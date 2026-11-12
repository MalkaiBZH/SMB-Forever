-- GuildUpSMB : bannière derrière le nom et la barre de vie des membres de ta guilde.
-- L'image dépend du rôle (tank / heal / dps), qu'on soit en combat ou non ; rôle inconnu =
-- bannière neutre (fichier "horscombat"). Chaque GuildUpSMB annonce le rôle de son joueur à la guilde.
-- Affichage local uniquement : seuls les joueurs qui ont l'addon le voient.

-- ns : table partagée entre les fichiers de l'addon (GuildUp_Groupes.lua s'en sert)
local NOM_ADDON, ns = ...
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\" -- le dossier de l'addon, quel que soit son nom

local DEFAUT = {
	actif     = true,
	plaques   = true,        -- barres de nom au-dessus des têtes
	cible     = true,        -- bannière dans le cadre de cible
	style     = "banniere",  -- "banniere" ou "degrade"
	couleurs  = true,        -- barre de vie colorée selon le rôle (barres de nom + cadre de cible)
	lueur     = true,        -- lueur jaune autour de la barre de vie quand le joueur est ciblé
	medaillons = true,       -- portrait du joueur (race, classe, sexe) à la place de la mascotte de la bannière
	aurasSous = true,        -- icônes d'améliorations sous la barre de vie (barres de nom)
	nomsAllies = true,       -- barres de nom alliées toujours affichées ; hors guilde et hors groupe : nom + <guilde> seuls
	partagePosition = true,  -- partager ma position sur la carte avec la guilde (activé de base, coupable dans le volet)
	reperes = true,          -- repères des membres de ma zone à l'écran (GuildUp_Reperes.lua)
	testSolo = false,        -- test seul : mes propres messages sont traités comme ceux d'un autre membre
	testGroupe = false,      -- debug : bannières de groupe (_min) sur tout le monde
	nomGauche = true,        -- nom aligné à gauche au-dessus de la barre de vie (barres de nom)
	incantationHaut = true,  -- barre d'incantation au-dessus du nom, sur le bord doré (barres de nom)
	debugIncantation = false, -- affiche une fausse barre d'incantation pour régler sa position
	role      = "auto",      -- aperçu : "auto", ou forcer "tank" / "heal" / "dps" / "horscombat" sur tout le monde
	test      = false,       -- mode test : tous les joueurs comptent comme membres de la guilde
	r = 0.10, g = 0.55, b = 1.00, a = 0.80, -- couleur et opacité du style "degrade"
}

local db

-- Lecture d'un réglage du jeu (CVar) : la fonction du client, et une version protégée
local LireCVarJeu = (C_CVar and C_CVar.GetCVar) or GetCVar
local function LireCVar(nom)
	local ok, v = pcall(LireCVarJeu, nom)
	return ok and v or nil
end

local function Message(texte)
	print("|cff3399ffGuildUpSMB|r : " .. texte)
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
	if (genre == "Button" or genre == "CheckButton") and not cadre.sonGuildUpSMB and not fermeture then
		cadre.sonGuildUpSMB = true
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

-- Avertissement à l'écran (texte en haut, comme les erreurs du jeu) au lieu du chat
local function Erreur(texte)
	if UIErrorsFrame and UIErrorsFrame.AddMessage then
		UIErrorsFrame:AddMessage(texte, 1, 0.82, 0)
	end
end
ns.Erreur = Erreur

-- Ajoute les sons d'ouverture / fermeture et des boutons à une fenêtre, et la renvoie
ns.AvecSons = function(f, type_)
	if not f or f.sonsGuildUpSMB then return f end
	f.sonsGuildUpSMB = true
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

local rolesConnus = {} -- ["Nom-Royaume"] = rôle annoncé par son GuildUpSMB

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
-- Rôle annoncé par le GuildUpSMB d'un joueur, à partir de son nom normalisé
ns.RoleDeNom = function(nomNormalise) return nomNormalise and rolesConnus[nomNormalise] end
-- Mode test seul (Debug) : se voir comme un autre membre
ns.TestSolo = function() return db and db.test and db.testSolo end
-- Rôle connu d'une unité (tank / heal / dps) ou nil : moi, rôle de groupe, ou rôle annoncé par son GuildUpSMB
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

--------------------------------------------------------------------------------
-- Annonce des rôles entre membres de la guilde (messages d'addon invisibles)
--------------------------------------------------------------------------------
-- "R:tank" / "R:heal" / "R:dps" / "R:?" = mon rôle ; "Q" = « annoncez-moi vos rôles »

local PREFIXE = "GuildUp"
local dernierEnvoi, envoiPrevu, dernierRoleAnnonce = 0, false, nil

local function Envoyer(msg) ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end

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

-- barre de nom d'un joueur (GuildUp_Plaques.lua, chargé après ce fichier)
local function MajJoueur(cle) if ns.Plaques then ns.Plaques.MajJoueur(cle) end end

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
		local nouveau = ROLE_VALIDE[role] and role or nil
		if rolesConnus[expediteur] ~= nouveau then
			rolesConnus[expediteur] = nouveau
			MajJoueur(expediteur)
		end
	end
end

--------------------------------------------------------------------------------
-- Évènements (les barres de nom ont les leurs : GuildUp_Plaques.lua)
--------------------------------------------------------------------------------

local premiereEntree = true
local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(self, event, arg1)
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
		-- rôles annoncés par les autres membres (canal de guilde seulement)
		ns.Ecouter(PREFIXE, function(prefixe, msg, _, expediteur) Recevoir(prefixe, msg, expediteur) end)
		for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE", "PLAYER_ROLES_ASSIGNED",
			"PLAYER_SPECIALIZATION_CHANGED", "ACTIVE_TALENT_GROUP_CHANGED" }) do
			pcall(self.RegisterEvent, self, e) -- certains évènements peuvent ne pas exister sur ce client
		end
		if ns.ActiverPlaques then ns.ActiverPlaques() end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if premiereEntree then
			premiereEntree = false
			-- on laisse le temps à la guilde de se charger, puis on demande les rôles et on annonce le nôtre
			C_Timer.After(8, function()
				Envoyer("Q")
				Annoncer(true)
			end)
		end
	else
		-- groupe, rôles, spécialisation : mon rôle a peut-être changé
		Annoncer(false)
	end
end)

-- Partagé avec GuildUp_Plaques.lua, GuildUp_MiniCarte.lua et GuildUp_Options.lua (chargés après)
ns.Coeur = {
	DEFAUT = DEFAUT, rolesConnus = rolesConnus, LireCVarJeu = LireCVarJeu, LireCVar = LireCVar,
	Message = Message, Erreur = Erreur, SonsSurBoutons = SonsSurBoutons, NomComplet = NomComplet,
	EstDeMaGuilde = EstDeMaGuilde, Etat = Etat, MonRole = MonRole, RoleManuel = RoleManuel,
	PoserRoleManuel = PoserRoleManuel, Annoncer = Annoncer,
}
