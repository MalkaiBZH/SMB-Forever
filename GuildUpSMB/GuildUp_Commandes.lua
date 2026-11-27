-- GuildUpSMB : page « Aide » de la fenêtre SMB Forever (ns.AjouterPage("aide"), kit ns.UI).
-- Toutes les commandes de /smb (et /guildup), rangées par chapitre, avec ce que fait chacune et son
-- état quand c'est un interrupteur (activé / désactivé, lu dans GuildUpDB au moment de l'affichage).
-- Une case de recherche filtre sur la commande, ses autres écritures et sa description.
-- Clic sur une ligne : la commande est lancée, sauf celles qui attendent une valeur (elles sont
-- montrées en gris avec leur exemple) et /smb reset, trop brutale pour un clic.
-- Les commandes sont déclarées ici à la main : quand GuildUp_Options.lua en gagne une, l'ajouter.
--   { commande, autres écritures, ce que ça fait, exemple de valeur, état, à taper à la main }
-- « état » est une fonction qui renvoie true / false pour les interrupteurs, nil pour le reste.

local NOM_ADDON, ns = ...

local function DB() return (ns.DB and ns.DB()) or {} end
local function Notifs()
	local db = DB()
	return type(db.notifs) == "table" and db.notifs or {}
end

local CHAPITRES = {
	{ "Ouvrir une page", {
		{ "", nil, "Ouvre la fenêtre SMB Forever, sur la page où tu l'avais laissée (un deuxième /smb la referme)." },
		{ "aide", "commandes", "Cette page : toutes les commandes, ce que fait chacune et son état." },
		{ "options", "reglages", "La page Options : affichage des bannières, bulles, carte et repères, taille de la fenêtre." },
		{ "demandes", "dons, besoins", "La page Demandes : ce que la guilde cherche, ce que tu peux donner ou fabriquer." },
		{ "metiers", "metier", "Le registre des métiers : qui sait fabriquer quoi, et à quel niveau de métier." },
		{ "items", "crafts, craft", "L'Artisanat, sur l'onglet des objets que la guilde sait fabriquer." },
		{ "quetes", nil, "La page Quêtes : les quêtes que d'autres membres font aussi, les plus proches en premier." },
		{ "wowdex", "dex, bestiaire", "Le WoWdex : tous les monstres du jeu à voir, capturer (vaincre) et dépouiller, avec leur butin, et le classement de la guilde." },
		{ "jeux", "jeu", "La page Jeux : tirage au sort et Bizkit, le jeu de dés de la guilde." },
		{ "evenements", "events", "La page Événements : le calendrier de la guilde sur les 30 prochains jours." },
		{ "activite", "fil, podium", "La page Activité : le fil des 30 derniers jours et le podium de la semaine." },
		{ "stats", "statistiques, presence", "Les statistiques de présence : à quelles heures la guilde est en ligne." },
		{ "encyclo", "encyclopedie", "L'encyclopédie d'un objet : où il tombe, qui le vend, qui sait le fabriquer. Alt + clic sur un objet fait pareil." },
		{ "nouveautes", "notes", "Les nouveautés de cette version et des précédentes." },
		{ "layer", "layers", "Ton layer (la copie de la zone où le serveur t'a mis) et les membres qui sont sur un autre." },
		{ "souvenirs", "souvenir", "Affiche ou cache sur la carte du monde les grands moments de la guilde.",
			nil, function() return DB().souvenirsCarte ~= false end },
	} },
	{ "Agir avec la guilde", {
		{ "sos", nil, "Envoie un appel à l'aide à la guilde avec ta position : les autres reçoivent une bulle et peuvent venir." },
		{ "roll", "tirage", "Ouvre un tirage au sort pour la guilde. Maj + clic sur un objet pour le mettre en jeu ; sans rien, rouvre la fenêtre du dernier tirage.",
			"roll [objet ou mot]" },
		{ "bizkit", "des, dés", "Le Bizkit : assieds-toi autour de la table et lance deux dés quand vient ton tour. Sur un 7, tout le monde crie « Bizkit ! » : le dernier perd un point. Sur un 3 ou un 5, en prison ! Sur un double, attaque ! Sinon, gare au vecteur. Pas assez de monde ? « Appeler la guilde » prévient les autres membres." },
		{ "motus", "mot", "Le Motus de la guilde : un mot à trouver chaque jour, le même pour tout le monde, mais on n'y joue qu'en vol sur un griffon. Les points du jour récompensent la vitesse." },
		{ "sondage", "sondages, vote", "Ouvre le sondage en cours, ou te laisse en poser un (une question, de deux à cinq réponses)." },
		{ "biere", "gu", "Affiche ou non la chope qui descend de l'écran quand un membre écrit le cri de guilde. Ne lance pas le cri : il part tout seul quand tu écris le cri dans le chat.",
			nil, function() return Notifs().gu ~= false end },
		{ "entree", "entrée", "Note ta position comme entrée d'un donjon, pour que l'addon sache la montrer ensuite.",
			"entree mortemines" },
		{ "cena", "explosion", "Rejoue l'explosion de montée de niveau, pour la voir sans attendre de monter." },
	} },
	{ "Bulles et fenêtre", {
		{ "calme", "dnd, npd", "Ne pas déranger : coupe toutes les bulles de l'addon. Suivi d'un nombre, seulement pour ce nombre de minutes. La guilde voit une lune devant ton nom.",
			"calme 30", function() return ns.NePasDeranger and ns.NePasDeranger() end },
		{ "annonces", nil, "Reçois ou non les bulles d'annonce de la guilde : montées de niveau, nouveaux métiers, paliers.",
			nil, function() return DB().annoncesGuilde ~= false end },
		{ "bouton", "barre", "Affiche ou cache le médaillon SMB Forever, le bouton rond déplaçable par lequel passent les bulles.",
			nil, function() return ns.BoutonVisible and ns.BoutonVisible() end },
		{ "taille", nil, "Change la taille de la fenêtre SMB Forever, de 0,7 à 1,6.", "taille 1.2" },
	} },
	{ "Affichage sur les barres de nom", {
		{ "on", nil, "Rallume les bannières de guilde au-dessus des noms.", nil, function() return DB().actif end },
		{ "off", nil, "Éteint les bannières de guilde (le reste de l'addon continue de fonctionner)." },
		{ "plaques", nil, "Bannières sur les barres de nom des joueurs autour de toi.", nil, function() return DB().plaques end },
		{ "cible", nil, "Bannière sur le cadre de ta cible.", nil, function() return DB().cible end },
		{ "cast", nil, "Place la barre d'incantation au-dessus du nom plutôt qu'en dessous.",
			nil, function() return DB().incantationHaut end },
		{ "noms", nil, "Affiche toujours le nom et la guilde des joueurs alliés, même sans les viser.",
			nil, function() return DB().nomsAllies end },
		{ "lueur", nil, "Lueur jaune derrière la bannière de ta cible, pour la repérer d'un coup d'œil.",
			nil, function() return DB().lueur end },
		{ "medaillons", "portraits", "Portraits des joueurs sur les bannières (race, classe et sexe reconnus par le jeu).",
			nil, function() return DB().medaillons ~= false end },
		{ "reperes", "repères, hud", "Flèches sur les bords de l'écran vers les membres de la guilde qui sont dans ta zone.",
			nil, function() return DB().reperes ~= false end },
		{ "objectifs", "quetes!", "Un « ! » sur les ennemis à tuer ou à dépouiller pour une de tes quêtes en cours.",
			nil, function() return DB().objectifsPlaques ~= false end },
		{ "couleurs", nil, "Colore la bannière selon le rôle du membre (tank, soigneur, dégâts) au lieu de la couleur choisie.",
			nil, function() return DB().couleurs end },
		{ "auras", nil, "Montre les améliorations et affaiblissements sous la barre de nom.",
			nil, function() return DB().aurasSous end },
		{ "style", nil, "Aspect des bannières : « banniere » pour l'image gravée, « degrade » pour un simple dégradé de couleur.",
			"style banniere" },
		{ "role", nil, "Force le rôle affiché sur ta bannière : tank, heal, dps, ou auto pour laisser l'addon le deviner.",
			"role tank" },
		{ "couleur", nil, "Couleur du dégradé des bannières : trois nombres de 0 à 1 (ou de 0 à 255). Sans valeur, ouvre le sélecteur de couleur.",
			"couleur 0.8 0.6 0.2" },
		{ "opacite", "opacité", "Transparence des bannières, de 0 (invisible) à 1 (opaque).", "opacite 0.8" },
	} },
	{ "En cas de problème", {
		{ "diag", nil, "Rassemble des informations techniques (ta cible, le réseau de l'addon, les versions) à copier et à envoyer." },
		{ "debug", nil, "Affiche la partie Debug de la page Options, avec les cases de test réservées à la mise au point.",
			nil, function() return DB().afficherDebug end },
		{ "reset", nil, "Remet tous les réglages d'affichage par défaut. Tes demandes, ton profil et tes données sont gardés. À taper à la main, pour éviter un clic malheureux.",
			nil, nil, true },
	} },
}

