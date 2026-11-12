-- GuildUpSMB : page « Événements » de la fenêtre SMB Forever (kit ns.UI), avec le calendrier du jeu
-- (C_Calendar). Aucun message réseau : tout vient du serveur du jeu.
-- Page :
--   à gauche, les événements de la guilde (et ceux où je suis invité) des 30 prochains jours, groupés
--   par jour (« Aujourd'hui », « Demain », « samedi 15 novembre ») et triés par heure : icône, titre,
--   heure, type (et donjon ou raid une fois le détail lu), créateur, inscrits (oui / peut-être / en
--   attente / non, connus une fois l'événement ouvert) et mon état, en couleur ;
--   à droite, le détail de l'événement choisi (C_Calendar.OpenEvent → CALENDAR_OPEN_EVENT :
--   GetEventInfo, GetNumInvites / EventGetInvite) : date, type, créateur, description, inscrits avec
--   leur classe et leur état, et les réponses sur l'événement ouvert (événement à inscription :
--   S'inscrire = EventSignUp, Peut-être = EventTentative, Se désinscrire = EventDecline ; invitation :
--   Accepter = EventAvailable, Peut-être, Refuser = EventDecline) ;
--   en haut, « Créer un événement de guilde » (le calendrier du jeu sur « Créer un événement de
--   guilde », comme le clic droit sur un jour), « Ouvrir le calendrier » et « Actualiser ».
-- Chargement asynchrone : la page demande les données (C_Calendar.OpenCalendar, au plus toutes les
-- 30 s, et le mois en cours avec C_Calendar.SetAbsMonth quand le calendrier du jeu est fermé) et se
-- redessine sur les évènements CALENDAR_* (p.rafraichirAuto = false). Le cadre du calendrier du jeu
-- ne s'ouvre que sur demande. Sans C_Calendar, la page le dit et ne propose que « Ouvrir le calendrier ».
-- Bulle pour chaque nouvel événement de guilde (C_Calendar.GetGuildEventInfo) ; clic : la page.
-- Fournit ns.BasculerEvenements (/smb evenements), ns.OuvrirEvenements(cle), ns.CreerEvenementGuilde,
-- ns.ProchainsEvenements(n) (carte de l'Accueil), ns.DiagEvenements.

local NOM_ADDON, ns = ...

local CALME = 30                -- les événements déjà prévus à la connexion ne font pas de bulle
local RAFRAICHIR = 300          -- redemande les événements au serveur toutes les 5 min
local HORIZON = 30              -- jours montrés par la page
local MOIS = { "janv.", "févr.", "mars", "avril", "mai", "juin", "juil.", "août", "sept.", "oct.", "nov.", "déc." }
local JOURS = { "dim.", "lun.", "mar.", "mer.", "jeu.", "ven.", "sam." }
local MOIS_LONGS = { "janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre",
	"octobre", "novembre", "décembre" }
local JOURS_LONGS = { "dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi" }

local debut = GetTime()
local premiereLecture = true

local Erreur = ns.Erreur
local NomCourt = ns.NomCourt
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local CouleurClasseTexte = ns.CouleurClasseTexte
local UI = ns.UI
local C = UI.C

local function Vus()
	local db = ns.DB and ns.DB()
	if not db then return {} end
	if type(db.evenementsVus) ~= "table" then db.evenementsVus = {} end
	return db.evenementsVus
end

--------------------------------------------------------------------------------
-- Lecture prudente de l'API du calendrier
--------------------------------------------------------------------------------

-- (tonumber d'autre chose qu'un nombre ou un texte de nombre donne nil)
local function Nombre(x) return tonumber(x) end
local function Chaine(x)
	if type(x) == "string" and x ~= "" then return x end
	if type(x) == "number" then return tostring(x) end
end

-- C_Calendar.nom(...) si la fonction existe, sans jamais planter
local function Appel(nom, ...)
	local f = type(C_Calendar) == "table" and C_Calendar[nom]
	if type(f) ~= "function" then return nil end
	local ok, a, b, c = pcall(f, ...)
	if ok then return a, b, c end
end

local function Existe(nom) return type(C_Calendar) == "table" and type(C_Calendar[nom]) == "function" end

-- le calendrier est lisible : par jour (GetDayEvent) ou au moins la liste des événements de guilde
local function Disponible()
	if Existe("GetNumDayEvents") and Existe("GetDayEvent") then return true end
	return Existe("GetNumGuildEvents") and Existe("GetGuildEventInfo")
end

local function CalendrierAffiche() return CalendarFrame and CalendarFrame.IsShown and CalendarFrame:IsShown() and true or false end

-- États d'inscription (Enum.CalendarStatus, valeurs de repli de l'API C_Calendar)
local S = (type(Enum) == "table" and Enum.CalendarStatus) or {}
local ST = {
	invite = Nombre(S.Invited) or 0, oui = Nombre(S.Available) or 1, non = Nombre(S.Declined) or 2,
	confirme = Nombre(S.Confirmed) or 3, absent = Nombre(S.Out) or 4, reserve = Nombre(S.Standby) or 5,
	inscrit = Nombre(S.Signedup) or 6, pasInscrit = Nombre(S.NotSignedup) or 7, peutEtre = Nombre(S.Tentative) or 8,
}
local INSCRIPTION = Nombre(type(Enum) == "table" and Enum.CalendarInviteType and Enum.CalendarInviteType.Signup) or 1

local VERT, ORANGE, ROUGE = { 0.44, 0.82, 0.55 }, { 1, 0.7, 0.3 }, { 0.93, 0.5, 0.46 }
-- [code] = { texte, couleur, groupe (oui / peut / attente / non) }
local ETATS = {
	[ST.invite] = { "Invité", C.ors, "attente" },
	[ST.oui] = { "Accepté", VERT, "oui" },
	[ST.non] = { "Refusé", ROUGE, "non" },
	[ST.confirme] = { "Confirmé", VERT, "oui" },
	[ST.absent] = { "Absent", ROUGE, "non" },
	[ST.reserve] = { "En réserve", ORANGE, "peut" },
	[ST.inscrit] = { "Inscrit", VERT, "oui" },
	[ST.pasInscrit] = { "Pas inscrit", C.gris, nil },
	[ST.peutEtre] = { "Peut-être", ORANGE, "peut" },
}
local ORDRE_GROUPES = { oui = 1, peut = 2, attente = 3, non = 4 }

