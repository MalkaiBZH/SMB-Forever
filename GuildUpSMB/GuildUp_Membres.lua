-- GuildUpSMB : page « Guilde » de la fenêtre SMB Forever (ns.AjouterPage("guilde"), kit ns.UI).
-- Tous les membres de la liste de guilde du jeu, en ligne et hors ligne, avec tout ce que l'addon sait
-- d'eux : portrait, nom à la couleur de la classe, niveau, classe, rang, en ligne (zone) ou vu il y a…,
-- pseudo et personnages (identités), rôle annoncé, SMB Forever (et sa version si connue), métiers et
-- niveaux (fiches du registre), position partagée sur ma carte (distance), note publique de guilde.
-- En haut : recherche (nom, pseudo, zone, métier, rang, note), puces Tous / En ligne / Avec l'addon,
-- tri (en ligne d'abord, par niveau, par rang), compteur, bouton « Mon profil » (ns.OuvrirProfil).
-- Rangée sur deux lignes (identité ; détails), infobulle complète au survol, clic = chuchoter (en
-- ligne), clic droit = menu (Chuchoter, Inviter dans le groupe). Liste « virtuelle » : seules les
-- rangées visibles existent, réutilisées au défilement (une guilde peut compter des centaines de membres).
-- Données lues ailleurs : ns.RosterGuilde() et ns.FicheMetiers() (GuildUp_Metiers.lua), ns.Identite()
-- et ns.LignesIdentite() (GuildUp_Identite.lua), ns.RoleDeNom() (GuildUp.lua), ns.PositionsMembres()
-- (GuildUp_Carte.lua), ns.DistanceMembre() (GuildUp_Interface.lua), ns.VersionMembre() si
-- GuildUp_Version.lua la fournit. « Avec l'addon » = un signe de SMB Forever reçu de ce joueur (version,
-- identité, fiche métiers, position ou rôle annoncé).
-- Rafraîchie sur GUILD_ROSTER_UPDATE (la liste est demandée au jeu à l'ouverture de la page), quand une
-- identité ou le profil change (ns.MajMembres) et toutes les 10 s tant qu'elle est affichée (fiches,
-- positions, rôles). Aucun message réseau.

local NOM_ADDON, ns = ...
local NomCourt = ns.NomCourt
local Simplifier = ns.Simplifier
local CouleurClasseTexte = ns.CouleurClasseTexte

local UI = ns.UI
local C = UI.C
local MARGE = 16
local HAUTEUR_RANGEE, ECART_RANGEE = 46, 4
local PAS = HAUTEUR_RANGEE + ECART_RANGEE
local HAUT_LISTE = -104       -- haut de la liste (sous le titre, la recherche et les filtres)
local HAUTEUR_VUE = 470       -- hauteur de la liste avant la première mise en page
local RAFRAICHIR = 10         -- secondes entre deux rafraîchissements tant que la page est affichée
local FRAIS = 45              -- secondes : position partagée encore valable (comme la carte)

local FILTRES = { "Tous", "En ligne", "Avec l'addon" }
local TRIS = { { "enligne", "En ligne d'abord" }, { "niveau", "Par niveau" }, { "rang", "Par rang" } }

local GRIS = "|cff9c9380"
local VERT = "|cff6fd08c"
local OR = "|cfff1cf6b"
local CLAIR = "|cffd9cfb8"

local filtre, tri, recherche = 1, "enligne", ""
local page
local membres = {}            -- membres affichés (après recherche, filtre et tri)

--------------------------------------------------------------------------------
-- Ce que l'addon sait d'un membre
--------------------------------------------------------------------------------