--------------------------------------------------------------------------------
-- Page
--------------------------------------------------------------------------------

local MARGE, HAUT_LIGNE, HAUT_TITRE = 16, 38, 26
local LARGEUR_CMD = 168

local Simplifier = ns.Simplifier

local function Lancer(nom)
	if SlashCmdList and SlashCmdList.GUILDUP then SlashCmdList.GUILDUP(nom) end
end

local function CreerPage(parent)
	local UI = ns.UI
	local C = UI.C
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	local largeur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[1] or 794) - 2 * MARGE
	local hauteur = (ns.TAILLE_PAGE and ns.TAILLE_PAGE[2] or 586)

	local titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -16)
	titre:SetText("Aide")
	local sous = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	sous:SetPoint("TOPLEFT", titre, "BOTTOMLEFT", 0, -4)
	sous:SetText("Toutes les commandes de |cffffd100/smb|r (qui s'écrit aussi |cffffd100/guildup|r), accents acceptés. Clic sur une ligne : la commande est lancée.")

	p.cherche = UI.Champ(p, 240, "Chercher une commande…")
	p.cherche:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -14)
	p.cherche.SurTexte = function() if p.Maj then p.Maj() end end
	p.cherche.SurValider = function() if p.Maj then p.Maj() end end

	local carte = UI.Carte(p, "Commandes")
	carte:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -62)
	carte:SetSize(largeur, hauteur - 62 - MARGE)
	carte.liste = UI.Liste(carte)
	carte.liste:SetPoint("TOPLEFT", carte, "TOPLEFT", 12, -36)
	carte.liste:SetPoint("BOTTOMRIGHT", carte, "BOTTOMRIGHT", -8, 10)
	carte.lignes, carte.titres = {}, {}

	-- une ligne de chapitre
	local function Titre(i)
		local t = carte.titres[i]
		if t then return t end
		t = CreateFrame("Frame", nil, carte.liste.contenu)
		t:SetHeight(HAUT_TITRE)
		t:SetPoint("RIGHT", carte.liste.contenu, "RIGHT", 0, 0)
		t.texte = UI.Texte(t, "GameFontNormal", C.ors)
		t.texte:SetPoint("BOTTOMLEFT", t, "BOTTOMLEFT", 2, 4)
		t.filet = UI.Filet(t)
		t.filet:SetPoint("BOTTOMLEFT", t, "BOTTOMLEFT", 0, 0)
		t.filet:SetPoint("BOTTOMRIGHT", t, "BOTTOMRIGHT", 0, 0)
		carte.titres[i] = t
		return t
	end

	-- une ligne de commande
	local function Ligne(i)
		local l = carte.lignes[i]
		if l then return l end
		l = CreateFrame("Button", nil, carte.liste.contenu)
		l:SetHeight(HAUT_LIGNE)
		l:SetPoint("RIGHT", carte.liste.contenu, "RIGHT", 0, 0)
		l.fond = l:CreateTexture(nil, "BACKGROUND")
		l.fond:SetAllPoints()
		l.fond:SetColorTexture(1, 1, 1, 0.03)
		l.fond:Hide()
		l.cmd = UI.Texte(l, "GameFontNormal", C.ors)
		l.cmd:SetPoint("TOPLEFT", l, "TOPLEFT", 4, -3)
		l.cmd:SetWidth(LARGEUR_CMD)
		l.cmd:SetJustifyH("LEFT")
		l.alias = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.alias:SetPoint("TOPLEFT", l.cmd, "BOTTOMLEFT", 0, -1)
		l.alias:SetWidth(LARGEUR_CMD)
		l.alias:SetJustifyH("LEFT")
		l.etat = UI.Texte(l, "GameFontHighlightSmall", C.gris)
		l.etat:SetPoint("TOPRIGHT", l, "TOPRIGHT", -4, -3)
		l.etat:SetJustifyH("RIGHT")
		l.texte = UI.Texte(l, "GameFontHighlightSmall", C.texte)
		l.texte:SetPoint("TOPLEFT", l.cmd, "TOPRIGHT", 10, 1)
		l.texte:SetPoint("RIGHT", l.etat, "LEFT", -10, 0)
		l.texte:SetJustifyH("LEFT")
		l.texte:SetJustifyV("TOP")
		l.texte:SetHeight(HAUT_LIGNE - 6)
		l.texte:SetWordWrap(true)
		l:SetScript("OnEnter", function(self)
			if self.lancable then self.fond:Show() end
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("/smb " .. (self.nom ~= "" and self.nom or ""))
			if self.autres then GameTooltip:AddLine("aussi : " .. self.autres, 0.6, 0.58, 0.5) end
			GameTooltip:AddLine(self.description or "", 1, 1, 1, true)
			if self.exemple then
				GameTooltip:AddLine("Attend une valeur, à taper dans le chat : |cffffd100/smb " .. self.exemple .. "|r", 0.85, 0.66, 0.25, true)
			elseif self.lancable then
				GameTooltip:AddLine("Clic : lancer la commande", 0.44, 0.82, 0.55)
			end
			GameTooltip:Show()
		end)
		l:SetScript("OnLeave", function(self) self.fond:Hide(); GameTooltip:Hide() end)
		l:SetScript("OnClick", function(self)
			if not self.lancable then return end
			Lancer(self.nom)
			if p.Maj then p.Maj() end
		end)
		carte.lignes[i] = l
		return l
	end

	p.Maj = function()
		local filtre = Simplifier and Simplifier(p.cherche:Lire()) or (p.cherche:Lire() or ""):lower()
		local y, nTitres, nLignes, total = 0, 0, 0, 0
		for _, chapitre in ipairs(CHAPITRES) do
			-- les commandes de ce chapitre qui passent le filtre
			local gardees = {}
			for _, c in ipairs(chapitre[2]) do
				local texte = (c[1] or "") .. " " .. (c[2] or "") .. " " .. (c[3] or "")
				if filtre == "" or (Simplifier and Simplifier(texte) or texte:lower()):find(filtre, 1, true) then
					gardees[#gardees + 1] = c
				end
			end
			if #gardees > 0 then
				nTitres = nTitres + 1
				local t = Titre(nTitres)
				t:SetPoint("TOPLEFT", carte.liste.contenu, "TOPLEFT", 0, -y)
				t.texte:SetText(chapitre[1])
				t:Show()
				y = y + HAUT_TITRE
				for _, c in ipairs(gardees) do
					nLignes = nLignes + 1
					total = total + 1
					local l = Ligne(nLignes)
					l:SetPoint("TOPLEFT", carte.liste.contenu, "TOPLEFT", 0, -y)
					l.nom, l.autres, l.description, l.exemple = c[1], c[2], c[3], c[4]
					-- « /smb » tout seul refermerait la fenêtre, et /smb reset se tape à la main
					l.lancable = c[4] == nil and c[1] ~= "" and not c[6]
					l.cmd:SetText("|cffffd100/smb " .. c[1] .. "|r")
					l.alias:SetText(c[2] and ("ou " .. c[2]) or "")
					l.texte:SetText(c[3] or "")
					local etat = c[5] and c[5]()
					if etat == nil then
						l.etat:SetText(c[4] and "|cff8a826f(une valeur)|r" or (c[6] and "|cff8a826f(à taper)|r" or ""))
					else
						l.etat:SetText(etat and "|cff6fd08cactivé|r" or "|cff8a826fdésactivé|r")
					end
					l.cmd:SetAlpha(l.lancable and 1 or 0.75)
					y = y + HAUT_LIGNE
				end
			end
		end
		for i = nTitres + 1, #carte.titres do carte.titres[i]:Hide() end
		for i = nLignes + 1, #carte.lignes do carte.lignes[i]:Hide() end
		for i = 1, nLignes do carte.lignes[i]:Show() end
		carte.compte:SetText(("%d commande%s"):format(total, total > 1 and "s" or ""))
		carte.vide:SetShown(total == 0)
		if total == 0 then carte.vide:SetText("Aucune commande ne correspond à ta recherche.") end
		carte.liste:Hauteur(math.max(1, y))
	end
	return p
end

if ns.AjouterPage then ns.AjouterPage("aide", CreerPage) end
