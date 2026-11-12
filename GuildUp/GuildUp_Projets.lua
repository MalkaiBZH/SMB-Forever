-- GuildUp : projets de guilde. Un membre crée un projet (une liste d'objets à fabriquer, partagée
-- avec toute la guilde) ; GuildUp en déduit les tâches (ce qu'il faut fabriquer, ce qu'il faut
-- réunir) et chaque membre qualifié peut cocher « Je m'en occupe » : son nom s'affiche à côté.
--
-- Synchro (préfixe GuildUpPrj, canal GUILD) — chaque information porte sa date (GetServerTime) et
-- la plus récente gagne, ce qui permet à n'importe quel membre de relayer les projets d'un absent :
--   P~id~maj~auteur~nom          en-tête d'un projet        E~id~maj~i~n~objet:qte,…   ses objets (morceaux)
--   T~id~objet~qui~etat~maj      une tâche (etat 0 libre, 1 prise, 2 faite ; qui = clé du joueur)
--   X~id~maj                     projet supprimé            Q                          « envoyez-moi les projets »

local NOM_ADDON, ns = ...
local PREFIXE = "GuildUpPrj"
local LIBRE, PRISE, FAITE = 0, 1, 2
local OUBLI = 30 * 86400          -- projets supprimés : contenu oublié après 30 jours…
local TOMBE = 365 * 86400         -- … mais la trace de suppression (id, date) est gardée un an,
                                  -- pour qu'un membre longtemps absent ne fasse pas revenir le projet
local ATTENTE_MAX = 120           -- secondes : réception incomplète (morceaux perdus) abandonnée

local function Normaliser(nom) return ns.Normaliser and ns.Normaliser(nom) or nom end
local function MaCle() return Normaliser(UnitName("player")) end
local function TestSolo() return ns.TestSolo and ns.TestSolo() end
local function NomCourt(nom) return ((nom or "?"):gsub("%-.*$", ""):gsub("#test$", "")) end
local function Envoyer(msg) if ns.EnvoyerAddon then ns.EnvoyerAddon(PREFIXE, msg, "GUILD") end end
local function Maintenant() return GetServerTime and GetServerTime() or time() end
local function Outils() return ns.OutilsCarnet or {} end
local function Propre(t) return ((t or ""):gsub("[~|\n]", " ")) end

local pret = false
local MajPage                       -- rafraîchit l'onglet (défini plus bas)
local function Maj() if MajPage then MajPage() end end

--------------------------------------------------------------------------------
-- Données : db.projets[id] = { id, nom, auteur, maj, entrees = { {objet, qte} },
--   taches = { [objet] = { qui, etat, maj } }, supprime = date }
--------------------------------------------------------------------------------

local function Projets()
	local db = ns.DB and ns.DB() or {}
	if type(db.projets) ~= "table" then db.projets = {} end
	return db.projets, db
end

local function Projet(id, creer)
	local ps = Projets()
	local p = ps[id]
	if not p and creer then
		p = { id = id, maj = 0, entrees = {}, taches = {} }
		ps[id] = p
	end
	if p then
		p.entrees = p.entrees or {}
		p.taches = p.taches or {}
	end
	return p
end

