-- GuildUpSMB : mode calme, « ne pas déranger » (/smb calme, préfixe "GuildUpNpd").
-- Le joueur coupe les bulles de l'addon quand il veut être tranquille (donjon, soirée raid, farm) :
-- ns.Notifier (GuildUp_Bouton.lua) ne montre plus rien et compte ce qui a été coupé, par catégorie.
-- À la sortie du mode, un message privé dit ce qui est passé pendant ce temps ; rien n'est rejoué.
-- Le mode suit aussi le « Ne pas déranger » du jeu (/dnd) quand db.calmeSuitDnd n'est pas false :
-- passer en /dnd met le mode calme, en sortir le retire (mais /smb calme reste indépendant ensuite).
-- Les autres membres le voient : une icône de lune devant le nom dans la page Guilde et une ligne
-- dans l'infobulle, pour éviter de chuchoter à quelqu'un qui ne répondra pas.
--   "C~1" / "C~0"   j'entre dans le mode calme / j'en sors (envoyé à chaque changement)
--   "Q"             à la connexion : « dites-moi qui est en mode calme » (seuls ceux qui y sont
--                   répondent, après un délai au hasard, pour ne pas parler tous en même temps)
-- L'état des autres n'est pas gardé d'une session à l'autre : il se redemande à chaque connexion.
-- Mon propre mode est gardé dans GuildUpDB (db.calme, db.calmeFin), commun à mes personnages : si je
-- me déconnecte en mode calme, j'y reviens en mode calme.

local NOM_ADDON, ns = ...

local PREFIXE = "GuildUpNpd"
local ICONE = "Interface\\Icons\\Spell_Nature_Sleep"
local MAX_MINUTES = 12 * 60

local Normaliser = ns.Normaliser
local NomJoueur = ns.NomJoueur -- (affichage : « Pseudo (Prénom) »)
local MaCle = ns.MaCle

local calmes = {}      -- [clé] = true : membres en mode calme (cette session seulement)
local coupees = {}     -- [catégorie] = nombre de bulles coupées depuis l'entrée dans le mode
local pret = false
local suitDnd         -- dernier état du /dnd du jeu, pour ne réagir qu'aux changements

local NOMS = {         -- catégories des bulles, pour le compte rendu (GuildUp_Options.lua)
	demandes = "demande", quetes = "quête", tirages = "jeu", sondages = "sondage",
	aide = "appel à l'aide", annonces = "annonce", evenements = "événement", version = "version",
	metiers = "métier", membres = "membre", groupes = "groupe", layers = "layer",
}

local function DB() return ns.DB and ns.DB() end

--------------------------------------------------------------------------------
-- Mon mode calme
--------------------------------------------------------------------------------

-- true si je suis en mode calme (la durée choisie met fin au mode toute seule)
ns.NePasDeranger = function()
	local db = DB()
	if not db or not db.calme then return false end
	if db.calmeFin and time() >= db.calmeFin then
		-- la durée est passée : on sort du mode (et on le dit aux autres)
		if ns.BasculerCalme then ns.BasculerCalme(false) end
		return false
	end
	return true
end

-- ns.Notifier appelle ceci pour chaque bulle qu'il n'a pas montrée
ns.CompterBulleCoupee = function(categorie)
	local c = categorie or "autres"
	coupees[c] = (coupees[c] or 0) + 1
end

