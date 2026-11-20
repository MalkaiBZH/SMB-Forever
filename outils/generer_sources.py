"""Régénère GuildUpSMB/GuildUp_Sources.lua : d'où viennent les objets (marchands, butin, récolte,
contenants, quêtes), lu par GuildUp_Carnet.lua (Encyclopédie) et GuildUp_Demandes.lua.

Ce fichier avait été produit une seule fois par l'outil d'export de l'auteur d'origine (`/gup export`),
absent de ce dépôt : il était donc figé et impossible à rafraîchir. Ce script le reconstruit.

Deux sources, les mêmes que les autres générateurs :
  * les relations (qui vend, qui lâche, où ça se récolte, quelle quête le donne) : la base ForeverDB
    (GPL-3.0) — https://github.com/foreverfraddons/forever-db — qui réunit et recoupe QuestieDB (GPL-3.0),
    VMaNGOS (GPL-2.0-or-later), cMaNGOS classic-db (GPL) et pfQuest (MIT), plus des relevés en jeu.
  * les entités (noms français, zones, positions sur la carte) : QuestieDB version Forever, comme
    generer_bestiaire.py. ForeverDB donne aussi des positions, mais en coordonnées monde et pour une
    minorité des PNJ : QuestieDB est ici la meilleure des deux.

Usage :
    python outils/generer_sources.py [--ref REF] [--ref-db REF] [--verifier]

  --ref        référence QuestieDB (défaut : HEAD), cache outils/cache/questiedb/<ref>/
  --ref-db     référence forever-db (défaut : main), cache outils/cache/foreverdb/<ref>/
  --verifier   n'écrit rien : compare le résultat au fichier actuel et affiche les différences

Lignes produites (format inchangé : les lecteurs existants n'ont pas à bouger) :
  objets : id|marchands|butin (les plus répandus)|nombre total de monstres|récolte|contenants|quêtes
  pnj    : id|nom|niv min|niv max|zone principale|faction (A, H, AH)|positions x,y;x,y (0-100)|sous-titre|rang
  récolte: id|nom|zone:nombre:x,y;x,y#zone:…
  zones  : id|nom|carte du monde        quêtes : id|nom

Les noms de zones ne sont traduits ni par ForeverDB ni par QuestieDB : on reprend ceux du fichier actuel,
qui ne bougent pas. Une zone nouvelle est écrite avec son nom anglais et signalée à la fin du script, pour
être traduite dans ZONES_FR ci-dessous.
"""
import os
import re
import sys
import urllib.request
from datetime import date

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from generer_objectifs import Lecteur, lire_donnees, liste  # noqa: E402

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SORTIE = os.path.join(RACINE, "GuildUpSMB", "GuildUp_Sources.lua")

URL_Q = "https://raw.githubusercontent.com/Questie/QuestieDB/{ref}/{fichier}"
FICHIERS_Q = ("data/Forever/foreverNpcDB.lua", "data/Forever/foreverObjectDB.lua",
              "l10n/Forever/lookupNpcs/frFR.lua", "l10n/Forever/lookupObjects/frFR.lua")
URL_DB = "https://raw.githubusercontent.com/foreverfraddons/forever-db/{ref}/{dossier}/{fichier}"
FICHIERS_DB = ("ForeverDB.lua", "ForeverDB_2.lua", "ForeverDB_3.lua", "ForeverDB_4.lua")
FICHIERS_LOC = ("ForeverDB_Locales.lua", "ForeverDB_Locales_2.lua", "ForeverDB_Locales_3.lua",
                "ForeverDB_Locales_4.lua")

# plafonds par objet, repris de ceux qu'avait le fichier d'origine
MAX_MARCHANDS, MAX_BUTIN, MAX_RECOLTE, MAX_CONTENANTS, MAX_QUETES = 40, 12, 45, 27, 52
MAX_POINTS = 4          # positions gardées par PNJ ou par point de récolte et par zone

