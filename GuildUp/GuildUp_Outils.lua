-- GuildUp : outils communs à tous les modules (chargé juste après GuildUp.lua, voir le .toc).
-- Une seule version de chaque petite fonction : noms, recherche sans accents, atlas, objets, dates,
-- couleurs de classe, menus déroulants, case où déposer un objet, fenêtre déplaçable.
-- Les modules les reprennent en local en tête de fichier (local NomCourt = ns.NomCourt).
-- (ns.Normaliser, ns.TestSolo et ns.Erreur sont dans GuildUp.lua ; le réseau dans GuildUp_Reseau.lua.)

local NOM_ADDON, ns = ...

--------------------------------------------------------------------------------
-- Joueurs et temps
--------------------------------------------------------------------------------

-- Heure du serveur (secondes) : la même pour tous les membres, contrairement à l'horloge du PC
ns.Maintenant = function() return GetServerTime and GetServerTime() or time() end

-- Ma clé de joueur « Nom-Royaume » (voir ns.Normaliser)
ns.MaCle = function() return ns.Normaliser(UnitName("player")) end

-- Nom affiché : « Prénom Famille » (« Miko-Banko » devient « Miko Banko »), sans les marques du
-- mode test (« #test », « (test) »)
ns.NomCourt = function(nom)
	return ((nom or "?"):gsub("#test$", ""):gsub(" %(test%)$", ""):gsub("%-", " "))
end

-- Durée écoulée depuis une date (heure du serveur) : « 5 min », « 3 h », « 2 j »
ns.Depuis = function(t)
	local s = math.max(0, ns.Maintenant() - (t or ns.Maintenant()))
	if s < 3600 then return math.max(1, math.floor(s / 60)) .. " min" end
	if s < 86400 then return math.floor(s / 3600) .. " h" end
	return math.floor(s / 86400) .. " j"
end

--------------------------------------------------------------------------------
-- Textes
--------------------------------------------------------------------------------

local ACCENTS = {
	["à"] = "a", ["â"] = "a", ["ä"] = "a", ["ç"] = "c", ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e",
	["î"] = "i", ["ï"] = "i", ["ô"] = "o", ["ö"] = "o", ["ù"] = "u", ["û"] = "u", ["ü"] = "u",
	["À"] = "a", ["Â"] = "a", ["Ä"] = "a", ["Ç"] = "c", ["É"] = "e", ["È"] = "e", ["Ê"] = "e", ["Ë"] = "e",
	["Î"] = "i", ["Ï"] = "i", ["Ô"] = "o", ["Ö"] = "o", ["Ù"] = "u", ["Û"] = "u", ["Ü"] = "u",
	["œ"] = "oe", ["Œ"] = "oe",
}
-- Texte pour une recherche : sans accents, sans apostrophes, en minuscules (« Œuf » -> « oeuf »)
ns.Simplifier = function(s)
	return ((s or ""):gsub("[\195\197][\128-\191]", ACCENTS):gsub("’", " "):gsub("'", " "):lower())
end

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

-- Nombre en base 36 (identifiants compacts dans les messages d'addon)
local CHIFFRES = "0123456789abcdefghijklmnopqrstuvwxyz"
ns.Base36 = function(n)
	n = math.floor(n or 0)
	if n <= 0 then return "0" end
	local s = ""
	while n > 0 do
		local r = n % 36
		s = CHIFFRES:sub(r + 1, r + 1) .. s
		n = math.floor(n / 36)
	end
	return s
end

-- Couleur de classe : r, g, b (or si inconnue) ; ou préfixe de texte « |cAARRGGBB » (blanc si inconnue)
ns.CouleurClasse = function(classe)
	local c = classe and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classe]
	if c then return c.r, c.g, c.b end
	return 1, 0.82, 0
end
ns.CouleurClasseTexte = function(classe)
	local c = classe and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classe]
	if c and c.colorStr then return "|c" .. c.colorStr end
	return "|cffffffff"
end

ns.NOMS_ROLES = { tank = "|cff3399ffTank|r", heal = "|cff33dd55Heal|r", dps = "|cffff4444DPS|r" }

--------------------------------------------------------------------------------
-- Objets
--------------------------------------------------------------------------------

