-- GuildUp : recherche de groupe réservée à la guilde.
-- Style de la recherche de groupe officielle de Forever (cadre à portrait, onglets, barres de
-- groupe, boutons de catégorie), avec un affichage des places par rôle façon FF14 : chaque
-- groupe montre ses emplacements Tank / Heal / DPS, pris ou libres.
--
-- Messages d'addon invisibles :
--   canal GUILD  : "A~..." annonce (ou mise à jour), "F~id" fin d'annonce, "Q" demande des annonces
--   chuchotement : "P~id~role~classe~niveau" candidature, "X~id" candidature annulée,
--                  "R~id~non" candidature refusée
-- Annonce : A~id~code~besoinT~besoinH~besoinD~prisT~prisH~prisD~taille~membres~niveau~classe~commentaire~liste
--   liste (groupes de 5 max) : "Nom.t,Nom.h,Nom.?" (rôle de chaque membre)
--
-- Catalogue des contenus : lu dans la recherche de groupe Blizzard du client (C_LFGList),
-- icônes de donjon via GetLFGDungeonInfo (par carte d'instance), liste de secours sinon.
-- Code d'un contenu : "a<id d'activité>" (jeu) ou "s<n°>" (liste de secours).

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpGrp"
local SEP = "~"
local RAPPEL = 60       -- secondes entre deux rediffusions de mon annonce
local DUREE_VIE = 150   -- secondes sans nouvelles d'une annonce avant de l'effacer
local ROLES = { "tank", "heal", "dps" }

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

local annonces = {}      -- [id] = annonce reçue (voir Recevoir)
local candidatures = {}  -- [id] = "envoyee" | "refusee"  (mes candidatures)
local monAnnonce         -- { id, code, besoin = {tank,heal,dps}, taille, commentaire } ou nil
local candidats = {}     -- liste ordonnée : { nom, role, classe, niveau, statut }
local fenetre
local Rafraichir         -- défini avec la fenêtre

local function Message(texte)
	print("|cff3399ffGuildUp|r : " .. texte)
end

local function DB() return ns.DB and ns.DB() end

--------------------------------------------------------------------------------
-- Outils
--------------------------------------------------------------------------------

-- Sur Forever, les noms arrivent sous la forme « Miko Banko » (nom + royaume séparés par un
-- espace). On garde le nom tel que reçu pour chuchoter / inviter, et on compare des noms
-- normalisés « Nom-Royaume » (ns.Normaliser, défini dans GuildUp.lua).
local function Normaliser(nom)
	if ns.Normaliser then return ns.Normaliser(nom) end
	return nom
end

local function MonNom()
	return Normaliser(UnitName("player"))
end

-- Nom affiché : complet, « Prénom Famille » (« Miko-Banko » devient « Miko Banko »)
local function NomCourt(nom)
	return ((nom or "?"):gsub("%-", " "))
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

local function Prenom(nom)
	return (NomCourt(nom) or "?"):match("^(%S+)") or nom
end

local dernierNomRecuDeMoi -- pour /smb diag : comment le serveur écrit mon nom dans les messages
local finCalme = math.huge -- pas d'alerte avant la connexion + 25 s (voir PLAYER_ENTERING_WORLD)

-- texte libre sûr pour un message d'addon : sans séparateur, ni « | », ni retour à la ligne,
-- coupé à max lettres sans couper un caractère accentué
local function Nettoyer(texte, max)
	texte = (texte or ""):gsub("[~|\r\n]", " ")
	return ns.CouperUTF8 and ns.CouperUTF8(texte, nil, max or 50) or texte:sub(1, max or 50)
end

local function Decouper(msg, sep)
	local t = {}
	for morceau in (msg .. sep):gmatch("(.-)" .. sep) do t[#t + 1] = morceau end
	return t
end

local function Envoyer(msg, canal, cible)
	if canal == "GUILD" and not IsInGuild() then return end
	local envoi = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage
	if envoi then pcall(envoi, PREFIXE, msg, canal, cible) end
end

local function CouleurClasse(classe)
	local c = classe and RAID_CLASS_COLORS and RAID_CLASS_COLORS[classe]
	if c and c.colorStr then return "|c" .. c.colorStr end
	return "|cffffffff"
end

local NOMS_ROLES = { tank = "|cff3399ffTank|r", heal = "|cff33dd55Heal|r", dps = "|cffff4444DPS|r" }
local LETTRES_ROLES = { tank = "t", heal = "h", dps = "d" }
local ROLES_LETTRES = { t = "tank", h = "heal", d = "dps" }

local function TexteRole(role)
	return NOMS_ROLES[role] or "|cff999999rôle ?|r"
end

local function NombreMembres()
	local n = GetNumGroupMembers and GetNumGroupMembers() or 0
	return math.max(1, n)
end

local function PeutAnnoncer()
	return not IsInGroup() or UnitIsGroupLeader("player")
end

local function AtlasExiste(nom)
	return nom and C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo(nom) ~= nil
end

local function PoserAtlas(tex, atlas, secours)
	tex:SetTexCoord(0, 1, 0, 1)
	if AtlasExiste(atlas) then
		tex:SetAtlas(atlas)
		return true
	elseif secours then
		tex:SetColorTexture(unpack(secours))
	end
	return false
end

-- Pose une icône de contenu : fichier, ou atlas, ou point d'interrogation
local function PoserIcone(tex, icone)
	tex:SetTexCoord(0, 1, 0, 1)
	if icone and icone.fichier then
		tex:SetTexture(icone.fichier)
		if icone.coords then tex:SetTexCoord(unpack(icone.coords)) end
	elseif icone and icone.atlas and AtlasExiste(icone.atlas) then
		tex:SetAtlas(icone.atlas)
	else
		tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end
end

-- Icône de rôle (style recherche de groupe), allumée ou éteinte
local ATLAS_ROLES = {
	tank = { "groupfinder-icon-role-large-tank", "UI-LFG-RoleIcon-Tank" },
	heal = { "groupfinder-icon-role-large-heal", "UI-LFG-RoleIcon-Healer" },
	dps = { "groupfinder-icon-role-large-dps", "UI-LFG-RoleIcon-DPS" },
}
local COORDS_ROLES = {
	tank = { 0, 19 / 64, 22 / 64, 41 / 64 },
	heal = { 20 / 64, 39 / 64, 1 / 64, 20 / 64 },
	dps = { 20 / 64, 39 / 64, 22 / 64, 41 / 64 },
}

local function IconeRole(tex, role, allume)
	local pose = false
	for _, atlas in ipairs(ATLAS_ROLES[role] or {}) do
		if AtlasExiste(atlas) then tex:SetAtlas(atlas); pose = true; break end
	end
	if not pose then
		if COORDS_ROLES[role] then
			tex:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-ROLES")
			tex:SetTexCoord(unpack(COORDS_ROLES[role]))
		else
			tex:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
			tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		end
	end
	tex:SetDesaturated(not allume)
	tex:SetAlpha(allume and 1 or 0.3)
end

-- Icône de classe (style recherche de groupe)
local function IconeClasse(tex, classe)
	if classe and AtlasExiste("groupfinder-icon-class-" .. classe:lower()) then
		tex:SetAtlas("groupfinder-icon-class-" .. classe:lower())
		tex:Show()
	elseif classe and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[classe] then
		tex:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		tex:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classe]))
		tex:Show()
	else
		tex:Hide()
	end
end

-- Composition par défaut selon la taille du groupe
local function BesoinParDefaut(taille)
	if taille <= 5 then return { tank = 1, heal = 1, dps = math.max(0, taille - 2) } end
	if taille <= 10 then return { tank = 2, heal = 2, dps = taille - 4 } end
	local t = math.max(2, math.floor(taille / 10 + 0.5))
	local h = math.max(2, math.floor(taille / 4 + 0.5))
	return { tank = t, heal = h, dps = math.max(0, taille - t - h) }
end

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
ns.TailleMaxContenu = TailleMaxContenu


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

--------------------------------------------------------------------------------
-- Composition de mon groupe (rôles des membres)
--------------------------------------------------------------------------------

