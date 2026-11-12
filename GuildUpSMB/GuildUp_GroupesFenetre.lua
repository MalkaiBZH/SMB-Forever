-- GuildUpSMB : page « Groupes » de la fenêtre GuildUpSMB (style sombre et doré, kit ns.UI).
-- Le protocole, l'état (annonces, candidatures) et les actions sont dans GuildUp_Groupes.lua ;
-- le catalogue des contenus dans GuildUp_Catalogue.lua. Aucun message réseau ici, sauf « Q »
-- (Actualiser : « renvoyez-moi vos annonces », une fois toutes les 10 s au plus).
-- Onglets :
--   Parcourir : les annonces de la guilde (la plus récente d'abord, complètes comprises), filtres par
--     catégorie et recherche ; par annonce : portrait du chef, contenu (+ entrée sur la carte), niveaux,
--     chef, âge, commentaire, places par rôle, rôle recherché, bouton (Postuler / Annuler / Refusé /
--     Complet / Rôle complet / Ton groupe) ; info-bulle avec les membres et les places libres.
--   Mon groupe : sans annonce, le formulaire (catégorie, contenu, places recherchées par rôle,
--     commentaire, rappel, Publier) ; avec une annonce, sa gestion (composition, candidats à inviter ou
--     refuser, style de jeu et groupe public, Retirer l'annonce).
-- Fonctions gardées pour les autres fichiers : ns.OuvrirGroupes, ns.BasculerGroupes, ns.NombreGroupes,
-- ns.EnAttente, ns.SurChangementDeRole, ns.SurChangementTestSolo, ns.RafraichirGroupes, ns.DiagGroupes.

local NOM_ADDON, ns = ...

local G = ns.Groupes
local etat = G.etat
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
local InfoContenu = G.InfoContenu
local Inviter = G.Inviter
local MonNom = G.MonNom
local NomCourt = G.NomCourt
local NombreMembres = G.NombreMembres
local PeutAnnoncer = G.PeutAnnoncer
local PlacesLibres = G.PlacesLibres
local PoserIcone = G.PoserIcone
local Postuler = G.Postuler
local Prenom = G.Prenom
local ROLES = G.ROLES
local Refuser = G.Refuser
local TailleMaxContenu = G.TailleMaxContenu
local TexteNiveaux = G.TexteNiveaux
local TexteRole = G.TexteRole
local Normaliser = ns.Normaliser

local UI = ns.UI
local C = UI.C

-- toujours : médaillon (pastille, anneau) et fenêtre GuildUpSMB (accueil ou cette page, si affichée)
local function Rafraichir()
	if ns.MajBouton then ns.MajBouton() end
	if ns.MajInterface then ns.MajInterface() end
end

--------------------------------------------------------------------------------
-- Petits outils
--------------------------------------------------------------------------------

local MARGE = 16

-- catégorie de filtre d'un contenu : 2 Donjons, 3 Raids, 4 Quêtes, 5 Autres (1 = Tout)
local function FiltreDe(e)
	local c = e and e.idCategorie
	if c == 2 or c == "Donjons" then return 2 end
	if c == 114 or c == "Raids" then return 3 end
	if c == 116 or c == "Quêtes" then return 4 end
	return 5
end

local function Simplifier(t)
	return ns.Simplifier and ns.Simplifier(t or "") or (t or ""):lower()
end

-- places d'une annonce, une par joueur : { role, pris }
local function ListePlaces(besoin, pris)
	local res = {}
	for _, role in ipairs(ROLES) do
		for n = 1, (besoin and besoin[role] or 0) do
			res[#res + 1] = { role = role, pris = n <= (pris and pris[role] or 0) }
		end
	end
	return res
end

-- « Tank 1/1  Heal 0/1  DPS 2/3 » (grands groupes)
local function TextePlaces(besoin, pris)
	local t = {}
	for _, role in ipairs(ROLES) do
		t[#t + 1] = UI.TexteRole(role) .. " " .. (pris and pris[role] or 0) .. "/" .. (besoin and besoin[role] or 0)
	end
	return table.concat(t, "   ")
end

-- bouton « Entrée sur la carte » (montré seulement si l'entrée du contenu est connue)
local function BoutonEntree(parent)
	local bt = CreateFrame("Button", nil, parent)
	bt:SetSize(18, 18)
	bt.icone = bt:CreateTexture(nil, "ARTWORK")
	bt.icone:SetAllPoints(bt)
	bt.icone:SetTexture("Interface\\Minimap\\Tracking\\POIArrow")
	if AtlasExiste("Waypoint-MapPin-Untracked") then bt.icone:SetAtlas("Waypoint-MapPin-Untracked") end
	UI.Survol(bt, 0.15)
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
	bt.Poser = function(self, e)
		local connue = e and ns.EntreeDonjon and ns.EntreeDonjon(e.nom, e.mapID)
		self.nom, self.mapID = e and e.nom, e and e.mapID
		self:SetShown(connue and true or false)
	end
	bt:Hide()
	return bt
end

-- petit rond de la couleur d'un rôle + son nom
local function PastilleRole(parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(70, 16)
	f.rond = f:CreateTexture(nil, "ARTWORK")
	f.rond:SetTexture(UI.ROND)
	f.rond:SetSize(10, 10)
	f.rond:SetPoint("LEFT", f, "LEFT", 0, 0)
	f.texte = UI.Texte(f, "GameFontHighlightSmall")
	f.texte:SetPoint("LEFT", f.rond, "RIGHT", 6, 0)
	f.Poser = function(self, role)
		local r = role and UI.ROLES[role]
		if r then
			self.rond:SetVertexColor(r.plein[1], r.plein[2], r.plein[3], 1)
			self.texte:SetText(UI.TexteRole(role))
		else
			self.rond:SetVertexColor(0.4, 0.4, 0.4, 1)
			self.texte:SetText("|cff999999rôle ?|r")
		end
	end
	return f
end

--------------------------------------------------------------------------------
-- Onglet « Parcourir »
--------------------------------------------------------------------------------

local NOMS_FILTRES = { "Tout", "Donjons", "Raids", "Quêtes", "Autres" }
local HAUTEUR_ANNONCE, ECART_ANNONCE = 68, 6
local derniereDemande = -100

local function InfobulleAnnonce(self)
	local a, e = self.annonce, self.contenu
	if not a then return end
	local tt = GameTooltip
	tt:SetOwner(self, "ANCHOR_RIGHT")
	tt:SetText(e.nom or "?", C.ors[1], C.ors[2], C.ors[3])
	tt:AddLine(TexteNiveaux(e) .. " · " .. (a.membres or 1) .. "/" .. (a.taille or 5) .. " joueurs", 1, 1, 1)
	tt:AddLine("Chef : " .. CouleurClasse(a.classe) .. NomCourt(a.chef or "?") .. "|r" .. ((a.niveau or 0) > 0 and (" (" .. a.niveau .. ")") or ""), 1, 1, 1)
	if ns.LignesIdentite and not a.estMoi then ns.LignesIdentite(tt, a.chef) end
	if a.liste and #a.liste > 0 then
		for _, m in ipairs(a.liste) do
			if Prenom(m.nom) ~= Prenom(a.chef) then
				tt:AddLine("  " .. NomCourt(m.nom) .. " — " .. TexteRole(m.role), 0.9, 0.9, 0.9)
			end
		end
	end
	for _, role in ipairs(ROLES) do
		local b = a.besoin and a.besoin[role] or 0
		if b > 0 then
			local libres = PlacesLibres(a, role) or 0
			tt:AddLine(UI.TexteRole(role) .. " : " .. (a.pris and a.pris[role] or 0) .. "/" .. b
				.. (libres > 0 and ("  |cff6fd08c(" .. libres .. " libre" .. (libres > 1 and "s" or "") .. ")|r") or ""), 1, 1, 1)
		end
	end
	if a.commentaire and a.commentaire ~= "" then tt:AddLine("« " .. a.commentaire .. " »", 0.8, 0.8, 0.8, true) end
	tt:Show()
end

local function CreerAnnonce(parent)
	local r = UI.Rangee(parent, HAUTEUR_ANNONCE)
	r.portrait = UI.Portrait(r, 44)
	r.portrait:SetPoint("LEFT", r, "LEFT", 12, 0)
	r.bouton = UI.Bouton(r, "Postuler", "or", 104, 28)
	r.bouton:SetPoint("RIGHT", r, "RIGHT", -12, 0)
	r.cherche = UI.Texte(r, "GameFontHighlightSmall")
	r.cherche:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r.cherche:SetWidth(96)
	r.cherche:SetWordWrap(true)
	r.places = UI.Places(r, 10)
	r.places:SetPoint("RIGHT", r.cherche, "LEFT", -10, 0)
	r.placesTexte = UI.Texte(r, "GameFontHighlightSmall")
	r.placesTexte:SetPoint("RIGHT", r.cherche, "LEFT", -10, 0)
	r.titre = UI.Texte(r, "GameFontNormal", C.texte)
	r.titre:SetPoint("TOPLEFT", r.portrait, "TOPRIGHT", 12, 4)
	r.entree = BoutonEntree(r)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("TOPLEFT", r.titre, "BOTTOMLEFT", 0, -4)
	r.sous:SetPoint("RIGHT", r.places, "LEFT", -10, 0)
	r.commentaire = UI.Texte(r, "GameFontDisableSmall")
	r.commentaire:SetPoint("TOPLEFT", r.sous, "BOTTOMLEFT", 0, -3)
	r.commentaire:SetPoint("RIGHT", r.places, "LEFT", -10, 0)
	r:SetScript("OnEnter", InfobulleAnnonce)
	r:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return r
end

local function MajAnnonce(r, a)
	local e = InfoContenu(a.code)
	r.annonce, r.contenu = a, e
	r.portrait:Poser(a.estMoi and ns.MaCle and ns.MaCle() or Normaliser(a.chef or ""), a.classe)
	r.titre:SetText(e.nom or "?")
	r.titre:SetWidth(math.min(r.titre:GetStringWidth() + 2, 300))
	r.entree:ClearAllPoints()
	r.entree:SetPoint("LEFT", r.titre, "RIGHT", 6, 0)
	r.entree:Poser(e)
	local age = a.premiere and math.floor((GetTime() - a.premiere) / 60) or 0
	r.sous:SetText(("%s|r · %s%s|r%s · %s"):format(CouleurNiveau(e) .. TexteNiveaux(e), CouleurClasse(a.classe), NomCourt(a.chef or "?"),
		(a.niveau or 0) > 0 and (" (" .. a.niveau .. ")") or "", a.estMoi and "ton annonce" or (age < 1 and "à l'instant" or ("il y a " .. age .. " min"))))
	r.commentaire:SetText((a.commentaire and a.commentaire ~= "") and ("« " .. a.commentaire .. " »") or "")
	-- places : un rond par joueur (jusqu'à 10), sinon le compte par rôle
	local places = ListePlaces(a.besoin, a.pris)
	if #places <= 10 then
		r.places:Poser(places)
		r.places:Show()
		r.placesTexte:Hide()
	else
		r.places:Hide()
		r.placesTexte:SetText(TextePlaces(a.besoin, a.pris))
		r.placesTexte:Show()
	end
	-- rôle recherché
	local complet = (a.membres or 1) >= (a.taille or 5)
	if complet then
		r.cherche:SetText("|cff999999Complet|r")
	else
		local t = {}
		for _, role in ipairs(ROLES) do if (PlacesLibres(a, role) or 0) > 0 then t[#t + 1] = UI.TexteRole(role) end end
		r.cherche:SetText(#t == 3 and "|cff999999Tous rôles|r" or (#t > 0 and ("Cherche " .. table.concat(t, ", ")) or "|cff999999Complet|r"))
	end
	-- bouton (l'ordre des cas compte)
	local cand = etat.candidatures[a.id]
	local libres = PlacesLibres(a, ns.MonRole and ns.MonRole())
	local b = r.bouton
	b:SetScript("OnClick", nil)
	if a.estMoi then
		b:Ecrire("Ton groupe"); b:Activer(false)
	elseif cand == "envoyee" then
		b:Ecrire("Annuler"); b:Activer(true)
		b:SetScript("OnClick", function() AnnulerCandidature(a.id) end)
	elseif cand == "refusee" then
		b:Ecrire("Refusé"); b:Activer(false)
	elseif complet then
		b:Ecrire("Complet"); b:Activer(false)
	elseif libres and libres <= 0 then
		b:Ecrire("Rôle complet"); b:Activer(false)
	else
		b:Ecrire("Postuler"); b:Activer(true)
		b:SetScript("OnClick", function() Postuler(a.id) end)
	end
	r:Fort(a.estMoi or cand == "envoyee")
end

-- annonces à montrer : toutes sauf la mienne (complètes comprises), la plus récente d'abord, et ma
-- propre annonce en tête (« Ton groupe »)
local function AnnoncesParcourir()
	local liste = {}
	for id, a in pairs(etat.annonces) do
		if not (etat.monAnnonce and id == etat.monAnnonce.id) then liste[#liste + 1] = a end
	end
	table.sort(liste, function(x, y) return (x.premiere or 0) > (y.premiere or 0) end)
	local m = etat.monAnnonce
	if m then
		local pris, membres = Composition(m.besoin)
		local _, classe = UnitClass("player")
		table.insert(liste, 1, { id = m.id, code = m.code, besoin = m.besoin, pris = pris, taille = m.taille,
			membres = #membres, chef = UnitName("player"), classe = classe, niveau = UnitLevel("player"),
			commentaire = m.commentaire, liste = membres, estMoi = true })
	end
	return liste
end

local function CreerParcourir(page)
	local p = CreateFrame("Frame", nil, page)
	p:SetAllPoints()
	p.filtre, p.recherche = 1, ""
	p.puces = UI.Puces(p, NOMS_FILTRES, function(i) p.filtre = i; p.puces:Choisir(i); p.liste:Haut(); Rafraichir() end)
	p.puces:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -60)
	p.puces:Choisir(1)
	p.champ = UI.Champ(p, 210, "Rechercher un contenu, un joueur")
	p.champ:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -60)
	p.champ.SurTexte = function(t) p.recherche = Simplifier(t); p.liste:Haut(); Rafraichir() end
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -100)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE + 6, 56)
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.vide:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	p.vide:SetWordWrap(true)
	p.lignes = {}

	-- bas : quêtes en commun, Actualiser
	p.quetes = UI.Cadre(p, { 0, 0, 0, 0 }, C.bordMoyen)
	p.quetes:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", MARGE, 12)
	p.quetes:SetPoint("RIGHT", p, "RIGHT", -MARGE - 130, 0)
	p.quetes:SetHeight(34)
	p.quetes.texte = UI.Texte(p.quetes, "GameFontHighlightSmall", C.texte)
	p.quetes.texte:SetPoint("LEFT", p.quetes, "LEFT", 12, 0)
	p.quetes.voir = UI.Bouton(p.quetes, "Voir les quêtes en commun", "fantome", 180, 24)
	p.quetes.voir:SetPoint("RIGHT", p.quetes, "RIGHT", -6, 0)
	p.quetes.voir:SetScript("OnClick", function() if ns.OuvrirInterface then ns.OuvrirInterface("quetes") end end)
	p.actualiser = UI.Bouton(p, "Actualiser", "fantome", 118, 34)
	p.actualiser:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, 12)
	p.actualiser:SetScript("OnClick", function()
		if GetTime() - derniereDemande >= 10 then
			derniereDemande = GetTime()
			Envoyer("Q", "GUILD")
		end
		Rafraichir()
	end)
	UI.Infobulle(p.actualiser, "Actualiser", "Redemande les annonces à la guilde (une fois toutes les 10 secondes).")

	p.Maj = function()
		local liste = AnnoncesParcourir()
		local y, n = 0, 0
		for _, a in ipairs(liste) do
			local e = InfoContenu(a.code)
			local ok = (p.filtre == 1 or FiltreDe(e) == p.filtre)
			if ok and p.recherche ~= "" then
				local texte = Simplifier((e.nom or "") .. " " .. NomCourt(a.chef or "") .. " " .. (a.commentaire or ""))
				ok = texte:find(p.recherche, 1, true) ~= nil
			end
			if ok then
				n = n + 1
				local r = p.lignes[n]
				if not r then r = CreerAnnonce(p.liste.contenu); p.lignes[n] = r end
				r:ClearAllPoints()
				r:SetPoint("TOPLEFT", p.liste.contenu, "TOPLEFT", 0, -y)
				r:SetPoint("RIGHT", p.liste.contenu, "RIGHT", 0, 0)
				MajAnnonce(r, a)
				r:Show()
				y = y + HAUTEUR_ANNONCE + ECART_ANNONCE
			end
		end
		for i = n + 1, #p.lignes do p.lignes[i]:Hide() end
		p.liste:Hauteur(y)
		p.vide:SetShown(n == 0)
		p.vide:SetText(#liste == 0 and "Aucun groupe ouvert pour l'instant. Si tu ne trouves pas ce que tu cherches, crée le tien."
			or "Aucun groupe ne correspond à ce filtre.")
		local nq = ns.QuetesEnCommun and #ns.QuetesEnCommun() or 0
		p.quetes.texte:SetText(nq > 0 and (nq .. " de tes quêtes " .. (nq > 1 and "sont" or "est") .. " aussi faite" .. (nq > 1 and "s" or "") .. " par d'autres membres.")
			or "Aucune de tes quêtes n'est faite par d'autres membres pour l'instant.")
	end
	return p
end

--------------------------------------------------------------------------------
-- Onglet « Mon groupe » : création d'une annonce
--------------------------------------------------------------------------------

local HAUTEUR_CONTENU = 32
local LARGEUR_ANNONCE = 280 -- colonne de droite (« Ton annonce »)

local function CreerCreation(page)
	local p = CreateFrame("Frame", nil, page)
	p:SetAllPoints()
	p.lignes = {}

	-- gauche : catégorie, niveaux, contenus
	p.consigne = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.consigne:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -56)
	p.consigne:SetPoint("RIGHT", p, "RIGHT", -MARGE - LARGEUR_ANNONCE - 16, 0)
	p.tousNiveaux = UI.Case(p, "Voir tous les niveaux", function(oui)
		local db = DB()
		if db then db.tousNiveaux = oui end
		p.liste:Haut()
		Rafraichir()
	end)
	p.tousNiveaux:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE - LARGEUR_ANNONCE - 16, -52)
	UI.Infobulle(p.tousNiveaux, "Voir tous les niveaux", "Décoché : seulement les contenus accessibles à ton niveau.")
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -116)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE - LARGEUR_ANNONCE - 10, 12)
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.vide:SetText("Aucun contenu à ton niveau dans cette catégorie (coche « Voir tous les niveaux »).")

	-- droite : l'annonce
	local a = UI.Carte(p, "Ton annonce")
	a:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -52)
	a:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, 12)
	a:SetWidth(LARGEUR_ANNONCE)
	p.annonce = a
	a.contenu = UI.Texte(a, "GameFontHighlight", C.texte)
	a.contenu:SetPoint("TOPLEFT", a, "TOPLEFT", 14, -40)
	a.contenu:SetPoint("RIGHT", a, "RIGHT", -14, 0)
	a.contenu:SetWordWrap(true)
	local tPlaces = UI.Texte(a, "GameFontNormalSmall", C.ors)
	tPlaces:SetPoint("TOPLEFT", a, "TOPLEFT", 14, -86)
	tPlaces:SetText("Places recherchées")
	a.compteurs = {}
	for i, role in ipairs(ROLES) do
		local l = CreateFrame("Frame", nil, a)
		l:SetSize(LARGEUR_ANNONCE - 28, 28)
		l:SetPoint("TOPLEFT", a, "TOPLEFT", 14, -104 - (i - 1) * 32)
		l.role = PastilleRole(l)
		l.role:SetPoint("LEFT", l, "LEFT", 0, 0)
		l.role:Poser(role)
		l.plus = UI.Bouton(l, "+", "fantome", 28, 24)
		l.plus:SetPoint("RIGHT", l, "RIGHT", 0, 0)
		l.valeur = UI.Texte(l, "GameFontHighlight", C.texte)
		l.valeur:SetJustifyH("CENTER")
		l.valeur:SetWidth(30)
		l.valeur:SetPoint("RIGHT", l.plus, "LEFT", -4, 0)
		l.moins = UI.Bouton(l, "-", "fantome", 28, 24)
		l.moins:SetPoint("RIGHT", l.valeur, "LEFT", -4, 0)
		local function Changer(d)
			local e = page.choix and InfoContenu(page.choix)
			page.besoin = page.besoin or BesoinParDefaut(e and e.taille or 5)
			local total = 0
			for _, r in ipairs(ROLES) do total = total + (page.besoin[r] or 0) end
			local v = (page.besoin[role] or 0) + d
			if v < 0 or (d > 0 and total >= TailleMaxContenu(e)) then return end
			page.besoin[role] = v
			Rafraichir()
		end
		l.plus:SetScript("OnClick", function() Changer(1) end)
		l.moins:SetScript("OnClick", function() Changer(-1) end)
		a.compteurs[role] = l
	end
	a.taille = UI.Texte(a, "GameFontHighlightSmall", C.gris)
	a.taille:SetPoint("TOPLEFT", a, "TOPLEFT", 14, -204)
	local tCom = UI.Texte(a, "GameFontNormalSmall", C.ors)
	tCom:SetPoint("TOPLEFT", a, "TOPLEFT", 14, -232)
	tCom:SetText("Commentaire")
	a.commentaire = UI.Champ(a, LARGEUR_ANNONCE - 28, "Ex. : on part dans 10 min")
	a.commentaire:SetPoint("TOPLEFT", a, "TOPLEFT", 14, -250)
	a.commentaire.saisie:SetMaxLetters(50)
	a.rappel = UI.Case(a, "Rappel à la guilde toutes les 5 min", function(oui)
		local db = DB()
		if db then db.rappelGroupe = oui end
	end)
	a.rappel:SetPoint("TOPLEFT", a, "TOPLEFT", 14, -290)
	UI.Infobulle(a.rappel, "Rappel", "Tant que ton groupe cherche du monde, la guilde reçoit une bulle de rappel (sans son) toutes les 5 minutes.")
	a.publier = UI.Bouton(a, "Publier le groupe", "or", LARGEUR_ANNONCE - 28, 34)
	a.publier:SetPoint("BOTTOMLEFT", a, "BOTTOMLEFT", 14, 14)
	a.publier:SetScript("OnClick", function()
		if not page.choix then return end
		a.commentaire.saisie:ClearFocus()
		CreerMonAnnonce(page.choix, page.besoin or BesoinParDefaut(5), a.commentaire:Lire())
		Rafraichir()
	end)
	a.etat = UI.Texte(a, "GameFontHighlightSmall", C.aide)
	a.etat:SetPoint("BOTTOMLEFT", a.publier, "TOPLEFT", 0, 10)
	a.etat:SetPoint("RIGHT", a, "RIGHT", -14, 0)
	a.etat:SetWordWrap(true)

	local function CreerLigneContenu()
		local r = UI.Rangee(p.liste.contenu, HAUTEUR_CONTENU - 2)
		r.icone = r:CreateTexture(nil, "ARTWORK")
		r.icone:SetSize(22, 22)
		r.icone:SetPoint("LEFT", r, "LEFT", 8, 0)
		r.nom = UI.Texte(r, "GameFontHighlight", C.texte)
		r.nom:SetPoint("LEFT", r.icone, "RIGHT", 8, 0)
		r.info = UI.Texte(r, "GameFontHighlightSmall", C.gris)
		r.info:SetPoint("RIGHT", r, "RIGHT", -10, 0)
		r.info:SetJustifyH("RIGHT")
		r.nom:SetPoint("RIGHT", r.info, "LEFT", -30, 0)
		r.entree = BoutonEntree(r)
		r.entree:SetPoint("RIGHT", r.info, "LEFT", -6, 0)
		r:SetScript("OnClick", function(self)
			if page.choix ~= self.code then
				page.choix = self.code
				page.besoin = BesoinParDefaut(self.taille or 5)
			end
			Rafraichir()
		end)
		return r
	end

	p.Maj = function()
		local db = DB()
		-- catégories (puces), refaites si la liste change (catalogue reconstruit)
		local cats = Categories()
		local cles = {}
		for _, c in ipairs(cats) do cles[#cles + 1] = tostring(c.id) end
		local cle = table.concat(cles, ",")
		if p.clesCategories ~= cle then
			p.clesCategories = cle
			if p.puces then p.puces:Hide() end
			local noms = {}
			for _, c in ipairs(cats) do noms[#noms + 1] = c.nom end
			p.puces = UI.Puces(p, noms, function(i)
				local c = cats[i]
				if c and page.categorie ~= c.id then page.categorie = c.id; p.liste:Haut() end
				Rafraichir()
			end)
			p.puces:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -78)
			p.categories = cats
		end
		if not page.categorie and cats[1] then page.categorie = cats[1].id end
		for i, c in ipairs(p.categories or {}) do if c.id == page.categorie then p.puces:Choisir(i) end end

		-- consigne
		if not IsInGuild() then
			p.consigne:SetText("|cffff6655Tu n'es pas dans une guilde.|r")
		elseif not PeutAnnoncer() then
			p.consigne:SetText("|cffff6655Seul le chef du groupe peut publier.|r")
		else
			p.consigne:SetText("Choisis une catégorie puis un contenu.")
		end
		p.tousNiveaux:Poser(db and db.tousNiveaux)

		-- contenus de la catégorie
		local niveau = UnitLevel("player") or 0
		local y, n = 0, 0
		for _, e in ipairs(Catalogue()) do
			if e.idCategorie == page.categorie and ((db and db.tousNiveaux) or (e.min or 0) <= niveau) then
				n = n + 1
				local r = p.lignes[n]
				if not r then r = CreerLigneContenu(); p.lignes[n] = r end
				r.code, r.taille = e.code, e.taille
				if e.icone and e.icone.fichier then PoserIcone(r.icone, e.icone); r.icone:Show() else r.icone:Hide() end
				r.nom:SetText(e.nom or "?")
				r.info:SetText(CouleurNiveau(e) .. TexteNiveaux(e) .. "|r · " .. (e.taille or 5) .. " j.")
				r.entree:Poser(e)
				local choisi = (page.choix == e.code)
				r:SetBackdropColor(unpack(choisi and C.actif or C.carte))
				r:Fort(choisi)
				r:ClearAllPoints()
				r:SetPoint("TOPLEFT", p.liste.contenu, "TOPLEFT", 0, -y)
				r:SetPoint("RIGHT", p.liste.contenu, "RIGHT", 0, 0)
				r:Show()
				y = y + HAUTEUR_CONTENU
			end
		end
		for i = n + 1, #p.lignes do p.lignes[i]:Hide() end
		p.liste:Hauteur(y)
		p.vide:SetShown(n == 0)

		-- l'annonce
		local e = page.choix and InfoContenu(page.choix)
		a.contenu:SetText(e and ("|cfff1cf6b" .. e.nom .. "|r") or "|cff999999Choisis un contenu dans la liste.|r")
		page.besoin = page.besoin or BesoinParDefaut(e and e.taille or 5)
		local total = 0
		for _, role in ipairs(ROLES) do total = total + (page.besoin[role] or 0) end
		local max = TailleMaxContenu(e)
		for role, l in pairs(a.compteurs) do
			local v = page.besoin[role] or 0
			l.valeur:SetText(tostring(v))
			l.moins:Activer(v > 0)
			l.plus:Activer(total < max)
		end
		a.taille:SetText(EstPerso(e) and (total .. " place" .. (total > 1 and "s" or "") .. " (jusqu'à " .. max .. ")")
			or (total .. " place" .. (total > 1 and "s" or "") .. " sur " .. max))
		a.rappel:Poser(db and db.rappelGroupe)
		local peut = IsInGuild() and PeutAnnoncer()
		a.publier:Activer(peut and page.choix ~= nil and total > 0)
		a.etat:SetText(not IsInGuild() and "Tu n'es pas dans une guilde."
			or (not PeutAnnoncer() and "Seul le chef du groupe peut publier.") or "")
	end
	return p
end

--------------------------------------------------------------------------------
-- Onglet « Mon groupe » : gestion de mon annonce
--------------------------------------------------------------------------------

local HAUTEUR_CANDIDAT = 44

local function CreerGestion(page)
	local p = CreateFrame("Frame", nil, page)
	p:SetAllPoints()

	-- en-tête : le contenu
	local tete = UI.Cadre(p, C.carte, C.bordMoyen)
	tete:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -52)
	tete:SetPoint("RIGHT", p, "RIGHT", -MARGE - LARGEUR_ANNONCE - 16, 0)
	tete:SetHeight(76)
	tete.icone = tete:CreateTexture(nil, "ARTWORK")
	tete.icone:SetSize(76, 46)
	tete.icone:SetPoint("LEFT", tete, "LEFT", 14, 0)
	tete.entree = BoutonEntree(tete)
	tete.entree:SetPoint("BOTTOMRIGHT", tete.icone, "BOTTOMRIGHT", 2, -2)
	tete.nom = UI.Texte(tete, "GameFontNormalLarge", C.ors)
	tete.nom:SetPoint("TOPLEFT", tete.icone, "TOPRIGHT", 14, 0)
	tete.nom:SetPoint("RIGHT", tete, "RIGHT", -14, 0)
	tete.infos = UI.Texte(tete, "GameFontHighlightSmall", C.texte)
	tete.infos:SetPoint("TOPLEFT", tete.nom, "BOTTOMLEFT", 0, -5)
	tete.commentaire = UI.Texte(tete, "GameFontDisableSmall")
	tete.commentaire:SetPoint("TOPLEFT", tete.infos, "BOTTOMLEFT", 0, -4)
	tete.commentaire:SetPoint("RIGHT", tete, "RIGHT", -14, 0)

	-- candidats
	local cand = UI.Carte(p, "Candidats")
	cand:SetPoint("TOPLEFT", tete, "BOTTOMLEFT", 0, -12)
	cand:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE - LARGEUR_ANNONCE - 16, 12)
	cand.liste = UI.Liste(cand)
	cand.liste:SetPoint("TOPLEFT", cand, "TOPLEFT", 12, -38)
	cand.liste:SetPoint("BOTTOMRIGHT", cand, "BOTTOMRIGHT", -6, 10)
	cand.vide:SetText("Pas encore de candidat. Les membres qui postulent apparaissent ici : invite-les dans ton groupe.")
	cand.lignes = {}
	local function CreerCandidat()
		local r = UI.Rangee(cand.liste.contenu, HAUTEUR_CANDIDAT - 4)
		r.portrait = UI.Portrait(r, 30)
		r.portrait:SetPoint("LEFT", r, "LEFT", 8, 0)
		r.refuser = UI.Bouton(r, "Refuser", "fantome", 72, 24)
		r.refuser:SetPoint("RIGHT", r, "RIGHT", -8, 0)
		r.inviter = UI.Bouton(r, "Inviter", "or", 84, 24)
		r.inviter:SetPoint("RIGHT", r.refuser, "LEFT", -6, 0)
		r.nom = UI.Texte(r, "GameFontHighlight")
		r.nom:SetPoint("TOPLEFT", r.portrait, "TOPRIGHT", 10, 0)
		r.nom:SetPoint("RIGHT", r.inviter, "LEFT", -8, 0)
		r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
		r.sous:SetPoint("TOPLEFT", r.nom, "BOTTOMLEFT", 0, -3)
		r.sous:SetPoint("RIGHT", r.inviter, "LEFT", -8, 0)
		return r
	end

	-- droite : composition et actions
	local compo = UI.Carte(p, "Composition")
	compo:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -52)
	compo:SetSize(LARGEUR_ANNONCE, 250)
	compo.places = UI.Places(compo, 10)
	compo.places:SetPoint("TOPRIGHT", compo, "TOPRIGHT", -14, -12)
	compo.lignes = {}
	for i = 1, 5 do
		local l = CreateFrame("Frame", nil, compo)
		l:SetSize(LARGEUR_ANNONCE - 28, 30)
		l:SetPoint("TOPLEFT", compo, "TOPLEFT", 14, -40 - (i - 1) * 34)
		l.role = PastilleRole(l)
		l.role:SetPoint("LEFT", l, "LEFT", 0, 0)
		l.nom = UI.Texte(l, "GameFontHighlight")
		l.nom:SetPoint("LEFT", l, "LEFT", 74, 0)
		l.nom:SetPoint("RIGHT", l, "RIGHT", 0, 0)
		compo.lignes[i] = l
	end
	compo.resume = UI.Texte(compo, "GameFontHighlight", C.texte)
	compo.resume:SetPoint("TOPLEFT", compo, "TOPLEFT", 14, -44)
	compo.resume:SetPoint("RIGHT", compo, "RIGHT", -14, 0)
	compo.resume:SetWordWrap(true)

	local actions = UI.Carte(p, "Mon annonce")
	actions:SetPoint("TOPRIGHT", compo, "BOTTOMRIGHT", 0, -12)
	actions:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, 12)
	actions:SetWidth(LARGEUR_ANNONCE)
	if ns.CreerBoutonsPublic then
		p.public = ns.CreerBoutonsPublic(actions)
		p.public.style:SetWidth(LARGEUR_ANNONCE - 28)
		p.public.style:SetPoint("TOPLEFT", actions, "TOPLEFT", 14, -40)
		p.public.public:SetWidth(LARGEUR_ANNONCE - 28)
		p.public.public:SetPoint("TOPLEFT", p.public.style, "BOTTOMLEFT", 0, -8)
	end
	p.retirer = UI.Bouton(actions, "Retirer l'annonce", "aide", LARGEUR_ANNONCE - 28, 32)
	p.retirer:SetPoint("BOTTOMLEFT", actions, "BOTTOMLEFT", 14, 14)
	p.retirer:SetScript("OnClick", function() FermerMonAnnonce("retirée par toi") end)

	p.Maj = function()
		local m = etat.monAnnonce
		if not m then return end
		local e = InfoContenu(m.code)
		PoserIcone(tete.icone, e.icone)
		tete.entree:Poser(e)
		tete.nom:SetText(e.nom or "?")
		tete.infos:SetText(NombreMembres() .. "/" .. (m.taille or 5) .. " joueurs · " .. CouleurNiveau(e) .. TexteNiveaux(e) .. "|r"
			.. (m.rappel and " · |cff999999rappel toutes les 5 min|r" or ""))
		tete.commentaire:SetText((m.commentaire and m.commentaire ~= "") and ("« " .. m.commentaire .. " »") or "")

		-- composition
		local pris, membres = Composition(m.besoin)
		local places = ListePlaces(m.besoin, pris)
		if #places <= 10 then compo.places:Poser(places); compo.places:Show() else compo.places:Hide() end
		local taille = m.taille or 5
		if taille <= 5 then
			compo.resume:Hide()
			-- une ligne par place, dans l'ordre tank, heal, dps ; les places vides prennent les membres restants
			local restants = {}
			for _, mb in ipairs(membres) do restants[#restants + 1] = mb end
			local lignes = {}
			for _, role in ipairs(ROLES) do
				for _ = 1, (m.besoin[role] or 0) do
					local trouve
					for i, mb in ipairs(restants) do
						if mb.role == role then trouve = table.remove(restants, i); break end
					end
					lignes[#lignes + 1] = { role = role, membre = trouve }
				end
			end
			for _, l in ipairs(lignes) do
				if not l.membre and #restants > 0 then l.membre = table.remove(restants, 1) end
			end
			for i, l in ipairs(compo.lignes) do
				local d = lignes[i]
				if d then
					l.role:Poser(d.role)
					if d.membre then
						l.nom:SetText(NomCourt(d.membre.nom) .. (d.membre.role and "" or "  |cff999999(rôle inconnu)|r"))
						l.nom:SetTextColor(unpack(C.texte))
					else
						l.nom:SetText("— place libre —")
						l.nom:SetTextColor(unpack(C.gris))
					end
					l:Show()
				else
					l:Hide()
				end
			end
		else
			for _, l in ipairs(compo.lignes) do l:Hide() end
			compo.resume:SetText(TextePlaces(m.besoin, pris))
			compo.resume:Show()
		end

		-- candidats
		local liste = etat.candidats or {}
		cand.titre:SetText("Candidats" .. (#liste > 0 and ("  |cff6fd08c(" .. #liste .. ")|r") or ""))
		local y = 0
		for i, cd in ipairs(liste) do
			local r = cand.lignes[i]
			if not r then r = CreerCandidat(); cand.lignes[i] = r end
			r.portrait:Poser(Normaliser(cd.nom or ""), cd.classe)
			r.nom:SetText(CouleurClasse(cd.classe) .. NomCourt(cd.nom or "?") .. "|r" .. ((cd.niveau or 0) > 0 and ("  |cff999999(" .. cd.niveau .. ")|r") or ""))
			local plein = cd.role and m.besoin[cd.role] and (pris[cd.role] or 0) >= (m.besoin[cd.role] or 0)
			r.sous:SetText(TexteRole(cd.role) .. (cd.statut == "invite" and "  · |cff6fd08cinvité|r" or "")
				.. (plein and "  · |cffff6655rôle déjà pris|r" or ""))
			local reinviter = cd.statut == "invite"
			r.inviter:Ecrire(reinviter and "Réinviter" or "Inviter")
			r.inviter:Activer(not (reinviter and cd.invite and GetTime() - cd.invite < 10))
			r.inviter:SetScript("OnClick", function() Inviter(cd.nom); Rafraichir() end)
			r.refuser:SetScript("OnClick", function() Refuser(cd.nom); Rafraichir() end)
			r:ClearAllPoints()
			r:SetPoint("TOPLEFT", cand.liste.contenu, "TOPLEFT", 0, -y)
			r:SetPoint("RIGHT", cand.liste.contenu, "RIGHT", 0, 0)
			r:Show()
			y = y + HAUTEUR_CANDIDAT
		end
		for i = #liste + 1, #cand.lignes do cand.lignes[i]:Hide() end
		cand.liste:Hauteur(y)
		cand.vide:SetShown(#liste == 0)

		if p.public then p.public.maj(m, e.nom) end
	end
	return p
end

--------------------------------------------------------------------------------
-- La page
--------------------------------------------------------------------------------

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.onglet = 1
	local function Choisir(i)
		p.onglet = i
		p.onglets:Choisir(i)
		Rafraichir()
	end
	p.onglets = UI.Onglets(p, { "Parcourir", "Mon groupe" }, Choisir)
	p.onglets:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -10)
	p.onglets:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	p.creer = UI.Bouton(p, "+ Créer un groupe", "or", 150, 28)
	p.creer:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -12)
	p.creer:SetScript("OnClick", function() Choisir(2) end)

	p.parcourir = CreerParcourir(p)
	p.creation = CreerCreation(p)
	p.gestion = CreerGestion(p)
	p.onglets:Choisir(1)

	p.Maj = function()
		local n = 0
		for id in pairs(etat.annonces) do
			if not (etat.monAnnonce and id == etat.monAnnonce.id) then n = n + 1 end
		end
		p.onglets:Compte(1, n)
		p.onglets:Compte(2, etat.monAnnonce and #(etat.candidats or {}) or 0)
		p.creer:SetShown(p.onglet == 1 and not etat.monAnnonce)
		p.parcourir:SetShown(p.onglet == 1)
		p.creation:SetShown(p.onglet == 2 and not etat.monAnnonce)
		p.gestion:SetShown(p.onglet == 2 and etat.monAnnonce ~= nil)
		if p.onglet == 1 then p.parcourir.Maj()
		elseif etat.monAnnonce then p.gestion.Maj()
		else p.creation.Maj() end
	end
	-- ns.OuvrirInterface("groupes", onglet)
	p.Ouvrir = function(onglet) if onglet then Choisir(onglet) end end
	return p
end
if ns.AjouterPage then ns.AjouterPage("groupes", CreerPage) end

--------------------------------------------------------------------------------
-- Fonctions partagées
--------------------------------------------------------------------------------

-- Nombre de groupes de la guilde qui cherchent encore du monde (hors le mien)
ns.NombreGroupes = function()
	local n = 0
	for id, a in pairs(etat.annonces) do
		if not (etat.monAnnonce and id == etat.monAnnonce.id) and (a.membres or 1) < (a.taille or 5) then n = n + 1 end
	end
	return n
end

-- Suis-je en attente ? (mon annonce ouverte, une candidature envoyée, ou mon groupe public)
ns.EnAttente = function()
	if etat.monAnnonce then return true end
	for _, e in pairs(etat.candidatures) do
		if e == "envoyee" then return true end
	end
	if C_LFGList and C_LFGList.HasActiveEntryInfo then
		local ok, oui = pcall(C_LFGList.HasActiveEntryInfo)
		if ok and oui then return true end
	end
	return false
end

-- appelé par GuildUp_Bouton.lua quand le rôle change
ns.SurChangementDeRole = function() Rafraichir() end

-- Ouvre la page sur « Parcourir » (bulles, accueil, /smb groupes…)
ns.OuvrirGroupes = function()
	if ns.OuvrirInterface then ns.OuvrirInterface("groupes", 1) end
end

-- /smb groupes : ouvre la page, ou ferme la fenêtre si elle y est déjà
ns.BasculerGroupes = function()
	if ns.PageInterface and ns.PageInterface() == "groupes" then
		if ns.BasculerInterface then ns.BasculerInterface() end
	elseif ns.OuvrirInterface then
		ns.OuvrirInterface("groupes")
	end
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
		"Waypoint-MapPin-Untracked" }) do
		atlas[#atlas + 1] = a .. "=" .. tostring(AtlasExiste(a))
	end
	L("  atlas : " .. table.concat(atlas, ", "))
end

-- appelée par GuildUp_Groupes.lua quand les annonces ou les candidatures changent
ns.RafraichirGroupes = Rafraichir
