-- GuildUpSMB : kit d'interface de la fenêtre GuildUpSMB (style sombre et doré des maquettes).
-- Tous les éléments graphiques des pages viennent d'ici (ns.UI) : couleurs, cadres plats, textes,
-- boutons (or, fantôme, aide, alerte avec icône), pastilles, cartes, rangées, onglets soulignés, puces de filtre, liste
-- défilante, champ de saisie, case à cocher, liste de choix, curseur, places par rôle, portrait de joueur.
-- Les pages ne créent pas de modèle du jeu (UIPanelButtonTemplate…) : elles passent par ces fonctions,
-- pour garder une seule apparence. Aucun message réseau.

local NOM_ADDON, ns = ...
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\"

local UI = {}
ns.UI = UI

local BLANC = "Interface\\Buttons\\WHITE8X8"
local ROND = MEDIA .. "point"     -- disque blanc de l'addon, teinté
local ANNEAU = MEDIA .. "anneau"  -- anneau blanc (Miko), teinté
UI.ROND, UI.ANNEAU = ROND, ANNEAU

UI.C = {
	fond      = { 0.082, 0.071, 0.055, 0.97 },
	bandeau   = { 0.067, 0.055, 0.043, 1 },
	menu      = { 0.071, 0.059, 0.047, 1 },
	carte     = { 0.114, 0.098, 0.078, 1 },
	champ     = { 0.067, 0.055, 0.043, 1 },
	bord      = { 0.227, 0.192, 0.141, 1 },
	bordMoyen = { 0.35, 0.29, 0.17, 1 },
	bordFort  = { 0.42, 0.33, 0.19, 1 },
	actif     = { 0.165, 0.133, 0.086, 1 },
	ors       = { 0.945, 0.81, 0.42 },
	orFonce   = { 0.85, 0.66, 0.25 },
	texte     = { 0.91, 0.886, 0.83 },
	gris      = { 0.61, 0.576, 0.5 },
	rouge     = { 0.75, 0.2, 0.15 },
	vert      = { 0.44, 0.82, 0.55 },
	aide      = { 1, 0.7, 0.62 },
	fondAide  = { 0.227, 0.098, 0.071, 1 },
	bordAide  = { 0.66, 0.27, 0.18, 1 },
}
local C = UI.C

-- couleurs des rôles : pleine (place prise, bouton actif) et claire (texte)
UI.ROLES = {
	tank = { nom = "Tank", plein = { 0.18, 0.44, 0.7 }, clair = { 0.42, 0.65, 0.9 } },
	heal = { nom = "Heal", plein = { 0.17, 0.48, 0.25 }, clair = { 0.44, 0.82, 0.55 } },
	dps  = { nom = "DPS",  plein = { 0.64, 0.23, 0.19 }, clair = { 0.93, 0.5, 0.46 } },
}
UI.ORDRE_ROLES = { "tank", "heal", "dps" }
function UI.TexteRole(role)
	local r = UI.ROLES[role]
	if not r then return "" end
	return ("|cff%02x%02x%02x%s|r"):format(math.floor(r.clair[1] * 255), math.floor(r.clair[2] * 255),
		math.floor(r.clair[3] * 255), r.nom)
end

--------------------------------------------------------------------------------
-- Éléments de base
--------------------------------------------------------------------------------

-- fond plat et bordure d'un pixel (cadre créé avec "BackdropTemplate")
function UI.Habiller(f, fond, bord)
	if not f.SetBackdrop then return end
	f:SetBackdrop({ bgFile = BLANC, edgeFile = BLANC, edgeSize = 1 })
	f:SetBackdropColor(unpack(fond))
	if bord then f:SetBackdropBorderColor(unpack(bord)) else f:SetBackdropBorderColor(0, 0, 0, 0) end
end

function UI.Cadre(parent, fond, bord)
	local f = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	UI.Habiller(f, fond, bord)
	return f