# champs de QuestieDB, comptés à partir de 0 (voir generer_bestiaire.py)
N_NOM, N_MIN, N_MAX, N_RANG, N_SPAWNS, N_ZONE, N_AMIS, N_SOUS = 0, 3, 4, 5, 6, 8, 12, 13
O_NOM, O_SPAWNS, O_ZONE = 0, 3, 4

# Zones que ni ForeverDB ni QuestieDB ne traduisent et que le fichier actuel ne connaît pas encore.
ZONES_FR = {}


def telecharger(dossier, fabriquer_url, fichiers, nommer):
    os.makedirs(dossier, exist_ok=True)
    chemins = []
    for f in fichiers:
        chemin = os.path.join(dossier, nommer(f))
        if not os.path.exists(chemin):
            url = fabriquer_url(f)
            print("téléchargement :", url)
            with urllib.request.urlopen(url) as r, open(chemin, "wb") as sortie:
                sortie.write(r.read())
        chemins.append(chemin)
    return chemins


def fichiers_questie(ref):
    # (même cache que generer_bestiaire.py : le nom de fichier seul, sauf pour les traductions)
    return telecharger(os.path.join(RACINE, "outils", "cache", "questiedb", ref.replace("/", "_")),
                       lambda f: URL_Q.format(ref=ref, fichier=f), FICHIERS_Q,
                       lambda f: f.split("/")[-1] if f.startswith("data/") else f.replace("/", "_"))


def fichiers_base(ref, dossier, fichiers):
    return telecharger(os.path.join(RACINE, "outils", "cache", "foreverdb", ref.replace("/", "_")),
                       lambda f: URL_DB.format(ref=ref, dossier=dossier, fichier=f), fichiers,
                       lambda f: f)


def propre(nom):
    return str(nom).replace("|", "/").replace("~", "-").replace("\n", " ").strip()


def decalage(entrees):
    """Le lecteur rend des tables numérotées à partir de 0 ou de 1 selon les versions : on regarde."""
    for p in entrees.values():
        if isinstance(p, dict) and p:
            return 0 if 0 in p else 1
    return 0


def champ(p, i, d):
    return p.get(i + d) if isinstance(p, dict) else None


# ---------------------------------------------------------------- ForeverDB

def table_db(textes, nom):
    """Une table de ForeverDB : { clé : « contenu entre accolades » }."""
    bloc = re.compile(r"local t = D\.%s\b(.*?)(?=;\(function\(\) local t = D\.|\nD\.|\Z)" % nom, re.S)
    entree = re.compile(r"^t\[(\d+)\]=\{([^}]*)\}", re.M)
    out, trouve = {}, False
    for texte in textes:
        for b in bloc.finditer(texte):
            trouve = True
            for m in entree.finditer(b.group(1)):
                out[int(m.group(1))] = m.group(2)
    if not trouve:
        raise SystemExit("table « %s » introuvable : ForeverDB a-t-elle changé de format ?" % nom)
    return out


def nombres(texte):
    return [int(x) for x in texte.split(",") if x.strip().lstrip("-").isdigit()]


def paires(texte):
    """{ source, chance, source, chance, … } → [(source, chance), …], les meilleures chances d'abord."""
    v = nombres(texte)
    p = [(v[i], v[i + 1]) for i in range(0, len(v) - 1, 2)]
    p.sort(key=lambda sc: (-sc[1], sc[0]))
    return p


def noms_frfr(textes):
    """D.loc["frFR"] : { item = {…}, npc = {…}, obj = {…}, quest = {…} }."""
    for texte in textes:
        i = texte.find('t["frFR"]={')
        if i < 0:
            continue
        j = texte.find('t["', i + 11)
        bloc = texte[i:j if j > 0 else len(texte)]
        out = {}
        for cat in ("npc", "obj", "quest"):
            m = re.search(r"[,{]%s=\{" % cat, bloc)
            if not m:
                continue
            # jusqu'à l'accolade qui ferme la catégorie
            prof, k = 1, m.end()
            while k < len(bloc) and prof:
                if bloc[k] == "{":
                    prof += 1
                elif bloc[k] == "}":
                    prof -= 1
                k += 1
            out[cat] = dict((int(a), b) for a, b in re.findall(r'\[(\d+)\]="((?:[^"\\]|\\.)*)"', bloc[m.end():k]))
        return out
    return {}


