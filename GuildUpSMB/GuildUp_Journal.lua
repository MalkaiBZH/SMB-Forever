-- GuildUpSMB : fil d'activité de la guilde et podium (page « Activité », /smb activite ; préfixe "GuildUpJrn").
-- Le journal garde ce qui se passe dans la guilde, pour le retrouver après une absence :
--   N  montée de niveau (valeur = niveau)          M  nouveau métier (valeur = nom)
--   P  palier de métier (valeur = « 150 Forge »)   D  don remercié (membre = le donneur,
--   T  tirage au sort gagné (valeur = « i<objet> » ou le lot)   valeur = « objet:clé de celui qui remercie »)
-- Chaque addon note ce qu'il voit passer (les autres modules appellent ns.NoterActivite ou
-- ns.ActiviteAnnonce) dans GuildUpDB.journal[guilde] = { e = { { t, g, q, v }, … }, present, vu } :
-- 300 entrées au plus, oubliées après 30 jours ; « present » = dernière fois où un de mes personnages
-- était en jeu, « vu » = dernière visite de la page. Commun aux personnages du compte.
-- Rattrapage à la connexion :
--   "Q~depuis"                 je reviens : envoyez-moi ce qui s'est passé depuis cette date (base 36)
--   "E~t,g,membre,valeur;…"    entrées du journal (240 octets au plus par message), envoyées par le
--                              seul relais (ns.EstLeRelais), 60 entrées au plus ; tout le monde les lit
-- Un membre n'apprend donc que ce qu'un autre membre en ligne a vu : rien n'existe avant l'installation
-- de cette version, et une heure où personne n'était connecté reste vide.
-- Une minute après la connexion, une bulle « Pendant ton absence » résume les nouveautés (sauf
-- /smb annonces coupé) ; la pastille du menu les compte jusqu'à l'ouverture de la page.
-- Podium des 7 derniers jours, calculé sur le journal : progression (niveaux gagnés), générosité (dons
-- remerciés, un par membre remerciant et par jour), chance (tirages gagnés).
-- Mes propres nouvelles notées en direct partent aussi à la carte des souvenirs (ns.MonSouvenir,
-- GuildUp_Souvenirs.lua), qui ne garde que les grands moments.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpJrn"
local OUBLI = 30 * 86400        -- durée de vie d'une entrée
local MAX_ENTREES = 300
local MAX_RELAIS = 60           -- entrées renvoyées à un membre qui revient
local RATTRAPAGE = 14 * 86400   -- on ne redemande jamais plus loin
local PODIUM = 7 * 86400
local AFFICHEES = 120           -- lignes du fil au plus
local GENRES = { N = true, M = true, P = true, D = true, T = true }

local Normaliser = ns.Normaliser
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local MaCle = ns.MaCle
local Maintenant = ns.Maintenant
local Base36 = ns.Base36

local pret = false          -- vrai une fois ma propre demande partie (je peux alors servir de relais)
local majPrevue = false

--------------------------------------------------------------------------------
-- Journal
--------------------------------------------------------------------------------

-- le journal de ma guilde (nil hors guilde ou avant le chargement des réglages)
local function Journal()
	local db = ns.DB and ns.DB()
	local guilde = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not db or not guilde then return nil end
	if type(db.journal) ~= "table" then db.journal = {} end
	local j = db.journal[guilde]
	if type(j) ~= "table" then j = {}; db.journal[guilde] = j end
	if type(j.e) ~= "table" then j.e = {} end
	return j
end

local function Nettoyer(v)
	v = tostring(v or ""):gsub("[~|,;\r\n]", " "):gsub("%s+", " ")
	v = strtrim(v)
	return ns.CouperUTF8 and ns.CouperUTF8(v, nil, 60) or v:sub(1, 60)
end

-- la même nouvelle, déjà notée ? (reçue en direct puis par le relais, ou annoncée deux fois)
local function Doublon(e, t, g, q, v)
	if e.g ~= g or e.q ~= q or e.v ~= v then return false end
	if g == "D" then return math.abs(e.t - t) < 86400 end
	if g == "T" then return math.abs(e.t - t) < 600 end
	return true -- un niveau, un métier ou un palier ne s'atteint qu'une fois
end

local function Rafraichir()
	if majPrevue then return end
	majPrevue = true
	C_Timer.After(0.5, function()
		majPrevue = false
		if ns.MajInterface then ns.MajInterface() end
	end)
end