end

function UI.Texte(parent, modele, couleur)
	local t = parent:CreateFontString(nil, "OVERLAY", modele or "GameFontHighlight")
	if couleur then t:SetTextColor(unpack(couleur)) end
	t:SetJustifyH("LEFT")
	t:SetWordWrap(false)
	return t
end

-- filet horizontal (séparation)
function UI.Filet(parent, couleur)
	local t = parent:CreateTexture(nil, "ARTWORK")
	t:SetColorTexture(unpack(couleur or C.bord))
	t:SetHeight(1)
	return t
end

function UI.Infobulle(cadre, titre, texte)
	cadre:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(titre)
		if texte then GameTooltip:AddLine(texte, 1, 1, 1, true) end
		GameTooltip:Show()
	end)
	cadre:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function Survol(cadre, alpha)
	local s = cadre:CreateTexture(nil, "HIGHLIGHT")
	s:SetAllPoints()
	s:SetColorTexture(1, 1, 1, alpha or 0.08)
	return s
end
UI.Survol = Survol

-- Son de clic des éléments du kit, sur PostClick : les pages posent leur propre OnClick avec
-- SetScript, ce qui effacerait une accroche sur OnClick. case = vrai : son de case cochée / décochée.
function UI.SonClic(b, case)
	b:SetScript("PostClick", function(self)
		if not ns.Son then return end
		if case then
			ns.Son(self.oui and "IG_MAINMENU_OPTION_CHECKBOX_ON" or "IG_MAINMENU_OPTION_CHECKBOX_OFF")
		else
			ns.Son("U_CHAT_SCROLL_BUTTON")
		end
	end)
end

