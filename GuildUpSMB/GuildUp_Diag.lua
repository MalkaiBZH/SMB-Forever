-- GuildUpSMB : outils de diagnostic, pour comprendre le client Forever et préparer les données
-- (mode Debug : /smb debug). Rien ici ne sert au jeu normal.

local NOM_ADDON, ns = ...

-- Discord : le client Forever expose-t-il quelque chose aux addons ? (fonctions, tables, réglages)
ns.DiagDiscord = function(L)
	local trouves, tables = {}, {}
	for nom, v in pairs(_G) do
		if type(nom) == "string" then
			local bas = nom:lower()
			if bas:find("discord", 1, true) then
				trouves[#trouves + 1] = nom .. "(" .. type(v) .. ")"
			end
			-- espaces de fonctions C_… : on regarde aussi leurs fonctions
			if type(v) == "table" and nom:sub(1, 2) == "C_" then
				for f in pairs(v) do
					if type(f) == "string" and f:lower():find("discord", 1, true) then
						tables[#tables + 1] = nom .. "." .. f
					end
				end
			end
		end
	end
	table.sort(trouves)
	table.sort(tables)
	L("discord : globales = " .. (#trouves > 0 and table.concat(trouves, " ") or "aucune"))
	L("discord : fonctions C_ = " .. (#tables > 0 and table.concat(tables, " ") or "aucune"))
	-- réglages et commandes de la console qui parlent de Discord ou de réseau social
	local cvars = {}
	if C_Console and C_Console.GetAllCommands then
		local ok, liste = pcall(C_Console.GetAllCommands)
		if ok and type(liste) == "table" then
			for _, c in ipairs(liste) do
				local nom = c.command or c.name
				if type(nom) == "string" and (nom:lower():find("discord", 1, true) or nom:lower():find("social", 1, true)) then
					cvars[#cvars + 1] = nom .. "=" .. tostring(GetCVar and select(2, pcall(GetCVar, nom)) or "?")
				end
			end
		end
	end
	L("discord : réglages = " .. (#cvars > 0 and table.concat(cvars, " ") or "aucun"))
	-- espaces sociaux connus (communautés, amis, réseaux) : présents ou non
	local sociaux = {}
	for _, n in ipairs({ "C_Club", "C_ClubFinder", "C_Social", "C_SocialRestrictions", "C_BattleNet", "C_FriendList",
		"C_SocialQueue", "C_ChatInfo" }) do
		sociaux[#sociaux + 1] = n .. "=" .. tostring(_G[n] ~= nil)
	end
	L("discord : espaces sociaux = " .. table.concat(sociaux, ", "))
end

-- Carnet de craft (à venir) : la base de Questie couvre-t-elle les matériaux d'artisanat ?
ns.DiagCarnet = function(L)
	local I, N, O = _G.ItemDB, _G.NpcDB, _G.ObjectDB
	L(("carnet : QuestieDB=%s ItemDB=%s NpcDB=%s ObjectDB=%s"):format(tostring(_G.LibQuestieDB ~= nil),
		tostring(I ~= nil), tostring(N ~= nil), tostring(O ~= nil)))
	if not I then return end
	local function nb(f, id)
		if not f then return "?" end
		local ok, t = pcall(f, id)
		if not ok then return "err" end
		return type(t) == "table" and tostring(#t) or tostring(t)
	end
	-- étoffe de lin (butin), fil grossier (marchand), minerai de cuivre (récolte), barre de cuivre (fabriqué),
	-- feuillargent (herbe), cuir léger (dépeçage)
	for _, id in ipairs({ 2589, 2320, 2770, 2840, 765, 2318 }) do
		local nom = I.name and select(2, pcall(I.name, id))
		L(("carnet : %d %s : monstres=%s marchands=%s objets=%s quêtes=%s"):format(id, tostring(nom),
			nb(I.npcDrops, id), nb(I.vendors, id), nb(I.objectDrops, id), nb(I.questRewards, id)))
	end
	-- un exemple de monstre et de point de récolte, pour le format des zones et positions
	local okN, npcs = pcall(I.npcDrops, 2589)
	if okN and type(npcs) == "table" and npcs[1] and N then
		local id = npcs[1]
		local okS, sp = pcall(N.spawns, id)
		local zones = {}
		if okS and type(sp) == "table" then for z, pts in pairs(sp) do zones[#zones + 1] = z .. "(" .. #pts .. ")" end end
		L(("carnet : monstre %d %s niv %s-%s, apparitions : %s"):format(id, tostring(select(2, pcall(N.name, id))),
			tostring(select(2, pcall(N.minLevel, id))), tostring(select(2, pcall(N.maxLevel, id))), table.concat(zones, " ")))
	end
	local okO, objs = pcall(I.objectDrops, 2770)
	if okO and type(objs) == "table" and objs[1] and O then
		local id = objs[1]
		local okS, sp = pcall(O.spawns, id)
		local zones = {}
		if okS and type(sp) == "table" then for z, pts in pairs(sp) do zones[#zones + 1] = z .. "(" .. #pts .. ")" end end
		L(("carnet : objet %d %s, apparitions : %s"):format(id, tostring(select(2, pcall(O.name, id))),
			table.concat(zones, " ")))
	end
end

