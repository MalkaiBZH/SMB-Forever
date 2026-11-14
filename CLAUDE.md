# CLAUDE.md

Addon World of Warcraft **GuildUpSMB** (Lua), pour le client **WoW Forever** (`## Interface: 16001`,
client 1.60.1, style Vanilla). Tout le code est dans `GuildUpSMB/`. Voir `README.md` pour les fonctionnalités.

## Conventions

- **Tout est en français** : identifiants (`Normaliser`, `Envoyer`, `MajFenetre`…), commentaires,
  textes affichés. Garder ce style, avec les accents dans les commentaires et les textes.
- Indentation par **tabulations**.
- Chaque fichier commence par un commentaire d'en-tête qui décrit le module et son protocole réseau :
  le mettre à jour quand le comportement change.
- Chaque fichier commence par `local NOM_ADDON, ns = ...`. **`ns` est la seule communication entre
  fichiers** : un module expose ses fonctions via `ns.Xxx = function…`, les autres les appellent de façon
  défensive (`if ns.Xxx then ns.Xxx() end`) car l'ordre de chargement compte.
- **Ordre de chargement** = ordre des fichiers dans `GuildUpSMB/GuildUpSMB.toc`. Tout nouveau fichier doit y être ajouté.
- **Outils communs** : `GuildUp_Outils.lua` (chargé juste après `GuildUp.lua`) contient la seule version de chaque
  petite fonction : `ns.NomCourt`, `ns.NomJoueur` (nom à afficher : « Pseudo (Prénom) » ; jamais pour chuchoter,
  inviter ou comparer), `ns.MaCle`, `ns.Maintenant` (heure du serveur), `ns.Simplifier` (recherche sans
  accents), `ns.Depuis`, `ns.Base36`, `ns.CouleurClasse` / `ns.CouleurClasseTexte`, `ns.NOMS_ROLES`, `ns.InfoObjet`,
  `ns.Precharger`, `ns.AtlasExiste`, `ns.PoserAtlas`, `ns.CadreMenu` / `ns.BoutonMenu`, `ns.BrancherDepot`,
  `ns.FenetreDeplacable`. Le cœur fournit `ns.Normaliser`, `ns.TestSolo`, `ns.Erreur`, `ns.CouperUTF8`.
  Un module les reprend en tête de fichier (`local NomCourt = ns.NomCourt`) : ne pas en recopier de version locale.
- Appels d'API défensifs : `(C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage`,
  `pcall(CreateFrame, …, "Template")` avec un modèle de repli. Le client Forever n'a pas toutes les API
  ni tous les modèles : ne pas supposer qu'une API retail existe.

## Architecture

- `GuildUp.lua` : cœur.
  - Contenu : `DEFAUT` (réglages par défaut), base `GuildUpDB`, sons, identité des joueurs et rôles (choix, annonce à la guilde), initialisation.
  - Fournit `ns.DB()`, `ns.Normaliser`, `ns.Erreur`, `ns.TestSolo`, et `ns.Coeur` (fonctions partagées avec les fichiers suivants).
- `GuildUp_Plaques.lua` : bannières derrière le nom et la barre de vie (barres de nom et cadre de cible), modèles de bannière (passés en paramètre), mise en page des barres de nom, réglages du jeu imposés (CVars), événements des barres de nom. Exporte `ns.Plaques`.
- `GuildUp_Bouton.lua` : médaillon flottant (`ns.MajBouton`), menu rapide, `ns.ChoisirRole`, bulles
  `ns.Notifier(catégorie, titre, texte, son, action)`.
- `GuildUp_Style.lua` : **kit d'interface** `ns.UI` (couleurs `UI.C`, `Bouton`, `BoutonAlerte`, `Carte`, `Rangee`,
  `Onglets`, `Puces`, `Liste`, `Champ`, `Case`, `Choix`, `Places`, `Portrait`…). Toute nouvelle interface passe par lui (style sombre et
  doré des maquettes) : pas de modèle du jeu (`UIPanelButtonTemplate`, parchemins…) dans les pages.
