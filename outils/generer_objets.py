"""Régénère les noms d'objets de GuildUpSMB depuis les tables du client WoW Forever publiées par wago.tools :
GuildUpSMB/GuildUp_Objets.lua (noms français) et GuildUpSMB/GuildUp_Objets_enUS.lua (noms anglais).

Usage :
    python outils/generer_objets.py [build] [--dossier DOSSIER_CSV] [--verifier]

  build        version du client (défaut : celle écrite dans l'en-tête de GuildUp_Objets.lua)
  --dossier    dossier où lire / garder les CSV (défaut : outils/cache/<build>/) ; les tables
               manquantes sont téléchargées depuis
               https://wago.tools/db2/<Table>/csv?build=<build>[&locale=<langue>]
  --verifier   n'écrit rien : compare le résultat aux fichiers actuels et affiche les différences

À relancer après outils/generer_craft.py : la liste des objets liés ne garde que les objets fabriqués
par une recette de GuildUp_Craft.lua.

Tables utilisées :
  ItemSparse (frFR, enUS)  nom (Display_lang), qualité (OverallQualityID), niveau d'objet (ItemLevel),
                           liaison (Bonding : 0 aucune, 1 quand ramassé, 2 quand équipé, 3 quand utilisé,
                           4 objet de quête, 5 compte) ; seule la colonne du nom change avec la langue
  Item                     classe de l'objet (ClassID : 7 = artisanat, 5 = composant, 12 = quête…)

Sélection (la même pour les deux langues) :
  - ni gris (qualité 0), ni objets de quête (liaison 4) ;
  - pas d'objets de test ou abandonnés, reconnus à leur nom français (voir ABANDONNES ; pas au nom
    anglais : « Boar Intestines » ou « The Greatest Race of Hunters » contiennent « test ») ;
  - ns.DONNEES_OBJETS : les objets échangeables (toute liaison sauf 1) ; la classe 12 (quête) est
    gardée tant que l'objet n'est pas lié comme objet de quête ;
  - ns.DONNEES_OBJETS_LIES : les objets liés quand ramassés (liaison 1) fabriqués par une recette.
Tri par nom sans tenir compte des majuscules (puis par numéro), chaque langue selon ses propres noms.

Format d'une ligne (voir GuildUp_Besoins.lua, Index(), et GuildUp_Carnet.lua, Catalogue()) :
    id:qualité:classe:niveau d'objet:nom
"""
import csv
import os
import re
import sys
import urllib.request

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DONNEES = os.path.join(RACINE, "GuildUpSMB")
CRAFT = os.path.join(DONNEES, "GuildUp_Craft.lua")
LANGUES = {  # langue de wago.tools -> fichier de l'addon
    "frFR": os.path.join(DONNEES, "GuildUp_Objets.lua"),
    "enUS": os.path.join(DONNEES, "GuildUp_Objets_enUS.lua"),
}
BLOCS = ("ns.DONNEES_OBJETS", "ns.DONNEES_OBJETS_LIES")

GRIS = 0
LIE_QUAND_RAMASSE = 1
OBJET_DE_QUETE = 4
# objets de test, abandonnés ou provisoires : « [PÉRIMÉ] », « Deprecated », « Test », « UNUSED »,
# « (OLD) », « zzOLD », « Monster - », « Placeholder », « (DND) », « … NYI », « [PH] », « [DNT] »…
ABANDONNES = re.compile(r"\btest\b|deprecated|unused|^\[|\(old|zzold|^monster - |placeholder|\(dnd\)|\bnyi\b", re.I)


def build_actuel():
    with open(LANGUES["frFR"], encoding="utf-8") as f:
        m = re.search(r"client WoW Forever ([\d.]+)", f.read(2000))
    return m.group(1) if m else None


