-- GuildUpSMB : WoWdex, le bestiaire à compléter, seul et en guilde (page « WoWdex », /smb wowdex ; préfixe
-- "GuildUpDex").
-- Le bestiaire (ns.BESTIAIRE, GuildUp_Bestiaire.lua, généré depuis QuestieDB) numérote les monstres de Forever
-- du plus faible au plus fort. Chaque monstre a trois paliers, comme dans un carnet de collection :
--   vu        barre de nom, cible ou survol d'un monstre qu'on peut attaquer : son nom et son modèle s'affichent
--   vaincu    (« capturé ») tué par moi ou mon groupe : cible ou survol d'un corps qui n'est pas « pris par un
--             autre », ou dépouillé. (Pas de journal de combat : le client interdit aux addons d'écouter
--             COMBAT_LOG_EVENT_UNFILTERED ; le demander, même sous pcall, affiche une erreur d'addon.)
--   dépouillé fouillé : ce qu'il a lâché est compté, pour donner les taux de butin. Pas le butin d'une récolte
--             (dépeçage, vol à la tire, minage, herboristerie : sort lancé moins de 2 s avant l'ouverture du
--             butin, reconnu à son numéro ou à son nom), ni celui d'un monstre ciblé encore vivant. Le butin est
--             lu dès LOOT_READY : avec le ramassage automatique, la fenêtre est vide (ou ne s'ouvre pas) à
--             LOOT_OPENED, où il ne restait que les objets soumis à un jet de dés.
-- En instance, Forever cache aux addons le GUID et le nom des monstres (valeurs secrètes) : barres de nom, cible et
-- survol ne disent plus qui ils sont. Un monstre y est capturé par son nom, cherché dans le bestiaire : celui de
-- la ligne d'expérience (« X meurt, vous gagnez… » : une par monstre, aucune pour un monstre gris) ou de la fin
-- d'un combat de boss (ENCOUNTER_END, BOSS_KILL) ; ou par son corps fouillé, quand le butin donne son GUID.
-- GuildUpDB.wowdex.diag : petit relevé de ce que le jeu a caché et de ce que chaque voie a donné, avec la
-- dernière erreur avalée par pcall (/smb diag) : la seule trace, après coup, d'un souci en jeu.
-- Les rares sont le cœur du WoWdex (7.3.0) : rares, rares élites et boss (RARES) font le compteur de l'entête, le
-- titre de chasseur (TITRES : seuils en rares et boss capturés), le classement de la guilde et l'onglet « Avis de
-- recherche ». Un rare du monde (TRAQUES : rare, rare élite) vu vivant déclenche une alerte si je ne l'ai pas
-- capturé, et son repérage part à la guilde.
-- Un monstre absent du bestiaire mais rencontré en jeu est gardé aussi (nom, niveau, rang, type, zone appris sur
-- l'unité), sans numéro : le WoWdex vit de ce que croisent les joueurs.
-- Mon WoWdex est commun aux personnages du compte : GuildUpDB.wowdex.m[pnj] = { v = vu le, k = vaincus,
-- d = dépouilles, tk = premier vaincu le, tb = dernière dépouille le, b = { [objet] = corps qui l'ont lâché },
-- ty = type, et pour un monstre hors bestiaire : n = nom, l = niveau, r = rang, c = carte, z = zone } ;
-- GuildUpDB.wowdex.pistes[pnj] = date : les monstres que je piste (10 au plus ; alerte quand ils sont en vue,
-- losange sur leur barre de nom ; retirés à la capture) ; alertes = false, plaques = false : réglages coupés.
-- La guilde (GuildUpDB.wowdexGuilde[guilde]) : d[pnj] = { c = premier membre à l'avoir vaincu, j = jour },
-- s[clé] = { v, k, d, t, r } (score de chaque membre ; r = rares et boss capturés, absent pour une version d'avant
-- la 7.3.0), butin[pnj][clé] = { k = corps fouillés, o = { [objet] = n }, t = date } (le relevé de chaque autre
-- membre ; le mien est lu dans mon WoWdex ; ceux d'un membre dont rien n'est arrivé depuis un an, ni relevé ni
-- score, sont oubliés à la connexion), curseurButin (rattrapage), r[pnj] = { c = membre, t = date, carte, x,
-- y } (dernier repérage d'un rare du monde), morts[pnj] = { c = membre, t = date } (dernière fois qu'un membre a
-- vaincu ce rare : un repérage plus ancien que cette mort n'est plus montré).
-- Taux de drop de la guilde = somme des relevés de chaque membre. Chaque relevé appartient à son membre et ses
-- comptes ne font que monter : on garde le plus grand reçu, donc rien n'est compté deux fois (ni un message reçu
-- deux fois, ni un relevé reçu en direct puis par le relais).
-- Un monstre est « connu » (nom et modèle affichés, sinon « ??? ») si je l'ai vu, si la guilde l'a vaincu ou si un
-- membre l'a repéré. Son butin, lui, est toujours affiché.
-- Page : entête (rares et boss capturés, titre), puis cinq onglets : « Avis de recherche » (les rares et boss, en
-- grandes cartes), « Bestiaire » (tous les monstres, en cases), « Zones » (un WoWdex par zone, ses rares d'abord),
-- « Carnet de chasse » (titres, progression par rang et par niveau, monstres pistés, dernières captures,
-- réglages), « Guilde » (classement par rares, premières captures de rares). Les deux premiers partagent la
-- grille et la fiche (modèle 3D, paliers, guilde, repérage, dernière mort, butin, « Pister », « Sur la carte »,
-- « Lier »). Un rare repéré depuis moins d'une heure, avec sa position, a un bouton « Y aller » : le repère du
-- jeu est posé à cet endroit et la carte s'ouvre (ns.MontrerAppelSurCarte de GuildUp_Aide.lua). Les distances
-- (apparition la plus proche, repérage, monstres pistés) viennent de ns.PositionMonde (GuildUp_Reperes.lua).
-- Recherche : nom du monstre, zone, ou nom d'un objet (les monstres qui le lâchent : ceux où la guilde l'a trouvé
-- d'abord, puis ceux du bestiaire). ns.SourcesWowdex(objet) : les monstres où la guilde l'a trouvé, avec le taux
-- (Encyclopédie de GuildUp_Carnet.lua).
-- Messages (pnj et objets en base 36, jour = jours depuis le 1er janvier 2024, t = heure du serveur) :
--   "N~pnj,pnj,…"                     mes nouvelles captures (regroupées, toutes les 15 s au plus)
--   "B~pnj:corps:t.objet.n.objet.n;…" mes relevés de butin (totaux) des monstres fouillés depuis le dernier envoi
--                                     (toutes les 60 s au plus) ; un monstre au butin très varié tient en
--                                     plusieurs mots. (« L », les écarts de la 7.0.0, est ignoré.)
--   "S~vus~vaincus~dépouillés"        mon score (à la connexion, puis 2 min après un changement)
--   "C~rares"                         mes rares et boss capturés, envoyé avec « S » (7.3.0 ; un message à part : les
--                                     versions d'avant ne liraient pas un « S » plus long)
--   "V~pnj~carte~x~y"                 je vois un rare du monde vivant (7.3.0) : une fois toutes les 10 min par rare
--                                     pour toute la guilde ; carte et position (dix-millièmes) vides si je ne
--                                     partage pas ma position. Pas de rattrapage : c'est une nouvelle du moment.
--   "K~pnj"                           je viens de vaincre un rare du monde (7.5.0), à chaque fois : la guilde sait
--                                     depuis quand il est mort. Pas de rattrapage non plus.
--   "Q~jour"                          je me connecte : envoyez-moi les découvertes depuis ce jour
--   "E~clé~pnj.jour,pnj.jour,…"       découvertes de la guilde, par le seul relais (ns.EstLeRelais), les plus
--                                     anciennes d'abord, 400 au plus par demande (la suite à la connexion suivante)
--   "T~clé,vus,vaincus,dépouillés,t;…" scores des membres, par le même relais
--   "U~clé,rares;…"                   rares et boss capturés des membres, par le même relais, après « T » (7.3.0)
--   "P~t"                             je me connecte : envoyez-moi les relevés de butin changés depuis t
--   "R~clé~pnj:corps:t.objet.n…;…"    relevés de ce membre, par le seul relais, les plus anciens d'abord, 300 au
--                                     plus par demande ; tout le monde les lit
--   "F~demandeur~t"                   fin du rattrapage : le demandeur reprendra à t la prochaine fois
-- Les versions d'avant la 7.3.0 ignorent « C », « U » et « V », celles d'avant la 7.5.0 ignorent « K » : rien ne
-- change pour elles.
-- Une découverte : le jour le plus ancien gagne (à égalité, la plus petite clé). La capture d'un rare, d'un rare
-- élite ou d'un boss entre dans le fil d'activité (GuildUp_Journal.lua) : genre « W » pour la première de la
-- guilde, « R » pour les suivantes.
-- Bulles (catégorie « wowdex ») : rare en vue (moi : son d'alerte ; un membre : bulle simple), monstre pisté en
-- vue, capture d'un rare ou d'un boss (avec le nouveau titre et la zone terminée s'il y a lieu), zone complète,
-- tous les 25 monstres capturés ; une ligne dans la discussion pour chaque nouvelle capture. Ligne « WoWdex » dans
-- l'infobulle des monstres. Losange sur la barre de nom des rares à capturer et des monstres pistés.
local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpDex"
local EPOQUE = 1704067200        -- 1er janvier 2024 : jour 0
local MAX_RELAIS = 400
local MAX_RELAIS_BUTIN = 300
local MAX_HORS = 1000             -- monstres hors bestiaire gardés au plus
local PALIER_BULLE = 25
local OCTETS = 240
local DELAI_ALERTE = 300          -- secondes entre deux alertes « en vue » pour le même monstre
local DELAI_REPERAGE = 600        -- secondes entre deux repérages du même rare annoncés à la guilde
local MAX_PISTES = 10             -- monstres pistés au plus
local OUBLI_BUTIN = 365 * 86400   -- relevés de butin d'un membre dont on n'a rien reçu depuis un an : oubliés

local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local Maintenant = ns.Maintenant
local Base36 = ns.Base36
local Simplifier = ns.Simplifier
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local Secrete = ns.Secrete

local ANGLAIS = GetLocale() == "enUS" or GetLocale() == "enGB"
local NOMS_RANGS = { [0] = "Normal", "Élite", "Rare élite", "Boss", "Rare" }
local COULEURS_RANGS = { [0] = { 0.91, 0.886, 0.83 }, { 1, 0.82, 0 }, { 0.75, 0.75, 1 }, { 1, 0.35, 0.3 }, { 0.75, 0.75, 1 } }
local RARES = { [2] = true, [3] = true, [4] = true } -- rare élite, boss, rare : le cœur du WoWdex
local TRAQUES = { [2] = true, [4] = true }           -- rares du monde : alerte « en vue », repérage partagé
-- Titres de chasseur : seuil en rares et boss capturés (le dernier : tous ceux du bestiaire)
local TITRES = { { 0, "Novice" }, { 5, "Pisteur" }, { 15, "Traqueur" }, { 40, "Chasseur" }, { 80, "Grand veneur" },
	{ 150, "Maître de chasse" }, { 250, "Maître du bestiaire" }, { false, "Légende de Forever" } }
local CLASSEMENTS = { elite = 1, rareelite = 2, worldboss = 3, rare = 4 }

local function Jour(t) return math.floor(((t or Maintenant()) - EPOQUE) / 86400) end
local function DateJour(j) return date("%d/%m/%Y", EPOQUE + j * 86400 + 43200) end
local function Message(t) if ns.Coeur and ns.Coeur.Message then ns.Coeur.Message(t) else print(t) end end

--------------------------------------------------------------------------------
-- Bestiaire (lu une fois, à la première utilisation)
--------------------------------------------------------------------------------

local bestiaire -- { liste = { fiche… } dans l'ordre des numéros, par = { [pnj] = fiche }, zones, nombre,
                -- rares = nombre de rares, rares élites et boss, parRang = { [rang] = nombre } }

local function Bestiaire()
	if bestiaire then return bestiaire end
	local b = { liste = {}, par = {}, zones = {}, rares = 0, parRang = { [0] = 0, 0, 0, 0, 0 } }
	for z, nom, carte in (ns.BESTIAIRE_ZONES or ""):gmatch("(%d+)|([^|\n]*)|(%d*)") do
		b.zones[tonumber(z)] = { nom = nom, carte = tonumber(carte) }
	end
	for ligne in (ns.BESTIAIRE or ""):gmatch("[^\n]+") do
		local id, fr, en, mi, ma, rang, zones, butin = ligne:match("^(%d+)|([^|]*)|([^|]*)|(%d+)|(%d+)|(%d+)|([^|]*)|(.*)$")
		if id then
			local f = { id = tonumber(id), nom = (ANGLAIS and en ~= "" and en) or fr, min = tonumber(mi),
				max = tonumber(ma), rang = tonumber(rang) or 0, zonesTexte = zones, butinTexte = butin }
			f.zone = tonumber(zones:match("^(%d+)"))
			f.num = #b.liste + 1
			b.liste[f.num] = f
			b.par[f.id] = f
			b.parRang[f.rang] = (b.parRang[f.rang] or 0) + 1
			if RARES[f.rang] then b.rares = b.rares + 1 end
		end
	end
	b.nombre = #b.liste
	ns.BESTIAIRE, ns.BESTIAIRE_ZONES = nil, nil -- (le texte n'est plus utile)
	bestiaire = b
	return b
end

-- zones d'une fiche : { { zone, points = { {x, y}, … } }, … } (lu à la demande)
local function ZonesFiche(f)
	if f.zones then return f.zones end
	f.zones = {}
	for bloc in (f.zonesTexte or ""):gmatch("[^#]+") do
		local z, pts = bloc:match("^(%d+):(.*)$")
		if z then
			local points = {}
			for x, y in pts:gmatch("(%d+),(%d+)") do points[#points + 1] = { tonumber(x), tonumber(y) } end
			f.zones[#f.zones + 1] = { zone = tonumber(z), points = points }
		end
	end
	return f.zones
end

local function ButinFiche(f)
	if f.butin then return f.butin end
	f.butin = {}
	for o in (f.butinTexte or ""):gmatch("%d+") do f.butin[#f.butin + 1] = tonumber(o) end
	return f.butin
end

-- ensemble des zones d'une fiche : { [zone] = true }
local function ZonesDe(f)
	if not f.ensembleZones then
		f.ensembleZones = {}
		for z in (f.zonesTexte or ""):gmatch("(%d+):") do f.ensembleZones[tonumber(z)] = true end
	end
	return f.ensembleZones
end

local function NomZone(z)
	local b = Bestiaire()
	return z and b.zones[z] and b.zones[z].nom or nil
end

--------------------------------------------------------------------------------
-- Données : mon WoWdex, celui de la guilde
--------------------------------------------------------------------------------

local function Moi()
	local db = ns.DB and ns.DB()
	if not db then return nil end
	if type(db.wowdex) ~= "table" then db.wowdex = {} end
	if type(db.wowdex.m) ~= "table" then db.wowdex.m = {} end
	if type(db.wowdex.pistes) ~= "table" then db.wowdex.pistes = {} end
	return db.wowdex
end

local function Entree(id, creer)
	local w = Moi()
	if not w then return nil end
	local e = w.m[id]
	if not e and creer then
		e = { k = 0, d = 0 }
		w.m[id] = e
	end
	return e
end

-- En instance, le jeu cache l'identité des monstres : voir l'en-tête. sansGuid[pnj] = { t = GetTime(), n = morts
-- comptées par le nom et pas encore revues par un GUID, boss }, parGuid[pnj] = GetTime() de la dernière mort
-- comptée par un GUID : une même mort n'est pas comptée par les deux voies.
local Instance = { sansGuid = {}, parGuid = {} }

-- relevé : compteur, et le dernier texte qui va avec (nom inconnu, erreur)
function Instance.Noter(cle, texte)
	local w = Moi()
	if not w then return end
	if type(w.diag) ~= "table" then w.diag = { depuis = Maintenant() } end
	w.diag[cle] = (tonumber(w.diag[cle]) or 0) + 1
	if texte ~= nil then
		texte = tostring(texte)
		w.diag[cle .. "Texte"] = ns.CouperUTF8 and ns.CouperUTF8(texte, 200) or texte:sub(1, 200)
	end
end

-- appel protégé, comme pcall, mais l'erreur est gardée dans le relevé
function Instance.Essayer(f, ...)
	local ok, err = pcall(f, ...)
	if not ok then Instance.Noter("erreurs", err) end
	return ok, err
end

function Instance.Dedans()
	if not IsInInstance then return false end
	local ok, dedans = pcall(IsInInstance)
	return ok and not Secrete(dedans) and dedans and true or false
end

-- la fiche du bestiaire qui porte ce nom : de préférence un monstre de l'instance où je suis (zone du même nom),
-- sinon un monstre d'instance (zone sans position), sinon le premier de ce nom
function Instance.Chercher(nom)
	if not Instance.parNom then
		Instance.parNom = {}
		for _, f in ipairs(Bestiaire().liste) do
			local c = Simplifier(f.nom)
			local l = Instance.parNom[c]
			if not l then l = {}; Instance.parNom[c] = l end
			l[#l + 1] = f
		end
	end
	local ici = GetRealZoneText and GetRealZoneText()
	ici = type(ici) == "string" and not Secrete(ici) and Simplifier(ici) or nil
	local trouve, note = nil, 0
	for _, f in ipairs(Instance.parNom[Simplifier(nom)] or {}) do
		local n = 1
		if ("#" .. (f.zonesTexte or "") .. "#"):find(":#", 1, true) then n = 2 end
		if ici then
			for z in pairs(ZonesDe(f)) do
				local nz = NomZone(z)
				if nz and Simplifier(nz) == ici then n = 3 end
			end
		end
		if n > note then trouve, note = f, n end
	end
	return trouve
end

-- Un monstre vaincu en instance, connu par son nom seul (boss : fin d'un combat de boss, sinon ligne
-- d'expérience). Un boss donne sa fin de combat, par un ou deux évènements, et sa ligne d'expérience : une mort.
function Instance.Vaincu(nom, boss)
	if not Instance.Dedans() then return end
	if type(nom) ~= "string" or Secrete(nom) or nom == "" then
		Instance.Noter("nomsCaches")
		return
	end
	local f = Instance.Chercher(nom)
	if not f then
		Instance.Noter(boss and "bossInconnus" or "nomsInconnus", nom)
		return
	end
	local t = GetTime()
	local g = Instance.parGuid[f.id]
	if g and t - g < 5 then -- (son corps vient d'être compté par son GUID)
		Instance.parGuid[f.id] = nil
		return
	end
	local c = Instance.sansGuid[f.id]
	if c and t - c.t < 10 and (boss or c.boss) then
		c.boss = true
		return
	end
	Instance.sansGuid[f.id] = { t = t, n = (c and t - c.t < 900 and c.n or 0) + 1, boss = boss or false }
	Instance.Noter(boss and "boss" or "nomsLus")
	Instance.Vaincre(f.id)
end

-- « X meurt, vous gagnez N points d'expérience » : le nom du monstre. Le motif vient du texte du jeu, dans sa
-- langue, coupé au nombre (la suite change avec les bonus de repos ou de groupe).
function Instance.Experience(texte)
	if type(texte) ~= "string" then return end
	if Secrete(texte) then
		Instance.Noter("xpCachees")
		return
	end
	if not Instance.motif then
		local f = type(COMBATLOG_XPGAIN_FIRSTPERSON) == "string" and COMBATLOG_XPGAIN_FIRSTPERSON
			or "%s dies, you gain %d experience."
		f = f:gsub("%%%d+%$", "%%") -- (« %1$s » : « %s »)
		f = f:match("^(.-%%d)") or f
		f = f:gsub("[%^%$%(%)%.%[%]%*%+%-%?]", "%%%0")
		f = f:gsub("%%s", "(.+)")
		f = f:gsub("%%d", "%%d+")
		Instance.motif = "^" .. f
	end
	local nom = texte:match(Instance.motif)
	if type(nom) == "string" then Instance.Vaincu(nom, false) end
end

local function Palier(e)
	if not e then return 0 end
	if (e.d or 0) > 0 then return 3 end
	if (e.k or 0) > 0 then return 2 end
	return e.v and 1 or 0
end

local function Guilde()
	local db = ns.DB and ns.DB()
	local nom = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not db or not nom then return nil end
	if type(db.wowdexGuilde) ~= "table" then db.wowdexGuilde = {} end
	local g = db.wowdexGuilde[nom]
	if type(g) ~= "table" then g = {}; db.wowdexGuilde[nom] = g end
	for _, k in ipairs({ "d", "s", "butin", "r", "morts" }) do
		if type(g[k]) ~= "table" then g[k] = {} end
	end
	g.b = nil -- (7.0.0 : totaux de tous mélangés, impossibles à répartir par membre)
	return g
end

-- mes compteurs : vus, vaincus (capturés), dépouillés, hors bestiaire, et r = rares, rares élites et boss
-- du bestiaire capturés
local scoreCache
local function MonScore()
	if scoreCache then return scoreCache end
	local w = Moi()
	local s = { v = 0, k = 0, d = 0, hors = 0, r = 0 }
	if w then
		local par = Bestiaire().par
		for id, e in pairs(w.m) do
			local p = Palier(e)
			if p >= 1 then s.v = s.v + 1 end
			if p >= 2 then s.k = s.k + 1 end
			if p >= 3 then s.d = s.d + 1 end
			local f = par[id]
			if not f then s.hors = s.hors + 1
			elseif p >= 2 and RARES[f.rang] then s.r = s.r + 1 end
		end
	end
	scoreCache = s
	return s
end

-- Titre de chasseur pour r rares et boss capturés : rang (1 à 8), nom, seuil du titre suivant (nil au dernier)
local function SeuilTitre(i)
	local t = TITRES[i]
	if not t then return nil end
	return t[1] or Bestiaire().rares
end
local function Titre(r)
	r = r or 0
	local rang = 1
	for i = 2, #TITRES do
		local seuil = SeuilTitre(i)
		if seuil > 0 and r >= seuil then rang = i end
	end
	return rang, TITRES[rang][2], SeuilTitre(rang + 1)
end

-- Par zone : n monstres, k capturés par moi, g par la guilde (ou moi) ; rares, raresK, raresG : pareil pour les
-- rares, rares élites et boss. Recalculé après chaque changement.
local statsZones
local function StatsZones()
	if statsZones then return statsZones end
	local w, g = Moi(), Guilde()
	local st = {}
	for _, f in ipairs(Bestiaire().liste) do
		local pris = w and Palier(w.m[f.id]) >= 2 or false
		local guilde = pris or (g and g.d[f.id] ~= nil) or false
		local rare = RARES[f.rang]
		for z in pairs(ZonesDe(f)) do
			local s = st[z]
			if not s then s = { n = 0, k = 0, g = 0, rares = 0, raresK = 0, raresG = 0 }; st[z] = s end
			s.n = s.n + 1
			if pris then s.k = s.k + 1 end
			if guilde then s.g = s.g + 1 end
			if rare then
				s.rares = s.rares + 1
				if pris then s.raresK = s.raresK + 1 end
				if guilde then s.raresG = s.raresG + 1 end
			end
		end
	end
	statsZones = st
	return st
end

-- un membre de la guilde a vaincu ce monstre (le jour le plus ancien gagne) ; true si la guilde ne l'avait pas
local function Decouverte(id, cle, j)
	local g = Guilde()
	if not g or not id or not cle or not j then return false end
	local d = g.d[id]
	if not d then
		g.d[id] = { c = cle, j = j }
		return true
	end
	if j < d.j or (j == d.j and cle < d.c) then d.c, d.j = cle, j end
	return false
end

local function Connu(id)
	local e = Entree(id)
	if e and e.v then return true end
	local g = Guilde()
	return g and (g.d[id] ~= nil or g.r[id] ~= nil) or false
end

--------------------------------------------------------------------------------
-- Rafraîchissement de la page
--------------------------------------------------------------------------------

local page
local majPrevue = false
local function MajBientot()
	scoreCache = nil
	statsZones = nil
	if majPrevue then return end
	majPrevue = true
	C_Timer.After(0.5, function()
		majPrevue = false
		if page and page:IsVisible() and page.Maj then page.Maj() end
	end)
end

--------------------------------------------------------------------------------
-- Réseau : envois regroupés
--------------------------------------------------------------------------------

local function Envoyer(msg, jetable)
	if ns.EnvoyerAddon and IsInGuild() then
		ns.EnvoyerAddon(PREFIXE, msg, "GUILD", nil, jetable and { jetable = true } or nil)
	end
end

-- liste de mots → messages de OCTETS au plus : "tete" .. mot .. sep .. mot …
local function EnvoyerMots(tete, mots, sep)
	local msg = tete
	for _, mot in ipairs(mots) do
		if #msg + #mot + 1 > OCTETS and #msg > #tete then Envoyer(msg); msg = tete end
		msg = msg .. (#msg > #tete and sep or "") .. mot
	end
	if #msg > #tete then Envoyer(msg) end
end

local captures = {}        -- nouvelles captures à annoncer
local butinChange = {}     -- [pnj] = true : mes relevés de butin à annoncer
local captureLancee, butinLance, scoreLance = false, false, false

local function EnvoyerScore()
	scoreLance = false
	local s = MonScore()
	Envoyer(("S~%d~%d~%d"):format(s.v, s.k, s.d), true)
	Envoyer("C~" .. s.r) -- (pas jetable : il remplacerait « S » dans la file)
end

local function ScorePlusTard()
	if scoreLance then return end
	scoreLance = true
	C_Timer.After(120, EnvoyerScore)
end

local function AnnoncerCapture(id)
	captures[#captures + 1] = Base36(id)
	if captureLancee then return end
	captureLancee = true
	C_Timer.After(15, function()
		captureLancee = false
		local mots = captures
		captures = {}
		EnvoyerMots("N~", mots, ",")
	end)
	ScorePlusTard()
end

-- un relevé de butin en mots de message : "pnj:corps:t.objet.n.objet.n" ; un monstre au butin très varié prend
-- plusieurs mots, chacun avec ses corps et sa date (la fusion garde le plus grand de chaque compte)
local function MotsButin(id, r, mots)
	local tete = ("%s:%d:%s"):format(Base36(id), r.k or 0, Base36(r.t or 0))
	local mot = tete
	for o, n in pairs(r.o or {}) do
		local bout = "." .. Base36(o) .. "." .. n
		if #mot + #bout > OCTETS - 40 then mots[#mots + 1] = mot; mot = tete end
		mot = mot .. bout
	end
	mots[#mots + 1] = mot
end

-- mon relevé de butin d'un monstre (mes corps fouillés, sur tous mes personnages), ou nil
local function MonReleve(id)
	local e = Entree(id)
	if not e or (e.d or 0) <= 0 then return nil end
	return { k = e.d, o = type(e.b) == "table" and e.b or {}, t = e.tb or e.tk or e.v or 1 }
end

local function AnnoncerButin(id)
	butinChange[id] = true
	if butinLance then return end
	butinLance = true
	C_Timer.After(60, function()
		butinLance = false
		local mots = {}
		for pnj in pairs(butinChange) do
			local r = MonReleve(pnj)
			if r then MotsButin(pnj, r, mots) end
		end
		butinChange = {}
		EnvoyerMots("B~", mots, ";")
	end)
end

-- le relevé d'un autre membre : ses comptes ne font que monter, on garde le plus grand de chacun
local function RecevoirReleve(cle, id, k, objets, t)
	local g = Guilde()
	if not g or not cle or cle == MaCle() or not id or not k or k <= 0 then return end
	local parPnj = g.butin[id]
	if not parPnj then parPnj = {}; g.butin[id] = parPnj end
	local r = parPnj[cle]
	if not r then r = { k = 0, o = {}, t = 0 }; parPnj[cle] = r end
	if k > r.k then r.k = k end
	for o, n in pairs(objets) do
		if n > (r.o[o] or 0) then r.o[o] = n end
	end
	if t and t > (r.t or 0) then r.t = t end
end

-- Oubli des relevés d'un membre disparu : rien reçu de lui depuis OUBLI_BUTIN (ni relevé, ni score). Ses comptes
-- restent justes, mais ils grossiraient la sauvegarde pour toujours (monstres x membres passés par la guilde).
-- Un membre actif ne perd rien : son score part à chaque connexion. Le relais ne les renvoie pas (date trop
-- ancienne pour le curseur) ; s'il revient, ses nouveaux relevés repartent normalement.
local function OublierButin()
	local g = Guilde()
	if not g then return 0 end
	local dernier = {}
	for _, parPnj in pairs(g.butin) do
		for cle, r in pairs(parPnj) do
			if (r.t or 0) > (dernier[cle] or 0) then dernier[cle] = r.t or 0 end
		end
	end
	for cle, s in pairs(g.s) do
		if dernier[cle] and (s.t or 0) > dernier[cle] then dernier[cle] = s.t end
	end
	local limite, oublies = Maintenant() - OUBLI_BUTIN, 0
	for cle, t in pairs(dernier) do
		if t < limite then
			oublies = oublies + 1
			for id, parPnj in pairs(g.butin) do
				parPnj[cle] = nil
				if next(parPnj) == nil then g.butin[id] = nil end
			end
		end
	end
	return oublies
end

-- taux de la guilde pour un monstre : corps fouillés, { [objet] = corps qui l'ont lâché }, membres qui l'ont
-- fouillé (moi compris ; hors guilde : moi seul)
local function TotauxButin(id)
	local k, o, membres = 0, {}, 0
	local function Ajout(r)
		if not r or (r.k or 0) <= 0 then return end
		k = k + r.k
		membres = membres + 1
		for x, n in pairs(r.o or {}) do o[x] = (o[x] or 0) + n end
	end
	Ajout(MonReleve(id))
	local g = Guilde()
	local moi = MaCle()
	for cle, r in pairs(g and g.butin[id] or {}) do
		if cle ~= moi then Ajout(r) end
	end
	return k, o, membres
end

--------------------------------------------------------------------------------
-- Détection : vu, vaincu, dépouillé
--------------------------------------------------------------------------------

local vaincus = {}     -- [GUID] = true : corps déjà comptés (session)
local fouilles = {}    -- [GUID] = { t = GetTime(), [objet] = true } : corps déjà fouillés (session)
local nVaincus, nFouilles = 0, 0

local function PnjDuGuid(guid)
	if type(guid) ~= "string" or Secrete(guid) then return nil end
	local genre, id = guid:match("^(%a+)%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")
	if genre == "Creature" then return tonumber(id) end
end

-- une unité est-elle un monstre du WoWdex ? (id, GUID)
local function Lire(unite)
	if not unite or not UnitExists(unite) or UnitIsPlayer(unite) then return nil end
	if UnitPlayerControlled and UnitPlayerControlled(unite) then return nil end -- (familiers, invocations)
	local guid = UnitGUID(unite)
	if Secrete(guid) then -- (en instance)
		Instance.Noter("guidsCaches")
		return nil
	end
	local id = PnjDuGuid(guid)
	if not id then return nil end
	if UnitIsFriend and UnitIsFriend("player", unite) then return nil end
	if UnitCanAttack and not UnitCanAttack("player", unite) and not UnitIsDead(unite) then return nil end
	return id, guid
end

local TYPES_EXCLUS = { ["Bestiole"] = true, ["Critter"] = true, ["Non spécifié"] = true, ["Not specified"] = true,
	["Totem"] = true }

-- ce que l'unité apprend : type pour tous, et tout le reste pour un monstre hors bestiaire ; nil si à ignorer
local function Apprendre(unite, id)
	local fiche = Bestiaire().par[id]
	local ty = UnitCreatureType and UnitCreatureType(unite)
	if Secrete(ty) then ty = nil end
	if not fiche then
		if ty and TYPES_EXCLUS[ty] then return nil end
		local classement = UnitClassification and UnitClassification(unite)
		if Secrete(classement) or classement == "minus" or classement == "trivial" then return nil end
		local nom = UnitName(unite)
		if type(nom) ~= "string" or Secrete(nom) or nom == "" then return nil end
	end
	local e = Entree(id)
	if not e then
		if not fiche then
			local w = Moi()
			local hors = 0
			for pid in pairs(w and w.m or {}) do if not Bestiaire().par[pid] then hors = hors + 1 end end
			if hors >= MAX_HORS then return nil end
		end
		e = Entree(id, true)
	end
	if not e then return nil end
	if ty and ty ~= "" then e.ty = ty end
	if not fiche then
		e.n = UnitName(unite)
		local niveau = UnitLevel and UnitLevel(unite)
		if type(niveau) == "number" and not Secrete(niveau) and niveau > 0 then e.l = niveau end
		local classement = UnitClassification and UnitClassification(unite)
		e.r = CLASSEMENTS[classement] or 0
		if ns.MaPosition then
			local carte = ns.MaPosition()
			if carte then e.c = carte end
		end
		local zone = GetRealZoneText and GetRealZoneText()
		if type(zone) == "string" and not Secrete(zone) and zone ~= "" then e.z = zone end
	end
	return e
end

local function NomMonstre(id)
	local f = Bestiaire().par[id]
	if f then return f.nom end
	local e = Entree(id)
	return e and e.n or ("monstre n° " .. id)
end
ns.NomWowdex = NomMonstre

-- bulle ; un clic ouvre le WoWdex, sur la fiche du monstre s'il est donné
local function Notif(categorie, titre, texte, son, id)
	if ns.Notifier then ns.Notifier(categorie, titre, texte, son, function()
		if ns.OuvrirInterface then ns.OuvrirInterface("wowdex", id) end
	end) end
end

local function AlertesActives()
	local w = Moi()
	return w and w.alertes ~= false or false
end

-- Je vois un rare du bestiaire : la guilde l'apprend (une fois toutes les 10 min par rare, pour toute la guilde),
-- avec ma position si je la partage (réglage partagePosition)
local function Signaler(id)
	local g = Guilde()
	if not g then return end
	local t = Maintenant()
	local r = g.r[id]
	if r and t - (r.t or 0) < DELAI_REPERAGE then return end
	local carte, x, y
	local db = ns.DB and ns.DB()
	if db and db.partagePosition and ns.MaPosition then carte, x, y = ns.MaPosition() end
	g.r[id] = { c = MaCle(), t = t, carte = carte, x = x, y = y }
	Envoyer(("V~%s~%s~%s~%s"):format(Base36(id), carte and tostring(carte) or "",
		x and tostring(math.floor(x * 10000 + 0.5)) or "", y and tostring(math.floor(y * 10000 + 0.5)) or ""))
	MajBientot()
end

-- Un rare du monde, ou un monstre que je piste, est vivant devant moi : alerte (au plus une toutes les 5 min par
-- monstre) si je ne l'ai pas encore capturé, et repérage pour la guilde si c'est un rare
local alertes = {} -- [pnj] = GetTime() de la dernière fois
local function EnVue(id, e)
	local f = Bestiaire().par[id]
	local rang = f and f.rang or e.r or 0
	local w = Moi()
	local piste = w and w.pistes[id]
	if not TRAQUES[rang] and not piste then return end
	local maintenant = GetTime()
	if alertes[id] and maintenant - alertes[id] < DELAI_ALERTE then return end
	alertes[id] = maintenant
	if f and TRAQUES[rang] then Signaler(id) end
	if Palier(e) >= 2 or not AlertesActives() then return end
	Notif("wowdex", TRAQUES[rang] and ("WoWdex : " .. NOMS_RANGS[rang] .. " en vue !") or "WoWdex : monstre pisté en vue !",
		(e.n or (f and f.nom) or "Un monstre") .. " est à capturer.", "RAID_WARNING", id)
end

local function Vu(unite)
	local id = Lire(unite)
	if not id then return nil end
	local e = Apprendre(unite, id)
	if e and not e.v then
		e.v = Maintenant()
		MajBientot()
	end
	if e and not UnitIsDead(unite) then EnVue(id, e) end
	return id, e
end

local MasquerMarques -- (losanges des barres de nom, plus bas)

local function Vaincre(id, guid, unite)
	if not id or (guid and vaincus[guid]) then return end
	if guid then
		vaincus[guid] = true
		nVaincus = nVaincus + 1
		if nVaincus > 3000 then wipe(vaincus); nVaincus = 0 end
		-- (en instance, cette mort a pu être déjà comptée par le nom du monstre)
		local c = Instance.sansGuid[id]
		if c and c.n > 0 and GetTime() - c.t < 900 then
			c.n = c.n - 1
			return
		end
		Instance.parGuid[id] = GetTime()
	end
	local e = unite and Apprendre(unite, id) or Entree(id)
	if not e then
		if not Bestiaire().par[id] then return end -- (hors bestiaire, jamais vu : on ne sait rien de lui)
		e = Entree(id, true)
		if not e then return end
	end
	e.v = e.v or Maintenant()
	e.k = (e.k or 0) + 1
	MajBientot()
	-- un rare du monde vaincu : la guilde apprend l'heure de sa mort (à chaque fois, pas seulement la première)
	local fr = Bestiaire().par[id]
	if fr and TRAQUES[fr.rang] then
		local g = Guilde()
		if g then
			g.morts[id] = { c = MaCle(), t = Maintenant() }
			Envoyer("K~" .. Base36(id))
		end
	end
	if e.k > 1 then return end
	-- nouvelle capture
	e.tk = Maintenant()
	local moi = MaCle()
	local nouveauGuilde = Decouverte(id, moi, Jour())
	AnnoncerCapture(id)
	local b = Bestiaire()
	local f = b.par[id]
	local rang = f and f.rang or e.r or 0
	local rare = RARES[rang] or false
	local s = MonScore()
	local w = Moi()
	if w then w.pistes[id] = nil end -- (capturé : plus besoin de le pister)
	if MasquerMarques then MasquerMarques(id) end
	local db = ns.DB and ns.DB()
	local bavard = not (db and type(db.notifs) == "table" and db.notifs.wowdex == false)
	local nom = NomMonstre(id)
	if bavard then
		if rare and f then
			Message(("WoWdex : |cffbfbfff%s|r %s%s|r capturé ! (rares et boss : %d sur %d)"):format(NOMS_RANGS[rang],
				"|cffffd100", ("n°%04d "):format(f.num) .. nom, s.r, b.rares))
		else
			Message(("WoWdex : %s%s|r capturé ! (%d sur %d)"):format("|cffffd100",
				(f and ("n°%04d "):format(f.num) or "") .. nom, s.k, b.nombre))
		end
	end
	-- ce que cette capture débloque : un titre (rares et boss), une zone (ses rares, ou tous ses monstres)
	local suites = {}
	if rare and f then
		local avant = Titre(s.r - 1)
		local apres, nomTitre = Titre(s.r)
		if apres > avant then suites[#suites + 1] = "Nouveau titre : " .. nomTitre end
	end
	if f then
		local st = StatsZones()
		for z in pairs(ZonesDe(f)) do
			local x = st[z]
			if x and x.k >= x.n then
				suites[#suites + 1] = (NomZone(z) or "Zone") .. " : zone complète !"
			elseif x and rare and x.raresK >= x.rares then
				suites[#suites + 1] = (NomZone(z) or "Zone") .. " : tous les rares capturés !"
			end
		end
	end
	if bavard then
		for _, ligne in ipairs(suites) do Message("WoWdex : |cffffd100" .. ligne .. "|r") end
	end
	if rare then
		local texte = nom .. (f and (" · %d sur %d"):format(s.r, b.rares) or "")
		if nouveauGuilde then texte = texte .. "\nUne première pour la guilde !" end
		if #suites > 0 then texte = texte .. "\n" .. table.concat(suites, "\n") end
		Notif("wowdex", "WoWdex : " .. NOMS_RANGS[rang] .. " capturé !", texte, nil, id)
		-- (fil d'activité : « W » la première capture de la guilde, « R » les suivantes)
		if ns.NoterActivite and moi and (nouveauGuilde or f) then
			ns.NoterActivite(nouveauGuilde and "W" or "R", moi, tostring(id))
		end
	elseif #suites > 0 then
		Notif("wowdex", "WoWdex", table.concat(suites, "\n"), nil, id)
	elseif s.k % PALIER_BULLE == 0 then
		Notif("wowdex", "WoWdex", ("%d monstres capturés !"):format(s.k))
	end
end
Instance.Vaincre = Vaincre

-- Récoltes : leur butin n'est pas celui du monstre (le cuir d'un loup dépecé, l'objet volé à un monstre vivant).
-- Rangs 1 à 4 du dépeçage, vol à la tire, minage, herboristerie ; les noms en plus, si Forever a ses propres numéros.
local SORTS_RECOLTE = { [8613] = true, [8617] = true, [8618] = true, [10768] = true, [921] = true,
	[2575] = true, [2576] = true, [3564] = true, [10248] = true,
	[2366] = true, [2368] = true, [3570] = true, [11993] = true }
local NOMS_RECOLTE = { ["Dépeçage"] = true, ["Skinning"] = true, ["Vol à la tire"] = true, ["Pick Pocket"] = true }
do
	local nomSort = (C_Spell and C_Spell.GetSpellName) or GetSpellInfo
	if nomSort then
		for id in pairs(SORTS_RECOLTE) do
			local ok, nom = pcall(nomSort, id)
			if ok and type(nom) == "string" and nom ~= "" then NOMS_RECOLTE[nom] = true end
		end
	end
end
local DELAI_RECOLTE = 2 -- secondes entre la fin du sort et l'ouverture du butin
local finRecolte = -math.huge

local function SortLance(sort)
	if not sort or Secrete(sort) then return end
	local recolte = SORTS_RECOLTE[sort]
	if not recolte then
		local nomSort = (C_Spell and C_Spell.GetSpellName) or GetSpellInfo
		local ok, nom = false, nil
		if nomSort then ok, nom = pcall(nomSort, sort) end
		recolte = ok and type(nom) == "string" and not Secrete(nom) and NOMS_RECOLTE[nom]
	end
	if recolte then finRecolte = GetTime() end
end

-- un monstre ciblé encore vivant (vol à la tire) n'a rien lâché. En instance, le GUID de la cible est caché : le
-- comparer lève une erreur (« attempt to compare a secret value » à l'ouverture d'un butin, jusqu'à la 7.7.1).
local function Vivant(guid)
	local cible = UnitExists("target") and UnitGUID("target")
	if not cible or Secrete(cible) or cible ~= guid then return false end
	return not UnitIsDead("target")
end

-- corps fouillés : chaque corps (GUID) compte une fois, avec les objets qu'il a lâchés. Appelé à LOOT_READY
-- (pret) puis à LOOT_OPENED : un corps déjà compté ne gagne alors que les objets pas encore lus, et seulement
-- pendant 2 s (plus tard, un second butin sur le même corps est une récolte).
local function Fouiller(pret)
	Instance.Noter(pret and "butinsPrets" or "butinsOuverts")
	if IsFishingLoot and IsFishingLoot() then return end
	if GetTime() - finRecolte < DELAI_RECOLTE then return end
	local n = GetNumLootItems and GetNumLootItems() or 0
	if type(n) ~= "number" or Secrete(n) then return end
	local corps = {} -- [GUID] = { id, objets = { [objet] = true } }
	local avecSources = GetLootSourceInfo ~= nil
	for slot = 1, n do
		local lien = GetLootSlotLink and GetLootSlotLink(slot)
		local objet = type(lien) == "string" and not Secrete(lien) and tonumber(lien:match("item:(%d+)")) or nil
		if avecSources then
			local sources = { GetLootSourceInfo(slot) }
			for i = 1, #sources, 2 do
				local guid = sources[i]
				if Secrete(guid) then Instance.Noter("sourcesCachees") end
				local id = PnjDuGuid(guid)
				if id then
					corps[guid] = corps[guid] or { id = id, objets = {} }
					if objet then corps[guid].objets[objet] = true end
				end
			end
		end
	end
	if not avecSources and UnitExists("target") and UnitIsDead("target") then
		-- (client sans GetLootSourceInfo : le corps ciblé)
		local guid = UnitGUID("target")
		local id = PnjDuGuid(guid)
		if id then
			corps[guid] = { id = id, objets = {} }
			for slot = 1, n do
				local lien = GetLootSlotLink and GetLootSlotLink(slot)
				local objet = type(lien) == "string" and not Secrete(lien) and tonumber(lien:match("item:(%d+)")) or nil
				if objet then corps[guid].objets[objet] = true end
			end
		end
	end
	local t = GetTime()
	for guid, c in pairs(corps) do
		local lus = fouilles[guid]
		if lus and t - lus.t >= DELAI_RECOLTE then
			-- (corps déjà fouillé)
		elseif not Vivant(guid) and (Bestiaire().par[c.id] or Entree(c.id)) then
			local nouveau = false
			if not lus then
				lus = { t = t }
				nFouilles = nFouilles + 1
				if nFouilles > 3000 then wipe(fouilles); nFouilles = 1 end
				fouilles[guid] = lus
				Vaincre(c.id, guid)
				local e = Entree(c.id)
				if e then
					e.d = (e.d or 0) + 1
					if e.d == 1 then ScorePlusTard() end
					nouveau = true
					Instance.Noter(pret and "corpsPrets" or "corpsOuverts")
				end
			end
			local e = Entree(c.id)
			if e then
				if type(e.b) ~= "table" then e.b = {} end
				for o in pairs(c.objets) do
					if not lus[o] then
						lus[o] = true
						e.b[o] = (e.b[o] or 0) + 1
						nouveau = true
					end
				end
				if nouveau then
					e.tb = Maintenant()
					AnnoncerButin(c.id)
					MajBientot()
				end
			end
		end
	end
end

-- un corps ciblé ou survolé qui n'est pas « pris par un autre » : vaincu par moi ou mon groupe
local function Observer(unite)
	local id, e = Vu(unite)
	if not id then return end
	if UnitIsDead(unite) and UnitIsTapDenied and not UnitIsTapDenied(unite) then
		Vaincre(id, UnitGUID(unite), unite)
	end
end

--------------------------------------------------------------------------------
-- Réseau : réception, rattrapage
--------------------------------------------------------------------------------

local pret = false

local function Relayer(depuis)
	local g = Guilde()
	if not g then return end
	local liste = {}
	for id, d in pairs(g.d) do
		if d.j >= depuis then liste[#liste + 1] = { id = id, c = d.c, j = d.j } end
	end
	table.sort(liste, function(a, b) if a.j ~= b.j then return a.j < b.j end return a.id < b.id end)
	local parMembre, ordre = {}, {}
	for i = 1, math.min(#liste, MAX_RELAIS) do
		local x = liste[i]
		if not parMembre[x.c] then parMembre[x.c] = {}; ordre[#ordre + 1] = x.c end
		local l = parMembre[x.c]
		l[#l + 1] = Base36(x.id) .. "." .. Base36(x.j)
	end
	for _, cle in ipairs(ordre) do EnvoyerMots("E~" .. cle .. "~", parMembre[cle], ",") end
	local scores = {}
	local limite = EPOQUE + depuis * 86400
	for cle, s in pairs(g.s) do
		if (s.t or 0) >= limite then
			scores[#scores + 1] = ("%s,%d,%d,%d,%s"):format(cle, s.v or 0, s.k or 0, s.d or 0, Base36(s.t or 0))
		end
	end
	EnvoyerMots("T~", scores, ";")
	local rares = {}
	for cle, s in pairs(g.s) do
		if s.r and (s.t or 0) >= limite then rares[#rares + 1] = ("%s,%d"):format(cle, s.r) end
	end
	EnvoyerMots("U~", rares, ";")
end

-- relevés de butin changés depuis « depuis » (de tous les membres, moi compris), les plus anciens d'abord, 300 au
-- plus ; puis la fin du rattrapage, qui dit au demandeur où reprendre
local function RelayerButin(depuis, demandeur)
	local g = Guilde()
	local moi = MaCle()
	if not g or not moi then return end
	local liste = {}
	for id, parPnj in pairs(g.butin) do
		for cle, r in pairs(parPnj) do
			if cle ~= moi and (r.t or 0) > depuis then liste[#liste + 1] = { cle = cle, id = id, r = r } end
		end
	end
	local w = Moi()
	for id in pairs(w and w.m or {}) do
		local r = MonReleve(id)
		if r and r.t > depuis then liste[#liste + 1] = { cle = moi, id = id, r = r } end
	end
	table.sort(liste, function(a, b)
		if a.r.t ~= b.r.t then return a.r.t < b.r.t end
		if a.id ~= b.id then return a.id < b.id end
		return a.cle < b.cle
	end)
	local n = math.min(#liste, MAX_RELAIS_BUTIN)
	local parMembre, ordre = {}, {}
	for i = 1, n do
		local x = liste[i]
		if not parMembre[x.cle] then parMembre[x.cle] = {}; ordre[#ordre + 1] = x.cle end
		MotsButin(x.id, x.r, parMembre[x.cle])
	end
	for _, cle in ipairs(ordre) do EnvoyerMots("R~" .. cle .. "~", parMembre[cle], ";") end
	-- (tout envoyé : le demandeur reprendra à maintenant ; coupé : au dernier relevé envoyé)
	local fin = (#liste > n) and liste[n].r.t or Maintenant()
	Envoyer("F~" .. demandeur .. "~" .. Base36(fin))
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or type(msg) ~= "string" or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui or qui == MaCle() then return end
	local g = Guilde()
	if not g then return end
	local genre, suite = msg:match("^(%u)~(.*)$")
	if genre == "N" then
		local j = Jour()
		for mot in suite:gmatch("[^,]+") do
			local id = tonumber(mot, 36)
			if id then
				local premiere = Decouverte(id, qui, j)
				local f = Bestiaire().par[id]
				if f and RARES[f.rang] and ns.NoterActivite then
					ns.NoterActivite(premiere and "W" or "R", qui, tostring(id))
				end
			end
		end
		MajBientot()
	elseif genre == "B" or genre == "R" then
		-- (B : les relevés de l'expéditeur ; R : ceux d'un membre, renvoyés par le relais)
		local cle, liste = qui, suite
		if genre == "R" then
			cle, liste = suite:match("^([^~]+)~(.*)$")
			if not cle or cle:find("[,;|:]") then return end
		end
		for mot in liste:gmatch("[^;]+") do
			local pnj, corps, t, reste = mot:match("^(%w+):(%d+):(%w+)(.*)$")
			local id, k = pnj and tonumber(pnj, 36), tonumber(corps)
			t = t and tonumber(t, 36)
			if id and k and k > 0 and t and t <= Maintenant() + 120 then
				local objets = {}
				for o, n in (reste or ""):gmatch("%.(%w+)%.(%d+)") do
					o, n = tonumber(o, 36), tonumber(n)
					if o and n and n <= k then objets[o] = n end
				end
				RecevoirReleve(cle, id, k, objets, t)
			end
		end
		MajBientot()
	elseif genre == "P" then
		local depuis = tonumber(suite, 36)
		if not depuis or not pret or not (ns.EstLeRelais and ns.EstLeRelais(qui)) then return end
		C_Timer.After(8 + math.random() * 4, function() RelayerButin(depuis, qui) end)
	elseif genre == "F" then
		local demandeur, t = suite:match("^([^~]+)~(%w+)$")
		t = t and tonumber(t, 36)
		if demandeur == MaCle() and t and t > (g.curseurButin or 0) then g.curseurButin = t end
	elseif genre == "S" then
		local v, k, d = suite:match("^(%d+)~(%d+)~(%d+)$")
		if v then
			g.s[qui] = { v = tonumber(v), k = tonumber(k), d = tonumber(d), t = Maintenant(), r = g.s[qui] and g.s[qui].r }
			MajBientot()
		end
	elseif genre == "C" then
		local r = tonumber(suite:match("^(%d+)"))
		if r then
			local s = g.s[qui]
			if not s then s = { v = 0, k = 0, d = 0, t = Maintenant() }; g.s[qui] = s end
			s.r = r
			MajBientot()
		end
	elseif genre == "U" then
		for cle, r in suite:gmatch("([^,;]+),(%d+)") do
			local s = g.s[cle]
			if s and cle ~= MaCle() then s.r = math.max(s.r or 0, tonumber(r)) end
		end
		MajBientot()
	elseif genre == "K" then
		local id = tonumber(suite, 36)
		local f = id and Bestiaire().par[id]
		if f and TRAQUES[f.rang] then
			g.morts[id] = { c = qui, t = Maintenant() }
			MajBientot()
		end
	elseif genre == "V" then
		local pnj, carte, x, y = suite:match("^(%w+)~(%d*)~(%d*)~(%d*)$")
		local id = pnj and tonumber(pnj, 36)
		local f = id and Bestiaire().par[id]
		if f and TRAQUES[f.rang] then
			local t = Maintenant()
			local recent = g.r[id] and t - (g.r[id].t or 0) < DELAI_REPERAGE
			x, y = tonumber(x), tonumber(y)
			g.r[id] = { c = qui, t = t, carte = tonumber(carte), x = x and x / 10000, y = y and y / 10000 }
			MajBientot()
			if not recent and Palier(Entree(id)) < 2 and AlertesActives() then
				Notif("wowdex", "WoWdex : " .. NOMS_RANGS[f.rang] .. " en vue !", ("%s (%s)\nRepéré par %s."):format(f.nom,
					NomZone(f.zone) or "zone inconnue", NomJoueur(qui)), nil, id)
			end
		end
	elseif genre == "Q" then
		local depuis = tonumber(suite, 36)
		if not depuis or not pret or not (ns.EstLeRelais and ns.EstLeRelais(qui)) then return end
		C_Timer.After(4 + math.random() * 4, function() Relayer(depuis) end)
	elseif genre == "E" then
		local cle, liste = suite:match("^([^~]+)~(.*)$")
		if cle and not cle:find("[,;|]") then
			for id, j in liste:gmatch("(%w+)%.(%w+)") do Decouverte(tonumber(id, 36), cle, tonumber(j, 36)) end
			MajBientot()
		end
	elseif genre == "T" then
		for mot in suite:gmatch("[^;]+") do
			local cle, v, k, d, t = mot:match("^([^,]+),(%d+),(%d+),(%d+),(%w+)$")
			t = t and tonumber(t, 36)
			if cle and t and cle ~= MaCle() and (not g.s[cle] or (g.s[cle].t or 0) < t) then
				g.s[cle] = { v = tonumber(v), k = tonumber(k), d = tonumber(d), t = t, r = g.s[cle] and g.s[cle].r }
			end
		end
		MajBientot()
	end
end

--------------------------------------------------------------------------------
-- Infobulle des monstres : « WoWdex n°0016  capturé ×12 », « à capturer », « Rare à capturer ! », « (pisté) »
--------------------------------------------------------------------------------

local function BulleUnite(tt)
	if not tt or not tt.GetUnit then return end
	local _, unite = tt:GetUnit()
	if not unite or Secrete(unite) then return end
	local id = Lire(unite)
	if not id then return end
	local f = Bestiaire().par[id]
	local e = Entree(id)
	local p = Palier(e)
	local texte = "|cffffd100WoWdex|r" .. (f and (" n°%04d"):format(f.num) or "")
	if p >= 2 then
		texte = texte .. ("  |cff6fd08ccapturé ×%d|r"):format(e.k or 0)
		if (e.d or 0) > 0 then texte = texte .. ("|cff9c9380, dépouillé ×%d|r"):format(e.d) end
	else
		local g = Guilde()
		local rang = f and f.rang or (e and e.r) or 0
		texte = texte .. (RARES[rang] and ("  |cffbfbfff" .. NOMS_RANGS[rang] .. " à capturer !|r") or "  |cffff9f40à capturer|r")
			.. ((g and g.d[id]) and "|cff9c9380 (déjà dans le WoWdex de la guilde)|r" or "")
		local w = Moi()
		if w and w.pistes[id] then texte = texte .. "  |cfff1cf6b(pisté)|r" end
	end
	tt:AddLine(texte)
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tt) pcall(BulleUnite, tt) end)
elseif GameTooltip and GameTooltip.HookScript then
	pcall(GameTooltip.HookScript, GameTooltip, "OnTooltipSetUnit", function(self) pcall(BulleUnite, self) end)
end

--------------------------------------------------------------------------------
-- Page « WoWdex » : entête (rares et boss, titre), onglets, vues
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI and UI.C
local MARGE = 16
local LARGEUR_FICHE = 300
local HAUT_VUES = -92            -- sous l'entête et les onglets
local ONGLETS = { "Avis de recherche", "Bestiaire", "Zones", "Carnet de chasse", "Guilde" }
local FILTRES = { { "Tous", "À capturer", "Capturés" }, { "Tous", "Vus", "Capturés", "À capturer" } }
local GRIS, VERT, OR, BLEU = "|cff9c9380", "|cff6fd08c", "|cfff1cf6b", "|cffbfbfff"
local COULEUR_RARE = { 0.75, 0.75, 1 }
local COULEURS_PALIERS = { [0] = { 0.3, 0.27, 0.22 }, { 0.75, 0.72, 0.65 }, { 0.44, 0.82, 0.55 }, { 0.945, 0.81, 0.42 } }
local NOMS_PALIERS = { [0] = "Jamais rencontré", "Vu", "Capturé", "Capturé et dépouillé" }
-- La grille : « cases » (bestiaire, 6 par ligne) ou « cartes » (avis de recherche et recherche d'un objet, 3 par
-- ligne, avec le nom). Toujours des lignes entières : un modèle 3D ne se découpe pas au bord d'une zone qui défile.
-- Colonnes, lignes et taille des cases sont calculées à la création de la grille, d'après la place de la page
-- (taille minimale d'une case : largeurMin × hauteurMin).
local MODES = {
	cases = { largeurMin = 70, hauteurMin = 82, ecart = 6, col = 6, lignes = 5, largeur = 68, hauteur = 82 },
	cartes = { largeurMin = 136, hauteurMin = 138, ecart = 6, col = 3, lignes = 3, largeur = 142, hauteur = 140 },
}
local TRANCHES = { { 1, 9 }, { 10, 19 }, { 20, 29 }, { 30, 39 }, { 40, 49 }, { 50, 59 }, { 60, 999 } }
local ORDRE_RANGS = { 4, 2, 3, 1, 0 } -- rare, rare élite, boss, élite, normal

-- ce que la page montre : onglet, puce choisie dans chaque grille, recherche, zone ("toutes", "ici" ou un numéro
-- de zone), première ligne affichée de la grille
local etat = { onglet = 1, filtres = { 1, 1 }, filtreZones = 1, recherche = "", zone = "toutes", ligne = 0, parObjet = false }
local affiches = {}       -- éléments de la grille : une fiche du bestiaire, ou { hors = pnj, e = entrée }
local choisi              -- pnj de la fiche ouverte
local DessinerGrille, MajFiche -- (définis plus bas)

local function Couleur(c) return ("|cff%02x%02x%02x"):format(math.floor(c[1] * 255), math.floor(c[2] * 255), math.floor(c[3] * 255)) end

local function LargeurPage() return (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) end
local function HauteurPage() return (ns.TAILLE_PAGE and ns.TAILLE_PAGE[2] or 586) end

local function NiveauTexte(mi, ma)
	if not mi or mi <= 0 then return nil end
	return (ma and ma ~= mi) and (mi .. "-" .. ma) or tostring(mi)
end

-- « il y a 12 min » (heure du serveur, comme les dates gardées)
local function IlYa(t)
	local s = math.max(0, Maintenant() - (t or 0))
	if s < 90 then return "à l'instant" end
	if s < 3600 then return "il y a " .. math.floor(s / 60) .. " min" end
	if s < 86400 then return "il y a " .. math.floor(s / 3600) .. " h" end
	return "il y a " .. math.floor(s / 86400) .. " j"
end

-- les zones de ma carte actuelle (filtre « Ma zone », carte « Tu es ici »)
local function ZonesDeMaCarte()
	local res = {}
	local carte = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not carte then return res end
	for z, info in pairs(Bestiaire().zones) do
		if info.carte == carte then res[z] = true end
	end
	return res, carte
end

-- les monstres d'un ensemble de zones : n, k capturés par moi, g par la guilde (ou moi), rares = leurs fiches,
-- raresK = rares capturés par moi
local function Recensement(zones)
	local res = { n = 0, k = 0, g = 0, rares = {}, raresK = 0 }
	if not zones or not next(zones) then return res end
	local w, g = Moi(), Guilde()
	for _, f in ipairs(Bestiaire().liste) do
		local ici = false
		for z in pairs(ZonesDe(f)) do
			if zones[z] then ici = true; break end
		end
		if ici then
			local pris = w and Palier(w.m[f.id]) >= 2 or false
			res.n = res.n + 1
			if pris then res.k = res.k + 1 end
			if pris or (g and g.d[f.id]) then res.g = res.g + 1 end
			if RARES[f.rang] then
				res.rares[#res.rares + 1] = f
				if pris then res.raresK = res.raresK + 1 end
			end
		end
	end
	return res
end

-- dernier repérage d'un rare par la guilde : « il y a 12 min », nom du membre, repérage (recent : nil au-delà
-- d'une heure) ; nil s'il a été vaincu depuis : il n'est plus là
local function Reperage(id, recent)
	local g = Guilde()
	local r = g and g.r[id]
	if not r or not r.t then return nil end
	local mort = g.morts[id]
	if mort and (mort.t or 0) >= r.t then return nil end
	if recent and Maintenant() - r.t > 3600 then return nil end
	return IlYa(r.t), r.c and NomJoueur(r.c) or nil, r
end

-- dernière fois qu'un membre a vaincu ce rare : « il y a 40 min », nom du membre
local function DerniereMort(id, recent)
	local g = Guilde()
	local m = g and g.morts[id]
	if not m or not m.t then return nil end
	if recent and Maintenant() - m.t > 3600 then return nil end
	return IlYa(m.t), m.c and NomJoueur(m.c) or nil
end

-- Distances, en mètres du jeu : entre moi et un point de carte (x, y de 0 à 1), entre moi et l'apparition la plus
-- proche d'un monstre ; nil si la position est inconnue ou sur un autre continent
local Distance = {}
function Distance.A(carte, x, y)
	if not (ns.MaPosition and ns.PositionMonde and carte and x and y) then return nil end
	local maCarte, mx, my = ns.MaPosition()
	if not maCarte then return nil end
	local n1, o1, c1 = ns.PositionMonde(maCarte, mx, my)
	local n2, o2, c2 = ns.PositionMonde(carte, x, y)
	if not (n1 and n2) or c1 ~= c2 then return nil end
	return math.sqrt((n1 - n2) ^ 2 + (o1 - o2) ^ 2)
end
function Distance.Monstre(f)
	local proche
	local zones = Bestiaire().zones
	for _, z in ipairs(f and ZonesFiche(f) or {}) do
		local carte = zones[z.zone] and zones[z.zone].carte
		for _, pt in ipairs(carte and z.points or {}) do
			local d = Distance.A(carte, pt[1] / 100, pt[2] / 100)
			if d and (not proche or d < proche) then proche = d end
		end
	end
	return proche
end
function Distance.Texte(d)
	return d and (math.floor(d + 0.5) .. " m") or nil
end

-- ce que veut dire chaque ligne de la fiche (infobulle au survol)
local AIDES = {
	Vu = "Tu l'as croisé : sa barre de nom est apparue, tu l'as ciblé ou survolé. Son nom et son modèle se dévoilent.",
	["Capturé"] = "Toi ou ton groupe l'avez vaincu. C'est le palier qui compte pour le WoWdex, et pour un rare, ton titre et le classement. Il est noté quand tu cibles, survoles ou fouilles son corps. En donjon, le jeu cache aux addons qui sont les monstres : ils sont notés quand ils te donnent de l'expérience, à la fin d'un combat de boss, ou quand tu fouilles leur corps.",
	["Dépouillé"] = "Tu as fouillé son corps. Chaque corps fouillé alimente les taux de butin de la guilde. Le dépeçage et le vol à la tire ne comptent pas.",
	Guilde = "Le premier membre de la guilde à l'avoir capturé.",
	["Repéré"] = "La dernière fois qu'un membre l'a vu vivant. Le bouton « Y aller » pose un repère à cet endroit.",
	["Tué"] = "La dernière fois qu'un membre l'a vaincu : il lui faut le temps de réapparaître.",
}

-- Recherche d'un objet : les objets dont le nom contient le texte (liste de tous les objets du jeu,
-- GuildUp_Demandes.lua), puis les monstres qui les lâchent : trouvés par la guilde (ou moi), ou dans le bestiaire.
-- objetDe[pnj] = { objet, guilde = vrai si trouvé en jeu } (remis à zéro à chaque construction de la liste)
local objetDe = {}

local function ChercherParObjet(b, g, w)
	wipe(objetDe)
	local recherche = etat.recherche
	if #recherche < 3 or not ns.IndexObjets then return false end
	local cherches, n = {}, 0
	for _, o in ipairs(ns.IndexObjets()) do
		if o[4]:find(recherche, 1, true) then
			cherches[o[1]] = true
			n = n + 1
			if n >= 300 then break end
		end
	end
	if n == 0 then return false end
	local function Trouve(id, objet, guilde)
		local x = objetDe[id]
		if not x or (guilde and not x.guilde) then objetDe[id] = { objet = objet, guilde = guilde } end
	end
	for id, e in pairs(w and w.m or {}) do
		for o in pairs(type(e.b) == "table" and e.b or {}) do
			if cherches[o] then Trouve(id, o, true) end
		end
	end
	for id, parPnj in pairs(g and g.butin or {}) do
		for _, r in pairs(parPnj) do
			for o in pairs(r.o or {}) do
				if cherches[o] then Trouve(id, o, true) end
			end
		end
	end
	for _, f in ipairs(b.liste) do
		for _, o in ipairs(ButinFiche(f)) do
			if cherches[o] then Trouve(f.id, o, false); break end
		end
	end
	return true
end

-- la liste de la grille : l'avis de recherche ne garde que les rares, rares élites et boss
local function Construire()
	wipe(affiches)
	local b, g, w = Bestiaire(), Guilde(), Moi()
	local raresSeuls = (etat.onglet == 1)
	local filtre = etat.filtres[raresSeuls and 1 or 2]
	local recherche = etat.recherche
	local maZone, maCarte
	if etat.zone == "ici" then
		maZone, maCarte = ZonesDeMaCarte()
	elseif type(etat.zone) == "number" then
		maZone = { [etat.zone] = true }
	end
	local parObjet = ChercherParObjet(b, g, w)
	etat.parObjet = parObjet
	local function Garder(id, rang, zones, nomVisible, texteZone)
		local e = w and w.m[id]
		local p = Palier(e)
		if raresSeuls then
			if not RARES[rang or 0] then return false end
			if filtre == 2 and p >= 2 then return false end
			if filtre == 3 and p < 2 then return false end
		else
			if filtre == 2 and p < 1 then return false end
			if filtre == 3 and p < 2 then return false end
			if filtre == 4 and p >= 2 then return false end
		end
		if maZone then
			local ici = zones.ici
			if not ici then
				for z in pairs(zones) do
					if maZone[z] then ici = true; break end
				end
			end
			if not ici then return false end
		end
		if recherche ~= "" and not (parObjet and objetDe[id]) then
			local cle = Simplifier((nomVisible or "") .. " " .. (texteZone or ""))
			if not cle:find(recherche, 1, true) then return false end
		end
		return true
	end
	for _, f in ipairs(b.liste) do
		local connu = (w and w.m[f.id] and w.m[f.id].v) or (g and (g.d[f.id] or g.r[f.id]))
		if Garder(f.id, f.rang, ZonesDe(f), connu and f.nom or nil, NomZone(f.zone)) then affiches[#affiches + 1] = f end
	end
	-- hors bestiaire, après les numéros
	if w then
		local hors = {}
		for id, e in pairs(w.m) do
			if not b.par[id] and e.n then
				local zones = { ici = maCarte and e.c == maCarte or nil }
				if Garder(id, e.r, zones, e.n, e.z) then hors[#hors + 1] = { hors = id, e = e } end
			end
		end
		table.sort(hors, function(x, y) return (x.e.l or 0) < (y.e.l or 0) or ((x.e.l or 0) == (y.e.l or 0) and x.hors < y.hors) end)
		for _, h in ipairs(hors) do affiches[#affiches + 1] = h end
	end
	-- recherche d'un objet : les monstres où la guilde l'a trouvé d'abord (dans l'ordre du WoWdex)
	if parObjet then
		local trouves, autres = {}, {}
		for _, a in ipairs(affiches) do
			local x = objetDe[a.hors or a.id]
			if x and x.guilde then trouves[#trouves + 1] = a else autres[#autres + 1] = a end
		end
		wipe(affiches)
		for _, a in ipairs(trouves) do affiches[#affiches + 1] = a end
		for _, a in ipairs(autres) do affiches[#affiches + 1] = a end
	end
end

local function NomObjet(objet)
	local nom = ns.InfoObjet(objet)
	if not nom and ns.Precharger then ns.Precharger(objet) end
	return nom or (ns.NomObjetListe and ns.NomObjetListe(objet)) or ("objet n° " .. objet)
end

-- infos d'un élément affiché : id, numéro, nom (ou nil si inconnu), rang, niveau, zone, entrée
local function Infos(a)
	if a.hors then
		local e = a.e or Entree(a.hors)
		return a.hors, nil, e and e.n, e and e.r or 0, e and NiveauTexte(e.l), e and e.z, e
	end
	local f = a
	local e = Entree(f.id)
	return f.id, f.num, Connu(f.id) and f.nom or nil, f.rang, NiveauTexte(f.min, f.max), NomZone(f.zone), e
end

--------------------------------------------------------------------------------
-- Petits éléments : losange de rang, barre de progression, pilule
--------------------------------------------------------------------------------

-- carré posé sur la pointe (repli : un carré droit si le client ne sait pas tourner une texture)
local function Losange(parent, taille)
	local t = parent:CreateTexture(nil, "OVERLAY")
	t:SetColorTexture(1, 1, 1, 1)
	t:SetSize(taille, taille)
	if t.SetRotation then pcall(t.SetRotation, t, math.rad(45)) end
	return t
end

-- barre : b:Poser(part, couleur, partGuilde) ; la part de la guilde est un trait vertical
local function Barre(parent, largeur, hauteur)
	local f = UI.Cadre(parent, C.champ, C.bord)
	f:SetSize(largeur, hauteur)
	f.plein = f:CreateTexture(nil, "ARTWORK")
	f.plein:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
	f.plein:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
	f.trait = f:CreateTexture(nil, "OVERLAY")
	f.trait:SetSize(2, hauteur + 4)
	f.trait:SetColorTexture(C.texte[1], C.texte[2], C.texte[3], 0.85)
	f.trait:Hide()
	f.Poser = function(self, part, couleur, partGuilde)
		part = math.max(0, math.min(1, part or 0))
		couleur = couleur or C.orFonce
		self.plein:SetColorTexture(couleur[1], couleur[2], couleur[3], 1)
		self.plein:SetWidth(math.max(1, (largeur - 2) * part))
		self.plein:SetShown(part > 0)
		if partGuilde and partGuilde > 0 then
			self.trait:ClearAllPoints()
			self.trait:SetPoint("CENTER", self, "LEFT", 1 + (largeur - 2) * math.min(1, partGuilde), 0)
			self.trait:Show()
		else
			self.trait:Hide()
		end
	end
	return f
end

-- pilule : petit texte sur un fond teinté ; p:Ecrire(texte, couleur) renvoie sa largeur (0 : cachée)
local function Pilule(parent)
	local f = UI.Cadre(parent, C.voile)
	f:SetHeight(18)
	f.texte = UI.Texte(f, "GameFontHighlightSmall", C.texte)
	f.texte:SetPoint("CENTER", f, "CENTER", 0, 0)
	f.Ecrire = function(self, texte, couleur)
		if not texte or texte == "" then self:Hide(); return 0 end
		couleur = couleur or C.texte
		self.texte:SetText(texte)
		self.texte:SetTextColor(couleur[1], couleur[2], couleur[3])
		self:SetBackdropColor(couleur[1], couleur[2], couleur[3], 0.13)
		local l = (tonumber(self.texte:GetStringWidth()) or 40) + 14
		self:SetWidth(l)
		self:Show()
		return l
	end
	return f
end

-- un modèle 3D montre le monstre (faux si le client refuse)
local function PoserModele(m, id, angle)
	if not m then return false end
	pcall(m.ClearModel, m)
	local ok = pcall(m.SetCreature, m, id)
	if ok and angle then pcall(m.SetFacing, m, angle) end
	return ok
end

--------------------------------------------------------------------------------
-- Grille des monstres
--------------------------------------------------------------------------------

local pools = { cases = {}, cartes = {} } -- cases déjà créées, par mode

local function ModeGrille() return (etat.onglet == 1 or etat.parObjet) and "cartes" or "cases" end

-- rend visible l'élément i de la grille
local function Montrer(i)
	local m = MODES[ModeGrille()]
	local ligne = math.floor((i - 1) / m.col)
	if ligne < etat.ligne then
		etat.ligne = ligne
	elseif ligne >= etat.ligne + m.lignes then
		etat.ligne = ligne - m.lignes + 1
	end
end

local function BulleCase(c)
	if not c.element then return end
	local id, num, nom, rang, niveau, zone, e = Infos(c.element)
	local cr = COULEURS_RANGS[rang or 0] or COULEURS_RANGS[0]
	GameTooltip:SetOwner(c, "ANCHOR_RIGHT")
	GameTooltip:SetText((num and ("n° %04d  "):format(num) or "") .. (nom or "???"), cr[1], cr[2], cr[3])
	local d = {}
	if rang and rang > 0 then d[#d + 1] = NOMS_RANGS[rang] end
	if niveau then d[#d + 1] = "niveau " .. niveau end
	if #d > 0 then GameTooltip:AddLine(table.concat(d, " · "), 1, 1, 1) end
	if zone then GameTooltip:AddLine(zone, C.gris[1], C.gris[2], C.gris[3]) end
	local p = Palier(e)
	local pc = COULEURS_PALIERS[p]
	GameTooltip:AddLine(NOMS_PALIERS[p], math.max(0.6, pc[1]), math.max(0.57, pc[2]), math.max(0.5, pc[3]))
	local w = Moi()
	if w and w.pistes[id] then GameTooltip:AddLine("Pisté", C.ors[1], C.ors[2], C.ors[3]) end
	GameTooltip:Show()
end

local function CreerCase(parent, grand)
	local c = CreateFrame("Button", nil, parent, "BackdropTemplate")
	UI.Habiller(c, C.carte, C.bord)
	local okM, m = pcall(CreateFrame, "PlayerModel", nil, c)
	if okM and m then
		m:SetPoint("TOPLEFT", c, "TOPLEFT", 2, grand and -2 or -12)
		m:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", -2, grand and 54 or 9)
		if m.EnableMouse then pcall(m.EnableMouse, m, false) end
		c.modele = m
	end
	-- textes et marques : dans un cadre posé au-dessus du modèle
	local d = CreateFrame("Frame", nil, c)
	d:SetAllPoints(c)
	d:SetFrameLevel((c:GetFrameLevel() or 1) + 4)
	c.num = UI.Texte(d, "GameFontHighlightSmall", C.gris)
	c.num:SetPoint("TOPLEFT", c, "TOPLEFT", 4, -3)
	c.losange = Losange(d, 7)
	c.losange:SetPoint("TOPRIGHT", c, "TOPRIGHT", -5, -5)
	c.mystere = UI.Texte(d, "GameFontNormalLarge", C.bordFort)
	c.mystere:SetText("?")
	if c.modele then
		c.mystere:SetPoint("CENTER", c.modele, "CENTER", 0, 0)
	else
		c.mystere:SetPoint("CENTER", c, "CENTER", 0, grand and 24 or 0)
	end
	c.crans = {}
	for i = 1, 3 do
		local t = d:CreateTexture(nil, "OVERLAY")
		t:SetSize(12, 3)
		if grand then
			t:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", -6 - (3 - i) * 14, 6)
		else
			t:SetPoint("BOTTOM", c, "BOTTOM", (i - 2) * 14, 4)
		end
		c.crans[i] = t
	end
	if grand then
		c.nom = UI.Texte(d, "GameFontHighlight", C.texte)
		c.nom:SetPoint("BOTTOMLEFT", c, "BOTTOMLEFT", 7, 37)
		c.nom:SetPoint("RIGHT", c, "RIGHT", -6, 0)
		c.sous = UI.Texte(d, "GameFontHighlightSmall", C.gris)
		c.sous:SetPoint("BOTTOMLEFT", c, "BOTTOMLEFT", 7, 22)
		c.sous:SetPoint("RIGHT", c, "RIGHT", -6, 0)
		c.etat = UI.Texte(d, "GameFontHighlightSmall", C.gris)
		c.etat:SetPoint("BOTTOMLEFT", c, "BOTTOMLEFT", 7, 7)
		c.etat:SetPoint("RIGHT", c, "RIGHT", -50, 0)
	end
	c.accent = UI.Accent(c)
	UI.Survol(c, 0.05)
	c:SetScript("OnClick", function(self)
		if not self.id then return end
		choisi = self.id
		MajFiche()
		DessinerGrille()
	end)
	UI.SonClic(c)
	c:SetScript("OnEnter", BulleCase)
	c:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return c
end

local function RemplirCase(c, a, grand)
	local id, num, nom, rang, niveau, zone, e = Infos(a)
	rang = rang or 0
	local p = Palier(e)
	local connu = (nom ~= nil)
	local cr = COULEURS_RANGS[rang] or COULEURS_RANGS[0]
	-- modèle : rechargé seulement quand la case change de monstre
	local cle = id .. (connu and ":1" or ":0")
	if c.cle ~= cle then
		c.cle = cle
		local montre = connu and PoserModele(c.modele, id, 0.45) or false
		if c.modele then c.modele:SetShown(montre) end
		c.mystere:SetShown(not montre)
	end
	c.id, c.element = id, a
	-- (vu ou connu par la guilde, pas encore capturé : dans l'ombre)
	if c.modele then pcall(c.modele.SetAlpha, c.modele, p >= 2 and 1 or 0.4) end
	c.num:SetText(num and ("%04d"):format(num) or "hors")
	if rang > 0 then
		c.losange:SetColorTexture(cr[1], cr[2], cr[3], 1)
		c.losange:Show()
	else
		c.losange:Hide()
	end
	for i, t in ipairs(c.crans) do
		local col = (p >= i) and COULEURS_PALIERS[i] or C.bord
		t:SetColorTexture(col[1], col[2], col[3], 1)
	end
	-- choisie : fond clair et trait doré ; rare pas encore capturé : contour bleuté ; pisté : contour doré
	local w = Moi()
	local ouvert = (id == choisi)
	c:SetBackdropColor(unpack(ouvert and C.actif or C.carte))
	c.accent:SetShown(ouvert)
	if RARES[rang] and p < 2 then
		c:SetBackdropBorderColor(cr[1] * 0.6, cr[2] * 0.6, cr[3] * 0.6, 1)
	elseif w and w.pistes[id] then
		c:SetBackdropBorderColor(unpack(C.bordFort))
	else
		c:SetBackdropBorderColor(unpack(C.bord))
	end
	if not grand then return end
	c.nom:SetText(nom or "???")
	if nom then c.nom:SetTextColor(cr[1], cr[2], cr[3]) else c.nom:SetTextColor(unpack(C.gris)) end
	local d = {}
	if rang > 0 then d[#d + 1] = Couleur(cr) .. NOMS_RANGS[rang] .. "|r" end
	if niveau then d[#d + 1] = "niv. " .. niveau end
	c.sous:SetText(table.concat(d, " · "))
	-- dernière ligne : l'objet cherché, un repérage ou une mort de moins d'une heure, « capturé », sinon la zone
	local x = objetDe[id]
	local quand, qui = Reperage(id, true)
	if x then
		local k, o = TotauxButin(id)
		local taux = (x.guilde and k > 0 and o[x.objet]) and (" " .. VERT .. math.floor(100 * o[x.objet] / k + 0.5) .. " %|r") or ""
		c.etat:SetText(OR .. NomObjet(x.objet) .. "|r" .. taux)
	elseif quand and p < 2 then
		c.etat:SetText(OR .. "Repéré " .. quand .. "|r")
	elseif p < 2 and DerniereMort(id, true) then
		c.etat:SetText(GRIS .. "Tué " .. DerniereMort(id, true) .. "|r")
	elseif p >= 2 then
		c.etat:SetText(VERT .. "Capturé|r" .. (zone and (GRIS .. " · " .. zone .. "|r") or ""))
	else
		c.etat:SetText(zone or "")
	end
end

DessinerGrille = function()
	local gr = page and page.grille
	if not gr then return end
	local mode = ModeGrille()
	local m = MODES[mode]
	local grand = (mode == "cartes")
	local largeur = m.largeur
	local total = math.ceil(#affiches / m.col)
	local dernier = math.max(0, total - m.lignes)
	etat.ligne = math.max(0, math.min(dernier, etat.ligne))
	for nom, autre in pairs(pools) do
		if nom ~= mode then
			for _, c in pairs(autre) do c:Hide() end
		end
	end
	-- chaque monstre garde sa case tant qu'il est à l'écran : faire défiler d'une ligne ne recharge que les
	-- modèles de la ligne qui entre
	local N = m.col * m.lignes
	local pool = pools[mode]
	local pris = {}
	local base = etat.ligne * m.col
	for pos = 1, N do
		local i = base + pos
		local a = affiches[i]
		if a then
			local place = (i - 1) % N + 1
			local c = pool[place]
			if not c then
				c = CreerCase(gr, grand)
				pool[place] = c
			end
			pris[place] = true
			c:SetSize(largeur, m.hauteur)
			c:ClearAllPoints()
			c:SetPoint("TOPLEFT", gr, "TOPLEFT", ((pos - 1) % m.col) * (largeur + m.ecart),
				-math.floor((pos - 1) / m.col) * (m.hauteur + m.ecart))
			RemplirCase(c, a, grand)
			c:Show()
		end
	end
	for place, c in pairs(pool) do
		if not pris[place] then c:Hide() end
	end
	-- repère de défilement
	local piste = gr.piste
	if total > m.lignes then
		local hp = math.max(24, gr.hauteur * m.lignes / total)
		piste.poignee:ClearAllPoints()
		piste.poignee:SetPoint("TOP", piste, "TOP", 0, -(dernier > 0 and (etat.ligne / dernier) * (gr.hauteur - hp) or 0))
		piste.poignee:SetHeight(hp)
		piste:Show()
	else
		piste:Hide()
	end
end

local function CreerGrille(parent)
	local gr = CreateFrame("Frame", nil, parent)
	gr.largeur = LargeurPage() - 2 * MARGE - LARGEUR_FICHE - 10 - 12
	gr.hauteur = HauteurPage() + HAUT_VUES - 40 - 20
	for _, m in pairs(MODES) do
		m.col = math.max(1, math.floor((gr.largeur + m.ecart) / (m.largeurMin + m.ecart)))
		m.lignes = math.max(1, math.floor((gr.hauteur + m.ecart) / (m.hauteurMin + m.ecart)))
		m.largeur = math.floor((gr.largeur - (m.col - 1) * m.ecart) / m.col)
		m.hauteur = math.floor((gr.hauteur - (m.lignes - 1) * m.ecart) / m.lignes)
	end
	gr:SetSize(gr.largeur, gr.hauteur)
	gr:EnableMouseWheel(true)
	gr:SetScript("OnMouseWheel", function(_, sens)
		local pas = (IsShiftKeyDown and IsShiftKeyDown()) and MODES[ModeGrille()].lignes or 1
		etat.ligne = etat.ligne - sens * pas
		DessinerGrille()
	end)
	-- piste à droite : cliquer ou glisser pour aller loin (plus de 500 lignes dans le bestiaire)
	local piste = CreateFrame("Button", nil, gr)
	piste:SetSize(8, gr.hauteur)
	piste:SetPoint("TOPLEFT", gr, "TOPRIGHT", 4, 0)
	local fond = piste:CreateTexture(nil, "BACKGROUND")
	fond:SetAllPoints()
	fond:SetColorTexture(C.champ[1], C.champ[2], C.champ[3], 1)
	piste.poignee = piste:CreateTexture(nil, "ARTWORK")
	piste.poignee:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 0.6)
	piste.poignee:SetWidth(8)
	piste:SetScript("OnMouseDown", function(self) self.glisse = true; self.dernier = 0 end)
	piste:SetScript("OnMouseUp", function(self) self.glisse = false end)
	piste:SetScript("OnHide", function(self) self.glisse = false end)
	piste:SetScript("OnUpdate", function(self)
		if not self.glisse then return end
		if IsMouseButtonDown and not IsMouseButtonDown("LeftButton") then self.glisse = false; return end
		local maintenant = GetTime()
		if maintenant - (self.dernier or 0) < 0.08 then return end
		self.dernier = maintenant
		local _, y = GetCursorPosition()
		local echelle = self:GetEffectiveScale()
		local haut, bas = self:GetTop(), self:GetBottom()
		if not (y and echelle and haut and bas) or echelle <= 0 or haut <= bas then return end
		local part = math.max(0, math.min(1, (haut - y / echelle) / (haut - bas)))
		local m = MODES[ModeGrille()]
		local ligne = math.floor(part * math.max(0, math.ceil(#affiches / m.col) - m.lignes) + 0.5)
		if ligne ~= etat.ligne then
			etat.ligne = ligne
			DessinerGrille()
		end
	end)
	gr.piste = piste
	return gr
end

--------------------------------------------------------------------------------
-- Fiche d'un monstre
--------------------------------------------------------------------------------

local LIGNES_BUTIN = 9
local HAUT_SCENE = 128

local function Voisin(sens)
	local n = #affiches
	if n == 0 then return end
	local place = 0
	for i, a in ipairs(affiches) do
		if (a.hors or a.id) == choisi then place = i; break end
	end
	place = math.max(1, math.min(n, place + sens))
	local a = affiches[place]
	choisi = a.hors or a.id
	Montrer(place)
	DessinerGrille()
	MajFiche()
end

local function CreerFiche(p, parent)
	local fiche = UI.Cadre(parent, C.carte, C.bord)
	fiche:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -MARGE, -4)
	fiche:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -MARGE, 12)
	fiche:SetWidth(LARGEUR_FICHE)
	fiche.vide = UI.Texte(fiche, "GameFontHighlight", C.gris)
	fiche.vide:SetPoint("TOPLEFT", fiche, "TOPLEFT", 14, -16)
	fiche.vide:SetWidth(LARGEUR_FICHE - 28)
	fiche.vide:SetWordWrap(true)
	fiche.vide:SetText("Clique sur un monstre pour ouvrir sa fiche.")
	local k = CreateFrame("Frame", nil, fiche)
	k:SetAllPoints(fiche)
	fiche.corps = k
	fiche.num = UI.Texte(k, "GameFontHighlightSmall", C.gris)
	fiche.num:SetPoint("TOPLEFT", k, "TOPLEFT", 14, -13)
	fiche.suiv = UI.Bouton(k, ">", "fantome", 24, 20)
	fiche.suiv:SetPoint("TOPRIGHT", k, "TOPRIGHT", -10, -8)
	fiche.suiv:SetScript("OnClick", function() Voisin(1) end)
	fiche.prec = UI.Bouton(k, "<", "fantome", 24, 20)
	fiche.prec:SetPoint("RIGHT", fiche.suiv, "LEFT", -4, 0)
	fiche.prec:SetScript("OnClick", function() Voisin(-1) end)
	fiche.nom = UI.Texte(k, "GameFontNormalLarge", C.ors)
	fiche.nom:SetPoint("TOPLEFT", k, "TOPLEFT", 14, -30)
	fiche.nom:SetPoint("RIGHT", k, "RIGHT", -14, 0)
	fiche.pilules = { Pilule(k), Pilule(k), Pilule(k) }
	-- scène : le modèle 3D tourne
	fiche.scene = UI.Cadre(k, C.champ, C.bord)
	fiche.scene:SetPoint("TOPLEFT", k, "TOPLEFT", 10, -76)
	fiche.scene:SetPoint("TOPRIGHT", k, "TOPRIGHT", -10, -76)
	fiche.scene:SetHeight(HAUT_SCENE)
	local okM, m = pcall(CreateFrame, "PlayerModel", nil, fiche.scene)
	if okM and m then
		m:SetPoint("TOPLEFT", fiche.scene, "TOPLEFT", 1, -1)
		m:SetPoint("BOTTOMRIGHT", fiche.scene, "BOTTOMRIGHT", -1, 1)
		fiche.modele = m
		local angle = 0
		fiche.scene:SetScript("OnUpdate", function(_, ecoule)
			angle = (angle + (ecoule or 0) * 0.6) % (2 * math.pi)
			pcall(m.SetFacing, m, angle)
		end)
	end
	local dessus = CreateFrame("Frame", nil, fiche.scene)
	dessus:SetAllPoints(fiche.scene)
	dessus:SetFrameLevel((fiche.scene:GetFrameLevel() or 1) + 4)
	fiche.mystere = UI.Texte(dessus, "GameFontNormalLarge", C.bordFort)
	fiche.mystere:SetPoint("CENTER", fiche.scene, "CENTER", 0, 0)
	fiche.mystere:SetText("?")
	fiche.bandeau = UI.Texte(dessus, "GameFontHighlightSmall", C.texte)
	fiche.bandeau:SetPoint("TOPLEFT", fiche.scene, "TOPLEFT", 7, -6)
	-- rare repéré il y a peu : le repère du jeu à l'endroit du repérage, et la carte
	fiche.yAller = UI.Bouton(dessus, "Y aller", "or", 66, 20)
	fiche.yAller:SetPoint("TOPRIGHT", fiche.scene, "TOPRIGHT", -5, -5)
	fiche.yAller:SetScript("OnClick", function(self)
		if self.point and ns.MontrerAppelSurCarte then ns.MontrerAppelSurCarte(self.point) end
	end)
	UI.Infobulle(fiche.yAller, "Y aller", "Pose un repère sur la carte là où ce rare vient d'être repéré, et ouvre la carte.")
	fiche.yAller:Hide()
	-- tableau : zone, vu, capturé, dépouillé, guilde, repéré, tué ; une infobulle explique chaque ligne
	fiche.rangs = {}
	for i = 1, 7 do
		local cle = UI.Texte(k, "GameFontHighlightSmall", C.gris)
		local val = UI.Texte(k, "GameFontHighlightSmall", C.texte)
		val:SetWidth(LARGEUR_FICHE - 20 - 78 - 6)
		val:SetWordWrap(true)
		val:SetSpacing(2)
		local survol = CreateFrame("Frame", nil, k)
		survol:SetPoint("TOPLEFT", cle, "TOPLEFT", 0, 2)
		survol:SetPoint("BOTTOMRIGHT", val, "BOTTOMRIGHT", 0, -2)
		survol:EnableMouse(true)
		survol:SetScript("OnEnter", function(self)
			if not self.aide then return end
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(self.titre or "")
			GameTooltip:AddLine(self.aide, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		survol:SetScript("OnLeave", function() GameTooltip:Hide() end)
		fiche.rangs[i] = { cle = cle, val = val, survol = survol }
	end
	fiche.titreButin = UI.Texte(k, "GameFontNormal", C.ors)
	fiche.lignes = {}
	for i = 1, LIGNES_BUTIN do
		local l = CreateFrame("Button", nil, k)
		l:SetHeight(20)
		l.icone = l:CreateTexture(nil, "ARTWORK")
		l.icone:SetSize(18, 18)
		l.icone:SetPoint("LEFT", l, "LEFT", 0, 0)
		l.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		l.taux = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.taux:SetPoint("RIGHT", l, "RIGHT", 0, 0)
		l.taux:SetJustifyH("RIGHT")
		l.nom = UI.Texte(l, "GameFontHighlightSmall", C.texte)
		l.nom:SetPoint("LEFT", l.icone, "RIGHT", 6, 0)
		l.nom:SetPoint("RIGHT", l.taux, "LEFT", -6, 0)
		UI.Survol(l, 0.06)
		l:SetScript("OnEnter", function(self)
			if not self.objet then return end
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			if GameTooltip.SetItemByID then pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
			else GameTooltip:SetHyperlink("item:" .. self.objet) end
			if self.aide then GameTooltip:AddLine(self.aide, 0.6, 0.6, 0.6, true) end
			GameTooltip:Show()
		end)
		l:SetScript("OnLeave", function() GameTooltip:Hide() end)
		l:SetScript("OnClick", function(self)
			if self.objet and IsModifiedClick and IsModifiedClick("CHATLINK") then
				local _, lien = ns.InfoObjet(self.objet)
				if lien and ChatEdit_InsertLink then ChatEdit_InsertLink(lien) end
			end
		end)
		fiche.lignes[i] = l
	end
	fiche.reste = UI.Texte(k, "GameFontHighlightSmall", C.gris)
	fiche.reste:SetWidth(LARGEUR_FICHE - 28)
	fiche.reste:SetWordWrap(true)
	-- actions
	fiche.pister = UI.Bouton(k, "Pister", "fantome", 104, 24)
	fiche.pister:SetPoint("BOTTOMLEFT", k, "BOTTOMLEFT", 10, 10)
	fiche.pister:SetScript("OnClick", function()
		local w = Moi()
		if not w or not choisi then return end
		if w.pistes[choisi] then
			w.pistes[choisi] = nil
		else
			local n = 0
			for _ in pairs(w.pistes) do n = n + 1 end
			if n >= MAX_PISTES then
				Message(("WoWdex : tu pistes déjà %d monstres. Retires-en un dans le carnet de chasse."):format(MAX_PISTES))
				return
			end
			w.pistes[choisi] = Maintenant()
		end
		if ns.MajPlaquesWowdex then ns.MajPlaquesWowdex() end
		p.Maj()
	end)
	fiche.carte = UI.Bouton(k, "Sur la carte", "fantome", 92, 24)
	fiche.carte:SetPoint("LEFT", fiche.pister, "RIGHT", 6, 0)
	fiche.carte:SetScript("OnClick", function(self)
		-- (les apparitions de sa première zone, et le dernier repérage s'il est sur la même carte)
		local premier = self.groupes and self.groupes[1]
		if ns.AfficherSurCarte and premier then
			local groupes = { premier }
			for i = 2, #self.groupes do
				if self.groupes[i].icone and self.groupes[i].carte == premier.carte then groupes[#groupes + 1] = self.groupes[i] end
			end
			ns.AfficherSurCarte(self.titre or "WoWdex", groupes)
		end
	end)
	fiche.lier = UI.Bouton(k, "Lier", "fantome", 72, 24)
	fiche.lier:SetPoint("LEFT", fiche.carte, "RIGHT", 6, 0)
	fiche.lier:SetScript("OnClick", function(self)
		if not self.lien then return end
		local boite = ChatEdit_GetActiveWindow and ChatEdit_GetActiveWindow()
		if boite and boite.Insert then
			boite:Insert(self.lien)
		elseif ChatFrame_OpenChat then
			ChatFrame_OpenChat(self.lien)
		end
	end)
	UI.Infobulle(fiche.lier, "Lier dans la discussion", "Écrit le nom, le rang, le niveau et la zone du monstre dans la zone de saisie.")
	return fiche
end

-- un taux de la base ForeverDB en texte court : « 100 % », « 8,4 % », « 0,3 % », « <0,1 % »
local function TexteTaux(t)
	if not t then return nil end
	if t >= 10 then return ("%d %%"):format(math.floor(t + 0.5)) end
	if t < 0.1 then return "<0,1 %" end
	local s = (("%.1f %%"):format(t)):gsub("%.", ",")
	return s
end
-- butin d'un monstre : objets observés (taux sur les corps fouillés, guilde ou moi), puis ceux du bestiaire
-- jamais vus tomber ; { objet, n, corps } du plus fréquent au plus rare
local function ButinAffiche(id)
	local k, objets, membres = TotauxButin(id)
	local liste, deja = {}, {}
	for o, n in pairs(objets) do
		liste[#liste + 1] = { objet = o, n = n, corps = k, membres = membres }
		deja[o] = true
	end
	-- (l'objet cherché d'abord, puis du plus fréquent au plus rare)
	local cherche = objetDe[id] and objetDe[id].objet
	table.sort(liste, function(a, b)
		if (a.objet == cherche) ~= (b.objet == cherche) then return a.objet == cherche end
		if a.n ~= b.n then return a.n > b.n end
		return a.objet < b.objet
	end)
	local f = Bestiaire().par[id]
	local base = {}
	for _, o in ipairs(f and ButinFiche(f) or {}) do
		if not deja[o] then
			if o == cherche then table.insert(base, 1, { objet = o }) else base[#base + 1] = { objet = o } end
		end
	end
	-- La base ForeverDB (dépendance optionnelle, GuildUp_Butin.lua) : le taux des objets que la guilde n'a pas
	-- encore vus tomber, et les objets que le bestiaire ne liste pas (il laisse de côté le butin commun).
	for _, x in ipairs(base) do deja[x.objet] = true end
	if ns.ButinBase then
		for _, x in ipairs(ns.ButinBase(id)) do
			if not deja[x.objet] then
				deja[x.objet] = true
				base[#base + 1] = { objet = x.objet, tauxBase = x.taux }
			end
		end
	end
	if ns.TauxBase then
		for _, x in ipairs(liste) do x.tauxBase = ns.TauxBase(id, x.objet) end
		for _, x in ipairs(base) do
			if x.tauxBase == nil then x.tauxBase = ns.TauxBase(id, x.objet) end
		end
	end
	-- (jamais vus par la guilde : l'objet cherché d'abord, puis le meilleur taux de la base)
	table.sort(base, function(a, b)
		if (a.objet == cherche) ~= (b.objet == cherche) then return a.objet == cherche end
		if (a.tauxBase == nil) ~= (b.tauxBase == nil) then return b.tauxBase == nil end
		if a.tauxBase and b.tauxBase and a.tauxBase ~= b.tauxBase then return a.tauxBase > b.tauxBase end
		return a.objet < b.objet
	end)
	if cherche and not deja[cherche] then
		for _, x in ipairs(base) do table.insert(liste, 1, x) end -- (pas encore trouvé : en tête quand même)
	else
		for _, x in ipairs(base) do liste[#liste + 1] = x end
	end
	return liste, k, membres
end

-- Pour l'Encyclopédie (GuildUp_Carnet.lua) : les monstres où la guilde (ou moi) a trouvé cet objet, du meilleur taux
-- au plus faible : { { id, nom, rang, zone, n = corps qui l'ont lâché, k = corps fouillés, membres }, … }
ns.SourcesWowdex = function(objet)
	objet = tonumber(objet)
	if not objet then return {} end
	local res, vus = {}, {}
	local function Essayer(id)
		if vus[id] then return end
		vus[id] = true
		local k, o, membres = TotauxButin(id)
		if k > 0 and (o[objet] or 0) > 0 then
			local f = Bestiaire().par[id]
			local e = Entree(id)
			res[#res + 1] = { id = id, nom = NomMonstre(id), rang = f and f.rang or (e and e.r) or 0,
				zone = f and NomZone(f.zone) or (e and e.z), n = o[objet], k = k, membres = membres }
		end
	end
	local w = Moi()
	for id, e in pairs(w and w.m or {}) do
		if type(e.b) == "table" and e.b[objet] then Essayer(id) end
	end
	local g = Guilde()
	for id, parPnj in pairs(g and g.butin or {}) do
		for _, r in pairs(parPnj) do
			if r.o and r.o[objet] then Essayer(id); break end
		end
	end
	table.sort(res, function(a, b)
		local ta, tb = a.n / a.k, b.n / b.k
		if ta ~= tb then return ta > tb end
		return a.k > b.k
	end)
	return res
end

MajFiche = function()
	local fiche = page and page.fiche
	if not fiche then return end
	local id = choisi
	local b = Bestiaire()
	local f = id and b.par[id]
	local e = id and Entree(id)
	if not id or not (f or (e and e.n)) then
		fiche.corps:Hide()
		fiche.vide:Show()
		return
	end
	fiche.vide:Hide()
	fiche.corps:Show()
	local connu = Connu(id) or (e and e.n ~= nil) or false
	local rang = f and f.rang or (e and e.r) or 0
	local cr = COULEURS_RANGS[rang] or COULEURS_RANGS[0]
	local nom = connu and NomMonstre(id) or "???"
	local p = Palier(e)
	local w = Moi()
	local piste = w and w.pistes[id] and true or false
	fiche.num:SetText(f and ("n° %04d"):format(f.num) or "Hors liste")
	fiche.nom:SetText(nom)
	fiche.nom:SetTextColor(cr[1], cr[2], cr[3])
	-- pilules : rang, niveau, type de créature
	local niveau = f and NiveauTexte(f.min, f.max) or (e and NiveauTexte(e.l))
	local x = 0
	local function Pil(i, texte, couleur)
		local pil = fiche.pilules[i]
		local l = pil:Ecrire(texte, couleur)
		if l > 0 then
			pil:ClearAllPoints()
			pil:SetPoint("TOPLEFT", fiche.corps, "TOPLEFT", 14 + x, -52)
			x = x + l + 5
		end
	end
	Pil(1, NOMS_RANGS[rang] or "Normal", rang > 0 and cr or C.gris)
	Pil(2, niveau and ("Niveau " .. niveau) or nil, C.texte)
	Pil(3, e and e.ty or nil, C.texte)
	-- modèle : seulement pour un monstre connu, rechargé quand la fiche change de monstre
	local cle = id .. (connu and ":1" or ":0")
	if fiche.cleModele ~= cle then
		fiche.cleModele = cle
		local montre = connu and PoserModele(fiche.modele, id) or false
		if fiche.modele then fiche.modele:SetShown(montre) end
		fiche.mystere:SetShown(not montre)
	end
	if fiche.modele then pcall(fiche.modele.SetAlpha, fiche.modele, p >= 2 and 1 or 0.55) end
	local rare = RARES[rang]
	if rare and p < 2 then
		fiche.scene:SetBackdropBorderColor(cr[1] * 0.6, cr[2] * 0.6, cr[3] * 0.6, 1)
	else
		fiche.scene:SetBackdropBorderColor(unpack(C.bord))
	end
	local marques = {}
	if rare then marques[#marques + 1] = (p >= 2) and (VERT .. NOMS_RANGS[rang] .. " capturé|r") or (Couleur(cr) .. NOMS_RANGS[rang] .. " à capturer|r") end
	if piste then marques[#marques + 1] = OR .. "Pisté|r" end
	fiche.bandeau:SetText(table.concat(marques, GRIS .. " · |r"))
	-- tableau
	local y = 0
	local n = 0
	local function Rang(cle2, valeur)
		if not valeur then return end
		n = n + 1
		local r = fiche.rangs[n]
		if not r then return end
		r.cle:SetText(cle2)
		r.val:SetText(valeur)
		r.cle:ClearAllPoints()
		r.cle:SetPoint("TOPLEFT", fiche.scene, "BOTTOMLEFT", 4, -10 - y)
		r.val:ClearAllPoints()
		r.val:SetPoint("TOPLEFT", fiche.scene, "BOTTOMLEFT", 82, -10 - y)
		r.cle:Show()
		r.val:Show()
		r.survol.titre, r.survol.aide = cle2, AIDES[cle2]
		r.survol:SetShown(AIDES[cle2] ~= nil)
		y = y + math.max(11, tonumber(r.val:GetStringHeight()) or 11) + 5
	end
	local zones = {}
	for _, z in ipairs(f and ZonesFiche(f) or {}) do zones[#zones + 1] = NomZone(z.zone) end
	if #zones == 0 and e and e.z then zones[1] = e.z end
	local proche = Distance.Texte(Distance.Monstre(f))
	Rang("Zone", #zones > 0 and (table.concat(zones, ", ") .. (proche and (GRIS .. " · à " .. proche .. "|r") or "")) or nil)
	Rang("Vu", (p >= 1 and e.v) and ("le " .. date("%d/%m/%Y", e.v)) or (GRIS .. "pas encore|r"))
	Rang("Capturé", p >= 2 and (VERT .. "×" .. (e.k or 0) .. "|r" .. (e.tk and (GRIS .. " · le " .. date("%d/%m/%Y", e.tk) .. "|r") or ""))
		or (GRIS .. "pas encore|r"))
	Rang("Dépouillé", p >= 3 and (OR .. "×" .. (e.d or 0) .. "|r" .. GRIS .. " corps|r") or (GRIS .. "pas encore|r"))
	local g = Guilde()
	local d = g and g.d[id]
	if d then
		Rang("Guilde", "première capture par " .. NomJoueur(d.c) .. GRIS .. ", le " .. DateJour(d.j) .. "|r")
	elseif g then
		Rang("Guilde", GRIS .. "personne ne l'a encore capturé|r")
	end
	local quand, qui, rep = Reperage(id)
	local ici = rep and rep.carte and rep.x and rep.y and true or false
	if quand then
		local loin = ici and Distance.Texte(Distance.A(rep.carte, rep.x, rep.y))
		Rang("Repéré", OR .. quand .. "|r" .. (qui and (" par " .. qui) or "") .. (loin and (GRIS .. " · à " .. loin .. "|r") or ""))
	end
	local mortQuand, mortQui = DerniereMort(id)
	if mortQuand then Rang("Tué", mortQuand .. (mortQui and (" par " .. mortQui) or "")) end
	for i = n + 1, #fiche.rangs do
		fiche.rangs[i].cle:Hide()
		fiche.rangs[i].val:Hide()
		fiche.rangs[i].survol:Hide()
	end
	-- « Y aller » : un repérage de moins d'une heure, dont la position est connue
	local frais = ici and (Maintenant() - rep.t <= 3600)
	fiche.yAller.point = frais and { carte = rep.carte, x = rep.x, y = rep.y } or nil
	fiche.yAller:SetShown(frais)
	-- butin : autant de lignes que la place le permet
	local liste, corps, membres = ButinAffiche(id)
	local haut = tonumber(fiche:GetHeight()) or 0
	if haut < 200 then haut = HauteurPage() + HAUT_VUES - 16 end
	local places = math.floor((haut - 76 - HAUT_SCENE - 10 - y - 10 - 20 - 20 - 44) / 21)
	places = math.max(1, math.min(LIGNES_BUTIN, places))
	fiche.titreButin:ClearAllPoints()
	fiche.titreButin:SetPoint("TOPLEFT", fiche.scene, "BOTTOMLEFT", 4, -18 - y)
	fiche.titreButin:SetText("Butin" .. (corps > 0 and (GRIS .. ("  %d corps fouillé%s par %d membre%s"):format(corps,
		corps > 1 and "s" or "", membres, membres > 1 and "s" or "") .. "|r") or ""))
	local yb = 0
	for i, l in ipairs(fiche.lignes) do
		local o = (i <= places) and liste[i] or nil
		if o then
			local nomO, _, qualite, icone = ns.InfoObjet(o.objet)
			if not nomO and ns.Precharger then ns.Precharger(o.objet) end
			l.objet = o.objet
			l.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
			local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
			l.nom:SetText(((qc and qc.hex) or "|cffffffff") .. (nomO or ("objet n° " .. o.objet)) .. "|r")
			local deLaBase = TexteTaux(o.tauxBase)
			if o.n then
				l.taux:SetText(("%d %%"):format(math.floor(100 * o.n / math.max(1, o.corps) + 0.5)))
				l.aide = ("Tombé sur %d des %d corps fouillés par la guilde (%d membre%s)."):format(o.n, o.corps,
					o.membres or 1, (o.membres or 1) > 1 and "s" or "")
					.. (deLaBase and ("|nLa base ForeverDB donne " .. deLaBase .. ".") or "")
			elseif deLaBase then
				l.taux:SetText(GRIS .. deLaBase .. "|r")
				l.aide = "Taux de la base ForeverDB. La guilde ne l'a pas encore vu tomber : dès qu'elle aura fouillé "
					.. "assez de corps, son propre taux prendra la place."
			else
				l.taux:SetText(GRIS .. "jamais vu|r")
				l.aide = "Peut tomber sur ce monstre (bestiaire), pas encore trouvé par la guilde."
			end
			l:ClearAllPoints()
			l:SetPoint("TOPLEFT", fiche.titreButin, "BOTTOMLEFT", 0, -6 - yb)
			l:SetPoint("RIGHT", fiche, "RIGHT", -14, 0)
			l:Show()
			yb = yb + 21
		else
			l:Hide()
			l.objet = nil
		end
	end
	fiche.reste:ClearAllPoints()
	fiche.reste:SetPoint("TOPLEFT", fiche.titreButin, "BOTTOMLEFT", 0, -8 - yb)
	if #liste > places then
		fiche.reste:SetText(("et %d autre%s"):format(#liste - places, #liste - places > 1 and "s objets" or " objet"))
	elseif #liste == 0 then
		fiche.reste:SetText("Rien de particulier : le butin commun (étoffes, objets gris) apparaîtra ici quand la guilde l'aura fouillé.")
	else
		fiche.reste:SetText("")
	end
	-- actions
	if p >= 2 then
		fiche.pister:Ecrire("Capturé")
		fiche.pister:Activer(false)
	else
		fiche.pister:Ecrire(piste and "Ne plus pister" or "Pister")
		fiche.pister:Activer(true)
	end
	fiche.pister:SetBackdropColor(unpack(piste and C.actif or C.voile))
	local groupes = {}
	for _, z in ipairs(f and ZonesFiche(f) or {}) do
		local info = b.zones[z.zone]
		if info and info.carte and #z.points > 0 then
			groupes[#groupes + 1] = { carte = info.carte, points = z.points, couleur = { 0.95, 0.35, 0.25 } }
		end
	end
	if frais then
		local repere = { carte = rep.carte, points = { { rep.x * 100, rep.y * 100 } },
			icone = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8" }
		-- (sans apparition connue : le repérage seul, sur sa carte)
		if #groupes == 0 then groupes[1] = repere else groupes[#groupes + 1] = repere end
	end
	fiche.carte.groupes = groupes
	fiche.carte.titre = "WoWdex : " .. nom .. " — " .. (NomZone(f and f.zone) or "")
	fiche.carte:Activer(#groupes > 0)
	local quoi = {}
	if rang > 0 then quoi[#quoi + 1] = NOMS_RANGS[rang] end
	if niveau then quoi[#quoi + 1] = "niveau " .. niveau end
	if zones[1] then quoi[#quoi + 1] = zones[1] end
	fiche.lier.lien = "WoWdex " .. (f and ("n°%04d "):format(f.num) or "") .. nom .. (#quoi > 0 and (" (" .. table.concat(quoi, ", ") .. ")") or "")
end

--------------------------------------------------------------------------------
-- Vue « Avis de recherche » et « Bestiaire » : recherche, puces, grille, fiche
--------------------------------------------------------------------------------

local function CreerVueGrille(p)
	local v = CreateFrame("Frame", nil, p)
	v:SetPoint("TOPLEFT", p, "TOPLEFT", 0, HAUT_VUES)
	v:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
	v.recherche = UI.Champ(v, 140, "Monstre, zone, objet…")
	v.recherche:SetPoint("TOPLEFT", v, "TOPLEFT", MARGE, -4)
	v.recherche.SurTexte = function(t)
		etat.recherche = Simplifier(strtrim(t or ""))
		etat.ligne = 0
		MajBientot()
	end
	v.recherche.saisie:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
		etat.recherche = ""
		etat.ligne = 0
		MajBientot()
	end)
	v.puces = {}
	for i, noms in ipairs(FILTRES) do
		local pu = UI.Puces(v, noms, function(j)
			etat.filtres[i] = j
			etat.ligne = 0
			p.Maj()
		end)
		pu:SetPoint("LEFT", v.recherche, "RIGHT", 8, 0)
		v.puces[i] = pu
	end
	p.fiche = CreerFiche(p, v)
	p.grille = CreerGrille(v)
	p.grille:SetPoint("TOPLEFT", v, "TOPLEFT", MARGE, -40)
	v.vide = UI.Texte(v, "GameFontHighlight", C.gris)
	v.vide:SetPoint("TOPLEFT", p.grille, "TOPLEFT", 4, -8)
	v.vide:SetWidth(p.grille.largeur - 8)
	v.vide:SetWordWrap(true)
	v.Maj = function()
		local i = (etat.onglet == 1) and 1 or 2
		for j, pu in ipairs(v.puces) do pu:SetShown(j == i) end
		v.puces[i]:Choisir(etat.filtres[i])
		Construire()
		-- une fiche toujours ouverte : à défaut, le premier monstre de la liste
		local present = false
		for _, a in ipairs(affiches) do
			if (a.hors or a.id) == choisi then present = true; break end
		end
		if not present and affiches[1] then choisi = affiches[1].hors or affiches[1].id end
		DessinerGrille()
		v.vide:SetShown(#affiches == 0)
		if #affiches == 0 then
			if etat.recherche ~= "" then
				v.vide:SetText(etat.onglet == 1 and "Aucun rare ne correspond à ta recherche. L'onglet Bestiaire cherche parmi tous les monstres."
					or "Aucun monstre ne correspond à ta recherche (les monstres inconnus se cherchent par leur zone).")
			else
				v.vide:SetText(etat.onglet == 1 and "Aucun rare ni boss ici." or "Aucun monstre ici.")
			end
		end
		MajFiche()
	end
	return v
end

--------------------------------------------------------------------------------
-- Vue « Zones » : un WoWdex par zone, ses rares d'abord
--------------------------------------------------------------------------------

-- ouvre la grille sur une zone (ses rares s'il y en a, sinon tous ses monstres)
local function OuvrirZone(z, rares)
	etat.zone = z
	etat.onglet = rares and 1 or 2
	etat.filtres[etat.onglet] = 1
	etat.ligne = 0
	if page then page.Maj() end
end

local function CreerRangeeZone(parent, largeur)
	local r = UI.Rangee(parent, 36)
	r.nom = UI.Texte(r, "GameFontHighlight", C.texte)
	r.nom:SetPoint("LEFT", r, "LEFT", 12, 0)
	r.nom:SetWidth(210)
	r.rares = UI.Texte(r, "GameFontHighlightSmall", COULEUR_RARE)
	r.rares:SetPoint("LEFT", r, "LEFT", 232, 0)
	r.rares:SetWidth(150)
	r.barre = Barre(r, math.max(160, largeur - 392 - 96), 8)
	r.barre:SetPoint("LEFT", r, "LEFT", 392, 0)
	r.compte = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.compte:SetPoint("RIGHT", r, "RIGHT", -12, 0)
	r.compte:SetJustifyH("RIGHT")
	r:SetScript("OnClick", function(self)
		if self.zone then OuvrirZone(self.zone, self.aDesRares) end
	end)
	UI.SonClic(r)
	return r
end

local function CreerVueZones(p)
	local v = CreateFrame("Frame", nil, p)
	v:SetPoint("TOPLEFT", p, "TOPLEFT", 0, HAUT_VUES)
	v:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
	local largeur = LargeurPage() - 2 * MARGE
	v.ici = UI.Carte(v, "Tu es ici")
	v.ici:SetPoint("TOPLEFT", v, "TOPLEFT", MARGE, -4)
	v.ici:SetSize(largeur, 88)
	v.ici.texte = UI.Texte(v.ici, "GameFontHighlightSmall", C.texte)
	v.ici.texte:SetPoint("TOPLEFT", v.ici, "TOPLEFT", 14, -36)
	v.ici.texte:SetWidth(largeur - 28 - 150)
	v.ici.texte:SetWordWrap(true)
	v.ici.texte:SetSpacing(4)
	v.ici.voir = UI.Bouton(v.ici, "Voir ses rares", "or", 130, 26)
	v.ici.voir:SetPoint("RIGHT", v.ici, "RIGHT", -14, 0)
	v.ici.voir:SetScript("OnClick", function() OuvrirZone("ici", true) end)
	v.puces = UI.Puces(v, { "Toutes", "Rares à capturer", "Rares complets" }, function(i)
		etat.filtreZones = i
		v.liste:Haut()
		p.Maj()
	end)
	v.puces:SetPoint("TOPLEFT", v.ici, "BOTTOMLEFT", 0, -8)
	v.legende = UI.Texte(v, "GameFontHighlightSmall", C.gris)
	v.legende:SetPoint("TOPRIGHT", v.ici, "BOTTOMRIGHT", 0, -15)
	v.legende:SetJustifyH("RIGHT")
	v.legende:SetText("Barre : tes captures · trait clair : la guilde")
	v.liste = UI.Liste(v)
	v.liste:SetPoint("TOPLEFT", v.puces, "BOTTOMLEFT", 0, -8)
	v.liste:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", -MARGE, 12)
	v.rangees = {}
	v.vide = UI.Texte(v, "GameFontHighlight", C.gris)
	v.vide:SetPoint("TOPLEFT", v.liste, "TOPLEFT", 4, -8)
	v.Maj = function()
		local b = Bestiaire()
		local st = StatsZones()
		-- tu es ici
		local mesZones = ZonesDeMaCarte()
		local noms = {}
		for z in pairs(mesZones) do noms[#noms + 1] = b.zones[z] and b.zones[z].nom or nil end
		table.sort(noms)
		local ici = Recensement(mesZones)
		if ici.n > 0 then
			v.ici.titre:SetText("Tu es ici : " .. table.concat(noms, ", "))
			local lignes = {}
			if #ici.rares > 0 then
				-- (ceux dont je connais le nom, puis le nombre des autres)
				local manque, inconnus = {}, 0
				for _, f in ipairs(ici.rares) do
					if Palier(Entree(f.id)) < 2 then
						if Connu(f.id) then
							manque[#manque + 1] = Couleur(COULEURS_RANGS[f.rang] or COULEUR_RARE) .. f.nom .. "|r"
						else
							inconnus = inconnus + 1
						end
					end
				end
				if inconnus > 0 then manque[#manque + 1] = inconnus .. (inconnus > 1 and " inconnus" or " inconnu") end
				lignes[#lignes + 1] = ("%sRares et boss : %d sur %d|r"):format(BLEU, ici.raresK, #ici.rares)
					.. (#manque > 0 and (GRIS .. " · à capturer : |r" .. table.concat(manque, GRIS .. ", |r")) or (VERT .. " · tous capturés !|r"))
			else
				lignes[#lignes + 1] = GRIS .. "Pas de rare ni de boss au bestiaire pour cette carte.|r"
			end
			lignes[#lignes + 1] = ("Monstres : %s%d|r sur %d%s"):format(VERT, ici.k, ici.n,
				Guilde() and (GRIS .. (" · guilde : %d"):format(ici.g) .. "|r") or "")
			v.ici.texte:SetText(table.concat(lignes, "\n"))
			v.ici.voir:SetShown(#ici.rares > 0)
		else
			v.ici.titre:SetText("Tu es ici")
			v.ici.texte:SetText(GRIS .. "Le bestiaire n'a pas de monstre pour la carte où tu te trouves.|r")
			v.ici.voir:Hide()
		end
		-- les zones : la mienne d'abord, puis par nom
		v.puces:Choisir(etat.filtreZones)
		local liste = {}
		for z, s in pairs(st) do
			local info = b.zones[z]
			local garde = info and info.nom and info.nom ~= ""
			if etat.filtreZones == 2 and not (s.rares > s.raresK) then garde = false end
			if etat.filtreZones == 3 and not (s.rares > 0 and s.raresK >= s.rares) then garde = false end
			if garde then liste[#liste + 1] = { z = z, nom = info.nom, cle = Simplifier(info.nom), s = s, ici = mesZones[z] or false } end
		end
		table.sort(liste, function(x, y)
			if x.ici ~= y.ici then return x.ici end
			if x.cle ~= y.cle then return x.cle < y.cle end
			return x.z < y.z
		end)
		local largeurListe = largeur - 8
		for i, x in ipairs(liste) do
			local r = v.rangees[i]
			if not r then
				r = CreerRangeeZone(v.liste.contenu, largeurListe)
				r:SetPoint("TOPLEFT", v.liste.contenu, "TOPLEFT", 0, -(i - 1) * 40)
				r:SetPoint("RIGHT", v.liste.contenu, "RIGHT", 0, 0)
				v.rangees[i] = r
			end
			local s = x.s
			r.zone, r.aDesRares = x.z, s.rares > 0
			r.nom:SetText(x.nom)
			r.nom:SetTextColor(unpack(x.ici and C.ors or C.texte))
			if s.rares == 0 then
				r.rares:SetText(GRIS .. "pas de rare|r")
			elseif s.raresK >= s.rares then
				r.rares:SetText(OR .. ("Rares %d / %d · complets"):format(s.raresK, s.rares) .. "|r")
			else
				r.rares:SetText(("Rares %d / %d"):format(s.raresK, s.rares))
			end
			local complet = s.k >= s.n
			r.barre:Poser(s.n > 0 and s.k / s.n or 0, complet and C.ors or C.orFonce, Guilde() and s.n > 0 and s.g / s.n or nil)
			r.compte:SetText((complet and OR or "") .. s.k .. " / " .. s.n .. (complet and "|r" or ""))
			r:Fort(x.ici)
			r:Show()
		end
		for i = #liste + 1, #v.rangees do v.rangees[i]:Hide() end
		v.liste:Hauteur(#liste * 40)
		v.vide:SetShown(#liste == 0)
		v.vide:SetText(etat.filtreZones == 3 and "Aucune zone dont tu as capturé tous les rares, pour l'instant." or "Aucune zone ici.")
	end
	return v
end

--------------------------------------------------------------------------------
-- Vue « Carnet de chasse » : titre, progression, monstres pistés, dernières captures, réglages
--------------------------------------------------------------------------------

-- ligne cliquable d'une carte : texte à gauche, précision à droite ; ouvre la fiche du monstre
local function LigneMonstre(carte, i, largeur)
	local l = CreateFrame("Button", nil, carte)
	l:SetSize(largeur - 24, 18)
	l:SetPoint("TOPLEFT", carte, "TOPLEFT", 12, -34 - (i - 1) * 19)
	l.droite = UI.Texte(l, "GameFontHighlightSmall", C.gris)
	l.droite:SetPoint("RIGHT", l, "RIGHT", -2, 0)
	l.droite:SetJustifyH("RIGHT")
	l.texte = UI.Texte(l, "GameFontHighlightSmall", C.texte)
	l.texte:SetPoint("LEFT", l, "LEFT", 2, 0)
	l.texte:SetPoint("RIGHT", l.droite, "LEFT", -8, 0)
	UI.Survol(l, 0.06)
	l:SetScript("OnClick", function(self)
		if self.id and page then page.Ouvrir(self.id) end
	end)
	UI.SonClic(l)
	return l
end

-- ligne de progression : nom, barre, « 12 / 244 »
local function LigneBarre(carte, i, largeur, pas)
	local l = {}
	local y = -36 - (i - 1) * pas
	l.nom = UI.Texte(carte, "GameFontHighlightSmall", C.texte)
	l.nom:SetPoint("TOPLEFT", carte, "TOPLEFT", 14, y)
	l.nom:SetWidth(78)
	l.barre = Barre(carte, largeur - 14 - 82 - 86, 8)
	l.barre:SetPoint("TOPLEFT", carte, "TOPLEFT", 14 + 82, y - 2)
	l.compte = UI.Texte(carte, "GameFontHighlightSmall", C.gris)
	l.compte:SetPoint("TOPRIGHT", carte, "TOPRIGHT", -14, y)
	l.compte:SetJustifyH("RIGHT")
	return l
end

local function CreerVueCarnet(p)
	local v = CreateFrame("Frame", nil, p)
	v:SetPoint("TOPLEFT", p, "TOPLEFT", 0, HAUT_VUES)
	v:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
	local largeur = LargeurPage() - 2 * MARGE
	local lg = math.floor((largeur - 10) / 2)
	local ld = largeur - 10 - lg
	-- hauteurs : celles d'une page de 586 de haut, plus la place en plus répartie entre les cartes
	local haut = HauteurPage() + HAUT_VUES - 4 - 12
	local sup = math.max(0, haut - 452)
	local hTitre, pasTitre = 196 + math.floor(sup * 0.4), 14 + math.floor(sup * 0.4 / #TITRES)
	local hNiveaux, pasNiveaux = 152 + math.floor(sup * 0.35), 16 + math.floor(sup * 0.35 / #TRANCHES)
	local hRangs, pasRangs = 130 + math.floor(sup * 0.2), 18 + math.floor(sup * 0.2 / #ORDRE_RANGS)
	local hListe = math.floor((haut - hRangs - 20) / 2)
	local nListe = math.max(3, math.floor((hListe - 34) / 19))
	-- colonne de gauche : titre, progression par niveau, réglages
	v.titre = UI.Carte(v, "Titre de chasseur")
	v.titre:SetPoint("TOPLEFT", v, "TOPLEFT", MARGE, -4)
	v.titre:SetSize(lg, hTitre)
	v.titre.nom = UI.Texte(v.titre, "GameFontNormalLarge", C.ors)
	v.titre.nom:SetPoint("TOPLEFT", v.titre, "TOPLEFT", 14, -34)
	v.titre.detail = UI.Texte(v.titre, "GameFontHighlightSmall", C.gris)
	v.titre.detail:SetPoint("TOPLEFT", v.titre.nom, "BOTTOMLEFT", 0, -4)
	v.titre.echelle = {}
	for i = 1, #TITRES do
		local nom = UI.Texte(v.titre, "GameFontHighlightSmall", C.gris)
		nom:SetPoint("TOPLEFT", v.titre, "TOPLEFT", 14, -76 - (i - 1) * pasTitre)
		local seuil = UI.Texte(v.titre, "GameFontHighlightSmall", C.gris)
		seuil:SetPoint("TOPRIGHT", v.titre, "TOPRIGHT", -14, -76 - (i - 1) * pasTitre)
		seuil:SetJustifyH("RIGHT")
		v.titre.echelle[i] = { nom = nom, seuil = seuil }
	end
	v.niveaux = UI.Carte(v, "Par niveau")
	v.niveaux:SetPoint("TOPLEFT", v.titre, "BOTTOMLEFT", 0, -10)
	v.niveaux:SetSize(lg, hNiveaux)
	v.niveaux.lignes = {}
	for i = 1, #TRANCHES do v.niveaux.lignes[i] = LigneBarre(v.niveaux, i, lg, pasNiveaux) end
	v.reglages = UI.Carte(v, "Alertes")
	v.reglages:SetPoint("TOPLEFT", v.niveaux, "BOTTOMLEFT", 0, -10)
	v.reglages:SetSize(lg, math.max(86, haut - hTitre - hNiveaux - 20))
	v.alertes = UI.Case(v.reglages, "Alerte quand un rare à capturer est en vue", function(oui)
		local w = Moi()
		if w then w.alertes = oui and true or false end
	end)
	v.alertes:SetPoint("TOPLEFT", v.reglages, "TOPLEFT", 14, -32)
	v.plaques = UI.Case(v.reglages, "Losange sur la barre de nom des rares à capturer", function(oui)
		local w = Moi()
		if w then w.plaques = oui and true or false end
		if ns.MajPlaquesWowdex then ns.MajPlaquesWowdex() end
	end)
	v.plaques:SetPoint("TOPLEFT", v.reglages, "TOPLEFT", 14, -56)
	-- colonne de droite : progression par rang, monstres pistés, dernières captures
	v.rangs = UI.Carte(v, "Par rang")
	v.rangs:SetPoint("TOPLEFT", v.titre, "TOPRIGHT", 10, 0)
	v.rangs:SetSize(ld, hRangs)
	v.rangs.lignes = {}
	for i = 1, #ORDRE_RANGS do v.rangs.lignes[i] = LigneBarre(v.rangs, i, ld, pasRangs) end
	v.pistes = UI.Carte(v, "À pister")
	v.pistes:SetPoint("TOPLEFT", v.rangs, "BOTTOMLEFT", 0, -10)
	v.pistes:SetSize(ld, hListe)
	v.pistes.lignes = {}
	for i = 1, nListe do v.pistes.lignes[i] = LigneMonstre(v.pistes, i, ld) end
	v.captures = UI.Carte(v, "Dernières captures")
	v.captures:SetPoint("TOPLEFT", v.pistes, "BOTTOMLEFT", 0, -10)
	v.captures:SetSize(ld, haut - hRangs - 20 - hListe)
	v.captures.lignes = {}
	for i = 1, nListe do v.captures.lignes[i] = LigneMonstre(v.captures, i, ld) end

	local function NomColore(id)
		local f = Bestiaire().par[id]
		local e = Entree(id)
		local rang = f and f.rang or (e and e.r) or 0
		local nom = (Connu(id) or (e and e.n)) and NomMonstre(id) or "???"
		return (f and (GRIS .. ("%04d|r "):format(f.num)) or "") .. Couleur(COULEURS_RANGS[rang] or COULEURS_RANGS[0]) .. nom .. "|r", f
	end

	v.Maj = function()
		local b = Bestiaire()
		local s = MonScore()
		local w = Moi()
		-- titre et échelle
		local rang, nomTitre, suivant = Titre(s.r)
		v.titre.nom:SetText(nomTitre)
		v.titre.detail:SetText(("%d rare%s et boss capturé%s sur %d"):format(s.r, s.r > 1 and "s" or "", s.r > 1 and "s" or "", b.rares)
			.. (suivant and (" · encore %d pour « %s »"):format(math.max(0, suivant - s.r), TITRES[rang + 1][2]) or ""))
		for i, l in ipairs(v.titre.echelle) do
			local c = (i == rang) and C.ors or (i < rang and C.texte or C.gris)
			l.nom:SetText(((i == rang) and "› " or "   ") .. TITRES[i][2])
			l.nom:SetTextColor(c[1], c[2], c[3])
			l.seuil:SetText(tostring(SeuilTitre(i) or 0))
			l.seuil:SetTextColor(c[1], c[2], c[3])
		end
		-- progression par rang et par niveau
		local parRang, parNiveau = {}, {}
		for i = 1, #TRANCHES do parNiveau[i] = { n = 0, k = 0 } end
		for _, f in ipairs(b.liste) do
			local pris = w and Palier(w.m[f.id]) >= 2 or false
			local r = parRang[f.rang]
			if not r then r = { n = 0, k = 0 }; parRang[f.rang] = r end
			r.n = r.n + 1
			if pris then r.k = r.k + 1 end
			for i, t in ipairs(TRANCHES) do
				if f.min >= t[1] and f.min <= t[2] then
					parNiveau[i].n = parNiveau[i].n + 1
					if pris then parNiveau[i].k = parNiveau[i].k + 1 end
					break
				end
			end
		end
		for i, rg in ipairs(ORDRE_RANGS) do
			local l = v.rangs.lignes[i]
			local x = parRang[rg] or { n = 0, k = 0 }
			local c = COULEURS_RANGS[rg] or COULEURS_RANGS[0]
			l.nom:SetText(NOMS_RANGS[rg])
			l.nom:SetTextColor(c[1], c[2], c[3])
			l.barre:Poser(x.n > 0 and x.k / x.n or 0, rg == 0 and C.orFonce or c)
			l.compte:SetText(x.k .. " / " .. x.n)
		end
		for i, t in ipairs(TRANCHES) do
			local l = v.niveaux.lignes[i]
			local x = parNiveau[i]
			l.nom:SetText(t[2] > 100 and (t[1] .. " et plus") or (t[1] .. " à " .. t[2]))
			l.barre:Poser(x.n > 0 and x.k / x.n or 0)
			l.compte:SetText(x.k .. " / " .. x.n)
		end
		-- monstres pistés (les plus récents d'abord)
		local pistes = {}
		for id, t in pairs(w and w.pistes or {}) do pistes[#pistes + 1] = { id = id, t = tonumber(t) or 0 } end
		table.sort(pistes, function(x, y) if x.t ~= y.t then return x.t > y.t end return x.id < y.id end)
		for i, l in ipairs(v.pistes.lignes) do
			local x = pistes[i]
			if x then
				local texte, f = NomColore(x.id)
				local e = Entree(x.id)
				l.id = x.id
				l.texte:SetText(texte)
				local loin = f and Distance.Texte(Distance.Monstre(f))
				l.droite:SetText(((f and NomZone(f.zone)) or (e and e.z) or "") .. (loin and (" · " .. loin) or ""))
				l:Show()
			else
				l:Hide()
			end
		end
		v.pistes.compte:SetText(#pistes > 0 and (#pistes .. " / " .. MAX_PISTES) or "")
		v.pistes.vide:SetText(#pistes == 0 and "Rien à pister. Ouvre la fiche d'un monstre et clique sur « Pister » : une alerte te préviendra quand il sera en vue." or "")
		-- dernières captures
		local captures = {}
		for id, e in pairs(w and w.m or {}) do
			if (e.k or 0) > 0 and e.tk then captures[#captures + 1] = { id = id, t = e.tk } end
		end
		table.sort(captures, function(x, y) if x.t ~= y.t then return x.t > y.t end return x.id < y.id end)
		for i, l in ipairs(v.captures.lignes) do
			local x = captures[i]
			if x then
				l.id = x.id
				l.texte:SetText((NomColore(x.id)))
				l.droite:SetText(IlYa(x.t))
				l:Show()
			else
				l:Hide()
			end
		end
		v.captures.compte:SetText(s.hors > 0 and (s.hors .. " hors liste") or "")
		v.captures.vide:SetText(#captures == 0 and "Pas encore de capture : vaincs un monstre, seul ou en groupe." or "")
		v.alertes:Poser(not w or w.alertes ~= false)
		v.plaques:Poser(not w or w.plaques ~= false)
	end
	return v
end

--------------------------------------------------------------------------------
-- Vue « Guilde » : le WoWdex commun, le classement par rares, les premières captures de rares
--------------------------------------------------------------------------------

local COLONNES = { { "Rares", 250 }, { "Capturés", 322 }, { "Dépouillés", 396 }, { "Premières", 466 } }

local function CreerVueGuilde(p)
	local v = CreateFrame("Frame", nil, p)
	v:SetPoint("TOPLEFT", p, "TOPLEFT", 0, HAUT_VUES)
	v:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
	local largeur = LargeurPage() - 2 * MARGE
	local lg = 480
	local ld = largeur - 10 - lg
	-- (hauteur de la vue, moins le résumé et les marges)
	local hauteur = HauteurPage() + HAUT_VUES - 4 - 62 - 10 - 12
	local nLignes = math.max(8, math.floor((hauteur - 62) / 23)) -- lignes du classement et des premières
	v.resume = UI.Carte(v, "WoWdex de la guilde")
	v.resume:SetPoint("TOPLEFT", v, "TOPLEFT", MARGE, -4)
	v.resume:SetSize(largeur, 62)
	v.resume.texte = UI.Texte(v.resume, "GameFontHighlight", C.texte)
	v.resume.texte:SetPoint("TOPLEFT", v.resume, "TOPLEFT", 14, -34)
	v.resume.texte:SetPoint("RIGHT", v.resume, "RIGHT", -14, 0)
	v.classement = UI.Carte(v, "Classement des chasseurs")
	v.classement:SetPoint("TOPLEFT", v.resume, "BOTTOMLEFT", 0, -10)
	v.classement:SetSize(lg, hauteur)
	for _, col in ipairs(COLONNES) do
		local t = UI.Texte(v.classement, "GameFontHighlightSmall", C.gris)
		t:SetPoint("TOPRIGHT", v.classement, "TOPLEFT", col[2], -38)
		t:SetJustifyH("RIGHT")
		t:SetText(col[1])
	end
	local filet = UI.Filet(v.classement)
	filet:SetPoint("TOPLEFT", v.classement, "TOPLEFT", 14, -54)
	filet:SetPoint("TOPRIGHT", v.classement, "TOPRIGHT", -14, -54)
	v.classement.lignes = {}
	for i = 1, nLignes do
		local l = CreateFrame("Frame", nil, v.classement)
		l:SetSize(lg - 16, 22)
		l:SetPoint("TOPLEFT", v.classement, "TOPLEFT", 8, -58 - (i - 1) * 23)
		l.fond = l:CreateTexture(nil, "BACKGROUND")
		l.fond:SetAllPoints()
		l.fond:SetColorTexture(C.actif[1], C.actif[2], C.actif[3], 1)
		l.accent = UI.Accent(l)
		l.nom = UI.Texte(l, "GameFontHighlightSmall", C.texte)
		l.nom:SetPoint("LEFT", l, "LEFT", 8, 0)
		l.nom:SetWidth(196)
		l.cols = {}
		for j, col in ipairs(COLONNES) do
			local t = UI.Texte(l, "GameFontHighlightSmall", C.texte)
			t:SetPoint("RIGHT", l, "LEFT", col[2] - 8, 0)
			t:SetJustifyH("RIGHT")
			l.cols[j] = t
		end
		v.classement.lignes[i] = l
	end
	v.premieres = UI.Carte(v, "Premières captures de rares")
	v.premieres:SetPoint("TOPLEFT", v.classement, "TOPRIGHT", 10, 0)
	v.premieres:SetSize(ld, hauteur)
	v.premieres.lignes = {}
	for i = 1, nLignes do
		local l = LigneMonstre(v.premieres, i, ld)
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", v.premieres, "TOPLEFT", 12, -36 - (i - 1) * 23)
		v.premieres.lignes[i] = l
	end

	v.Maj = function()
		local b = Bestiaire()
		local g = Guilde()
		local s = MonScore()
		local moi = MaCle()
		if not g then
			v.resume.texte:SetText(GRIS .. "Tu n'es pas dans une guilde : le classement et les premières captures se jouent en guilde.|r")
		end
		-- la guilde : monstres et rares capturés, corps fouillés, premières de chaque membre
		local nGuilde, raresGuilde, corps = 0, 0, 0
		local premieres, parMembre = {}, {}
		for id, d in pairs(g and g.d or {}) do
			nGuilde = nGuilde + 1
			local f = b.par[id]
			if f and RARES[f.rang] then
				raresGuilde = raresGuilde + 1
				parMembre[d.c] = (parMembre[d.c] or 0) + 1
				premieres[#premieres + 1] = { id = id, f = f, c = d.c, j = d.j }
			end
		end
		for _, parPnj in pairs(g and g.butin or {}) do
			for cle, r in pairs(parPnj) do
				if cle ~= moi then corps = corps + (r.k or 0) end
			end
		end
		for _, e in pairs(Moi() and Moi().m or {}) do corps = corps + (e.d or 0) end
		if g then
			v.resume.texte:SetText(("%sRares et boss : %d sur %d|r%s · |rmonstres : %d sur %d%s · |r%d corps fouillé%s"):format(
				BLEU, raresGuilde, b.rares, GRIS, nGuilde, b.nombre, GRIS, corps, corps > 1 and "s" or ""))
		end
		-- classement : les rares d'abord (un membre resté à une version d'avant la 7.3.0 n'annonce pas les siens)
		local liste = {}
		if moi then liste[1] = { cle = moi, r = s.r, k = s.k, d = s.d } end
		for cle, x in pairs(g and g.s or {}) do
			if cle ~= moi and ((x.k or 0) > 0 or (x.r or 0) > 0) then
				liste[#liste + 1] = { cle = cle, r = x.r, k = x.k or 0, d = x.d or 0 }
			end
		end
		table.sort(liste, function(x, y)
			local rx, ry = x.r or -1, y.r or -1
			if rx ~= ry then return rx > ry end
			if x.k ~= y.k then return x.k > y.k end
			return x.cle < y.cle
		end)
		for i, l in ipairs(v.classement.lignes) do
			local x = liste[i]
			if x then
				local nom = ns.NomMembreColore and ns.NomMembreColore(x.cle, NomJoueur(x.cle)) or NomJoueur(x.cle)
				local _, titre = Titre(x.r or 0)
				l.nom:SetText(("%s%d.|r %s%s"):format(i <= 3 and OR or GRIS, i, nom, x.r and (GRIS .. "  " .. titre .. "|r") or ""))
				l.cols[1]:SetText(x.r and (BLEU .. x.r .. "|r") or (GRIS .. "—|r"))
				l.cols[2]:SetText(tostring(x.k))
				l.cols[3]:SetText(tostring(x.d))
				l.cols[4]:SetText(parMembre[x.cle] and (OR .. parMembre[x.cle] .. "|r") or (GRIS .. "0|r"))
				l.fond:SetShown(x.cle == moi)
				l.accent:SetShown(x.cle == moi)
				l:Show()
			else
				l:Hide()
			end
		end
		v.classement.compte:SetText(#liste > nLignes and (("les %d premiers sur %d"):format(nLignes, #liste)) or "")
		-- premières captures de rares, les plus récentes d'abord
		table.sort(premieres, function(x, y)
			if x.j ~= y.j then return x.j > y.j end
			return x.id < y.id
		end)
		for i, l in ipairs(v.premieres.lignes) do
			local x = premieres[i]
			if x then
				l.id = x.id
				l.texte:SetText(Couleur(COULEURS_RANGS[x.f.rang] or COULEUR_RARE) .. x.f.nom .. "|r")
				l.droite:SetText(NomJoueur(x.c) .. " · " .. date("%d/%m", EPOQUE + x.j * 86400 + 43200))
				l:Show()
			else
				l:Hide()
			end
		end
		v.premieres.compte:SetText(#premieres > 0 and tostring(#premieres) or "")
		v.premieres.vide:SetText(#premieres == 0 and "Aucun rare capturé par la guilde pour l'instant. Le premier à en capturer un l'inscrit ici." or "")
	end
	return v
end

--------------------------------------------------------------------------------
-- La page
--------------------------------------------------------------------------------

local CREER_VUES = { [1] = CreerVueGrille, [3] = CreerVueZones, [4] = CreerVueCarnet, [5] = CreerVueGuilde }

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.rafraichirAuto = false -- (page lourde : rafraîchie par ses propres évènements)
	page = p

	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -12)
	titre:SetText("WoWdex")
	p.titreChasseur = Pilule(p)
	p.titreChasseur:SetPoint("LEFT", titre, "RIGHT", 10, 0)
	p.sous = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.sous:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -7)
	p.sous:SetWidth(LargeurPage() - 2 * MARGE - 260)

	-- à droite : le compteur qui compte, les rares et boss capturés
	p.rares = UI.Texte(p, "GameFontNormalLarge", COULEUR_RARE)
	p.rares:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -8)
	p.rares:SetJustifyH("RIGHT")
	p.barre = Barre(p, 240, 8)
	p.barre:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -30)
	p.prochain = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.prochain:SetPoint("TOPRIGHT", p.barre, "BOTTOMRIGHT", 0, -4)
	p.prochain:SetJustifyH("RIGHT")

	p.onglets = UI.Onglets(p, ONGLETS, function(i)
		etat.onglet = i
		etat.ligne = 0
		p.Maj()
	end)
	p.onglets:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -54)
	p.onglets:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	-- zone des grilles : toutes, la mienne, ou celle choisie dans l'onglet Zones
	p.zone = UI.Choix(p, 170, { { "toutes", "Toutes les zones" }, { "ici", "Ma zone" } }, function(valeur)
		etat.zone = valeur
		etat.ligne = 0
		p.Maj()
	end)
	p.zone:SetPoint("BOTTOMRIGHT", p.onglets, "BOTTOMRIGHT", 0, 4)

	p.vues = {}
	p.MajFiche = MajFiche
	p.Maj = function()
		local b = Bestiaire()
		local s = MonScore()
		local g = Guilde()
		-- entête
		local rang, nomTitre, suivant = Titre(s.r)
		p.titreChasseur:Ecrire(nomTitre, C.ors)
		local d = { ("%sCapturés : %d|r sur %d"):format(VERT, s.k, b.nombre), "vus : " .. s.v, "dépouillés : " .. s.d }
		if s.hors > 0 then d[#d + 1] = "hors liste : " .. s.hors end
		if g then
			local nGuilde = 0
			for _ in pairs(g.d) do nGuilde = nGuilde + 1 end
			d[#d + 1] = "guilde : " .. nGuilde
		end
		p.sous:SetText(table.concat(d, GRIS .. " · |r"))
		p.rares:SetText(s.r .. GRIS .. " / " .. b.rares .. " rares et boss|r")
		p.barre:Poser(b.rares > 0 and s.r / b.rares or 0, COULEUR_RARE)
		p.prochain:SetText(suivant and ("Prochain titre : %s, à %d"):format(TITRES[rang + 1][2], suivant)
			or "Tous les rares et boss sont capturés !")
		-- onglets : les rares et boss de ma carte qui restent à capturer
		local ici = Recensement((ZonesDeMaCarte()))
		p.onglets:Compte(1, #ici.rares - ici.raresK)
		p.onglets:Choisir(etat.onglet)
		local options = { { "toutes", "Toutes les zones" }, { "ici", "Ma zone" } }
		if type(etat.zone) == "number" then options[3] = { etat.zone, NomZone(etat.zone) or "Zone choisie" } end
		p.zone.options = options
		p.zone:Poser(etat.zone)
		p.zone:SetShown(etat.onglet <= 2)
		-- vue de l'onglet (créée à la première visite)
		local cle = (etat.onglet <= 2) and 1 or etat.onglet
		if not p.vues[cle] then p.vues[cle] = CREER_VUES[cle](p) end
		for k, v in pairs(p.vues) do v:SetShown(k == cle) end
		p.vues[cle].Maj()
	end
	-- ns.OuvrirInterface("wowdex", pnj) : la fiche d'un monstre (avis de recherche pour un rare, sinon bestiaire)
	p.Ouvrir = function(id)
		id = tonumber(id)
		if not id then return end
		local f = Bestiaire().par[id]
		local e = Entree(id)
		choisi = id
		etat.onglet = RARES[f and f.rang or (e and e.r) or 0] and 1 or 2
		etat.filtres[1], etat.filtres[2] = 1, 1
		etat.zone, etat.recherche = "toutes", ""
		if p.vues[1] then p.vues[1].recherche:Ecrire("") end
		p.Maj()
		for i, a in ipairs(affiches) do
			if (a.hors or a.id) == id then
				Montrer(i)
				DessinerGrille()
				break
			end
		end
	end
	p:SetScript("OnShow", function() p.Maj() end)
	return p
end
if ns.AjouterPage then ns.AjouterPage("wowdex", CreerPage) end

--------------------------------------------------------------------------------
-- Losange sur la barre de nom des rares à capturer et des monstres pistés
--------------------------------------------------------------------------------

local marques = {} -- [cadre de barre de nom] = losange

local function MajPlaque(unite)
	if not (unite and C_NamePlate and C_NamePlate.GetNamePlateForUnit) then return end
	local plaque = C_NamePlate.GetNamePlateForUnit(unite)
	if not plaque then return end
	local w = Moi()
	local couleur, pnj
	if w and w.plaques ~= false then
		local id = Lire(unite)
		if id and not UnitIsDead(unite) and Palier(w.m[id]) < 2 then
			local f = Bestiaire().par[id]
			local rang = f and f.rang or (w.m[id] and w.m[id].r) or 0
			if RARES[rang] then
				couleur, pnj = COULEURS_RANGS[rang], id
			elseif w.pistes[id] then
				couleur, pnj = C and C.ors or { 0.945, 0.81, 0.42 }, id
			end
		end
	end
	local m = marques[plaque]
	if not couleur then
		if m then m:Hide(); m.id = nil end
		return
	end
	if not m then
		m = CreateFrame("Frame", nil, plaque)
		m:SetSize(11, 11)
		m:SetFrameLevel((plaque:GetFrameLevel() or 0) + 20)
		m.t = m:CreateTexture(nil, "OVERLAY")
		m.t:SetAllPoints()
		m.t:SetColorTexture(1, 1, 1, 1)
		if m.t.SetRotation then pcall(m.t.SetRotation, m.t, math.rad(45)) end
		marques[plaque] = m
	end
	m.id = pnj
	m.t:SetColorTexture(couleur[1], couleur[2], couleur[3], 1)
	-- à gauche de la barre de vie (le « ! » des quêtes est à droite), sinon à gauche de la barre de nom
	m:ClearAllPoints()
	local uf = plaque.UnitFrame
	local barre = uf and not (uf.IsForbidden and uf:IsForbidden()) and (uf.healthBar or uf.HealthBarsContainer)
	if barre and barre:IsShown() and uf:IsShown() then
		m:SetPoint("RIGHT", barre, "LEFT", -6, 0)
	else
		m:SetPoint("RIGHT", plaque, "LEFT", 6, 0)
	end
	m:Show()
end

local function RetirerPlaque(unite)
	local plaque = unite and C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(unite)
	local m = plaque and marques[plaque]
	if m then m:Hide(); m.id = nil end
end

-- un monstre vient d'être capturé : ses losanges disparaissent
MasquerMarques = function(id)
	for _, m in pairs(marques) do
		if m.id == id then m:Hide(); m.id = nil end
	end
end

-- réglage ou liste des monstres pistés changés : toutes les barres de nom affichées sont relues
ns.MajPlaquesWowdex = function()
	if not (C_NamePlate and C_NamePlate.GetNamePlates) then return end
	for _, plaque in ipairs(C_NamePlate.GetNamePlates() or {}) do
		local unite = plaque.namePlateUnitToken or (plaque.UnitFrame and plaque.UnitFrame.unit)
		if unite then pcall(MajPlaque, unite) end
	end
end

--------------------------------------------------------------------------------
-- /smb diag
--------------------------------------------------------------------------------

ns.DiagWowdex = function(L)
	local s = MonScore()
	local g = Guilde()
	local w = Moi()
	local nGuilde, nScores, nPistes, nReperes, nMorts = 0, 0, 0, 0, 0
	for _ in pairs(g and g.morts or {}) do nMorts = nMorts + 1 end
	for _ in pairs(g and g.d or {}) do nGuilde = nGuilde + 1 end
	for _ in pairs(g and g.s or {}) do nScores = nScores + 1 end
	for _ in pairs(g and g.r or {}) do nReperes = nReperes + 1 end
	for _ in pairs(w and w.pistes or {}) do nPistes = nPistes + 1 end
	local _, titre = Titre(s.r)
	L(("wowdex : %d monstres au bestiaire dont %d rares et boss, moi %d vus / %d capturés / %d dépouillés (%d hors liste), %d rares et boss (%s), %d pistés, guilde %d capturés, %d scores, %d rares repérés, %d rares tués, sources du butin %s"):format(
		Bestiaire().nombre, Bestiaire().rares, s.v, s.k, s.d, s.hors, s.r, titre, nPistes, nGuilde, nScores, nReperes, nMorts,
		GetLootSourceInfo and "oui" or "non"))
	local d = w and type(w.diag) == "table" and w.diag or {}
	local function N(cle) return tonumber(d[cle]) or 0 end
	local function T(cle) return d[cle .. "Texte"] and (" (dernier : « " .. tostring(d[cle .. "Texte"]) .. " »)") or "" end
	L(("wowdex, relevé depuis le %s : butins lus à LOOT_READY %d (corps comptés %d), à LOOT_OPENED %d (corps comptés %d), sources de butin cachées %d ; GUID cachés %d ; en instance : monstres reconnus par leur nom %d, noms hors bestiaire %d%s, noms cachés %d, lignes d'expérience cachées %d, boss %d, boss hors bestiaire %d%s ; erreurs %d%s"):format(
		type(d.depuis) == "number" and date("%d/%m %H:%M", d.depuis) or "?", N("butinsPrets"), N("corpsPrets"),
		N("butinsOuverts"), N("corpsOuverts"), N("sourcesCachees"), N("guidsCaches"), N("nomsLus"), N("nomsInconnus"),
		T("nomsInconnus"), N("nomsCaches"), N("xpCachees"), N("boss"), N("bossInconnus"), T("bossInconnus"),
		N("erreurs"), T("erreurs")))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "UPDATE_MOUSEOVER_UNIT", "PLAYER_TARGET_CHANGED",
	"NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "LOOT_READY", "LOOT_OPENED",
	"CHAT_MSG_COMBAT_XP_GAIN", "ENCOUNTER_END", "BOSS_KILL" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
-- (mort de la cible pendant qu'elle est ciblée : aucun changement de cible)
-- (sort de récolte qui va ouvrir un butin : dépeçage, vol à la tire…)
pcall(ev.RegisterUnitEvent, ev, "UNIT_SPELLCAST_SUCCEEDED", "player")
if not pcall(ev.RegisterUnitEvent, ev, "UNIT_HEALTH", "target") then
	pcall(ev.RegisterUnitEvent, ev, "UNIT_HEALTH_FREQUENT", "target")
end
local premiere = true
-- (a1… : unité ; ou unité, _, sort ; ou texte ; ou numéro du combat de boss, nom, difficulté, taille, réussi)
ev:SetScript("OnEvent", function(_, evenement, a1, a2, a3, _, a5)
	if evenement == "UPDATE_MOUSEOVER_UNIT" then
		Instance.Essayer(Observer, "mouseover")
	elseif evenement == "PLAYER_TARGET_CHANGED" then
		Instance.Essayer(Observer, "target")
	elseif evenement == "NAME_PLATE_UNIT_ADDED" then
		Instance.Essayer(Vu, a1)
		Instance.Essayer(MajPlaque, a1)
	elseif evenement == "NAME_PLATE_UNIT_REMOVED" then
		Instance.Essayer(RetirerPlaque, a1)
	elseif evenement == "UNIT_HEALTH" or evenement == "UNIT_HEALTH_FREQUENT" then
		if UnitIsDead("target") then Instance.Essayer(Observer, "target") end
	elseif evenement == "UNIT_SPELLCAST_SUCCEEDED" then
		Instance.Essayer(SortLance, a3)
	elseif evenement == "LOOT_READY" or evenement == "LOOT_OPENED" then
		-- (une erreur va au relevé de /smb diag, plus en haut de l'écran)
		Instance.Essayer(Fouiller, evenement == "LOOT_READY")
	elseif evenement == "CHAT_MSG_COMBAT_XP_GAIN" then
		Instance.Essayer(Instance.Experience, a1)
	elseif evenement == "ENCOUNTER_END" or evenement == "BOSS_KILL" then
		if evenement == "BOSS_KILL" or (not Secrete(a5) and (a5 == 1 or a5 == true)) then
			Instance.Essayer(Instance.Vaincu, a2, true)
		end
	elseif evenement == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		-- (la guilde et la liste de ses membres ne sont pas connues tout de suite)
		C_Timer.After(30, function()
			local g = Guilde()
			if g then
				OublierButin()
				local depuis = 0
				for _, d in pairs(g.d) do if d.j > depuis then depuis = d.j end end
				Envoyer("Q~" .. Base36(depuis))
				Envoyer("P~" .. Base36(g.curseurButin or 0))
			end
			pret = true
		end)
		C_Timer.After(45, EnvoyerScore)
	end
end)

ns.Ecouter(PREFIXE, Recevoir)
