-- GuildUpSMB : vérification de version.
-- Chaque GuildUpSMB annonce sa version à la guilde à la connexion ("V~1.3.0", préfixe "GuildUpVer").
-- Si un membre a une version plus récente, une bulle propose de mettre l'addon à jour avec le
-- programme SMB Forever Updater (outils/MiseAJour, voir le README).
-- Si un membre a une version plus ancienne, on lui renvoie la nôtre pour qu'il soit prévenu.
-- Présence : à chaque annonce « V » d'un membre qui arrive, les autres répondent « R~version » après
-- un petit délai au hasard (une seule réponse pour plusieurs arrivées rapprochées). Le nouveau venu
-- sait ainsi tout de suite qui a SMB Forever (en-tête de la fenêtre, page Guilde). « R » ne déclenche
-- aucune réponse ; les versions d'avant 2.13.1 l'ignorent.
-- Fenêtre « Nouveautés » (ns.MontrerNouveautes, /smb nouveautes) : notes de chaque version, au style
-- sombre et doré du kit ns.UI ; elle s'ouvre seule une fois après une mise à jour.

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
ns.ComparerVersions = Comparer -- (page Guilde : versions en retard)

local NomCourt = ns.NomCourt

local versions = {}       -- [nom normalisé] = { nom, v } : annonces reçues pendant la session
-- Dernière version vue de chaque membre, gardée d'une session à l'autre (GuildUpDB.versionsVues[clé] =
-- { v = version, t = date }), oubliée après 60 jours sans nouvelle
local OUBLI_VERSION = 60 * 86400
local function VersionsVues()
	local db = ns.DB and ns.DB()
	if not db then return nil end
	if type(db.versionsVues) ~= "table" then db.versionsVues = {} end
	return db.versionsVues
end
-- version de l'addon d'un membre, pour la page Guilde (GuildUp_Membres.lua) :
--   version, date où on l'a vue (time()), true si annoncée pendant cette session
ns.VersionMembre = function(cle)
	if not cle then return nil end
	local e = versions[cle]
	local vues = VersionsVues()
	local g = vues and vues[cle]
	if e then return e.v, type(g) == "table" and g.t or time(), true end
	if type(g) == "table" and type(g.v) == "string" then
		if type(g.t) ~= "number" or time() - g.t > OUBLI_VERSION then vues[cle] = nil; return nil end
		return g.v, g.t, false
	end
	return nil
end
local plusRecenteVue      -- plus haute version déjà signalée (une seule bulle par version)
local dernierEnvoi = 0

-- version de développement (« 1.6.0-dev » dans le .toc) : on n'annonce rien à la guilde, pour ne pas
-- lui proposer une mise à jour qui n'est pas encore publiée (on reçoit toujours les leurs)
local DEV = MA_VERSION:find("dev", 1, true) ~= nil
local function Annoncer()
	if DEV then return end
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, "V~" .. MA_VERSION, "GUILD") end
	dernierEnvoi = GetTime()
end

