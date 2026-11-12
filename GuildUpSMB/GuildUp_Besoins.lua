-- GuildUpSMB : besoins (onglet « Besoins » de la page « Dons » de la fenêtre GuildUpSMB).
-- Chaque joueur liste les objets dont il a besoin (avec une quantité). La liste part à la guilde
-- (préfixe "GuildUpBes") et chacun la garde (GuildUpDB) : elle reste visible même quand son
-- auteur est hors ligne.
--   "B~objet:qte,objet:qte,…"   ma liste complète (vide = plus aucun besoin ; qte 0 = sans limite)
--   "V~cle~date~objet36:qte,…"  liste d'un autre membre, renvoyée par le relais élu
--   "Q"                          « renvoyez vos listes » (à la connexion)
-- Bulle « Besoin dans la guilde » pour ceux qui savent fabriquer l'objet demandé ; ligne « Miko a
-- besoin de cette ressource » ajoutée aux infobulles d'objets du jeu.
-- Interface (kit ns.UI) : ns.CreerPageBesoins(parent) fabrique le contenu de l'onglet (appelé par
-- GuildUp_Echanges.lua, qui le rafraîchit) : carte « Mes besoins » (case où glisser un objet ou
-- recherche dans tous les objets du jeu, quantité ou « sans limite », Ajouter ; liste avec Retirer ;
-- un besoin qu'un membre met en don affiche « donné par X » et un bouton Demander, le même que celui
-- de l'onglet Dons : ns.DonneursParObjet et ns.DemanderDon de GuildUp_Echanges.lua) et carte « Besoins
-- de la guilde » (ce que j'ai dans mes sacs ou ma banque, ns.ObjetDonnable, puis ce que je sais
-- fabriquer d'abord, Chuchoter). Fournit aussi aux autres onglets ns.IconeObjet (icône bordée à la
-- couleur de qualité), ns.InfobulleObjet, ns.EcrireNomObjet et ns.NomMembreColore, et aux dons
-- ns.MonBesoin(objet) / ns.MesBesoinsListe() (croisement des dons et de mes besoins).

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpBes"
local MAX_BESOINS = 20
local CALME = 25
local OUBLI = 30 * 86400      -- une liste sans nouvelles depuis 30 jours est oubliée

local debut = GetTime()
local pret = false

local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local TestSolo = ns.TestSolo
local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local Erreur = ns.Erreur

-- La page « Dons » (GuildUp_Echanges.lua) se rafraîchit si elle est affichée, avec ses compteurs
local function Rafraichir() if ns.MajOngletsEchanges then ns.MajOngletsEchanges() end end

--------------------------------------------------------------------------------
-- Données
--   db.besoins.mes[perso]            = { [objet] = quantité }
--   db.besoins.guildes[guilde][cle]  = { nom, liste = { [objet] = quantité }, vu }
--------------------------------------------------------------------------------

local function Racine()
	local db = ns.DB and ns.DB()
	if not db then return { mes = {}, guildes = {} } end
	if type(db.besoins) ~= "table" then db.besoins = {} end
	local b = db.besoins
	if type(b.mes) ~= "table" then b.mes = {} end
	if type(b.guildes) ~= "table" then b.guildes = {} end
	return b
end

local function MesBesoins()
	local b = Racine()
	local cle = MaCle()
	if type(b.mes[cle]) ~= "table" then b.mes[cle] = {} end
	return b.mes[cle]
end

local function Guilde()
	local nom = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not nom then return nil end
	local b = Racine()
	if type(b.guildes[nom]) ~= "table" then b.guildes[nom] = {} end
	return b.guildes[nom]
end

local InfoObjet = ns.InfoObjet

local Precharger = ns.Precharger

local function Coder(liste)
	local t = {}
	for objet, qte in pairs(liste) do t[#t + 1] = objet .. ":" .. qte end
	table.sort(t)
	return table.concat(t, ",")
end

local function Decoder(texte)
	local liste = {}
	for objet, qte in (texte or ""):gmatch("(%d+):(%d+)") do
		objet, qte = tonumber(objet), tonumber(qte)
		if objet and qte and qte >= 0 then liste[objet] = qte end
	end
	return liste
end

local function EnvoyerMaListe()
	Envoyer("B~" .. Coder(MesBesoins()))
end

--------------------------------------------------------------------------------
-- Mes besoins
--------------------------------------------------------------------------------

-- Quantité affichée : « x5 », ou « sans limite » pour un besoin permanent (quantité 0)
local function TexteQte(qte, avecUn)
	if qte == 0 then return "sans limite" end
	if qte > 1 or avecUn then return "x" .. qte end
	return nil
end

local function Ajouter(objet, qte)
	if not objet then Erreur("Choisis d'abord un objet (cherche-le ou glisse-le dans la case)"); return false end
	local mes = MesBesoins()
	local n = 0
	for _ in pairs(mes) do n = n + 1 end
	if not mes[objet] and n >= MAX_BESOINS then Erreur("Pas plus de " .. MAX_BESOINS .. " besoins"); return false end
	mes[objet] = (qte == 0) and 0 or math.max(1, math.min(999, math.floor(qte or 1)))
	Precharger(objet)
	EnvoyerMaListe()
	Rafraichir()
	return true
end

-- Pour la fiche encyclopédie du carnet
ns.AjouterBesoin = function(objet, qte) return Ajouter(objet, qte) end
-- Pour les dons (GuildUp_Echanges.lua) : quantité de mon besoin pour cet objet (0 = sans limite), nil
-- si ce n'est pas un de mes besoins ; et toute la liste { [objet] = quantité } (ne pas la modifier)
ns.MonBesoin = function(objet) return objet and MesBesoins()[objet] or nil end
ns.MesBesoinsListe = function() return MesBesoins() end

local function Retirer(objet)
	MesBesoins()[objet] = nil
	EnvoyerMaListe()
	Rafraichir()
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function AlerteBesoin(nom, objet, qte)
	if not ns.Notifier then return end
	local nomO, lien = InfoObjet(objet)
	ns.Notifier("plans", "Besoin dans la guilde", ("%s cherche %s%s — tu sais le fabriquer"):format(NomJoueur(nom),
		lien or nomO or ("l'objet " .. objet), TexteQte(qte) and (" " .. TexteQte(qte)) or ""), nil,
		function() if ns.OuvrirBesoins then ns.OuvrirBesoins() end end)
end

-- Relais : à la connexion d'un membre (son « Q »), un membre en ligne lui renvoie aussi les listes
-- des absents qu'il a gardées. Chaque liste porte sa date (heure du serveur) : on garde la plus
-- récente. Une liste vide reste notée (pour qu'un besoin retiré disparaisse aussi chez les autres).
--   "V~cle~date~objet36:qte,…"  liste d'un autre membre, renvoyée
local Maintenant = ns.Maintenant
local relayees = {}   -- [cle] = moment où une liste de ce membre est passée (envoyée ou reçue)

local B36 = ns.Base36

-- Enregistre une liste (directe ou relayée) si elle est plus récente que celle connue ; renvoie
-- l'ancienne liste si elle a été remplacée
local function Enregistrer(g, cle, nom, liste, date)
	local e = g[cle]
	if e and (e.maj or e.vu or 0) > date then return nil end
	local ancienne = e and e.liste or {}
	g[cle] = { nom = nom, liste = liste, vu = date, maj = date }
	return ancienne
end

local function Relayer(pour)
	C_Timer.After(3 + math.random() * 7, function()
		local g = Guilde()
		if not g then return end
		-- un seul relais pour toute la guilde
		if ns.EstLeRelais and not ns.EstLeRelais(pour) then return end
		for cle, e in pairs(g) do
			if type(e) == "table" and cle ~= pour and not cle:find("#test", 1, true)
				and (e.vu or 0) >= Maintenant() - OUBLI and not (ns.MembreGuilde and ns.MembreGuilde(cle) == false)
				and not (ns.EnLigneMembre and ns.EnLigneMembre(cle)) -- connecté : il répond lui-même
				and not (relayees[cle] and GetTime() - relayees[cle] < 30) then
				local mots = {}
				for objet, qte in pairs(e.liste or {}) do mots[#mots + 1] = B36(objet) .. ":" .. qte end
				relayees[cle] = GetTime()
				Envoyer(("V~%s~%d~%s"):format(cle, e.maj or e.vu or 0, table.concat(mots, ",")))
			end
		end
	end)
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle, nom = Normaliser(expediteur), expediteur
	if cle == MaCle() then
		if not TestSolo() then return end
		cle, nom = cle .. "#test", expediteur .. " (test)"
	end
	local genre, reste = msg:match("^(%a)~?(.*)$")
	if genre == "Q" then
		if pret then
			-- liste vide : rien à dire (une liste vidée part tout de suite, à la modification)
			if next(MesBesoins()) then C_Timer.After(1 + math.random() * 4, EnvoyerMaListe) end
			Relayer(cle) -- il vient de se connecter : les listes des absents lui partent aussi
		end
	elseif genre == "B" then
		local g = Guilde()
		if not g then return end
		local liste = Decoder(reste)
		relayees[cle] = GetTime()
		local ancienne = Enregistrer(g, cle, nom, liste, Maintenant())
		if not ancienne then return end
		for objet, qte in pairs(liste) do
			Precharger(objet)
			-- nouvel objet demandé, que je sais fabriquer : bulle (pas pendant le calme de connexion)
			if not ancienne[objet] and GetTime() - debut > CALME and ns.JeSaisFabriquer and ns.JeSaisFabriquer(objet) then
				C_Timer.After(1, function() AlerteBesoin(nom, objet, qte) end)
			end
		end
		Rafraichir()
	elseif genre == "V" then
		local qui, date, mots = reste:match("^([^~]+)~(%d+)~?(.*)$")
		date = tonumber(date)
		if not qui or not date or qui == MaCle() or date > Maintenant() + 60 then return end
		relayees[qui] = GetTime()
		local g = Guilde()
		if not g then return end
		local liste = {}
		for o, q in (mots or ""):gmatch("(%w+):(%d+)") do
			o, q = tonumber(o, 36), tonumber(q)
			if o and q and q >= 0 then liste[o] = q; Precharger(o) end
		end
		local nomQui = (g[qui] and g[qui].nom) or qui
		if Enregistrer(g, qui, nomQui, liste, date) then Rafraichir() end
	end
end

--------------------------------------------------------------------------------
-- Recherche d'un objet par son nom dans tout le jeu (GuildUp_Objets.lua, ou GuildUp_Objets_enUS.lua
-- sur un client anglais : noms dans la langue du client), même sans l'avoir
--------------------------------------------------------------------------------

local Simplifier = ns.Simplifier

local index                    -- { { id, qualité, nom, nom simplifié }, … } (construit au premier besoin)
local function Index()
	if index then return index end
	index = {}
	for id, q, classe, niveau, nom in (ns.DONNEES_OBJETS or ""):gmatch("(%d+):(%d+):(%d+):(%d+):([^\n]+)") do
		index[#index + 1] = { tonumber(id), tonumber(q), nom, Simplifier(nom), tonumber(classe), tonumber(niveau) }
	end
	ns.DONNEES_OBJETS = nil -- le texte brut n'est plus utile
	return index
end

-- Ingrédients d'abord (artisanat, composants), puis les noms qui commencent par le texte, puis
-- ceux où un mot commence par le texte, puis le reste
local INGREDIENTS = { [7] = true, [5] = true }
local function ChercherObjets(texte, max)
	local t = Simplifier(strtrim(texte or ""))
	if #t < 2 then return {} end
	local trouves = {}
	for _, o in ipairs(Index()) do
		local pos = o[4]:find(t, 1, true)
		if pos then
			local rang = (pos == 1) and 0 or (o[4]:find(" " .. t, 1, true) and 1 or 2)
			trouves[#trouves + 1] = { o = o, ingredient = INGREDIENTS[o[5] or -1] and 0 or 1, rang = rang }
			if #trouves >= 400 then break end
		end
	end
	table.sort(trouves, function(a, b)
		if a.ingredient ~= b.ingredient then return a.ingredient < b.ingredient end
		if a.rang ~= b.rang then return a.rang < b.rang end
		return a.o[4] < b.o[4]
	end)
	local res = {}
	for i = 1, math.min(max, #trouves) do res[i] = trouves[i].o end
	return res
end
ns.ChercherObjets = ChercherObjets

local Depuis = ns.Depuis

-- Membre encore dans la guilde ? (liste de guilde chargée : sinon on garde)
local function DansLaGuilde(cle)
	if cle:find("#test", 1, true) then return true end
	if ns.MembreGuilde then return ns.MembreGuilde(cle) ~= false end
	return true
end

-- nom d'un objet d'après la liste du jeu (quand il n'est pas encore en cache)
local parId -- [id] = entrée de l'index (construit au premier besoin)
local function NomListe(objet)
	if not parId then
		parId = {}
		for _, o in ipairs(Index()) do parId[o[1]] = o end
	end
	local o = parId[objet]
	if o then return o[3], o[2] end
end
-- Pour la page Items du carnet : la liste de tous les objets échangeables, et un nom de secours
ns.IndexObjets = Index
ns.NomObjetListe = function(objet) return (NomListe(objet)) end

-- Nombre de besoins listés par la guilde (compteur de l'onglet)
ns.NombreBesoins = function()
	local n = 0
	for cle, e in pairs(Guilde() or {}) do
		if type(e) == "table" and DansLaGuilde(cle) and (TestSolo() or not cle:find("#test", 1, true)) then
			for _ in pairs(e.liste or {}) do n = n + 1 end
		end
	end
	return n
end

--------------------------------------------------------------------------------
-- Éléments communs aux onglets de la page « Dons » (repris par GuildUp_Echanges.lua)
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI.C
local BLANC = "Interface\\Buttons\\WHITE8X8"
local ICONE_INCONNUE = "Interface\\Icons\\INV_Misc_QuestionMark"
local CASE_VIDE = "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
local VERT, OR = "|cff6fd08c", "|cfff1cf6b"
local MARGE = 16

-- Icône d'objet dans un cadre bordé (2 pixels) à la couleur de sa qualité ; genre "Button" pour une
-- case cliquable. f:Poser(icône, qualité, vide) : vide = icône grisée (case sans objet)
local function IconeObjet(parent, taille, genre)
	local f = CreateFrame(genre or "Frame", nil, parent, "BackdropTemplate")
	f:SetSize(taille, taille)
	if f.SetBackdrop then
		f:SetBackdrop({ bgFile = BLANC, edgeFile = BLANC, edgeSize = 2 })
		f:SetBackdropColor(unpack(C.champ))
		f:SetBackdropBorderColor(unpack(C.bord))
	end
	f.image = f:CreateTexture(nil, "ARTWORK")
	f.image:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
	f.image:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
	f.image:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	if genre == "Button" then UI.Survol(f, 0.12) end
	f.Poser = function(self, icone, qualite, vide)
		self.image:SetTexture(icone or ICONE_INCONNUE)
		self.image:SetDesaturated(vide and true or false)
		if not self.SetBackdropBorderColor then return end
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		if qc then self:SetBackdropBorderColor(qc.r, qc.g, qc.b, 1) else self:SetBackdropBorderColor(unpack(C.bord)) end
	end
	return f
end
ns.IconeObjet = IconeObjet

-- Infobulle de l'objet du cadre (self.objet) au survol ; plus(self, bulle) ajoute des lignes
local function InfobulleObjet(cadre, plus)
	cadre:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		if plus then plus(self, GameTooltip) end
		GameTooltip:Show()
	end)
	cadre:SetScript("OnLeave", function() GameTooltip:Hide() end)
end
ns.InfobulleObjet = InfobulleObjet

-- Nom d'un objet à la couleur de sa qualité (« chargement… » tant que le jeu ne l'a pas)
local function EcrireNomObjet(fs, nom, qualite)
	if not nom then
		fs:SetText("chargement…")
		fs:SetTextColor(unpack(C.gris))
		return
	end
	fs:SetText(nom)
	local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
	if qc then fs:SetTextColor(qc.r, qc.g, qc.b) else fs:SetTextColor(unpack(C.texte)) end
end
ns.EcrireNomObjet = EcrireNomObjet

-- Nom d'un membre à la couleur de sa classe, si elle est connue (positions partagées de la carte)
-- nom à la couleur de sa classe (liste de guilde, sinon position partagée), sinon neutre
local function NomMembreColore(cle, nom)
	local classe = ns.ClasseMembre and ns.ClasseMembre(cle)
	if not classe then
		local positions = ns.PositionsMembres and ns.PositionsMembres()
		local p = positions and cle and positions[(cle:gsub("#test$", ""))]
		classe = p and p.classe
	end
	if classe and ns.CouleurClasseTexte then return ns.CouleurClasseTexte(classe) .. NomJoueur(nom) .. "|r" end
	return NomJoueur(nom)
end
ns.NomMembreColore = NomMembreColore

--------------------------------------------------------------------------------
-- Onglet « Besoins »
--------------------------------------------------------------------------------

local page
local choix                    -- objet choisi dans la zone d'ajout
local HAUTEUR_LIGNE, ECART_LIGNE = 44, 4
local MAX_RES = 10

-- Ligne d'une liste : icône, nom, sous-titre, bouton à droite
local function CreerLigne(parent, texteBouton, style, plus)
	local r = UI.Rangee(parent, HAUTEUR_LIGNE)
	r.icone = IconeObjet(r, 32)
	r.icone:SetPoint("LEFT", r, "LEFT", 8, 0)
	r.bouton = UI.Bouton(r, texteBouton, style, 86, 24)
	r.bouton:SetPoint("RIGHT", r, "RIGHT", -8, 0)
	r.nom = UI.Texte(r, "GameFontNormal")
	r.nom:SetPoint("TOPLEFT", r.icone, "TOPRIGHT", 10, -1)
	r.nom:SetPoint("RIGHT", r.bouton, "LEFT", -8, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("BOTTOMLEFT", r.icone, "BOTTOMRIGHT", 10, 1)
	r.sous:SetPoint("RIGHT", r.bouton, "LEFT", -8, 0)
	r.objet, r.d = false, false
	InfobulleObjet(r, plus)
	return r
end

-- Ligne de « Mes besoins » : Retirer, et Demander quand un membre donne l'objet (r.d.donneurs)
local function InfobulleDemander(self)
	local d = self:GetParent().d
	local premier = d and d.donneurs and d.donneurs[1]
	if not premier then return end
	local nom = NomJoueur(premier.e.nom)
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	if premier.demande then
		GameTooltip:SetText("Déjà demandé")
		GameTooltip:AddLine("Tu as déjà demandé ce don à " .. nom .. ". Tu peux le remercier depuis l'onglet Dons.", 1, 1, 1, true)
	else
		GameTooltip:SetText("Demander ce don à " .. nom)
		GameTooltip:AddLine(premier.enLigne and ("Un message privé part vers " .. nom .. ".")
			or (nom .. " est hors ligne : ta demande lui sera transmise dès que possible, par un membre de la guilde connecté avec SMB Forever, ou quand vous serez connectés en même temps."),
			1, 1, 1, true)
	end
	if #d.donneurs > 1 then
		local noms = {}
		for i, x in ipairs(d.donneurs) do
			noms[#noms + 1] = NomJoueur(x.e.nom) .. (x.enLigne and (" " .. VERT .. "(en ligne)|r") or "")
			if i >= 6 then break end
		end
		GameTooltip:AddLine("Donné par : " .. table.concat(noms, ", "), C.gris[1], C.gris[2], C.gris[3], true)
	end
	GameTooltip:Show()
end

local function CreerLigneMienne(parent)
	local r = CreerLigne(parent, "Retirer", "fantome", function(self, bulle)
		local premier = self.d and self.d.donneurs and self.d.donneurs[1]
		if premier then
			bulle:AddLine("Donné par " .. NomJoueur(premier.e.nom) .. (#self.d.donneurs > 1 and (" et " .. (#self.d.donneurs - 1) .. " autre(s)") or ""),
				C.vert[1], C.vert[2], C.vert[3])
		end
	end)
	r.bouton:SetScript("OnClick", function() if r.d then Retirer(r.d.objet) end end)
	r.demander = UI.Bouton(r, "Demander", "or", 80, 24)
	r.demander:SetPoint("RIGHT", r.bouton, "LEFT", -6, 0)
	if r.demander.SetMotionScriptsWhileDisabled then r.demander:SetMotionScriptsWhileDisabled(true) end
	r.demander:SetScript("OnClick", function()
		local premier = r.d and r.d.donneurs and r.d.donneurs[1]
		if premier and not premier.demande and ns.DemanderDon then ns.DemanderDon(premier) end
	end)
	r.demander:SetScript("OnEnter", InfobulleDemander)
	r.demander:SetScript("OnLeave", function() GameTooltip:Hide() end)
	r.demander:Hide()
	return r
end

local function Remplir(r, objet)
	local nom, _, qualite, icone = InfoObjet(objet)
	if not nom then
		nom, qualite = NomListe(objet)
		Precharger(objet)
	end
	r.objet = objet
	r.icone:Poser(icone, qualite)
	EcrireNomObjet(r.nom, nom, qualite)
end

local function MajChoix()
	if not page then return end
	local z = page.ajout
	if choix then
		local nom, _, qualite, icone = InfoObjet(choix)
		if not nom then nom, qualite = NomListe(choix) end
		z.case:Poser(icone, qualite)
		-- le nom choisi s'écrit dans la recherche (sans relancer la recherche)
		z.cherche:Ecrire(nom or ("Objet " .. choix))
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		if qc then z.cherche.saisie:SetTextColor(qc.r, qc.g, qc.b) else z.cherche.saisie:SetTextColor(unpack(C.texte)) end
	else
		z.case:Poser(CASE_VIDE, nil, true)
		z.cherche.saisie:SetTextColor(unpack(C.texte))
	end
	z.ajouter:Activer(choix ~= nil)
end

local function Choisir(objet)
	choix = objet
	if objet then Precharger(objet) end
	if not objet and page then page.ajout.cherche:Ecrire("") end
	MajChoix()
end

local function MajPage()
	if not page then return end
	MajChoix()

	-- mes besoins (ceux qu'un membre donne d'abord)
	local donneurs = ns.DonneursParObjet and ns.DonneursParObjet() or {}
	local liste = {}
	for objet, qte in pairs(MesBesoins()) do
		liste[#liste + 1] = { objet = objet, qte = qte, nom = (InfoObjet(objet)) or "", donneurs = donneurs[objet] or {} }
	end
	table.sort(liste, function(x, y)
		local dx, dy = #x.donneurs > 0, #y.donneurs > 0
		if dx ~= dy then return dx end
		return x.nom < y.nom
	end)
	local mes = page.mes
	local y = 0
	for i, d in ipairs(liste) do
		local r = mes.lignes[i]
		if not r then r = CreerLigneMienne(mes.liste.contenu); mes.lignes[i] = r end
		r.d = d
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", mes.liste.contenu, "TOPLEFT", 0, -y)
		r:SetPoint("RIGHT", mes.liste.contenu, "RIGHT", 0, 0)
		Remplir(r, d.objet)
		-- donné par un membre : « donné par X » et Demander (au premier à qui je ne l'ai pas demandé)
		local premier = d.donneurs[1]
		if premier then
			local autres = #d.donneurs - 1
			r.sous:SetText(TexteQte(d.qte, true) .. " · " .. VERT .. "donné par " .. NomJoueur(premier.e.nom)
				.. (autres > 0 and (" +" .. autres) or "") .. "|r")
			r.demander:Ecrire(premier.demande and "Demandé" or "Demander")
			r.demander:Activer(not premier.demande)
		else
			r.sous:SetText(d.qte == 0 and "Quantité : sans limite" or ("Quantité : " .. d.qte))
		end
		r.demander:SetShown(premier ~= nil)
		local droite = premier and r.demander or r.bouton
		r.nom:SetPoint("RIGHT", droite, "LEFT", -8, 0)
		r.sous:SetPoint("RIGHT", droite, "LEFT", -8, 0)
		r:Fort(premier ~= nil)
		if premier then r:SetBackdropBorderColor(C.vert[1], C.vert[2], C.vert[3], 0.55) end
		r:Show()
		y = y + HAUTEUR_LIGNE + ECART_LIGNE
	end
	for i = #liste + 1, #mes.lignes do mes.lignes[i]:Hide() end
	mes.liste:Hauteur(y)
	mes.vide:SetShown(#liste == 0)
	mes.compte:SetText(#liste .. " / " .. MAX_BESOINS)

	-- besoins de la guilde : ce que j'ai dans mes sacs ou ma banque (je peux le donner), puis ce que je
	-- sais fabriquer, puis les membres en ligne
	local g = Guilde() or {}
	local tous = {}
	local limite = Maintenant() - OUBLI
	for cle, e in pairs(g) do
		if type(e) ~= "table" or (e.vu or 0) < limite then
			g[cle] = nil
		elseif DansLaGuilde(cle) and (TestSolo() or not cle:find("#test", 1, true)) then
			local enLigne = ns.EnLigneMembre and ns.EnLigneMembre(cle) or false
			for objet, qte in pairs(e.liste or {}) do
				local jai, lieu, donne
				if ns.ObjetDonnable then jai, lieu, donne = ns.ObjetDonnable(objet) end
				local fabrique = ns.JeSaisFabriquer and ns.JeSaisFabriquer(objet) or false
				tous[#tous + 1] = { cle = cle, e = e, objet = objet, qte = qte, enLigne = enLigne,
					fabrique = fabrique, jai = jai, lieu = lieu, donne = donne,
					rang = jai and 1 or fabrique and 2 or 3, nomO = (InfoObjet(objet)) or "" }
			end
		end
	end
	table.sort(tous, function(a, b)
		if a.rang ~= b.rang then return a.rang < b.rang end
		if a.enLigne ~= b.enLigne then return a.enLigne end
		if a.nomO ~= b.nomO then return a.nomO < b.nomO end
		return (a.e.nom or "") < (b.e.nom or "")
	end)
	local gu = page.guilde
	y = 0
	for i, d in ipairs(tous) do
		local r = gu.lignes[i]
		if not r then
			r = CreerLigne(gu.liste.contenu, "Chuchoter", "or", function(self, bulle)
				if self.d and self.d.jai then
					bulle:AddLine(("Tu en as %d (%s)%s"):format(self.d.jai, self.d.lieu or "sacs",
						self.d.donne and " : déjà dans tes dons" or " : tu peux le donner"), C.ors[1], C.ors[2], C.ors[3])
				end
				if self.d and self.d.fabrique then bulle:AddLine("Tu sais le fabriquer", C.vert[1], C.vert[2], C.vert[3]) end
			end)
			r.bouton:SetScript("OnClick", function() if r.d then UI.Chuchoter(r.d.cle, r.d.e.nom) end end)
			gu.lignes[i] = r
		end
		r.d = d
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", gu.liste.contenu, "TOPLEFT", 0, -y)
		r:SetPoint("RIGHT", gu.liste.contenu, "RIGHT", 0, 0)
		Remplir(r, d.objet)
		local etat = d.enLigne and (VERT .. "en ligne|r") or ("hors ligne · il y a " .. Depuis(d.e.vu))
		r.sous:SetText(("%s%s · %s%s%s"):format(NomMembreColore(d.cle, d.e.nom), TexteQte(d.qte) and (" (" .. TexteQte(d.qte) .. ")") or "",
			etat, d.jai and (" · " .. OR .. "tu en as " .. d.jai .. "|r") or "",
			d.fabrique and (" · " .. VERT .. "tu sais le fabriquer|r") or ""))
		r.bouton:Activer(d.enLigne)
		r:Fort(d.fabrique or d.jai ~= nil)
		r:Show()
		y = y + HAUTEUR_LIGNE + ECART_LIGNE
	end
	for i = #tous + 1, #gu.lignes do gu.lignes[i]:Hide() end
	gu.liste:Hauteur(y)
	gu.vide:SetShown(#tous == 0)
	gu.compte:SetText(#tous > 0 and tostring(#tous) or "")
end

-- Zone d'ajout : [case objet] [recherche dans tous les objets du jeu      x]
--                            Quantité [ 1 ]  [ ] Sans limite        [Ajouter]
local function CreerAjout(carte)
	local z = CreateFrame("Button", nil, carte)
	z:SetPoint("TOPLEFT", carte, "TOPLEFT", 14, -38)
	z:SetPoint("RIGHT", carte, "RIGHT", -14, 0)
	z:SetHeight(60)
	z.case = IconeObjet(z, 44, "Button")
	z.case:SetPoint("LEFT", z, "LEFT", 0, 0)

	-- recherche par nom (tout le jeu) : liste de résultats sous la zone de saisie
	local cherche = UI.Champ(z, 200, "Nom de l'objet, ou glisse-le ici", 26)
	cherche:SetPoint("TOPLEFT", z.case, "TOPRIGHT", 10, 8)
	cherche:SetPoint("RIGHT", z, "RIGHT", 0, 0)
	cherche.saisie:SetPoint("BOTTOMRIGHT", cherche, "BOTTOMRIGHT", -26, 0)
	z.cherche = cherche
	local croix = CreateFrame("Button", nil, cherche)
	croix:SetSize(20, 20)
	croix:SetPoint("RIGHT", cherche, "RIGHT", -4, 0)
	croix.texte = UI.Texte(croix, "GameFontNormal", C.gris)
	croix.texte:SetPoint("CENTER", 0, 1)
	croix.texte:SetText("x")
	UI.Survol(croix, 0.1)
	croix:Hide()

	local res = UI.Cadre(z, { 0.05, 0.043, 0.035, 0.98 }, C.bordFort)
	res:SetFrameStrata("DIALOG")
	res:SetPoint("TOPLEFT", cherche, "BOTTOMLEFT", 0, -2)
	res:SetPoint("TOPRIGHT", cherche, "BOTTOMRIGHT", 0, -2)
	res:Hide()
	res.lignes = {}
	for i = 1, MAX_RES do
		local l = CreateFrame("Button", nil, res)
		l:SetHeight(22)
		l:SetPoint("TOPLEFT", res, "TOPLEFT", 2, -2 - (i - 1) * 22)
		l:SetPoint("RIGHT", res, "RIGHT", -2, 0)
		UI.Survol(l, 0.08)
		l.icone = l:CreateTexture(nil, "ARTWORK")
		l.icone:SetSize(16, 16)
		l.icone:SetPoint("LEFT", l, "LEFT", 6, 0)
		l.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		l.texte = UI.Texte(l, "GameFontHighlightSmall")
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 6, 0)
		l.texte:SetPoint("RIGHT", l, "RIGHT", -4, 0)
		l.objet = false
		l:SetScript("OnClick", function(self)
			res:Hide()
			cherche.saisie:ClearFocus()
			Choisir(self.objet)
		end)
		InfobulleObjet(l)
		res.lignes[i] = l
	end
	local function Resultats()
		local liste = ChercherObjets(cherche:Lire(), MAX_RES)
		local fi = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
		for i, l in ipairs(res.lignes) do
			local o = liste[i]
			if o then
				l.objet = o[1]
				local okI, icone = false, nil
				if fi then okI, icone = pcall(fi, o[1]) end
				l.icone:SetTexture(okI and icone or ICONE_INCONNUE)
				local qc = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[o[2]]
				l.texte:SetText(o[3])
				if qc then l.texte:SetTextColor(qc.r, qc.g, qc.b) else l.texte:SetTextColor(unpack(C.texte)) end
				l:Show()
			else
				l:Hide()
			end
		end
		res:SetHeight(4 + math.max(1, #liste) * 22)
		res:SetShown(#liste > 0)
	end
	-- on tape un nom : l'objet choisi est oublié, les résultats suivent
	cherche.SurTexte = function()
		if choix then
			choix = nil
			MajChoix()
		end
		Resultats()
	end
	croix:SetScript("OnClick", function()
		res:Hide()
		cherche.saisie:ClearFocus()
		Choisir(nil)
	end)
	cherche.saisie:HookScript("OnTextChanged", function(self) croix:SetShown((self:GetText() or "") ~= "") end)
	-- Entrée : le premier résultat ; Échap ferme la liste
	cherche.saisie:SetScript("OnEnterPressed", function(self)
		local l = res.lignes[1]
		if res:IsShown() and l:IsShown() then l:Click() else self:ClearFocus() end
	end)
	cherche.saisie:HookScript("OnEscapePressed", function() res:Hide() end)
	cherche.saisie:HookScript("OnEditFocusLost", function()
		C_Timer.After(0.2, function() if not cherche.saisie:HasFocus() then res:Hide() end end)
	end)

	-- quantité, sans limite, ajouter
	local tq = UI.Texte(z, "GameFontNormalSmall", C.ors)
	tq:SetPoint("BOTTOMLEFT", z.case, "BOTTOMRIGHT", 10, -4)
	tq:SetText("Quantité")
	z.qte = UI.Champ(z, 46, nil, 24)
	z.qte:SetPoint("LEFT", tq, "RIGHT", 8, 0)
	z.qte.saisie:SetNumeric(true)
	z.qte.saisie:SetMaxLetters(3)
	z.qte:Ecrire("1")
	-- « Sans limite » : besoin permanent (quantité 0)
	z.infini = UI.Case(z, "Sans limite", function(oui)
		z.qte.saisie:SetEnabled(not oui)
		z.qte:SetAlpha(oui and 0.4 or 1)
	end)
	z.infini:SetPoint("LEFT", z.qte, "RIGHT", 10, 0)
	UI.Infobulle(z.infini, "Sans limite", "Besoin permanent : la guilde voit « sans limite » au lieu d'une quantité.")
	z.ajouter = UI.Bouton(z, "Ajouter", "or", 84, 26)
	z.ajouter:SetPoint("BOTTOMRIGHT", z, "BOTTOMRIGHT", 0, -2)
	z.ajouter:SetScript("OnClick", function()
		z.qte.saisie:ClearFocus()
		local qte = z.infini.oui and 0 or (tonumber(z.qte:Lire()) or 1)
		if Ajouter(choix, qte) then
			Choisir(nil)
			z.qte:Ecrire("1")
		end
	end)

	-- glisser un objet sur la case (ou cliquer avec un objet sur le curseur) ; clic droit : vider
	ns.BrancherDepot({ z, z.case }, function(o) res:Hide(); Choisir(o) end, function() return choix end)
	z.case:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if choix then
			pcall(GameTooltip.SetItemByID, GameTooltip, choix)
			GameTooltip:AddLine("Clic droit : retirer l'objet de la case", 0.6, 0.6, 0.6)
		else
			GameTooltip:SetText("Objet recherché")
			GameTooltip:AddLine("Cherche un objet par son nom à côté, ou glisse un objet de tes sacs ici.", 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	z.case:SetScript("OnLeave", function() GameTooltip:Hide() end)
	if ns.SonsSurBoutons then ns.SonsSurBoutons(z) end
	return z
end

-- Appelé par GuildUp_Echanges.lua à la création de la page « Dons » : contenu de l'onglet, qui
-- remplit parent (les onglets sont au-dessus) ; p.Maj() le rafraîchit
ns.CreerPageBesoins = function(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	local largeur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) - 2 * MARGE
	local demi = math.floor((largeur - 12) / 2)

	local aide = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	aide:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -56)
	aide:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	aide:SetWordWrap(true)
	aide:SetText("Liste les objets dont tu as besoin : la guilde les voit, même quand tu es hors ligne. Ceux qui savent les fabriquer sont prévenus, et toi quand un membre en met un en don.")

	-- gauche : mes besoins (zone d'ajout puis liste)
	local mes = UI.Carte(p, "Mes besoins")
	mes:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -84)
	mes:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", MARGE, 12)
	mes:SetWidth(demi)
	mes.lignes = {}
	p.mes = mes
	p.ajout = CreerAjout(mes)
	local filet = UI.Filet(mes)
	filet:SetPoint("TOPLEFT", mes, "TOPLEFT", 14, -108)
	filet:SetPoint("TOPRIGHT", mes, "TOPRIGHT", -14, -108)
	mes.liste = UI.Liste(mes)
	mes.liste:SetPoint("TOPLEFT", mes, "TOPLEFT", 12, -118)
	mes.liste:SetPoint("BOTTOMRIGHT", mes, "BOTTOMRIGHT", -6, 10)
	mes.vide:ClearAllPoints()
	mes.vide:SetPoint("TOPLEFT", mes.liste, "TOPLEFT", 2, -6)
	mes.vide:SetPoint("RIGHT", mes, "RIGHT", -14, 0)
	mes.vide:SetText("Aucun besoin pour l'instant.")

	-- droite : besoins de la guilde
	local gu = UI.Carte(p, "Besoins de la guilde")
	gu:SetPoint("TOPLEFT", mes, "TOPRIGHT", 12, 0)
	gu:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, 12)
	gu.lignes = {}
	p.guilde = gu
	gu.liste = UI.Liste(gu)
	gu.liste:SetPoint("TOPLEFT", gu, "TOPLEFT", 12, -38)
	gu.liste:SetPoint("BOTTOMRIGHT", gu, "BOTTOMRIGHT", -6, 10)
	gu.vide:SetText("Personne n'a listé de besoin pour l'instant.")

	p.Maj = MajPage
	page = p
	return p
end


--------------------------------------------------------------------------------
-- Infobulle des objets : « Miko a besoin de cette ressource (x5) »
--------------------------------------------------------------------------------

local function LignesBesoin(tooltip, objet)
	if not objet or not tooltip or not tooltip.AddLine then return end
	local g = Guilde()
	if not g then return end
	local qui = {}
	for cle, e in pairs(g) do
		local q = type(e) == "table" and e.liste and e.liste[objet]
		if q and DansLaGuilde(cle) and (TestSolo() or not cle:find("#test", 1, true)) then
			qui[#qui + 1] = NomJoueur(e.nom) .. (TexteQte(q) and (" (" .. TexteQte(q) .. ")") or "")
		end
	end
	if #qui == 0 then return end
	table.sort(qui)
	local texte
	if #qui == 1 then
		texte = qui[1] .. " a besoin de cette ressource"
	elseif #qui <= 3 then
		texte = table.concat(qui, ", ") .. " en ont besoin"
	else
		texte = ("%s, %s et %d autres en ont besoin"):format(qui[1], qui[2], #qui - 2)
	end
	tooltip:AddLine("|TInterface\\Icons\\INV_Misc_Note_01:0|t " .. texte, 0.25, 1, 0.45, true)
	tooltip:Show()
end

local function ObjetDeBulle(tooltip, data)
	if data and data.id then return tonumber(data.id) end
	if tooltip and tooltip.GetItem then
		local _, lien = tooltip:GetItem()
		return lien and tonumber(lien:match("item:(%d+)"))
	end
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	-- API récente : toutes les infobulles d'objet du jeu (sacs, liens, butin, hôtel des ventes…)
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		if tooltip == GameTooltip or tooltip == ItemRefTooltip or tooltip == ShoppingTooltip1 then
			pcall(LignesBesoin, tooltip, ObjetDeBulle(tooltip, data))
		end
	end)
else
	for _, bulle in ipairs({ GameTooltip, ItemRefTooltip }) do
		if bulle and bulle.HookScript then
			pcall(bulle.HookScript, bulle, "OnTooltipSetItem", function(self)
				pcall(LignesBesoin, self, ObjetDeBulle(self))
			end)
		end
	end
end

-- Ouvre la page « Dons » sur l'onglet « Besoins »
ns.OuvrirBesoins = function()
	if ns.OuvrirEchanges then ns.OuvrirEchanges(nil, 4) end
end

ns.DiagBesoins = function(L)
	local n, m = 0, 0
	for _ in pairs(MesBesoins()) do n = n + 1 end
	for _, e in pairs(Guilde() or {}) do
		if type(e) == "table" then for _ in pairs(e.liste or {}) do m = m + 1 end end
	end
	L(("besoins : %d à moi, %d de la guilde (gardés hors ligne)"):format(n, m))
end

--------------------------------------------------------------------------------
-- Évènements (le rafraîchissement de la page sur GET_ITEM_INFO_RECEIVED et GUILD_ROSTER_UPDATE est
-- fait par GuildUp_Echanges.lua, pour toute la page « Dons »)
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
pcall(ev.RegisterEvent, ev, "PLAYER_ENTERING_WORLD")
local premiere = true
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		debut = GetTime()
		-- purge : listes de besoins sans nouvelles depuis 30 jours (toutes guildes)
		pcall(function()
			local guildes = Racine().guildes
			local limite = Maintenant() - OUBLI
			for _, g in pairs(guildes) do
				if type(g) == "table" then
					for cle, e in pairs(g) do
						if type(e) ~= "table" or (e.vu or 0) < limite then g[cle] = nil end
					end
				end
			end
		end)
		C_Timer.After(20, function()
			pret = true
			if next(MesBesoins()) then EnvoyerMaListe() end
			Envoyer("Q")
		end)
	end
end)

-- Pour l'accueil de la fenêtre GuildUpSMB : besoins des autres membres que je sais fabriquer
-- { cle, nom, objet, qte, enLigne }, les membres en ligne d'abord (mêmes filtres que la liste)
ns.BesoinsQueJeSaisFabriquer = function()
	local res = {}
	if not ns.JeSaisFabriquer then return res end
	local limite = Maintenant() - OUBLI
	for cle, e in pairs(Guilde() or {}) do
		if type(e) == "table" and (e.vu or 0) >= limite and DansLaGuilde(cle)
			and (TestSolo() or not cle:find("#test", 1, true)) then
			local enLigne = ns.EnLigneMembre and ns.EnLigneMembre(cle) or false
			for objet, qte in pairs(e.liste or {}) do
				if ns.JeSaisFabriquer(objet) then
					res[#res + 1] = { cle = cle, nom = e.nom, objet = objet, qte = qte, enLigne = enLigne }
				end
			end
		end
	end
	table.sort(res, function(a, b)
		if a.enLigne ~= b.enLigne then return a.enLigne end
		return (a.nom or "") < (b.nom or "")
	end)
	return res
end
