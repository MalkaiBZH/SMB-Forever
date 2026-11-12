-- GuildUp : « Besoin d'aide ». Un appel à la guilde (préfixe "GuildUpAid") pour une quête difficile,
-- une escorte, un élite… avec la zone et la position :
--   "H~carte~x~y~niveau~zone~texte"   (x, y en dix-millièmes)
-- Les membres qui ont le niveau pour aider (au moins le niveau de l'appelant moins 3) reçoivent une
-- bulle ; un clic pose un repère sur la carte du monde. Son plus marqué pour ceux de la même zone.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpAid"
local ATTENTE = 60          -- secondes entre deux appels
local ECART_NIVEAU = 3      -- on prévient ceux qui ont au moins (niveau de l'appelant - 3)

local dernierAppel = 0

local function Normaliser(nom) return ns.Normaliser and ns.Normaliser(nom) or nom end
local function TestSolo() return ns.TestSolo and ns.TestSolo() end
local function NomCourt(nom) return ((nom or "?"):gsub("%-", " "):gsub(" %(test%)$", "")) end
local function Erreur(t) if ns.Erreur then ns.Erreur(t) end end

local function MaPosition()
	if not (C_Map and C_Map.GetBestMapForUnit) then return nil end
	local carte = C_Map.GetBestMapForUnit("player")
	if not carte then return nil end
	local pos = C_Map.GetPlayerMapPosition and C_Map.GetPlayerMapPosition(carte, "player")
	if not pos then return carte, nil, nil end
	local x, y = pos:GetXY()
	return carte, x, y
end

local function Envoyer(texte)
	if GetTime() - dernierAppel < ATTENTE and dernierAppel > 0 then
		Erreur(("Attends encore %d s avant un nouvel appel"):format(ATTENTE - (GetTime() - dernierAppel)))
		return
	end
	if not IsInGuild() then Erreur("Tu n'es pas dans une guilde"); return end
	dernierAppel = GetTime()
	local carte, x, y = MaPosition()
	texte = (texte or ""):gsub("[~|\r\n]", " ")
	texte = ns.CouperUTF8 and ns.CouperUTF8(texte, nil, 60) or texte:sub(1, 60)
	local zone = (GetZoneText and GetZoneText()) or ""
	local msg = ("H~%d~%d~%d~%d~%s~%s"):format(carte or 0, math.floor((x or 0) * 10000),
		math.floor((y or 0) * 10000), UnitLevel("player") or 0, zone:gsub("~", " "), texte)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end
	if ns.Notifier then ns.Notifier("aide", "Demande d'aide", "Ton appel est parti vers la guilde.", "aucun", function() end) end
end

StaticPopupDialogs["GUILDUP_AIDE"] = {
	text = "Besoin d'aide de la guilde ?\nDis en quelques mots pourquoi (facultatif) :",
	button1 = "Appeler",
	button2 = "Annuler",
	hasEditBox = true,
	maxLetters = 60,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnShow = function(self)
		local boite = self.editBox or self.EditBox
		if boite then boite:SetText(""); boite:SetFocus() end
	end,
	OnAccept = function(self)
		local boite = self.editBox or self.EditBox
		Envoyer(boite and boite:GetText() or "")
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		Envoyer(self:GetText() or "")
		parent:Hide()
	end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

ns.DemanderAide = function()
	StaticPopup_Show("GUILDUP_AIDE")
end

-- Repère sur la carte du monde à la position de l'appel
local function MontrerSurCarte(carte, x, y)
	if not carte or carte == 0 then return end
	if x and x > 0 and C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		pcall(C_Map.SetUserWaypoint, UiMapPoint.CreateFromCoordinates(carte, x, y))
		if C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint then
			pcall(C_SuperTrack.SetSuperTrackedUserWaypoint, true)
		end
	end
	if OpenWorldMap then
		pcall(OpenWorldMap, carte)
	elseif WorldMapFrame then
		if not WorldMapFrame:IsShown() and ToggleWorldMap then pcall(ToggleWorldMap) end
		if WorldMapFrame.SetMapID then pcall(WorldMapFrame.SetMapID, WorldMapFrame, carte) end
	end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	if Normaliser(expediteur) == Normaliser(UnitName("player")) and not TestSolo() then return end
	local carte, x, y, niveau, zone, texte = msg:match("^H~(%d+)~(%d+)~(%d+)~(%d+)~([^~]*)~?(.*)$")
	if not carte then return end
	carte, x, y, niveau = tonumber(carte), tonumber(x) / 10000, tonumber(y) / 10000, tonumber(niveau) or 0
	-- seulement ceux qui ont le niveau pour aider
	if (UnitLevel("player") or 0) < niveau - ECART_NIVEAU then return end
	local memeZone = zone ~= "" and GetZoneText and GetZoneText() == zone
	if ns.Notifier then
		ns.Notifier("aide", "Demande d'aide", ("%s (niv %d) a besoin d'aide · %s%s"):format(NomCourt(expediteur), niveau,
			zone ~= "" and zone or "?", texte ~= "" and (" : « " .. texte .. " »") or ""),
			memeZone and "RAID_WARNING" or nil, function() MontrerSurCarte(carte, x, y) end)
	end
end

do
	local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
	if inscription then pcall(inscription, PREFIXE) end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, a1, a2, a3, a4) Recevoir(a1, a2, a3, a4) end)
