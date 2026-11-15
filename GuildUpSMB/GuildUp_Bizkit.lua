-- GuildUpSMB : le Bizkit, jeu de dés de la guilde (onglet « Bizkit » de la page Jeux, /smb bizkit, préfixe "GuildUpBzk").
-- Une table ovale pour toute la guilde, huit places autour. Un membre clique sur une place libre pour
-- s'asseoir (ou changer de place), « Quitter la table » pour se lever. Chacun commence avec POINTS_DEPART points.
-- Chacun son tour, dans l'ordre des places (sens des aiguilles d'une montre), le joueur lance deux dés :
-- l'addon fait deux /roll 1-6 du jeu (le hasard vient du serveur, les joueurs à côté le voient passer dans
-- leur discussion), lit les deux résultats (ns.LireMonJet de GuildUp_Tirage.lua) et les envoie à la guilde avec
-- l'endroit où les dés se posent, tiré au hasard sur le tapis, entre les joueurs. Tout le monde voit les dés
-- partir de la place du lanceur, rouler et se poser au même endroit.
-- Le Bizkit : le bouton « Bizkit ! » est toujours là, à côté de « Lancer les dés », et ne change pas
-- d'aspect (rien ne trahit un 7). Un clic crie « Bizkit ! » dans la discussion de guilde. Quand les dés font
-- 7, tous les joueurs assis doivent cliquer, le lanceur comme les autres, dans n'importe quel ordre : le
-- dernier perd un point. Dès qu'il ne reste qu'un joueur qui n'a pas cliqué, c'est lui le dernier : il perd
-- sans attendre (seul à la table, il est le dernier). Ceux qui n'ont pas cliqué au bout de DELAI_COURSE
-- secondes perdent tous (c'est le lanceur qui l'annonce, « P »). Un clic alors que les dés posés ne font pas
-- 7 coûte un point (une fois par lancer). Le bouton attend que les dés soient posés. Pendant un Bizkit,
-- personne ne lance ; ensuite le tour passe au joueur suivant.
-- La prison de 3 : un lancer qui fait 3 (1 + 2) envoie le lanceur en prison de 3, et en fait sortir celui qui
-- y était (un seul prisonnier à la fois). À chaque lancer, de n'importe quel joueur (le prisonnier compris),
-- chaque dé qui montre un 3 enlève un point au prisonnier : deux points sur un double 3. Le prisonnier qui
-- refait 3 monte d'un cran (PRISONS : La Prison, Prison du cuirassé,
-- Donjon de Fort-de-Durn, Prison d'Alcaz) et chaque 3 lui coûte alors
-- autant de points que le numéro du cran (2, 3, 4, 5) ; au dernier cran, il y reste. Quand un autre joueur
-- fait 3, le prisonnier sort, quel que soit le cran, et le nouveau entre au premier (prison de 3). Le
-- prisonnier qui se lève reste en prison : seul un autre 3 l'en fait sortir.
-- La prison de 5 : un lancer qui fait 5 envoie le lanceur en prison de 5 si elle est vide (un seul
-- prisonnier de 5 à la fois). Tant qu'il y est, chaque 5 d'un autre joueur lui coûte un point, et ce joueur
-- reste libre. Le prisonnier de 5 en sort en refaisant 5 à son tour. Elle est indépendante de la prison de 3
-- (on peut être dans les deux), et le prisonnier de 5 qui se lève y reste aussi.
-- Les doubles : le lanceur distribue autant d'attaques que la valeur du dé (double 1 : 7 attaques) aux autres
-- joueurs assis, comme il veut (clic sur une place : une attaque, clic droit : en retirer une) ; chaque
-- attaque coûte un point. Double 6 : au choix, 6 attaques, ou une relance dont la somme des dés donne le
-- nombre d'attaques (la relance ne déclenche aucune autre règle). Au plus MAX_PAR_JOUEUR attaques sur un
-- même joueur : celles que personne d'autre ne peut plus recevoir, le lanceur se les met à lui-même (seul à
-- la table : toutes). Il a DELAI_ATTAQUE secondes : ensuite, les attaques déjà placées partent (et celles
-- pour lui), les autres sont perdues. Pendant les attaques, personne ne lance.
-- Le 9, le 10 et le 11 (somme des dés) : 9, le joueur assis avant le lanceur (celui qui a joué avant lui)
-- perd un point ; 10, le lanceur perd un point ; 11, le joueur assis après lui perd un point. Seul à la
-- table, le 9 et le 11 ne coûtent rien.
-- Le vecteur : un lancer qui n'est pas un double et dont la somme ne déclenche rien (4, 6 ou 8 ; un dé qui
-- montre un 3 et coûte au prisonnier de 3 ne compte pas comme un effet) trace une ligne du plus petit dé vers
-- le plus grand : si son point d'arrivée tombe près d'un joueur assis (moins de TOUCHE pixels, le lanceur
-- compris), ce joueur perd un point ; sinon, dégâts de zone : les deux joueurs les plus proches perdent un
-- point. Chacun fait le calcul avec les positions des dés reçues : tous trouvent les mêmes.
-- Un lancer en rappel (« ~1 ») ne change ni les prisons ni les points.
-- Tout changement est appliqué à la réception, mes messages compris (le serveur les renvoie à tous dans le
-- même ordre) : si deux membres prennent la même place en même temps, le premier arrivé l'a, et l'ordre
-- des cris est celui de leur arrivée.
--   "A~place"                   je m'assois à cette place (1 à 8) ; déjà assis ailleurs : je change de place
--   "A~place~derniere~points~prisonnier~cran~prisonnier5"  réponse à « Q » ou retour après un /reload : ma
--                               place, la place du dernier lanceur que je connais (ou vide), mes points, la clé
--                               du prisonnier de 3 et son cran (1 à 5), la clé du prisonnier de 5 (vides s'il n'y
--                               en a pas) ; adoptés par qui ne les connaît pas
--   "D"                         je me lève
--   "L~id~d1~d2~x1~y1~a1~x2~y2~a2[~1]"  mon lancer : id = heure du serveur en base 36 ; d1, d2 de 1 à 6 ;
--                               x, y de 0 à 200 (100 = centre du tapis) ; a = angle du dé en degrés ;
--                               « ~1 » = rappel pour qui vient d'ouvrir la table (ni Bizkit, ni prison, ni points)
--   "B~id"                      je crie « Bizkit ! » (id = celui du lancer qui a fait 7)
--   "P~id~clé,clé…"             le lanceur annonce ceux qui n'ont pas crié à temps : ils perdent un point
--   "R~id~d1~d2~x1~y1~a1~x2~y2~a2"  relance d'un double 6 (id = celui du double) : la somme = les attaques
--   "T~id~clé:n,clé:n…"         mes attaques (id = celui du double) : chaque joueur cité perd n points
--   "N"                         nouvelle partie : tous les joueurs repartent à POINTS_DEPART points, prison vide
--   "Q"                         j'ouvre la table : les membres assis renvoient « A~place~derniere~points », et
--                               l'auteur du dernier lancer le renvoie en rappel (même id : déjà vu, ignoré)
-- C'est au tour du joueur assis après le dernier lanceur ; sans lancer connu, de la première place occupée.
-- Un joueur qui tarde (TARDE secondes) peut être sauté : le suivant peut lancer à sa place. Les places des
-- membres déconnectés sont libérées. Ma place et mes points sont notés dans GuildUpDB (db.bizkit) pour les
-- reprendre après un /reload ; le reste n'est pas gardé d'une session à l'autre.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpBzk"
local PLACES = 8
local POINTS_DEPART = 30
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

