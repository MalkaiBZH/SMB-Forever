-- GuildUpSMB : passer un groupe de la guilde dans la recherche de groupe du jeu.
-- Onglet « Mon groupe » : choix du style de jeu + bouton « Rendre public », qui inscrit le groupe
-- comme la fenêtre « Annonce » du jeu : C_LFGList.CreateListing({ activityIDs, generalPlaystyle,
-- newPlayerFriendly, voiceMode }) (forme relevée sur Forever le 2026-11-10). Il faut un vrai clic.

local NOM_ADDON, ns = ...

local ACTIVITE_PERSO = 1064      -- catégorie « Personnalisé » de Forever
local STYLES = {                 -- Enum.LFGEntryGeneralPlaystyle
	{ 1, "Apprentissage" }, { 2, "Détente" }, { 3, "Sérieux" }, { 4, "Expert" },
}
local function NomStyle(v)
	local g = _G["GROUP_FINDER_GENERAL_PLAYSTYLE" .. tostring(v)]
	if type(g) == "string" and g ~= "" then return g end
	for _, s in ipairs(STYLES) do if s[1] == v then return s[2] end end
	return "?"
end

local Erreur = ns.Erreur
local function DB() return ns.DB and ns.DB() end

local function StyleChoisi()
	local db = DB()
	local v = db and tonumber(db.styleJeu) or 2
	return (v >= 1 and v <= 4) and v or 2
end

local function EstInscrit()
	return C_LFGList and C_LFGList.HasActiveEntryInfo and select(2, pcall(C_LFGList.HasActiveEntryInfo)) == true
end

-- Activité du jeu pour notre annonce : « a<id> » = activité du jeu ; quête = son activité si le jeu
-- en a une ; sinon « Personnalisé »
local function ActiviteDe(code)
	local id = code and tonumber(code:match("^a(%d+)$"))
	if id then return id end
	local q = code and tonumber(code:match("^q(%d+)$"))
	if q and C_LFGList.GetActivityIDForQuestID then
		local ok, a = pcall(C_LFGList.GetActivityIDForQuestID, q)
		if ok and tonumber(a) and a > 0 then return a end
	end
	return ACTIVITE_PERSO
end

local inscritParNous = false     -- l'annonce publique vient de notre bouton

-- commentaire de l'annonce : la zone de texte de la fenêtre « Annonce » du jeu (le jeu la lit)
-- (sur Forever : une zone de texte sans nom, enfant de LFGListingComment, relevé le 2026-11-10)
local function ZoneCommentaire()
	local racine = _G.LFGListingComment
	if not racine then return nil end
	if racine.GetObjectType and racine:GetObjectType() == "EditBox" then return racine end
	if racine.EditBox then return racine.EditBox end
	local function Chercher(f, prof)
		if not f or prof > 3 or not f.GetChildren then return nil end
		for _, c in ipairs({ f:GetChildren() }) do
			if c.GetObjectType and c:GetObjectType() == "EditBox" then return c end
			local z = Chercher(c, prof + 1)
			if z then return z end
		end
	end
	return Chercher(racine, 0)
end

-- le jeu n'accepte le texte libre des annonces que sur un compte avec authentificateur
local function CommentaireAutorise()
	if not C_LFGList then return false end
	if not C_LFGList.IsPlayerAuthenticatedForLFG then return true end
	local ok, oui = pcall(C_LFGList.IsPlayerAuthenticatedForLFG)
	return not ok or oui ~= false
end

local function PoserCommentaire(texte)
	if not CommentaireAutorise() then return false end
	local zone = ZoneCommentaire()
	if zone and zone.SetText then
		pcall(zone.SetText, zone, texte or "")
		return true
	end
end

