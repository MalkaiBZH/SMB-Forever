-- GuildUp : positions des membres de la guilde sur la carte du monde.
-- Chacun choisit de partager sa position (bouton « Position » du volet de la mini-carte,
-- coupé par défaut). Messages d'addon invisibles sur le canal de guilde :
--   "P~carte~x~y~CLASSE"  position (carte = uiMapID de C_Map.GetBestMapForUnit, x/y entre 0 et 1)
--   "I"                    en instance (pas de position utilisable)
--   "O"                    partage coupé
-- Envoi toutes les INTERVALLE secondes si le joueur a bougé, sinon un signal toutes les BATTEMENT s.
-- Sur la carte : un point par membre, à la couleur de sa classe ; nom, rôle et âge de la position
-- au survol. Les positions sont converties pour s'afficher aussi sur la carte du continent.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpPos"
local INTERVALLE = 3     -- secondes entre deux vérifications de ma position
local BATTEMENT = 15     -- envoi même sans bouger, pour dire « je suis toujours là »
local DUREE_VIE = 30     -- secondes sans nouvelles avant d'effacer un membre
local TAILLE_POINT = 10   -- petit point de couleur (couleur de classe)

local positions = {}     -- [nom normalisé] = { nom, carte, x, y, classe, vu, instance }
local dernier = { carte = nil, x = -1, y = -1, t = 0, etat = nil }
local epingles = {}      -- points affichés sur la carte (réutilisés)
local MajCarte

local function DB() return ns.DB and ns.DB() end

local function Partage()
	local db = DB()
	return db and db.actif and db.partagePosition
end

local function Normaliser(nom)
	if ns.Normaliser then return ns.Normaliser(nom) end
	return nom
end

local function Envoyer(msg)
	if not IsInGuild() then return end
	local envoi = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage
	if envoi then pcall(envoi, PREFIXE, msg, "GUILD") end
end

--------------------------------------------------------------------------------
-- Envoi de ma position
--------------------------------------------------------------------------------

local function MaPosition()
	if not (C_Map and C_Map.GetBestMapForUnit) then return nil end
	local ok, carte = pcall(C_Map.GetBestMapForUnit, "player")
	if not ok or not carte then return nil end
	local ok2, pos = pcall(C_Map.GetPlayerMapPosition, carte, "player")
	if not ok2 or not pos then return nil end
	local ok3, x, y = pcall(pos.GetXY, pos)
	if not ok3 or not x or not y or (x == 0 and y == 0) then return nil end
	return carte, x, y
end

local function Emettre(force)
	local maintenant = GetTime()
	if not Partage() then
		-- on prévient une seule fois que le partage est coupé
		if dernier.etat and dernier.etat ~= "O" then
			Envoyer("O")
			dernier.etat = "O"
		end
		return
	end
	local carte, x, y = MaPosition()
	if not carte then
		if force or dernier.etat ~= "I" or maintenant - dernier.t > BATTEMENT then
			Envoyer("I")
			dernier.etat, dernier.t = "I", maintenant
		end
		return
	end
	local bouge = carte ~= dernier.carte or math.abs(x - dernier.x) > 0.0005 or math.abs(y - dernier.y) > 0.0005
	if force or bouge or maintenant - dernier.t > BATTEMENT then
		local _, classe = UnitClass("player")
		Envoyer(("P~%d~%.4f~%.4f~%s"):format(carte, x, y, classe or ""))
		dernier.carte, dernier.x, dernier.y, dernier.t, dernier.etat = carte, x, y, maintenant, "P"
	end
end

-- appelé par GuildUp.lua quand on clique sur le bouton « Position »
ns.SurChangementPartage = function()
	Emettre(true)
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if cle == Normaliser(UnitName("player")) and not (ns.TestSolo and ns.TestSolo()) then return end
	local type_, a, b, c, d = strsplit("~", msg)
	if type_ == "P" then
		positions[cle] = {
			nom = expediteur, carte = tonumber(a), x = tonumber(b), y = tonumber(c),
			classe = (d and d ~= "") and d or nil, vu = GetTime(),
		}
	elseif type_ == "I" then
		positions[cle] = { nom = expediteur, instance = true, vu = GetTime() }
	elseif type_ == "O" then
		positions[cle] = nil
	end
	if MajCarte then MajCarte() end
