"""Régénère GuildUpSMB/GuildUp_Bestiaire.lua : le bestiaire du WoWdex (GuildUp_Wowdex.lua), tous les monstres
hostiles de WoW Forever placés dans le monde, avec leur niveau, leur rang, leurs lieux d'apparition et leur butin
particulier. Données tirées de la base QuestieDB (version Forever, GPL-3.0, merci à ses auteurs) :
https://github.com/Questie/QuestieDB (data/Forever/foreverNpcDB.lua et foreverItemDB.lua, noms français dans
l10n/Forever/lookupNpcs/frFR.lua). Noms des zones : ns.SOURCES_ZONES de GuildUpSMB/GuildUp_Sources.lua.

Usage :
    python outils/generer_bestiaire.py [--ref REF] [--verifier]

  --ref        branche, étiquette ou commit de QuestieDB à utiliser (défaut : HEAD) ; les fichiers sont
               gardés dans outils/cache/questiedb/<ref>/ (ignoré par git) et téléchargés s'ils manquent
  --verifier   n'écrit rien : compare le résultat au fichier actuel et affiche les différences

Monstres gardés : hostiles aux deux factions (friendlyToFaction vide) ou neutres avec du butin (« AH » : les bêtes
qu'on attaque, loups, sangliers…), avec au moins une apparition (spawns) dans une zone connue, sans fonction de PNJ
(npcFlags), sans les PNJ techniques (déclencheurs, invisibles…).
Ordre du fichier = numéro dans le WoWdex : niveau minimum, niveau maximum, zone, nom.

Ligne de ns.BESTIAIRE :
    pnj|nom français|nom anglais (vide s'il est le même)|niv min|niv max|rang|zones|butin
  rang   0 normal, 1 élite, 2 rare élite, 3 boss, 4 rare (QuestieDB, rank)
  zones  zone:x,y;x,y#zone:… : la zone principale d'abord, deux zones au plus, 8 apparitions au plus par zone,
         en pourcentage entier de la carte (0-100)
  butin  objets que le monstre lâche, lâchés par 40 monstres au plus (le butin commun, étoffes, objets gris,
         est mesuré en jeu par la guilde), les plus rares d'abord, 20 au plus
Ligne de ns.BESTIAIRE_ZONES : zone|nom|carte (uiMapID, vide si inconnue)
"""
import os
import re
import sys
import urllib.request
from datetime import date

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from generer_objectifs import Lecteur, lire_donnees, liste  # noqa: E402

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SORTIE = os.path.join(RACINE, "GuildUpSMB", "GuildUp_Bestiaire.lua")
SOURCES = os.path.join(RACINE, "GuildUpSMB", "GuildUp_Sources.lua")
URL = "https://raw.githubusercontent.com/Questie/QuestieDB/{ref}/{fichier}"
FICHIERS = ("data/Forever/foreverNpcDB.lua", "data/Forever/foreverItemDB.lua", "l10n/Forever/lookupNpcs/frFR.lua")

SEUIL_BUTIN = 40      # un objet lâché par plus de monstres que ça est du butin commun : pas listé
MAX_BUTIN = 20
MAX_ZONES = 2
MAX_POINTS = 8
# zones absentes de ns.SOURCES_ZONES
ZONES_EN_PLUS = {1585: ("La Prison de Hurlevent", "")}
TECHNIQUES = re.compile(r"^\[|\bDND\b|Trigger|Bunny|UNUSED|Invisible|Dummy|Spawn Point|Credit|^zz", re.I)

# champs de QuestieDB (npcKeys, itemKeys), comptés à partir de 0
N_NOM, N_MIN, N_MAX, N_RANG, N_SPAWNS, N_ZONE, N_AMIS, N_FLAGS = 0, 3, 4, 5, 6, 8, 12, 14
I_DROPS = 1


