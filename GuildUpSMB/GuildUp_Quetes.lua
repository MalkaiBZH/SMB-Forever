-- GuildUpSMB : quêtes en commun avec la guilde.
-- Chaque GuildUpSMB envoie la liste des quêtes en cours du joueur (identifiants), préfixe "GuildUpQst" :
--   "L~id,id,..."  ma liste (identifiants en base 36), à la connexion et quand elle change
--   "Q"            « envoyez vos listes » (à la connexion)
-- La page « Quêtes en commun » de la fenêtre GuildUpSMB montre mes quêtes que d'autres membres font
-- aussi, avec un bouton « Créer un groupe » : l'annonce de groupe (GuildUp_Groupes.lua) prévient par
-- une bulle les membres qui ont cette quête. Déjà en groupe : « Inviter » (membres en ligne qui ont la
-- quête et ne sont pas dans mon groupe, ns.Groupes.DansMonGroupe) ou « Déjà groupés » (tous y sont).

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpQst"
local MAX_QUETES = 35         -- tient dans un message (255 caractères)

local mesQuetes = {}          -- [id] = { titre, zone }
local autres = {}             -- [nom normalisé] = { nom, quetes = { [id] = true }, vu }
local signature = nil
local pret = false
local dernierEnvoi = 0
local MajFenetre

local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local TestSolo = ns.TestSolo
local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local AtlasExiste = ns.AtlasExiste

local Base36 = ns.Base36

--------------------------------------------------------------------------------
-- Mes quêtes (titre + zone : les en-têtes du journal de quêtes sont les zones)
--------------------------------------------------------------------------------

-- Le journal ne liste que les lignes visibles : les quêtes d'une zone repliée n'y sont pas.
-- On garde donc celles qu'on connaissait déjà (« avant », gardées aussi d'une session à l'autre)
-- quand leur zone est repliée, sauf si le jeu dit qu'on ne les a plus (C_QuestLog.IsOnQuest).
local function LireQuetes(avant)
	local t, repliees = {}, {}
	local zone
	if C_QuestLog and C_QuestLog.GetNumQuestLogEntries and C_QuestLog.GetInfo then
		for i = 1, (C_QuestLog.GetNumQuestLogEntries() or 0) do
			local info = C_QuestLog.GetInfo(i)
			if info and info.isHeader then
				zone = info.title
				if info.isCollapsed and zone then repliees[zone] = true end
			elseif info and info.questID and info.questID > 0 then
				t[info.questID] = { titre = info.title or ("Quête " .. info.questID), zone = zone, niveau = info.level }
			end
		end
	elseif GetNumQuestLogEntries and GetQuestLogTitle then
		for i = 1, (GetNumQuestLogEntries() or 0) do
			local titre, niveau, _, entete, repliee, _, _, id = GetQuestLogTitle(i)
			if entete then
				zone = titre
				if repliee and zone then repliees[zone] = true end
			elseif id and id > 0 then
				t[id] = { titre = titre, zone = zone, niveau = niveau }
			end
		end
	end
	local enCours = C_QuestLog and C_QuestLog.IsOnQuest
	for id, q in pairs(avant or {}) do
		if not t[id] and type(q) == "table" and q.zone and repliees[q.zone] then
			local garder = true
			if enCours then
				local ok, oui = pcall(enCours, id)
				if ok then garder = oui and true or false end
			end
			if garder then t[id] = q end
		end
	end
	return t
end

-- Mes quêtes connues, par personnage (pour les zones repliées dès la connexion)
local function QuetesGardees()
	local db = ns.DB and ns.DB()
	if not db then return {} end
	if type(db.quetesPerso) ~= "table" then db.quetesPerso = {} end
	local cle = MaCle()
	if not cle then return {} end
	if type(db.quetesPerso[cle]) ~= "table" then db.quetesPerso[cle] = {} end
	return db.quetesPerso[cle], db.quetesPerso, cle
end

-- Pour GuildUp_Groupes.lua : ai-je cette quête ? et son titre (mon journal, sinon le jeu)
ns.AQuete = function(id) return mesQuetes[id] ~= nil end
ns.InfoQuete = function(id)
	local q = mesQuetes[id]
	if q then return q.titre, q.zone end
	if C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local ok, titre = pcall(C_QuestLog.GetTitleForQuestID, id)
		if ok and titre then return titre end
	end