-- Bouton plat : "or" (action principale), "fantome" (secondaire), "aide" (appel à l'aide)
function UI.Bouton(parent, texte, style, largeur, hauteur)
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	b:SetSize(largeur or 84, hauteur or 24)
	b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	b.texte:SetPoint("CENTER")
	b.texte:SetText(texte or "")
	if style == "or" then
		UI.Habiller(b, { C.orFonce[1], C.orFonce[2], C.orFonce[3], 1 }, { C.ors[1], C.ors[2], C.ors[3], 1 })
		-- texte sombre sur l'or : sans l'ombre noire de la police du jeu, qui le rendait baveux
		b.texte:SetTextColor(0.07, 0.05, 0.02)
		b.texte:SetShadowOffset(0, 0)
		b.texte:SetShadowColor(0, 0, 0, 0)
	elseif style == "aide" then
		UI.Habiller(b, C.fondAide, C.bordAide)
		b.texte:SetFontObject("GameFontNormal")
		b.texte:SetTextColor(unpack(C.aide))
	else
		UI.Habiller(b, { 0, 0, 0, 0 }, C.bordMoyen)
		b.texte:SetTextColor(unpack(C.ors))
	end
	Survol(b)
	UI.SonClic(b)
	b.Ecrire = function(self, t) self.texte:SetText(t) end
	b.Activer = function(self, oui)
		self:SetEnabled(oui and true or false)
		self:SetAlpha(oui and 1 or 0.45)
	end
	return b
end

-- Bouton d'alerte (style « aide » : fond rouge sombre, bordure) avec l'icône d'alerte du jeu à gauche du
-- texte ; l'icône pulse doucement tant que le bouton est affiché (repli : un « ! » si l'icône manque)
function UI.BoutonAlerte(parent, texte, largeur, hauteur)
	local b = UI.Bouton(parent, texte, "aide", largeur or 150, hauteur or 30)
	b.icone = b:CreateTexture(nil, "OVERLAY")
	b.icone:SetSize(22, 22)
	b.icone:SetPoint("LEFT", b, "LEFT", 8, 0)
	local ok, pose = pcall(b.icone.SetTexture, b.icone, "Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
	if not ok or pose == false then
		-- (SetTexture renvoie false si le fichier n'existe pas sur ce client)
		b.icone:SetTexture(nil)
		local point = b:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		point:SetPoint("CENTER", b.icone, "CENTER", 0, 0)
		point:SetText("!")
		point:SetTextColor(unpack(C.aide))
	end
	b.texte:ClearAllPoints()
	b.texte:SetPoint("LEFT", b.icone, "RIGHT", 6, 0)
	b.texte:SetPoint("RIGHT", b, "RIGHT", -8, 0)
	b.texte:SetJustifyH("LEFT")
	local t = 0
	b:SetScript("OnUpdate", function(self, ecoule)
		t = (t + (ecoule or 0)) % 2
		self.icone:SetAlpha(0.55 + 0.45 * math.abs(1 - t))
	end)
	return b
end

-- pastille ronde (compteur) : rouge, ou discrète (neutre)
-- Croix de fermeture plate : carré bordé, deux traits dorés en croix (texte « X » si le client ne
-- sait pas tourner une texture) ; fermer() au clic. Pas de son de clic : la fenêtre joue le sien.
function UI.Fermer(parent, fermer, taille)
	taille = taille or 28
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	UI.Habiller(b, { 0, 0, 0, 0 }, C.bordMoyen)
	b:SetSize(taille, taille)
	local tourne = true
	for _, angle in ipairs({ 45, -45 }) do
		local t = b:CreateTexture(nil, "ARTWORK")
		t:SetColorTexture(C.ors[1], C.ors[2], C.ors[3], 1)
		t:SetSize(taille * 0.55, 2)
		t:SetPoint("CENTER")
		if not (t.SetRotation and pcall(t.SetRotation, t, math.rad(angle))) then
			tourne = false
			t:Hide()
		end
	end
	if not tourne then
		local x = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		x:SetPoint("CENTER", 0, 0)
		x:SetText("X")
		x:SetTextColor(unpack(C.ors))
	end
	Survol(b, 0.1)
	b:SetScript("OnClick", function() if fermer then fermer() end end)
	return b
end

function UI.Pastille(parent, neutre)
	local p = CreateFrame("Frame", nil, parent)
	p:SetSize(20, 20)
	p.rond = p:CreateTexture(nil, "ARTWORK")
	p.rond:SetTexture(ROND)
	p.rond:SetAllPoints()
	if neutre then p.rond:SetVertexColor(C.bord[1], C.bord[2], C.bord[3], 1) else p.rond:SetVertexColor(C.rouge[1], C.rouge[2], C.rouge[3], 1) end
	p.n = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	p.n:SetPoint("CENTER", 0, 0)
	if neutre then p.n:SetTextColor(unpack(C.ors)) end
	p.Ecrire = function(self, n)
		n = tonumber(n) or 0
		self.n:SetText(n > 9 and "9+" or tostring(n))
		self:SetShown(n > 0)
	end
	return p
end

-- carte (bloc) avec un titre doré et un compteur à droite ; c.vide = message quand elle est vide
function UI.Carte(parent, titre)
	local c = UI.Cadre(parent, C.carte, C.bord)
	c.titre = UI.Texte(c, "GameFontNormal", C.ors)
	c.titre:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -12)
	c.titre:SetText(titre or "")
	c.compte = UI.Texte(c, "GameFontHighlight", C.gris)
	c.compte:SetPoint("TOPRIGHT", c, "TOPRIGHT", -14, -13)
	c.compte:SetJustifyH("RIGHT")
	c.vide = UI.Texte(c, "GameFontHighlight", C.gris)
	c.vide:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -40)
	c.vide:SetPoint("RIGHT", c, "RIGHT", -14, 0)
	c.vide:SetWordWrap(true)
	return c
end

