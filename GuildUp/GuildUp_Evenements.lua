-- GuildUp : événements de guilde, avec le calendrier du jeu.
-- Le bouton « Événements » du volet ouvre la fenêtre « Créer un événement de guilde » du jeu
-- (comme le menu du clic droit sur un jour du calendrier). GuildUp surveille ensuite les
-- événements de guilde du jeu (C_Calendar.GetGuildEventInfo) : une bulle prévient quand un
-- nouveau apparaît.

local NOM_ADDON, ns = ...

local CALME = 30                -- les événements déjà prévus à la connexion ne font pas de bulle
local RAFRAICHIR = 300          -- redemande les événements au serveur toutes les 5 min
local MOIS = { "janv.", "févr.", "mars", "avril", "mai", "juin", "juil.", "août", "sept.", "oct.", "nov.", "déc." }
local JOURS = { "dim.", "lun.", "mar.", "mer.", "jeu.", "ven.", "sam." }

local debut = GetTime()
local premiereLecture = true

local function Erreur(t) if ns.Erreur then ns.Erreur(t) end end

local function Vus()
	local db = ns.DB and ns.DB()
	if not db then return {} end
	if type(db.evenementsVus) ~= "table" then db.evenementsVus = {} end
	return db.evenementsVus
end

--------------------------------------------------------------------------------
-- Ouvrir la création d'un événement de guilde du jeu
--------------------------------------------------------------------------------

-- Bouton du jour d'aujourd'hui dans le calendrier du jeu
local function BoutonDuJour()
	local jour = tonumber(date("%d"))
	for i = 1, 42 do
		local b = _G["CalendarDayButton" .. i]
		if b and b.day == jour and b.monthOffset == 0 then return b end
	end
end

local function CreerEvenementGuilde()
	local b = BoutonDuJour()
	if b and CalendarDayContextMenu_CreateGuildEvent then
		local ok = pcall(CalendarDayContextMenu_CreateGuildEvent, b)
		if ok then return end
	end
	Erreur("Clic droit sur un jour du calendrier → « Créer un événement de guilde »")
end

ns.BasculerEvenements = function()
	if not IsInGuild() then
		Erreur("Tu n'es pas dans une guilde")
		return
	end
	-- le calendrier du jeu, sur le mois en cours
	if not (CalendarFrame and CalendarFrame:IsShown()) then
		if ToggleCalendar then pcall(ToggleCalendar) end
	end
	if C_Calendar and C_Calendar.SetAbsMonth then
		local t = date("*t")
		pcall(C_Calendar.SetAbsMonth, t.month, t.year)
		if CalendarFrame_Update then pcall(CalendarFrame_Update) end
	end
	-- les boutons des jours existent une fois le calendrier affiché
	C_Timer.After(0.1, CreerEvenementGuilde)
end

local function OuvrirCalendrier()
	if not (CalendarFrame and CalendarFrame:IsShown()) and ToggleCalendar then pcall(ToggleCalendar) end
end

--------------------------------------------------------------------------------
-- Bulle pour chaque nouvel événement de guilde du jeu
--------------------------------------------------------------------------------

local function TexteDate(e)
	return ("%s %d %s à %02d:%02d"):format(JOURS[e.weekday] or "", e.monthDay or 0, MOIS[e.month] or "",
		e.hour or 0, e.minute or 0)
end

local function LireEvenementsGuilde()
	if not (C_Calendar and C_Calendar.GetNumGuildEvents and C_Calendar.GetGuildEventInfo) then return end
	local ok, n = pcall(C_Calendar.GetNumGuildEvents)
	if not ok or not n then return end
	local vus = Vus()
	local calme = premiereLecture or GetTime() - debut < CALME
	premiereLecture = false
	for i = 1, n do
		local okE, e = pcall(C_Calendar.GetGuildEventInfo, i)
		if okE and type(e) == "table" and e.title then
			local cle = tostring(e.eventID or (tostring(e.title) .. tostring(e.month) .. tostring(e.monthDay)
				.. tostring(e.hour) .. tostring(e.minute)))
			if not vus[cle] then
				vus[cle] = time()
				if not calme and ns.Notifier then
					ns.Notifier("evenements", "Nouvel événement de guilde", ("|cffffd100%s|r — %s"):format(e.title, TexteDate(e)),
						nil, OuvrirCalendrier)
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
	if IsInGuild() and C_Calendar and C_Calendar.OpenCalendar then pcall(C_Calendar.OpenCalendar) end
end

ns.DiagEvenements = function(L)
	local n = C_Calendar and C_Calendar.GetNumGuildEvents and select(2, pcall(C_Calendar.GetNumGuildEvents))
	L(("événements : calendrier du jeu, %s événement(s) de guilde à venir, création=%s"):format(
		tostring(n), tostring(CalendarDayContextMenu_CreateGuildEvent ~= nil or ToggleCalendar ~= nil)))
end

--------------------------------------------------------------------------------
-- Évènements du jeu
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "PLAYER_ENTERING_WORLD", "CALENDAR_UPDATE_GUILD_EVENTS", "CALENDAR_UPDATE_EVENT_LIST" }) do
	pcall(ev.RegisterEvent, ev, nom)
end
local premiere = true
ev:SetScript("OnEvent", function(_, event)
	if event == "PLAYER_ENTERING_WORLD" then
		if premiere then
			premiere = false
			debut = GetTime()
			C_Timer.After(10, Rafraichir)
			C_Timer.NewTicker(RAFRAICHIR, Rafraichir)
		end
	else
		LireEvenementsGuilde()
	end
end)
