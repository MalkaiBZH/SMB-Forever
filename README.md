# GuildUpSMB

Addon World of Warcraft pour le client **WoW Forever** (interface `16001`, client 1.60.1) : des outils pour
faire vivre une guilde. Version adaptée à notre guilde, à partir de GuildUp de Miko.

Tout passe par des messages d'addon invisibles sur le canal de guilde : **seuls les membres qui ont
l'addon voient et partagent ces informations**.

## Installation

Le plus simple, sous Windows : **[télécharger SMB Forever Updater](https://github.com/MalkaiBZH/SMB-Forever/releases/latest/download/GuildUpSMB-MiseAJour.exe)**
et le lancer : il installe l'addon et le tient à jour tout seul (voir ci-dessous). Sous Linux (jeu sous
Wine ou Proton), voir [la version Linux](#mise-à-jour-automatique-linux).

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

### Mise à jour automatique (Linux)

Même travail, à la façon Linux : un script Python 3 (rien d'autre à installer) lancé par un minuteur
systemd de la session, à l'ouverture de session puis toutes les 15 minutes. Dans un terminal :

```sh
curl -fsSL -o /tmp/smb-forever-maj https://raw.githubusercontent.com/MalkaiBZH/SMB-Forever/main/outils/MiseAJour/GuildUpSMB-MiseAJour.py
python3 /tmp/smb-forever-maj --installer
```

- il installe le programme dans `~/.local/bin/smb-forever-maj`, active le minuteur et fait un premier passage ;
- il cherche le dossier `_forever_` dans les préfixes Wine et Proton (Lutris, Bottles, Steam, Heroic,
  Faugus, `~/.wine`…), dans leur registre et sur leurs lecteurs ; sinon il le demande, ou
  `smb-forever-maj --jeu "<dossier _forever_>"` ;
- après une mise à jour, notification du bureau (`notify-send`) : `/reload`, relancer le jeu, ou rien
  si le jeu est fermé ;
- `smb-forever-maj` seul fait un passage en montrant le détail ; `--etat` montre le dossier du jeu, la
  version installée et le minuteur ; `--intervalle 5|15|30|60` ; `--desinstaller` retire le minuteur et
  le programme (l'addon reste) ;
- il se met à jour lui-même quand `outils/MiseAJour/GuildUpSMB-MiseAJour.py` change sur `main` : pas de
  release pour Linux.

Sans systemd, `--installer` donne la ligne à ajouter avec `crontab -e`. Réglages et journal du dernier
passage : `~/.config/GuildUpSMB-MiseAJour/`.

## Fonctionnalités

- **Portraits** : le médaillon des membres de la guilde (race, classe et sexe reconnus par le jeu,
  56 portraits Alliance dans `GuildUpSMB/media/portraits/`) s'affiche à gauche de leur nom, sur les barres
  de nom et le cadre de cible. Les anciennes bannières horizontales derrière le nom ne sont plus dessinées :
  sans portrait, rien derrière le nom. En combat (toi ou le membre), les barres de nom n'ont plus de portrait ;
  il revient à la sortie du combat. Lueur dorée sur la cible. `/smb medaillons` pour couper.
- **Repères dans le HUD** : les membres de la guilde présents sur la même carte ont un repère (portrait,
  prénom à la couleur de la classe, distance) toujours sur le tour de l'écran, comme dans un jeu de tir :
  en haut quand ils sont devant (dans leur direction exacte), sur les côtés quand ils sont à gauche ou à
  droite, en bas quand ils sont derrière, avec une flèche. Clic : chuchoter ; clic droit : menu
  (chuchoter, inviter dans le groupe, voir dans la page Guilde). Seulement les membres qui
  partagent leur position et ont un portrait, et à plus de 100 m (réglable dans les options, 0 pour toujours). `/smb reperes` pour couper.
- **Ennemis de quête** : un « ! » à droite de la barre de nom d'un ennemi à tuer ou à dépouiller pour une
  quête en cours : **jaune** pour toi, **bleu** pour un membre de ton groupe, **vert** pour les deux. Il
  disparaît quand l'objectif est terminé. Les monstres de chaque quête viennent de QuestieDB (version Forever),
  croisés avec ton journal de quêtes ; les coéquipiers qui ont SMB Forever envoient au groupe la liste des
  monstres dont ils ont besoin. L'infobulle du jeu complète quand elle le peut. `/smb objectifs` pour couper
  (ou la case dans Options).
- **Médaillon GuildUpSMB** : bouton rond à placer où l'on veut sur l'écran (glisser), anneau à la
  couleur de son rôle, pastille des nouveautés (groupes ouverts, appels à l'aide, demandes de dons).
  Halo doré quand des groupes sont ouverts, anneau vert quand on est en attente. Clic : la fenêtre
  GuildUpSMB ; clic droit : menu rapide (rôle, partage de position, groupes, appel à l'aide, options).
- **Fenêtre GuildUpSMB** (style sombre et doré) : menu à gauche (Accueil, Guilde, Groupes, Quêtes en
  commun, Artisanat, Dons, Événements, Activité, À l'aide !, Options) et choix du rôle en haut. L'accueil
  résume la guilde : membres sur ta carte, groupes ouverts (postuler en un clic), appels à l'aide,
  demandes de dons, besoins que tu sais fabriquer, avancement du dernier projet.
- **Page Guilde** : tous les membres de la guilde, en ligne et hors ligne, avec tout ce que l'addon sait
  d'eux : niveau, classe, rang, zone ou dernière connexion, pseudo et personnage principal, rôle,
  SMB Forever et sa version (verte si à jour, bleue si plus ancienne que la tienne, dorée si plus récente ;
  la dernière version vue d'un membre est gardée 60 jours, avec sa date dans l'infobulle), métiers et niveaux,
  distance s'il est sur ta carte, note de guilde. Recherche (nom, pseudo, zone, métier, version), filtres
  Tous / En ligne / Avec l'addon, tri (en ligne d'abord, par niveau, par rang, par version). Survol : la fiche complète ; clic : chuchoter ; clic droit : chuchoter ou
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
  - **Groupes programmés** : dans « Mon groupe », choisis un départ aujourd'hui ou demain (par pas de 15 min)
    au lieu de « Maintenant ». Les membres s'inscrivent à l'avance depuis Parcourir (puce « Programmés », heure
    affichée dans l'heure de chacun). Bulle 10 min avant le départ pour le chef et les inscrits, bulle « C'est
    l'heure » au chef, et bouton « Inviter tous les inscrits » (passage en raid compris). L'annonce survit à un
    /reload du chef ; elle se ferme seule 1 h après le départ si personne n'est venu.
- **Carte de la guilde** : position des membres sur la carte du monde (partage activé par défaut,
  désactivable dans les options ou le menu rapide du médaillon). Chaque membre y apparaît avec son médaillon
  (son portrait), entouré d'un anneau à la couleur de sa classe ; un point de couleur s'il n'a pas de portrait.
  Quand plusieurs membres se chevauchent, la position la plus récente est au-dessus.
- **Quêtes en commun** : les quêtes que d'autres membres font aussi, avec « Créer un groupe ». Si tu es déjà
  en groupe, le bouton devient « Inviter » (les membres en ligne qui ont la quête et ne sont pas encore avec
  toi), ou « Déjà groupés » quand ils sont tous dans ton groupe ; « (groupe) » marque ceux qui y sont.
- **Artisanat** :
  - *Registre* des métiers et recettes de chaque membre, commande en un clic ;
  - *Commandes* : les commandes reçues et passées, gardées 30 jours, avec leur état (en attente, acceptée, refusée, faite, annulée). L'artisan accepte, refuse ou marque « Fait » ; le client annule ou marque « Reçue ». Chaque changement prévient l'autre par une bulle (envoyé à son retour s'il est hors ligne). Le nombre de commandes reçues en attente s'affiche sur l'onglet ;
  - *Items* : tous les objets fabricables, par catégorie, avec des filtres (ma classe, mon niveau, niveau requis, fabricable par la guilde) ; un clic sur un objet montre à droite qui, dans la guilde, sait le fabriquer (chuchoter, commander) ;
  - *Encyclopédie* des objets (Alt + clic sur un objet) ; « Voir dans Items » montre qui sait fabriquer l'objet ;
  - *Dons* (un hôtel des ventes gratuit), *Demandes* et *Besoins* ;
  - *Dons et besoins croisés* : quand un membre met en don un objet de tes besoins, une bulle te prévient (une seule fois par donneur et par objet ; clic : la page Dons sur cet objet). Dans l'onglet Dons, ces dons portent la marque « Dans tes besoins », passent en tête, et la case « Mes besoins » ne montre qu'eux. Dans l'onglet Besoins, chacun de tes besoins mis en don indique « donné par X » avec un bouton Demander ; dans « Besoins de la guilde », ce que tu as dans tes sacs ou ta banque est marqué « tu en as N » ;
  - *Projets de guilde* : une liste d'objets à fabriquer, découpée en tâches à prendre.
- **Annonces** en bulle : montées de niveau (« Nom a up ! », avec des chopes à l'écran : 4, 8 aux paliers 10, 20,
  30… et 12 au niveau maximum ; celui qui monte voit aussi les siennes), nouveaux métiers, paliers de métier.
- **À l'aide !** (`/smb sos`) : appel à la guilde avec sa position.
- **Tirage au sort** (`/smb roll`) : un membre ouvre un tirage sur un objet ou un lot, toute la guilde reçoit une
  bulle et lance les dés d'un clic (le `/roll` 1-100 du jeu, lu par l'addon et transmis à la guilde). Classement en
  direct, égalités en tête départagées par un nouveau tour, résultat annoncé en bulle. Il faut l'addon pour participer.
  Avant l'ouverture, l'organisateur choisit qui participe : une case par membre connecté, « Tout cocher », ou
  « Mon groupe » pour réserver le tirage à son groupe ou à son raid.
- **Activité** (`/smb activite`) : le fil d'activité de la guilde sur 30 jours (montées de niveau, métiers, dons
  remerciés, tirages gagnés). À la connexion, une bulle « Pendant ton absence » résume ce qui a été manqué : un membre
  connecté renvoie les nouveautés à celui qui revient. À côté, le podium des 7 derniers jours (niveaux gagnés, dons
  remerciés, tirages gagnés). Le fil ne contient que ce qu'un membre en ligne avec l'addon a vu passer.
- **Événements** : les événements de la guilde et tes invitations des 30 prochains jours, groupés par jour
  (Aujourd'hui, Demain…), avec l'heure, le type (donjon ou raid), l'organisateur, le nombre d'inscrits et ton
  état en couleur. À droite, le détail (description, inscrits avec leur classe et leur état) et les réponses :
  S'inscrire / Peut-être / Se désinscrire (ou Accepter / Refuser pour une invitation), sans ouvrir le calendrier
  du jeu. Boutons « Créer un événement de guilde » et « Ouvrir le calendrier ». Une bulle prévient d'un nouvel
  événement de guilde ; un clic ouvre la page. Le prochain événement est aussi rappelé sur l'accueil.
- **Identité** : un pseudo commun à tous ses personnages et son personnage principal. Partout où l'addon
  affiche un membre (listes, bulles, infobulles, HUD), il apparaît sous la forme **Pseudo (Prénom)** s'il a choisi
  un pseudo (le prénom est la première partie de son nom en jeu) ; sinon sous son nom en jeu.
- **Vérification de version** : prévient quand un membre a une version plus récente.
- **Annonce sur Discord** : chaque nouvelle version est annoncée automatiquement dans le salon de la guilde,
  avec ses nouveautés (`.github/workflows/annonce-discord.yml`, `outils/annoncer_version.py`).
- **Spécial guilde** (réglé dans `GuildUpSMB/GuildUp_Config.lua`) : le cri de guilde « 33 », qui fait apparaître à
  l'écran de toute la guilde une chope en bois animée, et, en option, une fête quand un membre « vedette »
  monte de niveau.

## Commandes

| Commande | Effet |
|---|---|
| `/smb` | Fenêtre GuildUpSMB |
| `/smb options` | Page Options (pseudo, rôle, notifications, taille de la fenêtre, taille des membres sur la carte, hauteur et distance minimale des repères…) |
| `/smb taille 1.2` | Taille de la fenêtre GuildUpSMB (de 0.7 à 1.6, 1.1 par défaut) |
| `/smb groupes` | Recherche de groupe de la guilde |
| `/smb metiers` | Registre des métiers |
| `/smb quetes` | Quêtes en commun |
| `/smb evenements` | Créer un événement de guilde |
| `/smb echanges` | Dons et besoins |
| `/smb encyclo` | Encyclopédie |
| `/smb items` | Tous les objets fabricables |
| `/smb projets` | Projets de guilde |
| `/smb sos` | Appeler la guilde à l'aide |
| `/smb activite` | Fil d'activité de la guilde et podium des 7 derniers jours |
| `/smb roll [objet ou mot]` | Tirage au sort de la guilde (sans rien : rouvrir la fenêtre du tirage) |
| `/smb nouveautes` | Nouveautés de la version |
| `/smb on` / `off` | Activer / couper les bannières |
| `/smb bouton` | Afficher / cacher le médaillon GuildUpSMB |
| `/smb noms` | Nom et guilde des autres joueurs |
| `/smb objectifs` | « ! » sur les ennemis de quête |
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

- `GuildUpDB` (par compte) : réglages, dons, besoins, projets, identité, listes reçues des autres membres,
  dernière version de SMB Forever vue de chaque membre (`versionsVues`, oubliée après 60 jours),
  groupes programmés (`groupesProgrammes` : ton annonce programmée, ses inscrits et tes inscriptions, oubliés
  1 h après le départ).
- `GuildUpMetiersDB` (par compte) : métiers et recettes de ses personnages et des membres de la guilde.

Les listes des membres hors ligne sont gardées et relayées par les membres connectés ; celles sans
nouvelles depuis 30 jours sont oubliées.

## Crédits

- Addon d'origine : **Miko**.
- Données d'objets et de recettes générées depuis les tables du client WoW Forever (via wago.tools).
- Provenance des composants (`GuildUp_Sources.lua`) et objectifs des quêtes (`GuildUp_ObjectifsQuetes.lua`,
  `python outils/generer_objectifs.py`) tirés de **QuestieDB** (version Forever, GPL-3.0) :
  merci à ses auteurs. GuildUpSMB n'a pas besoin de Questie pour fonctionner.
- Images (`GuildUpSMB/media/`) : anneau de Miko ; chope en bois du cri de guilde (`gu_emote.tga`,
  `emote_animee.tga`), disque de la carte (`point.tga`) et bannières au nain (`M_DC_Banner_*.tga`, qui ne sont
  plus affichées) propres à cette version.
- Portraits (`GuildUp/media/portraits/`) : 56 médaillons Alliance (race, classe, homme et femme), nommés
  `race-classe-sexe.tga`, générés par IA (Nano Banana Pro) pour la guilde. TGA 32 bits 256×256, fond transparent.