end

--------------------------------------------------------------------------------
-- Affichage sur la carte du monde
--------------------------------------------------------------------------------

-- Position d'un membre sur la carte affichée (même zone, ou conversion par les coordonnées du monde)
local function PositionSurCarte(p, carteAffichee)
	if not p.carte or not p.x then return nil end
	if p.carte == carteAffichee then return p.x, p.y end
	if not (C_Map.GetWorldPosFromMapPos and C_Map.GetMapPosFromWorldPos and CreateVector2D) then return nil end
	local ok, continent, monde = pcall(C_Map.GetWorldPosFromMapPos, p.carte, CreateVector2D(p.x, p.y))
	if not ok or not continent or not monde then return nil end
	local ok2, _, pos = pcall(C_Map.GetMapPosFromWorldPos, continent, monde, carteAffichee)
	if not ok2 or not pos then return nil end
	local x, y = pos:GetXY()
	if not x or x < 0 or x > 1 or y < 0 or y > 1 then return nil end
	return x, y
end

local function CouleurClasse(classe)
	local c = classe and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classe]
	if c then return c.r, c.g, c.b end
	return 1, 0.82, 0
end

local NOMS_ROLES = { tank = "|cff3399ffTank|r", heal = "|cff33dd55Heal|r", dps = "|cffff4444DPS|r" }

