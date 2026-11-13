-- GuildUpSMB : statistiques de présence de la guilde (page « Statistiques », /smb stats ; préfixe "GuildUpSta").
-- Pour savoir quand organiser les sorties : toutes les 10 minutes, chaque addon connecté relève le
-- nombre de membres de la guilde en ligne (liste de guilde du jeu, donc aussi les membres sans l'addon)
-- et le nombre de membres avec l'addon (ns.MembresActifs). Relevés gardés 8 semaines dans
-- GuildUpDB.stats[guilde].r = { [tranche] = "enLigne,avecAddon" }, où « tranche » = heure du serveur
-- divisée par 600 (une tranche de 10 min), en base 36. Commun aux personnages du compte.
-- À la connexion, chaque membre demande les relevés qui lui manquent au relais (ns.EstLeRelais), qui
-- les renvoie : au bout de quelques jours tout le monde a la même courbe. Quand plusieurs relevés
-- existent pour la même tranche, on garde le plus grand.
--   "Q~depuis"                je reviens : envoyez-moi les relevés depuis cette tranche (base 36)
--   "R~tranche:enLigne,addon;…"   relevés (240 octets au plus par message ; 600 tranches au plus par
--                             demande, les plus récentes d'abord ; un message toutes les 1,5 s pour ne
--                             pas bloquer la file d'envoi commune aux autres modules)
-- Page : semaine type (grille 7 jours x 24 heures, moyenne des membres en ligne, clair = beaucoup de
-- monde), les cinq meilleurs créneaux, pic de membres en ligne par jour (barres) sur 28 jours,
-- et aujourd'hui (barres par heure). Les heures sont celles de l'ordinateur du joueur (heure locale)
-- pour la grille et le jour : les relevés sont datés en heure du serveur. Les calculs de la page ne
-- sont refaits que si les relevés ont changé (ou à l'heure suivante), pas à chaque rafraîchissement.
-- Rien n'existe avant l'installation ; une tranche sans aucun membre à l'addon reste vide (comptée 0).

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpSta"
local TRANCHE = 600                     -- secondes
local GARDE = 8 * 7 * 86400             -- 8 semaines
local MAX_RELAIS = 600                  -- tranches renvoyées à un membre qui revient (≈ 4 jours)
local ENTRE_MESSAGES = 1.5              -- secondes entre deux messages du relais
local PREMIER_RELEVE = 60               -- secondes après la connexion
local JOURS = { "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam", "Dim" }

local Maintenant = ns.Maintenant
local Base36 = ns.Base36
local Normaliser = ns.Normaliser
local MaCle = ns.MaCle

local pret = false
local majPrevue = false
local version = 0 -- change à chaque relevé noté ou oublié : la page ne recalcule que dans ce cas

--------------------------------------------------------------------------------
-- Relevés
--------------------------------------------------------------------------------

local function Stats()
	local db = ns.DB and ns.DB()
	local guilde = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not db or not guilde then return nil end
	if type(db.stats) ~= "table" then db.stats = {} end
	local s = db.stats[guilde]
	if type(s) ~= "table" then s = {}; db.stats[guilde] = s end
	if type(s.r) ~= "table" then s.r = {} end
	return s
end

local function Rafraichir()
	if majPrevue then return end
	majPrevue = true
	C_Timer.After(1, function()
		majPrevue = false
		if ns.MajInterface then ns.MajInterface() end
	end)
end

-- note un relevé ; true s'il change quelque chose
local function Noter(tranche, enLigne, addon)
	local s = Stats()
	tranche, enLigne, addon = tonumber(tranche), tonumber(enLigne), tonumber(addon)
	if not s or not tranche or not enLigne or not addon then return false end
	local maintenant = math.floor(Maintenant() / TRANCHE)
	if tranche > maintenant + 1 or tranche < maintenant - GARDE / TRANCHE then return false end
	if enLigne < 0 or enLigne > 1000 or addon < 0 or addon > enLigne then addon = math.min(addon, enLigne) end
	if enLigne < 0 or enLigne > 1000 or addon < 0 then return false end
	local cle = Base36(tranche)
	local actuel = s.r[cle]
	local aE, aA = 0, 0
	if type(actuel) == "string" then
		aE, aA = actuel:match("^(%d+),(%d+)$")
		aE, aA = tonumber(aE) or 0, tonumber(aA) or 0
	end
	if actuel and enLigne <= aE and addon <= aA then return false end
	s.r[cle] = ("%d,%d"):format(math.max(enLigne, aE), math.max(addon, aA))
	version = version + 1
	Rafraichir()
	return true
end

-- oublie les relevés de plus de 8 semaines (une fois par session suffit)
local function Purger()
	local s = Stats()
	if not s then return end
	local limite = math.floor((Maintenant() - GARDE) / TRANCHE)
	for cle in pairs(s.r) do
		local t = tonumber(cle, 36)
		if not t or t < limite then s.r[cle] = nil; version = version + 1 end
	end
end

-- membres de la guilde en ligne d'après la liste du jeu (demandée au passage pour la prochaine fois)
local function EnLigneMaintenant()
	if ns.DemanderRoster then ns.DemanderRoster() end
	local n = 0
	for _, e in ipairs(ns.RosterGuilde and ns.RosterGuilde(true) or {}) do
		if e.enLigne then n = n + 1 end
	end
	return n
end

local function Relever()
	if not pret or not IsInGuild() then return end
	local enLigne = EnLigneMaintenant()
	if enLigne == 0 then enLigne = 1 end -- (je suis en ligne : la liste n'est pas encore lue)
	local addon = ns.MembresActifs and ns.MembresActifs() or 1
	Noter(math.floor(Maintenant() / TRANCHE), enLigne, math.min(addon, enLigne))
end

--------------------------------------------------------------------------------
-- Réseau
--------------------------------------------------------------------------------

local function Envoyer(msg)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end
end

local function Relayer(depuis)
	local s = Stats()
	if not s then return end
	local cles = {}
	for cle in pairs(s.r) do
		local t = tonumber(cle, 36)
		if t and t > depuis then cles[#cles + 1] = t end
	end
	table.sort(cles, function(a, b) return a > b end)
	-- les messages d'abord, puis un toutes les 1,5 s (jusqu'à une trentaine : la file d'envoi est commune
	-- à tout l'addon, une rafale ferait attendre les groupes, votes, appels à l'aide…)
	local messages, msg = {}, "R~"
	for i = 1, math.min(#cles, MAX_RELAIS) do
		local cle = Base36(cles[i])
		local mot = cle .. ":" .. s.r[cle]
		if #msg + #mot + 1 > 240 and #msg > 2 then messages[#messages + 1] = msg; msg = "R~" end
		msg = msg .. (#msg > 2 and ";" or "") .. mot
	end
	if #msg > 2 then messages[#messages + 1] = msg end
	for i, m in ipairs(messages) do
		if i == 1 then Envoyer(m) else C_Timer.After((i - 1) * ENTRE_MESSAGES, function() Envoyer(m) end) end
	end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui or qui == MaCle() then return end
	local genre, suite = msg:match("^(%u)~(.*)$")
	if genre == "Q" then
		local depuis = tonumber(suite, 36)
		if not depuis or not pret or not (ns.EstLeRelais and ns.EstLeRelais(qui)) then return end
		C_Timer.After(3 + math.random() * 4, function() Relayer(depuis) end)
	elseif genre == "R" then
		for mot in suite:gmatch("[^;]+") do
			local tranche, enLigne, addon = mot:match("^(%w+):(%d+),(%d+)$")
			if tranche then Noter(tonumber(tranche, 36), enLigne, addon) end
		end
	end
end

--------------------------------------------------------------------------------
-- Calculs pour la page
--------------------------------------------------------------------------------

-- parcourt les relevés : f(heureServeur, enLigne, addon)
local function Parcourir(f)
	local s = Stats()
	if not s then return end
	for cle, v in pairs(s.r) do
		local t = tonumber(cle, 36)
		local e, a = v:match("^(%d+),(%d+)$")
		if t and e then f(t * TRANCHE, tonumber(e), tonumber(a)) end
	end
end

-- jour de la semaine (1 = lundi) et heure locale d'un instant
local function JourHeure(t)
	local d = date("*t", t)
	return (d.wday + 5) % 7 + 1, d.hour, d
end

-- grille[jour][heure] = moyenne des membres en ligne ; maxi = la plus haute moyenne ; nbJours couverts
local function SemaineType()
	local somme, nombre = {}, {}
	for j = 1, 7 do somme[j], nombre[j] = {}, {} for h = 0, 23 do somme[j][h], nombre[j][h] = 0, 0 end end
	local jours = {}
	Parcourir(function(t, e)
		local j, h, d = JourHeure(t)
		somme[j][h] = somme[j][h] + e
		nombre[j][h] = nombre[j][h] + 1
		jours[d.yday .. "-" .. d.year] = true
	end)
	local grille, maxi = {}, 0
	for j = 1, 7 do
		grille[j] = {}
		for h = 0, 23 do
			local m = nombre[j][h] > 0 and somme[j][h] / nombre[j][h] or nil
			grille[j][h] = m
			if m and m > maxi then maxi = m end
		end
	end
	local n = 0
	for _ in pairs(jours) do n = n + 1 end
	return grille, maxi, n
end

-- les cinq meilleurs créneaux de la semaine type
local function MeilleursCreneaux(grille)
	local liste = {}
	for j = 1, 7 do
		for h = 0, 23 do
			if grille[j][h] and grille[j][h] >= 1 then liste[#liste + 1] = { j = j, h = h, m = grille[j][h] } end
		end
	end
	table.sort(liste, function(a, b) if a.m ~= b.m then return a.m > b.m end if a.j ~= b.j then return a.j < b.j end return a.h < b.h end)
	return liste
end

-- par jour (les N derniers) : pic de membres en ligne
local function ParJour(nbJours)
	local pics = {}
	local aujourdhui = date("*t", Maintenant())
	local debutJour = time({ year = aujourdhui.year, month = aujourdhui.month, day = aujourdhui.day, hour = 0 })
	Parcourir(function(t, e)
		local i = t >= debutJour and 1 or math.ceil((debutJour - t) / 86400) + 1 -- 1 = aujourd'hui
		if i >= 1 and i <= nbJours then pics[i] = math.max(pics[i] or 0, e) end
	end)
	local liste, maxi = {}, 0
	for i = nbJours, 1, -1 do
		local t = debutJour - (i - 1) * 86400
		local v = pics[i] or 0
		liste[#liste + 1] = { t = t, v = v, releve = pics[i] ~= nil }
		if v > maxi then maxi = v end
	end
	return liste, maxi
end

-- aujourd'hui, par heure : pic de membres en ligne
local function Aujourdhui()
	local heures, maxi = {}, 0
	local a = date("*t", Maintenant())
	Parcourir(function(t, e)
		local d = date("*t", t)
		if d.year == a.year and d.yday == a.yday then
			heures[d.hour] = math.max(heures[d.hour] or 0, e)
			if e > maxi then maxi = e end
		end
	end)
	return heures, maxi, a.hour
end

--------------------------------------------------------------------------------
-- Page « Statistiques »
--------------------------------------------------------------------------------

local MARGE, ECART = 16, 12

-- bloc de barres verticales dans un cadre : b:Poser(valeurs, maxi, etiquettes, actuel)
local function Barres(parent, nombre, largeur, hauteur)
	local f = CreateFrame("Frame", nil, parent)
	f:SetSize(largeur, hauteur)
	f.barres, f.etiquettes = {}, {}
	local C = ns.UI.C
	local pas = largeur / nombre
	for i = 1, nombre do
		local b = f:CreateTexture(nil, "ARTWORK")
		b:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 0.9)
		b:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", (i - 1) * pas + 1, 14)
		b:SetWidth(math.max(1, pas - 2))
		b:SetHeight(1)
		b:Hide()
		f.barres[i] = b
		local e = ns.UI.Texte(f, "GameFontHighlightSmall", C.gris)
		e:SetPoint("BOTTOM", f, "BOTTOMLEFT", (i - 0.5) * pas, 0)
		e:SetText("")
		f.etiquettes[i] = e
	end
	local sol = f:CreateTexture(nil, "ARTWORK")
	sol:SetColorTexture(C.bord[1], C.bord[2], C.bord[3], 1)
	sol:SetHeight(1)
	sol:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 13)
	sol:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 13)
	f.Poser = function(self, valeurs, maxi, etiquettes, actuel)
		local utile = hauteur - 16
		for i, b in ipairs(self.barres) do
			local v = valeurs[i]
			if v and v > 0 and maxi > 0 then
				b:SetHeight(math.max(2, utile * v / maxi))
				if actuel == i then b:SetColorTexture(C.ors[1], C.ors[2], C.ors[3], 1)
				else b:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 0.9) end
				b:Show()
			else
				b:Hide()
			end
			self.etiquettes[i]:SetText(etiquettes[i] or "")
		end
	end
	return f
end

local function CreerPage(parent)
	local UI = ns.UI
	local C = UI.C
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.rafraichirAuto = false -- (les relevés changent toutes les 10 min : rafraîchie sur ns.MajInterface)
	local largeur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) - 2 * MARGE
	local hauteur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[2] or 586)

	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -16)
	titre:SetText("Statistiques de présence")
	p.sous = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.sous:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -4)

	-- semaine type : grille 7 x 24
	local largeurGrille = largeur - ECART - 230
	local semaine = UI.Carte(p, "Semaine type")
	semaine:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -60)
	semaine:SetSize(largeurGrille, 262)
	semaine.vide:SetText("Pas encore de relevés : l'addon note la présence toutes les 10 minutes à partir de maintenant.")
	local ETQ = 34        -- colonne des jours
	local caseL = (largeurGrille - 28 - ETQ) / 24
	local caseH = 24
	semaine.cases = {}
	for j = 1, 7 do
		local e = UI.Texte(semaine, "GameFontHighlightSmall", C.gris)
		e:SetPoint("TOPLEFT", semaine, "TOPLEFT", 14, -54 - (j - 1) * (caseH + 2) - 6)
		e:SetText(JOURS[j])
		semaine.cases[j] = {}
		for h = 0, 23 do
			local c = CreateFrame("Frame", nil, semaine)
			c:EnableMouse(true) -- (sans quoi un simple cadre ne reçoit pas le survol : pas d'infobulle)
			c:SetSize(caseL - 2, caseH)
			c:SetPoint("TOPLEFT", semaine, "TOPLEFT", 14 + ETQ + h * caseL, -54 - (j - 1) * (caseH + 2))
			c.fond = c:CreateTexture(nil, "ARTWORK")
			c.fond:SetAllPoints()
			c.j, c.h = j, h
			c:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetText(("%s %02dh-%02dh"):format(JOURS[self.j], self.h, (self.h + 1) % 24))
				GameTooltip:AddLine(self.m and ("%.1f membre%s en ligne en moyenne"):format(self.m, self.m >= 2 and "s" or "")
					or "pas de relevé", 1, 1, 1)
				GameTooltip:Show()
			end)
			c:SetScript("OnLeave", function() GameTooltip:Hide() end)
			semaine.cases[j][h] = c
		end
	end
	for h = 0, 23, 3 do
		local e = UI.Texte(semaine, "GameFontHighlightSmall", C.gris)
		e:SetPoint("TOPLEFT", semaine, "TOPLEFT", 14 + ETQ + h * caseL, -40)
		e:SetText(("%02dh"):format(h))
	end

	-- meilleurs créneaux
	local creneaux = UI.Carte(p, "Meilleurs créneaux")
	creneaux:SetPoint("TOPLEFT", semaine, "TOPRIGHT", ECART, 0)
	creneaux:SetSize(230, 262)
	creneaux.vide:SetText("Il faut quelques jours de relevés.")
	creneaux.lignes = {}
	for i = 1, 5 do
		local l = UI.Texte(creneaux, "GameFontHighlight", i == 1 and C.ors or C.texte)
		l:SetPoint("TOPLEFT", creneaux, "TOPLEFT", 14, -42 - (i - 1) * 40)
		l:SetPoint("RIGHT", creneaux, "RIGHT", -14, 0)
		l:SetJustifyH("LEFT")
		local s = UI.Texte(creneaux, "GameFontHighlightSmall", C.gris)
		s:SetPoint("TOPLEFT", l, "BOTTOMLEFT", 0, -2)
		l.sous = s
		creneaux.lignes[i] = l
	end

	-- par jour et aujourd'hui
	local hautBas = hauteur - 60 - 262 - ECART - MARGE
	local NB_JOURS = 28
	local jours = UI.Carte(p, "Membres en ligne par jour (pic)")
	jours:SetPoint("TOPLEFT", semaine, "BOTTOMLEFT", 0, -ECART)
	jours:SetSize(largeurGrille, hautBas)
	jours.vide:Hide()
	jours.barres = Barres(jours, NB_JOURS, largeurGrille - 28, hautBas - 48)
	jours.barres:SetPoint("TOPLEFT", jours, "TOPLEFT", 14, -40)

	local jour = UI.Carte(p, "Aujourd'hui")
	jour:SetPoint("TOPLEFT", jours, "TOPRIGHT", ECART, 0)
	jour:SetSize(230, hautBas)
	jour.vide:Hide()
	jour.barres = Barres(jour, 24, 230 - 28, hautBas - 48)
	jour.barres:SetPoint("TOPLEFT", jour, "TOPLEFT", 14, -40)

	p.Maj = function()
		local s = Stats()
		if not s then
			p.sous:SetText("Tu n'es pas dans une guilde.")
			return
		end
		-- (calculs sur tous les relevés, jusqu'à 8 000 : refaits seulement si les relevés ont changé,
		-- ou à l'heure suivante pour les barres d'aujourd'hui et des jours)
		local etat = ("%d:%s:%s"):format(version, tostring(GetGuildInfo and GetGuildInfo("player")), date("%Y%m%d%H"))
		if etat == p.etat then return end
		p.etat = etat
		local grille, maxi, nbJours = SemaineType()
		local nbReleves = 0
		for _ in pairs(s.r) do nbReleves = nbReleves + 1 end
		p.sous:SetText(nbReleves > 0
			and ("%d relevé%s sur %d jour%s · membres en ligne d'après la liste de guilde, un relevé toutes les 10 min")
				:format(nbReleves, nbReleves > 1 and "s" or "", nbJours, nbJours > 1 and "s" or "")
			or "Aucun relevé pour l'instant.")
		semaine.vide:SetShown(nbReleves == 0)
		for j = 1, 7 do
			for h = 0, 23 do
				local c = semaine.cases[j][h]
				local m = grille[j][h]
				c.m = m
				if m and maxi > 0 then
					local k = 0.15 + 0.85 * (m / maxi)
					c.fond:SetColorTexture(C.ors[1] * k, C.ors[2] * k, C.ors[3] * k, 0.25 + 0.75 * (m / maxi))
				else
					c.fond:SetColorTexture(1, 1, 1, 0.04)
				end
			end
		end
		local meilleurs = MeilleursCreneaux(grille)
		creneaux.vide:SetShown(#meilleurs == 0)
		for i, l in ipairs(creneaux.lignes) do
			local m = meilleurs[i]
			if m then
				l:SetText(("%d. %s %02dh"):format(i, ({ "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche" })[m.j], m.h))
				l.sous:SetText(("%.1f membre%s en ligne en moyenne"):format(m.m, m.m >= 2 and "s" or ""))
			end
			l:SetShown(m ~= nil)
			l.sous:SetShown(m ~= nil)
		end
		local liste, maxJ = ParJour(NB_JOURS)
		local valeurs, etiquettes = {}, {}
		for i, x in ipairs(liste) do
			valeurs[i] = x.v
			local d = date("*t", x.t)
			etiquettes[i] = (i == #liste or d.wday == 2) and tostring(d.day) or ""
		end
		jours.barres:Poser(valeurs, maxJ, etiquettes, #liste)
		jours.compte:SetText(("%d derniers jours"):format(NB_JOURS))
		local heures, maxH, heureActuelle = Aujourdhui()
		valeurs, etiquettes = {}, {}
		for h = 0, 23 do
			valeurs[h + 1] = heures[h]
			etiquettes[h + 1] = (h % 6 == 0) and ("%02dh"):format(h) or ""
		end
		jour.barres:Poser(valeurs, maxH, etiquettes, heureActuelle + 1)
		jour.compte:SetText(maxH > 0 and ("pic : %d"):format(maxH) or "")
	end
	return p
end

if ns.AjouterPage then ns.AjouterPage("stats", CreerPage) end

--------------------------------------------------------------------------------
-- Connexion : premier relevé, demande au relais, puis un relevé toutes les 10 minutes
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
local premiere = true
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function(_, event)
	if not premiere then return end
	premiere = false
	C_Timer.After(PREMIER_RELEVE, function()
		local s = Stats()
		if s then
			Purger()
			-- la tranche la plus récente que j'ai : je demande la suite
			local dernier = 0
			for cle in pairs(s.r) do
				local t = tonumber(cle, 36)
				if t and t > dernier then dernier = t end
			end
			local maintenant = math.floor(Maintenant() / TRANCHE)
			Envoyer("Q~" .. Base36(math.max(dernier, maintenant - MAX_RELAIS)))
		end
		pret = true
		Relever()
		-- un relevé au début de chaque tranche de 10 min (heure du serveur), puis toutes les 10 min
		local attente = TRANCHE - (Maintenant() % TRANCHE) + 5
		C_Timer.After(attente, function()
			Relever()
			if C_Timer.NewTicker then C_Timer.NewTicker(TRANCHE, Relever) end
		end)
	end)
end)

ns.Ecouter(PREFIXE, Recevoir)