def fichiers(ref):
    dossier = os.path.join(RACINE, "outils", "cache", "questiedb", ref.replace("/", "_"))
    os.makedirs(dossier, exist_ok=True)
    chemins = []
    for f in FICHIERS:
        # (même cache que generer_objectifs.py : le nom de fichier seul, sauf pour les noms français)
        nom = f.split("/")[-1] if f.startswith("data/") else f.replace("/", "_")
        chemin = os.path.join(dossier, nom)
        if not os.path.exists(chemin):
            url = URL.format(ref=ref, fichier=f)
            print("téléchargement :", url)
            with urllib.request.urlopen(url) as r, open(chemin, "wb") as sortie:
                sortie.write(r.read())
        chemins.append(chemin)
    return chemins


def noms_francais(chemin):
    texte = open(chemin, encoding="utf-8").read()
    debut = texte.index("{", texte.index("[[return"))
    fin = texte.index("}]]", debut)
    noms = {}
    for pnj, valeur in Lecteur(texte[debut:fin + 1]).table().items():
        v = liste(valeur)
        if v and isinstance(v[0], str):
            noms[pnj] = v[0]
    return noms


def zones_connues():
    texte = open(SOURCES, encoding="utf-8").read()
    bloc = texte.split("ns.SOURCES_ZONES = [==[", 1)[1].split("]==]", 1)[0]
    zones = {}
    for ligne in bloc.strip().split("\n"):
        z, nom, carte = ligne.split("|")
        zones[int(z)] = (nom, carte)
    for z, v in ZONES_EN_PLUS.items():
        zones.setdefault(z, v)
    return zones


def propre(nom):
    return nom.replace("|", "/").replace("~", "-").replace("\n", " ").strip()


def echantillon(points, n):
    """n points répartis dans la liste (ordre gardé), coordonnées entières, sans doublons"""
    vus, res = set(), []
    pas = max(1, len(points) / n)
    i = 0.0
    while int(i) < len(points) and len(res) < n:
        p = liste(points[int(i)])
        i += pas
        if len(p) < 2 or not isinstance(p[0], (int, float)) or not isinstance(p[1], (int, float)):
            continue
        if p[0] < 0 or p[1] < 0:  # (QuestieDB : -1,-1 = position inconnue, dans une instance)
            continue
        xy = (int(round(p[0])), int(round(p[1])))
        if xy not in vus:
            vus.add(xy)
            res.append(xy)
    return res


def construire(ref):
    chemin_pnj, chemin_objets, chemin_fr = fichiers(ref)
    pnjs = lire_donnees(chemin_pnj, "QuestieDB.npcData")
    objets = lire_donnees(chemin_objets, "QuestieDB.itemData")
    fr = noms_francais(chemin_fr)
    zones = zones_connues()

    # butin : monstre -> objets, et nombre de monstres par objet
    butin, sources = {}, {}
    for oid, o in objets.items():
        o = liste(o)
        drops = sorted(set(n for n in liste(o[I_DROPS]) if isinstance(n, int))) if len(o) > I_DROPS else []
        sources[oid] = len(drops)
        for n in drops:
            butin.setdefault(n, []).append(oid)

    monstres = []
    for pid, p in pnjs.items():
        p = liste(p)
        if not isinstance(pid, int) or len(p) <= N_FLAGS:
            continue
        nom_en = p[N_NOM]
        if not isinstance(nom_en, str) or TECHNIQUES.search(nom_en):
            continue
        # (« amical » envers les deux factions : aussi les bêtes neutres, qu'on attaque ; gardées si elles ont
        # du butin, pas les bestioles ni les PNJ des villes)
        if p[N_FLAGS] or not (p[N_AMIS] is None or (p[N_AMIS] == "AH" and butin.get(pid))):
            continue
        spawns = p[N_SPAWNS] if isinstance(p[N_SPAWNS], dict) else {}
        if not spawns:
            continue
        principale = p[N_ZONE] if p[N_ZONE] in spawns else None
        ordre = sorted(spawns, key=lambda z: (z != principale, -len(liste(spawns[z])), z))
        blocs = []
        for z in ordre:
            if len(blocs) >= MAX_ZONES:
                break
            if z not in zones:
                continue
            pts = echantillon(liste(spawns[z]), MAX_POINTS)
            blocs.append("%d:%s" % (z, ";".join("%d,%d" % xy for xy in pts)))
        if not blocs:
            continue
        zone = int(blocs[0].split(":")[0])
        objets_pnj = sorted((o for o in butin.get(pid, []) if sources[o] <= SEUIL_BUTIN), key=lambda o: (sources[o], o))
        mi, ma = p[N_MIN] or 0, p[N_MAX] or 0
        nom = propre(fr.get(pid) or nom_en)
        en = propre(nom_en)
        monstres.append(((mi, ma, zone, nom, pid), "%d|%s|%s|%d|%d|%d|%s|%s" % (
            pid, nom, "" if en == nom else en, mi, ma, p[N_RANG] or 0, "#".join(blocs),
            ",".join(str(o) for o in objets_pnj[:MAX_BUTIN]))))
    monstres.sort(key=lambda m: m[0])
    lignes = [m[1] for m in monstres]
    utilisees = sorted(set(int(b.split(":")[0]) for l in lignes for b in l.split("|")[6].split("#")))
    lignes_zones = ["%d|%s|%s" % (z, zones[z][0], zones[z][1]) for z in utilisees]
    return lignes, lignes_zones