-- Types d'événement (Enum.CalendarEventType)
local T = (type(Enum) == "table" and Enum.CalendarEventType) or {}
local TYPES = {
	[Nombre(T.Raid) or 0] = { "Raid", "Interface\\Icons\\INV_Misc_Head_Dragon_01" },
	[Nombre(T.Dungeon) or 1] = { "Donjon", "Interface\\Icons\\INV_Misc_Key_03" },
	[Nombre(T.PvP) or 2] = { "JcJ", "Interface\\Icons\\INV_BannerPVP_02" },
	[Nombre(T.Meeting) or 3] = { "Réunion", "Interface\\Icons\\INV_Misc_PocketWatch_01" },
	[Nombre(T.Other) or 4] = { "Autre", "Interface\\Icons\\INV_Misc_PocketWatch_01" },
}
-- événements gardés (les fêtes, verrouillages de raid… sont laissés au calendrier du jeu)
local TYPES_CALENDRIER = { GUILD_EVENT = true, GUILD_ANNOUNCEMENT = true, PLAYER = true, COMMUNITY_EVENT = true }

local function Hex(c)
	return ("|cff%02x%02x%02x"):format(math.floor(c[1] * 255 + 0.5), math.floor(c[2] * 255 + 0.5), math.floor(c[3] * 255 + 0.5))
end

local function TexteEtat(code)
	local e = code and ETATS[code]
	if not e then return "" end
	return Hex(e[2]) .. e[1] .. "|r"
end

--------------------------------------------------------------------------------
-- Dates (heure du serveur, comme le calendrier du jeu)
--------------------------------------------------------------------------------

-- horodatage d'une date du calendrier ({ year, month, monthDay, hour, minute }), nil si incomplète
local function Horodatage(t)
	if type(t) ~= "table" then return nil end
	local an, mois, jour = Nombre(t.year), Nombre(t.month), Nombre(t.monthDay)
	if not (an and mois and jour) then return nil end
	local ok, v = pcall(time, { year = an, month = mois, day = jour, hour = Nombre(t.hour) or 0,
		min = Nombre(t.minute) or 0, sec = 0 })
	if ok then return v end
end

-- maintenant à l'heure du serveur (horodatage comparable à Horodatage)
local function Maintenant()
	local t
	if type(C_DateAndTime) == "table" and type(C_DateAndTime.GetCurrentCalendarTime) == "function" then
		local ok, r = pcall(C_DateAndTime.GetCurrentCalendarTime)
		if ok then t = r end
	end
	return Horodatage(t) or Horodatage(Appel("GetDate")) or time()
end

local function CleJour(ts)
	local d = date("*t", ts)
	return d.year * 10000 + d.month * 100 + d.day
end

local function DebutJour(ts)
	local d = date("*t", ts)
	return time({ year = d.year, month = d.month, day = d.day, hour = 0, min = 0, sec = 0 })
end

-- « Aujourd'hui », « Demain », « samedi 15 novembre » (« 1er » le premier du mois)
local function NomJour(ts, maintenant)
	local cle = CleJour(ts)
	if cle == CleJour(maintenant) then return "Aujourd'hui" end
	if cle == CleJour(DebutJour(maintenant) + 36 * 3600) then return "Demain" end
	local d = date("*t", ts)
	return ("%s %s %s"):format(JOURS_LONGS[d.wday] or "", d.day == 1 and "1er" or tostring(d.day), MOIS_LONGS[d.month] or "")
end

local function Heure(e) return ("%02d:%02d"):format(e.heure or 0, e.minute or 0) end

--------------------------------------------------------------------------------
-- Liste des événements
--------------------------------------------------------------------------------

local details = {}      -- [cle] = détail lu à l'ouverture de l'événement (description, inscrits…)
local selection         -- clé de l'événement choisi dans la page
local ouvert            -- clé de l'événement ouvert dans le calendrier du jeu (C_Calendar.OpenEvent)
local attendu           -- clé demandée à C_Calendar.OpenEvent, pas encore arrivée
local actionEnAttente   -- { cle, f } : réponse à envoyer quand l'événement sera ouvert
local recu = false      -- au moins une liste reçue du serveur
local derniereDemande = -100
local derniereAction = -100

-- fiche d'un événement d'un jour (C_Calendar.GetDayEvent)
local function FicheJour(e, offset, jour, index)
	local t = type(e.startTime) == "table" and e.startTime or e
	local quand, titre = Horodatage(t), Chaine(e.title)
	if not (quand and titre) then return nil end
	local typeCal = Chaine(e.calendarType)
	if typeCal and not TYPES_CALENDRIER[typeCal] then return nil end
	local id = Nombre(e.eventID)
	return {
		cle = (id and id ~= 0) and ("id" .. tostring(id)) or (titre .. "@" .. quand),
		titre = titre, quand = quand, heure = Nombre(t.hour) or 0, minute = Nombre(t.minute) or 0,
		typeCal = typeCal, typeEv = Nombre(e.eventType),
		icone = (type(e.iconTexture) == "number" or type(e.iconTexture) == "string") and e.iconTexture or nil,
		etat = Nombre(e.inviteStatus), invitePar = Chaine(e.invitedBy), mod = Chaine(e.modStatus),
		inviteType = Nombre(e.inviteType), verrouille = e.isLocked == true, difficulte = Chaine(e.difficultyName),
		coords = { offset, jour, index },
	}
end

-- fiche d'un événement de la liste de guilde (C_Calendar.GetGuildEventInfo)
local function FicheGuilde(g, i)
	local quand, titre = Horodatage(g), Chaine(g.title)
	if not (quand and titre) then return nil end
	local id = Nombre(g.eventID)
	local a, b, c = Appel("GetGuildEventSelectionInfo", i)
	if type(a) == "table" then a, b, c = a.offsetMonths, a.monthDay, a.eventIndex end
	a, b, c = Nombre(a), Nombre(b), Nombre(c)
	return {
		cle = (id and id ~= 0) and ("id" .. tostring(id)) or (titre .. "@" .. quand),
		titre = titre, quand = quand, heure = Nombre(g.hour) or 0, minute = Nombre(g.minute) or 0,
		typeCal = Chaine(g.calendarType) or "GUILD_EVENT", typeEv = Nombre(g.eventType),
		icone = (type(g.texture) == "number" or type(g.texture) == "string") and g.texture or nil,
		etat = Nombre(g.inviteStatus),
		coords = (a and b and c) and { a, b, c } or nil,
	}
end

