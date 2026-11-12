-- GuildUp : bannière derrière le nom et la barre de vie des membres de ta guilde.
-- L'image dépend du rôle (tank / heal / dps), qu'on soit en combat ou non ; rôle inconnu =
-- bannière neutre (fichier "horscombat"). Chaque GuildUp annonce le rôle de son joueur à la guilde.
-- Affichage local uniquement : seuls les joueurs qui ont l'addon le voient.

-- ns : table partagée entre les fichiers de l'addon (GuildUp_Groupes.lua s'en sert)
local NOM_ADDON, ns = ...
local MEDIA = "Interface\\AddOns\\GuildUp\\media\\"

local DEFAUT = {
	actif     = true,
	plaques   = true,        -- barres de nom au-dessus des têtes
	cible     = true,        -- bannière dans le cadre de cible
	style     = "banniere",  -- "banniere" ou "degrade"
	couleurs  = true,        -- barre de vie colorée selon le rôle (barres de nom + cadre de cible)
	lueur     = true,        -- lueur jaune autour de la barre de vie quand le joueur est ciblé
	aurasSous = true,        -- icônes d'améliorations sous la barre de vie (barres de nom)
	nomsAllies = true,       -- barres de nom alliées toujours affichées ; hors guilde et hors groupe : nom + <guilde> seuls
	annoncesGroupes = true,  -- message dans le chat quand un membre de la guilde ouvre un groupe
	partagePosition = true,  -- partager ma position sur la carte avec la guilde (activé de base, coupable dans le volet)
	testSolo = false,        -- test seul : mes propres messages sont traités comme ceux d'un autre membre
	testGroupe = false,      -- debug : bannières de groupe (_min) sur tout le monde
	niveauCentre = true,     -- niveau centré sur la hauteur de la bannière (barres de nom)
	nomGauche = true,        -- nom aligné à gauche au-dessus de la barre de vie (barres de nom)
	incantationHaut = true,  -- barre d'incantation au-dessus du nom, sur le bord doré (barres de nom)
	debugIncantation = false, -- affiche une fausse barre d'incantation pour régler sa position
	role      = "auto",      -- aperçu : "auto", ou forcer "tank" / "heal" / "dps" / "horscombat" sur tout le monde
	test      = false,       -- mode test : tous les joueurs comptent comme membres de la guilde
	r = 0.10, g = 0.55, b = 1.00, a = 0.80, -- couleur et opacité du style "degrade"
}

local db
local MajBarreRole -- petite barre de choix du rôle, définie plus bas

-- Lecture d'un réglage du jeu (CVar) : la fonction du client, et une version protégée
local LireCVarJeu = (C_CVar and C_CVar.GetCVar) or GetCVar
local function LireCVar(nom)
	local ok, v = pcall(LireCVarJeu, nom)
	return ok and v or nil
end

local function Message(texte)
	print("|cff3399ffGuildUp|r : " .. texte)
end

--------------------------------------------------------------------------------
-- Sons d'interface du jeu (ouverture / fermeture des fenêtres, clics, cases à cocher)
--------------------------------------------------------------------------------

local function Son(nom)
	local id = SOUNDKIT and SOUNDKIT[nom]
	if id then pcall(PlaySound, id) end
end
ns.Son = Son

local SONS_FENETRES = {
	fenetre = { "IG_CHARACTER_INFO_OPEN", "IG_CHARACTER_INFO_CLOSE" }, -- grandes fenêtres
	options = { "IG_MAINMENU_OPEN", "IG_MAINMENU_CLOSE" },             -- options /smb
	volet   = { "IG_MAINMENU_OPTION_CHECKBOX_ON", "IG_MAINMENU_OPTION_CHECKBOX_OFF" },
}

