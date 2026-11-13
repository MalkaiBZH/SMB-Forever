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
-- Seuls les membres dont le portrait est connu sont affichés (addon à jour, race avec portrait), et
-- seulement au-delà d'une distance minimale (db.distanceMinReperes, sinon celle de GuildUp_Config.lua :
-- plus près, on le voit en jeu ; 0 = toujours).
-- Layer (GuildUp_Layers.lua) : « · autre layer » en orange après la distance, ligne dans l'infobulle, et
-- « Demander à rejoindre son layer » dans le menu quand on sait qu'il est sur un autre layer.
-- Clic : chuchoter ; clic droit : menu (chuchoter, inviter dans le groupe, suivre sa trace, voir dans la
-- page Guilde). Réglage db.reperes (/smb reperes, case dans les options) ; hauteur des repères du haut et
-- du bas, distance minimale : curseurs de la page Options, sinon valeurs de GuildUp_Config.lua.
-- Fil d'Ariane : chaque position reçue d'un membre (ns.NoterTrace, appelé par GuildUp_Carte.lua) allonge
-- sa trace (10 dernières minutes, un point tous les 4 m au moins). « Suivre sa trace » montre un repère
-- « pas » sur l'étape suivante : on part du point de la trace le plus proche, on avance d'étape en étape
-- (raccourcis compris), jusqu'à rejoindre le membre, ou jusqu'au bout de la trace s'il est entré en
-- instance ou ne donne plus de nouvelles. La carte du monde dessine la trace suivie (ns.TraceSuivie).
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
local DISTANCE_MIN = (ns.Config and tonumber(ns.Config.distanceMinReperes)) or 100 -- pas de repère plus près (m / yards)
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

