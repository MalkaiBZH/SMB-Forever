-- GuildUpSMB : explosion de montée de niveau (« Et son nom est… »).
-- Quand un membre de la guilde monte de niveau (annonce « N » reçue par GuildUp_Annonces.lua, ou moi-même) :
-- musique d'entrée de catch et fête à l'écran, environ 6 s en tout :
--   « ET SON NOM EST… » (1,3 s), puis le boum : léger éclair, portrait du membre (media\portraits, celui de la
--   carte de la guilde, sinon l'icône de sa classe) dans un anneau doré, rayons qui tournent derrière, gerbe
--   d'étincelles, nom en arc-en-ciel qui s'écrase à l'écran, compteur de niveau (l'ancien, puis le nouveau et
--   « +1 »), pluie de confettis, bords de l'écran dorés qui pulsent, et feux d'artifice un peu partout.
-- Aucun message réseau : s'appuie sur l'annonce de niveau déjà envoyée par GuildUp_Annonces.lua.
-- Musique : media\levelup.mp3 de l'addon (sample de 5 s). Un joueur peut la remplacer par la sienne dans
-- Interface\AddOns\GuildUpSMB_Sons\levelup.mp3 (ou .ogg), hors du dossier de l'addon pour que le programme
-- de mise à jour ne l'efface pas. Le jeu ne voit un nouveau fichier qu'après avoir été relancé : en attendant,
-- la corne de guerre naine du jeu au boum. La musique est coupée en fondu après MUSIQUE secondes.
-- Case « Surprise » des notifications (db.notifs.cena == false : coupée). /smb cena [niveau] : essai.
-- Surprise : ni la case, ni l'aide de /smb, ni les notes de version, ni le README ne disent ce que c'est.
-- Plusieurs montées de niveau en même temps : à la suite (3 en attente au plus).

local NOM_ADDON, ns = ...

