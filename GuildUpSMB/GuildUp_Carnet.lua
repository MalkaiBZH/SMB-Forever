-- GuildUpSMB : artisanat, dans la fenêtre GuildUpSMB (kit ns.UI, GuildUp_Style.lua).
-- Page fournie ici (ns.AjouterPage) :
--   « artisanat » : onglets Registre (GuildUp_Metiers.lua), Items (ici : tous les objets fabricables,
--     catégories et sous-catégories, recherche, filtres « Pour ma classe », « Jusqu'à mon niveau », niveau requis min / max et « Fabricable par la
--     guilde », tri ; « Besoin », « Ajouter » à un projet), Projets de guilde
--     (GuildUp_Projets.lua) et Commandes (GuildUp_Metiers.lua : commandes reçues et passées).
-- Fenêtres à part, aux couleurs du kit : l'encyclopédie (fiche d'un objet, Alt + clic sur un objet du
-- jeu ; collée à droite de la fenêtre GuildUpSMB ; « Voir dans Items » ouvre l'onglet Items sur un objet
-- fabricable, avec ses artisans) et la bulle 3D des PNJ.
-- Calcul des composants (sous-recettes comprises) pour les projets de guilde : ns.OutilsCarnet.
-- (La page « Mes carnets », listes de courses et mini-liste, a été retirée en 3.7.0 ; les anciennes
-- listes restent dans GuildUpDB.carnets, sans être lues.)
-- Données : GuildUp_Craft.lua (recettes du client Forever) et GuildUp_Sources.lua (sources tirées
-- une fois de QuestieDB). Rien ne dépend d'un autre addon. Aucun message réseau ici.

local NOM_ADDON, ns = ...

local LARGEUR_FICHE, HAUTEUR_FICHE = 360, 520   -- encyclopédie
local PROFONDEUR_MAX = 6

local Erreur = ns.Erreur
local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
-- « niv. 12-18 » (ou « niv. 12 ») d'un PNJ, rien si inconnu
local function TexteNiveaux(p)
	if not (p.min and p.min > 0) then return "" end
	if p.max and p.max ~= p.min then return " niv. " .. p.min .. "-" .. p.max end
	return " niv. " .. p.min
end
local Simplifier = ns.Simplifier

--------------------------------------------------------------------------------
-- Données : recettes et sources
--------------------------------------------------------------------------------

local recettes        -- [sort] = { sort, metier, niveau, jaune, difficulte, objet, rendement, composants = { {objet, n}, … } }
                      -- niveau : requis (1 = inconnu, le client ne le renseigne presque jamais) ;
                      -- jaune : la recette commence à donner moins de points (0 = inconnu) ;
                      -- difficulte : la plus grande des deux (pour trier)
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
	for sort, metier, niveau, jaune, objet, rend, compos in (ns.DONNEES_CRAFT or ""):gmatch("(%d+):(%a+):(%d+):(%d+):(%d+):(%d+):([^\n]*)") do
		local r = { sort = tonumber(sort), metier = metier, niveau = tonumber(niveau), jaune = tonumber(jaune),
			objet = tonumber(objet), rendement = math.max(1, tonumber(rend) or 1), composants = {} }
		r.difficulte = math.max(r.niveau, r.jaune)
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
	for _, l in pairs(parObjet) do table.sort(l, function(a, b) return a.difficulte < b.difficulte end) end
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
-- Recette à suivre pour fabriquer un objet dans un calcul automatique (projets de guilde) :
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
	sacs = ok1 and tonumber(sacs) or 0
	local enDirect = math.max(0, (ok2 and tonumber(tout) or sacs) - sacs)
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
-- « Forge 125 » (niveau requis connu), « Forge (jaune à 125) », ou « Forge » seul
local function TexteRecette(r)
	local m = NomMetier(r.metier)
	if (r.niveau or 1) > 1 then return m .. " " .. r.niveau end
	if (r.jaune or 0) > 0 then return m .. " |cff999999(jaune à " .. r.jaune .. ")|r" end
	return m
