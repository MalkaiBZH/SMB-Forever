-- GuildUpSMB : bouton de la mini-carte, son volet (rôle, fenêtres, position, notifications) et les
-- bulles de notification (ns.Notifier).

local NOM_ADDON, ns = ...
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\" -- le dossier de l'addon, quel que soit son nom

-- GuildUpDB (réglages) : la table est chargée par GuildUp.lua (ADDON_LOADED) ; ce mandataire y donne
-- accès sous le même nom « db » (nil avant le chargement)
local db = setmetatable({}, {
	__index = function(_, k) local t = ns.DB(); return t and t[k] end,
	__newindex = function(_, k, v) local t = ns.DB(); if t then t[k] = v end end,
})
-- (fichiers chargés avant celui-ci)
local SonsSurBoutons, MonRole, RoleManuel, PoserRoleManuel, Annoncer = ns.Coeur.SonsSurBoutons, ns.Coeur.MonRole, ns.Coeur.RoleManuel, ns.Coeur.PoserRoleManuel, ns.Coeur.Annoncer
local ToutRafraichir, SurActivation = ns.Plaques.ToutRafraichir, ns.Plaques.SurActivation
local MajBarreRole -- icône et volet du bouton (défini plus bas)

--------------------------------------------------------------------------------
-- Bouton de mini-carte (comme les autres addons) :
--   collé au bord de la mini-carte, on le fait glisser pour le faire tourner autour ;
--   icône = rôle actuel ; clic gauche = volet (voir CreerVolet) ; clic droit = groupes.
--------------------------------------------------------------------------------

local ICONES_ROLE = {
	tank = { atlas = "UI-LFG-RoleIcon-Tank",   coords = { 0, 19 / 64, 22 / 64, 41 / 64 },       nom = "Tank" },
	heal = { atlas = "UI-LFG-RoleIcon-Healer", coords = { 20 / 64, 39 / 64, 1 / 64, 20 / 64 },  nom = "Heal" },
	dps  = { atlas = "UI-LFG-RoleIcon-DPS",    coords = { 20 / 64, 39 / 64, 22 / 64, 41 / 64 }, nom = "DPS" },
}

local function PoserIcone(tex, role)
	local i = ICONES_ROLE[role]
	if i and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(i.atlas) then
		tex:SetAtlas(i.atlas)
	elseif i then
		tex:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-ROLES")
		tex:SetTexCoord(i.coords[1], i.coords[2], i.coords[3], i.coords[4])
	else
		tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end
end

-- position (angle autour de la mini-carte), visibilité, volet ouvert
-- (hors DEFAUT : recréé après une réinitialisation)
local function ReglagesBarre()
	if type(db.barre) ~= "table" then db.barre = { visible = true } end
	local r = db.barre
	if r.visible == nil then r.visible = true end
	if type(r.angle) ~= "number" then r.angle = 225 end
	return r
end

local boutonCarte, volet

local function Infobulle(cadre, titre, texte)
	cadre:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(titre)
		if texte then GameTooltip:AddLine(texte, 1, 1, 1, true) end
		GameTooltip:Show()
	end)
	cadre:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function ChoisirRole(role)
	-- re-cliquer sur le rôle choisi à la main revient en automatique
	if RoleManuel() == role then PoserRoleManuel("auto") else PoserRoleManuel(role) end
	Annoncer(true)
	ToutRafraichir()
	if ns.MajOptions then ns.MajOptions() end
	if ns.SurChangementDeRole then ns.SurChangementDeRole() end
end
-- utilisé par la fenêtre des groupes (même choix que le bouton de mini-carte)
ns.ChoisirRole = function(role) if db then ChoisirRole(role) end end
ns.RoleChoisiALaMain = function() return db and RoleManuel() end

-- Taille du bouton de mini-carte (1 = celle des boutons des autres addons)
local ECHELLE_BOUTON = 1.3
-- Anneau vert qui tourne (texture media\anneau.tga de Miko, fournie) : activé par défaut.
-- false = repli sur le halo qui pulse en vert
local ANNEAU_CUSTOM = true

