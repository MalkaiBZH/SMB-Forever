-- GuildUpSMB : registre des métiers de la guilde.
-- Chaque GuildUpSMB lit les niveaux de métier du joueur (fenêtre des compétences) et les recettes connues
-- (relevées quand le joueur ouvre sa fenêtre de métier : le jeu ne les donne qu'à ce moment-là),
-- puis les partage avec les autres membres qui ont l'addon. Les fiches reçues sont gardées
-- (GuildUpMetiersDB) : on voit aussi les membres hors ligne.
-- Interface : onglet « Registre » de la page Artisanat de la fenêtre GuildUpSMB (kit ns.UI ; la page et
-- ses onglets sont dans GuildUp_Carnet.lua), vu par métier depuis la 7.7.0 : un panneau par métier avec ses
-- meilleurs artisans ; clic sur un panneau : le classement complet et les recettes que la guilde connaît
-- dans ce métier, avec qui sait les faire. Clic sur une recette qu'un autre membre connaît : la page
-- Demandes, formulaire rempli (demande d'artisanat, GuildUp_Demandes.lua).
-- Lit aussi la liste de guilde (en ligne, zone, rang, note…) : ns.RosterGuilde() et ns.FicheMetiers(cle)
-- servent la page Guilde (GuildUp_Membres.lua).
--
-- Messages d'addon (préfixe "GuildUpMet"), sur le canal de guilde :
--   "Q"                                        demande : « envoyez vos résumés »
--   "S~niveau~CLASSE~AL,225,300,40,empreinte;CU,..."  résumé : métier, niveau, max, nb de recettes, empreinte
--   "D~AL~Nom-Royaume"                         demande les recettes d'un métier d'un membre
--   "R~AL~empreinte~n~total~i1a2b,s3c4,..."    recettes (par morceaux), diffusées à toute la guilde
-- (Les commandes d'artisanat « C », « E », « K » ont été retirées en 4.0.0 : remplacées par les demandes.)
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
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)

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
--   (GuildUpMetiersDB.commandes : anciennes commandes, effacées à la connexion depuis la 4.0.0)
-- fiche = { nom, classe, niveau, vu, profs = { AL = { n, max, nr, h, r = { "s123", ... } } } }
--------------------------------------------------------------------------------

local function Base()
	if type(GuildUpMetiersDB) ~= "table" then GuildUpMetiersDB = {} end
	local b = GuildUpMetiersDB
	if type(b.moi) ~= "table" then b.moi = {} end
	if type(b.guildes) ~= "table" then b.guildes = {} end
	return b
end

-- Purge à la connexion : fiches non vues depuis 90 jours (toutes guildes), anciens membres de ma
-- guilde (absents de la liste de guilde et non vus depuis 7 jours), restes de l'ancien système
-- d'entraîneurs et des « recettes spéciales » (champ sp)
local OUBLI_FICHE, OUBLI_ANCIEN_MEMBRE = 90 * 86400, 7 * 86400
local function PurgerFiches()
	local b = Base()
	b.entraineur = nil
	b.ouverts, b.speciales = nil, nil -- (réglages de l'ancienne fiche de membre, retirée en 7.7.0)
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

-- Pour les autres modules : mon niveau dans un métier (nil si je ne l'ai pas)
ns.MonNiveauMetier = function(code)
	local p = MesDonnees().profs[code]
	return p and p.n
end

-- Pour la page Guilde (GuildUp_Membres.lua) : fiche métiers d'un membre (la mienne pour moi), nil
-- s'il n'en a pas envoyé ; fiche = { nom, classe, niveau, vu, profs = { AL = { n, max, nr, … } } }
ns.FicheMetiers = function(cle)
	if not cle then return nil end
	if cle == MaCle() then return MesDonnees() end
	local g = Guilde()
	local e = g and g[cle]
	return type(e) == "table" and e or nil
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

	if genre == "Q" then
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

-- Une entrée par membre : nom, enLigne, zone, classe, niveau (lus par les autres modules) ; pour la
-- page Guilde (GuildUp_Membres.lua) aussi : cle, rang, rangIndex, classeNom, note (note publique),
-- statut (« ABS », « NPD » ou nil) et absence = { ans, mois, jours, heures } depuis la dernière
-- connexion (hors ligne seulement, GetGuildRosterLastOnline si le client l'a)
local rosterLuA = 0
local function LireRoster()
	if not IsInGuild() or not GetNumGuildMembers then return end
	wipe(roster)
	local n = tonumber((GetNumGuildMembers())) or 0
	for i = 1, n do
		local nom, rang, rangIndex, niveau, classeNom, zone, note, _, enLigne, statut, classe = GetGuildRosterInfo(i)
		local cle = nom and Normaliser(nom)
		if cle then
			local e = { nom = nom, enLigne = enLigne and true or false, zone = zone, classe = classe, niveau = niveau,
				cle = cle, rang = rang, rangIndex = tonumber(rangIndex), classeNom = classeNom, note = note }
			if statut == 1 or statut == "<AFK>" or statut == "<Absent>" then e.statut = "ABS"
			elseif statut == 2 or statut == "<DND>" or statut == "<Ne pas déranger>" then e.statut = "NPD" end
			if not e.enLigne and GetGuildRosterLastOnline then
				local ok, a, m, j, h = pcall(GetGuildRosterLastOnline, i)
				if ok and (tonumber(a) or tonumber(m) or tonumber(j) or tonumber(h)) then
					e.absence = { ans = tonumber(a) or 0, mois = tonumber(m) or 0, jours = tonumber(j) or 0, heures = tonumber(h) or 0 }
				end
			end
			roster[cle] = e
		end
	end
	rosterLu = n > 0
	rosterLuA = GetTime()
end

-- Pour la page Guilde (GuildUp_Membres.lua) : tous les membres de la liste de guilde (en ligne et hors
-- ligne), dans une nouvelle liste (entrées décrites au-dessus de LireRoster, à ne pas modifier) ;
-- relire = relire la liste du jeu d'abord (au plus une fois par seconde)
ns.RosterGuilde = function(relire)
	if relire and GetTime() - rosterLuA >= 1 then LireRoster() end
	local l = {}
	for _, e in pairs(roster) do l[#l + 1] = e end
	return l
end

local EnLigne

-- Clic sur la recette d'un membre : la page Demandes, formulaire rempli (demande d'artisanat). Une
-- recette qui ne crée pas d'objet (enchantement) ne peut pas être demandée : on propose de chuchoter.
local function DemanderRecette(code, cle, nom)
	local objet = tonumber((code or ""):match("^i(%d+)$"))
	if objet and ns.OuvrirDemandes then
		ns.OuvrirDemandes(objet, "A", 1)
	elseif cle then
		ns.UI.Chuchoter(cle, nom)
	end
end

-- Pour les autres modules (demandes, accueil, page Guilde…)
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
-- Onglet « Registre » de la page Artisanat (fenêtre GuildUpSMB, kit ns.UI) : vu par métier (7.7.0)
-- Vue d'ensemble : un panneau par métier (fabrication d'abord, récolte ensuite) avec ses quatre
-- meilleurs artisans : niveau, puis nombre de recettes, puis en ligne. Si j'ai le métier sans être dans
-- les quatre, ma ligne prend la dernière place avec mon vrai rang. Recherche « recette ou joueur » : les
-- panneaux concernés listent ceux qui la connaissent, les autres s'éteignent.
-- Clic sur un panneau ou sur un artisan : le métier ouvert. À gauche le classement complet, à droite
-- les recettes que la guilde connaît dans ce métier, avec qui sait les faire (liste virtuelle : seules
-- les lignes visibles existent). Clic sur un artisan : seulement ses recettes ; clic sur une recette :
-- demander (Maj-clic : lien). La fiche d'un membre, tous métiers confondus, reste dans son infobulle
-- et dans la page Guilde.
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI.C
local MARGE, ECART = 16, 12              -- marge de la page, écart entre deux panneaux
local HAUT_OUTILS, HAUT_CORPS = -54, -98 -- barre d'outils (sous les onglets), puis le contenu
local PAR_RANGEE, PAR_PANNEAU = 4, 4     -- panneaux par rangée, artisans par panneau
local HAUTEUR_TETE, HAUTEUR_RANG = 46, 28
local LARGEUR_CLASSEMENT, HAUTEUR_ARTISAN, HAUTEUR_RECETTE = 300, 44, 28
local NB_QUI = 3                         -- artisans nommés à droite d'une recette (ensuite « +n »)
local ICONE_INCONNUE = "Interface\\Icons\\INV_Misc_QuestionMark"
local GRIS_HORS_LIGNE = { 0.35, 0.33, 0.27 }
local VERT, TOI = "|cff6fd08c", " |cff9c937f(toi)|r"

local fen                -- le cadre de l'onglet (créé à la première ouverture)
-- ce que montre l'onglet : metier = code du métier ouvert (nil : vue d'ensemble), membre = artisan dont
-- on ne voit que les recettes, puce = 1 toutes, 2 spéciales (apprises avec un plan), 3 un seul artisan,
-- enLigne = cacher les hors-ligne des panneaux, texte = recherche telle qu'elle est écrite
local reg = { puce = 1, enLigne = false, texte = "" }
local recherche = ""     -- texte cherché (simplifié)
local majPrevue = false
local MajFenetre

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

-- Métiers montrés, dans l'ordre des panneaux : la fabrication d'abord, la récolte ensuite
local function MetiersMontres()
	local sansInfo = not (GetSpellInfo or (C_Spell and C_Spell.GetSpellInfo))
	local l = {}
	for passe = 1, 2 do
		for _, m in ipairs(METIERS) do
			if (m.existe or sansInfo) and ((passe == 2) == (m.recolte == true)) then l[#l + 1] = m end
		end
	end
	return l
end

-- recettes d'un membre dans un métier : celles reçues, ou le nombre annoncé si elles ne sont pas arrivées
local function NbRecettes(p)
	local lues = type(p.r) == "table" and #p.r or 0
	return math.max(lues, tonumber(p.nr) or 0)
end

local function AvantDansClassement(a, b)
	if a.n ~= b.n then return a.n > b.n end
	if a.nr ~= b.nr then return a.nr > b.nr end
	if a.f.enLigne ~= b.f.enLigne then return a.f.enLigne end
	local na, nb = tostring(a.f.e.nom or a.f.cle), tostring(b.f.e.nom or b.f.cle)
	if na ~= nb then return na < nb end
	return tostring(a.f.cle) < tostring(b.f.cle)
end

-- Classement de chaque métier : [code] = { { f = fiche, p = le métier du membre, n = niveau, nr = nombre
-- de recettes, rang }, … }, du meilleur au moins bon (niveau, puis recettes, puis en ligne, puis nom).
-- Rend aussi le nombre de membres en ligne et le plus haut plafond de métier vu dans la guilde (un
-- niveau à ce plafond s'écrit en doré).
local function Classements()
	local par, enLigne, plafond = {}, 0, 0
	for _, m in ipairs(METIERS) do par[m.code] = {} end
	for _, f in ipairs(Fiches()) do
		f.enLigne = (f.moi or EnLigne(f.cle, f.e)) and true or false
		if f.enLigne then enLigne = enLigne + 1 end
		for code, p in pairs(type(f.e.profs) == "table" and f.e.profs or {}) do
			local l = par[code]
			if l and type(p) == "table" then
				l[#l + 1] = { f = f, p = p, n = tonumber(p.n) or 0, nr = NbRecettes(p) }
				plafond = math.max(plafond, tonumber(p.max) or 0)
			end
		end
	end
	for _, l in pairs(par) do
		table.sort(l, AvantDansClassement)
		for i, a in ipairs(l) do a.rang = i end
	end
	return par, enLigne, plafond
end

-- recettes d'un artisan dont le nom contient le texte cherché : leur nombre (notées dans « vues »)
local function RecettesTrouvees(p, vues)
	if recherche == "" or type(p.r) ~= "table" then return 0 end
	local n = 0
	for _, c in ipairs(p.r) do
		local s = NomRecetteSimplifie(c)
		if s and s:find(recherche, 1, true) then
			n = n + 1
			if vues then vues[c] = true end
		end
	end
	return n
end

local function NomTrouve(f)
	local nom = f.e.nom or f.cle
	return Simplifier(NomJoueur(nom) .. " " .. NomCourt(nom)):find(recherche, 1, true) ~= nil
end

-- zone d'un membre en ligne, sinon depuis quand on ne l'a pas vu
local function Lieu(f)
	if f.enLigne then
		local zone = f.moi and GetRealZoneText and GetRealZoneText() or (roster[f.cle] and roster[f.cle].zone)
		return zone and zone ~= "" and zone or "En ligne"
	end
	return "Hors ligne" .. (f.e.vu and (" · vu il y a " .. Depuis(f.e.vu)) or "")
end

-- Infobulle d'un membre : son nom, son identité, tous ses métiers (ce qui reste de l'ancienne fiche)
local function InfobulleMembre(cadre, cle, e, indice)
	GameTooltip:SetOwner(cadre, "ANCHOR_RIGHT")
	GameTooltip:SetText(NomJoueur(e.nom or cle), CouleurClasse(e.classe))
	if ns.LignesIdentite then ns.LignesIdentite(GameTooltip, cle) end
	local rien = true
	for _, m in ipairs(METIERS) do
		local p = type(e.profs) == "table" and e.profs[m.code]
		if type(p) == "table" then
			rien = false
			local nr = NbRecettes(p)
			GameTooltip:AddDoubleLine("|T" .. tostring(m.icone) .. ":14|t " .. NomMetier(m),
				("%d / %d%s"):format(tonumber(p.n) or 0, tonumber(p.max) or 0, nr > 0 and ("  (" .. nr .. " recettes)") or ""),
				1, 0.82, 0, 1, 1, 1)
		end
	end
	if rien then GameTooltip:AddLine("Aucun métier connu.", 0.7, 0.7, 0.7) end
	if indice then GameTooltip:AddLine(indice, 0.6, 0.6, 0.6) end
	GameTooltip:Show()
end

-- ouvre un métier (cle : seulement les recettes de ce membre)
local function OuvrirMetier(code, cle)
	reg.metier, reg.membre, reg.puce = code, cle, 1
	if fen then
		fen.artisans:Haut()
		fen.recettes:Haut()
	end
	MajFenetre()
end

--------------------------------------------------------------------------------
-- Vue d'ensemble : les panneaux
--------------------------------------------------------------------------------

-- ligne d'un artisan dans un panneau : rang, point en ligne, nom, recettes, niveau
local function CreerRang(panneau, i)
	local b = CreateFrame("Button", nil, panneau)
	b:SetHeight(HAUTEUR_RANG)
	b:SetPoint("TOPLEFT", panneau, "TOPLEFT", 1, -(HAUTEUR_TETE + 5 + (i - 1) * HAUTEUR_RANG))
	b:SetPoint("RIGHT", panneau, "RIGHT", -1, 0)
	-- ma ligne, quand je ne suis pas dans les premiers : un filet la sépare du classement
	b.filet = UI.Filet(b, C.bordMoyen)
	b.filet:SetPoint("TOPLEFT", b, "TOPLEFT", 10, 0)
	b.filet:SetPoint("TOPRIGHT", b, "TOPRIGHT", -10, 0)
	b.rang = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.rang:SetPoint("LEFT", b, "LEFT", 6, 0)
	b.rang:SetWidth(18)
	b.rang:SetJustifyH("RIGHT")
	b.point = b:CreateTexture(nil, "ARTWORK")
	b.point:SetTexture(UI.ROND)
	b.point:SetSize(7, 7)
	b.point:SetPoint("LEFT", b.rang, "RIGHT", 6, 0)
	b.niveau = UI.Texte(b, "GameFontHighlight", C.texte)
	b.niveau:SetPoint("RIGHT", b, "RIGHT", -10, 0)
	b.niveau:SetWidth(30)
	b.niveau:SetJustifyH("RIGHT")
	b.recettes = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.recettes:SetPoint("RIGHT", b.niveau, "LEFT", -6, 0)
	b.recettes:SetJustifyH("RIGHT")
	b.nom = UI.Texte(b, "GameFontHighlight")
	b.nom:SetPoint("LEFT", b.point, "RIGHT", 7, 0)
	b.nom:SetPoint("RIGHT", b.recettes, "LEFT", -6, 0)
	UI.Survol(b, 0.04)
	UI.SonClic(b)
	b:SetScript("OnClick", function(self)
		if self.cle then OuvrirMetier(panneau.code, self.cle) end
	end)
	b:SetScript("OnEnter", function(self)
		if self.e then InfobulleMembre(self, self.cle, self.e, "Clic : ses recettes dans ce métier") end
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

-- Panneau d'un métier : en-tête cliquable (icône, nom, nombre d'artisans), puis les meilleurs artisans
local function CreerPanneau(parent, m, largeur, hauteur)
	local pn = UI.Cadre(parent, C.carte, C.bord)
	pn:SetSize(largeur, hauteur)
	pn.code = m.code
	local t = CreateFrame("Button", nil, pn)
	t:SetPoint("TOPLEFT", pn, "TOPLEFT", 1, -1)
	t:SetPoint("TOPRIGHT", pn, "TOPRIGHT", -1, -1)
	t:SetHeight(HAUTEUR_TETE)
	t.icone = t:CreateTexture(nil, "ARTWORK")
	t.icone:SetSize(30, 30)
	t.icone:SetPoint("LEFT", t, "LEFT", 11, 0)
	t.icone:SetTexture(m.icone)
	t.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	t.nom = UI.Texte(t, "GameFontNormal", C.ors)
	t.nom:SetPoint("TOPLEFT", t.icone, "TOPRIGHT", 10, -1)
	t.nom:SetPoint("RIGHT", t, "RIGHT", -8, 0)
	t.nom:SetText(NomMetier(m))
	t.compte = UI.Texte(t, "GameFontHighlightSmall", C.gris)
	t.compte:SetPoint("BOTTOMLEFT", t.icone, "BOTTOMRIGHT", 10, 1)
	t.compte:SetPoint("RIGHT", t, "RIGHT", -8, 0)
	UI.Survol(t, 0.04)
	UI.SonClic(t)
	t:SetScript("OnClick", function() OuvrirMetier(m.code) end)
	UI.Infobulle(t, NomMetier(m), "Clic : le classement complet et les recettes que la guilde connaît dans ce métier.")
	local filet = UI.Filet(pn)
	filet:SetPoint("TOPLEFT", t, "BOTTOMLEFT", 0, 0)
	filet:SetPoint("TOPRIGHT", t, "BOTTOMRIGHT", 0, 0)
	pn.tete = t
	pn.rangs = {}
	for i = 1, PAR_PANNEAU do pn.rangs[i] = CreerRang(pn, i) end
	pn.vide = UI.Texte(pn, "GameFontHighlightSmall", C.gris)
	return pn
end

local function RemplirPanneau(pn, classement, plafond)
	-- les artisans à montrer ; pendant une recherche : ceux qui connaissent une recette trouvée (ou dont
	-- le nom correspond), du plus fourni au moins fourni
	local liste, trouvees = {}, nil
	if recherche ~= "" then
		trouvees = {}
		for _, a in ipairs(classement) do
			a.trouvees = 0
			if not reg.enLigne or a.f.enLigne then
				a.trouvees = RecettesTrouvees(a.p, trouvees)
				if a.trouvees > 0 or NomTrouve(a.f) then liste[#liste + 1] = a end
			end
		end
		table.sort(liste, function(a, b)
			if a.trouvees ~= b.trouvees then return a.trouvees > b.trouvees end
			return a.rang < b.rang
		end)
	else
		for _, a in ipairs(classement) do
			a.trouvees = 0
			if not reg.enLigne or a.f.enLigne then liste[#liste + 1] = a end
		end
	end

	local compte
	if trouvees then
		local n = 0
		for _ in pairs(trouvees) do n = n + 1 end
		if #liste == 0 then
			compte = "Rien ici"
		elseif n > 0 then
			compte = VERT .. n .. (n > 1 and " recettes trouvées" or " recette trouvée") .. "|r"
		else
			compte = #liste .. (#liste > 1 and " artisans" or " artisan")
		end
	else
		local enLigne = 0
		for _, a in ipairs(classement) do if a.f.enLigne then enLigne = enLigne + 1 end end
		compte = ("%d artisan%s · %s%d en ligne|r"):format(#classement, #classement > 1 and "s" or "", VERT, enLigne)
	end
	pn.tete.compte:SetText(compte)
	pn:SetAlpha((trouvees and #liste == 0) and 0.36 or 1)

	-- les premiers ; hors recherche, si j'ai le métier sans y être, ma ligne prend la dernière place
	local montres, horsRang = {}, false
	for i = 1, math.min(PAR_PANNEAU, #liste) do montres[i] = liste[i] end
	if not trouvees then
		for i = PAR_PANNEAU + 1, #liste do
			if liste[i].f.moi then
				montres[PAR_PANNEAU] = liste[i]
				horsRang = true
				break
			end
		end
	end
	for i, b in ipairs(pn.rangs) do
		local a = montres[i]
		if a then
			local f = a.f
			b.cle, b.e = f.cle, f.e
			b.rang:SetText(tostring(a.rang))
			b.rang:SetTextColor(unpack(a.rang == 1 and C.ors or C.gris))
			b.point:SetVertexColor(unpack(f.enLigne and C.vert or GRIS_HORS_LIGNE))
			b.nom:SetText(NomJoueur(f.e.nom or f.cle, true) .. (f.moi and TOI or ""))
			b.nom:SetTextColor(CouleurClasse(f.e.classe))
			b.nom:SetAlpha(f.enLigne and 1 or 0.55)
			if a.trouvees > 0 then
				b.recettes:SetText(VERT .. a.trouvees .. (a.trouvees > 1 and " recettes" or " recette") .. "|r")
			else
				b.recettes:SetText(a.nr > 0 and (a.nr .. " rec.") or "")
			end
			b.niveau:SetText(tostring(a.n))
			b.niveau:SetTextColor(unpack((plafond > 0 and a.n >= plafond) and C.ors or C.texte))
			b.filet:SetShown(horsRang and i == PAR_PANNEAU)
			b:Show()
		else
			b.cle, b.e = nil, nil
			b:Hide()
		end
	end

	local n = #montres
	if not trouvees and n < PAR_PANNEAU then
		local texte
		if n > 0 then
			texte = reg.enLigne and "Personne d'autre en ligne." or "Personne d'autre pour l'instant."
		else
			texte = (reg.enLigne and #classement > 0) and "Personne en ligne." or "Personne pour l'instant."
		end
		pn.vide:ClearAllPoints()
		pn.vide:SetPoint("TOPLEFT", pn, "TOPLEFT", 45, -(HAUTEUR_TETE + 13 + n * HAUTEUR_RANG))
		pn.vide:SetText(texte)
		pn.vide:Show()
	else
		pn.vide:Hide()
	end
end

--------------------------------------------------------------------------------
-- Un métier ouvert : le classement à gauche, les recettes de la guilde à droite
--------------------------------------------------------------------------------

-- ligne du classement : rang, point en ligne, nom et lieu, niveau et recettes, jauge du niveau
local function CreerArtisan(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetHeight(HAUTEUR_ARTISAN)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints()
	b.fond:SetColorTexture(unpack(C.actif))
	b.accent = UI.Accent(b)
	b.rang = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.rang:SetPoint("LEFT", b, "LEFT", 6, 0)
	b.rang:SetWidth(18)
	b.rang:SetJustifyH("RIGHT")
	b.point = b:CreateTexture(nil, "ARTWORK")
	b.point:SetTexture(UI.ROND)
	b.point:SetSize(7, 7)
	b.point:SetPoint("LEFT", b.rang, "RIGHT", 6, 0)
	b.niveau = UI.Texte(b, "GameFontHighlight", C.texte)
	b.niveau:SetPoint("TOPRIGHT", b, "TOPRIGHT", -12, -7)
	b.niveau:SetJustifyH("RIGHT")
	b.recettes = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.recettes:SetPoint("TOPRIGHT", b.niveau, "BOTTOMRIGHT", 0, -3)
	b.recettes:SetJustifyH("RIGHT")
	b.nom = UI.Texte(b, "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b, "TOPLEFT", 44, -7)
	b.nom:SetPoint("RIGHT", b.niveau, "LEFT", -8, 0)
	b.sous = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.sous:SetPoint("TOPLEFT", b.nom, "BOTTOMLEFT", 0, -3)
	b.sous:SetPoint("RIGHT", b.recettes, "LEFT", -8, 0)
	b.barre = Barre(b, 2)
	b.barre:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 12, 0)
	b.barre:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -12, 0)
	UI.Survol(b, 0.04)
	UI.SonClic(b)
	b:SetScript("OnClick", function(self)
		if not self.cle then return end
		reg.membre = (reg.membre ~= self.cle) and self.cle or nil
		fen.recettes:Haut()
		MajFenetre()
	end)
	b:SetScript("OnEnter", function(self)
		if not self.e then return end
		InfobulleMembre(self, self.cle, self.e, reg.membre == self.cle and "Clic : revenir aux recettes de toute la guilde"
			or "Clic : seulement ses recettes")
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return b
end

local function RemplirArtisan(b, a, plafond)
	local f, choisi = a.f, a.f.cle == reg.membre
	b.cle, b.e = f.cle, f.e
	b.fond:SetShown(choisi)
	b.accent:SetShown(choisi)
	b.rang:SetText(tostring(a.rang))
	b.rang:SetTextColor(unpack(a.rang == 1 and C.ors or C.gris))
	b.point:SetVertexColor(unpack(f.enLigne and C.vert or GRIS_HORS_LIGNE))
	b.nom:SetText(NomJoueur(f.e.nom or f.cle) .. (f.moi and TOI or ""))
	b.nom:SetTextColor(CouleurClasse(f.e.classe))
	b.nom:SetAlpha(f.enLigne and 1 or 0.55)
	b.sous:SetText(Lieu(f))
	local max = tonumber(a.p.max) or 0
	b.niveau:SetText(a.n .. " / " .. max)
	b.niveau:SetTextColor(unpack((plafond > 0 and a.n >= plafond) and C.ors or C.texte))
	b.recettes:SetText(a.nr > 0 and (a.nr .. (a.nr > 1 and " recettes" or " recette")) or "")
	b.barre:SetMinMaxValues(0, math.max(plafond, max, 1))
	b.barre:SetValue(a.n)
end

-- Ce que fait un clic sur une recette : « demander » (objet fabriqué : page Demandes), « chuchoter » à
-- un artisan (enchantement : rien à demander), ou rien (je suis seul à la connaître, personne en ligne)
local function ActionRecette(x)
	local autre, enLigne, choisi
	for _, a in ipairs(x.qui) do
		if not a.f.moi then
			autre = true
			if a.f.enLigne then
				enLigne = enLigne or a
				if a.f.cle == reg.membre then choisi = a end
			end
		end
	end
	if not autre then return nil end
	if x.code:match("^i%d+$") then return "demander" end
	-- l'artisan choisi d'abord, sinon le mieux classé en ligne
	if choisi or enLigne then return "chuchoter", choisi or enLigne end
	return nil
end

-- ligne d'une recette : icône, nom (couleur de qualité), puis à droite ceux qui savent la faire
local function CreerRecette(parent)
	local l = CreateFrame("Button", nil, parent)
	l:SetHeight(HAUTEUR_RECETTE)
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetSize(20, 20)
	l.icone:SetPoint("LEFT", l, "LEFT", 13, 0)
	l.icone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	l.plus = UI.Texte(l, "GameFontHighlightSmall", C.gris)
	l.plus:SetPoint("RIGHT", l, "RIGHT", -14, 0)
	l.plus:SetJustifyH("RIGHT")
	-- les artisans, posés de la droite vers la gauche : le dernier est le plus à droite
	l.qui = {}
	local ancre = l.plus
	for i = NB_QUI, 1, -1 do
		local nom = UI.Texte(l, "GameFontHighlightSmall")
		nom:SetPoint("RIGHT", ancre, "LEFT", -10, 0)
		nom:SetJustifyH("RIGHT")
		local point = l:CreateTexture(nil, "ARTWORK")
		point:SetTexture(UI.ROND)
		point:SetSize(6, 6)
		point:SetPoint("RIGHT", nom, "LEFT", -4, 0)
		l.qui[i] = { nom = nom, point = point }
		ancre = point
	end
	l.texte = UI.Texte(l, "GameFontHighlight", C.texte)
	l.texte:SetPoint("LEFT", l.icone, "RIGHT", 8, 0)
	l.texte:SetPoint("RIGHT", ancre, "LEFT", -10, 0)
	UI.Survol(l, 0.05)
	l:SetScript("OnEnter", function(self)
		local x = self.x
		if not x then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if not (self.hyper and pcall(GameTooltip.SetHyperlink, GameTooltip, self.hyper)) then
			GameTooltip:SetText(self.texte:GetText() or "?")
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(#x.qui > 1 and (#x.qui .. " artisans savent la faire :") or "Un seul artisan sait la faire :", 1, 0.82, 0)
		for i = 1, math.min(#x.qui, 8) do
			local a = x.qui[i]
			local r, g, b = CouleurClasse(a.f.e.classe)
			GameTooltip:AddDoubleLine(NomJoueur(a.f.e.nom or a.f.cle) .. (a.f.moi and " (toi)" or ""),
				a.f.enLigne and "en ligne" or "hors ligne", r, g, b, 0.6, 0.6, 0.6)
		end
		if #x.qui > 8 then GameTooltip:AddLine("… et " .. (#x.qui - 8) .. " autres", 0.6, 0.6, 0.6) end
		local action, cible = ActionRecette(x)
		if action == "demander" then
			GameTooltip:AddLine("Clic : demander cet objet à la guilde (page Demandes)", 0.3, 1, 0.3)
		elseif action == "chuchoter" then
			GameTooltip:AddLine("Clic : chuchoter à " .. NomJoueur(cible.f.e.nom or cible.f.cle), 0.3, 1, 0.3)
		end
		GameTooltip:AddLine("Maj-clic : lien dans la discussion", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	l:SetScript("OnLeave", function() GameTooltip:Hide() end)
	l:SetScript("OnClick", function(self)
		local x = self.x
		if not x then return end
		if self.lien and IsModifiedClick and IsModifiedClick("CHATLINK") and ChatEdit_InsertLink then
			ChatEdit_InsertLink(self.lien)
			return
		end
		local action, cible = ActionRecette(x)
		if action then DemanderRecette(x.code, cible and cible.f.cle, cible and cible.f.e.nom) end
	end)
	return l
end

local function RemplirRecette(l, x)
	local nom, icone, lien, hyper, qualite = InfoRecette(x.code)
	l.x, l.lien, l.hyper = x, lien, hyper
	l.icone:SetTexture(icone or ICONE_INCONNUE)
	local plan = ns.RecetteDePlan and ns.RecetteDePlan(reg.metier, x.code)
	l.texte:SetText((nom or "|cff9c937fchargement…|r") .. (plan and "  |cff9c937f· plan|r" or ""))
	local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
	if qc and nom then l.texte:SetTextColor(qc.r, qc.g, qc.b) else l.texte:SetTextColor(unpack(C.texte)) end
	-- ceux qui savent la faire : en ligne d'abord, puis dans l'ordre du classement
	local ordre = {}
	for passe = 1, 2 do
		for _, a in ipairs(x.qui) do
			if (passe == 1) == a.f.enLigne then ordre[#ordre + 1] = a end
		end
	end
	local decalage = NB_QUI - math.min(#ordre, NB_QUI)
	for i = 1, NB_QUI do
		local s, a = l.qui[i], ordre[i - decalage]
		if a then
			s.nom:SetText(NomJoueur(a.f.e.nom or a.f.cle, true))
			s.nom:SetTextColor(CouleurClasse(a.f.e.classe))
			s.nom:SetAlpha(a.f.enLigne and 1 or 0.55)
			s.point:SetVertexColor(unpack(a.f.enLigne and C.vert or GRIS_HORS_LIGNE))
			s.point:Show()
		else
			s.nom:SetText("")
			s.point:Hide()
		end
	end
	l.plus:SetText(#ordre > NB_QUI and ("+" .. (#ordre - NB_QUI)) or "")
end

-- Recettes à montrer pour le métier ouvert : { code, qui = { artisans }, simple = nom pour le tri }, triées
-- par nom. Rend aussi le nombre de recettes de la guilde dans ce métier, et le nombre avant les puces et
-- la recherche (celles de l'artisan choisi, sinon toutes).
local function RecettesAffichees(code, classement)
	local par, toutes = {}, {}
	for _, a in ipairs(classement) do
		if type(a.p.r) == "table" then
			for _, c in ipairs(a.p.r) do
				local x = par[c]
				if not x then
					x = { code = c, qui = {} }
					par[c] = x
					toutes[#toutes + 1] = x
				end
				if x.qui[#x.qui] ~= a then x.qui[#x.qui + 1] = a end
			end
		end
	end
	local liste, base = {}, 0
	for _, x in ipairs(toutes) do
		local garde = true
		if reg.membre then
			garde = false
			for _, a in ipairs(x.qui) do
				if a.f.cle == reg.membre then garde = true; break end
			end
		end
		if garde then base = base + 1 end
		if garde and reg.puce == 2 then
			garde = (ns.RecetteDePlan ~= nil and ns.RecetteDePlan(code, x.code)) and true or false
		elseif garde and reg.puce == 3 then
			garde = #x.qui == 1
		end
		if garde then
			x.simple = NomRecetteSimplifie(x.code)
			if recherche ~= "" then garde = x.simple ~= nil and x.simple:find(recherche, 1, true) ~= nil end
		end
		if garde then liste[#liste + 1] = x end
	end
	-- (les noms que le jeu n'a pas encore en mémoire arrivent un peu après : à la fin en attendant)
	table.sort(liste, function(a, b)
		local na, nb = a.simple or "~", b.simple or "~"
		if na ~= nb then return na < nb end
		return a.code < b.code
	end)
	return liste, #toutes, base
end

-- Dessine les recettes visibles (selon le défilement)
local function DessinerRecettes()
	if not fen then return end
	local l, liste = fen.recettes, fen.listeRecettes or {}
	local haut = tonumber(l:GetVerticalScroll()) or 0
	local h = tonumber(l:GetHeight()) or 0
	if h < 50 then h = ns.TAILLE_PAGE and ns.TAILLE_PAGE[2] or 600 end
	local premier = math.max(1, math.floor(haut / HAUTEUR_RECETTE) + 1)
	local dernier = math.min(#liste, premier + math.ceil(h / HAUTEUR_RECETTE))
	local k = 0
	for i = premier, dernier do
		k = k + 1
		local r = fen.lignesRecettes[k]
		if not r then
			r = CreerRecette(l.contenu)
			fen.lignesRecettes[k] = r
		end
		RemplirRecette(r, liste[i])
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", l.contenu, "TOPLEFT", 0, -(i - 1) * HAUTEUR_RECETTE)
		r:SetPoint("RIGHT", l.contenu, "RIGHT", 8, 0)
		r:Show()
	end
	for i = k + 1, #fen.lignesRecettes do
		fen.lignesRecettes[i]:Hide()
		fen.lignesRecettes[i].x = nil
	end
end

local function MajMetier(par, plafond)
	local m = PAR_CODE[reg.metier]
	local classement = par[m.code]
	-- l'artisan choisi a pu quitter le classement
	local choisi
	for _, a in ipairs(classement) do if a.f.cle == reg.membre then choisi = a end end
	if not choisi then reg.membre = nil end

	for code, bt in pairs(fen.bande) do
		local oui = code == m.code
		bt:SetBackdropColor(unpack(oui and C.actif or C.carte))
		bt:SetBackdropBorderColor(unpack(oui and C.orFonce or C.bord))
		bt.icone:SetDesaturated(not oui)
		bt.icone:SetAlpha(oui and 1 or 0.55)
	end

	-- à gauche : le classement complet
	local enLigne = 0
	for _, a in ipairs(classement) do if a.f.enLigne then enLigne = enLigne + 1 end end
	fen.gIcone:SetTexture(m.icone)
	fen.gTitre:SetText(NomMetier(m))
	fen.gSous:SetText(("%d artisan%s · %s%d en ligne|r · par niveau"):format(#classement, #classement > 1 and "s" or "", VERT, enLigne))
	local contenu = fen.artisans.contenu
	for i, a in ipairs(classement) do
		local b = fen.lignesArtisans[i]
		if not b then
			b = CreerArtisan(contenu)
			fen.lignesArtisans[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", contenu, "TOPLEFT", 0, -(i - 1) * HAUTEUR_ARTISAN)
		b:SetPoint("RIGHT", contenu, "RIGHT", 8, 0)
		RemplirArtisan(b, a, plafond)
		b:Show()
	end
	for i = #classement + 1, #fen.lignesArtisans do
		fen.lignesArtisans[i]:Hide()
		fen.lignesArtisans[i].cle, fen.lignesArtisans[i].e = nil, nil
	end
	fen.artisans:Hauteur(#classement * HAUTEUR_ARTISAN)
	fen.gVide:SetShown(#classement == 0)

	-- à droite : les recettes de la guilde, ou celles de l'artisan choisi
	local liste, total, base = RecettesAffichees(m.code, classement)
	fen.listeRecettes = liste
	fen.recettes:Hauteur(#liste * HAUTEUR_RECETTE)
	DessinerRecettes()
	fen.puces:Choisir(reg.puce)
	fen.puces:SetShown(total > 0)
	if choisi then
		local e = choisi.f.e
		fen.dTitre:SetText("Recettes de " .. (ns.CouleurClasseTexte and ns.CouleurClasseTexte(e.classe) or "")
			.. NomJoueur(e.nom or choisi.f.cle) .. "|r")
		fen.dSous:SetText(base .. (base > 1 and " recettes" or " recette") .. " dans ce métier")
		fen.mp.cle, fen.mp.e = choisi.f.cle, e
		fen.mp:Activer(choisi.f.enLigne and not choisi.f.moi)
	else
		fen.dTitre:SetText("Recettes connues dans la guilde")
		fen.dSous:SetText(total .. (total > 1 and " recettes" or " recette") .. " · clic sur un artisan pour ne voir que les siennes")
	end
	fen.mp:SetShown(choisi ~= nil)
	fen.toute:SetShown(choisi ~= nil)

	local vide
	if #liste == 0 then
		if base > 0 then
			vide = "Aucune recette ne correspond."
		elseif choisi and (tonumber(choisi.p.nr) or 0) > 0 then
			vide = "Recettes en cours de réception…"
		elseif m.recolte then
			vide = "Métier de récolte : pas de recettes à montrer. Le classement dit à qui demander ; pour une quantité précise, fais une demande de ressource, que toute la guilde verra."
		elseif choisi then
			vide = choisi.f.moi and "Ouvre ta fenêtre de métier pour partager tes recettes."
				or "Pas encore de recettes : il doit ouvrir sa fenêtre de métier avec l'addon."
		elseif #classement == 0 then
			vide = "Personne n'a ce métier parmi les membres qui ont SMB Forever."
		else
			vide = "Pas encore de recettes : chacun doit ouvrir sa fenêtre de métier une fois avec l'addon."
		end
	end
	fen.dVide:SetText(vide or "")
	fen.dVide:SetShown(vide ~= nil)
	fen.demander:SetShown(m.recolte == true and #liste == 0 and base == 0)
end

MajFenetre = function()
	if not fen then return end
	local par, enLigne, plafond = Classements()
	if reg.metier and not fen.bande[reg.metier] then reg.metier, reg.membre = nil, nil end
	local ouvert = reg.metier ~= nil
	fen.ensemble:SetShown(not ouvert)
	fen.detail:SetShown(ouvert)
	-- la recherche suit d'une vue à l'autre
	local champ = ouvert and fen.rechercheMetier or fen.recherche
	if champ:Lire() ~= reg.texte then champ:Ecrire(reg.texte) end
	if ouvert then
		MajMetier(par, plafond)
	else
		fen.pucesEnLigne:Choisir(reg.enLigne and 2 or 1)
		for _, pn in ipairs(fen.panneaux) do RemplirPanneau(pn, par[pn.code], plafond) end
	end
	-- conseil seulement s'il reste un de mes métiers d'artisanat dont aucune recette n'a été lue (sa
	-- fenêtre de métier n'a jamais été ouverte avec l'addon) ; les métiers de récolte n'en ont pas
	local aOuvrir = {}
	local mesProfs = MesDonnees().profs or {}
	for _, m in ipairs(METIERS) do
		local pr = mesProfs[m.code]
		if pr and not m.recolte and (type(pr.r) ~= "table" or next(pr.r) == nil) then
			aOuvrir[#aOuvrir + 1] = m.noms[1]
		end
	end
	local conseil = ""
	if #aOuvrir > 0 then
		local noms = #aOuvrir == 1 and aOuvrir[1]
			or (table.concat(aOuvrir, ", ", 1, #aOuvrir - 1) .. " et " .. aOuvrir[#aOuvrir])
		conseil = " · ouvre " .. (#aOuvrir == 1 and "ta fenêtre" or "tes fenêtres") .. " de " .. noms
			.. " une fois pour partager tes recettes"
	end
	fen.bas:SetText(VERT .. enLigne .. " en ligne|r" .. conseil)
end

local function SurRecherche(t)
	reg.texte = t or ""
	recherche = Simplifier(strtrim(reg.texte))
	if fen then
		fen.grille:Haut()
		fen.recettes:Haut()
	end
	MajBientot(0.15)
end

-- Onglet « Registre » : créé par la page Artisanat (GuildUp_Carnet.lua) dans son cadre, sous les onglets
local function CreerPage(parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetAllPoints()
	fen = f
	local largeur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) - 2 * MARGE
	local hauteur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[2] or 586) + HAUT_CORPS - MARGE
	local montres = MetiersMontres()

	-- à droite des onglets : membres en ligne et astuce
	f.bas = UI.Texte(f, "GameFontHighlightSmall", C.gris)
	f.bas:SetPoint("TOPRIGHT", f, "TOPRIGHT", -MARGE, -24)
	f.bas:SetJustifyH("RIGHT")

	---- vue d'ensemble : recherche, « Tous / En ligne », Actualiser, puis les panneaux
	local v = CreateFrame("Frame", nil, f)
	v:SetAllPoints()
	f.ensemble = v
	f.actualiser = UI.Bouton(v, "Actualiser", "fantome", 100, 32)
	f.actualiser:SetPoint("TOPRIGHT", v, "TOPRIGHT", -MARGE, HAUT_OUTILS)
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
	f.pucesEnLigne = UI.Puces(v, { "Tous", "En ligne" }, function(i)
		reg.enLigne = (i == 2)
		MajFenetre()
	end)
	f.pucesEnLigne:SetPoint("RIGHT", f.actualiser, "LEFT", -16, 0)
	UI.Infobulle(f.pucesEnLigne.boutons[2], "En ligne", "Ne garde dans les panneaux que les artisans connectés.")
	f.recherche = UI.Champ(v, 380, "Recette ou joueur (ex. « sac »)", 32)
	f.recherche:SetPoint("TOPLEFT", v, "TOPLEFT", MARGE, HAUT_OUTILS)
	f.recherche:SetPoint("RIGHT", f.pucesEnLigne, "LEFT", -16, 0)
	f.recherche.SurTexte = SurRecherche
	-- (la liste garde 8 px à droite pour sa barre de défilement : elle dépasse la marge d'autant, pour
	-- que les panneaux occupent toute la largeur)
	f.grille = UI.Liste(v)
	f.grille:SetPoint("TOPLEFT", v, "TOPLEFT", MARGE, HAUT_CORPS)
	f.grille:SetPoint("BOTTOMRIGHT", v, "BOTTOMRIGHT", -MARGE + 8, MARGE)
	-- trois rangées de panneaux tiennent sans défiler (douze métiers sur Forever) ; au-delà la grille défile
	local lp = math.floor((largeur - (PAR_RANGEE - 1) * ECART) / PAR_RANGEE)
	local hp = math.max(math.floor((hauteur - 2 * ECART) / 3), HAUTEUR_TETE + 9 + PAR_PANNEAU * HAUTEUR_RANG)
	f.panneaux = {}
	for i, m in ipairs(montres) do
		local pn = CreerPanneau(f.grille.contenu, m, lp, hp)
		pn:SetPoint("TOPLEFT", f.grille.contenu, "TOPLEFT", ((i - 1) % PAR_RANGEE) * (lp + ECART),
			-math.floor((i - 1) / PAR_RANGEE) * (hp + ECART))
		f.panneaux[i] = pn
	end
	f.grille:Hauteur(math.ceil(#montres / PAR_RANGEE) * (hp + ECART) - ECART)

	---- un métier ouvert : retour, un bouton par métier, recherche, puis le classement et les recettes
	local d = CreateFrame("Frame", nil, f)
	d:SetAllPoints()
	d:Hide()
	f.detail = d
	f.retour = UI.Bouton(d, "< Tous les métiers", "fantome", 150, 32)
	f.retour:SetPoint("TOPLEFT", d, "TOPLEFT", MARGE, HAUT_OUTILS)
	f.retour:SetScript("OnClick", function()
		reg.metier, reg.membre = nil, nil
		MajFenetre()
	end)
	f.bande = {}
	local x = MARGE + 150 + 12
	for _, m in ipairs(montres) do
		local bt = CreateFrame("Button", nil, d, "BackdropTemplate")
		UI.Habiller(bt, C.carte, C.bord)
		bt:SetSize(32, 32)
		bt:SetPoint("TOPLEFT", d, "TOPLEFT", x, HAUT_OUTILS)
		bt.icone = bt:CreateTexture(nil, "ARTWORK")
		bt.icone:SetPoint("TOPLEFT", bt, "TOPLEFT", 3, -3)
		bt.icone:SetPoint("BOTTOMRIGHT", bt, "BOTTOMRIGHT", -3, 3)
		bt.icone:SetTexture(m.icone)
		bt.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		UI.Survol(bt, 0.12)
		if ns.SonsSurBoutons then ns.SonsSurBoutons(bt) end
		bt:SetScript("OnClick", function()
			if reg.metier ~= m.code then OuvrirMetier(m.code) end
		end)
		bt:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
			GameTooltip:SetText(NomMetier(m))
			GameTooltip:Show()
		end)
		bt:SetScript("OnLeave", function() GameTooltip:Hide() end)
		f.bande[m.code] = bt
		x = x + 36
	end
	f.rechercheMetier = UI.Champ(d, 200, "Chercher une recette", 32)
	f.rechercheMetier:SetPoint("TOPLEFT", d, "TOPLEFT", x + 8, HAUT_OUTILS)
	f.rechercheMetier:SetPoint("RIGHT", d, "RIGHT", -MARGE, 0)
	f.rechercheMetier.SurTexte = SurRecherche

	-- à gauche : le classement du métier
	local g = UI.Cadre(d, C.carte, C.bord)
	g:SetPoint("TOPLEFT", d, "TOPLEFT", MARGE, HAUT_CORPS)
	g:SetPoint("BOTTOMLEFT", d, "BOTTOMLEFT", MARGE, MARGE)
	g:SetWidth(LARGEUR_CLASSEMENT)
	f.gIcone = g:CreateTexture(nil, "ARTWORK")
	f.gIcone:SetSize(36, 36)
	f.gIcone:SetPoint("TOPLEFT", g, "TOPLEFT", 14, -12)
	f.gIcone:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	f.gTitre = UI.Texte(g, "GameFontNormalLarge", C.ors)
	f.gTitre:SetPoint("TOPLEFT", f.gIcone, "TOPRIGHT", 12, -2)
	f.gTitre:SetPoint("RIGHT", g, "RIGHT", -12, 0)
	f.gSous = UI.Texte(g, "GameFontHighlightSmall", C.gris)
	f.gSous:SetPoint("BOTTOMLEFT", f.gIcone, "BOTTOMRIGHT", 12, 2)
	f.gSous:SetPoint("RIGHT", g, "RIGHT", -12, 0)
	local filetG = UI.Filet(g)
	filetG:SetPoint("TOPLEFT", g, "TOPLEFT", 1, -60)
	filetG:SetPoint("TOPRIGHT", g, "TOPRIGHT", -1, -60)
	f.artisans = UI.Liste(g)
	f.artisans:SetPoint("TOPLEFT", g, "TOPLEFT", 1, -61)
	f.artisans:SetPoint("BOTTOMRIGHT", g, "BOTTOMRIGHT", -1, 1)
	f.lignesArtisans = {}
	f.gVide = UI.Texte(g, "GameFontHighlight", C.gris)
	f.gVide:SetPoint("TOPLEFT", g, "TOPLEFT", 16, -76)
	f.gVide:SetPoint("RIGHT", g, "RIGHT", -16, 0)
	f.gVide:SetWordWrap(true)
	f.gVide:SetText("Personne n'a ce métier parmi les membres qui ont SMB Forever.")

	-- à droite : les recettes
	local r = UI.Cadre(d, C.carte, C.bord)
	r:SetPoint("TOPLEFT", g, "TOPRIGHT", 14, 0)
	r:SetPoint("BOTTOMRIGHT", d, "BOTTOMRIGHT", -MARGE, MARGE)
	f.mp = UI.Bouton(r, "Chuchoter", "fantome", 96, 26)
	f.mp:SetPoint("TOPRIGHT", r, "TOPRIGHT", -14, -16)
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
	f.toute = UI.Bouton(r, "Toute la guilde", "fantome", 124, 26)
	f.toute:SetPoint("RIGHT", f.mp, "LEFT", -8, 0)
	f.toute:SetScript("OnClick", function()
		reg.membre = nil
		fen.recettes:Haut()
		MajFenetre()
	end)
	UI.Infobulle(f.toute, "Toute la guilde", "Revenir aux recettes de tous les artisans de ce métier.")
	f.dTitre = UI.Texte(r, "GameFontNormalLarge", C.ors)
	f.dTitre:SetPoint("TOPLEFT", r, "TOPLEFT", 16, -12)
	f.dTitre:SetPoint("RIGHT", f.toute, "LEFT", -10, 0)
	f.dSous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	f.dSous:SetPoint("TOPLEFT", f.dTitre, "BOTTOMLEFT", 0, -5)
	-- (toute la largeur : la phrase est courte quand les boutons d'un artisan choisi sont là)
	f.dSous:SetPoint("RIGHT", r, "RIGHT", -16, 0)
	f.puces = UI.Puces(r, { "Toutes", "Spéciales", "Un seul artisan" }, function(i)
		reg.puce = i
		fen.recettes:Haut()
		MajFenetre()
	end)
	f.puces:SetPoint("TOPLEFT", r, "TOPLEFT", 14, -58)
	UI.Infobulle(f.puces.boutons[2], "Recettes spéciales", "Seulement les recettes apprises avec un plan (butin, vendeur, quête…), sans celles de l'entraîneur.")
	UI.Infobulle(f.puces.boutons[3], "Un seul artisan", "Les recettes qu'une seule personne de la guilde connaît.")
	local filetD = UI.Filet(r)
	filetD:SetPoint("TOPLEFT", r, "TOPLEFT", 1, -94)
	filetD:SetPoint("TOPRIGHT", r, "TOPRIGHT", -1, -94)
	f.recettes = UI.Liste(r)
	f.recettes:SetPoint("TOPLEFT", r, "TOPLEFT", 1, -95)
	f.recettes:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", -1, 1)
	f.lignesRecettes = {}
	f.recettes:SetScript("OnVerticalScroll", function() DessinerRecettes() end)
	f.recettes:HookScript("OnMouseWheel", function() DessinerRecettes() end)
	f.recettes:HookScript("OnSizeChanged", function() DessinerRecettes() end)
	f.dVide = UI.Texte(r, "GameFontHighlight", C.gris)
	f.dVide:SetPoint("TOPLEFT", r, "TOPLEFT", 16, -110)
	f.dVide:SetPoint("RIGHT", r, "RIGHT", -16, 0)
	f.dVide:SetWordWrap(true)
	f.demander = UI.Bouton(r, "Demander une ressource", "fantome", 190, 28)
	f.demander:SetPoint("TOPLEFT", f.dVide, "BOTTOMLEFT", 0, -14)
	f.demander:SetScript("OnClick", function()
		if ns.OuvrirDemandes then ns.OuvrirDemandes() end
	end)

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
		Base().commandes = nil -- (anciennes commandes d'artisanat, retirées en 4.0.0)
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
