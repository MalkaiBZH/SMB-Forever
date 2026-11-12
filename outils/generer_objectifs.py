"""Régénère GuildUpSMB/GuildUp_ObjectifsQuetes.lua : pour chaque quête de WoW Forever, les monstres à tuer et
ceux qui lâchent les objets demandés. Données tirées de la base QuestieDB (version Forever, GPL-3.0, merci à
ses auteurs) : https://github.com/Questie/QuestieDB (data/Forever/foreverQuestDB.lua et foreverItemDB.lua).

Usage :
    python outils/generer_objectifs.py [--ref REF] [--verifier]

  --ref        branche, étiquette ou commit de QuestieDB à utiliser (défaut : HEAD) ; les fichiers sont
               gardés dans outils/cache/questiedb/<ref>/ (ignoré par git) et téléchargés s'ils manquent
  --verifier   n'écrit rien : compare le résultat au fichier actuel et affiche les différences

Champs lus :
  quête (questKeys)  objectives = 10 : { creatureObjective, objectObjective, itemObjective, réputation,
                     killCreditObjective, spellObjective }
  objet (itemKeys)   npcDrops = 2 : monstres qui lâchent l'objet

Format d'une ligne (voir GuildUp_Objectifs.lua) :
    quête|tuer|butin
  tuer   objectifs « à tuer » dans l'ordre du jeu, séparés par « ; » : les monstres de chacun séparés par
         « , » (un seul en général ; plusieurs pour un objectif « crédit de mise à mort »)
  butin  objectifs « objet » dans l'ordre du jeu, séparés par « ; » : objet:monstre,monstre (rien après
         « : » si aucun monstre ne le lâche : coffre, marchand, autre quête)
Seules les quêtes qui ont au moins un monstre à tuer ou à dépouiller sont gardées.

Deux autres listes dans le même fichier (« Jouer ensemble », GuildUp_Ensemble.lua) :
  ns.DONJONS_QUETES  aire|quête,quête,…  les quêtes dont la zone (zoneOrSort = 17) est ce donjon (numéro
                     de zone AreaTable, voir DONJONS)
  ns.SUITES_QUETES   quête|racine|étape|longueur  les quêtes qui font partie d'une suite d'au moins deux
                     quêtes : première quête de la suite, rang de celle-ci (1 = la première) et nombre
                     d'étapes du plus long chemin ; la suite se lit par preQuestSingle (13, une seule quête
                     avant) et nextQuestInChain (22)
"""
import os
import sys
import urllib.request
from datetime import date

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SORTIE = os.path.join(RACINE, "GuildUpSMB", "GuildUp_ObjectifsQuetes.lua")
URL = "https://raw.githubusercontent.com/Questie/QuestieDB/{ref}/data/Forever/{fichier}"
FICHIERS = ("foreverQuestDB.lua", "foreverItemDB.lua")

# Donjons à cinq (numéro de zone AreaTable utilisé par QuestieDB pour les quêtes qui s'y passent)
DONJONS = (2437, 718, 1581, 209, 719, 717, 133, 1717, 796, 722, 1517, 978, 2100, 1417, 1584, 1583, 2557,
           2057, 2017)


# --- Lecture des tables Lua de QuestieDB (sous-ensemble : tables, nombres, chaînes, nil, booléens) ---

