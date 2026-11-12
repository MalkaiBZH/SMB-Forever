-- GuildUp : besoins (onglet « Besoins » de la fenêtre Artisanat & Échanges).
-- Chaque joueur liste les objets dont il a besoin (avec une quantité). La liste part à la guilde
-- (préfixe "GuildUpBes") et chacun la garde (GuildUpDB) : elle reste visible même quand son
-- auteur est hors ligne.
--   "B~objet:qte,objet:qte,…"   ma liste complète (vide = plus aucun besoin ; qte 0 = sans limite)
--   "Q"                          « renvoyez vos listes » (à la connexion)
-- Bulle « Besoin dans la guilde » pour ceux qui savent fabriquer l'objet demandé.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpBes"
local MAX_BESOINS = 20
local CALME = 25
local OUBLI = 30 * 86400      -- une liste sans nouvelles depuis 30 jours est oubliée

local debut = GetTime()
local pret = false
local Maj

local function Normaliser(nom) return ns.Normaliser and ns.Normaliser(nom) or nom end
local function MaCle() return Normaliser(UnitName("player")) end
local function TestSolo() return ns.TestSolo and ns.TestSolo() end
local function NomCourt(nom) return ((nom or "?"):gsub("%-", " "):gsub(" %(test%)$", "")) end
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local function Erreur(t) if ns.Erreur then ns.Erreur(t) end end
local function AtlasExiste(a) return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(a) ~= nil end

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

local function InfoObjet(objet)
	local f = GetItemInfo or (C_Item and C_Item.GetItemInfo)
	local nom, lien, qualite, icone
	if f then
		local ok, n, l, q, _, _, _, _, _, _, i = pcall(f, objet)
		if ok then nom, lien, qualite, icone = n, l, q, i end
	end
	if not icone then
		local fi = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
		if fi then
			local ok, _, _, _, _, i = pcall(fi, objet)
			if ok then icone = i end
		end
	end
	return nom, lien, qualite, icone
end

local function Precharger(objet)
	if C_Item and C_Item.RequestLoadItemDataByID then pcall(C_Item.RequestLoadItemDataByID, objet) end
end

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
	if Maj then Maj() end
	return true
end

-- Pour la fiche encyclopédie du carnet
ns.AjouterBesoin = function(objet, qte) return Ajouter(objet, qte) end

local function Retirer(objet)
	MesBesoins()[objet] = nil
	EnvoyerMaListe()
	if Maj then Maj() end
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function AlerteBesoin(nom, objet, qte)
	if not ns.Alerte then return end
	local nomO, lien = InfoObjet(objet)
	ns.Alerte("Besoin dans la guilde", ("%s cherche %s%s — tu sais le fabriquer"):format(NomCourt(nom),
		lien or nomO or ("l'objet " .. objet), TexteQte(qte) and (" " .. TexteQte(qte)) or ""), nil,
		function() if ns.OuvrirBesoins then ns.OuvrirBesoins() end end)
end

