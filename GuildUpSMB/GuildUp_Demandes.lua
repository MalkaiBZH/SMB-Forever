-- GuildUpSMB : demandes de la guilde (page « Demandes » de la fenêtre GuildUpSMB, préfixe "GuildUpDem").
-- Un membre publie une demande : une ressource (« il me faut 20 Étoffe de lin ») ou de l'artisanat
-- (« fabriquez-moi une Cape en lin »). Toute la guilde voit la liste ; un membre la prend (« Je m'en
-- occupe »), son nom s'affiche, puis il l'honore (« C'est fait ! ») ou la libère. L'auteur peut la retirer,
-- ou confirmer qu'il a reçu l'objet. Une demande honorée entre dans le fil d'activité (« D », générosité
-- du podium). Remplace les dons, les besoins, les commandes d'artisanat et les projets de guilde (4.0.0).
--
-- Chaque demande porte la date de son dernier changement (heure du serveur) : la plus récente gagne, ce
-- qui permet à n'importe quel membre de relayer les demandes d'un absent.
--   "D~id~maj~auteur~genre~objet36~qte~preneur~état"   une demande, entière (création et chaque changement)
--        id : heure de création en base 36 (unique pour son auteur) ; genre : R ressource, A artisanat ;
--        preneur : clé du membre qui s'en occupe (vide sinon) ; état : O ouverte, P prise, H honorée,
--        X retirée. À égalité de date, l'état le plus avancé gagne (O < P < H < X).
--   "Q"   « renvoyez-moi les demandes » (à la connexion) : le seul relais (ns.EstLeRelais) renvoie toutes les
--         demandes en cours, en fond ; chacun renvoie aussi les siennes.
-- Les demandes honorées ou retirées sont oubliées après 3 jours, les autres après 30 jours sans changement.
-- Bulles (catégorie « demandes ») : nouvelle demande que je peux honorer (j'ai l'objet dans mes sacs ou ma
-- banque, ou je sais le fabriquer) ; ma demande prise, libérée ou honorée ; une demande que j'avais prise
-- retirée ou reçue. Ligne « Miko demande cet objet » dans les infobulles d'objets du jeu.
-- Page (kit ns.UI) : à gauche, « Nouvelle demande » (Ressource ou Artisanat, objet à chercher dans tout le
-- jeu ou à glisser, quantité, Publier) et « Mes demandes » ; à droite, « Demandes de la guilde » (filtres
-- Toutes / Je peux aider / Prises par moi). ns.OuvrirDemandes(objet, genre, qte) ouvre la page avec le
-- formulaire déjà rempli (encyclopédie, onglet Crafts, registre des métiers).
-- Fournit aussi aux autres modules : ns.IconeObjet (icône bordée à la couleur de qualité),
-- ns.InfobulleObjet, ns.EcrireNomObjet, ns.NomMembreColore, ns.ChercherObjets, ns.IndexObjets,
-- ns.NomObjetListe, et la lecture des sacs et de la banque : ns.LireConteneur, ns.SacsDeBanque, ns.Jai(objet).
-- Données : db.demandes[guilde][auteur:id] = { id, auteur, genre, objet, qte, preneur, etat, maj } ;
-- db.banque[perso] = { [objet] = nombre } (objets non liés de ma banque, à sa dernière visite).
-- À la première connexion en 4.0.0 : mes anciens besoins deviennent des demandes de ressources, et les
-- données des modules retirés (dons, besoins, projets, groupes) sont effacées.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpDem"
local MAX_MIENNES = 20               -- demandes en cours (ouvertes ou prises) par membre
local CALME = 25                     -- pas de bulle juste après la connexion
local OUBLI = 30 * 86400             -- demande en cours sans changement
local OUBLI_FINIE = 3 * 86400        -- demande honorée ou retirée
local RECENTE = 600                  -- une demande relayée plus vieille que ça ne fait pas de bulle
local MAX_RELAIS = 150
local RANG = { O = 1, P = 2, H = 3, X = 4 }
local GENRES = { R = "Ressource", A = "Artisanat" }

local debut = GetTime()
local pret = false

local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local Maintenant = ns.Maintenant
local B36 = ns.Base36
local Erreur = ns.Erreur
local InfoObjet = ns.InfoObjet
local Precharger = ns.Precharger

local function DB() return ns.DB and ns.DB() end

--------------------------------------------------------------------------------
-- Données
--------------------------------------------------------------------------------

local function Guilde()
	local db = DB()
	local nom = db and IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not nom then return nil end
	if type(db.demandes) ~= "table" then db.demandes = {} end
	if type(db.demandes[nom]) ~= "table" then db.demandes[nom] = {} end
	return db.demandes[nom]
end

local function Cle(auteur, id) return auteur .. ":" .. id end
local function EnCours(d) return d.etat == "O" or d.etat == "P" end

-- Membre encore dans la guilde ? (liste de guilde chargée : sinon on garde)
local function DansLaGuilde(cle)
	if ns.MembreGuilde then return ns.MembreGuilde(cle) ~= false end
	return true
end

local function Purger()
	local g = Guilde()
	if not g then return end
	local t = Maintenant()
	for k, d in pairs(g) do
		if type(d) ~= "table" or not d.maj or (EnCours(d) and d.maj < t - OUBLI) or (not EnCours(d) and d.maj < t - OUBLI_FINIE) then
			g[k] = nil
		end
	end
end

local function Coder(d)
	return ("D~%s~%d~%s~%s~%s~%d~%s~%s"):format(d.id, d.maj, d.auteur, d.genre, B36(d.objet), d.qte, d.preneur or "", d.etat)
end

local function Envoyer(msg, fond)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD", nil, fond and { fond = true } or nil) end
end

local Rafraichir -- (page, accueil, médaillon : plus bas)

--------------------------------------------------------------------------------
-- Mes sacs et ma banque (objets non liés)
--------------------------------------------------------------------------------

local sacs = {}       -- [objet] = nombre, dans mes sacs
local function Banque()
	local db = DB()
	if not db then return {} end
	if type(db.banque) ~= "table" then db.banque = {} end
	local moi = MaCle()
	if type(db.banque[moi]) ~= "table" then db.banque[moi] = {} end
	return db.banque[moi]
end

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

local function LireSacs()
	wipe(sacs)
	for sac = 0, tonumber(NUM_BAG_SLOTS) or 4 do LireSac(sac, sacs) end
end
local function LireBanque()
	local t = {}
	for _, sac in ipairs(ns.SacsDeBanque()) do LireSac(sac, t) end
	local b = Banque()
	wipe(b)
	for objet, n in pairs(t) do b[objet] = n end
