-- GuildUpSMB : faux client WoW, pour faire tourner des fichiers de l'addon hors du jeu (essais automatiques).
-- Ce n'est pas le jeu : aucune mise en page n'est calculée, rien n'est dessiné. Il attrape ce qu'un essai en jeu
-- montrerait tout de suite : une fonction appelée avant d'être définie, un nom mal écrit, un texte ou un nombre
-- absent là où il en faut un, un booléen passé à SetPoint, une couleur incomplète.
-- Tout cadre, texture ou texte est un objet « factice » : n'importe quelle méthode existe. Les « Get » rendent 0,
-- les « Is » faux, les « Create » un autre objet factice ; quelques méthodes gardent leur valeur (texte, taille,
-- affiché ou non, scripts) et vérifient le type de ce qu'on leur passe.
-- Usage, dans un essai :  local client = dofile("outils/essais/faux_client.lua")  puis  client.Charger(fichier).
-- Marche avec Lua 5.1 (celui du jeu, utilisé par GitHub) comme avec Lua 5.4.
local DOSSIER = arg and arg[1] or "GuildUpSMB"
unpack = unpack or table.unpack

-- Lua 5.1 (le jeu) refuse nil, un booléen ou une table pour « %s » ; Lua 5.4 les convertit sans rien dire. Le
-- faux client garde la règle du jeu, pour que l'essai lancé avec Lua 5.4 attrape aussi cette erreur.
local vraiFormat = string.format
string.format = function(f, ...)
	local n = 0
	for spec in f:gmatch("%%[%-+ #0]*%d*%.?%d*([%a%%])") do
		if spec ~= "%" then
			n = n + 1
			local v = select(n, ...)
			if spec == "s" and type(v) ~= "string" and type(v) ~= "number" then
				error("format : le « %s » n° " .. n .. " reçoit " .. type(v), 2)
			end
		end
	end
	return vraiFormat(f, ...)