end
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
-- Habillage : kit d'interface ns.UI (GuildUp_Style.lua), et ce qui manque au kit pour le carnet
-- (barre d'avancement, croix, fenêtre à part, menus, cadres de section)
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI.C
local MARGE = 16
local PISTE = { 0.165, 0.137, 0.094, 1 }          -- piste des barres, filets légers entre les lignes
local FOND_MENU = { 0.05, 0.043, 0.035, 0.98 }
local VERT, GRIS = "|cff6fd08c", "|cff9c937f"  -- réuni / discret
local ICONE_INCONNUE = "Interface\\Icons\\INV_Misc_QuestionMark"

-- Barre d'avancement plate (piste sombre, remplissage doré) : SetMinMaxValues / SetValue
local function Barre(parent, hauteur)
	local b = CreateFrame("StatusBar", nil, parent)
	b:SetHeight(hauteur or 8)
	b:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
	b:SetStatusBarColor(C.orFonce[1], C.orFonce[2], C.orFonce[3], 1)
	local piste = b:CreateTexture(nil, "BACKGROUND")
	piste:SetAllPoints(b)
	piste:SetColorTexture(unpack(PISTE))
	b:SetMinMaxValues(0, 1)
	b:SetValue(0)
	return b
end

-- Petite croix (fermer une fenêtre, retirer une ligne) : bouton fantôme du kit
-- croix plate du kit (fermer, retirer) ; le clic est posé par l'appelant (SetScript OnClick)
local function Croix(parent, taille)
	return UI.Fermer(parent, nil, taille or 22)
end

-- Fenêtre à part (encyclopédie) : cadre sombre à bordure dorée, bandeau de titre qu'on glisse pour
-- la déplacer, croix de fermeture ; Échap la ferme
local HAUTEUR_BANDEAU = 30
local function FenetreKit(nom, titre, largeur, hauteur)
	local f = CreateFrame("Frame", nom, UIParent, "BackdropTemplate")
	UI.Habiller(f, C.fond, C.bordFort)
	f:SetSize(largeur, hauteur)
	f:SetFrameStrata("HIGH")
	f:SetToplevel(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	tinsert(UISpecialFrames, nom)
	local tete = UI.Cadre(f, C.bandeau)
	tete:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
	tete:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
	tete:SetHeight(HAUTEUR_BANDEAU)
	tete:EnableMouse(true)
	tete:RegisterForDrag("LeftButton")
	tete:SetScript("OnDragStart", function() f:StartMoving() end)
	tete:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
	local filet = UI.Filet(tete)
	filet:SetPoint("BOTTOMLEFT", tete, "BOTTOMLEFT", 0, 0)
	filet:SetPoint("BOTTOMRIGHT", tete, "BOTTOMRIGHT", 0, 0)
	f.titre = UI.Texte(tete, "GameFontNormal", C.ors)
	f.titre:SetPoint("LEFT", tete, "LEFT", 12, 0)
	f.titre:SetText(titre)
	f.fermer = Croix(tete, 20)
	f.fermer:SetPoint("RIGHT", tete, "RIGHT", -6, 0)
	f.fermer:SetScript("OnClick", function() f:Hide() end)
	f.tete = tete
	if ns.AvecSons then ns.AvecSons(f, "fenetre") end
	f:Hide()
	return f
end

-- Menus déroulants (ns.CadreMenu, GuildUp_Outils.lua) aux couleurs du kit
local function Menu(nom)
	local m = ns.CadreMenu(nom)
	UI.Habiller(m, FOND_MENU, C.bordFort)
	return m
end
local function LigneMenu(m, i)
	local b = ns.BoutonMenu(m, i)
	if b.kit ~= true then
		b.kit = true
		local h = b.GetHighlightTexture and b:GetHighlightTexture()
		if h and h.SetColorTexture then h:SetColorTexture(1, 1, 1, 0.08) end
	end
	return b
end

-- Cadre autour d'une section (encyclopédie) : une carte du kit, sous les lignes
local function CadreSection(pool, parent, i)
	local c = pool[i]
	if not c then
		c = UI.Cadre(parent, C.carte, C.bord)
		c:EnableMouse(false)
		pool[i] = c
	end
	c:SetFrameLevel(parent:GetFrameLevel())
	c:Show()
	return c
end

-- En-tête de section (bande dorée discrète, filet) ; l.bande = false à la création de la ligne
local function StylerTitre(l, actif)
	if not l.bande then
		l.bande = l:CreateTexture(nil, "BACKGROUND", nil, 1)
		l.bande:SetAllPoints(l)
		l.bande:SetColorTexture(C.orFonce[1], C.orFonce[2], C.orFonce[3], 0.10)
		l.trait = l:CreateTexture(nil, "BORDER")
		l.trait:SetHeight(1)
		l.trait:SetPoint("BOTTOMLEFT", l, "BOTTOMLEFT", 0, 0)
		l.trait:SetPoint("BOTTOMRIGHT", l, "BOTTOMRIGHT", 0, 0)
		l.trait:SetColorTexture(unpack(C.bordMoyen))
	end
	l.bande:SetShown(actif)
	l.trait:SetShown(actif)
end

-- Page Artisanat de la fenêtre GuildUpSMB : est-elle à l'écran (et sur cet onglet) ?
local pageArtisanat
local function ArtisanatVisible(onglet)
	if not (ns.PageInterface and ns.PageInterface() == "artisanat" and pageArtisanat) then return false end
	return not onglet or pageArtisanat.onglet == onglet
end
ns.ArtisanatVisible = ArtisanatVisible

--------------------------------------------------------------------------------
-- Calcul : arbre des composants et matériaux de base
--------------------------------------------------------------------------------

-- Contexte d'un calcul : stock restant partagé par toutes les branches (un objet en stock ne sert
-- qu'une fois, et le surplus d'une fabrication à rendement > 1 profite aux autres branches) et
-- objets « à obtenir tels quels » (non développés).
--   avecMesObjets : le stock part de mes sacs + banque ; sinon de zéro (projets de guilde)
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

--------------------------------------------------------------------------------
-- Encyclopédie : fiche d'un objet (clic sur un composant) — d'où il vient, qui le fabrique
--------------------------------------------------------------------------------

local fiche
local lignesFiche = {}
local CreerFiche, MajFiche
local ouvertsFiche = {}   -- [clé] = true : sections / sous-catégories dépliées (tout plié par défaut)
local PLUS, MOINS = "|cfff1cf6b+|r  ", "|cfff1cf6b-|r  "

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
	l.survol = UI.Survol(l, 0.06)
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetSize(14, 14)
	l.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	l.texte = UI.Texte(l, "GameFontHighlightSmall", C.texte)
	l.bande = false
	l.action, l.bulle, l.objetBulle, l.pnj, l.pnjInfo = false, false, false, false, false
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
		fiche.nom:SetTextColor(unpack(C.ors))
		fiche.jai:SetText("Alt + clic sur un objet du jeu pour voir sa fiche.")
		fiche.icone:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
		fiche.besoin:Hide()
		fiche.ajouter:Hide()
		fiche.lien:Hide()
		fiche.items:Hide()
		for _, l in ipairs(lignesFiche) do l:Hide() end
		for _, c in ipairs(fiche.cadres or {}) do c:Hide() end
		fiche.defile:Hauteur(10)
		return
	end
	local objet = fiche.objet
	local nom, lien, qualite, icone = InfoObjet(objet)
	if not nom then Precharger(objet) end
	fiche.icone:SetTexture(icone or ICONE_INCONNUE)
	fiche.nom:SetText(nom or "chargement…")
	local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
	if qc then fiche.nom:SetTextColor(qc.r, qc.g, qc.b) else fiche.nom:SetTextColor(unpack(C.ors)) end
	local sacs, banque = OuSont(objet)
	fiche.jai:SetText(banque and ("Tu en as %d dans tes sacs · %d à la banque"):format(sacs, banque)
		or ("Tu en as %d dans tes sacs · banque inconnue (ouvre-la une fois)"):format(sacs))
	fiche.besoin:Show()
	local fabricable = RecettesDe(objet) ~= nil
	fiche.ajouter:SetShown(fabricable)
	fiche.lien:Show()
	fiche.items:SetShown(fabricable)

	local y, i = 4, 0
	local contenu = fiche.contenu
	local nCadres, debutSection = 0, nil
	fiche.cadres = fiche.cadres or {}
	local function FermerSection()
		if not debutSection then return end
		nCadres = nCadres + 1
		local c = CadreSection(fiche.cadres, contenu, nCadres)
		c:ClearAllPoints()
		c:SetPoint("TOPLEFT", contenu, "TOPLEFT", 0, -(debutSection - 4))
		c:SetPoint("RIGHT", contenu, "RIGHT", 0, 0)
		c:SetHeight(y - debutSection + 8)
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
			local h = fiche.contenu:GetHeight()
			fiche.defile:SetVerticalScroll(math.min(defil, math.max(0, h - fiche.defile:GetHeight())))
			fiche.defile:Hauteur(h) -- (replace la barre de défilement)
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
		l:SetFrameLevel(contenu:GetFrameLevel() + 3)
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", contenu, "TOPLEFT", 4, -y)
		l:SetPoint("RIGHT", contenu, "RIGHT", -4, 0)
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
		l.texte:SetTextColor(unpack(opts.titre and C.ors or opts.sous and C.orFonce or C.texte))
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
			Ajouter(("%s%s"):format(TexteRecette(r),
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
				Ajouter(("- %s (%s %s) · %s"):format(NomJoueur(a.nom), NomMetier(a.metier), a.niveau or "?", etat), 2, {
					action = (a.enLigne and not a.moi) and function()
						if ns.CommanderObjet then ns.CommanderObjet(a.cle, a.nom, objet, fiche.qte) end
					end or nil,
					bulle = (a.enLigne and not a.moi) and ("Clic : commander à " .. NomJoueur(a.nom)) or nil })
			end
		end
		Espace()
	end
	local appris = RecetteDeFormule(objet)
	if appris then
		Ajouter("Apprend", 0, { titre = true, icone = ns.IconeMetierCode and ns.IconeMetierCode(appris.metier) or "Interface\\Icons\\INV_Scroll_03" })
		Ajouter(TexteRecette(appris), 1, { sous = true })
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
			table.sort(l, function(a, b) if a.difficulte ~= b.difficulte then return a.difficulte < b.difficulte end return a.sort < b.sort end)
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
				Ajouter(("|cff999999%s|r  %s%s|r  |cff999999(x%d)|r"):format(r.difficulte > 1 and tostring(r.difficulte) or "", qcU and qcU.hex or "|cffffffff", nomU or "…", qte), 2, {
					icone = iconeU, objet = r.objet > 0 and r.objet or nil,
					action = r.objet > 0 and function() ns.OuvrirFiche(r.objet) end or nil })
			end
		end
		Espace()
	end
	FermerSection()
	for j = nCadres + 1, #fiche.cadres do fiche.cadres[j]:Hide() end
	for j = i + 1, #lignesFiche do lignesFiche[j]:Hide() end
	fiche.defile:Hauteur(math.max(10, y))
end

-- Bulle d'un monstre ou d'un marchand : nom, rang, niveau, zone… et son modèle 3D, dans un seul cadre
-- (sombre à bordure dorée, comme la fenêtre GuildUpSMB)
local LARGEUR_BULLE, HAUTEUR_MODELE = 240, 210
local NOMS_RANGS = { "Élite", "Rare élite", "Boss", "Rare" }
local COULEURS_RANGS = { { 1, 0.82, 0 }, { 0.75, 0.75, 1 }, { 1, 0.3, 0.3 }, { 0.75, 0.75, 1 } }
local apercu
local function CreerBullePnj()
	apercu = CreateFrame("Frame", "GuildUpApercu3D", UIParent, "BackdropTemplate")
	apercu:SetWidth(LARGEUR_BULLE)
	apercu:SetFrameStrata("TOOLTIP")
	apercu:SetClampedToScreen(true)
	UI.Habiller(apercu, FOND_MENU, C.bordFort)
	local function Texte(police, r, g, b)
		local t = apercu:CreateFontString(nil, "OVERLAY", police)
		t:SetWidth(LARGEUR_BULLE - 20)
		t:SetJustifyH("LEFT")
		if r then t:SetTextColor(r, g, b) end
		return t
	end
	apercu.nom = Texte("GameFontNormalLarge")
	apercu.sous = Texte("GameFontHighlightSmall", C.gris[1], C.gris[2], C.gris[3])
	apercu.infos = Texte("GameFontHighlightSmall", C.texte[1], C.texte[2], C.texte[3])
	apercu.infos:SetSpacing(2)
	-- cadre du modèle : fond sombre et filet doré
	apercu.scene = CreateFrame("Frame", nil, apercu)
	apercu.scene:SetSize(LARGEUR_BULLE - 16, HAUTEUR_MODELE)
	local fond = apercu.scene:CreateTexture(nil, "BACKGROUND")
	fond:SetAllPoints(apercu.scene)
	fond:SetColorTexture(unpack(C.champ))
	for _, bord in ipairs({ { "TOPLEFT", "TOPRIGHT" }, { "BOTTOMLEFT", "BOTTOMRIGHT" } }) do
		local t = apercu.scene:CreateTexture(nil, "BORDER")
		t:SetColorTexture(unpack(C.bordMoyen))
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
	apercu.aide = Texte("GameFontNormalSmall", C.vert[1], C.vert[2], C.vert[3])
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
	if NOMS_RANGS[rang] then quoi[#quoi + 1] = ("|cff%02x%02x%02x%s|r"):format(math.floor(c[1] * 255), math.floor(c[2] * 255), math.floor(c[3] * 255), NOMS_RANGS[rang]) end
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
	local f = FenetreKit("GuildUpEncyclopedie", "Encyclopédie", LARGEUR_FICHE, HAUTEUR_FICHE)
	f:SetPoint("CENTER")
	-- l'objet : icône (survol : infobulle du jeu), nom, ce que j'en ai
	f.icone = f:CreateTexture(nil, "ARTWORK")
	f.icone:SetSize(40, 40)
	f.icone:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -42)
	f.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	local zoneIcone = CreateFrame("Frame", nil, f)
	zoneIcone:SetAllPoints(f.icone)
	zoneIcone:EnableMouse(true)
	zoneIcone:SetScript("OnEnter", function(self)
		if not f.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, f.objet)
		GameTooltip:Show()
	end)
	zoneIcone:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.nom = UI.Texte(f, "GameFontNormalLarge", C.ors)
	f.nom:SetPoint("TOPLEFT", f.icone, "TOPRIGHT", 10, -2)
	f.nom:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.jai = UI.Texte(f, "GameFontHighlightSmall", C.gris)
	f.jai:SetPoint("TOPLEFT", f.nom, "BOTTOMLEFT", 0, -5)
	f.jai:SetPoint("RIGHT", f, "RIGHT", -14, 0)
	f.jai:SetWordWrap(true)
	-- actions : besoin de la guilde, ajouter à une liste (objets fabricables), lien dans la discussion,
	-- voir dans l'onglet Items (objets fabricables : qui sait le fabriquer, commander)
	f.besoin = UI.Bouton(f, "Besoin", "fantome", 66, 26)
	f.besoin:SetPoint("TOPLEFT", f, "TOPLEFT", 14, -94)
	UI.Infobulle(f.besoin, "Ajouter aux besoins", "La guilde verra que tu cherches cet objet.")
	f.besoin:SetScript("OnClick", function()
		if f.objet and ns.AjouterBesoin and ns.AjouterBesoin(f.objet, f.qte or 1) and ns.Notifier then
			ns.Notifier(nil, "Besoin ajouté", (InfoObjet(f.objet) or "Objet") .. " est dans tes besoins : la guilde le voit.", "aucun", function() end)
		end
	end)
	f.ajouter = UI.Bouton(f, "Ajouter", "or", 76, 26)
	f.ajouter:SetPoint("LEFT", f.besoin, "RIGHT", 6, 0)
	f.ajouter:SetScript("OnClick", function(self)
		if ns.MontrerMenuProjets and f.objet then ns.MontrerMenuProjets(self, f.objet) end
	end)
	UI.Infobulle(f.ajouter, "Ajouter à un projet", "Choisis un de tes projets de guilde, ou crée-en un nouveau.")
	f.lien = UI.Bouton(f, "Lien", "fantome", 50, 26)
	f.lien:SetPoint("LEFT", f.ajouter, "RIGHT", 6, 0)
	f.lien:SetScript("OnClick", function()
		local _, lien = InfoObjet(f.objet)
		if lien then
			if ChatEdit_InsertLink and ChatEdit_InsertLink(lien) then return end
			if ChatFrame_OpenChat then ChatFrame_OpenChat(lien) end
		end
	end)
	UI.Infobulle(f.lien, "Lien", "Met le lien de l'objet dans la discussion.")
	f.items = UI.Bouton(f, "Voir dans Items", "fantome", 110, 26)
	f.items:SetPoint("LEFT", f.lien, "RIGHT", 6, 0)
	f.items:SetScript("OnClick", function()
		if f.objet and ns.MontrerObjetItems then ns.MontrerObjetItems(f.objet) end
	end)
	UI.Infobulle(f.items, "Voir dans Items", "Ouvre l'onglet Items de la page Artisanat sur cet objet : qui, dans la guilde, sait le fabriquer, et le bouton Commander.")
	local filet = UI.Filet(f)
	filet:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -130)
	filet:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -130)
	-- sections : fabriqué, apprend, récolte, marchands, butin, contenants, quêtes, utilisé dans
	f.defile = UI.Liste(f)
	f.defile:SetPoint("TOPLEFT", f, "TOPLEFT", 10, -138)
	f.defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 10)
	f.contenu = f.defile.contenu
	f.contenu:SetWidth(LARGEUR_FICHE - 22)
	f.objet, f.qte, f.cadres = false, 1, {}
	f:SetScript("OnHide", function() if ns.CacherModele then ns.CacherModele() end end)
	fiche = f
	return f
