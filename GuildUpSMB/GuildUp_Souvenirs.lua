-- GuildUpSMB : carte des souvenirs de la guilde (préfixe "GuildUpSvn").
-- Les grands moments de chaque membre sont épinglés sur la carte du monde, là où ils sont arrivés :
--   N  niveau 10, 20, 30… et niveau maximum (valeur = niveau)     M  nouveau métier (valeur = nom)
--   P  palier de métier (valeur = « 150 Forge »)                   T  tirage au sort gagné (valeur = lot)
-- Seul le membre concerné crée son souvenir, à sa propre position (ns.MaPosition), et seulement s'il
-- partage sa position (réglage partagePosition) et n'est pas en instance ; il est appelé par
-- GuildUp_Journal.lua quand une de ses nouvelles entre dans le fil d'activité (ns.MonSouvenir).
-- Gardés sans limite de durée dans GuildUpDB.souvenirs[guilde] = { { t, g, q, v, c, x, y }, … } (400 au
-- plus, les plus anciens oubliés), communs aux personnages du compte.
--   "S~t~g~carte~x~y~valeur"        mon nouveau souvenir (t = heure du serveur en base 36)
--   "Q~depuis"                      je me connecte : envoyez-moi les souvenirs plus récents (base 36)
--   "E~t,g,membre,carte,x,y,valeur;…"  souvenirs (240 octets au plus par message), envoyés par le seul
--                                   relais (ns.EstLeRelais), 40 au plus ; tout le monde les lit
-- Sur la carte du monde (dessin dans GuildUp_Carte.lua, ns.SouvenirsCarte) : un symbole de raid par
-- souvenir sur la carte de la zone où il est arrivé (étoile : niveau ; rond : métier ; losange : tirage),
-- date et phrase du fil d'activité au survol. /smb souvenirs les cache ou les montre (db.souvenirsCarte).

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpSvn"
local MAX = 400
local MAX_RELAIS = 40
local NIVEAU_MAX = (GetMaxPlayerLevel and GetMaxPlayerLevel()) or 60

local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local Maintenant = ns.Maintenant
local Base36 = ns.Base36

local pret = false -- vrai une fois ma demande partie (je peux alors servir de relais)

-- les souvenirs de ma guilde, du plus ancien au plus récent (nil hors guilde)
local function Souvenirs()
	local db = ns.DB and ns.DB()
	local guilde = IsInGuild() and GetGuildInfo and GetGuildInfo("player")
	if not db or not guilde then return nil end
	if type(db.souvenirs) ~= "table" then db.souvenirs = {} end
	local s = db.souvenirs[guilde]
	if type(s) ~= "table" then s = {}; db.souvenirs[guilde] = s end
	return s
end

local function Nettoyer(v)
	v = tostring(v or ""):gsub("[~|,;\r\n]", " "):gsub("%s+", " ")
	v = strtrim(v)
	return ns.CouperUTF8 and ns.CouperUTF8(v, nil, 60) or v:sub(1, 60)
end

-- un moment qui mérite un souvenir ?
local function Digne(g, v)
	if g == "N" then
		local n = tonumber(v)
		return n ~= nil and n >= 10 and (n % 10 == 0 or n == NIVEAU_MAX)
	end
	return g == "M" or g == "P" or g == "T"
end