# ---------------------------------------------------------------- QuestieDB

def lookup_francais(chemin):
    texte = open(chemin, encoding="utf-8").read()
    debut = texte.index("{", texte.index("[[return"))
    fin = texte.index("}]]", debut)
    noms = {}
    for cle, valeur in Lecteur(texte[debut:fin + 1]).table().items():
        v = liste(valeur)
        if v and isinstance(v[0], str):
            noms[cle] = v[0]
    return noms


def points(spawns, zone_principale, d):
    """{ zone : [(x, y), …] } d'après les spawns de QuestieDB, zone principale d'abord."""
    out = {}
    if not isinstance(spawns, dict):
        return out
    for z, liste_points in spawns.items():
        if not isinstance(z, int):
            continue
        vus, pts = set(), []
        for point in liste(liste_points):
            xy = liste(point)
            if len(xy) < 2 or not isinstance(xy[0], (int, float)) or not isinstance(xy[1], (int, float)):
                continue
            if xy[0] < 0 or xy[1] < 0:      # (QuestieDB : -1,-1 = dans une instance)
                continue
            p = (int(round(xy[0])), int(round(xy[1])))
            if p not in vus:
                vus.add(p)
                pts.append(p)
            if len(pts) >= MAX_POINTS:
                break
        if pts:
            out[z] = pts
    return out


# ---------------------------------------------------------------- Zones

def bloc_actuel(nom):
    """Les lignes d'une table du fichier actuel : { id : ligne }."""
    if not os.path.exists(SORTIE):
        return {}
    texte = open(SORTIE, encoding="utf-8").read()
    cle = "ns.SOURCES_%s = [==[" % nom
    if cle not in texte:
        return {}
    out = {}
    for ligne in texte.split(cle, 1)[1].split("]==]", 1)[0].strip().split("\n"):
        c = ligne.split("|")
        if c[0].isdigit():
            out[int(c[0])] = ligne
    return out


def zones_actuelles():
    """Les noms de zones du fichier actuel : ni ForeverDB ni QuestieDB ne les traduisent."""
    out = {}
    for z, ligne in bloc_actuel("ZONES").items():
        c = ligne.split("|")
        if len(c) >= 3:
            out[z] = (c[1], c[2])
    return out


def fusionner(objet, ligne, ancienne):
    """L'export d'origine connaît des sources que ForeverDB n'a pas : on garde les deux."""
    a, b = ancienne.split("|"), ligne.split("|")
    if len(a) < 7 or len(b) < 7:
        return ligne
    res = [b[0]]
    for i, plafond in ((1, MAX_MARCHANDS), (2, MAX_BUTIN)):
        res.append(",".join(union(b[i], a[i], plafond)))
    res.append(str(max(int(b[3] or 0), int(a[3] or 0))))
    for i, plafond in ((4, MAX_RECOLTE), (5, MAX_CONTENANTS), (6, MAX_QUETES)):
        res.append(",".join(union(b[i], a[i], plafond)))
    return "|".join(res)


def union(neuf, ancien, plafond):
    """Les valeurs du neuf d'abord (ForeverDB est à jour), puis celles que lui seul connaissait."""
    vus, res = set(), []
    for texte in (neuf, ancien):
        for x in texte.split(","):
            x = x.strip()
            if x and x not in vus:
                vus.add(x)
                res.append(x)
            if len(res) >= plafond:
                return res
    return res


# ---------------------------------------------------------------- Construction