local MEDIA = ns.MEDIA or ("Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\")
local ROND, ANNEAU = MEDIA .. "point", MEDIA .. "anneau"
local DOSSIER_SONS = "Interface\\AddOns\\GuildUpSMB_Sons\\"
local SONS_JOUEUR = { DOSSIER_SONS .. "levelup.mp3", DOSSIER_SONS .. "levelup.ogg", MEDIA .. "levelup.mp3" }
local CORNES = { 566064, 567386 } -- sound/doodad/dwarfhorn.ogg, sound/events/scourge_horn.ogg
local POLICE = "Fonts\\FRIZQT__.TTF"

local ANNONCE = 1.3      -- secondes de « ET SON NOM EST… » avant le boum
local TENUE = 4          -- secondes à l'écran après le boum
local FONDU = 1          -- secondes de fondu à la fin
local MUSIQUE = 12       -- secondes de musique au plus (puis fondu de 2 s)
local ATTENTE_MAX = 3    -- montées de niveau en attente au plus
local HAUTEUR = 80       -- centre de l'animation, au-dessus du milieu de l'écran (pixels)
local PORTRAIT = 150     -- diamètre du portrait (pixels)
local ECLAIR = 0.25      -- force de l'éclair au boum
local TREMBLE = 8        -- force du tremblement au boum
local ETINCELLES = 30
local RAYONS = 10
local CONFETTIS = 90
local FUSEES, ECLATS = 8, 26
local BORDS = 0.6        -- force des bords dorés

local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local Normaliser = ns.Normaliser

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
-- Outils d'image
--------------------------------------------------------------------------------

local function Tex(parent, couche, fichier, ajout)
	local t = parent:CreateTexture(nil, couche or "ARTWORK")
	if fichier then t:SetTexture(fichier) end
	if ajout ~= false then t:SetBlendMode("ADD") end
	t:Hide()
	return t
end

local function Texte(parent, taille, repli)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	if not fs:SetFont(POLICE, taille, "THICKOUTLINE") then fs:SetFontObject(repli) end
	fs:SetPoint("CENTER", parent, "CENTER", 0, 0)
	fs:SetShadowOffset(3, -3)
	fs:SetShadowColor(0, 0, 0, 1)
	return fs
end

local function Tourner(t, angle) if t.SetRotation then pcall(t.SetRotation, t, angle) end end
local function Hasard(a, b) return a + math.random() * (b - a) end
local function Doux(p) return 1 - (1 - p) * (1 - p) end -- démarre vite, finit doucement

-- échelle d'un texte qui s'écrase à l'écran : de 4 à 1 en 0,16 s, puis un rebond qui s'amortit
local function Ecrase(b)
	if b < 0.16 then return 4 - 3 * (b / 0.16) end
	local x = b - 0.16
	return 1 + 0.22 * math.exp(-6 * x) * math.sin(22 * x)
end

-- teinte (0-1) → couleur vive, un peu éclaircie
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
	return 0.3 + 0.7 * r, 0.3 + 0.7 * g, 0.3 + 0.7 * b
end

-- texte arc-en-ciel : une couleur par lettre (lettres UTF-8 entières), qui défile
local function ArcEnCiel(texte, t)
	local morceaux, i = {}, 0
	for lettre in texte:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		if lettre == " " then morceaux[#morceaux + 1] = " "
		else
			local r, g, b = Teinte((i * 0.06 - t * 0.7) % 1)
			morceaux[#morceaux + 1] = ("|cff%02x%02x%02x%s|r"):format(math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), lettre)
		end
		i = i + 1
	end
	return table.concat(morceaux)
end

local COULEURS = { { 1, 0.85, 0.2 }, { 1, 0.35, 0.3 }, { 0.35, 0.8, 1 }, { 0.45, 1, 0.45 }, { 1, 0.45, 1 }, { 1, 1, 1 }, { 1, 0.6, 0.15 } }
local function Couleur() return COULEURS[math.random(#COULEURS)] end

--------------------------------------------------------------------------------
-- Le cadre et ses éléments
--------------------------------------------------------------------------------

local function Creer()
	local f = CreateFrame("Frame", "GuildUpExplosion", UIParent)
	f:SetAllPoints(UIParent)
	f:SetFrameStrata("FULLSCREEN_DIALOG")
	f:EnableMouse(false)
	f:Hide()

	-- plein écran : éclair, bords dorés, confettis, fusées
	f.eclair = f:CreateTexture(nil, "BACKGROUND")
	f.eclair:SetAllPoints(f)
	f.eclair:SetColorTexture(1, 0.7, 0.25)
	f.eclair:SetBlendMode("ADD")
	f.bords = {}
	for _, cote in ipairs({ "TOP", "BOTTOM", "LEFT", "RIGHT" }) do
		for k = 1, 6 do
			local b = Tex(f, "BORDER", nil)
			b:SetColorTexture(1, 0.75, 0.2, 1)
			b.k = k
			if cote == "TOP" or cote == "BOTTOM" then
				local dy = (cote == "TOP" and -1 or 1) * (k - 1) * 7
				b:SetPoint(cote .. "LEFT", f, cote .. "LEFT", 0, dy)
				b:SetPoint(cote .. "RIGHT", f, cote .. "RIGHT", 0, dy)
				b:SetHeight(7)
			else
				local dx = (cote == "LEFT" and 1 or -1) * (k - 1) * 7
				b:SetPoint("TOP" .. cote, f, "TOP" .. cote, dx, 0)
				b:SetPoint("BOTTOM" .. cote, f, "BOTTOM" .. cote, dx, 0)
				b:SetWidth(7)
			end
			f.bords[#f.bords + 1] = b
		end
	end
	f.confettis = {}
	for i = 1, CONFETTIS do f.confettis[i] = Tex(f, "ARTWORK", nil, false) end
	f.feux = {}
	for i = 1, FUSEES do
		local fu = { tete = Tex(f, "ARTWORK", ROND), eclats = {} }
		for k = 1, ECLATS do fu.eclats[k] = Tex(f, "ARTWORK", ROND) end
		f.feux[i] = fu
	end

	-- centre de l'animation (tremble) : rayons, étincelles, portrait, textes
	f.centre = CreateFrame("Frame", nil, f)
	f.centre:SetSize(1, 1)
	f.rayons = {}
	for i = 1, RAYONS do
		local r = Tex(f.centre, "BACKGROUND", ROND) -- (ellipses très allongées)
		r:SetSize(1100, 26)
		r:SetVertexColor(1, 0.85, 0.45)
		r.angle = (i - 1) * math.pi / RAYONS
		f.rayons[i] = r
	end
	f.etincelles = {}
	for i = 1, ETINCELLES do f.etincelles[i] = Tex(f.centre, "ARTWORK", ROND) end

	-- portrait : disque sombre, image, anneau doré
	f.cadrePortrait = CreateFrame("Frame", nil, f.centre)
	f.cadrePortrait:SetSize(PORTRAIT, PORTRAIT)
	f.fondPortrait = f.cadrePortrait:CreateTexture(nil, "BORDER")
	f.fondPortrait:SetTexture(ROND)
	f.fondPortrait:SetSize(PORTRAIT * 0.9, PORTRAIT * 0.9)
	f.fondPortrait:SetPoint("CENTER")
	f.fondPortrait:SetVertexColor(0.12, 0.09, 0.06, 1)
	f.imagePortrait = f.cadrePortrait:CreateTexture(nil, "ARTWORK")
	f.anneauPortrait = f.cadrePortrait:CreateTexture(nil, "OVERLAY")
	f.anneauPortrait:SetTexture(ANNEAU)
	f.anneauPortrait:SetSize(PORTRAIT * 1.02, PORTRAIT * 1.02)
	f.anneauPortrait:SetPoint("CENTER")
	f.anneauPortrait:SetVertexColor(1, 0.8, 0.25, 1)
	f.cadrePortrait:Hide()

	-- textes, chacun dans son cadre : l'échelle du cadre fait l'effet d'écrasement
	local function Cadre()
		local c = CreateFrame("Frame", nil, f.centre)
		c:SetSize(1, 1)
		c:SetPoint("CENTER", f.centre, "CENTER", 0, 0)
		c:Hide()
		return c
	end
	f.cadreAnnonce, f.cadreNom, f.cadreNiveau, f.cadrePlus = Cadre(), Cadre(), Cadre(), Cadre()
	f.annonce = Texte(f.cadreAnnonce, 36, "GameFontNormalHuge")
	f.annonce:SetTextColor(1, 1, 1)
	f.annonce:SetText("ET SON NOM EST…")
	f.nom = Texte(f.cadreNom, 48, "GameFontNormalHuge")
	f.niveau = Texte(f.cadreNiveau, 30, "GameFontNormalLarge")
	f.niveau:SetTextColor(1, 0.45, 0.1)
	f.plus = Texte(f.cadrePlus, 26, "GameFontNormalLarge")
	f.plus:SetTextColor(0.45, 1, 0.45)
	f.plus:SetText("+1")
	return f
end

-- positions, vitesses et couleurs au hasard, pour une nouvelle explosion
local function Preparer(f)
	local L, H = UIParent:GetWidth(), UIParent:GetHeight()
	f.L, f.H = L, H
	for _, e in ipairs(f.etincelles) do
		local angle = math.random() * 2 * math.pi
		local vitesse = Hasard(250, 900)
		e.vx, e.vy = math.cos(angle) * vitesse, math.sin(angle) * vitesse + 150
		e.vie, e.taille = Hasard(0.9, 2.2), Hasard(5, 17)
		local g = Hasard(0.45, 0.95)
		e:SetVertexColor(1, g, g * 0.35)
	end
	for _, c in ipairs(f.confettis) do
		local couleur = Couleur()
		c:SetColorTexture(couleur[1], couleur[2], couleur[3], 1)
		c:SetSize(Hasard(5, 9), Hasard(9, 15))
		c.x0, c.retard, c.vitesse = Hasard(0, L), Hasard(0, 2.6), Hasard(90, 230)
		c.ampl, c.freq, c.phase, c.tour = Hasard(15, 60), Hasard(1.5, 3.5), Hasard(0, 6.3), Hasard(-6, 6)
	end
	-- fusées : départ du bas, rapprochées (tout tient dans la durée), éclatement dans le haut de l'écran
	for i, fu in ipairs(f.feux) do
		fu.depart = 0.1 + (i - 1) * Hasard(0.2, 0.35)
		fu.x0, fu.y1 = Hasard(0.08, 0.92) * L, Hasard(0.45, 0.88) * H
		fu.x1 = fu.x0 + Hasard(-90, 90)
		local couleur = Couleur()
		for _, e in ipairs(fu.eclats) do
			local angle = math.random() * 2 * math.pi
			local vitesse = Hasard(110, 260)
			e.vx, e.vy, e.taille = math.cos(angle) * vitesse, math.sin(angle) * vitesse, Hasard(4, 9)
			e:SetVertexColor(couleur[1], couleur[2], couleur[3])
		end
		fu.tete:SetVertexColor(1, 0.9, 0.6)
	end
end

--------------------------------------------------------------------------------
-- Une image de l'animation
--------------------------------------------------------------------------------

local Terminer

-- particule qui part de (x0, y0) à vitesse (vx, vy), freinée par l'air, puis retombe ; plein écran :
-- coordonnées depuis le coin bas gauche, sinon depuis le centre du parent
local function Particule(t, parent, pleinEcran, x0, y0, b, vie, gravite)
	if b < 0 or b >= vie then t:Hide(); return end
	local d = (1 - math.exp(-1.6 * b)) / 1.6
	local r = 1 - b / vie
	t:ClearAllPoints()
	t:SetPoint("CENTER", parent, pleinEcran and "BOTTOMLEFT" or "CENTER", x0 + t.vx * d, y0 + t.vy * d - (gravite or 250) * b * b)
	local s = t.taille * (0.4 + 0.6 * r)
	t:SetSize(s, s)
	t:SetAlpha(r)
	t:Show()
end

-- place un cadre de texte (mis à l'échelle s) au point (0, y) du centre
local function Placer(c, f, s, y)
	c:SetScale(s)
	c:ClearAllPoints()
	c:SetPoint("CENTER", f.centre, "CENTER", 0, y / s)
end

local function Animer(f)
	local t = GetTime() - f.debut
	local fin = ANNONCE + TENUE + FONDU
	if t >= fin then Terminer(); return end
	local b = t - ANNONCE -- temps depuis le boum (négatif avant)
	f:SetAlpha(t > ANNONCE + TENUE and (fin - t) / FONDU or 1)
	local L, H = f.L, f.H

	-- tremblement : léger qui monte pendant l'annonce, plus fort au boum puis qui s'amortit
	local amp = b < 0 and (1 + 4 * t / ANNONCE) or TREMBLE * math.exp(-3.5 * b)
	f.centre:ClearAllPoints()
	f.centre:SetPoint("CENTER", f, "CENTER", (math.random() * 2 - 1) * amp, HAUTEUR + (math.random() * 2 - 1) * amp)

	-- « ET SON NOM EST… »
	if b < 0 then
		Placer(f.cadreAnnonce, f, 0.85 + 0.3 * t / ANNONCE, 0)
		f.annonce:SetAlpha(math.min(1, t / 0.25))
		f.cadreAnnonce:Show()
		return
	end
	f.cadreAnnonce:Hide()
	if not f.boum then
		f.boum = true
		if not f.musique then Corne() end
	end

	-- éclair
	local a = ECLAIR * (1 - b / 0.5)
	if a > 0 then f.eclair:SetAlpha(a); f.eclair:Show() else f.eclair:Hide() end

	-- rayons qui tournent derrière le portrait
	for _, r in ipairs(f.rayons) do
		Tourner(r, r.angle + t * 0.25)
		r:SetAlpha(0.16 * math.min(1, b / 0.6))
		r:ClearAllPoints()
		r:SetPoint("CENTER", f.centre, "CENTER", 0, 30)
		r:Show()
	end

	-- étincelles
	for _, e in ipairs(f.etincelles) do Particule(e, f.centre, false, 0, 30, b, e.vie) end

	-- portrait : arrive en zoom, puis rebondit
	local c = f.cadrePortrait
	local s = math.max(0.01, b < 0.16 and (b / 0.16) * 1.15 or Ecrase(b + 0.05))
	c:SetScale(s)
	c:ClearAllPoints()
	c:SetPoint("CENTER", f.centre, "CENTER", 0, 30 / s)
	c:Show()
	local yNom, yNiveau = 30 - PORTRAIT / 2 - 42, 30 - PORTRAIT / 2 - 100

	-- le nom s'écrase, en arc-en-ciel
	Placer(f.cadreNom, f, Ecrase(b), yNom)
	f.nom:SetAlpha(math.min(1, b / 0.08))
	if t - (f.derniereCouleur or -1) > 0.05 then
		f.derniereCouleur = t
		f.nom:SetText(ArcEnCiel(f.nomTexte, t))
	end
	f.cadreNom:Show()

	-- le niveau : l'ancien, puis le nouveau qui s'écrase, et « +1 » qui monte
	local bn = b - 0.35
	if bn > 0 then
		local nouveau = bn >= 0.5
		f.niveau:SetText(nouveau and ("NIVEAU " .. tostring(f.niveauAtteint) .. " !") or ("NIVEAU " .. tostring(f.niveauAvant)))
		Placer(f.cadreNiveau, f, nouveau and Ecrase(bn - 0.5) or 1, yNiveau)
		f.niveau:SetAlpha(math.min(1, bn / 0.08))
		f.cadreNiveau:Show()
		local bp = bn - 0.5
		if bp > 0 and bp < 1.6 then
			f.cadrePlus:ClearAllPoints()
			f.cadrePlus:SetPoint("CENTER", f.centre, "CENTER", 150, yNiveau + 10 + 70 * bp)
			f.plus:SetAlpha(1 - bp / 1.6)
			f.cadrePlus:Show()
		else
			f.cadrePlus:Hide()
		end
	else
		f.cadreNiveau:Hide()
		f.cadrePlus:Hide()
	end

	-- bords dorés qui pulsent
	for _, bd in ipairs(f.bords) do
		bd:SetAlpha(BORDS * (0.3 - (bd.k - 1) * 0.05) * (0.6 + 0.4 * math.sin(t * 4)) * math.min(1, b / 0.4))
		bd:Show()
	end

	-- confettis qui tombent en tournant
	for _, cf in ipairs(f.confettis) do
		local q = b - cf.retard
		local y = H + 20 - cf.vitesse * q
		if q >= 0 and y >= -20 then
			cf:ClearAllPoints()
			cf:SetPoint("CENTER", f, "BOTTOMLEFT", cf.x0 + cf.ampl * math.sin(q * cf.freq + cf.phase), y)
			Tourner(cf, cf.tour * q)
			cf:Show()
		else
			cf:Hide()
		end
	end

	-- fusées : la tête monte, puis éclate en éclats qui retombent
	for _, fu in ipairs(f.feux) do
		local q = b - fu.depart
		if q >= 0 and q < 0.7 then
			local p = Doux(q / 0.7)
			fu.tete:ClearAllPoints()
			fu.tete:SetPoint("CENTER", f, "BOTTOMLEFT", fu.x0 + (fu.x1 - fu.x0) * p, fu.y1 * p)
			fu.tete:SetSize(8, 8)
			fu.tete:Show()
		else
			fu.tete:Hide()
		end
		for _, ec in ipairs(fu.eclats) do Particule(ec, f, true, fu.x1, fu.y1, q - 0.7, 1.7, 160) end
	end
end

-- portrait d'un membre : le mien (race, classe, sexe), sinon celui de la carte de la guilde, sinon
-- l'icône de sa classe
local function PoserPortrait(f, nom)
	local cle = nom and Normaliser and Normaliser(nom)
	local moi = cle and ns.MaCle and cle == ns.MaCle()
	local chemin
	if moi then
		chemin = ns.CheminPortrait and ns.PortraitUnite and ns.CheminPortrait(ns.PortraitUnite("player"))
	else
		local positions = ns.PositionsMembres and ns.PositionsMembres()
		local p = positions and cle and positions[cle]
		chemin = p and p.portrait
	end
	local img = f.imagePortrait
	img:ClearAllPoints()
	if chemin then
		img:SetTexture(chemin)
		img:SetTexCoord(0, 1, 0, 1)
		img:SetSize(PORTRAIT * 1.16, PORTRAIT * 1.16) -- (le disque fait 86 % de l'image)
		img:SetPoint("CENTER", f.cadrePortrait, "CENTER", 0, PORTRAIT * 0.04)
		return
	end
	local classe = cle and ns.ClasseMembre and ns.ClasseMembre(cle)
	if not classe and moi then classe = select(2, UnitClass("player")) end
	local coords = classe and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[classe]
	img:SetPoint("CENTER", f.cadrePortrait, "CENTER", 0, 0)
	img:SetSize(PORTRAIT * 0.55, PORTRAIT * 0.55)
	if coords then
		img:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		img:SetTexCoord(unpack(coords))
	else
		img:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		img:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	end
end

local function Lancer(nom, niveau)
	cadre = cadre or Creer()
	local f = cadre
	-- (réglages des essais de variantes, retirés : effacés)
	local db = ns.DB and ns.DB()
	if db then db.cena = nil end
	enCours = true
	f.nomTexte = NomJoueur(nom)
	f.niveauAtteint = niveau
	f.niveauAvant = tonumber(niveau) and (tonumber(niveau) - 1) or niveau
	f.debut = GetTime()
	f.boum, f.derniereCouleur = false, nil
	for _, liste in ipairs({ f.rayons, f.etincelles, f.bords, f.confettis }) do
		for _, x in ipairs(liste) do x:Hide() end
	end
	for _, fu in ipairs(f.feux) do
		fu.tete:Hide()
		for _, x in ipairs(fu.eclats) do x:Hide() end
	end
	f.eclair:Hide()
	f.cadrePortrait:Hide(); f.cadreNom:Hide(); f.cadreNiveau:Hide(); f.cadrePlus:Hide()
	Preparer(f)
	PoserPortrait(f, nom)
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
	if enCours then
		if #attente < ATTENTE_MAX then attente[#attente + 1] = { nom, niveau } end
		return
	end
	local ok, err = pcall(Lancer, nom, niveau)
	if not ok then
		enCours = false
		if cadre then cadre:SetScript("OnUpdate", nil); cadre:Hide() end
		if ns.Erreur then ns.Erreur("explosion de niveau : " .. tostring(err)) end
	end
end

-- /smb cena [niveau] : essai, avec mon nom (même si la case est décochée)
ns.EssaiExplosion = function(saisie)
	local Message = (ns.Coeur and ns.Coeur.Message) or print
	local niveau = tonumber((saisie or ""):match("(%d+)")) or ((UnitLevel and UnitLevel("player") or 0) + 1)
	if enCours then
		attente = {}
		if cadre then cadre:SetScript("OnUpdate", nil); cadre:Hide() end
		enCours = false
	end
	local ok, err = pcall(Lancer, UnitName("player"), niveau)
	if not ok then
		enCours = false
		if cadre then cadre:SetScript("OnUpdate", nil); cadre:Hide() end
		Message("explosion : erreur " .. tostring(err))
		return
	end
	if not cadre.musique then Message("explosion : musique introuvable (relance le jeu après une mise à jour qui ajoute des fichiers), corne de guerre à la place.") end
	if Coupee() then Message("(la case « Surprise » des notifications est décochée : les vraies montées de niveau n'ont pas d'explosion.)") end
end
