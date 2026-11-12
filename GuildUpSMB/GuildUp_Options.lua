-- GuildUpSMB : fenêtre d'options, diagnostic (/smb diag), réinitialisation et commandes /smb.

local NOM_ADDON, ns = ...
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\" -- le dossier de l'addon, quel que soit son nom

-- GuildUpDB (réglages) : la table est chargée par GuildUp.lua (ADDON_LOADED) ; ce mandataire y donne
-- accès sous le même nom « db » (nil avant le chargement)
local db = setmetatable({}, {
	__index = function(_, k) local t = ns.DB(); return t and t[k] end,
	__newindex = function(_, k, v) local t = ns.DB(); if t then t[k] = v end end,
})
-- (fichiers chargés avant celui-ci)
local DEFAUT, rolesConnus, LireCVarJeu, Message, Erreur, NomComplet, EstDeMaGuilde, Etat, MonRole, RoleManuel, PoserRoleManuel, Annoncer = ns.Coeur.DEFAUT, ns.Coeur.rolesConnus, ns.Coeur.LireCVarJeu, ns.Coeur.Message, ns.Coeur.Erreur, ns.Coeur.NomComplet, ns.Coeur.EstDeMaGuilde, ns.Coeur.Etat, ns.Coeur.MonRole, ns.Coeur.RoleManuel, ns.Coeur.PoserRoleManuel, ns.Coeur.Annoncer
local ToutRafraichir, SurActivation, MajBarre, Bordures, DeplacerAuras, PlacerIncantation, fondsPlaques, misesEnPage, modifiees = ns.Plaques.ToutRafraichir, ns.Plaques.SurActivation, ns.Plaques.MajBarre, ns.Plaques.Bordures, ns.Plaques.DeplacerAuras, ns.Plaques.PlacerIncantation, ns.Plaques.fondsPlaques, ns.Plaques.misesEnPage, ns.Plaques.modifiees
-- Réglages hors DEFAUT, remis à zéro avec les autres (les données des modules : carnets, dons,
-- besoins, projets, identité, cvarsAvant… sont gardées)
local REGLAGES_HORS_DEFAUT = {
	"notifs", "bouton", "barre", "interface", "annoncesGuilde", "emoteGU", "voletNotifs", "coursesCompact",
	"afficherDebug", "tousNiveaux", "styleJeu", "rappelGroupe", "portee", "rolesPerso",
}

-- Bouton « Réinitialiser » et /smb reset : seulement les réglages
local function ReinitialiserReglages()
	for _, k in ipairs(REGLAGES_HORS_DEFAUT) do db[k] = nil end
	for k, v in pairs(DEFAUT) do db[k] = v end
	SurActivation()
end



--------------------------------------------------------------------------------
-- Commandes /smb
--------------------------------------------------------------------------------

local function OuiNon(v) return v and "|cff00ff00oui|r" or "|cffff4444non|r" end

local function Aide()
	Message("/smb tout seul ouvre la fenêtre GuildUpSMB. Commandes :")
	print("  /smb options — réglages de l'addon")
	print("  /smb groupes — recherche de groupe de la guilde")
	print("  /smb metiers — registre des métiers de la guilde")
	print("  /smb quetes — quêtes en commun avec la guilde")
	print("  /smb evenements — créer un événement de guilde (calendrier du jeu)")
	print("  /smb echanges — dons et besoins de la guilde")
	print("  /smb carnet — carnet de craft (tes listes de courses)")
	print("  /smb encyclo — encyclopédie (ou Alt + clic sur un objet)")
	print("  /smb items — tous les objets fabricables")
	print("  /smb projets — projets de guilde")
	print("  /smb nouveautes — les nouveautés de cette version")
	print("  /smb sos — appeler la guilde à l'aide")
	print("  /smb on | off — bannières de la guilde (" .. OuiNon(db.actif) .. ")")
	print("  /smb bouton — afficher / cacher le médaillon GuildUpSMB")
	print("  /smb noms — nom et guilde des autres joueurs (" .. OuiNon(db.nomsAllies) .. ")")
	print("  /smb lueur — lueur derrière la bannière de ta cible (" .. OuiNon(db.lueur) .. ")")
	print("  /smb medaillons — portraits des joueurs sur les bannières (" .. OuiNon(db.medaillons ~= false) .. ")")
	print("  /smb reperes — membres de ta zone à l'écran (" .. OuiNon(db.reperes ~= false) .. ")")
	print("  /smb annonces — annonces de la guilde en bulle (" .. OuiNon(db.annoncesGuilde ~= false) .. ")")
	print("  /smb diag — informations techniques à copier (en cas de problème)")
	print("  /smb debug — afficher / cacher la partie Debug de la fenêtre d'options")
	print("  /smb entree <mot> — noter ma position comme entrée de ce donjon (ex. /smb entree mortemines)")
	print("  /smb reset — réglages par défaut")