def table(nom, build, dossier, langue=None):
    chemin = os.path.join(dossier, nom + ("." + langue if langue else "") + ".csv")
    if not os.path.exists(chemin):
        os.makedirs(dossier, exist_ok=True)
        url = "https://wago.tools/db2/%s/csv?build=%s" % (nom, build)
        if langue:
            url += "&locale=" + langue
        print("téléchargement :", url)
        requete = urllib.request.Request(url, headers={"User-Agent": "generer_objets"})
        with urllib.request.urlopen(requete) as r, open(chemin, "wb") as f:
            f.write(r.read())
    with open(chemin, encoding="utf-8") as f:
        return list(csv.DictReader(f))


def objets_fabriques():
    with open(CRAFT, encoding="utf-8") as f:
        fabriques = {int(m.group(1)) for m in re.finditer(r"^\d+:[A-Z]+:\d+:\d+:(\d+):", f.read(), re.M)}
    fabriques.discard(0)
    return fabriques


def generer(build, dossier):
    """Renvoie {langue: {bloc: [lignes]}}."""
    noms = {}
    for langue in LANGUES:
        lignes = table("ItemSparse", build, dossier, langue)
        noms[langue] = {int(r["ID"]): r["Display_lang"] for r in lignes}
        if langue == "frFR":
            objets = {int(r["ID"]): r for r in lignes}  # les autres colonnes ne changent pas avec la langue
    classes = {int(r["ID"]): int(r["ClassID"]) for r in table("Item", build, dossier)}
    fabriques = objets_fabriques()

    choisis = {bloc: [] for bloc in BLOCS}
    for id, o in objets.items():
        liaison, qualite = int(o["Bonding"]), int(o["OverallQualityID"])
        if qualite == GRIS or liaison == OBJET_DE_QUETE:
            continue
        if ABANDONNES.search(noms["frFR"].get(id) or ""):
            continue
        if liaison == LIE_QUAND_RAMASSE:
            if id not in fabriques:
                continue  # la liste des objets liés ne sert qu'au catalogue des objets fabricables
            bloc = "ns.DONNEES_OBJETS_LIES"
        else:
            bloc = "ns.DONNEES_OBJETS"
        choisis[bloc].append((id, qualite, classes.get(id, 0), int(o["ItemLevel"])))

    resultat = {}
    for langue in LANGUES:
        resultat[langue] = {}
        for bloc, liste in choisis.items():
            lignes = []
            for id, qualite, classe, niveau in liste:
                nom = (noms[langue].get(id) or noms["frFR"][id]).replace("\n", " ").strip()
                lignes.append((nom.lower(), id, "%d:%d:%d:%d:%s" % (id, qualite, classe, niveau, nom)))
            resultat[langue][bloc] = [l[2] for l in sorted(lignes)]
    return resultat


ENTETES = {
    "frFR": """-- GuildUp : noms français de tous les objets échangeables du jeu (ni liés quand ramassés, ni de quête,
-- ni gris), pour chercher un objet par son nom dans les Besoins même sans l'avoir sur soi.
-- Généré depuis les données du client WoW Forever %s, français (wago.tools : ItemSparse, Item)
-- par outils/generer_objets.py. Ne pas modifier à la main.
-- Une ligne par objet : id:qualité:classe:niveau d'objet:nom (classe 7 = artisanat, 5 = composant)
-- Client anglais (enUS, enGB) : ce fichier ne fait rien, GuildUp_Objets_enUS.lua donne les noms anglais.
-- Le texte n'est alors gardé nulle part : il disparaît avec le fichier après son chargement.

local NOM_ADDON, ns = ...

local langue = GetLocale and GetLocale()
if langue == "enUS" or langue == "enGB" then return end

""",
    "enUS": """-- GuildUp : noms anglais de tous les objets échangeables du jeu (ni liés quand ramassés, ni de quête,
-- ni gris), pour chercher un objet par son nom dans les Besoins même sans l'avoir sur soi.
-- Généré depuis les données du client WoW Forever %s, anglais (wago.tools : ItemSparse, Item)
-- par outils/generer_objets.py. Ne pas modifier à la main.
-- Une ligne par objet : id:qualité:classe:niveau d'objet:nom (classe 7 = artisanat, 5 = composant)
-- Utilisé seulement sur un client anglais (enUS, enGB) : sinon ce fichier ne fait rien et les noms
-- viennent de GuildUp_Objets.lua (français). Même sélection d'objets dans les deux fichiers.

local NOM_ADDON, ns = ...

local langue = GetLocale and GetLocale()
if langue ~= "enUS" and langue ~= "enGB" then return end

""",
}
COMMENTAIRE_LIES = """
-- objets liés quand ramassés et fabriqués par une recette : seulement pour la fenêtre Items (pas pour
-- les Besoins : on ne peut pas les donner). Même format. Seulement ceux de GuildUp_Craft.lua.
"""