-- Relais : à la connexion d'un membre (son « Q »), un membre en ligne lui renvoie aussi les listes
-- des absents qu'il a gardées. Chaque liste porte sa date (heure du serveur) : on garde la plus
-- récente. Une liste vide reste notée (pour qu'un besoin retiré disparaisse aussi chez les autres).
--   "V~cle~date~objet36:qte,…"  liste d'un autre membre, renvoyée
local function Maintenant() return GetServerTime and GetServerTime() or time() end
local relayees = {}   -- [cle] = moment où une liste de ce membre est passée (envoyée ou reçue)

local function B36(n)
	local c, t = "0123456789abcdefghijklmnopqrstuvwxyz", ""
	n = math.floor(n)
	repeat
		local r = n % 36
		t = c:sub(r + 1, r + 1) .. t
		n = math.floor(n / 36)
	until n == 0
	return t
end

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
		for cle, e in pairs(g) do
			if type(e) == "table" and cle ~= pour and not cle:find("#test", 1, true)
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
			C_Timer.After(1 + math.random() * 4, EnvoyerMaListe)
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
		if Maj then Maj() end
	elseif genre == "V" then
		local qui, date, mots = reste:match("^([^~]+)~(%d+)~?(.*)$")
		date = tonumber(date)
		if not qui or not date or qui == MaCle() then return end
		relayees[qui] = GetTime()
		local g = Guilde()
		if not g then return end
		local liste = {}
		for o, q in (mots or ""):gmatch("(%w+):(%d+)") do
			o, q = tonumber(o, 36), tonumber(q)
			if o and q and q >= 0 then liste[o] = q; Precharger(o) end
		end
		local nomQui = (g[qui] and g[qui].nom) or qui
		if Enregistrer(g, qui, nomQui, liste, date) and Maj then Maj() end
	end
end

--------------------------------------------------------------------------------
-- Page « Besoins »
--------------------------------------------------------------------------------

local page
local lignesMes, lignesGuilde = {}, {}
local choix                    -- objet choisi dans la zone d'ajout

--------------------------------------------------------------------------------
-- Recherche d'un objet par son nom dans tout le jeu (GuildUp_Objets.lua), même sans l'avoir
--------------------------------------------------------------------------------

local ACCENTS = { ["à"] = "a", ["â"] = "a", ["ä"] = "a", ["ç"] = "c", ["é"] = "e", ["è"] = "e", ["ê"] = "e",
	["ë"] = "e", ["î"] = "i", ["ï"] = "i", ["ô"] = "o", ["ö"] = "o", ["ù"] = "u", ["û"] = "u", ["ü"] = "u",
	["À"] = "a", ["Â"] = "a", ["Ç"] = "c", ["É"] = "e", ["È"] = "e", ["Ê"] = "e", ["Î"] = "i", ["Ô"] = "o",
	["Û"] = "u", ["œ"] = "oe", ["Œ"] = "oe" }
local function Simplifier(s)
	return ((s or ""):gsub("[\195\197][\128-\191]", ACCENTS):gsub("’", " "):gsub("'", " "):lower())
end

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

local function Depuis(t)
	local s = time() - (t or time())
	if s < 3600 then return math.max(1, math.floor(s / 60)) .. " min" end
	if s < 86400 then return math.floor(s / 3600) .. " h" end
	return math.floor(s / 86400) .. " j"
end

local function LigneBase(parent, largeur)
	local b = CreateFrame("Frame", nil, parent)
	b:SetSize(largeur, 38)
	b:EnableMouse(true)
	local fond = b:CreateTexture(nil, "BACKGROUND")
	fond:SetAllPoints(b)
	fond:SetColorTexture(0, 0, 0, 0.25)
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(30, 30)
	b.icone:SetPoint("LEFT", b, "LEFT", 4, 0)
	b.nom = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b.icone, "TOPRIGHT", 6, -1)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.sous = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.sous:SetPoint("BOTTOMLEFT", b.icone, "BOTTOMRIGHT", 6, 1)
	b.sous:SetJustifyH("LEFT")
	b.sous:SetWordWrap(false)
	b.bouton = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.bouton:SetSize(82, 22)
	b.bouton:SetPoint("RIGHT", b, "RIGHT", -4, 0)
	b.nom:SetPoint("RIGHT", b.bouton, "LEFT", -6, 0)
	b.sous:SetPoint("RIGHT", b.bouton, "LEFT", -6, 0)
	b:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	if ns.SonsSurBoutons then ns.SonsSurBoutons(b) end
	return b
end

local function Remplir(b, objet)
	local nom, _, qualite, icone = InfoObjet(objet)
	b.objet = objet
	b.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
	b.nom:SetText(nom or "|cff999999chargement…|r")
	local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
	if qc and nom then b.nom:SetTextColor(qc.r, qc.g, qc.b) else b.nom:SetTextColor(1, 0.82, 0) end
end

-- Membre encore dans la guilde ? (liste de guilde chargée : sinon on garde)
local function DansLaGuilde(cle)
	if cle:find("#test", 1, true) then return true end
	if ns.MembreGuilde then return ns.MembreGuilde(cle) ~= false end
	return true
end

