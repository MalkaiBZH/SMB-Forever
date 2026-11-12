-- GuildUp : fenêtre « Artisanat & Échanges » (1.5) — tout l'artisanat de la guilde en un.
-- Onglets : Registre (métiers et recettes, GuildUp_Metiers.lua) · Dons (hôtel des ventes de dons,
-- par catégorie) · Mes dons (mes objets échangeables, sacs et banque : je coche ce que je donne) ·
-- Besoins (GuildUp_Besoins.lua).
--
-- Préfixe "GuildUpEch" (canal de guilde) :
--   "L~part~total~objet:qte:métier:niveau,…"  ma liste de dons complète (vide = plus aucun don)
--   "Q"                                         « renvoyez vos listes » (à la connexion)
--   "D~objet~cible~quand"                       je voudrais ce don (+ message privé si en ligne)
--   "R~cible~demandeur~objet~quand"             demande faite pendant que « cible » était hors ligne,
--                                               renvoyée par un membre à sa connexion
--   "A~demandeur~objet~quand"                   accusé de réception du donneur : les membres qui
--                                               gardaient cette demande pour lui l'oublient
-- Les demandes reçues sont gardées (onglet « Demandes ») ; celles faites à un donneur hors ligne
-- sont gardées par les membres connectés et lui arrivent à sa connexion.
-- Les listes sont gardées (GuildUpDB) : visibles même quand le donneur est hors ligne.
-- Plans : bulle tout de suite pour ceux qui ont le métier au niveau requis, 10 s plus tard pour
-- ceux qui ont le métier sans le niveau, rien pour les autres ni si la recette est déjà apprise.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpEch"
local DELAI_SANS_NIVEAU = 10
local CALME = 25
local OUBLI = 30 * 86400
local TAILLE_MORCEAU = 200
local LARGEUR, HAUTEUR = 720, 520
local HAUT_ENCART = -88
local LARGEUR_CATS = 132
local ICONE_FENETRE = "Interface\\Icons\\INV_Holiday_Christmas_Present_01"
local TITRE = "Dons de la guilde"
-- onglets
local DONS, MES_DONS, DEMANDES, BESOINS = 1, 2, 3, 4
local GARDE_DEMANDES = 30 * 86400   -- historique des demandes reçues
local GARDE_RELAIS = 14 * 86400     -- demandes gardées pour un donneur hors ligne

local SOUS_CLASSES_PLANS = { [1] = "TC", [2] = "CO", [3] = "IN", [4] = "FO", [5] = "CU", [6] = "AL",
	[7] = "SE", [8] = "EN", [9] = "PE", [10] = "JO", [11] = "CA" }