- `GuildUp_Interface.lua` : fenêtre principale (style sombre et doré : `Habiller`, `Bouton`, `CarteAccueil`…),
  menu des sections et page Accueil ; `ns.OuvrirInterface(page)`, `ns.MajInterface()`, `ns.NouveautesGuilde()`.
  Un module fournit sa page avec `ns.AjouterPage(id, creer)` (`creer(parent)` renvoie un cadre avec `Maj()` et
  `Ouvrir(...)`). Les sections pas encore refaites ouvrent leur ancienne fenêtre (`ouvrir` dans `SECTIONS`).
  Dans le bandeau, l'alerte « Profil incomplet » (tant que `ns.ProfilComplet()` est faux) ouvre `ns.OuvrirProfil()`.
- `GuildUp_Identite.lua` : pseudo, personnage principal et personnages (préfixe `GuildUpId`), et **profil** :
  `ns.PoserPseudo(texte, differer)` (seule validation du pseudo, aussi pour la page Options), `ns.PoserPrincipal`,
  `ns.ProfilComplet()` / `ns.ManquesProfil()` (pseudo, principal et rôle choisi à la main), fenêtre « Complète ton
  profil » `ns.OuvrirProfil()` (ouverte seule à la première ouverture de la fenêtre de la session si incomplet).
- `GuildUp_Membres.lua` : page **Guilde** (`ns.AjouterPage("guilde")`) : tous les membres de la liste de guilde
  (`ns.RosterGuilde()` et `ns.FicheMetiers(cle)` de `GuildUp_Metiers.lua`) avec ce que l'addon sait d'eux (identité,
  rôle, version `ns.VersionMembre` si fournie, métiers, distance `ns.DistanceMembre` de `GuildUp_Interface.lua`, note) ;
  liste virtuelle (seules les rangées visibles existent). `ns.MajMembres()` la rafraîchit. Vue « À suivre » (inactifs,
  sans l'addon, versions en retard) ; seul envoi : le chuchotement « Rappeler » (pas de message d'addon).
- `GuildUp_Options.lua` : fenêtre d'options, `/smb diag`, réinitialisation, commandes `/smb`.
- Les fichiers découpés accèdent à `GuildUpDB` par un mandataire `db` (même nom qu'avant) et reprennent les fonctions partagées en tête de fichier (`local Message = ns.Coeur.Message`).
- Pages de la fenêtre GuildUpSMB (chacune enregistrée par son module avec `ns.AjouterPage`), **un menu par fonction**,
  dans cet ordre (4.0.0) : Accueil (`GuildUp_Interface.lua`), Demandes (`GuildUp_Demandes.lua`), Artisanat
  (`GuildUp_Carnet.lua` : onglets Registre dans `GuildUp_Metiers.lua` et Crafts dans `GuildUp_Carnet.lua`), Quêtes
  (`GuildUp_Quetes.lua`), Guilde (`GuildUp_Membres.lua`), Jeux (`GuildUp_Tirage.lua` : onglet Tirage au sort ; un jeu de
  plus = un onglet de plus), Événements (`GuildUp_Evenements.lua`), Activité (`GuildUp_Journal.lua`), Statistiques
  (`GuildUp_Stats.lua`) ; Options (`GuildUp_Options.lua`) en bas du menu. Les anciennes fonctions `ns.Ouvrir*` /
  `ns.Basculer*` ouvrent ces pages (`ns.OuvrirInterface(page, ...)`). L'encyclopédie et l'aperçu 3D restent des
  fenêtres à part. Ne pas éparpiller : une nouvelle fonction trouve sa place dans une section existante (onglet) avant
  d'en créer une.
  Retirés : « Jouer ensemble » et « Mes carnets » en 3.7.0 (anciennes listes dans `GuildUpDB.carnets`, sans être lues) ;
  en 4.0.0, la recherche de groupe (`GuildUp_Catalogue`, `GuildUp_Groupes`, `GuildUp_GroupesFenetre`, `GuildUp_Recherche`),
  les dons et besoins (`GuildUp_Echanges`, `GuildUp_Besoins`), les projets de guilde (`GuildUp_Projets`) et les commandes
  d'artisanat (dans `GuildUp_Metiers`) : les demandes les remplacent. Leurs données sont effacées à la connexion
  (`Migrer` dans `GuildUp_Demandes.lua` ; mes anciens besoins y deviennent des demandes de ressources).
- `GuildUp_Demandes.lua` : demandes de la guilde (ressource ou artisanat), qu'un membre prend puis honore. Fournit
  aussi les outils d'objets communs (`ns.IconeObjet`, `ns.InfobulleObjet`, `ns.EcrireNomObjet`, `ns.NomMembreColore`,
  `ns.ChercherObjets`, `ns.IndexObjets`, `ns.NomObjetListe`) et la lecture des sacs et de la banque (`ns.LireConteneur`,
  `ns.SacsDeBanque`, `ns.Jai`). `ns.OuvrirDemandes(objet, genre, qte)` ouvre la page, formulaire rempli.
