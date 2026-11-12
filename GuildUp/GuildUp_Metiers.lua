-- GuildUp : registre des métiers de la guilde.
-- Chaque GuildUp lit les niveaux de métier du joueur (fenêtre des compétences) et les recettes connues
-- (relevées quand le joueur ouvre sa fenêtre de métier : le jeu ne les donne qu'à ce moment-là),
-- puis les partage avec les autres membres qui ont l'addon. Les fiches reçues sont gardées
-- (GuildUpMetiersDB) : on voit aussi les membres hors ligne.
--
-- Messages d'addon sur le canal de guilde (préfixe "GuildUpMet") :
--   "Q"                                        demande : « envoyez vos résumés »
--   "S~niveau~CLASSE~AL,225,300,40,empreinte;CU,..."  résumé : métier, niveau, max, nb de recettes, empreinte
--   "D~AL~Nom-Royaume"                         demande les recettes d'un métier d'un membre
--   "R~AL~empreinte~n~total~i1a2b,s3c4,..."    recettes (par morceaux), diffusées à toute la guilde
-- Une recette = "s<id de sort>" ou "i<id d'objet fabriqué>" ; sur le réseau, l'id est en base 36.
-- L'empreinte change dès qu'une recette s'ajoute : les autres ne redemandent la liste qu'à ce moment.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpMet"
local TAILLE_MORCEAU = 200   -- caractères de recettes par message (limite du jeu : 255 en tout)

--------------------------------------------------------------------------------
-- Métiers connus
--------------------------------------------------------------------------------

local METIERS = {
	{ code = "AL", sort = 2259,  noms = { "Alchimie", "Alchemy" },            icone = "Interface\\Icons\\Trade_Alchemy" },
	{ code = "FO", sort = 2018,  noms = { "Forge", "Blacksmithing" },         icone = "Interface\\Icons\\Trade_BlackSmithing" },
	{ code = "EN", sort = 7411,  noms = { "Enchantement", "Enchanting" },     icone = "Interface\\Icons\\Trade_Engraving" },
	{ code = "IN", sort = 4036,  noms = { "Ingénierie", "Engineering" },      icone = "Interface\\Icons\\Trade_Engineering" },
	{ code = "TC", sort = 2108,  noms = { "Travail du cuir", "Leatherworking" }, icone = "Interface\\Icons\\INV_Misc_ArmorKit_17" },
	{ code = "CO", sort = 3908,  noms = { "Couture", "Tailoring" },           icone = "Interface\\Icons\\Trade_Tailoring" },
	{ code = "JO", sort = 25229, noms = { "Joaillerie", "Jewelcrafting" },    icone = "Interface\\Icons\\INV_Misc_Gem_01" },
	{ code = "CA", sort = 45357, noms = { "Calligraphie", "Inscription" },    icone = "Interface\\Icons\\INV_Inscription_Tradeskill01" },
	{ code = "HE", sort = 2366,  noms = { "Herboristerie", "Herbalism" },     icone = "Interface\\Icons\\Spell_Nature_NatureTouchGrow", recolte = true },
	{ code = "MI", sort = 2575,  noms = { "Minage", "Mining" },               icone = "Interface\\Icons\\Trade_Mining", recolte = true },
	{ code = "DE", sort = 8613,  noms = { "Dépeçage", "Skinning" },           icone = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01", recolte = true },
	{ code = "CU", sort = 2550,  noms = { "Cuisine", "Cooking" },             icone = "Interface\\Icons\\INV_Misc_Food_15" },
	{ code = "SE", sort = 3273,  noms = { "Secourisme", "First Aid" },        icone = "Interface\\Icons\\Spell_Holy_SealOfSacrifice" },
	{ code = "PE", sort = 7620,  noms = { "Pêche", "Fishing" },               icone = "Interface\\Icons\\Trade_Fishing", recolte = true },
}
local PAR_CODE = {}
for _, m in ipairs(METIERS) do PAR_CODE[m.code] = m end

-- nom anglais utilisé par les images de la fenêtre de métier du jeu (Professions-Recipe-Background-…)
local KITS = {
	AL = "Alchemy", FO = "Blacksmithing", EN = "Enchanting", IN = "Engineering", TC = "Leatherworking",
	CO = "Tailoring", JO = "Jewelcrafting", CA = "Inscription", HE = "Herbalism", MI = "Mining",
	DE = "Skinning", CU = "Cooking", SE = "FirstAid", PE = "Fishing",
}

-- minuscules sans accents, pour comparer et chercher (« Écaille » = « ecaille »)
local ACCENTS = {
	["à"] = "a", ["â"] = "a", ["ä"] = "a", ["ç"] = "c", ["é"] = "e", ["è"] = "e", ["ê"] = "e", ["ë"] = "e",
	["î"] = "i", ["ï"] = "i", ["ô"] = "o", ["ö"] = "o", ["ù"] = "u", ["û"] = "u", ["ü"] = "u",
	["À"] = "a", ["Â"] = "a", ["Ç"] = "c", ["É"] = "e", ["È"] = "e", ["Ê"] = "e", ["Î"] = "i",
	["Ô"] = "o", ["Û"] = "u", ["œ"] = "oe", ["Œ"] = "oe",
}
local function Simplifier(s)
	if not s then return "" end
	s = s:gsub("[\195\197][\128-\191]", ACCENTS)
	return s:lower()
end

local function InfoSort(id)
	if C_Spell and C_Spell.GetSpellInfo then
		local ok, t = pcall(C_Spell.GetSpellInfo, id)
		if ok and type(t) == "table" then return t.name, t.iconID end
	end
	if GetSpellInfo then
		local ok, nom, _, icone = pcall(GetSpellInfo, id)
		if ok and nom then return nom, icone end
	end
end

local function LienSort(id)
	local f = (C_Spell and C_Spell.GetSpellLink) or GetSpellLink
	if not f then return nil end
	local ok, lien = pcall(f, id)
	return ok and lien or nil
end

local function InfoObjet(id)
	local f = GetItemInfo or (C_Item and C_Item.GetItemInfo)
	local nom, lien, qualite, icone
	if f then
		local ok, n, l, q, _, _, _, _, _, _, ic = pcall(f, id)
		if ok then nom, lien, qualite, icone = n, l, q, ic end
	end
	if not icone then
		local fi = GetItemIcon or (C_Item and C_Item.GetItemIconByID)
		if fi then local ok, ic = pcall(fi, id); if ok then icone = ic end end
	end
	return nom, lien, qualite, icone
end

-- nom et icône localisés de chaque métier (tirés du sort d'apprentissage quand il existe)
for _, m in ipairs(METIERS) do
	local nom, icone = InfoSort(m.sort)
	m.nomJeu = nom
	m.existe = nom ~= nil
	if icone then m.icone = icone end
	m.cles = {}
	for _, n in ipairs(m.noms) do m.cles[Simplifier(n)] = true end
	if nom then m.cles[Simplifier(nom)] = true end
end
local function NomMetier(m) return m.nomJeu or m.noms[1] end

local MetierParNom
ns.MetierParNom = function(nom) return MetierParNom(nom) end
ns.NomMetierCode = function(code) local m = PAR_CODE[code]; return m and (m.nomJeu or m.noms[1]) end
ns.IconeMetierCode = function(code) local m = PAR_CODE[code]; return m and m.icone end

MetierParNom = function(nom)
	if not nom or nom == "" then return nil end
	local s = Simplifier(nom)
	for _, m in ipairs(METIERS) do
		if m.cles[s] then return m end
	end
end

-- Recette : nom, icône, lien de discussion, lien d'infobulle, qualité
local function InfoRecette(code)
	local genre, id = code:sub(1, 1), tonumber(code:sub(2))
	if not id then return nil end
	if genre == "s" then
		local nom, icone = InfoSort(id)
		if not icone and C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo then
			local ok, r = pcall(C_TradeSkillUI.GetRecipeInfo, id)
			if ok and type(r) == "table" then icone = r.icon; nom = nom or r.name end
		end
		return nom, icone, LienSort(id), "spell:" .. id
	end
	local nom, lien, qualite, icone = InfoObjet(id)
	return nom, icone, lien, "item:" .. id, qualite
end

local nomsSimplifies = {}
local function NomRecetteSimplifie(code)
	local n = nomsSimplifies[code]
	if n then return n end
	local nom = InfoRecette(code)
	if nom then
		n = Simplifier(nom)
		nomsSimplifies[code] = n
	end
	return n
end

--------------------------------------------------------------------------------
-- Outils
--------------------------------------------------------------------------------

local CHIFFRES = "0123456789abcdefghijklmnopqrstuvwxyz"
local function Base36(n)
	n = math.floor(n)
	if n <= 0 then return "0" end
	local s = ""
	while n > 0 do
		local r = n % 36
		s = CHIFFRES:sub(r + 1, r + 1) .. s
		n = math.floor(n / 36)
	end
	return s
end

local function Empreinte(liste)
	if #liste == 0 then return "0" end
	local h = 5381
	for _, c in ipairs(liste) do
		for i = 1, #c do h = (h * 33 + c:byte(i)) % 2147483629 end
		h = (h * 33 + 44) % 2147483629
	end
	return Base36(h)
end

local function Normaliser(nom)
	if ns.Normaliser then return ns.Normaliser(nom) end
	return nom
end

local function MaCle() return Normaliser(UnitName("player")) end
local function TestSolo() return ns.TestSolo and ns.TestSolo() end

local function Depuis(t)
	local s = math.max(0, time() - (t or 0))
	if s < 3600 then return math.max(1, math.floor(s / 60)) .. " min" end
	if s < 86400 then return math.floor(s / 3600) .. " h" end
	return math.floor(s / 86400) .. " j"
end

local function CouleurClasse(classe)
	local c = classe and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classe]
	if c then return c.r, c.g, c.b end
	return 1, 0.82, 0
end

-- Nom affiché : complet, « Prénom Famille » (« Miko-Banko » devient « Miko Banko »)
local function NomCourt(nom)
	if not nom then return "?" end
	return (nom:gsub("%-", " "))
end

-- Nom complet « Prénom Famille » (sur Forever, le nom de famille est à la place du royaume)
local function NomCompletUnite(u)
	local ok, nom, famille = pcall(UnitFullName, u)
	if ok and nom then
		if famille and famille ~= "" then return nom .. " " .. famille end
		return nom
	end
	return UnitName(u)
end

--------------------------------------------------------------------------------
-- Données (SavedVariables à part : /smb reset ne les efface pas)
--   GuildUpMetiersDB.moi[cle]              mes métiers (par personnage)
--   GuildUpMetiersDB.guildes[guilde][cle]  fiches reçues des autres membres
-- fiche = { nom, classe, niveau, vu, profs = { AL = { n, max, nr, h, r = { "s123", ... } } } }
--------------------------------------------------------------------------------

local function Base()
	if type(GuildUpMetiersDB) ~= "table" then GuildUpMetiersDB = {} end
	local b = GuildUpMetiersDB
	if type(b.moi) ~= "table" then b.moi = {} end
	if type(b.guildes) ~= "table" then b.guildes = {} end
	if type(b.ouverts) ~= "table" then b.ouverts = {} end -- catégories dépliées dans la fiche
	return b
end

local function Guilde()
	if not IsInGuild() then return nil end
	local nom = GetGuildInfo("player")
	if not nom then return nil end
	local b = Base()
	if type(b.guildes[nom]) ~= "table" then b.guildes[nom] = {} end
	return b.guildes[nom]
end

local function MesDonnees()
	local b = Base()
	local cle = MaCle()
	local e = b.moi[cle]
	if type(e) ~= "table" then e = {}; b.moi[cle] = e end
	if type(e.profs) ~= "table" then e.profs = {} end
	e.nom = NomCompletUnite("player") or UnitName("player")
	local _, classe = UnitClass("player")
	e.classe = classe
	e.niveau = UnitLevel("player")
	e.vu = time()
	return e
end

-- Pour GuildUp_Plans.lua : mon niveau dans un métier (nil si je ne l'ai pas)
ns.MonNiveauMetier = function(code)
	local p = MesDonnees().profs[code]
	return p and p.n
end

--------------------------------------------------------------------------------
-- Envoi (file d'attente : le jeu limite le nombre de messages d'addon par seconde)
--------------------------------------------------------------------------------

local file = {}
local stats = { envoyes = 0, recus = 0, bloques = 0 }
local pompe = CreateFrame("Frame")
pompe:Hide()
local attente = 0
pompe:SetScript("OnUpdate", function(self, ecoule)
	attente = attente - ecoule
	if attente > 0 then return end
	local m = file[1]
	if not m then self:Hide(); return end
	local envoi = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage
	local ok, res = false, nil
	if envoi and IsInGuild() then ok, res = pcall(envoi, PREFIXE, m.t, "GUILD") end
	-- false (ancienne API) ou 3 / 8 (Enum.SendAddonMessageResult : trop de messages) : on réessaie
	local bloque = ok and (res == false or res == 3 or res == 8)
	if bloque and m.essais < 6 then
		m.essais = m.essais + 1
		stats.bloques = stats.bloques + 1
		attente = 1.5
	else
		table.remove(file, 1)
		if ok and not bloque then stats.envoyes = stats.envoyes + 1 end
		attente = 0.35
	end
end)

local function Envoyer(texte)
	if not IsInGuild() then return end
	file[#file + 1] = { t = texte, essais = 0 }
	pompe:Show()
end

--------------------------------------------------------------------------------
-- Lecture de mes métiers
--------------------------------------------------------------------------------

local pret = false            -- vrai quelques secondes après la connexion
local dernierResume = 0
local resumePrevu = false
local derniereLecture         -- pour /smb diag
local PlanifierMaj

local function Resume()
	local moi = MesDonnees()
	local morceaux = {}
	for _, m in ipairs(METIERS) do
		local p = moi.profs[m.code]
		if p and p.n then
			morceaux[#morceaux + 1] = ("%s,%d,%d,%d,%s"):format(m.code, p.n, p.max or 0, #(p.r or {}), p.h or "0")
		end
	end
	return ("S~%d~%s~%s"):format(moi.niveau or 0, moi.classe or "", table.concat(morceaux, ";"))
end

local function EnvoyerResume()
	Envoyer(Resume())
	dernierResume = GetTime()
end

local function PlanifierResume()
	if PlanifierMaj then PlanifierMaj() end
	if not pret or resumePrevu then return end
	resumePrevu = true
	C_Timer.After(4, function()
		resumePrevu = false
		EnvoyerResume()
	end)
end

local function Profession(code)
	local moi = MesDonnees()
	local p = moi.profs[code]
	if not p then
		p = { r = {}, h = "0" }
		moi.profs[code] = p
	end
	if type(p.r) ~= "table" then p.r = {} end
	return p
end

-- Niveaux : fenêtre des compétences (Classic) ou GetProfessions (API récente)
local premiereLecture = true  -- pas d'annonce « nouveau métier » à la première lecture de la session
local absences = {}           -- [code] = lectures consécutives où ce métier manquait

local function LireNiveaux()
	local vus, replie, lu, lignes = {}, false, false, 0
	if GetNumSkillLines and GetSkillLineInfo then
		lu = true
		for i = 1, (GetNumSkillLines() or 0) do
			local nom, entete, ouvert, rang, _, _, max = GetSkillLineInfo(i)
			if entete then
				if not ouvert then replie = true end
			elseif nom then
				lignes = lignes + 1
				local m = MetierParNom(nom)
				if m and rang then vus[m.code] = { rang, max } end
			end
		end
	elseif GetProfessions and GetProfessionInfo then
		lu = true
		local liste = { GetProfessions() }
		for i = 1, 6 do
			local idx = liste[i]
			if idx then
				local nom, _, rang, max = GetProfessionInfo(idx)
				if nom then lignes = lignes + 1 end
				local m = MetierParNom(nom)
				if m and rang then vus[m.code] = { rang, max } end
			end
		end
	end
	-- compétences pas encore chargées (juste après la connexion) : on ne conclut rien
	if not lu or (lignes == 0 and next(MesDonnees().profs) ~= nil) then return end

	local moi = MesDonnees()
	local change = false
	-- pas d'annonce à la première lecture de la session, ni quand aucun métier n'était connu
	-- (première installation, nouveau personnage) : tout paraîtrait « nouveau »
	local annoncer = pret and not premiereLecture and next(moi.profs) ~= nil
	if pret then premiereLecture = false end
	for code, v in pairs(vus) do
		local avant = moi.profs[code] and moi.profs[code].n
		local p = Profession(code)
		if p.n ~= v[1] or p.max ~= v[2] then
			p.n, p.max = v[1], v[2]
			change = true
		end
		-- annonce à la guilde (bulle chez les autres) : nouveau métier, ou palier de 75 franchi
		if annoncer and ns.AnnonceMetier and v[1] then
			if not avant then
				ns.AnnonceMetier("nouveau", NomMetier(PAR_CODE[code]), v[1])
			elseif math.floor(v[1] / 75) > math.floor(avant / 75) then
				ns.AnnonceMetier("palier", NomMetier(PAR_CODE[code]), math.floor(v[1] / 75) * 75)
			end
		end
	end
	-- métier oublié : seulement si aucune catégorie n'est repliée (sinon on ne voit pas tout), et
	-- après deux lectures consécutives où il manque (une lecture incomplète n'efface rien)
	for code in pairs(vus) do absences[code] = nil end
	if not replie then
		for code in pairs(moi.profs) do
			if not vus[code] then
				absences[code] = (absences[code] or 0) + 1
				if absences[code] >= 2 then
					moi.profs[code] = nil
					absences[code] = nil
					change = true
				end
			end
		end
	end
	if change then PlanifierResume() end
end

local function CodeDepuisLiens(...)
	for i = 1, select("#", ...) do
		local lien = select(i, ...)
		if type(lien) == "string" then
			local s = lien:match("enchant:(%d+)") or lien:match("spell:(%d+)")
			if s then return "s" .. s end
			local o = lien:match("item:(%d+)")
			if o then return "i" .. o end
		end
	end
end

-- Ajoute les recettes lues (on ne retire jamais : une recette apprise ne s'oublie pas,
-- et les catégories repliées ou les filtres cachent une partie de la liste)
local function Fusionner(m, rang, max, nouvelles, source, remplacer)
	local p = Profession(m.code)
	local change = false
	if remplacer and #nouvelles > 0 then
		table.sort(nouvelles)
		local h = Empreinte(nouvelles)
		if h ~= p.h then
			local avant = #p.r
			p.r, p.h = nouvelles, h
			derniereLecture = ("%s via %s : %d recette(s) (avant : %d)"):format(NomMetier(m), source, #nouvelles, avant)
			change = true
		end
		if rang and rang > 0 and (p.n ~= rang or p.max ~= max) then p.n, p.max = rang, max; change = true end
		if change then PlanifierResume() end
		return
	end
	if rang and rang > 0 and (p.n ~= rang or p.max ~= max) then
		p.n, p.max = rang, max
		change = true
	end
	local deja = {}
	for _, c in ipairs(p.r) do deja[c] = true end
	local ajout = 0
	for _, c in ipairs(nouvelles) do
		if not deja[c] then
			deja[c] = true
			p.r[#p.r + 1] = c
			ajout = ajout + 1
		end
	end
	if ajout > 0 then
		table.sort(p.r)
		p.h = Empreinte(p.r)
		change = true
	end
	derniereLecture = ("%s via %s : %d lue(s), %d nouvelle(s), %d en tout"):format(
		NomMetier(m), source, #nouvelles, ajout, #p.r)
	if change then PlanifierResume() end
end

local function LireMetierClassique()
	-- fenêtre de métier d'un autre joueur (lien de métier) : ce ne sont pas mes recettes
	if IsTradeSkillLinked then
		local okLie, lie = pcall(IsTradeSkillLinked)
		if okLie and lie then return end
	end
	local okL, nom, rang, max = pcall(GetTradeSkillLine)
	if not okL then return end
	local m = MetierParNom(nom)
	if not m then
		derniereLecture = "fenêtre de métier « " .. tostring(nom) .. " » : métier non reconnu"
		return
	end
	local liste = {}
	for i = 1, (GetNumTradeSkills() or 0) do
		local nomR, genre = GetTradeSkillInfo(i)
		if nomR and genre ~= "header" and genre ~= "subheader" then
			local c = CodeDepuisLiens(
				GetTradeSkillRecipeLink and GetTradeSkillRecipeLink(i),
				GetTradeSkillItemLink and GetTradeSkillItemLink(i))
			if c then liste[#liste + 1] = c end
		end
	end
	Fusionner(m, rang, max, liste, "TradeSkill")
end

-- Objet fabriqué par une recette (nil pour un enchantement, qui ne crée pas d'objet)
local function ObjetFabrique(idRecette)
	local T = C_TradeSkillUI
	local function essai(f, ...)
		if not f then return nil end
		local ok, a = pcall(f, ...)
		if not ok or not a then return nil end
		if type(a) == "string" then return tonumber(a:match("item:(%d+)")) end
		if type(a) == "table" then
			return a.itemID or a.outputItemID or (a.hyperlink and tonumber(a.hyperlink:match("item:(%d+)")))
		end
	end
	return essai(T.GetRecipeItemLink, idRecette)
		or essai(T.GetRecipeOutputItemData, idRecette)
		or essai(T.GetRecipeSchematic, idRecette, false)
end

-- Recette « spéciale » : apprise ailleurs que chez l'entraîneur (plan trouvé, vendeur, quête…).
-- D'après le texte « source » de la recette dans le jeu (rien ou « Entraîneur » = recette normale).
local exemplesSources = {}    -- quelques textes lus, pour /smb diag
local function RecetteSpeciale(T, id)
	if not T.GetRecipeSourceText then return false end
	local ok, s = pcall(T.GetRecipeSourceText, id)
	if not ok or type(s) ~= "string" or s == "" then return false end
	local propre = s:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", ""):gsub("|n", " ")
	if #exemplesSources < 4 then exemplesSources[#exemplesSources + 1] = id .. "=" .. propre:sub(1, 60) end
	local simple = Simplifier(propre)
	if simple:find("entraineur", 1, true) or simple:find("trainer", 1, true) or simple:find("formateur", 1, true) then
		return false
	end
	return true
end

local function LireMetierModerne()
	local T = C_TradeSkillUI
	if T.IsTradeSkillLinked and T.IsTradeSkillLinked() then return end
	if T.IsTradeSkillGuild and T.IsTradeSkillGuild() then return end
	local info = T.GetBaseProfessionInfo and T.GetBaseProfessionInfo()
	local nom = info and info.professionName
	local m = MetierParNom(nom)
	if not m then
		derniereLecture = "fenêtre de métier « " .. tostring(nom) .. " » : métier non reconnu"
		return
	end
	local liste, speciales = {}, {}
	for _, id in ipairs(T.GetAllRecipeIDs() or {}) do
		local r = T.GetRecipeInfo(id)
		if r and r.learned then
			-- de préférence l'objet fabriqué (nom, icône, qualité et infobulle de l'objet)
			local objet = ObjetFabrique(id)
			local code = objet and ("i" .. objet) or ("s" .. id)
			liste[#liste + 1] = code
			if RecetteSpeciale(T, id) then speciales[code] = true end
		end
	end
	-- cette API donne toutes les recettes apprises d'un coup : la liste remplace l'ancienne
	Fusionner(m, info.skillLevel, info.maxSkillLevel, liste, "C_TradeSkillUI", true)
	if #liste > 0 then Profession(m.code).sp = speciales end
end

local function LireMetierOuvert()
	if GetNumTradeSkills and GetTradeSkillInfo and GetTradeSkillLine then
		LireMetierClassique()
	elseif C_TradeSkillUI and C_TradeSkillUI.GetAllRecipeIDs then
		LireMetierModerne()
	end
end

-- Enchantement (et dressage) passent par l'ancienne fenêtre « Craft » sur Classic
local function LireArtisanatOuvert()
	if not (GetNumCrafts and GetCraftInfo) then return end
	local nom, rang, max
	if GetCraftDisplaySkillLine then nom, rang, max = GetCraftDisplaySkillLine() end
	if not nom and GetCraftName then nom = GetCraftName() end
	local m = MetierParNom(nom)
	if not m then return end -- dressage des familiers, etc.
	local liste = {}
	for i = 1, (GetNumCrafts() or 0) do
		local nomR, _, genre = GetCraftInfo(i)
		if nomR and genre ~= "header" then
			local c = CodeDepuisLiens(
				GetCraftRecipeLink and GetCraftRecipeLink(i),
				GetCraftItemLink and GetCraftItemLink(i))
			if c then liste[#liste + 1] = c end
		end
	end
	Fusionner(m, rang, max, liste, "Craft")
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local demandes = {}      -- [cle .. code] = moment de la dernière demande de recettes
local diffusions = {}    -- [code] = moment de ma dernière diffusion
local enCours = {}       -- recettes en cours de réception : [cle .. code] = { h, total, n, parts }

local function RepondreQ()
	if not pret then return end
	C_Timer.After(1 + math.random() * 4, function()
		if GetTime() - dernierResume > 5 then EnvoyerResume() end
	end)
end

local function DiffuserRecettes(code)
	local p = MesDonnees().profs[code]
	if not p or not p.r or #p.r == 0 then return end
	if diffusions[code] and GetTime() - diffusions[code] < 20 then return end
	diffusions[code] = GetTime()
	local morceaux, courant, taille = {}, {}, 0
	for _, c in ipairs(p.r) do
		local id = tonumber(c:sub(2))
		if id then
			local mot = c:sub(1, 1) .. Base36(id)
			if taille + #mot + 1 > TAILLE_MORCEAU and #courant > 0 then
				morceaux[#morceaux + 1] = table.concat(courant, ",")
				courant, taille = {}, 0
			end
			courant[#courant + 1] = mot
			taille = taille + #mot + 1
		end
	end
	if #courant > 0 then morceaux[#morceaux + 1] = table.concat(courant, ",") end
	for i, txt in ipairs(morceaux) do
		Envoyer(("R~%s~%s~%d~%d~%s"):format(code, p.h or "0", i, #morceaux, txt))
	end
	-- (message P désactivé : Forever ne donne pas la source des recettes apprises)
	if false then
		local sp, cour, t = {}, {}, 0
		for c in pairs(p.sp) do
			local id = tonumber(c:sub(2))
			if id then
				local mot = c:sub(1, 1) .. Base36(id)
				if t + #mot + 1 > TAILLE_MORCEAU and #cour > 0 then
					sp[#sp + 1] = table.concat(cour, ",")
					cour, t = {}, 0
				end
				cour[#cour + 1] = mot
				t = t + #mot + 1
			end
		end
		if #cour > 0 or #sp == 0 then sp[#sp + 1] = table.concat(cour, ",") end
		for i, txt in ipairs(sp) do
			Envoyer(("P~%s~%d~%d~%s"):format(code, i, #sp, txt))
		end
	end
end

local function Demander(g, cle, code, force)
	local k = cle .. code
	if demandes[k] and GetTime() - demandes[k] < 60 then return end
	demandes[k] = GetTime()
	-- petit délai au hasard : si un autre membre demande la même liste, elle arrive pour tout le monde
	C_Timer.After(0.5 + math.random() * 2.5, function()
		local e = g[cle]
		local p = e and e.profs and e.profs[code]
		if p and (force or (p.attendu and p.h ~= p.attendu)) then
			Envoyer(("D~%s~%s"):format(code, cle))
		end
	end)
end

--------------------------------------------------------------------------------
-- Recettes d'entraîneur (filtre « recettes spéciales ») : lues dans la fenêtre d'un maître de
-- métier et mises en commun dans la guilde. Une recette absente de ces listes = recette spéciale
-- (plan trouvé, vendeur, quête…).
--   Base().entraineur[métier] = { o = { [objet fabriqué] = true }, n = { [nom simplifié] = true } }
--   « T~métier~part~total~mots »  la liste (mots : i<objet en base 36> ou n<nom>)
--   « U~métier »                  qui a la liste de ce métier ? (le premier qui l'a répond)
--------------------------------------------------------------------------------

local function Entraineur(code, creer)
	local b = Base()
	if type(b.entraineur) ~= "table" then b.entraineur = {} end
	local t = b.entraineur[code]
	if type(t) ~= "table" and creer then
		t = { o = {}, n = {} }
		b.entraineur[code] = t
	end
	return type(t) == "table" and t or nil
end
ns.EntraineurConnu = function(code) return Entraineur(code) ~= nil end

local dernierT = {}            -- [métier] = moment de la dernière liste vue passer (envoyée ou reçue)
local derniereLectureEntraineur

local function DiffuserEntraineur(code)
	local t = Entraineur(code)
	if not t then return end
	if dernierT[code] and GetTime() - dernierT[code] < 15 then return end
	dernierT[code] = GetTime()
	local mots = {}
	for o in pairs(t.o) do mots[#mots + 1] = "i" .. Base36(o) end
	for n in pairs(t.n) do mots[#mots + 1] = "n" .. n end
	local morceaux, cour, taille = {}, {}, 0
	for _, mot in ipairs(mots) do
		if taille + #mot + 1 > TAILLE_MORCEAU and #cour > 0 then
			morceaux[#morceaux + 1] = table.concat(cour, ",")
			cour, taille = {}, 0
		end
		cour[#cour + 1] = mot
		taille = taille + #mot + 1
	end
	if #cour > 0 then morceaux[#morceaux + 1] = table.concat(cour, ",") end
	for i, txt in ipairs(morceaux) do
		Envoyer(("T~%s~%d~%d~%s"):format(code, i, #morceaux, txt))
	end
end

local function NomPropre(nom) return (Simplifier(nom or ""):gsub("[,~|]", "")) end

local lectureEntraineur = false
local function LireEntraineur()
	if lectureEntraineur or not (GetNumTrainerServices and GetTrainerServiceInfo) then return end
	lectureEntraineur = true
	-- tout afficher le temps de la lecture (appris, disponibles, pas encore disponibles)
	local avant = {}
	if GetTrainerServiceTypeFilter and SetTrainerServiceTypeFilter then
		for _, f in ipairs({ "available", "unavailable", "used" }) do
			local ok, v = pcall(GetTrainerServiceTypeFilter, f)
			avant[f] = ok and v
			if ok and not v then pcall(SetTrainerServiceTypeFilter, f, 1) end
		end
	end
	local ajouts, lus, metierLu = {}, 0, nil
	for i = 1, GetNumTrainerServices() or 0 do
		local nom, _, genre = GetTrainerServiceInfo(i)
		if nom and genre ~= "header" then
			local ligne = GetTrainerServiceSkillLine and GetTrainerServiceSkillLine(i)
			local m = ligne and MetierParNom(ligne)
			if m and not m.recolte then
				metierLu = m
				local t = Entraineur(m.code, true)
				local lien = GetTrainerServiceItemLink and GetTrainerServiceItemLink(i)
				local o = lien and tonumber(lien:match("item:(%d+)"))
				lus = lus + 1
				if o then
					if not t.o[o] then t.o[o] = true; ajouts[m.code] = true end
				else
					local s = NomPropre(nom)
					if s ~= "" and not t.n[s] then t.n[s] = true; ajouts[m.code] = true end
				end
			end
		end
	end
	for f, v in pairs(avant) do
		if not v then pcall(SetTrainerServiceTypeFilter, f, 0) end
	end
	derniereLectureEntraineur = ("entraîneur : %d recette(s) lue(s)%s, SkillLine=%s"):format(lus,
		metierLu and (" en " .. NomMetier(metierLu)) or "", tostring(GetTrainerServiceSkillLine ~= nil))
	if PlanifierMaj then PlanifierMaj() end
	C_Timer.After(1, function() lectureEntraineur = false end)
end

-- Une recette est-elle apprise chez l'entraîneur ? (nil = liste de ce métier encore inconnue)
local function DeLEntraineur(metier, code)
	local t = Entraineur(metier)
	if not t then return nil end
	local id = tonumber(code:sub(2))
	if code:sub(1, 1) == "i" and id and t.o[id] then return true end
	local s = NomRecetteSimplifie(code)
	if s and t.n[(s:gsub("[,~|]", ""))] then return true end
	return false
end

local function RecevoirEntraineur(genre, reste)
	if genre == "U" then
		local code = reste
		if not PAR_CODE[code] or not Entraineur(code) then return end
		local demande = GetTime()
		-- le premier qui a la liste répond ; les autres voient passer sa réponse et se taisent
		C_Timer.After(1 + math.random() * 5, function()
			if not (dernierT[code] and dernierT[code] >= demande) then DiffuserEntraineur(code) end
		end)
	elseif genre == "T" then
		local code, part, total, mots = strsplit("~", reste)
		part, total = tonumber(part), tonumber(total)
		if not PAR_CODE[code] or not part or not total or part > total or total > 40 then return end
		dernierT[code] = GetTime()
		local t = Entraineur(code, true)
		for mot in (mots or ""):gmatch("[^,]+") do
			local g, v = mot:sub(1, 1), mot:sub(2)
			if g == "i" then
				local o = tonumber(v, 36)
				if o then t.o[o] = true end
			elseif g == "n" and v ~= "" then
				t.n[v] = true
			end
		end
		if PlanifierMaj then PlanifierMaj() end
	end
end

-- À la connexion : demande les listes d'entraîneur qui me manquent (une fois par session)
local function DemanderEntraineurs()
	for _, m in ipairs(METIERS) do
		if not m.recolte and not Entraineur(m.code) then Envoyer("U~" .. m.code) end
	end
end

local function Fiche(g, cle, nom)
	local e = g[cle]
	if type(e) ~= "table" then e = {}; g[cle] = e end
	if type(e.profs) ~= "table" then e.profs = {} end
	e.nom = nom
	e.vu = time()
	return e
end

--------------------------------------------------------------------------------
-- Commandes d'artisanat : « C~cible~recette~id » (demande), « K~cible~id~1|0~recette » (réponse),
-- diffusées sur le canal de guilde et lues seulement par la cible
--------------------------------------------------------------------------------

local function NomRecette(code)
	local nom, _, lien = InfoRecette(code)
	return lien or nom or "une recette"
end

-- Nom pour chuchoter sur Forever : « Prénom Famille » (sans le suffixe de test)
local function PrenomSeul(nom) return ((nom or "?"):gsub(" %(test%)$", ""):gsub("%-", " ")) end

-- Le demandeur envoie lui-même un message privé (trace dans la discussion des deux côtés) ;
-- le crafteur reçoit juste une bulle (plus de fenêtre Accepter / Refuser depuis la 1.5)
local function RecevoirCommande(genre, reste, cle, nom)
	local moi = MaCle()
	local function PourMoi(cible) return cible == moi or (TestSolo() and cible == moi .. "#test") end
	if genre == "C" then
		local cible, code, id, qteC = strsplit("~", reste)
		qteC = tonumber(qteC)
		if not PourMoi(cible) or not code or not id then return end
		if ns.Notifier then
			ns.Notifier("commandes", "Nouvelle commande", ("%s te demande : %s%s"):format(NomCourt(nom),
				(qteC and qteC > 1) and (qteC .. " x ") or "", NomRecette(code)), "aucun",
				function()
					local nomMP = cle:find("#test", 1, true) and UnitName("player")
						or (ns.NomListeGuilde and ns.NomListeGuilde(cle)) or PrenomSeul(nom)
					if ChatFrame_SendTell then ChatFrame_SendTell(nomMP) end
				end)
		end
	elseif genre == "K" then
		-- réponse d'un crafteur qui a une version plus ancienne (bouton Accepter / Refuser)
		local cible, _, ok, code = strsplit("~", reste)
		if not PourMoi(cible) then return end
		if ns.Notifier then
			if ok == "1" then
				ns.Notifier("commandes", "Commande acceptée", ("%s s'en occupe : %s"):format(NomCourt(nom), NomRecette(code or "")),
					"TELL_MESSAGE", function() end)
			else
				ns.Notifier("commandes", "Commande refusée", ("par %s"):format(NomCourt(nom)), nil, function() end)
			end
		end
	end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local g = Guilde()
	if not g then return end
	stats.recus = stats.recus + 1
	local cle = Normaliser(expediteur)
	local nom = expediteur
	if cle == MaCle() then
		-- mon propre message (le jeu me le renvoie) : ignoré, sauf en test seul où je deviens « un autre »
		if not TestSolo() then return end
		cle, nom = cle .. "#test", expediteur .. " (test)"
	end
	local genre = msg:sub(1, 1)
	local reste = msg:sub(3)

	if genre == "C" or genre == "K" then
		RecevoirCommande(genre, reste, cle, nom)

	elseif genre == "T" or genre == "U" then
		RecevoirEntraineur(genre, reste)

	elseif genre == "Q" then
		RepondreQ()

	elseif genre == "S" then
		local niveau, classe, liste = strsplit("~", reste)
		local e = Fiche(g, cle, nom)
		e.niveau = tonumber(niveau)
		if classe and classe ~= "" then e.classe = classe end
		local vus = {}
		for morceau in (liste or ""):gmatch("[^;]+") do
			local code, n, max, nr, h = strsplit(",", morceau)
			if PAR_CODE[code] then
				vus[code] = true
				local p = e.profs[code]
				if type(p) ~= "table" then p = { r = {} }; e.profs[code] = p end
				p.n, p.max, p.nr = tonumber(n), tonumber(max), tonumber(nr) or 0
				if p.nr == 0 then
					p.r, p.h, p.attendu = {}, h, nil
				elseif p.h ~= h then
					p.attendu = h
					Demander(g, cle, code)
				end
			end
		end
		for code in pairs(e.profs) do
			if not vus[code] then e.profs[code] = nil end
		end
		if PlanifierMaj then PlanifierMaj() end

	elseif genre == "P" then
		local code, part, total, ids = strsplit("~", reste)
		part, total = tonumber(part), tonumber(total)
		if not PAR_CODE[code] or not part or not total or part > total or total > 20 then return end
		local e = Fiche(g, cle, nom)
		local p = e.profs[code]
		if type(p) ~= "table" then p = { r = {} }; e.profs[code] = p end
		if part == 1 or type(p.sp) ~= "table" then p.sp = {} end
		for mot in (ids or ""):gmatch("[^,]+") do
			local genreR, id = mot:sub(1, 1), tonumber(mot:sub(2), 36)
			if id and (genreR == "s" or genreR == "i") then p.sp[genreR .. id] = true end
		end
		if PlanifierMaj then PlanifierMaj() end

	elseif genre == "D" then
		local code, cible = strsplit("~", reste)
		local moi = MaCle()
		if PAR_CODE[code] and (cible == moi or (TestSolo() and cible == moi .. "#test")) then
			DiffuserRecettes(code)
		end

	elseif genre == "R" then
		local code, h, part, total, ids = strsplit("~", reste)
		part, total = tonumber(part), tonumber(total)
		if not PAR_CODE[code] or not part or not total or total < 1 or total > 60 or part > total then return end
		local e = Fiche(g, cle, nom)
		local p = e.profs[code]
		if type(p) ~= "table" then p = { r = {} }; e.profs[code] = p end
		if p.h == h then return end -- déjà à jour
		local k = cle .. code
		local t = enCours[k]
		if not t or t.h ~= h or t.total ~= total then
			t = { h = h, total = total, n = 0, parts = {} }
			enCours[k] = t
		end
		if not t.parts[part] then
			t.parts[part] = ids or ""
			t.n = t.n + 1
		end
		if t.n >= t.total then
			local liste = {}
			for i = 1, t.total do
				for mot in (t.parts[i] or ""):gmatch("[^,]+") do
					local genreR, id = mot:sub(1, 1), tonumber(mot:sub(2), 36)
					if id and (genreR == "s" or genreR == "i") then liste[#liste + 1] = genreR .. id end
				end
			end
			table.sort(liste)
			p.r, p.h, p.nr, p.attendu = liste, h, #liste, nil
			enCours[k] = nil
			if PlanifierMaj then PlanifierMaj() end
		end
	end
end

--------------------------------------------------------------------------------
-- Liste de guilde : qui est en ligne, zone, nom exact pour chuchoter
--------------------------------------------------------------------------------

local roster, rosterLu = {}, false
-- nom exact d'un membre dans la liste de guilde (pour lui écrire en privé)
ns.NomListeGuilde = function(cle) return roster[cle] and roster[cle].nom end

local function DemanderRoster()
	if C_GuildInfo and C_GuildInfo.GuildRoster then pcall(C_GuildInfo.GuildRoster)
	elseif GuildRoster then pcall(GuildRoster) end
end

local function LireRoster()
	if not IsInGuild() or not GetNumGuildMembers then return end
	wipe(roster)
	local n = GetNumGuildMembers() or 0
	for i = 1, n do
		local nom, _, _, niveau, _, zone, _, _, enLigne, _, classe = GetGuildRosterInfo(i)
		local cle = nom and Normaliser(nom)
		if cle then
			roster[cle] = { nom = nom, enLigne = enLigne and true or false, zone = zone, classe = classe, niveau = niveau }
		end
	end
	rosterLu = n > 0
end

local EnLigne
local dernieresCommandes = {}
local function Commander(cle, nom, code, qte)
	qte = tonumber(qte)
	if qte and qte < 2 then qte = nil end
	if not EnLigne(cle, { vu = 0 }) then
		if ns.Erreur then ns.Erreur("Ce joueur est hors ligne : impossible de lui commander") end
		return
	end
	local k = cle .. code
	if dernieresCommandes[k] and GetTime() - dernieresCommandes[k] < 30 then
		if ns.Erreur then ns.Erreur("Commande déjà envoyée, attends sa réponse") end
		return
	end
	dernieresCommandes[k] = GetTime()
	local id = MaCle() .. ":" .. (GetServerTime and GetServerTime() or math.floor(GetTime()))
	Envoyer(("C~%s~%s~%s~%d"):format(cle, code, id, qte or 1))
	-- message privé envoyé par le demandeur : le crafteur en garde la trace dans sa discussion
	if not cle:find("#test", 1, true) then
		local nomMP = (roster[cle] and roster[cle].nom) or PrenomSeul(nom)
		local envoi = (C_ChatInfo and C_ChatInfo.SendChatMessage) or SendChatMessage
		if envoi and nomMP then
			pcall(envoi, "Commande d'artisanat : " .. (qte and (qte .. " x ") or "") .. NomRecette(code)
				.. (qte and " — peux-tu me les fabriquer ?" or " — peux-tu me le fabriquer ?"), "WHISPER", nil, nomMP)
		end
	end
end

-- Confirmation avant d'envoyer une commande (évite les clics par erreur et les demandes en double)
StaticPopupDialogs["GUILDUP_CONFIRMER_COMMANDE"] = {
	text = "%s",
	button1 = "Commander",
	button2 = "Annuler",
	hasEditBox = true,
	maxLetters = 4,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnShow = function(self)
		local boite = self.editBox or self.EditBox
		if boite then
			boite:SetNumeric(true)
			boite:SetText(tostring(self.data and self.data.qte or 1))
			boite:HighlightText()
		end
	end,
	OnAccept = function(self)
		local d = self.data
		local boite = self.editBox or self.EditBox
		if d then Commander(d.cle, d.nom, d.code, boite and tonumber(boite:GetText()) or d.qte) end
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		local d = parent.data
		if d then Commander(d.cle, d.nom, d.code, tonumber(self:GetText()) or d.qte) end
		parent:Hide()
	end,
}

-- (quantité modifiable : 1 par défaut, ou celle du carnet de craft)
local function DemanderConfirmation(cle, nom, code, qte)
	local texte = ("Commander à |cffffd100%s|r :\n%s\n\nQuantité :"):format(NomCourt(nom), NomRecette(code))
	StaticPopup_Show("GUILDUP_CONFIRMER_COMMANDE", texte, nil, { cle = cle, nom = nom, code = code, qte = qte })
end
-- Pour le carnet de craft : commander un objet (avec une quantité) à un membre
ns.CommanderObjet = function(cle, nom, objet, qte) DemanderConfirmation(cle, nom, "i" .. objet, qte) end

-- Pour GuildUp_Besoins.lua
ns.EnLigneMembre = function(cle) return EnLigne(cle, { vu = 0 }) end
ns.MembreGuilde = function(cle)
	if not rosterLu then return nil end
	return roster[cle] ~= nil
end
ns.JeSaisFabriquer = function(objet)
	local code = "i" .. tostring(objet)
	for _, p in pairs(MesDonnees().profs) do
		if type(p) == "table" and type(p.r) == "table" then
			for _, c in ipairs(p.r) do if c == code then return true end end
		end
	end
	return false
end

EnLigne = function(cle, e)
	if cle == MaCle() or cle:find("#test", 1, true) then return true end
	local r = roster[cle]
	if r then return r.enLigne end
	-- absent de la liste de guilde chargée = hors ligne (les absents ne sont pas listés)
	if rosterLu then return false end
	return e.vu and (time() - e.vu) < 120 or false
end

local function Chuchoter(cle, e)
	local nom
	if cle:find("#test", 1, true) then
		nom = UnitName("player")
	elseif roster[cle] then
		nom = roster[cle].nom          -- nom tel que la liste de guilde le donne
	else
		-- pas dans la liste de guilde : on chuchote à « Prénom Famille » (format des noms de Forever)
		nom = ((e.nom or cle):gsub(" %(test%)$", ""):gsub("%-", " ")) -- « Prénom Famille »
	end
	if ChatFrame_SendTell then
		ChatFrame_SendTell(nom)
	elseif ChatFrame_OpenChat then
		ChatFrame_OpenChat("/w " .. nom .. " ")
	end
end

--------------------------------------------------------------------------------
-- Fenêtre du registre
--------------------------------------------------------------------------------

local LARGEUR, HAUTEUR = 720, 520
local HAUT_ENCART = -88
local LARGEUR_GAUCHE = 300
local HAUTEUR_LIGNE = 34
local LARGEUR_LIGNE = LARGEUR_GAUCHE - 38
local LARGEUR_DROITE = LARGEUR - LARGEUR_GAUCHE - 14 - 32
local ICONE_EN_LIGNE = "Interface\\FriendsFrame\\StatusIcon-Online"
local ICONE_HORS_LIGNE = "Interface\\FriendsFrame\\StatusIcon-Offline"
local ICONE_INCONNUE = "Interface\\Icons\\INV_Misc_QuestionMark"

local fen
local function Speciales() return Base().speciales and true or false end
-- recette affichée selon le filtre « recettes spéciales » (nil = spéciales inconnues pour ce métier)
-- recettes spéciales = apprises avec un plan (liste tirée des données du jeu : GuildUp_Recettes.lua)
local function Visible(p, code, metier)
	if not Speciales() then return true end
	return ns.RecetteDePlan ~= nil and ns.RecetteDePlan(metier, code)
end
local filtre = nil       -- code du métier filtré
local recherche = ""     -- texte cherché (simplifié)
local selection = nil    -- fiche affichée à droite
local majPrevue = false
local MajFenetre
local lignesMembres = {}
local pools = { metier = {}, recette = {}, info = {} }

PlanifierMaj = function(delai)
	if not fen or not fen.page or not fen.page:IsVisible() or majPrevue then return end
	majPrevue = true
	C_Timer.After(delai or 0.2, function()
		majPrevue = false
		if fen and fen.page and fen.page:IsVisible() then MajFenetre() end
	end)
end

local function AtlasExiste(a)
	return C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(a) ~= nil
end
local function PoserAtlas(tex, atlas, couleur)
	if AtlasExiste(atlas) then tex:SetAtlas(atlas); return true end
	if couleur then tex:SetColorTexture(unpack(couleur)) end
	return false
end

local function Fiches()
	local liste = {}
	local g = Guilde()
	local moi = MaCle()
	local test = TestSolo()
	if g then
		for cle, e in pairs(g) do
			if cle ~= moi and type(e) == "table" and (test or not cle:find("#test", 1, true)) then
				liste[#liste + 1] = { cle = cle, e = e }
			end
		end
	end
	liste[#liste + 1] = { cle = moi, e = MesDonnees(), moi = true }
	return liste
end

-- Pour les projets de guilde : membres qui ont un métier (code : MI, HE, DE…), moi compris
ns.MembresAvecMetier = function(code)
	local res = {}
	for _, f in ipairs(Fiches()) do
		local p = (f.e.profs or {})[code]
		if p then
			res[#res + 1] = { cle = f.cle, nom = f.e.nom or f.cle, moi = f.moi, niveau = type(p) == "table" and p.n or nil,
				enLigne = f.moi or EnLigne(f.cle, f.e) }
		end
	end
	table.sort(res, function(a, b)
		if a.moi ~= b.moi then return a.moi end
		if a.enLigne ~= b.enLigne then return a.enLigne end
		return (a.nom or "") < (b.nom or "")
	end)
	return res
end

-- Pour le carnet de craft : qui sait fabriquer cet objet (moi compris), en ligne d'abord
ns.ArtisansDe = function(objet)
	local code = "i" .. tostring(objet)
	local res = {}
	for _, f in ipairs(Fiches()) do
		for metier, p in pairs(f.e.profs or {}) do
			if type(p) == "table" and type(p.r) == "table" then
				for _, c in ipairs(p.r) do
					if c == code then
						res[#res + 1] = { cle = f.cle, nom = f.e.nom or f.cle, moi = f.moi, metier = metier,
							niveau = p.n, enLigne = f.moi or EnLigne(f.cle, f.e) }
						break
					end
				end
			end
		end
	end
	table.sort(res, function(a, b)
		if a.moi ~= b.moi then return a.moi end
		if a.enLigne ~= b.enLigne then return a.enLigne end
		return (a.nom or "") < (b.nom or "")
	end)
	return res
end

local function RecettesTrouvees(p, metier)
	if recherche == "" or type(p.r) ~= "table" then return 0 end
	local n = 0
	for _, c in ipairs(p.r) do
		local s = NomRecetteSimplifie(c)
		if s and Visible(p, c, metier) and s:find(recherche, 1, true) then n = n + 1 end
	end
	return n
end

local function ASpeciales(e)
	for metier, p in pairs(e.profs or {}) do
		if (not filtre or metier == filtre) and type(p.r) == "table" then
			for _, c in ipairs(p.r) do
				if Visible(p, c, metier) then return true end
			end
		end
	end
	return false
end

local function ListeAffichee()
	local res, total, enLigne = {}, 0, 0
	for _, f in ipairs(Fiches()) do
		local e = f.e
		f.enLigne = EnLigne(f.cle, e)
		total = total + 1
		if f.enLigne then enLigne = enLigne + 1 end
		local garde = not filtre or (e.profs and e.profs[filtre] ~= nil)
		f.trouvees, f.nomTrouve = 0, false
		if garde and recherche ~= "" then
			f.nomTrouve = Simplifier(e.nom or f.cle):find(recherche, 1, true) ~= nil
			for code, p in pairs(e.profs or {}) do
				if not filtre or code == filtre then f.trouvees = f.trouvees + RecettesTrouvees(p, code) end
			end
			garde = f.nomTrouve or f.trouvees > 0
		end
		if garde and Speciales() and not f.moi then garde = ASpeciales(e) end
		if garde then res[#res + 1] = f end
	end
	table.sort(res, function(a, b)
		if a.enLigne ~= b.enLigne then return a.enLigne end
		if filtre then
			local na = a.e.profs[filtre].n or 0
			local nb = b.e.profs[filtre].n or 0
			if na ~= nb then return na > nb end
		end
		if a.trouvees ~= b.trouvees then return a.trouvees > b.trouvees end
		return (a.e.nom or a.cle) < (b.e.nom or b.cle)
	end)
	return res, total, enLigne
end

-- Ligne d'un membre (colonne de gauche)
local function CreerLigneMembre(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(LARGEUR_LIGNE, HAUTEUR_LIGNE)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	b.fond:SetColorTexture(1, 1, 1, 0.03)
	b.choisi = b:CreateTexture(nil, "BORDER")
	b.choisi:SetAllPoints(b)
	if not PoserAtlas(b.choisi, "groupfinder-highlightbar-blue") then b.choisi:SetColorTexture(0.2, 0.45, 0.9, 0.3) end
	b.choisi:SetBlendMode("ADD")
	b.choisi:SetAlpha(0.7)
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetAllPoints(b)
	survol:SetColorTexture(1, 0.82, 0, 0.12)
	survol:SetBlendMode("ADD")

	b.etat = b:CreateTexture(nil, "ARTWORK")
	b.etat:SetSize(12, 12)
	b.etat:SetPoint("TOPLEFT", b, "TOPLEFT", 3, -5)
	b.nom = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b, "TOPLEFT", 18, -4)
	b.nom:SetWidth(120)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.sous = b:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	b.sous:SetPoint("TOPLEFT", b, "TOPLEFT", 18, -19)
	b.sous:SetWidth(125)
	b.sous:SetJustifyH("LEFT")
	b.sous:SetWordWrap(false)

	-- petits métiers à droite (icône + niveau), du plus à droite vers la gauche
	b.metiers = {}
	for i = 1, 4 do
		local ic = b:CreateTexture(nil, "ARTWORK")
		ic:SetSize(16, 16)
		ic:SetPoint("TOPRIGHT", b, "TOPRIGHT", -8 - (i - 1) * 30, -3)
		local t = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		t:SetPoint("TOP", ic, "BOTTOM", 0, -1)
		b.metiers[i] = { icone = ic, texte = t }
	end
	-- un seul métier en grand quand un filtre est actif
	b.grosIcone = b:CreateTexture(nil, "ARTWORK")
	b.grosIcone:SetSize(22, 22)
	b.grosIcone:SetPoint("RIGHT", b, "RIGHT", -68, 0)
	b.grosTexte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	b.grosTexte:SetPoint("LEFT", b.grosIcone, "RIGHT", 6, 0)

	b:SetScript("OnClick", function(self)
		selection = self.cle
		MajFenetre()
	end)
	b:SetScript("OnEnter", function(self)
		local e = self.e
		if not e then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(NomCourt(e.nom or self.cle), CouleurClasse(e.classe))
		if ns.LignesIdentite then ns.LignesIdentite(GameTooltip, self.cle) end
		local rien = true
		for _, m in ipairs(METIERS) do
			local p = e.profs and e.profs[m.code]
			if p then
				rien = false
				local nr = type(p.r) == "table" and #p.r or 0
				GameTooltip:AddDoubleLine("|T" .. tostring(m.icone) .. ":14|t " .. NomMetier(m),
					("%d / %d%s"):format(p.n or 0, p.max or 0, nr > 0 and ("  (" .. nr .. " recettes)") or ""),
					1, 0.82, 0, 1, 1, 1)
			end
		end
		if rien then GameTooltip:AddLine("Aucun métier connu.", 0.7, 0.7, 0.7) end
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

local function RemplirLigneMembre(b, f)
	local e = f.e
	b.cle, b.e = f.cle, e
	b.etat:SetTexture(f.enLigne and ICONE_EN_LIGNE or ICONE_HORS_LIGNE)
	b.nom:SetText(NomCourt(e.nom or f.cle) .. (f.moi and " |cff999999(toi)|r" or ""))
	b.nom:SetTextColor(CouleurClasse(e.classe))
	if recherche ~= "" and f.trouvees > 0 then
		local s = f.trouvees > 1 and "s" or ""
		b.sous:SetText(("|cff33dd55%d recette%s trouvée%s|r"):format(f.trouvees, s, s))
	elseif f.enLigne then
		local zone = f.moi and GetRealZoneText and GetRealZoneText() or (roster[f.cle] and roster[f.cle].zone)
		b.sous:SetText(zone and zone ~= "" and zone or "En ligne")
	else
		b.sous:SetText("Hors ligne" .. (e.vu and (" · vu il y a " .. Depuis(e.vu)) or ""))
	end

	for _, s in ipairs(b.metiers) do s.icone:Hide(); s.texte:Hide() end
	b.grosIcone:Hide()
	b.grosTexte:Hide()
	if filtre then
		local p = e.profs and e.profs[filtre]
		if p then
			b.grosIcone:SetTexture(PAR_CODE[filtre].icone)
			b.grosTexte:SetText(("%d / %d"):format(p.n or 0, p.max or 0))
			b.grosIcone:Show()
			b.grosTexte:Show()
		end
		return
	end
	-- métiers principaux d'abord (ordre de METIERS), quatre au plus
	local i = 0
	local tous = {}
	for _, m in ipairs(METIERS) do
		local p = e.profs and e.profs[m.code]
		if p then tous[#tous + 1] = { m = m, p = p } end
	end
	for j = math.min(#tous, 4), 1, -1 do
		i = i + 1
		local s, x = b.metiers[i], tous[j]
		s.icone:SetTexture(x.m.icone)
		s.texte:SetText(tostring(x.p.n or 0))
		s.icone:Show()
		s.texte:Show()
	end
end

-- Lignes de la colonne de droite (réutilisées)
local function Prendre(genre, parent)
	local pool = pools[genre]
	pool.utilisees = (pool.utilisees or 0) + 1
	local l = pool[pool.utilisees]
	if l then return l end
	l = CreateFrame("Button", nil, parent)
	l:SetWidth(LARGEUR_DROITE)
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.texte = l:CreateFontString(nil, "OVERLAY", genre == "metier" and "GameFontNormal"
		or genre == "info" and "GameFontDisableSmall" or "GameFontHighlightSmall")
	l.texte:SetJustifyH("LEFT")
	l.texte:SetWordWrap(false)
	if genre == "metier" then
		l:SetHeight(30)
		l.fleche = l:CreateTexture(nil, "ARTWORK")
		l.fleche:SetSize(14, 14)
		l.fleche:SetPoint("LEFT", l, "LEFT", 0, 0)
		l.icone:SetSize(24, 24)
		l.icone:SetPoint("LEFT", l, "LEFT", 17, 0)
		l.texte:SetPoint("TOPLEFT", l, "TOPLEFT", 47, -3)
		local survolM = l:CreateTexture(nil, "HIGHLIGHT")
		survolM:SetAllPoints(l)
		survolM:SetColorTexture(1, 0.82, 0, 0.08)
		survolM:SetBlendMode("ADD")
		l:SetScript("OnClick", function(self)
			if not self.code then return end
			local o = Base().ouverts
			o[self.code] = not o[self.code] or nil
			MajFenetre()
		end)
		l.niveau = l:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		l.niveau:SetPoint("TOPRIGHT", l, "TOPRIGHT", -4, -3)
		l.barre = CreateFrame("StatusBar", nil, l)
		l.barre:SetSize(LARGEUR_DROITE - 56, 8)
		l.barre:SetPoint("BOTTOMLEFT", l, "BOTTOMLEFT", 49, 2)
		l.barre:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
		l.barre:SetStatusBarColor(0.26, 0.62, 0.18)
		local fond = l.barre:CreateTexture(nil, "BACKGROUND")
		fond:SetAllPoints(l.barre)
		if not PoserAtlas(fond, "Professions-skillbar-bg") then fond:SetColorTexture(0, 0, 0, 0.6) end
		local contour = l.barre:CreateTexture(nil, "OVERLAY")
		contour:SetPoint("TOPLEFT", l.barre, "TOPLEFT", -3, 3)
		contour:SetPoint("BOTTOMRIGHT", l.barre, "BOTTOMRIGHT", 3, -3)
		if not PoserAtlas(contour, "Professions-skillbar-frame") then contour:Hide() end
		local filet = l:CreateTexture(nil, "BACKGROUND")
		filet:SetPoint("TOPLEFT", l, "TOPLEFT", -2, 1)
		filet:SetPoint("BOTTOMRIGHT", l, "BOTTOMRIGHT", 2, -1)
		filet:SetColorTexture(1, 0.82, 0, 0.06)
	elseif genre == "info" then
		l:SetHeight(18)
		l.texte:SetPoint("LEFT", l, "LEFT", 47, 0)
		l.texte:SetWidth(LARGEUR_DROITE - 47)
		l.icone:Hide()
	else
		l:SetHeight(18)
		l.icone:SetSize(16, 16)
		l.icone:SetPoint("LEFT", l, "LEFT", 47, 0)
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 6, 0)
		l.texte:SetWidth(LARGEUR_DROITE - 73)
		local survol = l:CreateTexture(nil, "HIGHLIGHT")
		survol:SetAllPoints(l)
		survol:SetColorTexture(1, 0.82, 0, 0.12)
		survol:SetBlendMode("ADD")
		l:SetScript("OnEnter", function(self)
			if not self.hyper then return end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			if not pcall(GameTooltip.SetHyperlink, GameTooltip, self.hyper) then
				GameTooltip:SetText(self.texte:GetText() or "?")
			end
			if self.commande then
				GameTooltip:AddLine(self.commande.enLigne and ("Clic : commander à " .. NomCourt(self.commande.nom))
					or "Hors ligne : commande impossible", 0.3, 1, 0.3)
			end
			GameTooltip:AddLine("Maj-clic : lien dans la discussion", 0.6, 0.6, 0.6)
			GameTooltip:Show()
		end)
		l:SetScript("OnLeave", function() GameTooltip:Hide() end)
		l:SetScript("OnClick", function(self)
			if self.lien and IsModifiedClick and IsModifiedClick("CHATLINK") and ChatEdit_InsertLink then
				ChatEdit_InsertLink(self.lien)
			elseif self.commande and self.code then
				DemanderConfirmation(self.commande.cle, self.commande.nom, self.code)
			end
		end)
	end
	pool[pool.utilisees] = l
	return l
end

local function ViderPools()
	for _, pool in pairs(pools) do
		for i = 1, #pool do pool[i]:Hide() end
		pool.utilisees = 0
	end
end

local function MajDetail(f)
	ViderPools()
	local c = fen.contenuD
	if not f then
		fen.dNom:SetText("")
		fen.dEtat:SetText("")
		fen.mp:Hide()
		fen.videD:Show()
		c:SetHeight(10)
		return
	end
	fen.videD:Hide()
	local e = f.e
	do
		local code = filtre
		if not code then
			for _, m in ipairs(METIERS) do
				if e.profs and e.profs[m.code] and not m.recolte then code = m.code; break end
			end
		end
		local atlas = code and KITS[code] and ("Professions-Recipe-Background-" .. KITS[code])
		if not (atlas and PoserAtlas(fen.fondD, atlas)) then PoserAtlas(fen.fondD, "Professions-Recipe-Background") end
	end
	fen.dNom:SetText(NomCourt(e.nom or f.cle))
	fen.dNom:SetTextColor(CouleurClasse(e.classe))
	local etat
	if f.enLigne then
		local zone = f.moi and GetRealZoneText and GetRealZoneText() or (roster[f.cle] and roster[f.cle].zone)
		etat = "|cff33dd55En ligne|r" .. (zone and zone ~= "" and (" · " .. zone) or "")
	else
		etat = "|cff999999Hors ligne|r" .. (e.vu and (" · vu il y a " .. Depuis(e.vu)) or "")
	end
	fen.dEtat:SetText((e.niveau and e.niveau > 0 and ("Niveau " .. e.niveau .. " · ") or "") .. etat)
	fen.mp:Show()
	fen.mp.cle, fen.mp.e = f.cle, e
	fen.mp:SetEnabled(f.enLigne and not f.moi)

	local y = 0
	local toutMontrer = recherche == "" or f.nomTrouve
	for _, m in ipairs(METIERS) do
		local p = e.profs and e.profs[m.code]
		if p and (not filtre or filtre == m.code) then
			local recettes = {}
			for _, code in ipairs(type(p.r) == "table" and p.r or {}) do
				if not Visible(p, code, m.code) then
					-- filtre « recettes spéciales » : recette d'entraîneur cachée
				elseif toutMontrer then
					recettes[#recettes + 1] = code
				else
					local s = NomRecetteSimplifie(code)
					if s and s:find(recherche, 1, true) then recettes[#recettes + 1] = code end
				end
			end
			if toutMontrer or #recettes > 0 then
				-- repliée par défaut ; toujours dépliée pendant une recherche ou avec le filtre de ce métier
				local force = (recherche ~= "" and not f.nomTrouve) or filtre == m.code
				local ouvert = force or Base().ouverts[m.code]
				local l = Prendre("metier", c)
				l:ClearAllPoints()
				l:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
				l.code = not force and m.code or nil
				l.fleche:SetTexture(ouvert and "Interface\\Buttons\\UI-MinusButton-Up" or "Interface\\Buttons\\UI-PlusButton-Up")
				l.fleche:SetShown(not force and (#recettes > 0 or not m.recolte))
				l.icone:SetTexture(m.icone)
				l.texte:SetText(NomMetier(m) .. (#recettes > 0 and ("  |cff999999(" .. #recettes .. ")|r") or ""))
				l.niveau:SetText(("%d / %d"):format(p.n or 0, p.max or 0))
				l.barre:SetMinMaxValues(0, math.max(p.max or 1, 1))
				l.barre:SetValue(p.n or 0)
				l:Show()
				y = y + 34

				-- recettes triées par nom (les noms inconnus du cache arrivent un peu après)
				if not ouvert then recettes = {} end
				local noms = {}
				for _, code in ipairs(recettes) do noms[code] = (InfoRecette(code)) end
				table.sort(recettes, function(a, b) return (noms[a] or "~") < (noms[b] or "~") end)
				for _, code in ipairs(recettes) do
					local r = Prendre("recette", c)
					r:ClearAllPoints()
					r:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
					local nomR, icone, lien, hyper, qualite = InfoRecette(code)
					r.icone:SetTexture(icone or ICONE_INCONNUE)
					r.texte:SetText(nomR or "|cff999999chargement…|r")
					local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
					if qc and nomR then r.texte:SetTextColor(qc.r, qc.g, qc.b) else r.texte:SetTextColor(1, 1, 1) end
					r.lien, r.hyper, r.code = lien, hyper, code
					r.commande = (not f.moi) and { cle = f.cle, nom = e.nom or f.cle, enLigne = f.enLigne } or nil
					r:Show()
					y = y + 18
				end
				if ouvert and #recettes == 0 and not m.recolte then
					local i = Prendre("info", c)
					i:ClearAllPoints()
					i:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
					if Speciales() and (p.nr or #(p.r or {})) > 0 then
						i.texte:SetText("Aucune recette apprise avec un plan.")
					elseif (p.nr or 0) > 0 then
						i.texte:SetText("Recettes en cours de réception…")
					elseif f.moi then
						i.texte:SetText("Ouvre ta fenêtre de métier pour partager tes recettes.")
					else
						i.texte:SetText("Pas encore de recettes : il doit ouvrir sa fenêtre de métier.")
					end
					i:Show()
					y = y + 18
				end
				y = y + 8
			end
		end
	end
	if y == 0 then
		local i = Prendre("info", c)
		i:ClearAllPoints()
		i:SetPoint("TOPLEFT", c, "TOPLEFT", 0, 0)
		i.texte:SetText(filtre and "Ce métier n'est pas connu." or "Aucun métier connu.")
		i:Show()
		y = 18
	end
	c:SetHeight(y)
end

MajFenetre = function()
	if not fen then return end
	for code, bt in pairs(fen.filtres) do
		local choisi = filtre == code
		bt.halo:SetShown(choisi)
		bt.icone:SetDesaturated(filtre ~= nil and not choisi)
		bt.icone:SetAlpha((filtre == nil or choisi) and 1 or 0.55)
	end
	if filtre then fen.tous:UnlockHighlight() else fen.tous:LockHighlight() end

	local liste, total, enLigne = ListeAffichee()
	local y = 0
	local choisie
	for i, f in ipairs(liste) do
		local b = lignesMembres[i]
		if not b then
			b = CreerLigneMembre(fen.contenuG)
			lignesMembres[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", fen.contenuG, "TOPLEFT", 0, -y)
		RemplirLigneMembre(b, f)
		b.fond:SetShown(i % 2 == 0)
		b:Show()
		y = y + HAUTEUR_LIGNE
		if f.cle == selection then choisie = f end
	end
	for i = #liste + 1, #lignesMembres do lignesMembres[i]:Hide() end
	fen.contenuG:SetHeight(math.max(y, 10))
	fen.videG:SetShown(#liste == 0)
	fen.speciales:SetChecked(Speciales())
	fen.videG:SetText(Speciales() and "Personne n'a de recette spéciale (ou ne l'a pas encore partagée)."
		or recherche ~= "" and "Personne ne correspond à ta recherche."
		or filtre and "Personne n'a ce métier (parmi les membres qui ont GuildUp)."
		or "Personne pour l'instant.")
	if not choisie then
		choisie = liste[1]
		selection = choisie and choisie.cle
	end
	for i, f in ipairs(liste) do lignesMembres[i].choisi:SetShown(f.cle == selection) end
	MajDetail(choisie)
	fen.bas:SetText(("|cff33dd55%d en ligne|r"):format(enLigne))
end

-- Page « Registre » de la fenêtre « Artisanat & Échanges » (GuildUp_Echanges.lua la crée et
-- l'héberge ; même cadre à portrait, 720 de large)
local function CreerPage(f)
	fen = f
	local page = CreateFrame("Frame", nil, f)
	page:SetAllPoints(f)

	-- filtres par métier
	f.filtres = {}
	local tous = CreateFrame("Button", nil, page, "UIPanelButtonTemplate")
	tous:SetSize(52, 22)
	tous:SetPoint("TOPLEFT", f, "TOPLEFT", 66, -30)
	tous:SetText("Tous")
	tous:SetScript("OnClick", function() filtre = nil; MajFenetre() end)
	f.tous = tous
	local x = 126
	for _, m in ipairs(METIERS) do
		if m.existe or not (GetSpellInfo or (C_Spell and C_Spell.GetSpellInfo)) then
			local bt = CreateFrame("Button", nil, page)
			bt:SetSize(24, 24)
			bt:SetPoint("TOPLEFT", f, "TOPLEFT", x, -29)
			bt.icone = bt:CreateTexture(nil, "ARTWORK")
			bt.icone:SetAllPoints(bt)
			bt.icone:SetTexture(m.icone)
			bt.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			bt.halo = bt:CreateTexture(nil, "OVERLAY")
			bt.halo:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
			bt.halo:SetBlendMode("ADD")
			bt.halo:SetVertexColor(1, 0.82, 0)
			bt.halo:SetPoint("CENTER", bt, "CENTER", 0, 0)
			bt.halo:SetSize(46, 46)
			bt:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
			bt:SetScript("OnClick", function()
				filtre = (filtre ~= m.code) and m.code or nil
				MajFenetre()
			end)
			bt:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(NomMetier(m))
				GameTooltip:AddLine("Clic : voir seulement ce métier, classé par niveau.", 1, 1, 1, true)
				GameTooltip:Show()
			end)
			bt:SetScript("OnLeave", function() GameTooltip:Hide() end)
			f.filtres[m.code] = bt
			x = x + 28
		end
	end

	-- recherche (joueur ou recette)
	local okR, boite = pcall(CreateFrame, "EditBox", "GuildUpMetiersRecherche", page, "SearchBoxTemplate")
	if not okR then
		boite = CreateFrame("EditBox", "GuildUpMetiersRecherche", page, "InputBoxTemplate")
	end
	boite:SetSize(230, 20)
	boite:SetPoint("TOPLEFT", f, "TOPLEFT", 74, -60)
	boite:SetAutoFocus(false)
	boite:HookScript("OnTextChanged", function(self)
		recherche = Simplifier(strtrim(self:GetText() or ""))
		PlanifierMaj(0.15)
	end)
	boite:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
	f.recherche = boite
	if boite.Instructions then boite.Instructions:SetText("Joueur ou recette (ex. « flacon »)") end
	boite:HookScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText("Cherche un joueur ou une recette (ex. « flacon »)")
		GameTooltip:Show()
	end)
	boite:HookScript("OnLeave", function() GameTooltip:Hide() end)
	-- « Recettes spéciales » : cache les recettes d'entraîneur, garde celles des plans trouvés
	local sp = CreateFrame("CheckButton", nil, page, "UICheckButtonTemplate")
	sp:SetSize(22, 22)
	sp:SetPoint("LEFT", boite, "RIGHT", 14, 0)
	local tsp = sp.Text or sp.text
	if not tsp then
		tsp = sp:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		tsp:SetPoint("LEFT", sp, "RIGHT", 1, 0)
	end
	tsp:SetFontObject("GameFontHighlightSmall")
	tsp:SetText("Voir uniquement les recettes spéciales")
	sp:SetScript("OnClick", function(self)
		Base().speciales = self:GetChecked() and true or nil
		MajFenetre()
	end)
	sp:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText("Recettes spéciales")
		GameTooltip:AddLine("Cache les recettes apprises chez l'entraîneur : il ne reste que celles apprises avec un plan (butin, vendeur, quête…).", 1, 1, 1, true)
		GameTooltip:AddLine("D'après les données du jeu : toutes les recettes qu'un objet « Recette » / « Plans » apprend.", 0.6, 0.6, 0.6, true)
		GameTooltip:Show()
	end)
	sp:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.speciales = sp

	-- colonne de gauche : membres, sur le fond de la liste des recettes du jeu
	local fondG = page:CreateTexture(nil, "BACKGROUND")
	fondG:SetPoint("TOPLEFT", f, "TOPLEFT", 8, HAUT_ENCART - 4)
	fondG:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", LARGEUR_GAUCHE + 2, 36)
	if not PoserAtlas(fondG, "Professions-background-summarylist") then fondG:SetColorTexture(0, 0, 0, 0.25) end
	-- colonne de droite : fond de recette du métier (changé selon la fiche affichée)
	f.fondD = page:CreateTexture(nil, "BACKGROUND")
	f.fondD:SetPoint("TOPLEFT", f, "TOPLEFT", LARGEUR_GAUCHE + 10, HAUT_ENCART - 4)
	f.fondD:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 36)
	if not PoserAtlas(f.fondD, "Professions-Recipe-Background") then f.fondD:SetColorTexture(0, 0, 0, 0.2) end
	f.page = page

	local defileG = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
	defileG:SetPoint("TOPLEFT", f, "TOPLEFT", 12, HAUT_ENCART - 8)
	defileG:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", 12 + LARGEUR_LIGNE, 38)
	f.contenuG = CreateFrame("Frame", nil, defileG)
	f.contenuG:SetSize(LARGEUR_LIGNE, 10)
	defileG:SetScrollChild(f.contenuG)
	f.videG = page:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	f.videG:SetPoint("TOP", defileG, "TOP", 0, -40)
	f.videG:SetWidth(LARGEUR_LIGNE - 20)

	-- séparateur
	local sep = page:CreateTexture(nil, "ARTWORK")
	sep:SetColorTexture(1, 0.82, 0, 0.3)
	sep:SetWidth(1)
	sep:SetPoint("TOPLEFT", f, "TOPLEFT", LARGEUR_GAUCHE + 6, HAUT_ENCART - 8)
	sep:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", LARGEUR_GAUCHE + 6, 38)

	-- colonne de droite : fiche du membre choisi
	f.dNom = page:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	f.dNom:SetPoint("TOPLEFT", f, "TOPLEFT", LARGEUR_GAUCHE + 16, HAUT_ENCART - 12)
	f.dNom:SetJustifyH("LEFT")
	f.dEtat = page:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.dEtat:SetPoint("TOPLEFT", f.dNom, "BOTTOMLEFT", 0, -4)
	f.dEtat:SetJustifyH("LEFT")
	f.mp = CreateFrame("Button", nil, page, "UIPanelButtonTemplate")
	f.mp:SetSize(90, 22)
	f.mp:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, HAUT_ENCART - 12)
	f.mp:SetText("Chuchoter")
	f.mp:SetScript("OnClick", function(self)
		if self.cle then Chuchoter(self.cle, self.e) end
	end)
	f.mp:SetMotionScriptsWhileDisabled(true)
	f.mp:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		if self.cle == MaCle() then
			GameTooltip:SetText("C'est toi !")
		elseif self:IsEnabled() then
			GameTooltip:SetText("Lui envoyer un message privé")
		else
			GameTooltip:SetText("Hors ligne : impossible de lui écrire.")
		end
		GameTooltip:Show()
	end)
	f.mp:SetScript("OnLeave", function() GameTooltip:Hide() end)
	local filetD = page:CreateTexture(nil, "ARTWORK")
	filetD:SetColorTexture(1, 0.82, 0, 0.3)
	filetD:SetHeight(1)
	filetD:SetPoint("TOPLEFT", f, "TOPLEFT", LARGEUR_GAUCHE + 14, HAUT_ENCART - 50)
	filetD:SetPoint("TOPRIGHT", f, "TOPRIGHT", -12, HAUT_ENCART - 50)

	local defileD = CreateFrame("ScrollFrame", nil, page, "UIPanelScrollFrameTemplate")
	defileD:SetPoint("TOPLEFT", f, "TOPLEFT", LARGEUR_GAUCHE + 16, HAUT_ENCART - 58)
	defileD:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -32, 38)
	f.contenuD = CreateFrame("Frame", nil, defileD)
	f.contenuD:SetSize(LARGEUR_DROITE, 10)
	defileD:SetScrollChild(f.contenuD)
	f.videD = page:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	f.videD:SetPoint("TOP", defileD, "TOP", 0, -40)
	f.videD:SetText("Choisis un membre à gauche.")

	-- bas : compteur + actualiser
	local filetB = page:CreateTexture(nil, "ARTWORK")
	filetB:SetColorTexture(1, 0.82, 0, 0.3)
	filetB:SetHeight(1)
	filetB:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 34)
	filetB:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 34)
	f.bas = page:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.bas:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 16, 14)
	local astuce = page:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	astuce:SetPoint("BOTTOM", f, "BOTTOM", 20, 14)
	astuce:SetText("Ouvre chacun de tes métiers une fois pour partager tes recettes.")
	local actualiser = CreateFrame("Button", nil, page, "UIPanelButtonTemplate")
	actualiser:SetSize(100, 22)
	actualiser:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 9)
	actualiser:SetText("Actualiser")
	local dernierQ = 0
	actualiser:SetScript("OnClick", function()
		LireNiveaux()
		DemanderRoster()
		if GetTime() - dernierQ > 10 then
			dernierQ = GetTime()
			Envoyer("Q")
		end
		MajFenetre()
	end)

	-- liste de guilde rafraîchie de temps en temps tant que la fenêtre est ouverte
	local attenteRoster = 0
	page:SetScript("OnUpdate", function(_, ecoule)
		attenteRoster = attenteRoster + ecoule
		if attenteRoster > 30 then
			attenteRoster = 0
			DemanderRoster()
		end
	end)
	page:SetScript("OnShow", function()
		LireNiveaux()
		DemanderRoster()
		MajFenetre()
	end)
	return page
end
ns.CreerPageRegistre = CreerPage

-- Bouton « Métiers » du volet, /smb metiers : la fenêtre commune, onglet Registre
ns.BasculerMetiers = function()
	if ns.BasculerArtisanat then ns.BasculerArtisanat(1) end
end

--------------------------------------------------------------------------------
-- /smb diag
--------------------------------------------------------------------------------

ns.DiagMetiers = function(L)
	local function api(nom, v) return nom .. "=" .. tostring(v ~= nil) end
	L("métiers :")
	L("  API : " .. table.concat({
		api("GetNumSkillLines", GetNumSkillLines), api("GetProfessions", GetProfessions),
		api("GetTradeSkillLine", GetTradeSkillLine), api("GetTradeSkillRecipeLink", GetTradeSkillRecipeLink),
		api("GetTradeSkillItemLink", GetTradeSkillItemLink), api("GetCraftInfo", GetCraftInfo),
		api("C_TradeSkillUI.GetAllRecipeIDs", C_TradeSkillUI and C_TradeSkillUI.GetAllRecipeIDs),
	}, ", "))
	if GetNumSkillLines and GetSkillLineInfo then
		local t = {}
		for i = 1, GetNumSkillLines() do
			local nom, entete, ouvert, rang, _, _, max = GetSkillLineInfo(i)
			if entete then
				t[#t + 1] = "[" .. tostring(nom) .. (ouvert and "" or " replié") .. "]"
			else
				local m = MetierParNom(nom)
				if m then t[#t + 1] = ("%s %s/%s=%s"):format(tostring(nom), tostring(rang), tostring(max), m.code) end
			end
		end
		L("  compétences : " .. table.concat(t, " "))
	end
	local moi = MesDonnees()
	local t = {}
	for _, m in ipairs(METIERS) do
		local p = moi.profs[m.code]
		if p then t[#t + 1] = ("%s %d/%d (%d recettes)"):format(m.code, p.n or 0, p.max or 0, #(p.r or {})) end
	end
	L("  mes métiers : " .. (#t > 0 and table.concat(t, ", ") or "aucun"))
	local ex = {}
	for _, m in ipairs(METIERS) do
		local p = moi.profs[m.code]
		if p and p.r and p.r[1] and #ex < 4 then
			local code = p.r[1]
			local nomR, icone = InfoRecette(code)
			ex[#ex + 1] = ("%s=%s (icône %s)"):format(code, tostring(nomR), tostring(icone))
		end
	end
	L("  exemples de recettes : " .. (#ex > 0 and table.concat(ex, ", ") or "aucune"))
	L("  dernière lecture de recettes : " .. (derniereLecture or "aucune (ouvre une fenêtre de métier)"))
	do
		local sp = {}
		for code, pr in pairs(MesDonnees().profs) do
			if type(pr) == "table" then
				local n = 0
				for _ in pairs(type(pr.sp) == "table" and pr.sp or {}) do n = n + 1 end
				sp[#sp + 1] = code .. "=" .. (type(pr.sp) == "table" and n or "?")
			end
		end
		L("  recettes spéciales (mes métiers) : " .. table.concat(sp, ", ") .. " ; GetRecipeSourceText="
			.. tostring(C_TradeSkillUI and C_TradeSkillUI.GetRecipeSourceText ~= nil))
		local ent = {}
		for _, m in ipairs(METIERS) do
			local t = Entraineur(m.code)
			if t then
				local a, b = 0, 0
				for _ in pairs(t.o) do a = a + 1 end
				for _ in pairs(t.n) do b = b + 1 end
				ent[#ent + 1] = ("%s=%d+%d"):format(m.code, a, b)
			end
		end
		L("  listes d'entraîneur : " .. (#ent > 0 and table.concat(ent, ", ") or "aucune (ouvre un maître de métier)")
			.. " ; " .. (derniereLectureEntraineur or "pas de lecture cette session"))
	end
	local inconnus = {}
	for _, m in ipairs(METIERS) do if not m.existe then inconnus[#inconnus + 1] = m.code end end
	L("  métiers absents du jeu : " .. (#inconnus > 0 and table.concat(inconnus, " ") or "aucun"))
	local g = Guilde()
	local n = 0
	if g then for _ in pairs(g) do n = n + 1 end end
	local rn, exemple = 0, nil
	for cle, r in pairs(roster) do
		rn = rn + 1
		if cle == MaCle() then exemple = r.nom end
	end
	L(("  guilde : %s, %d fiche(s) reçue(s), liste de guilde %d membre(s) listé(s), mon nom dans la liste = %s"):format(
		tostring(GetGuildInfo("player")), n, rn, tostring(exemple)))
	L(("  messages : %d envoyé(s), %d reçu(s), %d bloqué(s) puis réessayé(s), %d en attente"):format(
		stats.envoyes, stats.recus, stats.bloques, #file))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

do
	local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
	if inscription then pcall(inscription, PREFIXE) end
end

local ev = CreateFrame("Frame")
for _, nom in ipairs({
	"PLAYER_ENTERING_WORLD", "CHAT_MSG_ADDON", "SKILL_LINES_CHANGED",
	"TRADE_SKILL_SHOW", "TRADE_SKILL_UPDATE", "TRADE_SKILL_LIST_UPDATE",
	"CRAFT_SHOW", "CRAFT_UPDATE", "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE",
	"GET_ITEM_INFO_RECEIVED", "TRAINER_SHOW", "TRAINER_UPDATE",
}) do
	pcall(ev.RegisterEvent, ev, nom) -- certains évènements n'existent pas selon la version du jeu
end

-- lectures regroupées : ces évènements arrivent souvent en rafale
local prevu = {}
local function Plus_tard(cle, delai, fonction)
	if prevu[cle] then return end
	prevu[cle] = true
	C_Timer.After(delai, function()
		prevu[cle] = nil
		local ok, err = pcall(fonction)
		if not ok then derniereLecture = "ERREUR " .. tostring(err) end
	end)
end

local premiereEntree = true
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "CHAT_MSG_ADDON" then
		Recevoir(a1, a2, a3, a4)
	elseif event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_UPDATE" or event == "TRADE_SKILL_LIST_UPDATE" then
		Plus_tard("metier", 0.5, LireMetierOuvert)
	elseif event == "CRAFT_SHOW" or event == "CRAFT_UPDATE" then
		Plus_tard("craft", 0.5, LireArtisanatOuvert)
	elseif event == "TRAINER_SHOW" or event == "TRAINER_UPDATE" then
		if not lectureEntraineur then Plus_tard("entraineur", 0.5, LireEntraineur) end
	elseif event == "SKILL_LINES_CHANGED" then
		Plus_tard("niveaux", 2, LireNiveaux)
	elseif event == "GUILD_ROSTER_UPDATE" or event == "PLAYER_GUILD_UPDATE" then
		LireRoster()
		if PlanifierMaj then PlanifierMaj(0.3) end
	elseif event == "GET_ITEM_INFO_RECEIVED" then
		if PlanifierMaj then PlanifierMaj(0.5) end
	elseif event == "PLAYER_ENTERING_WORLD" and premiereEntree then
		premiereEntree = false
		-- anciennes fiches de test (mode « me voir comme un autre membre »)
		for _, g in pairs(Base().guildes) do
			if type(g) == "table" and not TestSolo() then
				for cle in pairs(g) do
					if type(cle) == "string" and cle:find("#test", 1, true) then g[cle] = nil end
				end
			end
		end
		C_Timer.After(8, function()
			pret = true
			pcall(LireNiveaux)
			DemanderRoster()
			EnvoyerResume()
			Envoyer("Q")

		end)
	end
end)