-- projets visibles (connus et non supprimés), triés du plus récent au plus ancien
local function ListeProjets()
	local l, ps = {}, Projets()
	local maintenant = Maintenant()
	for id, p in pairs(ps) do
		if p.supprime then
			if maintenant - p.supprime > TOMBE then
				ps[id] = nil
			elseif maintenant - p.supprime > OUBLI and (p.nom or next(p.entrees or {})) then
				ps[id] = { id = id, supprime = p.supprime, maj = p.maj } -- trace minimale
			end
		elseif not p.nom then
			ps[id] = nil -- coquille (réception jamais terminée) : rien à garder
		else
			l[#l + 1] = p
		end
	end
	table.sort(l, function(a, b) return (a.cree or a.maj or 0) > (b.cree or b.maj or 0) end)
	return l
end
ns.ListeProjets = ListeProjets

local function EstAuteur(p) return p and p.auteur == MaCle() end

--------------------------------------------------------------------------------
-- Tâches : ce qu'il faut fabriquer (objets fabricables, développés) et ce qu'il faut réunir
--------------------------------------------------------------------------------

local function Taches(p)
	local O = Outils()
	local fab, base, ordreF = {}, {}, {}
	local objectifs = {}
	for _, e in ipairs(p.entrees) do objectifs[e.objet] = (objectifs[e.objet] or 0) + e.qte end
	-- même calcul que la liste de courses (GuildUp_Carnet.lua) : boucles de transmutation non
	-- développées, surplus des fabrications partagé ; le stock part de zéro (projet de guilde)
	if not (O.Developper and O.NouveauContexte) then return {}, {} end
	local ctx = O.NouveauContexte(false)
	local function Parcourir(n, prof)
		if n.recette then
			local t = fab[n.objet]
			if not t then
				t = { objet = n.objet, qte = 0, recette = n.recette, prof = prof }
				fab[n.objet] = t
				ordreF[#ordreF + 1] = t
			end
			t.qte = t.qte + n.manque
			t.prof = math.min(t.prof, prof)
			for _, c in ipairs(n.enfants or {}) do Parcourir(c, prof + 1) end
		elseif n.manque > 0 then
			base[n.objet] = (base[n.objet] or 0) + n.manque
		end
	end
	for _, e in ipairs(p.entrees) do Parcourir(O.Developper(e.objet, e.qte, ctx, 0, {}), 0) end
	local function Nom(o) return (O.InfoObjet and O.InfoObjet(o)) or "" end
	table.sort(ordreF, function(a, b)
		if a.prof ~= b.prof then return a.prof < b.prof end
		return Nom(a.objet) < Nom(b.objet)
	end)
	local ordreB = {}
	for o, q in pairs(base) do ordreB[#ordreB + 1] = { objet = o, qte = q } end
	table.sort(ordreB, function(a, b) return Nom(a.objet) < Nom(b.objet) end)
	for _, t in ipairs(ordreF) do t.objectif = objectifs[t.objet] ~= nil end
	for _, t in ipairs(ordreB) do t.objectif = objectifs[t.objet] ~= nil end
	return ordreF, ordreB
end

-- qteActuelle : quantité demandée aujourd'hui ; une tâche « faite » pour une quantité plus petite
-- (l'auteur a augmenté le projet depuis) redevient à faire
local function Etat(p, objet, qteActuelle)
	local t = p.taches[objet]
	if not t or (t.etat or LIBRE) == LIBRE then return LIBRE end
	if t.etat == FAITE and t.qte and qteActuelle and qteActuelle > t.qte then return LIBRE end
	return t.etat, t.qui
end

-- quantité demandée pour un objet du projet (tâche à fabriquer ou à réunir), ou nil
local function QteTache(p, objet)
	local f, b = Taches(p)
	for _, t in ipairs(f) do if t.objet == objet then return t.qte end end
	for _, t in ipairs(b) do if t.objet == objet then return t.qte end end
end

-- Départage de deux versions d'une même tâche : la plus récente ; à la même seconde, la plus
-- avancée (libre < prise < faite), puis le plus grand nom : tous les membres choisissent pareil
local function Gagne(nouv, anc)
	if not anc then return true end
	if (nouv.maj or 0) ~= (anc.maj or 0) then return (nouv.maj or 0) > (anc.maj or 0) end
	if (nouv.etat or LIBRE) ~= (anc.etat or LIBRE) then return (nouv.etat or LIBRE) > (anc.etat or LIBRE) end
	return (nouv.qui or "") > (anc.qui or "")
end

local function Avancement(p)
	local f, b = Taches(p)
	local total, faites = #f + #b, 0
	for _, t in ipairs(f) do if Etat(p, t.objet, t.qte) == FAITE then faites = faites + 1 end end
	for _, t in ipairs(b) do if Etat(p, t.objet, t.qte) == FAITE then faites = faites + 1 end end
	return faites, total
end

-- métier de récolte nécessaire pour réunir un objet (nil : tout le monde peut)
local InfoInstant = (C_Item and C_Item.GetItemInfoInstant) or GetItemInfoInstant
local function MetierRecolte(objet)
	if not InfoInstant then return nil end
	local ok, _, _, _, _, _, classe, sous = pcall(InfoInstant, objet)
	if not ok or not classe then return nil end
	local S = Outils().Sources and Outils().Sources()
	local s = S and S.objets and S.objets[objet]
	local recolte = s and s.recolte and #s.recolte > 0
	if classe == 7 and sous == 6 then return "DE" end                 -- cuir : dépeçage
	if recolte and classe == 7 and sous == 9 then return "HE" end     -- herbes
	if recolte and ((classe == 7 and (sous == 7 or sous == 4)) or classe == 3) then return "MI" end -- minerai, pierres, gemmes
	return nil
end
local NOMS_RECOLTE = { HE = "herboristes", MI = "mineurs", DE = "dépeceurs" }

-- membres qualifiés pour une tâche, et si je le suis
local function Qualifies(t)
	local l, moi = {}, false
	if t.recette then
		for _, a in ipairs(ns.ArtisansDe and ns.ArtisansDe(t.objet) or {}) do
			l[#l + 1] = a
			if a.moi then moi = true end
		end
		return l, moi, "Il faut connaître la recette (" .. ((Outils().NomMetier and Outils().NomMetier(t.recette.metier)) or "?") .. ")."
	end
	local code = MetierRecolte(t.objet)
	if not code then return nil, true end
	for _, m in ipairs(ns.MembresAvecMetier and ns.MembresAvecMetier(code) or {}) do
		l[#l + 1] = m
		if m.moi then moi = true end
	end
	return l, moi, "Réservé aux " .. NOMS_RECOLTE[code] .. "."
end

--------------------------------------------------------------------------------
-- Envoi
--------------------------------------------------------------------------------

local TAILLE_MORCEAU = 180
local function EnvoyerProjet(p, relais)
	if p.supprime then Envoyer(("X~%s~%d"):format(p.id, p.supprime)); return end
	if not p.nom then return end
	Envoyer(("P~%s~%d~%s~%s~%s"):format(p.id, p.maj, p.auteur or "?", relais and "1" or "0", Propre(p.nom)))
	local morceaux, cur = {}, {}
	local long = 0
	for _, e in ipairs(p.entrees) do
		local m = e.objet .. ":" .. e.qte
		if long + #m + 1 > TAILLE_MORCEAU and #cur > 0 then
			morceaux[#morceaux + 1] = table.concat(cur, ",")
			cur, long = {}, 0
		end
		cur[#cur + 1] = m
		long = long + #m + 1
	end
	morceaux[#morceaux + 1] = table.concat(cur, ",")
	for i, m in ipairs(morceaux) do Envoyer(("E~%s~%d~%d~%d~%s"):format(p.id, p.maj, i, #morceaux, m)) end
end
local function EnvoyerTache(p, objet)
	local t = p.taches[objet]
	if t then Envoyer(("T~%s~%d~%s~%d~%d"):format(p.id, objet, t.qui or "", t.etat or LIBRE, t.maj or 0)) end
end
local function EnvoyerTout(p, relais)
	EnvoyerProjet(p, relais)
	if not p.supprime then for objet in pairs(p.taches) do EnvoyerTache(p, objet) end end
end

--------------------------------------------------------------------------------
-- Actions locales
--------------------------------------------------------------------------------

ns.CreerProjet = function(nom, entrees)
	nom = strtrim(Propre(nom))
	if nom == "" then return end
	local maintenant = Maintenant()
	local id = (MaCle():gsub("[^%w]", "")):sub(1, 12) .. maintenant
	local p = Projet(id, true)
	p.nom = ns.CouperUTF8 and ns.CouperUTF8(nom, nil, 40) or nom:sub(1, 40)
	p.auteur, p.maj, p.cree = MaCle(), maintenant, maintenant
	for _, e in ipairs(entrees or {}) do
		if e.objet and e.objet > 0 then p.entrees[#p.entrees + 1] = { objet = e.objet, qte = e.qte or 1 } end
	end
	EnvoyerTout(p)
	Maj()
	return p
end

local function Modifie(p)
	p.maj = math.max(Maintenant(), (p.maj or 0) + 1)
	EnvoyerProjet(p)
	Maj()
end

ns.AjouterAProjet = function(id, objet, qte)
	local p = Projet(id)
	if not p or not EstAuteur(p) then return end
	for _, e in ipairs(p.entrees) do
		if e.objet == objet then e.qte = e.qte + (qte or 1); Modifie(p); return p end
	end
	p.entrees[#p.entrees + 1] = { objet = objet, qte = qte or 1 }
	Modifie(p)
	return p
end

local function RetirerDuProjet(p, objet)
	for i, e in ipairs(p.entrees) do
		if e.objet == objet then table.remove(p.entrees, i); Modifie(p); return end
	end
end

local function Supprimer(p)
	p.supprime = math.max(Maintenant(), (p.maj or 0) + 1)
	Envoyer(("X~%s~%d"):format(p.id, p.supprime))
	Maj()
end

local function ChangerTache(p, objet, etat)
	local t = p.taches[objet] or {}
	t.etat = etat
	t.qui = etat == LIBRE and nil or (etat == PRISE and MaCle() or t.qui or MaCle())
	t.maj = math.max(Maintenant(), (t.maj or 0) + 1)
	t.qte = QteTache(p, objet)
	p.taches[objet] = t
	EnvoyerTache(p, objet)
	Maj()
end

--------------------------------------------------------------------------------
-- Réception
--------------------------------------------------------------------------------

local enAttente = {}   -- [id] = { maj, n, morceaux, recu } : objets d'un projet en cours de réception
local orphelines = {}  -- [id] = { [objet] = tâche } : tâches reçues avant leur projet
local annules = {}     -- [id] = true : quelqu'un a déjà renvoyé ce projet après un « Q »
local reponsePrevue = false

local function Alerte(texte, id)
	if ns.Notifier then
		ns.Notifier("commandes", "Projet de guilde", texte, nil, function() ns.OuvrirProjet(id) end)
	end
end

local function Recevoir(prefixe, msg, canal, expediteur)
	if prefixe ~= PREFIXE or canal ~= "GUILD" or not msg or not expediteur then return end
	local cle = Normaliser(expediteur)
	if cle == MaCle() and not TestSolo() then return end
	local genre, reste = msg:match("^(%a)~?(.*)$")
	if genre == "Q" then
		if pret and not reponsePrevue then
			reponsePrevue = true
			wipe(annules)
			C_Timer.After(2 + math.random() * 6, function()
				reponsePrevue = false
				for id, p in pairs(Projets()) do
					if not annules[id] and (p.nom or p.supprime) then EnvoyerTout(p, true) end
				end
			end)
		end
	elseif genre == "P" then
		local id, maj, auteur, relais, nom = reste:match("^([^~]+)~(%d+)~([^~]*)~(%d)~(.*)$")
		if not id then return end
		maj = tonumber(maj)
		-- réceptions abandonnées (morceaux perdus)
		for k, a in pairs(enAttente) do
			if GetTime() - (a.recu or 0) > ATTENTE_MAX then enAttente[k], orphelines[k] = nil, nil end
		end
		local p = Projet(id) -- le projet n'est créé qu'une fois reçu en entier
		local majConnue = p and p.maj or 0
		if maj <= majConnue or (p and p.supprime and p.supprime >= maj) then
			if maj >= majConnue then annules[id] = true end
			return
		end
		annules[id] = true
		enAttente[id] = { maj = maj, nom = nom, auteur = auteur, nouveau = not (p and p.nom) and relais == "0",
			morceaux = {}, recu = GetTime() }
	elseif genre == "E" then
		local id, maj, i, n, liste = reste:match("^([^~]+)~(%d+)~(%d+)~(%d+)~(.*)$")
		local a = id and enAttente[id]
		if not a or tonumber(maj) ~= a.maj then return end
		a.n = tonumber(n)
		a.morceaux[tonumber(i)] = liste
		for k = 1, a.n do if not a.morceaux[k] then return end end
		-- tout est arrivé : on remplace le projet
		local p = Projet(id, true)
		p.nom, p.auteur, p.maj = a.nom, a.auteur, a.maj
		p.cree = p.cree or a.maj
		p.entrees = {}
		for k = 1, a.n do
			for o, q in a.morceaux[k]:gmatch("(%d+):(%d+)") do p.entrees[#p.entrees + 1] = { objet = tonumber(o), qte = tonumber(q) } end
		end
		enAttente[id] = nil
		-- tâches arrivées avant le projet
		for objet, t in pairs(orphelines[id] or {}) do
			if Gagne(t, p.taches[objet]) then p.taches[objet] = t end
		end
		orphelines[id] = nil
		-- tâches d'objets qui ne font plus partie du projet (l'auteur l'a modifié) : retirées
		local f, b = Taches(p)
		local encore = {}
		for _, t in ipairs(f) do encore[t.objet] = true end
		for _, t in ipairs(b) do encore[t.objet] = true end
		for objet in pairs(p.taches) do
			if not encore[objet] then p.taches[objet] = nil end
		end
		if a.nouveau and p.auteur ~= MaCle() then
			Alerte(("%s lance le projet « %s »."):format(NomCourt(p.auteur), p.nom), id)
		end
		Maj()
	elseif genre == "T" then
		local id, objet, qui, etat, maj = reste:match("^([^~]+)~(%d+)~([^~]*)~(%d)~(%d+)$")
		if not id then return end
		objet, etat, maj = tonumber(objet), tonumber(etat), tonumber(maj)
		local nouv = { qui = qui ~= "" and qui or nil, etat = etat, maj = maj }
		local p = Projet(id)
		if not (p and p.nom) then
			-- projet pas encore reçu : la tâche attend (sans créer de coquille)
			if p and p.supprime then return end
			orphelines[id] = orphelines[id] or {}
			if Gagne(nouv, orphelines[id][objet]) then orphelines[id][objet] = nouv end
			return
		end
		local t = p.taches[objet]
		if not Gagne(nouv, t) then return end
		local avant = t and t.etat
		if etat ~= LIBRE then nouv.qte = QteTache(p, objet) end
		p.taches[objet] = nouv
		-- quelqu'un prend une tâche de mon projet : je le sais
		if EstAuteur(p) and etat == PRISE and avant ~= PRISE and qui ~= MaCle() and p.nom then
			local O = Outils()
			Alerte(("%s s'occupe de %s (%s)."):format(NomCourt(qui), (O.InfoObjet and O.InfoObjet(objet)) or "un objet", p.nom), id)
		end
		Maj()
	elseif genre == "X" then
		local id, maj = reste:match("^([^~]+)~(%d+)$")
		if not id then return end
		maj = tonumber(maj)
		local p = Projet(id, true)
		annules[id] = true
		if (p.supprime or 0) >= maj or maj < (p.maj or 0) then return end
		p.supprime = maj
		Maj()
	end
end

--------------------------------------------------------------------------------
-- Onglet « Projets » de la fenêtre Artisanat de la guilde
--------------------------------------------------------------------------------

local page, choisi
local boutonsProjets, lignes = {}, {}
local LARGEUR_C = 200

local function CouleurNom(cle)
	return (cle == MaCle() and "|cff33dd55" or "|cffffd100") .. NomCourt(cle) .. "|r"
end

local function BoutonProjet(i)
	local b = boutonsProjets[i]
	if b then return b end
	b = CreateFrame("Button", nil, page.contC)
	b:SetHeight(40)
	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	b.choisi = b:CreateTexture(nil, "BACKGROUND")
	b.choisi:SetAllPoints(b)
	b.choisi:SetColorTexture(1, 0.82, 0, 0.18)
	b.nom = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	b.nom:SetPoint("TOPLEFT", b, "TOPLEFT", 6, -5)
	b.nom:SetPoint("RIGHT", b, "RIGHT", -4, 0)
	b.nom:SetJustifyH("LEFT")
	b.nom:SetWordWrap(false)
	b.info = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.info:SetPoint("TOPLEFT", b.nom, "BOTTOMLEFT", 0, -3)
	b.info:SetPoint("RIGHT", b, "RIGHT", -4, 0)
	b.info:SetJustifyH("LEFT")
	b:SetScript("OnClick", function(self) choisi = self.id; page.defile:SetVerticalScroll(0); Maj() end)
	boutonsProjets[i] = b
	return b
end

local function Ligne(i)
	local l = lignes[i]
	if l then return l end
	l = CreateFrame("Button", nil, page.contenu)
	l:SetHeight(28)
	l.fond = l:CreateTexture(nil, "BACKGROUND")
	l.fond:SetAllPoints(l)
	l:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	l.icone = l:CreateTexture(nil, "ARTWORK")
	l.icone:SetSize(22, 22)
	l.icone:SetPoint("LEFT", l, "LEFT", 4, 0)
	l.texte = l:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	l.texte:SetPoint("TOPLEFT", l.icone, "TOPRIGHT", 6, 1)
	l.texte:SetJustifyH("LEFT")
	l.texte:SetWordWrap(false)
	l.etat = l:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	l.etat:SetPoint("BOTTOMLEFT", l.icone, "BOTTOMRIGHT", 6, 0)
	l.etat:SetJustifyH("LEFT")
	l.etat:SetWordWrap(false)
	l.action = CreateFrame("Button", nil, l, "UIPanelButtonTemplate")
	l.action:SetSize(112, 22)
	l.action:SetPoint("RIGHT", l, "RIGHT", -26, 0)
	l.action2 = CreateFrame("Button", nil, l, "UIPanelButtonTemplate")
	l.action2:SetSize(70, 22)
	l.action2:SetPoint("RIGHT", l.action, "LEFT", -4, 0)
	l.retirer = CreateFrame("Button", nil, l, "UIPanelCloseButton")
	l.retirer:SetSize(22, 22)
	l.retirer:SetPoint("RIGHT", l, "RIGHT", 0, 0)
	l.texte:SetPoint("RIGHT", l.action2, "LEFT", -6, 0)
	l.etat:SetPoint("RIGHT", l.action2, "LEFT", -6, 0)
	for _, b in ipairs({ l.action, l.action2 }) do
		b:SetScript("OnEnter", function(self)
			if not self.bulle then return end
			GameTooltip:SetOwner(self, "ANCHOR_TOP")
			GameTooltip:SetText(self.bulle, 1, 1, 1, 1, true)
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", function() GameTooltip:Hide() end)
		b:SetMotionScriptsWhileDisabled(true)
	end
	l:SetScript("OnClick", function(self)
		if self.objet and ns.OuvrirFiche then ns.OuvrirFiche(self.objet, self.qte, _G.GuildUpArtisanat) end
	end)
	l:SetScript("OnEnter", function(self)
		if not self.objet then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		pcall(GameTooltip.SetItemByID, GameTooltip, self.objet)
		if self.qualifies then
			GameTooltip:AddLine(" ")
			if #self.qualifies == 0 then
				GameTooltip:AddLine("Personne dans la guilde n'est noté pour cette tâche.", 1, 0.5, 0.3, true)
			else
				GameTooltip:AddLine("Peuvent s'en occuper :", 1, 0.82, 0)
				for k = 1, math.min(8, #self.qualifies) do
					local a = self.qualifies[k]
					GameTooltip:AddLine("  - " .. NomCourt(a.nom) .. (a.enLigne and " |cff33dd55(en ligne)|r" or ""), 1, 1, 1)
				end
				if #self.qualifies > 8 then GameTooltip:AddLine(("  … et %d autres"):format(#self.qualifies - 8), 0.7, 0.7, 0.7) end
			end
		end
		GameTooltip:AddLine("Clic : fiche dans l'encyclopédie", 0.6, 0.6, 0.6)
		GameTooltip:Show()
	end)
	l:SetScript("OnLeave", function() GameTooltip:Hide() end)
	lignes[i] = l
	return l
end

local function Bouton(b, texte, actif, bulle, action)
	b:SetText(texte)
	b:SetEnabled(actif)
	b.bulle = bulle
	b:SetScript("OnClick", action)
	b:Show()
end

MajPage = function()
	if not page or not page:IsVisible() then return end
	local liste = ListeProjets()
	-- colonne de gauche : les projets
	if choisi and not (Projet(choisi) and Projet(choisi).nom and not Projet(choisi).supprime) then choisi = nil end
	if not choisi and liste[1] then choisi = liste[1].id end
	local y = 2
	for i, p in ipairs(liste) do
		local b = BoutonProjet(i)
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", page.contC, "TOPLEFT", 0, -y)
		b:SetWidth(page.contC:GetWidth())
		b.id = p.id
		b.choisi:SetShown(p.id == choisi)
		b.nom:SetText(p.nom)
		local faites, total = Avancement(p)
		b.info:SetText(("par %s  ·  %s%d / %d|r"):format(CouleurNom(p.auteur), faites == total and total > 0 and "|cff33dd55" or "|cffffffff", faites, total))
		b:Show()
		y = y + 42
	end
	for i = #liste + 1, #boutonsProjets do boutonsProjets[i]:Hide() end
	page.contC:SetHeight(math.max(10, y))
	page.videC:SetShown(#liste == 0)

	-- partie droite : le projet choisi
	local p = choisi and Projet(choisi)
	page.entete:SetShown(p ~= nil)
	page.vide:SetShown(p == nil)
	if not p then
		for _, l in ipairs(lignes) do l:Hide() end
		page.contenu:SetHeight(10)
		return
	end
	local O = Outils()
	page.titreP:SetText(p.nom)
	page.auteurP:SetText(("Projet de %s  ·  %d objectif%s"):format(CouleurNom(p.auteur), #p.entrees, #p.entrees > 1 and "s" or ""))
	local faites, total = Avancement(p)
	page.barre:SetMinMaxValues(0, math.max(1, total))
	page.barre:SetValue(faites)
	page.barre.texte:SetText(("%d / %d tâches faites"):format(faites, total))
	page.supprimer:SetShown(EstAuteur(p))
	page.ajouter:SetShown(EstAuteur(p))

	local fab, base = Taches(p)
	local i, yy = 0, 2
	local largeur = page.contenu:GetWidth()
	local function Titre(texte)
		i = i + 1
		local l = Ligne(i)
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", page.contenu, "TOPLEFT", 0, -yy)
		l:SetWidth(largeur)
		l:SetHeight(22)
		l.objet, l.qualifies = nil, nil
		l.fond:SetColorTexture(1, 0.82, 0, 0.12)
		l.icone:Hide()
		l.texte:SetFontObject("GameFontNormal")
		l.texte:ClearAllPoints()
		l.texte:SetPoint("LEFT", l, "LEFT", 8, 0)
		l.texte:SetPoint("RIGHT", l, "RIGHT", -8, 0)
		l.texte:SetText(texte)
		l.etat:SetText("")
		l.action:Hide(); l.action2:Hide(); l.retirer:Hide()
		l:Show()
		yy = yy + 25
	end
	local function Tache(t, k)
		i = i + 1
		local l = Ligne(i)
		l:ClearAllPoints()
		l:SetPoint("TOPLEFT", page.contenu, "TOPLEFT", 0, -yy)
		l:SetWidth(largeur)
		l:SetHeight(30)
		l.objet, l.qte = t.objet, t.qte
		l.fond:SetColorTexture(1, 1, 1, k % 2 == 0 and 0.05 or 0.02)
		local nom, _, qualite, icone = (O.InfoObjet or function() end)(t.objet)
		if not nom and O.Precharger then O.Precharger(t.objet) end
		l.icone:SetTexture(icone or "Interface\\Icons\\INV_Misc_QuestionMark")
		l.icone:Show()
		l.texte:SetFontObject("GameFontHighlight")
		l.texte:ClearAllPoints()
		l.texte:SetPoint("TOPLEFT", l.icone, "TOPRIGHT", 6, 1)
		l.texte:SetPoint("RIGHT", l.action2, "LEFT", -6, 0)
		local qc = qualite and ITEM_QUALITY_COLORS and ITEM_QUALITY_COLORS[qualite]
		local detail = ""
		if t.recette then
			detail = ("  |cff999999%s %d|r"):format(O.NomMetier and O.NomMetier(t.recette.metier) or "?", t.recette.niveau)
		end
		local jai = O.JAi and O.JAi(t.objet) or 0
		l.texte:SetText(("%s%s|r |cffffffffx%d|r%s%s%s"):format(qc and qc.hex or "|cffffffff", nom or "…", t.qte, detail,
			t.objectif and "  |cffffd100(objectif)|r" or "", jai > 0 and ("  |cff999999(tu en as %d)|r"):format(jai) or ""))
		local etat, qui = Etat(p, t.objet, t.qte)
		local qualifies, moiOk, raison = Qualifies(t)
		l.qualifies = qualifies
		if etat == FAITE then
			l.etat:SetText("|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t |cff33dd55Fait|r par " .. CouleurNom(qui))
		elseif etat == PRISE then
			l.etat:SetText(CouleurNom(qui) .. " s'en occupe")
		else
			l.etat:SetText("|cff999999Libre|r")
		end
		l.action2:Hide()
		local moi, auteur = qui == MaCle(), EstAuteur(p)
		if etat == LIBRE then
			Bouton(l.action, "Je m'en occupe", moiOk, not moiOk and raison or "Ton nom s'affichera pour toute la guilde.",
				function() ChangerTache(p, t.objet, PRISE) end)
		elseif etat == PRISE and moi then
			Bouton(l.action, "C'est fait !", true, "Tâche terminée (objets fabriqués ou réunis).", function() ChangerTache(p, t.objet, FAITE) end)
			Bouton(l.action2, "Libérer", true, "Tu ne t'en occupes plus : la tâche redevient libre.", function() ChangerTache(p, t.objet, LIBRE) end)
		elseif etat == PRISE and auteur then
			Bouton(l.action, "Libérer", true, "Rendre la tâche libre (créateur du projet).", function() ChangerTache(p, t.objet, LIBRE) end)
		elseif etat == FAITE and (moi or auteur) then
			Bouton(l.action, "Pas encore fait", true, "Annuler : la tâche redevient libre.", function() ChangerTache(p, t.objet, LIBRE) end)
		else
			l.action:Hide()
		end
		l.retirer:SetShown(auteur and t.objectif)
		l.retirer:SetScript("OnClick", function() RetirerDuProjet(p, t.objet) end)
		l:Show()
		yy = yy + 32
	end
	if #fab + #base == 0 then
		Titre(EstAuteur(p) and "Projet vide : ajoute des objets depuis l'onglet Items (bouton Ajouter)." or "Projet vide pour l'instant.")
	end
	if #fab > 0 then
		Titre(("À fabriquer (%d)"):format(#fab))
		for k, t in ipairs(fab) do Tache(t, k) end
		yy = yy + 6
	end
	if #base > 0 then
		Titre(("À réunir (%d)"):format(#base))
		for k, t in ipairs(base) do Tache(t, k) end
	end
	for j = i + 1, #lignes do lignes[j]:Hide() end
	page.contenu:SetHeight(math.max(10, yy))
end

-- menu « Nouveau projet » : vide, ou copie d'une de mes listes
local menuNouveau
local function MenuNouveau(ancre)
	if not menuNouveau then
		menuNouveau = CreateFrame("Frame", "GuildUpMenuNouveauProjet", UIParent, "BackdropTemplate")
		menuNouveau:SetFrameStrata("FULLSCREEN_DIALOG")
		menuNouveau:SetClampedToScreen(true)
		if menuNouveau.SetBackdrop then
			menuNouveau:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14,
				insets = { left = 3, right = 3, top = 3, bottom = 3 } })
			menuNouveau:SetBackdropColor(0.05, 0.05, 0.05, 0.97)
		end
		menuNouveau.boutons = {}
		menuNouveau:SetScript("OnUpdate", function(self)
			if not self:IsMouseOver(20, -20, -20, 20) and not (self.ancre and self.ancre:IsMouseOver()) then self:Hide() end
		end)
		tinsert(UISpecialFrames, "GuildUpMenuNouveauProjet")
	end
	local m = menuNouveau
	local choix = { { "|cff33dd55Projet vide…|r", nil } }
	local carnets = Outils().Carnets and Outils().Carnets() or {}
	local noms = {}
	for nom in pairs(carnets) do noms[#noms + 1] = nom end
	table.sort(noms)
	for _, nom in ipairs(noms) do choix[#choix + 1] = { "À partir de « " .. nom .. " »", nom } end
	for i, c in ipairs(choix) do
		local b = m.boutons[i]
		if not b then
			b = CreateFrame("Button", nil, m)
			b:SetHeight(20)
			b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
			b.texte = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
			b.texte:SetPoint("LEFT", b, "LEFT", 8, 0)
			m.boutons[i] = b
		end
		b:ClearAllPoints()
		b:SetPoint("TOPLEFT", m, "TOPLEFT", 4, -4 - (i - 1) * 20)
		b:SetPoint("RIGHT", m, "RIGHT", -4, 0)
		b.texte:SetText(c[1])
		b:SetScript("OnClick", function()
			m:Hide()
			local entrees = {}
			if c[2] then
				for _, e in ipairs(carnets[c[2]].entrees or {}) do
					if e.objet then entrees[#entrees + 1] = { objet = e.objet, qte = e.qte } end
				end
			end
			StaticPopup_Show("GUILDUP_NOUVEAU_PROJET", nil, nil, { entrees = entrees, nom = c[2] })
		end)
		b:Show()
	end
	for i = #choix + 1, #m.boutons do m.boutons[i]:Hide() end
	m:SetSize(230, 8 + #choix * 20)
	m.ancre = ancre
	m:ClearAllPoints()
	m:SetPoint("TOPLEFT", ancre, "BOTTOMLEFT", 0, -2)
	m:Show()
end
ns.MenuNouveauProjet = MenuNouveau

StaticPopupDialogs["GUILDUP_NOUVEAU_PROJET"] = {
	text = "Nom du projet de guilde :",
	button1 = "Créer",
	button2 = "Annuler",
	hasEditBox = true,
	maxLetters = 40,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnShow = function(self, data)
		local boite = self.editBox or self.EditBox
		if boite and data and data.nom then boite:SetText(data.nom) end
	end,
	OnAccept = function(self, data)
		local boite = self.editBox or self.EditBox
		local nom = boite and strtrim(boite:GetText() or "") or ""
		if nom == "" then return end
		data = data or {}
		local p = ns.CreerProjet(nom, data.entrees)
		if p and data.objet then ns.AjouterAProjet(p.id, data.objet, 1) end
		if p then choisi = p.id; ns.OuvrirProjet(p.id) end
	end,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		StaticPopupDialogs["GUILDUP_NOUVEAU_PROJET"].OnAccept(parent, parent.data)
		parent:Hide()
	end,
}
StaticPopupDialogs["GUILDUP_SUPPRIMER_PROJET"] = {
	text = "Supprimer le projet « %s » pour toute la guilde ?",
	button1 = "Supprimer",
	button2 = "Annuler",
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	OnAccept = function(self, data) local p = data and Projet(data); if p then Supprimer(p) end end,
}

ns.CreerPageProjets = function(f)
	local haut = ns.HAUT_ENCART or -88
	local p = CreateFrame("Frame", nil, f)
	p:SetAllPoints(f)
	page = p
	local largeur = f:GetWidth()
	local titre = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	titre:SetPoint("TOPLEFT", f, "TOPLEFT", 70, -32)
	titre:SetText("Projets de guilde")
	local aide = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	aide:SetPoint("TOPLEFT", f, "TOPLEFT", 72, -58)
	aide:SetWidth(440)
	aide:SetJustifyH("LEFT")
	aide:SetText("Des listes partagées avec toute la guilde : chacun prend une tâche qu'il sait faire.")
	local nouveau = CreateFrame("Button", nil, p, "UIPanelButtonTemplate")
	nouveau:SetSize(140, 24)
	nouveau:SetPoint("TOPRIGHT", f, "TOPRIGHT", -16, -56)
	nouveau:SetText("+ Nouveau projet")
	nouveau:SetScript("OnClick", function(self) MenuNouveau(self) end)

	-- colonne des projets
	local fondC = p:CreateTexture(nil, "BACKGROUND")
	fondC:SetPoint("TOPLEFT", f, "TOPLEFT", 8, haut - 4)
	fondC:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 8, 10)
	fondC:SetWidth(LARGEUR_C)
	fondC:SetColorTexture(0, 0, 0, 0.3)
	local defC = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
	defC:SetPoint("TOPLEFT", f, "TOPLEFT", 12, haut - 8)
	defC:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 14)
	defC:SetWidth(LARGEUR_C - 26)
	p.contC = CreateFrame("Frame", nil, defC)
	p.contC:SetSize(LARGEUR_C - 28, 10)
	defC:SetScrollChild(p.contC)
	p.videC = p:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	p.videC:SetPoint("TOP", fondC, "TOP", 0, -30)
	p.videC:SetWidth(LARGEUR_C - 20)
	p.videC:SetText("Aucun projet pour l'instant.\n\nLance le premier avec « + Nouveau projet ».")

	-- projet choisi
	local x0 = LARGEUR_C + 20
	local fondL = p:CreateTexture(nil, "BACKGROUND")
	fondL:SetPoint("TOPLEFT", f, "TOPLEFT", x0 - 4, haut - 4)
	fondL:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 10)
	fondL:SetColorTexture(0, 0, 0, 0.2)
	p.entete = CreateFrame("Frame", nil, p)
	p.entete:SetPoint("TOPLEFT", f, "TOPLEFT", x0, haut - 8)
	p.entete:SetPoint("RIGHT", f, "RIGHT", -12, 0)
	p.entete:SetHeight(60)
	p.titreP = p.entete:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	p.titreP:SetPoint("TOPLEFT", p.entete, "TOPLEFT", 4, 0)
	p.titreP:SetPoint("RIGHT", p.entete, "RIGHT", -190, 0)
	p.titreP:SetJustifyH("LEFT")
	p.titreP:SetWordWrap(false)
	p.auteurP = p.entete:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	p.auteurP:SetPoint("TOPLEFT", p.titreP, "BOTTOMLEFT", 0, -4)
	local Barre = Outils().BarreMetier
	p.barre = Barre and Barre(p.entete, largeur - x0 - 40) or CreateFrame("StatusBar", nil, p.entete)
	if not p.barre.texte then p.barre.texte = p.barre:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); p.barre.texte:SetPoint("CENTER") end
	p.barre:SetPoint("TOPLEFT", p.entete, "TOPLEFT", 4, -42)
	p.supprimer = CreateFrame("Button", nil, p.entete, "UIPanelButtonTemplate")
	p.supprimer:SetSize(90, 22)
	p.supprimer:SetPoint("TOPRIGHT", p.entete, "TOPRIGHT", 0, 0)
	p.supprimer:SetText("Supprimer")
	p.supprimer:SetScript("OnClick", function()
		local pr = choisi and Projet(choisi)
		if pr then StaticPopup_Show("GUILDUP_SUPPRIMER_PROJET", pr.nom, nil, pr.id) end
	end)
	p.ajouter = CreateFrame("Button", nil, p.entete, "UIPanelButtonTemplate")
	p.ajouter:SetSize(96, 22)
	p.ajouter:SetPoint("RIGHT", p.supprimer, "LEFT", -4, 0)
	p.ajouter:SetText("+ Objets")
	p.ajouter:SetScript("OnClick", function() if ns.OuvrirArtisanat then ns.OuvrirArtisanat(2) end end)
	p.ajouter:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText("Ajouter des objets au projet")
		GameTooltip:AddLine("Dans l'onglet Items (ou l'encyclopédie), bouton « Ajouter », puis choisis ce projet.", 1, 1, 1, true)
		GameTooltip:Show()
	end)
	p.ajouter:SetScript("OnLeave", function() GameTooltip:Hide() end)
	local defile = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
	defile:SetPoint("TOPLEFT", f, "TOPLEFT", x0, haut - 74)
	defile:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -30, 14)
	p.defile = defile
	p.contenu = CreateFrame("Frame", nil, defile)
	p.contenu:SetSize(largeur - x0 - 42, 10)
	defile:SetScrollChild(p.contenu)
	p.vide = p:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	p.vide:SetPoint("TOP", fondL, "TOP", 0, -60)
	p.vide:SetWidth(largeur - x0 - 60)
	p.vide:SetText("Choisis un projet à gauche, ou crée-en un.")
	p:SetScript("OnShow", function() MajPage() end)
	return p
end

ns.OuvrirProjet = function(id)
	if id then choisi = id end
	if ns.OuvrirArtisanat then ns.OuvrirArtisanat(3) end
	Maj()
end
ns.MajProjets = Maj

ns.DiagProjets = function(L)
	local n, t = 0, 0
	for _, p in ipairs(ListeProjets()) do n = n + 1; for _ in pairs(p.taches) do t = t + 1 end end
	L(("projets : %d (%d tâches suivies)"):format(n, t))
end

--------------------------------------------------------------------------------
-- Évènements
--------------------------------------------------------------------------------

do
	local inscription = (C_ChatInfo and C_ChatInfo.RegisterAddonMessagePrefix) or RegisterAddonMessagePrefix
	if inscription then pcall(inscription, PREFIXE) end
end

local ev = CreateFrame("Frame")
for _, nom in ipairs({ "CHAT_MSG_ADDON", "PLAYER_ENTERING_WORLD", "GUILD_ROSTER_UPDATE" }) do pcall(ev.RegisterEvent, ev, nom) end
local premiere = true
ev:SetScript("OnEvent", function(_, event, a1, a2, a3, a4)
	if event == "CHAT_MSG_ADDON" then
		Recevoir(a1, a2, a3, a4)
	elseif event == "GUILD_ROSTER_UPDATE" then
		if page and page:IsVisible() then Maj() end
	elseif event == "PLAYER_ENTERING_WORLD" and premiere then
		premiere = false
		C_Timer.After(25, function()
			pret = true
			Envoyer("Q")
		end)
	end
end)
