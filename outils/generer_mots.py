# -*- coding: utf-8 -*-
"""Génère GuildUpSMB/GuildUp_Mots.lua : les mots français du jeu, pour le WoWTUS (GuildUp_Wowtus.lua).

Les mots sortent des fichiers de données déjà présents dans l'addon (GuildUp_Objets.lua,
GuildUp_Bestiaire.lua, GuildUp_Sources.lua) : aucune liste extérieure, aucune licence à traîner.

L'astuce du tri : dans les noms français du client, seul le premier mot porte une majuscule
(« Épée longue de fer »), alors que l'anglais resté dans les données est en Title Case et les noms
propres sont toujours capitalisés. Un mot **vu en minuscule** est donc un nom commun français.
Deux apparitions en minuscule suffisent à écarter les coquilles.

    python outils/generer_mots.py            écrit GuildUpSMB/GuildUp_Mots.lua
    python outils/generer_mots.py --verifier  compare au fichier actuel sans rien écrire
"""

import collections
import os
import re
import sys
import unicodedata

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SOURCES = ("GuildUp_Objets.lua", "GuildUp_Bestiaire.lua", "GuildUp_Sources.lua")
SORTIE = os.path.join(RACINE, "GuildUpSMB", "GuildUp_Mots.lua")

MINI, MAXI = 5, 8      # longueurs jouables : la grille va de 5 à 8 cases
MINIMUM_MINUSCULE = 2  # apparitions en minuscule exigées

# Noms propres d'Azeroth restés en minuscule dans les données (au milieu d'un nom composé, le plus
# souvent) : ils passeraient le filtre sans être des mots français.
NOMS_PROPRES = {
    "AERELLES", "AKETH", "AMESANG", "DEFIAS", "DIABLOC", "DRALAR", "ENKAN", "ETHIS", "GAJIN",
    "GALAK", "GELKIS", "GIVREFEU", "GORDOK", "GRESH", "GROSH", "HAKKARI", "HEPAH", "HURAN",
    "ICOKE", "JAGUERO", "KALDOREI", "KOLKAR", "KORWI", "KRAAL", "LALAI", "LITHUZ", "LUTJAN",
    "LUTJANS", "MACHEROC", "MAGESANG", "MAGRAM", "MAKRURA", "MAROK", "MESAS", "NAGEFEU",
    "NAGENUIT", "NILASH", "QIRAJI", "RAVARAGE", "RETHIS", "RILLA", "SAPTA", "SCORPOK", "SHIRI",
    "SKULK", "THERA", "TILAC", "VEKNISS", "VHANEL", "WATNA", "WYRMIDE", "ZHEVRA", "ZULAH",
    "ZULIEN", "ZULIENNE",
}

# Mots de grammaire : corrects, mais un mot du jour « COMME » n'amuse personne.
MOTS_OUTILS = {
    "AUSSI", "AUTRE", "AUTRES", "AVOIR", "CELUI", "CETTE", "CHAQUE", "COMME", "COMMENT",
    "DEPUIS", "DEVANT", "DONNE", "ENCORE", "ENSUITE", "ETAIT", "ETRE", "JUSQUE", "LEQUEL",
    "LEURS", "MAINTENANT", "MERCI", "MEMES", "NOTRE", "NOTRES", "PARMI", "PENDANT", "PEUT",
    "PLUSIEURS", "POURQUOI", "PRESQUE", "QUAND", "QUELQUE", "SANS", "SELON", "SERONT", "SOUS",
    "TOUJOURS", "TOUTE", "TOUTES", "TOUS", "VERS", "VIVEMENT", "VOICI", "VOILA", "VOTRE",
    "VOTRES", "VRAIMENT",
}


def sans_accent(mot):
    return "".join(c for c in unicodedata.normalize("NFD", mot) if unicodedata.category(c) != "Mn")


def blocs_de_donnees(chemin):
    """Les seuls [==[ … ]==] du fichier : les données, jamais les commentaires du code."""
    with open(chemin, "rb") as f:
        texte = f.read().decode("utf-8")
    return re.findall(r"\[==\[(.*?)\]==\]", texte, re.S)


def recolter():
    minuscules = collections.Counter()
    for nom in SOURCES:
        chemin = os.path.join(RACINE, "GuildUpSMB", nom)
        if not os.path.exists(chemin):
            sys.exit("introuvable : %s" % chemin)
        for bloc in blocs_de_donnees(chemin):
            for trouve in re.finditer(r"[A-Za-zÀ-ÿ][A-Za-zÀ-ÿ]{%d,}" % (MINI - 1), bloc):
                mot = trouve.group(0)
                if not mot[0].islower():
                    continue  # majuscule : début de nom, anglais en Title Case, ou nom propre
                nu = sans_accent(mot).upper()
                if not (nu.isascii() and nu.isalpha() and MINI <= len(nu) <= MAXI):
                    continue
                minuscules[nu] += 1
    gardes = [m for m, n in minuscules.items()
              if n >= MINIMUM_MINUSCULE and m not in NOMS_PROPRES and m not in MOTS_OUTILS]
    return sorted(gardes)


ENTETE = """\
-- GuildUpSMB : les mots du WoWTUS (GuildUp_Wowtus.lua, onglet « WoWTUS » de la page Jeux).
-- Mots français de 5 à 8 lettres, sans accents, en majuscules, tirés des données du jeu déjà
-- présentes dans l'addon (objets, bestiaire, sources) par outils/generer_mots.py : dans un nom
-- français du client, seul le premier mot porte une majuscule (« Épée longue de fer »), donc un mot
-- vu en minuscule est un nom commun français et non un nom propre ni de l'anglais en Title Case.
-- Deux apparitions en minuscule exigées ; le script écarte en plus une poignée de noms propres
-- restés en minuscule et les mots de grammaire.
-- ns.MOTS_WOWTUS : un bloc par longueur, « longueur|mots collés » (tous de la même longueur),
-- une ligne par longueur. GuildUp_Wowtus.lua le découpe puis libère le texte (ns.MOTS_WOWTUS = nil).
-- Ne pas modifier à la main : relancer python outils/generer_mots.py.
-- %d mots : %s.

local NOM_ADDON, ns = ...

ns.MOTS_WOWTUS = [==[
"""


def fabriquer(mots):
    par_longueur = collections.defaultdict(list)
    for mot in mots:
        par_longueur[len(mot)].append(mot)
    detail = ", ".join("%d de %d lettres" % (len(par_longueur[n]), n)
                       for n in range(MINI, MAXI + 1) if par_longueur[n])
    lignes = [ENTETE % (len(mots), detail)]
    for n in range(MINI, MAXI + 1):
        if par_longueur[n]:
            lignes.append("%d|%s\n" % (n, "".join(sorted(par_longueur[n]))))
    lignes.append("]==]\n")
    return "".join(lignes).replace("\n", "\r\n")


def main():
    mots = recolter()
    if len(mots) < 300:
        sys.exit("seulement %d mots : les données sources ont dû changer, vérifier le filtre" % len(mots))
    contenu = fabriquer(mots)
    if "--verifier" in sys.argv:
        ancien = open(SORTIE, "rb").read() if os.path.exists(SORTIE) else b""
        print("identique" if ancien == contenu.encode("utf-8")
              else "différent : %d mots proposés, %d octets" % (len(mots), len(contenu)))
        return
    with open(SORTIE, "wb") as f:
        f.write(contenu.encode("utf-8"))
    print("%s : %d mots, %d octets" % (SORTIE, len(mots), len(contenu)))


if __name__ == "__main__":
    main()