-- nom d'un objet d'après la liste du jeu (quand il n'est pas encore en cache)
local function NomListe(objet)
	for _, o in ipairs(Index()) do if o[1] == objet then return o[3], o[2] end end
end
-- Pour la page Items du carnet : la liste de tous les objets échangeables, et un nom de secours
ns.IndexObjets = Index
ns.NomObjetListe = function(objet) return (NomListe(objet)) end

local function MajChoix()
	if not page then return end
	local z = page.ajout
	if choix then
		local nom, _, qualite, icone = InfoObjet(choix)
		if not icone then
			local fi = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
			if fi then local ok, i = pcall(fi, choix); if ok then icone = i end end
		end
		if not nom then nom, qualite = NomListe(choix) end
		z.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
		z.icone:SetDesaturated(false)
		-- le nom choisi s'écrit dans la recherche (sans relancer la recherche)
		z.ecriture = true
		z.cherche:SetText(nom or ("Objet " .. choix))
		z.ecriture = false
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		if qc then z.cherche:SetTextColor(qc.r, qc.g, qc.b) else z.cherche:SetTextColor(1, 1, 1) end
	else
		z.icone:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
		z.icone:SetDesaturated(true)
		z.cherche:SetTextColor(1, 1, 1)
	end
	z.ajouter:SetEnabled(choix ~= nil)
end

local function Choisir(objet)
	choix = objet
	if objet then Precharger(objet) end
	if not objet and page and page.ajout and page.ajout.cherche then
		page.ajout.ecriture = true
		page.ajout.cherche:SetText("")
		page.ajout.ecriture = false
	end
	MajChoix()
end

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

Maj = function()
	if ns.MajOngletsEchanges then ns.MajOngletsEchanges() end
	if not page or not page:IsShown() then return end
	MajChoix()

	-- mes besoins
	local liste = {}
	for objet, qte in pairs(MesBesoins()) do
		liste[#liste + 1] = { objet = objet, qte = qte, nom = (InfoObjet(objet)) or "" }
	end
	table.sort(liste, function(x, y) return x.nom < y.nom end)
	local y = 0
	for i, d in ipairs(liste) do
		local b = lignesMes[i] or LigneBase(page.contenuG, page.largeurG)
		lignesMes[i] = b
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", page.contenuG, "TOPLEFT", 0, -y)
		Remplir(b, d.objet)
		b.sous:SetText(d.qte == 0 and "Quantité : sans limite" or ("Quantité : " .. d.qte))
		b.bouton:SetText("Retirer")
		b.bouton:SetEnabled(true)
		b.bouton:SetScript("OnClick", function() Retirer(d.objet) end)
		b:Show()
		y = y + 42
	end
	for i = #liste + 1, #lignesMes do lignesMes[i]:Hide() end
	page.contenuG:SetHeight(math.max(10, y))
	page.videG:SetShown(#liste == 0)

	-- besoins de la guilde : ce que je sais fabriquer d'abord, puis les membres en ligne
	local g = Guilde() or {}
	local tous = {}
	local limite = time() - OUBLI
	for cle, e in pairs(g) do
		if type(e) ~= "table" or (e.vu or 0) < limite then
			g[cle] = nil
		elseif DansLaGuilde(cle) and (TestSolo() or not cle:find("#test", 1, true)) then
			local enLigne = ns.EnLigneMembre and ns.EnLigneMembre(cle) or false
			for objet, qte in pairs(e.liste or {}) do
				tous[#tous + 1] = { cle = cle, e = e, objet = objet, qte = qte, enLigne = enLigne,
					fabrique = ns.JeSaisFabriquer and ns.JeSaisFabriquer(objet) or false,
					nomO = (InfoObjet(objet)) or "" }
			end
		end
	end
	table.sort(tous, function(a, b)
		if a.fabrique ~= b.fabrique then return a.fabrique end
		if a.enLigne ~= b.enLigne then return a.enLigne end
		if a.nomO ~= b.nomO then return a.nomO < b.nomO end
		return (a.e.nom or "") < (b.e.nom or "")
	end)
	y = 0
	for i, d in ipairs(tous) do
		local b = lignesGuilde[i] or LigneBase(page.contenuD, page.largeurD)
		lignesGuilde[i] = b
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", page.contenuD, "TOPLEFT", 0, -y)
		Remplir(b, d.objet)
		local etat = d.enLigne and "|cff33dd55en ligne|r" or ("|cff999999hors ligne · il y a " .. Depuis(d.e.vu) .. "|r")
		b.sous:SetText(("%s%s · %s%s"):format(NomCourt(d.e.nom), TexteQte(d.qte) and (" (" .. TexteQte(d.qte) .. ")") or "", etat,
			d.fabrique and "  |cff33dd55· tu sais le fabriquer|r" or ""))
		b.bouton:SetText("Chuchoter")
		b.bouton:SetEnabled(d.enLigne and true or false)
		b.bouton:SetScript("OnClick", function()
			local nomMP = (ns.NomListeGuilde and ns.NomListeGuilde(d.cle)) or NomCourt(d.e.nom)
			if d.cle:find("#test", 1, true) then nomMP = UnitName("player") end
			if ChatFrame_SendTell then ChatFrame_SendTell(nomMP)
			elseif ChatFrame_OpenChat then ChatFrame_OpenChat("/w " .. nomMP .. " ") end
		end)
		b:Show()
		y = y + 42
	end
	for i = #tous + 1, #lignesGuilde do lignesGuilde[i]:Hide() end
	page.contenuD:SetHeight(math.max(10, y))
	page.videD:SetShown(#tous == 0)
end

-- Appelé par GuildUp_Echanges.lua à la création de la fenêtre
ns.CreerPageBesoins = function(f, hautEncart)
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	local largeur = f:GetWidth()
	local milieu = math.floor(largeur / 2)
	p.largeurG = milieu - 46
	p.largeurD = largeur - milieu - 46

	local titre = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", f, "TOPLEFT", 70, -34)
	titre:SetText("Besoins")
	local aide = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	aide:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	aide:SetWidth(largeur - 90)
	aide:SetJustifyH("LEFT")
	aide:SetText("Liste les objets dont tu as besoin : la guilde les voit, même quand tu es hors ligne. Ceux qui savent les fabriquer sont prévenus.")

	local function Colonne(x, l, texte, decalage)
		local fond = p:CreateTexture(nil, "BACKGROUND")
		fond:SetPoint("TOPLEFT", f, "TOPLEFT", x - 4, hautEncart - 4)
		fond:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x - 4, 12)
		fond:SetWidth(l + 36)
		if AtlasExiste("Professions-background-summarylist") then
			fond:SetAtlas("Professions-background-summarylist")
		else
			fond:SetColorTexture(0, 0, 0, 0.25)
		end
		local t = p:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		t:SetPoint("TOPLEFT", f, "TOPLEFT", x + 2, hautEncart - 10)
		t:SetText(texte)
		local defile = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
		defile:SetPoint("TOPLEFT", f, "TOPLEFT", x, hautEncart - 30 - (decalage or 0))
		defile:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", x, 16)
		defile:SetWidth(l)
		local contenu = CreateFrame("Frame", nil, defile)
		contenu:SetSize(l, 10)
		defile:SetScrollChild(contenu)
		local vide = p:CreateFontString(nil, "OVERLAY", "GameFontDisable")
		vide:SetPoint("TOP", defile, "TOP", 0, -30)
		vide:SetWidth(l - 20)
		return contenu, vide
	end
	p.contenuG, p.videG = Colonne(14, p.largeurG, "Mes besoins", 70)
	p.videG:SetText("Aucun besoin pour l'instant.")
	p.contenuD, p.videD = Colonne(milieu + 14, p.largeurD, "Besoins de la guilde")
	p.videD:SetText("Personne n'a listé de besoin pour l'instant.")

	-- zone d'ajout : [case objet] nom de l'objet / Quantité [ 1 ] [Ajouter]
	local z = CreateFrame("Button", nil, p)
	z:SetSize(p.largeurG, 64)
	z:SetPoint("TOPLEFT", f, "TOPLEFT", 14, hautEncart - 30)
	p.ajout = z
	local cadre = z:CreateTexture(nil, "BACKGROUND")
	cadre:SetAllPoints(z)
	cadre:SetColorTexture(0, 0, 0, 0.35)
	z.case = CreateFrame("Button", nil, z)
	z.case:SetSize(36, 36)
	z.case:SetPoint("LEFT", z, "LEFT", 6, 0)
	z.icone = z.case:CreateTexture(nil, "ARTWORK")
	z.icone:SetAllPoints(z.case)
	z.case:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	-- recherche par nom (tout le jeu) : liste de résultats sous la zone de saisie
	local okC, cherche = pcall(CreateFrame, "EditBox", "GuildUpBesoinsCherche", z, "SearchBoxTemplate")
	if not okC then cherche = CreateFrame("EditBox", "GuildUpBesoinsCherche", z, "InputBoxTemplate") end
	cherche:SetHeight(20)
	cherche:SetPoint("TOPLEFT", z.case, "TOPRIGHT", 12, 0)
	cherche:SetPoint("RIGHT", z, "RIGHT", -8, 0)
	cherche:SetAutoFocus(false)
	if cherche.Instructions then cherche.Instructions:SetText("Nom de l'objet, ou glisse-le ici") end
	z.cherche = cherche
	local res = CreateFrame("Frame", nil, z, "BackdropTemplate")
	res:SetFrameStrata("DIALOG")
	res:SetPoint("TOPLEFT", cherche, "BOTTOMLEFT", -4, -2)
	res:SetPoint("TOPRIGHT", cherche, "BOTTOMRIGHT", 0, -2)
	if res.SetBackdrop then
		res:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
			insets = { left = 3, right = 3, top = 3, bottom = 3 } })
		res:SetBackdropColor(0.05, 0.05, 0.05, 0.97)
	end
	res:Hide()
	res.lignes = {}
	local MAX_RES = 10
	for i = 1, MAX_RES do
		local l = CreateFrame("Button", nil, res)
		l:SetHeight(20)
		l:SetPoint("TOPLEFT", res, "TOPLEFT", 6, -5 - (i - 1) * 20)
		l:SetPoint("RIGHT", res, "RIGHT", -6, 0)
		l:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		l.icone = l:CreateTexture(nil, "ARTWORK")
		l.icone:SetSize(16, 16)
		l.icone:SetPoint("LEFT", l, "LEFT", 2, 0)
		l.texte = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 6, 0)
		l.texte:SetPoint("RIGHT", l, "RIGHT", -2, 0)
		l.texte:SetJustifyH("LEFT")
		l.texte:SetWordWrap(false)
		l:SetScript("OnClick", function(self)
			res:Hide()
			cherche:ClearFocus()
			Choisir(self.objet)
		end)
		l:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
			GameTooltip:Show()
		end)
		l:SetScript("OnLeave", function() GameTooltip:Hide() end)
		res.lignes[i] = l
	end
	local function Resultats()
		local liste = ChercherObjets(cherche:GetText(), MAX_RES)
		local fi = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
		for i, l in ipairs(res.lignes) do
			local o = liste[i]
			if o then
				l.objet = o[1]
				local okI, icone = false, nil
				if fi then okI, icone = pcall(fi, o[1]) end
				l.icone:SetTexture(okI and icone or "Interface\\Icons\\INV_Misc_QuestionMark")
				local qc = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[o[2]]
				l.texte:SetText(o[3])
				if qc then l.texte:SetTextColor(qc.r, qc.g, qc.b) else l.texte:SetTextColor(1, 1, 1) end
				l:Show()
			else
				l:Hide()
			end
		end
		res:SetHeight(10 + math.max(1, #liste) * 20)
		res:SetShown(#liste > 0)
	end
	cherche:HookScript("OnTextChanged", function(self, saisie)
		if z.ecriture then return end
		if not saisie and self:GetText() == "" then
			-- croix de la recherche : on vide aussi l'objet choisi
			res:Hide()
			if choix then Choisir(nil) end
			return
		end
		if saisie and choix then
			-- on retape un nom : l'objet choisi est oublié
			choix = nil
			z.icone:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
			z.icone:SetDesaturated(true)
			self:SetTextColor(1, 1, 1)
			z.ajouter:SetEnabled(false)
		end
		if saisie then Resultats() end
	end)
	cherche:HookScript("OnEnterPressed", function(self)
		-- Entrée : le premier résultat
		local l = res.lignes[1]
		if res:IsShown() and l:IsShown() then l:Click() else self:ClearFocus() end
	end)
	cherche:HookScript("OnEscapePressed", function(self) res:Hide(); self:ClearFocus() end)
	cherche:HookScript("OnEditFocusLost", function()
		C_Timer.After(0.2, function() if not cherche:HasFocus() then res:Hide() end end)
	end)
	z.nom = z:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall") -- (plus affiché)
	z.nom:Hide()
	local tq = z:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	tq:SetPoint("BOTTOMLEFT", z.case, "BOTTOMRIGHT", 8, 0)
	tq:SetText("Quantité")
	z.qte = CreateFrame("EditBox", nil, z, "InputBoxTemplate")
	z.qte:SetSize(40, 18)
	z.qte:SetPoint("LEFT", tq, "RIGHT", 10, 0)
	z.qte:SetAutoFocus(false)
	z.qte:SetNumeric(true)
	z.qte:SetMaxLetters(3)
	z.qte:SetText("1")
	z.qte:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	z.ajouter = CreateFrame("Button", nil, z, "UIPanelButtonTemplate")
	z.ajouter:SetSize(80, 22)
	z.ajouter:SetPoint("BOTTOMRIGHT", z, "BOTTOMRIGHT", -6, 6)
	z.ajouter:SetText("Ajouter")
	z.ajouter:SetScript("OnClick", function()
		z.qte:ClearFocus()
		local qte = z.infini:GetChecked() and 0 or (tonumber(z.qte:GetText()) or 1)
		if Ajouter(choix, qte) then
			Choisir(nil)
			z.ecriture = true
			z.cherche:SetText("")
			z.ecriture = false
			z.qte:SetText("1")
		end
	end)
	-- « Sans limite » : besoin permanent (quantité 0)
	z.infini = CreateFrame("CheckButton", nil, z, "UICheckButtonTemplate")
	z.infini:SetSize(20, 20)
	z.infini:SetPoint("LEFT", z.qte, "RIGHT", 8, 0)
	local ti = z.infini.Text or z.infini.text
	if not ti then
		ti = z.infini:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		ti:SetPoint("LEFT", z.infini, "RIGHT", 1, 0)
	end
	ti:SetFontObject("GameFontHighlightSmall")
	ti:SetText("Sans limite")
	z.infini:SetScript("OnClick", function(self)
		local oui = self:GetChecked() and true or false
		z.qte:SetEnabled(not oui)
		z.qte:SetAlpha(oui and 0.4 or 1)
	end)
	z.infini:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Sans limite")
		GameTooltip:AddLine("Besoin permanent : la guilde voit « sans limite » au lieu d'une quantité.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	z.infini:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- glisser un objet sur la case (ou cliquer avec un objet sur le curseur)
	local function Deposer()
		local genre, objet = GetCursorInfo()
		if genre == "item" and objet then
			Choisir(tonumber(objet))
			ClearCursor()
			return true
		end
	end
	for _, cible in ipairs({ z, z.case }) do
		cible:SetScript("OnReceiveDrag", Deposer)
		cible:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		cible:SetScript("OnClick", function(_, bouton)
			-- clic droit : retire l'objet de la case ; clic gauche : dépose l'objet tenu (ou vide la case)
			if bouton == "RightButton" then
				if choix then Choisir(nil) end
				GameTooltip:Hide()
				return
			end
			if not Deposer() and choix then Choisir(nil) end
		end)
	end
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

	p:SetScript("OnShow", function() Maj() end)
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
			qui[#qui + 1] = NomCourt(e.nom) .. (TexteQte(q) and (" (" .. TexteQte(q) .. ")") or "")
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

-- Ouvre la fenêtre Échanges sur l'onglet « Besoins »
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
-- Évènements
--------------------------------------------------------------------------------

do
	local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
	if inscription then pcall(inscription, PREFIXE) end
end

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "CHAT_MSG_ADDON", "PLAYER_ENTERING_WORLD", "GET_ITEM_INFO_RECEIVED", "GUILD_ROSTER_UPDATE" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local premiere, prevu = true, false
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "CHAT_MSG_ADDON" then
		Recevoir(a1, a2, a3, a4)
	elseif event == "GET_ITEM_INFO_RECEIVED" or event == "GUILD_ROSTER_UPDATE" then
		if page and page:IsShown() and not prevu then
			prevu = true
			C_Timer.After(0.3, function() prevu = false; if Maj then Maj() end end)
		end
	elseif event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		debut = GetTime()
		C_Timer.After(20, function()
			pret = true
			if next(MesBesoins()) then EnvoyerMaListe() end
			Envoyer("Q")
		end)
	end
end)
