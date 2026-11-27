-- GuildUpSMB : le Motus de la guilde (onglet « Motus » de la page Jeux, /smb motus, préfixe "GuildUpMot").
-- Un seul mot par jour, le même pour toute la guilde : il est tiré de la date (heure du serveur) et de
-- ns.MOTS_MOTUS (GuildUp_Mots.lua), donc tout le monde a le même sans que rien ne circule. Sa longueur
-- change avec le jour, de 5 à 8 lettres ; la première lettre est donnée et six lignes sont offertes.
-- Les couleurs d'une proposition : or = bonne lettre bien placée, bronze = bonne lettre mal placée,
-- sombre = lettre absente. Les lettres en double sont comptées en deux passes, comme au Motus de la télé
-- (ABIME contre AMBRE : le M bien placé d'abord, ce qui reste ensuite). Le clavier de l'écran se colore
-- de la même façon, avec ce qu'on sait de chaque lettre.
-- N'importe quelle suite de lettres est acceptée comme proposition : l'addon ne connaît que 1 300 mots et
-- refuser tout le reste rendrait le jeu pénible.
--
-- On ne joue qu'en vol, sur un griffon ou un hippogriffe : au sol la grille est fermée. Le vol est lu par
-- UnitOnTaxi (appel protégé : rien ne dit que le client Forever l'ait) avec un repli sur
-- PLAYER_CONTROL_LOST / PLAYER_CONTROL_GAINED. Le chrono ne tourne que pendant le vol, l'onglet ouvert :
-- à l'atterrissage la grille se fige et reprend au vol suivant du même jour, sinon un vol court
-- condamnerait la partie. Une bulle (catégorie « motus ») propose le mot du jour au décollage, une fois
-- par vol, et seulement s'il reste à trouver.
--
-- Les points du jour : 100 de base, plus une seconde gagnée = un point (180 au plus), plus 25 par ligne
-- laissée, plus 20 par lettre au-delà de cinq. Rien du tout si le mot n'est pas trouvé.
--
-- Réseau (canal GUILD, préfixe "GuildUpMot") :
--   S~jour~points~secondes~lignes   mon score du jour (nombres en base 36)
--   Q                               « renvoyez-moi vos scores du jour », à la connexion
-- Ma partie : GuildUpDB.motus.partie, commune aux personnages du compte (comme le WoWdex) ; les scores
-- de la guilde : GuildUpDB.motus.guilde, oubliés dès que le jour change.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpMot"
local MINI, MAXI = 5, 8        -- longueurs possibles du mot du jour
local ESSAIS = 6               -- lignes offertes
local BASE_POINTS = 100
local BONUS_TEMPS = 180        -- une seconde gagnée = un point, jusqu'à ce plafond
local BONUS_LIGNE = 25         -- par ligne laissée
local BONUS_LETTRE = 20        -- par lettre au-delà de MINI
local CASE, ECART = 42, 6      -- taille d'une case de la grille et espace entre deux
local TOUCHE = 26              -- taille d'une touche du clavier de l'écran
local CLASSEMENT_MAX = 12

local Maintenant = ns.Maintenant
local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local NomJoueur = ns.NomJoueur
local Base36 = ns.Base36
local Simplifier = ns.Simplifier

local JUSTE, AILLEURS, ABSENT, VIDE = 1, 2, 3, 4

local vue           -- le cadre de l'onglet, créé à la première ouverture de la page Jeux
local partie        -- ma partie du jour (table rangée dans GuildUpDB)
local controlePerdu = false
local bulleFaite = false
local MajFenetre

--------------------------------------------------------------------------------
-- Données : les mots, le mot du jour
--------------------------------------------------------------------------------

local MOTS
local function Mots()
	if MOTS then return MOTS end
	MOTS = {}
	for n, bloc in (ns.MOTS_MOTUS or ""):gmatch("(%d+)|([^\r\n]*)") do
		local taille = tonumber(n)
		if taille and taille >= MINI and taille <= MAXI and #bloc >= taille then
			local liste = {}
			for i = 1, #bloc - taille + 1, taille do liste[#liste + 1] = bloc:sub(i, i + taille - 1) end
			MOTS[taille] = liste
		end
	end
	ns.MOTS_MOTUS = nil -- le texte brut n'est plus utile
	return MOTS
end

local function Jour(quand)
	return math.floor((quand or Maintenant()) / 86400)
end

-- Le mot du jour. Rien de hasardeux : math.random dépendrait de la graine du client et chacun aurait son
-- mot. La longueur tourne (5, 6, 7, 8, 5…) ; dans la liste de cette longueur, on avance d'un pas premier à
-- chaque fois que cette longueur revient. Le pas étant premier et plus grand que n'importe quelle liste, il
-- n'a aucun diviseur commun avec elle : tous les mots d'une longueur passent avant qu'un seul revienne,
-- soit plus de trois ans. (Compter en jours au lieu de compter les tours ne marcherait pas : un pas de
-- quatre jours et une liste de longueur paire ont 2 en commun, et la moitié des mots ne sortirait jamais.)
local PAS = 7919

local function MotDuJour(jour)
	local m = Mots()
	local tailles = {}
	for t = MINI, MAXI do
		if m[t] and #m[t] > 0 then tailles[#tailles + 1] = t end
	end
	if #tailles == 0 then return nil end
	jour = jour or 0
	local liste = m[tailles[1 + (jour % #tailles)]]
	local tour = math.floor(jour / #tailles) -- combien de fois cette longueur est déjà venue
	return liste[1 + ((tour * PAS) % #liste)]
end

--------------------------------------------------------------------------------
-- Ma partie et les scores de la guilde, gardés dans GuildUpDB
--------------------------------------------------------------------------------

local function Coffre()
	local db = ns.DB and ns.DB()
	if not db then return nil end
	if type(db.motus) ~= "table" then db.motus = {} end
	return db.motus
end

local function Neuve(jour)
	local mot = MotDuJour(jour)
	return { jour = jour, mot = mot, lignes = {}, secondes = 0, fini = (mot == nil) }
end

-- Ma partie du jour. Tant que GuildUpDB n'est pas chargé (au tout début), elle est jetable et rien
-- n'est gardé : partie reste nil, donc le chrono ne tourne pas et aucun score n'est noté.
local function Charger()
	local jour = Jour()
	if partie and partie.jour == jour then return partie end
	local coffre = Coffre()
	if not coffre then return Neuve(jour) end
	local gardee = coffre.partie
	if type(gardee) == "table" and gardee.jour == jour and type(gardee.mot) == "string" then
		partie = gardee
		if type(partie.lignes) ~= "table" then partie.lignes = {} end
		partie.secondes = tonumber(partie.secondes) or 0
	else
		partie = Neuve(jour)
		coffre.partie = partie
	end
	return partie
end

local function Scores()
	local coffre = Coffre()
	if not coffre then return {} end
	local jour = Jour()
	if type(coffre.guilde) ~= "table" or coffre.guilde.jour ~= jour then
		coffre.guilde = { jour = jour }
	end
	return coffre.guilde
end

--------------------------------------------------------------------------------
-- Les règles du jeu
--------------------------------------------------------------------------------

-- Couleur de chaque lettre d'une proposition, en deux passes (les bien placées d'abord, pour que les
-- lettres en double soient comptées juste)
local function Comparer(essai, mot)
	local etats, reste = {}, {}
	for i = 1, #mot do
		local attendue = mot:sub(i, i)
		if essai:sub(i, i) == attendue then
			etats[i] = JUSTE
		else
			reste[attendue] = (reste[attendue] or 0) + 1
		end
	end
	for i = 1, #mot do
		if not etats[i] then
			local lettre = essai:sub(i, i)
			if (reste[lettre] or 0) > 0 then
				etats[i] = AILLEURS
				reste[lettre] = reste[lettre] - 1
			else
				etats[i] = ABSENT
			end
		end
	end
	return etats
end

local function Points(taille, secondes, lignes)
	local p = BASE_POINTS
	p = p + math.max(0, BONUS_TEMPS - math.floor(secondes or 0))
	p = p + BONUS_LIGNE * math.max(0, ESSAIS - (lignes or ESSAIS))
	p = p + BONUS_LETTRE * math.max(0, (taille or MINI) - MINI)
	return p
end

-- Ce qu'on sait de chaque lettre, d'après les lignes déjà jouées (pour colorer le clavier)
local function SavoirLettres(p)
	local su = {}
	if not (p and p.mot) then return su end
	for _, essai in ipairs(p.lignes) do
		local etats = Comparer(essai, p.mot)
		for i = 1, #essai do
			local lettre, etat = essai:sub(i, i), etats[i]
			if not su[lettre] or etat < su[lettre] then su[lettre] = etat end
		end
	end
	return su
end

--------------------------------------------------------------------------------
-- Le vol : la seule porte d'entrée du jeu
--------------------------------------------------------------------------------

local function SurLeVol()
	if UnitOnTaxi then
		local ok, dessus = pcall(UnitOnTaxi, "player")
		if ok then return dessus == true or dessus == 1 end
	end
	return controlePerdu -- repli : le client n'a pas UnitOnTaxi
end

local function AJouer()
	local p = Charger()
	return p.mot ~= nil and not p.fini
end

-- Pour la pastille de la page Jeux (GuildUp_Interface.lua)
ns.MotusEnAttente = function()
	return (SurLeVol() and AJouer()) and 1 or 0
end

--------------------------------------------------------------------------------
-- Réseau
--------------------------------------------------------------------------------

local function AnnoncerMonScore()
	local p = partie
	if not (p and p.fini and p.gagne and p.points) then return end
	if not ns.EnvoyerAddon then return end
	ns.EnvoyerAddon(PREFIXE, ("S~%s~%s~%s~%s"):format(Base36(p.jour), Base36(p.points),
		Base36(math.floor(p.secondes or 0)), Base36(#p.lignes)), "GUILD")
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui then return end
	local moi = MaCle()
	local solo = ns.TestSolo and ns.TestSolo()
	if msg == "Q" then
		if qui ~= moi or solo then AnnoncerMonScore() end
		return
	end
	local jour, points, secondes, lignes = msg:match("^S~(%w+)~(%w+)~(%w+)~(%w+)$")
	if not jour then return end
	jour, points = tonumber(jour, 36), tonumber(points, 36)
	secondes, lignes = tonumber(secondes, 36), tonumber(lignes, 36)
	if not points or jour ~= Jour() then return end
	if qui == moi and not solo then return end -- mon propre score, déjà noté
	local s = Scores()
	s[qui] = { p = points, s = secondes or 0, l = lignes or ESSAIS }
	if MajFenetre then MajFenetre() end
end

--------------------------------------------------------------------------------
-- La grille
--------------------------------------------------------------------------------

local C
local function Couleurs()
	C = C or (ns.UI and ns.UI.C)
	return C
end

local function Peindre(case, etat)
	local c = Couleurs()
	if not c then return end
	if etat == JUSTE then
		case:SetBackdropColor(c.orFonce[1], c.orFonce[2], c.orFonce[3], 1)
		case:SetBackdropBorderColor(c.ors[1], c.ors[2], c.ors[3], 1)
		case.lettre:SetTextColor(0.07, 0.05, 0.02)
		case.lettre:SetShadowColor(0, 0, 0, 0)
	elseif etat == AILLEURS then
		case:SetBackdropColor(0.33, 0.25, 0.09, 1)
		case:SetBackdropBorderColor(c.bordFort[1], c.bordFort[2], c.bordFort[3], 1)
		case.lettre:SetTextColor(c.ors[1], c.ors[2], c.ors[3])
		case.lettre:SetShadowColor(0, 0, 0, 1)
	elseif etat == ABSENT then
		case:SetBackdropColor(0.085, 0.075, 0.065, 1)
		case:SetBackdropBorderColor(c.bord[1], c.bord[2], c.bord[3], 1)
		case.lettre:SetTextColor(c.gris[1], c.gris[2], c.gris[3])
		case.lettre:SetShadowColor(0, 0, 0, 1)
	else
		case:SetBackdropColor(c.champ[1], c.champ[2], c.champ[3], 1)
		case:SetBackdropBorderColor(c.bordMoyen[1], c.bordMoyen[2], c.bordMoyen[3], 1)
		case.lettre:SetTextColor(c.texte[1], c.texte[2], c.texte[3])
		case.lettre:SetShadowColor(0, 0, 0, 1)
	end
end

local function CreerGrille(parent)
	local UI = ns.UI
	local g = CreateFrame("Frame", nil, parent)
	g:SetSize(MAXI * CASE + (MAXI - 1) * ECART, ESSAIS * CASE + (ESSAIS - 1) * ECART)
	g.cases = {}
	for ligne = 1, ESSAIS do
		g.cases[ligne] = {}
		for colonne = 1, MAXI do
			local case = UI.Cadre(g, UI.C.champ, UI.C.bord)
			case:SetSize(CASE, CASE)
			case:SetPoint("TOPLEFT", g, "TOPLEFT", (colonne - 1) * (CASE + ECART), -(ligne - 1) * (CASE + ECART))
			case.lettre = UI.Texte(case, "GameFontNormalLarge", UI.C.texte)
			case.lettre:SetPoint("CENTER")
			case.lettre:SetJustifyH("CENTER")
			g.cases[ligne][colonne] = case
		end
	end
	return g
end

--------------------------------------------------------------------------------
-- Le clavier de l'écran (et le champ invisible qui capte les touches)
--------------------------------------------------------------------------------

local RANGEES = { "AZERTYUIOP", "QSDFGHJKLM", "WXCVBN" }

local function CreerClavier(parent, taper, effacer, valider)
	local UI = ns.UI
	local k = CreateFrame("Frame", nil, parent)
	k:SetSize(10 * TOUCHE + 9 * 3, 3 * TOUCHE + 2 * 3)
	k.touches = {}
	for r, rangee in ipairs(RANGEES) do
		for i = 1, #rangee do
			local lettre = rangee:sub(i, i)
			local b = UI.Bouton(k, lettre, nil, TOUCHE, TOUCHE)
			b:SetPoint("TOPLEFT", k, "TOPLEFT", (i - 1) * (TOUCHE + 3), -(r - 1) * (TOUCHE + 3))
			b:SetScript("OnClick", function() taper(lettre) end)
			k.touches[lettre] = b
		end
	end
	k.retour = UI.Bouton(k, "<", nil, TOUCHE + 14, TOUCHE)
	k.retour:SetPoint("TOPLEFT", k, "TOPLEFT", 6 * (TOUCHE + 3), -2 * (TOUCHE + 3))
	k.retour:SetScript("OnClick", effacer)
	UI.Infobulle(k.retour, "Effacer la dernière lettre")
	k.valider = UI.Bouton(k, "Entrée", "or", 2 * TOUCHE + 24, TOUCHE)
	k.valider:SetPoint("TOPLEFT", k.retour, "TOPRIGHT", 3, 0)
	k.valider:SetScript("OnClick", valider)
	return k
end

--------------------------------------------------------------------------------
-- L'onglet
--------------------------------------------------------------------------------

local function Secondes(n)
	n = math.floor(n or 0)
	if n < 60 then return ("%d s"):format(n) end
	return ("%d min %02d s"):format(math.floor(n / 60), n % 60)
end

local function Taille()
	local p = Charger()
	return (p and p.mot) and #p.mot or MINI
end

-- La proposition en cours : la première lettre donnée, puis ce que le joueur a tapé
local function EnCours(p)
	p = p or Charger()
	if not (p and p.mot) then return "" end
	return p.mot:sub(1, 1) .. ((vue and vue.champ:GetText()) or ""):upper()
end

local function Valider()
	local p = Charger()
	if not (p and p.mot) or p.fini or not SurLeVol() then return end
	local essai = EnCours(p)
	if #essai ~= #p.mot then
		if ns.Erreur then ns.Erreur(("Il faut %d lettres."):format(#p.mot)) end
		return
	end
	p.lignes[#p.lignes + 1] = essai
	vue.champ:SetText("")
	if essai == p.mot then
		p.fini, p.gagne = true, true
		p.points = Points(#p.mot, p.secondes, #p.lignes)
		local s = Scores()
		s[MaCle()] = { p = p.points, s = math.floor(p.secondes or 0), l = #p.lignes }
		AnnoncerMonScore()
		if ns.Notifier then
			ns.Notifier("motus", "Motus", ("Trouvé : |cffffd100%s|r · %d points"):format(p.mot, p.points), nil,
				function() if ns.MontrerMotus then ns.MontrerMotus() end end)
		end
	elseif #p.lignes >= ESSAIS then
		p.fini, p.gagne, p.points = true, false, 0
	end
	MajFenetre()
end

local function Taper(lettre)
	local p = Charger()
	if not (p and p.mot) or p.fini or not SurLeVol() then return end
	local champ = vue and vue.champ
	if not champ then return end
	local texte = champ:GetText() or ""
	if #texte >= #p.mot - 1 then return end -- la première lettre est donnée : une de moins à taper
	champ:SetText(texte .. lettre)
end

local function Effacer()
	local champ = vue and vue.champ
	if not champ then return end
	local texte = champ:GetText() or ""
	if #texte > 0 then champ:SetText(texte:sub(1, #texte - 1)) end
end

MajFenetre = function()
	if not vue then return end
	local UI, c = ns.UI, Couleurs()
	local p = Charger()
	local taille = (p.mot and #p.mot) or MINI
	local enVol, aJouer = SurLeVol(), AJouer()
	local jouable = enVol and aJouer

	-- la grille : les lignes jouées, la ligne en cours, le reste vide
	local encours = jouable and EnCours(p) or ""
	for ligne = 1, ESSAIS do
		local essai = p.lignes[ligne]
		local etats = (essai and p.mot) and Comparer(essai, p.mot) or nil
		for colonne = 1, MAXI do
			local case = vue.grille.cases[ligne][colonne]
			case:SetShown(colonne <= taille)
			if colonne <= taille then
				if essai then
					case.lettre:SetText(essai:sub(colonne, colonne))
					Peindre(case, etats[colonne])
				elseif ligne == #p.lignes + 1 then
					case.lettre:SetText(encours:sub(colonne, colonne))
					Peindre(case, VIDE)
				else
					case.lettre:SetText("")
					Peindre(case, ABSENT)
				end
			end
		end
	end
	vue.grille:SetWidth(taille * CASE + (taille - 1) * ECART)

	-- le clavier : coloré avec ce qu'on sait, caché si on ne peut pas jouer
	local su = SavoirLettres(p)
	for lettre, b in pairs(vue.clavier.touches) do
		local etat = su[lettre]
		if etat == JUSTE then
			b.texte:SetTextColor(c.ors[1], c.ors[2], c.ors[3])
			b:SetAlpha(1)
		elseif etat == AILLEURS then
			b.texte:SetTextColor(c.orFonce[1], c.orFonce[2], c.orFonce[3])
			b:SetAlpha(1)
		elseif etat == ABSENT then
			b.texte:SetTextColor(c.gris[1], c.gris[2], c.gris[3])
			b:SetAlpha(0.4)
		else
			b.texte:SetTextColor(c.texte[1], c.texte[2], c.texte[3])
			b:SetAlpha(1)
		end
	end
	vue.clavier:SetShown(jouable)
	vue.grille:SetShown((enVol or p.fini) and true or false)

	-- le bandeau du haut : la consigne, le chrono
	if p.mot == nil then
		vue.consigne:SetText("|cffff7f7fLa liste de mots n'a pas pu être lue.|r")
	elseif p.fini and p.gagne then
		vue.consigne:SetText(("Mot du jour trouvé : |cffffd100%s|r en %d ligne%s et %s · |cffffd100%d points|r")
			:format(p.mot, #p.lignes, #p.lignes > 1 and "s" or "", Secondes(p.secondes), p.points or 0))
	elseif p.fini then
		vue.consigne:SetText(("Le mot du jour était |cffffd100%s|r. Rien marqué aujourd'hui, à demain."):format(p.mot))
	elseif not enVol then
		vue.consigne:SetText("|cfff1cf6bLe Motus ne s'ouvre qu'en vol.|r Prends un griffon : le mot du jour t'attend pendant le trajet.")
	else
		vue.consigne:SetText(("%d lettres, %d ligne%s · la première lettre est donnée · |cffffd100%s|r")
			:format(taille, ESSAIS - #p.lignes, (ESSAIS - #p.lignes) > 1 and "s restantes" or " restante",
				Secondes(p.secondes)))
	end
	vue.aide:SetShown(jouable and not vue.champ:HasFocus())

	-- le classement du jour
	local scores, liste = Scores(), {}
	for cle, s in pairs(scores) do
		if cle ~= "jour" and type(s) == "table" and s.p then
			liste[#liste + 1] = { cle = cle, p = s.p, s = s.s, l = s.l }
		end
	end
	table.sort(liste, function(a, b)
		if a.p ~= b.p then return a.p > b.p end
		return (a.s or 0) < (b.s or 0)
	end)
	local moi = MaCle()
	for i = 1, CLASSEMENT_MAX do
		local r, e = vue.rangs[i], liste[i]
		r:SetShown(e ~= nil)
		if e then
			r.nom:SetText(("%d. %s"):format(i, NomJoueur(e.cle)))
			r.detail:SetText(("%d pts · %s · %d l."):format(e.p, Secondes(e.s), e.l or ESSAIS))
			r:Fort(e.cle == moi)
		end
	end
	vue.carteClassement.vide:SetText(#liste == 0 and "Personne n'a encore trouvé le mot du jour." or "")
	vue.carteClassement.compte:SetText(#liste > 0 and ("%d"):format(#liste) or "")
end

local function CreerOnglet(parent)
	local UI = ns.UI
	C = UI.C
	local largeur = parent:GetWidth()
	if not largeur or largeur < 100 then largeur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) - 32 end

	local f = CreateFrame("Frame", nil, parent)
	f:SetAllPoints()
	vue = f

	local carte = UI.Carte(f, "Le mot du jour")
	carte:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	carte:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 0)
	carte:SetWidth(math.max(430, math.floor((largeur - 12) * 0.62)))
	UI.Infobulle(carte.titre, "Motus de la guilde",
		"Un mot par jour, le même pour toute la guilde, et seulement en vol. Or : bonne lettre bien placée. "
		.. "Bronze : bonne lettre, mauvaise place. Les points montent quand tu trouves vite et en peu de lignes.")

	f.consigne = UI.Texte(carte, "GameFontHighlight", UI.C.gris)
	f.consigne:SetPoint("TOPLEFT", carte, "TOPLEFT", 14, -38)
	f.consigne:SetPoint("RIGHT", carte, "RIGHT", -14, 0)
	f.consigne:SetWordWrap(true)

	f.grille = CreerGrille(carte)
	f.grille:SetPoint("TOP", carte, "TOP", 0, -74)

	-- champ invisible : il ne sert qu'à capter les touches du clavier (le jeu gère retour arrière et
	-- Entrée tout seul). La grille affiche son contenu ; lui reste à un pixel, transparent.
	local champ = CreateFrame("EditBox", nil, carte)
	champ:SetSize(1, 1)
	champ:SetPoint("TOPLEFT", carte, "TOPLEFT", 2, -2)
	champ:SetAlpha(0)
	champ:SetAutoFocus(false)
	pcall(champ.SetFontObject, champ, "GameFontHighlight")
	champ:SetMaxLetters(MAXI - 1)
	champ:SetScript("OnTextChanged", function(self)
		local brut = self:GetText() or ""
		local propre = (Simplifier(brut):upper():gsub("[^A-Z]", ""))
		local maxi = math.max(0, Taille() - 1)
		if #propre > maxi then propre = propre:sub(1, maxi) end
		if propre ~= brut then self:SetText(propre) return end
		MajFenetre()
	end)
	champ:SetScript("OnEnterPressed", Valider)
	champ:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	champ:SetScript("OnEditFocusGained", MajFenetre)
	champ:SetScript("OnEditFocusLost", MajFenetre)
	f.champ = champ

	f.aide = UI.Bouton(carte, "Clic ici pour taper au clavier", nil, 230, 22)
	f.aide:SetPoint("TOP", f.grille, "BOTTOM", 0, -10)
	f.aide:SetScript("OnClick", function() champ:SetFocus() end)

	f.clavier = CreerClavier(carte, Taper, Effacer, Valider)
	f.clavier:SetPoint("BOTTOM", carte, "BOTTOM", 0, 16)

	-- le classement du jour, à droite
	local cl = UI.Carte(f, "Classement du jour")
	cl:SetPoint("TOPLEFT", carte, "TOPRIGHT", 12, 0)
	cl:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)
	f.carteClassement = cl
	f.rangs = {}
	for i = 1, CLASSEMENT_MAX do
		local r = UI.Rangee(cl, 34)
		r:SetPoint("TOPLEFT", cl, "TOPLEFT", 10, -34 - (i - 1) * 37)
		r:SetPoint("RIGHT", cl, "RIGHT", -10, 0)
		r.nom = UI.Texte(r, "GameFontNormal", UI.C.texte)
		r.nom:SetPoint("LEFT", r, "LEFT", 10, 0)
		r.detail = UI.Texte(r, "GameFontHighlightSmall", UI.C.gris)
		r.detail:SetPoint("RIGHT", r, "RIGHT", -10, 0)
		r.detail:SetJustifyH("RIGHT")
		f.rangs[i] = r
	end

	f:SetScript("OnShow", function()
		Charger()
		if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, "Q", "GUILD") end
		if SurLeVol() and AJouer() then champ:SetFocus() end
		MajFenetre()
	end)
	f:SetScript("OnHide", function() champ:ClearFocus() end)
	f.Maj = MajFenetre
	f.Ouvrir = function() MajFenetre() end
	return f
end

ns.MontrerMotus = function()
	if ns.OuvrirInterface then ns.OuvrirInterface("jeux", "motus") end
end

if ns.AjouterJeu then ns.AjouterJeu("Motus", CreerOnglet, "motus") end

--------------------------------------------------------------------------------
-- Le chrono et le vol
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")

local function Decoller()
	local p = Charger()
	if bulleFaite or not AJouer() or not ns.Notifier then return end
	bulleFaite = true
	ns.Notifier("motus", "Motus", ("Le mot du jour t'attend : %d lettres, %d ligne%s. Clic : jouer.")
		:format(#p.mot, ESSAIS - #p.lignes, (ESSAIS - #p.lignes) > 1 and "s" or ""), nil,
		function() if ns.MontrerMotus then ns.MontrerMotus() end end)
end

local function Atterrir()
	bulleFaite = false
	if vue and vue.champ then vue.champ:ClearFocus() end
end

-- Le décollage et l'atterrissage sont guettés ici et pas seulement par les évènements : rien ne garantit
-- que PLAYER_CONTROL_LOST parte au griffon sur ce client, alors qu'UnitOnTaxi, lui, se relit quand on veut.
local volAvant, tic = false, 0
ev:SetScript("OnUpdate", function(_, ecoule)
	ecoule = ecoule or 0
	local p = partie
	if p and p.mot and not p.fini and vue and vue:IsVisible() and SurLeVol() then
		p.secondes = (p.secondes or 0) + ecoule
	end
	tic = tic + ecoule
	if tic < 1 then return end
	tic = 0
	local enVol = SurLeVol()
	if enVol ~= volAvant then
		volAvant = enVol
		if enVol then Decoller() else Atterrir() end
		if MajFenetre then MajFenetre() end
	elseif p and p.mot and not p.fini and enVol and vue and vue:IsVisible() then
		MajFenetre() -- une seconde de plus au chrono affiché
	end
end)

for _, nom in ipairs({ "PLAYER_LOGIN", "PLAYER_ENTERING_WORLD", "PLAYER_CONTROL_LOST", "PLAYER_CONTROL_GAINED" }) do
	pcall(ev.RegisterEvent, ev, nom)
end

ev:SetScript("OnEvent", function(_, evenement)
	if evenement == "PLAYER_CONTROL_LOST" then
		controlePerdu = true
	elseif evenement == "PLAYER_CONTROL_GAINED" then
		controlePerdu = false
	end
	Charger()
	if evenement == "PLAYER_LOGIN" and ns.EnvoyerAddon then
		ns.EnvoyerAddon(PREFIXE, "Q", "GUILD")
	end
	if MajFenetre then MajFenetre() end
end)

ns.Ecouter(PREFIXE, Recevoir)

--------------------------------------------------------------------------------
-- Diagnostic (/smb diag)
--------------------------------------------------------------------------------

ns.DiagMotus = function(L)
	local m = Mots()
	local compte = 0
	for t = MINI, MAXI do compte = compte + (m[t] and #m[t] or 0) end
	local p = partie
	L(("motus : %d mots, UnitOnTaxi %s, en vol %s, mot du jour %s"):format(compte,
		UnitOnTaxi and "oui" or "non", SurLeVol() and "oui" or "non",
		(p and p.mot) and ("%d lettres"):format(#p.mot) or "aucun"))
	if p then
		L(("motus, ma partie : %d ligne(s), %s, %s%s"):format(#p.lignes, Secondes(p.secondes),
			p.fini and (p.gagne and "trouvé" or "perdu") or "en cours",
			p.points and (", %d points"):format(p.points) or ""))
	end
end