-- « 4 bulles : 2 demandes, 1 quête, 1 tirage », ou nil si rien n'a été coupé
local function Resume()
	local total, mots = 0, {}
	for c, n in pairs(coupees) do
		total = total + n
		local nom = NOMS[c] or c
		mots[#mots + 1] = { texte = ("%d %s%s"):format(n, nom, n > 1 and "s" or ""), n = n }
	end
	if total == 0 then return nil end
	table.sort(mots, function(a, b) return a.n > b.n end)
	local liste = {}
	for i = 1, math.min(#mots, 4) do liste[i] = mots[i].texte end
	return ("%d bulle%s pendant que tu étais tranquille : %s."):format(total, total > 1 and "s" or "",
		table.concat(liste, ", "))
end

local function Envoyer(msg)
	if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end
end

-- Entrer dans le mode calme ou en sortir. minutes : durée (nil = jusqu'à nouvel ordre).
ns.BasculerCalme = function(oui, minutes)
	local db = DB()
	if not db then return end
	if oui == nil then oui = not db.calme end
	local avant = db.calme and true or false
	db.calme = oui or nil
	db.calmeFin = nil
	if oui and minutes then
		minutes = math.max(1, math.min(tonumber(minutes) or 0, MAX_MINUTES))
		db.calmeFin = time() + minutes * 60
	end
	if oui then
		if not avant then coupees = {} end
		local fin = db.calmeFin and (" pendant %d min"):format(math.ceil((db.calmeFin - time()) / 60)) or ""
		print(("|cffffd100SMB Forever|r : mode calme%s. Les bulles sont coupées, la guilde voit que tu ne veux pas être dérangé."):format(fin))
	else
		local resume = Resume()
		coupees = {}
		print("|cffffd100SMB Forever|r : fin du mode calme." .. (resume and (" " .. resume) or ""))
	end
	if avant ~= (oui and true or false) then Envoyer(oui and "C~1" or "C~0") end
	if ns.MajInterface then ns.MajInterface() end
	if ns.MajBouton then ns.MajBouton() end
end

--------------------------------------------------------------------------------
-- Les autres membres
--------------------------------------------------------------------------------

ns.CalmeDe = function(cle)
	if not cle then return false end
	if cle == MaCle() then return ns.NePasDeranger() end
	return calmes[cle] == true
end

-- Icône à mettre devant le nom d'un membre en mode calme (chaîne vide sinon)
ns.IconeCalme = function(cle, taille)
	if not ns.CalmeDe(cle) then return "" end
	return ("|T%s:%d:%d:0:0|t"):format(ICONE, taille or 12, taille or 12)
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if not cle or cle == MaCle() then return end
	if msg == "Q" then
		-- seuls ceux qui sont en mode calme répondent : un membre qui ne dit rien n'y est pas
		if pret and ns.NePasDeranger() then
			C_Timer.After(1 + math.random() * 4, function()
				if ns.NePasDeranger() then Envoyer("C~1") end
			end)
		end
		return
	end
	local etat = msg:match("^C~([01])$")
	if not etat then return end
	calmes[cle] = etat == "1" or nil
	if ns.MajInterface then ns.MajInterface() end
end

--------------------------------------------------------------------------------
-- Connexion, et suivi du « Ne pas déranger » du jeu
--------------------------------------------------------------------------------

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
pcall(ev.RegisterEvent, ev, "PLAYER_FLAGS_CHANGED")
local premiere = true
ev:SetScript("OnEvent", function(_, event, unite)
	if event == "PLAYER_FLAGS_CHANGED" then
		if unite and unite ~= "player" then return end
		local db = DB()
		if not db or db.calmeSuitDnd == false or not UnitIsDND then return end
		local dnd = UnitIsDND("player") and true or false
		if suitDnd == nil then suitDnd = dnd; return end
		if dnd ~= suitDnd then
			suitDnd = dnd
			-- le /dnd du jeu entre et sort du mode calme, sans durée
			if dnd ~= (db.calme and true or false) then ns.BasculerCalme(dnd) end
		end
	elseif event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		C_Timer.After(16, function()
			pret = true
			local db = DB()
			if UnitIsDND then suitDnd = UnitIsDND("player") and true or false end
			Envoyer("Q")
			-- je me suis déconnecté en mode calme : la guilde doit le savoir
			if db and ns.NePasDeranger() then
				C_Timer.After(2, function() if ns.NePasDeranger() then Envoyer("C~1") end end)
			end
		end)
	end
end)

-- La durée choisie doit finir le mode même si rien ne l'interroge (ns.NePasDeranger s'en charge)
if C_Timer and C_Timer.NewTicker then
	C_Timer.NewTicker(15, function()
		local db = DB()
		if db and db.calme and db.calmeFin then ns.NePasDeranger() end
	end)
end

ns.Ecouter(PREFIXE, Recevoir)
