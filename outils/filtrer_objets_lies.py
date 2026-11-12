"""Allège GuildUp/GuildUp_Objets.lua : dans la liste des objets liés (ns.DONNEES_OBJETS_LIES), ne garde
que les objets fabriqués par une recette de GuildUp/GuildUp_Craft.lua.

Cette liste ne sert qu'au catalogue de l'onglet « Items » (GuildUp_Carnet.lua, Catalogue()), qui ne
montre de toute façon que les objets fabricables : le reste était lu au chargement puis jeté.

Usage : python outils/filtrer_objets_lies.py   (à relancer après outils/generer_craft.py)
"""
import os
import re

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CRAFT = os.path.join(RACINE, "GuildUp", "GuildUp_Craft.lua")
OBJETS = os.path.join(RACINE, "GuildUp", "GuildUp_Objets.lua")


def main():
    with open(CRAFT, encoding="utf-8") as f:
        fabriques = {int(m.group(1)) for m in re.finditer(r"^\d+:[A-Z]+:\d+:\d+:(\d+):", f.read(), re.M)}
    fabriques.discard(0)
    with open(OBJETS, encoding="utf-8") as f:
        texte = f.read()
    debut = texte.index("ns.DONNEES_OBJETS_LIES = [==[\n") + len("ns.DONNEES_OBJETS_LIES = [==[\n")
    fin = texte.index("]==]", debut)
    lignes = [l for l in texte[debut:fin].split("\n") if l]
    gardees = [l for l in lignes if int(l.split(":", 1)[0]) in fabriques]
    texte = texte[:debut] + "\n".join(gardees) + "\n" + texte[fin:]
    with open(OBJETS, "w", encoding="utf-8", newline="\n") as f:
        f.write(texte)
    print("objets liés : %d -> %d (fabricables seulement)" % (len(lignes), len(gardees)))


if __name__ == "__main__":
    main()
