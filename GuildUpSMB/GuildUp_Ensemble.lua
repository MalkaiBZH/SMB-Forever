-- GuildUpSMB : « Jouer ensemble » (page de la fenêtre SMB Forever, kit ns.UI), deux onglets.
-- Maintenant : ce que je peux faire tout de suite avec la guilde, calculé avec ce que l'addon sait déjà :
--   * quêtes en commun (GuildUp_Quetes.lua, ns.QuetesEnCommun) regroupées par zone : « 3 quêtes en commun
--     en Marche de l'Ouest » avec les membres en ligne qui les ont → « Former le groupe » (invitations) ;
--   * donjons à mon niveau où des membres en ligne ont des quêtes : « Les Mortemines : il ne manque qu'un
--     soigneur » → « Monter le groupe » (invite un groupe composé selon les rôles, voir Composer) ;
--   * suites de quêtes : un membre en ligne qui a une quête de la même suite que moi, à la même étape
--     (« en est au même point que toi ») ou à une ou deux étapes près → « Chuchoter » ;
--   * membres « dispo pour grouper » proches de mon niveau (dans ma zone d'abord) → « Inviter » ;
--   * groupes ouverts de la guilde (GuildUp_Groupes.lua) qui cherchent mon rôle, ou montés pour une de mes
--     quêtes → « Postuler ».
--   Chaque suggestion a un score ; les mieux notées d'abord. Clic droit : l'ignorer jusqu'à la fin de la
--   session. À droite, « Dispo maintenant » : les membres en ligne qui ont activé « Dispo pour grouper ».
-- Donjons : chaque donjon à cinq, avec les quêtes à y faire (les miennes et celles des membres en ligne),
--   les membres qui pourraient venir par rôle, « Monter le groupe » et « Créer l'annonce » (recherche de
--   groupe de la guilde). Filtres : à mon niveau, où il y a des quêtes, tous.
-- Données : GuildUp_ObjectifsQuetes.lua (tiré de QuestieDB) : ns.DONJONS_QUETES (quêtes de chaque donjon)
--   et ns.SUITES_QUETES (suites de quêtes : première quête, étape, nombre d'étapes) ; quêtes des membres
--   reçues par GuildUp_Quetes.lua (ns.QuetesDesMembres, ns.MesQuetesEnCours).
-- Statut « Dispo pour grouper » : pour la session (remis à non à la connexion), case de la page, menu rapide
-- du médaillon et /smb dispo. Préfixe "GuildUpEns", canal GUILD :
--   "D~1" / "D~0"  je suis dispo / je ne le suis plus ; "D~1" redit toutes les 10 min tant que je le suis
--                  (un dispo sans nouvelle depuis 25 min est oublié, comme un membre hors ligne)
--   "Q"            « qui est dispo ? » (à la connexion) : les membres dispo répondent "D~1"

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpEns"
local RAPPEL = 600
local OUBLI = 1500
local MAX_SUGGESTIONS = 5
local ECART_NIVEAU = 5        -- membres dispo suggérés : au plus 5 niveaux d'écart
local MARGE_DONJON = 2        -- un donjon est « à mon niveau » de (min - 2) à max

local UI = ns.UI
local C = UI and UI.C
local NomCourt = ns.NomCourt
local Normaliser = ns.Normaliser

local monDispo = false
local dispos = {}             -- [clé] = GetTime() du dernier "D~1"
local ignorees = {}           -- [clé de suggestion] = true (session)
local cache, cacheA = nil, -10 -- suggestions calculées et quand (GetTime)

local function MaCle() return ns.MaCle and ns.MaCle() end
local function Envoyer(msg, jetable)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD", nil, jetable and { jetable = true } or nil) end
end
-- fenêtre ouverte : page et compteur du menu à jour
local function MajPage()
	cacheA = -10
	if ns.PageInterface and ns.PageInterface() and ns.MajInterface then ns.MajInterface() end
end
local function Message(texte)
	local f = ns.Coeur and ns.Coeur.Message
	if f then f(texte) end
end

--------------------------------------------------------------------------------
-- Statut « Dispo pour grouper »
--------------------------------------------------------------------------------

ns.EstDispo = function() return monDispo end
ns.BasculerDispo = function(oui)
	if oui == nil then oui = not monDispo end
	oui = oui and true or false
	if oui == monDispo then return end
	monDispo = oui
	Envoyer(oui and "D~1" or "D~0")
	Message(oui and "tu es dispo pour grouper : la guilde le voit dans « Jouer ensemble »." or "tu n'es plus dispo pour grouper.")
	MajPage()
end

local function SansTest(cle) return (cle:gsub("#test$", "")) end

-- membre en ligne d'après la liste de guilde (inconnu de la liste : on le croit en ligne)
local function EnLigne(cle)
	if cle == MaCle() then return true end
	if ns.EnLigneMembre and ns.MembreGuilde and ns.MembreGuilde(SansTest(cle)) ~= nil then
		return ns.EnLigneMembre(SansTest(cle)) and true or false
	end
	return true
end

-- membre dispo (en ligne, nouvelle reçue depuis moins de 25 min)
local function MembreDispo(cle)
	if cle == MaCle() then return monDispo end
	local t = dispos[cle]
	if not t then return false end
	if GetTime() - t > OUBLI or not EnLigne(cle) then dispos[cle] = nil; return false end
	return true
end
ns.MembreDispo = MembreDispo

local function Recevoir(prefixe, msg, canal, expediteur)
	if not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if not cle then return end
	if cle == MaCle() then
		if not (ns.TestSolo and ns.TestSolo()) then return end
		cle = cle .. "#test"
	end
	if msg == "Q" then
		if monDispo then C_Timer.After(1 + math.random() * 5, function() if monDispo then Envoyer("D~1", true) end end) end
	elseif msg == "D~1" then
		local nouveau = not dispos[cle]
		dispos[cle] = GetTime()
		if nouveau then MajPage() end
	elseif msg == "D~0" then
		if dispos[cle] then dispos[cle] = nil; MajPage() end
	end
end
ns.Ecouter(PREFIXE, Recevoir)

--------------------------------------------------------------------------------
-- Données des quêtes : donjons et suites (GuildUp_ObjectifsQuetes.lua)
--------------------------------------------------------------------------------

-- aire (numéro de zone des quêtes dans QuestieDB), carte d'instance (recherche de groupe), nom de secours,
-- niveaux conseillés
local DONJONS = {
	{ aire = 2437, carte = 389, nom = "Gouffre de Ragefeu", min = 13, max = 18 },
	{ aire = 718, carte = 43, nom = "Cavernes des Lamentations", min = 17, max = 24 },
	{ aire = 1581, carte = 36, nom = "Les Mortemines", min = 17, max = 26 },
	{ aire = 209, carte = 33, nom = "Donjon d'Ombrecroc", min = 22, max = 30 },
	{ aire = 719, carte = 48, nom = "Profondeurs de Brassenoire", min = 24, max = 32 },
	{ aire = 717, carte = 34, nom = "La Prison", min = 24, max = 32 },
	{ aire = 133, carte = 90, nom = "Gnomeregan", min = 29, max = 38 },
	{ aire = 1717, carte = 47, nom = "Kraal de Tranchebauge", min = 29, max = 38 },
	{ aire = 796, carte = 189, nom = "Monastère écarlate", min = 30, max = 45 },
	{ aire = 722, carte = 129, nom = "Souilles de Tranchebauge", min = 37, max = 46 },
	{ aire = 1517, carte = 70, nom = "Uldaman", min = 41, max = 51 },
	{ aire = 978, carte = 209, nom = "Zul'Farrak", min = 44, max = 54 },
	{ aire = 2100, carte = 349, nom = "Maraudon", min = 46, max = 55 },
	{ aire = 1417, carte = 109, nom = "Temple d'Atal'Hakkar", min = 50, max = 60 },
	{ aire = 1584, carte = 230, nom = "Profondeurs de Rochenoire", min = 52, max = 60 },
	{ aire = 1583, carte = 229, nom = "Pic Rochenoire", min = 55, max = 60 },
	{ aire = 2557, carte = 429, nom = "Hache-tripes", min = 55, max = 60 },
	{ aire = 2057, carte = 289, nom = "Scholomance", min = 58, max = 60 },
	{ aire = 2017, carte = 329, nom = "Stratholme", min = 58, max = 60 },
}

local quetesDonjons -- [aire] = { [quête] = true }
local suites        -- [quête] = { racine, etape, longueur }

local function QuetesDonjon(aire)
	if not quetesDonjons then
		quetesDonjons = {}
		for a, liste in ((ns.DONJONS_QUETES or "") .. "\n"):gmatch("(%d+)|([^\n]*)\n") do
			local t = {}
			for id in liste:gmatch("%d+") do t[tonumber(id)] = true end
			quetesDonjons[tonumber(a)] = t
		end
	end
	return quetesDonjons[aire] or {}
end

local function Suite(id)
	if not suites then
		suites = {}
		for q, r, e, l in ((ns.SUITES_QUETES or "") .. "\n"):gmatch("(%d+)|(%d+)|(%d+)|(%d+)\n") do
			suites[tonumber(q)] = { racine = tonumber(r), etape = tonumber(e), longueur = tonumber(l) }
		end
	end
	return suites[id]
end

local function NomDonjon(d)
	if d.nomJeu == nil then
		local ok, nom = pcall(function() return C_Map and C_Map.GetAreaInfo and C_Map.GetAreaInfo(d.aire) end)
		d.nomJeu = (ok and type(nom) == "string" and nom ~= "") and nom or false
	end
	return d.nomJeu or d.nom
end

-- entrée du catalogue de la recherche de groupe pour ce donjon (même carte, sinon même nom)
local function Simplifier(t) return (ns.Simplifier and ns.Simplifier(t) or (t or ""):lower()):gsub("[%s%p]", "") end
local function EntreeCatalogue(d)
	local cat = ns.Groupes and ns.Groupes.Catalogue and ns.Groupes.Catalogue() or {}
	local nom1, nom2 = Simplifier(NomDonjon(d)), Simplifier(d.nom)
	for _, e in ipairs(cat) do
		if e.mapID and e.mapID == d.carte then return e end
	end
	for _, e in ipairs(cat) do
		local n = Simplifier(e.nom)
		if n == nom1 or n == nom2 then return e end
	end
end

--------------------------------------------------------------------------------
-- Groupe, invitations
--------------------------------------------------------------------------------

local function EnGroupe() return IsInGroup and IsInGroup() or false end
local function PeutInviter()
	return not EnGroupe() or UnitIsGroupLeader("player") or (UnitIsGroupAssistant and UnitIsGroupAssistant("player")) or false
end
local function DansMonGroupe(nom)
	return EnGroupe() and ns.Groupes and ns.Groupes.DansMonGroupe and ns.Groupes.DansMonGroupe(nom) or false
end

local function Inviter(membres)
	local inviter = (C_PartyInfo and C_PartyInfo.InviteUnit) or InviteUnit
	if not inviter then return end
	for _, m in ipairs(membres) do
		local nom = (ns.NomListeGuilde and ns.NomListeGuilde(SansTest(m.cle))) or m.nom
		if nom then pcall(inviter, nom) end
	end
end

local function RosterParCle()
	local roster = {}
	for _, e in ipairs(ns.RosterGuilde and ns.RosterGuilde() or {}) do roster[e.cle] = e end
	return roster
end

-- infos d'un membre : nom, niveau, zone, classe, rôle, dispo, distance
local function Membre(roster, cle, nom)
	local e = roster[SansTest(cle)]
	local m = { cle = cle, nom = (e and e.nom) or nom or cle, niveau = e and tonumber(e.niveau), zone = e and e.zone,
		classe = e and e.classe, enLigne = EnLigne(cle) }
	m.role = ns.RoleDeNom and ns.RoleDeNom(cle)
	m.dispo = MembreDispo(cle)
	if ns.DistanceMembre then m.distance, m.unite = ns.DistanceMembre(cle) end
	return m
end

local function TexteRole(role) return (role and UI.TexteRole) and UI.TexteRole(role) or "" end
local NOMS_MANQUE = { tank = "un tank", heal = "un soigneur", dps = "un DPS" }

-- rôles déjà pris dans mon groupe (moi compris) ; rôle inconnu = DPS
local function RolesDuGroupe()
	local pris = { tank = 0, heal = 0, dps = 0 }
	local function Compter(role) role = pris[role or ""] and role or "dps"; pris[role] = pris[role] + 1 end
	Compter(ns.MonRole and ns.MonRole())
	if EnGroupe() and not (IsInRaid and IsInRaid()) then
		for i = 1, (GetNumSubgroupMembers and GetNumSubgroupMembers() or 0) do
			local nom = UnitName("party" .. i)
			local cle = nom and Normaliser(GetUnitName and GetUnitName("party" .. i, true) or nom)
			Compter(cle and ns.RoleDeNom and ns.RoleDeNom(cle))
		end
	end
	return pris
end

--------------------------------------------------------------------------------
-- Donjons : qui a des quêtes dedans, et quel groupe on pourrait monter
--------------------------------------------------------------------------------

-- Compose un groupe de cinq pour ce donjon : d'abord les membres en ligne qui y ont le plus de quêtes,
-- puis les membres dispo à son niveau ; un tank, un soigneur, trois DPS (rôle inconnu = DPS), en
-- comptant moi et mon groupe actuel. Renvoie les membres à inviter et les places qui restent.
local function Composer(d, roster, membresQuetes)
	local pris = RolesDuGroupe()
	local reste = { tank = math.max(0, 1 - pris.tank), heal = math.max(0, 1 - pris.heal), dps = math.max(0, 3 - pris.dps) }
	local candidats, vus = {}, {}
	for _, m in ipairs(membresQuetes) do
		if m.enLigne and not DansMonGroupe(m.nom) then candidats[#candidats + 1] = m; vus[m.cle] = true end
	end
	for cle in pairs(dispos) do
		if not vus[cle] and MembreDispo(cle) then
			local m = Membre(roster, cle)
			m.n = 0
			if m.niveau and m.niveau >= d.min - MARGE_DONJON and m.niveau <= d.max and not DansMonGroupe(m.nom) then
				candidats[#candidats + 1] = m
			end
		end
	end
	table.sort(candidats, function(a, b)
		if (a.n or 0) ~= (b.n or 0) then return (a.n or 0) > (b.n or 0) end
		if a.dispo ~= b.dispo then return a.dispo end
		return a.nom < b.nom
	end)
	local choisis = {}
	for _, m in ipairs(candidats) do
		local role = reste[m.role or ""] and m.role or "dps"
		if reste[role] > 0 then
			reste[role] = reste[role] - 1
			m.roleGroupe = role
			choisis[#choisis + 1] = m
		end
	end
	return choisis, reste
end

-- Tout ce qu'on sait d'un donjon pour moi : quêtes (miennes et des membres en ligne), membres, groupe possible
local function InfoDonjon(d, roster, monNiveau)
	local q = QuetesDonjon(d.aire)
	local i = { d = d, nom = NomDonjon(d), mesQuetes = 0, quetes = {}, membres = {} }
	for id in pairs(ns.MesQuetesEnCours and ns.MesQuetesEnCours() or {}) do
		if q[id] then i.mesQuetes = i.mesQuetes + 1; i.quetes[id] = true end
	end
	local maCle = MaCle()
	for cle, a in pairs(ns.QuetesDesMembres and ns.QuetesDesMembres() or {}) do
		if cle ~= maCle and type(a) == "table" and type(a.quetes) == "table" then
			local n = 0
			for id in pairs(a.quetes) do if q[id] then n = n + 1 end end
			if n > 0 then
				local m = Membre(roster, cle, a.nom)
				m.n = n
				if m.enLigne then
					for id in pairs(a.quetes) do if q[id] then i.quetes[id] = true end end
				end
				i.membres[#i.membres + 1] = m
			end
		end
	end
	table.sort(i.membres, function(a, b)
		if a.enLigne ~= b.enLigne then return a.enLigne end
		if a.n ~= b.n then return a.n > b.n end
		return a.nom < b.nom
	end)
	i.nQuetes = 0
	for _ in pairs(i.quetes) do i.nQuetes = i.nQuetes + 1 end
	i.enLigne = 0
	for _, m in ipairs(i.membres) do if m.enLigne then i.enLigne = i.enLigne + 1 end end
	i.aMonNiveau = monNiveau >= d.min - MARGE_DONJON and monNiveau <= d.max
	i.choisis, i.reste = Composer(d, roster, i.membres)
	i.manque = i.reste.tank + i.reste.heal + i.reste.dps
	return i
end

local function InfosDonjons()
	local roster = RosterParCle()
	local monNiveau = UnitLevel("player") or 0
	local l = {}
	for _, d in ipairs(DONJONS) do l[#l + 1] = InfoDonjon(d, roster, monNiveau) end
	return l
end

local function MonterGroupe(i)
	if #i.choisis > 0 then Inviter(i.choisis) end
end

local function CreerAnnonce(i)
	local e = EntreeCatalogue(i.d)
	if not (e and ns.Groupes and ns.Groupes.CreerMonAnnonce) then
		if ns.Erreur then ns.Erreur("Ce donjon n'est pas dans la recherche de groupe du jeu") end
		return
	end
	local besoin = ns.Groupes.BesoinParDefaut and ns.Groupes.BesoinParDefaut(e.taille or 5) or { tank = 1, heal = 1, dps = 3 }
	local commentaire = i.nQuetes > 0 and (i.nQuetes .. " quête" .. (i.nQuetes > 1 and "s" or "") .. " à faire") or ""
	ns.Groupes.CreerMonAnnonce(e.code, besoin, commentaire)
	if ns.OuvrirGroupes then ns.OuvrirGroupes() end
end

--------------------------------------------------------------------------------
-- Suggestions
--------------------------------------------------------------------------------

local function Calculer()
	local res = {}
	local roster = RosterParCle()
	local maCle = MaCle()
	local monNiveau = UnitLevel("player") or 0
	local maZone = (GetRealZoneText and GetRealZoneText()) or ""
	local monRole = ns.MonRole and ns.MonRole()
	local dejaSuggeres = {}

	-- 1. quêtes en commun, par zone (membres en ligne, pas déjà dans mon groupe)
	local zones = {}
	for _, q in ipairs(ns.QuetesEnCommun and ns.QuetesEnCommun() or {}) do
		local z = (q.zone and q.zone ~= "") and q.zone or "?"
		for _, m in ipairs(q.membres or {}) do
			if m.enLigne and not m.groupe then
				local zz = zones[z]
				if not zz then zz = { quetes = {}, nQuetes = 0, membres = {} }; zones[z] = zz end
				if not zz.quetes[q.id] then zz.quetes[q.id] = q.titre; zz.nQuetes = zz.nQuetes + 1 end
				local mm = zz.membres[m.cle]
				if not mm then mm = Membre(roster, m.cle, m.nom); mm.n = 0; zz.membres[m.cle] = mm end
				mm.n = mm.n + 1
			end
		end
	end
	for z, zz in pairs(zones) do
		local membres = {}
		for _, m in pairs(zz.membres) do membres[#membres + 1] = m end
		table.sort(membres, function(a, b)
			if a.n ~= b.n then return a.n > b.n end
			if a.dispo ~= b.dispo then return a.dispo end
			return (a.distance or 1e9) < (b.distance or 1e9)
		end)
		while #membres > 4 do table.remove(membres) end
		local titres = {}
		for _, t in pairs(zz.quetes) do titres[#titres + 1] = t end
		table.sort(titres)
		local sous = table.concat(titres, " · ", 1, math.min(3, #titres)) .. (#titres > 3 and " · …" or "")
		local score = zz.nQuetes * 10 + #membres * 5 + (z == maZone and 15 or 0)
		for _, m in ipairs(membres) do
			if m.dispo then score = score + 8 end
			dejaSuggeres[m.cle] = true
		end
		res[#res + 1] = { cle = "z:" .. z, genre = "quetes", score = score, membres = membres,
			titre = ("%d quête%s en commun %s %s"):format(zz.nQuetes, zz.nQuetes > 1 and "s" or "", z == "?" and "avec" or "en", z == "?" and "la guilde" or z),
			sous = sous, bouton = EnGroupe() and "Inviter" or "Former le groupe",
			actif = PeutInviter(), action = function(s) Inviter(s.membres) end }
	end

	-- 2. donjons à mon niveau où des membres en ligne ont des quêtes
	for _, i in ipairs(InfosDonjons()) do
		if i.aMonNiveau and i.enLigne > 0 and i.nQuetes >= 2 and #i.choisis > 0 then
			local titre
			if i.manque == 0 then
				titre = ("%s : le groupe est au complet"):format(i.nom)
			elseif i.manque == 1 then
				local role = (i.reste.tank > 0 and "tank") or (i.reste.heal > 0 and "heal") or "dps"
				titre = ("%s : il ne manque qu'%s"):format(i.nom, NOMS_MANQUE[role])
			else
				titre = ("%s : %d membre%s y %s des quêtes"):format(i.nom, i.enLigne, i.enLigne > 1 and "s" or "", i.enLigne > 1 and "ont" or "a")
			end
			res[#res + 1] = { cle = "j:" .. i.d.aire, genre = "donjon", icone = (EntreeCatalogue(i.d) or {}).icone,
				score = 15 + i.nQuetes * 4 + #i.choisis * 4 + (i.manque == 0 and 15 or (i.manque == 1 and 8 or 0)),
				membres = i.choisis, titre = titre,
				sous = ("niveaux %d–%d · %d quête%s dedans%s"):format(i.d.min, i.d.max, i.nQuetes, i.nQuetes > 1 and "s" or "",
					i.mesQuetes > 0 and (" · toi : " .. i.mesQuetes) or ""),
				bouton = "Monter le groupe", actif = PeutInviter(), action = function() MonterGroupe(i) end }
		end
	end

	-- 3. suites de quêtes : un membre en ligne sur la même suite que moi (même étape ou presque)
	local mesSuites = {}
	for id, q in pairs(ns.MesQuetesEnCours and ns.MesQuetesEnCours() or {}) do
		local s = Suite(id)
		if s and (not mesSuites[s.racine] or s.etape > mesSuites[s.racine].etape) then
			mesSuites[s.racine] = { id = id, etape = s.etape, longueur = s.longueur, titre = type(q) == "table" and q.titre or "?" }
		end
	end
	if next(mesSuites) then
		for cle, a in pairs(ns.QuetesDesMembres and ns.QuetesDesMembres() or {}) do
			if cle ~= maCle and type(a) == "table" and type(a.quetes) == "table" and EnLigne(cle) then
				local meilleur
				for id in pairs(a.quetes) do
					local s = Suite(id)
					local mien = s and mesSuites[s.racine]
					if mien then
						local ecart = math.abs(s.etape - mien.etape)
						if ecart <= 2 and (not meilleur or ecart < meilleur.ecart) then
							meilleur = { ecart = ecart, etape = s.etape, mien = mien }
						end
					end
				end
				if meilleur and not (meilleur.ecart == 0 and dejaSuggeres[cle]) then
					local m = Membre(roster, cle, a.nom)
					if not DansMonGroupe(m.nom) then
						local mien = meilleur.mien
						local s = { cle = "s:" .. cle, genre = "suite", membres = { m },
							score = 12 + mien.etape * 2 - meilleur.ecart * 3, bouton = "Chuchoter", actif = true,
							action = function() if UI.Chuchoter then UI.Chuchoter(m.cle, m.nom) end end }
						if meilleur.ecart == 0 then
							s.titre = ("%s en est au même point que toi"):format(NomCourt(m.nom))
							s.sous = ("%s, étape %d sur %d"):format(mien.titre, mien.etape, mien.longueur)
						else
							s.titre = ("%s fait la même suite de quêtes que toi"):format(NomCourt(m.nom))
							s.sous = ("%s : tu en es à l'étape %d, %s à l'étape %d (sur %d)"):format(mien.titre, mien.etape,
								NomCourt(m.nom), meilleur.etape, mien.longueur)
						end
						res[#res + 1] = s
					end
				end
			end
		end
	end

	-- 4. membres dispo proches de mon niveau
	for cle in pairs(dispos) do
		if cle ~= maCle and not dejaSuggeres[cle] and MembreDispo(cle) then
			local m = Membre(roster, cle)
			local ecart = m.niveau and math.abs(m.niveau - monNiveau) or 0
			if m.enLigne and ecart <= ECART_NIVEAU and not DansMonGroupe(m.nom) then
				local memeZone = m.zone and m.zone == maZone
				res[#res + 1] = { cle = "d:" .. cle, genre = "dispo", score = 20 + (memeZone and 15 or 0) - ecart * 2,
					membres = { m },
					titre = ("%s est dispo pour grouper"):format(NomCourt(m.nom)),
					sous = ("%s%s%s"):format(m.niveau and ("niveau " .. m.niveau) or "",
						m.role and (" · " .. TexteRole(m.role)) or "",
						memeZone and " · dans ta zone" or (m.zone and (" · " .. m.zone) or "")),
					bouton = "Inviter", actif = PeutInviter(), action = function(s) Inviter(s.membres) end }
			end
		end
	end

	-- 5. groupes ouverts de la guilde qui cherchent mon rôle, ou montés pour une de mes quêtes
	local etat = ns.Groupes and ns.Groupes.etat
	if etat and not EnGroupe() then
		local mesQuetes = {}
		for _, q in ipairs(ns.QuetesEnCommun and ns.QuetesEnCommun() or {}) do mesQuetes[q.id] = true end
		for id, a in pairs(etat.annonces or {}) do
			local libres = ns.Groupes.PlacesLibres and ns.Groupes.PlacesLibres(a, monRole)
			local pasLeMien = not (etat.monAnnonce and id == etat.monAnnonce.id)
			local cand = etat.candidatures and etat.candidatures[id]
			if pasLeMien and (a.membres or 1) < (a.taille or 5) and (libres == nil or libres > 0) and cand ~= "refusee" then
				local info = ns.Groupes.InfoContenu and ns.Groupes.InfoContenu(a.code) or {}
				local quete = tostring(a.code or ""):match("^q(%d+)$")
				local maQuete = quete and mesQuetes[tonumber(quete)]
				local chef = Normaliser(a.chef or "")
				res[#res + 1] = { cle = "g:" .. tostring(id), genre = "groupe", icone = info.icone,
					score = 25 + (maQuete and 20 or 0) + (monRole and 5 or 0),
					membres = chef and { Membre(roster, chef, a.chef) } or {},
					titre = ("%s cherche %s pour %s"):format(NomCourt(a.chef or "?"),
						monRole and ("un " .. TexteRole(monRole)) or "du monde", info.nom or "un groupe"),
					sous = ("%d/%d%s"):format(a.membres or 1, a.taille or 5, maQuete and " · tu as cette quête" or ""),
					bouton = cand == "envoyee" and "Envoyée" or "Postuler", actif = cand ~= "envoyee",
					action = function() if ns.Groupes.Postuler then ns.Groupes.Postuler(id) end end }
			end
		end
	end

	-- tri, suggestions ignorées retirées
	local garde = {}
	for _, s in ipairs(res) do if not ignorees[s.cle] then garde[#garde + 1] = s end end
	table.sort(garde, function(a, b)
		if a.score ~= b.score then return a.score > b.score end
		return a.cle < b.cle
	end)
	while #garde > MAX_SUGGESTIONS do table.remove(garde) end
	return garde
end

-- Suggestions du moment (recalculées au plus toutes les 2 s)
ns.SuggestionsEnsemble = function()
	if not cache or GetTime() - cacheA >= 2 then
		local ok, l = pcall(Calculer)
		cache, cacheA = ok and l or {}, GetTime()
		ns.DerniereErreurEnsemble = (not ok) and l or nil
	end
	return cache
end
ns.NombreSuggestions = function() return #ns.SuggestionsEnsemble() end

-- Membres dispo en ligne, triés par écart de niveau
ns.MembresDispo = function()
	local roster = RosterParCle()
	local monNiveau = UnitLevel("player") or 0
	local l = {}
	for cle in pairs(dispos) do
		if MembreDispo(cle) then l[#l + 1] = Membre(roster, cle) end
	end
	table.sort(l, function(a, b)
		local ea, eb = math.abs((a.niveau or monNiveau) - monNiveau), math.abs((b.niveau or monNiveau) - monNiveau)
		if ea ~= eb then return ea < eb end
		return a.nom < b.nom
	end)
	return l
end

--------------------------------------------------------------------------------
-- Page « Jouer ensemble »
--------------------------------------------------------------------------------

local MARGE = 16
local HAUT_CORPS = -64        -- haut du contenu, sous les onglets
local HAUTEUR_SUGG, ECART_SUGG = 78, 8
local LARGEUR_DISPO = 250
local HAUTEUR_DISPO = 46
local HAUTEUR_DONJON, ECART_DONJON = 74, 8

local function PoserIcone(tex, icone, defaut)
	if type(icone) == "table" and ns.Groupes and ns.Groupes.PoserIcone then
		ns.Groupes.PoserIcone(tex, icone)
	else
		tex:SetTexture(icone or defaut)
		tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end
end

local function CreerSuggestion(parent)
	local r = UI.Rangee(parent, HAUTEUR_SUGG)
	r.icone = r:CreateTexture(nil, "ARTWORK")
	r.icone:SetSize(40, 40)
	r.icone:SetPoint("LEFT", r, "LEFT", 14, 0)
	r.bouton = UI.Bouton(r, "", "or", 140, 30)
	r.bouton:SetPoint("RIGHT", r, "RIGHT", -14, 0)
	r.titre = UI.Texte(r, "GameFontHighlight", C.texte)
	r.titre:SetPoint("TOPLEFT", r, "TOPLEFT", 66, -12)
	r.titre:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("TOPLEFT", r.titre, "BOTTOMLEFT", 0, -4)
	r.sous:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r.portraits = {}
	for i = 1, 4 do
		local po = UI.Portrait(r, 22)
		po:SetPoint("BOTTOMLEFT", r, "BOTTOMLEFT", 66 + (i - 1) * 16, 10)
		po:SetFrameLevel(r:GetFrameLevel() + 1 + i)
		r.portraits[i] = po
	end
	r.membres = UI.Texte(r, "GameFontHighlightSmall", C.texte)
	r:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	r:SetScript("OnClick", function(self, bouton)
		if bouton == "RightButton" and self.s then
			ignorees[self.s.cle] = true
			cacheA = -10
			if ns.MajInterface then ns.MajInterface() end
		end
	end)
	r:SetScript("OnEnter", function(self)
		if not self.s then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.s.titre, 1, 0.82, 0, 1, true)
		for _, m in ipairs(self.s.membres or {}) do
			GameTooltip:AddLine(("%s%s|r%s%s%s"):format(ns.CouleurClasseTexte and ns.CouleurClasseTexte(m.classe) or "",
				NomCourt(m.nom), m.niveau and ("  " .. m.niveau) or "", (m.roleGroupe or m.role) and ("  " .. TexteRole(m.roleGroupe or m.role)) or "",
				m.dispo and "  |cff6fd08cdispo|r" or ""), 1, 1, 1)
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Clic droit : ignorer cette suggestion", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	r:SetScript("OnLeave", function() GameTooltip:Hide() end)
	r.bouton:SetScript("OnClick", function(self)
		local s = self:GetParent().s
		if s and s.action then s.action(s) end
		cacheA = -10
		if ns.MajInterface then ns.MajInterface() end
	end)
	return r
end

local ICONES = {
	quetes = "Interface\\Icons\\INV_Misc_Note_06",
	donjon = "Interface\\Icons\\INV_Misc_Key_03",
	suite = "Interface\\Icons\\INV_Misc_Map_01",
	dispo = "Interface\\Icons\\INV_Misc_GroupNeedMore",
	groupe = "Interface\\Icons\\INV_Sword_04",
}

local function TexteMembres(membres, max)
	local noms = {}
	for i = 1, math.min(#membres, max or 4) do
		local m = membres[i]
		noms[#noms + 1] = ("%s%s|r%s"):format(ns.CouleurClasseTexte and ns.CouleurClasseTexte(m.classe) or "", NomCourt(m.nom),
			m.niveau and (" |cff9c9380" .. m.niveau .. "|r") or "")
	end
	return table.concat(noms, ", ") .. (#membres > (max or 4) and (" |cff9c9380+" .. (#membres - (max or 4)) .. "|r") or "")
end

local function RemplirSuggestion(r, s)
	r.s = s
	PoserIcone(r.icone, s.icone, ICONES[s.genre] or ICONES.quetes)
	r.titre:SetText(s.titre)
	r.sous:SetText(s.sous or "")
	r.bouton:Ecrire(s.bouton)
	r.bouton:Activer(s.actif and true or false)
	for i, po in ipairs(r.portraits) do
		local m = s.membres and s.membres[i]
		if m then po:Poser(m.cle, m.classe); po:Show() else po:Hide() end
	end
	local n = s.membres and #s.membres or 0
	r.membres:ClearAllPoints()
	r.membres:SetPoint("LEFT", r, "BOTTOMLEFT", 66 + math.max(1, math.min(n, 4)) * 16 + 12, 21)
	r.membres:SetPoint("RIGHT", r.bouton, "LEFT", -12, 0)
	r.membres:SetText(TexteMembres(s.membres or {}))
	r:SetBackdropBorderColor(unpack(s.score >= 40 and C.bordFort or C.bord))
end

local function CreerDispo(parent)
	local b = CreateFrame("Button", nil, parent)
	b:SetHeight(HAUTEUR_DISPO)
	b.portrait = UI.Portrait(b, 32)
	b.portrait:SetPoint("LEFT", b, "LEFT", 0, 0)
	b.role = UI.Texte(b, "GameFontHighlightSmall")
	b.role:SetPoint("RIGHT", b, "RIGHT", 0, 0)
	b.role:SetJustifyH("RIGHT")
	b.nom = UI.Texte(b, "GameFontHighlight")
	b.nom:SetPoint("TOPLEFT", b.portrait, "TOPRIGHT", 8, -1)
	b.nom:SetPoint("RIGHT", b.role, "LEFT", -6, 0)
	b.sous = UI.Texte(b, "GameFontHighlightSmall", C.gris)
	b.sous:SetPoint("BOTTOMLEFT", b.portrait, "BOTTOMRIGHT", 8, 1)
	b.sous:SetPoint("RIGHT", b, "RIGHT", 0, 0)
	b.ligne = b:CreateTexture(nil, "BACKGROUND")
	b.ligne:SetColorTexture(C.bord[1], C.bord[2], C.bord[3], 0.6)
	b.ligne:SetHeight(1)
	b.ligne:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 0, -3)
	b.ligne:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 0, -3)
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	b:SetScript("OnClick", function(self, bouton)
		local m = self.m
		if not m then return end
		if bouton == "RightButton" then Inviter({ m }) else UI.Chuchoter(m.cle, m.nom) end
	end)
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText(self.m and NomCourt(self.m.nom) or "")
		GameTooltip:AddLine("Clic : chuchoter · clic droit : inviter", 0.8, 0.8, 0.8)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	if UI.SonClic then UI.SonClic(b) end
	return b
end

-- rangée d'un donjon (onglet Donjons)
local function CreerDonjon(parent)
	local r = UI.Rangee(parent, HAUTEUR_DONJON)
	r.icone = r:CreateTexture(nil, "ARTWORK")
	r.icone:SetSize(44, 44)
	r.icone:SetPoint("LEFT", r, "LEFT", 14, 0)
	r.monter = UI.Bouton(r, "Monter le groupe", "or", 132, 26)
	r.monter:SetPoint("TOPRIGHT", r, "TOPRIGHT", -14, -9)
	r.annonce = UI.Bouton(r, "Créer l'annonce", "fantome", 132, 24)
	r.annonce:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", -14, 9)
	r.nom = UI.Texte(r, "GameFontHighlight", C.texte)
	r.nom:SetPoint("TOPLEFT", r, "TOPLEFT", 70, -14)
	r.nom:SetWidth(200)
	r.niveaux = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.niveaux:SetPoint("TOPLEFT", r.nom, "BOTTOMLEFT", 0, -5)
	r.niveaux:SetWidth(200)
	r.quetes = UI.Texte(r, "GameFontHighlightSmall", C.texte)
	r.quetes:SetPoint("TOPLEFT", r, "TOPLEFT", 284, -14)
	r.quetes:SetWidth(170)
	r.qui = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.qui:SetPoint("TOPLEFT", r.quetes, "BOTTOMLEFT", 0, -5)
	r.qui:SetWidth(170)
	r.qui:SetWordWrap(true)
	r.roles = {}
	for i, role in ipairs({ "tank", "heal", "dps" }) do
		local t = UI.Texte(r, "GameFontHighlightSmall", C.texte)
		t:SetPoint("TOPLEFT", r, "TOPLEFT", 468, -12 - (i - 1) * 17)
		t:SetPoint("RIGHT", r.monter, "LEFT", -10, 0)
		t:SetWordWrap(false)
		r.roles[role] = t
	end
	r.monter:SetScript("OnClick", function(self)
		local i = self:GetParent().i
		if i then MonterGroupe(i) end
	end)
	r.monter:SetScript("OnEnter", function(self)
		local i = self:GetParent().i
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("Monter le groupe")
		if i and #i.choisis > 0 then
			GameTooltip:AddLine("Invite " .. TexteMembres(i.choisis, 4) .. ".", 1, 1, 1, true)
		else
			GameTooltip:AddLine("Personne à inviter pour l'instant : aucun membre en ligne n'y a de quête ni n'est dispo à ce niveau.", 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	r.monter:SetScript("OnLeave", function() GameTooltip:Hide() end)
	r.annonce:SetScript("OnClick", function(self)
		local i = self:GetParent().i
		if i then CreerAnnonce(i) end
	end)
	r.annonce:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("Créer l'annonce")
		GameTooltip:AddLine("Publie un groupe pour ce donjon dans la recherche de groupe de la guilde (page Groupes). Tu peux aussi le programmer depuis « Mon groupe ».", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	r.annonce:SetScript("OnLeave", function() GameTooltip:Hide() end)
	return r
end

local function RemplirDonjon(r, i)
	r.i = i
	PoserIcone(r.icone, (EntreeCatalogue(i.d) or {}).icone, ICONES.donjon)
	r.nom:SetText(i.nom)
	r.niveaux:SetText(("Niveaux %d–%d%s"):format(i.d.min, i.d.max, i.aMonNiveau and "  |cff6fd08c· à ton niveau|r" or ""))
	if i.nQuetes > 0 or #i.membres > 0 then
		local total = 0
		for _, m in ipairs(i.membres) do total = total + m.n end
		r.quetes:SetText(("%d quête%s · %d membre%s%s"):format(i.nQuetes + 0, i.nQuetes > 1 and "s" or "",
			#i.membres, #i.membres > 1 and "s" or "", i.mesQuetes > 0 and (" · toi : " .. i.mesQuetes) or ""))
		local enLigne = {}
		for _, m in ipairs(i.membres) do if m.enLigne then enLigne[#enLigne + 1] = m end end
		r.qui:SetText(#enLigne > 0 and TexteMembres(enLigne, 3) or "personne en ligne")
	else
		r.quetes:SetText("|cff9c9380Aucune quête connue dedans|r")
		r.qui:SetText("")
	end
	-- rôles : moi, mon groupe et les membres que « Monter le groupe » inviterait
	local parRole = { tank = {}, heal = {}, dps = {} }
	local monRole = ns.MonRole and ns.MonRole()
	monRole = parRole[monRole or ""] and monRole or "dps"
	parRole[monRole][#parRole[monRole] + 1] = "|cfff1cf6btoi|r"
	for _, m in ipairs(i.choisis) do
		local l = parRole[m.roleGroupe or "dps"]
		l[#l + 1] = ("%s%s|r"):format(ns.CouleurClasseTexte and ns.CouleurClasseTexte(m.classe) or "", NomCourt(m.nom))
	end
	for role, t in pairs(r.roles) do
		local l = parRole[role]
		local manque = i.reste[role] or 0
		t:SetText(TexteRole(role) .. " : " .. (#l > 0 and table.concat(l, ", ") or "")
			.. (manque > 0 and ((#l > 0 and " " or "") .. "|cff9c9380(" .. manque .. " à trouver)|r") or ""))
	end
	r.monter:Activer(PeutInviter() and #i.choisis > 0)
	r.annonce:Activer(not (ns.Groupes and ns.Groupes.PeutAnnoncer) or ns.Groupes.PeutAnnoncer())
end

local FILTRES_DONJONS = { "À mon niveau", "Où il y a des quêtes", "Tous" }

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.onglet = 1
	p.filtre = 1

	p.onglets = UI.Onglets(p, { "Maintenant", "Donjons" }, function(i)
		p.onglet = i
		p.Maj()
	end)
	p.onglets:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -12)
	p.onglets:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)

	p.dispo = UI.Case(p, "Dispo pour grouper", function(oui) ns.BasculerDispo(oui) end)
	p.dispo:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -20)
	p.dispo:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		GameTooltip:SetText("Dispo pour grouper")
		GameTooltip:AddLine("La guilde te voit dans « Dispo maintenant » et peut te proposer un groupe. Jusqu'à ta déconnexion (aussi dans le menu rapide du médaillon et /smb dispo).", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	p.dispo:SetScript("OnLeave", function() GameTooltip:Hide() end)

	-- onglet Maintenant
	local maintenant = CreateFrame("Frame", nil, p)
	maintenant:SetPoint("TOPLEFT", p, "TOPLEFT", 0, HAUT_CORPS)
	maintenant:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
	p.maintenant = maintenant
	local cote = UI.Carte(maintenant, "Dispo maintenant")
	cote:SetPoint("TOPRIGHT", maintenant, "TOPRIGHT", -MARGE, 0)
	cote:SetPoint("BOTTOMRIGHT", maintenant, "BOTTOMRIGHT", -MARGE, MARGE)
	cote:SetWidth(LARGEUR_DISPO)
	cote.lignes = {}
	for i = 1, 8 do
		local b = CreerDispo(cote)
		b:SetPoint("TOPLEFT", cote, "TOPLEFT", 14, -38 - (i - 1) * (HAUTEUR_DISPO + 6))
		b:SetPoint("RIGHT", cote, "RIGHT", -14, 0)
		cote.lignes[i] = b
	end
	cote.vide = UI.Texte(cote, "GameFontHighlightSmall", C.gris)
	cote.vide:SetPoint("TOPLEFT", cote, "TOPLEFT", 14, -40)
	cote.vide:SetPoint("RIGHT", cote, "RIGHT", -14, 0)
	cote.vide:SetWordWrap(true)
	cote.vide:SetText("Personne n'est dispo pour l'instant. Coche « Dispo pour grouper » pour apparaître ici chez les autres.")
	p.lignes = {}
	for i = 1, MAX_SUGGESTIONS do
		local r = CreerSuggestion(maintenant)
		r:SetPoint("TOPLEFT", maintenant, "TOPLEFT", MARGE, -(i - 1) * (HAUTEUR_SUGG + ECART_SUGG))
		r:SetPoint("RIGHT", cote, "LEFT", -14, 0)
		p.lignes[i] = r
	end
	p.vide = UI.Texte(maintenant, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", maintenant, "TOPLEFT", MARGE + 4, -8)
	p.vide:SetPoint("RIGHT", cote, "LEFT", -18, 0)
	p.vide:SetWordWrap(true)
	p.vide:SetText("Rien à proposer pour l'instant. Les suggestions viennent des quêtes que tu partages avec d'autres membres, des donjons à ton niveau, des membres dispo et des groupes de la guilde.")
	local astuce = UI.Texte(maintenant, "GameFontHighlightSmall", C.gris)
	astuce:SetPoint("BOTTOMLEFT", maintenant, "BOTTOMLEFT", MARGE, MARGE + 2)
	astuce:SetPoint("RIGHT", cote, "LEFT", -14, 0)
	astuce:SetText("Clic droit sur une suggestion : l'ignorer. Survol : le détail des membres.")

	-- onglet Donjons
	local donjons = CreateFrame("Frame", nil, p)
	donjons:SetPoint("TOPLEFT", p, "TOPLEFT", 0, HAUT_CORPS)
	donjons:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", 0, 0)
	p.donjons = donjons
	p.puces = UI.Puces(donjons, FILTRES_DONJONS, function(i)
		p.filtre = i
		p.Maj()
	end)
	p.puces:SetPoint("TOPLEFT", donjons, "TOPLEFT", MARGE, 0)
	local note = UI.Texte(donjons, "GameFontHighlightSmall", C.gris)
	note:SetPoint("LEFT", p.puces, "RIGHT", 12, 0)
	note:SetPoint("RIGHT", donjons, "RIGHT", -MARGE, 0)
	note:SetJustifyH("RIGHT")
	note:SetText("Quêtes de donjon d'après Questie · membres qui ont SMB Forever")
	p.liste = UI.Liste(donjons)
	p.liste:SetPoint("TOPLEFT", donjons, "TOPLEFT", MARGE, -38)
	p.liste:SetPoint("BOTTOMRIGHT", donjons, "BOTTOMRIGHT", -MARGE + 6, 12)
	p.rangees = {}
	p.videDonjons = UI.Texte(donjons, "GameFontHighlight", C.gris)
	p.videDonjons:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.videDonjons:SetPoint("RIGHT", donjons, "RIGHT", -MARGE, 0)
	p.videDonjons:SetWordWrap(true)

	local function MajMaintenant()
		local liste = ns.SuggestionsEnsemble()
		for i, r in ipairs(p.lignes) do
			local s = liste[i]
			if s then RemplirSuggestion(r, s); r:Show() else r:Hide(); r.s = nil end
		end
		p.vide:SetShown(#liste == 0)
		local dispoListe = ns.MembresDispo()
		cote.compte:SetText(#dispoListe > 0 and tostring(#dispoListe) or "")
		for i, b in ipairs(cote.lignes) do
			local m = dispoListe[i]
			if m then
				b.m = m
				b.portrait:Poser(m.cle, m.classe)
				b.nom:SetText(("%s%s|r"):format(ns.CouleurClasseTexte and ns.CouleurClasseTexte(m.classe) or "", NomCourt(m.nom)))
				b.sous:SetText((m.niveau and (m.niveau .. " · ") or "") .. (m.zone or ""))
				b.role:SetText(TexteRole(m.role))
				b:Show()
			else
				b:Hide()
				b.m = nil
			end
		end
		cote.vide:SetShown(#dispoListe == 0)
	end

	local function MajDonjons()
		p.puces:Choisir(p.filtre)
		local liste = {}
		for _, i in ipairs(InfosDonjons()) do
			local garde = (p.filtre == 3) or (p.filtre == 1 and i.aMonNiveau) or (p.filtre == 2 and (i.nQuetes > 0 or #i.membres > 0))
			if garde then liste[#liste + 1] = i end
		end
		-- ceux où il y a le plus à faire d'abord (à niveau égal de filtre), puis par niveau
		table.sort(liste, function(a, b)
			local sa, sb = a.nQuetes + a.enLigne * 2, b.nQuetes + b.enLigne * 2
			if sa ~= sb then return sa > sb end
			return a.d.min < b.d.min
		end)
		local y = 0
		for n, i in ipairs(liste) do
			local r = p.rangees[n]
			if not r then r = CreerDonjon(p.liste.contenu); p.rangees[n] = r end
			RemplirDonjon(r, i)
			r:ClearAllPoints()
			r:SetPoint("TOPLEFT", p.liste.contenu, "TOPLEFT", 0, -y)
			r:SetPoint("RIGHT", p.liste.contenu, "RIGHT", 0, 0)
			r:Show()
			y = y + HAUTEUR_DONJON + ECART_DONJON
		end
		for n = #liste + 1, #p.rangees do p.rangees[n]:Hide() end
		p.liste:Hauteur(y)
		p.videDonjons:SetShown(#liste == 0)
		p.videDonjons:SetText(p.filtre == 1 and "Aucun donjon à ton niveau." or "Aucune quête de donjon connue chez toi ni chez les membres de la guilde.")
	end

	p.Maj = function()
		p.onglets:Choisir(p.onglet)
		p.onglets:Compte(1, #ns.SuggestionsEnsemble())
		p.dispo:Poser(monDispo)
		p.maintenant:SetShown(p.onglet == 1)
		p.donjons:SetShown(p.onglet == 2)
		if p.onglet == 2 then MajDonjons() else MajMaintenant() end
	end
	-- ns.OuvrirInterface("ensemble", onglet)
	p.Ouvrir = function(onglet)
		if onglet == "donjons" or onglet == 2 then p.onglet = 2 elseif onglet then p.onglet = 1 end
		p.Maj()
	end
	return p
end
if ns.AjouterPage then ns.AjouterPage("ensemble", CreerPage) end

-- /smb ensemble [donjons], menu rapide : ouvrir la page
ns.OuvrirEnsemble = function(onglet)
	if not ns.OuvrirInterface then return end
	if onglet then ns.OuvrirInterface("ensemble", onglet) else ns.OuvrirInterface("ensemble") end
end

ns.DiagEnsemble = function(L)
	local n = 0
	for cle in pairs(dispos) do if MembreDispo(cle) then n = n + 1 end end
	local nDonjons, nSuites = 0, 0
	for _ in pairs(quetesDonjons or {}) do nDonjons = nDonjons + 1 end
	for _ in pairs(suites or {}) do nSuites = nSuites + 1 end
	L(("jouer ensemble : moi %s ; %d membre(s) dispo ; %d suggestion(s) ; données : %s donjons, %s quêtes en suite%s"):format(
		monDispo and "dispo" or "pas dispo", n, #ns.SuggestionsEnsemble(), quetesDonjons and nDonjons or "pas lus",
		suites and nSuites or "pas lues",
		ns.DerniereErreurEnsemble and (" ; erreur : " .. tostring(ns.DerniereErreurEnsemble)) or ""))
end

--------------------------------------------------------------------------------
-- Évènements : « qui est dispo ? » à la connexion, rappel toutes les 10 min, groupe qui change
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE" }) do pcall(ev.RegisterEvent, ev, nom) end
local premiere = true
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		C_Timer.After(16, function() Envoyer("Q") end)
		if C_Timer.NewTicker then
			C_Timer.NewTicker(RAPPEL, function() if monDispo then Envoyer("D~1", true) end end)
		end
	elseif event == "GROUP_ROSTER_UPDATE" then
		cacheA = -10
	end
end)
