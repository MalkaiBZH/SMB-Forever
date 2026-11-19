-- GuildUpSMB : bestiaire du WoWdex (GuildUp_Wowdex.lua) : les monstres hostiles de WoW Forever.
-- FICHIER GÉNÉRÉ par outils/generer_bestiaire.py : ne pas modifier à la main.
-- Données tirées de la base QuestieDB, version Forever (GPL-3.0, merci à ses auteurs) :
-- https://github.com/Questie/QuestieDB (data/Forever et l10n/Forever, réf. HEAD, le 2026-11-19).
-- Ligne (numéro dans le WoWdex = rang de la ligne) :
--   pnj|nom français|nom anglais (vide si le même)|niv min|niv max|rang|zones|butin
-- rang : 0 normal, 1 élite, 2 rare élite, 3 boss, 4 rare ; zones : zone:x,y;x,y#zone:… (0-100, zone
-- principale d'abord) ; butin : objets particuliers (lâchés par 40 monstres au plus), les plus rares d'abord.
-- Zones : zone|nom|carte (uiMapID).

local NOM_ADDON, ns = ...

ns.BESTIAIRE = [==[
7732|Blatte mécanique|Dupe Bug|1|1|0|1:20,32|
705|Jeune loup décharné|Ragged Young Wolf|1|1|0|1:32,71;31,75;27,71;26,78;29,74;28,72;29,77;30,74|750,7073,7074,4865
299|Jeune loup|Young Wolf|1|1|0|12:43,63;45,55;46,45;45,43;47,41;47,38;48,40;49,45|2396,2398,3471,4766,7280,4302,750,7073,7074,4865
3444|Rat fouisseur|Dig Rat|1|1|0|17:49,84;48,86;47,85|5051,5052
1508|Jeune charognard|Young Scavenger|1|1|0|85:33,67;31,56;30,64;34,57;31,62;29,68;29,66;30,63|3265,7073,7074,4865
1501|Zombie lunatique|Mindless Zombie|1|1|0|85:35,63;35,65;34,64;31,64;32,64;33,65|
12247|Bâtiment du Fléau|Scourge Structure|1|1|0|139:23,29;27,24;32,14;35,31;20,16;37,20;25,18;28,18|
2031|Jeune sabre-de-nuit|Young Nightsaber|1|1|0|141:63,42;64,42;58,47;62,44;62,45;59,46;61,45;58,39|7073,7074,4865
11819|Jory Zaga||1|1|0|148:69,20|
11817|Krah'ranik||1|1|0|148:69,20|
707|Trogg Mâcheroc|Rockjaw Trogg|1|2|0|1:32,74;24,73;23,76;29,76;30,76;30,77;32,76;31,77|
6|Vermine kobold|Kobold Vermin|1|2|0|12:49,36;48,37;50,36;48,35;49,35;52,36;51,37|5364,755
3098|Sanglier tacheté|Mottled Boar|1|2|0|14:45,70;41,65;41,72;46,67;44,73;45,60;44,64;45,62|7098,769,4865
1512|Chauve-souris du crépuscule|Duskbat|1|2|0|85:32,69;31,73;34,69;28,64;34,68;32,56;30,64;29,69|3264,7073,7074,4865
1502|Zombie décharné|Wretched Zombie|1|2|0|85:34,66;32,62;34,64;34,63;33,61;34,61|
1984|Jeune sanglier des chardons|Young Thistle Boar|1|2|0|141:57,42;55,42;63,42;62,41;58,40;57,46;61,46;60,45|7098,4865
2955|Trotteur des plaines|Plainstrider|1|2|0|215:49,86;46,85;43,84;44,80;48,76;51,87;49,79;46,84|4739,4740,4759,4806,7096,7097,4757
704|Loup des bois décharné|Ragged Timber Wolf|2|2|0|1:23,79;24,80;26,80;26,75;28,78;28,76;27,75;29,77|750,7073,7074,4865
724|Trogg Mâcheroc forcené|Burly Rockjaw Trogg|2|2|0|1:32,74;26,72;25,73;21,75;23,75;27,73;30,77|2787
69|Loup des bois|Timber Wolf|2|2|0|12:46,40;48,38;46,37;45,35;53,35;53,39;51,44;49,49|750,7073,7074,4865
2032|Sabre-de-nuit galeux|Mangy Nightsaber|2|2|0|141:60,36;62,39;62,37;63,37;59,36;61,36;62,35|7073,7074,4865
1509|Charognard pouilleux|Ragged Scavenger|2|3|0|85:37,63;38,63;37,61;38,56;36,59;35,65;36,62;35,59|3265,7073,7074,4865
1917|Daniel Ulfman||2|3|0|85:37,62|3293
1504|Jeune Tisse-nuit|Young Night Web Spider|2|3|0|85:28,57;28,55;30,57;27,58;27,57;29,56;29,59;29,57|7100,7101,1476
1918|Karrel Grayves||2|3|0|85:37,62|3294
1890|Squelette Cliquethorax|Rattlecage Skeleton|2|3|0|85:35,64;34,65;34,62;32,62;32,60;33,60;34,61;33,62|3262,6281
1916|Stephen Bhartec||2|3|0|85:36,62|3296
1988|Grell||2|3|0|141:56,45;56,46|3297
1985|Sanglier des chardons|Thistle Boar|2|3|0|141:55,37;56,39;57,36;60,39;58,35;59,35;60,37;61,35|7098,769,4865
708|Petit sanglier des rochers|Small Crag Boar|3|3|0|1:32,72;27,69;24,72;21,69;20,71;21,72;22,70;21,75|2886,7098,769,4865
257|Ouvrier kobold|Kobold Worker|3|3|0|12:52,38;47,35;48,33;47,32;50,34;46,33;48,36|755
3124|Scorpide ouvrier|Scorpid Worker|3|3|0|14:41,62;45,73;46,59;39,61;42,57;41,69;41,63;41,64|4862,7099,7100,7101,4867
1506|Converti écarlate|Scarlet Convert|3|3|0|85:38,65;38,72;37,71;37,68;39,69;37,66;37,70;37,69|2754,3266
2961|Puma des montagnes|Mountain Cougar|3|3|0|215:54,92;43,83;52,88;48,87;51,88;46,90;45,89;41,87|4742,7073,7074,4865
1718|Ecumeur Mâcheroc|Rockjaw Raider|3|4|0|1:36,69;35,68;34,69;35,69;35,71;36,68;36,66|2054
706|Jeune troll Frostmane|Frostmane Troll Whelp|3|4|0|1:21,76;21,78;24,80;26,79;27,79;28,81;29,80;29,81|2108
946|Novice Frostmane|Frostmane Novice|3|4|0|1:29,83;29,81;30,81;30,80;66,41|2110,6753
38|Nervi défias|Defias Thug|3|4|0|12:53,46;52,47;54,51;54,49;54,52;54,47;56,45;57,41|752,2057
80|Travailleur kobold|Kobold Laborer|3|4|0|12:48,32;48,30;49,28;48,28;49,27;50,26;50,27|2055,755
3102|Traqueur corrompu|Felstalker|3|4|0|14:43,52;45,52;43,55;44,55;43,54;45,53;44,52;46,55|6640,7073,7074,4865
3101|Vil quasit|Vile Familiar|3|4|0|14:46,56;44,54;43,53;44,53;46,57;45,58;45,54;45,56|6487
1505|Araignée Tisse-nuit|Night Web Spider|3|4|0|85:24,61;24,58;23,59;26,60;25,60|3263,7100,7101,1476
1513|Chauve-souris du crépuscule galeuse|Mangy Duskbat|3|4|0|85:37,57;38,58;38,62;35,61;36,59;34,62;35,65;35,63|3264,7073,7074,4865
1507|Initié écarlate|Scarlet Initiate|3|4|0|85:38,65;38,72;37,71;37,68;39,69;37,66;37,70;37,69|3260,3266
1986|Araignée Tissebois|Webwood Spider|3|4|0|141:58,27;57,27;56,25;57,31;56,27;57,32;57,28;56,29|5166,10640,7100,7101,1476
1989|Grellide|Grellkin|3|4|0|141:54,40;54,39;55,40;56,35;55,44;55,39;54,44|10639,3297
2953|Chaman Dos-hirsute|Bristleback Shaman|3|4|0|215:62,78;60,77;59,76;57,76;60,81;57,78|1388,6634,4770
2952|Huran Dos-hirsute|Bristleback Quilboar|3|4|0|215:55,81;58,78;58,77;56,79;61,79;57,83;56,83;57,80|1384,4770
2966|Sanglier de guerre|Battleboar|3|4|0|215:56,88;57,87;52,77;56,87;54,86;53,85;53,79;52,82|4848,4849,7098,4865
3281|Sarkoth||4|4|0|14:40,67|4905,4862,7099,7100,7101,4867
2954|Sanglier de guerre Dos-hirsute|Bristleback Battleboar|4|5|0|215:62,78;58,76;59,77;59,79;57,79;58,80;60,78;60,79|4848,4849,7098,4865
808|Grik'nir le Froid|Grik'nir the Cold|5|5|0|1:30,80|2004,2109
103|Garrick Padfoot||5|5|0|12:58,48|182,2057
3183|Yarrog Baneshadow||5|5|0|14:43,53|4859
1688|Matriarche Tisse-nuit|Night Web Matriarch|5|5|0|85:24,58|3261,7100,7101,1476
1667|Meven Korgal||5|5|0|85:37,69|2885,3266
1919|Samuel Fipps||5|5|0|85:37,62|3295,16333
1994|Githyiss la Vile|Githyiss the Vile|5|5|0|141:57,26|7100,7101,1476
8554|Chef Brochaigu Mantépine|Chief Sharptusk Thornmantle|5|5|0|215:61,78|10459
3229|Mouchard de Mantépine|"Squealer" Thornmantle|5|5|0|215:60,82|4951
5680|Captif humain|Male Human Captive|5|5|0|1497:52,22;51,22|
1199|Jeune Léopard des neiges|Juvenile Snow Leopard|5|6|0|1:45,58;41,62;39,61;36,61;43,56;40,59;42,60;44,60|4814,4813
1128|Jeune ours noir|Young Black Bear|5|6|0|1:45,49;42,67;34,60;30,56;44,45;44,52;40,61;48,50|6952,3169,3170,7073,3173,7074,4865
1134|Jeune wendigo|Young Wendigo|5|6|0|1:39,49;40,46;43,55;43,56;42,55|2671
1125|Sanglier des rochers|Crag Boar|5|6|0|1:48,49;46,62;42,67;38,60;35,58;45,58;46,64;50,62|2886,3171,771,769
30|Araignée forestière|Forest Spider|5|6|0|12:36,56;36,63;28,67;36,69;38,73;40,79;41,75;39,73|2590,1476,5465
525|Loup galeux|Mangy Wolf|5|6|0|12:57,70;36,63;34,65;36,74;29,73;24,77;55,70;50,69|11110,2672,3300,3299
113|Sanglier Brocheroc|Stonetusk Boar|5|6|0|12:44,69;31,84;32,84;35,90;41,85;38,89;41,92;42,88|3171,771,769
475|Tunnelier kobold|Kobold Tunneler|5|6|0|12:36,83;39,82;38,79;37,83;39,83;41,82;40,83;41,80|1195,772,773
94|Vide-gousset défias|Defias Cutpurse|5|6|0|12:41,57;42,54;41,54;43,54;43,51;37,55;36,66;31,67|
3106|Clampant de l'écume pygmée|Pygmy Surf Crawler|5|6|0|14:64,55;63,55;61,50;63,52;64,47;52,84;55,84;64,49|4888,4873,4874
3125|Scorpide cliquetant|Clattering Scorpid|5|6|0|14:57,46;58,43;59,45;56,49;58,47;54,69;57,44;53,52|5466,4872,4867
1935|Journalier de Tirisfal|Tirisfal Farmhand|5|6|0|85:38,52;35,52;37,50;35,49;37,49;39,51;38,49;39,49|3335
1525|Mort pourrissant|Rotting Dead|5|6|0|85:56,46;55,54;55,50;52,47;50,56;54,56;53,59|2855
1547|Sombredogue décrépit|Decrepit Darkhound|5|6|0|85:39,40;65,54;38,47;63,41;44,53;64,46;43,50;64,59|2858,2672,3300,3299
2003|Fée des ombres|Shadow Sprite|5|6|0|141:54,51;53,51;53,50;55,51;55,53|
2002|Fée maudite|Rascal Sprite|5|6|0|141:54,51;53,51;53,52;53,49;54,49;54,50|
1995|Hibou Strigid|Strigid Owl|5|6|0|141:52,56;64,54;67,54;54,60;55,64;65,61;62,51;59,56|3411,7096,7097,4757,6889,4775
2007|Jardinier Pin-tordu|Gnarlpine Gardener|5|6|0|141:65,66;66,64;66,60;67,55;65,62;66,59;67,56|
1998|Rôdeuse Tissebois|Webwood Lurker|5|6|0|141:68,64;70,57;61,55;52,59;52,66;61,57;60,60;52,56|3412,1476,5465,1081
2042|Sabre-de-nuit sauvage|Nightsaber|5|6|0|141:67,51;64,56;51,60;54,63;67,54;60,63;51,57;52,62|3409,4814,4813
2022|Sylvain|Timberling|5|6|0|141:60,72;62,69;60,65;58,66;62,66;56,68;55,66|5168
2006|Ursa Pin-tordu|Gnarlpine Ursa|5|6|0|141:67,63;66,64;65,64;68,58;69,58;65,58|
2975|Journalier de la KapitalRisk|Venture Co. Hireling|5|6|0|215:52,69;52,68;51,68|
2958|Loup des prairies|Prairie Wolf|5|6|0|215:36,74;37,56;37,68;42,72;38,69;41,64;54,66;37,74|4758,4804,2672,3300,3299
2949|Tanneur crin-pâle|Palemane Tanner|5|6|0|215:47,73;36,66;37,65;34,65;51,73;52,75|
2969|Rapace nerveux|Wiry Swoop|5|7|0|215:36,78;41,68;38,65;41,66;52,62;38,72;40,61;41,62|4769,4807,7096,7097,4757,6889,4775
1129|Ours noir|Black Bear|6|6|0|1:65,13|3169,3170,7073,7074,4865
14432|Threggil||6|6|4|141:52,51|
1126|Grand sanglier des rochers|Large Crag Boar|6|7|0|1:45,45;48,47;44,30;36,52;40,47;41,47;50,52;59,54|2886,3171,771,769
1138|Loup pisteur des neiges|Snow Tracker Wolf|6|7|0|1:44,45;46,47;43,46;45,47;46,46;50,45;51,45;51,46|2672,3300,3299
1135|Wendigo||6|7|0|1:40,49;40,47;43,47;43,50;42,46;42,55;41,50;42,52|2671
16423|Apparition spectrale|Spectral Apparition|6|7|0|12:35,56;33,56;34,55;33,53;34,51;34,50;34,48#85:60,62;61,62;61,61;60,61;60,60|22892
40|Mineur kobold|Kobold Miner|6|7|0|12:40,80;40,79;42,80;41,78;64,57;63,60;62,52;60,50|1389,772,773
285|Murloc||6|7|0|12:57,66;56,67;50,66;56,68;55,67;54,66;51,67|1256,779,6303,1468
735|Ruisselier murloc|Murloc Streamrunner|6|7|0|12:57,69;51,69;58,65;55,69;56,63;53,64;53,68;52,65|1256,735,779,6303,1468
16422|Soldat squelettique|Skeletal Soldier|6|7|0|12:34,56;35,55;32,54;32,52;34,51;35,50;34,49#85:60,62;61,61;60,61;59,61;60,60|22892
3103|Claqueur makrura|Makrura Clacker|6|7|0|14:65,50;62,80;64,60;59,82;64,51;62,43;62,41;60,87|4887,4873,6303,4874
3104|Coquillard makrura|Makrura Shellhide|6|7|0|14:54,85;61,45;66,74;65,51;63,74;61,40;66,72;60,76|4887,4873,6303,4874
3111|Huran Tranchecrin|Razormane Quilboar|6|7|0|14:50,51;46,49;47,49;50,48;48,49;49,48;50,49;49,49|
3119|Manoeuvre kolkar|Kolkar Drudge|6|7|0|14:51,79;48,80;50,80;50,79;52,76;53,80;48,79|4870
3099|Sanglier tacheté redoutable|Dire Mottled Boar|6|7|0|14:52,50;52,54;47,38;51,56;50,35;53,31;48,40;38,36|3171,771,769
1531|Ame égarée|Lost Soul|6|7|4|85:53,48;53,46;45,41|
1526|Cadavre décomposé|Ravaged Corpse|6|7|0|85:55,59;52,52;56,49;52,45;54,49;49,56;52,60;54,51|2855
1934|Fermier de Tirisfal|Tirisfal Farmer|6|7|0|85:38,51;38,50;38,52;36,51;37,52|
1674|Gnoll Poil-Putride|Rot Hide Gnoll|6|7|0|85:59,34;59,43;59,44;57,38;58,37;60,34;59,42;59,39|2834
1553|Grande chauve-souris du crépuscule|Greater Duskbat|6|7|0|85:42,57;47,51;49,50;61,38;39,48;46,53;46,54;58,57|2876,6293,6296,12223,7073,7074,4865
1535|Guerrier écarlate|Scarlet Warrior|6|7|0|85:32,51;31,48;30,51;33,51;37,48;31,46;34,48;32,46|2875
1941|Profanateur Poil-Putride|Rot Hide Graverobber|6|7|0|85:56,46;58,42;58,43;55,43;56,41;57,40;56,44|2834
1520|Soldat Cliquethorax|Rattlecage Soldier|6|7|0|85:49,44;45,41;46,40;45,38;49,43;47,44|3162,2839
2152|Embusqué Pin-tordu|Gnarlpine Ambusher|6|7|0|141:46,51;46,52;46,55;45,55;47,52;46,54;46,53|
2004|Fée sombre|Dark Sprite|6|7|0|141:52,50;51,51;53,49;53,50;52,49;51,50|
2008|Guerrier Pin-tordu|Gnarlpine Warrior|6|7|0|141:70,52;70,54;67,60;50,66;66,60;68,60;66,57;67,57|
7235|Mystique Pin-tordu|Gnarlpine Mystic|6|7|0|141:69,52;70,53;70,55;69,53;68,52|
2950|Ecorcheur crin-pâle|Palemane Skinner|6|7|0|215:47,74;47,73;48,73;35,65;32,63;32,64;33,64;51,75|
2976|Travailleur de la KapitalRisk|Venture Co. Laborer|6|7|0|215:52,53;44,52;44,51;52,54|
3122|Fouette-queue Griffesang|Bloodtalon Taillasher|6|8|0|14:46,37;42,34;70,71;50,35;69,75;55,37;64,87;68,70|4877,4878
2956|Trotteur des plaines adulte|Adult Plainstrider|6|8|0|215:46,39;45,44;38,64;35,39;39,69;37,79;51,64;48,69|4759,4806,7096,7097,4757,4775
390|Entourage porcin|Porcine Entourage|7|7|0|12:70,79|4656,3171,771,769
2005|Grell vicieux|Vicious Grell|7|7|0|141:52,50;52,52;52,51;51,51;52,49|
14428|Uruson||7|7|4|141:68,59|
5681|Captive humaine|Female Human Captive|7|7|0|1497:51,22|
1127|Ancien sanglier des rochers|Elder Crag Boar|7|8|0|1:45,42;35,35;27,43;32,47;42,39;59,50;63,59;70,50|2886,3171,771,769
1131|Loup blanc|Winter Wolf|7|8|0|1:46,42;46,47;45,42;34,41;34,43;35,41;49,45;52,49|2672,3300,3299
1201|Léopard des neiges|Snow Leopard|7|8|0|1:49,59;37,32;28,43;28,45;48,62;55,59;58,60;63,59|4814,4813
1196|Ours Griffeglace|Ice Claw Bear|7|8|0|1:46,63;34,32;25,56;28,48;32,47;35,36;49,62;61,57|2898,6952,3169,3170,7073,3173,7074,4865
1120|Troll Frostmane|Frostmane Troll|7|8|0|1:26,50;26,51;26,52;26,53;27,51;27,52;67,41;71,39|2258
476|Géomancien kobold|Kobold Geomancer|7|8|0|12:65,57;64,58;64,57;62,56;61,57;61,52;61,49|778,1399,772,773
1922|Loup forestier gris|Gray Forest Wolf|7|8|0|12:74,69;74,64;69,57;68,66;61,66;62,61;61,62;59,64|2672,3300,3299
524|Sanglier Rochecuir|Rockhide Boar|7|8|0|12:62,78;44,79;47,81;49,76;54,85;59,74;63,76;73,80|4656,3171,771,769
3107|Clampant de l'écume|Surf Crawler|7|8|0|14:66,79;63,81;70,79;61,18;60,27;64,72;62,87;65,75|4888,4873,4874
3112|Eclaireur Tranchecrin|Razormane Scout|7|8|0|14:44,50;47,50;43,51;44,51;50,49;49,49;50,48|
3120|Estafette kolkar|Kolkar Outrunner|7|8|0|14:48,78;50,81;47,79;46,79|4870
3115|Harpie Terrevent|Dustwind Harpy|7|8|0|14:46,34;45,29;49,22;48,33;48,32;49,32;48,31;50,33|4775
3116|Pilleuse Terrevent|Dustwind Pillager|7|8|0|14:47,30;49,21;48,21;48,32;47,31;49,20|4775
3126|Scorpide blindé|Armored Scorpid|7|8|0|14:43,32;42,29;47,36;45,46;55,22;57,25;41,39;39,42|5466,4872,4867
3121|Tigre de Durotar|Durotar Tiger|7|8|0|14:64,95;63,97;65,89;64,97;62,95;65,85;61,82;62,90|4892,4814,4813
1543|Bondisseur Aileron noir|Vile Fin Puddlejumper|7|8|0|85:34,44;36,43;30,46;62,27;31,45;59,29;62,29;58,26|779,2859,6303
1675|Bâtard Poil-Putride|Rot Hide Mongrel|7|8|0|85:58,35;56,34;60,33;59,37;61,32;60,38;57,35;58,31|2834
1536|Missionnaire écarlate|Scarlet Missionary|7|8|0|85:43,65;46,65;44,65;47,64;50,69;53,68;53,67;50,67|2875
1527|Mort affamé|Hungering Dead|7|8|0|85:68,44;68,43;68,42;70,42;70,41;67,42|
1522|Ossomancien Sombroeil|Darkeye Bonecaster|7|8|0|85:42,34;48,38;47,30;47,42;48,39;46,32;48,43;49,34|3163,2839
1548|Sombredogue maudit|Cursed Darkhound|7|8|0|85:68,31;74,36;50,50;45,48;43,68;77,65;68,37;58,58|2858,2672,3300,3299
2009|Chaman Pin-tordu|Gnarlpine Shaman|7|8|0|141:37,67;57,76;47,78;48,78;45,57;44,61;44,60|8363
1999|Croc-venin Tissebois|Webwood Venomfang|7|8|0|141:45,77;42,75;46,79;37,47;45,78;39,60;45,70;47,72|3412,1476,5465
2010|Défenseur Pin-tordu|Gnarlpine Defender|7|8|0|141:41,72;39,67;49,67;47,78;44,58;43,60;44,61;44,60|
2025|Ecorceur sylvain|Timberling Bark Ripper|7|8|0|141:54,70;52,74;50,72;53,72;51,74;52,70;53,68;49,73|5168
1996|Hurleur Strigid|Strigid Screecher|7|8|0|141:58,76;40,54;52,77;66,67;39,51;52,78;38,56;43,77|3411,7096,7097,4757,6889,4775
2043|Rôdeur sabre-de-nuit|Nightsaber Stalker|7|8|0|141:39,58;64,71;38,59;61,73;63,73;50,76;50,77;41,57|3409,4814,4813
2951|Braconnier crin-pâle|Palemane Poacher|7|8|0|215:33,64;33,65;32,65;32,64;53,74;52,74|
2962|Harpie Furie-des-vents|Windfury Harpy|7|8|0|215:36,48;63,73;34,47;33,48;33,47;60,72;61,72;62,71|4751,4775
2972|Jeune kodo|Kodo Calf|7|8|0|215:56,30;43,28;37,47;34,36;57,31|4779,4780,5082,5467
3035|Puma des basses plaines|Flatland Cougar|7|8|0|215:44,40;52,43;54,48;59,56;47,40;38,46;40,52;45,53#1638:25,71|4802,4805,4814,4813
2977|Sous-chef de la KapitalRisk|Venture Co. Taskmaster|7|8|0|215:51,53;52,54;52,53;44,51;44,52|
2959|Traqueur des prairies|Prairie Stalker|7|8|0|215:56,73;50,46;55,53;35,37;50,47;43,53;42,56;47,52#1638:26,41;26,40;29,77|4801,4758,4804,2672,3300,3299
2970|Rapace|Swoop|7|9|0|215:53,44;47,44;50,47;43,56;38,48;46,55;55,54;48,53|4769,4807,7096,7097,4757,6889,4775
327|Dent-d'or|Goldtooth|8|8|0|12:42,78|981,1175,772,773
880|Erlan Drudgemoor||8|8|0|12:71,81|1972,1019,4656
60|Ruklar le trappeur|Ruklar the Trapper|8|8|0|12:65,57|4656
3141|Ancien makrura|Makrura Elder|8|8|0|14:59,13;60,16;61,23;61,39|4887,4873,6303,4874
1936|Fermier de Solliden|Farmer Solliden|8|8|4|85:38,50;34,52;37,49;38,52|2091
1660|Garde du corps écarlate|Scarlet Bodyguard|8|8|0|85:79,25|4263,2875
2162|Agal||8|8|0|141:46,51|
7234|Ferocitas le Mangeur de rêves|Ferocitas the Dream Eater|8|8|0|141:69,53|8049
14431|Furie Shelda|Fury Shelda|8|8|4|141:34,35|5204,4775
2038|Seigneur Melenas|Lord Melenas|8|8|0|141:51,51;51,50;53,50|5221
5686|Zombie captif|Captive Zombie|8|8|0|1497:52,22|
1115|Brise-crâne Mâcheroc|Rockjaw Skullthumper|8|9|0|1:67,60;71,54;69,58;68,61;71,55;72,52;71,50|2066,2591
1123|Chasseur de têtes Frostmane|Frostmane Headhunter|8|9|0|1:26,51;23,51;24,51;24,53;22,52;21,52;23,55|2260
1133|Loup blanc affamé|Starving Winter Wolf|8|9|0|1:34,42|2114,2672,3300,3299
1121|Marche-neige Frostmane|Frostmane Snowstrider|8|9|0|1:25,50;26,51;24,51;23,50;41,44;42,36;39,35;66,41|2259
1397|Prophète Frostmane|Frostmane Seer|8|9|0|1:43,36;41,45;41,44;42,45;41,35;42,36;43,37|2676,5767
43|Araignée minière|Mine Spider|8|9|0|12:62,48;60,49;61,47;62,47;60,48;60,47|1476,5465
116|Bandit défias|Defias Bandit|8|9|0|12:31,58;30,65;46,75;48,83;68,80;55,60;90,79;25,58|1972,1019,4656
822|Jeune ours des forêts|Young Forest Bear|8|9|0|12:60,80;43,81;47,80;57,76;76,68;59,67;81,77;87,65|4656,3169,3170,7073,3173,7074,4865
6927|Portefaix défias|Defias Dockworker|8|9|0|12:49,87|1972,1019
97|Rivepatte chétif|Riverpaw Runt|8|9|0|12:26,87;28,86;26,92;24,94;69,46;68,45;66,39;66,41|781,782,1307
3100|Ancien sanglier tacheté|Elder Mottled Boar|8|9|0|14:51,16;36,46;36,39;43,28;43,22;40,17;58,19;50,13|3171,771,769
3113|Lève-poussière Tranchecrin|Razormane Dustrunner|8|9|0|14:39,53;38,53;40,53;44,38;43,39;41,38;44,40|
3105|Makrura claque-pinces|Makrura Snapclaw|8|9|0|14:60,26;60,17;60,29;58,9;58,10;59,15;60,30;60,18|4887,4873,6303,4874
3195|Nervi de la Lame ardente|Burning Blade Thug|8|9|0|14:53,29;53,28;53,27;52,29|4871
3207|Troll maléficié|Hexed Troll|8|9|0|14:68,83;68,84;67,89;68,86;67,85;69,84;67,88|
3206|Troll vaudou|Voodoo Troll|8|9|0|14:69,84;67,88;68,87;67,87;66,83;68,82|
1554|Chauve-souris du crépuscule vampirique|Vampiric Duskbat|8|9|0|85:72,34;70,35;45,63;73,37;79,62;75,47;71,50;52,63|2876,6293,6296,12223,7073,7074,4865
1533|Esprit tourmenté|Tormented Spirit|8|9|4|85:46,32|
1528|Horreur titubante|Shambling Horror|8|9|0|85:67,45;68,44;69,44|
1544|Oracle mineur Aileron noir|Vile Fin Minor Oracle|8|9|0|85:75,27;29,46;36,39;35,41;67,26;26,47;36,41;59,27|3327,779,2859,6303
1523|Soldat Squelette|Cracked Skull Soldier|8|9|0|85:49,32;45,28;47,28;45,29;44,33;45,34;49,34;48,35|3162,2839
1537|Zélote écarlate|Scarlet Zealot|8|9|0|85:88,43;87,42;86,42;81,55;52,70;50,65;77,56;52,69|2875
2033|Ancien sabre-de-nuit|Elder Nightsaber|8|9|0|141:45,43;40,44;45,37;46,38;46,34;36,29;40,35;35,31|3409,4814,4813
2011|Augure Pin-tordu|Gnarlpine Augur|8|9|0|141:42,72;41,73;56,76;46,58;45,61;45,63;46,57|
1997|Chasseur Strigid|Strigid Hunter|8|9|0|141:41,45;46,31;38,29;39,46;38,40;38,38;39,48|3411,7096,7097,4757,6889,4775
2015|Harpie Plumesang|Bloodfeather Harpy|8|9|0|141:38,44;38,41;37,43;39,41;36,39;37,39;37,44;34,35|5204,4775
2027|Piétineur sylvain|Timberling Trampler|8|9|0|141:42,38;42,39;54,75;53,75;44,43;44,41;44,39;53,74|5170,5168
2000|Tisse-soie Tissebois|Webwood Silkspinner|8|9|0|141:44,47;48,32;45,35;33,31;47,34;36,32;42,46;48,44|3412,1476,5465
2017|Voleuse Plumesang|Bloodfeather Rogue|8|9|0|141:37,43;37,40;36,38;35,37;34,36;35,35;37,42|5204,4775
2967|Centaure galak|Galak Centaur|8|9|0|215:63,61;64,65;64,62|
2978|Ouvrier de la KapitalRisk|Venture Co. Worker|8|9|0|215:62,47;58,43;60,48;60,49;41,26;58,54;59,50;58,48|
2963|Sorcière du vent Furie-des-vents|Windfury Wind Witch|8|9|0|215:36,50;36,48;62,70;63,73;62,72;34,48;35,49;35,47|4751,4775
2957|Vieux trotteur des plaines|Elder Plainstrider|8|9|0|215:48,24;47,36;47,34;48,38;44,37;52,32;47,22;43,29#1638:22,6;64,23|4759,4806,7096,7097,4757,4775
1211|Gnome lépreux|Leper Gnome|8|10|0|1:28,36;28,37;26,37;25,39;24,40;26,43;26,44;25,43|3083,3084
3123|Tranche-gueule Griffesang|Bloodtalon Scythemaw|8|10|0|14:38,37;36,53;38,49;54,18;57,15;37,34;56,16;42,21|4877,4878
2971|Rapace acéré|Taloned Swoop|8|10|0|215:48,21;49,37;53,40;52,40;50,27;63,61;61,63;42,21|4769,4807,7096,7097,4757,6889,4775
1137|Edan le Hurleur|Edan the Howler|9|9|4|1:39,47;42,49|2671
330|Princesse|Princess|9|9|0|12:70,79|1006,4656,3171,771,769
881|Surena Caledon||9|9|0|12:71,81|6810,1972,1019,4656
5826|Géomaîtresse Mottle|Geolord Mottle|9|9|4|14:43,39;47,50;44,50|
5808|Seigneur de guerre Kolkanis|Warlord Kolkanis|9|9|4|14:48,77;50,81;46,79|4870
5766|Jeune lion des savanes|Savannah Cub|9|9|0|17:60,32;61,33;62,32;62,33|
1662|Capitaine Perrine|Captain Perrine|9|9|0|85:51,68|3332,2875
1657|Devlin Agamand||9|9|0|85:47,41|2831
2018|Ensorceleuse Plumesang|Bloodfeather Sorceress|9|9|0|141:38,43;36,37;34,34;39,43;35,39|5204,4775
2166|Froncechêne|Oakenscowl|9|9|1|141:54,75|8136,5168
14430|Traqueur du crépuscule|Duskstalker|9|9|4|141:58,77|3409,4814,4813
3068|Mazzranache||9|9|4|215:49,49|4759,4806,7096,7097,4757,4775
3566|Rôdeur des basses plaines|Flatland Prowler|9|9|0|215:52,23;45,36;54,42;43,29;44,23;42,28;58,34;50,28#1638:64,37;71,46;83,15|5203,4814,4813
5786|Travépieu|Snagglespear|9|9|4|215:47,73;52,74|
1117|Briseur d’os Mâcheroc|Rockjaw Bonesnapper|9|10|0|1:71,55;71,53;72,52;73,52;78,60;80,55|2067,2591
1122|Ecorcheur Frostmane|Frostmane Hideskinner|9|10|0|1:24,52;24,54;22,51;22,53;22,55;23,55;23,54|2260
1116|Embusqué Mâcheroc|Rockjaw Ambusher|9|10|0|1:71,53;72,55;74,53;73,56;76,59;77,58;75,57|2065,2591
6123|Espion Sombrefer|Dark Iron Spy|9|10|0|1:77,61;77,62;78,62;78,61;77,60;78,60|6847
1124|Exhalombre Frostmane|Frostmane Shadowcaster|9|10|0|1:26,51;23,53;22,50;22,52;21,54;23,54;66,41;71,39|2257
1689|Sanglier des rochers balafré|Scarred Crag Boar|9|10|0|1:71,54;73,60;76,50;79,56;81,53;86,48;81,44;83,36|2112,2886,3171,771,769
478|Estafette Rivepatte|Riverpaw Outrunner|9|10|0|12:27,80;27,86;27,89;25,94;29,93;68,45;68,39;67,41|781,782,1307
46|Fourrageur murloc|Murloc Forager|9|10|0|12:69,85;57,84;77,86;79,57;79,54;79,45;78,44|780,735,779,6303,1468
118|Rôdeur|Prowler|9|10|0|12:75,77;71,42;80,81;80,78;79,42;83,60;87,68;86,61|777,2672,3300,3299
732|Rôdeur murloc|Murloc Lurker|9|10|0|12:77,80;78,84;76,84;81,87;80,57;80,53;79,46;78,44|780,779,6303,1468
474|Sorcier-voleur défias|Defias Rogue Wizard|9|10|0|12:29,61;28,60;73,46;73,50;73,52;72,56;75,52;77,52|6846,1972,1019
3108|Clampant de l'écume incrusté|Encrusted Surf Crawler|9|10|0|14:58,15;57,10;56,11;58,14;58,8;57,9;58,13;58,11|4888,4873,4874
16437|Esprit spectral|Spectral Spirit|9|10|0|14:45,19;44,18;45,18;44,17;45,17;44,16;45,16#1:48,41;49,40;48,40;50,39;49,39;50,38;48,38|22892
3197|Fanatique de la Lame ardente|Burning Blade Fanatic|9|10|0|14:52,10;52,9;42,26;52,8;51,9;55,9|14544,4871
3114|Garde de guerre Tranchecrin|Razormane Battleguard|9|10|0|14:39,54;38,54;44,38;39,53;44,40;43,39;45,38;43,40|
3130|Lézard-tonnerre|Thunder Lizard|9|10|0|14:40,30;41,30;40,29;39,27;39,29;40,28;39,31|4879,4880,6486
3196|Néophyte de la Lame ardente|Burning Blade Neophyte|9|10|0|14:52,25;53,28;53,27;52,26;52,27|4871
3127|Scorpide queue-venin|Venomtail Scorpid|9|10|0|14:57,15;37,27;38,51;37,56;54,12;54,13;38,20;39,18|4886,5466,4872,4867
3117|Terrevent sauvage|Dustwind Savage|9|10|0|14:52,24;54,24;54,25;54,23;54,22;53,25|4775
480|Golem des moissons rouillé|Rusty Harvest Golem|9|10|0|40:54,25;55,25;57,20;54,24;53,25;59,18;58,19|2327,732,1274,814,4361,4359
1534|Ancêtre gémissante|Wailing Ancestor|9|10|0|85:53,29;53,27;54,30;54,28;52,26;51,29;52,29|
1538|Frère écarlate|Scarlet Friar|9|10|0|85:87,42;87,44;87,45;79,26;81,57;78,56;79,55;79,56|2875
1529|Horreur sanguinolente|Bleeding Horror|9|10|0|85:78,59;77,60;77,63;75,60;74,63;75,62;79,60|3319
1545|Marche-boue Aileron noir|Vile Fin Muckdweller|9|10|0|85:70,25;75,26;66,30;30,42;73,27;65,30;75,27;68,26|3325,779,2859,6303
1549|Sombredogue vorace|Ravenous Darkhound|9|10|0|85:88,42;83,47;83,42;90,44;88,44;87,45;84,44;85,46|3321,2858,2672,3300,3299
1555|Tisse-nuit vicieuse|Vicious Night Web Spider|9|10|0|85:86,53;90,53;84,50;86,57;91,51;89,50;84,51;86,49|2872,3328,1476,5465,1475
2029|Boueux sylvain|Timberling Mire Beast|9|10|0|141:42,34;44,35;42,37;43,34;43,30;42,33;43,36;43,32|7095,5170,5168
2019|Furie Plumesang|Bloodfeather Fury|9|10|0|141:33,30;36,26;33,29;35,27;34,28|5204,4775
2012|Guide Pin-tordu|Gnarlpine Pathfinder|9|10|0|141:42,80;39,78;38,80;40,80;39,80|
2020|Sorcière du vent Plumesang|Bloodfeather Wind Witch|9|10|0|141:34,30;33,30;34,28;37,28;32,32;33,29|5204,4775
16438|Troupier squelettique|Skeletal Trooper|9|10|0|141:38,58;39,57;38,57;36,56;39,56;38,56;38,55;37,55#1:49,41;49,40;50,40;48,40;48,39;50,39;49,39|22892
2013|Vengeur Pin-tordu|Gnarlpine Avenger|9|10|0|141:43,79;39,80;39,79;41,77;42,79;41,80;40,79;40,80|
2231|Clampant des marées pygmée|Pygmy Tide Crawler|9|10|0|148:37,40;37,36;35,43;35,44;36,47;36,49;37,37|5506,5385,2674,2675,4874
6789|Jeune chardon|Thistle Cub|9|10|0|148:51,38;52,38|3169,3170,7073,7074,4865
2964|Ensorceleuse Furie-des-vents|Windfury Sorceress|9|10|0|215:38,22;40,20;39,20;52,22;31,31;32,30;32,33;34,31|4752,4775
2968|Estafette galak|Galak Outrunner|9|10|0|215:63,61;64,65;64,62|
3232|Intrus Dos-hirsute|Bristleback Interloper|9|10|0|215:57,31;58,31;59,30;57,30|
2960|Loup Alpha des prairies|Prairie Wolf Alpha|9|10|0|215:58,36;44,38;55,39;51,28;59,60;55,34;61,64#1638:68,39|4803,4758,4804,2672,3300,3299
2979|Superviseur de la KapitalRisk|Venture Co. Supervisor|9|10|0|215:62,46;61,46;58,45;43,25;57,42;59,52;59,46;59,48|
3110|Crocilisque Gueule-d'effroi|Dreadmaw Crocolisk|9|11|0|14:35,26;35,54;36,57;36,22;37,22;34,46;36,61;38,68#17:63,15;63,11;63,24;63,16;64,8;65,34|4875,4876,4891,2924,2925
1132|Grumeux|Timber|10|10|4|1:34,42;34,44;34,43|2672,3300,3299
6846|Maître des docks défias|Defias Dockmaster|10|10|0|12:48,87|7675,1972,1019
99|Morgaine la rusée|Morgaine the Sly|10|10|4|12:31,65|2091
473|Morgan le collecteur|Morgan the Collector|10|10|0|12:71,81|2239,1019,4656
471|Mère Croc|Mother Fang|10|10|4|12:62,48|1476,5465,3174
79|Narg le Sous-chef|Narg the Taskmaster|10|10|4|12:41,78|
3205|Zalazane||10|10|0|14:68,88|4866
10356|Bayne||10|10|4|85:40,42|2672,3300,3299
1654|Gregor Agamand||10|10|0|85:47,29|2829
1910|Muad||10|10|4|85:36,42|4302,779,6303
1655|Nissa Agamand||10|10|0|85:50,36|2828
1656|Thurman Agamand||10|10|0|85:44,34|2830
2852|Druide de la Serre asservi|Enslaved Druid of the Talon|10|10|0|141:39,81|4301,9719
7318|Grifferage|Rageclaw|10|10|0|141:46,59|
1993|Patte-verte|Greenpaw|10|10|0|141:45,63|
6128|Vorlus Vilehoof||10|10|0|141:47,64|6805
5807|Le Rake|The Rake|10|10|4|215:52,27|4814,4813
5685|Goule captive|Captive Ghoul|10|10|0|1497:51,22|
119|Longroin|Longsnout|10|11|0|12:25,82;26,80;25,85;25,87;24,84;26,82;24,83;25,88|3171,771,769
3198|Apprenti de la Lame ardente|Burning Blade Apprentice|10|11|0|14:55,9;53,9;52,11;43,26;54,9;52,10;53,8|14544,4871
3228|Clampant de l'écume corrompu|Corrupted Surf Crawler|10|11|0|14:57,11;60,22|4888,4873,4874
3131|Foudroyant|Lightning Hide|10|11|0|14:42,24;41,24;43,24;44,24;39,25;40,24|4879,4880,6486
3225|Sanglier tacheté corrompu|Corrupted Mottled Boar|10|11|0|14:37,40;44,15|3171,771,769
3226|Scorpide corrompu|Corrupted Scorpid|10|11|0|14:37,29;36,48;51,14|4886,5466,1475,4872,4867
3199|Sectateur de la Lame ardente|Burning Blade Cultist|10|11|0|14:53,25;52,25;52,27;53,26;52,26|6652,4871
3118|Sorcière des tempêtes Terrevent|Dustwind Storm Witch|10|11|0|14:52,22;52,20;52,23;51,24;51,23;53,22;52,19|4775
3227|Tranche-gueule Griffesang corrompu|Corrupted Bloodtalon Scythemaw|10|11|0|14:38,56;44,32;40,20;39,19;44,18|4877,4878
3379|Cogneur de la Lame ardente|Burning Blade Bruiser|10|11|0|17:48,19;48,16;47,19;48,15;47,18;48,18|
3267|Sourcier Tranchecrin|Razormane Water Seeker|10|11|0|17:54,25;56,26;54,26;56,27;55,27|5026
3268|Tisseuse d’épines Tranchecrin|Razormane Thornweaver|10|11|0|17:54,25;56,26;55,26;55,27;56,27|5026
1173|Eclaireur Rat des tunnels|Tunnel Rat Scout|10|11|0|38:37,26;37,18;36,25;23,29;24,29;28,32;25,30|2282,3110
1195|Rôdeuse des forêts|Forest Lurker|10|11|0|38:29,17;39,32;29,49;39,75;34,54;30,23;34,41;32,33|2606,3167,5465,1475,3174,1081
1190|Sanglier des montagnes|Mountain Boar|10|11|0|38:31,17;32,24;38,36;34,32;27,39;40,29;37,36;29,23|2677,3172,3171,771,769
1172|Vermine Rat des tunnels|Tunnel Rat Vermin|10|11|0|38:36,15;38,20;27,42;38,26;33,13;38,16;22,29;24,30|2282,3110
834|Coyote||10|11|0|40:48,26;58,15;63,42;53,38;36,26;42,19;42,32;35,42|2673,3300,3299
481|Détrousseur défias|Defias Footpad|10|11|0|40:56,19;57,19;57,20|829,7997
199|Jeune déchireur|Young Fleshripper|10|11|0|40:52,19;59,14;60,32;62,35;52,28;51,42;54,40;36,26|555,3399,729,7096,7097,4757,6889,4775
1530|Ancêtre pourrissant|Rotting Ancestor|10|11|0|85:51,28;53,30;53,31;53,26;49,32;51,31;52,31|
1540|Avant-garde écarlate|Scarlet Vanguard|10|11|0|85:78,33;79,24;78,32;79,30;80,26;78,35;79,36|2875
1532|Esprit vagabond|Wandering Spirit|10|11|0|85:76,60;76,61;77,59;76,59;75,59;75,60;78,61|
1539|Néophyte écarlate|Scarlet Neophyte|10|11|0|85:79,27;80,25;79,29;79,26;78,32|2875
1769|Poil-blanc Ragelune|Moonrage Whitescalp|10|11|0|130:55,24;55,20;54,23;52,25;49,32;51,26;52,42;49,40|
1765|Worg||10|11|0|130:65,6;65,11;68,6;64,11;64,8;48,48;46,46;69,5#85:56,76;53,75|3164,2672,3300,3299
2030|Ancien sylvain|Elder Timberling|10|11|0|141:45,27;44,27;44,26;44,28;43,29;43,26;43,28|7094,5170,5168
2001|Araignée Tissebois géante|Giant Webwood Spider|10|11|0|141:46,27;41,29;40,25;38,28|3412,1476,5465
2034|Sabre-de-nuit farouche|Feral Nightsaber|10|11|0|141:41,27;38,29;41,25;40,29;38,27;37,25|3409,4814,4813
2014|Totémique Pin-tordu|Gnarlpine Totemic|10|11|0|141:38,81;39,79;39,80|
2176|Bien-née maudite|Cursed Highborne|10|11|0|148:42,59;42,60;41,59;42,58;42,57;43,58;44,58|5360
2189|Fée vile|Vile Sprite|10|11|0|148:44,38;45,39;45,40;45,38;45,37;48,36|5336
2234|Jeune clampant des récifs|Young Reef Crawler|10|11|0|148:39,31;40,31;35,53;41,32;39,32;37,60;36,55;37,61|5506,5385,2674,2675,4874
2973|Kodo adulte|Kodo Bull|10|11|0|215:56,30;43,28;37,47;34,36;57,31|4779,4780,5082,5467
2965|Matriarche Furie-des-vents|Windfury Matriarch|10|11|0|215:37,22;40,19;38,22;53,22;49,18;32,30;33,36;33,34#1638:13,23|4753,4775
6124|Capitaine Beld|Captain Beld|11|11|0|1:78,62|
8503|Gibblewilt||11|11|4|1:27,36;25,43|3083,3084
1260|Grand-père Arctikus|Great Father Arctikus|11|11|4|1:23,52;22,52;22,54;24,51;24,53;23,55|
1961|Griffe galeuse|Mangeclaw|11|11|0|1:78,38|3183,3169,3170,3173,11406,2940
1388|Vagash||11|11|1|1:63,46|3627,2671
6113|Vejrek||11|11|0|1:28,58|6799
1271|Vieux Barbeglace|Old Icebeard|11|11|1|1:39,54|2671
6093|Jack Dent-Morte|Dead-Tooth Jack|11|11|0|12:89,79|6783
448|Lardeur|Hogger|11|11|1|12:25,93;27,87;26,94;27,93;26,90|1931,1307
61|Thuros Doigts-agiles|Thuros Lightfingers|11|11|4|12:53,59;29,60;29,58;31,57;51,83;90,79;89,79|
5824|Capitaine Plate-défense|Captain Flat Tusk|11|11|2|14:43,39;45,51;39,54|
5823|Ecorcheur mortel|Death Flayer|11|11|4|14:37,50|4886,5466,1475,4872,4867
5822|Gangretisseur Scornn|Felweaver Scornn|11|11|2|14:53,9;53,7;52,10|
1202|Kobold Rat des tunnels|Tunnel Rat Kobold|11|11|0|38:37,25;25,44;26,44;36,17;35,17;39,13;40,12|2281,3110
1664|Capitaine Vachon|Captain Vachon|11|11|0|85:79,56|2875
10357|Ressan le Harceleur|Ressan the Needler|11|11|4|85:43,68|6293,6296,12223,7073,7074,4865
1753|Œil-de-ver|Maggot Eye|11|11|0|85:59,31|3329,3635
14429|Grimmaw||11|11|4|141:40,80|
2021|Matriarche Plumesang|Bloodfeather Matriarch|11|11|0|141:33,30;32,33;33,32;31,32;36,28;34,27;35,28;34,29|5204,5114
6133|Ombre d'Elura|Shade of Elura|11|11|0|148:32,45|6809
3058|Arra'chea||11|11|0|215:51,25|4841,4779,4780,5082,5467
5787|Massacreur Emilgund|Enforcer Emilgund|11|11|4|215:41,26|
5785|Sœur Cinglehaine|Sister Hatelash|11|11|2|215:37,23|4772,4775
1118|Brise-dos Mâcheroc|Rockjaw Backbreaker|11|12|0|1:79,54;80,56;79,55;80,54;81,57;79,58|2064,2591
3231|Crocilisque Gueule-d'effroi corrompu|Corrupted Dreadmaw Crocolisk|11|12|0|14:34,53#17:63,11|4875,4876,4891,2924,2925
3380|Acolyte de la Lame ardente|Burning Blade Acolyte|11|12|0|17:48,19;48,15;47,18;47,19|
3415|Chasseresse des savanes|Savannah Huntress|11|12|0|17:50,23;50,24;55,29;52,21;51,24;56,17;55,30;50,28|4893,5134,4813
3265|Chasseur Tranchecrin|Razormane Hunter|11|12|0|17:58,24;59,24;55,25;56,26;55,26;54,25|
3244|Grand trotteur des plaines|Greater Plainstrider|11|12|0|17:49,24;49,25;51,16;52,19;49,23;54,31;51,28;51,33|4894,5087,4759,4806,5469,5114,5115,4775
1186|Ancien ours noir|Elder Black Bear|11|12|0|38:31,10;27,14;40,33;30,25;31,54;21,77;38,56;32,30|3169,3170,3173,11406,2940
1162|Eclaireur Brisepierre|Stonesplinter Scout|11|12|0|38:26,49;26,57;27,56;35,77;33,80;34,71;31,72;35,71|2268,2536,5109
1176|Fourrageur Rat des tunnels|Tunnel Rat Forager|11|12|0|38:37,25;37,24;26,43;26,44;35,16;36,23;38,16|2281,3110
1161|Trogg Brisepierre|Stonesplinter Trogg|11|12|0|38:27,57;27,49;28,49;32,81;30,72;31,74;31,75;35,74|2268,2536,5109
833|Chef de meute coyote|Coyote Packleader|11|12|0|40:46,20;62,23;40,27;36,30;37,36;35,39;30,36;60,36|2673,3300,3299
95|Contrebandier défias|Defias Smuggler|11|12|0|40:47,20;48,20;41,42;46,19;41,41;46,21;46,27;52,47|829,7997
515|Ecumeur murloc|Murloc Raider|11|12|0|40:52,10;53,11;56,8;56,9;53,10;55,10;54,10|735,1357,1468
117|Gnoll Rivepatte|Riverpaw Gnoll|11|12|0|40:58,13;57,13;52,14;45,16;41,21;46,17;45,13|725
36|Golem des moissons|Harvest Golem|11|12|0|40:47,68;33,36;36,47;50,34;49,32;47,67;57,35;56,36|816,732,1274,814,4361,4359
1772|Coureur des champs Poil-Putride|Rot Hide Gladerunner|11|12|0|130:44,24;44,20;45,23;45,24;46,23;46,22;45,20|
1770|Coureur sombre Ragelune|Moonrage Darkrunner|11|12|0|130:53,26;53,24;54,27;49,24;48,25;49,23;53,28|
1866|Esclave Ravenclaw|Ravenclaw Slave|11|12|0|130:46,55;47,54;53,15;54,15;52,14;48,51|
1778|Vieil ours féroce|Ferocious Grizzled Bear|11|12|0|130:46,50;45,52;49,17;52,22;48,20;51,38;51,42;54,38|3253,3169,3170,3173,11406,2940
1766|Worg chamarré|Mottled Worg|11|12|0|130:59,14;45,25;50,14;58,14;45,27;60,9;58,9;60,16|3164,2672,3300,3299
2177|Bien-né frémissant|Writhing Highborne|11|12|0|148:43,59;42,60;43,62;44,63;42,62;42,61;43,60|5360
2201|Ecumeur Grisebrume|Greymist Raider|11|12|0|148:36,51|7499
2190|Grell sauvage|Wild Grell|11|12|0|148:45,40;46,40;45,39;47,38;46,39;46,38;47,37;48,37|5336
10159|Jeune sélénien|Young Moonkin|11|12|0|148:44,45;44,47;44,53;43,48;42,49;43,45;42,46|6889,5114,5115
2163|Ours des chardons|Thistle Bear|11|12|0|148:44,32;43,56;40,39;42,35;41,42;43,25;45,24;40,38|3169,3170,3173,11406,2940
2974|Matriarche kodo|Kodo Matriarch|11|12|0|215:56,30;43,28;37,47;34,36;57,31|4779,4780,5082,5467
3254|Flagellant solécaille|Sunscale Lashtail|11|13|0|17:49,24;52,19;48,14;51,23;55,23;48,25;48,26;53,33|5123,5165,4878,5062
2321|Jeune trotteur des forêts|Foreststrider Fledgling|11|13|0|148:45,27;45,44;44,67;40,63;45,41;43,55;44,55;44,33|5469,5114,5115,4775
1130|Bjarn||12|12|4|1:56,59;63,58;59,58;53,59|3169,3170,3173,2940
1119|Martelléchine|Hammerspine|12|12|4|1:71,51|
472|Fenouillard|Fedfennel|12|12|4|12:68,45;66,41;68,40;69,39|
100|Gruff Mord-vite|Gruff Swiftbite|12|12|4|12:25,90;26,92;28,88;26,87;28,86|1307
13159|James Clark||12|12|0|12:79,67|
3203|Fizzle Darkstorm||12|12|0|14:42,27|4869
13157|Makasgar||12|12|0|14:62,66|
5893|Manifestation de feu mineure|Minor Manifestation of Fire|12|12|0|14:39,58|6655
1665|Capitaine Melrache|Captain Melrache|12|12|0|85:80,25|3331,2875
1911|Deeb||12|12|4|85:63,27|779,6303
13158|Lieutenant Sanders||12|12|0|85:87,44|
10358|Ombre de Fellicent|Fellicent's Shade|12|12|4|85:77,60|
7319|Dame Sathrah|Lady Sathrah|12|12|0|141:47,26;41,25|8344,1476,5465
6909|Sethir l’Ancien|Sethir the Ancient|12|12|0|141:37,23|
2039|Ursal le Mutileur|Ursal the Mauler|12|12|0|141:39,80|
3056|Hurleur fantomatique|Ghost Howl|12|12|4|215:35,34;47,48;47,25|2672,3300,3299
3051|Superviseur Fizsprocket|Supervisor Fizsprocket|12|12|0|215:61,49|4819
6466|Gamon||12|12|0|1637:54,68|
3381|Brigand des Mers du sud|Southsea Brigand|12|13|0|17:64,47;64,46;64,49;64,44;63,50|5107
3266|Défenseur Tranchecrin|Razormane Defender|12|13|0|17:59,28;59,25;59,24;59,27;57,25;57,26;58,27|5075
3243|Grande crinière des savanes|Savannah Highmane|12|13|0|17:50,16;55,30;51,21;52,26|4893,5134,4813
3269|Géomancienne Tranchecrin|Razormane Geomancer|12|13|0|17:59,25;59,24;57,24;57,25|5026
3272|Querelleur kolkar|Kolkar Wrangler|12|13|0|17:47,42;45,20;42,27;46,25;46,41;46,38;47,41|5020,5030
3246|Trotteur des plaines fugitif|Fleeting Plainstrider|12|13|0|17:47,24;46,27;48,33;57,31;50,21;45,36;47,22;57,21|4894,5087,4759,4806,5469,5114,5115,4775
1193|Furie du loch|Loch Frenzy|12|13|0|38:49,17;54,14;52,14;50,17;44,22;47,18;43,20;46,23|6317,6987,537,6361,4874
1174|Géomancien Rat des tunnels|Tunnel Rat Geomancer|12|13|0|38:37,25;36,28;37,26;36,21;36,22;36,24;35,22;35,23|3110
1175|Terrassier Rat des tunnels|Tunnel Rat Digger|12|13|0|38:36,27;36,26;36,21;35,23;36,23;36,22;36,25|3110
126|Cours-la-côte murloc|Murloc Coastrunner|12|13|0|40:44,8;53,9;56,8;47,9;42,12;42,10;53,11;56,9|1357,1468
500|Eclaireur Rivepatte|Riverpaw Scout|12|13|0|40:56,13;52,15;45,14;46,15;42,21;37,32;38,28;34,28|725
454|Jeune Broche-tripes|Young Goretusk|12|13|0|40:50,24;49,19;63,38;60,32;56,42;38,26;52,21;50,42|731,723,2677,3172,3171,771,769
1236|Terrassier kobold|Kobold Digger|12|13|0|40:45,23;45,18;45,21;45,20;46,19;46,18|
504|Trappeur défias|Defias Trapper|12|13|0|40:44,25;49,21;31,34;46,37;48,47;47,53;41,40;51,39|835,5368,829,7997
1767|Déchiqueteur Aileron noir|Vile Fin Shredder|12|13|0|130:59,18;64,13;65,13;58,22;67,12;57,26;59,17;56,28|3258,2859
1865|Ecumeur Ravenclaw|Ravenclaw Raider|12|13|0|130:47,54;46,54;46,56;46,55;47,53;48,55|
1779|Glouton Ragelune|Moonrage Glutton|12|13|0|130:43,33;38,23;44,29;41,29;44,32;45,27;56,46;49,25|3156
1773|Mystique Poil-Putride|Rot Hide Mystic|12|13|0|130:44,20;44,22;46,23;45,24;45,23;46,19|
1780|Rôdeuse des sous-bois|Moss Stalker|12|13|0|130:35,13;34,15;36,15;36,14;35,12;36,16|3254,3167,5465,1475,3174
1797|Vieil ours géant|Giant Grizzled Bear|12|13|0|130:37,22;37,18;38,17;46,18;51,68;52,61;52,59;52,62|3253,3169,3170,3173,11406,2940
2178|Bien-née gémissante|Wailing Highborne|12|13|0|148:43,60;44,61;42,61;43,61;44,60;42,62;43,62|5360
2202|Cours-la-côte Grisebrume|Greymist Coastrunner|12|13|0|148:39,22;40,27;42,32;39,29;38,29;42,31;37,51;37,62|7499
2167|Guide Noirbois|Blackwood Pathfinder|12|13|0|148:40,56;39,52;40,53;39,53;39,54;40,54|
2212|Satyre Deth'ryll|Deth'ryll Satyr|12|13|0|148:45,40;47,39;47,37;48,37;47,38;45,36|5338
10158|Sélénien|Moonkin|12|13|0|148:43,52;43,44;47,46;43,51;44,49;42,51;44,48|6889,5114,5115
456|Oracle mineur murloc|Murloc Minor Oracle|12|14|0|40:34,17;34,16;42,11;33,15;34,18;43,8|1357,1468
2185|Batteur de Sombrivage|Darkshore Thresher|12|14|0|148:31,59;33,60;32,57;35,31;34,56;33,40;35,34;32,43|5412,2608,6361
10160|Sélénien enragé|Raging Moonkin|12|14|0|148:45,53;45,46;45,55;45,45;46,52;44,48;46,47;47,49|6889,5114,5115
3384|Corsaire des Mers du sud|Southsea Privateer|12|15|0|17:61,44;62,48;61,49;62,44;62,46;62,49|5107
3383|Coupe-gorge des Mers du sud|Southsea Cutthroat|12|15|0|17:62,44;62,46;62,48|5107
4316|Chien de meute kolkar|Kolkar Packhound|13|13|0|17:53,45;54,42;49,42;48,37;56,46;52,45;57,41;53,41|3300,3299
5865|Dishu||13|13|4|17:50,16|4893,5134,4813
6494|Tazan||13|13|0|17:63,44|7209
1065|Chaman Rivepatte|Riverpaw Shaman|13|13|0|40:42,21|725
1658|Capitaine Dargol|Captain Dargol|13|13|0|85:53,26|3082
10359|Sri'skulk||13|13|4|85:88,51|1476,5465,1475
12431|Gorefang||13|13|4|130:60,8|3164,2672,3300,3299
1971|Ivar l'Infect|Ivar the Foul|13|13|0|130:52,14|3621
3535|Noiremousse le Fétide|Blackmoss the Fetid|13|13|4|141:44,30|5179
2175|Ombregriffe|Shadowclaw|13|13|4|148:40,41|15945,5134,7074
3382|Canonnier des Mers du sud|Southsea Cannoneer|13|14|0|17:63,44;64,47;64,46;64,49;63,50|5107
3273|Légion-tempête kolkar|Kolkar Stormer|13|14|0|17:43,23;47,42;45,21;45,20;42,27;45,40;46,38|5020,5030
3242|Messager zhévra|Zhevra Runner|13|14|0|17:45,31;49,38;49,13;51,15;47,29;53,17;49,36;55,34|5118,10338,5086,5119
3271|Mystique Tranchecrin|Razormane Mystic|13|14|0|17:59,27;58,26;58,27|5026
3285|Péon de la KapitalRisk|Venture Co. Peon|13|14|0|17:53,12;52,11;52,12;53,11;53,10|
1163|Brise-crâne Brisepierre|Stonesplinter Skullthumper|13|14|0|38:28,81;51,24;48,29;31,85;36,84;29,81;36,81;33,90|2536,5109
1166|Prophète Brisepierre|Stonesplinter Seer|13|14|0|38:28,81;27,86;48,21;50,24;36,86;37,84;49,29;35,85|2536,5109
1188|Vieil ours noir|Grizzled Black Bear|13|14|0|38:68,49;75,51;76,52;66,74;64,73;63,43;66,43;65,45|3169,3170,3173,11406,2940
123|Bâtard Rivepatte|Riverpaw Mongrel|13|14|0|40:34,26;34,28;39,32;30,50;30,52;30,58;29,65;36,62|725
830|Clampant des sables|Sand Crawler|13|14|0|40:48,11;50,11;51,10;50,10;50,12;40,13;41,12;40,12|2674,2675
1109|Déchireur|Fleshripper|13|14|0|40:51,25;39,25;35,41;39,38;50,62;40,59;43,49;40,68|555,3399,729,6889,5114,5115,4775
590|Pillard défias|Defias Looter|13|14|0|40:30,47;46,71;45,67;44,68;32,43;39,58;36,55;30,46|5771,829,4405,4361,4359,7997
1867|Apprenti de Dalaran|Dalaran Apprentice|13|14|0|130:52,66;56,63;55,63;53,69;53,66;51,60;50,60;56,68|7293
1768|Chasse-marée Aileron noir|Vile Fin Tidehunter|13|14|0|130:61,18;59,18;62,14;67,13;58,18;66,13;61,17;56,27|3258,2859
1781|Rampant des brumes|Mist Creeper|13|14|0|130:36,9;35,8;36,8;34,9;35,10;36,11|3254,3167,5465,1475,3174
1868|Serviteur Ravenclaw|Ravenclaw Servant|13|14|0|130:55,36;53,36;52,36;53,34;52,35;52,34;54,33;53,31|
1782|Ténébreux Ragelune|Moonrage Darksoul|13|14|0|130:59,42;43,32;44,31;39,25;38,25;57,46;58,45|3157
2232|Clampant des marées|Tide Crawler|13|14|0|148:36,65;42,21;41,29;43,23;43,21;36,63;37,70;37,66|5506,5385,2674,2675,4874
2324|Messager du Vent Noirbois|Blackwood Windtalker|13|14|0|148:39,57;40,56;40,54;40,53;39,53|
10157|Oracle sélénien|Moonkin Oracle|13|14|0|148:46,53;47,46;46,50|6889,5114,5115
2164|Ours des chardons enragé|Rabid Thistle Bear|13|14|0|148:45,33;47,34;53,28;51,30;39,61;39,79;38,72;43,71|3169,3170,3173,11406,2940
2203|Prophète Grisebrume|Greymist Seer|13|14|0|148:40,27;40,28;39,29;39,28;39,30;36,71|7499
11320|Fouisseur|Earthborer|13|14|1|2437:|
3255|Hurleur solécaille|Sunscale Screecher|13|15|0|17:43,26;40,24;60,12;58,14;44,35;40,29;60,43;53,13|5123,5165,4878,5062
11319|Chaman Ragefeu|Ragefire Shaman|13|15|1|2437:|
11324|Démoniste de la Lame brûlante|Searing Blade Warlock|13|15|1|2437:|14395,14396
11321|Elémentaire de lave|Molten Elemental|13|15|1|2437:|5741,4784
11323|Massacreur de la Lame brûlante|Searing Blade Enforcer|13|15|1|2437:|
11322|Sectateur de la Lame brûlante|Searing Blade Cultist|13|15|1|2437:|14395,14396
11318|Trogg Ragefeu|Ragefire Trogg|13|15|1|2437:|
3204|Gazz'uz||14|14|0|14:52,10;53,9;51,10|4903
5435|Requin du sable|Sand Shark|14|14|1|14:65,7;65,15;65,25;64,37;68,61;73,68;72,91#85:29,20;44,20;55,20|537,6361,4874
1177|Géomètre Rat des tunnels|Tunnel Rat Surveyor|14|14|0|38:35,27;35,26;34,27|3110
12432|Vieux Vile mâchoire|Old Vicejaw|14|14|4|130:54,52|3253,3169,3170,3173,11406,2940
2191|Licillin||14|14|4|148:46,36|
3274|Coursier kolkar|Kolkar Pack Runner|14|15|0|17:53,45;54,42;49,42;48,37;54,43;52,45;53,41;57,41|5030
8236|Furie des marais|Muck Frenzy|14|15|0|17:68,49;69,49|5468,6987,537,6361,4874
3276|Harpie Ensorçaile|Witchwing Harpy|14|15|0|17:41,17;41,14;40,18;40,17;41,15;42,15;41,18|5064,5114
3234|Kodo égaré des Tarides|Lost Barrens Kodo|14|15|0|17:40,24;57,16;41,26;44,20;57,18;55,46;53,43;45,41|15852,4779,4780,4896,5082,5467
3284|Manouvrier de la KapitalRisk|Venture Co. Drudger|14|15|0|17:53,11;56,7;52,12;57,9;56,8;56,9|
3425|Rôdeur des savanes|Savannah Prowler|14|15|0|17:43,33;54,15;41,21;44,35;55,16;55,15;64,6|5096,4893,5134,4813
3397|Sanguinaire kolkar|Kolkar Bloodcharger|14|15|0|17:46,41;53,42;53,41;53,45;55,43;57,41;57,43;54,41|5066,5030
1693|Crocilisque du loch|Loch Crocolisk|14|15|0|38:51,35;59,37;54,39;53,39;56,36;60,42;55,53;54,55|2939,3181,3401,2924,2925
1191|Sanglier des montagnes galeux|Mangy Mountain Boar|14|15|0|38:52,73;63,58;64,66;58,61;63,60;51,72;60,64;46,66|2677,3172,2295,771,769
157|Broche-tripes|Goretusk|14|15|0|40:34,31;61,45;38,43;43,49;54,65;37,64;45,49;41,40|731,723,2677,3172,3171,771,769
114|Gardien des moissons|Harvest Watcher|14|15|0|40:38,48;50,23;38,51;40,51;37,52;45,33;54,35;54,32|11110,732,1274,814,4361,4359
846|Goule|Ghoul|14|15|0|40:40,68;40,67|2085
501|Herboriste Rivepatte|Riverpaw Herbalist|14|15|0|40:30,50;30,51;31,52;30,58;31,71;33,68;32,72;31,70|1401,725
513|Lanceur de filet murloc|Murloc Netter|14|15|0|40:34,17;35,16;39,15;37,16;33,18;32,27;33,17;36,22|835,1357,4405,1468
550|Messager défias|Defias Messenger|14|15|0|40:45,69|1381,7997
1426|Mineur Rivepatte|Riverpaw Miner|14|15|0|40:29,49;30,45;29,46;29,51;30,51;30,48;31,46;30,50|725
589|Pilleur défias|Defias Pillager|14|15|0|40:29,51;44,67;44,68;42,70;33,59;39,58;35,54;43,69|5368,829,4405,4361,4359,7997
712|Vandale des Carmines|Redridge Thrasher|14|15|0|44:24,81;9,68;10,67;10,66;11,64;12,64;10,62|1213,1212
1869|Champion Ravenclaw|Ravenclaw Champion|14|15|0|130:57,32;57,33;56,33;56,32;53,32;54,36;55,32;54,34|
2173|Furie des récifs|Reef Frenzy|14|15|0|130:35,36;35,37;35,50;35,51;35,49;38,77;33,25;37,33|5468,537,6361,4874
1912|Protecteur de Dalaran|Dalaran Protector|14|15|0|130:57,54;62,63;59,66;58,66;55,60;59,63;60,62;55,54|3354,7293
2174|Furie côtière|Coastal Frenzy|14|15|0|148:32,63;40,22;41,19;34,69;46,16;33,66;41,17;44,17|5468,6987,537,6361,4874
2204|Pêcheur Grisebrume|Greymist Netter|14|15|0|148:44,20;36,71;36,70|835,7499
2069|Traquelune|Moonstalker|14|15|0|148:55,21;45,69;40,69;39,69;39,65;51,27;39,64;51,29|5413,5134,4813
11910|Forban du Totem sinistre|Grimtotem Ruffian|14|15|0|406:84,85;85,85;82,86;84,86;83,88;81,88;81,90|
11911|Mercenaire du Totem sinistre|Grimtotem Mercenary|14|15|0|406:82,87;82,86;85,84;82,90;83,88;81,88;80,95|
2322|Trotteur des forêts|Foreststrider|14|16|0|148:49,27;44,71;48,34;53,35;47,32;40,76;53,28;49,35|5469,5114,5115,4775
3283|Massacreur de la KapitalRisk|Venture Co. Enforcer|14|17|0|17:60,3;60,4;62,4;61,4|11148,5097,4361,4359
3270|Ancienne mystique Tranchegroin|Elder Mystic Razorsnout|15|15|2|17:59,24|4768,4771
5837|Bras-de-pierre|Stonearm|15|15|4|17:42,25|5030
3438|Kreenig Grondegroin|Kreenig Snarlsnout|15|15|0|17:59,27|5063
3470|Rathorian||15|15|4|17:48,19|
1425|Grizlak||15|15|4|38:35,27|
502|Benny Blaanco||15|15|0|40:49,19|829,7997
1424|Maître Terrassier|Master Digger|15|15|4|40:46,19|
519|Slark||15|15|4|40:47,11|1357
1972|Grimson le Pâle|Grimson the Pale|15|15|0|130:59,45|3634
12433|Krethis Shadowspinner||15|15|4|130:36,8|3254,3167,5465,1475,3174
4625|Gardien de la Tête de Mort|Death's Head Ward Keeper|15|15|0|491:|5369
3617|Citoyen de Lordaeron|Lordaeron Citizen|15|15|0|1497:66,6;69,15;68,9;71,14;69,11;63,15;62,5;63,9#85:60,67;60,68|
3630|Embobineur déviant|Deviate Coiler|15|16|1|17:46,34;46,35|6445,6443,6470,6471
3248|Girafe des Tarides|Barrens Giraffe|15|16|0|17:52,13;41,25;56,38;40,30;47,43;44,40;45,41;51,43|5119,5120
3461|Gueule d'acier des oasis|Oasis Snapjaw|15|16|0|17:46,39;56,43;47,40;48,40;48,39;46,40;55,42|5098,5066,5075,6361,4555
4127|Hyène Jappecroc|Hecklefang Hyena|15|16|0|17:42,31;43,40;52,13;40,23;48,42;43,37;60,42;49,42|3299,3301
3275|Maraudeur kolkar|Kolkar Marauder|15|16|0|17:55,41;53,45;53,42;54,43;55,47;56,46;54,47;56,43|5030
3282|Mercenaire de la KapitalRisk|Venture Co. Mercenary|15|16|0|17:56,9;57,8;56,7;56,8;57,7|
3241|Patriarche des savanes|Savannah Patriarch|15|16|0|17:44,17;44,14;47,14;46,17;43,15;44,16;62,33|4893,5134,4813
3632|Rampant déviant|Deviate Creeper|15|16|1|17:46,33;47,34;46,34;46,35;47,35|5124,3180,6443,6470,6471
3634|Traqueur déviant|Deviate Stalker|15|16|1|17:48,32;48,34;46,34;46,35|5124,3180,6443,6470,6471
3277|Volplume Ensorçaile|Witchwing Roguefeather|15|16|0|17:40,18;41,20;41,18;40,16;40,15;41,16;42,19|5064,5114
1164|Briseur d’os Brisepierre|Stonesplinter Bonesnapper|15|16|0|38:37,93;52,24;52,22;55,27;53,27;36,94;36,92;35,92|2536,5109
1194|Busard des montagnes|Mountain Buzzard|15|16|0|38:71,75;71,53;76,75;77,56;79,59;76,70;79,67;77,75|3882,6889,556,5114,5115,4775
1197|Chaman Brisepierre|Stonesplinter Shaman|15|16|0|38:35,91;36,94;54,26;54,27;34,95;36,91;38,88|2536,5109
124|Brute Rivepatte|Riverpaw Brute|15|16|0|40:31,70;31,69;33,68;33,69;48,62;49,62;53,63;57,71|725
831|Clampant des mers|Sea Crawler|15|16|0|40:33,22;36,17;31,24;35,18;37,16;31,23;32,21|5506,2674,2675,4874
121|Eclaireur défias|Defias Pathstalker|15|16|0|40:39,70;39,69;37,75;37,76;49,77;53,73;50,78;46,79|832,5368,829,7997
171|Guerrier murloc|Murloc Warrior|15|16|0|40:29,33;29,35;28,33;29,28;25,50;27,38;28,28;26,50|1357,4361,4359,1468,5784
619|Invocateur défias|Defias Conjurer|15|16|1|40:44,74;40,78;42,76|915,7997
594|Malfrat défias|Defias Henchman|15|16|1|40:43,73;42,78;44,74;44,77;42,74|915,7997
824|Terrassier défias|Defias Digger|15|16|0|40:43,75;43,77;42,75;42,78;44,77;43,74;43,76|915,7997
423|Bâtard des Carmines|Redridge Mongrel|15|16|0|44:39,71;24,84;10,61;10,67;27,83;25,84;27,82;25,81|7809,1212
442|Tarentule|Tarantula|15|16|0|44:6,93;8,85;5,77;5,86;15,65;9,76;30,75;13,72|3167,1475,3174,1081
6033|Furie lacustre|Lake Frenzy|15|16|0|130:69,41;63,17;62,28;67,41;67,16;60,28;61,23;75,13#36:32,24;28,35;31,27;23,42;20,46;27,31;18,49;21,12|5468,6987,537,6361,4874
1953|Furtif lacustre|Lake Skulker|15|16|0|130:70,34;73,38;71,37;69,37;72,38;73,36;71,34;71,35|3256
1924|Hurle-sang Ragelune|Moonrage Bloodhowler|15|16|0|130:55,78;60,41;49,76;51,80;47,78;52,86;52,75|
1914|Mage de Dalaran|Dalaran Mage|15|16|0|130:62,72;60,67;63,67;59,67;60,65;59,62;60,62|3354,7293
1870|Main de Ravenclaw|Hand of Ravenclaw|15|16|0|130:59,36;57,35;58,35;57,34;56,35|
2179|Chevaucheur des vagues Tempécaille|Stormscale Wave Rider|15|16|0|148:56,35;56,36;57,34;55,35;55,37;55,33|
2205|Guerrier Grisebrume|Greymist Warrior|15|16|0|148:32,80;44,21;44,20;36,76;33,81;37,77;37,76|7499,5784
11912|Brute du Totem sinistre|Grimtotem Brute|15|16|0|406:78,86;78,85;79,87;79,86;74,86;72,86|
11913|Sorcier du Totem sinistre|Grimtotem Sorcerer|15|16|0|406:78,85;75,85;76,87;80,86;80,87;78,86|
449|Truand défias|Defias Knuckleduster|15|17|0|40:37,76;37,75;35,72;49,79;47,81;38,75;50,79;61,59|5368,829,7997
2235|Clampant des récifs|Reef Crawler|15|17|0|148:35,72;45,22;48,21;47,21;48,22;46,21;36,74|12237,5385,2674,2675,3010,4874
4008|Lézard-tempête des falaises|Cliff Stormer|15|17|0|406:83,90;74,88;76,83;77,84;61,72;75,89;80,85;77,96|5125,5470,5128
3286|Surveillant de la KapitalRisk|Venture Co. Overseer|15|18|0|17:60,4;61,5;62,4;61,4;61,6|11148,5097,5075,4957,814,4361,4359
3471|Artisan Sniggles|Tinkerer Sniggles|16|16|0|17:53,10|5089,4361,4359
3394|Barak Kodobane||16|16|0|17:43,24|5022,5020,5030
6606|Surveillant Glibby|Overseer Glibby|16|16|0|17:56,8|
1207|Bagarreur|Brawler|16|16|0|38:35,91|5109
1206|Grinceur|Gnasher|16|16|0|38:35,91|5109
14268|Seigneur Condar|Lord Condar|16|16|4|38:78,75;75,67;75,71;63,79|3882,6889,556,5114,5115,4775
1954|Ancien Furtif lacustre|Elder Lake Skulker|16|16|0|130:74,35;75,33;75,34;72,37|3256
2106|Apothicaire Berard|Apothecary Berard|16|16|1|130:43,73|
6570|Fenwick Thatros||16|16|0|130:60,34|7306
3667|Anaya Dawnrunner||16|16|0|148:42,61|5382
2186|Carnivous le Casseur|Carnivous the Breaker|16|16|4|148:39,53;40,79;43,85;40,57|6342
7015|Flagglemurk le Cruel|Flagglemurk the Cruel|16|16|4|148:37,68;45,21|5785,1468
7017|Seigneur Salvassio|Lord Sinslayer|16|16|4|148:57,35;56,36|1738,1739,1740,1742,1743,1744,1745,1764,1766,1767,1768,1769,1770,1787,1788,1789,1791,1792,1793,1794
11519|Bazzalan||16|16|1|2437:|
11518|Jergosh l'Invocateur|Jergosh the Invoker|16|16|1|2437:|14147,14150,14151
11517|Lorgnesilex|Oggleflint|16|16|1|2437:|
11520|Taragaman l'Affameur|Taragaman the Hungerer|16|16|1|2437:|14145,14148,14149,14540
3631|Aiguillonneur déviant|Deviate Stinglash|16|17|1|17:47,34;48,32;49,33;49,34;48,35;48,34;47,33|6445,6443,6470,6471
3638|Ectoplasme dévorant|Devouring Ectoplasm|16|17|1|17:48,33;49,32;48,32;49,33;48,34;46,34|6464,3670,3673,3674,7296
3641|Rôdeur déviant|Deviate Lurker|16|17|1|17:47,32;48,34;48,33;49,33;47,33|5516,2608,6361,6443,6470,6471
3260|Sourcier Dos-hirsute|Bristleback Water Seeker|16|17|0|17:47,54;47,53;51,55;45,54;46,55;43,55;48,53|5085,5075
3245|Trotteur des plaines hargneux|Ornery Plainstrider|16|17|0|17:42,16;61,49;60,9;61,34;59,49;49,47;58,52;56,6|4894,5087,4759,4806,5469,4957,5114,5115,4775
3633|Tueur déviant|Deviate Slayer|16|17|1|17:48,32;48,33;49,33;49,34;48,34|5124,3180,6443,6470,6471
3278|Tueuse Ensorçaile|Witchwing Slayer|16|17|0|17:38,16;40,12;38,13;38,15;39,13;39,17;39,12|5065,5064,5114,5115
1192|Ancien sanglier des montagnes|Elder Mountain Boar|16|17|0|38:70,38;65,39;67,39;65,42;63,35;63,40;60,34;76,47|2677,3172,2295,771,769
1189|Patriarche ours noir|Black Bear Patriarch|16|17|0|38:68,43;73,36;69,36;78,42;65,34;72,37;64,34;60,27|10781,10782,3169,3170,3173,11406,2940
452|Bandit Rivepatte|Riverpaw Bandit|16|17|0|40:48,62;53,63;56,70;57,70;61,70;59,74;64,70;61,71|725
458|Chasseur murloc|Murloc Hunter|16|17|0|40:31,35;30,28;25,56;28,35;27,60;26,49;28,41;25,55|1357,4405,4361,4359,1468,5784
154|Grand déchireur|Greater Fleshripper|16|17|0|40:27,42;27,44;62,49;63,51;61,55;59,60;59,63;63,61|555,3399,729,6889,5114,5115,4775
1726|Magicien défias|Defias Magician|16|17|1|40:42,80;39,79;40,78|1928,915,7997
1727|Ouvrier défias|Defias Worker|16|17|0|40:41,79;42,80;40,78;43,79;40,79;40,77|915,7997
1725|Sentinelle défias|Defias Watchman|16|17|1|40:42,80;39,79;40,78#1581:|1925,915,7997
424|Braconnier des Carmines|Redridge Poacher|16|17|0|44:38,71;24,84;30,84;30,83;27,83;26,84;36,72;27,79|1212
547|Grand Broche-tripes|Great Goretusk|16|17|0|44:10,50;42,14;15,40;24,73;28,66;25,78;13,55;27,71#40:55,68;59,59;50,69;57,68;61,68;60,50;64,67;64,55|2296,723,2677,3172,2295,771,769
1083|Guerrier des rivages murloc|Murloc Shorestriker|16|17|0|44:45,66;43,72;43,68;44,70;45,70;46,69;41,69;42,66|1467,1468,5784
1939|Brute Poil-Putride|Rot Hide Brute|16|17|0|130:69,35;67,24;67,33;68,34;67,26;65,25;65,31;66,31|3236,3317
1923|Flaire-sang worg|Bloodsnout Worg|16|17|0|130:46,79;49,83;51,78;50,85;50,84;47,81;48,80;49,81|3164,2672,3299,3301
1913|Garde de Dalaran|Dalaran Warder|16|17|0|130:63,62;64,63;64,64;64,65;63,63;62,64|7293
1957|Rampeur des rives Aileron noir|Vile Fin Shorecreeper|16|17|0|130:78,31;76,33;77,34;77,30|3258,2859,5784
2206|Chasseur Grisebrume|Greymist Hunter|16|17|0|148:33,81;33,80;37,77;37,76;36,77|7499,5784
2338|Disciple du crépuscule|Twilight Disciple|16|17|0|148:38,87;38,86;40,88;39,88;39,85|5352
2336|Fanatique de la Rive noire|Dark Strand Fanatic|16|17|0|148:56,26;57,27;57,28;56,27;55,28|5348
2168|Guerrier Noirbois|Blackwood Warrior|16|17|0|148:43,84;51,34;51,35;40,78;52,34;53,34;40,79|
2180|Sirène Tempécaille|Stormscale Siren|16|17|0|148:55,35;55,37;55,36;57,35;55,34;56,35;56,34;55,33|
2070|Traquelune chétif|Moonstalker Runt|16|17|0|148:47,41;43,90;40,41;42,48;42,54;46,24;40,91;39,51|5413,5134,4813
2165|Vieil ours des chardons|Grizzled Thistle Bear|16|17|0|148:45,81;38,82;40,82;39,82;39,70;38,79;41,81|5414,3169,3170,3173,11406,2940
11915|Gardien des rochers de Gogger|Gogger Rock Keeper|16|17|0|406:58,91;62,92;60,93;60,92;60,91;61,92;61,91;60,90|16581
11917|Géomancien de Gogger|Gogger Geomancer|16|17|0|406:58,93;60,91;59,91;57,90;59,90;61,93;61,91;60,92|16581
4005|Rampant des mousses profondes|Deepmoss Creeper|16|17|0|406:59,74;59,73;64,93;55,75;56,76;58,76;59,76;60,75|3931,5601,5602,1475,3182,3174,1081
6492|Rejeton de la faille|Rift Spawn|16|17|0|1519:51,93;51,96;52,94;51,92#1497:53,75;54,77;52,76;53,71|
3256|Faucheur solécaille|Sunscale Scytheclaw|16|18|0|17:57,53;39,26;43,16;46,15;52,51;49,50;48,50;53,46|5055,5165,5062,5124,3180
517|Oracle murloc|Murloc Oracle|16|18|0|40:28,69;34,83;26,74;26,72;26,59;27,76;34,85;35,85|1357,4359,1468,5784
2187|Ancien Batteur de Sombrivage|Elder Darkshore Thresher|16|18|0|148:31,83;58,10;31,81;31,73;31,88;33,86;49,13;49,11|5412,5516,2608,6361
5838|Brise-épieu|Brokespear|17|17|4|17:57,41|5030
5841|Rochelance|Rocklance|17|17|2|17:56,42|5030
5829|Snort la Moqueuse|Snort the Heckler|17|17|4|17:41,22|3299,3301
1205|Grawmug||17|17|0|38:35,90|5109
1222|Sapeur Sombrefer|Dark Iron Sapper|17|17|0|38:56,13|
14271|Chassecôtes|Ribchaser|17|17|4|44:11,65;10,66;8,63;10,61;14,62;27,82;27,83;24,84|1013,2856,1212
2184|Dame Moongazer|Lady Moongazer|17|17|4|148:43,61|
3662|Delmanis le Haï|Delmanis the Hated|17|17|0|148:57,28|6887,8957
11914|Gorehoof le Noir|Gorehoof the Black|17|17|0|406:77,85|
3258|Chasseur Dos-hirsute|Bristleback Hunter|17|18|0|17:43,48;45,51;43,49;51,54;43,52;46,54;44,55|5085,5075
3279|Embusquée Ensorçaile|Witchwing Ambusher|17|18|0|17:38,16;38,17|5064,5114,5115
3426|Etalon zhévra|Zhevra Charger|17|18|0|17:47,14;39,29;36,28;45,15;52,50;60,50;53,47;61,33|10338,5086,5119,5120
3280|Imploratrice céleste Ensorçaile|Witchwing Windcaller|17|18|0|17:39,12;38,13;38,15;39,14;38,16;39,13;40,15;38,12|5064,5075,5114,5115
3416|Matriarche des savanes|Savannah Matriarch|17|18|0|17:61,35;60,32;60,33;62,32;62,33;63,34|4893,5134,5135
1165|Géomancien Brisepierre|Stonesplinter Geomancer|17|18|0|38:73,62;70,66;69,66;71,64;70,63;72,68;69,63|2636,2536,5109
1185|Rôdeuse des bois|Wood Lurker|17|18|0|38:76,38;81,40;80,40;78,36;74,35;76,36;74,38|2606,3931,5465,1475,3174,1081
1216|Clampant du rivage|Shore Crawler|17|18|0|40:26,65;26,67;25,65;26,66;32,83;29,79;30,81;29,78|2674,2675,3010,4874
625|Dynamiteur mort-vivant|Undead Dynamiter|17|18|1|40:41,81;41,83;42,83;42,81|1894
624|Excavateur mort-vivant|Undead Excavator|17|18|1|40:42,83;41,81;41,83;42,82|1894
122|Malandrin défias|Defias Highwayman|17|18|0|40:46,78;52,73;53,79;49,77;42,81;37,83;38,81;48,77|5368,829,7997
623|Mineur squelette|Skeletal Miner|17|18|1|40:41,82;42,81;42,82;41,83;41,81|1894
115|Moissonneur|Harvest Reaper|17|18|0|40:66,61;66,62;65,62;65,61;63,58;62,59;65,60;64,61|732,1274,814,4361,4359
98|Sous-chef Rivepatte|Riverpaw Taskmaster|17|18|0|40:57,70;60,71;62,78;63,76;63,77;64,73;65,77;62,73|725
426|Brute des Carmines|Redridge Brute|17|18|0|44:19,35;16,36;15,33;19,37;18,38;34,32;34,31|1013,2856,1212
441|Dragonnet noir|Black Dragon Whelp|17|18|0|44:62,77;50,74;55,75;57,75;19,35;29,73;30,68;29,76|1221,3177,3176
548|Maître des flots murloc mineur|Murloc Minor Tidecaller|17|18|0|44:56,62;55,62;52,62;50,62;54,60;44,72;44,69;37,49|1467,1468,5784
1915|Conjurateur de Dalaran|Dalaran Conjuror|17|18|0|130:63,62;63,64;63,63;64,65;64,66;63,65|3354,7293
1958|Maître des flots Aileron noir|Vile Fin Tidecaller|17|18|0|130:81,31;78,33;78,31;80,29;79,28;79,32;80,27#36:27,35|3258,2859,5784
1940|Pestilentiel Poil-Putride|Rot Hide Plague Weaver|17|18|0|130:70,37;65,23;67,23;68,33;65,26;67,26;68,25|3236,3317
1955|Rampant lacustre|Lake Creeper|17|18|0|130:78,29;77,26;77,28;78,25;77,27;78,27;78,26|3257
2237|Géniteur traquelune|Moonstalker Sire|17|18|0|148:44,82;39,94;37,92;40,81;42,83;44,80;43,88;43,82|5386,5413,5134,5135
2339|Nervi du crépuscule|Twilight Thug|17|18|0|148:38,87;55,36;39,88;39,87;40,86;39,86;56,35|5352
2169|Totémique Noirbois|Blackwood Totemic|17|18|0|148:43,86;43,87;45,89;51,35;52,33;53,34;52,34;40,78|
11918|Cassepierre de Gogger|Gogger Stonepounder|17|18|0|406:59,93;60,93;60,91;59,92;59,91;57,90|16581
4007|Venimeux des mousses profondes|Deepmoss Venomspitter|17|18|0|406:49,45;49,49;61,59;55,73;52,76;59,61;51,40;62,63|3931,4957,5601,5602,1475,3182,3174,1081
3640|Ectoplasme grandissant|Evolving Ectoplasm|17|18|1|718:|6464,3670,3673,3674,7296
1729|Evocateur défias|Defias Evoker|17|18|1|1581:|1929,915,7997
634|Surveillant défias|Defias Overseer|17|18|1|1581:|10400,10401,915,7997
2323|Trotteur des forêts géant|Giant Foreststrider|17|19|0|148:38,81;36,94;37,95;37,96;39,82;41,81;39,91;61,10|7498,5469,5114,5115,4775
3655|Magglish le Dingue|Mad Magglish|18|18|1|17:46,34|5334
3445|Superviseur Lugwizzle|Supervisor Lugwizzle|18|18|0|17:56,9|5050
1184|Rôdeuse des falaises|Cliff Lurker|18|18|0|38:49,73;70,52;58,77;49,72;66,51;65,53;62,56;46,72|2606,3167,5465,1475,3174,1081
599|Marisa du'Paige||18|18|2|40:42,80;44,79;44,77|
596|Noble manipulé|Brainwashed Noble|18|18|2|40:44,78|
506|Sergent Brashclaw|Sergeant Brashclaw|18|18|4|40:37,32|725
14272|Grondefuse|Snarlflare|18|18|4|44:37,31;43,34;45,33;39,33;35,33;39,30;31,65;29,66|1221,3177,3176
3862|Worg écumant|Slavering Worg|18|18|1|209:|1015,1974,1484,1483,3194,3301,3402
11858|Grundig Darkcloud||18|18|0|406:74,86|
598|Mineur défias|Defias Miner|18|18|0|1581:|1930,915,7997
539|Araignée Tisse-venin pygmée|Pygmy Venom Web Spider|18|19|0|10:47,17;10,66;9,61;55,14;72,19;10,59;10,54;12,29|1130,4428,878,2251,1475,3182,3174,1081
3463|Girafe errante des Tarides|Wandering Barrens Giraffe|18|19|0|17:50,55;51,60;53,55;50,56;44,46;44,53;44,47;50,54|5119,5120
4129|Grogneuse Jappecroc|Hecklefang Snarler|18|19|0|17:46,55;45,46;44,46;43,47;47,47;45,49;46,48;50,56|3299,3301
3240|Groin-tempête|Stormsnout|18|19|0|17:49,51;52,57;48,52;51,53;43,49;46,48;44,45;46,51|5143,4895,5125,5470,4957,5128
6020|Makrura à carapace gluante|Slimeshell Makrura|18|19|0|17:65,36;63,53;64,55;63,52;64,50;65,49;65,38;65,42|4887,3010,4874
3503|Protecteur silithide|Silithid Protector|18|19|0|17:45,72|1180,5058,7119,5268,5269
3261|Tisseur d’épines Dos-hirsute|Bristleback Thornweaver|18|19|0|17:43,52;45,52;53,53;53,54;44,51;52,57|5085,5075,4957
1181|Chaman Mo'grosh|Mo'grosh Shaman|18|19|1|38:70,18;75,31;67,22;75,30;72,21;65,20;77,18;75,17|6992,2607
1169|Insurgé Sombrefer|Dark Iron Insurgent|18|19|0|38:58,17;58,19;59,19;60,16;59,13;59,14#11:63,78;63,77;64,78|
1179|Massacreur Mo'grosh|Mo'grosh Enforcer|18|19|1|38:66,32;71,24;74,25;67,23;72,20;69,25;77,16;76,15|2821,6992,2607
1178|Ogre Mo'grosh|Mo'grosh Ogre|18|19|1|38:69,32;69,28;70,26;70,27;74,26;64,21;64,25;66,22|6992,2607
1167|Terrassier Brisepierre|Stonesplinter Digger|18|19|0|38:68,66;69,66;68,63;71,60;71,65;71,66;73,67;70,67|2636,2536,5109
127|Chasse-marée murloc|Murloc Tidehunter|18|19|0|40:28,70;26,74;26,72;28,69;35,84;27,72;35,85|1357,4361,1468,5784
832|Diable de poussière|Dust Devil|18|19|0|40:69,74;38,62;35,35;40,22;33,49;61,35;34,68;46,49|5669,2091,7069
450|Mage renégat défias|Defias Renegade Mage|18|19|0|40:37,75;37,83|5772,829,7997
453|Mystique Rivepatte|Riverpaw Mystic|18|19|0|40:61,74;61,77;63,78;62,76;64,77;64,73;65,75;61,73|725
428|Condor redoutable|Dire Condor|18|19|0|44:55,76;52,76;59,76;50,46;30,70;50,73;45,34;44,35|1080,6889,556,1464,5114,5115,4775
422|Dévoreur murloc|Murloc Flesheater|18|19|0|44:56,62;55,62;52,62;50,62;54,60;44,72;44,69;37,49|1467,1468,5784
430|Mystique des Carmines|Redridge Mystic|18|19|0|44:27,29;20,32;22,36;12,18;29,25;26,24;18,27;34,31|1013,2856,1212
1956|Ancien Rampant lacustre|Elder Lake Creeper|18|19|0|130:75,21;74,21;74,20;77,21;79,24;77,23;76,23;78,23|3257
1943|Furieux Poil-Putride|Raging Rot Hide|18|19|0|130:66,23;65,24;66,25;65,25;66,24|3236,3317
1888|Gardien de Dalaran|Dalaran Watcher|18|19|0|130:65,62;63,59;65,59;64,56;64,77;61,76;63,77;59,76|7293
1909|Rôdeur lacustre Aileron noir|Vile Fin Lakestalker|18|19|0|130:66,46;70,17;64,20;66,20;68,19;74,19;67,45;75,16|3258,2859,5784
1942|Sauvage Poil-Putride|Rot Hide Savage|18|19|0|130:66,24;66,23;65,25;65,23;66,25|3236,3317
2156|Golem lézardé|Cracked Golem|18|19|0|148:36,86;35,85;36,84;35,84|5568
2181|Myrmidon Tempécaille|Stormscale Myrmidon|18|19|0|148:59,25;58,20;59,22;58,19;60,15;61,17;58,24;57,18|5329
6788|Mère de la tanière|Den Mother|18|19|0|148:51,38|5414,3169,3170,3173,11406,2940
2207|Oracle Grisebrume|Greymist Oracle|18|19|0|148:55,12;31,86;31,87;55,13;31,84;31,88|7499,5784
2170|Ursa Noirbois|Blackwood Ursa|18|19|0|148:42,86;43,87;44,84;45,87;44,85;44,86|
3851|Poil-blanc Ombrecroc|Shadowfang Whitescalp|18|19|1|209:|1974,1484,1483,3194
3861|Worg pâle|Bleak Worg|18|19|1|209:|1015,1974,1484,1483,3194,3301,3402
3728|Adepte de la Rive noire|Dark Strand Adept|18|19|0|331:32,29;32,30;31,30|5366
3816|Cerf sauvage|Wild Buck|18|19|0|331:21,33;18,39;17,38;22,36;27,28;25,16;27,34;24,37|5471,5566
3713|Chevaucheur des vagues Irequeue|Wrathtail Wave Rider|18|19|0|331:12,25;16,16;14,21;15,18;15,16;15,20;15,22;12,29|5490,4377
3717|Ensorceleuse Irequeue|Wrathtail Sorceress|18|19|0|331:12,24;14,15;16,15;14,19;15,21;15,20;14,23;15,25|5490
3725|Sectateur de la Rive noire|Dark Strand Cultist|18|19|0|331:31,32;31,31;30,31;30,32;31,30;33,29;31,29|5366
3989|Déboiseur de la KapitalRisk|Venture Co. Logger|18|19|0|406:74,59;66,51;68,49;67,55;66,52;61,55;64,46;73,54|5601,5602
4009|Lézard-tempête enragé des falaises|Raging Cliff Stormer|18|19|0|406:78,56;78,50;59,48;63,64;51,33;48,35;51,39;48,37|5125,5470,5601,5602,5128
5053|Crocilisque déviant|Deviate Crocolisk|18|19|0|718:|3181,3401,2924,2925,6443,6470,6471
3637|Gardien déviant|Deviate Guardian|18|19|1|718:|5124,4957,3180,6443,6470,6471
8886|Python déviant|Deviate Python|18|19|0|718:|6445,6443,6470,6471
3636|Ravageur déviant|Deviate Ravager|18|19|1|718:|5124,3180,6443,6470,6471
5048|Serpent déviant|Deviate Adder|18|19|1|718:|6445,6443,6470,6471
1731|Artisan gobelin|Goblin Craftsman|18|19|1|1581:|1944,814,4405,4359
4416|Carrier défias|Defias Strip Miner|18|19|0|1581:|10402,915,4359,7997
622|Ingénieur gobelin|Goblin Engineer|18|19|1|1581:|1936,4405,4361,4359
641|Sculpteur gobelin|Goblin Woodcarver|18|19|1|1581:|1945,6994,4361,4359
4418|Sorcier défias|Defias Wizard|18|19|1|1581:|1929,915,4405,4361,4359,7997
4417|Sous-chef défias|Defias Taskmaster|18|19|1|1581:|10400,10401,915,4361,4359,7997
3247|Jeune faucon-tonnerre|Thunderhawk Hatchling|18|20|0|17:47,51;43,46;48,51;46,47;47,49;46,49;51,53;45,53|5164,6445
2233|Clampant des marées incrusté|Encrusted Tide Crawler|18|20|0|148:33,83;32,84;54,19;53,19;52,21;52,23;33,81;32,81|7500,12237,5385,2674,2675,3010,4874
9336|Chef Copperplug|Boss Copperplug|19|19|0|17:60,4|11147,5097,814,4405,4359
5835|Contremaître Grills|Foreman Grills|19|19|4|17:56,8|
5863|Géoprêtresse Gukk'rok|Geopriest Gukk'rok|19|19|4|17:43,52|
3396|Hezrul Marque-de-sang|Hezrul Bloodmark|19|19|0|17:46,41|5025,5030
5836|Ingénieur Whirleygig|Engineer Whirleygig|19|19|4|17:56,9|814,4361,4359
3295|Limace bestiale|Sludge Beast|19|19|4|17:57,8|3670,3673,3674,7296
5830|Sœur Rathtalon|Sister Rathtalon|19|19|2|17:39,15|5114,5115
5842|Takk le Bondisseur|Takk the Leaper|19|19|2|17:60,8|5055,5062,5124,3180
3652|Trigore le Flagelleur|Trigore the Lasher|19|19|2|17:48,33|3010,4874
14267|Emogg le Broyeur|Emogg the Crusher|19|19|2|38:73,27|2821,2607
14266|Shanda la Tisseuse|Shanda the Spinner|19|19|4|38:78,52|2606,3931,5465,1475,3174,1081
520|Brack||19|19|4|40:27,45|1357,5784
572|Leprithus||19|19|4|40:43,27;42,29;42,30;65,67;65,68|2085
125|Surveillant Rivepatte|Riverpaw Overseer|19|19|0|40:61,78;63,78|1190,725
14270|Squiddic||19|19|4|44:34,56;35,53;40,50;44,56;45,67;44,71;40,66;36,62|1467,1468,5784
2192|Flamboyeur Radison|Firecaller Radison|19|19|4|148:39,88|9767,9771
3586|Mineur Johnson|Miner Johnson|19|19|2|1581:|5443,5444
644|Rhahk'Zor||19|19|1|1581:|872,5187
217|Araignée Tisse-venin|Venom Web Spider|19|20|0|10:74,20;15,68;69,20;54,17;48,18;9,40;22,28;50,18|1130,4428,878,2251,1475,3182,3174,1081
213|Loup redoutable affamé|Starving Dire Wolf|19|20|0|10:13,67;36,25;40,19;42,19;34,27;22,29;28,26;58,16|893,1015,3301,3402
2103|Eclaireur Dragonmaw|Dragonmaw Scout|19|20|0|11:50,76;51,80;47,76;48,75;48,74;50,79;48,78;48,77|
3263|Géomancienne Dos-hirsute|Bristleback Geomancer|19|20|0|17:42,45;43,48;53,52;44,48;53,55;43,49;51,57|5085,5075
3236|Kodo des Tarides|Barrens Kodo|19|20|0|17:46,68;47,67|15852,4780,4896,5121,5082,5467
1180|Brute Mo'grosh|Mo'grosh Brute|19|20|1|38:75,25;75,16;76,18;77,14;80,15;69,20|2607
1224|Jeune Battrodon|Young Threshadon|19|20|0|38:54,47;54,61;49,62;59,47;57,47;51,50;48,51;46,51|5516,2608,6361
1183|Mystique Mo'grosh|Mo'grosh Mystic|19|20|1|38:75,25;77,14;68,19;69,19|6992,2607
1393|Trogg berserk|Berserk Trogg|19|20|0|38:68,66;69,62;68,63;71,64;73,63|2636,2536,5109
446|Cogneur des Carmines|Redridge Basher|19|20|0|44:27,29;22,27;14,22;14,18;12,22;23,28;27,24;18,27|1013,2856,1212
578|Eclaireur murloc|Murloc Scout|19|20|0|44:53,52;51,55;52,51;76,61;40,51;36,46;49,53|1467,1468,5784
505|Grande tarentule|Greater Tarantula|19|20|0|44:62,77;49,36;49,38;49,44;51,43;48,38;46,41;43,38|3931,1475,3182,3174,1081
440|Grunt Blackrock|Blackrock Grunt|19|20|0|44:70,74;67,82;72,86;56,43;70,82;54,44;57,41;32,46|3014,7906
545|Maître des flots murloc|Murloc Tidecaller|19|20|0|44:53,52;51,55;52,51;76,61;40,51;36,46;49,53|1467,1468,5784
1974|Manouvrier Ravenclaw|Ravenclaw Drudger|19|20|0|130:60,74;57,71;58,70;58,72;60,71;61,72;60,72|
1908|Oracle Aileron noir|Vile Fin Oracle|19|20|0|130:65,42;68,21;73,19;73,16;71,18;71,17;65,43;67,49|3258,2859,5784
1889|Sorcier de Dalaran|Dalaran Wizard|19|20|0|130:66,50;64,57;63,58;64,59;63,76;66,76;65,76;63,73|7293
2157|Béhémoth de pierre|Stone Behemoth|19|20|0|148:36,86;35,85|5568
2171|Chaman Noirbois|Blackwood Shaman|19|20|0|148:45,87;43,86;43,87;44,85;44,84|
2208|Chasse-marée Grisebrume|Greymist Tidehunter|19|20|0|148:55,12;31,83;31,87;55,13;32,83;31,86;31,88|7499,5784
2182|Ensorceleuse Tempécaille|Stormscale Sorceress|19|20|0|148:60,24;62,21;60,19;59,24;58,22;62,19;58,24|5329
2071|Matriarche traquelune|Moonstalker Matriarch|19|20|0|148:61,13;43,91;35,89;36,90;39,92;40,90;61,12;63,7|5386,5413,5134,5135
3864|Palefroi corrompu|Fel Steed|19|20|1|209:|932,6341,5871,1318,1974,1484,5120,1483,3194
3737|Bondisseur Crache-sel|Saltspittle Puddlejumper|19|20|0|331:20,45;19,40;20,44;19,43;19,42;22,42;21,43|5463,1468,5784
3812|Clampant cliquetant|Clattering Crawler|19|20|0|331:13,16;11,29;11,16;13,19;10,35;10,33;10,14;12,14|2674,2675,3010,4874
3823|Coureur Patte-fantôme|Ghostpaw Runner|19|20|0|331:18,47;34,60;23,48;20,49;18,36;32,51;76,67;31,52|16748,16747,1015,3301,3402
3730|Excavateur de la Rive noire|Dark Strand Excavator|19|20|0|331:32,32;31,31;32,31|6912,5366
3739|Guerrier Crache-sel|Saltspittle Warrior|19|20|0|331:20,45;21,44;19,42;19,41;22,41;21,43;21,40|5463,1468,5784
3721|Hydre Fouettebrume|Mystlash Hydra|19|20|0|331:12,18;10,17;9,14;10,16;9,31;13,19;14,17;12,28|5569,3010,4377
3712|Rasoir Irequeue|Wrathtail Razortail|19|20|0|331:14,31;9,30;8,29;10,25;10,26;11,14;11,29;11,28|5490
3715|Sorcière des mers Irequeue|Wrathtail Sea Witch|19|20|0|331:10,26;7,13;8,28;9,26;9,25;12,32;11,29;11,27|5490
3991|Défricheur de la KapitalRisk|Venture Co. Deforester|19|20|0|406:75,59;67,52;69,56;71,57;62,54;64,47;74,55|
4011|Jeune Aile-fière|Young Pridewing|19|20|0|406:78,54;61,49;77,44;62,64;64,59|5808,5135,5601,5602,5136
3988|Opérateur de la KapitalRisk|Venture Co. Operator|19|20|0|406:70,56;71,43;72,50;75,56;63,54;73,49;62,52;66,46|5734,5601,5602
4006|Tisseuse des mousses profondes|Deepmoss Webspinner|19|20|0|406:79,51;77,50;76,45;74,43;61,46;77,46;53,72|3931,5601,5602,1475,3182,3174,1081
3840|Druide du Croc|Druid of the Fang|19|20|1|718:|10413
5055|Flagellant déviant|Deviate Lasher|19|20|0|718:|
5761|Glacial déviant|Deviate Shambler|19|20|1|718:|6443,6470,6471
636|Canaille défias|Defias Blackguard|19|20|1|1581:|1934,915,7997
3947|Constructeur naval gobelin|Goblin Shipbuilder|19|20|1|1581:|1943,4405,4361,4359
1732|Forme-grain défias|Defias Squallshaper|19|20|1|1581:|1951,5786,915,7997
657|Pirate défias|Defias Pirate|19|20|1|1581:|8492,1951,5787,915,4361,7997
3672|Boahn||20|20|2|17:49,34|
3398|Gesharahan||20|20|2|17:47,39|5182,5183,3010,4874
3251|Larve silithide|Silithid Grub|20|20|0|17:48,71;45,72;47,70;44,72;43,70|5058,7119,5268,5269
3452|Serena Plumesang|Serena Bloodfeather|20|20|0|17:39,12|5067,5064,5114,5115
1225|Vieux Noiraud|Ol' Sooty|20|20|1|38:38,63|2713,3169,3170,3173,11406,2940
626|Contremaître Crispechardon|Foreman Thistlenettle|20|20|1|40:42,83|1875
573|Découpeur 4000|Foe Reaper 4000|20|20|4|40:45,35;47,67;41,50;38,49;44,37;49,30;51,22;62,58|732,1274,814,4361,4359
391|Vieux Troubloeil|Old Murk-Eye|20|20|0|40:29,76|3636,1357,5784
2172|Matriarche trotteuse|Strider Clutchmother|20|20|4|148:35,87|1497,1504,1507,1510,1511,1512,1514,1516,1735,2214,2763,3374,3375,4570,5071,6266,6268,6336,6512,6537
3854|Garde-loup d'Ombrecroc|Shadowfang Wolfguard|20|20|1|209:|1935,2807,1318,1974,1484,1483,3194
3853|Marche-lune d'Ombrecroc|Shadowfang Moonwalker|20|20|1|209:|2807,1318,1974,1484,1483,3194
3914|Rethilgore||20|20|1|209:|5254
5912|Dragon féérique déviant|Deviate Faerie Dragon|20|20|2|718:|5243,6632,3177,3176,6443,6470,6471
3653|Kresh||20|20|1|718:|6447,13245,6361,6443,6470,6471,4556,4555
3669|Seigneur Cobrahn|Lord Cobrahn|20|20|1|718:|6460,6465,9738,10410
5755|Vipère déviante|Deviate Viper|20|20|1|718:|6445,6443,6470,6471
7897|Alarme-bombe 2600|Alarm-a-bomb 2600|20|20|0|721:|
5687|Abomination captive|Captive Abomination|20|20|0|1497:52,22|
5043|Emeutier défias|Defias Rioter|20|20|0|1519:50,66|
647|Capitaine Vertepeau|Captain Greenskin|20|20|1|1581:|5200,5201,10403
642|Déchiqueteur de Sneed|Sneed's Shredder|20|20|1|1581:|1937,2169,7365,4359
1763|Gilnid||20|20|1|1581:|1156,5199
646|M. Smite|Mr. Smite|20|20|1|1581:|5192,5196,7230
645|Macaron|Cookie|20|20|1|1581:|5197,5198,8490,11982,5784
565|Loup redoutable enragé|Rabid Dire Wolf|20|21|0|10:13,69;16,30;35,26;34,28;22,30;56,20;11,61;16,27|893,1015,3301,3402
1039|Créature des tourbières|Fen Dweller|20|21|0|11:62,59;60,51;17,42;29,28;23,45;60,62;32,27;17,41|
1030|Gelée noire|Black Slime|20|21|0|11:62,79;53,50;57,79;54,72;55,67;66,61;59,69;55,63|814,3670,3673,3674,7296
1007|Gnoll Poil-moussu|Mosshide Gnoll|20|21|0|11:60,74;61,73;62,72;56,76;63,69;62,67;64,64|
2102|Grunt Dragonmaw|Dragonmaw Grunt|20|21|0|11:49,66;49,83;47,77;49,77;48,75;49,80;48,76;47,75|
1024|Murloc Branchie-bleue|Bluegill Murloc|20|21|0|11:12,39;12,41;18,41;13,41;17,40;15,40;15,39;16,41|1468,5784
3466|Coursier zhévra|Zhevra Courser|20|21|0|17:45,67;47,69;50,61;48,65;45,63;49,62;48,61;45,61|10338,5086,5119,5120
3456|Guide Tranchecrin|Razormane Pathfinder|20|21|0|17:44,80;44,81;44,84;45,80;45,81;43,80|5093
3250|Rampant silithide|Silithid Creeper|20|21|0|17:45,73;49,69;48,69;44,73;42,71;47,70;45,72|5058,7119,5268,5269
3239|Tête-tonnerre|Thunderhead|20|21|0|17:46,67;47,67;50,60;48,63;46,64;48,60;47,69|5143,4895,5125,5470,5128
4064|Eclaireur Blackrock|Blackrock Scout|20|21|1|44:60,49;57,65;63,53;58,50;59,50;58,49;60,60|3014,7906
485|Estafette Blackrock|Blackrock Outrunner|20|21|0|44:73,69;74,69;71,69;71,81;56,44;54,44;37,18;32,46|3014,7906
580|Manouvrier des Carmines|Redridge Drudger|20|21|0|44:11,17;15,21;11,19;17,24;17,21;15,13;17,17;12,18|2798,1013,2856,1212
1973|Gardien Ravenclaw|Ravenclaw Guardian|20|21|0|130:57,71;58,72;58,70;57,70;59,72;59,71;60,71;60,70|
2236|Clampant des récifs enragé|Raging Reef Crawler|20|21|0|148:30,90;31,90;30,91;56,13;56,17;55,18|7500,5385,2674,2675,3010,4874
2183|Guerrier Tempécaille|Stormscale Warrior|20|21|0|148:61,22;61,21;60,19;60,20;62,20;61,18;61,19|5329
4802|Prêtresse des marées de Brassenoire|Blackfathom Tide Priestess|20|21|1|148:30,92;31,92;33,94;31,94;31,91#331:13,13;13,12;14,12|16790,6995,5952,2143,2567,3415,1486,2271
3865|Destrier des ténèbres|Shadow Charger|20|21|1|209:|5871,1482,1935,2807,1318,1484,5120,1483,3194
5058|Garde-loup worg|Wolfguard Worg|20|21|0|209:|
3875|Serviteur hanté|Haunted Servitor|20|21|1|209:|1482,1935,2807,1318,1974,1484,1483,3194
2350|Rampemousse forestière|Forest Moss Creeper|20|21|0|267:18,53;21,52;26,39;70,9;57,10;65,26;62,40;58,24|3477,4428,878,1288,2251,3182,1081
2261|Sentinelle du Syndicat|Syndicate Watchman|20|21|0|267:83,44;76,44;67,50;79,40;75,40;76,41;76,46;82,41|3692
3814|Clampant épineux|Spined Crawler|20|21|0|331:8,16;7,17;6,14;10,35;14,20;10,15;12,17;11,32|2674,2675,5569,3010
3740|Marche-boue Crache-sel|Saltspittle Muckdweller|20|21|0|331:19,44;21,42|5463,1468,5784
3727|Massacreur de la Rive noire|Dark Strand Enforcer|20|21|0|331:32,31|5366
3711|Myrmidon Irequeue|Wrathtail Myrmidon|20|21|0|331:7,16;6,11;6,12;7,14;6,13;8,15;8,16|5490
3742|Oracle Crache-sel|Saltspittle Oracle|20|21|0|331:20,44;21,44;21,42;20,43;21,41|5463,1468,5784
3944|Prêtresse Irequeue|Wrathtail Priestess|20|21|0|331:7,16;6,15;6,12;7,13;8,14;8,13;7,12|5490
4788|Satyre Sans-racines|Fallenroot Satyr|20|21|1|331:14,12;13,13;14,11#148:31,93;31,94|5952,3415,1486,2271
3819|Traqueuse Ronce-sauvage|Wildthorn Stalker|20|21|0|331:70,86;27,53;23,47;21,50;39,41;78,66;74,71;26,49|16748,16747,4428,878,1288,2251,3182,3174,1081
4070|Bâtisseur de la KapitalRisk|Venture Co. Builder|20|21|0|406:63,41;64,40;64,39|4361,4359
4003|Géomancien des Cisailles|Windshear Geomancer|20|21|0|406:74,58;76,59;74,59;73,61;74,60|7126
3992|Ingénieur de la KapitalRisk|Venture Co. Engineer|20|21|0|406:63,41;64,39|814,4361,4359
5056|Croc-d'effroi déviant|Deviate Dreadfang|20|21|1|718:|6445,6443,6470,6471
5756|Venimeux des airs déviant|Deviate Venomwing|20|21|1|718:|6445,6443,6470,6471
3424|Faucon-tonnerre des nuages|Thunderhawk Cloudscraper|20|22|0|17:50,61;46,67;49,62;47,61;48,60;45,63|5164,6445
3928|Gelée pourrissante|Rotting Slime|20|22|0|331:69,85;69,83;70,74;78,70;71,75;70,85;77,68;71,74|6712,16748,16747,3670,3673,3674,7296
3436|Kuz||21|21|0|17:45,80|5074
5831|Vif-crins|Swiftmane|21|21|2|17:61,34|5086,5119,5120
1399|Magosh||21|21|4|38:70,66|5109
14269|Aqualon le Chercheur|Seeker Aqualon|21|21|4|44:55,56;57,61;62,71|9451,7070
1920|Copiste de Dalaran|Dalaran Spellscribe|21|21|4|130:64,63|
3857|Glouton d'Ombrecroc|Shadowfang Glutton|21|21|1|209:|1489,2205,1482,1935,2807,1318,1974,1484,1483,3194
3855|Ténébreux d'Ombrecroc|Shadowfang Darksoul|21|21|1|209:|6915,1482,1935,2807,1318,1974,1484,1483,3194
11921|Besseleth||21|21|1|406:55,72;52,74;52,72|16192,3931,4428,5601,5602,1475,3182,3174,1081
3670|Seigneur Pythas|Lord Pythas|21|21|1|718:|6472,6473,9740
3673|Seigneur Serpentis|Lord Serpentis|21|21|1|718:|5970,6459,6469,9741,10411
3674|Skum||21|21|1|718:|6448,6449,5125,5470,6443,6470,6471,5128
5775|Verdan l'Immortel|Verdan the Everliving|21|21|1|718:|6629,6630,6631,6443,6470,6471
639|Edwin VanCleef||21|21|2|1581:|2874,3637,5191,5193,5202,10399
48|Guerrier squelette|Skeletal Warrior|21|22|0|10:77,74;77,72;80,72;77,70;81,70;82,69;80,73;81,69|2378,2794
569|Solitaire verte|Green Recluse|21|22|0|10:13,69;69,23;14,65;13,58;11,42;75,23;58,21;62,23|1130,4428,878,1288,2251,3182,3174,1081
1025|Bondisseur Branchie-bleue|Bluegill Puddlejumper|21|22|0|11:12,36;10,36;11,35;19,39;18,40;15,38;15,34;14,35|1468,5784
1008|Bâtard Poil-moussu|Mosshide Mongrel|21|22|0|11:60,73;62,72;62,73;63,69;61,68;60,59;64,63;62,58|
1417|Jeune crocilisque des Paluns|Young Wetlands Crocolisk|21|22|0|11:65,71;55,31;50,34;61,62;29,36;52,36;28,40;29,34|3397,2924,2925,3667,770
4040|Traqueuse des grottes|Cave Stalker|21|22|0|11:50,59;51,62;49,62;49,60;50,60;47,59;47,60;47,63|3340,6838,4428,878,1288,2251,3182,3174,1081
1111|Traqueuse sanguine|Leech Stalker|21|22|0|11:50,59;50,61;55,67;56,65;54,63;52,63;49,61;46,62|3340,6838,4428,878,1288,2251,3182,3174,1081
3252|Grouillant silithide|Silithid Swarmer|21|22|0|17:45,72;48,71;42,69;46,73;44,71;42,70;45,70|5058,7119,5268,5269
445|Alpha des Carmines|Redridge Alpha|21|22|0|44:12,18;22,21;23,22;22,23;21,21;22,22;21,23|17706
434|Gnoll Sombrepoil enragé|Rabid Shadowhide Gnoll|21|22|0|44:70,48;68,54;71,47;70,50;68,58;66,54;68,55|1075,1962,16882
544|Marcheur de l'ombre murloc|Murloc Nightcrawler|21|22|0|44:76,59;76,60;77,60|1467,1468,5784
437|Renégat Blackrock|Blackrock Renegade|21|22|0|44:73,69;73,67;72,67;73,73;58,46;38,12;36,11;34,15|3014,7906
4065|Sentinelle Blackrock|Blackrock Sentry|21|22|1|44:64,54;57,66;61,57;63,56;58,50;60,55;58,49;60,60|3014,7906
12123|Requin des récifs|Reef Shark|21|22|1|130:36,32;35,27;32,22;31,19;32,32;30,21#331:0,29;4,28;3,19;2,13;2,25|5567,537,6361
4803|Oracle de Brassenoire|Blackfathom Oracle|21|22|1|148:30,93;31,92;32,91;34,94;32,92;35,94|6995,5952,2143,1481,1491,3413,2567,3415,1486,2271
4789|Voleur Sans-racines|Fallenroot Rogue|21|22|1|148:34,94;33,94;32,93;31,92|5952,1481,1491,3413,2567,3415,1486,2271
3877|Gardien gémissant|Wailing Guardsman|21|22|1|209:|2292,1489,2205,1482,1935,2807,1318,1974,1484,1483,3194
2244|Mage de l'ombre du Syndicat|Syndicate Shadow Mage|21|22|0|267:68,47;65,47;67,50;78,39;82,44;80,42;76,43;81,45|5620,3692
2351|Ours gris|Gray Bear|21|22|0|267:64,9;23,44;19,50;58,15;66,23;64,29;62,36;67,19#36:52,69|3476,3702,3730,11407,11406,2940
2260|Voleur du Syndicat|Syndicate Rogue|21|22|0|267:65,47;66,48;81,47;75,41;81,45;78,44;80,45;82,42|3692
3809|Ours d’Ashenvale|Ashenvale Bear|21|22|0|331:68,86;37,72;67,84;44,64;46,63;55,53;46,65;51,56#17:47,5|3702,3730,11407,3173,11406,2940
3993|Forgeur de machines de la KapitalRisk|Venture Co. Machine Smith|21|22|0|406:63,40;65,40|814,4371,4377,4382
4004|Seigneur des Cisailles|Windshear Overlord|21|22|0|406:74,60;73,60;72,62;72,61;73,62;73,61|7126
3999|Terrassier des Cisailles|Windshear Digger|21|22|0|406:75,59;74,60;73,60;73,59;72,62;73,62|7126
4012|Wyverne Aile-fière|Pridewing Wyvern|21|22|0|406:46,47;46,45;55,42;52,43;52,45;55,43;50,45|5808,5135,5601,5602,5136
3780|Mange-mousse Sombretaillis|Shadethicket Moss Eater|21|23|0|331:47,49;48,47;47,44;48,45;46,48;46,44;45,45;45,46|
7050|Pantin défias|Defias Drone|22|22|0|10:12,75|5376,16882
1259|Enfourneur|Gobbler|22|22|0|11:18,40|3618,1468,5784
7287|Contremaître Silixiz|Foreman Silixiz|22|22|0|17:55,6|
3474|Lakota'mani||22|22|0|17:47,51;45,53;50,53;46,49|5099,4896,5122,5121,5082,5467
7067|Pantin de la KapitalRisk|Venture Co. Drone|22|22|0|17:55,6#40:71,73|5376,16882
7308|Patrouilleur de la KapitalRisk|Venture Co. Patroller|22|22|0|17:55,6|16882
5864|Peau-piquante Swinegart|Swinegart Spearhide|22|22|2|17:41,45|
1398|Boss Galgosh||22|22|4|38:68,66|5109
1210|Chok'sul||22|22|1|38:80,15|2561
2476|Grand crocilisque du loch|Large Loch Crocolisk|22|22|4|38:59,31;60,40|2939,3181,3401,2924,2925
2120|Archimage Ataeric|Archmage Ataeric|22|22|0|130:63,64|3515
1944|Cogneur Poil-Putride|Rot Hide Bruiser|22|22|4|130:65,23|3236,3317
5894|Manifestation d'eau corrompue mineure|Corrupt Minor Manifestation of Water|22|22|0|130:39,44|7812
2283|Régent Ravenclaw|Ravenclaw Regent|22|22|4|130:57,70|
7016|Dame Vespira|Lady Vespira|22|22|4|148:58,21;62,19;59,17;61,22;58,19;60,16;58,22;60,23|
3886|Tranchegriffe le Boucher|Razorclaw the Butcher|22|22|1|209:|1292,6226,6633
10559|Dame Vespia|Lady Vespia|22|22|4|331:14,25;10,14|2996,5445
10644|Hurleur des brumes|Mist Howler|22|22|4|331:27,18;21,37|1015,3301,3402
3943|Ruuzel||22|22|0|331:7,13|5445
6141|Planeur Aile-fière|Pridewing Soarer|22|22|0|406:49,41;43,47;45,35|
5932|Sous-chef Fouettecroc|Taskmaster Whipfang|22|22|2|406:65,54|
203|Mage squelette|Skeletal Mage|22|23|0|10:78,76;82,70;80,71;80,69;80,74;79,73;81,73;77,68|2378,2794
1026|Fourrageur Branchie-bleue|Bluegill Forager|22|23|0|11:25,38;25,40;22,41;14,38;15,35|1468,5784
1010|Paludier Poil-moussu|Mosshide Fenrunner|22|23|0|11:61,58;52,31;45,34;52,28;44,35;43,34;65,55;64,57|2611
1020|Raptor tacheté|Mottled Raptor|22|23|0|11:23,60;24,47;23,50;25,50;29,46;27,47;30,46;29,42|5233,1697,3180,3685
1009|Tisseur de brumes Poil-moussu|Mosshide Mistweaver|22|23|0|11:61,58;61,59;63,69;45,32;46,34;39,34|2611
3238|Orageux|Stormhide|22|23|0|17:44,76;44,74;47,73;44,79;49,79;47,74;47,77|4898,5143,4895,5470,4957,5133,5128
3457|Traqueur Tranchecrin|Razormane Stalker|22|23|0|17:44,82;43,83;44,83;43,82;42,79;45,84|5093
4128|Traqueuse Jappecroc|Hecklefang Stalker|22|23|0|17:48,74;50,76;50,79;47,74;45,77;45,79;46,82;48,81|3301,3402
436|Exhalombre Blackrock|Blackrock Shadowcaster|22|23|1|44:64,54;31,8;64,56;61,57;65,54;64,55;58,49|1261,3014,7906
433|Gnoll Sombrepoil|Shadowhide Gnoll|22|23|0|44:68,55;71,48;71,51;67,51;67,59;64,46;69,41|1075,1962
4463|Invocateur Blackrock|Blackrock Summoner|22|23|0|44:69,78;56,43;22,16;23,12;34,15;31,10;29,7;24,13|3014,16882,7906
3866|Chauve-souris vile|Vile Bat|22|23|1|209:|6298,11390,12223,2292,11391,11392,1489,2205,1935,2807,1318,1974,1484,1483,3194
2354|Ours gris vicieux|Vicious Gray Bear|22|23|0|267:53,48;74,34;46,47;38,38;51,38;66,40;57,40;45,35|3476,3702,3730,11407,3173,11406,2940
3817|Cerf à corne noire|Shadowhorn Stag|22|23|0|331:53,55;45,64;47,61;50,51;54,52;56,55;42,61;42,70|5871,5471,5566,5120
3774|Gangretueur|Felslayer|22|23|0|331:23,63;22,62;21,59;22,61;25,61;29,59;28,63;29,62|3301,3402
3783|Invocateur de pluie Sombretaillis|Shadethicket Raincaller|22|23|0|331:31,72;32,69;33,71;34,66;32,68;33,68;32,67|
4020|Bête de sève|Sap Beast|22|23|0|406:39,10;37,20;38,19;35,19;33,17;35,16;40,13|5582,3670,3673,3674,7296
4014|Concubine Aile-fière|Pridewing Consort|22|23|0|406:45,46;43,38;51,44;56,43;55,42;53,39|5808,5135,5136
4018|Coursier à ramure|Antlered Courser|22|23|0|406:39,7;39,8;40,9;44,23;45,24;45,23;47,38|5585,5871,5471,5566,5120
4815|Claque-pinces Troublefond|Murkshallow Snapclaw|22|23|1|719:|2143,1481,3416,3417,1491,3413,2567,3415,1486,2271
4821|Crustacé luisant|Skittering Crustacean|22|23|1|719:|2674,2675,5569,3417,1491,3413,2567,3415,1486,2271,3010
4818|Murloc Noctant|Blindlight Murloc|22|23|1|719:|2143,1481,3416,3417,1491,3413,2567,3415,1486,2271,1468,5784
4807|Myrmidon de Brassenoire|Blackfathom Myrmidon|22|23|1|719:|5952,2143,1481,3416,3417,1491,3413,2567,3415,1486,2271
521|Lupos||23|23|4|10:33,26;67,27;62,25;38,25;34,30;30,30;25,28;20,26|1015,3301,3402
2090|Ma'ruk Wyrmscale||23|23|4|11:48,75|
7288|Grand contremaître Puzik Gallywix|Grand Foreman Puzik Gallywix|23|23|1|17:55,6|8074
5828|Humar le Fier|Humar the Pridelord|23|23|2|17:62,33|3731,4893,5135,5136
3434|Nak||23|23|0|17:44,83|5073
7307|Sentinelle de la KapitalRisk|Venture Co. Lookout|23|23|0|17:55,6|5373,16882
14281|Jimmy le Saignant|Jimmy the Bleeder|23|23|4|36:59,69|
7052|Patrouilleur défias|Defias Tower Patroller|23|23|0|40:70,75;71,74|16882
616|Cliqueteuse|Chatter|23|23|4|44:47,45;47,33;46,39;50,38;53,48;51,47;47,43;45,37|4428,878,1288,2251,3182,3174,1081
1948|Snarlmane||23|23|4|130:65,25|
3722|Ecorcheuse Fouettebrume|Mystlash Flayer|23|23|0|331:7,24;8,20;7,18;4,14;7,22;7,27;7,31;8,33|5569,3010
10643|Moldaileron|Mugglefin|23|23|4|331:19,43|1468,5784
4073|XT:4||23|23|0|406:64,46|5601,5602,4371,4377,4382
4074|XT:9||23|23|0|406:64,57|4371,4377,4382
1707|Captif défias|Defias Captive|23|23|1|717:|1076,2909
923|Jeune Ravageur noir|Young Black Ravager|23|24|0|10:26,71;44,77;52,76;27,68;52,73;32,62;66,24;56,62|1015,3301,3402
202|Squelette infernal|Skeletal Horror|23|24|0|10:80,62;82,57;22,48;15,48;18,47;14,46;80,60;79,58|1598,2378,2794
1400|Crocilisque des Paluns|Wetlands Crocolisk|23|24|0|11:21,57;19,56;37,28;47,34;25,27;18,53;30,33;25,29|2924,2925,3667,770
1042|Dragonnet rouge|Red Whelp|23|24|0|11:63,49;64,51;64,52;66,53;62,47;60,40;60,41|8499,3176,3175,4402
1032|Limon noir|Black Ooze|23|24|0|11:59,29;56,25;46,25;57,44;43,29;48,25;44,27;28,46|3349,814,11914,11948,3670,3673,3674,7296
1028|Marche-boue Branchie-bleue|Bluegill Muckdweller|23|24|0|11:13,33;11,30;12,34;25,37;17,32;16,36;24,36|1468,5784
1015|Raptor des hautes-terres|Highland Raptor|23|24|0|11:56,29;57,37;57,29;57,33;56,25;51,29;55,26;42,22|1697,3180,3685
1011|Trappeur Poil-moussu|Mosshide Trapper|23|24|0|11:27,35;32,33;28,35;53,27;43,32;41,34;45,32|2611
3249|Grand faucon-tonnerre|Greater Thunderhawk|23|24|0|17:49,76;44,77;47,74;45,78;45,75;48,75;45,81|4897,5164,4957
3458|Prophète Tranchecrin|Razormane Seer|23|24|0|17:43,83;42,82;44,83;41,79;40,81;42,81|5092,5075
6132|Serviteur de Tranchebauge|Razorfen Servitor|23|24|1|17:43,90;44,90|
7051|Pantin défias déformé|Malformed Defias Drone|23|24|0|40:69,74|7923
579|Assassin Sombrepoil|Shadowhide Assassin|23|24|0|44:74,54;75,49|1075,1962
432|Brute Sombrepoil|Shadowhide Brute|23|24|0|44:68,55;75,41;74,41;70,46;75,35;74,37;76,44|1075,1962
4462|Chasseur Blackrock|Blackrock Hunter|23|24|1|44:64,54;62,56;65,58;63,56;64,55;64,56|1445,3014,7906
615|Pisteur Blackrock|Blackrock Tracker|23|24|0|44:21,13;32,10;34,15;32,13;31,11;30,9;31,8;25,9|1445,4375,3014,16882,7906
3873|Officier tourmenté|Tormented Officer|23|24|1|209:|2292,1489,2205,1482,1935,2807,1318,1974,1484,1483,3194
3868|Sanguinaire|Blood Seeker|23|24|1|209:|6298,11390,12223,11391,11392,1489,2205,1935,2807,1318,1974,1483
2384|Lion des montagnes affamé|Starving Mountain Lion|23|24|0|267:56,50;50,31;52,36;52,45;56,44;53,37;50,32;43,35|3496,5810,3731,5135,5136
3924|Chaman Crin-de-Chardon|Thistlefur Shaman|23|24|0|331:36,37;40,36;38,35;36,32;35,33;34,39;34,40;31,43|16743
3781|Forme-bois Sombretaillis|Shadethicket Wood Shaper|23|24|0|331:33,70;34,69;35,67;31,68;34,66;32,66;35,68|
3772|Gangregarde inférieur|Lesser Felguard|23|24|0|331:28,61;25,63;22,60;23,62;28,60;29,62;28,63;26,63|
3743|Guerrier Vile-sylve|Foulweald Warrior|23|24|0|331:57,65;56,65;50,61;49,60;56,62;54,63;53,64;52,60|5066,16743
3926|Guide Crin-de-Chardon|Thistlefur Pathfinder|23|24|0|331:39,37;39,39;36,32;38,31;39,36|16743
3745|Guide Vile-sylve|Foulweald Pathfinder|23|24|0|331:51,61;54,62;54,61|16743
3824|Hurleur Patte-fantôme|Ghostpaw Howler|23|24|0|331:54,72;57,71;57,78;57,77;61,71;59,68;59,74;54,70|1015,3301,3402
3923|Protecteur Crin-de-Chardon|Thistlefur Den Watcher|23|24|0|331:41,35;41,34;41,32;42,34;42,32|16743
3922|Totémique Crin-de-Chardon|Thistlefur Totemic|23|24|0|331:42,35;41,35;41,32;40,33;41,33;43,34|16743
3750|Totémique Vile-sylve|Foulweald Totemic|23|24|0|331:56,65;49,61;54,64;54,65;53,63;58,64;55,62;55,63|16743
3921|Ursa Crin-de-Chardon|Thistlefur Ursa|23|24|0|331:40,32;41,34;41,32;39,31;40,31;40,34;40,33;42,33|16743
3925|Vengeur Crin-de-Chardon|Thistlefur Avenger|23|24|0|331:40,38;38,35;38,34;32,38;37,37;32,39;37,33;32,46|16743
4044|Basilic noirci|Blackened Basilisk|23|24|0|406:36,48;46,44;45,43;37,46;37,51;33,62;35,59;44,39|5675,11384,11385,5601,5602,1701,1702
4013|Chasseresse céleste Aile-fière|Pridewing Skyhunter|23|24|0|406:55,38;55,37;54,36;53,40;53,37;54,38;53,36|5808,5135,5136
4067|Coureur crépusculaire|Twilight Runner|23|24|0|406:31,10;39,12;32,10;33,8;33,10;34,9;35,10;33,11|5584,5135,5136
4025|Embusquée Rougefurie|Bloodfury Ambusher|23|24|0|406:30,63;30,62;31,59;31,61;31,65;32,60|5115,5116
4036|Esprit flamboyant insoumis|Rogue Flame Spirit|23|24|0|406:37,60;44,41;37,49;37,51;35,53;34,60;34,64|5659,16312,5601,5602
4022|Harpie Rougefurie|Bloodfury Harpy|23|24|0|406:31,59;32,59;35,61;35,63;37,49;33,65;30,64;33,64|5115,5116
1706|Prisonnier défias|Defias Prisoner|23|24|1|717:|1076,2909
4822|Crustacé carnassier|Snapping Crustacean|23|24|1|719:|2674,2675,5569,1481,1491,3413,2567,3415,1486,2271,3010
4824|Pêcheur Aku'mai|Aku'mai Fisher|23|24|1|719:|3416,3417,1491,3413,3712,2567,4556,3415,4555,1486,2271
4805|Sorcière des mers de Brassenoire|Blackfathom Sea Witch|23|24|1|719:|6995,5952,1454,3414,2143,1481,3416,3417,1491,3413,2567,3415,1486,2271
4798|Traqueur des ombres Sans-racines|Fallenroot Shadowstalker|23|24|1|719:|5952,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
3917|Elémentaire d’eau souillé|Befouled Water Elemental|23|25|0|331:45,69;48,73;52,69;51,72;51,71;48,70;47,71;49,70|12220,5446,5447,5448,5451,9451,7070
4032|Jeune chimère|Young Chimaera|23|25|0|406:36,65;29,66|6839
14425|Ronge-les-os|Gnawbone|24|24|4|11:30,31;32,30;31,33;35,27;38,30;39,34|2611
1112|Veuve sanguine|Leech Widow|24|24|4|11:47,59|4428,878,1288,2251,3182,3174,1081
5832|Grondeterre|Thunderstomp|24|24|4|17:48,80|5470,5133,5128
3253|Moissonneur silithide|Silithid Harvester|24|24|4|17:43,70|5138,7119,5268,5269
3473|Owatanka||24|24|0|17:49,61;49,59;46,63;44,62|5102,4895,5470,5133,5128
7056|Sentinelle défias de la tour|Defias Tower Sentry|24|24|0|40:71,74|16882
711|Ardo Crassepatte|Ardo Dirtpaw|24|24|0|44:12,17|1212
345|Fouailleventre|Bellygrub|24|24|0|44:11,49|3631,2296,723,3403,2677,3172,2295
335|Roussi|Singe|24|24|1|44:65,56|3176,12562,3175,4402
486|Tharil'zun||24|24|1|44:64,59|1260,7906
1947|Thule Ravenclaw||24|24|1|130:66,24|3623
3887|Baron d'Argelaine|Baron Silverlaine|24|24|1|209:|6321,6323
4278|Commandant Springvale|Commander Springvale|24|24|1|209:|3191,6320
3859|Enragé d'Ombrecroc|Shadowfang Ragetooth|24|24|1|209:|2292,1489,2205,1482,1935,2807,1318,1974,1484,1483,3194
3863|Horreur Lupine|Lupine Horror|24|24|1|209:|2292,1489,2205,1482,1935,2807,1015,1318,1974,1484,1483,3194,3301,3402
4279|Odo l'Aveugle|Odo the Blindwatcher|24|24|1|209:|6318,6319
2427|Geôlier Eston|Jailor Eston|24|24|0|267:80,42|3467,3692
2428|Geôlier Marlgen|Jailor Marlgen|24|24|0|267:79,41|3499,3692
14279|Insinueuse|Creepthess|24|24|4|267:39,58|3477,4428,878,1288,2251,3182,1081
3664|Ilkrud Magthrull||24|24|0|331:25,61|5533
4250|Chien de meute galak|Galak Packhound|24|24|0|400:23,37;23,38|3301,3402
5931|Contremaître Rigger|Foreman Rigger|24|24|2|406:67,52|
1696|Targorr le Terrifiant|Targorr the Dread|24|24|1|717:|3630
6221|Lépreux perturbé|Addled Leper|24|25|0|1:23,40;24,39;23,39;22,39|9279,5568
6210|Pilleur des Basses-cavernes|Caverndeep Pillager|24|25|1|1:22,34;21,37;19,39|9279,9308,5568,9488,9486
215|Cours-la-nuit défias|Defias Night Runner|24|25|0|10:21,66;25,69;22,71;24,64;50,74;49,70;56,73;51,75|7997,2794
531|Démon squelette|Skeletal Fiend|24|25|0|10:16,43;22,47;24,44;22,43;23,43;16,47;17,47;21,46|1598,2378,2794
3|Dévoreur|Flesh Eater|24|25|0|10:25,38;25,36;26,34;24,39;23,39;22,33;22,38;22,37|884,1129,5529,887,2794
930|Jeune veuve noire|Black Widow Hatchling|24|25|0|10:26,47;35,32;30,48;29,53;34,34;33,48;31,57;28,41|7267,1130,4428,878,1288,2251,3182,3174,1081
218|Pilleur de tombes|Grave Robber|24|25|0|10:15,44;15,45|7997,2794
628|Ravageur noir|Black Ravager|24|25|0|10:49,62;70,35;66,29;64,28;64,26;67,32;68,33;60,58|1015,3301,3402
1012|Brute Poil-moussu|Mosshide Brute|24|25|0|11:35,28;39,27;41,27;31,29;32,30;37,30;38,29;37,29|2611
1043|Dragonnet égaré|Lost Whelp|24|25|0|11:66,49;64,48;65,49;67,49;67,52;62,42;63,37;62,46|3176,3175,4402
1016|Flagellant des hautes-terres|Highland Lashtail|24|25|0|11:61,22;56,27;39,23;57,25;40,21;31,21;30,21|1697,3180,3685
1027|Guerrier Branchie-bleue|Bluegill Warrior|24|25|0|11:14,21;16,21;14,22;12,29;13,28;17,30;16,31;19,33|2143,1468,5784
1021|Hurleur tacheté|Mottled Screecher|24|25|0|11:24,53;23,56;30,44;24,60;26,49;29,45|5233,1697,3180,3685
1031|Limon cramoisi|Crimson Ooze|24|25|0|11:44,25;45,24;45,25;44,24|3349,5529,814,3670,3673,3674,7296
1040|Rampant des tourbières|Fen Creeper|24|25|0|11:27,37;25,36;19,28;26,32;27,39;55,37;36,33;37,33|
3459|Frénétique Tranchecrin|Razormane Warfrenzy|24|25|0|17:41,79;42,78;42,79;42,82;41,80;41,81;42,81|5094,5075
3235|Grand kodo des Tarides|Greater Barrens Kodo|24|25|0|17:47,66|4896,5122,5121,5082,5467
435|Champion Blackrock|Blackrock Champion|24|25|0|44:22,16;22,10;31,8;25,10;25,9;23,12;23,15;24,14|3014,7906,9355
4464|Gladiateur Blackrock|Blackrock Gladiator|24|25|1|44:64,56;62,56;65,57;63,55|3014,7906
568|Guerrier Sombrepoil|Shadowhide Warrior|24|25|0|44:70,30;79,54;71,37;77,47;71,38;71,31;71,42;73,39|1075,1962,16882
819|Serviteur d’Ilgalar|Servant of Ilgalar|24|25|0|44:74,50;74,49;74,48;75,49;75,48;74,47|3722,3723,3724,3725
2529|Fils d'Arugal|Son of Arugal|24|25|1|130:45,80;38,15;47,34#209:|2292,1489,2205,1482,1935,2807,1318,1974,1484,1483,3194
2349|Rampemousse géante|Giant Moss Creeper|24|25|0|267:90,41;73,63;90,40;24,51;70,28;26,35;68,37;40,60#36:15,82;26,66;15,86;27,84;25,80;22,73;23,82;28,74|3477,4428,878,1288,2251,3182,1081
3748|Chaman Vile-sylve|Foulweald Shaman|24|25|0|331:54,62;50,60|16743
3820|Crache-venin Ronce-sauvage|Wildthorn Venomspitter|24|25|0|331:64,55;58,71;57,78;67,50;69,49;58,73;56,76;66,63|4428,878,1288,2251,3182,3174,1081
3746|Protecteur Vile-sylve|Foulweald Den Watcher|24|25|0|331:55,62;50,60;54,61|16743
3749|Ursa Vile-sylve|Foulweald Ursa|24|25|0|331:55,62;50,60;54,62|16743
4096|Chasse-vent galak|Galak Windchaser|24|25|0|400:49,42;44,38;42,41;39,38;43,38;47,41;44,37;45,42|
4094|Eclaireur galak|Galak Scout|24|25|0|400:50,41;41,37;40,35;40,36;41,36;43,38;44,38;46,44|
4021|Bête de sève corrosive|Corrosive Sap Beast|24|25|0|406:34,11;38,18;39,19;34,20;34,13;33,18|3670,3673,3674,7296
4016|Dragon-faë|Fey Dragon|24|25|0|406:40,14;37,21|5583,3176,3175,4402
4034|Esprit rocheux enragé|Enraged Stone Spirit|24|25|0|406:30,66;34,65|5741,4784
4019|Grand coursier|Great Courser|24|25|0|406:39,6;40,12;36,16;40,10|5585,5871,5471,5566,5120
4026|Imploratrice céleste Rougefurie|Bloodfury Windcaller|24|25|0|406:31,63;30,64;34,62;33,60;35,64;33,59;35,63;33,63|5115,5116
4037|Ravageur ardent|Burning Ravager|24|25|0|406:29,63;31,67;35,66;28,66;30,65|5659,16312
4511|Agam'ar||24|25|1|491:|3403,2677,3172,2295,1727,1975,1978,2549
4435|Guerrier de Tranchebauge|Razorfen Warrior|24|25|1|491:|1975,1978,2549,5825
1711|Détenu défias|Defias Convict|24|25|1|717:|1076,2909
1708|Interné défias|Defias Inmate|24|25|1|717:|1076,2909
4809|Acolyte du crépuscule|Twilight Acolyte|24|25|1|719:|6914,5879,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
4827|Battraileron du bassin profond|Deep Pool Threshfin|24|25|1|719:|5516,2608,1454,2143,1481,3416,3417,3413,2567,3415,1486
4812|Erudit du crépuscule|Twilight Loreseeker|24|25|1|719:|5879,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
4799|Invocateur infernal Sans-racines|Fallenroot Hellcaller|24|25|1|719:|5952,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
6213|Envahisseur irradié|Irradiated Invader|24|26|1|1:21,36;22,34;20,37;19,39;22,32|9279,9308,9487,9490,9488,9486,9309
14424|Bas-boueux|Mirelow|25|25|4|11:24,29;21,35;24,26;27,30;19,24;20,28;17,31;18,30|2997
5834|Azzere la lame céleste|Azzere the Skyblade|25|25|4|17:45,64|11370
3435|Lok Plaie-des-orcs|Lok Orcbane|25|25|0|17:40,81|5072
7310|Pantin muté de la KapitalRisk|Mutated Venture Co. Drone|25|25|0|17:55,6|5375,16882
3472|Washte Pawne||25|25|0|17:43,81;45,79;45,75;47,80|5103
14357|Batteur lacustre|Lake Thresher|25|25|1|44:43,55;37,64|5516,2608
518|Couineur|Yowler|25|25|0|44:23,21|3614,1212
14273|Rochecoeur|Boulderheart|25|25|4|44:84,67|5741
3872|Capitaine Ligemort|Deathsworn Captain|25|25|2|209:|6641,6642
4274|Fenrus le Dévoreur|Fenrus the Devourer|25|25|1|209:|3230,6340,1015,3301,3402
3927|Maître-loup Nandos|Wolf Master Nandos|25|25|1|209:|3748,6314
14682|Sectionneur|Sever|25|25|1|209:|23171,23173,1484
10641|Brise-branche|Branch Snapper|25|25|4|331:47,44|
3987|Dal Griffesang|Dal Bloodclaw|25|25|0|331:38,35|5544
10639|Joufflu le croquant|Rorgish Jowl|25|25|4|331:36,37|
4015|Patriarche Aile-fière|Pridewing Patriarch|25|25|4|406:54,36;48,47|5808,5135,5601,5602,5136
4520|Géomancienne de Tranchebauge|Razorfen Geomancer|25|25|1|491:|1976,2039,1727,1975,1978,2549,5825
4831|Dame Sarevess|Lady Sarevess|25|25|1|719:|888,3078,11121,5952,7072
4887|Ghamoo-ra||25|25|1|719:|6907,6908,3712,4556,4555
4819|Marche-boue Noctant|Blindlight Muckdweller|25|25|1|719:|1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271,1468,5784
4820|Oracle Noctant|Blindlight Oracle|25|25|1|719:|1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271,1468,5784
7849|Système d'alarme mobile|Mobile Alert System|25|25|0|721:|10299,4405,4377,4382
6208|Envahisseur des Basses-cavernes|Caverndeep Invader|25|26|1|1:22,33;22,34;18,39|9279,9308,9487,9490,9488,9486,9309
1258|Dogue Ravageur noir|Black Ravager Mastiff|25|26|0|10:70,38;67,35;66,33;66,31;63,28;51,61|1015,3301,3402
909|Lame nocturne défias|Defias Night Blade|25|26|0|10:23,72;22,73;23,73;48,75;22,72;23,74;51,77;24,71|7997,2794
889|Ogre Brisepoing|Splinter Fist Ogre|25|26|0|10:39,70;40,72;40,70;38,72;38,73;39,75;39,76|2794
948|Pourri|Rotted One|25|26|0|10:22,36;26,34;22,34;24,38;22,38;25,34;25,38|7307,884,1129,5529,887,2794
949|Solitaire putride|Carrion Recluse|25|26|0|10:21,46;21,39;19,42;17,40;18,44;23,37|7267,1130,4428,878,1288,2251,3182,3174,1081
2089|Crocilisque géant des Paluns|Giant Wetlands Crocolisk|25|26|0|11:18,27;18,29;22,21;22,20;17,27;17,24;15,29;21,24|3348,2924,2925,3667,770
1069|Dragonnet cramoisi|Crimson Whelp|25|26|0|11:64,35;70,50;63,37;62,41;67,44;66,45;65,43;68,46|8499,3179,3175,4402
1017|Faucheur des hautes-terres|Highland Scytheclaw|25|26|0|11:59,22;60,21;38,23;57,28;38,20;38,19;33,18|1697,3180,3685
1022|Faucheur tacheté|Mottled Scytheclaw|25|26|0|11:32,47;31,49;36,44;31,48;34,44;35,51;34,46;34,51|1180,3012,5233,1697,3180,3685
1033|Limon monstrueux|Monstrous Ooze|25|26|0|11:69,53;45,25;70,47;68,47;65,37;44,25|3349,814,3670,3673,3674,7296
1013|Mystique Poil-moussu|Mosshide Mystic|25|26|0|11:35,28;38,30;40,27;31,33;31,30|2611
1029|Oracle Branchie-bleue|Bluegill Oracle|25|26|0|11:17,31;16,30|1468,5784
1041|Seigneur des tourbières|Fen Lord|25|26|0|11:30,28;32,27;31,22|
3237|Kodo laineux|Wooly Kodo|25|26|0|17:47,67|4896,5122,5121,5082,5467
431|Pourfendeur Sombrepoil|Shadowhide Slayer|25|26|0|44:79,58;78,59;77,55;69,36;76,49;75,49;72,55|5375,1075,1962
429|Tisseur d'ombre Sombrepoil|Shadowhide Darkweaver|25|26|0|44:75,50;74,49;76,56;77,53;76,55;80,48;75,45;71,35|1075,1962
2356|Vieil ours gris|Elder Gray Bear|25|26|0|267:90,43;80,36;85,33;88,42;75,67;68,61;43,63;74,60#36:23,76;25,65;25,77;28,69;27,82;22,73;25,81;15,83|955,3476,3702,3730,11407,4957,3173,11406,2940
3782|Bouge-pierre Sombretaillis|Shadethicket Stone Mover|25|26|0|331:65,80;85,69;67,84;71,56;81,64;78,61;82,64;66,80|16747
3762|Lige de la corruption Gangremusc|Felmusk Felsworn|25|26|0|331:69,54;66,55;67,55;67,52;66,54;68,54|7128,5481
3758|Satyre Gangremusc|Felmusk Satyr|25|26|0|331:69,53;67,53;66,53;66,52;67,56|7128,5481
3810|Vieil ours d’Ashenvale|Elder Ashenvale Bear|25|26|0|331:61,64;63,62;70,51;65,59;62,67;72,52;71,55|3702,3730,11407,3173,11406,2940
10758|Bandit du Totem sinistre|Grimtotem Bandit|25|26|0|400:33,27;37,32;38,35;33,38;34,39;38,36|
4093|Querelleur galak|Galak Wrangler|25|26|0|400:45,40;43,40;41,37;40,37;48,41;44,39;44,41|
4117|Serpent-nuage|Cloud Serpent|25|26|0|400:37,55;37,42;35,28;41,58;40,50|
4112|Vermine Mufle-de-gravier|Gravelsnout Vermin|25|26|0|400:34,27;46,59;34,32;38,55|
4028|Ancien calciné|Charred Ancient|25|26|0|406:33,63;33,73;34,68|5664,11151
4042|Basilic flamboyant|Singed Basilisk|25|26|0|406:28,64;36,64;36,66;33,67;29,67|5675,11384,11385,1701,1702
4024|Tueuse Rougefurie|Bloodfury Slayer|25|26|0|406:27,70;29,71;30,70;30,67;37,70;37,66;35,70|5115,5116
4023|Volplume Rougefurie|Bloodfury Roguefeather|25|26|0|406:29,70;30,69;29,69;36,70;37,68;35,69;35,67;35,68|5115,5116
4514|Agam'ar enragé|Raging Agam'ar|25|26|1|491:|3403,2677,3172,2295,1976,2039,1727,1975,1978,2549
4530|Dresseur de Tranchebauge|Razorfen Handler|25|26|1|491:|1976,2039,1727,1975,1978,2549,5825
4436|Garde-huran de Tranchebauge|Razorfen Quilguard|25|26|1|491:|1976,2039,1727,1975,1978,2549,5825
4437|Gardien de Tranchebauge|Razorfen Warden|25|26|1|491:|1976,2039,1727,1975,1978,2549,5825
1715|Insurgé défias|Defias Insurgent|25|26|1|717:|1076,2909
4811|Aquamancien du crépuscule|Twilight Aquamancer|25|26|1|719:|5879,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
4823|Crustacé épineux|Barbed Crustacean|25|26|1|719:|2674,2675,1454,3414,2143,5569,1481,3416,3417,1491,3413,2567,3415,1486,2271,3010
4810|Ravageur du crépuscule|Twilight Reaver|25|26|1|719:|5879,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
6329|Pilleur irradié|Irradiated Pillager|25|26|1|721:|4406,10298,9261,10299,4405,9308,9487,9490,5568,9488,9486,4371,9309,4377,4382
10760|Géomancien du Totem sinistre|Grimtotem Geomancer|25|27|0|400:34,37;34,38;32,30;37,32;38,27;34,39;33,28;35,31|5773
4031|Petite chimère|Fledgling Chimaera|25|27|0|406:33,73;31,73;35,71|6839
6206|Creuseur des Basses-cavernes|Caverndeep Burrower|25|27|1|721:|4406,10298,5740,9261,10299,9509,9485,4405,9308,9487,9490,5568,9488,9486,4371,9309,4377,4382
6207|Embusqué des Basses-cavernes|Caverndeep Ambusher|25|27|0|721:|10298,5740,9261,10299,9509,9485,9308,9487,9490,5568,9488,9486,4371,9309,4377,4382
6209|Pillard des Basses-Cavernes|Caverndeep Looter|26|26|1|1:19,39;23,32;19,37;21,32|9279,9308
6231|Techbot||26|26|1|1:20,32|9277,9444,9487,9488,9486,4371,9309,4377,4382
511|Goule folle|Insane Ghoul|26|26|0|10:81,72|1946,887,2794
5859|Hagg Taurenbane||26|26|2|17:43,83;44,83;42,79|
7053|Klaven Mortwake||26|26|1|40:71,74|
462|Vultros||26|26|4|40:51,44;37,63;46,60;45,44;51,24;63,57;66,59;62,74|555,729,11416,5114,5115,5116
334|Gath'Ilzogg||26|26|1|44:65,56|3633,7906
703|Lieutenant Fangore||26|26|0|44:75,37|3632,1075,1962
397|Morganth||26|26|1|44:75,49|3617
947|Rohh le silencieux|Rohh the Silent|26|26|4|44:70,40;79,59;77,56;76,56;79,51;74,36;71,38;71,30|1075,1962
4275|Archimage Arugal|Archmage Arugal|26|26|1|209:|6220,6324,6392,5442
10000|Arugal||26|26|1|209:|5442
3773|Akkrilus||26|26|4|331:26,64|
10617|Messager galak|Galak Messenger|26|26|0|400:39,33|12564
12579|Déchiqueteuse Rougefurie|Bloodfury Ripper|26|26|1|406:31,62|16190,5116
1720|Bruegal Ironknuckle||26|26|2|717:|2941,2942,3228,2909
1663|Dextren Ward||26|26|1|717:|3628,2909
6243|Gelihast||26|26|1|719:|1470,6905,6906,1468,5784
12902|Lorgus Jett||26|26|1|719:|1454,3414,3416,3417,3413,3415,1486,2271
4830|Vieux Serra'kis|Old Serra'kis|26|26|1|719:|6901,6902,6904,5516,2608
910|Enchanteur défias|Defias Enchanter|26|27|0|10:49,78;21,73;21,72;50,77;24,72|1077,5773,7997,2794
210|Mâcheur d'os|Bone Chewer|26|27|0|10:26,28;19,26;18,28;22,36;23,34;24,38;23,33;25,35|884,1129,5529,887,2794
787|Soigneur squelette|Skeletal Healer|26|27|0|10:17,37;17,35;17,29;15,34;14,36;17,38;17,39;16,41|2378,2794
891|Tisseur de flamme Brisepoing|Splinter Fist Fire Weaver|26|27|0|10:36,75;35,71;36,71;40,74;39,75;40,75;35,72|2794
898|Worgen Plaie-de-nuit|Nightbane Worgen|26|27|0|10:61,33;63,55;59,27;59,50;61,53;60,32;66,37;58,30|6844,2794
1044|Dragonnet crache-flammes|Flamesnorting Whelp|26|27|0|11:71,49;70,45;63,37;64,38;72,47;68,43;67,43;64,32|8499,3179,3175,4402
1034|Ecumeur Dragonmaw|Dragonmaw Raider|26|27|0|11:46,45;45,43;47,47;50,48;42,46;43,40;44,45|3337,7131
1157|Marin maudit|Cursed Sailor|26|27|0|11:15,24;14,31;14,30;14,29|
1023|Tranchegueule tacheté|Mottled Razormaw|26|27|0|11:34,48;35,46;35,47;33,47;34,50;34,46;33,48|5233,1697,1696,3685
2348|Ancienne Rampemousse|Elder Moss Creeper|26|27|0|267:66,78;64,66;64,74;61,55;75,68;60,53;61,63;67,73|3477,878,1288,2251,3182,1081
2372|Gnoll Fangemufle|Mudsnout Gnoll|26|27|0|267:64,65;65,66;65,63;63,63;64,63;62,63;62,62;64,60|
3919|Ancien flétri|Withered Ancient|26|27|0|331:59,42;58,34;55,33;58,42;54,34;55,34;55,35|5475,11151
3784|Arracheur Sombretaillis|Shadethicket Bark Ripper|26|27|0|331:66,82;85,68;66,80;86,69;67,81;70,58;75,46;81,73|
3815|Dragon frappeur|Blink Dragon|26|27|0|331:62,51;50,46|3179,3175,4402
3771|Invocateur infernal Mornecoeur|Bleakheart Hellcaller|26|27|0|331:82,52;83,50;82,50;80,49;81,51;80,51;80,50|7128,5481
3765|Satyre Mornecoeur|Bleakheart Satyr|26|27|0|331:80,50;81,51;82,48|7128,5481
3763|Traqueur des ténèbres Gangremusc|Felmusk Shadowstalker|26|27|0|331:68,54;67,57;67,56;66,56;66,54|7128,5481
3818|Vieux cerf à corne noire|Elder Shadowhorn Stag|26|27|0|331:66,67;56,33;59,36;62,44;58,42;68,64;73,56;76,52|5471,5566,5119,5120
3759|Voleur Gangremusc|Felmusk Rogue|26|27|0|331:66,53;67,55;67,54;67,57|7128,5481
4248|Hyène Pestepoil|Pesterhide Hyena|26|27|0|400:32,47;36,30;28,30;30,51;28,29;36,50;25,45;25,37|3301,3402
4111|Kobold Mufle-de-gravier|Gravelsnout Kobold|26|27|0|400:32,48;38,55;35,51;24,22;25,28;39,52;27,40;22,38|
4097|Légion-tempête galak|Galak Stormer|26|27|0|400:43,31;18,21;19,21;20,22;23,25;42,34;42,32|
4099|Maraudeur galak|Galak Marauder|26|27|0|400:42,32;44,31;18,20;19,23;23,25;45,33#17:49,96|1493
10759|Marteleur du Totem sinistre|Grimtotem Stomper|26|27|0|400:34,38;34,37;33,27;38,27;35,32;35,39;35,31|
4038|Destructeur ardent|Burning Destroyer|26|27|0|406:33,75;33,74;31,74;30,74;32,71;36,72;35,74|5659,16312
4017|Dragon-faë rusé|Wily Fey Dragon|26|27|0|406:33,13|5583,3179,3175,4402
4035|Esprit rocheux furieux|Furious Stone Spirit|26|27|0|406:32,73|5741,4784
4027|Sorcière des tempêtes Rougefurie|Bloodfury Storm Witch|26|27|0|406:27,69;27,70;28,67;29,68;30,69;28,70;37,69|5115,5116
4517|Prêtre de la Tête de Mort|Death's Head Priest|26|27|1|491:|4438,1976,1727,1975,1978,2549,5825
4814|Elémentaliste du crépuscule|Twilight Elementalist|26|27|1|719:|5879,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
4825|Gueule d'acier d'Aku'mai|Aku'mai Snapjaw|26|27|1|719:|1454,3414,1481,3416,3417,1491,3413,3712,2567,4556,3415,4555,1486,2271
4813|Ombremage du crépuscule|Twilight Shadowmage|26|27|1|719:|5879,1454,3414,1481,3416,3417,1491,3413,2567,3415,1486,2271
4118|Serpent-nuage venimeux|Venomous Cloud Serpent|26|28|0|400:28,42;37,55;26,26;29,28;38,54;33,53;23,24;51,56|
574|Naraxis||27|27|4|10:86,48|1130,878,1288,2251,3182,3174,1081
1014|Alpha Poil-moussu|Mosshide Alpha|27|27|0|11:35,27;38,29;40,27;31,33;31,30|2611
1057|Gardien Dragonmaw|Dragonmaw Bonewarder|27|27|0|11:45,45;46,47;46,42;48,47;52,48;51,51;49,47;49,46|6930,3337,7131
5827|Brontus||27|27|2|17:47,73|4896,5122,5121,5082,5467
3476|Isha Awak||27|27|0|17:64,54|5104,5516,2608
584|Kazon||27|27|4|44:30,8;32,12;31,9;30,7|
14280|Gros Samras|Big Samras|27|27|4|267:86,40|3476,3702,3730,11407,11406,2940
10640|Chênepatte|Oakpaw|27|27|4|331:56,63|
10642|Eck'alom||27|27|4|331:53,70|5446,5447,5448,5451,9451,7070
12759|Maréen|Tideress|27|27|0|331:46,71|16408,12220,5446,5447,5448,5451,9451,7070
14426|Harb Foulmountain||27|27|4|400:33,27|
5928|Ailes du désespoir|Sorrow Wing|27|27|2|406:49,36|5808,5137,5136
4202|Gerenzo Wrenchwhistle||27|27|0|406:64,40|5736
4541|Sang d'Agamaggan|Blood of Agamaggan|27|27|1|491:|3670,3673,3674,7296
1666|Kam Deepfury||27|27|1|717:|2280,3640
4832|Seigneur du crépuscule Kelris|Twilight Lord Kelris|27|27|1|719:|1155,5881,6903
1110|Ecumeur squelette|Skeletal Raider|27|28|0|10:17,31;17,35;17,33;15,37;14,36;16,39;16,38;18,37|2378,2794
604|Répandeur de peste|Plague Spreader|27|28|0|10:23,28;22,28;24,34;17,33;24,35;25,31;23,35;26,34|884,1129,5529,887,2794
892|Sous-chef Brisepoing|Splinter Fist Taskmaster|27|28|0|10:34,68;40,75;37,72;34,70|2794
533|Tisseur d'ombre Plaie-de-nuit|Nightbane Shadow Weaver|27|28|0|10:65,69;65,75;64,66;63,70;63,44;60,53;58,29;57,30|6844,2794
1035|Arpenteur Dragonmaw|Dragonmaw Swamprunner|27|28|0|11:46,46;50,47;46,47;54,54;48,49;38,46;50,45;50,44|1955,3337,7131
6523|Fusilier Sombrefer|Dark Iron Rifleman|27|28|1|11:49,16;49,18|
1051|Nain Sombrefer|Dark Iron Dwarf|27|28|1|11:60,23;48,18;48,17;62,30;62,29;60,25;60,24|11150
1158|Soldat de marine maudit|Cursed Marine|27|28|0|11:15,23;16,24;14,25;15,24;13,30;14,24;14,31|
1018|Tranchegueule des hautes-terres|Highland Razormaw|27|28|0|11:71,29;69,32;69,28;68,31;65,30;65,29;68,36;33,15|1697,1696,3685
2373|Chaman Fangemufle|Mudsnout Shaman|27|28|0|267:63,64;63,62;64,62;64,59;65,60;66,61|
2385|Lion des montagnes farouche|Feral Mountain Lion|27|28|0|267:65,73;65,69;66,75;68,81;57,60;66,74;61,67;61,51|3496,5810,3731,5137,5136
3825|Alpha Patte-fantôme|Ghostpaw Alpha|27|28|0|331:68,69;63,45;69,64;68,65;72,58;61,46;68,70;73,55|1015,3301,3402
3834|Ancien fou|Crazed Ancient|27|28|0|331:62,43;57,31;59,36;60,39;62,45;58,39;58,41|5475,11151
3767|Entourloupeur Mornecoeur|Bleakheart Trickster|27|28|0|331:80,50;81,49;82,50;81,50;82,49;82,52|7128,5481
3932|Garde de Dent-rouge|Bloodtooth Guard|27|28|0|331:56,76;55,76;56,75;55,79;54,80|
3770|Traqueur des ténèbres Mornecoeur|Bleakheart Shadowstalker|27|28|0|331:81,49;82,49;81,50;81,52;81,48|7128,5481
10757|Elémentaire bouillonnant|Boiling Elemental|27|28|0|400:36,35;37,39;34,34;33,35;37,38;35,34;34,33;37,35|9451,7070
4114|Fourrageur Mufle-de-gravier|Gravelsnout Forager|27|28|0|400:59,59;31,52;29,29;36,46;25,47|
4095|Marteleur galak|Galak Mauler|27|28|0|400:44,33;42,32;17,19;17,23;43,33;44,34;43,31|
4124|Puma des pointes|Needles Cougar|27|28|0|400:60,48;64,48;36,48;34,54;39,50;14,27;60,59;20,39|5137,5136
4029|Ancien noirci|Blackened Ancient|27|28|0|406:31,65;33,63|5664,11151
4041|Basilic cramoisi|Scorched Basilisk|27|28|0|406:37,73;33,72;31,72;32,69;31,70;30,72;36,71;34,74|5675,11384,11385,1701,1702
4516|Adepte de la Tête de Mort|Death's Head Adept|27|28|1|491:|776,1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
4442|Défenseur de Tranchebauge|Razorfen Defender|27|28|1|491:|9036,776,1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
4523|Tremble-terre de Tranchebauge|Razorfen Groundshaker|27|28|1|491:|1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
6218|Gelée irradiée|Irradiated Slime|27|28|1|721:|5568,9309,3670,3673,3674,7296
6211|Ravageur des Basses-cavernes|Caverndeep Reaver|27|28|1|721:|10298,9261,10299,9489,9509,9485,9308,9487,9490,5568,9488,9486,9309
4119|Ancien serpent-nuage|Elder Cloud Serpent|27|29|0|400:60,46;52,44;56,51;59,52;56,49;57,50;19,39;18,37|
14278|Ro'Bark||28|28|4|267:66,60|
14427|Gibblesnik||28|28|4|400:56,50|5842
10761|Ravageur du Totem sinistre|Grimtotem Reaver|28|28|0|400:33,38;35,37;35,38;33,39;34,40;38,26|
6167|Matriarche chimère|Chimaera Matriarch|28|28|0|406:34,75|6840
5930|Sœur Riven|Sister Riven|28|28|2|406:30,69|5116
4512|Agam'ar décrépi|Rotting Agam'ar|28|28|1|491:|3403,2677,3172,2295,776,1488,4438,2264,2039,1727,1975,1978,2549
6168|Roogug||28|28|1|491:|6841,4957,1488,4438,2264,1976,1727,5825
1717|Hamhock||28|28|1|717:|
4829|Aku'mai||28|28|1|719:|6909,6910,6911,5569,3010
785|Gardien squelette|Skeletal Warder|28|29|0|10:18,36;14,34;14,33;17,28;17,29;16,33;16,35;18,35|2378,2794
1251|Incendiaire Brisepoing|Splinter Fist Firemonger|28|29|0|10:36,77;38,80;37,82;37,84;34,72;34,74|2794
570|Mangeur de cervelle|Brain Eater|28|29|0|10:24,30;22,30;21,29;22,28;21,30;26,29;27,34;25,30|884,1129,5529,887,2794
205|Messager Plaie-de-nuit|Nightbane Dark Runner|28|29|0|10:65,68;67,78;62,75;65,66;68,46;60,42;60,45|6844,2794
1036|Centurion Dragonmaw|Dragonmaw Centurion|28|29|0|11:50,46;49,46;53,54;54,55|3337,7131
1418|Ecumeur Branchie-bleue|Bluegill Raider|28|29|0|11:26,17;26,16;22,18;31,12;11,66;10,71;14,64;9,70#45:23,95;22,97|2702,2143,1468
1052|Saboteur Sombrefer|Dark Iron Saboteur|28|29|1|11:60,24;62,27;63,27;48,18;48,16;48,15;46,16;47,16|11150
1038|Veilleur des ombres Dragonmaw|Dragonmaw Shadowwarder|28|29|0|11:50,46;54,54;53,53;53,54;53,55|6930,3337,7131
2337|Anéantisseur de la Rive noire|Dark Strand Voidcaller|28|29|0|148:56,26|5773
2374|Marche-boue Aileron déchiré|Torn Fin Muckdweller|28|29|0|267:27,74;25,73;23,73;25,65;23,65;25,70;25,71;30,74|3510,3716,11152,5785
2368|Rôdeur du rivage Daguéchine|Daggerspine Shorestalker|28|29|0|267:64,82;61,77;67,87;67,86;66,82;66,83;62,76;60,76|3509,7072
3801|Dormeur austère|Severed Sleeper|28|29|0|331:75,73;75,74;76,76|
3799|Druide austère|Severed Druid|28|29|0|331:75,76;77,76;76,76;77,75;78,75;76,75;75,74;76,73|
3789|Déchireur Frayeloup|Terrowulf Fleshripper|28|29|0|331:50,40;50,39;53,34;53,33;53,38;53,36;51,38|
3755|Lige de la corruption de Xavian|Xavian Felsworn|28|29|0|331:78,47;78,43;78,42;77,45;80,47;78,46;79,47|7128,5481
3821|Rôdeuse Ronce-sauvage|Wildthorn Lurker|28|29|0|331:93,56;93,54;91,55;89,45;84,49;92,46;91,66;83,49|878,1288,2251,3182,3174,1081
3754|Traître de Xavian|Xavian Betrayer|28|29|0|331:78,46|7128,5481
4109|Concubine de Haut-perchoir|Highperch Consort|28|29|0|400:12,36;16,42;12,32;11,37;12,37|5809,5137,5136
4120|Eboulide fulminant|Thundering Boulderkin|28|29|0|400:64,49;13,14;10,16;11,22;63,60;65,62;12,14;12,18|5741,4784
10756|Elémentaire brûlant|Scalding Elemental|28|29|0|400:37,39;35,36;35,35;35,34;38,38|9451,7070
4249|Grogneuse Pestepoil|Pesterhide Snarler|28|29|0|400:12,16;63,46;13,13;67,51;54,55;68,58;62,60;20,33|3301,3402
4100|Harpie hurlante|Screeching Harpy|28|29|0|400:26,55;27,56;26,52;28,49;28,48|5116
4113|Mineur Mufle-de-gravier|Gravelsnout Digger|28|29|0|400:12,21;12,14;60,58|5842
4107|Wyverne de Haut-perchoir|Highperch Wyvern|28|29|0|400:18,43;11,39;13,38;18,41;12,33;10,34;14,39;9,36|5809,5137,5136
4515|Acolyte de la Tête de Mort|Death's Head Acolyte|28|29|1|491:|776,1488,4438,2264,2039,1727,1975,1978,2549,5825
4522|Lève-poussière de Tranchebauge|Razorfen Dustweaver|28|29|1|491:|776,4438,2264,1976,2039,1727,1975,1978,2549,5825
4531|Maître des bêtes de Tranchebauge|Razorfen Beast Trainer|28|29|1|491:|776,1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
4519|Prophète de la Tête de Mort|Death's Head Seer|28|29|1|491:|776,1488,4438,2264,1976,2039,1727,1975,2549,5825
6035|Traqueur de Tranchebauge|Razorfen Stalker|28|29|1|491:|776,1488,4438,2264,2039,1727,1975,1978,2549,5825
7603|Assistant lépreux|Leprous Assistant|28|29|0|721:|4406,10298,4405,4371,9309,4377,4382
6223|Défenseur lépreux|Leprous Defender|28|29|1|721:|9261,9491,9489,9508,9509,9485,9308,9487,9490,5568,9488,9486,9309
6220|Horreur irradiée|Irradiated Horror|28|29|1|721:|9261,9451,9491,9489,9508,9509,9485,9487,9490,5568,9488,9486,9309,7070
6219|Rôdeur corrosif|Corrosive Lurker|28|29|1|721:|5568,9309,3670,3673,3674,7296
6233|Sentinelle mécanique|Mechanized Sentry|28|29|1|721:|9510,9327,9491,9489,9508,9509,9485,9487,9490,5568,9488,9486,4371,9309,4377,4382
1019|Ancien tranchegueule|Elder Razormaw|29|29|0|11:69,32;68,32;69,30;69,31;39,17;70,33;38,16|1697,1696,3685
2108|Garneg Charskull||29|29|4|11:38,46|7131
1353|Grondecroc|Sarltooth|29|29|0|11:33,52|3638,1697,1696,4461,3685
1159|Premier officier Snellig|First Mate Snellig|29|29|0|11:14,30|3619
10896|Arnak Grimtotem||29|29|0|400:38,27|12884
6139|Planeur de Haut-perchoir|Highperch Soarer|29|29|0|400:11,33;10,40;17,41|
4440|Totémique de Tranchebauge|Razorfen Totemic|29|29|1|491:|776,1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
1716|Bazil Thredd||29|29|1|717:|2926,2909
1270|Cadavre fétide|Fetid Corpse|29|30|0|10:79,34;76,37;79,36;75,37;76,34;77,35;77,30;81,33|1129,887,2794
206|Croc noir Plaie-de-nuit|Nightbane Vile Fang|29|30|0|10:63,80;63,79;74,69;72,72;72,73;74,70;73,71;73,73|6844,2794
212|Guerrier Brisepoing|Splinter Fist Warrior|29|30|0|10:35,79;37,79;37,80;33,75;34,76;35,76;32,70;32,69|2794
1053|Tunnelier Sombrefer|Dark Iron Tunneler|29|30|1|11:60,24;60,25;48,19;48,15;46,17;46,16;47,18|11150
4281|Eclaireur écarlate|Scarlet Scout|29|30|1|85:83,31;82,30;86,35;84,36;84,35;84,34;84,37|5819,7753,7787,8226,7727,7754,7786,5805
4282|Magicien écarlate|Scarlet Magician|29|30|1|85:83,31;82,30;84,31;83,29;81,30;85,36;82,34;84,35|7729,5819,7752,7753,7787,8226,7727,7754,7786,5805
4280|Sauveur écarlate|Scarlet Preserver|29|30|1|85:83,31;84,29;82,30;84,30;84,31;82,32;82,34;83,34|7752,7753,8226,7727,7754,7786,5805
2375|Cours-la-côte Aileron déchiré|Torn Fin Coastrunner|29|30|0|267:35,74;31,74;24,69;23,64;33,72;33,74;25,70;27,72|3510,3716,11152,5785
2370|Hurleuse Daguéchine|Daggerspine Screamer|29|30|0|267:61,81;65,86;60,79;63,84;67,80;65,80;63,77;64,77|3509,7072
11697|Flagellante de Mannoroc|Mannoroc Lasher|29|30|0|331:78,85;78,84;81,80;90,77;85,75;80,81|
6115|Gangregarde|Felguard|29|30|0|331:78,85;78,83;84,69;82,66;85,71;79,82|
3803|Gardien austère|Severed Keeper|29|30|0|331:77,75;76,75;75,75|
3757|Implorateur de l’enfer de Xavian|Xavian Hellcaller|29|30|0|331:78,43;78,45;78,44;79,46;79,45|7128,5481
6073|Infernal incendiaire|Searing Infernal|29|30|0|331:78,85;78,84;82,69;83,70;85,78;82,70;79,81;78,82|5741,4784
6071|Molosse de la Légion|Legion Hound|29|30|0|331:79,82;79,83;79,85;78,84;80,81;79,80;90,77|3301,3402
3811|Ours d’Ashenvale géant|Giant Ashenvale Bear|29|30|0|331:89,47;83,48;83,47|3702,3730,11407,3173,11406,2940
3802|Rêveur austère|Severed Dreamer|29|30|0|331:78,74|
3791|Tisseur des ombres Frayeloup|Terrowulf Shadow Weaver|29|30|0|331:52,38;50,39|
3752|Voleur de Xavian|Xavian Rogue|29|30|0|331:78,44;78,46;78,45;79,47;79,45|7128,5481
4116|Géomètre Mufle-de-gravier|Gravelsnout Surveyor|29|30|0|400:64,47;66,50;12,23;13,15;67,60|5842
4101|Volplume hurlante|Screeching Roguefeather|29|30|0|400:27,53;27,52;27,55;27,56;26,53;27,51;27,47;28,48|5116
4438|Lanceur de Tranchebauge|Razorfen Spearhide|29|30|2|491:|6679,776,1488,4438,2264,1976,2039,1727,1978,2549,5825
4518|Sage de la Tête de Mort|Death's Head Sage|29|30|1|491:|776,1488,2264,1976,2039,1727,1975,1978,2549,5825
6224|Forgeur de machines lépreux|Leprous Machinesmith|29|30|0|721:|10299,9308,9309
6225|Mécano-Tank|Mechano-Tank|29|30|1|721:|9510,9327,9489,9509,9485,9487,9490,9488,9486,4371,9309,4377,4382
6222|Technicien lépreux|Leprous Technician|29|30|0|721:|4405,9308,4371,9309,4377,4382
14433|Bouillasseux|Sludginn|30|30|4|11:13,68|814,3670,3673,3674,7296
1160|Capitaine Halyndor|Captain Halyndor|30|30|0|11:15,24|2629,5788
1037|Maître de guerre Dragonmaw|Dragonmaw Battlemaster|30|30|4|11:45,44|3337,7131
7233|Sous-chef Fizzule|Taskmaster Fizzule|30|30|1|17:55,6|
14276|Scargil||30|30|4|267:29,74|3510,3716,11152,5785
3931|Oracle Sombretaillis|Shadethicket Oracle|30|30|0|331:67,82|5508
3696|Ran Dent-rouge|Ran Bloodtooth|30|30|0|331:55,80|5388
4548|Broie-l'acier|Steelsnap|30|30|0|400:18,20|5837,3301,3402
7404|Garde des flammes galak|Galak Flame Guard|30|30|0|400:42,32|
4104|Imploratrice céleste hurlante|Screeching Windcaller|30|30|0|400:26,56;27,54;27,52;26,54;26,53|5116
10992|Panthère enragée|Enraged Panther|30|30|1|400:23,25|12946,5137,5136
4499|Rok'Alim le Marteleur|Rok'Alim the Pounder|30|30|1|400:26,42|5844,5741,4784
4030|Ancien vengeur|Vengeful Ancient|30|30|4|406:30,68|5664,11151
4424|Aggem Mantépine|Aggem Thorncurse|30|30|1|491:|6681,5825
4428|Nécrorateur Jargba|Death Speaker Jargba|30|30|1|491:|2816,6682,6685,5825
7079|Retombée visqueuse|Viscous Fallout|30|30|1|721:|9452,9453,9454,9451,7070
6230|Tenue de maintien de l'ordre|Peacekeeper Security Suit|30|30|1|721:|9510,9327,9491,9489,9508,9509,9485,9487,9490,9488,7191,9486,4371,9309,4377,4382
920|Contaminé Plaie-de-nuit|Nightbane Tainted One|30|31|0|10:63,80;61,82;64,84;62,82;63,84;74,79;74,80;74,77|6844,2794
1487|Esclavagiste Brisepoing|Splinter Fist Enslaver|30|31|0|10:38,81;35,81;38,84|2794
1054|Démolisseur Sombrefer|Dark Iron Demolitionist|30|31|1|11:60,24;62,26;63,29;62,28;47,19;46,19;47,15|11150
1150|Crocilisque des rivières|River Crocolisk|30|31|0|33:36,8;35,8;41,14;37,11;39,11;34,10;35,10|4053,3667,770
683|Jeune panthère|Young Panther|30|31|0|33:37,8;41,8;39,8;38,13;41,10;42,13;41,11;41,13|1687,1686
855|Jeune raptor de Strangleronce|Young Stranglethorn Raptor|30|31|0|33:24,16;25,16|1696,4586,4461,3685,12184
681|Jeune tigre de Strangleronce|Young Stranglethorn Tiger|30|31|0|33:39,15;39,14;37,12;35,12;35,17;32,10;34,11|1687,1686,12202
2408|Gueule d'acier|Snapjaw|30|31|0|36:72,69;33,12;11,55;14,55;31,36;80,58;37,19;23,46#267:68,29;68,32;68,17;68,26;66,38;56,51;62,43;57,47|3712,4556,4555
2559|Arpenteur des hautes-terres|Highland Strider|30|31|0|45:27,21;42,44;19,38;27,24;38,52;51,41;50,41;59,41|4512,1696,4586,4461,3685,12184
4062|Bombardier Sombrefer|Dark Iron Bombardier|30|31|0|45:50,89;49,89|
2586|Malandrin du Syndicat|Syndicate Highwayman|30|31|0|45:32,32;32,31;31,26;30,28;31,30;32,33;35,30;35,32|4495,5113,6986
2552|Troll Witherbark|Witherbark Troll|30|31|0|45:35,46;38,41;36,49;32,46;74,46|7273,4503
4284|Augure écarlate|Scarlet Augur|30|31|1|85:84,32;84,33;85,31;85,32|7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,5805
4285|Disciple écarlate|Scarlet Disciple|30|31|1|85:84,32;84,33;85,31;85,32|7729,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,5805
4283|Sentinelle écarlate|Scarlet Sentry|30|31|1|85:84,31;84,33;84,32;85,32#796:|7729,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,5805,10328
2369|Chasseur du rivage Daguéchine|Daggerspine Shorehunter|30|31|0|267:59,78;58,76;59,74;61,75;53,66;54,64;58,69;54,67|3509,7072,4377
2376|Oracle Aileron déchiré|Torn Fin Oracle|30|31|0|267:38,73;37,69;44,71;36,69;37,66;44,66;44,68;41,69|3510,3716,11152,5785
2248|Yéti des grottes|Cave Yeti|30|31|0|267:46,31;44,27;45,34;46,32;42,33;42,32;45,31;45,28|3708,3720
4147|Basilic du sel gemme|Saltstone Basilisk|30|31|0|400:77,58;76,54;77,60;75,61;75,57;78,65;71,68;71,66|5675,11384,11385,1701,1702
4110|Patriarche de Haut-perchoir|Highperch Patriarch|30|31|0|400:12,34;10,34|5809,5137,5136
4142|Tortue nacrétoile|Sparkleshell Tortoise|30|31|0|400:81,53;75,53;81,55;84,56;75,63;75,56;74,63;75,61|5795,3712,4556,4555
4663|Augure de la Lame ardente|Burning Blade Augur|30|31|0|405:53,30;55,22;52,29;57,23;57,28;53,32;55,30|20310,6986
4632|Centaure kolkar|Kolkar Centaur|30|31|0|405:69,43;70,41;69,44;69,47;69,48;69,52;69,51|6079,6067
4633|Eclaireur kolkar|Kolkar Scout|30|31|0|405:69,50;69,41;69,40;68,39;69,46;69,44;69,49;70,46|6079,24231,6046,6067
4664|Ravageur de la Lame ardente|Burning Blade Reaver|30|31|0|405:52,28;56,22;57,26;54,30;53,32;56,29;55,29|20310,6986
4696|Scorpashi mordeur|Scorpashi Snapper|30|31|0|405:70,21;71,27;68,26;71,24;77,36;80,37;63,15;58,9|6248,19938,19937,1288,4872,4867
4532|Belluaire de Tranchebauge|Razorfen Beastmaster|30|31|1|491:|776,1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
4525|Brise-terre de Tranchebauge|Razorfen Earthbreaker|30|31|1|491:|776,1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
4623|Champion garde-huran|Quilguard Champion|30|31|1|491:|776,1488,4438,2264,1976,2039,1727,1975,1978,2549,5825
4538|Chauve-souris du kraal|Kraul Bat|30|31|1|491:|5801,11393,11394,11391,11392,776,1488,4438,2264,1976,2039,1727,1975,1978,2549
6226|Mécano-Brûleur|Mechano-Flamewalker|30|31|1|721:|9510,9327,9491,9489,9508,9509,9485,9487,9490,9488,7191,9486,4371,9309,3875,4377,4382
4293|Clairvoyant écarlate|Scarlet Scryer|30|31|1|796:|7729,7730,5819,7752,7753,7787,7727,7754,7786,4301,5805
4306|Tortionnaire écarlate|Scarlet Torturer|30|31|1|796:|7729,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,5805,10328
4154|Charognard des Salines|Salt Flats Scavenger|30|32|0|400:81,59;88,66;87,65;88,65;74,59;70,69|5848,3399,729,11416,5114,5115,5116
12347|Clampant des récifs enragé|Enraged Reef Crawler|30|32|0|405:32,34;33,27;34,29;35,26;35,22;37,24;32,28;34,36|15874,15924,2674,2675,5569,3010
4689|Pattes-d'os affamée|Starving Bonepaw|30|32|0|405:70,28;70,27;56,16;56,17|4582,3402
8130|Jeune Sul'lithuz|Sul'lithuz Hatchling|30|35|1|1176:|
503|Seigneur Malathrom|Lord Malathrom|31|31|4|10:21,27;20,29;22,28;23,29;25,29;25,31;26,31|
1140|Matriarche tranchegueules|Razormaw Matriarch|31|31|4|11:70,29|1697,1696,4461,3685,12184
5185|Squale-marteau|Hammerhead Shark|31|31|1|11:7,34;10,25;12,21;14,19;19,17;17,17;22,15;25,14#267:54,91;50,85|5567,537
3660|Athrikus Narassin||31|31|0|148:56,26|5383,5839
12037|Ursol'lok||31|31|4|331:83,49|3702,3730,11407,11406,2940
5933|Achellios le Banni|Achellios the Banished|31|31|4|400:23,37|
4427|Gardien du sceau|Ward Guardian|31|31|1|491:|1488,2264,2039,1975,1978,2549,5825
688|Basilic de pierre|Stone Maw Basilisk|31|32|0|33:35,7;36,7;34,6;37,8;31,2|3918,1701,1702,4093,11386
905|Trancheur frénétique|Sharptooth Frenzy|31|32|0|33:41,17;41,18;39,30;40,22;42,18;36,33;38,10;39,12|4860,6987
2271|Défenseur de Dalaran|Dalaran Shield Guard|31|32|0|36:22,60;15,79;22,87;21,84;18,84;19,86|8491,3714,9719
2577|Exhalombre Sombrefer|Dark Iron Shadowcaster|31|32|0|45:48,87;49,88;48,88|8384
2553|Exhalombre Witherbark|Witherbark Shadowcaster|31|32|0|45:35,40;31,42;74,46|7273,4503
2575|Fournisseur Sombrefer|Dark Iron Supplier|31|32|0|45:48,87|
2578|Jeune busard des mésas|Young Mesa Buzzard|31|32|0|45:28,34;43,61;20,47;69,50;69,52;25,35;20,37;69,37|11416,1464,3404,5829,11418,5116
2589|Mercenaire du Syndicat|Syndicate Mercenary|31|32|0|45:31,26;34,27;31,29;32,31;33,31;34,30;34,29;32,27|4495,5113,6986
2377|Chasse-marée Aileron déchiré|Torn Fin Tidehunter|31|32|0|267:43,71;39,71;37,70;36,70;46,66;45,67;45,69;41,69|3510,3716,11152,5785,12261
2371|Sirène Daguéchine|Daggerspine Siren|31|32|0|267:57,77;57,74;56,70;59,70;59,72;56,65;57,66;59,66|3509,7072
2249|Yéti féroce|Ferocious Yeti|31|32|0|267:43,28;44,25;43,26;42,31;45,30;45,26;44,31|3708,3720
4140|Scorpide ravageur|Scorpid Reaver|31|32|0|400:83,69;83,59;78,57;78,68;75,68;77,68;71,57;74,61|5794,4425,19938,19937,9357,1288,4872,4867
4665|Adepte de la Lame ardente|Burning Blade Adept|31|32|0|405:52,30;53,27;53,28;52,29;57,29;55,26;55,27;56,31|20310,24231,5140,6986,2928
4728|Basilic Mâchesable|Gritjaw Basilisk|31|32|0|405:69,19;48,38;72,36;45,31;74,29;49,8;71,37;57,9|1701,1702,4093,11386,12261
4635|Chasse-vent kolkar|Kolkar Windchaser|31|32|0|405:71,49;75,51;70,39;71,40;72,42;70,41;73,48;74,47|6079,6067
4671|Entourloupeur Fielfurie|Hatefury Trickster|31|32|0|405:77,20;78,17;74,12;78,19;74,24;77,19;72,18;79,25|6246,6247,6989
4672|Lige de la corruption Fielfurie|Hatefury Felsworn|31|32|0|405:78,14;74,10;81,16;75,27;74,24;72,21;76,18;76,29|6246,6247,6989
4666|Lige de la corruption de la Lame ardente|Burning Blade Felsworn|31|32|0|405:53,29;56,26;54,26;55,28;56,28;55,30|20310,6986
4634|Marteleur kolkar|Kolkar Mauler|31|32|0|405:71,44;73,46;72,40;72,45;74,47;71,47;72,42|6079,6067
4670|Voleur Fielfurie|Hatefury Rogue|31|32|0|405:73,11;74,9;77,15;74,25;75,22;75,24;71,17;74,17|6246,6247,6989,12261,6046
6234|Gardien mécanique|Mechanized Guardian|31|32|1|721:|9510,9327,9491,9489,9508,9509,9485,9487,9490,5568,9488,7191,9486,4371,9309,4377,4382
6227|Mécano-Glaceur|Mechano-Frostwalker|31|32|1|721:|9510,9327,9491,9489,9508,9509,9485,9487,9490,9488,7191,9486,4371,9309,4377,4382
4308|Esprit libéré|Unfettered Spirit|31|32|0|796:|7761,10332,7729,7728,7730,5819,6046,7752,7753,7787,8226,7727,7754,7786,4301,10328
6426|Mort angoissé|Anguished Dead|31|33|1|796:|2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787,8226,8384,7727,7754,7786,10328
507|Fenros||32|32|4|10:62,37;62,39;61,41;61,44;62,46;61,50;64,52;64,47|
1200|Morbent Fel||32|32|1|10:17,33|
315|Stalvan Mistmantle||32|32|0|10:77,36|3629,2794
6170|Videssac|Gutspill|32|32|0|10:74,77|6845,2794
2091|Chef Nek'rosh|Chieftain Nek'rosh|32|32|1|11:54,55|3339,3625,3337,3685
14223|Benj le teigneux|Cranky Benj|32|32|4|36:37,20|8167,3712,4556,4555
3792|Chef de meute Frayeloup|Terrowulf Packlord|32|32|4|331:50,40|
4619|Geltharis||32|32|0|331:78,42|5461,5481
3942|Mavoris Cloudsbreak||32|32|0|331:75,74|
10647|Prince Raze||32|32|4|331:82,49;78,46|5461,5481
3940|Taneel Darkwood||32|32|0|331:77,74|
3941|Uthil Mooncall||32|32|0|331:78,73|
5934|Tranchecoeur|Heartrazor|32|32|2|400:17,41|5809,1687,1686
4539|Grande chauve-souris du kraal|Greater Kraul Bat|32|32|1|491:|5801,11393,11394,11391,11392,776,1488,4438,2264,2039,1727,1975,1978,2549
4842|Implorateur de la terre Halmgar|Earthcaller Halmgar|32|32|2|491:|6688,6689,5825
4420|Seigneur Brusquebroche|Overlord Ramtusk|32|32|1|491:|6686,6687,5825
6235|Electrocuteur 6000|Electrocutioner 6000|32|32|1|721:|6893,9446,9447,9448,9327,9309
6229|Faucheur de foule 9-60|Crowd Pummeler 9-60|32|32|1|721:|9449,9450,11827,9327,9309
3983|Interrogateur Vishas|Interrogator Vishas|32|32|1|796:|7682,7683,5805,10328
1108|Gorille de Valbrume|Mistvale Gorilla|32|33|0|33:37,17;39,18;39,17;38,17;37,18;37,16|4097,4096,2799
937|Guerrier de la jungle de Kurzen|Kurzen Jungle Fighter|32|33|0|33:45,10;44,10;45,8;45,9;46,13;45,11;46,11|2633
940|Guérisseur de Kurzen|Kurzen Medicine Man|32|33|0|33:44,7;44,9;44,10;47,10;44,12;45,11|2633
736|Panthère|Panther|32|33|0|33:46,10;28,13;28,17;30,10;28,11;30,11;28,12|1687,1686
977|Panthère de guerre de Kurzen|Kurzen War Panther|32|33|0|33:46,10;46,9|1687,1686
682|Tigre de Strangleronce|Stranglethorn Tiger|32|33|0|33:47,11;47,18;30,9;29,10;31,16;48,14;48,12;47,15|4424,1687,1686,12202
976|Tigre de guerre de Kurzen|Kurzen War Tiger|32|33|0|33:46,10|1687,1686,12202
2240|Détrousseur du Syndicat|Syndicate Footpad|32|33|0|36:58,68;56,66;59,68;59,67;58,66;48,81;48,79|3601,5113,6986
2440|Détrousseur ivre|Drunken Footpad|32|33|0|36:59,70;59,67|3703
2406|Lion des montagnes|Mountain Lion|32|33|0|36:65,49;74,60;33,80;29,70;32,81;35,84;37,86;40,92#267:39,25|3496,5810,3731,1687,1686
2272|Théurge de Dalaran|Dalaran Theurgist|32|33|0|36:22,60;19,78;20,87;20,84;18,83;17,83;18,84;23,61|8491,3714
2250|Yéti des montagnes|Mountain Yeti|32|33|0|36:31,65;33,67;40,70;39,73;39,74;35,72;33,70;30,63|3708,3720,17202
2587|Eclaireur du Syndicat|Syndicate Pathstalker|32|33|0|45:31,26;31,28;32,28;32,31;33,31;33,28|4495,5113,6986
2554|Lanceur de haches Witherbark|Witherbark Axe Thrower|32|33|0|45:66,63;72,59;73,66;68,61;65,68;60,74;65,73;62,72|7273,4503
2562|Ogre Rochepoing|Boulderfist Ogre|32|33|0|45:33,50;36,48;36,45;33,48;32,41;33,41;33,40;37,43|4301
2563|Rampant des plaines|Plains Creeper|32|33|0|45:20,55;61,51;38,31;24,38;33,54;42,73;60,50;53,33|878,2251,3182,1081
4130|Chercheur silithide|Silithid Searcher|32|33|0|400:72,86;68,84;68,81;70,82;72,83|5853,5854,5855,5877
4151|Peau de cristal du sel gemme|Saltstone Crystalhide|32|33|0|400:84,65;78,87;80,70;87,80;79,89;77,65;77,85;75,66|1478,1711,1701,1702,4093,11386
4144|Tortue fouisseuse nacrétoile|Sparkleshell Borer|32|33|0|400:80,86;82,85;82,89;84,84;85,82;72,89|5795,3712,4556,4555
4637|Destructeur kolkar|Kolkar Destroyer|32|33|0|405:72,50;74,52;73,50;75,49;71,44;73,42|6079,6067
4647|Eclaireur gelkis|Gelkis Scout|32|33|0|405:39,85;40,90;34,80;39,83;34,81;35,82;35,84|24281,6067,2928
4638|Eclaireur magram|Magram Scout|32|33|0|405:74,66;66,70;72,69;66,76;70,69;67,74|6067
4646|Estafette gelkis|Gelkis Outrunner|32|33|0|405:37,84;35,88;40,83;35,84;35,86;36,86;41,90|6067
4639|Estafette magram|Magram Outrunner|32|33|0|405:67,69;67,70;72,67;66,75;68,70|6067
4675|Implorateur de l’enfer Fielfurie|Hatefury Hellcaller|32|33|0|405:79,18;75,12;75,16;80,17;74,24;73,18;73,17;77,26|6246,6247,6989
4711|Naga Ondulame|Slitherblade Naga|32|33|0|405:33,24;35,22;42,20;37,24;38,24;35,27;35,28|15881,15874,15924,7072
4667|Ombremage de la Lame ardente|Burning Blade Shadowmage|32|33|0|405:53,29;55,27|20310,6986
4692|Rapace de l'effroi|Dread Swoop|32|33|0|405:70,21;44,19;72,57;48,31;68,60;72,28;52,24;54,67|11416,556,1464,3404,5829,11418,5116
4636|Seigneur de guerre kolkar|Kolkar Battle Lord|32|33|0|405:72,51;70,43;74,51;74,50;73,47;72,41;75,47;72,48|6079,6067
4712|Sorcière Ondulame|Slitherblade Sorceress|32|33|0|405:32,17;36,25;36,29;33,23;31,22;28,7;39,20|15881,15874,15924,7072
4674|Traqueur des ténèbres Fielfurie|Hatefury Shadowstalker|32|33|0|405:73,13;79,16;77,18;76,24;76,16;76,27|6441,6246,6247,6989
4673|Traître Fielfurie|Hatefury Betrayer|32|33|0|405:78,18;75,12;71,15;81,18;77,21;74,22;73,17;78,26|6246,6247,6989
6212|Agent Sombrefer|Dark Iron Agent|32|33|1|721:|9326,9510,10299,9491,9489,9508,9509,9485,9308,9487,9490,9488,9486,9309,6046,8384
6232|Annulateur d’Arcane X-21|Arcane Nullifier X-21|32|33|1|721:|9510,9327,9491,9489,9508,9509,9485,9487,9490,9488,7191,9486,4371,9309,4377,4382
6427|Illusion spectrale|Haunting Phantasm|32|33|1|796:|2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,4301,10328
4158|Vautour des Salines|Salt Flats Vulture|32|34|0|400:83,71;78,90;71,75;84,71;71,79;79,89|5848,3399,729,11416,5829,11418,5116
11578|Déchireur de tourbillon|Whirlwind Shredder|32|34|0|405:63,79;62,77;58,91;56,85;32,70;60,74;58,86;31,81|7069
11576|Tourbillon éventreur|Whirlwind Ripper|32|34|0|405:42,29;45,20;45,39;50,9;65,42;56,20;36,73;45,74|7069
2412|Alina||33|33|0|36:20,86|3690
3984|Nancy Vishas||33|33|1|36:32,33|5538
2411|Ricter||33|33|0|36:20,84|3689
14277|Dame Zephris|Lady Zephris|33|33|4|267:65,80|3509,7072
14225|Prince Kellen||33|33|4|405:79,21|6246,6247,6989
13019|Prophète de la Lame ardente|Burning Blade Seer|33|33|0|405:55,30|15750,20310,6986
4422|Agathelos l'Enragé|Agathelos the Raging|33|33|1|491:|6690,6691,3403,2677,3172,2295
4421|Charlga Trancheflanc|Charlga Razorflank|33|33|1|491:|5792,5793,6692,6693,6694,17008,5825
6228|Ambassadeur Sombrefer|Dark Iron Ambassador|33|33|2|721:|9455,9456,9457,9308
6490|Azshir le Sans-sommeil|Azshir the Sleepless|33|33|2|796:|7708,7709,7731
6488|Champion mort|Fallen Champion|33|33|2|796:|7689,7690,7691,10328
4304|Chien de chasse écarlate|Scarlet Tracking Hound|33|33|1|796:|4582,5756,7757,2262,8225,7761,10332,7729,3402,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,10328
6489|Echine-de-fer|Ironspine|33|33|2|796:|7686,7687,7688,10328
7873|Garde de guerre de Tranchebauge|Razorfen Battleguard|33|34|1|17:47,88;48,90;46,90;48,95;47,89;48,93;47,93|24232,9357,10573,10582,5140,10571,10584,8384,3875,2928
7872|Sectateur de la Tête de Mort|Death's Head Cultist|33|34|1|17:49,90;48,90;47,88;48,94;48,89;48,91;47,92;48,92#400:40,30|10571,10584
7874|Tisseur d'épines de Tranchebauge|Razorfen Thornweaver|33|34|1|17:49,90;46,88;48,91;48,94;46,91;47,92;48,93#400:40,30|10573,10582,10571,10584
697|Chaman Bloodscalp|Bloodscalp Shaman|33|34|0|33:30,19;30,20;30,21;31,18;30,17|1519,3901,3915
702|Charognard Bloodscalp|Bloodscalp Scavenger|33|34|0|33:31,12;31,13;31,11;32,12;31,14;33,14;32,14;33,13|1519,3901,3915
587|Guerrier Bloodscalp|Bloodscalp Warrior|33|34|0|33:30,19;33,14;30,22;34,15;34,17|1519,3901,3915
856|Jeune raptor flagellant|Young Lashtail Raptor|33|34|0|33:31,23|1696,4586,4461,3685,12184
694|Lanceur de haches Bloodscalp|Bloodscalp Axe Thrower|33|34|0|33:30,20;29,19;29,20;33,17;34,16;35,16|1519,3901,3915
685|Raptor de Strangleronce|Stranglethorn Raptor|33|34|0|33:24,16;24,15;25,16;27,18;26,17;27,16;28,18|1696,4586,4461,3685,12184,4356
2359|Elémentaire asservi|Elemental Slave|33|34|0|36:23,59;19,58;16,79;15,77;19,74;21,61;20,54;20,57|3715,3766,3767,3769,5741,4553,8384,4784
2241|Larron du Syndicat|Syndicate Thief|33|34|0|36:59,69;58,68;48,82;47,81;48,81|3601,5113,6986
2407|Lion des montagnes massif|Hulking Mountain Lion|33|34|0|36:53,31;83,59;74,55;83,65;52,25;49,83;44,77;40,92|3496,5810,3731,1687,1686
2628|Ouvrier de Dalaran|Dalaran Worker|33|34|0|36:17,56;13,75;10,74;15,76;14,78;16,75;20,72|3714
2251|Yéti géant|Giant Yeti|33|34|0|36:32,49;34,40;37,36;31,51;41,63;44,65;39,65;37,69|3708,21211,3720,21314,17202
2564|Massacreur Rochepoing|Boulderfist Enforcer|33|34|0|45:33,47;31,44;34,45;33,44;35,44;32,45;33,45;33,46|
2555|Sorcier-docteur Witherbark|Witherbark Witch Doctor|33|34|0|45:65,72;69,81;70,78;66,64;70,62;65,73;71,69;68,77|4522,7273,4503,9719
2560|Vandale des hautes-terres|Highland Thrasher|33|34|0|45:21,55;20,48;37,67;39,69;38,33;32,64;37,30|1477,2289,2290,4512,1711,1696,4586,4461,3685,12184
4133|Bourdon silithide|Silithid Hive Drone|33|34|0|400:68,88;69,85;70,86;70,88;67,82;65,86;65,85|5853,5854,5855,5877
4139|Scorpide terrifiant|Scorpid Terror|33|34|0|400:87,69;83,88;73,90;85,80;83,80;70,79;71,75;84,72|5794,19938,19937,1288,4872,4867
9377|Vortex tourbillonnant|Swirling Vortex|33|34|0|400:82,63;72,90;75,53;71,57;72,66;77,71|7069
4649|Chasse-vent gelkis|Gelkis Windchaser|33|34|0|405:38,97;35,90;37,85;40,93;39,92;36,83;37,80;37,82|6067
4641|Chasse-vent magram|Magram Windchaser|33|34|0|405:75,68;66,71;71,79;67,81;65,78;69,70;74,69;69,77|12261,6067
4713|Guerrier Ondulame|Slitherblade Warrior|33|34|0|405:33,15;34,14;32,24;32,21;35,23;35,22;34,21;37,26|15881,15874,15924,7072
4726|Lézard-tonnerre enragé|Raging Thunder Lizard|33|34|0|405:45,29;37,75;72,55;45,37;68,57;50,33;45,23;70,69|5133,5128,6046
4648|Poinçonneur gelkis|Gelkis Stamper|33|34|0|405:37,86;38,95;39,86;41,92;35,92;38,84;36,82;35,82|6067
4640|Querelleur magram|Magram Wrangler|33|34|0|405:66,80;76,73;74,68;69,81;73,78;76,71;71,74;70,76|4301,6067
11562|Rampant Claquesec|Drysnap Crawler|33|34|0|405:25,80;23,82;20,70;24,82;25,79;19,82;31,28;35,34|13545,15878,6457,15874,15924,2143
4296|Adepte écarlate|Scarlet Adept|33|34|1|796:|5756,7757,2262,8225,7761,10332,4356,7729,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,3875,5805
4287|Vaillant écarlate|Scarlet Gallant|33|34|1|796:|5756,7757,2262,8225,7761,10332,4356,7729,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786,3875,5805
938|Commando de Kurzen|Kurzen Commando|33|35|0|33:44,8;48,7;45,8;47,8;46,7;46,8|5788
4688|Hyène Pattes-d'os|Bonepaw Hyena|33|35|0|405:37,72;46,29;47,30;55,40;54,39|4582,3402
534|Nefaru||34|34|4|10:63,84;74,78;62,81|
1364|Balgaras le Crasseux|Balgaras the Foul|34|34|1|11:60,25;62,28;47,15;62,29;62,26;47,19|3639,11150
943|Fracasseur de Kurzen|Kurzen Wrangler|34|34|0|33:46,10;46,9|
2413|Dermot||34|34|0|36:20,86|3691
3985|Grand-père Vishas|Grandpa Vishas|34|34|1|36:32,33|
2600|Singer||34|34|4|45:32,31|2997,3875,2928
6072|Diathorus le Chercheur|Diathorus the Seeker|34|34|0|331:79,85;79,86;79,81;79,83|
14228|Glousse|Giggler|34|34|4|405:61,29|4582,3402
7800|Mekgénieur Thermaplugg|Mekgineer Thermaplugg|34|34|1|721:|4411,4413,6672,7192,7560,7561,7742,9299,9458,9459,9461,9492,11828,9327,9309
7333|Sanglier de guerre corrompu|Withered Battle Boar|34|34|0|722:|3403,2677,3172,2295
4543|Mage de sang Thalnos|Bloodmage Thalnos|34|34|1|796:|7684,7685,10328
3974|Maître-chien Loksey|Houndmaster Loksey|34|34|1|796:|3456,7710,7756,5805,10328
740|Jeune dragonnet|Adolescent Whelp|34|35|0|8:16,65;15,67;14,61;17,60;14,59;11,63;13,67|4459,5803,4402,12261
755|Rôdeboue Perdu|Lost One Mudlurker|34|35|0|8:50,34;43,35;46,28;49,32;52,34;46,31;52,29;50,27|
7327|Guerrier flétri|Withered Warrior|34|35|1|17:50,93;49,92#722:|10578,10573,10582,10571,10584,6046
7332|Lanceur flétri|Withered Spearhide|34|35|1|17:50,93;49,92#722:|10567,10578,10573,10582,10571,10584
1085|Ancien tigre de Strangleronce|Elder Stranglethorn Tiger|34|35|0|33:34,19;36,19;35,19;32,18;34,18;33,19;31,17|1687,1686,12202
689|Basilic de cristal|Crystal Spine Basilisk|34|35|0|33:49,10;47,6;24,17;24,18;25,18;27,19;26,18|1703,3918,1701,1702,4093,11386,4301
699|Belluaire Bloodscalp|Bloodscalp Beastmaster|34|35|0|33:26,13;25,9;25,11;23,11;23,8;28,11|1519,3901,3915,2928
921|Bûcheron de la KapitalRisk|Venture Co. Lumberjack|34|35|0|33:43,19|1630
595|Chasseur Bloodscalp|Bloodscalp Hunter|34|35|0|33:23,12;26,10;26,13;26,9;25,9;23,11;26,11|1519,3901,3915,24231,5140,2928
588|Eclaireur Bloodscalp|Bloodscalp Scout|34|35|0|33:22,13;26,9;25,13;25,11;26,12;23,13|1519,3901,3915,24231,2928
1094|Mineur de la KapitalRisk|Venture Co. Miner|34|35|0|33:29,7;28,8;29,8;27,7|1630
701|Mystique Bloodscalp|Bloodscalp Mystic|34|35|0|33:23,13;26,12;24,12;26,8;25,10;27,11;24,13|1519,3901,3915
1097|Mécanicien de la KapitalRisk|Venture Co. Mechanic|34|35|0|33:29,8;43,19;42,19;42,18|4387,4389,1630,4377,4382
941|Réducteur de tête de Kurzen|Kurzen Headshrinker|34|35|0|33:48,7;48,8;47,7;46,7;46,8|2633,2928
2358|Invocateur de Dalaran|Dalaran Summoner|34|35|0|36:22,60;22,58;19,75;11,79;13,76;20,75;21,54;19,55|3384,3745,3767,8491,3714
2252|Ogre Cassecrête|Crushridge Ogre|34|35|0|36:54,36;53,45;51,35;46,40;47,60;49,37;53,48|2843,3658,17202
2319|Sorcier du Syndicat|Syndicate Wizard|34|35|0|36:58,67;60,44;60,43;63,44;61,46;62,41;62,40|3505,5113,6986
2579|Busard des mésas|Mesa Buzzard|34|35|0|45:20,52;34,66;38,27;37,66;40,67;54,65;45,35;57,69|11416,1464,3404,5829,11418,5116
2556|Chasseur de têtes Witherbark|Witherbark Headhunter|34|35|0|45:70,78;67,81;68,80;68,82;73,64;71,67;69,76;63,73|11166,7273,4503,4356,6046
4150|Contemplateur du sel gemme|Saltstone Gazer|34|35|0|400:71,91;77,89;77,91;76,90;78,89;79,89;79,87;78,84|1701,1702,4093,11386
4131|Envahisseur silithide|Silithid Invader|34|35|0|400:65,87;66,86;64,86;65,85;64,85;67,86|5853,5854,5855,5877
4143|Mordeuse nacrétoile|Sparkleshell Snapper|34|35|0|400:78,72;88,79;82,54;86,61;84,67;79,52;77,71;70,78|5795,3712,4556,4555
4643|Coursier magram|Magram Pack Runner|34|35|0|405:70,73;65,77;72,78|6067
4697|Flagellant scorpashi|Scorpashi Lasher|34|35|0|405:64,58;44,46;43,72;45,74;45,48;78,44;57,48;59,54|6248,19938,19937,4872,4867
4651|Implorateur de la terre gelkis|Gelkis Earthcaller|34|35|0|405:38,93;38,90;41,88;37,89;39,87;40,96;38,96;36,81|6067
4642|Légion-tempête magram|Magram Stormer|34|35|0|405:68,80;69,83;66,79;70,78;71,76;70,74;68,75;70,72|6067
4714|Myrmidon Ondulame|Slitherblade Myrmidon|34|35|0|405:33,15;33,6;32,19;29,13;29,8;27,10;32,23;34,22|15881,15874,15924,7072
4718|Oracle Ondulame|Slitherblade Oracle|34|35|0|405:34,10;33,22;32,16;29,7;28,8|6442,15881,15874,15924,7072
11563|Pinceur Claquesec|Drysnap Pincer|34|35|0|405:20,78;22,85;21,84;22,82;31,35;23,78;33,31;32,35|13545,15878,6457,15874,15924,2143
4700|Vieux kodo|Aged Kodo|34|35|0|405:53,57;48,60;54,57;58,35;45,19;45,20;49,40;57,82|6249,12204,5122,5121,5173
4288|Belluaire écarlate|Scarlet Beastmaster|34|35|1|796:|1992,7755,7759,5756,7757,2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787,8226,7727,7754,7786
4299|Chapelain écarlate|Scarlet Chaplain|34|35|1|796:|7146,7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,4356,7729,7728,7730,5819,6046,7752
4291|Devin écarlate|Scarlet Diviner|34|35|1|796:|7146,1992,7755,7759,5756,7757,2262,8225,7761,10332,4356,7729,7728,7730,5819,6046,7752,7753,7787,8226
1096|Géologue de la KapitalRisk|Venture Co. Geologist|34|36|0|33:29,7;45,22;43,19;45,23;45,20;45,21;28,8;46,20|4106,1630
522|Mor'Ladim||35|35|1|10:17,37|3514,2794
815|Herod la Paperasse|Bookie Herod|35|35|0|33:45,8;44,8;45,11|
14222|Araga||35|35|4|36:30,72|5137,1687,1686,4865
2414|Kegan Darkmar||35|35|0|36:18,83|3688
5937|Dardeur|Vile Sting|35|35|2|400:71,73|5794,19938,19937,1288,4872,4867
5600|Khan Dez'hepah||35|35|0|405:73,42|6066,6067
14229|Ondulame maudit|Accursed Slitherblade|35|35|4|405:42,19|7072
7343|Squelette Os-brisés|Splinterbone Skeleton|35|35|0|722:|
7175|Embusqué Cavepierre|Stonevault Ambusher|35|35|0|1337:|5833
2727|Coyote des rochers|Crag Coyote|35|36|0|3:50,46;50,42;58,46;54,48;50,40;50,35;52,25;52,21|6166,7846,24232,4582,8384
2739|Tunnelier Ombreforge|Shadowforge Tunneler|35|36|0|3:52,31;53,32;54,33;53,33;54,34;52,32;55,31|4616,4301
741|Dragonnet rêveur|Dreaming Whelp|35|36|0|8:15,64;13,59;13,65;11,57;17,56|8498,4459,5803,4402,6046
1084|Jeune crocilisque Dents-de-scie|Young Sawtooth Crocolisk|35|36|0|8:30,39;29,36;26,36;39,35;25,39;27,55;26,52;30,55|3667,770
757|Pêcheur Perdu|Lost One Fisherman|35|36|0|8:44,31;51,32;60,28;57,31;49,30;43,39;54,31;55,30|
4376|Araignée de Sombrebrume|Darkmist Spider|35|36|0|15:32,23;32,22;30,22;31,22;34,22;35,24;35,22|5884,5959,12205
4341|Crocilisque Sèchefange|Drywallow Crocolisk|35|36|0|15:50,20;59,35;60,35;45,19;48,22;38,29;36,27;36,26|3667,770
4346|Ecorcheur nuisible|Noxious Flayer|35|36|0|15:53,17;60,28;50,32;60,22;56,38;48,26;47,27;38,24|
4359|Murloc Aileron boueux|Mirefin Murloc|35|36|0|15:57,15;58,16;58,15;54,15;57,16|5847,5785
4382|Rampant Fane-liane|Withervine Creeper|35|36|0|15:38,15;37,17;42,15;43,19;40,14;39,24;38,22;40,25|
4351|Raptor Rougefange|Bloodfen Raptor|35|36|0|15:49,16;49,18;50,19;51,22;47,15;52,21;48,20;48,18|4586,4461,4587,12184,8384
7335|Géomancienne de la Tête de Mort|Death's Head Geomancer|35|36|1|17:50,93;50,92#722:|10572,10567,10578,10573,10582,10571,10584,9719
4458|Chasseur Branchie-bistre|Murkgill Hunter|35|36|0|33:34,24;35,24;34,22;35,23;35,21|5785
879|Chasseur Selécaille|Saltscale Hunter|35|36|1|33:24,25;23,25;23,26;24,24;25,24|4655,5796,4611,5785
1152|Crocilisque Gueule d'acier|Snapjaw Crocolisk|35|36|0|33:41,21;40,23;42,17;40,19;39,29;40,27;41,22;39,30|4104,3667,770
1151|Crocilisque marin|Saltwater Crocolisk|35|36|0|33:15,10;18,12;22,18;22,17;34,32;23,18;22,19;27,21|2924,2925,3667,770
4457|Fourrageur Branchie-bistre|Murkgill Forager|35|36|0|33:34,23;36,23|5785
877|Fourrageur Selécaille|Saltscale Forager|35|36|1|33:24,25|4655,5796,4611,2143,5785
4461|Guerrier Branchie-bistre|Murkgill Warrior|35|36|0|33:34,21;33,22;34,22;35,23;36,23|5785,2928
871|Guerrier Selécaille|Saltscale Warrior|35|36|1|33:24,25;25,23;25,25;27,24;27,22|4655,5796,4611,5785
978|Lieutenant de Kurzen|Kurzen Subchief|35|36|0|33:50,6;49,4;49,5;50,4;49,6|
686|Raptor flagellant|Lashtail Raptor|35|36|0|33:39,19;39,22;36,26;38,20;38,27;31,24;32,21;32,24|1696,4586,4461,3685,12184,9719
2253|Brute Cassecrête|Crushridge Brute|35|36|0|36:43,31;47,36;47,45;51,53;51,58;45,31;52,44;49,60|2843,3658,17202,9262,8384,9719
2242|Espion du Syndicat|Syndicate Spy|35|36|0|36:64,42;59,43;58,44;63,42;57,45;61,43;64,44|5775,3505,5113,6986
2318|Mage de l'ombre d'Argus|Argus Shadow Mage|35|36|0|36:59,31;56,27;48,17;53,21;57,46;60,44;61,46;64,44|
4844|Géomètre Ombreforge|Shadowforge Surveyor|35|36|1|38:39,92;38,92;35,89;39,90;38,88;38,87;35,91;34,88#3:44,10;44,11;46,8;47,11;47,13;46,13;45,11|7666,8009,8052,5173,5140,9381,9391,9386,9397,9393,9396,9406,9428,9384,9420,3875,2928,9719
4846|Terrassier Ombreforge|Shadowforge Digger|35|36|1|38:40,90;38,94;38,93;39,90;36,89;37,89;36,91;39,87#3:41,15;44,10;45,8;47,11;47,12;47,10;44,12;42,12|21211,7666,21314,8009,8052,9381,9391,9386,9397,9393,9396,9406,9428,9384,9420,4356,4301
2566|Brute Rochepoing|Boulderfist Brute|35|36|0|45:55,80;55,78;53,74;54,76;55,79;53,73;52,74;50,79|4301
2557|Chasseur des ombres Witherbark|Witherbark Shadow Hunter|35|36|0|45:69,81;70,79;68,81;69,82;66,80;67,82;67,79|5040,11166,7273,4503
2590|Conjurateur du Syndicat|Syndicate Conjuror|35|36|1|45:25,63;27,66;29,65;29,66;25,66;26,64;28,60|4440,4506,5113,6986,6046
2572|Kobold Sèche-moustache|Drywhisker Kobold|35|36|0|45:82,37;76,44;77,44;78,41;82,39;78,40;78,37;78,36|4435,4479,4480,4481,6046
2565|Rampant des plaines géant|Giant Plains Creeper|35|36|0|45:43,33;42,32;48,77;62,69;45,37;47,37;53,59;57,62|878,2251,3182,1081
4729|Basilic Mâchesable massif|Hulking Gritjaw Basilisk|35|36|0|405:43,49;42,43;38,39;43,64;62,44;52,48;56,48;57,49|1701,1702,4093,11386
6068|Garde du corps de Warug|Warug's Bodyguard|35|36|0|405:75,68|6067
4701|Kodo mourant|Dying Kodo|35|36|0|405:51,59;47,59;54,58;50,58;54,63;56,63;49,41|12204,5122,5121
4653|Maraudeur gelkis|Gelkis Marauder|35|36|0|405:35,91;36,92;39,94;39,95;41,95;40,94|6067
4644|Maraudeur magram|Magram Marauder|35|36|0|405:66,81;67,81;71,71;71,75;73,73;73,75|6067
4652|Marteleur gelkis|Gelkis Mauler|35|36|0|405:40,94;40,96;40,95;41,96;40,92;39,96;36,91|6067
4645|Marteleur magram|Magram Mauler|35|36|0|405:66,80;69,78;70,78;72,78;74,73;71,75|6067
4715|Queue-rasoir Ondulame|Slitherblade Razortail|35|36|0|405:31,16;29,8;31,9;30,9;29,10|15881,7072
4719|Sorcière des mers Ondulame|Slitherblade Sea Witch|35|36|0|405:34,8;35,17;29,12;29,11;29,9;28,13;30,11;28,10|6245,15881,7072
7329|Garde-huran flétri|Withered Quilguard|35|36|1|722:|10570,10583,10572,10567,10578,10573,10582,10571,10584,12261,6046,4301,9719
7328|Ravageur flétri|Withered Reaver|35|36|1|722:|10570,10583,10572,10567,10578,10573,10582,10571,10584,9719
4297|Conjurateur écarlate|Scarlet Conjuror|35|36|1|796:|7736,1992,7755,7759,7757,2262,8225,7761,10332,7728,7730,5819,7752,8226,8384,7727,7754,7786,5805,10328
4540|Moine écarlate|Scarlet Monk|35|36|1|796:|7146,7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,4356,7729,7728,7730,5819,6046,7752
4286|Soldat écarlate|Scarlet Soldier|35|36|1|796:|7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787,8226
7078|Scorpide de la Faille|Cleft Scorpid|35|36|0|1337:|19938,19937,5833,12261,4872,4867,9719
2829|Busard affamé|Starving Buzzard|35|37|0|3:60,30;61,40;49,27;59,24;55,14;57,29|7847,11416,556,1464,3404,5829,11418,5116
4695|Horreur putride|Carrion Horror|35|37|0|405:50,57;52,59;52,61;49,59;53,60;54,64;51,58;53,59|11416,556,1464,3404,5829,11418,5116
11577|Tourbillon Marchetempête|Whirlwind Stormwalker|35|37|0|405:43,62;42,54;43,61;77,54;42,52;52,47;54,48;55,45|7069
2751|Golem de guerre|War Golem|36|36|4|3:52,19;49,12;45,34|4553
4386|Arracheur Fane-liane|Withervine Bark Ripper|36|36|0|15:46,81;50,60;36,48;44,44;41,42;54,31;54,24;48,22|
12865|Ambassadeur Malcin|Ambassador Malcin|36|36|1|17:48,91;48,92;49,96;46,90|17009,10578
7895|Ambassadeur Ragesang|Ambassador Bloodrage|36|36|2|17:48,91|
1095|Régisseur de la KapitalRisk|Venture Co. Workboss|36|36|0|33:43,19|1630
2415|Gardienne Belamoore|Warden Belamoore|36|36|0|36:18,83|3711,3714
14221|Gravis Slipknot||36|36|4|36:58,42|3505,5113,6986
2452|Grybou|Skhowl|36|36|4|36:31,52|4304,3720
2603|Kovork||36|36|4|45:30,44;33,44;32,46|
5643|Tyranis Malem||36|36|0|405:53,29|6767
2906|Guerrier Crache-poussières|Dustbelcher Warrior|36|37|0|3:68,25;64,24;66,22;66,23;67,22|4630
2907|Mystique Crache-poussières|Dustbelcher Mystic|36|37|0|3:67,23;65,26;13,73;66,22|4630
2740|Tisseur d’ombre Ombreforge|Shadowforge Darkweaver|36|37|0|3:54,32;51,34;54,31;53,34|4616
2731|Traqueur des crêtes|Ridge Stalker|36|37|0|3:61,30;65,37;45,41;61,44;45,36;57,28;59,26;54,15|1686,1688,12202
759|Chasseur Perdu|Lost One Hunter|36|37|0|8:65,23;55,25;58,24;56,29;57,25;62,23;63,24|
767|Jaguar du marécage|Swamp Jaguar|36|37|0|8:37,38;36,40;37,31;23,42;26,34;54,42;12,59;42,43|1686,1688,4356,8384
760|Marche-boue Perdu|Lost One Muckdweller|36|37|0|8:58,28;61,28;58,30;63,22;62,27;62,19;59,24;56,34|
858|Tisseuse des pleurs|Sorrow Spinner|36|37|0|8:26,50;37,31;40,31;37,32;34,55;27,49;20,53;25,59|12205
4362|Cours-la-côte Aileron boueux|Mirefin Coastrunner|36|37|0|15:58,16;58,15;54,15;56,17;59,16;57,16|5847,5785
4352|Hurleur Rougefange|Bloodfen Screecher|36|37|0|15:50,17;51,16;49,21;52,22;48,16;46,20;47,18|4586,4461,4587,12184
4361|Marche-boue Aileron boueux|Mirefin Muckdweller|36|37|0|15:58,11;62,8;64,8;63,8;59,11;57,11;59,8;60,10|5847,5785
4378|Solitaire de Sombrebrume|Darkmist Recluse|36|37|0|15:31,20;33,23;31,22;34,24;35,23|5884,5959,12205
597|Berserker Bloodscalp|Bloodscalp Berserker|36|37|0|33:20,12;25,9;24,9;23,11;24,10|1519,3901,3915,3875
1142|Brute Mosh'Ogg|Mosh'Ogg Brute|36|37|0|33:36,31;37,31;38,30;37,32|
671|Chasseur de tête Bloodscalp|Bloodscalp Headhunter|36|37|0|33:20,12;24,9;21,10;23,10;23,11;24,10;24,8|1532,1519,3901,3915
691|Elémentaire d'eau mineur|Lesser Water Elemental|36|37|0|33:20,24;22,24;21,24;21,23;23,23;22,22;20,22|1706,3923,4791,7070
854|Jeune Traqueur de la jungle|Young Jungle Stalker|36|37|0|33:32,42;31,45;32,43;31,44|4586,4461,3685,4587,12184
4459|Oracle Branchie-bistre|Murkgill Oracle|36|37|0|33:35,23|5785
873|Oracle Selécaille|Saltscale Oracle|36|37|1|33:25,24;24,24;25,23;25,25|4655,5796,4611,5785
1144|Sorcier-docteur Mosh'Ogg|Mosh'Ogg Witch Doctor|36|37|0|33:37,29;38,30;37,31;36,32|
942|Sorcier-docteur de Kurzen|Kurzen Witch Doctor|36|37|0|33:48,6;48,7;47,6;49,9;50,8|2633
939|Troupe d'élite de Kurzen|Kurzen Elite|36|37|0|33:47,7;48,6;48,7;49,8;49,9|
2254|Mutileur Cassecrête|Crushridge Mauler|36|37|1|36:39,40;39,39;42,45;40,46;44,47;43,47;43,50;41,49|2843,3658,3875,9719
2416|Pilleur Cassecrête|Crushridge Plunderer|36|37|1|36:37,55;37,54|2843,3658
2243|Sentinelle du Syndicat|Syndicate Sentry|36|37|0|36:52,31;56,34;58,29;59,29;56,27;48,18;46,20;53,20|3505,5113,6986
4856|Chasseur Cavepierre|Stonevault Cave Hunter|36|37|1|38:33,89;37,93;36,92;35,96;34,96;33,92;35,93#3:36,23|5797,7666,9383,9381,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420
4845|Forban Ombreforge|Shadowforge Ruffian|36|37|1|38:40,90;38,93;36,88;34,89;39,86;35,91;39,87;37,89#3:40,19;42,10;42,11|7666,8009,8052,9383,9381,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420
4851|Mange-roches Cavepierre|Stonevault Rockchewer|36|37|1|38:32,90;33,92;34,92;37,92;35,94;35,95;34,97#3:35,23|4623,9030,5797,7666,9383,9381,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420,12261,6046,3875,2928
2558|Berserker Witherbark|Witherbark Berserker|36|37|1|45:23,65;24,66;24,65|11166,7273,4503,3875
2561|Charognard des hautes-terres|Highland Fleshstalker|36|37|0|45:47,81;46,77;46,80;51,65;50,68;51,69;52,68;54,65|4513,1696,4586,4461,3685,12184
2567|Magus Rochepoing|Boulderfist Magus|36|37|0|45:55,81;54,78;53,74;53,77;54,80;54,72;52,76;51,78|12261
2588|Rôdeur du Syndicat|Syndicate Prowler|36|37|1|45:25,63;29,65;28,62;26,63;29,66;26,64;29,61|4440,4506,5113,6986
2574|Terrassier Sèche-moustache|Drywhisker Digger|36|37|0|45:83,32;82,36;84,34;85,34;85,31;86,30;87,32;83,35|4435,4479,4480,4481
4702|Ancien kodo|Ancient Kodo|36|37|0|405:51,58;49,60;52,62;54,61|12204,5122,5121
4716|Chasse-marée Ondulame|Slitherblade Tidehunter|36|37|0|405:34,9;33,11;30,16;30,8;29,11;29,9|6245,15881,7072,2928
4676|Infernal mineur|Lesser Infernal|36|37|0|405:54,81;58,77;54,84;53,86;53,72;54,71;55,80;49,77|6990,4553,4784
4693|Volant de l'effroi|Dread Flyer|36|37|0|405:40,51;63,52;43,41;42,50;42,54;42,45;44,59;57,51|11416,556,1464,3404,5829,11418,5116
7337|Nécromancienne de la Tête de Mort|Death's Head Necromancer|36|37|1|722:|10581,10570,10574,10583,10572,10567,10578,10573,10582,10571,10584
4289|Evocateur écarlate|Scarlet Evoker|36|37|1|796:|5740,7758,7760,7736,7755,7759,5756,7757,2262,8225,7761,10332,7728,7730,5819,6046,7752,7753,7787,8226
4290|Gardien écarlate|Scarlet Guardsman|36|37|1|796:|5740,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787,8226
4292|Protecteur écarlate|Scarlet Protector|36|37|1|796:|5740,7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,4356,7729,7728,12261,7730,5819,6046
979|Chasseur des ombres de Kurzen|Kurzen Shadow Hunter|36|38|0|33:50,6;50,4;49,4;49,6;49,5|8384
4690|Pattes-d'os enragée|Rabid Bonepaw|36|38|0|405:54,45;40,42|4582
4655|Querelleur maraudine|Maraudine Wrangler|36|38|0|405:37,61;35,61;35,56;34,54;32,60;40,61;30,69;31,65|6074,6067
2850|Brèchedent|Broken Tooth|37|37|4|3:60,29;60,27;54,16;46,36|2996,4305,4339,2997,4580,1688,4301,9719
1106|Cuisinier perdu|Lost One Cook|37|37|4|8:65,23;64,23;62,23;62,22;61,24;62,21|
5622|Ongeku||37|37|0|8:65,22|6190
14231|Dorgoth le Vagabond|Drogoth the Roamer|37|37|4|15:40,19|
4260|Déchiqueteur de la KapitalRisk|Venture Co. Shredder|37|37|0|33:46,20;44,23|4387,4389,7191,4377,4382
14487|Gluggle||37|37|4|33:35,23;35,22;36,24;34,23|5785
4460|Seigneur Branchie-bistre|Murkgill Lord|37|37|0|33:36,24;36,23|5785
875|Seigneur des marées Selécaille|Saltscale Tide Lord|37|37|1|33:25,24;25,25|5796,4611,5785
729|Sin'Dall||37|37|0|33:32,17|3879,1686,1688,12202
660|Sorcier-docteur Bloodscalp|Bloodscalp Witch Doctor|37|37|0|33:20,12;21,13;21,12;20,13;24,10;24,8;23,8|1519,3901,3915,9719
2258|Furie-de-pierre|Stone Fury|37|37|4|36:65,45|4553,4784
2431|Geôlier Borhuin|Jailor Borhuin|37|37|0|36:63,43|3704,2928
2606|Nimar le Pourfendeur|Nimar the Slayer|37|37|4|45:65,73;64,75;60,72;63,68;66,63;74,65;70,66;70,70|11166
5935|Ferregard l’Invincible|Ironeye the Invincible|37|37|2|400:87,78|8223,1701,1702,4093,11386
4132|Ravageur silithide|Silithid Ravager|37|37|4|400:68,82|5853,5854,5855,5877
4677|Garde funeste|Doomwarder|37|37|0|405:55,78;54,75;51,78;52,69|6046
14227|Hissperak||37|37|4|405:53,50|1701,1702,4093,11386
5601|Khan Jehn||37|37|0|405:66,80|6072,6067
5602|Khan Shaka||37|37|0|405:40,95|6073,6067
7334|Horreur sanglier de guerre|Battle Boar Horror|37|37|0|722:|3403,2677,3172,2295
6487|Arcaniste Doan|Arcanist Doan|37|37|1|796:|7711,7712,7713,7714,5805
2728|Coyote farouche des rochers|Feral Crag Coyote|37|38|0|3:56,68;59,71;59,68;58,60;59,54;61,56;61,50;54,75|6166,7846,4582
762|Fouille-rivage Perdu|Lost One Riftseeker|37|38|0|8:64,23;62,21;61,24|
761|Prophète Perdu|Lost One Seer|37|38|0|8:60,22;65,20|
4414|Crache-venin Sombrecroc|Darkfang Venomspitter|37|38|0|15:53,15;50,31;37,12;62,38;52,35;60,23;41,26;50,23|5959,12205
4397|Epineuse Rochefange|Mudrock Spikeshell|37|38|0|15:62,16;58,6;60,9;62,28;54,11;61,8;62,21;65,42|5883,3712,4556,4555
4387|Marche-bourbier Fane-liane|Withervine Mire Beast|37|38|0|15:42,18;39,20;44,22;43,21;41,20;40,20;42,28;38,19|
4343|Mordeur Sèchefange|Drywallow Snapper|37|38|0|15:42,45;42,41;38,42;41,45;35,35;40,33;38,45;35,41|3667,770
4363|Oracle Aileron boueux|Mirefin Oracle|37|38|0|15:63,7;64,7;62,7;57,11;58,10;60,9;59,10|4639,5847,5785
4347|Ravageur nuisible|Noxious Reaver|37|38|0|15:42,43;43,43;38,41;40,40;41,44;44,30;46,44;37,45|
1114|Foudroyeur de la Jungle|Jungle Thunderer|37|38|0|33:49,35;44,31;44,32;49,34;43,28;49,32;45,29;42,31|4097,4096,2799
684|Panthère Ombregueule|Shadowmaw Panther|37|38|0|33:41,35;49,23;50,25;49,21;41,40;37,36;39,40;48,27|3838,1686,1688,4301,9719
772|Tigresse de Strangleronce|Stranglethorn Tigress|37|38|0|33:41,35;49,23;50,25;49,21;41,40;37,36;39,40;48,27|3839,1686,1688,12202
2255|Mage Cassecrête|Crushridge Mage|37|38|1|36:41,40;38,40;39,50;40,48;40,44;43,46;46,47;43,48|2843,3658,17202,3875,4301
2245|Saboteur du Syndicat|Syndicate Saboteur|37|38|0|36:57,26;58,30;54,21;57,27;56,28;56,27;48,18;54,20|3505,5113,6986
2580|Ancien busard des mésas|Elder Mesa Buzzard|37|38|0|45:24,71;24,69;22,73;47,82;27,68;16,65;15,70;16,67|11416,1464,3404,5829,11418,5116
2573|Géomètre Sèche-moustache|Drywhisker Surveyor|37|38|0|45:84,31;83,33;84,34;86,33;86,32;87,30;84,30|4435,4479,4480,4481,2928
2591|Magus du Syndicat|Syndicate Magus|37|38|1|45:29,63;26,64;26,65;28,61;29,62|4440,4506,5113,6986,4301
2569|Marteleur Rochepoing|Boulderfist Mauler|37|38|1|45:18,68;22,65;22,68;21,69;20,67;23,67;22,67;24,66|4301,9719
4727|Ancien lézard-tonnerre|Elder Thunder Lizard|37|38|0|405:52,93;51,88;63,72;53,87;74,11;56,86;57,84;62,46|5133,5128
4654|Eclaireur maraudine|Maraudine Scout|37|38|0|405:36,61;31,66;34,56;31,56;31,53;31,61;35,58;33,66|6074,6067
4678|Mange-mana|Mana Eater|37|38|0|405:51,68;53,68|6250,4582
4662|Pattes-d'os magram|Magram Bonepaw|37|38|0|405:70,73;65,77;72,78|4582
11561|Ravageur mort-vivant|Undead Ravager|37|38|0|405:60,88;64,89;64,88;64,83;61,91;60,90;64,92;64,91|2928
4679|Vierge du néant|Nether Maiden|37|38|0|405:50,71;49,78;54,71;50,73;49,79;51,77;51,72;50,77|6251
7352|Ame glacée|Frozen Soul|37|38|1|722:|10581,10570,10574,10572,10567,10578,10573,10582,10571,10584,6046
7348|Goule des épines|Thorn Eater Ghoul|37|38|1|722:|10581,10570,10574,10583,10572,10567,10578,10573,10582,10571,10584,4356,12261,3875
7344|Guerrier Os-brisés|Splinterbone Warrior|37|38|0|722:|
7341|Tisseur de givre squelettique|Skeletal Frostweaver|37|38|1|722:|10570,10574,10583,10572,10567,10578,10573,10582,10571,10584
4298|Défenseur écarlate|Scarlet Defender|37|38|1|796:|5740,7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787
4294|Ensorceleur écarlate|Scarlet Sorcerer|37|38|1|796:|7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787,8226
4295|Myrmidon écarlate|Scarlet Myrmidon|37|38|1|796:|5740,7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,4356,7729,7728,12261,7730,5819,6046
4852|Oracle Cavepierre|Stonevault Oracle|37|38|1|1337:|7666,9426,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420,4356,12261
2830|Busard|Buzzard|37|39|0|3:49,55;62,56;58,74;50,60;50,64;50,78;63,54|7847,11416,556,1464,3404,5829,11418,5116
2735|Elémentaire de roche inférieur|Lesser Rock Elemental|37|39|0|3:15,38;13,39;21,44;21,46;17,43;19,41;19,46;24,45|4626,7848,4553,4784
2742|Psalmodieur Ombreforge|Shadowforge Chanter|37|39|0|3:40,26;40,28;44,31;41,29;43,28;42,27|4616
4850|Rôdeur des cavernes Cavepierre|Stonevault Cave Lurker|37|39|1|1337:|9426,9427,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420,9719
2753|Barnabus||38|38|0|3:46,74;39,68;56,68|
7057|Maître des fouilles Shovelphlange|Digmaster Shovelphlange|38|38|2|3:35,23|
14230|Pique-les-yeux|Burgle Eye|38|38|4|15:59,9|4639,5847,5785
2635|Ancien crocilisque marin|Elder Saltwater Crocolisk|38|38|1|33:33,33;25,19;30,25;29,22|4105,2924,2925,3667,770
4723|Contremaître Cozzle|Foreman Cozzle|38|38|0|33:43,18|5851,3917,1630
14488|Roloch||38|38|4|33:37,31|
814|Sergent Malthus|Sergeant Malthus|38|38|0|33:47,6|
4872|Golem d’obsidienne|Obsidian Golem|38|38|1|38:39,94;38,93;40,91|4553,9393,9428
2932|Magregan Deepshadow||38|38|1|38:38,94|4635
2636|Matelot des Flots noirs|Blackwater Deckhand|38|38|0|45:33,81;33,82;31,81|5789
2599|Otto||38|38|1|45:26,66|4516
4680|Capitaine de la Garde funeste|Doomwarder Captain|38|38|0|405:52,84;53,84;51,83;51,82|6252
2732|Chasseresse des récifs|Ridge Huntress|38|39|0|3:50,60;65,68;44,74;61,62;63,74;30,50;32,47;40,73|1686,1688,12202
2723|Golem de pierre|Stone Golem|38|39|0|3:40,27;41,26;40,28;42,27;42,28;42,29|4553,24232
2743|Guerrier Ombreforge|Shadowforge Warrior|38|39|0|3:42,34;44,29;40,27;44,31;42,30;43,31;44,34;42,27|4616,2928
2701|Ogre Crache-poussières|Dustbelcher Ogre|38|39|0|3:63,68;62,70;29,57;30,56|4630
1082|Crocilisque Dents-de-scie|Sawtooth Crocolisk|38|39|0|8:54,56;70,19;62,30;55,50;57,52;55,41;57,35|6169,3667,770,4356
764|Maraistreur|Swampwalker|38|39|0|8:47,37;49,35;51,37;15,39;16,37;17,39;11,39;13,37|6065,11205
4344|Crocilisque tacheté Sèchefange|Mottled Drywallow Crocolisk|38|39|0|15:36,61;35,55;40,49;37,61;40,59;45,51;43,56;40,50|3667,770
4348|Déchiqueteur nuisible|Noxious Shredder|38|39|0|15:39,51;42,58;40,48;38,49;38,56;49,63;44,62;41,52|
4385|Rageur Fane-liane|Withervine Rager|38|39|0|15:41,18;41,20;38,18;37,15;44,20;39,23;43,23|
4412|Rampant Sombrecroc|Darkfang Creeper|38|39|0|15:44,35;43,41;35,45;50,60;38,55;48,60;45,37;34,46|5959,12205
4379|Tisseuse de Sombrebrume|Darkmist Silkspinner|38|39|0|15:31,22;31,23;33,23;32,22;34,21;35,24;35,23;36,21|5884,5959,12205
2246|Assassin du Syndicat|Syndicate Assassin|38|39|0|36:38,15;41,21;41,20;39,15;40,15;40,16;41,17|11206,3505,5113,6986,4301
2256|Massacreur Cassecrête|Crushridge Enforcer|38|39|1|36:40,51;40,49;38,53;37,51;38,49;40,56;38,60;37,56|2843,3658,17202,4301
2570|Chaman Rochepoing|Boulderfist Shaman|38|39|1|45:19,67;18,69;21,66;20,67;21,67;22,67;20,69;20,68|4527
2595|Ecumeur Daguéchine|Daggerspine Raider|38|39|0|45:23,86;26,91;21,90;25,85;23,85;22,87;19,85|4375,7072
2760|Exilé ardent|Burning Exile|38|39|0|45:26,29;26,28;24,29;26,31;26,30;25,31;25,32|4483,6991,4479,4787
2762|Exilé foudroyant|Thundering Exile|38|39|0|45:52,49;52,50;52,51;51,52;53,49;50,51;52,48;53,51|4480,7069
2761|Exilé grimpeur|Cresting Exile|38|39|0|45:67,29;65,31;65,29;67,31;68,30;65,30|4481,4791,7070
2592|Exilé grondant|Rumbling Exile|38|39|0|45:37,61;36,61;35,56;37,59;38,56;35,57;37,58|4553,4784
4657|Chasse-vent maraudine|Maraudine Windchaser|38|39|0|405:30,61;32,54;30,55;29,54;31,52;30,58;31,59;31,61|6074,6067
4681|Chasseur de mages|Mage Hunter|38|39|0|405:57,75;56,73;57,78;58,76;54,77;56,78;53,79|6250,4582,2928
4699|Empoisonneur scorpashi|Scorpashi Venomlash|38|39|0|405:59,72;46,87;29,82;51,92;55,86;62,76;47,87;61,73|6248,19938,19937,4872,4867
4686|Géant Arpentefonds|Deepstrider Giant|38|39|1|405:66,33|6082,15924
4668|Invocateur de la Lame ardente|Burning Blade Summoner|38|39|0|405:80,77;80,78;79,81;82,81;82,80;52,82;53,78;50,72|7291,20310,6986
4656|Marteleur maraudine|Maraudine Mauler|38|39|0|405:31,51;33,53;33,55;32,56;29,52;30,58;33,60|6074,4301,6067
4682|Sœur du néant|Nether Sister|38|39|0|405:53,85;54,79;54,78;55,77|6251
7346|Centurion Os-brisés|Splinterbone Centurion|38|39|0|722:|3875,9719
7347|Goule Ecorcheuse-d'os|Boneflayer Ghoul|38|39|1|722:|10581,10570,10574,10583,10572,10567,10578,10573,10582,10571,10584,12261,8384
4301|Centurion écarlate|Scarlet Centurion|38|39|1|796:|7758,7760,24232,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,4356,7729,7728,7730,5819,7752,7753
4300|Sorcier écarlate|Scarlet Wizard|38|39|1|796:|7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,4356,7729,7728,12261,7730,5819,6046,7752
4861|Chauve-souris hurlante|Shrike Bat|38|39|1|1337:|11393,11394,11391,11392,9426,9427,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396,9406,9428,9384
2729|Ancien coyote des rochers|Elder Crag Coyote|38|40|0|3:42,71;39,70;39,67;28,72;35,64;13,67;24,59;30,64|6166,7846,4582
14356|Nagescie frénétique|Sawfin Frenzy|38|40|0|8:66,52;74,52;68,46;67,57;73,60;70,60;74,56;72,48|
4392|Limon des marais corrosif|Corrosive Swamp Ooze|38|40|0|15:45,58;44,59;54,58;49,56;54,55;52,55;53,53;48,52|20766,20763
763|Chef Perdu|Lost One Chieftain|39|39|4|8:62,21;61,23;60,20;62,23;64,21|
5477|Noboru le Gourdin|Noboru the Cudgel|39|39|0|8:56,34|6196
2422|Glommus||39|39|1|36:40,42|3552
2417|Grel'borg l'Avare|Grel'borg the Miser|39|39|1|36:36,54|3684,4646
2453|Lo'Grosh||39|39|4|36:52,47;48,32|
2598|Darbel Montrose||39|39|2|45:27,61;28,61;29,63;25,62;28,62;28,63;29,66;27,65|
4063|Feeboz||39|39|0|45:68,38|
2793|Kor'gresh Coldrage||39|39|0|45:55,82|4525
2604|Molok l’Anéantisseur|Molok the Crusher|39|39|4|45:55,80;53,80;55,82|4305
2765|Znort||39|39|0|45:68,38|
7357|Mordresh Oeil-de-feu|Mordresh Fire Eye|39|39|1|722:|10769,10770,10771
2893|Briseur d’os Cavepierre|Stonevault Bonesnapper|39|40|0|3:50,64;49,72;51,70;51,68;51,66;52,66;50,67;50,72|5797,4356,9719
2715|Brute Crache-poussières|Dustbelcher Brute|39|40|0|3:30,57;63,70|4630
6733|Cogneur Cavepierre|Stonevault Basher|39|40|1|3:64,42;64,45;66,45|5797
92|Elémentaire de roche|Rock Elemental|39|40|0|3:45,81;44,86;43,82;37,74;42,77;41,78;37,76;15,34|4627,7848,4553,4784,9719
2892|Prophète Cavepierre|Stonevault Seer|39|40|1|3:64,41;65,41;66,44;65,44|5797
765|Ancien Maraistreur|Swampwalker Elder|39|40|0|8:13,33;10,32|6065,11205
768|Panthère des ombres|Shadow Panther|39|40|0|8:84,59;69,12;71,10;74,25;87,29;89,36;88,31;71,11|6080,1686,1688
4401|Claqueur Bourbecoque|Muckshell Clacker|39|40|0|15:49,37;59,44;52,40;60,62;59,46;54,46;56,62;58,45|5942
4394|Limon des marais bouillonnant|Bubbling Swamp Ooze|39|40|1|15:49,56;49,52;53,52;52,60;52,55;48,55;53,57;55,55|20767,20763
4356|Tranchegueule rougefange|Bloodfen Razormaw|39|40|0|15:32,64;34,70;34,69;36,70;32,66;33,65|4586,4461,4587,12184
690|Basilic Oeil-de-glace|Cold Eye Basilisk|39|40|0|33:29,41;31,37;29,39;28,43;28,42;36,42;37,43;36,43|2476,3918,1701,1702,4093,11386
813|Colonel Kurzen||39|40|1|33:50,4|3615
667|Guerrier Skullsplitter|Skullsplitter Warrior|39|40|0|33:47,39;49,41;47,40;44,39;48,41;46,32;42,35;44,34|3916,1524,4356,12261
696|Lanceur de haches Skullsplitter|Skullsplitter Axe Thrower|39|40|0|33:47,39;49,41;47,40;44,39;48,41;46,32;42,35;44,34|3916,1524,9719
780|Mystique Skullsplitter|Skullsplitter Mystic|39|40|0|33:47,39;49,41;47,40;44,39;48,41;46,32;42,35;44,34|2466,3916,1524
2287|Combattant Cassecrête|Crushridge Warmonger|39|40|1|36:35,53;36,54;36,53;36,56;36,55;36,51;39,60|1602,9144,9179,2843,3658,9036,17202
2247|Massacreur du Syndicat|Syndicate Enforcer|39|40|0|36:39,13;39,21;38,22;39,15;40,19;43,18;38,17|3505,5113,6986,8384
2571|Seigneur Rochepoing|Boulderfist Lord|39|40|1|45:19,69;18,68;18,69;20,66;19,66;21,68;18,67;20,69|5173
2596|Sorcière Daguéchine|Daggerspine Sorceress|39|40|0|45:18,87;22,90;22,84;24,85;21,85;21,84|7072
4685|Chasseur Ley|Ley Hunter|39|40|0|405:79,82;79,81;82,76;80,77;79,77;54,85;52,86;50,81|6250,4582
4687|Chercheur Arpentefonds|Deepstrider Searcher|39|40|1|405:32,25|6082,15874,15924
4694|Déchiqueteur de l’effroi|Dread Ripper|39|40|0|405:62,80;60,79;63,71;60,76;55,86;61,74;62,76;30,81|11416,556,1464,3404,5829,11418,5116
4684|Ensorceleuse du Néant|Nether Sorceress|39|40|0|405:51,83;52,83;52,85;52,84|6251
4705|Invocateur de la Lame ardente|Burning Blade Invoker|39|40|0|405:82,81;80,78;81,77;80,79|20310,6986
4658|Légion-tempête maraudine|Maraudine Stormer|39|40|0|405:31,51;29,55;29,51|6074,6067
4659|Maraudeur maraudine|Maraudine Marauder|39|40|0|405:29,61;29,58|6074,24281,6067
11559|Nécromancien renégat|Outcast Necromancer|39|40|0|405:63,89;64,90;60,90;65,90|6067
7345|Capitaine Os-brisés|Splinterbone Captain|39|40|1|722:|10581,10574,10583,10572,10567,10573,10571,10584
7353|Esprit glacial|Freezing Spirit|39|40|1|722:|10581,10570,10574,10583,10572,10567,10578,10573,10582,10571,10584,8384,9719
7342|Invocateur squelettique|Skeletal Summoner|39|40|1|722:|10581,10570,10574,10583,10572,10567,10578,10582,10571,10584
4303|Abbé écarlate|Scarlet Abbot|39|40|1|796:|7758,7760,7736,1992,7755,7759,5756,7757,2262,8225,7761,10332,7729,7728,7730,5819,7752,7753,7787,8226
4302|Champion écarlate|Scarlet Champion|39|40|1|796:|7758,7760,7736,1992,7755,7759,5140,5756,7757,2262,8225,7761,10332,7729,7728,12261,7730,5819,6046,7752
4863|Basilic Jadéchine|Jadespine Basilisk|39|40|1|1337:|4234,9426,9432,5833,9381,9424,1701,1702,9386,9392,9397,9396,9406,4093,9428,11386,9384,9420
4847|Chasseur de reliques Ombreforge|Shadowforge Relic Hunter|39|40|1|1337:|8009,8052,9427,9432,9383,5833,9424,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420
7022|Scorpide empoisonneur|Venomlash Scorpid|39|40|1|1337:|19938,9422,9431,19937,9426,9427,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396,9406,9428,9384
2831|Busard géant|Giant Buzzard|39|41|0|3:29,72;17,61;16,62;16,59;17,60;12,68;26,62;24,76|7847,11416,556,1464,3404,5829,11418,5116
4393|Limon des marais acide|Acidic Swamp Ooze|39|41|0|15:50,50;55,54;52,53;52,56;53,55;53,59;52,57|20766,20763
1561|Ecumeur de la Voile sanglante|Bloodsail Raider|39|41|0|33:32,72;33,74;33,73;32,73;28,70;28,69;27,70|21174,5789,8494,3897,3910,9260
1562|Mage de la Voile sanglante|Bloodsail Mage|39|41|0|33:32,73;28,70;28,69;27,70;26,67;27,68;26,66;29,71|8494,3897,3910,9260,4301
2744|Commandant Ombreforge|Shadowforge Commander|40|40|4|3:41,30|4655,4611,2143
2749|Golem de siège|Siege Golem|40|40|2|3:20,57;16,59;9,62;16,65;25,56;25,50;31,50;36,42|
4380|Veuve de Sombrebrume|Darkmist Widow|40|40|4|15:31,20|5884,5959,12205
728|Bhag'thera||40|40|1|33:50,24|3876,1686,1688,12202
2624|Gazban||40|40|0|33:23,24|4034
1062|Nezzliok le Redoutable|Nezzliok the Dire|40|40|0|33:24,10|3905
2306|Baron Vardus||40|40|0|36:48,17|3626
2421|Fouilleboue|Muckrake|40|40|1|36:39,47|3551
2320|Nagaz||40|40|0|36:39,14|3672
2609|Géomancien Dague-de-silex|Geomancer Flintdagger|40|40|4|45:83,32|
2783|Marez Cowl||40|40|1|45:30,63|4510,4515,12261
2773|Or'Kalar||40|40|1|45:19,66;21,65;20,68;19,69|4551
2597|Seigneur Falconcrest|Lord Falconcrest|40|40|1|45:26,66|4517
2764|Sleeby||40|40|0|45:68,38|
2605|Zalas Witherbark||40|40|4|45:65,73;61,72;68,78;70,78;66,82;67,81;67,82;69,81|11166,4503
10262|Opus||40|40|0|46:66,22|5173,5140,2928
2347|Gryphon sauvage|Wild Gryphon|40|40|0|267:79,35;87,42|4304,4591,4589,4590
5771|Jugkar Grim'rod||40|40|0|405:56,78|
14226|Kaskk||40|40|4|405:51,86|6252
5760|Seigneur Azrethoc|Lord Azrethoc|40|40|1|405:57,76|6252
14686|Dame Falther'ess|Lady Falther'ess|40|40|1|722:|23177,23178,10572
8567|Glouton|Glutton|40|40|1|722:|10772,10774
7354|Groinfendu|Ragglesnout|40|40|1|722:|10758,10767,10768
3975|Herod||40|40|1|796:|7717,7718,7719,5805,10328
6910|Revelosh||40|40|1|1337:|7741,9387,9388,9389,9390
2894|Chaman Cavepierre|Stonevault Shaman|40|41|0|3:50,66;48,68;50,70;50,68;51,67|5797
2716|Chasseur Wyrm Crache-poussières|Dustbelcher Wyrmhunter|40|41|0|3:13,74;12,76;8,72;8,78;11,78;11,74|4630
2734|Patriarche Traqueur des récifs|Ridge Stalker Patriarch|40|41|0|3:15,52;8,58;28,67;26,64;15,56;18,67;20,62;20,60|4580,1688,12202,9719
922|Clampant des vases|Silt Crawler|40|41|0|8:79,5;76,5;77,5;79,8;81,9;86,83;84,15;88,20|5938,12206,5569,3010
766|Horreur enchevêtrée|Tangled Horror|40|41|0|8:74,72;68,32;77,31;60,36;57,50;84,73;8,34;77,73|6065,11205
769|Tarentule mortelle|Deathstrike Tarantula|40|41|0|8:61,69;59,60;65,70;76,89;67,79;70,80;71,69;60,62|3875,12205
4415|Araignée Sombrecroc géante|Giant Darkfang Spider|40|41|0|15:56,67;53,66;51,63;52,48;56,56;51,48;50,46;50,48|5959,12205
4402|Claque-pinces Bourbecoque|Muckshell Snapclaw|40|41|0|15:60,49;60,52;62,52;60,56;60,60;61,54;61,50;61,45|5942
4345|Crocs-lames Sèchefange|Drywallow Daggermaw|40|41|0|15:50,80;51,62;55,74;39,70;53,71;38,71;48,80;41,69|3667,770
4357|Flagellant Rougefange|Bloodfen Lashtail|40|41|0|15:38,69;34,72;33,71;38,68;31,66;33,64;34,64;34,65|4586,4461,4587,12184,4356
4388|Jeune batteur des boues|Young Murk Thresher|40|41|0|15:69,59;70,58;69,58;70,55;69,56;72,55;74,46;72,52|5516,2608
1557|Ancien gorille de Valbrume|Elder Mistvale Gorilla|40|41|0|33:34,63;34,67;34,68;32,66;31,67;31,60;33,66;34,65|3862,3919,4097,4096,2799
677|Bricoleur de la KapitalRisk|Venture Co. Tinkerer|40|41|0|33:42,45;42,42;41,44|4387,3917,4389,1630,4377,4382
674|Carrier de la KapitalRisk|Venture Co. Strip Miner|40|41|0|33:42,44;42,45;42,46;42,43;42,41;41,42;40,44|11203,3917,1630
2544|Clampant des sables du sud|Southern Sand Crawler|40|41|0|33:28,86;32,83;35,88;32,87;29,88;30,86;31,88|2290,1711,12206,5569,3010
687|Traqueur de la jungle|Jungle Stalker|40|41|0|33:23,48;35,40;31,42;33,37;30,44;28,47;25,51;26,50|1712,3863,3012,4422,4586,4461,4587,12184
2649|Scalpeur Witherbark|Witherbark Scalper|40|41|0|47:22,58;23,58;24,57;24,55;25,56;25,58;25,59|9320,9259
5249|Bâtard Griffebois|Woodpaw Mongrel|40|41|0|357:69,51;72,37;71,55;70,54;76,54;73,36;74,37|9237,24231,2928
5286|Messager Longues-dents|Longtooth Runner|40|41|0|357:89,39;69,44;88,38;31,52;70,42;76,37;77,41;31,49|
5229|Ogre Gordunni|Gordunni Ogre|40|41|0|357:75,26;75,25;74,27;81,35;77,30;75,30;76,35|15793,15794,15798
11785|Basilic Oeil-d'ambre|Ambereye Basilisk|40|41|1|405:34,68;35,61;33,68;30,65;34,64;35,64;34,60;34,62|1701,1702,4093,11386
11781|Ecraseur Ambréclat|Ambershard Crusher|40|41|1|405:32,64;30,64|4553,7075,4784
11686|Ecumeur fantomatique|Ghostly Raider|40|41|0|405:30,61;28,63;27,63;29,62;30,63;31,62;28,62;28,65|
11787|Fouisseur des rochers|Rock Borer|40|41|1|405:27,55;28,54;27,56;30,57;28,56;28,55;29,56|6046,3875
11777|Grondeur Ombréclat|Shadowshard Rumbler|40|41|1|405:27,53;30,56;27,57;28,54;27,58;28,58;29,58;28,56|17756,4553,7075,4784
5616|Larron Bat-le-désert|Wastewander Thief|40|41|0|440:64,31;63,33;60,24;65,33;64,33;60,23;64,30|8398,8483,9358
5422|Scorpide chasseur|Scorpid Hunter|40|41|0|440:51,35;63,23;56,33;53,22;64,27;54,32;57,31;53,36|9442,19935,19936,19937,4872,4867
7030|Géologue Ombreforge|Shadowforge Geologist|40|41|1|1337:|8009,8052,5833,9381,9391,9386,9392,9393,9396,9406,9428,9384,9420
11685|Prêtre maraudine|Maraudine Priest|40|42|0|405:28,63|
14224|7:XT||41|41|4|3:55,84;54,54;24,52;29,69;20,78;14,67;3,80|9060,10561,9061,10505,7191
14234|Hayoc||41|41|4|15:52,63|
1061|Gan'zulah||41|41|0|33:23,8|3904
2423|Seigneur Aliden Perenolde|Lord Aliden Perenolde|41|41|0|36:39,15|
2420|Targ||41|41|1|36:40,53|3550,17202
2779|Prince Nazjak||41|41|4|45:19,90|7072
7358|Amnennar le Porte-froid|Amnennar the Coldbringer|41|41|1|722:|10420,10761,10762,10763,10764,10765
5186|Requin pèlerin|Basking Shark|41|41|1|2257:|5567,537
2944|Boss Tho'grun||41|42|0|3:13,75|4640
2717|Marteleur Crache-poussières|Dustbelcher Mauler|41|42|0|3:9,76;13,74;11,76;14,76;14,75;10,84;9,80;8,82|4630,6046
1087|Mordeur Dents-de-scie|Sawtooth Snapper|41|42|0|8:77,6;80,7;76,19;87,34;84,15;80,31;76,97;83,12|6168,6169,3667,770
747|Murloc des marais|Marsh Murloc|41|42|0|8:83,94;86,85;87,85;84,89;86,87;84,94;87,81|
742|Wyrmide vert|Green Wyrmkin|41|42|0|8:72,70;60,52;66,64;89,66|5803,11914,11948
4329|Eclaireur Crins-de-feu|Firemane Scout|41|42|0|15:45,82;42,68;47,78;42,66;39,64;39,66;38,69;43,66|
4323|Jeune incendiaire|Searing Hatchling|41|42|0|15:54,71;52,68;45,77;42,81;45,82;47,72;48,81;47,67|5840,5841,4402
4403|Pinceur Bourbecoque|Muckshell Pincer|41|42|0|15:61,69;60,61;59,69;61,66;61,67;55,63;59,67;61,68|5942
1550|Basilic flagelleur|Thrashtail Basilisk|41|42|0|33:39,49;40,52;39,52;38,50;39,47;40,51;41,50;41,51|3918,4092,11387,4093,11386,3875
784|Belluaire Skullsplitter|Skullsplitter Beastmaster|41|42|0|33:44,43;44,41;45,42;47,41|3916,1524,5140
669|Chasseur Skullsplitter|Skullsplitter Hunter|41|42|0|33:46,43;45,40;45,44;47,39;45,42;46,39;46,44|3916,1524
709|Combattant Mosh'Ogg|Mosh'Ogg Warmonger|41|42|1|33:50,31;47,25;48,31;49,31;50,28;48,30;49,29|3930
782|Eclaireur Skullsplitter|Skullsplitter Scout|41|42|0|33:46,43;46,42;45,44;45,42;44,42|3916,1524,5140
676|Géomètre de la KapitalRisk|Venture Co. Surveyor|41|42|0|33:42,45;42,46;41,44|3917,1630
670|Sorcier-docteur Skullsplitter|Skullsplitter Witch Doctor|41|42|0|33:46,43;44,42;46,42;45,42|2466,3916,1524
2923|Crins-d'argent galeux|Mangy Silvermane|41|42|0|47:22,48;15,56;22,53;21,50;20,57;21,55;18,48;17,49|
2650|Zélote Witherbark|Witherbark Zealot|41|42|0|47:22,57;24,57;23,58;24,58;23,56;25,57;24,55;25,59|9320,9259
5253|Brute Griffebois|Woodpaw Brute|41|42|0|357:77,54;70,51;70,52;71,54;76,54;73,39;73,40;73,37|9237
5332|Chevaucheur des vagues Hainecrête|Hatecrest Wave Rider|41|42|0|357:34,55;27,57;29,56;27,55;28,55;27,53|9247
5335|Hurleuse Hainecrête|Hatecrest Screamer|41|42|0|357:33,55;31,57;30,55;28,54;25,50;28,52;29,54|9247,24231
7726|Naturaliste du Totem sinistre|Grimtotem Naturalist|41|42|0|357:69,40;69,47;67,46;69,38;70,39;67,39;66,39;67,38|9460
5237|Ogre-mage Gordunni|Gordunni Ogre Mage|41|42|0|357:75,34;76,33;75,29;80,35;79,34;76,30;75,28|15793,15794,15798
5268|Ours Ferpoil|Ironfur Bear|41|42|0|357:90,39;72,35;85,38;71,41;71,45;85,46;56,54|6258,11408,11409,11410
5251|Trappeur Griffebois|Woodpaw Trapper|41|42|0|357:77,54;72,38;70,51;70,53;76,53;76,55;73,39|9237,12261
11786|Déchireur Oeil-d'ambre|Ambereye Reaver|41|42|1|405:30,65;33,64;37,61;36,61;35,63;34,61;37,63;35,61|4092,11387,4093,11386
11778|Fracasseur Ombréclat|Shadowshard Smasher|41|42|1|405:28,54;27,54;27,55;28,58;28,57;30,56|17756,7075,4784
11687|Maraudeur fantomatique|Ghostly Marauder|41|42|0|405:30,61;28,63;27,63;29,62;30,63;31,62;28,62;28,65|4356
11788|Ver des rochers|Rock Worm|41|42|1|405:29,53;27,56;28,56;27,55;30,58;29,57;29,56;28,57|
5618|Bandit Bat-le-désert|Wastewander Bandit|41|42|0|440:59,25;64,29;66,32;60,25;61,23;63,30;63,33;61,24|8395,8483
5425|Brûlepatte affamée|Starving Blisterpaw|41|42|0|440:49,28;35,28;52,35;61,28;54,37;47,26;54,34;42,27|9439
2725|Dragonnet flamboyant|Scalding Whelp|41|43|0|3:81,31;86,29;81,37;83,33;78,34;72,65;70,54;73,63|4844,4845,4612,4843,10822,4402,4557
4389|Batteur des boues|Murk Thresher|41|43|0|15:53,39;49,41;52,42;52,41;53,43;56,45;51,37;47,34|5516,2608
1563|Bretteur de la Voile sanglante|Bloodsail Swashbuckler|41|43|0|33:24,54;28,82;27,83;33,77;31,81|8494,3897,3910,9260
1564|Démoniste de la Voile sanglante|Bloodsail Warlock|41|43|0|33:23,54;24,53;34,87;30,81;28,83;30,88|8494,3897,3910,9260,3875
2549|Garr Salthoof||41|43|0|33:29,89|3897,3910
5307|Hurleur des vallées|Vale Screecher|41|43|0|357:58,59;57,55;58,58;60,62|
5617|Mage de l'ombre Bat-le-désert|Wastewander Shadow Mage|41|43|0|440:62,35;59,39;59,36;61,33;60,33;64,38;65,40|8397,8483,9357
5428|Roc||41|43|0|440:41,25;50,36;35,29;49,28;49,36;57,32;49,37|6257,556,1464,3404,12207,5829,11418,11417
2745|Ambassadeur Infernus|Ambassador Infernus|42|42|1|3:42,29|4621,7848,4787,7077
2945|Murdaloc||42|42|0|3:50,66|
14448|Rougeronce|Molt Thorn|42|42|4|8:34,39;41,32;37,37;31,37;27,38;28,46;31,51;33,45|11205
1081|Seigneur du bourbier|Mire Lord|42|42|0|8:6,31|6081,6065,11205
14237|Ver de limon|Oozeworm|42|42|4|15:36,63;39,63;35,71|
8386|Marin de l'Horizon|Horizon Scout Crewman|42|42|0|16:53,88;50,92|4471,5526,4388
675|Contremaître de la KapitalRisk|Venture Co. Foreman|42|42|0|33:42,43|1652,3917,1630
14491|Kurmokk||42|42|4|33:38,61|4096,4099,2799
14492|Verifonix||42|42|4|33:37,57;37,54;36,54;35,56;36,56;37,56|1652,3917,1630
2601|Foulbelly||42|42|2|45:20,67;21,66;19,69;18,69|
2611|Fozruk||42|42|1|45:68,38|4469
8211|Vieux Saute-falaise|Old Cliff Jumper|42|42|4|47:12,54|
5356|Grogneur|Snarler|42|42|4|357:80,40|
3976|Commandant écarlate Mograine|Scarlet Commander Mograine|42|42|1|796:|7723,7724,7726,10330,5805,10328
3977|Grand Inquisiteur Whitemane|High Inquisitor Whitemane|42|42|1|796:|7720,7721,7722,5805,10328
7023|Sentinelle d'obsidienne|Obsidian Sentinel|42|42|1|1337:|8053,9425,9431,9426,9427,5833,9424,9393,9396,9428,9384,9420
2718|Chaman Crache-poussières|Dustbelcher Shaman|42|43|0|3:8,76;12,75;14,75;9,86;11,80;10,78;8,84|4630
2730|Coyote des rochers enragé|Rabid Crag Coyote|42|43|0|3:70,34;69,31;69,36;71,35;70,33;73,33|6166,7846
2791|Elémentaire de roche enragé|Enraged Rock Elemental|42|43|0|3:54,82;55,86;56,83;56,87;54,84;57,84;55,82|4518,4519,4520,7848,7075,4784
750|Cracheur des marais|Marsh Inkspewer|42|43|0|8:62,81;90,76;87,83;93,67;64,88;84,87;84,91;95,59|
743|Marcherêve wyrmide|Wyrmkin Dreamwalker|42|43|0|8:60,57;64,64;62,60;71,67;61,53;90,57;90,62|5803
744|Plaiedécaille vert|Green Scalebane|42|43|0|8:77,69;78,71;61,39;65,42;64,39;62,37;62,42;61,43|5803
4324|Dragonnet incendiaire|Searing Whelp|42|43|0|15:43,82;48,79;45,70;49,68;55,83;43,79;46,83;42,66|5840,5841,10822,4304,4402
4404|Fouilleur Bourbecoque|Muckshell Scrabbler|42|43|0|15:56,65;60,67;49,39;62,67;57,60;60,58;56,62;60,69|5942
4331|Queue-cendrée Crins-de-feu|Firemane Ash Tail|42|43|0|15:45,82;46,67;42,66;44,65;37,69;38,67;45,65;46,66|
1713|Ancienne panthère Ombregueule|Elder Shadowmaw Panther|42|43|0|33:35,56;36,57;36,58;31,59;37,56;37,55;36,55|3838,4580,1688
2547|Oeil de fer|Ironpatch|42|43|0|33:31,90|3910
1558|Patriarche Dos argenté|Silverback Patriarch|42|43|0|33:36,63;35,63;38,61;37,62;38,62;36,62;36,64|3080,4096,4099,2799
2927|Chouettard vicieux|Vicious Owlbeast|42|43|0|47:34,63;37,46;34,62;34,52;36,51;26,67;27,60;26,61|9591,9592,12207,11417
2651|Ecorcheur Witherbark|Witherbark Hideskinner|42|43|0|47:28,58;31,59;33,58;33,59;33,57;30,61;30,60;29,57|9320,4589,6887,9259,4301
5232|Brute Gordunni|Gordunni Brute|42|43|0|357:75,25;61,55;77,33;80,35;79,34;62,54;61,58;59,65|15793,15794,15798
7725|Ecumeur du Totem sinistre|Grimtotem Raider|42|43|0|357:67,39;66,48;67,46;66,47;69,38;69,39|9460,9355,9357
5331|Guerrier Hainecrête|Hatecrest Warrior|42|43|0|357:33,50;34,51;30,58;26,54;27,54;29,52;29,54;30,53|9247,11914,11948,2928
5254|Mystique Griffebois|Woodpaw Mystic|42|43|0|357:77,57;78,56;67,56;70,56;69,56;72,57|9237,2928
5255|Ravageur Griffebois|Woodpaw Reaver|42|43|0|357:66,53;77,56;67,53;76,56;69,55;69,56;72,57;74,56|9237
5260|Singe Groddoc|Groddoc Ape|42|43|0|357:62,64;75,51;58,58;73,54;61,61;60,60;58,56;59,59|6259,4096,4099,2799
5337|Sirène Hainecrête|Hatecrest Siren|42|43|0|357:33,53;32,57;33,56;32,56;25,55;29,57;30,57;28,55|9247
11782|Destructeur Ambréclat|Ambershard Destroyer|42|43|1|405:35,61;34,65|7075,4784
5419|Basilic Peau-de-verre|Glasshide Basilisk|42|43|0|440:53,23;52,39;50,39;45,23;35,26;46,26;43,34;56,36|9437,4092,11387,4093,11386,3875
5645|Dépeceur Sandfury|Sandfury Hideskinner|42|43|1|440:42,23;36,25;41,30;41,29;40,30;40,28;40,21|
14123|Mordeuse mâchoire d'acier|Steeljaw Snapper|42|43|0|440:66,22;68,40;67,18;67,20;68,30;68,22;67,38;68,35|10505,8167,9357,9358,3712,4556,4555
7011|Brise-roc terrestre|Earthen Rocksmasher|42|43|0|1337:|5833
7405|Scorpide de la Faille mortel|Deadly Cleft Scorpid|42|43|0|1337:|19935,19936,19937,4872,4867
7012|Sculpteur terrestre|Earthen Sculptor|42|43|0|1337:|9422,9425,9429,9431,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420
12217|Corrupteur|Corruptor|42|43|0|2100:|
12216|Fée empoisonnante|Poison Sprite|42|43|0|2100:|17684
11792|Traqueur des ombres Putridus|Putridus Shadowstalker|42|43|1|2100:|17684
2736|Elémentaire de roche supérieur|Greater Rock Elemental|42|44|0|3:5,77;3,78;4,80;2,85;5,84;16,90;15,86;14,90|4628,7848,3875,7075,4784
4506|Mousse de la Voile sanglante|Bloodsail Swabby|42|44|0|33:33,88;29,89;31,90|8494,3897,3910,9260
15692|Kindnappeur Sombrefer|Dark Iron Kidnapper|42|45|0|51:68,33;68,36;69,34;69,33;70,34;70,33|
14446|Fingat||43|43|4|8:61,84|
14447|Gilmorian||43|43|4|8:96,64|
2551|Brutus||43|43|0|33:33,88|3897,3910
731|Roi Bangalash|King Bangalash|43|43|1|33:38,36|3880,4581,4580,12202
730|Téthis|Tethis|43|43|1|33:29,45;28,43;32,43|3877,4588,4461,4587,12184
2257|Mug'thol||43|43|1|36:36,54|3553,3554
2652|Venimeux Witherbark|Witherbark Venomblood|43|43|0|47:31,57;32,58;33,60;30,62;30,59;30,57|9320,6887,9259
8219|Zul'arek Volaillaîne|Zul'arek Hatefowler|43|43|4|47:32,57|9259
11688|Centaure maudit|Cursed Centaur|43|43|4|405:30,60|17684
8208|Brûlepatte meurtrier|Murderous Blisterpaw|43|43|4|440:52,33|9439
2720|Ogre-mage Crache-poussières|Dustbelcher Ogre Mage|43|44|0|3:7,91;8,90;8,92;9,88;8,86;9,91;8,88;10,89|4630,9262
745|Capitaine Plaiedécaille|Scalebane Captain|43|44|0|8:78,68;77,65;76,67;62,45;75,41;81,42;82,41;81,52|5803
1088|Clampant monstrueux|Monstrous Crawler|43|44|0|8:74,98;91,20;94,62;93,30;94,33;96,46;95,56;94,36|6184,5938,12206,5569,3010
751|Dévoreur des marais|Marsh Flesheater|43|44|0|8:62,81;71,98;95,51;65,89;63,88;62,83;94,53|
4334|Implorateur des flammes Crins-de-feu|Firemane Flamecaller|43|44|0|15:54,84;57,75;55,75;52,83;50,83;48,76;53,75;49,75|
4328|Plaiedécaille Crins-de-feu|Firemane Scalebane|43|44|0|15:58,79;56,81;49,76;53,73;54,73;52,75;37,67;38,70|
1551|Basilic gueule de fer|Ironjaw Basilisk|43|44|0|33:43,48;44,48;43,49;44,49;43,47;43,46;42,47|3911,3918,4092,11387,4093,11386
783|Berserker Skullsplitter|Skullsplitter Berserker|43|44|0|33:43,44;48,44;47,45;44,45;47,44|3916,1524
679|Chaman Mosh'Ogg|Mosh'Ogg Shaman|43|44|1|33:50,30;50,31;52,28;51,28;51,27|3930
1489|Chasseur Zanzil|Zanzil Hunter|43|44|0|33:39,59;34,52|4016
781|Chasseur de têtes Skullsplitter|Skullsplitter Headhunter|43|44|0|33:44,46;48,43;48,44;46,45|3916,1524
2537|Chucky "Dix pouces"|Chucky "Ten Thumbs"|43|44|0|33:40,58|3926,4016
1907|Explorateur naga|Naga Explorer|43|44|0|33:28,62;28,63;27,63;27,61;25,64;26,63;24,62;25,59|4029
2536|Jon-Jon le Corbeau|Jon-Jon the Crow|43|44|0|33:35,52|3925,4016
710|Magicien Mosh'Ogg|Mosh'Ogg Spellcrafter|43|44|1|33:52,27;51,27;52,28;51,28;50,31|3930,4356
4505|Matelot de la Voile sanglante|Bloodsail Deckhand|43|44|0|33:29,89;33,88;34,88;31,90|8494,3897,3910,9260
2535|Maury "Pied bot" Wilkins|Maury "Club Foot" Wilkins|43|44|0|33:35,51|3924
678|Mutileur Mosh'Ogg|Mosh'Ogg Mauler|43|44|1|33:52,29;51,27;51,28;50,28;52,27;53,28|3930
1488|Zombie Zanzil|Zanzil Zombie|43|44|0|33:41,57;40,58;35,52;39,58;34,51;41,59;35,51|4016
2924|Loup Crins-d'argent|Silvermane Wolf|43|44|0|47:36,45;34,46;36,49;32,63;34,54;33,64;27,55|
5839|Géologue Sombrefer|Dark Iron Geologist|43|44|0|51:69,33;69,34;63,62;64,60;63,61;63,60;64,59|10551,11370
5258|Alpha Griffebois|Woodpaw Alpha|43|44|0|357:66,53;65,54;66,52;65,52;75,56;69,56;73,56;72,57|9237
7727|Chaman du Totem sinistre|Grimtotem Shaman|43|44|0|357:66,48;69,47;68,46;67,46;69,39;70,40;67,39|9460
5240|Démoniste Gordunni|Gordunni Warlock|43|44|0|357:61,72;59,70;58,73;61,71;59,64;61,58;60,63;59,71|
5328|Enfouisseur côtier|Coast Crawl Deepseer|43|44|0|357:38,47;34,35;36,53;24,56;31,61;27,61;39,44;32,59|
5336|Ensorceleuse Hainecrête|Hatecrest Sorceress|43|44|0|357:28,68;26,62;25,73;27,68;27,69;25,66;27,70|9247,9262,6046
5300|Hippogryphe Aigreplume|Frayfeather Hippogryph|43|44|0|357:55,61;58,63;56,62;57,64;55,65|4589,9591,9592,4590,5829,11418,11417
5287|Hurleur Longues-dents|Longtooth Howler|43|44|0|357:71,60;56,47;70,59;57,50;54,49;55,49;61,50;71,61|
5234|Marteleur Gordunni|Gordunni Mauler|43|44|0|357:61,59;60,57;59,64;61,56;61,58;62,55;61,55|
5334|Myrmidon Hainecrête|Hatecrest Myrmidon|43|44|0|357:23,64;24,63;25,62;26,64;26,63;27,65;27,64|9247
5292|Yéti Griffe farouche|Feral Scar Yeti|43|44|0|357:56,59;53,58;53,56;54,56;55,56;55,55;56,56;57,56|8973,8384
5647|Flamboyant Sandfury|Sandfury Firecaller|43|44|1|440:41,22;38,26;38,25;37,26;41,30;39,21;42,23|
5646|Lanceur de haches Sandfury|Sandfury Axe Thrower|43|44|1|440:37,24;38,22;37,25;40,30;40,28;40,29|
5423|Scorpide flagellant|Scorpid Tail Lasher|43|44|0|440:59,45;51,43;35,27;63,41;46,23;47,39;62,42;54,43|4421,9442,4425,19935,19936,19937,4872,4867
5615|Voleur Bat-le-désert|Wastewander Rogue|43|44|0|440:61,33;62,38;62,35;61,32;59,39;63,40;64,39;63,37|8399,8401,8483
5648|Exhalombre Sandfury|Sandfury Shadowcaster|43|44|1|1176:|9332,9334,9333,5173,9523,9242,9243,4356,12261,3875,2928
4849|Archéologue Ombreforge|Shadowforge Archaeologist|43|44|1|1337:|9430,8009,8052,9422,9429,9431,9427,9432,9424,9392,9384,9420
4855|Bagarreur Cavepierre|Stonevault Brawler|43|44|1|1337:|4375,9465,9423,9430,9422,9425,9429,9431,9426,9427,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393
4853|Géomancien Cavepierre|Stonevault Geomancer|43|44|1|1337:|9430,9422,9425,9429,9431,9426,9427,9432,9383,9381,9424,9391,9386,9392,9397,9393,9406,9428,9384,9420
4848|Invocateur noir Ombreforge|Shadowforge Darkcaster|43|44|1|1337:|8009,8052,9425,9429,9431,9426,9424,9396,9406,9428,9384,9420
4860|Régisseur des pierres|Stone Steward|43|44|1|1337:|9465,9423,9430,9422,9425,9429,9431,9426,9427,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396
7290|Tireur d'élite Ombreforge|Shadowforge Sharpshooter|43|44|1|1337:|9465,9423,8009,8052,9422,9429,9427,9383,5833,9424,9391,9386,9392,9397,9393,9396,9406,9428,9384,9420
13141|Marteleur Sève-putride|Deeprot Stomper|43|44|1|2100:|4356,6046
11790|Satyre Putridus|Putridus Satyr|43|44|1|2100:|17684,9719
2726|Gardien des terres brûlées|Scorched Guardian|43|45|1|3:85,56;82,48;83,54;80,48;79,52;81,45;80,50;77,54|4612,4843,11108,4402,4557
4390|Ancien batteur des boues|Elder Murk Thresher|43|45|0|15:55,44;56,48|5516,2608
1565|Loup de mer de la Voile sanglante|Bloodsail Sea Dog|43|45|0|33:32,54;29,89;31,90;29,88;32,56|8494,3897,3910,9260,2928
5856|Araignée verrière|Glassweb Spider|43|45|0|51:61,69;68,69;72,16;69,51;59,53;64,68;65,49;63,54|11725,21211,21314,9355,8384,12205
5429|Roc de feu|Fire Roc|43|45|0|440:55,47;37,35;42,39;43,40;45,39;47,47;48,45;45,38|6257,556,1464,3404,12207,5829,11418,11417,4775
8667|Vortex violent|Gusting Vortex|43|45|0|440:39,42;43,47;46,46;60,58;36,64|7081,7069
11791|Entourloupeur Putridus|Putridus Trickster|43|45|1|2100:|17684
14236|Seigneur Angler|Lord Angler|44|44|4|15:58,62|5942
723|Boucher Mosh'Ogg|Mosh'Ogg Butcher|44|44|2|33:50,31|3930
672|Chasseur d’esprit Skullsplitter|Skullsplitter Spiritchaser|44|44|0|33:48,43;48,42;44,45;48,44|3916,1524
1060|Mogh l'Immortel|Mogh the Undying|44|44|1|33:48,44|4644,8152
1491|Naga Zanzil|Zanzil Naga|44|44|0|33:42,56;41,58;35,52;40,59;35,51;39,60|4016
14490|Rippa||44|44|4|33:29,85|4860
1490|Sorcier-docteur Zanzil|Zanzil Witch Doctor|44|44|0|33:35,52;39,57;40,58;39,59|4016,4301,8152
2447|Narillasanz||44|44|2|36:74,65|4375,7191,4402
8210|Trancheserre|Razortalon|44|44|4|47:37,45|12207,11417
5354|Gnarl Frèrefeuilles|Gnarl Leafbrother|44|44|4|357:69,57|
5272|Vieil ours Ferpoil|Grizzled Ironfur Bear|44|44|0|357:55,50;70,61;68,61;69,59;57,50;54,48;61,51;51,48|6258,11408,11409,11410
7605|Corbeau|Raven|44|44|1|1176:|9482,9512
7608|Murta Grimgut||44|44|1|1176:|9511,5616,9512
7606|Oro Eyegouge||44|44|1|1176:|9482,5616
7206|Ancien Gardien des pierres|Ancient Stone Keeper|44|44|1|1337:|9410,9411,9425
13743|Force de la Nature corrompue|Corrupt Force of Nature|44|44|0|2100:|
2719|Seigneur Crache-poussières|Dustbelcher Lord|44|45|0|3:7,91;8,90;10,93;10,92;8,96;7,95;8,94|4630
752|Oracle des marais|Marsh Oracle|44|45|0|8:63,80;61,84;94,31;95,51;95,61;62,87;60,87;64,87|
1653|Ancien magus de la Voile sanglante|Bloodsail Elder Magus|44|45|0|33:32,54;29,89;33,88;31,90;31,89;32,56|8494,3897,3910,9260,8384
2928|Chouettard primitif|Primitive Owlbeast|44|45|0|47:51,50;43,45;39,45;43,44;39,53;39,52;40,48;46,52|9591,9592,12207,11417,9719
2686|Garde du clan Witherbark|Witherbark Broodguard|44|45|0|47:31,70;32,71;35,74;32,73;38,68;37,68;33,74;35,68|9322,12205
2653|Sadique Witherbark|Witherbark Sadist|44|45|0|47:31,71;33,67;40,66;32,68;35,73;37,72;33,75;35,64|9320,9259
8637|Garde Sombrefer|Dark Iron Watchman|44|45|0|51:63,59;63,58;62,62|21547,10551
5304|Cerf ailé Aigreplume|Frayfeather Stagwing|44|45|0|357:56,71;58,74;54,66;54,69;56,64;57,66;55,66;55,64|9591,9592,4590,5829,11418,11417
5236|Chaman Gordunni|Gordunni Shaman|44|45|0|357:61,73;64,69;62,69;61,68;61,66;60,63;60,66;59,70|
5327|Claque-pinces côtier|Coast Crawl Snapclaw|44|45|0|357:36,52;36,49;37,50;38,42;40,48;37,42;38,46;34,56|
5295|Enragé Griffe farouche|Enraged Feral Scar|44|45|0|357:52,59;52,60;52,58;51,58;51,60;53,56|8973,9262
5333|Garde-serpent Hainecrête|Hatecrest Serpent Guard|44|45|0|357:27,68;26,72;26,66;26,69;26,68;28,70|9247,9358
5245|Guêpe Zukk'ash|Zukk'ash Wasp|44|45|0|357:77,60;75,63;74,64;76,62;74,62;74,63;73,62;72,64|18961
5246|Ouvrière Zukk'ash|Zukk'ash Worker|44|45|0|357:77,63;76,59;75,60;73,61;75,62;74,61|18961
5623|Assassin Bat-le-désert|Wastewander Assassin|44|45|0|440:66,36;59,40;61,33;59,36;60,37;64,40;59,37|45,8400,8402,11206,8483,9358
7858|Bretteur des Mers du sud|Southsea Swashbuckler|44|45|0|440:75,46;72,47;76,46;75,47;76,45|9249,9276,20519,9356,9355,9357,9260,9358,8384
7856|Flibustier des Mers du sud|Southsea Freebooter|44|45|0|440:72,48;73,47;71,46;72,45;71,47;71,43;71,44;76,45|17722,9249,9276,9206,8956,10592,20519,9356,9355,9357,9260,9358,9719
5426|Hyène Brûlepatte|Blisterpaw Hyena|44|45|0|440:57,55;38,37;38,49;55,42;47,58;48,53;52,63;46,38|3013,9439,3875,4775
7855|Pirate des Mers du sud|Southsea Pirate|44|45|0|440:73,48;71,43;72,48;72,44;73,47;72,45|9249,9276,21211,20519,21314,9356,9355,9357,9260,9358,8384
7857|Portefaix des Mers du sud|Southsea Dock Worker|44|45|0|440:74,47;75,48;74,48;75,47;73,47|9249,9276,20519,9356,9355,9357,9260,9358,12261
5649|Buveur de sang Sandfury|Sandfury Blood Drinker|44|45|1|1176:|9332,9334,9336,9333,9335,9357,9523,9242,9243
5650|Sorcier-docteur Sandfury|Sandfury Witch Doctor|44|45|1|1176:|9332,9334,9336,9333,9335,5173,9523,9242,9243,12261,9719
7396|Brise-pierre terrestre|Earthen Stonebreaker|44|45|0|1337:|
7076|Gardien terrestre|Earthen Guardian|44|45|0|1337:|6046
7397|Grave-pierre terrestre|Earthen Stonecarver|44|45|0|1337:|12261
7320|Marteleur Cavepierre|Stonevault Mauler|44|45|1|1337:|9465,9423,9430,9422,9425,9429,9431,9426,9427,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396
7309|Protecteur terrestre|Earthen Custodian|44|45|0|1337:|
7077|Réformeur terrestre|Earthen Hallshaper|44|45|0|1337:|
7321|Tisseur de flammes Cavepierre|Stonevault Flameweaver|44|45|1|1337:|9465,9423,9422,9425,9429,9431,9426,9427,9432,9383,5833,9381,9424,9391,9386,9392,9397,9393,9396,9406
12219|Flagellant barbelé|Barbed Lasher|44|45|1|2100:|17684
13142|Noueur Sève-putride|Deeprot Tangler|44|45|1|2100:|9262
5308|Hurleur des vallées insoumis|Rogue Vale Screecher|44|46|0|357:43,37;44,36;53,47;48,59;57,48;61,50;47,41;46,49|11914,11948
7584|Marcheur des bois errant|Wandering Forest Walker|44|46|0|357:44,23;74,39;54,47;57,73;73,55|9590,9592
7269|Scarabée|Scarab|44|46|0|1176:|9238,9332,9334,9336,9333,9335
2754|Anathemus||45|45|2|3:24,74|
2752|Grondeur|Rumbler|45|45|4|3:15,89;14,86;5,82;2,81|7848,7075,4784
746|Ancien draconien|Elder Dragonkin|45|45|0|8:86,46;83,46;80,45;87,44;87,48;85,50;78,55|5803
14445|Seigneur-capitaine Wyrmak|Lord Captain Wyrmak|45|45|2|8:69,39|5803
4841|Mortebourbe|Deadmire|45|45|0|15:49,57|5945,770
4339|Soufresang|Brimgore|45|45|2|15:42,76|4402
1059|Ana'thek le Cruel|Ana'thek the Cruel|45|45|0|33:44,45|3909,3916,1524,8152
680|Seigneur Mosh'Ogg|Mosh'Ogg Lord|45|45|1|33:53,28;52,27;51,31|3930
2541|Seigneur Sakrasis|Lord Sakrasis|45|45|4|33:28,63;29,62|4356
1552|Ventrécaille|Scale Belly|45|45|4|33:43,46;42,48;44,48|4092,11387,4093,11386
8218|Flétricoeur le Traqueur|Witherheart the Stalker|45|45|4|47:33,70|9259
5881|Sycomore maudit|Cursed Sycamore|45|45|0|357:55,68|742,22529
5345|Tête-de-diamant|Diamond Head|45|45|4|357:37,51|
7883|Andre Barbe-en-feu|Andre Firebeard|45|45|0|440:73,47|9246,8400,8402,20519,8483,9356,9358
8199|Chef de guerre Krazzilak|Warleader Krazzilak|45|45|2|440:39,22|
15685|Kidnappeur des mers du Sud|Southsea Kidnapper|45|45|0|440:74,48;74,47;73,48;73,47|
10081|Ame en peine poudreuse|Dustwraith|45|45|2|1176:|12471,9523,9242,9243
10080|Sandarr Ravadune|Sandarr Dunereaver|45|45|2|1176:|9523,9243
10082|Zerillis||45|45|2|1176:|12470,2040,6440,9512,9523,9242,9243
7291|Galgann Firehammer||45|45|1|1337:|9412,9419,11310,11311
10120|Garde de la Banque|Vault Warder|45|45|1|1337:|
4854|Grimlok||45|45|1|1337:|7670,9414,9415,9416,9425
5974|Ogre Cognepeur|Dreadmaul Ogre|45|46|0|4:42,15;41,12;43,13;42,13;43,15;44,15|
5984|Raillecroc affamée|Starving Snickerfang|45|46|0|4:56,18;49,25;46,18;48,24;51,28;48,20;47,21;45,21|8391
5261|Exalté atal'ai|Enthralled Atal'ai|45|46|1|8:81,47|10627,10628,10632,6181,10623,10631,10624,10634,8152
6116|Apparition bien-née|Highborne Apparition|45|46|0|16:17,69;17,71;17,73;18,68;17,66;18,69;16,69;14,72|
6125|Satyre Haldarr|Haldarr Satyr|45|46|0|16:20,64;20,61;21,62;20,62;19,63;21,61;21,60|
2550|Capitaine Stillwater|Captain Stillwater|45|46|0|33:33,88|3897,3910
4465|Guerrier Vilebranch|Vilebranch Warrior|45|46|1|47:68,69;64,63;65,62;68,66;66,65;69,64;68,64;66,69|9259,8152
2925|Hurleur Crins-d'argent|Silvermane Howler|45|46|0|47:41,67;50,58;51,41;41,55;41,64;43,63;39,46;48,62|
2654|Implorateur Witherbark|Witherbark Caller|45|46|0|47:32,76;32,67;40,66;36,73;37,72|9320,9259
2639|Lanceur de haches Vilebranch|Vilebranch Axe Thrower|45|46|0|47:43,68;46,67;50,64;45,70;48,63;44,67;43,65;49,63|9259
5844|Esclavagiste Sombrefer|Dark Iron Slaver|45|46|0|51:44,31;42,29;39,38;39,45;46,49;40,54;47,25;35,59|21547,11818,10551,24232
5244|Aiguillonneuse Zukk'ash|Zukk'ash Stinger|45|46|0|357:78,64;79,64;77,66;73,65;74,63;77,62;77,63|18961
5293|Griffe farouche massif|Hulking Feral Scar|45|46|0|357:52,60;52,61;53,60;52,57;52,59;50,59;51,58|8973
5238|Maître de guerre Gordunni|Gordunni Battlemaster|45|46|0|357:62,69;60,70;59,68;61,68;58,73;61,69;59,72|
5239|Seigneur-mage Gordunni|Gordunni Mage-Lord|45|46|0|357:62,73;63,69;61,71;60,68;58,68;59,73;61,70|9371
5305|Tempêtueux Aigreplume|Frayfeather Skystormer|45|46|0|357:56,70;55,71;56,72;57,74;55,72;54,70;55,74;54,64|9591,9592,4590,5829,11418,11417,9719
5247|Tunnelière Zukk'ash|Zukk'ash Tunneler|45|46|0|357:74,65;76,66;78,63;77,65;74,63;75,62;77,62|18961
5420|Contemplateur Peau-de-verre|Glasshide Gazer|45|46|0|440:50,62;54,57;60,56;44,45;50,50;40,66;42,60;62,59|9437,4092,11387,9355,9358,4093,11386
5471|Ogre Cognedune|Dunemaul Ogre|45|46|0|440:41,73;42,73;42,74;42,70;40,75;39,73;41,55;41,52|
7246|Chasseur des ombres Sandfury|Sandfury Shadowhunter|45|46|1|1176:|9332,9334,9336,9333,9335,9523,9242,9243,4301
7268|Gardien Sandfury|Sandfury Guardian|45|46|1|1176:|
7247|Mangeur d'âmes Sandfury|Sandfury Soul Eater|45|46|1|1176:|9332,9334,9333,9335,9523,9242,9243
8311|Gelée urticante|Slime Maggot|45|46|0|1477:|10780,10781,10782
11793|Dryade de Celebrian|Celebrian Dryad|45|46|1|2100:|17684
12220|Liane étrangleuse|Constrictor Vine|45|46|1|2100:|22529,17684,9719
12223|Rôdeur des cavernes|Cavern Lurker|45|46|1|2100:|17684
12222|Vase rampante|Creeping Sludge|45|46|1|2100:|20767,20763,17684,3670,3673,3674,7296
5979|Perdu décati|Wretched Lost One|45|47|0|4:47,19;48,23|
8759|Coureur Sabots-de-mousse|Mosshoof Runner|45|47|0|16:18,51;21,58;22,54;20,67;19,67;23,62;19,54;18,60|5471,5566,5119,5120
6126|Entourloupeur Haldarr|Haldarr Trickster|45|47|0|16:19,62;21,60;20,64;20,62|
5857|Araignée de lave incendiaire|Searing Lava Spider|45|47|0|51:54,70;48,72;51,70;47,63;56,69;58,84;53,39;55,38|12205,14227
5850|Elémentaire flamboyant|Blazing Elemental|45|47|0|51:58,77;45,48;60,43;58,45;58,47;41,37;48,49|10509,4787,7077
5853|Golem de guerre|Tempered War Golem|45|47|0|51:68,33;70,32;61,62;65,64;62,63;63,60;64,58|10511
5465|Ravageur des landes|Land Rager|45|47|0|440:51,49;35,56;51,52;59,54;44,59|7075,4784
8095|Rampeur de Sul'lithuz|Sul'lithuz Sandcrawler|45|47|1|1176:|9336,9335,4092,11387,1701,1702
12218|Larve maléfique|Vile Larva|45|47|0|2100:|4426,17684
11794|Soeur de Celebrian|Sister of Celebrian|45|47|1|2100:|17684
9916|Jarquia||46|46|0|8:95,52|11723
6184|Guide Grumegueule|Timbermaw Pathfinder|46|46|0|16:31,43;35,41;32,46;36,36;36,41;31,45;31,46|
2534|Zanzil le Paria|Zanzil the Outcast|46|46|0|33:40,59|4016,8152
8402|Archéologue asservi|Enslaved Archaeologist|46|46|0|51:40,27;42,24;39,24;40,22|5173,2928
8279|Golem de guerre défaillant|Faulty War Golem|46|46|4|51:46,68;32,61;33,46;43,42;60,58|
5343|Dame Szallah|Lady Szallah|46|46|4|357:28,68|9247
7847|Caliph Dard-de-scorpide|Caliph Scorpidsting|46|46|0|440:62,38|8723
8207|Grand oiseau de feu|Greater Firebird|46|46|4|440:49,36|1464,3404,12207,5829,11418,11417
8200|Jin'Zallah Porte-sable|Jin'Zallah the Sandbringer|46|46|2|440:37,25|
7274|Bourreau Sandfury|Sandfury Executioner|46|46|1|1176:|8444,2040,6440,9480,9483,9511,9482,5616,9512,24232,9523,9242,9243
7795|Hydromancienne Velratha|Hydromancer Velratha|46|46|1|1176:|9234,9481,10661,9483,5616,9512,9242,9243
7797|Ruuzlu||46|46|1|1176:|6440,9511,5616,9512,9523,9242,9243
7271|Sorcier-docteur Zum'rah|Witch Doctor Zum'rah|46|46|1|1176:|18082,18083,9242,9243
7272|Theka le Martyr|Theka the Martyr|46|46|1|1176:|10660,2040,9480,9483,9511,9482,5616,9512,9523,9242,9243,3875
4857|Gardien des pierres|Stone Keeper|46|46|1|1337:|9423,9430,9422,9429,9426,9427,9432,9424,9392,9397,9393,9406,9384,9420
5976|Brute Cognepeur|Dreadmaul Brute|46|47|0|4:41,14;44,13;44,12;41,12;42,12|
5975|Ogre-mage Cognepeur|Dreadmaul Ogre Mage|46|47|0|4:43,13;43,11;42,13;42,14;44,12|
5434|Requin du corail|Coral Shark|46|47|1|15:68,61;75,70;78,69;81,67;81,65;80,64;81,55;80,53#17:66,40|8508,5567
6190|Guerrier Fouette-bile|Spitelash Warrior|46|47|0|16:29,53;29,58;29,50;34,62;37,46;26,62;31,52;29,60|
6117|Jeune liche bien-née|Highborne Lichling|46|47|0|16:13,73;15,73;17,71;16,68;17,68;18,70;17,67;17,72|
6127|Lige de la corruption Haldarr|Haldarr Felsworn|46|47|0|16:21,61;19,61;19,64;20,61|
2548|Capitaine Keelhaul|Captain Keelhaul|46|47|0|33:29,88|3897,3910
2641|Chasseur de têtes Vilebranch|Vilebranch Headhunter|46|47|1|47:66,70;65,69;68,71;69,71|9259,8152
2929|Chouettard sauvage|Savage Owlbeast|46|47|0|47:62,44;61,42;61,47;60,54;63,41;56,52;53,50;66,58|9591,9592,12207,11417
4467|Devin Vilebranch|Vilebranch Soothsayer|46|47|0|47:45,67;47,68;48,66;50,63;48,67;49,68;53,39;66,44|6887,9259
2655|Limace verte|Green Sludge|46|47|0|47:57,41;57,44;58,42;58,44;49,46;45,42;48,41|20767,6887,11914,11948,20763,3670,3673,3674,7296
4469|Limon émeraude|Emerald Ooze|46|47|1|47:65,66;65,67;65,65|20767,20763,3670,3673,3674,7296
2680|Louveteau Vilebranch|Vilebranch Wolf Pup|46|47|0|47:45,65;46,65;48,64;44,68;66,70;64,65;67,72;68,69|
4466|Scalpeur Vilebranch|Vilebranch Scalper|46|47|0|47:51,66;50,63;45,68;54,39;54,40;67,44;70,49;65,45|6887,9259
2640|Sorcier-docteur Vilebranch|Vilebranch Witch Doctor|46|47|0|47:48,69;63,60;64,60;68,66;67,66;67,69;69,70;66,69|3829,4623,9259
5840|Forge-vapeur Sombrefer|Dark Iron Steamsmith|46|47|0|51:38,51;38,50;40,48;41,49;43,52|18959,11818,10551
5306|Patriarche Aigreplume|Frayfeather Patriarch|46|47|0|357:58,75;55,72;57,75;56,72;55,75;56,75;54,72;54,71|9591,9592,4590,5829,11418,11417
5241|Seigneur de guerre Gordunni|Gordunni Warlord|46|47|0|357:61,69;61,71;63,68;63,69;61,73;62,67;61,67;59,72|
5296|Yéti Griffe féroce|Rage Scar Yeti|46|47|0|357:55,33;54,33;53,30;53,32;52,30;52,31|18947,18969,18972
5472|Massacreur Cognedune|Dunemaul Enforcer|46|47|0|440:41,73;39,73;39,52;39,53;38,59;39,55;42,53;40,58|
5473|Ogre-mage Cognedune|Dunemaul Ogre Mage|46|47|0|440:41,71;47,67;47,65;46,63;40,54;42,54;42,56|
5424|Scorpide des sables|Scorpid Dunestalker|46|47|0|440:33,56;45,46;45,50;47,50;37,47;42,45;35,58;47,72|9442,19935,19936,11948,4872,4867
5263|Atal'ai momifié|Mummified Atal'ai|46|47|1|1477:|10626,10629,10625,10627,10628,10632,6181,10623,10631,10624,10634,8152
8318|Esclave atal'ai|Atal'ai Slave|46|47|0|1477:|
5269|Prêtre atal'ai|Atal'ai Priest|46|47|1|1477:|10626,10627,10628,10632,6181,10623,10631,10624,10634,8152
12221|Gelée nuisible|Noxious Slime|46|47|1|2100:|20767,11914,11948,20763,17684,3670,3673,3674,7296
13599|Gueule d'acier impassible|Stolid Snapjaw|46|47|0|2100:|8167,3712,4556,4555
12207|Hydre de Thessala|Thessala Hydra|46|47|1|2100:|5569,3010,17684
12224|Traînard des grottes|Cavern Shambler|46|47|1|2100:|17684
5990|Basilic Rougepierre|Redstone Basilisk|46|48|0|4:60,35;55,29;62,26;61,28;61,30|8394,4092,11387,4093,11386,10310
5982|Pourfendeur noir|Black Slayer|46|48|0|4:63,27;56,36;57,37;59,28|8168,8396,4425,556,1464,3404,12207,5829,11418,11417
6375|Hippogryphe Tête-tonnerre|Thunderhead Hippogryph|46|48|0|16:17,52;19,66;19,53;18,55;16,49;18,54;18,62;19,56|10450,4589,4590,5829,11418,11417
5855|Elémentaire de magma|Magma Elemental|46|48|0|51:30,60;24,54;54,47;56,47;56,55;31,75;56,77;54,55|10509,10511,4787,7077
5474|Brute Cognedune|Dunemaul Brute|46|48|0|440:42,72;39,52;41,70;38,52;43,56;41,51;48,64;40,58|9358
13323|Dimeurtrodon souterrain|Subterranean Diemetradon|46|48|1|2100:|5133,5128
11789|Fouisseur des profondeurs|Deep Borer|46|48|0|2100:|
6187|Protecteur Grumegueule|Timbermaw Den Watcher|47|47|0|16:45,27;48,31;38,32;45,22;44,27;42,20|
1492|Gorlash||47|47|1|33:37,70|3932,4382
818|Mai'Zoth||47|47|1|33:53,28|3616
8280|Shleipnarr||47|47|4|51:59,57|5119,5120
14661|Fouet-cuisant|Stinglasher|47|47|0|357:77,62|18962,18961
5350|Qirot||47|47|4|357:77,66|
8136|Seigneur Shalzaru|Lord Shalzaru|47|47|0|357:28,70|9248,9247
5467|Etre des profondeurs|Deep Dweller|47|47|1|440:66,66|
8203|Kregg Keelhaul||47|47|4|440:73,49|20519,9356
8120|Abomination Sul'lithuz|Sul'lithuz Abomination|47|47|1|1176:|4092,11387,4093,11386
2748|Archaedas||47|47|1|1337:|7672,9413,9418,11118
12236|Seigneur Vylelangue|Lord Vyletongue|47|47|1|2100:|17703,17752,17754,17755,17684
8762|Grumetoile solitaire|Timberweb Recluse|47|48|0|16:38,41;47,34;41,36;30,48;37,42;24,50;40,39;26,48|20023,12205,14227
6185|Guerrier Grumegueule|Timbermaw Warrior|47|48|0|16:33,46;33,44;36,36;35,42;37,35;32,45;32,46|
6193|Hurleuse Fouette-bile|Spitelash Screamer|47|48|0|16:30,61;31,61;34,50;32,53;34,58;37,46;28,60;26,51|
2643|Berserker Vilebranch|Vilebranch Berserker|47|48|1|47:67,72;68,72;64,67;64,71;64,70;64,72;67,73|9259,8152
2642|Exhalombre Vilebranch|Vilebranch Shadowcaster|47|48|1|47:66,72;68,73;64,66;63,66;65,71;64,71;64,72;65,73|16214,9259,8152
4468|Limace de jade|Jade Sludge|47|48|1|47:62,77;61,75;61,74;62,76;63,74;63,77|6756,20767,20763,3670,3673,3674,7296
2656|Limon de jade|Jade Ooze|47|48|0|47:57,43;58,43;56,41;51,53;58,46;57,45;48,42|20767,6887,11914,11948,20763,3670,3673,3674,7296
2926|Traqueur Crins-d'argent|Silvermane Stalker|47|48|0|47:69,53;59,48;62,50;54,43;73,58;67,49;56,46;59,49|11472,6887
5860|Chaman noir du crépuscule|Twilight Dark Shaman|47|48|1|51:24,34;19,36;23,41;24,37;25,37|10458,10552
8566|Guetteur Sombrefer|Dark Iron Lookout|47|48|0|51:43,63;53,59;33,54;35,62;52,59;50,56;34,52|18960,11818,10551
5846|Sous-chef Sombrefer|Dark Iron Taskmaster|47|48|0|51:38,32;44,34;41,44;42,34;58,42;34,46;46,40;46,25|10575,21547,11818,10551
5462|Embruns|Sea Spray|47|48|0|357:44,65;34,35;38,36;44,39;45,46;48,49;46,62;47,55|18958,4791,7079,7070
5299|Griffe féroce enragé|Ferocious Rage Scar|47|48|0|357:55,33;55,32;55,34;53,30;54,32;53,32;52,31|18947,18969,18972
5288|Longues-dents enragé|Rabid Longtooth|47|48|0|357:44,9;40,20;44,20;40,23;45,24;51,34;49,32;44,13|
5361|Marcheur des vagues|Wave Strider|47|48|1|357:45,62;38,34;44,47;47,58|
5276|Petit dragon féerique|Sprite Dragon|47|48|0|357:44,22;43,23;44,10;51,34|9589,4402,4557
8959|Loup Gangrepatte|Felpaw Wolf|47|48|0|361:56,92;51,81;43,80;42,81;55,86;48,80;50,80;52,86|11172,11914,11948
8956|Ours de la griffe colérique|Angerclaw Bear|47|48|0|361:45,85;44,83;58,87;55,83;48,76;47,73;40,78;45,73|9144,9036,11172,11408,11409,11410
5427|Brûlepatte enragée|Rabid Blisterpaw|47|48|0|440:34,66;33,61;44,44;43,52;33,67;34,59;29,57;45,76|15564,9439
5481|Chardonnier collecteur de rosée|Thistleshrub Dew Collector|47|48|0|440:31,67;31,65;28,68;28,64;29,68;28,69;31,64;30,67|8428,8429,8430
5475|Démoniste Cognedune|Dunemaul Warlock|47|48|0|440:42,73;39,71;46,65;47,68;40,54;39,57;39,53;45,66|
5455|Guêpe Centipaar|Centipaar Wasp|47|48|0|440:33,46;31,45;33,48;33,43;33,50;36,46;34,40;36,42|8587
5441|Guêpe Hazzali|Hazzali Wasp|47|48|0|440:50,72;52,68;53,74;49,72;53,73;51,76;52,72;51,71|
5452|Ouvrier Hazzali|Hazzali Worker|47|48|0|440:55,68;57,69;57,70;58,72;55,77;56,74;58,70|9262
5459|Tunnelière centipaar|Centipaar Tunneler|47|48|0|440:31,45;34,42;33,43;32,44;34,46;34,40;35,48;35,43|8587
5228|Limon saturé|Saturated Ooze|47|48|1|1477:|11318,10633,10780,10781,10782,20767,10629,10625,10627,10628,10632,10623,10631,10624,10634,20763,3670,3673,3674,7296
5226|Ver des boues|Murk Worm|47|48|1|1477:|15733,11318,10780,10630,10781,10782,10626,10629,10625,10627,10628,10632,10623,10631,10624,10634
11784|Gardien Theradrim|Theradrim Guardian|47|48|1|2100:|7075,4784
8837|Eclabousseur des marais|Muck Splash|47|49|0|51:16,37;16,36;14,38;15,35;14,36;14,35;18,43|4791,7079,7070
5852|Elémentaire infernal|Inferno Elemental|47|49|0|51:40,59;30,77;28,64;52,62;39,56;31,44|10509,4787,7077
5854|Golem de guerre lourd|Heavy War Golem|47|49|0|51:46,38;45,64;43,44;48,39;32,53;42,41;35,45;52,59|10511,10575
5858|Grande araignée de lave|Greater Lava Spider|47|49|0|51:40,69;29,76;30,71;26,69;28,55;30,57;28,50;32,40|12205,14227
9318|Incendosaure|Incendosaur|47|49|0|51:50,39;50,33;51,34;51,29;48,26;45,25;45,21;48,22|18944,4422,5133,5128
5360|Marcheur des profondeurs|Deep Strider|47|49|1|357:36,33;43,53;40,39;45,66;44,49;45,53;47,62|
5430|Roc incendiaire|Searing Roc|47|49|0|440:37,69;32,60;41,63;33,60;37,70;41,64|6257,556,1464,3404,12207,5829,11418,11417
8384|Rôdeur des Abysses|Deep Lurker|47|49|1|1477:|11318,10780,10781,10782
8442|Braconnier Ombresoie|Shadowsilk Poacher|47|50|0|51:60,25;59,25;60,26|
8296|Mojo le Tordu|Mojo the Twisted|48|48|4|4:45,16;42,15;42,12|
6118|Fantôme de Varo'then|Varo'then's Ghost|48|48|4|16:13,74|
8660|L'Evalcharr|The Evalcharr|48|48|4|16:18,66|
7977|Gammerita||48|48|1|47:80,58|19023,8167,3712,4556,4555
8216|Retherokk le Berserker|Retherokk the Berserker|48|48|4|47:51,64|9259
8447|Clonk|Clunk|48|48|1|51:35,52|9060,10561,9061,10505,7191
8277|Rekk'tilac||48|48|4|51:62,73;53,71;30,73;35,28;60,29|12205,14227
8504|Sentinelle Sombrefer|Dark Iron Sentry|48|48|1|51:43,62;41,36;35,54;37,60;49,56|11818,10551
5347|Antilus le Planeur|Antilus the Soarer|48|48|4|357:56,74|9591,9592,4590,5829,11418,11417
5346|Rugissang le Traqueur|Bloodroar the Stalker|48|48|4|357:52,61|8973
8202|Cyclok le Fol|Cyclok the Mad|48|48|4|440:41,55|
5454|Ravageur des sables Hazzali|Hazzali Sandreaver|48|48|0|440:58,71;56,69;57,70;53,75;54,72;56,68;57,67;55,70|
9397|Tempête vivante|Living Storm|48|48|0|440:30,78;50,69|7081,7069
8127|Antu'sul||48|48|1|1176:|9379,9639,9640,9641,9523,9242,9243
7267|Chef Ukorz Scalpessable|Chief Ukorz Sandscalp|48|48|1|1176:|9476,9477,9478,9479,11086,9523,9242,9243
12237|Meshlok le Moissonneur|Meshlok the Harvester|48|48|2|2100:|17741,17742,17767,17684
13282|Noxxion||48|48|1|2100:|17702,17744,17745,17746,4791,17684
12258|Tranchefouet|Razorlash|48|48|1|2100:|4808,17747,17748,17749,17750,17751,22529,17684
5992|Sanglier cendré|Ashmane Boar|48|49|0|4:58,30;59,36;62,29;58,27;63,28|8392,3403,2295
6194|Garde-serpent Fouette-bile|Spitelash Serpent Guard|48|49|0|16:38,50;41,49;44,64;38,54;39,58;40,64;36,53;39,62|
6186|Totémique Grumegueule|Timbermaw Totemic|48|49|0|16:32,45|
2645|Chasseur des ombres Vilebranch|Vilebranch Shadow Hunter|48|49|1|47:62,65;68,75;67,77;66,76;64,74;60,73;62,70;63,66|9259,8152
2644|Ecorcheur Vilebranch|Vilebranch Hideskinner|48|49|1|47:67,76;65,77;67,80;64,74;65,76;68,75;61,68;63,71|15760,9259,8152
5861|Gardefeu du crépuscule|Twilight Fire Guard|48|49|1|51:20,39;24,39;18,36;14,39;19,37;21,36;25,39;22,26|14471,14476,10458,10552
5297|Ancien Griffe féroce|Elder Rage Scar|48|49|0|357:56,33;55,33;55,34;55,32;54,33|18947,18969,18972
5461|Elémentaire marin|Sea Elemental|48|49|0|357:45,68;35,35;37,36;44,39;41,38;48,53;46,57;47,54|18958,4791,7079,7070
5362|Harpie Ruissenord|Northspring Harpy|48|49|0|357:38,16;40,11;40,15;40,14;41,15;42,12;40,13|9530,5116
5359|Marcheur des rivages|Shore Strider|48|49|1|357:35,34;43,47;38,35;36,36;36,37;45,62;44,50;46,58|
5357|Marcheur des terres|Land Walker|48|49|1|357:41,26;38,24;38,22;39,24;40,22;41,24;39,22;38,21|9589,9592
5274|Patriarche Ferpoil|Ironfur Patriarch|48|49|0|357:43,24;44,12;45,22;49,28;41,18;40,25;50,34;51,31|6258,11408,11409,11410
5363|Volplume Ruissenord|Northspring Roguefeather|48|49|0|357:37,16;39,16;38,12;40,10;42,13;42,14|9530,5116
7097|Chouette Bec-de-fer|Ironbeak Owl|48|49|0|361:45,81;38,73;42,81;45,83;54,84;57,84;47,74;49,82|12207,5829,11418,11417
7153|Guerrier Mort-bois|Deadwood Warrior|48|49|0|361:50,88;49,92;48,93;49,93;48,94;46,89;49,90;48,91|9155,9154,9179,21377
7154|Jardinier Mort-bois|Deadwood Gardener|48|49|0|361:46,91;49,93;47,93;49,91;49,89;48,90;46,90;48,91|3829,9206,21377
5490|Chardonnier noueux|Gnarled Thistleshrub|48|49|0|440:28,63;29,62;30,63;31,66;30,66;29,67;28,66;28,70|
5469|Compresseur|Dune Smasher|48|49|1|440:37,81;37,80;38,81;37,79|
5456|Dard Centipaar|Centipaar Stinger|48|49|0|440:33,50;31,47;34,41;32,45;32,49;35,45;35,39;33,41|8587
5466|Marcheur des côtes|Coast Strider|48|49|1|440:68,58;69,60;67,62;65,63;67,60;67,59;72,56;70,57|9358
5458|Ouvrier Centipaar|Centipaar Worker|48|49|0|440:35,44;34,45;31,46;35,40;32,45;31,44;33,45;36,43|8587
5421|Pétrificateur Peau-de-verre|Glasshide Petrifier|48|49|0|440:32,78;26,59;37,73;27,60;31,75;26,62;34,69;26,60|9437,4092,11387,4093,11386
5453|Tunnelière Hazzali|Hazzali Tunneler|48|49|0|440:56,71;57,71;54,70;57,73;55,76;57,74;57,68|
6509|Flagellant Pétale-de-sang|Bloodpetal Lasher|48|49|0|490:75,45;75,40;68,28;65,31;68,32;68,24;70,22;68,21|11316,22529,11315,11185,11184,11186,11188
6505|Ravasaure|Ravasaur|48|49|0|490:60,71;58,79;61,76;62,77;67,63;68,61;61,75;61,82|11477,20015,4588,11108,4587,12184,11315,11185,11184,11186,11188
5267|Atal'ai non-vivant|Unliving Atal'ai|48|49|1|1477:|10633,10780,10630,10781,10782,10626,10629,10625,10627,10628,10632,6181,10623,10631,10624,10634,8152
5256|Guerrier atal'ai|Atal'ai Warrior|48|49|1|1477:|10633,10630,10626,10629,10625,10627,10628,10632,6181,10623,10631,10624,10634,8152
8889|Surveillant Ragenclume|Anvilrage Overseer|48|49|1|1585:|11615,11370,12535,12531,12542,12546,12549,12527,12528,12550,11078,11468
12206|Béhémoth primordial|Primordial Behemoth|48|49|1|2100:|17684
7864|Bien-né survivant|Lingering Highborne|48|50|0|16:40,46;39,61;39,50;39,55;36,48;35,52|14473,14477
6377|Cerf ailé Tête-tonnerre|Thunderhead Stagwing|48|50|0|16:21,79;26,79;39,42;17,79;39,39;34,83;39,40;45,32|10450,20023,4590,5829,11418,11417
5431|Glisseur|Surf Glider|48|50|0|440:65,65;69,57;70,56;50,91;56,96;51,92;61,86;60,82|4419,8167,3712,4556,4555
5432|Glisseur géant|Giant Surf Glider|48|50|1|440:61,82;61,84;48,87;60,88;49,90;58,92;50,93;56,95|9361,8167,9356,9355,9357,9358,3712,4556,4555
6556|Limon de mucus|Muculent Ooze|48|50|0|490:62,25;74,35;70,32;64,37;71,26;67,24;61,38;68,36|12235,15772,11953,11108,20767,11914,11948,20763,11315,11185,11184,11186,11188,3670,3673,3674,7296
9165|Petit pterreurdactyle|Fledgling Pterrordax|48|50|0|490:81,40;77,60;78,59;80,59;80,41;79,38;66,34;77,40|11831,5133,5128,11315,11185,11184,11186,11188
5259|Sorcier-docteur atal'ai|Atal'ai Witch Doctor|48|50|1|1477:|16216,10633,10780,10630,10781,10782,10626,10629,10625,10627,10628,10632,6181,10623,10631,10624,10634,8152
8302|Oeil-de-mort|Deatheye|49|49|4|4:50,21;48,20;46,20;45,20;45,18;45,25;44,26;43,28|8394,4092,11387,4093,11386
8212|Le Jonc|The Reak|49|49|4|47:59,43|20767,20763,3670,3673,3674,7296
8281|Brûlar|Scald|49|49|4|51:51,47;36,56|11129,4787,7077
5349|Arash-ethis||49|49|4|357:45,25|
14339|Hurlemort|Death Howl|49|49|4|361:50,77;48,75;48,78;56,89|11172
12046|Gor'marok le Ravageur|Gor'marok the Ravager|49|49|0|440:42,58|24232
12225|Celebras le Maudit|Celebras the Cursed|49|49|1|2100:|17738,17739,17740,17684
5985|Hyène Raillecroc|Snickerfang Hyena|49|50|0|4:52,57;53,38;52,39;51,40;45,34;46,35;49,37;51,36|8391
5983|Racleur-d'os|Bonepicker|49|50|0|4:54,39;54,36;45,36;55,44;55,45|8168,8396,4425,556,1464,3404,12207,5829,11418,11417
8763|Brumaile insoumis|Mistwing Rogue|49|50|0|16:32,82;25,81;35,82;20,79;37,69;29,81;37,83|
2505|Gueule d'acier des mers|Saltwater Snapjaw|49|50|0|47:85,45;77,86;83,50;83,48;83,59;82,51;84,58;79,65|8167,3712,4556,4555
2647|Mangeur d’âmes Vilebranch|Vilebranch Soul Eater|49|50|1|47:68,78;63,80;66,80;59,67;63,83;60,74;58,72;61,65|9036,9224,9259,8152
2646|Sanguinaire Vilebranch|Vilebranch Blood Drinker|49|50|1|47:65,82;68,77;67,81;59,68;63,83;62,72;61,68|9259,8152
5862|Géomancien du crépuscule|Twilight Geomancer|49|50|1|51:18,38;13,40;18,42;16,43;30,26;24,28;26,25;25,26|10458,10552
5262|Foudroyeur Groddoc|Groddoc Thunderer|49|50|0|357:41,21;44,24;42,22;46,22;43,25;42,23;41,17;49,35|6259,4096,4099,2799
5358|Géant des falaises|Cliff Giant|49|50|1|357:41,26;38,24;38,22;39,24;40,22;41,24;39,22;38,21|9589,9592
5366|Imploratrice céleste Ruissenord|Northspring Windcaller|49|50|0|357:38,14;40,14;39,14;39,13;39,12;40,12;39,11|9530,5116
5364|Pourfendeuse Ruissenord|Northspring Slayer|49|50|0|357:38,15;39,15;38,16;38,12;39,10;41,13;39,11|9530,9355,5116
8960|Charognard Gangrepatte|Felpaw Scavenger|49|50|0|361:50,34;51,32;38,40;42,34;43,24;38,54;44,70|11172
7155|Guide Mort-bois|Deadwood Pathfinder|49|50|0|361:47,93;46,90;49,92;48,89;46,89|21377
7086|Limon maudit|Cursed Ooze|49|50|0|361:41,71;39,71;39,73;40,66;41,66;42,67|12230,20767,11914,11948,20763,3670,3673,3674,7296
8958|Mutilateur de la griffe colérique|Angerclaw Mauler|49|50|0|361:50,16;44,63;38,45;38,43;42,25;38,42;44,66|11172,11408,11409,11410
7105|Satyre Jadefeu|Jadefire Satyr|49|50|0|361:44,86;42,87;43,87;44,88;39,84;39,83;42,84;42,85|11674
5485|Chardonnier taille-racine|Thistleshrub Rootshaper|49|50|0|440:29,65;29,64;29,62;27,66;31,65;31,66;30,66;28,67|
5450|Dard Hazzali|Hazzali Stinger|49|50|0|440:51,74;51,68;55,62;57,70;50,74;56,64;54,72;57,64|
5460|Ravageur des sables Centipaar|Centipaar Sandreaver|49|50|0|440:32,46;32,48;32,44;35,43;35,46;34,42;34,41|8587
5457|Traînard Centipaar|Centipaar Swarmer|49|50|0|440:35,47;32,49;30,47;30,46;33,50;34,49;34,42;35,43|8587
5451|Traînard Hazzali|Hazzali Swarmer|49|50|0|440:52,71;53,68;51,77;54,66;55,63;52,66;52,76;57,63|9262
6511|Batteur Pétale-de-sang|Bloodpetal Thresher|49|50|0|490:74,51;75,44;69,25;64,33;59,35;68,34;66,36;68,30|11316,4426,22529,11315,11185,11184,11186,11188
9162|Jeune dimeurtrodon|Young Diemetradon|49|50|0|490:58,34;70,21;70,28;66,30;61,39;65,35;69,26;72,32|11830,11114,5133,5128,11315,11185,11184,11186,11188
6507|Ravasaure chasseur|Ravasaur Hunter|49|50|0|490:64,50;63,55;63,59;66,49;68,51;68,45;70,53;71,59|11477,20015,4588,11108,4587,12184,11315,11185,11184,11186,11188
6506|Ravasaure coureur|Ravasaur Runner|49|50|0|490:60,79;64,72;63,78;60,81;66,68;68,73;60,74;62,66|11477,20015,4588,11108,4587,12184,11315,11185,11184,11186,11188
5291|Aile-de-givre hakkari|Hakkari Frostwing|49|50|1|1477:|10633,10630,10626,10629,10625,10627,10628,10623,10631,10624,10634
5283|Cavale de cauchemar errante|Nightmare Wanderer|49|50|1|1477:|10633,10630,10629,10625,10627,10628,10632,10623,10631,10624,10634
5270|Charognard atal'ai|Atal'ai Corpse Eater|49|50|1|1477:|10633,10780,10630,10781,10782,10626,10629,10625,10627,10628,10632,6181,10623,10631,10624,10634,8152
8319|Dragonnet de cauchemar|Nightmare Whelp|49|50|0|1477:|10780,10781,10782,10626
8890|Gardien Ragenclume|Anvilrage Warden|49|50|1|1585:|11615,11370,12535,12531,12542,12546,12549,12527,12528,12550,11078,11468
8921|Limier|Bloodhound|49|50|0|1585:|11370,11382
3094|Invisible|Unseen|49|51|0|10:18,54;66,77;52,62;21,57;66,68;54,60;19,54|
8419|Idolâtre du crépuscule|Twilight Idolater|49|51|1|51:29,27;30,26;29,26;29,25|10458,10552
5277|Cavale de cauchemar Plaiedécaille|Nightmare Scalebane|49|51|1|1477:|10633,10630,10626,10629,10625,10627,10628,10632,10623,10631,10624,10634
8303|Grunter||50|50|4|4:56,31;52,27;55,30;58,30;61,26;62,27;63,30;57,29|8392,3403,2295
950|Parleur des marécages|Swamp Talker|50|50|0|8:63,88|8463,8959
6648|Antilos||50|50|4|16:17,54|4590,15420,5829,11418,11417
6372|Claque-pinces Makrinni|Makrinni Snapclaw|50|50|0|16:83,10;89,18;82,11;86,15;69,9;41,16|8959
6651|Portier Hurlerage|Gatekeeper Rageroar|50|50|4|16:38,32|
6369|Tortue corail|Coralshell Tortoise|50|50|0|16:88,15;85,13;69,8;84,11;88,17;85,11;82,9|8167,3712,4556,4555,8959
2521|Gorille Crins-de-ciel|Skymane Gorilla|50|50|0|33:40,77;41,78;40,80;39,87;39,79;42,81;42,83;42,84|4096,4099,2799
1493|Mok'rash||50|50|1|33:23,72|3985
2522|Traqueur jaguero|Jaguero Stalker|50|50|0|33:36,81;37,80;36,84;39,78;38,86;38,83;38,84;37,79|4581,4580
8215|Grimungous||50|50|2|47:70,55|
8636|Morta'gya la Gardienne|Morta'gya the Keeper|50|50|1|47:49,68|9259,8152
7996|Qiaga la Gardienne|Qiaga the Keeper|50|50|1|47:49,68|9241,9259,8152
8278|Fumar|Smoldar|50|50|4|51:30,62|7848,7076,7075,4784
8444|Maître d'artisanat Kovic|Trade Master Kovic|50|50|0|51:35,52|10467
8283|Maître des esclaves Blackheart|Slave Master Blackheart|50|50|4|51:42,23;46,26;41,44;43,35;42,37|
14621|Surveillant Maltorius|Overseer Maltorius|50|50|1|51:41,36|18946
14344|Mongress||50|50|4|361:47,84;43,77;42,75;40,80|11172,11408,11409,11410
8205|Haarka le Féroce|Haarka the Ravenous|50|50|4|440:53,74|
8196|Occulus||50|50|1|440:63,53|4557
8201|Omgorn l'Egaré|Omgorn the Lost|50|50|4|440:39,56|
8204|Soriid le Dévoreur|Soriid the Devourer|50|50|4|440:34,45|
6581|Matriarche ravasaure|Ravasaur Matriarch|50|50|4|490:62,66|11477,20015,4588,4587,12184
3581|Bête des égouts|Sewer Beast|50|50|4|1519:71,49;71,68|770
13601|Artisan Gizlock|Tinkerer Gizlock|50|50|1|2100:|17717,17718,17719,17684
12203|Glissement de terrain|Landslide|50|50|1|2100:|17734,17736,17737,17943,17684
13596|Grippe-charogne|Rotgrip|50|50|1|2100:|17728,17730,17732,770,17684
5988|Aiguillonneur scorpok|Scorpok Stinger|50|51|0|4:57,19;57,23;57,22;52,30;50,17;49,19;44,23;50,22|6756,8393,9144,4623,9206,9224,4426,19935,19936,19933,19934,4872,4867,19441
8675|Gangrebête|Felbeast|50|51|0|4:53,43;51,44;50,38;51,42;47,41;47,38;45,36;54,41|
14388|Drake noir insoumis|Rogue Black Drake|50|51|1|12:59,12;58,11;61,11#46:9,57|
6188|Chaman Grumegueule|Timbermaw Shaman|50|51|0|16:43,18;44,21;45,22;42,19;46,25;46,22;41,22;44,27|19775
193|Draconide bleu|Blue Dragonspawn|50|51|1|16:40,76;37,79;37,76;38,74;36,73;36,74;36,75|
6196|Myrmidon Fouette-bile|Spitelash Myrmidon|50|51|0|16:46,45;43,59;41,48;47,46;48,42;47,57;45,60;48,60|13815
6378|Tempêtueux Tête-tonnerre|Thunderhead Skystormer|50|51|0|16:57,19;57,23;55,22;51,24;52,28;47,19;47,23;58,19|10450,20023,4590,15420,5829,11418,11417
1783|Ecorcheur Squelette|Skeletal Flayer|50|51|0|28:38,56;49,77;38,55;54,80;37,56;39,57;47,80;39,55|9296,14619,13357,22526
1822|Rôdeuse venimeuse des brumes|Venom Mist Lurker|50|51|0|28:33,61;33,54;30,61;32,62;34,67;36,65;32,64;34,58|20610,12205,14227,1081
7033|Ogre Brûlentrailles|Firegut Ogre|50|51|0|46:80,42;79,45;76,50;74,40;82,43;77,44;78,44;74,38|
2648|Garde Aman'zasi Vilebranch|Vilebranch Aman'zasi Guard|50|51|1|47:59,78;58,82;54,84;57,85;57,84;57,86;62,82;59,79|9259,8152
2681|Loup d'attaque Vilebranch|Vilebranch Raiding Wolf|50|51|1|47:62,83;61,79;62,80;59,65;58,76;60,77;59,76|
7099|Chasseur Bec-de-fer|Ironbeak Hunter|50|51|0|361:52,30;41,34;43,65;45,18;38,42;42,54;48,15;39,55|15420,12207,5829,11418,11417
7113|Gardien de Jaedenar|Jaedenar Guardian|50|51|0|361:38,61;36,62;39,60;38,58;39,59;37,61|
7109|Lige de la corruption Jadefeu|Jadefire Felsworn|50|51|0|361:44,86;43,83;43,89;39,81;32,67;35,67;42,86;39,83|11674
7125|Molosse de Jaedenar|Jaedenar Hound|50|51|0|361:38,61;39,62;39,60;39,59;36,61;36,62;34,60|
7106|Voleur Jadefeu|Jadefire Rogue|50|51|0|361:37,66;32,67;37,67;36,67;38,69|13491,11674
6517|Bête du goudron|Tar Beast|50|51|0|490:47,35;48,30;49,32;60,23;65,24;61,32;58,30|11834,11108,12803,11315,11185,11184,11186,11188
6514|Gorille d'Un'Goro|Un'Goro Gorilla|50|51|0|490:69,18;62,17;67,17;69,16;63,20;66,16;69,15;64,16|11478,4096,4099,10781,10782,2799,11315,11185,11184,11186,11188
6508|Ravasaure peau-de-venin|Venomhide Ravasaur|50|51|0|490:71,45;63,53;65,47;67,53;67,49;72,53;72,50;69,57|11477,9356,20015,4588,4587,11914,11948,12184,11315,11185,11184,11186,11188
5280|Cavale de cauchemar wyrmide|Nightmare Wyrmkin|50|51|1|1477:|10780,10630,10781,10782,10626,10629,10625,10627,10628,10632,10623,10631,10624,10634
5273|Grand prêtre atal'ai|Atal'ai High Priest|50|51|1|1477:|10633,10630,10626,10629,10625,10627,10632,6181,10631,10624,10634,8152
5271|Marche-mort atal'ai|Atal'ai Deathwalker|50|51|1|1477:|10633,10630,10626,10629,10625,10627,10628,10632,6181,10623,10631,10624,10634,8152
8891|Garde Ragenclume|Anvilrage Guardsman|50|51|1|1585:|11615,11370,12535,12531,12542,12546,12549,12527,12528,12550,11078,11468
8912|Tortionnaire du Marteau du crépuscule|Twilight's Hammer Torturer|50|51|1|1585:|9036,9224,11615,11382,12535,12531,12542,12546,12549,12527,12528,12550
10990|Bélier d'Alterac|Alterac Ram|50|51|0|2597:45,21;43,22;47,40;44,20;45,22;47,20;47,22;49,28|17642,17411,5119,5120,18228,18226,18229,18230
13676|Bélier d'Alterac à l'écurie|Stabled Alterac Ram|50|51|0|2597:52,38;53,39|17642,5119,5120
10981|Loup des glaces|Frostwolf|50|51|0|2597:50,77;54,85;45,52;45,54;51,74;52,77;49,69;49,70|17643,18229,18230
6195|Sirène Fouette-bile|Spitelash Siren|50|52|0|16:36,50;36,56;39,56;46,43;36,59;36,52;47,51;47,64|16045,20029,13815,24232,8959
1791|Goule écumante|Slavering Ghoul|50|52|0|28:39,55;50,77;39,57;51,76;51,77;37,58;50,80;49,80|9296,13356
1809|Vautour putride|Carrion Vulture|50|52|0|28:30,55;32,62|20611,20610,729,11419,11420,556,15420,3404,12207,11417
7044|Drake noir|Black Drake|50|52|1|46:90,44;85,28;90,57|15416,4557
6557|Limon primitif|Primal Ooze|50|52|0|490:43,65;51,67;56,67;54,63;51,34;49,63;52,66;58,45|12235,15772,11953,11108,20767,11914,11948,20763,11315,11185,11184,11186,11188,3670,3673,3674,7296
9166|Pterreurdactyle|Pterrordax|50|52|0|490:58,87;44,66;43,86;44,93;56,88;44,89;58,91;58,9|11831,5133,5128,11315,11185,11184,11186,11188
8909|Garde du feu|Fireguard|50|52|1|1585:|11129,24232,11615,5173,12552,12535,12555,12531,4787,12542,12546,12549,12527,12528,12550,7078,2928,7077
8300|Ravage||51|51|4|4:59,36;46,34;46,36;47,37;49,36;50,37;60,38;61,37|8391
8760|Cerf Sabots-de-mousse|Mosshoof Stag|51|51|0|16:20,76;14,82;34,79;26,81;34,81|5471,5566,5119,5120
6649|Dame Sesspira|Lady Sesspira|51|51|4|16:35,56|8959
6650|Général Crocdangoiffe|General Fangferror|51|51|4|16:41,54|
6347|Jeune Vandale des flots|Young Wavethrasher|51|51|0|16:84,12;88,17;58,10;86,12;86,13;88,16;88,14;84,13|20087,5569,3010,8959
1559|Roi Mukla|King Mukla|51|51|1|33:41,84|4103,4558,4099,2799
8213|Dos-de-fer|Ironback|51|51|4|47:81,49|8167,3712,4556,4555
10802|Hitah'ya la Gardienne|Hitah'ya the Keeper|51|51|1|47:57,87|19064,9259,8152
7995|Vile prêtresse Maléficia|Vile Priestess Hexx|51|51|1|47:59,78|9472,9259,8152
14345|L'Ongar|The Ongar|51|51|4|361:42,50|12230,20770,20768,20763,3670,3673,3674,7296
14342|Ragepatte|Ragepaw|51|51|4|361:48,93|21377
9464|Seigneur Ror|Overlord Ror|51|51|0|361:48,94|15879,21377
5713|Balafreur|Gasher|51|51|1|1477:|20606,6181,8152
5714|Loro||51|51|1|1477:|20608,6181,8152
5708|Rejeton d'Hakkar|Spawn of Hakkar|51|51|1|1477:|10801,10802,10630,10629,10623,10624,10634
5712|Zolo||51|51|1|1477:|20608,6181,8152
9025|Seigneur Roccor|Lord Roccor|51|51|2|1585:|11630,11631,11632,11813,22234,22397,11129
12201|Princesse Theradras|Princess Theradras|51|51|1|2100:|17684
5991|Peau de cristal Rougepierre|Redstone Crystalhide|51|52|0|4:64,52;45,55;47,49;60,38;60,42;59,41;59,44;59,38|11388,11389,8394,4092,11387
6004|Sectateur lige d'ombre|Shadowsworn Cultist|51|52|0|4:64,33;68,31;63,44;62,40;66,30;65,33;64,34|
6371|Guerrier de la baie des tempêtes|Storm Bay Warrior|51|52|0|16:88,33;83,8;47,15;88,35;88,24;89,17;87,28;90,38|8959
6198|Géomètre elfe de sang|Blood Elf Surveyor|51|52|0|16:59,28;59,27;56,29;55,26;55,30;58,26;57,28|20028
6200|Satyre Legashi|Legashi Satyr|51|52|0|16:66,16;60,24;61,26;66,20;67,18;62,25;52,19|18624
6131|Tisse-magie draconique|Draconic Mageweaver|51|52|1|16:39,85;37,80;43,84;38,81;40,77;43,77;40,85;38,74|
6189|Ursa Grumegueule|Timbermaw Ursa|51|52|0|16:49,29;44,19;45,26;47,28;46,24;41,21;48,29;44,24|
1784|Ensorceleur Squelette|Skeletal Sorcerer|51|52|0|28:36,56;39,54;54,80;36,57;54,81;39,56;39,55|14619,13357,22526
1815|Ours noir malade|Diseased Black Bear|51|52|0|28:37,62;33,55;37,67;38,63;33,56;30,54;39,62;35,64|20611,11408,11409,11410,2940
9777|Fée Flammide|Flamekin Sprite|51|52|0|46:78,50;77,51;80,47;78,75;79,73;79,75|
7034|Ogre-mage Brûlentrailles|Firegut Ogre Mage|51|52|0|46:75,47;79,44;82,36;78,38;82,46;82,41;83,47;81,42|11370
7047|Rejeton noir|Black Broodling|51|52|0|46:87,31;85,32;81,28;81,26;88,33;92,33;91,45;91,47|11370,15416,4557
9690|Worg de braise|Ember Worg|51|52|0|46:91,40;87,56;79,31;84,61;89,51;92,59;90,52|11467
7115|Adepte de Jaedenar|Jaedenar Adept|51|52|0|361:38,62;38,61;39,61;39,58;36,61;35,61|10780,10781,10782
9878|Bête d'entropie|Entropic Beast|51|52|0|361:44,41;43,41;46,39;40,39;44,39;42,38;41,40;44,40|4787,7078,7077
8957|Grizzly de la griffe colérique|Angerclaw Grizzly|51|52|0|361:56,24;57,25;55,24;54,15;61,17;62,17;52,12;56,27|11172,11408,11409,11410
7092|Limon corrompu|Tainted Ooze|51|52|0|361:43,48;40,55;40,54;41,59;35,48;44,49;43,51|20614,12230,20770,20768,11914,11948,20763,3670,3673,3674,7296
8961|Ravageur Gangrepatte|Felpaw Ravager|51|52|0|361:57,21;57,19;54,14;65,20;62,19;62,20;53,27;56,27|11172
7112|Sectateur de Jaedenar|Jaedenar Cultist|51|52|0|361:38,62;38,61;39,62;39,58;36,61;35,61;35,60|15739
7110|Traqueur des ombres Jadefeu|Jadefire Shadowstalker|51|52|0|361:32,66;37,69;37,68;38,67;33,66;38,69|11674
9163|Dimeurtrodon|Diemetradon|51|52|0|490:43,61;57,48;49,60;49,67;43,65;47,67;58,46;56,65|11830,11114,11108,5133,5128,11315,11185,11184,11186,11188
6510|Ecorcheur Pétale-de-sang|Bloodpetal Flayer|51|52|0|490:60,45;58,74;50,65;57,29;60,61;44,25;54,31;57,17|11316,9030,8956,22529,11315,11185,11184,11186,11188
6551|Guêpe Gorishi|Gorishi Wasp|51|52|0|490:51,75;54,75;47,82;48,75;43,76;54,76;52,85;49,82|11837,22435,11315,11185,11184,11186
6513|Marteleur d'Un'Goro|Un'Goro Stomper|51|52|0|490:69,18;62,17;67,17;69,16;63,20;66,16;69,15;64,16|11479,4558,4099,2799,11315,11185,11184,11186,11188
6552|Ouvrier Gorishi|Gorishi Worker|51|52|0|490:48,77;49,77;51,74;52,83;54,85;47,76;49,80;52,81|11837,22435,11315,11185,11184,11186
6527|Rampeur du goudron|Tar Creeper|51|52|0|490:47,32;48,36;49,34;49,33;60,33;60,30;49,29;59,24|3829,11834,12803,11315,11185,11184,11186,11188
8892|Fantassin Ragenclume|Anvilrage Footman|51|52|1|1585:|11615,11382,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550,11078,11468
5981|Chercheur du portail|Portal Seeker|51|53|0|4:55,44;44,34|15727
6201|Voleur Legashi|Legashi Rogue|51|53|0|16:63,25;66,17;61,24;52,21;61,26;67,15;52,19|15728,16219,13491,18624,11914,11948
7031|Elémentaire d'obsidienne|Obsidian Elemental|51|53|0|46:60,58;80,34;70,60;81,51;77,38;75,69;79,37|7076,7075,4784
6553|Ravageur Gorishi|Gorishi Reaver|51|53|0|490:47,74;52,80;45,75;46,77;53,86;48,84;50,78;49,84|11837,22435,11315,11186,11188
9879|Horreur d'entropie|Entropic Horror|51|54|0|361:44,41;43,41;46,39;40,39;44,39;42,38;41,40;44,40|4787,7078,7077
9167|Pterreurdactyle frénétique|Frenzied Pterrordax|51|54|0|490:31,71;21,40;36,79;22,59;35,46;21,61;40,45;37,28|11831,11108,5133,5128,11315,11185,11184,11186,11188
8299|Ecorchebile|Spiteflayer|52|52|4|4:59,43;62,46;60,42;61,40;61,36;62,32;60,36;58,34|8168,8396,9154,10592,11419,11420,1464,15420,3404,12207,11417
13896|Barbe-d'écailles|Scalebeard|52|52|2|16:53,47|10505,8167,3712,4556,4555,8959
6647|Magistère Hawkhelm|Magister Hawkhelm|52|52|4|16:58,31|
6652|Maître Trouilleffroi|Master Feardred|52|52|4|16:66,17;61,25;62,24|
1847|Vilcrin|Foulmane|52|52|4|28:46,52|13356
8217|Mith'rethis l'Enchanteur|Mith'rethis the Enchanter|52|52|2|47:64,78|17050,9259,8152
8400|Obsidion||52|52|1|51:42,24|10446
9861|Moora||52|52|0|361:39,47|
14343|Olm la Sage|Olm the Wise|52|52|4|361:50,33|11419,11420,15420,12207,11417
12124|Grand requin|Great Shark|52|52|1|440:62,96;44,88;65,67;75,58;76,44;70,38;67,87;78,56#47:85,92|5567,537
8198|Tique|Tick|52|52|1|440:63,49|4557
5715|Hukku||52|52|1|1477:|20607,6181,8152
5717|Mijan||52|52|1|1477:|20607,6181,8152
5719|Morphaz||52|52|1|1477:|20019,20022,20025,20085
5716|Zul'Lor||52|52|1|1477:|20606,6181,8152
9018|Grand Interrogateur Gerstahn|High Interrogator Gerstahn|52|52|1|1585:|11140,11624,11625,11626,22240
9319|Maître-chien Grebmar|Houndmaster Grebmar|52|52|1|1585:|11623,11627,11628,11629,11078
13557|Géomètre de Gouffrefer champion|Champion Irondeep Surveyor|52|52|0|2597:53,7|
6006|Adepte lige d'ombre|Shadowsworn Adept|52|53|0|4:67,31;69,31;62,41;67,29;67,32;63,41|
6005|Nervi lige d'ombre|Shadowsworn Thug|52|53|0|4:63,41;68,30;64,44;66,31;69,31;64,47;66,30;65,33|15727
5993|Sanglier infernal|Helboar|52|53|0|4:52,58;51,53;51,56;52,53;50,55;54,50;61,46;59,45|8392,3403,2295
8761|Coursier Sabots-de-mousse|Mosshoof Courser|52|53|0|16:63,16;50,31;66,27;66,24;57,18;51,83;59,79;43,72|20017,20027,10839,5471,5566,5119,5120
6370|Fouilleur Makrinni|Makrinni Scrabbler|52|53|0|16:88,34;88,25;85,29;55,40;89,21;89,33;54,41;89,23|8959
8766|Limon forestier|Forest Ooze|52|53|0|16:66,26;71,31;36,68;44,71;68,29;42,70;77,25;80,24|20023,20767,20763,3670,3673,3674,7296
6148|Marcheur des falaises|Cliff Walker|52|53|1|16:17,54;60,90;84,20;48,82;82,18;52,80;45,86;47,78|11405,10840
6130|Plaiedécaille bleu|Blue Scalebane|52|53|1|16:43,82;42,85;43,85;44,76;40,86;43,74;43,81|
6202|Prêtre noir Legashi|Legashi Hellcaller|52|53|0|16:61,24;67,18;66,19;62,26;65,16;61,23;69,18;52,17|18624
8764|Ravageur Brumaile|Mistwing Ravager|52|53|0|16:64,26;82,17;78,27;74,28;74,17;77,28;66,22;75,33|
6348|Vandale des flots|Wavethrasher|52|53|0|16:92,37;90,31;86,31;89,29;84,29;92,36;84,32;54,42|20087,5569,3010,8959
6199|Vengeur elfe de sang|Blood Elf Reclaimer|52|53|0|16:56,26;57,25;56,27;56,29;59,28;58,30;57,30|20028
1831|Chasseur écarlate|Scarlet Hunter|52|53|0|28:41,52;41,53;39,56;51,44;52,44;52,45|
1821|Rôdeuse putride|Carrion Lurker|52|53|0|28:53,70;46,46;46,43;49,39;47,38;44,40;50,27;47,40|20610,12205,14227,19441
4475|Zombie corrompu|Blighted Zombie|52|53|0|28:46,52;47,55;48,53;47,51;48,51;46,50;47,50;45,51|13356
7035|Brute Brûlentrailles|Firegut Brute|52|53|0|46:81,39;83,43;82,48;81,43;80,45;86,36;81,42;81,47|15732,11370,11382,7296
7040|Draconide noir|Black Dragonspawn|52|53|1|46:85,27;57,61;82,27;87,35;87,28;56,64;93,58;56,61|15416
9776|Flammide cracheur|Flamekin Spitter|52|53|0|46:78,51;79,46;79,47;78,75|
9691|Scorpide dard-venin|Venomtip Scorpid|52|53|0|46:91,33;90,30;89,31;86,58;85,23;89,45;87,60;93,37|19935,19936,19933,19934,4872,4867,19441
12418|Hyène Gordok|Gordok Hyena|52|53|0|357:61,43;62,45;56,44;62,32;61,31;62,34;59,44;62,38|
11443|Ogre-mage Gordok|Gordok Ogre-Mage|52|53|1|357:60,47;64,36;54,45;62,44;65,45;62,28;62,38;63,27|18640,21982
7138|Arbrefer errant|Irontree Wanderer|52|53|0|361:49,20;47,24;53,23|11173,20613,22529,12803
7139|Arbrefer marteleur|Irontree Stomper|52|53|0|361:49,21;49,18;50,19;51,21;47,23;48,28;52,25;52,24|11173,20613,22529,12803
7126|Chasseur de Jaedenar|Jaedenar Hunter|52|53|0|361:37,56;36,57;38,54;37,55;39,48;37,46|11914,11948
7100|Ecorcheur Crochebois|Warpwood Moss Flayer|52|53|0|361:57,22;59,20;55,20;54,17;58,18;57,18;55,17|11503,12803
7107|Entourloupeur Jadefeu|Jadefire Trickster|52|53|0|361:43,16;43,15;46,14;44,14;43,18;41,20;43,19|15744,11674
7098|Hurleur Bec-de-fer|Ironbeak Screecher|52|53|0|361:57,26;62,19;54,27;56,23;57,16;56,11;54,16;64,18|11419,11420,15420,12207,11417
7136|Infernal Sentinelle|Infernal Sentry|52|53|1|361:41,38;41,40;44,41;45,42|7076,7075,4784
7114|Massacreur de Jaedenar|Jaedenar Enforcer|52|53|0|361:40,48;41,49;36,52;35,58;37,53;40,49;39,46;38,47|13140,24231,24232
11553|Pliebois Grumegueule|Timbermaw Woodbender|52|53|0|361:66,1;66,3;65,8#493:36,72|
7108|Traître Jadefeu|Jadefire Betrayer|52|53|0|361:43,14;45,14;39,22;42,20;42,17;42,19|8956,9179,11674,5173,5140,2928
6554|Dard Gorishi|Gorishi Stinger|52|53|0|490:46,85;48,87;49,87;50,80;45,83;44,81|11837,22435,9262
6516|Foudroyeur d'Un'Goro|Un'Goro Thunderer|52|53|0|490:69,18;62,17;67,17;69,16;63,20;66,16;69,15;64,16|11480,4558,4426,4099,2799,11315,11185,11184,11186,11188
6501|Stégodon|Stegodon|52|53|1|490:36,72;36,75;30,78;39,70;41,73;30,62;39,64;30,67|11114,5133,5128,11315,11185,11184,11186,11188
6512|Trappeur Pétale-de-sang|Bloodpetal Trapper|52|53|0|490:29,57;32,72;31,32;35,63;36,38;33,22;41,79;40,36|11316,22529,11315,11185,11184,11186,11188
6555|Tunnelière Gorishi|Gorishi Tunneler|52|53|0|490:47,87;46,89;48,85;47,86;47,83;48,82;45,84;44,82|11837,22435
10221|Jeune worgen Bloodaxe|Bloodaxe Worg Pup|52|53|0|1583:|
8913|Emissaire du crépuscule|Twilight Emissary|52|53|1|1585:|11615
8894|Médecin Ragenclume|Anvilrage Medic|52|53|1|1585:|12532,12551,11615,12547,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550,11078,11468
8893|Soldat Ragenclume|Anvilrage Soldier|52|53|1|1585:|12532,12551,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550,11078,11468
11678|Embusquée Brûleglace|Snowblind Ambusher|52|53|0|2597:40,39;38,37;40,35;45,23;40,30|5116
10991|Gnoll Follepatte|Wildpaw Gnoll|52|53|0|2597:53,93;52,97;52,91|
10986|Harpie Brûleglace|Snowblind Harpy|52|53|0|2597:38,47;41,29;39,34;39,39;49,29;43,23;43,22|9206,5116
11603|Terrassier Blanche-moustache|Whitewhisker Digger|52|53|0|2597:44,69;46,72;44,70;45,72;43,72;45,71;46,70;46,69|5430
10987|Trogg de Gouffrefer|Irondeep Trogg|52|53|0|2597:52,4;51,5;50,6;52,6;50,7;52,7;51,8;53,9|16885,5430,18226
10982|Vermine Blanche-moustache|Whitewhisker Vermin|52|53|0|2597:48,72;47,72;47,71;48,73;47,73;48,71|18230
6380|Concubine Tête-tonnerre|Thunderhead Consort|52|54|0|16:65,26;65,88;77,27;53,84;74,24;49,86;82,24;65,81|10839,10840,10450,20023,11419,11420,4590,15420,11417
6379|Patriarche Tête-tonnerre|Thunderhead Patriarch|52|54|0|16:84,23;73,29;67,28;77,16;81,26;54,75;70,26;51,82|10840,10450,20023,11419,11420,4590,15420,11417
10605|Médecin écarlate|Scarlet Medic|52|54|0|28:41,51;40,52;39,56;41,52;52,45;44,68|
1785|Terreur Squelette|Skeletal Terror|52|54|0|28:45,52;48,51;47,50;46,51;47,51;47,52;46,49|14619,13357,22526
11290|Zombie Mossflayer|Mossflayer Zombie|52|54|0|139:23,73;23,74;23,72;22,71;22,74;24,71;24,75|
11552|Mystique Grumegueule|Timbermaw Mystic|52|54|0|361:65,5;65,3;66,1;68,5|
6559|Limon gluant|Glutinous Ooze|52|54|0|490:31,74;28,61;28,36;38,56;39,21;26,45;41,64;38,32|12235,15772,11953,20770,20768,11914,11948,20763,11315,11185,11184,11186,11188,3670,3673,3674,7296
6518|Rôdeur du goudron|Tar Lurker|52|54|0|490:54,20;49,18;50,23;51,24;46,20;44,21;45,19;45,18|11834,12803,11315,11185,11184,11186,11188
6502|Stégodon cuirassé|Plated Stegodon|52|54|1|490:34,77;28,58;38,61;34,67;38,67;34,62;39,59|11114,5133,5128,11315,11185,11184,11186,11188
8897|Artisan Forge-ruine|Doomforge Craftsman|52|54|0|1585:|16048,22205,9262,11468
8910|Garde du feu flamboyant|Blazing Fireguard|52|54|1|1585:|11129,12532,12551,12547,12552,12535,12555,12531,4787,12542,12546,12549,12527,12528,12550,7078,7077
8896|Paysan Ombreforge|Shadowforge Peasant|52|54|0|1585:|24231,11615,11468
8916|Spectateur de l'arène|Arena Spectator|52|54|0|1585:|
8301|Clack le Ravageur|Clack the Reaver|53|53|4|4:48,39;50,36;53,38;54,33;55,29;58,36;60,35;59,37|8393,19933,19934,4872,4867,19441
8409|Maître-caravanier Tset|Caravan Master Tset|53|53|0|16:44,56|8959
10077|Gueule-du-trépas|Deathmaw|53|53|4|46:87,50;83,30;76,33;82,57|11467
7093|Vil limon|Vile Ooze|53|53|0|361:37,45;37,46;37,47;37,52|11953,20770,20768,11948,20763,3670,3673,3674,7296
6585|Uhk'loc||53|53|4|490:68,13|4558,4099,2799
5722|Hazzas||53|53|1|1477:|
5711|Ogom le Misérable|Ogom the Wretched|53|53|1|1477:|10803,10804,10805,6181,8152
9681|Jaz||53|53|1|1585:|12555,12546,12549,12527,12550
6008|Démoniste lige d'ombre|Shadowsworn Warlock|53|54|0|4:42,40;39,32;43,40;42,42;43,42;41,33;40,33|
5977|Marteleur Cognepeur|Dreadmaul Mauler|53|54|0|4:50,43;47,41;47,43;49,41;48,42;48,45;48,43;49,43|
6007|Massacreur lige d'ombre|Shadowsworn Enforcer|53|54|0|4:43,41;44,42;38,31;44,41;39,32;41,39;40,31;39,31|
7669|Serviteur de Grol|Servant of Grol|53|54|0|4:41,14;43,11;48,43|
6135|Claqueur Arkkoran|Arkkoran Clacker|53|54|0|16:78,36;77,44;80,31;79,32;77,37;78,39;76,37;76,38|9030,9179,8959
6147|Foudroyeur des falaises|Cliff Thunderer|53|54|1|16:62,87;57,87;49,87;50,78;54,90;77,15;54,81;53,79|11405,10839
6349|Grand Vandale des flots|Great Wavethrasher|53|54|0|16:60,94;66,72;79,93;81,84;69,75;64,97;53,95;50,96|20087,5569,3010,8959
6136|Habitant du bourbier Arkkoran|Arkkoran Muckdweller|53|54|0|16:76,44;78,32;78,43;81,36;77,32;77,36;81,34;78,44|8959
7885|Maître de guerre Fouette-bile|Spitelash Battlemaster|53|54|0|16:67,92;66,77;69,83;67,91;69,91;68,83;71,90;68,92|13815,8959
6352|Rôdeuse corail|Coralshell Lurker|53|54|0|16:92,34;59,95;68,34;80,85;75,75;79,86;53,96;86,30|8167,3712,4556,4555,8959
6129|Seigneur-mage draconique|Draconic Magelord|53|54|1|16:42,76;42,84;43,75;43,82;40,85|
6143|Servant d’Arkkoroc|Servant of Arkkoroc|53|54|1|16:65,69;54,45;62,58;59,41;75,73;62,70;78,74;75,69|8959
4474|Cadavre pourrissant|Rotting Cadaver|53|54|0|28:46,54;48,50;48,51;47,53;47,51;45,54;46,51|13356
1835|Conjureur écarlate|Scarlet Invoker|53|54|0|28:40,53;39,56;47,51;40,52;52,44;44,68;41,51|8957
1817|Loup malade|Diseased Wolf|53|54|0|28:53,70;46,46;46,43;49,39;47,38;44,40;50,27;47,40|
7036|Espion de Thaurissan|Thaurissan Spy|53|54|0|46:56,36;55,37;63,36;71,36;63,39;70,39;66,42;66,43|
7048|Rejeton brûlant|Scalding Broodling|53|54|0|46:58,32;61,31;64,57;71,62;38,63;35,55;41,49;59,32|11382,4557
9694|Worg de braise écumant|Slavering Ember Worg|53|54|0|46:72,47;68,61;62,60;63,54;58,64|11467
7041|Wyrmide noir|Black Wyrmkin|53|54|1|46:88,40;58,61;77,62;89,35;85,27;91,56;93,54;88,37|15416
8596|Chien pestiféré chétif|Plaguehound Runt|53|54|0|139:39,74;13,67;5,45;16,56;28,72;60,69;46,67;38,68|
8555|Démon des cryptes|Crypt Fiend|53|54|0|139:11,25;11,24;6,32;6,31;13,25;13,26;28,18;23,29|22525,19441
9447|Gardien écarlate|Scarlet Warder|53|54|1|139:69,66;60,72;72,73;72,72;73,72;70,73;60,70;68,68|16222
8547|Sectateur de la mort|Death Cultist|53|54|0|139:34,27;23,22|
8523|Soldat du Fléau|Scourge Soldier|53|54|0|139:32,27;22,24;17,25;36,28;39,19;12,25;14,25;13,24|22526
10698|Zombie invoqué|Summoned Zombie|53|54|0|139:52,60|
11442|Marteleur Gordok|Gordok Mauler|53|54|1|357:65,36;64,26;61,26;59,36;61,32;63,26;66,36;63,33|21982
11440|Massacreur Gordok|Gordok Enforcer|53|54|1|357:60,47;65,44;65,29;59,43;61,43;57,45;61,40|21982
7158|Chaman Mort-bois|Deadwood Shaman|53|54|0|361:64,7;61,11;62,12;63,11;62,13;63,7;62,6|15752,20741,15754,21377
7101|Déchireur Crochebois|Warpwood Shredder|53|54|0|361:58,22;59,21;60,20;57,22;58,18;58,19;57,18|11503,9154,12803
7120|Démoniste de Jaedenar|Jaedenar Warlock|53|54|0|361:40,49;39,50;36,57;37,55;38,53;40,47;38,45;37,47|13140
11516|Garde Grumegueule|Timbermaw Warder|53|54|0|361:66,3;65,3;65,7;65,4;67,4;67,3|
7135|Garde du corps infernal|Infernal Bodyguard|53|54|1|361:41,38;41,40;44,41;45,42|7076,7075,4784
7132|Horreur toxique|Toxic Horror|53|54|0|361:49,27;49,23;48,24;51,27;50,27;51,23;50,24|12822,7080,4791,7079,11914,11948,7070
7111|Implorateur de l'enfer Jadefeu|Jadefire Hellcaller|53|54|0|361:42,14;43,14;42,22;40,22;41,21;41,19|11674
7156|Protecteur Mort-bois|Deadwood Den Watcher|53|54|0|361:64,6;60,8;63,13;63,10;63,8;61,7;61,6;62,6|20741,15754,21377
7118|Tisseur d'ombre de Jaedenar|Jaedenar Darkweaver|53|54|0|361:41,48;38,48;37,55;36,52;38,51;38,50;40,48|13140
6520|Elémentaire de brûlure|Scorching Elemental|53|54|0|490:47,54;54,55;47,53;50,53;53,46;50,44;54,44;55,45|15564,11829,4426,11108,4787,7078,7077
6519|Seigneur du goudron|Tar Lord|53|54|0|490:48,22;48,19;54,25;49,21;50,25;42,21;47,15;46,15|11834,12803,11315,11185,11184,11186,11188
6503|Stégodon à pointes|Spiked Stegodon|53|54|1|490:32,75;39,81;36,69|11114,5133,5128,11315,11185,11184,11186,11188
7442|Guide Tombe-hiver|Winterfall Pathfinder|53|54|0|618:42,45;43,43;31,35;39,43;41,43;31,37;34,36;30,36|12771,12431,20742,21383,12820
7444|Ours Crocs acérés|Shardtooth Bear|53|54|0|618:36,39;46,47;46,42;40,37;39,38;53,37;45,44;39,39|12432,12622,21928,11408,11409,11410
9416|Worg du Bouclier balafré|Scarshield Worg|53|54|0|1583:|4421,9187,9154,4426,12533
8905|Assemblage porteguerre|Warbringer Construct|53|54|1|1585:|11920,11929,22254,22255,22256,11923,22205,11269,11926,11129,12532,12551,9262,12547,11370,11382,12552,12535,12555,12531
8914|Garde du corps du crépuscule|Twilight Bodyguard|53|54|1|1585:|12532,12551,12547,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550
8895|Officier Ragenclume|Anvilrage Officer|53|54|1|1585:|11444,11325,12532,12551,11615,12547,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550,11078,11468
11837|Chaman Follepatte|Wildpaw Shaman|53|54|0|2597:51,96;51,94|
11600|Chaman de Gouffrefer|Irondeep Shaman|53|54|0|2597:52,5;51,6;52,7;50,8;52,8;52,6;51,9|5430
11604|Géomancien Blanche-moustache|Whitewhisker Geomancer|53|54|0|2597:44,68;46,71;43,69;46,68;46,72;45,70;44,69|
11675|Imploratrice céleste Brûleglace|Snowblind Windcaller|53|54|0|2597:41,38;40,32;39,31;42,29;50,27;43,23|5116
1787|Bourreau Squelette|Skeletal Executioner|53|55|0|28:46,67;46,69;50,68;50,67;44,62;42,62;40,68;45,67|14619,13357,8957,22526
7045|Drake brûlant|Scalding Drake|53|55|1|46:60,59;64,58|4557
7037|Marchefeu de Thaurissan|Thaurissan Firewalker|53|55|0|46:64,41;54,40;61,37;61,42;65,42;66,44;66,40|14482,14490
7039|Ravageur de guerre|War Reaver|53|55|0|46:61,35;53,38;56,34;57,35;67,40;67,36;69,39|11266,11382
8600|Chauve-souris pestiférée|Plaguebat|53|55|0|139:12,64;53,74;20,80;29,72;37,74;25,59;17,58;57,66|11395,11402,11403,11404
9452|Enchanteur écarlate|Scarlet Enchanter|53|55|1|139:59,71;69,69;74,68;74,74;73,73;73,68;74,70|16242,13479
8540|Hurleuse déchirée|Torn Screamer|53|55|0|139:38,22;16,26;34,25;20,18;38,27;36,17;14,24;13,24|21935
11291|Non-vivant Mossflayer|Unliving Mossflayer|53|55|0|139:23,73;23,74;22,72;24,72;25,73|
9164|Ancien dimeurtrodon|Elder Diemetradon|53|55|0|490:33,71;36,61;42,74;34,64;41,50;41,36;37,44;32,36|11830,11114,11108,5133,5128,11315,11185,11184,11186,11188
7457|Chardon de glace insoumis|Rogue Ice Thistle|53|55|0|618:49,47;49,34;40,39;48,44;32,40;29,47;44,39;43,37|12366,12435
7450|Chouettard éreinté|Ragged Owlbeast|53|55|0|618:48,46;55,38;45,36;37,36;29,48;54,37;53,38;38,38|12433,18590,11419,11420,15420,12207
7447|Petite Noroît|Fledgling Chillwind|53|55|0|618:30,48;49,45;44,44;49,41;51,39;37,44;45,42;45,36|12434,12444,12623
8298|Akubar le Prophète|Akubar the Seer|54|54|4|4:51,53;58,46;61,44;61,45;59,44;52,52;46,48;45,48|
6646|Monnos l’Ancien|Monnos the Elder|54|54|2|16:76,25|
12125|Requin mammouth|Mammoth Shark|54|54|1|16:80,92;78,95;61,52;79,76;69,35;64,39;67,5;81,91|5567,537,8959
10801|Goule jacassante|Jabbering Ghoul|54|54|0|28:37,58|12722,13356
11614|Sanguin|Bloodshot|54|54|0|28:58,36|
9176|Gor'tesh||54|54|0|46:39,55|11080
9604|Gorgon'och||54|54|4|46:80,41;78,41;79,45;80,42;77,43|
9602|Hahk'Zor||54|54|4|46:81,48;82,48;82,44;82,42|
8977|Krom'Grul||54|54|0|46:80,47|11058,11382
9695|Scorpide fouet-mortel|Deathlash Scorpid|54|54|0|46:63,56;50,28;73,65;54,67;48,29;65,61;57,27;55,66|19933,19934,4872,4867,19441
14340|Alshirr Souffléau|Alshirr Banebreath|54|54|4|361:40,85|
9860|Salia||54|54|0|361:39,47|
9454|Xavathras||54|54|0|361:32,67|
6582|Matriarche Zavas|Clutchmother Zavas|54|54|4|490:49,85|
5710|Jammal'an le prophète|Jammal'an the Prophet|54|54|1|1477:|6212,10806,10807,10808,6181,8152
9016|Bael'Gar||54|54|1|1585:|11802,11803,11805,11807
9056|Fineous Darkvire||54|54|1|1585:|10999,11839,11840,11841,11842,22223,11078,11468
9680|Tueur des sommets|Crest Killer|54|54|1|1585:|12552,12555,12546,12549,12527,12528,12550,11078,11468
13022|Claque-fouet|Whip Lasher|54|54|0|2557:|18222,18223,18224,18266,18240,18365,5263,22529,18255,18297,12803
13099|Explorateur de Gouffrefer|Irondeep Explorer|54|54|0|2597:52,5;52,7;52,8;50,9;53,6;51,8|
5978|Démoniste Cognepeur|Dreadmaul Warlock|54|55|0|4:50,41;48,45;48,44;49,46;47,46;48,43;47,44|
6010|Gangrechien|Felhound|54|55|0|4:63,58;62,55;60,51;58,51;56,50|
6011|Gangregarde sentinelle|Felguard Sentry|54|55|0|4:58,51;62,52;58,49;55,52;60,52|18623
6009|Lige d'ombre tisseur d’effroi|Shadowsworn Dreadweaver|54|55|0|4:39,33;43,42;38,31;39,32;39,31;44,40|
7670|Serviteur d'Allistarj|Servant of Allistarj|54|55|0|4:64,34;64,47;63,41|
6146|Brise-falaises|Cliff Breaker|54|55|1|16:57,80;55,90;76,20;49,79;75,27;60,82;58,82;49,71|15763,12800,11405,10839,10840
7886|Ensorceleuse Fouette-bile|Spitelash Enchantress|54|55|0|16:70,85;71,81;70,84;71,90;66,91;70,81;66,78|13815,8959
6144|Fils d’Arkkoroc|Son of Arkkoroc|54|55|1|16:57,54;59,65;56,58;54,61;54,57;57,42;57,50;62,38|15764,8959
6138|Oracle Arkkoran|Arkkoran Oracle|54|55|0|16:77,44;74,38;79,42;78,43;79,38;76,37;75,45|15753,8959
6351|Oracle de la baie des tempêtes|Storm Bay Oracle|54|55|0|16:78,84;63,72;60,72;80,89;66,85;65,85;47,92;62,95|8959
6350|Pince-tranchante Makrinni|Makrinni Razorclaw|54|55|0|16:71,75;62,72;80,89;66,86;64,71;68,75;55,70;54,68|8959
6137|Pinceur Arkkoran|Arkkoran Pincer|54|55|0|16:75,44;79,32;76,42;77,46;77,44;78,42;76,45;79,39|8959
1833|Chevalier écarlate|Scarlet Knight|54|55|0|28:50,41;53,37;46,34;50,40;50,42;51,40;47,32|
1806|Gelée maléfique|Vile Slime|54|55|0|28:63,38;66,42;66,40;65,39;64,36;67,41;64,37;66,38|20770,20768,20763,3670,3673,3674,7296
1794|Goule dévastée|Soulless Ghoul|54|55|0|28:39,69;43,73;42,71;48,70;40,70;42,72;45,63;40,67|13356,8957
1793|Goule purulente|Rotting Ghoul|54|55|0|28:55,66;54,65;53,64;52,65;54,68;53,66|13356
1824|Rôdeuse pestilentielle|Plague Lurker|54|55|0|28:67,48;56,54;58,60;64,50;65,46;67,55;56,61;66,55|20610,12205,14227,19441
11355|Guerrier Gurubashi|Gurubashi Warrior|54|55|1|33:51,17;51,18;52,17;53,17;53,18;50,16|
7038|Agent de Thaurissan|Thaurissan Agent|54|55|0|46:57,36;65,34;64,37;63,39;66,40|
7055|Worg Blackrock|Blackrock Worg|54|55|0|46:49,58;56,54;39,55;51,53;45,58|11467
9449|Clerc écarlate|Scarlet Cleric|54|55|1|139:69,67;73,68;72,72;69,71;71,71;71,74;74,67|13479
8519|Fléau|Blighted Surge|54|55|0|139:55,71;52,67;53,66;56,68;53,71;53,70;55,67;55,70|7080,4791,7079,7070
8530|Goule cannibale|Cannibal Ghoul|54|55|0|139:19,13;36,26;35,20;26,28;33,29;37,16;13,24;31,17|
8603|Larve putride|Carrion Grub|54|55|0|139:58,51;60,57;62,69;58,48;45,53;38,61;26,66;18,61|13853,18512
8524|Mage maudit|Cursed Mage|54|55|0|139:34,18;36,18;21,14;30,29;29,21;14,26;31,24;39,17|22526
8553|Nécromancien|Necromancer|54|55|0|139:35,31;23,29;37,19;28,18;26,22;26,21;26,15|
8607|Vase pourrissante|Rotting Sludge|54|55|0|139:65,51;66,52;49,58;47,58;48,55;67,49;67,53|20770,20768,20763,3670,3673,3674,7296
12250|Zaeldarr le Banni|Zaeldarr the Outcast|54|55|0|139:23,73|15785
7157|Vengeur Mort-bois|Deadwood Avenger|54|55|0|361:61,8;64,8;63,12;63,10;63,8;63,7;60,6|20741,21377
6521|Brasier vivant|Living Blaze|54|55|0|490:45,48;56,58;52,49;50,48;51,45;48,50;50,46;53,51|11829,11108,4787,7078,7077,11184
6498|Diablosaure|Devilsaur|54|55|1|490:35,22;57,24;31,36|20016,20015,4588,4587,11315,11185,11184,11186,11188
6500|Diablosaure Rex|Tyrant Devilsaur|54|55|1|490:74,33;50,61|20016,20015,4588,4587,11315,11185,11184,11186,11188
6504|Stégodon Grondeterre|Thunderstomp Stegodon|54|55|1|490:29,69;34,72|11114,5133,5128,11186,11188
7523|Bien-né souffrant|Suffering Highborne|54|55|0|618:51,46;54,42;52,45;53,40;57,43;53,41;52,41;54,44|21936
10659|Dragonnet cobalt|Cobalt Whelp|54|55|0|618:58,52;60,51;60,50;52,56;57,49;57,50;54,51;55,51|4557
7441|Totémique Tombe-hiver|Winterfall Totemic|54|55|0|618:39,45;40,44;40,43;41,43;33,37;30,36|15761,12771,12431,20742,21383,12820
11735|Scorpide Cinglepierre|Stonelash Scorpid|54|55|0|1377:73,37;49,13;62,27;64,14;43,41;62,41;63,20;60,28|20373,22381,19933,19934,4872,4867,19441
9045|Acolyte du Bouclier balafré|Scarshield Acolyte|54|55|1|1583:|12533,22138
9257|Démoniste du Bouclier balafré|Scarshield Warlock|54|55|1|1583:|9214,16673,16703,12533,22138
9098|Lieur de sort du Bouclier balafré|Scarshield Spellbinder|54|55|1|1583:|16683,16696,12533,22138
9097|Légionnaire du Bouclier balafré|Scarshield Legionnaire|54|55|1|1583:|16735,16713,12533,22138
9199|Massacreur Pierre-du-pic|Spirestone Enforcer|54|55|1|1583:|12533,21982
9201|Ogre-magus Pierre-du-pic|Spirestone Ogre Magus|54|55|1|1583:|4388,9061,12562,21982
8915|Ambassadeur du Marteau du crépuscule|Twilight's Hammer Ambassador|54|55|0|1585:|
8899|Dragon Forge-ruine|Doomforge Dragoon|54|55|1|1585:|11614,12532,12551,11615,12547,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550,11078,11468
8900|Forgeron des arcanes Forge-ruine|Doomforge Arcanasmith|54|55|0|1585:|16053,11614,11468
9956|Gardien des flammes Ombreforge|Shadowforge Flame Keeper|54|55|0|1585:|11885
8906|Golem ravarage|Ragereaver Golem|54|55|1|1585:|11269,11614,11129,12532,12551,12547,11370,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550
8922|Limier mastiff|Bloodhound Mastiff|54|55|0|1585:|
8898|Maréchal Ragenclume|Anvilrage Marshal|54|55|1|1585:|15770,15994,18631,11614,12532,12551,11615,12547,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550,11078,14227
8901|Réserviste Ragenclume|Anvilrage Reservist|54|55|0|1585:|
13196|Flagellant phasique|Phase Lasher|54|55|1|2557:|18295,18222,18223,18224,22529,18255,18297,12803
11462|Tréant Crochebois|Warpwood Treant|54|55|1|2557:|9155,18289,22529,18255,18297,12803
11605|Surveillant Blanche-moustache|Whitewhisker Overseer|54|55|0|2597:44,69|5430
1884|Bûcheron écarlate|Scarlet Lumberjack|54|56|0|28:47,32;48,31;46,33;49,31;45,34;47,33;48,32;44,34|8957
10580|Zombie fétide|Fetid Zombie|54|56|0|28:54,68;53,65;52,68|13356
9779|Flammide enragé|Flamekin Rager|54|56|0|46:37,60;37,61;36,64;36,65;66,29;51,35;34,58;71,31|
9778|Flammide incendiaire|Flamekin Torcher|54|56|0|46:37,61;36,63;65,29;51,35;36,58;71,32|
8601|Chauve-souris pestiférée nuisible|Noxious Plaguebat|54|56|0|139:69,61;46,43;40,55;42,49;53,48;46,51;52,46;52,50|11395,11402,11403,11404
8534|Gargouille putride|Putrid Gargoyle|54|56|0|139:19,12;40,60;49,65;33,16;68,53;69,56;38,71;16,58|
6499|Diablosaure Cuiracier|Ironhide Devilsaur|54|56|1|490:57,62|20016,20015,4588,4587,11315,11185,11184,11186,11188
14460|Envahisseur flamboyant|Blazing Invader|54|56|0|490:44,48|11829,4787,7078,7077
7451|Chouettard enragé|Raging Owlbeast|54|56|0|618:61,30;60,37;51,34;60,32;56,28;60,33|12433,18590,11419,11420,15420,12207
10661|Dévoreur de sorts|Spell Eater|54|56|0|618:58,52;53,56;57,49;58,54;62,51;59,50;57,50;55,50|4557
7443|Marteleur Crocs acérés|Shardtooth Mauler|54|56|0|618:69,48;62,48;52,33;62,45;60,41;64,26;55,48;57,29|12432,12622,21928,11408,11409,11410
9258|Ecumeur du Bouclier balafré|Scarshield Raider|54|56|1|1583:|16680,16716,16717,12533,22138
9200|Ravageur Pierre-du-pic|Spirestone Reaver|54|56|1|1583:|12562,24281,5140,21982,2928
8902|Citoyen Ombreforge|Shadowforge Citizen|54|56|0|1585:|11468
8911|Destructeur Garde du feu|Fireguard Destroyer|54|56|1|1585:|11926,11614,11129,12532,12551,12547,11370,11382,12552,12535,12555,12531,4787,12542,12546,12549,12527,12528,12550,7078
2931|Zaricotl||55|55|2|3:56,62;35,66;34,54|11419,11420,556,15420,3404,12207,11417
7728|Kirith le Damné|Kirith the Damned|55|55|1|4:69,31|
6140|Hetaera||55|55|1|16:57,45|10598,10599,10600,5569,3010,8959
8408|Seigneur de guerre Krellian|Warlord Krellian|55|55|0|16:41,53|23250,8959
10816|Squelette errant|Wandering Skeleton|55|55|0|28:48,50|12738,13357,22526
10078|Lueur terrifiante|Terrorspark|55|55|4|46:42,47;42,45;46,43;49,43;68,31;64,38;51,43;69,32|
14467|Kroshius||55|55|1|361:46,35|18625
9862|Légionnaire de Jaedenar|Jaedenar Legionnaire|55|55|0|361:36,46;38,46;39,51;36,56;38,55;38,53;40,49|18622,13140
9877|Prince Xavalis||55|55|0|361:37,57|
10648|Xavaric||55|55|0|361:39,22|11668
9622|U'cha||55|55|0|490:68,13|11476,4558,4099,2799
10197|Mezzir le hurleur|Mezzir the Howler|55|55|4|618:45,37|
5709|Ombre d'Eranikus|Shade of Eranikus|55|55|1|1477:|10454
9677|Ograbisi||55|55|1|1585:|12535,12542,12546,12528
9017|Seigneur Incendius|Lord Incendius|55|55|1|1585:|11126,11764,11765,11766,11767,21987,19268,11129
9042|Verek||55|55|2|1585:|11755,22242
15333|Nourrisseur silicieux|Silicate Feeder|55|55|0|3429:|18512,21804,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,7078,20858,20859,20860,20861,20862
15168|Scarabée vil|Vile Scarab|55|55|0|3429:|22202,21222,19441
15514|Œuf de Buru|Buru Egg|55|55|0|3429:|
7671|Serviteur de Sevine|Servant of Sevine|55|56|0|4:41,40;38,34;43,41|
1789|Acolyte Squelette|Skeletal Acolyte|55|56|0|28:50,64;47,74;48,65;40,69;44,67;43,63;40,70;46,73|14619,13357,22526
1812|Béhémoth pourrissant|Rotting Behemoth|55|56|0|28:64,34;62,36;67,39;61,37;62,33;62,38;63,35;61,36|13496,12803
1796|Goule glaciale|Freezing Ghoul|55|56|0|28:53,67;54,63;55,66;53,65;53,66;53,64|13356
1795|Goule incendiaire|Searing Ghoul|55|56|0|28:43,69;39,67;46,69;47,72;41,66;47,68;45,71;41,68|13356
1816|Grizzly malade|Diseased Grizzly|55|56|0|28:67,48;56,54;58,60;64,50;65,46;67,55;56,61;66,55|20611,11408,11409,11410
1808|Limon dévorant|Devouring Ooze|55|56|0|28:64,36;62,35;63,36;62,36;65,34;61,35;61,37|20770,20768,20763,3670,3673,3674,7296
1826|Mage écarlate|Scarlet Mage|55|56|0|28:58,36;51,40;53,37;53,38;54,38;57,36|
1834|Paladin écarlate|Scarlet Paladin|55|56|1|28:42,16;43,18;43,16;45,18;47,14;47,13;43,13|4375
1827|Sentinelle écarlate|Scarlet Sentinel|55|56|1|28:47,20;43,16;42,16;48,20;48,22;45,16|8957
11346|Oracle Hakkari|Hakkari Oracle|55|56|1|33:52,18;52,17;51,18;51,17;53,18;53,17;50,18|
7369|Brute de Deuillevent|Deadwind Brute|55|56|0|41:58,60;58,65;59,68;55,63;59,75;57,77;52,59;54,57|24281,2928
7376|Ombre céleste|Sky Shadow|55|56|0|41:40,53;43,45;41,41;47,25;41,49;36,41;50,47;45,63|11419,11420,556,15420,3404,12207,11417
7049|Rejeton Flammécaille|Flamescale Broodling|55|56|0|46:25,47;24,67;29,58;22,69;23,71;22,59;25,46;17,55|4557
7025|Soldat Blackrock|Blackrock Soldier|55|56|0|46:56,54;45,51;49,59;42,56;42,55;43,56;49,57;45,57|15738,11467
7026|Sorcier Blackrock|Blackrock Sorcerer|55|56|0|46:50,54;44,56;53,53;55,54;50,61;51,61;43,37;41,33|11467
9697|Worg de braise géant|Giant Ember Worg|55|56|0|46:27,58;26,63;24,69;24,59|11467
8597|Chien pestiféré|Plaguehound|55|56|0|139:58,49;47,48;46,48;66,53;66,61;58,59;57,59;42,53|
8525|Gardien du Fléau|Scourge Warder|55|56|0|139:22,17;32,24;32,19;26,19;29,17;53,59;53,62|15447,22526
8551|Invocateur des ténèbres|Dark Summoner|55|56|0|139:53,60;52,59;54,58;52,60;35,31;23,29;37,19;28,18|14485
8556|Marcheur des cryptes|Crypt Walker|55|56|0|139:7,29;12,24;10,26;20,16;8,28;14,26|22525,19441
8606|Pourriture vivante|Living Decay|55|56|0|139:50,56;64,51;66,50;47,60;45,59;67,49;64,53;46,60|20770,20768,20763,3670,3673,3674,7296
8520|Ravageur de la peste|Plague Ravager|55|56|0|139:54,70;56,69;51,68;58,70;57,68;52,65;53,68;53,69|7080,4791,7079,7070
8538|Serviteur invisible|Unseen Servant|55|56|0|139:52,53;55,55;53,56;53,58;51,60|14480,14477,21935,15447
9450|Vicaire écarlate|Scarlet Curate|55|56|1|139:76,70;77,70;76,71;77,75;74,75;75,74;77,74|13479
7149|Protecteur flétri|Withered Protector|55|56|0|361:52,25|20613,12803
7524|Bien-née angoissée|Anguished Highborne|55|56|0|618:51,46;56,44;52,40;51,47;57,42;51,45;56,45;55,43|16223,21936
7455|Chouette du Berceau-de-l'Hiver|Winterspring Owl|55|56|0|618:68,31;63,45;63,27;64,29;55,47;59,29;61,33;58,30|11419,11420,15420,12207,11417
7430|Jeune sabre-de-givre|Frostsaber Cub|55|56|0|618:49,19;50,17;55,11;49,11;50,9;52,9;50,7;49,12|12430,12733,21928,4581,4580,1688,12202
7440|Protecteur Tombe-hiver|Winterfall Den Watcher|55|56|0|618:68,34;42,43;30,36;30,37;66,35;67,34;69,35;68,36|15747,12771,12431,20742,21383,12820
10660|Rejeton de cobalt|Cobalt Broodling|55|56|0|618:58,52;53,56;61,51;59,51;56,51;62,51;58,50;55,50|11108,4557
7435|Wyrmide cobalt|Cobalt Wyrmkin|55|56|1|618:61,51;61,50;57,53;57,52;59,52;56,50;55,50;54,55|18704
7458|Yéti Chardon de glace|Ice Thistle Yeti|55|56|0|618:52,32;67,46;59,34;71,39;69,41;70,40;67,43;66,44|12366,12435
12178|Druide torturé|Tortured Druid|55|56|0|1377:61,58;63,58;63,51;63,50;64,48;60,57;62,54;61,50|18588,21937,4388,9061
11740|Frappeur térébrant|Dredge Striker|55|56|0|1377:37,16;38,29;52,18;56,14;37,35;62,38;54,21;55,31|20424
11738|Glisseuse du sable|Sand Skitterer|55|56|0|1377:62,40;36,23;69,43;67,30;58,18;37,30;63,18;56,27|20376,20552,20541,20545,9154,22381,8956,10592,9224,4426,12205,14227,19441
10375|Jeune araignée du pic|Spire Spiderling|55|56|0|1583:|12586,12205,14227
9267|Lanceur de haches Smolderthorn|Smolderthorn Axe Thrower|55|56|1|1583:|16735
9198|Mystique Pierre-du-pic|Spirestone Mystic|55|56|1|1583:|16244,12562,21982
9239|Mystique Smolderthorn|Smolderthorn Mystic|55|56|1|1583:|16685
9240|Prêtre des ombres Smolderthorn|Smolderthorn Shadow Priest|55|56|1|1583:|4623,9206,10592,16696,9224
8907|Assemblage du marteau de colère|Wrath Hammer Construct|55|56|1|1585:|11269,11614,12532,12551,12547,11370,12552,12535,12555,12531,12542,12546,12549,12527,12528,12550
8903|Capitaine Ragenclume|Anvilrage Captain|55|56|1|1585:|15781,12547,12552,12535,12555,12531,12542,12546,12527,12528,12550,11078,11468
8908|Golem de lave de guerre|Molten War Golem|55|56|1|1585:|11269,11614,11129,12532,12551,12547,11370,12552,12535,12555,12531,12542,12549,12527,12528,12550
8920|Ingénieur de siège|Weapon Technician|55|56|0|1585:|16049,18654,18661,11614,22388
8904|Sénateur Ombreforge|Shadowforge Senator|55|56|0|1585:|11468
10382|Cadavre mutilé|Mangled Cadaver|55|56|1|2017:|17061,13174,18743,18744,18745
10384|Citoyen spectral|Spectral Citizen|55|56|1|2017:|14495,13362,18744
10390|Gardien squelettique|Skeletal Guardian|55|56|0|2017:|10592,12827,18743,18744,18745,22526
11455|Lige de la corruption Follengeance|Wildspawn Felsworn|55|56|1|2557:|18296,18298,18603,18255,18297
11464|Noueur Crochebois|Warpwood Tangler|55|56|1|2557:|18289,22529,18255,18297,12803
11451|Satyre Follengeance|Wildspawn Satyr|55|56|1|2557:|18296,18298,18603,18255,18297
11454|Traître Follengeance|Wildspawn Betrayer|55|56|1|2557:|18296,18298,18603,18255,18297
14462|Envahisseur grondant|Thundering Invader|55|57|0|16:80,26;80,25|7076,7075,4784
1883|Ouvrier écarlate|Scarlet Worker|55|57|0|28:46,12;46,9;45,9;45,13;46,17;45,10;46,11|5173
10608|Prêtre écarlate|Scarlet Priest|55|57|1|28:44,20;47,15;43,20|
7379|Ogre-mage de Deuillevent|Deadwind Ogre Mage|55|57|0|41:58,60;59,69;60,73;53,61;52,57;54,56;52,60;58,73|
7032|Grand élémentaire d'obsidienne|Greater Obsidian Elemental|55|57|0|46:29,62;44,44;55,63;36,61;62,32;41,44;55,49;66,32|11266,7076,7075,4784
9451|Archimage écarlate|Scarlet Archmage|55|57|1|139:75,71;77,71;77,75;76,71;76,75;75,72;77,73|16252,13479
8541|Hurleuse haineuse|Hate Shrieker|55|57|0|139:33,17;33,16;24,20;52,57;55,56;53,59;51,56;52,62|21935,15447
7448|Chimère Noroît|Chillwind Chimaera|55|57|0|618:68,53;68,30;68,49;67,50;55,48;58,45;57,40;66,30|12434,12444,12623
11744|Tempétueux de poussière|Dust Stormer|55|57|0|1377:27,18;32,17;29,23;62,17;63,31;18,27;23,25;21,25|7082,7081,7069
10411|Oeil de Naxxramas|Eye of Naxxramas|55|57|0|2017:|13354
8297|Magronos l'Inflexible|Magronos the Unyielding|56|56|4|4:47,47|
1848|Seigneur Maldazzar|Lord Maldazzar|56|56|4|28:54,80|
11613|Veneur Radley|Huntsman Radley|56|56|0|28:58,36|
8981|Ravageur défectueux|Malfunctioning Reaver|56|56|4|46:79,30;90,46;88,32;86,57;89,57|11266
10825|Gish l'Immobile|Gish the Unmoving|56|56|4|139:65,44|12843
10827|Nécrorateur Selendre|Deathspeaker Selendre|56|56|4|139:75,37|
9462|Chef de clan Saignegueule|Chieftain Bloodmaw|56|56|0|361:63,8|21377
7104|Dessecus||56|56|2|361:58,22|11503,12803
7137|Immolatus||56|56|2|361:43,41|7076,7075,4784
9518|Rakaiah||56|56|0|361:38,51|
9376|Blazerunner||56|56|1|490:49,49|11829,4787,7078,7077
10662|Gueulesort|Spellmaw|56|56|1|618:59,48|4557
10806|Ursius||56|56|1|618:64,24|11408,11409,11410
14476|Krellack||56|56|4|1377:63,17|19933,19934,4872,4867,19441
11736|Pinceur Cinglepierre|Stonelash Pincer|56|56|0|1377:37,51;34,62;32,33;37,64;33,35;59,63;49,56;56,59|20374,22381,19933,19934,7069,4872,4867,7070,10309,19441
9041|Gardien Stilgiss|Warder Stilgiss|56|56|2|1585:|11782,11783,11784,22241,11078
13021|Cogneur Crochebois|Warpwood Crusher|56|56|1|2557:|15754,18289,22529,18255,18297,12803
13276|Diablotin Follengeance|Wildspawn Imp|56|56|0|2557:|18255,18297
13197|Gangrefouet|Fel Lash|56|56|1|2557:|18222,18223,18224,22529,18255,18297,12803
14349|Pimgib||56|56|1|2557:|18354
11456|Traqueur des ombres Follengeance|Wildspawn Shadowstalker|56|56|1|2557:|15994,18296,18298,18603,18631,18365,5263,7191,18255,18297,14227
13086|Aggi Rumblestomp||56|56|0|2597:44,69;44,68|
1788|Chef de guerre Squelette|Skeletal Warlord|56|57|1|28:45,69;45,70;44,63;43,66;47,72;40,72|14619,13357,22526
1805|Golem de chair|Flesh Golem|56|57|1|28:48,69;42,68|13356
12387|Grande gelée maléfique|Large Vile Slime|56|57|0|28:63,37|20770,20768,20763,3670,3673,3674,7296
1813|Horreur décomposée|Decaying Horror|56|57|0|28:62,34;62,36|15771,13496,12803
1832|Magus écarlate|Scarlet Magus|56|57|1|28:45,16;45,15;46,14;47,14;47,13|
1804|Morte gémissante|Wailing Death|56|57|0|28:64,56;64,58;62,58;63,60;65,60;64,57;65,59|13354
4493|Vengeur écarlate|Scarlet Avenger|56|57|0|28:54,24;53,37;51,41;53,38;55,34|8957
7371|Marteleur de Deuillevent|Deadwind Mauler|56|57|0|41:63,77;65,74;63,73;53,65;62,73;61,75|
7042|Draconide Flammécaille|Flamescale Dragonspawn|56|57|1|46:21,45;31,61;20,49;34,71;35,49;32,66;23,48;31,59|15416
7028|Démoniste Blackrock|Blackrock Warlock|56|57|0|46:18,29;18,30;17,29;55,54;44,34;43,38;40,36|11467
7027|Pourfendeur Blackrock|Blackrock Slayer|56|57|0|46:56,54;56,53;55,54;39,56;44,34;44,35;41,33;41,34|13476,15748,11467
9698|Scorpide queue-de-feu|Firetail Scorpid|56|57|0|46:28,58;26,61;29,56;32,56;33,55;27,55;27,60|19933,19934,4872,4867,19441
8605|Dévoreur putride|Carrion Devourer|56|57|0|139:57,21;57,20;40,32;60,20;51,26;42,21;61,40;27,32|13853,18512
8531|Goule bredouillante|Gibbering Ghoul|56|57|0|139:52,58;53,55;52,62;53,62;54,57;53,57;54,55;51,62|15447
8521|Horreur corrompue|Blighted Horror|56|57|0|139:62,25;63,27;62,28;45,42;43,42;45,41;44,43;44,41|7080,4791,7079,7070
8535|Hurleuse putride|Putrid Shrieker|56|57|0|139:56,23;27,31;57,22;24,34;16,30;52,21|
8526|Magicien noir|Dark Caster|56|57|0|139:51,58;52,56;52,60;52,58;51,57;51,56;54,56|14500,14505,15447,22526
9448|Prétorien écarlate|Scarlet Praetorian|56|57|1|139:78,72;77,70;77,69;75,73;75,75;76,72;77,73;77,74|22228
8548|Vil tuteur|Vile Tutor|56|57|0|139:52,59;52,60;52,57;51,57;54,58;53,56|
7439|Chaman Tombe-hiver|Winterfall Shaman|56|57|0|618:68,40;67,35;68,38;68,37;70,38;68,36|12771,12431,20742,21383,12820
7452|Chouettard affolé|Crazed Owlbeast|56|57|0|618:64,61;62,17;67,20;65,60;65,62;63,17;68,23;66,24|12524,12558,12433,18590,11419,11420,15420,12207
7459|Matriarche Chardon de glace|Ice Thistle Matriarch|56|57|0|618:70,39;69,42;71,39;71,38;71,41;72,40;69,41;65,40|12367,12435
7436|Plaiedécaille cobalt|Cobalt Scalebane|56|57|1|618:61,54;58,51;56,50;57,50;54,50;55,53;53,55|18704
7431|Sabre-de-givre|Frostsaber|56|57|0|618:56,12;57,14;53,17;54,17;55,13;56,13;50,19;54,15|12430,12733,21928,4581,4580,1688,12202
12179|Sentinelle torturée|Tortured Sentinel|56|57|0|1377:65,54;63,50;63,56;63,51;64,51;61,56;63,48;62,53|21937
9265|Chasseur d'ombre Smolderthorn|Smolderthorn Shadow Hunter|56|57|1|1583:|16710,16713
9241|Chasseur de têtes Smolderthorn|Smolderthorn Headhunter|56|57|1|1583:|16680
9259|Grunt de Brandefeu|Firebrand Grunt|56|57|1|1583:|15749,16680,16735,16713,22138
9262|Invocateur de Brandefeu|Firebrand Invoker|56|57|1|1583:|13494,16683,16673,16717,5140,22138
9269|Prophète Smolderthorn|Smolderthorn Seer|56|57|1|1583:|16703,16717
9266|Sorcier-docteur Smolderthorn|Smolderthorn Witch Doctor|56|57|1|1583:|16673,24231,24232,5140
9261|Tisseur d’ombre de Brandefeu|Firebrand Darkweaver|56|57|1|1583:|16696,16703,22138
9696|Worg Bloodaxe|Bloodaxe Worg|56|57|0|1583:|
10391|Berserker squelettique|Skeletal Berserker|56|57|0|2017:|12827,18742,18743,18744,18745,22526
10381|Cadavre en décomposition|Ravaged Cadaver|56|57|1|2017:|13174,18742,18743,18744,18745
10385|Citoyen fantomatique|Ghostly Citizen|56|57|1|2017:|13364,18743,18744,18745
10387|Fantôme vengeur|Vengeful Phantom|56|57|0|2017:|
11453|Entourloupeur Follengeance|Wildspawn Trickster|56|57|1|2557:|18603,18255,18297
11457|Invocateur infernal Follengeance|Wildspawn Hellcaller|56|57|1|2557:|18296,18298,18603,18255,18297
11452|Voleur Follengeance|Wildspawn Rogue|56|57|1|2557:|18296,18298,18603,18255,18297
11839|Brute Follepatte|Wildpaw Brute|56|57|0|2597:53,94;53,91;53,97;50,93|18226
11838|Mystique Follepatte|Wildpaw Mystic|56|57|0|2597:52,95|
1802|Ame en peine affamée|Hungering Wraith|56|58|0|28:62,60;61,58;64,58;63,58;64,59;65,59;62,59|13354
1836|Cavalier écarlate|Scarlet Cavalier|56|58|1|28:42,15;42,14|12707
7046|Drake torride|Searscale Drake|56|58|1|46:17,52;32,62;25,67|4557
8602|Chauve-souris pestiférée monstrueuse|Monstrous Plaguebat|56|58|0|139:67,27;45,31;38,35;56,27;27,35;63,35;15,19;46,17|20532,20679,11395,11402,11403,11404
14458|Envahisseur aqueux|Watery Invader|56|58|0|618:55,41;55,42|7080,4791,7079,7070
11746|Grondeur du désert|Desert Rumbler|56|58|0|1377:27,16;25,15;26,14;25,10;46,53;21,14;22,13;23,18|20066,7076,7075,4784
14880|Glisseuse Razzashi|Razzashi Skitterer|56|58|1|1977:|19813,19816,19818,19819,19814,19821,19820,19727,19726,19815,14227,19441
13160|Grouillant putride|Carrion Swarmer|56|58|0|2557:|18266,18365,5263,7079,18255,18297
8304|Dériseffroi|Dreadscorn|57|57|4|4:41,39|
7668|Serviteur de Razelikh|Servant of Razelikh|57|57|0|4:55,49;62,51;54,52;52,57;53,59;63,56;63,57|
11611|Cavalier Durgen||57|57|0|28:55,24|
11383|Grande prêtresse Hai'watna|High Priestess Hai'watna|57|57|1|33:51,16;51,18;51,17|
8978|Thauris Balgarr||57|57|4|46:54,39;55,36;61,36;62,38;65,43;66,44;66,42;71,37|
10821|Hed'mush le Pourrissant|Hed'mush the Rotting|57|57|4|139:48,19;58,41;34,64;59,42|12843
11620|Maraudeur spectral|Spectral Marauder|57|57|0|139:47,55;47,56|
10826|Seigneur Sombrefaux|Lord Darkscythe|57|57|4|139:22,26|12843,22526
11288|Traître spectral|Spectral Betrayer|57|57|0|139:44,41|
9517|Seigneur des ténèbres Fel'dan|Shadow Lord Fel'dan|57|57|0|361:39,47|13207
6583|Gruff||57|57|2|490:38,76|5133,5128,11188
10196|Général Colbatann|General Colbatann|57|57|2|618:55,50;54,50;60,50|18704
10916|Messager Tombe-hiver|Winterfall Runner|57|57|0|618:28,35;28,34#361:60,6|12829,12771,12431,20742,21383,12820
10200|Rak'shiri||57|57|4|618:51,11|4623,9179,4581,4580,1688,12202
14472|Gretheer||57|57|4|1377:39,55|12205,14227,19441
14475|Rex Ashil||57|57|2|1377:46,28|20944,20499
9219|Boucher Pierre-du-pic|Spirestone Butcher|57|57|2|1583:|12608,13286,21982
9156|Ambassadeur Cinglefouet|Ambassador Flamelash|57|57|1|1585:|11808,11809,11812,11814,11832,11129
9033|Général Forgehargne|General Angerforge|57|57|1|1585:|11464,11810,11816,11817,11820,11821,11078,11468
9938|Magmus||57|57|1|1585:|11746,11935,22208,22395,22400,4787
8983|Seigneur golem Argelmach|Golem Lord Argelmach|57|57|1|1585:|11268,11465,11669,11819,11822,11823,11078,11468
10558|Hearthsinger Forresten||57|57|2|2017:|13378,13379,13383,13384,16682,13174,12843
10516|Le Condamné|The Unforgiven|57|57|1|2017:|13404,13405,13408,13409,16717,13174,12843
11082|Messager de Stratholme|Stratholme Courier|57|57|1|2017:|13302,13303,13304,13305,13306,13307,22526
13280|Hydrogénos|Hydrospawn|57|57|1|2557:|18299,18305,18307,18317,18322,18324,19268,7080,7079,7070
14327|Lethtendris||57|57|1|2557:|18301,18302,18311,18325,18426
11490|Zevrim Thornhoof||57|57|1|2557:|18306,18308,18313,18319,18323
1045|Draconide rouge|Red Dragonspawn|57|58|1|11:80,48;79,47|
4494|Lieur de sort écarlate|Scarlet Spellbinder|57|58|0|28:54,36;55,24;55,23;55,34|16252
4472|Vision cauchemardesque|Haunting Vision|57|58|0|28:64,58;63,61;64,57;62,61;65,59;63,58;62,58|13354
7372|Démoniste de Deuillevent|Deadwind Warlock|57|58|0|41:66,78;61,62;62,76;63,75;63,77|16246
7029|Maître de guerre Blackrock|Blackrock Battlemaster|57|58|0|46:41,35;39,35;40,33;41,33;40,34;41,34;40,35|15774,11467
7043|Wyrmide Flammécaille|Flamescale Wyrmkin|57|58|1|46:30,61;37,49;32,61;21,46;34,70;31,62;37,47;36,49|15416
8598|Chien pestiféré frénétique|Frenzied Plaguehound|57|58|0|139:57,26;17,20;17,18;45,24;51,27;61,38;27,33;39,32|17709,9155,9030,8956,9224
8560|Eclaireur Mossflayer|Mossflayer Scout|57|58|0|139:62,13;62,9;62,10;61,10;61,12;56,16;55,18|
8527|Garde du Fléau|Scourge Guard|57|58|0|139:57,28;59,28;60,31;60,33;61,32;58,32;58,29;57,29|22526
13118|Garde du corps cramoisi|Crimson Bodyguard|57|58|1|139:52,31;51,30;51,31|
8539|Gardien aveugle|Eyeless Watcher|57|58|0|139:69,37;34,40;61,22;74,30;63,23;35,43;30,50;33,46|21935
8557|Horreur des cryptes|Crypt Horror|57|58|0|139:10,25;7,28;9,28;10,24;7,29;9,27;59,32|22525,19441
8543|Horreur raccommodée|Stitched Horror|57|58|0|139:27,23;30,20;24,18;35,28;32,15;18,20;27,18;52,62|15447
8522|Monstruosité de la peste|Plague Monstrosity|57|58|0|139:64,28;45,40;44,39;44,41;44,43|7080,4791,7079,7070
7068|Acolyte condamné|Condemned Acolyte|57|58|1|267:18,78;20,78;18,77;20,77|3692
7072|Justicier maudit|Cursed Justicar|57|58|1|267:15,82;14,84;16,80;17,84|22229,3692
7071|Paladin maudit|Cursed Paladin|57|58|1|267:19,81;16,77;18,78;13,83;20,76;18,77;20,77;17,77|22229,3692
7445|Ancien Croc acéré|Elder Shardtooth|57|58|0|618:58,60;59,16;58,15;63,55;60,15;62,22;59,26|12432,12622,21928,11408,11409,11410
7453|Chouettard lunaire|Moontouched Owlbeast|57|58|0|618:65,18;63,20;66,63;59,59;59,60;66,18;66,22;63,21|12524,12558,12433,18590,11419,11420,15420,12207
7460|Patriarche Chardon de glace|Ice Thistle Patriarch|57|58|0|618:68,46;70,42;71,38;70,40;71,41;71,39;65,41|12367,12435
7437|Tisse-magie cobalt|Cobalt Mageweaver|57|58|1|618:60,49;57,53;59,51;60,53;58,50;58,49;55,52;54,51|13497,14493,16054,18704
7438|Ursa Tombe-hiver|Winterfall Ursa|57|58|0|618:65,38;68,39;65,37;67,40;66,38;67,37;68,37;69,38|15779,9187,9030,12771,12431,20742,21383,12820
11698|Aiguillonneur de la Ruche'Ashi|Hive'Ashi Stinger|57|58|1|1377:42,30;47,46;44,18;48,26;49,48;50,41;52,41;56,50|20457,20461,20384,20499
11737|Ecorcheur Cinglepierre|Stonelash Flayer|57|58|0|1377:26,82;20,77;27,77;34,74;23,84;39,87;45,91;68,76|20375,22649,22381,19933,19934,4872,4867,19441
14455|Envahisseur tourbillonnant|Whirling Invader|57|58|0|1377:28,27;28,26|20378,7082,7081,7069
11724|Grouillante de la Ruche'Ashi|Hive'Ashi Swarmer|57|58|1|1377:48,47;45,14;52,53;53,52;44,23;51,27;42,28;55,45|20457,20461,20384,20499
11721|Ouvrière de la Ruche'Ashi|Hive'Ashi Worker|57|58|1|1377:40,15;49,24;43,18;46,13;44,30;44,17;47,27;42,12|20457,20461,20384,20499
10374|Araignée du pic|Spire Spider|57|58|1|1583:|140,12586,13260,12205,14227,19441
9268|Berserker Smolderthorn|Smolderthorn Berserker|57|58|1|1583:|16736,12562,16717,13260
9216|Chef de guerre Pierre-du-pic|Spirestone Warlord|57|58|1|1583:|12562,21982,13260
9716|Combattant Bloodaxe|Bloodaxe Warmonger|57|58|1|1583:|16735,16713,13260,22138
9692|Ecumeur Bloodaxe|Bloodaxe Raider|57|58|1|1583:|16680,16716,16717,13260,22138
9717|Invocateur Bloodaxe|Bloodaxe Summoner|57|58|1|1583:|16696,16703,22138
9260|Légionnaire de Brandefeu|Firebrand Legionnaire|57|58|1|1583:|15775,16680,16735,16713,22138
9197|Mage de bataille Pierre-du-pic|Spirestone Battle Mage|57|58|1|1583:|12562,5140,21982,13260
9264|Pyromancien de Brandefeu|Firebrand Pyromancer|57|58|1|1583:|14513,13494,16683,16673,16717,22138
9263|Tisseur d’effroi de Brandefeu|Firebrand Dreadweaver|57|58|1|1583:|16696,16703,22138
10463|Banshee hurlante|Shrieking Banshee|57|58|1|2017:|16714,12830,17061,13174,18741,18742,18743,18744,18745
10419|Conjurateur cramoisi|Crimson Conjuror|57|58|1|2017:|16697,16702,10592,16685,18631,12811,17061,7191,18741,18742,18743,14227,18744,18745
10418|Gardien cramoisi|Crimson Guardsman|57|58|1|2017:|16723,12811,17061,18741,18742,18743,18744,18745
10408|Gargouille Aile-de-roc|Rockwing Gargoyle|57|58|1|2017:|16722,16723,12830,18741,18742,18743,18744,18745
10405|Goule pestilentielle|Plague Ghoul|57|58|1|2017:|16710,17061,13174,18741,18742,18743,18744,18745
10414|Horreur régénérée|Patchwork Horror|57|58|1|2017:|12735,16736,17061,13174,18741,18742,18743,18744,18745
10420|Initié cramoisi|Crimson Initiate|57|58|1|2017:|16697,12811,17061,18741,18742,18743,18744,18745
10485|Aberration ressuscitée|Risen Aberration|57|58|0|2057:|22526
10471|Acolyte Scholomance|Scholomance Acolyte|57|58|1|2057:|14536,18699,18697,18702,18700,18701,18698
10476|Nécrolyte Scholomance|Scholomance Necrolyte|57|58|1|2057:|14536,18699,18697,18702,18700,18701,18698
10470|Néophyte de la Scholomance|Scholomance Neophyte|57|58|1|2057:|14536,18699,18697,18702,18700,18701,18698
11476|Bien-né squelette|Skeletal Highborne|57|58|0|2557:|22526
11465|Ecraseur Crochebois|Warpwood Stomper|57|58|1|2557:|20066,18289,22529,18297,12803
11472|Esprit Eldreth|Eldreth Spirit|57|58|1|2557:|18340,21211,21314,22224,18334
11471|Fantôme Eldreth|Eldreth Apparition|57|58|1|2557:|18340,22224,18334
13285|Fouet-mortel|Death Lash|57|58|1|2557:|18222,18223,18224,18365,5263,22529,18255,18297,12803
11461|Gardien Crochebois|Warpwood Guardian|57|58|1|2557:|18289,22529,18255,18297,12803
8562|Cannibale Mossflayer|Mossflayer Cannibal|57|59|0|139:57,19;58,18;65,11;64,10;61,10;62,12;56,17;62,8|
8542|Chante-mort|Death Singer|57|59|0|139:61,24;64,24;63,24;63,23;68,42;32,46;68,43;74,36|21935
8532|Ecorcheur maladif|Diseased Flayer|57|59|0|139:34,41;57,33;57,31;32,44;32,48;72,34;32,47|
7456|Hurleur du Berceau-de-l'Hiver|Winterspring Screecher|57|59|0|618:60,64;58,27;58,21;61,56;58,25;62,62;60,61;61,61|11419,11420,15420,12207,11417
7449|Ravageur Noroît|Chillwind Ravager|57|59|0|618:60,22;56,21;57,26;60,17;55,20;58,23;60,23;55,23|20697,20532,12434,12444,12623,20679,10309
11745|Guerrier cyclone|Cyclone Warrior|57|59|0|1377:32,83;46,63;36,60;47,59;43,79|7082,7081,7069
11727|Guêpe de la Ruche'Zora|Hive'Zora Wasp|57|59|0|1377:25,48;27,47;28,61;36,62;22,51;31,61;27,69;34,68|20458,20461,20384,20499
11739|Traqueuse des rochers|Rock Stalker|57|59|0|1377:34,77;34,76;23,77;36,86;37,90;65,86;50,70;47,86|20377,22381,7081,12205,14227,7077,19441
11880|Vengeur du crépuscule|Twilight Avenger|57|59|0|1377:68,18;40,45;18,82;20,83;25,31;26,37;39,46;42,44|20545,20406,20407,20408,20404
10489|Garde ressuscité|Risen Guard|57|59|1|2057:|22388,24281,24231,5140,14536,18699,18697,18702,18700,18701,18698,22526
10678|Jeune pestiféré|Plagued Hatchling|57|59|0|2057:|13920,22388,4557
14303|Gardien pétrifié|Petrified Guardian|57|59|1|2557:|18344,5263,22529,12803,18334
13036|Mastiff Gordok|Gordok Mastiff|57|59|0|2557:|18236,18237,18475,18477,18479,18528,18530,18533,18266,18365,5263,18255,18297
11459|Protecteur Ecorcefer|Ironbark Protector|57|59|1|2557:|21235,18344,22529,12803,18334
11483|Restes de mana|Mana Remnant|57|59|1|2557:|18285,18286,18338,18365,5263,18334
11458|Tréant pétrifié|Petrified Treant|57|59|1|2557:|18746,18792,18344,18365,5263,22529,12803,18334
7461|Initiée Hederine|Hederine Initiate|57|60|1|618:55,84;61,84;56,80;64,79;60,77;60,84;53,84;60,83|21105,18604,18665
7463|Pourfendeur Hederine|Hederine Slayer|57|60|1|618:58,80;56,79;57,87;65,80;59,75;60,78;62,84;61,78|21105,18604,18665
7666|Archimage Allistarj|Archmage Allistarj|58|58|1|4:67,29|10755
7665|Grol le Destructeur|Grol the Destroyer|58|58|1|4:43,13|10753
14464|Avalanchion||58|58|1|16:80,25|18673,19268,7076,7075,4784
1844|Contremaître Marcrid|Foreman Marcrid|58|58|4|28:49,33|
1850|Putridius||58|58|2|28:48,67|13356,12843
12263|Protecteur de la Boucherie|Slaughterhouse Protector|58|58|1|139:32,14;27,24|
12262|Protecteur de la ziggourat|Ziggurat Protector|58|58|1|139:20,16;35,31;23,29;38,20;25,18;28,18|15447
10822|Seigneur de guerre Thresh'jin|Warlord Thresh'jin|58|58|4|139:63,9|
14461|Baron Charr||58|58|1|490:44,48|18671,18672,11829,19268,4787,7078,7077
10807|Brumeran||58|58|1|618:63,58|
10663|Griffemana|Manaclaw|58|58|1|618:53,54|18704,4557
14477|Grubthor||58|58|4|1377:44,81|
12199|Ombre d'Ambermoon|Shade of Ambermoon|58|58|0|1377:63,50|
14478|Ouraganien|Huricanian|58|58|4|1377:22,24|7082,7081,7069
9236|Chasseresse des ombres Vosh'gajin|Shadow Hunter Vosh'gajin|58|58|1|1583:|12626,12651,12653,12654,13255,13257,13352,16712
9237|Maître de guerre Voone|War Master Voone|58|58|1|1583:|12335,12582,13173,13177,13179,16676,22231,21524
10177|Scarabée du pic|Spire Scarab|58|58|0|1583:|
9701|Scorpide du pic|Spire Scorpid|58|58|0|1583:|19933,19934,4872,4867,19441
9218|Seigneur de guerre Pierre-du-pic|Spirestone Battle Lord|58|58|2|1583:|13284,13285,21982
9217|Seigneur magus Pierre-du-pic|Spirestone Lord Magus|58|58|2|1583:|13261,13282,13283,21982
10393|Krân|Skul|58|58|2|2017:|13394,13395,13396,12843,22526
10435|Magistrat Barthilas|Magistrate Barthilas|58|58|1|2017:|12382,13376,18722,18725,18726,18727,23198,13174,12843
11492|Alzzin le Modeleur|Alzzin the Wildshaper|58|58|1|2557:|18309,18310,18312,18314,18315,18318,18321,18326,18327,18328
13317|Mineur de Froidemine|Coldmine Miner|58|58|0|2597:43,72;43,71;44,73;45,72;47,71;46,71;46,70;42,69|
11657|Morloch||58|58|0|2597:52,8|
11677|Sous-chef Snivvle|Taskmaster Snivvle|58|58|0|2597:44,68|16885,24281
1046|Wyrmide rouge|Red Wyrmkin|58|59|1|11:79,44;78,46;82,49|
8561|Chasseur des ténèbres Mossflayer|Mossflayer Shadowhunter|58|59|0|139:63,8;64,10;63,13;64,7;64,9;62,10;61,14;61,9|16056
8544|Golem dégingandé|Gangled Golem|58|59|0|139:77,32|
8558|Pourfendeur des cryptes|Crypt Slayer|58|59|0|139:32,41;10,25;36,39;34,43;33,45;58,30;75,36;73,31|22525,19441
8528|Tisseur d'effroi|Dread Weaver|58|59|0|139:75,35;66,42;76,36;74,37;69,46;70,37;69,37|22526
7075|Mage frémissant|Writhing Mage|58|59|1|267:15,77;17,81;16,82;16,85;14,84;15,82;13,81|22229,3692
7069|Moine condamné|Condemned Monk|58|59|1|267:14,83;13,80;16,78;16,77|3692
7433|Chasseresse sabre-de-givre|Frostsaber Huntress|58|59|0|618:49,12;51,14;50,17;49,7;52,12;52,10;51,8;49,14|12430,12733,21928,4581,4580,1688,12202
7454|Chouettard berserk|Berserk Owlbeast|58|59|0|618:64,19;65,64;67,26;66,19;65,23;67,22;65,21;63,24|12524,12558,12433,18590,11419,11420,15420,12207
11722|Défenseur de la Ruche'Ashi|Hive'Ashi Defender|58|59|1|1377:50,27;47,16;42,28;44,13;46,26;41,27;39,12;41,14|20457,20461,20384,20499
11747|Enragé du désert|Desert Rager|58|59|0|1377:39,68;48,90;24,90|7076,7075,4784
15542|Maraudeur du crépuscule|Twilight Marauder|58|59|0|1377:57,17;57,18|20406,20407,20408,20404
11725|Patrouilleuse de la Ruche'Zora|Hive'Zora Waywatcher|58|59|1|1377:22,49;35,65;24,62;27,60;34,64;22,61;26,61;23,72|20458,20461,20384,20499
11723|Traqueuse des sables de la Ruche'Ashi|Hive'Ashi Sandstalker|58|59|1|1377:42,22;50,24;40,15;46,32;43,20;48,24;51,26;44,14|22650,20457,20461,20384,20499
11726|Tunnelière de la Ruche'Zora|Hive'Zora Tunneler|58|59|1|1377:33,64;37,64;19,67;23,73;22,71;27,69;23,59;26,62|12698,20458,20461,20384,20499
9096|Draconide de la Griffe enragée|Rage Talon Dragonspawn|58|59|1|1583:|16681,13371,15994,18631,16717,16786,7191,15416,13260,14227
9693|Evocateur Bloodaxe|Bloodaxe Evoker|58|59|1|1583:|16683,16673,22138
10083|Flammécaille de la Griffe enragée|Rage Talon Flamescale|58|59|1|1583:|13371,16673,16786,15416,13260
9583|Vétéran Bloodaxe|Bloodaxe Veteran|58|59|1|1583:|12562,13260,22138
10464|Banshee gémissante|Wailing Banshee|58|59|1|2017:|16714,12830,18736,18741,18742,18743,18744,18745
10421|Défenseur cramoisi|Crimson Defender|58|59|1|2017:|16681,12827,12811,18741,18742,18744,18745
10422|Ensorceleur cramoisi|Crimson Sorcerer|58|59|1|2017:|16249,16702,12827,16685,12811,18742,18743,18744,18745
10398|Exhalombre Thuzadin|Thuzadin Shadowcaster|58|59|1|2017:|16248,16697,16702,15994,16685,18631,12830,18736,17061,7191,18741,18742,18743,18744,18745
10406|Goule vorace|Ghoul Ravener|58|59|1|2017:|15768,16681,12830,18736,13174,18741,18742,18743,18744,18745
10409|Hurleuse Aile-de-roc|Rockwing Screecher|58|59|1|2017:|16722,16723,12830,18736,17061,18741,18742,18743,18744,18745
10423|Prêtre cramoisi|Crimson Priest|58|59|1|2017:|16697,12827,12811,18736,18742,18743,18745
10412|Rampant des cryptes|Crypt Crawler|58|59|1|2017:|16671,22525,12830,18736,17061,13174,18741,18742,18743,18744,18745,19441
10469|Adepte Scholomance|Scholomance Adept|58|59|1|2057:|16255,16684,9179,9224,16685,14536,18699,18697,18702,18700,18701,18698
10481|Cadavre réanimé|Reanimated Corpse|58|59|0|2057:|18701
10480|Corps instable|Unstable Corpse|58|59|0|2057:|
10491|Gardien d'os ressuscité|Risen Bonewarder|58|59|1|2057:|12753,14536,18699,18697,18702,18700,18701,18698,22526
10495|Goule infectée|Diseased Ghoul|58|59|1|2057:|16714,14536,18699,18697,18702,18700,18701,18698
11582|Invocateur des ténèbres de Scholomance|Scholomance Dark Summoner|58|59|1|2057:|15776,20520,14536,18699,18697,18702,18700,18701,18698
10477|Nécromancien Scholomance|Scholomance Necromancer|58|59|1|2057:|16705,16702,20520,14536,18699,18697,18702,18700,18701,18698
10472|Occultiste Scholomance|Scholomance Occultist|58|59|1|2057:|16710
11477|Bien-né pourrissant|Rotting Highborne|58|59|0|2557:|22526
11475|Fantasme Eldreth|Eldreth Phantasm|58|59|1|2557:|18340,22224,18334
14398|Fléchetteuse Eldreth|Eldreth Darter|58|59|1|2557:|4402,4557
11469|Rongé Eldreth|Eldreth Seether|58|59|1|2557:|18334
11473|Spectre Eldreth|Eldreth Spectre|58|59|1|2557:|18340,22224,18334
11840|Alpha Follepatte|Wildpaw Alpha|58|59|0|2597:52,95;53,94;52,91|
7370|Ame errante|Restless Shade|58|60|0|41:46,71;57,81;56,80;41,75;45,79;51,80;54,78;55,78|11751,11752,11753,24231,2928
12377|Spectre gémissant|Wailing Spectre|58|60|0|41:46,72;57,79;55,74;41,70;47,74;54,80;55,81;53,79|
16043|Seigneur-magma Bokk|Magma Lord Bokk|58|60|0|46:35,58|21938
7462|Traque-mana Hederine|Hederine Manastalker|58|60|1|618:57,88;58,88;56,85;53,85;53,90;61,83;52,89;55,79|18604
11881|Géoseigneur du crépuscule|Twilight Geolord|58|60|0|1377:25,38;37,43;18,85;21,86;24,34;28,34;27,33;39,46|20546,20678,20541,20679,20406,20407,20408,20404,7079
11043|Moine cramoisi|Crimson Monk|58|60|1|2017:|16671,12811,18736,17061,18741,18742,18743,18744,18745
10499|Chercheur spectral|Spectral Researcher|58|60|1|2057:|15773,16254,16716,22388,18699,18697,18702,18700,18701,18698
10498|Educateur spectral|Spectral Tutor|58|60|1|2057:|14536,18699,18697,18702,18700,18701,18698
11551|Nécrofiel|Necrofiend|58|60|1|2057:|22525,14536,18699,18697,18702,18700,18701,18698,14557,19441
10487|Protecteur ressuscité|Risen Protector|58|60|1|2057:|16722,5173,14536,18699,18697,18702,18700,18701,18698,22526
10488|Assemblage ressuscité|Risen Construct|58|61|1|2057:|18746,18792,12753,16710,14558,14536,18699,18697,18702,18700,18701,12728,18698,14557,22526
10500|Professeur spectral|Spectral Teacher|58|61|1|2057:|16716,14558,14536,18697,18702,18700,18701,18698
7667|Dame Sevine|Lady Sevine|59|59|1|4:41,30|10754
1885|Forgeron écarlate|Scarlet Smith|59|59|4|28:44,14|12719
1845|Haut Protecteur Tarsen|High Protector Tarsen|59|59|0|28:49,34|
8979|Gruklash||59|59|4|46:42,55;44,56;40,36;41,35;41,33;15,30;41,54|
8546|Adepte noir|Dark Adept|59|59|0|139:32,41;74,32;35,42;36,41;58,30;34,40;74,34;73,31|13499
10828|Grand général Abbendis|High General Abbendis|59|59|2|139:78,74|
10823|Zul'Brin Warpbranch||59|59|4|139:63,11|
10202|Azurous||59|59|2|618:67,54|4557
10738|Grand chef Tombe-hiver|High Chief Winterfall|59|59|1|618:70,38|12842,12431,20742,21383,12820
10199|Grison Neigepatte|Grizzle Snowpaw|59|59|4|618:67,36|12820
15196|Poigne-de-mort|Deathclasp|59|59|1|1377:45,92|20385
14474|Zora||59|59|2|1377:21,61|20499
9596|Bannok Grimaxe||59|59|2|1583:|12621,12634,12637,12838,22138
9718|Ghok Bashguud||59|59|2|1583:|13198,13203,13204,22138
9196|Généralissime Omokk|Highlord Omokk|59|59|1|1583:|12336,12534,13166,13167,13168,13169,13170,16670,21982
10220|Halycon||59|59|1|1583:|13210,13211,13212,22313
9736|Intendant Zigris|Quartermaster Zigris|59|59|2|1583:|12835,13252,13253,22138
10509|Jed Runewatcher||59|59|2|1583:|12604,12605,12930,22138
10596|Matriarche Couveuse|Mother Smolderweb|59|59|1|1583:|13183,13213,13244,16715,12205,14227
9019|Empereur Dagran Thaurissan|Emperor Dagran Thaurissan|59|59|1|1585:|11684,11815,11924,11928,11930,11931,11932,11933,11934,12033,22204,22207,21524,11078,11468
10436|Baronne Anastari|Baroness Anastari|59|59|1|2017:|13514,13534,13535,13537,13538,13539,16704,18728,18729,18730,13174,12843
11467|Tsu'zee||59|59|1|2557:|18345,18346,18387
13525|Commando aguerri|Seasoned Commando|59|59|1|2597:50,81|
603|Mâchinistre|Grimtooth|59|59|0|2597:52,95|
1047|Plaiedécaille rouge|Red Scalebane|59|60|1|11:86,50;85,52;86,51;82,47;81,48;85,51;84,50;83,48|
4364|Guerrier Strashaz|Strashaz Warrior|59|60|1|15:75,15;75,22;77,18;77,20|12714,22094,8959
4371|Sirène Strashaz|Strashaz Siren|59|60|1|15:74,18;77,19;75,22;73,19;76,17;77,20|22094,8959
12378|Ame damnée|Damned Soul|59|60|0|41:43,70;56,82;55,77;42,76;43,73;51,78;52,80;55,73|
12379|Fossoyeur non-vivant|Unliving Caretaker|59|60|0|41:55,76;56,77;53,81;44,76;45,74;43,74;50,78;54,78|
12380|Résident non vivant|Unliving Resident|59|60|0|41:45,77;45,79;41,78;41,79;50,78;43,74;47,79;49,75|
8545|Abomination||59|60|0|139:32,43;30,54;29,56;76,31;76,32;76,33;30,49|
8529|Champion du Fléau|Scourge Champion|59|60|0|139:35,40;29,55;67,43;67,40;75,33;29,51;70,36;72,33|13157,22526
8550|Ombremage|Shadowmage|59|60|0|139:32,41;74,32;35,42;36,41;58,30;34,40;74,34;73,31|13499
7070|Clerc condamné|Condemned Cleric|59|60|1|267:16,81;17,80;13,83|
7446|Croc acéré enragé|Rabid Shardtooth|59|60|0|618:58,71;57,69;58,72;57,70;59,71;56,71;61,73|21037,21039,21040,12432,12622,21928,11408,11409,11410
7434|Guetteur sabre-de-givre|Frostsaber Pride Watcher|59|60|0|618:48,10;51,9;52,9;51,7;49,12|12430,12733,21928,4581,4580,1688,12202
7428|Géant Cognegivre|Frostmaul Giant|59|60|1|618:66,69;64,72;58,67;59,69;60,70;63,70;61,67;63,69|13495,12436,22227,12334
7429|Protecteur Cognegivre|Frostmaul Preserver|59|60|1|618:64,72;64,67;58,67;62,73;60,65;61,68;60,68;62,68|12436,22227,12334
7432|Traqueur sabre-de-givre|Frostsaber Stalker|59|60|0|618:57,17;49,16;53,16;54,17;50,18;54,11;56,14|12430,12733,21928,4581,9262,4580,1688,12202
11732|Crache-feu de la Ruche'Regal|Hive'Regal Spitfire|59|60|1|1377:52,80;56,75;51,83;60,88;58,89;61,75;66,77;64,74|20459,22226,20461,20384,20499
11730|Embusquée de la Ruche'Regal|Hive'Regal Ambusher|59|60|1|1377:49,80;58,87;62,80;61,72;61,83;66,83;65,77;63,100|20459,22226,20461,20384,20499
11733|Esclavagiste de la Ruche'Regal|Hive'Regal Slavemaker|59|60|1|1377:51,94;57,83;61,90;56,79;59,77;65,82;52,99;63,77|20459,22226,20461,20384,20499
11731|Fouisseuse de la Ruche'Regal|Hive'Regal Burrower|59|60|1|1377:65,71;52,81;55,71;65,75;61,79;64,81;54,95;54,85|20459,22226,4425,20461,20384,20499
11882|Invocateur des pierres du crépuscule|Twilight Stonecaller|59|60|0|1377:39,45;39,44;27,34;27,32;27,33;18,84;19,84|20406,20407,20408,20404
11883|Maître du crépuscule|Twilight Master|59|60|0|1377:69,17;68,20;66,18;20,85;19,82;18,82;66,22|20406,20407,20408,20404
11728|Ravageuse de la Ruche'Zora|Hive'Zora Reaver|59|60|1|1377:35,62;25,48;25,56;25,61;23,69;25,64;26,58;20,70|20458,22388,20461,20384,20499
11729|Sœur de la Ruche'Zora|Hive'Zora Hive Sister|59|60|1|1377:24,52;25,73;30,55;22,47;32,57;24,72;29,67;27,66|22649,20458,20461,20384,20499
10814|Garde d'élite chromatique|Chromatic Elite Guard|59|60|1|1583:|12607,15416,13260
10316|Geôlier Blackhand|Blackhand Incarcerator|59|60|0|1583:|22138
9818|Invocateur Blackhand|Blackhand Summoner|59|60|1|1583:|16696,13260,22138
9817|Tisseur d’effroi Blackhand|Blackhand Dreadweaver|59|60|1|1583:|13371,16703,14557,13260,22138
9819|Vétéran Blackhand|Blackhand Veteran|59|60|1|1583:|13371,13260,22138
10399|Acolyte Thuzadin|Thuzadin Acolyte|59|60|0|2017:|12830,18736,17061,18741,18742,18743,18744,18745
10413|Bête des cryptes|Crypt Beast|59|60|1|2017:|16671,22525,12830,18736,17061,13174,18741,18742,18743,18744,18745,19441
10416|Cracheur de bile|Bile Spewer|59|60|1|2017:|12735,16736,16716,18736,13174,18741,18742,18743,18744,18745
10407|Goule écorcheuse|Fleshflayer Ghoul|59|60|1|2017:|16681,12830,18736,17061,13174,14557,18741,18742,18743,18744,18745
10426|Inquisiteur cramoisi|Crimson Inquisitor|59|60|1|2017:|16052,18658,16714,12811,18736,18741,18742,18743,18744,18745
10425|Mage de bataille cramoisi|Crimson Battle Mage|59|60|1|2017:|15777,16685,12811,18736,18741,18742,18743,18744
10424|Vaillant cramoisi|Crimson Gallant|59|60|1|2017:|16723,12827,12811,18736,17061,18741,18742,18743,18744,18745
11257|Eleveur de Scholomance|Scholomance Handler|59|60|1|2057:|16716,14536,18699,18697,18702,18700,18701,18698
10478|Squelette brisé|Splintered Skeleton|59|60|1|2057:|1382,16671,5140,14536,18699,18697,18702,18700,18701,18698,22526,2928
11480|Aberration des arcanes|Arcane Aberration|59|60|1|2557:|18285,18286,18338,18365,5263,18334
11484|Monstruosité résiduelle|Residual Monstrosity|59|60|1|2557:|18285,18286,18338,18365,5263,18334
14400|Réaction arcanique|Arcane Feedback|59|60|0|2557:|18285,18286
14399|Torrent arcanique|Arcane Torrent|59|60|1|2557:|18285,18286,18338,18334
4366|Garde-serpent Strashaz|Strashaz Serpent Guard|59|61|1|15:76,22;76,19;75,14;74,17;75,18|12706,22094,8959
4374|Hydre Strashaz|Strashaz Hydra|59|61|1|15:69,19;69,20;70,19;70,21;70,17;70,23;72,19;74,18|5569,3010,8959
11734|Seigneur de la Ruche'Regal|Hive'Regal Hive Lord|59|61|1|1377:66,74;58,82;57,80;51,98;65,73;61,91;66,81;64,99|20459,22226,14510,16253,20461,20384,20499
15213|Suzerain du crépuscule|Twilight Overlord|59|61|0|1377:71,13;71,12;68,18;74,12;65,16;66,15;66,22;67,22|20406,20407,20408,20404
10400|Nécromancien Thuzadin|Thuzadin Necromancer|59|61|1|2017:|16697,16702,16685,12717,12830,14509,18736,12720,14558,17061,14557,18741,18742,18743,18744,18745
10486|Guerrier ressuscité|Risen Warrior|59|61|1|2057:|16722,14536,18699,18697,18702,18700,18701,12728,18698,14557,22526
8718|Molosse de mana|Manahound|60|60|1|4:40,65;40,72;43,75;42,63;40,71;38,56;59,57;59,59|18665
7846|Teremus le Dévoreur|Teremus the Devourer|60|60|3|4:51,50|4557
1841|Bourreau écarlate|Scarlet Executioner|60|60|2|28:46,19|
11873|Domestique spectral|Spectral Attendant|60|60|0|28:46,69|13354
1837|Juge écarlate|Scarlet Judge|60|60|4|28:42,18|
8976|Hematos||60|60|2|46:22,60|4557
10119|Volchan||60|60|2|46:74,38|12828,4787,7076,7078,7075,7077
12479|Gardien sylvestre de Verdantis|Verdantine Tree Warder|60|60|1|47:65,25;70,15;66,28;61,31;60,25;60,26;63,31;59,18|21146
11897|Crépuscaile|Duskwing|60|60|1|139:26,59|15850,11395,11402,11403,11404
12248|Infiltrateur Hameya|Infiltrator Hameya|60|60|0|139:62,11|15767
12337|Messager cramoisi|Crimson Courier|60|60|1|139:51,31|15868,12811
16117|Pourceau pestiféré|Plagued Swine|60|60|0|139:15,27;12,27;14,27;11,27;15,26;12,25;13,24|3403,2295
16184|Surveillant nérubien|Nerubian Overseer|60|60|1|139:6,31|22525
12475|Gardien sylvestre Emeraldon|Emeraldon Tree Warder|60|60|1|331:89,40;93,37;90,39;93,39|21147
5319|Gardien sylvestre Jademir|Jademir Tree Warder|60|60|1|357:54,10;52,8;50,7;54,17;50,16;51,18;54,7;49,16|21148
6584|Roi Mosh|King Mosh|60|60|2|490:35,36|20016,20015,4588,4587
10664|Clairvoyant|Scryer|60|60|1|618:53,56|16869,18704,4557
10198|Kashoch le ravageur|Kashoch the Reaver|60|60|2|618:63,70|12334
14457|Princesse Tempestria|Princess Tempestria|60|60|1|618:55,42|18678,21548,19268,7080,7079,7070
15201|Flamme ravageuse du crépuscule|Twilight Flamereaver|60|60|0|1377:71,13;72,14;73,14;73,13;74,12;70,14;72,13|20406,20407,20408,20404,7070
11803|Gardien du crépuscule Exeter|Twilight Keeper Exeter|60|60|0|1377:16,86|20395,20518,20531,20679
11804|Gardien du crépuscule Havunth|Twilight Keeper Havunth|60|60|0|1377:41,42|20396,20404,7081
15200|Gardienne du crépuscule Mayna|Twilight Keeper Mayna|60|60|0|1377:26,37|20394,2928
14473|Lapress||60|60|2|1377:58,79;63,92|20499
14454|Le Déchirevent|The Windreaver|60|60|1|1377:29,27|18676,18677,21548,19268,7082,7081,7069
15541|Maraudeuse du crépuscule Morna|Twilight Marauder Morna|60|60|1|1377:58,18|20406,20407,20408,20404
15308|Prophète du crépuscule|Twilight Prophet|60|60|1|1377:23,69;18,31|20803,20404
14479|Seigneur du crépuscule Everun|Twilight Lord Everun|60|60|4|1377:18,86;27,33;38,46|14048,20451,4339,20406,20407,20408,20404
10376|Croc cristallin|Crystal Fang|60|60|2|1583:|13184,13185,13218,12205,14227
10762|Nervi Blackhand|Blackhand Thug|60|60|1|1583:|13260
9816|Pyrogarde Prophète ardent|Pyroguard Emberseer|60|60|3|1583:|12905,12926,12927,12929,16672,17322,21988,23320,4787
9568|Seigneur Wyrmthalak|Overlord Wyrmthalak|60|60|1|1583:|12337,12780,13143,13161,13162,13163,16679,22321,16786
11353|Buveur de sang Gurubashi|Gurubashi Blood Drinker|60|60|1|1977:|19817,20259,19921,20258,20261,20263,19908,19813,19816,19818,19819,19774,19814,19821,19820,19727,14557,19726,19698,19699
11351|Chasseur de têtes Gurubashi|Gurubashi Headhunter|60|60|1|1977:|20259,19921,20261,20263,19908,19813,19816,19818,19774,19814,19821,19820,19727,19726,19698,19699,19700,19702,19703,19704
11368|Chauve-souris sanguinaire|Bloodseeker Bat|60|60|0|1977:|11403,11404,19813,19819,19774,19814,19821,19820,19727,19726
11373|Cobra Razzashi|Razzashi Cobra|60|60|1|1977:|4304
11374|Crochedents frénétique|Hooktooth Frenzy|60|60|1|1977:|19221,19815
15043|Crocilisque zulien|Zulian Crocolisk|60|60|1|1977:|19975,19221,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714,19715,19701
14883|Esclave vaudou|Voodoo Slave|60|60|1|1977:|19817,19816,19818,19819,19774,19814,19821,19820,19727,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708
11357|Fils d'Hakkar|Son of Hakkar|60|60|1|1977:|21037,21039,21040,19821,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714
14532|Fils du venin Razzashi|Razzashi Venombrood|60|60|1|1977:|19813,19816,19819,19814,19820,19727,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711
11360|Jeune zulien|Zulian Cub|60|60|0|1977:|19817,4581,19813,19816,19818,19819,4580,19774,19814,19821,19820,19727,19726
11350|Lanceur de haches Gurubashi|Gurubashi Axe Thrower|60|60|1|1977:|19221,19817,20259,19921,20258,20261,20263,19908,19813,19816,19818,19819,19774,19814,19821,19820,19727,14557,19726,19698
14882|Maîtresse atal'ai|Atal'ai Mistress|60|60|1|1977:|20259,19921,20258,20261,20263,19908,19816,19818,19819,19774,19814,19821,19820,19727,19726,19698,19699,19700,19702,19703
14825|Maîtresse desséchée|Withered Mistress|60|60|1|1977:|20259,19921,20258,20261,20263,19908,19813,19816,19819,19774,19814,19821,19820,19727,19726,19698,19699,19700,19702,19703
11365|Panthère zulienne|Zulian Panther|60|60|1|1977:|19221,4581,19819,4580,19727,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713
11830|Prêtre Hakkari|Hakkari Priest|60|60|1|1977:|20259,19921,20258,20261,20263,19908,19819,19821,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709
14821|Raptor Razzashi|Razzashi Raptor|60|60|1|1977:|20016,19817,20015,4588,19813,19816,19818,19774,19814,19820,19727,14557,19726,19698,19699,19700,19702,19703,19704,19705
11371|Serpent Razzashi|Razzashi Serpent|60|60|1|1977:|19221,19818,14557,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714
11831|Sorcier-docteur Hakkari|Hakkari Witch Doctor|60|60|1|1977:|19817,20259,19921,20258,20261,20263,19908,19813,19816,19774,19814,19821,19820,19727,19726,19698,19699,19700,19702,19703
11361|Tigre zulien|Zulian Tiger|60|60|1|1977:|19221,19817,4581,19813,19816,19818,19819,4580,19774,19814,19821,19820,19727,14557,19726,19698,19699,19700,19702,19703
14826|Troll sacrifié|Sacrificed Troll|60|60|0|1977:|19815
11372|Vipère Razzashi|Razzashi Adder|60|60|1|1977:|19221,19774,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714,19715
10811|Archiviste Galford|Archivist Galford|60|60|1|2017:|13385,13386,13387,16692,18716,22897,22206,12811
14684|Balzaphon||60|60|1|2017:|23124,23125,23126,22890,18742,12843
10809|Echine-de-pierre|Stonespine|60|60|2|2017:|13397,13399,13954,12843
11032|Malor le Zélé|Malor the Zealous|60|60|1|2017:|18742,18745
10997|Maître canonnier Willey|Cannon Master Willey|60|60|1|2017:|12839,13377,13380,13381,13382,16708,18721,22403,22404,22405,22406,22407,21524
10437|Nerub'enkan||60|60|1|2017:|13508,13529,13530,13531,13532,13533,16675,18738,18739,18740,22525,13174,12843
10502|Dame Illucia Barov|Lady Illucia Barov|60|60|1|2057:|12753,20520,12843
10901|Gardien du savoir Polkelt|Lorekeeper Polkelt|60|60|1|2057:|16705,22206,12753,20520
10507|Le Voracien|The Ravenian|60|60|1|2057:|12753,20520,16716,12843
10504|Seigneur Alexei Barov|Lord Alexei Barov|60|60|1|2057:|16722,12843
14695|Seigneur Noirbois|Lord Blackwood|60|60|1|2057:|23132,23139,23156,22890,18698,22526
11446|Esprit Gordok|Gordok Spirit|60|60|1|2557:|
14308|Ferra||60|60|1|2557:|11414,11415
11488|Illyanna Ravenoak||60|60|1|2557:|18347,18349,18383,18386,22206,18334
11487|Magistère Kalendris|Magister Kalendris|60|60|1|2557:|18350,18351,18371,18374,18397,22309,18334
14690|Revanchion||60|60|1|2557:|23127,23128,23129,18338,22224,12843
11489|Tendris Crochebois|Tendris Warpwood|60|60|1|2557:|18352,18353,18390,18393,22529,18334
14386|Œil errant de Kilrogg|Wandering Eye of Kilrogg|60|60|0|2557:|
13551|Envahisseur de Froidemine champion|Champion Coldmine Invader|60|60|0|2597:50,74|
13548|Explorateur de Froidemine champion|Champion Coldmine Explorer|60|60|0|2597:51,75|
13554|Garde de Gouffrefer champion|Champion Irondeep Guard|60|60|0|2597:53,7|
14024|Dragonnet bleu corrompu|Corrupted Blue Whelp|60|60|0|2677:|
14025|Dragonnet bronze corrompu|Corrupted Bronze Whelp|60|60|0|2677:|
14022|Dragonnet rouge corrompu|Corrupted Red Whelp|60|60|0|2677:|
14023|Dragonnet vert corrompu|Corrupted Green Whelp|60|60|0|2677:|
14401|Maître élémentaire Krixix le Sculpteur|Master Elemental Shaper Krixix|60|60|1|2677:|
13996|Technicien de l'Aile noire|Blackwing Technician|60|60|1|2677:|18562,19183,10310,10309,10308
12099|Lige du feu|Firesworn|60|60|1|2717:|
15300|Bourdon vekniss|Vekniss Drone|60|60|0|3428:|
15262|Eradicateur d'obsidienne|Obsidian Eradicator|60|60|1|3428:|22203,21223,22202,21218,21321,21323,21324,21762,21836,21837,21838,21856,21888,20874,20875,20876,20877,20878,20879,20881
15236|Guêpe vekniss|Vekniss Wasp|60|60|1|3428:|21836,21837,21838,21856,21888,21225,20874,20875,20876,20877,20878,20879,20881,20882,21230,21222,20858,20859,20860,20861
15957|Générateur d'Ouro|Ouro Spawner|60|60|0|3428:|
15316|Scarabée qiraji|Qiraji Scarab|60|60|0|3428:|
15317|Scorpion qiraji|Qiraji Scorpion|60|60|0|3428:|
15318|Bourdon de la Ruche'Zara|Hive'Zara Drone|60|60|1|3429:|21225,21803,21800,21805,21802,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860,20861,20862,20863
15319|Collecteur de la Ruche'Zara|Hive'Zara Collector|60|60|1|3429:|21225,21804,21803,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860,20861,20862
15505|Furie des canaux|Canal Frenzy|60|60|1|3429:|
15462|Scarabée cracheur|Spitting Scarab|60|60|1|3429:|22202,21804,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,19441,20858,20859,20860
15461|Scarabée hurleur|Shrieker Scarab|60|60|1|3429:|21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,19441,20858,20859,20860,20861,20862,20863,20864
16022|Assistant en chirurgie|Surgical Assistant|60|60|1|3456:|23664,23665,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16056|Asticot malade|Diseased Maggot|60|60|1|3456:|
16057|Asticot pourrissant|Rotting Maggot|60|60|1|3456:|
16218|Bobine de Tesla|Tesla Coil|60|60|0|3456:|
16036|Chauve-souris frénétique|Frenzied Bat|60|60|1|3456:|
16037|Chauve-souris pesteuse|Plagued Bat|60|60|1|3456:|
16803|Doublure de chevalier de la mort|Deathknight Understudy|60|60|1|3456:|
16024|Gelée d'embaumement|Embalming Slime|60|60|1|3456:|
17293|Plague Wave||60|60|0|3456:|
1048|Lieutenant Plaiedécaille|Scalebane Lieutenant|60|61|1|11:89,63;89,64;87,53;88,62;86,53;87,51;88,64|
4368|Myrmidon Strashaz|Strashaz Myrmidon|60|61|1|15:77,20;77,19;76,18;77,18;77,17|12718,8959
4370|Sorcière de Strashaz|Strashaz Sorceress|60|61|1|15:77,22;75,15;77,19|22094,8959
15591|Séide de Weavil|Minion of Weavil|60|61|1|15:78,17;77,17;77,19;78,18;77,18|
12800|Chimaerok||60|61|1|357:31,88;30,81;28,75;30,83;30,85;28,74;28,76|21024
6560|Garde de pierre|Stone Guardian|60|61|1|490:54,37;72,71;71,39;76,54;71,78;44,32;53,37|12809,7076,11315,11185,11184,11186,11188
10318|Assassin Blackhand|Blackhand Assassin|60|61|1|1583:|24102,16713,14511,16253,12728,13260,22138
10317|Elite Blackhand|Blackhand Elite|60|61|1|1583:|16247,12717,14509,12720,14558,12728,14557,13260,22138
10319|Garde de fer Blackhand|Blackhand Iron Guard|60|61|1|1583:|15994,16735,18631,12717,14511,14510,14509,16253,14558,7191,14557,13260,14227,22138
10366|Garde de la Griffe enragée|Rage Talon Dragon Guard|60|61|1|1583:|16680,16253,16786,12720,14558,12728,15416,13260
10372|Langue de feu de la Griffe enragée|Rage Talon Fire Tongue|60|61|1|1583:|16683,16786,14558,12728,15416,13260
10417|Crache venin|Venom Belcher|60|61|1|2017:|12735,16736,12716,16716,18736,12720,17061,13174,18741,18742,18743,18744,18745
12801|Chimaerok des arcanes|Arcane Chimaerok|60|62|1|357:31,86;30,88;31,85;29,75;28,73;29,77;30,79|21024
12129|Gardien onyxien|Onyxian Warder|60|63|1|2159:|12728
12396|Commandant de la Garde funeste|Doomguard Commander|61|61|1|4:38,69;44,75;45,73;43,74;35,64;40,67;59,55|4213,21104,18665
1852|Araj l'Invocateur|Araj the Summoner|61|61|1|28:45,69|13354,13357,13356,12720,12843
1846|Haut Protecteur Lorik|High Protector Lorik|61|61|1|28:45,18|
1838|Inquisiteur écarlate|Scarlet Interrogator|61|61|2|28:45,15|
12478|Oracle de Verdantis|Verdantine Oracle|61|61|1|47:65,25;62,16;59,31;62,28;66,28;67,18;68,31;66,23|21146,8165
11896|Creusechair|Borelgore|61|61|1|139:48,25|
15162|Inquisiteur écarlate|Scarlet Inquisitor|61|61|1|139:71,73|
12476|Oracle Emeraldon|Emeraldon Oracle|61|61|1|331:92,39;89,40;93,37;90,39;95,37;93,39;95,40|21147
5317|Oracle Jademir|Jademir Oracle|61|61|1|357:54,10;48,12;53,9;52,12;53,16;51,16;48,8;53,6|21148,8165
8197|Chronalis||61|61|1|440:64,48|16871,4557
10201|Dame Hederine|Lady Hederine|61|61|2|618:65,80|
14471|Setis||61|61|2|1377:30,87|
15202|Vyral le Vil|Vyral the Vile|61|61|0|1377:72,16|20466
10899|Goraluk Anvilcrack||61|61|1|1583:|12834,12837,13498,13502,18047,18048,18779,21525,12728,22138
11356|Champion Gurubashi|Gurubashi Champion|61|61|1|1977:|20259,19921,20258,20261,20263,19908,19774,14558,19727,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708
11339|Chasseur des ombres Hakkari|Hakkari Shadow Hunter|61|61|1|1977:|12717,20259,19921,20258,20261,20263,19908,19818,19774,14558,19820,19727,19726,19698,19699,19700,19702,19703,19704,19705
14750|Chevaucheur de sanguinaire|Gurubashi Bat Rider|61|61|1|1977:|11403,11404,14511,19817,19921,20258,20261,20263,19908,19818,19819,19774,19814,19821,19820,19727,12728,19726,19698,19699
11359|Ecorcheur d'âmes|Soulflayer|61|61|1|1977:|14509,12728,14557,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714,19715
11338|Exhalombre Hakkari|Hakkari Shadowcaster|61|61|1|1977:|19817,20258,19908,19813,19816,19818,19819,19821,19820,19727,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707
11340|Grand prêtre Hakkari|Hakkari Blood Priest|61|61|1|1977:|19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714,19715,19701,10310
11389|Porte-parole Bloodscalp|Bloodscalp Speaker|61|61|0|1977:|
11387|Porte-parole Sandfury|Sandfury Speaker|61|61|0|1977:|19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714,19715,19701,10310
11388|Porte-parole Witherbark|Witherbark Speaker|61|61|0|1977:|19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714,19715,19701,10308
15111|Serviteur fou|Mad Servant|61|61|1|1977:|22390,12720,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712,19713,19714,19715,19701
11370|Sombre-veuve Razzashi|Razzashi Broodwidow|61|61|1|1977:|22389,19816,19818,19814,19820,19726,19698,19699,19700,19702,19703,19704,19705,19706,19707,19708,19709,19710,19711,19712
15067|Traqueur zulien|Zulian Stalker|61|61|1|1977:|19221,19815
10438|Maleki le Blafard|Maleki the Pallid|61|61|1|2017:|12833,13509,13524,13525,13526,13527,13528,16691,18734,18735,18737,12843
11622|Cliquettripes|Rattlegore|61|61|1|2057:|13873,14528,14531,14537,14538,14539,16711,18686,18782,22526
10503|Jandice Barov||61|61|1|2057:|13725,14541,14543,14545,14548,16701,18689,18690,22394,13523,12843
14861|Régisseuse sanglante de Kirtonos|Blood Steward of Kirtonos|61|61|1|2057:|13523
11496|Immol'thar||61|61|1|2557:|18370,18372,18377,18379,18381,18384,18385,18389,18391,18394,18334
13421|Gardien champion|Champion Guardian|61|61|0|2597:43,16;49,15;52,36;45,46;51,60;50,77;49,88|18228,18226,18229,18230
13959|Yéti d'Alterac|Alterac Yeti|61|61|1|2597:38,38;41,37;40,33;38,36;39,35|
12459|Démoniste de l'Aile noire|Blackwing Warlock|61|61|1|2677:|19362,19434,19435,19183,14511,12728,10310,10309,10308
12468|Eveilleur Griffemort|Death Talon Hatcher|61|61|1|2677:|12716,14510,16253,16786,12720,15416,10310,10309,10308
14456|Garde de l'Aile noire|Blackwing Guardsman|61|61|1|2677:|
12465|Wyrmide Griffemort|Death Talon Wyrmkin|61|61|1|2677:|19358,19436,19437,14509,16786,10310,10309,10308
11671|Chien du Magma|Core Hound|61|61|1|2717:|
15249|Aiguillonneur courroucé qiraji|Qiraji Lasher|61|61|1|3428:|21218,21321,21323,21324,21762,21836,21837,21838,21856,21888,21224,20874,20875,20876,20877,20878,20879,20881,20882,21230
15312|Annulateur d'obsidienne|Obsidian Nullifier|61|61|1|3428:|21889,21891,21223,21218,21321,21323,21324,21762,20874,20875,20876,20877,20878,20879,20881,20882,21230,7076,20858,20859
15984|Garde royal de Sartura|Sartura's Royal Guard|61|61|1|3428:|
15233|Gardien vekniss|Vekniss Guardian|61|61|1|3428:|22390,21836,21837,21838,21856,21888,21225,20874,20875,20876,20877,20878,20879,20881,20882,21230,21222,20858,20859,20860
15247|Lave-cerveaux qiraji|Qiraji Brainwasher|61|61|1|3428:|21218,21321,21323,21324,21762,21836,21837,21838,21856,21888,21224,20874,20875,20876,20877,20878,20879,20881,20882,21230
15250|Massacreur qiraji|Qiraji Slayer|61|61|1|3428:|21218,21321,21323,21324,21762,21836,21837,21838,21856,21888,14510,21224,20874,20875,20876,20877,20878,20879,20881,20882
15230|Patrouilleur vekniss|Vekniss Warrior|61|61|1|3428:|21836,21837,21838,21856,21888,21225,20874,20875,20876,20877,20878,20879,20881,20882,21230,21222,20858,20859,20860,20861
15264|Sentinelle Anubisath|Anubisath Sentinel|61|61|1|3428:|21744,21226,22203,21223,22389,22202,21218,21321,21323,21324,21762,21836,21837,21838,21856,21888,20874,20875,20876,20877
15229|Soldat vekniss|Vekniss Soldier|61|61|1|3428:|20066,12716,21836,21837,21838,21856,21888,21225,20874,20875,20876,20877,20878,20879,20881,20882,21230,12720,21222,20858
15246|Tueur d'esprit qiraji|Qiraji Mindslayer|61|61|1|3428:|21889,21891,21218,21321,21323,21324,21762,14510,21224,20874,20875,20876,20877,20878,20879,20881,20882,21230,21222,20858
15327|Aiguillonneur de la Ruche'Zara|Hive'Zara Stinger|61|61|1|3429:|21225,21804,14509,21803,12720,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859
15338|Destructeur d'obsidienne|Obsidian Destroyer|61|61|1|3429:|22203,21223,22202,21761,21804,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,7076,20858
15336|Fouette-queue de la Ruche'Zara|Hive'Zara Tail Lasher|61|61|1|3429:|21800,21805,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,19441,20858,20859,20860,20861,20862,20863,20864
15343|Garde-essaim qiraji|Qiraji Swarmguard|61|61|1|3429:|21761,21804,16253,21224,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859
15324|Gladiateur qiraji|Qiraji Gladiator|61|61|1|3429:|21761,21224,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860,20861
15387|Guerrier qiraji|Qiraji Warrior|61|61|1|3429:|
15325|Guêpe de la Ruche'Zara|Hive'Zara Wasp|61|61|1|3429:|12717,22388,22389,22390,14510,21225,21804,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873
15344|Piqueur garde-essaim|Swarmguard Needler|61|61|1|3429:|
15320|Soldat de la Ruche'Zara|Hive'Zara Soldier|61|61|1|3429:|21225,21804,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860,20861
15323|Traqueur des sables de la Ruche'Zara|Hive'Zara Sandstalker|61|61|1|3429:|21225,21804,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860,20861
15981|Acolyte de Naxxramas|Naxxramas Acolyte|61|61|1|3456:|23664,23665,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16506|Adorateur de Naxxramas|Naxxramas Worshipper|61|61|1|3456:|
16167|Assemblage osseux|Bony Construct|61|61|1|3456:|22390,14509,23665,23667,23668,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16215|Bâton impie|Unholy Staff|61|61|1|3456:|23238,22374,22373,22375,22376,23055
16034|Bête de peste|Plague Beast|61|61|1|3456:|
16145|Capitaine des chevaliers de la mort|Deathknight Captain|61|61|1|3456:|23663,23664,23665,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16163|Cavalier de la mort|Deathknight Cavalier|61|61|1|3456:|23663,23665,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16146|Chevalier de la mort|Deathknight|61|61|1|3456:|
16154|Chevalier de la mort ressuscité|Risen Deathknight|61|61|1|3456:|22389,23665,23667,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16448|Doguemort pestiféré|Plagued Deathhound|61|61|1|3456:|23221,23237,22374,22373,22375,22376,23055
16216|Epées impies|Unholy Swords|61|61|1|3456:|23044,23221,23237,22374,22373,22375,22376,23055
16449|Esprit de Naxxramas|Spirit of Naxxramas|61|61|1|3456:|23664,23667,23668,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16193|Forgeron squelettique|Skeletal Smith|61|61|1|3456:|23668,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16573|Gardien des cryptes|Crypt Guard|61|61|1|3456:|
16168|Gargouille peau de pierre|Stoneskin Gargoyle|61|61|1|3456:|23663,23665,23667,12728,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16446|Gargouille pestiférée|Plagued Gargoyle|61|61|1|3456:|23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16243|Gelée de la peste|Plague Slime|61|61|1|3456:|22708
15977|Glisseuse infectieuse|Infectious Skitterer|61|61|1|3456:|
16017|Golem recousu|Patchwork Golem|61|61|1|3456:|23663,23664,23665,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16244|Goule infectieuse|Infectious Ghoul|61|61|1|3456:|23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16447|Goule pestiférée|Plagued Ghoul|61|61|1|3456:|23663,23664,12720,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16156|Guerrier touché par l'obscurité|Dark Touched Warrior|61|61|1|3456:|23666,22708,22374,22373,22375,22376,23055
16158|Guerrier touché par la mort|Death Touched Warrior|61|61|1|3456:|23069,23226,23238,22374,22373,22375,22376,23055
16157|Guerrier touché par le destin|Doom Touched Warrior|61|61|1|3456:|23044,22373,22375,22376,23055
16194|Hache impie|Unholy Axe|61|61|1|3456:|23665,23668,22708,23237,23238,22374,22373,22375,22376,23055
15979|Horreur des tombes|Tomb Horror|61|61|1|3456:|14511,23664,23665,23666,23221,23069,14227,22708,23237,23238,22374,22373,22375,22376,23055,19441
16297|Larve mutante|Mutated Grub|61|61|1|3456:|
16165|Nécrochevalier|Necro Knight|61|61|1|3456:|23664,23665,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16453|Nécrotraqueur|Necro Stalker|61|61|1|3456:|22388,23663,23664,23667,23666,23044,23221,23069,23226,14227,22708,23237,23238,22374,22373,22375,22376,23055,19441
16236|Oeil pédonculé|Eye Stalk|61|61|1|3456:|
16164|Ombre de Naxxramas|Shade of Naxxramas|61|61|1|3456:|23664,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16067|Palefroi squelettique|Skeletal Steed|61|61|1|3456:|23663,23665,23668,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
15974|Rampant de l'effroi|Dread Creeper|61|61|1|3456:|16253,23665,23667,23668,23666,23044,23221,23069,23226,14227,22708,23237,23238,22374,22373,22375,22376,23055,19441
15978|Ravageur des cryptes|Crypt Reaver|61|61|1|3456:|23665,23667,23666,23069,23226,14227,22708,23237,22374,22373,22375,22376,23055,19441
16020|Savant fou|Mad Scientist|61|61|1|3456:|23663,23664,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
15980|Sectateur de Naxxramas|Naxxramas Cultist|61|61|1|3456:|23663,23665,23667,23668,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16861|Seigneur de la mort|Death Lord|61|61|1|3456:|
16505|Suivant de Naxxramas|Naxxramas Follower|61|61|1|3456:|
15975|Tisse-charogne|Carrion Spinner|61|61|1|3456:|22390,23664,23665,23667,12728,23668,23666,23044,23221,23069,23226,14227,22708,23237,23238,22374,22373,22375,22376,23055
15976|Traque-venin|Venom Stalker|61|61|1|3456:|23667,23668,23666,23044,23221,23069,23226,14227,22708,23237,23238,22374,22373,22375,22376,23055,19441
16018|Vomisseur de bile|Bile Retcher|61|61|1|3456:|23663,23664,23665,23668,23666,23044,23221,23069,23226,23237,23238,22374,22373,22375,22376,23055
1050|Garde royal Plaiedécaille|Scalebane Royal Guard|61|62|1|11:87,70;85,68;88,66;86,70;82,69;87,65;87,67;85,71|
1049|Wyrmide de braise|Wyrmkin Firebrand|61|62|1|11:87,54;88,52;89,57;88,60;88,59;89,58;88,56;89,59|
12802|Dévoreur Chimaerok|Chimaerok Devourer|61|62|1|357:31,76;30,76;28,71;29,71;29,77;29,78;29,79|21024
11501|Roi Gordok|King Gordok|61|62|1|2557:|18520,18521,18522,18523,18524,18525,18526,18527,18780,19258,18640,21982,18334
11665|Annihilateur de lave|Lava Annihilator|61|62|1|2717:|17011,14510,14509,16253,9262,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857
11669|Diablotin des flammes|Flame Imp|61|62|1|2717:|
12076|Elémentaire de lave|Lava Elemental|61|62|1|2717:|17011,22389,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861,16864
11667|Garde des flammes|Flameguard|61|62|1|2717:|17010,9262,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861,16864
11666|Marchefeu|Firewalker|61|62|1|2717:|17010,14510,16253,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861
11668|Seigneur du feu|Firelord|61|62|1|2717:|17010,12716,12717,14511,22389,14510,16253,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850
12101|Surgisseur de lave|Lava Surger|61|62|1|2717:|21308,17011,14511,9262,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858
8716|Seigneur de l'effroi|Dreadlord|62|62|1|4:39,77;35,64;35,71;39,74;37,71;38,72|4213,21104,18665,12720
12900|Somnus||62|62|1|8:74,68|16870,4557
12899|Axtroz||62|62|1|11:82,48|16872,12728,4557
16072|Seigneur-marées Rrurgaz|Tidelord Rrurgaz|62|62|1|15:76,19|
1843|Contremaître Jerris|Foreman Jerris|62|62|2|28:46,9|
1851|La Bogue|The Husk|62|62|4|28:62,36|12803
12496|Cherche-rêve|Dreamtracker|62|62|1|47:63,26|4557
12477|Gardien de Verdantis|Verdantine Boughguard|62|62|1|47:65,25;62,16;59,31;62,28;66,28;68,28;61,31;66,23|21146,8165
5718|Rothos||62|62|1|47:66,20|4557
12474|Gardien Emeraldon|Emeraldon Boughguard|62|62|1|331:92,39;90,40;93,37;95,37;95,40|21147
5314|Phantim||62|62|1|331:93,39|22123,4557
12498|Traquerêve|Dreamstalker|62|62|1|331:94,37|8165,4557
5320|Gardien des marais Jademir|Jademir Boughguard|62|62|1|357:54,10;48,12;54,15;50,7;51,10;50,16;51,8;52,6|21148
12497|Hurle-rêve|Dreamroarer|62|62|1|357:51,7|14510,4557
5312|Lethlas||62|62|1|357:50,12|4557
12803|Seigneur Lakmaeran|Lord Lakmaeran|62|62|1|357:29,73|21027,21024
10371|Capitaine de la Griffe enragée|Rage Talon Captain|62|62|1|1583:|12717,16786,7191,12728,15416,13260,14227
10363|Général Drakkisath|General Drakkisath|62|62|3|1583:|12592,12602,13098,13141,13142,13519,15730,16663,16666,16674,16688,16690,16700,16706,16721,16726,16730,22253,22267,22268
10430|La Bête|The Beast|62|62|3|1583:|12709,12963,12964,12965,12966,12967,12968,12969,16729,19227,22311,24101
11347|Zélote Lor'Khan|Zealot Lor'Khan|62|62|1|1977:|19815
11348|Zélote Zath|Zealot Zath|62|62|1|1977:|
10440|Baron Rivendare||62|62|1|2017:|13251,13335,13340,13344,13345,13346,13349,13361,13368,13505,16668,16678,16687,16694,16699,16709,16719,16728,16732,22408
10812|Grand croisé Dathrohan|Grand Crusader Dathrohan|62|62|1|2017:|
10508|Ras Murmegivre|Ras Frostwhisper|62|62|1|2057:|13314,13521,13626,12843
11352|Berserker gurubashi|Gurubashi Berserker|62|62|1|2597:56,69#1977:|12717,22390,19221,20259,14510,19921,20258,20261,20263,19908,16253,19813,19818,19819,19774,19814,19821,19820,19727,14557
12467|Capitaine Griffemort|Death Talon Captain|62|62|1|2677:|19358,19436,19437,16786,15416,10310,10309,10308
12463|Flammécaille Griffemort|Death Talon Flamescale|62|62|1|2677:|19358,19436,19437,16786,14557,10310,10309,10308
12557|Grethok le Contrôleur|Grethok the Controller|62|62|1|2677:|
12457|Lieur de sort de l'Aile noire|Blackwing Spellbinder|62|62|1|2677:|19362,19434,19435,19183,12728,10310,10309,10308
12464|Rongé Griffemort|Death Talon Seether|62|62|1|2677:|19358,19436,19437,16786,15416,10310,10309,10308
12458|Sous-chef de l'Aile noire|Blackwing Taskmaster|62|62|1|2677:|
12461|Surveillant Griffemort|Death Talon Overseer|62|62|1|2677:|19362,19434,19435,19183,14509,15416,10310,10309,10308
11673|Ancien chien du Magma|Ancient Core Hound|62|62|1|2717:|12716,22389,22390,14509,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858
11661|Attise-flammes|Flamewaker|62|62|1|2717:|20951,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861,16864,7078
11658|Géant de lave|Molten Giant|62|62|1|2717:|14509,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861,16864,11382
12119|Protecteur Attise-flammes|Flamewaker Protector|62|62|1|2717:|16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861,16864,7078,7077
11662|Prêtre Attise-flammes|Flamewaker Priest|62|62|1|2717:|16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861,16864,14557,7078
11672|Rageur du Magma|Core Rager|62|62|1|2717:|
15277|Défenseur Anubisath|Anubisath Defender|62|62|1|3428:|21226,21889,21891,22203,21223,22389,22390,22202,21218,21321,21323,21324,21762,16253,20874,20875,20876,20877,20878,20879
15235|Flagellant vekniss|Vekniss Stinger|62|62|1|3428:|21836,21837,21838,21856,21888,21225,20874,20875,20876,20877,20878,20879,20881,20882,21230,12728,21222,20858,20859,20860
15240|Rampant de la ruche vekniss|Vekniss Hive Crawler|62|62|1|3428:|21889,21891,20874,20875,20876,20877,20878,20879,20881,20882,21230,21222,19441,20858,20859,20860,20861,20862,20863,20864
15335|Chasse-chair|Flesh Hunter|62|62|1|3429:|21156,21227,12716,22202,20768,21804,16253,21803,21800,21805,21802,21801,20866,20868,20869,20870,20871,20872,20873,7076
15355|Gardien Anubisath|Anubisath Guardian|62|62|1|3429:|12800,21226,22203,21223,12716,22202,21761,21804,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872
16368|Acolyte de la nécropole|Necropolis Acolyte|62|62|1|3456:|23665,23667,12728,23666,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16451|Chevalier de la mort justicier|Deathknight Vindicator|62|62|1|3456:|23069,23226,23238,22374,22373,22375,22376,23055
16029|Crache-vase|Sludge Belcher|62|62|1|3456:|
16021|Monstruosité vivante|Living Monstrosity|62|62|1|3456:|23664,23044,23221,23069,23226,22708,23237,23238,22374,22373,22375,22376,23055
16452|Nécro-chevalier garde|Necro Knight Guardian|62|62|1|3456:|23668,23044,23226,23237,23238,22374,22373,22375,22376,23055
12100|Ravageur de lave|Lava Reaver|62|63|1|2717:|17011,9262,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850,16851,16857,16858,16861,16864
8717|Gangregarde d'élite|Felguard Elite|63|63|1|4:41,65;42,63;40,73;41,62;43,58;37,56;58,57;60,56|21104,18665
12397|Seigneur Kazzak|Lord Kazzak|63|63|3|4:36,75|18665
15552|Docteur Weavil|Doctor Weavil|63|63|1|15:78,17|21103,21130
1839|Grand prêtre écarlate|Scarlet High Clerist|63|63|2|28:57,35;44,19;42,19|
14509|Grand prêtre Thekal|High Priest Thekal|63|63|3|1977:|19768,19896,19897,19898,19899,19901,19902,20260,20266,19881,19716,19717,19718,19719,19720,19721,19722,19723,19724,19943
14507|Grand prêtre Venoxis|High Priest Venoxis|63|63|3|1977:|19900,19903,19904,19905,19906,19907,22216,19881,19716,19717,19718,19719,19720,19721,19722,19723,19724,19943
14517|Grande prêtresse Jeklik|High Priestess Jeklik|63|63|3|1977:|19767,19915,19918,19920,19923,19928,20262,20265,19881,19716,19717,19718,19719,19720,19721,19722,19723,19724,19943
14510|Grande prêtresse Mar'li|High Priestess Mar'li|63|63|3|1977:|19871,19919,19925,19927,19930,20032,19881,19716,19717,19718,19719,19720,19721,19722,19723,19724,19943
14834|Hakkar||63|63|3|1977:|19802,19943
11380|Jin'do le Maléficieur|Jin'do the Hexxer|63|63|3|1977:|22637,19716,19717,19718,19719,19720,19721,19722,19723,19724,19943
11382|Seigneur sanglant Mandokir|Bloodlord Mandokir|63|63|3|1977:|19872,22637,19716,19717,19718,19719,19720,19721,19722,19723,19724,19943
10184|Onyxia||63|63|3|2159:|17064,17068,17075,17966,18422,18423,18705,21108
14020|Chromaggus||63|63|3|2677:|
11981|Flamegor||63|63|3|2677:|
12460|Garde wyrm Griffemort|Death Talon Wyrmguard|63|63|1|2677:|19354,19438,19439,15416,10310,10309,10308
11983|Gueule-de-feu|Firemaw|63|63|3|2677:|
14601|Rochébène|Ebonroc|63|63|3|2677:|
12017|Seigneur des couvées Lashlayer|Broodlord Lashlayer|63|63|3|2677:|19341,19342,19350,19351,19373,19374,20383
12435|Tranchetripe l'Indompté|Razorgore the Untamed|63|63|3|2677:|19334,19335,19336,19337,19369,19370
12056|Baron Geddon||63|63|3|2717:|18563,17010,20951,4787,7078,7077
11659|Destructeur de lave|Molten Destroyer|63|63|1|2717:|9144,17010,8956,17011,12716,14511,14509,16799,16802,16804,16806,16817,16819,16825,16827,16828,16830,16838,16840,16850
12057|Garr||63|63|3|2717:|18564,17011,20951,7076,7075
12259|Gehennas||63|63|3|2717:|17331,20951,7078,7077
11988|Golemagg l'Incinérateur|Golemagg the Incinerator|63|63|3|2717:|17203,17011,20951,7076,7078,7075,7077
12118|Lucifron||63|63|3|2717:|16665,17329,20951,7078,7077
11982|Magmadar||63|63|3|2717:|20951
12098|Messager de Sulfuron|Sulfuron Harbinger|63|63|3|2717:|17330,20951,7078,7077
12264|Shazzrah||63|63|3|2717:|17332,20951,7078,7077
15727|C'Thun||63|63|3|3428:|20929,20933,21221,21579,22734
15252|Champion qiraji|Qiraji Champion|63|63|1|3428:|21889,21891,21218,21321,21323,21324,21762,21224,20874,20875,20876,20877,20878,20879,20881,20882,21230,21222,20858,20859
15276|Empereur Vek'lor|Emperor Vek'lor|63|63|3|3428:|20735,20930,21597,21598,21599,21600,21601,21602,21229
15275|Empereur Vek'nilash|Emperor Vek'nilash|63|63|3|3428:|20726,20926,21604,21605,21606,21607,21608,21609,21679,21229
15589|Eye of C'Thun||63|63|3|3428:|
15510|Fankriss l'Inflexible|Fankriss the Unyielding|63|63|3|3428:|21229
15311|Garde Anubisath|Anubisath Warder|63|63|1|3428:|21226,21889,21891,22203,21223,22202,21218,21321,21323,21324,21762,20874,20875,20876,20877,20878,20879,20881,20882,21230
15516|Garde de guerre Sartura|Battleguard Sartura|63|63|3|3428:|21229
15963|L'Œil du Maître|The Master's Eye|63|63|3|3428:|
15263|Le Prophète Skeram|The Prophet Skeram|63|63|3|3428:|22222,21229
15896|Portail de C'Thun|C'Thun Portal|63|63|0|3428:|
15509|Princesse Huhuran|Princess Huhuran|63|63|3|3428:|21616,21617,21618,21619,21620,21621,20928,20932,21229
15543|Princesse Yauj|Princess Yauj|63|63|3|3428:|21682,21683,21684,21686,21687,21692,21693,21694,21695,21696,21697,21229
15511|Seigneur Kri|Lord Kri|63|63|3|3428:|21603,21680,21681,21685,21692,21693,21694,21695,21696,21697,21229
15544|Vem||63|63|3|3428:|21688,21689,21690,21691,21692,21693,21694,21695,21696,21697,21229
15299|Viscidus||63|63|3|3428:|21622,21623,21624,21625,21626,21677,22399,20928,20932,21229
15369|Ayamiss le Chasseur|Ayamiss the Hunter|63|63|3|3429:|21466,21478,21480,21481,21482,21483,21484,21479,20885,20886,20889,20890,20884,20888
15370|Buru Grandgosier|Buru the Gorger|63|63|3|3429:|21485,21486,21487,21488,21489,21490,21491,20885,20886,20889,20890,20884,20888
15389|Capitaine Drenn|Captain Drenn|63|63|1|3429:|21806,21809,21810,21761,21804,21224,21800,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859
15391|Capitaine Qeez|Captain Qeez|63|63|1|3429:|21806,21809,21810,21761,21224,21803,21800,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858
15392|Capitaine Tuubid|Captain Tuubid|63|63|1|3429:|21806,21809,21810,21761,21224,21800,21805,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860
15390|Capitaine Xurrem|Captain Xurrem|63|63|1|3429:|21806,21809,21810,21761,21224,21800,21802,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860,20861
15385|Colonel Zerran||63|63|1|3429:|21806,21809,21810,21761,21224,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860,20861,20862
15341|Général Rajaxx|General Rajaxx|63|63|3|3429:|21492,21493,21494,21495,21496,21497,20885,20889,20884,20888
15348|Kurinnaxx||63|63|3|3429:|21498,21499,21500,21501,21502,21503,22217,20885,20889,20884,20888
15388|Major Parron|Major Pakkon|63|63|1|3429:|21806,21809,21810,21761,21224,21805,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859,20860
15386|Major Yeggeth||63|63|1|3429:|21806,21809,21810,21761,21224,21803,21800,21802,21801,20867,20866,20868,20869,20870,20871,20872,20873,21222,20858,20859
15340|Moam||63|63|3|3429:|21455,21467,21468,21469,21470,21471,21472,21473,21474,21475,21476,21477,22220,21479,20886,20890,20884,20888
15339|Ossirian l'Intouché|Ossirian the Unscarred|63|63|3|3429:|21220,20886,20890,20884,20888
15956|Anub'Rekhan||63|63|3|3456:|22935,22936,22937,22938,22939,22355,22362,22369,22726
16025|Cracheur raccomodé|Stitched Spewer|63|63|1|3456:|23664,23668,23666,23044,23221,23069,23226,23237,23238,22374,22373,22375,22376,23055
16065|Dame Blaumeux|Lady Blaumeux|63|63|3|3456:|
15930|Feugen||63|63|3|3456:|
15932|Gluth||63|63|3|3456:|22813,22981,22983,22994,23075,22354,22355,22356,22358,22361,22362,22363,22365,22368,22369,22370,22372,22726
16060|Gothik le Moissonneur|Gothik the Harvester|63|63|3|3456:|23020,23021,23023,23032,23073,22358,22365,22372,22726
15953|Grande veuve Faerlina|Grand Widow Faerlina|63|63|3|3456:|22806,22940,22941,22942,22943,22355,22362,22369,22726
15931|Grobbulus||63|63|3|3456:|22803,22810,22967,22968,22988,22354,22361,22368,22726
16062|Généralissime Mograine|Highlord Mograine|63|63|3|3456:|
15936|Heigan l'Impur|Heigan the Unclean|63|63|3|3456:|23019,23033,23035,23036,23068,22356,22363,22370,22726
16011|Horreb|Loatheb|63|63|3|3456:|22800,23037,23038,23039,23042,22726
16061|Instructeur Razuvious|Instructor Razuvious|63|63|3|3456:|23004,23009,23014,23017,23018,23219,22358,22365,22372,22726
15990|Kel'Thuzad||63|63|3|3456:|22520,22733,22798,22799,22802,22812,22819,22821,23053,23054,23056,23057,23577
16028|Le Recousu|Patchwerk|63|63|3|3456:|22815,22818,22820,22960,22961,22354,22361,22368,22726
15952|Maexxna||63|63|3|3456:|22804,22807,22947,22954,23220,22726
15954|Noth le Porte-peste|Noth the Plaguebringer|63|63|3|3456:|22816,23005,23006,23028,23029,23030,23031,22356,22363,22370,22726
16063|Sire Zeliek|Sir Zeliek|63|63|3|3456:|
15929|Stalagg||63|63|3|3456:|
15928|Thaddius||63|63|3|3456:|22801,22808,23000,23001,23070,22726
16064|Thane Korth'azz||63|63|3|3456:|
]==]

ns.BESTIAIRE_ZONES = [==[
1|Dun Morogh|1426
3|Terres ingrates (Badlands)|1418
4|Terres foudroyées|1419
8|Marais des Chagrins|1435
10|Bois de la Pénombre (Duskwood)|1431
11|Les Paluns|1437
12|Forêt d'Elwynn|1429
14|Durotar|1411
15|Marécage d'Âprefange|1445
16|Azshara|1447
17|Les Tarides|1413
28|Maleterres de l’ouest|1422
33|Vallée de Strangleronce|1434
36|Montagnes d'Alterac|1416
38|Loch Modan|1432
40|Marche de l'Ouest (Westfall)|1436
41|Défilé de Deuillevent|1430
44|Les Carmines|1433
45|Hautes-terres Arathies|1417
46|Steppes ardentes|1428
47|Les Hinterlands|1425
51|Gorge des Vents brûlants|1427
85|Clairières de Tirisfal|1420
130|Forêt des Pins argentés (Silverpine Forest)|1421
139|Maleterres de l'est (Eastern Plaguelands)|1423
141|Teldrassil|1438
148|Sombrivage (Darkshore)|1439
209|Donjon d'Ombrecroc|310
215|Mulgore|1412
267|Contreforts de Hautebrande|1424
331|Orneval|1440
357|Feralas|1444
361|Gangrebois (Felwood)|1448
400|Mille pointes|1441
405|Désolace|1443
406|Les Serres-Rocheuses|1442
440|Tanaris|1446
490|Cratère d'Un'Goro|1449
491|Kraal de Tranchebauge|301
493|Reflet-de-Lune|1450
618|Berceau-de-l’Hiver|1452
717|La Prison|225
718|Cavernes des lamentations|279
719|Profondeurs de Brassenoire|221
721|Gnomeregan|226
722|Souilles de Tranchebauge|300
796|Monastère écarlate|302
1176|Zul'Farrak|219
1337|Uldaman|230
1377|Silithus|1451
1477|Le temple d'Atal'Hakkar|220
1497|Fossoyeuse|1458
1519|Hurlevent|1453
1581|Les Mortemines|291
1583|Pic Rochenoire|253
1585|La Prison de Hurlevent|
1637|Orgrimmar|1454
1638|Thunder Bluff|1456
1977|Zul'Gurub|233
2017|Stratholme|317
2057|Scholomance|306
2100|Maraudon|280
2159|Repaire d'Onyxia|248
2257|Tram des profondeurs|0
2437|Gouffre de Ragefeu|213
2557|Hache-tripes|234
2597|Vallée d'Alterac|1459
2677|Repaire de l'Aile noire|287
2717|Cœur du Magma|232
3428|Ahn'Qiraj|320
3429|Ruines d'Ahn'Qiraj|247
3456|Naxxramas|166
]==]
