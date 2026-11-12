-- GuildUpSMB : recherche de groupe réservée à la guilde.
-- Style de la recherche de groupe officielle de Forever (cadre à portrait, onglets, barres de
-- groupe, boutons de catégorie), avec un affichage des places par rôle façon FF14 : chaque
-- groupe montre ses emplacements Tank / Heal / DPS, pris ou libres.
--
-- Messages d'addon invisibles :
--   canal GUILD  : "A~..." annonce (ou mise à jour), "F~id" fin d'annonce, "Q" demande des annonces
--   chuchotement : "P~id~role~classe~niveau" candidature, "X~id" candidature annulée,
--                  "R~id~non" candidature refusée
-- Annonce : A~id~code~besoinT~besoinH~besoinD~prisT~prisH~prisD~taille~membres~niveau~classe~commentaire~liste~rappel
--   (id = « clé du chef:date » ; rappel = « 1 » si le chef veut une bulle de rappel toutes les 5 min)
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

-- Catalogue des contenus (GuildUp_Catalogue.lua, chargé avant)
local CG = ns.CatalogueGroupes
local Catalogue, InfoContenu, EstPerso, TailleMaxContenu, TexteNiveaux, CouleurNiveau, Categories, ATLAS_DEFAUT =
	CG.Catalogue, CG.InfoContenu, CG.EstPerso, CG.TailleMaxContenu, CG.TexteNiveaux, CG.CouleurNiveau, CG.Categories,
	CG.ATLAS_DEFAUT

-- État partagé avec la fenêtre (GuildUp_GroupesFenetre.lua)
local etat = {
	annonces = {},       -- [id] = annonce reçue (voir Recevoir)
	candidatures = {},   -- [id] = "envoyee" | "refusee"  (mes candidatures)
	monAnnonce = nil,    -- { id, code, besoin = {tank,heal,dps}, taille, commentaire } ou nil
	candidats = {},      -- liste ordonnée : { nom, role, classe, niveau, statut }
	fenetre = nil,       -- fenêtre des groupes (créée par GuildUp_GroupesFenetre.lua)
	dernierNomRecuDeMoi = nil, -- pour /smb diag : comment le serveur écrit mon nom dans les messages
}
-- rafraîchit la fenêtre des groupes (définie dans GuildUp_GroupesFenetre.lua)
local function Rafraichir() if ns.RafraichirGroupes then ns.RafraichirGroupes() end end

local function Message(texte)
	print("|cff3399ffSMB Forever|r : " .. texte)
end

local function DB() return ns.DB and ns.DB() end

--------------------------------------------------------------------------------
-- Outils
--------------------------------------------------------------------------------

-- Sur Forever, les noms arrivent sous la forme « Miko Banko » (nom + royaume séparés par un
-- espace). On garde le nom tel que reçu pour chuchoter / inviter, et on compare des noms
-- normalisés « Nom-Royaume » (ns.Normaliser, défini dans GuildUp.lua).
local Normaliser = ns.Normaliser

local function MonNom()
	return Normaliser(UnitName("player"))
end

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

local function Prenom(nom)
	return (NomCourt(nom) or "?"):match("^(%S+)") or nom
end

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

local function Envoyer(msg, canal, cible) ns.EnvoyerAddon(PREFIXE, msg, canal or "GUILD", cible) end

local CouleurClasse = ns.CouleurClasseTexte

local NOMS_ROLES = ns.NOMS_ROLES
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

local AtlasExiste = ns.AtlasExiste

local PoserAtlas = ns.PoserAtlas

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
local rediffusionPrevue = false