-- ajoute un souvenir (dans l'ordre des dates) ; true s'il est nouveau
local function Ajouter(t, g, q, v, c, x, y)
	local s = Souvenirs()
	t, c, x, y = tonumber(t), tonumber(c), tonumber(x), tonumber(y)
	if not s or not t or not (c and x and y) or x < 0 or x > 1 or y < 0 or y > 1 then return false end
	if type(q) ~= "string" or q == "" or q:find("[~,;|]") or not Digne(g, v) then return false end
	if t > Maintenant() + 120 then return false end
	t, v = math.floor(t), Nettoyer(v)
	for _, e in ipairs(s) do
		-- (un niveau, un métier ou un palier ne s'atteint qu'une fois ; un tirage, à la même heure près)
		if e.g == g and e.q == q and e.v == v and (g ~= "T" or math.abs(e.t - t) < 600) then return false end
	end
	local place = #s + 1
	while place > 1 and s[place - 1].t > t do place = place - 1 end
	table.insert(s, place, { t = t, g = g, q = q, v = v, c = c, x = x, y = y })
	while #s > MAX do table.remove(s, 1) end
	if ns.RedessinerCarte then ns.RedessinerCarte() end
	return true
end

local function Envoyer(msg)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end
end

-- Une de mes nouvelles vient d'entrer dans le fil d'activité (GuildUp_Journal.lua)
ns.MonSouvenir = function(g, v)
	local db = ns.DB and ns.DB()
	if not (db and db.partagePosition) or not Digne(g, v) or not ns.MaPosition then return end
	local c, x, y = ns.MaPosition()
	if not c then return end -- (en instance : pas de position)
	local t, moi = Maintenant(), MaCle()
	v = Nettoyer(v)
	if not moi or not Ajouter(t, g, moi, v, c, x, y) then return end
	Envoyer(("S~%s~%s~%d~%.3f~%.3f~%s"):format(Base36(t), g, c, x, y, v))
end

-- Souvenirs à dessiner sur une carte (celle de leur zone), pour GuildUp_Carte.lua
ns.SouvenirsCarte = function(carte)
	local db = ns.DB and ns.DB()
	local s = Souvenirs()
	if not s or (db and db.souvenirsCarte == false) then return nil end
	local liste = {}
	for _, e in ipairs(s) do
		if e.c == carte then liste[#liste + 1] = e end
	end
	return liste
end

-- Infobulle d'un souvenir : date, phrase du fil d'activité
ns.InfobulleSouvenir = function(e)
	GameTooltip:AddLine("Souvenir de la guilde", 1, 0.82, 0)
	local phrase = ns.PhraseActivite and ns.PhraseActivite(e) or e.v
	GameTooltip:AddLine(phrase, 1, 1, 1, true)
	GameTooltip:AddLine(date("le %d/%m/%Y à %Hh%M", e.t), 0.6, 0.6, 0.6)
end

-- /smb souvenirs : montrer ou cacher les souvenirs sur la carte du monde
ns.BasculerSouvenirs = function()
	local db = ns.DB and ns.DB()
	if not db then return end
	db.souvenirsCarte = (db.souvenirsCarte == false)
	local s = Souvenirs()
	if ns.Coeur and ns.Coeur.Message then
		ns.Coeur.Message(("souvenirs sur la carte du monde : %s (%d souvenir%s)"):format(
			db.souvenirsCarte and "affichés" or "cachés", s and #s or 0, (s and #s > 1) and "s" or ""))
	end
	if ns.RedessinerCarte then ns.RedessinerCarte() end
end

--------------------------------------------------------------------------------
-- Réseau
--------------------------------------------------------------------------------

-- les souvenirs plus récents que « depuis » (les 40 derniers au plus), en messages de 240 octets
local function Relayer(depuis)
	local s = Souvenirs()
	if not s then return end
	local premier = #s + 1
	while premier > 1 and s[premier - 1].t > depuis and #s - premier + 1 < MAX_RELAIS do premier = premier - 1 end
	local msg = "E~"
	for i = premier, #s do
		local e = s[i]
		local mot = ("%s,%s,%s,%d,%.3f,%.3f,%s"):format(Base36(e.t), e.g, e.q, e.c, e.x, e.y, e.v)
		if #msg + #mot + 1 > 240 and #msg > 2 then Envoyer(msg); msg = "E~" end
		msg = msg .. (#msg > 2 and ";" or "") .. mot
	end
	if #msg > 2 then Envoyer(msg) end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local qui = Normaliser(expediteur)
	if not qui or qui == MaCle() then return end
	local genre, suite = msg:match("^(%u)~(.*)$")
	if genre == "S" then
		local t, g, c, x, y, v = suite:match("^(%w+)~(%u)~(%d+)~([%d%.]+)~([%d%.]+)~(.*)$")
		if t then Ajouter(tonumber(t, 36), g, qui, v, c, x, y) end
	elseif genre == "Q" then
		local depuis = tonumber(suite, 36)
		if not depuis or not pret or not (ns.EstLeRelais and ns.EstLeRelais(qui)) then return end
		C_Timer.After(3 + math.random() * 4, function() Relayer(depuis) end)
	elseif genre == "E" then
		for mot in suite:gmatch("[^;]+") do
			local t, g, q, c, x, y, v = mot:match("^(%w+),(%u),([^,]+),(%d+),([%d%.]+),([%d%.]+),(.*)$")
			if t then Ajouter(tonumber(t, 36), g, q, v, c, x, y) end
		end
	end
end

local ev = CreateFrame("Frame")
local premiere = true
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
	if not premiere then return end
	premiere = false
	-- (la guilde et la liste de ses membres ne sont pas connues tout de suite)
	C_Timer.After(30, function()
		local s = Souvenirs()
		if s then Envoyer("Q~" .. Base36(#s > 0 and s[#s].t or 0)) end
		pret = true
	end)
end)

ns.Ecouter(PREFIXE, Recevoir)