end

local function Liste(t)
	local ids = {}
	for id in pairs(t) do ids[#ids + 1] = id end
	table.sort(ids)
	return ids
end

local function Emettre(force)
	local ids = Liste(mesQuetes)
	local mots = {}
	for i = 1, math.min(#ids, MAX_QUETES) do mots[i] = Base36(ids[i]) end
	local texte = table.concat(mots, ",")
	if not force and texte == signature then return end
	signature = texte
	Envoyer("L~" .. texte)
	dernierEnvoi = GetTime()
end

-- Membres connectés de la guilde (liste de guilde)
local enLigne = {}
local function LireRoster()
	if not IsInGuild() or not GetNumGuildMembers then return end
	wipe(enLigne)
	for i = 1, (GetNumGuildMembers() or 0) do
		local nom, _, _, _, _, zone, _, _, connecte = GetGuildRosterInfo(i)
		local cle = nom and Normaliser(nom)
		if cle and connecte then enLigne[cle] = { nom = nom, zone = zone } end
	end
end
local function EstEnLigne(cle)
	if cle:find("#test", 1, true) then return true end
	return enLigne[cle] ~= nil
end

-- Mes quêtes ont changé : prévenir la guilde, et bulle si un membre connecté a la nouvelle quête
local function MajMesQuetes()
	local avant = mesQuetes
	mesQuetes = LireQuetes(next(avant) and avant or QuetesGardees())
	local _, toutes, cle = QuetesGardees()
	if toutes and cle then toutes[cle] = mesQuetes end
	if not pret then return end
	for id, q in pairs(mesQuetes) do
		if not avant[id] then
			local noms = {}
			for cle, a in pairs(autres) do
				if a.quetes[id] and EstEnLigne(cle) then noms[#noms + 1] = NomJoueur(a.nom) end
			end
			if #noms > 0 and ns.Notifier then
				ns.Notifier("quetes", "Quête en commun", ("%s fait aussi : |cffffd100%s|r"):format(table.concat(noms, ", "), q.titre),
					nil, function() if ns.BasculerQuetes then ns.BasculerQuetes(true) end end)
			end
		end
	end
	Emettre(false)
	if MajFenetre then MajFenetre() end
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle, nom = Normaliser(expediteur), expediteur
	if cle == MaCle() then
		if not TestSolo() then return end
		cle, nom = cle .. "#test", expediteur .. " (test)"
	end
	local genre = msg:sub(1, 1)
	if genre == "Q" then
		if pret and GetTime() - dernierEnvoi > 5 then
			C_Timer.After(1 + math.random() * 4, function() Emettre(true) end)
		end
	elseif genre == "L" then
		local quetes = {}
		for mot in (msg:sub(3) or ""):gmatch("[^,]+") do
			local id = tonumber(mot, 36)
			if id then quetes[id] = true end
		end
		autres[cle] = { nom = nom, quetes = quetes, vu = time() }
		if MajFenetre then MajFenetre() end
	end
end

--------------------------------------------------------------------------------
-- Page « Quêtes en commun » de la fenêtre GuildUpSMB (style sombre et doré, kit ns.UI)
--------------------------------------------------------------------------------

-- Chaque quête : membres qui l'ont (groupe = déjà dans mon groupe), et aInviter = ceux qui sont en ligne
-- mais pas encore dans mon groupe (le bouton de la ligne en dépend : Créer un groupe / Inviter / Déjà groupés)
local function Partages()
	local res = {}
	local DansMonGroupe = IsInGroup and IsInGroup() and ns.Groupes and ns.Groupes.DansMonGroupe
	for id, q in pairs(mesQuetes) do
		local membres, aInviter, groupes = {}, {}, 0
		for cle, a in pairs(autres) do
			if a.quetes[id] then
				local m = { cle = cle, nom = a.nom, enLigne = EstEnLigne(cle) }
				m.groupe = DansMonGroupe and DansMonGroupe(a.nom) or false
				if m.groupe then groupes = groupes + 1
				elseif m.enLigne then aInviter[#aInviter + 1] = m end
				membres[#membres + 1] = m
			end
		end
		if #membres > 0 then
			table.sort(membres, function(x, y)
				if x.groupe ~= y.groupe then return x.groupe end
				if x.enLigne ~= y.enLigne then return x.enLigne end
				return x.nom < y.nom
			end)
			res[#res + 1] = { id = id, titre = q.titre, zone = q.zone, niveau = q.niveau, membres = membres,
				aInviter = aInviter, groupes = groupes }
		end
	end
	table.sort(res, function(a, b)
		if (a.zone or "") ~= (b.zone or "") then return (a.zone or "") < (b.zone or "") end
		return a.titre < b.titre
	end)
	return res
end
ns.QuetesEnCommun = Partages -- mes quêtes faites aussi par d'autres membres (accueil de la fenêtre GuildUpSMB)

-- Ouvre le journal de quêtes du jeu sur cette quête
local function OuvrirJournal(id)
	if QuestMapFrame_OpenToQuestDetails then
		if pcall(QuestMapFrame_OpenToQuestDetails, id) then return end
	end
	local index = C_QuestLog and C_QuestLog.GetLogIndexForQuestID and C_QuestLog.GetLogIndexForQuestID(id)
	if not index and GetQuestLogIndexByID then index = GetQuestLogIndexByID(id) end
	if QuestLogFrame and not QuestLogFrame:IsShown() then
		if ToggleQuestLog then pcall(ToggleQuestLog) else pcall(ShowUIPanel, QuestLogFrame) end
	end
	if index and index > 0 then
		if C_QuestLog and C_QuestLog.SetSelectedQuest then pcall(C_QuestLog.SetSelectedQuest, id) end
		if SelectQuestLogEntry then pcall(SelectQuestLogEntry, index) end
		if QuestLog_Update then pcall(QuestLog_Update) end
		if QuestLog_SetSelection then pcall(QuestLog_SetSelection, index) end
	end
end

local UI = ns.UI
local C = UI.C
local MARGE, HAUTEUR_LIGNE = 16, 70

local function InfobulleQuete(self)
	local q = self.q
	if not q then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(q.titre)
	if q.niveau and q.niveau > 0 then GameTooltip:AddLine("Niveau " .. q.niveau, 1, 0.82, 0) end
	if q.zone then GameTooltip:AddLine(q.zone, 0.8, 0.8, 0.8) end
	GameTooltip:AddLine(" ")
	for _, m in ipairs(q.membres) do
		if m.enLigne then
			local zone = enLigne[m.cle] and enLigne[m.cle].zone
			GameTooltip:AddLine("|cff33dd55●|r " .. NomJoueur(m.nom) .. (zone and ("  |cff999999" .. zone .. "|r") or ""), 1, 1, 1)
		else
			GameTooltip:AddLine("|cff888888○ " .. NomJoueur(m.nom) .. " (hors ligne)|r", 1, 1, 1)
		end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Clic : ouvrir dans le journal de quêtes", 0.6, 0.6, 0.6)
	GameTooltip:AddLine("Maj-clic : lien dans la discussion", 0.6, 0.6, 0.6)
	GameTooltip:Show()
end

local function CreerLigne(parent)
	local r = UI.Rangee(parent, HAUTEUR_LIGNE - 6)
	r.icone = r:CreateTexture(nil, "ARTWORK")
	r.icone:SetSize(36, 36)
	r.icone:SetPoint("LEFT", r, "LEFT", 12, 0)
	r.icone:SetTexture("Interface\\Icons\\INV_Misc_Note_06")
	r.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	r.groupe = UI.Bouton(r, "Créer un groupe", "or", 130, 28)
	r.groupe:SetPoint("RIGHT", r, "RIGHT", -12, 0)
	r.groupe:SetScript("OnClick", function(self)
		local q = self:GetParent().q
		if not q then return end
		if self.action == "inviter" then
			-- déjà en groupe : on invite directement ceux qui ont la quête et sont en ligne
			local inviter = (C_PartyInfo and C_PartyInfo.InviteUnit) or InviteUnit
			if inviter then
				for _, m in ipairs(q.aInviter or {}) do pcall(inviter, m.nom) end
			end
		elseif self.action == "creer" and ns.CreerGroupeQuete then
			ns.CreerGroupeQuete(q.id, q.titre, q.zone)
		end
	end)
	r.groupe:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if self.action == "groupes" then
			GameTooltip:SetText("Déjà groupés")
			GameTooltip:AddLine("Les membres en ligne qui ont cette quête sont déjà dans ton groupe.", 1, 1, 1, true)
		elseif self.action == "inviter" then
			GameTooltip:SetText("Inviter dans ton groupe")
			local q = self:GetParent().q
			local noms = {}
			for _, m in ipairs(q and q.aInviter or {}) do noms[#noms + 1] = NomJoueur(m.nom) end
			GameTooltip:AddLine("Invite " .. table.concat(noms, ", ") .. " : ils ont cette quête et sont en ligne.", 1, 1, 1, true)
		else
			GameTooltip:SetText("Créer un groupe pour cette quête")
			GameTooltip:AddLine("Publie une annonce dans les groupes de la guilde. Les membres qui ont cette quête sont prévenus par une bulle.", 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	r.groupe:SetScript("OnLeave", function() GameTooltip:Hide() end)
	r.titre = UI.Texte(r, "GameFontNormal", C.texte)
	r.titre:SetPoint("TOPLEFT", r.icone, "TOPRIGHT", 12, 2)
	r.titre:SetPoint("RIGHT", r.groupe, "LEFT", -12, 0)
	r.zone = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.zone:SetPoint("TOPLEFT", r.titre, "BOTTOMLEFT", 0, -4)
	r.zone:SetPoint("RIGHT", r.groupe, "LEFT", -12, 0)
	r.membres = UI.Texte(r, "GameFontHighlightSmall")
	r.membres:SetPoint("TOPLEFT", r.zone, "BOTTOMLEFT", 0, -4)
	r.membres:SetPoint("RIGHT", r.groupe, "LEFT", -12, 0)
	r:SetScript("OnEnter", InfobulleQuete)
	r:SetScript("OnLeave", function() GameTooltip:Hide() end)
	r:RegisterForClicks("LeftButtonUp")
	r:SetScript("OnClick", function(self)
		if not self.q then return end
		local id = self.q.id
		if IsModifiedClick and IsModifiedClick("CHATLINK") then
			local lien = (C_QuestLog and C_QuestLog.GetQuestLink and C_QuestLog.GetQuestLink(id))
				or (GetQuestLink and GetQuestLink(id))
			if lien and ChatEdit_InsertLink then ChatEdit_InsertLink(lien) end
			return
		end
		OuvrirJournal(id)
	end)
	return r
end

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -18)
	titre:SetText("Quêtes en commun")
	local aide = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	aide:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	aide:SetText("Tes quêtes que d'autres membres font aussi (|cff6fd08cvert|r = connecté). Crée un groupe : ceux qui ont la quête sont prévenus.")
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -70)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE + 6, 12)
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.vide:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	p.vide:SetWordWrap(true)
	p.vide:SetText("Aucun membre de la guilde (avec SMB Forever) ne fait les mêmes quêtes que toi pour l'instant.")
	p.lignes = {}
	-- à l'ouverture : qui est en ligne (la liste de guilde n'est sinon relue qu'à la connexion)
	p:SetScript("OnShow", function()
		if C_GuildInfo and C_GuildInfo.GuildRoster then pcall(C_GuildInfo.GuildRoster) elseif GuildRoster then pcall(GuildRoster) end
	end)
	p.Maj = function()
		local liste = Partages()
		local y = 0
		for i, q in ipairs(liste) do
			local r = p.lignes[i]
			if not r then r = CreerLigne(p.liste.contenu); p.lignes[i] = r end
			r.q = q
			r.titre:SetText((q.niveau and q.niveau > 0) and ("|cff999999[" .. q.niveau .. "]|r " .. q.titre) or q.titre)
			r.zone:SetText(q.zone or "")
			local noms = {}
			for _, m in ipairs(q.membres) do
				noms[#noms + 1] = (m.enLigne and "|cff6fd08c" or "|cff8a826f") .. NomJoueur(m.nom) .. "|r"
					.. (m.groupe and " |cfff1cf6b(groupe)|r" or "")
			end
			r.membres:SetText(table.concat(noms, ", "))
			-- bouton : déjà groupé avec tous ceux en ligne ; en groupe avec d'autres à inviter (chef ou
			-- assistant) ; sinon créer une annonce de groupe
			local enGroupe = IsInGroup and IsInGroup()
			local peutInviter = not enGroupe or UnitIsGroupLeader("player")
				or (UnitIsGroupAssistant and UnitIsGroupAssistant("player"))
			if q.groupes > 0 and #q.aInviter == 0 then
				r.groupe.action = "groupes"
				r.groupe:Ecrire("Déjà groupés")
				r.groupe:Activer(false)
			elseif enGroupe and #q.aInviter > 0 then
				r.groupe.action = "inviter"
				r.groupe:Ecrire(#q.aInviter > 1 and ("Inviter (" .. #q.aInviter .. ")") or "Inviter")
				r.groupe:Activer(peutInviter and true or false)
			else
				r.groupe.action = "creer"
				r.groupe:Ecrire("Créer un groupe")
				r.groupe:Activer(not enGroupe or UnitIsGroupLeader("player"))
			end
			r:ClearAllPoints()
			r:SetPoint("TOPLEFT", p.liste.contenu, "TOPLEFT", 0, -y)
			r:SetPoint("RIGHT", p.liste.contenu, "RIGHT", 0, 0)
			r:Show()
			y = y + HAUTEUR_LIGNE
		end
		for i = #liste + 1, #p.lignes do p.lignes[i]:Hide() end
		p.liste:Hauteur(y)
		p.vide:SetShown(#liste == 0)
	end
	return p
end
if ns.AjouterPage then ns.AjouterPage("quetes", CreerPage) end

-- la page se met à jour quand mes quêtes, celles des autres ou la liste de guilde changent
MajFenetre = function()
	if ns.PageInterface and ns.PageInterface() == "quetes" and ns.MajInterface then ns.MajInterface() end
end

-- /smb quetes, bulles : la page des quêtes en commun (ouvrir = toujours l'ouvrir ; sinon basculer)
ns.BasculerQuetes = function(ouvrir)
	if not ouvrir and ns.PageInterface and ns.PageInterface() == "quetes" then
		if ns.BasculerInterface then ns.BasculerInterface() end
	elseif ns.OuvrirInterface then
		ns.OuvrirInterface("quetes")
	end
end

ns.DiagQuetes = function(L)
	local n, partages = 0, 0
	for _ in pairs(autres) do n = n + 1 end
	local mes = 0
	for _ in pairs(mesQuetes) do mes = mes + 1 end
	for _ in ipairs(Partages()) do partages = partages + 1 end
	L(("quêtes : %d en cours, listes reçues de %d membre(s), %d quête(s) en commun ; C_QuestLog=%s"):format(
		mes, n, partages, tostring(C_QuestLog ~= nil and C_QuestLog.GetInfo ~= nil)))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "QUEST_LOG_UPDATE", "GUILD_ROSTER_UPDATE", "GROUP_ROSTER_UPDATE" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local premiere, prevu = true, false
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "QUEST_LOG_UPDATE" then
		-- évènement très fréquent : on regroupe
		if prevu then return end
		prevu = true
		C_Timer.After(2, function()
			prevu = false
			MajMesQuetes()
		end)
	elseif event == "GUILD_ROSTER_UPDATE" then
		LireRoster()
		if MajFenetre then MajFenetre() end
	elseif event == "GROUP_ROSTER_UPDATE" then
		-- quelqu'un rejoint ou quitte mon groupe : boutons Créer un groupe / Inviter / Déjà groupés
		if MajFenetre then MajFenetre() end
	elseif event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		C_Timer.After(14, function()
			mesQuetes = LireQuetes(next(mesQuetes) and mesQuetes or QuetesGardees())
			local _, toutes, cle = QuetesGardees()
			if toutes and cle then toutes[cle] = mesQuetes end
			pret = true
			LireRoster()
			Emettre(true)
			Envoyer("Q")
		end)
	end
end)