end

local fenetre, MajFenetre -- fenêtre d'options, définies plus bas
-- pour le médaillon et la fenêtre GuildUpSMB (rôle, position) : rafraîchit la fenêtre si elle est ouverte
ns.MajOptions = function() if fenetre and fenetre:IsShown() then MajFenetre() end end

local function Rafraichir()
	ToutRafraichir()
	if fenetre and fenetre:IsShown() then MajFenetre() end
end

local function OuvrirSelecteur()
	if not (ColorPickerFrame and ColorPickerFrame.SetupColorPickerAndShow) then
		Message("sélecteur indisponible sur ce client, utilise /smb couleur R V B")
		return
	end
	local avant = { r = db.r, g = db.g, b = db.b, a = db.a }
	ColorPickerFrame:SetupColorPickerAndShow({
		r = db.r, g = db.g, b = db.b,
		hasOpacity = true, opacity = db.a,
		swatchFunc = function()
			db.r, db.g, db.b = ColorPickerFrame:GetColorRGB()
			Rafraichir()
		end,
		opacityFunc = function()
			if ColorPickerFrame.GetColorAlpha then db.a = ColorPickerFrame:GetColorAlpha() end
			Rafraichir()
		end,
		cancelFunc = function()
			db.r, db.g, db.b, db.a = avant.r, avant.g, avant.b, avant.a
			Rafraichir()
		end,
	})
end

local ETATS = { auto = true, tank = true, heal = true, dps = true, horscombat = true }

