-- GuildUpSMB : « Jouer ensemble » (page de la fenêtre SMB Forever, kit ns.UI).
-- Ce que je peux faire maintenant avec la guilde, calculé avec ce que l'addon sait déjà :
--   * quêtes en commun (GuildUp_Quetes.lua, ns.QuetesEnCommun) regroupées par zone : « 3 quêtes en commun
--     en Marche de l'Ouest » avec les membres en ligne qui les ont → « Former le groupe » (invitations) ;
--   * membres « dispo pour grouper » proches de mon niveau (dans ma zone d'abord) → « Inviter » ;
--   * groupes ouverts de la guilde (GuildUp_Groupes.lua) qui cherchent mon rôle, ou montés pour une de mes
--     quêtes → « Postuler ».
-- Chaque suggestion a un score (nombre de quêtes, membres dispo, même zone, écart de niveau) ; les mieux
-- notées d'abord. Clic droit sur une suggestion : l'ignorer jusqu'à la fin de la session.
-- À droite, « Dispo maintenant » : les membres en ligne qui ont activé « Dispo pour grouper ».
-- Statut « Dispo pour grouper » : pour la session (remis à non à la connexion), case de la page et menu rapide
-- du médaillon. Préfixe "GuildUpEns", canal GUILD :
--   "D~1" / "D~0"  je suis dispo / je ne le suis plus ; "D~1" redit toutes les 10 min tant que je le suis
--                  (un dispo sans nouvelle depuis 25 min est oublié, comme un membre hors ligne)
--   "Q"            « qui est dispo ? » (à la connexion) : les membres dispo répondent "D~1"

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpEns"
local RAPPEL = 600
local OUBLI = 1500
local MAX_SUGGESTIONS = 5
local ECART_NIVEAU = 5        -- membres dispo suggérés : au plus 5 niveaux d'écart

local UI = ns.UI
local C = UI and UI.C
local NomCourt = ns.NomCourt
local Normaliser = ns.Normaliser

local monDispo = false
local dispos = {}             -- [clé] = GetTime() du dernier "D~1"
local ignorees = {}           -- [clé de suggestion] = true (session)
local cache, cacheA = nil, -10 -- suggestions calculées et quand (GetTime)

local function MaCle() return ns.MaCle and ns.MaCle() end
local function Envoyer(msg, jetable)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD", nil, jetable and { jetable = true } or nil) end
end
-- fenêtre ouverte : page et compteur du menu à jour
local function MajPage()
	cacheA = -10
	if ns.PageInterface and ns.PageInterface() and ns.MajInterface then ns.MajInterface() end
end
local function Message(texte)
	local f = ns.Coeur and ns.Coeur.Message
	if f then f(texte) end
end

--------------------------------------------------------------------------------
-- Statut « Dispo pour grouper »
--------------------------------------------------------------------------------

ns.EstDispo = function() return monDispo end
ns.BasculerDispo = function(oui)
	if oui == nil then oui = not monDispo end
	oui = oui and true or false
	if oui == monDispo then return end
	monDispo = oui
	Envoyer(oui and "D~1" or "D~0")
	Message(oui and "tu es dispo pour grouper : la guilde le voit dans « Jouer ensemble »." or "tu n'es plus dispo pour grouper.")
	MajPage()
end

-- membre dispo (en ligne d'après la liste de guilde, nouvelle reçue depuis moins de 25 min)
local function MembreDispo(cle)
	if cle == MaCle() then return monDispo end
	local t = dispos[cle]
	if not t then return false end
	if GetTime() - t > OUBLI then dispos[cle] = nil; return false end
	if ns.EnLigneMembre and ns.MembreGuilde and ns.MembreGuilde((cle:gsub("#test$", ""))) ~= nil
		and not ns.EnLigneMembre((cle:gsub("#test$", ""))) then
		dispos[cle] = nil
		return false
	end
	return true
end
ns.MembreDispo = MembreDispo

local function Recevoir(prefixe, msg, canal, expediteur)
	if not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if not cle then return end
	if cle == MaCle() then
		if not (ns.TestSolo and ns.TestSolo()) then return end
		cle = cle .. "#test"
	end
	if msg == "Q" then
		if monDispo then C_Timer.After(1 + math.random() * 5, function() if monDispo then Envoyer("D~1", true) end end) end
	elseif msg == "D~1" then
		local nouveau = not dispos[cle]
		dispos[cle] = GetTime()
		if nouveau then MajPage() end
	elseif msg == "D~0" then
		if dispos[cle] then dispos[cle] = nil; MajPage() end
	end
end
ns.Ecouter(PREFIXE, Recevoir)

--------------------------------------------------------------------------------
-- Suggestions
--------------------------------------------------------------------------------

local function EnGroupe() return IsInGroup and IsInGroup() or false end
local function PeutInviter()
	return not EnGroupe() or UnitIsGroupLeader("player") or (UnitIsGroupAssistant and UnitIsGroupAssistant("player")) or false
end
local function DansMonGroupe(nom)
	return EnGroupe() and ns.Groupes and ns.Groupes.DansMonGroupe and ns.Groupes.DansMonGroupe(nom) or false
end

local function Inviter(membres)
	local inviter = (C_PartyInfo and C_PartyInfo.InviteUnit) or InviteUnit
	if not inviter then return end
	for _, m in ipairs(membres) do
		local nom = (ns.NomListeGuilde and ns.NomListeGuilde(m.cle)) or m.nom
		if nom then pcall(inviter, nom) end
	end
end

-- infos d'un membre en ligne : nom, niveau, zone, classe, rôle, dispo, distance
local function Membre(roster, cle, nom)
	local e = roster[(cle:gsub("#test$", ""))]
	local m = { cle = cle, nom = (e and e.nom) or nom or cle, niveau = e and tonumber(e.niveau), zone = e and e.zone,
		classe = e and e.classe, enLigne = (e == nil) or e.enLigne }
	m.role = ns.RoleDeNom and ns.RoleDeNom(cle)
	m.dispo = MembreDispo(cle)
	if ns.DistanceMembre then m.distance, m.unite = ns.DistanceMembre(cle) end
	return m
end

local function TexteRole(role) return (role and UI.TexteRole) and UI.TexteRole(role) or "" end

local function Calculer()
	local res = {}
	local roster = {}
	for _, e in ipairs(ns.RosterGuilde and ns.RosterGuilde() or {}) do roster[e.cle] = e end
	local maCle = MaCle()
	local monNiveau = UnitLevel("player") or 0
	local maZone = (GetRealZoneText and GetRealZoneText()) or ""
	local monRole = ns.MonRole and ns.MonRole()
	local dejaSuggeres = {}

	-- 1. quêtes en commun, par zone (membres en ligne, pas déjà dans mon groupe)
	local zones = {}
	for _, q in ipairs(ns.QuetesEnCommun and ns.QuetesEnCommun() or {}) do
		local z = (q.zone and q.zone ~= "") and q.zone or "?"
		for _, m in ipairs(q.membres or {}) do
			if m.enLigne and not m.groupe then
				local zz = zones[z]
				if not zz then zz = { quetes = {}, nQuetes = 0, membres = {} }; zones[z] = zz end
				if not zz.quetes[q.id] then zz.quetes[q.id] = q.titre; zz.nQuetes = zz.nQuetes + 1 end
				local mm = zz.membres[m.cle]
				if not mm then mm = Membre(roster, m.cle, m.nom); mm.n = 0; zz.membres[m.cle] = mm end
				mm.n = mm.n + 1
			end
		end
	end
	for z, zz in pairs(zones) do
		local membres = {}
		for _, m in pairs(zz.membres) do membres[#membres + 1] = m end
		table.sort(membres, function(a, b)
			if a.n ~= b.n then return a.n > b.n end
			if a.dispo ~= b.dispo then return a.dispo end
			return (a.distance or 1e9) < (b.distance or 1e9)
		end)
		while #membres > 4 do table.remove(membres) end
		local titres = {}
		for _, t in pairs(zz.quetes) do titres[#titres + 1] = t end
		table.sort(titres)
		local sous = table.concat(titres, " · ", 1, math.min(3, #titres)) .. (#titres > 3 and " · …" or "")
		local score = zz.nQuetes * 10 + #membres * 5 + (z == maZone and 15 or 0)
		for _, m in ipairs(membres) do
			if m.dispo then score = score + 8 end
			dejaSuggeres[m.cle] = true
		end
		res[#res + 1] = { cle = "z:" .. z, genre = "quetes", score = score, membres = membres,
			titre = ("%d quête%s en commun %s %s"):format(zz.nQuetes, zz.nQuetes > 1 and "s" or "", z == "?" and "avec" or "en", z == "?" and "la guilde" or z),
			sous = sous, bouton = EnGroupe() and "Inviter" or "Former le groupe",
			actif = PeutInviter(), action = function(s) Inviter(s.membres) end }
	end

	-- 2. membres dispo proches de mon niveau
	for cle in pairs(dispos) do
		if cle ~= maCle and not dejaSuggeres[cle] and MembreDispo(cle) then
			local m = Membre(roster, cle)
			local ecart = m.niveau and math.abs(m.niveau - monNiveau) or 0
			if m.enLigne and ecart <= ECART_NIVEAU and not DansMonGroupe(m.nom) then
				local memeZone = m.zone and m.zone == maZone
				res[#res + 1] = { cle = "d:" .. cle, genre = "dispo", score = 20 + (memeZone and 15 or 0) - ecart * 2,
					membres = { m },
					titre = ("%s est dispo pour grouper"):format(NomCourt(m.nom)),
					sous = ("%s%s%s"):format(m.niveau and ("niveau " .. m.niveau) or "",
						m.role and (" · " .. TexteRole(m.role)) or "",
						memeZone and " · dans ta zone" or (m.zone and (" · " .. m.zone) or "")),
					bouton = "Inviter", actif = PeutInviter(), action = function(s) Inviter(s.membres) end }
			end
		end
	end

	-- 3. groupes ouverts de la guilde qui cherchent mon rôle, ou montés pour une de mes quêtes
	local etat = ns.Groupes and ns.Groupes.etat
	if etat and not EnGroupe() then
		local mesQuetes = {}
		for _, q in ipairs(ns.QuetesEnCommun and ns.QuetesEnCommun() or {}) do mesQuetes[q.id] = true end
		for id, a in pairs(etat.annonces or {}) do
			local libres = ns.Groupes.PlacesLibres and ns.Groupes.PlacesLibres(a, monRole)
			local pasLeMien = not (etat.monAnnonce and id == etat.monAnnonce.id)
			local cand = etat.candidatures and etat.candidatures[id]
			if pasLeMien and (a.membres or 1) < (a.taille or 5) and (libres == nil or libres > 0) and cand ~= "refusee" then
				local info = ns.Groupes.InfoContenu and ns.Groupes.InfoContenu(a.code) or {}
				local quete = tostring(a.code or ""):match("^q(%d+)$")
				local maQuete = quete and mesQuetes[tonumber(quete)]
				local chef = Normaliser(a.chef or "")
				res[#res + 1] = { cle = "g:" .. tostring(id), genre = "groupe", icone = info.icone,
					score = 25 + (maQuete and 20 or 0) + (monRole and 5 or 0),
					membres = chef and { Membre(roster, chef, a.chef) } or {},
					titre = ("%s cherche %s pour %s"):format(NomCourt(a.chef or "?"),
						monRole and ("un " .. TexteRole(monRole)) or "du monde", info.nom or "un groupe"),
					sous = ("%d/%d%s"):format(a.membres or 1, a.taille or 5, maQuete and " · tu as cette quête" or ""),
					bouton = cand == "envoyee" and "Envoyée" or "Postuler", actif = cand ~= "envoyee",
					action = function() if ns.Groupes.Postuler then ns.Groupes.Postuler(id) end end }
			end
		end
	end

	-- tri, suggestions ignorées retirées
	local garde = {}
	for _, s in ipairs(res) do if not ignorees[s.cle] then garde[#garde + 1] = s end end
	table.sort(garde, function(a, b)
		if a.score ~= b.score then return a.score > b.score end
		return a.cle < b.cle
	end)
	while #garde > MAX_SUGGESTIONS do table.remove(garde) end
	return garde
end

-- Suggestions du moment (recalculées au plus toutes les 2 s)
ns.SuggestionsEnsemble = function()
	if not cache or GetTime() - cacheA >= 2 then
		local ok, l = pcall(Calculer)
		cache, cacheA = ok and l or {}, GetTime()
		if not ok then ns.DerniereErreurEnsemble = l end
	end
	return cache
end
ns.NombreSuggestions = function() return #ns.SuggestionsEnsemble() end

-- Membres dispo en ligne (moi compris si je le suis), triés par écart de niveau
ns.MembresDispo = function()
	local roster = {}
	for _, e in ipairs(ns.RosterGuilde and ns.RosterGuilde() or {}) do roster[e.cle] = e end
	local monNiveau = UnitLevel("player") or 0
	local l = {}
	for cle in pairs(dispos) do
		if MembreDispo(cle) then l[#l + 1] = Membre(roster, cle) end
	end
	table.sort(l, function(a, b)
		local ea, eb = math.abs((a.niveau or monNiveau) - monNiveau), math.abs((b.niveau or monNiveau) - monNiveau)
		if ea ~= eb then return ea < eb end
		return a.nom < b.nom
	end)
	return l
end

--------------------------------------------------------------------------------
-- Page « Jouer ensemble »
--------------------------------------------------------------------------------

local MARGE = 16
local HAUTEUR_SUGG, ECART_SUGG = 78, 8
local LARGEUR_DISPO = 250
local HAUTEUR_DISPO = 46

local function CreerSuggestion(parent)
	local r = UI.Rangee(parent, HAUTEUR_SUGG)
	r.icone = r:CreateTexture(nil, "ARTWORK")
	r.icone:SetSize(40, 40)
	r.icone:SetPoint("LEFT", r, "LEFT", 14, 0)
	r.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	r.bouton = UI.Bouton(r, "", "or", 140, 30)
	r.bouton:SetPoint("RIGHT", r, "RIGHT", -14, 0)
	r.titre = UI.Texte(r, "GameFontHighlight", C.texte)
	r.titre:SetPoint("TOPLEFT", r, "TOPLEFT", 66, -12)
	r.titre:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("TOPLEFT", r.titre, "BOTTOMLEFT", 0, -4)
	r.sous:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r.portraits = {}
	for i = 1, 4 do
		local po = UI.Portrait(r, 22)
		po:SetPoint("BOTTOMLEFT", r, "BOTTOMLEFT", 66 + (i - 1) * 16, 10)
		po:SetFrameLevel(r:GetFrameLevel() + 1 + i)
		r.portraits[i] = po
	end
	r.membres = UI.Texte(r, "GameFontHighlightSmall", C.texte)
	r.membres:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	r:SetScript("OnClick", function(self, bouton)
		if bouton == "RightButton" and self.s then
			ignorees[self.s.cle] = true
			cacheA = -10
			if ns.MajInterface then ns.MajInterface() end
		end
	end)
	r:SetScript("OnEnter", function(self)
		if not self.s then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.s.titre, 1, 0.82, 0, 1, true)
		for _, m in ipairs(self.s.membres or {}) do
			GameTooltip:AddLine(("%s%s|r%s%s%s"):format(ns.CouleurClasseTexte and ns.CouleurClasseTexte(m.classe) or "",
				NomCourt(m.nom), m.niveau and ("  " .. m.niveau) or "", m.role and ("  " .. TexteRole(m.role)) or "",
				m.dispo and "  |cff6fd08cdispo|r" or ""), 1, 1, 1)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Clic droit : ignorer cette suggestion", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	r:SetScript("OnLeave", function() GameTooltip:Hide() end)
	r.bouton:SetScript("OnClick", function(self)
		local s = self:GetParent().s
		if s and s.action then s.action(s) end
		cacheA = -10
		if ns.MajInterface then ns.MajInterface() end
	end)
	return r
end

local ICONES = {
	quetes = "Interface\\Icons\\INV_Misc_Note_06",
	dispo = "Interface\\Icons\\INV_Misc_GroupNeedMore",
	groupe = "Interface\\Icons\\INV_Sword_04",
}

local function RemplirSuggestion(r, s)
	r.s = s
	r.icone:SetTexture(s.icone or ICONES[s.genre] or ICONES.quetes)
	r.titre:SetText(s.titre)
	r.sous:SetText(s.sous or "")
	r.bouton:Ecrire(s.bouton)
	r.bouton:Activer(s.actif and true or false)
	local noms = {}
	for i, po in ipairs(r.portraits) do
		local m = s.membres and s.membres[i]
		if m then
			po:Poser(m.cle, m.classe)
			po:Show()
			noms[#noms + 1] = ("%s%s|r%s"):format(ns.CouleurClasseTexte and ns.CouleurClasseTexte(m.classe) or "", NomCourt(m.nom),
				m.niveau and (" |cff9c9380" .. m.niveau .. "|r") or "")
		else
			po:Hide()
		end
	end
	local n = s.membres and #s.membres or 0
	r.membres:ClearAllPoints()
	r.membres:SetPoint("LEFT", r, "BOTTOMLEFT", 66 + math.max(1, math.min(n, 4)) * 16 + 12, 21)
	r.membres:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r.membres:SetText(table.concat(noms, ", "))
	-- groupe de la guilde : l'icône du contenu ; sinon les portraits suffisent
	r:SetBackdropBorderColor(unpack(s.score >= 40 and C.bordFort or C.bord))
end

local function CreerDispo(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetHeight(HAUTEUR_DISPO)
	b.portrait = UI.Portrait(b, 32)
	b.portrait:SetPoint("LEFT", b, "LEFT", 0, 0)
	b.role = UI.Texte(b, "GameFontHighlightSmall")
	b.role:SetPoint("RIGHT", b, "RIGHT", 0, 0)
	b.role:SetJustifyH("RIGHT")
	b.nom = UI.Texte(b, "GameFontHighlight")
	b.nom:SetPoint("TOPLEFT", b.portrait, "TOPRIGHT", 8, -1)
	b.nom:SetPoint("RIGHT", b.role, "LEFT", -6, 0)
	b.sous = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.sous:SetPoint("BOTTOMLEFT", b.portrait, "BOTTOMRIGHT", 8, 1)
	b.sous:SetPoint("RIGHT", b, "RIGHT", 0, 0)
	b.ligne = b:CreateTexture(nil, "BACKGROUND")
	b.ligne:SetColorTexture(C.bord[1], C.bord[2], C.bord[3], 0.6)
	b.ligne:SetHeight(1)
	b.ligne:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 0, -3)
	b.ligne:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, -3)
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	b:SetScript("OnClick", function(self, bouton)
		local m = self.m
		if not m then return end
		if bouton == "RightButton" then Inviter({ m }) else UI.Chuchoter(m.cle, m.nom) end
	end)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(self.m and NomCourt(self.m.nom) or "")
		GameTooltip:AddLine("Clic : chuchoter · clic droit : inviter", 0.8, 0.8, 0.8)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	if UI.SonClic then UI.SonClic(b) end
	return b
end

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -18)
	titre:SetText("Jouer ensemble")
	local aide = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	aide:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	aide:SetText("Ce que tu peux faire maintenant avec la guilde, d'après tes quêtes, ta zone et ton niveau.")

	p.dispo = UI.Case(p, "Dispo pour grouper", function(oui) ns.BasculerDispo(oui) end)
	p.dispo:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -24)
	p.dispo:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText("Dispo pour grouper")
		GameTooltip:AddLine("La guilde te voit dans « Dispo maintenant » et peut te proposer un groupe. Jusqu'à ta déconnexion (aussi dans le menu rapide du médaillon).", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	p.dispo:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- à droite : Dispo maintenant
	local cote = UI.Carte(p, "Dispo maintenant")
	cote:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -64)
	cote:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, MARGE)
	cote:SetWidth(LARGEUR_DISPO)
	cote.lignes = {}
	for i = 1, 8 do
		local b = CreerDispo(cote)
		b:SetPoint("TOPLEFT", cote, "TOPLEFT", 14, -38 - (i - 1) * (HAUTEUR_DISPO + 6))
		b:SetPoint("RIGHT", cote, "RIGHT", -14, 0)
		cote.lignes[i] = b
	end
	cote.vide = UI.Texte(cote, "GameFontHighlightSmall", C.gris)
	cote.vide:SetPoint("TOPLEFT", cote, "TOPLEFT", 14, -40)
	cote.vide:SetPoint("RIGHT", cote, "RIGHT", -14, 0)
	cote.vide:SetWordWrap(true)
	cote.vide:SetText("Personne n'est dispo pour l'instant. Coche « Dispo pour grouper » pour apparaître ici chez les autres.")

	-- à gauche : suggestions
	p.lignes = {}
	for i = 1, MAX_SUGGESTIONS do
		local r = CreerSuggestion(p)
		r:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -64 - (i - 1) * (HAUTEUR_SUGG + ECART_SUGG))
		r:SetPoint("RIGHT", cote, "LEFT", -14, 0)
		p.lignes[i] = r
	end
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE + 4, -72)
	p.vide:SetPoint("RIGHT", cote, "LEFT", -18, 0)
	p.vide:SetWordWrap(true)
	p.vide:SetText("Rien à proposer pour l'instant. Les suggestions viennent des quêtes que tu partages avec d'autres membres, des membres dispo et des groupes de la guilde.")
	p.astuce = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.astuce:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", MARGE, MARGE + 2)
	p.astuce:SetPoint("RIGHT", cote, "LEFT", -14, 0)
	p.astuce:SetText("Clic droit sur une suggestion : l'ignorer. Survol : le détail des membres.")

	p.Maj = function()
		p.dispo:Poser(monDispo)
		local liste = ns.SuggestionsEnsemble()
		for i, r in ipairs(p.lignes) do
			local s = liste[i]
			if s then RemplirSuggestion(r, s); r:Show() else r:Hide(); r.s = nil end
		end
		p.vide:SetShown(#liste == 0)
		local dispoListe = ns.MembresDispo()
		cote.compte:SetText(#dispoListe > 0 and tostring(#dispoListe) or "")
		for i, b in ipairs(cote.lignes) do
			local m = dispoListe[i]
			if m then
				b.m = m
				b.portrait:Poser(m.cle, m.classe)
				b.nom:SetText(("%s%s|r"):format(ns.CouleurClasseTexte and ns.CouleurClasseTexte(m.classe) or "", NomCourt(m.nom)))
				b.sous:SetText((m.niveau and (m.niveau .. " · ") or "") .. (m.zone or ""))
				b.role:SetText(TexteRole(m.role))
				b:Show()
			else
				b:Hide()
				b.m = nil
			end
		end
		cote.vide:SetShown(#dispoListe == 0)
	end
	return p
end
if ns.AjouterPage then ns.AjouterPage("ensemble", CreerPage) end

-- /smb ensemble, menu rapide : ouvrir la page
ns.OuvrirEnsemble = function() if ns.OuvrirInterface then ns.OuvrirInterface("ensemble") end end

ns.DiagEnsemble = function(L)
	local n = 0
	for cle in pairs(dispos) do if MembreDispo(cle) then n = n + 1 end end
	L(("jouer ensemble : moi %s ; %d membre(s) dispo ; %d suggestion(s)%s"):format(monDispo and "dispo" or "pas dispo", n,
		#ns.SuggestionsEnsemble(), ns.DerniereErreurEnsemble and (" ; erreur : " .. tostring(ns.DerniereErreurEnsemble)) or ""))
end

--------------------------------------------------------------------------------
-- Évènements : « qui est dispo ? » à la connexion, rappel toutes les 10 min, groupe qui change
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE" }) do pcall(ev.RegisterEvent, ev, nom) end
local premiere = true
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		C_Timer.After(16, function() Envoyer("Q") end)
		if C_Timer.NewTicker then
			C_Timer.NewTicker(RAPPEL, function() if monDispo then Envoyer("D~1", true) end end)
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		cacheA = -10
	end
end)
