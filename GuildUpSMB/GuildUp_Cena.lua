-- GuildUpSMB : explosion de montée de niveau (« Et son nom est… »).
-- Quand un membre de la guilde monte de niveau (annonce « N » reçue par GuildUp_Annonces.lua, ou moi-même) :
-- musique d'entrée de catch et explosion au milieu de l'écran. « ET SON NOM EST… » pendant 1,3 s, puis
-- BOUM : éclair, boule de feu, ondes de choc, gerbe d'étincelles, et le nom du membre qui s'écrase à
-- l'écran en tremblant, suivi de son niveau. Le tout s'efface au bout d'une dizaine de secondes.
-- Aucun message réseau : s'appuie sur l'annonce de niveau déjà envoyée par GuildUp_Annonces.lua.
-- Musique : media\levelup.mp3 de l'addon (sample de 5 s). Un joueur peut la remplacer par la sienne dans
-- Interface\AddOns\GuildUpSMB_Sons\levelup.mp3 (ou .ogg), hors du dossier de l'addon pour que le programme
-- de mise à jour ne l'efface pas. Le jeu ne voit un nouveau fichier qu'après avoir été relancé : en attendant,
-- la corne de guerre naine du jeu au boum.
-- La musique est coupée en fondu après MUSIQUE secondes.
-- Case « Surprise » des notifications (db.notifs.cena == false : coupée). /smb cena [niveau] : essai.
-- Surprise : ni la case, ni l'aide de /smb, ni les notes de version, ni le README ne disent ce que c'est.
-- Plusieurs montées de niveau en même temps : à la suite (3 en attente au plus).

local NOM_ADDON, ns = ...

local MEDIA = ns.MEDIA or ("Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\")
local DOSSIER_SONS = "Interface\\AddOns\\GuildUpSMB_Sons\\"
local SONS_JOUEUR = { DOSSIER_SONS .. "levelup.mp3", DOSSIER_SONS .. "levelup.ogg", MEDIA .. "levelup.mp3" }
local CORNES = { 566064, 567386 } -- sound/doodad/dwarfhorn.ogg, sound/events/scourge_horn.ogg
local POLICE = "Fonts\\FRIZQT__.TTF"

local ANNONCE = 1.3      -- secondes de « ET SON NOM EST… » avant le boum
local TENUE = 6.5        -- secondes après le boum avant le fondu
local FONDU = 1          -- secondes de fondu à la fin
local MUSIQUE = 12       -- secondes de musique (puis fondu de 2 s)
local ETINCELLES = 48
local ONDES = 3
local ATTENTE_MAX = 3    -- montées de niveau en attente au plus
local HAUTEUR = 80       -- centre de l'explosion, au-dessus du milieu de l'écran (pixels)

local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)

local cadre                -- créé à la première explosion
local enCours = false
local attente = {}         -- { nom, niveau } à montrer ensuite
local sonEnCours           -- poignée de la musique (StopSound)

local function Coupee()
	local db = ns.DB and ns.DB()
	return db and type(db.notifs) == "table" and db.notifs.cena == false or false
end

--------------------------------------------------------------------------------
-- Son
--------------------------------------------------------------------------------

