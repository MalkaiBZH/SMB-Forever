-- GuildUpSMB : essai du WoWdex dans le faux client (outils/essais/faux_client.lua).
-- Charge le kit d'interface, le bestiaire et GuildUp_Wowdex.lua, puis déroule un scénario : page et onglets,
-- rare en vue, capture, dépouille, messages de la guilde, filtres, recherche, fiche, zones, carnet, classement.
-- Usage, depuis la racine du dépôt :  lua outils/essais/wowdex.lua GuildUpSMB   (code de sortie 1 si un essai rate)
local client = dofile((arg[0]:gsub("[^/\\]*$", "")) .. "faux_client.lua")
local ns, db, cadres, unites, plaque = client.ns, client.db, client.cadres, client.unites, client.plaque
local envoyes, bulles, activite, messages = client.envoyes, client.bulles, client.activite, client.messages
local Factice, Charger, Etape = client.Factice, client.Charger, client.Etape
local CARTE_ELWYNN
Charger("GuildUp_Style.lua")
Charger("GuildUp_Bestiaire.lua")
-- repères dans le bestiaire avant qu'il soit consommé : zone 12 (Forêt d'Elwynn), un rare et un normal de cette zone
local carte = ns.BESTIAIRE_ZONES:match("\n?12|[^|\n]*|(%d*)")
CARTE_ELWYNN = tonumber(carte)
client.Carte(CARTE_ELWYNN)
local rare, normal, rare2, boss
local donjon, nomsDonjon = {}, {} -- deux monstres d'instance (zone sans position), le premier de chaque nom
for ligne in ns.BESTIAIRE:gmatch("[^\n]+") do
	local id, fr, en, mi, ma, rang, zones = ligne:match("^(%d+)|([^|]*)|([^|]*)|(%d+)|(%d+)|(%d+)|([^|]*)|")
	if id and zones:match("^12:") then
		if rang == "4" and not rare then rare = { id = tonumber(id), nom = fr }
		elseif rang == "4" and not rare2 then rare2 = { id = tonumber(id), nom = fr }
		elseif rang == "0" and not normal then normal = { id = tonumber(id), nom = fr } end
	end
	if id and rang == "3" and not boss then boss = { id = tonumber(id), nom = fr } end
	if id and zones:match("^%d+:$") and not nomsDonjon[fr] then
		nomsDonjon[fr] = true
		if #donjon < 2 then donjon[#donjon + 1] = { id = tonumber(id), nom = fr } end
	end
end
print("repères", CARTE_ELWYNN, rare.id, rare.nom, rare2 and rare2.id, normal.id, normal.nom, boss.id)
Charger("GuildUp_Wowdex.lua")
local ev
for _, f in ipairs(cadres) do if f.__scripts.OnEvent then ev = f end end
local OnEvent = ev.__scripts.OnEvent

local ecouteur, creerPage = client.Ecouteur(), client.CreerPage()

OnEvent(ev, "PLAYER_ENTERING_WORLD")
local page
Etape("création de la page", function() page = creerPage(Factice("Parent")) end)
local function Onglet(i) page.onglets.boutons[i].__scripts.OnClick(page.onglets.boutons[i]) end
for i = 1, 5 do Etape("onglet " .. i .. " (WoWdex vide)", function() Onglet(i) end) end