-- /smb diag : décrit la barre de nom de ta cible, pour comprendre pourquoi rien ne s'affiche
local function DiagCollecte(L)
	do
		local lire = LireCVarJeu
		local t = {}
		for _, nom in ipairs({ "nameplateShowFriends", "nameplateShowFriendlyPlayers", "nameplateShowFriendlyNPCs", "nameplateShowAll", "UnitNameFriendlyPlayerName", "UnitNamePlayerGuild",
			"WorldTextMinSize", "nameplateMinScale", "nameplateMaxScale", "nameplateSelectedScale", "nameplateMaxDistance" }) do
			local ok, v = pcall(lire, nom)
			t[#t + 1] = nom .. "=" .. (ok and tostring(v) or "?")
		end
		L("barres de nom alliées (Maj+V) : " .. table.concat(t, ", "))
		for nom, txt in pairs(ns.essaisCVars or {}) do L("  essai " .. nom .. " : " .. txt) end
		local n = 0
		for _, plaque in ipairs(C_NamePlate.GetNamePlates() or {}) do
			local uf = plaque.UnitFrame
			local unit = uf and uf.unit
			if unit and UnitIsPlayer(unit) and n < 8 then
				n = n + 1
				local okA, a = pcall(uf.GetAlpha, uf)
				local okC, cr, cg, cb = pcall(UnitSelectionColor, unit, true)
				local couleur = "?"
				if okC then
					local okT, txt = pcall(function() return ("%d,%d,%d"):format(cr * 255, cg * 255, cb * 255) end)
					couleur = okT and txt or "secrète"
				end
				L(("  joueur %s : couleur du jeu=%s, guilde=%s, allié=%s, groupe=%s, opacité=%s"):format(
					tostring(UnitName(unit)), couleur, tostring(EstDeMaGuilde(unit)), tostring(UnitIsFriend("player", unit)),
					tostring(UnitInParty(unit) or UnitInRaid(unit) ~= nil),
					okA and tostring(a) or "?"))
			end
		end
	end
	local p = C_NamePlate.GetNamePlateForUnit("target")
	if not p then L("diag : ta cible n'a pas de barre de nom visible"); return end
	local interdit = p.IsForbidden and p:IsForbidden()
	L("diag — plaque : " .. (p:GetName() or "sans nom") .. ", interdite=" .. tostring(interdit))
	if interdit then return end
	local uf = p.UnitFrame
	L("  UnitFrame=" .. tostring(uf and (uf:GetName() or "sans nom")) .. " unit=" .. tostring(uf and uf.unit)
		.. " visible=" .. tostring(uf and uf:IsVisible()))
	L("  name=" .. tostring(uf and uf.name and uf.name:GetObjectType()) .. " healthBar="
		.. tostring(uf and uf.healthBar and uf.healthBar:GetObjectType()) .. " guilde=" .. tostring(EstDeMaGuilde("target")))
	do
		local hb = uf and uf.healthBar
		local f = fondsPlaques[uf]
		local l = f and f.lueur
		local okC, cible = pcall(UnitIsUnit, uf.unit, "target")
		L(("  lueur de cible : option=%s, barre modifiée=%s, ciblé=%s, lueur derrière la bannière affichée=%s"):format(
			tostring(db.lueur), tostring(modifiees[uf] == true), okC and tostring(cible) or "ERREUR",
			tostring(l and l[2] and l[2]:IsShown())))
		local sb = hb and hb.selectedBorder
		if sb then L("  lueur Blizzard (selectedBorder) : affichée=" .. tostring(sb:IsShown()) .. ", visible=" .. tostring(sb:IsVisible())) end
	end
	local cles = {}
	for k, v in pairs(uf or {}) do
		if type(v) == "table" and type(k) == "string" then cles[#cles + 1] = k end
	end
	table.sort(cles)
	L("  clés UnitFrame : " .. table.concat(cles, ", "))
	local enfants = {}
	for _, e in ipairs({ p:GetChildren() }) do
		enfants[#enfants + 1] = (e:GetName() or e:GetObjectType()) .. (e:IsShown() and "" or "(caché)")
	end
	L("  enfants de la plaque : " .. table.concat(enfants, ", "))
	-- contenu de la barre de vie et de son conteneur (pour trouver la bordure)
	local function Decrire(titre, obj)
		if type(obj) ~= "table" or not obj.GetRegions then return end
		local morceaux = {}
		for k, v in pairs(obj) do
			if type(k) == "string" and type(v) == "table" and v.GetObjectType then
				morceaux[#morceaux + 1] = k .. "(" .. v:GetObjectType() .. (v:IsShown() and "" or ",caché") .. ")"
			end
		end
		table.sort(morceaux)
		L("  " .. titre .. " clés : " .. table.concat(morceaux, ", "))
		local regions = {}
		for _, r in ipairs({ obj:GetRegions() }) do
			if r:GetObjectType() == "Texture" and r:IsShown() then
				regions[#regions + 1] = tostring(r:GetAtlas() or r:GetTexture() or "?")
			end
		end
		L("  " .. titre .. " textures visibles : " .. table.concat(regions, ", "))
	end
	if uf then
		Decrire("healthBar", uf.healthBar)
		Decrire("HealthBarsContainer", uf.HealthBarsContainer)
		L("  bordures trouvées : " .. #Bordures(uf))
		local af = uf.AurasFrame
		if af then
			Decrire("AurasFrame", af)
			Decrire("BuffListFrame", af.BuffListFrame)
			Decrire("DebuffListFrame", af.DebuffListFrame)
		else
			L("  AurasFrame : absent")
		end
		-- fonctions de mise en page de Blizzard (pour remettre une barre de nom dans son état d'origine)
		local function Fonctions(titre, obj)
			if type(obj) ~= "table" then return end
			local noms = {}
			for k, v in pairs(obj) do
				if type(v) == "function" and type(k) == "string"
					and (k:find("Layout") or k:find("Anchor") or k:find("Setup") or k:find("Position")
						or k:find("Apply") or k:find("Refresh") or k:find("Update")) then
					noms[#noms + 1] = k
				end
			end
			table.sort(noms)
			L("  " .. titre .. " fonctions : " .. (#noms > 0 and table.concat(noms, ", ") or "aucune"))
		end
		Fonctions("UnitFrame", uf)
		Fonctions("plaque", p)
		Fonctions("AurasFrame", uf.AurasFrame)
		Fonctions("CastBarsContainer", uf.CastBarsContainer)
		Fonctions("castBar", uf.CastBarsContainer and uf.CastBarsContainer.castBar)
		Decrire("CastBarsContainer", uf.CastBarsContainer)
		-- on ne déplace rien sur une barre de nom hors guilde (la mise en page ne s'applique qu'à la guilde)
		local function Tenter(fn)
			if not misesEnPage[uf] then return "non appliqué (pas de la guilde)" end
			local ok, e = pcall(fn, uf)
			return ok and "ok" or ("ERREUR " .. tostring(e))
		end
		L("  mise en page GuildUpSMB appliquée : " .. tostring(misesEnPage[uf] == true))
		L("  placement de l'incantation : " .. Tenter(PlacerIncantation))
		Decrire("LevelFrame", uf.LevelFrame)
		Decrire("PlayerLevelDiffFrame", uf.PlayerLevelDiffFrame)
		L("  déplacement des auras : " .. Tenter(DeplacerAuras))
		local ok, err = pcall(MajBarre, uf)
		L("  MajBarre : " .. (ok and "ok" or ("ERREUR " .. tostring(err))))
		local f = fondsPlaques[uf]
		if f then
			L("  fond : visible=" .. tostring(f.o:IsVisible()) .. " texture=" .. tostring(f.o:GetTexture()))
		else
			L("  fond : jamais créé")
		end
	end
	L("  hook CompactUnitFrame_UpdateName : " .. tostring(CompactUnitFrame_UpdateName ~= nil))
	local n = 0
	for _ in pairs(rolesConnus) do n = n + 1 end
	L(("  rôles : le mien=%s, cible=%s (%s), rôles reçus de la guilde=%d, spécialisation lisible=%s"):format(
		tostring(MonRole()), tostring(Etat("target")), tostring(NomComplet("target")), n,
		tostring(GetSpecialization ~= nil and GetSpecializationRole ~= nil)))
end

-- Fenêtre avec le texte du diagnostic, déjà sélectionné : Ctrl+C pour copier
local fenetreCopie

local function AfficherCopie(texte)
	if not fenetreCopie then
		local f = ns.FenetreDeplacable("GuildUpCopie", 520, 380)
		if f.TitleText then f.TitleText:SetText("GuildUpSMB — diag (Ctrl+C pour copier)") end

		local defile = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		defile:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -30)
		defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -32, 12)

		local edit = CreateFrame("EditBox", nil, defile)
		edit:SetMultiLine(true)
		edit:SetAutoFocus(false)
		edit:SetFontObject("ChatFontNormal")
		edit:SetWidth(470)
		edit:SetScript("OnEscapePressed", function() f:Hide() end)
		-- le texte ne doit pas être modifié : on le remet si on tape dedans
		edit:SetScript("OnTextChanged", function(self, parUtilisateur)
			if parUtilisateur then self:SetText(f.texte or ""); self:HighlightText() end
		end)
		defile:SetScrollChild(edit)
		f.edit = edit
		fenetreCopie = f
	end
	fenetreCopie.texte = texte
	fenetreCopie:Show()
	fenetreCopie.edit:SetText(texte)
	fenetreCopie.edit:SetFocus()
	fenetreCopie.edit:HighlightText()
end

-- Test pour la future carte de la guilde : la position du joueur est-elle lisible par un addon ?
local function DiagPosition(L)
	L("position (test pour la carte) :")
	if not (C_Map and C_Map.GetBestMapForUnit) then
		L("  C_Map.GetBestMapForUnit : absent")
		return
	end
	local okM, carte = pcall(C_Map.GetBestMapForUnit, "player")
	L("  carte : " .. (okM and tostring(carte) or ("ERREUR " .. tostring(carte))))
	if okM and carte then
		local okI, info = pcall(C_Map.GetMapInfo, carte)
		L("  nom de la carte : " .. tostring(okI and info and info.name))
		local okP, pos = pcall(C_Map.GetPlayerMapPosition, carte, "player")
		if okP and pos then
			local okX, x, y = pcall(pos.GetXY, pos)
			L("  coordonnées : " .. (okX and ("%.4f, %.4f"):format(x or -1, y or -1) or ("ERREUR " .. tostring(x))))
		else
			L("  coordonnées : " .. (okP and "aucune (nil)" or ("ERREUR " .. tostring(pos))))
		end
	end
	local okU, ux, uy, uz, instance = pcall(UnitPosition, "player")
	L("  UnitPosition : " .. (okU and ("%s, %s, instance %s"):format(tostring(ux), tostring(uy), tostring(instance))
		or ("ERREUR " .. tostring(ux))))
	L("  en instance : " .. tostring(IsInInstance and IsInInstance()))
end

local function Diag()
	local lignes = {}
	local function L(s) lignes[#lignes + 1] = s end
	DiagCollecte(L)
	pcall(DiagPosition, L)
	if ns.DiagGroupes then
		local ok, err = pcall(ns.DiagGroupes, L)
		if not ok then L("groupes : ERREUR " .. tostring(err)) end
	end
	if ns.DiagCarte then
		local ok, err = pcall(ns.DiagCarte, L)
		if not ok then L("carte : ERREUR " .. tostring(err)) end
	end
	for _, d in ipairs({ { "métiers", ns.DiagMetiers }, { "version", ns.DiagVersion }, { "quêtes", ns.DiagQuetes },
		{ "événements", ns.DiagEvenements }, { "recherche", ns.DiagRecherche }, { "besoins", ns.DiagBesoins }, { "échanges", ns.DiagEchanges }, { "discord", ns.DiagDiscord }, { "carnet", ns.DiagCarnet }, { "carnet2", ns.DiagCarnet2 }, { "projets", ns.DiagProjets }, { "identité", ns.DiagIdentite }, { "gu", ns.DiagGU } }) do
		if d[2] then
			local ok, err = pcall(d[2], L)
			if not ok then L(d[1] .. " : ERREUR " .. tostring(err)) end
		end
	end
	AfficherCopie(table.concat(lignes, "\n"))
end

--------------------------------------------------------------------------------
-- Fenêtre d'options (/smb)
--------------------------------------------------------------------------------

local controles = {} -- { maj = fonction qui recale l'état affiché }

MajFenetre = function()
	for _, c in ipairs(controles) do c.maj() end
end

local function Appliquer()
	ToutRafraichir()
	MajFenetre()
end

local function NouvelleCase(parent, x, y, texte, lire, ecrire, radio)
	local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	cb:SetSize(24, 24)
	cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	local label = cb.Text or cb.text
	if not label then
		label = cb:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("LEFT", cb, "RIGHT", 2, 0)
	end
	label:SetFontObject("GameFontHighlight")
	label:SetText(texte)
	cb:SetScript("OnClick", function(self)
		if radio then ecrire() else ecrire(self:GetChecked() and true or false) end
		Appliquer()
	end)
	table.insert(controles, { maj = function() cb:SetChecked(lire()) end })
	return cb
end

local function NouveauTitre(parent, x, y, texte)
	local t = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	t:SetText(texte)
	return t
end

local function CreerFenetre()
	local f = ns.FenetreDeplacable("GuildUpFenetre", 330, 354)
	f:SetScript("OnShow", MajFenetre)

	local titre = f.TitleText or f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if not f.TitleText then titre:SetPoint("TOP", f, "TOP", 0, -16) end
	titre:SetText("GuildUpSMB")

	local x, y = 16, -34
	local function Ligne(h) local v = y; y = y - (h or 24); return v end

	NouvelleCase(f, x, Ligne(), "Activer les bannières",
		function() return db.actif end, function(v) db.actif = v; SurActivation() end)
	NouvelleCase(f, x, Ligne(), "Portraits des joueurs sur les bannières",
		function() return db.medaillons ~= false end, function(v) db.medaillons = v; ToutRafraichir() end)
	NouvelleCase(f, x, Ligne(), "Membres de ma zone à l'écran",
		function() return db.reperes ~= false end, function(v) db.reperes = v end)
	NouvelleCase(f, x, Ligne(), "Afficher le médaillon GuildUpSMB",
		function() return ns.BoutonVisible and ns.BoutonVisible() end, function(v)
			if ns.BasculerBouton then ns.BasculerBouton(v) end
		end)

	NouveauTitre(f, x, Ligne(20) - 6, "Mon rôle (annoncé à la guilde)")
	local yMoi1, yMoi2 = Ligne(), Ligne()
	local mesRoles = {
		{ "auto", "Auto (groupe / spécialisation)", x, yMoi1 },
		{ "tank", "Tank", x, yMoi2 },
		{ "heal", "Heal", x + 90, yMoi2 },
		{ "dps", "DPS", x + 180, yMoi2 },
	}
	for _, r in ipairs(mesRoles) do
		local cle = r[1]
		NouvelleCase(f, r[3], r[4], r[2],
			function() return RoleManuel() == cle end, function()
				PoserRoleManuel(cle)
				Annoncer(true)
			end, true)
	end
	local detecte = f:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
	detecte:SetPoint("TOPLEFT", f, "TOPLEFT", x + 4, Ligne(16) - 2)
	table.insert(controles, { maj = function()
		local r = MonRole()
		detecte:SetText("Rôle annoncé : " .. (r and r:upper() or "inconnu (bannière neutre)"))
	end })

	-- Moi : pseudo commun à mes personnages (visible seulement au survol), mes personnages, position
	NouveauTitre(f, x, Ligne(20) - 6, "Moi")
	local yPseudo = Ligne(26)
	local tPseudo = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	tPseudo:SetPoint("TOPLEFT", f, "TOPLEFT", x + 4, yPseudo - 4)
	tPseudo:SetText("Pseudo")
	local pseudo = CreateFrame("EditBox", nil, f, "InputBoxTemplate")
	pseudo:SetSize(110, 18)
	pseudo:SetPoint("LEFT", tPseudo, "RIGHT", 12, 0)
	pseudo:SetAutoFocus(false)
	pseudo:SetMaxLetters(16)
	pseudo:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	pseudo:SetScript("OnEscapePressed", function(self) self:SetText(db.pseudo or ""); self:ClearFocus() end)
	pseudo:SetScript("OnEditFocusLost", function(self)
		local t = strtrim(((self:GetText() or ""):gsub("[~|,\n]", "")))
		db.pseudo = t ~= "" and t or nil
		if ns.AnnoncerIdentite then ns.AnnoncerIdentite() end
	end)
	pseudo:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText("Pseudo")
		GameTooltip:AddLine("Un nom commun à tous tes personnages (par exemple « Miko »).", 1, 1, 1, true)
		GameTooltip:AddLine("La guilde le voit seulement au survol de ton nom : partout ailleurs, ton vrai nom reste affiché (pour le courrier et les messages, qui partent toujours au bon personnage).", 0.7, 0.7, 0.7, true)
		GameTooltip:Show()
	end)
	pseudo:SetScript("OnLeave", function() GameTooltip:Hide() end)
	table.insert(controles, { maj = function() if not pseudo:HasFocus() then pseudo:SetText(db.pseudo or "") end end })
	local persos = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	persos:SetSize(70, 20)
	persos:SetPoint("LEFT", pseudo, "RIGHT", 8, 0)
	persos:SetText("Persos")
	persos:SetScript("OnClick", function(self) if ns.MenuPersos then ns.MenuPersos(self) end end)
	NouvelleCase(f, x, Ligne(), "Partager ma position avec la guilde",
		function() return db.partagePosition end, function()
			if ns.BasculerPartagePosition then ns.BasculerPartagePosition() end
		end, true)

	-- Notifications : une case par type de bulle (deux colonnes)
	NouveauTitre(f, x, Ligne(20) - 6, "Notifications")
	local NOTIFS = {
		{ "groupes", "Groupes" }, { "candidatures", "Candidatures" },
		{ "niveaux", "Niveaux" }, { "metiers", "Métiers" },
		{ "evenements", "Événements" }, { "quetes", "Quêtes" },
		{ "commandes", "Commandes" }, { "plans", "Échanges" },
		{ "version", "Version" }, { "aide", "Aide" },
		{ "gu", (ns.Config and ns.Config.cri) and (tostring(ns.Config.cri):upper() .. "!") or "Cri" },
	}
	local yNotif
	for i, n in ipairs(NOTIFS) do
		local cat = n[1]
		if i % 2 == 1 then yNotif = Ligne() end
		NouvelleCase(f, (i % 2 == 0) and (x + 150) or x, yNotif, n[2],
			function() return not (type(db.notifs) == "table" and db.notifs[cat] == false) end,
			function(v)
				if type(db.notifs) ~= "table" then db.notifs = {} end
				db.notifs[cat] = (not v) and false or nil
			end)
	end

	-- Partie Debug : cachée par défaut, affichée avec /smb debug (pour tester l'addon)
	local hauteurSansDebug = -Ligne(0) + 50
	Ligne(6)
	local dbg = CreateFrame("Frame", nil, f)
	dbg:SetAllPoints(f)
	NouvelleCase(dbg, x, Ligne(), "Debug (tous les joueurs = guilde)",
		function() return db.test end, function(v) db.test = v end)
	NouvelleCase(dbg, x + 20, Ligne(), "Me voir comme un autre membre (test seul)",
		function() return db.testSolo end, function(v)
			db.testSolo = v
			if v and not db.test then Erreur("Coche aussi « Debug » pour activer le test seul") end
			if ns.SurChangementTestSolo then ns.SurChangementTestSolo() end
		end)
	NouvelleCase(dbg, x + 20, Ligne(), "Bannières de groupe sur tout le monde",
		function() return db.testGroupe end, function(v)
			db.testGroupe = v
			if v and not db.test then Erreur("Coche aussi « Debug » pour voir les bannières de groupe") end
		end)

	-- debug : forcer la bannière d'un rôle sur tout le monde (remis en Auto à chaque connexion)
	local etiquette = dbg:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	local yRoles = Ligne(22)
	etiquette:SetPoint("TOPLEFT", dbg, "TOPLEFT", x + 24, yRoles - 6)
	etiquette:SetText("Rôle affiché :")
	local yRoles2 = Ligne()
	local rolesDebug = {
		{ "auto", "Auto", x + 20, yRoles2 },
		{ "tank", "Tank", x + 75, yRoles2 },
		{ "heal", "Heal", x + 130, yRoles2 },
		{ "dps", "DPS", x + 185, yRoles2 },
		{ "horscombat", "Neutre", x + 235, yRoles2 },
	}
	for _, r in ipairs(rolesDebug) do
		local cle = r[1]
		NouvelleCase(dbg, r[3], r[4], r[2],
			function() return db.role == cle end, function()
				db.role = cle
				if cle ~= "auto" and not db.test then Erreur("Coche aussi « Debug » pour le voir sur tout le monde") end
			end, true)
	end

	local hauteurAvecDebug = -Ligne(0) + 50
	table.insert(controles, { maj = function()
		dbg:SetShown(db.afficherDebug and true or false)
		f:SetHeight(db.afficherDebug and hauteurAvecDebug or hauteurSansDebug)
	end })

	local reset = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	reset:SetSize(130, 22)
	reset:SetPoint("BOTTOM", f, "BOTTOM", 0, 14)
	reset:SetText("Réinitialiser")
	reset:SetScript("OnClick", function()
		ReinitialiserReglages()
		Appliquer()
	end)

	f:Hide()
	return f
end

local function BasculerFenetre()
	fenetre = fenetre or ns.AvecSons(CreerFenetre(), "options")
	fenetre:SetShown(not fenetre:IsShown())
end
ns.BasculerOptions = BasculerFenetre -- (fenêtre GuildUpSMB, menu rapide du médaillon)


SLASH_GUILDUP1 = "/smb"
SLASH_GUILDUP2 = "/guildup"
SlashCmdList.GUILDUP = function(msg)
	local cmd, reste = (msg or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")
	if cmd == "on" then
		db.actif = true; Message("activé"); SurActivation()
	elseif cmd == "off" then
		db.actif = false; Message("désactivé"); SurActivation()
	elseif cmd == "plaques" then
		db.plaques = not db.plaques; Message("barres de nom : " .. OuiNon(db.plaques))
	elseif cmd == "cible" then
		db.cible = not db.cible; Message("cadre de cible : " .. OuiNon(db.cible))
	elseif cmd == "cast" then
		db.incantationHaut = not db.incantationHaut
		Message("barre d'incantation au-dessus du nom : " .. OuiNon(db.incantationHaut)
			.. (db.incantationHaut and "" or " (/reload pour la remettre à sa place)"))
	elseif cmd == "metiers" or cmd == "métiers" or cmd == "metier" then
		if ns.BasculerMetiers then ns.BasculerMetiers() end
		return
	elseif cmd == "carnet" or cmd == "liste" or cmd == "craft" then
		if ns.BasculerCourses then ns.BasculerCourses() end
		return
	elseif cmd == "encyclo" or cmd == "encyclopedie" or cmd == "encyclopédie" then
		local fi = ns.FicheCadre and ns.FicheCadre()
		if fi and fi:IsShown() then fi:Hide() elseif ns.OuvrirFiche then ns.OuvrirFiche(nil) end
		return
	elseif cmd == "gu" then
		-- même réglage que la case du cri de guilde dans les notifications du volet
		if type(db.notifs) ~= "table" then db.notifs = {} end
		db.notifs.gu = (db.notifs.gu == false) and nil or false
		db.emoteGU = nil
		Message(db.notifs.gu == false and "emote du cri de guilde coupée." or "emote du cri de guilde activée.")
		return
	elseif cmd == "projets" or cmd == "projet" then
		if ns.OuvrirProjet then ns.OuvrirProjet() end
		return
	elseif cmd == "items" then
		if ns.BasculerArtisanat then ns.BasculerArtisanat(2) end
		return
	elseif cmd == "sos" then
		if ns.DemanderAide then ns.DemanderAide() end
		return
	elseif cmd == "nouveautes" or cmd == "nouveautés" or cmd == "notes" then
		if ns.MontrerNouveautes then ns.MontrerNouveautes() end
		return
	elseif cmd == "echanges" or cmd == "échanges" or cmd == "dons" then
		if ns.BasculerEchanges then ns.BasculerEchanges() end
		return
	elseif cmd == "quetes" or cmd == "quêtes" then
		if ns.BasculerQuetes then ns.BasculerQuetes() end
		return
	elseif cmd == "evenements" or cmd == "événements" or cmd == "events" then
		if ns.BasculerEvenements then ns.BasculerEvenements() end
		return
	elseif cmd == "annonces" then
		db.annoncesGuilde = (db.annoncesGuilde == false)
		Message("annonces de la guilde en bulle (niveaux, métiers) : " .. OuiNon(db.annoncesGuilde))
	elseif cmd == "groupes" or cmd == "groupe" then
		if ns.BasculerGroupes then ns.BasculerGroupes() end
		return
	elseif cmd == "bouton" or cmd == "barre" then
		local visible = ns.BasculerBouton and ns.BasculerBouton()
		Message("médaillon GuildUpSMB : " .. OuiNon(visible))
	elseif cmd == "diag" then
		Diag(); return
	elseif cmd == "debug" then
		db.afficherDebug = not db.afficherDebug or nil
		if not db.afficherDebug then db.test, db.testSolo, db.testGroupe = false, false, false end
		Message("partie Debug de la fenêtre d'options : " .. OuiNon(db.afficherDebug))
		if db.afficherDebug and ns.InstallerEspionRecherche then ns.InstallerEspionRecherche() end
		if fenetre and fenetre:IsShown() then MajFenetre() end
		return
	elseif cmd == "entree" or cmd == "entrée" then
		if not ns.EnregistrerEntree then return end
		local ok, err = ns.EnregistrerEntree(reste)
		Message(ok and ("entrée notée : " .. ok) or (err or "?"))
		return
	elseif cmd == "couleurs" then
		db.couleurs = not db.couleurs; Message("couleurs selon le rôle : " .. OuiNon(db.couleurs))
	elseif cmd == "noms" then
		db.nomsAllies = not db.nomsAllies
		Message("noms et guilde des joueurs alliés toujours affichés : " .. OuiNon(db.nomsAllies))
		SurActivation()
	elseif cmd == "auras" then
		db.aurasSous = not db.aurasSous; Message("améliorations sous la barre : " .. OuiNon(db.aurasSous))
	elseif cmd == "medaillons" or cmd == "médaillons" or cmd == "portraits" then
		db.medaillons = (db.medaillons == false)
		Message("portraits des joueurs sur les bannières : " .. OuiNon(db.medaillons))
	elseif cmd == "reperes" or cmd == "repères" or cmd == "hud" then
		db.reperes = (db.reperes == false)
		Message("membres de ta zone à l'écran : " .. OuiNon(db.reperes))
	elseif cmd == "lueur" then
		db.lueur = not db.lueur; Message("lueur jaune de sélection : " .. OuiNon(db.lueur))
	elseif cmd == "style" then
		if reste ~= "banniere" and reste ~= "degrade" then Message("ex. /smb style banniere"); return end
		db.style = reste; Message("style : " .. reste)
	elseif cmd == "role" then
		if not ETATS[reste] then Message("ex. /smb role tank (ou auto)"); return end
		db.role = reste; Message("rôle : " .. reste)
	elseif cmd == "couleur" then
		local r, g, b = reste:match("^([%d%.]+)%s+([%d%.]+)%s+([%d%.]+)$")
		r, g, b = tonumber(r), tonumber(g), tonumber(b)
		if not (r and g and b) then
			OuvrirSelecteur(); return
		end
		if r > 1 or g > 1 or b > 1 then r, g, b = r / 255, g / 255, b / 255 end
		db.r, db.g, db.b = math.min(r, 1), math.min(g, 1), math.min(b, 1)
		Message(("couleur : %.2f %.2f %.2f"):format(db.r, db.g, db.b))
	elseif cmd == "opacite" or cmd == "opacité" then
		local a = tonumber(reste)
		if not a then Message("ex. /smb opacite 0.8"); return end
		db.a = math.max(0, math.min(a, 1)); Message(("opacité : %.2f"):format(db.a))
	elseif cmd == "reset" then
		ReinitialiserReglages()
		Message("réglages par défaut (tes carnets, dons, besoins et projets sont gardés)")
	else
		if cmd == "" then
			if ns.BasculerInterface then ns.BasculerInterface() else BasculerFenetre() end
		elseif cmd == "options" or cmd == "reglages" or cmd == "réglages" then
			BasculerFenetre()
		else
			Aide()
		end
		return
	end
	ToutRafraichir()
	if fenetre and fenetre:IsShown() then MajFenetre() end
end