local function RendrePublic(annonce, nomContenu)
	if not (C_LFGList and C_LFGList.CreateListing) then Erreur("Recherche de groupe du jeu indisponible"); return end
	if InCombatLockdown() then Erreur("Impossible en combat"); return end
	if IsInGroup() and not UnitIsGroupLeader("player") then Erreur("Seul le chef du groupe peut inscrire le groupe"); return end
	local activite = ActiviteDe(annonce.code)
	local style = StyleChoisi()
	local com = annonce.commentaire ~= "" and annonce.commentaire or (nomContenu or "")
	local pose = PoserCommentaire(("[%s] %s"):format(NomStyle(style), com))
	if ns.NoterAppelRecherche then
		ns.NoterAppelRecherche(("GuildUpSMB : bouton Rendre public (commentaire posé=%s)"):format(tostring(pose == true)))
	end
	local ok, err = pcall(C_LFGList.CreateListing, {
		activityIDs = { activite },
		generalPlaystyle = style,
		newPlayerFriendly = style == 1,
		voiceMode = 0,
	})
	-- la zone de texte de la fenêtre « Annonce » du jeu ne garde pas notre commentaire pour une
	-- annonce faite ensuite à la main (le jeu l'a lu au moment de l'inscription)
	if pose then PoserCommentaire("") end
	if not ok then
		Erreur("Le jeu a refusé l'inscription : " .. tostring(err))
		return
	end
	inscritParNous = true
	if ns.Notifier then
		ns.Notifier("groupes", "Groupe public", ("Inscrit à la recherche du jeu (%s)"):format(NomStyle(style)))
	end
end

--------------------------------------------------------------------------------
-- Texture de l'anneau qui tourne autour du médaillon GuildUpSMB : la première qui existe
--------------------------------------------------------------------------------

local ANNEAUX = {
	{ atlas = "groupfinder-eye-highlight", taille = 46 },
	{ atlas = "GarrLanding-CircleGlow", taille = 50 },
	{ atlas = "ChallengeMode-Runes-CircleGlow", taille = 50 },
	{ atlas = "Artifacts-PerkRing-WhiteGlow", taille = 48 },
	{ atlas = "worldquest-tracker-ring-selected", taille = 46 },
	{ fichier = "Interface\\Cooldown\\star4", taille = 46 },
}
local AtlasExiste = ns.AtlasExiste
ns.TextureAnneau = function()
	for _, a in ipairs(ANNEAUX) do
		if a.fichier or AtlasExiste(a.atlas) then return a end
	end
end

-- Retire l'annonce publique (bouton, ou annonce de guilde retirée / groupe complet)
ns.RetirerPublic = function(force)
	if not (force or inscritParNous) then return end
	inscritParNous = false
	if EstInscrit() and C_LFGList.RemoveListing then pcall(C_LFGList.RemoveListing) end
end

--------------------------------------------------------------------------------
-- Contrôles de l'onglet « Mon groupe » (page Groupes) : [Style : Détente ▾] [Rendre public]
--------------------------------------------------------------------------------