def construire(ref, ref_db):
    chemin_pnj, chemin_obj, chemin_fr_pnj, chemin_fr_obj = fichiers_questie(ref)
    textes_db = [open(c, encoding="utf-8", errors="replace").read()
                 for c in fichiers_base(ref_db, "ForeverDB", FICHIERS_DB)]
    textes_loc = [open(c, encoding="utf-8", errors="replace").read()
                  for c in fichiers_base(ref_db, "ForeverDB_Locales", FICHIERS_LOC)]

    vend = dict((k, nombres(v)) for k, v in table_db(textes_db, "vend").items())
    drop = dict((k, paires(v)) for k, v in table_db(textes_db, "drop").items())
    odrop = dict((k, paires(v)) for k, v in table_db(textes_db, "odrop").items())
    idrop = dict((k, paires(v)) for k, v in table_db(textes_db, "idrop").items())
    rew = dict((k, nombres(v)) for k, v in table_db(textes_db, "rew").items())

    # rew est rangée par objet et donne les quêtes qui le récompensent (rew[60]={6} = l'objet 60 vient
    # de la quête 6), comme le champ « quêtes » du fichier d'origine.
    par_objet_quetes = rew

    fr = noms_frfr(textes_loc)
    pnjs = lire_donnees(chemin_pnj, "QuestieDB.npcData")
    objs = lire_donnees(chemin_obj, "QuestieDB.objectData")
    fr_pnj = lookup_francais(chemin_fr_pnj)
    fr_obj = lookup_francais(chemin_fr_obj)
    dn, do = decalage(pnjs), decalage(objs)
    zones = zones_actuelles()

    anciens = dict((nom, bloc_actuel(nom)) for nom in ("OBJETS", "PNJ", "RECOLTE", "QUETES"))
    tous = set(vend) | set(drop) | set(odrop) | set(idrop) | set(par_objet_quetes)
    lignes_objets = []
    vus_pnj, vus_obj, vus_quetes, zones_utiles = set(), set(), set(), set()
    for objet in sorted(tous):
        marchands = vend.get(objet, [])[:MAX_MARCHANDS]
        butin_tout = [p for p, _ in drop.get(objet, [])]
        butin = butin_tout[:MAX_BUTIN]
        recolte = [p for p, _ in odrop.get(objet, [])][:MAX_RECOLTE]
        contenants = [p for p, _ in idrop.get(objet, [])][:MAX_CONTENANTS]
        quetes = sorted(par_objet_quetes.get(objet, []))[:MAX_QUETES]
        if not (marchands or butin or recolte or contenants or quetes):
            continue
        vus_pnj.update(marchands)
        vus_pnj.update(butin)
        vus_obj.update(recolte)
        vus_quetes.update(quetes)
        ligne = "%d|%s|%s|%d|%s|%s|%s" % (
            objet, ",".join(str(x) for x in marchands), ",".join(str(x) for x in butin),
            len(butin_tout), ",".join(str(x) for x in recolte),
            ",".join(str(x) for x in contenants), ",".join(str(x) for x in quetes))
        if objet in anciens["OBJETS"]:
            ligne = fusionner(objet, ligne, anciens["OBJETS"][objet])
        lignes_objets.append(ligne)
    # les objets que seul l'export d'origine connaît
    for objet, ligne in sorted(anciens["OBJETS"].items()):
        if objet not in tous:
            lignes_objets.append(ligne)
            c = ligne.split("|")
            if len(c) >= 7:
                vus_pnj.update(nombres(c[1]) + nombres(c[2]))
                vus_obj.update(nombres(c[4]))
                vus_quetes.update(nombres(c[6]))
    lignes_objets.sort(key=lambda l: int(l.split("|")[0]))

    # --- PNJ (marchands et monstres cités)
    lignes_pnj = []
    for pnj in sorted(vus_pnj):
        p = pnjs.get(pnj)
        nom = fr_pnj.get(pnj) or (fr.get("npc", {}).get(pnj)) or (champ(p or {}, N_NOM, dn))
        if not isinstance(nom, str) or not nom.strip():
            continue
        zone = champ(p or {}, N_ZONE, dn)
        pts = points(champ(p or {}, N_SPAWNS, dn), zone, dn)
        if zone not in pts and pts:
            zone = sorted(pts)[0]
        if isinstance(zone, int):
            zones_utiles.add(zone)
        coord = ";".join("%d,%d" % xy for xy in pts.get(zone, []))
        sous = champ(p or {}, N_SOUS, dn)
        lignes_pnj.append("%d|%s|%s|%s|%s|%s|%s|%s|%d" % (
            pnj, propre(nom), champ(p or {}, N_MIN, dn) or "", champ(p or {}, N_MAX, dn) or "",
            zone if isinstance(zone, int) else "", champ(p or {}, N_AMIS, dn) or "", coord,
            propre(sous) if isinstance(sous, str) else "", champ(p or {}, N_RANG, dn) or 0))

    # --- récolte (objets du décor)
    lignes_recolte = []
    for oid in sorted(vus_obj):
        o = objs.get(oid)
        nom = fr_obj.get(oid) or (fr.get("obj", {}).get(oid)) or (champ(o or {}, O_NOM, do))
        if not isinstance(nom, str) or not nom.strip():
            continue
        pts = points(champ(o or {}, O_SPAWNS, do), champ(o or {}, O_ZONE, do), do)
        blocs = []
        for z in sorted(pts, key=lambda z: (-len(pts[z]), z)):
            zones_utiles.add(z)
            blocs.append("%d:%d:%s" % (z, len(pts[z]), ";".join("%d,%d" % xy for xy in pts[z])))
        lignes_recolte.append("%d|%s|%s" % (oid, propre(nom), "#".join(blocs)))

    # --- quêtes
    noms_quetes = fr.get("quest", {})
    lignes_quetes = ["%d|%s" % (q, propre(noms_quetes[q])) for q in sorted(vus_quetes) if q in noms_quetes]

    # --- ce que l'export d'origine savait et que les bases ne redonnent pas
    for nom, lignes in (("PNJ", lignes_pnj), ("RECOLTE", lignes_recolte), ("QUETES", lignes_quetes)):
        connus = set(int(l.split("|")[0]) for l in lignes)
        besoin = vus_pnj if nom == "PNJ" else (vus_obj if nom == "RECOLTE" else vus_quetes)
        for cle, ligne in sorted(anciens[nom].items()):
            if cle not in connus and cle in besoin:
                lignes.append(ligne)
                c = ligne.split("|")
                if nom == "PNJ" and len(c) >= 5 and c[4].isdigit():
                    zones_utiles.add(int(c[4]))
                elif nom == "RECOLTE" and len(c) >= 3:
                    zones_utiles.update(int(z) for z in re.findall(r"(?:^|#)(\d+):", c[2]))
        lignes.sort(key=lambda l: int(l.split("|")[0]))

    # --- zones : celles du fichier actuel, plus les nouvelles (nom anglais, à traduire)
    manquantes = []
    lignes_zones = []
    for z in sorted(zones_utiles | set(zones)):
        if z in zones:
            nom, carte = zones[z]
        elif z in ZONES_FR:
            nom, carte = ZONES_FR[z], ""
        else:
            manquantes.append(z)
            continue
        lignes_zones.append("%d|%s|%s" % (z, nom, carte))

    return (lignes_objets, lignes_pnj, lignes_recolte, lignes_zones, lignes_quetes, manquantes)


