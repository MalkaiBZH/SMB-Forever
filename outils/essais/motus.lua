-- GuildUpSMB : essai du Motus dans le faux client (outils/essais/faux_client.lua).
-- Charge le kit d'interface, la liste de mots et GuildUp_Motus.lua, puis déroule un scénario : mot du jour
-- identique pour tout le monde, grille fermée au sol, bulle au décollage, saisie, couleurs d'une proposition
-- (lettres en double comprises), victoire et points, message envoyé à la guilde, score reçu d'un membre,
-- classement, chrono qui ne tourne qu'en vol, grille figée à l'atterrissage, et remise à zéro le lendemain.
-- Usage, depuis la racine du dépôt :  lua outils/essais/motus.lua GuildUpSMB   (code de sortie 1 si un essai rate)
local client = dofile((arg[0]:gsub("[^/\\]*$", "")) .. "faux_client.lua")
local ns, db, cadres = client.ns, client.db, client.cadres
local envoyes, bulles = client.envoyes, client.bulles
local Factice, Charger, Etape = client.Factice, client.Charger, client.Etape

-- le vol, piloté par l'essai
local surLeVol = false
UnitOnTaxi = function() return surLeVol end

-- la page Jeux : l'addon y pose son onglet par ns.AjouterJeu
local CreerOnglet, idJeu
ns.AjouterJeu = function(nom, creer, id) CreerOnglet, idJeu = creer, id end

Charger("GuildUp_Style.lua")

-- Le faux client accepte n'importe quelle méthode sur ses cadres factices, y compris SetScript sur un
-- FontString, que le jeu refuserait. On le lui interdit ici : une infobulle accrochée sur le titre d'une
-- carte au lieu d'un cadre levait une erreur en jeu, avalée par le pcall de GuildUp_Tirage.lua, et laissait
-- l'onglet vide sans rien dire.
local VraiTexte = ns.UI.Texte
ns.UI.Texte = function(...)
	local t = VraiTexte(...)
	t.SetScript = function() error("SetScript sur un FontString : le jeu refuserait", 2) end
	return t
end

Charger("GuildUp_Mots.lua")
local MOTS_BRUTS = ns.MOTS_MOTUS
Charger("GuildUp_Motus.lua")

local ev
for _, f in ipairs(cadres) do if f.__scripts.OnEvent then ev = f end end
local OnEvent, OnUpdate = ev.__scripts.OnEvent, ev.__scripts.OnUpdate
local ecouteur = client.Ecouteur()

-- toutes les listes de mots, relues du texte brut gardé avant que l'addon le libère
local LISTES = {}
for n, bloc in MOTS_BRUTS:gmatch("(%d+)|([^\r\n]*)") do
	local taille = tonumber(n)
	LISTES[taille] = {}
	for i = 1, #bloc - taille + 1, taille do LISTES[taille][bloc:sub(i, i + taille - 1)] = true end
end

local JOUR = math.floor(ns.Maintenant() / 86400)

Etape("l'onglet est déclaré", function()
	assert(type(CreerOnglet) == "function", "pas de CreerOnglet")
	assert(idJeu == "motus", "mauvais identifiant d'onglet : " .. tostring(idJeu))
	assert(ns.MOTS_MOTUS == nil or type(ns.MOTS_MOTUS) == "string", "MOTS_MOTUS mal rangé")
end)

OnEvent(ev, "PLAYER_LOGIN")

Etape("un « Q » part à la connexion", function()
	assert(envoyes[1] == "Q", "pas de demande de scores : " .. tostring(envoyes[1]))
end)

