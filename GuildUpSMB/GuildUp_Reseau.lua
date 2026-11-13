-- GuildUpSMB : réseau commun à tous les modules (chargé juste après GuildUp_Outils.lua, voir le .toc).
--   * une seule file d'envoi des messages d'addon (le jeu en limite le nombre par seconde), en deux
--     voies : les messages courants d'abord, les longs envois de rattrapage derrière (voir plus bas) ;
--   * une seule réception (ns.Ecouter) : inscription du préfixe, canal vérifié, aiguillage par préfixe ;
--   * découpage d'une longue liste en morceaux (ns.Morceaux) et réassemblage (ns.Reassembleur).

local NOM_ADDON, ns = ...

-- Longueur maximale d'un message d'addon accepté par le jeu (octets)
local LONGUEUR_MAX = 255
ns.LONGUEUR_MAX = LONGUEUR_MAX

local stats = { envoyes = 0, bloques = 0, echecs = 0, jetes = 0, recus = 0, maxFile = 0,
	fond = 0, doublons = 0, debordes = 0 }

-- Message d'addon qui n'a pas pu partir : prévenu à l'écran (au plus une fois toutes les 30 s)
local dernierAvertissement = -math.huge
local function AvertirEchec(prefixe, raison)
	stats.echecs = stats.echecs + 1
	if GetTime() - dernierAvertissement < 30 then return end
	dernierAvertissement = GetTime()
	if UIErrorsFrame and UIErrorsFrame.AddMessage then
		UIErrorsFrame:AddMessage(("SMB Forever : un message (%s) n'a pas pu partir : %s"):format(prefixe or "?", raison), 1, 0.82, 0)
	end
end

