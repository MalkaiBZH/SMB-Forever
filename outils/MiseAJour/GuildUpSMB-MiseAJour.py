#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# SMB Forever Updater pour Linux : mise à jour automatique de l'addon GuildUpSMB depuis GitHub.
#
# Même travail que GuildUpSMB-MiseAJour.exe (Windows), à la façon Linux : pas d'icône de zone de
# notification, mais un minuteur systemd de l'utilisateur qui lance un passage toutes les 15 minutes
# (5 à 60, réglable) et à l'ouverture de session. Python 3.6 ou plus, sans autre dépendance.
#
#   * WoW Forever tourne sous Wine ou Proton (Lutris, Bottles, Steam, Heroic, Faugus, ~/.wine…) :
#     le dossier _forever_ est cherché dans les préfixes Wine connus, dans leur registre (clé
#     InstallPath de Blizzard, comme sous Windows) et sur leurs lecteurs (dosdevices) ;
#   * un passage demande à l'API GitHub l'empreinte du dernier commit de main (requête conditionnelle :
#     l'ETag est gardé entre deux passages, une réponse 304 ne compte pas dans la limite de 60 par
#     heure). Si elle diffère de celle notée dans Interface/AddOns/GuildUpSMB/.miseajour, télécharge
#     l'archive de ce commit, en extrait GuildUpSMB/ (sans *.bak ni *.previous) et synchronise ;
#   * notification du bureau ensuite (notify-send) : /reload, relancer le jeu si des fichiers sont
#     ajoutés ou si le .toc change, ou rien si le jeu est fermé. Un commit qui ne touche pas à
#     l'addon (README, outils) ne dérange personne ;
#   * le programme installé se remplace lui-même quand ce fichier change dans le dépôt (pas de release
#     à publier pour Linux).
#
# Utilisation :
#   python3 GuildUpSMB-MiseAJour.py --installer   installe le programme dans ~/.local/bin, le minuteur
#                                                 systemd, et fait un premier passage
#   smb-forever-maj                 un passage, avec le détail (le dossier du jeu est demandé s'il le faut)
#   smb-forever-maj --etat          dossier du jeu, version installée, minuteur
#   smb-forever-maj --jeu DOSSIER   indique (et enregistre) le dossier _forever_ du jeu
#   smb-forever-maj --intervalle N  vérifie toutes les N minutes (5, 15, 30 ou 60)
#   smb-forever-maj --desinstaller  retire le minuteur et le programme (l'addon reste installé)
#   smb-forever-maj --auto          passage lancé par le minuteur : silencieux, notifications
# Variable d'environnement GUILDUPSMB_JETON : jeton GitHub facultatif (dépôt privé, essais).
#
# Réglages, état et journal du dernier passage : ~/.config/GuildUpSMB-MiseAJour/
# (reglages.ini, journal.txt).

import argparse
import errno
import glob
import hashlib
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request
import zipfile

VERSION = "1.0.0"
DEPOT = "MalkaiBZH/SMB-Forever"
BRANCHE = "main"
ADDON = "GuildUpSMB"
SOI = "outils/MiseAJour/GuildUpSMB-MiseAJour.py"	# ce programme dans le dépôt (mise à jour de lui-même)
MARQUE = ".miseajour"		# empreinte du commit installé, dans le dossier de l'addon
NOM = "smb-forever-maj"		# programme installé et unités systemd
TITRE = "SMB Forever Updater"
INTERVALLES = (5, 15, 30, 60)	# minutes
INTERVALLE_DEFAUT = 15

ACCUEIL = os.path.expanduser("~")
DOSSIER_REGLAGES = os.path.join(os.environ.get("XDG_CONFIG_HOME") or os.path.join(ACCUEIL, ".config"),
	"GuildUpSMB-MiseAJour")
FICHIER_REGLAGES = os.path.join(DOSSIER_REGLAGES, "reglages.ini")
FICHIER_JOURNAL = os.path.join(DOSSIER_REGLAGES, "journal.txt")
FICHIER_VERROU = os.path.join(DOSSIER_REGLAGES, "verrou")
PROGRAMME = os.path.join(ACCUEIL, ".local", "bin", NOM)
DOSSIER_SYSTEMD = os.path.join(os.environ.get("XDG_CONFIG_HOME") or os.path.join(ACCUEIL, ".config"),
	"systemd", "user")