-- Réponse de présence à l'annonce d'un membre qui arrive : « R~version », 1 à 7 s plus tard (les
-- réponses de la guilde s'étalent) ; une seule pour plusieurs annonces pendant ce délai
local presencePrevue = false
local function RepondrePresence()
	if DEV or presencePrevue or not ns.EnvoyerAddon then return end
	presencePrevue = true
	C_Timer.After(1 + math.random() * 6, function()
		presencePrevue = false
		ns.EnvoyerAddon(PREFIXE, "R~" .. MA_VERSION, "GUILD")
	end)
end

local derniereAnnonceVue = 0 -- un membre a annoncé une version au moins égale à la mienne
local reponsePrevue = false

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local sorte, v = msg:match("^([VR])~([^~]+)$")
	if not v then return end
	local cle = ns.Normaliser and ns.Normaliser(expediteur) or expediteur
	local moi = ns.Normaliser and ns.Normaliser(UnitName("player")) or UnitName("player")
	if cle == moi then return end
	v = v:gsub("[^%w%.%-]", ""):sub(1, 16) -- texte venu du réseau : chiffres, points et tirets
	if v == "" then return end
	versions[cle] = { nom = expediteur, v = v }
	local vues = VersionsVues()
	if vues then vues[cle] = { v = v, t = time() } end
	if sorte == "V" then RepondrePresence() end
	local c = Comparer(v, MA_VERSION)
	if c >= 0 then derniereAnnonceVue = GetTime() end
	if c > 0 then
		if not plusRecenteVue or Comparer(v, plusRecenteVue) > 0 then
			plusRecenteVue = v
			if ns.Notifier then
				ns.Notifier("version", "Nouvelle version de SMB Forever",
					("%s a la %s (toi : %s) — mets à jour avec |cffffd100SMB Forever Updater|r"):format(NomCourt(expediteur), v, MA_VERSION),
					nil, function() end)
			end
		end
	elseif sorte == "V" and c < 0 and GetTime() - dernierEnvoi > 60 and not reponsePrevue then
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

local NOM_PUBLIC = (ns.Config and ns.Config.nomPublic) or "SMB Forever" -- GuildUp_Config.lua
-- De la plus récente à la plus ancienne
local ORDRE = { "2.14.1", "2.14.0", "2.13.1", "2.13.0", "2.12.0", "2.11.0", "2.10.0", "2.9.0", "2.8.0", "2.7.0", "2.6.2", "2.6.1", "2.6.0", "2.5.1", "2.5.0", "2.4.1", "2.4.0", "2.3.1", "2.3.0", "2.2.0", "2.1.1", "2.1.0", "2.0.1", "2.0.0", "1.6.0", "1.5.1", "1.5.0", "1.4.0", "1.3.0" }
local NOTES = {
	["2.14.1"] = {
		"Les portraits disparaissent des barres de nom pendant le combat (le tien ou celui du membre) et reviennent à la sortie.",
	},
	["2.14.0"] = {
		"|cffffd100Guilde|r : la version de SMB Forever de chaque membre, en vert s'il est à jour, en bleu s'il est en retard, en or s'il est en avance. La dernière version vue reste affichée quand il est hors ligne (sa date est dans l'infobulle). Nouveau tri « Par version », et la recherche trouve une version (« 2.12 »).",
	},
	["2.13.1"] = {
		"Le nombre de membres « en ligne avec l'addon » est juste dès ta connexion : les membres présents se signalent à ton arrivée, et un membre silencieux n'est plus oublié au bout de 10 minutes.",
	},
	["2.13.0"] = {
		"|cffffd100Groupes programmés|r : « Mortemines à 21:00 » ; on s'inscrit à l'avance, rappel 10 min avant, « Inviter tous les inscrits » à l'heure. Ils apparaissent aussi sur l'accueil avec leur heure de départ.",
	},
	["2.12.0"] = {
		"|cffffd100Suivi des commandes|r : nouvel onglet Commandes dans Artisanat. Tes commandes reçues et passées y restent 30 jours, avec leur état. Accepte, refuse, marque « Fait » ou « Reçue », annule : l'autre est prévenu par une bulle.",
		"|cffffd100Encyclopédie|r : bouton « Voir dans Items » sur un objet fabricable, pour voir qui sait le fabriquer et le commander.",
	},
	["2.11.0"] = {
		"Nouvelle page |cffffd100Événements|r dans la fenêtre SMB Forever : les événements de la guilde et tes invitations des 30 prochains jours, groupés par jour, avec ton état d'inscription. Clique sur un événement pour voir sa description et la liste des inscrits, et réponds directement (S'inscrire, Peut-être, Se désinscrire). La bulle d'un nouvel événement ouvre cette page, et l'accueil rappelle le prochain événement.",
	},
	["2.10.0"] = {
		"|cffffd100Carte du monde|r : les membres de la guilde y apparaissent avec leur médaillon, entouré d'un anneau à la couleur de leur classe (un point s'ils n'ont pas de portrait). Le plus récent passe au-dessus quand ils se chevauchent.",
		"|cffffd100Guilde > À suivre|r : les inactifs depuis un mois, les membres sans SMB Forever et ceux qui ne sont pas à jour, avec une étiquette pour chacun. Le bouton |cffffd100Rappeler|r envoie un message privé poli aux membres en ligne pour qu'ils installent ou mettent à jour l'addon (une fois toutes les 10 min).",
	},
	["2.9.0"] = {
		"|cffffd100Dons × Besoins|r : une bulle quand un membre donne un objet de tes besoins ; marque « Dans tes besoins », tri en tête et filtre « Mes besoins » dans les Dons ; « donné par X » et bouton Demander dans tes besoins ; « tu en as N » sur les besoins de la guilde que tu peux donner.",
	},
	["2.8.0"] = {
		"|cffffd100Artisanat > Items|r : un clic sur un objet l'affiche à droite avec |cffffd100les membres de la guilde qui savent le fabriquer|r (en ligne d'abord, avec leur métier et leur niveau) : clic pour chuchoter, « Commander » pour lui demander. Les boutons Ajouter, Besoin et Encyclopédie sont dans ce panneau.",
	},
	["2.7.0"] = {
		"|cffffd100Page Guilde|r : tous les membres, en ligne et hors ligne, avec ce que l'addon sait d'eux (niveau, rang, zone ou dernière connexion, pseudo et personnage principal, rôle, métiers, version de l'addon, distance, note). Recherche, filtres, clic pour chuchoter, clic droit pour inviter.",
		"|cffffd100Ton profil|r : une fenêtre te propose de renseigner ton pseudo, ton personnage principal et ton rôle ; tant qu'il manque quelque chose, un panneau « Profil incomplet » dans le bandeau la rouvre.",
		"|cffffd100Artisanat > Items|r : niveau requis minimum et maximum, et « Fabricable par la guilde » (ce qu'un autre membre sait fabriquer).",
		"Registre : le conseil « ouvre ta fenêtre de métier » ne s'affiche plus que pour les métiers pas encore partagés.",
	},
	["2.6.2"] = {
		"Le programme de mise à jour s'appelle désormais |cffffd100SMB Forever Updater|r.",
	},
	["2.6.1"] = {
		"La bulle « Nouvelle version » indique de mettre à jour avec |cffffd100SMB Forever Updater|r.",
	},
	["2.6.0"] = {
		"|cffffd100Artisanat > Items|r : deux filtres, « Pour ma classe » (armes que tu sais manier, ton type d'armure, capes, bijoux, boucliers et reliques de ta classe) et « Jusqu'à mon niveau ». Ils sont gardés d'une session à l'autre.",
	},
	["2.5.1"] = {
		"Boutons dorés plus lisibles (texte net, sans ombre), croix de fermeture plates et dorées.",
		"L'addon s'appelle |cffffd100SMB Forever|r partout : fenêtres, bulles, messages et liste des addons du jeu.",
	},
	["2.5.0"] = {
		"|cffffd100Accueil|r au même style que les autres pages : portrait du chef et places par rôle dans les groupes ouverts, portrait de qui appelle à l'aide, noms à la couleur de leur classe.",
		"|cffffd100Bulles de notification|r et |cffffd100menus|r (menu rapide du médaillon, personnages…) aux couleurs de la fenêtre SMB Forever.",
		"Cette fenêtre |cffffd100Nouveautés|r a elle aussi fait peau neuve.",
	},
	["2.4.1"] = {
		"Les noms des membres (dons, besoins) sont à la couleur de leur classe, et les portraits montrent l'icône de leur classe, d'après la liste de guilde.",
	},
	["2.4.0"] = {
		"|cffffd100Artisanat|r dans la fenêtre SMB Forever, au nouveau style : Registre (qui sait fabriquer quoi, commandes), Items (catégories et sous-catégories, Besoin, Ajouter à une liste ou un projet) et Projets de guilde (tâches « Je m'en occupe »).",
		"|cffffd100Mes carnets|r dans la fenêtre : tes listes à gauche, la liste de courses à droite (matériaux, recettes, quantités). L'encyclopédie et la mini-liste passent aux nouvelles couleurs ; l'encyclopédie se colle à droite de la fenêtre.",
		"Toutes les fenêtres de SMB Forever sont maintenant réunies dans la fenêtre SMB Forever.",
	},
	["2.3.1"] = {
		"La fenêtre principale s'appelle désormais |cffffd100SMB Forever|r, suivi de la version de l'addon.",
	},
	["2.3.0"] = {
		"|cffffd100Dons|r dans la fenêtre SMB Forever, au nouveau style : Dons (catégories, recherche, Demander puis Merci !), Mes dons (glisser un objet pour le donner), Demandes reçues et Besoins (les tiens et ceux de la guilde, avec « tu sais le fabriquer »).",
		"Son de clic sur tous les boutons de la fenêtre SMB Forever.",
	},
	["2.2.0"] = {
		"|cffffd100Options|r dans la fenêtre SMB Forever, au nouveau style : Affichage (avec un curseur pour la taille de la fenêtre), Moi (pseudo, personnages, position, rôle), Notifications.",
	},
	["2.1.1"] = {
		"Fenêtre SMB Forever plus lisible : textes des boutons, filtres et champs plus grands, fenêtre un peu plus grande. |cffffd100/smb taille 1.2|r pour l'ajuster (de 0.7 à 1.6).",
	},
	["2.1.0"] = {
		"|cffffd100Groupes|r dans la fenêtre SMB Forever, au nouveau style : filtres (Donjons, Raids, Quêtes…) et recherche, portrait du chef, places par rôle, rôle recherché. « Mon groupe » : choix du contenu, places, commentaire et rappel sur un seul écran ; gestion des candidats et groupe public à côté de la composition.",
		"|cffffd100Quêtes en commun|r : leur propre page dans la fenêtre SMB Forever.",
	},
	["2.0.1"] = {
		"|cffffd100Repères à l'écran|r : toujours sur le tour de l'écran (les positions n'ont pas d'altitude) : en haut pour les membres devant toi, sur les côtés à gauche et à droite, en bas pour ceux qui sont derrière.",
	},
	["2.0.0"] = {
		"|cffffd100Nouvelle interface|r : le bouton de la mini-carte devient un médaillon à placer où tu veux (anneau à la couleur de ton rôle, pastille des nouveautés). Clic : la fenêtre SMB Forever et son accueil, qui résume la guilde (membres de ta zone, groupes ouverts, appels à l'aide, demandes de dons, besoins que tu sais fabriquer, projets). Clic droit : menu rapide (rôle, position, groupes, à l'aide).",
		"|cffffd100Repères à l'écran|r : les membres de la guilde sur ta carte apparaissent dans le HUD, avec leur portrait et leur distance, au-dessus de leur tête ou dans leur direction (/smb reperes).",
		"|cffffd100Portraits|r : le portrait de chaque membre (race, classe, sexe) s'affiche à côté de son nom ; les bannières horizontales disparaissent.",
		"Barres de nom : leur taille suit de nouveau le jeu, les noms des autres joueurs ne grossissent plus d'un coup.",
		"Carte : le point des membres est plus visible, et visible aussi hors groupe.",
		"Noms des objets en anglais sur un client anglais ; emote du cri de guilde : une chope en bois animée.",
		"Pseudo, personnages, partage de position et choix des notifications : dans les options (/smb options).",
	},
	["1.6.0"] = {
		"|cffffd100Carnet de craft|r : tes listes de courses. Choisis des objets, SMB Forever calcule tous les composants (sous-recettes comprises) et ce qu'il te manque d'après tes sacs et ta banque. Réduit, il ne laisse à l'écran que la liste des composants, mise à jour en direct.",
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

-- Apparence : kit ns.UI (GuildUp_Style.lua), comme la fenêtre SMB Forever. Cadre plat sombre à bordure
-- dorée ; bandeau (emblème, titre, sous-titre, fermeture) par lequel on la déplace ; liste défilante
-- (molette) d'un bloc par version, la version montrée mise en avant dans une carte ; bouton « Super ! ».
local MEDIA = "Interface\\AddOns\\" .. NOM_ADDON .. "\\media\\"
local LARGEUR, HAUTEUR, HAUTEUR_TETE = 500, 470, 58
local LARGEUR_BLOC = LARGEUR - 38             -- liste (marges 16 et 10), place de la barre de défilement
local LARGEUR_NOTE = LARGEUR_BLOC - 26 - 12   -- après la puce, marge droite du bloc

local fenNotes

-- Bloc d'une version (réutilisé d'un affichage à l'autre) : titre, marque « ta version », puces
local function Bloc(f, n)
	if f.blocs[n] then return f.blocs[n] end
	local UI, C = ns.UI, ns.UI.C
	local b = UI.Cadre(f.liste.contenu, { 0, 0, 0, 0 })
	b:SetWidth(LARGEUR_BLOC)
	b.titre = UI.Texte(b, "GameFontNormalLarge", C.ors)
	b.titre:SetPoint("TOPLEFT", b, "TOPLEFT", 12, -10)
	b.marque = UI.Texte(b, "GameFontHighlightSmall", C.vert)
	b.marque:SetPoint("LEFT", b.titre, "RIGHT", 10, 0)
	b.puces = {}
	f.blocs[n] = b
	return b
end

-- Une note : puce dorée et texte à la ligne, aligné après la puce
local function Puce(b, i)
	if b.puces[i] then return b.puces[i] end
	local UI, C = ns.UI, ns.UI.C
	local p = {}
	p.point = UI.Texte(b, "GameFontHighlight", C.orFonce)
	p.point:SetText("•")
	p.texte = UI.Texte(b, "GameFontHighlight", C.texte)
	p.texte:SetWordWrap(true)
	p.texte:SetWidth(LARGEUR_NOTE)
	p.texte:SetSpacing(2)
	b.puces[i] = p
	return p
end

local function CreerFenetre()
	local UI = ns.UI
	local C = UI.C
	local f = CreateFrame("Frame", "GuildUpNouveautes", UIParent, "BackdropTemplate")
	UI.Habiller(f, C.fond, C.bordFort)
	f:SetSize(LARGEUR, HAUTEUR)
	f:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
	f:SetFrameStrata("DIALOG") -- au-dessus de la fenêtre SMB Forever (HIGH)
	f:SetToplevel(true)
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)
	f:Hide()
	tinsert(UISpecialFrames, "GuildUpNouveautes") -- Échap ferme

	-- bandeau : emblème, titre, sous-titre, fermeture ; on le glisse pour déplacer
	local tete = UI.Cadre(f, C.bandeau)
	tete:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
	tete:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -1)
	tete:SetHeight(HAUTEUR_TETE)
	tete:EnableMouse(true)
	tete:RegisterForDrag("LeftButton")
	tete:SetScript("OnDragStart", function() f:StartMoving() end)
	tete:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)
	local filet = UI.Filet(tete)
	filet:SetPoint("BOTTOMLEFT", tete, "BOTTOMLEFT", 0, 0)
	filet:SetPoint("BOTTOMRIGHT", tete, "BOTTOMRIGHT", 0, 0)
	local embleme = tete:CreateTexture(nil, "ARTWORK")
	embleme:SetTexture(MEDIA .. "gu_emote")
	embleme:SetSize(36, 36)
	embleme:SetPoint("LEFT", tete, "LEFT", 12, 0)
	f.titre = UI.Texte(tete, "GameFontNormalLarge", C.ors)
	f.titre:SetPoint("TOPLEFT", embleme, "TOPRIGHT", 10, -2)
	f.sousTitre = UI.Texte(tete, "GameFontHighlightSmall", C.gris)
	f.sousTitre:SetPoint("TOPLEFT", f.titre, "BOTTOMLEFT", 0, -3)
	f.sousTitre:SetText("Ce qui a changé, de la plus récente à la plus ancienne")
	-- croix plate du kit, comme la fenêtre SMB Forever
	local fermer = UI.Fermer(tete, function() f:Hide() end, 26)
	fermer:SetPoint("RIGHT", tete, "RIGHT", -10, 0)
	f.CloseButton = fermer -- (pas de son de clic : la fenêtre joue le sien en se fermant)

	-- notes de toutes les versions, la plus récente en haut (molette)
	f.liste = UI.Liste(f)
	f.liste:SetPoint("TOPLEFT", tete, "BOTTOMLEFT", 15, -12)
	f.liste:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -10, 54)
	f.blocs = {}

	-- pied : filet et bouton or
	local filetBas = UI.Filet(f)
	filetBas:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 1, 46)
	filetBas:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 46)
	f.ok = UI.Bouton(f, "Super !", "or", 120, 26)
	f.ok:SetPoint("BOTTOM", f, "BOTTOM", 0, 10)
	f.ok:SetScript("OnClick", function() f:Hide() end)
	f.ok.sonGuildUpSMB = true -- le kit joue déjà le son de clic (pas de second son par AvecSons)
	if ns.AvecSons then ns.AvecSons(f, "fenetre") end
	return f
