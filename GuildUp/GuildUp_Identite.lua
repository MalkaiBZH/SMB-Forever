-- GuildUp : pseudo commun à tous ses personnages, et personnage principal / secondaires.
--
-- Le pseudo n'apparaît QU'AU SURVOL (infobulles) : partout ailleurs (listes, bulles, chat, courrier)
-- on garde le vrai nom en jeu, pour ne jamais écrire au mauvais joueur si deux membres ont le même pseudo.
--
-- GuildUpDB est commun au compte : chaque personnage connecté s'y note (db.mesPersos), le joueur
-- choisit son pseudo (db.pseudo) et son principal (db.persoPrincipal). Synchro (préfixe GuildUpId) :
--   I~pseudo~principal~perso1,perso2,…     mon identité          Q    « envoyez-moi les vôtres »

local NOM_ADDON, ns = ...
local PREFIXE = "GuildUpId"

local function DB() return ns.DB and ns.DB() end
local Normaliser = ns.Normaliser
local MaCle = ns.MaCle
local TestSolo = ns.TestSolo
local NomCourt = ns.NomCourt
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local function Propre(t) return strtrim(((t or ""):gsub("[~|,\n]", ""))) end

--------------------------------------------------------------------------------
-- Mes personnages (dans ma guilde actuelle)
--------------------------------------------------------------------------------

-- Purge à la connexion : identités sans nouvelles depuis 90 jours, mes personnages non connectés
-- depuis un an (supprimés ou abandonnés)
local function Purger()
	local db = DB()
	if not db then return end
	local maintenant = time()
	if type(db.identites) == "table" then
		for cle, id in pairs(db.identites) do
			if type(id) ~= "table" or maintenant - (id.maj or 0) > 90 * 86400 then db.identites[cle] = nil end
		end
	end
	if type(db.mesPersos) == "table" then
		for cle, p in pairs(db.mesPersos) do
			if type(p) ~= "table" or maintenant - (p.vu or 0) > 365 * 86400 then db.mesPersos[cle] = nil end
		end
	end
end

local function NoterMonPerso()
	local db = DB()
	if not db then return end
	if type(db.mesPersos) ~= "table" then db.mesPersos = {} end
	local guilde = IsInGuild() and GetGuildInfo("player") or nil
	local _, classe = UnitClass("player")
	local p = db.mesPersos[MaCle()] or {}
	p.guilde = guilde or p.guilde
	p.classe, p.niveau, p.vu = classe, UnitLevel("player"), time()
	db.mesPersos[MaCle()] = p
end