--------------------------------------------------------------------------------
-- Envoi : un message toutes les 0,3 s ; nouvel essai (jusqu'à 6) si le jeu refuse (trop de messages)
--
-- Deux voies. À la connexion d'un membre, le relais (ns.EstLeRelais) lui renvoie ce qu'il a manqué :
-- dons, besoins, projets, événements, groupes, quêtes, identités, fil d'activité, souvenirs, relevés
-- de présence. Cela fait des dizaines de messages, et tant qu'ils défilent, un appel à l'aide ou un
-- vote attend derrière. Ces longs envois passent donc en « fond » : un module qui met plus de
-- RAFALE_MAX messages du même préfixe dans la file en moins de RAFALE_FENETRE secondes est en train de
-- relayer, et le reste de son envoi part plus lentement (DELAI_FOND), toujours après les messages
-- courants. Un module peut aussi le dire lui-même avec options.fond. Comme tout part sur le canal de
-- guilde et que tout le monde le lit, un message de fond identique envoyé il y a moins de DOUBLON
-- secondes n'est pas renvoyé : deux membres qui se connectent coup sur coup ne font pas tout répéter.
--------------------------------------------------------------------------------

local DELAI, DELAI_FOND = 0.3, 1.2
local RAFALE_MAX, RAFALE_FENETRE = 3, 10
local FILE_CHARGEE = 6   -- au-delà, plusieurs modules relaient en même temps : on resserre le seuil
local DOUBLON = 90       -- secondes : un même message de fond n'est pas renvoyé avant
local MAX_FOND = 200     -- messages de fond en attente au plus (au-delà, les plus anciens sont jetés)

local file, fond = {}, {}
local pause, dernierEnvoi = 0, 0
local rafales = {}       -- [préfixe] = { n, depuis } : messages mis en file récemment
local envoyes = {}       -- [préfixe .. msg] = heure du dernier envoi en fond

local pompe = CreateFrame("Frame")
pompe:Hide()
pompe:SetScript("OnUpdate", function(self)
	local maintenant = GetTime()
	if maintenant < pause then return end
	-- les messages courants d'abord ; le fond seulement quand ils sont tous partis
	local m, defond = file[1], false
	if not m then m, defond = fond[1], true end
	if not m then self:Hide(); return end
	if maintenant - dernierEnvoi < (defond and DELAI_FOND or DELAI) then return end
	local voie = defond and fond or file
	if (m.canal or "GUILD") == "GUILD" and not IsInGuild() then
		table.remove(voie, 1)
		return
	end
	local envoi = (C_ChatInfo and C_ChatInfo.SendAddonMessage) or SendAddonMessage
	local ok, res = false, nil
	if envoi then ok, res = pcall(envoi, m.prefixe, m.msg, m.canal or "GUILD", m.cible) end
	-- false (ancienne API) ou 3 / 8 (Enum.SendAddonMessageResult : trop de messages) : on réessaie
	local bloque = ok and (res == false or res == 3 or res == 8)
	if bloque and m.essais < 6 and not m.jetable then
		m.essais = m.essais + 1
		stats.bloques = stats.bloques + 1
		pause = maintenant + 1.5
	else
		if not ok then
			AvertirEchec(m.prefixe, tostring(res))
		elseif bloque then
			if m.jetable then stats.jetes = stats.jetes + 1 else AvertirEchec(m.prefixe, "trop de messages") end
		else
			stats.envoyes = stats.envoyes + 1
			if defond then
				stats.fond = stats.fond + 1
				envoyes[m.prefixe .. m.msg] = maintenant
			end
		end
		table.remove(voie, 1)
		dernierEnvoi = maintenant
	end
end)

-- Ce préfixe est-il en train d'envoyer une longue liste ? (plus de RAFALE_MAX messages d'affilée)
-- À la connexion d'un membre, dix modules relaient en même temps : si chacun avait droit à ses trois
-- messages courants, la file en compterait trente avant le premier message de fond. Quand elle est
-- déjà chargée, le deuxième message d'un même préfixe suffit donc à reconnaître un relais.
local function EnRafale(prefixe)
	local maintenant = GetTime()
	local r = rafales[prefixe]
	if not r or maintenant - r.depuis > RAFALE_FENETRE then
		r = { n = 0, depuis = maintenant }
		rafales[prefixe] = r
	end
	r.n = r.n + 1
	r.depuis = maintenant
	return r.n > (#file > FILE_CHARGEE and 1 or RAFALE_MAX)
end

-- ns.EnvoyerAddon(préfixe, message, canal = "GUILD", cible, options)
--   options.jetable : message périodique (position…) : remplace celui du même préfixe encore en
--   attente, n'est jamais réessayé (le suivant le remplacera)
--   options.fond : long envoi de rattrapage, sans urgence : part après les messages courants, plus
--   lentement, et pas du tout s'il vient d'être envoyé (voir plus haut). Un envoi en rafale est
--   reconnu tout seul : les modules n'ont rien à déclarer. false : jamais en fond, même en rafale
--   (message attendu tout de suite). Les chuchotements d'addon ne passent jamais en fond.
ns.EnvoyerAddon = function(prefixe, msg, canal, cible, options)
	canal = canal or "GUILD"
	if canal == "GUILD" and not IsInGuild() then return end
	msg = tostring(msg or "")
	if #msg > LONGUEUR_MAX then
		-- le jeu le refuserait sans rien dire : on prévient au lieu de le perdre en silence
		AvertirEchec(prefixe, ("trop long (%d octets)"):format(#msg))
		return
	end
	local jetable = options and options.jetable
	if jetable then
		for i = #file, 2, -1 do -- (le premier est peut-être en cours d'envoi)
			if file[i].jetable and file[i].prefixe == prefixe then table.remove(file, i) end
		end
	end
	-- seuls les envois sur la guilde passent en fond : un chuchotement d'addon est un échange direct
	-- (commande d'artisanat, demande de layer) qu'on ne fait pas attendre
	local defond = false
	if not jetable and canal == "GUILD" and not (options and options.fond == false) then
		defond = (options and options.fond) or EnRafale(prefixe)
	end
	local m = { prefixe = prefixe, msg = msg, canal = canal, cible = cible, essais = 0, jetable = jetable }
	if defond then
		-- déjà parti il y a peu : tout le monde l'a reçu sur le canal de guilde
		local vu = envoyes[prefixe .. msg]
		local maintenant = GetTime()
		if vu and maintenant - vu < DOUBLON then stats.doublons = stats.doublons + 1; return end
		if vu == nil then
			-- ménage de temps en temps, pour ne pas garder tous les messages de la session
			local n = 0
			for _ in pairs(envoyes) do n = n + 1 end
			if n > 400 then
				for k, t in pairs(envoyes) do if maintenant - t > DOUBLON then envoyes[k] = nil end end
			end
		end
		fond[#fond + 1] = m
		while #fond > MAX_FOND do table.remove(fond, 1); stats.debordes = stats.debordes + 1 end
	else
		file[#file + 1] = m
	end
	if #file + #fond > stats.maxFile then stats.maxFile = #file + #fond end
	pompe:Show()
end

-- Pour /smb diag
ns.StatsReseau = function()
	return ("messages : %d envoyé(s) dont %d de rattrapage, %d reçu(s), %d bloqué(s) puis réessayé(s), %d jeté(s), %d déjà envoyé(s), %d débordé(s), %d échec(s), %d en attente dont %d de rattrapage (max %d)")
		:format(stats.envoyes, stats.fond, stats.recus, stats.bloques, stats.jetes, stats.doublons,
			stats.debordes, stats.echecs, #file + #fond, #fond, stats.maxFile)
end

--------------------------------------------------------------------------------
-- Réception : un seul cadre pour CHAT_MSG_ADDON, aiguillé par préfixe
--------------------------------------------------------------------------------

local ecouteurs = {}   -- [préfixe] = { fonction, canaux }
local actifs = {}      -- [clé] = dernier message reçu de ce membre (il a GuildUpSMB et il est là)
local vus = {}         -- [clé] = true : un message reçu de ce membre depuis le début de la session
local cadre = CreateFrame("Frame")
cadre:RegisterEvent("CHAT_MSG_ADDON")
cadre:SetScript("OnEvent", function(_, _, prefixe, msg, canal, expediteur)
	local e = prefixe and ecouteurs[prefixe]
	if not e or not msg or not expediteur or expediteur == "" then return end
	if not e.canaux[canal] then return end
	-- aucun message d'addon de GuildUpSMB ne contient « | » : on le retire (codes de couleur, liens,
	-- textures |T…|t qu'un message forgé glisserait dans une bulle ou une infobulle)
	if msg:find("|", 1, true) then msg = msg:gsub("|", "") end
	stats.recus = stats.recus + 1
	if canal == "GUILD" and ns.Normaliser then
		local cle = ns.Normaliser(expediteur)
		if cle then actifs[cle] = GetTime(); vus[cle] = true end
	end
	local ok, err = pcall(e.fonction, prefixe, msg, canal, expediteur)
	if not ok then
		stats.echecs = stats.echecs + 1
		ns.DerniereErreurReseau = ("%s : %s"):format(prefixe, tostring(err))
	end
end)

-- ns.Ecouter(préfixe, fonction(préfixe, message, canal, expéditeur), canaux)
--   canaux : canaux acceptés, par défaut { GUILD = true } (ex. { GUILD = true, WHISPER = true })
-- Une erreur dans la fonction n'interrompt pas les autres modules (notée pour /smb diag).
ns.Ecouter = function(prefixe, fonction, canaux)
	ecouteurs[prefixe] = { fonction = fonction, canaux = canaux or { GUILD = true } }
	local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
	if inscription then pcall(inscription, prefixe) end
end

-- Suis-je le relais ? Quand un membre se connecte, un seul membre lui renvoie les listes des absents
-- au lieu de toute la guilde : celui qui a la plus petite clé parmi les membres actifs (un message
-- de GuildUpSMB reçu depuis moins de 10 min, et pas hors ligne d'après la liste de guilde). « exclu » :
-- le membre qui vient de se connecter.
local ACTIF = 600
ns.EstLeRelais = function(exclu)
	local moi = ns.MaCle and ns.MaCle()
	if not moi then return true end
	local maintenant = GetTime()
	for cle, t in pairs(actifs) do
		if maintenant - t > ACTIF then
			actifs[cle] = nil
		elseif cle ~= exclu and cle ~= moi and cle < moi and not cle:find("#test", 1, true)
			and not (ns.EnLigneMembre and ns.MembreGuilde and ns.MembreGuilde(cle) ~= nil and not ns.EnLigneMembre(cle)) then
			return false
		end
	end
	return true
end

-- Nombre de membres connectés qui ont GuildUpSMB, moi compris : un message reçu pendant la session
-- (les présents répondent à l'annonce de version de chaque arrivant, GuildUp_Version.lua) et en ligne
-- d'après la liste de guilde ; sans liste de guilde lue, un message reçu depuis moins de 10 min.
ns.MembresActifs = function()
	local moi = ns.MaCle and ns.MaCle()
	return #ns.ClesMembresActifs() + (moi and 1 or 0)
end

-- Les clés de ces membres, sans moi (choix des participants d'un tirage au sort, GuildUp_Tirage.lua)
ns.ClesMembresActifs = function()
	local moi = ns.MaCle and ns.MaCle()
	local maintenant, cles = GetTime(), {}
	for cle in pairs(vus) do
		if cle ~= moi and not cle:find("#test", 1, true) then
			local membre = ns.MembreGuilde and ns.MembreGuilde(cle)
			local compte
			if membre == nil or not ns.EnLigneMembre then
				compte = actifs[cle] and maintenant - actifs[cle] <= ACTIF
			else
				compte = membre and ns.EnLigneMembre(cle)
			end
			if compte then cles[#cles + 1] = cle end
		end
	end
	return cles
end

--------------------------------------------------------------------------------
-- Longues listes : découpage en morceaux et réassemblage
--------------------------------------------------------------------------------

-- Regroupe des mots (séparés par des virgules) en morceaux d'au plus `taille` caractères.
-- Toujours au moins un morceau (vide si la liste est vide : « plus rien »).
ns.Morceaux = function(mots, taille)
	local morceaux, cour, long = {}, {}, 0
	for _, m in ipairs(mots) do
		if long + #m + 1 > taille and #cour > 0 then
			morceaux[#morceaux + 1] = table.concat(cour, ",")
			cour, long = {}, 0
		end
		cour[#cour + 1] = m
		long = long + #m + 1
	end
	morceaux[#morceaux + 1] = table.concat(cour, ",")
	return morceaux
end

-- Réassemblage des morceaux reçus.
--   local r = ns.Reassembleur(maxMorceaux)
--   local parts = r:Ajouter(cle, version, part, total, texte)
-- renvoie la liste complète des morceaux (dans l'ordre) quand tout est arrivé, sinon nil.
-- cle : un envoi (ex. expéditeur .. métier) ; version : ce qui change d'un envoi à l'autre
-- (empreinte, date) ; un morceau déjà reçu qui revient = nouvel envoi. Numéros contrôlés
-- (entiers, 1 <= part <= total <= maxMorceaux) ; les envois incomplets sont oubliés après 2 min.
local OUBLI_MORCEAUX = 120
local Reassembleur = {}
Reassembleur.__index = Reassembleur
function Reassembleur:Ajouter(cle, version, part, total, texte)
	part, total = tonumber(part), tonumber(total)
	if not (cle and part and total) or part ~= math.floor(part) or total ~= math.floor(total)
		or part < 1 or total < 1 or part > total or total > self.max then
		return nil
	end
	local maintenant = GetTime()
	for k, t in pairs(self.enCours) do
		if maintenant - t.debut > OUBLI_MORCEAUX then self.enCours[k] = nil end
	end
	local t = self.enCours[cle]
	if not t or t.version ~= version or t.total ~= total or t.parts[part] then
		t = { version = version, total = total, n = 0, parts = {}, debut = maintenant }
		self.enCours[cle] = t
	end
	t.parts[part] = texte or ""
	t.n = t.n + 1
	if t.n < t.total then return nil end
	self.enCours[cle] = nil
	return t.parts
end
ns.Reassembleur = function(maxMorceaux)
	return setmetatable({ max = maxMorceaux or 60, enCours = {} }, Reassembleur)
end