-- position sur le monde d'un point de carte : nord, ouest (en mètres / yards du jeu), continent, ou nil.
-- (C_Map.GetWorldPosFromMapPos rend le continent et un vecteur dont x pointe vers le nord et y vers l'ouest)
local function Monde(carte, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then return nil end
	local ok, continent, v = pcall(C_Map.GetWorldPosFromMapPos, carte, CreateVector2D(x, y))
	if not ok or not v then return nil end
	local ok2, nord, ouest = pcall(v.GetXY, v)
	if not ok2 or not nord or not ouest then return nil end
	return nord, ouest, continent
end

-- position sur le monde des membres, recalculée seulement quand leur position change
local mondes = {} -- [nom normalisé] = { carte, x, y, nord, ouest, continent }
local function MondeMembre(cle, p)
	local m = mondes[cle]
	if not (m and m.carte == p.carte and m.x == p.x and m.y == p.y) then
		local nord, ouest, continent = Monde(p.carte, p.x, p.y)
		m = { carte = p.carte, x = p.x, y = p.y, nord = nord, ouest = ouest, continent = continent }
		mondes[cle] = m
	end
	return m.nord, m.ouest, m.continent
end

local function Distance(pt, nord, ouest)
	local dn, dO = pt.nord - nord, pt.ouest - ouest
	return math.sqrt(dn * dn + dO * dO)
end

--------------------------------------------------------------------------------
-- Fil d'Ariane : trace récente de chaque membre, et suivi d'une trace
--------------------------------------------------------------------------------

local TRACE_DUREE = 600  -- secondes de trace gardées (la trace suivie n'est pas raccourcie en route)
local TRACE_MAX = 300    -- points au plus par trace
local TRACE_PAS = 4      -- distance minimale entre deux points (m / yards)
local ATTEINT = 10       -- une étape est atteinte à cette distance
local REJOINT = 20       -- le membre est rejoint à cette distance

local traces = {} -- [nom normalisé] = { points = { { carte, x, y, nord, ouest, continent, t, n }, … }, n }
local suivi       -- { cle, joueur, n = numéro du point visé (nil : pas encore choisi) }

-- position reçue d'un membre (GuildUp_Carte.lua, message P)
ns.NoterTrace = function(cle, p)
	if not (cle and p and p.carte and p.x) then return end
	local nord, ouest, continent = Monde(p.carte, p.x, p.y)
	if not nord then return end
	local t = traces[cle]
	if not t then t = { points = {}, n = 0 }; traces[cle] = t end
	local pts = t.points
	local maintenant = GetTime()
	local dernier = pts[#pts]
	if dernier and dernier.continent == continent and Distance(dernier, nord, ouest) < TRACE_PAS then
		dernier.t = maintenant -- (toujours au même endroit)
		return
	end
	t.n = t.n + 1
	pts[#pts + 1] = { carte = p.carte, x = p.x, y = p.y, nord = nord, ouest = ouest, continent = continent,
		t = maintenant, n = t.n }
	local garder = suivi and suivi.cle == cle
	local limite = maintenant - TRACE_DUREE
	while #pts > TRACE_MAX or (not garder and #pts > 1 and pts[1].t < limite) do table.remove(pts, 1) end
end

local function Arreter(texte)
	suivi = nil
	if texte and ns.Notifier then ns.Notifier("reperes", "Fil d'Ariane", texte, "aucun") end
	if ns.RedessinerCarte then ns.RedessinerCarte() end
end

local function Suivre(cle, joueur)
	local t = traces[cle]
	if not (t and #t.points > 0) then
		if ns.Erreur then ns.Erreur("Pas encore de trace pour " .. NomJoueur(joueur)) end
		return
	end
	suivi = { cle = cle, joueur = joueur } -- (première étape : le point de la trace le plus proche de moi)
	if ns.RedessinerCarte then ns.RedessinerCarte() end
end

-- index du premier point de la trace pas encore atteint (trace suivie)
local function IndexEtape(pts)
	if not suivi.n then return 1 end
	local i = 1
	while i < #pts and pts[i].n < suivi.n do i = i + 1 end
	return i
end

-- trace suivie, pour la carte du monde : points, index de l'étape visée (nil sans suivi ou pas encore choisie)
ns.TraceSuivie = function()
	local t = suivi and traces[suivi.cle]
	if not (t and #t.points > 0) then return nil end
	return t.points, suivi.n and IndexEtape(t.points) or nil
end

-- Avance sur la trace suivie ; renvoie l'étape visée, sa distance, son rang et le nombre de points,
-- ou nil quand le suivi s'arrête (membre rejoint, bout de la trace, autre continent)
local function Avancer(monNord, monOuest, monCont)
	local nom = NomJoueur(suivi.joueur)
	local t = traces[suivi.cle]
	local pts = t and t.points
	if not (pts and #pts > 0) then Arreter(("La trace de %s a disparu."):format(nom)); return nil end
	local positions = ns.PositionsMembres and ns.PositionsMembres()
	local p = positions and positions[suivi.cle]
	local present = p and not p.instance and p.carte and GetTime() - (p.vu or 0) < DUREE_VIE
	if present then
		local nord, ouest, continent = MondeMembre(suivi.cle, p)
		if nord and continent == monCont and Distance({ nord = nord, ouest = ouest }, monNord, monOuest) < REJOINT then
			Arreter(("Tu as rejoint %s."):format(nom))
			return nil
		end
	end
	-- raccourci : le point le plus proche de moi parmi ceux qui restent (au départ : toute la trace)
	local meilleur, dMeilleur
	for j = IndexEtape(pts), #pts do
		local pt = pts[j]
		if pt.continent == monCont then
			local d = Distance(pt, monNord, monOuest)
			if not dMeilleur or d < dMeilleur then meilleur, dMeilleur = j, d end
		end
	end
	if not meilleur then Arreter(("La trace de %s part sur un autre continent."):format(nom)); return nil end
	local i = meilleur
	while i < #pts and pts[i + 1].continent == monCont and Distance(pts[i], monNord, monOuest) < ATTEINT do i = i + 1 end
	local d = Distance(pts[i], monNord, monOuest)
	if i == #pts and d < ATTEINT and not present then
		Arreter(p and p.instance and ("Bout de la trace : %s a rejoint une instance à cet endroit."):format(nom)
			or ("Bout de la trace de %s : plus de nouvelles de sa position."):format(nom))
		return nil
	end
	suivi.n = pts[i].n
	return pts[i], d, i, #pts
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
		(suivi and suivi.cle == cle) and { "Arrêter de suivre sa trace", function() Arreter() end }
			or { "Suivre sa trace", function() Suivre(cle, joueur) end },
		{ "Voir dans la page Guilde", function()
			if ns.OuvrirInterface then ns.OuvrirInterface("guilde", NomCourt(joueur)) end
		end },
	}
	-- sur un autre layer (GuildUp_Layers.lua) : lui demander de m'inviter pour passer sur le sien
	if ns.MemeLayer and ns.DemanderLayer and ns.MemeLayer(cle) == false then
		table.insert(lignes, 3, { "Demander à rejoindre son layer", function() ns.DemanderLayer(cle, joueur) end })
	end
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
		local layer = ns.TexteLayer and ns.TexteLayer(self.cle)
		if layer then GameTooltip:AddLine(layer, 1, 1, 1) end
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

-- Repère « pas » de l'étape suivante du fil d'Ariane (créé au premier suivi)
local pas
local function CreerPas()
	local b = NouveauRepere()
	b:SetSize(30, 30)
	b.portrait:SetTexture("Interface\\Icons\\Ability_Tracking")
	b.portrait:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	local bord = b:CreateTexture(nil, "BACKGROUND")
	bord:SetPoint("TOPLEFT", b, "TOPLEFT", -2, 2)
	bord:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 2, -2)
	bord:SetColorTexture(1, 0.82, 0, 0.9)
	b.nom:SetTextColor(1, 0.82, 0)
	b:SetScript("OnClick", function() GameTooltip:Hide(); Arreter() end)
	b:SetScript("OnEnter", function(self)
		if not suivi then return end
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:AddLine("Fil d'Ariane : trace de " .. NomJoueur(suivi.joueur), 1, 0.82, 0)
		GameTooltip:AddLine(("Étape %d sur %d, à %d %s"):format(self.rang or 0, self.total or 0, self.metres or 0, UNITE), 1, 1, 1)
		GameTooltip:AddLine("Suis les pas : le repère avance à chaque étape atteinte.", 0.8, 0.8, 0.8, true)
		GameTooltip:AddLine("Clic : arrêter de suivre", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	return b
end

local function ToutCacher(depuis)
	for i = depuis or 1, #reperes do reperes[i]:Hide() end
	if not depuis and pas then pas:Hide() end
end

-- Place un repère sur le tour de l'écran selon son angle (relatif à mon cap, entre -pi et pi)
local function Placer(r, angle, demi, demiL, yHaut, yBas, tanDemi)
	r:ClearAllPoints()
	if math.abs(angle) < CHAMP / 2 then
		-- devant moi : bord du haut ; projection comme sur l'écran (tangente)
		Disposer(r, "haut")
		local px = -math.tan(angle) / tanDemi * demi
		if px < -demiL then px = -demiL elseif px > demiL then px = demiL end
		r:SetPoint("CENTER", cadre, "CENTER", px, yHaut)
	else
		local px, py, fleche = PlaceAuBord(angle, demiL, yHaut, yBas)
		Disposer(r, fleche)
		r:SetPoint("CENTER", cadre, "CENTER", px, py)
	end
end

-- angle d'un point du monde vu depuis moi : depuis le nord vers l'ouest (comme GetPlayerFacing),
-- relatif à mon cap, entre -pi et pi
local function Angle(nord, ouest, monNord, monOuest, cap)
	local angle = (atan2(ouest - monOuest, nord - monNord) - cap) % (2 * PI)
	if angle > PI then angle = angle - 2 * PI end
	return angle
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
	local monNord, monOuest, monCont = Monde(carte, x, y)
	if not monNord then return ToutCacher() end

	-- membres sur ma carte, avec un portrait
	local maintenant = GetTime()
	local distanceMin = tonumber(db.distanceMinReperes) or DISTANCE_MIN
	for i = #visibles, 1, -1 do visibles[i] = nil end
	for cle, p in pairs(positions) do
		if p.carte == carte and not p.instance and p.portrait and maintenant - (p.vu or 0) < DUREE_VIE then
			local nord, ouest = MondeMembre(cle, p)
			if nord then
				local angle = Angle(nord, ouest, monNord, monOuest, cap)
				local metres = Distance({ nord = nord, ouest = ouest }, monNord, monOuest)
				if metres >= distanceMin then -- (plus près : visible en jeu)
					visibles[#visibles + 1] = { cle = cle, p = p, angle = angle, metres = metres }
				end
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
		Placer(r, v.angle, demi, demiL, yHaut, yBas, tanDemi)
		r:SetFrameLevel(cadre:GetFrameLevel() + i) -- le plus proche par-dessus
		r.cle, r.joueur, r.classe, r.metres = v.cle, v.p.nom, v.p.classe, math.floor(v.metres + 0.5)
		r.portrait:SetTexture(v.p.portrait)
		r.nom:SetText(NomJoueur(v.p.nom, true)) -- « Pseudo (Prénom) », ou le prénom seul
		r.nom:SetTextColor(CouleurClasse(v.p.classe))
		-- (autre layer : en orange, le membre n'est pas visible même tout près)
		local autre = ns.MemeLayer and ns.MemeLayer(v.cle) == false
		r.distance:SetText(r.metres .. " " .. UNITE .. (autre and " · autre layer" or ""))
		if autre then r.distance:SetTextColor(1, 0.62, 0.25) else r.distance:SetTextColor(0.85, 0.85, 0.85) end
		r:Show()
	end
	ToutCacher(#visibles + 1)

	-- fil d'Ariane : l'étape suivante, par-dessus les membres
	local etape, metres, rang, total
	if suivi then etape, metres, rang, total = Avancer(monNord, monOuest, monCont) end
	if not etape then
		if pas then pas:Hide() end
		return
	end
	pas = pas or CreerPas()
	Placer(pas, Angle(etape.nord, etape.ouest, monNord, monOuest, cap), demi, demiL, yHaut, yBas, tanDemi)
	pas:SetFrameLevel(cadre:GetFrameLevel() + #visibles + 2)
	pas.metres, pas.rang, pas.total = math.floor(metres + 0.5), rang, total
	pas.nom:SetText("Trace de " .. NomJoueur(suivi.joueur, true))
	pas.distance:SetText(pas.metres .. " " .. UNITE)
	pas:Show()
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
