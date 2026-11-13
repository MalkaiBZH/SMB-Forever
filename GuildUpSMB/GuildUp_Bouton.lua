-- GuildUpSMB : bouton flottant (médaillon de la guilde, à placer où l'on veut sur l'écran), son menu
-- rapide (clic droit) et les bulles de notification (ns.Notifier).
-- Il remplace l'ancien bouton de la mini-carte et son volet : les fenêtres passent par la fenêtre
-- GuildUpSMB (GuildUp_Interface.lua) ; le rôle, la position et l'appel à l'aide par le menu rapide ;
-- le pseudo, les personnages et le choix des notifications par la fenêtre d'options.
-- Le médaillon : emblème de la guilde dans un anneau à la couleur de mon rôle ; pastille = nouveautés
-- (ns.NouveautesGuilde, GuildUp_Interface.lua) ; halo doré qui pulse = des groupes cherchent du monde ;
-- anneau vert qui tourne = je suis moi-même en attente (annonce, candidature). Aucun message réseau.

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
local ToutRafraichir = ns.Plaques.ToutRafraichir
local MajBouton -- état du médaillon (défini plus bas)

--------------------------------------------------------------------------------
-- Rôle
--------------------------------------------------------------------------------

local ROLES = {
	tank = { nom = "Tank", couleur = { 0.23, 0.56, 0.88 } },
	heal = { nom = "Heal", couleur = { 0.2, 0.75, 0.35 } },
	dps  = { nom = "DPS",  couleur = { 0.85, 0.27, 0.22 } },
}
local COULEUR_SANS_ROLE = { 0.85, 0.66, 0.25 } -- doré
ns.ROLES_INTERFACE = ROLES

local function ChoisirRole(role)
	-- re-cliquer sur le rôle choisi à la main revient en automatique
	if RoleManuel() == role then PoserRoleManuel("auto") else PoserRoleManuel(role) end
	Annoncer(true)
	ToutRafraichir()
	if ns.MajOptions then ns.MajOptions() end
	if ns.SurChangementDeRole then ns.SurChangementDeRole() end
	if MajBouton then MajBouton() end
	if ns.MajInterface then ns.MajInterface() end
end
-- utilisé par la fenêtre GuildUpSMB et celle des groupes
ns.ChoisirRole = function(role) if ns.DB() then ChoisirRole(role) end end
ns.RoleChoisiALaMain = function() return ns.DB() and RoleManuel() end

-- partage de ma position sur la carte de la guilde (menu rapide, fenêtre GuildUpSMB, options)
ns.BasculerPartagePosition = function()
	if not ns.DB() then return end
	db.partagePosition = not db.partagePosition
	if ns.SurChangementPartage then ns.SurChangementPartage() end
	if ns.MajOptions then ns.MajOptions() end
	if ns.MajInterface then ns.MajInterface() end
end

--------------------------------------------------------------------------------
-- Médaillon flottant
--------------------------------------------------------------------------------

local TAILLE = 52 -- diamètre (pixels)
local ROND = MEDIA .. "point" -- disque blanc de l'addon, teinté

