-- GuildUpSMB : repères des membres de la guilde dans le HUD, comme dans un jeu de tir.
--
-- Les membres qui partagent leur position (GuildUp_Carte.lua, message P) et se trouvent sur la même
-- carte que moi ont un repère (portrait, prénom, distance) toujours sur le tour de l'écran, placé selon
-- leur direction vue depuis mon personnage (GetPlayerFacing : c'est l'orientation du personnage, pas
-- celle de la caméra quand on la tourne au clic gauche). Les positions n'ont pas d'altitude : le
-- repère ne se pose jamais au milieu de l'écran.
--   - devant moi (dans le champ de vision) : bord du haut, à l'horizontale exacte de sa direction
--     (projection comme sur l'écran) ;
--   - hors du champ de vision : bord de gauche ou de droite, de plus en plus bas à mesure qu'il passe
--     derrière moi, puis bord du bas, au centre quand il est juste derrière ; avec une flèche.
-- Seuls les membres dont le portrait est connu sont affichés (addon à jour, race avec portrait).
-- Clic : chuchoter ; clic droit : menu (chuchoter, inviter dans le groupe, voir dans la page Guilde). Réglage db.reperes (/smb reperes, case dans les options) ; hauteur des repères du
-- haut et du bas : curseurs de la page Options, sinon valeurs de GuildUp_Config.lua.
-- Aucun message réseau propre : tout vient des positions de GuildUp_Carte.lua (une toutes les 6 s
-- au plus pour un membre qui bouge), d'où des petits sauts quand un membre proche se déplace.

local NOM_ADDON, ns = ...

local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local CouleurClasse = ns.CouleurClasse

local CHAMP = math.rad((ns.Config and tonumber(ns.Config.champVisionReperes)) or 90) -- largeur de l'écran (angle)
-- Position proposée par la guilde ; chaque membre peut la changer (page Options : GuildUpDB.hautReperes
-- et GuildUpDB.basReperes, lus à chaque mise à jour)
local HAUT = (ns.Config and tonumber(ns.Config.hautReperes)) or 34 -- centre des repères du haut, sous le haut de l'écran
local BAS = (ns.Config and tonumber(ns.Config.basReperes)) or 150 -- centre des repères du bas (au-dessus des barres d'action)
local TAILLE = 40        -- diamètre du portrait (pixels)
local MARGE = 50         -- distance minimale au bord de l'écran (côtés)
local DUREE_VIE = 45     -- secondes sans nouvelles d'un membre avant de cacher son repère
local PERIODE = 0.02     -- secondes entre deux mises à jour (mouvement fluide)
local UNITE = (GetLocale() == "enUS" or GetLocale() == "enGB") and "yd" or "m"
local POLICE = (GameFontNormal and GameFontNormal:GetFont()) or STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
local atan2 = math.atan2 or math.atan
local PI = math.pi

local function DB() return ns.DB and ns.DB() end

-- tout l'écran : les repères s'y placent par rapport au centre (le cadre ne prend pas la souris)
local cadre = CreateFrame("Frame", "GuildUpReperes", UIParent)
cadre:SetAllPoints(UIParent)
cadre:SetFrameStrata("LOW")

--------------------------------------------------------------------------------
-- Coordonnées du monde
--------------------------------------------------------------------------------

-- position sur le monde d'un point de carte : nord, ouest (en mètres / yards du jeu), ou nil.
-- (C_Map.GetWorldPosFromMapPos rend un vecteur dont x pointe vers le nord et y vers l'ouest)
local function Monde(carte, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then return nil end
	local ok, _, v = pcall(C_Map.GetWorldPosFromMapPos, carte, CreateVector2D(x, y))
	if not ok or not v then return nil end
	local ok2, nord, ouest = pcall(v.GetXY, v)
	if not ok2 or not nord or not ouest then return nil end
	return nord, ouest
end

-- position sur le monde des membres, recalculée seulement quand leur position change
local mondes = {} -- [nom normalisé] = { carte, x, y, nord, ouest }
local function MondeMembre(cle, p)
	local m = mondes[cle]
	if not (m and m.carte == p.carte and m.x == p.x and m.y == p.y) then
		local nord, ouest = Monde(p.carte, p.x, p.y)
		m = { carte = p.carte, x = p.x, y = p.y, nord = nord, ouest = ouest }
		mondes[cle] = m
	end
	return m.nord, m.ouest
end

--------------------------------------------------------------------------------
-- Repères
--------------------------------------------------------------------------------

local reperes = {} -- boutons réutilisés

-- nom à donner au jeu (chuchoter, inviter) : celui de la liste de guilde
local function NomJeu(cle, joueur)
	local nom = (ns.NomListeGuilde and ns.NomListeGuilde(cle)) or NomCourt(joueur)
	if cle and cle:find("#test", 1, true) then nom = UnitName("player") end -- (membres factices du mode test)
	return nom
end

local function Chuchoter(cle, joueur)
	local nom = NomJeu(cle, joueur)
	if ChatFrame_SendTell then ChatFrame_SendTell(nom)
	elseif ChatFrame_OpenChat then ChatFrame_OpenChat("/w " .. nom .. " ") end
end

local function Inviter(cle, joueur)
	local inviter = (C_PartyInfo and C_PartyInfo.InviteUnit) or InviteUnit
	if inviter then pcall(inviter, NomJeu(cle, joueur)) end
end

-- Menu du clic droit (même cadre que celui de la page Guilde : ns.CadreMenu). Le membre est retenu
-- au moment du clic : les repères sont réutilisés et peuvent changer de membre pendant que le menu
-- est ouvert.
local menu
local function MontrerMenu(repere)
	if not ns.CadreMenu then return end
	menu = menu or ns.CadreMenu("GuildUpMenuRepere")
	local cle, joueur = repere.cle, repere.joueur
	local lignes = {
		{ "Chuchoter", function() Chuchoter(cle, joueur) end },
		{ "Inviter dans le groupe", function() Inviter(cle, joueur) end },
		{ "Voir dans la page Guilde", function()
			if ns.OuvrirInterface then ns.OuvrirInterface("guilde", NomCourt(joueur)) end
		end },
	}
	for i, l in ipairs(lignes) do
		local b = ns.BoutonMenu(menu, i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", menu, "TOPLEFT", 6, -6 - (i - 1) * 20)
		b:SetPoint("RIGHT", menu, "RIGHT", -6, 0)
		b.texte:SetText(l[1])
		b:SetScript("OnClick", function() menu:Hide(); l[2]() end)
		b:Show()
	end
	for i = #lignes + 1, #menu.boutons do menu.boutons[i]:Hide() end
	menu:SetSize(190, #lignes * 20 + 12)
	menu.ancre = repere
	menu:ClearAllPoints()
	-- sous le curseur (le menu se garde à l'écran : SetClampedToScreen)
	local x, y = GetCursorPosition()
	local echelle = tonumber(UIParent:GetEffectiveScale()) or 1
	x, y = tonumber(x), tonumber(y)
	if x and y and echelle > 0 then
		menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / echelle - 8, y / echelle + 8)
	else
		menu:SetPoint("TOP", repere, "BOTTOM", 0, -30)
	end
	menu:Show()
end

local function NouveauRepere()
	local b = CreateFrame("Button", nil, cadre)
	b:SetSize(TAILLE, TAILLE)
	b.portrait = b:CreateTexture(nil, "ARTWORK")
	b.portrait:SetAllPoints()
	b.nom = b:CreateFontString(nil, "OVERLAY")
	b.nom:SetFont(POLICE, 13, "OUTLINE")
	b.nom:SetPoint("TOP", b, "BOTTOM", 0, -2)
	b.distance = b:CreateFontString(nil, "OVERLAY")
	b.distance:SetFont(POLICE, 10, "OUTLINE")
	b.distance:SetTextColor(0.85, 0.85, 0.85)
	b.distance:SetPoint("TOP", b.nom, "BOTTOM", 0, -1)
	-- flèche vers le membre quand il est hors du champ de vision
	b.fleche = b:CreateFontString(nil, "OVERLAY")
	b.fleche:SetFont(POLICE, 22, "OUTLINE")
	b.fleche:SetTextColor(1, 0.82, 0)
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	b:SetScript("OnClick", function(self, bouton)
		if not self.cle then return end
		if bouton == "RightButton" then
			GameTooltip:Hide()
			MontrerMenu(self)
		else
			Chuchoter(self.cle, self.joueur)
		end
	end)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		local r, g, bl = CouleurClasse(self.classe)
		GameTooltip:AddLine(NomJoueur(self.joueur), r, g, bl)
		GameTooltip:AddLine(("à %d %s"):format(self.metres or 0, UNITE), 1, 1, 1)
		GameTooltip:AddLine("Clic : chuchoter · Clic droit : menu", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

-- Flèche d'un repère, refaite seulement quand elle change : "haut" (devant moi, sans flèche),
-- "<", ">" (côtés), "v" (bas, derrière moi)
local function Disposer(r, mode)
	if r.mode == mode then return end
	r.mode = mode
	r.fleche:ClearAllPoints()
	if mode == "haut" then
		r.fleche:Hide()
		r:SetAlpha(1)
		return
	end
	if mode == "<" then r.fleche:SetPoint("RIGHT", r, "LEFT", -2, 0)
	elseif mode == ">" then r.fleche:SetPoint("LEFT", r, "RIGHT", 2, 0)
	else r.fleche:SetPoint("TOP", r.distance, "BOTTOM", 0, 2) end
	r.fleche:SetText(mode)
	r.fleche:Show()
	r:SetAlpha(0.8)
end

-- Membre hors du champ de vision : place sur le tour de l'écran (centre du repère, depuis le centre
-- de l'écran) et flèche. On part du coin du haut (bord du champ de vision), on descend le côté, puis
-- on suit le bas jusqu'au centre (droit derrière moi).
local function PlaceAuBord(angle, demiL, yHaut, yBas)
	local cote = (angle > 0) and -1 or 1 -- angle positif = à ma gauche
	local f = (math.abs(angle) - CHAMP / 2) / (PI - CHAMP / 2)
	if f < 0 then f = 0 elseif f > 1 then f = 1 end
	local lCote, lBas = math.max(0, yHaut - yBas), demiL
	local s = f * (lCote + lBas)
	if s <= lCote then
		return cote * demiL, yHaut - s, (cote < 0) and "<" or ">"
	end
	return cote * (demiL - (s - lCote)), yBas, "v"
end

local function ToutCacher(depuis)
	for i = depuis or 1, #reperes do reperes[i]:Hide() end
end

local visibles = {} -- liste réutilisée à chaque mise à jour
local function TriDistance(a, b) return a.metres > b.metres end -- du plus loin au plus proche

local function Maj()
	local db = DB()
	local positions = ns.PositionsMembres and ns.PositionsMembres()
	if not (db and db.actif and db.reperes ~= false and positions and ns.MaPosition) then return ToutCacher() end
	local carte, x, y = ns.MaPosition()
	local cap = GetPlayerFacing and GetPlayerFacing()
	if not (carte and cap) then return ToutCacher() end -- en instance, ou position inconnue
	local monNord, monOuest = Monde(carte, x, y)
	if not monNord then return ToutCacher() end

	-- membres sur ma carte, avec un portrait
	local maintenant = GetTime()
	for i = #visibles, 1, -1 do visibles[i] = nil end
	for cle, p in pairs(positions) do
		if p.carte == carte and not p.instance and p.portrait and maintenant - (p.vu or 0) < DUREE_VIE then
			local nord, ouest = MondeMembre(cle, p)
			if nord then
				local dn, dO = nord - monNord, ouest - monOuest
				-- angle depuis le nord vers l'ouest, comme GetPlayerFacing ; relatif à mon cap, entre -pi et pi
				local angle = (atan2(dO, dn) - cap) % (2 * PI)
				if angle > PI then angle = angle - 2 * PI end
				visibles[#visibles + 1] = { cle = cle, p = p, angle = angle, metres = math.sqrt(dn * dn + dO * dO) }
			end
		end
	end
	table.sort(visibles, TriDistance)

	local demi = cadre:GetWidth() / 2
	local demiL = math.max(0, demi - MARGE)
	local yHaut = cadre:GetHeight() / 2 - (tonumber(db.hautReperes) or HAUT) -- centre des portraits du haut, depuis le centre de l'écran
	local yBas = -cadre:GetHeight() / 2 + (tonumber(db.basReperes) or BAS)
	local tanDemi = math.tan(CHAMP / 2)
	for i, v in ipairs(visibles) do
		local r = reperes[i]
		if not r then r = NouveauRepere(); reperes[i] = r end
		r:ClearAllPoints()
		if math.abs(v.angle) < CHAMP / 2 then
			-- devant moi : bord du haut ; projection comme sur l'écran (tangente)
			Disposer(r, "haut")
			local px = -math.tan(v.angle) / tanDemi * demi
			if px < -demiL then px = -demiL elseif px > demiL then px = demiL end
			r:SetPoint("CENTER", cadre, "CENTER", px, yHaut)
		else
			local px, py, fleche = PlaceAuBord(v.angle, demiL, yHaut, yBas)
			Disposer(r, fleche)
			r:SetPoint("CENTER", cadre, "CENTER", px, py)
		end
		r:SetFrameLevel(cadre:GetFrameLevel() + i) -- le plus proche par-dessus
		r.cle, r.joueur, r.classe, r.metres = v.cle, v.p.nom, v.p.classe, math.floor(v.metres + 0.5)
		r.portrait:SetTexture(v.p.portrait)
		r.nom:SetText(NomJoueur(v.p.nom, true)) -- « Pseudo (Prénom) », ou le prénom seul
		r.nom:SetTextColor(CouleurClasse(v.p.classe))
		r.distance:SetText(r.metres .. " " .. UNITE)
		r:Show()
	end
	ToutCacher(#visibles + 1)
end

local attente = 0
cadre:SetScript("OnUpdate", function(self, ecoule)
	attente = attente + ecoule
	if attente < PERIODE then return end
	attente = 0
	Maj()
end)

-- pour /smb reperes et la case des options
ns.MajReperes = Maj
