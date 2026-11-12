-- GuildUp : passer un groupe de la guilde dans la recherche de groupe du jeu.
-- Onglet « Mon groupe » : choix du style de jeu + bouton « Rendre public », qui inscrit le groupe
-- comme la fenêtre « Annonce » du jeu : C_LFGList.CreateListing({ activityIDs, generalPlaystyle,
-- newPlayerFriendly, voiceMode }) (forme relevée sur Forever le 2026-11-10). Il faut un vrai clic.

local NOM_ADDON, ns = ...

local ACTIVITE_PERSO = 1064      -- catégorie « Personnalisé » de Forever
local STYLES = {                 -- Enum.LFGEntryGeneralPlaystyle
	{ 1, "Apprentissage" }, { 2, "Détente" }, { 3, "Sérieux" }, { 4, "Expert" },
}
local function NomStyle(v)
	local g = _G["GROUP_FINDER_GENERAL_PLAYSTYLE" .. tostring(v)]
	if type(g) == "string" and g ~= "" then return g end
	for _, s in ipairs(STYLES) do if s[1] == v then return s[2] end end
	return "?"
end

local function Erreur(t) if ns.Erreur then ns.Erreur(t) else print("GuildUp : " .. t) end end
local function DB() return ns.DB and ns.DB() end

local function StyleChoisi()
	local db = DB()
	local v = db and tonumber(db.styleJeu) or 2
	return (v >= 1 and v <= 4) and v or 2
end

local function EstInscrit()
	return C_LFGList and C_LFGList.HasActiveEntryInfo and select(2, pcall(C_LFGList.HasActiveEntryInfo)) == true
end

-- Activité du jeu pour notre annonce : « a<id> » = activité du jeu ; quête = son activité si le jeu
-- en a une ; sinon « Personnalisé »
local function ActiviteDe(code)
	local id = code and tonumber(code:match("^a(%d+)$"))
	if id then return id end
	local q = code and tonumber(code:match("^q(%d+)$"))
	if q and C_LFGList.GetActivityIDForQuestID then
		local ok, a = pcall(C_LFGList.GetActivityIDForQuestID, q)
		if ok and tonumber(a) and a > 0 then return a end
	end
	return ACTIVITE_PERSO
end

local inscritParNous = false     -- l'annonce publique vient de notre bouton

-- commentaire de l'annonce : la zone de texte de la fenêtre « Annonce » du jeu (le jeu la lit)
-- (sur Forever : une zone de texte sans nom, enfant de LFGListingComment, relevé le 2026-11-10)
local function ZoneCommentaire()
	local racine = _G.LFGListingComment
	if not racine then return nil end
	if racine.GetObjectType and racine:GetObjectType() == "EditBox" then return racine end
	if racine.EditBox then return racine.EditBox end
	local function Chercher(f, prof)
		if not f or prof > 3 or not f.GetChildren then return nil end
		for _, c in ipairs({ f:GetChildren() }) do
			if c.GetObjectType and c:GetObjectType() == "EditBox" then return c end
			local z = Chercher(c, prof + 1)
			if z then return z end
		end
	end
	return Chercher(racine, 0)
end

-- le jeu n'accepte le texte libre des annonces que sur un compte avec authentificateur
local function CommentaireAutorise()
	if not C_LFGList.IsPlayerAuthenticatedForLFG then return true end
	local ok, oui = pcall(C_LFGList.IsPlayerAuthenticatedForLFG)
	return not ok or oui ~= false
end

local function PoserCommentaire(texte)
	if not CommentaireAutorise() then return false end
	local zone = ZoneCommentaire()
	if zone and zone.SetText then
		pcall(zone.SetText, zone, texte or "")
		return true
	end
end

local function RendrePublic(annonce, nomContenu)
	if not (C_LFGList and C_LFGList.CreateListing) then Erreur("Recherche de groupe du jeu indisponible"); return end
	if InCombatLockdown() then Erreur("Impossible en combat"); return end
	if IsInGroup() and not UnitIsGroupLeader("player") then Erreur("Seul le chef du groupe peut inscrire le groupe"); return end
	local activite = ActiviteDe(annonce.code)
	local style = StyleChoisi()
	local com = annonce.commentaire ~= "" and annonce.commentaire or (nomContenu or "")
	local pose = PoserCommentaire(("[%s] %s"):format(NomStyle(style), com))
	if ns.NoterAppelRecherche then
		ns.NoterAppelRecherche(("GuildUp : bouton Rendre public (commentaire posé=%s)"):format(tostring(pose == true)))
	end
	local ok, err = pcall(C_LFGList.CreateListing, {
		activityIDs = { activite },
		generalPlaystyle = style,
		newPlayerFriendly = style == 1,
		voiceMode = 0,
	})
	if not ok then
		Erreur("Le jeu a refusé l'inscription : " .. tostring(err))
		return
	end
	inscritParNous = true
	if ns.Notifier then
		ns.Notifier("groupes", "Groupe public", ("Inscrit à la recherche du jeu (%s)"):format(NomStyle(style)))
	end