-- Événements des HORIZON prochains jours (et ceux commencés depuis moins de 3 h), triés par date
local function Lister()
	local res = {}
	if not Disponible() then return res, Maintenant() end
	local maintenant = Maintenant()
	local depuis, jusqua = maintenant - 3 * 3600, DebutJour(maintenant) + (HORIZON + 1) * 86400
	local parCle, parTitre = {}, {}
	local function Ajouter(e)
		if not e or e.quand < depuis or e.quand >= jusqua then return end
		local deja = parCle[e.cle] or parTitre[e.titre .. "@" .. e.quand]
		if deja then
			for k, v in pairs(e) do if deja[k] == nil then deja[k] = v end end
			return
		end
		res[#res + 1] = e
		parCle[e.cle], parTitre[e.titre .. "@" .. e.quand] = e, e
	end
	-- 1. jour par jour (les mois sont comptés depuis le mois choisi dans le calendrier du jeu)
	if Existe("GetNumDayEvents") and Existe("GetDayEvent") then
		local info = Appel("GetMonthInfo", 0)
		local baseAn = Nombre(type(info) == "table" and info.year)
		local baseMois = Nombre(type(info) == "table" and info.month)
		if baseAn and baseMois then
			local midi = DebutJour(maintenant) + 12 * 3600 -- (midi : à l'abri des changements d'heure)
			for j = 0, HORIZON do
				local d = date("*t", midi + j * 86400)
				local offset = (d.year - baseAn) * 12 + (d.month - baseMois)
				local n = Nombre(Appel("GetNumDayEvents", offset, d.day)) or 0
				for i = 1, n do
					local e = Appel("GetDayEvent", offset, d.day, i)
					if type(e) == "table" then Ajouter(FicheJour(e, offset, d.day, i)) end
				end
			end
		end
	end
	-- 2. les événements de guilde à venir (aussi ceux des mois pas encore chargés)
	local n = Nombre(Appel("GetNumGuildEvents")) or 0
	for i = 1, n do
		local g = Appel("GetGuildEventInfo", i)
		if type(g) == "table" then Ajouter(FicheGuilde(g, i)) end
	end
	table.sort(res, function(x, y)
		if x.quand ~= y.quand then return x.quand < y.quand end
		return x.titre < y.titre
	end)
	return res, maintenant
end

local function Trouver(cle)
	if not cle then return nil end
	for _, e in ipairs((Lister())) do if e.cle == cle then return e end end
end

-- Demande les données au serveur (au plus toutes les 30 s, sauf force) ; le mois en cours est choisi
-- seulement si le calendrier du jeu est fermé (sinon on le laisse sur le mois que regarde le joueur)
local function Demander(force)
	if not Disponible() then return end
	if not force and GetTime() - derniereDemande < 30 then return end
	derniereDemande = GetTime()
	if not CalendrierAffiche() then
		local d = date("*t", Maintenant())
		Appel("SetAbsMonth", d.month, d.year)
	end
	Appel("OpenCalendar")
end

-- type lisible : « Raid · Cœur du Magma », « Annonce », « Donjon »…
local function TexteType(e, d)
	local morceaux = {}
	if e.typeCal == "GUILD_ANNOUNCEMENT" then
		morceaux[1] = "Annonce"
	else
		local ty = TYPES[(d and d.typeEv) or e.typeEv]
		if ty then morceaux[#morceaux + 1] = ty[1] end
		if d and d.contenu then morceaux[#morceaux + 1] = d.contenu end
		local diff = (d and d.difficulte) or e.difficulte
		if diff then morceaux[#morceaux + 1] = diff end
		if e.typeCal == "PLAYER" then morceaux[#morceaux + 1] = "invitation"
		elseif e.typeCal == "COMMUNITY_EVENT" then morceaux[#morceaux + 1] = "communauté" end
	end
	return table.concat(morceaux, " · ")
end

local function TexteCompte(d, long)
	if not d or not d.compte then return "" end
	local c, t = d.compte, {}
	if c.oui > 0 then t[#t + 1] = Hex(VERT) .. c.oui .. "|r oui" end
	if c.peut > 0 then t[#t + 1] = Hex(ORANGE) .. c.peut .. "|r peut-être" end
	if c.attente > 0 then t[#t + 1] = Hex(C.ors) .. c.attente .. "|r en attente" end
	if c.non > 0 then t[#t + 1] = Hex(ROUGE) .. c.non .. "|r non" end
	if #t == 0 then return long and "Personne pour l'instant" or "" end
	return table.concat(t, " · ")
end

--------------------------------------------------------------------------------
-- Événement ouvert : détail, inscrits, réponses
--------------------------------------------------------------------------------

-- lit l'événement ouvert dans le calendrier du jeu (après CALENDAR_OPEN_EVENT et ses mises à jour)
local function LireOuvert()
	local info = Appel("GetEventInfo")
	if type(info) ~= "table" then return end
	local titre = Chaine(info.title)
	if not titre then return end
	local quand = Horodatage(info.time)
	local cle
	local candidat = attendu and Trouver(attendu)
	if candidat and candidat.titre == titre and (not quand or candidat.quand == quand) then
		cle = candidat.cle
	else
		for _, e in ipairs((Lister())) do
			if e.titre == titre and (not quand or e.quand == quand) then cle = e.cle; break end
		end
	end
	if not cle then return end
	if attendu == cle then attendu = nil end
	ouvert = cle
	local d = {
		description = Chaine(info.description), createur = Chaine(info.creator), typeEv = Nombre(info.eventType),
		etat = Nombre(info.inviteStatus), inviteType = Nombre(info.inviteType), typeCal = Chaine(info.calendarType),
		verrouille = info.isLocked == true, invites = {}, compte = { oui = 0, peut = 0, attente = 0, non = 0 },
	}
	-- nom du donjon ou du raid (textures du type d'événement)
	local index = Nombre(info.textureIndex)
	if d.typeEv and index then
		local textures = Appel("EventGetTextures", d.typeEv)
		local tx = type(textures) == "table" and textures[index]
		if type(tx) == "table" then d.contenu, d.difficulte = Chaine(tx.title), Chaine(tx.difficultyName) end
	end
	local n = Nombre(Appel("GetNumInvites")) or 0
	for i = 1, n do
		local v = Appel("EventGetInvite", i)
		if type(v) == "table" and Chaine(v.name) then
			local etat = Nombre(v.inviteStatus)
			d.invites[#d.invites + 1] = { nom = Chaine(v.name), niveau = Nombre(v.level), classe = Chaine(v.classFilename),
				etat = etat, moi = v.inviteIsMine == true, mod = Chaine(v.modStatus) }
			local g = ETATS[etat or -1] and ETATS[etat][3]
			if g then d.compte[g] = d.compte[g] + 1 end
			if v.inviteIsMine == true and d.etat == nil then d.etat = etat end
		end
	end
	table.sort(d.invites, function(x, y)
		local gx = ORDRE_GROUPES[ETATS[x.etat or -1] and ETATS[x.etat][3] or ""] or 5
		local gy = ORDRE_GROUPES[ETATS[y.etat or -1] and ETATS[y.etat][3] or ""] or 5
		if gx ~= gy then return gx < gy end
		return x.nom < y.nom
	end)
	details[cle] = d
	if actionEnAttente and actionEnAttente.cle == cle then
		local a = actionEnAttente
		actionEnAttente = nil
		a.f()
	end
end

-- ouvre l'événement dans le calendrier du jeu (sans afficher son cadre) pour lire son détail
local function OuvrirEvenement(cle)
	local e = Trouver(cle)
	if not (e and e.coords and Existe("OpenEvent")) then return false end
	attendu = cle
	Appel("OpenEvent", e.coords[1], e.coords[2], e.coords[3])
	return true
end

local function EstInscription(e, d)
	local it = (d and d.inviteType) or (e and e.inviteType)
	if it then return it == INSCRIPTION end
	local etat = (d and d.etat) or (e and e.etat)
	if etat == ST.pasInscrit or etat == ST.inscrit then return true end
	return e and e.typeCal == "GUILD_EVENT" and etat == nil or false
end

-- j'ai créé l'événement (GetDayEvent.modStatus, ou mon nom parmi les inscrits)
local function EstOrganisateur(e, d)
	if e and e.mod == "CREATOR" then return true end
	for _, v in ipairs(d and d.invites or {}) do
		if v.moi and v.mod == "CREATOR" then return true end
	end
	return false
end

-- pourquoi on ne peut pas répondre (nil = on peut)
local function Empechement(e, d, maintenant)
	if not e then return "Choisis un événement." end
	local typeCal = (d and d.typeCal) or e.typeCal
	if typeCal == "GUILD_ANNOUNCEMENT" then return "Annonce de guilde : pas d'inscription." end
	if EstOrganisateur(e, d) then return "Tu as créé cet événement : modifie-le dans le calendrier du jeu." end
	if (d and d.verrouille) or e.verrouille then return "Événement verrouillé : les inscriptions sont closes." end
	if e.quand < (maintenant or Maintenant()) then return "Événement déjà commencé." end
	if not e.coords then return "Événement pas encore chargé : ouvre le calendrier du jeu." end
	if Appel("IsActionPending") == true then return "Réponse en cours d'envoi…" end
end

-- Répond à l'événement (quoi = "oui", "peut" ou "non"), une fois qu'il est ouvert
local function Repondre(cle, quoi)
	local function Envoyer()
		local e, d = Trouver(cle), details[cle]
		local inscription = EstInscription(e, d)
		local nom = (quoi == "peut" and "EventTentative") or (quoi == "non" and "EventDecline")
			or (inscription and "EventSignUp" or "EventAvailable")
		if not Existe(nom) and nom == "EventSignUp" then nom = "EventAvailable" end
		if not Existe(nom) then
			Erreur("Réponse impossible ici : ouvre le calendrier du jeu")
			return
		end
		derniereAction = GetTime()
		local ok = pcall(C_Calendar[nom])
		if not ok then Erreur("Le calendrier du jeu a refusé la réponse") end
		-- relire les inscrits un peu plus tard (le serveur met à jour l'événement)
		if C_Timer and C_Timer.After then
			C_Timer.After(1, function() if selection == cle then OuvrirEvenement(cle) end end)
		end
	end
	if ouvert == cle then
		Envoyer()
	else
		actionEnAttente = { cle = cle, f = Envoyer }
		if not OuvrirEvenement(cle) then actionEnAttente = nil end
	end
end

--------------------------------------------------------------------------------
-- Calendrier du jeu
--------------------------------------------------------------------------------

-- la fenêtre SMB Forever (strate haute) cacherait le calendrier du jeu : on la ferme d'abord
local function CacherFenetre()
	if ns.PageInterface and ns.PageInterface() and ns.BasculerInterface then ns.BasculerInterface() end
end

local function OuvrirCalendrier()
	CacherFenetre()
	if CalendrierAffiche() then return true end
	if ToggleCalendar then
		local ok = pcall(ToggleCalendar)
		if ok then return true end
	end
	Erreur("Le calendrier du jeu est introuvable sur ce client")
	return false
end

-- Bouton du jour d'aujourd'hui dans le calendrier du jeu
local function BoutonDuJour()
	local jour = tonumber(date("%d"))
	for i = 1, 42 do
		local b = _G["CalendarDayButton" .. i]
		if b and b.day == jour and b.monthOffset == 0 then return b end
	end
end

local function CreerSurLeJour()
	local b = BoutonDuJour()
	if b and CalendarDayContextMenu_CreateGuildEvent then
		local ok = pcall(CalendarDayContextMenu_CreateGuildEvent, b)
		if ok then return end
	end
	Erreur("Clic droit sur un jour du calendrier → « Créer un événement de guilde »")
end

-- le calendrier du jeu sur le mois en cours, puis sa fenêtre « Créer un événement de guilde »
ns.CreerEvenementGuilde = function()
	if not IsInGuild() then
		Erreur("Tu n'es pas dans une guilde")
		return
	end
	if not OuvrirCalendrier() then return end
	if Existe("SetAbsMonth") then
		local t = date("*t")
		Appel("SetAbsMonth", t.month, t.year)
		if CalendarFrame_Update then pcall(CalendarFrame_Update) end
	end
	-- les boutons des jours existent une fois le calendrier affiché
	if C_Timer and C_Timer.After then C_Timer.After(0.1, CreerSurLeJour) else CreerSurLeJour() end
end

--------------------------------------------------------------------------------
-- La page
--------------------------------------------------------------------------------

local MARGE = 16
local LARGEUR_DETAIL = 300
local HAUTEUR_JOUR, HAUTEUR_LIGNE, ECART = 28, 52, 6
local HAUTEUR_INVITE = 20

-- une page ouverte est redessinée sur les évènements du calendrier (regroupés)
local planifie = false
local function Planifier()
	if planifie or not (ns.PageInterface and ns.PageInterface() == "evenements") then return end
	if not (C_Timer and C_Timer.After) then
		if ns.MajInterface then ns.MajInterface() end
		return
	end
	planifie = true
	C_Timer.After(0.2, function()
		planifie = false
		if ns.PageInterface and ns.PageInterface() == "evenements" and ns.MajInterface then ns.MajInterface() end
	end)
end

local function Choisir(cle)
	selection = cle
	OuvrirEvenement(cle)
	if ns.MajInterface then ns.MajInterface() end
end

local function CreerJour(parent)
	local f = CreateFrame("Frame", nil, parent)
	f:SetHeight(HAUTEUR_JOUR)
	f.texte = UI.Texte(f, "GameFontNormal", C.ors)
	f.texte:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 2, 7)
	f.filet = UI.Filet(f)
	f.filet:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 0, 2)
	f.filet:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 2)
	return f
end

local function CreerLigne(parent)
	local r = UI.Rangee(parent, HAUTEUR_LIGNE)
	r.icone = r:CreateTexture(nil, "ARTWORK")
	r.icone:SetSize(32, 32)
	r.icone:SetPoint("LEFT", r, "LEFT", 10, 0)
	r.etat = UI.Texte(r, "GameFontHighlightSmall")
	r.etat:SetPoint("TOPRIGHT", r, "TOPRIGHT", -12, -11)
	r.etat:SetJustifyH("RIGHT")
	r.etat:SetWidth(110)
	r.compte = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.compte:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", -12, 11)
	r.compte:SetJustifyH("RIGHT")
	r.compte:SetWidth(200)
	r.titre = UI.Texte(r, "GameFontHighlight", C.texte)
	r.titre:SetPoint("TOPLEFT", r.icone, "TOPRIGHT", 10, 1)
	r.titre:SetPoint("RIGHT", r.etat, "LEFT", -8, 0)
	r.sous = UI.Texte(r, "GameFontHighlightSmall", C.gris)
	r.sous:SetPoint("TOPLEFT", r.titre, "BOTTOMLEFT", 0, -5)
	r.sous:SetPoint("RIGHT", r, "RIGHT", -12, 0)
	r:SetScript("OnClick", function(self) if self.cle then Choisir(self.cle) end end)
	return r
end

local function MajLigne(r, e, maintenant)
	local d = details[e.cle]
	r.cle = e.cle
	local ty = TYPES[(d and d.typeEv) or e.typeEv]
	r.icone:SetTexture(e.icone or (ty and ty[2]) or "Interface\\Icons\\INV_Misc_PocketWatch_01")
	r.icone:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	r.titre:SetText(e.titre)
	local morceaux = { Heure(e) }
	local typeTexte = TexteType(e, d)
	if typeTexte ~= "" then morceaux[#morceaux + 1] = typeTexte end
	local par = (d and d.createur) or e.invitePar
	if par then morceaux[#morceaux + 1] = "par " .. NomJoueur(par) end
	if e.quand < maintenant then morceaux[#morceaux + 1] = Hex(VERT) .. "en cours|r" end
	r.sous:SetText(table.concat(morceaux, " · "))
	local etat = (d and d.etat) or e.etat
	if e.typeCal == "GUILD_ANNOUNCEMENT" then
		r.etat:SetText("")
	elseif EstOrganisateur(e, d) then
		r.etat:SetText(Hex(C.ors) .. "Organisateur|r")
	elseif etat == nil and EstInscription(e, d) then
		r.etat:SetText(TexteEtat(ST.pasInscrit))
	else
		r.etat:SetText(TexteEtat(etat))
	end
	local compte = TexteCompte(d)
	r.compte:SetText(compte)
	r.sous:ClearAllPoints()
	r.sous:SetPoint("TOPLEFT", r.titre, "BOTTOMLEFT", 0, -5)
	if compte ~= "" then r.sous:SetPoint("RIGHT", r.compte, "LEFT", -8, 0) else r.sous:SetPoint("RIGHT", r, "RIGHT", -12, 0) end
	local choisi = (selection == e.cle)
	r:SetBackdropColor(unpack(choisi and C.actif or C.carte))
	r:Fort(choisi or etat == ST.invite)
end

local function CreerInvite(parent)
	local l = CreateFrame("Frame", nil, parent)
	l:SetHeight(HAUTEUR_INVITE)
	l.etat = UI.Texte(l, "GameFontHighlightSmall")
	l.etat:SetPoint("RIGHT", l, "RIGHT", -4, 0)
	l.etat:SetJustifyH("RIGHT")
	l.etat:SetWidth(80)
	l.nom = UI.Texte(l, "GameFontHighlightSmall")
	l.nom:SetPoint("LEFT", l, "LEFT", 2, 0)
	l.nom:SetPoint("RIGHT", l.etat, "LEFT", -6, 0)
	return l
end

local function CreerDetail(p)
	local c = UI.Carte(p, "Détail")
	c:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -64)
	c:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE, 12)
	c:SetWidth(LARGEUR_DETAIL)
	c.titre:SetPoint("RIGHT", c, "RIGHT", -14, 0)
	c.compte:SetText("")
	local INTERIEUR = LARGEUR_DETAIL - 28
	c.quand = UI.Texte(c, "GameFontHighlight", C.texte)
	c.quand:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -36)
	c.quand:SetWidth(INTERIEUR)
	c.genre = UI.Texte(c, "GameFontHighlightSmall", C.gris)
	c.genre:SetPoint("TOPLEFT", c.quand, "BOTTOMLEFT", 0, -6)
	c.genre:SetWidth(INTERIEUR)
	c.createur = UI.Texte(c, "GameFontHighlightSmall", C.gris)
	c.createur:SetPoint("TOPLEFT", c.genre, "BOTTOMLEFT", 0, -4)
	c.createur:SetWidth(INTERIEUR)
	c.monEtat = UI.Texte(c, "GameFontHighlight", C.texte)
	c.monEtat:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -98)
	c.monEtat:SetWidth(INTERIEUR)
	-- réponses
	local largeur = math.floor((INTERIEUR - 12) / 3)
	c.oui = UI.Bouton(c, "S'inscrire", "or", largeur, 26)
	c.oui:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -120)
	c.peut = UI.Bouton(c, "Peut-être", "fantome", largeur, 26)
	c.peut:SetPoint("LEFT", c.oui, "RIGHT", 6, 0)
	c.non = UI.Bouton(c, "Se désinscrire", "fantome", largeur, 26)
	c.non:SetPoint("LEFT", c.peut, "RIGHT", 6, 0)
	c.oui:SetScript("OnClick", function() if selection then Repondre(selection, "oui") end end)
	c.peut:SetScript("OnClick", function() if selection then Repondre(selection, "peut") end end)
	c.non:SetScript("OnClick", function() if selection then Repondre(selection, "non") end end)
	c.raison = UI.Texte(c, "GameFontHighlightSmall", C.gris)
	c.raison:SetPoint("TOPLEFT", c.oui, "BOTTOMLEFT", 0, -6)
	c.raison:SetWidth(INTERIEUR)
	-- description
	c.description = UI.Texte(c, "GameFontHighlightSmall", C.texte)
	c.description:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -172)
	c.description:SetWidth(INTERIEUR)
	c.description:SetHeight(52)
	c.description:SetWordWrap(true)
	c.description:SetJustifyV("TOP")
	-- inscrits
	c.tInscrits = UI.Texte(c, "GameFontNormalSmall", C.ors)
	c.tInscrits:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -232)
	c.tInscrits:SetText("Inscrits")
	c.compteInscrits = UI.Texte(c, "GameFontHighlightSmall", C.gris)
	c.compteInscrits:SetPoint("TOPRIGHT", c, "TOPRIGHT", -14, -232)
	c.compteInscrits:SetJustifyH("RIGHT")
	c.filet = UI.Filet(c)
	c.filet:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -248)
	c.filet:SetPoint("RIGHT", c, "RIGHT", -14, 0)
	c.liste = UI.Liste(c)
	c.liste:SetPoint("TOPLEFT", c, "TOPLEFT", 12, -254)
	c.liste:SetPoint("BOTTOMRIGHT", c, "BOTTOMRIGHT", -6, 10)
	c.inscritsVide = UI.Texte(c, "GameFontHighlightSmall", C.gris)
	c.inscritsVide:SetPoint("TOPLEFT", c, "TOPLEFT", 14, -258)
	c.inscritsVide:SetWidth(INTERIEUR)
	c.inscritsVide:SetWordWrap(true)
	c.lignes = {}
	c.elements = { c.quand, c.genre, c.createur, c.monEtat, c.oui, c.peut, c.non, c.raison, c.description,
		c.tInscrits, c.compteInscrits, c.filet, c.liste, c.inscritsVide }
	c.vide:SetText("Choisis un événement dans la liste pour voir son détail et t'inscrire.")

	c.Maj = function(e, maintenant)
		for _, el in ipairs(c.elements) do el:SetShown(e ~= nil) end
		c.vide:SetShown(e == nil)
		if not e then
			c.titre:SetText("Détail")
			return
		end
		local d = details[e.cle]
		c.titre:SetText(e.titre)
		c.quand:SetText(NomJour(e.quand, maintenant) .. " à " .. Heure(e))
		local typeTexte = TexteType(e, d)
		c.genre:SetText(typeTexte ~= "" and typeTexte or "Événement")
		local par = (d and d.createur) or e.invitePar
		c.createur:SetText(par and (((d and d.createur) and "Créé par " or "Invitation de ") .. NomJoueur(par)) or "")
		local etat = (d and d.etat) or e.etat
		local inscription = EstInscription(e, d)
		if EstOrganisateur(e, d) then
			c.monEtat:SetText("Ton état : " .. Hex(C.ors) .. "organisateur|r")
		elseif etat == nil and not inscription then
			c.monEtat:SetText("Ton état : " .. Hex(C.gris) .. "pas invité|r")
		else
			c.monEtat:SetText("Ton état : " .. TexteEtat(etat or ST.pasInscrit))
		end
		-- réponses
		c.oui:Ecrire(inscription and "S'inscrire" or "Accepter")
		c.non:Ecrire(inscription and "Se désinscrire" or "Refuser")
		local raison = Empechement(e, d, maintenant)
		local groupe = ETATS[etat or -1] and ETATS[etat][3]
		c.oui:Activer(not raison and groupe ~= "oui")
		c.peut:Activer(not raison and etat ~= ST.peutEtre and Existe("EventTentative"))
		c.non:Activer(not raison and groupe ~= "non" and not (inscription and (etat == nil or etat == ST.pasInscrit)))
		c.raison:SetText(raison or "")
		-- description et inscrits
		if d then
			c.description:SetText(d.description or "|cff9b9380Pas de description.|r")
			c.compteInscrits:SetText(TexteCompte(d, true))
			local y = 0
			for i, v in ipairs(d.invites) do
				local l = c.lignes[i]
				if not l then l = CreerInvite(c.liste.contenu); c.lignes[i] = l end
				l.nom:SetText(CouleurClasseTexte(v.classe) .. NomJoueur(v.nom) .. "|r"
					.. (v.niveau and v.niveau > 0 and ("  |cff9b9380" .. v.niveau .. "|r") or "")
					.. (v.mod == "CREATOR" and "  |cff9b9380(organisateur)|r" or "")
					.. (v.moi and "  |cff9b9380(toi)|r" or ""))
				l.etat:SetText(TexteEtat(v.etat))
				l:ClearAllPoints()
				l:SetPoint("TOPLEFT", c.liste.contenu, "TOPLEFT", 0, -y)
				l:SetPoint("RIGHT", c.liste.contenu, "RIGHT", 0, 0)
				l:Show()
				y = y + HAUTEUR_INVITE
			end
			for i = #d.invites + 1, #c.lignes do c.lignes[i]:Hide() end
			c.liste:Hauteur(y)
			c.inscritsVide:SetShown(#d.invites == 0)
			c.inscritsVide:SetText(e.typeCal == "GUILD_ANNOUNCEMENT" and "Une annonce n'a pas d'inscrits."
				or "Personne n'est encore inscrit.")
		else
			c.description:SetText("")
			c.compteInscrits:SetText("")
			for _, l in ipairs(c.lignes) do l:Hide() end
			c.liste:Hauteur(0)
			c.inscritsVide:Show()
			c.inscritsVide:SetText(e.coords and "Chargement du détail…"
				or "Détail pas encore chargé : ouvre le calendrier du jeu sur ce mois.")
		end
	end
	return c
end

local function CreerPage(parent)
	local p = CreateFrame("Frame", nil, parent)
	p:SetAllPoints()
	p.rafraichirAuto = false -- redessinée sur les évènements du calendrier (Planifier)

	-- en-tête
	p.titre = UI.Texte(p, "GameFontNormalLarge", C.ors)
	p.titre:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -18)
	p.titre:SetText("Événements")
	p.sous = UI.Texte(p, "GameFontHighlightSmall", C.gris)
	p.sous:SetPoint("TOPLEFT", p.titre, "BOTTOMLEFT", 0, -4)
	p.actualiser = UI.Bouton(p, "Actualiser", "fantome", 96, 28)
	p.actualiser:SetPoint("TOPRIGHT", p, "TOPRIGHT", -MARGE, -18)
	p.actualiser:SetScript("OnClick", function()
		Demander(true)
		if selection then OuvrirEvenement(selection) end
		if ns.MajInterface then ns.MajInterface() end
	end)
	UI.Infobulle(p.actualiser, "Actualiser", "Redemande les événements au serveur du jeu.")
	p.calendrier = UI.Bouton(p, "Ouvrir le calendrier", "fantome", 150, 28)
	p.calendrier:SetPoint("RIGHT", p.actualiser, "LEFT", -8, 0)
	p.calendrier:SetScript("OnClick", OuvrirCalendrier)
	UI.Infobulle(p.calendrier, "Calendrier du jeu", "Ouvre le calendrier du jeu (la fenêtre SMB Forever se ferme).")
	p.creer = UI.Bouton(p, "+ Créer un événement de guilde", "or", 214, 28)
	p.creer:SetPoint("RIGHT", p.calendrier, "LEFT", -8, 0)
	p.creer:SetScript("OnClick", function() ns.CreerEvenementGuilde() end)
	UI.Infobulle(p.creer, "Créer un événement de guilde", "Ouvre le calendrier du jeu sur « Créer un événement de guilde », pour aujourd'hui (choisis ensuite la date).")

	-- liste à gauche
	p.liste = UI.Liste(p)
	p.liste:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -64)
	p.liste:SetPoint("BOTTOMRIGHT", p, "BOTTOMRIGHT", -MARGE - LARGEUR_DETAIL - 10, 12)
	p.vide = UI.Texte(p, "GameFontHighlight", C.gris)
	p.vide:SetPoint("TOPLEFT", p.liste, "TOPLEFT", 4, -8)
	p.vide:SetPoint("RIGHT", p.liste, "RIGHT", -8, 0)
	p.vide:SetWordWrap(true)
	p.jours, p.lignes = {}, {}

	-- détail à droite
	p.detail = CreerDetail(p)

	-- sans calendrier sur ce client
	p.absent = UI.Texte(p, "GameFontHighlight", C.texte)
	p.absent:SetPoint("TOPLEFT", p, "TOPLEFT", MARGE, -80)
	p.absent:SetPoint("RIGHT", p, "RIGHT", -MARGE, 0)
	p.absent:SetWordWrap(true)
	p.absent:SetText("Le calendrier du jeu n'est pas lisible par l'addon sur ce client (pas d'API C_Calendar). "
		.. "Utilise « Ouvrir le calendrier » pour voir les événements de la guilde et t'y inscrire.")

	p:SetScript("OnShow", function() Demander() end)
	p:SetScript("OnHide", function()
		-- on referme l'événement ouvert pour le détail, sauf si le joueur regarde le calendrier du jeu
		if ouvert and not CalendrierAffiche() then Appel("CloseEvent") end
		ouvert, attendu, actionEnAttente = nil, nil, nil
	end)

	p.Maj = function()
		local dispo = Disponible()
		p.absent:SetShown(not dispo)
		p.liste:SetShown(dispo)
		p.detail:SetShown(dispo)
		p.actualiser:SetShown(dispo)
		p.creer:SetShown(dispo)
		if not dispo then
			p.vide:Hide()
			p.sous:SetText("Calendrier du jeu")
			return
		end
		Demander()
		local enGuilde = IsInGuild() and true or false
		p.creer:Activer(enGuilde)
		local liste, maintenant = Lister()
		p.sous:SetText(enGuilde and (HORIZON .. " prochains jours · guilde et invitations")
			or "Hors guilde : tes invitations seulement")

		-- sélection : garder l'événement choisi s'il est toujours là, sinon le premier
		local choisi
		for _, e in ipairs(liste) do if e.cle == selection then choisi = e end end
		if not choisi and liste[1] then
			choisi = liste[1]
			selection = choisi.cle
			-- (pas pendant que le joueur regarde le calendrier du jeu : il afficherait cet événement)
			if not CalendrierAffiche() then OuvrirEvenement(selection) end
		elseif not choisi then
			selection = nil
		end

		-- liste groupée par jour
		local y, nj, nl, jourPrecedent = 0, 0, 0, nil
		for _, e in ipairs(liste) do
			local cle = CleJour(math.max(e.quand, maintenant))
			if cle ~= jourPrecedent then
				jourPrecedent = cle
				nj = nj + 1
				local j = p.jours[nj]
				if not j then j = CreerJour(p.liste.contenu); p.jours[nj] = j end
				j.texte:SetText(NomJour(math.max(e.quand, maintenant), maintenant))
				j:ClearAllPoints()
				j:SetPoint("TOPLEFT", p.liste.contenu, "TOPLEFT", 0, -y)
				j:SetPoint("RIGHT", p.liste.contenu, "RIGHT", 0, 0)
				j:Show()
				y = y + HAUTEUR_JOUR + 4
			end
			nl = nl + 1
			local r = p.lignes[nl]
			if not r then r = CreerLigne(p.liste.contenu); p.lignes[nl] = r end
			MajLigne(r, e, maintenant)
			r:ClearAllPoints()
			r:SetPoint("TOPLEFT", p.liste.contenu, "TOPLEFT", 0, -y)
			r:SetPoint("RIGHT", p.liste.contenu, "RIGHT", 0, 0)
			r:Show()
			y = y + HAUTEUR_LIGNE + ECART
		end
		for i = nj + 1, #p.jours do p.jours[i]:Hide() end
		for i = nl + 1, #p.lignes do p.lignes[i]:Hide() end
		p.liste:Hauteur(y)
		p.vide:SetShown(#liste == 0)
		if not recu and GetTime() - derniereDemande < 10 then
			p.vide:SetText("Chargement du calendrier…")
		else
			p.vide:SetText("Aucun événement dans les " .. HORIZON .. " prochains jours."
				.. (enGuilde and " Crée le premier avec « Créer un événement de guilde »." or ""))
		end
		p.detail.Maj(choisi, maintenant)
	end
	-- ns.OuvrirInterface("evenements", cle) : choisit un événement
	p.Ouvrir = function(cle) if cle then Choisir(cle) end end
	return p
end
if ns.AjouterPage then ns.AjouterPage("evenements", CreerPage) end

-- Ouvre la page (sur un événement si cle est donnée)
ns.OuvrirEvenements = function(cle)
	if not ns.OuvrirInterface then return end
	if cle then ns.OuvrirInterface("evenements", cle) else ns.OuvrirInterface("evenements") end
end

-- /smb evenements, bouton du menu : ouvre la page, ou ferme la fenêtre si elle y est déjà
ns.BasculerEvenements = function()
	if ns.PageInterface and ns.PageInterface() == "evenements" then
		if ns.BasculerInterface then ns.BasculerInterface() end
	else
		ns.OuvrirEvenements()
	end
end

-- Pour l'Accueil : les n prochains événements { cle, titre, quand, jour, heure, date, etat, etatTexte,
-- type, icone } (liste vide tant que le calendrier n'a rien envoyé, ou sans C_Calendar)
ns.ProchainsEvenements = function(n)
	Demander()
	local liste, maintenant = Lister()
	local res = {}
	for i = 1, math.min(n or 3, #liste) do
		local e = liste[i]
		local d = details[e.cle]
		local etat = (d and d.etat) or e.etat
		if etat == nil and e.typeCal ~= "GUILD_ANNOUNCEMENT" and EstInscription(e, d) then etat = ST.pasInscrit end
		local jour = NomJour(math.max(e.quand, maintenant), maintenant)
		local ty = TYPES[(d and d.typeEv) or e.typeEv]
		res[i] = { cle = e.cle, titre = e.titre, quand = e.quand, jour = jour, heure = Heure(e),
			date = jour .. " · " .. Heure(e), etat = etat, etatTexte = TexteEtat(etat), type = TexteType(e, d),
			icone = e.icone or (ty and ty[2]) or "Interface\\Icons\\INV_Misc_PocketWatch_01" }
	end
	return res
end

--------------------------------------------------------------------------------
-- Bulle pour chaque nouvel événement de guilde du jeu
--------------------------------------------------------------------------------

local function TexteDate(e)
	return ("%s %d %s à %02d:%02d"):format(JOURS[Nombre(e.weekday) or 0] or "", Nombre(e.monthDay) or 0,
		MOIS[Nombre(e.month) or 0] or "", Nombre(e.hour) or 0, Nombre(e.minute) or 0)
end

local function LireEvenementsGuilde()
	if not (Existe("GetNumGuildEvents") and Existe("GetGuildEventInfo")) then return end
	-- (une fonction du jeu peut renvoyer autre chose qu'un nombre : on ne lit que des nombres)
	local n = Nombre(Appel("GetNumGuildEvents")) or 0
	local vus = Vus()
	local calme = premiereLecture or GetTime() - debut < CALME
	premiereLecture = false
	for i = 1, n do
		local e = Appel("GetGuildEventInfo", i)
		local titre = type(e) == "table" and Chaine(e.title)
		if titre then
			local cle = tostring(Chaine(e.eventID) or (titre .. tostring(e.month) .. tostring(e.monthDay)
				.. tostring(e.hour) .. tostring(e.minute)))
			if not vus[cle] then
				vus[cle] = time()
				if not calme and ns.Notifier then
					local fiche = FicheGuilde(e, i)
					ns.Notifier("evenements", "Nouvel événement de guilde", ("|cffffd100%s|r — %s"):format(titre, TexteDate(e)),
						nil, function() ns.OuvrirEvenements(fiche and fiche.cle) end)
				end
			end
		end
	end
	-- on oublie les vieux événements (plus de 60 jours)
	local limite = time() - 60 * 86400
	for cle, quand in pairs(vus) do
		if type(quand) ~= "number" or quand < limite then vus[cle] = nil end
	end
end

local function Rafraichir()
	if IsInGuild() and Existe("OpenCalendar") then Appel("OpenCalendar") end
end

ns.DiagEvenements = function(L)
	local liste = Lister()
	local api = {}
	for _, nom in ipairs({ "OpenCalendar", "GetDayEvent", "GetGuildEventInfo", "OpenEvent", "GetEventInfo",
		"EventGetInvite", "EventSignUp", "EventAvailable", "EventTentative", "EventDecline" }) do
		api[#api + 1] = nom .. "=" .. (Existe(nom) and "oui" or "non")
	end
	L(("événements : %s, %d événement(s) sur %d j, %s de guilde, reçu=%s, création=%s"):format(
		Disponible() and "calendrier lisible" or "calendrier illisible", #liste, HORIZON,
		tostring(Nombre(Appel("GetNumGuildEvents")) or 0), tostring(recu),
		tostring(CalendarDayContextMenu_CreateGuildEvent ~= nil or ToggleCalendar ~= nil)))
	L("  API : " .. table.concat(api, ", "))
end

--------------------------------------------------------------------------------
-- Évènements du jeu
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "CALENDAR_UPDATE_GUILD_EVENTS", "CALENDAR_UPDATE_EVENT_LIST",
	"CALENDAR_NEW_EVENT", "CALENDAR_UPDATE_PENDING_INVITES", "CALENDAR_OPEN_EVENT", "CALENDAR_UPDATE_EVENT",
	"CALENDAR_UPDATE_INVITE_LIST", "CALENDAR_CLOSE_EVENT", "CALENDAR_ACTION_PENDING", "CALENDAR_UPDATE_ERROR" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local premiere = true
ev:SetScript("OnEvent", function(_, event, arg1, arg2)
	if event == "PLAYER_ENTERING_WORLD" then
		if premiere then
			premiere = false
			debut = GetTime()
			C_Timer.After(10, Rafraichir)
			C_Timer.NewTicker(RAFRAICHIR, Rafraichir)
		end
	elseif event == "CALENDAR_OPEN_EVENT" or event == "CALENDAR_UPDATE_EVENT" or event == "CALENDAR_UPDATE_INVITE_LIST" then
		LireOuvert()
		Planifier()
	elseif event == "CALENDAR_CLOSE_EVENT" then
		ouvert = nil
		Planifier()
	elseif event == "CALENDAR_ACTION_PENDING" then
		Planifier()
	elseif event == "CALENDAR_UPDATE_ERROR" then
		-- seulement juste après une réponse envoyée d'ici
		if GetTime() - derniereAction < 5 then
			-- (le message est un texte, ou le nom d'une chaîne du jeu)
			local msg = (type(arg1) == "string" and arg1) or (type(arg2) == "string" and arg2) or nil
			if msg and type(_G[msg]) == "string" then msg = _G[msg] end
			Erreur("Calendrier : " .. (msg or "réponse refusée"))
		end
	else
		recu = true
		LireEvenementsGuilde()
		Planifier()
	end
end)