-- position (centre du bouton, depuis le coin bas gauche de l'écran) et visibilité
-- (hors DEFAUT : recréé après une réinitialisation ; db.barre = l'ancien bouton de la mini-carte)
local function ReglagesBouton()
	if type(db.bouton) ~= "table" then db.bouton = { visible = true } end
	db.barre = nil
	local r = db.bouton
	if r.visible == nil then r.visible = true end
	return r
end

local bouton

local function Placer()
	local r = ReglagesBouton()
	bouton:ClearAllPoints()
	if type(r.x) == "number" and type(r.y) == "number" then
		bouton:SetPoint("CENTER", UIParent, "BOTTOMLEFT", r.x, r.y)
	else
		bouton:SetPoint("CENTER", UIParent, "TOPRIGHT", -240, -70) -- à gauche de la mini-carte
	end
end

local function Infobulle(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetText("SMB Forever")
	local role = MonRole()
	GameTooltip:AddLine("Ton rôle : " .. (role and ROLES[role] and ROLES[role].nom or "inconnu"), 1, 1, 1)
	local n = ns.NouveautesGuilde and ns.NouveautesGuilde()
	if n then
		if n.groupes > 0 then GameTooltip:AddLine(n.groupes .. " groupe" .. (n.groupes > 1 and "s" or "") .. " ouvert" .. (n.groupes > 1 and "s" or ""), 1, 0.82, 0) end
		if n.aide > 0 then GameTooltip:AddLine(n.aide .. " appel" .. (n.aide > 1 and "s" or "") .. " à l'aide", 1, 0.6, 0.5) end
		if n.dons > 0 then GameTooltip:AddLine(n.dons .. " demande" .. (n.dons > 1 and "s" or "") .. " de don", 1, 0.82, 0) end
		if n.groupes + n.aide + n.dons == 0 then GameTooltip:AddLine("Rien de nouveau", 0.7, 0.7, 0.7) end
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Clic : ouvrir · Clic droit : menu rapide", 0.6, 0.6, 0.6)
	GameTooltip:AddLine("Glisser : déplacer", 0.6, 0.6, 0.6)
	GameTooltip:Show()
end

-- Menu rapide (clic droit) : rôle, position, groupes, appel à l'aide, options
local menu
local function MontrerMenu()
	menu = menu or ns.CadreMenu("GuildUpMenuRapide")
	local lignes = {}
	local actuel, manuel = MonRole(), RoleManuel()
	for _, role in ipairs({ "tank", "heal", "dps" }) do
		local c = ROLES[role].couleur
		local coche = (manuel == role) and "  |cffffd100(choisi)|r" or ((actuel == role) and "  |cff999999(auto)|r" or "")
		lignes[#lignes + 1] = { ("|cff%02x%02x%02x%s|r%s"):format(math.floor(c[1] * 255), math.floor(c[2] * 255), math.floor(c[3] * 255), ROLES[role].nom, coche),
			function() ChoisirRole(role) end }
	end
	lignes[#lignes + 1] = { (db.partagePosition and "|TInterface\\Buttons\\UI-CheckBox-Check:16:16|t " or "|TInterface\\Buttons\\UI-CheckBox-Up:16:16|t ") .. "Partager ma position",
		ns.BasculerPartagePosition }
	lignes[#lignes + 1] = { "Groupes", function() if ns.OuvrirInterface then ns.OuvrirInterface("groupes") elseif ns.BasculerGroupes then ns.BasculerGroupes() end end }
	lignes[#lignes + 1] = { "|cffff9f80À l'aide !|r", function() if ns.DemanderAide then ns.DemanderAide() end end }
	lignes[#lignes + 1] = { "Options", function() if ns.OuvrirInterface then ns.OuvrirInterface("options") elseif ns.BasculerOptions then ns.BasculerOptions() end end }
	for i, l in ipairs(lignes) do
		local b = ns.BoutonMenu(menu, i)
		b:SetPoint("TOPLEFT", menu, "TOPLEFT", 6, -6 - (i - 1) * 20)
		b:SetPoint("RIGHT", menu, "RIGHT", -6, 0)
		b.texte:SetText(l[1])
		b:SetScript("OnClick", function() menu:Hide(); l[2]() end)
		b:Show()
	end
	for i = #lignes + 1, #menu.boutons do menu.boutons[i]:Hide() end
	menu:SetSize(170, #lignes * 20 + 12)
	menu.ancre = bouton
	menu:ClearAllPoints()
	-- du côté de l'écran où il y a de la place
	local x = bouton:GetCenter()
	if x and x > UIParent:GetWidth() / 2 then
		menu:SetPoint("TOPRIGHT", bouton, "BOTTOMLEFT", 8, 8)
	else
		menu:SetPoint("TOPLEFT", bouton, "BOTTOMRIGHT", -8, 8)
	end
	menu:Show()
end

local function CreerBouton()
	local b = CreateFrame("Button", "GuildUpBouton", UIParent)
	b:SetSize(TAILLE, TAILLE)
	b:SetFrameStrata("MEDIUM")
	b:SetFrameLevel(8)
	b:SetMovable(true)
	b:SetClampedToScreen(true)
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	b:RegisterForDrag("LeftButton")

	-- anneau du rôle (disque coloré), fond sombre, emblème de la guilde
	b.anneauRole = b:CreateTexture(nil, "BACKGROUND")
	b.anneauRole:SetTexture(ROND)
	b.anneauRole:SetAllPoints()
	b.fond = b:CreateTexture(nil, "BORDER")
	b.fond:SetTexture(ROND)
	b.fond:SetVertexColor(0.08, 0.07, 0.055, 1)
	b.fond:SetSize(TAILLE - 8, TAILLE - 8)
	b.fond:SetPoint("CENTER")
	b.embleme = b:CreateTexture(nil, "ARTWORK")
	b.embleme:SetTexture(MEDIA .. "gu_emote")
	b.embleme:SetSize(TAILLE - 16, TAILLE - 16)
	b.embleme:SetPoint("CENTER")
	-- survol : le disque s'éclaircit
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetTexture(ROND)
	survol:SetAllPoints()
	survol:SetBlendMode("ADD")
	survol:SetVertexColor(1, 1, 1, 0.18)

	-- halo qui pulse (doré) : des groupes de la guilde cherchent du monde
	b.halo = b:CreateTexture(nil, "OVERLAY", nil, 1)
	if ns.AtlasExiste("groupfinder-eye-highlight") then
		b.halo:SetAtlas("groupfinder-eye-highlight")
	else
		b.halo:SetTexture("Interface\\Calendar\\EventNotificationGlow")
	end
	b.halo:SetSize(TAILLE * 1.6, TAILLE * 1.6)
	b.halo:SetPoint("CENTER")
	b.halo:SetBlendMode("ADD")
	b.halo:SetVertexColor(1, 0.82, 0.1, 1)
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

	-- anneau qui tourne (vert) : je suis moi-même en attente. Texture faite par Miko :
	-- media\anneau.tga (blanche, teintée ici)
	b.anneau = b:CreateTexture(nil, "OVERLAY", nil, 1)
	b.anneau:SetTexture(MEDIA .. "anneau")
	b.anneau:SetSize(TAILLE * 1.75, TAILLE * 1.75)
	b.anneau:SetPoint("CENTER")
	b.anneau:SetBlendMode("ADD")
	b.anneau:SetVertexColor(0.25, 1, 0.35, 1)
	b.anneau:Hide()
	b.tourne = b.anneau:CreateAnimationGroup()
	local rot = b.tourne:CreateAnimation("Rotation")
	rot:SetDegrees(360) -- sens inverse des aiguilles d'une montre (choix de Miko)
	rot:SetDuration(4)
	b.tourne:SetLooping("REPEAT")

	-- pastille : nombre de nouveautés
	b.pastille = b:CreateTexture(nil, "OVERLAY", nil, 2)
	b.pastille:SetTexture(ROND)
	b.pastille:SetSize(20, 20)
	b.pastille:SetPoint("CENTER", b, "TOPRIGHT", -6, -6)
	b.pastille:SetVertexColor(0.75, 0.13, 0.1, 1)
	b.compteur = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.compteur:SetPoint("CENTER", b.pastille, "CENTER", 0, 0)
	b.compteur:SetDrawLayer("OVERLAY", 3)

	-- glisser : déplacer ; la position est gardée (centre, depuis le coin bas gauche de l'écran)
	b:SetScript("OnDragStart", function(self)
		GameTooltip:Hide()
		self:StartMoving()
	end)
	b:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local x, y = self:GetCenter()
		local r = ReglagesBouton()
		if x and y then r.x, r.y = x, y end
		Placer()
	end)
	b:SetScript("OnClick", function(_, souris)
		GameTooltip:Hide()
		if souris == "RightButton" then
			MontrerMenu()
		elseif ns.BasculerInterface then
			ns.BasculerInterface()
		end
	end)
	b:SetScript("OnEnter", Infobulle)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

MajBouton = function()
	if not ns.DB() then return end
	local r = ReglagesBouton()
	if not bouton then
		if not r.visible then return end
		bouton = CreerBouton()
		SonsSurBoutons(bouton)
		Placer()
	end
	bouton:SetShown(r.visible and true or false)
	local role = MonRole()
	local c = (role and ROLES[role] and ROLES[role].couleur) or COULEUR_SANS_ROLE
	bouton.anneauRole:SetVertexColor(c[1], c[2], c[3], 1)
	-- pastille : groupes ouverts + appels à l'aide + demandes de dons
	local nv = ns.NouveautesGuilde and ns.NouveautesGuilde()
	local n = nv and (nv.groupes + nv.aide + nv.dons) or (ns.NombreGroupes and ns.NombreGroupes() or 0)
	bouton.compteur:SetText(n > 9 and "9+" or tostring(n))
	bouton.compteur:SetShown(n > 0)
	bouton.pastille:SetShown(n > 0)
	-- vert (anneau qui tourne) si je suis en attente, sinon halo doré qui pulse s'il y a des groupes
	local moi = db.actif and ns.EnAttente and ns.EnAttente()
	local groupes = db.actif and ns.NombreGroupes and ns.NombreGroupes() > 0
	if moi then
		bouton.anneau:Show()
		if not bouton.tourne:IsPlaying() then bouton.tourne:Play() end
	else
		bouton.tourne:Stop()
		bouton.anneau:Hide()
	end
	if groupes and not moi then
		bouton.halo:Show()
		if not bouton.pulse:IsPlaying() then bouton.pulse:Play() end
	else
		bouton.pulse:Stop()
		bouton.halo:Hide()
	end
end

-- appelé par les modules quand leur état change (groupes, attente, rôle…)
ns.MajBouton = function() if MajBouton then MajBouton() end end

-- affiché / caché (options, /smb bouton)
ns.BasculerBouton = function(visible)
	if not ns.DB() then return end
	local r = ReglagesBouton()
	if visible == nil then visible = not r.visible end
	r.visible = visible and true or false
	MajBouton()
	return r.visible
end
ns.BoutonVisible = function() return ns.DB() and ReglagesBouton().visible end

--------------------------------------------------------------------------------
-- Bulles de notification
--------------------------------------------------------------------------------

-- Bulle à côté du médaillon quand un membre ouvre un groupe, avec un son discret.
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
	-- style de la fenêtre SMB Forever : fond sombre, bordure dorée (le cri de guilde la recolore)
	ns.UI.Habiller(f, { 0.067, 0.055, 0.043, 0.96 }, ns.UI.C.orFonce)
	f:SetBackdropBorderColor(ns.UI.C.orFonce[1], ns.UI.C.orFonce[2], ns.UI.C.orFonce[3], 1)
	f:SetScale(1.15) -- un peu plus grande que les infobulles du jeu
	-- filet doré sous le bord du haut
	local filet = f:CreateTexture(nil, "ARTWORK")
	filet:SetColorTexture(ns.UI.C.ors[1], ns.UI.C.ors[2], ns.UI.C.ors[3], 0.5)
	filet:SetHeight(2)
	filet:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
	filet:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
	f.filet = filet
	f.titre = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.titre:SetTextColor(ns.UI.C.ors[1], ns.UI.C.ors[2], ns.UI.C.ors[3])
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

-- Bulle d'alerte à côté du médaillon (remplace les messages dans le chat) :
-- titre, texte, son (nom SOUNDKIT, ou nil pour le son discret) ; un clic ouvre les groupes
-- action (facultative) : fonction appelée au clic sur la bulle (par défaut : fenêtre des groupes)
ns.MEDIA = MEDIA

-- Les bulles sont rangées par catégorie (passée par l'appelant), pour pouvoir les couper une par
-- une dans la fenêtre d'options (db.notifs[catégorie] = false) ; nil = toujours affichée
-- (retours immédiats d'une action du joueur)
local function NotifActive(categorie)
	return not (categorie and type(db.notifs) == "table" and db.notifs[categorie] == false)
end

-- Place de la bulle : à côté du médaillon, du côté de l'écran où il y a de la place, ou en haut à
-- droite de l'écran si le médaillon est caché (/smb bouton)
local function AncrerBulle(b)
	b:ClearAllPoints()
	if bouton and bouton:IsShown() then
		local x = bouton:GetCenter()
		if x and x > UIParent:GetWidth() / 2 then
			b:SetPoint("RIGHT", bouton, "LEFT", -6, 0)
		else
			b:SetPoint("LEFT", bouton, "RIGHT", 6, 0)
		end
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
	bulle.titre:SetText(titre or "SMB Forever")
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
ns.BoutonGuilde = { ReglagesBouton = ReglagesBouton }