local function SignatureComposition()
	if not etat.monAnnonce then return "" end
	local pris, membres = Composition(etat.monAnnonce.besoin)
	return ("%d%d%d%d"):format(pris.tank, pris.heal, pris.dps, #membres), pris, membres
end

local function DiffuserMonAnnonce()
	if not etat.monAnnonce then return end
	local signature, pris, membres = SignatureComposition()
	local liste = {}
	if etat.monAnnonce.taille <= 5 then
		for _, m in ipairs(membres) do
			liste[#liste + 1] = NomCourt(m.nom) .. "." .. (LETTRES_ROLES[m.role] or "?")
		end
	end
	local _, classe = UnitClass("player")
	etat.monAnnonce.vu = GetTime()
	dernierEnvoi = GetTime()
	derniereSignature = signature
	local b = etat.monAnnonce.besoin
	local function Construire(commentaire, membresTexte)
		return table.concat({
			"A", etat.monAnnonce.id, etat.monAnnonce.code, b.tank, b.heal, b.dps, pris.tank, pris.heal, pris.dps,
			etat.monAnnonce.taille, #membres, UnitLevel("player") or 0, classe or "", commentaire,
			membresTexte, etat.monAnnonce.rappel and "1" or "",
		}, SEP)
	end
	local max = ns.LONGUEUR_MAX or 255
	local msg = Construire(etat.monAnnonce.commentaire, table.concat(liste, ","))
	-- trop long (noms longs ou accentués) : sans la liste des membres, puis commentaire raccourci
	if #msg > max then msg = Construire(etat.monAnnonce.commentaire, "") end
	if #msg > max and ns.CouperUTF8 then
		local place = #etat.monAnnonce.commentaire - (#msg - max)
		msg = Construire(ns.CouperUTF8(etat.monAnnonce.commentaire, math.max(0, place)), "")
	end
	Envoyer(msg, "GUILD")
end

local function FermerMonAnnonce(raison)
	if not etat.monAnnonce then return end
	if raison then (ns.Erreur or Message)("Annonce de groupe fermée : " .. raison) end
	if ns.RetirerPublic then ns.RetirerPublic() end -- l'annonce publique (recherche du jeu) part avec
	Envoyer("F" .. SEP .. etat.monAnnonce.id, "GUILD")
	for _, c in ipairs(etat.candidats) do
		if c.statut == "attente" then
			Envoyer("R" .. SEP .. etat.monAnnonce.id .. SEP .. "non", "WHISPER", c.nom)
		end
	end
	etat.monAnnonce = nil
	etat.candidats = {}
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
	etat.monAnnonce = {
		id = MonNom() .. ":" .. (GetServerTime and GetServerTime() or math.floor(GetTime())),
		code = code,
		besoin = { tank = besoin.tank, heal = besoin.heal, dps = besoin.dps },
		taille = EstPerso(e) and math.max(1, besoin.tank + besoin.heal + besoin.dps)
			or math.min(e.taille or 5, math.max(1, besoin.tank + besoin.heal + besoin.dps)),
		commentaire = Nettoyer(commentaire, 50),
		rappel = DB() and DB().rappelGroupe and true or false,
	}
	etat.candidats = {}
	DiffuserMonAnnonce()
	if Rafraichir then Rafraichir() end
end

-- Groupe pour une quête : annonce « Quête : titre », zone en commentaire, places 1 / 1 / 3
ns.CreerGroupeQuete = function(id, titre, zone)
	if etat.monAnnonce then
		local erreur = ns.Erreur or Message
		erreur("Tu as déjà une annonce de groupe : retire-la d'abord (onglet Mon groupe)")
		if ns.OuvrirGroupes then ns.OuvrirGroupes() end
		return
	end
	local commentaire = zone and zone ~= "" and zone or (titre or "")
	CreerMonAnnonce("q" .. id, BesoinParDefaut(5), commentaire)
	if etat.monAnnonce and ns.OuvrirGroupes then ns.OuvrirGroupes() end
end

local function TrouverCandidat(nom)
	for i, c in ipairs(etat.candidats) do
		if c.nom == nom then return c, i end
	end
end

local function Inviter(nom)
	local c = TrouverCandidat(nom)
	if not c then return end
	-- plus de 5 joueurs prévus : on passe en raid avant que le groupe soit plein
	if etat.monAnnonce and (etat.monAnnonce.taille or 5) > 5 and not IsInRaid() and GetNumGroupMembers() >= 4 then
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
	if not c or not etat.monAnnonce then return end
	Envoyer("R" .. SEP .. etat.monAnnonce.id .. SEP .. "non", "WHISPER", nom)
	table.remove(etat.candidats, i)
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
	local a = etat.annonces[id]
	if not a then return end
	local _, classe = UnitClass("player")
	local role = (ns.MonRole and ns.MonRole()) or "?"
	Envoyer(table.concat({ "P", id, role, classe or "", UnitLevel("player") or 0 }, SEP), "WHISPER", a.chef)
	etat.candidatures[id] = "envoyee"
	if Rafraichir then Rafraichir() end
end

local function AnnulerCandidature(id)
	local a = etat.annonces[id]
	if a then Envoyer("X" .. SEP .. id, "WHISPER", a.chef) end
	etat.candidatures[id] = nil
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
		etat.dernierNomRecuDeMoi = expediteur
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

	-- l'identifiant d'une annonce commence par la clé de son chef (« Nom-Royaume:date ») : seul le
	-- chef peut la publier ou la fermer
	local function DuChef(id)
		return deMoi or (id and id:match("^(.+):%d+$") == Normaliser(expediteur))
	end
	-- nombre reçu, borné (un message forgé ne fige pas le jeu avec une boucle d'un milliard de tours)
	local function Borne(v, mini, maxi, defaut)
		v = tonumber(v)
		if not v then return defaut end
		return math.max(mini, math.min(maxi, math.floor(v)))
	end

	if type_ == "A" and canal == "GUILD" then
		local id = p[2]
		if not id or not DuChef(id) then return end
		local ancienne = etat.annonces[id]
		local membres = {}
		for _, m in ipairs(p[15] and p[15] ~= "" and Decouper(p[15], ",") or {}) do
			local nom, lettre = m:match("^(.-)%.(.)$")
			if nom then membres[#membres + 1] = { nom = nom, role = ROLES_LETTRES[lettre] } end
		end
		etat.annonces[id] = {
			id = id, chef = expediteur,
			premiere = ancienne and ancienne.premiere or GetTime(),
			code = p[3] or "",
			besoin = { tank = Borne(p[4], 0, 40, 0), heal = Borne(p[5], 0, 40, 0), dps = Borne(p[6], 0, 40, 0) },
			pris = { tank = Borne(p[7], 0, 40, 0), heal = Borne(p[8], 0, 40, 0), dps = Borne(p[9], 0, 40, 0) },
			taille = Borne(p[10], 1, 40, 5), membres = Borne(p[11], 1, 40, 1),
			niveau = Borne(p[12], 0, 100, 0), classe = p[13] ~= "" and p[13] or nil,
			commentaire = p[14] or "", liste = membres,
			rappel = p[16] == "1",
			prochainRappel = ancienne and ancienne.prochainRappel,
			vu = GetTime(),
		}
		if not ancienne then
			local nomContenu = InfoContenu(etat.annonces[id].code).nom
			-- bulle + son discret à côté du médaillon GuildUpSMB (pas pendant le calme de connexion :
			-- les groupes déjà ouverts arrivent tous d'un coup et ne sont pas « nouveaux »)
			local idQuete = tonumber((etat.annonces[id].code or ""):match("^q(%d+)$"))
			if GetTime() <= finCalme then
				-- calme de connexion : pas de bulle
			elseif idQuete then
				-- groupe de quête : seulement les membres qui ont cette quête sont prévenus
				if ns.AQuete and ns.AQuete(idQuete) and ns.Notifier then
					local titre = ns.InfoQuete and ns.InfoQuete(idQuete) or "?"
					local zone = etat.annonces[id].commentaire ~= "" and (" (" .. etat.annonces[id].commentaire .. ")") or ""
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
		if id and etat.annonces[id] and DuChef(id) then
			etat.annonces[id] = nil
			etat.candidatures[id] = nil
			if Rafraichir then Rafraichir() end
		end

	elseif type_ == "Q" then
		-- au plus une rediffusion toutes les 5 s, quel que soit le nombre de « Q »
		if etat.monAnnonce and GetTime() - dernierEnvoi > 5 and not rediffusionPrevue then
			rediffusionPrevue = true
			C_Timer.After(math.random() * 4, function()
				rediffusionPrevue = false
				DiffuserMonAnnonce()
			end)
		end

	elseif type_ == "P" then
		if not etat.monAnnonce or p[2] ~= etat.monAnnonce.id then return end
		-- candidature d'un joueur hors de la guilde (chuchotement) : ignorée
		if not deMoi and ns.MembreGuilde and ns.MembreGuilde(Normaliser(expediteur)) == false then return end
		local c = TrouverCandidat(expediteur)
		if not c then
			c = { nom = expediteur }
			etat.candidats[#etat.candidats + 1] = c
		end
		c.role, c.classe, c.niveau, c.statut = p[3], p[4] ~= "" and p[4] or nil, tonumber(p[5]) or 0, "attente"
		if ns.Notifier then
			ns.Notifier("candidatures", "Nouvelle candidature", ("%s postule : %s"):format(NomCourt(expediteur), TexteRole(c.role)), "TELL_MESSAGE")
		end
		if Rafraichir then Rafraichir() end

	elseif type_ == "X" then
		local c, i = TrouverCandidat(expediteur)
		if c and etat.monAnnonce and p[2] == etat.monAnnonce.id then
			table.remove(etat.candidats, i)
			if Rafraichir then Rafraichir() end
		end

	elseif type_ == "R" then
		local id = p[2]
		-- seul le chef de l'annonce peut refuser ma candidature
		if id and etat.candidatures[id] and DuChef(id) then
			etat.candidatures[id] = "refusee"
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
	for id, a in pairs(etat.annonces) do
		local mien = etat.monAnnonce and (id == etat.monAnnonce.id or id == "test:" .. etat.monAnnonce.id)
		if a.rappel and not mien and (a.membres or 1) < (a.taille or 5) and not etat.candidatures[id] then
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
	for _, c in ipairs(etat.candidats) do
		if c.statut == "invite" and maintenant - (c.invite or 0) > DELAI_INVITATION then
			c.statut = "attente"
			change = true
		end
	end
	for id, a in pairs(etat.annonces) do
		if maintenant - a.vu > DUREE_VIE then
			etat.annonces[id] = nil
			etat.candidatures[id] = nil
			change = true
		end
	end
	if etat.monAnnonce then
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
	for id in pairs(etat.candidatures) do
		local a = etat.annonces[id]
		if a and a.chef and IsInGroup() and DansMonGroupe(a.chef) then etat.candidatures[id] = nil end
	end
	if etat.monAnnonce then
		if not PeutAnnoncer() then
			FermerMonAnnonce("tu n'es plus chef du groupe")
			return
		end
		if NombreMembres() >= etat.monAnnonce.taille then
			FermerMonAnnonce("groupe complet")
			return
		end
		for i = #etat.candidats, 1, -1 do
			if DansMonGroupe(etat.candidats[i].nom) then table.remove(etat.candidats, i) end
		end
		if GetTime() - dernierEnvoi > 5 then DiffuserMonAnnonce() end
	end
	if Rafraichir then Rafraichir() end
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir, { GUILD = true, WHISPER = true })

local premiereEntree = true
local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("GROUP_ROSTER_UPDATE")
ev:RegisterEvent("PLAYER_GUILD_UPDATE")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "GROUP_ROSTER_UPDATE" then
		SurChangementDeGroupe()
	elseif event == "PLAYER_LEVEL_UP" then
		C_Timer.After(0.5, Rafraichir)
	elseif event == "PLAYER_GUILD_UPDATE" then
		if not IsInGuild() then
			FermerMonAnnonce("plus de guilde")
			etat.annonces = {}
		end
		Rafraichir()
	elseif event == "PLAYER_ENTERING_WORLD" and premiereEntree then
		premiereEntree = false
		finCalme = GetTime() + 25
		C_Timer.After(10, function() Envoyer("Q", "GUILD") end)
		C_Timer.NewTicker(15, Entretien)
	end
end)

-- Partagé avec la fenêtre des groupes (GuildUp_GroupesFenetre.lua, chargée après)
ns.Groupes = {
	etat = etat,
	ATLAS_DEFAUT = ATLAS_DEFAUT,
	AnnulerCandidature = AnnulerCandidature,
	AtlasExiste = AtlasExiste,
	BesoinParDefaut = BesoinParDefaut,
	Catalogue = Catalogue,
	Categories = Categories,
	Composition = Composition,
	CouleurClasse = CouleurClasse,
	CouleurNiveau = CouleurNiveau,
	CreerMonAnnonce = CreerMonAnnonce,
	DB = DB,
	DiffuserMonAnnonce = DiffuserMonAnnonce,
	Envoyer = Envoyer,
	EstPerso = EstPerso,
	FermerMonAnnonce = FermerMonAnnonce,
	IconeClasse = IconeClasse,
	IconeRole = IconeRole,
	InfoContenu = InfoContenu,
	Inviter = Inviter,
	MonNom = MonNom,
	NomCourt = NomCourt,
	NombreMembres = NombreMembres,
	PeutAnnoncer = PeutAnnoncer,
	PlacesLibres = PlacesLibres,
	PoserAtlas = PoserAtlas,
	PoserIcone = PoserIcone,
	Postuler = Postuler,
	Prenom = Prenom,
	ROLES = ROLES,
	Refuser = Refuser,
	TailleMaxContenu = TailleMaxContenu,
	TexteNiveaux = TexteNiveaux,
	TexteRole = TexteRole,
}