class Erreur(Exception):
	"""Erreur expliquée au joueur (sans pile d'appels)."""


class Bilan(object):
	def __init__(self):
		self.deja_a_jour = False
		self.version = "?"
		self.commit = ""
		self.ajoutes = self.modifies = self.supprimes = 0
		self.toc_modifie = False

	@property
	def change(self):
		return self.ajoutes + self.modifies + self.supprimes > 0

	# Le jeu ne voit les nouveaux fichiers (et un .toc changé) qu'à son démarrage.
	@property
	def relancer_jeu(self):
		return self.ajoutes > 0 or self.toc_modifie


# ---------------------------------------------------------------- Réglages

def lire_reglage(nom):
	try:
		with open(FICHIER_REGLAGES, encoding="utf-8") as f:
			for ligne in f:
				cle, egal, valeur = ligne.partition("=")
				if egal and cle.strip() == nom:
					return valeur.strip()
	except OSError:
		pass
	return None


def ecrire_reglage(nom, valeur):
	lignes = []
	try:
		with open(FICHIER_REGLAGES, encoding="utf-8") as f:
			lignes = [l.rstrip("\n") for l in f if l.partition("=")[0].strip() != nom]
	except OSError:
		pass
	if valeur is not None:
		lignes.append(nom + "=" + valeur)
	os.makedirs(DOSSIER_REGLAGES, exist_ok=True)
	with open(FICHIER_REGLAGES, "w", encoding="utf-8") as f:
		f.write("\n".join(lignes) + ("\n" if lignes else ""))


def intervalle():
	try:
		m = int(lire_reglage("intervalle") or "")
		if m in INTERVALLES:
			return m
	except ValueError:
		pass
	return INTERVALLE_DEFAUT


# ---------------------------------------------------------------- Dossier du jeu

def entree_insensible(parent, nom):
	"""Chemin de « nom » dans « parent » sans tenir compte de la casse (Wine ne la distingue pas)."""
	exact = os.path.join(parent, nom)
	if os.path.exists(exact):
		return exact
	try:
		bas = nom.lower()
		for e in os.listdir(parent):
			if e.lower() == bas:
				return os.path.join(parent, e)
	except OSError:
		pass
	return None


def chemin_insensible(base, *parties):
	chemin = base
	for p in parties:
		for morceau in p.replace("\\", "/").split("/"):
			if not morceau:
				continue
			chemin = entree_insensible(chemin, morceau)
			if chemin is None:
				return None
	return chemin


def jeu_valable(dossier):
	"""Un dossier de jeu valable contient Wow.exe (client Forever)."""
	return bool(dossier) and os.path.isdir(dossier) and entree_insensible(dossier, "Wow.exe") is not None


def prefixes_wine():
	"""Préfixes Wine / Proton probables (dossiers qui contiennent drive_c)."""
	h = ACCUEIL
	motifs = [
		os.environ.get("WINEPREFIX") or "",
		h + "/.wine",
		h + "/.wine*",
		h + "/Games/*",
		h + "/Games/Heroic/Prefixes/*",
		h + "/Games/Heroic/Prefixes/default/*",
		h + "/.local/share/wineprefixes/*",
		h + "/.local/share/bottles/bottles/*",
		h + "/.var/app/com.usebottles.bottles/data/bottles/bottles/*",
		h + "/.PlayOnLinux/wineprefix/*",
		h + "/Faugus/*",
		h + "/.cxoffice/*",
	]
	# Steam (Proton) : chaque bibliothèque a ses préfixes dans steamapps/compatdata/<id>/pfx.
	bibliotheques = set()
	for steam in (h + "/.steam/steam", h + "/.local/share/Steam",
			h + "/.var/app/com.valvesoftware.Steam/.local/share/Steam"):
		bibliotheques.add(steam)
		try:
			with open(os.path.join(steam, "steamapps", "libraryfolders.vdf"), encoding="utf-8", errors="replace") as f:
				for m in re.finditer(r'"path"\s+"([^"]+)"', f.read()):
					bibliotheques.add(m.group(1).replace("\\\\", "\\"))
		except OSError:
			pass
	for b in bibliotheques:
		motifs.append(b + "/steamapps/compatdata/*/pfx")
	# Lutris note le préfixe de chaque jeu dans sa configuration.
	for config in (h + "/.config/lutris/games/*.yml", h + "/.local/share/lutris/games/*.yml",
			h + "/.var/app/net.lutris.Lutris/config/lutris/games/*.yml",
			h + "/.var/app/net.lutris.Lutris/data/lutris/games/*.yml"):
		for fichier in glob.glob(config):
			try:
				with open(fichier, encoding="utf-8", errors="replace") as f:
					for m in re.finditer(r"^\s*prefix:\s*['\"]?([^'\"\n]+?)['\"]?\s*$", f.read(), re.M):
						motifs.append(os.path.expanduser(m.group(1)))
			except OSError:
				pass

	vus, prefixes = set(), []
	for motif in motifs:
		if not motif:
			continue
		for p in glob.glob(motif):
			p = os.path.realpath(p)
			if p not in vus and os.path.isdir(os.path.join(p, "drive_c")):
				vus.add(p)
				prefixes.append(p)
	return prefixes


