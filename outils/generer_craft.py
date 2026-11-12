"""Régénère GuildUp/GuildUp_Craft.lua depuis les tables du client WoW Forever publiées par wago.tools.

Usage :
    python outils/generer_craft.py [build] [--dossier DOSSIER_CSV] [--verifier]

  build        version du client (défaut : celle écrite dans l'en-tête de GuildUp_Craft.lua)
  --dossier    dossier où lire / garder les CSV (défaut : outils/cache/<build>/) ; les tables
               manquantes sont téléchargées depuis https://wago.tools/db2/<Table>/csv?build=<build>
  --verifier   n'écrit rien : compare le résultat au fichier actuel et affiche les différences

Tables utilisées :
  SkillLineAbility  sort -> métier, niveau requis (MinSkillLineRank), niveau « jaune »
                    (TrivialSkillLineRankLow : la recette commence à donner moins de points)
  SpellEffect       objet fabriqué et quantité (effet 24 = création d'objet)
  SpellReagents     composants et quantités

Format d'une ligne (voir GuildUp_Carnet.lua, Recettes()) :
    sort:métier:niveau requis:niveau jaune:objet fabriqué (0 = aucun):objets par fabrication:composant x quantité,…
"""
import csv
import os
import re
import sys
import urllib.request

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FICHIER = os.path.join(RACINE, "GuildUp", "GuildUp_Craft.lua")

# SkillLine du jeu -> code de métier de GuildUp (GuildUp_Metiers.lua)
METIERS = {171: "AL", 164: "FO", 333: "EN", 202: "IN", 165: "TC", 197: "CO", 755: "JO", 773: "CA",
           185: "CU", 129: "SE", 356: "PE", 186: "MI", 182: "HE", 393: "DE"}
CREER_OBJET = 24


def build_actuel():
    with open(FICHIER, encoding="utf-8") as f:
        m = re.search(r"client WoW Forever ([\d.]+)", f.read(2000))
    return m.group(1) if m else None


def table(nom, build, dossier):
    chemin = os.path.join(dossier, nom + ".csv")
    if not os.path.exists(chemin):
        os.makedirs(dossier, exist_ok=True)
        url = "https://wago.tools/db2/%s/csv?build=%s" % (nom, build)
        print("téléchargement :", url)
        requete = urllib.request.Request(url, headers={"User-Agent": "generer_craft"})
        with urllib.request.urlopen(requete) as r, open(chemin, "wb") as f:
            f.write(r.read())
    with open(chemin, encoding="utf-8") as f:
        return list(csv.DictReader(f))


def generer(build, dossier):
    abilites = table("SkillLineAbility", build, dossier)
    effets = table("SpellEffect", build, dossier)
    reactifs = table("SpellReagents", build, dossier)

    creation = {}  # sort -> (objet, quantité)
    for e in effets:
        if int(e["Effect"]) == CREER_OBJET and int(e["DifficultyID"]) == 0:
            sort = int(e["SpellID"])
            if sort not in creation or int(e["EffectIndex"]) == 0:
                creation[sort] = (int(e["EffectItemType"]), max(1, int(round(float(e["EffectBasePointsF"])))))
    composants = {}  # sort -> [(objet, quantité)]
    for r in reactifs:
        l = []
        for i in range(8):
            o, n = int(r["Reagent_%d" % i]), int(r["ReagentCount_%d" % i])
            if o > 0 and n > 0:
                l.append((o, n))
        composants[int(r["SpellID"])] = l

    lignes = {}
    for a in abilites:
        code = METIERS.get(int(a["SkillLine"]))
        sort = int(a["Spell"])
        if not code or sort not in composants or not composants[sort]:
            continue  # pas un métier suivi, ou pas une recette (aucun composant)
        objet, rendement = creation.get(sort, (0, 1))
        compo = ",".join("%dx%d" % c for c in composants[sort])
        lignes[sort] = "%d:%s:%d:%d:%d:%d:%s" % (sort, code, max(1, int(a["MinSkillLineRank"])),
                                                 int(a["TrivialSkillLineRankLow"]), objet, rendement, compo)
    return [lignes[s] for s in sorted(lignes)]


def ecrire(build, lignes):
    entete = """-- GuildUp : recettes pour le carnet de craft (composants, quantités, rendement).
-- Généré depuis les données du client WoW Forever %s (wago.tools : SkillLineAbility,
-- SpellEffect, SpellReagents) par outils/generer_craft.py. Ne pas modifier à la main.
-- Une ligne par recette :
--   sort:métier:niveau requis:niveau jaune:objet fabriqué (0 = aucun):objets par fabrication:composant x quantité,…
-- (niveau requis : 1 pour la plupart des recettes, le client ne le renseigne pas ; niveau jaune :
--  la recette commence à donner moins de points, 0 si inconnu)

local NOM_ADDON, ns = ...

ns.DONNEES_CRAFT = [==[
""" % build
    with open(FICHIER, "w", encoding="utf-8", newline="\n") as f:
        f.write(entete + "\n".join(lignes) + "\n]==]\n")


def lignes_actuelles():
    with open(FICHIER, encoding="utf-8") as f:
        texte = f.read()
    corps = texte.split("[==[", 1)[1].split("]==]", 1)[0]
    return [l for l in corps.strip("\n").split("\n") if l]


def main():
    args = sys.argv[1:]
    verifier = "--verifier" in args
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
    lignes = generer(build, dossier)
    if verifier:
        avant = {l.split(":", 1)[0]: l for l in lignes_actuelles()}
        apres = {l.split(":", 1)[0]: l for l in lignes}
        print("%d recettes avant, %d générées" % (len(avant), len(apres)))
        for s in sorted(set(avant) | set(apres), key=int)[:4000]:
            if avant.get(s) != apres.get(s):
                print("  avant :", avant.get(s))
                print("  après :", apres.get(s))
        return
    ecrire(build, lignes)
    print("%s : %d recettes écrites" % (FICHIER, len(lignes)))


if __name__ == "__main__":
    main()
