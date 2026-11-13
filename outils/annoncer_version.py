#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Annonce les nouvelles versions de l'addon dans un salon Discord.

Lancé par GitHub (.github/workflows/annonce-discord.yml) à chaque push sur main qui touche le .toc :
compare la version du .toc avec celle du commit précédent, et envoie au webhook Discord un message
par nouvelle version, avec ses nouveautés tirées de GuildUp_Version.lua (tables ORDRE et NOTES).
Rien n'est envoyé si la version n'a pas changé, ni pour une version « -dev ».

Avant toute annonce, le dépôt est vérifié (--verifier pour ne faire que ça, avant de pousser) :
  - la version du .toc est la première de ORDRE et a ses NOTES ;
  - ORDRE ne monte que d'un cran à la fois (3.5.2 → 3.5.3, 3.6.0 ou 4.0.0, jamais 3.5.0 → 5.1.0) ;
  - la version ne redescend pas par rapport au commit précédent ;
  - chaque fichier .lua de GuildUpSMB/ est dans le .toc, et chaque fichier du .toc existe.
Au moindre problème, rien n'est envoyé et le script s'arrête en erreur (la tâche GitHub échoue).

L'adresse du webhook n'est jamais écrite dans le dépôt : elle vient de la variable d'environnement
DISCORD_WEBHOOK (secret du dépôt GitHub). Adresse Discord telle quelle, sans « /github » à la fin.

Utilisation :
  python outils/annoncer_version.py --avant <commit>    versions parues depuis ce commit (GitHub)
  python outils/annoncer_version.py --depuis 3.3.0      versions parues après la 3.3.0
  python outils/annoncer_version.py --version 3.4.0     cette version seulement
  python outils/annoncer_version.py --verifier          vérifier le dépôt, sans rien annoncer
  --essai   affiche les messages au lieu de les envoyer (aucun webhook nécessaire)
Python 3.6 ou plus, bibliothèque standard seulement.
"""

import argparse
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ADDON = "GuildUpSMB"
TOC = "GuildUpSMB/GuildUpSMB.toc"
NOTES = "GuildUpSMB/GuildUp_Version.lua"
NOM = "SMB Forever"
COULEUR = 0xFFD100      # le doré de l'addon
MAX_VERSIONS = 5        # au plus cinq messages par push (les plus récentes)
MAX_DESCRIPTION = 3800  # Discord refuse une description de plus de 4096 caractères


def lire(chemin):
	with open(os.path.join(RACINE, chemin), encoding="utf-8") as f:
		return f.read()


def version_du_toc(texte):
	m = re.search(r"^## Version:\s*(\S+)", texte, re.M)
	return m.group(1) if m else None


def cle(version):
	"""« 3.10.0 » → (3, 10, 0), pour comparer deux versions."""
	return tuple(int(n) for n in re.findall(r"\d+", version))


def version_avant(commit):
	"""Version du .toc dans un commit donné, ou None (premier push, commit inconnu)."""
	if not commit or set(commit) == {"0"}:
		return None
	try:
		texte = subprocess.check_output(["git", "-C", RACINE, "show", "{0}:{1}".format(commit, TOC)],
			stderr=subprocess.DEVNULL).decode("utf-8", "replace")
	except (OSError, subprocess.CalledProcessError):
		return None
	return version_du_toc(texte)


def lire_notes():
	"""(ordre, notes) : les versions de la plus récente à la plus ancienne, et leurs lignes."""
	texte = lire(NOTES)
	m = re.search(r"local ORDRE = \{(.*?)\}", texte, re.S)
	ordre = re.findall(r'"([^"]+)"', m.group(1)) if m else []
	notes = {}
	debut = texte.find("local NOTES = {")
	for bloc in re.finditer(r'^\t\["([^"]+)"\] = \{(.*?)^\t\},', texte[debut:], re.S | re.M):
		lignes = re.findall(r'"((?:[^"\\]|\\.)*)"', bloc.group(2))
		notes[bloc.group(1)] = [propre(l) for l in lignes]
	return ordre, notes


def propre(ligne):
	"""Texte du jeu → texte Discord : les passages colorés (|cffxxxxxx…|r) deviennent du gras."""
	ligne = ligne.replace('\\"', '"').replace("\\n", " ").replace("\\\\", "\\")
	ligne = re.sub(r"\|c[0-9a-fA-F]{8}(.*?)\|r", r"**\1**", ligne)
	ligne = re.sub(r"\|c[0-9a-fA-F]{8}|\|r", "", ligne)
	return ligne.replace("||", "|").strip()


def base(version):
	"""« 3.6.0-dev » → « 3.6.0 »."""
	return version.split("-")[0]


def triplet(version):
	"""« 3.6 » → (3, 6, 0) : majeur, mineur, correctif."""
	n = list(cle(base(version))) + [0, 0, 0]
	return tuple(n[:3])


def un_cran(ancienne, nouvelle):
	"""Vrai si « nouvelle » suit « ancienne » d'un seul cran semver : correctif, mineur ou majeur."""
	a, n = triplet(ancienne), triplet(nouvelle)
	return (n == (a[0], a[1], a[2] + 1)
		or n == (a[0], a[1] + 1, 0)
		or n == (a[0] + 1, 0, 0))


def fichiers_du_toc(texte):
	"""Les fichiers chargés par le .toc (lignes qui ne sont ni vides ni des commentaires « # »)."""
	return [l.strip() for l in texte.splitlines() if l.strip() and not l.strip().startswith("#")]