- `GuildUp_Reperes.lua` : repères des membres de la même carte à l'écran (HUD : au-dessus de la tête, en haut, ou au bord), calculés à partir des
  positions de `GuildUp_Carte.lua` (`ns.PositionsMembres`, `ns.MaPosition`, portrait dans le message `P`) ; pas de préfixe propre.
- `GuildUp_Cena.lua` : « Et son nom est… », musique et fête à l'écran (portrait, nom arc-en-ciel, compteur de niveau,
  confettis, feux d'artifice, bords dorés ; 4 s après le boum) à chaque montée de niveau d'un membre
  (`ns.ExplosionNiveau`, appelé par `GuildUp_Annonces.lua` ; pas de préfixe propre). **Surprise pour la guilde** : la case
  des notifications s'appelle « Surprise », `/smb cena` n'est pas dans l'aide, rien dans le `README.md`, et les notes de
  version n'en disent rien (pas même « secrète »). Musique : `media/levelup.mp3` (sample de 5 s) ; un joueur peut la
  remplacer par `Interface\AddOns\GuildUpSMB_Sons\levelup.mp3`, hors du dossier de l'addon.
- `GuildUp_Objectifs.lua` : « ! » sur les barres de nom des ennemis de quête (jaune moi, bleu groupe, vert les deux).
  Croise `ns.OBJECTIFS_QUETES` (données générées) avec le journal de quêtes, par numéro de PNJ (GUID) ; complété par
  l'infobulle du jeu (`C_TooltipInfo.GetUnit`) ; listes des coéquipiers reçues sur `PARTY` / `RAID` (`GuildUpObj`).
- `GuildUp_Config.lua` : **réglages propres à la guilde** (`ns.Config` : nom public, cri de guilde, emote animée,
  membre vedette). Chargé en premier, sans dépendance ; les autres modules le lisent via `ns.Config`.
