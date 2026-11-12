-- GuildUpSMB : registre des métiers de la guilde.
-- Chaque GuildUpSMB lit les niveaux de métier du joueur (fenêtre des compétences) et les recettes connues
-- (relevées quand le joueur ouvre sa fenêtre de métier : le jeu ne les donne qu'à ce moment-là),
-- puis les partage avec les autres membres qui ont l'addon. Les fiches reçues sont gardées
-- (GuildUpMetiersDB) : on voit aussi les membres hors ligne.
-- Interface : onglet « Registre » de la page Artisanat de la fenêtre GuildUpSMB (kit ns.UI ; la page
-- et ses onglets sont dans GuildUp_Carnet.lua) : filtres par métier, recherche, membres, fiche.
--
-- Messages d'addon sur le canal de guilde (préfixe "GuildUpMet") :
--   "Q"                                        demande : « envoyez vos résumés »
--   "S~niveau~CLASSE~AL,225,300,40,empreinte;CU,..."  résumé : métier, niveau, max, nb de recettes, empreinte
--   "D~AL~Nom-Royaume"                         demande les recettes d'un métier d'un membre
--   "R~AL~empreinte~n~total~i1a2b,s3c4,..."    recettes (par morceaux), diffusées à toute la guilde
--   "C~cible~recette~id~quantité"              commande d'artisanat (lue seulement par la cible)
--   "K~cible~id~1|0~recette"                   réponse à une commande (acceptée / refusée)
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

-- minuscules sans accents, pour comparer et chercher (« Écaille » = « ecaille »)
local Simplifier = ns.Simplifier

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

local InfoObjet = ns.InfoObjet

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

local Base36 = ns.Base36

local function Empreinte(liste)
	if #liste == 0 then return "0" end
	local h = 5381
	for _, c in ipairs(liste) do
		for i = 1, #c do h = (h * 33 + c:byte(i)) % 2147483629 end
		h = (h * 33 + 44) % 2147483629
	end
	return Base36(h)
end

local Normaliser = ns.Normaliser

local MaCle = ns.MaCle
local TestSolo = ns.TestSolo

local Depuis = ns.Depuis

local CouleurClasse = ns.CouleurClasse

-- Nom affiché : complet, « Prénom Famille » (« Miko-Banko » devient « Miko Banko »)
local NomCourt = ns.NomCourt

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

-- Purge à la connexion : fiches non vues depuis 90 jours (toutes guildes), anciens membres de ma
-- guilde (absents de la liste de guilde et non vus depuis 7 jours), restes de l'ancien système
-- d'entraîneurs et des « recettes spéciales » (champ sp)
local OUBLI_FICHE, OUBLI_ANCIEN_MEMBRE = 90 * 86400, 7 * 86400
local function PurgerFiches()
	local b = Base()
	b.entraineur = nil
	for _, e in pairs(b.moi) do
		if type(e) == "table" and type(e.profs) == "table" then
			for _, p in pairs(e.profs) do if type(p) == "table" then p.sp = nil end end
		end
	end
	local maintenant = time()
	local maGuilde = IsInGuild() and GetGuildInfo("player") or nil
	for nomG, g in pairs(b.guildes) do
		if type(g) ~= "table" then
			b.guildes[nomG] = nil
		else
			for cle, e in pairs(g) do
				local age = maintenant - (type(e) == "table" and e.vu or 0)
				if type(e) ~= "table" or age > OUBLI_FICHE
					or (nomG == maGuilde and age > OUBLI_ANCIEN_MEMBRE and ns.MembreGuilde and ns.MembreGuilde(cle) == false) then
					g[cle] = nil
				end
			end
			if not next(g) then b.guildes[nomG] = nil end
		end
	end
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

-- Pour GuildUp_Echanges.lua : mon niveau dans un métier (nil si je ne l'ai pas)
ns.MonNiveauMetier = function(code)
	local p = MesDonnees().profs[code]
	return p and p.n
end

--------------------------------------------------------------------------------
-- Envoi (file d'attente : le jeu limite le nombre de messages d'addon par seconde)
--------------------------------------------------------------------------------

-- (file commune : ns.EnvoyerAddon, GuildUp_Reseau.lua)
local function Envoyer(texte) ns.EnvoyerAddon(PREFIXE, texte, "GUILD") end

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
	if PlanifierMaj then PlanifierMaj() end -- (refait aussi l'index des artisans)
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
	local liste = {}
	for _, id in ipairs(T.GetAllRecipeIDs() or {}) do
		local r = T.GetRecipeInfo(id)
		if r and r.learned then
			-- de préférence l'objet fabriqué (nom, icône, qualité et infobulle de l'objet)
			local objet = ObjetFabrique(id)
			local code = objet and ("i" .. objet) or ("s" .. id)
			liste[#liste + 1] = code
		end
	end
	-- cette API donne toutes les recettes apprises d'un coup : la liste remplace l'ancienne
	Fusionner(m, info.skillLevel, info.maxSkillLevel, liste, "C_TradeSkillUI", true)
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
local reassembleur = ns.Reassembleur(60) -- recettes en cours de réception (par membre et métier)

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
	local mots = {}
	for _, c in ipairs(p.r) do
		local id = tonumber(c:sub(2))
		if id then mots[#mots + 1] = c:sub(1, 1) .. Base36(id) end
	end
	local morceaux = ns.Morceaux(mots, TAILLE_MORCEAU)
	for i, txt in ipairs(morceaux) do
		Envoyer(("R~%s~%s~%d~%d~%s"):format(code, p.h or "0", i, #morceaux, txt))
	end
end

local function Demander(g, cle, code, force)
	local k = cle .. code
	if demandes[k] and GetTime() - demandes[k] < 60 then return end
	local prevue = GetTime()
	demandes[k] = prevue
	-- petit délai au hasard : si un autre membre demande la même liste entre-temps (demandes[k]
	-- mis à jour à la réception de son « D »), elle arrive pour tout le monde : on se tait
	C_Timer.After(0.5 + math.random() * 2.5, function()
		if demandes[k] ~= prevue then return end
		local e = g[cle]
		local p = e and e.profs and e.profs[code]
		if p and (force or (p.attendu and p.h ~= p.attendu)) then
			Envoyer(("D~%s~%s"):format(code, cle))
		end
	end)
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

	elseif genre == "D" then
		local code, cible = strsplit("~", reste)
		local moi = MaCle()
		if PAR_CODE[code] and (cible == moi or (TestSolo() and cible == moi .. "#test")) then
			DiffuserRecettes(code)
		elseif code and cible then
			demandes[cible .. code] = GetTime() -- un autre l'a demandée : la réponse viendra pour tous
		end

	elseif genre == "R" then
		local code, h, part, total, ids = strsplit("~", reste)
		part, total = tonumber(part), tonumber(total)
		if not PAR_CODE[code] or not part or not total or total < 1 or total > 60 or part > total then return end
		local e = Fiche(g, cle, nom)
		local p = e.profs[code]
		if type(p) ~= "table" then p = { r = {} }; e.profs[code] = p end
		if p.h == h then return end -- déjà à jour
		local parts = reassembleur:Ajouter(cle .. code, h, part, total, ids)
		if parts then
			local liste = {}
			for i = 1, #parts do
				for mot in parts[i]:gmatch("[^,]+") do
					local genreR, id = mot:sub(1, 1), tonumber(mot:sub(2), 36)
					if id and (genreR == "s" or genreR == "i") then liste[#liste + 1] = genreR .. id end
				end
			end
			table.sort(liste)
			p.r, p.h, p.nr, p.attendu = liste, h, #liste, nil
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
-- classe d'un membre d'après la liste de guilde (« WARRIOR »…), nil s'il n'y est pas
ns.ClasseMembre = function(cle) return cle and roster[(cle:gsub("#test$", ""))] and roster[(cle:gsub("#test$", ""))].classe end

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

-- Pour GuildUp_Besoins.lua et GuildUp_Echanges.lua
ns.EnLigneMembre = function(cle) return EnLigne(cle, { vu = 0 }) end
ns.DemanderRoster = function() DemanderRoster() end
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

--------------------------------------------------------------------------------
-- Onglet « Registre » de la page Artisanat (fenêtre GuildUpSMB, kit ns.UI)
-- En haut : « Tous » et un bouton par métier (filtre ; re-clic : retiré), recherche « joueur ou
-- recette », case « recettes spéciales », Actualiser. À gauche les membres, à droite la fiche du
-- membre choisi (métiers repliables, recettes : clic = commander, Maj-clic = lien).
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI.C
local MARGE = 16
local LARGEUR_MEMBRES = 290
local HAUTEUR_MEMBRE, ECART_MEMBRE = 44, 6
local HAUT_CORPS = -136                 -- haut des colonnes (sous les filtres et la recherche)
local ICONE_INCONNUE = "Interface\\Icons\\INV_Misc_QuestionMark"
local GRIS_HORS_LIGNE = { 0.35, 0.33, 0.27 }

local fen                -- le cadre de l'onglet (créé à la première ouverture)
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

local indexArtisans          -- [code recette] = { { f = fiche, metier, p }, … } ; nil = à reconstruire
local function InvaliderIndex() indexArtisans = nil end

-- l'onglet est-il à l'écran ? (page Artisanat de la fenêtre GuildUpSMB, onglet 1)
local function OngletVisible()
	if ns.ArtisanatVisible then return ns.ArtisanatVisible(1) end
	return fen ~= nil and fen:IsVisible()
end

-- rafraîchissement regroupé (rafales d'évènements, frappe dans la recherche)
local function MajBientot(delai)
	if not fen or majPrevue or not OngletVisible() then return end
	majPrevue = true
	C_Timer.After(delai or 0.2, function()
		majPrevue = false
		if fen and OngletVisible() and ns.MajInterface then ns.MajInterface() end
	end)
end

PlanifierMaj = function(delai)
	-- données de métiers changées (fiche reçue, recettes lues) : l'index des artisans est à refaire
	InvaliderIndex()
	MajBientot(delai)
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

-- Index inversé : pour chaque recette, les membres qui la connaissent (reconstruit après un
-- changement des données, ou au plus toutes les 60 s)
local function IndexArtisans()
	if indexArtisans and GetTime() - indexArtisans.t < 60 then return indexArtisans.parCode end
	local parCode = {}
	for _, f in ipairs(Fiches()) do
		for metier, p in pairs(f.e.profs or {}) do
			if type(p) == "table" and type(p.r) == "table" then
				for _, c in ipairs(p.r) do
					local l = parCode[c]
					if not l then l = {}; parCode[c] = l end
					l[#l + 1] = { f = f, metier = metier, p = p }
				end
			end
		end
	end
	indexArtisans = { t = GetTime(), parCode = parCode }
	return parCode
end

-- Pour le carnet de craft : qui sait fabriquer cet objet (moi compris), en ligne d'abord
ns.ArtisansDe = function(objet)
	local res = {}
	for _, a in ipairs(IndexArtisans()["i" .. tostring(objet)] or {}) do
		local f = a.f
		res[#res + 1] = { cle = f.cle, nom = f.e.nom or f.cle, moi = f.moi, metier = a.metier,
			niveau = a.p.n, enLigne = f.moi or EnLigne(f.cle, f.e) }
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

-- Barre d'avancement plate (celle du carnet, GuildUp_Carnet.lua ; repli : barre simple)
local function Barre(parent, hauteur)
	local B = ns.OutilsCarnet and ns.OutilsCarnet.Barre
	if B then return B(parent, hauteur) end
	local b = CreateFrame("StatusBar", nil, parent)
	b:SetHeight(hauteur or 6)
	b:SetStatusBarTexture("Interface\\Buttons\\WHITE8X8")
	b:SetStatusBarColor(C.orFonce[1], C.orFonce[2], C.orFonce[3], 1)
	return b
end

-- Rangée d'un membre (colonne de gauche) : point en ligne, nom, zone ou « vu il y a », métiers à droite
local function CreerLigneMembre(parent)
	local b = UI.Rangee(parent, HAUTEUR_MEMBRE)
	b.point = b:CreateTexture(nil, "ARTWORK")
	b.point:SetTexture(UI.ROND)
	b.point:SetSize(8, 8)
	b.point:SetPoint("LEFT", b, "LEFT", 10, 0)
	b.nom = UI.Texte(b, "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b, "TOPLEFT", 26, -7)
	b.sous = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.sous:SetPoint("TOPLEFT", b.nom, "BOTTOMLEFT", 0, -3)
	-- jusqu'à quatre métiers (icône, niveau dessous), du plus à droite vers la gauche
	b.metiers = {}
	for i = 1, 4 do
		local ic = b:CreateTexture(nil, "ARTWORK")
		ic:SetSize(16, 16)
		ic:SetPoint("TOPRIGHT", b, "TOPRIGHT", -14 - (i - 1) * 30, -6)
		ic:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		local t = UI.Texte(b, "GameFontHighlightSmall", C.texte)
		t:SetPoint("TOP", ic, "BOTTOM", 0, -2)
		t:SetJustifyH("CENTER")
		b.metiers[i] = { icone = ic, texte = t }
	end
	-- métier filtré : pastille « icône n / max »
	b.pilule = UI.Cadre(b, { 0.165, 0.137, 0.094, 1 })
	b.pilule:SetHeight(20)
	b.pilule:SetPoint("RIGHT", b, "RIGHT", -10, 0)
	b.pilule.icone = b.pilule:CreateTexture(nil, "ARTWORK")
	b.pilule.icone:SetSize(14, 14)
	b.pilule.icone:SetPoint("LEFT", b.pilule, "LEFT", 5, 0)
	b.pilule.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	b.pilule.texte = UI.Texte(b.pilule, "GameFontHighlightSmall", C.texte)
	b.pilule.texte:SetPoint("LEFT", b.pilule.icone, "RIGHT", 5, 0)

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
		GameTooltip:AddLine("Clic : voir sa fiche", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

local function RemplirLigneMembre(b, f, choisi)
	local e = f.e
	b.cle, b.e = f.cle, e
	b.point:SetVertexColor(unpack(f.enLigne and C.vert or GRIS_HORS_LIGNE))
	b.nom:SetText(NomCourt(e.nom or f.cle) .. (f.moi and " |cff9c937f(toi)|r" or ""))
	b.nom:SetTextColor(CouleurClasse(e.classe))
	if recherche ~= "" and f.trouvees > 0 then
		local s = f.trouvees > 1 and "s" or ""
		b.sous:SetText(("|cff6fd08c%d recette%s trouvée%s|r"):format(f.trouvees, s, s))
	elseif f.enLigne then
		local zone = f.moi and GetRealZoneText and GetRealZoneText() or (roster[f.cle] and roster[f.cle].zone)
		b.sous:SetText(zone and zone ~= "" and zone or "En ligne")
	else
		b.sous:SetText("Hors ligne" .. (e.vu and (" · vu il y a " .. Depuis(e.vu)) or ""))
	end
	b:SetBackdropColor(unpack(choisi and C.actif or C.carte))
	b:SetBackdropBorderColor(unpack(choisi and C.orFonce or C.bord))

	for _, s in ipairs(b.metiers) do s.icone:Hide(); s.texte:Hide() end
	b.pilule:Hide()
	local droite = 10
	if filtre then
		local p = e.profs and e.profs[filtre]
		if p then
			b.pilule.icone:SetTexture(PAR_CODE[filtre].icone)
			b.pilule.texte:SetText(("%d / %d"):format(p.n or 0, p.max or 0))
			b.pilule:SetWidth(b.pilule.texte:GetStringWidth() + 32)
			b.pilule:Show()
			droite = b.pilule.texte:GetStringWidth() + 50
		end
	else
		-- métiers principaux d'abord (ordre de METIERS), quatre au plus
		local tous = {}
		for _, m in ipairs(METIERS) do
			local p = e.profs and e.profs[m.code]
			if p then tous[#tous + 1] = { m = m, p = p } end
		end
		local i = 0
		for j = math.min(#tous, 4), 1, -1 do
			i = i + 1
			local s, x = b.metiers[i], tous[j]
			s.icone:SetTexture(x.m.icone)
			s.texte:SetText(tostring(x.p.n or 0))
			s.icone:Show()
			s.texte:Show()
		end
		if i > 0 then droite = 14 + i * 30 end
	end
	b.nom:SetPoint("RIGHT", b, "RIGHT", -droite, 0)
	b.sous:SetPoint("RIGHT", b, "RIGHT", -droite, 0)
end

-- Lignes de la fiche (colonne de droite, réutilisées) : métier, recette, information
local function Prendre(genre)
	local pool = pools[genre]
	pool.utilisees = (pool.utilisees or 0) + 1
	local l = pool[pool.utilisees]
	if l then return l end
	l = CreateFrame("Button", nil, fen.detail.contenu)
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	if genre == "metier" then
		-- en-tête de métier : « + / - », icône, nom (nombre de recettes), barre n / max ; clic = replier
		l:SetHeight(36)
		l.filet = UI.Filet(l)
		l.filet:SetPoint("TOPLEFT", l, "TOPLEFT", 0, 0)
		l.filet:SetPoint("TOPRIGHT", l, "TOPRIGHT", 0, 0)
		l.signe = UI.Texte(l, "GameFontNormal", C.ors)
		l.signe:SetPoint("LEFT", l, "LEFT", 2, 0)
		l.icone:SetSize(20, 20)
		l.icone:SetPoint("LEFT", l, "LEFT", 18, 0)
		l.texte = UI.Texte(l, "GameFontNormal", C.texte)
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 8, 0)
		l.texte:SetWidth(156)
		l.niveau = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.niveau:SetPoint("RIGHT", l, "RIGHT", -8, 0)
		l.niveau:SetJustifyH("RIGHT")
		l.barre = Barre(l, 6)
		l.barre:SetPoint("LEFT", l, "LEFT", 210, 0)
		l.barre:SetPoint("RIGHT", l.niveau, "LEFT", -10, 0)
		UI.Survol(l, 0.04)
		l:SetScript("OnClick", function(self)
			if not self.code then return end
			local o = Base().ouverts
			o[self.code] = not o[self.code] or nil
			MajFenetre()
		end)
	elseif genre == "info" then
		l:SetHeight(22)
		l.icone:Hide()
		l.texte = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.texte:SetPoint("LEFT", l, "LEFT", 18, 0)
		l.texte:SetPoint("RIGHT", l, "RIGHT", -8, 0)
		l:EnableMouse(false)
	else
		-- recette : icône, nom (couleur de qualité), « clic : commander » au survol
		l:SetHeight(28)
		l.icone:SetSize(20, 20)
		l.icone:SetPoint("LEFT", l, "LEFT", 18, 0)
		l.indice = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.indice:SetPoint("RIGHT", l, "RIGHT", -8, 0)
		l.indice:SetJustifyH("RIGHT")
		l.indice:Hide()
		l.texte = UI.Texte(l, "GameFontHighlight", C.texte)
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 8, 0)
		l.texte:SetPoint("RIGHT", l, "RIGHT", -110, 0)
		UI.Survol(l, 0.05)
		l:SetScript("OnEnter", function(self)
			if self.commande then
				self.indice:SetText(self.commande.enLigne and "clic : commander" or "hors ligne")
				self.indice:Show()
			end
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
		l:SetScript("OnLeave", function(self)
			self.indice:Hide()
			GameTooltip:Hide()
		end)
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

-- pose une ligne de la fiche à la hauteur y
local function Poser(l, y)
	local c = fen.detail.contenu
	l:ClearAllPoints()
	l:SetPoint("TOPLEFT", c, "TOPLEFT", 0, -y)
	l:SetPoint("RIGHT", c, "RIGHT", 0, 0)
	l:Show()
end

local function MajDetail(f)
	ViderPools()
	if not f then
		fen.dNom:SetText("")
		fen.dEtat:SetText("")
		fen.mp:Hide()
		fen.videD:Show()
		fen.detail:Hauteur(10)
		return
	end
	fen.videD:Hide()
	local e = f.e
	fen.dNom:SetText(NomCourt(e.nom or f.cle))
	fen.dNom:SetTextColor(CouleurClasse(e.classe))
	local etat
	if f.enLigne then
		local zone = f.moi and GetRealZoneText and GetRealZoneText() or (roster[f.cle] and roster[f.cle].zone)
		etat = "|cff6fd08cen ligne|r" .. (zone and zone ~= "" and (" · " .. zone) or "")
	else
		etat = "hors ligne" .. (e.vu and (" · vu il y a " .. Depuis(e.vu)) or "")
	end
	fen.dEtat:SetText((e.niveau and e.niveau > 0 and ("Niveau " .. e.niveau .. " · ") or "") .. etat)
	fen.mp:Show()
	fen.mp.cle, fen.mp.e = f.cle, e
	fen.mp:Activer(f.enLigne and not f.moi)

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
				local l = Prendre("metier")
				Poser(l, y)
				l.code = not force and m.code or nil
				l.signe:SetText(ouvert and "-" or "+")
				l.signe:SetShown(not force and (#recettes > 0 or not m.recolte))
				l.icone:SetTexture(m.icone)
				l.texte:SetText(NomMetier(m) .. (#recettes > 0 and ("  |cff9c937f(" .. #recettes .. ")|r") or ""))
				l.texte:SetTextColor(unpack(ouvert and C.ors or C.texte))
				l.niveau:SetText(("%d / %d"):format(p.n or 0, p.max or 0))
				l.barre:SetMinMaxValues(0, math.max(p.max or 1, 1))
				l.barre:SetValue(p.n or 0)
				y = y + 38

				-- recettes triées par nom (les noms inconnus du cache arrivent un peu après)
				if not ouvert then recettes = {} end
				local noms = {}
				for _, code in ipairs(recettes) do noms[code] = (InfoRecette(code)) end
				table.sort(recettes, function(a, b) return (noms[a] or "~") < (noms[b] or "~") end)
				for _, code in ipairs(recettes) do
					local r = Prendre("recette")
					Poser(r, y)
					local nomR, icone, lien, hyper, qualite = InfoRecette(code)
					r.icone:SetTexture(icone or ICONE_INCONNUE)
					r.texte:SetText(nomR or "|cff9c937fchargement…|r")
					local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
					if qc and nomR then r.texte:SetTextColor(qc.r, qc.g, qc.b) else r.texte:SetTextColor(unpack(C.texte)) end
					r.lien, r.hyper, r.code = lien, hyper, code
					r.commande = (not f.moi) and { cle = f.cle, nom = e.nom or f.cle, enLigne = f.enLigne } or nil
					y = y + 28
				end
				if ouvert and #recettes == 0 and not m.recolte then
					local i = Prendre("info")
					Poser(i, y)
					if Speciales() and (p.nr or #(p.r or {})) > 0 then
						i.texte:SetText("Aucune recette apprise avec un plan.")
					elseif (p.nr or 0) > 0 then
						i.texte:SetText("Recettes en cours de réception…")
					elseif f.moi then
						i.texte:SetText("Ouvre ta fenêtre de métier pour partager tes recettes.")
					else
						i.texte:SetText("Pas encore de recettes : il doit ouvrir sa fenêtre de métier.")
					end
					y = y + 22
				end
				y = y + 4
			end
		end
	end
	if y == 0 then
		local i = Prendre("info")
		Poser(i, 0)
		i.texte:SetText(filtre and "Ce métier n'est pas connu." or "Aucun métier connu.")
		y = 22
	end
	fen.detail:Hauteur(y)
end

MajFenetre = function()
	if not fen then return end
	-- filtres : choisi en surbrillance, les autres grisés
	for code, bt in pairs(fen.filtres) do
		local choisi = filtre == code
		bt:SetBackdropColor(unpack(choisi and C.actif or C.carte))
		bt:SetBackdropBorderColor(unpack(choisi and C.orFonce or C.bord))
		bt.icone:SetDesaturated(filtre ~= nil and not choisi)
		bt.icone:SetAlpha((filtre == nil or choisi) and 1 or 0.55)
	end
	fen.tous:SetBackdropColor(unpack(filtre and { 0, 0, 0, 0 } or C.actif))
	fen.tous:SetBackdropBorderColor(unpack(filtre and C.bordMoyen or C.orFonce))
	fen.nomFiltre:SetText(filtre and (NomMetier(PAR_CODE[filtre]) .. " · classé par niveau") or "")
	fen.speciales:Poser(Speciales())

	local liste, _, enLigne = ListeAffichee()
	local choisie
	for _, f in ipairs(liste) do if f.cle == selection then choisie = f end end
	if not choisie then
		choisie = liste[1]
		selection = choisie and choisie.cle
	end
	local y = 0
	local contenu = fen.membres.contenu
	for i, f in ipairs(liste) do
		local b = lignesMembres[i]
		if not b then
			b = CreerLigneMembre(contenu)
			lignesMembres[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", contenu, "TOPLEFT", 0, -y)
		b:SetPoint("RIGHT", contenu, "RIGHT", 0, 0)
		RemplirLigneMembre(b, f, f.cle == selection)
		b:Show()
		y = y + HAUTEUR_MEMBRE + ECART_MEMBRE
	end
	for i = #liste + 1, #lignesMembres do lignesMembres[i]:Hide() end
	fen.membres:Hauteur(y)
	fen.videG:SetShown(#liste == 0)
	fen.videG:SetText(Speciales() and "Personne n'a de recette spéciale (ou ne l'a pas encore partagée)."
		or recherche ~= "" and "Personne ne correspond à ta recherche."
		or filtre and "Personne n'a ce métier (parmi les membres qui ont GuildUpSMB)."
		or "Personne pour l'instant.")
	MajDetail(choisie)
	fen.bas:SetText(("|cff6fd08c%d en ligne|r · ouvre chacun de tes métiers une fois pour partager tes recettes"):format(enLigne))
end

-- Onglet « Registre » : créé par la page Artisanat (GuildUp_Carnet.lua) dans son cadre, sous les onglets
local function CreerPage(parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetAllPoints()
	fen = f

	-- à droite des onglets : membres en ligne et astuce
	f.bas = UI.Texte(f, "GameFontHighlightSmall", C.gris)
	f.bas:SetPoint("TOPRIGHT", f, "TOPRIGHT", -MARGE, -24)
	f.bas:SetJustifyH("RIGHT")

	-- filtres par métier : « Tous », puis une icône par métier
	f.filtres = {}
	f.tous = UI.Bouton(f, "Tous", "fantome", 56, 32)
	f.tous:SetPoint("TOPLEFT", f, "TOPLEFT", MARGE, -54)
	f.tous:SetScript("OnClick", function() filtre = nil; fen.membres:Haut(); MajFenetre() end)
	UI.Infobulle(f.tous, "Tous les métiers", "Montre tous les membres, quel que soit leur métier.")
	local x = MARGE + 62
	for _, m in ipairs(METIERS) do
		if m.existe or not (GetSpellInfo or (C_Spell and C_Spell.GetSpellInfo)) then
			local bt = CreateFrame("Button", nil, f, "BackdropTemplate")
			UI.Habiller(bt, C.carte, C.bord)
			bt:SetSize(32, 32)
			bt:SetPoint("TOPLEFT", f, "TOPLEFT", x, -54)
			bt.icone = bt:CreateTexture(nil, "ARTWORK")
			bt.icone:SetPoint("TOPLEFT", bt, "TOPLEFT", 3, -3)
			bt.icone:SetPoint("BOTTOMRIGHT", bt, "BOTTOMRIGHT", -3, 3)
			bt.icone:SetTexture(m.icone)
			bt.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
			UI.Survol(bt, 0.12)
			if ns.SonsSurBoutons then ns.SonsSurBoutons(bt) end
			bt:SetScript("OnClick", function()
				filtre = (filtre ~= m.code) and m.code or nil
				fen.membres:Haut()
				MajFenetre()
			end)
			bt:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
				GameTooltip:SetText(NomMetier(m))
				GameTooltip:AddLine(filtre == m.code and "Clic : revenir à tous les métiers."
					or "Clic : voir seulement ce métier, classé par niveau.", 1, 1, 1, true)
				GameTooltip:Show()
			end)
			bt:SetScript("OnLeave", function() GameTooltip:Hide() end)
			f.filtres[m.code] = bt
			x = x + 36
		end
	end
	f.nomFiltre = UI.Texte(f, "GameFontHighlightSmall", C.gris)
	f.nomFiltre:SetPoint("LEFT", f, "TOPLEFT", x + 6, -70)
	f.nomFiltre:SetPoint("RIGHT", f, "TOPRIGHT", -MARGE, -70)

	-- recherche (joueur ou recette), recettes spéciales, Actualiser
	f.actualiser = UI.Bouton(f, "Actualiser", "fantome", 100, 32)
	f.actualiser:SetPoint("TOPRIGHT", f, "TOPRIGHT", -MARGE, -94)
	local dernierQ = 0
	f.actualiser:SetScript("OnClick", function()
		LireNiveaux()
		DemanderRoster()
		if GetTime() - dernierQ > 10 then
			dernierQ = GetTime()
			Envoyer("Q")
		end
		MajFenetre()
	end)
	UI.Infobulle(f.actualiser, "Actualiser", "Relit tes métiers et la liste de guilde, et redemande les fiches à la guilde (une fois toutes les 10 secondes).")
	-- « Recettes spéciales » : cache les recettes d'entraîneur, garde celles des plans trouvés
	f.speciales = UI.Case(f, "Seulement les recettes spéciales", function(oui)
		Base().speciales = oui or nil
		fen.membres:Haut()
		MajFenetre()
	end)
	f.speciales:SetPoint("RIGHT", f.actualiser, "LEFT", -16, 0)
	f.speciales:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText("Recettes spéciales")
		GameTooltip:AddLine("Cache les recettes apprises chez l'entraîneur : il ne reste que celles apprises avec un plan (butin, vendeur, quête…).", 1, 1, 1, true)
		GameTooltip:AddLine("D'après les données du jeu : toutes les recettes qu'un objet « Recette » / « Plans » apprend.", 0.6, 0.6, 0.6, true)
		GameTooltip:Show()
	end)
	f.speciales:SetScript("OnLeave", function() GameTooltip:Hide() end)
	f.recherche = UI.Champ(f, 380, "Joueur ou recette (ex. « flacon »)", 32)
	f.recherche:SetPoint("TOPLEFT", f, "TOPLEFT", MARGE, -94)
	f.recherche:SetPoint("RIGHT", f.speciales, "LEFT", -16, 0)
	f.recherche.SurTexte = function(t)
		recherche = Simplifier(strtrim(t or ""))
		fen.membres:Haut()
		MajBientot(0.15)
	end

	-- colonne de gauche : les membres
	f.membres = UI.Liste(f)
	f.membres:SetPoint("TOPLEFT", f, "TOPLEFT", MARGE, HAUT_CORPS)
	f.membres:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", MARGE, MARGE)
	f.membres:SetWidth(LARGEUR_MEMBRES + 8)
	f.videG = UI.Texte(f, "GameFontHighlight", C.gris)
	f.videG:SetPoint("TOPLEFT", f.membres, "TOPLEFT", 4, -8)
	f.videG:SetWidth(LARGEUR_MEMBRES - 8)
	f.videG:SetWordWrap(true)

	-- colonne de droite : fiche du membre choisi
	local d = UI.Cadre(f, C.carte, C.bord)
	d:SetPoint("TOPLEFT", f, "TOPLEFT", MARGE + LARGEUR_MEMBRES + 18, HAUT_CORPS)
	d:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -MARGE, MARGE)
	f.mp = UI.Bouton(d, "Chuchoter", "fantome", 96, 26)
	f.mp:SetPoint("TOPRIGHT", d, "TOPRIGHT", -14, -14)
	f.mp:SetMotionScriptsWhileDisabled(true)
	f.mp:SetScript("OnClick", function(self)
		if self.cle then UI.Chuchoter(self.cle, self.e and self.e.nom) end
	end)
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
	f.dNom = UI.Texte(d, "GameFontNormalLarge")
	f.dNom:SetPoint("TOPLEFT", d, "TOPLEFT", 16, -14)
	f.dNom:SetPoint("RIGHT", f.mp, "LEFT", -10, 0)
	f.dEtat = UI.Texte(d, "GameFontHighlightSmall", C.gris)
	f.dEtat:SetPoint("TOPLEFT", f.dNom, "BOTTOMLEFT", 0, -5)
	f.dEtat:SetPoint("RIGHT", f.mp, "LEFT", -10, 0)
	f.detail = UI.Liste(d)
	f.detail:SetPoint("TOPLEFT", d, "TOPLEFT", 14, -56)
	f.detail:SetPoint("BOTTOMRIGHT", d, "BOTTOMRIGHT", -6, 10)
	f.videD = UI.Texte(d, "GameFontHighlight", C.gris)
	f.videD:SetPoint("TOPLEFT", d, "TOPLEFT", 16, -18)
	f.videD:SetText("Choisis un membre à gauche.")

	-- liste de guilde relue toutes les 30 s tant que l'onglet est affiché
	local attenteRoster = 0
	f:SetScript("OnUpdate", function(_, ecoule)
		attenteRoster = attenteRoster + ecoule
		if attenteRoster > 30 then
			attenteRoster = 0
			DemanderRoster()
		end
	end)
	-- à chaque affichage (et tout de suite : l'onglet est créé déjà affiché), relire mes métiers et la
	-- liste de guilde
	f:SetScript("OnShow", function()
		pcall(LireNiveaux)
		DemanderRoster()
	end)
	pcall(LireNiveaux)
	DemanderRoster()
	f.Maj = MajFenetre
	return f
end
ns.CreerPageRegistre = CreerPage

-- Bouton « Métiers » du volet, /smb metiers : la page Artisanat, onglet Registre (re-clic : fermée)
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
	L("  " .. (ns.StatsReseau and ns.StatsReseau() or "?"))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
for _, nom in ipairs({
	"PLAYER_ENTERING_WORLD", "SKILL_LINES_CHANGED",
	"TRADE_SKILL_SHOW", "TRADE_SKILL_UPDATE", "TRADE_SKILL_LIST_UPDATE",
	"CRAFT_SHOW", "CRAFT_UPDATE", "GUILD_ROSTER_UPDATE", "PLAYER_GUILD_UPDATE",
	"GET_ITEM_INFO_RECEIVED",
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
	if event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_UPDATE" or event == "TRADE_SKILL_LIST_UPDATE" then
		Plus_tard("metier", 0.5, LireMetierOuvert)
	elseif event == "CRAFT_SHOW" or event == "CRAFT_UPDATE" then
		Plus_tard("craft", 0.5, LireArtisanatOuvert)
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
		-- la liste de guilde a eu le temps d'arriver : on sait qui est encore membre
		C_Timer.After(40, function() pcall(PurgerFiches) end)
	end
end)
