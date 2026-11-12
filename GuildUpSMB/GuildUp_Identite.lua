-- GuildUpSMB : pseudo commun à tous ses personnages, et personnage principal / secondaires.
--
-- Affichage : « Pseudo (Prénom) » partout où l'addon montre un membre (ns.NomJoueur, GuildUp_Outils.lua) ;
-- le prénom en jeu reste visible pour ne pas confondre deux membres au même pseudo. Pour chuchoter, inviter,
-- envoyer un courrier ou comparer, on garde toujours le vrai nom en jeu.
--
-- GuildUpDB est commun au compte : chaque personnage connecté s'y note (db.mesPersos), le joueur
-- choisit son pseudo (db.pseudo) et son principal (db.persoPrincipal). Synchro (préfixe GuildUpId) :
--   I~pseudo~principal~perso1,perso2,…     mon identité          Q    « envoyez-moi les vôtres »
--
-- Profil : pseudo, personnage principal et rôle choisi à la main (Tank / Heal / DPS, par personnage).
-- Une seule validation du pseudo (ns.PoserPseudo, aussi pour la page Options) et du principal
-- (ns.PoserPrincipal, aussi pour le menu « Persos »). ns.ProfilComplet() / ns.ManquesProfil() :
-- l'alerte « Profil incomplet » du bandeau de la fenêtre SMB Forever (GuildUp_Interface.lua).
-- Fenêtre « Complète ton profil » (ns.OuvrirProfil, kit ns.UI) : pseudo, principal, rôle ; elle
-- s'ouvre seule à la première ouverture de la fenêtre SMB Forever de la session si le profil est
-- incomplet. Rien n'est enregistré avant « Enregistrer ».

local NOM_ADDON, ns = ...
local PREFIXE = "GuildUpId"

local function DB() return ns.DB and ns.DB() end
local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local TestSolo = ns.TestSolo
local NomCourt = ns.NomCourt
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local function Propre(t) return strtrim(((t or ""):gsub("[~|,\n]", ""))) end

--------------------------------------------------------------------------------
-- Mes personnages (dans ma guilde actuelle)
--------------------------------------------------------------------------------

-- Purge à la connexion : identités sans nouvelles depuis 90 jours, mes personnages non connectés
-- depuis un an (supprimés ou abandonnés)
local function Purger()
	local db = DB()
	if not db then return end
	local maintenant = time()
	if type(db.identites) == "table" then
		for cle, id in pairs(db.identites) do
			if type(id) ~= "table" or maintenant - (id.maj or 0) > 90 * 86400 then db.identites[cle] = nil end
		end
	end
	if type(db.mesPersos) == "table" then
		for cle, p in pairs(db.mesPersos) do
			if type(p) ~= "table" or maintenant - (p.vu or 0) > 365 * 86400 then db.mesPersos[cle] = nil end
		end
	end
end

local function NoterMonPerso()
	local db = DB()
	if not db then return end
	if type(db.mesPersos) ~= "table" then db.mesPersos = {} end
	local guilde = IsInGuild() and GetGuildInfo("player") or nil
	local _, classe = UnitClass("player")
	local p = db.mesPersos[MaCle()] or {}
	p.guilde = guilde or p.guilde
	p.classe, p.niveau, p.vu = classe, UnitLevel("player"), time()
	db.mesPersos[MaCle()] = p
end

