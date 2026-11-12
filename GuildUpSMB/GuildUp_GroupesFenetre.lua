-- GuildUpSMB : fenêtre de la recherche de groupe de la guilde (onglets Parcourir et Mon groupe), dans le
-- style de la recherche de groupe officielle de Forever. Le protocole, l'état (annonces, candidatures)
-- et les actions sont dans GuildUp_Groupes.lua.

local NOM_ADDON, ns = ...

-- (GuildUp_Groupes.lua est chargé avant ce fichier)
local G = ns.Groupes
local etat = G.etat
local ATLAS_DEFAUT = G.ATLAS_DEFAUT
local AnnulerCandidature = G.AnnulerCandidature
local AtlasExiste = G.AtlasExiste
local BesoinParDefaut = G.BesoinParDefaut
local Catalogue = G.Catalogue
local Categories = G.Categories
local Composition = G.Composition
local CouleurClasse = G.CouleurClasse
local CouleurNiveau = G.CouleurNiveau
local CreerMonAnnonce = G.CreerMonAnnonce
local DB = G.DB
local DiffuserMonAnnonce = G.DiffuserMonAnnonce
local Envoyer = G.Envoyer
local EstPerso = G.EstPerso
local FermerMonAnnonce = G.FermerMonAnnonce
local IconeClasse = G.IconeClasse
local IconeRole = G.IconeRole
local InfoContenu = G.InfoContenu
local Inviter = G.Inviter
local MonNom = G.MonNom
local NomCourt = G.NomCourt
local NombreMembres = G.NombreMembres
local PeutAnnoncer = G.PeutAnnoncer
local PlacesLibres = G.PlacesLibres
local PoserAtlas = G.PoserAtlas
local PoserIcone = G.PoserIcone
local Postuler = G.Postuler
local Prenom = G.Prenom
local ROLES = G.ROLES
local Refuser = G.Refuser
local TailleMaxContenu = G.TailleMaxContenu
local TexteNiveaux = G.TexteNiveaux
local TexteRole = G.TexteRole
local Rafraichir -- défini plus bas, avec la fenêtre

--------------------------------------------------------------------------------
-- Éléments d'interface
--------------------------------------------------------------------------------

local function NouveauBouton(parent, texte, largeur, hauteur)
	local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	b:SetSize(largeur or 80, hauteur or 22)
	b:SetText(texte)
	return b
end

local function Infobulle(cadre, Remplir)
	cadre:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		Remplir(GameTooltip, self)
		GameTooltip:Show()
	end)
	cadre:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Places par rôle façon FF14 : une icône par place, chacune dans un petit cadre
-- (fond sombre + liseré doré) ; au-delà de 10 places, 3 icônes + « pris/besoin »
local ECART_PLACES = 6

local function CreerEmplacements(parent, taille)
	local w = CreateFrame("Frame", nil, parent)
	w:SetSize(10 * (taille + ECART_PLACES), taille + 4)
	w.icones, w.cadres, w.compteurs = {}, {}, {}
	for i = 1, 10 do
		local t = w:CreateTexture(nil, "ARTWORK")
		t:SetSize(taille, taille)
		w.icones[i] = t
		local lisere = w:CreateTexture(nil, "BACKGROUND", nil, -1)
		lisere:SetSize(taille + 4, taille + 4)
		lisere:SetPoint("CENTER", t, "CENTER", 0, 0)
		lisere:SetColorTexture(1, 0.82, 0, 0.55)
		local fond = w:CreateTexture(nil, "BACKGROUND", nil, 0)
		fond:SetSize(taille + 2, taille + 2)
		fond:SetPoint("CENTER", t, "CENTER", 0, 0)
		fond:SetColorTexture(0.05, 0.05, 0.05, 0.9)
		w.cadres[i] = { lisere, fond }
	end
	for _, role in ipairs(ROLES) do
		local fs = w:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		w.compteurs[role] = fs
	end
	w.taille = taille
	return w
end

local function MontrerPlace(w, i, visible)
	w.icones[i]:SetShown(visible)
	for _, c in ipairs(w.cadres[i]) do c:SetShown(visible) end
end

local function MajEmplacements(w, besoin, pris, taille)
	local total = (besoin.tank or 0) + (besoin.heal or 0) + (besoin.dps or 0)
	for _, fs in pairs(w.compteurs) do fs:Hide() end
	for i = 1, 10 do MontrerPlace(w, i, false) end
	if total <= 10 and taille <= 10 then
		-- une place par joueur, alignées à droite
		local pas = w.taille + ECART_PLACES
		local i = 10 - total + 1
		for _, role in ipairs(ROLES) do
			for n = 1, besoin[role] or 0 do
				local t = w.icones[i]
				if t then
					t:ClearAllPoints()
					t:SetPoint("RIGHT", w, "RIGHT", -2 - (10 - i) * pas, 0)
					IconeRole(t, role, n <= (pris[role] or 0))
					MontrerPlace(w, i, true)
				end
				i = i + 1
			end
		end
	else
		-- grand groupe : 3 icônes + « pris/besoin » (icône éteinte quand le rôle est complet)
		local decalage = 2
		for n, role in ipairs(ROLES) do
			local t = w.icones[n]
			local fs = w.compteurs[role]
			t:ClearAllPoints()
			t:SetPoint("LEFT", w, "LEFT", decalage, 0)
			IconeRole(t, role, (pris[role] or 0) < (besoin[role] or 0))
			MontrerPlace(w, n, true)
			fs:ClearAllPoints()
			fs:SetPoint("LEFT", t, "RIGHT", 4, 0)
			fs:SetText(("%d/%d"):format(pris[role] or 0, besoin[role] or 0))
			fs:Show()
			decalage = decalage + w.taille + 38
		end
	end
end

