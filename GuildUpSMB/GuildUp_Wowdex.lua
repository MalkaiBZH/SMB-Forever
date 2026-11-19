-- GuildUpSMB : WoWdex, le bestiaire à compléter, seul et en guilde (page « WoWdex », /smb wowdex ; préfixe
-- "GuildUpDex").
-- Le bestiaire (ns.BESTIAIRE, GuildUp_Bestiaire.lua, généré depuis QuestieDB) numérote les monstres de Forever
-- du plus faible au plus fort. Chaque monstre a trois paliers, comme dans un Pokédex :
--   vu        barre de nom, cible ou survol d'un monstre qu'on peut attaquer : son nom et son modèle s'affichent
--   vaincu    (« capturé ») tué par moi ou mon groupe (PARTY_KILL du journal de combat, sinon cible ou survol
--             d'un corps qui n'est pas « pris par un autre »), ou dépouillé
--   dépouillé fouillé : ce qu'il a lâché est compté, pour donner les taux de butin. Pas le butin d'une récolte
--             (dépeçage, vol à la tire, minage, herboristerie : sort lancé moins de 2 s avant l'ouverture du
--             butin, reconnu à son numéro ou à son nom), ni celui d'un monstre ciblé encore vivant
-- Un monstre absent du bestiaire mais rencontré en jeu est gardé aussi (nom, niveau, rang, type, zone appris sur
-- l'unité), sans numéro : le WoWdex vit de ce que croisent les joueurs.
-- Mon WoWdex est commun aux personnages du compte : GuildUpDB.wowdex.m[pnj] = { v = vu le, k = vaincus,
-- d = dépouilles, tk = premier vaincu le, tb = dernière dépouille le, b = { [objet] = corps qui l'ont lâché },
-- ty = type, et pour un monstre hors bestiaire : n = nom, l = niveau, r = rang, c = carte, z = zone }.
-- La guilde (GuildUpDB.wowdexGuilde[guilde]) : d[pnj] = { c = premier membre à l'avoir vaincu, j = jour },
-- s[clé] = { v, k, d, t } (score de chaque membre), butin[pnj][clé] = { k = corps fouillés, o = { [objet] = n },
-- t = date } (le relevé de chaque autre membre ; le mien est lu dans mon WoWdex), curseurButin (rattrapage).
-- Taux de drop de la guilde = somme des relevés de chaque membre. Chaque relevé appartient à son membre et ses
-- comptes ne font que monter : on garde le plus grand reçu, donc rien n'est compté deux fois (ni un message reçu
-- deux fois, ni un relevé reçu en direct puis par le relais).
-- Un monstre est « connu » (nom affiché, sinon « ??? ») si je l'ai vu ou si la guilde l'a vaincu.
-- Recherche de la page : nom du monstre, zone, ou nom d'un objet (les monstres qui le lâchent : ceux où la guilde
-- l'a trouvé d'abord, puis ceux du bestiaire). ns.SourcesWowdex(objet) : les monstres où la guilde l'a trouvé,
-- avec le taux (Encyclopédie de GuildUp_Carnet.lua).
-- Messages (pnj et objets en base 36, jour = jours depuis le 1er janvier 2024, t = heure du serveur) :
--   "N~pnj,pnj,…"                     mes nouvelles captures (regroupées, toutes les 15 s au plus)
--   "B~pnj:corps:t.objet.n.objet.n;…" mes relevés de butin (totaux) des monstres fouillés depuis le dernier envoi
--                                     (toutes les 60 s au plus) ; un monstre au butin très varié tient en
--                                     plusieurs mots. (« L », les écarts de la 7.0.0, est ignoré.)
--   "S~vus~vaincus~dépouillés"        mon score (à la connexion, puis 2 min après un changement)
--   "Q~jour"                          je me connecte : envoyez-moi les découvertes depuis ce jour
--   "E~clé~pnj.jour,pnj.jour,…"       découvertes de la guilde, par le seul relais (ns.EstLeRelais), les plus
--                                     anciennes d'abord, 400 au plus par demande (la suite à la connexion suivante)
--   "T~clé,vus,vaincus,dépouillés,t;…" scores des membres, par le même relais
--   "P~t"                             je me connecte : envoyez-moi les relevés de butin changés depuis t
--   "R~clé~pnj:corps:t.objet.n…;…"    relevés de ce membre, par le seul relais, les plus anciens d'abord, 300 au
--                                     plus par demande ; tout le monde les lit
--   "F~demandeur~t"                   fin du rattrapage : le demandeur reprendra à t la prochaine fois
-- Une découverte : le jour le plus ancien gagne (à égalité, la plus petite clé). La première capture d'un rare,
-- d'un rare élite ou d'un boss par la guilde entre dans le fil d'activité (genre « W », GuildUp_Journal.lua).
-- Bulles (catégorie « wowdex ») : capture d'un rare ou d'un boss, tous les 25 monstres capturés ; une ligne dans la
-- discussion pour chaque nouvelle capture. Ligne « WoWdex » dans l'infobulle des monstres.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpDex"
local EPOQUE = 1704067200        -- 1er janvier 2024 : jour 0
local MAX_RELAIS = 400
local MAX_RELAIS_BUTIN = 300
local MAX_HORS = 1000             -- monstres hors bestiaire gardés au plus
local PALIER_BULLE = 25
local OCTETS = 240

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
local RARES = { [2] = true, [3] = true, [4] = true } -- rare élite, boss, rare
local CLASSEMENTS = { elite = 1, rareelite = 2, worldboss = 3, rare = 4 }

local function Jour(t) return math.floor(((t or Maintenant()) - EPOQUE) / 86400) end
local function DateJour(j) return date("%d/%m/%Y", EPOQUE + j * 86400 + 43200) end
local function Message(t) if ns.Coeur and ns.Coeur.Message then ns.Coeur.Message(t) else print(t) end end

--------------------------------------------------------------------------------
-- Bestiaire (lu une fois, à la première utilisation)
--------------------------------------------------------------------------------

local bestiaire -- { liste = { fiche… } dans l'ordre des numéros, par = { [pnj] = fiche }, zones, nombre }

local function Bestiaire()
	if bestiaire then return bestiaire end
	local b = { liste = {}, par = {}, zones = {} }
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
	for _, k in ipairs({ "d", "s", "butin" }) do
		if type(g[k]) ~= "table" then g[k] = {} end
	end
	g.b = nil -- (7.0.0 : totaux de tous mélangés, impossibles à répartir par membre)
	return g
end

-- mes compteurs : vus, vaincus (capturés), dépouillés, hors bestiaire
local scoreCache
local function MonScore()
	if scoreCache then return scoreCache end
	local w = Moi()
	local s = { v = 0, k = 0, d = 0, hors = 0 }
	if w then
		local par = Bestiaire().par
		for id, e in pairs(w.m) do
			local p = Palier(e)
			if p >= 1 then s.v = s.v + 1 end
			if p >= 2 then s.k = s.k + 1 end
			if p >= 3 then s.d = s.d + 1 end
			if not par[id] then s.hors = s.hors + 1 end
		end
	end
	scoreCache = s
	return s
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
	return g and g.d[id] ~= nil or false
end

--------------------------------------------------------------------------------
-- Rafraîchissement de la page
--------------------------------------------------------------------------------

local page
local majPrevue = false
local function MajBientot()
	scoreCache = nil
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
local fouilles = {}    -- [GUID] = true : corps déjà fouillés (session)
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

local function Notif(categorie, titre, texte)
	if ns.Notifier then ns.Notifier(categorie, titre, texte, nil, function()
		if ns.OuvrirInterface then ns.OuvrirInterface("wowdex") end
	end) end
end

local function Vu(unite)
	local id = Lire(unite)
	if not id then return nil end
	local e = Apprendre(unite, id)
	if e and not e.v then
		e.v = Maintenant()
		MajBientot()
	end
	return id, e
end

local function Vaincre(id, guid, unite)
	if not id or (guid and vaincus[guid]) then return end
	if guid then
		vaincus[guid] = true
		nVaincus = nVaincus + 1
		if nVaincus > 3000 then wipe(vaincus); nVaincus = 0 end
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
	if e.k > 1 then return end
	-- nouvelle capture
	e.tk = Maintenant()
	local moi = MaCle()
	local nouveauGuilde = Decouverte(id, moi, Jour())
	AnnoncerCapture(id)
	local f = Bestiaire().par[id]
	local rang = f and f.rang or e.r or 0
	local s = MonScore()
	local db = ns.DB and ns.DB()
	local bavard = not (db and type(db.notifs) == "table" and db.notifs.wowdex == false)
	if bavard then
		Message(("WoWdex : %s%s|r capturé ! (%d sur %d)"):format("|cffffd100",
			(f and ("n°%04d "):format(f.num) or "") .. NomMonstre(id), s.k, Bestiaire().nombre))
	end
	if RARES[rang] then
		Notif("wowdex", "WoWdex : " .. NOMS_RANGS[rang] .. " capturé !", NomMonstre(id)
			.. (nouveauGuilde and " : une première pour la guilde !" or ""))
		if nouveauGuilde and ns.NoterActivite and moi then ns.NoterActivite("W", moi, tostring(id)) end
	elseif s.k % PALIER_BULLE == 0 then
		Notif("wowdex", "WoWdex", ("%d monstres capturés !"):format(s.k))
	end
end

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

-- un monstre ciblé encore vivant (vol à la tire) n'a rien lâché
local function Vivant(guid)
	if not (UnitExists("target") and UnitGUID("target") == guid) then return false end
	return not UnitIsDead("target")
end

-- corps fouillés : chaque corps (GUID) compte une fois, avec les objets qu'il a lâchés
local function Fouiller()
	if IsFishingLoot and IsFishingLoot() then return end
	if GetTime() - finRecolte < DELAI_RECOLTE then return end
	local n = GetNumLootItems and GetNumLootItems() or 0
	local corps = {} -- [GUID] = { id, objets = { [objet] = true } }
	local avecSources = GetLootSourceInfo ~= nil
	for slot = 1, n do
		local lien = GetLootSlotLink and GetLootSlotLink(slot)
		local objet = type(lien) == "string" and not Secrete(lien) and tonumber(lien:match("item:(%d+)")) or nil
		if avecSources then
			local sources = { GetLootSourceInfo(slot) }
			for i = 1, #sources, 2 do
				local guid = sources[i]
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
				local objet = type(lien) == "string" and tonumber(lien:match("item:(%d+)")) or nil
				if objet then corps[guid].objets[objet] = true end
			end
		end
	end
	for guid, c in pairs(corps) do
		if not fouilles[guid] and not Vivant(guid) and (Bestiaire().par[c.id] or Entree(c.id)) then
			fouilles[guid] = true
			nFouilles = nFouilles + 1
			if nFouilles > 3000 then wipe(fouilles); nFouilles = 0 end
			Vaincre(c.id, guid)
			local e = Entree(c.id)
			if e then
				e.d = (e.d or 0) + 1
				if type(e.b) ~= "table" then e.b = {} end
				for o in pairs(c.objets) do e.b[o] = (e.b[o] or 0) + 1 end
				e.tb = Maintenant()
				AnnoncerButin(c.id)
				if e.d == 1 then ScorePlusTard() end
				MajBientot()
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

-- journal de combat : un membre de mon groupe (ou moi) donne le coup de grâce
local function JournalCombat()
	if not CombatLogGetCurrentEventInfo then return end
	local ok, _, evenement, _, _, _, _, _, guid = pcall(CombatLogGetCurrentEventInfo)
	if not ok or Secrete(evenement) or evenement ~= "PARTY_KILL" then return end
	local id = PnjDuGuid(guid)
	if id then Vaincre(id, guid) end
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
			if id and Decouverte(id, qui, j) then
				local f = Bestiaire().par[id]
				if f and RARES[f.rang] and ns.NoterActivite then ns.NoterActivite("W", qui, tostring(id)) end
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
			g.s[qui] = { v = tonumber(v), k = tonumber(k), d = tonumber(d), t = Maintenant() }
			MajBientot()
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
				g.s[cle] = { v = tonumber(v), k = tonumber(k), d = tonumber(d), t = t }
			end
		end
		MajBientot()
	end
end

--------------------------------------------------------------------------------
-- Infobulle des monstres : « WoWdex n°0016 · capturé ×12 » ou « Nouveau ! »
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
		texte = texte .. "  |cffff9f40à capturer|r" .. ((g and g.d[id]) and "|cff9c9380 (déjà dans le WoWdex de la guilde)|r" or "")
	end
	tt:AddLine(texte)
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tt) pcall(BulleUnite, tt) end)
elseif GameTooltip and GameTooltip.HookScript then
	pcall(GameTooltip.HookScript, GameTooltip, "OnTooltipSetUnit", function(self) pcall(BulleUnite, self) end)
