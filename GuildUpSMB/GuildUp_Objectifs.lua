-- GuildUpSMB : objectifs de quête sur les barres de nom des ennemis.
-- Un « ! » à droite de la barre de nom d'un ennemi (PNJ attaquable) qu'il faut tuer ou dépouiller pour
-- une quête en cours : jaune pour moi, bleu pour un membre de mon groupe, vert pour les deux.
-- D'où vient l'information :
--   * GuildUp_ObjectifsQuetes.lua (tiré de QuestieDB, version Forever) : pour chaque quête, les monstres
--     à tuer et ceux qui lâchent les objets demandés, dans l'ordre des objectifs du jeu. Croisé avec mon
--     journal de quêtes (objectifs pas encore terminés) : la liste des monstres dont j'ai besoin, par
--     numéro de PNJ (lu dans le GUID de l'unité) ;
--   * l'infobulle de l'unité telle que le jeu la construit (C_TooltipInfo.GetUnit), en complément :
--     objectifs pas terminés, et en groupe ceux de chaque coéquipier sous son nom ;
--   * en secours (ni données ni infobulle), mes objectifs « à tuer » dont le texte contient le nom du monstre ;
--   * les coéquipiers qui ont SMB Forever envoient au groupe la liste des monstres dont ils ont besoin
--     (préfixe "GuildUpObj", canal PARTY ou RAID, numéros de PNJ en base 36) :
--       "I~version~part~total~id,id,..."  ma liste, en morceaux (vide = plus rien), quand elle change
--                                         (au plus une fois toutes les 2 s)
--       "Q"                               « renvoyez vos listes » (à mon arrivée dans un groupe)
-- Réglage : GuildUpDB.objectifsPlaques (/smb objectifs). /smb diag : ce que le client fournit.
-- Les valeurs du jeu peuvent être cachées (« secrètes ») sur ce client, surtout en combat : chaque
-- lecture est protégée, le numéro de PNJ d'une barre est relevé dès son apparition, et une barre dont
-- on ne peut rien lire garde son dernier état.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpObj"
local DELAI_ENVOI = 2

local COULEURS = {
	moi    = { 1.00, 0.82, 0.00 }, -- jaune des quêtes
	groupe = { 0.40, 0.70, 1.00 }, -- bleu du groupe
	deux   = { 0.35, 0.95, 0.40 }, -- vert : moi et un membre du groupe
}

local function DB() return ns.DB and ns.DB() end
local function Actif()
	local db = DB()
	return db and db.objectifsPlaques ~= false
end
local function MonNom() return UnitName("player") end
local Base36 = ns.Base36 or function(n) return tostring(n) end

--------------------------------------------------------------------------------
-- Données des quêtes (GuildUp_ObjectifsQuetes.lua)
--------------------------------------------------------------------------------

local DONNEES = ns.OBJECTIFS_QUETES and ("\n" .. ns.OBJECTIFS_QUETES) or nil
local quetesLues = {} -- [quête] = { tuer = { {pnj,…}, … }, butin = { { objet, pnj = {…} }, … } } ou false

local function Nombres(texte)
	local l = {}
	for n in (texte or ""):gmatch("%d+") do l[#l + 1] = tonumber(n) end
	return l
end

local function DonneesQuete(id)
	if quetesLues[id] ~= nil then return quetesLues[id] or nil end
	local ligne = DONNEES and DONNEES:match("\n" .. id .. "|([^\n]*)")
	if not ligne then quetesLues[id] = false; return nil end
	local tuer, butin = ligne:match("^([^|]*)|([^|]*)")
	local q = { tuer = {}, butin = {} }
	for groupe in ((tuer or "") .. ";"):gmatch("([^;]*);") do
		if groupe ~= "" then q.tuer[#q.tuer + 1] = Nombres(groupe) end
	end
	for objet, pnj in ((butin or "") .. ";"):gmatch("(%d+):([^;]*);") do
		q.butin[#q.butin + 1] = { objet = tonumber(objet), pnj = Nombres(pnj) }
	end
	quetesLues[id] = q
	return q
end

-- Mes quêtes en cours : { { id, complete, objectifs = { { texte, genre, fini }, … } }, … }
local function MesQuetes()
	local l = {}
	if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo and C_QuestLog.GetQuestObjectives then
		for i = 1, C_QuestLog.GetNumQuestLogEntries() or 0 do
			local info = C_QuestLog.GetInfo(i)
			if info and not info.isHeader and info.questID then
				local q = { id = info.questID, objectifs = {} }
				q.complete = C_QuestLog.IsComplete and C_QuestLog.IsComplete(info.questID) or false
				for _, o in ipairs(C_QuestLog.GetQuestObjectives(info.questID) or {}) do
					q.objectifs[#q.objectifs + 1] = { texte = o.text, genre = o.type, fini = o.finished }
				end
				l[#l + 1] = q
			end
		end
	elseif GetNumQuestLogEntries and GetQuestLogTitle and GetNumQuestLeaderBoards and GetQuestLogLeaderBoard then
		for i = 1, (GetNumQuestLogEntries()) or 0 do
			local _, _, _, enTete, _, complete, _, id = GetQuestLogTitle(i)
			if not enTete and id then
				local q = { id = id, complete = complete == 1, objectifs = {} }
				for j = 1, GetNumQuestLeaderBoards(i) or 0 do
					local texte, genre, fini = GetQuestLogLeaderBoard(j, i)
					q.objectifs[#q.objectifs + 1] = { texte = texte, genre = genre, fini = fini }
				end
				l[#l + 1] = q
			end
		end
	end
	return l
end

-- k-ième objectif du jeu de ce genre (« monster », « item »), ou nil
local function ObjectifDuGenre(q, genre, k)
	local n = 0
	for _, o in ipairs(q.objectifs) do
		if o.genre == genre then
			n = n + 1
			if n == k then return o end
		end
	end
end

local mesPnj = {}        -- [numéro de PNJ] = true : monstres dont j'ai besoin (données + journal)
local textesATuer = {}   -- secours : textes de mes objectifs « à tuer » pas terminés

-- Relit mon journal : monstres dont j'ai besoin. Un objectif des données est rapproché du k-ième objectif
-- du même genre dans le jeu ; s'il est terminé, ses monstres ne comptent plus.
local function CalculerMesBesoins()
	local pnj, textes = {}, {}
	for _, q in ipairs(MesQuetes()) do
		for _, o in ipairs(q.objectifs) do
			if not o.fini and o.genre == "monster" and type(o.texte) == "string" and o.texte ~= "" then
				textes[#textes + 1] = o.texte
			end
		end
		local d = not q.complete and DonneesQuete(q.id)
		if d then
			for k, ids in ipairs(d.tuer) do
				local o = ObjectifDuGenre(q, "monster", k)
				if not (o and o.fini) then
					for _, id in ipairs(ids) do pnj[id] = true end
				end
			end
			for k, b in ipairs(d.butin) do
				local o = ObjectifDuGenre(q, "item", k)
				if not (o and o.fini) then
					for _, id in ipairs(b.pnj) do pnj[id] = true end
				end
			end
		end
	end
	return pnj, textes
end

--------------------------------------------------------------------------------
-- Lecture d'une unité : numéro de PNJ, infobulle
--------------------------------------------------------------------------------

-- numéro de PNJ d'une unité (« Creature-0-…-<pnj>-<instance> »), nil si illisible
local function NumeroPnj(unit)
	local guid = UnitGUID(unit)
	if type(guid) ~= "string" then return nil end
	local genre, id = guid:match("^(%a+)%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")
	if genre == "Creature" or genre == "Vehicle" then return tonumber(id) end
end

local TYPES = Enum and Enum.TooltipDataLineType
local T_TITRE = TYPES and TYPES.QuestTitle
local T_OBJECTIF = TYPES and TYPES.QuestObjective
local T_JOUEUR = TYPES and TYPES.QuestPlayer

-- Objectif encore à faire ? (champ « completed » si le jeu le donne, sinon « 3/10 » dans le texte)
local function ObjectifAFaire(ligne)
	if ligne.completed ~= nil then return not ligne.completed end
	local a, b = tostring(ligne.leftText or ""):match("(%d+)%s*/%s*(%d+)")
	if a and b then return tonumber(a) < tonumber(b) end
	return true
end

-- Renvoie moi (bool), autres ([nom court] = true), lu (false si l'infobulle n'a rien donné d'exploitable)
local function LireInfobulle(unit)
	if not (C_TooltipInfo and C_TooltipInfo.GetUnit and T_OBJECTIF) then return false, {}, false end
	local data = C_TooltipInfo.GetUnit(unit)
	if type(data) ~= "table" or type(data.lines) ~= "table" then return false, {}, false end
	local moi, autres = false, {}
	local qui = nil      -- nil = moi (lignes sous le titre), sinon le nom du coéquipier
	local monNom = MonNom()
	for _, ligne in ipairs(data.lines) do
		if ligne.args and TooltipUtil and TooltipUtil.SurfaceArgs then pcall(TooltipUtil.SurfaceArgs, ligne) end
		local t = ligne.type
		if t == T_TITRE then
			qui = nil
		elseif t == T_JOUEUR then
			local nom = ligne.leftText
			nom = nom and (ns.NomCourt and ns.NomCourt(nom) or nom)
			qui = (nom and nom ~= monNom) and nom or nil
		elseif t == T_OBJECTIF and ObjectifAFaire(ligne) then
			if qui then autres[qui] = true else moi = true end
		end
	end
	return moi, autres, true
end

--------------------------------------------------------------------------------
-- Groupe : ce que veulent les coéquipiers, et ma liste envoyée au groupe
--------------------------------------------------------------------------------

local besoinsGroupe = {} -- [nom court du coéquipier] = { [numéro de PNJ] = true }
local signatureEnvoyee = nil
local envoiPrevu = false
local reassembleur = ns.Reassembleur and ns.Reassembleur(8)

local function DansMonGroupe(nom)
	if not (IsInGroup and IsInGroup()) then return false end
	if ns.Groupes and ns.Groupes.DansMonGroupe then return ns.Groupes.DansMonGroupe(nom) end
	return ((UnitInParty and UnitInParty(nom)) or (UnitInRaid and UnitInRaid(nom))) and true or false
end

local function CanalGroupe()
	if IsInRaid and IsInRaid() then return "RAID" end
	if IsInGroup and IsInGroup() then return "PARTY" end
end

local function Envoyer(force)
	local canal = CanalGroupe()
	if not canal or not ns.EnvoyerAddon then return end
	local mots = {}
	for id in pairs(mesPnj) do mots[#mots + 1] = Base36(id) end
	table.sort(mots)
	local signature = table.concat(mots, ",")
	if not force and signature == signatureEnvoyee then return end
	signatureEnvoyee = signature
	local morceaux = ns.Morceaux and ns.Morceaux(mots, 200) or { signature }
	local version = Base36(math.random(1, 1295))
	for i, m in ipairs(morceaux) do
		ns.EnvoyerAddon(PREFIXE, ("I~%s~%d~%d~%s"):format(version, i, #morceaux, m), canal)
	end
end

local function PlanifierEnvoi(force)
	if envoiPrevu then return end
	envoiPrevu = true
	C_Timer.After(DELAI_ENVOI, function()
		envoiPrevu = false
		Envoyer(force)
	end)
end

--------------------------------------------------------------------------------
-- Le « ! » sur les barres de nom
--------------------------------------------------------------------------------

local marques = {}     -- [cadre de barre de nom] = cadre du « ! »
local etats = {}       -- [cadre de barre de nom] = "moi" / "groupe" / "deux" / nil (dernier état connu)
local pnjPlaques = {}  -- [cadre de barre de nom] = numéro de PNJ relevé à son apparition
local cacheNoms = {}   -- [nom de l'ennemi] = { moi, autres, lu } : infobulle déjà lue (vidé quand les quêtes changent)

local function Marque(plaque)
	local m = marques[plaque]
	if m then return m end
	m = CreateFrame("Frame", nil, plaque)
	m:SetSize(16, 24)
	m:SetFrameLevel((plaque:GetFrameLevel() or 0) + 20)
	m.texte = m:CreateFontString(nil, "OVERLAY")
	local police = (GameFontNormal and GameFontNormal:GetFont()) or "Fonts\\FRIZQT__.TTF"
	m.texte:SetFont(police, 22, "OUTLINE")
	m.texte:SetPoint("CENTER")
	m.texte:SetText("!")
	m:Hide()
	marques[plaque] = m
	return m
end

local function Placer(m, plaque)
	m:ClearAllPoints()
	local uf = plaque.UnitFrame
	local barre = uf and not (uf.IsForbidden and uf:IsForbidden()) and (uf.healthBar or uf.HealthBarsContainer)
	-- case du niveau à droite de la barre de vie (« 12 ») : le « ! » se met après elle
	local niveau = barre and (uf.PlayerLevelDiffFrame or uf.LevelFrame)
	if niveau and niveau.IsShown and niveau:IsShown() then
		m:SetPoint("LEFT", niveau, "RIGHT", 3, 0)
	elseif barre and barre:IsShown() and uf:IsShown() then
		m:SetPoint("LEFT", barre, "RIGHT", 4, 0)
	else
		m:SetPoint("LEFT", plaque, "RIGHT", -4, 0)
	end
end

local function TexteContient(liste, nom)
	for _, texte in ipairs(liste) do
		if texte:find(nom, 1, true) then return true end
	end
	return false
end

-- État d'un ennemi : "moi", "groupe", "deux" ou nil ; et false si rien n'a pu être lu
local function EtatUnite(unit, plaque)
	if not UnitCanAttack("player", unit) or UnitIsPlayer(unit) then return nil, true end
	if UnitIsDead and UnitIsDead(unit) then return nil, true end
	local okId, id = pcall(NumeroPnj, unit)
	id = okId and id or pnjPlaques[plaque]
	if id then pnjPlaques[plaque] = id end
	local moi = id and mesPnj[id] or false
	local groupe = false
	if id and IsInGroup and IsInGroup() then
		for qui, ids in pairs(besoinsGroupe) do
			if ids[id] and DansMonGroupe(qui) then groupe = true; break end
		end
	end
	-- infobulle (et secours par le nom) quand les données n'ont pas déjà tout dit
	if not (moi and (groupe or not (IsInGroup and IsInGroup()))) then
		local okNom, nom = pcall(UnitName, unit)
		if okNom and type(nom) == "string" and nom ~= "" then
			local c = cacheNoms[nom]
			if not c then
				local ok, m, autres, lu = pcall(LireInfobulle, unit)
				if not ok then m, autres, lu = false, {}, false end
				c = { moi = m, autres = autres, lu = lu }
				cacheNoms[nom] = c
			end
			if c.moi then moi = true end
			if not moi and not c.lu and not (id and DONNEES) then moi = TexteContient(textesATuer, nom) end
			if not groupe and IsInGroup and IsInGroup() then
				for qui in pairs(c.autres) do
					if DansMonGroupe(qui) then groupe = true; break end
				end
			end
		elseif not id then
			return nil, false
		end
	end
	if moi and groupe then return "deux", true end
	if moi then return "moi", true end
	if groupe then return "groupe", true end
	return nil, true
end

local function MajPlaque(plaque, unit)
	if not plaque or (plaque.IsForbidden and plaque:IsForbidden()) then return end
	local m = marques[plaque]
	if not Actif() or not unit then
		if m then m:Hide() end
		etats[plaque] = nil
		return
	end
	local ok, etat, lu = pcall(EtatUnite, unit, plaque)
	if not ok or lu == false then etat = etats[plaque] end -- rien de lisible : on garde le dernier état
	etats[plaque] = etat
	if not etat then
		if m then m:Hide() end
		return
	end
	m = Marque(plaque)
	local c = COULEURS[etat]
	m.texte:SetTextColor(c[1], c[2], c[3])
	Placer(m, plaque)
	m:Show()
end

local function MajUnite(unit)
	if not (unit and C_NamePlate and C_NamePlate.GetNamePlateForUnit) then return end
	local plaque = C_NamePlate.GetNamePlateForUnit(unit)
	if plaque then MajPlaque(plaque, unit) end
end

local function ToutMettreAJour()
	if not (C_NamePlate and C_NamePlate.GetNamePlates) then return end
	for _, plaque in ipairs(C_NamePlate.GetNamePlates() or {}) do
		local unit = plaque.namePlateUnitToken or (plaque.UnitFrame and plaque.UnitFrame.unit)
		MajPlaque(plaque, unit)
	end
end

-- Les quêtes ou le groupe ont changé : tout relire (regroupé)
local relecturePrevue = false
local function Relire()
	if relecturePrevue then return end
	relecturePrevue = true
	C_Timer.After(0.5, function()
		relecturePrevue = false
		wipe(cacheNoms)
		local ok, pnj, textes = pcall(CalculerMesBesoins)
		if ok then
			mesPnj, textesATuer = pnj, textes
			if IsInGroup and IsInGroup() then PlanifierEnvoi() end
		end
		ToutMettreAJour()
	end)
end
ns.MajObjectifsPlaques = Relire

--------------------------------------------------------------------------------
-- Réseau (groupe)
--------------------------------------------------------------------------------

local function Recevoir(prefixe, msg, canal, expediteur)
	if not msg or not expediteur then return end
	local qui = ns.NomCourt and ns.NomCourt(expediteur) or expediteur
	if qui == MonNom() and not (ns.TestSolo and ns.TestSolo()) then return end
	if msg == "Q" then
		PlanifierEnvoi(true)
		return
	end
	local version, part, total, texte = msg:match("^I~([^~]*)~(%d+)~(%d+)~(.*)$")
	if not version then return end
	part, total = tonumber(part), tonumber(total)
	local morceaux = reassembleur and reassembleur:Ajouter(qui, version, part, total, texte)
		or (total == 1 and { texte } or nil)
	if not morceaux then return end
	local ids = {}
	for _, m in ipairs(morceaux) do
		for mot in m:gmatch("[%w]+") do
			local id = tonumber(mot, 36)
			if id then ids[id] = true end
		end
	end
	besoinsGroupe[qui] = ids
	ToutMettreAJour()
end
ns.Ecouter(PREFIXE, Recevoir, { PARTY = true, RAID = true })

ns.DiagObjectifs = function(L)
	local n, g = 0, 0
	for _ in pairs(mesPnj) do n = n + 1 end
	for _ in pairs(besoinsGroupe) do g = g + 1 end
	local exemple
	local unit = UnitExists("target") and "target" or nil
	if unit then
		local ok, id = pcall(NumeroPnj, unit)
		exemple = ok and tostring(id) or "illisible"
	end
	L(("objectifs : %s ; données %s ; infobulle=%s (types %s/%s/%s) ; %d monstre(s) dont j'ai besoin ; listes de %d coéquipier(s) ; PNJ de la cible : %s"):format(
		Actif() and "affichés" or "coupés", DONNEES and "chargées" or "absentes",
		tostring(C_TooltipInfo ~= nil and C_TooltipInfo.GetUnit ~= nil),
		tostring(T_TITRE), tostring(T_OBJECTIF), tostring(T_JOUEUR), n, g, exemple or "pas de cible"))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "QUEST_LOG_UPDATE", "UNIT_QUEST_LOG_CHANGED",
	"QUEST_REMOVED", "QUEST_TURNED_IN", "QUEST_ACCEPTED", "GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_WORLD" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local dansGroupe = false
ev:SetScript("OnEvent", function(_, event, arg1)
	if event == "NAME_PLATE_UNIT_ADDED" then
		local plaque = C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(arg1)
		if plaque then pnjPlaques[plaque] = nil; etats[plaque] = nil end
		-- le jeu n'a pas toujours fini de remplir l'unité : une image plus tard
		C_Timer.After(0, function() MajUnite(arg1) end)
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		local plaque = C_NamePlate and C_NamePlate.GetNamePlateForUnit and C_NamePlate.GetNamePlateForUnit(arg1)
		if plaque then
			etats[plaque], pnjPlaques[plaque] = nil, nil
			if marques[plaque] then marques[plaque]:Hide() end
		end
	elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
		local enGroupe = IsInGroup and IsInGroup() or false
		-- coéquipiers partis : on oublie leurs listes
		for qui in pairs(besoinsGroupe) do
			if not enGroupe or not DansMonGroupe(qui) then besoinsGroupe[qui] = nil end
		end
		if enGroupe and not dansGroupe then
			-- arrivée dans un groupe : on demande les listes et on envoie la mienne
			local canal = CanalGroupe()
			if canal and ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, "Q", canal) end
			PlanifierEnvoi(true)
		end
		if not enGroupe then signatureEnvoyee = nil end
		dansGroupe = enGroupe
		Relire()
	else
		-- QUEST_LOG_UPDATE, UNIT_QUEST_LOG_CHANGED, QUEST_ACCEPTED, QUEST_REMOVED, QUEST_TURNED_IN
		Relire()
	end
end)
