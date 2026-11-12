# GuildUp

Addon World of Warcraft pour le client **WoW Forever** (interface `16001`, client 1.60.1) : des outils pour
faire vivre une guilde. Version adaptée à notre guilde, à partir de GuildUp de Miko.

Tout passe par des messages d'addon invisibles sur le canal de guilde : **seuls les membres qui ont
l'addon voient et partagent ces informations**.

## Installation

1. Copier le dossier `GuildUp/` dans `World of Warcraft/<version du client>/Interface/AddOns/`.
2. Lancer le jeu (ou `/reload`) et vérifier que « GuildUp » est coché dans la liste des addons.
3. Taper `/gup` pour ouvrir les options, ou cliquer sur le bouton de la mini-carte.

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
- **À l'aide !** (`/gup sos`) : appel à la guilde avec sa position.
- **Événements** : création via le calendrier du jeu et notification des nouveaux événements.
- **Identité** : un pseudo commun à tous ses personnages et son personnage principal, visibles au survol.
- **Vérification de version** : prévient quand un membre a une version plus récente.
- **Spécial guilde** : l'emote « GU! » qui monte à l'écran, et la fête quand Zaardoz Gu monte de niveau.

## Commandes

| Commande | Effet |
|---|---|
| `/gup` | Fenêtre d'options |
| `/gup groupes` | Recherche de groupe de la guilde |
| `/gup metiers` | Registre des métiers |
| `/gup quetes` | Quêtes en commun |
| `/gup evenements` | Créer un événement de guilde |
| `/gup echanges` | Dons et besoins |
| `/gup carnet` | Carnet de craft (listes de courses) |
| `/gup encyclo` | Encyclopédie |
| `/gup items` | Tous les objets fabricables |
| `/gup projets` | Projets de guilde |
| `/gup sos` | Appeler la guilde à l'aide |
| `/gup nouveautes` | Nouveautés de la version |
| `/gup on` / `off` | Activer / couper les bannières |
| `/gup barre` | Afficher / cacher le bouton de la mini-carte |
| `/gup noms` | Nom et guilde des autres joueurs |
| `/gup lueur` | Lueur derrière la bannière de la cible |
| `/gup annonces` | Annonces de la guilde en bulle |
| `/gup gu` | Emote « GU! » |
| `/gup diag` | Informations techniques à copier en cas de problème |
| `/gup reset` | Réglages par défaut |

`/guildup` fonctionne comme `/gup`.

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
