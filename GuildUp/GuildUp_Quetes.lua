-- GuildUp : quêtes en commun avec la guilde.
-- Chaque GuildUp envoie la liste des quêtes en cours du joueur (identifiants), préfixe "GuildUpQst" :
--   "L~id,id,..."  ma liste (identifiants en base 36), à la connexion et quand elle change
--   "Q"            « envoyez vos listes » (à la connexion)
-- La fenêtre « Quêtes en commun » (style parchemin, comme le journal de quêtes) montre mes quêtes
-- que d'autres membres font aussi, avec un bouton « Créer un groupe » : l'annonce de groupe
-- (GuildUp_Groupes.lua) prévient par une bulle les membres qui ont cette quête.

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
				if a.quetes[id] and EstEnLigne(cle) then noms[#noms + 1] = NomCourt(a.nom) end
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
-- Fenêtre « Quêtes en commun » : parchemin, comme le journal de quêtes
--------------------------------------------------------------------------------

local fen
local lignes = {}
-- panneau accroché à droite de la fenêtre des groupes : moins large, du niveau de la ligne
-- « Contenu / Places » jusqu'en bas, collé contre le bord droit des groupes (sans espace)
local LARGEUR, HAUTEUR = 330, 455
local HAUT_PANNEAU = -80     -- = haut de l'encart de la fenêtre des groupes
local RECOUVREMENT = 9       -- décalage vers la gauche : les deux cadres se touchent
local HAUTEUR_LIGNE = 58
local function Partages()
	local res = {}
	for id, q in pairs(mesQuetes) do
		local membres = {}
		for cle, a in pairs(autres) do
			if a.quetes[id] then
				membres[#membres + 1] = { cle = cle, nom = a.nom, enLigne = EstEnLigne(cle) }
			end
		end
		if #membres > 0 then
			table.sort(membres, function(x, y)
				if x.enLigne ~= y.enLigne then return x.enLigne end
				return x.nom < y.nom
			end)
			res[#res + 1] = { id = id, titre = q.titre, zone = q.zone, niveau = q.niveau, membres = membres }
		end
	end
	table.sort(res, function(a, b)
		if (a.zone or "") ~= (b.zone or "") then return (a.zone or "") < (b.zone or "") end
		return a.titre < b.titre
	end)
	return res
end

-- Fenêtre « Quêtes en commun », dans le style de la page « Récit du lieu » (addon Spoken) :
-- cadre de panneau du jeu (DefaultPanelFlatTemplate), parchemin des détails de quête, contour
-- et filigrane du journal de quêtes, encre brune. Uniquement des images du jeu (atlas).
local ENCRE = { 0.25, 0.16, 0.08 }        -- l'encre du grimoire (SPELLBOOK_FONT_COLOR)
if SPELLBOOK_FONT_COLOR and SPELLBOOK_FONT_COLOR.GetRGB then ENCRE = { SPELLBOOK_FONT_COLOR:GetRGB() } end
local ENCRE_CLAIRE = { 0.42, 0.30, 0.17 } -- zones, sous-titre
local VERT_ENCRE = "|cff1a5c0f"           -- membre connecté
local GRIS_ENCRE = "|cff6e5a44"           -- membre hors ligne

local function Encre(fs, c)
	c = c or ENCRE
	fs:SetTextColor(c[1], c[2], c[3])
	fs:SetShadowColor(0, 0, 0, 0)   -- pas d'ombre noire sur le parchemin
end

-- Pose un atlas ; renvoie faux s'il n'existe pas sur ce client
local function Atlas(tex, nom, tailleAtlas)
	if AtlasExiste(nom) then tex:SetAtlas(nom, tailleAtlas); return true end
	return false
end

-- Contour en 9 morceaux d'un atlas (coins à leur taille, bords étirés) : comme le jeu le dessine
local function NeufMorceaux(cadre, nom, part, couche)
	local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(nom)
	if not info then return false end
	local fichier = info.file or info.filename
	if not fichier then return false end
	local l, r, t, b = info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord
	local du, dv = (r - l) * part, (b - t) * part
	local u = { l, l + du, r - du, r }
	local v = { t, t + dv, b - dv, b }
	local w, h = math.floor(info.width * part + 0.5), math.floor(info.height * part + 0.5)
	local g = {}
	for rang = 1, 3 do
		g[rang] = {}
		for col = 1, 3 do
			local p = cadre:CreateTexture(nil, couche)
			p:SetTexture(fichier)
			p:SetTexCoord(u[col], u[col + 1], v[rang], v[rang + 1])
			g[rang][col] = p
		end
	end
	local hg, hd, bg, bd = g[1][1], g[1][3], g[3][1], g[3][3]
	for _, c in ipairs({ hg, hd, bg, bd }) do c:SetSize(w, h) end
	hg:SetPoint("TOPLEFT"); hd:SetPoint("TOPRIGHT"); bg:SetPoint("BOTTOMLEFT"); bd:SetPoint("BOTTOMRIGHT")
	local function Entre(p, a, pa, z, pz) p:SetPoint("TOPLEFT", a, pa); p:SetPoint("BOTTOMRIGHT", z, pz) end
	Entre(g[1][2], hg, "TOPRIGHT", hd, "BOTTOMLEFT")
	Entre(g[3][2], bg, "TOPRIGHT", bd, "BOTTOMLEFT")
	Entre(g[2][1], hg, "BOTTOMLEFT", bg, "TOPRIGHT")
	Entre(g[2][3], hd, "BOTTOMLEFT", bd, "TOPRIGHT")
	Entre(g[2][2], hg, "BOTTOMRIGHT", bd, "TOPLEFT")
	g[2][2]:Hide() -- le milieu du contour : le parchemin est dessous
	return true
end

local function PoserParchemin(tex)
	for _, nom in ipairs({ "QuestDetailsBackgrounds", "spellbook-Page-Right-C60", "QuestBG-Parchment" }) do
		if Atlas(tex, nom) then return end
	end
	tex:SetTexture("Interface\\QuestFrame\\QuestBG")
	tex:SetTexCoord(0, 0.586, 0, 0.65)
end

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

local function CreerLigne(parent)
	local b = CreateFrame("Frame", nil, parent)
	b:SetSize(LARGEUR - 70, HAUTEUR_LIGNE - 4)
	b:EnableMouse(true)
	local survol = b:CreateTexture(nil, "BACKGROUND")
	survol:SetAllPoints(b)
	survol:SetColorTexture(0.55, 0.35, 0.1, 0.10)
	survol:Hide()
	b:SetScript("OnEnter", function(self)
		survol:Show()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.q.titre)
		if self.q.niveau and self.q.niveau > 0 then GameTooltip:AddLine("Niveau " .. self.q.niveau, 1, 0.82, 0) end
		if self.q.zone then GameTooltip:AddLine(self.q.zone, 0.8, 0.8, 0.8) end
		GameTooltip:AddLine(" ")
		for _, m in ipairs(self.q.membres) do
			if m.enLigne then
				local zone = enLigne[m.cle] and enLigne[m.cle].zone
				GameTooltip:AddLine("|cff33dd55●|r " .. NomCourt(m.nom) .. (zone and ("  |cff999999" .. zone .. "|r") or ""), 1, 1, 1)
			else
				GameTooltip:AddLine("|cff888888○ " .. NomCourt(m.nom) .. " (hors ligne)|r", 1, 1, 1)
			end
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Clic : ouvrir dans le journal de quêtes", 0.6, 0.6, 0.6)
		GameTooltip:AddLine("Maj-clic : lien dans la discussion", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() survol:Hide(); GameTooltip:Hide() end)
	b:SetScript("OnMouseUp", function(self, bouton)
		if bouton ~= "LeftButton" or not self.q then return end
		local id = self.q.id
		if IsModifiedClick and IsModifiedClick("CHATLINK") then
			local lien = (C_QuestLog and C_QuestLog.GetQuestLink and C_QuestLog.GetQuestLink(id))
				or (GetQuestLink and GetQuestLink(id))
			if lien and ChatEdit_InsertLink then ChatEdit_InsertLink(lien) end
			return
		end
		OuvrirJournal(id)
	end)

	b.titre = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.titre:SetPoint("TOPLEFT", b, "TOPLEFT", 4, -5)
	b.titre:SetPoint("RIGHT", b, "RIGHT", -76, 0)
	b.titre:SetJustifyH("LEFT")
	b.titre:SetWordWrap(false)
	Encre(b.titre)
	b.zone = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	b.zone:SetPoint("TOPLEFT", b.titre, "BOTTOMLEFT", 0, -2)
	b.zone:SetPoint("RIGHT", b, "RIGHT", -76, 0)
	b.zone:SetJustifyH("LEFT")
	b.zone:SetWordWrap(false)
	Encre(b.zone, ENCRE_CLAIRE)
	b.membres = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	b.membres:SetPoint("TOPLEFT", b.zone, "BOTTOMLEFT", 0, -3)
	b.membres:SetPoint("RIGHT", b, "RIGHT", -76, 0)
	b.membres:SetJustifyH("LEFT")
	b.membres:SetWordWrap(false)
	b.membres:SetShadowColor(0, 0, 0, 0)

	b.groupe = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.groupe:SetSize(70, 22)
	b.groupe:SetPoint("RIGHT", b, "RIGHT", -2, 0)
	b.groupe:SetText("Groupe")
	b.groupe:SetScript("OnClick", function(self)
		local q = self:GetParent().q
		if q and ns.CreerGroupeQuete then ns.CreerGroupeQuete(q.id, q.titre, q.zone) end
	end)
	b.groupe:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Créer un groupe pour cette quête")
		GameTooltip:AddLine("Publie une annonce dans les groupes de la guilde. Les membres qui ont cette quête sont prévenus par une bulle.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	b.groupe:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- séparateur à l'encre du grimoire entre les quêtes
	b.filet = b:CreateTexture(nil, "ARTWORK")
	b.filet:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 0, -3)
	b.filet:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, -3)
	if Atlas(b.filet, "spellbook-divider") then
		b.filet:SetHeight(6)
	else
		b.filet:SetColorTexture(ENCRE_CLAIRE[1], ENCRE_CLAIRE[2], ENCRE_CLAIRE[3], 0.35)
		b.filet:SetHeight(1)
	end
	if ns.SonsSurBoutons then ns.SonsSurBoutons(b) end
	return b
end

MajFenetre = function()
	if not fen or not fen:IsVisible() then return end
	local liste = Partages()
	local y = 0
	for i, q in ipairs(liste) do
		local b = lignes[i] or CreerLigne(fen.contenu)
		lignes[i] = b
		b.q = q
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", fen.contenu, "TOPLEFT", 0, -y)
		b.titre:SetText((q.niveau and q.niveau > 0) and ("[" .. q.niveau .. "] " .. q.titre) or q.titre)
		b.zone:SetText(q.zone or "")
		local noms = {}
		for _, m in ipairs(q.membres) do
			noms[#noms + 1] = (m.enLigne and VERT_ENCRE or GRIS_ENCRE) .. NomCourt(m.nom) .. "|r"
		end
		b.membres:SetText(table.concat(noms, ", "))
		b:Show()
		y = y + HAUTEUR_LIGNE
	end
	for i = #liste + 1, #lignes do lignes[i]:Hide() end
	fen.contenu:SetHeight(math.max(10, y))
	fen.vide:SetShown(#liste == 0)
end

-- hote : la fenêtre des groupes, à droite de laquelle le panneau est accroché
local function CreerFenetre(hote)
	-- cadre de panneau du jeu (titre, sans bouton de fermeture : il se ferme avec les groupes),
	-- enfant de la fenêtre des groupes
	local ok, f = pcall(CreateFrame, "Frame", "GuildUpQuetes", hote, "DefaultPanelFlatTemplate")
	local gabarit = ok and f and f.SetTitle
	if gabarit then
		f:SetTitle("Quêtes en commun")
	else
		ok, f = pcall(CreateFrame, "Frame", "GuildUpQuetes", hote, "BasicFrameTemplateWithInset")
		if not ok then f = CreateFrame("Frame", "GuildUpQuetes", hote, "BackdropTemplate") end
		if f.CloseButton then f.CloseButton:Hide() end
		local t = f.TitleText or f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		if not f.TitleText then t:SetPoint("TOP", f, "TOP", 0, -6) end
		t:SetText("Quêtes en commun")
	end
	f:SetSize(LARGEUR, HAUTEUR)
	-- collé à droite des groupes : il suit la fenêtre (la glisser déplace les deux), s'ouvre et se
	-- ferme avec elle
	f:SetPoint("TOPLEFT", hote, "TOPRIGHT", -RECOUVREMENT, HAUT_PANNEAU)
	f:SetPoint("BOTTOMLEFT", hote, "BOTTOMRIGHT", -RECOUVREMENT, 0)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function() if hote:IsMovable() then hote:StartMoving() end end)
	f:SetScript("OnDragStop", function() hote:StopMovingOrSizing() end)

	-- la page : parchemin sous le titre, entourée du cadre et du filigrane du journal de quêtes
	local page = CreateFrame("Frame", nil, f)
	page:SetPoint("TOPLEFT", f, "TOPLEFT", gabarit and 7 or 8, gabarit and -25 or -28)
	page:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", gabarit and -5 or -8, gabarit and 6 or 8)
	-- fond parchemin clair sous l'image : le fond sombre du cadre ne transparaît plus (voile brun)
	local base = page:CreateTexture(nil, "BACKGROUND", nil, -8)
	base:SetAllPoints(page)
	base:SetColorTexture(0.93, 0.86, 0.71, 1)
	local parchemin = page:CreateTexture(nil, "BACKGROUND")
	parchemin:SetAllPoints(page)
	PoserParchemin(parchemin)
	local bord = CreateFrame("Frame", nil, page)
	bord:SetPoint("TOPLEFT", page, "TOPLEFT", -2, 3)
	bord:SetPoint("BOTTOMRIGHT", page, "BOTTOMRIGHT", 2, -3)
	bord:SetFrameLevel(page:GetFrameLevel() + 12)
	NeufMorceaux(bord, "questlog-frame", 56 / 214, "OVERLAY")
	local filigrane = bord:CreateTexture(nil, "OVERLAY", nil, 1)
	if Atlas(filigrane, "questlog-frame-filigree", true) then filigrane:SetPoint("TOP", bord, "TOP", 0, 1) end

	-- en-tête : grand titre et sous-titre à l'encre, puis le séparateur du grimoire
	local grand = page:CreateFontString(nil, "OVERLAY", _G.QuestTitleFont and "QuestTitleFont" or "GameFontNormalLarge")
	grand:SetPoint("TOPLEFT", page, "TOPLEFT", 22, -24)
	grand:SetText("Avec la guilde")
	Encre(grand)
	local sous = page:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	sous:SetPoint("TOPLEFT", grand, "BOTTOMLEFT", 0, -4)
	sous:SetWidth(LARGEUR - 60)
	sous:SetJustifyH("LEFT")
	sous:SetText("Tes quêtes que d'autres membres font aussi (vert = connecté)")
	Encre(sous, ENCRE_CLAIRE)
	local separation = page:CreateTexture(nil, "ARTWORK")
	separation:SetPoint("TOPLEFT", sous, "BOTTOMLEFT", -6, -8)
	separation:SetPoint("RIGHT", page, "RIGHT", -18, 0)
	if Atlas(separation, "spellbook-divider") then
		separation:SetHeight(8)
	else
		separation:SetColorTexture(ENCRE[1], ENCRE[2], ENCRE[3], 0.5)
		separation:SetHeight(1)
	end

	local defile = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", separation, "BOTTOMLEFT", 6, -8)
	defile:SetPoint("BOTTOMRIGHT", page, "BOTTOMRIGHT", -30, 14)
	f.contenu = CreateFrame("Frame", nil, defile)
	f.contenu:SetSize(LARGEUR - 70, 10)
	defile:SetScrollChild(f.contenu)
	f.vide = page:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.vide:SetPoint("TOP", defile, "TOP", 0, -40)
	f.vide:SetWidth(LARGEUR - 90)
	Encre(f.vide, ENCRE_CLAIRE)
	f.vide:SetText("Aucun membre de la guilde (avec GuildUp) ne fait les mêmes quêtes que toi pour l'instant.")
	f:SetScript("OnShow", function()
		if C_GuildInfo and C_GuildInfo.GuildRoster then pcall(C_GuildInfo.GuildRoster) elseif GuildRoster then pcall(GuildRoster) end
		MajFenetre()
	end)
	return f
end

-- Appelé par GuildUp_Groupes.lua à la création de sa fenêtre
ns.CreerPanneauQuetes = function(hote)
	if not fen then fen = CreerFenetre(hote) end
	return fen
end

-- Bouton « Quêtes » du volet, bulles : la fenêtre des groupes (avec les quêtes à droite)
ns.BasculerQuetes = function(ouvrir)
	if ouvrir then
		if ns.OuvrirGroupes then ns.OuvrirGroupes() end
	elseif ns.BasculerGroupes then
		ns.BasculerGroupes()
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
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "QUEST_LOG_UPDATE", "GUILD_ROSTER_UPDATE" }) do
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