-- Un point = un ancrage (taille 1, à l'échelle de la carte) + le point lui-même, à échelle
-- compensée pour garder la même taille à l'écran quel que soit le zoom
local function CreerEpingle(canevas)
	local ancre = CreateFrame("Frame", nil, canevas)
	ancre:SetSize(1, 1)
	local e = CreateFrame("Button", nil, ancre)
	e:SetSize(TAILLE_POINT + 6, TAILLE_POINT + 6) -- zone de survol un peu plus large que le point
	e:SetPoint("CENTER", ancre, "CENTER", 0, 0)
	e.ancre = ancre
	-- un simple rond de couleur (couleur de classe), cerclé de sombre : plus d'icône de personnage
	e.contour = e:CreateTexture(nil, "BACKGROUND")
	e.contour:SetSize(TAILLE_POINT + 3, TAILLE_POINT + 3)
	e.contour:SetPoint("CENTER", e, "CENTER", 0, 0)
	e.contour:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	e.contour:SetVertexColor(0, 0, 0, 0.85)
	e.point = e:CreateTexture(nil, "ARTWORK")
	e.point:SetSize(TAILLE_POINT, TAILLE_POINT)
	e.point:SetPoint("CENTER", e, "CENTER", 0, 0)
	e.point:SetColorTexture(1, 1, 1, 1)
	local masque = e:CreateMaskTexture()
	masque:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	masque:SetAllPoints(e.point)
	e.point:AddMaskTexture(masque)
	e:SetScript("OnEnter", function(self)
		local p = self.p
		if not p then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		local r, g, b = CouleurClasse(p.classe)
		GameTooltip:SetText(p.nom, r, g, b)
		local role = ns.RoleDeNom and ns.RoleDeNom(self.cle)
		if self.cle == Normaliser(UnitName("player")) and ns.MonRole then role = ns.MonRole() end
		GameTooltip:AddLine("Rôle : " .. (NOMS_ROLES[role] or "|cff999999inconnu|r"), 1, 1, 1)
		GameTooltip:AddLine(("Position d'il y a %d s"):format(math.floor(GetTime() - p.vu)), 0.7, 0.7, 0.7)
		GameTooltip:Show()
	end)
	e:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return e
end

--------------------------------------------------------------------------------
-- Entrées des donjons et raids : repère sur la carte du monde (bouton des groupes)
--------------------------------------------------------------------------------
-- 1. le jeu, s'il connaît les entrées (C_EncounterJournal.GetDungeonEntrancesForMap) ;
-- 2. sinon cette table (contenus classiques) : mots-clés du nom (minuscules, sans accents),
--    carte de zone (uiMapID Classic) et position de l'entrée (0 à 1).
local ENTREES = {
	-- nouveaux donjons de WoW Forever (positions mmonster.co, à confirmer en jeu)
	{ { "thane" }, 1455, 0.278, 0.479 },                                   -- Hall of Thanes (Forgefer)
	{ { "lordaeron" }, 1420, 0.631, 0.675 },                               -- Ruins of Lordaeron (Tirisfal)
	{ { "excavation", "fouille" }, 1437, 0.478, 0.563 },                   -- Excavation Site (Les Paluns)
	{ { "dalaran" }, 1416, 0.088, 0.596 },                                 -- City of Dalaran (Alterac)
	{ { "drowned", "noyee", "cite engloutie", "ville engloutie" }, 1434, 0.214, 0.279 }, -- The Drowned City
	{ { "krol'dok", "kroldok", "krol dok" }, { "riverglades" }, 0.375, 0.375 }, -- Krol'dok Stronghold
	{ { "alcaz" }, 1445, 0.755, 0.137 },                                   -- Alcaz Prison (Marécage d'Âprefange)
	{ { "blackmaw", "noirgueule", "gueule-noire", "gueulenoire", "gueule noire" }, 1447, 0.349, 0.238 }, -- Blackmaw Hold
	{ { "shaper", "faconneur", "terrasse" }, 1449, 0.481, 0.061 },                     -- Shaper's Terrace (Un'Goro)
	-- donjons et raids classiques
	{ { "mortemines", "deadmines" }, 1436, 0.425, 0.717 },
	{ { "prison", "stockade" }, 1453, 0.410, 0.580 },
	{ { "lamentations", "wailing" }, 1413, 0.461, 0.360 },
	{ { "ragefeu", "ragefire" }, 1454, 0.518, 0.496 },
	{ { "ombrecroc", "shadowfang" }, 1421, 0.448, 0.678 },
	{ { "brassenoire", "blackfathom" }, 1440, 0.142, 0.143 },
	{ { "gnomeregan" }, 1426, 0.243, 0.398 },
	{ { "kraal", "kraul" }, 1413, 0.408, 0.945 },
	{ { "ecarlate", "scarlet" }, 1420, 0.826, 0.338 },
	{ { "souilles", "downs" }, 1413, 0.490, 0.939 },
	{ { "uldaman" }, 1418, 0.443, 0.122 },
	{ { "zul'farrak", "zulfarrak" }, 1446, 0.387, 0.201 },
	{ { "maraudon" }, 1443, 0.291, 0.626 },
	{ { "atal'hakkar", "englouti", "sunken" }, 1435, 0.699, 0.535 },
	{ { "rochenoire", "blackrock", "magma", "molten", "aile noire", "blackwing" }, 1428, 0.294, 0.383 },
	{ { "hache-tripes", "haches-tripes", "dire maul" }, 1444, 0.592, 0.451 },
	{ { "scholomance" }, 1422, 0.694, 0.728 },
	{ { "stratholme" }, 1423, 0.313, 0.157 },
	{ { "onyxia" }, 1445, 0.526, 0.768 },
	{ { "zul'gurub", "zulgurub" }, 1434, 0.539, 0.176 },
	{ { "ahn'qiraj", "ahnqiraj" }, 1451, 0.286, 0.924 },
	{ { "naxxramas" }, 1423, 0.399, 0.258 },
}

local ACCENTS = {
	["à"] = "a", ["â"] = "a", ["ç"] = "c", ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e",
	["î"] = "i", ["ï"] = "i", ["ô"] = "o", ["ù"] = "u", ["û"] = "u", ["œ"] = "oe",
	["À"] = "a", ["É"] = "e", ["È"] = "e", ["Ê"] = "e", ["Î"] = "i", ["Ô"] = "o", ["Œ"] = "oe",
}
local function Simplifier(t)
	return ((t or ""):gsub("[\195\197][\128-\191]", ACCENTS)):lower()
end

-- Entrée connue par le jeu, dans la zone de l'activité (ou sa zone parente)
local function EntreeDuJeu(nom, mapID)
	if not (mapID and C_EncounterJournal and C_EncounterJournal.GetDungeonEntrancesForMap) then return nil end
	local cible = Simplifier(nom)
	local cartes = { mapID }
	local okI, info = pcall(C_Map.GetMapInfo, mapID)
	if okI and info and info.parentMapID then cartes[#cartes + 1] = info.parentMapID end
	for _, carte in ipairs(cartes) do
		local ok, liste = pcall(C_EncounterJournal.GetDungeonEntrancesForMap, carte)
		for _, d in ipairs(ok and liste or {}) do
			local n = Simplifier(d.name)
			if n ~= "" and (cible:find(n, 1, true) or n:find(cible, 1, true)) and d.position then
				local x, y = d.position:GetXY()
				return { carte = carte, x = x, y = y }
			end
		end
	end
end

-- Carte d'une zone d'après son nom (pour les zones ajoutées par Forever, sans numéro connu)
local cartesParNom = {}
local function CarteParNom(noms)
	local cle = table.concat(noms, "|")
	if cartesParNom[cle] ~= nil then return cartesParNom[cle] or nil end
	local trouvee
	if C_Map and C_Map.GetMapChildrenInfo then
		for _, continent in ipairs({ 1414, 1415, 947 }) do -- Kalimdor, Royaumes de l'Est, Azeroth
			local ok, liste = pcall(C_Map.GetMapChildrenInfo, continent, nil, true)
			for _, info in ipairs(ok and liste or {}) do
				local n = Simplifier(info.name)
				for _, mot in ipairs(noms) do
					if n:find(mot, 1, true) then trouvee = info.mapID; break end
				end
				if trouvee then break end
			end
			if trouvee then break end
		end
	end
	cartesParNom[cle] = trouvee or false
	return trouvee
end

local entreesVues = {} -- cache par nom
-- Entrées relevées en jeu par le joueur (/gup entree <nom>), prioritaires : pour les donjons
-- propres à Forever, absents de la table ci-dessus
local function EntreesPerso()
	local db = DB()
	if not db then return {} end
	if type(db.entreesPerso) ~= "table" then db.entreesPerso = {} end
	return db.entreesPerso
end

ns.EntreeDonjon = function(nom, mapID)
	if not nom then return nil end
	local s0 = Simplifier(nom)
	for cle, p in pairs(EntreesPerso()) do
		if s0:find(cle, 1, true) then return { carte = p.carte, x = p.x, y = p.y } end
	end
	if entreesVues[nom] ~= nil then return entreesVues[nom] or nil end
	local e = EntreeDuJeu(nom, mapID)
	if not e then
		local s = Simplifier(nom)
		for _, d in ipairs(ENTREES) do
			for _, mot in ipairs(d[1]) do
				if s:find(mot, 1, true) then
					local carte = type(d[2]) == "table" and CarteParNom(d[2]) or d[2]
					if carte then e = { carte = carte, x = d[3], y = d[4] } end
					break
				end
			end
			if e then break end
		end
	end
	entreesVues[nom] = e or false
	return e
end

-- /gup entree <mot du nom> : enregistre ma position actuelle comme entrée de ce contenu
ns.EnregistrerEntree = function(nom)
	nom = Simplifier((nom or ""):gsub("^%s+", ""):gsub("%s+$", ""))
	if nom == "" then return nil, "donne un mot du nom, ex. /gup entree mortemines" end
	local carte, x, y = MaPosition()
	if not carte then return nil, "position introuvable ici (en instance ?)" end
	EntreesPerso()[nom] = { carte = carte, x = x, y = y }
	wipe(entreesVues)
	return ("%s → carte %d, %.3f, %.3f"):format(nom, carte, x, y)
end

local repere -- entrée affichée sur la carte : { nom, carte, x, y }

-- Ouvre la carte du monde sur la zone de l'entrée, avec un repère (et le repère du jeu si possible)
ns.MontrerEntree = function(nom, mapID)
	local e = ns.EntreeDonjon(nom, mapID)
	if not e then return end
	repere = { nom = nom, carte = e.carte, x = e.x, y = e.y }
	-- repère officiel (flèche de suivi), si ce client le permet
	if C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		local ok = pcall(C_Map.SetUserWaypoint, UiMapPoint.CreateFromCoordinates(e.carte, e.x, e.y))
		if ok and C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
	end
	if WorldMapFrame then
		if not WorldMapFrame:IsShown() then
			if ToggleWorldMap then ToggleWorldMap() else WorldMapFrame:Show() end
		end
		if WorldMapFrame.SetMapID then pcall(WorldMapFrame.SetMapID, WorldMapFrame, e.carte) end
	end
	if MajCarte then MajCarte() end
end

local epingleEntree
local function MajRepere(canevas, carte, largeur, hauteur, echelle)
	if not repere then
		if epingleEntree then epingleEntree.ancre:Hide() end
		return
	end
	local x, y = PositionSurCarte(repere, carte)
	if not x then
		if epingleEntree then epingleEntree.ancre:Hide() end
		return
	end
	if not epingleEntree then
		local ancre = CreateFrame("Frame", nil, canevas)
		ancre:SetSize(1, 1)
		local e = CreateFrame("Button", nil, ancre)
		e:SetSize(26, 26)
		e:SetPoint("CENTER", ancre, "CENTER", 0, 0)
		e.icone = e:CreateTexture(nil, "ARTWORK")
		e.icone:SetAllPoints(e)
		e.icone:SetTexture("Interface\\Minimap\\Dungeon")
		e:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(repere and repere.nom or "?", 1, 0.82, 0)
			GameTooltip:AddLine("Entrée de l'instance", 1, 1, 1)
			GameTooltip:AddLine("Clic droit : retirer le repère", 0.6, 0.6, 0.6)
			GameTooltip:Show()
		end)
		e:SetScript("OnLeave", function() GameTooltip:Hide() end)
		e:RegisterForClicks("RightButtonUp")
		e:SetScript("OnClick", function()
			repere = nil
			GameTooltip:Hide()
			if MajCarte then MajCarte() end
		end)
		e.ancre = ancre
		epingleEntree = e
	end
	local a = epingleEntree.ancre
	a:SetParent(canevas)
	a:SetFrameLevel(canevas:GetFrameLevel() + 52)
	a:ClearAllPoints()
	a:SetPoint("CENTER", canevas, "TOPLEFT", x * largeur, -y * hauteur)
	epingleEntree:SetScale(1 / echelle)
	epingleEntree:SetFrameLevel(canevas:GetFrameLevel() + 53)
	a:Show()
	epingleEntree:Show()
end

--------------------------------------------------------------------------------
-- Zones du carnet de craft : formes bleues (comme les zones de quête) aux endroits où vivent les
-- monstres (ou marchands) d'un composant. Effacées quand la carte se ferme.
--   ns.AfficherSurCarte(titre, { { carte = UiMapID, points = { {x, y}, … } (0-100), couleur = {r,g,b} }, … })
--------------------------------------------------------------------------------

local zonesAffichees      -- { titre, groupes }
local bandeau

-- Formes « comme les zones de quête » : les apparitions proches sont regroupées en grappes ; chaque
-- grappe devient un polygone arrondi (enveloppe autour de cercles placés sur chaque apparition),
-- rempli de bleu translucide (bandes horizontales jointives) et bordé d'un trait lumineux.
local RAYON = 2.6          -- rayon autour de chaque apparition (en % de la carte)
local ECART_GRAPPE = 9     -- deux apparitions plus proches que ça (en %) sont dans la même grappe
local ETAPES_CERCLE = 10

local support            -- cadre posé sur le canevas, qui porte les traits
local traits = {}        -- traits réutilisés
local nTraits = 0
local cleDessin          -- évite de tout redessiner tant que rien ne change

local function Trait()
	nTraits = nTraits + 1
	local t = traits[nTraits]
	if not t then
		t = support:CreateLine(nil, "OVERLAY", nil, 7)
		traits[nTraits] = t
	end
	t:Show()
	return t
end

-- regroupement simple : chaque point rejoint la grappe d'un point proche (de proche en proche)
local function Grappes(points)
	local grappe, liste = {}, {}
	for i = 1, #points do
		if not grappe[i] then
			local g = { points[i] }
			grappe[i] = g
			liste[#liste + 1] = g
			local file = { i }
			while #file > 0 do
				local k = table.remove(file)
				for j = 1, #points do
					if not grappe[j] then
						local dx, dy = points[j][1] - points[k][1], points[j][2] - points[k][2]
						if dx * dx + dy * dy <= ECART_GRAPPE * ECART_GRAPPE then
							grappe[j] = g
							g[#g + 1] = points[j]
							file[#file + 1] = j
						end
					end
				end
			end
		end
	end
	return liste
end

-- enveloppe convexe (chaîne monotone d'Andrew)
local function Enveloppe(pts)
	table.sort(pts, function(p, q) if p[1] ~= q[1] then return p[1] < q[1] end return p[2] < q[2] end)
	local function croise(o, a, b) return (a[1] - o[1]) * (b[2] - o[2]) - (a[2] - o[2]) * (b[1] - o[1]) end
	local bas, haut = {}, {}
	for _, p in ipairs(pts) do
		while #bas >= 2 and croise(bas[#bas - 1], bas[#bas], p) <= 0 do table.remove(bas) end
		bas[#bas + 1] = p
	end
	for i = #pts, 1, -1 do
		local p = pts[i]
		while #haut >= 2 and croise(haut[#haut - 1], haut[#haut], p) <= 0 do table.remove(haut) end
		haut[#haut + 1] = p
	end
	table.remove(bas)
	table.remove(haut)
	for _, p in ipairs(haut) do bas[#bas + 1] = p end
	return bas
end

local function DessinerForme(points, largeur, hauteur, couleur, echelle)
	-- cercles autour de chaque apparition (en coordonnées du canevas), puis enveloppe
	local r = RAYON / 100 * largeur
	local pts = {}
	for _, p in ipairs(points) do
		local cx, cy = p[1] / 100 * largeur, p[2] / 100 * hauteur
		for k = 0, ETAPES_CERCLE - 1 do
			local ang = k / ETAPES_CERCLE * 2 * math.pi
			pts[#pts + 1] = { cx + r * math.cos(ang), cy + r * math.sin(ang) }
		end
	end
	local poly = Enveloppe(pts)
	if #poly < 3 then return end
	-- remplissage : bandes horizontales jointives
	local miny, maxy = math.huge, -math.huge
	for _, p in ipairs(poly) do miny = math.min(miny, p[2]); maxy = math.max(maxy, p[2]) end
	local pas = math.max(1.5, (maxy - miny) / 60)
	local y = miny + pas / 2
	while y < maxy do
		local x1, x2 = math.huge, -math.huge
		for i = 1, #poly do
			local a, b = poly[i], poly[i % #poly + 1]
			if (a[2] <= y and b[2] > y) or (b[2] <= y and a[2] > y) then
				local x = a[1] + (y - a[2]) / (b[2] - a[2]) * (b[1] - a[1])
				x1, x2 = math.min(x1, x), math.max(x2, x)
			end
		end
		if x2 > x1 then
			local t = Trait()
			t:SetColorTexture(couleur[1], couleur[2], couleur[3], 0.30)
			t:SetThickness(pas)
			t:SetStartPoint("TOPLEFT", support, x1, -y)
			t:SetEndPoint("TOPLEFT", support, x2, -y)
		end
		y = y + pas
	end
	-- bordure lumineuse
	local epaisseur = 2.5 / (echelle or 1)
	for i = 1, #poly do
		local a, b = poly[i], poly[i % #poly + 1]
		local t = Trait()
		t:SetColorTexture(math.min(1, couleur[1] + 0.25), math.min(1, couleur[2] + 0.25), math.min(1, couleur[3] + 0.1), 0.9)
		t:SetThickness(epaisseur)
		t:SetStartPoint("TOPLEFT", support, a[1], -a[2])
		t:SetEndPoint("TOPLEFT", support, b[1], -b[2])
	end
end

-- icônes (marchands) : une petite icône par emplacement, de taille fixe à l'écran
local icones = {}
local nIcones = 0
local function Icone(texture)
	nIcones = nIcones + 1
	local t = icones[nIcones]
	if not t then
		t = support:CreateTexture(nil, "OVERLAY", nil, 7)
		icones[nIcones] = t
	end
	t:SetTexture(texture)
	t:Show()
	return t
end

local function MajZones(canevas, carte, largeur, hauteur, echelle)
	if not support then
		support = CreateFrame("Frame", nil, canevas)
		support:SetAllPoints(canevas)
	end
	support:SetParent(canevas)
	support:SetAllPoints(canevas)
	-- au premier plan : au-dessus des icônes de la carte (quêtes, PNJ, autres addons), qui ont des
	-- niveaux élevés ; la carte reste cliquable (le cadre ne capte pas la souris)
	support:SetFrameStrata(canevas:GetFrameStrata())
	support:SetFrameLevel(math.min(9000, canevas:GetFrameLevel() + 2500))
	if support.EnableMouse then support:EnableMouse(false) end
	local montre, surCarte = false, false
	if zonesAffichees then
		for _, g in ipairs(zonesAffichees.groupes) do
			if g.carte == carte then
				surCarte = true
				if #(g.points or {}) > 0 then montre = true end
			end
		end
	end
	if not support.CreateLine then montre = false end -- (client sans traits : rien à dessiner)
	local cle = montre and (tostring(zonesAffichees) .. ":" .. carte .. ":" .. math.floor(largeur) .. ":" .. math.floor((echelle or 1) * 4)) or nil
	if cle ~= cleDessin then
		cleDessin = cle
		for i = 1, nTraits do traits[i]:Hide() end
		nTraits = 0
		for i = 1, nIcones do icones[i]:Hide() end
		nIcones = 0
		if montre then
			for _, g in ipairs(zonesAffichees.groupes) do
				if g.carte == carte and g.icone then
					-- marchands : une icône par emplacement
					local d = 18 / (echelle or 1)
					for _, p in ipairs(g.points or {}) do
						local t = Icone(g.icone)
						t:SetSize(d, d)
						t:ClearAllPoints()
						t:SetPoint("CENTER", support, "TOPLEFT", p[1] / 100 * largeur, -p[2] / 100 * hauteur)
					end
				elseif g.carte == carte then
					for _, grappe in ipairs(Grappes(g.points or {})) do
						DessinerForme(grappe, largeur, hauteur, g.couleur or { 0.2, 0.5, 1 }, echelle)
					end
				end
			end
		end
	end
	support:SetShown(montre)
	-- bandeau en haut de la carte : ce qui est affiché
	if zonesAffichees and WorldMapFrame then
		if not bandeau then
			bandeau = CreateFrame("Frame", nil, WorldMapFrame, "BackdropTemplate")
			bandeau:SetFrameStrata("HIGH")
			bandeau:SetHeight(26)
			if bandeau.SetBackdrop then
				bandeau:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
					insets = { left = 3, right = 3, top = 3, bottom = 3 } })
				bandeau:SetBackdropColor(0, 0, 0, 0.8)
			end
			bandeau.texte = bandeau:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			bandeau.texte:SetPoint("CENTER", bandeau, "CENTER", -8, 0)
			local x = CreateFrame("Button", nil, bandeau, "UIPanelCloseButton")
			x:SetSize(22, 22)
			x:SetPoint("RIGHT", bandeau, "RIGHT", 0, 0)
			x:SetScript("OnClick", function() zonesAffichees = nil; bandeau:Hide(); if MajCarte then MajCarte() end end)
		end
		local defile = WorldMapFrame.ScrollContainer or WorldMapFrame
		bandeau:ClearAllPoints()
		bandeau:SetPoint("TOP", defile, "TOP", 0, -6)
		bandeau.texte:SetText(zonesAffichees.titre .. (montre and "" or surCarte and "  |cff999999(positions inconnues : la zone seulement)|r"
			or "  |cff999999(pas sur cette carte)|r"))
		bandeau:SetWidth(bandeau.texte:GetStringWidth() + 50)
		bandeau:Show()
	elseif bandeau then
		bandeau:Hide()
	end
end

ns.AfficherSurCarte = function(titre, groupes)
	if not groupes or #groupes == 0 then return end
	zonesAffichees = { titre = titre, groupes = groupes }
	local carte = groupes[1].carte
	if OpenWorldMap then pcall(OpenWorldMap, carte)
	elseif WorldMapFrame then
		if not WorldMapFrame:IsShown() and ToggleWorldMap then pcall(ToggleWorldMap) end
		if WorldMapFrame.SetMapID then pcall(WorldMapFrame.SetMapID, WorldMapFrame, carte) end
	end
	if WorldMapFrame and not WorldMapFrame.guildupZones then
		WorldMapFrame.guildupZones = true
		WorldMapFrame:HookScript("OnHide", function()
			zonesAffichees = nil
			if bandeau then bandeau:Hide() end
		end)
	end
	if MajCarte then MajCarte() end
end

MajCarte = function()
	if not WorldMapFrame or not WorldMapFrame:IsShown() or not WorldMapFrame.GetCanvas then return end
	local canevas = WorldMapFrame:GetCanvas()
	local carte = WorldMapFrame.GetMapID and WorldMapFrame:GetMapID()
	if not canevas or not carte then return end
	local largeur, hauteur = canevas:GetSize()
	local echelle = 1
	local defile = WorldMapFrame.ScrollContainer
	if defile and defile.GetCanvasScale then
		local ok, s = pcall(defile.GetCanvasScale, defile)
		if ok and s and s > 0 then echelle = s end
	end

	local maintenant, n = GetTime(), 0
	for cle, p in pairs(positions) do
		if maintenant - p.vu > DUREE_VIE then
			positions[cle] = nil
		elseif not p.instance then
			local x, y = PositionSurCarte(p, carte)
			if x then
				n = n + 1
				local e = epingles[n]
				if not e then
					e = CreerEpingle(canevas)
					epingles[n] = e
				end
				e.ancre:SetParent(canevas)
				e.ancre:SetFrameLevel(canevas:GetFrameLevel() + 50)
				e.ancre:ClearAllPoints()
				e.ancre:SetPoint("CENTER", canevas, "TOPLEFT", x * largeur, -y * hauteur)
				e:SetScale(1 / echelle)
				e:SetFrameLevel(canevas:GetFrameLevel() + 51)
				e.point:SetVertexColor(CouleurClasse(p.classe))
				e.p, e.cle = p, cle
				e.ancre:Show()
				e:Show()
			end
		end
	end
	for i = n + 1, #epingles do epingles[i].ancre:Hide() end
	MajRepere(canevas, carte, largeur, hauteur, echelle)
	pcall(MajZones, canevas, carte, largeur, hauteur, echelle)
end

-- suivi de la carte : rafraîchi régulièrement tant qu'elle est ouverte (zoom, changement de carte)
local suivi
local function InstallerSuivi()
	if suivi or not WorldMapFrame then return end
	suivi = CreateFrame("Frame", nil, WorldMapFrame)
	local attente = 0
	suivi:SetScript("OnUpdate", function(_, ecoule)
		attente = attente + ecoule
		if attente >= 0.2 then
			attente = 0
			MajCarte()
		end
	end)
end

-- Pour /gup diag
ns.DiagCarte = function(L)
	local n, enInstance = 0, 0
	for _, p in pairs(positions) do
		n = n + 1
		if p.instance then enInstance = enInstance + 1 end
	end
	L(("carte de la guilde : partage %s, %d membre(s) reçu(s) dont %d en instance, carte du monde %s"):format(
		Partage() and "activé" or "coupé", n, enInstance, tostring(WorldMapFrame ~= nil)))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

do
	local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
	if inscription then pcall(inscription, PREFIXE) end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:RegisterEvent("ADDON_LOADED")
local premiereEntree = true
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "CHAT_MSG_ADDON" then
		Recevoir(a1, a2, a3, a4)
	elseif event == "ADDON_LOADED" then
		if a1 == "Blizzard_WorldMap" then InstallerSuivi() end
	elseif event == "PLAYER_ENTERING_WORLD" then
		InstallerSuivi()
		Emettre(true) -- changement de zone / d'instance
		if premiereEntree then
			premiereEntree = false
			C_Timer.NewTicker(INTERVALLE, function() Emettre(false) end)
		end
	end
end)
