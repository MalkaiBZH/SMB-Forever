-- GuildUpSMB : taux de butin des monstres, lus dans GuildUp_Taux.lua et montrés dans la fiche du WoWdex
-- (GuildUp_Wowdex.lua).
--
-- Le WoWdex mesure déjà ses propres taux à partir des corps que la guilde fouille : ceux-ci passent toujours
-- avant. Les données d'ici ne servent qu'aux objets que personne n'a encore vu tomber, et à ceux que le
-- bestiaire ne liste pas (il écarte le butin commun, lâché par plus de 40 monstres).
--
-- Aucun réseau, aucune dépendance : GuildUp_Taux.lua est généré hors ligne par outils/generer_butin.py depuis
-- la base ForeverDB, qui réunit elle-même QuestieDB, VMaNGOS, cMaNGOS et pfQuest. Les taux arrivent donc avec
-- la mise à jour de l'addon, comme le bestiaire, et il n'y a rien à installer.
--
-- Ligne de ns.TAUX_BUTIN, tout en base 36 : pnj|objet:chance,objet:chance,… la chance en dix-millièmes
-- (10000 = 100 %, 0 = lâché par ce monstre mais taux inconnu), les meilleures d'abord.
--
-- Fournit : ns.ButinBase(pnj), ns.TauxBase(pnj, objet).

local NOM_ADDON, ns = ...

local brut                -- [pnj] = "objet:chance,…", la ligne telle quelle
local lu = {}             -- [pnj] = liste de { objet, taux } déjà découpée, ou false

-- une ligne par monstre, repérée à la première demande seulement
local function Index()
	if brut then return brut end
	brut = {}
	for ligne in (ns.TAUX_BUTIN or ""):gmatch("[^\r\n]+") do
		local pnj, reste = ligne:match("^(%w+)|(.*)$")
		if pnj then brut[tonumber(pnj, 36) or 0] = reste end
	end
	ns.TAUX_BUTIN = nil -- le texte brut n'est plus utile
	return brut
end

-- une chance en dix-millièmes → un pourcentage, ou nil quand la base ne connaît pas le taux
local function Pourcent(chance)
	if not chance or chance <= 0 then return nil end
	return chance / 100
end

-- butin d'un monstre d'après la base : { { objet = id, taux = pourcentage ou nil }, … }, 20 au plus,
-- du plus probable au plus rare (l'ordre du fichier). Liste vide si le monstre n'y est pas.
ns.ButinBase = function(pnj)
	pnj = tonumber(pnj)
	if not pnj then return {} end
	local garde = lu[pnj]
	if garde ~= nil then return garde or {} end
	local ligne = Index()[pnj]
	if not ligne then lu[pnj] = false; return {} end
	local res = {}
	for o, c in ligne:gmatch("(%w+):(%w+)") do
		res[#res + 1] = { objet = tonumber(o, 36), taux = Pourcent(tonumber(c, 36)) }
	end
	lu[pnj] = (#res > 0) and res or false
	return res
end

-- taux de la base pour un objet sur un monstre, en pourcentage, ou nil (inconnu ou absent de la base)
ns.TauxBase = function(pnj, objet)
	objet = tonumber(objet)
	if not objet then return nil end
	for _, e in ipairs(ns.ButinBase(pnj)) do
		if e.objet == objet then return e.taux end
	end
	return nil
end