-- Place le bouton sur le bord de la mini-carte, à l'angle donné (en degrés). Les décalages d'un
-- cadre agrandi sont comptés à son échelle : on les divise pour rester au bon endroit.
local function PlacerSurLaCarte(angle)
	local rad = math.rad(angle)
	local rayon = (Minimap:GetWidth() / 2) + 10 + 6 * (ECHELLE_BOUTON - 1)
	boutonCarte:ClearAllPoints()
	boutonCarte:SetPoint("CENTER", Minimap, "CENTER",
		math.cos(rad) * rayon / ECHELLE_BOUTON, math.sin(rad) * rayon / ECHELLE_BOUTON)
end

-- Le volet s'ouvre du côté de l'écran (à gauche si le bouton est à gauche de la mini-carte, etc.)
local function PlacerVolet()
	if not volet then return end
	local cx = Minimap:GetCenter()
	local bx = boutonCarte:GetCenter()
	bx = bx and bx * ECHELLE_BOUTON -- même échelle que la mini-carte pour comparer
	volet:ClearAllPoints()
	if bx and cx and bx > cx then
		volet:SetPoint("LEFT", boutonCarte, "RIGHT", 2, 0)
	else
		volet:SetPoint("RIGHT", boutonCarte, "LEFT", -2, 0)
	end
end

-- Volet du bouton de mini-carte : pseudo et personnages, mon rôle (Tank / Heal / DPS), boutons des
-- fenêtres (groupes, artisanat, dons…), partage de position, activation de GuildUpSMB et
-- notifications (repliables)
local LARGEUR_VOLET = 206