end

local function MontrerNouveautes(version)
	version = version or MA_VERSION
	if not NOTES[version] then version = ORDRE[1] end
	if not ns.UI then return end -- (GuildUp_Style.lua absent)
	if not fenNotes then fenNotes = CreerFenetre() end
	local f = fenNotes
	local C = ns.UI.C
	f.titre:SetText(("Nouveautés · %s %s"):format(NOM_PUBLIC, version))
	local y, n = 0, 0
	for _, v in ipairs(ORDRE) do
		if Comparer(v, version) <= 0 and NOTES[v] then
			n = n + 1
			local b = Bloc(f, n)
			-- la version montrée dans une carte bordée d'or, les anciennes plus discrètes
			local enAvant = (v == version)
			b:ClearAllPoints()
			b:SetPoint("TOPLEFT", f.liste.contenu, "TOPLEFT", 0, -y)
			if b.SetBackdropColor then
				if enAvant then
					b:SetBackdropColor(unpack(C.carte))
					b:SetBackdropBorderColor(unpack(C.bordMoyen))
				else
					b:SetBackdropColor(0, 0, 0, 0)
					b:SetBackdropBorderColor(0, 0, 0, 0)
				end
			end
			b.titre:SetFontObject(enAvant and "GameFontNormalLarge" or "GameFontNormal")
			b.titre:SetTextColor(unpack(enAvant and C.ors or C.orFonce))
			b.titre:SetText("Version " .. v)
			b.marque:SetText(v == MA_VERSION and "ta version" or "")
			local h = 10 + b.titre:GetStringHeight() + 8
			for i, note in ipairs(NOTES[v]) do
				local p = Puce(b, i)
				p.point:ClearAllPoints()
				p.point:SetPoint("TOPLEFT", b, "TOPLEFT", 12, -h)
				p.texte:ClearAllPoints()
				p.texte:SetPoint("TOPLEFT", b, "TOPLEFT", 26, -h)
				p.texte:SetText(note) -- (les codes couleur |cff…|r des notes sont gardés)
				p.texte:SetAlpha(enAvant and 1 or 0.8)
				p.point:Show()
				p.texte:Show()
				h = h + p.texte:GetStringHeight() + 6
			end
			for i = #NOTES[v] + 1, #b.puces do b.puces[i].point:Hide(); b.puces[i].texte:Hide() end
			h = h + 6
			b:SetHeight(h)
			b:Show()
			y = y + h + 8
		end
	end
	for i = n + 1, #f.blocs do f.blocs[i]:Hide() end
	f.liste:Hauteur(y)
	f.liste:Haut()
	-- même taille que la fenêtre SMB Forever (/smb taille)
	if ns.EchelleInterface then f:SetScale(ns.EchelleInterface() or 1) end
	f:Show()
	f:Raise()
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
	L(("version : %s ; %d membre(s) avec SMB Forever vus (%d plus ancienne(s), %d plus récente(s))"):format(
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