def lecteurs(prefixe):
	"""Racines Linux des lecteurs du préfixe : {"c": …/drive_c, "d": /mnt/jeux…}."""
	r = {"c": os.path.join(prefixe, "drive_c")}
	try:
		for e in os.listdir(os.path.join(prefixe, "dosdevices")):
			if len(e) == 2 and e[1] == ":" and e[0].isalpha():
				cible = os.path.realpath(os.path.join(prefixe, "dosdevices", e))
				if os.path.isdir(cible) and cible != "/":
					r.setdefault(e[0].lower(), cible)
	except OSError:
		pass
	return r


def chemin_windows(prefixe, chemin):
	"""« C:\\Program Files (x86)\\World of Warcraft\\_retail_\\ » → chemin Linux dans le préfixe."""
	m = re.match(r"^([A-Za-z]):[\\/]*(.*)$", chemin.strip())
	if not m:
		return None
	racine = lecteurs(prefixe).get(m.group(1).lower())
	return racine and chemin_insensible(racine, m.group(2).rstrip("\\/"))


def installations_registre(prefixe):
	"""InstallPath noté par le lanceur Blizzard dans le registre du préfixe (system.reg)."""
	trouves = []
	try:
		with open(os.path.join(prefixe, "system.reg"), encoding="utf-8", errors="replace") as f:
			section = ""
			for ligne in f:
				if ligne.startswith("["):
					section = ligne.lower()
				elif "blizzard entertainment" in section and "world of warcraft" in section \
						and ligne.lower().startswith('"installpath"='):
					valeur = ligne.split("=", 1)[1].strip().strip('"').replace("\\\\", "\\")
					trouves.append(valeur)
	except OSError:
		pass
	return trouves


def trouver_jeu(fouiller=False):
	"""Le réglage enregistré d'abord (quel que soit le nom du dossier), puis un vrai _forever_."""
	enregistre = lire_reglage("jeu")
	if jeu_valable(enregistre):
		return enregistre

	candidats = []
	for p in prefixes_wine():
		for chemin in installations_registre(p):
			lin = chemin_windows(p, chemin)
			if lin:
				candidats.append(lin)
				candidats.append(os.path.join(os.path.dirname(lin.rstrip("/")), "_forever_"))
		for racine in lecteurs(p).values():
			for sous in ("Program Files (x86)/World of Warcraft/_forever_", "Program Files/World of Warcraft/_forever_",
					"World of Warcraft/_forever_", "Games/World of Warcraft/_forever_", "Jeux/World of Warcraft/_forever_"):
				candidats.append(chemin_insensible(racine, sous))
	for c in candidats:
		if c and os.path.basename(c.rstrip("/")) == "_forever_" and jeu_valable(c):
			return os.path.realpath(c)
	return fouiller_disques() if fouiller else None


def fouiller_disques(profondeur_max=7, limite=150000):
	"""Dernier recours : un dossier _forever_ avec Wow.exe dans le dossier personnel ou les disques montés."""
	racines = [ACCUEIL]
	utilisateur = os.path.basename(ACCUEIL)
	for r in ("/mnt", "/media/" + utilisateur, "/run/media/" + utilisateur, "/media"):
		if os.path.isdir(r):
			racines.append(r)
	vus = 0
	for racine in racines:
		base = racine.rstrip("/").count("/")
		for dossier, sous, fichiers in os.walk(racine, followlinks=False):
			vus += 1
			if vus > limite:
				return None
			if os.path.basename(dossier) == "_forever_" and any(f.lower() == "wow.exe" for f in fichiers):
				return dossier
			if dossier.count("/") - base >= profondeur_max:
				sous[:] = []
			else:
				# Le dossier des préfixes Wine est caché (.wine, .local…), le reste des dossiers cachés non.
				sous[:] = [s for s in sous if not s.startswith(".") or s in (".wine", ".local", ".var", ".steam")
					or dossier.endswith("/.local/share") or "/.var/app" in dossier]
	return None