-- Catégories de la colonne de gauche (classes d'objets du jeu)
local CATEGORIES = {
	{ nom = "Tout" },
	{ nom = "Recettes", classes = { [9] = true } },
	{ nom = "Armes", classes = { [2] = true } },
	{ nom = "Armures", classes = { [4] = true } },
	{ nom = "Consommables", classes = { [0] = true } },
	{ nom = "Artisanat", classes = { [7] = true, [5] = true } },
	{ nom = "Gemmes", classes = { [3] = true } },
	{ nom = "Sacs", classes = { [1] = true, [11] = true } },
	{ nom = "Quête", classes = { [12] = true } },
	{ nom = "Divers", autres = true },
}
local CLASSES_RANGEES = {}
for _, c in ipairs(CATEGORIES) do for k in pairs(c.classes or {}) do CLASSES_RANGEES[k] = true end end

local debut = GetTime()
local pret = false
local PhotoConnexion, RecapConnexion
local fen
local MajTout

local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local TestSolo = ns.TestSolo
local NomCourt = ns.NomCourt
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local Erreur = ns.Erreur
local AtlasExiste = ns.AtlasExiste
local PoserAtlas = ns.PoserAtlas
local Simplifier = ns.Simplifier

--------------------------------------------------------------------------------
-- Données
--   db.donsPerso[perso][objet] = quantité          ce que je donne, par personnage (voir Dons())
--   db.donsBanque[perso] = { [objet] = nombre }    objets échangeables de ma banque (dernière visite)
--   db.echanges[guilde][cle] = { nom, vu, liste = { [objet] = { q, c, n } } }
--------------------------------------------------------------------------------

local function DB() return ns.DB and ns.DB() or {} end
-- Mes dons, par personnage (GuildUpDB est commun au compte : sans cela, un reroll effaçait les
-- dons du principal). Ancienne table commune db.dons : reprise une fois, par le personnage
-- principal s'il est choisi, sinon par le premier personnage connecté.
local function Dons()
	local db = DB()
	if type(db.donsPerso) ~= "table" then db.donsPerso = {} end
	if type(db.dons) == "table" then
		local cle = (type(db.persoPrincipal) == "string" and db.persoPrincipal ~= "") and db.persoPrincipal or MaCle()
		if db.donsPerso[cle] == nil then db.donsPerso[cle] = db.dons end
		db.dons = nil
	end
	local moi = MaCle()
	if type(db.donsPerso[moi]) ~= "table" then db.donsPerso[moi] = {} end
	return db.donsPerso[moi]
end
local function Banque()
	local db = DB()
	if type(db.donsBanque) ~= "table" then db.donsBanque = {} end
	local cle = MaCle()
	if type(db.donsBanque[cle]) ~= "table" then db.donsBanque[cle] = {} end
	return db.donsBanque[cle]
end
local function Guilde()
	local nom = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not nom then return nil end
	local db = DB()
	if type(db.echanges) ~= "table" then db.echanges = {} end
	if type(db.echanges[nom]) ~= "table" then db.echanges[nom] = {} end
	return db.echanges[nom]
end

-- ici : nom, lien, qualité, niveau minimum, icône
local function InfoObjet(objet)
	local nom, lien, qualite, icone, niveau = ns.InfoObjet(objet)
	return nom, lien, qualite, niveau, icone
end
local function ClasseObjet(objet)
	local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not f then return nil end
	local ok, _, _, _, _, icone, classe, sousClasse = pcall(f, objet)
	if ok then return classe, sousClasse, icone end
end
local Precharger = ns.Precharger

-- Infobulle d'un objet (lignes de texte), pour lire « Requiert Forge (125) » et « Déjà connu »
local bulleCachee
local function LignesInfobulle(objet)
	local lignes = {}
	if C_TooltipInfo and C_TooltipInfo.GetItemByID then
		local ok, data = pcall(C_TooltipInfo.GetItemByID, objet)
		if ok and data and data.lines then
			for _, l in ipairs(data.lines) do lignes[#lignes + 1] = l.leftText or "" end
			if #lignes > 0 then return lignes end
		end
	end
	if not bulleCachee then
		bulleCachee = CreateFrame("GameTooltip", "GuildUpBulleEchanges", UIParent, "GameTooltipTemplate")
	end
	bulleCachee:SetOwner(WorldFrame, "ANCHOR_NONE")
	pcall(bulleCachee.SetItemByID, bulleCachee, objet)
	for i = 1, bulleCachee:NumLines() do
		local fs = _G["GuildUpBulleEchangesTextLeft" .. i]
		lignes[#lignes + 1] = fs and fs:GetText() or ""
	end
	bulleCachee:Hide()
	return lignes
end
local function DejaConnu(objet)
	if not ITEM_SPELL_KNOWN then return false end
	for _, t in ipairs(LignesInfobulle(objet)) do if t == ITEM_SPELL_KNOWN then return true end end
	return false
end
-- Plan : métier et niveau requis (ligne « Requiert Forge (125) »)
local exigences = {} -- [objet] = { code, niveau } : lu une fois dans l'infobulle
local ExigenceLue
local function Exigence(objet, sousClasse)
	local e = exigences[objet]
	if e then return e[1], e[2] end
	local code, niveau = ExigenceLue(objet, sousClasse)
	-- infobulle pas encore chargée (texte vide) : on ne garde pas, on relira
	if code ~= SOUS_CLASSES_PLANS[sousClasse or -1] or niveau ~= 0 then exigences[objet] = { code, niveau } end
	return code, niveau
end
ExigenceLue = function(objet, sousClasse)
	local code, niveau
	for _, texte in ipairs(LignesInfobulle(objet)) do
		local avant, n = texte:match("^(.-)%s*%((%d+)%)%s*$")
		if avant and n and not code then
			local mots = {}
			for mot in avant:gmatch("%S+") do mots[#mots + 1] = mot end
			for d = 1, #mots do
				local m = ns.MetierParNom and ns.MetierParNom(table.concat(mots, " ", d))
				if m then code, niveau = m.code, tonumber(n); break end
			end
		end
	end
	return code or SOUS_CLASSES_PLANS[sousClasse or -1], niveau or 0
end
local function TexteMetier(code, niveau)
	local nom = code and ns.NomMetierCode and ns.NomMetierCode(code) or "?"
	return (niveau and niveau > 0) and (nom .. " " .. niveau) or nom
end
-- "ok" (métier au niveau), "bas" (métier sans le niveau), nil (pas le métier)
local function MaPlace(code, niveau)
	local n = code and ns.MonNiveauMetier and ns.MonNiveauMetier(code)
	if not n then return nil end
	return n >= (niveau or 0) and "ok" or "bas"
end

--------------------------------------------------------------------------------
-- Mes objets échangeables (sacs + banque)
--------------------------------------------------------------------------------

local mesObjets = {}     -- [objet] = { objet, nombre, lieu, classe, sousClasse, code, niveau }

local function Case(sac, c)
	if C_Container and C_Container.GetContainerItemInfo then
		local info = C_Container.GetContainerItemInfo(sac, c)
		if info then return info.itemID, info.stackCount, info.isBound end
	elseif GetContainerItemInfo then
		local _, nombre, _, _, _, _, lien, _, _, objet, lie = GetContainerItemInfo(sac, c)
		objet = objet or (lien and tonumber(lien:match("item:(%d+)")))
		return objet, nombre, lie
	end
end
local function NbCases(sac)
	return (C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(sac))
		or (GetContainerNumSlots and GetContainerNumSlots(sac)) or 0
end

-- compte les objets d'un sac dans t (avecLies : aussi les objets liés, sinon seulement les échangeables)
local function LireSac(sac, t, avecLies)
	for c = 1, NbCases(sac) do
		local objet, nombre, lie = Case(sac, c)
		if objet and (avecLies or not lie) then t[objet] = (t[objet] or 0) + (nombre or 1) end
	end
end
ns.LireConteneur = LireSac
-- numéros des sacs de la banque (la banque elle-même, puis ses sacs)
ns.SacsDeBanque = function()
	local l = { BANK_CONTAINER or -1 }
	local premier = (NUM_BAG_SLOTS or 4) + 1
	for sac = premier, premier + (NUM_BANKBAGSLOTS or 7) - 1 do l[#l + 1] = sac end
	return l
end

local function LireBanque()
	local t = {}
	for _, sac in ipairs(ns.SacsDeBanque()) do LireSac(sac, t) end
	local b = Banque()
	wipe(b)
	for objet, n in pairs(t) do b[objet] = n end
end

local EnvoyerMaListe
local envoiPrevu = false
local function LireMesObjets()
	local sacs = {}
	for sac = 0, (NUM_BAG_SLOTS or 4) do LireSac(sac, sacs) end
	local t = {}
	local function Noter(objet, n, lieu)
		local o = t[objet]
		if o then
			o.nombre = o.nombre + n
			if o.lieu ~= lieu then o.lieu = "sacs et banque" end
			return
		end
		local classe, sousClasse = ClasseObjet(objet)
		o = { objet = objet, nombre = n, lieu = lieu, classe = classe, sousClasse = sousClasse }
		if classe == 9 then o.code, o.niveau = Exigence(objet, sousClasse) end
		t[objet] = o
	end
	for objet, n in pairs(sacs) do Noter(objet, n, "sacs") end
	for objet, n in pairs(Banque()) do Noter(objet, n, "banque") end
	-- un don que je n'ai plus (donné, vendu…) disparaît de ma liste
	local change = false
	for objet in pairs(Dons()) do
		if not t[objet] then Dons()[objet] = nil; change = true end
	end
	-- quantité changée d'un objet donné : la liste repart
	for objet in pairs(Dons()) do
		if not mesObjets[objet] or mesObjets[objet].nombre ~= t[objet].nombre then change = true end
	end
	mesObjets = t
	-- ramassages en série (objet donné qu'on continue de récolter) : un seul envoi après 45 s
	if change and pret and EnvoyerMaListe and not envoiPrevu then
		envoiPrevu = true
		C_Timer.After(45, function()
			envoiPrevu = false
			EnvoyerMaListe()
		end)
	end
	if MajTout then MajTout() end
end

--------------------------------------------------------------------------------
-- Envoi / réception des listes
--------------------------------------------------------------------------------

local dernierEnvoi = 0
EnvoyerMaListe = function()
	local mots = {}
	for objet in pairs(Dons()) do
		local o = mesObjets[objet]
		if o then
			local v = Dons()[objet]
			local q = (type(v) == "number" and v > 0) and math.min(v, o.nombre) or o.nombre
			mots[#mots + 1] = ("%d:%d:%s:%d"):format(objet, q, o.code or "", o.niveau or 0)
		end
	end
	table.sort(mots)
	local morceaux = ns.Morceaux(mots, TAILLE_MORCEAU)
	for i, txt in ipairs(morceaux) do Envoyer(("L~%d~%d~%s"):format(i, #morceaux, txt)) end
	dernierEnvoi = GetTime()
end

local function AlerteDon(cle, nom, objet, d)
	local g = Guilde()
	if not (g and g[cle] and g[cle].liste[objet]) or not ns.Notifier then return end -- retiré entre-temps
	if DejaConnu(objet) then return end
	local nomO, lien = InfoObjet(objet)
	ns.Notifier("plans", "Plan à donner", ("%s donne %s (%s)"):format(NomCourt(nom), lien or nomO or ("plan " .. objet),
		TexteMetier(d.c, d.n)), nil, function() if ns.OuvrirEchanges then ns.OuvrirEchanges(2, DONS) end end)
end

local reassembleur = ns.Reassembleur(30) -- listes de dons en cours de réception
-- Mes demandes de dons (gardées 30 jours) : db.mesDemandesDons[perso][cle .. objet] = { quand, merci }
local function MesDemandes()
	local db = DB()
	if type(db.mesDemandesDons) ~= "table" then db.mesDemandesDons = {} end
	local cle = MaCle()
	if type(db.mesDemandesDons[cle]) ~= "table" then db.mesDemandesDons[cle] = {} end
	local t = db.mesDemandesDons[cle]
	local limite = (GetServerTime and GetServerTime() or time()) - 30 * 86400
	for k, v in pairs(t) do
		if type(v) ~= "table" or (v.quand or 0) < limite then t[k] = nil end
	end
	return t
end
local mesDemandes = setmetatable({}, {
	__index = function(_, k) return MesDemandes()[k] end,
	__newindex = function(_, k, v)
		MesDemandes()[k] = v and { quand = GetServerTime and GetServerTime() or time() } or nil
	end,
})

-- Remerciements : « M~donneur~objet » ; chacun les garde (db.mercis[guilde]) pour le classement des
-- donateurs du mois
local function Mercis()
	local nomG = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not nomG then return {} end
	local db = DB()
	if type(db.mercis) ~= "table" then db.mercis = {} end
	if type(db.mercis[nomG]) ~= "table" then db.mercis[nomG] = {} end
	local t = db.mercis[nomG]
	local limite = (GetServerTime and GetServerTime() or time()) - 62 * 86400
	for i = #t, 1, -1 do
		if type(t[i]) ~= "table" or (t[i].quand or 0) < limite then table.remove(t, i) end
	end
	return t
end
local function NoterMerci(donneur, de, objet, quand)
	local t = Mercis()
	-- un merci par membre, par donneur et par objet et par jour
	for _, m in ipairs(t) do
		if m.donneur == donneur and m.de == de and m.objet == objet and math.abs((m.quand or 0) - quand) < 86400 then return end
	end
	t[#t + 1] = { donneur = donneur, de = de, objet = objet, quand = quand }
end
-- Les 3 donateurs les plus remerciés ce mois-ci
local function DonateursDuMois()
	local mois = date("%Y-%m", GetServerTime and GetServerTime() or time())
	-- un même membre compte au plus une fois par jour pour un donneur (des mercis en rafale ne
	-- font pas grimper le classement)
	local compte, vus = {}, {}
	for _, m in ipairs(Mercis()) do
		if date("%Y-%m", m.quand or 0) == mois then
			local k = tostring(m.donneur) .. "|" .. tostring(m.de) .. "|" .. date("%d", m.quand or 0)
			if not vus[k] then
				vus[k] = true
				compte[m.donneur] = (compte[m.donneur] or 0) + 1
			end
		end
	end
	local liste = {}
	for qui, n in pairs(compte) do liste[#liste + 1] = { qui = qui, n = n } end
	table.sort(liste, function(a, b) if a.n ~= b.n then return a.n > b.n end return a.qui < b.qui end)
	return liste
end
local MajDemandes          -- rafraîchit l'onglet « Demandes »

local Maintenant = ns.Maintenant

-- Demandes reçues (historique) : db.demandesDons[perso] = { { nom, objet, quand, vu }, … }
local function Historique()
	local db = DB()
	if type(db.demandesDons) ~= "table" then db.demandesDons = {} end
	local cle = MaCle()
	if type(db.demandesDons[cle]) ~= "table" then db.demandesDons[cle] = {} end
	local h = db.demandesDons[cle]
	local limite = Maintenant() - GARDE_DEMANDES
	for i = #h, 1, -1 do
		if type(h[i]) ~= "table" or (h[i].quand or 0) < limite then table.remove(h, i) end
	end
	return h
end

-- Ajoute une demande reçue (sans doublon) ; renvoie vrai si elle est nouvelle
local function NoterDemande(nom, objet, quand)
	local h = Historique()
	quand = tonumber(quand) or Maintenant()
	local cleNom = Normaliser(nom)
	for _, d in ipairs(h) do
		if d.objet == objet and Normaliser(d.nom) == cleNom and math.abs((d.quand or 0) - quand) < 5 then return false end
	end
	table.insert(h, 1, { nom = nom, objet = objet, quand = quand, vu = false })
	return true
end

local function NombreDemandes(objet, nonVues)
	local n = 0
	for _, d in ipairs(Historique()) do
		if (not objet or d.objet == objet) and (not nonVues or not d.vu) then n = n + 1 end
	end
	return n
end

-- Demandes à transmettre à un donneur hors ligne : db.relaisDons[guilde][cible][k] = { nom, objet, quand, t }
local function Relais()
	local nomG = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not nomG then return nil end
	local db = DB()
	if type(db.relaisDons) ~= "table" then db.relaisDons = {} end
	if type(db.relaisDons[nomG]) ~= "table" then db.relaisDons[nomG] = {} end
	return db.relaisDons[nomG]
end
local function GarderPourPlusTard(cible, nom, objet, quand)
	local r = Relais()
	if not r then return end
	r[cible] = r[cible] or {}
	r[cible][Normaliser(nom) .. ":" .. objet .. ":" .. quand] = { nom = nom, objet = objet, quand = quand, t = Maintenant() }
end
-- Le donneur vient de se connecter : on lui renvoie les demandes gardées (après un petit délai au
-- hasard, pour qu'un seul membre le fasse ; les autres voient passer les « R » et oublient les leurs)
local transmissionPrevue = {} -- [cible] = true : renvoi déjà programmé
local function Transmettre(cible)
	local r = Relais()
	if not r or not r[cible] or not next(r[cible]) or transmissionPrevue[cible] then return end
	transmissionPrevue[cible] = true
	C_Timer.After(2 + math.random() * 6, function()
		transmissionPrevue[cible] = nil
		local liste = r[cible]
		if not liste then return end
		local maintenant = Maintenant()
		local limite = maintenant - GARDE_RELAIS
		for k, d in pairs(liste) do
			if (d.t or 0) < limite then
				liste[k] = nil
			elseif maintenant - (d.t or 0) >= 20 then
				-- 20 s sans accusé de réception : le donneur ne l'a pas eue
				Envoyer(("R~%s~%s~%d~%d"):format(cible, d.nom, d.objet, d.quand))
				liste[k] = nil
			end
		end
		if not next(liste) then r[cible] = nil end
	end)
end
-- Donneurs en ligne qui ont des demandes en attente (à ma connexion, quand la liste de guilde change)
-- Purge à la connexion : listes de dons sans nouvelles depuis 30 jours, demandes gardées pour un
-- absent depuis plus de 14 jours (toutes guildes)
local function PurgerAnciennes()
	local db = DB()
	local limite = Maintenant() - OUBLI
	if type(db.echanges) == "table" then
		for _, g in pairs(db.echanges) do
			if type(g) == "table" then
				for cle, e in pairs(g) do
					if type(e) ~= "table" or (e.vu or 0) < limite then g[cle] = nil end
				end
			end
		end
	end
	if type(db.relaisDons) == "table" then
		local limiteR = Maintenant() - GARDE_RELAIS
		for nomG, r in pairs(db.relaisDons) do
			if type(r) ~= "table" then
				db.relaisDons[nomG] = nil
			else
				for cible, liste in pairs(r) do
					if type(liste) == "table" then
						for k, d in pairs(liste) do
							if type(d) ~= "table" or (d.t or 0) < limiteR then liste[k] = nil end
						end
					end
					if type(liste) ~= "table" or not next(liste) then r[cible] = nil end
				end
			end
		end
	end
end

local function TransmettreAuxConnectes()
	local r = Relais()
	if not r or not ns.EnLigneMembre then return end
	for cible in pairs(r) do
		if ns.EnLigneMembre(cible) then Transmettre(cible) end
	end
end
-- J'ai reçu une demande : accusé à la guilde, pour que personne ne la garde pour moi
local function Accuser(nomDem, objet, quand)
	Envoyer(("A~%s~%d~%d"):format(nomDem, objet, quand or 0))
end

-- Bulle de résumé pour les demandes arrivées pendant mon absence (regroupées)
local resumePrevu, resumeN = false, 0
local function ResumerAbsence()
	resumeN = resumeN + 1
	if resumePrevu then return end
	resumePrevu = true
	C_Timer.After(4, function()
		resumePrevu = false
		local n = resumeN
		resumeN = 0
		if ns.Notifier then
			ns.Notifier("plans", "Demande de don", ("%d demande%s de dons pendant ton absence"):format(n, n > 1 and "s" or ""),
				"TELL_MESSAGE", function() if ns.OuvrirEchanges then ns.OuvrirEchanges(nil, DEMANDES) end end)
		end
	end)
end

-- Relais des listes : à la connexion d'un membre, un membre en ligne lui renvoie aussi les listes de
-- dons des absents (avec leur date, heure du serveur : chacun garde la plus récente)
local relayees = {}   -- [cle] = moment où une liste de ce membre est passée (envoyée ou reçue)
local function RelayerListes(pour)
	C_Timer.After(3 + math.random() * 7, function()
		local g = Guilde()
		if not g then return end
		-- un seul relais pour toute la guilde
		if ns.EstLeRelais and not ns.EstLeRelais(pour) then return end
		for qui, e in pairs(g) do
			if type(e) == "table" and qui ~= pour and not qui:find("#test", 1, true)
				and (e.vu or 0) >= Maintenant() - OUBLI and not (ns.MembreGuilde and ns.MembreGuilde(qui) == false)
				and not (ns.EnLigneMembre and ns.EnLigneMembre(qui)) -- connecté : il répond lui-même
				and not (relayees[qui] and GetTime() - relayees[qui] < 30) then
				relayees[qui] = GetTime()
				local mots = {}
				for o, d in pairs(e.liste or {}) do
					mots[#mots + 1] = ("%d:%d:%s:%d"):format(o, d.q or 1, d.c or "", d.n or 0)
				end
				local morceaux = ns.Morceaux(mots, TAILLE_MORCEAU - 30)
				for i, txt in ipairs(morceaux) do
					Envoyer(("W~%s~%d~%d~%d~%s"):format(qui, e.maj or e.vu or 0, i, #morceaux, txt))
				end
			end
		end
	end)
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle, nom = Normaliser(expediteur), expediteur
	local moi = MaCle()
	if cle == moi then
		if not TestSolo() then return end
		cle, nom = cle .. "#test", expediteur .. " (test)"
	end
	local genre = msg:sub(1, 1)
	local reste = msg:sub(3)

	if genre == "Q" then
		if pret and next(Dons()) then C_Timer.After(1 + math.random() * 4, EnvoyerMaListe) end
		Transmettre(cle) -- il vient de se connecter : ses demandes en attente lui partent
		if pret then RelayerListes(cle) end -- et les listes de dons des absents

	elseif genre == "L" or genre == "W" then
		-- L : liste du donneur lui-même ; W : liste d'un autre membre, renvoyée par un relais
		--   "W~cle~date~part~total~…"
		local qui, date, part, total, mots
		if genre == "L" then
			qui, date = cle, Maintenant()
			part, total, mots = reste:match("^(%d+)~(%d+)~?(.*)$")
		else
			qui, date, part, total, mots = reste:match("^([^~]+)~(%d+)~(%d+)~(%d+)~?(.*)$")
			date = tonumber(date)
			-- une date dans le futur gagnerait contre toutes les listes à venir : refusée
			if not qui or not date or qui == moi or date > Maintenant() + 60 then return end
		end
		part, total = tonumber(part), tonumber(total)
		if not part or not total or total < 1 or total > 30 or part > total then return end
		relayees[qui] = GetTime()
		-- un envoi = type + membre concerné + expéditeur réel (+ date pour un relais) : deux relais
		-- simultanés de la même liste ne se mélangent plus
		local parts = reassembleur:Ajouter(genre .. qui .. "|" .. cle, genre == "W" and date or nil, part, total, mots)
		if not parts then return end
		local g = Guilde()
		if not g then return end
		local liste = {}
		for i = 1, #parts do
			for o, q, c, n in parts[i]:gmatch("(%d+):(%d+):(%a*):(%d+)") do
				o = tonumber(o)
				if o then liste[o] = { q = tonumber(q) or 1, c = c ~= "" and c or nil, n = tonumber(n) or 0 } end
			end
		end
		-- on garde la liste la plus récente (une liste vide reste notée : dons retirés)
		local e = g[qui]
		if e and (e.maj or e.vu or 0) > date then return end
		local ancienne = e and e.liste or {}
		g[qui] = { nom = (genre == "L") and nom or (e and e.nom) or qui, vu = date, maj = date, liste = liste }
		for objet, d in pairs(liste) do
			Precharger(objet)
			-- nouveau plan proposé : bulle selon mon métier (pas pendant le calme de connexion)
			if genre == "L" and not ancienne[objet] and d.c and GetTime() - debut > CALME then
				local place = MaPlace(d.c, d.n)
				if place == "ok" then
					C_Timer.After(1, function() AlerteDon(cle, nom, objet, d) end)
				elseif place == "bas" then
					C_Timer.After(DELAI_SANS_NIVEAU, function() AlerteDon(cle, nom, objet, d) end)
				end
			end
		end
		if MajTout then MajTout() end

	elseif genre == "M" then
		local donneur, objet = reste:match("^([^~]+)~(%d+)")
		objet = tonumber(objet)
		if not donneur or not objet then return end
		NoterMerci(donneur, cle, objet, Maintenant())
		if (donneur == moi or (TestSolo() and donneur == moi .. "#test")) and ns.Notifier then
			local nomO, lien = InfoObjet(objet)
			ns.Notifier("plans", "Merci !", ("%s te remercie pour %s"):format(NomCourt(nom), lien or nomO or ("l'objet " .. objet)),
				nil, function() end)
		end
		if MajTout then MajTout() end

	elseif genre == "R" then
		-- demande faite pendant l'absence de « cible », renvoyée par un membre
		local cible, nomDem, objet, quand = strsplit("~", reste)
		objet, quand = tonumber(objet), tonumber(quand)
		if not cible or not nomDem or not objet then return end
		-- demandeur inconnu de la guilde, ou date dans le futur : ignoré
		if ns.MembreGuilde and ns.MembreGuilde(Normaliser(nomDem)) == false then return end
		if quand and quand > Maintenant() + 60 then return end
		local r = Relais()
		if r and r[cible] then r[cible][Normaliser(nomDem) .. ":" .. objet .. ":" .. (quand or 0)] = nil end
		if cible == moi or (TestSolo() and cible == moi .. "#test") then
			if NoterDemande(nomDem, objet, quand) then ResumerAbsence() end
			Accuser(nomDem, objet, quand)
			if MajTout then MajTout() end
		end

	elseif genre == "A" then
		-- le donneur (expéditeur) a bien reçu cette demande : on oublie notre copie
		local nomDem, objet, quand = strsplit("~", reste)
		objet, quand = tonumber(objet), tonumber(quand)
		if not nomDem or not objet then return end
		local r = Relais()
		local cible = cle:gsub("#test$", "")
		if r and r[cible] then
			r[cible][Normaliser(nomDem) .. ":" .. objet .. ":" .. (quand or 0)] = nil
			if not next(r[cible]) then r[cible] = nil end
		end

	elseif genre == "D" then
		local objet, cible, quand = strsplit("~", reste)
		objet, quand = tonumber(objet), tonumber(quand) or Maintenant()
		if not objet or not cible then return end
		if not (cible == moi or (TestSolo() and cible == moi .. "#test")) then
			-- pour un autre : je garde la demande jusqu'à son accusé de réception (« A ») ; s'il était
			-- en fait hors ligne, elle lui sera renvoyée à sa connexion
			GarderPourPlusTard(cible, nom, objet, quand)
			return
		end
		NoterDemande(nom, objet, quand)
		Accuser(nom, objet, quand)
		local nomO, lien = InfoObjet(objet)
		if ns.Notifier then
			-- sans son : le message privé du demandeur sonne déjà
			ns.Notifier("plans", "Demande de don", ("%s voudrait %s"):format(NomCourt(nom), lien or nomO or ("l'objet " .. objet)),
				"aucun", function()
					local nomMP = cle:find("#test", 1, true) and UnitName("player")
						or (ns.NomListeGuilde and ns.NomListeGuilde(cle)) or NomCourt(nom)
					if ChatFrame_SendTell then ChatFrame_SendTell(nomMP) end
				end)
		end
		if MajTout then MajTout() end
	end
end

local function Demander(d)
	local k = d.cle .. d.objet
	if mesDemandes[k] then return end
	mesDemandes[k] = true
	local quand = Maintenant()
	Envoyer(("D~%d~%s~%d"):format(d.objet, d.cle, quand))
	if ns.DemanderRoster then ns.DemanderRoster() end
	-- je garde aussi la demande jusqu'à l'accusé de réception du donneur : s'il vient de se
	-- déconnecter (encore vu « en ligne »), elle lui arrivera à sa prochaine connexion
	local prenom, famille = UnitFullName("player")
	GarderPourPlusTard(d.cle, famille and famille ~= "" and (prenom .. "-" .. famille) or prenom, d.objet, quand)
	if not d.enLigne then
		local nomO, lien = InfoObjet(d.objet)
		if ns.Notifier then
			ns.Notifier("plans", "Demande de don", ("%s est hors ligne : ta demande pour %s lui sera transmise dès que possible"):format(
				NomCourt(d.e.nom), lien or nomO or ("objet " .. d.objet)), "aucun", function() end)
		end
		if MajTout then MajTout() end
		return
	end
	-- message privé du demandeur : le donneur en garde la trace dans sa discussion
	if not d.cle:find("#test", 1, true) then
		local nomMP = (ns.NomListeGuilde and ns.NomListeGuilde(d.cle)) or NomCourt(d.e.nom)
		local _, lien = InfoObjet(d.objet)
		local envoi = (C_ChatInfo and C_ChatInfo.SendChatMessage) or SendChatMessage
		if envoi and nomMP then
			pcall(envoi, "Je serais intéressé par ton don : " .. (lien or ("objet " .. d.objet)) .. " — merci !",
				"WHISPER", nil, nomMP)
		end
	end
	if MajTout then MajTout() end
end

--------------------------------------------------------------------------------
-- Fenêtre
--------------------------------------------------------------------------------

local Depuis = ns.Depuis

local function DansLaGuilde(cle)
	if cle:find("#test", 1, true) then return TestSolo() end
	if ns.MembreGuilde then return ns.MembreGuilde(cle) ~= false end
	return true
end

-- Tous les dons de la guilde (hors les miens), filtrés par catégorie et recherche
local categorie, recherche = 1, ""
-- L'objet (classe donnée) entre-t-il dans cette catégorie ?
local function Classee(cat, classe)
	if cat.autres then return not CLASSES_RANGEES[classe or -1] end
	if cat.classes then return cat.classes[classe or -1] == true end
	return true
end

local comptes = {}       -- [catégorie] = nombre de dons de la guilde
local function DonsGuilde()
	local g = Guilde() or {}
	local res = {}
	wipe(comptes)
	local limite = Maintenant() - OUBLI
	local cat = CATEGORIES[categorie]
	for cle, e in pairs(g) do
		if type(e) ~= "table" or (e.vu or 0) < limite then
			g[cle] = nil
		elseif DansLaGuilde(cle) then
			local enLigne = ns.EnLigneMembre and ns.EnLigneMembre(cle) or false
			for objet, d in pairs(e.liste or {}) do
				local classe = ClasseObjet(objet)
				local nomO, _, qualite, niveau = InfoObjet(objet)
				local trouve = recherche == "" or Simplifier(nomO):find(recherche, 1, true) ~= nil
				-- compteurs des catégories (avec la recherche en cours)
				if trouve then
					for i, c in ipairs(CATEGORIES) do
						if Classee(c, classe) then comptes[i] = (comptes[i] or 0) + 1 end
					end
				end
				if trouve and Classee(cat, classe) then
					res[#res + 1] = { cle = cle, e = e, objet = objet, d = d, enLigne = enLigne, nomO = nomO or "",
						qualite = qualite, niveau = niveau, place = d.c and MaPlace(d.c, d.n) or nil }
				end
			end
		end
	end
	local rangPlace = { ok = 1, bas = 2 }
	table.sort(res, function(a, b)
		local pa, pb = rangPlace[a.place or ""] or 3, rangPlace[b.place or ""] or 3
		if pa ~= pb then return pa < pb end
		if a.enLigne ~= b.enLigne then return a.enLigne end
		if a.nomO ~= b.nomO then return a.nomO < b.nomO end
		return (a.e.nom or "") < (b.e.nom or "")
	end)
	return res
end

local function NombreDons()
	local n = 0
	for cle, e in pairs(Guilde() or {}) do
		if type(e) == "table" and DansLaGuilde(cle) then for _ in pairs(e.liste or {}) do n = n + 1 end end
	end
	return n
end

local function CouleurQualite(fs, qualite, ok)
	local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
	if qc and ok then fs:SetTextColor(qc.r, qc.g, qc.b) else fs:SetTextColor(1, 0.82, 0) end
end

local function InfobulleObjet(cadre)
	cadre:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		GameTooltip:Show()
	end)
	cadre:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function Colonne(parent, texte, x, largeur, alignement)
	local t = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	t:SetPoint("LEFT", parent, "LEFT", x, 0)
	t:SetWidth(largeur)
	t:SetJustifyH(alignement or "LEFT")
	t:SetText(texte)
	return t
end

local function Defilement(p, x1, y1, x2)
	local defile = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", fen, "TOPLEFT", x1, y1)
	defile:SetPoint("BOTTOMRIGHT", fen, "BOTTOMRIGHT", x2, 16)
	local contenu = CreateFrame("Frame", nil, defile)
	contenu:SetSize(defile:GetWidth() > 0 and defile:GetWidth() or 400, 10)
	defile:SetScrollChild(contenu)
	local vide = p:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	vide:SetPoint("TOP", defile, "TOP", 0, -40)
	vide:SetWidth(300)
	return defile, contenu, vide
end

local function BoiteRecherche(p, nom, x, y, largeur, aide, Changer)
	local ok, boite = pcall(CreateFrame, "EditBox", nom, p, "SearchBoxTemplate")
	if not ok then boite = CreateFrame("EditBox", nom, p, "InputBoxTemplate") end
	boite:SetSize(largeur, 20)
	boite:SetPoint("TOPLEFT", fen, "TOPLEFT", x, y)
	boite:SetAutoFocus(false)
	if boite.Instructions then boite.Instructions:SetText(aide) end
	boite:HookScript("OnTextChanged", function(self) Changer(Simplifier(strtrim(self:GetText() or ""))) end)
	boite:HookScript("OnEscapePressed", function(self) self:ClearFocus() end)
	return boite
end

---------------------------------------------------------------- Parcourir
local pageParcourir, lignesP, boutonsCats = nil, {}, {}
local LARGEUR_LISTE = LARGEUR - LARGEUR_CATS - 52

local function CreerLigneDon(parent)
	local b = CreateFrame("Frame", nil, parent)
	b:SetSize(LARGEUR_LISTE, 34)
	b:EnableMouse(true)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	b.fond:SetColorTexture(1, 1, 1, 0.04)
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(28, 28)
	b.icone:SetPoint("LEFT", b, "LEFT", 3, 0)
	b.nom = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b.icone, "TOPRIGHT", 6, -1)
	b.nom:SetWidth(200)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.info = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.info:SetPoint("BOTTOMLEFT", b.icone, "BOTTOMRIGHT", 6, 1)
	b.info:SetWidth(200)
	b.info:SetJustifyH("LEFT")
	b.info:SetWordWrap(false)
	b.qte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	b.qte:SetPoint("LEFT", b, "LEFT", 240, 0)
	b.qte:SetWidth(36)
	b.qte:SetJustifyH("CENTER")
	b.niveau = b:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	b.niveau:SetPoint("LEFT", b, "LEFT", 280, 0)
	b.niveau:SetWidth(36)
	b.niveau:SetJustifyH("CENTER")
	b.donneur = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.donneur:SetPoint("TOPLEFT", b, "TOPLEFT", 324, -4)
	b.donneur:SetWidth(120)
	b.donneur:SetJustifyH("LEFT")
	b.donneur:SetWordWrap(false)
	b.etat = b:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	b.etat:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 324, 4)
	b.etat:SetWidth(120)
	b.etat:SetJustifyH("LEFT")
	b.bouton = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.bouton:SetSize(84, 22)
	b.bouton:SetPoint("RIGHT", b, "RIGHT", -2, 0)
	b.bouton:SetMotionScriptsWhileDisabled(true)
	InfobulleObjet(b)
	if ns.SonsSurBoutons then ns.SonsSurBoutons(b) end
	return b
end

local function MajParcourir()
	local p = pageParcourir
	if not p or not p:IsShown() then return end
	-- donateurs du mois (les plus remerciés)
	local top = DonateursDuMois()
	if #top > 0 then
		local noms = {}
		for i = 1, math.min(3, #top) do noms[#noms + 1] = ("%s (%d)"):format(NomCourt(top[i].qui), top[i].n) end
		p.donateurs:SetText("|cffffd100Donateurs du mois :|r " .. table.concat(noms, " · "))
	else
		p.donateurs:SetText("Les plans que tu peux apprendre passent en premier.")
	end
	for i, bt in ipairs(boutonsCats) do
		if i == categorie then bt:LockHighlight() else bt:UnlockHighlight() end
		bt.choisi:SetShown(i == categorie)
	end
	local liste = DonsGuilde()
	for i, bt in ipairs(boutonsCats) do
		local n = comptes[i] or 0
		bt.texte:SetText(n > 0 and (CATEGORIES[i].nom .. " |cff999999(" .. n .. ")|r") or ("|cff808080" .. CATEGORIES[i].nom .. "|r"))
	end
	local y = 0
	for i, d in ipairs(liste) do
		local b = lignesP[i] or CreerLigneDon(p.contenu)
		lignesP[i] = b
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", p.contenu, "TOPLEFT", 0, -y)
		b.fond:SetShown(i % 2 == 0)
		b.objet = d.objet
		local _, _, _, _, icone = InfoObjet(d.objet)
		local _, _, iconeI = ClasseObjet(d.objet)
		b.icone:SetTexture(icone or iconeI or "Interface\\Icons\\INV_Misc_QuestionMark")
		b.nom:SetText(d.nomO ~= "" and d.nomO or "|cff999999chargement…|r")
		CouleurQualite(b.nom, d.qualite, d.nomO ~= "")
		if d.d.c then
			local couleur = d.place == "ok" and "|cff33dd55" or d.place == "bas" and "|cffff9933" or "|cff999999"
			b.info:SetText(couleur .. TexteMetier(d.d.c, d.d.n) .. "|r")
		else
			b.info:SetText("")
		end
		b.qte:SetText(d.d.q or 1)
		b.niveau:SetText((d.niveau and d.niveau > 1) and d.niveau or "—")
		b.donneur:SetText(NomCourt(d.e.nom))
		b.etat:SetText(d.enLigne and "|cff33dd55en ligne|r" or ("hors ligne · " .. Depuis(d.e.vu)))
		local demande = mesDemandes[d.cle .. d.objet]
		-- après la demande : « Merci ! » (une fois le don reçu), puis « Remercié »
		local merci = demande and demande.merci
		b.bouton:SetText(merci and "Remercié" or demande and "Merci !" or "Demander")
		b.bouton:SetEnabled(not merci)
		b.bouton:SetScript("OnClick", function()
			if not demande then
				Demander(d)
			elseif not demande.merci then
				demande.merci = true
				Envoyer(("M~%s~%d"):format(d.cle, d.objet))
				if MajTout then MajTout() end
			end
		end)
		b.bouton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			if demande then
				GameTooltip:SetText(merci and "Merci envoyé" or "Merci !")
				GameTooltip:AddLine("Tu as reçu ce don ? Remercie " .. NomCourt(d.e.nom) .. " : ça compte pour les donateurs du mois.", 1, 1, 1, true)
			elseif not d.enLigne then
				GameTooltip:SetText("Demander ce don")
				GameTooltip:AddLine(NomCourt(d.e.nom) .. " est hors ligne : ta demande lui sera transmise dès que possible, par un membre de la guilde connecté avec GuildUp, ou quand vous serez connectés en même temps.", 1, 1, 1, true)
			else
				GameTooltip:SetText("Demander ce don")
				GameTooltip:AddLine("Un message privé part vers " .. NomCourt(d.e.nom) .. ".", 1, 1, 1, true)
			end
			GameTooltip:Show()
		end)
		b.bouton:SetScript("OnLeave", function() GameTooltip:Hide() end)
		b:Show()
		y = y + 36
	end
	for i = #liste + 1, #lignesP do lignesP[i]:Hide() end
	p.contenu:SetHeight(math.max(10, y))
	p.vide:SetShown(#liste == 0)
	p.vide:SetText(recherche ~= "" and "Aucun don ne correspond à ta recherche."
		or categorie > 1 and "Aucun don dans cette catégorie." or "Personne ne donne rien pour l'instant.")
end

-- Colonne des catégories (dons de la guilde et mes dons)
local function CreerCategories(p, f, boutons, Choisir)
	local fondC = p:CreateTexture(nil, "BACKGROUND")
	fondC:SetPoint("TOPLEFT", f, "TOPLEFT", 8, HAUT_ENCART - 4)
	fondC:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 10)
	fondC:SetWidth(LARGEUR_CATS)
	PoserAtlas(fondC, "Professions-background-summarylist", { 0, 0, 0, 0.25 })
	for i, c in ipairs(CATEGORIES) do
		local bt = CreateFrame("Button", nil, p)
		bt:SetSize(LARGEUR_CATS - 12, 22)
		bt:SetPoint("TOPLEFT", f, "TOPLEFT", 14, HAUT_ENCART - 10 - (i - 1) * 24)
		bt:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
		bt.choisi = bt:CreateTexture(nil, "BACKGROUND")
		bt.choisi:SetAllPoints(bt)
		bt.choisi:SetColorTexture(1, 0.82, 0, 0.18)
		bt.texte = bt:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		bt.texte:SetPoint("LEFT", bt, "LEFT", 8, 0)
		bt.texte:SetText(c.nom)
		bt:SetScript("OnClick", function() Choisir(i) end)
		boutons[i] = bt
	end
end

local function CreerParcourir(f)
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	local titre = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", f, "TOPLEFT", 70, -32)
	titre:SetText("Dons de la guilde")
	BoiteRecherche(p, "GuildUpEchangesRecherche", 76, -58, 220, "Chercher un objet", function(t)
		recherche = t
		MajParcourir()
	end)
	local aide = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	aide:SetPoint("TOPLEFT", f, "TOPLEFT", 310, -62)
	aide:SetText("Les plans que tu peux apprendre passent en premier.")
	p.donateurs = aide

	-- catégories (colonne de gauche)
	CreerCategories(p, f, boutonsCats, function(i)
		categorie = i
		p.defile:SetVerticalScroll(0)
		MajParcourir()
	end)

	-- en-têtes de colonnes
	local x0 = LARGEUR_CATS + 20
	local entete = CreateFrame("Frame", nil, p)
	entete:SetSize(LARGEUR_LISTE, 18)
	entete:SetPoint("TOPLEFT", f, "TOPLEFT", x0, HAUT_ENCART - 8)
	Colonne(entete, "Objet", 36, 180)
	Colonne(entete, "Qté", 240, 36, "CENTER")
	Colonne(entete, "Niv.", 280, 36, "CENTER")
	Colonne(entete, "Donneur", 324, 120)
	local fondL = p:CreateTexture(nil, "BACKGROUND")
	fondL:SetPoint("TOPLEFT", f, "TOPLEFT", x0 - 4, HAUT_ENCART - 4)
	fondL:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 10)
	PoserAtlas(fondL, "Professions-Recipe-Background", { 0, 0, 0, 0.2 })

	p.defile, p.contenu, p.vide = Defilement(p, x0, HAUT_ENCART - 30, -30)
	p.contenu:SetWidth(LARGEUR_LISTE)
	p:SetScript("OnShow", MajParcourir)
	pageParcourir = p
	return p
end

---------------------------------------------------------------- Mes dons
-- Comme les besoins : on glisse un objet dans la case d'ajout, avec la quantité à
-- donner. Seuls les objets que j'ai (sacs ou banque) et qui ne sont pas liés peuvent être donnés.
local pageMes, lignesM, boutonsCatsMes = nil, {}, {}
local rechercheMes, categorieMes = "", 1
local choixDon


-- Quantité donnée : celle choisie, jamais plus que ce que j'ai
local function QteDonnee(objet)
	local o = mesObjets[objet]
	if not o then return 0 end
	local v = Dons()[objet]
	if type(v) == "number" and v > 0 then return math.min(v, o.nombre) end
	return o.nombre
end
ns.QteDonnee = QteDonnee

local function AjouterDon(objet, qte)
	if not objet then Erreur("Choisis d'abord un objet (glisse-le dans la case)"); return false end
	local o = mesObjets[objet]
	if not o then Erreur("Cet objet n'est pas dans tes sacs ni ta banque (ou il est lié)"); return false end
	Dons()[objet] = math.max(1, math.min(o.nombre, math.floor(qte or o.nombre)))
	EnvoyerMaListe()
	if MajTout then MajTout() end
	return true
end

local function RetirerDon(objet)
	Dons()[objet] = nil
	EnvoyerMaListe()
	if MajTout then MajTout() end
end

local function CreerLigneMien(parent, largeur)
	local b = CreateFrame("Frame", nil, parent)
	b:SetSize(largeur, 34)
	b:EnableMouse(true)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	b.fond:SetColorTexture(1, 1, 1, 0.04)
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(28, 28)
	b.icone:SetPoint("LEFT", b, "LEFT", 3, 0)
	b.nom = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b.icone, "TOPRIGHT", 6, -1)
	b.nom:SetWidth(largeur - 140)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.info = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.info:SetPoint("BOTTOMLEFT", b.icone, "BOTTOMRIGHT", 6, 1)
	b.info:SetWidth(largeur - 140)
	b.info:SetJustifyH("LEFT")
	b.info:SetWordWrap(false)
	b.retirer = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.retirer:SetSize(84, 22)
	b.retirer:SetPoint("RIGHT", b, "RIGHT", -2, 0)
	b.retirer:SetText("Retirer")
	b.retirer:SetScript("OnClick", function() if b.objet then RetirerDon(b.objet) end end)
	InfobulleObjet(b)
	if ns.SonsSurBoutons then ns.SonsSurBoutons(b) end
	return b
end

local function MajChoixDon()
	local p = pageMes
	if not p then return end
	local z = p.ajout
	local o = choixDon and mesObjets[choixDon]
	if choixDon then
		local nom, lien, _, _, icone = InfoObjet(choixDon)
		local _, _, iconeI = ClasseObjet(choixDon)
		z.icone:SetTexture(icone or iconeI or "Interface\\Icons\\INV_Misc_QuestionMark")
		z.icone:SetDesaturated(false)
		z.nom:SetText((lien or nom or ("Objet " .. choixDon))
			.. (o and ("  |cff999999(tu en as " .. o.nombre .. ")|r") or "  |cffff6666(pas dans tes affaires, ou lié)|r"))
	else
		z.icone:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
		z.icone:SetDesaturated(true)
		z.nom:SetText("|cff999999Glisse ici un objet de tes sacs (ou de ta banque ouverte)|r")
	end
	z.ajouter:SetEnabled(o ~= nil)
end

local function ChoisirDon(objet)
	choixDon = objet
	local o = objet and mesObjets[objet]
	if pageMes then
		pageMes.ajout.qte:SetText(o and tostring(Dons()[objet] and QteDonnee(objet) or o.nombre) or "1")
	end
	MajChoixDon()
end

local function MajMes()
	local p = pageMes
	if not p or not p:IsShown() then return end
	for i, bt in ipairs(boutonsCatsMes) do
		if i == categorieMes then bt:LockHighlight() else bt:UnlockHighlight() end
		bt.choisi:SetShown(i == categorieMes)
	end
	MajChoixDon()
	local cat = CATEGORIES[categorieMes]
	local liste, comptesMes = {}, {}
	for objet in pairs(Dons()) do
		local o = mesObjets[objet]
		if o then
			local nomO, _, qualite = InfoObjet(objet)
			if rechercheMes == "" or Simplifier(nomO):find(rechercheMes, 1, true) then
				for i, c in ipairs(CATEGORIES) do
					if Classee(c, o.classe) then comptesMes[i] = (comptesMes[i] or 0) + 1 end
				end
				if Classee(cat, o.classe) then liste[#liste + 1] = { o = o, nomO = nomO or "", qualite = qualite } end
			end
		end
	end
	for i, bt in ipairs(boutonsCatsMes) do
		local n = comptesMes[i] or 0
		bt.texte:SetText(n > 0 and (CATEGORIES[i].nom .. " |cff999999(" .. n .. ")|r") or ("|cff808080" .. CATEGORIES[i].nom .. "|r"))
	end
	table.sort(liste, function(a, b) return a.nomO < b.nomO end)
	local y = 0
	for i, d in ipairs(liste) do
		local b = lignesM[i] or CreerLigneMien(p.contenu, LARGEUR_LISTE)
		lignesM[i] = b
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", p.contenu, "TOPLEFT", 0, -y)
		b.fond:SetShown(i % 2 == 0)
		b.objet = d.o.objet
		local _, _, _, _, icone = InfoObjet(d.o.objet)
		local _, _, iconeI = ClasseObjet(d.o.objet)
		b.icone:SetTexture(icone or iconeI or "Interface\\Icons\\INV_Misc_QuestionMark")
		b.nom:SetText(d.nomO ~= "" and d.nomO or "|cff999999chargement…|r")
		CouleurQualite(b.nom, d.qualite, d.nomO ~= "")
		local qte = QteDonnee(d.o.objet)
		local infos = ("Donne x%d"):format(qte)
		if qte < d.o.nombre then infos = infos .. (" (sur %d)"):format(d.o.nombre) end
		infos = infos .. " · " .. d.o.lieu
		if d.o.code then infos = infos .. " · " .. TexteMetier(d.o.code, d.o.niveau) end
		local n = 0
		n = NombreDemandes(d.o.objet)
		if n > 0 then infos = infos .. ("  |cff33dd55%d demande%s|r"):format(n, n > 1 and "s" or "") end
		b.info:SetText(infos)
		b:Show()
		y = y + 36
	end
	for i = #liste + 1, #lignesM do lignesM[i]:Hide() end
	p.contenu:SetHeight(math.max(10, y))
	p.vide:SetShown(#liste == 0)
	p.vide:SetText(rechercheMes ~= "" and "Aucun de tes dons ne correspond à ta recherche."
		or categorieMes > 1 and "Aucun don dans cette catégorie."
		or "Tu ne donnes rien pour l'instant : glisse un objet dans la case ci-dessus.")
end

local function CreerMes(f)
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	pageMes = p
	local titre = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", f, "TOPLEFT", 70, -32)
	titre:SetText("Mes dons")
	BoiteRecherche(p, "GuildUpEchangesRechercheMes", 76, -58, 220, "Chercher dans mes dons", function(t)
		rechercheMes = t
		MajMes()
	end)
	local aide = p:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
	aide:SetPoint("TOPLEFT", f, "TOPLEFT", 310, -62)
	aide:SetText("Objets de tes sacs ou de ta banque, non liés.")

	CreerCategories(p, f, boutonsCatsMes, function(i)
		categorieMes = i
		p.defile:SetVerticalScroll(0)
		MajMes()
	end)

	local x0 = LARGEUR_CATS + 20
	local fondL = p:CreateTexture(nil, "BACKGROUND")
	fondL:SetPoint("TOPLEFT", f, "TOPLEFT", x0 - 4, HAUT_ENCART - 4)
	fondL:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 10)
	PoserAtlas(fondL, "Professions-Recipe-Background", { 0, 0, 0, 0.2 })

	-- zone d'ajout : [case objet] nom (tu en as N) / Quantité [ N ] [Donner]
	local z = CreateFrame("Button", nil, p)
	z:SetSize(LARGEUR_LISTE, 56)
	z:SetPoint("TOPLEFT", f, "TOPLEFT", x0, HAUT_ENCART - 8)
	p.ajout = z
	local cadre = z:CreateTexture(nil, "BACKGROUND")
	cadre:SetAllPoints(z)
	cadre:SetColorTexture(0, 0, 0, 0.35)
	z.case = CreateFrame("Button", nil, z)
	z.case:SetSize(36, 36)
	z.case:SetPoint("LEFT", z, "LEFT", 8, 0)
	z.icone = z.case:CreateTexture(nil, "ARTWORK")
	z.icone:SetAllPoints(z.case)
	z.case:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	z.nom = z:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	z.nom:SetPoint("TOPLEFT", z.case, "TOPRIGHT", 8, -2)
	z.nom:SetPoint("RIGHT", z, "RIGHT", -100, 0)
	z.nom:SetJustifyH("LEFT")
	z.nom:SetWordWrap(false)
	local tq = z:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	tq:SetPoint("BOTTOMLEFT", z.case, "BOTTOMRIGHT", 8, 0)
	tq:SetText("Quantité")
	z.qte = CreateFrame("EditBox", nil, z, "InputBoxTemplate")
	z.qte:SetSize(44, 18)
	z.qte:SetPoint("LEFT", tq, "RIGHT", 10, 0)
	z.qte:SetAutoFocus(false)
	z.qte:SetNumeric(true)
	z.qte:SetMaxLetters(4)
	z.qte:SetText("1")
	z.qte:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	z.ajouter = CreateFrame("Button", nil, z, "UIPanelButtonTemplate")
	z.ajouter:SetSize(84, 22)
	z.ajouter:SetPoint("RIGHT", z, "RIGHT", -8, 0)
	z.ajouter:SetText("Donner")
	z.ajouter:SetScript("OnClick", function()
		z.qte:ClearFocus()
		if AjouterDon(choixDon, tonumber(z.qte:GetText())) then ChoisirDon(nil) end
	end)
	ns.BrancherDepot({ z, z.case }, function(o) ChoisirDon(o) end, function() return choixDon end)
	z.case:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if choixDon then
			pcall(GameTooltip.SetItemByID, GameTooltip, choixDon)
			GameTooltip:AddLine("Clic droit : retirer l'objet de la case", 0.6, 0.6, 0.6)
		else
			GameTooltip:SetText("Objet à donner")
			GameTooltip:AddLine("Glisse ici un objet de tes sacs, ou de ta banque quand elle est ouverte.", 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	z.case:SetScript("OnLeave", function() GameTooltip:Hide() end)
	if ns.SonsSurBoutons then ns.SonsSurBoutons(z) end

	p.defile, p.contenu, p.vide = Defilement(p, x0, HAUT_ENCART - 70, -30)
	p.contenu:SetWidth(LARGEUR_LISTE)
	p:SetScript("OnShow", function() LireMesObjets() end)
	return p
end


---------------------------------------------------------------- Demandes
local pageDemandes, lignesD = nil, {}

local function CreerLigneDemande(parent, largeur)
	local b = CreateFrame("Frame", nil, parent)
	b:SetSize(largeur, 36)
	b:EnableMouse(true)
	b.fond = b:CreateTexture(nil, "BACKGROUND")
	b.fond:SetAllPoints(b)
	b.fond:SetColorTexture(1, 1, 1, 0.04)
	b.nouveau = b:CreateTexture(nil, "BORDER")
	b.nouveau:SetPoint("TOPLEFT", b, "TOPLEFT", 0, 0)
	b.nouveau:SetPoint("BOTTOMLEFT", b, "BOTTOMLEFT", 0, 0)
	b.nouveau:SetWidth(3)
	b.nouveau:SetColorTexture(0.25, 1, 0.4, 0.9)
	b.icone = b:CreateTexture(nil, "ARTWORK")
	b.icone:SetSize(28, 28)
	b.icone:SetPoint("LEFT", b, "LEFT", 6, 0)
	b.nom = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b.icone, "TOPRIGHT", 6, -1)
	b.nom:SetPoint("RIGHT", b, "RIGHT", -190, 0)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.info = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.info:SetPoint("BOTTOMLEFT", b.icone, "BOTTOMRIGHT", 6, 1)
	b.info:SetPoint("RIGHT", b, "RIGHT", -190, 0)
	b.info:SetJustifyH("LEFT")
	b.info:SetWordWrap(false)
	b.effacer = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.effacer:SetSize(80, 22)
	b.effacer:SetPoint("RIGHT", b, "RIGHT", -2, 0)
	b.effacer:SetText("Effacer")
	b.mp = CreateFrame("Button", nil, b, "UIPanelButtonTemplate")
	b.mp:SetSize(90, 22)
	b.mp:SetPoint("RIGHT", b.effacer, "LEFT", -4, 0)
	b.mp:SetText("Chuchoter")
	InfobulleObjet(b)
	if ns.SonsSurBoutons then ns.SonsSurBoutons(b) end
	return b
end

MajDemandes = function()
	local p = pageDemandes
	if not p or not p:IsVisible() then return end
	local h = Historique()
	local y = 0
	for i, d in ipairs(h) do
		local b = lignesD[i] or CreerLigneDemande(p.contenu, p.largeur)
		lignesD[i] = b
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", p.contenu, "TOPLEFT", 0, -y)
		b.fond:SetShown(i % 2 == 0)
		b.nouveau:SetShown(not d.vu)
		b.objet = d.objet
		local nomO, _, qualite, _, icone = InfoObjet(d.objet)
		local _, _, iconeI = ClasseObjet(d.objet)
		b.icone:SetTexture(icone or iconeI or "Interface\\Icons\\INV_Misc_QuestionMark")
		b.nom:SetText(nomO or "|cff999999chargement…|r")
		CouleurQualite(b.nom, qualite, nomO ~= nil)
		local cle = Normaliser(d.nom)
		local enLigne = ns.EnLigneMembre and ns.EnLigneMembre(cle) or false
		local encore = Dons()[d.objet] and "" or "  |cff999999(plus dans tes dons)|r"
		b.info:SetText(("par %s · il y a %s · %s%s"):format(NomCourt(d.nom), Depuis(d.quand),
			enLigne and "|cff33dd55en ligne|r" or "|cff999999hors ligne|r", encore))
		b.mp:SetEnabled(enLigne)
		b.mp:SetScript("OnClick", function()
			local nomMP = (ns.NomListeGuilde and ns.NomListeGuilde(cle)) or NomCourt(d.nom)
			if ChatFrame_SendTell then ChatFrame_SendTell(nomMP) end
		end)
		b.effacer:SetScript("OnClick", function()
			for k, x in ipairs(Historique()) do
				if x == d then table.remove(Historique(), k); break end
			end
			MajTout()
		end)
		b:Show()
		y = y + 38
	end
	for i = #h + 1, #lignesD do lignesD[i]:Hide() end
	p.contenu:SetHeight(math.max(10, y))
	p.vide:SetShown(#h == 0)
	p.toutEffacer:SetEnabled(#h > 0)
end

local function CreerDemandes(f)
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	p.largeur = LARGEUR - 60
	pageDemandes = p
	local titre = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", f, "TOPLEFT", 70, -32)
	titre:SetText("Demandes reçues")
	local aide = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	aide:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -6)
	aide:SetWidth(LARGEUR - 260)
	aide:SetJustifyH("LEFT")
	aide:SetText("Qui t'a demandé un de tes dons (gardé 30 jours). Les demandes faites pendant ton absence arrivent quand un membre avec GuildUp est connecté en même temps que toi.")
	p.toutEffacer = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
	p.toutEffacer:SetSize(110, 22)
	p.toutEffacer:SetPoint("TOPRIGHT", f, "TOPRIGHT", -14, -58)
	p.toutEffacer:SetText("Tout effacer")
	p.toutEffacer:SetScript("OnClick", function()
		wipe(Historique())
		MajTout()
	end)
	local fond = p:CreateTexture(nil, "BACKGROUND")
	fond:SetPoint("TOPLEFT", f, "TOPLEFT", 8, HAUT_ENCART - 4)
	fond:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 10)
	PoserAtlas(fond, "Professions-background-summarylist", { 0, 0, 0, 0.25 })
	p.defile, p.contenu, p.vide = Defilement(p, 14, HAUT_ENCART - 10, -30)
	p.contenu:SetWidth(p.largeur)
	p.vide:SetText("Personne ne t'a encore demandé de don.")
	-- en ouvrant l'onglet, les demandes sont « vues » (le compteur de l'onglet retombe)
	p:SetScript("OnShow", function()
		MajDemandes()
		C_Timer.After(1.5, function()
			if not p:IsVisible() then return end
			for _, d in ipairs(Historique()) do d.vu = true end
			MajTout()
		end)
	end)
	return p
end

---------------------------------------------------------------- Fenêtre et onglets
local NOMS_ONGLETS = { "Dons", "Mes dons", "Demandes", "Besoins" }
local function MajOnglets()
	if not fen or not fen.onglets then return end
	local compteurs = { NombreDons(), 0, NombreDemandes(nil, true), ns.NombreBesoins and ns.NombreBesoins() or 0 }
	for i, o in ipairs(fen.onglets) do
		local n = compteurs[i] or 0
		if i == MES_DONS then for _ in pairs(Dons()) do n = n + 1 end end
		o:SetText(n > 0 and (NOMS_ONGLETS[i] .. " |cff33dd55(" .. n .. ")|r") or NOMS_ONGLETS[i])
		if PanelTemplates_TabResize then pcall(PanelTemplates_TabResize, o, 0) end
	end
end
ns.MajOngletsEchanges = MajOnglets

MajTout = function()
	MajOnglets()
	if MajDemandes then MajDemandes() end
	MajParcourir()
	MajMes()
end

-- Fenêtre à onglets (cadre à portrait, bande de pierre, encart illustré), partagée avec la fenêtre
-- Artisanat (GuildUp_Artisanat.lua). pages : fonctions (f) -> page ; noms : textes des onglets.
local function FenetreOnglets(nom, titre, icone, fonds, pages, noms)
	local ok, f = pcall(CreateFrame, "Frame", nom, UIParent, "PortraitFrameTemplate")
	if not ok then
		ok, f = pcall(CreateFrame, "Frame", nom, UIParent, "BasicFrameTemplateWithInset")
		if not ok then f = CreateFrame("Frame", nom, UIParent) end
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
	tinsert(UISpecialFrames, nom)
	if f.SetTitle then pcall(f.SetTitle, f, titre)
	elseif f.TitleText then f.TitleText:SetText(titre) end
	if f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, icone) end

	local pierre = f:CreateTexture(nil, "BACKGROUND", nil, -5)
	pierre:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -21)
	pierre:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -2, HAUT_ENCART - 7)
	PoserAtlas(pierre, "groupfinder-Stat-StoneBG", { 0.12, 0.1, 0.08, 1 })
	local encart = CreateFrame("Frame", nil, f)
	encart:SetPoint("TOPLEFT", f, "TOPLEFT", 4, HAUT_ENCART)
	encart:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -4, 3)
	encart:SetFrameLevel(f:GetFrameLevel() + 1)
	local illustration = encart:CreateTexture(nil, "BACKGROUND")
	illustration:SetPoint("TOPLEFT", encart, "TOPLEFT", 3, -3)
	illustration:SetPoint("BOTTOMRIGHT", encart, "BOTTOMRIGHT", -3, 3)
	local pose = false
	for _, a in ipairs(fonds) do
		if not pose and PoserAtlas(illustration, a) then pose = true end
	end
	if not pose then PoserAtlas(illustration, "groupfinder-background", { 0.06, 0.05, 0.05, 1 }) end
	local voile = encart:CreateTexture(nil, "BACKGROUND", nil, 1)
	voile:SetAllPoints(illustration)
	voile:SetColorTexture(0, 0, 0, 0.2)

	local liste = {}
	for i, creer in ipairs(pages) do
		liste[i] = creer(f) or CreateFrame("Frame", nil, f)
		liste[i]:SetFrameLevel(encart:GetFrameLevel() + 2)
		liste[i]:Hide()
	end
	f.pages = liste
	f.onglets = {}
	local function Choisir(i)
		for k, pg in ipairs(liste) do pg:SetShown(k == i) end
		f.ongletChoisi = i
		if PanelTemplates_SetTab then pcall(PanelTemplates_SetTab, f, i) end
	end
	f.Choisir = Choisir
	for i = 1, #liste do
		local okO, o = pcall(CreateFrame, "Button", nom .. "Tab" .. i, f, "PanelTabButtonTemplate")
		if not okO then
			o = CreateFrame("Button", nom .. "Tab" .. i, f, "UIPanelButtonTemplate")
			o:SetSize(110, 24)
		end
		o:SetID(i)
		o:SetText(noms[i])
		if PanelTemplates_TabResize then pcall(PanelTemplates_TabResize, o, 0) end
		if i == 1 then o:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 12, 2)
		else o:SetPoint("LEFT", f.onglets[i - 1], "RIGHT", 3, 0) end
		o:SetScript("OnClick", function() Choisir(i) end)
		f.onglets[i] = o
	end
	f.numTabs = #liste
	f.Tabs = f.onglets
	Choisir(1)
	f:Hide()
	return f
end
ns.FenetreOnglets = FenetreOnglets
ns.HAUT_ENCART = HAUT_ENCART

local function CreerFenetre()
	fen = FenetreOnglets("GuildUpDons", TITRE, ICONE_FENETRE,
		{ "auctionhouse-background-index", "Profession-Background-Template2" },
		-- fen doit être connue avant de créer les pages : leurs listes s'ancrent dessus
		{ function(f) fen = f; return CreerParcourir(f) end, CreerMes, CreerDemandes,
			function(f) return ns.CreerPageBesoins and ns.CreerPageBesoins(f, HAUT_ENCART) end },
		NOMS_ONGLETS)
	MajOnglets()
	return fen
end

-- Ouvre la fenêtre des dons sur un onglet (1 Dons, 2 Mes dons, 3 Demandes, 4 Besoins) ; déjà ouverte
-- sur cet onglet : la ferme (bouton « Dons » du volet)
local function Creer()
	-- qui est en ligne : la liste de guilde n'est sinon relue qu'à la connexion
	if ns.DemanderRoster then ns.DemanderRoster() end
	if fen then return end
	CreerFenetre()
	if ns.AvecSons then ns.AvecSons(fen, "fenetre") end
end
local function BasculerOnglet(onglet)
	Creer()
	if fen:IsShown() and fen.ongletChoisi == onglet then
		fen:Hide()
		return
	end
	fen:Show()
	fen.Choisir(onglet)
	LireMesObjets()
end
ns.BasculerEchanges = function() BasculerOnglet(DONS) end

-- ns.OuvrirEchanges(catégorie, onglet) : catégorie des dons (2 = Recettes), onglet (défaut : Dons)
ns.OuvrirEchanges = function(cat, onglet)
	Creer()
	if cat then categorie = cat end
	fen:Show()
	fen.Choisir(onglet or DONS)
	LireMesObjets()
end
ns.OuvrirPlans = function() ns.OuvrirEchanges(2, DONS) end

ns.DiagEchanges = function(L)
	local mes, n = 0, 0
	for _ in pairs(Dons()) do mes = mes + 1 end
	for _ in pairs(mesObjets) do n = n + 1 end
	L(("échanges : %d don(s) à moi sur %d objet(s) échangeable(s), %d don(s) de la guilde"):format(mes, n, NombreDons()))
end

--------------------------------------------------------------------------------
-- Récap de connexion : une bulle « pendant ton absence » une fois les listes arrivées
--------------------------------------------------------------------------------

local photo   -- dons et besoins connus au moment de la connexion (avant les nouvelles listes)
local function ClesDons()
	local t = {}
	for qui, e in pairs(Guilde() or {}) do
		if type(e) == "table" then for o in pairs(e.liste or {}) do t[qui .. ":" .. o] = true end end
	end
	return t
end
local function ClesBesoins()
	local t = {}
	local nomG = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	local b = DB().besoins
	local g = nomG and type(b) == "table" and type(b.guildes) == "table" and b.guildes[nomG]
	for qui, e in pairs(type(g) == "table" and g or {}) do
		if type(e) == "table" then for o in pairs(e.liste or {}) do t[qui .. ":" .. o] = true end end
	end
	return t
end
PhotoConnexion = function()
	photo = { dons = ClesDons(), besoins = ClesBesoins() }
end
RecapConnexion = function()
	if not photo or not ns.Notifier or not IsInGuild() then return end
	local morceaux = {}
	-- nouveaux dons (et plans que je peux apprendre)
	local nDons, nPlans = 0, 0
	for qui, e in pairs(Guilde() or {}) do
		if type(e) == "table" then
			for o, d in pairs(e.liste or {}) do
				if not photo.dons[qui .. ":" .. o] then
					nDons = nDons + 1
					if d.c and MaPlace(d.c, d.n) == "ok" and not DejaConnu(o) then nPlans = nPlans + 1 end
				end
			end
		end
	end
	if nDons > 0 then
		morceaux[#morceaux + 1] = ("%d nouveau%s don%s%s"):format(nDons, nDons > 1 and "x" or "", nDons > 1 and "s" or "",
			nPlans > 0 and (" (|cff33dd55%d plan%s pour toi|r)"):format(nPlans, nPlans > 1 and "s" or "") or "")
	end
	-- nouveaux besoins que je sais fabriquer
	local nBesoins = 0
	for k in pairs(ClesBesoins()) do
		if not photo.besoins[k] then
			local o = tonumber(k:match(":(%d+)$"))
			if o and ns.JeSaisFabriquer and ns.JeSaisFabriquer(o) then nBesoins = nBesoins + 1 end
		end
	end
	if nBesoins > 0 then
		morceaux[#morceaux + 1] = ("%d besoin%s que tu sais fabriquer"):format(nBesoins, nBesoins > 1 and "s" or "")
	end
	local nDem = NombreDemandes(nil, true)
	if nDem > 0 then morceaux[#morceaux + 1] = ("%d demande%s de dons"):format(nDem, nDem > 1 and "s" or "") end
	local nGroupes = ns.NombreGroupes and ns.NombreGroupes() or 0
	if nGroupes > 0 then morceaux[#morceaux + 1] = ("%d groupe%s ouvert%s"):format(nGroupes, nGroupes > 1 and "s" or "", nGroupes > 1 and "s" or "") end
	photo = nil
	if #morceaux == 0 then return end
	ns.Notifier(nil, "Pendant ton absence", table.concat(morceaux, " · "), nil, function()
		if nDem > 0 then
			if ns.OuvrirEchanges then ns.OuvrirEchanges(nil, DEMANDES) end
		elseif nPlans > 0 then
			if ns.OuvrirEchanges then ns.OuvrirEchanges(2, DONS) end
		elseif nDons > 0 then
			if ns.OuvrirEchanges then ns.OuvrirEchanges(1, DONS) end
		elseif nBesoins > 0 then
			if ns.OuvrirBesoins then ns.OuvrirBesoins() end
		elseif ns.OuvrirGroupes then
			ns.OuvrirGroupes()
		end
	end)
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "BAG_UPDATE_DELAYED", "BANKFRAME_OPENED",
	"BANKFRAME_CLOSED", "PLAYERBANKSLOTS_CHANGED", "PLAYERBANKBAGSLOTS_CHANGED", "BAG_UPDATE",
	"GET_ITEM_INFO_RECEIVED", "GUILD_ROSTER_UPDATE" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local premiere, prevuSacs, prevuMaj = true, false, false
local banqueOuverte = false
-- relecture regroupée (les évènements de sacs arrivent en rafale) ; banque relue tant qu'elle est
-- ouverte, pour suivre en direct les objets déplacés entre banque et sacs
local function Relire()
	if prevuSacs then return end
	prevuSacs = true
	C_Timer.After(0.5, function()
		prevuSacs = false
		if banqueOuverte then LireBanque() end
		LireMesObjets()
	end)
end
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "BAG_UPDATE_DELAYED" or event == "PLAYERBANKSLOTS_CHANGED" or event == "PLAYERBANKBAGSLOTS_CHANGED" then
		Relire()
	elseif event == "BAG_UPDATE" then
		-- sacs de banque (numéros au-delà des sacs du joueur) : seulement banque ouverte
		if banqueOuverte or (tonumber(a1) or 0) <= (NUM_BAG_SLOTS or 4) then Relire() end
	elseif event == "BANKFRAME_OPENED" then
		banqueOuverte = true
		C_Timer.After(0.3, function() LireBanque(); LireMesObjets() end)
	elseif event == "BANKFRAME_CLOSED" then
		banqueOuverte = false
	elseif event == "GET_ITEM_INFO_RECEIVED" or event == "GUILD_ROSTER_UPDATE" then
		if event == "GUILD_ROSTER_UPDATE" and pret then TransmettreAuxConnectes() end
		if fen and fen:IsShown() and not prevuMaj then
			prevuMaj = true
			C_Timer.After(0.3, function() prevuMaj = false; MajTout() end)
		end
	elseif event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		debut = GetTime()
		pcall(PurgerAnciennes)
		PhotoConnexion()
		C_Timer.After(45, RecapConnexion)
		C_Timer.After(18, function()
			LireMesObjets()
			pret = true
			if next(Dons()) then EnvoyerMaListe() end
			Envoyer("Q")
			TransmettreAuxConnectes()
		end)
	end
end)
