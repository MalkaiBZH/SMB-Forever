-- GuildUpSMB : vérification de version.
-- Chaque GuildUpSMB annonce sa version à la guilde à la connexion ("V~1.3.0", préfixe "GuildUpVer").
-- Si un membre a une version plus récente, une bulle propose de mettre l'addon à jour (CurseForge).
-- Si un membre a une version plus ancienne, on lui renvoie la nôtre pour qu'il soit prévenu.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpVer"

local function LireVersion()
	local f = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
	if not f then return "0" end
	local ok, v = pcall(f, NOM_ADDON, "Version")
	return (ok and v) or "0"
end

local MA_VERSION = LireVersion()
ns.Version = MA_VERSION

-- -1 si a < b, 0 si égales, 1 si a > b (compare 1.10.0 et 1.9.2 correctement)
local function Comparer(a, b)
	local ta, tb = {}, {}
	for n in tostring(a):gmatch("%d+") do ta[#ta + 1] = tonumber(n) end
	for n in tostring(b):gmatch("%d+") do tb[#tb + 1] = tonumber(n) end
	for i = 1, math.max(#ta, #tb) do
		local x, y = ta[i] or 0, tb[i] or 0
		if x ~= y then return x < y and -1 or 1 end
	end
	return 0
end

local NomCourt = ns.NomCourt

local versions = {}       -- [nom normalisé] = { nom, v }
local plusRecenteVue      -- plus haute version déjà signalée (une seule bulle par version)
local dernierEnvoi = 0

-- version de développement (« 1.6.0-dev » dans le .toc) : on n'annonce rien à la guilde, pour ne pas
-- lui proposer une mise à jour qui n'est pas encore sur CurseForge (on reçoit toujours les leurs)
local DEV = MA_VERSION:find("dev", 1, true) ~= nil
local function Annoncer()
	if DEV then return end
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, "V~" .. MA_VERSION, "GUILD") end
	dernierEnvoi = GetTime()
end

local derniereAnnonceVue = 0 -- un membre a annoncé une version au moins égale à la mienne
local reponsePrevue = false

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local v = msg:match("^V~(.+)$")
	if not v then return end
	local cle = ns.Normaliser and ns.Normaliser(expediteur) or expediteur
	local moi = ns.Normaliser and ns.Normaliser(UnitName("player")) or UnitName("player")
	if cle == moi then return end
	versions[cle] = { nom = expediteur, v = v }
	local c = Comparer(v, MA_VERSION)
	if c >= 0 then derniereAnnonceVue = GetTime() end
	if c > 0 then
		if not plusRecenteVue or Comparer(v, plusRecenteVue) > 0 then
			plusRecenteVue = v
			if ns.Notifier then
				ns.Notifier("version", "Nouvelle version de GuildUpSMB",
					("%s a la %s (toi : %s) — mets à jour via CurseForge"):format(NomCourt(expediteur), v, MA_VERSION),
					nil, function() end)
			end
		end
	elseif c < 0 and GetTime() - dernierEnvoi > 60 and not reponsePrevue then
		-- il est en retard : on lui renvoie notre version (au plus une fois par minute), sauf si un
		-- autre membre à jour l'a fait pendant notre petit délai au hasard
		reponsePrevue = true
		dernierEnvoi = GetTime()
		local prevue = GetTime()
		C_Timer.After(2 + math.random() * 5, function()
			reponsePrevue = false
			if derniereAnnonceVue < prevue then Annoncer() end
		end)
	end
end

--------------------------------------------------------------------------------
-- Fenêtre « Nouveautés » : s'ouvre une fois à la première connexion après une mise à jour
-- (/smb nouveautes pour la rouvrir)
--------------------------------------------------------------------------------

local NOM_PUBLIC = (ns.Config and ns.Config.nomPublic) or "GuildUpSMB" -- GuildUp_Config.lua
-- De la plus récente à la plus ancienne
local ORDRE = { "2.4.0", "2.3.1", "2.3.0", "2.2.0", "2.1.1", "2.1.0", "2.0.1", "2.0.0", "1.6.0", "1.5.1", "1.5.0", "1.4.0", "1.3.0" }
local NOTES = {
	["2.4.0"] = {
		"|cffffd100Artisanat|r dans la fenêtre SMB Forever, au nouveau style : Registre (qui sait fabriquer quoi, commandes), Items (catégories et sous-catégories, Besoin, Ajouter à une liste ou un projet) et Projets de guilde (tâches « Je m'en occupe »).",
		"|cffffd100Mes carnets|r dans la fenêtre : tes listes à gauche, la liste de courses à droite (matériaux, recettes, quantités). L'encyclopédie et la mini-liste passent aux nouvelles couleurs ; l'encyclopédie se colle à droite de la fenêtre.",
		"Toutes les fenêtres de GuildUpSMB sont maintenant réunies dans la fenêtre SMB Forever.",
	},
	["2.3.1"] = {
		"La fenêtre GuildUpSMB s'appelle désormais |cffffd100SMB Forever|r, suivi de la version de l'addon.",
	},
	["2.3.0"] = {
		"|cffffd100Dons|r dans la fenêtre GuildUpSMB, au nouveau style : Dons (catégories, recherche, Demander puis Merci !), Mes dons (glisser un objet pour le donner), Demandes reçues et Besoins (les tiens et ceux de la guilde, avec « tu sais le fabriquer »).",
		"Son de clic sur tous les boutons de la fenêtre GuildUpSMB.",
	},
	["2.2.0"] = {
		"|cffffd100Options|r dans la fenêtre GuildUpSMB, au nouveau style : Affichage (avec un curseur pour la taille de la fenêtre), Moi (pseudo, personnages, position, rôle), Notifications.",
	},
	["2.1.1"] = {
		"Fenêtre GuildUpSMB plus lisible : textes des boutons, filtres et champs plus grands, fenêtre un peu plus grande. |cffffd100/smb taille 1.2|r pour l'ajuster (de 0.7 à 1.6).",
	},
	["2.1.0"] = {
		"|cffffd100Groupes|r dans la fenêtre GuildUpSMB, au nouveau style : filtres (Donjons, Raids, Quêtes…) et recherche, portrait du chef, places par rôle, rôle recherché. « Mon groupe » : choix du contenu, places, commentaire et rappel sur un seul écran ; gestion des candidats et groupe public à côté de la composition.",
		"|cffffd100Quêtes en commun|r : leur propre page dans la fenêtre GuildUpSMB.",
	},
	["2.0.1"] = {
		"|cffffd100Repères à l'écran|r : toujours sur le tour de l'écran (les positions n'ont pas d'altitude) : en haut pour les membres devant toi, sur les côtés à gauche et à droite, en bas pour ceux qui sont derrière.",
	},
	["2.0.0"] = {
		"|cffffd100Nouvelle interface|r : le bouton de la mini-carte devient un médaillon à placer où tu veux (anneau à la couleur de ton rôle, pastille des nouveautés). Clic : la fenêtre GuildUpSMB et son accueil, qui résume la guilde (membres de ta zone, groupes ouverts, appels à l'aide, demandes de dons, besoins que tu sais fabriquer, projets). Clic droit : menu rapide (rôle, position, groupes, à l'aide).",
		"|cffffd100Repères à l'écran|r : les membres de la guilde sur ta carte apparaissent dans le HUD, avec leur portrait et leur distance, au-dessus de leur tête ou dans leur direction (/smb reperes).",
		"|cffffd100Portraits|r : le portrait de chaque membre (race, classe, sexe) s'affiche à côté de son nom ; les bannières horizontales disparaissent.",
		"Barres de nom : leur taille suit de nouveau le jeu, les noms des autres joueurs ne grossissent plus d'un coup.",
		"Carte : le point des membres est plus visible, et visible aussi hors groupe.",
		"Noms des objets en anglais sur un client anglais ; emote du cri de guilde : une chope en bois animée.",
		"Pseudo, personnages, partage de position et choix des notifications : dans les options (/smb options).",
	},
	["1.6.0"] = {
		"|cffffd100Carnet de craft|r : tes listes de courses. Choisis des objets, GuildUpSMB calcule tous les composants (sous-recettes comprises) et ce qu'il te manque d'après tes sacs et ta banque. Réduit, il ne laisse à l'écran que la liste des composants, mise à jour en direct.",
		"|cffffd100Encyclopédie|r : d'où vient chaque objet (marchands, butin classé par zone avec les élites, récolte, quêtes), zones et marchands sur la carte du monde, modèle 3D des monstres, formules et recettes, « Utilisé dans ». |cffffd100Alt + clic|r sur n'importe quel objet du jeu pour l'ouvrir.",
		"|cffffd100Items|r (Artisanat) : tous les objets fabricables, rangés comme à l'hôtel des ventes (catégories, sous-catégories, tri par niveau d'objet).",
		"|cffffd100Projets de guilde|r : des listes partagées avec toute la guilde ; chacun coche « Je m'en occupe » sur ce qu'il sait faire, et son nom s'affiche.",
		"|cffffd100Pseudo et personnages|r : un pseudo commun et ton personnage principal, visibles au survol de ton nom (le vrai nom reste partout ailleurs).",
		"|cffffd100À l'aide !|r (/smb sos), |cffffd100Merci !|r et les donateurs du mois, et un récapitulatif à la connexion de ce qui s'est passé pendant ton absence.",
		"Menu de la mini-carte réorganisé (Groupes, Artisanat, Mes carnets, Dons…) ; notifications repliables.",
	},
	["1.5.1"] = {
		"|cffffd100Besoins|r : cherche n'importe quel objet du jeu par son nom (les ingrédients en premier), même sans l'avoir sur toi.",
		"|cffffd100Demandes|r : nouvel onglet avec l'historique de qui t'a demandé un don (gardé 30 jours). On peut aussi demander un don à un joueur hors ligne : la demande lui est transmise dès que possible.",
		"|cffffd100Listes à jour|r : les dons et besoins des absents te sont renvoyés par les membres connectés.",
		"|cffffd100Nouveautés|r : cette fenêtre, à chaque mise à jour (/smb nouveautes pour la revoir).",
		"Échap ferme le menu de la mini-carte ; le Maj-clic sur un objet sert de nouveau à diviser une pile.",
		"Correctifs : icône du bouton de mini-carte quand le rôle est inconnu, compatibilité avec les addons de mini-carte.",
	},
	["1.5.0"] = {
		"|cffffd100Artisanat et dons|r : une seule fenêtre avec le Registre, les Dons (un hôtel des ventes gratuit), Mes dons, les Demandes et les Besoins.",
		"|cffffd100Besoins|r : liste les objets que tu cherches, visibles par la guilde même hors ligne ; option « sans limite ».",
		"|cffffd100Infobulles|r : les objets indiquent quels membres de la guilde en ont besoin.",
		"|cffffd100Recettes spéciales|r : filtre du registre pour ne voir que les recettes apprises avec un plan.",
		"|cffffd100Groupes et quêtes|r côte à côte ; « Rendre public » inscrit ton groupe dans la recherche du jeu ; rappel facultatif toutes les 5 min.",
		"|cffffd100Commandes|r : un message privé part automatiquement vers l'artisan.",
		"|cffffd100Mini-carte|r : halo doré = des groupes sont ouverts, anneau vert = tu es en attente. Sur la carte, les membres sont de petits points de couleur.",
	},
	["1.4.0"] = {
		"|cffffd100Recherche de groupe|r : chaque place a son cadre, un repère sur la carte montre l'entrée des donjons et raids (dont les 9 donjons de Forever), et seuls les contenus de ton niveau s'affichent (« Voir tous les niveaux » pour tout voir).",
		"|cffffd100Quêtes en commun|r : style parchemin, niveau des quêtes et bouton « Créer un groupe » ; les membres qui ont la quête sont prévenus.",
		"|cffffd100Métiers|r : style des métiers du jeu et onglet « Dons de plans » ; ceux qui ont le métier au bon niveau sont prévenus en premier.",
		"|cffffd100Événements|r : passent par le calendrier du jeu, avec une notification à chaque nouvel événement de guilde.",
		"Les notifications s'affichent toujours au-dessus des fenêtres ouvertes.",
	},
	["1.3.0"] = {
		"|cffffd100Bouton de mini-carte|r : choix du rôle, accès à toutes les fenêtres, partage de position, bannières et notifications.",
		"|cffffd100Recherche de groupe|r : places Tank / Heal / DPS, groupes perso jusqu'à 40 joueurs (passage en raid automatique).",
		"|cffffd100Carte de la guilde|r : les membres sur la carte du monde.",
		"|cffffd100Registre des métiers|r et |cffffd100commandes d'artisanat|r : qui sait fabriquer quoi, et commande en un clic.",
		"|cffffd100Quêtes en commun|r, |cffffd100annonces|r (montées de niveau avec sonnette) et |cffffd100vérification de version|r.",
		"Bannières allégées en groupe, lueur dorée sur ta cible, nom + guilde pour les autres joueurs, notifications en bulles au lieu du chat.",
	},
}

local fenNotes
local function MontrerNouveautes(version)
	version = version or MA_VERSION
	if not NOTES[version] then version = ORDRE[1] end
	if not fenNotes then
		local f = ns.FenetreDeplacable("GuildUpNouveautes", 470, 440)
		f:ClearAllPoints()
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
		f:SetToplevel(true)
		local barre = f.TitleText or f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		if not f.TitleText then barre:SetPoint("TOP", f, "TOP", 0, -6) end
		barre:SetText("Nouveautés")
		f.entete = f:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
		f.entete:SetPoint("TOP", f, "TOP", 0, -36)
		f.entete:SetTextColor(1, 0.82, 0)
		f.sous = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		f.sous:SetPoint("TOP", f.entete, "BOTTOM", 0, -4)
		f.sous:SetText("Mettez à jour votre addon")
		f.sous:SetTextColor(0.8, 0.8, 0.8)
		-- notes de toutes les versions, la plus récente en haut (défilement)
		local defile = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		defile:SetPoint("TOPLEFT", f, "TOPLEFT", 16, -86)
		defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -34, 46)
		local contenu = CreateFrame("Frame", nil, defile)
		contenu:SetSize(410, 10)
		defile:SetScrollChild(contenu)
		f.defile, f.contenu = defile, contenu
		f.blocs = {}
		f.ok = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
		f.ok:SetSize(110, 24)
		f.ok:SetPoint("BOTTOM", f, "BOTTOM", 0, 12)
		f.ok:SetText("Super !")
		f.ok:SetScript("OnClick", function() f:Hide() end)
		if ns.AvecSons then ns.AvecSons(f, "fenetre") end
		fenNotes = f
	end
	local f = fenNotes
	f.entete:SetText(("%s %s est sortie !"):format(NOM_PUBLIC, version))
	local y = 0
	local n = 0
	for _, v in ipairs(ORDRE) do
		if Comparer(v, version) <= 0 and NOTES[v] then
			n = n + 1
			local b = f.blocs[n]
			if not b then
				b = {}
				b.titre = f.contenu:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
				b.texte = f.contenu:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				b.texte:SetWidth(400)
				b.texte:SetJustifyH("LEFT")
				b.texte:SetSpacing(3)
				f.blocs[n] = b
			end
			b.titre:ClearAllPoints()
			b.titre:SetPoint("TOPLEFT", f.contenu, "TOPLEFT", 4, -y)
			b.titre:SetText(v == version and ("Version " .. v) or ("|cffaaaaaaVersion " .. v .. "|r"))
			b.texte:ClearAllPoints()
			b.texte:SetPoint("TOPLEFT", b.titre, "BOTTOMLEFT", 0, -6)
			local lignes = {}
			for _, l in ipairs(NOTES[v]) do lignes[#lignes + 1] = "• " .. l end
			b.texte:SetText(table.concat(lignes, "\n"))
			-- les anciennes versions un peu plus discrètes
			if v == version then b.texte:SetAlpha(1) else b.texte:SetAlpha(0.75) end
			b.titre:Show()
			b.texte:Show()
			y = y + b.titre:GetStringHeight() + 6 + b.texte:GetStringHeight() + 18
		end
	end
	for i = n + 1, #f.blocs do f.blocs[i].titre:Hide(); f.blocs[i].texte:Hide() end
	f.contenu:SetHeight(math.max(10, y))
	f.defile:SetVerticalScroll(0)
	f:Show()
end
ns.MontrerNouveautes = MontrerNouveautes

-- Première connexion avec une nouvelle version : la fenêtre s'ouvre une fois
local function VerifierNouveautes()
	local db = ns.DB and ns.DB()
	if not db then return end
	if db.versionVue ~= MA_VERSION then
		local avant = db.versionVue
		db.versionVue = MA_VERSION
		if NOTES[MA_VERSION] and (not avant or Comparer(avant, MA_VERSION) < 0) then MontrerNouveautes(MA_VERSION) end
	end
end

-- Pour /smb diag
ns.DiagVersion = function(L)
	local n, plusAncienne, plusRecente = 0, 0, 0
	for _, e in pairs(versions) do
		n = n + 1
		local c = Comparer(e.v, MA_VERSION)
		if c < 0 then plusAncienne = plusAncienne + 1 elseif c > 0 then plusRecente = plusRecente + 1 end
	end
	L(("version : %s ; %d membre(s) avec GuildUpSMB vus (%d plus ancienne(s), %d plus récente(s))"):format(
		MA_VERSION, n, plusAncienne, plusRecente))
end

ns.Ecouter(PREFIXE, Recevoir)

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
local premiere = true
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if premiere then
		premiere = false
		C_Timer.After(12, Annoncer)
		C_Timer.After(6, VerifierNouveautes)
	end
end)
