-- GuildUpSMB : dons de la guilde (page « Dons » de la fenêtre GuildUpSMB, kit ns.UI).
-- Onglets : Dons (les dons de la guilde, par catégorie, recherche, donateurs du mois) · Mes dons (mes
-- objets échangeables, sacs et banque : je glisse dans la case ce que je donne) · Demandes (qui m'a
-- demandé un don) · Besoins (GuildUp_Besoins.lua, ns.CreerPageBesoins).
-- La page est lourde : elle ne suit pas le rafraîchissement automatique de la fenêtre
-- (rafraichirAuto = false) ; MajTout (= ns.MajOngletsEchanges) la rafraîchit si elle est affichée,
-- ainsi que le médaillon, à chaque changement (listes reçues, sacs, demandes, liste de guilde…).
-- ns.FenetreOnglets / ns.HAUT_ENCART : ancienne fenêtre à onglets, encore utilisée par l'Artisanat.
--
-- Préfixe "GuildUpEch" (canal de guilde) :
--   "L~part~total~objet:qte:métier:niveau,…"  ma liste de dons complète (vide = plus aucun don)
--   "W~qui~date~part~total~objet:qte:…,…"      liste de dons d'un absent, renvoyée par le relais élu
--   "M~donneur~objet"                           merci (classement des donateurs du mois)
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
local LARGEUR, HAUTEUR = 720, 520   -- ancienne fenêtre à onglets (ns.FenetreOnglets, Artisanat)
local HAUT_ENCART = -88
-- onglets de la page
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
local MajTout              -- rafraîchit le médaillon et la page (défini avec la page)

local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local TestSolo = ns.TestSolo
local NomCourt = ns.NomCourt
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local Erreur = ns.Erreur
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
-- classe, sous-classe, icône, nom du type dans le jeu (« Bâtons »)
local function ClasseObjet(objet)
	local f = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
	if not f then return nil end
	local ok, _, _, sousType, _, icone, classe, sousClasse = pcall(f, objet)
	if ok then return classe, sousClasse, icone, sousType end
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
	return tonumber((C_Container and C_Container.GetContainerNumSlots and C_Container.GetContainerNumSlots(sac))
		or (GetContainerNumSlots and GetContainerNumSlots(sac))) or 0
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
	for sac = 0, tonumber(NUM_BAG_SLOTS) or 4 do LireSac(sac, sacs) end
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
-- pour l'accueil de la fenêtre GuildUpSMB : demandes reçues { nom, objet, quand, vu }, la plus récente
-- d'abord, et le nombre de demandes pas encore vues (onglet Demandes)
ns.DemandesDons = function() return Historique() end
ns.NombreDemandesDons = function() return NombreDemandes(nil, true) end

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
-- Dons de la guilde (tri, filtres)
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

-- « Armes · Bâtons » : catégorie de l'objet et son type dans le jeu
local function TexteGenre(classe, sousType)
	local nom
	for i = 2, #CATEGORIES do
		local c = CATEGORIES[i]
		if not c.autres and Classee(c, classe) then nom = c.nom; break end
	end
	if type(sousType) == "string" and sousType ~= "" then
		if nom and Simplifier(nom) ~= Simplifier(sousType) then return nom .. " · " .. sousType end
		return sousType
	end
	return nom or ""
end

local comptes = {}       -- [catégorie] = nombre de dons de la guilde
local function DonsGuilde()
	local g = Guilde() or {}
	local res = {}
	wipe(comptes)
	local limite = Maintenant() - OUBLI
	local cat = CATEGORIES[categorie] or CATEGORIES[1]
	for cle, e in pairs(g) do
		if type(e) ~= "table" or (e.vu or 0) < limite then
			g[cle] = nil
		elseif DansLaGuilde(cle) then
			local enLigne = ns.EnLigneMembre and ns.EnLigneMembre(cle) or false
			for objet, d in pairs(e.liste or {}) do
				local classe, _, iconeI, sousType = ClasseObjet(objet)
				local nomO, _, qualite, niveau, icone = InfoObjet(objet)
				local trouve = recherche == "" or Simplifier(nomO):find(recherche, 1, true) ~= nil
				-- compteurs des catégories (avec la recherche en cours)
				if trouve then
					for i, c in ipairs(CATEGORIES) do
						if Classee(c, classe) then comptes[i] = (comptes[i] or 0) + 1 end
					end
				end
				if trouve and Classee(cat, classe) then
					res[#res + 1] = { cle = cle, e = e, objet = objet, d = d, enLigne = enLigne, nomO = nomO or "",
						qualite = qualite, niveau = niveau, icone = icone or iconeI, classe = classe, sousType = sousType,
						place = d.c and MaPlace(d.c, d.n) or nil }
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