end

-- Combien j'en ai (non lié) : nombre, lieu (« sacs », « banque », « sacs et banque ») ; nil si aucun
local function Jai(objet)
	if not objet then return nil end
	local s, b = sacs[objet] or 0, Banque()[objet] or 0
	if s + b == 0 then return nil end
	return s + b, (s > 0 and b > 0) and "sacs et banque" or (s > 0 and "sacs" or "banque")
end
ns.Jai = Jai

local function SaisFabriquer(objet)
	return ns.JeSaisFabriquer and ns.JeSaisFabriquer(objet) or false
end

--------------------------------------------------------------------------------
-- Actions
--------------------------------------------------------------------------------

local function TexteQte(qte) return (qte and qte > 1) and (" ×" .. qte) or "" end
local function NomObjet(objet)
	local nom, lien = InfoObjet(objet)
	if not nom then Precharger(objet) end
	return lien or nom or ("l'objet n° " .. objet)
end

local function Bulle(titre, texte, son)
	if ns.Notifier then
		ns.Notifier("demandes", titre, texte, son, function() if ns.OuvrirDemandes then ns.OuvrirDemandes() end end)
	end
end

-- enregistre d (plus récent que ce que je connais) ; renvoie l'ancienne version (ou false si d est
-- plus vieux que la mienne, true si elle est nouvelle)
local function Enregistrer(d)
	local g = Guilde()
	if not g then return false end
	local k = Cle(d.auteur, d.id)
	local a = g[k]
	if a then
		if a.maj > d.maj or (a.maj == d.maj and RANG[a.etat] >= RANG[d.etat]) then return false end
	end
	g[k] = d
	return a or true
end

-- une demande honorée : le fil d'activité la garde (générosité du podium ; le journal évite les doublons)
local function NoterHonoree(d)
	if d.etat == "H" and d.preneur and ns.NoterActivite then
		ns.NoterActivite("D", d.preneur, d.objet .. ":" .. d.auteur)
	end
end

-- changement d'état d'une demande (par moi) : nouvelle date, au moins une seconde après l'ancienne
local function Changer(d, etat, preneur)
	local n = {}
	for k, v in pairs(d) do n[k] = v end
	n.etat, n.preneur = etat, preneur
	n.maj = math.max(Maintenant(), (d.maj or 0) + 1)
	if not Enregistrer(n) then return end
	Envoyer(Coder(n))
	NoterHonoree(n)
	Rafraichir()
end

local function MesEnCours()
	local n, moi = 0, MaCle()
	for _, d in pairs(Guilde() or {}) do
		if d.auteur == moi and EnCours(d) then n = n + 1 end
	end
	return n
end

local dernierId = 0
local function Publier(genre, objet, qte)
	if not Guilde() then Erreur("Il faut être dans une guilde"); return false end
	if not objet then Erreur("Choisis d'abord un objet (cherche-le ou glisse-le dans la case)"); return false end
	if MesEnCours() >= MAX_MIENNES then Erreur("Pas plus de " .. MAX_MIENNES .. " demandes en cours"); return false end
	local t = Maintenant()
	if t <= dernierId then t = dernierId + 1 end
	dernierId = t
	local d = { id = B36(t), auteur = MaCle(), genre = GENRES[genre] and genre or "R", objet = objet,
		qte = math.max(1, math.min(999, math.floor(tonumber(qte) or 1))), etat = "O", maj = t }
	Precharger(objet)
	Enregistrer(d)
	Envoyer(Coder(d))
	Rafraichir()
	return true
end

local function Prendre(d) if d.etat == "O" and d.auteur ~= MaCle() then Changer(d, "P", MaCle()) end end
local function Liberer(d) if d.etat == "P" and d.preneur == MaCle() then Changer(d, "O", nil) end end
local function Honorer(d) if d.etat == "P" and (d.preneur == MaCle() or d.auteur == MaCle()) then Changer(d, "H", d.preneur) end end
local function Retirer(d) if EnCours(d) and d.auteur == MaCle() then Changer(d, "X", d.preneur) end end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Decoder(reste)
	local id, maj, auteur, genre, objet, qte, preneur, etat = reste:match("^(%w+)~(%d+)~([^~]+)~(%a)~(%w+)~(%d+)~([^~]*)~(%a)$")
	maj, objet, qte = tonumber(maj), tonumber(objet or "", 36), tonumber(qte)
	if not (id and maj and objet and qte and GENRES[genre] and RANG[etat]) then return nil end
	if maj > Maintenant() + 120 then return nil end
	return { id = id, maj = maj, auteur = auteur, genre = genre, objet = objet, qte = qte,
		preneur = preneur ~= "" and preneur or nil, etat = etat }
end

-- bulles d'un changement reçu (a : ancienne version, true si nouvelle)
local function Signaler(d, a)
	if GetTime() - debut < CALME or Maintenant() - d.maj > RECENTE then return end
	local moi = MaCle()
	local ancien = type(a) == "table" and a or nil
	if not ancien and d.etat == "O" and d.auteur ~= moi then
		-- nouvelle demande que je peux honorer
		local n = Jai(d.objet)
		local fab = SaisFabriquer(d.objet)
		if n or fab then
			Bulle("Demande de la guilde", ("%s demande %s%s — %s"):format(NomJoueur(d.auteur), NomObjet(d.objet), TexteQte(d.qte),
				n and ("tu en as " .. n) or "tu sais le fabriquer"))
		end
	elseif ancien and d.auteur == moi then
		if d.etat == "P" and ancien.etat == "O" and d.preneur then
			Bulle("Demande prise", ("%s s'occupe de ta demande : %s%s"):format(NomJoueur(d.preneur), NomObjet(d.objet), TexteQte(d.qte)), "TELL_MESSAGE")
		elseif d.etat == "O" and ancien.etat == "P" and ancien.preneur then
			Bulle("Demande libérée", ("%s ne peut plus s'occuper de ta demande : %s"):format(NomJoueur(ancien.preneur), NomObjet(d.objet)))
		elseif d.etat == "H" and d.preneur then
			Bulle("Demande honorée", ("%s a honoré ta demande : %s%s"):format(NomJoueur(d.preneur), NomObjet(d.objet), TexteQte(d.qte)), "TELL_MESSAGE")
		end
	elseif ancien and ancien.preneur == moi and d.auteur ~= moi then
		if d.etat == "X" then
			Bulle("Demande retirée", ("%s a retiré sa demande : %s"):format(NomJoueur(d.auteur), NomObjet(d.objet)))
		elseif d.etat == "H" then
			Bulle("Merci !", ("%s a bien reçu %s%s"):format(NomJoueur(d.auteur), NomObjet(d.objet), TexteQte(d.qte)), "TELL_MESSAGE")
		end
	end