-- métiers d'une fiche, du plus haut niveau au plus bas : { nom, n, max, recettes }
local function Metiers(fiche)
	local l = {}
	if not (fiche and type(fiche.profs) == "table") then return l end
	for code, p in pairs(fiche.profs) do
		if type(p) == "table" then
			l[#l + 1] = { nom = (ns.NomMetierCode and ns.NomMetierCode(code)) or code, n = tonumber(p.n) or 0,
				max = tonumber(p.max), recettes = (type(p.r) == "table" and #p.r > 0) and #p.r or tonumber(p.nr) }
		end
	end
	table.sort(l, function(a, b)
		if a.n ~= b.n then return a.n > b.n end
		return a.nom < b.nom
	end)
	return l
end

-- Nom d'une carte du jeu (zone de la position partagée)
local function NomCarte(carte)
	if not (carte and C_Map and C_Map.GetMapInfo) then return nil end
	local ok, info = pcall(C_Map.GetMapInfo, carte)
	return ok and type(info) == "table" and info.name or nil
end

-- Tout ce qu'on sait d'un membre de la liste de guilde (entrée de ns.RosterGuilde)
local function Infos(e, maCle)
	local cle = e.cle
	local moi = (cle == maCle)
	local m = { e = e, cle = cle, nom = e.nom, moi = moi, enLigne = e.enLigne or moi }
	m.identite = ns.Identite and ns.Identite(cle)
	if moi then
		m.role = ns.MonRole and ns.MonRole()
	else
		m.role = ns.RoleDeNom and ns.RoleDeNom(cle)
	end
	m.fiche = ns.FicheMetiers and ns.FicheMetiers(cle)
	m.metiers = Metiers(m.fiche)
	local positions = ns.PositionsMembres and ns.PositionsMembres()
	local p = positions and positions[cle]
	if p and GetTime() - (p.vu or 0) < FRAIS then m.position = p end
	if m.position and ns.DistanceMembre then m.distance, m.unite = ns.DistanceMembre(cle) end
	if moi then m.version = ns.Version
	elseif ns.VersionMembre then m.version = ns.VersionMembre(cle) end
	m.addon = (moi or m.version or m.identite or m.fiche or m.position or m.role) and true or false
	local id = m.identite
	if id then
		m.pseudo = (id.pseudo and id.pseudo ~= "") and id.pseudo or nil
		m.principal = id.principal
	end
	return m
end

-- texte où chercher : nom, pseudo, personnages, zone, métiers, rang, classe, note
local function TexteRecherche(m)
	local morceaux = { NomCourt(m.nom), m.pseudo or "", m.e.zone or "", m.e.rang or "", m.e.classeNom or "", m.e.note or "" }
	for _, mt in ipairs(m.metiers) do morceaux[#morceaux + 1] = mt.nom end
	if m.identite then
		for _, c in ipairs(m.identite.persos or {}) do morceaux[#morceaux + 1] = NomCourt(c) end
	end
	return Simplifier(table.concat(morceaux, " "))
end

local function TexteAbsence(a)
	if not a then return "hors ligne" end
	if a.ans > 0 then return "vu il y a " .. a.ans .. (a.ans > 1 and " ans" or " an") end
	if a.mois > 0 then return "vu il y a " .. a.mois .. " mois" end
	if a.jours > 0 then return "vu il y a " .. a.jours .. " j" end
	if a.heures > 0 then return "vu il y a " .. a.heures .. " h" end
	return "vu il y a moins d'une heure"
end

local function TexteStatut(statut)
	if statut == "ABS" then return "absent" end
	if statut == "NPD" then return "ne pas déranger" end
end

local function Cle(nom) return Simplifier(NomCourt(nom)) end

local TRIER = {
	enligne = function(a, b)
		if a.enLigne ~= b.enLigne then return a.enLigne end
		return a.tri < b.tri
	end,
	niveau = function(a, b)
		local na, nb = tonumber(a.e.niveau) or 0, tonumber(b.e.niveau) or 0
		if na ~= nb then return na > nb end
		if a.enLigne ~= b.enLigne then return a.enLigne end
		return a.tri < b.tri
	end,
	rang = function(a, b)
		local ra, rb = a.e.rangIndex or 99, b.e.rangIndex or 99
		if ra ~= rb then return ra < rb end
		if a.enLigne ~= b.enLigne then return a.enLigne end
		return a.tri < b.tri
	end,
}

-- Liste affichée et compteurs (tous les membres, en ligne, avec l'addon)
local function Construire(relire)
	local roster = ns.RosterGuilde and ns.RosterGuilde(relire) or {}
	local maCle = ns.MaCle and ns.MaCle()
	local n, enLigne, addon = 0, 0, 0
	wipe(membres)
	for _, e in ipairs(roster) do
		if e.cle then
			local m = Infos(e, maCle)
			n = n + 1
			if m.enLigne then enLigne = enLigne + 1 end
			if m.addon then addon = addon + 1 end
			local garde = (filtre == 1) or (filtre == 2 and m.enLigne) or (filtre == 3 and m.addon)
			if garde and recherche ~= "" and not TexteRecherche(m):find(recherche, 1, true) then garde = false end
			if garde then
				m.tri = Cle(m.nom)
				membres[#membres + 1] = m
			end
		end
	end
	table.sort(membres, TRIER[tri] or TRIER.enligne)
	return n, enLigne, addon, #roster
end

--------------------------------------------------------------------------------
-- Actions : chuchoter, inviter, menu du clic droit
--------------------------------------------------------------------------------

local function NomJeu(m) return (ns.NomListeGuilde and ns.NomListeGuilde(m.cle)) or m.nom end

local function Chuchoter(m)
	if m.moi then return end
	if not m.enLigne then
		if ns.Erreur then ns.Erreur(NomCourt(m.nom) .. " est hors ligne") end
		return
	end
	UI.Chuchoter(m.cle, m.nom)
end

local function Inviter(m)
	if m.moi then return end
	if not m.enLigne then
		if ns.Erreur then ns.Erreur(NomCourt(m.nom) .. " est hors ligne") end
		return
	end
	local inviter = (C_PartyInfo and C_PartyInfo.InviteUnit) or InviteUnit
	if inviter then pcall(inviter, NomJeu(m)) end
end

local menu
local function MontrerMenu(rangee, m)
	menu = menu or ns.CadreMenu("GuildUpMenuMembre")
	local lignes
	if m.moi then
		lignes = { { "Mon profil", function() if ns.OuvrirProfil then ns.OuvrirProfil() end end } }
	else
		local actif = m.enLigne and "" or GRIS
		lignes = {
			{ actif .. "Chuchoter", function() Chuchoter(m) end },
			{ actif .. "Inviter dans le groupe", function() Inviter(m) end },
		}
	end
	for i, l in ipairs(lignes) do
		local b = ns.BoutonMenu(menu, i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", menu, "TOPLEFT", 6, -6 - (i - 1) * 20)
		b:SetPoint("RIGHT", menu, "RIGHT", -6, 0)
		b.texte:SetText(l[1])
		b:SetScript("OnClick", function() menu:Hide(); l[2]() end)
		b:Show()
	end
	for i = #lignes + 1, #menu.boutons do menu.boutons[i]:Hide() end
	menu:SetSize(180, #lignes * 20 + 12)
	menu.ancre = rangee
	menu:ClearAllPoints()
	-- sous le curseur
	local x, y = GetCursorPosition()
	local echelle = UIParent:GetEffectiveScale()
	x, y = tonumber(x), tonumber(y)
	echelle = tonumber(echelle) or 1
	if x and y and echelle > 0 then
		menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / echelle - 8, y / echelle + 8)
	else
		menu:SetPoint("TOPLEFT", rangee, "BOTTOMLEFT", 40, 4)
	end
	menu:Show()
end

--------------------------------------------------------------------------------
-- Infobulle d'un membre
--------------------------------------------------------------------------------

local function Infobulle(self)
	local m = self.m
	if not m then return end
	local e = m.e
	local tt = GameTooltip
	tt:SetOwner(self, "ANCHOR_RIGHT")
	tt:SetText(CouleurClasseTexte(e.classe) .. NomCourt(m.nom) .. "|r" .. (m.moi and (GRIS .. " (toi)|r") or ""))
	tt:AddLine(("Niveau %s %s"):format(tostring(e.niveau or "?"), e.classeNom or ""), 1, 1, 1)
	if e.rang and e.rang ~= "" then tt:AddLine("Rang : " .. e.rang, 0.85, 0.66, 0.25) end
	if m.enLigne then
		local statut = TexteStatut(e.statut)
		tt:AddLine("En ligne" .. ((e.zone and e.zone ~= "") and (" · " .. e.zone) or "")
			.. (statut and (" (" .. statut .. ")") or ""), 0.44, 0.82, 0.55)
	else
		tt:AddLine("Hors ligne · " .. TexteAbsence(e.absence), 0.6, 0.58, 0.5)
	end
	-- pseudo et personnages (identités), principal
	if ns.LignesIdentite then ns.LignesIdentite(tt, m.cle) end
	if m.principal and m.principal ~= m.cle and #((m.identite and m.identite.persos) or {}) < 2 then
		tt:AddLine("|cffffd100Principal :|r " .. NomCourt(m.principal), 1, 1, 1)
	end
	if m.role then tt:AddLine("|cffffd100Rôle :|r " .. UI.TexteRole(m.role), 1, 1, 1) end
	-- SMB Forever
	if m.version then
		tt:AddLine("|cffffd100SMB Forever :|r " .. m.version, 1, 1, 1)
	elseif m.addon then
		tt:AddLine("|cffffd100SMB Forever :|r oui", 1, 1, 1)
	else
		tt:AddLine("SMB Forever : pas encore vu", 0.6, 0.58, 0.5)
	end
	-- métiers
	if #m.metiers > 0 then
		tt:AddLine(" ")
		tt:AddLine("Métiers", 1, 0.82, 0)
		for _, mt in ipairs(m.metiers) do
			tt:AddDoubleLine("  " .. mt.nom, mt.n .. (mt.max and ("/" .. mt.max) or "")
				.. (mt.recettes and (" · " .. mt.recettes .. " recette" .. (mt.recettes > 1 and "s" or "")) or ""),
				1, 1, 1, 0.8, 0.8, 0.8)
		end
	end
	-- position partagée
	if m.position and not m.moi then
		if m.position.instance then
			tt:AddLine("Position : en instance", 0.8, 0.8, 0.8)
		else
			local carte = NomCarte(m.position.carte)
			tt:AddLine("Position : " .. (carte or "partagée")
				.. (m.distance and (" · à " .. math.floor(m.distance + 0.5) .. " " .. (m.unite or "m")) or ""), 0.8, 0.8, 0.8)
		end
	end
	if e.note and e.note ~= "" then
		tt:AddLine(" ")
		tt:AddLine("Note : « " .. e.note .. " »", 0.85, 0.81, 0.72, true)
	end
	tt:AddLine(" ")
	if m.moi then
		tt:AddLine("Clic droit : mon profil", 0.6, 0.6, 0.6)
	elseif m.enLigne then
		tt:AddLine("Clic : chuchoter · Clic droit : menu", 0.6, 0.6, 0.6)
	else
		tt:AddLine("Clic droit : menu", 0.6, 0.6, 0.6)
	end
	tt:Show()
end

--------------------------------------------------------------------------------
-- Rangées (réutilisées : seules les visibles existent)
--------------------------------------------------------------------------------

local function CreerRangee(parent)
	local r = UI.Rangee(parent, HAUTEUR_RANGEE)
	r.portrait = UI.Portrait(r, 34)
	r.portrait:SetPoint("LEFT", r, "LEFT", 8, 0)
	-- point vert « en ligne » sur le bord du portrait
	r.point = r:CreateTexture(nil, "OVERLAY")
	r.point:SetTexture(UI.ROND)
	r.point:SetSize(10, 10)
	r.point:SetPoint("BOTTOMRIGHT", r.portrait, "BOTTOMRIGHT", 1, -1)
	r.point:SetVertexColor(C.vert[1], C.vert[2], C.vert[3], 1)
	r.etat = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.etat:SetPoint("TOPRIGHT", r, "TOPRIGHT", -12, -9)
	r.etat:SetJustifyH("RIGHT")
	r.addon = UI.Texte(r, "GameFontHighlightSmall", C.orFonce)
	r.addon:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", -12, 9)
	r.addon:SetJustifyH("RIGHT")
	r.ligne1 = UI.Texte(r, "GameFontHighlight", C.texte)
	r.ligne1:SetPoint("TOPLEFT", r.portrait, "TOPRIGHT", 10, 1)
	r.ligne1:SetPoint("RIGHT", r.etat, "LEFT", -12, 0)
	r.ligne2 = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.ligne2:SetPoint("BOTTOMLEFT", r.portrait, "BOTTOMRIGHT", 10, 1)
	r.ligne2:SetPoint("RIGHT", r.addon, "LEFT", -12, 0)
	r:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	r:SetScript("OnClick", function(self, bouton)
		local m = self.m
		if not m then return end
		GameTooltip:Hide()
		if bouton == "RightButton" then MontrerMenu(self, m) else Chuchoter(m) end
	end)
	r:SetScript("OnEnter", Infobulle)
	r:SetScript("OnLeave", function() GameTooltip:Hide() end)
	UI.SonClic(r)
	return r
end

local function Remplir(r, m)
	local e = m.e
	r.m = m
	r:Fort(m.moi)
	r.portrait:Poser(m.cle, e.classe)
	r.portrait:SetAlpha(m.enLigne and 1 or 0.45)
	r.point:SetShown(m.enLigne)
	-- ligne 1 : nom, niveau, pseudo, rôle, statut
	local l1 = CouleurClasseTexte(e.classe) .. NomCourt(m.nom) .. "|r"
		.. "  " .. GRIS .. "niv. " .. tostring(e.niveau or "?") .. "|r"
	if m.pseudo then l1 = l1 .. "  " .. OR .. "« " .. m.pseudo .. " »|r" end
	if m.role then l1 = l1 .. "  " .. UI.TexteRole(m.role) end
	if m.moi then l1 = l1 .. "  " .. GRIS .. "(toi)|r" end
	local statut = m.enLigne and TexteStatut(e.statut)
	if statut then l1 = l1 .. "  " .. GRIS .. "<" .. statut .. ">|r" end
	r.ligne1:SetText(l1)
	r.ligne1:SetAlpha(m.enLigne and 1 or 0.7)
	-- ligne 2 : classe, rang, métiers, principal, distance, note
	local d = {}
	if e.classeNom and e.classeNom ~= "" then d[#d + 1] = e.classeNom end
	if e.rang and e.rang ~= "" then d[#d + 1] = e.rang end
	if #m.metiers > 0 then
		local t = {}
		for i = 1, math.min(2, #m.metiers) do t[i] = m.metiers[i].nom .. " " .. m.metiers[i].n end
		d[#d + 1] = CLAIR .. table.concat(t, ", ") .. "|r" .. (#m.metiers > 2 and "…" or "")
	end
	if m.principal and m.principal ~= m.cle then
		d[#d + 1] = "perso de " .. OR .. NomCourt(m.principal) .. "|r"
	end
	if m.distance then
		d[#d + 1] = VERT .. "à " .. math.floor(m.distance + 0.5) .. " " .. (m.unite or "m") .. "|r"
	end
	if e.note and e.note ~= "" then d[#d + 1] = "« " .. e.note .. " »" end
	r.ligne2:SetText(table.concat(d, " · "))
	-- à droite : en ligne (zone) ou vu il y a… ; SMB Forever
	if m.enLigne then
		r.etat:SetText(VERT .. "En ligne|r" .. ((e.zone and e.zone ~= "") and (GRIS .. " · " .. e.zone .. "|r") or ""))
	else
		r.etat:SetText(GRIS .. TexteAbsence(e.absence) .. "|r")
	end
	r.addon:SetText(m.addon and ("SMB" .. (m.version and (" " .. m.version) or "")) or "")
end

-- Dessine les rangées visibles (selon le défilement)
local function Dessiner()
	if not page then return end
	local l = page.liste
	local haut = tonumber(l:GetVerticalScroll()) or 0
	local vue = tonumber(l:GetHeight()) or 0
	if vue < 50 then vue = HAUTEUR_VUE end
	local premier = math.max(1, math.floor(haut / PAS) + 1)
	local dernier = math.min(#membres, premier + math.ceil(vue / PAS))
	local k = 0
	for i = premier, dernier do
		k = k + 1
		local r = page.rangees[k]
		if not r then
			r = CreerRangee(l.contenu)
			page.rangees[k] = r
		end
		Remplir(r, membres[i])
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", l.contenu, "TOPLEFT", 0, -(i - 1) * PAS)
		r:SetPoint("RIGHT", l.contenu, "RIGHT", 0, 0)
		r:Show()
	end
	for i = k + 1, #page.rangees do
		page.rangees[i]:Hide()
		page.rangees[i].m = nil
	end
end

--------------------------------------------------------------------------------
-- Page
--------------------------------------------------------------------------------

local function Visible()
	return page ~= nil and ns.PageInterface and ns.PageInterface() == "guilde"
end

-- rafraîchissement regroupé (rafales d'évènements, frappe dans la recherche)
local prevue = false
local function MajBientot(delai)
	if prevue or not Visible() then return end
	prevue = true
	C_Timer.After(delai or 0.3, function()
		prevue = false
		if Visible() and page.Maj then page.Maj() end
	end)
end

-- (GuildUp_Identite.lua : une identité reçue, le profil changé)
ns.MajMembres = function() MajBientot(0.5) end

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.rafraichirAuto = false -- (liste lourde : évènements, recherche et un rafraîchissement toutes les 10 s)
	page = p

	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -18)
	titre:SetText("Guilde")
	local aide = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	aide:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	aide:SetText("Tous les membres. Survole un membre pour tout voir ; clic : chuchoter, clic droit : menu.")

	p.profil = UI.Bouton(p, "Mon profil", "fantome", 110, 26)
	p.profil:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -14)
	p.profil:SetScript("OnClick", function() if ns.OuvrirProfil then ns.OuvrirProfil() end end)
	UI.Infobulle(p.profil, "Mon profil", "Ton pseudo, ton personnage principal et ton rôle : ce que la guilde voit de toi.")
	p.compte = UI.Texte(p, "GameFontHighlight", C.gris)
	p.compte:SetPoint("RIGHT", p.profil, "LEFT", -14, 0)
	p.compte:SetJustifyH("RIGHT")

	-- recherche, filtres, tri
	p.recherche = UI.Champ(p, 240, "Nom, pseudo, zone, métier…")
	p.recherche:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -64)
	p.recherche.SurTexte = function(t)
		recherche = Simplifier(strtrim(t or ""))
		if p.liste then p.liste:Haut() end
		MajBientot(0.15)
	end
	p.recherche.saisie:SetScript("OnEscapePressed", function(self)
		self:SetText("")
		self:ClearFocus()
		recherche = ""
		MajBientot(0.05)
	end)
	p.puces = UI.Puces(p, FILTRES, function(i)
		filtre = i
		p.puces:Choisir(i)
		p.liste:Haut()
		p.Maj()
	end)
	p.puces:SetPoint("LEFT", p.recherche, "RIGHT", 12, 0)
	p.puces:Choisir(filtre)
	p.tri = UI.Choix(p, 160, TRIS, function(v)
		tri = v
		p.liste:Haut()
		p.Maj()
	end)
	p.tri:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -64)
	p.tri:Poser(tri)
	local tTri = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	tTri:SetPoint("RIGHT", p.tri, "LEFT", -8, 0)
	tTri:SetText("Tri")

	-- liste
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, HAUT_LISTE)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE + 6, 12)
	p.liste:SetScript("OnVerticalScroll", function() Dessiner() end)
	p.liste:HookScript("OnMouseWheel", function() Dessiner() end)
	p.liste:HookScript("OnSizeChanged", function() Dessiner() end)
	p.rangees = {}
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.vide:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	p.vide:SetWordWrap(true)

	-- à l'ouverture : la liste de guilde à jour (GUILD_ROSTER_UPDATE suit)
	p:SetScript("OnShow", function()
		if ns.DemanderRoster then ns.DemanderRoster() end
	end)
	-- tant qu'elle est affichée : fiches, positions et rôles arrivent sans évènement
	local attente = 0
	p:SetScript("OnUpdate", function(_, ecoule)
		attente = attente + (tonumber(ecoule) or 0)
		if attente < RAFRAICHIR then return end
		attente = 0
		if Visible() then p.Maj() end
	end)

	p.Maj = function()
		local n, enLigne, addon = Construire(true)
		p.compte:SetText(n > 0 and (("%d membre%s · %s%d en ligne|r · %d avec l'addon"):format(n, n > 1 and "s" or "",
			VERT, enLigne, addon) .. ((#membres < n) and (GRIS .. " · " .. #membres .. " affiché" .. (#membres > 1 and "s" or "") .. "|r") or ""))
			or "")
		p.liste:Hauteur(#membres * PAS)
		Dessiner()
		p.vide:SetShown(#membres == 0)
		if not (IsInGuild and IsInGuild()) then
			p.vide:SetText("Tu n'es pas dans une guilde.")
		elseif n == 0 then
			p.vide:SetText("Liste de guilde en cours de chargement…")
		elseif recherche ~= "" then
			p.vide:SetText("Aucun membre ne correspond à ta recherche.")
		else
			p.vide:SetText(filtre == 2 and "Aucun membre en ligne." or "Aucun membre avec SMB Forever pour l'instant.")
		end
	end
	-- ns.OuvrirInterface("guilde", texte) : la page avec une recherche
	p.Ouvrir = function(texte)
		if type(texte) ~= "string" then return end
		p.recherche:Ecrire(texte)
		recherche = Simplifier(strtrim(texte))
		p.liste:Haut()
		p.Maj()
	end
	return p
end
if ns.AjouterPage then ns.AjouterPage("guilde", CreerPage) end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
ev:SetScript("OnEvent", function() MajBientot(0.3) end)
