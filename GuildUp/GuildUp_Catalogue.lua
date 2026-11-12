-- GuildUp : catalogue des contenus de la recherche de groupe (donjons, raids, quêtes, champs de
-- bataille…), lu dans la recherche de groupe Blizzard du client (C_LFGList), avec les icônes de
-- donjon (GetLFGDungeonInfo) et une liste de secours. Utilisé par GuildUp_Groupes.lua.
-- Code d'un contenu : "a<id d'activité>" (jeu), "s<n°>" (liste de secours) ou "q<id de quête>".

local NOM_ADDON, ns = ...
local AtlasExiste = ns.AtlasExiste
local PoserAtlas = ns.PoserAtlas

-- Catégories de la recherche de groupe Forever (Blizzard_GroupFinder_VanillaStyle)
local CATEGORIES_CONNUES = { 2, 114, 116, 118, 120 }
local ATLAS_CATEGORIES = {
	[2] = "groupfinder-button-dungeons",
	[114] = "groupfinder-button-raids-warlords",
	[116] = "groupfinder-button-questing",
	[118] = "groupfinder-button-battlegrounds",
	[120] = "groupfinder-button-custom-pve",
}
local ATLAS_DEFAUT = "groupfinder-button-questing"

-- Liste de secours : { nom, niveau min, niveau max, taille, catégorie }
local SECOURS = {
	{ "Gouffre de Ragefeu", 13, 18, 5, "Donjons" },
	{ "Les Mortemines", 17, 26, 5, "Donjons" },
	{ "Cavernes des Lamentations", 17, 24, 5, "Donjons" },
	{ "Donjon d'Ombrecroc", 22, 30, 5, "Donjons" },
	{ "Profondeurs de Brassenoire", 24, 32, 5, "Donjons" },
	{ "La Prison", 24, 32, 5, "Donjons" },
	{ "Gnomeregan", 29, 38, 5, "Donjons" },
	{ "Kraal de Tranchebauge", 29, 38, 5, "Donjons" },
	{ "Monastère écarlate", 26, 45, 5, "Donjons" },
	{ "Souilles de Tranchebauge", 37, 46, 5, "Donjons" },
	{ "Uldaman", 41, 51, 5, "Donjons" },
	{ "Zul'Farrak", 42, 46, 5, "Donjons" },
	{ "Maraudon", 46, 55, 5, "Donjons" },
	{ "Temple d'Atal'Hakkar", 50, 60, 5, "Donjons" },
	{ "Profondeurs de Rochenoire", 52, 60, 5, "Donjons" },
	{ "Pic de Rochenoire inférieur", 55, 60, 5, "Donjons" },
	{ "Hache-tripes", 55, 60, 5, "Donjons" },
	{ "Stratholme", 58, 60, 5, "Donjons" },
	{ "Scholomance", 58, 60, 5, "Donjons" },
	{ "Pic de Rochenoire supérieur", 58, 60, 10, "Raids" },
	{ "Zul'Gurub", 60, 60, 20, "Raids" },
	{ "Ruines d'Ahn'Qiraj", 60, 60, 20, "Raids" },
	{ "Cœur du Magma", 60, 60, 40, "Raids" },
	{ "Repaire d'Onyxia", 60, 60, 40, "Raids" },
	{ "Repaire de l'Aile noire", 60, 60, 40, "Raids" },
	{ "Temple d'Ahn'Qiraj", 60, 60, 40, "Raids" },
	{ "Naxxramas", 60, 60, 40, "Raids" },
	{ "Quêtes de groupe", 1, 60, 5, "Quêtes" },
	{ "Autre (voir commentaire)", 1, 60, 5, "Autre" },
}


--------------------------------------------------------------------------------
-- Catalogue des contenus
--------------------------------------------------------------------------------

local catalogue          -- liste triée d'entrées { code, nom, min, max, taille, categorie, idCategorie, ordreCat, icone }
local categories = {}    -- liste { id, nom, atlas }
local parCode = {}

local function Simplifier(nom)
	return (nom or ""):lower():gsub("[%s%p]", "")