- `GuildUp_Reseau.lua` : **tout le réseau passe par lui**.
  - `ns.EnvoyerAddon(préfixe, msg, canal, cible, { jetable = true })` : file unique, un message toutes les 0,3 s, nouvel essai si le jeu refuse, refus au-delà de 255 octets.
  - Deux voies d'envoi : les messages courants d'abord, les longs envois de rattrapage (relais à la connexion d'un membre) derrière, un toutes les 1,2 s. Un module qui met plus de trois messages du même préfixe dans la file en dix secondes est reconnu comme relais : **rien à déclarer**. `{ fond = true }` ou `{ fond = false }` force le choix ; un chuchotement d'addon n'est jamais mis en fond. Un message de fond identique envoyé il y a moins de 90 s n'est pas renvoyé (tout part sur la guilde : les autres l'ont déjà reçu).
  - `ns.Ecouter(préfixe, fonction, canaux)` : réception unique, canal `GUILD` par défaut.
  - `ns.Morceaux(mots, taille)` découpe une longue liste, `ns.Reassembleur(max)` la recompose.
  - `ns.StatsReseau()` donne les compteurs pour `/smb diag`.
  - Ne jamais appeler `SendAddonMessage` ni écouter `CHAT_MSG_ADDON` ailleurs.
- Un fichier par fonctionnalité, chacun avec **son préfixe de message d'addon** sur le canal `GUILD` :
  `GuildUpPos` (carte), `GuildUpQst` (quêtes), `GuildUpMet` (métiers), `GuildUpDem` (demandes,
  `GuildUp_Demandes.lua` : une demande entière par message, la date la plus récente gagne), `GuildUpId` (identité),
  `GuildUpAnn` (annonces), `GuildUpAid` (aide), `GuildUpVer` (version), `GuildUpGU` (emote du cri de guilde),
  `GuildUpTir` (tirage au sort, `/smb roll`), `GuildUpSdg` (sondage, `/smb sondage`, `GuildUp_Sondage.lua`),
  `GuildUpJrn` (fil d'activité et podium, `GuildUp_Journal.lua` : les autres modules y notent leurs nouvelles avec
  `ns.NoterActivite(genre, clé, valeur)`), `GuildUpSta` (statistiques de présence, `GuildUp_Stats.lua` : un relevé
  toutes les 10 min, partagé par le relais à la connexion), `GuildUpSvn` (carte des souvenirs, `GuildUp_Souvenirs.lua` :
  les grands moments de chacun, à sa position, gardés sans limite de durée, dessinés par `GuildUp_Carte.lua`),
  `GuildUpLay` (layers, `GuildUp_Layers.lua` : signature des GUID des PNJ observés, comparée entre membres de la
  même carte ; demande d'invitation en chuchotement d'addon).
  Exception : `GuildUpObj` (`GuildUp_Objectifs.lua`, « ! » des ennemis de quête) passe par `PARTY` / `RAID`.
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
- `GuildUp_Objets.lua` (noms français) et `GuildUp_Objets_enUS.lua` (noms anglais) : objets échangeables
  (`ns.DONNEES_OBJETS`) et objets liés fabricables (`ns.DONNEES_OBJETS_LIES`), même sélection dans les deux.
  Générés par `python outils/generer_objets.py <build>` depuis wago.tools (ItemSparse en `frFR` et `enUS`
  via `&locale=`, Item pour la classe ; même cache, même `--verifier`). Chaque fichier ne remplit
  `ns.DONNEES_OBJETS*` que si `GetLocale()` lui correspond (`enUS`/`enGB` → anglais, sinon français) :
  les modules consommateurs n'ont rien à savoir. Après une régénération des recettes, relancer
  `generer_objets.py` (les objets liés ne gardent que ceux fabriqués par une recette de `GuildUp_Craft.lua`).
- `GuildUp_Recettes.lua` (recettes apprises avec un plan) et `GuildUp_Sources.lua` (tiré de QuestieDB,
  GPL-3.0) : générés par l'outil d'export de l'auteur d'origine (`ns.Exporter`, `/gup export`), absent de
  ce dépôt.
- `GuildUp_ObjectifsQuetes.lua` (`ns.OBJECTIFS_QUETES` : pour chaque quête, monstres à tuer et monstres qui
  lâchent les objets demandés, dans l'ordre des objectifs du jeu) : généré par `python outils/generer_objectifs.py`
  depuis QuestieDB (`data/Forever` du dépôt Questie/QuestieDB, GPL-3.0 ; `--ref` pour une version précise,
  cache dans `outils/cache/questiedb/`, même `--verifier`). Lu par `GuildUp_Objectifs.lua`. Le même fichier contient
  `ns.DONJONS_QUETES` (quêtes de chaque donjon, par numéro de zone) et `ns.SUITES_QUETES` (suites de quêtes :
  première quête, étape, nombre d'étapes), qui ne sont plus lus depuis le retrait de « Jouer ensemble » (3.7.0) :
  à retirer de `generer_objectifs.py` à la prochaine régénération.
- Ces fichiers font plusieurs milliers de lignes : **ne pas les lire en entier**, utiliser Grep.

## Particularités de Forever

- Les noms arrivent sous la forme « Prénom Famille » ou « Prénom-Famille » : le nom de famille est à la
  place du royaume. Toujours comparer les joueurs via `ns.Normaliser` (→ `Nom-Royaume`).
- Les régions des barres de nom sont « restreintes » : impossible de mesurer (`GetTop`,
  `GetStringWidth`…). Placer uniquement par points d'ancrage.

## Tester

Pas de build ni de tests automatisés : on teste **en jeu**, après `/reload`.
- Mode Debug : mettre `afficherDebug = true` dans `GuildUpDB`
  (`WTF/Account/<compte>/SavedVariables/GuildUpSMB.lua`, jeu fermé). Les cases Debug apparaissent alors
  dans `/smb` : `test` (tout le monde compte comme membre de la guilde), `testSolo` (ses propres
  messages sont traités comme ceux d'un autre membre), `testGroupe` (bannières de groupe partout).
- `/smb diag` : diagnostic de la barre de nom de la cible.

## Version (semver) : toujours la mettre à jour

**Chaque modification poussée sur `main` monte la version**, selon le semver `MAJEUR.MINEUR.CORRECTIF` :
- **correctif** (`2.0.0` → `2.0.1`) : correction de bug, petit réglage sans nouvelle fonctionnalité ;
- **mineur** (`2.0.1` → `2.1.0`) : nouvelle fonctionnalité ou amélioration visible, compatible avec les
  versions précédentes (les autres membres de la guilde peuvent garder l'ancienne) ;
- **majeur** (`2.1.0` → `3.0.0`) : refonte importante, ou changement de protocole réseau incompatible avec
  les anciennes versions.

À chaque fois :
1. Monter `## Version` dans `GuildUpSMB/GuildUpSMB.toc`. Un suffixe `-dev` (ex. `2.0.1-dev`) empêche
   d'annoncer la version à la guilde.
2. Ajouter les nouveautés dans `GuildUp_Version.lua` (tables `ORDRE` et `NOTES`, la plus récente en premier),
   en français, du point de vue du joueur.
3. Si le changement touche les commandes ou les fonctionnalités, mettre à jour le `README.md` dans le même
   commit.

**Avant de pousser** : `python outils/annoncer_version.py --verifier`. Il vérifie que la version du `.toc` est la
première de `ORDRE` et a ses `NOTES`, que `ORDRE` ne monte que d'un cran à la fois (jamais 3.5.0 → 5.1.0), que la
version ne redescend pas, et que chaque fichier `.lua` de `GuildUpSMB/` est dans le `.toc`. GitHub refait cette
vérification à chaque push sur `main` qui touche l'addon : en cas d'échec, rien n'est annoncé et la tâche échoue.
Une version déjà poussée ne se renumérote pas : on corrige dans la suivante.

**Annonce Discord** : dès qu'un push sur `main` change la version du `.toc`, GitHub
(`.github/workflows/annonce-discord.yml`) lance `python outils/annoncer_version.py`, qui poste dans le salon
de la guilde un message par nouvelle version, avec ses lignes de `NOTES` (les passages colorés deviennent du
gras). Les notes sont donc lues telles quelles par toute la guilde : les écrire pour elle. Rien n'est envoyé
pour une version `-dev`. L'adresse du webhook est le secret `DISCORD_WEBHOOK` du dépôt : ne jamais l'écrire
dans un fichier. `python outils/annoncer_version.py --depuis 3.3.0 --essai` montre les messages sans rien envoyer.

## Programme de mise à jour (`outils/MiseAJour/`)

- Windows : `MiseAJour.cs` → `GuildUpSMB-MiseAJour.exe` (`construire.bat`), publié dans une release `miseajour-<version>`.
- Linux : `GuildUpSMB-MiseAJour.py` (Python 3.6+, bibliothèque standard seulement, minuteur systemd de l'utilisateur).
  Les joueurs l'ont tiré de `main` et il se remplace lui-même quand ce fichier change : **tout commit sur `main`
  qui le touche part chez eux**, le garder exécutable (`compile` vérifié avant remplacement) et en fins de ligne LF.
- Les deux suivent la même logique (empreinte du commit de `main` dans `GuildUpSMB/.miseajour`, synchronisation,
  conseil `/reload` ou relancer le jeu) : un changement de l'une se reporte dans l'autre.