def verifier(precedente=None):
	"""Liste des problèmes du dépôt (vide si tout va bien). « precedente » : version du commit d'avant."""
	erreurs = []
	toc = lire(TOC)
	actuelle = version_du_toc(toc)
	ordre, notes = lire_notes()
	if not actuelle:
		return ["Version introuvable dans " + TOC + "."]
	if not ordre:
		return ["Table ORDRE introuvable dans " + NOTES + "."]

	if ordre[0] != base(actuelle):
		erreurs.append("La version du .toc ({0}) n'est pas la première de ORDRE dans {1} ({2}).".format(
			actuelle, NOTES, ordre[0]))
	if not notes.get(base(actuelle)):
		erreurs.append("Pas de NOTES pour la {0} dans {1}.".format(base(actuelle), NOTES))
	vues = set()
	for v in ordre:
		if v in vues:
			erreurs.append("La {0} apparaît deux fois dans ORDRE.".format(v))
		vues.add(v)
	for nouvelle, ancienne in zip(ordre, ordre[1:]):
		if not un_cran(ancienne, nouvelle):
			erreurs.append("ORDRE passe de la {0} à la {1} : une version ne monte que d'un cran "
				"(correctif, mineur ou majeur).".format(ancienne, nouvelle))
	if precedente:
		if cle(base(actuelle)) < cle(base(precedente)):
			erreurs.append("La version redescend : {0} au commit précédent, {1} maintenant.".format(
				precedente, actuelle))
		elif base(precedente) not in ordre:
			erreurs.append("La version du commit précédent ({0}) n'est pas dans ORDRE.".format(precedente))

	charges = fichiers_du_toc(toc)
	for f in charges:
		if not os.path.isfile(os.path.join(RACINE, ADDON, f)):
			erreurs.append("Le .toc charge {0}, qui n'existe pas.".format(f))
	for f in sorted(os.listdir(os.path.join(RACINE, ADDON))):
		if f.endswith(".lua") and f not in charges:
			erreurs.append("{0} n'est pas dans le .toc : le jeu ne le chargera pas.".format(f))
	return erreurs


def message(version, lignes):
	description = "\n".join("• " + l for l in lignes) if lignes else "Petites corrections."
	if len(description) > MAX_DESCRIPTION:
		description = description[:MAX_DESCRIPTION].rsplit("\n", 1)[0] + "\n…"
	return {
		"username": NOM,
		"allowed_mentions": {"parse": []},  # jamais de @everyone ni de mention, quoi que disent les notes
		"embeds": [{
			"title": "{0} {1}".format(NOM, version),
			"description": description,
			"color": COULEUR,
			"footer": {"text": "SMB Forever Updater l'installe tout seul. Sinon : /smb nouveautes en jeu."},
		}],
	}


def envoyer(webhook, corps):
	requete = urllib.request.Request(webhook, data=json.dumps(corps).encode("utf-8"), method="POST",
		headers={"Content-Type": "application/json", "User-Agent": "SMB-Forever-Annonce (github actions)"})
	with urllib.request.urlopen(requete, timeout=30) as reponse:
		return reponse.status


def principal():
	p = argparse.ArgumentParser(description="Annonce les nouvelles versions de l'addon sur Discord.")
	p.add_argument("--avant", help="commit précédent (github.event.before)")
	p.add_argument("--depuis", help="annoncer les versions parues après celle-ci")
	p.add_argument("--version", help="annoncer cette version seulement")
	p.add_argument("--essai", action="store_true", help="afficher au lieu d'envoyer")
	p.add_argument("--verifier", action="store_true", help="vérifier le dépôt seulement, sans rien annoncer")
	a = p.parse_args()

	actuelle = version_du_toc(lire(TOC))
	if not actuelle:
		print("Version introuvable dans " + TOC)
		return 1
	ordre, notes = lire_notes()
	precedente = None if a.version else (a.depuis or version_avant(a.avant))

	# jamais d'annonce d'un dépôt incohérent (version sautée ou redescendue, fichier oublié dans le .toc)
	erreurs = verifier(precedente)
	if erreurs:
		print("Vérification échouée, rien n'est annoncé :")
		for e in erreurs:
			print("  - " + e)
		return 1
	if a.verifier:
		print("Vérification réussie : version {0}, .toc et notes cohérents.".format(actuelle))
		return 0

	if a.version:
		versions = [a.version]
	else:
		if precedente and cle(precedente) >= cle(actuelle):
			print("Pas de nouvelle version ({0}) : rien à annoncer.".format(actuelle))
			return 0
		if precedente:
			# toutes les versions parues depuis, de la plus ancienne à la plus récente
			versions = [v for v in reversed(ordre) if cle(precedente) < cle(v) <= cle(actuelle)]
			if actuelle not in versions:
				versions.append(actuelle)
		else:
			versions = [actuelle]
	versions = [v for v in versions if "dev" not in v][-MAX_VERSIONS:]
	if not versions:
		print("Version de développement : rien à annoncer.")
		return 0

	webhook = os.environ.get("DISCORD_WEBHOOK", "").strip()
	if not a.essai and not webhook:
		print("Secret DISCORD_WEBHOOK absent : rien n'est envoyé (versions : {0}).".format(", ".join(versions)))
		return 0

	for v in versions:
		corps = message(v, notes.get(v, []))
		if a.essai:
			print(json.dumps(corps, ensure_ascii=False, indent=2))
			continue
		try:
			envoyer(webhook, corps)
			print("Version {0} annoncée.".format(v))
		except urllib.error.HTTPError as e:
			# (jamais l'adresse du webhook dans le journal)
			print("Discord a refusé l'annonce de la {0} : erreur {1}.".format(v, e.code))
			return 1
		except (urllib.error.URLError, OSError) as e:
			print("Discord injoignable pour la {0} : {1}.".format(v, getattr(e, "reason", e)))
			return 1
	return 0


if __name__ == "__main__":
	sys.exit(principal())