def contenu(ref, ref_db, objets, pnj, recolte, zones, quetes):
    return ("-- GuildUpSMB : d'où viennent les objets (marchands, butin, récolte, contenants, quêtes).\n"
            "-- FICHIER GÉNÉRÉ par outils/generer_sources.py : ne pas modifier à la main.\n"
            "-- Relations (qui vend, qui lâche, où ça se récolte, quelle quête le donne) : base ForeverDB\n"
            "-- (GPL-3.0, réf. %s), https://github.com/foreverfraddons/forever-db, qui réunit elle-même\n"
            "-- QuestieDB (GPL-3.0), VMaNGOS (GPL-2.0-or-later), cMaNGOS classic-db (GPL) et pfQuest (MIT).\n"
            "-- Noms français, zones et positions : QuestieDB version Forever (GPL-3.0, réf. %s),\n"
            "-- https://github.com/Questie/QuestieDB — le %s. GuildUpSMB n'a besoin d'aucun des deux en jeu.\n"
            "-- objets : id|marchands|butin (les plus répandus)|nombre total de monstres|récolte|contenants|quêtes\n"
            "-- pnj    : id|nom|niv min|niv max|zone principale|faction (A, H, AH)|positions x,y;x,y (0-100)"
            "|sous-titre|rang (0 normal, 1 élite, 2 rare élite, 3 boss, 4 rare)\n"
            "-- récolte: id|nom|zone:nombre:x,y;x,y#zone:…   zones : id|nom|carte du monde   quêtes : id|nom\n"
            "\n"
            "local NOM_ADDON, ns = ...\n"
            "\n"
            "ns.SOURCES_OBJETS = [==[\n%s\n]==]\n"
            "\n"
            "ns.SOURCES_PNJ = [==[\n%s\n]==]\n"
            "\n"
            "ns.SOURCES_RECOLTE = [==[\n%s\n]==]\n"
            "\n"
            "ns.SOURCES_ZONES = [==[\n%s\n]==]\n"
            "\n"
            "ns.SOURCES_QUETES = [==[\n%s\n]==]\n") % (
        ref_db, ref, date.today().isoformat(), "\n".join(objets), "\n".join(pnj),
        "\n".join(recolte), "\n".join(zones), "\n".join(quetes))


