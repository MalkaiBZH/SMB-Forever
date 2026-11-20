"""Régénère GuildUpSMB/GuildUp_Taux.lua : les taux de butin des monstres du bestiaire, lus par
GuildUp_Butin.lua et affichés dans la fiche du WoWdex (GuildUp_Wowdex.lua).

Données tirées de la base ForeverDB (GPL-3.0, merci à ses auteurs) : https://github.com/foreverfraddons/forever-db
Elle réunit et recoupe elle-même quatre bases ouvertes, qu'il faut créditer avec elle :
  * QuestieDB (GPL-3.0)                     la seule avec le contenu propre à WoW Forever
  * VMaNGOS (GPL-2.0-or-later)              taux de butin de référence pour le contenu 1.12
  * cMaNGOS classic-db (GPL)                idem, maintenue séparément
  * pfQuest (MIT)                           taux et positions supplémentaires
Quand les sources divergent, ForeverDB garde la valeur médiane de celles qui en donnent une ; une donnée propre
à Forever l'emporte ; un taux mesuré en jeu (20 ramassages ou plus) remplace celui de la base. Refaire cette
fusion ici n'aurait aucun intérêt : on prend son résultat.

Usage :
    python outils/generer_butin.py [--ref REF] [--verifier]

  --ref        branche, étiquette ou commit de forever-db à utiliser (défaut : main) ; les fichiers sont
               gardés dans outils/cache/foreverdb/<ref>/ (ignoré par git) et téléchargés s'ils manquent
  --verifier   n'écrit rien : compare le résultat au fichier actuel et affiche les différences

La table « drop » de ForeverDB est rangée par objet : drop[objet] = { pnj, chance, pnj, chance, … }, la chance
en dix-millièmes (10000 = 100 %, 0 = « lâché ici, taux inconnu »). On l'inverse, et on ne garde que les monstres
du bestiaire (GuildUp_Bestiaire.lua) : les autres ne sont jamais montrés par le WoWdex.

Ligne de ns.TAUX_BUTIN (tout en base 36, comme le reste de l'addon) :
    pnj|objet:chance,objet:chance,…
  les meilleures chances d'abord, MAX_BUTIN objets au plus ; chance 0 = lâché, taux inconnu.
"""
import os
import re
import sys
import urllib.request
from datetime import date

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SORTIE = os.path.join(RACINE, "GuildUpSMB", "GuildUp_Taux.lua")
BESTIAIRE = os.path.join(RACINE, "GuildUpSMB", "GuildUp_Bestiaire.lua")
URL = "https://raw.githubusercontent.com/foreverfraddons/forever-db/{ref}/ForeverDB/{fichier}"
FICHIERS = ("ForeverDB.lua", "ForeverDB_2.lua", "ForeverDB_3.lua", "ForeverDB_4.lua")

MAX_BUTIN = 20      # objets au plus par monstre (le WoWdex n'en montre jamais autant d'un coup)


def base36(n):
    chiffres = "0123456789abcdefghijklmnopqrstuvwxyz"
    s = ""
    while n:
        s = chiffres[n % 36] + s
        n //= 36
    return s or "0"


def fichiers(ref):
    dossier = os.path.join(RACINE, "outils", "cache", "foreverdb", ref.replace("/", "_"))
    os.makedirs(dossier, exist_ok=True)
    chemins = []
    for f in FICHIERS:
        chemin = os.path.join(dossier, f)
        if not os.path.exists(chemin):
            url = URL.format(ref=ref, fichier=f)
            print("téléchargement :", url)
            with urllib.request.urlopen(url) as r, open(chemin, "wb") as sortie:
                sortie.write(r.read())
        chemins.append(chemin)
    return chemins


def monstres_du_bestiaire():
    """Les numéros de PNJ du bestiaire : eux seuls ont une fiche dans le WoWdex."""
    texte = open(BESTIAIRE, encoding="utf-8").read()
    corps = texte.split("ns.BESTIAIRE = [==[", 1)[1].split("]==]", 1)[0]
    return set(int(l.split("|")[0]) for l in corps.strip().split("\n") if l[:1].isdigit())


