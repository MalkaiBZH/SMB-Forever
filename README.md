# GuildUp

Addon World of Warcraft pour le client **WoW Forever** (interface `16001`, client 1.60.1) : des outils pour
faire vivre une guilde. Version adaptée à notre guilde, à partir de GuildUp de Miko.

Tout passe par des messages d'addon invisibles sur le canal de guilde : **seuls les membres qui ont
l'addon voient et partagent ces informations**.

## Installation

1. Copier le dossier `GuildUp/` dans `World of Warcraft/<version du client>/Interface/AddOns/`.
2. Lancer le jeu (ou `/reload`) et vérifier que « GuildUp » est coché dans la liste des addons.
3. Taper `/smb` pour ouvrir les options, ou cliquer sur le bouton de la mini-carte.

## Fonctionnalités

- **Bannières par rôle** : bannière derrière le nom et la barre de vie des membres de la guilde
  (barres de nom et cadre de cible), selon leur rôle tank / heal / dps. Modèle orné hors groupe,
  sobre en groupe ou en raid. Lueur dorée sur la cible.
- **Bouton de mini-carte** : choix de son rôle, accès à toutes les fenêtres, notifications.
  Halo doré quand des groupes sont ouverts, anneau vert quand on est en attente.
- **Recherche de groupe de la guilde** : places Tank / Heal / DPS, groupes jusqu'à 40, et bouton
  « Rendre public » pour inscrire le groupe dans la recherche du jeu.
- **Carte de la guilde** : position des membres sur la carte du monde (partage activé par défaut,
  désactivable dans le volet de la mini-carte).
- **Quêtes en commun** : les quêtes que d'autres membres font aussi, avec « Créer un groupe ».
- **Artisanat** :
  - *Registre* des métiers et recettes de chaque membre, commande en un clic ;
  - *Carnet de craft* et liste de courses (sous-recettes, sacs et banque, provenance des composants) ;
  - *Encyclopédie* des objets (Alt + clic sur un objet) ;
  - *Dons* (un hôtel des ventes gratuit), *Demandes* et *Besoins* ;
  - *Projets de guilde* : une liste d'objets à fabriquer, découpée en tâches à prendre.
- **Annonces** en bulle : montées de niveau, nouveaux métiers, paliers de métier.
- **À l'aide !** (`/smb sos`) : appel à la guilde avec sa position.
- **Événements** : création via le calendrier du jeu et notification des nouveaux événements.
- **Identité** : un pseudo commun à tous ses personnages et son personnage principal, visibles au survol.
- **Vérification de version** : prévient quand un membre a une version plus récente.
- **Spécial guilde** : l'emote « GU! » qui monte à l'écran, et la fête quand Zaardoz Gu monte de niveau.

## Commandes

| Commande | Effet |
|---|---|
| `/smb` | Fenêtre d'options |
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
| `/smb barre` | Afficher / cacher le bouton de la mini-carte |
| `/smb noms` | Nom et guilde des autres joueurs |
| `/smb lueur` | Lueur derrière la bannière de la cible |
| `/smb annonces` | Annonces de la guilde en bulle |
| `/smb gu` | Emote « GU! » |
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
  GPL-3.0) : merci à ses auteurs. GuildUp n'a pas besoin de Questie pour fonctionner.
- Images (`GuildUp/media/`) : bannières et anneau de Miko ; l'emote « GU! » et l'animation de Zaardoz Gu
  appartiennent à la guilde et ne sont pas couvertes par la licence du code sans l'accord des personnes concernées.
- Portraits (`GuildUp/media/portraits/`) : 56 médaillons Alliance (race, classe, homme et femme), nommés
  `race-classe-sexe.tga`, générés par IA (Nano Banana Pro) pour la guilde. TGA 32 bits 256×256, fond transparent.
