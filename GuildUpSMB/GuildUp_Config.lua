-- GuildUpSMB : réglages propres à la guilde (chargé en premier, voir le .toc).
-- C'est le seul fichier à modifier pour adapter l'addon à une autre guilde : tout le reste passe par
-- le canal de guilde du jeu et marche tel quel. Aucun message réseau.
-- Après une modification : /reload en jeu.

local NOM_ADDON, ns = ...

ns.Config = {
	-- Nom affiché dans la fenêtre « Nouveautés » (ex. "GuildUpSMB — Les Gardiens")
	nomPublic = "GuildUpSMB",

	-- Cri de guilde : quand un membre l'écrit (seul, ou suivi de « ! »), une emote monte à l'écran
	-- de toute la guilde. Lettres sans accent ou chiffres, sans espace. false pour désactiver.
	cri = "33",

	-- Emote animée : planche d'images de media\ lue de gauche à droite puis de haut en bas
	-- (TGA 32 bits ; ici 512 x 256 : 8 images de 128 x 128, 4 par rangée, 10 images par seconde).
	-- false = image fixe media\gu_emote.tga (128 x 128), qui sert aussi d'icône de l'addon.
	emoteAnimation = { fichier = "emote_animee", images = 8, colonnes = 4, rangees = 2, ips = 10 },

	-- Membre « vedette » : quand il monte de niveau, la bulle passe en version fête (corne, texte
	-- arc-en-ciel, animation). Écrire "Prénom-Famille" (ex. "Zaardoz-Gu"), ou false pour rien.
	vedette = false,

	-- Animation de la vedette : true = planche media\zaardoz.tga (1024 x 512, 19 images de
	-- 115 x 128, 8 par rangée). false = fête sans image (texte arc-en-ciel et corne seulement).
	vedetteAnimation = false,

	-- Carte du monde : diamètre en pixels du point qui marque chaque membre de la guilde
	taillePointCarte = 16,
}