local Normaliser = ns.Normaliser
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local MaCle = ns.MaCle
local Base36 = ns.Base36
local Erreur = ns.Erreur

local places = {}            -- [place] = clé du membre assis
local points = {}            -- [clé] = points du joueur (gardés s'il se lève, pour la session)
local derniere               -- place du dernier lanceur (le tour passe au suivant)
local dernierLancer          -- le dernier lancer reçu (voir Recevoir, genre « L »)
local historique = {}        -- lancers et Bizkit, le plus récent en premier
local annonce = ""           -- la dernière nouvelle de la table, sous les places
local bizkit                 -- le Bizkit en cours (voir NouveauBizkit)
local prison                 -- clé du joueur en prison de 3
local cran = 1               -- son cran dans PRISONS (1 = prison de 3)
local prison5                -- clé du joueur en prison de 5
local attaque                -- les attaques d'un double en cours (voir NouvelleAttaque)
local tourCle                -- membre dont c'est le tour, et depuis quand
local debutTour = 0
local attente                -- { limite, valeurs } : j'ai lancé, j'attends mes deux /roll
local demande = false        -- « Q » déjà envoyé cette session
local vue                    -- l'onglet (créé à la première ouverture)
local Maj = function() end
local Animer = function() end
local Toucher = function() end -- (animation des points perdus sur la place du joueur)

local function DB() return (ns.DB and ns.DB()) or {} end
-- (jamais en fond : la voie lente du réseau ne renvoie pas un message identique, or « A~3 » peut revenir)
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD", nil, { fond = false }) end end
local function Son(nom) if ns.Son then ns.Son(nom) end end

--------------------------------------------------------------------------------
-- Places, points et tour de jeu
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

local function Points(cle) return points[cle] or POINTS_DEPART end

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

local function PeutLancer()
	local mienne = PlaceDe(MaCle())
	if not mienne or attente or bizkit or attaque then return false end
	local tarde, tour = Tarde()
	return tour == mienne or (tarde and Suivante(tour) == mienne)
end

-- ma place et mes points, pour les reprendre après un /reload
local function NoterMaPlace(place)
	DB().bizkit = place and { place = place, quand = ns.Maintenant(), points = Points(MaCle()) } or nil
end

-- n points en moins pour ce joueur (jamais sous zéro)
local function Retirer(cle, n)
	points[cle] = math.max(0, Points(cle) - n)
	Toucher(cle, n)
	if cle == MaCle() then
		local mienne = PlaceDe(cle)
		if mienne then NoterMaPlace(mienne) end
		Son("IG_QUEST_FAILED")
	end
end

local function Noter(entree)
	table.insert(historique, 1, entree)
	if #historique > HISTORIQUE then historique[#historique] = nil end
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

-- fin du Bizkit : chaque perdant perd un point
local function FinBizkit(perdants)
	local noms = {}
	for _, cle in ipairs(perdants) do
		Retirer(cle, 1)
		noms[#noms + 1] = NomJoueur(cle) .. (" (%d)"):format(Points(cle))
	end
	Noter({ genre = "bizkit", perdants = perdants })
	annonce = #perdants > 0 and ("Bizkit ! %s perd un point"):format(table.concat(noms, ", ")) or "Bizkit annulé"
	if #perdants > 1 then annonce = ("Bizkit ! %s perdent un point"):format(table.concat(noms, ", ")) end
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
		FinBizkit(restants)
	elseif #restants == 0 then
		-- (seul à la table, ou les autres partis : le dernier à avoir crié)
		FinBizkit(#b.appuis > 0 and { b.appuis[#b.appuis] } or {})
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

-- clic sur une place pendant ma distribution : une attaque de plus (sens = -1 : une de moins)
local function Viser(place, sens)
	if not JeDistribue() then return end
	local cle = places[place]
	if not cle or cle == MaCle() then return end
	local r = attaque.repartition
	if sens > 0 and Distribuees() < APlacer() and (r[cle] or 0) < MAX_PAR_JOUEUR then
		r[cle] = (r[cle] or 0) + 1
	elseif sens < 0 and r[cle] then
		r[cle] = r[cle] > 1 and r[cle] - 1 or nil
	end
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
		Maj()
	end
end

-- double 6 : 6 attaques tout de suite
local function ChoisirSix()
	if not ChoixEnAttente() or attaque.qui ~= MaCle() then return end
	attaque.choisi = "six"
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

-- fin des attaques : chaque cible perd ses points
local function FinAttaque(cibles)
	local a = attaque
	local textes = {}
	for _, c in ipairs(cibles) do
		Retirer(c.cle, c.n)
		textes[#textes + 1] = ("%s -%d"):format(NomJoueur(c.cle), c.n)
	end
	Noter({ genre = "attaque", qui = a.qui, cibles = cibles })
	if #cibles > 0 then
		annonce = ("%s attaque : %s"):format(NomJoueur(a.qui), table.concat(textes, ", "))
	else
		annonce = ("%s n'attaque personne"):format(NomJoueur(a.qui))
	end
	attaque = nil
	debutTour = GetTime() -- (le joueur suivant ne « tarde » pas pendant les attaques)
	Maj()
end

--------------------------------------------------------------------------------
-- Actions
--------------------------------------------------------------------------------

local function Asseoir(place)
	if places[place] then return end
	Envoyer("A~" .. place)
end

local function Lever()
	if PlaceDe(MaCle()) then Envoyer("D") end
	NoterMaPlace(nil)
end

local confirmeNouvelle = 0
local function NouvellePartie()
	if not PlaceDe(MaCle()) then return end
	-- deux clics à moins de 3 s : on ne remet pas les points de tout le monde à zéro par erreur
	if GetTime() - confirmeNouvelle > 3 then
		confirmeNouvelle = GetTime()
		Maj()
		return
	end
	confirmeNouvelle = 0
	Envoyer("N")
end

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

-- le Bizkit commence chez moi : la page s'ouvre si elle est fermée, pour que je puisse crier
-- (sans son : rien ne doit trahir le 7 à ceux qui regardent la table)
local function Alerter()
	if not (vue and vue:IsVisible()) and ns.OuvrirInterface then ns.OuvrirInterface("jeux", "bizkit") end
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
		if avant and avant ~= place then places[avant] = nil end
		places[place] = qui
		pts = tonumber(pts)
		if not points[qui] then points[qui] = pts and math.max(0, math.min(pts, 999)) or POINTS_DEPART end
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
		if qui == moi then NoterMaPlace(nil) end
		if p then
			places[p] = nil
			RetirerDuBizkit(qui)
			if attaque and attaque.qui == qui then
				attaque = nil
				annonce = ("Attaques annulées : %s a quitté la table"):format(NomJoueur(qui))
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
		local l = {
			genre = "lancer", qui = qui, id = champs[1], place = p, d1 = d1, d2 = d2,
			x1 = (n[3] - 100) / 100, y1 = (n[4] - 100) / 100, a1 = n[5],
			x2 = (n[6] - 100) / 100, y2 = (n[7] - 100) / 100, a2 = n[8],
		}
		l.brut = ("L~%s~%d~%d~%d~%d~%d~%d~%d~%d~1"):format(l.id, d1, d2, n[3], n[4], n[5], n[6], n[7], n[8])
		dernierLancer = l
		derniere = p
		Noter(l)
		if d1 == d2 then
			annonce = ("%s : double %d"):format(NomJoueur(qui), d1)
		else
			annonce = ("%s : %d + %d = %d"):format(NomJoueur(qui), d1, d2, d1 + d2)
		end
		if not rappel then
			-- chaque 3 sorti coûte au prisonnier autant de points que son cran
			local trois = (d1 == 3 and 1 or 0) + (d2 == 3 and 1 or 0)
			if trois > 0 and prison then
				local perte = trois * cran
				Retirer(prison, perte)
				Noter({ genre = "peine", qui = prison, n = perte, cran = cran })
				annonce = annonce .. (" · %s perd %d point%s (%s)"):format(NomJoueur(prison), perte, perte > 1 and "s" or "", PRISONS[cran])
			end
			if d1 + d2 == 3 then
				if prison == qui then
					-- le prisonnier refait 3 : un cran de plus (au dernier, il y reste)
					cran = math.min(cran + 1, #PRISONS)
					Noter({ genre = "prison", qui = qui, cran = cran })
					annonce = annonce .. (" · direction : %s !"):format(PRISONS[cran])
				else
					-- un autre joueur : le prisonnier sort, quel que soit le cran, et le nouveau entre au premier
					Noter({ genre = "prison", qui = qui, avant = prison, cran = 1 })
					prison, cran = qui, 1
					annonce = annonce .. " · en prison de 3 !"
				end
			end
			-- prison de 5 : on y entre si elle est vide ; un 5 d'un autre coûte un point au prisonnier ; le
			-- prisonnier en sort en refaisant 5
			if d1 + d2 == 5 then
				if not prison5 then
					prison5 = qui
					Noter({ genre = "prison5", qui = qui })
					annonce = annonce .. " · en prison de 5 !"
				elseif prison5 == qui then
					prison5 = nil
					Noter({ genre = "prison5", qui = qui, sort = true })
					annonce = annonce .. " · sort de la prison de 5 !"
				else
					Retirer(prison5, 1)
					Noter({ genre = "peine", qui = prison5, n = 1, lieu = "Prison de 5" })
					annonce = annonce .. (" · %s perd 1 point (prison de 5)"):format(NomJoueur(prison5))
				end
			end
			-- le 9 : le joueur d'avant perd un point ; le 10 : le lanceur ; le 11 : le joueur d'après
			local somme = d1 + d2
			if somme >= 9 and somme <= 11 then
				local cible = qui
				if somme ~= 10 then
					local voisin = somme == 9 and Precedente(p) or Suivante(p)
					cible = voisin and voisin ~= p and places[voisin] or nil
				end
				if cible then
					Retirer(cible, 1)
					Noter({ genre = "peine", qui = cible, n = 1, lieu = ({ [9] = "Le 9", [10] = "Le 10", [11] = "Le 11" })[somme] })
					annonce = annonce .. (" · %s perd 1 point"):format(NomJoueur(cible))
				end
			end
			-- le vecteur : pas de double, et une somme sans effet (le 3 de la prison de 3 ne compte pas)
			local effet = d1 == d2 or somme == 3 or somme == 5 or somme == 7 or (somme >= 9 and somme <= 11)
			if not effet then
				local vises, trace = Vecteur(l)
				if vises then
					l.trace = trace
					local noms = {}
					for _, cle in ipairs(vises) do
						Retirer(cle, 1)
						Noter({ genre = "peine", qui = cle, n = 1, lieu = #vises > 1 and "Zone" or "Vecteur" })
						noms[#noms + 1] = NomJoueur(cle)
					end
					if #vises > 1 then
						annonce = annonce .. (" · dégâts de zone : %s perdent 1 point"):format(table.concat(noms, " et "))
					else
						annonce = annonce .. (" · vecteur : %s perd 1 point"):format(noms[1])
					end
				end
			end
			if d1 + d2 == 7 then
				NouveauBizkit(l)
				if bizkit.requis[moi] then Alerter() end
			end
			-- un double : des attaques à distribuer
			if d1 == d2 then
				NouvelleAttaque(l)
				if d1 == 6 then
					annonce = annonce .. " · 6 attaques, ou relance !"
				else
					annonce = annonce .. (" · %d attaques à distribuer"):format(attaque.n)
				end
			end
		end
		NoterTour()
		Animer(l)
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
		a.relance = { d1, d2 }
		a.choisi = "relance"
		a.n = d1 + d2
		Noter({ genre = "relance", qui = qui, d1 = d1, d2 = d2 })
		annonce = ("%s relance : %d + %d = %d attaques à distribuer"):format(NomJoueur(qui), d1, d2, a.n)
		local p = PlaceDe(qui)
		if p then
			Animer({ place = p, d1 = d1, d2 = d2, x1 = (n[3] - 100) / 100, y1 = (n[4] - 100) / 100, a1 = n[5],
				x2 = (n[6] - 100) / 100, y2 = (n[7] - 100) / 100, a2 = n[8] })
		end
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
		local b = bizkit
		if b and b.id == l.id then
			if not b.requis[qui] or b.rang[qui] then return end
			b.appuis[#b.appuis + 1] = qui
			b.rang[qui] = #b.appuis
			VerifierBizkit()
			Maj()
		elseif l.d1 + l.d2 ~= 7 then
			-- faux Bizkit : les dés ne font pas 7, un point (une fois par lancer)
			l.faux = l.faux or {}
			if l.faux[qui] then return end
			l.faux[qui] = true
			Retirer(qui, 1)
			Noter({ genre = "peine", qui = qui, n = 1, lieu = "Faux Bizkit" })
			annonce = annonce .. (" · %s crie Bizkit pour rien : -1"):format(NomJoueur(qui))
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
		FinBizkit(perdants)
	elseif genre == "N" then
		if not PlaceDe(qui) then return end
		for cle in pairs(points) do points[cle] = POINTS_DEPART end
		historique = {}
		bizkit, attaque = nil, nil
		prison, cran, prison5 = nil, 1, nil
		annonce = ("Nouvelle partie lancée par %s : tout le monde repart à %d points"):format(NomJoueur(qui), POINTS_DEPART)
		if PlaceDe(moi) then NoterMaPlace(PlaceDe(moi)) end
		Maj()
	elseif genre == "Q" then
		if qui == moi then return end
		local mienne = PlaceDe(moi)
		if not mienne then return end
		-- après un délai au hasard, pour ne pas répondre tous en même temps
		C_Timer.After(0.5 + math.random() * 2.5, function()
			if PlaceDe(moi) ~= mienne then return end
			Envoyer(("A~%d~%s~%d~%s~%s~%s"):format(mienne, derniere and tostring(derniere) or "", Points(moi), prison or "",
				prison and tostring(cran) or "", prison5 or ""))
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
	-- jeton des points, à cheval sur le bas du portrait
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
	-- points perdus : un éclair rouge sur le portrait, et « -2 » qui monte et s'efface (voir Toucher)
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
	-- attaques que je lui donne pendant ma distribution (« -2 »), au milieu du portrait
	b.attaque = b.dessus:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
	b.attaque:SetPoint("CENTER", b, "CENTER", 0, 0)
	b.attaque:SetTextColor(1, 0.35, 0.3)
	b.nom = UI.Texte(b, "GameFontHighlightSmall", C.texte)
	b.nom:SetJustifyH("CENTER")
	b.nom:SetWidth(100)
	local _, y = PositionPlace(i)
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
			GameTooltip:AddLine(PlaceDe(MaCle()) and "Clic : changer de place" or "Clic : t'asseoir ici", 1, 1, 1)
		else
			GameTooltip:SetText(NomJoueur(cle))
			GameTooltip:AddLine(("%d point%s"):format(Points(cle), Points(cle) > 1 and "s" or ""), 1, 1, 1)
			if cle == prison then
				GameTooltip:AddLine(("%s : chaque 3 sorti lui coûte %s"):format(PRISONS[cran],
					cran > 1 and (cran .. " points") or "un point"), 1, 0.45, 0.4, true)
			end
			if cle == prison5 then
				GameTooltip:AddLine("Prison de 5 : chaque 5 d'un autre joueur lui coûte un point ; refaire 5 l'en sort", 0.55, 0.75, 1, true)
			end
			if JeDistribue() and cle ~= MaCle() then
				GameTooltip:AddLine(("Clic : une attaque (%d au plus) · clic droit : en retirer une"):format(MAX_PAR_JOUEUR), 1, 0.45, 0.4)
			elseif self.place == PlaceDuTour() and not bizkit and not attaque then
				GameTooltip:AddLine("C'est son tour", 1, 0.82, 0)
			end
		end
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

local function CreerTable(parent)
	local UI = ns.UI
	local C = UI.C
	local f = UI.Carte(parent, "Bizkit")
	f.vide:Hide()

	-- la table au centre de la zone de jeu, les places autour
	f.zone = CreateFrame("Frame", nil, f)
	f.zone:SetSize(LARGEUR_TABLE, HAUTEUR_TABLE)
	f.zone:SetPoint("TOP", f, "TOP", 0, -40 - ECART_PLACE - TAILLE_PLACE / 2 - 18)
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

	-- sous la table : la dernière nouvelle, à qui le tour, le bouton
	f.resultat = UI.Texte(f, "GameFontNormalLarge", C.ors)
	f.resultat:SetPoint("TOP", f.zone, "BOTTOM", 0, -ECART_PLACE - TAILLE_PLACE / 2 - 30)
	f.resultat:SetPoint("LEFT", f, "LEFT", 14, 0)
	f.resultat:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.resultat:SetJustifyH("CENTER")
	f.etat = UI.Texte(f, "GameFontHighlight", C.texte)
	f.etat:SetPoint("TOP", f.resultat, "BOTTOM", 0, -6)
	f.etat:SetPoint("LEFT", f, "LEFT", 14, 0)
	f.etat:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.etat:SetJustifyH("CENTER")
	f.etat:SetWordWrap(true)
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
	-- à sa gauche, pendant mes attaques : « 6 attaques » (double 6) ou « Effacer »
	f.secondaire = UI.Bouton(f, "", "fantome", 120, 32)
	f.secondaire:SetPoint("RIGHT", f.lancer, "LEFT", -8, 0)
	f.secondaire:SetScript("OnClick", function()
		if ChoixEnAttente() then ChoisirSix() else EffacerAttaques() end
	end)
	f.secondaire:Hide()
	-- à sa droite, toujours là et toujours pareil (rien ne doit trahir un 7) : « Bizkit ! »
	f.crier = UI.Bouton(f, CRI, "aide", 110, 32)
	f.crier:SetPoint("LEFT", f.lancer, "RIGHT", 8, 0)
	f.crier:SetScript("OnClick", Crier)
	UI.Infobulle(f.crier, CRI, "Sur un 7, tout le monde clique : le dernier perd un point. Un clic quand les dés ne font pas 7 coûte un point.")

	-- animation des dés et des points perdus (le halo des places reste fixe : voir CreerPlace)
	local attenteMaj = 0
	f:SetScript("OnUpdate", function(self, dt)
		if self.roule then self:Rouler() end
		for _, b in ipairs(self.places) do
			if b.perteDebut then b:AnimerPerte() end
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
			if not r.instantane then Son("U_CHAT_SCROLL_BUTTON") end
		end
	end
	f:Rouler()
end

Animer = function(l)
	if not vue or not vue.table then return end
	-- page cachée : les dés sont posés directement, sans animation
	AnimerDes(vue.table, l, not vue:IsVisible())
end

-- un joueur perd n points : « -n » monte au-dessus de sa place, son portrait rougit. Si les dés roulent
-- encore, l'animation attend qu'ils soient posés (rien n'est dévoilé avant) ; plusieurs pertes rapprochées
-- s'additionnent.
Toucher = function(cle, n)
	if not vue or not vue.table or not vue:IsVisible() then return end
	local t = vue.table
	local p = PlaceDe(cle)
	local b = p and t.places[p]
	if not b then return end
	local debut = GetTime()
	if t.roule and not t.roule.instantane then debut = math.max(debut, t.roule.debut + DUREE_ROULE) end
	if b.perteDebut and debut - b.perteDebut < 0.5 then
		b.perteN = b.perteN + n
	else
		b.perteN = n
	end
	b.perteDebut = debut
	b.perte:SetText("-" .. b.perteN)
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
	f.liste:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 146)
	f.lignes = {}
	-- en bas, de haut en bas : les deux prisons, les règles (au survol), nouvelle partie, quitter la table
	f.prison = UI.Texte(f, "GameFontHighlight", C.texte)
	f.prison:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 124)
	f.prison:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.prison5 = UI.Texte(f, "GameFontHighlight", C.texte)
	f.prison5:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 106)
	f.prison5:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.regles = CreateFrame("Button", nil, f)
	f.regles:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 78)
	f.regles:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.regles:SetHeight(20)
	f.regles.texte = UI.Texte(f.regles, "GameFontHighlightSmall", C.gris)
	f.regles.texte:SetPoint("LEFT", 0, 0)
	f.regles.texte:SetText("|cfff1cf6b?|r  Les règles du Bizkit (survol)")
	UI.Infobulle(f.regles, "Les règles du Bizkit", table.concat({
		("Chacun son tour lance deux dés. Départ : %d points."):format(POINTS_DEPART),
		"",
		"|cffffd1007|r : tout le monde clique sur « Bizkit ! », le lanceur aussi, dans n'importe quel ordre. Le dernier perd un point. Cliquer quand les dés ne font pas 7 coûte un point.",
		"",
		"|cffffd1003|r (1 + 2) : prison de 3, un seul prisonnier à la fois. Chaque dé qui montre un 3, chez n'importe qui, lui coûte un point. S'il refait 3, il monte d'un cran : chaque 3 coûte alors 2, 3, 4 puis 5 points. Un autre joueur qui fait 3 prend sa place, au premier cran.",
		"",
		"|cffffd1005|r : prison de 5 si elle est vide. Chaque 5 d'un autre joueur coûte un point au prisonnier, qui sort en refaisant 5.",
		"",
		"|cffffd100Doubles|r : autant d'attaques que la valeur du dé (double 1 : 7), à distribuer aux autres joueurs ; chaque attaque coûte un point, 7 au plus par joueur (le reste, pour soi). Double 6 : 6 attaques, ou une relance dont la somme donne les attaques.",
		"",
		"|cffffd1009|r : le joueur d'avant perd un point. |cffffd10010|r : le lanceur perd un point. |cffffd10011|r : le joueur d'après perd un point.",
		"",
		"|cffffd100Le vecteur|r : sur un 4, un 6 ou un 8 (pas un double), une ligne part du plus petit dé vers le plus grand. Si elle arrive près d'un joueur, il perd un point ; sinon, dégâts de zone : les deux joueurs les plus proches perdent un point.",
	}, "\n"))
	f.lever = UI.Bouton(f, "Quitter la table", "fantome", 100, 26)
	f.lever:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 14, 14)
	f.lever:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.lever:SetScript("OnClick", Lever)
	f.nouvelle = UI.Bouton(f, "Nouvelle partie", "fantome", 100, 26)
	f.nouvelle:SetPoint("BOTTOMLEFT", f.lever, "TOPLEFT", 0, 6)
	f.nouvelle:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.nouvelle:SetScript("OnClick", NouvellePartie)
	UI.Infobulle(f.nouvelle, "Nouvelle partie", ("Tous les joueurs repartent à %d points. Deux clics pour confirmer."):format(POINTS_DEPART))
	return f
end

local function LigneHistorique(f, i)
	local l = f.lignes[i]
	if l then return l end
	local UI = ns.UI
	local C = UI.C
	l = CreateFrame("Frame", nil, f.liste.contenu)
	l:SetHeight(HAUT_LIGNE)
	l:SetPoint("TOPLEFT", f.liste.contenu, "TOPLEFT", 0, -(i - 1) * HAUT_LIGNE)
	l:SetPoint("RIGHT", f.liste.contenu, "RIGHT", 0, 0)
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

--------------------------------------------------------------------------------
-- Mise à jour de l'onglet
--------------------------------------------------------------------------------

local function TexteEtat(mienne, tour)
	local moi = MaCle()
	local b = bizkit
	-- (pendant un Bizkit, rien tant que je n'ai pas crié : c'est à moi de voir le 7)
	if b and b.rang[moi] then
		local reste = math.max(0, math.ceil(DELAI_COURSE - (GetTime() - b.debut)))
		return ("Tu as crié en position %d. On attend les autres… %d s"):format(b.rang[moi], reste)
	end
	local a = attaque
	if a then
		local reste = math.max(0, math.ceil(DELAI_ATTAQUE - (GetTime() - a.debut)))
		if a.qui == moi then
			if a.envoye then return "Tes attaques partent…" end
			if ChoixEnAttente() then
				return ("|cffffd100Double 6 !|r 6 attaques, ou relance : la somme des dés · %d s"):format(reste)
			end
			if not AttaquesConnues() then return "Les dés roulent…" end
			if APlacer() == 0 then
				return ("Personne d'autre pour les recevoir : tes |cffffd100%d attaques|r sont pour toi · %d s"):format(AttaquesConnues(), reste)
			end
			local pourMoi = Surplus() > 0 and (" (dont %d pour toi)"):format(Surplus()) or ""
			return ("|cffffd100%d attaques|r%s : clique sur les joueurs (clic droit : en retirer) · %d s"):format(AttaquesConnues(), pourMoi, reste)
		end
		if a.choix6 and not a.relance then return ("%s choisit : 6 attaques ou relance…"):format(NomJoueur(a.qui)) end
		return ("%s distribue %d attaques…"):format(NomJoueur(a.qui), a.n)
	end
	if attente then return "Les dés roulent…" end
	if not mienne then
		return Assis() >= PLACES and "La table est pleine." or "Clique sur une place libre pour t'asseoir."
	end
	if tour == mienne then return "|cffffd100À toi de lancer !|r" end
	if tour and places[tour] then
		local tarde = Tarde()
		if tarde and Suivante(tour) == mienne then
			return ("%s tarde : tu peux lancer à sa place."):format(NomJoueur(places[tour]))
		end
		return ("Au tour de %s."):format(NomJoueur(places[tour]))
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

	-- les places
	local distribue = JeDistribue()
	for i, b in ipairs(t.places) do
		local cle = places[i]
		-- halo doré : son tour ; rouge : un joueur que je peux attaquer
		local cible = distribue and cle ~= nil and cle ~= moi
		b.halo:SetShown(cible or (cle ~= nil and i == tour and not bizkit and not attaque))
		if cible then
			b.halo:SetVertexColor(1, 0.3, 0.25, 1)
		else
			b.halo:SetVertexColor(C.ors[1], C.ors[2], C.ors[3], 1)
		end
		local k = cle and attaque and attaque.qui == moi and attaque.repartition[cle]
		if cle == moi and distribue and Surplus() > 0 then k = Surplus() end -- (celles que je me mets)
		b.attaque:SetText(k and ("-" .. k) or "")
		if cle then
			local r, g, bl = ns.CouleurClasse(ns.ClasseMembre and ns.ClasseMembre(cle))
			b.bord:SetVertexColor(r, g, bl, 1)
			b.creux:Hide()
			b.plus:Hide()
			b.portrait:Poser(cle)
			b.portrait:Show()
			b.nom:SetText(NomJoueur(cle))
			b.nom:SetTextColor(unpack(cle == moi and C.ors or C.texte))
			local p = Points(cle)
			b.points:SetText(p)
			b.points:SetTextColor(unpack(p <= 5 and C.aide or C.ors))
			b.jeton:Show()
			b.prison:SetShown(cle == prison)
			b.prison5:SetShown(cle == prison5)
			b.prison.texte:SetText(cran > 1 and ("×" .. cran) or "3")
			local rang = bizkit and bizkit.rang[cle]
			b.rang:SetText(rang and tostring(rang) or "")
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
		end
	end

	-- les dés du dernier lancer (sans animation en cours)
	if dernierLancer and not t.roule and not t.des[1]:IsShown() then AnimerDes(t, dernierLancer, true) end

	-- le vecteur du dernier lancer, une fois les dés posés : un point tous les 9 pixels
	local tr = dernierLancer and dernierLancer.trace
	if tr and not t.roule then
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

	-- dernière nouvelle, état, bouton
	t.resultat:SetText(t.roule and "" or annonce)
	t.etat:SetText(TexteEtat(mienne, tour))
	local a = attaque
	if a and a.qui == moi and not a.envoye then
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
		t.secondaire:Hide()
		t.lancer:Activer(PeutLancer())
		t.lancer:Ecrire(attente and "Les dés roulent…" or "Lancer les dés")
	end
	t.compte:SetText(("%d / %d"):format(Assis(), PLACES))

	-- à droite : la prison de 3, les derniers lancers et Bizkit
	if prison then
		cote.prison:SetText(("%s%s : |cffffd100%s|r%s"):format(PRISONS[cran], cran > 1 and (" (×" .. cran .. ")") or "",
			NomJoueur(prison), PlaceDe(prison) and "" or " (absent)"))
	else
		cote.prison:SetText("Prison de 3 : |cff9b9380personne|r")
	end
	if prison5 then
		cote.prison5:SetText(("Prison de 5 : |cffffd100%s|r%s"):format(NomJoueur(prison5), PlaceDe(prison5) and "" or " (absent)"))
	else
		cote.prison5:SetText("Prison de 5 : |cff9b9380personne|r")
	end
	cote.vide:SetShown(#historique == 0)
	for i, h in ipairs(historique) do
		local ligne = LigneHistorique(cote, i)
		if h.genre == "bizkit" then
			local noms = {}
			for _, cle in ipairs(h.perdants) do noms[#noms + 1] = NomJoueur(cle) end
			ligne.nom:SetText("|cffffd100Bizkit !|r " .. (#noms > 0 and table.concat(noms, ", ") or "annulé"))
			ligne.nom:SetTextColor(unpack(C.texte))
			ligne.de1:Hide()
			ligne.de2:Hide()
			ligne.total:SetText(#noms > 0 and "-1" or "")
			ligne.total:SetTextColor(unpack(C.aide))
		elseif h.genre == "peine" or h.genre == "prison" or h.genre == "prison5" then
			if h.genre == "peine" then
				ligne.nom:SetText("|cffff7766" .. (h.lieu or PRISONS[h.cran or 1]) .. "|r " .. NomJoueur(h.qui))
				ligne.total:SetText("-" .. h.n)
			elseif h.genre == "prison5" then
				ligne.nom:SetText("|cff8cbfff" .. (h.sort and "Sort de la prison de 5" or "Prison de 5") .. "|r " .. NomJoueur(h.qui))
				ligne.total:SetText("")
			else
				local lieu = (h.cran or 1) > 1 and PRISONS[h.cran] or "En prison"
				ligne.nom:SetText("|cffff7766" .. lieu .. "|r " .. NomJoueur(h.qui) .. (h.avant and (" · " .. NomJoueur(h.avant) .. " sort") or ""))
				ligne.total:SetText("")
			end
			ligne.nom:SetTextColor(unpack(C.texte))
			ligne.total:SetTextColor(unpack(C.aide))
			ligne.de1:Hide()
			ligne.de2:Hide()
		elseif h.genre == "attaque" then
			local noms, total = {}, 0
			for _, c in ipairs(h.cibles) do
				noms[#noms + 1] = ("%s -%d"):format(NomJoueur(c.cle), c.n)
				total = total + c.n
			end
			ligne.nom:SetText("|cffff9966Attaque|r " .. (#noms > 0 and table.concat(noms, ", ") or "personne"))
			ligne.nom:SetTextColor(unpack(C.texte))
			ligne.total:SetText(total > 0 and ("-" .. total) or "")
			ligne.total:SetTextColor(unpack(C.aide))
			ligne.de1:Hide()
			ligne.de2:Hide()
		else
			-- un lancer, ou la relance d'un double 6
			ligne.nom:SetText((h.genre == "relance" and "|cffff9966Relance|r " or "") .. NomJoueur(h.qui))
			ligne.nom:SetTextColor(unpack(h.qui == moi and C.ors or C.texte))
			ligne.de1:SetTexture(FACE .. h.d1)
			ligne.de2:SetTexture(FACE .. h.d2)
			ligne.de1:Show()
			ligne.de2:Show()
			ligne.total:SetText(tostring(h.d1 + h.d2))
			local somme = h.d1 + h.d2
			ligne.total:SetTextColor(unpack(somme == 7 and C.ors or somme == 3 and C.aide or C.texte))
		end
		ligne:Show()
	end
	for i = #historique + 1, #cote.lignes do cote.lignes[i]:Hide() end
	cote.liste:Hauteur(math.max(1, #historique * HAUT_LIGNE))
	cote.lever:Activer(mienne ~= nil)
	cote.nouvelle:Activer(mienne ~= nil)
	cote.nouvelle:Ecrire(GetTime() - confirmeNouvelle <= 3 and "Confirmer ?" or "Nouvelle partie")
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
ev:SetScript("OnEvent", function(_, event, texte)
	if event == "CHAT_MSG_SYSTEM" then
		LireJet(texte)
	elseif event == "PLAYER_ENTERING_WORLD" then
		ev:UnregisterEvent("PLAYER_ENTERING_WORLD")
		-- après un /reload ou une courte déconnexion, je reprends ma place et mes points
		C_Timer.After(8, function()
			local p = DB().bizkit
			if type(p) == "table" and tonumber(p.place) and ns.Maintenant() - (tonumber(p.quand) or 0) < REPRISE then
				local moi = MaCle()
				if moi and tonumber(p.points) then points[moi] = tonumber(p.points) end
				Envoyer(("A~%d~~%d"):format(p.place, Points(moi)))
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
			annonce = "Bizkit abandonné : le lanceur ne répond plus"
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
			annonce = "Attaques abandonnées : le lanceur ne répond plus"
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
	if change then NoterTour(); Maj() end
	local mienne = PlaceDe(moi)
	if mienne then NoterMaPlace(mienne) end
end)

ns.Ecouter(PREFIXE, Recevoir)