def dossier_addon(jeu):
	interface = entree_insensible(jeu, "Interface") or os.path.join(jeu, "Interface")
	addons = entree_insensible(interface, "AddOns") or os.path.join(interface, "AddOns")
	return os.path.join(addons, ADDON)


def lire_version(dossier):
	"""« ## Version: 1.6.0 » dans le .toc."""
	try:
		with open(os.path.join(dossier, ADDON + ".toc"), encoding="utf-8-sig", errors="replace") as f:
			for ligne in f:
				l = ligne.strip()
				if l.lower().startswith("## version:"):
					return l[11:].strip()
	except OSError:
		pass
	return "?"


def jeu_lance(jeu):
	"""Wow.exe tourne-t-il ? Sous Wine, la ligne de commande garde le chemin Windows du jeu."""
	nom = os.path.basename(os.path.realpath(jeu)).lower()
	for pid in os.listdir("/proc") if os.path.isdir("/proc") else []:
		if not pid.isdigit():
			continue
		try:
			with open("/proc/" + pid + "/cmdline", "rb") as f:
				ligne = f.read().replace(b"\0", b" ").decode("utf-8", "replace").lower().replace("\\", "/")
		except OSError:
			continue
		if "/wow.exe" in ligne and ("/" + nom + "/") in ligne:
			return True
	return False


# ---------------------------------------------------------------- Réseau

def requete(url, accept, etag=None):
	r = urllib.request.Request(url)
	r.add_header("User-Agent", "GuildUpSMB-MiseAJour")
	r.add_header("Accept", accept)
	if etag:
		r.add_header("If-None-Match", etag)
	jeton = (os.environ.get("GUILDUPSMB_JETON") or "").strip()
	if jeton:
		r.add_header("Authorization", "Bearer " + jeton)
	return r


def message_reseau(e):
	if isinstance(e, urllib.error.HTTPError):
		if e.code == 404:
			return "dépôt " + DEPOT + " introuvable sur GitHub (est-il public ?)."
		if e.code in (403, 429):
			return "GitHub limite les requêtes (60 par heure) : nouvel essai plus tard."
		return "GitHub répond {0} ({1}).".format(e.code, e.reason)
	return "connexion à GitHub impossible ({0}).".format(getattr(e, "reason", e))


def dernier_commit():
	"""Empreinte du dernier commit de la branche. Requête conditionnelle : un 304 rend l'empreinte connue."""
	etag, connu = lire_reglage("etag"), lire_reglage("commit")
	url = "https://api.github.com/repos/{0}/commits/{1}".format(DEPOT, BRANCHE)
	try:
		with urllib.request.urlopen(requete(url, "application/vnd.github.sha", etag if connu else None), timeout=30) as r:
			commit = r.read().decode("ascii", "replace").strip()
			if not re.match(r"^[0-9a-fA-F]{7,64}$", commit):
				raise Erreur("réponse inattendue de GitHub.")
			ecrire_reglage("etag", r.headers.get("ETag"))
			ecrire_reglage("commit", commit)
			return commit
	except urllib.error.HTTPError as e:
		if e.code == 304 and connu:
			return connu
		raise Erreur(message_reseau(e))
	except (urllib.error.URLError, OSError) as e:
		raise Erreur(message_reseau(e))


def telecharger(url, fichier):
	try:
		with urllib.request.urlopen(requete(url, "application/vnd.github+json"), timeout=120) as r, \
				open(fichier, "wb") as sortie:
			shutil.copyfileobj(r, sortie)
	except urllib.error.HTTPError as e:
		raise Erreur(message_reseau(e))
	except (urllib.error.URLError, OSError) as e:
		raise Erreur(message_reseau(e))


# ---------------------------------------------------------------- Mise à jour