end

-- Icônes de donjon : GetLFGDungeonInfo donne une texture (« LFGIcon-<nom> ») et la carte d'instance
local iconesDonjons

local function ChargerIconesDonjons()
	iconesDonjons = { parCarte = {}, parNom = {}, total = 0, exemples = {} }
	if not GetLFGDungeonInfo then return end
	for id = 1, 3000 do
		local ok, nom, _, _, _, _, _, _, _, _, _, texture, _, _, _, _, _, _, _, _, _, _, carte = pcall(GetLFGDungeonInfo, id)
		if ok and nom and texture and texture ~= "" then
			local fichier = "Interface\\LFGFrame\\LFGIcon-" .. texture
			iconesDonjons.total = iconesDonjons.total + 1
			if carte and carte > 0 and not iconesDonjons.parCarte[carte] then iconesDonjons.parCarte[carte] = fichier end
			iconesDonjons.parNom[Simplifier(nom)] = iconesDonjons.parNom[Simplifier(nom)] or fichier
			if #iconesDonjons.exemples < 8 then
				iconesDonjons.exemples[#iconesDonjons.exemples + 1] = ("%s (carte %s, %s)"):format(nom, tostring(carte), texture)
			end
		end
	end
end

local function IconeDonjon(nom, carte)
	if not iconesDonjons then ChargerIconesDonjons() end
	local fichier = (carte and iconesDonjons.parCarte[carte]) or (nom and iconesDonjons.parNom[Simplifier(nom)])
	if not fichier and nom then
		local base = nom:match("^(.-)%s*[%-:%(]")
		if base and base ~= "" then fichier = iconesDonjons.parNom[Simplifier(base)] end
	end
	if fichier then return { fichier = fichier } end
end

local function EntreeActivite(idActivite, nomCategorie, ordreCat, idCategorie)
	local ok, info = pcall(C_LFGList.GetActivityInfoTable, idActivite)
	if not ok or not info then return nil end
	local nom = (info.fullName and info.fullName ~= "" and info.fullName) or info.shortName or ("Activité " .. idActivite)
	local taille = (info.maxNumPlayers and info.maxNumPlayers > 0) and info.maxNumPlayers or 5
	return {
		code = "a" .. idActivite,
		nom = nom, min = info.minLevelSuggestion or info.minLevel or 0, max = info.maxLevelSuggestion or 0,
		taille = taille, categorie = nomCategorie, idCategorie = idCategorie, ordreCat = ordreCat,
		mapID = info.mapID,
		icone = IconeDonjon(nom, info.mapID) or { atlas = ATLAS_CATEGORIES[idCategorie] or ATLAS_DEFAUT },
	}
end

local function ActivitesDe(idCategorie)
	local liste, vus = {}, {}
	local function Ajouter(ids)
		for _, id in ipairs(ids or {}) do
			if not vus[id] then vus[id] = true; liste[#liste + 1] = id end
		end
	end
	if C_LFGList.GetAvailableActivities then
		local ok, ids = pcall(C_LFGList.GetAvailableActivities, idCategorie)
		if ok then Ajouter(ids) end
	end
	if #liste == 0 and LFGUtil_GetFilteredActivities then
		local ok, ids = pcall(LFGUtil_GetFilteredActivities, idCategorie)
		if ok then Ajouter(ids) end
	end
	return liste
end

local function ConstruireCatalogue()
	catalogue, parCode, categories = {}, {}, {}
	if C_LFGList and C_LFGList.GetActivityInfoTable then
		local ids = CATEGORIES_CONNUES
		if C_LFGList.GetAvailableCategories then
			local ok, liste = pcall(C_LFGList.GetAvailableCategories)
			if ok and liste and #liste > 0 then ids = liste end
		end
		for ordreCat, idCategorie in ipairs(ids) do
			local nomCategorie = "Catégorie " .. idCategorie
			if C_LFGList.GetLfgCategoryInfo then
				local ok, info = pcall(C_LFGList.GetLfgCategoryInfo, idCategorie)
				if ok and info and info.name then nomCategorie = info.name end
			end
			local n = 0
			for _, idActivite in ipairs(ActivitesDe(idCategorie)) do
				local e = EntreeActivite(idActivite, nomCategorie, ordreCat, idCategorie)
				if e then catalogue[#catalogue + 1] = e; n = n + 1 end
			end
			if n > 0 then
				categories[#categories + 1] = { id = idCategorie, nom = nomCategorie,
					atlas = ATLAS_CATEGORIES[idCategorie] or ATLAS_DEFAUT }
			end
		end
	end
	if #catalogue == 0 then
		local ordres = { Donjons = 1, Raids = 2, ["Quêtes"] = 3, Autre = 4 }
		local atlas = { Donjons = ATLAS_CATEGORIES[2], Raids = ATLAS_CATEGORIES[114], ["Quêtes"] = ATLAS_CATEGORIES[116],
			Autre = ATLAS_CATEGORIES[120] }
		local vues = {}
		for i, s in ipairs(SECOURS) do
			catalogue[#catalogue + 1] = {
				code = "s" .. i, nom = s[1], min = s[2], max = s[3], taille = s[4],
				categorie = s[5], idCategorie = s[5], ordreCat = ordres[s[5]] or 9,
				icone = IconeDonjon(s[1]) or { atlas = atlas[s[5]] or ATLAS_DEFAUT },
			}
			if not vues[s[5]] then
				vues[s[5]] = true
				categories[#categories + 1] = { id = s[5], nom = s[5], atlas = atlas[s[5]] or ATLAS_DEFAUT }
			end
		end
		catalogue.secours = true
	end
	table.sort(catalogue, function(a, b)
		if a.ordreCat ~= b.ordreCat then return a.ordreCat < b.ordreCat end
		if a.min ~= b.min then return a.min < b.min end
		if a.max ~= b.max then return a.max < b.max end
		return a.nom < b.nom
	end)
	for _, e in ipairs(catalogue) do parCode[e.code] = e end
end

local essaiCatalogue = 0
local function Catalogue()
	-- liste de secours (le jeu ne donnait encore rien, par exemple juste après la connexion) :
	-- on redemande au jeu, au plus toutes les 10 s
	if not catalogue or #catalogue == 0 or (catalogue.secours and GetTime() - essaiCatalogue > 10) then
		essaiCatalogue = GetTime()
		ConstruireCatalogue()
	end
	return catalogue
end

local function InfoContenu(code)
	Catalogue()
	local e = parCode[code]
	if e then return e end
	local id = code and tonumber(code:match("^a(%d+)$"))
	if id and C_LFGList and C_LFGList.GetActivityInfoTable then
		e = EntreeActivite(id, "?", 99, nil)
		if e then parCode[code] = e; return e end
	end
	-- groupe pour une quête (bouton de la fenêtre « Quêtes en commun ») : titre tiré de mon journal
	local q = code and tonumber(code:match("^q(%d+)$"))
	if q then
		local titre = ns.InfoQuete and ns.InfoQuete(q)
		return { code = code, nom = titre and ("Quête : " .. titre) or "Groupe de quête", min = 0, max = 0, taille = 5,
			categorie = "Quêtes", idCategorie = 116, icone = { atlas = ATLAS_CATEGORIES[116] or ATLAS_DEFAUT } }
	end
	local n = code and tonumber(code:match("^s(%d+)$"))
	if n and SECOURS[n] then
		return { code = code, nom = SECOURS[n][1], min = SECOURS[n][2], max = SECOURS[n][3], taille = SECOURS[n][4],
			icone = IconeDonjon(SECOURS[n][1]) or { atlas = ATLAS_DEFAUT } }
	end
	return { code = code, nom = "Contenu inconnu", min = 0, max = 0, taille = 5, icone = { atlas = ATLAS_DEFAUT } }
end

-- Groupe personnalisé (catégorie « Personnalisé » / « Autre ») : pas de limite à 5 joueurs,
-- la taille du groupe = le total des places choisies (jusqu'à 40, comme un raid)
local TAILLE_MAX_PERSO = 40
local function EstPerso(e)
	if not e then return false end
	if e.idCategorie == 120 then return true end
	local c = e.categorie and e.categorie:lower() or ""
	return c:find("perso", 1, true) ~= nil or c == "autre"
end
local function TailleMaxContenu(e)
	if EstPerso(e) then return TAILLE_MAX_PERSO end
	return e and e.taille or 5
end


local function TexteNiveaux(e)
	if not e.max or e.max == 0 or e.max == e.min then return ("niv. %d"):format(e.min or 0) end
	return ("niv. %d-%d"):format(e.min, e.max)
end

local function CouleurNiveau(e)
	local niv = UnitLevel("player") or 0
	if e.max and e.max > 0 and niv >= e.min and niv <= e.max then return "|cff33dd55" end
	if niv < (e.min or 0) then return "|cffff6666" end
	return "|cff999999"
end


-- Pour /smb diag (partie catalogue, appelée par ns.DiagGroupes)
local function Diag(L)
	ConstruireCatalogue()
	L("groupes (catalogue des contenus) :")
	L("  C_LFGList : " .. tostring(C_LFGList ~= nil) .. ", GetAvailableActivities : "
		.. tostring(C_LFGList and C_LFGList.GetAvailableActivities ~= nil)
		.. ", GetLFGDungeonInfo : " .. tostring(GetLFGDungeonInfo ~= nil)
		.. ", cadre à portrait : " .. tostring(PortraitFrameTemplateMixin ~= nil or PortraitFrameMixin ~= nil))
	L("  source : " .. (catalogue.secours and "liste de secours" or "jeu") .. ", " .. #catalogue .. " contenus, "
		.. #categories .. " catégories")
	-- contenus par catégorie, et ceux dont l'entrée est connue (repère sur la carte)
	local parCat, ordre, sansEntree = {}, {}, {}
	for _, e in ipairs(catalogue) do
		local c = e.categorie or "?"
		if not parCat[c] then parCat[c] = { n = 0, entrees = 0, noms = {} }; ordre[#ordre + 1] = c end
		parCat[c].n = parCat[c].n + 1
		parCat[c].noms[#parCat[c].noms + 1] = e.nom
		if ns.EntreeDonjon and ns.EntreeDonjon(e.nom, e.mapID) then
			parCat[c].entrees = parCat[c].entrees + 1
		elseif #sansEntree < 12 then
			sansEntree[#sansEntree + 1] = e.nom
		end
	end
	for _, c in ipairs(ordre) do
		L(("  %s : %d contenu(s), %d entrée(s) connue(s)"):format(c, parCat[c].n, parCat[c].entrees))
		if c:lower():find("raid", 1, true) then L("    raids : " .. table.concat(parCat[c].noms, ", ")) end
	end
	L("  sans entrée connue (exemples) : " .. (#sansEntree > 0 and table.concat(sansEntree, ", ") or "aucun"))
	local avecIcone = 0
	for _, e in ipairs(catalogue) do if e.icone and e.icone.fichier then avecIcone = avecIcone + 1 end end
	L("  avec icône de donjon : " .. avecIcone)
	if iconesDonjons then
		L(("  icônes de donjons (GetLFGDungeonInfo) : %d donjon(s) avec icône"):format(iconesDonjons.total))
		L("  exemples : " .. (#iconesDonjons.exemples > 0 and table.concat(iconesDonjons.exemples, " ; ") or "aucun"))
	end
end

ns.CatalogueGroupes = {
	Catalogue = Catalogue, InfoContenu = InfoContenu, EstPerso = EstPerso, TailleMaxContenu = TailleMaxContenu,
	TexteNiveaux = TexteNiveaux, CouleurNiveau = CouleurNiveau, ATLAS_DEFAUT = ATLAS_DEFAUT, Diag = Diag,
	-- catégories (reconstruites avec le catalogue : toujours passer par cette fonction)
	Categories = function() Catalogue(); return categories end,
}