-- rangée cliquable façon carte (une ligne de liste) ; fortes = bordure dorée (mise en avant)
function UI.Rangee(parent, hauteur)
	local r = CreateFrame("Button", nil, parent, "BackdropTemplate")
	UI.Habiller(r, C.carte, C.bord)
	r:SetHeight(hauteur or 64)
	Survol(r, 0.04)
	r.Fort = function(self, oui) self:SetBackdropBorderColor(unpack(oui and C.bordMoyen or C.bord)) end
	return r
end

--------------------------------------------------------------------------------
-- Portraits et rôles
--------------------------------------------------------------------------------

-- Portrait rond d'un joueur : son médaillon s'il est connu (positions de la carte), sinon l'icône de
-- sa classe dans un disque sombre
function UI.Portrait(parent, taille)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(taille, taille)
	f.fond = f:CreateTexture(nil, "BACKGROUND")
	f.fond:SetTexture(ROND)
	f.fond:SetAllPoints()
	f.fond:SetVertexColor(0.16, 0.13, 0.09, 1)
	f.image = f:CreateTexture(nil, "ARTWORK")
	f.image:SetAllPoints()
	f.Poser = function(self, cle, classe)
		local p = cle and ns.PositionsMembres and ns.PositionsMembres()[cle]
		if p and p.portrait then
			self.image:SetTexture(p.portrait)
			self.image:SetTexCoord(0, 1, 0, 1)
			self.image:ClearAllPoints()
			self.image:SetAllPoints()
			self.fond:Hide()
			return
		end
		self.fond:Show()
		classe = classe or (ns.ClasseMembre and ns.ClasseMembre(cle))
		local coords = classe and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[classe]
		self.image:ClearAllPoints()
		self.image:SetPoint("CENTER")
		self.image:SetSize(self:GetWidth() * 0.62, self:GetHeight() * 0.62)
		if coords then
			self.image:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			self.image:SetTexCoord(unpack(coords))
		else
			self.image:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
			self.image:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		end
	end
	return f
end

-- Places d'un groupe : un rond par place, plein à la couleur du rôle quand elle est prise, anneau
-- quand elle est libre (couleur du rôle recherché, ou doré si tous les rôles conviennent)
function UI.Places(parent, nombreMax)
	local f = CreateFrame("Frame", nil, parent)
	f.ronds = {}
	local TAILLE, ECART = 18, 4
	for i = 1, nombreMax do
		local r = f:CreateTexture(nil, "ARTWORK")
		r:SetSize(TAILLE, TAILLE)
		r:SetPoint("LEFT", f, "LEFT", (i - 1) * (TAILLE + ECART), 0)
		f.ronds[i] = r
	end
	f:SetSize(nombreMax * (TAILLE + ECART) - ECART, TAILLE)
	-- places = liste de { role = "tank"|"heal"|"dps"|nil, pris = vrai/faux }
	f.Poser = function(self, places)
		for i, r in ipairs(self.ronds) do
			local p = places[i]
			if p then
				local c = (p.role and UI.ROLES[p.role]) and (p.pris and UI.ROLES[p.role].plein or UI.ROLES[p.role].clair) or C.orFonce
				r:SetTexture(p.pris and ROND or ANNEAU)
				r:SetVertexColor(c[1], c[2], c[3], p.pris and 1 or 0.85)
				r:Show()
			else
				r:Hide()
			end
		end
	end
	return f
end

--------------------------------------------------------------------------------
-- Onglets, puces de filtre
--------------------------------------------------------------------------------