def ignore(chemin):
	"""Fichiers de travail des bannières, jamais installés."""
	bas = chemin.lower()
	return bas.endswith(".bak") or bas.endswith(".previous")


def extraire(archive, destination, programme=None):
	"""Garde uniquement le dossier GuildUpSMB/ de l'archive (dont la racine est « depot-commit/ »),
	et ce programme dans « programme » si on le demande."""
	racine = os.path.realpath(destination) + os.sep
	with zipfile.ZipFile(archive) as z:
		for info in z.infolist():
			chemin = info.filename.replace("\\", "/")
			if "/" not in chemin:
				continue
			chemin = chemin.split("/", 1)[1]
			if programme and chemin == SOI:
				with z.open(info) as entree, open(programme, "wb") as sortie:
					shutil.copyfileobj(entree, sortie)
				continue
			if not chemin.startswith(ADDON + "/"):
				continue
			chemin = chemin[len(ADDON) + 1:]
			if not chemin or chemin.endswith("/") or ignore(chemin):
				continue
			cible = os.path.realpath(os.path.join(destination, chemin))
			if not cible.startswith(racine):
				continue	# chemin hors du dossier
			os.makedirs(os.path.dirname(cible), exist_ok=True)
			with z.open(info) as entree, open(cible, "wb") as sortie:
				shutil.copyfileobj(entree, sortie)


def empreinte(fichier):
	h = hashlib.sha256()
	with open(fichier, "rb") as f:
		for bloc in iter(lambda: f.read(65536), b""):
			h.update(bloc)
	return h.digest()


def identiques(a, b):
	return os.path.getsize(a) == os.path.getsize(b) and empreinte(a) == empreinte(b)


def fichiers(dossier):
	r = []
	for d, _, noms in os.walk(dossier):
		for n in noms:
			r.append(os.path.relpath(os.path.join(d, n), dossier))
	return r


def synchroniser(source, cible, bilan, noter):
	attendus = set()
	for relatif in sorted(fichiers(source)):
		attendus.add(relatif)
		origine, destination = os.path.join(source, relatif), os.path.join(cible, relatif)
		if os.path.isfile(destination):
			if identiques(origine, destination):
				continue
			bilan.modifies += 1
			if relatif.lower() == (ADDON + ".toc").lower():
				bilan.toc_modifie = True
			noter("  modifié : " + relatif)
		else:
			bilan.ajoutes += 1
			noter("  ajouté : " + relatif)
		os.makedirs(os.path.dirname(destination), exist_ok=True)
		shutil.copyfile(origine, destination)

	for relatif in sorted(fichiers(cible)):
		if relatif in attendus or relatif == MARQUE:
			continue
		os.remove(os.path.join(cible, relatif))
		bilan.supprimes += 1
		noter("  supprimé : " + relatif)

	# Dossiers devenus vides, du plus profond au moins profond.
	for d, _, _ in sorted(os.walk(cible), key=lambda t: -len(t[0])):
		if d != cible and not os.listdir(d):
			try:
				os.rmdir(d)
			except OSError:
				pass


def executer(jeu, noter):
	bilan = Bilan()
	addon = dossier_addon(jeu)
	marque = os.path.join(addon, MARQUE)

	commit = dernier_commit()
	bilan.commit = commit
	try:
		with open(marque, encoding="utf-8") as f:
			installe = f.read().strip()
	except OSError:
		installe = ""
	if installe == commit and os.path.isfile(os.path.join(addon, ADDON + ".toc")):
		bilan.deja_a_jour = True
		bilan.version = lire_version(addon)
		noter("Déjà à jour (version {0}, commit {1}).".format(bilan.version, commit[:7]))
		return bilan

	temp = tempfile.mkdtemp(prefix="GuildUpSMB-MiseAJour-")
	try:
		noter("Nouveau commit sur GitHub : téléchargement de " + commit[:7] + "…")
		archive = os.path.join(temp, "addon.zip")
		telecharger("https://api.github.com/repos/{0}/zipball/{1}".format(DEPOT, commit), archive)
		source = os.path.join(temp, ADDON)
		nouveau = os.path.join(temp, NOM)
		try:
			extraire(archive, source, nouveau)
		except zipfile.BadZipFile:
			raise Erreur("archive reçue de GitHub illisible.")
		if not os.path.isfile(os.path.join(source, ADDON + ".toc")):
			raise Erreur("l'archive ne contient pas " + ADDON + "/" + ADDON + ".toc.")
		bilan.version = lire_version(source)

		noter("Installation de la version {0} dans {1}".format(bilan.version, addon))
		try:
			os.makedirs(addon, exist_ok=True)
			synchroniser(source, addon, bilan, noter)
			with open(marque, "w", encoding="utf-8") as f:
				f.write(commit)
		except OSError as e:
			raise Erreur("fichier de l'addon inaccessible ({0}).".format(e))
		mettre_a_jour_programme(nouveau, noter)
	finally:
		shutil.rmtree(temp, ignore_errors=True)

	noter("Terminé : {0} ajouté(s), {1} modifié(s), {2} supprimé(s).".format(
		bilan.ajoutes, bilan.modifies, bilan.supprimes))
	return bilan