-- Sons sur tous les boutons et cases déjà créés dans un cadre (et ses enfants)
local function SonsSurBoutons(cadre, vus)
	vus = vus or {}
	if vus[cadre] then return end
	vus[cadre] = true
	local genre = cadre.GetObjectType and cadre:GetObjectType()
	-- bouton de fermeture : la fenêtre joue déjà son son en se fermant
	local parent = cadre.GetParent and cadre:GetParent()
	local fermeture = parent and parent.CloseButton == cadre
		or (cadre.GetName and (cadre:GetName() or ""):find("CloseButton$"))
	if (genre == "Button" or genre == "CheckButton") and not cadre.sonGuildUp and not fermeture then
		cadre.sonGuildUp = true
		cadre:HookScript("OnClick", function(self)
			if genre == "CheckButton" then
				Son(self:GetChecked() and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF")
			else
				Son("U_CHAT_SCROLL_BUTTON")
			end
		end)
	end
	for _, enfant in ipairs({ cadre:GetChildren() }) do SonsSurBoutons(enfant, vus) end
end
ns.SonsSurBoutons = SonsSurBoutons

-- Coupe un texte à au plus maxOctets octets et/ou maxLettres caractères, sans jamais couper un
-- caractère UTF-8 en deux (les zones de saisie comptent des lettres, les messages des octets)
local function CouperUTF8(texte, maxOctets, maxLettres)
	texte = texte or ""
	local n, fin = 0, 0
	for debut, car in texte:gmatch("()([%z\1-\127\194-\244][\128-\191]*)") do
		n = n + 1
		local f = debut + #car - 1
		if (maxLettres and n > maxLettres) or (maxOctets and f > maxOctets) then break end
		fin = f
	end
	return texte:sub(1, fin)
end
ns.CouperUTF8 = CouperUTF8

-- Longueur maximale d'un message d'addon accepté par le jeu (octets)
local LONGUEUR_MAX = 255
ns.LONGUEUR_MAX = LONGUEUR_MAX

-- Message d'addon qui n'a pas pu partir : prévenu à l'écran (au plus une fois toutes les 30 s)
local dernierAvertissement = 0
local function AvertirEchec(prefixe, raison)
	if GetTime() - dernierAvertissement < 30 then return end
	dernierAvertissement = GetTime()
	if UIErrorsFrame and UIErrorsFrame.AddMessage then
		UIErrorsFrame:AddMessage(("GuildUp : un message (%s) n'a pas pu partir : %s"):format(prefixe or "?", raison), 1, 0.82, 0)
	end
end

-- File d'envoi des messages d'addon (le jeu limite leur nombre par seconde) : un toutes les 0,3 s,
-- nouvel essai si le jeu refuse (trop de messages)
do
	local file, attente = {}, 0
	local pompe = CreateFrame("Frame")
	pompe:Hide()
	pompe:SetScript("OnUpdate", function(self, ecoule)
		attente = attente - ecoule
		if attente > 0 then return end
		local m = file[1]
		if not m then self:Hide(); return end
		local envoi = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage
		local ok, res = false, nil
		if envoi then ok, res = pcall(envoi, m[1], m[2], m[3] or "GUILD", m[4]) end
		local bloque = ok and (res == false or res == 3 or res == 8)
		if bloque and m.essais < 6 then
			m.essais = m.essais + 1
			attente = 1.5
		else
			if not ok then AvertirEchec(m[1], tostring(res)) elseif bloque then AvertirEchec(m[1], "trop de messages") end
			table.remove(file, 1)
			attente = 0.3
		end
	end)
	ns.EnvoyerAddon = function(prefixe, msg, canal, cible)
		if (canal or "GUILD") == "GUILD" and not IsInGuild() then return end
		if #msg > LONGUEUR_MAX then
			-- le jeu le refuserait sans rien dire : on prévient au lieu de le perdre en silence
			AvertirEchec(prefixe, ("trop long (%d octets)"):format(#msg))
			return
		end
		file[#file + 1] = { prefixe, msg, canal, cible, essais = 0 }
		pompe:Show()
	end
end

-- Avertissement à l'écran (texte en haut, comme les erreurs du jeu) au lieu du chat
local function Erreur(texte)
	if UIErrorsFrame and UIErrorsFrame.AddMessage then
		UIErrorsFrame:AddMessage(texte, 1, 0.82, 0)
	end
end
ns.Erreur = Erreur

-- Ajoute les sons d'ouverture / fermeture et des boutons à une fenêtre, et la renvoie
ns.AvecSons = function(f, type_)
	if not f or f.sonsGuildUp then return f end
	f.sonsGuildUp = true
	local sons = SONS_FENETRES[type_ or "fenetre"]
	if sons then
		f:HookScript("OnShow", function() Son(sons[1]) end)
		f:HookScript("OnHide", function() Son(sons[2]) end)
	end
	SonsSurBoutons(f)
	return f
end

--------------------------------------------------------------------------------
-- Qui, et dans quel état ?
--------------------------------------------------------------------------------

local function EstDeMaGuilde(unit)
	if not unit or not UnitExists(unit) or not UnitIsPlayer(unit) then return false end
	if db.test then return true end
	if UnitIsInMyGuild then
		return UnitIsInMyGuild(unit) and true or false
	end
	local maGuilde = GetGuildInfo("player")
	return maGuilde ~= nil and GetGuildInfo(unit) == maGuilde
end

local ROLES = { TANK = "tank", HEALER = "heal", DAMAGER = "dps" }
local ROLE_VALIDE = { tank = true, heal = true, dps = true }

local rolesConnus = {} -- ["Nom-Royaume"] = rôle annoncé par son GuildUp

-- Sur Forever, le royaume d'un joueur (UnitFullName : « Miko », « Banko ») n'est pas le nom
-- interne du serveur (GetNormalizedRealmName : « CAMWOWEU5Realm5PvE »), et les noms complets
-- peuvent arriver sous la forme « Miko Banko » (espace) ou « Miko-Banko » (tiret).
-- Pour comparer deux joueurs, on ramène tout à « Nom-Royaume ».
local function MonRoyaume()
	local ok, _, royaume = pcall(UnitFullName, "player")
	if ok and royaume and royaume ~= "" then return (royaume:gsub("%s", "")) end
	return ((GetNormalizedRealmName and GetNormalizedRealmName() or ""):gsub("%s", ""))
end

local function Normaliser(texte)
	if not texte or texte == "" then return nil end
	local nom, royaume = texte:match("^([^%-%s]+)[%-%s]+(.+)$")
	if not nom then nom, royaume = texte, MonRoyaume() end
	return nom .. "-" .. (royaume:gsub("%s", ""))
end
ns.Normaliser = Normaliser

-- Rôle choisi à la main, par personnage (db.rolesPerso[clé] = "tank" / "heal" / "dps" ; absent =
-- automatique). GuildUpDB est commun au compte : l'ancien réglage db.monRole, commun à tous les
-- personnages, est repris une fois par le premier personnage connecté.
local function RoleManuel()
	if not db then return "auto" end
	if type(db.rolesPerso) ~= "table" then db.rolesPerso = {} end
	local cle = Normaliser(UnitName("player"))
	if db.monRole ~= nil then
		if db.monRole ~= "auto" and cle and db.rolesPerso[cle] == nil then db.rolesPerso[cle] = db.monRole end
		db.monRole = nil
	end
	return cle and db.rolesPerso[cle] or "auto"
end

local function PoserRoleManuel(role)
	RoleManuel() -- reprise de l'ancien réglage
	local cle = Normaliser(UnitName("player"))
	if cle then db.rolesPerso[cle] = (role ~= "auto") and role or nil end
end

local function NomComplet(unit)
	local nom, royaume = UnitName(unit)
	if not nom then return nil end
	if royaume and royaume ~= "" then return Normaliser(nom .. "-" .. royaume) end
	return Normaliser(nom)
end

local function RoleDeGroupe(unit)
	if UnitGroupRolesAssigned then
		local ok, r = pcall(UnitGroupRolesAssigned, unit)
		if ok then return ROLES[r] end
	end
end

-- Mon rôle : choix manuel, sinon rôle de groupe, sinon rôle de ma spécialisation (si le client le permet)
local function MonRole()
	local manuel = RoleManuel()
	if ROLE_VALIDE[manuel] then return manuel end
	local r = RoleDeGroupe("player")
	if r then return r end
	if GetSpecialization and GetSpecializationRole then
		local ok, role = pcall(function() return GetSpecializationRole(GetSpecialization()) end)
		if ok and ROLES[role] then return ROLES[role] end
	end
	return nil
end

-- Partagé avec les autres fichiers de l'addon
ns.MonRole = function() return db and MonRole() end
-- Rôle annoncé par le GuildUp d'un joueur, à partir de son nom normalisé
ns.RoleDeNom = function(nomNormalise) return nomNormalise and rolesConnus[nomNormalise] end
-- Mode test seul (Debug) : se voir comme un autre membre
ns.TestSolo = function() return db and db.test and db.testSolo end
-- Rôle connu d'une unité (tank / heal / dps) ou nil : moi, rôle de groupe, ou rôle annoncé par son GuildUp
ns.RoleConnu = function(unit)
	if not db or not unit or not UnitExists(unit) then return nil end
	if UnitIsUnit(unit, "player") then return MonRole() end
	local r = RoleDeGroupe(unit)
	if r then return r end
	local nom = NomComplet(unit)
	return nom and rolesConnus[nom]
end
ns.DB = function() return db end
ns.NomComplet = NomComplet

-- Rôle affiché : aperçu forcé, sinon rôle de groupe, sinon rôle annoncé, sinon neutre
local function Etat(unit)
	if db.role ~= "auto" then return db.role end
	local r = RoleDeGroupe(unit)
	if r then return r end
	if UnitIsUnit(unit, "player") then return MonRole() or "horscombat" end
	local nom = NomComplet(unit)
	return (nom and rolesConnus[nom]) or "horscombat"
end

-- Couleur des barres de vie, version vive de la couleur de chaque bannière
local COULEURS = {
	tank       = { 0.20, 0.55, 1.00 }, -- bleu
	heal       = { 0.25, 0.85, 0.30 }, -- vert
	dps        = { 0.90, 0.15, 0.15 }, -- rouge
	horscombat = { 0.80, 0.15, 0.40 }, -- bordeaux
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
local modele = MODELES.V2

-- _min pour les membres de mon groupe ou de mon raid (et moi-même quand je suis groupé)
local function ModeleVoulu(unit)
	if db and db.test and db.testGroupe then return MODELES.min end -- debug : aperçu des bannières de groupe
	if unit and UnitExists(unit) and (UnitInParty(unit) or UnitInRaid(unit))
		and ((IsInGroup and IsInGroup()) or (IsInRaid and IsInRaid())) then
		return MODELES.min
	end
	return MODELES.V2
end

local function ImageBanniere(etat) return MEDIA .. "M_DC_Banner_" .. etat .. modele.suffixe .. ".tga" end

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
local V_HAUT, V_BAS, INT_HAUT, INT_BAS, INT_GAUCHE, INT_DROITE, BORD_DORE_HAUT, BORD_DORE_BAS, MORCEAUX

-- Charge les mesures du modèle voulu (V2 hors groupe, _min en groupe / raid)
local function UtiliserModele(unit)
	local m = ModeleVoulu(unit)
	modele = m
	V_HAUT, V_BAS, INT_HAUT, INT_BAS = m.V_HAUT, m.V_BAS, m.INT_HAUT, m.INT_BAS
	INT_GAUCHE, INT_DROITE, BORD_DORE_HAUT, BORD_DORE_BAS = m.INT_GAUCHE, m.INT_DROITE, m.BORD_DORE_HAUT, m.BORD_DORE_BAS
	MORCEAUX = m.MORCEAUX
end
UtiliserModele()
local ORDRE = { "g", "a", "o", "b", "d" }

local function CreerFond(parent, couche, sousCouche)
	local f = {}
	for _, cle in ipairs(ORDRE) do
		f[cle] = parent:CreateTexture(nil, couche, nil, sousCouche)
	end
	return f
end

local function Masquer(f)
	for _, cle in ipairs(ORDRE) do f[cle]:Hide() end
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
local function PoserBanniere(f, image, region, dxG, dxD, dyH, dyB, hauteurInt)
	local k = hauteurInt / (INT_BAS - INT_HAUT)
	local yHaut = dyH + (INT_HAUT - V_HAUT) * k
	local yBas = dyB - (V_BAS - INT_BAS) * k
	for _, cle in ipairs(ORDRE) do
		local t, c = f[cle], MORCEAUX[cle]
		t:ClearAllPoints()
		t:SetTexture(image)
		t:SetVertexColor(1, 1, 1, 1)
		t:SetTexCoord(c[1] / TEX_L, c[2] / TEX_L, V_HAUT / TEX_H, V_BAS / TEX_H)
	end
	local g, a, o, b, d = f.g, f.a, f.o, f.b, f.d
	local function Largeur(cle) return (MORCEAUX[cle][2] - MORCEAUX[cle][1]) * k end

	-- morceau gauche : son bord droit est 16 px (image) après le début de l'intérieur
	local xG = dxG + (MORCEAUX.g[2] - INT_GAUCHE) * k
	g:SetPoint("TOPRIGHT", region, "TOPLEFT", xG, yHaut)
	g:SetPoint("BOTTOMRIGHT", region, "BOTTOMLEFT", xG, yBas)
	g:SetWidth(Largeur("g"))
	-- embout droit : son bord gauche est 56 px (image) avant la fin de l'intérieur
	local xD = dxD - (INT_DROITE - MORCEAUX.d[1]) * k
	d:SetPoint("TOPLEFT", region, "TOPRIGHT", xD, yHaut)
	d:SetPoint("BOTTOMLEFT", region, "BOTTOMRIGHT", xD, yBas)
	d:SetWidth(Largeur("d"))
	-- ornement central : centré sur l'intérieur, jamais étiré
	local xO = (dxG + dxD) / 2
	o:SetPoint("TOP", region, "TOP", xO, yHaut)
	o:SetPoint("BOTTOM", region, "BOTTOM", xO, yBas)
	o:SetWidth(Largeur("o"))
	-- parties unies : elles comblent l'espace restant de chaque côté de l'ornement
	a:SetPoint("TOPLEFT", g, "TOPRIGHT", 0, 0)
	a:SetPoint("BOTTOMRIGHT", o, "BOTTOMLEFT", 0, 0)
	b:SetPoint("TOPLEFT", o, "TOPRIGHT", 0, 0)
	b:SetPoint("BOTTOMRIGHT", d, "BOTTOMLEFT", 0, 0)

	for _, cle in ipairs(ORDRE) do f[cle]:Show() end
end

-- Dégradé (style alternatif) : deux moitiés a / b, le reste caché
local function PoserDegrade(f, region, dxG, dxD, dyH, dyB, fortAuCentre)
	for _, cle in ipairs(ORDRE) do f[cle]:ClearAllPoints(); f[cle]:Hide() end
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
	UtiliserModele(unit)
	if mode == "texte" then
		if db.style == "degrade" then
			PoserDegrade(f, region, -14, 14, 3, -3, true)
		else
			PoserBanniere(f, ImageBanniere(Etat(unit)), region, -4, 4, 2, -2, region:GetHeight() + 4)
		end
	else
		if db.style == "degrade" then
			PoserDegrade(f, region, 0, 0, 0, 0, false)
		else
			PoserBanniere(f, ImageBanniere(Etat(unit)), region, 0, 0, 0, 0, region:GetHeight())
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
	UtiliserModele(unit)
	local _, bas, hauteur = GeometriePlaque(barre, tailleNom)
	local k = hauteur / (INT_BAS - INT_HAUT)
	local droite = MARGE_BANNIERE_X + (niveauVisible and EXTENSION_NIVEAU or 0)
	local gauche = -MARGE_BANNIERE_X + (MORCEAUX.g[2] - INT_GAUCHE) * k + DEBUT_INCANTATION
	local fin = droite - (INT_DROITE - MORCEAUX.d[1]) * k + FIN_INCANTATION
	local y = bas - (BORD_DORE_BAS - INT_BAS) * k + ECART_INCANTATION
	return gauche, fin, y
end

-- Lueur portée derrière la bannière du joueur ciblé : une copie de la bannière, un peu plus
-- grande, dorée et en mode additif, posée sous la vraie (couche plus basse)
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

local function LueurBanniere(f, unit, region, dxG, dxD, dyH, dyB, hauteur, niveauVisible)
	local l = f.lueur
	if not l then return end
	if not (db.lueur and UnitIsUnit(unit, "target")) then
		for _, t in ipairs(l) do t:Hide() end
		return
	end
	local k = hauteur / (INT_BAS - INT_HAUT)
	local xG = dxG + (INT_GAUCHE - DEBUT_LUEUR - INT_GAUCHE) * k
	-- fin à droite : avant la case du niveau si elle est affichée, sinon au bout de la bannière
	local xD = niveauVisible and FIN_LUEUR_NIVEAU or (dxD + (MORCEAUX.d[2] - INT_DROITE) * k)
	local yH = dyH - ((BORD_DORE_HAUT - DEBORD_LUEUR) - INT_HAUT) * k
	local yB = dyB - ((BORD_DORE_BAS + DEBORD_LUEUR) - INT_BAS) * k
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
	UtiliserModele(unit)
	local margeX = MARGE_BANNIERE_X
	local haut, bas, hauteur = GeometriePlaque(barre, tailleNom)
	local droite = margeX + (niveauVisible and EXTENSION_NIVEAU or 0)
	if db.style == "degrade" then
		PoserDegrade(f, barre, -margeX - 20, droite + 20, haut, bas, true)
		return
	end
	PoserBanniere(f, ImageBanniere(Etat(unit)), barre, -margeX, droite, haut, bas, hauteur)
	LueurBanniere(f, unit, barre, -margeX, droite, haut, bas, hauteur, niveauVisible)
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
		if obj and not obj.crochetLueurGuildUp and type(obj.UpdateSelectionBorder) == "function" then
			obj.crochetLueurGuildUp = true
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

-- Mise en page GuildUp (auras sous la barre, niveau, nom à gauche, incantation en haut) :
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
local function AgrandissementAllie() return AGRANDISSEMENT_ALLIE end

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

local textesNoms = {} -- [UnitFrame] = nom écrit par GuildUp (remplace celui de Blizzard)

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
		local taille = (policesNoms[uf] and policesNoms[uf][2] or 10) * AgrandissementAllie()
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
			Afficher(fondCible, "target", zone, "zone", zone:GetHeight())
		else
			Afficher(fondCible, "target", nom, "texte", 18)
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
	if MajBarreRole then MajBarreRole() end
end

--------------------------------------------------------------------------------
-- Annonce des rôles entre membres de la guilde (messages d'addon invisibles)
--------------------------------------------------------------------------------
-- "R:tank" / "R:heal" / "R:dps" / "R:?" = mon rôle ; "Q" = « annoncez-moi vos rôles »

local PREFIXE = "GuildUp"
local dernierEnvoi, envoiPrevu, dernierRoleAnnonce = 0, false, nil

local function Envoyer(msg)
	if not IsInGuild() then return end
	local envoi = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage
	if envoi then pcall(envoi, PREFIXE, msg, "GUILD") end
end

-- Annonce mon rôle s'il a changé (ou toujours si force), au plus une fois toutes les 10 s
local function Annoncer(force)
	if not force and (MonRole() or "?") == dernierRoleAnnonce then return end
	if envoiPrevu then return end
	envoiPrevu = true
	local attente = math.max(0, 10 - (GetTime() - dernierEnvoi))
	if force then attente = math.max(attente, math.random() * 5) end -- évite que toute la guilde réponde en même temps
	C_Timer.After(attente, function()
		envoiPrevu = false
		dernierEnvoi = GetTime()
		dernierRoleAnnonce = MonRole() or "?"
		Envoyer("R:" .. dernierRoleAnnonce)
	end)
end

local function Recevoir(prefixe, msg, expediteur)
	if prefixe ~= PREFIXE or not msg or not expediteur then return end
	expediteur = Normaliser(expediteur)
	if expediteur == NomComplet("player") then return end
	if msg == "Q" then
		Annoncer(true)
		return
	end
	local role = msg:match("^R:(.+)$")
	if role then
		rolesConnus[expediteur] = ROLE_VALIDE[role] and role or nil
		ToutRafraichir()
	end
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

local premiereEntree = true

-- Réglages Blizzard des barres de nom imposés par GuildUp à chaque connexion
-- (nameplateDebuffPadding = option « Espacement des affaiblissements »)
local CVARS_IMPOSEES = {
	nameplateDebuffPadding = "25",
}

-- Réglages imposés tant que GuildUp est actif (remis comme avant à la désactivation) :
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
		-- GuildUp activé = barres de nom alliées affichées (comme Maj+V) ; le nom du réglage
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
			-- valeur d'avant GuildUp, remise si on désactive
			if db.cvarsAvant[nom] == nil then db.cvarsAvant[nom] = tostring(actuelle) end
			local okE, res = pcall(ecrire, nom, valeur)
			local okR, apres = pcall(lire, nom)
			ns.essaisCVars = ns.essaisCVars or {}
			ns.essaisCVars[nom] = ("%s -> %s : %s, relu %s"):format(tostring(actuelle), valeur,
				okE and ("ok (" .. tostring(res) .. ")") or ("ERREUR " .. tostring(res)), okR and tostring(apres) or "?")
		end
	end
end

-- GuildUp désactivé (ou /smb noms coupé) : barres de nom alliées remises comme avant
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

-- Réglages hors DEFAUT, remis à zéro avec les autres (les données des modules : carnets, dons,
-- besoins, projets, identité, cvarsAvant… sont gardées)
local REGLAGES_HORS_DEFAUT = {
	"notifs", "barre", "annoncesGuilde", "emoteGU", "voletNotifs", "coursesCompact",
	"afficherDebug", "tousNiveaux", "styleJeu", "rappelGroupe", "portee", "rolesPerso",
}

-- Bouton « Réinitialiser » et /smb reset : seulement les réglages
local function ReinitialiserReglages()
	for _, k in ipairs(REGLAGES_HORS_DEFAUT) do db[k] = nil end
	for k, v in pairs(DEFAUT) do db[k] = v end
	SurActivation()
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, arg4)
	if event == "ADDON_LOADED" then
		if arg1 ~= NOM_ADDON then return end
		GuildUpDB = GuildUpDB or {}
		for k, v in pairs(DEFAUT) do
			if GuildUpDB[k] == nil then GuildUpDB[k] = v end
		end
		db = GuildUpDB
		-- données d'export du carnet (outil de préparation, absent des versions publiées) : on libère la place
		if not ns.Exporter then db.export = nil end
		-- aperçus de test (plus dans la fenêtre) : toujours désactivés au chargement
		db.role = "auto"
		db.debugIncantation = false
		-- partie Debug cachée (/smb debug pour l'afficher) : aucun essai ne reste actif à l'insu du joueur
		if not db.afficherDebug then db.test, db.testSolo, db.testGroupe = false, false, false end
		-- la lueur de cible avait été coupée (option plus visible dans la fenêtre) : remise une fois
		if not db.lueurRemise then db.lueur = true; db.lueurRemise = true end
		-- partage de position activé de base (1.5.0) : allumé une fois pour tout le monde, chacun peut le couper
		if not db.partageDeBase then db.partagePosition = true; db.partageDeBase = true end
		self:UnregisterEvent("ADDON_LOADED")
		local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
		if inscription then pcall(inscription, PREFIXE) end
		for _, e in ipairs({
			"NAME_PLATE_UNIT_ADDED", "NAME_PLATE_UNIT_REMOVED", "PLAYER_TARGET_CHANGED",
			"UNIT_NAME_UPDATE", "PLAYER_GUILD_UPDATE", "GUILD_ROSTER_UPDATE", "GROUP_ROSTER_UPDATE",
			"PLAYER_ROLES_ASSIGNED", "PLAYER_ENTERING_WORLD", "UNIT_AURA", "CHAT_MSG_ADDON",
			"PLAYER_SPECIALIZATION_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED", "CVAR_UPDATE",
			"PLAYER_FLAGS_CHANGED", "UNIT_FLAGS", "UNIT_HEALTH", "UNIT_MAXHEALTH",
			"UNIT_SPELLCAST_START", "UNIT_SPELLCAST_CHANNEL_START", "UNIT_SPELLCAST_EMPOWER_START",
		}) do
			pcall(self.RegisterEvent, self, e) -- certains évènements peuvent ne pas exister sur ce client
		end
	elseif event == "CHAT_MSG_ADDON" then
		-- arguments : préfixe, message, canal, expéditeur
		Recevoir(arg1, arg2, arg4)
	elseif event == "PLAYER_ENTERING_WORLD" then
		ToutRafraichir()
		if premiereEntree then
			premiereEntree = false
			ImposerCVars()
			C_Timer.After(5, ImposerCVars) -- le jeu peut recharger ses réglages juste après la connexion
			-- on laisse le temps à la guilde de se charger, puis on demande les rôles et on annonce le nôtre
			C_Timer.After(8, function()
				Envoyer("Q")
				Annoncer(true)
			end)
		end
	elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED"
		or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		Annoncer(false)
		ToutRafraichir()
	elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START"
		or event == "UNIT_SPELLCAST_EMPOWER_START" then
		-- Blizzard peut replacer la barre d'incantation quand elle s'affiche : on repasse après lui
		if arg1 and arg1:find("^nameplate") and db.incantationHaut and not incantationRefusee then
			C_Timer.After(0, function()
				local plaque = C_NamePlate.GetNamePlateForUnit(arg1)
				if plaque and not (plaque.IsForbidden and plaque:IsForbidden()) and plaque.UnitFrame
					and misesEnPage[plaque.UnitFrame] then
					pcall(PlacerIncantation, plaque.UnitFrame)
				end
			end)
		end
	elseif event == "UNIT_AURA" then
		-- Blizzard peut replacer ses icônes en mettant les auras à jour : on repasse après lui
		if arg1 and arg1:find("^nameplate") and db.aurasSous then
			C_Timer.After(0, function()
				local plaque = C_NamePlate.GetNamePlateForUnit(arg1)
				if plaque and plaque.UnitFrame and misesEnPage[plaque.UnitFrame] then
					DeplacerAurasUnite(arg1)
				end
			end)
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
		ToutRafraichir()
	end
end)

--------------------------------------------------------------------------------
-- Commandes /smb
--------------------------------------------------------------------------------

local function OuiNon(v) return v and "|cff00ff00oui|r" or "|cffff4444non|r" end

local function Aide()
	Message("/smb tout seul ouvre la fenêtre d'options. Commandes :")
	print("  /smb groupes — recherche de groupe de la guilde")
	print("  /smb metiers — registre des métiers de la guilde")
	print("  /smb quetes — quêtes en commun avec la guilde")
	print("  /smb evenements — créer un événement de guilde (calendrier du jeu)")
	print("  /smb echanges — dons et besoins de la guilde")
	print("  /smb carnet — carnet de craft (tes listes de courses)")
	print("  /smb encyclo — encyclopédie (ou Alt + clic sur un objet)")
	print("  /smb items — tous les objets fabricables")
	print("  /smb projets — projets de guilde")
	print("  /smb nouveautes — les nouveautés de cette version")
	print("  /smb sos — appeler la guilde à l'aide")
	print("  /smb on | off — bannières de la guilde (" .. OuiNon(db.actif) .. ")")
	print("  /smb barre — afficher / cacher le bouton de la mini-carte")
	print("  /smb noms — nom et guilde des autres joueurs (" .. OuiNon(db.nomsAllies) .. ")")
	print("  /smb lueur — lueur derrière la bannière de ta cible (" .. OuiNon(db.lueur) .. ")")
	print("  /smb diag — informations techniques à copier (en cas de problème)")
	print("  /smb reset — réglages par défaut")
end

local fenetre, MajFenetre -- fenêtre d'options, définies plus bas

local function Rafraichir()
	ToutRafraichir()
	if fenetre and fenetre:IsShown() then MajFenetre() end
end

local function OuvrirSelecteur()
	if not (ColorPickerFrame and ColorPickerFrame.SetupColorPickerAndShow) then
		Message("sélecteur indisponible sur ce client, utilise /smb couleur R V B")
		return
	end
	local avant = { r = db.r, g = db.g, b = db.b, a = db.a }
	ColorPickerFrame:SetupColorPickerAndShow({
		r = db.r, g = db.g, b = db.b,
		hasOpacity = true, opacity = db.a,
		swatchFunc = function()
			db.r, db.g, db.b = ColorPickerFrame:GetColorRGB()
			Rafraichir()
		end,
		opacityFunc = function()
			if ColorPickerFrame.GetColorAlpha then db.a = ColorPickerFrame:GetColorAlpha() end
			Rafraichir()
		end,
		cancelFunc = function()
			db.r, db.g, db.b, db.a = avant.r, avant.g, avant.b, avant.a
			Rafraichir()
		end,
	})
end

local ETATS = { auto = true, tank = true, heal = true, dps = true, horscombat = true }

-- /smb diag : décrit la barre de nom de ta cible, pour comprendre pourquoi rien ne s'affiche
local function DiagCollecte(L)
	do
		local lire = LireCVarJeu
		local t = {}
		for _, nom in ipairs({ "nameplateShowFriends", "nameplateShowFriendlyPlayers", "nameplateShowFriendlyNPCs", "nameplateShowAll", "UnitNameFriendlyPlayerName", "UnitNamePlayerGuild",
			"WorldTextMinSize", "nameplateMinScale", "nameplateMaxScale", "nameplateSelectedScale", "nameplateMaxDistance" }) do
			local ok, v = pcall(lire, nom)
			t[#t + 1] = nom .. "=" .. (ok and tostring(v) or "?")
		end
		L("barres de nom alliées (Maj+V) : " .. table.concat(t, ", "))
		for nom, txt in pairs(ns.essaisCVars or {}) do L("  essai " .. nom .. " : " .. txt) end
		local n = 0
		for _, plaque in ipairs(C_NamePlate.GetNamePlates() or {}) do
			local uf = plaque.UnitFrame
			local unit = uf and uf.unit
			if unit and UnitIsPlayer(unit) and n < 8 then
				n = n + 1
				local okA, a = pcall(uf.GetAlpha, uf)
				local okC, cr, cg, cb = pcall(UnitSelectionColor, unit, true)
				local couleur = "?"
				if okC then
					local okT, txt = pcall(function() return ("%d,%d,%d"):format(cr * 255, cg * 255, cb * 255) end)
					couleur = okT and txt or "secrète"
				end
				L(("  joueur %s : couleur du jeu=%s, guilde=%s, allié=%s, groupe=%s, opacité=%s"):format(
					tostring(UnitName(unit)), couleur, tostring(EstDeMaGuilde(unit)), tostring(UnitIsFriend("player", unit)),
					tostring(UnitInParty(unit) or UnitInRaid(unit) ~= nil),
					okA and tostring(a) or "?"))
			end
		end
	end
	local p = C_NamePlate.GetNamePlateForUnit("target")
	if not p then L("diag : ta cible n'a pas de barre de nom visible"); return end
	local interdit = p.IsForbidden and p:IsForbidden()
	L("diag — plaque : " .. (p:GetName() or "sans nom") .. ", interdite=" .. tostring(interdit))
	if interdit then return end
	local uf = p.UnitFrame
	L("  UnitFrame=" .. tostring(uf and (uf:GetName() or "sans nom")) .. " unit=" .. tostring(uf and uf.unit)
		.. " visible=" .. tostring(uf and uf:IsVisible()))
	L("  name=" .. tostring(uf and uf.name and uf.name:GetObjectType()) .. " healthBar="
		.. tostring(uf and uf.healthBar and uf.healthBar:GetObjectType()) .. " guilde=" .. tostring(EstDeMaGuilde("target")))
	do
		local hb = uf and uf.healthBar
		local f = fondsPlaques[uf]
		local l = f and f.lueur
		local okC, cible = pcall(UnitIsUnit, uf.unit, "target")
		L(("  lueur de cible : option=%s, barre modifiée=%s, ciblé=%s, lueur derrière la bannière affichée=%s"):format(
			tostring(db.lueur), tostring(modifiees[uf] == true), okC and tostring(cible) or "ERREUR",
			tostring(l and l[2] and l[2]:IsShown())))
		local sb = hb and hb.selectedBorder
		if sb then L("  lueur Blizzard (selectedBorder) : affichée=" .. tostring(sb:IsShown()) .. ", visible=" .. tostring(sb:IsVisible())) end
	end
	local cles = {}
	for k, v in pairs(uf or {}) do
		if type(v) == "table" and type(k) == "string" then cles[#cles + 1] = k end
	end
	table.sort(cles)
	L("  clés UnitFrame : " .. table.concat(cles, ", "))
	local enfants = {}
	for _, e in ipairs({ p:GetChildren() }) do
		enfants[#enfants + 1] = (e:GetName() or e:GetObjectType()) .. (e:IsShown() and "" or "(caché)")
	end
	L("  enfants de la plaque : " .. table.concat(enfants, ", "))
	-- contenu de la barre de vie et de son conteneur (pour trouver la bordure)
	local function Decrire(titre, obj)
		if type(obj) ~= "table" or not obj.GetRegions then return end
		local morceaux = {}
		for k, v in pairs(obj) do
			if type(k) == "string" and type(v) == "table" and v.GetObjectType then
				morceaux[#morceaux + 1] = k .. "(" .. v:GetObjectType() .. (v:IsShown() and "" or ",caché") .. ")"
			end
		end
		table.sort(morceaux)
		L("  " .. titre .. " clés : " .. table.concat(morceaux, ", "))
		local regions = {}
		for _, r in ipairs({ obj:GetRegions() }) do
			if r:GetObjectType() == "Texture" and r:IsShown() then
				regions[#regions + 1] = tostring(r:GetAtlas() or r:GetTexture() or "?")
			end
		end
		L("  " .. titre .. " textures visibles : " .. table.concat(regions, ", "))
	end
	if uf then
		Decrire("healthBar", uf.healthBar)
		Decrire("HealthBarsContainer", uf.HealthBarsContainer)
		L("  bordures trouvées : " .. #Bordures(uf))
		local af = uf.AurasFrame
		if af then
			Decrire("AurasFrame", af)
			Decrire("BuffListFrame", af.BuffListFrame)
			Decrire("DebuffListFrame", af.DebuffListFrame)
		else
			L("  AurasFrame : absent")
		end
		-- fonctions de mise en page de Blizzard (pour remettre une barre de nom dans son état d'origine)
		local function Fonctions(titre, obj)
			if type(obj) ~= "table" then return end
			local noms = {}
			for k, v in pairs(obj) do
				if type(v) == "function" and type(k) == "string"
					and (k:find("Layout") or k:find("Anchor") or k:find("Setup") or k:find("Position")
						or k:find("Apply") or k:find("Refresh") or k:find("Update")) then
					noms[#noms + 1] = k
				end
			end
			table.sort(noms)
			L("  " .. titre .. " fonctions : " .. (#noms > 0 and table.concat(noms, ", ") or "aucune"))
		end
		Fonctions("UnitFrame", uf)
		Fonctions("plaque", p)
		Fonctions("AurasFrame", uf.AurasFrame)
		Fonctions("CastBarsContainer", uf.CastBarsContainer)
		Fonctions("castBar", uf.CastBarsContainer and uf.CastBarsContainer.castBar)
		Decrire("CastBarsContainer", uf.CastBarsContainer)
		-- on ne déplace rien sur une barre de nom hors guilde (la mise en page ne s'applique qu'à la guilde)
		local function Tenter(fn)
			if not misesEnPage[uf] then return "non appliqué (pas de la guilde)" end
			local ok, e = pcall(fn, uf)
			return ok and "ok" or ("ERREUR " .. tostring(e))
		end
		L("  mise en page GuildUp appliquée : " .. tostring(misesEnPage[uf] == true))
		L("  placement de l'incantation : " .. Tenter(PlacerIncantation))
		Decrire("LevelFrame", uf.LevelFrame)
		Decrire("PlayerLevelDiffFrame", uf.PlayerLevelDiffFrame)
		L("  déplacement des auras : " .. Tenter(DeplacerAuras))
		local ok, err = pcall(MajBarre, uf)
		L("  MajBarre : " .. (ok and "ok" or ("ERREUR " .. tostring(err))))
		local f = fondsPlaques[uf]
		if f then
			L("  fond : visible=" .. tostring(f.o:IsVisible()) .. " texture=" .. tostring(f.o:GetTexture()))
		else
			L("  fond : jamais créé")
		end
	end
	L("  hook CompactUnitFrame_UpdateName : " .. tostring(CompactUnitFrame_UpdateName ~= nil))
	local n = 0
	for _ in pairs(rolesConnus) do n = n + 1 end
	L(("  rôles : le mien=%s, cible=%s (%s), rôles reçus de la guilde=%d, spécialisation lisible=%s"):format(
		tostring(MonRole()), tostring(Etat("target")), tostring(NomComplet("target")), n,
		tostring(GetSpecialization ~= nil and GetSpecializationRole ~= nil)))
end

-- Fenêtre avec le texte du diagnostic, déjà sélectionné : Ctrl+C pour copier
local fenetreCopie

local function AfficherCopie(texte)
	if not fenetreCopie then
		local f = ns.FenetreDeplacable("GuildUpCopie", 520, 380)
		if f.TitleText then f.TitleText:SetText("GuildUp — diag (Ctrl+C pour copier)") end

		local defile = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		defile:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -30)
		defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -32, 12)

		local edit = CreateFrame("EditBox", nil, defile)
		edit:SetMultiLine(true)
		edit:SetAutoFocus(false)
		edit:SetFontObject("ChatFontNormal")
		edit:SetWidth(470)
		edit:SetScript("OnEscapePressed", function() f:Hide() end)
		-- le texte ne doit pas être modifié : on le remet si on tape dedans
		edit:SetScript("OnTextChanged", function(self, parUtilisateur)
			if parUtilisateur then self:SetText(f.texte or ""); self:HighlightText() end
		end)
		defile:SetScrollChild(edit)
		f.edit = edit
		fenetreCopie = f
	end
	fenetreCopie.texte = texte
	fenetreCopie:Show()
	fenetreCopie.edit:SetText(texte)
	fenetreCopie.edit:SetFocus()
	fenetreCopie.edit:HighlightText()
end

-- Test pour la future carte de la guilde : la position du joueur est-elle lisible par un addon ?
local function DiagPosition(L)
	L("position (test pour la carte) :")
	if not (C_Map and C_Map.GetBestMapForUnit) then
		L("  C_Map.GetBestMapForUnit : absent")
		return
	end
	local okM, carte = pcall(C_Map.GetBestMapForUnit, "player")
	L("  carte : " .. (okM and tostring(carte) or ("ERREUR " .. tostring(carte))))
	if okM and carte then
		local okI, info = pcall(C_Map.GetMapInfo, carte)
		L("  nom de la carte : " .. tostring(okI and info and info.name))
		local okP, pos = pcall(C_Map.GetPlayerMapPosition, carte, "player")
		if okP and pos then
			local okX, x, y = pcall(pos.GetXY, pos)
			L("  coordonnées : " .. (okX and ("%.4f, %.4f"):format(x or -1, y or -1) or ("ERREUR " .. tostring(x))))
		else
			L("  coordonnées : " .. (okP and "aucune (nil)" or ("ERREUR " .. tostring(pos))))
		end
	end
	local okU, ux, uy, uz, instance = pcall(UnitPosition, "player")
	L("  UnitPosition : " .. (okU and ("%s, %s, instance %s"):format(tostring(ux), tostring(uy), tostring(instance))
		or ("ERREUR " .. tostring(ux))))
	L("  en instance : " .. tostring(IsInInstance and IsInInstance()))
end

local function Diag()
	local lignes = {}
	local function L(s) lignes[#lignes + 1] = s end
	DiagCollecte(L)
	pcall(DiagPosition, L)
	if ns.DiagGroupes then
		local ok, err = pcall(ns.DiagGroupes, L)
		if not ok then L("groupes : ERREUR " .. tostring(err)) end
	end
	if ns.DiagCarte then
		local ok, err = pcall(ns.DiagCarte, L)
		if not ok then L("carte : ERREUR " .. tostring(err)) end
	end
	for _, d in ipairs({ { "métiers", ns.DiagMetiers }, { "version", ns.DiagVersion }, { "quêtes", ns.DiagQuetes },
		{ "événements", ns.DiagEvenements }, { "recherche", ns.DiagRecherche }, { "besoins", ns.DiagBesoins }, { "échanges", ns.DiagEchanges }, { "discord", ns.DiagDiscord }, { "carnet", ns.DiagCarnet }, { "carnet2", ns.DiagCarnet2 }, { "projets", ns.DiagProjets }, { "identité", ns.DiagIdentite }, { "gu", ns.DiagGU } }) do
		if d[2] then
			local ok, err = pcall(d[2], L)
			if not ok then L(d[1] .. " : ERREUR " .. tostring(err)) end
		end
	end
	AfficherCopie(table.concat(lignes, "\n"))
end

--------------------------------------------------------------------------------
-- Fenêtre d'options (/smb)
--------------------------------------------------------------------------------

local controles = {} -- { maj = fonction qui recale l'état affiché }

MajFenetre = function()
	for _, c in ipairs(controles) do c.maj() end
end

local function Appliquer()
	ToutRafraichir()
	MajFenetre()
end

local function NouvelleCase(parent, x, y, texte, lire, ecrire, radio)
	local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	cb:SetSize(24, 24)
	cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	local label = cb.Text or cb.text
	if not label then
		label = cb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("LEFT", cb, "RIGHT", 2, 0)
	end
	label:SetFontObject("GameFontHighlight")
	label:SetText(texte)
	cb:SetScript("OnClick", function(self)
		if radio then ecrire() else ecrire(self:GetChecked() and true or false) end
		Appliquer()
	end)
	table.insert(controles, { maj = function() cb:SetChecked(lire()) end })
	return cb
end

local function NouveauTitre(parent, x, y, texte)
	local t = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	t:SetText(texte)
	return t
end

local function CreerFenetre()
	local f = ns.FenetreDeplacable("GuildUpFenetre", 330, 354)
	f:SetScript("OnShow", MajFenetre)

	local titre = f.TitleText or f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if not f.TitleText then titre:SetPoint("TOP", f, "TOP", 0, -16) end
	titre:SetText("GuildUp")

	local x, y = 16, -34
	local function Ligne(h) local v = y; y = y - (h or 24); return v end

	NouvelleCase(f, x, Ligne(), "Activer les bannières",
		function() return db.actif end, function(v) db.actif = v; SurActivation() end)
	NouvelleCase(f, x, Ligne(), "Afficher le bouton de la mini-carte",
		function() return db.barre == nil or db.barre.visible ~= false end, function(v)
			if type(db.barre) ~= "table" then db.barre = {} end
			db.barre.visible = v
		end)

	NouveauTitre(f, x, Ligne(20) - 6, "Mon rôle (annoncé à la guilde)")
	local yMoi1, yMoi2 = Ligne(), Ligne()
	local mesRoles = {
		{ "auto", "Auto (groupe / spécialisation)", x, yMoi1 },
		{ "tank", "Tank", x, yMoi2 },
		{ "heal", "Heal", x + 90, yMoi2 },
		{ "dps", "DPS", x + 180, yMoi2 },
	}
	for _, r in ipairs(mesRoles) do
		local cle = r[1]
		NouvelleCase(f, r[3], r[4], r[2],
			function() return RoleManuel() == cle end, function()
				PoserRoleManuel(cle)
				Annoncer(true)
			end, true)
	end
	local detecte = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	detecte:SetPoint("TOPLEFT", f, "TOPLEFT", x + 4, Ligne(16) - 2)
	table.insert(controles, { maj = function()
		local r = MonRole()
		detecte:SetText("Rôle annoncé : " .. (r and r:upper() or "inconnu (bannière neutre)"))
	end })

	-- Partie Debug : cachée par défaut, affichée avec /smb debug (pour tester l'addon)
	local hauteurSansDebug = -Ligne(0) + 50
	Ligne(6)
	local dbg = CreateFrame("Frame", nil, f)
	dbg:SetAllPoints(f)
	NouvelleCase(dbg, x, Ligne(), "Debug (tous les joueurs = guilde)",
		function() return db.test end, function(v) db.test = v end)
	NouvelleCase(dbg, x + 20, Ligne(), "Me voir comme un autre membre (test seul)",
		function() return db.testSolo end, function(v)
			db.testSolo = v
			if v and not db.test then Erreur("Coche aussi « Debug » pour activer le test seul") end
			if ns.SurChangementTestSolo then ns.SurChangementTestSolo() end
		end)
	NouvelleCase(dbg, x + 20, Ligne(), "Bannières de groupe sur tout le monde",
		function() return db.testGroupe end, function(v)
			db.testGroupe = v
			if v and not db.test then Erreur("Coche aussi « Debug » pour voir les bannières de groupe") end
		end)

	-- debug : forcer la bannière d'un rôle sur tout le monde (remis en Auto à chaque connexion)
	local etiquette = dbg:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	local yRoles = Ligne(22)
	etiquette:SetPoint("TOPLEFT", dbg, "TOPLEFT", x + 24, yRoles - 6)
	etiquette:SetText("Rôle affiché :")
	local yRoles2 = Ligne()
	local rolesDebug = {
		{ "auto", "Auto", x + 20, yRoles2 },
		{ "tank", "Tank", x + 75, yRoles2 },
		{ "heal", "Heal", x + 130, yRoles2 },
		{ "dps", "DPS", x + 185, yRoles2 },
		{ "horscombat", "Neutre", x + 235, yRoles2 },
	}
	for _, r in ipairs(rolesDebug) do
		local cle = r[1]
		NouvelleCase(dbg, r[3], r[4], r[2],
			function() return db.role == cle end, function()
				db.role = cle
				if cle ~= "auto" and not db.test then Erreur("Coche aussi « Debug » pour le voir sur tout le monde") end
			end, true)
	end

	local hauteurAvecDebug = -Ligne(0) + 50
	table.insert(controles, { maj = function()
		dbg:SetShown(db.afficherDebug and true or false)
		f:SetHeight(db.afficherDebug and hauteurAvecDebug or hauteurSansDebug)
	end })

	local reset = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	reset:SetSize(130, 22)
	reset:SetPoint("BOTTOM", f, "BOTTOM", 0, 14)
	reset:SetText("Réinitialiser")
	reset:SetScript("OnClick", function()
		ReinitialiserReglages()
		Appliquer()
	end)

	f:Hide()
	return f
end

local function BasculerFenetre()
	fenetre = fenetre or ns.AvecSons(CreerFenetre(), "options")
	fenetre:SetShown(not fenetre:IsShown())
end

--------------------------------------------------------------------------------
-- Bouton de mini-carte (comme les autres addons) :
--   collé au bord de la mini-carte, on le fait glisser pour le faire tourner autour ;
--   icône = rôle actuel ; clic gauche = volet [Tank] [Heal] [DPS] [Groupes] ; clic droit = groupes.
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
	if fenetre and fenetre:IsShown() then MajFenetre() end
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

-- Volet du bouton de mini-carte, en trois lignes :
--   1. Mon rôle : [Tank] [Heal] [DPS]
--   2. [Position] [Groupes] [Métiers]
--   3. [x] Activer GuildUp
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

	-- Ligne 5 : activer GuildUp (bannières, noms, barres de nom alliées)
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
		if fenetre and fenetre:IsShown() then MajFenetre() end
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
		{ "gu", "GU!" },
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
		b.anneau:SetTexture("Interface\\AddOns\\GuildUp\\media\\anneau")
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
		GameTooltip:SetText("GuildUp")
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

-- Renvoie true si la bulle est affichée (false : GuildUp pas prêt ou catégorie coupée)
ns.Notifier = function(categorie, titre, texte, son, action)
	if not db then return false end
	if not NotifActive(categorie) then return false end
	bulle = bulle or CreerBulle()
	if bulle.Reinit then bulle.Reinit(bulle) end -- une bulle spéciale (GuildUp_GU) l'avait décorée
	bulle.action = action
	bulle.titre:SetText(titre or "GuildUp")
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

SLASH_GUILDUP1 = "/smb"
SLASH_GUILDUP2 = "/guildup"
SlashCmdList.GUILDUP = function(msg)
	local cmd, reste = (msg or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")
	if cmd == "on" then
		db.actif = true; Message("activé"); SurActivation()
	elseif cmd == "off" then
		db.actif = false; Message("désactivé"); SurActivation()
	elseif cmd == "plaques" then
		db.plaques = not db.plaques; Message("barres de nom : " .. OuiNon(db.plaques))
	elseif cmd == "cible" then
		db.cible = not db.cible; Message("cadre de cible : " .. OuiNon(db.cible))
	elseif cmd == "cast" then
		db.incantationHaut = not db.incantationHaut
		Message("barre d'incantation au-dessus du nom : " .. OuiNon(db.incantationHaut)
			.. (db.incantationHaut and "" or " (/reload pour la remettre à sa place)"))
	elseif cmd == "metiers" or cmd == "métiers" or cmd == "metier" then
		if ns.BasculerMetiers then ns.BasculerMetiers() end
		return
	elseif cmd == "carnet" or cmd == "liste" or cmd == "craft" then
		if ns.BasculerCourses then ns.BasculerCourses() end
		return
	elseif cmd == "encyclo" or cmd == "encyclopedie" or cmd == "encyclopédie" then
		local fi = ns.FicheCadre and ns.FicheCadre()
		if fi and fi:IsShown() then fi:Hide() elseif ns.OuvrirFiche then ns.OuvrirFiche(nil) end
		return
	elseif cmd == "gu" then
		-- même réglage que la case « GU! » des notifications du volet
		if type(db.notifs) ~= "table" then db.notifs = {} end
		db.notifs.gu = (db.notifs.gu == false) and nil or false
		db.emoteGU = nil
		Message(db.notifs.gu == false and "emote « GU! » coupée." or "emote « GU! » activée.")
		return
	elseif cmd == "projets" or cmd == "projet" then
		if ns.OuvrirProjet then ns.OuvrirProjet() end
		return
	elseif cmd == "items" then
		if ns.BasculerArtisanat then ns.BasculerArtisanat(2) end
		return
	elseif cmd == "sos" then
		if ns.DemanderAide then ns.DemanderAide() end
		return
	elseif cmd == "nouveautes" or cmd == "nouveautés" or cmd == "notes" then
		if ns.MontrerNouveautes then ns.MontrerNouveautes() end
		return
	elseif cmd == "echanges" or cmd == "échanges" or cmd == "dons" then
		if ns.BasculerEchanges then ns.BasculerEchanges() end
		return
	elseif cmd == "quetes" or cmd == "quêtes" then
		if ns.BasculerQuetes then ns.BasculerQuetes() end
		return
	elseif cmd == "evenements" or cmd == "événements" or cmd == "events" then
		if ns.BasculerEvenements then ns.BasculerEvenements() end
		return
	elseif cmd == "annonces" then
		db.annoncesGuilde = (db.annoncesGuilde == false)
		Message("annonces de la guilde en bulle (niveaux, métiers) : " .. OuiNon(db.annoncesGuilde))
	elseif cmd == "groupes" or cmd == "groupe" then
		if ns.BasculerGroupes then ns.BasculerGroupes() end
		return
	elseif cmd == "barre" then
		local r = ReglagesBarre()
		r.visible = not r.visible
		Message("bouton de la mini-carte : " .. OuiNon(r.visible))
	elseif cmd == "diag" then
		Diag(); return
	elseif cmd == "couleurs" then
		db.couleurs = not db.couleurs; Message("couleurs selon le rôle : " .. OuiNon(db.couleurs))
	elseif cmd == "noms" then
		db.nomsAllies = not db.nomsAllies
		Message("noms et guilde des joueurs alliés toujours affichés : " .. OuiNon(db.nomsAllies))
		SurActivation()
	elseif cmd == "auras" then
		db.aurasSous = not db.aurasSous; Message("améliorations sous la barre : " .. OuiNon(db.aurasSous))
	elseif cmd == "lueur" then
		db.lueur = not db.lueur; Message("lueur jaune de sélection : " .. OuiNon(db.lueur))
	elseif cmd == "style" then
		if reste ~= "banniere" and reste ~= "degrade" then Message("ex. /smb style banniere"); return end
		db.style = reste; Message("style : " .. reste)
	elseif cmd == "role" then
		if not ETATS[reste] then Message("ex. /smb role tank (ou auto)"); return end
		db.role = reste; Message("rôle : " .. reste)
	elseif cmd == "couleur" then
		local r, g, b = reste:match("^([%d%.]+)%s+([%d%.]+)%s+([%d%.]+)$")
		r, g, b = tonumber(r), tonumber(g), tonumber(b)
		if not (r and g and b) then
			OuvrirSelecteur(); return
		end
		if r > 1 or g > 1 or b > 1 then r, g, b = r / 255, g / 255, b / 255 end
		db.r, db.g, db.b = math.min(r, 1), math.min(g, 1), math.min(b, 1)
		Message(("couleur : %.2f %.2f %.2f"):format(db.r, db.g, db.b))
	elseif cmd == "opacite" or cmd == "opacité" then
		local a = tonumber(reste)
		if not a then Message("ex. /smb opacite 0.8"); return end
		db.a = math.max(0, math.min(a, 1)); Message(("opacité : %.2f"):format(db.a))
	elseif cmd == "reset" then
		ReinitialiserReglages()
		Message("réglages par défaut (tes carnets, dons, besoins et projets sont gardés)")
	else
		if cmd == "" then BasculerFenetre() else Aide() end
		return
	end
	ToutRafraichir()
	if fenetre and fenetre:IsShown() then MajFenetre() end
end