-- musique (celle du joueur, sinon celle de l'addon) ; son chemin si elle joue, sinon nil
local function Musique()
	if sonEnCours and StopSound then pcall(StopSound, sonEnCours, 500) end -- (la précédente, en fondu court)
	sonEnCours = nil
	if not PlaySoundFile then return nil end
	for _, chemin in ipairs(SONS_JOUEUR) do
		local ok, joue, poignee = pcall(PlaySoundFile, chemin, "Master")
		if ok and joue then
			sonEnCours = poignee
			if poignee and StopSound and C_Timer and C_Timer.After then
				C_Timer.After(MUSIQUE, function()
					if sonEnCours == poignee then
						pcall(StopSound, poignee, 2000)
						sonEnCours = nil
					end
				end)
			end
			return chemin
		end
	end
	return nil
end

-- sans musique : la corne de guerre au boum
local function Corne()
	if not PlaySoundFile then return end
	for _, id in ipairs(CORNES) do
		local ok, joue = pcall(PlaySoundFile, id, "Master")
		if ok and joue ~= false then return end
	end
end

--------------------------------------------------------------------------------
-- Image
--------------------------------------------------------------------------------

local function Texte(parent, taille, repli)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	if not fs:SetFont(POLICE, taille, "THICKOUTLINE") then fs:SetFontObject(repli) end
	fs:SetPoint("CENTER", parent, "CENTER", 0, 0)
	fs:SetShadowOffset(3, -3)
	fs:SetShadowColor(0, 0, 0, 1)
	return fs
end

-- échelle d'un texte qui s'écrase à l'écran : de 4 à 1 en 0,16 s, puis un rebond qui s'amortit
local function Ecrase(b)
	if b < 0.16 then return 4 - 3 * (b / 0.16) end
	local x = b - 0.16
	return 1 + 0.22 * math.exp(-6 * x) * math.sin(22 * x)
end

local function Creer()
	local f = CreateFrame("Frame", "GuildUpExplosion", UIParent)
	f:SetAllPoints(UIParent)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:EnableMouse(false)
	f:Hide()

	-- éclair sur tout l'écran
	f.eclair = f:CreateTexture(nil, "BACKGROUND")
	f.eclair:SetAllPoints(f)
	f.eclair:SetColorTexture(1, 0.7, 0.25)
	f.eclair:SetBlendMode("ADD")

	-- centre de l'explosion : tout ce qui tremble
	f.centre = CreateFrame("Frame", nil, f)
	f.centre:SetSize(1, 1)
	f.centre:SetPoint("CENTER", f, "CENTER", 0, HAUTEUR)

	-- boule de feu (disque blanc de l'addon, teinté)
	f.boule = f.centre:CreateTexture(nil, "BACKGROUND")
	f.boule:SetTexture(MEDIA .. "point")
	f.boule:SetBlendMode("ADD")
	f.boule:SetPoint("CENTER", f.centre, "CENTER", 0, 0)

	-- ondes de choc (anneau blanc de l'addon, teinté)
	f.ondes = {}
	for i = 1, ONDES do
		local o = f.centre:CreateTexture(nil, "BORDER")
		o:SetTexture(MEDIA .. "anneau")
		o:SetBlendMode("ADD")
		o:SetVertexColor(1, 0.65 + 0.12 * i, 0.2)
		o:SetPoint("CENTER", f.centre, "CENTER", 0, 0)
		f.ondes[i] = o
	end

	-- étincelles
	f.etincelles = {}
	for i = 1, ETINCELLES do
		local e = f.centre:CreateTexture(nil, "ARTWORK")
		e:SetTexture(MEDIA .. "point")
		e:SetBlendMode("ADD")
		f.etincelles[i] = e
	end

	-- textes, chacun dans son cadre : l'échelle du cadre fait l'effet d'écrasement
	f.cadreAnnonce = CreateFrame("Frame", nil, f.centre)
	f.cadreAnnonce:SetSize(1, 1)
	f.cadreAnnonce:SetPoint("CENTER", f.centre, "CENTER", 0, 0)
	f.annonce = Texte(f.cadreAnnonce, 36, "GameFontNormalHuge")
	f.annonce:SetTextColor(1, 1, 1)

	f.cadreNom = CreateFrame("Frame", nil, f.centre)
	f.cadreNom:SetSize(1, 1)
	f.cadreNom:SetPoint("CENTER", f.centre, "CENTER", 0, 0)
	f.nom = Texte(f.cadreNom, 48, "GameFontNormalHuge")

	f.cadreNiveau = CreateFrame("Frame", nil, f.centre)
	f.cadreNiveau:SetSize(1, 1)
	f.niveau = Texte(f.cadreNiveau, 30, "GameFontNormalLarge")
	f.niveau:SetTextColor(1, 0.45, 0.1)

	return f
end

local Terminer

-- une image de l'animation
local function Animer(f)
	local t = GetTime() - f.debut
	local fin = ANNONCE + TENUE + FONDU
	if t >= fin then Terminer(); return end
	local b = t - ANNONCE -- temps depuis le boum (négatif avant)
	f:SetAlpha(t > ANNONCE + TENUE and (fin - t) / FONDU or 1)

	-- tremblement : léger qui monte pendant l'annonce, violent au boum puis qui s'amortit
	local amp = b < 0 and (1 + 4 * t / ANNONCE) or 24 * math.exp(-3.5 * b)
	f.centre:ClearAllPoints()
	f.centre:SetPoint("CENTER", f, "CENTER", (math.random() * 2 - 1) * amp, HAUTEUR + (math.random() * 2 - 1) * amp)

	if b < 0 then
		f.cadreAnnonce:Show()
		f.cadreAnnonce:SetScale(0.85 + 0.3 * t / ANNONCE)
		f.annonce:SetAlpha(math.min(1, t / 0.25))
		f.cadreNom:Hide()
		f.cadreNiveau:Hide()
		f.eclair:Hide()
		f.boule:Hide()
		for _, o in ipairs(f.ondes) do o:Hide() end
		for _, e in ipairs(f.etincelles) do e:Hide() end
		return
	end

	f.cadreAnnonce:Hide()
	if not f.boum then
		f.boum = true
		if not f.musique then Corne() end
	end

	-- éclair
	local a = 0.7 * (1 - b / 0.5)
	if a > 0 then f.eclair:SetAlpha(a); f.eclair:Show() else f.eclair:Hide() end

	-- boule de feu : grossit vite, passe du blanc-jaune au rouge en s'éteignant
	local p = b / 0.6
	if p < 1 then
		local s = 40 + 520 * (1 - (1 - p) ^ 3)
		f.boule:SetSize(s, s)
		f.boule:SetVertexColor(1, 0.9 - 0.5 * p, 0.5 - 0.45 * p)
		f.boule:SetAlpha(1 - p)
		f.boule:Show()
	else
		f.boule:Hide()
	end

	-- ondes de choc, l'une après l'autre
	for i, o in ipairs(f.ondes) do
		local q = b - (i - 1) * 0.14
		if q > 0 and q < 1 then
			local s = 60 + 1000 * (1 - (1 - q) ^ 2)
			o:SetSize(s, s)
			o:SetAlpha(0.9 * (1 - q))
			o:Show()
		else
			o:Hide()
		end
	end

	-- étincelles : freinées par l'air, puis retombent
	for _, e in ipairs(f.etincelles) do
		if b < e.vie then
			local d = (1 - math.exp(-1.6 * b)) / 1.6
			local r = 1 - b / e.vie
			e:ClearAllPoints()
			e:SetPoint("CENTER", f.centre, "CENTER", e.vx * d, e.vy * d - 250 * b * b)
			e:SetSize(e.taille * (0.4 + 0.6 * r), e.taille * (0.4 + 0.6 * r))
			e:SetAlpha(r)
			e:Show()
		else
			e:Hide()
		end
	end

	-- le nom s'écrase, puis brille entre l'or et le blanc
	f.cadreNom:Show()
	f.cadreNom:SetScale(Ecrase(b))
	f.nom:SetAlpha(math.min(1, b / 0.08))
	local brille = 0.5 + 0.5 * math.sin(t * 6)
	f.nom:SetTextColor(1, 0.75 + 0.25 * brille, 0.1 + 0.6 * brille)

	-- le niveau, juste après (décalage divisé par l'échelle : il est compté dans celle du cadre)
	local bn = b - 0.35
	if bn > 0 then
		local s = Ecrase(bn)
		f.cadreNiveau:SetScale(s)
		f.cadreNiveau:ClearAllPoints()
		f.cadreNiveau:SetPoint("CENTER", f.centre, "CENTER", 0, -62 / s)
		f.niveau:SetAlpha(math.min(1, bn / 0.08))
		f.cadreNiveau:Show()
	else
		f.cadreNiveau:Hide()
	end
end

local function Lancer(nom, niveau)
	cadre = cadre or Creer()
	local f = cadre
	enCours = true
	f.debut = GetTime()
	f.boum = false
	f.annonce:SetText("ET SON NOM EST…")
	f.nom:SetText(nom)
	f.niveau:SetText(("NIVEAU %s !"):format(tostring(niveau)))
	-- étincelles : direction, vitesse, durée, taille et couleur au hasard (plutôt vers le haut)
	for _, e in ipairs(f.etincelles) do
		local angle = math.random() * 2 * math.pi
		local vitesse = 250 + math.random() * 650
		e.vx, e.vy = math.cos(angle) * vitesse, math.sin(angle) * vitesse + 150
		e.vie = 0.9 + math.random() * 1.3
		e.taille = 5 + math.random() * 12
		local g = 0.45 + math.random() * 0.5
		e:SetVertexColor(1, g, g * 0.35)
	end
	f.musique = Musique() or false
	Animer(f)
	f:SetScript("OnUpdate", Animer)
	f:Show()
end

Terminer = function()
	cadre:SetScript("OnUpdate", nil)
	cadre:Hide()
	enCours = false
	local suivant = table.remove(attente, 1)
	if suivant then Lancer(suivant[1], suivant[2]) end
end

--------------------------------------------------------------------------------
-- Pour les autres modules
--------------------------------------------------------------------------------

-- un membre (nom du jeu) a atteint ce niveau : appelé par GuildUp_Annonces.lua
ns.ExplosionNiveau = function(nom, niveau)
	if not nom or not niveau or Coupee() then return end
	local affiche = NomJoueur(nom)
	if enCours then
		if #attente < ATTENTE_MAX then attente[#attente + 1] = { affiche, niveau } end
		return
	end
	local ok, err = pcall(Lancer, affiche, niveau)
	if not ok then
		enCours = false
		if cadre then cadre:SetScript("OnUpdate", nil); cadre:Hide() end
		if ns.Erreur then ns.Erreur("explosion de niveau : " .. tostring(err)) end
	end
end

-- /smb cena [niveau] : essai, avec mon nom (même si la case est décochée)
ns.EssaiExplosion = function(niveau)
	local Message = (ns.Coeur and ns.Coeur.Message) or print
	niveau = tonumber(niveau) or ((UnitLevel and UnitLevel("player") or 0) + 1)
	if enCours then Message("explosion déjà à l'écran : attends qu'elle finisse.") return end
	local ok, err = pcall(Lancer, NomJoueur(UnitName("player")), niveau)
	if not ok then
		enCours = false
		if cadre then cadre:SetScript("OnUpdate", nil); cadre:Hide() end
		Message("explosion : erreur " .. tostring(err))
		return
	end
	Message(cadre.musique and ("explosion : musique = %s"):format(cadre.musique)
		or "explosion : musique introuvable (relance le jeu après une mise à jour qui ajoute des fichiers), corne de guerre à la place.")
	if Coupee() then Message("(la case « Surprise » des notifications est décochée : les vraies montées de niveau n'ont pas d'explosion.)") end
end
