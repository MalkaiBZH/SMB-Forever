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
- Appels d'API défensifs : `(C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage`,
  `pcall(CreateFrame, …, "Template")` avec un modèle de repli. Le client Forever n'a pas toutes les API
  ni tous les modèles : ne pas supposer qu'une API retail existe.

## Architecture

- `GuildUp.lua` : cœur (bannières sur les barres de nom et le cadre de cible, rôles, bouton et volet de
  mini-carte, fenêtre d'options, bulles `ns.Notifier(catégorie, titre, texte, son, action)`, commandes `/smb`, `DEFAUT` = réglages par défaut).
  Fournit `ns.DB()`, `ns.Normaliser`, `ns.EnvoyerAddon` (file d'envoi : un message toutes les 0,3 s),
  `ns.Erreur`, `ns.TestSolo`.
- Un fichier par fonctionnalité, chacun avec **son préfixe de message d'addon** sur le canal `GUILD` :
  `GuildUpGrp` (groupes), `GuildUpPos` (carte), `GuildUpQst` (quêtes), `GuildUpMet` (métiers),
  `GuildUpEch` (dons), `GuildUpBes` (besoins), `GuildUpPrj` (projets), `GuildUpId` (identité),
  `GuildUpAnn` (annonces), `GuildUpAid` (aide), `GuildUpVer` (version), `GuildUpGU` (emote GU!).
- Protocoles texte : champs séparés par `~`, identifiants en base 36, **255 caractères maximum par
  message** (découpage en morceaux de 200 si besoin). Nettoyer `~` et `|` dans les textes saisis.
- Message `Q` = « renvoyez-moi vos données » à la connexion. Les listes des absents sont gardées en
  `SavedVariables` et relayées par les membres connectés ; oubli après 30 jours (`OUBLI`).

## Données générées (ne pas éditer à la main)

- `GuildUp_Objets.lua`, `GuildUp_Craft.lua`, `GuildUp_Recettes.lua` : générés depuis les tables du client
  Forever (wago.tools).
- `GuildUp_Sources.lua` : extrait une fois de QuestieDB (GPL-3.0).
- Ces fichiers font ~30 000 lignes : **ne pas les lire en entier**, utiliser Grep. L'outil d'export
  (`ns.Exporter`, `/smb export`) n'est pas dans ce dépôt.

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
