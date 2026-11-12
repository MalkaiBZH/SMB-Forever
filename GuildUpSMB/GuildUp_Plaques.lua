-- GuildUpSMB : bannières derrière le nom et la barre de vie des membres de la guilde (barres de nom et
-- cadre de cible), couleurs par rôle, mise en page des barres de nom, réglages du jeu (CVars) imposés.

local NOM_ADDON, ns = ...
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\" -- le dossier de l'addon, quel que soit son nom

-- GuildUpDB (réglages) : la table est chargée par GuildUp.lua (ADDON_LOADED) ; ce mandataire y donne
-- accès sous le même nom « db » (nil avant le chargement)
local db = setmetatable({}, {
	__index = function(_, k) local t = ns.DB(); return t and t[k] end,
	__newindex = function(_, k, v) local t = ns.DB(); if t then t[k] = v end end,
})
-- (fichiers chargés avant celui-ci)
local Message, NomComplet, EstDeMaGuilde, Etat, LireCVar, LireCVarJeu = ns.Coeur.Message, ns.Coeur.NomComplet, ns.Coeur.EstDeMaGuilde, ns.Coeur.Etat, ns.Coeur.LireCVar, ns.Coeur.LireCVarJeu
-- Couleur des barres de vie, version vive de la couleur de chaque bannière
local COULEURS = {
	tank       = { 0.20, 0.55, 1.00 }, -- bleu
	heal       = { 0.25, 0.85, 0.30 }, -- vert
	dps        = { 0.90, 0.15, 0.15 }, -- rouge
	horscombat = { 0.85, 0.68, 0.25 }, -- doré (bannière neutre : mascotte dorée)
}

-- Deux modèles d'image : V2 (ornée) et _min (sobre, utilisée en groupe ou en raid)
local MODELES = {
	V2 = {
		suffixe = "_V2", V_HAUT = 52, V_BAS = 188, INT_HAUT = 100, INT_BAS = 155, INT_GAUCHE = 160, INT_DROITE = 482,
		BORD_DORE_HAUT = 89, BORD_DORE_BAS = 165,
		MORCEAUX = { g = { 0, 176 }, a = { 176, 218 }, o = { 218, 334 }, b = { 334, 426 }, d = { 426, 504 } },
	},
	-- _min : pas d'ornement central, le morceau « o » est une tranche unie de la barre
	min = {
		suffixe = "_min", V_HAUT = 52, V_BAS = 188, INT_HAUT = 101, INT_BAS = 154, INT_GAUCHE = 122, INT_DROITE = 478,
		BORD_DORE_HAUT = 99, BORD_DORE_BAS = 157,
		MORCEAUX = { g = { 0, 140 }, a = { 140, 300 }, o = { 300, 310 }, b = { 310, 450 }, d = { 450, 504 } },
	},
}

-- _min pour les membres de mon groupe ou de mon raid (et moi-même quand je suis groupé)
local function ModeleVoulu(unit)
	if db and db.test and db.testGroupe then return MODELES.min end -- debug : aperçu des bannières de groupe
	if unit and UnitExists(unit) and (UnitInParty(unit) or UnitInRaid(unit))
		and ((IsInGroup and IsInGroup()) or (IsInRaid and IsInRaid())) then
		return MODELES.min
	end
	return MODELES.V2
end

--------------------------------------------------------------------------------
-- Médaillons : portrait du joueur (race, classe, sexe) à la place de la mascotte de la bannière
-- Fichiers : media/portraits/<race>-<classe>-<sexe>.tga (256 x 256, rond, fond transparent).
-- Sans portrait pour cette combinaison (Horde, classe absente…) : la mascotte reste.
--------------------------------------------------------------------------------

-- portraits disponibles : [race] = { classes } (chacune en homme et en femme)
local PORTRAITS_DISPONIBLES = {
	["humain"] = { "chasseur", "demoniste", "guerrier", "mage", "paladin", "pretre", "voleur" },
	["nain"] = { "chaman", "chasseur", "guerrier", "paladin", "pretre", "voleur" },
	["elfe-de-la-nuit"] = { "chasseur", "druide", "guerrier", "pretre", "voleur" },
	["gnome"] = { "demoniste", "guerrier", "mage", "pretre", "voleur" },
	["skyborne"] = { "chasseur", "druide", "guerrier", "mage", "voleur" },
}
local PORTRAITS = {}
for race, classes in pairs(PORTRAITS_DISPONIBLES) do
	for _, classe in ipairs(classes) do
		PORTRAITS[race .. "-" .. classe .. "-homme"] = true
		PORTRAITS[race .. "-" .. classe .. "-femme"] = true
	end
end

-- race du jeu (nom de fichier anglais de UnitRace) -> nom du portrait
local RACES = { Human = "humain", Dwarf = "nain", NightElf = "elfe-de-la-nuit", Gnome = "gnome" }
-- classe du jeu (UnitClass) -> nom du portrait
local CLASSES = {
	WARRIOR = "guerrier", PALADIN = "paladin", HUNTER = "chasseur", ROGUE = "voleur", PRIEST = "pretre",
	SHAMAN = "chaman", MAGE = "mage", WARLOCK = "demoniste", DRUID = "druide",
}

