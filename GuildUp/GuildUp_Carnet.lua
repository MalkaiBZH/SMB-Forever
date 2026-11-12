-- GuildUp : fenêtre « Artisanat » (onglets Registre, Items et Projets) et carnet de craft.
-- Le carnet : on choisit des recettes et des quantités ; la « Liste de courses » (fenêtre à part)
-- calcule tout ce qu'il faut, sous-recettes comprises, compare avec les sacs et la banque, et dit
-- d'où viennent les composants et qui, dans la guilde, sait les fabriquer.
-- Données : GuildUp_Craft.lua (recettes du client Forever) et GuildUp_Sources.lua (sources tirées
-- une fois de QuestieDB). Rien ne dépend d'un autre addon.

local NOM_ADDON, ns = ...

local LARGEUR_LISTE_COURSES, HAUTEUR_LISTE_COURSES = 420, 540
local LARGEUR_GAUCHE = 260   -- colonne « Mes carnets », à gauche de la liste, dans la même fenêtre
local LARGEUR_FICHE, HAUTEUR_FICHE = 340, 450
local HAUT_CONTENU = -92   -- haut de la zone de contenu, sous la bande de pierre
local PROFONDEUR_MAX = 6

local Erreur = ns.Erreur
local NomCourt = ns.NomCourt
-- « niv. 12-18 » (ou « niv. 12 ») d'un PNJ, rien si inconnu
local function TexteNiveaux(p)
	if not (p.min and p.min > 0) then return "" end
	if p.max and p.max ~= p.min then return " niv. " .. p.min .. "-" .. p.max end
	return " niv. " .. p.min
end
local Simplifier = ns.Simplifier
local AtlasExiste = ns.AtlasExiste
local PoserAtlas = ns.PoserAtlas

--------------------------------------------------------------------------------
-- Données : recettes et sources
--------------------------------------------------------------------------------