end

--------------------------------------------------------------------------------
-- Texture de l'anneau qui tourne autour du bouton de mini-carte : la première qui existe
--------------------------------------------------------------------------------

local ANNEAUX = {
	{ atlas = "groupfinder-eye-highlight", taille = 46 },
	{ atlas = "GarrLanding-CircleGlow", taille = 50 },
	{ atlas = "ChallengeMode-Runes-CircleGlow", taille = 50 },
	{ atlas = "Artifacts-PerkRing-WhiteGlow", taille = 48 },
	{ atlas = "worldquest-tracker-ring-selected", taille = 46 },
	{ fichier = "Interface\\Cooldown\\star4", taille = 46 },
}
local function AtlasExiste(nom)
	if C_Texture and C_Texture.GetAtlasInfo then
		local ok, info = pcall(C_Texture.GetAtlasInfo, nom)
		return ok and info ~= nil
	end
	return false
end
ns.TextureAnneau = function()
	for _, a in ipairs(ANNEAUX) do
		if a.fichier or AtlasExiste(a.atlas) then return a end
	end
end

-- Retire l'annonce publique (bouton, ou annonce de guilde retirée / groupe complet)
ns.RetirerPublic = function(force)
	if not (force or inscritParNous) then return end
	inscritParNous = false
	if EstInscrit() and C_LFGList.RemoveListing then pcall(C_LFGList.RemoveListing) end
end

--------------------------------------------------------------------------------
-- Contrôles de l'onglet « Mon groupe » : [Style : Détente ▾] [Rendre public]
--------------------------------------------------------------------------------

ns.CreerBoutonsPublic = function(parent)
	local c = {}

	-- choix du style : bouton qui ouvre une petite liste
	local style = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	style:SetSize(130, 28)
	c.style = style
	local liste = CreateFrame("Frame", nil, style, "BackdropTemplate")
	liste:SetFrameStrata("DIALOG")
	liste:SetPoint("BOTTOMLEFT", style, "TOPLEFT", 0, 2)
	liste:SetSize(130, #STYLES * 20 + 12)
	if liste.SetBackdrop then
		liste:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
			insets = { left = 3, right = 3, top = 3, bottom = 3 } })
		liste:SetBackdropColor(0.05, 0.05, 0.05, 0.95)
	end
	liste:Hide()
	for i, s in ipairs(STYLES) do
		local b = CreateFrame("Button", nil, liste)
		b:SetSize(120, 20)
		b:SetPoint("TOPLEFT", liste, "TOPLEFT", 5, -6 - (i - 1) * 20)
		b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		b.texte = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		b.texte:SetPoint("LEFT", b, "LEFT", 6, 0)
		b.texte:SetText(NomStyle(s[1]))
		b:SetScript("OnClick", function()
			local db = DB()
			if db then db.styleJeu = s[1] end
			liste:Hide()
			if c.maj then c.maj() end
		end)
	end
	style:SetScript("OnClick", function() liste:SetShown(not liste:IsShown()) end)
	style:SetScript("OnHide", function() liste:Hide() end)
	style:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Style de jeu")
		GameTooltip:AddLine("Affiché dans la recherche de groupe du jeu quand le groupe est public.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	style:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- rendre public / retirer du public
	local public = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	public:SetSize(120, 28)
	c.public = public
	public:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		if EstInscrit() then
			GameTooltip:SetText("Retirer du public")
			GameTooltip:AddLine("Retire le groupe de la recherche de groupe du jeu. L'annonce de guilde reste.", 1, 1, 1, true)
		else
			GameTooltip:SetText("Rendre public")
			GameTooltip:AddLine("Inscrit aussi le groupe dans la recherche de groupe du jeu : les joueurs hors guilde peuvent le trouver.", 1, 1, 1, true)
			if not CommentaireAutorise() then
				GameTooltip:AddLine("Sans authentificateur sur ton compte, le jeu n'affiche pas le commentaire (donjon et style seulement).", 1, 0.5, 0.3, true)
			end
		end
		GameTooltip:Show()
	end)
	public:SetScript("OnLeave", function() GameTooltip:Hide() end)

	c.maj = function(annonce, nomContenu)
		if annonce then c.annonce, c.nomContenu = annonce, nomContenu end
		style:SetText("Style : " .. NomStyle(StyleChoisi()))
		local inscrit = EstInscrit()
		public:SetText(inscrit and "Retirer du public" or "Rendre public")
		style:SetEnabled(not inscrit)
	end
	public:SetScript("OnClick", function()
		if EstInscrit() then
			ns.RetirerPublic(true)
		elseif c.annonce then
			RendrePublic(c.annonce, c.nomContenu)
		end
		C_Timer.After(0.5, function() c.maj() end)
	end)
	ns.majBoutonsPublic = c.maj
	return c