class Lecteur:
    def __init__(self, texte):
        self.t = texte
        self.i = 0

    def blancs(self):
        t, n = self.t, len(self.t)
        while self.i < n:
            c = t[self.i]
            if c in " \t\r\n":
                self.i += 1
            elif t.startswith("--", self.i):
                fin = t.find("\n", self.i)
                self.i = n if fin < 0 else fin + 1
            else:
                break

    def valeur(self):
        self.blancs()
        t = self.t
        c = t[self.i]
        if c == "{":
            return self.table()
        if c in "\"'":
            return self.chaine(c)
        if t.startswith("nil", self.i):
            self.i += 3
            return None
        if t.startswith("true", self.i):
            self.i += 4
            return True
        if t.startswith("false", self.i):
            self.i += 5
            return False
        debut = self.i
        while self.i < len(t) and (t[self.i].isalnum() or t[self.i] in "-+.xX"):
            self.i += 1
        mot = t[debut:self.i]
        try:
            return int(mot, 0)
        except ValueError:
            return float(mot)

    def chaine(self, q):
        self.i += 1
        morceaux = []
        t = self.t
        while True:
            c = t[self.i]
            if c == "\\":
                morceaux.append(t[self.i + 1])
                self.i += 2
            elif c == q:
                self.i += 1
                return "".join(morceaux)
            else:
                morceaux.append(c)
                self.i += 1

    def table(self):
        # renvoie un dict {clé: valeur} ; les valeurs sans clé sont numérotées à partir de 1
        self.i += 1
        res, n = {}, 0
        while True:
            self.blancs()
            if self.t[self.i] == "}":
                self.i += 1
                return res
            if self.t[self.i] == "[":
                self.i += 1
                cle = self.valeur()
                self.blancs()
                assert self.t[self.i] == "]", self.t[self.i:self.i + 40]
                self.i += 1
                self.blancs()
                assert self.t[self.i] == "=", self.t[self.i:self.i + 40]
                self.i += 1
                res[cle] = self.valeur()
            else:
                n += 1
                res[n] = self.valeur()
            self.blancs()
            if self.t[self.i] in ",;":
                self.i += 1


def liste(t):
    """table Lua (dict numéroté) -> liste Python dans l'ordre (les trous valent None)"""
    if not isinstance(t, dict):
        return []
    n = max([k for k in t if isinstance(k, int)], default=0)
    return [t.get(i) for i in range(1, n + 1)]


def lire_donnees(chemin, variable):
    texte = open(chemin, encoding="utf-8").read()
    debut = texte.index(variable + " = [[return ")
    debut = texte.index("{", debut)
    fin = texte.index("}]]", debut)
    return Lecteur(texte[debut:fin + 1]).table()


# --- Téléchargement (cache) ---

def fichiers(ref):
    dossier = os.path.join(RACINE, "outils", "cache", "questiedb", ref.replace("/", "_"))
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


# --- Construction ---

def construire(ref):
    chemin_quetes, chemin_objets = fichiers(ref)
    quetes = lire_donnees(chemin_quetes, "QuestieDB.questData")
    objets = lire_donnees(chemin_objets, "QuestieDB.itemData")
    lignes = []
    for qid in sorted(k for k in quetes if isinstance(k, int)):
        q = liste(quetes[qid])
        objectifs = liste(q[9]) if len(q) > 9 else []
        if not objectifs:
            continue
        creatures = liste(objectifs[0]) if len(objectifs) > 0 else []
        items = liste(objectifs[2]) if len(objectifs) > 2 else []
        credits = liste(objectifs[4]) if len(objectifs) > 4 else []
        tuer = []
        for o in creatures:
            o = liste(o)
            if o and isinstance(o[0], int):
                tuer.append(str(o[0]))
        for o in credits:
            o = liste(o)
            ids = [str(i) for i in liste(o[0])] if o else []
            if o and len(o) > 1 and isinstance(o[1], int) and str(o[1]) not in ids:
                ids.append(str(o[1]))
            if ids:
                tuer.append(",".join(ids))
        butin, monstres_butin = [], 0
        for o in items:
            o = liste(o)
            if not o or not isinstance(o[0], int):
                continue
            objet = liste(objets.get(o[0]))
            drops = sorted(set(i for i in liste(objet[1]) if isinstance(i, int))) if len(objet) > 1 else []
            monstres_butin += len(drops)
            butin.append("%d:%s" % (o[0], ",".join(str(i) for i in drops)))
        if not tuer and monstres_butin == 0:
            continue
        lignes.append("%d|%s|%s" % (qid, ";".join(tuer), ";".join(butin)))
    return lignes, donjons(quetes), suites(quetes)


def donjons(quetes):
    par_aire = {a: [] for a in DONJONS}
    for qid in sorted(k for k in quetes if isinstance(k, int)):
        q = liste(quetes[qid])
        zone = q[16] if len(q) > 16 else None
        if zone in par_aire:
            par_aire[zone].append(str(qid))
    return ["%d|%s" % (a, ",".join(par_aire[a])) for a in DONJONS if par_aire[a]]