def contenu(ref, lignes, lignes_zones):
    return ("-- GuildUpSMB : bestiaire du WoWdex (GuildUp_Wowdex.lua) : les monstres hostiles de WoW Forever.\n"
            "-- FICHIER GÉNÉRÉ par outils/generer_bestiaire.py : ne pas modifier à la main.\n"
            "-- Données tirées de la base QuestieDB, version Forever (GPL-3.0, merci à ses auteurs) :\n"
            "-- https://github.com/Questie/QuestieDB (data/Forever et l10n/Forever, réf. %s, le %s).\n"
            "-- Ligne (numéro dans le WoWdex = rang de la ligne) :\n"
            "--   pnj|nom français|nom anglais (vide si le même)|niv min|niv max|rang|zones|butin\n"
            "-- rang : 0 normal, 1 élite, 2 rare élite, 3 boss, 4 rare ; zones : zone:x,y;x,y#zone:… (0-100, zone\n"
            "-- principale d'abord) ; butin : objets particuliers (lâchés par 40 monstres au plus), les plus rares d'abord.\n"
            "-- Zones : zone|nom|carte (uiMapID).\n"
            "\n"
            "local NOM_ADDON, ns = ...\n"
            "\n"
            "ns.BESTIAIRE = [==[\n%s\n]==]\n"
            "\n"
            "ns.BESTIAIRE_ZONES = [==[\n%s\n]==]\n") % (ref, date.today().isoformat(), "\n".join(lignes),
                                                       "\n".join(lignes_zones))


def main():
    args = sys.argv[1:]
    verifier = "--verifier" in args
    args = [a for a in args if a != "--verifier"]
    ref = "HEAD"
    if "--ref" in args:
        ref = args[args.index("--ref") + 1]
    lignes, lignes_zones = construire(ref)
    print("%d monstres, %d zones" % (len(lignes), len(lignes_zones)))
    if verifier:
        if not os.path.exists(SORTIE):
            print("pas de fichier actuel")
            return
        actuelles = [l for l in open(SORTIE, encoding="utf-8").read().split("\n") if l[:1].isdigit()]
        lignes = lignes + lignes_zones
        ajoutees = set(lignes) - set(actuelles)
        retirees = set(actuelles) - set(lignes)
        print("%d ligne(s) ajoutée(s), %d retirée(s)" % (len(ajoutees), len(retirees)))
        for l in sorted(ajoutees)[:20]:
            print("+", l)
        for l in sorted(retirees)[:20]:
            print("-", l)
        return
    with open(SORTIE, "w", encoding="utf-8", newline="\n") as f:
        f.write(contenu(ref, lignes, lignes_zones))
    print("écrit :", SORTIE, "(%d octets)" % os.path.getsize(SORTIE))


if __name__ == "__main__":
    main()