local recettes        -- [sort] = { sort, metier, niveau, objet, rendement, composants = { {objet, n}, … } }
local parObjet        -- [objet] = { recette, … } (recettes qui fabriquent cet objet)
local formuleSort     -- [objet formule] = recette qu'elle apprend
local parCompo        -- [composant] = { recette, … } (recettes qui l'utilisent)
local enCycle         -- [objet] = true : fabriqué dans une boucle de recettes (transmutations d'essences…)

-- Boucles de recettes (composantes fortement connexes du graphe objet -> composants, algorithme de
-- Tarjan) : ces objets se transmutent les uns en les autres (Feu <- Air <- Eau <- Terre <- Feu…).
-- Ils ne sont jamais développés automatiquement : ils restent des matériaux de base.
local function CalculerCycles()
	enCycle = {}
	local index, bas, pile, surPile, n = {}, {}, {}, {}, 0
	local function Visiter(v)
		n = n + 1
		index[v], bas[v] = n, n
		pile[#pile + 1] = v
		surPile[v] = true
		for _, r in ipairs(parObjet[v] or {}) do
			for _, c in ipairs(r.composants) do
				local w = c[1]
				-- une recette qui utilise son propre objet (recharge, réparation) n'est pas une boucle
				if w ~= v and parObjet[w] then
					if not index[w] then
						Visiter(w)
						bas[v] = math.min(bas[v], bas[w])
					elseif surPile[w] then
						bas[v] = math.min(bas[v], index[w])
					end
				end
			end
		end
		if bas[v] == index[v] then
			local membres = {}
			repeat
				local w = table.remove(pile)
				surPile[w] = nil
				membres[#membres + 1] = w
			until w == v
			if #membres > 1 then
				for _, w in ipairs(membres) do enCycle[w] = true end
			end
		end
	end
	for v in pairs(parObjet) do
		if not index[v] then Visiter(v) end
	end
end

local function Recettes()
	if recettes then return recettes end
	recettes, parObjet, parCompo = {}, {}, {}
	for sort, metier, niveau, objet, rend, compos in (ns.DONNEES_CRAFT or ""):gmatch("(%d+):(%a+):(%d+):(%d+):(%d+):([^\n]*)") do
		local r = { sort = tonumber(sort), metier = metier, niveau = tonumber(niveau), objet = tonumber(objet),
			rendement = math.max(1, tonumber(rend) or 1), composants = {} }
		for o, n in compos:gmatch("(%d+)x(%d+)") do
			o = tonumber(o)
			r.composants[#r.composants + 1] = { o, tonumber(n) }
			parCompo[o] = parCompo[o] or {}
			table.insert(parCompo[o], r)
		end
		recettes[r.sort] = r
		if r.objet > 0 then
			parObjet[r.objet] = parObjet[r.objet] or {}
			table.insert(parObjet[r.objet], r)
		end
	end
	for _, l in pairs(parObjet) do table.sort(l, function(a, b) return a.niveau < b.niveau end) end
	ns.DONNEES_CRAFT = nil
	CalculerCycles()
	-- formules / recettes / plans : l'objet qui apprend chaque recette
	formuleSort = {}
	for o, s in (ns.DONNEES_FORMULES or ""):gmatch("(%d+)=(%d+)") do
		o, s = tonumber(o), tonumber(s)
		local r = recettes[s]
		if r then
			formuleSort[o] = r
			r.formules = r.formules or {}
			table.insert(r.formules, o)
		end
	end
	ns.DONNEES_FORMULES = nil
	return recettes
end
local function RecettesDe(objet) Recettes(); return parObjet[objet] end
-- Recette à suivre pour fabriquer un objet dans un calcul automatique (liste de courses, projets) :
-- aucune pour un objet en boucle de transmutation ; sinon la première qui n'utilise pas l'objet lui-même
local function RecetteADevelopper(objet)
	Recettes()
	if enCycle[objet] then return nil end
	for _, r in ipairs(parObjet[objet] or {}) do
		local soiMeme = false
		for _, c in ipairs(r.composants) do
			if c[1] == objet then soiMeme = true; break end
		end
		if not soiMeme then return r end
	end
end
local function UtilisationsDe(objet) Recettes(); return parCompo[objet] end
-- recette apprise par une formule (objet), ou nil
local function RecetteDeFormule(objet) Recettes(); return formuleSort[objet] end

local sources         -- { objets = { [id] = {...} }, pnj = {}, recolte = {}, zones = {}, quetes = {} }
-- Table lue à la demande : chaque entrée n'est analysée qu'au premier accès (sources[id]), en
-- cherchant sa ligne « id|… » dans le texte brut. Analyser les ~30 000 lignes d'un coup gelait le jeu
-- et créait ~85 000 tables. (Pas de pairs() sur ces tables : seules les entrées lues y sont.)
local function TablePresseuse(brut, construire)
	brut = "\n" .. (brut or "")
	local cache = {}
	return setmetatable({}, { __index = function(_, id)
		if type(id) ~= "number" then return nil end
		local v = cache[id]
		if v == nil then
			v = false
			local debut = brut:find("\n" .. id .. "|", 1, true)
			if debut then
				local fin = brut:find("\n", debut + 1, true) or (#brut + 1)
				v = construire(brut:sub(debut + 1, fin - 1)) or false
			end
			cache[id] = v
		end
		return v or nil
	end, __brut = brut })
end

local function Sources()
	if sources then return sources end
	sources = { zones = {}, quetes = {} }
	local VIDE = {} -- liste vide partagée (jamais modifiée)
	local function ids(t)
		if not t or t == "" then return VIDE end
		local l = {}
		for x in t:gmatch("%d+") do l[#l + 1] = tonumber(x) end
		return l
	end
	local function Points(t)
		local l = {}
		for x, y in (t or ""):gmatch("([%d%.]+),([%d%.]+)") do l[#l + 1] = { tonumber(x), tonumber(y) } end
		return l
	end
	sources.objets = TablePresseuse(ns.SOURCES_OBJETS, function(ligne)
		local _, m, b, nb, r, c, q = ligne:match("^(%d+)|([^|]*)|([^|]*)|(%d*)|([^|]*)|([^|]*)|(.*)$")
		if not m then return nil end
		return { marchands = ids(m), butin = ids(b), nbButin = tonumber(nb) or 0,
			recolte = ids(r), contenants = ids(c), quetes = ids(q) }
	end)
	sources.pnj = TablePresseuse(ns.SOURCES_PNJ, function(ligne)
		local id, nom, mi, ma, z, fa, pos, sous, rang = ligne:match("^(%d+)|([^|]*)|(%d*)|(%d*)|(%d*)|([^|]*)|([^|]*)|([^|]*)|?(%d*)$")
		if not id then return nil end
		local pts = Points(pos)
		return { id = tonumber(id), nom = nom, min = tonumber(mi), max = tonumber(ma), zone = tonumber(z),
			faction = fa ~= "" and fa or nil, points = pts, x = pts[1] and pts[1][1], y = pts[1] and pts[1][2],
			sous = sous ~= "" and sous or nil, rang = tonumber(rang) or 0 }
	end)
	sources.recolte = TablePresseuse(ns.SOURCES_RECOLTE, function(ligne)
		local _, nom, zs = ligne:match("^(%d+)|([^|]*)|(.*)$")
		if not nom then return nil end
		local l, pts = {}, {}
		for bloc in zs:gmatch("[^#]+") do
			local z, _, p = bloc:match("^(%d+):(%d*):?(.*)$")
			if z then
				l[#l + 1] = tonumber(z)
				pts[tonumber(z)] = Points(p)
			end
		end
		return { nom = nom, zones = l, points = pts }
	end)
	for id, nom, carte in (ns.SOURCES_ZONES or ""):gmatch("(%d+)|([^|]*)|(%d*)") do
		sources.zones[tonumber(id)] = { nom = nom, carte = tonumber(carte) }
	end
	for id, nom in (ns.SOURCES_QUETES or ""):gmatch("(%d+)|([^\n]*)") do sources.quetes[tonumber(id)] = nom end
	ns.SOURCES_OBJETS, ns.SOURCES_PNJ, ns.SOURCES_RECOLTE, ns.SOURCES_ZONES, ns.SOURCES_QUETES = nil, nil, nil, nil, nil
	return sources
end

-- Rang d'une créature : dragon doré (élite), étiquette pour les rares et les boss
local ICONE_ELITE = "|TInterface\\Tooltips\\EliteNameplateIcon:14:14:0:0|t"
local function MarqueRang(rang)
	if rang == 1 then return ICONE_ELITE .. "|cffffd100Élite|r "
	elseif rang == 2 then return ICONE_ELITE .. "|cffc0c0ffRare élite|r "
	elseif rang == 3 then return "|cffff4040[Boss]|r "
	elseif rang == 4 then return "|cffc0c0ff[Rare]|r "
	end
	return ""
end

local InfoObjet = ns.InfoObjet
local function ClasseObjet(objet)
	local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not f then return nil end
	local ok, _, _, _, _, _, classe, sousClasse = pcall(f, objet)
	if ok then return classe, sousClasse end
end
local function NomSort(sort)
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, t = pcall(C_Spell.GetSpellInfo, sort)
		if ok and type(t) == "table" then return t.name, t.iconID end
	end
	if GetSpellInfo then
		local ok, nom, _, icone = pcall(GetSpellInfo, sort)
		if ok then return nom, icone end
	end
end
local Precharger = ns.Precharger
-- Banque : le jeu ne la connaît qu'une fois ouverte. Son contenu est gardé à chaque visite
-- (db.banquePerso[perso]) pour les sessions suivantes ; nil = jamais vue sur ce personnage.
local banqueOuverte = false
local function ClePerso() return ns.Normaliser and ns.Normaliser(UnitName("player")) end
local function BanqueGardee()
	local db = ns.DB and ns.DB()
	local cle = ClePerso()
	if not (db and cle and type(db.banquePerso) == "table") then return nil end
	return db.banquePerso[cle]
end
local function NoterBanque()
	if not (ns.LireConteneur and ns.SacsDeBanque) then return end
	local db = ns.DB and ns.DB()
	local cle = ClePerso()
	if not (db and cle) then return end
	local t = {}
	for _, sac in ipairs(ns.SacsDeBanque()) do ns.LireConteneur(sac, t, true) end
	if type(db.banquePerso) ~= "table" then db.banquePerso = {} end
	db.banquePerso[cle] = t
end
-- Où sont mes objets : sacs, banque (nil = banque inconnue : jamais ouverte sur ce personnage)
local function OuSont(objet)
	local f = (C_Item and C_Item.GetItemCount) or GetItemCount
	if not f then return 0, nil end
	local ok1, sacs = pcall(f, objet)
	local ok2, tout = pcall(f, objet, true)
	sacs = ok1 and sacs or 0
	local enDirect = math.max(0, (ok2 and tout or sacs) - sacs)
	if banqueOuverte then return sacs, enDirect end
	local gardee = BanqueGardee()
	if not gardee then return sacs, enDirect > 0 and enDirect or nil end
	return sacs, math.max(enDirect, gardee[objet] or 0)
end
local function JAi(objet)
	local sacs, banque = OuSont(objet)
	return sacs + (banque or 0)
end
local function NomMetier(code) return ns.NomMetierCode and ns.NomMetierCode(code) or code end
local function NomZone(z)
	local e = z and Sources().zones[z]
	if e then return e.nom end
	if z and C_Map and C_Map.GetAreaInfo then
		local ok, n = pcall(C_Map.GetAreaInfo, z)
		if ok and n then return n end
	end
	return nil
end

-- Indication par type d'objet quand on ne connaît pas de source précise
local ETOFFES = {
	[2589] = "humanoïdes niv. 5 à 20", [2592] = "humanoïdes niv. 15 à 30", [4306] = "humanoïdes niv. 25 à 45",
	[4338] = "humanoïdes niv. 35 à 55", [14047] = "humanoïdes niv. 50 à 60", [14256] = "démons niv. 50 à 60",
}
local function IndicationType(objet)
	if ETOFFES[objet] then return "Butin : " .. ETOFFES[objet] end
	local classe, sous = ClasseObjet(objet)
	if classe ~= 7 then return nil end
	if sous == 5 then return "Butin des humanoïdes" end
	if sous == 6 then return "Dépeçage (bêtes)" end
	if sous == 7 then return "Minage, ou fabriqué (fonte)" end
	if sous == 8 then return "Butin des bêtes, ou pêche" end
	if sous == 9 then return "Herboristerie" end
	if sous == 10 then return "Butin des élémentaires" end
	if sous == 12 then return "Désenchantement" end
	return nil
end


--------------------------------------------------------------------------------
-- Listes (sauvegardées) : db.carnets = { [nom] = { entrees = { {objet, qte} ou {sort, qte} },
-- obtenir = { [objet] = true } } } — une entrée est un objet (fabriqué ou non) ; {sort} = ancienne
-- entrée « recette » (encore lue)
--------------------------------------------------------------------------------

local function Carnets()
	local db = ns.DB and ns.DB() or {}
	if type(db.carnets) ~= "table" then db.carnets = {} end
	if not next(db.carnets) then db.carnets["Mon carnet"] = { entrees = {}, obtenir = {} } end
	if not db.carnetChoisi or not db.carnets[db.carnetChoisi] then db.carnetChoisi = next(db.carnets) end
	return db.carnets, db
end
local function Carnet()
	local c, db = Carnets()
	local k = c[db.carnetChoisi]
	k.entrees = k.entrees or {}
	k.obtenir = k.obtenir or {}
	return k, db.carnetChoisi
end

local MajCarnet, MajCourses

-- Ajoute un objet à une liste (nom : liste existante ou nouvelle ; par défaut la liste choisie)
local function AjouterObjet(objet, qte, nomListe)
	local c, db = Carnets()
	nomListe = nomListe or db.carnetChoisi
	c[nomListe] = c[nomListe] or { entrees = {}, obtenir = {} }
	local k = c[nomListe]
	k.entrees = k.entrees or {}
	db.carnetChoisi = nomListe
	for _, e in ipairs(k.entrees) do
		if e.objet == objet then e.qte = e.qte + (qte or 1); MajCarnet(); MajCourses(); return end
	end
	k.entrees[#k.entrees + 1] = { objet = objet, qte = qte or 1 }
	MajCarnet()
	MajCourses()
end
local function AjouterRecette(sort, qte)
	local r = Recettes()[sort]
	if r and r.objet > 0 then return AjouterObjet(r.objet, qte) end
	local k = Carnet()
	k.entrees[#k.entrees + 1] = { sort = sort, qte = qte or 1 }
	MajCarnet()
	MajCourses()
end

--------------------------------------------------------------------------------
-- Cadre commun des fenêtres du carnet : cadre à portrait du jeu, bande de pierre sous le titre,
-- fond de la zone de contenu (images des métiers du jeu)
--------------------------------------------------------------------------------

local function CadrePortrait(nom, titre, largeur, hauteur, icone, fond)
	local ok, f = pcall(CreateFrame, "Frame", nom, UIParent, "PortraitFrameTemplate")
	if not ok then
		ok, f = pcall(CreateFrame, "Frame", nom, UIParent, "BasicFrameTemplateWithInset")
		if not ok then f = CreateFrame("Frame", nom, UIParent) end
	end
	f:SetSize(largeur, hauteur)
	f:SetFrameStrata("HIGH")
	f:SetToplevel(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	tinsert(UISpecialFrames, nom)
	if f.SetTitle then pcall(f.SetTitle, f, titre)
	elseif f.TitleText then f.TitleText:SetText(titre) end
	if f.SetPortraitToAsset and icone then pcall(f.SetPortraitToAsset, f, icone) end
	f.pierre = f:CreateTexture(nil, "BACKGROUND", nil, -5)
	PoserAtlas(f.pierre, "groupfinder-Stat-StoneBG", { 0.12, 0.1, 0.08, 1 })
	f.pierre:ClearAllPoints()
	f.pierre:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -21)
	f.pierre:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -2, HAUT_CONTENU)
	f.fond = f:CreateTexture(nil, "BACKGROUND", nil, -4)
	-- fond uni sombre (les images de fond des métiers ont un vignettage clair qui se voyait)
	f.fond:SetColorTexture(0.06, 0.05, 0.045, 1)
	f.fond:ClearAllPoints()
	f.fond:SetPoint("TOPLEFT", f, "TOPLEFT", 4, HAUT_CONTENU)
	f.fond:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 4)
	f.filet = f:CreateTexture(nil, "ARTWORK")
	-- une vraie ligne dorée de 1 px (l'image « groupfinder-ScrollLine » est un grand dégradé : il débordait)
	f.filet:SetColorTexture(1, 0.82, 0, 0.45)
	f.filet:SetHeight(1)
	f.filet:SetPoint("LEFT", f, "TOPLEFT", 4, HAUT_CONTENU)
	f.filet:SetPoint("RIGHT", f, "TOPRIGHT", -4, HAUT_CONTENU)
	if ns.AvecSons then ns.AvecSons(f, "fenetre") end
	f:Hide()
	return f
end

-- Barre de progression façon métiers du jeu
local function BarreMetier(parent, largeur)
	local b = CreateFrame("StatusBar", nil, parent)
	b:SetSize(largeur, 12)
	b:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	b:SetStatusBarColor(0.26, 0.62, 0.18)
	local fondB = b:CreateTexture(nil, "BACKGROUND")
	fondB:SetAllPoints(b)
	if not PoserAtlas(fondB, "Professions-skillbar-bg") then fondB:SetColorTexture(0, 0, 0, 0.6) end
	local contour = b:CreateTexture(nil, "OVERLAY")
	contour:SetPoint("TOPLEFT", b, "TOPLEFT", -3, 3)
	contour:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 3, -3)
	if not PoserAtlas(contour, "Professions-skillbar-frame") then contour:Hide() end
	b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.texte:SetPoint("CENTER", b, "CENTER", 0, 0)
	return b
end

-- Cadre autour d'une section (Fabriqué, Marchands… / Recettes, Matériaux de base)
local function CadreSection(pool, parent, i)
	local c = pool[i]
	if not c then
		c = CreateFrame("Frame", nil, parent, "BackdropTemplate")
		if c.SetBackdrop then
			c:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
				insets = { left = 3, right = 3, top = 3, bottom = 3 } })
			c:SetBackdropColor(0, 0, 0, 0.35)
			c:SetBackdropBorderColor(1, 0.82, 0, 0.55)
		end
		c:EnableMouse(false)
		pool[i] = c
	end
	c:SetFrameLevel(parent:GetFrameLevel())
	c:Show()
	return c
end

-- En-tête de section (bande dorée, icône, texte)
local function StylerTitre(l, actif)
	if not l.bande then
		l.bande = l:CreateTexture(nil, "BACKGROUND", nil, 1)
		l.bande:SetAllPoints(l)
		l.bande:SetColorTexture(1, 0.82, 0, 0.16)
		l.trait = l:CreateTexture(nil, "BORDER")
		l.trait:SetHeight(1)
		l.trait:SetPoint("BOTTOMLEFT", l, "BOTTOMLEFT", 0, 0)
		l.trait:SetPoint("BOTTOMRIGHT", l, "BOTTOMRIGHT", 0, 0)
		l.trait:SetColorTexture(1, 0.82, 0, 0.45)
	end
	l.bande:SetShown(actif)
	l.trait:SetShown(actif)
end

--------------------------------------------------------------------------------
-- Calcul : arbre des composants et matériaux de base
--------------------------------------------------------------------------------

-- Contexte d'un calcul : stock restant partagé par toutes les branches (un objet en stock ne sert
-- qu'une fois, et le surplus d'une fabrication à rendement > 1 profite aux autres branches) et
-- objets « à obtenir tels quels » (non développés).
--   avecMesObjets : le stock part de mes sacs + banque (liste de courses) ; sinon de zéro (projets)
local function NouveauContexte(avecMesObjets, obtenir)
	local ctx = { obtenir = obtenir or {}, dispo = avecMesObjets and JAi or function() return 0 end }
	ctx.stock = setmetatable({}, { __index = function(t, objet)
		local v = ctx.dispo(objet)
		rawset(t, objet, v)
		return v
	end })
	return ctx
end

-- noeud = { objet, besoin, jai, manque, recette, fabrications, enfants, cycle }
-- chemin : objets en cours de développement au-dessus de ce noeud (garde-fou contre les boucles)
local function Developper(objet, besoin, ctx, profondeur, chemin)
	local n = { objet = objet, besoin = besoin, jai = ctx.dispo(objet) }
	local pris = math.min(ctx.stock[objet], besoin)
	ctx.stock[objet] = ctx.stock[objet] - pris
	n.manque = besoin - pris
	local recs = RecettesDe(objet)
	n.fabricable = recs ~= nil
	local r = RecetteADevelopper(objet)
	n.cycle = recs ~= nil and r == nil
	if r and not ctx.obtenir[objet] and n.manque > 0 and profondeur < PROFONDEUR_MAX and not chemin[objet] then
		n.recette = r
		n.fabrications = math.ceil(n.manque / r.rendement)
		-- surplus de la fabrication : disponible pour les autres branches
		ctx.stock[objet] = ctx.stock[objet] + n.fabrications * r.rendement - n.manque
		n.enfants = {}
		chemin[objet] = true
		for _, c in ipairs(r.composants) do
			n.enfants[#n.enfants + 1] = Developper(c[1], c[2] * n.fabrications, ctx, profondeur + 1, chemin)
		end
		chemin[objet] = nil
	end
	return n
end

local CalculerSansMemoire
local memoireCalcul, imageCalcul -- résultat du dernier calcul et moment (GetTime : un par image)
local function Calculer()
	-- plusieurs affichages (liste, mini-liste, carnets) le demandent dans la même image : un seul calcul
	if memoireCalcul and imageCalcul == GetTime() then return memoireCalcul[1], memoireCalcul[2] end
	local arbres, base = CalculerSansMemoire()
	memoireCalcul, imageCalcul = { arbres, base }, GetTime()
	return arbres, base
end
CalculerSansMemoire = function()
	Recettes()
	local k = Carnet()
	local arbres, base = {}, {}
	local ctx = NouveauContexte(true, k.obtenir)
	for _, e in ipairs(k.entrees) do
		local r = e.sort and recettes[e.sort]
		if not r and e.objet then
			local recs = RecettesDe(e.objet)
			r = recs and recs[1]
		end
		if r then
			-- objet fabriqué : quantité voulue = objets ; fabrications arrondies
			local fab = math.ceil(e.qte / r.rendement)
			local racine = { recette = r, objet = r.objet, besoin = e.qte, fabrications = fab, enfants = {}, racine = true,
				entree = e }
			for _, c in ipairs(r.composants) do
				racine.enfants[#racine.enfants + 1] = Developper(c[1], c[2] * fab, ctx, 1, { [r.objet] = true })
			end
			arbres[#arbres + 1] = racine
		elseif e.objet then
			-- objet qui ne se fabrique pas : il va directement dans les matériaux de base
			arbres[#arbres + 1] = { objet = e.objet, besoin = e.qte, enfants = {}, racine = true, entree = e,
				jai = JAi(e.objet) }
			base[e.objet] = (base[e.objet] or 0) + e.qte
		end
	end
	-- matériaux de base : les feuilles (composants non fabriqués, ou à obtenir tels quels)
	local function Cumuler(n)
		if n.enfants and not n.racine then
			for _, c in ipairs(n.enfants) do Cumuler(c) end
		elseif n.racine then
			for _, c in ipairs(n.enfants) do Cumuler(c) end
		else
			base[n.objet] = (base[n.objet] or 0) + n.besoin
		end
	end
	for _, a in ipairs(arbres) do Cumuler(a) end
	return arbres, base
end

--------------------------------------------------------------------------------
-- Fenêtre « Liste de courses »
--------------------------------------------------------------------------------

local courses
local lignes = {}
local replies = {}   -- [chemin] = true : noeuds repliés dans l'affichage

local function InfobulleObjet(self)
	if not self.objet then return end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
	GameTooltip:AddLine(" ")
	local sacs, banque = OuSont(self.objet)
	GameTooltip:AddLine("|cffffd100Tu en as|r :", 1, 1, 1)
	GameTooltip:AddLine(("  - %d dans tes sacs"):format(sacs), 1, 1, 1)
	if banque then
		GameTooltip:AddLine(("  - %d à la banque"):format(banque), 1, 1, 1)
	else
		GameTooltip:AddLine("  - banque inconnue (ouvre-la une fois)", 0.6, 0.6, 0.6)
	end
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("Clic : fiche (d'où ça vient, qui le fabrique)", 0.6, 0.6, 0.6)
	if self.noeud and self.noeud.fabricable and not self.noeud.racine then
		GameTooltip:AddLine(Carnet().obtenir[self.objet] and "Clic droit ou +/- : le fabriquer (déplier)"
			or "Clic droit ou +/- : l'obtenir tel quel (ne pas déplier)", 0.6, 0.6, 0.6)
	end
	GameTooltip:Show()
end

local function CreerLigne(parent)
	local l = CreateFrame("Button", nil, parent)
	l:SetSize(LARGEUR_LISTE_COURSES - 44, 22)
	l.fond = l:CreateTexture(nil, "BACKGROUND")
	l.fond:SetAllPoints(l)
	l.fond:SetColorTexture(1, 1, 1, 0.04)
	l:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	l.fleche = l:CreateTexture(nil, "ARTWORK")
	l.fleche:SetSize(12, 12)
	-- la flèche +/- bascule entre « le fabriquer » et « l'obtenir tel quel »
	l.basculer = CreateFrame("Button", nil, l)
	l.basculer:SetPoint("TOPLEFT", l.fleche, "TOPLEFT", -3, 3)
	l.basculer:SetPoint("BOTTOMRIGHT", l.fleche, "BOTTOMRIGHT", 3, -3)
	l.basculer:SetScript("OnClick", function()
		local n = l.noeud
		if not n or n.racine or not n.fabricable then return end
		local o = Carnet().obtenir
		o[l.objet] = not o[l.objet] or nil
		MajCourses()
	end)
	l.basculer:Hide()
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetSize(18, 18)
	l.liseret = l:CreateTexture(nil, "BORDER")
	l.liseret:SetPoint("TOPLEFT", l, "TOPLEFT", 0, 0)
	l.liseret:SetPoint("BOTTOMLEFT", l, "BOTTOMLEFT", 0, 0)
	l.liseret:SetWidth(3)
	l.liseret:SetColorTexture(1, 0.82, 0, 0.9)
	l.liseret:Hide()
	l.texte = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	l.texte:SetJustifyH("LEFT")
	l.texte:SetWordWrap(false)
	l.compte = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	l.compte:SetPoint("RIGHT", l, "RIGHT", -4, 0)
	l.compte:SetJustifyH("RIGHT")
	-- objets de la liste (racines) : quantité modifiable et bouton de retrait
	l.retirer = CreateFrame("Button", nil, l, "UIPanelCloseButton")
	l.retirer:SetSize(20, 20)
	l.retirer:SetPoint("RIGHT", l, "RIGHT", 0, 0)
	l.retirer:Hide()
	l.qte = CreateFrame("EditBox", nil, l, "InputBoxTemplate")
	l.qte:SetSize(34, 16)
	l.qte:SetPoint("RIGHT", l.retirer, "LEFT", -2, 0)
	l.qte:SetAutoFocus(false)
	l.qte:SetNumeric(true)
	l.qte:SetMaxLetters(4)
	l.qte:SetJustifyH("CENTER")
	l.qte:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	l.qte:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	l.qte:Hide()
	l.texte:SetPoint("RIGHT", l.compte, "LEFT", -6, 0)
	l:SetScript("OnEnter", InfobulleObjet)
	l:SetScript("OnLeave", function() GameTooltip:Hide() end)
	l:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	l:SetScript("OnClick", function(self, bouton)
		local n = self.noeud
		if not n then return end
		if IsModifiedClick and IsModifiedClick("CHATLINK") then
			local _, lien = InfoObjet(self.objet)
			if lien and ChatEdit_InsertLink then ChatEdit_InsertLink(lien) end
			return
		end
		if bouton == "RightButton" then
			if n.racine or not n.fabricable then return end
			local o = Carnet().obtenir
			o[self.objet] = not o[self.objet] or nil
			MajCourses()
			return
		end
		if ns.OuvrirFiche then ns.OuvrirFiche(self.objet, n.racine and n.besoin or n.manque) end
	end)
	return l
end


MajCourses = function()
	if ns.MajMini then ns.MajMini() end
	if not courses or not courses:IsShown() then return end
	if ns.MajCarnets then ns.MajCarnets() end
	local arbres, base = Calculer()
	local k, nomCarnet = Carnet()
	courses.titreCarnet:SetText(nomCarnet)
	local y, i = 4, 0
	local contenu = courses.contenu
	local nCadres, debutSection = 0, nil
	courses.cadres = courses.cadres or {}
	local function FermerSection()
		if not debutSection then return end
		nCadres = nCadres + 1
		local c = CadreSection(courses.cadres, contenu, nCadres)
		c:ClearAllPoints()
		c:SetPoint("TOPLEFT", contenu, "TOPLEFT", 0, -(debutSection - 4))
		c:SetSize(contenu:GetWidth(), y - debutSection + 8)
		debutSection = nil
		y = y + 12
	end
	local retraitCadre = 0     -- marge intérieure quand on dessine dans le cadre d'une recette
	local nCadresR = 0
	courses.cadresRecette = courses.cadresRecette or {}
	local function Ligne(h)
		h = h or 23
		i = i + 1
		local l = lignes[i] or CreerLigne(contenu)
		lignes[i] = l
		l:SetFrameLevel(contenu:GetFrameLevel() + 3)
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", contenu, "TOPLEFT", 4 + retraitCadre, -y)
		l:SetWidth(contenu:GetWidth() - 8 - 2 * retraitCadre)
		l:SetHeight(h)
		l.qte:Hide()
		l.retirer:Hide()
		l.liseret:Hide()
		l.texte:SetAlpha(1)
		l:Show()
		y = y + h
		return l
	end
	local function Titre(texte, icone)
		FermerSection()
		debutSection = y
		local l = Ligne()
		l.noeud, l.objet = nil, nil
		l.fleche:Hide(); l.basculer:Hide()
		l.fond:SetColorTexture(0, 0, 0, 0)
		StylerTitre(l, true)
		local x = 6
		if icone then
			l.icone:ClearAllPoints()
			l.icone:SetPoint("LEFT", l, "LEFT", 6, 0)
			l.icone:SetTexture(icone)
			l.icone:Show()
			x = 28
		else
			l.icone:Hide()
		end
		l.texte:ClearAllPoints()
		l.texte:SetPoint("LEFT", l, "LEFT", x, 0)
		l.texte:SetPoint("RIGHT", l.compte, "LEFT", -6, 0)
		l.texte:SetFontObject("GameFontHighlightSmall")
		l.compte:SetFontObject("GameFontHighlightSmall")
		l.icone:SetSize(18, 18)
		l.texte:SetText("|cffffd100" .. texte .. "|r")
		l.compte:SetText("")
	end
	-- 1 recette principale (grande, liseré doré), 2 sous-recette fabriquée (moyenne),
	-- 3 composant (petit, plus discret) ; « base » : liste des matériaux de base
	local STYLES = {
		[1] = { h = 30, icone = 24, police = "GameFontNormal", compte = "GameFontNormal", fond = { 1, 1, 1, 0 } },
		[2] = { h = 24, icone = 18, police = "GameFontHighlight", compte = "GameFontHighlightSmall", fond = { 1, 1, 1, 0.07 } },
		[3] = { h = 20, icone = 14, police = "GameFontHighlightSmall", compte = "GameFontHighlightSmall", fond = { 1, 1, 1, 0 }, alpha = 0.85 },
		base = { h = 23, icone = 18, police = "GameFontHighlight", compte = "GameFontHighlightSmall", fond = { 1, 1, 1, 0.04 } },
	}
	local function Noeud(n, prof, chemin)
		local niveau = n.base and "base" or n.racine and 1 or (n.fabricable and n.enfants) and 2 or 3
		local st = STYLES[niveau]
		local l = Ligne(st.h)
		StylerTitre(l, false)
		l.noeud, l.objet = n, n.objet
		l.fond:SetColorTexture(st.fond[1], st.fond[2], st.fond[3], st.fond[4])
		l.liseret:Hide()
		l.icone:SetSize(st.icone, st.icone)
		l.texte:SetFontObject(st.police)
		l.compte:SetFontObject(st.compte)
		l.texte:SetAlpha(st.alpha or 1)
		local x = 4 + prof * 16
		l.fleche:ClearAllPoints()
		l.fleche:SetPoint("LEFT", l, "LEFT", x, 0)
		local deplie = n.enfants and #n.enfants > 0 and not replies[chemin]
		if n.fabricable and not n.racine then
			l.fleche:SetTexture(n.enfants and "Interface\\Buttons\\UI-MinusButton-Up" or "Interface\\Buttons\\UI-PlusButton-Up")
			l.fleche:Show(); l.basculer:Show()
		else
			l.fleche:Hide(); l.basculer:Hide()
		end
		l.icone:ClearAllPoints()
		l.icone:SetPoint("LEFT", l, "LEFT", x + (n.racine and 6 or 14), 0)
		local nom, _, qualite, icone = InfoObjet(n.objet)
		if not nom and n.recette then nom, icone = NomSort(n.recette.sort) end
		if not nom and n.objet then nom = ns.NomObjetListe and ns.NomObjetListe(n.objet) end
		if not nom then Precharger(n.objet) end
		l.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
		l.icone:Show()
		l.texte:ClearAllPoints()
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 5, 0)
		l.texte:SetPoint("RIGHT", l.compte, "LEFT", -6, 0)
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		local couleur = qc and qc.hex or "|cffffffff"
		local suffixe = ""
		if n.racine and not n.recette then
			suffixe = "  |cff999999(à obtenir)|r"
		elseif n.racine then
			suffixe = ("  |cff999999%s %d · %d fabrication%s|r"):format(NomMetier(n.recette.metier), n.recette.niveau,
				n.fabrications, n.fabrications > 1 and "s" or "")
		elseif n.fabricable and n.enfants then
			suffixe = ("  |cff999999(%d fabrication%s)|r"):format(n.fabrications, n.fabrications > 1 and "s" or "")
		elseif n.fabricable then
			suffixe = "  |cff999999(à obtenir)|r"
		end
		-- où sont ceux que j'ai déjà : sacs / banque
		if not n.racine and (n.jai or 0) > 0 then
			local sacs, banque = OuSont(n.objet)
			if (banque or 0) > 0 then
				suffixe = suffixe .. ("  |cff999999(%s%d en banque)|r"):format(sacs > 0 and (sacs .. " en sacs, ") or "", banque)
			end
		end
		l.texte:SetText(couleur .. (nom or "chargement…") .. "|r" .. suffixe)
		if n.racine then
			-- quantité voulue (modifiable) et retrait de la liste
			l.compte:SetText("")
			l.qte:SetScript("OnTextChanged", nil)
			l.qte:SetText(tostring(n.besoin))
			l.qte:SetScript("OnTextChanged", function(self, saisie)
				if not saisie then return end
				local v = tonumber(self:GetText())
				if v and v > 0 and n.entree then
					n.entree.qte = v
					C_Timer.After(0.6, function() if not self:HasFocus() then MajCourses() end end)
				end
			end)
			l.qte:SetScript("OnEditFocusLost", function() MajCourses() end)
			l.qte:Show()
			l.retirer:SetScript("OnClick", function()
				local k = Carnet()
				for idx, e in ipairs(k.entrees) do
					if e == n.entree then table.remove(k.entrees, idx); break end
				end
				MajCourses()
				MajCarnet()
			end)
			l.retirer:Show()
			l.texte:SetPoint("RIGHT", l.qte, "LEFT", -6, 0)
		else
			local ok = n.jai >= n.besoin
			l.compte:SetText(("%s%d / %d|r"):format(ok and "|cff33dd55" or "|cffff9933", math.min(n.jai, n.besoin), n.besoin))
		end
		if deplie or n.racine then
			for j, c in ipairs(n.enfants or {}) do Noeud(c, prof + 1, chemin .. ">" .. j) end
		end
	end

	if #arbres == 0 then
		Titre("Ce carnet est vide : ajoute des recettes dans l'onglet Carnet.")
		courses.barre:SetMinMaxValues(0, 1)
		courses.barre:SetValue(0)
		courses.barre.texte:SetText("")
		courses.resume:SetText("Carnet vide")
	else
		-- matériaux de base d'abord (ce qu'il faut réunir), puis le détail des recettes
		local liste = {}
		for o, n in pairs(base) do
			local nom = InfoObjet(o)
			liste[#liste + 1] = { objet = o, besoin = n, jai = JAi(o), nom = nom or "" }
		end
		table.sort(liste, function(a, b)
			local fa, fb = a.jai >= a.besoin, b.jai >= b.besoin
			if fa ~= fb then return not fa end
			return a.nom < b.nom
		end)
		local reunis = 0
		for _, m in ipairs(liste) do if m.jai >= m.besoin then reunis = reunis + 1 end end
		Titre(("Matériaux de base — %d / %d réunis"):format(reunis, #liste), "Interface\\Icons\\INV_Fabric_Linen_01")
		for _, m in ipairs(liste) do
			Noeud({ objet = m.objet, besoin = m.besoin, jai = m.jai, manque = math.max(0, m.besoin - m.jai),
				fabricable = false, base = true }, 0, "base")
		end
		Titre("Recettes", "Interface\\Icons\\INV_Misc_Note_06")
		for j, a in ipairs(arbres) do
			local debut = y
			y = y + 4
			retraitCadre = 6
			Noeud(a, 0, tostring(j))
			retraitCadre = 0
			nCadresR = nCadresR + 1
			local c = CadreSection(courses.cadresRecette, contenu, nCadresR)
			if c.SetBackdropColor then
				c:SetBackdropColor(0.02, 0.02, 0.03, 0.45)
				c:SetBackdropBorderColor(1, 0.82, 0, 0.30)
			end
			c:SetFrameLevel(contenu:GetFrameLevel() + 1)
			c:ClearAllPoints()
			c:SetPoint("TOPLEFT", contenu, "TOPLEFT", 4, -debut)
			c:SetSize(contenu:GetWidth() - 8, y - debut + 4)
			y = y + 10
		end
		courses.barre:SetMinMaxValues(0, math.max(1, #liste))
		courses.barre:SetValue(reunis)
		courses.barre.texte:SetText(("%d / %d matériaux réunis"):format(reunis, #liste))
		local manquants = #liste - reunis
		courses.resume:SetText(manquants == 0 and "|cff33dd55Tout est réuni !|r"
			or ("%d matériau%s à trouver"):format(manquants, manquants > 1 and "x" or ""))
	end
	FermerSection()
	for j = nCadres + 1, #courses.cadres do courses.cadres[j]:Hide() end
	for j = nCadresR + 1, #courses.cadresRecette do courses.cadresRecette[j]:Hide() end
	for j = i + 1, #lignes do
		lignes[j]:Hide()
	end
	contenu:SetHeight(math.max(10, y))
end

local CreerFiche, MajFiche, CreerCarnets
local ouvertsFiche = {}   -- [clé] = true : sections / sous-catégories dépliées dans l'encyclopédie (tout plié par défaut)
local PLUS = "|TInterface\\Buttons\\UI-PlusButton-Up:14:14:0:0|t "
local MOINS = "|TInterface\\Buttons\\UI-MinusButton-Up:14:14:0:0|t "


-- Affichage complet de la liste de courses (la version réduite est la mini-liste, voir MontrerMini)
local function AffichageComplet(f)
	f.defile:Show()
	f.fond:Show()
	f.filet:Show()
	f:SetHeight(HAUTEUR_LISTE_COURSES)
	f.reduire:SetText("-")
	f.encyclo:Show()
	if ns.CarnetsCadre and ns.CarnetsCadre() then ns.CarnetsCadre().defile:Show() end
end

-- menu du nom de la liste : changer de liste, en créer une, supprimer celle-ci
local menuChoix
local function MenuChoixListe(ancre)
	menuChoix = menuChoix or ns.CadreMenu("GuildUpMenuChoixListe")
	local m = menuChoix
	local c, db = Carnets()
	local items = {}
	local noms = {}
	for nom in pairs(c) do noms[#noms + 1] = nom end
	table.sort(noms)
	for _, nom in ipairs(noms) do
		items[#items + 1] = { texte = (nom == db.carnetChoisi and "|cffffd100> " or "   ") .. nom .. ("  |cff999999(%d)|r"):format(#(c[nom].entrees or {})),
			action = function() db.carnetChoisi = nom; MajCourses(); MajCarnet() end }
	end
	items[#items + 1] = { texte = "|cff33dd55+ Nouvelle liste…|r", action = function() StaticPopup_Show("GUILDUP_NOUVEAU_CARNET") end }
	items[#items + 1] = { texte = "|cffff6666Supprimer cette liste|r", action = function()
		StaticPopup_Show("GUILDUP_SUPPRIMER_CARNET", db.carnetChoisi, nil, db.carnetChoisi) end }
	for i, it in ipairs(items) do
		local b = ns.BoutonMenu(m, i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", m, "TOPLEFT", 4, -4 - (i - 1) * 20)
		b:SetPoint("RIGHT", m, "RIGHT", -4, 0)
		b.texte:SetText(it.texte)
		b:SetScript("OnClick", function() m:Hide(); it.action() end)
		b:Show()
	end
	for i = #items + 1, #m.boutons do m.boutons[i]:Hide() end
	m:SetSize(220, 8 + #items * 20)
	m.ancre = ancre
	m:ClearAllPoints()
	m:SetPoint("TOPLEFT", ancre, "BOTTOMLEFT", 0, -2)
	m:Show()
end

local function CreerCourses()
	local X0 = LARGEUR_GAUCHE   -- début de la partie « liste », à droite de la séparation
	local f = CadrePortrait("GuildUpListeCourses", "Carnet de craft", LARGEUR_GAUCHE + LARGEUR_LISTE_COURSES,
		HAUTEUR_LISTE_COURSES, "Interface\\Icons\\INV_Misc_Book_09")
	f:SetPoint("CENTER", UIParent, "CENTER", -170, 0)
	-- séparation verticale entre les carnets et la liste
	local sep = f:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(1, 0.82, 0, 0.45)
	sep:SetWidth(1)
	sep:SetPoint("TOPLEFT", f, "TOPLEFT", X0, -24)
	sep:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", X0, 6)
	-- nom de la liste : clic = choisir / créer / supprimer une liste
	local choix = CreateFrame("Button", nil, f)
	choix:SetPoint("TOPLEFT", f, "TOPLEFT", X0 + 12, -26)
	choix:SetSize(LARGEUR_LISTE_COURSES - 150, 22)
	choix:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	f.titreCarnet = choix:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.titreCarnet:SetPoint("LEFT", choix, "LEFT", 2, 0)
	f.titreCarnet:SetPoint("RIGHT", choix, "RIGHT", -18, 0)
	f.titreCarnet:SetJustifyH("LEFT")
	f.titreCarnet:SetWordWrap(false)
	local fl = choix:CreateTexture(nil, "OVERLAY")
	fl:SetSize(16, 16)
	fl:SetPoint("RIGHT", choix, "RIGHT", 0, 0)
	fl:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	choix:SetScript("OnClick", function(self) MenuChoixListe(self) end)
	choix:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText("Mes listes")
		GameTooltip:AddLine("Clic : changer de liste, en créer une, ou supprimer celle-ci.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	choix:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.resume = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.resume:SetPoint("TOPLEFT", f, "TOPLEFT", X0 + 16, -50)
	f.barre = BarreMetier(f, LARGEUR_LISTE_COURSES - 40)
	f.barre:SetPoint("TOPLEFT", f, "TOPLEFT", X0 + 16, -68)
	-- ouvrir / fermer l'encyclopédie (à droite)
	f.encyclo = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.encyclo:SetSize(110, 22)
	f.encyclo:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, -28)
	f.encyclo:SetText("Encyclopédie")
	f.encyclo:SetScript("OnClick", function()
		local fi = ns.FicheCadre and ns.FicheCadre()
		if fi and fi:IsShown() then fi:Hide()
		else ns.OuvrirFiche(nil, nil, courses) end
	end)
	-- bouton réduire / agrandir (à gauche de la croix)
	f.reduire = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.reduire:SetSize(22, 18)
	-- au-dessus du bandeau de titre du cadre (NineSlice / titre ont un niveau élevé), collé à la croix
	local croix = f.CloseButton or (f.GetName and f:GetName() and _G[f:GetName() .. "CloseButton"])
	if croix then f.reduire:SetPoint("RIGHT", croix, "LEFT", 2, 0)
	else f.reduire:SetPoint("TOPRIGHT", f, "TOPRIGHT", -26, -2) end
	local niveau = f:GetFrameLevel()
	for _, enfant in ipairs({ f:GetChildren() }) do niveau = math.max(niveau, enfant:GetFrameLevel()) end
	f.reduire:SetFrameLevel(niveau + 5)
	f.reduire:SetScript("OnClick", function()
		local db = ns.DB and ns.DB() or {}
		db.coursesCompact = true
		f:Hide()
		if ns.MontrerMini then ns.MontrerMini() end
	end)
	f.reduire:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		local db = ns.DB and ns.DB() or {}
		GameTooltip:SetText("Réduire")
		GameTooltip:AddLine("Ne garder que les composants, sur l'écran, sans fenêtre.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	f.reduire:SetScript("OnLeave", function() GameTooltip:Hide() end)
	local defile = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", f, "TOPLEFT", X0 + 8, HAUT_CONTENU - 6)
	defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, 10)
	f.defile = defile
	f.contenu = CreateFrame("Frame", nil, defile)
	f.contenu:SetSize(LARGEUR_LISTE_COURSES - 44, 10)
	defile:SetScrollChild(f.contenu)
	f:SetScript("OnShow", function()
		-- rouvrir la grande fenêtre : fin du mode réduit
		local db = ns.DB and ns.DB() or {}
		db.coursesCompact = nil
		if ns.CacherMini then ns.CacherMini() end
		AffichageComplet(f)
		MajCourses()
	end)
	courses = f
	CreerCarnets()
	return f
end

-- Colonne « Mes carnets » : toutes mes listes et leurs objets (partie gauche de la fenêtre
-- du carnet de craft ; l'encyclopédie s'accroche à droite)
local carnets            -- le panneau
local lignesCarnets = {}
local carnetsOuverts = {} -- [nom] = true : listes dépliées dans le panneau

local function LigneCarnet(i)
	local l = lignesCarnets[i]
	if l then return l end
	l = CreateFrame("Button", nil, carnets.contenu)
	l:SetHeight(20)
	l.fond = l:CreateTexture(nil, "BACKGROUND")
	l.fond:SetAllPoints(l)
	l:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	l.fleche = l:CreateTexture(nil, "ARTWORK")
	l.fleche:SetSize(12, 12)
	l.fleche:SetPoint("LEFT", l, "LEFT", 4, 0)
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetSize(16, 16)
	l.texte = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	l.texte:SetJustifyH("LEFT")
	l.texte:SetWordWrap(false)
	l.compte = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	l.compte:SetPoint("RIGHT", l, "RIGHT", -4, 0)
	l.texte:SetPoint("RIGHT", l.compte, "LEFT", -4, 0)
	l:SetScript("OnClick", function(self) if self.action then self.action() end end)
	l:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Clic : fiche dans l'encyclopédie", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	l:SetScript("OnLeave", function() GameTooltip:Hide() end)
	lignesCarnets[i] = l
	return l
end

local function MajCarnets()
	if not carnets or not carnets:IsShown() or not carnets.defile:IsShown() then return end
	local c, db = Carnets()
	local noms = {}
	for nom in pairs(c) do noms[#noms + 1] = nom end
	table.sort(noms)
	local y, i = 4, 0
	local largeur = carnets.contenu:GetWidth()
	for _, nom in ipairs(noms) do
		local choisi = nom == db.carnetChoisi
		local ouvert = carnetsOuverts[nom] or choisi
		i = i + 1
		local l = LigneCarnet(i)
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", carnets.contenu, "TOPLEFT", 0, -y)
		l:SetWidth(largeur)
		l:SetHeight(24)
		l.objet = nil
		l.fond:SetColorTexture(1, 0.82, 0, choisi and 0.22 or 0.08)
		l.fleche:SetTexture(ouvert and "Interface\\Buttons\\UI-MinusButton-Up" or "Interface\\Buttons\\UI-PlusButton-Up")
		l.fleche:Show()
		l.icone:ClearAllPoints()
		l.icone:SetPoint("LEFT", l, "LEFT", 20, 0)
		l.icone:SetTexture("Interface\\Icons\\INV_Misc_Note_06")
		l.icone:Show()
		l.texte:ClearAllPoints()
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 6, 0)
		l.texte:SetPoint("RIGHT", l.compte, "LEFT", -4, 0)
		l.texte:SetFontObject(choisi and "GameFontNormal" or "GameFontHighlight")
		l.texte:SetText(nom)
		l.compte:SetText(("|cff999999%d|r"):format(#(c[nom].entrees or {})))
		-- clic : choisir cette liste (et la déplier) ; clic sur une liste déjà choisie : replier/déplier
		l.action = function()
			if choisi then carnetsOuverts[nom] = not ouvert or nil
			else db.carnetChoisi = nom; carnetsOuverts[nom] = true end
			MajCourses()
			MajCarnets()
		end
		l:Show()
		y = y + 26
		if ouvert then
			for _, e in ipairs(c[nom].entrees or {}) do
				local objet = e.objet or (e.sort and Recettes()[e.sort] and Recettes()[e.sort].objet)
				i = i + 1
				local li = LigneCarnet(i)
				li:ClearAllPoints()
				li:SetPoint("TOPLEFT", carnets.contenu, "TOPLEFT", 0, -y)
				li:SetWidth(largeur)
				li:SetHeight(20)
				li.objet = (objet and objet > 0) and objet or nil
				li.fond:SetColorTexture(0, 0, 0, 0)
				li.fleche:Hide()
				local nomO, _, qualite, icone = InfoObjet(objet or 0)
				if not nomO and objet then nomO = ns.NomObjetListe and ns.NomObjetListe(objet) end
				if not nomO and e.sort then nomO, icone = NomSort(e.sort) end
				li.icone:ClearAllPoints()
				li.icone:SetPoint("LEFT", li, "LEFT", 32, 0)
				li.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
				li.icone:Show()
				li.texte:ClearAllPoints()
				li.texte:SetPoint("LEFT", li.icone, "RIGHT", 5, 0)
				li.texte:SetPoint("RIGHT", li.compte, "LEFT", -4, 0)
				li.texte:SetFontObject("GameFontHighlightSmall")
				local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
				li.texte:SetText((qc and qc.hex or "|cffffffff") .. (nomO or "…") .. "|r")
				li.compte:SetText("x" .. (e.qte or 1))
				li.action = li.objet and function()
					if db.carnetChoisi ~= nom then db.carnetChoisi = nom; MajCourses() end
					ns.OuvrirFiche(li.objet, e.qte)
				end or nil
				li:Show()
				y = y + 21
			end
			y = y + 4
		end
	end
	for j = i + 1, #lignesCarnets do lignesCarnets[j]:Hide() end
	carnets.contenu:SetHeight(math.max(10, y))
end
ns.MajCarnets = MajCarnets

CreerCarnets = function()
	local f = CreateFrame("Frame", nil, courses)
	f:SetPoint("TOPLEFT", courses, "TOPLEFT", 0, 0)
	f:SetPoint("BOTTOMRIGHT", courses, "BOTTOMLEFT", LARGEUR_GAUCHE, 0)
	local titre = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", courses, "TOPLEFT", 64, -30)
	titre:SetText("Mes carnets")
	local nouveau = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	nouveau:SetSize(120, 22)
	nouveau:SetPoint("TOPLEFT", courses, "TOPLEFT", 62, -58)
	nouveau:SetText("+ Nouvelle liste")
	nouveau:SetScript("OnClick", function() StaticPopup_Show("GUILDUP_NOUVEAU_CARNET") end)
	local items = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	items:SetSize(64, 22)
	items:SetPoint("LEFT", nouveau, "RIGHT", 4, 0)
	items:SetText("Items")
	items:SetScript("OnClick", function() if ns.OuvrirArtisanat then ns.OuvrirArtisanat(2) end end)
	items:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Ajouter des objets")
		GameTooltip:AddLine("Ouvre la liste de tous les objets (fenêtre Artisanat, onglet Items).", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	items:SetScript("OnLeave", function() GameTooltip:Hide() end)
	local defile = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", courses, "TOPLEFT", 10, HAUT_CONTENU - 6)
	defile:SetPoint("BOTTOMRIGHT", courses, "BOTTOMLEFT", LARGEUR_GAUCHE - 26, 10)
	f.contenu = CreateFrame("Frame", nil, defile)
	f.contenu:SetSize(LARGEUR_GAUCHE - 40, 10)
	defile:SetScrollChild(f.contenu)
	f.defile = defile
	f:SetScript("OnShow", MajCarnets)
	f:Show()
	carnets = f
	return f
end
ns.CarnetsCadre = function() return carnets end

--------------------------------------------------------------------------------
-- Mini-liste (carnet réduit) : seulement les composants à réunir, en direct, sur fond transparent ;
-- glisser par le titre ; « + » rouvre le carnet
--------------------------------------------------------------------------------

local mini
local lignesMini = {}
local LARGEUR_MINI = 250

local function Contour(fs, police)
	fs:SetFontObject(police or "GameFontHighlightSmall")
	local fichier, taille = fs:GetFont()
	if fichier then fs:SetFont(fichier, taille, "OUTLINE") end
	fs:SetShadowOffset(1, -1)
	fs:SetShadowColor(0, 0, 0, 1)
end

local function CreerMini()
	mini = CreateFrame("Frame", "GuildUpCoursesMini", UIParent)
	mini:SetSize(LARGEUR_MINI, 40)
	mini:SetPoint("RIGHT", UIParent, "RIGHT", -260, 80)
	mini:SetMovable(true)
	mini:SetClampedToScreen(true)
	mini:SetFrameStrata("MEDIUM")
	mini:EnableMouse(false) -- les lignes laissent passer les clics vers le jeu
	-- titre : poignée pour déplacer, nom de la liste et avancement
	local tete = CreateFrame("Button", nil, mini)
	tete:SetPoint("TOPLEFT", mini, "TOPLEFT", 0, 0)
	tete:SetPoint("TOPRIGHT", mini, "TOPRIGHT", -48, 0)
	tete:SetHeight(20)
	tete:RegisterForDrag("LeftButton")
	tete:SetScript("OnDragStart", function() mini:StartMoving() end)
	tete:SetScript("OnDragStop", function() mini:StopMovingOrSizing() end)
	tete:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Carnet de craft (réduit)")
		GameTooltip:AddLine("Glisser : déplacer · « + » : rouvrir le carnet", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	tete:SetScript("OnLeave", function() GameTooltip:Hide() end)
	mini.titre = tete:CreateFontString(nil, "OVERLAY")
	Contour(mini.titre, "GameFontNormal")
	mini.titre:SetPoint("LEFT", tete, "LEFT", 2, 0)
	mini.titre:SetPoint("RIGHT", tete, "RIGHT", 0, 0)
	mini.titre:SetJustifyH("LEFT")
	mini.titre:SetWordWrap(false)
	local ouvrir = CreateFrame("Button", nil, mini, "UIPanelButtonTemplate")
	ouvrir:SetSize(22, 18)
	ouvrir:SetPoint("TOPRIGHT", mini, "TOPRIGHT", -24, -1)
	ouvrir:SetText("+")
	ouvrir:SetScript("OnClick", function() ns.OuvrirCourses() end)
	ouvrir:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Rouvrir le carnet de craft")
		GameTooltip:Show()
	end)
	ouvrir:SetScript("OnLeave", function() GameTooltip:Hide() end)
	local fermer = CreateFrame("Button", nil, mini, "UIPanelCloseButton")
	fermer:SetSize(22, 22)
	fermer:SetPoint("LEFT", ouvrir, "RIGHT", 0, 0)
	fermer:SetScript("OnClick", function()
		local db = ns.DB and ns.DB() or {}
		db.coursesCompact = nil
		mini:Hide()
	end)
	mini:Hide()
end

local function MajMini()
	if not mini or not mini:IsShown() then return end
	local _, base = Calculer()
	local _, nomCarnet = Carnet()
	local liste = {}
	for o, n in pairs(base) do
		local nom = InfoObjet(o)
		if not nom then Precharger(o) end
		liste[#liste + 1] = { objet = o, besoin = n, jai = JAi(o), nom = nom or "" }
	end
	table.sort(liste, function(a, b)
		local fa, fb = a.jai >= a.besoin, b.jai >= b.besoin
		if fa ~= fb then return not fa end
		return a.nom < b.nom
	end)
	local reunis = 0
	for _, m in ipairs(liste) do if m.jai >= m.besoin then reunis = reunis + 1 end end
	mini.titre:SetText(("%s  %s%d / %d|r"):format(nomCarnet or "Carnet",
		(reunis == #liste and #liste > 0) and "|cff33dd55" or "|cffffffff", reunis, #liste))
	local y = 22
	for i, m in ipairs(liste) do
		local l = lignesMini[i]
		if not l then
			l = CreateFrame("Frame", nil, mini)
			l:SetSize(LARGEUR_MINI, 17)
			l.icone = l:CreateTexture(nil, "ARTWORK")
			l.icone:SetSize(15, 15)
			l.icone:SetPoint("LEFT", l, "LEFT", 2, 0)
			l.compte = l:CreateFontString(nil, "OVERLAY")
			Contour(l.compte)
			l.compte:SetPoint("RIGHT", l, "RIGHT", -2, 0)
			l.texte = l:CreateFontString(nil, "OVERLAY")
			Contour(l.texte)
			l.texte:SetPoint("LEFT", l.icone, "RIGHT", 4, 0)
			l.texte:SetPoint("RIGHT", l.compte, "LEFT", -6, 0)
			l.texte:SetJustifyH("LEFT")
			l.texte:SetWordWrap(false)
			lignesMini[i] = l
		end
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", mini, "TOPLEFT", 0, -y)
		local _, _, qualite, icone = InfoObjet(m.objet)
		l.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
		local fini = m.jai >= m.besoin
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		l.texte:SetText((fini and "|cff888888" or (qc and qc.hex or "|cffffffff")) .. (m.nom ~= "" and m.nom or "…") .. "|r")
		l.compte:SetText(("%s%d / %d|r"):format(fini and "|cff33dd55" or "|cffff9933", math.min(m.jai, m.besoin), m.besoin))
		l.icone:SetDesaturated(fini)
		l:SetAlpha(fini and 0.7 or 1)
		l:Show()
		y = y + 17
	end
	for i = #liste + 1, #lignesMini do lignesMini[i]:Hide() end
	if #liste == 0 then
		mini.titre:SetText((nomCarnet or "Carnet") .. "  |cff999999(vide)|r")
	end
	mini:SetHeight(y + 2)
end
ns.MajMini = MajMini
ns.MontrerMini = function()
	if not mini then CreerMini() end
	mini:Show()
	MajMini()
end
ns.CacherMini = function() if mini then mini:Hide() end end
ns.MiniVisible = function() return mini and mini:IsShown() end

ns.OuvrirCourses = function()
	if not courses then CreerCourses() end
	-- son OnShow refait la liste ; déjà ouverte, on la refait nous-mêmes (une seule fois dans les deux cas)
	if courses:IsShown() then MajCourses() else courses:Show() end
	courses:Raise()
end
ns.BasculerCourses = function()
	-- réduit : la commande rouvre le carnet ; sinon elle l'ouvre ou le ferme
	if courses and courses:IsShown() then courses:Hide() else ns.OuvrirCourses() end
end

--------------------------------------------------------------------------------
-- Encyclopédie : fiche d'un objet (clic sur un composant) — d'où il vient, qui le fabrique
--------------------------------------------------------------------------------

local fiche
local lignesFiche = {}

-- Repère sur la carte du monde (zone Questie + position 0-100)
local function PoserRepere(zone, x, y)
	local z = zone and Sources().zones[zone]
	local carte = z and z.carte
	if not carte or carte == 0 then Erreur("Position inconnue pour cette zone"); return end
	if x and y and C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		pcall(C_Map.SetUserWaypoint, UiMapPoint.CreateFromCoordinates(carte, x / 100, y / 100))
		if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true) end
	end
	if OpenWorldMap then pcall(OpenWorldMap, carte)
	elseif WorldMapFrame then
		if not WorldMapFrame:IsShown() and ToggleWorldMap then pcall(ToggleWorldMap) end
		if WorldMapFrame.SetMapID then pcall(WorldMapFrame.SetMapID, WorldMapFrame, carte) end
	end
end

local function LigneFiche(i)
	local l = lignesFiche[i]
	if l then return l end
	l = CreateFrame("Button", nil, fiche.contenu)
	l:SetHeight(17)
	l.survol = l:CreateTexture(nil, "HIGHLIGHT")
	l.survol:SetAllPoints(l)
	l.survol:SetColorTexture(1, 0.82, 0, 0.10)
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetSize(14, 14)
	l.texte = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	l.texte:SetJustifyH("LEFT")
	l.texte:SetWordWrap(false)
	l:SetScript("OnClick", function(self) if self.action then self.action() end end)
	l:SetScript("OnEnter", function(self)
		if self.pnj then
			if ns.MontrerBullePnj then ns.MontrerBullePnj(self, self.pnj, self.pnjInfo or {}, self.bulle) end
		elseif self.objetBulle then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			pcall(GameTooltip.SetItemByID, GameTooltip, self.objetBulle)
			GameTooltip:Show()
		elseif self.bulle then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.bulle, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end
	end)
	l:SetScript("OnLeave", function()
		GameTooltip:Hide()
		if ns.CacherModele then ns.CacherModele() end
	end)
	lignesFiche[i] = l
	return l
end

MajFiche = function()
	if not fiche or not fiche:IsShown() then return end
	if not fiche.objet then
		-- ouverte sans objet : page d'accueil
		fiche.nom:SetText("Encyclopédie")
		fiche.nom:SetTextColor(1, 0.82, 0)
		fiche.jai:SetText("Alt + clic sur un objet du jeu pour voir sa fiche.")
		fiche.ajouter:Hide()
		for _, l in ipairs(lignesFiche) do l:Hide() end
		for _, c in ipairs(fiche.cadres or {}) do c:Hide() end
		fiche.contenu:SetHeight(10)
		return
	end
	local objet = fiche.objet
	local nom, lien, qualite, icone = InfoObjet(objet)
	if not nom then Precharger(objet) end
	fiche.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
	if fiche.SetPortraitToAsset and icone then pcall(fiche.SetPortraitToAsset, fiche, icone) end
	fiche.nom:SetText(nom or "chargement…")
	local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
	if qc then fiche.nom:SetTextColor(qc.r, qc.g, qc.b) else fiche.nom:SetTextColor(1, 0.82, 0) end
	local sacs, banque = OuSont(objet)
	fiche.jai:SetText(banque and ("Tu en as %d dans tes sacs · %d à la banque"):format(sacs, banque)
		or ("Tu en as %d dans tes sacs · banque inconnue (ouvre-la une fois)"):format(sacs))
	fiche.ajouter:SetShown(RecettesDe(objet) ~= nil)

	local y, i = 4, 0
	local largeur = fiche.contenu:GetWidth()
	local nCadres, debutSection = 0, nil
	fiche.cadres = fiche.cadres or {}
	local function FermerSection()
		if not debutSection then return end
		nCadres = nCadres + 1
		local c = CadreSection(fiche.cadres, fiche.contenu, nCadres)
		c:ClearAllPoints()
		c:SetPoint("TOPLEFT", fiche.contenu, "TOPLEFT", 0, -(debutSection - 4))
		c:SetSize(largeur, y - debutSection + 8)
		debutSection = nil
		y = y + 12
	end
	-- pliage : une section (titre) ou une sous-catégorie sans action propre se plie / déplie au clic
	local cleSection, sectionOuverte = nil, true
	local retraitPlie        -- sous-catégorie pliée : on saute les lignes plus en retrait
	local function Basculer(cle)
		return function()
			ouvertsFiche[cle] = not ouvertsFiche[cle] or nil
			local defil = fiche.defile:GetVerticalScroll()
			MajFiche()
			fiche.defile:SetVerticalScroll(math.min(defil, fiche.defile:GetVerticalScrollRange()))
		end
	end
	local function Ajouter(texte, retrait, opts)
		opts = opts or {}
		retrait = retrait or 0
		if opts.titre then
			FermerSection()
			debutSection = y
			cleSection = texte:gsub("%(.-%)", "")
			sectionOuverte = ouvertsFiche[cleSection] and true or false
			retraitPlie = nil
			opts.action = Basculer(cleSection)
			opts.bulle = sectionOuverte and "Clic : replier" or "Clic : déplier"
			texte = (sectionOuverte and MOINS or PLUS) .. texte
		else
			if not sectionOuverte then return end
			if retraitPlie and retrait > retraitPlie then return end
			retraitPlie = nil
			if opts.sous and not opts.action then
				local cle = cleSection .. "/" .. texte
				local ouvert = ouvertsFiche[cle] and true or false
				if not ouvert then retraitPlie = retrait end
				opts.action = Basculer(cle)
				texte = (ouvert and MOINS or PLUS) .. texte
			end
		end
		i = i + 1
		local l = LigneFiche(i)
		l:SetFrameLevel(fiche.contenu:GetFrameLevel() + 3)
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", fiche.contenu, "TOPLEFT", 4, -y)
		l:SetWidth(largeur - 8)
		local x = 4 + (retrait or 0) * 14
		l:SetHeight(opts.titre and 24 or 17)
		StylerTitre(l, opts.titre and true or false)
		l.icone:SetSize(opts.titre and 18 or 14, opts.titre and 18 or 14)
		if opts.icone then
			l.icone:ClearAllPoints()
			l.icone:SetPoint("LEFT", l, "LEFT", x, 0)
			l.icone:SetTexture(opts.icone)
			l.icone:Show()
			x = x + 18
		else
			l.icone:Hide()
		end
		l.texte:ClearAllPoints()
		l.texte:SetPoint("LEFT", l, "LEFT", x, 0)
		l.texte:SetPoint("RIGHT", l, "RIGHT", -4, 0)
		-- titres de section, sous-catégories (zones, métier, « dans la guilde ») en jaune gras, puis le détail
		l.texte:SetFontObject(opts.titre and "GameFontNormal" or opts.sous and "GameFontNormalSmall" or "GameFontHighlightSmall")
		l.texte:SetText(texte)
		l.action, l.bulle, l.objetBulle, l.pnj, l.pnjInfo = opts.action, opts.bulle, opts.objet, opts.pnj, opts.pnjInfo
		l:EnableMouse(opts.action ~= nil or opts.bulle ~= nil or opts.objet ~= nil or opts.pnj ~= nil)
		l.survol:SetShown(opts.action ~= nil)
		l:Show()
		y = y + (opts.titre and 27 or 17)
	end
	local function Espace() FermerSection() end
	local function Niveau(p)
		return TexteNiveaux(p)
	end
	-- PNJ regroupés par zone (classés par niveau) ; clic = repère sur la carte
	local function ParZone(ids, faction)
		local zones, ordre = {}, {}
		for _, id in ipairs(ids) do
			local p = Sources().pnj[id]
			if p then
				local z = NomZone(p.zone) or "Zone inconnue"
				if not zones[z] then zones[z] = {}; ordre[#ordre + 1] = z end
				table.insert(zones[z], p)
			end
		end
		local function Min(p) return p.min or 0 end
		for _, l in pairs(zones) do table.sort(l, function(a, b) return Min(a) < Min(b) end) end
		table.sort(ordre, function(a, b) return Min(zones[a][1]) < Min(zones[b][1]) end)
		for _, z in ipairs(ordre) do
			-- clic sur la zone : tous ses monstres (ou marchands) de la liste sur la carte
			-- (marchands : une icône par marchand ; butin : zones bleues comme les quêtes)
			local groupe = { carte = nil, points = {}, couleur = { 0.2, 0.45, 1 },
				icone = faction and "Interface\\GossipFrame\\VendorGossipIcon" or nil }
			for _, p in ipairs(zones[z]) do
				local zz = p.zone and Sources().zones[p.zone]
				groupe.carte = groupe.carte or (zz and zz.carte)
				if faction then
					if p.points and p.points[1] then groupe.points[#groupe.points + 1] = p.points[1] end
				else
					for _, pt in ipairs(p.points or {}) do groupe.points[#groupe.points + 1] = pt end
				end
			end
			local nomObjet = InfoObjet(objet) or "objet"
			Ajouter(z, 1, { sous = true,
				action = (groupe.carte and #groupe.points > 0) and function()
					ns.AfficherSurCarte((faction and "Marchands : " or "Butin : ") .. nomObjet .. " — " .. z, { groupe })
				end or nil,
				bulle = (groupe.carte and #groupe.points > 0) and "Clic : montrer la zone sur la carte" or nil })
			for _, p in ipairs(zones[z]) do
				local f = faction and p.faction and ("  |cff999999[" .. (p.faction == "A" and "Alliance" or p.faction == "H" and "Horde" or "neutre") .. "]|r") or ""
				local zz = p.zone and Sources().zones[p.zone]
				local ok = zz and zz.carte and p.points and #p.points > 0
				Ajouter("- " .. MarqueRang(p.rang) .. p.nom .. Niveau(p) .. f, 2, {
					pnj = p.id, pnjInfo = { nom = p.nom, sous = p.sous, min = p.min, max = p.max, rang = p.rang,
						zone = z, faction = faction and p.faction, marchand = faction and true or nil, objet = objet },
					action = ok and function()
						if faction then
							-- marchand : le marqueur personnel du jeu, à sa position
							PoserRepere(p.zone, p.points[1][1], p.points[1][2])
						else
							ns.AfficherSurCarte(p.nom .. Niveau(p) .. " — " .. z,
								{ { carte = zz.carte, points = p.points, couleur = groupe.couleur } })
						end
					end or nil,
					bulle = ok and (faction and "Clic : poser ton marqueur sur la carte" or "Clic : montrer où il se trouve sur la carte") or nil })
			end
		end
	end

	-- fabriqué
	local recs = RecettesDe(objet)
	if recs then
		Ajouter("Fabriqué", 0, { titre = true, icone = ns.IconeMetierCode and ns.IconeMetierCode(recs[1].metier) or "Interface\\Icons\\Trade_BlackSmithing" })
		for _, r in ipairs(recs) do
			Ajouter(("%s %d%s"):format(NomMetier(r.metier), r.niveau,
				r.rendement > 1 and (" · " .. r.rendement .. " par fabrication") or ""), 1, { sous = true })
			if r.formules then
				for _, fo in ipairs(r.formules) do
					local nomF, _, qualF, iconeF = InfoObjet(fo)
					if not nomF then Precharger(fo) end
					local qcF = qualF and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualF]
					Ajouter("Apprise avec : " .. (qcF and qcF.hex or "|cffffffff") .. (nomF or "…") .. "|r", 2, {
						icone = iconeF, objet = fo, action = function() ns.OuvrirFiche(fo) end })
				end
			else
				Ajouter("|cff999999Apprise auprès d'un maître " .. NomMetier(r.metier):lower() .. "|r", 2)
			end
			for _, c in ipairs(r.composants) do
				local nomC, _, _, iconeC = InfoObjet(c[1])
				if not nomC then Precharger(c[1]) end
				Ajouter(("%d x %s"):format(c[2], nomC or "…"), 2, { icone = iconeC, objet = c[1],
					action = function() ns.OuvrirFiche(c[1]) end })
			end
		end
		local artisans = {}
		for _, a in ipairs(ns.ArtisansDe and ns.ArtisansDe(objet) or {}) do
			if a.moi or a.enLigne then artisans[#artisans + 1] = a end
		end
		if #artisans > 0 then
			Ajouter("Dans la guilde (en ligne)", 1, { sous = true })
			for _, a in ipairs(artisans) do
				local etat = a.moi and "|cff33dd55toi|r" or a.enLigne and "|cff33dd55en ligne|r" or "|cff999999hors ligne|r"
				Ajouter(("- %s (%s %s) · %s"):format(NomCourt(a.nom), NomMetier(a.metier), a.niveau or "?", etat), 2, {
					action = (a.enLigne and not a.moi) and function()
						if ns.CommanderObjet then ns.CommanderObjet(a.cle, a.nom, objet, fiche.qte) end
					end or nil,
					bulle = (a.enLigne and not a.moi) and ("Clic : commander à " .. NomCourt(a.nom)) or nil })
			end
		end
		Espace()
	end
	local appris = RecetteDeFormule(objet)
	if appris then
		Ajouter("Apprend", 0, { titre = true, icone = ns.IconeMetierCode and ns.IconeMetierCode(appris.metier) or "Interface\\Icons\\INV_Scroll_03" })
		Ajouter(("%s %d"):format(NomMetier(appris.metier), appris.niveau), 1, { sous = true })
		if appris.objet > 0 then
			local nomA, _, qualA, iconeA = InfoObjet(appris.objet)
			if not nomA then Precharger(appris.objet) end
			local qcA = qualA and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualA]
			Ajouter(("%s%s|r%s"):format(qcA and qcA.hex or "|cffffffff", nomA or NomSort(appris.sort) or "…",
				appris.rendement > 1 and (" x" .. appris.rendement) or ""), 2,
				{ icone = iconeA, objet = appris.objet, action = function() ns.OuvrirFiche(appris.objet) end })
		else
			Ajouter(NomSort(appris.sort) or "?", 2)
		end
		for _, c in ipairs(appris.composants) do
			local nomC, _, _, iconeC = InfoObjet(c[1])
			if not nomC then Precharger(c[1]) end
			Ajouter(("%d x %s"):format(c[2], nomC or "…"), 3, { icone = iconeC, objet = c[1],
				action = function() ns.OuvrirFiche(c[1]) end })
		end
		Espace()
	end
	local s = Sources().objets[objet]
	if s then
		if #s.recolte > 0 then
			Ajouter("Récolte", 0, { titre = true, icone = "Interface\\Icons\\Trade_Herbalism" })
			-- regroupée par zone, comme le butin : zone (clic = toute la récolte de la zone), puis les points
			local zones, ordre = {}, {}
			for _, id in ipairs(s.recolte) do
				local r = Sources().recolte[id]
				if r then
					for _, z in ipairs(r.zones) do
						local nz = NomZone(z) or "Zone inconnue"
						if not zones[nz] then zones[nz] = { z = z, points = {} }; ordre[#ordre + 1] = nz end
						table.insert(zones[nz].points, { nom = r.nom, pts = r.points and r.points[z] or {} })
					end
				end
			end
			table.sort(ordre)
			for _, nz in ipairs(ordre) do
				local zz = Sources().zones[zones[nz].z]
				local carte = zz and zz.carte
				local tous = {}
				for _, pt in ipairs(zones[nz].points) do for _, q in ipairs(pt.pts) do tous[#tous + 1] = q end end
				Ajouter(nz, 1, { sous = true,
					action = carte and function()
						ns.AfficherSurCarte("Récolte : " .. (InfoObjet(objet) or "objet") .. " — " .. nz,
							{ { carte = carte, points = tous, couleur = { 0.3, 1, 0.4 } } })
					end or nil,
					bulle = carte and "Clic : ouvrir la carte de la zone" or nil })
				table.sort(zones[nz].points, function(x, y2) return x.nom < y2.nom end)
				for _, pt in ipairs(zones[nz].points) do
					Ajouter("- " .. pt.nom, 2, {
						action = carte and function()
							ns.AfficherSurCarte("Récolte : " .. pt.nom .. " — " .. nz,
								{ { carte = carte, points = pt.pts, couleur = { 0.3, 1, 0.4 } } })
						end or nil,
						bulle = carte and "Clic : ouvrir la carte de la zone" or nil })
				end
			end
			Espace()
		end
		if #s.marchands > 0 then
			Ajouter(("Marchands (%d)"):format(#s.marchands), 0, { titre = true, icone = "Interface\\GossipFrame\\VendorGossipIcon" })
			ParZone(s.marchands, true)
			Espace()
		end
		if #s.butin > 0 then
			Ajouter(("Butin (%d monstres%s)"):format(math.max(s.nbButin, #s.butin),
				s.nbButin > #s.butin and (", les " .. #s.butin .. " plus répandus") or ""), 0, { titre = true, icone = "Interface\\Icons\\INV_Misc_Bag_07" })
			ParZone(s.butin, false)
			Espace()
		end
		if #s.contenants > 0 then
			Ajouter("Dans", 0, { titre = true, icone = "Interface\\Icons\\INV_Box_01" })
			for _, c in ipairs(s.contenants) do
				local nomC, _, _, iconeC = InfoObjet(c)
				Ajouter("- " .. (nomC or ("objet " .. c)), 1, { icone = iconeC, objet = c, action = function() ns.OuvrirFiche(c) end })
			end
			Espace()
		end
		if #s.quetes > 0 then
			Ajouter("Quêtes", 0, { titre = true, icone = "Interface\\GossipFrame\\AvailableQuestIcon" })
			for _, q in ipairs(s.quetes) do Ajouter("- " .. (Sources().quetes[q] or "?"), 1) end
			Espace()
		end
	end
	if (appris and not s) then
		Ajouter("Où l'obtenir", 0, { titre = true, icone = "Interface\\Icons\\INV_Misc_QuestionMark" })
		Ajouter("|cff999999Aucune source connue pour cette formule (peut-être retirée du jeu).|r", 1)
	elseif i == 0 or not s or (#s.marchands + #s.recolte + #s.butin + #s.contenants + #s.quetes == 0) then
		local ind = IndicationType(objet)
		if ind then
			Ajouter("Source", 0, { titre = true, icone = "Interface\\Icons\\INV_Misc_QuestionMark" })
			Ajouter(ind, 1)
		elseif i == 0 then
			Ajouter("Aucune source connue pour cet objet.", 0)
		end
	end
	-- recettes qui utilisent cet objet, par métier puis par niveau
	local util = UtilisationsDe(objet)
	if util and #util > 0 then
		Ajouter(("Utilisé dans (%d recette%s)"):format(#util, #util > 1 and "s" or ""), 0, { titre = true, icone = "Interface\\Icons\\INV_Misc_Gear_01" })
		local parMetier, ordre = {}, {}
		for _, r in ipairs(util) do
			local m = NomMetier(r.metier)
			if not parMetier[m] then parMetier[m] = {}; ordre[#ordre + 1] = m end
			table.insert(parMetier[m], r)
		end
		table.sort(ordre)
		for _, m in ipairs(ordre) do
			local l = parMetier[m]
			table.sort(l, function(a, b) if a.niveau ~= b.niveau then return a.niveau < b.niveau end return a.sort < b.sort end)
			Ajouter(m, 1, { sous = true })
			for _, r in ipairs(l) do
				local qte = 0
				for _, c in ipairs(r.composants) do if c[1] == objet then qte = c[2] end end
				local nomU, iconeU, qcU
				if r.objet > 0 then
					local _, _, qualU
					nomU, _, qualU, iconeU = InfoObjet(r.objet)
					if not nomU then Precharger(r.objet) end
					qcU = qualU and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualU]
				end
				if not nomU then
					local nS, iS = NomSort(r.sort)
					nomU, iconeU = nomU or nS, iconeU or iS
				end
				Ajouter(("|cff999999%d|r  %s%s|r  |cff999999(x%d)|r"):format(r.niveau, qcU and qcU.hex or "|cffffffff", nomU or "…", qte), 2, {
					icone = iconeU, objet = r.objet > 0 and r.objet or nil,
					action = r.objet > 0 and function() ns.OuvrirFiche(r.objet) end or nil })
			end
		end
		Espace()
	end
	FermerSection()
	for j = nCadres + 1, #fiche.cadres do fiche.cadres[j]:Hide() end
	for j = i + 1, #lignesFiche do lignesFiche[j]:Hide() end
	fiche.contenu:SetHeight(math.max(10, y))
end

-- Bulle d'un monstre ou d'un marchand : nom, rang, niveau, zone… et son modèle 3D, dans un seul cadre
local LARGEUR_BULLE, HAUTEUR_MODELE = 240, 210
local NOMS_RANGS = { "Élite", "Rare élite", "Boss", "Rare" }
local COULEURS_RANGS = { { 1, 0.82, 0 }, { 0.75, 0.75, 1 }, { 1, 0.3, 0.3 }, { 0.75, 0.75, 1 } }
local apercu
local function CreerBullePnj()
	apercu = CreateFrame("Frame", "GuildUpApercu3D", UIParent, "BackdropTemplate")
	apercu:SetWidth(LARGEUR_BULLE)
	apercu:SetFrameStrata("TOOLTIP")
	apercu:SetClampedToScreen(true)
	if apercu.SetBackdrop then
		apercu:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
			insets = { left = 3, right = 3, top = 3, bottom = 3 } })
		apercu:SetBackdropColor(0.04, 0.04, 0.06, 0.96)
		apercu:SetBackdropBorderColor(1, 0.82, 0, 0.8)
	end
	local function Texte(police, r, g, b)
		local t = apercu:CreateFontString(nil, "OVERLAY", police)
		t:SetWidth(LARGEUR_BULLE - 20)
		t:SetJustifyH("LEFT")
		if r then t:SetTextColor(r, g, b) end
		return t
	end
	apercu.nom = Texte("GameFontNormalLarge")
	apercu.sous = Texte("GameFontHighlightSmall", 0.7, 0.7, 0.7)
	apercu.infos = Texte("GameFontHighlightSmall")
	apercu.infos:SetSpacing(2)
	-- cadre du modèle : fond sombre et filet doré
	apercu.scene = CreateFrame("Frame", nil, apercu)
	apercu.scene:SetSize(LARGEUR_BULLE - 16, HAUTEUR_MODELE)
	local fond = apercu.scene:CreateTexture(nil, "BACKGROUND")
	fond:SetAllPoints(apercu.scene)
	fond:SetColorTexture(0, 0, 0, 0.55)
	for _, bord in ipairs({ { "TOPLEFT", "TOPRIGHT" }, { "BOTTOMLEFT", "BOTTOMRIGHT" } }) do
		local t = apercu.scene:CreateTexture(nil, "BORDER")
		t:SetColorTexture(1, 0.82, 0, 0.35)
		t:SetHeight(1)
		t:SetPoint(bord[1], apercu.scene, bord[1])
		t:SetPoint(bord[2], apercu.scene, bord[2])
	end
	local okM, m = pcall(CreateFrame, "PlayerModel", nil, apercu.scene)
	if okM then
		m:SetAllPoints(apercu.scene)
		apercu.modele = m
		local angle = 0
		apercu:SetScript("OnUpdate", function(_, ecoule)
			angle = (angle + ecoule * 0.7) % (2 * math.pi)
			pcall(m.SetFacing, m, angle)
		end)
	end
	apercu.aide = Texte("GameFontNormalSmall", 0.2, 0.85, 0.35)
end

ns.MontrerBullePnj = function(proprio, id, info, aide)
	if not apercu then CreerBullePnj() end
	GameTooltip:Hide()
	local rang = info.rang or 0
	local c = COULEURS_RANGS[rang] or { 1, 1, 1 }
	apercu.nom:SetText((rang == 1 or rang == 2) and ("|TInterface\\Tooltips\\EliteNameplateIcon:16:16:0:0|t" .. (info.nom or "?")) or (info.nom or "?"))
	apercu.nom:SetTextColor(c[1], c[2], c[3])
	apercu.sous:SetText(info.sous and ("<" .. info.sous .. ">") or "")
	local texte = {}
	local niveau = (info.min and info.min > 0) and ((info.max and info.max ~= info.min) and (info.min .. "-" .. info.max) or tostring(info.min)) or nil
	local quoi = {}
	if niveau then quoi[#quoi + 1] = "Niveau " .. niveau end
	if NOMS_RANGS[rang] then quoi[#quoi + 1] = ("|cff%02x%02x%02x%s|r"):format(c[1] * 255, c[2] * 255, c[3] * 255, NOMS_RANGS[rang]) end
	if #quoi > 0 then texte[#texte + 1] = table.concat(quoi, "  ·  ") end
	if info.zone then texte[#texte + 1] = "|cff999999Zone :|r " .. info.zone end
	if info.faction then
		local f = info.faction == "A" and "|cff4a9effAlliance|r" or info.faction == "H" and "|cffff4a4aHorde|r" or "neutre"
		texte[#texte + 1] = "|cff999999Faction :|r " .. f
	end
	if info.objet then
		local nomO, _, qualite = InfoObjet(info.objet)
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		if nomO then
			texte[#texte + 1] = (info.marchand and "|cff999999Vend :|r " or "|cff999999Butin :|r ")
				.. (qc and qc.hex or "|cffffffff") .. nomO .. "|r"
		end
	end
	apercu.infos:SetText(table.concat(texte, "\n"))
	apercu.aide:SetText(aide or "")
	-- mise en page verticale
	local y = -10
	local function Poser(t, ecart)
		if t:GetText() == nil or t:GetText() == "" then t:Hide(); return end
		t:ClearAllPoints()
		t:SetPoint("TOPLEFT", apercu, "TOPLEFT", 10, y)
		t:Show()
		y = y - t:GetStringHeight() - (ecart or 4)
	end
	Poser(apercu.nom, 2)
	Poser(apercu.sous, 4)
	Poser(apercu.infos, 8)
	local modele = false
	if apercu.modele then
		pcall(apercu.modele.ClearModel, apercu.modele)
		modele = pcall(apercu.modele.SetCreature, apercu.modele, id)
	end
	if modele then
		apercu.scene:ClearAllPoints()
		apercu.scene:SetPoint("TOPLEFT", apercu, "TOPLEFT", 8, y)
		apercu.scene:Show()
		y = y - HAUTEUR_MODELE - 6
	else
		apercu.scene:Hide()
	end
	Poser(apercu.aide, 0)
	apercu:SetHeight(-y + 8)
	apercu:ClearAllPoints()
	apercu:SetPoint("TOPLEFT", proprio, "TOPRIGHT", 12, 4)
	apercu:Show()
end
-- (compatibilité : ancien appel modèle seul)
ns.CacherModele = function() if apercu then apercu:Hide() end end

CreerFiche = function()
	local f = CadrePortrait("GuildUpEncyclopedie", "Encyclopédie", LARGEUR_FICHE, HAUTEUR_FICHE, "Interface\\Icons\\INV_Misc_Book_09")
	f:SetPoint("CENTER")
	-- (icône cachée : l'objet est dans le portrait ; on garde la zone de survol)
	f.icone = f:CreateTexture(nil, "ARTWORK")
	f.icone:SetSize(1, 1)
	f.icone:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	f.icone:SetAlpha(0)
	local zoneIcone = CreateFrame("Frame", nil, f)
	zoneIcone:SetSize(58, 58)
	zoneIcone:SetPoint("TOPLEFT", f, "TOPLEFT", -6, 8)
	zoneIcone:EnableMouse(true)
	zoneIcone:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, f.objet)
		GameTooltip:Show()
	end)
	zoneIcone:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.nom = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.nom:SetPoint("TOPLEFT", f, "TOPLEFT", 64, -30)
	f.nom:SetPoint("RIGHT", f, "RIGHT", -16, 0)
	f.nom:SetJustifyH("LEFT")
	f.nom:SetWordWrap(false)
	f.jai = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.jai:SetPoint("TOPLEFT", f.nom, "BOTTOMLEFT", 0, -3)
	-- actions
	local besoin = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	besoin:SetSize(70, 22)
	besoin:SetPoint("TOPLEFT", f, "TOPLEFT", 62, -64)
	besoin:SetText("Besoin")
	besoin:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Ajouter aux besoins")
		GameTooltip:AddLine("La guilde verra que tu cherches cet objet.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	besoin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- objets fabricables : ajouter à une de mes listes de courses
	f.ajouter = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	f.ajouter:SetSize(120, 22)
	f.ajouter:SetPoint("LEFT", besoin, "RIGHT", 4, 0)
	f.ajouter:SetText("Ajouter à une liste")
	f.ajouter:SetScript("OnClick", function(self)
		if ns.MontrerMenuListes and f.objet then ns.MontrerMenuListes(self, f.objet) end
	end)
	f.ajouter:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Ajouter à une liste de courses")
		GameTooltip:AddLine("Choisis une de tes listes, ou crée-en une nouvelle.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	f.ajouter:SetScript("OnLeave", function() GameTooltip:Hide() end)
	besoin:SetScript("OnClick", function()
		if ns.AjouterBesoin and ns.AjouterBesoin(f.objet, f.qte or 1) and ns.Notifier then
			ns.Notifier(nil, "Besoin ajouté", (InfoObjet(f.objet) or "Objet") .. " est dans tes besoins : la guilde le voit.", "aucun", function() end)
		end
	end)
	local lienB = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	lienB:SetSize(56, 22)
	lienB:SetPoint("LEFT", f.ajouter, "RIGHT", 4, 0)
	lienB:SetText("Lien")
	lienB:SetScript("OnClick", function()
		local _, lien = InfoObjet(f.objet)
		if lien then
			if ChatEdit_InsertLink and ChatEdit_InsertLink(lien) then return end
			if ChatFrame_OpenChat then ChatFrame_OpenChat(lien) end
		end
	end)
	local defile = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", f, "TOPLEFT", 12, HAUT_CONTENU - 6)
	defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, 10)
	f.contenu = CreateFrame("Frame", nil, defile)
	f.contenu:SetSize(LARGEUR_FICHE - 54, 10)
	defile:SetScrollChild(f.contenu)
	f.defile = defile
	f:SetScript("OnHide", function() if ns.CacherModele then ns.CacherModele() end end)
	-- fenêtre indépendante : elle se pose à côté de la fenêtre d'où on l'ouvre, puis se déplace seule
	f:SetSize(LARGEUR_FICHE, HAUTEUR_FICHE)
	tinsert(UISpecialFrames, "GuildUpEncyclopedie")
	fiche = f
	return f
end

-- Ouvre la fiche d'un objet (qte : quantité proposée pour les commandes et les besoins)
ns.FicheCadre = function() return fiche end
-- où poser l'encyclopédie quand on l'ouvre : à droite de la fenêtre d'où vient le clic
local function PlacerFiche(origine)
	fiche:ClearAllPoints()
	if origine and origine:IsShown() then
		fiche:SetPoint("TOPLEFT", origine, "TOPRIGHT", 4, -40)
	else
		fiche:SetPoint("CENTER", UIParent, "CENTER", 260, 0)
	end
end
ns.OuvrirFiche = function(objet, qte, origine)
	if not fiche then CreerFiche() end
	if not fiche:IsShown() or (objet and objet ~= fiche.objet) then wipe(ouvertsFiche) end
	if not fiche:IsShown() then
		-- d'où vient-on ? fenêtre indiquée, sinon la liste ou les Items s'ils sont ouverts
		local items = _G.GuildUpArtisanat
		origine = origine or (courses and courses:IsShown() and courses) or (items and items:IsShown() and items) or nil
		PlacerFiche(origine)
	end
	if objet then fiche.objet = objet end
	fiche.qte = (qte and qte > 0) and qte or 1
	fiche:Show()
	fiche:Raise()
	fiche.defile:SetVerticalScroll(0)
	MajFiche()
end

--------------------------------------------------------------------------------
-- Onglet « Items » : tous les objets du jeu, comme l'hôtel des ventes ; boutons « Besoin » (ajoute
-- aux besoins de la guilde) et « Ajouter » (à une de mes listes, ou à une nouvelle)
--------------------------------------------------------------------------------

local page
local lignesItems = {}
local MAX_AFFICHES = 150
local categorieItems, rechercheItems = 1, ""
local CATEGORIES_ITEMS = {
	{ nom = "Tout" },
	{ nom = "Armes", classes = { [2] = true } },
	{ nom = "Armures", classes = { [4] = true } },
	{ nom = "Consommables", classes = { [0] = true } },
	{ nom = "Artisanat", classes = { [7] = true, [5] = true } },
	{ nom = "Recettes", classes = { [9] = true } },
	{ nom = "Gemmes", classes = { [3] = true } },
	{ nom = "Sacs", classes = { [1] = true, [11] = true } },
	{ nom = "Divers", autres = true },
}
local RANGEES = {}
for _, c in ipairs(CATEGORIES_ITEMS) do for k in pairs(c.classes or {}) do RANGEES[k] = true end end
-- catalogue : la liste des objets échangeables + les objets fabriqués qui n'y sont pas
local catalogue   -- { { id, qualite, nom, simplifie, classe, niveau d'objet }, … }
local triItems = 1 -- 1 = niveau d'objet décroissant (défaut), 2 = croissant, 3 = nom
local TRIS = { "Niveau |TInterface\\Buttons\\Arrow-Down-Up:12:12:0:-2|t", "Niveau |TInterface\\Buttons\\Arrow-Up-Up:12:12:0:2|t", "Nom (A-Z)" }
local function Catalogue()
	if catalogue then return catalogue end
	catalogue = {}
	local vus = {}
	for _, o in ipairs(ns.IndexObjets and ns.IndexObjets() or {}) do
		catalogue[#catalogue + 1] = o
		vus[o[1]] = true
	end
	-- objets liés quand ramassés (butin de boss, objets fabriqués…) : dans Items, pas dans les Besoins
	for id, q, classe, niv, nom in (ns.DONNEES_OBJETS_LIES or ""):gmatch("(%d+):(%d+):(%d+):(%d+):([^\n]+)") do
		id = tonumber(id)
		if not vus[id] then
			vus[id] = true
			catalogue[#catalogue + 1] = { id, tonumber(q), nom, Simplifier(nom), tonumber(classe), tonumber(niv), true }
		end
	end
	ns.DONNEES_OBJETS_LIES = nil
	for _, r in pairs(Recettes()) do
		if r.objet > 0 and not vus[r.objet] then
			vus[r.objet] = true
			local nom, _, qualite = InfoObjet(r.objet)
			nom = nom or NomSort(r.sort)
			if nom then
				local classe = ClasseObjet(r.objet)
				local niv
				if C_Item and C_Item.GetDetailedItemLevelInfo then
					local okN, n = pcall(C_Item.GetDetailedItemLevelInfo, r.objet)
					niv = okN and n or nil
				end
				catalogue[#catalogue + 1] = { r.objet, qualite or 1, nom, Simplifier(nom), classe, niv or 0 }
			end
		end
	end
	-- la fenêtre Items ne montre que les objets fabricables
	local fab = {}
	for _, o in ipairs(catalogue) do
		if RecettesDe(o[1]) then fab[#fab + 1] = o end
	end
	catalogue = fab
	table.sort(catalogue, function(x, y) return x[4] < y[4] end)
	return catalogue
end

local sousCategorie        -- nil = toute la catégorie, sinon clé classe * 100 + sous-classe

-- sous-classe d'un objet (lue dans les données du client, instantané), en cache
local InfoInstant = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
local InfoSousClasse = (C_Item and C_Item.GetItemSubClassInfo) or GetItemSubClassInfo
local cacheSous, nomsSous = {}, {}
local function SousClasse(id)
	local v = cacheSous[id]
	if v == nil then
		v = false
		if InfoInstant then
			local ok, _, _, nomSous, _, _, classe, sous = pcall(InfoInstant, id)
			if ok and classe and sous then
				v = classe * 100 + sous
				if not nomsSous[v] then
					local okN, nom = false, nil
					if InfoSousClasse then okN, nom = pcall(InfoSousClasse, classe, sous) end
					nomsSous[v] = (okN and nom and nom ~= "") and nom or nomSous or ("?" .. sous)
				end
			end
		end
		cacheSous[id] = v
	end
	return v or nil
end

-- nombre d'objets d'une catégorie (pour cacher les vides)
local nombreParCat = {}
local function NombreCategorie(i)
	if nombreParCat[i] then return nombreParCat[i] end
	local cat, n = CATEGORIES_ITEMS[i], 0
	for _, o in ipairs(Catalogue()) do
		if cat.autres then if not RANGEES[o[5] or -1] then n = n + 1 end
		elseif cat.classes then if cat.classes[o[5] or -1] then n = n + 1 end
		else n = n + 1 end
	end
	nombreParCat[i] = n
	return n
end

-- sous-catégories présentes dans une catégorie (triées comme le jeu : classe puis sous-classe)
local sousParCat = {}
local function SousCategories(i)
	if sousParCat[i] then return sousParCat[i] end
	local cat, vus, liste = CATEGORIES_ITEMS[i], {}, {}
	if cat.classes then
		for _, o in ipairs(Catalogue()) do
			if cat.classes[o[5] or -1] then
				local k = SousClasse(o[1])
				if k and not vus[k] then vus[k] = true; liste[#liste + 1] = k end
			end
		end
	end
	table.sort(liste)
	-- une seule sous-catégorie : inutile de l'afficher
	if #liste < 2 then liste = {} end
	sousParCat[i] = liste
	return liste
end


-- menu « Ajouter à une liste » : mes listes + nouvelle liste
local menuListes
local MontrerMenuListes
MontrerMenuListes = function(bouton, objet)
	menuListes = menuListes or ns.CadreMenu("GuildUpMenuListes")
	local m = menuListes
	local c = Carnets()
	local choix = { { titre = "Mes carnets" } }
	local nomsC = {}
	for nom in pairs(c) do nomsC[#nomsC + 1] = nom end
	table.sort(nomsC)
	for _, nom in ipairs(nomsC) do choix[#choix + 1] = { liste = nom } end
	choix[#choix + 1] = { nouvelleListe = true }
	choix[#choix + 1] = { titre = "Projets de guilde" }
	local moi = ns.Normaliser and ns.Normaliser(UnitName("player")) or UnitName("player")
	for _, p in ipairs(ns.ListeProjets and ns.ListeProjets() or {}) do
		if p.auteur == moi then choix[#choix + 1] = { projet = p } end
	end
	choix[#choix + 1] = { nouveauProjet = true }
	for i, ch in ipairs(choix) do
		local b = ns.BoutonMenu(m, i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", m, "TOPLEFT", 4, -4 - (i - 1) * 20)
		b:SetPoint("RIGHT", m, "RIGHT", -4, 0)
		b:Enable()
		b.texte:SetPoint("LEFT", b, "LEFT", ch.titre and 4 or 12, 0)
		b.texte:SetFontObject(ch.titre and "GameFontNormal" or "GameFontHighlightSmall")
		local nomObjet = (InfoObjet(objet)) or "Objet"
		if ch.titre then
			b.texte:SetText(ch.titre)
			b:SetScript("OnClick", nil)
			b:Disable()
		elseif ch.liste then
			local nom = ch.liste
			b.texte:SetText(nom)
			b:SetScript("OnClick", function()
				m:Hide()
				AjouterObjet(objet, 1, nom)
				if ns.Notifier then ns.Notifier(nil, "Liste de courses", nomObjet .. " ajouté à « " .. nom .. " »", "aucun", function() ns.OuvrirCourses() end) end
			end)
		elseif ch.nouvelleListe then
			b.texte:SetText("|cff33dd55+ Nouvelle liste…|r")
			b:SetScript("OnClick", function()
				m:Hide()
				StaticPopup_Show("GUILDUP_NOUVEAU_CARNET", nil, nil, objet)
			end)
		elseif ch.projet then
			local p = ch.projet
			b.texte:SetText(p.nom)
			b:SetScript("OnClick", function()
				m:Hide()
				if ns.AjouterAProjet then ns.AjouterAProjet(p.id, objet, 1) end
				if ns.Notifier then ns.Notifier("commandes", "Projet de guilde", nomObjet .. " ajouté au projet « " .. p.nom .. " »", "aucun", function() ns.OuvrirProjet(p.id) end) end
			end)
		else
			b.texte:SetText("|cff33dd55+ Nouveau projet…|r")
			b:SetScript("OnClick", function()
				m:Hide()
				StaticPopup_Show("GUILDUP_NOUVEAU_PROJET", nil, nil, { objet = objet })
			end)
		end
		b:Show()
	end
	for i = #choix + 1, #m.boutons do m.boutons[i]:Hide() end
	m:SetSize(200, 8 + #choix * 20)
	m.ancre = bouton
	m:ClearAllPoints()
	m:SetPoint("TOPLEFT", bouton, "BOTTOMLEFT", 0, -2)
	m:Show()
end
ns.MontrerMenuListes = MontrerMenuListes

local function CreerLigneItem(parent, largeur)
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(largeur, 34)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	b.fond:SetColorTexture(1, 1, 1, 0.04)
	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(28, 28)
	b.icone:SetPoint("LEFT", b, "LEFT", 3, 0)
	b.nom = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b.icone, "TOPRIGHT", 6, -1)
	b.nom:SetPoint("RIGHT", b, "RIGHT", -170, 0)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.info = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.info:SetPoint("BOTTOMLEFT", b.icone, "BOTTOMRIGHT", 6, 1)
	b.info:SetPoint("RIGHT", b, "RIGHT", -170, 0)
	b.info:SetJustifyH("LEFT")
	b.info:SetWordWrap(false)
	b.ajouter = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.ajouter:SetSize(80, 22)
	b.ajouter:SetPoint("RIGHT", b, "RIGHT", -2, 0)
	b.ajouter:SetText("Ajouter")
	b.besoin = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.besoin:SetSize(76, 22)
	b.besoin:SetPoint("RIGHT", b.ajouter, "LEFT", -4, 0)
	b.besoin:SetText("Besoin")
	b:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Clic : fiche (d'où ça vient, qui le fabrique)", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	b:SetScript("OnClick", function(self)
		if not self.objet then return end
		if IsModifiedClick and IsModifiedClick("CHATLINK") then
			local _, lien = InfoObjet(self.objet)
			if lien and ChatEdit_InsertLink then ChatEdit_InsertLink(lien) end
			return
		end
		if ns.OuvrirFiche then ns.OuvrirFiche(self.objet, nil, _G.GuildUpArtisanat) end
	end)
	b.besoin:SetScript("OnClick", function(self)
		local o = self:GetParent().objet
		if o and ns.AjouterBesoin and ns.AjouterBesoin(o, 1) and ns.Notifier then
			ns.Notifier(nil, "Besoin ajouté", ((InfoObjet(o)) or "Objet") .. " est dans tes besoins : la guilde le voit.", "aucun",
				function() if ns.OuvrirBesoins then ns.OuvrirBesoins() end end)
		end
	end)
	b.besoin:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Ajouter à mes besoins")
		GameTooltip:AddLine("La guilde voit que tu cherches cet objet (onglet Besoins de la fenêtre Dons).", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	b.besoin:SetScript("OnLeave", function() GameTooltip:Hide() end)
	b.ajouter:SetScript("OnClick", function(self) MontrerMenuListes(self, self:GetParent().objet) end)
	b.ajouter:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Ajouter à une liste de courses")
		GameTooltip:AddLine("Choisis une de tes listes, ou crée-en une nouvelle.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	b.ajouter:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

MajCarnet = function()
	if not page or not page:IsVisible() then return end
	local cat = CATEGORIES_ITEMS[categorieItems]
	page.MajCategories()
	local res, total = {}, 0
	for _, o in ipairs(Catalogue()) do
		local garde
		if cat.autres then garde = not RANGEES[o[5] or -1]
		elseif cat.classes then garde = cat.classes[o[5] or -1] == true
		else garde = true end
		if garde and sousCategorie then garde = SousClasse(o[1]) == sousCategorie end
		if garde and rechercheItems ~= "" then garde = o[4]:find(rechercheItems, 1, true) ~= nil end
		if garde then
			total = total + 1
			res[#res + 1] = o
		end
	end
	if triItems == 3 then
		table.sort(res, function(x, y) return x[4] < y[4] end)
	else
		local haut = triItems == 1
		table.sort(res, function(x, y)
			local a, b = x[6] or 0, y[6] or 0
			if a ~= b then if haut then return a > b else return a < b end end
			return x[4] < y[4]
		end)
	end
	for k = #res, MAX_AFFICHES + 1, -1 do res[k] = nil end
	local y = 0
	for i, o in ipairs(res) do
		local b = lignesItems[i] or CreerLigneItem(page.contenu, page.largeurListe)
		lignesItems[i] = b
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", page.contenu, "TOPLEFT", 0, -y)
		b.fond:SetShown(i % 2 == 0)
		b.objet = o[1]
		-- objet lié quand ramassé : on ne peut pas le donner, pas de « Besoin »
		b.besoin:SetShown(not o[7])
		local nom, _, qualite, icone = InfoObjet(o[1])
		b.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
		b.nom:SetText(nom or o[3])
		local qc = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite or o[2] or 1]
		if qc then b.nom:SetTextColor(qc.r, qc.g, qc.b) else b.nom:SetTextColor(1, 1, 1) end
		local recs = RecettesDe(o[1])
		if recs then
			local r = recs[1]
			local moi, enLigne = false, 0
			for _, art in ipairs(ns.ArtisansDe and ns.ArtisansDe(o[1]) or {}) do
				if art.moi then moi = true elseif art.enLigne then enLigne = enLigne + 1 end
			end
			b.info:SetText(((o[6] or 0) > 0 and ("|cffbbbbbbNiv. %d|r  ·  "):format(o[6]) or "") .. ("Fabriqué : %s %d%s"):format(NomMetier(r.metier), r.niveau,
				moi and "  |cff33dd55· tu sais le faire|r" or enLigne > 0 and ("  |cff33dd55· %d artisan%s en ligne|r"):format(enLigne, enLigne > 1 and "s" or "") or ""))
		else
			b.info:SetText(((o[6] or 0) > 0 and ("|cffbbbbbbNiv. %d|r" .. (Sources().objets[o[1]] and "  ·  " or "")):format(o[6]) or "")
				.. "|cff999999" .. ((Sources().objets[o[1]] and "Sources connues · clic pour la fiche") or "") .. "|r")
		end
		b:Show()
		y = y + 36
	end
	for i = #res + 1, #lignesItems do lignesItems[i]:Hide() end
	page.contenu:SetHeight(math.max(10, y))
	page.compte:SetText(total > MAX_AFFICHES and ("%d objets (%d affichés)"):format(total, MAX_AFFICHES)
		or ("%d objet%s"):format(total, total > 1 and "s" or ""))
	page.vide:SetShown(#res == 0)
end

StaticPopupDialogs["GUILDUP_NOUVEAU_CARNET"] = {
	text = "Nom de la nouvelle liste :",
	button1 = "Créer",
	button2 = "Annuler",
	hasEditBox = true,
	maxLetters = 30,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnAccept = function(self)
		local boite = self.editBox or self.EditBox
		local nom = boite and strtrim(boite:GetText() or "") or ""
		if nom == "" then return end
		local c, db = Carnets()
		c[nom] = c[nom] or { entrees = {}, obtenir = {} }
		db.carnetChoisi = nom
		if self.data then AjouterObjet(self.data, 1, nom) end
		MajCarnet()
		MajCourses()
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		StaticPopupDialogs["GUILDUP_NOUVEAU_CARNET"].OnAccept(parent)
		parent:Hide()
	end,
}
StaticPopupDialogs["GUILDUP_SUPPRIMER_CARNET"] = {
	text = "Supprimer la liste « %s » ?",
	button1 = "Supprimer",
	button2 = "Annuler",
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnAccept = function(self)
		local c, db = Carnets()
		c[self.data] = nil
		db.carnetChoisi = nil
		Carnets()
		MajCarnet()
		MajCourses()
	end,
}

local function CreerPageItems(f)
	local hautEncart = ns.HAUT_ENCART or -88
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	page = p
	local largeur = f:GetWidth()
	local LARGEUR_C = 165
	local titre = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", f, "TOPLEFT", 70, -32)
	titre:SetText("Items")
	local okC, cherche = pcall(CreateFrame, "EditBox", "GuildUpItemsCherche", p, "SearchBoxTemplate")
	if not okC then cherche = CreateFrame("EditBox", "GuildUpItemsCherche", p, "InputBoxTemplate") end
	cherche:SetSize(240, 20)
	cherche:SetPoint("TOPLEFT", f, "TOPLEFT", 76, -58)
	cherche:SetAutoFocus(false)
	if cherche.Instructions then cherche.Instructions:SetText("Chercher un objet") end
	cherche:HookScript("OnTextChanged", function(self)
		rechercheItems = Simplifier(strtrim(self:GetText() or ""))
		p.defile:SetVerticalScroll(0)
		MajCarnet()
	end)
	cherche:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
	p.compte = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	p.compte:SetPoint("LEFT", cherche, "RIGHT", 12, 0)
	local listes = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
	listes:SetSize(130, 24)
	listes:SetPoint("TOPRIGHT", f, "TOPRIGHT", -16, -56)
	listes:SetText("Mes listes")
	listes:SetScript("OnClick", function() ns.OuvrirCourses() end)
	local tri = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
	tri:SetSize(104, 24)
	tri:SetPoint("RIGHT", listes, "LEFT", -6, 0)
	tri:SetText(TRIS[triItems])
	tri:SetScript("OnClick", function(self)
		triItems = triItems % #TRIS + 1
		self:SetText(TRIS[triItems])
		p.defile:SetVerticalScroll(0)
		MajCarnet()
	end)
	tri:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Trier")
		GameTooltip:AddLine("Clic : niveau d'objet décroissant, croissant, ou par nom.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	tri:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- catégories
	local fondC = p:CreateTexture(nil, "BACKGROUND")
	fondC:SetPoint("TOPLEFT", f, "TOPLEFT", 8, hautEncart - 4)
	fondC:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 10)
	fondC:SetWidth(LARGEUR_C)
	fondC:SetColorTexture(0, 0, 0, 0.3)
	local defC = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
	defC:SetPoint("TOPLEFT", f, "TOPLEFT", 12, hautEncart - 8)
	defC:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 14)
	defC:SetWidth(LARGEUR_C - 8)
	-- barre de défilement fine, rangée dans la colonne
	if defC.ScrollBar then
		defC.ScrollBar:ClearAllPoints()
		defC.ScrollBar:SetPoint("TOPRIGHT", defC, "TOPRIGHT", 2, -16)
		defC.ScrollBar:SetPoint("BOTTOMRIGHT", defC, "BOTTOMRIGHT", 2, 16)
		defC.ScrollBar:SetScale(0.8)
	end
	local contC = CreateFrame("Frame", nil, defC)
	contC:SetSize(LARGEUR_C - 22, 10)
	defC:SetScrollChild(contC)
	p.boutonsCats = {}
	local function BoutonCat(n)
		local bt = p.boutonsCats[n]
		if bt then return bt end
		bt = CreateFrame("Button", nil, contC)
		bt:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		bt.choisi = bt:CreateTexture(nil, "BACKGROUND")
		bt.choisi:SetAllPoints(bt)
		bt.choisi:SetColorTexture(1, 0.82, 0, 0.18)
		bt.texte = bt:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		bt.texte:SetJustifyH("LEFT")
		bt.texte:SetWordWrap(false)
		bt:SetScript("OnClick", function(self)
			if self.sous then
				sousCategorie = (sousCategorie ~= self.sous) and self.sous or nil
			else
				categorieItems = self.cat
				sousCategorie = nil
			end
			p.defile:SetVerticalScroll(0)
			MajCarnet()
		end)
		p.boutonsCats[n] = bt
		return bt
	end
	-- catégories, et sous les choisies leurs sous-catégories (décalées)
	p.MajCategories = function()
		local y, n = 2, 0
		local largeurC = contC:GetWidth()
		for i, c in ipairs(CATEGORIES_ITEMS) do
		if NombreCategorie(i) > 0 then
			n = n + 1
			local bt = BoutonCat(n)
			bt:ClearAllPoints()
			bt:SetPoint("TOPLEFT", contC, "TOPLEFT", 0, -y)
			bt:SetSize(largeurC, 22)
			bt.cat, bt.sous = i, nil
			bt.texte:SetFontObject("GameFontHighlight")
			bt.texte:ClearAllPoints()
			bt.texte:SetPoint("LEFT", bt, "LEFT", 6, 0)
			bt.texte:SetPoint("RIGHT", bt, "RIGHT", -2, 0)
			local subs = SousCategories(i)
			local ouvert = i == categorieItems
			bt.texte:SetText(c.nom .. ((#subs > 0) and (ouvert and "  |cff999999-|r" or "  |cff999999+|r") or ""))
			bt.choisi:SetShown(ouvert and not sousCategorie)
			bt:Show()
			y = y + 23
			if ouvert then
				for _, k in ipairs(subs) do
					n = n + 1
					local bs = BoutonCat(n)
					bs:ClearAllPoints()
					bs:SetPoint("TOPLEFT", contC, "TOPLEFT", 10, -y)
					bs:SetSize(largeurC - 10, 18)
					bs.cat, bs.sous = i, k
					bs.texte:SetFontObject("GameFontHighlightSmall")
					bs.texte:ClearAllPoints()
					bs.texte:SetPoint("LEFT", bs, "LEFT", 6, 0)
					bs.texte:SetPoint("RIGHT", bs, "RIGHT", -2, 0)
					bs.texte:SetText(nomsSous[k] or "?")
					bs.choisi:SetShown(sousCategorie == k)
					bs:Show()
					y = y + 19
				end
				y = y + 3
			end
		end
		end
		for j = n + 1, #p.boutonsCats do p.boutonsCats[j]:Hide() end
		contC:SetHeight(math.max(10, y))
	end

	local x0 = LARGEUR_C + 20
	p.largeurListe = largeur - x0 - 40
	local fondL = p:CreateTexture(nil, "BACKGROUND")
	fondL:SetPoint("TOPLEFT", f, "TOPLEFT", x0 - 4, hautEncart - 4)
	fondL:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 10)
	fondL:SetColorTexture(0, 0, 0, 0.2)
	local defile = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", f, "TOPLEFT", x0, hautEncart - 8)
	defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, 14)
	p.defile = defile
	p.contenu = CreateFrame("Frame", nil, defile)
	p.contenu:SetSize(p.largeurListe, 10)
	defile:SetScrollChild(p.contenu)
	p.vide = p:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	p.vide:SetPoint("TOP", defile, "TOP", 0, -40)
	p.vide:SetWidth(p.largeurListe - 40)
	p.vide:SetText("Aucun objet ne correspond.")
	p:SetScript("OnShow", function() MajCarnet() end)
	return p
end

--------------------------------------------------------------------------------
-- Fenêtre « Artisanat » : Registre + Items
--------------------------------------------------------------------------------

local fen
local function CreerFenetre()
	if fen or not ns.FenetreOnglets then return end
	fen = ns.FenetreOnglets("GuildUpArtisanat", "Artisanat de la guilde", "Interface\\Icons\\Trade_BlackSmithing",
		{ "Profession-Background-Template2" },
		{ function(f) return ns.CreerPageRegistre and ns.CreerPageRegistre(f) end, CreerPageItems,
			function(f) return ns.CreerPageProjets and ns.CreerPageProjets(f) end },
		{ "Registre", "Items", "Projets de guilde" })
	if ns.AvecSons then ns.AvecSons(fen, "fenetre") end
end

-- onglet 1 Registre, 2 Items, 3 Projets ; déjà ouverte sur cet onglet : la ferme
ns.BasculerArtisanat = function(onglet)
	CreerFenetre()
	if not fen then return end
	onglet = onglet or 1
	if fen:IsShown() and fen.ongletChoisi == onglet then fen:Hide(); return end
	fen:Show()
	fen.Choisir(onglet)
end
ns.OuvrirArtisanat = function(onglet)
	CreerFenetre()
	if not fen then return end
	fen:Show()
	fen.Choisir(onglet or 1)
end

-- outils partagés avec les projets de guilde (GuildUp_Projets.lua)
ns.OutilsCarnet = { RecettesDe = RecettesDe, InfoObjet = InfoObjet, NomMetier = NomMetier, JAi = JAi,
	Developper = Developper, NouveauContexte = NouveauContexte,
	Precharger = Precharger, Sources = Sources, BarreMetier = BarreMetier, Carnets = Carnets }

ns.DiagCarnet2 = function(L)
	local n, m = 0, 0
	for _ in pairs(Recettes()) do n = n + 1 end
	local brut = getmetatable(Sources().objets).__brut or ""
	for _ in brut:gmatch("\n%d+|") do m = m + 1 end
	L(("carnet : %d recettes, sources de %d composants"):format(n, m))
end

--------------------------------------------------------------------------------
-- Évènements : la liste de courses suit les sacs en direct
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
-- le carnet était réduit avant le /reload : la mini-liste revient
C_Timer.After(3, function()
	local db = ns.DB and ns.DB() or {}
	if db.coursesCompact and ns.MontrerMini then ns.MontrerMini() end
end)
for _, nom in ipairs({ "BAG_UPDATE_DELAYED", "GET_ITEM_INFO_RECEIVED", "GUILD_ROSTER_UPDATE",
	"BANKFRAME_OPENED", "BANKFRAME_CLOSED", "PLAYERBANKSLOTS_CHANGED", "PLAYERBANKBAGSLOTS_CHANGED" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local prevu = false
ev:SetScript("OnEvent", function(_, event)
	if event == "BANKFRAME_OPENED" then
		banqueOuverte = true
		C_Timer.After(0.3, function() pcall(NoterBanque) end)
	elseif event == "BANKFRAME_CLOSED" then
		if banqueOuverte then pcall(NoterBanque) end
		banqueOuverte = false
	elseif (event == "PLAYERBANKSLOTS_CHANGED" or event == "PLAYERBANKBAGSLOTS_CHANGED"
		or event == "BAG_UPDATE_DELAYED") and banqueOuverte then
		pcall(NoterBanque)
	end
	if prevu then return end
	if not ((courses and courses:IsShown()) or (page and page:IsVisible()) or (fiche and fiche:IsShown())
		or (ns.MiniVisible and ns.MiniVisible())) then return end
	prevu = true
	C_Timer.After(0.4, function()
		prevu = false
		MajCourses()
		MajCarnet()
		MajFiche()
	end)
end)

--------------------------------------------------------------------------------
-- Alt + clic gauche sur n'importe quel objet du jeu (sacs, banque, chat, butin, personnage,
-- hôtel des ventes…) : ouvre sa fiche dans l'encyclopédie. Le jeu passe tous ces clics
-- « modifiés » par HandleModifiedItemClick : on l'écoute sans rien remplacer (Maj et Ctrl
-- gardent leur rôle habituel).
--------------------------------------------------------------------------------
local dernierAlt = 0
local function AltClic(lien)
	if not (IsAltKeyDown() and not IsShiftKeyDown() and not IsControlKeyDown()) then return end
	if GetMouseButtonClicked and GetMouseButtonClicked() == "RightButton" then return end
	local id = type(lien) == "string" and tonumber(lien:match("item:(%d+)"))
	if not id then return end
	-- un même clic peut passer deux fois par le crochet : on ne garde que le premier
	local t = GetTime()
	if t - dernierAlt < 0.2 then return end
	dernierAlt = t
	ns.OuvrirFiche(id)
end
if HandleModifiedItemClick then hooksecurefunc("HandleModifiedItemClick", AltClic) end

-- rappel dans les infobulles d'objet du jeu
local function LigneAltClic(bulle)
	if bulle and bulle.AddLine then
		bulle:AddLine("Alt + clic gauche : ouvrir l'encyclopédie", 0.4, 0.75, 1)
		bulle:Show()
	end
end
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
		if tooltip == GameTooltip or tooltip == ItemRefTooltip then pcall(LigneAltClic, tooltip) end
	end)
else
	for _, bulle in ipairs({ GameTooltip, ItemRefTooltip }) do
		if bulle and bulle.HookScript then
			pcall(bulle.HookScript, bulle, "OnTooltipSetItem", function(self) pcall(LigneAltClic, self) end)
		end
	end
end