-- Petit bouton « entrée sur la carte » (repère sur la carte du monde, voir GuildUp_Carte.lua)
local function CreerBoutonEntree(parent)
	local bt = CreateFrame("Button", nil, parent)
	bt:SetSize(20, 20)
	bt.icone = bt:CreateTexture(nil, "ARTWORK")
	bt.icone:SetAllPoints(bt)
	bt.icone:SetTexture("Interface\\Minimap\\Tracking\\POIArrow")
	if AtlasExiste("Waypoint-MapPin-Untracked") then bt.icone:SetAtlas("Waypoint-MapPin-Untracked") end
	bt:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	bt:SetScript("OnClick", function(self)
		if self.nom and ns.MontrerEntree then ns.MontrerEntree(self.nom, self.mapID) end
	end)
	bt:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Entrée sur la carte")
		GameTooltip:AddLine("Clic : repère sur la carte du monde vers l'entrée de « " .. (self.nom or "?") .. " ».", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	bt:SetScript("OnLeave", function() GameTooltip:Hide() end)
	bt:Hide()
	return bt
end

-- Montre le bouton seulement si l'entrée de ce contenu est connue
local function MajBoutonEntree(bt, e)
	local connue = e and ns.EntreeDonjon and ns.EntreeDonjon(e.nom, e.mapID)
	bt.nom, bt.mapID = e and e.nom, e and e.mapID
	bt:SetShown(connue and true or false)
end

-- remet les icônes en ligne (après un affichage « grand groupe »)
local function RangerEmplacements(w)
	for i, t in ipairs(w.icones) do
		t:ClearAllPoints()
		t:SetPoint("RIGHT", w, "RIGHT", -2 - (10 - i) * (w.taille + ECART_PLACES), 0)
	end
end

--------------------------------------------------------------------------------
-- Fenêtre principale : même disposition que la recherche de groupe officielle de Forever
-- (Blizzard_LFGVanilla_Browse.xml) : bande de pierre en haut, encart central illustré
-- (groupfinder-background + cadre common-insideframe), filets dorés, boutons dans la bande du bas.
--------------------------------------------------------------------------------

local LARGEUR, HAUTEUR = 458, 535
local HAUT_ENCART = -80          -- haut de l'encart central
local LIGNE_HAUT = -100          -- filet doré du haut (20 sous le haut de l'encart)
local BAS_LISTE = 66             -- bas des listes (au-dessus du filet du bas, à 61 du bas)
local LARGEUR_LISTE = 404

local function CreerCadrePrincipal()
	local ok, f = pcall(CreateFrame, "Frame", "GuildUpGroupes", UIParent, "PortraitFrameTemplate")
	if not ok then
		ok, f = pcall(CreateFrame, "Frame", "GuildUpGroupes", UIParent, "BasicFrameTemplateWithInset")
		if not ok then f = CreateFrame("Frame", "GuildUpGroupes", UIParent) end
	end
	f:SetSize(LARGEUR, HAUTEUR)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	f:SetToplevel(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	tinsert(UISpecialFrames, "GuildUpGroupes")
	local titre = "Groupes de la guilde"
	if f.SetTitle then pcall(f.SetTitle, f, titre)
	elseif f.TitleText then f.TitleText:SetText(titre) end
	if f.SetPortraitToAsset then
		pcall(f.SetPortraitToAsset, f, "Interface\\Icons\\Ability_Warrior_RallyingCry")
	end

	-- bande de pierre sous le titre
	local pierre = f:CreateTexture(nil, "BACKGROUND", nil, -5)
	pierre:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -21)
	pierre:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -2, HAUT_ENCART - 7)
	PoserAtlas(pierre, "groupfinder-Stat-StoneBG", { 0.12, 0.1, 0.08, 1 })

	-- encart central : illustration + cadre intérieur
	local encart = CreateFrame("Frame", nil, f)
	encart:SetPoint("TOPLEFT", f, "TOPLEFT", 4, HAUT_ENCART)
	encart:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 3)
	encart:SetFrameLevel(f:GetFrameLevel() + 1)
	local illustration = encart:CreateTexture(nil, "BACKGROUND")
	illustration:SetPoint("TOPLEFT", encart, "TOPLEFT", 3, -3)
	illustration:SetPoint("BOTTOMRIGHT", encart, "BOTTOMRIGHT", -3, 3)
	PoserAtlas(illustration, "groupfinder-background", { 0.06, 0.05, 0.05, 1 })
	local cadre = encart:CreateTexture(nil, "BORDER")
	cadre:SetPoint("TOPLEFT", encart, "TOPLEFT", 0, 2)
	cadre:SetPoint("BOTTOMRIGHT", encart, "BOTTOMRIGHT", 0, 0)
	if not PoserAtlas(cadre, "common-insideframe") then cadre:Hide() end
	f.encart = encart

	-- filets dorés : haut de la liste, et au-dessus des boutons du bas
	local function Filet(y, depuisLeBas)
		local t = encart:CreateTexture(nil, "OVERLAY")
		if AtlasExiste("groupfinder-ScrollLine") then
			t:SetAtlas("groupfinder-ScrollLine", true)
		else
			t:SetColorTexture(1, 0.82, 0, 0.3)
			t:SetHeight(1)
		end
		local point = depuisLeBas and "BOTTOMLEFT" or "TOPLEFT"
		local point2 = depuisLeBas and "BOTTOMRIGHT" or "TOPRIGHT"
		t:ClearAllPoints()
		t:SetPoint("LEFT", f, point, 4, y)
		t:SetPoint("RIGHT", f, point2, -4, y)
		return t
	end
	Filet(LIGNE_HAUT, false)
	Filet(61, true)
	return f
end

local function NouvellePage(f)
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	p:SetFrameLevel(f.encart:GetFrameLevel() + 2)
	return p
end

local function NouvelleListe(p, haut, bas)
	local defile = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", p, "TOPLEFT", 10, haut)
	defile:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -32, bas)
	local contenu = CreateFrame("Frame", nil, defile)
	contenu:SetSize(LARGEUR_LISTE, 10)
	defile:SetScrollChild(contenu)
	return defile, contenu
end

local function CreerOnglets(f, noms, Choisir)
	f.onglets = {}
	for i, nom in ipairs(noms) do
		local ok, o = pcall(CreateFrame, "Button", "GuildUpGroupesTab" .. i, f, "PanelTabButtonTemplate")
		if not ok then o = NouveauBouton(f, nom, 110, 24) end
		o:SetID(i)
		o:SetText(nom)
		if PanelTemplates_TabResize then pcall(PanelTemplates_TabResize, o, 0) end
		if i == 1 then
			o:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 12, 2)
		else
			o:SetPoint("LEFT", f.onglets[i - 1], "RIGHT", 3, 0)
		end
		o:SetScript("OnClick", function() Choisir(i) end)
		f.onglets[i] = o
	end
	f.numTabs = #noms
	f.Tabs = f.onglets
end

local function MarquerOnglet(f, i)
	if PanelTemplates_SetTab then pcall(PanelTemplates_SetTab, f, i) end
end

--------------------------------------------------------------------------------
-- Onglet 1 : Parcourir
--------------------------------------------------------------------------------

-- Choix du rôle (Tank / Heal / DPS) dans la bande de pierre, comme les boutons de rôle de la
-- recherche de groupe officielle. Même choix que la barre de rôle (ns.ChoisirRole).
local choixRoles = {} -- tous les sélecteurs créés, pour les remettre à jour ensemble

local function MajChoixRole(w)
	local actuel = ns.MonRole and ns.MonRole()
	local manuel = ns.RoleChoisiALaMain and ns.RoleChoisiALaMain()
	for role, b in pairs(w.boutons) do
		IconeRole(b.icone, role, actuel == role)
		b.coche:SetShown(manuel == role)
	end
end

