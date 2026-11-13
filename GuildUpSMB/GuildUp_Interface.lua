-- GuildUpSMB : fenêtre principale (style sombre et doré), ouverte par le médaillon (GuildUp_Bouton.lua)
-- ou /smb. Bandeau (titre, membres actifs, choix du rôle, alerte « Profil incomplet » tant que
-- ns.ProfilComplet() est faux, croix), menu à gauche, page à droite. À la première ouverture de la
-- session, la fenêtre « Complète ton profil » (ns.OuvrirProfil, GuildUp_Identite.lua) s'ouvre si le
-- profil est incomplet.
-- Pages :
--   Accueil : ce qui se passe dans la guilde (membres sur ma carte, groupes ouverts, appels à l'aide,
--             demandes de dons, besoins que je sais fabriquer, avancement d'un projet).
--   Les autres sections sont des pages fournies par leur module (ns.AjouterPage), avec le kit
--   d'interface ns.UI (GuildUp_Style.lua) : Guilde (GuildUp_Membres.lua), Groupes
--   (GuildUp_GroupesFenetre.lua), Quêtes en commun (GuildUp_Quetes.lua), Artisanat (GuildUp_Carnet.lua,
--   onglets Registre de GuildUp_Metiers.lua, Items, Projets de GuildUp_Projets.lua), Mes carnets
--   (GuildUp_Carnet.lua), Dons (GuildUp_Echanges.lua + GuildUp_Besoins.lua), Options
--   (GuildUp_Options.lua), Événements (GuildUp_Evenements.lua), Activité (GuildUp_Journal.lua : fil
--   d'activité et podium ; sa pastille compte les nouveautés depuis la dernière visite).
-- Fournit ns.NouveautesGuilde() (pastille du médaillon), ns.BasculerInterface(), ns.OuvrirInterface(page),
-- ns.MajInterface(), ns.DistanceMembre(cle) (distance d'un membre sur ma carte). Réglages :
-- db.interface = { x, y } (position). Aucun message réseau.

local NOM_ADDON, ns = ...
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\"
local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local CouleurClasse = ns.CouleurClasse
local CouleurClasseTexte = ns.CouleurClasseTexte

local function DB() return ns.DB and ns.DB() end

--------------------------------------------------------------------------------
-- Style : le kit commun (GuildUp_Style.lua)
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI.C
local Habiller, Cadre, Texte, Bouton, Infobulle, Pastille = UI.Habiller, UI.Cadre, UI.Texte, UI.Bouton, UI.Infobulle, UI.Pastille
local IlYa, Chuchoter = UI.IlYa, UI.Chuchoter
local ROND = UI.ROND
local LARGEUR, HAUTEUR = 980, 640
local LARGEUR_MENU, HAUTEUR_TETE = 184, 52
ns.TAILLE_PAGE = { LARGEUR - LARGEUR_MENU - 2, HAUTEUR - HAUTEUR_TETE - 2 } -- zone des pages

--------------------------------------------------------------------------------
-- Nouveautés (pastille du médaillon, compteurs du menu)
--------------------------------------------------------------------------------

ns.NouveautesGuilde = function()
	return {
		groupes = ns.NombreGroupes and ns.NombreGroupes() or 0,
		aide = ns.AppelsAide and #ns.AppelsAide() or 0,
		dons = ns.NombreDemandesDons and ns.NombreDemandesDons() or 0,
	}
end

--------------------------------------------------------------------------------
-- Sections du menu
--------------------------------------------------------------------------------

local fenetre
local Aller -- (défini plus bas)

local SECTIONS = {
	{ id = "accueil", nom = "Accueil", icone = "Interface\\Icons\\INV_Misc_Book_09" },
	{ id = "ensemble", nom = "Jouer ensemble", icone = "Interface\\Icons\\INV_Misc_GroupNeedMore", neutre = true,
		badge = function() return ns.NombreSuggestions and ns.NombreSuggestions() or 0 end },
	{ id = "guilde", nom = "Guilde", icone = "Interface\\Icons\\INV_Shirt_GuildTabard_01" },
	{ id = "groupes", nom = "Groupes", icone = "Interface\\Icons\\INV_Sword_04",
		ouvrir = function() if ns.OuvrirGroupes then ns.OuvrirGroupes() end end,
		badge = function() return ns.NombreGroupes and ns.NombreGroupes() or 0 end },
	{ id = "quetes", nom = "Quêtes en commun", icone = "Interface\\Icons\\INV_Misc_Note_06", neutre = true,
		ouvrir = function() if ns.BasculerQuetes then ns.BasculerQuetes(true) end end,
		badge = function() return ns.QuetesEnCommun and #ns.QuetesEnCommun() or 0 end },
	{ id = "artisanat", nom = "Artisanat", icone = "Interface\\Icons\\Trade_BlackSmithing",
		ouvrir = function() if ns.OuvrirArtisanat then ns.OuvrirArtisanat(1) end end },
	{ id = "carnets", nom = "Mes carnets", icone = "Interface\\Icons\\INV_Scroll_03",
		ouvrir = function() if ns.OuvrirCourses then ns.OuvrirCourses() end end },
	{ id = "dons", nom = "Dons", icone = "Interface\\Icons\\INV_Misc_Gift_01",
		ouvrir = function() if ns.OuvrirEchanges then ns.OuvrirEchanges(nil, 1) end end,
		badge = function() return ns.NombreDemandesDons and ns.NombreDemandesDons() or 0 end },
	{ id = "evenements", nom = "Événements", icone = "Interface\\Icons\\INV_Misc_PocketWatch_01" },
	{ id = "activite", nom = "Activité", icone = "Interface\\Icons\\INV_Misc_Note_01", neutre = true,
		badge = function() return ns.NouveautesActivite and ns.NouveautesActivite() or 0 end },
}
local OPTIONS = { id = "options", nom = "Options", icone = "Interface\\Icons\\Trade_Engineering",
	ouvrir = function() if ns.BasculerOptions then ns.BasculerOptions() end end }
local PAR_ID = { options = OPTIONS }
for _, s in ipairs(SECTIONS) do PAR_ID[s.id] = s end

--------------------------------------------------------------------------------
-- Page Accueil
--------------------------------------------------------------------------------

local CarteAccueil = UI.Carte

-- ligne d'une carte : portrait (un joueur) ou icône (un objet), titre, sous-titre, places par rôle
-- éventuelles, bouton à droite
local function LigneCarte(c, i)
	local l = CreateFrame("Frame", nil, c)
	l:SetHeight(38)
	l:SetPoint("TOPLEFT", c, "TOPLEFT", 12, -36 - (i - 1) * 44)
	l:SetPoint("RIGHT", c, "RIGHT", -12, 0)
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetSize(32, 32)
	l.icone:SetPoint("LEFT", l, "LEFT", 0, 0)
	l.portrait = UI.Portrait(l, 34)
	l.portrait:SetPoint("LEFT", l, "LEFT", -1, 0)
	l.portrait:Hide()
	l.bouton = Bouton(l, "", "or", 88, 24)
	l.bouton:SetPoint("RIGHT", l, "RIGHT", 0, 0)
	l.places = UI.Places(l, 5)
	l.places:SetPoint("BOTTOMRIGHT", l.bouton, "BOTTOMLEFT", -10, -2)
	l.places:SetScale(0.8)
	l.places:Hide()
	l.titre = Texte(l, "GameFontHighlight", C.texte)
	l.titre:SetPoint("TOPLEFT", l.icone, "TOPRIGHT", 8, 0)
	l.titre:SetPoint("RIGHT", l.bouton, "LEFT", -8, 0)
	l.sous = Texte(l, "GameFontHighlightSmall", C.gris)
	l.sous:SetPoint("TOPLEFT", l.titre, "BOTTOMLEFT", 0, -4)
	l.sous:SetPoint("RIGHT", l.bouton, "LEFT", -8, 0)
	-- un joueur (portrait) ou un objet / contenu (icône carrée)
	l.Joueur = function(self, cle, classe)
		self.icone:Hide()
		self.portrait:Poser(cle, classe)
		self.portrait:Show()
	end
	l.Icone = function(self, texture)
		self.portrait:Hide()
		self.icone:SetTexture(texture or "Interface\\Icons\\INV_Misc_QuestionMark")
		self.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		self.icone:Show()
	end
	-- places = liste { role, pris } ou nil ; le sous-titre s'arrête avant elles
	l.Places = function(self, places)
		self.sous:ClearAllPoints()
		self.sous:SetPoint("TOPLEFT", self.titre, "BOTTOMLEFT", 0, -4)
		if places and #places > 0 and #places <= 5 then
			self.places:Poser(places)
			self.places:Show()
			self.sous:SetPoint("RIGHT", self.places, "LEFT", -6, 0)
		else
			self.places:Hide()
			self.sous:SetPoint("RIGHT", self.bouton, "LEFT", -8, 0)
		end
	end
	return l
end

-- nom d'un membre à la couleur de sa classe (liste de guilde, position partagée)
local function NomColore(nom)
	local cle = ns.Normaliser and ns.Normaliser(nom or "")
	if ns.NomMembreColore then return ns.NomMembreColore(cle, nom or "?") end
	return NomJoueur(nom or "?")
end

-- Position sur le monde d'un point de carte (nord, ouest), pour les distances
local function Monde(carte, x, y)
	if not (C_Map and C_Map.GetWorldPosFromMapPos and CreateVector2D) then return nil end
	local ok, _, v = pcall(C_Map.GetWorldPosFromMapPos, carte, CreateVector2D(x, y))
	if not ok or not v then return nil end
	local ok2, a, b = pcall(v.GetXY, v)
	if ok2 then return a, b end
end

local UNITE = (GetLocale() == "enUS" or GetLocale() == "enGB") and "yd" or "m"

-- Pour la page Guilde (GuildUp_Membres.lua) : distance jusqu'à un membre qui partage sa position sur
-- ma carte (nombre, unité « m » ou « yd »), nil s'il n'est pas sur ma carte ou si on ne sait pas
ns.DistanceMembre = function(cle)
	local positions = ns.PositionsMembres and ns.PositionsMembres()
	local p = positions and cle and positions[cle]
	if not (p and p.carte and not p.instance and GetTime() - (p.vu or 0) < 45) then return nil end
	local carte, x, y
	if ns.MaPosition then carte, x, y = ns.MaPosition() end
	if not carte or carte ~= p.carte then return nil end
	local n0, o0 = Monde(carte, x, y)
	local n1, o1 = Monde(p.carte, p.x, p.y)
	if not (n0 and n1) then return nil end
	return math.sqrt((n1 - n0) ^ 2 + (o1 - o0) ^ 2), UNITE
end

-- membres sur ma carte (positions partagées, avec un portrait), du plus proche au plus loin
local function MembresDeMaCarte()
	local res = {}
	local positions = ns.PositionsMembres and ns.PositionsMembres()
	local carte, x, y
	if ns.MaPosition then carte, x, y = ns.MaPosition() end
	if not (positions and carte) then return res end
	local n0, o0 = Monde(carte, x, y)
	local maintenant = GetTime()
	for cle, p in pairs(positions) do
		if p.carte == carte and not p.instance and p.portrait and maintenant - (p.vu or 0) < 45 then
			local n1, o1 = Monde(p.carte, p.x, p.y)
			local d = (n0 and n1) and math.sqrt((n1 - n0) ^ 2 + (o1 - o0) ^ 2) or nil
			res[#res + 1] = { cle = cle, p = p, distance = d }
		end
	end
	table.sort(res, function(a, b) return (a.distance or 1e9) < (b.distance or 1e9) end)
	return res
end

local NOMS_ROLES = { tank = "Tank", heal = "Heal", dps = "DPS" }
local COULEURS_ROLES = { tank = "|cff6aa7e6", heal = "|cff6fd08c", dps = "|cffee8075" }

-- groupes ouverts (hors le mien), les plus récents d'abord
local function GroupesOuverts()
	local res = {}
	local etat = ns.Groupes and ns.Groupes.etat
	if not etat then return res end
	for id, a in pairs(etat.annonces or {}) do
		if not (etat.monAnnonce and id == etat.monAnnonce.id) and (a.membres or 1) < (a.taille or 5) then
			res[#res + 1] = a
		end
	end
	-- groupes immédiats d'abord (les plus récents), puis les programmés (départ le plus proche)
	local Programmee = ns.Groupes.Programmee or function() return false end
	table.sort(res, function(a, b)
		local pa, pb = Programmee(a), Programmee(b)
		if pa ~= pb then return not pa end
		if pa then return (a.depart or 0) < (b.depart or 0) end
		return (a.premiere or 0) > (b.premiere or 0)
	end)
	return res
end

local function CreerAccueil(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	local MARGE, ECART = 16, 12
	local largeur = LARGEUR - LARGEUR_MENU - 2 * MARGE
	local demi = (largeur - ECART) / 2

	-- Dans ta zone : jusqu'à 5 membres (portrait, nom, distance) ; clic : chuchoter
	local zone = CarteAccueil(p, "Dans ta zone")
	zone:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -MARGE)
	zone:SetSize(largeur, 96)
	zone.compte:SetText("clic : chuchoter")
	zone.membres = {}
	for i = 1, 5 do
		local m = CreateFrame("Button", nil, zone)
		m:SetSize((largeur - 28) / 5, 44)
		m:SetPoint("TOPLEFT", zone, "TOPLEFT", 14 + (i - 1) * (largeur - 28) / 5, -38)
		m.portrait = UI.Portrait(m, 42)
		m.portrait:SetPoint("LEFT", m, "LEFT", 0, 0)
		m.nom = Texte(m, "GameFontHighlight")
		m.nom:SetPoint("TOPLEFT", m.portrait, "TOPRIGHT", 8, -6)
		m.nom:SetPoint("RIGHT", m, "RIGHT", -4, 0)
		m.sous = Texte(m, "GameFontHighlightSmall", C.gris)
		m.sous:SetPoint("TOPLEFT", m.nom, "BOTTOMLEFT", 0, -3)
		m:SetScript("OnClick", function(self) Chuchoter(self.cle, self.nomComplet) end)
		Infobulle(m, "Chuchoter", "Ouvre une discussion privée avec ce membre.")
		zone.membres[i] = m
	end

	-- Groupes ouverts
	local groupes = CarteAccueil(p, "Groupes ouverts")
	groupes:SetPoint("TOPLEFT", zone, "BOTTOMLEFT", 0, -ECART)
	groupes:SetSize(demi, 182)
	groupes.lignes = { LigneCarte(groupes, 1), LigneCarte(groupes, 2) }
	groupes.creer = Bouton(groupes, "Voir les groupes", "fantome", 120, 22)
	groupes.creer:SetPoint("BOTTOMLEFT", groupes, "BOTTOMLEFT", 14, 10)
	groupes.creer:SetScript("OnClick", function() Aller("groupes") end)

	-- Appels à l'aide
	local aide = CarteAccueil(p, "Appels à l'aide")
	aide:SetPoint("TOPLEFT", groupes, "TOPRIGHT", ECART, 0)
	aide:SetSize(demi, 182)
	aide.titre:SetTextColor(unpack(C.aide))
	aide:SetBackdropBorderColor(0.43, 0.2, 0.14, 1)
	aide.lignes = { LigneCarte(aide, 1), LigneCarte(aide, 2) }
	aide.note = Texte(aide, "GameFontDisableSmall")
	aide.note:SetPoint("BOTTOMLEFT", aide, "BOTTOMLEFT", 14, 12)
	aide.note:SetText("Seuls les membres qui ont le niveau reçoivent l'appel.")

	-- Dons : demandes reçues
	local dons = CarteAccueil(p, "Dons")
	dons:SetPoint("TOPLEFT", groupes, "BOTTOMLEFT", 0, -ECART)
	dons:SetSize(demi, 160)
	dons.lignes = { LigneCarte(dons, 1), LigneCarte(dons, 2) }
	dons.parcourir = Bouton(dons, "Parcourir les dons", "fantome", 130, 22)
	dons.parcourir:SetPoint("BOTTOMLEFT", dons, "BOTTOMLEFT", 14, 10)
	dons.parcourir:SetScript("OnClick", function() Aller("dons") end)

	-- Tu peux aider : besoins que je sais fabriquer, avancement du dernier projet
	local aider = CarteAccueil(p, "Tu peux aider")
	aider:SetPoint("TOPLEFT", dons, "TOPRIGHT", ECART, 0)
	aider:SetSize(demi, 160)
	aider.lignes = { LigneCarte(aider, 1), LigneCarte(aider, 2) }
	aider.projet = Texte(aider, "GameFontHighlightSmall", C.texte)
	aider.projet:SetPoint("BOTTOMLEFT", aider, "BOTTOMLEFT", 14, 24)
	aider.projet:SetPoint("RIGHT", aider, "RIGHT", -70, 0)
	aider.avance = Texte(aider, "GameFontHighlightSmall", C.gris)
	aider.avance:SetPoint("BOTTOMRIGHT", aider, "BOTTOMRIGHT", -14, 24)
	aider.avance:SetJustifyH("RIGHT")
	aider.barre = aider:CreateTexture(nil, "ARTWORK")
	aider.barre:SetColorTexture(0.165, 0.137, 0.094, 1)
	aider.barre:SetHeight(6)
	aider.barre:SetPoint("BOTTOMLEFT", aider, "BOTTOMLEFT", 14, 12)
	aider.barre:SetPoint("BOTTOMRIGHT", aider, "BOTTOMRIGHT", -14, 12)
	aider.plein = aider:CreateTexture(nil, "OVERLAY")
	aider.plein:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 1)
	aider.plein:SetHeight(6)
	aider.plein:SetPoint("LEFT", aider.barre, "LEFT", 0, 0)
	aider.projetBouton = CreateFrame("Button", nil, aider)
	aider.projetBouton:SetPoint("TOPLEFT", aider.projet, "TOPLEFT", 0, 4)
	aider.projetBouton:SetPoint("BOTTOMRIGHT", aider.barre, "BOTTOMRIGHT", 0, -4)

	-- Prochain événement de la guilde (calendrier du jeu, GuildUp_Evenements.lua)
	local evts = CarteAccueil(p, "Prochain événement")
	evts:SetPoint("TOPLEFT", dons, "BOTTOMLEFT", 0, -ECART)
	evts:SetSize(largeur, 80)
	evts.ligne = LigneCarte(evts, 1)
	evts.vide:SetText("Aucun événement prévu dans les 30 prochains jours.")
	evts.tous = Bouton(evts, "Tous les événements", "fantome", 150, 22)
	evts.tous:SetPoint("TOPRIGHT", evts, "TOPRIGHT", -12, -8)
	evts.tous:SetScript("OnClick", function() Aller("evenements") end)
	evts.compte:Hide()

	local function Cacher(lignes, depuis)
		for i = depuis, #lignes do lignes[i]:Hide() end
	end

	p.Maj = function()
		-- membres sur ma carte
		local carte = ns.MaPosition and ns.MaPosition()
		local nomZone = (GetRealZoneText and GetRealZoneText()) or ""
		zone.titre:SetText("Dans ta zone" .. (nomZone ~= "" and (" · " .. nomZone) or ""))
		local membres = MembresDeMaCarte()
		for i, m in ipairs(zone.membres) do
			local v = membres[i]
			if v then
				m.cle, m.nomComplet = v.cle, v.p.nom
				m.portrait:Poser(v.cle, v.p.classe)
				m.nom:SetText(NomJoueur(v.p.nom, true))
				m.nom:SetTextColor(CouleurClasse(v.p.classe))
				local classe = v.p.classe and LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[v.p.classe] or ""
				m.sous:SetText(classe .. (v.distance and ((classe ~= "" and " · " or "") .. math.floor(v.distance + 0.5) .. " " .. UNITE) or ""))
				m:Show()
			else
				m:Hide()
			end
		end
		zone.vide:SetShown(#membres == 0)
		zone.vide:SetText(carte and "Aucun membre sur ta carte pour l'instant (ceux qui partagent leur position apparaissent ici)."
			or "Position inconnue (instance) : les membres de ta zone s'afficheront dehors.")
		zone.compte:SetShown(#membres > 0)

		-- groupes ouverts
		local liste = GroupesOuverts()
		local etat = ns.Groupes and ns.Groupes.etat
		local monRole = ns.MonRole and ns.MonRole()
		groupes.compte:SetText(#liste > 0 and tostring(#liste) or "")
		for i, l in ipairs(groupes.lignes) do
			local a = liste[i]
			if a then
				local info = ns.Groupes.InfoContenu and ns.Groupes.InfoContenu(a.code) or {}
				l:Joueur(ns.Normaliser and ns.Normaliser(a.chef or ""), a.classe)
				l.titre:SetText(info.nom or "?")
				local places = {}
				for _, r in ipairs({ "tank", "heal", "dps" }) do
					for n = 1, (a.besoin and a.besoin[r] or 0) do
						places[#places + 1] = { role = r, pris = n <= (a.pris and a.pris[r] or 0) }
					end
				end
				l:Places(places)
				local cherche = {}
				for _, r in ipairs({ "tank", "heal", "dps" }) do
					if ns.Groupes.PlacesLibres and (ns.Groupes.PlacesLibres(a, r) or 0) > 0 then
						cherche[#cherche + 1] = COULEURS_ROLES[r] .. NOMS_ROLES[r] .. "|r"
					end
				end
				-- groupe programmé : l'heure de départ avant le reste
				local programme = ns.Groupes.Programmee and ns.Groupes.Programmee(a)
				local depart = (programme and ns.Groupes.TexteDepart) and ("|cfff1cf6bdépart " .. ns.Groupes.TexteDepart(a.depart) .. "|r · ") or ""
				l.sous:SetText(depart .. ("%s%s|r · %d/%d%s"):format(CouleurClasseTexte(a.classe), NomJoueur(a.chef or "?"),
					a.membres or 1, a.taille or 5, #cherche > 0 and (" · cherche " .. table.concat(cherche, " ")) or ""))
				local cand = etat and etat.candidatures and etat.candidatures[a.id]
				local libres = ns.Groupes.PlacesLibres and ns.Groupes.PlacesLibres(a, monRole)
				l.bouton:SetScript("OnClick", nil)
				if cand == "envoyee" then
					l.bouton:Ecrire(programme and "Se désinscrire" or "Annuler")
					l.bouton:Activer(true)
					l.bouton:SetScript("OnClick", function()
						if ns.Groupes.AnnulerCandidature then ns.Groupes.AnnulerCandidature(a.id) end
						ns.MajInterface()
					end)
				elseif cand == "refusee" then
					l.bouton:Ecrire("Refusé")
					l.bouton:Activer(false)
				elseif libres and libres <= 0 then
					l.bouton:Ecrire("Rôle complet")
					l.bouton:Activer(false)
				else
					l.bouton:Ecrire(programme and "S'inscrire" or "Postuler")
					l.bouton:Activer(true)
					l.bouton:SetScript("OnClick", function()
						if ns.Groupes.Postuler then ns.Groupes.Postuler(a.id) end
						ns.MajInterface()
					end)
				end
				l:Show()
			else
				l:Hide()
			end
		end
		groupes.vide:SetShown(#liste == 0)
		groupes.vide:SetText("Aucun groupe ouvert pour l'instant.")
		groupes.creer:Ecrire(#liste == 0 and "Créer un groupe" or "Voir les groupes")

		-- appels à l'aide
		local appels = ns.AppelsAide and ns.AppelsAide() or {}
		aide.compte:SetText(appels[1] and IlYa(appels[1].quand) or "")
		for i, l in ipairs(aide.lignes) do
			local a = appels[i]
			if a then
				l:Joueur(ns.Normaliser and ns.Normaliser(a.nom or ""))
				l:Places(nil)
				l.titre:SetText(NomColore(a.nom) .. " a besoin d'aide")
				l.sous:SetText(((a.zone ~= "" and a.zone) or "?") .. " · niv. " .. (a.niveau or "?")
					.. ((a.texte and a.texte ~= "") and (" · « " .. a.texte .. " »") or ""))
				l.bouton:Ecrire("Sur la carte")
				l.bouton:Activer(true)
				l.bouton:SetScript("OnClick", function() if ns.MontrerAppelSurCarte then ns.MontrerAppelSurCarte(a) end end)
				l:Show()
			else
				l:Hide()
			end
		end
		aide.vide:SetShown(#appels == 0)
		aide.vide:SetText("Aucun appel en cours.")

		-- dons : demandes reçues pas encore vues, sinon les dernières
		local demandes = ns.DemandesDons and ns.DemandesDons() or {}
		local nonVues = ns.NombreDemandesDons and ns.NombreDemandesDons() or 0
		dons.compte:SetText(nonVues > 0 and (nonVues .. " nouvelle" .. (nonVues > 1 and "s" or "")) or "")
		for i, l in ipairs(dons.lignes) do
			local d = demandes[i]
			if d then
				local nom, lien, _, icone = ns.InfoObjet(d.objet)
				if not nom and ns.Precharger then ns.Precharger(d.objet) end
				l:Icone(icone)
				l:Places(nil)
				l.titre:SetText(NomColore(d.nom) .. " te demande " .. (lien or nom or "un objet"))
				l.sous:SetText((d.vu and "" or "|cff6fd08cnouvelle|r · ") .. IlYa(d.quand))
				l.bouton:Ecrire("Voir")
				l.bouton:Activer(true)
				l.bouton:SetScript("OnClick", function() if ns.OuvrirEchanges then ns.OuvrirEchanges(nil, 3) end end)
				l:Show()
			else
				l:Hide()
			end
		end
		dons.vide:SetShown(#demandes == 0)
		dons.vide:SetText("Aucune demande de don pour toi.")

		-- tu peux aider : besoins que je sais fabriquer
		local besoins = ns.BesoinsQueJeSaisFabriquer and ns.BesoinsQueJeSaisFabriquer() or {}
		aider.compte:SetText(#besoins > 0 and tostring(#besoins) or "")
		for i, l in ipairs(aider.lignes) do
			local b = besoins[i]
			if b then
				local nom, lien, _, icone = ns.InfoObjet(b.objet)
				if not nom and ns.Precharger then ns.Precharger(b.objet) end
				l:Icone(icone)
				l:Places(nil)
				l.titre:SetText(NomColore(b.nom) .. " cherche " .. ((b.qte or 0) > 0 and (b.qte .. " ") or "") .. (lien or nom or "un objet"))
				l.sous:SetText("tu sais le fabriquer" .. (b.enLigne and " · |cff6fd08cen ligne|r" or " · hors ligne"))
				l.bouton:Ecrire("Chuchoter")
				l.bouton:Activer(b.enLigne)
				l.bouton:SetScript("OnClick", function() Chuchoter(b.cle, b.nom) end)
				l:Show()
			else
				l:Hide()
			end
		end
		aider.vide:SetShown(#besoins == 0)
		aider.vide:SetText("Personne ne cherche ce que tu sais fabriquer.")
		-- dernier projet de guilde
		local projets = ns.ListeProjets and ns.ListeProjets() or {}
		local pr = projets[1]
		local faites, total = 0, 0
		if pr and ns.AvancementProjet then
			local ok, f, t = pcall(ns.AvancementProjet, pr)
			if ok then faites, total = f or 0, t or 0 end
		end
		aider.projet:SetShown(pr ~= nil)
		aider.avance:SetShown(pr ~= nil)
		aider.barre:SetShown(pr ~= nil)
		aider.projetBouton:SetShown(pr ~= nil)
		if pr then
			aider.projet:SetText("Projet : " .. (pr.nom or "?"))
			aider.avance:SetText(faites .. " / " .. total .. " tâches")
			local l = aider.barre:GetWidth()
			aider.plein:SetWidth(math.max(1, (l > 0 and l or (demi - 28)) * (total > 0 and faites / total or 0)))
			aider.plein:SetShown(faites > 0)
			aider.projetBouton:SetScript("OnClick", function() if ns.OuvrirProjet then ns.OuvrirProjet(pr.id) end end)
		else
			aider.plein:Hide()
		end

		-- prochain événement
		local prochains = ns.ProchainsEvenements and ns.ProchainsEvenements(3) or {}
		local ev = prochains[1]
		local l = evts.ligne
		if ev then
			l:Icone(ev.icone)
			l:Places(nil)
			l.titre:SetText(ev.titre or "?")
			l.sous:SetText((ev.date or "") .. ((ev.type and ev.type ~= "") and (" · " .. ev.type) or "")
				.. ((ev.etatTexte and ev.etatTexte ~= "") and (" · " .. ev.etatTexte) or "")
				.. (#prochains > 1 and ("  |cff999999(+" .. (#prochains - 1) .. " à venir)|r") or ""))
			l.bouton:Ecrire("Voir")
			l.bouton:Activer(true)
			l.bouton:SetScript("OnClick", function() if ns.OuvrirEvenements then ns.OuvrirEvenements(ev.cle) end end)
			l:Show()
		else
			l:Hide()
		end
		evts.vide:SetShown(ev == nil)
		evts.tous:SetShown(ev ~= nil)
	end
	return p
end

--------------------------------------------------------------------------------
-- Fenêtre
--------------------------------------------------------------------------------

local pages = {}     -- [id] = cadre de page (seulement les pages intégrées)
local CREER_PAGE = { accueil = CreerAccueil }
-- Une page fournie par un module (ex. GuildUp_GroupesPage.lua) : creer(parent) renvoie un cadre qui
-- remplit parent, avec p.Maj() (rafraîchir) et, si besoin, p.Ouvrir(...) (arguments de OuvrirInterface)
ns.AjouterPage = function(id, creer) CREER_PAGE[id] = creer end
local pageActive = "accueil"
local boutonsMenu = {}
local boutonsRole = {}

local function Reglages()
	local db = DB()
	if type(db.interface) ~= "table" then db.interface = {} end
	return db.interface
end

-- Taille de la fenêtre (échelle, 1,1 par défaut : un peu plus grande que les fenêtres du jeu)
local ECHELLE_DEFAUT = 1.1
local function Echelle()
	local e = tonumber(Reglages().echelle) or ECHELLE_DEFAUT
	return math.max(0.7, math.min(1.6, e))
end
-- ns.EchelleInterface(e) : change la taille (nil = la lire) ; renvoie la taille en vigueur
ns.EchelleInterface = function(e)
	if not DB() then return ECHELLE_DEFAUT end
	if e then Reglages().echelle = e end
	if fenetre then fenetre:SetScale(Echelle()) end
	return Echelle()
end

local function MajEntete()
	if not fenetre then return end
	local guilde = IsInGuild and IsInGuild() and GetGuildInfo("player")
	local n = ns.MembresActifs and ns.MembresActifs() or 1
	fenetre.sousTitre:SetText((guilde and (guilde .. " · ") or "")
		.. n .. " membre" .. (n > 1 and "s" or "") .. " en ligne avec l'addon")
	-- alerte « Profil incomplet » ; le choix du rôle se range à sa gauche (ou à gauche de la croix)
	local incomplet = ns.ProfilComplet and not ns.ProfilComplet() or false
	if fenetre.alerte:IsShown() ~= incomplet or not fenetre.rolePlace then
		fenetre.rolePlace = true
		fenetre.alerte:SetShown(incomplet)
		fenetre.zoneRole:ClearAllPoints()
		if incomplet then
			fenetre.zoneRole:SetPoint("RIGHT", fenetre.alerte, "LEFT", -14, 0)
		else
			fenetre.zoneRole:SetPoint("RIGHT", fenetre.alerte:GetParent(), "RIGHT", -50, 0)
		end
	end
	local actuel = ns.MonRole and ns.MonRole()
	local manuel = ns.RoleChoisiALaMain and ns.RoleChoisiALaMain()
	for role, b in pairs(boutonsRole) do
		local c = ns.ROLES_INTERFACE and ns.ROLES_INTERFACE[role] and ns.ROLES_INTERFACE[role].couleur or C.orFonce
		if actuel == role then
			b:SetBackdropColor(c[1], c[2], c[3], 1)
			b.texte:SetTextColor(1, 1, 1)
		else
			b:SetBackdropColor(0, 0, 0, 0)
			b.texte:SetTextColor(math.min(1, c[1] + 0.3), math.min(1, c[2] + 0.3), math.min(1, c[3] + 0.3))
		end
		b.auto:SetShown(actuel == role and manuel ~= role)
	end
	for _, b in ipairs(boutonsMenu) do
		local s = b.section
		local actif = (s.id == pageActive)
		b:SetBackdropColor(unpack(actif and C.actif or { 0, 0, 0, 0 }))
		b:SetBackdropBorderColor(unpack(actif and { 0.35, 0.29, 0.17, 1 } or { 0, 0, 0, 0 }))
		b.texte:SetTextColor(unpack(actif and C.ors or C.texte))
		if b.pastille then b.pastille:Ecrire(s.badge and s.badge() or 0) end
	end
end

local function MajPage()
	local p = pages[pageActive]
	if p and p.Maj then p.Maj() end
end

ns.MajInterface = function()
	if not (fenetre and fenetre:IsShown()) then return end
	MajEntete()
	MajPage()
end

Aller = function(id)
	local s = PAR_ID[id]
	if not s then return end
	if not CREER_PAGE[id] then
		-- page pas encore intégrée : sa fenêtre habituelle
		if fenetre then fenetre:Hide() end
		if s.ouvrir then s.ouvrir() end
		return
	end
	pageActive = id
	if not pages[id] then pages[id] = CREER_PAGE[id](fenetre.contenu) end
	for pid, p in pairs(pages) do p:SetShown(pid == id) end
	ns.MajInterface()
end

local function ElementMenu(parent, s, y)
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	Habiller(b, { 0, 0, 0, 0 })
	b:SetSize(LARGEUR_MENU - 16, 34)
	b:SetPoint("TOPLEFT", parent, "TOPLEFT", 8, y)
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(20, 20)
	b.icone:SetPoint("LEFT", b, "LEFT", 8, 0)
	b.icone:SetTexture(s.icone)
	b.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	b.texte = Texte(b, "GameFontHighlight", C.texte)
	b.texte:SetPoint("LEFT", b.icone, "RIGHT", 10, 0)
	b.texte:SetText(s.nom)
	b.pastille = false
	if s.badge then
		b.pastille = Pastille(b, s.neutre)
		b.pastille:SetPoint("RIGHT", b, "RIGHT", -8, 0)
	end
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetAllPoints()
	survol:SetColorTexture(1, 1, 1, 0.05)
	b.section = s
	b:SetScript("OnClick", function() Aller(s.id) end)
	boutonsMenu[#boutonsMenu + 1] = b
	return b
end

local function CreerFenetre()
	local f = CreateFrame("Frame", "GuildUpInterface", UIParent, "BackdropTemplate")
	Habiller(f, C.fond, C.bordFort)
	f:SetSize(LARGEUR, HAUTEUR)
	f:SetScale(Echelle())
	f:SetFrameStrata("HIGH")
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	tinsert(UISpecialFrames, "GuildUpInterface") -- Échap ferme
	local r = Reglages()
	if type(r.x) == "number" and type(r.y) == "number" then
		f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", r.x, r.y)
	else
		f:SetPoint("CENTER")
	end

	-- bandeau : emblème, titre, membres actifs, rôle, fermeture ; on le glisse pour déplacer
	local tete = Cadre(f, C.bandeau)
	tete:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
	tete:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
	tete:SetHeight(HAUTEUR_TETE)
	tete:EnableMouse(true)
	tete:RegisterForDrag("LeftButton")
	tete:SetScript("OnDragStart", function() f:StartMoving() end)
	tete:SetScript("OnDragStop", function()
		f:StopMovingOrSizing()
		local rr = Reglages()
		rr.x, rr.y = f:GetLeft(), f:GetTop()
	end)
	local filet = tete:CreateTexture(nil, "ARTWORK")
	filet:SetColorTexture(unpack(C.bord))
	filet:SetHeight(1)
	filet:SetPoint("BOTTOMLEFT", tete, "BOTTOMLEFT", 0, 0)
	filet:SetPoint("BOTTOMRIGHT", tete, "BOTTOMRIGHT", 0, 0)
	local embleme = tete:CreateTexture(nil, "ARTWORK")
	embleme:SetTexture(MEDIA .. "gu_emote")
	embleme:SetSize(36, 36)
	embleme:SetPoint("LEFT", tete, "LEFT", 12, 0)
	local titre = Texte(tete, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", embleme, "TOPRIGHT", 10, -2)
	-- « SMB Forever · 2.3.0 » (version lue dans le .toc par GuildUp_Version.lua)
	titre:SetText("SMB Forever" .. ((ns.Version and ns.Version ~= "") and (" · " .. ns.Version) or ""))
	f.sousTitre = Texte(tete, "GameFontHighlightSmall", C.gris)
	f.sousTitre:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -3)

	local fermer = UI.Fermer(tete, function() f:Hide() end, 30)
	fermer:SetPoint("RIGHT", tete, "RIGHT", -10, 0)
	-- alerte « Profil incomplet » à gauche de la croix, tant que le profil n'est pas complet
	-- (pseudo, personnage principal, rôle choisi à la main : GuildUp_Identite.lua) ; clic = la fenêtre
	-- « Complète ton profil »
	f.alerte = UI.BoutonAlerte(tete, "Profil incomplet", 162, 30)
	f.alerte:SetPoint("RIGHT", fermer, "LEFT", -12, 0)
	f.alerte:SetScript("OnClick", function() if ns.OuvrirProfil then ns.OuvrirProfil() end end)
	f.alerte:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
		GameTooltip:SetText("Complète ton profil")
		local manque = ns.ManquesProfil and ns.ManquesProfil() or {}
		if #manque > 0 then
			GameTooltip:AddLine("Il manque :", 1, 1, 1)
			for _, m in ipairs(manque) do GameTooltip:AddLine("  • " .. m, C.aide[1], C.aide[2], C.aide[3]) end
		end
		GameTooltip:AddLine("La guilde voit ton pseudo et ton personnage principal au survol de ton nom ; ton rôle sert aux groupes et aux bannières.", 0.7, 0.7, 0.7, true)
		GameTooltip:AddLine("Clic : compléter", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	f.alerte:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.alerte:Hide()
	-- choix du rôle : trois boutons collés, dans un cadre placé à gauche de l'alerte (ou de la croix)
	f.zoneRole = CreateFrame("Frame", nil, tete)
	f.zoneRole:SetSize(3 * 55 + 1, 26)
	f.zoneRole:SetPoint("RIGHT", tete, "RIGHT", -50, 0)
	local x = 0
	for i = 3, 1, -1 do
		local role = ({ "tank", "heal", "dps" })[i]
		local b = CreateFrame("Button", nil, f.zoneRole, "BackdropTemplate")
		Habiller(b, { 0, 0, 0, 0 }, C.bord)
		b:SetSize(56, 26)
		b:SetPoint("RIGHT", f.zoneRole, "RIGHT", x, 0)
		x = x - 55
		b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		b.texte:SetPoint("CENTER")
		b.texte:SetText(NOMS_ROLES[role])
		-- « auto » : rôle déduit du groupe ou de la spécialisation, pas choisi à la main
		b.auto = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		b.auto:SetPoint("TOP", b, "BOTTOM", 0, -1)
		b.auto:SetText("auto")
		b.auto:SetTextColor(unpack(C.gris))
		local survol = b:CreateTexture(nil, "HIGHLIGHT")
		survol:SetAllPoints()
		survol:SetColorTexture(1, 1, 1, 0.08)
		b:SetScript("OnClick", function() if ns.ChoisirRole then ns.ChoisirRole(role) end; MajEntete() end)
		Infobulle(b, NOMS_ROLES[role], "Clic : annoncer ce rôle à la guilde.\nRe-clic : revenir en automatique (rôle de groupe ou spécialisation).")
		boutonsRole[role] = b
	end
	local tRole = Texte(f.zoneRole, "GameFontHighlightSmall", C.gris)
	tRole:SetPoint("RIGHT", f.zoneRole, "LEFT", -6, 0)
	tRole:SetText("Mon rôle")

	-- menu à gauche
	local menu = Cadre(f, C.menu)
	menu:SetPoint("TOPLEFT", tete, "BOTTOMLEFT", 0, 0)
	menu:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 1)
	menu:SetWidth(LARGEUR_MENU)
	local bordMenu = menu:CreateTexture(nil, "ARTWORK")
	bordMenu:SetColorTexture(unpack(C.bord))
	bordMenu:SetWidth(1)
	bordMenu:SetPoint("TOPRIGHT", menu, "TOPRIGHT", 0, 0)
	bordMenu:SetPoint("BOTTOMRIGHT", menu, "BOTTOMRIGHT", 0, 0)
	for i, s in ipairs(SECTIONS) do ElementMenu(menu, s, -10 - (i - 1) * 36) end
	local options = ElementMenu(menu, OPTIONS, 0)
	options:ClearAllPoints()
	options:SetPoint("BOTTOMLEFT", menu, "BOTTOMLEFT", 8, 10)
	local sos = Bouton(menu, "À l'aide !", "aide", LARGEUR_MENU - 16, 36)
	sos:SetPoint("BOTTOMLEFT", options, "TOPLEFT", 0, 8)
	sos:SetScript("OnClick", function() if ns.DemanderAide then ns.DemanderAide() end end)
	Infobulle(sos, "Besoin d'aide", "Appelle la guilde à l'aide (quête difficile, escorte, élite…). Les membres qui ont le niveau reçoivent une bulle avec ta zone et un repère sur la carte.")

	-- zone des pages
	f.contenu = CreateFrame("Frame", nil, f)
	f.contenu:SetPoint("TOPLEFT", menu, "TOPRIGHT", 0, 0)
	f.contenu:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)

	-- tant qu'elle est ouverte : mise à jour toutes les 2 s (distances, appels, compteurs) ; une page
	-- lourde (p.rafraichirAuto = false) ne suit pas ce rythme : son module la rafraîchit sur ses
	-- évènements (ns.MajInterface)
	local attente = 0
	f:SetScript("OnUpdate", function(_, ecoule)
		attente = attente + ecoule
		if attente < 2 then return end
		attente = 0
		MajEntete()
		local p = pages[pageActive]
		if p and p.Maj and p.rafraichirAuto ~= false then p.Maj() end
	end)
	-- première ouverture de la session : la fenêtre « Complète ton profil » si le profil est incomplet
	-- (une seule fois : ensuite, l'alerte du bandeau suffit)
	local profilPropose = false
	f:SetScript("OnShow", function()
		ns.MajInterface()
		if profilPropose then return end
		profilPropose = true
		if ns.ProfilComplet and not ns.ProfilComplet() and ns.OuvrirProfil then ns.OuvrirProfil() end
	end)
	f:Hide()
	return f
end

local function Preparer()
	if not DB() then return false end
	if not fenetre then
		fenetre = ns.AvecSons and ns.AvecSons(CreerFenetre(), "fenetre") or CreerFenetre()
		Aller("accueil")
	end
	return true
end

ns.BasculerInterface = function()
	if not Preparer() then return end
	if fenetre:IsShown() then fenetre:Hide() else fenetre:Show(); Aller(pageActive) end
end

-- ns.OuvrirInterface(page, ...) : ouvre la fenêtre sur une page ; les arguments suivants vont à
-- p.Ouvrir de la page (onglet, objet…)
ns.OuvrirInterface = function(id, ...)
	if not Preparer() then return end
	if id and not CREER_PAGE[id] then Aller(id); return end
	fenetre:Show()
	Aller(id or pageActive)
	local p = pages[pageActive]
	if p and p.Ouvrir and select("#", ...) > 0 then p.Ouvrir(...) end
end
ns.PageInterface = function() return fenetre and fenetre:IsShown() and pageActive or nil end

-- compteurs du médaillon : les appels à l'aide expirent et les demandes changent sans prévenir
if C_Timer and C_Timer.NewTicker then
	C_Timer.NewTicker(5, function() if ns.MajBouton then ns.MajBouton() end end)
end