def mettre_a_jour_programme(nouveau, noter):
	"""Le programme installé (~/.local/bin) suit celui du dépôt : remplacé s'il a changé."""
	if not os.path.isfile(nouveau) or not os.path.isfile(PROGRAMME) or identiques(nouveau, PROGRAMME):
		return
	try:
		with open(nouveau, encoding="utf-8") as f:
			compile(f.read(), NOM, "exec")	# jamais un fichier tronqué ou illisible à la place du programme
		os.chmod(nouveau, 0o755)
		os.replace(nouveau, PROGRAMME)
		noter("Programme de mise à jour remplacé par celui du dépôt.")
	except (OSError, SyntaxError, ValueError) as e:
		noter("Programme de mise à jour non remplacé ({0}).".format(e))


def conseil(bilan, jeu):
	"""Que faire pour charger la nouvelle version ?"""
	if not jeu_lance(jeu):
		return "Elle sera chargée au prochain lancement du jeu."
	if bilan.relancer_jeu:
		return "Relancez le jeu : de nouveaux fichiers ont été ajoutés, /reload ne suffit pas."
	return "Tapez /reload en jeu pour la charger."


# ---------------------------------------------------------------- Notifications et verrou

def notifier(titre, texte, urgence="normal"):
	"""Notification du bureau (libnotify). Depuis systemd, le bus de session est à retrouver."""
	env = dict(os.environ)
	if not env.get("DBUS_SESSION_BUS_ADDRESS"):
		bus = "/run/user/{0}/bus".format(os.getuid())
		if os.path.exists(bus):
			env["DBUS_SESSION_BUS_ADDRESS"] = "unix:path=" + bus
	try:
		subprocess.call(["notify-send", "-a", TITRE, "-u", urgence, "-i", "system-software-update", titre, texte],
			env=env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=15)
	except (OSError, subprocess.SubprocessError):
		pass


def verrouiller():
	"""Un seul passage à la fois (minuteur et lancement à la main). Rend le fichier ouvert, ou None."""
	import fcntl
	os.makedirs(DOSSIER_REGLAGES, exist_ok=True)
	f = open(FICHIER_VERROU, "w")
	try:
		fcntl.flock(f, fcntl.LOCK_EX | fcntl.LOCK_NB)
		return f
	except OSError as e:
		f.close()
		if e.errno in (errno.EAGAIN, errno.EACCES):
			return None
		raise


def ecrire_journal(texte):
	try:
		os.makedirs(DOSSIER_REGLAGES, exist_ok=True)
		with open(FICHIER_JOURNAL, "w", encoding="utf-8") as f:
			f.write(time.strftime("%Y-%m-%d %H:%M:%S") + "\n" + texte)
	except OSError:
		pass


# ---------------------------------------------------------------- Passages

def demander_jeu():
	"""Demande le dossier du jeu dans le terminal (si on en a un). Rend le dossier, ou None."""
	if not sys.stdin.isatty():
		return None
	print("Dossier _forever_ de WoW Forever introuvable.")
	print("Indiquez celui qui contient Wow.exe, par exemple :")
	print("  ~/Games/battlenet/drive_c/Program Files (x86)/World of Warcraft/_forever_")
	while True:
		try:
			saisie = input("Dossier (vide pour abandonner) : ").strip().strip("'\"")
		except EOFError:
			return None
		if not saisie:
			return None
		dossier = os.path.realpath(os.path.expanduser(saisie))
		if jeu_valable(dossier):
			return dossier
		print("Ce dossier ne contient pas Wow.exe.")


