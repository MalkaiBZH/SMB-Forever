-- GuildUpSMB : layers des membres (préfixe "GuildUpLay").
-- Une même zone existe en plusieurs copies (« layers ») ; deux membres sur des layers différents ne se
-- voient pas. Le jeu ne donne pas le layer aux addons : on le déduit des PNJ. Le GUID d'un PNJ
-- (« Creature-0-serveur-instance-zone-PNJ-apparition ») porte des numéros propres à la copie de la zone
-- où il vit ; leur « signature » (serveur.instance.zone) est la même pour tous les PNJ d'un layer et
-- change d'un layer à l'autre. On ne cherche pas à savoir lequel de ces numéros est le layer : on compare
-- seulement les signatures, sur la même carte de zone.
-- Observation : PNJ survolés, ciblés ou dont la barre de nom apparaît (hors instance, sans les familiers
-- ni les joueurs). Mon layer = la signature la plus fréquente parmi les 5 derniers PNJ différents vus
-- (moins de 2 min, sur ma carte actuelle) : il suit un changement de layer en quelques PNJ.
--   "L~carte~signature"   mon layer, sur la guilde : quand il change, sinon toutes les 3 min (jetable)
--   "D"                   en chuchotement d'addon : « invite-moi, je voudrais passer sur ton layer »
-- Le layer d'un membre est oublié après 10 min sans nouvelles, ou s'il a changé de carte depuis.
-- Fournit ns.MemeLayer(clé) (true, false ou nil si on ne sait pas), ns.DemanderLayer(clé, nom) (menu
-- des repères), ns.TexteLayer(clé) (infobulles), /smb layer et une ligne de /smb diag.
-- Changer de layer : rejoindre le groupe d'un membre fait passer sur son layer (le jeu décide, après
-- quelques secondes, hors combat).

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpLay"
local DUREE_OBS = 120       -- secondes pendant lesquelles une observation compte
local DERNIERS = 5          -- PNJ les plus récents qui votent
local RAPPEL = 180          -- je redis mon layer au plus tard toutes les 3 min
local VALIDITE = 600        -- layer d'un membre oublié après 10 min sans nouvelles
local ENTRE_DEMANDES = 60   -- secondes entre deux demandes au même membre

local Normaliser = ns.Normaliser
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local NomCourt = ns.NomCourt
local MaCle = ns.MaCle

local observations = {} -- [GUID du PNJ] = { sig, t } (sur la carte carteObs)
local carteObs
local monLayer          -- { carte, sig, n = PNJ qui ont voté } ou nil
local envoye = { sig = nil, carte = nil, t = -math.huge }
local membres = {}      -- [clé] = { carte, sig, vu }
local demandes = {}     -- [clé] = GetTime() de ma dernière demande

local function MaCarte()
	if not ns.MaPosition then return nil end
	local carte = ns.MaPosition()
	return carte
end

local function EnInstance()
	return IsInInstance and IsInInstance() and true or false
end

-- signature de la copie de zone d'un PNJ, ou nil (joueur, familier, objet…)
local function Signature(guid)
	if type(guid) ~= "string" then return nil end
	local genre, _, serveur, instance, zone = strsplit("-", guid)
	if genre ~= "Creature" and genre ~= "Vehicle" then return nil end
	if not (serveur and instance and zone) or serveur == "" or zone == "" then return nil end
	return serveur .. "." .. instance .. "." .. zone
end

local function Envoyer(msg, canal, cible, jetable)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, canal or "GUILD", cible, jetable and { jetable = true } or nil) end
end

