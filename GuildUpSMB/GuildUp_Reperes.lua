-- GuildUpSMB : repères des membres de la guilde dans le HUD, comme dans un jeu de tir.
--
-- Les membres qui partagent leur position (GuildUp_Carte.lua, message P) et se trouvent sur la même
-- carte que moi ont un repère à l'écran, placé selon leur direction vue depuis mon personnage
-- (GetPlayerFacing : c'est l'orientation du personnage, pas celle de la caméra quand on la tourne au
-- clic gauche) :
--   - barre de nom du membre affichée (il est à l'écran et assez proche) : chevron doré et distance
--     au-dessus de sa tête, accrochés à sa barre de nom (placement exact, suit ses mouvements) ;
--   - devant moi mais trop loin pour avoir une barre de nom : portrait, prénom et distance au milieu
--     de l'écran, sur la ligne d'horizon (là où se trouve un personnage lointain), à l'horizontale
--     dans sa direction ;
--   - hors du champ de vision : même repère au bord de l'écran, avec une flèche. Le tour de l'écran
--     suit la direction : à droite ou à gauche sur les côtés (à partir de l'horizon), plus bas à
--     mesure qu'il passe derrière moi, puis en bas, au centre quand il est juste derrière.
-- Seuls les membres dont le portrait est connu sont affichés (addon à jour, race avec portrait).
-- Pas de hauteur : les positions de la carte n'ont pas d'altitude.
-- Clic : chuchoter. Réglage db.reperes (/smb reperes, case dans les options).
-- Aucun message réseau propre : tout vient des positions de GuildUp_Carte.lua (une toutes les 6 s
-- au plus pour un membre qui bouge), d'où des petits sauts quand un membre proche se déplace (sauf
-- au-dessus de sa tête : la barre de nom suit le personnage en continu).

local NOM_ADDON, ns = ...

local NomCourt = ns.NomCourt
local CouleurClasse = ns.CouleurClasse
local NomComplet = ns.Coeur and ns.Coeur.NomComplet

local CHAMP = math.rad((ns.Config and tonumber(ns.Config.champVisionReperes)) or 90) -- largeur de l'écran (angle)
local HORIZON = (ns.Config and tonumber(ns.Config.horizonReperes)) or 40 -- ligne d'horizon, au-dessus du centre de l'écran
local BAS = (ns.Config and tonumber(ns.Config.basReperes)) or 150 -- centre des repères du bas (au-dessus des barres d'action)
local TAILLE = 40        -- diamètre du portrait (pixels)
local MARGE = 50         -- distance minimale au bord de l'écran (côtés)
local DUREE_VIE = 45     -- secondes sans nouvelles d'un membre avant de cacher son repère
local PERIODE = 0.02     -- secondes entre deux mises à jour (mouvement fluide)
local PERIODE_PLAQUES = 1 -- secondes entre deux relevés complets des barres de nom (en plus des évènements)
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
-- Barres de nom affichées
--------------------------------------------------------------------------------

-- [nom normalisé] = région à laquelle accrocher le repère (nom de la barre, ou la barre elle-même).
-- Relevé aux évènements des barres de nom et toutes les PERIODE_PLAQUES secondes, pas à chaque image.
local plaques = {}
local plaquesARelever = true
local depuisReleve = 0

local function ReleverPlaques()
	plaquesARelever, depuisReleve = false, 0
	for k in pairs(plaques) do plaques[k] = nil end
	if not (C_NamePlate and C_NamePlate.GetNamePlates and NomComplet) then return end
	for _, plaque in ipairs(C_NamePlate.GetNamePlates() or {}) do
		if not (plaque.IsForbidden and plaque:IsForbidden()) then
			local uf = plaque.UnitFrame
			local unite = plaque.namePlateUnitToken or (uf and uf.unit)
			if unite and UnitIsPlayer(unite) then
				local cle = NomComplet(unite)
				-- le nom de Blizzard est juste au-dessus de la tête ; s'il est caché (autre addon de
				-- barres de nom), la barre elle-même
				local ancre = (uf and uf:IsShown() and uf.name and uf.name:IsShown()) and uf.name or plaque
				if cle then plaques[cle] = ancre end
			end
		end
	end
end

local ev = CreateFrame("Frame")
for _, e in ipairs({ "NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "UNIT_NAME_UPDATE", "PLAYER_ENTERING_WORLD" }) do
	pcall(ev.RegisterEvent, ev, e)
end
ev:SetScript("OnEvent", function() plaquesARelever = true end)

--------------------------------------------------------------------------------
-- Repères
--------------------------------------------------------------------------------

local reperes = {} -- boutons réutilisés

local function NomChuchotement(r)
	local nom = (ns.NomListeGuilde and ns.NomListeGuilde(r.cle)) or NomCourt(r.joueur)
	if r.cle and r.cle:find("#test", 1, true) then nom = UnitName("player") end
	return nom
end

local function NouveauRepere()
	local b = CreateFrame("Button", nil, cadre)
	b:SetSize(TAILLE, TAILLE)
	b.portrait = b:CreateTexture(nil, "ARTWORK")
	b.portrait:SetAllPoints()
	b.nom = b:CreateFontString(nil, "OVERLAY")
	b.nom:SetFont(POLICE, 13, "OUTLINE")
	b.distance = b:CreateFontString(nil, "OVERLAY")
	b.distance:SetFont(POLICE, 10, "OUTLINE")
	b.distance:SetTextColor(0.85, 0.85, 0.85)
	-- flèche vers le membre (bord de l'écran) ou chevron au-dessus de sa tête
	b.fleche = b:CreateFontString(nil, "OVERLAY")
	b.fleche:SetFont(POLICE, 22, "OUTLINE")
	b.fleche:SetTextColor(1, 0.82, 0)
	b:RegisterForClicks("LeftButtonUp")
	b:SetScript("OnClick", function(self)
		local nom = NomChuchotement(self)
		if ChatFrame_SendTell then ChatFrame_SendTell(nom)
		elseif ChatFrame_OpenChat then ChatFrame_OpenChat("/w " .. nom .. " ") end
	end)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		local r, g, bl = CouleurClasse(self.classe)
		GameTooltip:AddLine(NomCourt(self.joueur), r, g, bl)
		GameTooltip:AddLine(("à %d %s"):format(self.metres or 0, UNITE), 1, 1, 1)
		GameTooltip:AddLine("Clic : chuchoter", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

-- Mise en page d'un repère, refaite seulement quand elle change :
-- "tete" (au-dessus de la barre de nom), "horizon" (sans flèche), "<", ">", "v" (bord de l'écran)
local function Disposer(r, mode)
	if r.mode == mode then return end
	r.mode = mode
	r.nom:ClearAllPoints(); r.distance:ClearAllPoints(); r.fleche:ClearAllPoints()
	if mode == "tete" then
		-- le portrait et le nom sont déjà sur la barre de nom : chevron et distance seulement, et pas de
		-- clic (le repère est au milieu du monde, il ne doit pas gêner le clic droit sur le joueur)
		r.portrait:Hide(); r.nom:Hide()
		r.fleche:SetPoint("BOTTOM", r, "BOTTOM", 0, 0)
		r.fleche:SetText("v")
		r.fleche:Show()
		r.distance:SetPoint("BOTTOM", r.fleche, "TOP", 0, -4)
		r:EnableMouse(false)
		r:SetAlpha(1)
		return
	end
	r.portrait:Show(); r.nom:Show()
	r.nom:SetPoint("TOP", r, "BOTTOM", 0, -2)
	r.distance:SetPoint("TOP", r.nom, "BOTTOM", 0, -1)
	r:EnableMouse(true)
	if mode == "horizon" then
		r.fleche:Hide()
		r:SetAlpha(1)
		return
	end
	if mode == "<" then r.fleche:SetPoint("RIGHT", r, "LEFT", -2, 0)
	elseif mode == ">" then r.fleche:SetPoint("LEFT", r, "RIGHT", 2, 0)
	else r.fleche:SetPoint("TOP", r.distance, "BOTTOM", 0, 2) end
	r.fleche:SetText(mode)
	r.fleche:Show()
	r:SetAlpha(0.7)
end

-- Membre hors du champ de vision : place sur le tour de l'écran (centre du repère, depuis le centre
-- de l'écran) et flèche. On part du côté à hauteur de l'horizon (bord du champ de vision), on
-- descend le côté, puis on suit le bas jusqu'au centre (droit derrière moi).
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
	if plaquesARelever or depuisReleve >= PERIODE_PLAQUES then ReleverPlaques() end

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
	local yHaut = HORIZON -- centre du portrait, depuis le centre de l'écran
	local yBas = -cadre:GetHeight() / 2 + BAS
	local tanDemi = math.tan(CHAMP / 2)
	for i, v in ipairs(visibles) do
		local r = reperes[i]
		if not r then r = NouveauRepere(); reperes[i] = r end
		r:ClearAllPoints()
		local ancre = plaques[v.cle]
		if ancre then
			-- à l'écran et assez proche pour avoir une barre de nom : au-dessus de sa tête
			Disposer(r, "tete")
			r:SetPoint("BOTTOM", ancre, "TOP", 0, 2)
		elseif math.abs(v.angle) < CHAMP / 2 then
			-- devant moi, loin : sur l'horizon ; projection comme sur l'écran (tangente)
			Disposer(r, "horizon")
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
		r.nom:SetText(NomCourt(v.p.nom):match("^(%S+)") or NomCourt(v.p.nom)) -- prénom seul
		r.nom:SetTextColor(CouleurClasse(v.p.classe))
		r.distance:SetText(r.metres .. " " .. UNITE)
		r:Show()
	end
	ToutCacher(#visibles + 1)
end

local attente = 0
cadre:SetScript("OnUpdate", function(self, ecoule)
	depuisReleve = depuisReleve + ecoule
	attente = attente + ecoule
	if attente < PERIODE then return end
	attente = 0
	Maj()
end)

-- pour /smb reperes et la case des options
ns.MajReperes = Maj