end

--------------------------------------------------------------------------------
-- Évènements : état de l'annonce, candidatures venues du public
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "LFG_LIST_ACTIVE_ENTRY_UPDATE", "LFG_LIST_APPLICANT_LIST_UPDATED" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local dernierNombre = 0
ev:SetScript("OnEvent", function(_, event)
	if event == "LFG_LIST_ACTIVE_ENTRY_UPDATE" then
		if not EstInscrit() then inscritParNous = false end
		if ns.majBoutonsPublic then ns.majBoutonsPublic() end
		if ns.MajBoutonCarte then ns.MajBoutonCarte() end -- anneau vert du bouton de mini-carte
	elseif event == "LFG_LIST_APPLICANT_LIST_UPDATED" then
		local ok, n = pcall(C_LFGList.GetNumApplicants)
		n = ok and tonumber(n) or 0
		if n > dernierNombre and ns.Notifier then
			ns.Notifier("candidatures", "Candidature publique", "Un joueur hors guilde veut rejoindre ton groupe", nil, function()
				if LFGParentFrame and not LFGParentFrame:IsShown() and ToggleLFGParentFrame then
					pcall(ToggleLFGParentFrame)
				elseif LFGParentFrame then
					pcall(ShowUIPanel, LFGParentFrame)
				end
			end)
		end
		dernierNombre = n
	end
end)