local function CreerChoixRole(parent)
	local w = CreateFrame("Frame", nil, parent)
	w:SetSize(3 * 42, 40)
	w.boutons = {}
	for i, role in ipairs(ROLES) do
		local b = CreateFrame("Button", nil, w)
		b:SetSize(38, 38)
		b:SetPoint("LEFT", w, "LEFT", (i - 1) * 42, 0)
		b.icone = b:CreateTexture(nil, "ARTWORK")
		b.icone:SetAllPoints(b)
		local survol = b:CreateTexture(nil, "HIGHLIGHT")
		survol:SetAllPoints(b)
		survol:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
		survol:SetBlendMode("ADD")
		survol:SetAlpha(0.5)
		-- coche : rôle choisi à la main (sinon rôle automatique : groupe / spécialisation)
		b.coche = b:CreateTexture(nil, "OVERLAY")
		b.coche:SetSize(18, 18)
		b.coche:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
		b.coche:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		b:SetScript("OnClick", function()
			if ns.ChoisirRole then ns.ChoisirRole(role) end
			for _, autre in ipairs(choixRoles) do MajChoixRole(autre) end
			if Rafraichir then Rafraichir() end
		end)
		Infobulle(b, function(tt)
			tt:SetText(TexteRole(role))
			tt:AddLine("Clic : annoncer ce rôle à la guilde.", 1, 1, 1)
			tt:AddLine("Re-clic : revenir en automatique.", 0.7, 0.7, 0.7)
		end)
		w.boutons[role] = b
	end
	choixRoles[#choixRoles + 1] = w
	return w
end

-- appelé par GuildUp.lua quand le rôle change depuis la barre de rôle
ns.SurChangementDeRole = function()
	for _, w in ipairs(choixRoles) do MajChoixRole(w) end
	if Rafraichir then Rafraichir() end
end

local HAUTEUR_ENTREE = 56

local function CreerEntree(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(LARGEUR_LISTE, HAUTEUR_ENTREE - 4)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	PoserAtlas(b.fond, "groupfinder-highlightbar", { 0.15, 0.13, 0.1, 0.8 })
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetAllPoints(b)
	if not PoserAtlas(survol, "groupfinder-highlightbar-blue") then survol:SetColorTexture(0.3, 0.5, 1, 0.15) end
	survol:SetBlendMode("ADD")
	survol:SetAlpha(0.6)

	-- vignette large : les images de catégorie sont en paysage
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(72, 44)
	b.icone:SetPoint("LEFT", b, "LEFT", 4, 0)

	b.nom = b:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	b.nom:SetPoint("TOPLEFT", b, "TOPLEFT", 82, -5)
	b.nom:SetPoint("RIGHT", b, "RIGHT", -200, 0)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)

	b.chefIcone = b:CreateTexture(nil, "ARTWORK")
	b.chefIcone:SetSize(14, 14)
	b.chefIcone:SetPoint("TOPLEFT", b.nom, "BOTTOMLEFT", 0, -3)
	if not PoserAtlas(b.chefIcone, "groupfinder-icon-leader") then
		b.chefIcone:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	end
	b.classe = b:CreateTexture(nil, "ARTWORK")
	b.classe:SetSize(14, 14)
	b.classe:SetPoint("LEFT", b.chefIcone, "RIGHT", 2, 0)
	b.chef = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	b.chef:SetPoint("LEFT", b.classe, "RIGHT", 3, 0)
	b.niveaux = b:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	b.niveaux:SetPoint("LEFT", b.chef, "RIGHT", 8, 0)

	b.commentaire = b:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	b.commentaire:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 82, 5)
	b.commentaire:SetPoint("RIGHT", b, "RIGHT", -150, 0)
	b.commentaire:SetJustifyH("LEFT")
	b.commentaire:SetWordWrap(false)

	b.places = CreerEmplacements(b, 13)
	b.places:SetPoint("TOPRIGHT", b, "TOPRIGHT", -6, -6)
	b.entree = CreerBoutonEntree(b)
	b.entree:SetPoint("BOTTOMRIGHT", b.icone, "BOTTOMRIGHT", 2, -2)
	b.compte = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	b.compte:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -100, 8)

	b.bouton = NouveauBouton(b, "Postuler", 90, 20)
	b.bouton:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -6, 5)

	Infobulle(b, function(tt, self)
		local a = self.annonce
		if not a then return end
		local e = InfoContenu(a.code)
		tt:SetText(e.nom, 1, 0.82, 0)
		tt:AddLine(TexteNiveaux(e) .. "  ·  " .. (a.membres or 1) .. "/" .. (a.taille or 5) .. " joueurs", 1, 1, 1)
		tt:AddLine(" ")
		tt:AddLine("Chef : " .. CouleurClasse(a.classe) .. NomCourt(a.chef) .. "|r (" .. (a.niveau or 0) .. ")", 1, 1, 1)
		if ns.LignesIdentite then ns.LignesIdentite(tt, a.chef) end
		for _, m in ipairs(a.liste or {}) do
			if Prenom(m.nom) ~= Prenom(a.chef) then tt:AddLine("  " .. m.nom .. " — " .. TexteRole(m.role), 1, 1, 1) end
		end
		tt:AddLine(" ")
		for _, role in ipairs(ROLES) do
			local libres = PlacesLibres(a, role) or 0
			tt:AddLine(("%s : %d/%d%s"):format(TexteRole(role), a.pris[role] or 0, a.besoin[role] or 0,
				libres > 0 and ("  |cff33dd55(" .. libres .. " libre" .. (libres > 1 and "s" or "") .. ")|r") or ""), 1, 1, 1)
		end
		if a.commentaire ~= "" then
			tt:AddLine(" ")
			tt:AddLine(a.commentaire, 0.8, 0.8, 0.8, true)
		end
	end)
	return b
end

local function CreerPageParcourir(f, AllerVersMonGroupe)
	local p = NouvellePage(f)

	-- bande du haut : titre et rôle
	local titre = p:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", 74, -34)
	titre:SetText("Groupes de la guilde")
	p.monRole = p:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	p.monRole:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	p.choixRole = CreerChoixRole(p)
	p.choixRole:SetPoint("TOPRIGHT", p, "TOPRIGHT", -16, -30)

	-- en-têtes de colonnes, au-dessus du filet
	local colonne1 = p:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	colonne1:SetPoint("TOPLEFT", p, "TOPLEFT", 16, -86)
	colonne1:SetText("Contenu")
	local colonne2 = p:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	colonne2:SetPoint("TOPRIGHT", p, "TOPRIGHT", -44, -86)
	colonne2:SetText("Places")

	p.defile, p.contenu = NouvelleListe(p, LIGNE_HAUT - 4, BAS_LISTE)
	p.entrees = {}

	p.vide = p:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	p.vide:SetPoint("TOP", p, "TOP", 0, LIGNE_HAUT - 30)
	p.vide:SetWidth(300)
	p.vide:SetText("Aucun groupe ouvert pour l'instant. Si tu ne trouves pas ce que tu cherches, crée le tien.")

	-- bande du bas
	local actualiser = NouveauBouton(p, "Actualiser", 111, 28)
	actualiser:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", 21, 16)
	local dernierQ = 0
	actualiser:SetScript("OnClick", function()
		-- au plus une demande toutes les 10 s
		if GetTime() - dernierQ < 10 then
			if Rafraichir then Rafraichir() end
			return
		end
		dernierQ = GetTime()
		Envoyer("Q", "GUILD")
	end)
	local creer = NouveauBouton(p, "Créer un groupe", 130, 28)
	creer:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -21, 16)
	creer:SetScript("OnClick", AllerVersMonGroupe)
	return p
end

