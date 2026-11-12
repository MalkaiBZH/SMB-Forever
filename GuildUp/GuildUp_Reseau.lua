-- GuildUp : réseau commun à tous les modules (chargé juste après GuildUp_Outils.lua, voir le .toc).
--   * une seule file d'envoi des messages d'addon (le jeu en limite le nombre par seconde) ;
--   * une seule réception (ns.Ecouter) : inscription du préfixe, canal vérifié, aiguillage par préfixe ;
--   * découpage d'une longue liste en morceaux (ns.Morceaux) et réassemblage (ns.Reassembleur).

local NOM_ADDON, ns = ...

-- Longueur maximale d'un message d'addon accepté par le jeu (octets)
local LONGUEUR_MAX = 255
ns.LONGUEUR_MAX = LONGUEUR_MAX

local stats = { envoyes = 0, bloques = 0, echecs = 0, jetes = 0, recus = 0, maxFile = 0 }

-- Message d'addon qui n'a pas pu partir : prévenu à l'écran (au plus une fois toutes les 30 s)
local dernierAvertissement = -math.huge
local function AvertirEchec(prefixe, raison)
	stats.echecs = stats.echecs + 1
	if GetTime() - dernierAvertissement < 30 then return end
	dernierAvertissement = GetTime()
	if UIErrorsFrame and UIErrorsFrame.AddMessage then
		UIErrorsFrame:AddMessage(("GuildUp : un message (%s) n'a pas pu partir : %s"):format(prefixe or "?", raison), 1, 0.82, 0)
	end
end

--------------------------------------------------------------------------------
-- Envoi : un message toutes les 0,3 s ; nouvel essai (jusqu'à 6) si le jeu refuse (trop de messages)
--------------------------------------------------------------------------------

local file, attente = {}, 0
local pompe = CreateFrame("Frame")
pompe:Hide()
pompe:SetScript("OnUpdate", function(self, ecoule)
	attente = attente - ecoule
	if attente > 0 then return end
	local m = file[1]
	if not m then self:Hide(); return end
	if (m.canal or "GUILD") == "GUILD" and not IsInGuild() then
		table.remove(file, 1)
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
		attente = 1.5
	else
		if not ok then
			AvertirEchec(m.prefixe, tostring(res))
		elseif bloque then
			if m.jetable then stats.jetes = stats.jetes + 1 else AvertirEchec(m.prefixe, "trop de messages") end
		else
			stats.envoyes = stats.envoyes + 1
		end
		table.remove(file, 1)
		attente = 0.3
	end
end)

-- ns.EnvoyerAddon(préfixe, message, canal = "GUILD", cible, options)
--   options.jetable : message périodique (position…) : remplace celui du même préfixe encore en
--   attente, n'est jamais réessayé (le suivant le remplacera)
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
	file[#file + 1] = { prefixe = prefixe, msg = msg, canal = canal, cible = cible, essais = 0, jetable = jetable }
	if #file > stats.maxFile then stats.maxFile = #file end
	pompe:Show()
end

-- Pour /smb diag
ns.StatsReseau = function()
	return ("messages : %d envoyé(s), %d reçu(s), %d bloqué(s) puis réessayé(s), %d jeté(s), %d échec(s), %d en attente (max %d)")
		:format(stats.envoyes, stats.recus, stats.bloques, stats.jetes, stats.echecs, #file, stats.maxFile)
end

--------------------------------------------------------------------------------
-- Réception : un seul cadre pour CHAT_MSG_ADDON, aiguillé par préfixe
--------------------------------------------------------------------------------

local ecouteurs = {}   -- [préfixe] = { fonction, canaux }
local actifs = {}      -- [clé] = dernier message reçu de ce membre (il a GuildUp et il est là)
local cadre = CreateFrame("Frame")
cadre:RegisterEvent("CHAT_MSG_ADDON")
cadre:SetScript("OnEvent", function(_, _, prefixe, msg, canal, expediteur)
	local e = prefixe and ecouteurs[prefixe]
	if not e or not msg or not expediteur or expediteur == "" then return end
	if not e.canaux[canal] then return end
	-- aucun message d'addon de GuildUp ne contient « | » : on le retire (codes de couleur, liens,
	-- textures |T…|t qu'un message forgé glisserait dans une bulle ou une infobulle)
	if msg:find("|", 1, true) then msg = msg:gsub("|", "") end
	stats.recus = stats.recus + 1
	if canal == "GUILD" and ns.Normaliser then
		local cle = ns.Normaliser(expediteur)
		if cle then actifs[cle] = GetTime() end
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
-- de GuildUp reçu depuis moins de 10 min, et pas hors ligne d'après la liste de guilde). « exclu » :
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