local function CreerVolet()
	local v = CreateFrame("Frame", "GuildUpVoletRole", UIParent, "BackdropTemplate")
	v:SetFrameStrata("MEDIUM")
	v:SetFrameLevel(boutonCarte:GetFrameLevel() + 2)
	v:SetClampedToScreen(true)
	-- Échap ferme le volet (comme les fenêtres du jeu) ; fermé, il le reste au prochain affichage
	tinsert(UISpecialFrames, "GuildUpVoletRole")
	v:SetScript("OnHide", function()
		local r = ReglagesBarre()
		if r.ouvert then r.ouvert = false end
	end)
	v:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 14,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	v:SetBackdropColor(0, 0, 0, 0.85)

	-- filet doré horizontal entre deux lignes
	local function Filet(y)
		local t = v:CreateTexture(nil, "ARTWORK")
		t:SetColorTexture(1, 0.82, 0, 0.35)
		t:SetHeight(1)
		t:SetPoint("TOPLEFT", v, "TOPLEFT", 8, y)
		t:SetPoint("TOPRIGHT", v, "TOPRIGHT", -8, y)
	end

	-- Ligne 0 : pseudo commun à mes personnages (visible seulement au survol) et mes persos
	local tPseudo = v:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	tPseudo:SetPoint("LEFT", v, "TOPLEFT", 10, -24)
	tPseudo:SetText("Pseudo")
	local pseudo = CreateFrame("EditBox", nil, v, "InputBoxTemplate")
	pseudo:SetSize(66, 18)
	pseudo:SetPoint("LEFT", tPseudo, "RIGHT", 10, 0)
	pseudo:SetAutoFocus(false)
	pseudo:SetMaxLetters(16)
	local function ValiderPseudo(self)
		local t = strtrim(((self:GetText() or ""):gsub("[~|,\n]", "")))
		if db then db.pseudo = t ~= "" and t or nil end
		if ns.AnnoncerIdentite then ns.AnnoncerIdentite() end
	end
	pseudo:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	pseudo:SetScript("OnEscapePressed", function(self) self:SetText(db and db.pseudo or ""); self:ClearFocus() end)
	pseudo:SetScript("OnEditFocusLost", ValiderPseudo)
	pseudo:SetScript("OnShow", function(self) self:SetText(db and db.pseudo or "") end)
	pseudo:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("Pseudo")
		GameTooltip:AddLine("Un nom commun à tous tes personnages (par exemple « Miko »).", 1, 1, 1, true)
		GameTooltip:AddLine("La guilde le voit seulement au survol de ton nom : partout ailleurs, ton vrai nom reste affiché (pour le courrier et les messages, qui partent toujours au bon personnage).", 0.7, 0.7, 0.7, true)
		GameTooltip:Show()
	end)
	pseudo:SetScript("OnLeave", function() GameTooltip:Hide() end)
	v.pseudo = pseudo
	local persos = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
	persos:SetSize(56, 20)
	persos:SetPoint("RIGHT", v, "TOPRIGHT", -8, -24)
	persos:SetText("Persos")
	persos:SetScript("OnClick", function(self) if ns.MenuPersos then ns.MenuPersos(self) end end)
	Infobulle(persos, "Mes personnages", "Choisis ton personnage principal : la guilde voit tes autres personnages au survol de ton nom.")
	Filet(-44)

	-- Ligne 1 : choix du rôle
	local titre = v:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	titre:SetPoint("LEFT", v, "TOPLEFT", 10, -60)
	titre:SetText("Mon rôle")
	v.boutons = {}
	local x = LARGEUR_VOLET - 10 - 3 * 32 + 4
	for _, role in ipairs({ "tank", "heal", "dps" }) do
		local bt = CreateFrame("Button", nil, v)
		bt:SetSize(28, 28)
		bt:SetPoint("LEFT", v, "TOPLEFT", x, -60)
		bt.icone = bt:CreateTexture(nil, "ARTWORK")
		bt.icone:SetAllPoints(bt)
		PoserIcone(bt.icone, role)
		-- halo doré : rôle choisi à la main
		bt.halo = bt:CreateTexture(nil, "OVERLAY")
		bt.halo:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		bt.halo:SetBlendMode("ADD")
		bt.halo:SetVertexColor(1, 0.82, 0)
		bt.halo:SetPoint("CENTER", bt, "CENTER", 0, 0)
		bt.halo:SetSize(52, 52)
		bt:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		bt:SetScript("OnClick", function() ChoisirRole(role) end)
		Infobulle(bt, ICONES_ROLE[role].nom,
			"Clic : annoncer ce rôle à la guilde.\nRe-clic : revenir en automatique (rôle de groupe).")
		v.boutons[role] = bt
		x = x + 32
	end
	Filet(-80)

	-- Ligne 2 : partage de position, groupes, métiers
	local position = CreateFrame("Button", nil, v)
	position:SetSize(24, 24)
	position:SetPoint("RIGHT", v, "TOPRIGHT", -10, -206) -- sur la ligne de « Activer les bannières »
	position.icone = position:CreateTexture(nil, "ARTWORK")
	position.icone:SetAllPoints(position)
	position.icone:SetTexture("Interface\\Icons\\INV_Misc_Map_01")
	position.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	position.halo = position:CreateTexture(nil, "OVERLAY")
	position.halo:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	position.halo:SetBlendMode("ADD")
	position.halo:SetVertexColor(0.3, 1, 0.3)
	position.halo:SetPoint("CENTER", position, "CENTER", 0, 0)
	position.halo:SetSize(46, 46)
	position:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	position:SetScript("OnClick", function()
		db.partagePosition = not db.partagePosition
		if ns.SurChangementPartage then ns.SurChangementPartage() end
		MajBarreRole()
	end)
	position:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("Partager ma position")
		GameTooltip:AddLine(db.partagePosition and "|cff00ff00Activé|r : la guilde te voit sur sa carte du monde."
			or "|cffff4444Coupé|r : personne ne voit ta position.", 1, 1, 1, true)
		GameTooltip:AddLine("Clic : activer / couper.", 0.7, 0.7, 0.7)
		GameTooltip:Show()
	end)
	position:SetScript("OnLeave", function() GameTooltip:Hide() end)
	v.position = position

	-- ouvrir une fenêtre referme le volet
	local function FermerVolet()
		ReglagesBarre().ouvert = false
		MajBarreRole()
	end
	local function BoutonLigne(y, texte, titreBulle, aide, Ouvrir)
		local b = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
		b:SetSize(LARGEUR_VOLET - 20, 22)
		b:SetPoint("LEFT", v, "TOPLEFT", 10, y)
		b:SetText(texte)
		b:SetScript("OnClick", function()
			FermerVolet()
			Ouvrir()
		end)
		Infobulle(b, titreBulle, aide)
		return b
	end

	-- deux demi-boutons côte à côte sur une ligne
	local demi = (LARGEUR_VOLET - 20 - 4) / 2
	local function Paire(y, g, d)
		local bg = BoutonLigne(y, g[1], g[2], g[3], g[4])
		bg:SetWidth(demi)
		local bd = CreateFrame("Button", nil, v, "UIPanelButtonTemplate")
		bd:SetSize(demi, 22)
		bd:SetPoint("LEFT", bg, "RIGHT", 4, 0)
		bd:SetText(d[1])
		bd:SetScript("OnClick", function()
			FermerVolet()
			d[4]()
		end)
		Infobulle(bd, d[2], d[3])
		return bg, bd
	end

	-- Ligne 2 : groupes (et quêtes en commun) · appel à l'aide
	Paire(-98,
		{ "Groupes", "Groupes et quêtes en commun",
			"Les groupes de la guilde (postuler, créer le tien) et, à côté, les quêtes que tu fais avec d'autres membres.",
			function() if ns.BasculerGroupes then ns.BasculerGroupes() end end },
		{ "À l'aide !", "Besoin d'aide",
			"Appelle la guilde à l'aide (quête difficile, escorte, élite…). Les membres qui ont le niveau reçoivent une bulle avec ta zone et un repère sur la carte.",
			function() if ns.DemanderAide then ns.DemanderAide() end end })
	Filet(-116)

	-- Ligne 3 : artisanat (registre, items, projets) · mes carnets (carnet de craft)
	Paire(-134,
		{ "Artisanat", "Artisanat de la guilde",
			"Le registre des métiers (qui sait fabriquer quoi), tous les objets fabricables et les projets de guilde.",
			function() if ns.BasculerMetiers then ns.BasculerMetiers() end end },
		{ "Mes carnets", "Carnet de craft",
			"Tes listes de courses : les composants de tes recettes, ce que tu as déjà et ce qu'il manque.",
			function() if ns.BasculerCourses then ns.BasculerCourses() end end })
	Filet(-152)

	-- Ligne 4 : événements de guilde · dons
	Paire(-170,
		{ "Événements", "Événements de guilde",
			"Ouvre le calendrier du jeu sur « Créer un événement de guilde ».",
			function() if ns.BasculerEvenements then ns.BasculerEvenements() end end },
		{ "Dons", "Dons de la guilde",
			"Les dons (comme un hôtel des ventes, mais gratuit), tes dons, les demandes reçues et les besoins de chacun.",
			function() if ns.BasculerEchanges then ns.BasculerEchanges() end end })
	Filet(-188)

	-- Ligne 5 : activer GuildUpSMB (bannières, noms, barres de nom alliées)
	local actif = CreateFrame("CheckButton", nil, v, "UICheckButtonTemplate")
	actif:SetSize(24, 24)
	actif:SetPoint("LEFT", v, "TOPLEFT", 6, -206)
	local texte = actif.Text or actif.text
	if not texte then
		texte = actif:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		texte:SetPoint("LEFT", actif, "RIGHT", 2, 0)
	end
	texte:SetFontObject("GameFontHighlight")
	texte:SetText("Activer les bannières")
	actif:SetScript("OnClick", function(self)
		db.actif = self:GetChecked() and true or false
		SurActivation()
		ToutRafraichir()
		if ns.MajOptions then ns.MajOptions() end
	end)
	actif:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("Activer les bannières")
		GameTooltip:AddLine("Bannières de la guilde, noms des autres joueurs et barres de nom alliées.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	actif:SetScript("OnLeave", function() GameTooltip:Hide() end)
	v.actif = actif

	-- Notifications de la guilde : une case par type de bulle (deux colonnes)
	Filet(-224)
	local tNotifs = CreateFrame("Button", nil, v)
	tNotifs:SetPoint("TOPLEFT", v, "TOPLEFT", 6, -228)
	tNotifs:SetPoint("RIGHT", v, "RIGHT", -6, 0)
	tNotifs:SetHeight(18)
	tNotifs:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	tNotifs.texte = tNotifs:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	tNotifs.texte:SetPoint("LEFT", tNotifs, "LEFT", 4, 0)
	local NOTIFS = {
		{ "groupes", "Groupes" }, { "candidatures", "Candidatures" },
		{ "niveaux", "Niveaux" }, { "metiers", "Métiers" },
		{ "evenements", "Événements" }, { "quetes", "Quêtes" },
		{ "commandes", "Commandes" }, { "plans", "Échanges" },
		{ "version", "Version" }, { "aide", "Aide" },
		{ "gu", (ns.Config and ns.Config.cri) and (tostring(ns.Config.cri):upper() .. "!") or "Cri" },
	}
	v.notifs = {}
	for i, n in ipairs(NOTIFS) do
		local cat = n[1]
		local cb = CreateFrame("CheckButton", nil, v, "UICheckButtonTemplate")
		cb:SetSize(20, 20)
		local rang = math.floor((i - 1) / 2)
		cb:SetPoint("TOPLEFT", v, "TOPLEFT", (i % 2 == 0) and (LARGEUR_VOLET / 2 + 2) or 8, -246 - rang * 20)
		local t = cb.Text or cb.text
		if not t then
			t = cb:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			t:SetPoint("LEFT", cb, "RIGHT", 1, 0)
		end
		t:SetFontObject("GameFontHighlightSmall")
		t:SetText(n[2])
		cb:SetScript("OnClick", function(self)
			if type(db.notifs) ~= "table" then db.notifs = {} end
			db.notifs[cat] = (not self:GetChecked()) and false or nil
		end)
		cb.categorie = cat
		v.notifs[#v.notifs + 1] = cb
	end

	-- plié par défaut : le titre seul ; clic pour voir les cases
	local function MajNotifs()
		local ouvert = (db and db.voletNotifs) and true or false
		tNotifs.texte:SetText((ouvert and "|TInterface\\Buttons\\UI-MinusButton-Up:12:12:0:0|t " or "|TInterface\\Buttons\\UI-PlusButton-Up:12:12:0:0|t ") .. "Notifications")
		for _, cb in ipairs(v.notifs) do cb:SetShown(ouvert) end
		v:SetSize(LARGEUR_VOLET, ouvert and (246 + math.ceil(#NOTIFS / 2) * 20 + 8) or 252)
	end
	tNotifs:SetScript("OnClick", function()
		db.voletNotifs = not db.voletNotifs or nil
		MajNotifs()
	end)
	Infobulle(tNotifs, "Notifications", "Choisir les bulles que tu veux recevoir (clic : déplier / replier).")
	MajNotifs()
	v:Hide()
	return v
end

local function CreerBoutonCarte()
	local b = CreateFrame("Button", "GuildUpBoutonCarte", Minimap)
	b:SetSize(31, 31)
	b:SetScale(ECHELLE_BOUTON)
	b:SetFrameStrata("MEDIUM")
	b:SetFrameLevel(8)
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	b:RegisterForDrag("LeftButton")
	b:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	-- même habillage que les boutons de mini-carte des autres addons
	local fond = b:CreateTexture(nil, "BACKGROUND")
	fond:SetSize(24, 24)
	fond:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	fond:SetPoint("CENTER", b, "TOPLEFT", 17, -15) -- centre du cercle de la bordure
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(34, 34) -- l'image du rôle a des marges transparentes : plus grande que le cercle
	b.icone:SetPoint("CENTER", b, "TOPLEFT", 17, -16.5) -- recentrée dans le cercle doré (mesuré sur capture)
	local bordure = b:CreateTexture(nil, "OVERLAY")
	bordure:SetSize(53, 53)
	bordure:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	bordure:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
	-- mêmes noms de champs que les boutons LibDBIcon : les addons qui rangent ou rhabillent les
	-- boutons de mini-carte (SexyMap, ElvUI, Leatrix…) retrouvent l'icône au lieu de tout masquer
	b.icon, b.border, b.background = b.icone, bordure, fond

	-- halo qui pulse (jaune) : des groupes de la guilde cherchent du monde
	b.halo = b:CreateTexture(nil, "OVERLAY", nil, 1)
	if C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("groupfinder-eye-highlight") then
		b.halo:SetAtlas("groupfinder-eye-highlight")
	else
		b.halo:SetTexture("Interface\\Calendar\\EventNotificationGlow")
	end
	b.halo:SetSize(46, 46)
	b.halo:SetPoint("CENTER", b, "TOPLEFT", 17, -16.5)
	b.halo:SetBlendMode("ADD")
	b.halo:Hide()
	b.pulse = b.halo:CreateAnimationGroup()
	local monte = b.pulse:CreateAnimation("Alpha")
	monte:SetFromAlpha(0.25)
	monte:SetToAlpha(1)
	monte:SetDuration(0.9)
	monte:SetOrder(1)
	monte:SetSmoothing("IN_OUT")
	local descend = b.pulse:CreateAnimation("Alpha")
	descend:SetFromAlpha(1)
	descend:SetToAlpha(0.25)
	descend:SetDuration(0.9)
	descend:SetOrder(2)
	descend:SetSmoothing("IN_OUT")
	b.pulse:SetLooping("REPEAT")

	-- anneau qui tourne (vert) : je suis moi-même en attente (mon annonce, ma candidature, groupe
	-- public). Texture faite par Miko : media\anneau.tga (blanche, teintée ici). Si ANNEAU_CUSTOM
	-- est à false, c'est le halo qui pulse en vert à la place.
	if ANNEAU_CUSTOM then
		b.anneau = b:CreateTexture(nil, "OVERLAY", nil, 1)
		b.anneau:SetTexture(MEDIA .. "anneau")
		b.anneau:SetSize(87, 87)
		b.anneau:SetPoint("CENTER", b, "TOPLEFT", 17, -16.5)
		b.anneau:SetBlendMode("ADD")
		b.anneau:SetVertexColor(0.25, 1, 0.35, 1)
		b.anneau:Hide()
		b.tourne = b.anneau:CreateAnimationGroup()
		local rot = b.tourne:CreateAnimation("Rotation")
		rot:SetDegrees(360) -- sens inverse des aiguilles d'une montre (choix de Miko)
		rot:SetDuration(4)
		b.tourne:SetLooping("REPEAT")
	end

	-- compteur : nombre de groupes de la guilde qui cherchent du monde
	b.pastille = b:CreateTexture(nil, "OVERLAY", nil, 2)
	b.pastille:SetSize(18, 18)
	b.pastille:SetPoint("CENTER", b, "BOTTOMRIGHT", -5, 7)
	b.pastille:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	b.pastille:SetVertexColor(0.75, 0.1, 0.1, 1)
	b.compteur = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	b.compteur:SetPoint("CENTER", b.pastille, "CENTER", 0, 0)
	b.compteur:SetTextColor(1, 1, 1)
	b.compteur:SetDrawLayer("OVERLAY", 3)

	-- glisser : le bouton suit la souris en tournant autour de la mini-carte
	local function SuivreSouris()
		local cx, cy = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local echelle = Minimap:GetEffectiveScale()
		px, py = px / echelle, py / echelle
		local r = ReglagesBarre()
		r.angle = math.deg(math.atan2(py - cy, px - cx))
		PlacerSurLaCarte(r.angle)
		PlacerVolet()
	end
	b:SetScript("OnDragStart", function(self)
		self:LockHighlight()
		self:SetScript("OnUpdate", SuivreSouris)
		GameTooltip:Hide()
	end)
	b:SetScript("OnDragStop", function(self)
		self:SetScript("OnUpdate", nil)
		self:UnlockHighlight()
	end)

	b:SetScript("OnClick", function(_, bouton)
		if bouton == "RightButton" then
			if ns.BasculerGroupes then ns.BasculerGroupes() end
			return
		end
		local r = ReglagesBarre()
		r.ouvert = not r.ouvert
		MajBarreRole()
	end)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("GuildUpSMB")
		local role = MonRole()
		GameTooltip:AddLine("Ton rôle : " .. (role and ICONES_ROLE[role].nom or "inconnu"), 1, 1, 1)
		local n = ns.NombreGroupes and ns.NombreGroupes() or 0
		GameTooltip:AddLine(n > 0 and (n .. " groupe" .. (n > 1 and "s" or "") .. " de la guilde en recherche")
			or "Aucun groupe de la guilde en recherche", 1, 0.82, 0)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Clic gauche : choisir ton rôle", 0.8, 0.8, 0.8)
		GameTooltip:AddLine("Clic droit : groupes de la guilde", 0.8, 0.8, 0.8)
		GameTooltip:AddLine("Glisser : déplacer autour de la mini-carte", 0.8, 0.8, 0.8)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

MajBarreRole = function()
	if not db or not Minimap then return end
	local r = ReglagesBarre()
	if not boutonCarte then
		if not r.visible then return end
		boutonCarte = CreerBoutonCarte()
		volet = ns.AvecSons(CreerVolet(), "volet")
		SonsSurBoutons(boutonCarte)
	end
	boutonCarte:SetShown(r.visible)
	PlacerSurLaCarte(r.angle)
	local actuel = MonRole()
	PoserIcone(boutonCarte.icone, actuel)
	-- rôle inconnu : l'icône carrée du point d'interrogation, plus petite et arrondie pour rester
	-- dans le cercle (les icônes de rôle, rondes avec des marges, gardent leur grande taille)
	local ic = boutonCarte.icone
	if not ic.masque and ic.AddMaskTexture then
		ic.masque = boutonCarte:CreateMaskTexture()
		ic.masque:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		ic.masque:SetAllPoints(ic)
	end
	if actuel then
		ic:SetSize(34, 34)
		if ic.masque then ic:RemoveMaskTexture(ic.masque) end
	else
		ic:SetSize(21.3, 21.3)
		if ic.masque then ic:AddMaskTexture(ic.masque) end
	end
	boutonCarte.icone:SetDesaturated(not db.actif)
	local n = ns.NombreGroupes and ns.NombreGroupes() or 0
	boutonCarte.compteur:SetText(n > 9 and "9+" or tostring(n))
	boutonCarte.compteur:SetShown(n > 0)
	boutonCarte.pastille:SetShown(n > 0)
	-- vert (anneau qui tourne) si je suis en attente, sinon halo jaune qui pulse s'il y a des groupes
	local moi = db.actif and ns.EnAttente and ns.EnAttente()
	local groupes = db.actif and n > 0
	local b = boutonCarte
	local anneauVert = moi and b.anneau ~= nil
	if anneauVert then
		b.anneau:Show()
		if not b.tourne:IsPlaying() then b.tourne:Play() end
	elseif b.anneau then
		b.tourne:Stop()
		b.anneau:Hide()
	end
	-- halo : jaune pour les groupes ; vert seulement si l'anneau est désactivé (ANNEAU_CUSTOM = false)
	if (moi and not anneauVert) or (groupes and not moi) then
		if moi then b.halo:SetVertexColor(0.25, 1, 0.35, 1) else b.halo:SetVertexColor(1, 0.82, 0.1, 1) end
		b.halo:Show()
		if not b.pulse:IsPlaying() then b.pulse:Play() end
	else
		b.pulse:Stop()
		b.halo:Hide()
	end

	volet:SetShown(r.visible and r.ouvert and true or false)
	if not volet:IsShown() then return end
	PlacerVolet()
	for role, bt in pairs(volet.boutons) do
		local choisi = (actuel == role)
		bt.icone:SetDesaturated(not choisi)
		bt.icone:SetAlpha(choisi and 1 or 0.4)
		bt.halo:SetShown(RoleManuel() == role)
	end
	volet.position.icone:SetDesaturated(not db.partagePosition)
	volet.position.icone:SetAlpha(db.partagePosition and 1 or 0.5)
	volet.position.halo:SetShown(db.partagePosition and true or false)
	volet.actif:SetChecked(db.actif and true or false)
	for _, cb in ipairs(volet.notifs or {}) do
		cb:SetChecked(not (type(db.notifs) == "table" and db.notifs[cb.categorie] == false))
	end
end

-- appelé par GuildUp_Groupes.lua à chaque changement des annonces (compteur)
ns.MajBoutonCarte = function() if MajBarreRole then MajBarreRole() end end

-- Bulle à gauche du bouton de la mini-carte quand un membre ouvre un groupe, avec un son discret.
-- Clic sur la bulle : ouvre les groupes. Elle disparaît en fondu après DUREE_BULLE secondes.
local DUREE_BULLE = 10
local bulle
local jetonBulle = 0 -- chaque nouvelle bulle annule la fermeture prévue pour la précédente

local function SonDiscret()
	if not PlaySound or not SOUNDKIT then return end
	for _, nom in ipairs({ "UI_GARRISON_TOAST_INVASION_ALERT", "ALARM_CLOCK_WARNING_3", "TELL_MESSAGE" }) do
		if SOUNDKIT[nom] then
			pcall(PlaySound, SOUNDKIT[nom], "SFX")
			return
		end
	end
end

local function CreerBulle()
	local f = CreateFrame("Button", "GuildUpBulle", UIParent, "BackdropTemplate")
	-- au-dessus de toutes les fenêtres (les nôtres et celles du jeu sont en « HIGH » et passaient
	-- par-dessus la bulle quand elles étaient ouvertes)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 14,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0, 0, 0, 0.85)
	f:SetBackdropBorderColor(1, 0.82, 0, 1)
	f:SetScale(1.15) -- un peu plus grande que les infobulles du jeu
	f.titre = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.titre:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
	f.texte = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	f.texte:SetPoint("TOPLEFT", f.titre, "BOTTOMLEFT", 0, -4)
	f.texte:SetJustifyH("LEFT")
	f:SetScript("OnClick", function(self)
		self:Hide()
		if self.action then
			pcall(self.action)
		elseif ns.OuvrirGroupes then
			ns.OuvrirGroupes()
		end
	end)
	f:SetScript("OnUpdate", function(self)
		local reste = (self.fin or 0) - GetTime()
		if reste <= 0 then
			self:Hide()
		elseif reste < 1 then
			self:SetAlpha(reste)
		end
	end)
	f:Hide()
	return f
end

-- Bulle d'alerte à gauche du bouton de la mini-carte (remplace les messages dans le chat) :
-- titre, texte, son (nom SOUNDKIT, ou nil pour le son discret) ; un clic ouvre les groupes
-- action (facultative) : fonction appelée au clic sur la bulle (par défaut : fenêtre des groupes)
ns.MEDIA = MEDIA

-- Les bulles sont rangées par catégorie (passée par l'appelant), pour pouvoir les couper une par
-- une dans le volet de la mini-carte (db.notifs[catégorie] = false) ; nil = toujours affichée
-- (retours immédiats d'une action du joueur)
local function NotifActive(categorie)
	return not (categorie and type(db.notifs) == "table" and db.notifs[categorie] == false)
end

-- Place de la bulle : à gauche du bouton de la mini-carte, ou en haut à droite de l'écran si le
-- bouton est caché (/smb barre)
local function AncrerBulle(b)
	b:ClearAllPoints()
	if boutonCarte and boutonCarte:IsShown() then
		b:SetPoint("RIGHT", boutonCarte, "LEFT", -6, 0)
	else
		b:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -230, -40)
	end
end

-- Renvoie true si la bulle est affichée (false : GuildUpSMB pas prêt ou catégorie coupée)
ns.Notifier = function(categorie, titre, texte, son, action)
	if not db then return false end
	if not NotifActive(categorie) then return false end
	bulle = bulle or CreerBulle()
	if bulle.Reinit then bulle.Reinit(bulle) end -- une bulle spéciale (GuildUp_GU) l'avait décorée
	bulle.action = action
	bulle.titre:SetText(titre or "GuildUpSMB")
	bulle.texte:SetText(texte or "")
	local largeur = math.max(bulle.titre:GetStringWidth(), bulle.texte:GetStringWidth()) + 26
	bulle:SetSize(largeur, bulle.titre:GetStringHeight() + bulle.texte:GetStringHeight() + 24)
	AncrerBulle(bulle)
	bulle:SetAlpha(1)
	bulle.fin = GetTime() + DUREE_BULLE
	bulle:Show()
	bulle:Raise()
	-- son : un fichier de l'addon (chemin, ex. la sonnette des montées de niveau), un son du jeu
	-- (nom SOUNDKIT), ou rien = le son discret habituel
	local joue = false
	if son == "aucun" then
		joue = true -- bulle silencieuse (rappels, commandes déjà signalées par le message privé)
	elseif son and son:find("[/\\]") and PlaySoundFile then
		local ok, res = pcall(PlaySoundFile, son, "SFX")
		joue = ok and res ~= false
	elseif son and SOUNDKIT and SOUNDKIT[son] then
		joue = pcall(PlaySound, SOUNDKIT[son], "SFX")
	end
	if not joue then SonDiscret() end
	-- sécurité : fermeture garantie à la fin du délai, même si le fondu ne s'est pas fait
	jetonBulle = jetonBulle + 1
	local jeton = jetonBulle
	C_Timer.After(DUREE_BULLE + 0.2, function()
		if bulle and jeton == jetonBulle then bulle:Hide() end
	end)
	return true
end

ns.AlerteNouveauGroupe = function(chef, contenu)
	ns.Notifier("groupes", "Nouveau groupe de la guilde", ("%s ouvre un groupe : |cffffd100%s|r"):format(chef or "?", contenu or "?"))
end

-- Partagé avec GuildUp_Options.lua
ns.MiniCarte = { ReglagesBarre = ReglagesBarre }