-- Onglets soulignés (comme « Parcourir | Mon groupe ») : choisir(i) est appelé au clic ;
-- o.Choisir(i) met à jour l'apparence ; o.Compte(i, n) ajoute un compteur
function UI.Onglets(parent, noms, choisir)
	local o = CreateFrame("Frame", nil, parent)
	o:SetHeight(34)
	o.boutons = {}
	local x = 0
	for i, nom in ipairs(noms) do
		local b = CreateFrame("Button", nil, o)
		b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		b.texte:SetPoint("CENTER", 0, 1)
		b.texte:SetText(nom)
		b.nom = nom
		local l = math.max(70, b.texte:GetStringWidth() + 26)
		b:SetSize(l, 34)
		b:SetPoint("BOTTOMLEFT", o, "BOTTOMLEFT", x, 0)
		x = x + l + 2
		b.trait = b:CreateTexture(nil, "OVERLAY")
		b.trait:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 1)
		b.trait:SetHeight(2)
		b.trait:SetPoint("BOTTOMLEFT")
		b.trait:SetPoint("BOTTOMRIGHT")
		Survol(b, 0.05)
		b:SetScript("OnClick", function() choisir(i) end)
		UI.SonClic(b)
		o.boutons[i] = b
	end
	local filet = UI.Filet(o)
	filet:SetPoint("BOTTOMLEFT")
	filet:SetPoint("BOTTOMRIGHT")
	o.Choisir = function(self, i)
		for j, b in ipairs(self.boutons) do
			b.trait:SetShown(j == i)
			b.texte:SetTextColor(unpack(j == i and C.ors or C.gris))
		end
	end
	o.Compte = function(self, i, n)
		local b = self.boutons[i]
		if b then b.texte:SetText(b.nom .. ((n and n > 0) and ("  |cff6fd08c(" .. n .. ")|r") or "")) end
	end
	return o
end

-- Puces de filtre (« Tout », « Donjons »…) : une seule choisie ; choisir(i) au clic
function UI.Puces(parent, noms, choisir)
	local p = CreateFrame("Frame", nil, parent)
	p:SetHeight(28)
	p.boutons = {}
	local x = 0
	for i, nom in ipairs(noms) do
		local b = CreateFrame("Button", nil, p, "BackdropTemplate")
		UI.Habiller(b, { 0, 0, 0, 0 }, C.bord)
		b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		b.texte:SetPoint("CENTER")
		b.texte:SetText(nom)
		local l = b.texte:GetStringWidth() + 24
		b:SetSize(l, 26)
		b:SetPoint("LEFT", p, "LEFT", x, 0)
		x = x + l + 6
		Survol(b)
		b:SetScript("OnClick", function() choisir(i) end)
		UI.SonClic(b)
		p.boutons[i] = b
	end
	p:SetWidth(math.max(1, x - 6))
	p.Choisir = function(self, i)
		for j, b in ipairs(self.boutons) do
			local oui = (j == i)
			b:SetBackdropColor(unpack(oui and C.actif or { 0, 0, 0, 0 }))
			b:SetBackdropBorderColor(unpack(oui and C.bordMoyen or C.bord))
			b.texte:SetTextColor(unpack(oui and C.ors or C.texte))
		end
	end
	return p
end

--------------------------------------------------------------------------------
-- Liste défilante
--------------------------------------------------------------------------------

-- Zone qui défile à la molette, avec une fine barre dorée à droite quand le contenu dépasse.
-- l.contenu : le cadre où poser les éléments ; l.Hauteur(h) : hauteur totale du contenu.
function UI.Liste(parent)
	local l = CreateFrame("ScrollFrame", nil, parent)
	local contenu = CreateFrame("Frame", nil, l)
	contenu:SetSize(1, 1)
	l:SetScrollChild(contenu)
	l.contenu = contenu
	local barre = l:CreateTexture(nil, "OVERLAY")
	barre:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 0.55)
	barre:SetWidth(3)
	barre:Hide()
	local function MajBarre()
		local h, total = l:GetHeight(), contenu:GetHeight()
		if not h or h <= 0 or total <= h + 1 then barre:Hide(); return end
		local hb = math.max(20, h * h / total)
		local y = (l:GetVerticalScroll() / (total - h)) * (h - hb)
		barre:ClearAllPoints()
		barre:SetPoint("TOPRIGHT", l, "TOPRIGHT", 0, -y)
		barre:SetHeight(hb)
		barre:Show()
	end
	l:EnableMouseWheel(true)
	l:SetScript("OnMouseWheel", function(self, sens)
		local max = math.max(0, contenu:GetHeight() - self:GetHeight())
		local v = math.min(max, math.max(0, self:GetVerticalScroll() - sens * 40))
		self:SetVerticalScroll(v)
		MajBarre()
	end)
	l:SetScript("OnSizeChanged", function(self, w)
		contenu:SetWidth(math.max(1, (w or self:GetWidth()) - 8))
		MajBarre()
	end)
	l.Hauteur = function(self, h)
		contenu:SetHeight(math.max(1, h))
		local max = math.max(0, h - self:GetHeight())
		if self:GetVerticalScroll() > max then self:SetVerticalScroll(max) end
		MajBarre()
	end
	l.Haut = function(self) self:SetVerticalScroll(0); MajBarre() end
	return l
