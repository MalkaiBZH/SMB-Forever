# CLAUDE.md

Addon World of Warcraft **GuildUp** (Lua), pour le client **WoW Forever** (`## Interface: 16001`,
client 1.60.1, style Vanilla). Tout le code est dans `GuildUp/`. Voir `README.md` pour les fonctionnalités.

## Conventions

- **Tout est en français** : identifiants (`Normaliser`, `Envoyer`, `MajFenetre`…), commentaires,
  textes affichés. Garder ce style, avec les accents dans les commentaires et les textes.
- Indentation par **tabulations**.
- Chaque fichier commence par un commentaire d'en-tête qui décrit le module et son protocole réseau :
  le mettre à jour quand le comportement change.
- Chaque fichier commence par `local NOM_ADDON, ns = ...`. **`ns` est la seule communication entre
  fichiers** : un module expose ses fonctions via `ns.Xxx = function…`, les autres les appellent de façon
  défensive (`if ns.Xxx then ns.Xxx() end`) car l'ordre de chargement compte.
- **Ordre de chargement** = ordre des fichiers dans `GuildUp/GuildUp.toc`. Tout nouveau fichier doit y être ajouté.
- **Outils communs** : `GuildUp_Outils.lua` (chargé juste après `GuildUp.lua`) contient la seule version de chaque
  petite fonction : `ns.NomCourt`, `ns.MaCle`, `ns.Maintenant` (heure du serveur), `ns.Simplifier` (recherche sans
  accents), `ns.Depuis`, `ns.Base36`, `ns.CouleurClasse` / `ns.CouleurClasseTexte`, `ns.NOMS_ROLES`, `ns.InfoObjet`,
  `ns.Precharger`, `ns.AtlasExiste`, `ns.PoserAtlas`, `ns.CadreMenu` / `ns.BoutonMenu`, `ns.BrancherDepot`,
  `ns.FenetreDeplacable`. Le cœur fournit `ns.Normaliser`, `ns.TestSolo`, `ns.Erreur`, `ns.CouperUTF8`.
  Un module les reprend en tête de fichier (`local NomCourt = ns.NomCourt`) : ne pas en recopier de version locale.
- Appels d'API défensifs : `(C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage`,
  `pcall(CreateFrame, …, "Template")` avec un modèle de repli. Le client Forever n'a pas toutes les API
  ni tous les modèles : ne pas supposer qu'une API retail existe.

## Architecture

- `GuildUp.lua` : cœur (bannières sur les barres de nom et le cadre de cible, rôles, bouton et volet de
  mini-carte, fenêtre d'options, bulles `ns.Notifier(catégorie, titre, texte, son, action)`, commandes `/smb`, `DEFAUT` = réglages par défaut).
  Fournit `ns.DB()`, `ns.Normaliser`, `ns.Erreur`, `ns.TestSolo`.
- `GuildUp_Reseau.lua` : **tout le réseau passe par lui**.
  - `ns.EnvoyerAddon(préfixe, msg, canal, cible, { jetable = true })` : file unique, un message toutes les 0,3 s, nouvel essai si le jeu refuse, refus au-delà de 255 octets.
  - `ns.Ecouter(préfixe, fonction, canaux)` : réception unique, canal `GUILD` par défaut.
  - `ns.Morceaux(mots, taille)` découpe une longue liste, `ns.Reassembleur(max)` la recompose.
  - `ns.StatsReseau()` donne les compteurs pour `/smb diag`.
  - Ne jamais appeler `SendAddonMessage` ni écouter `CHAT_MSG_ADDON` ailleurs.
- Un fichier par fonctionnalité, chacun avec **son préfixe de message d'addon** sur le canal `GUILD` :
  `GuildUpGrp` (groupes), `GuildUpPos` (carte), `GuildUpQst` (quêtes), `GuildUpMet` (métiers),
  `GuildUpEch` (dons), `GuildUpBes` (besoins), `GuildUpPrj` (projets), `GuildUpId` (identité),
  `GuildUpAnn` (annonces), `GuildUpAid` (aide), `GuildUpVer` (version), `GuildUpGU` (emote GU!).
- Protocoles texte : champs séparés par `~`, identifiants en base 36, **255 caractères maximum par
  message** (découpage en morceaux de 200 si besoin). Nettoyer `~` et `|` dans les textes saisis.
- Message `Q` = « renvoyez-moi vos données » à la connexion. Les listes des absents sont gardées en
  `SavedVariables` et relayées par les membres connectés ; oubli après 30 jours (`OUBLI`).

## Données générées (ne pas éditer à la main)

- `GuildUp_Craft.lua` (recettes : métier, niveau requis, niveau « jaune », objet, rendement, composants) :
  généré par `python outils/generer_craft.py <build>` depuis les tables du client publiées par wago.tools
  (SkillLineAbility, SpellEffect, SpellReagents ; CSV gardés dans `outils/cache/`, ignoré par git).
  `--verifier` compare au fichier actuel sans rien écrire. Le niveau requis vaut 1 pour presque toutes
  les recettes (le client ne le renseigne pas) : l'interface affiche alors le niveau « jaune ».
- `GuildUp_Objets.lua` : objets échangeables (ItemSparse) et objets liés fabricables. Après une
  régénération des recettes, relancer `python outils/filtrer_objets_lies.py`.
- `GuildUp_Recettes.lua` (recettes apprises avec un plan) et `GuildUp_Sources.lua` (tiré de QuestieDB,
  GPL-3.0) : générés par l'outil d'export de l'auteur d'origine (`ns.Exporter`, `/gup export`), absent de
  ce dépôt.
- Ces fichiers font plusieurs milliers de lignes : **ne pas les lire en entier**, utiliser Grep.

## Particularités de Forever

- Les noms arrivent sous la forme « Prénom Famille » ou « Prénom-Famille » : le nom de famille est à la
  place du royaume. Toujours comparer les joueurs via `ns.Normaliser` (→ `Nom-Royaume`).
- Les régions des barres de nom sont « restreintes » : impossible de mesurer (`GetTop`,
  `GetStringWidth`…). Placer uniquement par points d'ancrage.

## Tester

Pas de build ni de tests automatisés : on teste **en jeu**, après `/reload`.
- Mode Debug : mettre `afficherDebug = true` dans `GuildUpDB`
  (`WTF/Account/<compte>/SavedVariables/GuildUp.lua`, jeu fermé). Les cases Debug apparaissent alors
  dans `/smb` : `test` (tout le monde compte comme membre de la guilde), `testSolo` (ses propres
  messages sont traités comme ceux d'un autre membre), `testGroupe` (bannières de groupe partout).
- `/smb diag` : diagnostic de la barre de nom de la cible.

## Publier une version

1. Monter `## Version` dans `GuildUp/GuildUp.toc`. Un suffixe `-dev` (ex. `1.6.1-dev`) empêche
   d'annoncer la version à la guilde.
2. Ajouter les nouveautés dans `GuildUp_Version.lua` (tables `ORDRE` et `NOTES`, la plus récente en premier).
