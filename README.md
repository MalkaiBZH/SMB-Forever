# GuildUpSMB

Addon World of Warcraft pour le client **WoW Forever** (interface `16001`, client 1.60.1) : des outils pour
faire vivre une guilde. Version adaptée à notre guilde, à partir de GuildUp de Miko.

Tout passe par des messages d'addon invisibles sur le canal de guilde : **seuls les membres qui ont
l'addon voient et partagent ces informations**.

## Installation

Le plus simple, sous Windows : **[télécharger SMB Forever Updater](https://github.com/MalkaiBZH/SMB-Forever/releases/latest/download/GuildUpSMB-MiseAJour.exe)**
et le lancer : il installe l'addon et le tient à jour tout seul (voir ci-dessous).

À la main :

1. Copier le dossier `GuildUpSMB/` dans `World of Warcraft/<version du client>/Interface/AddOns/`.
2. Lancer le jeu (ou `/reload`) et vérifier que « SMB Forever » est coché dans la liste des addons.
3. Cliquer sur le médaillon SMB Forever (en haut à droite, déplaçable), ou taper `/smb`.

### Mise à jour automatique (Windows) : SMB Forever Updater

**SMB Forever Updater** ([`GuildUpSMB-MiseAJour.exe`](https://github.com/MalkaiBZH/SMB-Forever/releases/latest)) installe l'addon
et le garde à jour depuis la branche `main` de ce dépôt. Au premier lancement, Windows peut afficher
« Windows a protégé votre ordinateur » (programme non signé) : **Informations complémentaires**, puis
**Exécuter quand même**. Le programme vit ensuite dans la zone de notification (icône de la chope, à
côté de l'horloge) :

- il trouve le dossier `_forever_` du jeu (sinon il le demande) et vérifie au lancement puis toutes
  les 15 minutes (5 min à 1 h, réglable) ; il ne télécharge que si un nouveau commit est arrivé ;
- après une mise à jour, une notification Windows dit quoi faire : `/reload` en jeu, **relancer le
  jeu** si des fichiers ont été ajoutés ou si le `.toc` a changé, ou rien si le jeu est fermé ;
- lancé au démarrage de Windows (activé au premier lancement, décochable), il démarre directement
  dans la zone de notification ; fermer la fenêtre l'y range, « Quitter » (clic droit sur l'icône)
  l'arrête ; le relancer rouvre sa fenêtre.

Inutile de le retélécharger pour avoir les nouvelles versions de l'addon ; seule une nouvelle version
du programme lui-même passe par une nouvelle release.

Construction : `outils\MiseAJour\construire.bat` (compilateur C# fourni avec Windows, rien à installer),
puis publication du `.exe` dans une release `miseajour-<version>` marquée « latest » (le lien de
téléchargement ci-dessus suit toujours la dernière).
Réglages et journal du dernier passage : `%APPDATA%\GuildUpSMB-MiseAJour\`.

## Fonctionnalités

- **Portraits** : le médaillon des membres de la guilde (race, classe et sexe reconnus par le jeu,
  56 portraits Alliance dans `GuildUpSMB/media/portraits/`) s'affiche à gauche de leur nom, sur les barres
  de nom et le cadre de cible. Les anciennes bannières horizontales derrière le nom ne sont plus dessinées :
  sans portrait, rien derrière le nom. Lueur dorée sur la cible. `/smb medaillons` pour couper.
- **Repères dans le HUD** : les membres de la guilde présents sur la même carte ont un repère (portrait,
  prénom à la couleur de la classe, distance) toujours sur le tour de l'écran, comme dans un jeu de tir :
  en haut quand ils sont devant (dans leur direction exacte), sur les côtés quand ils sont à gauche ou à
  droite, en bas quand ils sont derrière, avec une flèche. Clic : chuchoter. Seulement les membres qui
  partagent leur position et ont un portrait. `/smb reperes` pour couper.
- **Médaillon GuildUpSMB** : bouton rond à placer où l'on veut sur l'écran (glisser), anneau à la
  couleur de son rôle, pastille des nouveautés (groupes ouverts, appels à l'aide, demandes de dons).
  Halo doré quand des groupes sont ouverts, anneau vert quand on est en attente. Clic : la fenêtre
  GuildUpSMB ; clic droit : menu rapide (rôle, partage de position, groupes, appel à l'aide, options).
- **Fenêtre GuildUpSMB** (style sombre et doré) : menu à gauche (Accueil, Guilde, Groupes, Quêtes en
  commun, Artisanat, Mes carnets, Dons, Événements, À l'aide !, Options) et choix du rôle en haut. L'accueil
  résume la guilde : membres sur ta carte, groupes ouverts (postuler en un clic), appels à l'aide,
  demandes de dons, besoins que tu sais fabriquer, avancement du dernier projet.
- **Page Guilde** : tous les membres de la guilde, en ligne et hors ligne, avec tout ce que l'addon sait
  d'eux : niveau, classe, rang, zone ou dernière connexion, pseudo et personnage principal, rôle,
  SMB Forever (et sa version), métiers et niveaux, distance s'il est sur ta carte, note de guilde.
  Recherche (nom, pseudo, zone, métier), filtres Tous / En ligne / Avec l'addon, tri (en ligne d'abord,
  par niveau, par rang). Survol : la fiche complète ; clic : chuchoter ; clic droit : chuchoter ou
  inviter dans le groupe.
  **À suivre** : les membres à relancer (inactifs depuis 30 jours ou plus, sans l'addon, version plus ancienne
  que la tienne), avec une étiquette colorée ; « Rappeler » envoie un message privé poli à un membre en ligne
  pour qu'il installe ou mette à jour SMB Forever (au plus une fois toutes les 10 minutes par joueur).
- **Profil** : tant que ton pseudo, ton personnage principal ou ton rôle (Tank, Heal ou DPS, choisi à la
  main) manque, une alerte « Profil incomplet » s'affiche en haut de la fenêtre ; elle ouvre la fenêtre
  « Complète ton profil » (qui s'ouvre aussi d'elle-même la première fois que tu ouvres la fenêtre dans
  la session). Aussi par le bouton « Mon profil » de la page Guilde.
- **Recherche de groupe de la guilde** : places Tank / Heal / DPS, groupes jusqu'à 40, et bouton
  « Rendre public » pour inscrire le groupe dans la recherche du jeu.
- **Carte de la guilde** : position des membres sur la carte du monde (partage activé par défaut,
  désactivable dans les options ou le menu rapide du médaillon). Chaque membre y apparaît avec son médaillon
  (son portrait), entouré d'un anneau à la couleur de sa classe ; un point de couleur s'il n'a pas de portrait.
  Quand plusieurs membres se chevauchent, la position la plus récente est au-dessus.
- **Quêtes en commun** : les quêtes que d'autres membres font aussi, avec « Créer un groupe ».
- **Artisanat** :
  - *Registre* des métiers et recettes de chaque membre, commande en un clic ;
  - *Items* : tous les objets fabricables, par catégorie, avec des filtres (ma classe, mon niveau, niveau requis, fabricable par la guilde) ; un clic sur un objet montre à droite qui, dans la guilde, sait le fabriquer (chuchoter, commander) ;
  - *Carnet de craft* et liste de courses (sous-recettes, sacs et banque, provenance des composants) ;
  - *Encyclopédie* des objets (Alt + clic sur un objet) ;
  - *Dons* (un hôtel des ventes gratuit), *Demandes* et *Besoins* ;
  - *Dons et besoins croisés* : quand un membre met en don un objet de tes besoins, une bulle te prévient (une seule fois par donneur et par objet ; clic : la page Dons sur cet objet). Dans l'onglet Dons, ces dons portent la marque « Dans tes besoins », passent en tête, et la case « Mes besoins » ne montre qu'eux. Dans l'onglet Besoins, chacun de tes besoins mis en don indique « donné par X » avec un bouton Demander ; dans « Besoins de la guilde », ce que tu as dans tes sacs ou ta banque est marqué « tu en as N » ;
  - *Projets de guilde* : une liste d'objets à fabriquer, découpée en tâches à prendre.
- **Annonces** en bulle : montées de niveau, nouveaux métiers, paliers de métier.
- **À l'aide !** (`/smb sos`) : appel à la guilde avec sa position.
- **Événements** : création via le calendrier du jeu et notification des nouveaux événements.
- **Identité** : un pseudo commun à tous ses personnages et son personnage principal, visibles au survol.
- **Vérification de version** : prévient quand un membre a une version plus récente.
- **Spécial guilde** (réglé dans `GuildUpSMB/GuildUp_Config.lua`) : le cri de guilde « 33 », qui fait apparaître à
  l'écran de toute la guilde deux chopes qui trinquent, et, en option, une fête quand un membre « vedette »
  monte de niveau.

## Commandes

| Commande | Effet |
|---|---|
| `/smb` | Fenêtre GuildUpSMB |
| `/smb options` | Page Options (pseudo, rôle, notifications, taille de la fenêtre…) |
| `/smb taille 1.2` | Taille de la fenêtre GuildUpSMB (de 0.7 à 1.6, 1.1 par défaut) |
| `/smb groupes` | Recherche de groupe de la guilde |
| `/smb metiers` | Registre des métiers |
| `/smb quetes` | Quêtes en commun |
| `/smb evenements` | Créer un événement de guilde |
| `/smb echanges` | Dons et besoins |
| `/smb carnet` | Carnet de craft (listes de courses) |
| `/smb encyclo` | Encyclopédie |
| `/smb items` | Tous les objets fabricables |
| `/smb projets` | Projets de guilde |
| `/smb sos` | Appeler la guilde à l'aide |
| `/smb nouveautes` | Nouveautés de la version |
| `/smb on` / `off` | Activer / couper les bannières |
| `/smb bouton` | Afficher / cacher le médaillon GuildUpSMB |
| `/smb noms` | Nom et guilde des autres joueurs |
| `/smb lueur` | Lueur derrière la bannière de la cible |
| `/smb medaillons` | Portraits des joueurs sur les bannières |
| `/smb reperes` | Membres de ta zone sur le tour de l'écran |
| `/smb annonces` | Annonces de la guilde en bulle |
| `/smb gu` | Emote du cri de guilde |
| `/smb diag` | Informations techniques à copier en cas de problème |
| `/smb debug` | Afficher / cacher la partie Debug de la fenêtre d'options |
| `/smb entree <mot>` | Noter ma position comme entrée d'un donjon (ex. `/smb entree mortemines`) |
| `/smb reset` | Réglages par défaut |

`/guildup` fonctionne comme `/smb`.

## Données enregistrées

- `GuildUpDB` (par compte) : réglages, dons, besoins, projets, identité, listes reçues des autres membres.
- `GuildUpMetiersDB` (par compte) : métiers et recettes de ses personnages et des membres de la guilde.

Les listes des membres hors ligne sont gardées et relayées par les membres connectés ; celles sans
nouvelles depuis 30 jours sont oubliées.

## Crédits

- Addon d'origine : **Miko**.
- Données d'objets et de recettes générées depuis les tables du client WoW Forever (via wago.tools).
- Provenance des composants (`GuildUp_Sources.lua`) tirée une fois de **QuestieDB** (version Forever,
  GPL-3.0) : merci à ses auteurs. GuildUpSMB n'a pas besoin de Questie pour fonctionner.
- Images (`GuildUpSMB/media/`) : bannières et anneau de Miko ; chopes du cri de guilde (`gu_emote.tga`,
  `emote_animee.tga`) dessinées pour cette version.
- Portraits (`GuildUp/media/portraits/`) : 56 médaillons Alliance (race, classe, homme et femme), nommés
  `race-classe-sexe.tga`, générés par IA (Nano Banana Pro) pour la guilde. TGA 32 bits 256×256, fond transparent.