-- mes personnages de la même guilde que celui-ci, le principal d'abord
local function MesPersos()
	local db = DB() or {}
	local l = {}
	local guilde = IsInGuild() and GetGuildInfo("player") or (db.mesPersos and db.mesPersos[MaCle()] and db.mesPersos[MaCle()].guilde)
	for cle, p in pairs(db.mesPersos or {}) do
		if cle == MaCle() or (guilde and p.guilde == guilde) then l[#l + 1] = cle end
	end
	table.sort(l, function(a, b)
		if a == db.persoPrincipal then return true end
		if b == db.persoPrincipal then return false end
		return a < b
	end)
	return l
end
ns.MesPersos = MesPersos

local function MonIdentite()
	local db = DB() or {}
	local persos = MesPersos()
	local principal = db.persoPrincipal
	local ok = false
	for _, c in ipairs(persos) do if c == principal then ok = true end end
	return { pseudo = db.pseudo, principal = ok and principal or nil, persos = persos }
end

--------------------------------------------------------------------------------
-- Identités des autres : db.identites[emetteur] = { pseudo, principal, persos, maj }
--------------------------------------------------------------------------------

local index -- [cle d'un perso] = identité
local function Index()
	if index then return index end
	index = {}
	local db = DB() or {}
	for emetteur, id in pairs(db.identites or {}) do
		index[emetteur] = id
		for _, c in ipairs(id.persos or {}) do index[c] = id end
	end
	return index
end

-- identité d'un joueur (clé ou nom), ou nil
local function Identite(nom)
	if not nom then return nil end
	local cle = Normaliser(((nom:gsub(" %(test%)$", "")):gsub("#test$", "")))
	if not cle then return nil end
	local db = DB() or {}
	if cle == MaCle() or (db.mesPersos and db.mesPersos[cle]) then return MonIdentite() end
	return Index()[cle]
end
ns.Identite = Identite

-- lignes à ajouter dans une infobulle qui parle d'un joueur : pseudo et ses personnages
ns.LignesIdentite = function(tt, nom)
	local id = Identite(nom)
	if not tt or not id then return end
	local persos = id.persos or {}
	if not (id.pseudo and id.pseudo ~= "") and #persos < 2 then return end
	if id.pseudo and id.pseudo ~= "" then
		tt:AddLine("|cffffd100Pseudo :|r " .. id.pseudo, 1, 1, 1)
	end
	if #persos >= 2 then
		local noms = {}
		for _, c in ipairs(persos) do
			noms[#noms + 1] = NomCourt(c) .. (c == id.principal and " |cffffd100(principal)|r" or "")
		end
		tt:AddLine("|cffffd100Personnages :|r " .. table.concat(noms, ", "), 1, 1, 1, true)
	end
end

--------------------------------------------------------------------------------
-- Synchro
--------------------------------------------------------------------------------

local pret, dernierEnvoi = false, 0
local function EnvoyerMoi()
	local id = MonIdentite()
	if not (id.pseudo and id.pseudo ~= "") and #id.persos < 2 then return end -- rien à dire
	local pseudo = Propre(id.pseudo)
	if ns.CouperUTF8 then pseudo = ns.CouperUTF8(pseudo, 48) end
	local entete = ("I~%s~%s~"):format(pseudo, id.principal or "")
	-- la liste des personnages remplit ce qui reste des 255 octets après l'en-tête
	local budget = (ns.LONGUEUR_MAX or 255) - #entete
	local persos = {}
	local long = 0
	for _, c in ipairs(id.persos) do
		local ajout = #c + (long > 0 and 1 or 0)
		if long + ajout > budget then break end
		persos[#persos + 1] = c
		long = long + ajout
	end
	dernierEnvoi = GetTime()
	Envoyer(entete .. table.concat(persos, ","))
end
ns.AnnoncerIdentite = function()
	NoterMonPerso()
	if pret then EnvoyerMoi() end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if cle == MaCle() and not TestSolo() then return end
	if msg == "Q" then
		if pret and GetTime() - dernierEnvoi > 20 then
			dernierEnvoi = GetTime()
			C_Timer.After(1 + math.random() * 5, EnvoyerMoi)
		end
		return
	end
	local pseudo, principal, persos = msg:match("^I~([^~]*)~([^~]*)~(.*)$")
	if not pseudo then return end
	local db = DB()
	if not db then return end
	if type(db.identites) ~= "table" then db.identites = {} end
	-- textes bornés (affichés dans les infobulles)
	pseudo = ns.CouperUTF8(pseudo, 48)
	principal = ns.CouperUTF8(principal, 64)
	local l = {}
	for c in persos:gmatch("[^,]+") do
		if #l < 20 then l[#l + 1] = ns.CouperUTF8(c, 64) end
	end
	if #l == 0 then l[1] = cle end
	db.identites[cle] = { pseudo = pseudo ~= "" and pseudo or nil, principal = principal ~= "" and principal or nil,
		persos = l, maj = time() }
	-- l'expéditeur ne peut appartenir qu'à une identité : on le retire des autres (il ne peut pas
	-- retirer les personnages d'un autre membre)
	for autre, id in pairs(db.identites) do
		if autre ~= cle then
			for i = #(id.persos or {}), 1, -1 do
				if id.persos[i] == cle then table.remove(id.persos, i) end
			end
		end
	end
	index = nil
end

--------------------------------------------------------------------------------
-- Infobulles : joueurs survolés dans le monde (membres de la guilde)
--------------------------------------------------------------------------------

local function BulleUnite(tt)
	if tt ~= GameTooltip then return end
	local ok, _, unite = pcall(tt.GetUnit, tt)
	if not ok or not unite or not UnitIsPlayer(unite) then return end
	local okN, nom, famille = pcall(UnitFullName, unite)
	if not okN or not nom then return end
	ns.LignesIdentite(tt, famille and famille ~= "" and (nom .. "-" .. famille) or nom)
end
if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall and Enum and Enum.TooltipDataType then
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tt) pcall(BulleUnite, tt) end)
elseif GameTooltip and GameTooltip.HookScript then
	pcall(GameTooltip.HookScript, GameTooltip, "OnTooltipSetUnit", function(self) pcall(BulleUnite, self) end)
end

--------------------------------------------------------------------------------
-- Menu « Persos » du volet : choisir son personnage principal
--------------------------------------------------------------------------------

local menu
ns.MenuPersos = function(ancre)
	if not menu then
		menu = CreateFrame("Frame", "GuildUpMenuPersos", UIParent, "BackdropTemplate")
		menu:SetFrameStrata("FULLSCREEN_DIALOG")
		menu:SetClampedToScreen(true)
		if menu.SetBackdrop then
			menu:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
				insets = { left = 3, right = 3, top = 3, bottom = 3 } })
			menu:SetBackdropColor(0.05, 0.05, 0.05, 0.97)
		end
		menu.boutons = {}
		menu.titre = menu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		menu.titre:SetPoint("TOPLEFT", menu, "TOPLEFT", 8, -8)
		menu.titre:SetText("Mon personnage principal")
		menu.aide = menu:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		menu.aide:SetJustifyH("LEFT")
		menu:SetScript("OnUpdate", function(self)
			if not self:IsMouseOver(20, -20, -20, 20) and not (self.ancre and self.ancre:IsMouseOver()) then self:Hide() end
		end)
		tinsert(UISpecialFrames, "GuildUpMenuPersos")
	end
	NoterMonPerso()
	local db = DB() or {}
	local persos = MesPersos()
	for i, c in ipairs(persos) do
		local b = menu.boutons[i]
		if not b then
			b = CreateFrame("Button", nil, menu)
			b:SetHeight(20)
			b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			b.texte:SetPoint("LEFT", b, "LEFT", 8, 0)
			menu.boutons[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", menu, "TOPLEFT", 4, -26 - (i - 1) * 20)
		b:SetPoint("RIGHT", menu, "RIGHT", -4, 0)
		local p = db.mesPersos and db.mesPersos[c] or {}
		local couleur = p.classe and RAID_CLASS_COLORS and RAID_CLASS_COLORS[p.classe]
		local principal = c == db.persoPrincipal
		b.texte:SetText((principal and "|TInterface\\Buttons\\UI-CheckBox-Check:14:14:0:0|t " or "      ")
			.. (couleur and ("|c" .. (couleur.colorStr or "ffffffff")) or "|cffffffff") .. NomCourt(c) .. "|r"
			.. (p.niveau and ("  |cff999999niv. " .. p.niveau .. "|r") or "") .. (c == MaCle() and "  |cff999999(connecté)|r" or ""))
		b:SetScript("OnClick", function()
			db.persoPrincipal = (db.persoPrincipal ~= c) and c or nil
			ns.AnnoncerIdentite()
			ns.MenuPersos(ancre)
		end)
		b:Show()
	end
	for i = #persos + 1, #menu.boutons do menu.boutons[i]:Hide() end
	menu.aide:ClearAllPoints()
	menu.aide:SetPoint("TOPLEFT", menu, "TOPLEFT", 8, -30 - #persos * 20)
	menu.aide:SetWidth(204)
	menu.aide:SetText("Tes personnages de cette guilde apparaissent ici dès que tu t'y connectes avec GuildUp. La guilde les voit au survol de ton nom.")
	menu:SetSize(220, 40 + #persos * 20 + menu.aide:GetStringHeight())
	menu.ancre = ancre
	menu:ClearAllPoints()
	menu:SetPoint("TOPLEFT", ancre, "BOTTOMLEFT", 0, -2)
	menu:Show()
end

ns.DiagIdentite = function(L)
	local db = DB() or {}
	local n = 0
	for _ in pairs(db.identites or {}) do n = n + 1 end
	L(("identité : pseudo %s, %d perso(s), %d membre(s) connus"):format(db.pseudo or "—", #MesPersos(), n))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "PLAYER_GUILD_UPDATE", "PLAYER_LEVEL_UP" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local premiere = true
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		C_Timer.After(15, function()
			pcall(Purger)
			NoterMonPerso()
			pret = true
			EnvoyerMoi()
			Envoyer("Q")
		end)
	elseif event == "PLAYER_GUILD_UPDATE" or event == "PLAYER_LEVEL_UP" then
		NoterMonPerso()
	end
end)