end
wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
strtrim = function(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
tinsert = table.insert
date, time = os.date, os.time
strsplit = function(sep, s) local r = {} for m in (s .. sep):gmatch("(.-)" .. sep) do r[#r + 1] = m end return unpack(r) end
local horloge = 1000
GetTime = function() return horloge end
GetLocale = function() return "frFR" end
IsInGuild = function() return true end
GetGuildInfo = function() return "Donjons et Dindons" end
GetSpellInfo = function(id) return "Sort " .. id end
GetRealZoneText = function() return "Forêt d'Elwynn" end
IsShiftKeyDown = function() return false end
IsMouseButtonDown = function() return true end
GetCursorPosition = function() return 100, 300 end
IsFishingLoot = function() return false end
UISpecialFrames = {}

-- objet factice : toute méthode existe ; les « Get » rendent 0, les « Is » faux, les « Create » un objet
local cadres = {}
local function Factice(genre, parent)
	local o = { __genre = genre, __scripts = {}, __montre = true, __parent = parent }
	return setmetatable(o, { __index = function(t, k)
		if type(k) ~= "string" then return nil end
		local f
		if k == "SetScript" then f = function(self, nom, fn) self.__scripts[nom] = fn end
		elseif k == "HookScript" then f = function(self, nom, fn) local a = self.__scripts[nom]; self.__scripts[nom] = function(...) if a then a(...) end; fn(...) end end
		elseif k == "GetScript" then f = function(self, nom) return self.__scripts[nom] end
		elseif k == "SetText" then f = function(self, x) assert(x == nil or type(x) == "string" or type(x) == "number", "SetText : " .. type(x)); self.__texte = x and tostring(x) or "" end
		elseif k == "GetText" then f = function(self) return self.__texte end
		elseif k == "GetStringWidth" then f = function(self) return #(self.__texte or "") * 6 end
		elseif k == "GetStringHeight" then f = function(self) return 12 end
		elseif k == "Show" then f = function(self) self.__montre = true end
		elseif k == "Hide" then f = function(self) self.__montre = false end
		elseif k == "SetShown" then f = function(self, x) assert(type(x) == "boolean", "SetShown attend un booléen, reçu " .. type(x)); self.__montre = x end
		elseif k == "IsShown" or k == "IsVisible" then f = function(self) return self.__montre end
		elseif k == "SetHeight" then f = function(self, h) assert(type(h) == "number", "SetHeight"); self.__h = h end
		elseif k == "SetWidth" then f = function(self, l) assert(type(l) == "number", "SetWidth"); self.__l = l end
		elseif k == "SetSize" then f = function(self, l, h) assert(type(l) == "number" and type(h) == "number", "SetSize"); self.__l, self.__h = l, h end
		elseif k == "GetHeight" then f = function(self) return self.__h or 0 end
		elseif k == "GetWidth" then f = function(self) return self.__l or 0 end
		elseif k == "GetFrameLevel" then f = function() return 1 end
		elseif k == "GetEffectiveScale" then f = function() return 1 end
		elseif k == "GetTop" then f = function() return 500 end
		elseif k == "GetBottom" then f = function() return 66 end
		elseif k == "GetParent" then f = function(self) return self.__parent end
		elseif k == "SetPoint" then f = function(self, point, a, b, c, d)
			assert(type(point) == "string", "SetPoint : point " .. tostring(point))
			for _, x in ipairs({ a, b, c, d }) do assert(type(x) ~= "boolean", "SetPoint : booléen") end
		end
		elseif k == "SetTextColor" or k == "SetColorTexture" or k == "SetBackdropColor" or k == "SetBackdropBorderColor" or k == "SetVertexColor" then
			f = function(self, r, g, b, a) assert(type(r) == "number" and type(g) == "number" and type(b) == "number", k .. " : couleur incomplète") end
		elseif k == "GetUnit" then f = function() return "Nom", "mouseover" end
		elseif k:find("^Create") then f = function(self) return Factice(k, self) end
		elseif k:find("^Get") then f = function() return 0 end
		elseif k:find("^Is") or k:find("^Has") then f = function() return false end
		elseif k:find("^__") then return nil
		else f = function() end end
		return f
	end })
end
CreateFrame = function(genre, nom, parent, modele)
	local f = Factice(genre, parent)
	cadres[#cadres + 1] = f
	if nom then _G[nom] = f end
	return f
end
UIParent = Factice("Frame")
GameTooltip = Factice("GameTooltip")
C_Timer = { After = function(d, fn) fn() end }
local CARTE_ELWYNN
C_Map = { GetBestMapForUnit = function() return CARTE_ELWYNN end }
local plaque = Factice("Plaque")
C_NamePlate = { GetNamePlateForUnit = function() return plaque end, GetNamePlates = function() return { plaque } end }
plaque.namePlateUnitToken = "nameplate1"
plaque.UnitFrame = Factice("UnitFrame")
plaque.UnitFrame.healthBar = Factice("StatusBar")

-- unités factices
local unites = {}
UnitExists = function(u) return unites[u] ~= nil end
UnitIsPlayer = function() return false end
UnitPlayerControlled = function() return false end
UnitGUID = function(u) return unites[u] and ("Creature-0-1-2-3-%d-00001%s"):format(unites[u].id, unites[u].n or "A") end
UnitIsFriend = function() return false end
UnitCanAttack = function() return true end
UnitIsDead = function(u) return unites[u] and unites[u].mort or false end
UnitIsTapDenied = function() return false end
UnitCreatureType = function() return "Humanoïde" end
UnitClassification = function(u) return unites[u] and unites[u].classe or "normal" end
UnitName = function(u) return unites[u] and unites[u].nom or "Inconnu" end
UnitLevel = function() return 10 end
GetNumLootItems = function() return 1 end
GetLootSlotLink = function() return "|cffffffff|Hitem:2589::::|h[Etoffe de lin]|h|r" end
GetLootSourceInfo = function() return UnitGUID("target"), 1 end

-- lectures de globales inconnues : notées (une faute de frappe sur un nom de fonction se voit ici)
local inconnues = {}
setmetatable(_G, { __index = function(_, k) inconnues[k] = (inconnues[k] or 0) + 1 return nil end })

-- ns ; secrets[valeur] = true : une valeur que le jeu cache (ns.Secrete la reconnaît)
local secrets = {}
local db = { notifs = {}, partagePosition = true }
local envoyes, bulles, activite, messages = {}, {}, {}, {}
local ecouteur, creerPage
local ns = {
	TAILLE_PAGE = { 794, 586 },
	DB = function() return db end,
	Normaliser = function(n) return n end,
	MaCle = function() return "Miko-Forever" end,
	Maintenant = function() return 1795000000 + horloge end,
	Base36 = function(n) local s = ""; n = math.floor(n); if n == 0 then return "0" end
		while n > 0 do local r = n % 36; s = string.sub("0123456789abcdefghijklmnopqrstuvwxyz", r + 1, r + 1) .. s; n = math.floor(n / 36) end return s end,
	Simplifier = function(s) return s:lower() end,
	NomJoueur = function(c) return (c:gsub("%-.*", "")) end,
	NomCourt = function(c) return c end,
	Secrete = function(v) return secrets[v] == true end,
	Coeur = { Message = function(t) messages[#messages + 1] = t end },
	InfoObjet = function(o) return "Objet " .. o, "[Objet " .. o .. "]", 1, "icone" end,
	Precharger = function() end,
	IndexObjets = function() return { { 2589, "Etoffe de lin", 1, "etoffe de lin" } } end,
	AjouterPage = function(id, creer) creerPage = creer end,
	Ecouter = function(prefixe, fn) ecouteur = fn end,
	EnvoyerAddon = function(prefixe, msg) assert(#msg <= 255, "message trop long"); envoyes[#envoyes + 1] = msg end,
	Notifier = function(cat, titre, texte, son, action) bulles[#bulles + 1] = { titre = titre, texte = texte, son = son, action = action } return true end,
	NoterActivite = function(g, q, v) activite[#activite + 1] = g .. " " .. q .. " " .. v end,
	MaPosition = function() return CARTE_ELWYNN, 0.4321, 0.6543 end,
	PositionMonde = function(carte, x, y) return x * 1000, y * 1000, 0 end,
	MontrerAppelSurCarte = function(a) assert(type(a) == "table" and a.carte and a.x and a.y, "repère de carte incomplet") end,
	EstLeRelais = function() return true end,
	AfficherSurCarte = function(titre, groupes) assert(type(titre) == "string" and groupes[1].carte) end,
	OuvrirInterface = function() end,
	Son = function() end,
}
local function Charger(fichier)
	local bloc = assert(loadfile(DOSSIER .. "/" .. fichier))
	bloc("GuildUpSMB", ns)
end

-- Le déroulé d'un essai : Etape(nom, fonction) ; une étape ratée est comptée et sa trace affichée
local etapes, echecs = 0, 0
local function Etape(nom, fn)
	etapes = etapes + 1
	local ok, err = xpcall(fn, debug.traceback)
	if not ok then echecs = echecs + 1; print("ÉCHEC " .. nom .. " :\n" .. tostring(err)) else print("ok    " .. nom) end
end
-- L'addon enveloppe ses évènements dans pcall : une erreur y passerait inaperçue. Ce pcall-ci les note.
local vraiPcall = pcall
local erreursCachees = {}
pcall = function(f, ...)
	local r = { vraiPcall(f, ...) }
	if not r[1] and type(f) == "function" and debug.getinfo(f, "S").what ~= "C" then erreursCachees[#erreursCachees + 1] = tostring(r[2]) end
	return unpack(r, 1, table.maxn and table.maxn(r) or #r)
end
-- Bilan : rend vrai si tout est passé (aucune étape ratée, aucune erreur avalée par pcall)
local function Bilan()
	print(("%d étapes, %d échec(s), %d erreur(s) avalée(s) par pcall"):format(etapes, echecs, #erreursCachees))
	for i = 1, math.min(#erreursCachees, 12) do print("   " .. erreursCachees[i]) end
	local noms = {}
	for k in pairs(inconnues) do noms[#noms + 1] = k end
	table.sort(noms)
	print("globales absentes du faux client (à vérifier : API du jeu, ou nom mal écrit) : " .. table.concat(noms, ", "))
	return echecs == 0 and #erreursCachees == 0
end

return {
	ns = ns, db = db, cadres = cadres, unites = unites, plaque = plaque, Factice = Factice, Charger = Charger,
	Etape = Etape, Bilan = Bilan, envoyes = envoyes, bulles = bulles, activite = activite, messages = messages,
	secrets = secrets,
	Avancer = function(s) horloge = horloge + s end,
	Carte = function(c) CARTE_ELWYNN = c end,
	Ecouteur = function() return ecouteur end,
	CreerPage = function() return creerPage end,
}