def suites(quetes):
    ids = set(k for k in quetes if isinstance(k, int))
    parent = {}
    for qid in ids:
        q = liste(quetes[qid])
        avant = [i for i in liste(q[12]) if isinstance(i, int) and i in ids] if len(q) > 12 else []
        if len(avant) == 1:
            parent[qid] = avant[0]
    for qid in ids:
        q = liste(quetes[qid])
        suivante = q[21] if len(q) > 21 else None
        if isinstance(suivante, int) and suivante in ids and suivante not in parent and suivante != qid:
            parent[suivante] = qid

    def racine_et_rang(qid):
        vus, rang, cour = set(), 1, qid
        while cour in parent and parent[cour] not in vus:
            vus.add(cour)
            cour = parent[cour]
            rang += 1
        return cour, rang

    infos = {qid: racine_et_rang(qid) for qid in ids}
    longueur = {}
    for qid, (racine, rang) in infos.items():
        longueur[racine] = max(longueur.get(racine, 1), rang)
    lignes = []
    for qid in sorted(ids):
        racine, rang = infos[qid]
        if longueur[racine] >= 2:
            lignes.append("%d|%d|%d|%d" % (qid, racine, rang, longueur[racine]))
    return lignes


def contenu(ref, lignes, lignes_donjons, lignes_suites):
    return ("-- GuildUpSMB : objectifs des quêtes (monstres à tuer, monstres qui lâchent les objets demandés),\n"
            "-- quêtes de chaque donjon et suites de quêtes.\n"
            "-- FICHIER GÉNÉRÉ par outils/generer_objectifs.py : ne pas modifier à la main.\n"
            "-- Données tirées de la base QuestieDB, version Forever (GPL-3.0, merci à ses auteurs) :\n"
            "-- https://github.com/Questie/QuestieDB (data/Forever, réf. %s, le %s).\n"
            "-- Ligne : quête|tuer|butin ; tuer = objectifs « à tuer » dans l'ordre du jeu (« ; »), monstres de\n"
            "-- chacun (« , ») ; butin = objectifs « objet » dans l'ordre du jeu (« ; ») : objet:monstre,monstre.\n"
            "-- Lu par GuildUp_Objectifs.lua.\n"
            "-- DONJONS_QUETES : aire du donjon|quêtes qui s'y passent ; SUITES_QUETES : quête|première quête de la\n"
            "-- suite|étape|nombre d'étapes. Lus par GuildUp_Ensemble.lua.\n"
            "\n"
            "local NOM_ADDON, ns = ...\n"
            "\n"
            "ns.OBJECTIFS_QUETES = [==[\n%s\n]==]\n"
            "\n"
            "ns.DONJONS_QUETES = [==[\n%s\n]==]\n"
            "\n"
            "ns.SUITES_QUETES = [==[\n%s\n]==]\n") % (ref, date.today().isoformat(), "\n".join(lignes),
                                                      "\n".join(lignes_donjons), "\n".join(lignes_suites))


def main():
    args = sys.argv[1:]
    verifier = "--verifier" in args
    args = [a for a in args if a != "--verifier"]
    ref = "HEAD"
    if "--ref" in args:
        ref = args[args.index("--ref") + 1]
    lignes, lignes_donjons, lignes_suites = construire(ref)
    print("%d quêtes avec des monstres à tuer ou à dépouiller, %d donjons, %d quêtes dans une suite"
          % (len(lignes), len(lignes_donjons), len(lignes_suites)))
    if verifier:
        if not os.path.exists(SORTIE):
            print("pas de fichier actuel")
            return
        actuelles = [l for l in open(SORTIE, encoding="utf-8").read().split("\n") if l[:1].isdigit()]
        lignes = lignes + lignes_donjons + lignes_suites
        ajoutees = set(lignes) - set(actuelles)
        retirees = set(actuelles) - set(lignes)
        print("%d ligne(s) ajoutée(s), %d retirée(s)" % (len(ajoutees), len(retirees)))
        for l in sorted(ajoutees)[:20]:
            print("+", l)
        for l in sorted(retirees)[:20]:
            print("-", l)
        return
    with open(SORTIE, "w", encoding="utf-8", newline="\n") as f:
        f.write(contenu(ref, lignes, lignes_donjons, lignes_suites))
    print("écrit :", SORTIE, "(%d octets)" % os.path.getsize(SORTIE))


if __name__ == "__main__":
    main()