Etape("barre de nom d'un rare vivant : alerte et repérage", function()
	unites.nameplate1 = { id = rare.id, nom = rare.nom, classe = "rare" }
	OnEvent(ev, "NAME_PLATE_UNIT_ADDED", "nameplate1")
	assert(#bulles == 1 and bulles[1].son == "RAID_WARNING", "pas de bulle d'alerte")
	local vu = false
	for _, m in ipairs(envoyes) do if m:find("^V~") then vu = m end end
	assert(vu, "pas de repérage envoyé")
	print("      " .. bulles[1].titre .. " / " .. bulles[1].texte .. " / " .. vu)
	OnEvent(ev, "NAME_PLATE_UNIT_ADDED", "nameplate1")
	assert(#bulles == 1, "alerte répétée")
end)
Etape("monstre normal vu puis vaincu et fouillé", function()
	unites.target = { id = normal.id, nom = normal.nom }
	OnEvent(ev, "PLAYER_TARGET_CHANGED")
	unites.target.mort = true
	OnEvent(ev, "UNIT_HEALTH", "target")
	OnEvent(ev, "LOOT_OPENED")
	local e = db.wowdex.m[normal.id]
	assert(e and e.k == 1 and e.d == 1 and e.b[2589] == 1, "capture ou dépouille manquante")
end)
Etape("butin lu dès LOOT_READY, une seule fois par corps", function()
	local e = db.wowdex.m[normal.id]
	unites.target = { id = normal.id, nom = normal.nom, mort = true, n = "C" }
	OnEvent(ev, "LOOT_READY")
	OnEvent(ev, "LOOT_OPENED")
	OnEvent(ev, "LOOT_READY")
	assert(e.k == 2 and e.d == 2 and e.b[2589] == 2, ("corps compté %d fois, dépouillé %d fois"):format(e.k, e.d))
	assert(db.wowdex.diag.corpsPrets == 1 and db.wowdex.diag.butinsOuverts == 2, "relevé du butin")
end)
Etape("en instance : GUID cachés, boss par la fin du combat, monstre par la ligne d'expérience, butin", function()
	assert(#donjon == 2, "pas de monstre d'instance dans le bestiaire")
	local A, B = donjon[1], donjon[2]
	IsInInstance = function() return true end
	COMBATLOG_XPGAIN_FIRSTPERSON = "%s meurt, vous gagnez %d points d'expérience."
	-- la cible : un monstre dont le jeu cache le GUID
	unites.target = { id = A.id, nom = A.nom, mort = true, n = "S" }
	client.secrets[UnitGUID("target")] = true
	OnEvent(ev, "PLAYER_TARGET_CHANGED")
	assert(not db.wowdex.m[A.id] and db.wowdex.diag.guidsCaches == 1, "un GUID caché ne doit rien donner")
	-- boss : deux évènements et la ligne d'expérience, une seule mort
	OnEvent(ev, "ENCOUNTER_END", 2741, A.nom, 1, 5, 0)
	assert(not db.wowdex.m[A.id], "combat de boss perdu compté")
	OnEvent(ev, "ENCOUNTER_END", 2741, A.nom, 1, 5, 1)
	OnEvent(ev, "BOSS_KILL", 2741, A.nom)
	OnEvent(ev, "CHAT_MSG_COMBAT_XP_GAIN", A.nom .. " meurt, vous gagnez 350 points d'expérience.")
	assert(db.wowdex.m[A.id] and db.wowdex.m[A.id].k == 1, "boss compté " .. tostring(db.wowdex.m[A.id] and db.wowdex.m[A.id].k))
	print("      " .. messages[#messages])
	-- deux monstres du même nom, deux lignes d'expérience (la seconde avec un bonus)
	OnEvent(ev, "CHAT_MSG_COMBAT_XP_GAIN", B.nom .. " meurt, vous gagnez 120 points d'expérience.")
	OnEvent(ev, "CHAT_MSG_COMBAT_XP_GAIN", B.nom .. " meurt, vous gagnez 120 points d'expérience. (+60 exp bonus Reposé)")
	OnEvent(ev, "CHAT_MSG_COMBAT_XP_GAIN", "Vous gagnez 500 points d'expérience.")
	OnEvent(ev, "CHAT_MSG_COMBAT_XP_GAIN", "Monstre de nulle part meurt, vous gagnez 5 points d'expérience.")
	assert(db.wowdex.m[B.id].k == 2, "lignes d'expérience : " .. db.wowdex.m[B.id].k)
	assert(db.wowdex.diag.nomsInconnusTexte == "Monstre de nulle part", "nom inconnu pas relevé")
	-- le corps du premier, fouillé : son GUID arrive en clair par le butin alors que la cible reste cachée ;
	-- cette mort était déjà comptée par la ligne d'expérience
	local vraieSource = GetLootSourceInfo
	GetLootSourceInfo = function() return ("Creature-0-1-2-3-%d-00001Z"):format(B.id), 1 end
	OnEvent(ev, "LOOT_READY")
	GetLootSourceInfo = vraieSource
	assert(db.wowdex.m[B.id].k == 2 and db.wowdex.m[B.id].d == 1, "corps fouillé en instance")
	-- hors instance, les lignes d'expérience ne comptent pas (le GUID fait foi)
	IsInInstance = function() return false end
	OnEvent(ev, "CHAT_MSG_COMBAT_XP_GAIN", B.nom .. " meurt, vous gagnez 120 points d'expérience.")
	assert(db.wowdex.m[B.id].k == 2, "ligne d'expérience comptée hors instance")
	unites.target = nil
end)
Etape("capture du rare : bulle, fil d'activité, losange retiré", function()
	local avant = #bulles
	unites.target = { id = rare.id, nom = rare.nom, classe = "rare", mort = true, n = "B" }
	OnEvent(ev, "PLAYER_TARGET_CHANGED")
	assert(#bulles == avant + 1, "pas de bulle de capture")
	print("      " .. bulles[#bulles].titre .. " / " .. bulles[#bulles].texte:gsub("\n", " | "))
	assert(activite[#activite] and activite[#activite]:find("^W "), "pas de première dans le fil")
	local mort = false
	for _, m in ipairs(envoyes) do if m:find("^K~") then mort = m end end
	assert(mort and db.wowdexGuilde["Donjons et Dindons"].morts[rare.id], "la mort du rare n'est pas annoncée")
	OnEvent(ev, "NAME_PLATE_UNIT_REMOVED", "nameplate1")
end)
Etape("messages reçus : scores, rares, repérage, captures, relais", function()
	ecouteur("GuildUpDex", "S~120~80~40", "GUILD", "Brindille-Forever")
	ecouteur("GuildUpDex", "C~12", "GUILD", "Brindille-Forever")
	ecouteur("GuildUpDex", "S~300~200~90", "GUILD", "Tarkh-Forever")
	ecouteur("GuildUpDex", "T~Gromar-Forever,50,30,10," .. ns.Base36(ns.Maintenant()), "GUILD", "Brindille-Forever")
	ecouteur("GuildUpDex", "U~Gromar-Forever,3;Brindille-Forever,12", "GUILD", "Brindille-Forever")
	local g = db.wowdexGuilde["Donjons et Dindons"]
	assert(g.s["Brindille-Forever"].r == 12 and g.s["Gromar-Forever"].r == 3 and g.s["Tarkh-Forever"].r == nil, "rares des membres")
	if rare2 then
		local avant = #bulles
		ecouteur("GuildUpDex", ("V~%s~%d~4321~6543"):format(ns.Base36(rare2.id), CARTE_ELWYNN), "GUILD", "Brindille-Forever")
		assert(#bulles == avant + 1 and g.r[rare2.id].x == 0.4321, "repérage reçu")
		print("      " .. bulles[#bulles].titre .. " / " .. bulles[#bulles].texte:gsub("\n", " | "))
		ecouteur("GuildUpDex", "N~" .. ns.Base36(rare2.id) .. "," .. ns.Base36(boss.id), "GUILD", "Tarkh-Forever")
		ecouteur("GuildUpDex", "N~" .. ns.Base36(rare2.id), "GUILD", "Brindille-Forever")
		-- la fiche d'un rare repéré : « Y aller », lignes expliquées au survol, puis sa mort annoncée par un membre
		Etape("fiche d'un rare repéré : « Y aller », infobulles, mort annoncée", function()
			page.Ouvrir(rare2.id)
			local fiche = page.fiche
			assert(fiche.yAller.__montre and fiche.yAller.point, "pas de bouton « Y aller »")
			fiche.yAller.__scripts.OnClick(fiche.yAller)
			fiche.carte.__scripts.OnClick(fiche.carte)
			local lignes = {}
			for _, r in ipairs(fiche.rangs) do
				if r.cle.__montre then
					lignes[#lignes + 1] = r.cle.__texte .. " = " .. r.val.__texte
					r.survol.__scripts.OnEnter(r.survol)
				end
			end
			print("      " .. table.concat(lignes, " | "))
			client.Avancer(60)
			ecouteur("GuildUpDex", "K~" .. ns.Base36(rare2.id), "GUILD", "Tarkh-Forever")
			page.Ouvrir(rare2.id)
			assert(not fiche.yAller.__montre, "« Y aller » reste après la mort du rare")
			local tue = false
			for _, r in ipairs(fiche.rangs) do if r.cle.__montre and r.cle.__texte == "Tué" then tue = r.val.__texte end end
			assert(tue, "pas de ligne « Tué »")
			print("      Tué = " .. tue)
		end)
		print("      fil : " .. table.concat(activite, " ; "))
	end
	ecouteur("GuildUpDex", "Q~0", "GUILD", "Brindille-Forever")
	ecouteur("GuildUpDex", "P~0", "GUILD", "Brindille-Forever")
	local u = false
	for _, m in ipairs(envoyes) do if m:find("^U~") then u = m end end
	assert(u, "le relais n'envoie pas les rares")
end)
for i = 1, 5 do Etape("onglet " .. i .. " (avec des données)", function() Onglet(i) end) end
Etape("avis de recherche : clic sur une carte, voisins, pister, carte, lier", function()
	Onglet(1)
	local n = 0
	for _, f in ipairs(cadres) do
		if rawget(f, "element") and f.__montre and f.__scripts.OnClick and n < 4 then
			n = n + 1
			f.__scripts.OnClick(f)
			f.__scripts.OnEnter(f)
		end
	end
	assert(n > 0, "aucune carte dans la grille")
	local fiche = page.fiche
	fiche.suiv.__scripts.OnClick(fiche.suiv)
	fiche.suiv.__scripts.OnClick(fiche.suiv)
	fiche.prec.__scripts.OnClick(fiche.prec)
	fiche.pister.__scripts.OnClick(fiche.pister)
	fiche.carte.__scripts.OnClick(fiche.carte)
	fiche.lier.__scripts.OnClick(fiche.lier)
	print("      fiche : " .. tostring(fiche.nom.__texte) .. " / lien : " .. tostring(fiche.lier.lien))
	for _, l in ipairs(fiche.lignes) do if rawget(l, "objet") then l.__scripts.OnEnter(l); l.__scripts.OnClick(l) end end
	local pistes = 0
	for _ in pairs(db.wowdex.pistes) do pistes = pistes + 1 end
	print("      pistés : " .. pistes)
end)
Etape("filtres, zone, recherche par nom et par objet, molette, piste de défilement", function()
	local v = page.vues[1]
	for i = 1, 2 do
		Onglet(i)
		for _, b in ipairs(v.puces[i].boutons) do b.__scripts.OnClick(b) end
		v.puces[i].boutons[1].__scripts.OnClick(v.puces[i].boutons[1])
	end
	page.zone.__scripts.OnClick(page.zone)
	Onglet(2)
	page.grille.__scripts.OnMouseWheel(page.grille, -1)
	page.grille.__scripts.OnMouseWheel(page.grille, -1)
	page.grille.__scripts.OnMouseWheel(page.grille, 1)
	local piste = page.grille.piste
	piste.__scripts.OnMouseDown(piste)
	client.Avancer(1)
	piste.__scripts.OnUpdate(piste)
	piste.__scripts.OnMouseUp(piste)
	v.recherche.SurTexte("loup")
	v.recherche.SurTexte("etoffe de lin")
	v.recherche.SurTexte("")
end)
Etape("zones : clic sur une zone, « Voir ses rares », puces", function()
	Onglet(3)
	local v = page.vues[3]
	for _, b in ipairs(v.puces.boutons) do b.__scripts.OnClick(b) end
	v.puces.boutons[1].__scripts.OnClick(v.puces.boutons[1])
	print("      tu es ici : " .. tostring(v.ici.titre.__texte) .. " / " .. tostring(v.ici.texte.__texte):gsub("\n", " | "))
	v.rangees[1].__scripts.OnClick(v.rangees[1])
	Onglet(3)
	v.ici.voir.__scripts.OnClick(v.ici.voir)
end)
Etape("carnet : réglages, lignes cliquables", function()
	Onglet(4)
	local v = page.vues[4]
	v.alertes.__scripts.OnClick(v.alertes)
	v.alertes.__scripts.OnClick(v.alertes)
	v.plaques.__scripts.OnClick(v.plaques)
	v.plaques.__scripts.OnClick(v.plaques)
	print("      titre : " .. tostring(v.titre.nom.__texte) .. " / " .. tostring(v.titre.detail.__texte))
	for _, l in ipairs(v.captures.lignes) do if rawget(l, "id") and l.__montre then l.__scripts.OnClick(l); break end end
end)
Etape("guilde : classement et premières", function()
	Onglet(5)
	local v = page.vues[5]
	print("      " .. tostring(v.resume.texte.__texte))
	for i = 1, 4 do local l = v.classement.lignes[i]; if l.__montre then print("      " .. tostring(l.nom.__texte) .. " | " .. tostring(l.cols[1].__texte) .. " | " .. tostring(l.cols[2].__texte) .. " | " .. tostring(l.cols[4].__texte)) end end
end)
Etape("ouverture directe d'une fiche (rare, normal, inconnu)", function()
	page.Ouvrir(rare.id); assert(page.fiche.nom.__texte == rare.nom)
	page.Ouvrir(normal.id); assert(page.fiche.nom.__texte == normal.nom)
	page.Ouvrir(boss.id)
	page.Ouvrir(999999999)
	page.__scripts.OnShow(page)
end)
Etape("infobulle d'un monstre et diagnostic", function()
	unites.mouseover = { id = rare2 and rare2.id or rare.id, nom = "x", classe = "rare" }
	if GameTooltip.__scripts.OnTooltipSetUnit then GameTooltip.__scripts.OnTooltipSetUnit(GameTooltip) end
	ns.DiagWowdex(function(t) print("      " .. t) end)
	ns.MajPlaquesWowdex()
	assert(type(ns.SourcesWowdex(2589)) == "table" and ns.SourcesWowdex(2589)[1], "sources d'un objet")
end)
print("messages de discussion : " .. #messages)
for i = 1, math.min(#messages, 6) do print("   " .. messages[i]) end
os.exit(client.Bilan() and 0 or 1)