end

--------------------------------------------------------------------------------
-- Saisie
--------------------------------------------------------------------------------

-- Champ de saisie sombre (bordure dorée quand il a le focus) ; indice = texte grisé quand il est vide
function UI.Champ(parent, largeur, indice, hauteur)
	local cadre = UI.Cadre(parent, C.champ, C.bord)
	cadre:SetSize(largeur, hauteur or 28)
	local e = CreateFrame("EditBox", nil, cadre)
	e:SetPoint("TOPLEFT", cadre, "TOPLEFT", 8, 0)
	e:SetPoint("BOTTOMRIGHT", cadre, "BOTTOMRIGHT", -8, 0)
	e:SetFontObject("GameFontHighlight")
	e:SetAutoFocus(false)
	e:SetTextColor(unpack(C.texte))
	local ind = UI.Texte(cadre, "GameFontHighlight", C.gris)
	ind:SetPoint("LEFT", e, "LEFT", 0, 0)
	ind:SetText(indice or "")
	local function MajIndice() ind:SetShown((e:GetText() or "") == "" and not e:HasFocus()) end
	e:SetScript("OnEditFocusGained", function() cadre:SetBackdropBorderColor(unpack(C.bordFort)); MajIndice() end)
	e:SetScript("OnEditFocusLost", function()
		cadre:SetBackdropBorderColor(unpack(C.bord)); MajIndice()
		if cadre.SurValider then cadre.SurValider(e:GetText() or "") end
	end)
	e:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	e:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	e:SetScript("OnTextChanged", function(self, parUtilisateur)
		MajIndice()
		if parUtilisateur and cadre.SurTexte then cadre.SurTexte(self:GetText() or "") end
	end)
	cadre.saisie = e
	cadre.Lire = function() return e:GetText() or "" end
	cadre.Ecrire = function(_, t) e:SetText(t or ""); MajIndice() end
	cadre:EnableMouse(true)
	cadre:SetScript("OnMouseDown", function() e:SetFocus() end)
	MajIndice()
	return cadre
end

-- Case à cocher : petit carré bordé, coche dorée ; changer(oui) au clic
function UI.Case(parent, texte, changer)
	local b = CreateFrame("Button", nil, parent)
	b:SetHeight(22)
	b.carre = UI.Cadre(b, C.champ, C.bordMoyen)
	b.carre:SetSize(16, 16)
	b.carre:SetPoint("LEFT", b, "LEFT", 0, 0)
	b.coche = b.carre:CreateTexture(nil, "OVERLAY")
	b.coche:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	b.coche:SetVertexColor(C.ors[1], C.ors[2], C.ors[3], 1)
	b.coche:SetPoint("CENTER")
	b.coche:SetSize(20, 20)
	b.texte = UI.Texte(b, "GameFontHighlight", C.texte)
	b.texte:SetPoint("LEFT", b.carre, "RIGHT", 8, 0)
	b.texte:SetText(texte or "")
	b:SetWidth(24 + b.texte:GetStringWidth())
	b.oui = false
	b.Poser = function(self, oui) self.oui = oui and true or false; self.coche:SetShown(self.oui) end
	b:SetScript("OnClick", function(self)
		self:Poser(not self.oui)
		if changer then changer(self.oui) end
	end)
	b:Poser(false)
	UI.SonClic(b, true)
	return b