end

-- Relais : à la connexion d'un membre, un seul membre lui renvoie les demandes en cours (en fond)
local function Relayer(pour)
	C_Timer.After(3 + math.random() * 7, function()
		if ns.EstLeRelais and not ns.EstLeRelais(pour) then return end
		local liste = {}
		for _, d in pairs(Guilde() or {}) do
			if EnCours(d) and DansLaGuilde(d.auteur) then liste[#liste + 1] = d end
		end
		table.sort(liste, function(a, b) return a.maj > b.maj end)
		for i = 1, math.min(#liste, MAX_RELAIS) do Envoyer(Coder(liste[i]), true) end
	end)
end

-- mes demandes en cours, à la connexion (personne d'autre ne les a peut-être)
local function EnvoyerLesMiennes()
	local moi = MaCle()
	for _, d in pairs(Guilde() or {}) do
		if d.auteur == moi and EnCours(d) then Envoyer(Coder(d), true) end
	end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if cle == MaCle() then return end
	local genre, reste = msg:match("^(%a)~?(.*)$")
	if genre == "Q" then
		if pret then Relayer(cle) end
	elseif genre == "D" then
		local d = Decoder(reste or "")
		if not d then return end
		local a = Enregistrer(d)
		if not a then return end
		Precharger(d.objet)
		if d.etat == "H" and not (type(a) == "table" and a.etat == "H") then NoterHonoree(d) end
		Signaler(d, a)
		Rafraichir()
	end
end

--------------------------------------------------------------------------------
-- Listes (page, accueil, médaillon)
--------------------------------------------------------------------------------

-- toutes les demandes connues, annotées : { d, mienne, prisePourMoi, jai, lieu, fabrique, aide }
local function Annoter(d)
	local moi = MaCle()
	local jai, lieu = Jai(d.objet)
	local fab = SaisFabriquer(d.objet)
	return { d = d, mienne = d.auteur == moi, prise = d.etat == "P" and d.preneur == moi, jai = jai, lieu = lieu, fabrique = fab,
		aide = d.etat == "O" and d.auteur ~= moi and (jai ~= nil or fab) }
end

-- demandes des autres (en cours), dans l'ordre d'affichage : celles que j'ai prises, celles où je peux
-- aider, les autres ouvertes, puis celles prises par d'autres ; les plus récentes d'abord
local function DemandesGuilde()
	local res = {}
	for _, d in pairs(Guilde() or {}) do
		if EnCours(d) and d.auteur ~= MaCle() and DansLaGuilde(d.auteur) then res[#res + 1] = Annoter(d) end
	end
	local function Rang(x) return x.prise and 1 or x.aide and 2 or x.d.etat == "O" and 3 or 4 end
	table.sort(res, function(a, b)
		local ra, rb = Rang(a), Rang(b)
		if ra ~= rb then return ra < rb end
		return a.d.maj > b.d.maj
	end)
	return res
end

-- mes demandes : en cours d'abord (prises en tête), puis honorées ou retirées récemment
local function MesDemandes()
	local res = {}
	for _, d in pairs(Guilde() or {}) do
		if d.auteur == MaCle() then res[#res + 1] = Annoter(d) end
	end
	table.sort(res, function(a, b)
		local ra, rb = RANG[a.d.etat] == 2 and 0 or RANG[a.d.etat], RANG[b.d.etat] == 2 and 0 or RANG[b.d.etat]
		if ra ~= rb then return ra < rb end
		return a.d.maj > b.d.maj
	end)
	return res
end

-- Pour l'accueil : demandes des autres que j'ai prises ou que je peux honorer ; et mes demandes en cours
ns.DemandesAccueil = function()
	local res = {}
	for _, x in ipairs(DemandesGuilde()) do
		if x.prise or x.aide then res[#res + 1] = x end
	end
	return res
end
ns.MesDemandesAccueil = function()
	local res = {}
	for _, x in ipairs(MesDemandes()) do
		if EnCours(x.d) then res[#res + 1] = x end
	end
	return res
end
-- pastille du menu et du médaillon : demandes que je peux honorer
ns.NombreDemandesAider = function()
	local n = 0
	for _, x in ipairs(DemandesGuilde()) do if x.aide then n = n + 1 end end
	return n
end
ns.PrendreDemande, ns.HonorerDemande, ns.RetirerDemande = Prendre, Honorer, Retirer

--------------------------------------------------------------------------------
-- Recherche d'un objet par son nom dans tout le jeu (GuildUp_Objets.lua, ou GuildUp_Objets_enUS.lua
-- sur un client anglais : noms dans la langue du client), même sans l'avoir
--------------------------------------------------------------------------------

local Simplifier = ns.Simplifier

local index                    -- { { id, qualité, nom, nom simplifié, classe, niveau }, … } (au premier besoin)
local function Index()
	if index then return index end
	index = {}
	for id, q, classe, niveau, nom in (ns.DONNEES_OBJETS or ""):gmatch("(%d+):(%d+):(%d+):(%d+):([^\n]+)") do
		index[#index + 1] = { tonumber(id), tonumber(q), nom, Simplifier(nom), tonumber(classe), tonumber(niveau) }
	end
	ns.DONNEES_OBJETS = nil -- le texte brut n'est plus utile
	return index
end

-- Ingrédients d'abord (artisanat, composants), puis les noms qui commencent par le texte, puis
-- ceux où un mot commence par le texte, puis le reste
local INGREDIENTS = { [7] = true, [5] = true }
local function ChercherObjets(texte, max)
	local t = Simplifier(strtrim(texte or ""))
	if #t < 2 then return {} end
	local trouves = {}
	for _, o in ipairs(Index()) do
		local pos = o[4]:find(t, 1, true)
		if pos then
			local rang = (pos == 1) and 0 or (o[4]:find(" " .. t, 1, true) and 1 or 2)
			trouves[#trouves + 1] = { o = o, ingredient = INGREDIENTS[o[5] or -1] and 0 or 1, rang = rang }
			if #trouves >= 400 then break end
		end
	end
	table.sort(trouves, function(a, b)
		if a.ingredient ~= b.ingredient then return a.ingredient < b.ingredient end
		if a.rang ~= b.rang then return a.rang < b.rang end
		return a.o[4] < b.o[4]
	end)
	local res = {}
	for i = 1, math.min(max, #trouves) do res[i] = trouves[i].o end
	return res
end
ns.ChercherObjets = ChercherObjets

-- nom d'un objet d'après la liste du jeu (quand il n'est pas encore en cache)
local parId -- [id] = entrée de l'index (construit au premier besoin)
local function NomListe(objet)
	if not parId then
		parId = {}
		for _, o in ipairs(Index()) do parId[o[1]] = o end
	end
	local o = parId[objet]
	if o then return o[3], o[2] end
end
-- Pour l'onglet Crafts de la page Artisanat : la liste de tous les objets échangeables, et un nom de secours
ns.IndexObjets = Index
ns.NomObjetListe = function(objet) return (NomListe(objet)) end

--------------------------------------------------------------------------------
-- Éléments d'interface communs (repris par l'artisanat, l'accueil…)
--------------------------------------------------------------------------------

local UI = ns.UI
local C = UI.C
local BLANC = "Interface\\Buttons\\WHITE8X8"
local ICONE_INCONNUE = "Interface\\Icons\\INV_Misc_QuestionMark"
local CASE_VIDE = "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
local VERT, OR, GRIS = "|cff6fd08c", "|cfff1cf6b", "|cff9b9380"
local MARGE = 16

-- Icône d'objet dans un cadre bordé (2 pixels) à la couleur de sa qualité ; genre "Button" pour une
-- case cliquable. f:Poser(icône, qualité, vide) : vide = icône grisée (case sans objet)
local function IconeObjet(parent, taille, genre)
	local f = CreateFrame(genre or "Frame", nil, parent, "BackdropTemplate")
	f:SetSize(taille, taille)
	if f.SetBackdrop then
		f:SetBackdrop({ bgFile = BLANC, edgeFile = BLANC, edgeSize = 2 })
		f:SetBackdropColor(unpack(C.champ))
		f:SetBackdropBorderColor(unpack(C.bord))
	end
	f.image = f:CreateTexture(nil, "ARTWORK")
	f.image:SetPoint("TOPLEFT", f, "TOPLEFT", 2, -2)
	f.image:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
	f.image:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	if genre == "Button" then UI.Survol(f, 0.12) end
	f.Poser = function(self, icone, qualite, vide)
		self.image:SetTexture(icone or ICONE_INCONNUE)
		self.image:SetDesaturated(vide and true or false)
		if not self.SetBackdropBorderColor then return end
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		if qc then self:SetBackdropBorderColor(qc.r, qc.g, qc.b, 1) else self:SetBackdropBorderColor(unpack(C.bord)) end
	end
	return f
end
ns.IconeObjet = IconeObjet

-- Infobulle de l'objet du cadre (self.objet) au survol ; plus(self, bulle) ajoute des lignes
local function InfobulleObjet(cadre, plus)
	cadre:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		if plus then plus(self, GameTooltip) end
		GameTooltip:Show()
	end)
	cadre:SetScript("OnLeave", function() GameTooltip:Hide() end)
end
ns.InfobulleObjet = InfobulleObjet

-- Nom d'un objet à la couleur de sa qualité (« chargement… » tant que le jeu ne l'a pas)
local function EcrireNomObjet(fs, nom, qualite)
	if not nom then
		fs:SetText("chargement…")
		fs:SetTextColor(unpack(C.gris))
		return
	end
	fs:SetText(nom)
	local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
	if qc then fs:SetTextColor(qc.r, qc.g, qc.b) else fs:SetTextColor(unpack(C.texte)) end
end
ns.EcrireNomObjet = EcrireNomObjet

-- nom à la couleur de sa classe (liste de guilde, sinon position partagée), sinon neutre
local function NomMembreColore(cle, nom)
	local classe = ns.ClasseMembre and ns.ClasseMembre(cle)
	if not classe then
		local positions = ns.PositionsMembres and ns.PositionsMembres()
		local p = positions and cle and positions[(cle:gsub("#test$", ""))]
		classe = p and p.classe
	end
	if classe and ns.CouleurClasseTexte then return ns.CouleurClasseTexte(classe) .. NomJoueur(nom) .. "|r" end
	return NomJoueur(nom)
end
ns.NomMembreColore = NomMembreColore

--------------------------------------------------------------------------------
-- Page « Demandes »
--------------------------------------------------------------------------------

local page
local choix                    -- objet choisi dans le formulaire
local genreChoisi = "R"
local filtre = 1               -- 1 toutes, 2 je peux aider, 3 prises par moi
local HAUTEUR_LIGNE, ECART_LIGNE = 46, 4
local MAX_RES = 10
local FILTRES = { "Toutes", "Je peux aider", "Prises par moi" }

-- icône et nom de l'objet (couleur de qualité), suivi de la quantité
local function Remplir(r, objet, qte)
	local nom, _, qualite, icone = InfoObjet(objet)
	if not nom then
		nom, qualite = NomListe(objet)
		Precharger(objet)
	end
	r.objet = objet
	r.icone:Poser(icone, qualite)
	EcrireNomObjet(r.nom, nom, qualite)
	if nom and qte and qte > 1 then r.nom:SetText(nom .. " |cffe8e2d4×" .. qte .. "|r") end
end

-- ligne : icône, nom (× quantité à côté), genre à droite du nom, sous-titre ; deux boutons à droite
local function CreerLigne(parent)
	local r = UI.Rangee(parent, HAUTEUR_LIGNE)
	r.icone = IconeObjet(r, 32)
	r.icone:SetPoint("LEFT", r, "LEFT", 8, 0)
	r.bouton = UI.Bouton(r, "", "or", 104, 24)
	r.bouton:SetPoint("RIGHT", r, "RIGHT", -8, 0)
	r.bouton2 = UI.Bouton(r, "", "fantome", 82, 24)
	r.bouton2:SetPoint("RIGHT", r.bouton, "LEFT", -6, 0)
	r.nom = UI.Texte(r, "GameFontNormal")
	r.nom:SetPoint("TOPLEFT", r.icone, "TOPRIGHT", 10, -1)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("BOTTOMLEFT", r.icone, "BOTTOMRIGHT", 10, 1)
	r.objet = false
	InfobulleObjet(r, function(self, bulle)
		local x = self.x
		if not x then return end
		bulle:AddLine(" ")
		bulle:AddLine(("%s demandé%s par %s"):format(GENRES[x.d.genre], x.d.genre == "A" and " (artisanat)" or "", NomJoueur(x.d.auteur)), C.ors[1], C.ors[2], C.ors[3])
		if x.jai then bulle:AddLine(("Tu en as %d (%s)"):format(x.jai, x.lieu or "sacs"), C.vert[1], C.vert[2], C.vert[3]) end
		if x.fabrique then bulle:AddLine("Tu sais le fabriquer", C.vert[1], C.vert[2], C.vert[3]) end
	end)
	-- boutons : action posée à chaque mise à jour (r.action, r.action2)
	r.bouton:SetScript("OnClick", function() if r.action then r.action() end end)
	r.bouton2:SetScript("OnClick", function() if r.action2 then r.action2() end end)
	for _, b in ipairs({ r.bouton, r.bouton2 }) do
		b:SetScript("OnEnter", function(self)
			if not self.aide then return end
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(self.texte:GetText() or "")
			GameTooltip:AddLine(self.aide, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end
	return r
end

-- bouton d'une ligne : texte, aide au survol, action (nil = bouton caché ; actif = false : grisé)
local function PoserBouton(b, texte, aide, action, actif)
	if not texte then b:Hide(); return nil end
	b:Ecrire(texte)
	b.aide = aide
	b:Activer(actif ~= false)
	b:Show()
	return action
end

local function Chuchoter(cle) UI.Chuchoter(cle, cle) end
local function EnLigne(cle) return ns.EnLigneMembre and ns.EnLigneMembre(cle) or false end

local function Placer(r, liste, y)
	r:ClearAllPoints()
	r:SetPoint("TOPLEFT", liste.contenu, "TOPLEFT", 0, -y)
	r:SetPoint("RIGHT", liste.contenu, "RIGHT", 0, 0)
	-- le texte s'arrête avant le premier bouton visible
	local droite = r.bouton2:IsShown() and r.bouton2 or r.bouton:IsShown() and r.bouton or r
	local point = droite == r and "RIGHT" or "LEFT"
	r.nom:SetPoint("RIGHT", droite, point, -8, 0)
	r.sous:SetPoint("RIGHT", droite, point, -8, 0)
end

local function LigneGuilde(r, x)
	local d = x.d
	local moi = MaCle()
	r.x = x
	Remplir(r, d.objet, d.qte)
	local morceaux = { (d.genre == "A" and OR or GRIS) .. GENRES[d.genre] .. "|r", NomMembreColore(d.auteur, d.auteur) }
	if d.etat == "P" then
		morceaux[#morceaux + 1] = d.preneur == moi and (VERT .. "tu t'en occupes|r") or (OR .. "prise par " .. NomJoueur(d.preneur) .. "|r")
	else
		morceaux[#morceaux + 1] = UI.IlYa(d.maj)
	end
	if x.jai then morceaux[#morceaux + 1] = VERT .. "tu en as " .. x.jai .. "|r" end
	if x.fabrique then morceaux[#morceaux + 1] = VERT .. "tu sais le fabriquer|r" end
	r.sous:SetText(table.concat(morceaux, " · "))
	local enLigne = EnLigne(d.auteur)
	if x.prise then
		r.action = PoserBouton(r.bouton, "C'est fait !", "Tu as remis l'objet : la demande est honorée, " .. NomJoueur(d.auteur) .. " est prévenu.", function() Honorer(d) end)
		r.action2 = PoserBouton(r.bouton2, "Libérer", "Tu ne peux plus t'en occuper : la demande redevient ouverte.", function() Liberer(d) end)
	elseif d.etat == "O" then
		r.action = PoserBouton(r.bouton, "Je m'en occupe", "Ton nom s'affiche : la guilde sait que tu t'en charges. " .. NomJoueur(d.auteur) .. " est prévenu.", function() Prendre(d) end)
		r.action2 = PoserBouton(r.bouton2, "Chuchoter", enLigne and "Écrire à " .. NomJoueur(d.auteur) .. "." or "Hors ligne.", function() Chuchoter(d.auteur) end, enLigne)
	else
		r.action = PoserBouton(r.bouton, "Prise", "Un autre membre s'en occupe déjà.", nil, false)
		r.action2 = PoserBouton(r.bouton2, "Chuchoter", enLigne and "Écrire à " .. NomJoueur(d.auteur) .. "." or "Hors ligne.", function() Chuchoter(d.auteur) end, enLigne)
	end
	r:Fort(x.prise or x.aide)
	if x.prise then r:SetBackdropBorderColor(C.vert[1], C.vert[2], C.vert[3], 0.6) end
end

local function LigneMienne(r, x)
	local d = x.d
	r.x = x
	Remplir(r, d.objet, d.qte)
	local etat
	if d.etat == "O" then etat = "en attente · " .. UI.IlYa(d.maj)
	elseif d.etat == "P" then etat = OR .. NomJoueur(d.preneur) .. " s'en occupe|r"
	elseif d.etat == "H" then etat = VERT .. "honorée" .. (d.preneur and (" par " .. NomJoueur(d.preneur)) or "") .. "|r · " .. UI.IlYa(d.maj)
	else etat = "retirée · " .. UI.IlYa(d.maj) end
	r.sous:SetText((d.genre == "A" and OR or GRIS) .. GENRES[d.genre] .. "|r · " .. etat)
	if d.etat == "P" then
		r.action = PoserBouton(r.bouton, "Reçu !", "Tu as reçu l'objet : la demande est honorée, " .. NomJoueur(d.preneur) .. " est prévenu.", function() Honorer(d) end)
		r.action2 = PoserBouton(r.bouton2, "Retirer", "Tu n'en as plus besoin : la demande disparaît pour toute la guilde.", function() Retirer(d) end)
	elseif d.etat == "O" then
		r.action = PoserBouton(r.bouton, nil)
		r.action2 = PoserBouton(r.bouton2, "Retirer", "Tu n'en as plus besoin : la demande disparaît pour toute la guilde.", function() Retirer(d) end)
	else
		r.action = PoserBouton(r.bouton, nil)
		r.action2 = PoserBouton(r.bouton2, nil)
	end
	r:Fort(d.etat == "P")
	r:SetAlpha(EnCours(d) and 1 or 0.6)
end

local function Lister(carte, liste, Poser)
	local y = 0
	for i, x in ipairs(liste) do
		local r = carte.lignes[i]
		if not r then r = CreerLigne(carte.liste.contenu); carte.lignes[i] = r end
		r:SetAlpha(1)
		Poser(r, x)
		Placer(r, carte.liste, y)
		r:Show()
		y = y + HAUTEUR_LIGNE + ECART_LIGNE
	end
	for i = #liste + 1, #carte.lignes do carte.lignes[i]:Hide() end
	carte.liste:Hauteur(y)
	carte.vide:SetShown(#liste == 0)
end

local function MajChoix()
	if not page then return end
	local z = page.ajout
	if choix then
		local nom, _, qualite, icone = InfoObjet(choix)
		if not nom then nom, qualite = NomListe(choix) end
		z.case:Poser(icone, qualite)
		-- le nom choisi s'écrit dans la recherche (sans relancer la recherche)
		z.cherche:Ecrire(nom or ("Objet " .. choix))
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		if qc then z.cherche.saisie:SetTextColor(qc.r, qc.g, qc.b) else z.cherche.saisie:SetTextColor(unpack(C.texte)) end
	else
		z.case:Poser(CASE_VIDE, nil, true)
		z.cherche.saisie:SetTextColor(unpack(C.texte))
	end
	z.genre:Choisir(genreChoisi == "A" and 2 or 1)
	z.publier:Activer(choix ~= nil)
end

-- objet choisi : le genre suit (fabricable par un membre : Artisanat), sauf s'il est imposé
local function Choisir(objet, genre)
	choix = objet
	if objet then
		Precharger(objet)
		if genre then genreChoisi = genre
		else genreChoisi = (ns.ArtisansDe and #(ns.ArtisansDe(objet) or {}) > 0) and "A" or "R" end
	end
	if not objet and page then page.ajout.cherche:Ecrire("") end
	MajChoix()
end

local function MajPage()
	if not page then return end
	MajChoix()
	local tous = DemandesGuilde()
	local liste, aider = {}, 0
	for _, x in ipairs(tous) do
		if x.aide then aider = aider + 1 end
		if filtre == 1 or (filtre == 2 and x.aide) or (filtre == 3 and x.prise) then liste[#liste + 1] = x end
	end
	local gu = page.guilde
	Lister(gu, liste, LigneGuilde)
	gu.compte:SetText(#tous == 0 and "" or (aider > 0 and ("%d · tu peux en honorer %d"):format(#tous, aider) or tostring(#tous)))
	gu.vide:SetText(({ "Aucune demande dans la guilde pour l'instant.",
		"Rien que tu puisses honorer : ni dans tes sacs ou ta banque, ni dans tes recettes.",
		"Tu ne t'occupes d'aucune demande." })[filtre])
	gu.puces:Choisir(filtre)

	local mes = MesDemandes()
	Lister(page.mes, mes, LigneMienne)
	page.mes.compte:SetText(MesEnCours() .. " / " .. MAX_MIENNES)
end

-- Formulaire : [Ressource | Artisanat]
--              [case objet] [recherche dans tous les objets du jeu   x]
--              Quantité [ 1 ]                               [Publier]
local function CreerAjout(carte)
	local z = CreateFrame("Frame", nil, carte)
	z:SetPoint("TOPLEFT", carte, "TOPLEFT", 14, -40)
	z:SetPoint("RIGHT", carte, "RIGHT", -14, 0)
	z:SetHeight(120)

	z.genre = UI.Puces(z, { "Ressource", "Artisanat" }, function(i)
		genreChoisi = i == 2 and "A" or "R"
		MajChoix()
	end)
	z.genre:SetPoint("TOPLEFT", z, "TOPLEFT", 0, 0)
	UI.Infobulle(z.genre.boutons[1], "Ressource", "Un objet qu'un membre peut te donner (composants, consommables…).")
	UI.Infobulle(z.genre.boutons[2], "Artisanat", "Un objet à te fabriquer : ceux qui ont la recette sont prévenus.")

	z.case = IconeObjet(z, 44, "Button")
	z.case:SetPoint("TOPLEFT", z.genre, "BOTTOMLEFT", 0, -10)

	-- recherche par nom (tout le jeu) : liste de résultats sous la zone de saisie
	local cherche = UI.Champ(z, 200, "Nom de l'objet, ou glisse-le ici", 26)
	cherche:SetPoint("TOPLEFT", z.case, "TOPRIGHT", 10, 0)
	cherche:SetPoint("RIGHT", z, "RIGHT", 0, 0)
	cherche.saisie:SetPoint("BOTTOMRIGHT", cherche, "BOTTOMRIGHT", -26, 0)
	z.cherche = cherche
	local croix = CreateFrame("Button", nil, cherche)
	croix:SetSize(20, 20)
	croix:SetPoint("RIGHT", cherche, "RIGHT", -4, 0)
	croix.texte = UI.Texte(croix, "GameFontNormal", C.gris)
	croix.texte:SetPoint("CENTER", 0, 1)
	croix.texte:SetText("x")
	UI.Survol(croix, 0.1)
	croix:Hide()

	local res = UI.Cadre(z, { 0.05, 0.043, 0.035, 0.98 }, C.bordFort)
	res:SetFrameStrata("DIALOG")
	res:SetPoint("TOPLEFT", cherche, "BOTTOMLEFT", 0, -2)
	res:SetPoint("TOPRIGHT", cherche, "BOTTOMRIGHT", 0, -2)
	res:Hide()
	res.lignes = {}
	for i = 1, MAX_RES do
		local l = CreateFrame("Button", nil, res)
		l:SetHeight(22)
		l:SetPoint("TOPLEFT", res, "TOPLEFT", 2, -2 - (i - 1) * 22)
		l:SetPoint("RIGHT", res, "RIGHT", -2, 0)
		UI.Survol(l, 0.08)
		l.icone = l:CreateTexture(nil, "ARTWORK")
		l.icone:SetSize(16, 16)
		l.icone:SetPoint("LEFT", l, "LEFT", 6, 0)
		l.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		l.texte = UI.Texte(l, "GameFontHighlightSmall")
		l.texte:SetPoint("LEFT", l.icone, "RIGHT", 6, 0)
		l.texte:SetPoint("RIGHT", l, "RIGHT", -4, 0)
		l.objet = false
		l:SetScript("OnClick", function(self)
			res:Hide()
			cherche.saisie:ClearFocus()
			Choisir(self.objet)
		end)
		InfobulleObjet(l)
		res.lignes[i] = l
	end
	local function Resultats()
		local liste = ChercherObjets(cherche:Lire(), MAX_RES)
		local fi = (C_Item and C_Item.GetItemIconByID) or GetItemIcon
		for i, l in ipairs(res.lignes) do
			local o = liste[i]
			if o then
				l.objet = o[1]
				local okI, icone = false, nil
				if fi then okI, icone = pcall(fi, o[1]) end
				l.icone:SetTexture(okI and icone or ICONE_INCONNUE)
				local qc = ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[o[2]]
				l.texte:SetText(o[3])
				if qc then l.texte:SetTextColor(qc.r, qc.g, qc.b) else l.texte:SetTextColor(unpack(C.texte)) end
				l:Show()
			else
				l:Hide()
			end
		end
		res:SetHeight(4 + math.max(1, #liste) * 22)
		res:SetShown(#liste > 0)
	end
	-- on tape un nom : l'objet choisi est oublié, les résultats suivent
	cherche.SurTexte = function()
		if choix then
			choix = nil
			MajChoix()
		end
		Resultats()
	end
	croix:SetScript("OnClick", function()
		res:Hide()
		cherche.saisie:ClearFocus()
		Choisir(nil)
	end)
	cherche.saisie:HookScript("OnTextChanged", function(self) croix:SetShown((self:GetText() or "") ~= "") end)
	-- Entrée : le premier résultat ; Échap ferme la liste
	cherche.saisie:SetScript("OnEnterPressed", function(self)
		local l = res.lignes[1]
		if res:IsShown() and l:IsShown() then l:Click() else self:ClearFocus() end
	end)
	cherche.saisie:HookScript("OnEscapePressed", function() res:Hide() end)
	cherche.saisie:HookScript("OnEditFocusLost", function()
		C_Timer.After(0.2, function() if not cherche.saisie:HasFocus() then res:Hide() end end)
	end)

	-- quantité, publier
	local tq = UI.Texte(z, "GameFontNormalSmall", C.ors)
	tq:SetPoint("BOTTOMLEFT", z.case, "BOTTOMRIGHT", 10, -2)
	tq:SetText("Quantité")
	z.qte = UI.Champ(z, 46, nil, 24)
	z.qte:SetPoint("LEFT", tq, "RIGHT", 8, 0)
	z.qte.saisie:SetNumeric(true)
	z.qte.saisie:SetMaxLetters(3)
	z.qte:Ecrire("1")
	z.publier = UI.Bouton(z, "Publier", "or", 84, 26)
	z.publier:SetPoint("TOP", z.case, "BOTTOM", 0, -12)
	z.publier:SetPoint("RIGHT", z, "RIGHT", 0, 0)
	z.publier:SetScript("OnClick", function()
		z.qte.saisie:ClearFocus()
		if Publier(genreChoisi, choix, tonumber(z.qte:Lire()) or 1) then
			Choisir(nil)
			z.qte:Ecrire("1")
		end
	end)
	UI.Infobulle(z.publier, "Publier", "Toute la guilde voit ta demande, même quand tu es hors ligne. Ceux qui ont l'objet ou la recette sont prévenus.")

	-- glisser un objet sur la case (ou cliquer avec un objet sur le curseur) ; clic droit : vider
	ns.BrancherDepot({ z, z.case }, function(o) res:Hide(); Choisir(o) end, function() return choix end)
	z.case:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if choix then
			pcall(GameTooltip.SetItemByID, GameTooltip, choix)
			GameTooltip:AddLine("Clic droit : retirer l'objet de la case", 0.6, 0.6, 0.6)
		else
			GameTooltip:SetText("Objet demandé")
			GameTooltip:AddLine("Cherche un objet par son nom à côté, ou glisse un objet de tes sacs ici.", 1, 1, 1, true)
		end
		GameTooltip:Show()
	end)
	z.case:SetScript("OnLeave", function() GameTooltip:Hide() end)
	if ns.SonsSurBoutons then ns.SonsSurBoutons(z) end
	return z
end

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	local GAUCHE = 320

	-- gauche : nouvelle demande, puis mes demandes
	local nouvelle = UI.Carte(p, "Nouvelle demande")
	nouvelle:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -MARGE)
	nouvelle:SetSize(GAUCHE, 172)
	p.ajout = CreerAjout(nouvelle)

	local mes = UI.Carte(p, "Mes demandes")
	mes:SetPoint("TOPLEFT", nouvelle, "BOTTOMLEFT", 0, -12)
	mes:SetPoint("BOTTOMLEFT", p, "BOTTOMLEFT", MARGE, 12)
	mes:SetWidth(GAUCHE)
	mes.lignes = {}
	mes.liste = UI.Liste(mes)
	mes.liste:SetPoint("TOPLEFT", mes, "TOPLEFT", 12, -38)
	mes.liste:SetPoint("BOTTOMRIGHT", mes, "BOTTOMRIGHT", -6, 10)
	mes.vide:SetText("Aucune demande. Publie-en une au-dessus : la guilde la voit, même quand tu es hors ligne.")
	p.mes = mes

	-- droite : demandes de la guilde
	local gu = UI.Carte(p, "Demandes de la guilde")
	gu:SetPoint("TOPLEFT", nouvelle, "TOPRIGHT", 12, 0)
	gu:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, 12)
	gu.lignes = {}
	gu.puces = UI.Puces(gu, FILTRES, function(i) filtre = i; MajPage(); gu.liste:Haut() end)
	gu.puces:SetPoint("TOPLEFT", gu, "TOPLEFT", 14, -36)
	gu.liste = UI.Liste(gu)
	gu.liste:SetPoint("TOPLEFT", gu, "TOPLEFT", 12, -72)
	gu.liste:SetPoint("BOTTOMRIGHT", gu, "BOTTOMRIGHT", -6, 10)
	gu.vide:ClearAllPoints()
	gu.vide:SetPoint("TOPLEFT", gu.liste, "TOPLEFT", 2, -6)
	gu.vide:SetPoint("RIGHT", gu, "RIGHT", -14, 0)
	p.guilde = gu

	p.Maj = MajPage
	-- ns.OuvrirInterface("demandes", objet, genre, qte) : formulaire rempli
	p.Ouvrir = function(objet, genre, qte)
		if objet then
			Choisir(objet, genre)
			p.ajout.qte:Ecrire(tostring(math.max(1, tonumber(qte) or 1)))
		end
	end
	page = p
	return p
end

if ns.AjouterPage then ns.AjouterPage("demandes", CreerPage) end

-- Ouvre la page Demandes (avec le formulaire rempli si objet : genre "R" ou "A", sinon deviné)
ns.OuvrirDemandes = function(objet, genre, qte)
	if not ns.OuvrirInterface then return end
	if objet then ns.OuvrirInterface("demandes", objet, genre, qte) else ns.OuvrirInterface("demandes") end
end

-- page, accueil et médaillon (regroupé : les messages arrivent parfois en rafale)
local prevu = false
Rafraichir = function()
	if prevu then return end
	prevu = true
	C_Timer.After(0.3, function()
		prevu = false
		local pageVue = ns.PageInterface and ns.PageInterface()
		if pageVue == "demandes" or pageVue == "accueil" then ns.MajInterface() end
		if ns.MajBouton then ns.MajBouton() end
	end)
end

--------------------------------------------------------------------------------
-- Infobulle des objets : « Miko demande cet objet (×5) »
--------------------------------------------------------------------------------

local function LignesDemande(tooltip, objet)
	if not objet or not tooltip or not tooltip.AddLine then return end
	local qui = {}
	for _, d in pairs(Guilde() or {}) do
		if d.objet == objet and EnCours(d) and DansLaGuilde(d.auteur) then
			qui[#qui + 1] = NomJoueur(d.auteur) .. (d.qte > 1 and (" (×" .. d.qte .. ")") or "")
		end
	end
	if #qui == 0 then return end
	table.sort(qui)
	local texte
	if #qui == 1 then
		texte = qui[1] .. " demande cet objet"
	elseif #qui <= 3 then
		texte = table.concat(qui, ", ") .. " demandent cet objet"
	else
		texte = ("%s, %s et %d autres demandent cet objet"):format(qui[1], qui[2], #qui - 2)
	end
	tooltip:AddLine("|TInterface\\Icons\\INV_Misc_Note_01:0|t " .. texte, 0.25, 1, 0.45, true)
	tooltip:Show()
end

local function ObjetDeBulle(tooltip, data)
	if data and data.id then return tonumber(data.id) end
	if tooltip and tooltip.GetItem then
		local _, lien = tooltip:GetItem()
		return lien and tonumber(lien:match("item:(%d+)"))
	end
end

if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	-- API récente : toutes les infobulles d'objet du jeu (sacs, liens, butin, hôtel des ventes…)
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
		if tooltip == GameTooltip or tooltip == ItemRefTooltip or tooltip == ShoppingTooltip1 then
			pcall(LignesDemande, tooltip, ObjetDeBulle(tooltip, data))
		end
	end)
else
	for _, bulle in ipairs({ GameTooltip, ItemRefTooltip }) do
		if bulle and bulle.HookScript then
			pcall(bulle.HookScript, bulle, "OnTooltipSetItem", function(self)
				pcall(LignesDemande, self, ObjetDeBulle(self))
			end)
		end
	end
end

ns.DiagDemandes = function(L)
	local n, mes, prises = 0, 0, 0
	for _, d in pairs(Guilde() or {}) do
		if EnCours(d) then
			n = n + 1
			if d.auteur == MaCle() then mes = mes + 1 end
			if d.preneur == MaCle() then prises = prises + 1 end
		end
	end
	local s, b = 0, 0
	for _ in pairs(sacs) do s = s + 1 end
	for _ in pairs(Banque()) do b = b + 1 end
	L(("demandes : %d en cours (%d à moi, %d prises par moi), %d que je peux honorer ; %d objets différents en sacs, %d en banque")
		:format(n, mes, prises, ns.NombreDemandesAider(), s, b))
end

--------------------------------------------------------------------------------
-- 4.0.0 : anciens besoins → demandes ; données des modules retirés effacées
--------------------------------------------------------------------------------

local function Migrer()
	local db = DB()
	if not db or not Guilde() then return end
	-- mes besoins (ce personnage) deviennent des demandes de ressources
	local b = db.besoins
	if type(b) == "table" then
		local mes = type(b.mes) == "table" and b.mes[MaCle()]
		if type(mes) == "table" then
			local n = 0
			for objet, qte in pairs(mes) do
				objet = tonumber(objet)
				if objet and n < MAX_MIENNES then
					n = n + 1
					Publier("R", objet, (tonumber(qte) or 0) > 0 and qte or 1)
				end
			end
			b.mes[MaCle()] = nil
		end
		b.guildes = nil
		if type(b.mes) ~= "table" or not next(b.mes) then db.besoins = nil end
	end
	-- dons, projets de guilde, groupes : plus lus depuis la 4.0.0
	for _, k in ipairs({ "echanges", "donsPerso", "donsBanque", "donsSignales", "dons", "relaisDons", "mesDemandesDons",
		"mercis", "demandesDons", "projets", "groupesProgrammes", "styleJeu", "rappelGroupe", "tousNiveaux" }) do
		db[k] = nil
	end
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
for _, e in ipairs({ "PLAYER_ENTERING_WORLD", "BAG_UPDATE_DELAYED", "BANKFRAME_OPENED", "BANKFRAME_CLOSED",
	"PLAYERBANKSLOTS_CHANGED", "PLAYERBANKBAGSLOTS_CHANGED", "BAG_UPDATE", "GET_ITEM_INFO_RECEIVED", "GUILD_ROSTER_UPDATE" }) do
	pcall(ev.RegisterEvent, ev, e)
end
local premiere, prevuSacs, banqueOuverte = true, false, false
-- relecture regroupée (les évènements de sacs arrivent en rafale) ; banque relue tant qu'elle est ouverte
local function Relire()
	if prevuSacs then return end
	prevuSacs = true
	C_Timer.After(0.5, function()
		prevuSacs = false
		if banqueOuverte then LireBanque() end
		LireSacs()
		if ns.PageInterface and ns.PageInterface() == "demandes" then Rafraichir() end
	end)
end
ev:SetScript("OnEvent", function(_, event, a1)
	if event == "BAG_UPDATE_DELAYED" or event == "PLAYERBANKSLOTS_CHANGED" or event == "PLAYERBANKBAGSLOTS_CHANGED" then
		Relire()
	elseif event == "BAG_UPDATE" then
		-- sacs de banque (numéros au-delà des sacs du joueur) : seulement banque ouverte
		if banqueOuverte or (tonumber(a1) or 0) <= (NUM_BAG_SLOTS or 4) then Relire() end
	elseif event == "BANKFRAME_OPENED" then
		banqueOuverte = true
		C_Timer.After(0.3, function() LireBanque(); LireSacs(); Rafraichir() end)
	elseif event == "BANKFRAME_CLOSED" then
		banqueOuverte = false
	elseif event == "GET_ITEM_INFO_RECEIVED" or event == "GUILD_ROSTER_UPDATE" then
		if ns.PageInterface and ns.PageInterface() == "demandes" then Rafraichir() end
	elseif event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		debut = GetTime()
		C_Timer.After(18, function()
			pcall(Purger)
			LireSacs()
			pret = true
			pcall(Migrer)
			Envoyer("Q")
			C_Timer.After(2, EnvoyerLesMiennes)
		end)
	end
end)