-- Recalcule mon layer d'après les observations, et le dit à la guilde s'il a changé (ou s'il est temps)
local function Recalculer()
	local carte = MaCarte()
	if not carte or EnInstance() or carte ~= carteObs then
		monLayer = nil
		return
	end
	local maintenant = GetTime()
	local recentes = {}
	for guid, o in pairs(observations) do
		if maintenant - o.t > DUREE_OBS then observations[guid] = nil
		else recentes[#recentes + 1] = o end
	end
	table.sort(recentes, function(a, b) return a.t > b.t end)
	local votes, meilleur, n = {}, nil, 0
	for i = 1, math.min(DERNIERS, #recentes) do
		local sig = recentes[i].sig
		votes[sig] = (votes[sig] or 0) + 1
		-- (à égalité : la plus récente, vue en premier, garde la place)
		if votes[sig] > n then meilleur, n = sig, votes[sig] end
	end
	if not meilleur then monLayer = nil; return end
	monLayer = { carte = carte, sig = meilleur, n = n }
	if meilleur ~= envoye.sig or carte ~= envoye.carte or maintenant - envoye.t > RAPPEL then
		envoye.sig, envoye.carte, envoye.t = meilleur, carte, maintenant
		Envoyer(("L~%d~%s"):format(carte, meilleur), "GUILD", nil, true)
	end
end

local function Observer(unite)
	if not unite or EnInstance() or not UnitExists(unite) or UnitIsPlayer(unite) then return end
	if UnitPlayerControlled and UnitPlayerControlled(unite) then return end -- (familiers, invocations)
	local guid = UnitGUID(unite)
	local sig = Signature(guid)
	if not sig then return end
	local carte = MaCarte()
	if not carte then return end
	if carte ~= carteObs then wipe(observations); carteObs = carte end
	local o = observations[guid]
	local nouveau = not o or o.sig ~= sig
	observations[guid] = { sig = sig, t = GetTime() }
	if nouveau then Recalculer() end
end

--------------------------------------------------------------------------------
-- Pour les autres modules
--------------------------------------------------------------------------------

-- true : même layer que moi ; false : un autre ; nil : on ne sait pas (pas sur ma carte, trop vieux…)
ns.MemeLayer = function(cle)
	local m = cle and membres[cle]
	if not (m and monLayer) or GetTime() - m.vu > VALIDITE or m.carte ~= monLayer.carte then return nil end
	local positions = ns.PositionsMembres and ns.PositionsMembres()
	local p = positions and positions[cle]
	if p and (p.instance or (p.carte and p.carte ~= m.carte)) then return nil end -- (a changé de carte depuis)
	return m.sig == monLayer.sig
end

-- ligne d'infobulle (texte coloré) ou nil
ns.TexteLayer = function(cle)
	local meme = ns.MemeLayer(cle)
	if meme == true then return "|cff70d18cMême layer que toi|r" end
	if meme == false then return "|cffff9f40Sur un autre layer|r (vous ne vous voyez pas)" end
	return nil
end

-- « Invite-moi » : chuchotement d'addon au membre, qui reçoit une bulle pour m'inviter
ns.DemanderLayer = function(cle, joueur)
	if not cle then return end
	local reste = ENTRE_DEMANDES - (GetTime() - (demandes[cle] or -math.huge))
	if reste > 0 then
		if ns.Erreur then ns.Erreur(("Demande déjà envoyée : attends encore %d s"):format(math.ceil(reste))) end
		return
	end
	local nom = (ns.NomListeGuilde and ns.NomListeGuilde(cle)) or NomCourt(joueur or cle)
	demandes[cle] = GetTime()
	Envoyer("D", "WHISPER", nom)
	if ns.Coeur and ns.Coeur.Message then
		ns.Coeur.Message(("demande envoyée à %s : accepte son invitation de groupe, le jeu te fera passer sur son layer (hors combat, après quelques secondes)."):format(NomJoueur(joueur or cle)))
	end
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local function Inviter(nom)
	local inviter = (C_PartyInfo and C_PartyInfo.InviteUnit) or InviteUnit
	if inviter then pcall(inviter, nom) end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui or qui == MaCle() then return end
	if canal == "GUILD" then
		local carte, sig = msg:match("^L~(%d+)~([%d%.]+)$")
		if carte then membres[qui] = { carte = tonumber(carte), sig = sig, vu = GetTime() } end
	elseif canal == "WHISPER" and msg == "D" then
		if ns.Notifier then
			ns.Notifier("groupes", "Changer de layer", ("%s voudrait passer sur ton layer. Clic : l'inviter dans ton groupe.")
				:format(NomJoueur(expediteur)), "READY_CHECK", function() Inviter(expediteur) end)
		end
	end
end

--------------------------------------------------------------------------------
-- /smb layer et /smb diag
--------------------------------------------------------------------------------

local function Bilan()
	local meme, autre = {}, {}
	for cle in pairs(membres) do
		local m = ns.MemeLayer(cle)
		if m == true then meme[#meme + 1] = NomJoueur(cle) elseif m == false then autre[#autre + 1] = NomJoueur(cle) end
	end
	table.sort(meme); table.sort(autre)
	return meme, autre
end

ns.MontrerLayer = function()
	Recalculer()
	local Message = (ns.Coeur and ns.Coeur.Message) or print
	if EnInstance() then Message("layer : en instance, pas de layer.") return end
	if not monLayer then
		Message("layer : pas encore connu. Survole ou cible quelques PNJ de la zone (pas des joueurs ni des familiers).")
		return
	end
	local meme, autre = Bilan()
	Message(("layer : %s (d'après %d PNJ). Même layer : %s. Autre layer : %s."):format(monLayer.sig, monLayer.n,
		#meme > 0 and table.concat(meme, ", ") or "personne", #autre > 0 and table.concat(autre, ", ") or "personne"))
end

ns.DiagLayers = function(L)
	local sigs, n = {}, 0
	for _, o in pairs(observations) do
		n = n + 1
		sigs[o.sig] = (sigs[o.sig] or 0) + 1
	end
	local liste = {}
	for sig, c in pairs(sigs) do liste[#liste + 1] = sig .. " ×" .. c end
	table.sort(liste)
	local connus = 0
	for _ in pairs(membres) do connus = connus + 1 end
	L(("layers : moi %s, %d PNJ observé(s) sur la carte %s [%s], %d membre(s) connu(s)"):format(
		monLayer and monLayer.sig or "inconnu", n, tostring(carteObs), table.concat(liste, ", "), connus))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
ev:RegisterEvent("PLAYER_TARGET_CHANGED")
ev:RegisterEvent("NAME_PLATE_UNIT_ADDED")
ev:SetScript("OnEvent", function(_, event, unite)
	if event == "UPDATE_MOUSEOVER_UNIT" then Observer("mouseover")
	elseif event == "PLAYER_TARGET_CHANGED" then Observer("target")
	else Observer(unite) end
end)
-- (changement de carte, observations trop vieilles, rappel à la guilde)
if C_Timer and C_Timer.NewTicker then C_Timer.NewTicker(10, Recalculer) end

ns.Ecouter(PREFIXE, Recevoir, { GUILD = true, WHISPER = true })
