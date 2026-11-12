-- GuildUpSMB : repères des membres de la guilde dans le HUD, comme dans un jeu de tir.
--
-- Les membres qui partagent leur position (GuildUp_Carte.lua, message P) et se trouvent sur la même
-- carte que moi apparaissent en haut de l'écran : portrait rond, nom à la couleur de la classe,
-- distance. Chaque repère se place à l'horizontale dans la direction du membre, vue depuis mon
-- personnage (GetPlayerFacing : c'est l'orientation du personnage, pas celle de la caméra quand on la
-- tourne au clic gauche). Hors du champ de vision, le repère reste collé au bord, avec une flèche.
-- Seuls les membres dont le portrait est connu sont affichés (addon à jour, race avec portrait).
-- Clic : chuchoter. Réglage db.reperes (/smb reperes, case dans les options).
-- Aucun message réseau propre : tout vient des positions de GuildUp_Carte.lua (une toutes les 6 s
-- au plus pour un membre qui bouge), d'où des petits sauts quand un membre proche se déplace.

local NOM_ADDON, ns = ...

local NomCourt = ns.NomCourt
local CouleurClasse = ns.CouleurClasse

local CHAMP = math.rad((ns.Config and tonumber(ns.Config.champVisionReperes)) or 90) -- largeur de l'écran (angle)
local HAUTEUR = (ns.Config and tonumber(ns.Config.hauteurReperes)) or -30 -- position sous le haut de l'écran
local TAILLE = 40        -- diamètre du portrait (pixels)
local MARGE = 50         -- distance minimale au bord de l'écran
local DUREE_VIE = 45     -- secondes sans nouvelles d'un membre avant de cacher son repère
local PERIODE = 0.02     -- secondes entre deux mises à jour (mouvement fluide)
local UNITE = (GetLocale() == "enUS" or GetLocale() == "enGB") and "yd" or "m"
local POLICE = (GameFontNormal and GameFontNormal:GetFont()) or STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
local atan2 = math.atan2 or math.atan

local function DB() return ns.DB and ns.DB() end

local cadre = CreateFrame("Frame", "GuildUpReperes", UIParent)
cadre:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, HAUTEUR)
cadre:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, HAUTEUR)
cadre:SetHeight(TAILLE + 30)
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
	b.nom:SetPoint("TOP", b, "BOTTOM", 0, -2)
	b.distance = b:CreateFontString(nil, "OVERLAY")
	b.distance:SetFont(POLICE, 10, "OUTLINE")
	b.distance:SetTextColor(0.85, 0.85, 0.85)
	b.distance:SetPoint("TOP", b.nom, "BOTTOM", 0, -1)
	-- flèche quand le membre est hors du champ de vision
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
				local angle = (atan2(dO, dn) - cap) % (2 * math.pi)
				if angle > math.pi then angle = angle - 2 * math.pi end
				visibles[#visibles + 1] = { cle = cle, p = p, angle = angle, metres = math.sqrt(dn * dn + dO * dO) }
			end
		end
	end
	table.sort(visibles, TriDistance)

	local demi = cadre:GetWidth() / 2
	local limite = math.max(0, demi - MARGE)
	local tanDemi = math.tan(CHAMP / 2)
	for i, v in ipairs(visibles) do
		local r = reperes[i]
		if not r then r = NouveauRepere(); reperes[i] = r end
		-- angle positif = à ma gauche ; projection comme sur l'écran (tangente), bornée aux bords
		local px, fleche
		if math.abs(v.angle) < CHAMP / 2 then
			px = -math.tan(v.angle) / tanDemi * demi
		else
			px, fleche = (v.angle > 0) and -demi or demi, (v.angle > 0) and "<" or ">"
		end
		if px < -limite then px = -limite elseif px > limite then px = limite end
		r:ClearAllPoints()
		r:SetPoint("TOP", cadre, "TOP", px, 0)
		r:SetFrameLevel(cadre:GetFrameLevel() + i) -- le plus proche par-dessus
		r.cle, r.joueur, r.classe, r.metres = v.cle, v.p.nom, v.p.classe, math.floor(v.metres + 0.5)
		r.portrait:SetTexture(v.p.portrait)
		r.nom:SetText(NomCourt(v.p.nom):match("^(%S+)") or NomCourt(v.p.nom)) -- prénom seul
		r.nom:SetTextColor(CouleurClasse(v.p.classe))
		r.distance:SetText(r.metres .. " " .. UNITE)
		if fleche then
			r.fleche:ClearAllPoints()
			if fleche == "<" then r.fleche:SetPoint("RIGHT", r, "LEFT", -2, 0)
			else r.fleche:SetPoint("LEFT", r, "RIGHT", 2, 0) end
			r.fleche:SetText(fleche)
			r.fleche:Show()
			r:SetAlpha(0.7)
		else
			r.fleche:Hide()
			r:SetAlpha(1)
		end
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
