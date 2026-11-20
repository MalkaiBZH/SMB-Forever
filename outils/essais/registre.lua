-- GuildUpSMB : essai du Registre (onglet de la page Artisanat) dans le faux client (outils/essais/faux_client.lua).
-- Charge le kit d'interface, les outils communs et GuildUp_Metiers.lua, fait arriver les fiches de quelques
-- membres, puis déroule un scénario : panneaux par métier, ma ligne hors des quatre premiers, recherche, métier
-- ouvert, artisan choisi, puces, recettes (survol, clic, molette), bande des métiers, retour.
-- Usage, depuis la racine du dépôt :  lua outils/essais/registre.lua GuildUpSMB   (code de sortie 1 si un essai rate)
local client = dofile((arg[0]:gsub("[^/\\]*$", "")) .. "faux_client.lua")
local ns, cadres, unites, envoyes = client.ns, client.cadres, client.unites, client.envoyes
local Factice, Charger, Etape = client.Factice, client.Charger, client.Etape

-- ce que le faux client n'a pas et que les métiers lisent : mon personnage, la liste de guilde, le réseau
unites.player = { id = 1, nom = "Miko-Forever" }
UnitClass = function() return "Guerrier", "WARRIOR" end
local LISTE = {
	{ "Miko-Forever", "WARRIOR", true, "Tanaris" },
	{ "Brindille-Forever", "MAGE", true, "Gadgetzan" },
	{ "Tarkh-Forever", "WARRIOR", true, "Silithus" },
	{ "Gromar-Forever", "SHAMAN", false, "" },
	{ "Lune-Forever", "PRIEST", true, "Orgrimmar" },
	{ "Sorbet-Forever", "DRUID", false, "" },
}
GetNumGuildMembers = function() return #LISTE end
GetGuildRosterInfo = function(i)
	local m = LISTE[i]
	return m[1], "Membre", 2, 60, m[2], m[4], "", "", m[3], 0, m[2]
end
ns.TestSolo = function() return false end
ns.Morceaux = function(mots) return { table.concat(mots, ",") } end
ns.Reassembleur = function()
	return { Ajouter = function(self, cle, h, part, total, ids)
		self[cle] = self[cle] or {}
		self[cle][part] = ids
		for i = 1, total do if not self[cle][i] then return nil end end
		local parts = self[cle]
		self[cle] = nil
		return parts
	end }
end
-- mes métiers, comme le jeu les aurait gardés : Alchimie débutant (une recette), Cuisine sans recette lue
GuildUpMetiersDB = { moi = { ["Miko-Forever"] = { profs = {
	AL = { n = 40, max = 75, r = { "i118" }, h = "a" },
	CU = { n = 10, max = 75 },
} } } }

Charger("GuildUp_Style.lua")
local InfoObjet = ns.InfoObjet          -- (celui du faux client : « Objet 118 », toujours connu)
Charger("GuildUp_Outils.lua")
ns.InfoObjet = InfoObjet
Charger("GuildUp_Recettes.lua")
Charger("GuildUp_Metiers.lua")
local ev
for _, f in ipairs(cadres) do if f.__scripts.OnEvent then ev = f end end
local OnEvent = ev.__scripts.OnEvent
local ecouteur = client.Ecouteur()
local B36 = ns.Base36

local page
ns.MajInterface = function() if page then page.Maj() end end
local function Clic(b, ...) b.__scripts.OnClick(b, ...) end
local function Panneau(code)
	for _, pn in ipairs(page.panneaux) do if pn.code == code then return pn end end
	error("pas de panneau " .. code)