def main():
    args = sys.argv[1:]
    verifier = "--verifier" in args
    args = [a for a in args if a != "--verifier"]
    ref, ref_db = "HEAD", "main"
    if "--ref" in args:
        ref = args[args.index("--ref") + 1]
    if "--ref-db" in args:
        ref_db = args[args.index("--ref-db") + 1]
    objets, pnj, recolte, zones, quetes, manquantes = construire(ref, ref_db)
    print("%d objets, %d PNJ, %d points de récolte, %d zones, %d quêtes"
          % (len(objets), len(pnj), len(recolte), len(zones), len(quetes)))
    if manquantes:
        print("%d zone(s) sans nom français, ignorée(s) : %s" % (len(manquantes), manquantes[:20]))
        print("  les ajouter à ZONES_FR en tête de ce script pour qu'elles apparaissent")
    if verifier:
        if not os.path.exists(SORTIE):
            print("pas de fichier actuel")
            return
        actuel = open(SORTIE, encoding="utf-8").read()
        for nom, lignes in (("OBJETS", objets), ("PNJ", pnj), ("RECOLTE", recolte),
                            ("ZONES", zones), ("QUETES", quetes)):
            cle = "ns.SOURCES_%s = [==[" % nom
            if cle not in actuel:
                print("  %-8s absent du fichier actuel" % nom)
                continue
            vieilles = set(l for l in actuel.split(cle, 1)[1].split("]==]", 1)[0].strip().split("\n") if l)
            neuves = set(lignes)
            print("  %-8s %+d ligne(s) : %d ajoutée(s), %d retirée(s)"
                  % (nom, len(neuves) - len(vieilles), len(neuves - vieilles), len(vieilles - neuves)))
        return
    with open(SORTIE, "w", encoding="utf-8") as f:
        f.write(contenu(ref, ref_db, objets, pnj, recolte, zones, quetes))
    print("écrit :", SORTIE)


if __name__ == "__main__":
    main()