end

-- Ouvre la fiche d'un objet (qte : quantité proposée pour les commandes et les besoins)
ns.FicheCadre = function() return fiche end
-- où poser l'encyclopédie quand on l'ouvre : collée à droite de la fenêtre GuildUpSMB si elle est
-- ouverte (elle la suit tant qu'on ne la déplace pas), sinon à droite de l'écran
local function PlacerFiche(origine)
	fiche:ClearAllPoints()
	if origine and origine:IsShown() then
		fiche:SetPoint("TOPLEFT", origine, "TOPRIGHT", 6, 0)
	else
		fiche:SetPoint("CENTER", UIParent, "CENTER", 260, 0)
	end
end
ns.OuvrirFiche = function(objet, qte, origine)
	if not fiche then CreerFiche() end
	if not fiche:IsShown() or (objet and objet ~= fiche.objet) then wipe(ouvertsFiche) end
	if not fiche:IsShown() then
		-- d'où vient-on ? fenêtre indiquée, sinon la fenêtre GuildUpSMB si elle est ouverte
		local interface = _G.GuildUpInterface
		origine = origine or (interface and interface:IsShown() and interface) or nil
		PlacerFiche(origine)
	end
	if objet then fiche.objet = objet end
	fiche.qte = (qte and qte > 0) and qte or 1
	fiche:Show()
	fiche:Raise()
	fiche.defile:Haut()
	MajFiche()
end

--------------------------------------------------------------------------------
-- Onglet « Items » de la page Artisanat : tous les objets fabricables, catégories à gauche (et
-- sous-catégories de la choisie), recherche, tri ; boutons « Besoin » (ajoute aux besoins de la
-- guilde) et « Ajouter » (à une de mes listes ou un de mes projets, ou à un nouveau)
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

-- sous-catégories présentes dans une catégorie (triées comme le jeu : classe puis sous-classe), et
-- leur nombre d'objets (nombreSous[clé])
local sousParCat, nombreSous = {}, {}
local function SousCategories(i)
	if sousParCat[i] then return sousParCat[i] end
	local cat, vus, liste = CATEGORIES_ITEMS[i], {}, {}
	if cat.classes then
		for _, o in ipairs(Catalogue()) do
			if cat.classes[o[5] or -1] then
				local k = SousClasse(o[1])
				if k then
					if not vus[k] then vus[k] = true; liste[#liste + 1] = k end
					nombreSous[k] = (nombreSous[k] or 0) + 1
				end
			end
		end
	end
	table.sort(liste)
	-- une seule sous-catégorie : inutile de l'afficher
	if #liste < 2 then liste = {} end
	sousParCat[i] = liste
	return liste
end


-- menu « Ajouter à un projet » : mes projets de guilde + nouveau projet
local menuProjets
local function MontrerMenuProjets(bouton, objet)
	menuProjets = menuProjets or Menu("GuildUpMenuProjets")
	local m = menuProjets
	local choix = { { titre = "Projets de guilde" } }
	local moi = ns.Normaliser and ns.Normaliser(UnitName("player")) or UnitName("player")
	for _, p in ipairs(ns.ListeProjets and ns.ListeProjets() or {}) do
		if p.auteur == moi then choix[#choix + 1] = { projet = p } end
	end
	choix[#choix + 1] = { nouveauProjet = true }
	local nomObjet = (InfoObjet(objet)) or "Objet"
	for i, ch in ipairs(choix) do
		local b = LigneMenu(m, i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", m, "TOPLEFT", 4, -4 - (i - 1) * 20)
		b:SetPoint("RIGHT", m, "RIGHT", -4, 0)
		b:Enable()
		b.texte:SetPoint("LEFT", b, "LEFT", ch.titre and 4 or 12, 0)
		b.texte:SetFontObject(ch.titre and "GameFontNormal" or "GameFontHighlightSmall")
		if ch.titre then
			b.texte:SetText(ch.titre)
			b:SetScript("OnClick", nil)
			b:Disable()
		elseif ch.projet then
			local p = ch.projet
			b.texte:SetText(p.nom)
			b:SetScript("OnClick", function()
				m:Hide()
				if ns.AjouterAProjet then ns.AjouterAProjet(p.id, objet, 1) end
				if ns.Notifier then ns.Notifier("commandes", "Projet de guilde", nomObjet .. " ajouté au projet « " .. p.nom .. " »", "aucun", function() ns.OuvrirProjet(p.id) end) end
			end)
		else
			b.texte:SetText(VERT .. "+ Nouveau projet…|r")
			b:SetScript("OnClick", function()
				m:Hide()
				if ns.NouveauProjet then ns.NouveauProjet({ objet = objet }) end
			end)
		end
		b:Show()
	end
	for i = #choix + 1, #m.boutons do m.boutons[i]:Hide() end
	m:SetSize(210, 8 + #choix * 20)
	m.ancre = bouton
	m:ClearAllPoints()
	m:SetPoint("TOPLEFT", bouton, "BOTTOMLEFT", 0, -2)
	m:Show()
end
ns.MontrerMenuProjets = MontrerMenuProjets -- (bouton « Ajouter » de l'encyclopédie, plus haut)

-- Rangée d'un objet : icône, nom (qualité), niveau et fabrication, « Besoin », « Ajouter »
local HAUTEUR_ITEM, ECART_ITEM = 52, 6
local objetChoisi, objetChoisiLie -- objet montré dans le panneau de détail (et s'il est lié quand ramassé)
local RendreItems -- (défini plus bas)
local function CreerLigneItem(parent)
	local b = UI.Rangee(parent, HAUTEUR_ITEM)
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(36, 36)
	b.icone:SetPoint("LEFT", b, "LEFT", 10, 0)
	b.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	b.nom = UI.Texte(b, "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b.icone, "TOPRIGHT", 10, -2)
	b.nom:SetPoint("RIGHT", b, "RIGHT", -10, 0)
	b.info = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.info:SetPoint("TOPLEFT", b.nom, "BOTTOMLEFT", 0, -6)
	b.info:SetPoint("RIGHT", b, "RIGHT", -10, 0)
	b:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Clic : détails et artisans de la guilde, à droite", 0.6, 0.6, 0.6)
		GameTooltip:AddLine("Maj-clic : lien dans la discussion", 0.6, 0.6, 0.6)
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
		objetChoisi, objetChoisiLie = self.objet, self.lie
		RendreItems()
	end)
	b.objet = false
	return b
end

-- Filtres « Pour ma classe » et « Jusqu'à mon niveau » (db.itemsClasse, db.itemsNiveau)
-- Armes (classe d'objet 2) : sous-classes que la classe sait manier (règles de Vanilla).
--   0 hache 1M, 1 hache 2M, 2 arc, 3 fusil, 4 masse 1M, 5 masse 2M, 6 arme d'hast, 7 épée 1M,
--   8 épée 2M, 10 bâton, 13 arme de pugilat, 15 dague, 16 arme de jet, 18 arbalète, 19 baguette
local ARMES_CLASSE = {
	WARRIOR = { [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [10] = true, [13] = true, [15] = true, [16] = true, [18] = true },
	PALADIN = { [0] = true, [1] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true },
	HUNTER  = { [0] = true, [1] = true, [2] = true, [3] = true, [6] = true, [7] = true, [8] = true, [10] = true, [13] = true, [15] = true, [16] = true, [18] = true },
	ROGUE   = { [2] = true, [3] = true, [4] = true, [7] = true, [13] = true, [15] = true, [16] = true, [18] = true },
	PRIEST  = { [4] = true, [10] = true, [15] = true, [19] = true },
	SHAMAN  = { [0] = true, [1] = true, [4] = true, [5] = true, [10] = true, [13] = true, [15] = true },
	MAGE    = { [7] = true, [10] = true, [15] = true, [19] = true },
	WARLOCK = { [7] = true, [10] = true, [15] = true, [19] = true },
	DRUID   = { [4] = true, [5] = true, [10] = true, [13] = true, [15] = true },
}
-- Armures (classe d'objet 4) : type principal (1 tissu, 2 cuir, 3 mailles, 4 plaques) avant et à
-- partir du niveau 40, boucliers (6) et reliques (7 libram, 8 idole, 9 totem)
local ARMURE_CLASSE = {
	WARRIOR = { 3, 4, bouclier = true }, PALADIN = { 3, 4, bouclier = true, relique = 7 },
	HUNTER = { 2, 3 }, SHAMAN = { 2, 3, bouclier = true, relique = 9 },
	ROGUE = { 2, 2 }, DRUID = { 2, 2, relique = 8 },
	PRIEST = { 1, 1 }, MAGE = { 1, 1 }, WARLOCK = { 1, 1 },
}
local cacheEquipement = {} -- [objet] = { classe, sous-classe, emplacement } ou false
local function PourMaClasse(id)
	local e = cacheEquipement[id]
	if e == nil then
		e = false
		if InfoInstant then
			local ok, _, _, _, emplacement, _, classe, sous = pcall(InfoInstant, id)
			if ok and classe then e = { classe, sous, emplacement } end
		end
		cacheEquipement[id] = e
	end
	if not e then return true end
	local _, maClasse = UnitClass("player")
	local classe, sous, emplacement = e[1], e[2], e[3]
	if classe == 2 then
		local armes = ARMES_CLASSE[maClasse or ""]
		return not armes or armes[sous] == true
	elseif classe == 4 then
		local a = ARMURE_CLASSE[maClasse or ""]
		if not a then return true end
		if sous == 0 or emplacement == "INVTYPE_CLOAK" then return true end -- bijoux, capes (tissu pour tous)
		if sous == 6 then return a.bouclier == true end
		if sous == 7 or sous == 8 or sous == 9 then return a.relique == sous end
		if sous >= 1 and sous <= 4 then
			return sous == (((UnitLevel("player") or 1) >= 40) and a[2] or a[1])
		end
	end
	return true -- consommables, artisanat, sacs… : pas concernés
end
-- niveau requis hors de [min, max] (objet en cache) ; inconnu : gardé (demandé au serveur)
local function HorsNiveaux(id, min, max)
	local nom, _, _, _, requis = InfoObjet(id)
	if not nom then
		if ns.Precharger then ns.Precharger(id) end
		return false
	end
	requis = requis or 0
	return (min and requis < min) or (max and requis > max) or false
end
-- un autre membre de la guilde sait le fabriquer (registre des métiers)
local function FabricableParLaGuilde(id)
	for _, art in ipairs(ns.ArtisansDe and ns.ArtisansDe(id) or {}) do
		if not art.moi then return true end
	end
	return false
end

-- Onglet Items : la liste (150 objets au plus) selon la catégorie, la recherche, les filtres et le tri
RendreItems = function()
	if not page then return end
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
		local db = ns.DB and ns.DB()
		if garde and db and db.itemsClasse then garde = PourMaClasse(o[1]) end
		if garde and db and (db.itemsNiveau or db.itemsNivMin or db.itemsNivMax) then
			local max = db.itemsNivMax
			if db.itemsNiveau then max = math.min(max or 999, UnitLevel("player") or 1) end
			garde = not HorsNiveaux(o[1], db.itemsNivMin, max)
		end
		if garde and db and db.itemsGuilde then garde = FabricableParLaGuilde(o[1]) end
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
	local contenu = page.liste.contenu
	local y = 0
	for i, o in ipairs(res) do
		local b = lignesItems[i] or CreerLigneItem(contenu)
		lignesItems[i] = b
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", contenu, "TOPLEFT", 0, -y)
		b:SetPoint("RIGHT", contenu, "RIGHT", 0, 0)
		b.objet, b.lie = o[1], o[7] -- (lié quand ramassé : pas de « Besoin » dans le détail)
		local choisi = (o[1] == objetChoisi)
		b:SetBackdropColor(unpack(choisi and C.actif or C.carte))
		b:Fort(choisi)
		local nom, _, qualite, icone = InfoObjet(o[1])
		b.icone:SetTexture(icone or ICONE_INCONNUE)
		b.nom:SetText(nom or o[3])
		local qc = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite or o[2] or 1]
		if qc then b.nom:SetTextColor(qc.r, qc.g, qc.b) else b.nom:SetTextColor(unpack(C.texte)) end
		local niv = (o[6] or 0) > 0 and ("Niv. %d"):format(o[6]) or nil
		local recs = RecettesDe(o[1])
		if recs then
			local r = recs[1]
			local moi, enLigne = false, 0
			for _, art in ipairs(ns.ArtisansDe and ns.ArtisansDe(o[1]) or {}) do
				if art.moi then moi = true elseif art.enLigne then enLigne = enLigne + 1 end
			end
			b.info:SetText((niv and (niv .. " · ") or "") .. "Fabriqué : " .. TexteRecette(r)
				.. (moi and (" · " .. VERT .. "tu sais le faire|r")
				or enLigne > 0 and (" · " .. VERT .. ("%d artisan%s en ligne"):format(enLigne, enLigne > 1 and "s" or "") .. "|r") or ""))
		else
			local s = Sources().objets[o[1]] and "Sources connues · clic pour la fiche" or nil
			b.info:SetText((niv or "") .. ((niv and s) and " · " or "") .. (s or ""))
		end
		b:Show()
		y = y + HAUTEUR_ITEM + ECART_ITEM
	end
	for i = #res + 1, #lignesItems do lignesItems[i]:Hide() end
	page.liste:Hauteur(y)
	page.compte:SetText(total > MAX_AFFICHES and ("%d objets (%d affichés)"):format(total, MAX_AFFICHES)
		or ("%d objet%s"):format(total, total > 1 and "s" or ""))
	page.vide:SetShown(#res == 0)
	if page.MajDetail then page.MajDetail() end
end

local LARGEUR_CATS = 160
local function CreerPageItems(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	page = p

	-- à droite des onglets : rappel des clics
	local indice = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	indice:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -24)
	indice:SetJustifyH("RIGHT")
	indice:SetText("Clic : fiche de l'objet · Maj-clic : lien dans la discussion")

	-- catégories (gauche), et sous la choisie ses sous-catégories
	p.cats = UI.Liste(p)
	p.cats:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -56)
	p.cats:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", MARGE, MARGE)
	p.cats:SetWidth(LARGEUR_CATS + 8)
	p.boutonsCats = {}
	local function BoutonCat(n)
		local bt = p.boutonsCats[n]
		if bt then return bt end
		bt = CreateFrame("Button", nil, p.cats.contenu, "BackdropTemplate")
		UI.Habiller(bt, { 0, 0, 0, 0 }, { 0, 0, 0, 0 })
		bt.compte = UI.Texte(bt, "GameFontHighlightSmall", C.gris)
		bt.compte:SetPoint("RIGHT", bt, "RIGHT", -8, 0)
		bt.compte:SetJustifyH("RIGHT")
		bt.texte = UI.Texte(bt, "GameFontHighlight", C.texte)
		bt.texte:SetPoint("RIGHT", bt.compte, "LEFT", -4, 0)
		UI.Survol(bt, 0.05)
		if ns.SonsSurBoutons then ns.SonsSurBoutons(bt) end
		bt:SetScript("OnClick", function(self)
			if self.sous then
				sousCategorie = (sousCategorie ~= self.sous) and self.sous or nil
			else
				categorieItems = self.cat
				sousCategorie = nil
			end
			p.liste:Haut()
			RendreItems()
		end)
		p.boutonsCats[n] = bt
		return bt
	end
	p.MajCategories = function()
		local y, n = 0, 0
		local contenu = p.cats.contenu
		for i, c in ipairs(CATEGORIES_ITEMS) do
			local nombre = NombreCategorie(i)
			n = n + 1
			local bt = BoutonCat(n)
			bt:ClearAllPoints()
			bt:SetPoint("TOPLEFT", contenu, "TOPLEFT", 0, -y)
			bt:SetPoint("RIGHT", contenu, "RIGHT", 0, 0)
			bt:SetHeight(32)
			bt.cat, bt.sous = i, false
			local subs = SousCategories(i)
			local ouvert = i == categorieItems
			local choisi = ouvert and not sousCategorie
			bt.texte:SetFontObject("GameFontHighlight")
			bt.texte:ClearAllPoints()
			bt.texte:SetPoint("LEFT", bt, "LEFT", 10, 0)
			bt.texte:SetPoint("RIGHT", bt.compte, "LEFT", -4, 0)
			bt.texte:SetText(c.nom .. ((#subs > 0) and ("  " .. GRIS .. (ouvert and "-" or "+") .. "|r") or ""))
			bt.texte:SetTextColor(unpack(ouvert and C.ors or C.texte))
			bt.compte:SetText(tostring(nombre))
			bt:SetBackdropColor(unpack(choisi and C.actif or { 0, 0, 0, 0 }))
			bt:SetBackdropBorderColor(unpack(choisi and C.bordMoyen or { 0, 0, 0, 0 }))
			bt:SetEnabled(nombre > 0)
			bt:SetAlpha(nombre > 0 and 1 or 0.45)
			bt:Show()
			y = y + 34
			if ouvert then
				for _, k in ipairs(subs) do
					n = n + 1
					local bs = BoutonCat(n)
					bs:ClearAllPoints()
					bs:SetPoint("TOPLEFT", contenu, "TOPLEFT", 12, -y)
					bs:SetPoint("RIGHT", contenu, "RIGHT", 0, 0)
					bs:SetHeight(26)
					bs.cat, bs.sous = i, k
					local sc = sousCategorie == k
					bs.texte:SetFontObject("GameFontHighlightSmall")
					bs.texte:ClearAllPoints()
					bs.texte:SetPoint("LEFT", bs, "LEFT", 10, 0)
					bs.texte:SetPoint("RIGHT", bs.compte, "LEFT", -4, 0)
					bs.texte:SetText(nomsSous[k] or "?")
					bs.texte:SetTextColor(unpack(sc and C.ors or C.texte))
					bs.compte:SetText(tostring(nombreSous[k] or ""))
					bs:SetBackdropColor(unpack(sc and C.actif or { 0, 0, 0, 0 }))
					bs:SetBackdropBorderColor(unpack(sc and C.bordMoyen or { 0, 0, 0, 0 }))
					bs:SetEnabled(true)
					bs:SetAlpha(1)
					bs:Show()
					y = y + 27
				end
				y = y + 4
			end
		end
		for j = n + 1, #p.boutonsCats do p.boutonsCats[j]:Hide() end
		p.cats:Hauteur(y)
	end

	-- droite : recherche, tri, compte, liste des objets
	local x0 = MARGE + LARGEUR_CATS + 8 + 10
	p.tri = UI.Bouton(p, TRIS[triItems], "fantome", 110, 30)
	p.tri:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -56)
	p.tri:SetScript("OnClick", function(self)
		triItems = triItems % #TRIS + 1
		self:Ecrire(TRIS[triItems])
		p.liste:Haut()
		RendreItems()
	end)
	UI.Infobulle(p.tri, "Trier", "Clic : niveau d'objet décroissant, croissant, ou par nom.")
	p.cherche = UI.Champ(p, 300, "Chercher un objet", 30)
	p.cherche:SetPoint("TOPLEFT", p, "TOPLEFT", x0, -56)
	p.cherche:SetPoint("RIGHT", p.tri, "LEFT", -10, 0)
	p.cherche.SurTexte = function(t)
		rechercheItems = Simplifier(strtrim(t or ""))
		p.liste:Haut()
		RendreItems()
	end
	p.compte = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.compte:SetPoint("TOPLEFT", p, "TOPLEFT", x0 + 2, -130)
	-- filtres pour moi : ma classe (armes et armures que je peux porter), mon niveau (mémorisés)
	local function Filtre(cle)
		return function(oui)
			local db = ns.DB and ns.DB()
			if db then db[cle] = oui or nil end
			p.liste:Haut()
			RendreItems()
		end
	end
	p.classe = UI.Case(p, "Pour ma classe", Filtre("itemsClasse"))
	p.classe:SetPoint("TOPLEFT", p, "TOPLEFT", x0, -94)
	p.niveau = UI.Case(p, "Jusqu'à mon niveau", Filtre("itemsNiveau"))
	p.niveau:SetPoint("LEFT", p.classe, "RIGHT", 22, 0)
	UI.Infobulle(p.niveau, "Jusqu'à mon niveau", "Seulement les objets dont le niveau requis ne dépasse pas le tien.")
	p.guilde = UI.Case(p, "Fabricable par la guilde", Filtre("itemsGuilde"))
	p.guilde:SetPoint("LEFT", p.niveau, "RIGHT", 22, 0)
	UI.Infobulle(p.guilde, "Fabricable par la guilde",
		"Seulement les objets qu'un autre membre de la guilde sait fabriquer (d'après le registre des métiers : ils doivent avoir ouvert leur fenêtre de métier avec l'addon).")
	-- fourchette de niveau requis : deux cases (vides = pas de limite)
	local function Borne(cle)
		local champ = UI.Champ(p, 44, "", 26)
		champ.saisie:SetNumeric(true)
		champ.saisie:SetMaxLetters(2)
		champ.saisie:SetJustifyH("CENTER")
		champ.SurTexte = function(t)
			local db = ns.DB and ns.DB()
			if db then db[cle] = tonumber(t) end
			p.liste:Haut()
			RendreItems()
		end
		return champ
	end
	p.nivMax = Borne("itemsNivMax")
	p.nivMax:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -124)
	local tA = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	tA:SetPoint("RIGHT", p.nivMax, "LEFT", -6, 0)
	tA:SetText("à")
	p.nivMin = Borne("itemsNivMin")
	p.nivMin:SetPoint("RIGHT", tA, "LEFT", -6, 0)
	local tNiv = UI.Texte(p, "GameFontHighlightSmall", C.texte)
	tNiv:SetPoint("RIGHT", p.nivMin, "LEFT", -8, 0)
	tNiv:SetText("Niveau requis")
	UI.Infobulle(p.nivMin, "Niveau requis minimum", "Laisse vide pour ne pas limiter.")
	UI.Infobulle(p.nivMax, "Niveau requis maximum", "Laisse vide pour ne pas limiter. Avec « Jusqu'à mon niveau », la plus petite des deux limites compte.")
	UI.Infobulle(p.classe, "Pour ma classe",
		"Armes : celles que ta classe sait manier. Armures : ton type d'armure (plaques ou mailles à partir du niveau 40 pour les classes concernées), plus les capes, bijoux, boucliers et reliques de ta classe. Les autres objets ne sont pas filtrés.")
	do
		local db = ns.DB and ns.DB()
		p.classe:Poser(db and db.itemsClasse)
		p.niveau:Poser(db and db.itemsNiveau)
		p.guilde:Poser(db and db.itemsGuilde)
		p.nivMin:Ecrire(db and db.itemsNivMin and tostring(db.itemsNivMin) or "")
		p.nivMax:Ecrire(db and db.itemsNivMax and tostring(db.itemsNivMax) or "")
	end
	-- liste à gauche, détail de l'objet choisi à droite
	local LARGEUR_DETAIL = 250
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", x0, -152)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE - LARGEUR_DETAIL - 4, MARGE)
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.vide:SetText("Aucun objet ne correspond.")

	-- Panneau de détail : l'objet, ses actions, et les membres qui savent le fabriquer
	local d = UI.Carte(p, "")
	d:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -152)
	d:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, MARGE)
	d:SetWidth(LARGEUR_DETAIL)
	d.titre:Hide()
	d.compte:Hide()
	d.vide:ClearAllPoints()
	d.vide:SetPoint("TOPLEFT", d, "TOPLEFT", 14, -14)
	d.vide:SetPoint("RIGHT", d, "RIGHT", -14, 0)
	d.vide:SetText("Clique sur un objet pour voir qui, dans la guilde, sait le fabriquer.")
	d.icone = d:CreateTexture(nil, "ARTWORK")
	d.icone:SetSize(38, 38)
	d.icone:SetPoint("TOPLEFT", d, "TOPLEFT", 12, -12)
	d.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	d.nom = UI.Texte(d, "GameFontNormal")
	d.nom:SetPoint("TOPLEFT", d.icone, "TOPRIGHT", 8, -1)
	d.nom:SetPoint("RIGHT", d, "RIGHT", -10, 0)
	d.nom:SetWordWrap(true)
	if d.nom.SetMaxLines then d.nom:SetMaxLines(2) end
	d.sous = UI.Texte(d, "GameFontHighlightSmall", C.gris)
	d.sous:SetPoint("TOPLEFT", d.icone, "BOTTOMLEFT", 0, -6)
	d.sous:SetPoint("RIGHT", d, "RIGHT", -10, 0)
	d.sous:SetWordWrap(true)
	local largeurBouton = (LARGEUR_DETAIL - 24 - 6) / 2
	d.ajouter = UI.Bouton(d, "Ajouter", "or", largeurBouton, 26)
	d.ajouter:SetPoint("TOPLEFT", d, "TOPLEFT", 12, -94)
	d.ajouter:SetScript("OnClick", function(self) if objetChoisi then MontrerMenuProjets(self, objetChoisi) end end)
	UI.Infobulle(d.ajouter, "Ajouter à un projet", "Choisis un de tes projets de guilde, ou crée-en un nouveau.")
	d.besoin = UI.Bouton(d, "Besoin", "fantome", largeurBouton, 26)
	d.besoin:SetPoint("LEFT", d.ajouter, "RIGHT", 6, 0)
	d.besoin:SetScript("OnClick", function()
		local o = objetChoisi
		if o and ns.AjouterBesoin and ns.AjouterBesoin(o, 1) and ns.Notifier then
			ns.Notifier(nil, "Besoin ajouté", ((InfoObjet(o)) or "Objet") .. " est dans tes besoins : la guilde le voit.", "aucun",
				function() if ns.OuvrirBesoins then ns.OuvrirBesoins() end end)
		end
	end)
	UI.Infobulle(d.besoin, "Ajouter à mes besoins", "La guilde voit que tu cherches cet objet (onglet Besoins de la page Dons).")
	d.fiche = UI.Bouton(d, "Encyclopédie", "fantome", LARGEUR_DETAIL - 24, 26)
	d.fiche:SetPoint("TOPLEFT", d.ajouter, "BOTTOMLEFT", 0, -6)
	d.fiche:SetScript("OnClick", function() if objetChoisi and ns.OuvrirFiche then ns.OuvrirFiche(objetChoisi) end end)
	UI.Infobulle(d.fiche, "Encyclopédie", "D'où vient l'objet, ses composants, où le trouver sur la carte.")
	d.titreArtisans = UI.Texte(d, "GameFontNormal", C.ors)
	d.titreArtisans:SetPoint("TOPLEFT", d.fiche, "BOTTOMLEFT", 0, -14)
	d.artisans = UI.Liste(d)
	d.artisans:SetPoint("TOPLEFT", d.titreArtisans, "BOTTOMLEFT", 0, -8)
	d.artisans:SetPoint("BOTTOMRIGHT", d, "BOTTOMRIGHT", -4, 10)
	d.aucun = UI.Texte(d, "GameFontHighlightSmall", C.gris)
	d.aucun:SetPoint("TOPLEFT", d.artisans, "TOPLEFT", 0, -2)
	d.aucun:SetPoint("RIGHT", d, "RIGHT", -12, 0)
	d.aucun:SetWordWrap(true)
	d.aucun:SetText("Personne dans la guilde ne sait le fabriquer, d'après le registre des métiers (chacun doit avoir ouvert sa fenêtre de métier avec l'addon).")
	d.lignes = {}
	local HAUTEUR_ARTISAN = 42
	local function CreerArtisan()
		local l = UI.Rangee(d.artisans.contenu, HAUTEUR_ARTISAN - 4)
		l.portrait = UI.Portrait(l, 28)
		l.portrait:SetPoint("LEFT", l, "LEFT", 6, 0)
		l.commander = UI.Bouton(l, "Commander", "or", 84, 24)
		l.commander:SetPoint("RIGHT", l, "RIGHT", -6, 0)
		UI.Infobulle(l.commander, "Commander", "Demande-lui de te fabriquer cet objet (tu choisis la quantité). Tu la suis dans l'onglet Commandes.")
		l.nom = UI.Texte(l, "GameFontHighlight")
		l.nom:SetPoint("TOPLEFT", l.portrait, "TOPRIGHT", 8, 1)
		l.nom:SetPoint("RIGHT", l.commander, "LEFT", -6, 0)
		l.sous = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.sous:SetPoint("TOPLEFT", l.nom, "BOTTOMLEFT", 0, -3)
		l.sous:SetPoint("RIGHT", l.commander, "LEFT", -6, 0)
		-- clic sur la ligne : chuchoter (s'il est en ligne)
		l:SetScript("OnClick", function(self)
			if self.a and self.a.enLigne and not self.a.moi then UI.Chuchoter(self.a.cle, self.a.nom) end
		end)
		l:SetScript("OnEnter", function(self)
			local a = self.a
			if not a then return end
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(NomJoueur(a.nom or "?"))
			GameTooltip:AddLine(NomMetier(a.metier) .. " " .. (a.niveau or "?"), 1, 1, 1)
			if a.moi then GameTooltip:AddLine("C'est toi.", 0.6, 0.6, 0.6)
			elseif a.enLigne then GameTooltip:AddLine("Clic : chuchoter", 0.6, 0.6, 0.6)
			else GameTooltip:AddLine("Hors ligne", 0.6, 0.6, 0.6) end
			GameTooltip:Show()
		end)
		l:SetScript("OnLeave", function() GameTooltip:Hide() end)
		return l
	end

	p.MajDetail = function()
		local o = objetChoisi
		local montre = o ~= nil
		d.vide:SetShown(not montre)
		for _, e in ipairs({ d.icone, d.nom, d.sous, d.ajouter, d.besoin, d.fiche, d.titreArtisans, d.artisans }) do e:SetShown(montre) end
		if not montre then
			d.aucun:Hide()
			return
		end
		local nom, _, qualite, icone, requis = InfoObjet(o)
		if not nom and ns.Precharger then ns.Precharger(o) end
		d.icone:SetTexture(icone or ICONE_INCONNUE)
		d.nom:SetText(nom or "chargement…")
		local qc = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite or 1]
		if qc then d.nom:SetTextColor(qc.r, qc.g, qc.b) else d.nom:SetTextColor(unpack(C.texte)) end
		local recs = RecettesDe(o)
		d.sous:SetText(((requis or 0) > 1 and ("Niveau requis " .. requis .. " · ") or "")
			.. (recs and recs[1] and ("Fabriqué : " .. TexteRecette(recs[1])) or ""))
		d.besoin:Activer(not objetChoisiLie)
		-- les membres qui savent le fabriquer : moi, puis en ligne, puis les autres
		local artisans = ns.ArtisansDe and ns.ArtisansDe(o) or {}
		local enLigne = 0
		for _, a in ipairs(artisans) do if a.enLigne and not a.moi then enLigne = enLigne + 1 end end
		d.titreArtisans:SetText("Dans la guilde" .. (#artisans > 0 and ("  |cff6fd08c" .. enLigne .. " en ligne|r") or ""))
		local y = 0
		for i, a in ipairs(artisans) do
			local l = d.lignes[i]
			if not l then l = CreerArtisan(); d.lignes[i] = l end
			l.a = a
			l.portrait:Poser(a.cle)
			l.nom:SetText(ns.NomMembreColore and ns.NomMembreColore(a.cle, a.nom) or NomJoueur(a.nom or "?"))
			l.sous:SetText(NomMetier(a.metier) .. " " .. (a.niveau or "?") .. " · "
				.. (a.moi and "toi" or a.enLigne and "|cff6fd08cen ligne|r" or "hors ligne"))
			l.commander:SetShown(not a.moi)
			l.commander:Activer(a.enLigne and true or false)
			l.commander:SetScript("OnClick", function()
				if ns.CommanderObjet then ns.CommanderObjet(a.cle, a.nom, o, 1) end
			end)
			l:SetAlpha((a.enLigne or a.moi) and 1 or 0.6)
			l:ClearAllPoints()
			l:SetPoint("TOPLEFT", d.artisans.contenu, "TOPLEFT", 0, -y)
			l:SetPoint("RIGHT", d.artisans.contenu, "RIGHT", 0, 0)
			l:Show()
			y = y + HAUTEUR_ARTISAN
		end
		for i = #artisans + 1, #d.lignes do d.lignes[i]:Hide() end
		d.artisans:Hauteur(y)
		d.aucun:SetShown(#artisans == 0)
	end
	p.Maj = RendreItems
	return p
end

-- Ouvre Artisanat > Items sur un objet (son détail et ses artisans à droite)
ns.MontrerObjetItems = function(objet)
	objetChoisi, objetChoisiLie = objet, nil
	-- lié quand ramassé ? (pas de « Besoin » dans le détail)
	for _, o in ipairs(Catalogue()) do
		if o[1] == objet then objetChoisiLie = o[7]; break end
	end
	if ns.OuvrirArtisanat then ns.OuvrirArtisanat(2) end
	if RendreItems then RendreItems() end
end

--------------------------------------------------------------------------------
-- Page « Artisanat » de la fenêtre GuildUpSMB : onglets Registre (GuildUp_Metiers.lua), Items (ici),
-- Projets de guilde (GuildUp_Projets.lua) et Commandes (GuildUp_Metiers.lua ; compteur des commandes
-- reçues en attente, ns.MajCompteCommandes). Chaque onglet est créé à sa première ouverture ; la
-- page ne suit pas le rafraîchissement automatique de la fenêtre (rafraichirAuto = false) : chaque
-- module la rafraîchit sur ses évènements.
--------------------------------------------------------------------------------

local ongletVoulu
local CREER_ONGLETS = {
	function(q) return ns.CreerPageRegistre and ns.CreerPageRegistre(q) end,
	function(q) return CreerPageItems(q) end,
	function(q) return ns.CreerPageProjets and ns.CreerPageProjets(q) end,
	function(q) return ns.CreerPageCommandes and ns.CreerPageCommandes(q) end,
}

-- compteur de l'onglet Commandes : commandes reçues qui attendent ma réponse (GuildUp_Metiers.lua)
ns.MajCompteCommandes = function()
	if pageArtisanat and pageArtisanat.onglets then
		pageArtisanat.onglets:Compte(4, ns.CommandesEnAttente and ns.CommandesEnAttente() or 0)
	end
end

local function CreerPageArtisanat(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.rafraichirAuto = false
	p.sousPages = {}
	p.onglets = UI.Onglets(p, { "Registre", "Items", "Projets de guilde", "Commandes" }, function(i)
		p.Selectionner(i)
		p.Maj()
	end)
	p.onglets:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -10)
	p.onglets:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	-- montre l'onglet i (créé au besoin), sans le rafraîchir
	p.Selectionner = function(i)
		i = (i and CREER_ONGLETS[i]) and i or 1
		p.onglet = i
		p.onglets:Choisir(i)
		if p.sousPages[i] == nil then p.sousPages[i] = CREER_ONGLETS[i](p) or false end
		for j, sp in pairs(p.sousPages) do
			if sp then
				if j == i then sp:Show() else sp:Hide() end
			end
		end
	end
	p.Maj = function()
		local sp = p.sousPages[p.onglet]
		if sp and sp.Maj then sp.Maj() end
		ns.MajCompteCommandes()
	end
	-- ns.OuvrirInterface("artisanat", onglet)
	p.Ouvrir = function(onglet)
		p.Selectionner(onglet)
		p.Maj()
	end
	pageArtisanat = p
	p.Selectionner(ongletVoulu or 1)
	ns.MajCompteCommandes()
	return p
end
if ns.AjouterPage then ns.AjouterPage("artisanat", CreerPageArtisanat) end

-- onglet 1 Registre, 2 Items, 3 Projets, 4 Commandes (sans onglet : le dernier montré)
ns.OuvrirArtisanat = function(onglet)
	ongletVoulu = onglet or (pageArtisanat and pageArtisanat.onglet) or 1
	if pageArtisanat then pageArtisanat.Selectionner(ongletVoulu) end
	if ns.OuvrirInterface then ns.OuvrirInterface("artisanat") end
end
-- déjà ouverte sur cet onglet : ferme la fenêtre
ns.BasculerArtisanat = function(onglet)
	onglet = onglet or 1
	if ArtisanatVisible(onglet) then
		if ns.BasculerInterface then ns.BasculerInterface() end
	else
		ns.OuvrirArtisanat(onglet)
	end
end

-- outils partagés avec le registre (GuildUp_Metiers.lua) et les projets de guilde (GuildUp_Projets.lua)
ns.OutilsCarnet = { RecettesDe = RecettesDe, InfoObjet = InfoObjet, NomMetier = NomMetier, JAi = JAi,
	TexteRecette = TexteRecette,
	Developper = Developper, NouveauContexte = NouveauContexte,
	Precharger = Precharger, Sources = Sources,
	Barre = Barre, Croix = Croix, Menu = Menu, LigneMenu = LigneMenu }

ns.DiagCarnet2 = function(L)
	local n, m = 0, 0
	for _ in pairs(Recettes()) do n = n + 1 end
	local brut = getmetatable(Sources().objets).__brut or ""
	for _ in brut:gmatch("\n%d+|") do m = m + 1 end
	L(("carnet : %d recettes, sources de %d composants"):format(n, m))
end

--------------------------------------------------------------------------------
-- Évènements : l'onglet Items et l'encyclopédie suivent les sacs, la banque et les objets reçus du
-- serveur en direct
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
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
	if not (ArtisanatVisible(2) or (fiche and fiche:IsShown())) then return end
	prevu = true
	C_Timer.After(0.4, function()
		prevu = false
		if ArtisanatVisible(2) and ns.MajInterface then ns.MajInterface() end
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