local function Champs(t)
	if type(t) ~= "table" then return tostring(t) end
	local cles = {}
	for k, v in pairs(t) do
		local s = type(v) == "table" and "{…}" or tostring(v)
		if #s > 30 then s = s:sub(1, 30) .. "…" end
		cles[#cles + 1] = tostring(k) .. "=" .. s
	end
	table.sort(cles)
	return table.concat(cles, ", ")
end

local function Appel(f, ...)
	if not f then return nil end
	local r = { pcall(f, ...) }
	if not r[1] then return nil, tostring(r[2]) end
	return select(2, unpack(r))
end

-- Espion : relève les appels de la fenêtre « Annonce » du jeu (forme exacte attendue par Forever)
local appels = {}
local function Decrire(...)
	local t = {}
	for i = 1, select("#", ...) do
		local v = select(i, ...)
		if type(v) == "table" then
			local champs = {}
			for k, x in pairs(v) do
				local s
				if type(x) == "table" then
					local l = {}
					for kk, xx in pairs(x) do l[#l + 1] = tostring(kk) .. ":" .. tostring(xx) end
					s = "{" .. table.concat(l, ",") .. "}"
				else
					s = tostring(x)
				end
				champs[#champs + 1] = tostring(k) .. "=" .. s
			end
			table.sort(champs)
			t[#t + 1] = "{" .. table.concat(champs, ", ") .. "}"
		else
			t[#t + 1] = type(v) == "string" and ("\"" .. v .. "\"") or tostring(v)
		end
	end
	return table.concat(t, ", ")
end
ns.NoterAppelRecherche = function(t)
	appels[#appels + 1] = t
	if #appels > 12 then table.remove(appels, 1) end
end
if type(C_LFGList) == "table" and hooksecurefunc then
	for _, nom in ipairs({ "CreateListing", "UpdateListing", "RemoveListing", "SetEntryTitle",
		"CopyActiveEntryInfoToCreationFields", "ClearCreationTextFields" }) do
		if C_LFGList[nom] then
			pcall(hooksecurefunc, C_LFGList, nom, function(...)
				appels[#appels + 1] = ("%s(%s)"):format(nom, Decrire(...))
				if #appels > 12 then table.remove(appels, 1) end
			end)
		end
	end
end

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

ns.DiagRecherche = function(L)
	local T = C_LFGList
	if type(T) ~= "table" then
		L("recherche du jeu : C_LFGList absent")
		return
	end
	-- fonctions disponibles
	local noms = {}
	for k, v in pairs(T) do if type(v) == "function" then noms[#noms + 1] = k end end
	table.sort(noms)
	L(("recherche : C_LFGList (%d fonctions) : %s"):format(#noms, table.concat(noms, " ")))

	-- fenêtres du jeu
	local fen = {}
	for _, n in ipairs({ "LFGListFrame", "PVEFrame", "LFGParentFrame", "LFGListingFrame", "LFGBrowseFrame",
		"GroupFinderFrame", "LFGFrame" }) do
		if _G[n] then fen[#fen + 1] = n end
	end
	L("recherche : fenêtres = " .. (#fen > 0 and table.concat(fen, " ") or "aucune"))

	-- styles de jeu
	for _, e in ipairs({ "LFGEntryPlaystyle", "LFGEntryGeneralPlaystyle", "LFGListDisplayType" }) do
		if Enum and Enum[e] then L("recherche : Enum." .. e .. " = " .. Champs(Enum[e])) end
	end
	if T.GetPlaystyleString then L("recherche : GetPlaystyleString existe") end

	-- catégories et activités
	local cats = { Appel(T.GetAvailableCategories) }
	if type(cats[1]) == "table" then cats = cats[1] end
	L(("recherche : %d catégorie(s)"):format(#cats))
	for _, c in ipairs(cats) do
		local info = Appel(T.GetLfgCategoryInfo, c)
		local nomC = type(info) == "table" and info.name or tostring((Appel(T.GetCategoryInfo, c)))
		local acts = Appel(T.GetAvailableActivities, c)
		acts = type(acts) == "table" and acts or {}
		local liste = {}
		for i, a in ipairs(acts) do
			local ai = Appel(T.GetActivityInfoTable, a)
			if type(ai) == "table" then
				liste[#liste + 1] = ("%d:%s(%s-%s,%s)"):format(a, tostring(ai.fullName or ai.shortName),
					tostring(ai.minLevel or ai.minLevelSuggestion or "?"), tostring(ai.maxLevel or ai.maxLevelSuggestion or "?"),
					tostring(ai.maxNumPlayers or "?"))
			else
				liste[#liste + 1] = tostring(a)
			end
		end
		L(("recherche : cat %s « %s » [%s] : %d activité(s) : %s"):format(tostring(c), tostring(nomC),
			type(info) == "table" and Champs(info) or "", #acts, table.concat(liste, " ; ")))
	end
	-- champs d'une activité (pour connaître le format exact)
	if cats[1] then
		local acts = Appel(T.GetAvailableActivities, cats[1])
		if type(acts) == "table" and acts[1] then
			L("recherche : exemple d'activité = " .. Champs((Appel(T.GetActivityInfoTable, acts[1]))))
		end
	end

	-- annonce en cours (si le groupe est déjà inscrit)
	local actif = Appel(T.HasActiveEntryInfo)
	L("recherche : annonce active = " .. tostring(actif) .. ", authentifié pour le texte = " .. tostring((Appel(T.IsPlayerAuthenticatedForLFG))))
	if actif then L("recherche : annonce = " .. Decrire((Appel(T.GetActiveEntryInfo)))) end
	-- animations 2D de la recherche de groupe (œil, anneaux)
	local vfx = {}
	for _, n in ipairs({ "groupfinder-eye-frame", "groupfinder-eye-highlight", "groupfinder-eye-flipbook-searching",
		"groupfinder-eye-flipbook-initial", "groupfinder-eye-flipbook-foundfx", "groupfinder-eye-flipbook-mouseover",
		"groupfinder-eye-flipbook-poke-initial", "groupfinder-eye-single", "GarrLanding-CircleGlow",
		"ChallengeMode-Runes-CircleGlow", "Artifacts-PerkRing-WhiteGlow", "worldquest-tracker-ring-selected" }) do
		vfx[#vfx + 1] = n .. "=" .. tostring(AtlasExiste(n))
	end
	L("recherche : vfx = " .. table.concat(vfx, ", "))
	local a = ns.TextureAnneau()
	L("recherche : anneau du bouton = " .. tostring(a and (a.atlas or a.fichier)) ..
		", œil du jeu = " .. tostring(_G.MiniMapLFGFrame ~= nil or _G.QueueStatusButton ~= nil or _G.LFGMinimapFrame ~= nil))
	-- appels relevés depuis le dernier /reload
	if #appels == 0 then
		L("recherche : aucun appel relevé (inscris un groupe à la main avec la fenêtre du jeu, puis refais /smb diag)")
	end
	for _, a in ipairs(appels) do L("recherche : appel " .. a) end
	-- zones de texte de la fenêtre « Annonce » (titre / commentaire)
	local zones = {}
	local function Fouiller(f, chemin, prof)
		if not f or prof > 4 or not f.GetChildren then return end
		for _, c in ipairs({ f:GetChildren() }) do
			local n = c.GetName and c:GetName() or nil
			if c.GetObjectType and c:GetObjectType() == "EditBox" then
				zones[#zones + 1] = (n or (chemin .. ".?")) .. "=\"" .. tostring(c:GetText()) .. "\""
			end
			Fouiller(c, n or chemin, prof + 1)
		end
	end
	pcall(Fouiller, LFGListingFrame, "LFGListingFrame", 0)
	L("recherche : zones de texte de l'annonce = " .. (#zones > 0 and table.concat(zones, " ; ") or "aucune"))
end