end

-- Liste de choix : bouton qui montre la valeur et ouvre un menu sombre.
-- options = { { valeur, texte }, … } ; choisir(valeur) au choix ; c.Poser(valeur)
local menuChoix
function UI.Choix(parent, largeur, options, choisir)
	local c = CreateFrame("Button", nil, parent, "BackdropTemplate")
	UI.Habiller(c, C.champ, C.bord)
	c:SetSize(largeur, 28)
	c.texte = UI.Texte(c, "GameFontHighlight", C.texte)
	c.texte:SetPoint("LEFT", c, "LEFT", 8, 0)
	c.texte:SetPoint("RIGHT", c, "RIGHT", -20, 0)
	local fl = c:CreateTexture(nil, "OVERLAY")
	fl:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	fl:SetSize(16, 16)
	fl:SetPoint("RIGHT", c, "RIGHT", -4, 0)
	Survol(c, 0.05)
	c.options = options
	c.Poser = function(self, valeur)
		self.valeur = valeur
		for _, o in ipairs(self.options) do if o[1] == valeur then self.texte:SetText(o[2]) end end
	end
	c:SetScript("OnClick", function(self)
		if not menuChoix then
			menuChoix = CreateFrame("Frame", "GuildUpMenuChoix", UIParent, "BackdropTemplate")
			UI.Habiller(menuChoix, { 0.05, 0.043, 0.035, 0.98 }, C.bordFort)
			menuChoix:SetFrameStrata("FULLSCREEN_DIALOG")
			menuChoix:SetClampedToScreen(true)
			menuChoix.lignes = {}
			menuChoix:SetScript("OnUpdate", function(m)
				if not m:IsMouseOver(20, -20, -20, 20) and not (m.ancre and m.ancre:IsMouseOver()) then m:Hide() end
			end)
			tinsert(UISpecialFrames, "GuildUpMenuChoix")
		end
		local m = menuChoix
		m.ancre = self
		for i, o in ipairs(self.options) do
			local l = m.lignes[i]
			if not l then
				l = CreateFrame("Button", nil, m)
				l:SetHeight(22)
				l.texte = UI.Texte(l, "GameFontHighlight", C.texte)
				l.texte:SetPoint("LEFT", l, "LEFT", 8, 0)
				Survol(l)
				m.lignes[i] = l
			end
			l:ClearAllPoints()
			l:SetPoint("TOPLEFT", m, "TOPLEFT", 2, -2 - (i - 1) * 22)
			l:SetPoint("RIGHT", m, "RIGHT", -2, 0)
			l.texte:SetText(o[2])
			l.texte:SetTextColor(unpack(o[1] == self.valeur and C.ors or C.texte))
			l:SetScript("OnClick", function()
				m:Hide()
				self:Poser(o[1])
				if choisir then choisir(o[1]) end
			end)
			l:Show()
		end
		for i = #self.options + 1, #m.lignes do m.lignes[i]:Hide() end
		m:SetSize(math.max(self:GetWidth(), 120), #self.options * 22 + 4)
		m:ClearAllPoints()
		m:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
		m:Show()
	end)
	return c
end

-- Curseur : piste fine, partie remplie dorée, poignée ronde, valeur écrite à droite (c.valeur).
-- changer(valeur) quand on relâche la poignée, qu'on clique sur la piste ou à la molette (pas pendant le
-- glissement : la valeur peut changer la taille de la fenêtre qui contient le curseur) ;
-- c:Poser(valeur) sans appeler changer (ignoré pendant un glissement) ; c.Format(valeur) → texte affiché
-- (deux décimales au plus, virgule)
function UI.Curseur(parent, largeur, min, max, pas, changer)
	local c = CreateFrame("Slider", nil, parent)
	c:SetSize(largeur, 16)
	if c.SetOrientation then c:SetOrientation("HORIZONTAL") end
	c:SetMinMaxValues(min, max)
	c:SetValueStep(pas)
	if c.SetObeyStepOnDrag then c:SetObeyStepOnDrag(true) end
	c:EnableMouse(true)
	c:EnableMouseWheel(true)
	local piste = c:CreateTexture(nil, "BACKGROUND")
	piste:SetColorTexture(0.165, 0.137, 0.094, 1)
	piste:SetHeight(4)
	piste:SetPoint("LEFT", c, "LEFT", 0, 0)
	piste:SetPoint("RIGHT", c, "RIGHT", 0, 0)
	local plein = c:CreateTexture(nil, "ARTWORK")
	plein:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 1)
	plein:SetHeight(4)
	plein:SetPoint("LEFT", piste, "LEFT", 0, 0)
	-- poignée : un objet texture si le client l'accepte, sinon un chemin de fichier
	local poignee = c:CreateTexture(nil, "OVERLAY")
	poignee:SetTexture(ROND)
	poignee:SetSize(14, 14)
	if not pcall(c.SetThumbTexture, c, poignee) then
		c:SetThumbTexture(ROND)
		poignee = c.GetThumbTexture and c:GetThumbTexture() or poignee
		poignee:SetSize(14, 14)
	end
	poignee:SetVertexColor(C.ors[1], C.ors[2], C.ors[3], 1)
	c.valeur = UI.Texte(c, "GameFontHighlight", C.gris)
	c.valeur:SetPoint("LEFT", c, "RIGHT", 10, 0)
	c.Format = function(v)
		local t = ("%.2f"):format(v):gsub("0$", "")
		return (t:gsub("%.", ","))
	end
	local function Arrondi(v) return math.max(min, math.min(max, math.floor(v / pas + 0.5) * pas)) end
	local pose = false
	c:SetScript("OnValueChanged", function(self, v)
		v = Arrondi(v)
		local part = (max > min) and (v - min) / (max - min) or 0
		plein:SetWidth(math.max(1, part * (largeur - 14) + 7))
		self.valeur:SetText(self.Format(v))
	end)
	local function Valider(self)
		if changer and not pose then changer(Arrondi(self:GetValue())) end
	end
	c:SetScript("OnMouseUp", Valider)
	c:SetScript("OnMouseWheel", function(self, sens)
		self:SetValue(Arrondi(self:GetValue() + sens * pas))
		Valider(self)
	end)
	c.Poser = function(self, v)
		if self.IsDraggingThumb and self:IsDraggingThumb() then return end -- (rafraîchissement pendant un glissement)
		pose = true
		self:SetValue(Arrondi(v))
		pose = false
	end
	return c
end

--------------------------------------------------------------------------------
-- Divers
--------------------------------------------------------------------------------

function UI.IlYa(quand)
	local s = math.max(0, time() - (quand or time()))
	if s < 60 then return "à l'instant" end
	if s < 3600 then return "il y a " .. math.floor(s / 60) .. " min" end
	if s < 86400 then return "il y a " .. math.floor(s / 3600) .. " h" end
	return "il y a " .. math.floor(s / 86400) .. " j"
end

-- Chuchoter à un membre (clé normalisée, nom affiché en secours)
function UI.Chuchoter(cle, nom)
	local n = (cle and ns.NomListeGuilde and ns.NomListeGuilde(cle)) or ns.NomCourt(nom or "")
	if cle and cle:find("#test", 1, true) then n = UnitName("player") end
	if ChatFrame_SendTell then ChatFrame_SendTell(n)
	elseif ChatFrame_OpenChat then ChatFrame_OpenChat("/w " .. n .. " ") end
end