end
local function Recettes(...)
	local t = {}
	for _, c in ipairs({ ... }) do t[#t + 1] = c:sub(1, 1) .. B36(tonumber(c:sub(2))) end
	return table.concat(t, ",")
end

Etape("connexion, liste de guilde, fiches et recettes reçues", function()
	OnEvent(ev, "PLAYER_ENTERING_WORLD")
	OnEvent(ev, "GUILD_ROSTER_UPDATE")
	ecouteur("GuildUpMet", "S~60~MAGE~AL,300,300,4,h1;HE,300,300,0,0", "GUILD", "Brindille-Forever")
	ecouteur("GuildUpMet", "R~AL~h1~1~1~" .. Recettes("i118", "i858", "i929", "s2330"), "GUILD", "Brindille-Forever")
	ecouteur("GuildUpMet", "S~60~WARRIOR~AL,290,300,2,h2;FO,300,300,3,h3;MI,300,300,0,0", "GUILD", "Tarkh-Forever")
	ecouteur("GuildUpMet", "R~AL~h2~1~1~" .. Recettes("i118", "i858"), "GUILD", "Tarkh-Forever")
	ecouteur("GuildUpMet", "R~FO~h3~1~2~" .. Recettes("i2862", "i2863"), "GUILD", "Tarkh-Forever")
	ecouteur("GuildUpMet", "R~FO~h3~2~2~" .. Recettes("i3239"), "GUILD", "Tarkh-Forever")
	ecouteur("GuildUpMet", "S~52~SHAMAN~AL,250,300,2,h4", "GUILD", "Gromar-Forever")
	ecouteur("GuildUpMet", "R~AL~h4~1~1~" .. Recettes("i118", "i929"), "GUILD", "Gromar-Forever")
	ecouteur("GuildUpMet", "S~44~PRIEST~AL,200,225,5,h5;EN,120,150,0,0", "GUILD", "Lune-Forever")
	ecouteur("GuildUpMet", "S~30~DRUID~AL,120,150,0,0;HE,150,150,0,0", "GUILD", "Sorbet-Forever")
	local demande = false
	for _, m in ipairs(envoyes) do if m:find("^D~AL~") then demande = true end end
	assert(demande, "les recettes annoncées ne sont pas demandées")
end)

Etape("création de l'onglet : un panneau par métier", function()
	page = ns.CreerPageRegistre(Factice("Parent"))
	page.Maj()
	assert(#page.panneaux >= 12, "panneaux manquants : " .. #page.panneaux)
	assert(page.ensemble.__montre and not page.detail.__montre, "la vue d'ensemble n'est pas montrée")
	assert(Panneau("HE").tete.compte.__texte:find("2 artisans"), "herboristes : " .. tostring(Panneau("HE").tete.compte.__texte))
	print("      " .. tostring(page.bas.__texte))
end)

Etape("panneau d'Alchimie : classement, plafond, ma ligne hors des quatre premiers", function()
	local pn = Panneau("AL")
	assert(pn.tete.compte.__texte:find("6 artisans"), "compte : " .. tostring(pn.tete.compte.__texte))
	local lignes = {}
	for i, b in ipairs(pn.rangs) do
		assert(b.__montre, "ligne " .. i .. " cachée")
		lignes[i] = b.rang.__texte .. " " .. b.nom.__texte .. " " .. b.recettes.__texte .. " " .. b.niveau.__texte
	end
	print("      " .. table.concat(lignes, " | "))
	assert(pn.rangs[1].cle == "Brindille-Forever" and pn.rangs[2].cle == "Tarkh-Forever" and pn.rangs[3].cle == "Gromar-Forever", "ordre du classement")
	assert(pn.rangs[4].cle == "Miko-Forever" and pn.rangs[4].rang.__texte == "6" and pn.rangs[4].filet.__montre, "ma ligne ne prend pas la dernière place")
	assert(not pn.rangs[1].filet.__montre and not pn.vide.__montre)
	assert(pn.rangs[1].recettes.__texte == "4 rec." and pn.rangs[4].recettes.__texte == "1 rec.")
	-- un métier que presque personne n'a : lignes vides et message
	local fo = Panneau("FO")
	assert(fo.rangs[1].__montre and not fo.rangs[2].__montre and fo.vide.__montre, "panneau de Forge")
	print("      Forge : " .. fo.tete.compte.__texte .. " / " .. fo.vide.__texte)
	for _, b in ipairs(pn.rangs) do b.__scripts.OnEnter(b); b.__scripts.OnLeave(b) end
	pn.tete.__scripts.OnEnter(pn.tete)
end)

Etape("recherche d'une recette, d'un joueur, puis de rien", function()
	page.recherche.SurTexte("Objet 858")
	local pn = Panneau("AL")
	print("      Alchimie : " .. pn.tete.compte.__texte .. " / " .. pn.rangs[1].nom.__texte .. " " .. pn.rangs[1].recettes.__texte)
	assert(pn.tete.compte.__texte:find("1 recette trouvée"), "recette cherchée")
	assert(pn.rangs[1].__montre and pn.rangs[2].__montre and not pn.rangs[3].__montre, "deux artisans la connaissent")
	assert(Panneau("FO").tete.compte.__texte == "Rien ici", "la Forge devrait s'éteindre")
	page.recherche.SurTexte("tarkh")
	assert(Panneau("FO").rangs[1].cle == "Tarkh-Forever" and Panneau("AL").rangs[1].cle == "Tarkh-Forever", "recherche par joueur")
	assert(not Panneau("AL").rangs[2].__montre)
	page.recherche.SurTexte("zzz")
	for _, p in ipairs(page.panneaux) do assert(p.tete.compte.__texte == "Rien ici") end
	page.recherche.SurTexte("")
	assert(Panneau("AL").rangs[4].cle == "Miko-Forever")
end)

Etape("puces « Tous / En ligne »", function()
	Clic(page.pucesEnLigne.boutons[2])
	local pn = Panneau("AL")
	assert(pn.rangs[3].cle == "Lune-Forever" and pn.rangs[4].cle == "Miko-Forever" and not pn.rangs[4].filet.__montre, "hors-ligne encore montrés")
	assert(Panneau("FO").vide.__texte == "Personne d'autre en ligne.")
	Clic(page.pucesEnLigne.boutons[1])
	assert(Panneau("AL").rangs[3].cle == "Gromar-Forever")
end)

Etape("métier ouvert : classement complet et recettes de la guilde", function()
	Clic(Panneau("AL").tete)
	assert(page.detail.__montre and not page.ensemble.__montre, "le métier n'est pas ouvert")
	assert(page.gTitre.__texte == "Alchimie" or page.gTitre.__texte:find("Sort"), "titre : " .. tostring(page.gTitre.__texte))
	print("      " .. page.gSous.__texte .. " / " .. page.dTitre.__texte .. " / " .. page.dSous.__texte)
	local n = 0
	for _, b in ipairs(page.lignesArtisans) do if b.__montre then n = n + 1 end end
	assert(n == 6, "artisans listés : " .. n)
	assert(#page.listeRecettes == 4, "recettes de la guilde : " .. #page.listeRecettes)
	assert(not page.mp.__montre and not page.toute.__montre and not page.dVide.__montre)
	local a = page.lignesArtisans[1]
	print("      " .. a.rang.__texte .. " " .. a.nom.__texte .. " / " .. a.sous.__texte .. " / " .. a.niveau.__texte .. " / " .. a.recettes.__texte)
	local h = page.lignesArtisans[3]
	assert(h.cle == "Gromar-Forever" and h.sous.__texte:find("Hors ligne"), "lieu d'un absent : " .. tostring(h.sous.__texte))
	for _, b in ipairs(page.lignesArtisans) do if b.__montre then b.__scripts.OnEnter(b); b.__scripts.OnLeave(b) end end
end)

Etape("recettes : qui sait les faire, survol, clic, molette", function()
	local vues = 0
	for _, l in ipairs(page.lignesRecettes) do
		if l.__montre then
			vues = vues + 1
			local qui = {}
			for _, s in ipairs(l.qui) do if s.nom.__texte ~= "" then qui[#qui + 1] = s.nom.__texte end end
			print("      " .. l.texte.__texte .. " : " .. table.concat(qui, ", ") .. " " .. l.plus.__texte)
			l.__scripts.OnEnter(l)
			Clic(l)
			l.__scripts.OnLeave(l)
		end
	end
	assert(vues == 4, "lignes de recettes : " .. vues)
	-- « Objet 118 » : quatre artisans, trois nommés (en ligne d'abord) et « +1 »
	local l = page.lignesRecettes[1]
	assert(l.x.code == "i118" and #l.x.qui == 4 and l.plus.__texte == "+1", "artisans de la première recette")
	assert(l.qui[1].nom.__texte == "Brindille" and l.qui[3].nom.__texte == "Miko", "ordre des artisans : en ligne d'abord")
	page.recettes.__scripts.OnMouseWheel(page.recettes, -1)
	page.recettes.__scripts.OnMouseWheel(page.recettes, 1)
	page.recettes.__scripts.OnVerticalScroll(page.recettes)
	page.recettes.__scripts.OnSizeChanged(page.recettes, 500)
end)

Etape("artisan choisi : ses recettes, Chuchoter, retour à toute la guilde", function()
	Clic(page.lignesArtisans[2])
	assert(#page.listeRecettes == 2 and page.dTitre.__texte:find("Tarkh"), "recettes de Tarkh : " .. #page.listeRecettes .. " / " .. page.dTitre.__texte)
	assert(page.mp.__montre and page.toute.__montre and page.lignesArtisans[2].fond.__montre and not page.lignesArtisans[1].fond.__montre)
	print("      " .. page.dTitre.__texte .. " / " .. page.dSous.__texte)
	page.mp.__scripts.OnEnter(page.mp)
	Clic(page.mp)
	-- un artisan dont les recettes ne sont pas encore arrivées, puis un re-clic pour le lâcher
	Clic(page.lignesArtisans[4])
	assert(page.lignesArtisans[4].cle == "Lune-Forever" and #page.listeRecettes == 0 and page.dVide.__montre, "recettes en attente")
	print("      " .. page.dVide.__texte)
	Clic(page.lignesArtisans[4])
	assert(#page.listeRecettes == 4 and not page.mp.__montre, "re-clic : toute la guilde")
	Clic(page.lignesArtisans[6])
	assert(page.lignesArtisans[6].cle == "Miko-Forever" and #page.listeRecettes == 1)
	page.mp.__scripts.OnEnter(page.mp)
	for _, l in ipairs(page.lignesRecettes) do if l.__montre then l.__scripts.OnEnter(l); Clic(l) end end
	Clic(page.toute)
	assert(#page.listeRecettes == 4)
end)

Etape("puces des recettes et recherche dans le métier", function()
	Clic(page.puces.boutons[3])
	assert(#page.listeRecettes == 1 and page.listeRecettes[1].code == "s2330", "un seul artisan : " .. #page.listeRecettes)
	Clic(page.puces.boutons[2])
	print("      spéciales : " .. #page.listeRecettes .. (page.dVide.__montre and (" / " .. page.dVide.__texte) or ""))
	Clic(page.puces.boutons[1])
	page.rechercheMetier.SurTexte("objet 9")
	assert(#page.listeRecettes == 1 and page.listeRecettes[1].code == "i929", "recherche dans le métier")
	page.rechercheMetier.SurTexte("zzz")
	assert(#page.listeRecettes == 0 and page.dVide.__texte == "Aucune recette ne correspond.")
	page.rechercheMetier.SurTexte("")
end)

Etape("bande des métiers : chaque métier s'ouvre, récolte comprise", function()
	local n = 0
	for code, bt in pairs(page.bande) do
		n = n + 1
		bt.__scripts.OnEnter(bt)
		Clic(bt)
		Clic(bt)
		assert(page.detail.__montre, code)
	end
	assert(n == #page.panneaux)
	Clic(page.bande.HE)
	assert(#page.listeRecettes == 0 and page.dVide.__montre and page.demander.__montre, "métier de récolte")
	print("      " .. page.gSous.__texte .. " / " .. page.dVide.__texte)
	Clic(page.demander)
	Clic(page.bande.FO)
	assert(#page.listeRecettes == 3 and not page.demander.__montre, "recettes de Forge (en deux morceaux) : " .. #page.listeRecettes)
	Clic(page.bande.EN)
	print("      Enchantement : " .. page.dVide.__texte)
end)

Etape("retour, clic sur un artisan d'un panneau, Actualiser, affichage", function()
	Clic(page.retour)
	assert(page.ensemble.__montre and not page.detail.__montre, "retour à la vue d'ensemble")
	-- une recherche faite dans la vue d'ensemble suit dans le métier ouvert
	page.recherche.SurTexte("objet 858")
	Clic(Panneau("AL").rangs[2])
	assert(page.detail.__montre and page.dTitre.__texte:find("Tarkh") and #page.listeRecettes == 1, "artisan ouvert depuis un panneau")
	assert(page.rechercheMetier.Lire() == "objet 858", "la recherche n'a pas suivi")
	page.rechercheMetier.SurTexte("")
	Clic(page.retour)
	assert(page.recherche.Lire() == "")
	Clic(page.actualiser)
	page.actualiser.__scripts.OnEnter(page.actualiser)
	page.__scripts.OnShow(page)
	page.__scripts.OnUpdate(page, 31)
end)

Etape("un membre quitte le classement pendant que son métier est ouvert", function()
	Clic(Panneau("FO").rangs[1])
	assert(page.dTitre.__texte:find("Tarkh"))
	ecouteur("GuildUpMet", "S~60~WARRIOR~AL,290,300,2,h2", "GUILD", "Tarkh-Forever")
	assert(not page.mp.__montre and page.gVide.__montre and #page.listeRecettes == 0, "la Forge devrait être vide")
	Clic(page.retour)
	assert(not Panneau("FO").rangs[1].__montre and Panneau("FO").vide.__texte == "Personne pour l'instant.")
end)

Etape("fonctions pour les autres modules et diagnostic", function()
	local m = ns.MembresAvecMetier("AL")
	assert(#m == 6 and m[1].moi, "membres avec le métier")
	local a = ns.ArtisansDe(118)
	assert(#a == 4 and a[1].moi, "artisans d'un objet : " .. #a)
	assert(ns.MonNiveauMetier("AL") == 40 and ns.JeSaisFabriquer(118) and not ns.JeSaisFabriquer(858))
	ns.BasculerMetiers()
	ns.DiagMetiers(function(t) print("      " .. t) end)
end)

os.exit(client.Bilan() and 0 or 1)