def passage(auto):
	"""Un passage complet. Code de sortie : 0 = ok, 1 = erreur, 2 = dossier du jeu inconnu, 3 = déjà en cours."""
	verrou = verrouiller()
	if verrou is None:
		if not auto:
			print("Une vérification est déjà en cours.")
		return 3
	lignes = []

	def noter(t):
		ligne = time.strftime("%H:%M") + "  " + t
		lignes.append(ligne)
		if not auto:
			print(ligne)

	try:
		jeu = trouver_jeu(fouiller=not auto)
		if jeu is None and not auto:
			jeu = demander_jeu()
		if jeu is None:
			noter("Dossier du jeu introuvable : smb-forever-maj --jeu <dossier _forever_>.")
			# Au plus une notification par jour pour ce souci.
			if auto and time.time() - float(lire_reglage("alerte_jeu") or 0) > 86400:
				ecrire_reglage("alerte_jeu", str(int(time.time())))
				notifier("Dossier de WoW Forever introuvable",
					"Indiquez-le dans un terminal : smb-forever-maj --jeu <dossier _forever_>", "critical")
			return 2
		if lire_reglage("jeu") != jeu:
			ecrire_reglage("jeu", jeu)
			noter("Dossier du jeu : " + jeu)

		# Au démarrage de la session, le réseau peut tarder : quelques essais rapprochés.
		essais = 3 if auto else 1
		for n in range(essais):
			try:
				bilan = executer(jeu, noter)
				break
			except Erreur as e:
				if n == essais - 1 or "limite" in str(e):
					raise
				time.sleep(60)

		if bilan.deja_a_jour:
			return 0
		if not bilan.change:
			noter("Rien à changer dans l'addon (commit sans effet sur le jeu).")
			return 0
		texte = conseil(bilan, jeu)
		noter(texte)
		if auto:
			notifier("SMB Forever " + bilan.version + " installé", texte)
		return 0
	except Erreur as e:
		noter("Erreur : " + str(e))
		return 1
	except OSError as e:
		noter("Erreur : " + str(e))
		return 1
	finally:
		ecrire_journal("\n".join(lignes) + "\n")
		verrou.close()


# ---------------------------------------------------------------- Installation (systemd)