ns.CreerBoutonsPublic = function(parent)
	local UI = ns.UI
	local c = {}

	-- choix du style de jeu (liste sombre du kit d'interface)
	local options = {}
	for _, s in ipairs(STYLES) do options[#options + 1] = { s[1], "Style : " .. NomStyle(s[1]) } end
	local style = UI.Choix(parent, 160, options, function(v)
		local db = DB()
		if db then db.styleJeu = v end
		if c.maj then c.maj() end
	end)
	c.style = style
	UI.Infobulle(style, "Style de jeu", "Affiché dans la recherche de groupe du jeu quand le groupe est public.")

	-- rendre public / retirer du public
	local public = UI.Bouton(parent, "Rendre public", "fantome", 160, 28)
	c.public = public
	public:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		if EstInscrit() then
			GameTooltip:SetText("Retirer du public")
			GameTooltip:AddLine("Retire le groupe de la recherche de groupe du jeu. L'annonce de guilde reste.", 1, 1, 1, true)
		else
			GameTooltip:SetText("Rendre public")
			GameTooltip:AddLine("Inscrit aussi le groupe dans la recherche de groupe du jeu : les joueurs hors guilde peuvent le trouver.", 1, 1, 1, true)
			if not CommentaireAutorise() then
				GameTooltip:AddLine("Sans authentificateur sur ton compte, le jeu n'affiche pas le commentaire (donjon et style seulement).", 1, 0.5, 0.3, true)
			end
		end
		GameTooltip:Show()
	end)
	public:SetScript("OnLeave", function() GameTooltip:Hide() end)

	c.maj = function(annonce, nomContenu)
		if annonce then c.annonce, c.nomContenu = annonce, nomContenu end
		style:Poser(StyleChoisi())
		local inscrit = EstInscrit()
		public:Ecrire(inscrit and "Retirer du public" or "Rendre public")
		style:SetEnabled(not inscrit)
		style:SetAlpha(inscrit and 0.45 or 1)
	end
	public:SetScript("OnClick", function()
		if EstInscrit() then
			ns.RetirerPublic(true)
		elseif c.annonce then
			RendrePublic(c.annonce, c.nomContenu)
		end
		C_Timer.After(0.5, function() c.maj() end)
	end)
	ns.majBoutonsPublic = c.maj
	return c
end

--------------------------------------------------------------------------------
-- Évènements : état de l'annonce, candidatures venues du public
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "LFG_LIST_ACTIVE_ENTRY_UPDATE", "LFG_LIST_APPLICANT_LIST_UPDATED" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local dernierNombre = 0
ev:SetScript("OnEvent", function(_, event)
	if event == "LFG_LIST_ACTIVE_ENTRY_UPDATE" then
		if not EstInscrit() then inscritParNous = false end
		if ns.majBoutonsPublic then ns.majBoutonsPublic() end
		if ns.MajBouton then ns.MajBouton() end -- anneau vert du médaillon GuildUpSMB
	elseif event == "LFG_LIST_APPLICANT_LIST_UPDATED" then
		local ok, n = pcall(C_LFGList.GetNumApplicants)
		n = ok and tonumber(n) or 0
		if n > dernierNombre and ns.Notifier then
			ns.Notifier("candidatures", "Candidature publique", "Un joueur hors guilde veut rejoindre ton groupe", nil, function()
				if LFGParentFrame and not LFGParentFrame:IsShown() and ToggleLFGParentFrame then
					pcall(ToggleLFGParentFrame)
				elseif LFGParentFrame then
					pcall(ShowUIPanel, LFGParentFrame)
				end
			end)
		end
		dernierNombre = n
	end
end)

local function Champs(t)
	if type(t) ~= "table" then return tostring(t) end
	local cles = {}
	for k, v in pairs(t) do
		local s = type(v) == "table" and "{…}" or tostring(v)
		if #s > 30 then s = s:sub(1, 30) .. "…" end
		cles[#cles + 1] = tostring(k) .. "=" .. s
	end
	table.sort(cles)
	return table.concat(cles, ", ")
end

local function Appel(f, ...)
	if not f then return nil end
	local r = { pcall(f, ...) }
	if not r[1] then return nil, tostring(r[2]) end
	return select(2, unpack(r))
end

-- Appels relevés de la recherche de groupe du jeu (pour /smb diag) ; l'espion qui les relève
-- (hooks sur C_LFGList) n'est installé qu'en mode Debug, par GuildUp_Diag.lua
local appels = {}
ns.NoterAppelRecherche = function(t)
	appels[#appels + 1] = t
	if #appels > 12 then table.remove(appels, 1) end
end

ns.DiagRecherche = function(L)
	local T = C_LFGList
	if type(T) ~= "table" then
		L("recherche du jeu : C_LFGList absent")
		return
	end
	-- fonctions disponibles
	local noms = {}
	for k, v in pairs(T) do if type(v) == "function" then noms[#noms + 1] = k end end
	table.sort(noms)
	L(("recherche : C_LFGList (%d fonctions) : %s"):format(#noms, table.concat(noms, " ")))

	-- fenêtres du jeu
	local fen = {}
	for _, n in ipairs({ "LFGListFrame", "PVEFrame", "LFGParentFrame", "LFGListingFrame", "LFGBrowseFrame",
		"GroupFinderFrame", "LFGFrame" }) do
		if _G[n] then fen[#fen + 1] = n end
	end
	L("recherche : fenêtres = " .. (#fen > 0 and table.concat(fen, " ") or "aucune"))

	-- styles de jeu
	for _, e in ipairs({ "LFGEntryPlaystyle", "LFGEntryGeneralPlaystyle", "LFGListDisplayType" }) do
		if Enum and Enum[e] then L("recherche : Enum." .. e .. " = " .. Champs(Enum[e])) end
	end
	if T.GetPlaystyleString then L("recherche : GetPlaystyleString existe") end

	-- catégories et activités
	local cats = { Appel(T.GetAvailableCategories) }
	if type(cats[1]) == "table" then cats = cats[1] end
	L(("recherche : %d catégorie(s)"):format(#cats))
	for _, c in ipairs(cats) do
		local info = Appel(T.GetLfgCategoryInfo, c)
		local nomC = type(info) == "table" and info.name or tostring((Appel(T.GetCategoryInfo, c)))
		local acts = Appel(T.GetAvailableActivities, c)
		acts = type(acts) == "table" and acts or {}
		local liste = {}
		for i, a in ipairs(acts) do
			local ai = Appel(T.GetActivityInfoTable, a)
			if type(ai) == "table" then
				liste[#liste + 1] = ("%d:%s(%s-%s,%s)"):format(a, tostring(ai.fullName or ai.shortName),
					tostring(ai.minLevel or ai.minLevelSuggestion or "?"), tostring(ai.maxLevel or ai.maxLevelSuggestion or "?"),
					tostring(ai.maxNumPlayers or "?"))
			else
				liste[#liste + 1] = tostring(a)
			end
		end
		L(("recherche : cat %s « %s » [%s] : %d activité(s) : %s"):format(tostring(c), tostring(nomC),
			type(info) == "table" and Champs(info) or "", #acts, table.concat(liste, " ; ")))
	end
	-- champs d'une activité (pour connaître le format exact)
	if cats[1] then
		local acts = Appel(T.GetAvailableActivities, cats[1])
		if type(acts) == "table" and acts[1] then
			L("recherche : exemple d'activité = " .. Champs((Appel(T.GetActivityInfoTable, acts[1]))))
		end
	end

	-- annonce en cours (si le groupe est déjà inscrit)
	local actif = Appel(T.HasActiveEntryInfo)
	L("recherche : annonce active = " .. tostring(actif) .. ", authentifié pour le texte = " .. tostring((Appel(T.IsPlayerAuthenticatedForLFG))))
	if actif then L("recherche : annonce = " .. (ns.DecrireAppel or tostring)((Appel(T.GetActiveEntryInfo)))) end
	-- animations 2D de la recherche de groupe (œil, anneaux)
	local vfx = {}
	for _, n in ipairs({ "groupfinder-eye-frame", "groupfinder-eye-highlight", "groupfinder-eye-flipbook-searching",
		"groupfinder-eye-flipbook-initial", "groupfinder-eye-flipbook-foundfx", "groupfinder-eye-flipbook-mouseover",
		"groupfinder-eye-flipbook-poke-initial", "groupfinder-eye-single", "GarrLanding-CircleGlow",
		"ChallengeMode-Runes-CircleGlow", "Artifacts-PerkRing-WhiteGlow", "worldquest-tracker-ring-selected" }) do
		vfx[#vfx + 1] = n .. "=" .. tostring(AtlasExiste(n))
	end
	L("recherche : vfx = " .. table.concat(vfx, ", "))
	local a = ns.TextureAnneau()
	L("recherche : anneau du bouton = " .. tostring(a and (a.atlas or a.fichier)) ..
		", œil du jeu = " .. tostring(_G.MiniMapLFGFrame ~= nil or _G.QueueStatusButton ~= nil or _G.LFGMinimapFrame ~= nil))
	-- appels relevés depuis le dernier /reload
	if #appels == 0 then
		L("recherche : aucun appel relevé (inscris un groupe à la main avec la fenêtre du jeu, puis refais /smb diag)")
	end
	for _, a in ipairs(appels) do L("recherche : appel " .. a) end
	-- zones de texte de la fenêtre « Annonce » (titre / commentaire)
	local zones = {}
	local function Fouiller(f, chemin, prof)
		if not f or prof > 4 or not f.GetChildren then return end
		for _, c in ipairs({ f:GetChildren() }) do
			local n = c.GetName and c:GetName() or nil
			if c.GetObjectType and c:GetObjectType() == "EditBox" then
				zones[#zones + 1] = (n or (chemin .. ".?")) .. "=\"" .. tostring(c:GetText()) .. "\""
			end
			Fouiller(c, n or chemin, prof + 1)
		end
	end
	pcall(Fouiller, LFGListingFrame, "LFGListingFrame", 0)
	L("recherche : zones de texte de l'annonce = " .. (#zones > 0 and table.concat(zones, " ; ") or "aucune"))
end