def ecrire(build, resultat):
    for langue, fichier in LANGUES.items():
        texte = ENTETES[langue] % build
        for bloc in BLOCS:
            if bloc == "ns.DONNEES_OBJETS_LIES":
                texte += COMMENTAIRE_LIES
            lignes = resultat[langue][bloc]
            if any("]==]" in l for l in lignes):
                sys.exit("un nom contient « ]==] » : changer le niveau des crochets longs")
            texte += "%s = [==[\n%s\n]==]\n" % (bloc, "\n".join(lignes))
        with open(fichier, "w", encoding="utf-8", newline="\n") as f:
            f.write(texte)
        print("%s : %d objets échangeables, %d objets liés" % (fichier, len(resultat[langue][BLOCS[0]]),
                                                                len(resultat[langue][BLOCS[1]])))


def lignes_actuelles(fichier, bloc):
    if not os.path.exists(fichier):
        return []
    with open(fichier, encoding="utf-8") as f:
        texte = f.read()
    debut = texte.find(bloc + " = [==[\n")
    if debut < 0:
        return []
    debut += len(bloc + " = [==[\n")
    return [l for l in texte[debut:texte.index("]==]", debut)].split("\n") if l]


def verifier(resultat):
    for langue, fichier in LANGUES.items():
        if not os.path.exists(fichier):
            print("%s : absent, %d + %d lignes seraient écrites" % (os.path.basename(fichier),
                  len(resultat[langue][BLOCS[0]]), len(resultat[langue][BLOCS[1]])))
            continue
        for bloc in BLOCS:
            avant = lignes_actuelles(fichier, bloc)
            apres = resultat[langue][bloc]
            print("%s %s : %d lignes avant, %d générées%s" % (os.path.basename(fichier), bloc, len(avant),
                  len(apres), " (identiques)" if avant == apres else ""))
            if avant == apres:
                continue
            a, b = {l.split(":", 1)[0]: l for l in avant}, {l.split(":", 1)[0]: l for l in apres}
            ecarts = [i for i in sorted(set(a) | set(b), key=int) if a.get(i) != b.get(i)]
            for i in ecarts[:40]:
                print("  avant :", a.get(i))
                print("  après :", b.get(i))
            if len(ecarts) > 40:
                print("  … %d écarts en tout" % len(ecarts))
            if not ecarts:
                print("  mêmes lignes, ordre différent")


def main():
    args = sys.argv[1:]
    seulement_verifier = "--verifier" in args
    args = [a for a in args if a != "--verifier"]
    dossier = None
    if "--dossier" in args:
        i = args.index("--dossier")
        dossier = args[i + 1]
        del args[i:i + 2]
    build = args[0] if args else build_actuel()
    if not build:
        sys.exit("build inconnu : donne-le en argument (ex. 1.60.1.70862)")
    dossier = dossier or os.path.join(RACINE, "outils", "cache", build)
    resultat = generer(build, dossier)
    if seulement_verifier:
        verifier(resultat)
    else:
        ecrire(build, resultat)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    main()