end

--------------------------------------------------------------------------------
-- Page « WoWdex »
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI and UI.C
local MARGE = 16
local HAUTEUR_RANGEE, ECART_RANGEE = 40, 4
local PAS = HAUTEUR_RANGEE + ECART_RANGEE
local LARGEUR_FICHE = 330
local HAUT_LISTE = -100
local FILTRES = { "Tous", "Capturés", "À capturer", "Rares et boss" }
local GRIS, VERT, OR = "|cff9c9380", "|cff6fd08c", "|cfff1cf6b"
local COULEURS_PALIERS = { [0] = { 0.3, 0.27, 0.22 }, { 0.75, 0.72, 0.65 }, { 0.44, 0.82, 0.55 }, { 0.945, 0.81, 0.42 } }
local NOMS_PALIERS = { [0] = "Inconnu", "Vu", "Capturé", "Capturé et dépouillé" }

local filtre, recherche, zoneChoisie = 1, "", "toutes"
local affiches = {}       -- éléments affichés : { fiche } ou { hors = id }
local choisi              -- pnj de la fiche ouverte (nil : classement)

local function Couleur(c) return ("|cff%02x%02x%02x"):format(math.floor(c[1] * 255), math.floor(c[2] * 255), math.floor(c[3] * 255)) end

local function NiveauTexte(mi, ma)
	if not mi or mi <= 0 then return nil end
	return (ma and ma ~= mi) and (mi .. "-" .. ma) or tostring(mi)
