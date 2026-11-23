-- GuildUpSMB : le Bizkit, jeu de dés de la guilde (onglet « Bizkit » de la page Jeux, /smb bizkit, préfixe "GuildUpBzk").
-- Une table ovale pour toute la guilde, huit places autour. Un membre clique sur une place libre pour
-- s'asseoir (ou changer de place), « Quitter la table » pour se lever.
-- La partie : le premier qui s'assoit à la table vide la crée (ou celui qui lance « Nouvelle partie »). Elle
-- est en cours dès son premier lancer : les joueurs assis ne changent plus de place, et qui quitte la table
-- (« D ») ne peut plus la rejoindre avant la partie suivante ; un nouveau joueur s'assoit quand il veut. Un
-- prisonnier (prison de 3 ou de 5) ne peut pas quitter la table. Seul le créateur lance une nouvelle partie,
-- sauf s'il n'est plus assis : alors tous les joueurs assis le peuvent. La table vide, la partie est finie. Chacun a son compteur de coups : 0 au départ,
-- il ne fait que monter (seule une nouvelle partie le remet à 0).
-- Chacun son tour, dans l'ordre des places (sens des aiguilles d'une montre), le joueur lance deux dés :
-- l'addon fait deux /roll 1-6 du jeu (le hasard vient du serveur, les joueurs à côté le voient passer dans
-- leur discussion), lit les deux résultats (ns.LireMonJet de GuildUp_Tirage.lua) et les envoie à la guilde avec
-- l'endroit où les dés se posent, tiré au hasard sur le tapis, entre les joueurs. Tout le monde voit les dés
-- partir de la place du lanceur, rouler et se poser au même endroit.
-- Le Bizkit : le bouton « Bizkit ! » est toujours là, à côté de « Lancer les dés », et ne change pas
-- d'aspect (rien ne trahit un 7). Un clic crie « Bizkit ! » dans la discussion de guilde. Quand les dés font
-- 7, tous les joueurs assis doivent cliquer, le lanceur comme les autres, dans n'importe quel ordre : le
-- dernier prend un coup. Dès qu'il ne reste qu'un joueur qui n'a pas cliqué, c'est lui le dernier : il prend
-- son coup sans attendre (seul à la table, il est le dernier). Ceux qui n'ont pas cliqué au bout de DELAI_COURSE
-- secondes prennent tous un coup (c'est le lanceur qui l'annonce, « P »). Un clic alors que les dés posés ne font pas
-- 7 coûte un coup (une fois par lancer). Le bouton attend que les dés soient posés. Pendant un Bizkit,
-- personne ne lance ; ensuite le tour passe au joueur suivant.
-- La prison de 3 : un lancer qui fait 3 (1 + 2) envoie le lanceur en prison de 3, et en fait sortir celui qui
-- y était (un seul prisonnier à la fois). À chaque lancer, de n'importe quel joueur (le prisonnier compris),
-- chaque dé qui montre un 3 donne un coup au prisonnier : deux coups sur un double 3. Le prisonnier qui
-- refait 3 monte d'un cran (PRISONS : La Prison, Prison du cuirassé,
-- Donjon de Fort-de-Durn, Prison d'Alcaz) et chaque 3 lui coûte alors
-- autant de coups que le numéro du cran (2, 3, 4, 5) ; au dernier cran, il y reste. Quand un autre joueur
-- fait 3, le prisonnier sort, quel que soit le cran, et le nouveau entre au premier (prison de 3). Le
-- prisonnier qui se lève reste en prison : seul un autre 3 l'en fait sortir.
-- La prison de 5 : un lancer qui fait 5 envoie le lanceur en prison de 5 si elle est vide (un seul
-- prisonnier de 5 à la fois). Tant qu'il y est, chaque 5 d'un autre joueur lui coûte un coup, et ce joueur
-- reste libre. Le prisonnier de 5 en sort en refaisant 5 à son tour. Elle est indépendante de la prison de 3
-- (on peut être dans les deux), et le prisonnier de 5 qui se lève y reste aussi.
-- Les doubles : le lanceur distribue autant d'attaques que la valeur du dé (double 1 : 7 attaques) aux autres
-- joueurs assis, comme il veut (clic sur une place : une attaque, clic droit : en retirer une) ; chaque
-- attaque coûte un coup. Double 6 : au choix, 6 attaques, ou une relance dont la somme des dés donne le
-- nombre d'attaques (la relance ne déclenche aucune autre règle). Au plus MAX_PAR_JOUEUR attaques sur un
-- même joueur : celles que personne d'autre ne peut plus recevoir, le lanceur se les met à lui-même (seul à
-- la table : toutes). Il a DELAI_ATTAQUE secondes : ensuite, les attaques déjà placées partent (et celles
-- pour lui), les autres sont perdues. Pendant les attaques, personne ne lance. Tout le monde voit en direct
-- où elles vont (« +2 » sur les portraits visés, « V »).
-- Le 9, le 10 et le 11 (somme des dés) : 9, le joueur assis avant le lanceur (celui qui a joué avant lui)
-- prend un coup ; 10, le lanceur prend un coup ; 11, le joueur assis après lui prend un coup. Seul à la
-- table, le 9 et le 11 ne coûtent rien.
-- Le vecteur : un lancer qui n'est pas un double et dont la somme ne déclenche rien (4, 6 ou 8 ; un dé qui
-- montre un 3 et coûte au prisonnier de 3 ne compte pas comme un effet) trace une ligne du plus petit dé vers
-- le plus grand : si son point d'arrivée tombe près d'un joueur assis (moins de TOUCHE pixels, le lanceur
-- compris), ce joueur prend un coup ; sinon, dégâts de zone : les deux joueurs les plus proches prennent un
-- coup. Chacun fait le calcul avec les positions des dés reçues : tous trouvent les mêmes.
-- Un lancer en rappel (« ~1 ») ne change ni les prisons ni les coups.
-- Affichage : tant que les dés roulent, la page montre l'état d'avant le lancer (coups, prisons, derniers
-- lancers, effets) ; les dés se montrent une fois posés, et les effets du lancer (coups, prisons, lignes
-- d'effets, vecteur) DELAI_EFFETS secondes plus tard, pour tous les lancers : le 7 est le seul lancer sans
-- effet, son absence d'effet ne doit pas le trahir avant que chacun ait pu lire les dés. Les coups pris depuis le dernier
-- lancer restent affichés sur la place de chacun (« +2 ») jusqu'au lancer suivant. Chaque cri « Bizkit ! »
-- fait apparaître une bulle au-dessus de la place du joueur qui a cliqué.
-- La page : l'état (à qui le tour, mes attaques, mon cri, avec le temps qui reste) dans l'en-tête ; les deux
-- prisons en cachots dans les coins du haut (prisonnier, crans) ; sous la table, la case « Ce lancer » (dés,
-- lanceur, et une ligne par effet : chaque lancer garde ses effets, voir Effet) ; à droite, les derniers
-- lancers, chacun avec ses effets en dessous. Rien ne trahit un 7 : pas de somme pour le lancer en cours,
-- pas de ligne « Bizkit » avant la fin de la course, l'état ne change qu'après mon cri, le cadre doré du
-- joueur suivant reste allumé et son bouton « Lancer les dés » aussi (un clic est alors sans effet). La page
-- s'ouvre (hors combat) à chaque lancer chez les joueurs assis.
-- Tout changement est appliqué à la réception, mes messages compris (le serveur les renvoie à tous dans le
-- même ordre) : si deux membres prennent la même place en même temps, le premier arrivé l'a, et l'ordre
-- des cris est celui de leur arrivée.
--   "A~place"                   je m'assois à cette place (1 à 8) ; déjà assis ailleurs : je change de place
--   "A~place~derniere~points~prisonnier~cran~prisonnier5"  réponse à « Q » ou retour après un /reload : ma
--                               place, la place du dernier lanceur que je connais (ou vide), mes points à
--                               l'ancienne (ANCIEN_DEPART moins mes coups, pas sous 0 : pour les versions d'avant
--                               les coups, qui partaient de ANCIEN_DEPART points ; suivi de « C »), la clé
--                               du prisonnier de 3 et son cran (1 à 5), la clé du prisonnier de 5 (vides s'il n'y
--                               en a pas) ; adoptés par qui ne les connaît pas
--   "D"                         je me lève (refusé pour un prisonnier)
--   "G~créateur~en cours~clé,clé…"  l'état de la partie (créateur, 1 si en cours, ceux qui l'ont quittée),
--                               envoyé avec la réponse à « Q » par le joueur de la première place occupée ;
--                               adopté par qui ne connaît pas la partie depuis sa création
--   "L~id~d1~d2~x1~y1~a1~x2~y2~a2[~1]"  mon lancer : id = heure du serveur en base 36 ; d1, d2 de 1 à 6 ;
--                               x, y de 0 à 200 (100 = centre du tapis) ; a = angle du dé en degrés ;
--                               « ~1 » = rappel pour qui vient d'ouvrir la table (ni Bizkit, ni prison, ni coups)
--   "B~id"                      je crie « Bizkit ! » (id = celui du lancer qui a fait 7)
--   "P~id~clé,clé…"             le lanceur annonce ceux qui n'ont pas crié à temps : ils prennent un coup
--   "R~id~d1~d2~x1~y1~a1~x2~y2~a2"  relance d'un double 6 (id = celui du double) : la somme = les attaques
--   "V~id~clé:n,clé:n…"         pendant ma distribution, où vont mes attaques pour l'instant (sans celles
--                               pour moi) : affiché chez les autres, ne compte pas ; un message au plus toutes
--                               les VISEE secondes (les versions d'avant l'ignorent)
--   "T~id~clé:n,clé:n…"         mes attaques (id = celui du double) : chaque joueur cité prend n coups
--   "C~n"                       mes coups, juste après « A » (adoptés par qui ne les connaît pas, ou ne les
--                               connaît que par le champ « points » de « A » ; les versions d'avant l'ignorent)
--   "N"                         nouvelle partie : tous les joueurs repartent à 0 coup, prisons vides ; seul le
--                               créateur de la partie l'envoie, sauf s'il n'est plus assis ; je deviens le créateur
--   "J~n"                       j'appelle la guilde à la table (bouton « Appeler la guilde », assis, une place libre,
--                               un appel toutes les DELAI_APPEL secondes) ; n = joueurs assis ; chez qui n'est pas
--                               assis : bulle « tirages » avec SON_APPEL (après le combat s'il est en combat), un
--                               clic ouvre la table ; pastilles du médaillon et du menu Jeux (ns.BizkitEnAttente) et
--                               bouton « J'arrive ! » pendant DUREE_APPEL, tant qu'il reste une place et que
--                               l'appelant n'a pas quitté la table (les versions d'avant l'ignorent)
--   "I~clé"                     « J'arrive ! » en réponse à l'appel de clé : bulle chez lui, « 3 / 8 · Nom arrive »
--                               sur la table de tous jusqu'à ce que j'y sois assis (au plus DUREE_APPEL)
--   "Q"                         j'ouvre la table : les membres assis renvoient « A~place~derniere~points » et
--                               « C~coups », et
--                               l'auteur du dernier lancer le renvoie en rappel (même id : déjà vu, ignoré)
-- C'est au tour du joueur assis après le dernier lanceur ; sans lancer connu, de la première place occupée.
-- Un joueur qui tarde (TARDE secondes) peut être sauté : le suivant peut lancer à sa place. Les places des
-- membres déconnectés sont libérées. Ma place et mes coups sont notés dans GuildUpDB (db.bizkit) pour les
-- reprendre après un /reload ; le reste n'est pas gardé d'une session à l'autre.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpBzk"
local PLACES = 8
local ANCIEN_DEPART = 30     -- avant les coups, chacun partait de 30 points (champ « points » de « A »)
-- les crans de la prison : un prisonnier qui refait 3 monte d'un cran ; chaque 3 coûte le numéro du cran
-- (les prisons du jeu, d'après la table des lieux du client : AreaTable 717, 515, 275, 16620)
local PRISONS = { "Prison de 3", "La Prison", "Prison du cuirassé", "Donjon de Fort-de-Durn", "Prison d'Alcaz" }
local CRI = "Bizkit !"
local DELAI_COURSE = 10      -- secondes, après le cri, pour que tous les joueurs crient
local SANS_NOUVELLES = 10    -- secondes de plus sans nouvelles du lanceur : le Bizkit est abandonné
local DELAI_ATTAQUE = 60     -- secondes pour distribuer les attaques d'un double
local ATTENTE_DES = 5        -- secondes pour lire mes deux /roll
local TARDE = 40             -- secondes avant que le suivant puisse lancer à la place d'un joueur qui tarde
local HISTORIQUE = 14        -- lancers et Bizkit gardés dans la liste
local REPRISE = 10 * 60      -- après un /reload ou une reconnexion, je reprends ma place si je l'ai quittée depuis moins que ça
local DUREE_ROULE = 0.9      -- secondes de l'animation des dés
local DUREE_BULLE = 4        -- secondes de la bulle « Bizkit ! » au-dessus du joueur qui crie
local DELAI_EFFETS = 1.5     -- secondes, après que les dés se posent, avant de montrer les effets du lancer
                             -- (pour tous les lancers : un 7, seul lancer sans effet, ne doit pas se voir à ça)
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\"
local TABLE = MEDIA .. "table_des"
local FACE = MEDIA .. "de"   -- de1 à de6

-- dimensions de la table à l'écran (image 512 x 256) ; le tapis vert en occupe 90 % en largeur, 80 % en hauteur
local LARGEUR_TABLE, HAUTEUR_TABLE = 340, 170
local RX, RY = LARGEUR_TABLE / 2 * 0.88, HAUTEUR_TABLE / 2 * 0.78
local TAILLE_DE = 26
local TAILLE_PLACE = 44
local ECART_PLACE = 36       -- distance entre le bord de la table et le centre d'une place
local TOUCHE = 40            -- vecteur : un joueur est touché seul si la ligne arrive à moins de ça (pixels) de lui ;
                             -- plus loin de tout le monde, dégâts de zone sur les deux plus proches
local MAX_PAR_JOUEUR = 7     -- doubles : au plus 7 attaques sur un même joueur
local VISEE = 0.4            -- doubles : au plus un « V » (où vont mes attaques) toutes les VISEE secondes
local DELAI_APPEL = 120      -- secondes entre deux appels à la guilde d'un même joueur (« J »)
local DUREE_APPEL = 300      -- secondes pendant lesquelles un appel reçu reste affiché (pastilles, « J'arrive ! »)
local SON_APPEL = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\TheHordeFlagIsTaken.mp3" -- (absent : son discret)

local Normaliser = ns.Normaliser
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local NomCourt = ns.NomCourt
local MaCle = ns.MaCle
local Base36 = ns.Base36
local Erreur = ns.Erreur

local places = {}            -- [place] = clé du membre assis
local coups = {}             -- [clé] = coups pris par le joueur (gardés s'il se lève, pour la session)
local devines = {}           -- [clé] = vrai : ses coups ne viennent que du champ « points » de « A » (en attente de « C »)
local derniere               -- place du dernier lanceur (le tour passe au suivant)
local dernierLancer          -- le dernier lancer reçu (voir Recevoir, genre « L »)
local historique = {}        -- lancers et Bizkit, le plus récent en premier
local bizkit                 -- le Bizkit en cours (voir NouveauBizkit)
local prison                 -- clé du joueur en prison de 3
local cran = 1               -- son cran dans PRISONS (1 = prison de 3)
local prison5                -- clé du joueur en prison de 5
local attaque                -- les attaques d'un double en cours (voir NouvelleAttaque)
local createur               -- qui a créé la partie (premier assis à la table vide, ou « N »)
local enCours = false        -- un lancer depuis sa création : places bloquées, qui part ne revient pas
local partis = {}            -- [clé] = vrai : a quitté la table pendant la partie, n'y revient pas avant la suivante
local partieSure = false     -- je connais la partie depuis sa création (sinon, « G » me l'apprend)
local tourCle                -- membre dont c'est le tour, et depuis quand
local debutTour = 0
local attente                -- { limite, valeurs } : j'ai lancé, j'attends mes deux /roll
local demande = false        -- « Q » déjà envoyé cette session
local vue                    -- l'onglet (créé à la première ouverture)
local pertes = {}            -- [clé] = coups pris depuis le dernier lancer (affichés sur sa place jusqu'au suivant)
local cris = {}              -- [clé] = GetTime() de son dernier cri « Bizkit ! » (bulle au-dessus de sa place)
local finRoule = 0           -- GetTime() où les dés qui roulent à l'écran se posent
local avant                  -- l'état d'avant ce lancer, affiché tant que les dés roulent (voir Animer)
local appel                  -- le dernier appel reçu : { qui, n = joueurs assis, debut = GetTime(), repondu, bulle }
local arrivent = {}          -- [clé] = GetTime() : membres qui ont répondu « J'arrive ! » (affichés sur la table)
local Maj = function() end
local Animer = function() end
local Toucher = function() end -- (animation des coups pris sur la place du joueur)

local function DB() return (ns.DB and ns.DB()) or {} end
-- (jamais en fond : la voie lente du réseau ne renvoie pas un message identique, or « A~3 » peut revenir)
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD", nil, { fond = false }) end end
local function Son(nom) if ns.Son then ns.Son(nom) end end

-- les dés roulent encore à l'écran : rien du résultat ne doit se voir
local function DesEnRoute() return GetTime() < finRoule end

-- les effets du lancer ne se montrent pas encore (dés qui roulent, puis DELAI_EFFETS)
local function EffetsCaches() return GetTime() < finRoule + DELAI_EFFETS end

-- fn tout de suite, ou quand les effets du lancer se montrent
local function ApresEffets(fn)
	local reste = finRoule + DELAI_EFFETS - GetTime()
	if reste > 0 and C_Timer then C_Timer.After(reste, fn) else fn() end
end

--------------------------------------------------------------------------------
-- Places, coups et tour de jeu
--------------------------------------------------------------------------------

local function PlaceDe(cle)
	if not cle then return nil end
	for i = 1, PLACES do
		if places[i] == cle then return i end
	end
end

local function Assis()
	local n = 0
	for i = 1, PLACES do
		if places[i] then n = n + 1 end
	end
	return n
end

local function Coups(cle) return coups[cle] or 0 end

-- la première place occupée après la place p, dans l'ordre des places (p elle-même en dernier)
local function Suivante(p)
	for k = 1, PLACES do
		local i = (p + k - 1) % PLACES + 1
		if places[i] then return i end
	end
end

-- centre d'une place, en pixels par rapport au centre de la table, y vers le haut (place 1 en bas, puis
-- dans le sens des aiguilles d'une montre)
local function PositionPlace(i)
	local angle = math.rad(-90 - (i - 1) * 45)
	return (LARGEUR_TABLE / 2 + ECART_PLACE) * math.cos(angle), (HAUTEUR_TABLE / 2 + ECART_PLACE) * math.sin(angle)
end

-- centre du dé k d'un lancer, dans le même repère (coordonnées reçues : x vers la droite, y vers le bas)
local function PositionDe(l, k)
	return l["x" .. k] * RX, -l["y" .. k] * RY
end

-- Le vecteur : une ligne part du plus petit dé, passe par le plus grand et continue jusqu'au cercle des
-- places ; le joueur assis le plus près du point d'arrivée est visé s'il en est à moins de TOUCHE pixels,
-- sinon dégâts de zone : les deux plus près sont visés (seul à la table : lui). Renvoie les clés visées et
-- le tracé { ox, oy, px, py } (du centre du petit dé au point d'arrivée), ou rien.
local function Vecteur(l)
	local petit, grand = 1, 2
	if l.d2 < l.d1 then petit, grand = 2, 1 end
	local ox, oy = PositionDe(l, petit)
	local gx, gy = PositionDe(l, grand)
	local ux, uy = gx - ox, gy - oy
	local long = math.sqrt(ux * ux + uy * uy)
	if long < 0.001 then return nil end
	ux, uy = ux / long, uy / long
	-- point d'arrivée : l'ellipse des places, (x / A)² + (y / B)² = 1, devant le petit dé
	local A, B = LARGEUR_TABLE / 2 + ECART_PLACE, HAUTEUR_TABLE / 2 + ECART_PLACE
	local a = (ux / A) ^ 2 + (uy / B) ^ 2
	local b = 2 * (ox * ux / (A * A) + oy * uy / (B * B))
	local c = (ox / A) ^ 2 + (oy / B) ^ 2 - 1
	local t = (-b + math.sqrt(math.max(0, b * b - 4 * a * c))) / (2 * a)
	local px, py = ox + t * ux, oy + t * uy
	-- les joueurs assis, du plus proche au plus loin du point d'arrivée
	local proches = {}
	for i = 1, PLACES do
		if places[i] then
			local sx, sy = PositionPlace(i)
			proches[#proches + 1] = { cle = places[i], d = math.sqrt((px - sx) ^ 2 + (py - sy) ^ 2) }
		end
	end
	if #proches == 0 then return nil end
	table.sort(proches, function(x, y) return x.d < y.d end)
	local vises = { proches[1].cle }
	if proches[2] and proches[1].d >= TOUCHE then vises[2] = proches[2].cle end
	return vises, { ox = ox, oy = oy, px = px, py = py }
end

-- la première place occupée avant la place p (p elle-même en dernier)
local function Precedente(p)
	for k = 1, PLACES do
		local i = (p - k - 1) % PLACES + 1
		if places[i] then return i end
	end
end

local function PlaceDuTour() return Suivante(derniere or 0) end

-- le tour a changé de joueur : le compte à rebours de TARDE repart
local function NoterTour()
	local p = PlaceDuTour()
	local cle = p and places[p]
	if cle ~= tourCle then
		tourCle = cle
		debutTour = GetTime()
	end
end

-- le joueur du tour tarde : le suivant peut lancer à sa place
local function Tarde()
	local tour = PlaceDuTour()
	return tour ~= nil and Assis() > 1 and GetTime() - debutTour > TARDE, tour
end

-- malgreBizkit : comme s'il n'y avait pas de Bizkit en cours (le bouton « Lancer les dés » ne doit pas
-- s'éteindre sur un 7 avant que j'aie crié : un clic est alors sans effet)
local function PeutLancer(malgreBizkit)
	local mienne = PlaceDe(MaCle())
	if not mienne or attente or (bizkit and not malgreBizkit) or attaque then return false end
	local tarde, tour = Tarde()
	return tour == mienne or (tarde and Suivante(tour) == mienne)
end

-- ma place et mes coups, pour les reprendre après un /reload
local function NoterMaPlace(place)
	DB().bizkit = place and { place = place, quand = ns.Maintenant(), coups = Coups(MaCle()) } or nil
end

-- pourquoi ce joueur ne peut pas s'asseoir à une place libre (rien : il peut)
local function RefusPlace(cle)
	if not enCours then return nil end
	if partis[cle] then return "Tu as quitté cette partie : tu pourras revenir à la prochaine" end
	if PlaceDe(cle) then return "Pendant la partie, chacun garde sa place" end
end

-- pourquoi ce joueur ne peut pas quitter la table (rien : il peut)
local function RefusDepart(cle)
	if cle == prison or cle == prison5 then return "En prison : tu restes à table" end
end

-- ce joueur peut-il lancer une nouvelle partie ? Assis, et créateur (ou le créateur n'est plus assis)
local function PeutRelancerPartie(cle)
	return PlaceDe(cle) ~= nil and (not createur or createur == cle or not PlaceDe(createur))
end

-- la table s'est vidée : la partie est finie (le prochain assis en crée une)
local function VerifierTableVide()
	if Assis() == 0 then createur, enCours, partis, partieSure = nil, false, {}, true end
end

-- « A » : mes points à l'ancienne, pour les versions d'avant les coups
local function AnciensPoints(cle) return math.max(0, ANCIEN_DEPART - Coups(cle)) end

-- n coups de plus pour ce joueur
local function Encaisser(cle, n)
	coups[cle] = Coups(cle) + n
	pertes[cle] = (pertes[cle] or 0) + n
	Toucher(cle, n)
	if cle == MaCle() then
		local mienne = PlaceDe(cle)
		if mienne then NoterMaPlace(mienne) end
		ApresEffets(function() Son("IG_QUEST_FAILED") end)
	end
end

local function Noter(entree)
	table.insert(historique, 1, entree)
	if #historique > HISTORIQUE then historique[#historique] = nil end
end

-- Un effet du dernier lancer, pour la case « Ce lancer » et le journal de droite : k = genre (couleur de
-- la ligne : p3, p5, sortie, somme, vec, att, bz, info), cle = joueur concerné (ou rien), n = coups pris
-- (ou rien), texte = la raison. Sans lancer connu, la ligne attend le prochain (infoSeule).
local infoSeule
local function Effet(k, cle, n, texte)
	local l = dernierLancer
	if not l then infoSeule = texte; return end
	l.effets[#l.effets + 1] = { k = k, cle = cle, n = n, texte = texte }
end

--------------------------------------------------------------------------------
-- Le Bizkit
--------------------------------------------------------------------------------

-- un 7 : tous les joueurs assis à cet instant devront crier
local function NouveauBizkit(l)
	-- (la course commence quand les dés sont posés, à la fin de leur animation)
	local b = { id = l.id, lanceur = l.qui, requis = {}, nRequis = 0, appuis = {}, rang = {}, debut = GetTime() + DUREE_ROULE }
	for i = 1, PLACES do
		if places[i] then
			b.requis[places[i]] = true
			b.nRequis = b.nRequis + 1
		end
	end
	bizkit = b
end

-- fin du Bizkit : chaque perdant prend un coup (raison : « dernier au Bizkit », « pas crié à temps »)
local function FinBizkit(perdants, raison)
	for _, cle in ipairs(perdants) do
		Encaisser(cle, 1)
		Effet("bz", cle, 1, raison)
	end
	if #perdants == 0 then Effet("info", nil, nil, "Bizkit annulé") end
	bizkit = nil
	debutTour = GetTime() -- (le joueur suivant ne « tarde » pas pendant le Bizkit)
	Maj()
end

-- après chaque cri, ou un joueur parti : reste-t-il un seul joueur à crier ?
local function VerifierBizkit()
	local b = bizkit
	if not b then return end
	local restants = {}
	for cle in pairs(b.requis) do
		if not b.rang[cle] then restants[#restants + 1] = cle end
	end
	if #restants == 1 and b.nRequis > 1 then
		FinBizkit(restants, "dernier au Bizkit")
	elseif #restants == 0 then
		-- (seul à la table, ou les autres partis : le dernier à avoir crié)
		FinBizkit(#b.appuis > 0 and { b.appuis[#b.appuis] } or {}, "dernier au Bizkit")
	end
end

-- un joueur quitte la table pendant le Bizkit : il n'a plus à crier
local function RetirerDuBizkit(cle)
	local b = bizkit
	if not b then return end
	if b.requis[cle] and not b.rang[cle] then
		b.requis[cle] = nil
		b.nRequis = b.nRequis - 1
		VerifierBizkit()
	end
end

-- le bouton « Bizkit ! » : actif pour un joueur assis, quand des dés sont sur la table, s'il n'a pas déjà
-- cliqué pour ce lancer (qu'il fasse 7 ou non : le bouton ne doit rien trahir)
local monCri -- id du dernier lancer pour lequel j'ai cliqué
local function PeutCrier()
	return PlaceDe(MaCle()) ~= nil and dernierLancer ~= nil and monCri ~= dernierLancer.id
end

local function Crier()
	if not PeutCrier() then return end
	monCri = dernierLancer.id -- (un seul envoi par lancer, même si le message met un instant à revenir)
	cris[MaCle()] = GetTime() -- (ma bulle tout de suite, sans attendre le retour du message)
	Envoyer("B~" .. dernierLancer.id)
	local envoi = (C_ChatInfo and C_ChatInfo.SendChatMessage) or SendChatMessage
	if envoi and IsInGuild and IsInGuild() then pcall(envoi, CRI, "GUILD") end
	Maj()
end

--------------------------------------------------------------------------------
-- Les doubles : des attaques à distribuer
--------------------------------------------------------------------------------

-- un double : le lanceur distribue ses attaques aux autres joueurs assis (MAX_PAR_JOUEUR au plus chacun)
local function NouvelleAttaque(l)
	attaque = { id = l.id, qui = l.qui, n = l.d1 == 1 and 7 or l.d1, choix6 = l.d1 == 6, repartition = {}, debut = GetTime() }
end

-- les attaques que personne d'autre ne peut recevoir (MAX_PAR_JOUEUR chacun) : le lanceur se les met à lui-même
local function SurplusPour(n, lanceur)
	local autres = Assis() - (PlaceDe(lanceur) and 1 or 0)
	return math.max(0, n - MAX_PAR_JOUEUR * autres)
end

-- double 6 : le lanceur n'a pas encore choisi entre 6 attaques et la relance
local function ChoixEnAttente()
	local a = attaque
	return a and a.choix6 and not a.choisi and not a.relance
end

-- attaques que le lanceur peut distribuer maintenant (nil pendant le choix ou la relance du double 6)
local function AttaquesConnues()
	local a = attaque
	if not a then return nil end
	if a.choix6 and not a.relance and a.choisi ~= "six" then return nil end
	return a.n
end

local function Distribuees()
	local total = 0
	for _, k in pairs(attaque and attaque.repartition or {}) do total = total + k end
	return total
end

-- je suis le lanceur et je distribue mes attaques
local function JeDistribue()
	local a = attaque
	return a ~= nil and a.qui == MaCle() and not a.envoye and AttaquesConnues() ~= nil
end

-- pendant ma distribution : les attaques pour moi (surplus), et celles que je place sur les autres
local function Surplus() return SurplusPour(AttaquesConnues() or 0, attaque and attaque.qui) end
local function APlacer() return (AttaquesConnues() or 0) - Surplus() end

-- pendant ma distribution, les autres voient où vont mes attaques (« V ») : la répartition du moment, au
-- plus un message toutes les VISEE secondes (des clics rapprochés partent ensemble), seulement si elle a changé
local viseePrevue, viseeEnvoyee
local function AnnoncerVisee()
	if viseePrevue or not C_Timer then return end
	viseePrevue = true
	C_Timer.After(VISEE, function()
		viseePrevue = nil
		local a = attaque
		if not a or a.envoye or a.qui ~= MaCle() then return end
		local liste = {}
		for cle, k in pairs(a.repartition) do liste[#liste + 1] = cle .. ":" .. k end
		table.sort(liste)
		local msg = "V~" .. a.id .. "~" .. table.concat(liste, ",")
		if msg ~= viseeEnvoyee then
			viseeEnvoyee = msg
			Envoyer(msg)
		end
	end)
end

-- clic sur une place pendant ma distribution : une attaque de plus (sens = -1 : une de moins)
local function Viser(place, sens)
	if not JeDistribue() or DesEnRoute() then return end
	local cle = places[place]
	if not cle or cle == MaCle() then return end
	local r = attaque.repartition
	if sens > 0 and Distribuees() < APlacer() and (r[cle] or 0) < MAX_PAR_JOUEUR then
		r[cle] = (r[cle] or 0) + 1
	elseif sens < 0 and r[cle] then
		r[cle] = r[cle] > 1 and r[cle] - 1 or nil
	end
	AnnoncerVisee()
	Maj()
end

local function EnvoyerAttaques()
	local a = attaque
	if not a or a.envoye or a.qui ~= MaCle() then return end
	local surplus = Surplus()
	a.envoye = true
	local liste = {}
	for cle, k in pairs(a.repartition) do liste[#liste + 1] = cle .. ":" .. k end
	if surplus > 0 then liste[#liste + 1] = a.qui .. ":" .. surplus end
	Envoyer("T~" .. a.id .. "~" .. table.concat(liste, ","))
	Maj()
end

local function Attaquer()
	if JeDistribue() and Distribuees() == APlacer() then EnvoyerAttaques() end
end

local function EffacerAttaques()
	if JeDistribue() then
		attaque.repartition = {}
		AnnoncerVisee()
		Maj()
	end
end

-- double 6 : 6 attaques tout de suite
local function ChoisirSix()
	if not ChoixEnAttente() or attaque.qui ~= MaCle() then return end
	attaque.choisi = "six"
	AnnoncerVisee() -- (les autres voient que j'ai pris les 6 attaques)
	Maj()
end

-- double 6 : relancer ; la somme des dés donnera le nombre d'attaques (voir LireJet, message « R »)
local function Relancer()
	if not ChoixEnAttente() or attaque.qui ~= MaCle() or attente then return end
	if not RandomRoll or not ns.LireMonJet then Erreur("Ce client ne permet pas de lancer les dés depuis l'addon"); return end
	attaque.choisi = "relance"
	attente = { limite = GetTime() + ATTENTE_DES, valeurs = {}, relance = attaque.id }
	if not (pcall(RandomRoll, 1, 6) and pcall(RandomRoll, 1, 6)) then
		attente = nil
		attaque.choisi = nil
		Erreur("Le jeu a refusé le lancer de dés")
	end
	Maj()
end

-- fin des attaques : chaque cible prend ses coups
local function FinAttaque(cibles)
	local a = attaque
	for _, c in ipairs(cibles) do
		Encaisser(c.cle, c.n)
		Effet("att", c.cle, c.n, c.cle == a.qui and "ses propres attaques" or ("attaque de " .. NomJoueur(a.qui)))
	end
	if #cibles == 0 then Effet("info", a.qui, nil, "n'attaque personne") end
	attaque = nil
	debutTour = GetTime() -- (le joueur suivant ne « tarde » pas pendant les attaques)
	Maj()
end

--------------------------------------------------------------------------------
-- Actions
--------------------------------------------------------------------------------

local function Asseoir(place)
	if places[place] then return end
	local refus = RefusPlace(MaCle())
	if refus then Erreur(refus) return end
	Envoyer("A~" .. place)
end

local confirmeDepart = 0
local function Lever()
	local moi = MaCle()
	if not PlaceDe(moi) then NoterMaPlace(nil) return end
	local refus = RefusDepart(moi)
	if refus then Erreur(refus) return end
	-- pendant une partie, pas de retour : deux clics à moins de 3 s
	if enCours and GetTime() - confirmeDepart > 3 then
		confirmeDepart = GetTime()
		Maj()
		return
	end
	confirmeDepart = 0
	Envoyer("D")
	NoterMaPlace(nil)
end

local confirmeNouvelle = 0
local function NouvellePartie()
	if not PeutRelancerPartie(MaCle()) then return end
	-- deux clics à moins de 3 s : on ne remet pas les coups de tout le monde à zéro par erreur
	if GetTime() - confirmeNouvelle > 3 then
		confirmeNouvelle = GetTime()
		Maj()
		return
	end
	confirmeNouvelle = 0
	Envoyer("N")
end

-- l'appel à la guilde : assis, avec une place libre, un au plus toutes les DELAI_APPEL secondes
local dernierAppel = -DELAI_APPEL
local function PeutAppeler()
	return PlaceDe(MaCle()) ~= nil and Assis() < PLACES and GetTime() - dernierAppel >= DELAI_APPEL
end

local function Appeler()
	if not PeutAppeler() then return end
	dernierAppel = GetTime()
	Envoyer("J~" .. Assis())
	if C_Timer then C_Timer.After(DELAI_APPEL, function() Maj() end) end
	Maj()
end

local function EnCombat()
	return (InCombatLockdown and InCombatLockdown()) or (UnitAffectingCombat and UnitAffectingCombat("player"))
end

-- l'appel reçu vaut encore : récent, une place libre, et moi pas à table (ni parti de la partie en cours)
local function AppelValide()
	local a = appel
	if not a or GetTime() - a.debut > DUREE_APPEL then return nil end
	local moi = MaCle()
	if PlaceDe(moi) or partis[moi] or Assis() >= PLACES then return nil end
	return a
end

-- pastilles du médaillon et du menu Jeux
local function MajAppel()
	if ns.MajBouton then ns.MajBouton() end
	if ns.MajInterface then ns.MajInterface() end
end

local function BulleAppel(a)
	if not ns.Notifier then return end
	local libres = PLACES - a.n
	ns.Notifier("tirages", "Bizkit", ("%s cherche des joueurs pour le |cffffd100Bizkit|r · %d à table, %d place%s libre%s")
		:format(NomJoueur(a.qui), a.n, libres, libres > 1 and "s" or "", libres > 1 and "s" or ""), SON_APPEL,
		function() if ns.OuvrirInterface then ns.OuvrirInterface("jeux", "bizkit") end end)
end

-- « J'arrive ! » : je préviens celui qui a appelé (et la table) que je viens
local function Arriver()
	local a = AppelValide()
	if not a or a.repondu then return end
	a.repondu = true
	Envoyer("I~" .. a.qui)
	Maj()
end

-- pour le médaillon et le menu (GuildUp_Interface.lua) : 1 si un appel m'attend
ns.BizkitEnAttente = function() return AppelValide() and 1 or 0 end

local function Lancer()
	if not PeutLancer() then return end
	if not RandomRoll then Erreur("Ce client ne permet pas de lancer les dés depuis l'addon"); return end
	if not ns.LireMonJet then Erreur("Lecture des dés indisponible (GuildUp_Tirage.lua)"); return end
	attente = { limite = GetTime() + ATTENTE_DES, valeurs = {} }
	if not (pcall(RandomRoll, 1, 6) and pcall(RandomRoll, 1, 6)) then
		attente = nil
		Erreur("Le jeu a refusé le lancer de dés")
	end
	Maj()
end

-- deux points au hasard sur le tapis, assez loin l'un de l'autre et du bord (coordonnées de 0 à 200)
local function Poser()
	local function Point()
		local r = math.sqrt(math.random()) * 0.62
		local a = math.random() * 2 * math.pi
		return r * math.cos(a), r * math.sin(a)
	end
	local x1, y1 = Point()
	local x2, y2
	for _ = 1, 40 do
		x2, y2 = Point()
		-- (à l'écran, le tapis est deux fois plus large que haut)
		if math.sqrt(((x2 - x1) * 2) ^ 2 + (y2 - y1) ^ 2) > 0.5 then break end
	end
	local function E(v) return math.max(0, math.min(200, math.floor((v + 1) * 100 + 0.5))) end
	return E(x1), E(y1), math.random(0, 359), E(x2), E(y2), math.random(0, 359)
end

-- un /roll 1-6 à moi annoncé par le serveur : au deuxième, le lancer part
local function LireJet(texte)
	if not attente or not ns.LireMonJet then return end
	local valeur, mini, maxi = ns.LireMonJet(texte)
	if not valeur or mini ~= 1 or maxi ~= 6 then return end
	local v = attente.valeurs
	v[#v + 1] = valeur
	if #v < 2 then return end
	local relance = attente.relance
	attente = nil
	if not PlaceDe(MaCle()) then Maj(); return end
	local x1, y1, a1, x2, y2, a2 = Poser()
	if relance then
		-- (relance d'un double 6 : seulement le nombre d'attaques)
		Envoyer(("R~%s~%d~%d~%d~%d~%d~%d~%d~%d"):format(relance, v[1], v[2], x1, y1, a1, x2, y2, a2))
	else
		Envoyer(("L~%s~%d~%d~%d~%d~%d~%d~%d~%d"):format(Base36(ns.Maintenant()), v[1], v[2], x1, y1, a1, x2, y2, a2))
	end
	Maj()
end

-- un lancer à la table où je suis assis : la page s'ouvre si elle est fermée (hors combat), à chaque lancer,
-- pour que je voie les dés (sans son ; jamais seulement sur un 7 : rien ne doit le trahir)
local function Alerter()
	if not PlaceDe(MaCle()) or (vue and vue:IsVisible()) or not ns.OuvrirInterface then return end
	if (InCombatLockdown and InCombatLockdown()) or (UnitAffectingCombat and UnitAffectingCombat("player")) then return end
	ns.OuvrirInterface("jeux", "bizkit")
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui then return end
	local moi = MaCle()
	local genre, suite = msg:match("^(%u)~?(.*)$")
	if genre == "A" then
		local place, dern, pts, prisonnier, cranRecu, prisonnier5 = suite:match("^(%d+)~?(%d*)~?(%d*)~?([^~]*)~?(%d*)~?([^~]*)$")
		place = tonumber(place)
		if not place or place < 1 or place > PLACES then return end
		if places[place] and places[place] ~= qui then
			if qui == moi then Erreur("Cette place vient d'être prise") end
			return
		end
		local avant = PlaceDe(qui)
		-- pendant la partie : chacun garde sa place, et qui l'a quittée n'y revient pas
		if enCours and ((avant and avant ~= place) or (not avant and partis[qui])) then
			if qui == moi then Erreur(RefusPlace(qui) or "Place refusée") end
			return
		end
		-- le premier assis à la table vide crée la partie
		if not avant and Assis() == 0 and suite == tostring(place) then
			createur, enCours, partis = qui, false, {}
		end
		if avant and avant ~= place then places[avant] = nil end
		places[place] = qui
		arrivent[qui] = nil
		-- (assis, ou table pleine : l'appel ne m'attend plus, les pastilles s'éteignent)
		if appel then
			if qui == moi then appel = nil end
			MajAppel()
		end
		pts = tonumber(pts)
		if not coups[qui] then
			-- (une version d'avant les coups n'envoie que ses points ; une récente envoie aussi « C »)
			coups[qui] = pts and math.max(0, ANCIEN_DEPART - math.min(pts, ANCIEN_DEPART)) or 0
			devines[qui] = pts and true or nil
		end
		if qui == moi then NoterMaPlace(place) end
		dern = tonumber(dern)
		if dern and not derniere and dern >= 1 and dern <= PLACES then derniere = dern end
		if not prison and prisonnier and prisonnier ~= "" then
			prison = prisonnier
			cran = math.max(1, math.min(#PRISONS, tonumber(cranRecu) or 1))
		end
		if not prison5 and prisonnier5 and prisonnier5 ~= "" then prison5 = prisonnier5 end
		NoterTour()
		Maj()
	elseif genre == "D" then
		local p = PlaceDe(qui)
		if p and RefusDepart(qui) then return end -- (un prisonnier reste à table)
		if qui == moi then NoterMaPlace(nil) end
		if appel and appel.qui == qui then appel = nil; MajAppel() end -- (celui qui appelait est parti)
		if p then
			places[p] = nil
			if enCours then partis[qui] = true end
			VerifierTableVide()
			RetirerDuBizkit(qui)
			if attaque and attaque.qui == qui then
				attaque = nil
				Effet("info", qui, nil, "a quitté la table : attaques annulées")
			end
			NoterTour()
			Maj()
		end
	elseif genre == "L" then
		local champs = {}
		for c in suite:gmatch("[^~]+") do champs[#champs + 1] = c end
		if #champs < 9 then return end
		local n = {}
		for i = 2, 9 do
			n[i - 1] = tonumber(champs[i])
			if not n[i - 1] then return end
		end
		local d1, d2 = n[1], n[2]
		if d1 < 1 or d1 > 6 or d2 < 1 or d2 > 6 then return end
		local p = PlaceDe(qui)
		if not p then return end -- (seuls les joueurs assis lancent)
		if dernierLancer and dernierLancer.qui == qui and dernierLancer.id == champs[1] then return end -- (déjà vu)
		local rappel = champs[10] == "1"
		if (bizkit or attaque) and not rappel then return end -- (personne ne lance pendant un Bizkit ou des attaques)
		if not rappel then enCours = true end -- (le premier lancer : la partie est en cours)
		local l = {
			genre = "lancer", qui = qui, id = champs[1], place = p, d1 = d1, d2 = d2, effets = {},
			x1 = (n[3] - 100) / 100, y1 = (n[4] - 100) / 100, a1 = n[5],
			x2 = (n[6] - 100) / 100, y2 = (n[7] - 100) / 100, a2 = n[8],
		}
		l.brut = ("L~%s~%d~%d~%d~%d~%d~%d~%d~%d~1"):format(l.id, d1, d2, n[3], n[4], n[5], n[6], n[7], n[8])
		-- ma page s'ouvre à chaque lancer, pour que je voie les dés rouler (jamais seulement sur un 7)
		if not rappel then Alerter() end
		-- les dés partent avant les effets : la page garde l'état d'avant jusqu'à ce qu'ils se posent
		Animer(l)
		dernierLancer = l
		derniere = p
		infoSeule = nil
		if not rappel then pertes = {} end -- (les pertes affichées sont celles de ce lancer)
		Noter(l)
		if not rappel then
			-- chaque 3 sorti coûte au prisonnier autant de coups que son cran
			local trois = (d1 == 3 and 1 or 0) + (d2 == 3 and 1 or 0)
			if trois > 0 and prison then
				local perte = trois * cran
				Encaisser(prison, perte)
				Effet("p3", prison, perte, ("%s · %s"):format(trois > 1 and "deux 3 sortis" or "un 3 sorti",
					cran > 1 and (PRISONS[cran] .. " ×" .. cran) or "prison de 3"))
			end
			if d1 + d2 == 3 then
				if prison == qui then
					-- le prisonnier refait 3 : un cran de plus (au dernier, il y reste)
					cran = math.min(cran + 1, #PRISONS)
					Effet("p3", qui, nil, "direction : " .. PRISONS[cran])
				else
					-- un autre joueur : le prisonnier sort, quel que soit le cran, et le nouveau entre au premier
					if prison then Effet("sortie", prison, nil, "sort de " .. (cran > 1 and PRISONS[cran] or "la prison de 3")) end
					prison, cran = qui, 1
					Effet("p3", qui, nil, "entre en prison de 3")
				end
			end
			-- prison de 5 : on y entre si elle est vide ; un 5 d'un autre coûte un coup au prisonnier ; le
			-- prisonnier en sort en refaisant 5
			if d1 + d2 == 5 then
				if not prison5 then
					prison5 = qui
					Effet("p5", qui, nil, "entre en prison de 5")
				elseif prison5 == qui then
					prison5 = nil
					Effet("sortie", qui, nil, "sort de la prison de 5")
				else
					Encaisser(prison5, 1)
					Effet("p5", prison5, 1, "un 5 sorti · prison de 5")
				end
			end
			-- le 9 : le joueur d'avant prend un coup ; le 10 : le lanceur ; le 11 : le joueur d'après
			local somme = d1 + d2
			if somme >= 9 and somme <= 11 then
				local cible = qui
				if somme ~= 10 then
					local voisin = somme == 9 and Precedente(p) or Suivante(p)
					cible = voisin and voisin ~= p and places[voisin] or nil
				end
				if cible then
					Encaisser(cible, 1)
					Effet("somme", cible, 1, ({ [9] = "le 9 : joueur d'avant", [10] = "le 10 : le lanceur", [11] = "le 11 : joueur d'après" })[somme])
				end
			end
			-- le vecteur : pas de double, et une somme sans effet (le 3 de la prison de 3 ne compte pas)
			local effet = d1 == d2 or somme == 3 or somme == 5 or somme == 7 or (somme >= 9 and somme <= 11)
			if not effet then
				local vises, trace = Vecteur(l)
				if vises then
					l.trace = trace
					for _, cle in ipairs(vises) do
						Encaisser(cle, 1)
						Effet("vec", cle, 1, #vises > 1 and "dégâts de zone du vecteur" or "touché par le vecteur")
					end
				end
			end
			if d1 + d2 == 7 then NouveauBizkit(l) end
			-- un double : des attaques à distribuer (affichées en cours tant qu'elles ne sont pas parties)
			if d1 == d2 then NouvelleAttaque(l) end
		end
		NoterTour()
		Maj()
	elseif genre == "R" then
		-- relance d'un double 6 : la somme des dés donne le nombre d'attaques
		local a = attaque
		local champs = {}
		for c in suite:gmatch("[^~]+") do champs[#champs + 1] = c end
		if not a or champs[1] ~= a.id or qui ~= a.qui or not a.choix6 or a.relance or #champs < 9 then return end
		local n = {}
		for i = 2, 9 do
			n[i - 1] = tonumber(champs[i])
			if not n[i - 1] then return end
		end
		local d1, d2 = n[1], n[2]
		if d1 < 1 or d1 > 6 or d2 < 1 or d2 > 6 then return end
		-- (les dés partent d'abord : le nombre d'attaques ne se voit qu'une fois posés)
		local p = PlaceDe(qui)
		if p then
			Animer({ place = p, d1 = d1, d2 = d2, x1 = (n[3] - 100) / 100, y1 = (n[4] - 100) / 100, a1 = n[5],
				x2 = (n[6] - 100) / 100, y2 = (n[7] - 100) / 100, a2 = n[8] })
		end
		a.relance = { d1, d2 }
		a.choisi = "relance"
		a.n = d1 + d2
		Effet("att", qui, nil, ("relance : %d + %d = %d attaques"):format(d1, d2, a.n))
		Maj()
	elseif genre == "V" then
		-- où vont les attaques du lanceur pendant sa distribution : seulement affiché (« T » seul compte)
		local a = attaque
		local id, liste = suite:match("^([^~]+)~?(.*)$")
		if not a or id ~= a.id or qui ~= a.qui or qui == moi then return end
		if a.choix6 and not a.relance then a.choisi = "six" end -- (il distribue : il a pris les 6 attaques)
		local vise, total = {}, 0
		for cle, k in (liste or ""):gmatch("([^,:]+):(%d+)") do
			k = math.min(tonumber(k), MAX_PAR_JOUEUR)
			if cle ~= a.qui and PlaceDe(cle) and k > 0 and total + k <= a.n then
				vise[cle] = k
				total = total + k
			end
		end
		a.vise = vise
		Maj()
	elseif genre == "T" then
		-- les attaques du lanceur : sur des joueurs assis, MAX_PAR_JOUEUR au plus chacun, sans dépasser son
		-- nombre ; sur lui-même, seulement celles que personne d'autre ne pouvait recevoir (le surplus)
		local a = attaque
		local id, liste = suite:match("^([^~]+)~?(.*)$")
		if not a or id ~= a.id or qui ~= a.qui then return end
		local surplus = SurplusPour(a.n, a.qui)
		local cibles, total, soi = {}, 0, 0
		for cle, k in (liste or ""):gmatch("([^,:]+):(%d+)") do
			k = tonumber(k)
			if cle == a.qui then
				soi = math.min(k, surplus)
			elseif PlaceDe(cle) and k > 0 then
				k = math.min(k, MAX_PAR_JOUEUR)
				if total + k <= a.n then
					cibles[#cibles + 1] = { cle = cle, n = k }
					total = total + k
				end
			end
		end
		if soi > 0 and total + soi <= a.n then cibles[#cibles + 1] = { cle = a.qui, n = soi } end
		FinAttaque(cibles)
	elseif genre == "B" then
		-- un cri « Bizkit ! » sur le lancer posé sur la table (un autre id : il s'est croisé avec un nouveau
		-- lancer, on l'oublie)
		local l = dernierLancer
		if not l or suite ~= l.id or not PlaceDe(qui) then return end
		cris[qui] = GetTime() -- (la bulle « Bizkit ! » au-dessus de sa place)
		local b = bizkit
		if b and b.id == l.id then
			if not b.requis[qui] or b.rang[qui] then return end
			b.appuis[#b.appuis + 1] = qui
			b.rang[qui] = #b.appuis
			VerifierBizkit()
			Maj()
		elseif l.d1 + l.d2 ~= 7 then
			-- faux Bizkit : les dés ne font pas 7, un coup (une fois par lancer)
			l.faux = l.faux or {}
			if l.faux[qui] then return end
			l.faux[qui] = true
			Encaisser(qui, 1)
			Effet("bz", qui, 1, "Bizkit pour rien")
			Maj()
		end
		-- (un 7 dont le Bizkit est déjà fini : rien)
	elseif genre == "P" then
		local b = bizkit
		local id, liste = suite:match("^([^~]+)~?(.*)$")
		if not b or id ~= b.id or qui ~= b.lanceur then return end
		local perdants = {}
		for cle in (liste or ""):gmatch("[^,]+") do
			if b.requis[cle] and not b.rang[cle] then perdants[#perdants + 1] = cle end
		end
		FinBizkit(perdants, "pas crié à temps")
	elseif genre == "C" then
		local n = tonumber(suite)
		if not n or not PlaceDe(qui) then return end
		if not coups[qui] or devines[qui] then
			coups[qui] = math.max(0, math.min(math.floor(n), 99999))
			devines[qui] = nil
			Maj()
		end
	elseif genre == "G" then
		-- l'état de la partie, pour qui ne la connaît pas depuis sa création
		if partieSure or qui == moi or not PlaceDe(qui) then return end
		local cr, ec, liste = suite:match("^([^~]*)~(%d)~?(.*)$")
		if not cr then return end
		createur = cr ~= "" and cr or nil
		enCours = ec == "1"
		partis = {}
		for cle in (liste or ""):gmatch("[^,]+") do partis[cle] = true end
		partieSure = true
		Maj()
	elseif genre == "N" then
		if not PeutRelancerPartie(qui) then return end
		createur, enCours, partis, partieSure = qui, false, {}, true
		coups, devines = {}, {}
		historique = {}
		pertes = {}
		bizkit, attaque = nil, nil
		prison, cran, prison5 = nil, 1, nil
		if dernierLancer then dernierLancer.effets = {} end
		Effet("info", qui, nil, "nouvelle partie : tout le monde repart à 0 coup")
		if PlaceDe(moi) then NoterMaPlace(PlaceDe(moi)) end
		Maj()
	elseif genre == "J" then
		-- un appel : bulle pour qui n'est pas à table (et peut encore s'y asseoir), après le combat s'il le faut ;
		-- pastilles tant qu'il vaut (DUREE_APPEL)
		if qui == moi then return end
		local n = tonumber(suite) or Assis()
		if n >= PLACES then return end
		appel = { qui = qui, n = n, debut = GetTime() }
		if not AppelValide() then appel = nil; return end
		if EnCombat() then appel.bulle = true else BulleAppel(appel) end
		if C_Timer then C_Timer.After(DUREE_APPEL + 1, function() MajAppel(); Maj() end) end
		MajAppel()
		Maj()
	elseif genre == "I" then
		-- « J'arrive ! » (suite = qui a appelé) : affiché sur la table, bulle chez celui qui a appelé
		if suite == "" or PlaceDe(qui) then return end
		arrivent[qui] = GetTime()
		if suite == moi and qui ~= moi and ns.Notifier then
			ns.Notifier("tirages", "Bizkit", ("%s arrive à la table !"):format(NomJoueur(qui)))
		end
		Maj()
	elseif genre == "Q" then
		if qui == moi then return end
		local mienne = PlaceDe(moi)
		if not mienne then return end
		-- après un délai au hasard, pour ne pas répondre tous en même temps
		C_Timer.After(0.5 + math.random() * 2.5, function()
			if PlaceDe(moi) ~= mienne then return end
			Envoyer(("A~%d~%s~%d~%s~%s~%s"):format(mienne, derniere and tostring(derniere) or "", AnciensPoints(moi), prison or "",
				prison and tostring(cran) or "", prison5 or ""))
			Envoyer("C~" .. Coups(moi))
			-- l'état de la partie : un seul l'envoie, le joueur de la première place occupée
			if Suivante(PLACES) == mienne then
				local liste, long = {}, 0
				for cle in pairs(partis) do
					long = long + #cle + 1
					if long > 180 then break end
					liste[#liste + 1] = cle
				end
				Envoyer(("G~%s~%d~%s"):format(createur or "", enCours and 1 or 0, table.concat(liste, ",")))
			end
			if dernierLancer and dernierLancer.qui == moi then Envoyer(dernierLancer.brut) end
		end)
	end
end

-- première ouverture de la table : qui est assis ?
local function Demander()
	if demande then return end
	demande = true
	Envoyer("Q")
end

--------------------------------------------------------------------------------
-- Dessin : la table, les places, les dés
--------------------------------------------------------------------------------

local tourne -- le client sait-il tourner une texture ?
local function Tourner(tex, degres)
	if tourne == false then return end
	local ok = tex.SetRotation and pcall(tex.SetRotation, tex, math.rad(degres or 0))
	if tourne == nil then tourne = ok and true or false end
end

local function CreerDe(parent)
	local d = CreateFrame("Frame", nil, parent)
	d:SetSize(TAILLE_DE, TAILLE_DE)
	d.ombre = d:CreateTexture(nil, "BACKGROUND")
	d.ombre:SetTexture(ns.UI.ROND)
	d.ombre:SetVertexColor(0, 0, 0, 0.45)
	d.face = d:CreateTexture(nil, "ARTWORK")
	-- (l'image a une marge transparente : le dé tourne sans être coupé)
	d.face:SetSize(TAILLE_DE * 64 / 42, TAILLE_DE * 64 / 42)
	d.face:SetPoint("CENTER")
	d.Poser = function(self, valeur, angle, hauteur)
		hauteur = hauteur or 0
		self.face:SetTexture(FACE .. valeur)
		Tourner(self.face, angle)
		local echelle = 1 + 0.45 * hauteur
		self.face:SetSize(TAILLE_DE * 64 / 42 * echelle, TAILLE_DE * 64 / 42 * echelle)
		self.ombre:ClearAllPoints()
		self.ombre:SetPoint("CENTER", self, "CENTER", 2 + 10 * hauteur, -3 - 12 * hauteur)
		self.ombre:SetSize(TAILLE_DE * (0.95 - 0.25 * hauteur), TAILLE_DE * (0.95 - 0.25 * hauteur))
		self.ombre:SetAlpha(0.45 - 0.25 * hauteur)
	end
	d:Hide()
	return d
end

local function CreerPlace(parent, i)
	local UI = ns.UI
	local C = UI.C
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(TAILLE_PLACE, TAILLE_PLACE)
	b.place = i
	-- halo doré, fixe, autour du joueur dont c'est le tour (rouge : un joueur que je peux attaquer)
	b.halo = b:CreateTexture(nil, "BACKGROUND")
	b.halo:SetTexture(UI.ROND)
	b.halo:SetPoint("CENTER")
	b.halo:SetSize(TAILLE_PLACE + 14, TAILLE_PLACE + 14)
	b.halo:SetVertexColor(C.ors[1], C.ors[2], C.ors[3], 1)
	b.halo:SetAlpha(0.6)
	b.halo:Hide()
	b.bord = b:CreateTexture(nil, "BORDER")
	b.bord:SetTexture(UI.ROND)
	b.bord:SetAllPoints()
	b.creux = b:CreateTexture(nil, "ARTWORK")
	b.creux:SetTexture(UI.ROND)
	b.creux:SetPoint("CENTER")
	b.creux:SetSize(TAILLE_PLACE - 4, TAILLE_PLACE - 4)
	b.creux:SetVertexColor(C.champ[1], C.champ[2], C.champ[3], 1)
	b.portrait = UI.Portrait(b, TAILLE_PLACE - 6)
	b.portrait:SetPoint("CENTER")
	b.plus = b:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	b.plus:SetPoint("CENTER", 0, 1)
	b.plus:SetText("+")
	b.plus:SetTextColor(unpack(C.orFonce))
	-- jeton des coups, à cheval sur le bas du portrait
	b.jeton = CreateFrame("Frame", nil, b, "BackdropTemplate")
	UI.Habiller(b.jeton, C.bandeau, C.bordFort)
	b.jeton:SetSize(26, 15)
	b.jeton:SetPoint("CENTER", b, "BOTTOM", 0, 1)
	b.jeton:SetFrameLevel(b:GetFrameLevel() + 4)
	-- Les prisons, par-dessus le portrait : barreaux de couleur (orange, verticaux : prison de 3 ; bleus,
	-- horizontaux : prison de 5 ; les deux font une grille) et une pastille dans un coin (« 3 » ou « ×2 »… en
	-- haut à gauche, « 5 » en haut à droite)
	local function Prison(couleur, verticaux, coin)
		local p = CreateFrame("Frame", nil, b)
		p:SetAllPoints()
		p:SetFrameLevel(b:GetFrameLevel() + 3)
		for k = -1.5, 1.5 do
			local barre = p:CreateTexture(nil, "OVERLAY")
			barre:SetColorTexture(couleur[1], couleur[2], couleur[3], 0.85)
			if verticaux then
				barre:SetSize(3, TAILLE_PLACE - 8)
				barre:SetPoint("CENTER", p, "CENTER", k * 9, 0)
			else
				barre:SetSize(TAILLE_PLACE - 8, 3)
				barre:SetPoint("CENTER", p, "CENTER", 0, k * 9)
			end
		end
		p.pastille = CreateFrame("Frame", nil, p, "BackdropTemplate")
		UI.Habiller(p.pastille, { couleur[1] * 0.55, couleur[2] * 0.55, couleur[3] * 0.55, 1 }, { couleur[1], couleur[2], couleur[3], 1 })
		p.pastille:SetSize(22, 15)
		p.pastille:SetPoint("CENTER", b, coin, coin == "TOPLEFT" and 2 or -2, -2)
		p.pastille:SetFrameLevel(b:GetFrameLevel() + 6)
		p.texte = p.pastille:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		p.texte:SetPoint("CENTER", 0, 0)
		p:Hide()
		return p
	end
	b.prison = Prison({ 1, 0.5, 0.2 }, true, "TOPLEFT")
	b.prison5 = Prison({ 0.35, 0.6, 1 }, false, "TOPRIGHT")
	b.prison5.texte:SetText("5")
	b.dessus = CreateFrame("Frame", nil, b)
	b.dessus:SetAllPoints()
	b.dessus:SetFrameLevel(b:GetFrameLevel() + 5)
	b.points = b.jeton:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.points:SetPoint("CENTER", 0, 0)
	-- rang du cri pendant un Bizkit (1, 2, 3…), à droite de la place
	b.rang = b.dessus:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	b.rang:SetPoint("LEFT", b, "RIGHT", 3, 0)
	b.rang:SetTextColor(unpack(C.ors))
	-- coups pris : un éclair rouge sur le portrait, et « +2 » qui monte et s'efface (voir Toucher)
	b.eclair = b.dessus:CreateTexture(nil, "ARTWORK")
	b.eclair:SetTexture(UI.ROND)
	b.eclair:SetAllPoints()
	b.eclair:SetVertexColor(1, 0.1, 0.05, 1)
	b.eclair:SetAlpha(0)
	b.perte = b.dessus:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	b.perte:SetTextColor(1, 0.3, 0.25)
	b.perte:Hide()
	b.AnimerPerte = function(self)
		local t = (GetTime() - self.perteDebut) / 1.5
		if t < 0 then return end -- (les dés roulent encore)
		if t >= 1 then
			self.perteDebut = nil
			self.perte:Hide()
			self.eclair:SetAlpha(0)
			return
		end
		self.perte:ClearAllPoints()
		self.perte:SetPoint("BOTTOM", self, "TOP", 0, 2 + 26 * t)
		self.perte:SetAlpha(t < 0.6 and 1 or (1 - t) / 0.4)
		self.perte:Show()
		self.eclair:SetAlpha(math.max(0, 0.7 * (1 - t * 3)))
	end
	-- attaques que je lui donne pendant ma distribution (« +2 »), au milieu du portrait
	b.attaque = b.dessus:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	b.attaque:SetPoint("CENTER", b, "CENTER", 0, 0)
	b.attaque:SetTextColor(1, 0.35, 0.3)
	-- coups pris depuis le dernier lancer (« +2 »), à gauche du portrait, jusqu'au lancer suivant
	b.marque = CreateFrame("Frame", nil, b, "BackdropTemplate")
	UI.Habiller(b.marque, { 0.33, 0.06, 0.04, 0.95 }, { 1, 0.3, 0.25, 1 })
	b.marque:SetSize(30, 17)
	b.marque:SetPoint("RIGHT", b, "LEFT", -1, 0)
	b.marque:SetFrameLevel(b:GetFrameLevel() + 6)
	b.marque.texte = b.marque:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.marque.texte:SetPoint("CENTER", 0, 0)
	b.marque.texte:SetTextColor(1, 0.5, 0.45)
	b.marque:Hide()
	local _, y = PositionPlace(i)
	-- bulle « Bizkit ! » au-dessus du joueur qui crie (au-dessus de son nom s'il est écrit en haut)
	local CREME = { 0.96, 0.92, 0.8, 0.97 }
	b.bulle = CreateFrame("Frame", nil, b, "BackdropTemplate")
	UI.Habiller(b.bulle, CREME, { C.orFonce[1], C.orFonce[2], C.orFonce[3], 1 })
	b.bulle:SetSize(72, 22)
	b.bulle:SetPoint("BOTTOM", b, "TOP", 0, y > 1 and 22 or 8)
	b.bulle:SetFrameLevel(parent:GetFrameLevel() + 25) -- (par-dessus les dés)
	-- la pointe : un carré tourné d'un quart, à moitié caché par la bulle (sans rotation : pas de pointe)
	local pointe = b.bulle:CreateTexture(nil, "ARTWORK")
	pointe:SetColorTexture(CREME[1], CREME[2], CREME[3], 1)
	pointe:SetSize(9, 9)
	pointe:SetPoint("CENTER", b.bulle, "BOTTOM", 0, 1)
	if not (pointe.SetRotation and pcall(pointe.SetRotation, pointe, math.rad(45))) then pointe:Hide() end
	b.bulle.texte = b.bulle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.bulle.texte:SetPoint("CENTER", 0, 1)
	b.bulle.texte:SetText(CRI)
	b.bulle.texte:SetTextColor(0.35, 0.12, 0.05)
	b.bulle.texte:SetShadowOffset(0, 0)
	b.bulle:Hide()
	-- (appelé par l'animation de la table : la bulle s'efface sur sa dernière demi-seconde)
	b.MajBulle = function(self)
		local cle = places[self.place]
		local age = cle and cris[cle] and GetTime() - cris[cle]
		if age and age < DUREE_BULLE then
			self.bulle:SetAlpha(age > DUREE_BULLE - 0.5 and (DUREE_BULLE - age) / 0.5 or 1)
			self.bulle:Show()
		else
			self.bulle:Hide()
		end
	end
	b.nom = UI.Texte(b, "GameFontHighlightSmall", C.texte)
	b.nom:SetJustifyH("CENTER")
	b.nom:SetWidth(100)
	if y > 1 then
		b.nom:SetPoint("BOTTOM", b, "TOP", 0, 3)
	else
		b.nom:SetPoint("TOP", b, "BOTTOM", 0, -9)
	end
	b.survol = b:CreateTexture(nil, "HIGHLIGHT")
	b.survol:SetTexture(UI.ROND)
	b.survol:SetAllPoints()
	b.survol:SetVertexColor(1, 1, 1, 0.12)
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	b:SetScript("OnClick", function(self, bouton)
		-- pendant ma distribution : clic = une attaque, clic droit = en retirer une
		if JeDistribue() then
			Viser(self.place, bouton == "RightButton" and -1 or 1)
			return
		end
		if bouton ~= "RightButton" and not places[self.place] then Asseoir(self.place) end
	end)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local cle = places[self.place]
		if not cle then
			GameTooltip:SetText("Place libre")
			local refus = RefusPlace(MaCle())
			if refus then
				GameTooltip:AddLine(refus, 1, 0.45, 0.4, true)
			else
				GameTooltip:AddLine(PlaceDe(MaCle()) and "Clic : changer de place" or "Clic : t'asseoir ici", 1, 1, 1)
			end
		else
			GameTooltip:SetText(NomJoueur(cle))
			if cle == createur then GameTooltip:AddLine("A créé la partie", C.ors[1], C.ors[2], C.ors[3]) end
			-- (les dés roulent : rien du résultat, comme sur la table)
			local masque = EffetsCaches() and avant
			local n = masque and (masque.coups[cle] or 0) or Coups(cle)
			GameTooltip:AddLine(("%d coup%s"):format(n, n > 1 and "s" or ""), 1, 1, 1)
			if not masque and pertes[cle] then
				GameTooltip:AddLine(("+%d depuis le dernier lancer"):format(pertes[cle]), 1, 0.45, 0.4)
			end
			local pr, cr, pr5 = prison, cran, prison5
			if masque then pr, cr, pr5 = masque.prison, masque.cran, masque.prison5 end
			if cle == pr then
				GameTooltip:AddLine(("%s : chaque 3 sorti lui coûte %s"):format(PRISONS[cr],
					cr > 1 and (cr .. " coups") or "un coup"), 1, 0.45, 0.4, true)
			end
			if cle == pr5 then
				GameTooltip:AddLine("Prison de 5 : chaque 5 d'un autre joueur lui coûte un coup ; refaire 5 l'en sort", 0.55, 0.75, 1, true)
			end
			if masque then
				-- (ni attaques ni tour tant que les dés roulent)
			elseif JeDistribue() and cle ~= MaCle() then
				GameTooltip:AddLine(("Clic : une attaque (%d au plus) · clic droit : en retirer une"):format(MAX_PAR_JOUEUR), 1, 0.45, 0.4)
			elseif self.place == PlaceDuTour() and not attaque then
				GameTooltip:AddLine("C'est son tour", 1, 0.82, 0)
			end
		end
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

-- couleur de la petite barre de chaque ligne d'effet (voir Effet)
local COULEURS_EFFETS = {
	p3 = { 1, 0.5, 0.2 }, p5 = { 0.35, 0.6, 1 }, sortie = { 0.44, 0.82, 0.55 }, somme = { 0.95, 0.81, 0.42 },
	vec = { 1, 0.3, 0.25 }, att = { 1, 0.45, 0.3 }, bz = { 1, 0.82, 0 }, info = { 0.61, 0.576, 0.5 },
}
local LARGEUR_GAUCHE = 124   -- case « Ce lancer » : largeur de la partie des dés
local LIGNES_BOITE = 4       -- lignes d'effets dans la case (au-delà : voir le journal)

-- Une ligne d'effet : barre de couleur, (portrait,) « Nom · raison », coups pris à droite.
-- grande : la case « Ce lancer » (portrait, police normale) ; sinon le journal de droite.
local function CreerLigneEffet(parent, grande)
	local UI = ns.UI
	local C = UI.C
	local l = CreateFrame("Frame", nil, parent)
	l:SetHeight(grande and 19 or 16)
	l.barre = l:CreateTexture(nil, "ARTWORK")
	l.barre:SetSize(grande and 4 or 3, grande and 14 or 11)
	l.barre:SetPoint("LEFT", l, "LEFT", grande and 0 or 12, 0)
	if grande then
		l.portrait = UI.Portrait(l, 16)
		l.portrait:SetPoint("LEFT", l.barre, "RIGHT", 5, 0)
	end
	l.n = UI.Texte(l, grande and "GameFontNormal" or "GameFontHighlightSmall", { 1, 0.4, 0.33 })
	l.n:SetPoint("RIGHT", l, "RIGHT", -2, 0)
	l.n:SetJustifyH("RIGHT")
	l.texte = UI.Texte(l, grande and "GameFontHighlight" or "GameFontHighlightSmall", C.gris)
	-- e = { k, cle, n, texte, enCours } ; sans genre (k) : une ligne grise sans barre (« + 2 autres effets »)
	l.Poser = function(self, e)
		local c = COULEURS_EFFETS[e.k] or COULEURS_EFFETS.info
		self.barre:SetColorTexture(c[1], c[2], c[3], 1)
		self.barre:SetShown(e.k ~= nil)
		if self.portrait then
			self.portrait:SetShown(e.cle ~= nil)
			if e.cle then self.portrait:Poser(e.cle) end
		end
		self.texte:ClearAllPoints()
		self.texte:SetPoint("LEFT", (self.portrait and e.cle and self.portrait) or self.barre, "RIGHT", 5, 0)
		self.texte:SetPoint("RIGHT", self.n, "LEFT", -6, 0)
		if e.cle then
			local couleur = e.cle == MaCle() and "f1cf6b" or "e8e2d4"
			self.texte:SetText(("|cff%s%s|r · %s"):format(couleur, NomJoueur(e.cle), e.texte or ""))
		else
			self.texte:SetText(e.texte or "")
		end
		if e.enCours then
			self.n:SetText("en cours")
			self.n:SetTextColor(C.ors[1], C.ors[2], C.ors[3])
		else
			self.n:SetText(e.n and ("+" .. e.n) or "")
			self.n:SetTextColor(1, 0.4, 0.33)
		end
		self:Show()
	end
	return l
end

-- Un cachot dans un coin de la table (prison de 3 ou de 5) : barreaux en fond, portrait du prisonnier
-- derrière des barreaux, son nom, et en dessous ses crans (prison de 3) ou la règle (prison de 5)
local function CreerCachot(f, titre, couleur, coin)
	local UI = ns.UI
	local C = UI.C
	local c = UI.Cadre(f, { couleur[1] * 0.1, couleur[2] * 0.1, couleur[3] * 0.1, 0.95 }, { couleur[1], couleur[2], couleur[3], 0.9 })
	c:SetSize(60, 88)
	c:SetPoint(coin, f, coin, coin == "TOPLEFT" and 10 or -10, -38)
	for k = 1, 5 do
		local b = c:CreateTexture(nil, "BACKGROUND", nil, 2)
		b:SetColorTexture(couleur[1], couleur[2], couleur[3], 0.09)
		b:SetSize(2, 86)
		b:SetPoint("TOPLEFT", c, "TOPLEFT", k * 10 - 1, -1)
	end
	c.titre = UI.Texte(c, "GameFontHighlightSmall", couleur)
	c.titre:SetPoint("TOP", c, "TOP", 0, -5)
	c.titre:SetText(titre)
	c.portrait = UI.Portrait(c, 30)
	c.portrait:SetPoint("TOP", c, "TOP", 0, -19)
	c.grille = CreateFrame("Frame", nil, c)
	c.grille:SetAllPoints(c.portrait)
	c.grille:SetFrameLevel(c.portrait:GetFrameLevel() + 2)
	for k = -1.5, 1.5 do
		local b = c.grille:CreateTexture(nil, "OVERLAY")
		b:SetColorTexture(couleur[1], couleur[2], couleur[3], 0.85)
		b:SetSize(2, 30)
		b:SetPoint("CENTER", c.grille, "CENTER", k * 7, 0)
	end
	c.nom = UI.Texte(c, "GameFontHighlightSmall", C.texte)
	c.nom:SetPoint("TOP", c, "TOP", 0, -53)
	c.nom:SetWidth(56)
	c.nom:SetJustifyH("CENTER")
	c.detail = UI.Texte(c, "GameFontHighlightSmall", C.gris)
	c.detail:SetPoint("TOP", c, "TOP", 0, -68)
	c.detail:SetJustifyH("CENTER")
	c.crans = {}
	for k = 1, #PRISONS do
		local q = CreateFrame("Frame", nil, c, "BackdropTemplate")
		q:SetSize(7, 7)
		q:SetPoint("TOP", c, "TOP", (k - 3) * 10, -71)
		c.crans[k] = q
	end
	c.vide = UI.Texte(c, "GameFontHighlightSmall", C.gris)
	c.vide:SetPoint("CENTER", c, "CENTER", 0, -8)
	c.vide:SetText("vide")
	-- cle : le prisonnier (ou rien) ; nCran : son cran (prison de 3 seulement) ; detail : la ligne du bas
	c.Poser = function(self, cle, nCran, detail)
		self.cle, self.nCran = cle, nCran
		self.portrait:SetShown(cle ~= nil)
		self.grille:SetShown(cle ~= nil)
		self.vide:SetShown(cle == nil)
		if cle then
			self.portrait:Poser(cle)
			self.nom:SetText(NomJoueur(cle))
			self.nom:SetTextColor(unpack(PlaceDe(cle) and C.texte or C.gris)) -- (gris : absent de la table)
		else
			self.nom:SetText("")
		end
		self.detail:SetText(cle and detail or "")
		for k, q in ipairs(self.crans) do
			q:SetShown(cle ~= nil and nCran ~= nil)
			UI.Habiller(q, (nCran and k <= nCran) and { couleur[1], couleur[2], couleur[3], 1 } or { 0, 0, 0, 0 },
				{ couleur[1], couleur[2], couleur[3], 1 })
		end
	end
	c:EnableMouse(true)
	c:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(titre)
		if coin == "TOPLEFT" then
			if self.cle and self.nCran then
				GameTooltip:AddLine(("%s : %s. Chaque 3 sorti lui coûte %s."):format(NomJoueur(self.cle), PRISONS[self.nCran],
					self.nCran > 1 and (self.nCran .. " coups") or "un coup"), 1, 1, 1, true)
			end
			GameTooltip:AddLine("Un 3 (1 + 2) y envoie le lanceur et en fait sortir le prisonnier. Le prisonnier qui refait 3 monte d'un cran (5 au plus).", 0.8, 0.8, 0.8, true)
		else
			if self.cle then GameTooltip:AddLine(NomJoueur(self.cle), 1, 1, 1) end
			GameTooltip:AddLine("Un 5 y envoie le lanceur si elle est vide. Chaque 5 d'un autre joueur coûte un coup au prisonnier, qui sort en refaisant 5.", 0.8, 0.8, 0.8, true)
		end
		GameTooltip:Show()
	end)
	c:SetScript("OnLeave", function() GameTooltip:Hide() end)
	c:Poser(nil)
	return c
end

local function CreerTable(parent)
	local UI = ns.UI
	local C = UI.C
	local f = UI.Carte(parent, "Bizkit")
	f.vide:Hide()

	-- la table au centre de la zone de jeu, les places autour
	f.zone = CreateFrame("Frame", nil, f)
	f.zone:SetSize(LARGEUR_TABLE, HAUTEUR_TABLE)
	f.zone:SetPoint("TOP", f, "TOP", 0, -34 - ECART_PLACE - TAILLE_PLACE / 2 - 18)
	f.plateau = f.zone:CreateTexture(nil, "BACKGROUND")
	f.plateau:SetTexture(TABLE)
	f.plateau:SetAllPoints()
	f.places = {}
	for i = 1, PLACES do
		local b = CreerPlace(f, i)
		local x, y = PositionPlace(i)
		b:SetPoint("CENTER", f.zone, "CENTER", x, y)
		f.places[i] = b
	end
	f.des = { CreerDe(f.zone), CreerDe(f.zone) }
	-- (au-dessus des places : les dés partent de la place du lanceur)
	for _, d in ipairs(f.des) do d:SetFrameLevel(f:GetFrameLevel() + 20) end

	-- le vecteur : des points rouges du petit dé jusqu'au joueur visé, sous les dés
	f.trace = CreateFrame("Frame", nil, f.zone)
	f.trace:SetAllPoints()
	f.trace:SetFrameLevel(f:GetFrameLevel() + 15)
	f.points = {}
	for k = 1, 48 do
		local pt = f.trace:CreateTexture(nil, "ARTWORK")
		pt:SetTexture(UI.ROND)
		pt:SetSize(5, 5)
		pt:SetVertexColor(1, 0.25, 0.2, 0.85)
		f.points[k] = pt
	end
	f.impact = f.trace:CreateTexture(nil, "OVERLAY")
	f.impact:SetTexture(UI.ROND)
	f.impact:SetSize(16, 16)
	f.impact:SetVertexColor(1, 0.25, 0.2, 0.55)
	f.trace:Hide()

	-- dans l'en-tête, au milieu : l'état (à qui le tour, mes attaques, mon cri), avec le temps qui reste
	f.etat = CreateFrame("Frame", nil, f, "BackdropTemplate")
	f.etat:SetHeight(24)
	f.etat:SetPoint("TOP", f, "TOP", 0, -8)
	f.etat:SetFrameLevel(f:GetFrameLevel() + 2)
	f.etat.texte = f.etat:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.etat.texte:SetPoint("CENTER", 0, 0)
	f.etat.barre = f.etat:CreateTexture(nil, "OVERLAY")
	f.etat.barre:SetHeight(2)
	f.etat.barre:SetPoint("BOTTOMLEFT", f.etat, "BOTTOMLEFT", 1, 1)
	-- les deux prisons, en cachots dans les coins du haut
	f.cachot3 = CreerCachot(f, "Prison de 3", { 1, 0.5, 0.2 }, "TOPLEFT")
	f.cachot5 = CreerCachot(f, "Prison de 5", { 0.35, 0.6, 1 }, "TOPRIGHT")
	-- le bouton principal : lancer ; pendant mes attaques, relancer (double 6) ou attaquer
	f.lancer = UI.Bouton(f, "Lancer les dés", "or", 200, 32)
	f.lancer:SetPoint("BOTTOM", f, "BOTTOM", 0, 14)
	f.lancer:SetScript("OnClick", function()
		local a = attaque
		if a and a.qui == MaCle() then
			if ChoixEnAttente() then Relancer() else Attaquer() end
		else
			Lancer()
		end
	end)
	-- à sa gauche, pendant mes attaques : « 6 attaques » (double 6) ou « Effacer » ; pas assis, pendant un
	-- appel : « J'arrive ! »
	f.secondaire = UI.Bouton(f, "", "fantome", 120, 32)
	f.secondaire:SetPoint("RIGHT", f.lancer, "LEFT", -8, 0)
	f.secondaire:SetScript("OnClick", function()
		if not PlaceDe(MaCle()) then Arriver()
		elseif ChoixEnAttente() then ChoisirSix() else EffacerAttaques() end
	end)
	f.secondaire:Hide()
	-- à sa droite, toujours là et toujours pareil (rien ne doit trahir un 7) : « Bizkit ! »
	f.crier = UI.Bouton(f, CRI, "aide", 110, 32)
	f.crier:SetPoint("LEFT", f.lancer, "RIGHT", 8, 0)
	f.crier:SetScript("OnClick", Crier)
	UI.Infobulle(f.crier, CRI, "Sur un 7, tout le monde clique : le dernier prend un coup. Un clic quand les dés ne font pas 7 coûte un coup.")

	-- sous la table, au-dessus des boutons : « Ce lancer », les dés et le lanceur à gauche, les effets à droite
	f.boite = UI.Cadre(f, { 0.086, 0.071, 0.055, 1 }, C.bord)
	f.boite:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 54)
	f.boite:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -14, 54)
	f.boite:SetHeight(98)
	local bo = f.boite
	bo.titre = UI.Texte(bo, "GameFontHighlightSmall", C.gris)
	bo.titre:SetPoint("TOPLEFT", bo, "TOPLEFT", 10, -7)
	bo.titre:SetText("CE LANCER")
	bo.de1 = bo:CreateTexture(nil, "ARTWORK")
	bo.de1:SetSize(30, 30)
	bo.de1:SetPoint("TOPLEFT", bo, "TOPLEFT", 6, -24)
	bo.de2 = bo:CreateTexture(nil, "ARTWORK")
	bo.de2:SetSize(30, 30)
	bo.de2:SetPoint("LEFT", bo.de1, "RIGHT", 0, 0)
	bo.par = UI.Texte(bo, "GameFontHighlightSmall", C.gris)
	bo.par:SetPoint("TOPLEFT", bo, "TOPLEFT", 10, -62)
	bo.par:SetWidth(LARGEUR_GAUCHE - 14)
	bo.vide = UI.Texte(bo, "GameFontHighlight", C.gris)
	bo.vide:SetPoint("CENTER", bo, "CENTER", 0, 0)
	bo.filet = bo:CreateTexture(nil, "ARTWORK")
	bo.filet:SetColorTexture(C.bord[1], C.bord[2], C.bord[3], 1)
	bo.filet:SetWidth(1)
	bo.filet:SetPoint("TOPLEFT", bo, "TOPLEFT", LARGEUR_GAUCHE, -8)
	bo.filet:SetPoint("BOTTOMLEFT", bo, "BOTTOMLEFT", LARGEUR_GAUCHE, 8)
	bo.lignes = {}
	for k = 1, LIGNES_BOITE do
		local ligne = CreerLigneEffet(bo, true)
		ligne:SetPoint("TOPLEFT", bo, "TOPLEFT", LARGEUR_GAUCHE + 10, -8 - (k - 1) * 21)
		ligne:SetPoint("RIGHT", bo, "RIGHT", -10, 0)
		bo.lignes[k] = ligne
	end

	-- animation des dés et des coups pris (le halo des places reste fixe : voir CreerPlace)
	local attenteMaj = 0
	f:SetScript("OnUpdate", function(self, dt)
		if self.roule then self:Rouler() end
		for _, b in ipairs(self.places) do
			if b.perteDebut then b:AnimerPerte() end
			b:MajBulle()
		end
		attenteMaj = attenteMaj + dt
		if attenteMaj >= 0.25 then
			attenteMaj = 0
			Maj()
		end
	end)
	return f
end

-- les dés partent de la place du lanceur, roulent en tournant et se posent
local function AnimerDes(f, l, instantane)
	f.roule = { l = l, debut = GetTime(), changement = 0, instantane = instantane }
	local sx, sy = PositionPlace(l.place)
	f.roule.depart = { sx * 0.85, sy * 0.85 }
	for _, d in ipairs(f.des) do d:Show() end
	f.Rouler = function(self)
		local r = self.roule
		local t = r.instantane and 1 or math.min(1, (GetTime() - r.debut) / DUREE_ROULE)
		local e = 1 - (1 - t) ^ 3 -- (départ vif, arrivée en douceur)
		local fin = t >= 1
		local melange = not fin and GetTime() > r.changement
		if melange then r.changement = GetTime() + 0.07 end
		for k, d in ipairs(self.des) do
			local tx, ty = r.l["x" .. k] * RX, -r.l["y" .. k] * RY
			local x = r.depart[1] + (tx - r.depart[1]) * e
			local y = r.depart[2] + (ty - r.depart[2]) * e
			-- deux petits rebonds pendant la course
			local hauteur = fin and 0 or math.abs(math.sin(t * math.pi * 2.5)) * (1 - t)
			d:ClearAllPoints()
			d:SetPoint("CENTER", self.zone, "CENTER", x, y)
			local angle = r.l["a" .. k] + (1 - e) * (k == 1 and 540 or -630)
			local valeur = r.l["d" .. k]
			if not fin then
				valeur = melange and math.random(1, 6) or (d.valeurRoule or valeur)
				d.valeurRoule = valeur
			end
			d:Poser(valeur, angle, hauteur)
		end
		if fin then
			self.roule = nil
			if not r.instantane then
				Son("U_CHAT_SCROLL_BUTTON")
				-- (les dés se montrent dès qu'ils sont posés, leurs effets DELAI_EFFETS plus tard)
				Maj()
				if C_Timer then C_Timer.After(DELAI_EFFETS + 0.05, function() Maj() end) end
			end
		end
	end
	f:Rouler()
end

-- Appelé à la réception d'un lancer, avant ses effets : la page garde l'état d'avant (coups, pertes,
-- prisons, derniers lancers) jusqu'à ce que les dés soient posés.
Animer = function(l)
	if not vue or not vue.table then return end
	-- page cachée : les dés sont posés directement, sans animation
	local instantane = not vue:IsVisible()
	if not instantane then
		local p, perdu = {}, {}
		for cle, n in pairs(coups) do p[cle] = n end
		for cle, n in pairs(pertes) do perdu[cle] = n end
		avant = { coups = p, pertes = perdu, prison = prison, cran = cran, prison5 = prison5, entree = historique[1],
			lancer = dernierLancer, nEffets = dernierLancer and #dernierLancer.effets or 0 }
		finRoule = GetTime() + DUREE_ROULE
	end
	AnimerDes(vue.table, l, instantane)
end

-- un joueur prend n coups : « +n » monte au-dessus de sa place, son portrait rougit. Si les dés roulent
-- encore, l'animation attend qu'ils soient posés (rien n'est dévoilé avant) ; plusieurs pertes rapprochées
-- s'additionnent.
Toucher = function(cle, n)
	if not vue or not vue.table or not vue:IsVisible() then return end
	local t = vue.table
	local p = PlaceDe(cle)
	local b = p and t.places[p]
	if not b then return end
	local debut = math.max(GetTime(), finRoule + DELAI_EFFETS)
	if b.perteDebut and debut - b.perteDebut < 0.5 then
		b.perteN = b.perteN + n
	else
		b.perteN = n
	end
	b.perteDebut = debut
	b.perte:SetText("+" .. b.perteN)
end

--------------------------------------------------------------------------------
-- À droite : les derniers lancers et Bizkit, se lever, nouvelle partie
--------------------------------------------------------------------------------

local HAUT_LIGNE = 24

local function CreerCote(parent)
	local UI = ns.UI
	local C = UI.C
	local f = UI.Carte(parent, "Derniers lancers")
	f.vide:SetText("Aucun lancer pour l'instant.")
	f.liste = UI.Liste(f)
	f.liste:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -40)
	f.liste:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 136)
	f.lignes = {}             -- un lancer : son lanceur, ses dés, leur somme
	f.sous = {}               -- sous chaque lancer : ses effets
	-- le lancer en cours, encadré (voir Maj)
	f.actuel = CreateFrame("Frame", nil, f.liste.contenu, "BackdropTemplate")
	UI.Habiller(f.actuel, { 0.133, 0.11, 0.078, 1 }, { 0.29, 0.235, 0.145, 1 })
	f.actuel:SetFrameLevel(f.liste.contenu:GetFrameLevel())
	-- en bas, de haut en bas : les règles (au survol), appeler la guilde, nouvelle partie, quitter la table
	f.regles = CreateFrame("Button", nil, f)
	f.regles:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 110)
	f.regles:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.regles:SetHeight(20)
	f.regles.texte = UI.Texte(f.regles, "GameFontHighlightSmall", C.gris)
	f.regles.texte:SetPoint("LEFT", 0, 0)
	f.regles.texte:SetText("|cfff1cf6b?|r  Les règles du Bizkit (survol)")
	UI.Infobulle(f.regles, "Les règles du Bizkit", table.concat({
		"Chacun son tour lance deux dés. Chaque joueur compte ses coups : 0 au départ, et ça ne fait que monter.",
		"",
		"|cffffd100La partie|r : dès le premier lancer, chacun garde sa place ; qui quitte la table ne revient qu'à la partie suivante, et un prisonnier ne peut pas partir. Un nouveau joueur s'assoit quand il veut. Seul le créateur de la partie en lance une nouvelle (s'il a quitté la table : tous les joueurs assis).",
		"",
		"|cffffd1007|r : tout le monde clique sur « Bizkit ! », le lanceur aussi, dans n'importe quel ordre. Le dernier prend un coup. Cliquer quand les dés ne font pas 7 coûte un coup.",
		"",
		"|cffffd1003|r (1 + 2) : prison de 3, un seul prisonnier à la fois. Chaque dé qui montre un 3, chez n'importe qui, lui coûte un coup. S'il refait 3, il monte d'un cran : chaque 3 coûte alors 2, 3, 4 puis 5 coups. Un autre joueur qui fait 3 prend sa place, au premier cran.",
		"",
		"|cffffd1005|r : prison de 5 si elle est vide. Chaque 5 d'un autre joueur coûte un coup au prisonnier, qui sort en refaisant 5.",
		"",
		"|cffffd100Doubles|r : autant d'attaques que la valeur du dé (double 1 : 7), à distribuer aux autres joueurs ; chaque attaque coûte un coup, 7 au plus par joueur (le reste, pour soi). Double 6 : 6 attaques, ou une relance dont la somme donne les attaques.",
		"",
		"|cffffd1009|r : le joueur d'avant prend un coup. |cffffd10010|r : le lanceur prend un coup. |cffffd10011|r : le joueur d'après prend un coup.",
		"",
		"|cffffd100Le vecteur|r : sur un 4, un 6 ou un 8 (pas un double), une ligne part du plus petit dé vers le plus grand. Si elle arrive près d'un joueur, il prend un coup ; sinon, dégâts de zone : les deux joueurs les plus proches prennent un coup.",
	}, "\n"))
	f.lever = UI.Bouton(f, "Quitter la table", "fantome", 100, 26)
	f.lever:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 14)
	f.lever:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.lever:SetScript("OnClick", Lever)
	f.nouvelle = UI.Bouton(f, "Nouvelle partie", "fantome", 100, 26)
	f.nouvelle:SetPoint("BOTTOMLEFT", f.lever, "TOPLEFT", 0, 6)
	f.nouvelle:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.nouvelle:SetScript("OnClick", NouvellePartie)
	UI.Infobulle(f.nouvelle, "Nouvelle partie", "Tous les joueurs repartent à 0 coup. Seul le joueur qui a créé la partie peut en lancer une nouvelle ; s'il a quitté la table, tous les joueurs assis le peuvent. Deux clics pour confirmer.")
	UI.Infobulle(f.lever, "Quitter la table", "Pendant une partie, qui quitte la table ne peut plus la rejoindre avant la partie suivante (deux clics pour confirmer). Un prisonnier ne peut pas quitter la table.")
	f.appel = UI.Bouton(f, "Appeler la guilde", "fantome", 100, 26)
	f.appel:SetPoint("BOTTOMLEFT", f.nouvelle, "TOPLEFT", 0, 6)
	f.appel:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.appel:SetScript("OnClick", Appeler)
	UI.Infobulle(f.appel, "Appeler la guilde", "Une bulle prévient les membres qui ne sont pas à table que tu cherches des joueurs ; un clic dessus leur ouvre la table. Il faut être assis et qu'il reste une place. Un appel toutes les 2 minutes au plus.")
	-- (infobulles aussi sur les boutons grisés)
	for _, b in ipairs({ f.appel, f.nouvelle, f.lever }) do
		if b.SetMotionScriptsWhileDisabled then b:SetMotionScriptsWhileDisabled(true) end
	end
	return f
end

local HAUT_SOUS = 16

-- ligne d'un lancer dans le journal (placée par Maj)
local function LigneHistorique(f, i)
	local l = f.lignes[i]
	if l then return l end
	local UI = ns.UI
	local C = UI.C
	l = CreateFrame("Frame", nil, f.liste.contenu)
	l:SetHeight(HAUT_LIGNE)
	l:SetFrameLevel(f.liste.contenu:GetFrameLevel() + 2)
	l.total = UI.Texte(l, "GameFontHighlight", C.ors)
	l.total:SetPoint("RIGHT", l, "RIGHT", -2, 0)
	l.total:SetWidth(24)
	l.total:SetJustifyH("RIGHT")
	l.de2 = l:CreateTexture(nil, "ARTWORK")
	l.de2:SetSize(22, 22)
	l.de2:SetPoint("RIGHT", l.total, "LEFT", -4, 0)
	l.de1 = l:CreateTexture(nil, "ARTWORK")
	l.de1:SetSize(22, 22)
	l.de1:SetPoint("RIGHT", l.de2, "LEFT", 2, 0)
	l.nom = UI.Texte(l, "GameFontHighlight", C.texte)
	l.nom:SetPoint("LEFT", l, "LEFT", 2, 0)
	l.nom:SetPoint("RIGHT", l.de1, "LEFT", -6, 0)
	f.lignes[i] = l
	return l
end

-- ligne d'un effet sous son lancer, dans le journal (placée par Maj)
local function SousLigne(f, i)
	local l = f.sous[i]
	if l then return l end
	l = CreerLigneEffet(f.liste.contenu, false)
	l:SetFrameLevel(f.liste.contenu:GetFrameLevel() + 2)
	f.sous[i] = l
	return l
end

-- Effets à montrer pour un lancer : tant que les dés roulent, seulement ceux d'avant (voir Animer)
local function EffetsVus(l, cache)
	local n = #l.effets
	if cache then
		if l == cache.lancer then
			n = math.min(n, cache.nEffets or 0)
		elseif l == dernierLancer then
			n = 0
		end
	end
	return n
end

-- L'état, dans l'en-tête de la table : texte, genre (couleur : « moi », « bz », « att », ou rien) et part
-- du temps qui reste (barre). Pendant un Bizkit, rien tant que je n'ai pas crié : c'est à moi de voir le 7.
local function TexteEtat(mienne, tour)
	if DesEnRoute() then return "Les dés roulent…" end
	local moi = MaCle()
	local b = bizkit
	if b and b.rang[moi] then
		local reste = math.max(0, DELAI_COURSE - (GetTime() - b.debut))
		local r = b.rang[moi]
		return ("Bizkit ! Tu as crié %d%s · %d s"):format(r, r == 1 and "er" or "e", math.ceil(reste)), "bz", reste / DELAI_COURSE
	end
	local a = attaque
	if a then
		local reste = math.max(0, DELAI_ATTAQUE - (GetTime() - a.debut))
		local part = reste / DELAI_ATTAQUE
		local s = math.ceil(reste)
		if a.qui == moi then
			if a.envoye then return "Tes attaques partent…", "att" end
			if ChoixEnAttente() then return ("Double 6 : 6 attaques ou relance · %d s"):format(s), "att", part end
			if not AttaquesConnues() then return "Les dés roulent…", "att" end
			if APlacer() == 0 then return ("Tes %d attaques sont pour toi · %d s"):format(AttaquesConnues(), s), "att", part end
			local pourMoi = Surplus() > 0 and (", %d pour toi"):format(Surplus()) or ""
			return ("%d attaques : clique sur les joueurs%s · %d s"):format(AttaquesConnues(), pourMoi, s), "att", part
		end
		if a.choix6 and not a.relance and a.choisi ~= "six" then return ("%s choisit : 6 attaques ou relance"):format(NomJoueur(a.qui)), "att", part end
		return ("%s distribue %d attaques · %d s"):format(NomJoueur(a.qui), a.n, s), "att", part
	end
	if attente then return "Les dés roulent…" end
	if not mienne then
		return Assis() >= PLACES and "La table est pleine" or "Clique sur une place libre pour t'asseoir"
	end
	if tour == mienne then return "À toi de lancer !", "moi" end
	if tour and places[tour] then
		local tarde = Tarde()
		if tarde and Suivante(tour) == mienne then
			return ("%s tarde : tu peux lancer à sa place"):format(NomJoueur(places[tour])), "moi"
		end
		return ("Au tour de %s"):format(NomJoueur(places[tour]))
	end
	return ""
end

Maj = function()
	if not vue or not vue:IsVisible() then return end
	local UI = ns.UI
	local C = UI.C
	local t, cote = vue.table, vue.cote
	local moi = MaCle()
	local mienne = PlaceDe(moi)
	local tour = PlaceDuTour()
	-- les dés roulent : l'état d'avant le lancer (voir Animer), rien de son résultat
	local masque = DesEnRoute() and avant
	-- puis, dés posés, ses effets attendent encore DELAI_EFFETS (coups, prisons, lignes d'effets, vecteur)
	local cache = EffetsCaches() and avant
	local CoupsVus = cache and function(cle) return cache.coups[cle] or 0 end or Coups
	local pertesVues = cache and cache.pertes or pertes
	local prisonVue, cranVu, prison5Vue = prison, cran, prison5
	if cache then prisonVue, cranVu, prison5Vue = cache.prison, cache.cran, cache.prison5 end

	-- les places
	local distribue = JeDistribue() and not masque
	-- la distribution d'un autre, en direct (« V »)
	local regarde = not masque and attaque and attaque.qui ~= moi and attaque.vise
	for i, b in ipairs(t.places) do
		local cle = places[i]
		-- halo doré : son tour ; rouge : un joueur que je peux attaquer, ou que le lanceur vise
		local cible = (distribue and cle ~= nil and cle ~= moi) or (regarde and cle ~= nil and regarde[cle] ~= nil)
		-- (allumé aussi pendant un Bizkit : il ne doit pas s'éteindre sur un 7)
		b.halo:SetShown(not masque and (cible or (cle ~= nil and i == tour and not attaque)))
		if cible then
			b.halo:SetVertexColor(1, 0.3, 0.25, 1)
		else
			b.halo:SetVertexColor(C.ors[1], C.ors[2], C.ors[3], 1)
		end
		local k = distribue and cle and attaque.repartition[cle]
		if cle == moi and distribue and Surplus() > 0 then k = Surplus() end -- (celles que je me mets)
		if regarde and cle then
			k = regarde[cle]
			local soi = cle == attaque.qui and SurplusPour(attaque.n, attaque.qui) or 0
			if soi > 0 then k = soi end -- (celles qu'il se met)
		end
		b.attaque:SetText(k and ("+" .. k) or "")
		if cle then
			local r, g, bl = ns.CouleurClasse(ns.ClasseMembre and ns.ClasseMembre(cle))
			b.bord:SetVertexColor(r, g, bl, 1)
			b.creux:Hide()
			b.plus:Hide()
			b.portrait:Poser(cle)
			b.portrait:Show()
			b.nom:SetText(NomJoueur(cle))
			b.nom:SetTextColor(unpack(cle == moi and C.ors or C.texte))
			b.points:SetText(CoupsVus(cle))
			b.jeton:Show()
			b.prison:SetShown(cle == prisonVue)
			b.prison5:SetShown(cle == prison5Vue)
			b.prison.texte:SetText(cranVu > 1 and ("×" .. cranVu) or "3")
			local rang = bizkit and bizkit.rang[cle]
			b.rang:SetText(rang and tostring(rang) or "")
			-- (cachée pendant que « +n » monte au-dessus de lui ; pas avant que les dés soient posés)
			local perdu = pertesVues[cle]
			b.marque.texte:SetText(perdu and ("+" .. perdu) or "")
			b.marque:SetShown(perdu ~= nil and not (b.perteDebut and GetTime() >= b.perteDebut))
		else
			b.bord:SetVertexColor(C.bordMoyen[1], C.bordMoyen[2], C.bordMoyen[3], 1)
			b.creux:Show()
			b.plus:Show()
			b.portrait:Hide()
			b.nom:SetText("")
			b.jeton:Hide()
			b.prison:Hide()
			b.prison5:Hide()
			b.rang:SetText("")
			b.marque:Hide()
		end
		b:MajBulle()
	end

	-- les dés du dernier lancer (sans animation en cours)
	if dernierLancer and not t.roule and not t.des[1]:IsShown() then AnimerDes(t, dernierLancer, true) end

	-- le vecteur du dernier lancer, une fois ses effets montrés : un point tous les 9 pixels
	local tr = dernierLancer and dernierLancer.trace
	if tr and not t.roule and not cache then
		local dx, dy = tr.px - tr.ox, tr.py - tr.oy
		local n = math.min(#t.points, math.floor(math.sqrt(dx * dx + dy * dy) / 9))
		for k, pt in ipairs(t.points) do
			if k <= n then
				pt:ClearAllPoints()
				pt:SetPoint("CENTER", t.zone, "CENTER", tr.ox + dx * k / n, tr.oy + dy * k / n)
				pt:Show()
			else
				pt:Hide()
			end
		end
		t.impact:ClearAllPoints()
		t.impact:SetPoint("CENTER", t.zone, "CENTER", tr.px, tr.py)
		t.trace:Show()
	else
		t.trace:Hide()
	end

	-- le bouton « Bizkit ! » : une fois les dés posés, un clic par lancer
	t.crier:Activer(PeutCrier() and not t.roule)

	-- l'état, dans l'en-tête (couleur selon le genre, barre du temps qui reste)
	local texte, genre, part = TexteEtat(mienne, tour)
	local e = t.etat
	e.texte:SetWidth(0)
	e.texte:SetText(texte)
	if e.genre ~= (genre or "") then
		e.genre = genre or ""
		local couleurTexte = C.texte
		if genre == "moi" then
			UI.Habiller(e, { C.orFonce[1], C.orFonce[2], C.orFonce[3], 1 }, { C.ors[1], C.ors[2], C.ors[3], 1 })
			couleurTexte = { 0.07, 0.05, 0.02 }
		elseif genre == "bz" then
			UI.Habiller(e, C.fondAide, C.bordAide)
			couleurTexte = { 1, 0.83, 0.54 }
		elseif genre == "att" then
			UI.Habiller(e, { 0.165, 0.078, 0.06, 1 }, C.bordAide)
			couleurTexte = C.aide
		else
			UI.Habiller(e, C.bandeau, C.bordFort)
		end
		e.texte:SetTextColor(unpack(couleurTexte))
		-- (texte sombre sur l'or : sans l'ombre noire de la police)
		e.texte:SetShadowOffset(genre == "moi" and 0 or 1, genre == "moi" and 0 or -1)
		e.barre:SetColorTexture(couleurTexte[1], couleurTexte[2], couleurTexte[3], 0.9)
	end
	local largeur = math.min(340, math.max(120, (e.texte:GetStringWidth() or 0) + 28))
	if largeur >= 340 then e.texte:SetWidth(largeur - 16) end
	e:SetWidth(largeur)
	e:SetShown(texte ~= "")
	if part then
		e.barre:SetWidth(math.max(1, (largeur - 2) * part))
		e.barre:Show()
	else
		e.barre:Hide()
	end

	-- les boutons
	local a = attaque
	if masque then
		t.secondaire:Hide()
		t.lancer:Ecrire("Les dés roulent…")
		t.lancer:Activer(false)
	elseif a and a.qui == moi and not a.envoye then
		-- mes attaques : choix du double 6, puis distribution
		if ChoixEnAttente() then
			t.lancer:Ecrire("Relancer les dés")
			t.lancer:Activer(not attente)
			t.secondaire:Ecrire("6 attaques")
			t.secondaire:Activer(true)
			t.secondaire:Show()
		elseif AttaquesConnues() then
			local reste = APlacer() - Distribuees()
			t.lancer:Ecrire(reste > 0 and ("Encore %d attaque%s"):format(reste, reste > 1 and "s" or "")
				or (APlacer() == 0 and "Prendre mes attaques" or "Attaquer !"))
			t.lancer:Activer(reste == 0)
			t.secondaire:Ecrire("Effacer")
			t.secondaire:Activer(Distribuees() > 0)
			t.secondaire:Show()
		else
			t.lancer:Ecrire("Les dés roulent…")
			t.lancer:Activer(false)
			t.secondaire:Hide()
		end
	else
		-- pas assis, pendant un appel : « J'arrive ! »
		local ap = not mienne and AppelValide()
		if ap then
			t.secondaire:Ecrire(ap.repondu and "Tu arrives" or "J'arrive !")
			t.secondaire:Activer(not ap.repondu)
			t.secondaire:Show()
		else
			t.secondaire:Hide()
		end
		-- (pendant un Bizkit où je n'ai pas crié, le bouton reste comme avant le 7 ; un clic est sans effet)
		local b = bizkit
		t.lancer:Activer(PeutLancer() or (b ~= nil and not b.rang[moi] and PeutLancer(true)))
		t.lancer:Ecrire(attente and "Les dés roulent…" or "Lancer les dés")
	end
	-- le compte des joueurs, et ceux qui ont répondu « J'arrive ! » (oubliés après DUREE_APPEL)
	local nA, unSeul = 0, nil
	for cle, quand in pairs(arrivent) do
		if GetTime() - quand <= DUREE_APPEL and not PlaceDe(cle) then
			nA, unSeul = nA + 1, cle
		else
			arrivent[cle] = nil
		end
	end
	local enRoute = ""
	if nA == 1 then enRoute = " · " .. (NomCourt and NomCourt(unSeul) or unSeul) .. " arrive"
	elseif nA > 1 then enRoute = (" · %d arrivent"):format(nA) end
	t.compte:SetText(("%d / %d%s"):format(Assis(), PLACES, enRoute))

	-- les cachots
	t.cachot3:Poser(prisonVue, prisonVue and cranVu, nil)
	t.cachot5:Poser(prison5Vue, nil, "+1 par 5")

	-- « Ce lancer » : ses dés, son lanceur, ses effets (et les attaques d'un double qui attendent)
	local bo = t.boite
	local l = dernierLancer
	if masque then l = masque.lancer end
	for _, ligne in ipairs(bo.lignes) do ligne:Hide() end
	if l then
		bo.vide:Hide()
		bo.titre:Show()
		bo.filet:Show()
		bo.de1:SetTexture(FACE .. l.d1)
		bo.de2:SetTexture(FACE .. l.d2)
		bo.de1:Show()
		bo.de2:Show()
		bo.par:SetText("par |cffe8e2d4" .. NomJoueur(l.qui) .. "|r")
		local liste = {}
		for k = 1, EffetsVus(l, cache) do liste[#liste + 1] = l.effets[k] end
		if a and not cache and a.id == l.id and not a.envoye then
			local txt = ChoixEnAttente() and "double 6 : 6 attaques ou relance"
				or (AttaquesConnues() and ("%d attaques à distribuer"):format(a.n)) or "relance…"
			local placees, vise = 0, a.qui == moi and a.repartition or a.vise
			for _, k in pairs(vise or {}) do placees = placees + k end
			if AttaquesConnues() and placees > 0 then txt = txt .. (" · %d placée%s"):format(placees, placees > 1 and "s" or "") end
			liste[#liste + 1] = { k = "att", cle = a.qui, texte = txt, enCours = true }
		end
		for k = 1, math.min(#liste, LIGNES_BOITE) do
			local ef = liste[k]
			if k == LIGNES_BOITE and #liste > LIGNES_BOITE then
				ef = { texte = ("+ %d autres effets : voir les derniers lancers"):format(#liste - LIGNES_BOITE + 1) }
			end
			bo.lignes[k]:Poser(ef)
		end
	else
		bo.titre:Hide()
		bo.filet:Hide()
		bo.de1:Hide()
		bo.de2:Hide()
		bo.par:SetText("")
		bo.vide:SetText(infoSeule or "Aucun lancer pour l'instant")
		bo.vide:Show()
	end

	-- à droite : les derniers lancers, chacun avec ses effets en dessous ; le premier (le lancer en cours)
	-- est encadré, sans sa somme (c'est à chacun de voir le 7)
	local premier = 1
	if masque then
		premier = #historique + 1
		for j, h in ipairs(historique) do
			if h == masque.entree then premier = j; break end
		end
	end
	local y, nL, nS = 0, 0, 0
	for j = premier, #historique do
		local h = historique[j]
		nL = nL + 1
		local ligne = LigneHistorique(cote, nL)
		ligne:ClearAllPoints()
		ligne:SetPoint("TOPLEFT", cote.liste.contenu, "TOPLEFT", 0, -y)
		ligne:SetPoint("RIGHT", cote.liste.contenu, "RIGHT", 0, 0)
		ligne.nom:SetText(NomJoueur(h.qui))
		ligne.nom:SetTextColor(unpack(h.qui == moi and C.ors or C.texte))
		ligne.de1:SetTexture(FACE .. h.d1)
		ligne.de2:SetTexture(FACE .. h.d2)
		local somme = h.d1 + h.d2
		ligne.total:SetText(nL > 1 and tostring(somme) or "")
		ligne.total:SetTextColor(unpack(somme == 7 and C.ors or C.texte))
		ligne:Show()
		local haut = y
		y = y + HAUT_LIGNE
		for k = 1, EffetsVus(h, cache) do
			nS = nS + 1
			local sous = SousLigne(cote, nS)
			sous:ClearAllPoints()
			sous:SetPoint("TOPLEFT", cote.liste.contenu, "TOPLEFT", 0, -y)
			sous:SetPoint("RIGHT", cote.liste.contenu, "RIGHT", 0, 0)
			sous:Poser(h.effets[k])
			y = y + HAUT_SOUS
		end
		if nL == 1 then
			cote.actuel:ClearAllPoints()
			cote.actuel:SetPoint("TOPLEFT", cote.liste.contenu, "TOPLEFT", -2, -haut)
			cote.actuel:SetPoint("RIGHT", cote.liste.contenu, "RIGHT", 0, 0)
			cote.actuel:SetHeight(y - haut + 3)
		end
		y = y + 5
	end
	cote.actuel:SetShown(nL > 0)
	cote.vide:SetShown(nL == 0)
	for i = nL + 1, #cote.lignes do cote.lignes[i]:Hide() end
	for i = nS + 1, #cote.sous do cote.sous[i]:Hide() end
	cote.liste:Hauteur(math.max(1, y))
	local refusDepart = mienne and RefusDepart(moi)
	cote.lever:Activer(mienne ~= nil and not refusDepart)
	cote.lever:Ecrire(refusDepart or (GetTime() - confirmeDepart <= 3 and "Confirmer ? (sans retour)") or "Quitter la table")
	cote.appel:Activer(PeutAppeler())
	cote.appel:Ecrire((GetTime() - dernierAppel < DELAI_APPEL and "Appel envoyé")
		or (mienne and Assis() >= PLACES and "Table complète") or "Appeler la guilde")
	local relance = PeutRelancerPartie(moi)
	cote.nouvelle:Activer(relance)
	cote.nouvelle:Ecrire(GetTime() - confirmeNouvelle <= 3 and "Confirmer ?"
		or (mienne and not relance and createur and ("Nouvelle partie : %s seul"):format(NomCourt and NomCourt(createur) or createur))
		or "Nouvelle partie")
end

--------------------------------------------------------------------------------
-- L'onglet de la page Jeux
--------------------------------------------------------------------------------

local function CreerOnglet(parent)
	local largeur = parent:GetWidth()
	if not largeur or largeur < 100 then largeur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) - 32 end
	local f = CreateFrame("Frame", nil, parent)
	f:SetAllPoints()
	f.table = CreerTable(f)
	f.table:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	f.table:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
	f.table:SetWidth(math.max(520, math.floor((largeur - 12) * 0.68)))
	f.cote = CreerCote(f)
	f.cote:SetPoint("TOPLEFT", f.table, "TOPRIGHT", 12, 0)
	f.cote:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
	f:SetScript("OnShow", function() Demander(); Maj() end)
	f.Maj = function() Demander(); Maj() end
	vue = f
	return f
end

if ns.AjouterJeu then ns.AjouterJeu("Bizkit", CreerOnglet, "bizkit") end

-- /smb bizkit : la page Jeux sur le Bizkit
ns.MontrerBizkit = function()
	if ns.OuvrirInterface then ns.OuvrirInterface("jeux", "bizkit") end
end

--------------------------------------------------------------------------------
-- Événements et minuteries
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_SYSTEM")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_REGEN_ENABLED")
ev:SetScript("OnEvent", function(_, event, texte)
	if event == "CHAT_MSG_SYSTEM" then
		LireJet(texte)
	elseif event == "PLAYER_REGEN_ENABLED" then
		-- fin du combat : la bulle d'un appel reçu pendant le combat, s'il vaut encore
		local a = appel
		if a and a.bulle then
			a.bulle = nil
			if AppelValide() then BulleAppel(a) end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		ev:UnregisterEvent("PLAYER_ENTERING_WORLD")
		-- après un /reload ou une courte déconnexion, je reprends ma place et mes coups
		C_Timer.After(8, function()
			local p = DB().bizkit
			if type(p) == "table" and tonumber(p.place) and ns.Maintenant() - (tonumber(p.quand) or 0) < REPRISE then
				local moi = MaCle()
				-- (noté avant les coups : des points restants)
				local n = tonumber(p.coups) or (tonumber(p.points) and math.max(0, ANCIEN_DEPART - tonumber(p.points)))
				if moi and n then coups[moi] = n end
				Envoyer(("A~%d~~%d"):format(p.place, AnciensPoints(moi)))
				Envoyer("C~" .. Coups(moi))
				Demander()
			else
				NoterMaPlace(nil)
			end
		end)
	end
end)

-- toutes les 0,25 s : délais du Bizkit ; toutes les 2 s : lecture des dés trop longue, membres
-- déconnectés, ma place notée
local ecoule, ecouleLent = 0, 0
ev:SetScript("OnUpdate", function(_, dt)
	ecoule = ecoule + dt
	if ecoule < 0.25 then return end
	ecouleLent = ecouleLent + ecoule
	ecoule = 0
	local moi = MaCle()
	local b = bizkit
	if b then
		local maintenant = GetTime()
		if b.lanceur == moi and not b.annonce then
			-- c'est moi, le lanceur, qui tranche : ceux qui n'ont pas crié à temps perdent
			if maintenant - b.debut > DELAI_COURSE then
				local perdants = {}
				for cle in pairs(b.requis) do
					if not b.rang[cle] then perdants[#perdants + 1] = cle end
				end
				b.annonce = true
				Envoyer("P~" .. b.id .. "~" .. table.concat(perdants, ","))
			end
		elseif b.lanceur ~= moi and maintenant - b.debut > DELAI_COURSE + SANS_NOUVELLES then
			bizkit = nil
			Effet("info", nil, nil, "Bizkit abandonné : le lanceur ne répond plus")
			Maj()
		end
	end
	local a = attaque
	if a then
		local maintenant = GetTime()
		if a.qui == moi and not a.envoye and maintenant - a.debut > DELAI_ATTAQUE then
			-- temps écoulé : les attaques déjà placées partent, les autres sont perdues
			EnvoyerAttaques()
		elseif a.qui ~= moi and maintenant - a.debut > DELAI_ATTAQUE + SANS_NOUVELLES then
			attaque = nil
			Effet("info", nil, nil, "Attaques abandonnées : le lanceur ne répond plus")
			Maj()
		end
	end

	if ecouleLent < 2 then return end
	ecouleLent = 0
	if attente and GetTime() > attente.limite then
		-- (relance d'un double 6 pas lue : le choix revient au joueur)
		if attente.relance and attaque and attaque.id == attente.relance and not attaque.relance then attaque.choisi = nil end
		attente = nil
		Erreur("Tes dés n'ont pas été lus : relance")
		Maj()
	end
	local change = false
	for i = 1, PLACES do
		local cle = places[i]
		if cle and cle ~= moi and ns.MembreGuilde and ns.EnLigneMembre
			and ns.MembreGuilde(cle) ~= nil and not ns.EnLigneMembre(cle) then
			places[i] = nil
			RetirerDuBizkit(cle)
			if attaque and attaque.qui == cle then attaque = nil end
			change = true
		end
	end
	if change then
		VerifierTableVide()
		NoterTour()
		Maj()
	end
	local mienne = PlaceDe(moi)
	if mienne then NoterMaPlace(mienne) end
end)

ns.Ecouter(PREFIXE, Recevoir)