def systemctl(*args):
	try:
		return subprocess.call(["systemctl", "--user"] + list(args),
			stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 0
	except OSError:
		return False


def ecrire_minuteur(minutes):
	os.makedirs(DOSSIER_SYSTEMD, exist_ok=True)
	with open(os.path.join(DOSSIER_SYSTEMD, NOM + ".service"), "w", encoding="utf-8") as f:
		f.write("[Unit]\n"
			"Description=" + TITRE + " : mise à jour de l'addon SMB Forever\n"
			"Wants=network-online.target\nAfter=network-online.target\n\n"
			"[Service]\nType=oneshot\n"
			"ExecStart=/usr/bin/env python3 %h/.local/bin/" + NOM + " --auto\n")
	with open(os.path.join(DOSSIER_SYSTEMD, NOM + ".timer"), "w", encoding="utf-8") as f:
		f.write("[Unit]\nDescription=" + TITRE + " : vérification toutes les {0} minutes\n\n"
			"[Timer]\nOnStartupSec=1min\nOnUnitActiveSec={0}min\nRandomizedDelaySec=30s\n\n"
			"[Install]\nWantedBy=timers.target\n".format(minutes))


def installer():
	if sys.platform != "linux":
		print("Ce programme est fait pour Linux. Sous Windows : GuildUpSMB-MiseAJour.exe.")
		return 1
	ici = os.path.realpath(__file__)
	os.makedirs(os.path.dirname(PROGRAMME), exist_ok=True)
	if ici != os.path.realpath(PROGRAMME):
		shutil.copyfile(ici, PROGRAMME)
	os.chmod(PROGRAMME, 0o755)
	print("Programme installé : " + PROGRAMME)

	minuteur = False
	if shutil.which("systemctl") and systemctl("show-environment"):
		ecrire_minuteur(intervalle())
		systemctl("daemon-reload")
		minuteur = systemctl("enable", "--now", NOM + ".timer")
	if minuteur:
		print("Minuteur systemd activé : vérification à l'ouverture de session puis toutes les {0} minutes."
			.format(intervalle()))
	else:
		print("systemd (session utilisateur) indisponible : ajoutez cette ligne avec « crontab -e » :")
		print("  */{0} * * * * {1} --auto".format(intervalle(), PROGRAMME))
	if not shutil.which("notify-send"):
		print("notify-send introuvable : pas de notification après une mise à jour (paquet libnotify-bin ou libnotify).")
	if os.path.dirname(PROGRAMME) not in os.environ.get("PATH", "").split(os.pathsep):
		print("~/.local/bin n'est pas dans le PATH : lancez le programme par son chemin complet.")
	print()
	return passage(False)


def desinstaller():
	systemctl("disable", "--now", NOM + ".timer")
	for f in (NOM + ".service", NOM + ".timer"):
		try:
			os.remove(os.path.join(DOSSIER_SYSTEMD, f))
		except OSError:
			pass
	systemctl("daemon-reload")
	try:
		os.remove(PROGRAMME)
	except OSError:
		pass
	print("Minuteur et programme retirés. L'addon reste installé ; réglages dans " + DOSSIER_REGLAGES + ".")
	return 0


def changer_intervalle(minutes):
	if minutes not in INTERVALLES:
		print("Intervalle possible : " + ", ".join(str(m) for m in INTERVALLES) + " minutes.")
		return 1
	ecrire_reglage("intervalle", str(minutes))
	if os.path.exists(os.path.join(DOSSIER_SYSTEMD, NOM + ".timer")):
		ecrire_minuteur(minutes)
		systemctl("daemon-reload")
		systemctl("restart", NOM + ".timer")
	print("Vérification toutes les {0} minutes.".format(minutes))
	return 0


def etat():
	jeu = trouver_jeu()
	print(TITRE + " " + VERSION)
	print("Dossier du jeu : " + (jeu or "introuvable (smb-forever-maj --jeu <dossier>)"))
	if jeu:
		addon = dossier_addon(jeu)
		try:
			with open(os.path.join(addon, MARQUE), encoding="utf-8") as f:
				commit = f.read().strip()[:7]
		except OSError:
			commit = "?"
		print("Addon : version {0} (commit {1})".format(lire_version(addon), commit))
	actif = systemctl("is-active", "--quiet", NOM + ".timer")
	print("Minuteur : " + ("actif, toutes les {0} minutes".format(intervalle()) if actif else "inactif (--installer)"))
	try:
		with open(FICHIER_JOURNAL, encoding="utf-8") as f:
			print("\nDernier passage, " + f.read().rstrip())
	except OSError:
		pass
	return 0


def principal():
	p = argparse.ArgumentParser(prog=NOM, description=TITRE + " : mise à jour automatique de l'addon SMB Forever (WoW Forever sous Wine/Proton).")
	p.add_argument("--installer", action="store_true", help="installe le programme et le minuteur systemd, puis fait un passage")
	p.add_argument("--desinstaller", action="store_true", help="retire le minuteur et le programme (l'addon reste)")
	p.add_argument("--etat", action="store_true", help="dossier du jeu, version installée, minuteur")
	p.add_argument("--jeu", metavar="DOSSIER", help="dossier _forever_ du jeu (celui qui contient Wow.exe), enregistré")
	p.add_argument("--intervalle", type=int, metavar="MINUTES", help="vérifier toutes les 5, 15, 30 ou 60 minutes")
	p.add_argument("--auto", action="store_true", help="passage du minuteur : silencieux, notifications")
	p.add_argument("--version", action="version", version=TITRE + " " + VERSION)
	a = p.parse_args()

	if a.jeu:
		dossier = os.path.realpath(os.path.expanduser(a.jeu))
		if not jeu_valable(dossier):
			print("Ce dossier ne contient pas Wow.exe : " + dossier)
			return 1
		ecrire_reglage("jeu", dossier)
		print("Dossier du jeu : " + dossier)
	if a.intervalle is not None:
		r = changer_intervalle(a.intervalle)
		if r:
			return r
	if a.desinstaller:
		return desinstaller()
	if a.installer:
		return installer()
	if a.etat:
		return etat()
	if a.intervalle is not None and not a.jeu and not a.auto:
		return 0
	return passage(a.auto)


if __name__ == "__main__":
	try:
		sys.exit(principal())
	except KeyboardInterrupt:
		sys.exit(130)