-- ajoute une entrée (dans l'ordre des dates) ; true si elle est nouvelle
local function Ajouter(t, g, q, v)
	local j = Journal()
	local maintenant = Maintenant()
	if not j or not GENRES[g] or type(q) ~= "string" or q == "" or q:find("[~,;|]") then return false end
	t = tonumber(t)
	if not t or t > maintenant + 120 or t < maintenant - OUBLI then return false end
	t, v = math.floor(t), Nettoyer(v)
	local e = j.e
	-- purge des entrées trop vieilles ou abîmées
	for i = #e, 1, -1 do
		if type(e[i]) ~= "table" or type(e[i].t) ~= "number" or e[i].t < maintenant - OUBLI then table.remove(e, i) end
	end
	for _, x in ipairs(e) do
		if Doublon(x, t, g, q, v) then return false end
	end
	local place = #e + 1
	while place > 1 and e[place - 1].t > t do place = place - 1 end
	table.insert(e, place, { t = t, g = g, q = q, v = v })
	while #e > MAX_ENTREES do table.remove(e, 1) end
	Rafraichir()
	return true
end

-- Une de mes nouvelles entre dans le fil : la carte des souvenirs la garde si elle le mérite
-- (GuildUp_Souvenirs.lua : niveaux ronds, métiers, paliers, tirages gagnés, à ma position)
local function Souvenir(genre, cle, valeur)
	if cle == MaCle() and ns.MonSouvenir then ns.MonSouvenir(genre, valeur) end
end

-- Pour les autres modules : ns.NoterActivite("T", clé du gagnant, lot)
ns.NoterActivite = function(genre, cle, valeur)
	cle = cle and (cle:gsub("#test$", ""))
	local nouveau = Ajouter(Maintenant(), genre, cle, valeur)
	if nouveau then Souvenir(genre, cle, valeur) end
	return nouveau
end

-- Une annonce de GuildUp_Annonces.lua ("N~niveau", "M~métier", "P~métier~palier"), la mienne comprise
ns.ActiviteAnnonce = function(msg, expediteur)
	local qui = expediteur and Normaliser(expediteur)
	if not qui or type(msg) ~= "string" then return end
	local genre, a, b = strsplit("~", msg)
	local valeur
	if genre == "N" and tonumber(a) then
		valeur = tostring(tonumber(a))
	elseif genre == "M" and a and a ~= "" then
		valeur = a
	elseif genre == "P" and a and tonumber(b) then
		valeur = tonumber(b) .. " " .. a
	end
	if valeur and Ajouter(Maintenant(), genre, qui, valeur) then Souvenir(genre, qui, valeur) end
end

-- nouveautés depuis ma dernière visite de la page (les miennes ne comptent pas)
local function Nouveautes(seuil)
	local j = Journal()
	if not j then return {} end
	seuil = seuil or j.vu or 0
	local moi, liste = MaCle(), {}
	for _, e in ipairs(j.e) do
		if e.t > seuil and e.q ~= moi then liste[#liste + 1] = e end
	end
	return liste
end
ns.NouveautesActivite = function() return #Nouveautes() end

--------------------------------------------------------------------------------
-- Podium
--------------------------------------------------------------------------------

-- trois listes { { cle, n }, … } de la plus haute à la plus basse : niveaux, dons, tirages
local function Podium()
	local j = Journal()
	local niveaux, dons, tirages, vus = {}, {}, {}, {}
	local limite = Maintenant() - PODIUM
	for _, e in ipairs(j and j.e or {}) do
		if e.t >= limite then
			if e.g == "N" then
				niveaux[e.q] = (niveaux[e.q] or 0) + 1
			elseif e.g == "T" then
				tirages[e.q] = (tirages[e.q] or 0) + 1
			elseif e.g == "D" then
				-- un même membre ne compte qu'une fois par jour pour un donneur
				local k = e.q .. "|" .. (e.v:match(":(.+)$") or "?") .. "|" .. date("%j", e.t)
				if not vus[k] then
					vus[k] = true
					dons[e.q] = (dons[e.q] or 0) + 1
				end
			end
		end
	end
	local function Trier(compte)
		local liste = {}
		for cle, n in pairs(compte) do liste[#liste + 1] = { cle = cle, n = n } end
		table.sort(liste, function(a, b) if a.n ~= b.n then return a.n > b.n end return a.cle < b.cle end)
		return liste
	end
	return Trier(niveaux), Trier(dons), Trier(tirages)
end

--------------------------------------------------------------------------------
-- Réseau : rattrapage à la connexion
--------------------------------------------------------------------------------

local function Envoyer(msg)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end
end

-- les entrées plus récentes que « depuis » (les 60 dernières au plus), en messages de 240 octets
local function Relayer(depuis)
	local j = Journal()
	if not j then return end
	local e, premier = j.e, #j.e + 1
	while premier > 1 and e[premier - 1].t > depuis and #e - premier + 1 < MAX_RELAIS do premier = premier - 1 end
	local msg = "E~"
	for i = premier, #e do
		local x = e[i]
		local mot = ("%s,%s,%s,%s"):format(Base36(x.t), x.g, x.q, x.v)
		if #msg + #mot + 1 > 240 and #msg > 2 then Envoyer(msg); msg = "E~" end
		msg = msg .. (#msg > 2 and ";" or "") .. mot
	end
	if #msg > 2 then Envoyer(msg) end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui or qui == MaCle() then return end
	local genre, suite = msg:match("^(%u)~(.*)$")
	if genre == "Q" then
		local depuis = tonumber(suite, 36)
		if not depuis or not pret or not (ns.EstLeRelais and ns.EstLeRelais(qui)) then return end
		depuis = math.max(depuis, Maintenant() - RATTRAPAGE)
		C_Timer.After(2 + math.random() * 3, function() Relayer(depuis) end)
	elseif genre == "E" then
		for mot in suite:gmatch("[^;]+") do
			local t, g, q, v = mot:match("^(%w+),(%u),([^,]+),(.*)$")
			if t then Ajouter(tonumber(t, 36), g, q, v) end
		end
	end
end

--------------------------------------------------------------------------------
-- Textes
--------------------------------------------------------------------------------

local OR = "|cffffd100"

local function NomObjet(objet)
	local nom, lien = ns.InfoObjet(objet)
	if not nom and ns.Precharger then ns.Precharger(objet) end
	return lien or nom or ("l'objet n° " .. objet)
end

-- phrase d'une entrée { g, q, v } (aussi pour l'infobulle des souvenirs : ns.PhraseActivite)
local function Phrase(e)
	local qui = NomJoueur(e.q)
	if e.g == "N" then
		return ("%s a atteint le niveau %s%s|r"):format(qui, OR, e.v)
	elseif e.g == "M" then
		return ("%s a appris %s%s|r"):format(qui, OR, e.v)
	elseif e.g == "P" then
		local palier, metier = e.v:match("^(%d+) (.+)$")
		return ("%s est passé à %s%s|r en %s"):format(qui, OR, palier or "?", metier or e.v)
	elseif e.g == "D" then
		local objet, de = e.v:match("^(%d+):(.+)$")
		return ("%s a donné %s à %s"):format(qui, objet and NomObjet(tonumber(objet)) or "un objet",
			de and NomJoueur((de:gsub("#test$", ""))) or "un membre")
	elseif e.g == "T" then
		local objet = e.v:match("^i(%d+)$")
		local lot = objet and NomObjet(tonumber(objet)) or (e.v ~= "" and (OR .. e.v .. "|r") or "un lot")
		return ("%s a remporté le tirage : %s"):format(qui, lot)
	end
	return qui
end
ns.PhraseActivite = Phrase

-- « 3 montées de niveau, 1 don, 1 tirage gagné »
local function Resume(liste)
	local n = { N = 0, M = 0, P = 0, D = 0, T = 0 }
	for _, e in ipairs(liste) do n[e.g] = (n[e.g] or 0) + 1 end
	local mots = {}
	local function Mot(nombre, un, plusieurs)
		if nombre > 0 then mots[#mots + 1] = nombre .. " " .. (nombre > 1 and plusieurs or un) end
	end
	Mot(n.N, "montée de niveau", "montées de niveau")
	Mot(n.M + n.P, "progrès de métier", "progrès de métier")
	Mot(n.D, "don", "dons")
	Mot(n.T, "tirage gagné", "tirages gagnés")
	return table.concat(mots, ", ")
end

--------------------------------------------------------------------------------
-- Page « Activité »
--------------------------------------------------------------------------------

local MARGE, ECART, HAUT_LIGNE = 16, 12, 36

local function CreerPage(parent)
	local UI = ns.UI
	local C = UI.C
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	local largeur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) - 2 * MARGE
	local hauteur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[2] or 586)
	local largeurPodium = 272
	local largeurFil = largeur - ECART - largeurPodium

	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -16)
	titre:SetText("Activité de la guilde")
	p.sous = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.sous:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -4)

	-- le fil, du plus récent au plus ancien
	local fil = UI.Carte(p, "Fil d'activité")
	fil:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -60)
	fil:SetSize(largeurFil, hauteur - 60 - MARGE)
	fil.vide:SetText("Rien pour l'instant. Le fil se remplit avec les montées de niveau, les métiers, les dons remerciés et les tirages au sort, à partir de maintenant.")
	fil.liste = UI.Liste(fil)
	fil.liste:SetPoint("TOPLEFT", fil, "TOPLEFT", 12, -38)
	fil.liste:SetPoint("BOTTOMRIGHT", fil, "BOTTOMRIGHT", -8, 10)
	fil.lignes = {}
	local function Ligne(i)
		local l = fil.lignes[i]
		if l then return l end
		l = CreateFrame("Frame", nil, fil.liste.contenu)
		l:SetHeight(HAUT_LIGNE)
		l:SetPoint("TOPLEFT", fil.liste.contenu, "TOPLEFT", 0, -(i - 1) * HAUT_LIGNE)
		l:SetPoint("RIGHT", fil.liste.contenu, "RIGHT", 0, 0)
		-- point doré : nouveau depuis ma dernière visite
		l.point = l:CreateTexture(nil, "ARTWORK")
		l.point:SetTexture(UI.ROND)
		l.point:SetVertexColor(C.ors[1], C.ors[2], C.ors[3], 1)
		l.point:SetSize(6, 6)
		l.point:SetPoint("LEFT", l, "LEFT", 0, 0)
		l.portrait = UI.Portrait(l, 28)
		l.portrait:SetPoint("LEFT", l, "LEFT", 12, 0)
		l.quand = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.quand:SetPoint("RIGHT", l, "RIGHT", -4, 0)
		l.quand:SetJustifyH("RIGHT")
		l.texte = UI.Texte(l, "GameFontHighlight", C.texte)
		l.texte:SetPoint("LEFT", l.portrait, "RIGHT", 8, 0)
		l.texte:SetPoint("RIGHT", l.quand, "LEFT", -8, 0)
		fil.lignes[i] = l
		return l
	end

	-- le podium : trois classements de trois places
	local podium = UI.Carte(p, "Podium")
	podium:SetPoint("TOPLEFT", fil, "TOPRIGHT", ECART, 0)
	podium:SetSize(largeurPodium, hauteur - 60 - MARGE)
	podium.compte:SetText("7 derniers jours")
	podium.vide:Hide()
	local BLOCS = {
		{ "Progression", "niveau gagné", "niveaux gagnés", "Personne n'a monté de niveau." },
		{ "Générosité", "don remercié", "dons remerciés", "Aucun don remercié." },
		{ "Chance", "tirage gagné", "tirages gagnés", "Aucun tirage au sort gagné." },
	}
	podium.blocs = {}
	for i, b in ipairs(BLOCS) do
		local bloc = { lignes = {} }
		local y = -44 - (i - 1) * 150
		bloc.titre = UI.Texte(podium, "GameFontNormal", C.ors)
		bloc.titre:SetPoint("TOPLEFT", podium, "TOPLEFT", 14, y)
		bloc.titre:SetText(b[1])
		local filet = UI.Filet(podium)
		filet:SetPoint("TOPLEFT", bloc.titre, "BOTTOMLEFT", 0, -6)
		filet:SetPoint("RIGHT", podium, "RIGHT", -14, 0)
		for rang = 1, 3 do
			local l = CreateFrame("Frame", nil, podium)
			l:SetHeight(30)
			l:SetPoint("TOPLEFT", podium, "TOPLEFT", 14, y - 26 - (rang - 1) * 32)
			l:SetPoint("RIGHT", podium, "RIGHT", -14, 0)
			l.rang = UI.Texte(l, "GameFontNormal", rang == 1 and C.ors or C.gris)
			l.rang:SetPoint("LEFT", l, "LEFT", 0, 0)
			l.rang:SetText(rang .. ".")
			l.portrait = UI.Portrait(l, 24)
			l.portrait:SetPoint("LEFT", l, "LEFT", 20, 0)
			l.n = UI.Texte(l, "GameFontHighlightSmall", C.gris)
			l.n:SetPoint("RIGHT", l, "RIGHT", 0, 0)
			l.n:SetJustifyH("RIGHT")
			l.nom = UI.Texte(l, "GameFontHighlight", rang == 1 and C.ors or C.texte)
			l.nom:SetPoint("LEFT", l.portrait, "RIGHT", 8, 0)
			l.nom:SetPoint("RIGHT", l.n, "LEFT", -6, 0)
			bloc.lignes[rang] = l
		end
		bloc.vide = UI.Texte(podium, "GameFontHighlightSmall", C.gris)
		bloc.vide:SetPoint("TOPLEFT", podium, "TOPLEFT", 14, y - 34)
		bloc.vide:SetText(b[4])
		podium.blocs[i] = bloc
	end

	-- quitter la page : les nouveautés de cette visite ne seront plus marquées à la suivante
	p:SetScript("OnHide", function() p.seuil = nil end)

	p.Maj = function()
		local j = Journal()
		if not j then
			p.sous:SetText("Tu n'es pas dans une guilde.")
			for _, l in ipairs(fil.lignes) do l:Hide() end
			fil.vide:Show()
			fil.liste:Hauteur(1)
			return
		end
		-- première mise à jour de cette visite : on retient ce qui était nouveau, puis tout est « vu »
		if not p.seuil then p.seuil = j.vu or Maintenant() end
		j.vu = Maintenant()
		local moi = MaCle()
		local nouvelles = #Nouveautes(p.seuil)
		p.sous:SetText(("Les 30 derniers jours · %s"):format(nouvelles > 0
			and ("%s%d|r nouveauté%s depuis ta dernière visite"):format(OR, nouvelles, nouvelles > 1 and "s" or "")
			or "rien de neuf depuis ta dernière visite"))
		local e = j.e
		local n = 0
		for i = #e, math.max(1, #e - AFFICHEES + 1), -1 do
			n = n + 1
			local x = e[i]
			local l = Ligne(n)
			l.point:SetShown(x.t > p.seuil and x.q ~= moi)
			l.portrait:Poser(x.q)
			l.texte:SetText(Phrase(x))
			l.quand:SetText("il y a " .. ns.Depuis(x.t))
			l:Show()
		end
		for i = n + 1, #fil.lignes do fil.lignes[i]:Hide() end
		fil.vide:SetShown(n == 0)
		fil.compte:SetText(n > 0 and tostring(n) or "")
		fil.liste:Hauteur(math.max(1, n * HAUT_LIGNE))

		local listes = { Podium() }
		for i, bloc in ipairs(podium.blocs) do
			local liste = listes[i]
			for rang, l in ipairs(bloc.lignes) do
				local c = liste[rang]
				if c then
					l.portrait:Poser(c.cle)
					l.nom:SetText(NomJoueur(c.cle))
					l.n:SetText(c.n .. " " .. (c.n > 1 and BLOCS[i][3] or BLOCS[i][2]))
				end
				l:SetShown(c ~= nil)
			end
			bloc.vide:SetShown(#liste == 0)
		end
	end
	return p
end

if ns.AjouterPage then ns.AjouterPage("activite", CreerPage) end

--------------------------------------------------------------------------------
-- Connexion : présence, demande de rattrapage, bulle « Pendant ton absence »
--------------------------------------------------------------------------------

local function NoterPresence()
	local j = Journal()
	if j then j.present = Maintenant() end
end

local function BulleAbsence()
	local db = ns.DB and ns.DB()
	if not db or db.annoncesGuilde == false or not ns.Notifier then return end
	if ns.PageInterface and ns.PageInterface() == "activite" then return end
	local liste = Nouveautes()
	if #liste == 0 then return end
	ns.Notifier(nil, "Pendant ton absence", Resume(liste) .. ". Clic : le fil d'activité.", "aucun",
		function() if ns.OuvrirInterface then ns.OuvrirInterface("activite") end end)
end

local ev = CreateFrame("Frame")
local premiere = true
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_LOGOUT")
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_LOGOUT" then
		if pret then NoterPresence() end
	elseif premiere then
		premiere = false
		-- (la guilde et la liste de ses membres ne sont pas connues tout de suite)
		C_Timer.After(25, function()
			local j = Journal()
			local maintenant = Maintenant()
			if j then
				if not j.vu then j.vu = maintenant end -- première installation : rien n'est « nouveau »
				Envoyer("Q~" .. Base36(math.max(tonumber(j.present) or 0, maintenant - RATTRAPAGE)))
			end
			pret = true
			NoterPresence()
			if C_Timer.NewTicker then C_Timer.NewTicker(120, NoterPresence) end
			C_Timer.After(35, BulleAbsence)
		end)
	end
end)

ns.Ecouter(PREFIXE, Recevoir)
