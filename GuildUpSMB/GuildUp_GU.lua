-- GuildUpSMB : petites surprises de la guilde (réglées dans GuildUp_Config.lua).
--  * Cri de guilde (« 33 ») : quand un joueur l'écrit (dire, crier, groupe, raid, guilde…), une
--    emote descend doucement depuis le haut de l'écran, à une position au hasard, puis s'efface
--    (comme les pluies d'emotes de Twitch, en discret). Elle peut être animée (planche d'images).
--    Toute la guilde la voit : en canal de guilde chacun lit le message ; ailleurs, l'auteur
--    prévient la guilde par un message d'addon (préfixe GuildUpGU, message « G »).
--  * Membre vedette (facultatif) : quand il monte de niveau, la bulle « La guilde progresse » passe
--    en version fête, avec un texte arc-en-ciel qui défile et, si demandé, son animation (pour toute
--    la guilde, via l'annonce de niveau déjà envoyée par GuildUp_Annonces).

local NOM_ADDON, ns = ...
local MEDIA = ns.MEDIA or ("Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\")
local CFG = ns.Config or {}
-- cri de guilde (en majuscules) et son motif de recherche ; nil = pas de cri
local CRI = type(CFG.cri) == "string" and CFG.cri ~= "" and CFG.cri:upper() or nil
local CRI_MOTIF = CRI and (CRI:gsub("%p", "%%%0")) or nil
-- emote animée (planche d'images) ; nil = image fixe
local ANIM_EMOTE = type(CFG.emoteAnimation) == "table" and (tonumber(CFG.emoteAnimation.images) or 0) > 1 and CFG.emoteAnimation or nil
-- membre vedette : clé « prénom-famille » en minuscules, et nom affiché ; nil = personne
local VEDETTE = type(CFG.vedette) == "string" and CFG.vedette ~= "" and CFG.vedette or nil
local VEDETTE_CLE = VEDETTE and (VEDETTE:lower():gsub("%s+", "-")) or nil
local VEDETTE_NOM = VEDETTE and (VEDETTE:gsub("%-", " ")) or ""
local CORNE, CORNE2 = 566064, 567386 -- sound/doodad/dwarfhorn.ogg, sound/events/scourge_horn.ogg

local Normaliser = ns.Normaliser
-- emote coupée ? (case du cri dans les notifications du volet, ou /smb gu ; ancien réglage db.emoteGU lu aussi)
local function Coupee()
	local db = ns.DB and ns.DB()
	if not db then return false end
	if db.emoteGU == false then -- ancien réglage : passé dans les notifications
		if type(db.notifs) ~= "table" then db.notifs = {} end
		db.notifs.gu, db.emoteGU = false, nil
	end
	return type(db.notifs) == "table" and db.notifs.gu == false
end
local MaCle = ns.MaCle
local function EstVedette(nom)
	return VEDETTE_CLE ~= nil and nom ~= nil and (Normaliser(nom) or ""):lower() == VEDETTE_CLE
end

--------------------------------------------------------------------------------
-- Emote du cri de guilde
--------------------------------------------------------------------------------

local PREFIXE = "GuildUpGU"
local TAILLE, DUREE, DESCENTE = 64, 3.4, 140 -- taille, durée de vie, hauteur parcourue (pixels)
local MAX_ECRAN = 15                           -- au plus 15 emotes à la fois
local pool = {}
local diag = { detectees = 0, affichees = 0, refus = "" } -- pour /smb diag
local derniere = {}                            -- [cle] = moment de la dernière emote de ce joueur

local function NouvelleEmote()
	for _, f in ipairs(pool) do if not f:IsShown() then return f end end
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetSize(TAILLE, TAILLE)
	f:SetFrameStrata("HIGH") -- au-dessus de l'interface (barres, cartes…), sous les fenêtres de dialogue
	f:EnableMouse(false)
	f.tex = f:CreateTexture(nil, "OVERLAY")
	f.tex:SetPoint("CENTER", f, "CENTER", 0, 0)
	f.tex:SetTexture(MEDIA .. (ANIM_EMOTE and ANIM_EMOTE.fichier or "gu_emote"))
	f.tex:SetSize(1, 1)
	f:SetScript("OnUpdate", function(self) self:Placer() end)
	-- position, taille et transparence à l'instant présent (appelé aussi juste avant d'afficher :
	-- pas d'image « de la fois d'avant » à l'apparition)
	function f:Placer()
		local t = GetTime() - self.debut
		if t >= DUREE then self:Hide(); return end
		local p = t / DUREE
		-- descend depuis le haut de l'écran en ralentissant, avec un léger balancement
		local y = self.y0 - DESCENTE * (1 - (1 - p) * (1 - p))
		local x = self.x0 + 12 * math.sin(t * 2.6 + self.phase)
		self:ClearAllPoints()
		self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
		-- apparition douce : grandit de 50 % à 100 % (sans dépasser), fondu d'entrée et de sortie
		local a = math.min(1, t / 0.35)
		local s = 0.5 + 0.5 * (1 - (1 - a) * (1 - a))
		self.tex:SetSize(TAILLE * s * self.echelle, TAILLE * s * self.echelle)
		-- emote animée : image de la planche à cet instant
		if ANIM_EMOTE then
			local cols, rangs = ANIM_EMOTE.colonnes or ANIM_EMOTE.images, ANIM_EMOTE.rangees or 1
			local i = math.floor(t * (ANIM_EMOTE.ips or 10)) % ANIM_EMOTE.images
			local col, rang = i % cols, math.floor(i / cols)
			self.tex:SetTexCoord(col / cols, (col + 1) / cols, rang / rangs, (rang + 1) / rangs)
		end
		local alpha = math.min(1, t / 0.2)
		if t > DUREE - 0.9 then alpha = math.min(alpha, (DUREE - t) / 0.9) end
		self:SetAlpha(alpha)
	end
	pool[#pool + 1] = f
	return f
end

-- une emote en haut de l'écran (cle : joueur à l'origine, pour éviter les doublons)
local function Emote(cle)
	local maintenant = GetTime()
	diag.detectees = diag.detectees + 1
	if cle and derniere[cle] and maintenant - derniere[cle] < 1.5 then diag.refus = "anti-spam"; return end
	if cle then derniere[cle] = maintenant end
	-- emotes encore à l'écran (comptées directement : rien ne peut dériver) ; une emote plus vieille
	-- que sa durée de vie est forcément finie, même si son OnUpdate n'a pas tourné (interface cachée…)
	local n = 0
	for _, e in ipairs(pool) do
		if e:IsShown() then
			if maintenant - (e.debut or 0) > DUREE + 1 then e:Hide() else n = n + 1 end
		end
	end
	if n >= MAX_ECRAN then diag.refus = "trop à l'écran"; return end
	local f = NouvelleEmote()
	local largeur, hauteur = UIParent:GetWidth(), UIParent:GetHeight()
	-- en haut de l'écran, sur une largeur au hasard (sans aller sous la mini-carte et les buffs, à droite)
	f.x0 = largeur * (0.10 + 0.58 * math.random())
	f.y0 = hauteur - 70 - math.random() * 50
	f.phase = math.random() * 6.28
	f.echelle = 0.9 + math.random() * 0.35
	f.debut = maintenant
	f:Placer()
	f:Show()
	diag.affichees = diag.affichees + 1
	diag.refus = ""
end
ns.EmoteGU = Emote
ns.DiagGU = function(L)
	local n = 0
	for _, e in ipairs(pool) do if e:IsShown() then n = n + 1 end end
	L(("cri « %s » : %d détectés, %d affichés, %d à l'écran%s%s"):format(CRI or "aucun", diag.detectees, diag.affichees, n,
		diag.refus ~= "" and (", dernier refus : " .. diag.refus) or "", Coupee() and " (COUPÉE : notifications du volet ou /smb gu)" or ""))
end

local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end

-- Le cri suivi d'un point d'exclamation (« 33! », « 33 ! », toute casse), ou le cri tout seul,
-- en mot entier, tout en majuscules ou tout en minuscules (« 33 », mais pas « 133 » ni « 333 »)
local function DitGU(msg)
	if not CRI or type(msg) ~= "string" then return false end
	if (" " .. msg:upper() .. " "):find("[^%w\128-\255]" .. CRI_MOTIF .. "%s*!") then return true end
	local minuscules = CRI:lower()
	for mot in msg:gmatch("[%w\128-\255]+") do
		if mot == CRI or mot == minuscules then return true end
	end
	return false
end

--------------------------------------------------------------------------------
-- Le membre vedette monte de niveau : texte arc-en-ciel qui défile, bordure aux couleurs
-- changeantes et, avec vedetteAnimation, son GIF DANS la bulle de niveau
--------------------------------------------------------------------------------

local ANIM = { images = 19, colonnes = 8, larg = 115, haut = 128, planche = { 1024, 512 }, fps = 10 }
local GIF_L, GIF_H = 180, 200    -- GIF sur toute la largeur de la bulle (proportions 115 x 128)

-- teinte (0-1) → couleur vive
local function Teinte(h)
	local i = math.floor(h * 6) % 6
	local f = h * 6 - math.floor(h * 6)
	local r, g, b
	if i == 0 then r, g, b = 1, f, 0
	elseif i == 1 then r, g, b = 1 - f, 1, 0
	elseif i == 2 then r, g, b = 0, 1, f
	elseif i == 3 then r, g, b = 0, 1 - f, 1
	elseif i == 4 then r, g, b = f, 0, 1
	else r, g, b = 1, 0, 1 - f end
	-- un peu éclaircie : plus lisible sur le fond sombre
	return 0.35 + 0.65 * r, 0.35 + 0.65 * g, 0.35 + 0.65 * b
end

-- texte arc-en-ciel : une couleur par lettre (lettres UTF-8 entières), décalée dans le temps
local function ArcEnCiel(texte, t, pas)
	local morceaux, i = {}, 0
	for lettre in texte:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		if lettre == " " then
			morceaux[#morceaux + 1] = " "
		else
			local r, g, b = Teinte((i * (pas or 0.045) - t * 0.6) % 1)
			morceaux[#morceaux + 1] = ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, lettre)
		end
		i = i + 1
	end
	return table.concat(morceaux)
end

local deco -- cadre d'animation attaché à la bulle

local function Decorer(bulle, niveau)
	if not deco then
		deco = CreateFrame("Frame", nil, bulle)
		deco:SetAllPoints(bulle)
		deco.gif = deco:CreateTexture(nil, "ARTWORK")
		deco.gif:SetSize(GIF_L, GIF_H)
		deco.gif:SetPoint("TOP", bulle, "TOP", 0, -5)
		if CFG.vedetteAnimation then
			deco.gif:SetTexture(MEDIA .. "zaardoz")
		else
			-- pas d'image : le texte prend la place (bulle plus basse)
			deco.gif:SetColorTexture(0, 0, 0, 0)
			deco.gif:SetHeight(1)
		end
		deco.cadreGif = deco:CreateTexture(nil, "BORDER")
		deco.cadreGif:SetPoint("TOPLEFT", deco.gif, "TOPLEFT", -2, 2)
		deco.cadreGif:SetPoint("BOTTOMRIGHT", deco.gif, "BOTTOMRIGHT", 2, -2)
		deco.cadreGif:SetColorTexture(1, 0.82, 0, 1)
		if not CFG.vedetteAnimation then deco.cadreGif:Hide() end
		deco:SetScript("OnUpdate", function(self)
			local t = GetTime() - self.debut
			-- GIF
			local i = math.floor(t * ANIM.fps) % ANIM.images
			local col, rang = i % ANIM.colonnes, math.floor(i / ANIM.colonnes)
			local L, H = ANIM.planche[1], ANIM.planche[2]
			self.gif:SetTexCoord(col * ANIM.larg / L, (col + 1) * ANIM.larg / L, rang * ANIM.haut / H, (rang + 1) * ANIM.haut / H)
			-- couleurs (une dizaine de fois par seconde suffit)
			if t - (self.derniere or -1) < 0.06 then return end
			self.derniere = t
			bulle.texte:SetText(ArcEnCiel(self.ligne1, t) .. "\n\n" .. ArcEnCiel(self.ligne2, t + 0.3, 0.08))
			local r, g, b = Teinte((t * 0.35) % 1)
			bulle:SetBackdropBorderColor(r, g, b, 1)
			self.cadreGif:SetColorTexture(Teinte((t * 0.35 + 0.5) % 1))
		end)
	end
	deco.ligne1 = ("%s a atteint le niveau %s !"):format(VEDETTE_NOM, niveau)
	deco.ligne2 = CRI and (CRI .. " ! " .. CRI .. " ! " .. CRI .. " !") or "Bravo !"
	deco.debut = GetTime()
	deco.derniere = nil
	-- format vertical : le GIF en haut, les textes centrés dessous
	-- (pas de titre : seulement le texte, sous le GIF)
	bulle.titre:Hide()
	bulle.texte:ClearAllPoints()
	bulle.texte:SetPoint("TOP", deco.gif, "BOTTOM", 0, -10)
	bulle.texte:SetJustifyH("CENTER")
	bulle.texte:SetFontObject("GameFontHighlightLarge")
	-- le texte ne dépasse pas la largeur du GIF (retour à la ligne si besoin)
	bulle.texte:SetWidth(GIF_L - 8)
	bulle.texte:SetWordWrap(true)
	bulle.texte:SetText(deco.ligne1 .. "\n\n" .. deco.ligne2)
	local hauteur = 5 + (CFG.vedetteAnimation and GIF_H or 1) + 10 + bulle.texte:GetStringHeight() + 14
	bulle:SetSize(GIF_L + 10, hauteur)
	deco:Show()
	-- à la prochaine bulle ordinaire : tout revient comme avant
	bulle.Reinit = function(self)
		deco:Hide()
		self.titre:Show()
		self.titre:ClearAllPoints()
		self.titre:SetPoint("TOPLEFT", self, "TOPLEFT", 12, -10)
		self.texte:ClearAllPoints()
		self.texte:SetPoint("TOPLEFT", self.titre, "BOTTOMLEFT", 0, -4)
		self.titre:SetJustifyH("LEFT")
		self.texte:SetJustifyH("LEFT")
		self.titre:SetWidth(0) -- largeur libre, comme avant
		self.texte:SetWidth(0)
		self.titre:SetFontObject("GameFontNormal")
		self.texte:SetFontObject("GameFontHighlight")
		self:SetBackdropBorderColor(1, 0.82, 0, 1)
		self.Reinit = nil
	end
end

-- appelé par GuildUp_Annonces à la réception d'une montée de niveau ; true = déjà affichée
ns.NiveauSpecial = function(expediteur, niveau)
	if not EstVedette(expediteur) then return false end
	if not ns.Notifier then return false end
	-- bulle filtrée (notification « Niveaux » coupée) : ni corne ni décoration, et pas de bulle
	-- ordinaire non plus (true = traité)
	if not ns.Notifier("niveaux", "La guilde progresse", ("%s a atteint le niveau %s !"):format(VEDETTE_NOM, niveau), "aucun", function() end) then
		return true
	end
	-- corne de guerre (fichiers du jeu : corne naine d'Ironforge, sinon celle du Fléau)
	if PlaySoundFile then
		local ok, joue = pcall(PlaySoundFile, CORNE, "Master")
		if not ok or joue == false then pcall(PlaySoundFile, CORNE2, "Master") end
	end
	local bulle = _G.GuildUpBulle
	if bulle and bulle:IsShown() then pcall(Decorer, bulle, niveau) end
	return true
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

local CANAUX = { "CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_PARTY", "CHAT_MSG_PARTY_LEADER", "CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER", "CHAT_MSG_GUILD", "CHAT_MSG_INSTANCE_CHAT", "CHAT_MSG_INSTANCE_CHAT_LEADER" }
local ev = CreateFrame("Frame")
for _, nom in ipairs(CANAUX) do pcall(ev.RegisterEvent, ev, nom) end
pcall(ev.RegisterEvent, ev, "PLAYER_LEVEL_UP")
-- un membre a écrit le cri hors du canal de guilde : on le voit aussi
ns.Ecouter(PREFIXE, function(_, msg, _, expediteur)
	if msg ~= "G" then return end
	local cle = Normaliser(expediteur)
	if cle ~= MaCle() and not Coupee() then Emote(cle) end
end)
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "PLAYER_LEVEL_UP" then
		-- c'est moi, la vedette : je vois aussi ma fête (les autres la reçoivent par l'annonce)
		if EstVedette(MaCle()) then
			local niveau = a1
			C_Timer.After(1, function() ns.NiveauSpecial(MaCle(), niveau) end)
		end
		return
	end
	if not (DitGU(a1) and a2) then return end
	local cle = Normaliser(a2)
	-- c'est moi, hors du canal de guilde : je préviens la guilde (au plus une fois toutes les 3 s)
	if cle == MaCle() and event ~= "CHAT_MSG_GUILD" and IsInGuild() and GetTime() - (derniere["envoi"] or 0) > 3 then
		derniere["envoi"] = GetTime()
		Envoyer("G")
	end
	if Coupee() then return end
	local ok, err = pcall(Emote, cle)
	if not ok then diag.refus = "erreur : " .. tostring(err) end
end)
