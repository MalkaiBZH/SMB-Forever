-- GuildUpSMB : réglages propres à la guilde (chargé en premier, voir le .toc).
-- C'est le seul fichier à modifier pour adapter l'addon à une autre guilde : tout le reste passe par
-- le canal de guilde du jeu et marche tel quel. Aucun message réseau.
-- Après une modification : /reload en jeu.

local NOM_ADDON, ns = ...

ns.Config = {
	-- Nom affiché dans la fenêtre « Nouveautés » (ex. "GuildUpSMB — Les Gardiens")
	nomPublic = "SMB Forever",

	-- Cri de guilde : quand un membre l'écrit (seul, ou suivi de « ! »), une emote monte à l'écran
	-- de toute la guilde. Lettres sans accent ou chiffres, sans espace. false pour désactiver.
	cri = "33",

	-- Emote animée : planche d'images de media\ lue de gauche à droite puis de haut en bas
	-- (TGA 32 bits ; ici 1024 x 256 : 16 images de 128 x 128, 8 par rangée, 10 images par seconde).
	-- false = image fixe media\gu_emote.tga (128 x 128), qui sert aussi d'icône de l'addon.
	emoteAnimation = { fichier = "emote_animee", images = 16, colonnes = 8, rangees = 2, ips = 10 },

	-- Membre « vedette » : quand il monte de niveau, la bulle passe en version fête (corne, texte
	-- arc-en-ciel, bordure changeante). Écrire "Prénom-Famille", ou false pour rien.
	vedette = false,

	-- Carte du monde : diamètre en pixels du point qui marque chaque membre de la guilde
	taillePointCarte = 16,

	-- Repères des membres sur le tour de l'écran (GuildUp_Reperes.lua) : angle de vue (degrés) qui
	-- correspond à toute la largeur de l'écran (à ajuster si les repères du haut ne tombent pas dans la
	-- direction des joueurs), position des repères du haut, membres devant soi (pixels sous le haut de
	-- l'écran) et du bas, membres derrière soi (pixels au-dessus du bas de l'écran, au-dessus des
	-- barres d'action).
	champVisionReperes = 90,
	hautReperes = 34,
	basReperes = 150,
}