local function UnitesDuGroupe()
	local unites = { "player" }
	if IsInRaid() then
		for i = 1, GetNumGroupMembers() do
			local u = "raid" .. i
			if UnitExists(u) and not UnitIsUnit(u, "player") then unites[#unites + 1] = u end
		end
	elseif IsInGroup() then
		for i = 1, GetNumSubgroupMembers() do unites[#unites + 1] = "party" .. i end
	end
	return unites
end

-- Le joueur « nom » est-il dans mon groupe ? (compare les noms complets « Prénom Famille »)
local function DansMonGroupe(nom)
	local cible = nom and Normaliser(nom)
	if not cible then return false end
	for _, u in ipairs(UnitesDuGroupe()) do
		local n = NomCompletUnite(u)
		if n and Normaliser(n) == cible then return true end
	end
	return false
end

-- pris = places occupées par rôle ; membres = { nom, role } ; les rôles inconnus prennent les
-- places libres (DPS d'abord)
local function Composition(besoin)
	local pris = { tank = 0, heal = 0, dps = 0 }
	local membres, inconnus = {}, 0
	for _, u in ipairs(UnitesDuGroupe()) do
		local r = ns.RoleConnu and ns.RoleConnu(u)
		if r and pris[r] then pris[r] = pris[r] + 1 else inconnus = inconnus + 1 end
		membres[#membres + 1] = { nom = NomCompletUnite(u) or "?", role = r }
	end
	for _, r in ipairs({ "dps", "heal", "tank" }) do
		while inconnus > 0 and pris[r] < (besoin[r] or 0) do
			pris[r] = pris[r] + 1
			inconnus = inconnus - 1
		end
	end
	return pris, membres
end

--------------------------------------------------------------------------------
-- Mon annonce (côté chef)
--------------------------------------------------------------------------------

local dernierEnvoi, derniereSignature = 0, nil

local function SignatureComposition()
	if not monAnnonce then return "" end
	local pris, membres = Composition(monAnnonce.besoin)
	return ("%d%d%d%d"):format(pris.tank, pris.heal, pris.dps, #membres), pris, membres
end

local function DiffuserMonAnnonce()
	if not monAnnonce then return end
	local signature, pris, membres = SignatureComposition()
	local liste = {}
	if monAnnonce.taille <= 5 then
		for _, m in ipairs(membres) do
			liste[#liste + 1] = NomCourt(m.nom) .. "." .. (LETTRES_ROLES[m.role] or "?")
		end
	end
	local _, classe = UnitClass("player")
	monAnnonce.vu = GetTime()
	dernierEnvoi = GetTime()
	derniereSignature = signature
	local b = monAnnonce.besoin
	local function Construire(commentaire, membresTexte)
		return table.concat({
			"A", monAnnonce.id, monAnnonce.code, b.tank, b.heal, b.dps, pris.tank, pris.heal, pris.dps,
			monAnnonce.taille, #membres, UnitLevel("player") or 0, classe or "", commentaire,
			membresTexte, monAnnonce.rappel and "1" or "",
		}, SEP)
	end
	local max = ns.LONGUEUR_MAX or 255
	local msg = Construire(monAnnonce.commentaire, table.concat(liste, ","))
	-- trop long (noms longs ou accentués) : sans la liste des membres, puis commentaire raccourci
	if #msg > max then msg = Construire(monAnnonce.commentaire, "") end
	if #msg > max and ns.CouperUTF8 then
		local place = #monAnnonce.commentaire - (#msg - max)
		msg = Construire(ns.CouperUTF8(monAnnonce.commentaire, math.max(0, place)), "")
	end
	Envoyer(msg, "GUILD")
end

local function FermerMonAnnonce(raison)
	if not monAnnonce then return end
	if raison then (ns.Erreur or Message)("Annonce de groupe fermée : " .. raison) end
	if ns.RetirerPublic then ns.RetirerPublic() end -- l'annonce publique (recherche du jeu) part avec
	Envoyer("F" .. SEP .. monAnnonce.id, "GUILD")
	for _, c in ipairs(candidats) do
		if c.statut == "attente" then
			Envoyer("R" .. SEP .. monAnnonce.id .. SEP .. "non", "WHISPER", c.nom)
		end
	end
	monAnnonce = nil
	candidats = {}
	if Rafraichir then Rafraichir() end
end

local function CreerMonAnnonce(code, besoin, commentaire)
	local erreur = ns.Erreur or Message
	if not IsInGuild() then erreur("Tu n'es pas dans une guilde"); return end
	if not PeutAnnoncer() then erreur("Seul le chef du groupe peut créer une annonce"); return end
	if not code then erreur("Choisis d'abord un contenu"); return end
	local e = InfoContenu(code)
	if not EstPerso(e) and IsInGroup() and (GetNumGroupMembers() or 0) >= (e.taille or 5) then
		erreur("Ton groupe est déjà complet pour ce contenu"); return
	end
	monAnnonce = {
		id = MonNom() .. ":" .. (GetServerTime and GetServerTime() or math.floor(GetTime())),
		code = code,
		besoin = { tank = besoin.tank, heal = besoin.heal, dps = besoin.dps },
		taille = EstPerso(e) and math.max(1, besoin.tank + besoin.heal + besoin.dps)
			or math.min(e.taille or 5, math.max(1, besoin.tank + besoin.heal + besoin.dps)),
		commentaire = Nettoyer(commentaire, 50),
		rappel = DB() and DB().rappelGroupe and true or false,
	}
	candidats = {}
	DiffuserMonAnnonce()
	if Rafraichir then Rafraichir() end
end

-- Groupe pour une quête : annonce « Quête : titre », zone en commentaire, places 1 / 1 / 3
ns.CreerGroupeQuete = function(id, titre, zone)
	if monAnnonce then
		local erreur = ns.Erreur or Message
		erreur("Tu as déjà une annonce de groupe : retire-la d'abord (onglet Mon groupe)")
		if ns.OuvrirGroupes then ns.OuvrirGroupes() end
		return
	end
	local commentaire = zone and zone ~= "" and zone or (titre or "")
	CreerMonAnnonce("q" .. id, BesoinParDefaut(5), commentaire)
	if monAnnonce and ns.OuvrirGroupes then ns.OuvrirGroupes() end
end

local function TrouverCandidat(nom)
	for i, c in ipairs(candidats) do
		if c.nom == nom then return c, i end
	end
end

local function Inviter(nom)
	local c = TrouverCandidat(nom)
	if not c then return end
	-- plus de 5 joueurs prévus : on passe en raid avant que le groupe soit plein
	if monAnnonce and (monAnnonce.taille or 5) > 5 and not IsInRaid() and GetNumGroupMembers() >= 4 then
		local convertir = (C_PartyInfo and C_PartyInfo.ConvertToRaid) or ConvertToRaid
		if convertir then pcall(convertir) end
	end
	if C_PartyInfo and C_PartyInfo.InviteUnit then
		C_PartyInfo.InviteUnit(nom)
	elseif InviteUnit then
		InviteUnit(nom)
	end
	c.statut, c.invite = "invite", GetTime()
	if Rafraichir then Rafraichir() end
end

local function Refuser(nom)
	local c, i = TrouverCandidat(nom)
	if not c or not monAnnonce then return end
	Envoyer("R" .. SEP .. monAnnonce.id .. SEP .. "non", "WHISPER", nom)
	table.remove(candidats, i)
	if Rafraichir then Rafraichir() end
end

--------------------------------------------------------------------------------
-- Candidatures (côté joueur)
--------------------------------------------------------------------------------

local function PlacesLibres(a, role)
	if not role or not a.besoin[role] then return nil end
	return (a.besoin[role] or 0) - (a.pris[role] or 0)
end

local function Postuler(id)
	local a = annonces[id]
	if not a then return end
	local _, classe = UnitClass("player")
	local role = (ns.MonRole and ns.MonRole()) or "?"
	Envoyer(table.concat({ "P", id, role, classe or "", UnitLevel("player") or 0 }, SEP), "WHISPER", a.chef)
	candidatures[id] = "envoyee"
	if Rafraichir then Rafraichir() end
end

local function AnnulerCandidature(id)
	local a = annonces[id]
	if a then Envoyer("X" .. SEP .. id, "WHISPER", a.chef) end
	candidatures[id] = nil
	if Rafraichir then Rafraichir() end
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or not msg or not expediteur then return end
	-- on garde le nom tel que reçu (affichage, chuchotements, invitations) et on compare le normalisé
	local deMoi = Normaliser(expediteur) == MonNom()
	if deMoi then
		dernierNomRecuDeMoi = expediteur
		if not (ns.TestSolo and ns.TestSolo()) then return end
	end
	local p = Decouper(msg, SEP)
	local type_ = p[1]

	-- Test seul : mes propres messages sont traités comme ceux d'un autre membre.
	-- Mon annonce reçue prend l'identifiant « test:<id> » (pour ne pas être confondue avec la
	-- vraie) ; les candidatures qui la visent reviennent à la vraie annonce.
	if deMoi then
		if type_ == "Q" then return end
		if type_ == "A" or type_ == "F" or type_ == "R" then
			p[2] = "test:" .. (p[2] or ""):gsub("^test:", "")
		end
	end
	if (type_ == "P" or type_ == "X") and p[2] then p[2] = p[2]:gsub("^test:", "") end

	if type_ == "A" and canal == "GUILD" then
		local id = p[2]
		if not id then return end
		local ancienne = annonces[id]
		local membres = {}
		for _, m in ipairs(p[15] and p[15] ~= "" and Decouper(p[15], ",") or {}) do
			local nom, lettre = m:match("^(.-)%.(.)$")
			if nom then membres[#membres + 1] = { nom = nom, role = ROLES_LETTRES[lettre] } end
		end
		annonces[id] = {
			id = id, chef = expediteur,
			premiere = ancienne and ancienne.premiere or GetTime(),
			code = p[3] or "",
			besoin = { tank = tonumber(p[4]) or 0, heal = tonumber(p[5]) or 0, dps = tonumber(p[6]) or 0 },
			pris = { tank = tonumber(p[7]) or 0, heal = tonumber(p[8]) or 0, dps = tonumber(p[9]) or 0 },
			taille = tonumber(p[10]) or 5, membres = tonumber(p[11]) or 1,
			niveau = tonumber(p[12]) or 0, classe = p[13] ~= "" and p[13] or nil,
			commentaire = p[14] or "", liste = membres,
			rappel = p[16] == "1",
			prochainRappel = ancienne and ancienne.prochainRappel,
			vu = GetTime(),
		}
		if not ancienne then
			local nomContenu = InfoContenu(annonces[id].code).nom
			-- bulle + son discret à côté du bouton de la mini-carte (pas pendant le calme de connexion :
			-- les groupes déjà ouverts arrivent tous d'un coup et ne sont pas « nouveaux »)
			local idQuete = tonumber((annonces[id].code or ""):match("^q(%d+)$"))
			if GetTime() <= finCalme then
				-- calme de connexion : pas de bulle
			elseif idQuete then
				-- groupe de quête : seulement les membres qui ont cette quête sont prévenus
				if ns.AQuete and ns.AQuete(idQuete) and ns.Notifier then
					local titre = ns.InfoQuete and ns.InfoQuete(idQuete) or "?"
					local zone = annonces[id].commentaire ~= "" and (" (" .. annonces[id].commentaire .. ")") or ""
					ns.Notifier("quetes", "Groupe pour ta quête", ("%s : |cffffd100%s|r%s"):format(NomCourt(expediteur), titre, zone),
						nil, function() if ns.OuvrirGroupes then ns.OuvrirGroupes() end end)
				end
			elseif ns.AlerteNouveauGroupe then
				ns.AlerteNouveauGroupe(NomCourt(expediteur), nomContenu)
			end
		end
		if Rafraichir then Rafraichir() end

	elseif type_ == "F" then
		local id = p[2]
		if id and annonces[id] then
			annonces[id] = nil
			candidatures[id] = nil
			if Rafraichir then Rafraichir() end
		end

	elseif type_ == "Q" then
		if monAnnonce then C_Timer.After(math.random() * 4, DiffuserMonAnnonce) end

	elseif type_ == "P" then
		if not monAnnonce or p[2] ~= monAnnonce.id then return end
		local c = TrouverCandidat(expediteur)
		if not c then
			c = { nom = expediteur }
			candidats[#candidats + 1] = c
		end
		c.role, c.classe, c.niveau, c.statut = p[3], p[4] ~= "" and p[4] or nil, tonumber(p[5]) or 0, "attente"
		if ns.Notifier then
			ns.Notifier("candidatures", "Nouvelle candidature", ("%s postule : %s"):format(NomCourt(expediteur), TexteRole(c.role)), "TELL_MESSAGE")
		end
		if Rafraichir then Rafraichir() end

	elseif type_ == "X" then
		local c, i = TrouverCandidat(expediteur)
		if c and monAnnonce and p[2] == monAnnonce.id then
			table.remove(candidats, i)
			if Rafraichir then Rafraichir() end
		end

	elseif type_ == "R" then
		local id = p[2]
		if id and candidatures[id] then
			candidatures[id] = "refusee"
			if ns.Notifier then ns.Notifier("candidatures", "Candidature refusée", "par " .. NomCourt(expediteur)) end
			if Rafraichir then Rafraichir() end
		end
	end
end

--------------------------------------------------------------------------------
-- Entretien
--------------------------------------------------------------------------------

-- Rappel (option du créateur) : bulle silencieuse toutes les 5 min tant que le groupe cherche
local DELAI_RAPPEL = 300
local function Rappels(maintenant)
	if not ns.Notifier then return end
	for id, a in pairs(annonces) do
		local mien = monAnnonce and (id == monAnnonce.id or id == "test:" .. monAnnonce.id)
		if a.rappel and not mien and (a.membres or 1) < (a.taille or 5) and not candidatures[id] then
			a.prochainRappel = a.prochainRappel or (a.premiere + DELAI_RAPPEL)
			if maintenant >= a.prochainRappel then
				a.prochainRappel = maintenant + DELAI_RAPPEL
				local idQuete = tonumber((a.code or ""):match("^q(%d+)$"))
				-- groupe de quête : seulement pour ceux qui ont la quête (comme la bulle de création)
				if not idQuete or (ns.AQuete and ns.AQuete(idQuete)) then
					local libres = (a.taille or 5) - (a.membres or 1)
					ns.Notifier("groupes", "Groupe toujours en recherche", ("%s : |cffffd100%s|r (%d place%s)"):format(
						NomCourt(a.chef), InfoContenu(a.code).nom, libres, libres > 1 and "s" or ""), "aucun",
						function() if ns.OuvrirGroupes then ns.OuvrirGroupes() end end)
				end
			end
		end
	end
end

local DELAI_INVITATION = 60
local function Entretien()
	local maintenant = GetTime()
	local change = false
	pcall(Rappels, maintenant)
	for _, c in ipairs(candidats) do
		if c.statut == "invite" and maintenant - (c.invite or 0) > DELAI_INVITATION then
			c.statut = "attente"
			change = true
		end
	end
	for id, a in pairs(annonces) do
		if maintenant - a.vu > DUREE_VIE then
			annonces[id] = nil
			candidatures[id] = nil
			change = true
		end
	end
	if monAnnonce then
		-- rediffusion régulière, ou plus tôt si la composition a changé (rôle annoncé, etc.)
		if maintenant - dernierEnvoi >= RAPPEL or (SignatureComposition() ~= derniereSignature and maintenant - dernierEnvoi > 5) then
			DiffuserMonAnnonce()
			change = true
		end
	end
	if change and Rafraichir then Rafraichir() end
end

local function SurChangementDeGroupe()
	-- mes candidatures : je suis entré dans le groupe du chef, elles ne sont plus « en attente »
	for id in pairs(candidatures) do
		local a = annonces[id]
		if a and a.chef and IsInGroup() and DansMonGroupe(a.chef) then candidatures[id] = nil end
	end
	if monAnnonce then
		if not PeutAnnoncer() then
			FermerMonAnnonce("tu n'es plus chef du groupe")
			return
		end
		if NombreMembres() >= monAnnonce.taille then
			FermerMonAnnonce("groupe complet")
			return
		end
		for i = #candidats, 1, -1 do
			if DansMonGroupe(candidats[i].nom) then table.remove(candidats, i) end
		end
		if GetTime() - dernierEnvoi > 5 then DiffuserMonAnnonce() end
	end
	if Rafraichir then Rafraichir() end
end

--------------------------------------------------------------------------------
-- Éléments d'interface
--------------------------------------------------------------------------------

local function NouveauBouton(parent, texte, largeur, hauteur)
	local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	b:SetSize(largeur or 80, hauteur or 22)
	b:SetText(texte)
	return b
end

local function Infobulle(cadre, Remplir)
	cadre:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		Remplir(GameTooltip, self)
		GameTooltip:Show()
	end)
	cadre:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Emplacements de rôles façon FF14 : une icône par place (≤ 10 joueurs), sinon icône + compteur
-- Places par rôle façon FF14 : une icône par place, chacune dans un petit cadre
-- (fond sombre + liseré doré) ; au-delà de 10 places, 3 icônes + « pris/besoin »
local ECART_PLACES = 6

local function CreerEmplacements(parent, taille)
	local w = CreateFrame("Frame", nil, parent)
	w:SetSize(10 * (taille + ECART_PLACES), taille + 4)
	w.icones, w.cadres, w.compteurs = {}, {}, {}
	for i = 1, 10 do
		local t = w:CreateTexture(nil, "ARTWORK")
		t:SetSize(taille, taille)
		w.icones[i] = t
		local lisere = w:CreateTexture(nil, "BACKGROUND", nil, -1)
		lisere:SetSize(taille + 4, taille + 4)
		lisere:SetPoint("CENTER", t, "CENTER", 0, 0)
		lisere:SetColorTexture(1, 0.82, 0, 0.55)
		local fond = w:CreateTexture(nil, "BACKGROUND", nil, 0)
		fond:SetSize(taille + 2, taille + 2)
		fond:SetPoint("CENTER", t, "CENTER", 0, 0)
		fond:SetColorTexture(0.05, 0.05, 0.05, 0.9)
		w.cadres[i] = { lisere, fond }
	end
	for _, role in ipairs(ROLES) do
		local fs = w:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		w.compteurs[role] = fs
	end
	w.taille = taille
	return w
end

local function MontrerPlace(w, i, visible)
	w.icones[i]:SetShown(visible)
	for _, c in ipairs(w.cadres[i]) do c:SetShown(visible) end
end

local function MajEmplacements(w, besoin, pris, taille)
	local total = (besoin.tank or 0) + (besoin.heal or 0) + (besoin.dps or 0)
	for _, fs in pairs(w.compteurs) do fs:Hide() end
	for i = 1, 10 do MontrerPlace(w, i, false) end
	if total <= 10 and taille <= 10 then
		-- une place par joueur, alignées à droite
		local pas = w.taille + ECART_PLACES
		local i = 10 - total + 1
		for _, role in ipairs(ROLES) do
			for n = 1, besoin[role] or 0 do
				local t = w.icones[i]
				if t then
					t:ClearAllPoints()
					t:SetPoint("RIGHT", w, "RIGHT", -2 - (10 - i) * pas, 0)
					IconeRole(t, role, n <= (pris[role] or 0))
					MontrerPlace(w, i, true)
				end
				i = i + 1
			end
		end
	else
		-- grand groupe : 3 icônes + « pris/besoin » (icône éteinte quand le rôle est complet)
		local decalage = 2
		for n, role in ipairs(ROLES) do
			local t = w.icones[n]
			local fs = w.compteurs[role]
			t:ClearAllPoints()
			t:SetPoint("LEFT", w, "LEFT", decalage, 0)
			IconeRole(t, role, (pris[role] or 0) < (besoin[role] or 0))
			MontrerPlace(w, n, true)
			fs:ClearAllPoints()
			fs:SetPoint("LEFT", t, "RIGHT", 4, 0)
			fs:SetText(("%d/%d"):format(pris[role] or 0, besoin[role] or 0))
			fs:Show()
			decalage = decalage + w.taille + 38
		end
	end
end

-- remet les icônes en ligne (après un affichage « grand groupe »)
-- Petit bouton « entrée sur la carte » (repère sur la carte du monde, voir GuildUp_Carte.lua)
local function CreerBoutonEntree(parent)
	local bt = CreateFrame("Button", nil, parent)
	bt:SetSize(20, 20)
	bt.icone = bt:CreateTexture(nil, "ARTWORK")
	bt.icone:SetAllPoints(bt)
	bt.icone:SetTexture("Interface\\Minimap\\Tracking\\POIArrow")
	if AtlasExiste("Waypoint-MapPin-Untracked") then bt.icone:SetAtlas("Waypoint-MapPin-Untracked") end
	bt:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	bt:SetScript("OnClick", function(self)
		if self.nom and ns.MontrerEntree then ns.MontrerEntree(self.nom, self.mapID) end
	end)
	bt:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Entrée sur la carte")
		GameTooltip:AddLine("Clic : repère sur la carte du monde vers l'entrée de « " .. (self.nom or "?") .. " ».", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	bt:SetScript("OnLeave", function() GameTooltip:Hide() end)
	bt:Hide()
	return bt
end

-- Montre le bouton seulement si l'entrée de ce contenu est connue
local function MajBoutonEntree(bt, e)
	local connue = e and ns.EntreeDonjon and ns.EntreeDonjon(e.nom, e.mapID)
	bt.nom, bt.mapID = e and e.nom, e and e.mapID
	bt:SetShown(connue and true or false)
end

local function RangerEmplacements(w)
	for i, t in ipairs(w.icones) do
		t:ClearAllPoints()
		t:SetPoint("RIGHT", w, "RIGHT", -2 - (10 - i) * (w.taille + ECART_PLACES), 0)
	end
end

--------------------------------------------------------------------------------
-- Fenêtre principale : même disposition que la recherche de groupe officielle de Forever
-- (Blizzard_LFGVanilla_Browse.xml) : bande de pierre en haut, encart central illustré
-- (groupfinder-background + cadre common-insideframe), filets dorés, boutons dans la bande du bas.
--------------------------------------------------------------------------------

local LARGEUR, HAUTEUR = 458, 535
local HAUT_ENCART = -80          -- haut de l'encart central
local LIGNE_HAUT = -100          -- filet doré du haut (20 sous le haut de l'encart)
local BAS_LISTE = 66             -- bas des listes (au-dessus du filet du bas, à 61 du bas)
local LARGEUR_LISTE = 404

local function CreerCadrePrincipal()
	local ok, f = pcall(CreateFrame, "Frame", "GuildUpGroupes", UIParent, "PortraitFrameTemplate")
	if not ok then
		ok, f = pcall(CreateFrame, "Frame", "GuildUpGroupes", UIParent, "BasicFrameTemplateWithInset")
		if not ok then f = CreateFrame("Frame", "GuildUpGroupes", UIParent) end
	end
	f:SetSize(LARGEUR, HAUTEUR)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	f:SetToplevel(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	tinsert(UISpecialFrames, "GuildUpGroupes")
	local titre = "Groupes de la guilde"
	if f.SetTitle then pcall(f.SetTitle, f, titre)
	elseif f.TitleText then f.TitleText:SetText(titre) end
	if f.SetPortraitToAsset then
		pcall(f.SetPortraitToAsset, f, "Interface\\Icons\\Ability_Warrior_RallyingCry")
	end

	-- bande de pierre sous le titre
	local pierre = f:CreateTexture(nil, "BACKGROUND", nil, -5)
	pierre:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -21)
	pierre:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -2, HAUT_ENCART - 7)
	PoserAtlas(pierre, "groupfinder-Stat-StoneBG", { 0.12, 0.1, 0.08, 1 })

	-- encart central : illustration + cadre intérieur
	local encart = CreateFrame("Frame", nil, f)
	encart:SetPoint("TOPLEFT", f, "TOPLEFT", 4, HAUT_ENCART)
	encart:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 3)
	encart:SetFrameLevel(f:GetFrameLevel() + 1)
	local illustration = encart:CreateTexture(nil, "BACKGROUND")
	illustration:SetPoint("TOPLEFT", encart, "TOPLEFT", 3, -3)
	illustration:SetPoint("BOTTOMRIGHT", encart, "BOTTOMRIGHT", -3, 3)
	PoserAtlas(illustration, "groupfinder-background", { 0.06, 0.05, 0.05, 1 })
	local cadre = encart:CreateTexture(nil, "BORDER")
	cadre:SetPoint("TOPLEFT", encart, "TOPLEFT", 0, 2)
	cadre:SetPoint("BOTTOMRIGHT", encart, "BOTTOMRIGHT", 0, 0)
	if not PoserAtlas(cadre, "common-insideframe") then cadre:Hide() end
	f.encart = encart

	-- filets dorés : haut de la liste, et au-dessus des boutons du bas
	local function Filet(y, depuisLeBas)
		local t = encart:CreateTexture(nil, "OVERLAY")
		if AtlasExiste("groupfinder-ScrollLine") then
			t:SetAtlas("groupfinder-ScrollLine", true)
		else
			t:SetColorTexture(1, 0.82, 0, 0.3)
			t:SetHeight(1)
		end
		local point = depuisLeBas and "BOTTOMLEFT" or "TOPLEFT"
		local point2 = depuisLeBas and "BOTTOMRIGHT" or "TOPRIGHT"
		t:ClearAllPoints()
		t:SetPoint("LEFT", f, point, 4, y)
		t:SetPoint("RIGHT", f, point2, -4, y)
		return t
	end
	Filet(LIGNE_HAUT, false)
	Filet(61, true)
	return f
end

local function NouvellePage(f)
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	p:SetFrameLevel(f.encart:GetFrameLevel() + 2)
	return p
end

local function NouvelleListe(p, haut, bas)
	local defile = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", p, "TOPLEFT", 10, haut)
	defile:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -32, bas)
	local contenu = CreateFrame("Frame", nil, defile)
	contenu:SetSize(LARGEUR_LISTE, 10)
	defile:SetScrollChild(contenu)
	return defile, contenu
end

local function CreerOnglets(f, noms, Choisir)
	f.onglets = {}
	for i, nom in ipairs(noms) do
		local ok, o = pcall(CreateFrame, "Button", "GuildUpGroupesTab" .. i, f, "PanelTabButtonTemplate")
		if not ok then o = NouveauBouton(f, nom, 110, 24) end
		o:SetID(i)
		o:SetText(nom)
		if PanelTemplates_TabResize then pcall(PanelTemplates_TabResize, o, 0) end
		if i == 1 then
			o:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 12, 2)
		else
			o:SetPoint("LEFT", f.onglets[i - 1], "RIGHT", 3, 0)
		end
		o:SetScript("OnClick", function() Choisir(i) end)
		f.onglets[i] = o
	end
	f.numTabs = #noms
	f.Tabs = f.onglets
end

local function MarquerOnglet(f, i)
	if PanelTemplates_SetTab then pcall(PanelTemplates_SetTab, f, i) end
end

--------------------------------------------------------------------------------
-- Onglet 1 : Parcourir
--------------------------------------------------------------------------------

-- Choix du rôle (Tank / Heal / DPS) dans la bande de pierre, comme les boutons de rôle de la
-- recherche de groupe officielle. Même choix que la barre de rôle (ns.ChoisirRole).
local choixRoles = {} -- tous les sélecteurs créés, pour les remettre à jour ensemble

local function MajChoixRole(w)
	local actuel = ns.MonRole and ns.MonRole()
	local manuel = ns.RoleChoisiALaMain and ns.RoleChoisiALaMain()
	for role, b in pairs(w.boutons) do
		IconeRole(b.icone, role, actuel == role)
		b.coche:SetShown(manuel == role)
	end
end

local function CreerChoixRole(parent)
	local w = CreateFrame("Frame", nil, parent)
	w:SetSize(3 * 42, 40)
	w.boutons = {}
	for i, role in ipairs(ROLES) do
		local b = CreateFrame("Button", nil, w)
		b:SetSize(38, 38)
		b:SetPoint("LEFT", w, "LEFT", (i - 1) * 42, 0)
		b.icone = b:CreateTexture(nil, "ARTWORK")
		b.icone:SetAllPoints(b)
		local survol = b:CreateTexture(nil, "HIGHLIGHT")
		survol:SetAllPoints(b)
		survol:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
		survol:SetBlendMode("ADD")
		survol:SetAlpha(0.5)
		-- coche : rôle choisi à la main (sinon rôle automatique : groupe / spécialisation)
		b.coche = b:CreateTexture(nil, "OVERLAY")
		b.coche:SetSize(18, 18)
		b.coche:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 4, -4)
		b.coche:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		b:SetScript("OnClick", function()
			if ns.ChoisirRole then ns.ChoisirRole(role) end
			for _, autre in ipairs(choixRoles) do MajChoixRole(autre) end
			if Rafraichir then Rafraichir() end
		end)
		Infobulle(b, function(tt)
			tt:SetText(TexteRole(role))
			tt:AddLine("Clic : annoncer ce rôle à la guilde.", 1, 1, 1)
			tt:AddLine("Re-clic : revenir en automatique.", 0.7, 0.7, 0.7)
		end)
		w.boutons[role] = b
	end
	choixRoles[#choixRoles + 1] = w
	return w
end

-- appelé par GuildUp.lua quand le rôle change depuis la barre de rôle
ns.SurChangementDeRole = function()
	for _, w in ipairs(choixRoles) do MajChoixRole(w) end
	if Rafraichir then Rafraichir() end
end

local HAUTEUR_ENTREE = 56

local function CreerEntree(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(LARGEUR_LISTE, HAUTEUR_ENTREE - 4)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	PoserAtlas(b.fond, "groupfinder-highlightbar", { 0.15, 0.13, 0.1, 0.8 })
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetAllPoints(b)
	if not PoserAtlas(survol, "groupfinder-highlightbar-blue") then survol:SetColorTexture(0.3, 0.5, 1, 0.15) end
	survol:SetBlendMode("ADD")
	survol:SetAlpha(0.6)

	-- vignette large : les images de catégorie sont en paysage
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(72, 44)
	b.icone:SetPoint("LEFT", b, "LEFT", 4, 0)

	b.nom = b:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	b.nom:SetPoint("TOPLEFT", b, "TOPLEFT", 82, -5)
	b.nom:SetPoint("RIGHT", b, "RIGHT", -200, 0)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)

	b.chefIcone = b:CreateTexture(nil, "ARTWORK")
	b.chefIcone:SetSize(14, 14)
	b.chefIcone:SetPoint("TOPLEFT", b.nom, "BOTTOMLEFT", 0, -3)
	if not PoserAtlas(b.chefIcone, "groupfinder-icon-leader") then
		b.chefIcone:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon")
	end
	b.classe = b:CreateTexture(nil, "ARTWORK")
	b.classe:SetSize(14, 14)
	b.classe:SetPoint("LEFT", b.chefIcone, "RIGHT", 2, 0)
	b.chef = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	b.chef:SetPoint("LEFT", b.classe, "RIGHT", 3, 0)
	b.niveaux = b:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	b.niveaux:SetPoint("LEFT", b.chef, "RIGHT", 8, 0)

	b.commentaire = b:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	b.commentaire:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 82, 5)
	b.commentaire:SetPoint("RIGHT", b, "RIGHT", -150, 0)
	b.commentaire:SetJustifyH("LEFT")
	b.commentaire:SetWordWrap(false)

	b.places = CreerEmplacements(b, 13)
	b.places:SetPoint("TOPRIGHT", b, "TOPRIGHT", -6, -6)
	b.entree = CreerBoutonEntree(b)
	b.entree:SetPoint("BOTTOMRIGHT", b.icone, "BOTTOMRIGHT", 2, -2)
	b.compte = b:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	b.compte:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -100, 8)

	b.bouton = NouveauBouton(b, "Postuler", 90, 20)
	b.bouton:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -6, 5)

	Infobulle(b, function(tt, self)
		local a = self.annonce
		if not a then return end
		local e = InfoContenu(a.code)
		tt:SetText(e.nom, 1, 0.82, 0)
		tt:AddLine(TexteNiveaux(e) .. "  ·  " .. (a.membres or 1) .. "/" .. (a.taille or 5) .. " joueurs", 1, 1, 1)
		tt:AddLine(" ")
		tt:AddLine("Chef : " .. CouleurClasse(a.classe) .. NomCourt(a.chef) .. "|r (" .. (a.niveau or 0) .. ")", 1, 1, 1)
		if ns.LignesIdentite then ns.LignesIdentite(tt, a.chef) end
		for _, m in ipairs(a.liste or {}) do
			if Prenom(m.nom) ~= Prenom(a.chef) then tt:AddLine("  " .. m.nom .. " — " .. TexteRole(m.role), 1, 1, 1) end
		end
		tt:AddLine(" ")
		for _, role in ipairs(ROLES) do
			local libres = PlacesLibres(a, role) or 0
			tt:AddLine(("%s : %d/%d%s"):format(TexteRole(role), a.pris[role] or 0, a.besoin[role] or 0,
				libres > 0 and ("  |cff33dd55(" .. libres .. " libre" .. (libres > 1 and "s" or "") .. ")|r") or ""), 1, 1, 1)
		end
		if a.commentaire ~= "" then
			tt:AddLine(" ")
			tt:AddLine(a.commentaire, 0.8, 0.8, 0.8, true)
		end
	end)
	return b
end

local function CreerPageParcourir(f, AllerVersMonGroupe)
	local p = NouvellePage(f)

	-- bande du haut : titre et rôle
	local titre = p:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", 74, -34)
	titre:SetText("Groupes de la guilde")
	p.monRole = p:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	p.monRole:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	p.choixRole = CreerChoixRole(p)
	p.choixRole:SetPoint("TOPRIGHT", p, "TOPRIGHT", -16, -30)

	-- en-têtes de colonnes, au-dessus du filet
	local colonne1 = p:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	colonne1:SetPoint("TOPLEFT", p, "TOPLEFT", 16, -86)
	colonne1:SetText("Contenu")
	local colonne2 = p:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	colonne2:SetPoint("TOPRIGHT", p, "TOPRIGHT", -44, -86)
	colonne2:SetText("Places")

	p.defile, p.contenu = NouvelleListe(p, LIGNE_HAUT - 4, BAS_LISTE)
	p.entrees = {}

	p.vide = p:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	p.vide:SetPoint("TOP", p, "TOP", 0, LIGNE_HAUT - 30)
	p.vide:SetWidth(300)
	p.vide:SetText("Aucun groupe ouvert pour l'instant. Si tu ne trouves pas ce que tu cherches, crée le tien.")

	-- bande du bas
	local actualiser = NouveauBouton(p, "Actualiser", 111, 28)
	actualiser:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", 21, 16)
	actualiser:SetScript("OnClick", function()
		Envoyer("Q", "GUILD")
	end)
	local creer = NouveauBouton(p, "Créer un groupe", 130, 28)
	creer:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -21, 16)
	creer:SetScript("OnClick", AllerVersMonGroupe)
	return p
end

local function RafraichirParcourir(p)
	local monRole = ns.MonRole and ns.MonRole()
	p.monRole:SetText("Ton rôle : " .. TexteRole(monRole))
	local liste = {}
	for _, a in pairs(annonces) do
		if not (monAnnonce and a.id == monAnnonce.id) then liste[#liste + 1] = a end
	end
	table.sort(liste, function(a, b) return a.premiere > b.premiere end)
	-- mon propre groupe, en tête de liste (visible, mais on ne peut pas y postuler)
	if monAnnonce then
		local pris, membres = Composition(monAnnonce.besoin)
		local _, classe = UnitClass("player")
		table.insert(liste, 1, {
			id = monAnnonce.id, estMoi = true, chef = UnitName("player"), premiere = GetTime(),
			code = monAnnonce.code, besoin = monAnnonce.besoin, pris = pris,
			taille = monAnnonce.taille, membres = #membres, niveau = UnitLevel("player") or 0, classe = classe,
			commentaire = monAnnonce.commentaire, liste = membres,
		})
	end
	p.vide:SetShown(#liste == 0)
	for i, a in ipairs(liste) do
		local b = p.entrees[i]
		if not b then
			b = CreerEntree(p.contenu)
			p.entrees[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", p.contenu, "TOPLEFT", 0, -(i - 1) * HAUTEUR_ENTREE)
		b.annonce = a
		local e = InfoContenu(a.code)
		PoserIcone(b.icone, e.icone)
		b.nom:SetText(e.nom)
		IconeClasse(b.classe, a.classe)
		b.chef:SetText(CouleurClasse(a.classe) .. NomCourt(a.chef) .. "|r (" .. (a.niveau or 0) .. ")")
		b.niveaux:SetText(CouleurNiveau(e) .. TexteNiveaux(e) .. "|r")
		b.commentaire:SetText(a.commentaire ~= "" and ("« " .. a.commentaire .. " »") or "")
		RangerEmplacements(b.places)
		MajEmplacements(b.places, a.besoin, a.pris, a.taille or 5)
		MajBoutonEntree(b.entree, e)
		b.compte:SetText((a.membres or 1) .. "/" .. (a.taille or 5))

		local etat = candidatures[a.id]
		local libres = PlacesLibres(a, monRole)
		local bt = b.bouton
		bt:SetEnabled(true)
		if a.estMoi then
			bt:SetText("Ton groupe")
			bt:SetEnabled(false)
		elseif etat == "envoyee" then
			bt:SetText("Annuler")
			bt:SetScript("OnClick", function() AnnulerCandidature(a.id) end)
		elseif etat == "refusee" then
			bt:SetText("Refusé")
			bt:SetEnabled(false)
		elseif (a.membres or 1) >= (a.taille or 5) then
			bt:SetText("Complet")
			bt:SetEnabled(false)
		elseif libres and libres <= 0 then
			bt:SetText("Rôle complet")
			bt:SetEnabled(false)
		else
			bt:SetText("Postuler")
			bt:SetScript("OnClick", function() Postuler(a.id) end)
		end
		b:Show()
	end
	for i = #liste + 1, #p.entrees do p.entrees[i]:Hide() end
	p.contenu:SetHeight(math.max(10, #liste * HAUTEUR_ENTREE))
end

--------------------------------------------------------------------------------
-- Onglet 2 : Mon groupe (créer / gérer mon annonce)
--------------------------------------------------------------------------------

local HAUTEUR_ACTIVITE = 26

-- Taille réelle du cadre des boutons de catégorie (atlas groupfinder-button-cover)
local function TailleBoutonCategorie()
	local info = C_Texture and C_Texture.GetAtlasInfo and C_Texture.GetAtlasInfo("groupfinder-button-cover")
	local l, h = (info and info.width) or 319, (info and info.height) or 67
	if l > 400 then h = h * 400 / l; l = 400 end -- au cas où, sans déformer
	return l, h
end

-- Bouton de catégorie comme dans la recherche de groupe officielle (LFGListingCategoryTemplate) :
-- image de la catégorie en retrait (5, 8, 5, 5), cadre à sa taille réelle, texte à gauche
local function CreerBoutonCategorie(parent)
	local l, h = TailleBoutonCategorie()
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(l, h)
	b.icone = b:CreateTexture(nil, "BACKGROUND")
	b.icone:SetPoint("TOPLEFT", b, "TOPLEFT", 5, -8)
	b.icone:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -5, 5)
	b.cadre = b:CreateTexture(nil, "ARTWORK")
	b.cadre:SetPoint("CENTER", b, "CENTER", 0, 0)
	if AtlasExiste("groupfinder-button-cover") then
		b.cadre:SetAtlas("groupfinder-button-cover", true)
	else
		b.cadre:Hide()
	end
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetPoint("CENTER", b, "CENTER", 0, 0)
	if AtlasExiste("groupfinder-button-cover-hover") then
		survol:SetAtlas("groupfinder-button-cover-hover", true)
	else
		survol:SetAllPoints(b)
		survol:SetColorTexture(1, 1, 1, 0.15)
	end
	b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	b.texte:SetPoint("LEFT", b, "LEFT", 20, 0)
	b.texte:SetJustifyH("LEFT")
	return b
end

local function CreerLigneActivite(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetSize(LARGEUR_LISTE, HAUTEUR_ACTIVITE - 2)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	PoserAtlas(b.fond, "common-button-list-mid2", { 1, 1, 1, 0.05 })
	local survol = b:CreateTexture(nil, "HIGHLIGHT")
	survol:SetAllPoints(b)
	if not PoserAtlas(survol, "common-button-list-mid2-hover") then survol:SetColorTexture(1, 1, 1, 0.1) end
	-- la couche HIGHLIGHT passe au-dessus du texte : fondu additif léger, sinon tout devient marron
	survol:SetBlendMode("ADD")
	survol:SetAlpha(0.35)
	b.choisi = b:CreateTexture(nil, "ARTWORK")
	b.choisi:SetAllPoints(b)
	if not PoserAtlas(b.choisi, "common-button-list-mid2-selected") then b.choisi:SetColorTexture(1, 0.82, 0, 0.25) end
	b.choisi:SetBlendMode("ADD")
	b.icone = b:CreateTexture(nil, "ARTWORK", nil, 2)
	b.icone:SetSize(20, 20)
	b.icone:SetPoint("LEFT", b, "LEFT", 4, 0)
	b.nom = b:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.infos = b:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	b.infos:SetPoint("RIGHT", b, "RIGHT", -8, 0)
	-- repère de l'entrée sur la carte, devant le nom
	b.entree = CreerBoutonEntree(b)
	b.entree:SetSize(18, 18)
	b.entree:SetPoint("LEFT", b, "LEFT", 4, 0)
	return b
end

local function CreerCompteurRole(parent, role, Changer)
	local c = CreateFrame("Frame", nil, parent)
	c:SetSize(118, 30)
	-- petit cadre : liseré doré + fond sombre
	local lisere = c:CreateTexture(nil, "BACKGROUND", nil, -1)
	lisere:SetPoint("TOPLEFT", c, "TOPLEFT", -5, 4)
	lisere:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", 5, -4)
	lisere:SetColorTexture(1, 0.82, 0, 0.55)
	local fond = c:CreateTexture(nil, "BACKGROUND", nil, 0)
	fond:SetPoint("TOPLEFT", lisere, "TOPLEFT", 1, -1)
	fond:SetPoint("BOTTOMRIGHT", lisere, "BOTTOMRIGHT", -1, 1)
	fond:SetColorTexture(0.05, 0.05, 0.05, 0.85)
	c.icone = c:CreateTexture(nil, "ARTWORK")
	c.icone:SetSize(26, 26)
	c.icone:SetPoint("LEFT", c, "LEFT", 0, 0)
	IconeRole(c.icone, role, true)
	c.moins = NouveauBouton(c, "-", 22, 22)
	c.moins:SetPoint("LEFT", c.icone, "RIGHT", 4, 0)
	c.valeur = c:CreateFontString(nil, "ARTWORK", "GameFontHighlightLarge")
	c.valeur:SetPoint("LEFT", c.moins, "RIGHT", 4, 0)
	c.valeur:SetWidth(24)
	c.plus = NouveauBouton(c, "+", 22, 22)
	c.plus:SetPoint("LEFT", c.valeur, "RIGHT", 4, 0)
	c.moins:SetScript("OnClick", function() Changer(role, -1) end)
	c.plus:SetScript("OnClick", function() Changer(role, 1) end)
	return c
end

local function CreerPageMonGroupe(f)
	local p = NouvellePage(f)
	p.categorieChoisie = nil
	p.besoin = nil
	-- choix du rôle, en haut à droite (visible en création comme une fois l'annonce publiée)
	p.choixRole = CreerChoixRole(p)
	p.choixRole:SetPoint("TOPRIGHT", p, "TOPRIGHT", -16, -30)
	p.choixRole:SetFrameLevel(p:GetFrameLevel() + 5)

	----------------------------------------------------------------- création
	-- deux écrans, comme l'officiel : d'abord les catégories, puis les détails (avec « Retour »)
	local creer = CreateFrame("Frame", nil, p)
	creer:SetAllPoints(p)
	p.creer = creer
	p.etape = "categories"

	-- bande de pierre : titre (catégorie choisie) et consigne
	creer.titre = creer:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	creer.titre:SetPoint("TOPLEFT", creer, "TOPLEFT", 74, -34)
	creer.consigne = creer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	creer.consigne:SetPoint("TOPLEFT", creer.titre, "BOTTOMLEFT", 0, -6)

	-- écran 1 : grands boutons de catégorie empilés
	creer.ecranCategories = CreateFrame("Frame", nil, creer)
	creer.ecranCategories:SetAllPoints(creer)
	creer.boutonsCategories = {}

	local t1 = creer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	t1:SetPoint("TOPLEFT", creer, "TOPLEFT", 16, -86)
	t1:SetText("Contenu")
	local t1b = creer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	t1b:SetPoint("TOPRIGHT", creer, "TOPRIGHT", -44, -86)
	t1b:SetText("Niveau  ·  Joueurs")

	creer.defile, creer.liste = NouvelleListe(creer, LIGNE_HAUT - 4, HAUTEUR - 300)
	creer.lignes = {}

	local separation = creer:CreateTexture(nil, "ARTWORK")
	if AtlasExiste("groupfinder-ScrollLine") then
		separation:SetAtlas("groupfinder-ScrollLine", true)
	else
		separation:SetColorTexture(1, 0.82, 0, 0.3)
		separation:SetHeight(1)
	end
	separation:SetPoint("LEFT", creer, "TOPLEFT", 4, -304)
	separation:SetPoint("RIGHT", creer, "TOPRIGHT", -4, -304)

	local t2 = creer:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t2:SetPoint("TOPLEFT", creer, "TOPLEFT", 16, -314)
	t2:SetText("Places recherchées")
	creer.taille = creer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	creer.taille:SetPoint("TOPRIGHT", creer, "TOPRIGHT", -16, -316)
	creer.compteurs = {}
	local function Changer(role, delta)
		if not p.besoin then return end
		local e = fenetre.choix and InfoContenu(fenetre.choix)
		local taille = TailleMaxContenu(e)
		local total = p.besoin.tank + p.besoin.heal + p.besoin.dps
		local nouveau = (p.besoin[role] or 0) + delta
		if nouveau < 0 or (delta > 0 and total >= taille) then return end
		p.besoin[role] = nouveau
		Rafraichir()
	end
	for i, role in ipairs(ROLES) do
		local c = CreerCompteurRole(creer, role, Changer)
		c:SetPoint("TOPLEFT", creer, "TOPLEFT", 20 + (i - 1) * 140, -334)
		creer.compteurs[role] = c
	end

	local t3 = creer:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t3:SetPoint("TOPLEFT", creer, "TOPLEFT", 16, -376)
	t3:SetText("Commentaire")
	local saisie = CreateFrame("EditBox", nil, creer, "InputBoxTemplate")
	saisie:SetSize(400, 22)
	saisie:SetPoint("TOPLEFT", creer, "TOPLEFT", 24, -396)
	saisie:SetAutoFocus(false)
	saisie:SetMaxLetters(50)
	saisie:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	saisie:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	creer.saisie = saisie

	creer.publier = NouveauBouton(creer, "Publier le groupe", 150, 28)
	creer.publier:SetPoint("BOTTOMRIGHT", creer, "BOTTOMRIGHT", -21, 16)
	creer.publier:SetScript("OnClick", function()
		saisie:ClearFocus()
		CreerMonAnnonce(fenetre.choix, p.besoin or BesoinParDefaut(5), saisie:GetText())
	end)
	local retour = NouveauBouton(creer, "Retour", 111, 28)
	retour:SetPoint("BOTTOMLEFT", creer, "BOTTOMLEFT", 21, 16)
	retour:SetScript("OnClick", function()
		saisie:ClearFocus()
		p.etape = "categories"
		Rafraichir()
	end)

	-- « Rappel » : la guilde reçoit une bulle silencieuse toutes les 5 min tant que le groupe cherche
	local rappel = CreateFrame("CheckButton", nil, creer, "UICheckButtonTemplate")
	rappel:SetSize(22, 22)
	rappel:SetPoint("LEFT", retour, "RIGHT", 14, 0)
	local texteRappel = rappel.Text or rappel.text
	if not texteRappel then
		texteRappel = rappel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		texteRappel:SetPoint("LEFT", rappel, "RIGHT", 1, 0)
	end
	texteRappel:SetFontObject("GameFontHighlightSmall")
	texteRappel:SetText("Rappel")
	rappel:SetScript("OnShow", function(self)
		local db = DB()
		self:SetChecked(db and db.rappelGroupe and true or false)
	end)
	rappel:SetScript("OnClick", function(self)
		local db = DB()
		if db then db.rappelGroupe = self:GetChecked() and true or nil end
	end)
	rappel:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Rappel")
		GameTooltip:AddLine("Tant que ton groupe cherche du monde, la guilde reçoit une bulle de rappel (sans son) toutes les 5 minutes.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	rappel:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- écran 2 : détails (tout ce qui précède, sauf le titre et la consigne)
	local details = CreateFrame("Frame", nil, creer)
	details:SetAllPoints(creer)
	creer.details = details
	for _, element in ipairs({ t1, t1b, separation, t2, creer.taille, t3, creer.defile, saisie, creer.publier, retour, rappel }) do
		element:SetParent(details)
	end
	for _, c in pairs(creer.compteurs) do c:SetParent(details) end

	-- « Voir tous les niveaux » : sinon, seulement les contenus déjà accessibles à mon niveau
	local tous = CreateFrame("CheckButton", nil, details, "UICheckButtonTemplate")
	tous:SetSize(20, 20)
	tous:SetPoint("LEFT", t1, "RIGHT", 16, 0)
	local texteTous = tous.Text or tous.text
	if not texteTous then
		texteTous = tous:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		texteTous:SetPoint("LEFT", tous, "RIGHT", 1, 0)
	end
	texteTous:SetFontObject("GameFontHighlightSmall")
	texteTous:SetText("Voir tous les niveaux")
	tous:SetScript("OnShow", function(self)
		local db = DB()
		self:SetChecked(db and db.tousNiveaux and true or false)
	end)
	tous:SetScript("OnClick", function(self)
		local db = DB()
		if db then db.tousNiveaux = self:GetChecked() and true or nil end
		creer.defile:SetVerticalScroll(0)
		Rafraichir()
	end)
	tous:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Voir tous les niveaux")
		GameTooltip:AddLine("Décoché : seulement les contenus accessibles à ton niveau.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	tous:SetScript("OnLeave", function() GameTooltip:Hide() end)

	----------------------------------------------------------------- gestion
	local gerer = CreateFrame("Frame", nil, p)
	gerer:SetAllPoints(p)
	p.gerer = gerer

	-- bande de pierre : contenu de l'annonce
	gerer.icone = gerer:CreateTexture(nil, "ARTWORK")
	gerer.icone:SetSize(78, 48)
	gerer.icone:SetPoint("TOPLEFT", gerer, "TOPLEFT", 70, -27)
	gerer.nom = gerer:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	gerer.nom:SetPoint("TOPLEFT", gerer, "TOPLEFT", 156, -32)
	gerer.nom:SetPoint("RIGHT", gerer, "RIGHT", -150, 0) -- laisse la place au choix du rôle
	gerer.nom:SetJustifyH("LEFT")
	gerer.infos = gerer:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	gerer.infos:SetPoint("TOPLEFT", gerer.nom, "BOTTOMLEFT", 0, -6)
	gerer.entree = CreerBoutonEntree(gerer)
	gerer.entree:SetPoint("BOTTOMRIGHT", gerer.icone, "BOTTOMRIGHT", 2, -2)

	-- encart : composition
	local tc = gerer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	tc:SetPoint("TOPLEFT", gerer, "TOPLEFT", 16, -86)
	tc:SetText("Composition")
	gerer.places = CreerEmplacements(gerer, 16)
	gerer.places:SetPoint("TOPRIGHT", gerer, "TOPRIGHT", -16, -82)
	gerer.membres = {}
	for i = 1, 5 do
		local l = CreateFrame("Frame", nil, gerer)
		l:SetSize(400, 20)
		l:SetPoint("TOPLEFT", gerer, "TOPLEFT", 22, -108 - (i - 1) * 22)
		l.role = l:CreateTexture(nil, "ARTWORK")
		l.role:SetSize(18, 18)
		l.role:SetPoint("LEFT", l, "LEFT", 0, 0)
		l.nom = l:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		l.nom:SetPoint("LEFT", l.role, "RIGHT", 6, 0)
		gerer.membres[i] = l
	end
	gerer.resumeGrand = gerer:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	gerer.resumeGrand:SetPoint("TOPLEFT", gerer, "TOPLEFT", 22, -112)

	local ligne = gerer:CreateTexture(nil, "ARTWORK")
	if AtlasExiste("groupfinder-ScrollLine") then
		ligne:SetAtlas("groupfinder-ScrollLine", true)
	else
		ligne:SetColorTexture(1, 0.82, 0, 0.3)
		ligne:SetHeight(1)
	end
	ligne:SetPoint("LEFT", gerer, "TOPLEFT", 4, -222)
	ligne:SetPoint("RIGHT", gerer, "TOPRIGHT", -4, -222)

	-- encart : candidats
	local tca = gerer:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	tca:SetPoint("TOPLEFT", gerer, "TOPLEFT", 16, -230)
	tca:SetText("Candidats")
	gerer.aucun = gerer:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	gerer.aucun:SetPoint("TOP", gerer, "TOP", 0, -270)
	gerer.aucun:SetText("Pas encore de candidat.")
	gerer.candidats = {}
	gerer.decalage = 0 -- premier candidat affiché (molette sur la liste)
	local function Defiler(_, delta)
		local maxi = math.max(0, #candidats - #gerer.candidats)
		gerer.decalage = math.max(0, math.min(maxi, gerer.decalage - delta))
		if Rafraichir then Rafraichir() end
	end
	local zone = CreateFrame("Frame", nil, gerer)
	zone:SetPoint("TOPLEFT", gerer, "TOPLEFT", 10, -248)
	zone:SetSize(LARGEUR_LISTE + 20, 6 * 30)
	zone:EnableMouseWheel(true)
	zone:SetScript("OnMouseWheel", Defiler)
	gerer.plus = gerer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	gerer.plus:SetPoint("TOPRIGHT", zone, "BOTTOMRIGHT", -4, -2)
	for i = 1, 6 do
		local l = CreateFrame("Frame", nil, gerer)
		l:SetSize(LARGEUR_LISTE + 20, 28)
		l:SetPoint("TOPLEFT", gerer, "TOPLEFT", 10, -248 - (i - 1) * 30)
		l:EnableMouseWheel(true)
		l:SetScript("OnMouseWheel", Defiler)
		l.fond = l:CreateTexture(nil, "BACKGROUND")
		l.fond:SetAllPoints(l)
		PoserAtlas(l.fond, "groupfinder-highlightbar", { 0.15, 0.13, 0.1, 0.8 })
		l.role = l:CreateTexture(nil, "ARTWORK")
		l.role:SetSize(20, 20)
		l.role:SetPoint("LEFT", l, "LEFT", 6, 0)
		l.classe = l:CreateTexture(nil, "ARTWORK")
		l.classe:SetSize(16, 16)
		l.classe:SetPoint("LEFT", l.role, "RIGHT", 4, 0)
		l.nom = l:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		l.nom:SetPoint("LEFT", l.classe, "RIGHT", 4, 0)
		l.inviter = NouveauBouton(l, "Inviter", 76, 22)
		l.inviter:SetPoint("RIGHT", l, "RIGHT", -84, 0)
		l.refuser = NouveauBouton(l, "Refuser", 76, 22)
		l.refuser:SetPoint("RIGHT", l, "RIGHT", -4, 0)
		gerer.candidats[i] = l
	end

	-- commentaire sous les infos (la bande du bas sert aux boutons)
	gerer.commentaire = gerer:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	gerer.commentaire:SetPoint("TOPLEFT", gerer.infos, "BOTTOMLEFT", 0, -3)
	gerer.commentaire:SetPoint("RIGHT", gerer, "RIGHT", -150, 0)
	gerer.commentaire:SetJustifyH("LEFT")
	gerer.commentaire:SetWordWrap(false)
	-- bande du bas : [Style ▾] [Rendre public] [Retirer l'annonce]
	gerer.fermer = NouveauBouton(gerer, "Retirer l'annonce", 150, 28)
	gerer.fermer:SetPoint("BOTTOMRIGHT", gerer, "BOTTOMRIGHT", -21, 16)
	if ns.CreerBoutonsPublic then
		gerer.public = ns.CreerBoutonsPublic(gerer)
		gerer.public.public:SetPoint("RIGHT", gerer.fermer, "LEFT", -4, 0)
		gerer.public.style:SetPoint("RIGHT", gerer.public.public, "LEFT", -4, 0)
	end
	gerer.fermer:SetScript("OnClick", function() FermerMonAnnonce("retirée par toi") end)
	return p
end

local function RafraichirCreation(p)
	local creer = p.creer
	local cat = Catalogue()

	local enDetails = p.etape == "details" and p.categorieChoisie ~= nil
	creer.ecranCategories:SetShown(not enDetails)
	creer.details:SetShown(enDetails)

	if not enDetails then
		-- écran 1 : grands boutons de catégorie empilés et centrés, à leur taille réelle
		creer.titre:SetText("Créer un groupe")
		creer.consigne:SetText(not IsInGuild() and "|cffff6666Tu n'es pas dans une guilde.|r"
			or (not PeutAnnoncer() and "|cffff6666Seul le chef du groupe peut publier.|r"
			or "Choisis une catégorie."))
		local _, h = TailleBoutonCategorie()
		for i, c in ipairs(categories) do
			local b = creer.boutonsCategories[i]
			if not b then
				b = CreerBoutonCategorie(creer.ecranCategories)
				creer.boutonsCategories[i] = b
			end
			b:ClearAllPoints()
			b:SetPoint("TOP", creer.ecranCategories, "TOP", -2, LIGNE_HAUT - 8 - (i - 1) * (h + 6))
			if not PoserAtlas(b.icone, c.atlas) then PoserAtlas(b.icone, ATLAS_DEFAUT, { 0.2, 0.2, 0.2, 1 }) end
			b.texte:SetText(c.nom)
			b:SetScript("OnClick", function()
				if p.categorieChoisie ~= c.id then
					p.categorieChoisie = c.id
					fenetre.choix = nil
					creer.defile:SetVerticalScroll(0)
				end
				p.etape = "details"
				Rafraichir()
			end)
			b:Show()
		end
		for i = #categories + 1, #creer.boutonsCategories do creer.boutonsCategories[i]:Hide() end
		return
	end

	-- écran 2 : titre = catégorie choisie
	for _, c in ipairs(categories) do
		if c.id == p.categorieChoisie then creer.titre:SetText(c.nom) end
	end

	-- contenus de la catégorie
	local nb = 0
	for _, e in ipairs(cat) do
		-- contenus accessibles à mon niveau (sauf si « Voir tous les niveaux » est coché)
		local dbN = DB()
		local accessible = (dbN and dbN.tousNiveaux) or (e.min or 0) <= (UnitLevel("player") or 0)
		if e.idCategorie == p.categorieChoisie and accessible then
			nb = nb + 1
			local b = creer.lignes[nb]
			if not b then
				b = CreerLigneActivite(creer.liste)
				creer.lignes[nb] = b
			end
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", creer.liste, "TOPLEFT", 0, -(nb - 1) * HAUTEUR_ACTIVITE)
			-- petite icône seulement si c'est une vraie icône de donjon (pas l'image de catégorie)
			b.nom:ClearAllPoints()
			MajBoutonEntree(b.entree, e)
			local gauche = b.entree:IsShown() and 26 or 4  -- place du bouton carte
			b.icone:ClearAllPoints()
			b.icone:SetPoint("LEFT", b, "LEFT", gauche, 0)
			if e.icone and e.icone.fichier then
				PoserIcone(b.icone, e.icone)
				b.icone:Show()
				b.nom:SetPoint("LEFT", b.icone, "RIGHT", 6, 0)
			else
				b.icone:Hide()
				b.nom:SetPoint("LEFT", b, "LEFT", gauche + 6, 0)
			end
			b.nom:SetPoint("RIGHT", b, "RIGHT", -130, 0)
			b.nom:SetText(e.nom)
			b.infos:SetText(("%s%s|r  ·  %d j."):format(CouleurNiveau(e), TexteNiveaux(e), e.taille or 5))
			b.choisi:SetShown(fenetre.choix == e.code)
			b:SetScript("OnClick", function()
				if fenetre.choix ~= e.code then
					fenetre.choix = e.code
					p.besoin = BesoinParDefaut(e.taille or 5)
				end
				Rafraichir()
			end)
			b:Show()
		end
	end
	for i = nb + 1, #creer.lignes do creer.lignes[i]:Hide() end
	creer.liste:SetHeight(math.max(10, nb * HAUTEUR_ACTIVITE))

	-- composition
	local e = fenetre.choix and InfoContenu(fenetre.choix)
	local taille = TailleMaxContenu(e)
	if not p.besoin then p.besoin = BesoinParDefaut(e and e.taille or 5) end
	local total = p.besoin.tank + p.besoin.heal + p.besoin.dps
	for _, role in ipairs(ROLES) do
		local c = creer.compteurs[role]
		c.valeur:SetText(p.besoin[role])
		c.moins:SetEnabled(p.besoin[role] > 0)
		c.plus:SetEnabled(total < taille)
	end
	if EstPerso(e) then
		creer.taille:SetText(("%d place(s) (jusqu'à %d)"):format(total, taille))
	else
		creer.taille:SetText(("%d place(s) sur %d"):format(total, taille))
	end

	local possible = IsInGuild() and PeutAnnoncer() and fenetre.choix ~= nil and total > 0
	creer.publier:SetEnabled(possible)
	if not IsInGuild() then
		creer.consigne:SetText("|cffff6666Tu n'es pas dans une guilde.|r")
	elseif not PeutAnnoncer() then
		creer.consigne:SetText("|cffff6666Seul le chef du groupe peut publier.|r")
	elseif not fenetre.choix then
		creer.consigne:SetText("Choisis un contenu dans la liste.")
	else
		creer.consigne:SetText("Contenu : |cffffd100" .. (e and e.nom or "?") .. "|r")
	end
end

local function RafraichirGestion(p)
	local g = p.gerer
	local e = InfoContenu(monAnnonce.code)
	PoserIcone(g.icone, e.icone)
	g.nom:SetText(e.nom)
	g.infos:SetText(("%d/%d joueurs  ·  %s%s|r"):format(NombreMembres(), monAnnonce.taille, CouleurNiveau(e), TexteNiveaux(e)))
	g.commentaire:SetText(monAnnonce.commentaire ~= "" and ("« " .. monAnnonce.commentaire .. " »") or "")
	if g.public then g.public.maj(monAnnonce, e.nom) end

	local pris, membres = Composition(monAnnonce.besoin)
	RangerEmplacements(g.places)
	MajEmplacements(g.places, monAnnonce.besoin, pris, monAnnonce.taille)
	MajBoutonEntree(g.entree, e)

	-- une ligne par place façon FF14 (groupes de 5)
	if monAnnonce.taille <= 5 then
		g.resumeGrand:Hide()
		local lignes, restants = {}, {}
		for _, m in ipairs(membres) do restants[#restants + 1] = m end
		for _, role in ipairs(ROLES) do
			for _ = 1, monAnnonce.besoin[role] or 0 do
				local occupant
				for k, m in ipairs(restants) do
					if m.role == role then occupant = table.remove(restants, k); break end
				end
				lignes[#lignes + 1] = { role = role, membre = occupant }
			end
		end
		for _, l in ipairs(lignes) do
			if not l.membre and #restants > 0 then l.membre = table.remove(restants, 1) end
		end
		for i, l in ipairs(g.membres) do
			local d = lignes[i]
			if d then
				IconeRole(l.role, d.role, d.membre ~= nil)
				if d.membre then
					l.nom:SetText(d.membre.nom .. (d.membre.role and "" or "  |cff999999(rôle inconnu)|r"))
				else
					l.nom:SetText("|cff777777— place libre —|r")
				end
				l:Show()
			else
				l:Hide()
			end
		end
	else
		for _, l in ipairs(g.membres) do l:Hide() end
		g.resumeGrand:SetText(("%s %d/%d    %s %d/%d    %s %d/%d"):format(
			TexteRole("tank"), pris.tank, monAnnonce.besoin.tank, TexteRole("heal"), pris.heal, monAnnonce.besoin.heal,
			TexteRole("dps"), pris.dps, monAnnonce.besoin.dps))
		g.resumeGrand:Show()
	end

	g.aucun:SetShown(#candidats == 0)
	g.decalage = math.max(0, math.min(g.decalage or 0, #candidats - #g.candidats))
	local caches = #candidats - #g.candidats
	g.plus:SetText(caches > 0 and ("%d-%d sur %d candidats (molette)"):format(g.decalage + 1,
		g.decalage + #g.candidats, #candidats) or "")
	for i, l in ipairs(g.candidats) do
		local cd = candidats[i + g.decalage]
		if cd then
			IconeRole(l.role, cd.role, true)
			IconeClasse(l.classe, cd.classe)
			local plein = cd.role and monAnnonce.besoin[cd.role] and (pris[cd.role] or 0) >= monAnnonce.besoin[cd.role]
			l.nom:SetText(("%s%s|r (%d)%s%s"):format(CouleurClasse(cd.classe), NomCourt(cd.nom), cd.niveau or 0,
				cd.statut == "invite" and "  |cff999999invité|r" or "",
				plein and "  |cffff6666rôle déjà pris|r" or ""))
			l.inviter:SetScript("OnClick", function() Inviter(cd.nom) end)
			l.refuser:SetScript("OnClick", function() Refuser(cd.nom) end)
			-- invitation sans réponse (déclinée, échouée) : on peut réinviter après quelques secondes
			l.inviter:SetText(cd.statut == "invite" and "Réinviter" or "Inviter")
			l.inviter:SetEnabled(cd.statut ~= "invite" or GetTime() - (cd.invite or 0) > 10)
			l:Show()
		else
			l:Hide()
		end
	end
end

--------------------------------------------------------------------------------
-- Assemblage
--------------------------------------------------------------------------------

local function ChoisirOnglet(i)
	if not fenetre then return end
	fenetre.onglet = i
	MarquerOnglet(fenetre, i)
	fenetre.pageParcourir:SetShown(i == 1)
	fenetre.pageMonGroupe:SetShown(i == 2)
	Rafraichir()
end

local function CreerFenetre()
	local f = CreerCadrePrincipal()
	f.pageParcourir = CreerPageParcourir(f, function() ChoisirOnglet(2) end)
	f.pageMonGroupe = CreerPageMonGroupe(f)
	CreerOnglets(f, { "Parcourir", "Mon groupe" }, ChoisirOnglet)
	-- quêtes en commun, accrochées à droite (GuildUp_Quetes.lua)
	if ns.CreerPanneauQuetes then
		f.quetes = ns.CreerPanneauQuetes(f)
		-- l'ensemble (groupes + quêtes) reste centré à l'écran
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", -165, 0)
	end
	f.onglet = 1
	f:SetScript("OnShow", function() ChoisirOnglet(f.onglet or 1) end)
	f:Hide()
	return f
end

-- Nombre de groupes de la guilde qui cherchent encore du monde (hors le mien)
local function NombreGroupes()
	local n = 0
	for id, a in pairs(annonces) do
		if not (monAnnonce and id == monAnnonce.id) and (a.membres or 1) < (a.taille or 5) then n = n + 1 end
	end
	return n
end
ns.NombreGroupes = NombreGroupes

-- Suis-je en attente ? (mon annonce ouverte, une candidature envoyée, ou mon groupe public)
ns.EnAttente = function()
	if monAnnonce then return true end
	for _, etat in pairs(candidatures) do
		if etat == "envoyee" then return true end
	end
	if C_LFGList and C_LFGList.HasActiveEntryInfo then
		local ok, oui = pcall(C_LFGList.HasActiveEntryInfo)
		if ok and oui then return true end
	end
	return false
end

Rafraichir = function()
	-- compteur sur le bouton de la mini-carte, même fenêtre fermée
	if ns.MajBoutonCarte then ns.MajBoutonCarte() end
	if not fenetre or not fenetre:IsShown() then return end
	local n = 0
	for id in pairs(annonces) do
		if not (monAnnonce and id == monAnnonce.id) then n = n + 1 end
	end
	if fenetre.onglets then
		fenetre.onglets[1]:SetText(n > 0 and ("Parcourir (" .. n .. ")") or "Parcourir")
		fenetre.onglets[2]:SetText((monAnnonce and #candidats > 0) and ("Mon groupe (" .. #candidats .. ")") or "Mon groupe")
		for _, o in ipairs(fenetre.onglets) do
			if PanelTemplates_TabResize then pcall(PanelTemplates_TabResize, o, 0) end
		end
	end
	for _, w in ipairs(choixRoles) do MajChoixRole(w) end
	if fenetre.onglet == 1 then
		RafraichirParcourir(fenetre.pageParcourir)
	else
		local p = fenetre.pageMonGroupe
		p.creer:SetShown(monAnnonce == nil)
		p.gerer:SetShown(monAnnonce ~= nil)
		if monAnnonce then RafraichirGestion(p) else RafraichirCreation(p) end
	end
end

ns.BasculerGroupes = function()
	fenetre = fenetre or (ns.AvecSons and ns.AvecSons(CreerFenetre(), "fenetre")) or CreerFenetre()
	fenetre:SetShown(not fenetre:IsShown())
end

-- Test seul activé / coupé : on montre ou on retire la copie « test » de mon annonce
ns.SurChangementTestSolo = function()
	if ns.TestSolo and ns.TestSolo() then
		if monAnnonce then DiffuserMonAnnonce() end
	else
		for id in pairs(annonces) do
			if id:find("^test:") then annonces[id] = nil; candidatures[id] = nil end
		end
	end
	Rafraichir()
end

-- Ouvre la fenêtre sur « Parcourir » (clic sur la bulle d'alerte)
ns.OuvrirGroupes = function()
	fenetre = fenetre or (ns.AvecSons and ns.AvecSons(CreerFenetre(), "fenetre")) or CreerFenetre()
	fenetre.onglet = 1
	if fenetre:IsShown() then ChoisirOnglet(1) else fenetre:Show() end
end

-- Pour /smb diag
ns.DiagGroupes = function(L)
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
	local okF, nomF, royaumeF = pcall(UnitFullName, "player")
	local okG, nomG = pcall(GetUnitName, "player", true)
	L(("  noms : UnitName=%s, UnitFullName=%s-%s, GetUnitName=%s, normalisé=%s, reçu du serveur=%s"):format(
		tostring(UnitName("player")), tostring(okF and nomF), tostring(okF and royaumeF), tostring(okG and nomG),
		tostring(MonNom()), tostring(dernierNomRecuDeMoi or "pas encore (publie une annonce pour le voir)")))
	local atlas = {}
	for _, a in ipairs({ "groupfinder-icon-role-large-tank", "groupfinder-icon-role-large-heal", "groupfinder-icon-role-large-dps",
		"groupfinder-highlightbar", "groupfinder-Stat-StoneBG", "groupfinder-button-dungeons", "groupfinder-icon-leader" }) do
		atlas[#atlas + 1] = a .. "=" .. tostring(AtlasExiste(a))
	end
	L("  atlas : " .. table.concat(atlas, ", "))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

do
	local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
	if inscription then pcall(inscription, PREFIXE) end
end

local premiereEntree = true
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:RegisterEvent("GROUP_ROSTER_UPDATE")
ev:RegisterEvent("PLAYER_GUILD_UPDATE")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "CHAT_MSG_ADDON" then
		Recevoir(a1, a2, a3, a4)
	elseif event == "GROUP_ROSTER_UPDATE" then
		SurChangementDeGroupe()
	elseif event == "PLAYER_LEVEL_UP" then
		C_Timer.After(0.5, Rafraichir)
	elseif event == "PLAYER_GUILD_UPDATE" then
		if not IsInGuild() then
			FermerMonAnnonce("plus de guilde")
			annonces = {}
		end
		Rafraichir()
	elseif event == "PLAYER_ENTERING_WORLD" and premiereEntree then
		premiereEntree = false
		finCalme = GetTime() + 25
		C_Timer.After(10, function() Envoyer("Q", "GUILD") end)
		C_Timer.NewTicker(15, Entretien)
	end
end)
