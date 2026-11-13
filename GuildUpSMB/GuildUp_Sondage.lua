-- GuildUpSMB : sondage de la guilde (/smb sondage, préfixe "GuildUpSdg").
-- Un membre (l'organisateur) pose une question avec 2 à 5 choix et une durée (1 à 10 min) ; les membres
-- connectés qui ont l'addon reçoivent une bulle et votent d'un clic dans une petite fenêtre. On peut
-- changer d'avis jusqu'à la fin : seul le dernier vote compte. Les votes sont publics (le survol d'un
-- choix montre qui l'a choisi). Même mécanique que le tirage au sort (GuildUp_Tirage.lua).
--   "O~id~secondes~question~choix~choix[~choix…]"   ouverture (2 à 5 choix)
--   "V~organisateur~id~n"                           mon vote (n = numéro du choix ; organisateur = sa clé)
--   "F~id~n1~n2[~…]"                                fin : le compte de l'organisateur, choix par choix
--   "A~id"                                          sondage annulé
-- « id » = heure du serveur à l'ouverture, en base 36. Un sondage est repéré par la clé de l'organisateur
-- et son id : seuls les messages de l'organisateur peuvent le finir ou l'annuler. C'est l'organisateur qui
-- tient le chrono et dont le compte fait foi (un membre qui a manqué des votes a quand même le bon
-- résultat) ; sans nouvelles de lui 20 s après la fin, le sondage est marqué interrompu, avec le compte
-- provisoire. Les textes sont coupés pour tenir dans un message (question 96 octets, choix 26 octets).
-- Rien n'est gardé d'une session à l'autre : un membre qui se connecte pendant un sondage ne le voit pas.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpSdg"
local DUREES = { { 60, "1 minute" }, { 120, "2 minutes" }, { 300, "5 minutes" }, { 600, "10 minutes" } }
local DUREE = 300           -- durée proposée
local CHOIX_MAX = 5
local OCTETS_QUESTION = 96
local OCTETS_CHOIX = 26
local GRACE = 3             -- l'organisateur attend les derniers votes en route
local SANS_NOUVELLES = 20   -- secondes après la fin sans message de l'organisateur
local ENTRE_DEUX = 30       -- secondes entre deux sondages du même organisateur
local ENTRE_VOTES = 1       -- secondes entre deux votes (changements d'avis en rafale)
local GARDE = 30 * 60       -- un sondage terminé reste consultable 30 min

local Normaliser = ns.Normaliser
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local Erreur = ns.Erreur
local MaCle = ns.MaCle
local Base36 = ns.Base36

local sondages = {}   -- [organisateur .. "~" .. id] = sondage
local vue             -- sondage montré dans la fenêtre
local dernierOuvert, dernierVote = -math.huge, -math.huge
local fenetre
local MajFenetre = function() end

--------------------------------------------------------------------------------
-- Textes et compte des votes
--------------------------------------------------------------------------------

-- texte saisi, prêt à partir : sans séparateurs ni sauts de ligne, coupé à « octets »
local function Nettoyer(texte, octets)
	texte = tostring(texte or ""):gsub("[~|\r\n]", " "):gsub("%s+", " ")
	texte = strtrim(texte)
	if ns.CouperUTF8 then texte = ns.CouperUTF8(texte, octets) else texte = texte:sub(1, octets) end
	return strtrim(texte)
end

-- nombre de votes par choix : celui de l'organisateur une fois le sondage fini, sinon le mien
local function Compte(s)
	if s.totaux then return s.totaux end
	local n = {}
	for i = 1, #s.choix do n[i] = 0 end
	for _, v in pairs(s.votes) do n[v.n] = (n[v.n] or 0) + 1 end
	return n
end

local function Total(compte)
	local t = 0
	for _, n in ipairs(compte) do t = t + n end
	return t
end

-- les choix en tête (liste de numéros), vide sans aucun vote
local function EnTete(compte)
	local max, tete = 0, {}
	for i, n in ipairs(compte) do
		if n > max then max, tete = n, { i } elseif n == max and n > 0 then tete[#tete + 1] = i end
	end
	return tete, max
end

-- « Mardi (4 votes) » ou « égalité entre Mardi et Jeudi (2 votes) »
local function TexteResultat(s)
	local tete, max = EnTete(Compte(s))
	if #tete == 0 then return "aucun vote" end
	local votes = ("%d vote%s"):format(max, max > 1 and "s" or "")
	if #tete == 1 then return ("|cffffd100%s|r (%s)"):format(s.choix[tete[1]], votes) end
	local noms = {}
	for _, i in ipairs(tete) do noms[#noms + 1] = "|cffffd100" .. s.choix[i] .. "|r" end
	return ("égalité entre %s et %s (%s chacun)"):format(table.concat(noms, ", ", 1, #noms - 1), noms[#noms], votes)
end

local function Duree(secondes)
	if secondes >= 60 then return ("%d min %02d s"):format(math.floor(secondes / 60), secondes % 60) end
	return ("%d s"):format(secondes)
end

--------------------------------------------------------------------------------
-- Changements d'état (appliqués chez moi, puis reçus de la même façon chez les autres)
--------------------------------------------------------------------------------

local function Oublier()
	local maintenant = GetTime()
	for cle, s in pairs(sondages) do
		if s.etat ~= "ouvert" and maintenant - (s.clos or maintenant) > GARDE then
			sondages[cle] = nil
			if vue == s then vue = nil end
		end
	end
end

local function Creer(chef, nomChef, id, duree, question, choix)
	local cle = chef .. "~" .. id
	if sondages[cle] then return nil end
	Oublier()
	local s = { cle = cle, chef = chef, nomChef = nomChef, id = id, question = question, choix = choix,
		fin = GetTime() + duree, votes = {}, etat = "ouvert" }
	sondages[cle] = s
	return s
end

local function NoterVote(s, cle, nom, n)
	if s.etat ~= "ouvert" or not s.choix[n] then return false end
	local v = s.votes[cle]
	if v and v.n == n then return false end
	s.votes[cle] = { n = n, nom = nom }
	return true
end

local function Clore(s, etat, totaux)
	if s.etat ~= "ouvert" then return false end
	s.etat, s.totaux, s.clos = etat, totaux, GetTime()
	return true
end

-- un message de l'organisateur arrive après le délai : le sondage n'était pas interrompu
local function Reprendre(s)
	if s.etat == "interrompu" then s.etat, s.clos = "ouvert", nil end
end

local function Envoyer(msg)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end
end

local function Montrer(s)
	vue = s
	if ns.MontrerSondage then ns.MontrerSondage() end
end

local function BulleResultat(s)
	if not ns.Notifier then return end
	ns.Notifier("sondages", "Résultat du sondage", ("« %s » : %s"):format(s.question, TexteResultat(s)), nil,
		function() Montrer(s) end)
end

--------------------------------------------------------------------------------
-- Organisateur : ouverture, clôture, annulation
--------------------------------------------------------------------------------

local function Cloturer(s)
	if s.chef ~= MaCle() then return end
	local compte = Compte(s)
	if not Clore(s, "fini", compte) then return end
	Envoyer(("F~%s~%s"):format(s.id, table.concat(compte, "~")))
	MajFenetre()
	BulleResultat(s)
end

local function Annuler(s)
	if s.chef ~= MaCle() or not Clore(s, "annule") then return end
	Envoyer("A~" .. s.id)
	MajFenetre()
end

local function MonSondageOuvert()
	local moi = MaCle()
	for _, s in pairs(sondages) do
		if s.chef == moi and s.etat == "ouvert" then return s end
	end
end

local function PeutOuvrir()
	if not IsInGuild() then Erreur("Tu n'es pas dans une guilde"); return false end
	if MonSondageOuvert() then Erreur("Tu as déjà un sondage en cours"); return false end
	local reste = ENTRE_DEUX - (GetTime() - dernierOuvert)
	if reste > 0 then Erreur(("Attends encore %d s avant un nouveau sondage"):format(math.ceil(reste))); return false end
	return MaCle() ~= nil
end

-- question et choix tels que saisis ; renvoie true si le sondage est ouvert
local function Ouvrir(question, saisies, duree)
	question = Nettoyer(question, OCTETS_QUESTION)
	local choix = {}
	for _, c in ipairs(saisies) do
		c = Nettoyer(c, OCTETS_CHOIX)
		if c ~= "" and #choix < CHOIX_MAX then choix[#choix + 1] = c end
	end
	if question == "" then Erreur("Écris une question"); return false end
	if #choix < 2 then Erreur("Il faut au moins deux choix"); return false end
	if not PeutOuvrir() then return false end
	local moi = MaCle()
	local s = Creer(moi, moi, Base36(ns.Maintenant()), duree, question, choix)
	if not s then Erreur("Attends une seconde avant un nouveau sondage"); return false end
	dernierOuvert = GetTime()
	Envoyer(("O~%s~%d~%s~%s"):format(s.id, duree, question, table.concat(choix, "~")))
	Montrer(s)
	return true
end

local function Voter(s, n)
	local moi = MaCle()
	if not moi or s.etat ~= "ouvert" or GetTime() > s.fin then return end
	if GetTime() - dernierVote < ENTRE_VOTES then return end
	if not NoterVote(s, moi, moi, n) then return end
	dernierVote = GetTime()
	Envoyer(("V~%s~%s~%d"):format(s.chef, s.id, n))
	MajFenetre()
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui then return end
	local genre, suite = msg:match("^(%u)~(.*)$")
	if not genre then return end
	if genre == "O" then
		local id, duree, reste = suite:match("^(%w+)~(%d+)~(.+)$")
		if not id then return end
		local champs = {}
		for c in (reste .. "~"):gmatch("([^~]*)~") do champs[#champs + 1] = c end
		local question = table.remove(champs, 1)
		local choix = {}
		for _, c in ipairs(champs) do
			if c ~= "" and #choix < CHOIX_MAX then choix[#choix + 1] = c end
		end
		if not question or question == "" or #choix < 2 then return end
		duree = math.max(10, math.min(tonumber(duree) or DUREE, 1800))
		local s = Creer(qui, expediteur, id, duree, question, choix)
		if not s then return end -- (déjà connu : mon propre sondage qui me revient)
		if not (vue and vue.etat == "ouvert") then vue = s end
		MajFenetre()
		if ns.Notifier then
			ns.Notifier("sondages", "Sondage", ("%s demande : |cffffd100%s|r · %s pour voter")
				:format(NomJoueur(expediteur), question, Duree(duree)), "READY_CHECK",
				function() Montrer(s) end)
		end
	elseif genre == "V" then
		if qui == MaCle() then return end -- (mon propre vote, déjà noté)
		local chef, id, n = suite:match("^([^~]+)~(%w+)~(%d+)$")
		local s = chef and sondages[chef .. "~" .. id]
		if not s then return end
		-- l'organisateur ne compte plus les votes arrivés après son délai de grâce
		if s.chef == MaCle() and GetTime() > s.fin + GRACE then return end
		if NoterVote(s, qui, expediteur, tonumber(n)) then MajFenetre() end
	elseif genre == "F" then
		local id, nombres = suite:match("^(%w+)~(.*)$")
		local s = id and sondages[qui .. "~" .. id]
		if not s then return end
		Reprendre(s)
		local totaux = {}
		for i = 1, #s.choix do totaux[i] = 0 end
		local i = 0
		for n in (nombres .. "~"):gmatch("([^~]*)~") do
			i = i + 1
			if totaux[i] then totaux[i] = tonumber(n) or 0 end
		end
		if not Clore(s, "fini", totaux) then return end
		MajFenetre()
		BulleResultat(s)
	elseif genre == "A" then
		local s = sondages[qui .. "~" .. suite]
		if not s then return end
		Reprendre(s)
		if Clore(s, "annule") then MajFenetre() end
	end
end

--------------------------------------------------------------------------------
-- Chrono : clôture par l'organisateur, sondage interrompu chez les autres
--------------------------------------------------------------------------------

local chrono = CreateFrame("Frame")
local ecoule = 0
chrono:SetScript("OnUpdate", function(_, dt)
	ecoule = ecoule + dt
	if ecoule < 0.5 then return end
	ecoule = 0
	local maintenant, moi = GetTime(), MaCle()
	for _, s in pairs(sondages) do
		if s.etat == "ouvert" then
			if s.chef == moi then
				if maintenant > s.fin + GRACE then Cloturer(s) end
			elseif maintenant > s.fin + SANS_NOUVELLES then
				Clore(s, "interrompu")
				MajFenetre()
			end
		end
	end
end)

--------------------------------------------------------------------------------
-- Fenêtre : création d'un sondage, puis vote et résultats
--------------------------------------------------------------------------------

local LARGEUR, HAUTEUR = 360, 360
local HAUT_CHOIX, ECART_CHOIX = 30, 4

local function SondageAMontrer()
	if vue and sondages[vue.cle] == vue then return vue end
	vue = nil
	-- le plus récent encore ouvert, sinon le dernier terminé
	for _, s in pairs(sondages) do
		if not vue or (s.etat == "ouvert" and vue.etat ~= "ouvert")
			or ((s.etat == "ouvert") == (vue.etat == "ouvert") and s.fin > vue.fin) then
			vue = s
		end
	end
	return vue
end

local function Secondes(s) return math.max(0, math.ceil(s.fin - GetTime())) end

-- Formulaire « Nouveau sondage »
local function CreerFormulaire(f)
	local UI = ns.UI
	local C = UI.C
	local z = CreateFrame("Frame", nil, f)
	z:SetAllPoints()
	z.question = UI.Champ(z, LARGEUR - 32, "Question (ex. : quel soir pour le raid ?)")
	z.question:SetPoint("TOPLEFT", z, "TOPLEFT", 16, -44)
	z.question.saisie:SetMaxLetters(80)
	z.choix = {}
	for i = 1, CHOIX_MAX do
		local c = UI.Champ(z, LARGEUR - 32, i <= 2 and ("Choix " .. i) or ("Choix " .. i .. " (facultatif)"))
		c:SetPoint("TOPLEFT", z.question, "BOTTOMLEFT", 0, -8 - (i - 1) * 32)
		c.saisie:SetMaxLetters(24)
		z.choix[i] = c
	end
	-- Tab : champ suivant
	local champs = { z.question }
	for _, c in ipairs(z.choix) do champs[#champs + 1] = c end
	for i, c in ipairs(champs) do
		c.saisie:SetScript("OnTabPressed", function() champs[i % #champs + 1].saisie:SetFocus() end)
	end

	z.libelleDuree = UI.Texte(z, "GameFontHighlight", C.texte)
	z.libelleDuree:SetPoint("TOPLEFT", z.choix[CHOIX_MAX], "BOTTOMLEFT", 0, -16)
	z.libelleDuree:SetText("Durée du vote")
	z.duree = UI.Choix(z, 130, DUREES, function(v) z.valeurDuree = v end)
	z.duree:SetPoint("LEFT", z.libelleDuree, "RIGHT", 12, 0)

	z.ouvrir = UI.Bouton(z, "Ouvrir le sondage", "or", 150, 28)
	z.ouvrir:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 14)
	z.ouvrir:SetScript("OnClick", function()
		local saisies = {}
		for i, c in ipairs(z.choix) do saisies[i] = c.Lire() end
		if Ouvrir(z.question.Lire(), saisies, z.valeurDuree or DUREE) then
			f.creation = false
			MajFenetre()
		end
	end)
	z.annuler = UI.Bouton(z, "Annuler", "fantome", 90, 28)
	z.annuler:SetPoint("RIGHT", z.ouvrir, "LEFT", -8, 0)
	z.annuler:SetScript("OnClick", function()
		f.creation = false
		if SondageAMontrer() then MajFenetre() else f:Hide() end
	end)

	z.Vider = function()
		z.question:Ecrire("")
		for _, c in ipairs(z.choix) do c:Ecrire("") end
		z.valeurDuree = DUREE
		z.duree:Poser(DUREE)
	end
	return z
end

-- Une ligne de vote : barre dorée proportionnelle aux votes, texte du choix, nombre de votes
local function CreerLigne(parent, i, voter)
	local UI = ns.UI
	local C = UI.C
	local b = CreateFrame("Button", nil, parent, "BackdropTemplate")
	UI.Habiller(b, C.champ, C.bord)
	b:SetHeight(HAUT_CHOIX)
	b.barre = b:CreateTexture(nil, "BORDER")
	b.barre:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 0.28)
	b.barre:SetPoint("TOPLEFT", b, "TOPLEFT", 1, -1)
	b.barre:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 1, 1)
	b.compte = UI.Texte(b, "GameFontHighlight", C.texte)
	b.compte:SetPoint("RIGHT", b, "RIGHT", -10, 0)
	b.compte:SetJustifyH("RIGHT")
	b.texte = UI.Texte(b, "GameFontHighlight", C.texte)
	b.texte:SetPoint("LEFT", b, "LEFT", 10, 0)
	b.texte:SetPoint("RIGHT", b.compte, "LEFT", -8, 0)
	UI.Survol(b)
	UI.SonClic(b)
	b:SetScript("OnClick", function() voter(i) end)
	-- survol : qui a choisi ce choix (votes publics)
	b:SetScript("OnEnter", function(self)
		local s = self.sondage
		if not s then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(s.choix[i])
		local noms = {}
		for _, v in pairs(s.votes) do
			if v.n == i then noms[#noms + 1] = NomJoueur(v.nom) end
		end
		table.sort(noms)
		if #noms == 0 then
			GameTooltip:AddLine("Personne pour l'instant", 0.6, 0.6, 0.6)
		else
			for _, nom in ipairs(noms) do GameTooltip:AddLine(nom, 1, 1, 1) end
		end
		if s.etat == "ouvert" then GameTooltip:AddLine("Clic : voter pour ce choix", 0.6, 0.6, 0.6) end
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

local function CreerFenetre()
	local UI = ns.UI
	local C = UI.C
	local f = CreateFrame("Frame", "GuildUpSMBSondage", UIParent, "BackdropTemplate")
	UI.Habiller(f, C.fond, C.bordFort)
	f:SetSize(LARGEUR, HAUTEUR)
	f:SetPoint("CENTER", UIParent, "CENTER", -260, 60)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	tinsert(UISpecialFrames, "GuildUpSMBSondage") -- Échap ferme
	f:Hide()

	f.titre = UI.Texte(f, "GameFontNormal", C.ors)
	f.titre:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
	local croix = UI.Fermer(f, function() f:Hide() end, 22)
	croix:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -10)

	f.formulaire = CreerFormulaire(f)

	-- vote et résultats
	local v = CreateFrame("Frame", nil, f)
	v:SetAllPoints()
	f.vote = v
	v.question = UI.Texte(v, "GameFontHighlight", C.texte)
	v.question:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -42)
	v.question:SetWidth(LARGEUR - 32)
	v.question:SetHeight(30)
	v.question:SetJustifyV("TOP")
	v.question:SetWordWrap(true)
	v.chef = UI.Texte(v, "GameFontHighlightSmall", C.gris)
	v.chef:SetPoint("TOPLEFT", v.question, "BOTTOMLEFT", 0, -4)
	v.etat = UI.Texte(v, "GameFontHighlight", C.texte)
	v.etat:SetPoint("TOPLEFT", v.chef, "BOTTOMLEFT", 0, -8)
	v.etat:SetPoint("RIGHT", f, "RIGHT", -16, 0)
	v.lignes = {}
	for i = 1, CHOIX_MAX do
		local l = CreerLigne(v, i, function(n)
			local s = SondageAMontrer()
			if s then Voter(s, n) end
		end)
		l:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -122 - (i - 1) * (HAUT_CHOIX + ECART_CHOIX))
		l:SetPoint("RIGHT", f, "RIGHT", -16, 0)
		v.lignes[i] = l
	end
	v.aide = UI.Texte(v, "GameFontHighlightSmall", C.gris)
	v.aide:SetPoint("TOPLEFT", v.lignes[CHOIX_MAX], "BOTTOMLEFT", 0, -8)

	v.cloturer = UI.Bouton(v, "Clôturer", "fantome", 100, 26)
	v.cloturer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 14)
	v.cloturer:SetScript("OnClick", function()
		local s = SondageAMontrer()
		if s then Cloturer(s) end
	end)
	v.annuler = UI.Bouton(v, "Annuler", "fantome", 90, 26)
	v.annuler:SetPoint("RIGHT", v.cloturer, "LEFT", -8, 0)
	v.annuler:SetScript("OnClick", function()
		local s = SondageAMontrer()
		if s then Annuler(s) end
	end)
	v.nouveau = UI.Bouton(v, "Nouveau sondage", "or", 150, 26)
	v.nouveau:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 14)
	v.nouveau:SetScript("OnClick", function()
		if not PeutOuvrir() then return end
		f.creation = true
		f.formulaire.Vider()
		MajFenetre()
		f.formulaire.question.saisie:SetFocus()
	end)

	-- le compte à rebours avance tant que la fenêtre est ouverte
	local attente = 0
	f:SetScript("OnUpdate", function(_, dt)
		attente = attente + dt
		if attente < 0.25 then return end
		attente = 0
		if not f.creation then MajFenetre() end
	end)
	return f
end

MajFenetre = function()
	local f = fenetre
	if not f or not f:IsShown() then return end
	local C = ns.UI.C
	local s = SondageAMontrer()
	if f.creation or not s then
		if not f.creation then
			f.creation = true
			f.formulaire.Vider()
		end
		f.titre:SetText("Nouveau sondage")
		f.formulaire:Show()
		f.vote:Hide()
		return
	end
	f.formulaire:Hide()
	f.vote:Show()
	local v = f.vote
	local moi = MaCle()
	f.titre:SetText("Sondage")
	v.question:SetText(s.question)
	v.chef:SetText("Posé par " .. NomJoueur(s.nomChef))

	local ouvert = s.etat == "ouvert"
	local compte = Compte(s)
	local total = Total(compte)
	local monVote = s.votes[moi] and s.votes[moi].n
	if ouvert then
		local reste = Secondes(s)
		if reste <= 0 then
			v.etat:SetText("Temps écoulé : résultat dans un instant…")
		else
			v.etat:SetText(("%s pour voter · |cffffd100%d vote%s|r"):format(Duree(reste), total, total > 1 and "s" or ""))
		end
		v.aide:SetText(monVote and "Tu peux changer d'avis jusqu'à la fin. Survol : qui a voté quoi."
			or "Clique sur un choix pour voter. Survol : qui a voté quoi.")
	elseif s.etat == "annule" then
		v.etat:SetText("Sondage annulé par son auteur.")
		v.aide:SetText("")
	elseif s.etat == "interrompu" then
		v.etat:SetText("Interrompu : son auteur ne répond plus. Compte provisoire.")
		v.aide:SetText("")
	else
		v.etat:SetText("Terminé : " .. TexteResultat(s))
		v.aide:SetText("Survol : qui a voté quoi.")
	end

	local tete = {}
	if s.etat == "fini" then for _, i in ipairs(EnTete(compte)) do tete[i] = true end end
	local largeurBarre = LARGEUR - 32 - 2
	for i, l in ipairs(v.lignes) do
		local texte = s.choix[i]
		if texte then
			l.sondage = s
			local n = compte[i] or 0
			local mien = monVote == i
			l.texte:SetText((mien and "|TInterface\\Buttons\\UI-CheckBox-Check:16:16|t " or "") .. texte)
			l.compte:SetText(total > 0 and ("%d · %d %%"):format(n, math.floor(n * 100 / total + 0.5)) or "0")
			l.barre:SetWidth(math.max(1, (total > 0 and n / total or 0) * largeurBarre))
			l.barre:SetShown(n > 0)
			local fort = mien or tete[i]
			l.texte:SetTextColor(unpack(fort and C.ors or C.texte))
			l.compte:SetTextColor(unpack(tete[i] and C.ors or C.texte))
			l:SetBackdropBorderColor(unpack(fort and C.bordFort or C.bord))
			l:SetEnabled(ouvert and Secondes(s) > 0)
			l:Show()
		else
			l.sondage = nil
			l:Hide()
		end
	end

	local chef = ouvert and s.chef == moi
	v.cloturer:SetShown(chef)
	v.annuler:SetShown(chef)
	v.nouveau:SetShown(not MonSondageOuvert())
end

ns.MontrerSondage = function()
	if not ns.UI then return end
	fenetre = fenetre or CreerFenetre()
	fenetre.creation = false
	fenetre:Show()
	fenetre:Raise()
	MajFenetre()
end

-- /smb sondage : le sondage en cours (ou le dernier), sinon le formulaire d'un nouveau sondage
ns.Sondage = function()
	ns.MontrerSondage()
end

ns.Ecouter(PREFIXE, Recevoir)