-- race d'une unité ; la race propre à Forever (skyborne du Haut Ordre) est reconnue à son nom,
-- quel que soit l'identifiant que lui donne le client
local function RaceUnite(unit)
	local ok, nom, fichier = pcall(UnitRace, unit)
	if not ok then return nil end
	local r = fichier and RACES[fichier]
	if r then return r end
	local texte = ((fichier or "") .. " " .. (nom or "")):lower()
	if texte:find("sky", 1, true) then return "skyborne" end
	-- noms localisés (au cas où le client ne donnerait pas l'identifiant anglais)
	local simple = ns.Simplifier and ns.Simplifier(nom or "") or (nom or ""):lower()
	if simple:find("humain", 1, true) then return "humain" end
	if simple:find("nain", 1, true) then return "nain" end
	if simple:find("elfe de la nuit", 1, true) then return "elfe-de-la-nuit" end
	if simple:find("gnome", 1, true) then return "gnome" end
end

-- nom du portrait d'une unité (« nain-chaman-femme »), ou nil si le joueur n'en a pas
local cachePortraits = {} -- [nom normalisé du joueur] = portrait (la race, la classe et le sexe ne changent pas)
local function PortraitUnite(unit)
	if not (unit and UnitExists(unit) and UnitIsPlayer(unit)) then return nil end
	local cle = NomComplet(unit)
	if cle and cachePortraits[cle] ~= nil then return cachePortraits[cle] or nil end
	local race = RaceUnite(unit)
	local _, fichierClasse = UnitClass(unit)
	local classe = fichierClasse and CLASSES[fichierClasse]
	local sexe = UnitSex and UnitSex(unit)
	sexe = (sexe == 2 and "homme") or (sexe == 3 and "femme") or nil
	local nom = race and classe and sexe and (race .. "-" .. classe .. "-" .. sexe) or nil
	if nom and not PORTRAITS[nom] then nom = nil end
	-- (inconnu si le jeu n'a pas encore les informations : on ne garde pas, on redemandera)
	if cle and race and classe and sexe then cachePortraits[cle] = nom or false end
	return nom
end

-- chemin du médaillon à afficher pour une unité, ou nil (réglage coupé, pas de portrait)
local function MedaillonUnite(unit)
	if db.medaillons == false then return nil end
	local nom = PortraitUnite(unit)
	return nom and (MEDIA .. "portraits\\" .. nom .. ".tga") or nil
end
ns.PortraitUnite = PortraitUnite

-- image de la bannière d'un état (tank, heal, dps, horscombat) dans un modèle
local function ImageBanniere(etat, m) return MEDIA .. "M_DC_Banner_" .. etat .. m.suffixe .. ".tga" end


--------------------------------------------------------------------------------
-- Le fond du nom : bannière V2 en 5 morceaux, ou dégradé
--------------------------------------------------------------------------------
-- Image 512x256, affichée réduite en jeu (meilleure qualité). Découpage horizontal :
--   g  x   0-176 : mascotte + bol + début de la barre      (fixe)
--   a  x 176-218 : barre unie                               (étirée)
--   o  x 218-334 : ornement central, haut et bas            (fixe, centré sur la barre de vie)
--   b  x 334-426 : barre unie                               (étirée)
--   d  x 426-504 : embout droit orné                         (fixe)
-- Seules les lignes 52-188 sont utilisées. L'intérieur de la barre (là où vont le nom et la
-- barre de vie) va des lignes 100 à 155 et de x=160 (sortie du bol) à x=482 (avant l'embout).
-- Le bord doré du haut de la barre est à la ligne 89.

local TEX_L, TEX_H = 512, 256

-- (le modèle d'une bannière, V2 ou _min, est choisi par ModeleVoulu(unit) et passé aux fonctions)
local ORDRE = { "g", "a", "o", "b", "d" }

local function CreerFond(parent, couche, sousCouche)
	local f = { parent = parent, couche = couche, sousCouche = sousCouche }
	for _, cle in ipairs(ORDRE) do
		f[cle] = parent:CreateTexture(nil, couche, nil, sousCouche)
	end
	return f
end

local function Masquer(f)
	for _, cle in ipairs(ORDRE) do f[cle]:Hide() end
	if f.medaillon then f.medaillon:Hide() end
	if f.lueur then for _, t in ipairs(f.lueur) do t:Hide() end end
end

-- Dégradé horizontal d'une couleur, de l'opacité a1 à a2 (selon ce que le client permet)
local function DegradeCouleur(tex, r, g, b, a1, a2)
	tex:SetColorTexture(1, 1, 1, 1)
	if tex.SetGradient and CreateColor then
		tex:SetGradient("HORIZONTAL", CreateColor(r, g, b, a1), CreateColor(r, g, b, a2))
	elseif tex.SetGradientAlpha then
		tex:SetGradientAlpha("HORIZONTAL", r, g, b, a1, r, g, b, a2)
	else
		tex:SetColorTexture(r, g, b, (a1 + a2) / 2)
	end
end
local function Degrade(tex, a1, a2) DegradeCouleur(tex, db.r, db.g, db.b, a1, a2) end

-- Pose la bannière pour que son intérieur bleu couvre une zone définie par rapport aux bords
-- d'une région : gauche = bord gauche + dxG, droite = bord droit + dxD, haut = bord haut + dyH,
-- bas = bord bas + dyB. Uniquement des points d'ancrage (aucune mesure) : utilisable sur les
-- barres de nom restreintes. hauteurInt = hauteur de cette zone (fixe l'échelle de l'image).
-- medaillon (facultatif) : portrait du joueur à la place de la mascotte (morceau gauche)
local function PoserBanniere(f, image, region, dxG, dxD, dyH, dyB, hauteurInt, m, medaillon)
	local k = hauteurInt / (m.INT_BAS - m.INT_HAUT)
	local yHaut = dyH + (m.INT_HAUT - m.V_HAUT) * k
	local yBas = dyB - (m.V_BAS - m.INT_BAS) * k
	for _, cle in ipairs(ORDRE) do
		local t, c = f[cle], m.MORCEAUX[cle]
		t:ClearAllPoints()
		t:SetTexture(image)
		t:SetVertexColor(1, 1, 1, 1)
		t:SetTexCoord(c[1] / TEX_L, c[2] / TEX_L, m.V_HAUT / TEX_H, m.V_BAS / TEX_H)
	end
	local g, a, o, b, d = f.g, f.a, f.o, f.b, f.d
	local function Largeur(cle) return (m.MORCEAUX[cle][2] - m.MORCEAUX[cle][1]) * k end

	-- morceau gauche : son bord droit est 16 px (image) après le début de l'intérieur
	local xG = dxG + (m.MORCEAUX.g[2] - m.INT_GAUCHE) * k
	g:SetPoint("TOPRIGHT", region, "TOPLEFT", xG, yHaut)
	g:SetPoint("BOTTOMRIGHT", region, "BOTTOMLEFT", xG, yBas)
	g:SetWidth(Largeur("g"))
	-- embout droit : son bord gauche est 56 px (image) avant la fin de l'intérieur
	local xD = dxD - (m.INT_DROITE - m.MORCEAUX.d[1]) * k
	d:SetPoint("TOPLEFT", region, "TOPRIGHT", xD, yHaut)
	d:SetPoint("BOTTOMLEFT", region, "BOTTOMRIGHT", xD, yBas)
	d:SetWidth(Largeur("d"))
	-- ornement central : centré sur l'intérieur, jamais étiré
	local xO = (dxG + dxD) / 2
	o:SetPoint("TOP", region, "TOP", xO, yHaut)
	o:SetPoint("BOTTOM", region, "BOTTOM", xO, yBas)
	o:SetWidth(Largeur("o"))
	-- parties unies : elles comblent l'espace restant de chaque côté de l'ornement
	b:SetPoint("TOPLEFT", o, "TOPRIGHT", 0, 0)
	b:SetPoint("BOTTOMRIGHT", d, "BOTTOMLEFT", 0, 0)
	for _, cle in ipairs(ORDRE) do f[cle]:Show() end

	if not medaillon then
		a:SetPoint("TOPLEFT", g, "TOPRIGHT", 0, 0)
		a:SetPoint("BOTTOMRIGHT", o, "BOTTOMLEFT", 0, 0)
		if f.medaillon then f.medaillon:Hide() end
		return
	end
	-- Médaillon : rond, de la hauteur de la bannière, collé à gauche de l'intérieur (il ne passe pas
	-- sous le nom ni la barre de vie). La bannière elle-même disparaît : il ne reste que le médaillon
	-- à côté du nom et de la barre de vie (plus léger à l'écran).
	local taille = (m.V_BAS - m.V_HAUT) * k
	local yCentre = (yHaut + yBas) / 2
	for _, cle in ipairs(ORDRE) do f[cle]:Hide() end
	if not f.medaillon then
		-- juste au-dessus de la bannière, dans le même cadre
		local couche, sous = f.couche or "BACKGROUND", (f.sousCouche or 0) + 1
		if sous > 7 then couche, sous = "BORDER", -8 end
		f.medaillon = f.parent:CreateTexture(nil, couche, nil, sous)
	end
	local t = f.medaillon
	t:ClearAllPoints()
	t:SetTexture(medaillon)
	t:SetSize(taille, taille)
	t:SetPoint("RIGHT", region, "LEFT", dxG, yCentre)
	t:Show()
end

-- Dégradé (style alternatif) : deux moitiés a / b, le reste caché
local function PoserDegrade(f, region, dxG, dxD, dyH, dyB, fortAuCentre)
	for _, cle in ipairs(ORDRE) do f[cle]:ClearAllPoints(); f[cle]:Hide() end
	if f.medaillon then f.medaillon:Hide() end
	local a, b = f.a, f.b
	a:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", dxG, dyB)
	a:SetPoint("TOPRIGHT", region, "TOP", 0, dyH)
	b:SetPoint("BOTTOMLEFT", region, "BOTTOM", 0, dyB)
	b:SetPoint("TOPRIGHT", region, "TOPRIGHT", dxD, dyH)
	a:SetTexCoord(0, 1, 0, 1); b:SetTexCoord(0, 1, 0, 1)
	if fortAuCentre then
		Degrade(a, 0, db.a); Degrade(b, db.a, 0)
	else
		Degrade(a, db.a * 0.55, db.a); Degrade(b, db.a, db.a * 0.55)
	end
	a:Show(); b:Show()
end

-- Cadre de cible (pas de restriction ici) :
-- mode "texte" : autour d'une FontString ; mode "zone" : remplit une région (fond de nom)
local function Afficher(f, unit, region, mode)
	local m = ModeleVoulu(unit)
	if mode == "texte" then
		if db.style == "degrade" then
			PoserDegrade(f, region, -14, 14, 3, -3, true)
		else
			PoserBanniere(f, ImageBanniere(Etat(unit), m), region, -4, 4, 2, -2, region:GetHeight() + 4, m, MedaillonUnite(unit))
		end
	else
		if db.style == "degrade" then
			PoserDegrade(f, region, 0, 0, 0, 0, false)
		else
			PoserBanniere(f, ImageBanniere(Etat(unit), m), region, 0, 0, 0, 0, region:GetHeight(), m, MedaillonUnite(unit))
		end
	end
end

--------------------------------------------------------------------------------
-- Barres de nom
--------------------------------------------------------------------------------
-- Ces régions sont « restreintes » : impossible de mesurer leur position ou la largeur
-- du texte (GetTop, GetStringWidth… sont refusés). On place donc la bannière
-- uniquement avec des points d'ancrage sur la barre de vie, et la hauteur du nom
-- est estimée à partir de la taille de la police.

-- Taille de la bannière : marge autour du nom + barre de vie (haut/bas, et gauche/droite).
-- Plus la marge du haut/bas est petite, plus toute la bannière est petite.
local MARGE_BANNIERE, MARGE_BANNIERE_X = 3, 6
-- Allongement à droite quand la case du niveau est affichée (elle est collée à droite de la
-- barre de vie : 5 d'écart + 28 de large chez Blizzard), pour qu'elle tienne dans l'intérieur bleu
local EXTENSION_NIVEAU = 34
-- Échelle de l'image (1 = l'intérieur bleu épouse exactement nom + barre de vie + marges).
-- En dessous de 1, toute l'image rapetisse et l'intérieur se resserre autour du contenu,
-- en restant centré verticalement.
local ECHELLE_BANNIERE = 0.9

-- Position verticale de l'intérieur bleu par rapport à la barre de vie :
-- haut (au-dessus du haut de la barre de vie), bas (sous le bas), et hauteur totale
local function GeometriePlaque(barre, tailleNom)
	local hVie = 10
	local ok, h = pcall(barre.GetHeight, barre)
	if ok and type(h) == "number" and h > 0 then hVie = h end
	local hauteur = tailleNom + 2 + hVie + 2 * MARGE_BANNIERE
	local reduction = (1 - ECHELLE_BANNIERE) * hauteur / 2
	local haut = tailleNom + 2 + MARGE_BANNIERE - reduction
	local bas = -MARGE_BANNIERE + reduction
	return haut, bas, hauteur * ECHELLE_BANNIERE
end

-- Barre d'incantation (réglages)
local ECART_INCANTATION = 0       -- vers le haut (+) ou le bas (-) par rapport au bord doré du bas
local DEBUT_INCANTATION = -3      -- début (gauche) : négatif = vers la gauche
local FIN_INCANTATION = 6         -- fin (droite) : positif = vers la droite
local HAUTEUR_INCANTATION = 10

-- Zone de la barre d'incantation : sous la bannière, collée au bord doré du bas, entre la
-- partie gauche décorée (fin du bol) et l'embout droit. Décalages par rapport à la barre de vie :
-- gauche (depuis son bord gauche), droite (depuis son bord droit), y (haut, depuis son bord bas).
local function ZoneIncantation(barre, tailleNom, niveauVisible, unit)
	local m = ModeleVoulu(unit)
	local _, bas, hauteur = GeometriePlaque(barre, tailleNom)
	local k = hauteur / (m.INT_BAS - m.INT_HAUT)
	local droite = MARGE_BANNIERE_X + (niveauVisible and EXTENSION_NIVEAU or 0)
	local gauche = -MARGE_BANNIERE_X + (m.MORCEAUX.g[2] - m.INT_GAUCHE) * k + DEBUT_INCANTATION
	local fin = droite - (m.INT_DROITE - m.MORCEAUX.d[1]) * k + FIN_INCANTATION
	local y = bas - (m.BORD_DORE_BAS - m.INT_BAS) * k + ECART_INCANTATION
	return gauche, fin, y
end

-- Lueur derrière la bannière du joueur ciblé : un rectangle doré qui part du bol et va jusqu'au
-- bout droit de la bannière, un peu plus haut et plus bas que la barre ; plein au milieu, avec
-- un court fondu (transparence) à gauche et à droite
local DEBORD_LUEUR = 6        -- dépassement au-dessus / au-dessous des bords dorés (pixels de l'image)
local DEBUT_LUEUR = 30        -- départ avant la sortie du bol (pixels de l'image)
local FONDU_LUEUR = 40        -- longueur des fondus gauche / droite (pixels à l'écran)
local COULEUR_LUEUR = { 1, 0.78, 0.2, 1 }

local function DegradeAlpha(tex, a1, a2)
	DegradeCouleur(tex, COULEUR_LUEUR[1], COULEUR_LUEUR[2], COULEUR_LUEUR[3], a1, a2)
end

local function CreerLueur(parent)
	local l = {}
	for i = 1, 3 do l[i] = parent:CreateTexture(nil, "BACKGROUND", nil, -8) end
	return l
end

local FIN_LUEUR_NIVEAU = 33   -- avec la case du niveau : la lueur s'arrête au bout de la case (5 d'écart + 28 de large)

local function LueurBanniere(f, unit, region, dxG, dxD, dyH, dyB, hauteur, niveauVisible, m)
	local l = f.lueur
	if not l then return end
	if not (db.lueur and UnitIsUnit(unit, "target")) then
		for _, t in ipairs(l) do t:Hide() end
		return
	end
	local k = hauteur / (m.INT_BAS - m.INT_HAUT)
	local xG = dxG + (m.INT_GAUCHE - DEBUT_LUEUR - m.INT_GAUCHE) * k
	-- fin à droite : avant la case du niveau si elle est affichée, sinon au bout de la bannière
	local xD = niveauVisible and FIN_LUEUR_NIVEAU or (dxD + (m.MORCEAUX.d[2] - m.INT_DROITE) * k)
	local yH = dyH - ((m.BORD_DORE_HAUT - DEBORD_LUEUR) - m.INT_HAUT) * k
	local yB = dyB - ((m.BORD_DORE_BAS + DEBORD_LUEUR) - m.INT_BAS) * k
	local gauche, milieu, droite = l[1], l[2], l[3]
	local a = COULEUR_LUEUR[4]
	gauche:ClearAllPoints()
	gauche:SetPoint("TOPLEFT", region, "TOPLEFT", xG, yH)
	gauche:SetPoint("BOTTOMLEFT", region, "BOTTOMLEFT", xG, yB)
	gauche:SetWidth(FONDU_LUEUR)
	DegradeAlpha(gauche, 0, a)
	droite:ClearAllPoints()
	droite:SetPoint("TOPRIGHT", region, "TOPRIGHT", xD, yH)
	droite:SetPoint("BOTTOMRIGHT", region, "BOTTOMRIGHT", xD, yB)
	droite:SetWidth(FONDU_LUEUR)
	DegradeAlpha(droite, a, 0)
	milieu:ClearAllPoints()
	milieu:SetPoint("TOPLEFT", gauche, "TOPRIGHT", 0, 0)
	milieu:SetPoint("BOTTOMRIGHT", droite, "BOTTOMLEFT", 0, 0)
	DegradeAlpha(milieu, a, a)
	for _, t in ipairs(l) do t:Show() end
end

local function AfficherPlaque(f, unit, barre, tailleNom, niveauVisible)
	local m = ModeleVoulu(unit)
	local margeX = MARGE_BANNIERE_X
	local haut, bas, hauteur = GeometriePlaque(barre, tailleNom)
	local droite = margeX + (niveauVisible and EXTENSION_NIVEAU or 0)
	if db.style == "degrade" then
		PoserDegrade(f, barre, -margeX - 20, droite + 20, haut, bas, true)
		return
	end
	PoserBanniere(f, ImageBanniere(Etat(unit), m), barre, -margeX, droite, haut, bas, hauteur, m, MedaillonUnite(unit))
	LueurBanniere(f, unit, barre, -margeX, droite, haut, bas, hauteur, niveauVisible, m)
end

local fondsPlaques = {} -- [UnitFrame de la barre] = fond
local modifiees = {}    -- barres de vie dont on a changé la couleur / la bordure

-- Les barres de nom sont recyclées d'un joueur à l'autre : on remet l'état Blizzard
-- (healthBar.r/g/b = dernière couleur voulue par Blizzard, jamais touchée par nous).
-- Toutes les bordures de la barre de vie : clés contenant "border" dans la barre
-- et dans son conteneur (le nom exact change selon les versions du client).
local function Bordures(uf)
	local liste = {}
	for _, obj in ipairs({ uf.healthBar, uf.HealthBarsContainer }) do
		if type(obj) == "table" then
			for k, v in pairs(obj) do
				if type(k) == "string" and k:lower():find("border") and type(v) == "table"
					and v ~= uf.healthBar and v.SetShown then
					liste[#liste + 1] = v
				end
			end
		end
	end
	return liste
end

-- Sur ce client, le contour de la barre de vie fait partie de son fond (bgTexture,
-- atlas "UI-HUD-CoolDownManager-Bar-BG"), qui déborde de la barre. On le rend invisible
-- et on pose notre propre fond sombre, exactement à la taille de la barre.
local FOND_UNI = { 0, 0, 0, 0.55 }
local fondsPerso = {} -- [healthBar] = notre texture de fond

local function FondSansContour(hb, sansContour)
	local bg = hb.bgTexture
	if not bg then return end
	local perso = fondsPerso[hb]
	if sansContour then
		if not perso then
			perso = hb:CreateTexture(nil, "BACKGROUND", nil, -8)
			perso:SetAllPoints(hb)
			fondsPerso[hb] = perso
		end
		perso:SetColorTexture(FOND_UNI[1], FOND_UNI[2], FOND_UNI[3], FOND_UNI[4])
		perso:Show()
		bg:SetAlpha(0)
	else
		bg:SetAlpha(1)
		if perso then perso:Hide() end
	end
end

-- Icônes d'auras : les listes BuffListFrame (améliorations) et DebuffListFrame
-- (affaiblissements) d'AurasFrame sont accrochées sous la zone de la barre d'incantation
-- (pour ne jamais la chevaucher), alignées à gauche sur la barre de vie, les affaiblissements
-- sous les améliorations. Membres de la guilde seulement.
local ECART_AURAS = 3 -- espace entre le bas de la zone d'incantation et les icônes

local function DeplacerAuras(uf)
	if not db or not db.actif or not db.aurasSous then return end
	local af, hb, nom = uf.AurasFrame, uf.healthBar, uf.name
	if not af or not hb or not nom then return end
	local _, tailleNom = nom:GetFont()
	local _, _, yIncantation = ZoneIncantation(hb, tailleNom or 10, false, uf.unit)
	local y = yIncantation - HAUTEUR_INCANTATION - ECART_AURAS
	local buffs, debuffs = af.BuffListFrame, af.DebuffListFrame
	if buffs then
		buffs:ClearAllPoints()
		buffs:SetPoint("TOPLEFT", hb, "BOTTOMLEFT", 0, y)
	end
	if debuffs then
		debuffs:ClearAllPoints()
		if buffs then
			debuffs:SetPoint("TOPLEFT", buffs, "BOTTOMLEFT", 0, -2)
		else
			debuffs:SetPoint("TOPLEFT", hb, "BOTTOMLEFT", 0, y)
		end
	end
end

-- Nom aligné à gauche, juste au-dessus du bord gauche de la barre de vie (toutes les
-- barres de nom ; /reload pour revenir au nom centré de Blizzard).
local ECART_NOM = 2

local function PlacerNom(uf)
	if not db or not db.actif or not db.nomGauche then return end
	local hb, nom = uf.healthBar, uf.name
	if not hb or not nom then return end
	nom:ClearAllPoints()
	nom:SetPoint("BOTTOMLEFT", hb, "TOPLEFT", 0, ECART_NOM)
	nom:SetJustifyH("LEFT")
end

-- Barre d'incantation : sous la bannière, collée au bord doré du bas, entre la fin du bol et
-- l'embout droit (cf. ZoneIncantation). Membres de la guilde seulement.
-- ATTENTION : ne jamais toucher au conteneur CastBarsContainer — la barre de vie
-- (HealthBarsContainer) est accrochée à lui ; le détacher fait disparaître toute la barre de nom.
-- On ne déplace que la barre elle-même (CastBarsContainer.castBar).

local function NiveauVisible(uf)
	local n = uf.PlayerLevelDiffFrame
	return n and n:IsShown() or false
end

local incantationRefusee = false -- le jeu a refusé de déplacer la barre : coupé pour la session

local function PlacerIncantation(uf)
	if not db or not db.actif or not db.incantationHaut or incantationRefusee then return end
	local cb, hb, nom = uf.CastBarsContainer, uf.healthBar, uf.name
	local barre = cb and cb.castBar
	if not barre or not hb or not nom then return end
	local _, tailleNom = nom:GetFont()
	local gauche, fin, y = ZoneIncantation(hb, tailleNom or 10, NiveauVisible(uf), uf.unit)
	barre:ClearAllPoints()
	local ok, err = pcall(function()
		barre:SetPoint("TOPLEFT", hb, "BOTTOMLEFT", gauche, y)
		barre:SetPoint("TOPRIGHT", hb, "BOTTOMRIGHT", fin, y)
		barre:SetHeight(HAUTEUR_INCANTATION)
	end)
	if not ok then
		-- refusé par le jeu : on remet la barre dans son conteneur et on arrête pour cette session
		-- (le réglage est gardé : un /reload réessaie)
		barre:ClearAllPoints()
		barre:SetAllPoints(cb)
		incantationRefusee = true
		Message("le jeu refuse de déplacer la barre d'incantation : elle reste à sa place pour cette session.")
		error(err, 0)
	end
end

-- Debug : fausse barre d'incantation orange, exactement là où la vraie sera placée
local apercusIncantation = {} -- [UnitFrame] = { t = texture, txt = texte }

local function ApercuIncantation(uf)
	local a = apercusIncantation[uf]
	if not (db and db.actif and db.debugIncantation) then
		if a then a.t:Hide(); a.txt:Hide() end
		return
	end
	local hb, nom = uf.healthBar, uf.name
	if not hb or not nom then return end
	if not a then
		a = { t = uf:CreateTexture(nil, "OVERLAY", nil, 7), txt = uf:CreateFontString(nil, "OVERLAY", "SystemFont_Shadow_Small") }
		apercusIncantation[uf] = a
	end
	local _, tailleNom = nom:GetFont()
	local gauche, fin, y = ZoneIncantation(hb, tailleNom or 10, NiveauVisible(uf), uf.unit)
	a.t:ClearAllPoints()
	a.t:SetPoint("TOPLEFT", hb, "BOTTOMLEFT", gauche, y)
	a.t:SetPoint("TOPRIGHT", hb, "BOTTOMRIGHT", fin, y)
	a.t:SetHeight(HAUTEUR_INCANTATION)
	a.t:SetColorTexture(1, 0.6, 0.1, 0.85)
	a.txt:ClearAllPoints()
	a.txt:SetPoint("CENTER", a.t, "CENTER", 0, 0)
	a.txt:SetText("Aperçu incantation")
	a.t:Show(); a.txt:Show()
end

local function DeplacerAurasUnite(unit)
	local plaque = C_NamePlate.GetNamePlateForUnit(unit)
	if plaque and not (plaque.IsForbidden and plaque:IsForbidden()) and plaque.UnitFrame then
		pcall(DeplacerAuras, plaque.UnitFrame)
	end
end

local function LueursBlizzard(uf)
	local liste = Bordures(uf)
	local niv = uf.PlayerLevelDiffFrame
	if niv and niv.selectedBorder then liste[#liste + 1] = niv.selectedBorder end
	return liste
end

local function CacherLueursBlizzard(uf)
	for _, b in ipairs(LueursBlizzard(uf)) do b:Hide() end
	-- Blizzard les réaffiche en recalculant la sélection : on repasse derrière lui
	for _, obj in ipairs({ uf.healthBar, uf.PlayerLevelDiffFrame }) do
		if obj and not obj.crochetLueurGuildUpSMB and type(obj.UpdateSelectionBorder) == "function" then
			obj.crochetLueurGuildUpSMB = true
			hooksecurefunc(obj, "UpdateSelectionBorder", function(self)
				if modifiees[uf] and self.selectedBorder then self.selectedBorder:Hide() end
			end)
		end
	end
end

local function RestaurerBarreVie(uf)
	if not modifiees[uf] then return end
	modifiees[uf] = nil
	local hb = uf.healthBar
	if hb.r then hb:SetStatusBarColor(hb.r, hb.g, hb.b) end
	-- la lueur jaune (selectedBorder) ne doit être visible que sur la cible, comme chez Blizzard
	local estCible = uf.unit and UnitIsUnit(uf.unit, "target") or false
	for _, b in ipairs(LueursBlizzard(uf)) do b:SetShown(estCible) end
	FondSansContour(hb, false)
end

local function ColorerBarreVie(uf, unit)
	local hb = uf.healthBar
	if not hb then return end
	if db.couleurs then
		local c = COULEURS[Etat(unit)]
		hb:SetStatusBarColor(c[1], c[2], c[3])
	elseif hb.r then
		hb:SetStatusBarColor(hb.r, hb.g, hb.b)
	end
	-- lueur jaune de sélection (selectedBorder) : visible sur la cible (Blizzard ne l'affiche pas
	-- toujours sur les barres alliées), ou coupée si l'option est décochée
	if not db.lueur then
		for _, b in ipairs(Bordures(uf)) do b:Hide() end
	end
	-- notre propre lueur dorée autour de la barre de vie de la cible : celle de Blizzard
	-- disparaît une demi-seconde après le ciblage sur les barres alliées
	-- la cible est signalée par la lueur derrière la bannière : on cache celles de Blizzard
	-- (autour de la barre de vie et de la case du niveau)
	CacherLueursBlizzard(uf)
	-- le contour sombre (dans le fond de la barre) est toujours retiré
	FondSansContour(hb, true)
	modifiees[uf] = true
end

-- Mise en page GuildUpSMB (auras sous la barre, niveau, nom à gauche, incantation en haut) :
-- seulement sur les barres de nom des membres de la guilde. Quand une barre de nom passe à
-- un autre joueur, on demande à Blizzard de refaire sa propre mise en page (UpdateAnchors,
-- ApplyStyleAndAnchoring) : on ne peut pas lire les positions d'origine nous-mêmes.
local misesEnPage = {}  -- [UnitFrame] = true si notre mise en page est appliquée
local surveillees = {}  -- [UnitFrame] = true si les fonctions Blizzard sont déjà surveillées

-- Remet les éléments déplacés aux positions de Blizzard, recopiées du code source du client
-- Forever (Blizzard_NamePlates : UpdateAnchors, ApplyStyleAndAnchoring, XML des listes d'auras).
-- On ne peut pas appeler ces fonctions nous-mêmes : elles mesurent des régions restreintes et
-- sont bloquées quand c'est un addon qui les lance.
local function AncragesBlizzard(uf)
	local so = NamePlateSetupOptions
	if type(so) ~= "table" then return end
	local hbc, hb, nom = uf.HealthBarsContainer, uf.healthBar, uf.name
	local styles = (NamePlateConstants and NamePlateConstants.NAME_ANCHOR_STYLES) or {}
	local style = so.unitNameAnchorStyle
	local seulNom = false
	if type(uf.IsShowOnlyName) == "function" then
		local ok, v = pcall(uf.IsShowOnlyName, uf)
		seulNom = ok and v and true or false
	end

	-- Nom
	pcall(function()
		local texteVie = hb.Text
		nom:ClearAllPoints()
		if seulNom then
			nom:SetJustifyH("CENTER")
			if style == styles.InsideHealthBar then
				nom:SetPoint("LEFT", hbc, "LEFT", 4, 0)
				nom:SetPoint("RIGHT", hbc, "RIGHT", -4, 0)
			else
				nom:SetPoint("BOTTOMLEFT", hbc, "TOPLEFT", 4, 2)
				nom:SetPoint("BOTTOMRIGHT", hbc, "TOPRIGHT", -4, 2)
			end
		elseif style == styles.InsideHealthBar then
			nom:SetJustifyH("LEFT")
			nom:SetPoint("LEFT", hbc, "LEFT", 4, 0)
			nom:SetPoint("RIGHT", texteVie, "LEFT", -2, 0)
		elseif style == styles.CenteredAboveHealthBar then
			nom:SetJustifyH("CENTER")
			nom:SetPoint("BOTTOM", hbc, "TOP", 0, so.healthBarToNameAboveSpacing or 0)
		else -- AboveHealthBar
			nom:SetJustifyH(so.nameJustificationWhenAboveHealthBar or "LEFT")
			nom:SetPoint("BOTTOMLEFT", hbc, "TOPLEFT", 0, so.healthBarToNameAboveSpacing or 0)
			if so.healthTextInsideBarWhenNameAboveHealthBar then
				nom:SetPoint("RIGHT", hbc, "RIGHT", 0, 0)
			else
				nom:SetPoint("RIGHT", texteVie, "LEFT", -2, 0)
			end
		end
	end)

	-- Listes d'auras
	pcall(function()
		local af = uf.AurasFrame
		local lire = LireCVarJeu
		local espacement = tonumber(lire("nameplateDebuffPadding")) or 0
		af.DebuffListFrame:ClearAllPoints()
		af.DebuffListFrame:SetPoint("LEFT", hbc, "LEFT", 0, 0)
		if style == styles.InsideHealthBar then
			af.DebuffListFrame:SetPoint("BOTTOM", hb, "TOP", 0, espacement)
		else
			af.DebuffListFrame:SetPoint("BOTTOM", nom, "TOP", 0, espacement)
		end
		af.BuffListFrame:ClearAllPoints()
		af.BuffListFrame:SetPoint("RIGHT", uf.ClassificationFrame, "LEFT", -5, 0)
	end)

	-- Barre d'incantation
	pcall(function()
		local cb = uf.CastBarsContainer.castBar
		local parent = cb:GetParent()
		cb:ClearAllPoints()
		if so.useClassicCastBar then
			local h, v = so.horizontalScale or 1, so.verticalScale or 1
			cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 20.75 * h, 0.5 * v)
			cb:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -3.5 * h, 0.5 * v)
		elseif so.spellNameInsideCastBar == true then
			cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
			cb:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
		else
			cb:SetPoint("BOTTOM", cb.Icon, "TOP", 0, 0)
			cb:SetPoint("LEFT", parent, "BOTTOMLEFT", 0, 0)
			cb:SetPoint("RIGHT", parent, "BOTTOMRIGHT", 0, 0)
		end
		if so.castBarHeight then cb:SetHeight(so.castBarHeight) end
	end)
end

local function AppliquerMiseEnPage(uf)
	misesEnPage[uf] = true
	pcall(DeplacerAuras, uf)
	pcall(PlacerNom, uf)
	pcall(PlacerIncantation, uf)
	pcall(ApercuIncantation, uf)
	if not surveillees[uf] then
		surveillees[uf] = true
		-- Blizzard refait sa mise en page : si c'est un membre de la guilde, on repasse derrière
		if type(uf.UpdateAnchors) == "function" then
			hooksecurefunc(uf, "UpdateAnchors", function(self)
				if misesEnPage[self] then AppliquerMiseEnPage(self) end
			end)
		end
		local cb = uf.CastBarsContainer and uf.CastBarsContainer.castBar
		if cb and type(cb.ApplyStyleAndAnchoring) == "function" then
			hooksecurefunc(cb, "ApplyStyleAndAnchoring", function()
				if misesEnPage[uf] then pcall(PlacerIncantation, uf) end
			end)
		end
	end
end

local function RestaurerMiseEnPage(uf)
	pcall(ApercuIncantation, uf) -- masque l'aperçu
	if not misesEnPage[uf] then return end
	misesEnPage[uf] = nil
	AncragesBlizzard(uf)
end

-- Joueurs alliés hors de la guilde et hors de mon groupe : juste le nom et la guilde
-- (barre de vie masquée), comme les noms flottants classiques
local textesGuilde = {} -- [UnitFrame] = texte <Guilde>
local nomSeul = {}      -- [UnitFrame] = barre de vie masquée par nous

-- même couleur pour le nom et la guilde de tous les joueurs hors guilde
-- bleu des noms de joueurs alliés du jeu (nom flottant), sans ombre ; nom et guilde de la même couleur
local COULEUR_ALLIE = { 0.443, 0.443, 1.00, 1 } -- relevé sur le nom flottant du jeu (113, 113, 255)
local ombresNoms = {} -- [UnitFrame] = ombre d'origine du nom (remise quand il redevient normal)

local policesNoms = {} -- [UnitFrame] = police d'origine du nom { police, taille, contour }
local OMBRE_ALLIE = { 0, 0, 0, 0.45 } -- ombre douce qui adoucit le bord des lettres (alpha 0 = aucune)
local RENDU_ALLIE = 3            -- texte dessiné 3 fois plus grand puis réduit (épaisseur des noms du jeu)
local DECALAGE_Y_ALLIE = -25    -- nom + guilde descendus de 25 px (négatif = plus bas)
local AGRANDISSEMENT_ALLIE = 1.5 -- taille fixe des noms hors guilde (x1.5 la police des barres)

-- police des noms flottants du jeu (Friz Quadrata), taille fixe
local function PoliceAllie() return UNIT_NAME_FONT or STANDARD_TEXT_FONT end

-- police des noms flottants du jeu (au-dessus des personnages), sans ombre ni contour
-- Couleur du nom selon le jeu : UnitSelectionColor (couleurs étendues) est la couleur de
-- « sélection » que Blizzard utilise pour colorer les noms (CompactUnitFrame_UpdateName) ;
-- repli sur le bleu relevé si le jeu refuse de la donner
local ECLAIRCISSEMENT_JEU = 0.106
local function CouleurJeu(unit)
	if unit and UnitSelectionColor then
		local ok, r, g, b = pcall(UnitSelectionColor, unit, true)
		if ok and r then
			-- le moteur éclaircit un peu ses noms flottants : (96, 96, 255) donné → (113, 113, 255) à l'écran
			local okE, r2, g2, b2 = pcall(function()
				local e = ECLAIRCISSEMENT_JEU
				return r + (1 - r) * e, g + (1 - g) * e, b + (1 - b) * e
			end)
			if okE then return r2, g2, b2, 1 end
			return r, g, b, 1
		end
	end
	return unpack(COULEUR_ALLIE)
end


local function StyleAllie(texte, taille, unit)
	-- toujours net : le jeu rend les barres de nom translucides (joueurs proches, cachés…)
	if texte.SetIgnoreParentAlpha then pcall(texte.SetIgnoreParentAlpha, texte, true) end
	-- ombre douce, sans contour
	pcall(texte.SetShadowColor, texte, unpack(OMBRE_ALLIE))
	pcall(texte.SetShadowOffset, texte, 1, -1)
	local police = PoliceAllie()
	-- Rendu « grand puis réduit » : les noms flottants du jeu sont dessinés en grand puis réduits,
	-- ce qui garde des traits épais ; une police d'interface dessinée petite a des traits fins.
	-- On écrit donc le texte RENDU_ALLIE fois plus grand, puis on le réduit (SetTextScale).
	local k = 1
	if texte.SetTextScale then k = RENDU_ALLIE end
	if police then pcall(texte.SetFont, texte, police, taille * k, "") end
	-- pas d'alignement sur la grille de pixels : sinon la taille avance par sauts d'un pixel
	if texte.SetSnapToPixelGrid then pcall(texte.SetSnapToPixelGrid, texte, false) end
	if texte.SetTexelSnappingBias then pcall(texte.SetTexelSnappingBias, texte, 0) end
	if texte.SetTextScale then pcall(texte.SetTextScale, texte, 1 / k) end
	pcall(texte.SetTextColor, texte, CouleurJeu(unit))
end

-- options « Noms » du jeu : noms des joueurs alliés, et leur guilde (réglage absent = affiché)
local function GuildesVoulues() return LireCVar("UnitNamePlayerGuild") ~= "0" end

local textesNoms = {} -- [UnitFrame] = nom écrit par GuildUpSMB (remplace celui de Blizzard)

-- Sur Forever, chaque personnage a un nom de famille, rangé là où les autres versions mettent
-- le royaume (UnitFullName : « Miko », « Banko ») ; le jeu l'affiche après le prénom
local function NomEtFamille(unit)
	local ok, nom, famille = pcall(UnitFullName, unit)
	if ok and nom then
		if famille and famille ~= "" then return nom .. " " .. famille end
	end
	-- repli : GetUnitName(unit, true) donne aussi « Miko Banko »
	local ok2, complet = pcall(GetUnitName, unit, true)
	if ok2 and complet and complet ~= "" then return (complet:gsub("%-", " ")) end
	return (ok and nom) or UnitName(unit) or ""
end

-- Statut devant le nom, comme dans la discussion : <Absent> / <Occupé>
local function StatutJoueur(unit)
	local okA, absent = pcall(UnitIsAFK, unit)
	if okA and absent then return (CHAT_FLAG_AFK or "<AFK>") .. " " end
	local okD, occupe = pcall(UnitIsDND, unit)
	if okD and occupe then return (CHAT_FLAG_DND or "<DND>") .. " " end
	return ""
end

-- Vie pas au maximum (la comparaison peut être refusée si le jeu cache la valeur : on l'ignore alors)
local function VieEntamee(unit)
	local ok, entamee = pcall(function() return UnitHealth(unit) < UnitHealthMax(unit) end)
	return ok and entamee or false
end
local etatsVie = {} -- [unité de barre de nom] = vie entamée ? (pour ne rafraîchir qu'au changement)

local function MajNomSeul(uf, unit)
	local hbc = uf.HealthBarsContainer or uf.healthBar
	local niveau = uf.PlayerLevelDiffFrame
	local t = textesGuilde[uf]
	local voulu = db.actif and db.nomsAllies and unit and UnitIsPlayer(unit) and not UnitIsUnit(unit, "player")
		and UnitIsFriend("player", unit) and not UnitInParty(unit) and not UnitInRaid(unit)
		and not UnitAffectingCombat(unit) -- en combat : barre de vie normale
		and not VieEntamee(unit)          -- blessé : barre de vie normale
		and not UnitIsUnit(unit, "target") -- ciblé : barre normale, avec la lueur de sélection
		and uf.name and uf.name:IsShown()
	if voulu then
		if hbc then pcall(hbc.SetAlpha, hbc, 0) end
		if niveau then pcall(niveau.SetAlpha, niveau, 0) end
		if not ombresNoms[uf] then
			local ok, x, y = pcall(uf.name.GetShadowOffset, uf.name)
			local ok2, r, g, b, a = pcall(uf.name.GetShadowColor, uf.name)
			ombresNoms[uf] = {
				x = ok and x or 1, y = ok and y or -1,
				r = ok2 and r or 0, g = ok2 and g or 0, b = ok2 and b or 0, a = ok2 and a or 1,
			}
		end
		-- police d'origine, relevée tant que le nom n'est pas encore passé à notre style
		if not nomSeul[uf] or not policesNoms[uf] then
			local ok, police, taille, contour = pcall(uf.name.GetFont, uf.name)
			if ok and police then policesNoms[uf] = { police, taille or 10, contour or "" } end
		end
		local taille = (policesNoms[uf] and policesNoms[uf][2] or 10) * AGRANDISSEMENT_ALLIE
		-- le nom de Blizzard ne suit pas le rendu « grand puis réduit » (le jeu remet sa propre
		-- échelle) : on le rend invisible et on écrit le nôtre, centré au-dessus de la barre
		pcall(uf.name.SetAlpha, uf.name, 0)
		nomSeul[uf] = true
		local n = textesNoms[uf]
		if not n then
			n = uf:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
			textesNoms[uf] = n
		end
		n:ClearAllPoints()
		n:SetPoint("BOTTOM", hbc or uf.name, "TOP", 0, 2 + DECALAGE_Y_ALLIE)
		StyleAllie(n, taille, unit)
		local texteNom = StatutJoueur(unit) .. NomEtFamille(unit)
		n:SetText(texteNom)
		n:Show()
		local guilde = GuildesVoulues() and GetGuildInfo(unit)
		if guilde and guilde ~= "" then
			if not t then
				t = uf:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				textesGuilde[uf] = t
			end
			t:ClearAllPoints()
			t:SetPoint("TOP", n, "BOTTOM", 0, -1)
			StyleAllie(t, taille, unit)
			t:SetText("<" .. guilde .. ">")
			t:Show()
		elseif t then
			t:Hide()
		end
	else
		if nomSeul[uf] then
			if hbc then pcall(hbc.SetAlpha, hbc, 1) end
			if niveau then pcall(niveau.SetAlpha, niveau, 1) end
			local o = ombresNoms[uf]
			if o then
				pcall(uf.name.SetShadowOffset, uf.name, o.x, o.y)
				pcall(uf.name.SetShadowColor, uf.name, o.r, o.g, o.b, o.a)
			end
			local p = policesNoms[uf]
			if p then pcall(uf.name.SetFont, uf.name, p[1], p[2], p[3]) end
			if uf.name.SetTextScale then pcall(uf.name.SetTextScale, uf.name, 1) end
			if uf.name.SetIgnoreParentAlpha then pcall(uf.name.SetIgnoreParentAlpha, uf.name, false) end
			pcall(uf.name.SetAlpha, uf.name, 1)
			nomSeul[uf] = nil
			AncragesBlizzard(uf) -- remet le nom à sa place d'origine
		end
		if t then t:Hide() end
		if textesNoms[uf] then textesNoms[uf]:Hide() end
	end
end

local function MajBarre(uf)
	if not db or not uf or (uf.IsForbidden and uf:IsForbidden()) then return end
	local unit, nom = uf.unit, uf.name
	if not nom or not unit then return end

	local f = fondsPlaques[uf]
	if db.actif and db.plaques and nom:IsShown() and EstDeMaGuilde(unit) then
		AppliquerMiseEnPage(uf)
		if not f then
			f = CreerFond(uf, "BACKGROUND", -7)
			f.lueur = CreerLueur(uf) -- lueur de cible, sous la bannière
			fondsPlaques[uf] = f
		end
		local _, taille = nom:GetFont()
		taille = taille or 10
		local barre = uf.healthBar
		if barre and barre:IsShown() then
			local niveau = uf.PlayerLevelDiffFrame
			AfficherPlaque(f, unit, barre, taille, niveau and niveau:IsShown() or false)
		else
			Masquer(f)
		end
		ColorerBarreVie(uf, unit)
		MajNomSeul(uf, nil)
	else
		if f then Masquer(f) end
		RestaurerBarreVie(uf)
		RestaurerMiseEnPage(uf)
		MajNomSeul(uf, unit)
	end
end

local function MajBarreUnite(unit)
	local plaque = C_NamePlate.GetNamePlateForUnit(unit)
	if plaque and not (plaque.IsForbidden and plaque:IsForbidden()) then
		MajBarre(plaque.UnitFrame)
	end
end

-- Blizzard met à jour le nom de la barre : on recale le fond juste après.
if CompactUnitFrame_UpdateName then
	hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
		if frame and frame.unit and frame.unit:find("^nameplate") then
			MajBarre(frame)
		end
	end)
end

-- Blizzard recolore la barre de vie (ou sa bordure) : on repasse derrière.
for _, fonction in ipairs({ "CompactUnitFrame_UpdateHealthColor", "CompactUnitFrame_UpdateHealthBorder",
	"CompactUnitFrame_UpdateSelectionHighlight" }) do
	if _G[fonction] then
		hooksecurefunc(fonction, function(frame)
			if frame and frame.unit and frame.unit:find("^nameplate") and modifiees[frame] then
				MajBarre(frame)
			end
		end)
	end
end

--------------------------------------------------------------------------------
-- Bannière du cadre de cible
--------------------------------------------------------------------------------

local fondCible
local cibleColoree = false

local function BarreVieCible()
	return TargetFrame and (TargetFrame.healthbar or _G.TargetFrameHealthBar)
end

local function MajCouleurCible()
	local hb = BarreVieCible()
	if not db or not hb then return end
	if db.actif and db.couleurs and EstDeMaGuilde("target") then
		local c = COULEURS[Etat("target")]
		hb:SetStatusBarColor(c[1], c[2], c[3])
		cibleColoree = true
	elseif cibleColoree then
		hb:SetStatusBarColor(0, 1, 0) -- vert Blizzard
		cibleColoree = false
	end
end

-- Blizzard remet sa couleur quand la vie change : on repasse derrière.
for _, fonction in ipairs({ "HealthBar_OnValueChanged", "UnitFrameHealthBar_Update" }) do
	if _G[fonction] then
		hooksecurefunc(fonction, function(barre)
			if cibleColoree and barre == BarreVieCible() then MajCouleurCible() end
		end)
	end
end

local function MajCible()
	MajCouleurCible()
	if not db or not TargetFrame then return end
	local nom = TargetFrame.name or _G.TargetFrameTextureFrameName
	local zone = TargetFrame.nameBackground or _G.TargetFrameNameBackground
	if not nom then return end

	if db.actif and db.cible and EstDeMaGuilde("target") then
		-- au-dessus du fond de nom de Blizzard, sous le texte et le cadre
		if not fondCible then fondCible = CreerFond(TargetFrame, "BACKGROUND", 7) end
		if zone then
			Afficher(fondCible, "target", zone, "zone")
		else
			Afficher(fondCible, "target", nom, "texte")
		end
	elseif fondCible then
		Masquer(fondCible)
	end
end

--------------------------------------------------------------------------------
-- Tout rafraîchir
--------------------------------------------------------------------------------

local function ToutRafraichir()
	if not db then return end
	for _, plaque in ipairs(C_NamePlate.GetNamePlates() or {}) do
		if not (plaque.IsForbidden and plaque:IsForbidden()) then
			MajBarre(plaque.UnitFrame)
		end
	end
	MajCible()
	if ns.MajBoutonCarte then ns.MajBoutonCarte() end
end

-- Évènements en rafale (liste de guilde, réglages, statuts…) : un seul rafraîchissement complet,
-- 0,2 s après le premier
local rafraichissementPrevu = false
local function PlanifierRafraichissement()
	if rafraichissementPrevu then return end
	rafraichissementPrevu = true
	C_Timer.After(0.2, function()
		rafraichissementPrevu = false
		ToutRafraichir()
	end)
end

-- Rôle d'un joueur changé : seulement sa barre de nom (et le cadre de cible si c'est lui)
local function MajJoueur(cle)
	if not db then return end
	for _, plaque in ipairs(C_NamePlate.GetNamePlates() or {}) do
		local uf = plaque.UnitFrame
		if uf and uf.unit and not (plaque.IsForbidden and plaque:IsForbidden()) and NomComplet(uf.unit) == cle then
			MajBarre(uf)
		end
	end
	if UnitExists("target") and NomComplet("target") == cle then MajCible() end
end

-- Auras et incantations : Blizzard replace ses éléments à chaque mise à jour, on repasse après lui.
-- Une seule passe par image pour toutes les barres concernées, et seulement pour celles des
-- membres de la guilde (mise en page GuildUpSMB).
local aReplacer = { auras = {}, incantation = {} }
local replacementPrevu = false
local function PlanifierReplacement(genre, unite)
	local plaque = C_NamePlate.GetNamePlateForUnit(unite)
	if not (plaque and plaque.UnitFrame and misesEnPage[plaque.UnitFrame]) then return end
	aReplacer[genre][unite] = true
	if replacementPrevu then return end
	replacementPrevu = true
	C_Timer.After(0, function()
		replacementPrevu = false
		for u in pairs(aReplacer.auras) do
			aReplacer.auras[u] = nil
			local p = C_NamePlate.GetNamePlateForUnit(u)
			if p and p.UnitFrame and misesEnPage[p.UnitFrame] then DeplacerAurasUnite(u) end
		end
		for u in pairs(aReplacer.incantation) do
			aReplacer.incantation[u] = nil
			local p = C_NamePlate.GetNamePlateForUnit(u)
			if p and not (p.IsForbidden and p:IsForbidden()) and p.UnitFrame and misesEnPage[p.UnitFrame] then
				pcall(PlacerIncantation, p.UnitFrame)
			end
		end
	end)
end


-- Réglages Blizzard des barres de nom imposés par GuildUpSMB à chaque connexion
-- (nameplateDebuffPadding = option « Espacement des affaiblissements »)
local CVARS_IMPOSEES = {
	nameplateDebuffPadding = "25",
}

-- Réglages imposés tant que GuildUpSMB est actif (remis comme avant à la désactivation) :
-- barres de nom alliées affichées (Maj+V) ; les noms flottants du jeu restent actifs : au-delà
-- de la portée des barres (limite interne du jeu), chacun retrouve son nom d'origine
local CVARS_ALLIES = {
	{ "nameplateShowFriends", "1" },
	{ "nameplateShowFriendlyPlayers", "1" },
	-- taille fixe : le jeu agrandit / réduit les barres de nom selon la distance (0,8 à 1 par
	-- défaut) ; à 1 / 1, toutes les barres gardent la même taille quelle que soit la distance
	{ "nameplateMinScale", "1" },
	{ "nameplateMaxScale", "1" },
	{ "nameplateSelectedScale", "1" }, -- la cible n'est plus agrandie (1,2 par défaut)
}

local function ImposerCVars()
	if InCombatLockdown() then
		-- certains réglages sont bloqués en combat : on réessaie à la sortie du combat
		local attente = CreateFrame("Frame")
		attente:RegisterEvent("PLAYER_REGEN_ENABLED")
		attente:SetScript("OnEvent", function(self)
			self:UnregisterAllEvents()
			ImposerCVars()
		end)
		return
	end
	local lire = LireCVarJeu
	local ecrire = (C_CVar and C_CVar.SetCVar) or SetCVar
	local voulues = {}
	for nom, valeur in pairs(CVARS_IMPOSEES) do voulues[nom] = valeur end
	if db.actif and db.nomsAllies then
		-- GuildUpSMB activé = barres de nom alliées affichées (comme Maj+V) ; le nom du réglage
		-- change selon les versions du client, ceux qui n'existent pas sont ignorés
		for _, c in ipairs(CVARS_ALLIES) do voulues[c[1]] = c[2] end
	end
	if type(db.cvarsAvant) ~= "table" then db.cvarsAvant = {} end
	-- anciens essais retirés (/smb portee, noms flottants coupés) : réglages du jeu remis
	for _, nom in ipairs({ "nameplateMaxDistance", "UnitNameFriendlyPlayerName" }) do
		if db.cvarsAvant[nom] then
			pcall(ecrire, nom, db.cvarsAvant[nom])
			db.cvarsAvant[nom] = nil
		end
	end
	db.portee = nil
	for nom, valeur in pairs(voulues) do
		local ok, actuelle = pcall(lire, nom)
		if ok and actuelle ~= nil and tostring(actuelle) ~= valeur then
			-- valeur d'avant GuildUpSMB, remise si on désactive
			if db.cvarsAvant[nom] == nil then db.cvarsAvant[nom] = tostring(actuelle) end
			local okE, res = pcall(ecrire, nom, valeur)
			local okR, apres = pcall(lire, nom)
			ns.essaisCVars = ns.essaisCVars or {}
			ns.essaisCVars[nom] = ("%s -> %s : %s, relu %s"):format(tostring(actuelle), valeur,
				okE and ("ok (" .. tostring(res) .. ")") or ("ERREUR " .. tostring(res)), okR and tostring(apres) or "?")
		end
	end
end

-- GuildUpSMB désactivé (ou /smb noms coupé) : barres de nom alliées remises comme avant
local function RendreCVarsAllies()
	if InCombatLockdown() then
		local attente = CreateFrame("Frame")
		attente:RegisterEvent("PLAYER_REGEN_ENABLED")
		attente:SetScript("OnEvent", function(self)
			self:UnregisterAllEvents()
			RendreCVarsAllies()
		end)
		return
	end
	if type(db.cvarsAvant) ~= "table" then return end
	local ecrire = (C_CVar and C_CVar.SetCVar) or SetCVar
	local aRendre = { "nameplateMaxDistance" }
	for _, c in ipairs(CVARS_ALLIES) do aRendre[#aRendre + 1] = c[1] end
	for _, nom in ipairs(aRendre) do
		if db.cvarsAvant[nom] ~= nil then
			pcall(ecrire, nom, db.cvarsAvant[nom])
			db.cvarsAvant[nom] = nil
		end
	end
end

local function SurActivation()
	if db.actif and db.nomsAllies then ImposerCVars() else RendreCVarsAllies() end
end


--------------------------------------------------------------------------------
-- Évènements des barres de nom (enregistrés au chargement de GuildUpDB, voir GuildUp.lua)
--------------------------------------------------------------------------------

local premiereEntree = true
local evPlaques = CreateFrame("Frame")
ns.ActiverPlaques = function()
	for _, e in ipairs({
		"NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "PLAYER_TARGET_CHANGED",
		"UNIT_NAME_UPDATE", "PLAYER_GUILD_UPDATE", "GUILD_ROSTER_UPDATE", "GROUP_ROSTER_UPDATE",
		"PLAYER_ROLES_ASSIGNED", "PLAYER_ENTERING_WORLD", "UNIT_AURA",
		"PLAYER_SPECIALIZATION_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "CVAR_UPDATE",
		"PLAYER_FLAGS_CHANGED", "UNIT_FLAGS", "UNIT_HEALTH", "UNIT_MAXHEALTH",
		"UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_EMPOWER_START",
	}) do
		pcall(evPlaques.RegisterEvent, evPlaques, e) -- certains évènements peuvent ne pas exister sur ce client
	end
end
evPlaques:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_ENTERING_WORLD" then
		ToutRafraichir()
		if premiereEntree then
			premiereEntree = false
			ImposerCVars()
			C_Timer.After(5, ImposerCVars) -- le jeu peut recharger ses réglages juste après la connexion
		end
	elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED"
		or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		PlanifierRafraichissement()
	elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START"
		or event == "UNIT_SPELLCAST_EMPOWER_START" then
		-- Blizzard peut replacer la barre d'incantation quand elle s'affiche : on repasse après lui
		if arg1 and arg1:find("^nameplate") and db.incantationHaut and not incantationRefusee then
			PlanifierReplacement("incantation", arg1)
		end
	elseif event == "UNIT_AURA" then
		-- Blizzard peut replacer ses icônes en mettant les auras à jour : on repasse après lui
		if arg1 and arg1:find("^nameplate") and db.aurasSous then
			PlanifierReplacement("auras", arg1)
		end
	elseif event == "NAME_PLATE_UNIT_ADDED" then
		if arg1 then etatsVie[arg1] = VieEntamee(arg1) end -- nouvelle unité sur ce jeton
		-- le nom n'est pas forcément encore écrit : on attend une image
		C_Timer.After(0, function() MajBarreUnite(arg1) end)
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		local plaque = C_NamePlate.GetNamePlateForUnit(arg1)
		local f = plaque and plaque.UnitFrame and fondsPlaques[plaque.UnitFrame]
		if f then Masquer(f) end
	elseif event == "PLAYER_TARGET_CHANGED" then
		ToutRafraichir() -- lueur de la cible, barre complète du joueur ciblé
	elseif event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
		-- vie qui passe sous le maximum ou y revient : on ne refait la barre qu'à ce moment-là
		if arg1 and arg1:find("^nameplate") and UnitIsPlayer(arg1) then
			local entamee = VieEntamee(arg1)
			if etatsVie[arg1] ~= entamee then
				etatsVie[arg1] = entamee
				MajBarreUnite(arg1)
			end
		end
	elseif event == "UNIT_FLAGS" then
		-- entrée / sortie de combat d'un joueur : barre de vie affichée ou non
		if arg1 and arg1:find("^nameplate") then MajBarreUnite(arg1) end
	elseif event == "UNIT_NAME_UPDATE" then
		if arg1 and arg1:find("^nameplate") then
			MajBarreUnite(arg1)
		else
			MajCible()
		end
	else
		-- GUILD_ROSTER_UPDATE, CVAR_UPDATE, PLAYER_FLAGS_CHANGED, PLAYER_GUILD_UPDATE… : regroupés
		PlanifierRafraichissement()
	end
end)

-- Partagé avec GuildUp.lua, GuildUp_MiniCarte.lua et GuildUp_Options.lua
ns.Plaques = {
	ToutRafraichir = ToutRafraichir, SurActivation = SurActivation, MajJoueur = MajJoueur, MajBarre = MajBarre,
	Bordures = Bordures, DeplacerAuras = DeplacerAuras, PlacerIncantation = PlacerIncantation,
	fondsPlaques = fondsPlaques, misesEnPage = misesEnPage, modifiees = modifiees,
}