-- mes personnages de la même guilde que celui-ci, le principal d'abord
local function MesPersos()
	local db = DB() or {}
	local l = {}
	local guilde = IsInGuild() and GetGuildInfo("player") or (db.mesPersos and db.mesPersos[MaCle()] and db.mesPersos[MaCle()].guilde)
	for cle, p in pairs(db.mesPersos or {}) do
		if cle == MaCle() or (guilde and p.guilde == guilde) then l[#l + 1] = cle end
	end
	table.sort(l, function(a, b)
		if a == db.persoPrincipal then return true end
		if b == db.persoPrincipal then return false end
		return a < b
	end)
	return l
end
ns.MesPersos = MesPersos

local function MonIdentite()
	local db = DB() or {}
	local persos = MesPersos()
	local principal = db.persoPrincipal
	local ok = false
	for _, c in ipairs(persos) do if c == principal then ok = true end end
	return { pseudo = db.pseudo, principal = ok and principal or nil, persos = persos }
end

--------------------------------------------------------------------------------
-- Identités des autres : db.identites[emetteur] = { pseudo, principal, persos, maj }
--------------------------------------------------------------------------------

local index -- [cle d'un perso] = identité
local function Index()
	if index then return index end
	index = {}
	local db = DB() or {}
	for emetteur, id in pairs(db.identites or {}) do
		index[emetteur] = id
		for _, c in ipairs(id.persos or {}) do index[c] = id end
	end
	return index
end

-- identité d'un joueur (clé ou nom), ou nil
local function Identite(nom)
	if not nom then return nil end
	local cle = Normaliser(((nom:gsub(" %(test%)$", "")):gsub("#test$", "")))
	if not cle then return nil end
	local db = DB() or {}
	if cle == MaCle() or (db.mesPersos and db.mesPersos[cle]) then return MonIdentite() end
	return Index()[cle]
end
ns.Identite = Identite

-- lignes à ajouter dans une infobulle qui parle d'un joueur : pseudo et ses personnages
ns.LignesIdentite = function(tt, nom)
	local id = Identite(nom)
	if not tt or not id then return end
	local persos = id.persos or {}
	if not (id.pseudo and id.pseudo ~= "") and #persos < 2 then return end
	if id.pseudo and id.pseudo ~= "" then
		tt:AddLine("|cffffd100Pseudo :|r " .. id.pseudo, 1, 1, 1)
	end
	if #persos >= 2 then
		local noms = {}
		for _, c in ipairs(persos) do
			noms[#noms + 1] = NomCourt(c) .. (c == id.principal and " |cffffd100(principal)|r" or "")
		end
		tt:AddLine("|cffffd100Personnages :|r " .. table.concat(noms, ", "), 1, 1, 1, true)
	end
end

--------------------------------------------------------------------------------
-- Synchro
--------------------------------------------------------------------------------

local pret, dernierEnvoi = false, 0
local function EnvoyerMoi()
	local id = MonIdentite()
	if not (id.pseudo and id.pseudo ~= "") and #id.persos < 2 then return end -- rien à dire
	local pseudo = Propre(id.pseudo)
	if ns.CouperUTF8 then pseudo = ns.CouperUTF8(pseudo, 48) end
	local entete = ("I~%s~%s~"):format(pseudo, id.principal or "")
	-- la liste des personnages remplit ce qui reste des 255 octets après l'en-tête
	local budget = (ns.LONGUEUR_MAX or 255) - #entete
	local persos = {}
	local long = 0
	for _, c in ipairs(id.persos) do
		local ajout = #c + (long > 0 and 1 or 0)
		if long + ajout > budget then break end
		persos[#persos + 1] = c
		long = long + ajout
	end
	dernierEnvoi = GetTime()
	Envoyer(entete .. table.concat(persos, ","))
end
ns.AnnoncerIdentite = function()
	NoterMonPerso()
	if pret then EnvoyerMoi() end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if cle == MaCle() and not TestSolo() then return end
	if msg == "Q" then
		if pret and GetTime() - dernierEnvoi > 20 then
			dernierEnvoi = GetTime()
			C_Timer.After(1 + math.random() * 5, EnvoyerMoi)
		end
		return
	end
	local pseudo, principal, persos = msg:match("^I~([^~]*)~([^~]*)~(.*)$")
	if not pseudo then return end
	local db = DB()
	if not db then return end
	if type(db.identites) ~= "table" then db.identites = {} end
	-- textes bornés (affichés dans les infobulles)
	pseudo = ns.CouperUTF8(pseudo, 48)
	principal = ns.CouperUTF8(principal, 64)
	local l = {}
	for c in persos:gmatch("[^,]+") do
		if #l < 20 then l[#l + 1] = ns.CouperUTF8(c, 64) end
	end
	if #l == 0 then l[1] = cle end
	db.identites[cle] = { pseudo = pseudo ~= "" and pseudo or nil, principal = principal ~= "" and principal or nil,
		persos = l, maj = time() }
	-- l'expéditeur ne peut appartenir qu'à une identité : on le retire des autres (il ne peut pas
	-- retirer les personnages d'un autre membre)
	for autre, id in pairs(db.identites) do
		if autre ~= cle then
			for i = #(id.persos or {}), 1, -1 do
				if id.persos[i] == cle then table.remove(id.persos, i) end
			end
		end
	end
	index = nil
	if ns.MajMembres then ns.MajMembres() end
end

--------------------------------------------------------------------------------
-- Infobulles : joueurs survolés dans le monde (membres de la guilde)
--------------------------------------------------------------------------------

local function BulleUnite(tt)
	if tt ~= GameTooltip then return end
	local ok, _, unite = pcall(tt.GetUnit, tt)
	if not ok or not unite or not UnitIsPlayer(unite) then return end
	local okN, nom, famille = pcall(UnitFullName, unite)
	if not okN or not nom then return end
	ns.LignesIdentite(tt, famille and famille ~= "" and (nom .. "-" .. famille) or nom)
end
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tt) pcall(BulleUnite, tt) end)
elseif GameTooltip and GameTooltip.HookScript then
	pcall(GameTooltip.HookScript, GameTooltip, "OnTooltipSetUnit", function(self) pcall(BulleUnite, self) end)
end

--------------------------------------------------------------------------------
-- Menu « Persos » du volet : choisir son personnage principal
--------------------------------------------------------------------------------

local menu
ns.MenuPersos = function(ancre)
	if not menu then
		menu = CreateFrame("Frame", "GuildUpMenuPersos", UIParent, "BackdropTemplate")
		menu:SetFrameStrata("FULLSCREEN_DIALOG")
		menu:SetClampedToScreen(true)
		if menu.SetBackdrop then
			menu:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
				insets = { left = 3, right = 3, top = 3, bottom = 3 } })
			menu:SetBackdropColor(0.05, 0.05, 0.05, 0.97)
		end
		menu.boutons = {}
		menu.titre = menu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		menu.titre:SetPoint("TOPLEFT", menu, "TOPLEFT", 8, -8)
		menu.titre:SetText("Mon personnage principal")
		menu.aide = menu:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		menu.aide:SetJustifyH("LEFT")
		menu:SetScript("OnUpdate", function(self)
			if not self:IsMouseOver(20, -20, -20, 20) and not (self.ancre and self.ancre:IsMouseOver()) then self:Hide() end
		end)
		tinsert(UISpecialFrames, "GuildUpMenuPersos")
	end
	NoterMonPerso()
	local db = DB() or {}
	local persos = MesPersos()
	for i, c in ipairs(persos) do
		local b = menu.boutons[i]
		if not b then
			b = CreateFrame("Button", nil, menu)
			b:SetHeight(20)
			b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			b.texte:SetPoint("LEFT", b, "LEFT", 8, 0)
			menu.boutons[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", menu, "TOPLEFT", 4, -26 - (i - 1) * 20)
		b:SetPoint("RIGHT", menu, "RIGHT", -4, 0)
		local p = db.mesPersos and db.mesPersos[c] or {}
		local couleur = p.classe and RAID_CLASS_COLORS and RAID_CLASS_COLORS[p.classe]
		local principal = c == db.persoPrincipal
		b.texte:SetText((principal and "|TInterface\\Buttons\\UI-CheckBox-Check:14:14:0:0|t " or "      ")
			.. (couleur and ("|c" .. (couleur.colorStr or "ffffffff")) or "|cffffffff") .. NomCourt(c) .. "|r"
			.. (p.niveau and ("  |cff999999niv. " .. p.niveau .. "|r") or "") .. (c == MaCle() and "  |cff999999(connecté)|r" or ""))
		b:SetScript("OnClick", function()
			-- re-clic sur le principal : plus de principal
			ns.PoserPrincipal((db.persoPrincipal ~= c) and c or nil)
			ns.MenuPersos(ancre)
		end)
		b:Show()
	end
	for i = #persos + 1, #menu.boutons do menu.boutons[i]:Hide() end
	menu.aide:ClearAllPoints()
	menu.aide:SetPoint("TOPLEFT", menu, "TOPLEFT", 8, -30 - #persos * 20)
	menu.aide:SetWidth(204)
	menu.aide:SetText("Tes personnages de cette guilde apparaissent ici dès que tu t'y connectes avec SMB Forever. La guilde les voit au survol de ton nom.")
	menu:SetSize(220, 40 + #persos * 20 + menu.aide:GetStringHeight())
	menu.ancre = ancre
	menu:ClearAllPoints()
	menu:SetPoint("TOPLEFT", ancre, "BOTTOMLEFT", 0, -2)
	menu:Show()
end

--------------------------------------------------------------------------------
-- Profil : pseudo, personnage principal, rôle
--------------------------------------------------------------------------------

local LETTRES_PSEUDO = 16
ns.LETTRES_PSEUDO = LETTRES_PSEUDO

-- le profil a changé : alerte du bandeau, page Guilde
local function ProfilChange()
	if ns.MajInterface then ns.MajInterface() end
	if ns.MajMembres then ns.MajMembres() end
end

-- Pseudo saisi (page Options, fenêtre « Complète ton profil ») : sans ~ | , ni retour à la ligne,
-- 16 lettres au plus ; vide = pas de pseudo. Renvoie le pseudo retenu (ou nil) et vrai s'il a changé.
-- Annoncé à la guilde s'il change, sauf avec differer (l'appelant annonce une seule fois pour tout).
ns.PoserPseudo = function(texte, differer)
	local db = DB()
	if not db then return nil, false end
	local t = strtrim(((texte or ""):gsub("[~|,\r\n]", "")))
	t = strtrim(ns.CouperUTF8(t, nil, LETTRES_PSEUDO))
	local nouveau = (t ~= "") and t or nil
	if nouveau == db.pseudo then return nouveau, false end
	db.pseudo = nouveau
	if not differer then ns.AnnoncerIdentite() end
	ProfilChange()
	return nouveau, true
end

-- Personnage principal (un de mes personnages de cette guilde, ou nil = aucun). Renvoie vrai s'il a
-- changé ; annoncé à la guilde, sauf avec differer.
ns.PoserPrincipal = function(cle, differer)
	local db = DB()
	if not db then return false end
	if cle then
		local connu = false
		for _, c in ipairs(MesPersos()) do if c == cle then connu = true end end
		if not connu then return false end
	end
	if db.persoPrincipal == cle then return false end
	db.persoPrincipal = cle
	if not differer then ns.AnnoncerIdentite() end
	ProfilChange()
	return true
end

local ROLE_VALIDE = { tank = true, heal = true, dps = true }
local function RoleALaMain()
	local r = ns.RoleChoisiALaMain and ns.RoleChoisiALaMain()
	return ROLE_VALIDE[r] and r or nil
end

-- Ce qui manque au profil (textes pour l'infobulle de l'alerte), liste vide s'il est complet
ns.ManquesProfil = function()
	local db = DB()
	local m = {}
	if not db then return m end
	if not (db.pseudo and db.pseudo ~= "") then m[#m + 1] = "ton pseudo" end
	if not MonIdentite().principal then m[#m + 1] = "ton personnage principal" end
	if not RoleALaMain() then m[#m + 1] = "ton rôle (Tank, Heal ou DPS) sur ce personnage" end
	return m
end
-- Profil complet : pseudo, principal et rôle choisi à la main (pas « Auto ») ; vrai tant que la
-- base n'est pas chargée (rien à signaler)
ns.ProfilComplet = function()
	if not DB() then return true end
	return #ns.ManquesProfil() == 0
end

-- Fenêtre « Complète ton profil »
local LARGEUR_PROFIL, HAUTEUR_PROFIL, HAUTEUR_TETE_PROFIL = 470, 396, 52
local X_CHAMP = 170 -- colonne des champs (les libellés sont à gauche)
local ROLES_PROFIL = { "tank", "heal", "dps" }
local fenProfil

local function CreerProfil()
	local UI = ns.UI
	local C = UI.C
	local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\"
	local f = CreateFrame("Frame", "GuildUpProfil", UIParent, "BackdropTemplate")
	UI.Habiller(f, C.fond, { C.orFonce[1], C.orFonce[2], C.orFonce[3], 1 })
	f:SetSize(LARGEUR_PROFIL, HAUTEUR_PROFIL)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
	f:SetFrameStrata("DIALOG") -- au-dessus de la fenêtre SMB Forever (HIGH)
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:Hide()
	tinsert(UISpecialFrames, "GuildUpProfil") -- Échap ferme
	f:SetScript("OnShow", function() if ns.Son then ns.Son("IG_MAINMENU_OPEN") end end)
	f:SetScript("OnHide", function() if ns.Son then ns.Son("IG_MAINMENU_CLOSE") end end)

	-- bandeau : emblème, titre, sous-titre, fermeture ; on le glisse pour déplacer
	local tete = UI.Cadre(f, C.bandeau)
	tete:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
	tete:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
	tete:SetHeight(HAUTEUR_TETE_PROFIL)
	tete:EnableMouse(true)
	tete:RegisterForDrag("LeftButton")
	tete:SetScript("OnDragStart", function() f:StartMoving() end)
	tete:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
	local filet = UI.Filet(tete)
	filet:SetPoint("BOTTOMLEFT", tete, "BOTTOMLEFT", 0, 0)
	filet:SetPoint("BOTTOMRIGHT", tete, "BOTTOMRIGHT", 0, 0)
	local embleme = tete:CreateTexture(nil, "ARTWORK")
	embleme:SetTexture(MEDIA .. "gu_emote")
	embleme:SetSize(36, 36)
	embleme:SetPoint("LEFT", tete, "LEFT", 12, 0)
	local titre = UI.Texte(tete, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", embleme, "TOPRIGHT", 10, -2)
	titre:SetText("Complète ton profil")
	local sousTitre = UI.Texte(tete, "GameFontHighlightSmall", C.gris)
	sousTitre:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -3)
	sousTitre:SetText("Pour que la guilde sache qui tu es")
	local fermer = UI.Fermer(tete, function() f:Hide() end, 26)
	fermer:SetPoint("RIGHT", tete, "RIGHT", -10, 0)

	-- explication
	local expl = UI.Texte(f, "GameFontHighlight", C.texte)
	expl:SetPoint("TOPLEFT", tete, "BOTTOMLEFT", 15, -14)
	expl:SetWidth(LARGEUR_PROFIL - 32)
	expl:SetWordWrap(true)
	expl:SetSpacing(2)
	expl:SetText("La guilde voit ton |cfff1cf6bpseudo|r et ton |cfff1cf6bpersonnage principal|r au survol de ton nom. "
		.. "Ton |cfff1cf6brôle|r sert aux groupes et aux bannières derrière ton nom.")

	-- une ligne : libellé (et précision grisée en dessous) à gauche, champ à droite
	local function Libelle(y, texte, precision)
		local t = UI.Texte(f, "GameFontNormal", C.ors)
		t:SetPoint("TOPLEFT", f, "TOPLEFT", 16, y)
		t:SetText(texte)
		local p = UI.Texte(f, "GameFontHighlightSmall", C.gris)
		p:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, -3)
		p:SetWidth(X_CHAMP - 26)
		p:SetWordWrap(true)
		p:SetText(precision or "")
		return t, p
	end
	local largeurChamp = LARGEUR_PROFIL - X_CHAMP - 16

	-- pseudo
	Libelle(-124, "Pseudo", "Ton nom habituel, commun à tes persos")
	f.pseudo = UI.Champ(f, largeurChamp, "Par exemple « Miko »")
	f.pseudo:SetPoint("TOPLEFT", f, "TOPLEFT", X_CHAMP, -118)
	f.pseudo.saisie:SetMaxLetters(LETTRES_PSEUDO)

	-- personnage principal
	Libelle(-180, "Personnage principal", "Parmi tes persos de cette guilde")
	f.principal = UI.Choix(f, largeurChamp, {}, function(v)
		f.choixPrincipal = v
		if f.MajEtat then f.MajEtat() end
	end)
	f.principal:SetPoint("TOPLEFT", f, "TOPLEFT", X_CHAMP, -174)

	-- rôle (du personnage connecté)
	local _, precisionRole = Libelle(-236, "Rôle principal", "")
	f.precisionRole = precisionRole
	local noms = {}
	for i, r in ipairs(ROLES_PROFIL) do noms[i] = UI.TexteRole(r) end
	f.roles = UI.Puces(f, noms, function(i)
		f.choixRole = ROLES_PROFIL[i]
		f.roles:Choisir(i)
		if f.MajEtat then f.MajEtat() end
	end)
	f.roles:SetPoint("TOPLEFT", f, "TOPLEFT", X_CHAMP, -231)

	-- ce qui manque encore (d'après les choix en cours)
	f.etat = UI.Texte(f, "GameFontHighlightSmall", C.aide)
	f.etat:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -292)
	f.etat:SetWidth(LARGEUR_PROFIL - 32)
	f.etat:SetWordWrap(true)

	-- pied : filet, « Plus tard » et « Enregistrer »
	local filetBas = UI.Filet(f)
	filetBas:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 50)
	filetBas:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 50)
	f.enregistrer = UI.Bouton(f, "Enregistrer", "or", 130, 28)
	f.enregistrer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 12)
	f.plusTard = UI.Bouton(f, "Plus tard", "fantome", 110, 28)
	f.plusTard:SetPoint("RIGHT", f.enregistrer, "LEFT", -10, 0)
	f.plusTard:SetScript("OnClick", function() f:Hide() end)
	UI.Infobulle(f.plusTard, "Plus tard", "Ferme sans rien changer. L'alerte « Profil incomplet » du bandeau rouvre cette fenêtre.")

	f.MajEtat = function()
		local manque = {}
		local pseudo = strtrim(((f.pseudo:Lire() or ""):gsub("[~|,\r\n]", "")))
		if pseudo == "" then manque[#manque + 1] = "ton pseudo" end
		if not f.choixPrincipal then manque[#manque + 1] = "ton personnage principal" end
		if not f.choixRole then manque[#manque + 1] = "ton rôle" end
		if #manque == 0 then
			f.etat:SetTextColor(unpack(C.vert))
			f.etat:SetText("Tout est rempli : clique sur « Enregistrer ».")
		else
			f.etat:SetTextColor(unpack(C.aide))
			f.etat:SetText("Il manque encore " .. table.concat(manque, ", ") .. ".")
		end
	end
	f.pseudo.SurTexte = function() f.MajEtat() end

	f.enregistrer:SetScript("OnClick", function()
		local _, pseudoChange = ns.PoserPseudo(f.pseudo:Lire(), true)
		local principalChange = f.choixPrincipal and ns.PoserPrincipal(f.choixPrincipal, true) or false
		if pseudoChange or principalChange then ns.AnnoncerIdentite() end
		-- (ChoisirRole bascule en « Auto » si on redonne le rôle déjà choisi : seulement s'il change)
		if f.choixRole and RoleALaMain() ~= f.choixRole and ns.ChoisirRole then ns.ChoisirRole(f.choixRole) end
		f:Hide()
		ProfilChange()
	end)
	return f
end

-- Remplit la fenêtre avec le profil enregistré
local function RemplirProfil(f)
	local db = DB() or {}
	NoterMonPerso()
	f.pseudo:Ecrire(db.pseudo or "")
	-- mes personnages de cette guilde : nom à la couleur de la classe, niveau, « connecté »
	local options = {}
	local persos = MesPersos()
	for _, c in ipairs(persos) do
		local p = db.mesPersos and db.mesPersos[c] or {}
		local couleur = ns.CouleurClasseTexte and ns.CouleurClasseTexte(p.classe) or "|cffffffff"
		options[#options + 1] = { c, couleur .. NomCourt(c) .. "|r"
			.. (p.niveau and ("  |cff9c9380niv. " .. p.niveau .. "|r") or "")
			.. (c == MaCle() and "  |cff9c9380(connecté)|r" or "") }
	end
	f.principal.options = options
	f.choixPrincipal = MonIdentite().principal or (#persos == 1 and persos[1]) or nil
	if f.choixPrincipal then
		f.principal:Poser(f.choixPrincipal)
	else
		f.principal.valeur = nil
		f.principal.texte:SetText("|cff9c9380Choisir…|r")
	end
	f.choixRole = RoleALaMain()
	local index = 0
	for i, r in ipairs(ROLES_PROFIL) do if r == f.choixRole then index = i end end
	f.roles:Choisir(index)
	local _, classe = UnitClass("player")
	f.precisionRole:SetText("Pour " .. (ns.CouleurClasseTexte and ns.CouleurClasseTexte(classe) or "")
		.. NomCourt(MaCle()) .. "|r (chaque perso a le sien)")
	f.MajEtat()
	f.pseudo.saisie:ClearFocus()
end

ns.OuvrirProfil = function()
	if not (DB() and ns.UI) then return end
	if not fenProfil then fenProfil = CreerProfil() end
	RemplirProfil(fenProfil)
	-- même taille que la fenêtre SMB Forever (/smb taille)
	if ns.EchelleInterface then fenProfil:SetScale(ns.EchelleInterface() or 1) end
	fenProfil:Show()
	fenProfil:Raise()
end

ns.DiagIdentite = function(L)
	local db = DB() or {}
	local n = 0
	for _ in pairs(db.identites or {}) do n = n + 1 end
	L(("identité : pseudo %s, %d perso(s), %d membre(s) connus"):format(db.pseudo or "—", #MesPersos(), n))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_GUILD_UPDATE", "PLAYER_LEVEL_UP" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local premiere = true
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		C_Timer.After(15, function()
			pcall(Purger)
			NoterMonPerso()
			pret = true
			EnvoyerMoi()
			Envoyer("Q")
		end)
	elseif event == "PLAYER_GUILD_UPDATE" or event == "PLAYER_LEVEL_UP" then
		NoterMonPerso()
	end
end)