local function RafraichirParcourir(p)
	local monRole = ns.MonRole and ns.MonRole()
	p.monRole:SetText("Ton rôle : " .. TexteRole(monRole))
	local liste = {}
	for _, a in pairs(etat.annonces) do
		if not (etat.monAnnonce and a.id == etat.monAnnonce.id) then liste[#liste + 1] = a end
	end
	table.sort(liste, function(a, b) return a.premiere > b.premiere end)
	-- mon propre groupe, en tête de liste (visible, mais on ne peut pas y postuler)
	if etat.monAnnonce then
		local pris, membres = Composition(etat.monAnnonce.besoin)
		local _, classe = UnitClass("player")
		table.insert(liste, 1, {
			id = etat.monAnnonce.id, estMoi = true, chef = UnitName("player"), premiere = GetTime(),
			code = etat.monAnnonce.code, besoin = etat.monAnnonce.besoin, pris = pris,
			taille = etat.monAnnonce.taille, membres = #membres, niveau = UnitLevel("player") or 0, classe = classe,
			commentaire = etat.monAnnonce.commentaire, liste = membres,
		})
	end
	p.vide:SetShown(#liste == 0)
	for i, a in ipairs(liste) do
		local b = p.entrees[i]
		if not b then
			b = CreerEntree(p.contenu)
			p.entrees[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", p.contenu, "TOPLEFT", 0, -(i - 1) * HAUTEUR_ENTREE)
		b.annonce = a
		local e = InfoContenu(a.code)
		PoserIcone(b.icone, e.icone)
		b.nom:SetText(e.nom)
		IconeClasse(b.classe, a.classe)
		b.chef:SetText(CouleurClasse(a.classe) .. NomCourt(a.chef) .. "|r (" .. (a.niveau or 0) .. ")")
		b.niveaux:SetText(CouleurNiveau(e) .. TexteNiveaux(e) .. "|r")
		b.commentaire:SetText(a.commentaire ~= "" and ("« " .. a.commentaire .. " »") or "")
		RangerEmplacements(b.places)
		MajEmplacements(b.places, a.besoin, a.pris, a.taille or 5)
		MajBoutonEntree(b.entree, e)
		b.compte:SetText((a.membres or 1) .. "/" .. (a.taille or 5))

		local etat = etat.candidatures[a.id]
		local libres = PlacesLibres(a, monRole)
		local bt = b.bouton
		bt:SetEnabled(true)
		if a.estMoi then
			bt:SetText("Ton groupe")
			bt:SetEnabled(false)
		elseif etat == "envoyee" then
			bt:SetText("Annuler")
			bt:SetScript("OnClick", function() AnnulerCandidature(a.id) end)
		elseif etat == "refusee" then
			bt:SetText("Refusé")
			bt:SetEnabled(false)
		elseif (a.membres or 1) >= (a.taille or 5) then
			bt:SetText("Complet")
			bt:SetEnabled(false)
		elseif libres and libres <= 0 then
			bt:SetText("Rôle complet")
			bt:SetEnabled(false)
		else
			bt:SetText("Postuler")
			bt:SetScript("OnClick", function() Postuler(a.id) end)
		end
		b:Show()
	end
	for i = #liste + 1, #p.entrees do p.entrees[i]:Hide() end
	p.contenu:SetHeight(math.max(10, #liste * HAUTEUR_ENTREE))
end

--------------------------------------------------------------------------------
-- Onglet 2 : Mon groupe (créer / gérer mon annonce)
--------------------------------------------------------------------------------

local HAUTEUR_ACTIVITE = 26

-- Taille réelle du cadre des boutons de catégorie (atlas groupfinder-button-cover)
local function TailleBoutonCategorie()
	local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("groupfinder-button-cover")
	local l, h = (info and info.width) or 319, (info and info.height) or 67
	if l > 400 then h = h * 400 / l; l = 400 end -- au cas où, sans déformer
	return l, h
end

-- Bouton de catégorie comme dans la recherche de groupe officielle (LFGListingCategoryTemplate) :
-- image de la catégorie en retrait (5, 8, 5, 5), cadre à sa taille réelle, texte à gauche
local function CreerBoutonCategorie(parent)
	local l, h = TailleBoutonCategorie()
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(l, h)
	b.icone = b:CreateTexture(nil, "BACKGROUND")
	b.icone:SetPoint("TOPLEFT", b, "TOPLEFT", 5, -8)
	b.icone:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -5, 5)
	b.cadre = b:CreateTexture(nil, "ARTWORK")
	b.cadre:SetPoint("CENTER", b, "CENTER", 0, 0)
	if AtlasExiste("groupfinder-button-cover") then
		b.cadre:SetAtlas("groupfinder-button-cover", true)
	else
		b.cadre:Hide()
	end
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetPoint("CENTER", b, "CENTER", 0, 0)
	if AtlasExiste("groupfinder-button-cover-hover") then
		survol:SetAtlas("groupfinder-button-cover-hover", true)
	else
		survol:SetAllPoints(b)
		survol:SetColorTexture(1, 1, 1, 0.15)
	end
	b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	b.texte:SetPoint("LEFT", b, "LEFT", 20, 0)
	b.texte:SetJustifyH("LEFT")
	return b
end

local function CreerLigneActivite(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(LARGEUR_LISTE, HAUTEUR_ACTIVITE - 2)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	PoserAtlas(b.fond, "common-button-list-mid2", { 1, 1, 1, 0.05 })
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetAllPoints(b)
	if not PoserAtlas(survol, "common-button-list-mid2-hover") then survol:SetColorTexture(1, 1, 1, 0.1) end
	-- la couche HIGHLIGHT passe au-dessus du texte : fondu additif léger, sinon tout devient marron
	survol:SetBlendMode("ADD")
	survol:SetAlpha(0.35)
	b.choisi = b:CreateTexture(nil, "ARTWORK")
	b.choisi:SetAllPoints(b)
	if not PoserAtlas(b.choisi, "common-button-list-mid2-selected") then b.choisi:SetColorTexture(1, 0.82, 0, 0.25) end
	b.choisi:SetBlendMode("ADD")
	b.icone = b:CreateTexture(nil, "ARTWORK", nil, 2)
	b.icone:SetSize(20, 20)
	b.icone:SetPoint("LEFT", b, "LEFT", 4, 0)
	b.nom = b:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.infos = b:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	b.infos:SetPoint("RIGHT", b, "RIGHT", -8, 0)
	-- repère de l'entrée sur la carte, devant le nom
	b.entree = CreerBoutonEntree(b)
	b.entree:SetSize(18, 18)
	b.entree:SetPoint("LEFT", b, "LEFT", 4, 0)
	return b
end

local function CreerCompteurRole(parent, role, Changer)
	local c = CreateFrame("Frame", nil, parent)
	c:SetSize(118, 30)
	-- petit cadre : liseré doré + fond sombre
	local lisere = c:CreateTexture(nil, "BACKGROUND", nil, -1)
	lisere:SetPoint("TOPLEFT", c, "TOPLEFT", -5, 4)
	lisere:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", 5, -4)
	lisere:SetColorTexture(1, 0.82, 0, 0.55)
	local fond = c:CreateTexture(nil, "BACKGROUND", nil, 0)
	fond:SetPoint("TOPLEFT", lisere, "TOPLEFT", 1, -1)
	fond:SetPoint("BOTTOMRIGHT", lisere, "BOTTOMRIGHT", -1, 1)
	fond:SetColorTexture(0.05, 0.05, 0.05, 0.85)
	c.icone = c:CreateTexture(nil, "ARTWORK")
	c.icone:SetSize(26, 26)
	c.icone:SetPoint("LEFT", c, "LEFT", 0, 0)
	IconeRole(c.icone, role, true)
	c.moins = NouveauBouton(c, "-", 22, 22)
	c.moins:SetPoint("LEFT", c.icone, "RIGHT", 4, 0)
	c.valeur = c:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	c.valeur:SetPoint("LEFT", c.moins, "RIGHT", 4, 0)
	c.valeur:SetWidth(24)
	c.plus = NouveauBouton(c, "+", 22, 22)
	c.plus:SetPoint("LEFT", c.valeur, "RIGHT", 4, 0)
	c.moins:SetScript("OnClick", function() Changer(role, -1) end)
	c.plus:SetScript("OnClick", function() Changer(role, 1) end)
	return c
end

local function CreerPageMonGroupe(f)
	local p = NouvellePage(f)
	p.categorieChoisie = nil
	p.besoin = nil
	-- choix du rôle, en haut à droite (visible en création comme une fois l'annonce publiée)
	p.choixRole = CreerChoixRole(p)
	p.choixRole:SetPoint("TOPRIGHT", p, "TOPRIGHT", -16, -30)
	p.choixRole:SetFrameLevel(p:GetFrameLevel() + 5)

	----------------------------------------------------------------- création
	-- deux écrans, comme l'officiel : d'abord les catégories, puis les détails (avec « Retour »)
	local creer = CreateFrame("Frame", nil, p)
	creer:SetAllPoints(p)
	p.creer = creer
	p.etape = "categories"

	-- bande de pierre : titre (catégorie choisie) et consigne
	creer.titre = creer:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	creer.titre:SetPoint("TOPLEFT", creer, "TOPLEFT", 74, -34)
	creer.consigne = creer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	creer.consigne:SetPoint("TOPLEFT", creer.titre, "BOTTOMLEFT", 0, -6)

	-- écran 1 : grands boutons de catégorie empilés
	creer.ecranCategories = CreateFrame("Frame", nil, creer)
	creer.ecranCategories:SetAllPoints(creer)
	creer.boutonsCategories = {}

	local t1 = creer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	t1:SetPoint("TOPLEFT", creer, "TOPLEFT", 16, -86)
	t1:SetText("Contenu")
	local t1b = creer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	t1b:SetPoint("TOPRIGHT", creer, "TOPRIGHT", -44, -86)
	t1b:SetText("Niveau  ·  Joueurs")

	creer.defile, creer.liste = NouvelleListe(creer, LIGNE_HAUT - 4, HAUTEUR - 300)
	creer.lignes = {}

	local separation = creer:CreateTexture(nil, "ARTWORK")
	if AtlasExiste("groupfinder-ScrollLine") then
		separation:SetAtlas("groupfinder-ScrollLine", true)
	else
		separation:SetColorTexture(1, 0.82, 0, 0.3)
		separation:SetHeight(1)
	end
	separation:SetPoint("LEFT", creer, "TOPLEFT", 4, -304)
	separation:SetPoint("RIGHT", creer, "TOPRIGHT", -4, -304)

	local t2 = creer:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t2:SetPoint("TOPLEFT", creer, "TOPLEFT", 16, -314)
	t2:SetText("Places recherchées")
	creer.taille = creer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	creer.taille:SetPoint("TOPRIGHT", creer, "TOPRIGHT", -16, -316)
	creer.compteurs = {}
	local function Changer(role, delta)
		if not p.besoin then return end
		local e = etat.fenetre.choix and InfoContenu(etat.fenetre.choix)
		local taille = TailleMaxContenu(e)
		local total = p.besoin.tank + p.besoin.heal + p.besoin.dps
		local nouveau = (p.besoin[role] or 0) + delta
		if nouveau < 0 or (delta > 0 and total >= taille) then return end
		p.besoin[role] = nouveau
		Rafraichir()
	end
	for i, role in ipairs(ROLES) do
		local c = CreerCompteurRole(creer, role, Changer)
		c:SetPoint("TOPLEFT", creer, "TOPLEFT", 20 + (i - 1) * 140, -334)
		creer.compteurs[role] = c
	end

	local t3 = creer:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t3:SetPoint("TOPLEFT", creer, "TOPLEFT", 16, -376)
	t3:SetText("Commentaire")
	local saisie = CreateFrame("EditBox", nil, creer, "InputBoxTemplate")
	saisie:SetSize(400, 22)
	saisie:SetPoint("TOPLEFT", creer, "TOPLEFT", 24, -396)
	saisie:SetAutoFocus(false)
	saisie:SetMaxLetters(50)
	saisie:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	saisie:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	creer.saisie = saisie

	creer.publier = NouveauBouton(creer, "Publier le groupe", 150, 28)
	creer.publier:SetPoint("BOTTOMRIGHT", creer, "BOTTOMRIGHT", -21, 16)
	creer.publier:SetScript("OnClick", function()
		saisie:ClearFocus()
		CreerMonAnnonce(etat.fenetre.choix, p.besoin or BesoinParDefaut(5), saisie:GetText())
	end)
	local retour = NouveauBouton(creer, "Retour", 111, 28)
	retour:SetPoint("BOTTOMLEFT", creer, "BOTTOMLEFT", 21, 16)
	retour:SetScript("OnClick", function()
		saisie:ClearFocus()
		p.etape = "categories"
		Rafraichir()
	end)

	-- « Rappel » : la guilde reçoit une bulle silencieuse toutes les 5 min tant que le groupe cherche
	local rappel = CreateFrame("CheckButton", nil, creer, "UICheckButtonTemplate")
	rappel:SetSize(22, 22)
	rappel:SetPoint("LEFT", retour, "RIGHT", 14, 0)
	local texteRappel = rappel.Text or rappel.text
	if not texteRappel then
		texteRappel = rappel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		texteRappel:SetPoint("LEFT", rappel, "RIGHT", 1, 0)
	end
	texteRappel:SetFontObject("GameFontHighlightSmall")
	texteRappel:SetText("Rappel")
	rappel:SetScript("OnShow", function(self)
		local db = DB()
		self:SetChecked(db and db.rappelGroupe and true or false)
	end)
	rappel:SetScript("OnClick", function(self)
		local db = DB()
		if db then db.rappelGroupe = self:GetChecked() and true or nil end
	end)
	rappel:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Rappel")
		GameTooltip:AddLine("Tant que ton groupe cherche du monde, la guilde reçoit une bulle de rappel (sans son) toutes les 5 minutes.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	rappel:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- écran 2 : détails (tout ce qui précède, sauf le titre et la consigne)
	local details = CreateFrame("Frame", nil, creer)
	details:SetAllPoints(creer)
	creer.details = details
	for _, element in ipairs({ t1, t1b, separation, t2, creer.taille, t3, creer.defile, saisie, creer.publier, retour, rappel }) do
		element:SetParent(details)
	end
	for _, c in pairs(creer.compteurs) do c:SetParent(details) end

	-- « Voir tous les niveaux » : sinon, seulement les contenus déjà accessibles à mon niveau
	local tous = CreateFrame("CheckButton", nil, details, "UICheckButtonTemplate")
	tous:SetSize(20, 20)
	tous:SetPoint("LEFT", t1, "RIGHT", 16, 0)
	local texteTous = tous.Text or tous.text
	if not texteTous then
		texteTous = tous:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		texteTous:SetPoint("LEFT", tous, "RIGHT", 1, 0)
	end
	texteTous:SetFontObject("GameFontHighlightSmall")
	texteTous:SetText("Voir tous les niveaux")
	tous:SetScript("OnShow", function(self)
		local db = DB()
		self:SetChecked(db and db.tousNiveaux and true or false)
	end)
	tous:SetScript("OnClick", function(self)
		local db = DB()
		if db then db.tousNiveaux = self:GetChecked() and true or nil end
		creer.defile:SetVerticalScroll(0)
		Rafraichir()
	end)
	tous:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Voir tous les niveaux")
		GameTooltip:AddLine("Décoché : seulement les contenus accessibles à ton niveau.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	tous:SetScript("OnLeave", function() GameTooltip:Hide() end)

	----------------------------------------------------------------- gestion
	local gerer = CreateFrame("Frame", nil, p)
	gerer:SetAllPoints(p)
	p.gerer = gerer

	-- bande de pierre : contenu de l'annonce
	gerer.icone = gerer:CreateTexture(nil, "ARTWORK")
	gerer.icone:SetSize(78, 48)
	gerer.icone:SetPoint("TOPLEFT", gerer, "TOPLEFT", 70, -27)
	gerer.nom = gerer:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	gerer.nom:SetPoint("TOPLEFT", gerer, "TOPLEFT", 156, -32)
	gerer.nom:SetPoint("RIGHT", gerer, "RIGHT", -150, 0) -- laisse la place au choix du rôle
	gerer.nom:SetJustifyH("LEFT")
	gerer.infos = gerer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	gerer.infos:SetPoint("TOPLEFT", gerer.nom, "BOTTOMLEFT", 0, -6)
	gerer.entree = CreerBoutonEntree(gerer)
	gerer.entree:SetPoint("BOTTOMRIGHT", gerer.icone, "BOTTOMRIGHT", 2, -2)

	-- encart : composition
	local tc = gerer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	tc:SetPoint("TOPLEFT", gerer, "TOPLEFT", 16, -86)
	tc:SetText("Composition")
	gerer.places = CreerEmplacements(gerer, 16)
	gerer.places:SetPoint("TOPRIGHT", gerer, "TOPRIGHT", -16, -82)
	gerer.membres = {}
	for i = 1, 5 do
		local l = CreateFrame("Frame", nil, gerer)
		l:SetSize(400, 20)
		l:SetPoint("TOPLEFT", gerer, "TOPLEFT", 22, -108 - (i - 1) * 22)
		l.role = l:CreateTexture(nil, "ARTWORK")
		l.role:SetSize(18, 18)
		l.role:SetPoint("LEFT", l, "LEFT", 0, 0)
		l.nom = l:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		l.nom:SetPoint("LEFT", l.role, "RIGHT", 6, 0)
		gerer.membres[i] = l
	end
	gerer.resumeGrand = gerer:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	gerer.resumeGrand:SetPoint("TOPLEFT", gerer, "TOPLEFT", 22, -112)

	local ligne = gerer:CreateTexture(nil, "ARTWORK")
	if AtlasExiste("groupfinder-ScrollLine") then
		ligne:SetAtlas("groupfinder-ScrollLine", true)
	else
		ligne:SetColorTexture(1, 0.82, 0, 0.3)
		ligne:SetHeight(1)
	end
	ligne:SetPoint("LEFT", gerer, "TOPLEFT", 4, -222)
	ligne:SetPoint("RIGHT", gerer, "TOPRIGHT", -4, -222)

	-- encart : candidats
	local tca = gerer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	tca:SetPoint("TOPLEFT", gerer, "TOPLEFT", 16, -230)
	tca:SetText("Candidats")
	gerer.aucun = gerer:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	gerer.aucun:SetPoint("TOP", gerer, "TOP", 0, -270)
	gerer.aucun:SetText("Pas encore de candidat.")
	gerer.candidats = {}
	gerer.decalage = 0 -- premier candidat affiché (molette sur la liste)
	local function Defiler(_, delta)
		local maxi = math.max(0, #etat.candidats - #gerer.candidats)
		gerer.decalage = math.max(0, math.min(maxi, gerer.decalage - delta))
		if Rafraichir then Rafraichir() end
	end
	local zone = CreateFrame("Frame", nil, gerer)
	zone:SetPoint("TOPLEFT", gerer, "TOPLEFT", 10, -248)
	zone:SetSize(LARGEUR_LISTE + 20, 6 * 30)
	zone:EnableMouseWheel(true)
	zone:SetScript("OnMouseWheel", Defiler)
	gerer.plus = gerer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	gerer.plus:SetPoint("TOPRIGHT", zone, "BOTTOMRIGHT", -4, -2)
	for i = 1, 6 do
		local l = CreateFrame("Frame", nil, gerer)
		l:SetSize(LARGEUR_LISTE + 20, 28)
		l:SetPoint("TOPLEFT", gerer, "TOPLEFT", 10, -248 - (i - 1) * 30)
		l:EnableMouseWheel(true)
		l:SetScript("OnMouseWheel", Defiler)
		l.fond = l:CreateTexture(nil, "BACKGROUND")
		l.fond:SetAllPoints(l)
		PoserAtlas(l.fond, "groupfinder-highlightbar", { 0.15, 0.13, 0.1, 0.8 })
		l.role = l:CreateTexture(nil, "ARTWORK")
		l.role:SetSize(20, 20)
		l.role:SetPoint("LEFT", l, "LEFT", 6, 0)
		l.classe = l:CreateTexture(nil, "ARTWORK")
		l.classe:SetSize(16, 16)
		l.classe:SetPoint("LEFT", l.role, "RIGHT", 4, 0)
		l.nom = l:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		l.nom:SetPoint("LEFT", l.classe, "RIGHT", 4, 0)
		l.inviter = NouveauBouton(l, "Inviter", 76, 22)
		l.inviter:SetPoint("RIGHT", l, "RIGHT", -84, 0)
		l.refuser = NouveauBouton(l, "Refuser", 76, 22)
		l.refuser:SetPoint("RIGHT", l, "RIGHT", -4, 0)
		gerer.candidats[i] = l
	end

	-- commentaire sous les infos (la bande du bas sert aux boutons)
	gerer.commentaire = gerer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	gerer.commentaire:SetPoint("TOPLEFT", gerer.infos, "BOTTOMLEFT", 0, -3)
	gerer.commentaire:SetPoint("RIGHT", gerer, "RIGHT", -150, 0)
	gerer.commentaire:SetJustifyH("LEFT")
	gerer.commentaire:SetWordWrap(false)
	-- bande du bas : [Style ▾] [Rendre public] [Retirer l'annonce]
	gerer.fermer = NouveauBouton(gerer, "Retirer l'annonce", 150, 28)
	gerer.fermer:SetPoint("BOTTOMRIGHT", gerer, "BOTTOMRIGHT", -21, 16)
	if ns.CreerBoutonsPublic then
		gerer.public = ns.CreerBoutonsPublic(gerer)
		gerer.public.public:SetPoint("RIGHT", gerer.fermer, "LEFT", -4, 0)
		gerer.public.style:SetPoint("RIGHT", gerer.public.public, "LEFT", -4, 0)
	end
	gerer.fermer:SetScript("OnClick", function() FermerMonAnnonce("retirée par toi") end)
	return p
end

local function RafraichirCreation(p)
	local creer = p.creer
	local cat = Catalogue()

	local enDetails = p.etape == "details" and p.categorieChoisie ~= nil
	creer.ecranCategories:SetShown(not enDetails)
	creer.details:SetShown(enDetails)

	if not enDetails then
		-- écran 1 : grands boutons de catégorie empilés et centrés, à leur taille réelle
		creer.titre:SetText("Créer un groupe")
		creer.consigne:SetText(not IsInGuild() and "|cffff6666Tu n'es pas dans une guilde.|r"
			or (not PeutAnnoncer() and "|cffff6666Seul le chef du groupe peut publier.|r"
			or "Choisis une catégorie."))
		local _, h = TailleBoutonCategorie()
		for i, c in ipairs(Categories()) do
			local b = creer.boutonsCategories[i]
			if not b then
				b = CreerBoutonCategorie(creer.ecranCategories)
				creer.boutonsCategories[i] = b
			end
			b:ClearAllPoints()
			b:SetPoint("TOP", creer.ecranCategories, "TOP", -2, LIGNE_HAUT - 8 - (i - 1) * (h + 6))
			if not PoserAtlas(b.icone, c.atlas) then PoserAtlas(b.icone, ATLAS_DEFAUT, { 0.2, 0.2, 0.2, 1 }) end
			b.texte:SetText(c.nom)
			b:SetScript("OnClick", function()
				if p.categorieChoisie ~= c.id then
					p.categorieChoisie = c.id
					etat.fenetre.choix = nil
					creer.defile:SetVerticalScroll(0)
				end
				p.etape = "details"
				Rafraichir()
			end)
			b:Show()
		end
		for i = #Categories() + 1, #creer.boutonsCategories do creer.boutonsCategories[i]:Hide() end
		return
	end

	-- écran 2 : titre = catégorie choisie
	for _, c in ipairs(Categories()) do
		if c.id == p.categorieChoisie then creer.titre:SetText(c.nom) end
	end

	-- contenus de la catégorie
	local nb = 0
	for _, e in ipairs(cat) do
		-- contenus accessibles à mon niveau (sauf si « Voir tous les niveaux » est coché)
		local dbN = DB()
		local accessible = (dbN and dbN.tousNiveaux) or (e.min or 0) <= (UnitLevel("player") or 0)
		if e.idCategorie == p.categorieChoisie and accessible then
			nb = nb + 1
			local b = creer.lignes[nb]
			if not b then
				b = CreerLigneActivite(creer.liste)
				creer.lignes[nb] = b
			end
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", creer.liste, "TOPLEFT", 0, -(nb - 1) * HAUTEUR_ACTIVITE)
			-- petite icône seulement si c'est une vraie icône de donjon (pas l'image de catégorie)
			b.nom:ClearAllPoints()
			MajBoutonEntree(b.entree, e)
			local gauche = b.entree:IsShown() and 26 or 4  -- place du bouton carte
			b.icone:ClearAllPoints()
			b.icone:SetPoint("LEFT", b, "LEFT", gauche, 0)
			if e.icone and e.icone.fichier then
				PoserIcone(b.icone, e.icone)
				b.icone:Show()
				b.nom:SetPoint("LEFT", b.icone, "RIGHT", 6, 0)
			else
				b.icone:Hide()
				b.nom:SetPoint("LEFT", b, "LEFT", gauche + 6, 0)
			end
			b.nom:SetPoint("RIGHT", b, "RIGHT", -130, 0)
			b.nom:SetText(e.nom)
			b.infos:SetText(("%s%s|r  ·  %d j."):format(CouleurNiveau(e), TexteNiveaux(e), e.taille or 5))
			b.choisi:SetShown(etat.fenetre.choix == e.code)
			b:SetScript("OnClick", function()
				if etat.fenetre.choix ~= e.code then
					etat.fenetre.choix = e.code
					p.besoin = BesoinParDefaut(e.taille or 5)
				end
				Rafraichir()
			end)
			b:Show()
		end
	end
	for i = nb + 1, #creer.lignes do creer.lignes[i]:Hide() end
	creer.liste:SetHeight(math.max(10, nb * HAUTEUR_ACTIVITE))

	-- composition
	local e = etat.fenetre.choix and InfoContenu(etat.fenetre.choix)
	local taille = TailleMaxContenu(e)
	if not p.besoin then p.besoin = BesoinParDefaut(e and e.taille or 5) end
	local total = p.besoin.tank + p.besoin.heal + p.besoin.dps
	for _, role in ipairs(ROLES) do
		local c = creer.compteurs[role]
		c.valeur:SetText(p.besoin[role])
		c.moins:SetEnabled(p.besoin[role] > 0)
		c.plus:SetEnabled(total < taille)
	end
	if EstPerso(e) then
		creer.taille:SetText(("%d place(s) (jusqu'à %d)"):format(total, taille))
	else
		creer.taille:SetText(("%d place(s) sur %d"):format(total, taille))
	end

	local possible = IsInGuild() and PeutAnnoncer() and etat.fenetre.choix ~= nil and total > 0
	creer.publier:SetEnabled(possible)
	if not IsInGuild() then
		creer.consigne:SetText("|cffff6666Tu n'es pas dans une guilde.|r")
	elseif not PeutAnnoncer() then
		creer.consigne:SetText("|cffff6666Seul le chef du groupe peut publier.|r")
	elseif not etat.fenetre.choix then
		creer.consigne:SetText("Choisis un contenu dans la liste.")
	else
		creer.consigne:SetText("Contenu : |cffffd100" .. (e and e.nom or "?") .. "|r")
	end
end

local function RafraichirGestion(p)
	local g = p.gerer
	local e = InfoContenu(etat.monAnnonce.code)
	PoserIcone(g.icone, e.icone)
	g.nom:SetText(e.nom)
	g.infos:SetText(("%d/%d joueurs  ·  %s%s|r"):format(NombreMembres(), etat.monAnnonce.taille, CouleurNiveau(e), TexteNiveaux(e)))
	g.commentaire:SetText(etat.monAnnonce.commentaire ~= "" and ("« " .. etat.monAnnonce.commentaire .. " »") or "")
	if g.public then g.public.maj(etat.monAnnonce, e.nom) end

	local pris, membres = Composition(etat.monAnnonce.besoin)
	RangerEmplacements(g.places)
	MajEmplacements(g.places, etat.monAnnonce.besoin, pris, etat.monAnnonce.taille)
	MajBoutonEntree(g.entree, e)

	-- une ligne par place façon FF14 (groupes de 5)
	if etat.monAnnonce.taille <= 5 then
		g.resumeGrand:Hide()
		local lignes, restants = {}, {}
		for _, m in ipairs(membres) do restants[#restants + 1] = m end
		for _, role in ipairs(ROLES) do
			for _ = 1, etat.monAnnonce.besoin[role] or 0 do
				local occupant
				for k, m in ipairs(restants) do
					if m.role == role then occupant = table.remove(restants, k); break end
				end
				lignes[#lignes + 1] = { role = role, membre = occupant }
			end
		end
		for _, l in ipairs(lignes) do
			if not l.membre and #restants > 0 then l.membre = table.remove(restants, 1) end
		end
		for i, l in ipairs(g.membres) do
			local d = lignes[i]
			if d then
				IconeRole(l.role, d.role, d.membre ~= nil)
				if d.membre then
					l.nom:SetText(d.membre.nom .. (d.membre.role and "" or "  |cff999999(rôle inconnu)|r"))
				else
					l.nom:SetText("|cff777777— place libre —|r")
				end
				l:Show()
			else
				l:Hide()
			end
		end
	else
		for _, l in ipairs(g.membres) do l:Hide() end
		g.resumeGrand:SetText(("%s %d/%d    %s %d/%d    %s %d/%d"):format(
			TexteRole("tank"), pris.tank, etat.monAnnonce.besoin.tank, TexteRole("heal"), pris.heal, etat.monAnnonce.besoin.heal,
			TexteRole("dps"), pris.dps, etat.monAnnonce.besoin.dps))
		g.resumeGrand:Show()
	end

	g.aucun:SetShown(#etat.candidats == 0)
	g.decalage = math.max(0, math.min(g.decalage or 0, #etat.candidats - #g.candidats))
	local caches = #etat.candidats - #g.candidats
	g.plus:SetText(caches > 0 and ("%d-%d sur %d candidats (molette)"):format(g.decalage + 1,
		g.decalage + #g.candidats, #etat.candidats) or "")
	for i, l in ipairs(g.candidats) do
		local cd = etat.candidats[i + g.decalage]
		if cd then
			IconeRole(l.role, cd.role, true)
			IconeClasse(l.classe, cd.classe)
			local plein = cd.role and etat.monAnnonce.besoin[cd.role] and (pris[cd.role] or 0) >= etat.monAnnonce.besoin[cd.role]
			l.nom:SetText(("%s%s|r (%d)%s%s"):format(CouleurClasse(cd.classe), NomCourt(cd.nom), cd.niveau or 0,
				cd.statut == "invite" and "  |cff999999invité|r" or "",
				plein and "  |cffff6666rôle déjà pris|r" or ""))
			l.inviter:SetScript("OnClick", function() Inviter(cd.nom) end)
			l.refuser:SetScript("OnClick", function() Refuser(cd.nom) end)
			-- invitation sans réponse (déclinée, échouée) : on peut réinviter après quelques secondes
			l.inviter:SetText(cd.statut == "invite" and "Réinviter" or "Inviter")
			l.inviter:SetEnabled(cd.statut ~= "invite" or GetTime() - (cd.invite or 0) > 10)
			l:Show()
		else
			l:Hide()
		end
	end
end

--------------------------------------------------------------------------------
-- Assemblage
--------------------------------------------------------------------------------

local function ChoisirOnglet(i)
	if not etat.fenetre then return end
	etat.fenetre.onglet = i
	MarquerOnglet(etat.fenetre, i)
	etat.fenetre.pageParcourir:SetShown(i == 1)
	etat.fenetre.pageMonGroupe:SetShown(i == 2)
	Rafraichir()
end

local function CreerFenetre()
	local f = CreerCadrePrincipal()
	f.pageParcourir = CreerPageParcourir(f, function() ChoisirOnglet(2) end)
	f.pageMonGroupe = CreerPageMonGroupe(f)
	CreerOnglets(f, { "Parcourir", "Mon groupe" }, ChoisirOnglet)
	-- quêtes en commun, accrochées à droite (GuildUp_Quetes.lua)
	if ns.CreerPanneauQuetes then
		f.quetes = ns.CreerPanneauQuetes(f)
		-- l'ensemble (groupes + quêtes) reste centré à l'écran
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", -165, 0)
	end
	f.onglet = 1
	f:SetScript("OnShow", function() ChoisirOnglet(f.onglet or 1) end)
	f:Hide()
	return f
end

-- Nombre de groupes de la guilde qui cherchent encore du monde (hors le mien)
local function NombreGroupes()
	local n = 0
	for id, a in pairs(etat.annonces) do
		if not (etat.monAnnonce and id == etat.monAnnonce.id) and (a.membres or 1) < (a.taille or 5) then n = n + 1 end
	end
	return n
end
ns.NombreGroupes = NombreGroupes

-- Suis-je en attente ? (mon annonce ouverte, une candidature envoyée, ou mon groupe public)
ns.EnAttente = function()
	if etat.monAnnonce then return true end
	for _, etat in pairs(etat.candidatures) do
		if etat == "envoyee" then return true end
	end
	if C_LFGList and C_LFGList.HasActiveEntryInfo then
		local ok, oui = pcall(C_LFGList.HasActiveEntryInfo)
		if ok and oui then return true end
	end
	return false
end

Rafraichir = function()
	-- compteur du médaillon GuildUpSMB (et accueil de la fenêtre), même fenêtre fermée
	if ns.MajBouton then ns.MajBouton() end
	if ns.MajInterface then ns.MajInterface() end
	if not etat.fenetre or not etat.fenetre:IsShown() then return end
	local n = 0
	for id in pairs(etat.annonces) do
		if not (etat.monAnnonce and id == etat.monAnnonce.id) then n = n + 1 end
	end
	if etat.fenetre.onglets then
		etat.fenetre.onglets[1]:SetText(n > 0 and ("Parcourir (" .. n .. ")") or "Parcourir")
		etat.fenetre.onglets[2]:SetText((etat.monAnnonce and #etat.candidats > 0) and ("Mon groupe (" .. #etat.candidats .. ")") or "Mon groupe")
		for _, o in ipairs(etat.fenetre.onglets) do
			if PanelTemplates_TabResize then pcall(PanelTemplates_TabResize, o, 0) end
		end
	end
	for _, w in ipairs(choixRoles) do MajChoixRole(w) end
	if etat.fenetre.onglet == 1 then
		RafraichirParcourir(etat.fenetre.pageParcourir)
	else
		local p = etat.fenetre.pageMonGroupe
		p.creer:SetShown(etat.monAnnonce == nil)
		p.gerer:SetShown(etat.monAnnonce ~= nil)
		if etat.monAnnonce then RafraichirGestion(p) else RafraichirCreation(p) end
	end
end

ns.BasculerGroupes = function()
	etat.fenetre = etat.fenetre or (ns.AvecSons and ns.AvecSons(CreerFenetre(), "fenetre")) or CreerFenetre()
	etat.fenetre:SetShown(not etat.fenetre:IsShown())
end

-- Test seul activé / coupé : on montre ou on retire la copie « test » de mon annonce
ns.SurChangementTestSolo = function()
	if ns.TestSolo and ns.TestSolo() then
		if etat.monAnnonce then DiffuserMonAnnonce() end
	else
		for id in pairs(etat.annonces) do
			if id:find("^test:") then etat.annonces[id] = nil; etat.candidatures[id] = nil end
		end
	end
	Rafraichir()
end

-- Ouvre la fenêtre sur « Parcourir » (clic sur la bulle d'alerte)
ns.OuvrirGroupes = function()
	etat.fenetre = etat.fenetre or (ns.AvecSons and ns.AvecSons(CreerFenetre(), "fenetre")) or CreerFenetre()
	etat.fenetre.onglet = 1
	if etat.fenetre:IsShown() then ChoisirOnglet(1) else etat.fenetre:Show() end
end

-- Pour /smb diag
ns.DiagGroupes = function(L)
	if ns.CatalogueGroupes then ns.CatalogueGroupes.Diag(L) end
	local okF, nomF, royaumeF = pcall(UnitFullName, "player")
	local okG, nomG = pcall(GetUnitName, "player", true)
	L(("  noms : UnitName=%s, UnitFullName=%s-%s, GetUnitName=%s, normalisé=%s, reçu du serveur=%s"):format(
		tostring(UnitName("player")), tostring(okF and nomF), tostring(okF and royaumeF), tostring(okG and nomG),
		tostring(MonNom()), tostring(etat.dernierNomRecuDeMoi or "pas encore (publie une annonce pour le voir)")))
	local atlas = {}
	for _, a in ipairs({ "groupfinder-icon-role-large-tank", "groupfinder-icon-role-large-heal", "groupfinder-icon-role-large-dps",
		"groupfinder-highlightbar", "groupfinder-Stat-StoneBG", "groupfinder-button-dungeons", "groupfinder-icon-leader" }) do
		atlas[#atlas + 1] = a .. "=" .. tostring(AtlasExiste(a))
	end
	L("  atlas : " .. table.concat(atlas, ", "))
end

-- appelée par GuildUp_Groupes.lua quand les annonces ou les candidatures changent
ns.RafraichirGroupes = function() if Rafraichir then Rafraichir() end end
