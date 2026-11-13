-- GuildUpSMB : tirage au sort de la guilde (/smb roll, préfixe "GuildUpTir").
-- Un membre (l'organisateur) ouvre un tirage sur un lot ; les autres ont une bulle, puis une petite
-- fenêtre où lancer les dés. Le hasard vient du jeu : le bouton fait le /roll 1-100 du jeu, l'addon lit
-- le résultat annoncé par le serveur (message système) et le transmet à la guilde. Les joueurs à côté
-- le voient aussi passer dans leur discussion. Un seul lancer par membre et par tour.
-- Avant d'ouvrir, l'organisateur choisit qui participe : la liste des membres connectés qui ont l'addon,
-- avec une case par membre, « Tout cocher » et « Mon groupe ». Tout coché = toute la guilde.
--   "P~id~clé~clé…"                      participants d'un tirage réservé (un ou plusieurs messages,
--                                        envoyés avant l'ouverture)
--   "O~id~secondes~objet~texte"          ouverture (objet = identifiant d'objet, 0 sans objet)
--   "L~organisateur~id~tour~valeur"      mon lancer (organisateur = sa clé « Nom-Royaume »)
--   "E~id~tour~secondes~clé~clé…"        égalité en tête : nouveau tour entre les membres cités
--   "F~id~clé~hasard"                    fin (clé du gagnant, vide = personne ; hasard = 1 : égalité
--                                        tranchée au sort par l'organisateur après le dernier tour)
--   "A~id"                               tirage annulé
-- « id » = heure du serveur à l'ouverture, en base 36, suivie de « R » si le tirage est réservé à
-- certains membres (sans liste « P » reçue, personne n'est admis). Un tirage est repéré par la clé de
-- l'organisateur et son id : seuls les messages de l'organisateur peuvent le prolonger, le finir ou l'annuler.
-- Les autres membres ne reçoivent pas de bulle pour un tirage réservé, mais peuvent le suivre (/smb roll).
-- (La version 3.5.0 ne connaît pas « P » : elle montre le tirage à tous, et les lancers des membres non
-- admis sont ignorés par les autres.)
-- Classement : la valeur du premier tour, puis celle des tours de départage (pas de relance = 0).
-- C'est l'organisateur qui tient le chrono ; sans nouvelles de lui 20 s après la fin, le tirage est
-- marqué interrompu (il reprend si un message de l'organisateur finit par arriver). Rien n'est gardé
-- d'une session à l'autre.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpTir"
local DUREE = 60            -- secondes pour lancer les dés
local DUREE_DEPARTAGE = 30  -- secondes d'un tour de départage
local TOURS_MAX = 4         -- au-delà, l'organisateur tranche au sort
local GRACE = 3             -- l'organisateur attend les derniers lancers en route
local SANS_NOUVELLES = 20   -- secondes après la fin sans message de l'organisateur
local ATTENTE_DE = 5        -- secondes pour lire le résultat de mon lancer
local ENTRE_DEUX = 30       -- secondes entre deux tirages du même organisateur
local GARDE = 30 * 60       -- un tirage terminé reste consultable 30 min

local Normaliser = ns.Normaliser
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local Erreur = ns.Erreur
local MaCle = ns.MaCle
local Base36 = ns.Base36

local tirages = {}    -- [organisateur .. "~" .. id] = tirage
local annonces = {}   -- [organisateur .. "~" .. id] = { cles = { [clé] = true }, quand } : listes « P » reçues
local vue             -- tirage montré dans la fenêtre
local attenteDe       -- { tirage, tour, limite } : j'ai cliqué, j'attends le message du jeu
local dernierOuvert = -math.huge
local fenetre, choix
local MajFenetre = function() end

--------------------------------------------------------------------------------
-- Classement
--------------------------------------------------------------------------------

-- -1 si a est devant b, 1 s'il est derrière, 0 s'ils sont à égalité (tous les tours joués)
local function Comparer(a, b, tours)
	for i = 1, tours do
		local x, y = a.tours[i] or 0, b.tours[i] or 0
		if x ~= y then return x > y and -1 or 1 end
	end
	return 0
end

-- lancers du meilleur au moins bon (à égalité : ordre des noms, pour un affichage stable)
local function Classement(t)
	local liste = {}
	for cle, l in pairs(t.lancers) do liste[#liste + 1] = { cle = cle, nom = l.nom, tours = l.tours } end
	table.sort(liste, function(a, b)
		local c = Comparer(a, b, t.tour)
		if c ~= 0 then return c < 0 end
		return a.cle < b.cle
	end)
	return liste
end

-- les membres à égalité en tête
local function EnTete(t)
	local c = Classement(t)
	local tete = {}
	for i = 1, #c do
		if i > 1 and Comparer(c[i], c[1], t.tour) ~= 0 then break end
		tete[#tete + 1] = c[i]
	end
	return tete, c
end

local function PeutLancer(t, cle)
	if t.etat ~= "ouvert" or GetTime() > t.fin then return false end
	if t.admis and not t.admis[cle] then return false end
	local l = t.lancers[cle]
	return not (l and l.tours[t.tour])
end

local function NomLot(t)
	if t.objet then
		local nom, lien = ns.InfoObjet(t.objet)
		if not nom and ns.Precharger then ns.Precharger(t.objet) end
		local lot = lien or nom or ("objet n° " .. t.objet)
		return t.texte ~= "" and (lot .. " · " .. t.texte) or lot
	end
	return t.texte ~= "" and t.texte or "un lot"
end

--------------------------------------------------------------------------------
-- Changements d'état (appliqués chez moi, puis reçus de la même façon chez les autres)
--------------------------------------------------------------------------------

local function Oublier()
	local maintenant = GetTime()
	for cle, t in pairs(tirages) do
		if t.etat ~= "ouvert" and maintenant - (t.clos or maintenant) > GARDE then
			tirages[cle] = nil
			if vue == t then vue = nil end
		end
	end
	for cle, a in pairs(annonces) do
		if maintenant - a.quand > 60 then annonces[cle] = nil end
	end
end

local function Copie(cles)
	local c = {}
	for cle in pairs(cles) do c[cle] = true end
	return c
end

-- invites : les membres admis d'un tirage réservé ({ [clé] = true }), nil = toute la guilde
local function Creer(chef, nomChef, id, duree, objet, texte, invites)
	local cle = chef .. "~" .. id
	if tirages[cle] then return nil end
	Oublier()
	local t = { cle = cle, chef = chef, nomChef = nomChef, id = id, objet = objet, texte = texte or "",
		tour = 1, fin = GetTime() + duree, lancers = {}, etat = "ouvert",
		invites = invites, admis = invites and Copie(invites) or nil }
	tirages[cle] = t
	if objet and ns.Precharger then ns.Precharger(objet) end
	return t
end

local function NoterLancer(t, cle, nom, tour, valeur)
	if t.etat ~= "ouvert" or tour ~= t.tour then return false end
	if valeur < 1 or valeur > 100 or valeur ~= math.floor(valeur) then return false end
	if t.admis and not t.admis[cle] then return false end
	local l = t.lancers[cle]
	if not l then
		if tour ~= 1 then return false end
		l = { nom = nom, tours = {} }
		t.lancers[cle] = l
	end
	if l.tours[tour] then return false end
	l.tours[tour] = valeur
	return true
end

local function NouveauTour(t, tour, duree, admis)
	if t.etat ~= "ouvert" or tour <= t.tour then return false end
	t.tour, t.admis, t.fin = tour, admis, GetTime() + duree
	return true
end

local function Clore(t, etat, gagnant, hasard)
	if t.etat ~= "ouvert" then return false end
	t.etat, t.gagnant, t.hasard, t.clos = etat, gagnant, hasard, GetTime()
	-- le fil d'activité garde le nom du gagnant (GuildUp_Journal.lua)
	if etat == "fini" and gagnant and ns.NoterActivite then
		ns.NoterActivite("T", gagnant, t.objet and ("i" .. t.objet) or t.texte)
	end
	if attenteDe and attenteDe.tirage == t then attenteDe = nil end
	return true
end

-- un message de l'organisateur arrive après le délai : le tirage n'était pas interrompu
local function Reprendre(t)
	if t.etat == "interrompu" then t.etat, t.clos = "ouvert", nil end
end

local function Envoyer(msg)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end
end

--------------------------------------------------------------------------------
-- Organisateur : ouverture, clôture, départage
--------------------------------------------------------------------------------

local function Finir(t, gagnant, hasard)
	if not Clore(t, "fini", gagnant, hasard) then return end
	Envoyer(("F~%s~%s~%s"):format(t.id, gagnant or "", hasard and "1" or "0"))
	if gagnant == MaCle() and ns.PluieEmotes then ns.PluieEmotes(4) end
	MajFenetre()
end

-- fin du temps (ou bouton « Clôturer ») : un gagnant, ou un nouveau tour entre les premiers à égalité
local function Cloturer(t)
	if t.etat ~= "ouvert" or t.chef ~= MaCle() then return end
	local tete = EnTete(t)
	if #tete == 0 then Finir(t, nil); return end
	if #tete == 1 then Finir(t, tete[1].cle); return end
	if t.tour < TOURS_MAX then
		local cles, admis = {}, {}
		for _, l in ipairs(tete) do cles[#cles + 1] = l.cle; admis[l.cle] = true end
		local msg = ("E~%s~%d~%d~%s"):format(t.id, t.tour + 1, DUREE_DEPARTAGE, table.concat(cles, "~"))
		if #msg <= (ns.LONGUEUR_MAX or 255) then
			NouveauTour(t, t.tour + 1, DUREE_DEPARTAGE, admis)
			Envoyer(msg)
			MajFenetre()
			return
		end
	end
	-- trop de tours (ou trop de membres à égalité pour un seul message) : tranché au sort
	Finir(t, tete[math.random(#tete)].cle, true)
end

local function Annuler(t)
	if t.chef ~= MaCle() or not Clore(t, "annule") then return end
	Envoyer("A~" .. t.id)
	MajFenetre()
end

local function MonTirageOuvert()
	local moi = MaCle()
	for _, t in pairs(tirages) do
		if t.chef == moi and t.etat == "ouvert" then return t end
	end
end

local function PeutOuvrir()
	if not IsInGuild() then Erreur("Tu n'es pas dans une guilde"); return false end
	if MonTirageOuvert() then Erreur("Tu as déjà un tirage en cours"); return false end
	local reste = ENTRE_DEUX - (GetTime() - dernierOuvert)
	if reste > 0 then Erreur(("Attends encore %d s avant un nouveau tirage"):format(math.ceil(reste))); return false end
	return MaCle() ~= nil
end

-- invites : { [clé] = true } pour un tirage réservé, nil pour toute la guilde
local function Ouvrir(objet, texte, invites)
	if not PeutOuvrir() then return end
	local moi = MaCle()
	texte = (texte or ""):gsub("[~|\r\n]", " "):gsub("%s+", " ")
	texte = strtrim(ns.CouperUTF8 and ns.CouperUTF8(texte, nil, 60) or texte:sub(1, 60))
	local t = Creer(moi, moi, Base36(ns.Maintenant()) .. (invites and "R" or ""), DUREE, objet, texte, invites)
	if not t then Erreur("Attends une seconde avant un nouveau tirage"); return end
	dernierOuvert = GetTime()
	if invites then
		-- la liste des participants d'abord, en messages d'au plus 240 octets
		local msg = "P~" .. t.id
		for cle in pairs(invites) do
			if #msg + 1 + #cle > 240 then Envoyer(msg); msg = "P~" .. t.id end
			msg = msg .. "~" .. cle
		end
		Envoyer(msg)
	end
	Envoyer(("O~%s~%d~%d~%s"):format(t.id, DUREE, objet or 0, texte))
	vue = t
	if ns.MontrerTirage then ns.MontrerTirage() end
end

--------------------------------------------------------------------------------
-- Mon lancer : le /roll du jeu, lu dans le message système qui l'annonce
--------------------------------------------------------------------------------

-- motif de lecture construit sur le texte du client (« %s obtient un %d (%d-%d) » en français) ;
-- ordre[i] = rang de la i-ème capture parmi (nom, valeur, minimum, maximum)
local motif, ordre
local function Motif()
	if motif then return motif, ordre end
	local modele = (type(RANDOM_ROLL_RESULT) == "string" and RANDOM_ROLL_RESULT) or "%s obtient un %d (%d-%d)"
	ordre = {}
	local explicite = false
	modele = modele:gsub("%%(%d)%$([sd])", function(n, genre)
		explicite = true
		ordre[#ordre + 1] = tonumber(n)
		return "%" .. genre
	end)
	if not explicite then ordre = { 1, 2, 3, 4 } end
	modele = modele:gsub("([%(%)%.%+%-%*%?%[%]%^%$])", "%%%1")
	modele = modele:gsub("%%s", "(.+)"):gsub("%%d", "(%%d+)")
	motif = "^" .. modele .. "$"
	return motif, ordre
end

local function EstMoi(qui)
	local prenom = UnitName("player")
	if not prenom or not qui then return false end
	if qui == prenom or Normaliser(qui) == MaCle() then return true end
	return qui:sub(1, #prenom + 1) == prenom .. " " or qui:sub(1, #prenom + 1) == prenom .. "-"
end

local function LireLancer(texte)
	if not attenteDe or type(texte) ~= "string" then return end
	local m, o = Motif()
	local c = { texte:match(m) }
	if #c < 4 then return end
	local v = {}
	for i = 1, 4 do v[o[i] or i] = c[i] end
	local valeur, mini, maxi = tonumber(v[2]), tonumber(v[3]), tonumber(v[4])
	if not valeur or mini ~= 1 or maxi ~= 100 or not EstMoi(v[1]) then return end
	local a = attenteDe
	attenteDe = nil
	local t, moi = a.tirage, MaCle()
	if not NoterLancer(t, moi, moi, a.tour, valeur) then return end
	Envoyer(("L~%s~%s~%d~%d"):format(t.chef, t.id, a.tour, valeur))
	MajFenetre()
end

local function Lancer(t)
	local moi = MaCle()
	if not moi or not PeutLancer(t, moi) then return end
	if attenteDe then return end
	if not RandomRoll then Erreur("Ce client ne permet pas de lancer les dés depuis l'addon"); return end
	attenteDe = { tirage = t, tour = t.tour, limite = GetTime() + ATTENTE_DE }
	if not pcall(RandomRoll, 1, 100) then
		attenteDe = nil
		Erreur("Le jeu a refusé le lancer de dés")
	end
	MajFenetre()
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui then return end
	local genre, suite = msg:match("^(%u)~(.*)$")
	if not genre then return end
	if genre == "O" then
		local id, duree, objet, texte = suite:match("^(%w+)~(%d+)~(%d+)~(.*)$")
		if not id then return end
		duree, objet = math.max(10, math.min(tonumber(duree) or DUREE, 600)), tonumber(objet)
		local invites
		if id:sub(-1) == "R" then
			local a = annonces[qui .. "~" .. id]
			invites = a and a.cles or {}
		end
		local t = Creer(qui, expediteur, id, duree, objet ~= 0 and objet or nil, texte, invites)
		if not t then return end -- (déjà connu : mon propre tirage qui me revient)
		annonces[t.cle] = nil
		local pourMoi = not invites or invites[MaCle()]
		if pourMoi and not (vue and vue.etat == "ouvert") then vue = t end
		MajFenetre()
		if pourMoi and ns.Notifier then
			ns.Notifier("tirages", "Tirage au sort", ("%s ouvre un tirage : |cffffd100%s|r · %d s pour lancer les dés")
				:format(NomJoueur(expediteur), NomLot(t), duree), "READY_CHECK",
				function() vue = t; if ns.MontrerTirage then ns.MontrerTirage() end end)
		end
	elseif genre == "P" then
		local id, cles = suite:match("^(%w+)~(.+)$")
		if not id or id:sub(-1) ~= "R" then return end
		local cle = qui .. "~" .. id
		local t = tirages[cle]
		if t then
			-- (liste arrivée après l'ouverture : on complète, tant que le premier tour n'est pas fini)
			if t.chef == MaCle() or not t.invites or t.etat ~= "ouvert" or t.tour ~= 1 then return end
			for c in cles:gmatch("[^~]+") do t.invites[c] = true; t.admis[c] = true end
			MajFenetre()
			return
		end
		local a = annonces[cle]
		if not a then a = { cles = {} }; annonces[cle] = a end
		a.quand = GetTime()
		for c in cles:gmatch("[^~]+") do a.cles[c] = true end
	elseif genre == "L" then
		local chef, id, tour, valeur = suite:match("^([^~]+)~(%w+)~(%d+)~(%d+)$")
		local t = chef and tirages[chef .. "~" .. id]
		if not t then return end
		-- l'organisateur ne compte plus les lancers arrivés après son délai de grâce
		if t.chef == MaCle() and GetTime() > t.fin + GRACE then return end
		if NoterLancer(t, qui, expediteur, tonumber(tour), tonumber(valeur)) then MajFenetre() end
	elseif genre == "E" then
		local id, tour, duree, cles = suite:match("^(%w+)~(%d+)~(%d+)~(.+)$")
		local t = id and tirages[qui .. "~" .. id]
		if not t then return end
		Reprendre(t)
		local admis = {}
		for cle in cles:gmatch("[^~]+") do admis[cle] = true end
		duree = math.max(10, math.min(tonumber(duree) or DUREE_DEPARTAGE, 600))
		if not NouveauTour(t, tonumber(tour), duree, admis) then return end
		MajFenetre()
		if admis[MaCle()] and ns.Notifier then
			ns.Notifier("tirages", "Tirage au sort : égalité !", ("Relance les dés pour |cffffd100%s|r · %d s")
				:format(NomLot(t), duree), "READY_CHECK",
				function() vue = t; if ns.MontrerTirage then ns.MontrerTirage() end end)
		end
	elseif genre == "F" then
		local id, gagnant, hasard = suite:match("^(%w+)~([^~]*)~(%d)$")
		local t = id and tirages[qui .. "~" .. id]
		if not t then return end
		Reprendre(t)
		if not Clore(t, "fini", gagnant ~= "" and gagnant or nil, hasard == "1") then return end
		MajFenetre()
		if t.gagnant == MaCle() and ns.PluieEmotes then ns.PluieEmotes(4) end
		if (not t.invites or t.invites[MaCle()]) and ns.Notifier then
			local l = t.gagnant and t.lancers[t.gagnant]
			ns.Notifier("tirages", "Tirage au sort", t.gagnant
				and ("%s remporte |cffffd100%s|r%s"):format(NomJoueur(t.gagnant), NomLot(t),
					(l and l.tours[1] and t.tour == 1) and (" avec un " .. l.tours[1]) or "")
				or ("Personne n'a lancé les dés pour |cffffd100%s|r"):format(NomLot(t)), nil,
				function() vue = t; if ns.MontrerTirage then ns.MontrerTirage() end end)
		end
	elseif genre == "A" then
		local t = tirages[qui .. "~" .. suite]
		if not t then return end
		Reprendre(t)
		if Clore(t, "annule") then MajFenetre() end
	end
end

--------------------------------------------------------------------------------
-- Chrono : clôture par l'organisateur, tirage interrompu chez les autres, lancer non lu
--------------------------------------------------------------------------------

local chrono = CreateFrame("Frame")
local ecoule = 0
chrono:RegisterEvent("CHAT_MSG_SYSTEM")
chrono:SetScript("OnEvent", function(_, _, texte) LireLancer(texte) end)
chrono:SetScript("OnUpdate", function(_, dt)
	ecoule = ecoule + dt
	if ecoule < 0.5 then return end
	ecoule = 0
	local maintenant, moi = GetTime(), MaCle()
	if attenteDe and maintenant > attenteDe.limite then
		attenteDe = nil
		Erreur("Ton lancer de dés n'a pas été lu : réessaie")
		MajFenetre()
	end
	for _, t in pairs(tirages) do
		if t.etat == "ouvert" then
			if t.chef == moi then
				if maintenant > t.fin + GRACE then Cloturer(t) end
			elseif maintenant > t.fin + SANS_NOUVELLES then
				Clore(t, "interrompu")
				MajFenetre()
			end
		end
	end
end)

--------------------------------------------------------------------------------
-- Fenêtre
--------------------------------------------------------------------------------

local LARGEUR, HAUT_LIGNE, LIGNES = 340, 24, 8

local function TirageAMontrer()
	if vue and tirages[vue.cle] == vue then return vue end
	vue = nil
	-- le plus récent encore ouvert, sinon le dernier terminé
	for _, t in pairs(tirages) do
		if not vue or (t.etat == "ouvert" and vue.etat ~= "ouvert")
			or ((t.etat == "ouvert") == (vue.etat == "ouvert") and t.fin > vue.fin) then
			vue = t
		end
	end
	return vue
end

local function DemanderLot()
	ns.UI.DemanderTexte({
		titre = "Nouveau tirage au sort", bouton = "Ouvrir", maxLettres = 60, vide = true,
		texte = "Quel est le lot ? (facultatif)\nPour un objet : écris /smb roll puis Maj + clic sur l'objet.",
		valider = function(texte) if ns.PreparerTirage then ns.PreparerTirage(nil, texte) end end,
	})
end

--------------------------------------------------------------------------------
-- Choix des participants, avant l'ouverture
--------------------------------------------------------------------------------

local LARGEUR_CHOIX, LIGNES_CHOIX = 300, 10

-- moi d'abord, puis les membres connectés qui ont l'addon, par nom
local function Presents()
	local moi = MaCle()
	local autres = {}
	for _, cle in ipairs(ns.ClesMembresActifs and ns.ClesMembresActifs() or {}) do
		if cle ~= moi then autres[#autres + 1] = { cle = cle, nom = NomJoueur(cle) } end
	end
	table.sort(autres, function(a, b) return a.nom < b.nom end)
	table.insert(autres, 1, { cle = moi, nom = NomJoueur(moi) .. " (moi)" })
	return autres
end

-- clés des membres de mon groupe ou de mon raid, moi compris (nil si je suis seul)
local function ClesGroupe()
	local cles, trouve = {}, false
	for _, genre in ipairs({ "party", "raid" }) do
		for i = 1, genre == "raid" and 40 or 4 do
			local unite = genre .. i
			if UnitExists(unite) then
				local cle = ns.NomComplet and ns.NomComplet(unite)
				if cle then cles[cle] = true; trouve = true end
			end
		end
	end
	if not trouve then return nil end
	cles[MaCle()] = true
	return cles
end

local function MajChoix()
	local f = choix
	if not f or not f:IsShown() then return end
	local coches = 0
	for i, m in ipairs(f.membres) do
		local l = f.lignes[i]
		if not l then
			l = ns.UI.Case(f.liste.contenu, "", function(oui)
				local membre = f.membres[i]
				if membre then f.coches[membre.cle] = oui or nil end
				MajChoix()
			end)
			l:SetPoint("TOPLEFT", f.liste.contenu, "TOPLEFT", 2, -(i - 1) * HAUT_LIGNE - 1)
			l:SetWidth(LARGEUR_CHOIX - 44)
			f.lignes[i] = l
		end
		l.texte:SetText(m.nom)
		l:Poser(f.coches[m.cle])
		l:Show()
		if f.coches[m.cle] then coches = coches + 1 end
	end
	for i = #f.membres + 1, #f.lignes do f.lignes[i]:Hide() end
	f.liste:Hauteur(math.max(1, #f.membres * HAUT_LIGNE))
	if coches == #f.membres then
		f.compte:SetText("Toute la guilde participe")
	else
		f.compte:SetText(("Tirage réservé : |cffffd100%d|r membre%s sur %d"):format(coches, coches > 1 and "s" or "", #f.membres))
	end
	f.ouvrir:Activer(coches > 0)
	f.groupe:Activer(ClesGroupe() ~= nil)
end

local function CreerChoix()
	local UI = ns.UI
	local C = UI.C
	local f = CreateFrame("Frame", "GuildUpSMBTirageChoix", UIParent, "BackdropTemplate")
	UI.Habiller(f, C.fond, C.bordFort)
	f:SetSize(LARGEUR_CHOIX, 172 + LIGNES_CHOIX * HAUT_LIGNE)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 80)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	tinsert(UISpecialFrames, "GuildUpSMBTirageChoix") -- Échap ferme
	f:Hide()
	f.membres, f.coches, f.lignes = {}, {}, {}

	f.titre = UI.Texte(f, "GameFontNormal", C.ors)
	f.titre:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
	f.titre:SetText("Qui participe au tirage ?")
	local croix = UI.Fermer(f, function() f:Hide() end, 22)
	croix:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -10)
	f.lot = UI.Texte(f, "GameFontHighlight", C.texte)
	f.lot:SetPoint("TOPLEFT", f.titre, "BOTTOMLEFT", 0, -8)
	f.lot:SetPoint("RIGHT", f, "RIGHT", -16, 0)

	local function Cocher(cles)
		f.coches = {}
		for _, m in ipairs(f.membres) do
			if cles == true or (cles and cles[m.cle]) then f.coches[m.cle] = true end
		end
		MajChoix()
	end
	f.tout = UI.Bouton(f, "Tout cocher", "fantome", 86, 24)
	f.tout:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -62)
	f.tout:SetScript("OnClick", function() Cocher(true) end)
	f.rien = UI.Bouton(f, "Tout décocher", "fantome", 92, 24)
	f.rien:SetPoint("LEFT", f.tout, "RIGHT", 4, 0)
	f.rien:SetScript("OnClick", function() Cocher(nil) end)
	f.groupe = UI.Bouton(f, "Mon groupe", "fantome", 82, 24)
	f.groupe:SetPoint("LEFT", f.rien, "RIGHT", 4, 0)
	f.groupe:SetScript("OnClick", function() Cocher(ClesGroupe()) end)
	UI.Infobulle(f.groupe, "Mon groupe", "Ne coche que les membres de ton groupe ou de ton raid (ceux qui ont l'addon).")

	f.liste = UI.Liste(f)
	f.liste:SetPoint("TOPLEFT", f.tout, "BOTTOMLEFT", 0, -8)
	f.liste:SetSize(LARGEUR_CHOIX - 32, LIGNES_CHOIX * HAUT_LIGNE)

	f.compte = UI.Texte(f, "GameFontHighlightSmall", C.gris)
	f.compte:SetPoint("TOPLEFT", f.liste, "BOTTOMLEFT", 0, -8)
	f.ouvrir = UI.Bouton(f, "Ouvrir le tirage", "or", 140, 28)
	f.ouvrir:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 14)
	f.ouvrir:SetScript("OnClick", function()
		local invites, coches = {}, 0
		for _, m in ipairs(f.membres) do
			if f.coches[m.cle] then invites[m.cle] = true; coches = coches + 1 end
		end
		if coches == 0 then return end
		f:Hide()
		-- tout coché : tirage ouvert à toute la guilde, y compris à ceux qui se connectent ensuite
		Ouvrir(f.objet, f.texte, coches < #f.membres and invites or nil)
	end)
	f.annuler = UI.Bouton(f, "Annuler", "fantome", 90, 28)
	f.annuler:SetPoint("RIGHT", f.ouvrir, "LEFT", -8, 0)
	f.annuler:SetScript("OnClick", function() f:Hide() end)
	return f
end

-- Montre la liste des membres connectés (tous cochés) avant d'ouvrir le tirage
ns.PreparerTirage = function(objet, texte)
	if not ns.UI or not PeutOuvrir() then return end
	choix = choix or CreerChoix()
	local f = choix
	f.objet, f.texte = objet, texte or ""
	f.membres, f.coches = Presents(), {}
	for _, m in ipairs(f.membres) do f.coches[m.cle] = true end
	local nom = objet and (select(2, ns.InfoObjet(objet)) or ns.InfoObjet(objet) or ("objet n° " .. objet))
	local mot = strtrim(((texte or ""):gsub("[~|\r\n]", " ")))
	f.lot:SetText("Lot : " .. (nom and (mot ~= "" and (nom .. " · " .. mot) or nom) or (mot ~= "" and mot or "un lot")))
	f.liste:Haut()
	f:Show()
	f:Raise()
	MajChoix()
end

local function CreerFenetre()
	local UI = ns.UI
	local C = UI.C
	local f = CreateFrame("Frame", "GuildUpSMBTirage", UIParent, "BackdropTemplate")
	UI.Habiller(f, C.fond, C.bordFort)
	f:SetSize(LARGEUR, 150 + LIGNES * HAUT_LIGNE + 56)
	f:SetPoint("CENTER", UIParent, "CENTER", 260, 60)
	f:SetFrameStrata("DIALOG")
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	tinsert(UISpecialFrames, "GuildUpSMBTirage") -- Échap ferme
	f:Hide()

	f.titre = UI.Texte(f, "GameFontNormal", C.ors)
	f.titre:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -14)
	f.titre:SetText("Tirage au sort")
	local croix = UI.Fermer(f, function() f:Hide() end, 22)
	croix:SetPoint("TOPRIGHT", f, "TOPRIGHT", -10, -10)

	-- le lot : icône de l'objet (infobulle au survol) et son nom
	f.lot = CreateFrame("Button", nil, f)
	f.lot:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -42)
	f.lot:SetSize(LARGEUR - 32, 30)
	f.lot.icone = f.lot:CreateTexture(nil, "ARTWORK")
	f.lot.icone:SetSize(28, 28)
	f.lot.icone:SetPoint("LEFT", f.lot, "LEFT", 0, 0)
	f.lot.nom = UI.Texte(f.lot, "GameFontHighlight", C.texte)
	f.lot.nom:SetPoint("RIGHT", f.lot, "RIGHT", 0, 0)
	f.lot:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		if pcall(GameTooltip.SetHyperlink, GameTooltip, "item:" .. self.objet) then GameTooltip:Show() end
	end)
	f.lot:SetScript("OnLeave", function() GameTooltip:Hide() end)

	f.chef = UI.Texte(f, "GameFontHighlightSmall", C.gris)
	f.chef:SetPoint("TOPLEFT", f.lot, "BOTTOMLEFT", 0, -4)
	f.etat = UI.Texte(f, "GameFontHighlight", C.texte)
	f.etat:SetPoint("TOPLEFT", f.chef, "BOTTOMLEFT", 0, -8)
	f.etat:SetWidth(LARGEUR - 32)
	f.etat:SetHeight(28)
	f.etat:SetJustifyV("TOP")
	f.etat:SetWordWrap(true)

	f.lancer = UI.Bouton(f, "Lancer les dés", "or", LARGEUR - 32, 30)
	f.lancer:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -136)
	f.lancer:SetScript("OnClick", function()
		local t = TirageAMontrer()
		if t and t.etat == "ouvert" then Lancer(t) else DemanderLot() end
	end)

	f.liste = UI.Liste(f)
	f.liste:SetPoint("TOPLEFT", f.lancer, "BOTTOMLEFT", 0, -10)
	f.liste:SetSize(LARGEUR - 32, LIGNES * HAUT_LIGNE)
	f.lignes = {}

	f.cloturer = UI.Bouton(f, "Clôturer", "fantome", 110, 26)
	f.cloturer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -16, 14)
	f.cloturer:SetScript("OnClick", function()
		local t = TirageAMontrer()
		if t then Cloturer(t) end
	end)
	f.annuler = UI.Bouton(f, "Annuler", "fantome", 90, 26)
	f.annuler:SetPoint("RIGHT", f.cloturer, "LEFT", -8, 0)
	f.annuler:SetScript("OnClick", function()
		local t = TirageAMontrer()
		if t then Annuler(t) end
	end)

	-- le compte à rebours avance tant que la fenêtre est ouverte
	local attente = 0
	f:SetScript("OnUpdate", function(_, dt)
		attente = attente + dt
		if attente < 0.25 then return end
		attente = 0
		MajFenetre()
	end)
	return f
end

local function Ligne(f, i)
	local l = f.lignes[i]
	if l then return l end
	local UI = ns.UI
	local C = UI.C
	l = CreateFrame("Frame", nil, f.liste.contenu)
	l:SetHeight(HAUT_LIGNE)
	l:SetPoint("TOPLEFT", f.liste.contenu, "TOPLEFT", 0, -(i - 1) * HAUT_LIGNE)
	l:SetPoint("RIGHT", f.liste.contenu, "RIGHT", 0, 0)
	l.rang = UI.Texte(l, "GameFontHighlight", C.gris)
	l.rang:SetPoint("LEFT", l, "LEFT", 2, 0)
	l.rang:SetWidth(22)
	l.valeur = UI.Texte(l, "GameFontHighlight", C.texte)
	l.valeur:SetPoint("RIGHT", l, "RIGHT", -2, 0)
	l.valeur:SetJustifyH("RIGHT")
	l.nom = UI.Texte(l, "GameFontHighlight", C.texte)
	l.nom:SetPoint("LEFT", l.rang, "RIGHT", 4, 0)
	l.nom:SetPoint("RIGHT", l.valeur, "LEFT", -8, 0)
	f.lignes[i] = l
	return l
end

local function Secondes(t) return math.max(0, math.ceil(t.fin - GetTime())) end

MajFenetre = function()
	local f = fenetre
	if not f or not f:IsShown() then return end
	local C = ns.UI.C
	local t = TirageAMontrer()
	local moi = MaCle()
	if not t then
		f.lot.objet = nil
		f.lot.icone:Hide()
		f.lot.nom:ClearAllPoints()
		f.lot.nom:SetPoint("LEFT", f.lot, "LEFT", 0, 0)
		f.lot.nom:SetPoint("RIGHT", f.lot, "RIGHT", 0, 0)
		f.lot.nom:SetText("Aucun tirage en cours")
		f.chef:SetText("")
		f.etat:SetText("Ouvre un tirage : toute la guilde reçoit une bulle et lance les dés.")
		f.lancer:Ecrire("Nouveau tirage")
		f.lancer:Activer(true)
		f.cloturer:Hide(); f.annuler:Hide()
		for _, l in ipairs(f.lignes) do l:Hide() end
		f.liste:Hauteur(1)
		return
	end
	-- le lot
	local icone = t.objet and select(4, ns.InfoObjet(t.objet))
	f.lot.objet = t.objet
	f.lot.icone:SetShown(icone and true or false)
	if icone then f.lot.icone:SetTexture(icone) end
	f.lot.nom:ClearAllPoints()
	f.lot.nom:SetPoint("LEFT", f.lot, "LEFT", icone and 36 or 0, 0)
	f.lot.nom:SetPoint("RIGHT", f.lot, "RIGHT", 0, 0)
	f.lot.nom:SetText(NomLot(t))
	local invites = 0
	for _ in pairs(t.invites or {}) do invites = invites + 1 end
	f.chef:SetText("Ouvert par " .. NomJoueur(t.nomChef) .. (t.invites
		and (" · réservé à %d membre%s"):format(invites, invites > 1 and "s" or "") or " · toute la guilde"))

	-- l'état et le bouton principal
	local classement = Classement(t)
	local ouvert = t.etat == "ouvert"
	if ouvert then
		local reste = Secondes(t)
		local l = t.lancers[moi]
		if reste <= 0 then
			f.etat:SetText("Temps écoulé : résultat dans un instant…")
		elseif t.tour > 1 then
			local admis = 0
			for _ in pairs(t.admis or {}) do admis = admis + 1 end
			f.etat:SetText(("|cffffd100Égalité !|r Départage n° %d entre %d membres · encore %d s"):format(t.tour - 1,
				admis, reste))
		else
			f.etat:SetText(("Lance les dés (1 à 100) · encore |cffffd100%d s|r"):format(reste))
		end
		if attenteDe and attenteDe.tirage == t then
			f.lancer:Ecrire("Les dés roulent…")
		elseif l and l.tours[t.tour] then
			f.lancer:Ecrire(("Tu as fait %d"):format(l.tours[t.tour]))
		elseif t.invites and not t.invites[moi] then
			f.lancer:Ecrire("Tu ne participes pas à ce tirage")
		elseif t.admis and not t.admis[moi] then
			f.lancer:Ecrire(l and "Tu n'es plus en lice" or "Départage en cours")
		else
			f.lancer:Ecrire(t.tour > 1 and "Relancer les dés" or "Lancer les dés")
		end
		f.lancer:Activer(moi ~= nil and PeutLancer(t, moi) and not attenteDe)
	else
		if t.etat == "annule" then
			f.etat:SetText("Tirage annulé par l'organisateur.")
		elseif t.etat == "interrompu" then
			f.etat:SetText("Tirage interrompu : l'organisateur ne répond plus. Classement provisoire ci-dessous.")
		elseif t.gagnant then
			f.etat:SetText(("|cffffd100%s|r remporte le tirage%s"):format(NomJoueur(t.gagnant),
				t.hasard and " (égalité tranchée au sort)" or " !"))
		else
			f.etat:SetText("Personne n'a lancé les dés.")
		end
		f.lancer:Ecrire("Nouveau tirage")
		f.lancer:Activer(true)
	end
	local chef = ouvert and t.chef == moi
	f.cloturer:SetShown(chef)
	f.annuler:SetShown(chef)

	-- le classement
	for i, c in ipairs(classement) do
		local l = Ligne(f, i)
		local gagne = t.etat == "fini" and c.cle == t.gagnant
		local valeurs = {}
		for n = 1, t.tour do valeurs[#valeurs + 1] = c.tours[n] and tostring(c.tours[n]) or "–" end
		l.rang:SetText(i .. ".")
		l.nom:SetText(NomJoueur(c.nom))
		l.valeur:SetText(table.concat(valeurs, " · "))
		local couleur = (gagne or c.cle == moi) and C.ors or C.texte
		l.nom:SetTextColor(unpack(couleur))
		l.valeur:SetTextColor(unpack(gagne and C.ors or C.texte))
		l:Show()
	end
	for i = #classement + 1, #f.lignes do f.lignes[i]:Hide() end
	f.liste:Hauteur(math.max(1, #classement * HAUT_LIGNE))
end

ns.MontrerTirage = function()
	if not ns.UI then return end
	fenetre = fenetre or CreerFenetre()
	fenetre:Show()
	fenetre:Raise()
	MajFenetre()
end

-- /smb roll : la fenêtre ; /smb roll <texte ou lien d'objet> : choix des participants, puis ouverture
ns.Tirage = function(saisie)
	saisie = strtrim(saisie or "")
	if saisie == "" then ns.MontrerTirage(); return end
	local objet = tonumber(saisie:match("item:(%d+)"))
	-- le lien retiré, il reste le commentaire
	local texte = saisie:gsub("|c%x+|H.-|h.-|h|r", ""):gsub("|H.-|h.-|h", "")
	ns.PreparerTirage(objet, texte)
end

ns.Ecouter(PREFIXE, Recevoir)