def butin_par_pnj(chemins):
    """La table drop de ForeverDB, inversée : pnj -> { objet: chance }."""
    bloc = re.compile(r"local t = D\.drop\b(.*?)(?=;\(function\(\) local t = D\.|\nD\.|\Z)", re.S)
    entree = re.compile(r"^t\[(\d+)\]=\{([^}]*)\}", re.M)
    par_pnj = {}
    trouve = False
    for chemin in chemins:
        texte = open(chemin, encoding="utf-8", errors="replace").read()
        for b in bloc.finditer(texte):
            trouve = True
            for m in entree.finditer(b.group(1)):
                objet = int(m.group(1))
                valeurs = [int(x) for x in m.group(2).split(",") if x.strip().lstrip("-").isdigit()]
                for i in range(0, len(valeurs) - 1, 2):
                    par_pnj.setdefault(valeurs[i], {})[objet] = valeurs[i + 1]
    if not trouve:
        raise SystemExit("table « drop » introuvable : ForeverDB a-t-elle changé de format ?")
    return par_pnj


def construire(ref):
    par_pnj = butin_par_pnj(fichiers(ref))
    garder = monstres_du_bestiaire()
    lignes, sans_taux = [], 0
    for pnj in sorted(garder):
        objets = par_pnj.get(pnj)
        if not objets:
            continue
        # les meilleures chances d'abord ; les taux inconnus à la fin, par numéro d'objet
        tries = sorted(objets.items(), key=lambda kv: (-kv[1], kv[0]))[:MAX_BUTIN]
        sans_taux += sum(1 for _, c in tries if c <= 0)
        lignes.append("%s|%s" % (base36(pnj), ",".join("%s:%s" % (base36(o), base36(c)) for o, c in tries)))
    return lignes, len(garder), sans_taux


def contenu(ref, lignes):
    return ("-- GuildUpSMB : taux de butin des monstres du bestiaire, lus par GuildUp_Butin.lua et montrés dans la\n"
            "-- fiche du WoWdex (GuildUp_Wowdex.lua). Le taux mesuré par la guilde passe toujours avant celui-ci.\n"
            "-- FICHIER GÉNÉRÉ par outils/generer_butin.py : ne pas modifier à la main.\n"
            "-- Données tirées de la base ForeverDB (GPL-3.0, merci à ses auteurs), réf. %s, le %s :\n"
            "-- https://github.com/foreverfraddons/forever-db\n"
            "-- Elle-même réunit et recoupe QuestieDB (GPL-3.0), VMaNGOS (GPL-2.0-or-later), cMaNGOS classic-db\n"
            "-- (GPL) et pfQuest (MIT), plus des relevés en jeu : merci également à leurs auteurs.\n"
            "-- Ligne, tout en base 36 : pnj|objet:chance,objet:chance,…\n"
            "-- chance en dix-millièmes (10000 = 100 %%, 0 = lâché par ce monstre mais taux inconnu), les\n"
            "-- meilleures d'abord, 20 objets au plus.\n"
            "\n"
            "local NOM_ADDON, ns = ...\n"
            "\n"
            "ns.TAUX_BUTIN = [==[\n%s\n]==]\n") % (ref, date.today().isoformat(), "\n".join(lignes))


def main():
    args = sys.argv[1:]
    verifier = "--verifier" in args
    args = [a for a in args if a != "--verifier"]
    ref = "main"
    if "--ref" in args:
        ref = args[args.index("--ref") + 1]
    lignes, total, sans_taux = construire(ref)
    print("%d monstres du bestiaire sur %d ont un butin connu, %d entrée(s) sans taux"
          % (len(lignes), total, sans_taux))
    if verifier:
        if not os.path.exists(SORTIE):
            print("pas de fichier actuel")
            return
        actuelles = [l for l in open(SORTIE, encoding="utf-8").read().split("\n") if "|" in l and l[:1] != "-"]
        ajoutees = set(lignes) - set(actuelles)
        retirees = set(actuelles) - set(lignes)
        print("%d ligne(s) ajoutée(s), %d retirée(s)" % (len(ajoutees), len(retirees)))
        for l in sorted(ajoutees)[:20]:
            print("  +", l[:100])
        for l in sorted(retirees)[:20]:
            print("  -", l[:100])
        return
    with open(SORTIE, "w", encoding="utf-8") as f:
        f.write(contenu(ref, lignes))
    print("écrit :", SORTIE)


if __name__ == "__main__":
    main()
