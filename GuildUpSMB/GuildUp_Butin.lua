-- GuildUpSMB : taux de butin de la base ForeverDB.
-- Pont vers l'addon ForeverDB (https://github.com/foreverfraddons/forever-db, GPL-3.0), qui réunit QuestieDB,
-- VMaNGOS, cMaNGOS classic-db, pfQuest et les relevés en jeu du recorder de Command Center. Il complète les taux
-- que la guilde mesure elle-même dans le WoWdex : la mesure de la guilde passe toujours avant, la base ne sert
-- qu'aux objets que personne n'a encore vu tomber.
-- Aucun protocole réseau : ce module ne fait que lire un autre addon présent sur le disque du joueur. Un addon
-- WoW n'a pas d'accès réseau, il n'y a donc rien à interroger en ligne.
--
-- ForeverDB est une dépendance *optionnelle* (« ## OptionalDeps » du .toc) : sans lui tout marche comme avant,
-- seuls les taux de la base manquent. Il est « LoadOnDemand », donc il ne coûte rien tant qu'on ne le charge pas :
-- on ne le charge qu'à la première fiche ouverte dans le WoWdex.
--
-- Sa table D.drop est rangée par objet : drop[objet] = { pnj, chance, pnj, chance, … }, la chance en dix-millièmes
-- (10000 = 100 %, 0 = « lâché ici, taux inconnu »). Pour le butin d'un monstre il faut donc la parcourir à l'envers.
-- Construire l'index inverse complet coûterait 179 000 entrées de table : on cherche plutôt monstre par monstre,
-- en gardant le résultat en cache. Dans l'autre sens (les sources d'un objet), c'est un accès direct.
--
-- Fournit : ns.BaseButin (la table ou nil), ns.ButinBase(pnj), ns.TauxBase(pnj, objet), ns.SourcesBase(objet),
-- ns.MetaBase().

local NOM_ADDON, ns = ...

local ADDON_BASE = "ForeverDB"
local MAX_BUTIN = 20     -- objets au plus rendus pour un monstre

local cache = {}         -- [pnj] = liste de { objet, taux } ou false (rien dans la base)
local essaye = false     -- on n'essaie de charger qu'une fois par session

--------------------------------------------------------------------------------
-- Chargement
--------------------------------------------------------------------------------

-- la base, chargée à la demande, ou nil si l'addon est absent ou refuse de se charger
local function Base()
	if _G[ADDON_BASE] then return _G[ADDON_BASE] end
	if essaye then return nil end
	essaye = true
	local charger = (C_AddOns and C_AddOns.LoadAddOn) or LoadAddOn
	if not charger then return nil end
	pcall(charger, ADDON_BASE)
	return _G[ADDON_BASE]
end

-- ForeverDB est-il installé ? (sans le charger)
ns.BaseButinPresente = function()
	if _G[ADDON_BASE] then return true end
	local info = (C_AddOns and C_AddOns.GetAddOnInfo) or GetAddOnInfo
	if not info then return false end
	local ok, nom = pcall(info, ADDON_BASE)
	return (ok and nom) and true or false
end

-- la table de la base, ou nil : pour les autres modules qui veulent fouiller eux-mêmes
ns.BaseButin = function()
	return Base()
end

-- date du build de la base, ou nil (« 2026-11-20 »)
ns.MetaBase = function()
	local D = Base()
	local m = D and D.meta
	return m and m.build or nil
end

--------------------------------------------------------------------------------
-- Lecture
--------------------------------------------------------------------------------

-- une chance en dix-millièmes → un pourcentage, ou nil quand la base ne connaît pas le taux
local function Pourcent(chance)
	chance = tonumber(chance)
	if not chance or chance <= 0 then return nil end
	return chance / 100
end

-- du meilleur taux au plus faible ; les taux inconnus à la fin, par numéro d'objet
local function Avant(a, b)
	if (a.taux == nil) ~= (b.taux == nil) then return b.taux == nil end
	if a.taux and b.taux and a.taux ~= b.taux then return a.taux > b.taux end
	return (a.objet or a.pnj or 0) < (b.objet or b.pnj or 0)
end

-- butin d'un monstre d'après la base : { { objet = id, taux = pourcentage ou nil }, … }, 20 au plus,
-- du plus probable au plus rare. Liste vide si l'addon est absent ou ne connaît pas ce monstre.
ns.ButinBase = function(pnj)
	pnj = tonumber(pnj)
	if not pnj then return {} end
	local garde = cache[pnj]
	if garde ~= nil then return garde or {} end
	local D = Base()
	if not D or type(D.drop) ~= "table" then return {} end -- (pas de cache : rien n'a été cherché)
	local res = {}
	for objet, v in pairs(D.drop) do
		if type(v) == "table" then
			for i = 1, #v - 1, 2 do
				if v[i] == pnj then
					res[#res + 1] = { objet = objet, taux = Pourcent(v[i + 1]) }
					break
				end
			end
		end
	end
	table.sort(res, Avant)
	for i = #res, MAX_BUTIN + 1, -1 do res[i] = nil end
	cache[pnj] = (#res > 0) and res or false
	return res
end

-- taux de la base pour un objet sur un monstre, en pourcentage, ou nil (inconnu ou pas dans la base)
ns.TauxBase = function(pnj, objet)
	pnj, objet = tonumber(pnj), tonumber(objet)
	if not pnj or not objet then return nil end
	local D = Base()
	local v = D and type(D.drop) == "table" and D.drop[objet]
	if type(v) ~= "table" then return nil end
	for i = 1, #v - 1, 2 do
		if v[i] == pnj then return Pourcent(v[i + 1]) end
	end
	return nil
end

-- les monstres qui lâchent un objet d'après la base : { { pnj = id, taux = pourcentage ou nil }, … },
-- du meilleur taux au plus faible. Accès direct : D.drop est déjà rangée par objet.
ns.SourcesBase = function(objet)
	objet = tonumber(objet)
	if not objet then return {} end
	local D = Base()
	local v = D and type(D.drop) == "table" and D.drop[objet]
	if type(v) ~= "table" then return {} end
	local res = {}
	for i = 1, #v - 1, 2 do
		res[#res + 1] = { pnj = v[i], taux = Pourcent(v[i + 1]) }
	end
	table.sort(res, Avant)
	return res
end
