-- GuildUpSMB : annonces de la guilde en bulle (jamais dans le chat).
-- Préfixe "GuildUpAnn" :
--   "N~niveau"          j'ai atteint un niveau
--   "M~nom du métier"   j'ai appris un métier
--   "P~nom~palier"      j'ai franchi un palier de métier (75, 150, 225, 300…)
-- Les autres membres voient une bulle à côté du médaillon GuildUpSMB. /smb annonces les coupe.
-- Montée de niveau : titre « Nom a up ! », texte « Nom a atteint le niveau 24 ! », sonnette, et des
-- emotes du cri de guilde à l'écran (ns.PluieEmotes, GuildUp_GU.lua ; aucune si l'emote est coupée dans
-- les notifications) : 4 pour un niveau ordinaire, 8 pour un palier (10, 20, 30…), 12 au niveau
-- maximum. Les emotes sont affichées par l'addon de chaque membre à la réception de « N » (aucun
-- message de plus, rien dans le chat) ; celui qui monte de niveau voit les siennes, sans bulle.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpAnn"
local debut = GetTime()
local CALME = 20 -- rien juste après la connexion
local dejaEntre = false
-- emotes du cri de guilde à l'écran pour une montée de niveau : ordinaire, palier (tous les 10), niveau maximum
local EMOTES_NIVEAU, EMOTES_PALIER, EMOTES_MAX = 4, 8, 12

-- niveau maximum du jeu, ou nil si le client ne le dit pas
local function NiveauMax()
	local f = GetMaxLevelForPlayerExpansion or GetMaxPlayerLevel
	if not f then return nil end
	local ok, v = pcall(f)
	v = ok and tonumber(v) or nil
	return (v and v > 0) and v or nil
end

-- nombre d'emotes pour ce niveau
local function EmotesPour(niveau)
	niveau = tonumber(niveau)
	if not niveau then return EMOTES_NIVEAU end
	if niveau == NiveauMax() then return EMOTES_MAX end
	if niveau % 10 == 0 then return EMOTES_PALIER end
	return EMOTES_NIVEAU
end

local Normaliser = ns.Normaliser
local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local function Nettoyer(t) return ((t or ""):gsub("[~|]", " ")) end

-- appelé par GuildUp_Metiers.lua : genre = "nouveau" ou "palier"
ns.AnnonceMetier = function(genre, nomMetier, niveau)
	if genre == "nouveau" then
		Envoyer("M~" .. Nettoyer(nomMetier))
	else
		Envoyer(("P~%s~%d"):format(Nettoyer(nomMetier), niveau or 0))
	end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local db = ns.DB and ns.DB()
	if not db or db.annoncesGuilde == false or not ns.Notifier then return end
	if Normaliser(expediteur) == Normaliser(UnitName("player")) and not (ns.TestSolo and ns.TestSolo()) then return end
	if GetTime() - debut < CALME then return end
	local genre, a, b = strsplit("~", msg)
	local qui = NomJoueur(expediteur)
	if genre == "N" and tonumber(a) and ns.NiveauSpecial and ns.NiveauSpecial(expediteur, a) then
		-- montée de niveau spéciale (membre vedette : bulle en fête, GuildUp_GU.lua)
	elseif genre == "N" and tonumber(a) then
		-- petite sonnette (media/ding.mp3), puis les emotes du cri de guilde
		local montree = ns.Notifier("niveaux", ("%s a up !"):format(qui), ("%s a atteint le niveau |cffffd100%s|r !"):format(qui, a),
			(ns.MEDIA or ("Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\")) .. "ding.mp3", function() end)
		if montree and ns.PluieEmotes then ns.PluieEmotes(EmotesPour(a)) end
	elseif genre == "M" and a then
		ns.Notifier("metiers", "Nouveau métier", ("%s a appris |cffffd100%s|r"):format(qui, a), nil, function()
			if ns.BasculerMetiers then ns.BasculerMetiers() end
		end)
	elseif genre == "P" and a and tonumber(b) then
		ns.Notifier("metiers", "Métier", ("%s est passé à |cffffd100%s|r en %s"):format(qui, b, a), nil, function()
			if ns.BasculerMetiers then ns.BasculerMetiers() end
		end)
	end
end

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "PLAYER_LEVEL_UP" then
		if a1 then
			Envoyer("N~" .. tostring(a1))
			-- mes propres chopes (les autres membres les voient à la réception de l'annonce)
			if ns.PluieEmotes then ns.PluieEmotes(EmotesPour(a1)) end
		end
	elseif event == "PLAYER_ENTERING_WORLD" and not dejaEntre then
		-- calme seulement après la connexion, pas après chaque écran de chargement (instance, bateau)
		dejaEntre = true
		debut = GetTime()
	end
end)