--------------------------------------------------------------------------------
-- Mes dons : ajout, retrait
--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------
-- Page « Dons » de la fenêtre GuildUpSMB
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI.C
local IconeObjet = ns.IconeObjet
local InfobulleObjet = ns.InfobulleObjet
local EcrireNomObjet = ns.EcrireNomObjet
local NomMembreColore = ns.NomMembreColore

local MARGE = 16
local LARGEUR_CATS = 140
local X_DROITE = MARGE + LARGEUR_CATS + 12         -- début de la colonne de droite
local TRANSPARENT = { 0, 0, 0, 0 }
local CASE_VIDE = "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
local VERT, ORANGE, GRIS, OR = "|cff6fd08c", "|cffff9933", "|cff9c937f", "|cfff1cf6b"
local NOMS_ONGLETS = { "Dons", "Mes dons", "Demandes", "Besoins" }

local page                 -- la page (onglets et contenus)
local rechercheMes, categorieMes = "", 1
local choixDon             -- objet posé dans la case « Mes dons »

-- Colonne des catégories : nom, compteur à droite ; grisée quand elle est vide.
-- col:Poser(choisie, comptes)
local function ColonneCategories(parent, choisir)
	local col = CreateFrame("Frame", nil, parent)
	col:SetSize(LARGEUR_CATS, #CATEGORIES * 32)
	col.boutons = {}
	for i, c in ipairs(CATEGORIES) do
		local b = CreateFrame("Button", nil, col, "BackdropTemplate")
		UI.Habiller(b, TRANSPARENT, TRANSPARENT)
		b:SetSize(LARGEUR_CATS, 30)
		b:SetPoint("TOPLEFT", col, "TOPLEFT", 0, -(i - 1) * 32)
		b.nom = UI.Texte(b, "GameFontHighlight", C.texte)
		b.nom:SetPoint("LEFT", b, "LEFT", 10, 0)
		b.nom:SetText(c.nom)
		b.n = UI.Texte(b, "GameFontHighlightSmall", C.gris)
		b.n:SetPoint("RIGHT", b, "RIGHT", -10, 0)
		b.n:SetJustifyH("RIGHT")
		UI.Survol(b, 0.05)
		b:SetScript("OnClick", function() choisir(i) end)
		if ns.SonsSurBoutons then ns.SonsSurBoutons(b) end
		col.boutons[i] = b
	end
	col.Poser = function(self, choisie, nombres)
		for i, b in ipairs(self.boutons) do
			local oui = (i == choisie)
			local n = nombres[i] or 0
			b:SetBackdropColor(unpack(oui and C.actif or TRANSPARENT))
			b:SetBackdropBorderColor(unpack(oui and C.bordMoyen or TRANSPARENT))
			b.nom:SetTextColor(unpack(oui and C.ors or C.texte))
			b.n:SetText(tostring(n))
			b:SetAlpha((n > 0 or oui) and 1 or 0.45)
		end
	end
	return col
end

-- Texte vide (centré en haut d'une liste)
local function TexteVide(parent, liste)
	local t = UI.Texte(parent, "GameFontHighlight", C.gris)
	t:SetPoint("TOPLEFT", liste, "TOPLEFT", 4, -8)
	t:SetPoint("RIGHT", liste, "RIGHT", -10, 0)
	t:SetWordWrap(true)
	return t
end

-- Place les rangées d'une liste les unes sous les autres ; renvoie la hauteur occupée
local function Empiler(liste, lignes, n, hauteur)
	local y = 0
	for i = 1, n do
		local r = lignes[i]
		r:ClearAllPoints()
		r:SetPoint("TOPLEFT", liste.contenu, "TOPLEFT", 0, -y)
		r:SetPoint("RIGHT", liste.contenu, "RIGHT", 0, 0)
		r:Show()
		y = y + hauteur
	end
	for i = n + 1, #lignes do lignes[i]:Hide() end
	liste:Hauteur(y)
end

---------------------------------------------------------------- Onglet « Dons »
local HAUTEUR_DON, ECART = 54, 6

-- infobulle du bouton Demander / Merci ! / Remercié
local function InfobulleDemande(self)
	local d = self:GetParent().d
	if not d then return end
	local demande = mesDemandes[d.cle .. d.objet]
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	if demande then
		GameTooltip:SetText(demande.merci and "Merci envoyé" or "Merci !")
		GameTooltip:AddLine("Tu as reçu ce don ? Remercie " .. NomCourt(d.e.nom) .. " : ça compte pour les donateurs du mois.", 1, 1, 1, true)
	elseif not d.enLigne then
		GameTooltip:SetText("Demander ce don")
		GameTooltip:AddLine(NomCourt(d.e.nom) .. " est hors ligne : ta demande lui sera transmise dès que possible, par un membre de la guilde connecté avec GuildUpSMB, ou quand vous serez connectés en même temps.", 1, 1, 1, true)
	else
		GameTooltip:SetText("Demander ce don")
		GameTooltip:AddLine("Un message privé part vers " .. NomCourt(d.e.nom) .. ".", 1, 1, 1, true)
	end
	GameTooltip:Show()
end

local function CreerRangeeDon(parent)
	local r = UI.Rangee(parent, HAUTEUR_DON)
	r.d, r.objet = false, false
	r.icone = IconeObjet(r, 36)
	r.icone:SetPoint("LEFT", r, "LEFT", 10, 0)
	-- bouton : « Demander » (or), puis « Merci ! » (fantôme), puis « Remercié » (désactivé)
	r.demander = UI.Bouton(r, "Demander", "or", 96, 28)
	r.demander:SetPoint("RIGHT", r, "RIGHT", -12, 0)
	r.demander:SetScript("OnClick", function() if r.d then Demander(r.d) end end)
	r.demander:SetScript("OnEnter", InfobulleDemande)
	r.demander:SetScript("OnLeave", function() GameTooltip:Hide() end)
	r.merci = UI.Bouton(r, "Merci !", "fantome", 96, 28)
	r.merci:SetPoint("RIGHT", r, "RIGHT", -12, 0)
	if r.merci.SetMotionScriptsWhileDisabled then r.merci:SetMotionScriptsWhileDisabled(true) end
	r.merci:SetScript("OnClick", function()
		local d = r.d
		local demande = d and mesDemandes[d.cle .. d.objet]
		if demande and not demande.merci then
			demande.merci = true
			Envoyer(("M~%s~%d"):format(d.cle, d.objet))
			if MajTout then MajTout() end
		end
	end)
	r.merci:SetScript("OnEnter", InfobulleDemande)
	r.merci:SetScript("OnLeave", function() GameTooltip:Hide() end)
	-- donneur (nom, en ligne), niveau, quantité
	local donneur = CreateFrame("Frame", nil, r)
	donneur:SetSize(116, 34)
	donneur:SetPoint("RIGHT", r.demander, "LEFT", -12, 0)
	r.donneur = UI.Texte(donneur, "GameFontHighlight", C.texte)
	r.donneur:SetPoint("TOPLEFT", donneur, "TOPLEFT", 0, -2)
	r.donneur:SetPoint("RIGHT", donneur, "RIGHT", 0, 0)
	r.etat = UI.Texte(donneur, "GameFontHighlightSmall", C.gris)
	r.etat:SetPoint("BOTTOMLEFT", donneur, "BOTTOMLEFT", 0, 2)
	r.etat:SetPoint("RIGHT", donneur, "RIGHT", 0, 0)
	r.niveau = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.niveau:SetPoint("RIGHT", donneur, "LEFT", -8, 0)
	r.niveau:SetWidth(50)
	r.qte = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.qte:SetPoint("RIGHT", r.niveau, "LEFT", -4, 0)
	r.qte:SetWidth(38)
	r.nom = UI.Texte(r, "GameFontNormal")
	r.nom:SetPoint("TOPLEFT", r.icone, "TOPRIGHT", 12, -2)
	r.nom:SetPoint("RIGHT", r.qte, "LEFT", -10, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("BOTTOMLEFT", r.icone, "BOTTOMRIGHT", 12, 2)
	r.sous:SetPoint("RIGHT", r.qte, "LEFT", -10, 0)
	InfobulleObjet(r)
	return r
end

local function MajRangeeDon(r, d)
	r.d, r.objet = d, d.objet
	r.icone:Poser(d.icone, d.qualite)
	EcrireNomObjet(r.nom, d.nomO ~= "" and d.nomO or nil, d.qualite)
	if d.d.c then
		-- plan : métier et niveau requis, en vert si je peux l'apprendre, en orange s'il me manque le niveau
		local suite = d.place == "ok" and " · tu peux l'apprendre" or d.place == "bas" and " · niveau trop bas" or ""
		r.sous:SetText((d.place == "ok" and VERT or d.place == "bas" and ORANGE or GRIS) .. TexteMetier(d.d.c, d.d.n) .. suite .. "|r")
	else
		r.sous:SetText(TexteGenre(d.classe, d.sousType))
	end
	r.qte:SetText("x" .. (d.d.q or 1))
	r.niveau:SetText("niv. " .. ((d.niveau and d.niveau > 1) and d.niveau or "—"))
	r.donneur:SetText(NomMembreColore(d.cle, d.e.nom))
	r.etat:SetText(d.enLigne and (VERT .. "en ligne|r") or ("hors ligne · " .. Depuis(d.e.vu)))
	local demande = mesDemandes[d.cle .. d.objet]
	r.demander:SetShown(not demande)
	r.merci:SetShown(demande and true or false)
	if demande then
		r.merci:Ecrire(demande.merci and "Remercié" or "Merci !")
		r.merci:Activer(not demande.merci)
	end
	r:Fort(d.place == "ok")
end

local function CreerOngletDons(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.lignes = {}
	p.cats = ColonneCategories(p, function(i)
		categorie = i
		p.liste:Haut()
		p.Maj()
	end)
	p.cats:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -56)
	p.champ = UI.Champ(p, 300, "Chercher un objet", 30)
	p.champ:SetPoint("TOPLEFT", p, "TOPLEFT", X_DROITE, -56)
	p.champ:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	p.champ.SurTexte = function(t)
		recherche = Simplifier(strtrim(t))
		p.liste:Haut()
		p.Maj()
	end
	local aide = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	aide:SetPoint("TOPLEFT", p, "TOPLEFT", X_DROITE + 2, -94)
	aide:SetText("Les plans que tu peux apprendre passent en premier.")
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", X_DROITE, -112)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE + 6, 12)
	p.vide = TexteVide(p, p.liste)

	p.Maj = function()
		local liste = DonsGuilde()
		p.cats:Poser(categorie, comptes)
		for i, d in ipairs(liste) do
			local r = p.lignes[i]
			if not r then r = CreerRangeeDon(p.liste.contenu); p.lignes[i] = r end
			MajRangeeDon(r, d)
		end
		Empiler(p.liste, p.lignes, #liste, HAUTEUR_DON + ECART)
		p.vide:SetShown(#liste == 0)
		p.vide:SetText(recherche ~= "" and "Aucun don ne correspond à ta recherche."
			or categorie > 1 and "Aucun don dans cette catégorie." or "Personne ne donne rien pour l'instant.")
	end
	return p
end

---------------------------------------------------------------- Onglet « Mes dons »
-- On glisse un objet dans la case d'ajout, avec la quantité à donner. Seuls les objets que j'ai
-- (sacs ou banque) et qui ne sont pas liés peuvent être donnés.
local HAUTEUR_MIEN = 46

local function CreerRangeeMien(parent)
	local r = UI.Rangee(parent, HAUTEUR_MIEN)
	r.objet = false
	r.icone = IconeObjet(r, 32)
	r.icone:SetPoint("LEFT", r, "LEFT", 8, 0)
	r.retirer = UI.Bouton(r, "Retirer", "fantome", 86, 26)
	r.retirer:SetPoint("RIGHT", r, "RIGHT", -10, 0)
	r.retirer:SetScript("OnClick", function() if r.objet then RetirerDon(r.objet) end end)
	r.nom = UI.Texte(r, "GameFontNormal")
	r.nom:SetPoint("TOPLEFT", r.icone, "TOPRIGHT", 10, -1)
	r.nom:SetPoint("RIGHT", r.retirer, "LEFT", -10, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("BOTTOMLEFT", r.icone, "BOTTOMRIGHT", 10, 1)
	r.sous:SetPoint("RIGHT", r.retirer, "LEFT", -10, 0)
	InfobulleObjet(r)
	return r
end

local function MajChoixDon()
	local p = page and page.pages[MES_DONS]
	if not p then return end
	local z = p.ajout
	local o = choixDon and mesObjets[choixDon]
	if choixDon then
		local nom, lien, qualite, _, icone = InfoObjet(choixDon)
		local _, _, iconeI = ClasseObjet(choixDon)
		z.case:Poser(icone or iconeI, qualite)
		z.nom:SetText((lien or nom or ("Objet " .. choixDon))
			.. (o and ("  " .. GRIS .. "(tu en as " .. o.nombre .. ")|r") or "  |cffff6655(pas dans tes affaires, ou lié)|r"))
	else
		z.case:Poser(CASE_VIDE, nil, true)
		z.nom:SetText(GRIS .. "Glisse ici un objet de tes sacs (ou de ta banque ouverte)|r")
	end
	z.donner:Activer(o ~= nil)
end

local function ChoisirDon(objet)
	choixDon = objet
	local o = objet and mesObjets[objet]
	local p = page and page.pages[MES_DONS]
	if p then p.ajout.qte:Ecrire(o and tostring(Dons()[objet] and QteDonnee(objet) or o.nombre) or "1") end
	MajChoixDon()
end

-- zone d'ajout : [case objet] nom (tu en as N)              [Donner]
--                            Quantité [ N ]
local function CreerAjoutDon(p)
	local z = CreateFrame("Button", nil, p, "BackdropTemplate")
	UI.Habiller(z, C.carte, C.bordMoyen)
	z:SetPoint("TOPLEFT", p, "TOPLEFT", X_DROITE, -112)
	z:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	z:SetHeight(64)
	z.case = IconeObjet(z, 44, "Button")
	z.case:SetPoint("LEFT", z, "LEFT", 10, 0)
	z.donner = UI.Bouton(z, "Donner", "or", 96, 28)
	z.donner:SetPoint("RIGHT", z, "RIGHT", -12, 0)
	z.nom = UI.Texte(z, "GameFontHighlight", C.texte)
	z.nom:SetPoint("TOPLEFT", z.case, "TOPRIGHT", 10, -2)
	z.nom:SetPoint("RIGHT", z.donner, "LEFT", -10, 0)
	local tq = UI.Texte(z, "GameFontNormalSmall", C.ors)
	tq:SetPoint("BOTTOMLEFT", z.case, "BOTTOMRIGHT", 10, 5)
	tq:SetText("Quantité")
	z.qte = UI.Champ(z, 56, nil, 22)
	z.qte:SetPoint("LEFT", tq, "RIGHT", 8, 0)
	z.qte.saisie:SetNumeric(true)
	z.qte.saisie:SetMaxLetters(4)
	z.qte:Ecrire("1")
	z.donner:SetScript("OnClick", function()
		z.qte.saisie:ClearFocus()
		if AjouterDon(choixDon, tonumber(z.qte:Lire())) then ChoisirDon(nil) end
	end)
	-- glisser un objet sur la case (ou cliquer avec un objet sur le curseur) ; clic droit : vider
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
	return z
end

local function CreerOngletMes(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.lignes = {}
	p.cats = ColonneCategories(p, function(i)
		categorieMes = i
		p.liste:Haut()
		p.Maj()
	end)
	p.cats:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -56)
	p.champ = UI.Champ(p, 300, "Chercher dans mes dons", 30)
	p.champ:SetPoint("TOPLEFT", p, "TOPLEFT", X_DROITE, -56)
	p.champ:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	p.champ.SurTexte = function(t)
		rechercheMes = Simplifier(strtrim(t))
		p.liste:Haut()
		p.Maj()
	end
	local aide = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	aide:SetPoint("TOPLEFT", p, "TOPLEFT", X_DROITE + 2, -94)
	aide:SetText("Objets de tes sacs ou de ta banque, non liés.")
	p.ajout = CreerAjoutDon(p)
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", X_DROITE, -188)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE + 6, 12)
	p.vide = TexteVide(p, p.liste)

	p.Maj = function()
		MajChoixDon()
		local cat = CATEGORIES[categorieMes] or CATEGORIES[1]
		local liste, nombres = {}, {}
		for objet in pairs(Dons()) do
			local o = mesObjets[objet]
			if o then
				local nomO, _, qualite, _, icone = InfoObjet(objet)
				if rechercheMes == "" or Simplifier(nomO):find(rechercheMes, 1, true) then
					for i, c in ipairs(CATEGORIES) do
						if Classee(c, o.classe) then nombres[i] = (nombres[i] or 0) + 1 end
					end
					if Classee(cat, o.classe) then
						liste[#liste + 1] = { o = o, nomO = nomO or "", qualite = qualite, icone = icone }
					end
				end
			end
		end
		p.cats:Poser(categorieMes, nombres)
		table.sort(liste, function(a, b) return a.nomO < b.nomO end)
		for i, d in ipairs(liste) do
			local r = p.lignes[i]
			if not r then r = CreerRangeeMien(p.liste.contenu); p.lignes[i] = r end
			local objet = d.o.objet
			r.objet = objet
			local _, _, iconeI = ClasseObjet(objet)
			r.icone:Poser(d.icone or iconeI, d.qualite)
			EcrireNomObjet(r.nom, d.nomO ~= "" and d.nomO or nil, d.qualite)
			local qte = QteDonnee(objet)
			local infos = "Donne x" .. qte
			if qte < d.o.nombre then infos = infos .. " (sur " .. d.o.nombre .. ")" end
			infos = infos .. " · " .. d.o.lieu
			if d.o.code then infos = infos .. " · " .. TexteMetier(d.o.code, d.o.niveau) end
			local n = NombreDemandes(objet)
			if n > 0 then infos = infos .. " · " .. VERT .. n .. " demande" .. (n > 1 and "s" or "") .. "|r" end
			r.sous:SetText(infos)
			r:Fort(n > 0)
		end
		Empiler(p.liste, p.lignes, #liste, HAUTEUR_MIEN + ECART)
		p.vide:SetShown(#liste == 0)
		p.vide:SetText(rechercheMes ~= "" and "Aucun de tes dons ne correspond à ta recherche."
			or categorieMes > 1 and "Aucun don dans cette catégorie."
			or "Tu ne donnes rien pour l'instant : glisse un objet dans la case ci-dessus.")
	end
	return p
end

---------------------------------------------------------------- Onglet « Demandes »
local HAUTEUR_DEMANDE = 50

local function CreerRangeeDemande(parent)
	local r = UI.Rangee(parent, HAUTEUR_DEMANDE)
	r.d, r.objet, r.cle = false, false, false
	-- marque verte à gauche : demande pas encore vue
	r.marque = r:CreateTexture(nil, "OVERLAY")
	r.marque:SetColorTexture(C.vert[1], C.vert[2], C.vert[3], 0.9)
	r.marque:SetPoint("TOPLEFT", r, "TOPLEFT", 1, -1)
	r.marque:SetPoint("BOTTOMLEFT", r, "BOTTOMLEFT", 1, 1)
	r.marque:SetWidth(3)
	r.icone = IconeObjet(r, 34)
	r.icone:SetPoint("LEFT", r, "LEFT", 12, 0)
	r.effacer = UI.Bouton(r, "Effacer", "fantome", 80, 26)
	r.effacer:SetPoint("RIGHT", r, "RIGHT", -10, 0)
	r.effacer:SetScript("OnClick", function()
		local h = Historique()
		for k, x in ipairs(h) do
			if x == r.d then table.remove(h, k); break end
		end
		if MajTout then MajTout() end
	end)
	r.mp = UI.Bouton(r, "Chuchoter", "or", 96, 26)
	r.mp:SetPoint("RIGHT", r.effacer, "LEFT", -6, 0)
	r.mp:SetScript("OnClick", function() if r.d then UI.Chuchoter(r.cle, r.d.nom) end end)
	r.nom = UI.Texte(r, "GameFontNormal")
	r.nom:SetPoint("TOPLEFT", r.icone, "TOPRIGHT", 10, -1)
	r.nom:SetPoint("RIGHT", r.mp, "LEFT", -10, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("BOTTOMLEFT", r.icone, "BOTTOMRIGHT", 10, 1)
	r.sous:SetPoint("RIGHT", r.mp, "LEFT", -10, 0)
	InfobulleObjet(r)
	return r
end

local function CreerOngletDemandes(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.lignes = {}
	local aide = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	aide:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -56)
	aide:SetPoint("RIGHT", p, "RIGHT", -MARGE - 140, 0)
	aide:SetWordWrap(true)
	aide:SetText("Qui t'a demandé un de tes dons (gardé 30 jours). Les demandes faites pendant ton absence arrivent quand un membre avec GuildUpSMB est connecté en même temps que toi.")
	p.toutEffacer = UI.Bouton(p, "Tout effacer", "fantome", 120, 28)
	p.toutEffacer:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -54)
	p.toutEffacer:SetScript("OnClick", function()
		wipe(Historique())
		if MajTout then MajTout() end
	end)
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -96)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE + 6, 12)
	p.vide = TexteVide(p, p.liste)
	p.vide:SetText("Personne ne t'a encore demandé de don.")

	p.Maj = function()
		local h = Historique()
		for i, d in ipairs(h) do
			local r = p.lignes[i]
			if not r then r = CreerRangeeDemande(p.liste.contenu); p.lignes[i] = r end
			local cle = Normaliser(d.nom)
			r.d, r.objet, r.cle = d, d.objet, cle
			r.marque:SetShown(not d.vu)
			r:Fort(not d.vu)
			local nomO, _, qualite, _, icone = InfoObjet(d.objet)
			local _, _, iconeI = ClasseObjet(d.objet)
			r.icone:Poser(icone or iconeI, qualite)
			EcrireNomObjet(r.nom, nomO, qualite)
			local enLigne = ns.EnLigneMembre and ns.EnLigneMembre(cle) or false
			r.sous:SetText(("par %s · il y a %s · %s%s"):format(NomMembreColore(cle, d.nom), Depuis(d.quand),
				enLigne and (VERT .. "en ligne|r") or "hors ligne",
				Dons()[d.objet] and "" or ("  " .. GRIS .. "(plus dans tes dons)|r")))
			r.mp:Activer(enLigne)
		end
		Empiler(p.liste, p.lignes, #h, HAUTEUR_DEMANDE + ECART)
		p.vide:SetShown(#h == 0)
		p.toutEffacer:Activer(#h > 0)
	end
	return p
end

---------------------------------------------------------------- La page

-- Rafraîchit le médaillon et la page si elle est affichée (après tout changement des dons, des
-- demandes ou des besoins ; appelé aussi par GuildUp_Besoins.lua)
MajTout = function()
	if ns.MajBouton then ns.MajBouton() end
	if ns.PageInterface and ns.PageInterface() == "dons" and ns.MajInterface then ns.MajInterface() end
end
ns.MajOngletsEchanges = MajTout

-- En ouvrant l'onglet « Demandes », les demandes sont « vues » (le compteur retombe) après 1,5 s
local function PrevoirVues()
	C_Timer.After(1.5, function()
		if not (page and page.onglet == DEMANDES and page:IsVisible()) then return end
		for _, d in ipairs(Historique()) do d.vu = true end
		MajTout()
	end)
end

-- Les onglets du kit prennent la largeur de leur nom : on leur laisse la place du compteur « (12) »
local function ElargirOnglets(o, plus)
	local x = 0
	for _, b in ipairs(o.boutons) do
		b:SetWidth(b:GetWidth() + plus)
		b:ClearAllPoints()
		b:SetPoint("BOTTOMLEFT", o, "BOTTOMLEFT", x, 0)
		x = x + b:GetWidth() + 2
	end
end

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	-- page lourde : rafraîchie sur ses évènements (MajTout), pas toutes les 2 s
	p.rafraichirAuto = false
	p.onglet = DONS
	local function Choisir(i)
		p.onglet = i
		p.onglets:Choisir(i)
		if i == DEMANDES then PrevoirVues() end
		p.Maj()
		-- mes sacs relus (la liste suit ce que j'ai vraiment)
		if i == MES_DONS then LireMesObjets() end
	end
	p.onglets = UI.Onglets(p, NOMS_ONGLETS, Choisir)
	p.onglets:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -10)
	p.onglets:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	ElargirOnglets(p.onglets, 36)
	-- donateurs du mois (les plus remerciés), à droite des onglets
	p.donateurs = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.donateurs:SetPoint("BOTTOMRIGHT", p.onglets, "BOTTOMRIGHT", 0, 11)
	p.donateurs:SetJustifyH("RIGHT")

	local besoins = ns.CreerPageBesoins and ns.CreerPageBesoins(p)
	if not besoins then
		besoins = CreateFrame("Frame", nil, p)
		besoins.Maj = function() end
	end
	p.pages = { CreerOngletDons(p), CreerOngletMes(p), CreerOngletDemandes(p), besoins }
	p.onglets:Choisir(DONS)

	p.Maj = function()
		local nMes = 0
		for _ in pairs(Dons()) do nMes = nMes + 1 end
		p.onglets:Compte(DONS, NombreDons())
		p.onglets:Compte(MES_DONS, nMes)
		p.onglets:Compte(DEMANDES, NombreDemandes(nil, true))
		p.onglets:Compte(BESOINS, ns.NombreBesoins and ns.NombreBesoins() or 0)
		local top = p.onglet == DONS and DonateursDuMois() or {}
		if #top > 0 then
			local noms = {}
			for i = 1, math.min(3, #top) do noms[#noms + 1] = NomCourt(top[i].qui) .. " (" .. top[i].n .. ")" end
			p.donateurs:SetText("Donateurs du mois : " .. OR .. table.concat(noms, " · ") .. "|r")
		else
			p.donateurs:SetText("")
		end
		for i, sp in ipairs(p.pages) do sp:SetShown(i == p.onglet) end
		local sp = p.pages[p.onglet]
		if sp and sp.Maj then sp.Maj() end
	end
	-- ns.OuvrirInterface("dons", onglet, catégorie)
	p.Ouvrir = function(onglet, cat)
		if cat and CATEGORIES[cat] then categorie = cat end
		Choisir(onglet or DONS)
	end
	p:SetScript("OnShow", function() if p.onglet == DEMANDES then PrevoirVues() end end)
	page = p
	return p
end
if ns.AjouterPage then ns.AjouterPage("dons", CreerPage) end

-- Fenêtre à onglets (cadre à portrait, bande de pierre, encart illustré) : ancienne fenêtre des dons,
-- encore utilisée par la fenêtre Artisanat (GuildUp_Carnet.lua) en attendant sa page.
-- pages : fonctions (f) -> page ; noms : textes des onglets.
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

--------------------------------------------------------------------------------
-- Ouverture (volet, bulles, accueil, /smb)
--------------------------------------------------------------------------------

-- ns.OuvrirEchanges(catégorie, onglet) : ouvre la page « Dons » sur un onglet (1 Dons, 2 Mes dons,
-- 3 Demandes, 4 Besoins ; défaut : Dons) et une catégorie des dons (indice dans CATEGORIES, 2 = Recettes)
ns.OuvrirEchanges = function(cat, onglet)
	-- qui est en ligne : la liste de guilde n'est sinon relue qu'à la connexion
	if ns.DemanderRoster then ns.DemanderRoster() end
	if ns.OuvrirInterface then ns.OuvrirInterface("dons", onglet or DONS, cat) end
	LireMesObjets()
end
-- Bouton « Dons » du volet : ferme la fenêtre si elle montre déjà la page « Dons », sinon l'ouvre
ns.BasculerEchanges = function()
	if ns.PageInterface and ns.PageInterface() == "dons" then
		if ns.BasculerInterface then ns.BasculerInterface() end
	else
		ns.OuvrirEchanges(nil, DONS)
	end
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
		-- page « Dons » affichée (tous ses onglets, Besoins compris) : noms d'objets arrivés, qui est en ligne
		if ns.PageInterface and ns.PageInterface() == "dons" and not prevuMaj then
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