-- nom, lien, qualité, icône, niveau minimum (nil tant que le jeu n'a pas les données de l'objet ;
-- l'icône est connue tout de suite)
ns.InfoObjet = function(objet)
	local f = GetItemInfo or (C_Item and C_Item.GetItemInfo)
	local nom, lien, qualite, icone, niveau
	if f then
		local ok, n, l, q, _, nmin, _, _, _, _, ic = pcall(f, objet)
		if ok then nom, lien, qualite, niveau, icone = n, l, q, nmin, ic end
	end
	if not icone then
		local fi = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
		if fi then
			local ok, ic = pcall(fi, objet)
			if ok then icone = ic end
		end
	end
	if not icone then
		local fi = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
		if fi then
			local ok, _, _, _, _, ic = pcall(fi, objet)
			if ok then icone = ic end
		end
	end
	return nom, lien, qualite, icone, niveau
end

-- Demande au jeu les données d'un objet (GET_ITEM_INFO_RECEIVED suit)
ns.Precharger = function(objet)
	if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, objet) end
end

--------------------------------------------------------------------------------
-- Interface
--------------------------------------------------------------------------------

ns.AtlasExiste = function(nom)
	if not (nom and C_Texture and C_Texture.GetAtlasInfo) then return false end
	local ok, info = pcall(C_Texture.GetAtlasInfo, nom)
	return ok and info ~= nil
end

-- Pose un atlas du jeu s'il existe, sinon une couleur unie de secours ; true si l'atlas est posé
ns.PoserAtlas = function(tex, atlas, couleur)
	tex:SetTexCoord(0, 1, 0, 1)
	if ns.AtlasExiste(atlas) then
		tex:SetAtlas(atlas)
		return true
	end
	if couleur then tex:SetColorTexture(unpack(couleur)) end
	return false
end

-- Menu déroulant (cadre sombre, se ferme quand la souris s'en éloigne, Échap le ferme)
ns.CadreMenu = function(nom)
	local m = CreateFrame("Frame", nom, UIParent, "BackdropTemplate")
	m:SetFrameStrata("FULLSCREEN_DIALOG")
	m:SetClampedToScreen(true)
	if m.SetBackdrop then
		m:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
			insets = { left = 3, right = 3, top = 3, bottom = 3 } })
		m:SetBackdropColor(0.05, 0.05, 0.05, 0.97)
	end
	m.boutons = {}
	m:SetScript("OnUpdate", function(self)
		if not self:IsMouseOver(20, -20, -20, 20) and not (self.ancre and self.ancre:IsMouseOver()) then self:Hide() end
	end)
	if nom then tinsert(UISpecialFrames, nom) end
	return m
end
-- i-ème ligne d'un menu (créée au besoin, réutilisée ensuite)
ns.BoutonMenu = function(m, i)
	local b = m.boutons[i]
	if not b then
		b = CreateFrame("Button", nil, m)
		b:SetHeight(20)
		b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.texte:SetPoint("LEFT", b, "LEFT", 8, 0)
		m.boutons[i] = b
	end
	return b
end

-- Case où déposer un objet : glisser un objet dessus (ou cliquer avec un objet sur le curseur) le
-- choisit ; clic droit (ou clic sans objet) vide la case.
--   choisir(objet ou nil) ; actuel() = objet choisi en ce moment (ou nil)
ns.BrancherDepot = function(cibles, choisir, actuel)
	local function Deposer()
		local genre, objet = GetCursorInfo()
		if genre == "item" and objet then
			choisir(tonumber(objet))
			ClearCursor()
			return true
		end
	end
	for _, cible in ipairs(cibles) do
		cible:SetScript("OnReceiveDrag", Deposer)
		cible:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		cible:SetScript("OnClick", function(_, bouton)
			-- clic droit : retire l'objet de la case ; clic gauche : dépose l'objet tenu (ou vide la case)
			if bouton == "RightButton" then
				if actuel() then choisir(nil) end
				GameTooltip:Hide()
				return
			end
			if not Deposer() and actuel() then choisir(nil) end
		end)
	end
end

-- Fenêtre simple déplaçable (modèle du jeu, ou cadre de dialogue si le modèle n'existe pas),
-- au centre, fermée par Échap
ns.FenetreDeplacable = function(nom, largeur, hauteur)
	local ok, f = pcall(CreateFrame, "Frame", nom, UIParent, "BasicFrameTemplateWithInset")
	if not ok then
		f = CreateFrame("Frame", nom, UIParent, "BackdropTemplate")
		if f.SetBackdrop then
			f:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
				tile = true, tileSize = 32, edgeSize = 32,
				insets = { left = 11, right = 12, top = 12, bottom = 11 },
			})
		end
		local fermer = CreateFrame("Button", nil, f, "UIPanelCloseButton")
		fermer:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -4)
	end
	f:SetSize(largeur, hauteur)
	f:SetPoint("CENTER")
	f:SetFrameStrata("DIALOG")
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	if nom then tinsert(UISpecialFrames, nom) end
	return f
end