end

-- les zones de ma carte actuelle (filtre « Ma zone »)
local function ZonesDeMaCarte()
	local res = {}
	local carte = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if not carte then return res end
	for z, info in pairs(Bestiaire().zones) do
		if info.carte == carte then res[z] = true end
	end
	return res, carte
end

-- Recherche d'un objet : les objets dont le nom contient le texte (liste de tous les objets du jeu,
-- GuildUp_Demandes.lua), puis les monstres qui les lâchent : trouvés par la guilde (ou moi), ou dans le bestiaire.
-- objetDe[pnj] = { objet, guilde = vrai si trouvé en jeu } (remis à zéro à chaque construction de la liste)
local objetDe = {}

local function ChercherParObjet(b, g, w)
	wipe(objetDe)
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

local function Construire()
	wipe(affiches)
	local b = Bestiaire()
	local g = Guilde()
	local w = Moi()
	local maZone, maCarte
	if zoneChoisie == "ici" then maZone, maCarte = ZonesDeMaCarte() end
	local parObjet = ChercherParObjet(b, g, w)
	local function Garder(id, rang, zones, nomVisible, texteZone)
		local e = w and w.m[id]
		local p = Palier(e)
		if filtre == 2 and p < 2 then return false end
		if filtre == 3 and p >= 2 then return false end
		if filtre == 4 and not RARES[rang or 0] then return false end
		if maZone then
			local ici = zones.ici
			if not ici then
				for z in pairs(zones) do if maZone[z] then ici = true; break end end
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
		local zones = f.ensembleZones
		if not zones then
			zones = {}
			for z in f.zonesTexte:gmatch("(%d+):") do zones[tonumber(z)] = true end
			f.ensembleZones = zones
		end
		local connu = (w and w.m[f.id] and w.m[f.id].v) or (g and g.d[f.id])
		if Garder(f.id, f.rang, zones, connu and f.nom or nil, NomZone(f.zone)) then affiches[#affiches + 1] = f end
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

local function CreerRangee(parent)
	local r = UI.Rangee(parent, HAUTEUR_RANGEE)
	r.point = r:CreateTexture(nil, "ARTWORK")
	r.point:SetTexture(UI.ROND)
	r.point:SetSize(14, 14)
	r.point:SetPoint("LEFT", r, "LEFT", 10, 0)
	r.num = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.num:SetPoint("LEFT", r.point, "RIGHT", 8, 0)
	r.num:SetWidth(52)
	r.droite = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.droite:SetPoint("RIGHT", r, "RIGHT", -10, 0)
	r.droite:SetJustifyH("RIGHT")
	r.nom = UI.Texte(r, "GameFontHighlight", C.texte)
	r.nom:SetPoint("TOPLEFT", r.num, "TOPRIGHT", 4, 8)
	r.nom:SetPoint("RIGHT", r.droite, "LEFT", -8, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("TOPLEFT", r.nom, "BOTTOMLEFT", 0, -3)
	r.sous:SetPoint("RIGHT", r.droite, "LEFT", -8, 0)
	r:SetScript("OnClick", function(self)
		if not self.id then return end
		choisi = self.id
		if page then page.MajFiche() end
		if page and page.Dessiner then page.Dessiner() end
	end)
	UI.SonClic(r)
	return r
end

local function Remplir(r, a)
	local id, num, nom, rang, niveau, zone, e = Infos(a)
	r.id = id
	local p = Palier(e)
	local c = COULEURS_PALIERS[p]
	r.point:SetVertexColor(c[1], c[2], c[3], 1)
	r.num:SetText(num and ("n°%04d"):format(num) or "hors liste")
	local cr = COULEURS_RANGS[rang or 0] or COULEURS_RANGS[0]
	if nom then
		r.nom:SetText(((rang == 1 or rang == 2) and "|TInterface\\Tooltips\\EliteNameplateIcon:14:14:0:0|t" or "") .. nom)
		r.nom:SetTextColor(cr[1], cr[2], cr[3])
	else
		r.nom:SetText("???")
		r.nom:SetTextColor(unpack(C.gris))
	end
	local d = {}
	if niveau then d[#d + 1] = "Niv. " .. niveau end
	if rang and rang > 0 then d[#d + 1] = Couleur(cr) .. NOMS_RANGS[rang] .. "|r" end
	if zone then d[#d + 1] = zone end
	local x = objetDe[id]
	if x then
		local k, o = TotauxButin(id)
		local taux = (x.guilde and k > 0 and o[x.objet]) and (" " .. VERT .. math.floor(100 * o[x.objet] / k + 0.5) .. " %|r") or ""
		d[#d + 1] = OR .. NomObjet(x.objet) .. "|r" .. taux .. (x.guilde and "" or (GRIS .. " (bestiaire)|r"))
	end
	r.sous:SetText(table.concat(d, " · "))
	if p >= 2 then
		r.droite:SetText(VERT .. "×" .. (e.k or 0) .. "|r")
	else
		local g = Guilde()
		r.droite:SetText((g and g.d[id]) and (GRIS .. "guilde|r") or "")
	end
	r:Fort(id == choisi)
end

local function Dessiner()
	if not page then return end
	local l = page.liste
	local haut = tonumber(l:GetVerticalScroll()) or 0
	local vue = tonumber(l:GetHeight()) or 0
	if vue < 50 then vue = 460 end
	local premier = math.max(1, math.floor(haut / PAS) + 1)
	local dernier = math.min(#affiches, premier + math.ceil(vue / PAS))
	local k = 0
	for i = premier, dernier do
		k = k + 1
		local r = page.rangees[k]
		if not r then
			r = CreerRangee(l.contenu)
			page.rangees[k] = r
		end
		Remplir(r, affiches[i])
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", l.contenu, "TOPLEFT", 0, -(i - 1) * PAS)
		r:SetPoint("RIGHT", l.contenu, "RIGHT", 0, 0)
		r:Show()
	end
	for i = k + 1, #page.rangees do
		page.rangees[i]:Hide()
		page.rangees[i].id = nil
	end
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

local MAX_LIGNES_BUTIN = 7

local function CreerFiche(p)
	local fiche = UI.Carte(p, "")
	fiche:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, HAUT_LISTE)
	fiche:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, 12)
	fiche:SetWidth(LARGEUR_FICHE)
	fiche.titre:SetPoint("RIGHT", fiche, "RIGHT", -14, 0)
	-- modèle 3D
	fiche.scene = CreateFrame("Frame", nil, fiche)
	fiche.scene:SetPoint("TOPLEFT", fiche, "TOPLEFT", 10, -34)
	fiche.scene:SetPoint("TOPRIGHT", fiche, "TOPRIGHT", -10, -34)
	fiche.scene:SetHeight(120)
	local fond = fiche.scene:CreateTexture(nil, "BACKGROUND")
	fond:SetAllPoints()
	fond:SetColorTexture(unpack(C.champ))
	local okM, m = pcall(CreateFrame, "PlayerModel", nil, fiche.scene)
	if okM and m then
		m:SetAllPoints(fiche.scene)
		fiche.modele = m
		local angle = 0
		fiche.scene:SetScript("OnUpdate", function(_, ecoule)
			angle = (angle + (ecoule or 0) * 0.6) % (2 * math.pi)
			pcall(m.SetFacing, m, angle)
		end)
	end
	fiche.mystere = UI.Texte(fiche.scene, "GameFontNormalLarge", C.bordFort)
	fiche.mystere:SetPoint("CENTER")
	fiche.mystere:SetText("?")
	fiche.infos = UI.Texte(fiche, "GameFontHighlightSmall", C.texte)
	fiche.infos:SetPoint("TOPLEFT", fiche.scene, "BOTTOMLEFT", 4, -8)
	fiche.infos:SetPoint("RIGHT", fiche, "RIGHT", -14, 0)
	fiche.infos:SetWordWrap(true)
	fiche.infos:SetSpacing(3)
	fiche.carte = UI.Bouton(fiche, "Voir sur la carte", "fantome", 130, 22)
	fiche.carte:SetPoint("BOTTOMLEFT", fiche, "BOTTOMLEFT", 12, 10)
	fiche.classement = UI.Bouton(fiche, "Classement", "fantome", 100, 22)
	fiche.classement:SetPoint("BOTTOMRIGHT", fiche, "BOTTOMRIGHT", -12, 10)
	fiche.classement:SetScript("OnClick", function()
		choisi = nil
		p.MajFiche()
		Dessiner()
	end)
	UI.Infobulle(fiche.classement, "Classement", "Les membres de la guilde qui ont capturé le plus de monstres.")
	fiche.titreButin = UI.Texte(fiche, "GameFontNormal", C.ors)
	fiche.titreButin:SetText("Butin")
	fiche.lignes = {}
	for i = 1, MAX_LIGNES_BUTIN do
		local l = CreateFrame("Button", nil, fiche)
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
	fiche.reste = UI.Texte(fiche, "GameFontHighlightSmall", C.gris)
	-- classement (quand aucun monstre n'est choisi)
	fiche.rangs = UI.Texte(fiche, "GameFontHighlight", C.texte)
	fiche.rangs:SetPoint("TOPLEFT", fiche, "TOPLEFT", 14, -40)
	fiche.rangs:SetPoint("RIGHT", fiche, "RIGHT", -14, 0)
	fiche.rangs:SetWordWrap(true)
	fiche.rangs:SetSpacing(6)
	return fiche
end

local function MajClassement(fiche)
	fiche.titre:SetText("Classement de la guilde")
	fiche.titre:SetTextColor(unpack(C.ors))
	fiche.scene:Hide()
	fiche.infos:Hide()
	fiche.carte:Hide()
	fiche.classement:Hide()
	fiche.titreButin:Hide()
	fiche.reste:Hide()
	for _, l in ipairs(fiche.lignes) do l:Hide() end
	local g = Guilde()
	local liste = {}
	local moi = MaCle()
	local s = MonScore()
	if moi then liste[1] = { cle = moi, k = s.k, d = s.d } end
	for cle, x in pairs(g and g.s or {}) do
		if cle ~= moi and (x.k or 0) > 0 then liste[#liste + 1] = { cle = cle, k = x.k or 0, d = x.d or 0 } end
	end
	table.sort(liste, function(a, b) if a.k ~= b.k then return a.k > b.k end return a.cle < b.cle end)
	local lignes = {}
	for i = 1, math.min(#liste, 14) do
		local x = liste[i]
		local nom = ns.NomMembreColore and ns.NomMembreColore(x.cle, NomJoueur(x.cle)) or NomJoueur(x.cle)
		lignes[#lignes + 1] = ("%s%d.|r %s  %s%d capturés|r%s"):format(i <= 3 and OR or GRIS, i, nom, VERT, x.k,
			x.d > 0 and (GRIS .. " · " .. x.d .. " dépouillés|r") or "")
	end
	local nGuilde = 0
	for _ in pairs(g and g.d or {}) do nGuilde = nGuilde + 1 end
	lignes[#lignes + 1] = ""
	lignes[#lignes + 1] = GRIS .. ("WoWdex de la guilde : %d monstres capturés sur %d."):format(nGuilde, Bestiaire().nombre) .. "|r"
	lignes[#lignes + 1] = GRIS .. "Clique sur un monstre pour ouvrir sa fiche.|r"
	fiche.rangs:SetText(table.concat(lignes, "\n"))
	fiche.rangs:Show()
end

local function MajFiche()
	local fiche = page and page.fiche
	if not fiche then return end
	if not choisi then MajClassement(fiche); return end
	fiche.rangs:Hide()
	local id = choisi
	local b = Bestiaire()
	local f = b.par[id]
	local e = Entree(id)
	local connu = Connu(id) or (e and e.n)
	local rang = f and f.rang or (e and e.r) or 0
	local cr = COULEURS_RANGS[rang] or COULEURS_RANGS[0]
	local nom = connu and NomMonstre(id) or "???"
	fiche.titre:SetText((f and ("n°%04d  "):format(f.num) or "") .. nom)
	fiche.titre:SetTextColor(cr[1], cr[2], cr[3])
	-- modèle : seulement pour un monstre connu
	fiche.scene:Show()
	local modele = false
	if fiche.modele then
		pcall(fiche.modele.ClearModel, fiche.modele)
		if connu then
			modele = pcall(fiche.modele.SetCreature, fiche.modele, id)
			fiche.modele:SetShown(modele)
		else
			fiche.modele:Hide()
		end
	end
	fiche.mystere:SetShown(not modele)
	-- informations
	local t = {}
	local quoi = {}
	local niveau = f and NiveauTexte(f.min, f.max) or (e and NiveauTexte(e.l))
	if niveau then quoi[#quoi + 1] = "Niveau " .. niveau end
	if rang > 0 then quoi[#quoi + 1] = Couleur(cr) .. NOMS_RANGS[rang] .. "|r" end
	if e and e.ty then quoi[#quoi + 1] = e.ty end
	if #quoi > 0 then t[#t + 1] = table.concat(quoi, " · ") end
	local zones = {}
	for _, z in ipairs(f and ZonesFiche(f) or {}) do zones[#zones + 1] = NomZone(z.zone) end
	if #zones == 0 and e and e.z then zones[1] = e.z end
	if #zones > 0 then t[#t + 1] = GRIS .. "Zone :|r " .. table.concat(zones, ", ") end
	local p = Palier(e)
	local pc = COULEURS_PALIERS[p]
	if p == 0 then
		t[#t + 1] = GRIS .. "Toi :|r " .. Couleur(pc) .. "pas encore rencontré|r"
	else
		local moi = { Couleur(pc) .. NOMS_PALIERS[p] .. "|r" }
		if (e.k or 0) > 0 then moi[#moi + 1] = e.k .. " vaincu" .. (e.k > 1 and "s" or "") end
		if (e.d or 0) > 0 then moi[#moi + 1] = e.d .. " dépouillé" .. (e.d > 1 and "s" or "") end
		local quand = e.tk or e.v
		if quand then moi[#moi + 1] = GRIS .. (e.tk and "capturé le " or "vu le ") .. date("%d/%m/%Y", quand) .. "|r" end
		t[#t + 1] = GRIS .. "Toi :|r " .. table.concat(moi, " · ")
	end
	local g = Guilde()
	local d = g and g.d[id]
	if d then
		t[#t + 1] = GRIS .. "Guilde :|r premier capturé par " .. NomJoueur(d.c) .. GRIS .. ", le " .. DateJour(d.j) .. "|r"
	elseif g then
		t[#t + 1] = GRIS .. "Guilde : personne ne l'a encore capturé.|r"
	end
	fiche.infos:SetText(table.concat(t, "\n"))
	fiche.infos:Show()
	-- butin
	local liste, corps, membres = ButinAffiche(id)
	fiche.titreButin:ClearAllPoints()
	fiche.titreButin:SetPoint("TOPLEFT", fiche.infos, "BOTTOMLEFT", 0, -12)
	fiche.titreButin:SetText("Butin" .. (corps > 0 and (GRIS .. ("  %d corps fouillé%s par %d membre%s"):format(corps,
		corps > 1 and "s" or "", membres, membres > 1 and "s" or "") .. "|r") or ""))
	fiche.titreButin:Show()
	local y = 0
	for i, l in ipairs(fiche.lignes) do
		local x = liste[i]
		if x then
			local nomO, _, qualite, icone = ns.InfoObjet(x.objet)
			if not nomO and ns.Precharger then ns.Precharger(x.objet) end
			l.objet = x.objet
			l.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
			local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
			l.nom:SetText(((qc and qc.hex) or "|cffffffff") .. (nomO or ("objet n° " .. x.objet)) .. "|r")
			if x.n then
				l.taux:SetText(("%d %%"):format(math.floor(100 * x.n / math.max(1, x.corps) + 0.5)))
				l.aide = ("Tombé sur %d des %d corps fouillés par la guilde (%d membre%s)."):format(x.n, x.corps,
					x.membres or 1, (x.membres or 1) > 1 and "s" or "")
			else
				l.taux:SetText(GRIS .. "jamais vu|r")
				l.aide = "Peut tomber sur ce monstre (bestiaire), pas encore trouvé par la guilde."
			end
			l:ClearAllPoints()
			l:SetPoint("TOPLEFT", fiche.titreButin, "BOTTOMLEFT", 0, -6 - y)
			l:SetPoint("RIGHT", fiche, "RIGHT", -14, 0)
			l:Show()
			y = y + 21
		else
			l:Hide()
			l.objet = nil
		end
	end
	fiche.reste:ClearAllPoints()
	fiche.reste:SetPoint("TOPLEFT", fiche.titreButin, "BOTTOMLEFT", 0, -8 - y)
	if #liste > MAX_LIGNES_BUTIN then
		fiche.reste:SetText(("et %d autres objets"):format(#liste - MAX_LIGNES_BUTIN))
	elseif #liste == 0 then
		fiche.reste:SetText("Rien de particulier : le butin commun (étoffes, objets gris) apparaîtra ici quand la guilde l'aura fouillé.")
	else
		fiche.reste:SetText("")
	end
	fiche.reste:SetWidth(LARGEUR_FICHE - 28)
	fiche.reste:SetWordWrap(true)
	fiche.reste:Show()
	-- carte
	local groupes = {}
	for _, z in ipairs(f and ZonesFiche(f) or {}) do
		local info = b.zones[z.zone]
		if info and info.carte and #z.points > 0 then
			groupes[#groupes + 1] = { carte = info.carte, points = z.points, couleur = { 0.95, 0.35, 0.25 } }
		end
	end
	fiche.carte:SetShown(#groupes > 0)
	fiche.carte:SetScript("OnClick", function()
		if ns.AfficherSurCarte then
			ns.AfficherSurCarte("WoWdex : " .. nom .. " — " .. (NomZone(f and f.zone) or ""), { groupes[1] })
		end
	end)
	fiche.classement:Show()
end

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.rafraichirAuto = false -- (liste lourde : rafraîchie par ses propres évènements)
	page = p

	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -18)
	titre:SetText("WoWdex")
	p.sous = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.sous:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	p.sous:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)

	-- barre de progression (capturés)
	p.barre = UI.Cadre(p, C.champ, C.bord)
	p.barre:SetSize(200, 10)
	p.barre:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -22)
	p.barre.plein = p.barre:CreateTexture(nil, "ARTWORK")
	p.barre.plein:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 1)
	p.barre.plein:SetPoint("TOPLEFT", 1, -1)
	p.barre.plein:SetPoint("BOTTOMLEFT", 1, 1)
	p.pourcent = UI.Texte(p, "GameFontHighlightSmall", C.ors)
	p.pourcent:SetPoint("RIGHT", p.barre, "LEFT", -8, 0)
	p.pourcent:SetJustifyH("RIGHT")

	p.recherche = UI.Champ(p, 170, "Monstre, zone, objet…")
	p.recherche:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -60)
	p.recherche.SurTexte = function(t)
		recherche = Simplifier(strtrim(t or ""))
		p.liste:Haut()
		MajBientot()
	end
	p.recherche.saisie:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
		recherche = ""
		MajBientot()
	end)
	p.puces = UI.Puces(p, FILTRES, function(i)
		filtre = i
		p.puces:Choisir(i)
		p.liste:Haut()
		p.Maj()
	end)
	p.puces:SetPoint("LEFT", p.recherche, "RIGHT", 10, 0)
	p.puces:Choisir(filtre)
	-- zones : toutes ou la mienne (une zone précise : la recherche lit aussi le nom de la zone)
	p.zone = UI.Choix(p, 140, { { "toutes", "Toutes les zones" }, { "ici", "Ma zone" } }, function(v)
		zoneChoisie = v
		p.liste:Haut()
		p.Maj()
	end)
	p.zone:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -60)
	p.zone:Poser(zoneChoisie)

	p.fiche = CreerFiche(p)

	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, HAUT_LISTE)
	p.liste:SetPoint("BOTTOMRIGHT", p.fiche, "BOTTOMLEFT", -10, 0)
	p.liste:SetScript("OnVerticalScroll", function() Dessiner() end)
	p.liste:HookScript("OnMouseWheel", function() Dessiner() end)
	p.liste:HookScript("OnSizeChanged", function() Dessiner() end)
	p.rangees = {}
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.vide:SetPoint("RIGHT", p.liste, "RIGHT", -4, 0)
	p.vide:SetWordWrap(true)

	p.Dessiner = Dessiner
	p.MajFiche = MajFiche
	p.Maj = function()
		local b = Bestiaire()
		local s = MonScore()
		Construire()
		local g = Guilde()
		local nGuilde = 0
		for _ in pairs(g and g.d or {}) do nGuilde = nGuilde + 1 end
		local d = { ("%sCapturés : %d|r sur %d"):format(VERT, s.k, b.nombre), "vus : " .. s.v, "dépouillés : " .. s.d }
		if s.hors > 0 then d[#d + 1] = "hors liste : " .. s.hors end
		if g then d[#d + 1] = "guilde : " .. nGuilde end
		p.sous:SetText(table.concat(d, GRIS .. " · |r"))
		local part = b.nombre > 0 and s.k / b.nombre or 0
		p.pourcent:SetText((("%.1f %%"):format(100 * part):gsub("%.", ",")))
		p.barre.plein:SetWidth(math.max(1, 198 * math.min(1, part)))
		p.liste:Hauteur(#affiches * PAS)
		Dessiner()
		p.vide:SetShown(#affiches == 0)
		p.vide:SetText(recherche ~= "" and "Aucun monstre ne correspond à ta recherche (les monstres inconnus se cherchent par leur zone)."
			or "Aucun monstre ici.")
		MajFiche()
	end
	-- ns.OuvrirInterface("wowdex", pnj) : la fiche d'un monstre
	p.Ouvrir = function(id)
		id = tonumber(id)
		if not id then return end
		choisi = id
		p.Maj()
		for i, a in ipairs(affiches) do
			if (a.hors or a.id) == id then
				p.liste:SetVerticalScroll(math.max(0, (i - 3) * PAS))
				Dessiner()
				break
			end
		end
	end
	p:SetScript("OnShow", function() p.Maj() end)
	return p
end
if ns.AjouterPage then ns.AjouterPage("wowdex", CreerPage) end

--------------------------------------------------------------------------------
-- /smb diag
--------------------------------------------------------------------------------

ns.DiagWowdex = function(L)
	local s = MonScore()
	local g = Guilde()
	local nGuilde, nScores = 0, 0
	for _ in pairs(g and g.d or {}) do nGuilde = nGuilde + 1 end
	for _ in pairs(g and g.s or {}) do nScores = nScores + 1 end
	L(("wowdex : %d monstres au bestiaire, moi %d vus / %d capturés / %d dépouillés (%d hors liste), guilde %d capturés, %d scores, journal de combat %s, sources du butin %s"):format(
		Bestiaire().nombre, s.v, s.k, s.d, s.hors, nGuilde, nScores,
		CombatLogGetCurrentEventInfo and "oui" or "non", GetLootSourceInfo and "oui" or "non"))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "UPDATE_MOUSEOVER_UNIT", "PLAYER_TARGET_CHANGED",
	"NAME_PLATE_UNIT_ADDED", "LOOT_OPENED", "COMBAT_LOG_EVENT_UNFILTERED" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
-- (mort de la cible pendant qu'elle est ciblée : aucun changement de cible)
-- (sort de récolte qui va ouvrir un butin : dépeçage, vol à la tire…)
pcall(ev.RegisterUnitEvent, ev, "UNIT_SPELLCAST_SUCCEEDED", "player")
if not pcall(ev.RegisterUnitEvent, ev, "UNIT_HEALTH", "target") then
	pcall(ev.RegisterUnitEvent, ev, "UNIT_HEALTH_FREQUENT", "target")
end
local premiere = true
ev:SetScript("OnEvent", function(_, evenement, unite, _, sort)
	if evenement == "COMBAT_LOG_EVENT_UNFILTERED" then
		JournalCombat()
	elseif evenement == "UPDATE_MOUSEOVER_UNIT" then
		pcall(Observer, "mouseover")
	elseif evenement == "PLAYER_TARGET_CHANGED" then
		pcall(Observer, "target")
	elseif evenement == "NAME_PLATE_UNIT_ADDED" then
		pcall(Vu, unite)
	elseif evenement == "UNIT_HEALTH" or evenement == "UNIT_HEALTH_FREQUENT" then
		if UnitIsDead("target") then pcall(Observer, "target") end
	elseif evenement == "UNIT_SPELLCAST_SUCCEEDED" then
		pcall(SortLance, sort)
	elseif evenement == "LOOT_OPENED" then
		local ok, err = pcall(Fouiller)
		if not ok and ns.Erreur then ns.Erreur("WoWdex : " .. tostring(err)) end
	elseif evenement == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		-- (la guilde et la liste de ses membres ne sont pas connues tout de suite)
		C_Timer.After(30, function()
			local g = Guilde()
			if g then
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