Etape("le mot du jour vient de la liste et ne bouge pas", function()
	local d = db.motus and db.motus.partie
	assert(type(d) == "table" and type(d.mot) == "string", "aucune partie créée")
	assert(d.jour == JOUR, "mauvais jour : " .. tostring(d.jour))
	assert(#d.mot >= 5 and #d.mot <= 8, "longueur inattendue : " .. #d.mot)
	assert(LISTES[#d.mot] and LISTES[#d.mot][d.mot], "le mot n'est pas dans la liste : " .. d.mot)
	local avant = d.mot
	OnEvent(ev, "PLAYER_ENTERING_WORLD")
	assert(db.motus.partie.mot == avant, "le mot a changé sans changer de jour")
end)

local MOT = db.motus.partie.mot

-- l'onglet
local page = Factice("Frame")
page.__l = 762
local onglet = CreerOnglet(page)

Etape("au sol, rien à jouer", function()
	onglet.__scripts.OnShow(onglet)
	assert(onglet.clavier.__montre == false, "le clavier s'affiche au sol")
	assert(onglet.consigne.__texte:find("vol"), "la consigne ne parle pas du vol : " .. onglet.consigne.__texte)
end)

Etape("le chrono ne tourne pas au sol", function()
	for _ = 1, 10 do OnUpdate(ev, 0.5) end
	assert(db.motus.partie.secondes == 0, "le chrono a tourné au sol : " .. db.motus.partie.secondes)
end)

Etape("décollage : la bulle propose le mot du jour", function()
	surLeVol = true
	OnUpdate(ev, 1)
	local b = bulles[#bulles]
	assert(b and b.titre == "Motus", "pas de bulle au décollage")
	assert(b.texte:find("lettres"), "bulle inattendue : " .. b.texte)
	assert(onglet.clavier.__montre == true, "le clavier reste caché en vol")
end)

Etape("le chrono tourne en vol, l'onglet ouvert", function()
	for _ = 1, 8 do OnUpdate(ev, 0.5) end
	assert(db.motus.partie.secondes >= 3.9, "le chrono n'a pas tourné : " .. db.motus.partie.secondes)
end)

Etape("la première lettre est donnée, les touches écrivent la suite", function()
	assert(onglet.grille.cases[1][1].lettre.__texte == MOT:sub(1, 1), "première lettre absente")
	local a = onglet.clavier.touches["A"]
	a.__scripts.OnClick(a)
	assert(onglet.champ:GetText() == "A", "la touche n'a rien écrit : " .. tostring(onglet.champ:GetText()))
	onglet.clavier.retour.__scripts.OnClick(onglet.clavier.retour)
	assert((onglet.champ:GetText() or "") == "", "l'effacement n'a rien fait")
end)

Etape("une proposition trop courte est refusée", function()
	onglet.champ:SetText("AB")
	onglet.champ.__scripts.OnTextChanged(onglet.champ)
	onglet.clavier.valider.__scripts.OnClick(onglet.clavier.valider)
	assert(#db.motus.partie.lignes == 0, "une proposition trop courte est passée")
end)

-- une proposition fausse : des lettres du mot, mal placées, et une lettre absente à coup sûr
local function Proposer(mot)
	onglet.champ:SetText(mot:sub(2))
	onglet.champ.__scripts.OnTextChanged(onglet.champ)
	onglet.clavier.valider.__scripts.OnClick(onglet.clavier.valider)
end

Etape("les couleurs d'une proposition, lettres en double comprises", function()
	-- un faux mot bâti sur le vrai : première lettre juste, le reste décalé d'un cran
	local faux = MOT:sub(1, 1) .. MOT:sub(#MOT) .. MOT:sub(2, #MOT - 1)
	if faux == MOT then faux = MOT:sub(1, 1) .. ("Z"):rep(#MOT - 1) end
	Proposer(faux)
	local p = db.motus.partie
	assert(#p.lignes == 1, "la proposition n'a pas été prise")
	assert(p.lignes[1] == faux, "mauvaise ligne gardée : " .. p.lignes[1])
	assert(p.fini ~= true, "la partie est finie trop tôt")
	assert(onglet.grille.cases[1][1].lettre.__texte == faux:sub(1, 1), "la grille n'affiche pas la ligne jouée")
	-- compte des couleurs : autant de lettres marquées que le mot en contient, jamais plus
	local su = {}
	for i = 1, #MOT do su[MOT:sub(i, i)] = (su[MOT:sub(i, i)] or 0) + 1 end
	local vus = {}
	for i = 1, #faux do
		local l = faux:sub(i, i)
		if su[l] then vus[l] = (vus[l] or 0) + 1 end
	end
	for l, n in pairs(vus) do assert(n <= (su[l] or 0) + #faux, "compte de lettres absurde pour " .. l .. " : " .. n) end
end)

Etape("trouvé : points, score noté et annoncé à la guilde", function()
	local avant = #envoyes
	Proposer(MOT)
	local p = db.motus.partie
	assert(p.fini == true and p.gagne == true, "la victoire n'a pas été vue")
	assert(p.points and p.points > 0, "aucun point : " .. tostring(p.points))
	-- 100 de base + (180 - secondes) + 25 par ligne laissée + 20 par lettre au-delà de 5
	local attendu = 100 + math.max(0, 180 - math.floor(p.secondes)) + 25 * (6 - #p.lignes) + 20 * (#MOT - 5)
	assert(p.points == attendu, ("points %d, attendu %d"):format(p.points, attendu))
	local msg, semaine
	for i = avant + 1, #envoyes do
		if envoyes[i]:find("^S~") then msg = envoyes[i] end
		if envoyes[i]:find("^H~") then semaine = envoyes[i] end
	end
	assert(msg, "score du jour non annoncé parmi " .. #envoyes - avant .. " message(s)")
	assert(semaine, "semaine non annoncée")
	assert(#msg <= 255 and #semaine <= 255, "message trop long")
	local j, pts, s, l = msg:match("^S~(%w+)~(%w+)~(%w+)~(%w+)$")
	assert(j and tonumber(j, 36) == JOUR, "jour mal encodé")
	assert(tonumber(pts, 36) == p.points, "points mal encodés")
	assert(tonumber(s, 36) == math.floor(p.secondes), "secondes mal encodées")
	assert(tonumber(l, 36) == #p.lignes, "lignes mal encodées")
	assert(db.motus.guilde["Miko-Forever"].p == p.points, "mon score n'est pas au classement")
end)

Etape("le chrono s'arrête quand c'est fini", function()
	local avant = db.motus.partie.secondes
	for _ = 1, 6 do OnUpdate(ev, 1) end
	assert(db.motus.partie.secondes == avant, "le chrono tourne encore après la victoire")
end)

Etape("le score d'un camarade entre au classement, le mien ne compte qu'une fois", function()
	local Base36 = ns.Base36
	ecouteur("GuildUpMot", ("S~%s~%s~%s~%s"):format(Base36(JOUR), Base36(999), Base36(12), Base36(2)),
		"GUILD", "Ronan-Forever")
	assert(db.motus.guilde["Ronan-Forever"].p == 999, "score du camarade perdu")
	ecouteur("GuildUpMot", ("S~%s~%s~%s~%s"):format(Base36(JOUR), Base36(1), Base36(1), Base36(6)),
		"GUILD", "Miko-Forever")
	assert(db.motus.guilde["Miko-Forever"].p ~= 1, "mon propre score reçu a écrasé le vrai")
	-- un score d'hier est ignoré
	ecouteur("GuildUpMot", ("S~%s~%s~%s~%s"):format(Base36(JOUR - 1), Base36(5000), Base36(1), Base36(1)),
		"GUILD", "Vieux-Forever")
	assert(db.motus.guilde["Vieux-Forever"] == nil, "un score d'hier est entré au classement")
	-- le classement : le camarade devant moi, et ma ligne mise en avant
	onglet.Maj()
	assert(onglet.rangs[1].nom.__texte:find("Ronan"), "mauvais premier : " .. onglet.rangs[1].nom.__texte)
	assert(onglet.rangs[2].__montre == true and onglet.rangs[3].__montre == false, "classement mal rempli")
end)

Etape("un « Q » reçu fait renvoyer mon score", function()
	local avant = #envoyes
	ecouteur("GuildUpMot", "Q", "GUILD", "Ronan-Forever")
	local vuS = false
	for i = avant + 1, #envoyes do if envoyes[i]:find("^S~") then vuS = true end end
	assert(vuS, "score du jour non renvoyé")
end)

Etape("atterrissage : la grille garde le résultat, le clavier disparaît", function()
	surLeVol = false
	OnUpdate(ev, 1)
	assert(onglet.clavier.__montre == false, "le clavier reste au sol")
	assert(onglet.grille.__montre == true, "la grille finie devrait rester visible")
	assert(onglet.consigne.__texte:find("Mot du jour trouvé"), "le résultat n'est pas annoncé : " .. onglet.consigne.__texte)
end)

Etape("demain, un nouveau mot et un classement vide", function()
	client.Avancer(86400)
	local jour2 = math.floor(ns.Maintenant() / 86400)
	assert(jour2 == JOUR + 1, "l'horloge n'a pas avancé d'un jour")
	surLeVol = true
	OnUpdate(ev, 1)
	local p = db.motus.partie
	assert(p.jour == jour2, "la partie n'a pas changé de jour")
	assert(p.fini ~= true and #p.lignes == 0 and p.secondes == 0, "la partie du jour n'est pas neuve")
	assert(LISTES[#p.mot] and LISTES[#p.mot][p.mot], "le mot du lendemain n'est pas dans la liste")
	assert(db.motus.guilde["Ronan-Forever"] == nil, "le classement d'hier traîne encore")
end)

Etape("perdu après six lignes : aucun point", function()
	local p = db.motus.partie
	local faux = p.mot:sub(1, 1) .. ("QJKWXZVY"):sub(1, #p.mot - 1)
	if faux == p.mot then faux = p.mot:sub(1, 1) .. ("B"):rep(#p.mot - 1) end
	for _ = 1, 6 do Proposer(faux) end
	assert(p.fini == true and p.gagne == false, "la défaite n'a pas été vue")
	assert(p.points == 0, "des points pour une défaite : " .. tostring(p.points))
	assert(#p.lignes == 6, "mauvais nombre de lignes : " .. #p.lignes)
	assert(onglet.consigne.__texte:find("était"), "le mot n'est pas révélé : " .. onglet.consigne.__texte)
end)

Etape("sans UnitOnTaxi, perdre le contrôle ne suffit pas à ouvrir le jeu", function()
	client.Avancer(86400) -- un jour neuf : sinon la partie est finie et le clavier resterait caché de toute façon
	local vrai = UnitOnTaxi
	UnitOnTaxi = nil      -- on fait comme si le client ne connaissait pas l'API
	surLeVol = false
	OnEvent(ev, "PLAYER_CONTROL_GAINED")
	OnUpdate(ev, 1)
	onglet.Maj()
	assert(onglet.clavier.__montre == false, "le clavier s'affiche au sol")
	OnEvent(ev, "PLAYER_CONTROL_LOST") -- charme, cinématique, étourdissement : pas un vol
	OnUpdate(ev, 1)
	assert(onglet.clavier.__montre == false, "une simple perte de contrôle ouvre le jeu")
	OnEvent(ev, "PLAYER_CONTROL_GAINED")
	OnEvent(ev, "TAXIMAP_CLOSED")      -- là, on paie un trajet
	OnEvent(ev, "PLAYER_CONTROL_LOST") -- puis on décolle
	OnUpdate(ev, 1)
	assert(onglet.clavier.__montre == true, "le repli ne reconnaît pas un vrai vol")
	UnitOnTaxi = vrai
	OnEvent(ev, "PLAYER_CONTROL_GAINED")
	surLeVol = true
	OnUpdate(ev, 1)
end)

Etape("classement de la semaine : les jours s'additionnent", function()
	local Base36 = ns.Base36
	local jour = math.floor(ns.Maintenant() / 86400)
	local lundi = jour - ((jour + 3) % 7)
	local bouts = { "H", Base36(lundi) }
	for j = lundi, jour do
		bouts[#bouts + 1] = Base36((j == lundi) and 120 or 60)
	end
	local msg = table.concat(bouts, "~")
	assert(#msg <= 255, "message de semaine trop long : " .. #msg)
	ecouteur("GuildUpMot", msg, "GUILD", "Ronan-Forever")
	-- le total attendu se lit dans l'historique rangé par l'addon : le camarade avait déjà un score du jour
	local total, joues = 0, 0
	for j, p in pairs(db.motus.histo["Ronan-Forever"] or {}) do
		if j >= lundi and j <= jour then total = total + p ; joues = joues + 1 end
	end
	assert(joues > 0, "l'historique du camarade est vide")
	local bJour, bSemaine = onglet.carteClassement.ongletJour, onglet.carteClassement.ongletSemaine
	bSemaine.__scripts.OnClick(bSemaine)
	assert(onglet.carteClassement.titre.__texte:find("semaine"), "le titre ne passe pas à la semaine")
	local detail
	for i = 1, 12 do
		local r = onglet.rangs[i]
		if r.__montre and r.nom.__texte:find("Ronan") then detail = r.detail.__texte end
	end
	assert(detail, "le camarade n'est pas au classement de la semaine")
	assert(detail:find(tostring(total)), ("total attendu %d, affiché %s"):format(total, detail))
	assert(detail:find("jour"), "le nombre de jours joués manque : " .. detail)
	-- une semaine passée n'entre pas
	ecouteur("GuildUpMot", ("H~%s~%s"):format(Base36(lundi - 7), Base36(9999)), "GUILD", "Vieux-Forever")
	onglet.Maj()
	for i = 1, 12 do
		local r = onglet.rangs[i]
		if r.__montre then assert(not r.nom.__texte:find("Vieux"), "une semaine passée est entrée au classement") end
	end
	bJour.__scripts.OnClick(bJour)
	assert(onglet.carteClassement.titre.__texte:find("du jour"), "retour au classement du jour raté")
end)

Etape("un « Q » renvoie le score du jour et la semaine", function()
	local avant = #envoyes
	ecouteur("GuildUpMot", "Q", "GUILD", "Ronan-Forever")
	local vus = {}
	for i = avant + 1, #envoyes do vus[envoyes[i]:sub(1, 1)] = true end
	assert(vus.H, "la semaine n'est pas renvoyée")
end)

Etape("les scores trop vieux sont oubliés dès qu'on touche à l'historique", function()
	local coffre = db.motus
	coffre.histo = coffre.histo or {}
	local jour = math.floor(ns.Maintenant() / 86400)
	coffre.histo["Ancien-Forever"] = { [jour - 30] = 500 }
	-- l'oubli se fait à la première lecture de l'historique : ici, l'arrivée d'un score
	local lundi = jour - ((jour + 3) % 7)
	ecouteur("GuildUpMot", ("H~%s~%s"):format(ns.Base36(lundi), ns.Base36(30)), "GUILD", "Autre-Forever")
	assert(coffre.histo["Ancien-Forever"] == nil, "un score de 30 jours traîne encore")
	assert(coffre.histo["Autre-Forever"], "le score neuf n'a pas été gardé")
end)

Etape("le diagnostic parle", function()
	local lignes = {}
	ns.DiagMotus(function(s) lignes[#lignes + 1] = s end)
	assert(#lignes >= 1 and lignes[1]:find("motus"), "diagnostic muet")
	local semaine
	for _, l in ipairs(lignes) do if l:find("semaine") then semaine = l end end
	assert(semaine, "le diagnostic ne dit rien de la semaine")
end)

os.exit(client.Bilan() and 0 or 1)
