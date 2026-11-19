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
  (chuchoter, inviter dans le groupe, suivre sa trace, voir dans la page Guilde). Seulement les membres qui
  partagent leur position et ont un portrait, et à plus de 100 m (réglable dans les options, 0 pour toujours). `/smb reperes` pour couper.
  **Fil d'Ariane** : « Suivre sa trace » guide vers l'étape suivante du chemin pris par le membre ces 10 dernières
  minutes (repère doré en forme d'empreintes, trace en pointillés sur la carte du monde), jusqu'à le rejoindre.
  Clic sur le repère doré : arrêter.
  **Layers** : l'addon déduit ton layer (la copie de la zone où tu es) des PNJ que tu survoles, cibles ou dont la
  barre de nom apparaît, et le partage avec la guilde. Un membre de ta zone sur un autre layer porte « autre layer »
  en orange à côté de sa distance (et dans les infobulles) ; « Demander à rejoindre son layer » (clic droit) lui
  envoie une bulle pour t'inviter dans son groupe, ce qui te fait passer sur son layer. `/smb layer` pour vérifier.
- **Ennemis de quête** : un « ! » à droite de la barre de nom d'un ennemi à tuer ou à dépouiller pour une
  quête en cours : **jaune** pour toi, **bleu** pour un membre de ton groupe, **vert** pour les deux. Il
  disparaît quand l'objectif est terminé. Les monstres de chaque quête viennent de QuestieDB (version Forever),
  croisés avec ton journal de quêtes ; les coéquipiers qui ont SMB Forever envoient au groupe la liste des
  monstres dont ils ont besoin. L'infobulle du jeu complète quand elle le peut. `/smb objectifs` pour couper
  (ou la case dans Options).
- **Médaillon GuildUpSMB** : bouton rond à placer où l'on veut sur l'écran (glisser), anneau à la
  couleur de son rôle, pastille des nouveautés (appels à l'aide, demandes que tu peux honorer, tirage au sort
  qui attend tes dés). Halo doré quand un tirage au sort t'attend. Clic : la fenêtre GuildUpSMB ; clic droit :
  menu rapide (rôle, partage de position, demandes, tirage au sort, sondage, appel à l'aide, options).
- **Fenêtre GuildUpSMB** (style sombre et doré) : un menu par fonction à gauche (Accueil, Demandes, Artisanat,
  Quêtes, WoWdex, Guilde, Jeux, Événements, Activité, Statistiques, puis À l'aide ! et Options) et choix du rôle en
  haut. L'accueil résume la guilde : membres sur ta carte, demandes que tu peux honorer (« Je m'en occupe » en
  un clic), appels à l'aide, tes demandes en cours, les deux prochains événements.
- **Demandes** (`/smb demandes`) : chacun publie ce qu'il lui faut, une *ressource* (« 20 Étoffe de lin ») ou de
  l'*artisanat* (un objet à fabriquer), avec une quantité (objet à chercher dans tout le jeu ou à glisser).
  Toute la guilde voit la liste, même quand son auteur est hors ligne. Un membre la prend (« Je m'en occupe ») :
  son nom s'affiche et l'auteur est prévenu ; puis il l'honore (« C'est fait ! », ou « Reçu ! » côté auteur)
  ou la libère. Filtres Toutes / Je peux aider / Prises par moi ; « tu en as N » (sacs et banque) et « tu sais le
  fabriquer » sur chaque demande. Bulle pour une nouvelle demande que tu peux honorer ; ligne « X demande cet
  objet » dans les infobulles d'objets. 20 demandes en cours au plus par membre ; les demandes honorées ou
  retirées sont oubliées après 3 jours, les autres après 30 jours sans changement. Les demandes honorées
  entrent dans le fil d'activité. (Remplacent depuis la 4.0.0 les dons, besoins, commandes et projets de guilde.)
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
- **Carte de la guilde** : position des membres sur la carte du monde (partage activé par défaut,
  désactivable dans les options ou le menu rapide du médaillon). Chaque membre y apparaît avec son médaillon
  (son portrait), entouré d'un anneau à la couleur de sa classe ; un point de couleur s'il n'a pas de portrait.
  Quand plusieurs membres se chevauchent, la position la plus récente est au-dessus.
- **Quêtes** : les quêtes que d'autres membres font aussi, avec « Inviter » (les membres en ligne qui ont la
  quête et ne sont pas encore avec toi ; seul, l'invitation crée le groupe), « Déjà groupés » quand ils sont tous
  dans ton groupe, « Hors ligne » quand personne n'est connecté ; « (groupe) » marque ceux qui y sont.
  Les membres les plus proches viennent en premier, avec leur distance, et les quêtes dont un membre est tout près
  remontent dans la liste. Quand un membre qui a une de tes quêtes arrive à moins de 300 m sans être dans ton groupe,
  une bulle le signale (au plus une toutes les trois minutes, jamais en instance ni en vol). Les distances viennent
  des positions déjà partagées entre membres : aucun message de plus.
- **WoWdex** (`/smb wowdex`) : le bestiaire de Forever à compléter, comme un carnet de collection. Plus de
  3 300 monstres hostiles, numérotés du plus faible au plus fort, chacun avec trois paliers : *vu* (sa barre de nom,
  ta cible ou ton survol : son nom et son modèle apparaissent, sinon « ??? »), *capturé* (vaincu par toi ou ton
  groupe) et *dépouillé* (son corps fouillé). **Les rares sont l'objectif** : le compteur de l'entête compte les
  rares, rares élites et boss capturés (400), et ils donnent ton titre de chasseur, de Novice à Légende de Forever.
  Cinq onglets :
  - *Avis de recherche* : les rares et boss en grandes cartes, avec leur modèle 3D, leur zone, et « repéré il y a
    12 min » quand un membre vient d'en voir un ;
  - *Bestiaire* : tous les monstres en cases numérotées (modèle, losange de rang, trois crans vu / capturé /
    dépouillé) ; filtres Tous / Vus / Capturés / À capturer ;
  - *Zones* : ta progression zone par zone, ses rares d'abord, avec « Tu es ici » et la part de la guilde ; un clic
    ouvre les monstres de la zone ;
  - *Carnet de chasse* : les titres et leurs seuils, ta progression par rang et par niveau, les monstres pistés, tes
    dernières captures, et les réglages des alertes et des losanges ;
  - *Guilde* : le WoWdex commun, le classement par rares capturés (avec le titre de chacun) et les premières
    captures de rares.

  La recherche (nom, zone, objet) et le choix de la zone (toutes, la mienne, celle choisie dans l'onglet Zones)
  valent pour les deux premiers onglets. La fiche d'un monstre : modèle 3D, rang, niveau, type, zones, tes paliers
  datés, le premier membre de la guilde à l'avoir capturé, le dernier repérage, et son butin, toujours visible :
  objets particuliers tirés de QuestieDB, et taux de drop de toute la guilde, mesurés à chaque corps fouillé par un
  membre (« 34 % », 212 corps fouillés par 5 membres ; le dépeçage et le vol à la tire ne comptent pas). Trois
  boutons : « Pister » (10 monstres au plus), « Sur la carte », « Lier » (dans la discussion). La recherche trouve
  aussi un objet : les monstres qui le lâchent, ceux où la guilde l'a trouvé en premier. La fiche donne aussi la
  distance de l'apparition la plus proche, et pour un rare : qui l'a repéré et quand (bouton « Y aller » pendant
  une heure : le repère du jeu est posé à cet endroit), qui l'a tué en dernier et quand. Une infobulle explique
  chaque ligne (vu, capturé, dépouillé…).

  **Rare en vue !** Quand un rare ou un rare élite que tu n'as pas capturé apparaît près de toi (barre de nom,
  cible, survol), une alerte sonne ; la guilde est prévenue, et les membres à qui il manque reçoivent une bulle
  (une fois toutes les 10 minutes par rare ; ta position n'est jointe que si tu la partages). Un monstre pisté
  déclenche la même alerte. Les rares à capturer et les monstres pistés portent un losange sur leur barre de nom.
  Un monstre absent de la liste mais croisé en jeu y entre aussi, « hors liste ». Ton WoWdex est commun à tes
  personnages ; celui de la guilde (captures, taux de drop, scores) se rattrape à la connexion. Une ligne dans la
  discussion à chaque nouvelle capture ; une bulle pour un rare ou un boss, un nouveau titre, une zone terminée, et
  tous les 25 monstres (case « WoWdex » des notifications) ; chaque rare capturé par un membre entre dans le fil
  d'activité. Infobulle des monstres : « à capturer », « Rare à capturer ! » ou « capturé ×12 ».
- **Artisanat** :
  - *Registre* des métiers et recettes de chaque membre ; clic sur une recette d'un membre : demande d'artisanat ;
  - *Crafts* : tous les objets fabricables, par catégorie, avec des filtres (ma classe, mon niveau, niveau requis, fabricable par la guilde) ; un clic sur un objet montre à droite qui, dans la guilde, sait le fabriquer (chuchoter), et « Demander » prépare une demande d'artisanat ;
  - *Encyclopédie* des objets (Alt + clic sur un objet) ; « Demander » (page Demandes) et « Voir dans Crafts » ;
    « Trouvé par la guilde » : les monstres où la guilde l'a trouvé, avec le taux (WoWdex).
- **Annonces** en bulle : montées de niveau (« Nom a up ! », avec des chopes à l'écran : 4, 8 aux paliers 10, 20,
  30… et 12 au niveau maximum ; celui qui monte voit aussi les siennes), nouveaux métiers, paliers de métier.
- **À l'aide !** (`/smb sos`) : appel à la guilde avec sa position.
- **Jeux** (`/smb jeux`) : une page, un onglet par jeu.
  - *Tirage au sort* (`/smb roll`) : à droite, on prépare le tirage (un objet glissé dans la case et / ou un lot
    écrit, les participants : une case par membre connecté, « Tout cocher », ou « Mon groupe » pour le réserver à
    son groupe ou à son raid), puis « Ouvrir le tirage ». Toute la guilde reçoit une bulle et lance les dés d'un clic
    sur la page (le `/roll` 1-100 du jeu, lu par l'addon et transmis à la guilde). À gauche, le classement en direct ;
    égalités en tête départagées par un nouveau tour, résultat annoncé en bulle. Il faut l'addon pour participer.
  - *Bizkit* (`/smb bizkit`) : jeu de dés, une table pour toute la guilde, huit places autour. On clique sur une place libre
    pour s'asseoir, puis chacun son tour (dans le sens des aiguilles d'une montre) lance deux dés : deux `/roll` 1-6
    du jeu, lus par l'addon. Tout le monde voit les dés partir de la place du lanceur et se poser au hasard sur le
    tapis, entre les joueurs. Sous la table, la case « Ce lancer » montre les dés, le lanceur et une ligne par effet
    (qui prend combien de coups, et pourquoi) ; à droite, les derniers lancers, chacun avec ses effets ; en haut, à qui le
    tour, avec le temps qui reste. Rien ne trahit un 7 : la somme du lancer en cours n'est pas affichée, les effets
    de chaque lancer n'apparaissent que 1,5 s après que les dés se sont posés, et la page
    s'ouvre (hors combat) à chaque lancer chez les joueurs assis. Chacun compte ses *coups* : 0 au départ, et le
    compteur ne fait que monter ; un coup pris fait monter « +1 » au-dessus du joueur et rougir son portrait, puis reste affiché à côté de lui
    jusqu'au lancer suivant ; le résultat d'un lancer ne s'affiche qu'une fois les dés posés. Le bouton « Bizkit ! », à côté de
    « Lancer les dés », est toujours là (un clic le crie dans la discussion de guilde) : sur un 7, tous les joueurs
    doivent cliquer, le lanceur aussi, dans n'importe quel ordre, et le dernier prend un coup ; ceux qui n'ont pas
    cliqué 10 s après en prennent un aussi. Cliquer quand les dés ne font pas 7 coûte un coup. Chaque clic fait
    apparaître une bulle « Bizkit ! » au-dessus du joueur.
    Les deux prisons sont des cachots dans les coins de la table. Un 3 (1 + 2) envoie le lanceur en *prison de 3* (barreaux orange et pastille « 3 » sur son portrait) et en fait sortir celui qui y était :
    un seul prisonnier à la fois. À chaque lancer, chaque dé qui montre un 3 lui coûte un coup (deux sur un
    double 3). Le prisonnier qui refait 3 monte d'un cran : La Prison, Prison du cuirassé, Donjon de Fort-de-Durn puis
    Prison d'Alcaz, où
    chaque 3 lui coûte 2, 3, 4 puis 5 coups (au dernier cran, il y reste). Dès qu'un autre joueur fait 3, il sort,
    quel que soit le cran, et le nouveau entre en prison de 3. Le prisonnier qui quitte la table reste en prison
    jusqu'au prochain 3. Un 5 envoie en *prison de 5* (barreaux bleus et pastille « 5 ») si elle est vide (un seul prisonnier) : tant qu'il y est,
    chaque 5 d'un autre joueur lui coûte un coup, et il n'en sort qu'en refaisant 5. On peut être dans les deux
    prisons à la fois. Un double donne autant d'*attaques* que la valeur du dé (double 1 : 7) : le lanceur clique sur
    les places des joueurs à attaquer (clic droit pour en retirer), chaque attaque coûte un coup, 7 au plus par joueur
    (celles que personne d'autre ne peut plus recevoir, le lanceur se les met lui-même) ; pendant qu'il distribue, tout
    le monde voit en direct qui va les recevoir (« +2 » sur les portraits visés) ; au double 6, il
    choisit entre 6 attaques et une relance dont la somme des dés donne les attaques. Un 9 coûte un coup au
    joueur d'avant, un 10 au lanceur, un 11 au joueur d'après. Sur un 4, un 6 ou un 8 (pas un double), le
    *vecteur* : une ligne part du plus petit dé vers le plus grand (pointillés rouges sur la table) ; si elle
    arrive près d'un joueur, il prend un coup, sinon dégâts de zone : les deux joueurs les plus proches. Les règles complètes sont
    dans l'infobulle « Les règles du Bizkit », à droite de la table.
    Le premier assis à la table vide crée la partie. Dès le premier lancer, chacun garde sa place, et qui quitte
    la table ne peut plus la rejoindre avant la partie suivante ; un prisonnier ne peut pas la quitter ; un nouveau
    joueur s'assoit quand il veut. « Nouvelle partie » remet tout le monde à 0 coup : seul le créateur de la partie
    peut la lancer (s'il a quitté la table, tous les joueurs assis le peuvent), et il devient le créateur. Un joueur qui tarde (40 s) peut être sauté par le suivant ;
    les membres déconnectés libèrent leur place, et on reprend sa place et ses coups après un `/reload`.
- **Sondage** (`/smb sondage`, ou « Sondage » dans le menu rapide du médaillon) : une question, 2 à 5 choix, 1 à
  10 minutes pour voter. Les membres connectés qui ont l'addon reçoivent une bulle et votent d'un clic ; résultats en
  direct, changement d'avis possible jusqu'à la fin, votes publics (le survol d'un choix montre qui l'a choisi),
  résultat en bulle. Un membre qui se connecte pendant le vote ne le voit pas.
- **Carte des souvenirs** : les grands moments de chaque membre (niveau 10, 20… et niveau maximum, nouveau métier,
  palier de métier, tirage gagné) sont épinglés sur la carte du monde, à l'endroit où ils sont arrivés : un anneau
  jaune (niveau), orange (métier) ou violet (tirage), avec qui, quoi et quand au survol. Gardés sans limite de durée (400 au plus) et échangés à la
  connexion. Seulement pour les membres qui partagent leur position, hors instance. `/smb souvenirs` pour les cacher.
- **Activité** (`/smb activite`) : le fil d'activité de la guilde sur 30 jours (montées de niveau, métiers, demandes
  honorées, tirages gagnés). À la connexion, une bulle « Pendant ton absence » résume ce qui a été manqué : un membre
  connecté renvoie les nouveautés à celui qui revient. À côté, le podium des 7 derniers jours (niveaux gagnés, demandes
  honorées, tirages gagnés). Le fil ne contient que ce qu'un membre en ligne avec l'addon a vu passer.
- **Statistiques** (`/smb stats`) : la présence de la guilde pour choisir le moment des sorties. Toutes les 10 minutes,
  chaque addon connecté relève le nombre de membres en ligne (liste de guilde du jeu, addon ou pas) ; les relevés sont
  gardés 8 semaines et partagés entre membres à la connexion. Semaine type (grille jours × heures), cinq meilleurs
  créneaux, membres en ligne par jour sur 28 jours, courbe d'aujourd'hui.
- **Aide** (`/smb aide`) : toutes les commandes de l'addon rangées par chapitre, avec ce que fait chacune, ses autres
  écritures et son état (activé ou désactivé) pour les interrupteurs. Case de recherche, et clic sur une ligne pour
  lancer la commande (sauf celles qui attendent une valeur et `/smb reset`, à taper à la main).
- **Ne pas déranger** (`/smb calme`, ou la case dans Options > Notifications) : coupe toutes les bulles de l'addon
  quand on veut être tranquille ; `/smb calme 30` pour trente minutes seulement. À la sortie, un message dit ce qui a
  été coupé (« 5 bulles : 2 demandes, 1 quête… ») ; rien n'est rejoué. Les autres membres voient une lune devant le
  nom dans la page Guilde et une ligne dans l'infobulle. Le mode suit aussi le `/dnd` du jeu (désactivable).
- **Événements** : les événements de la guilde et tes invitations des 30 prochains jours, groupés par jour
  (Aujourd'hui, Demain…), avec l'heure, le type (donjon ou raid), l'organisateur, le nombre d'inscrits et ton
  état en couleur. À droite, le détail (description, inscrits avec leur classe et leur état) et les réponses :
  S'inscrire / Peut-être / Se désinscrire (ou Accepter / Refuser pour une invitation), sans ouvrir le calendrier
  du jeu. Boutons « Créer un événement de guilde » et « Ouvrir le calendrier ». Une bulle prévient d'un nouvel
  événement de guilde ; un clic ouvre la page. Les deux prochains événements sont aussi rappelés sur l'accueil.
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
| `/smb demandes` | Demandes de la guilde (ressources, artisanat) |
| `/smb metiers` | Artisanat : registre des métiers |
| `/smb crafts` | Artisanat : tous les objets fabricables |
| `/smb quetes` | Quêtes en commun |
| `/smb wowdex` | WoWdex : les monstres vus, capturés et dépouillés, seul et en guilde (`dex`, `bestiaire`) |
| `/smb jeux` | Jeux de la guilde (tirage au sort, Bizkit) |
| `/smb bizkit` | Le Bizkit, jeu de dés de la guilde |
| `/smb evenements` | Créer un événement de guilde |
| `/smb encyclo` | Encyclopédie |
| `/smb sos` | Appeler la guilde à l'aide |
| `/smb activite` | Fil d'activité de la guilde et podium des 7 derniers jours |
| `/smb stats` | Statistiques de présence : semaine type et meilleurs créneaux |
| `/smb roll [objet ou mot]` | Tirage au sort de la guilde (page Jeux ; avec un objet ou un mot : le lot déjà rempli) |
| `/smb layer` | Ton layer (d'après les PNJ observés) et les membres sur le même layer ou un autre |
| `/smb souvenirs` | Montrer / cacher les souvenirs de la guilde sur la carte du monde |
| `/smb sondage` | Sondage de la guilde : celui en cours ou le dernier, sinon en poser un |
| `/smb nouveautes` | Nouveautés de la version |
| `/smb on` / `off` | Activer / couper les bannières |
| `/smb aide` | La page Aide : toutes les commandes, ce qu'elles font et leur état |
| `/smb biere` | Chope à l'écran quand un membre crie (`/smb gu` marche toujours) |
| `/smb bouton` | Afficher / cacher le médaillon GuildUpSMB |
| `/smb calme [minutes]` | Ne pas déranger : couper les bulles, la guilde le voit |
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

- `GuildUpDB` (par compte) : réglages, demandes de la guilde (`demandes`), objets de ta banque (`banque`, pour
  « tu en as N »), identité, listes reçues des autres membres, dernière version de SMB Forever vue de chaque membre
  (`versionsVues`, oubliée après 60 jours).
- `GuildUpDB.wowdex` : ton WoWdex (commun à tes personnages), tes monstres pistés et tes réglages d'alerte ;
  `GuildUpDB.wowdexGuilde` : celui de la guilde (premières captures, scores des membres, taux de butin, derniers
  repérages de rares).
- `GuildUpMetiersDB` (par compte) : métiers et recettes de ses personnages et des membres de la guilde.

Les listes des membres hors ligne sont gardées et relayées par les membres connectés ; celles sans
nouvelles depuis 30 jours sont oubliées.

## Crédits

- Addon d'origine : **Miko**.
- Données d'objets et de recettes générées depuis les tables du client WoW Forever (via wago.tools).
- Provenance des composants (`GuildUp_Sources.lua`) et objectifs des quêtes (`GuildUp_ObjectifsQuetes.lua`,
  `python outils/generer_objectifs.py`) tirés de **QuestieDB** (version Forever, GPL-3.0) :
  merci à ses auteurs. GuildUpSMB n'a pas besoin de Questie pour fonctionner.
- Bestiaire du WoWdex (`GuildUp_Bestiaire.lua`, `python outils/generer_bestiaire.py`) : monstres, niveaux, rangs,
  apparitions, butin et noms français tirés de **QuestieDB** (version Forever, GPL-3.0).
- Images (`GuildUpSMB/media/`) : anneau de Miko ; chope en bois du cri de guilde (`gu_emote.tga`,
  `emote_animee.tga`), disque de la carte (`point.tga`) et bannières au nain (`M_DC_Banner_*.tga`, qui ne sont
  plus affichées) propres à cette version.
- Portraits (`GuildUp/media/portraits/`) : 56 médaillons Alliance (race, classe, homme et femme), nommés
  `race-classe-sexe.tga`, générés par IA (Nano Banana Pro) pour la guilde. TGA 32 bits 256×256, fond transparent.
