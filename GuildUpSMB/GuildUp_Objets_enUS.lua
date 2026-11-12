-- GuildUp : noms anglais de tous les objets échangeables du jeu (ni liés quand ramassés, ni de quête,
-- ni gris), pour chercher un objet par son nom dans les Besoins même sans l'avoir sur soi.
-- Généré depuis les données du client WoW Forever 1.60.1.70862, anglais (wago.tools : ItemSparse, Item)
-- par outils/generer_objets.py. Ne pas modifier à la main.
-- Une ligne par objet : id:qualité:classe:niveau d'objet:nom (classe 7 = artisanat, 5 = composant)
-- Utilisé seulement sur un client anglais (enUS, enGB) : sinon ce fichier ne fait rien et les noms
-- viennent de GuildUp_Objets.lua (français). Même sélection d'objets dans les deux fichiers.

local NOM_ADDON, ns = ...

local langue = GetLocale and GetLocale()
if langue ~= "enUS" and langue ~= "enGB" then return end

ns.DONNEES_OBJETS = [==[
252264:1:15:1:"Gold"
3041:2:2:31:"Mage-Eye" Blunderbuss
268880:1:0:10:"Secret" Bait
6292:1:15:15:10 Pound Mud Snapper
13917:1:15:55:103 Pound Mightfish
13909:1:15:55:12 Pound Lobster
6294:1:15:15:12 Pound Mud Snapper
13910:1:15:55:15 Pound Lobster
6295:1:15:15:15 Pound Mud Snapper
13901:1:15:55:15 Pound Salmon
6309:1:15:15:17 Pound Catfish
13902:1:15:55:18 Pound Salmon
6310:1:15:15:19 Pound Catfish
13911:1:15:55:19 Pound Lobster
1977:1:1:1:20-slot Bag
13912:1:15:55:21 Pound Lobster
6311:1:15:15:22 Pound Catfish
13913:1:15:55:22 Pound Lobster
13903:1:15:55:22 Pound Salmon
13904:1:15:55:25 Pound Salmon
6363:1:15:25:26 Pound Catfish
13905:1:15:55:29 Pound Salmon
6364:1:15:25:32 Pound Catfish
13906:1:15:55:32 Pound Salmon
13885:1:15:45:34 Pound Redgill
13886:1:15:45:37 Pound Redgill
13876:1:15:45:40 Pound Yellowtail
13882:1:15:45:42 Pound Redgill
13883:1:15:45:45 Pound Redgill
13877:1:15:45:47 Pound Yellowtail
13884:1:15:45:49 Pound Redgill
13887:1:15:45:52 Pound Redgill
13878:1:15:45:53 Pound Yellowtail
13879:1:15:45:59 Pound Yellowtail
20351:2:4:63:63 Green Frost Belt
20352:2:4:63:63 Green Frost Bindings
20355:2:4:63:63 Green Frost Gloves
20311:2:4:63:63 Green Rogue Belt
20314:2:4:63:63 Green Rogue Bracers
20280:2:2:63:63 Green Warrior Axe
20285:2:2:63:63 Green Warrior Gun
13880:1:15:45:68 Pound Yellowtail
13907:1:15:55:7 Pound Lobster
13914:1:15:55:70 Pound Mightfish
13915:1:15:55:85 Pound Mightfish
13908:1:15:55:9 Pound Lobster
20324:4:4:90:90 Epic Frost Belt
20325:4:4:90:90 Epic Frost Bindings
20328:4:4:90:90 Epic Frost Gloves
20267:4:4:90:90 Epic Rogue Belt
20269:4:4:90:90 Epic Rogue Bracers
20149:4:2:90:90 Epic Warrior Axe
20146:4:2:90:90 Epic Warrior Gun
20338:2:4:90:90 Green Frost Belt
20339:2:4:90:90 Green Frost Bindings
20342:2:4:90:90 Green Frost Gloves
20297:2:4:90:90 Green Rogue Belt
20300:2:4:90:90 Green Rogue Bracers
20238:2:2:90:90 Green Warrior Axe
20245:2:2:90:90 Green Warrior Gun
13916:1:15:55:92 Pound Mightfish
19450:1:15:35:A Jubling's Tiny Home
281282:1:0:47:A Little Somethin'
216637:1:15:1:A Pile of Random Parts
18664:1:15:1:A Treatise on Military Ranks
14115:1:4:14:Aboriginal Bands
14116:1:4:14:Aboriginal Cape
15971:2:4:20:Aboriginal Rod
14169:1:4:21:Aboriginal Shoulder Pads
20513:2:12:1:Abyssal Crest
20515:4:12:1:Abyssal Scepter
20514:3:12:1:Abyssal Signet
20695:3:4:63:Abyssal War Beads
4407:1:0:36:Accurate Scope
11284:1:6:45:Accurate Slugs
19227:3:12:1:Ace of Beasts
221290:3:15:1:Ace of Dunes
19268:3:12:1:Ace of Elementals
221298:3:15:1:Ace of Nightmares
221281:3:15:1:Ace of Plagues
19276:3:12:1:Ace of Portals
19258:3:12:1:Ace of Warlords
221271:3:15:1:Ace of Wilds
2487:1:2:4:Acolyte Staff
6097:1:4:1:Acolyte's Shirt
59:1:4:1:Acolyte's Shoes
207631:1:0:1:Adder Pheromone
2503:1:2:8:Adept Short Staff
10030:2:4:48:Admiral's Hat
4392:1:0:37:Advanced Target Dummy
10264:2:4:65:Adventurer's Tunic
208005:1:13:1:Agamand Relic Coffer Key
4788:2:4:20:Agile Boots
273815:1:4:1:Airy Windseeker's Shirt
20873:3:12:61:Alabaster Idol
279990:1:0:60:Alchemy Laboratory
12947:6:4:60:Alex's Ring of Audacity
22262:1:15:1:Alliance Gift Collection
8932:1:0:55:Alterac Swiss
20869:3:12:61:Amber Idol
279989:1:0:60:Anarchist's Workbench
289297:4:2:40:Anathema
4672:1:4:10:Ancestral Belt
3289:1:4:11:Ancestral Boots
3642:1:4:9:Ancestral Bracers
4671:1:4:9:Ancestral Cloak
3290:1:4:12:Ancestral Gloves
15944:2:4:12:Ancestral Orb
11023:1:15:35:Ancona Chicken
17030:1:5:30:Ankh
12798:3:2:63:Annihilator
205948:1:0:1:Anodyne Epiphany
6452:1:0:16:Anti-Venom
4799:2:4:23:Antiquated Cloak
279988:1:0:28:Anvil
55:1:4:1:Apprentice's Boots
6096:1:4:1:Apprentice's Shirt
6533:1:0:30:Aquadynamic Fish Attractor
6811:1:0:20:Aquadynamic Fish Lens
7909:2:7:45:Aquamarine
15985:2:4:57:Arachnidian Branch
16040:1:0:60:Arcane Bomb
12363:2:7:60:Arcane Crystal
17019:1:15:42:Arcane Dust
9155:1:0:47:Arcane Elixir
279987:1:0:60:Arcane Forge
17020:1:15:56:Arcane Powder
279985:1:0:28:Arcane Salvager
15931:2:4:61:Arcane Star
260631:1:0:15:Arcane Wine
12360:2:7:55:Arcanite Bar
12790:3:2:63:Arcanite Champion
16022:3:4:60:Arcanite Dragonling
12784:3:2:63:Arcanite Reaper
16206:1:7:55:Arcanite Rod
15872:2:0:55:Arcanite Skeleton Key
6219:1:2:10:Arclight Spanner
19056:3:4:58:Argent Boots
19059:3:4:61:Argent Shoulders
8836:1:7:44:Arthas' Tears
206975:1:13:1:Artifact Storage Key
17036:1:15:40:Ashwood Seed
15987:2:4:61:Astral Orb
217347:1:0:60:Atrophic Poison
21140:1:0:1:Auction Stationery
2419:1:4:37:Augmented Chain Belt
2420:1:4:37:Augmented Chain Boots
2421:1:4:37:Augmented Chain Bracers
2422:1:4:37:Augmented Chain Gloves
3891:1:4:37:Augmented Chain Helm
2418:1:4:37:Augmented Chain Leggings
2417:1:4:37:Augmented Chain Vest
7610:2:4:41:Aurora Sphere
12800:2:7:60:Azerothian Diamond
249726:2:7:55:Azerothium Bar
279265:4:4:65:Azerothium Legplates
277025:2:4:10:Azure Gustwoven Belt
277027:2:4:11:Azure Gustwoven Boots
277023:2:4:10:Azure Gustwoven Bracers
277024:2:4:11:Azure Gustwoven Gloves
277022:2:4:12:Azure Gustwoven Harness
277050:2:4:35:Azure Gustwoven Hood
277051:2:4:35:Azure Gustwoven Spaulders
277026:2:4:12:Azure Gustwoven Trousers
20866:3:12:61:Azure Idol
7060:2:4:38:Azure Shoulders
7052:2:4:35:Azure Silk Belt
7053:2:4:35:Azure Silk Cloak
4319:2:4:29:Azure Silk Gloves
7048:2:4:29:Azure Silk Hood
7046:2:4:28:Azure Silk Pants
4324:2:4:30:Azure Silk Vest
277019:2:4:10:Azure Skyforged Chain
277016:2:4:12:Azure Skyforged Chainmail
277018:2:4:11:Azure Skyforged Gauntlets
277021:2:4:11:Azure Skyforged Greaves
277048:2:4:35:Azure Skyforged Helm
277020:2:4:12:Azure Skyforged Legguards
277049:2:4:35:Azure Skyforged Pauldrons
277017:2:4:10:Azure Skyforged Wristguards
277037:2:4:10:Azure Stormsewn Cord
277054:2:4:35:Azure Stormsewn Cowl
277035:2:4:10:Azure Stormsewn Cuffs
277055:2:4:35:Azure Stormsewn Epaulets
277036:2:4:11:Azure Stormsewn Handwraps
277038:2:4:12:Azure Stormsewn Leggings
277039:2:4:11:Azure Stormsewn Shoes
277034:2:4:12:Azure Stormsewn Vest
277029:2:4:10:Azure Windraveled Armguards
277052:2:4:35:Azure Windraveled Cover
277053:2:4:35:Azure Windraveled Drapes
277033:2:4:11:Azure Windraveled Footwraps
277028:2:4:12:Azure Windraveled Jerkin
277030:2:4:11:Azure Windraveled Mitts
277032:2:4:12:Azure Windraveled Pants
277031:2:4:10:Azure Windraveled Strap
21168:1:15:20:Baby Shark
250618:3:2:63:Bagh Nakh
13935:1:0:55:Baked Salmon
2946:1:2:8:Balanced Throwing Dagger
288929:4:4:30:Band of Sulfuras
20721:3:4:65:Band of the Cultist
1193:1:4:17:Banded Buckler
17187:1:4:14:Banded Buckler
10405:1:4:22:Bandit Shoulders
4264:2:4:40:Barbaric Belt
18948:3:4:32:Barbaric Bracers
4687:1:4:14:Barbaric Cloth Belt
3644:1:4:12:Barbaric Cloth Bracers
4686:1:4:12:Barbaric Cloth Cloak
4254:2:4:30:Barbaric Gloves
5739:2:4:38:Barbaric Harness
7916:2:4:36:Barbaric Iron Boots
7914:2:4:32:Barbaric Iron Breastplate
7917:2:4:37:Barbaric Iron Gloves
7915:2:4:35:Barbaric Iron Helm
7913:2:4:32:Barbaric Iron Shoulders
5963:2:4:34:Barbaric Leggings
2578:2:4:14:Barbaric Linen Vest
5964:2:4:35:Barbaric Shoulders
4457:1:0:35:Barbecued Buzzard Wing
6555:1:4:14:Bard's Cloak
5319:1:4:20:Bashing Pauldrons
279981:1:0:4:Basic Campfire Kit
8394:1:12:1:Basilisk Brain
22296:1:15:1:Basket of Flowers
1194:1:2:4:Bastard Sword
250067:1:0:55:Bat Hachee
6356:1:15:8:Battered Chest
16882:1:15:20:Battered Junkbox
2371:1:4:10:Battered Leather Belt
2373:1:4:10:Battered Leather Boots
2374:1:4:10:Battered Leather Bracers
2375:1:4:10:Battered Leather Gloves
2370:1:4:10:Battered Leather Harness
2372:1:4:10:Battered Leather Pants
926:1:2:25:Battle Axe
3279:1:4:12:Battle Chain Boots
3280:1:4:9:Battle Chain Bracers
4668:1:4:9:Battle Chain Cloak
4669:1:4:10:Battle Chain Girdle
3281:1:4:11:Battle Chain Gloves
6526:1:4:37:Battle Harness
3650:1:4:9:Battle Shield
2527:1:2:36:Battle Staff
15224:2:2:25:Battlesmasher
2361:1:2:2:Battleworn Hammer
249425:2:7:45:Bauxite
14088:1:4:8:Beaded Cloak
14093:1:4:9:Beaded Cord
14087:1:4:8:Beaded Cuffs
14089:1:4:10:Beaded Gloves
15969:2:4:10:Beaded Orb
14086:1:4:10:Beaded Sandals
16166:1:0:5:Bean Soup
4795:2:4:25:Bear Bracers
250074:1:0:35:Bear Brisket
250070:1:0:55:Bear Bruscitti
4821:2:4:23:Bear Buckler
3173:1:7:11:Bear Meat
2025:1:2:20:Bearded Axe
19228:4:12:1:Beasts Deck
235278:4:15:1:Beasts Deck
3190:1:2:8:Beatstick
3422:1:4:30:Beautiful Wildflowers
2888:1:0:10:Beer Basted Boar Ribs
3711:1:12:1:Belamoore's Research Journal
18635:1:0:45:Bellara's Nutterbar
18405:4:4:62:Belt of the Archmage
4882:1:13:1:Benedict's Key
289296:4:2:40:Benediction
35:1:2:2:Bent Staff
259891:2:2:48:Berdun's Trusty Rifle
22249:2:1:65:Big Bag of Enchantment
3730:1:7:21:Big Bear Meat
3726:1:0:15:Big Bear Steak
7945:2:2:46:Big Black Mace
4380:1:0:33:Big Bronze Bomb
3848:2:2:20:Big Bronze Knife
4394:1:0:43:Big Iron Bomb
6367:1:2:30:Big Iron Fishing Pole
12251:2:2:37:Big Stick
8216:2:4:48:Big Voodoo Cloak
8201:2:4:44:Big Voodoo Mask
8202:2:4:47:Big Voodoo Pants
8200:2:4:43:Big Voodoo Robe
7973:1:7:40:Big-mouth Clam
275612:3:4:58:Bileblister Boots
275610:3:4:58:Bileblister Claws
275611:3:4:58:Bileblister Girdle
4563:1:2:9:Billy Club
18283:3:0:60:Biznicks 247x128 Accurascope
3024:1:2:26:BKP 2700 "Enforcer"
3025:1:2:36:BKP 42 "Ultra"
19166:4:2:66:Black Amnesty
11754:2:12:1:Black Diamond
15416:1:7:55:Black Dragonscale
16984:4:4:61:Black Dragonscale Boots
15050:3:4:58:Black Dragonscale Breastplate
252605:4:4:61:Black Dragonscale Helm
15052:3:4:62:Black Dragonscale Leggings
15051:3:4:60:Black Dragonscale Shoulders
2325:1:7:40:Black Dye
22194:4:4:70:Black Grasp of the Destroyer
10360:1:15:30:Black Kingsnake
3541:1:4:1:Black Leather D02 Boots
3545:1:4:1:Black Leather D02 Bracers
3537:1:4:1:Black Leather D02 Breastplate
13468:2:7:60:Black Lotus
10026:2:4:46:Black Mageweave Boots
10003:2:4:43:Black Mageweave Gloves
10024:2:4:46:Black Mageweave Headband
9999:2:4:41:Black Mageweave Leggings
10001:2:4:42:Black Mageweave Robe
10027:2:4:46:Black Mageweave Shoulders
9998:2:4:41:Black Mageweave Vest
3522:1:4:1:Black Night Elf Breastplate
3526:1:4:1:Black Night Elf Gloves
3529:1:4:1:Black Night Elf Helm
7971:2:7:40:Black Pearl
13328:4:15:60:Black Ram
3420:1:4:40:Black Rose
5765:1:1:25:Black Silk Pack
276063:3:15:40:Black Skeletal Horse
2411:3:15:40:Black Stallion Bridle
4336:1:4:40:Black Swashbuckler's Shirt
6834:1:4:1:Black Tuxedo
6835:1:4:23:Black Tuxedo Pants
9262:1:7:40:Black Vitriol
7283:2:4:20:Black Whelp Cloak
7286:1:7:1:Black Whelp Scale
20575:2:4:20:Black Whelp Tunic
5239:1:2:46:Blackbone Wand
2236:3:2:25:Blackfang
211845:2:7:25:Blackfathom Sharpening Stone
19167:4:2:66:Blackfury
19168:4:2:70:Blackguard
273050:1:15:1:Blackmaw Pouch
6370:1:7:15:Blackmouth Oil
1445:1:4:23:Blackrock Pauldrons
5956:1:2:1:Blacksmith Hammer
4763:2:2:9:Blackwood Recurve Bow
14550:4:4:49:Bladebane Armguards
24071:3:2:69:Bland Dagger
10648:1:7:40:Blank Parchment
8392:1:12:1:Blasted Boar Lung
12777:3:2:56:Blazing Rapier
2324:1:7:5:Bleach
12769:3:2:54:Bleakwood Hew
17404:1:0:15:Blended Bean Brew
4817:2:2:22:Blessed Claymore
250592:2:4:59:Blessed Plate Belt
250587:2:4:52:Blessed Plate Boots
250590:2:4:57:Blessed Plate Bracers
250594:2:4:61:Blessed Plate Chest
250588:2:4:54:Blessed Plate Gauntlet
250593:2:4:60:Blessed Plate Helm
250591:2:4:59:Blessed Plate Leggings
250586:2:4:52:Blessed Plate Pauldrons
2921:1:4:15:Blessed Relic
7959:3:2:50:Blight
5530:1:15:34:Blinding Powder
8839:1:7:47:Blindweed
18154:1:0:1:Blizzard Stationery
6646:1:15:15:Bloated Albacore
6644:1:15:5:Bloated Mackerel
5402:1:12:1:Blood of Anacondra
5400:1:12:1:Blood of Cobrahn
5401:1:12:1:Blood of Pythas
5403:1:12:1:Blood of Serpentis
11382:2:7:50:Blood of the Mountain
18023:3:4:59:Blood Ruby Pendant
3220:1:0:15:Blood Sausage
5075:1:12:1:Blood Shard
19688:3:4:65:Blood Tiger Breastplate
19689:3:4:65:Blood Tiger Shoulders
13546:1:0:35:Bloodbelly Fish
19706:2:12:1:Bloodscalp Coin
19690:3:4:65:Bloodsoul Breastplate
19692:3:4:65:Bloodsoul Gauntlets
19691:3:4:65:Bloodsoul Shoulders
15490:1:4:14:Bloodspattered Cloak
15496:1:4:21:Bloodspattered Shoulder Pads
3225:2:2:11:Bloodstained Knife
19726:2:7:60:Bloodvine
19684:3:4:65:Bloodvine Boots
19999:3:4:65:Bloodvine Goggles
19683:3:4:65:Bloodvine Leggings
19998:3:4:65:Bloodvine Lens
19682:3:4:65:Bloodvine Vest
15982:2:4:51:Bloodwoven Rod
286405:1:0:1:Blooming Heart
15415:1:7:50:Blue Dragonscale
15048:3:4:57:Blue Dragonscale Breastplate
252604:4:4:61:Blue Dragonscale Helm
20295:3:4:60:Blue Dragonscale Leggings
15049:3:4:59:Blue Dragonscale Shoulders
6260:1:7:10:Blue Dye
9312:1:0:20:Blue Firework
288336:1:0:20:Blue Firework
7942:2:2:44:Blue Glittering Axe
19708:3:12:61:Blue Hakkari Bijou
856:1:1:15:Blue Leather Bag
6242:2:4:14:Blue Linen Robe
2577:1:4:10:Blue Linen Shirt
6240:2:4:12:Blue Linen Vest
8595:3:15:40:Blue Mechanostrider
20371:1:15:20:Blue Murloc Egg
6263:2:4:20:Blue Overalls
4611:1:7:1:Blue Pearl
11184:1:12:1:Blue Power Crystal
5044:1:0:5:Blue Ribboned Gift
17302:1:0:5:Blue Ribboned Holiday Gift
5048:1:0:5:Blue Ribboned Wrapping Paper
17303:1:0:5:Blue Ribboned Wrapping Paper
21571:1:15:1:Blue Rocket Cluster
17962:2:15:1:Blue Sack of Gems
12361:2:7:55:Blue Sapphire
13332:3:15:40:Blue Skeletal Horse
8626:1:4:10:Blue Sparkler
252480:2:4:58:Blue Suede Armor
252481:2:4:59:Blue Suede Belt
252559:2:4:60:Blue Suede Bracers
252546:2:4:53:Blue Suede Gloves
252482:2:4:61:Blue Suede Hat
252478:2:4:56:Blue Suede Pants
252467:2:4:52:Blue Suede Shoes
252554:2:4:57:Blue Suede Shoulders
273112:2:9:60:Blueprint: Alchemy Laboratory
273117:2:9:60:Blueprint: Anarchist's Workbench
273086:2:9:25:Blueprint: Anvil
273116:2:9:60:Blueprint: Arcane Forge
273103:2:9:25:Blueprint: Arcane Salvager
273102:2:9:25:Blueprint: Cookie's Feast
273101:2:9:40:Blueprint: Expert Campfire
273085:2:9:25:Blueprint: Fermenter
273098:2:9:25:Blueprint: Field Guide
273119:2:9:60:Blueprint: Fishing Hut
273141:2:9:25:Blueprint: Fishing Rack
273106:2:9:25:Blueprint: Greenhouse
273115:2:9:60:Blueprint: Iron Oven
273087:2:9:25:Blueprint: Journeyman Campfire
273124:2:9:60:Blueprint: Loom
273113:2:9:60:Blueprint: Master Forge
273122:2:9:60:Blueprint: Molten Foundry
273118:2:9:60:Blueprint: Plague Doctor's Laboratory
273092:2:9:25:Blueprint: Repair Bot
273097:2:9:25:Blueprint: Rock Garden
273120:2:9:60:Blueprint: Seed Hybridizer
273121:2:9:60:Blueprint: Sewing Machine
273099:2:9:25:Blueprint: Spinning Wheel
273096:2:9:25:Blueprint: Tanning Rack
273105:2:9:25:Blueprint: Toxin Study
273109:2:9:60:Blueprint: Trapper's Workbench
22144:1:15:1:Bluffwatcher's Card
4824:2:2:27:Blurred Axe
3172:1:7:10:Boar Intestines
2677:1:7:14:Boar Ribs
7095:1:4:9:Bog Boots
5206:1:0:12:Bogling Root
5525:1:0:10:Boiled Clams
250616:2:2:57:Bold Dirk
3426:1:4:30:Bold Yellow Shirt
2996:1:7:10:Bolt of Linen Cloth
4339:1:7:45:Bolt of Mageweave
14048:1:7:55:Bolt of Runecloth
4305:1:7:35:Bolt of Silk Cloth
2997:1:7:25:Bolt of Woolen Cloth
13159:1:12:1:Bone Dust
22526:1:12:1:Bone Fragments
20864:2:12:1:Bone Scarab
3320:1:4:9:Bonecaster Sash
15986:2:4:60:Bonecaster's Star
4223:1:9:36:Book of Abolish Magic
8760:1:9:26:Book of Abolish Poison
1332:1:9:14:Book of Cure Poison
1339:1:9:8:Book of Entangling Roots
5147:1:9:18:Book of Entangling Roots II
4225:1:9:28:Book of Entangling Roots III
8900:1:9:38:Book of Entangling Roots IV
8773:1:9:48:Book of Entangling Roots V
8795:1:9:58:Book of Entangling Roots VI
1328:1:9:18:Book of Faerie Fire
8764:1:9:30:Book of Faerie Fire II
8779:1:9:42:Book of Faerie Fire III
8790:1:9:54:Book of Faerie Fire IV
24101:3:9:60:Book of Ferocious Bite V
8745:1:9:8:Book of Healing Touch
5145:1:9:8:Book of Healing Touch II
5150:1:9:14:Book of Healing Touch III
5152:1:9:20:Book of Healing Touch IV
8783:1:9:50:Book of Healing Touch IX
5160:1:9:26:Book of Healing Touch V
4230:1:9:32:Book of Healing Touch VI
8774:1:9:38:Book of Healing Touch VII
8901:1:9:44:Book of Healing Touch VIII
8794:1:9:56:Book of Healing Touch X
21294:3:9:60:Book of Healing Touch XI
8743:1:9:1:Book of Mark of the Wild
5155:1:9:10:Book of Mark of the Wild II
5163:1:9:20:Book of Mark of the Wild III
5153:1:9:30:Book of Mark of the Wild IV
8902:1:9:40:Book of Mark of the Wild V
8776:1:9:50:Book of Mark of the Wild VI
8799:1:9:60:Book of Mark of the Wild VII
1341:1:9:4:Book of Moonfire
1886:1:9:10:Book of Moonfire II
1882:1:9:16:Book of Moonfire III
4228:1:9:22:Book of Moonfire IV
8777:1:9:52:Book of Moonfire IX
8763:1:9:28:Book of Moonfire V
8770:1:9:34:Book of Moonfire VI
8903:1:9:40:Book of Moonfire VII
8904:1:9:46:Book of Moonfire VIII
8796:1:9:58:Book of Moonfire X
5141:1:9:12:Book of Regrowth
8756:1:9:18:Book of Regrowth II
8759:1:9:24:Book of Regrowth III
8765:1:9:30:Book of Regrowth IV
8800:1:9:60:Book of Regrowth IX
8772:1:9:36:Book of Regrowth V
8905:1:9:42:Book of Regrowth VI
8781:1:9:48:Book of Regrowth VII
8791:1:9:54:Book of Regrowth VIII
5730:1:9:4:Book of Rejuvenation
1334:1:9:10:Book of Rejuvenation II
1877:1:9:16:Book of Rejuvenation III
3088:1:9:22:Book of Rejuvenation IV
8785:1:9:52:Book of Rejuvenation IX
8762:1:9:28:Book of Rejuvenation V
8771:1:9:34:Book of Rejuvenation VI
8778:1:9:40:Book of Rejuvenation VII
8906:1:9:46:Book of Rejuvenation VIII
8797:1:9:58:Book of Rejuvenation X
21296:3:9:60:Book of Rejuvenation XI
8758:1:9:22:Book of Remove Curse
22298:1:15:1:Book of Romantic Poems
8787:1:9:22:Book of Soothe Animal
8788:1:9:38:Book of Soothe Animal II
8789:1:9:54:Book of Soothe Animal III
8757:1:9:20:Book of Starfire
8761:1:9:26:Book of Starfire II
8768:1:9:34:Book of Starfire III
8907:1:9:42:Book of Starfire IV
8780:1:9:50:Book of Starfire V
8798:1:9:58:Book of Starfire VI
21295:3:9:60:Book of Starfire VII
5139:1:9:6:Book of Thorns
5148:1:9:14:Book of Thorns II
5154:1:9:24:Book of Thorns III
8769:1:9:34:Book of Thorns IV
8782:1:9:44:Book of Thorns V
8792:1:9:54:Book of Thorns VI
5158:1:9:30:Book of Tranquility
8775:1:9:40:Book of Tranquility II
8786:1:9:50:Book of Tranquility III
8801:1:9:60:Book of Tranquility IV
8744:1:9:6:Book of Wrath
5142:1:9:6:Book of Wrath II
5149:1:9:14:Book of Wrath III
5151:1:9:22:Book of Wrath IV
5156:1:9:30:Book of Wrath V
4226:1:9:38:Book of Wrath VI
8784:1:9:46:Book of Wrath VII
8793:1:9:54:Book of Wrath VIII
17682:3:9:50:Book: Gift of the Wild
17683:3:9:60:Book: Gift of the Wild II
7027:2:4:28:Boots of Darkness
4325:2:4:35:Boots of the Enchanter
2723:1:0:1:Bottle of Dalaran Noir
273131:2:15:60:Bottled Screams
1119:1:0:25:Bottled Spirits
19300:1:0:45:Bottled Winterspring Water
18779:3:12:60:Bottom Half of Advanced Armorsmithing: Volume I
18781:3:12:60:Bottom Half of Advanced Armorsmithing: Volume II
18783:3:12:60:Bottom Half of Advanced Armorsmithing: Volume III
203787:1:0:1:Bottom-Left Map Piece
203786:1:0:1:Bottom-Right Map Piece
14156:3:1:62:Bottomless Bag
254139:1:1:62:Bottomless Reagent Bag
281927:2:4:27:Boulderheart Band
3424:1:4:60:Bouquet of Black Roses
3423:1:4:50:Bouquet of White Roses
22292:1:15:1:Box of Fresh Pies
9541:1:15:47:Box of Goodies
9539:1:15:1:Box of Rations
9540:1:15:1:Box of Spells
6827:1:15:40:Box of Supplies
22291:1:15:1:Box of Woodcrafts
3303:1:4:12:Brackwater Bracers
4680:1:4:13:Brackwater Cloak
3304:1:4:14:Brackwater Gauntlets
4681:1:4:14:Brackwater Girdle
22761:3:4:70:Bramblewood Belt
22760:3:4:70:Bramblewood Boots
22759:3:4:70:Bramblewood Helm
250602:2:2:21:Brass Knuckles
140:1:4:1:Brawler's Boots
6125:1:4:1:Brawler's Harness
278119:1:0:5:Bread with Butter
250080:1:0:15:Breakfast Omelette
250601:4:4:61:Breastplate of Salvation
7081:1:7:45:Breath of Wind
2450:1:7:15:Briarthorn
2424:1:4:50:Brigandine Belt
2426:1:4:50:Brigandine Boots
2427:1:4:50:Brigandine Bracers
2428:1:4:50:Brigandine Gloves
3894:1:4:50:Brigandine Helm
2425:1:4:50:Brigandine Leggings
2423:1:4:50:Brigandine Vest
6532:1:0:30:Bright Baubles
15927:2:4:27:Bright Sphere
4332:1:4:27:Bright Yellow Shirt
10499:2:4:35:Bright-Eye Goggles
14103:2:4:55:Brightcloth Cloak
14101:2:4:54:Brightcloth Gloves
14104:2:4:58:Brightcloth Pants
14100:2:4:54:Brightcloth Robe
12607:3:7:1:Brilliant Chromatic Scale
20748:1:0:55:Brilliant Mana Oil
12253:2:4:41:Brilliant Red Cloak
6290:1:0:10:Brilliant Smallfish
20749:1:0:55:Brilliant Wizard Oil
1402:1:0:12:Brimstone
274971:1:0:35:Briny Seafood Stew
4593:1:0:25:Bristle Whisker Catfish
274917:1:0:12:Brittle Trap
2479:1:2:4:Broad Axe
12247:2:2:32:Broad Bladed Knife
2520:1:2:36:Broadsword
9719:3:15:38:Broken Blade of Heroes
258773:1:12:1:Broken Dart Trap
11111:1:12:37:Broken Sprite Darter Egg
6651:1:2:12:Broken Wine Bottle
2849:2:2:23:Bronze Axe
2841:1:7:20:Bronze Bar
7958:2:2:27:Bronze Battle Axe
250603:2:2:25:Bronze Dory
4382:1:7:29:Bronze Framework
7957:2:2:26:Bronze Greatsword
19713:3:12:61:Bronze Hakkari Bijou
8502:2:15:20:Bronze Lotterybox
2848:2:2:22:Bronze Mace
20861:2:12:1:Bronze Scarab
2850:2:2:24:Bronze Shortsword
4371:1:7:21:Bronze Tube
7956:2:2:25:Bronze Warhammer
275620:3:4:58:Broodwatcher's Belt
275619:3:4:58:Broodwatcher's Clenchers
275621:3:4:58:Broodwatcher's Treaders
280794:1:15:30:Brown Ground Squirrel Whistle
5656:3:15:40:Brown Horse Bridle
875:1:15:1:Brown Horse Summoning
15290:3:15:40:Brown Kodo
4498:1:1:15:Brown Leather Satchel
4343:2:4:10:Brown Linen Pants
6238:2:4:10:Brown Linen Robe
4344:1:4:7:Brown Linen Shirt
2568:1:4:8:Brown Linen Vest
5872:3:15:40:Brown Ram
13333:3:15:40:Brown Skeletal Horse
10361:1:15:30:Brown Snake
2453:1:7:20:Bruiseweed
9451:1:0:25:Bubbling Water
14170:1:4:22:Buccaneer's Mantle
15912:2:4:23:Buccaneer's Orb
6523:1:4:17:Buckled Harness
2523:1:2:35:Bullova
22284:1:15:1:Bundle of Cards
23247:1:15:1:Burning Blossom
4479:1:0:35:Burning Charm
2617:1:4:37:Burning Robes
5210:1:2:25:Burning Wand
4694:1:4:22:Burnished Pauldrons
15324:2:2:56:Burnside Rifle
4665:1:4:8:Burnt Cloak
4666:1:4:9:Burnt Leather Belt
2963:1:4:9:Burnt Leather Boots
3200:1:4:8:Burnt Leather Bracers
2964:1:4:10:Burnt Leather Gloves
3404:1:7:35:Buzzard Wing
21031:1:0:55:Cabbage Kimchi
11584:1:0:5:Cactus Apple Surprise
9758:1:4:12:Cadet Belt
9759:1:4:13:Cadet Boots
9760:1:4:12:Cadet Bracers
9761:1:4:11:Cadet Cloak
9762:1:4:13:Cadet Gauntlets
8179:1:2:6:Cadet's Bow
249874:1:0:35:Calcified Smoothie
4825:2:2:29:Callous Axe
279979:1:0:4:Camp Chair
279978:1:0:4:Camp Tent
260623:1:0:35:Candied Fruit Sampler
7807:1:0:5:Candy Bar
17344:1:0:5:Candy Cane
1357:1:12:10:Captain Sander's Treasure Map
9249:2:13:1:Captain's Key
23083:1:15:1:Captured Flame
4098:1:12:45:Carefully Folded Note
12213:1:0:15:Carrion Surprise
278122:1:0:55:Carrot Salad
254432:2:15:1:Carved Centaur Totem
22288:1:15:1:Case of Homebrew
8491:1:15:20:Cat Carrier (Black Tabby)
8485:1:15:20:Cat Carrier (Bombay)
8486:1:15:20:Cat Carrier (Cornish Rex)
11903:1:15:40:Cat Carrier (Corrupted Kitten)
8487:1:15:20:Cat Carrier (Orange Tabby)
8490:1:15:20:Cat Carrier (Siamese)
8488:1:15:20:Cat Carrier (Silver Tabby)
8489:1:15:20:Cat Carrier (White Kitten)
10592:1:0:40:Catseye Draught
10501:2:4:44:Catseye Ultra Goggles
250951:1:0:5:Caustic Smog Potion
288930:4:4:30:Cauterizing Band
22251:2:1:55:Cenarion Herb Bag
269900:2:15:1:Centaur Banner Deployment Device
274490:2:4:40:Centaur Hoofwarmers
4692:1:4:12:Ceremonial Cloak
3311:1:4:15:Ceremonial Leather Ankleguards
4693:1:4:14:Ceremonial Leather Belt
3312:1:4:13:Ceremonial Leather Bracers
249409:2:7:25:Cerulean Dye
7426:2:4:30:Cerulean Ring
7427:2:4:31:Cerulean Talisman
847:1:4:17:Chainmail Armor
1845:1:4:17:Chainmail Belt
849:1:4:17:Chainmail Boots
1846:1:4:17:Chainmail Bracers
850:1:4:17:Chainmail Gloves
848:1:4:17:Chainmail Pants
250598:4:4:61:Champion's Legplates
250612:2:2:48:Charged Mithril Battleaxe
252575:2:4:51:Charged Scorpid Belt
252602:2:4:61:Charged Scorpid Boots
252593:2:4:56:Charged Scorpid Bracers
252596:2:4:56:Charged Scorpid Gauntlets
252581:2:4:53:Charged Scorpid Helm
252600:2:4:59:Charged Scorpid Leggings
252583:2:4:55:Charged Scorpid Shoulders
252598:2:4:57:Charged Scorpid Vest
15472:1:4:9:Charger's Belt
15474:1:4:8:Charger's Bindings
15473:1:4:10:Charger's Boots
15475:1:4:8:Charger's Cloak
15476:1:4:10:Charger's Handwraps
15478:1:4:8:Charger's Shield
2679:1:0:10:Charred Wolf Meat
19222:1:0:1:Cheap Beer
273636:1:7:45:Chef's Knife
4600:1:0:35:Cherry Grog
5655:3:15:40:Chestnut Mare Bridle
12434:1:12:1:Chillwind E'ko
205942:1:0:1:Chimaeric Epiphany
21024:1:7:60:Chimaerok Tenderloin
15423:1:7:50:Chimera Leather
15073:2:4:55:Chimeric Boots
15074:2:4:53:Chimeric Gloves
15072:2:4:56:Chimeric Leggings
15075:2:4:58:Chimeric Vest
7808:1:0:5:Chocolate Square
288926:4:4:30:Choker of the Fire Lord
18509:4:4:62:Chromatic Cloak
19157:4:4:70:Chromatic Gauntlets
2615:1:4:29:Chromatic Robe
184937:1:0:60:Chronoboon Displacer
212160:1:0:60:Chronoboon Displacer
769:1:7:5:Chunk of Boar Meat
10044:2:4:49:Cindercloth Boots
14044:2:4:55:Cindercloth Cloak
14043:2:4:54:Cindercloth Gloves
12256:2:4:49:Cindercloth Leggings
14045:2:4:56:Cindercloth Pants
10042:2:4:45:Cindercloth Robe
14042:2:4:52:Cindercloth Vest
3864:2:7:40:Citrine
5526:1:0:15:Clam Chowder
250081:1:0:55:Clam Linguine
5503:1:7:14:Clam Meat
16971:1:0:45:Clamlette Surprise
20863:2:12:1:Clay Scarab
1198:1:2:15:Claymore
1851:1:0:24:Cleansing Water
2029:1:2:20:Cleaver
250332:1:0:45:Cleric's Elixir
255717:1:7:26:Clever Poultice
211471:1:13:1:Cliffspring Key
279270:4:4:65:Cloak of Earth and Sky
14134:3:4:55:Cloak of Fire
18413:3:4:62:Cloak of Warding
277001:2:4:10:Cloudy Gustwoven Belt
277003:2:4:11:Cloudy Gustwoven Boots
276999:2:4:10:Cloudy Gustwoven Bracers
277000:2:4:11:Cloudy Gustwoven Gloves
276998:2:4:12:Cloudy Gustwoven Harness
277042:2:4:35:Cloudy Gustwoven Hood
277043:2:4:35:Cloudy Gustwoven Spaulders
277002:2:4:12:Cloudy Gustwoven Trousers
276995:2:4:10:Cloudy Skyforged Chain
276992:2:4:12:Cloudy Skyforged Chainmail
276994:2:4:11:Cloudy Skyforged Gauntlets
276997:2:4:11:Cloudy Skyforged Greaves
277040:2:4:35:Cloudy Skyforged Helm
276996:2:4:12:Cloudy Skyforged Legguards
277041:2:4:35:Cloudy Skyforged Pauldrons
276993:2:4:10:Cloudy Skyforged Wristguards
277013:2:4:10:Cloudy Stormsewn Cord
277046:2:4:35:Cloudy Stormsewn Cowl
277011:2:4:10:Cloudy Stormsewn Cuffs
277047:2:4:35:Cloudy Stormsewn Epaulets
277012:2:4:11:Cloudy Stormsewn Handwraps
277014:2:4:12:Cloudy Stormsewn Leggings
277015:2:4:11:Cloudy Stormsewn Shoes
277010:2:4:12:Cloudy Stormsewn Vest
277005:2:4:10:Cloudy Windraveled Armguards
277044:2:4:35:Cloudy Windraveled Cover
277045:2:4:35:Cloudy Windraveled Drapes
277009:2:4:11:Cloudy Windraveled Footwraps
277004:2:4:12:Cloudy Windraveled Jerkin
277006:2:4:11:Cloudy Windraveled Mitts
277008:2:4:12:Cloudy Windraveled Pants
277007:2:4:10:Cloudy Windraveled Strap
2130:1:2:3:Club
21570:1:15:1:Cluster Launcher
275625:3:4:58:Clutchlord's Grips
275627:3:4:58:Clutchlord's Stompers
275626:3:4:58:Clutchlord's Support
3857:1:7:30:Coal
4364:1:7:15:Coarse Blasting Powder
4365:1:0:20:Coarse Dynamite
4096:1:15:1:Coarse Gorilla Hair
3478:1:7:20:Coarse Grinding Stone
2863:1:0:15:Coarse Sharpening Stone
2836:1:7:15:Coarse Stone
2320:1:7:5:Coarse Thread
3240:1:0:15:Coarse Weightstone
10393:1:15:30:Cockroach
8976:1:9:32:Codex of Abolish Disease
8960:1:9:14:Codex of Cure Disease
18357:3:12:60:Codex of Defense
1095:1:9:18:Codex of Dispel Magic
4282:1:9:36:Codex of Dispel Magic II
4274:1:9:36:Codex of Divine Escape
1109:1:9:30:Codex of Dominate
8955:1:9:8:Codex of Fade
8965:1:9:20:Codex of Fade II
8975:1:9:30:Codex of Fade III
8989:1:9:40:Codex of Fade IV
9007:1:9:50:Codex of Fade V
9029:1:9:60:Codex of Fade VI
8964:1:9:20:Codex of Flash Heal
8969:1:9:26:Codex of Flash Heal II
8978:1:9:32:Codex of Flash Heal III
8983:1:9:38:Codex of Flash Heal IV
8999:1:9:44:Codex of Flash Heal V
9010:1:9:50:Codex of Flash Heal VI
9022:1:9:56:Codex of Flash Heal VII
3118:1:9:40:Codex of Greater Heal
9001:1:9:46:Codex of Greater Heal II
9013:1:9:52:Codex of Greater Heal III
9025:1:9:58:Codex of Greater Heal IV
21284:3:9:60:Codex of Greater Heal V
4273:1:9:16:Codex of Heal
4268:1:9:22:Codex of Heal II
4270:1:9:28:Codex of Heal III
1648:1:9:34:Codex of Heal IV
4272:1:9:30:Codex of Holy Protection
8987:1:9:40:Codex of Holy Protection II
9017:1:9:54:Codex of Holy Protection III
1091:1:9:6:Codex of Holy Smite II
1100:1:9:14:Codex of Holy Smite III
3120:1:9:22:Codex of Holy Smite IV
4271:1:9:30:Codex of Holy Smite V
4284:1:9:38:Codex of Holy Smite VI
9003:1:9:46:Codex of Holy Smite VII
9016:1:9:54:Codex of Holy Smite VIII
8954:1:9:1:Codex of Holy Word: Fortitude
1112:1:9:12:Codex of Holy Word: Fortitude II
3123:1:9:24:Codex of Holy Word: Fortitude III
4285:1:9:36:Codex of Holy Word: Fortitude IV
9004:1:9:48:Codex of Holy Word: Fortitude V
9034:1:9:60:Codex of Holy Word: Fortitude VI
3113:1:9:6:Codex of Holy Word: Shield
3116:1:9:12:Codex of Holy Word: Shield II
3122:1:9:18:Codex of Holy Word: Shield III
4280:1:9:24:Codex of Holy Word: Shield IV
9018:1:9:54:Codex of Holy Word: Shield IX
3119:1:9:30:Codex of Holy Word: Shield V
1651:1:9:36:Codex of Holy Word: Shield VI
8995:1:9:42:Codex of Holy Word: Shield VII
9006:1:9:48:Codex of Holy Word: Shield VIII
9035:1:9:60:Codex of Holy Word: Shield X
1086:1:9:12:Codex of Inner Fire
4266:1:9:20:Codex of Inner Fire II
3124:1:9:30:Codex of Inner Fire III
8991:1:9:40:Codex of Inner Fire IV
9009:1:9:50:Codex of Inner Fire V
9033:1:9:60:Codex of Inner Fire VI
1092:1:9:4:Codex of Lesser Heal II
1102:1:9:10:Codex of Lesser Heal III
3121:1:9:34:Codex of Levitate
8968:1:9:24:Codex of Mana Burn
8977:1:9:32:Codex of Mana Burn II
8988:1:9:40:Codex of Mana Burn III
9005:1:9:48:Codex of Mana Burn IV
9021:1:9:56:Codex of Mana Burn V
8958:1:9:10:Codex of Mind Blast
8962:1:9:16:Codex of Mind Blast II
8967:1:9:22:Codex of Mind Blast III
8972:1:9:28:Codex of Mind Blast IV
9027:1:9:58:Codex of Mind Blast IX
8980:1:9:34:Codex of Mind Blast V
8990:1:9:40:Codex of Mind Blast VI
9002:1:9:46:Codex of Mind Blast VII
9015:1:9:52:Codex of Mind Blast VIII
8974:1:9:30:Codex of Mind Control
8997:1:9:44:Codex of Mind Control II
9024:1:9:58:Codex of Mind Control III
4275:1:9:38:Codex of Mind Rot
8963:1:9:20:Codex of Mind Soothe
8981:1:9:36:Codex of Mind Soothe II
9014:1:9:52:Codex of Mind Soothe III
1085:1:9:22:Codex of Mind Vision
8998:1:9:44:Codex of Mind Vision II
1089:1:9:14:Codex of Nullify Disease
4287:1:9:32:Codex of Nullify Disease II
4269:1:9:30:Codex of Prayer of Healing
4286:1:9:40:Codex of Prayer of Healing II
9008:1:9:50:Codex of Prayer of Healing III
9032:1:9:60:Codex of Prayer of Healing IV
21287:3:9:60:Codex of Prayer of Healing V
8961:1:9:14:Codex of Psychic Scream
8971:1:9:28:Codex of Psychic Scream II
8992:1:9:42:Codex of Psychic Scream III
9020:1:9:56:Codex of Psychic Scream IV
1093:1:9:22:Codex of Remove Curse
4288:1:9:38:Codex of Remove Curse II
1084:1:9:8:Codex of Renew
1088:1:9:14:Codex of Renew II
1108:1:9:20:Codex of Renew III
3115:1:9:26:Codex of Renew IV
9019:1:9:56:Codex of Renew IX
1101:1:9:32:Codex of Renew V
1105:1:9:38:Codex of Renew VI
9000:1:9:44:Codex of Renew VII
9012:1:9:50:Codex of Renew VIII
21285:3:9:60:Codex of Renew X
1090:1:9:10:Codex of Resurrection
1657:1:9:26:Codex of Resurrection II
8996:1:9:42:Codex of Resurrection III
9026:1:9:58:Codex of Resurrection IV
8966:1:9:20:Codex of Shackle Undead
8986:1:9:40:Codex of Shackle Undead II
9031:1:9:60:Codex of Shackle Undead III
4281:1:9:30:Codex of Shadow Protection
8993:1:9:42:Codex of Shadow Protection II
9023:1:9:56:Codex of Shadow Protection III
3114:1:9:24:Codex of Shadow Word: Befuddle
4277:1:9:36:Codex of Shadow Word: Befuddle II
4267:1:9:20:Codex of Shadow Word: Fumble
4276:1:9:32:Codex of Shadow Word: Fumble II
1087:1:9:4:Codex of Shadow Word: Pain
1096:1:9:10:Codex of Shadow Word: Pain II
1641:1:9:18:Codex of Shadow Word: Pain III
1658:1:9:26:Codex of Shadow Word: Pain IV
4279:1:9:34:Codex of Shadow Word: Pain V
8994:1:9:42:Codex of Shadow Word: Pain VI
9011:1:9:50:Codex of Shadow Word: Pain VII
9028:1:9:58:Codex of Shadow Word: Pain VIII
1111:1:9:6:Codex of Sleep
1676:1:9:20:Codex of Sleep II
4283:1:9:40:Codex of Sleep III
17413:3:9:48:Codex: Prayer of Fortitude
17414:3:9:60:Codex: Prayer of Fortitude II
22393:3:9:60:Codex: Prayer of Shadow Protection
5079:2:4:40:Cold Basilisk Eye
219401:1:15:25:Cold Iron Ore
21833:1:15:1:Cologne Bottle
10048:2:4:19:Colorful Kilt
5236:1:2:34:Combustible Wand
8174:2:4:40:Comfortable Leather Hat
16059:1:4:20:Common Brown Shirt
3428:1:4:20:Common Gray Shirt
16060:1:4:20:Common White Shirt
268415:2:7:5:Commonplace Herb Seeds
260807:1:0:45:Compact Critter Carrier
4391:1:0:35:Compact Harvest Reaper Kit
5264:1:12:1:Complimentary Beer Token
228980:1:0:50:Conductive Shield Coating
1113:1:0:15:Conjured Bread
22895:1:0:65:Conjured Cinnamon Roll
8079:1:0:65:Conjured Crystal Water
2288:1:0:15:Conjured Fresh Water
8077:1:0:45:Conjured Mineral Water
5349:1:0:5:Conjured Muffin
1487:1:0:35:Conjured Pumpernickel
2136:1:0:25:Conjured Purified Water
1114:1:0:25:Conjured Rye
8075:1:0:45:Conjured Sourdough
8078:1:0:55:Conjured Sparkling Water
3772:1:0:35:Conjured Spring Water
8076:1:0:55:Conjured Sweet Roll
5350:1:0:5:Conjured Water
15918:2:4:38:Conjurer's Sphere
276468:1:15:1:Consecrated Holy Salts
3790:1:4:35:Consecrated Relic Parchment
282423:1:12:1:Consecrated Scroll
2682:1:0:10:Cooked Crab Claw
13927:1:0:45:Cooked Glossy Mightfish
279957:1:0:28:Cookie's Feast
2845:1:2:9:Copper Axe
2840:1:7:10:Copper Bar
3488:2:2:13:Copper Battle Axe
2853:1:4:7:Copper Bracers
2851:2:4:11:Copper Chain Belt
3469:2:4:10:Copper Chain Boots
2852:2:4:10:Copper Chain Pants
3471:2:4:10:Copper Chain Vest
7955:2:2:11:Copper Claymore
7166:2:2:11:Copper Dagger
2844:1:2:9:Copper Mace
4363:1:7:13:Copper Modulator
2770:1:7:10:Copper Ore
6217:1:7:5:Copper Rod
2847:2:2:10:Copper Shortsword
4361:1:7:10:Copper Tube
5000:2:4:26:Coral Band
18251:3:0:60:Core Armor Kit
21342:4:1:60:Core Felcloth Bag
17012:1:7:60:Core Leather
18282:4:2:65:Core Marksman Rifle
7075:1:7:45:Core of Earth
22527:1:12:1:Core of Elements
19162:4:4:70:Corehound Belt
16982:4:4:59:Corehound Boots
205863:1:15:1:Corrupted Libram
4056:1:12:35:Cortello's Riddle
15939:2:4:59:Councillor's Scepter
2673:1:7:10:Coyote Meat
2684:1:0:15:Coyote Steak
2683:1:0:15:Crab Cake
2122:1:4:5:Cracked Leather Belt
2123:1:4:5:Cracked Leather Boots
2124:1:4:5:Cracked Leather Bracers
2125:1:4:5:Cracked Leather Gloves
2126:1:4:5:Cracked Leather Pants
2127:1:4:5:Cracked Leather Vest
1352:1:12:22:Cracked Skull Mortar
8068:1:6:20:Crafted Heavy Shot
8067:1:6:10:Crafted Light Shot
8069:1:6:35:Crafted Solid Shot
4393:2:4:37:Craftsman's Monocle
22625:1:12:60:Craftsman's Writ - Baked Salmon
22609:1:12:60:Craftsman's Writ - Brightcloth Pants
22600:1:12:60:Craftsman's Writ - Dense Weightstone
22621:1:12:60:Craftsman's Writ - Flask of Petrification
22615:1:12:60:Craftsman's Writ - Gnomish Battle Chicken
22613:1:12:60:Craftsman's Writ - Goblin Sapper Charge
22620:1:12:60:Craftsman's Writ - Greater Arcane Protection Potion
22619:1:12:60:Craftsman's Writ - Greater Frost Protection Potion
22603:1:12:60:Craftsman's Writ - Huge Thorium Battleaxe
22601:1:12:60:Craftsman's Writ - Imperial Plate Chest
22624:1:12:60:Craftsman's Writ - Lightning Eel
22618:1:12:60:Craftsman's Writ - Major Healing Potion
22617:1:12:60:Craftsman's Writ - Major Mana Potion
22623:1:12:60:Craftsman's Writ - Plated Armorfish
22604:1:12:60:Craftsman's Writ - Radiant Circlet
22606:1:12:60:Craftsman's Writ - Rugged Armor Kit
22611:1:12:60:Craftsman's Writ - Runecloth Bag
22610:1:12:60:Craftsman's Writ - Runecloth Boots
22612:1:12:60:Craftsman's Writ - Runecloth Robe
22608:1:12:60:Craftsman's Writ - Runic Leather Pants
22626:1:12:60:Craftsman's Writ - Runn Tum Tuber Surprise
22622:1:12:60:Craftsman's Writ - Stonescale Eel
22614:1:12:60:Craftsman's Writ - Thorium Grenade
22616:1:12:60:Craftsman's Writ - Thorium Tube
22602:1:12:60:Craftsman's Writ - Volcanic Hammer
22607:1:12:60:Craftsman's Writ - Wicked Leather Belt
22605:1:12:60:Craftsman's Writ - Wicked Leather Headband
264081:3:0:1:Craftsman's Writ: Advanced Target Dummy
264132:3:0:1:Craftsman's Writ: Arcanite Skeleton Key
264049:3:0:1:Craftsman's Writ: Azure Silk Hood
264045:3:0:1:Craftsman's Writ: Barbaric Gloves
264036:3:0:1:Craftsman's Writ: Big Bronze Bomb
264027:3:0:1:Craftsman's Writ: Big Bronze Knife
264100:3:0:1:Craftsman's Writ: Big Voodoo Mask
264101:3:0:1:Craftsman's Writ: Big Voodoo Robe
264110:3:0:1:Craftsman's Writ: Black Mageweave Vest
264072:3:0:1:Craftsman's Writ: Blue Glittering Axe
264048:3:0:1:Craftsman's Writ: Blue Overalls
264060:3:0:1:Craftsman's Writ: Catseye Draught
264084:3:0:1:Craftsman's Writ: Catseye Ultra Goggles
264157:3:0:1:Craftsman's Writ: Cenarion Herb Bag
264148:3:0:1:Craftsman's Writ: Chimeric Vest
264114:3:0:1:Craftsman's Writ: Cindercloth Robe
264053:3:0:1:Craftsman's Writ: Colorful Kilt
264092:3:0:1:Craftsman's Writ: Comfortable Leather Hat
264037:3:0:1:Craftsman's Writ: Crafted Solid Shot
264082:3:0:1:Craftsman's Writ: Craftsman's Monocle
264106:3:0:1:Craftsman's Writ: Crimson Silk Robe
264091:3:0:1:Craftsman's Writ: Dark Iron Bomb
264044:3:0:1:Craftsman's Writ: Dark Leather Shoulders
264041:3:0:1:Craftsman's Writ: Dark Leather Tunic
264130:3:0:1:Craftsman's Writ: Darkrune Gauntlets
264124:3:0:1:Craftsman's Writ: Distilled Firewater
264119:3:0:1:Craftsman's Writ: Draught of Detect Demon
264019:3:0:1:Craftsman's Writ: Draught of Water Breathing
264117:3:0:1:Craftsman's Writ: Dreamless Sleep Potion
264094:3:0:1:Craftsman's Writ: Dusky Bracers
264115:3:0:1:Craftsman's Writ: Earthen Silk Belt
264133:3:0:1:Craftsman's Writ: Ebon Shiv
264066:3:0:1:Craftsman's Writ: Elixir of Agility
264018:3:0:1:Craftsman's Writ: Elixir of Defense
264016:3:0:1:Craftsman's Writ: Elixir of Lesser Agility
264011:3:0:1:Craftsman's Writ: Elixir of Ogre's Strength
264012:3:0:1:Craftsman's Writ: Elixir of Wisdom
264108:3:0:1:Craftsman's Writ: Enchanted Mageweave Pouch
264030:3:0:1:Craftsman's Writ: Explosive Sheep
264156:3:0:1:Craftsman's Writ: Felcloth Boots
264139:3:0:1:Craftsman's Writ: Field Repair Bot 74A
264039:3:0:1:Craftsman's Writ: Fine Leather Pants
264087:3:0:1:Craftsman's Writ: Fire Goggles
264063:3:0:1:Craftsman's Writ: Fire Protection Potion
264086:3:0:1:Craftsman's Writ: Flash Bomb
264121:3:0:1:Craftsman's Writ: Flask of Chromatic Resistance
264015:3:0:1:Craftsman's Writ: Free Action Potion
264056:3:0:1:Craftsman's Writ: Frost Protection Potion
264151:3:0:1:Craftsman's Writ: Frostsaber Boots
264159:3:0:1:Craftsman's Writ: Ghostweave Vest
264120:3:0:1:Craftsman's Writ: Gift of Arthas
264137:3:0:1:Craftsman's Writ: Gnomish Alarm-O-Bot
264035:3:0:1:Craftsman's Writ: Gnomish Universal Remote
264138:3:0:1:Craftsman's Writ: Goblin Jumper Cables XL
264083:3:0:1:Craftsman's Writ: Goblin Land Mine
264065:3:0:1:Craftsman's Writ: Goblin Rocket Fuel
264021:3:0:1:Craftsman's Writ: Golden Rod
264074:3:0:1:Craftsman's Writ: Golden Scale Coif
264078:3:0:1:Craftsman's Writ: Golden Scale Gauntlets
264144:3:0:1:Craftsman's Writ: Gordok Ogre Suit
264061:3:0:1:Craftsman's Writ: Great Rage Potion
264054:3:0:1:Craftsman's Writ: Greater Adept's Robe
264118:3:0:1:Craftsman's Writ: Greater Fire Protection Potion
264028:3:0:1:Craftsman's Writ: Green Iron Boots
264026:3:0:1:Craftsman's Writ: Green Iron Gauntlets
264135:3:0:1:Craftsman's Writ: Green Lens
264093:3:0:1:Craftsman's Writ: Guardian Cloak
264089:3:0:1:Craftsman's Writ: Gyromatic Micro-Adjuster
264024:3:0:1:Craftsman's Writ: Heavy Bronze Mace
264038:3:0:1:Craftsman's Writ: Heavy Leather Ball
264079:3:0:1:Craftsman's Writ: Heavy Mithril Axe
264043:3:0:1:Craftsman's Writ: Heavy Quiver
264149:3:0:1:Craftsman's Writ: Heavy Scorpid Helm
264040:3:0:1:Craftsman's Writ: Herbalist's Gloves
264131:3:0:1:Craftsman's Writ: Huge Thorium Battleaxe
264129:3:0:1:Craftsman's Writ: Imperial Plate Chest
264069:3:0:1:Craftsman's Writ: Inlaid Mithril Cylinder
264022:3:0:1:Craftsman's Writ: Iridescent Hammer
264057:3:0:1:Craftsman's Writ: Lesser Invisibility Potion
264013:3:0:1:Craftsman's Writ: Lesser Mana Potion
264058:3:0:1:Craftsman's Writ: Lesser Stoneshield Potion
264017:3:0:1:Craftsman's Writ: Lesser Troll's Blood Elixir
264047:3:0:1:Craftsman's Writ: Lesser Wizard's Robe
264136:3:0:1:Craftsman's Writ: Lifelike Mechanical Toad
264122:3:0:1:Craftsman's Writ: Limited Invulnerability Potion
264104:3:0:1:Craftsman's Writ: Mageweave Bag
264123:3:0:1:Craftsman's Writ: Major Rejuvenation Potion
264062:3:0:1:Craftsman's Writ: Mana Potion
264134:3:0:1:Craftsman's Writ: Masterwork Target Dummy
264080:3:0:1:Craftsman's Writ: Mechanical Dragonling
264090:3:0:1:Craftsman's Writ: Mechanical Repair Kit
264032:3:0:1:Craftsman's Writ: Minor Recombobulator
264088:3:0:1:Craftsman's Writ: Mithril Frag Bomb
264128:3:0:1:Craftsman's Writ: Mithril Spurs
264031:3:0:1:Craftsman's Writ: Moonsight Rifle
264073:3:0:1:Craftsman's Writ: Moonsteel Broadsword
264059:3:0:1:Craftsman's Writ: Nature Protection Potion
264099:3:0:1:Craftsman's Writ: Nightscape Shoulders
264112:3:0:1:Craftsman's Writ: Orange Martial Shirt
264127:3:0:1:Craftsman's Writ: Orcish War Leggings
264071:3:0:1:Craftsman's Writ: Ornate Mithril Shoulders
264029:3:0:1:Craftsman's Writ: Ornate Spyglass
264020:3:0:1:Craftsman's Writ: Pearl-Handled Dagger
264051:3:0:1:Craftsman's Writ: Phoenix Pants
264042:3:0:1:Craftsman's Writ: Pilferer's Gloves
264116:3:0:1:Craftsman's Writ: Potion of Demonslaying
264033:3:0:1:Craftsman's Writ: Practice Lock
264097:3:0:1:Craftsman's Writ: Quickdraw Quiver
264126:3:0:1:Craftsman's Writ: Radiant Belt
264125:3:0:1:Craftsman's Writ: Radiant Circlet
264111:3:0:1:Craftsman's Writ: Red Mageweave Pants
264046:3:0:1:Craftsman's Writ: Red Whelp Gloves
264052:3:0:1:Craftsman's Writ: Red Woolen Boots
264025:3:0:1:Craftsman's Writ: Rough Bronze Leggings
264153:3:0:1:Craftsman's Writ: Runecloth Bag
264154:3:0:1:Craftsman's Writ: Runecloth Boots
264150:3:0:1:Craftsman's Writ: Runic Leather Bracers
264146:3:0:1:Craftsman's Writ: Runic Leather Headband
264034:3:0:1:Craftsman's Writ: Shadow Goggles
264064:3:0:1:Craftsman's Writ: Shadow Oil
264014:3:0:1:Craftsman's Writ: Shadow Protection Potion
264105:3:0:1:Craftsman's Writ: Shadoweave Gloves
264158:3:0:1:Craftsman's Writ: Shadoweave Mask
264107:3:0:1:Craftsman's Writ: Shadoweave Robe
264023:3:0:1:Craftsman's Writ: Silver Skeleton Key
264050:3:0:1:Craftsman's Writ: Small Silk Pack
264141:3:0:1:Craftsman's Writ: Sniper Scope
264075:3:0:1:Craftsman's Writ: Solid Sharpening Stone
264160:3:0:1:Craftsman's Writ: Soul Pouch
264055:3:0:1:Craftsman's Writ: Spider Silk Slippers
264109:3:0:1:Craftsman's Writ: Star Belt
264068:3:0:1:Craftsman's Writ: Steel Plate Helm
264070:3:0:1:Craftsman's Writ: Steel Weapon Chain
264098:3:0:1:Craftsman's Writ: Swift Boots
264103:3:0:1:Craftsman's Writ: Thick Leather Ammo Pouch
264142:3:0:1:Craftsman's Writ: Tranquil Mechanical Yeti
264077:3:0:1:Craftsman's Writ: Truesilver Rod
264140:3:0:1:Craftsman's Writ: Truesilver Transformer
264102:3:0:1:Craftsman's Writ: Turtle Scale Breastplate
264155:3:0:1:Craftsman's Writ: Tuxedo Jacket
264085:3:0:1:Craftsman's Writ: Unstable Trigger
264145:3:0:1:Craftsman's Writ: Volcanic Breastplate
264113:3:0:1:Craftsman's Writ: White Bandit Mask
264147:3:0:1:Craftsman's Writ: Wicked Leather Bracers
264143:3:0:1:Craftsman's Writ: Wicked Leather Pants
264076:3:0:1:Craftsman's Writ: Wicked Mithril Blade
264095:3:0:1:Craftsman's Writ: Wild Leather Helmet
264096:3:0:1:Craftsman's Writ: Wild Leather Shoulders
264067:3:0:1:Craftsman's Writ: Wildvine Potion
264152:3:0:1:Craftsman's Writ: Wizardweave Turban
2886:1:7:5:Crag Boar Rib
2675:1:7:13:Crawler Claw
2674:1:7:13:Crawler Meat
2896:1:15:34:Creeping Anguish
2895:1:15:22:Creeping Pain
2927:1:15:40:Creeping Torment
2522:1:2:35:Crescent Axe
20416:1:12:1:Crest of Beckoning: Fire
20419:1:12:1:Crest of Beckoning: Stone
20418:1:12:1:Crest of Beckoning: Thunder
20420:1:12:1:Crest of Beckoning: Water
2451:1:4:50:Crested Heater Shield
4481:1:0:35:Cresting Charm
239148:4:1:1:Crimson Dawnwoven Bag
7055:2:4:35:Crimson Silk Belt
7056:2:4:36:Crimson Silk Cloak
7064:2:4:42:Crimson Silk Gloves
7062:2:4:39:Crimson Silk Pantaloons
7063:2:4:41:Crimson Silk Robe
7059:2:4:38:Crimson Silk Shoulders
7058:2:4:37:Crimson Silk Vest
10392:1:15:30:Crimson Snake
3775:1:0:20:Crippling Poison
3776:1:0:50:Crippling Poison II
1081:1:7:15:Crisp Spider Meat
252031:1:0:5:Crisp Spring Water
12224:1:0:10:Crispy Bat Wing
5479:1:0:15:Crispy Lizard Tail
3664:1:0:25:Crocolisk Gumbo
2924:1:7:14:Crocolisk Meat
3662:1:0:15:Crocolisk Steak
1388:1:2:3:Crooked Staff
4405:1:0:12:Crude Scope
3111:1:2:3:Crude Throwing Axe
247883:2:7:10:Crude Wax Effigy
282419:1:12:1:Crumpled Note
19306:1:0:45:Crunchy Frog
239147:3:1:1:Crusader's Knapsack
13303:1:13:1:Crusaders' Square Postbox Key
22525:1:12:1:Crypt Fiend Parts
1703:1:0:35:Crystal Basilisk Spine
23684:1:0:60:Crystal Infused Bandage
20862:2:12:1:Crystal Scarab
8925:1:7:35:Crystal Vial
19960:1:12:1:Crystalized Honey
10839:1:15:1:Crystallized Note
10840:1:15:1:Crystallized Note
7341:1:4:20:Cubic Zirconia Ring
2492:1:2:7:Cudgel
9360:1:0:1:Cuergo's Gold
9361:1:0:1:Cuergo's Gold with Worm
9265:2:12:45:Cuergo's Hidden Treasure
9254:1:12:40:Cuergo's Treasure Map
2142:1:4:27:Cuirboulli Belt
2143:1:4:27:Cuirboulli Boots
2144:1:4:27:Cuirboulli Bracers
2145:1:4:27:Cuirboulli Gloves
2146:1:4:27:Cuirboulli Pants
2141:1:4:27:Cuirboulli Vest
4599:1:0:45:Cured Ham Steak
4236:1:7:30:Cured Heavy Hide
236:1:4:22:Cured Leather Armor
1849:1:4:22:Cured Leather Belt
238:1:4:22:Cured Leather Boots
1850:1:4:22:Cured Leather Bracers
239:1:4:22:Cured Leather Gloves
237:1:4:22:Cured Leather Pants
4231:1:7:10:Cured Light Hide
4233:1:7:20:Cured Medium Hide
15407:1:7:50:Cured Rugged Hide
8172:1:7:40:Cured Thick Hide
3665:1:0:25:Curiously Tasty Omelet
23022:1:15:1:Curmudgeon's Payoff
851:1:2:15:Cutlass
203726:2:0:1:Cutty's Rune
21194:3:1:62:D'Sak's Big Sack
21193:3:1:62:D'Sak's Sack
21195:3:1:62:D'Sak's Sacktastic
21313:3:1:62:D'Sak's Small bag
922:1:2:26:Dacian Falx
414:1:0:15:Dalaran Sharp
5110:1:4:18:Dalaran Wizard's Robe
280399:1:2:2:Damaged Scimitar
12248:2:2:34:Daring Dirk
12003:1:0:55:Dark Dwarven Lager
13896:1:4:30:Dark Green Wedding Hanbok
11325:1:0:1:Dark Iron Ale Mug
11371:1:7:50:Dark Iron Bar
16005:1:0:57:Dark Iron Bomb
20039:4:4:70:Dark Iron Boots
17014:4:4:59:Dark Iron Bracers
17016:3:2:65:Dark Iron Destroyer
19164:4:4:70:Dark Iron Gauntlets
19148:4:4:66:Dark Iron Helm
5108:1:4:32:Dark Iron Leather
17013:4:4:60:Dark Iron Leggings
11606:2:4:56:Dark Iron Mail
210138:1:0:1:Dark Iron Ordinance
11099:1:7:55:Dark Iron Ore
11370:1:7:50:Dark Iron Ore
11608:3:2:55:Dark Iron Pulverizer
17015:3:2:65:Dark Iron Reaver
18945:1:12:1:Dark Iron Residue
16004:3:2:55:Dark Iron Rifle
22528:1:12:1:Dark Iron Scraps
11605:2:4:58:Dark Iron Shoulders
11607:3:2:57:Dark Iron Sunderer
11197:1:13:1:Dark Keeper Key
4249:2:4:25:Dark Leather Belt
2316:2:4:22:Dark Leather Cloak
4248:2:4:26:Dark Leather Gloves
5961:2:4:23:Dark Leather Pants
4252:2:4:28:Dark Leather Shoulders
2317:2:4:20:Dark Leather Tunic
6490:1:12:1:Dark Parchment
20520:2:7:55:Dark Rune
4333:1:4:31:Dark Silk Shirt
265839:4:15:60:Dark Skeletal Horse
10822:1:15:30:Dark Whelpling
232436:1:0:55:Darkclaw Bisque
13888:1:7:55:Darkclaw Lobster
15980:2:4:46:Darkmist Orb
19223:1:0:5:Darkmoon Dog
19295:1:4:20:Darkmoon Flower
19221:1:0:1:Darkmoon Special Reserve
19291:1:1:45:Darkmoon Storage Box
20550:3:4:63:Darkrune Breastplate
20549:3:4:63:Darkrune Gauntlets
20551:3:4:63:Darkrune Helm
12238:1:0:15:Darkshore Grouper
19693:3:4:65:Darksoul Breastplate
19694:3:4:65:Darksoul Leggings
19695:3:4:65:Darksoul Shoulders
12802:3:2:60:Darkspear
2070:1:0:5:Darnassian Bleu
22133:1:15:1:Darnassus Gift Collection
21030:1:0:45:Darnassus Kimchi Pie
22290:1:15:1:Darnassus Pledge Collection
252483:4:4:61:Dawn Armor
19052:3:4:58:Dawn Treaders
12774:3:2:55:Dawn's Edge
4033:1:4:50:Dawn's Glow
12625:3:4:58:Dawnbringer Shoulders
7944:2:2:48:Dazzling Mithril Rapier
4369:2:2:21:Deadly Blunderbuss
3490:2:2:25:Deadly Bronze Poniard
2892:1:0:30:Deadly Poison
2893:1:0:38:Deadly Poison II
8984:1:0:46:Deadly Poison III
8985:1:0:54:Deadly Poison IV
20844:1:0:60:Deadly Poison V
10546:1:0:42:Deadly Scope
3137:1:2:27:Deadly Throwing Axe
3295:1:2:3:Deadman Blade
3293:1:2:3:Deadman Cleaver
3294:1:2:3:Deadman Club
3296:1:2:3:Deadman Dagger
5172:1:15:30:Death Capsule
248822:2:7:60:Death Lotus
5173:1:15:30:Deathweed
216880:1:0:40:Deciphered Troll Scroll
5107:1:4:14:Deckhand's Shirt
20405:1:12:1:Decoded Tablet Transcription
20541:1:12:1:Decoded Twilight Text
20545:1:12:1:Decoded Twilight Text
20552:1:12:1:Decoded Twilight Text
20676:1:12:1:Decoded Twilight Text
20677:1:12:1:Decoded Twilight Text
20678:1:12:1:Decoded Twilight Text
20679:1:12:1:Decoded Twilight Text
19225:1:0:55:Deep Fried Candybar
8953:1:0:55:Deep Fried Plantains
10506:2:4:46:Deepdive Helmet
8150:1:7:40:Deeprock Salt
17119:1:0:15:Deeprun Rat Kabob
208607:1:0:1:Deer Musk
9311:1:0:1:Default Stationery
6579:1:4:24:Defender Spaulders
1077:2:4:26:Defias Mage Ring
16006:1:7:58:Delicate Arcanite Converter
4607:1:0:35:Delicious Cave Mold
3536:1:4:1:Demon Hunter Blindfold
16583:1:15:60:Demonic Figurine
248821:1:7:60:Demonsage
15992:1:7:50:Dense Blasting Powder
18641:1:0:45:Dense Dynamite
12644:1:7:45:Dense Grinding Stone
232433:1:0:70:Dense Runecloth Bandage
12404:1:0:45:Dense Sharpening Stone
11305:2:2:35:Dense Shortbow
12365:1:7:45:Dense Stone
12643:1:0:45:Dense Weightstone
1166:1:4:5:Dented Buckler
17183:1:4:3:Dented Buckler
6351:1:15:15:Dented Crate
279263:4:4:65:Depleted Thorium Sabatons
901:1:15:1:Deptecated White Stallion Summoning (Mount)
13330:1:1:1:Dereks Radish Bag
6496:1:12:1:Detailed Parchment
6522:1:0:15:Deviate Fish
6470:1:7:1:Deviate Scale
6468:3:4:23:Deviate Scale Belt
6466:2:4:18:Deviate Scale Cloak
6467:2:4:21:Deviate Scale Gloves
15063:3:4:58:Devilsaur Gauntlets
15417:1:7:50:Devilsaur Leather
15062:3:4:60:Devilsaur Leggings
2194:3:2:25:Diamond Hammer
23578:1:0:59:Diet McWeaksauce
5051:1:12:1:Dig Rat
5478:1:0:25:Dig Rat Stew
6182:1:4:10:Dim Torch
18984:2:15:55:Dimensional Ripper - Everlook
260823:2:15:60:Dimensional Transporter - Mt. Hyjal
21023:1:0:55:Dirge's Kickin' Chimaerok Chops
2139:1:2:3:Dirk
1835:1:4:5:Dirty Leather Belt
210:1:4:5:Dirty Leather Boots
1836:1:4:5:Dirty Leather Bracers
714:1:4:5:Dirty Leather Gloves
209:1:4:5:Dirty Leather Pants
85:1:4:5:Dirty Leather Vest
7351:1:4:11:Disciple's Boots
7350:1:4:10:Disciple's Bracers
6514:1:4:10:Disciple's Cloak
6515:1:4:11:Disciple's Gloves
6513:1:4:10:Disciple's Sash
15932:2:4:12:Disciple's Stein
241652:1:7:1:Discolored Beast Heart
247240:1:0:22:Discolored Healing Potion
4388:1:0:32:Discombobulator Ray
20769:1:15:55:Disgusting Oozeling
246948:1:0:45:Distilled Firewater
274041:1:15:1:Document Box
12778:1:12:1:Document Chest
927:1:2:24:Double Axe
2499:1:2:9:Double-bladed Axe
2613:1:4:13:Double-Stitched Robes
4314:2:4:22:Double-Stitched Woolen Shoulders
12284:1:12:1:Draco-Incarcinatrix 900
12217:1:0:35:Dragonbreath Chili
250953:1:0:45:Dragonfire Potion
8367:3:4:51:Dragonscale Breastplate
8347:3:4:45:Dragonscale Gauntlets
8685:1:12:1:Dran's Ripple Delivery
9233:1:0:50:Draught of Detect Demon
3828:1:0:39:Draught of Detect Lesser Invisibility
9154:1:0:46:Draught of Detect Undead
9197:1:0:48:Draught of Dream Vision
18294:1:0:45:Draught of Greater Water Breathing
5996:1:0:18:Draught of Water Breathing
8827:1:0:34:Draught of Water Walking
11176:1:7:45:Dream Dust
221470:3:12:1:Dream Emerald
219446:1:15:40:Dream-Infused Dragonscale
219402:1:15:25:Dream-Touched Dragonscale
249234:2:2:48:Dreambough Wand
4829:2:4:29:Dreamer's Belt
13463:1:7:54:Dreamfoil
12190:1:0:45:Dreamless Sleep Potion
219444:1:15:40:Dreamroot
20381:2:7:63:Dreamscale
20380:4:4:68:Dreamscale Breastplate
10041:3:4:50:Dreamweave Circlet
10019:3:4:45:Dreamweave Gloves
10021:3:4:45:Dreamweave Vest
6836:1:4:1:Dress Shoes
8948:1:0:55:Dried King Bolete
7094:1:2:10:Driftwood Branch
2687:1:0:15:Dry Pork Ribs
1384:1:2:3:Dull Blade
1201:1:4:10:Dull Heater Shield
208192:1:15:1:Dun Morogh Pig Meat
221289:4:15:1:Dunes Deck
14390:1:4:1:Durability Belt
14384:1:4:1:Durability Boots
14394:1:2:1:Durability Bow
14383:1:4:1:Durability Bracers
14382:1:4:1:Durability Chestpiece
14385:1:4:1:Durability Cloak
14387:1:4:1:Durability Gloves
14386:1:4:1:Durability Hat
14388:1:4:1:Durability Leggings
14393:1:4:1:Durability Shield
14389:3:4:1:Durability Shoulderpads
14392:1:2:1:Durability Staff
14391:1:2:1:Durability Sword
15935:2:4:34:Durable Rod
207590:1:15:1:Durotar Pig Meat
5211:1:2:25:Dusk Wand
15936:2:4:55:Duskwoven Branch
7387:2:4:39:Dusky Belt
7390:2:4:40:Dusky Boots
7378:2:4:37:Dusky Bracers
7374:2:4:35:Dusky Leather Armor
7373:2:4:33:Dusky Leather Leggings
2928:1:15:20:Dust of Decay
8924:1:15:30:Dust of Deterioration
22173:1:15:1:Dwarven Homebrew
422:1:0:25:Dwarven Mild
269502:2:4:58:Dwarven Plate
280803:1:15:30:Eagle Owl
7352:2:4:27:Earthen Leather Shoulders
253999:2:4:35:Earthen Leggings
7061:2:4:39:Earthen Silk Belt
254019:2:4:40:Earthen Silk Cuffs
254017:2:4:39:Earthen Silk Gloves
254015:2:4:37:Earthen Silk Hood
254033:2:4:41:Earthen Silk Shoulders
254013:2:4:36:Earthen Silk Slippers
7051:2:4:34:Earthen Vest
254093:2:4:54:Earthenweave Boots
254077:2:4:52:Earthenweave Cord
254137:2:4:61:Earthenweave Crown
254131:2:4:60:Earthenweave Cuffs
254075:2:4:52:Earthenweave Gloves
254125:2:4:58:Earthenweave Leggings
254119:2:4:57:Earthenweave Mantle
254121:2:4:59:Earthenweave Vest
2449:1:7:5:Earthroot
288900:4:2:30:Earthshaker
7809:1:4:30:Easter Dress
19170:4:2:70:Ebon Hand
7947:2:2:51:Ebon Shiv
17704:2:2:38:Edge of Winter
17198:1:0:10:Egg Nog
12286:1:12:1:Eggscilloscope Prototype
19236:3:12:1:Eight of Beasts
221297:3:15:1:Eight of Dunes
19275:3:12:1:Eight of Elementals
221306:3:15:1:Eight of Nightmares
221288:3:15:1:Eight of Plagues
19284:3:12:1:Eight of Portals
19265:3:12:1:Eight of Warlords
221279:3:15:1:Eight of Wilds
6620:1:12:1:Elaborate Parchment
7609:2:4:35:Elder's Amber Stave
13305:1:13:1:Elders' Square Postbox Key
279254:4:4:65:Elderwild Pants
279252:4:4:65:Elderwild Waistcord
15940:2:4:62:Elegant Scepter
7069:1:7:25:Elemental Air
7067:1:7:25:Elemental Earth
7068:1:7:25:Elemental Fire
18567:1:7:60:Elemental Flux
213558:1:12:1:Elemental Salve
18262:2:0:60:Elemental Sharpening Stone
7070:1:7:25:Elemental Water
19267:4:12:1:Elementals Deck
235276:4:15:1:Elementals Deck
17771:5:7:60:Elementium Bar
18562:4:7:60:Elementium Ore
4835:2:4:30:Elite Shoulders
8949:1:0:37:Elixir of Agility
13453:1:0:55:Elixir of Brute Force
210708:1:0:25:Elixir of Coalesced Regret
250328:1:0:55:Elixir of Cunning
8951:1:0:39:Elixir of Defense
289334:1:0:30:Elixir of Endless Experience
289329:1:0:30:Elixir of Endless Growth
289084:1:0:30:Elixir of Endless Healing
289082:1:0:30:Elixir of Endless Intellect
289321:1:0:30:Elixir of Endless Mana
289087:1:0:30:Elixir of Endless Opportunity
289083:1:0:30:Elixir of Endless Power
289086:1:0:30:Elixir of Endless Rapidity
250350:1:0:55:Elixir of Ferocity
6373:1:0:28:Elixir of Fire Power
250334:1:0:45:Elixir of Fortitude
17708:1:0:38:Elixir of Frost Power
6662:1:0:18:Elixir of Giant Growth
9187:1:0:48:Elixir of Greater Agility
13445:1:0:53:Elixir of Greater Defense
250335:1:0:55:Elixir of Greater Fortitude
9179:1:0:47:Elixir of Greater Intellect
250347:1:0:55:Elixir of Greater Spirit
9206:1:0:48:Elixir of Greater Strength
21546:1:0:50:Elixir of Holy Power
250354:1:0:45:Elixir of Intellect
3390:1:0:28:Elixir of Lesser Agility
3389:1:0:26:Elixir of Lesser Defense
3825:1:0:35:Elixir of Lesser Fortitude
250353:1:0:25:Elixir of Lesser Intellect
250345:1:0:25:Elixir of Lesser Spirit
2457:1:0:12:Elixir of Minor Agility
5997:1:0:5:Elixir of Minor Defense
247755:1:0:5:Elixir of Minor Force
2458:1:0:12:Elixir of Minor Fortitude
250344:1:0:5:Elixir of Minor Spirit
2454:1:0:5:Elixir of Minor Strength
250343:1:0:55:Elixir of Nature Power
3391:1:0:30:Elixir of Ogre Strength
250338:1:0:55:Elixir of Sages
9264:1:0:50:Elixir of Shadow Power
250346:1:0:45:Elixir of Spirit
250349:1:0:45:Elixir of Strength
250351:1:0:55:Elixir of the Grizzly
13452:1:0:56:Elixir of the Mongoose
250337:1:0:55:Elixir of the Owl
250329:1:0:55:Elixir of the Phalanx
13447:1:0:44:Elixir of the Sages
250348:1:0:55:Elixir of the Whale
250336:1:0:55:Elixir of Wicked Regeneration
3383:1:0:20:Elixir of Wisdom
15968:2:4:64:Elunarian Sphere
21536:1:15:1:Elune Stone
21713:1:0:1:Elune's Candle
269501:2:4:60:Elven Chain Wristguards
15979:2:4:42:Embersilk Stave
2309:2:4:15:Embossed Leather Boots
2310:2:4:13:Embossed Leather Cloak
4239:2:4:13:Embossed Leather Gloves
4242:2:4:15:Embossed Leather Pants
2300:2:4:12:Embossed Leather Vest
2435:1:4:50:Embroidered Armor
3587:1:4:50:Embroidered Belt
2438:1:4:50:Embroidered Boots
3588:1:4:50:Embroidered Bracers
2440:1:4:50:Embroidered Gloves
3892:1:4:50:Embroidered Hat
2437:1:4:50:Embroidered Pants
21173:1:15:1:Empty Festive Mug
21174:1:15:1:Empty Festive Mug
5229:1:0:38:Empty Greater Bloodstone
5223:1:0:28:Empty Mana Gem
5227:1:0:37:Empty Mana Jewel
5406:1:0:1:Empty Minor Bloodstone
3371:1:7:1:Empty Vial
21830:1:15:1:Empty Wrapper
269681:3:15:40:Empyrean Galestrider
4765:2:2:14:Enamelled Broadsword
273589:1:0:1:Enchant 2H Weapon - Agility
273608:1:0:1:Enchant 2H Weapon - Grand Arcanist
273610:1:0:1:Enchant 2H Weapon - Grand Inquisitor
273538:1:0:1:Enchant 2H Weapon - Greater Impact
273515:1:0:1:Enchant 2H Weapon - Impact
273617:1:0:1:Enchant 2H Weapon - Lesser Agility
273489:1:0:1:Enchant 2H Weapon - Lesser Impact
273474:1:0:1:Enchant 2H Weapon - Lesser Intellect
273481:1:0:1:Enchant 2H Weapon - Lesser Spirit
273618:1:0:1:Enchant 2H Weapon - Lesser Strength
273568:1:0:1:Enchant 2H Weapon - Major Intellect
273567:1:0:1:Enchant 2H Weapon - Major Spirit
273622:1:0:1:Enchant 2H Weapon - Mighty Healing Power
273621:1:0:1:Enchant 2H Weapon - Mighty Spell Power
273465:1:0:1:Enchant 2H Weapon - Minor Impact
273601:1:0:1:Enchant 2H Weapon - Spellblasting
273562:1:0:1:Enchant 2H Weapon - Superior Impact
273537:1:0:1:Enchant Boots - Agility
273556:1:0:1:Enchant Boots - Greater Agility
273555:1:0:1:Enchant Boots - Greater Stamina
273500:1:0:1:Enchant Boots - Lesser Agility
273512:1:0:1:Enchant Boots - Lesser Spirit
273503:1:0:1:Enchant Boots - Lesser Stamina
273479:1:0:1:Enchant Boots - Minor Agility
273530:1:0:1:Enchant Boots - Minor Speed
273478:1:0:1:Enchant Boots - Minor Stamina
289559:1:0:1:Enchant Boots - Speed
273557:1:0:1:Enchant Boots - Spirit
273523:1:0:1:Enchant Boots - Stamina
273597:1:0:1:Enchant Bracer - Agility
273614:1:0:1:Enchant Bracer - Agility
273535:1:0:1:Enchant Bracer - Deflection
273616:1:0:1:Enchant Bracer - Greater Agility
273545:1:0:1:Enchant Bracer - Greater Intellect
273606:1:0:1:Enchant Bracer - Greater Spellpower
273525:1:0:1:Enchant Bracer - Greater Spirit
273542:1:0:1:Enchant Bracer - Greater Stamina
273539:1:0:1:Enchant Bracer - Greater Strength
273575:1:0:1:Enchant Bracer - Healing Power
273458:1:0:1:Enchant Bracer - Inferior Stamina
273522:1:0:1:Enchant Bracer - Intellect
273613:1:0:1:Enchant Bracer - Lesser Agility
273504:1:0:1:Enchant Bracer - Lesser Deflection
273615:1:0:1:Enchant Bracer - Lesser Healing Power
273496:1:0:1:Enchant Bracer - Lesser Intellect
273476:1:0:1:Enchant Bracer - Lesser Spirit
273486:1:0:1:Enchant Bracer - Lesser Stamina
273574:1:0:1:Enchant Bracer - Mana Regeneration
273470:1:0:1:Enchant Bracer - Minor Agility
273461:1:0:1:Enchant Bracer - Minor Deflect
273612:1:0:1:Enchant Bracer - Minor Healing Power
273611:1:0:1:Enchant Bracer - Minor Intellect
273467:1:0:1:Enchant Bracer - Minor Spirit
273464:1:0:1:Enchant Bracer - Minor Stamina
273471:1:0:1:Enchant Bracer - Minor Strength
273596:1:0:1:Enchant Bracer - Spell Power
273502:1:0:1:Enchant Bracer - Spirit
273505:1:0:1:Enchant Bracer - Stamina
273510:1:0:1:Enchant Bracer - Strength
273620:1:0:1:Enchant Bracer - Superior Agility
273626:1:0:1:Enchant Bracer - Superior Deflection
273625:1:0:1:Enchant Bracer - Superior Intellect
273546:1:0:1:Enchant Bracer - Superior Spirit
273548:1:0:1:Enchant Bracer - Superior Stamina
273547:1:0:1:Enchant Bracer - Superior Strength
273635:1:0:1:Enchant Chest - Absorption
273511:1:0:1:Enchant Chest - Greater Intellect
273501:1:0:1:Enchant Chest - Greater Stamina
273558:1:0:1:Enchant Chest - Greater Stats
273459:1:0:1:Enchant Chest - Inferior Stamina
273492:1:0:1:Enchant Chest - Intellect
273491:1:0:1:Enchant Chest - Lesser Absorption
273469:1:0:1:Enchant Chest - Lesser Intellect
273466:1:0:1:Enchant Chest - Lesser Stamina
273517:1:0:1:Enchant Chest - Lesser Stats
273593:1:0:1:Enchant Chest - Living Stats
273560:1:0:1:Enchant Chest - Major Intellect
273559:1:0:1:Enchant Chest - Major Stamina
273460:1:0:1:Enchant Chest - Minor Absorption
273462:1:0:1:Enchant Chest - Minor Intellect
273497:1:0:1:Enchant Chest - Minor Stats
273591:1:0:1:Enchant Chest - Retricutioner
273475:1:0:1:Enchant Chest - Stamina
273540:1:0:1:Enchant Chest - Stats
273534:1:0:1:Enchant Chest - Superior Intellect
273526:1:0:1:Enchant Chest - Superior Stamina
273604:1:0:1:Enchant Cloak - Agility
273499:1:0:1:Enchant Cloak - Defense
273588:1:0:1:Enchant Cloak - Dodge
273508:1:0:1:Enchant Cloak - Fire Resistance
273518:1:0:1:Enchant Cloak - Greater Defense
273584:1:0:1:Enchant Cloak - Greater Fire Resistance
273585:1:0:1:Enchant Cloak - Greater Nature Resistance
273551:1:0:1:Enchant Cloak - Greater Resistance
273528:1:0:1:Enchant Cloak - Lesser Agility
273477:1:0:1:Enchant Cloak - Lesser Fire Resistance
273483:1:0:1:Enchant Cloak - Lesser Protection
273488:1:0:1:Enchant Cloak - Lesser Shadow Resistance
273482:1:0:1:Enchant Cloak - Minor Agility
273468:1:0:1:Enchant Cloak - Minor Protection
273463:1:0:1:Enchant Cloak - Minor Resistance
273519:1:0:1:Enchant Cloak - Resistance
273586:1:0:1:Enchant Cloak - Stealth
273587:1:0:1:Enchant Cloak - Subtlety
273552:1:0:1:Enchant Cloak - Superior Defense
273527:1:0:1:Enchant Gloves - Advanced Herbalism
273524:1:0:1:Enchant Gloves - Advanced Mining
273619:1:0:1:Enchant Gloves - Advanced Skinning
273520:1:0:1:Enchant Gloves - Agility
273595:1:0:1:Enchant Gloves - Arcane Power
273581:1:0:1:Enchant Gloves - Fire Power
273495:1:0:1:Enchant Gloves - Fishing
273580:1:0:1:Enchant Gloves - Frost Power
273549:1:0:1:Enchant Gloves - Greater Agility
273550:1:0:1:Enchant Gloves - Greater Strength
273582:1:0:1:Enchant Gloves - Healing Power
273494:1:0:1:Enchant Gloves - Herbalism
273594:1:0:1:Enchant Gloves - Holy Power
274426:1:0:1:Enchant Gloves - Lotus Claw
273493:1:0:1:Enchant Gloves - Mining
273544:1:0:1:Enchant Gloves - Minor Haste
273624:1:0:1:Enchant Gloves - Natural Power
273543:1:0:1:Enchant Gloves - Riding Skill
273579:1:0:1:Enchant Gloves - Shadow Power
273516:1:0:1:Enchant Gloves - Skinning
273529:1:0:1:Enchant Gloves - Strength
273583:1:0:1:Enchant Gloves - Superior Agility
273623:1:0:1:Enchant Gloves - Superior Strength
273578:1:0:1:Enchant Gloves - Threat
273633:1:0:1:Enchant Necklace - Agility
273634:1:0:1:Enchant Necklace - Deflection
273632:1:0:1:Enchant Necklace - Healing Power
273631:1:0:1:Enchant Necklace - Spell Power
273630:1:0:1:Enchant Necklace - Strength
273599:1:0:1:Enchant Off-Hand - Excellent Spirit
273598:1:0:1:Enchant Off-Hand - Superior Intellect
273600:1:0:1:Enchant Off-Hand - Wisdom
273605:1:0:1:Enchant Shield - Critical Strike
273602:1:0:1:Enchant Shield - Excellent Stamina
273536:1:0:1:Enchant Shield - Frost Resistance
273532:1:0:1:Enchant Shield - Greater Spirit
273554:1:0:1:Enchant Shield - Greater Stamina
273592:1:0:1:Enchant Shield - Law of Nature
273513:1:0:1:Enchant Shield - Lesser Block
273484:1:0:1:Enchant Shield - Lesser Protection
273485:1:0:1:Enchant Shield - Lesser Spirit
273498:1:0:1:Enchant Shield - Lesser Stamina
273480:1:0:1:Enchant Shield - Minor Stamina
273509:1:0:1:Enchant Shield - Spirit
273521:1:0:1:Enchant Shield - Stamina
273553:1:0:1:Enchant Shield - Superior Spirit
273573:1:0:1:Enchant Weapon - Agility
273566:1:0:1:Enchant Weapon - Crusader
273533:1:0:1:Enchant Weapon - Demonslaying
273590:1:0:1:Enchant Weapon - Dismantle
273531:1:0:1:Enchant Weapon - Fiery Weapon
273607:1:0:1:Enchant Weapon - Grand Crusader
273609:1:0:1:Enchant Weapon - Grand Sorcerer
273541:1:0:1:Enchant Weapon - Greater Striking
273571:1:0:1:Enchant Weapon - Healing Power
273561:1:0:1:Enchant Weapon - Icy Chill
273627:1:0:1:Enchant Weapon - Insight
273506:1:0:1:Enchant Weapon - Lesser Beastslayer
273507:1:0:1:Enchant Weapon - Lesser Elemental Slayer
273487:1:0:1:Enchant Weapon - Lesser Striking
273564:1:0:1:Enchant Weapon - Lifestealing
273577:1:0:1:Enchant Weapon - Mighty Intellect
273576:1:0:1:Enchant Weapon - Mighty Spirit
273472:1:0:1:Enchant Weapon - Minor Beastslayer
273473:1:0:1:Enchant Weapon - Minor Striking
273628:1:0:1:Enchant Weapon - Recovery
273629:1:0:1:Enchant Weapon - Revelation
273570:1:0:1:Enchant Weapon - Spell Power
273572:1:0:1:Enchant Weapon - Strength
273514:1:0:1:Enchant Weapon - Striking
273563:1:0:1:Enchant Weapon - Superior Striking
273565:1:0:1:Enchant Weapon - Unholy Weapon
273569:1:0:1:Enchant Weapon - Winter's Might
12776:3:2:56:Enchanted Battlehammer
12810:1:7:55:Enchanted Leather
279976:1:0:4:Enchanted Lute
22246:2:1:45:Enchanted Mageweave Pouch
22248:2:1:55:Enchanted Runecloth Bag
4639:1:12:1:Enchanted Sea Kelp
12655:1:7:55:Enchanted Thorium Bar
12618:3:4:63:Enchanted Thorium Breastplate
12620:3:4:62:Enchanted Thorium Helm
12619:3:4:63:Enchanted Thorium Leggings
18769:3:12:60:Enchanted Thorium Platemail
18770:3:12:60:Enchanted Thorium Platemail
18771:3:12:60:Enchanted Thorium Platemail
4791:1:0:35:Enchanted Water
4322:2:4:33:Enchanter's Cowl
215458:1:15:1:Enclosed Message
215459:1:15:1:Enclosed Message
215460:1:15:1:Enclosed Message
10647:1:7:50:Engineer's Ink
11199:1:4:1:Engineer's Shield 1
11200:1:4:1:Engineer's Shield 2
11201:1:4:1:Engineer's Shield 3
13724:1:0:55:Enriched Manna Biscuit
2024:1:2:21:Espadon
8923:1:15:50:Essence of Agony
7082:2:7:55:Essence of Air
273129:2:15:60:Essence of Anarchy
7076:2:7:55:Essence of Earth
7078:2:7:55:Essence of Fire
257348:3:5:60:Essence of Innovation
2930:1:15:22:Essence of Pain
12808:2:7:55:Essence of Undeath
7080:2:7:55:Essence of Water
15989:2:4:65:Eternal Rod
279255:4:4:65:Eternity Pauldrons
5760:2:15:60:Eternium Lockbox
279262:4:4:65:Evergreen Shield
18287:1:0:1:Evermurky
11404:1:12:1:Evil Bat Eye
11242:1:12:1:Evoroot
275682:1:15:1:Excitable Slime
8444:1:0:1:Executioner's Key
4818:2:2:24:Executioner's Sword
7066:1:4:27:Exotic Silk Dress
279974:1:0:40:Expert Campfire Kit
16072:1:9:30:Expert Cookbook
16084:1:9:30:Expert First Aid - Under Wraps
16083:1:9:30:Expert Fishing - The Bass and You
268912:1:0:15:Expiring Crab Cake
268913:1:0:15:Expiring Crocolisk Steak
3465:2:6:36:Exploding Shot
10579:3:6:42:Explosive Arrow
1178:1:0:8:Explosive Rocket
4384:1:0:30:Explosive Sheep
5105:1:15:20:Explosive Shell
239017:2:7:1:Exquisite Spices
260821:2:4:60:EZ and SAF Field Transporter: Mt. Hyjal
260802:1:4:39:EZ-Thro Bronze Mortar
260795:1:0:31:EZ-Thro Copper Bomb XL
260817:1:0:60:EZ-Thro Dark Bomb
6714:1:0:25:Ez-Thro Dynamite
18588:1:0:40:Ez-Thro Dynamite II
260819:2:4:60:EZ-Thro Field Transporter: Gadgetzan
260801:1:7:39:EZ-Thro Fireproof Fuse
260803:1:0:40:EZ-Thro Grenade
260829:2:4:60:EZ-Thro Magnetic Displacer
260818:1:0:60:EZ-Thro Mana Bomb
260815:1:7:57:EZ-Thro Shell
260816:1:0:57:EZ-Thro Thorium Grenade
260808:1:7:48:EZ-Thro Tru-Trigger
260794:1:7:15:EZ-Thro Wrap
13307:1:13:1:Ezra Grimm's Postbox Key
279972:1:0:4:Faction Banner
279973:1:0:4:Faction Banner
11108:1:12:1:Faded Photograph
3818:1:7:32:Fadeleaf
213369:3:7:40:Faintly Glowing Leather
2528:1:2:46:Falchion
13843:1:15:25:Fall/Winter Afternoon
13844:1:15:25:Fall/Winter Evening
13842:1:15:25:Fall/Winter Morning
13845:1:15:25:Fall/Winter Night
3335:1:2:6:Farmer's Broom
11937:1:15:1:Fat Sack of Coins
4190:1:4:27:Feathered Armor
3464:2:6:35:Feathered Arrow
4195:1:4:27:Feathered Boots
4194:1:4:27:Feathered Bracers
8349:3:4:50:Feathered Breastplate
4196:3:4:30:Feathered Mantle
279269:4:4:65:Fel Cape
248819:2:7:60:Fel Crystal
21939:1:12:1:Fel Elemental Rod
248824:1:7:60:Fel Hide
248825:1:7:60:Fel Leather
277533:1:15:1:Fel Tainted Journal
249695:1:12:1:Fel-Tainted Flesh
279271:4:1:65:Felblood Soul Bag
14256:1:7:50:Felcloth
21341:3:1:57:Felcloth Bag
14108:2:4:57:Felcloth Boots
18407:3:4:62:Felcloth Gloves
14111:2:4:58:Felcloth Hood
14107:2:4:55:Felcloth Pants
14106:2:4:61:Felcloth Robe
14112:2:4:62:Felcloth Shoulders
12445:1:12:1:Felnok's Package
4766:2:2:13:Feral Blade
15313:1:4:24:Feral Shoulder Pads
279970:1:0:28:Fermenter
5013:1:0:15:Fertile Bulb
21154:1:4:1:Festival Dress
21747:1:15:1:Festival Firecracker
13304:1:13:1:Festival Lane Postbox Key
20908:1:15:1:Festival of Nian Firework
21542:1:4:1:Festival Suit
279969:1:0:28:Field Guide
18232:1:0:60:Field Repair Bot 74A
16989:4:4:59:Fiery Chain Girdle
16988:4:4:62:Fiery Chain Shoulders
4797:2:4:25:Fiery Cloak
17010:3:7:60:Fiery Core
18942:1:12:1:Fiery Flux
12631:3:4:58:Fiery Plate Gauntlets
238638:1:0:65:Filet o' Flank
13930:1:0:45:Filet of Redgill
21171:1:15:1:Filled Festive Mug
5476:1:0:15:Fillet of Frenzy
3927:1:0:45:Fine Aged Cheddar
4246:2:4:16:Fine Leather Belt
2307:2:4:18:Fine Leather Boots
2308:2:4:15:Fine Leather Cloak
2312:2:4:15:Fine Leather Gloves
5958:2:4:21:Fine Leather Pants
4243:2:4:17:Fine Leather Tunic
15808:1:2:21:Fine Light Crossbow
11304:2:2:19:Fine Longbow
4560:1:2:6:Fine Scimitar
11303:2:2:16:Fine Shortbow
2321:1:7:20:Fine Thread
6202:2:4:13:Fingerless Gloves
10500:2:4:41:Fire Goggles
6371:1:7:25:Fire Oil
6049:1:0:33:Fire Protection Potion
189421:1:15:1:Fire Resist Leather Gear
189419:1:15:1:Fire Resist Plate Gear
189420:1:15:1:Fire Resist Plate Gear
997:1:2:1:Fire Sword of Crippling
4625:1:7:41:Firebloom
6359:1:7:25:Firefin Snapper
4836:2:4:28:Fireproof Orb
21569:1:15:1:Firework Launcher
279968:1:0:4:First Aid Kit
279967:1:0:4:Fish Bowl
17058:1:15:1:Fish Oil
279966:1:0:60:Fishing Hut
6256:1:2:1:Fishing Pole
279965:1:0:28:Fishing Rack
217017:1:15:1:Fishing Tournament!
5066:1:0:15:Fissure Plant
19233:3:12:1:Five of Beasts
221294:3:15:1:Five of Dunes
19272:3:12:1:Five of Elementals
221303:3:15:1:Five of Nightmares
221285:3:15:1:Five of Plagues
19281:3:12:1:Five of Portals
19262:3:12:1:Five of Warlords
221276:3:15:1:Five of Wilds
19299:1:0:25:Fizzy Faire Drink
2594:1:0:25:Flagon of Dwarven Honeymead
925:1:2:25:Flail
2521:1:2:36:Flamberge
4376:1:0:25:Flame Deflector
282080:2:4:57:Flame Seared Signet
766:1:2:7:Flanged Mace
250069:1:0:55:Flank au Poivre
16979:4:4:62:Flarecore Gloves
19165:4:4:70:Flarecore Leggings
16980:4:4:61:Flarecore Mantle
19156:4:4:66:Flarecore Robe
18263:4:4:64:Flarecore Wraps
4852:1:0:37:Flash Bomb
4960:1:6:7:Flash Pellet
5140:1:15:20:Flash Powder
8152:1:7:40:Flask of Big Mojo
13513:1:0:60:Flask of Chromatic Resistance
13511:1:0:60:Flask of Distilled Wisdom
8151:1:7:40:Flask of Mojo
274273:2:0:60:Flask of Natural Accuracy
274274:2:0:60:Flask of Natural Aggression
274275:2:0:60:Flask of Natural Precision
274276:2:0:60:Flask of Natural Swiftness
814:1:7:1:Flask of Oil
13506:1:0:60:Flask of Petrification
2593:1:0:15:Flask of Stormwind Tawny
13512:1:0:60:Flask of Supreme Power
13510:1:0:60:Flask of the Titans
16007:3:2:61:Flawless Arcanite Rifle
7340:1:4:50:Flawless Diamond Solitaire
8244:3:12:1:Flawless Draenethyst Sphere
7307:1:0:30:Flesh Eating Worm
7348:2:4:25:Fletcher's Gloves
4471:1:7:5:Flint and Tinder
4368:2:4:20:Flying Tiger Goggles
282420:1:12:1:Folded Parchment
219445:2:15:40:Fool's Gold Dust
49:1:4:1:Footpad's Shirt
47:1:4:1:Footpad's Shoes
20009:1:12:1:For the Light!
18168:4:4:65:Force Reactive Disk
252453:2:0:30:Forceful Heavy Armor Kit
252437:2:0:15:Forceful Medium Armor Kit
252488:2:0:50:Forceful Rugged Armor Kit
252463:2:0:40:Forceful Thick Armor Kit
279260:4:2:65:Forest Defender's Axe
4604:1:0:5:Forest Mushroom Cap
208086:1:15:1:Forged Scarlet Memorandum
13895:1:4:60:Formal Dangui
4334:1:4:34:Formal White Shirt
6349:1:9:20:Formula: Enchant 2H Weapon - Lesser Intellect
11038:2:9:22:Formula: Enchant 2H Weapon - Lesser Spirit
16249:2:9:60:Formula: Enchant 2H Weapon - Major Intellect
16255:2:9:62:Formula: Enchant 2H Weapon - Major Spirit
16247:2:9:59:Formula: Enchant 2H Weapon - Superior Impact
16245:2:9:59:Formula: Enchant Boots - Greater Agility
16215:2:9:52:Formula: Enchant Boots - Greater Stamina
11167:2:9:38:Formula: Enchant Boots - Lesser Spirit
6377:2:9:25:Formula: Enchant Boots - Minor Agility
6376:2:9:25:Formula: Enchant Boots - Minor Stamina
289560:2:9:50:Formula: Enchant Boots - Speed
16220:2:9:55:Formula: Enchant Boots - Spirit
11223:2:9:47:Formula: Enchant Bracer - Deflection
16214:2:9:51:Formula: Enchant Bracer - Greater Intellect
11204:2:9:44:Formula: Enchant Bracer - Greater Spirit
11225:2:9:49:Formula: Enchant Bracer - Greater Stamina
6375:2:9:24:Formula: Enchant Bracer - Lesser Spirit
11101:2:9:28:Formula: Enchant Bracer - Lesser Strength
6344:2:9:17:Formula: Enchant Bracer - Minor Spirit
6347:2:9:19:Formula: Enchant Bracer - Minor Strength
16218:2:9:54:Formula: Enchant Bracer - Superior Spirit
16251:2:9:60:Formula: Enchant Bracer - Superior Stamina
16246:2:9:59:Formula: Enchant Bracer - Superior Strength
16253:2:9:62:Formula: Enchant Chest - Greater Stats
6346:2:9:19:Formula: Enchant Chest - Lesser Intellect
16242:2:9:58:Formula: Enchant Chest - Major Intellect
16221:1:9:55:Formula: Enchant Chest - Major Stamina
6342:2:9:12:Formula: Enchant Chest - Minor Intellect
16216:2:9:53:Formula: Enchant Cloak - Greater Resistance
11206:2:9:45:Formula: Enchant Cloak - Lesser Agility
11098:2:9:27:Formula: Enchant Cloak - Lesser Shadow Resistance
16224:1:9:57:Formula: Enchant Cloak - Superior Defense
11205:2:9:45:Formula: Enchant Gloves - Advanced Herbalism
11203:2:9:43:Formula: Enchant Gloves - Advanced Mining
11152:2:9:29:Formula: Enchant Gloves - Fishing
16219:2:9:54:Formula: Enchant Gloves - Greater Agility
16244:2:9:59:Formula: Enchant Gloves - Greater Strength
11151:2:9:29:Formula: Enchant Gloves - Herbalism
11150:2:9:29:Formula: Enchant Gloves - Mining
11226:2:9:50:Formula: Enchant Gloves - Riding Skill
11166:2:9:40:Formula: Enchant Gloves - Skinning
11224:2:9:47:Formula: Enchant Shield - Frost Resistance
11168:2:9:39:Formula: Enchant Shield - Lesser Block
11081:2:9:22:Formula: Enchant Shield - Lesser Protection
11202:2:9:42:Formula: Enchant Shield - Stamina
16222:2:9:56:Formula: Enchant Shield - Superior Spirit
16252:2:9:61:Formula: Enchant Weapon - Crusader
11208:2:9:46:Formula: Enchant Weapon - Demonslaying
11207:2:9:53:Formula: Enchant Weapon - Fiery Weapon
16223:2:9:57:Formula: Enchant Weapon - Icy Chill
11164:2:9:35:Formula: Enchant Weapon - Lesser Beastslayer
11165:2:9:35:Formula: Enchant Weapon - Lesser Elemental Slayer
16254:3:9:62:Formula: Enchant Weapon - Lifestealing
6348:2:9:20:Formula: Enchant Weapon - Minor Beastslayer
16250:2:9:60:Formula: Enchant Weapon - Superior Striking
16248:2:9:59:Formula: Enchant Weapon - Unholy Weapon
17725:2:9:38:Formula: Enchant Weapon - Winter's Might
6222:2:9:12:Formula: Imbue Chest - Minor Spirit
6343:2:9:14:Formula: Imbue Chest - Spirit
6345:2:9:18:Formula: Imbue Cloak - Protection
20754:1:9:50:Formula: Lesser Mana Oil
20753:1:9:40:Formula: Lesser Wizard Oil
20752:1:9:30:Formula: Minor Mana Oil
20758:1:9:15:Formula: Minor Wizard Oil
8547:2:9:50:Formula: Powerful Smelling Salts
223163:2:9:15:Formula: Scroll of Spatial Mending
11813:2:9:53:Formula: Smoking Heart of the Mountain
20755:1:9:55:Formula: Wizard Oil
19232:3:12:1:Four of Beasts
221293:3:15:1:Four of Dunes
19271:3:12:1:Four of Elementals
221302:3:15:1:Four of Nightmares
221284:3:15:1:Four of Plagues
19280:3:12:1:Four of Portals
19261:3:12:1:Four of Warlords
221275:3:15:1:Four of Wilds
279450:2:15:1:Fractured Insignia
2530:1:2:46:Francisca
5634:1:0:30:Free Action Potion
250940:1:0:55:Frenzy Potion
252028:1:0:5:Fresh Gustberry Bread
4541:1:0:15:Freshly Baked Bread
22175:1:15:1:Freshly Baked Pie
22177:1:15:1:Freshly Picked Flowers
210410:1:15:1:Freshwater Snapper Bait
249399:2:7:25:Frilled Lichen
6807:1:0:35:Frog Leg Stew
21142:1:15:1:From the Desk of Lord Victor Nefarius
7377:2:4:36:Frost Leather Cloak
3829:1:0:40:Frost Oil
6050:1:0:38:Frost Protection Potion
13329:4:15:60:Frost Ram
18363:3:12:60:Frost Shock and You
3854:2:2:40:Frost Tiger Blade
5024:1:15:15:Frost Vial
2067:1:2:10:Frostbit Staff
12797:3:2:63:Frostguard
2109:1:4:5:Frostmane Chain Vest
2259:1:2:8:Frostmane Club
2260:1:2:9:Frostmane Hand Axe
2108:1:4:4:Frostmane Leather Vest
2258:1:2:8:Frostmane Shortsword
2257:1:2:10:Frostmane Staff
12436:1:12:1:Frostmaul E'ko
15071:2:4:55:Frostsaber Boots
12430:1:12:1:Frostsaber E'ko
15070:2:4:59:Frostsaber Gloves
15422:1:7:50:Frostsaber Leather
15069:2:4:57:Frostsaber Leggings
15068:2:4:62:Frostsaber Tunic
13870:2:4:53:Frostweave Gloves
13871:2:4:56:Frostweave Pants
13868:2:4:51:Frostweave Robe
13869:2:4:51:Frostweave Tunic
22682:3:7:80:Frozen Rune
278120:1:0:35:Fruit Platter
1072:1:0:25:Full Moonshine
7191:1:7:26:Fused Wiring
22660:3:4:70:Gaea's Embrace
15983:2:4:52:Gaea's Scepter
280615:1:15:20:Galestrider Chick
252022:1:0:5:Galestrider Jerky
267474:1:0:5:Galeswept Forestshroom
260625:1:0:45:Garnished Rice Cake
18356:3:12:60:Garona: A Study on Stealth and Treachery
8346:3:4:46:Gauntlets of the Sea
4262:3:4:37:Gem-studded Leather Belt
3474:2:4:15:Gemmed Copper Gauntlets
15978:2:4:41:Geomancer's Rod
6244:1:0:1:ggggfg
9210:1:7:49:Ghost Dye
8845:1:7:47:Ghost Mushroom
3323:2:4:10:Ghostly Bracers
14143:2:4:53:Ghostweave Belt
254129:2:4:60:Ghostweave Boots
254073:2:4:52:Ghostweave Cord
14142:2:4:54:Ghostweave Gloves
254135:2:4:61:Ghostweave Hood
254127:2:4:59:Ghostweave Mantle
14144:2:4:58:Ghostweave Pants
14141:2:4:55:Ghostweave Vest
4655:1:7:35:Giant Clam Meat
6038:1:0:35:Giant Clam Scorcho
16792:2:2:37:Giant Club
12207:1:7:45:Giant Egg
1197:1:2:15:Giant Mace
250078:1:0:35:Giant Scrambled Eggs
21979:1:15:1:Gift of Adoration: Darnassus
21980:1:15:1:Gift of Adoration: Ironforge
22164:1:15:1:Gift of Adoration: Orgrimmar
21981:1:15:1:Gift of Adoration: Stormwind
22165:1:15:1:Gift of Adoration: Thunder Bluff
22166:1:15:1:Gift of Adoration: Undercity
9088:1:0:48:Gift of Arthas
22167:1:15:1:Gift of Friendship: Darnassus
22168:1:15:1:Gift of Friendship: Ironforge
22169:1:15:1:Gift of Friendship: Orgrimmar
22170:1:15:1:Gift of Friendship: Stormwind
22171:1:15:1:Gift of Friendship: Thunder Bluff
22172:1:15:1:Gift of Friendship: Undercity
254021:3:4:40:Gilded Handwraps
17197:1:0:10:Gingerbread Cookie
18504:3:4:62:Girdle of Insight
19051:3:4:58:Girdle of the Dawn
22658:4:4:80:Glacial Cloak
22654:4:4:80:Glacial Gloves
22652:4:4:80:Glacial Vest
22655:4:4:80:Glacial Wrists
208760:1:0:1:Glade Crown
208609:1:0:1:Glade Flower
2488:1:2:9:Gladius
15326:1:2:40:Gleaming Throwing Axe
12259:2:2:36:Glinting Steel Dagger
7079:1:7:45:Globe of Water
5209:1:2:21:Gloom Wand
4833:2:4:28:Glorious Shoulders
4318:2:4:26:Gloves of Meditation
14146:4:4:62:Gloves of Spell Mastery
19057:3:4:61:Gloves of the Dawn
17721:2:4:38:Gloves of the Greatfather
282416:1:12:1:Glowing Recall Crystal
19933:1:15:1:Glowing Scorpid Blood
2030:1:2:20:Gnarled Staff
208749:1:13:1:Gnarlpine Stash Key
7740:1:12:1:Gni'kiv Medallion
204906:1:15:1:Gnoll Blood
3233:1:1:15:Gnoll Hide Sack
1213:1:4:14:Gnoll Kindred Bracers
5916:1:13:1:Gnome Camera Key
20337:1:0:1:Gnome Head on a Stick
215430:1:7:40:Gnomeregan Fallout
18645:1:0:53:Gnomish Alarm-O-Bot
260811:1:7:50:Gnomish Army Knife
4397:1:4:40:Gnomish Cloaking Device
10721:2:4:43:Gnomish Harm Prevention Belt
10726:2:4:47:Gnomish Mind Control Cap
10720:1:4:42:Gnomish Net-o-Matic Projector
10724:2:4:45:Gnomish Rocket Boots
10716:1:4:41:Gnomish Shrink Ray
7506:2:4:25:Gnomish Universal Remote
5937:1:13:1:Goblin Camera Key
5527:1:0:25:Goblin Deviled Clams
7148:1:4:33:Goblin Jumper Cables
18587:1:4:53:Goblin Jumper Cables XL
4395:1:0:39:Goblin Land Mine
10577:1:4:41:Goblin Mortar
7189:2:4:45:Goblin Rocket Boots
9061:1:7:42:Goblin Rocket Fuel
10588:2:4:47:Goblin Rocket Helmet
10646:1:0:41:Goblin Sapper Charge
3577:2:7:30:Gold Bar
19715:3:12:61:Gold Hakkari Bijou
272016:1:15:60:Gold Nugget
2776:2:7:25:Gold Ore
10558:1:7:30:Gold Power Core
272001:2:15:60:Gold Ring
20859:2:12:1:Gold Scarab
3852:2:2:34:Golden Iron Destroyer
19058:3:4:61:Golden Mantle of the Dawn
13926:2:7:40:Golden Pearl
11128:1:7:30:Golden Rod
13464:1:7:52:Golden Sansam
3847:2:4:40:Golden Scale Boots
6040:2:4:37:Golden Scale Bracers
3837:2:4:38:Golden Scale Coif
3845:2:4:40:Golden Scale Cuirass
9366:2:4:41:Golden Scale Gauntlets
217273:2:4:41:Golden Scale Gauntlets
3843:2:4:34:Golden Scale Leggings
3841:2:4:35:Golden Scale Shoulders
15870:2:0:30:Golden Skeleton Key
272000:3:15:60:Golden Statue
4539:1:0:35:Goldenbark Apple
3821:1:7:34:Goldthorn
10841:1:0:35:Goldthorn Tea
273127:2:15:60:Golem Heart
255007:1:7:1:Golem Isospring
3666:1:0:25:Gooey Spider Cake
2251:1:7:25:Gooey Spider Leg
18258:2:12:55:Gordok Ogre Suit
275622:3:4:58:Goregasher Grips
275624:3:4:58:Goregasher Stompers
275623:3:4:58:Goregasher Support
209059:1:15:1:Goretusk Haunch
723:1:7:12:Goretusk Liver
724:1:0:15:Goretusk Liver Pie
731:1:7:12:Goretusk Snout
2799:1:12:1:Gorilla Fang
17407:1:0:35:Graccu's Homemade Meat Pie
238642:2:0:65:Grand Lobster Banquet
3369:1:7:24:Grave Moss
4340:1:7:25:Gray Dye
3321:1:4:9:Gray Fur Booties
15277:3:15:40:Gray Kodo
2315:2:4:20:Gray Leather Boots
3542:1:4:1:Gray Leather D02 Boots
3546:1:4:1:Gray Leather D02 Bracers
3538:1:4:1:Gray Leather D02 Breastplate
5864:3:15:40:Gray Ram
17964:2:15:1:Gray Sack of Gems
2585:2:4:21:Gray Woolen Robe
2587:1:4:20:Gray Woolen Shirt
2531:1:2:44:Great Axe
18794:4:15:60:Great Brown Kodo
18795:4:15:60:Great Gray Kodo
8500:1:15:30:Great Horned Owl
5633:1:0:35:Great Rage Potion
18793:4:15:60:Great White Kodo
6264:2:4:23:Greater Adept's Robe
13454:1:0:57:Greater Arcane Elixir
13461:1:0:58:Greater Arcane Protection Potion
11082:2:7:25:Greater Astral Essence
250333:1:0:55:Greater Cleric's Elixir
19296:2:0:50:Greater Darkmoon Prize
247241:1:0:31:Greater Discolored Healing Potion
20002:1:0:60:Greater Dreamless Sleep Potion
16203:2:7:55:Greater Eternal Essence
249237:2:2:60:Greater Eternal Wand
13457:1:0:58:Greater Fire Protection Potion
250941:1:0:45:Greater Frenzy Potion
13456:1:0:58:Greater Frost Protection Potion
1710:1:0:31:Greater Healing Potion
5510:1:0:46:Greater Healthstone
19010:1:0:46:Greater Healthstone
19011:1:0:46:Greater Healthstone
13460:1:0:58:Greater Holy Protection Potion
250341:1:0:55:Greater Mageblood Elixir
10939:2:7:15:Greater Magic Essence
11288:2:2:23:Greater Magic Wand
6149:1:0:41:Greater Mana Potion
250947:1:0:25:Greater Mender's Potion
219515:2:15:50:Greater Moonstone
11135:2:7:35:Greater Mystic Essence
217287:2:2:35:Greater Mystic Wand
13458:1:0:58:Greater Nature Protection Potion
11175:2:7:45:Greater Nether Essence
21762:1:13:1:Greater Scarab Coffer Key
13459:1:0:58:Greater Shadow Protection Potion
250935:1:0:55:Greater Spellblasting Potion
13455:1:0:56:Greater Stoneshield Potion
17402:1:0:35:Greatfather's Winter Ale
19055:1:15:20:Green Dragon Orb
15412:1:7:50:Green Dragonscale
15045:3:4:52:Green Dragonscale Breastplate
20296:3:4:56:Green Dragonscale Gauntlets
15046:3:4:54:Green Dragonscale Leggings
2605:1:7:15:Green Dye
9313:1:0:20:Green Firework
288337:1:0:20:Green Firework
17405:1:15:35:Green Garden Tea
19711:3:12:61:Green Hakkari Bijou
21301:1:15:1:Green Helper Box
2725:1:12:1:Green Hills of Stranglethorn - Page 1
2734:1:12:1:Green Hills of Stranglethorn - Page 10
2735:1:12:1:Green Hills of Stranglethorn - Page 11
2738:1:12:1:Green Hills of Stranglethorn - Page 14
2740:1:12:1:Green Hills of Stranglethorn - Page 16
2742:1:12:1:Green Hills of Stranglethorn - Page 18
2744:1:12:1:Green Hills of Stranglethorn - Page 20
2745:1:12:1:Green Hills of Stranglethorn - Page 21
2748:1:12:1:Green Hills of Stranglethorn - Page 24
2749:1:12:1:Green Hills of Stranglethorn - Page 25
2750:1:12:1:Green Hills of Stranglethorn - Page 26
2751:1:12:1:Green Hills of Stranglethorn - Page 27
2728:1:12:1:Green Hills of Stranglethorn - Page 4
2730:1:12:1:Green Hills of Stranglethorn - Page 6
2732:1:12:1:Green Hills of Stranglethorn - Page 8
17723:1:4:40:Green Holiday Shirt
3484:2:4:29:Green Iron Boots
3835:2:4:33:Green Iron Bracers
3485:2:4:30:Green Iron Gauntlets
3844:3:4:36:Green Iron Hauberk
3836:2:4:34:Green Iron Helm
3842:2:4:31:Green Iron Leggings
3840:2:4:32:Green Iron Shoulders
15292:4:15:60:Green Kodo
4255:2:4:31:Green Leather Armor
5573:1:1:15:Green Leather Bag
4257:2:4:32:Green Leather Belt
4259:2:4:36:Green Leather Bracers
10504:3:4:49:Green Lens
4308:2:4:12:Green Linen Bracers
2579:1:4:14:Green Linen Shirt
13321:3:15:40:Green Mechanostrider
11185:1:12:1:Green Power Crystal
17305:1:0:5:Green Ribboned Holiday Gift
17304:1:0:5:Green Ribboned Wrapping Paper
21574:1:15:1:Green Rocket Cluster
17963:2:15:1:Green Sack of Gems
7065:2:4:33:Green Silk Armor
5764:1:1:25:Green Silk Pack
7057:2:4:36:Green Silken Shoulders
265838:4:15:60:Green Skeletal Horse
13334:4:15:60:Green Skeletal Warhorse
1401:1:0:14:Green Tea Leaf
4385:2:4:30:Green Tinted Goggles
13900:1:4:40:Green Wedding Hanbok
7375:2:4:35:Green Whelp Armor
7386:2:4:38:Green Whelp Bracers
7392:1:7:1:Green Whelp Scale
34087:1:4:1:Green Winter Clothes
4241:1:1:15:Green Woolen Bag
6243:2:4:18:Green Woolen Robe
2582:2:4:17:Green Woolen Vest
279261:4:2:65:Greenhammer
279964:1:0:28:Greenhouse
9769:2:4:27:Greenweave Branch
9681:1:0:45:Grilled King Crawler Legs
13928:1:0:45:Grilled Squid
11444:1:0:55:Grim Guzzler Boar
11602:1:13:1:Grim Guzzler Key
9308:1:12:1:Grime-Encrusted Object
213427:2:15:40:Grime-Encrusted Salvage
11818:1:12:43:Grimesilt Outhouse Key
1228:1:9:6:Grimoire of Blood Boil
3140:1:9:18:Grimoire of Blood Boil II
4220:1:9:30:Grimoire of Blood Boil III
3143:1:9:6:Grimoire of Burning Spirit
3144:1:9:16:Grimoire of Burning Spirit II
3146:1:9:28:Grimoire of Burning Spirit III
4219:1:9:40:Grimoire of Burning Spirit IV
9192:1:9:4:Grimoire of Corruption
9201:1:9:16:Grimoire of Corruption II
9216:1:9:28:Grimoire of Corruption III
9231:1:9:40:Grimoire of Corruption IV
21283:3:9:60:Grimoire of Corruption VII
4218:1:9:26:Grimoire of Create Bloodstone
9207:1:9:24:Grimoire of Create Bloodstone II
9228:1:9:36:Grimoire of Create Bloodstone III
5726:1:9:38:Grimoire of Create Greater Bloodstone
4210:1:9:14:Grimoire of Create Lesser Bloodstone
1229:1:9:18:Grimoire of Create Soulstone
5721:1:9:34:Grimoire of Create Spellstone
1681:1:9:16:Grimoire of Cripple
9194:1:9:8:Grimoire of Curse of Agony
9205:1:9:20:Grimoire of Curse of Agony II
9221:1:9:32:Grimoire of Curse of Agony III
4207:1:9:30:Grimoire of Curse of Archimonde
3134:1:9:4:Grimoire of Curse of Mannoroth
5720:1:9:20:Grimoire of Curse of Mannoroth II
4212:1:9:32:Grimoire of Curse of Mannoroth III
9199:1:9:12:Grimoire of Curse of Recklessness
9211:1:9:26:Grimoire of Curse of Recklessness II
9230:1:9:40:Grimoire of Curse of Recklessness III
3142:1:9:10:Grimoire of Curse of Sargeras
4206:1:9:24:Grimoire of Curse of Sargeras II
5723:1:9:36:Grimoire of Curse of Sargeras III
9222:1:9:32:Grimoire of Curse of the Elements
5724:1:9:22:Grimoire of Curse of Tongues
9191:1:9:4:Grimoire of Curse of Weakness
9200:1:9:14:Grimoire of Curse of Weakness II
9209:1:9:24:Grimoire of Curse of Weakness III
9223:1:9:34:Grimoire of Curse of Weakness IV
1244:1:9:22:Grimoire of Demon Armor
3139:1:9:34:Grimoire of Demon Armor II
1246:1:9:16:Grimoire of Demon Breath
1232:1:9:10:Grimoire of Demon Skin II
4221:1:9:40:Grimoire of Detect Invisibility
1250:1:9:26:Grimoire of Detect Lesser Invisibility
9195:1:9:10:Grimoire of Drain Soul
9208:1:9:24:Grimoire of Drain Soul II
9227:1:9:36:Grimoire of Drain Soul III
9218:1:9:30:Grimoire of Enslave Demon
4201:1:9:28:Grimoire of Eye of Kilrogg
1238:1:9:8:Grimoire of Fear
4202:1:9:24:Grimoire of Fear II
5729:1:9:40:Grimoire of Fear III
9198:1:9:12:Grimoire of Health Funnel
9204:1:9:20:Grimoire of Health Funnel II
9215:1:9:28:Grimoire of Health Funnel III
9226:1:9:36:Grimoire of Health Funnel IV
9219:1:9:30:Grimoire of Hellfire
4216:1:9:40:Grimoire of Holy Ward
9190:1:9:1:Grimoire of Immolate
1245:1:9:10:Grimoire of Immolate II
4200:1:9:22:Grimoire of Immolate III
4205:1:9:34:Grimoire of Immolate IV
21282:3:9:60:Grimoire of Immolate VIII
3141:1:9:14:Grimoire of Life Drain
5719:1:9:22:Grimoire of Life Drain II
4214:1:9:30:Grimoire of Life Drain III
9229:1:9:36:Grimoire of Life Drain IV
9193:1:9:6:Grimoire of Life Tap
9202:1:9:18:Grimoire of Life Tap II
9217:1:9:30:Grimoire of Life Tap III
5727:1:9:40:Grimoire of Mana Funnel
4208:1:9:32:Grimoire of Mind Bomb
4211:1:9:14:Grimoire of Pestilence
4203:1:9:26:Grimoire of Pestilence II
5725:1:9:38:Grimoire of Pestilence III
4215:1:9:20:Grimoire of Rain of Fire
5728:1:9:40:Grimoire of Rain of Fire II
9203:1:9:20:Grimoire of Ritual of Summoning
1224:1:9:24:Grimoire of Sense Demons
1231:1:9:6:Grimoire of Shadow Bolt II
1243:1:9:12:Grimoire of Shadow Bolt III
3138:1:9:20:Grimoire of Shadow Bolt IV
9212:1:9:28:Grimoire of Shadow Bolt V
9225:1:9:36:Grimoire of Shadow Bolt VI
21281:3:9:60:Grimoire of Shadow Bolt X
4209:1:9:30:Grimoire of Shadow Ward
22891:3:9:60:Grimoire of Shadow Ward IV
1239:1:9:26:Grimoire of Siphon Mana
5722:1:9:36:Grimoire of Siphon Mana II
4198:1:9:12:Grimoire of Soul Funnel
4199:1:9:20:Grimoire of Soul Funnel II
4204:1:9:28:Grimoire of Soul Funnel III
4217:1:9:36:Grimoire of Soul Funnel IV
15302:1:4:11:Grizzly Belt
15297:1:4:11:Grizzly Bracers
15299:1:4:10:Grizzly Cape
15300:1:4:14:Grizzly Gloves
15301:1:4:13:Grizzly Slippers
8846:1:7:50:Gromsblood
271673:1:4:1:Grove Scoundrel's Boots
271675:1:4:1:Grove Scoundrel's Shirt
4568:2:2:21:Grunt Axe
22142:1:15:1:Grunt's Card
6525:1:4:27:Grunt's Harness
4256:2:4:35:Guardian Armor
4258:2:4:34:Guardian Belt
4820:2:4:25:Guardian Buckler
5965:2:4:37:Guardian Cloak
5966:2:4:38:Guardian Gloves
4260:2:4:39:Guardian Leather Bracers
5962:2:4:32:Guardian Pants
12809:2:7:60:Guardian Stone
22145:1:15:1:Guardian's Moldy Card
21307:3:9:60:Guide: Aspect of the Hawk VII
21304:3:9:60:Guide: Multi-Shot V
21306:3:9:60:Guide: Serpent Sting IX
5976:1:4:1:Guild Tabard
282294:1:4:1:Guild Tabard
19701:2:12:1:Gurubashi Coin
19931:3:12:1:Gurubashi Mojo Madness
252027:1:0:15:Gustberry Juice
252026:1:0:15:Gustberry Pie
4389:1:7:34:Gyrochronatom
18634:3:4:52:Gyrofreeze Ice Reflector
10498:1:7:35:Gyromatic Micro-Adjustor
10460:1:13:1:Hakkari Blood
19700:2:12:1:Hakkari Coin
4031:1:4:45:Hallowed Relic Charm
2028:1:2:21:Hammer
289292:4:2:35:Hammer of Bestial Fury
810:4:2:54:Hammer of the Northern Wind
12796:3:2:63:Hammer of the Titans
2134:1:2:4:Hand Axe
21300:3:9:60:Handbook of Backstab IX
21302:3:9:60:Handbook of Deadly Poison V
21303:3:9:60:Handbook of Feint V
3661:1:2:2:Handcrafted Staff
4359:1:7:8:Handful of Copper Bolts
22218:1:15:1:Handful of Rose Petals
21960:1:15:1:Handmade Woodcraft
7047:2:4:29:Hands of Darkness
4237:2:4:10:Handstitched Leather Belt
2302:1:4:8:Handstitched Leather Boots
7277:1:4:9:Handstitched Leather Bracers
7276:1:4:9:Handstitched Leather Cloak
2303:2:4:10:Handstitched Leather Pants
5957:2:4:10:Handstitched Leather Vest
4309:2:4:14:Handstitched Linen Britches
18640:1:0:1:Happy Fun Rock
278117:1:0:15:Hard Boiled Eggs
250534:2:4:35:Hard Gold Boots
250535:2:4:37:Hard Gold Bracers
250537:2:4:40:Hard Gold Coif
250533:2:4:34:Hard Gold Cuirass
250538:2:4:40:Hard Gold Gauntlet
250536:2:4:38:Hard Gold Leggings
250539:2:4:40:Hard Gold Pauldrons
3849:2:2:32:Hardened Iron Shortsword
21038:1:0:5:Hardpacked Snowball
5874:1:15:40:Harness: Black Ram
5875:1:15:40:Harness: Blue Ram
18360:3:12:60:Harnessing Shadows
853:1:2:16:Hatchet
2287:1:0:15:Haunch of Meat
237037:1:15:15:Haute Club Membership Card
8501:1:15:30:Hawk Owl
961:1:0:5:Healing Herb
929:1:0:22:Healing Potion
5509:1:0:34:Healthstone
19008:1:0:34:Healthstone
19009:1:0:34:Healthstone
21816:1:15:1:Heart Candy
21817:1:15:1:Heart Candy
21818:1:15:1:Heart Candy
21819:1:15:1:Heart Candy
21820:1:15:1:Heart Candy
21821:1:15:1:Heart Candy
21822:1:15:1:Heart Candy
21823:1:15:1:Heart Candy
7077:1:7:45:Heart of Fire
10286:1:7:45:Heart of the Wild
12783:3:2:63:Heartseeker
16168:1:0:45:Heaven Peach
4265:1:0:30:Heavy Armor Kit
4377:1:7:25:Heavy Blasting Powder
4633:2:15:25:Heavy Bronze Lockbox
8503:2:15:25:Heavy Bronze Lotterybox
3491:2:2:25:Heavy Bronze Mace
4497:1:1:25:Heavy Brown Bag
3487:2:2:19:Heavy Copper Broadsword
6214:2:2:16:Heavy Copper Maul
13874:1:15:45:Heavy Crate
20074:1:0:35:Heavy Crocolisk Stew
15809:1:2:34:Heavy Crossbow
288928:4:4:30:Heavy Dark Iron Ring
4378:1:0:30:Heavy Dynamite
7359:2:4:29:Heavy Earthen Gloves
3486:1:7:25:Heavy Grinding Stone
4235:1:7:30:Heavy Hide
8505:2:15:35:Heavy Iron Lotterybox
16885:1:15:50:Heavy Junkbox
12204:1:7:35:Heavy Kodo Meat
12215:1:0:35:Heavy Kodo Stew
4234:1:7:30:Heavy Leather
7372:2:11:35:Heavy Leather Ammo Pouch
18662:1:0:1:Heavy Leather Ball
2581:1:0:1:Heavy Linen Bandage
4307:2:4:10:Heavy Linen Gloves
8545:1:0:1:Heavy Mageweave Bandage
7941:2:2:42:Heavy Mithril Axe
7933:2:4:47:Heavy Mithril Boots
7930:2:4:46:Heavy Mithril Breastplate
7919:2:4:41:Heavy Mithril Gauntlet
7934:2:4:47:Heavy Mithril Helm
8507:2:15:45:Heavy Mithril Lotterybox
7921:2:4:42:Heavy Mithril Pants
7918:2:4:41:Heavy Mithril Shoulder
12257:2:4:42:Heavy Notched Belt
22197:3:4:68:Heavy Obsidian Belt
6491:1:12:1:Heavy Parchment
2448:1:4:37:Heavy Pavise
7371:2:11:35:Heavy Quiver
3027:1:2:25:Heavy Recurve Bow
14530:1:0:58:Heavy Runecloth Bandage
4798:2:4:25:Heavy Runed Cloak
15082:2:4:56:Heavy Scorpid Belt
252594:2:4:56:Heavy Scorpid Boots
15077:2:4:51:Heavy Scorpid Bracers
15078:2:4:55:Heavy Scorpid Gauntlet
15080:2:4:59:Heavy Scorpid Helm
15079:2:4:57:Heavy Scorpid Leggings
15408:1:7:55:Heavy Scorpid Scale
15081:2:4:61:Heavy Scorpid Shoulders
15076:2:4:53:Heavy Scorpid Vest
2871:1:0:25:Heavy Sharpening Stone
2519:1:6:15:Heavy Shot
20501:1:7:55:Heavy Silithid Carapace
6451:1:0:1:Heavy Silk Bandage
8343:1:7:40:Heavy Silken Thread
15811:1:2:35:Heavy Spear
4778:2:2:19:Heavy Spiked Mace
4400:1:7:25:Heavy Stock
2838:1:7:25:Heavy Stone
251291:2:7:60:Heavy Thorium Bar
279264:4:4:65:Heavy Thorium Gauntlets
248815:1:7:60:Heavy Thorium Ore
3108:1:2:27:Heavy Throwing Dagger
19043:3:4:58:Heavy Timbermaw Belt
19048:3:4:61:Heavy Timbermaw Boots
837:1:4:17:Heavy Weave Armor
3589:1:4:17:Heavy Weave Belt
3590:1:4:17:Heavy Weave Bracers
839:1:4:17:Heavy Weave Gloves
838:1:4:17:Heavy Weave Pants
840:1:4:17:Heavy Weave Shoes
3241:1:0:25:Heavy Weightstone
3531:1:0:1:Heavy Wool Bandage
4311:2:4:21:Heavy Woolen Cloak
4310:2:4:17:Heavy Woolen Gloves
4316:2:4:22:Heavy Woolen Pants
8348:3:4:50:Helm of Fire
12636:3:4:61:Helm of the Great Chief
5791:1:12:29:Henrig Lonebrow's Journal
6888:1:0:10:Herb Baked Egg
22250:2:1:20:Herb Pouch
7349:2:4:27:Herbalist's Gloves
275724:2:7:10:Hexed Pendant
10562:1:0:47:Hi-Explosive Bomb
10512:2:6:42:Hi-Impact Mithril Slugs
15937:2:4:51:Hibernal Sphere
143539:2:4:1:Hidden Belt
168664:2:4:1:Hidden Boots
168665:2:4:1:Hidden Bracers
168659:2:4:1:Hidden Chestpiece
134111:2:4:1:Hidden Cloak
158329:2:4:1:Hidden Gloves
134110:2:4:1:Hidden Helm
216696:2:4:1:Hidden Pants
142503:2:4:1:Hidden Shirt
134112:2:4:1:Hidden Shoulder
142504:2:4:1:Hidden Tabard
18510:4:4:62:Hide of the Wild
10143:2:4:64:High Councillor's Robe
15941:2:4:64:High Councillor's Scepter
15967:2:4:59:Highborne Star
4250:2:4:25:Hillman's Belt
3719:2:4:30:Hillman's Cloak
252449:2:4:27:Hillman's Leather Boots
4247:2:4:29:Hillman's Leather Gloves
4244:2:4:20:Hillman's Leather Vest
4251:2:4:26:Hillman's Shoulders
252029:1:0:15:Hippogryph Flank
23713:1:15:1:Hippogryph Hatchling
234012:1:7:60:Hive Thistle
275615:3:4:58:Hivethrasher's Boots
275613:3:4:58:Hivethrasher's Claws
275614:3:4:58:Hivethrasher's Girdle
17406:1:0:15:Holiday Cheesewheel
17194:1:15:5:Holiday Spices
17196:1:0:5:Holiday Spirits
18362:3:12:60:Holy Bologna: What the Light Won't Tell You
17028:1:15:48:Holy Candle
6051:1:0:20:Holy Protection Potion
3006:1:4:25:Holy Relic Shard
4030:1:4:45:Holy Relic Water
239016:1:7:1:Holy Salts
22176:1:15:1:Homemade Bread
8950:1:0:55:Homemade Cherry Pie
269902:1:0:1:Hoof-Shaped Foot Pedal
3184:2:2:20:Hook Dagger
1274:1:12:1:Hops
22263:1:15:1:Horde Gift Collection
12351:4:15:60:Horn of the Arctic Wolf
1041:3:15:40:Horn of the Black Wolf
5668:3:15:40:Horn of the Brown Wolf
5665:3:15:40:Horn of the Dire Wolf
1134:1:15:40:Horn of the Gray Wolf
5663:1:15:40:Horn of the Red Wolf
12330:4:15:60:Horn of the Red Wolf
8583:1:15:40:Horn of the Skeletal Mount
18796:4:15:60:Horn of the Swift Brown Wolf
18798:4:15:60:Horn of the Swift Gray Wolf
18797:4:15:60:Horn of the Swift Timber Wolf
1132:3:15:40:Horn of the Timber Wolf
1133:1:15:40:Horn of the Winter Wolf
17037:1:15:50:Hornbeam Seed
2506:1:2:8:Hornwood Recurve Bow
3727:1:0:25:Hot Lion Chops
13929:1:0:45:Hot Smoked Bass
2692:1:7:20:Hot Spices
13851:1:0:35:Hot Wolf Ribs
207973:1:15:1:Hound Jawbone
19183:1:0:1:Hourglass Sand
4499:1:1:35:Huge Brown Sack
12364:2:7:60:Huge Emerald
272015:1:15:60:Huge Quartz Gem
12775:2:2:56:Huge Thorium Battleaxe
19441:1:7:1:Huge Venom Sac
282418:1:12:1:Humming Recall Crystal
2511:1:2:14:Hunter's Boomstick
4690:1:4:13:Hunting Belt
2975:1:4:14:Hunting Boots
3207:1:4:14:Hunting Bracers
4689:1:4:13:Hunting Cloak
20367:3:15:1:Hunting Gear
8181:1:2:9:Hunting Rifle
249796:1:0:55:Hyjal Berries
18300:1:0:65:Hyjal Nectar
279273:4:2:65:Hyper Deluxe Sniper Rifle Mk XVII
18638:3:4:58:Hyper-Radiant Flame Reflector
213379:3:7:40:Hyperconductive Arcano-Filament
10384:2:4:65:Hyperion Armor
1179:1:0:15:Ice Cold Milk
4386:1:0:31:Ice Deflector
12435:1:12:1:Ice Thistle E'ko
763:2:4:12:Ice-covered Bracers
22671:4:4:80:Icebane Bracers
22669:4:4:80:Icebane Breastplate
22670:4:4:80:Icebane Gauntlets
13467:1:7:58:Icecap
7972:1:7:45:Ichor of Undeath
23227:1:12:1:iCoke Gift Box Voucher
19642:1:12:1:iCoke Prize Voucher
22822:1:12:1:iCoke Prize Voucher
13327:4:15:60:Icy Blue Mechanostrider Mod A
4327:3:4:40:Icy Cloak
22665:4:4:80:Icy Scale Bracers
22664:4:4:80:Icy Scale Breastplate
22666:4:4:80:Icy Scale Gauntlets
20876:3:12:61:Idol of Death
20879:3:12:61:Idol of Life
20875:3:12:61:Idol of Night
20878:3:12:61:Idol of Rebirth
20881:3:12:61:Idol of Strife
279250:4:4:65:Idol of Swiftness
23197:3:4:65:Idol of the Moon
20877:3:12:61:Idol of the Sage
20874:3:12:61:Idol of the Sun
279251:4:4:65:Idol of the Ursine Twins
20882:3:12:61:Idol of War
16204:1:7:55:Illusion Dust
18256:1:7:55:Imbued Vial
12586:1:0:50:Immature Venom Sac
18688:1:12:1:Imp in a Jar
10593:2:12:1:Imperfect Draenethyst Fragment
12424:2:4:53:Imperial Plate Belt
12426:2:4:59:Imperial Plate Boots
12425:2:4:54:Imperial Plate Bracers
12422:2:4:60:Imperial Plate Chest
250589:2:4:57:Imperial Plate Gauntlets
12427:2:4:59:Imperial Plate Helm
12429:2:4:61:Imperial Plate Leggings
12428:2:4:53:Imperial Plate Shoulders
15930:2:4:56:Imperial Red Scepter
3340:1:12:22:Incendicite Ore
279962:1:0:4:Incense Candle
5833:1:12:1:Indurium Ore
6509:1:4:10:Infantry Belt
6506:1:4:11:Infantry Boots
6507:1:4:10:Infantry Bracers
6508:1:4:9:Infantry Cloak
6510:1:4:11:Infantry Gauntlets
2482:1:2:3:Inferior Tomahawk
5565:1:15:55:Infernal Stone
4790:2:4:25:Inferno Cloak
18408:3:4:62:Inferno Gloves
9060:1:7:42:Inlaid Mithril Cylinder
12772:2:2:54:Inlaid Thorium Hammer
6498:1:12:1:Inscribed Kodo Leather
6499:1:12:1:Inscribed Kodo Leather
6500:1:12:1:Inscribed Kodo Leather
6501:1:12:1:Inscribed Kodo Leather
4700:1:4:21:Inscribed Leather Spaulders
6947:1:0:20:Instant Poison
6949:1:0:28:Instant Poison II
6950:1:0:36:Instant Poison III
8926:1:0:44:Instant Poison IV
8927:1:0:52:Instant Poison V
8928:1:0:60:Instant Poison VI
5654:1:15:24:Instant Toxin
9529:1:15:1:Internal Warrior Equipment Kit L25
9532:1:15:1:Internal Warrior Equipment Kit L30
9172:1:0:47:Invisibility Potion
215366:2:4:30:Invoker's Cord
215365:2:4:30:Invoker's Mantle
12641:4:4:63:Invulnerable Mail
5541:2:2:28:Iridescent Hammer
5500:2:7:25:Iridescent Pearl
3575:1:7:30:Iron Bar
21150:1:15:35:Iron Bound Trunk
7071:1:7:30:Iron Buckle
6043:1:0:33:Iron Counterweight
250604:2:2:31:Iron Fists
4390:1:0:35:Iron Grenade
4634:2:15:30:Iron Lockbox
8504:2:15:30:Iron Lotterybox
250606:2:2:38:Iron Morningstar
2772:1:7:30:Iron Ore
279982:1:0:60:Iron Oven
6042:1:0:30:Iron Shield Spike
4387:1:7:32:Iron Strut
13875:1:15:45:Ironbound Locked Chest
15420:1:7:50:Ironfeather
15066:3:4:58:Ironfeather Breastplate
252486:4:4:61:Ironfeather Leggings
15067:3:4:54:Ironfeather Shoulders
6731:2:4:20:Ironforge Breastplate
6730:2:4:16:Ironforge Chain
6733:2:4:28:Ironforge Gauntlets
22132:1:15:1:Ironforge Gift Collection
22141:1:15:1:Ironforge Guard's Card
22286:1:15:1:Ironforge Pledge Collection
12976:3:2:20:Ironpatch Blade
14227:1:7:50:Ironweb Spider Silk
279259:4:2:65:Ironwood Blade
4777:2:2:18:Ironwood Maul
17038:1:15:60:Ironwood Seed
7497:2:4:40:Ivory Band
20865:2:12:1:Ivory Scarab
9800:2:4:29:Ivy Orb
1529:2:7:35:Jade
3850:2:2:35:Jade Serpentblade
15388:2:4:52:Jadefire Belt
11285:1:6:45:Jagged Arrow
22198:4:4:70:Jagged Obsidian Shield
2207:1:2:16:Jambiya
17262:1:13:1:James' Key
20870:3:12:61:Jasper Idol
8168:1:7:45:Jet Black Feather
21308:1:15:1:Jingling Bell
279961:1:0:18:Journeyman Campfire Kit
3914:1:1:45:Journeyman's Backpack
4663:1:4:9:Journeyman's Belt
2959:1:4:9:Journeyman's Boots
3641:1:4:8:Journeyman's Bracers
4662:1:4:8:Journeyman's Cloak
2960:1:4:9:Journeyman's Gloves
15925:2:4:10:Journeyman's Stave
2595:1:0:35:Jug of Badlands Bourbon
280703:1:15:30:Jungle Boa
2633:1:0:26:Jungle Remedy
12212:1:0:45:Jungle Stew
4595:1:0:1:Junglevine Wine
5472:1:0:10:Kaldorei Spider Kabob
3107:1:2:16:Keen Throwing Knife
14661:2:4:49:Keeper's Cord
17242:1:13:1:Key to Salem's Chest
3358:1:7:37:Khadgar's Whisker
13306:1:13:1:King's Square Postbox Key
3356:1:7:24:Kingsblood
2446:1:4:27:Kite Shield
864:2:2:38:Knightly Longsword
3602:1:4:10:Knitted Belt
3603:1:4:10:Knitted Bracers
793:1:4:10:Knitted Gloves
794:1:4:10:Knitted Pants
792:1:4:10:Knitted Sandals
795:1:4:10:Knitted Tunic
5130:1:9:13:Knowledge: Dalaran Wizard Disguise
5129:1:9:22:Knowledge: Dark Iron Dwarf Disguise
5126:1:9:13:Knowledge: Defias Disguise
5127:1:9:13:Knowledge: South Seas Pirate Disguise
5131:1:9:13:Knowledge: Stonesplinter Disguise
5132:1:9:22:Knowledge: Syndicate Disguise
778:1:2:7:Kobold Excavation Pick
1389:1:2:7:Kobold Mining Mallet
1195:1:2:6:Kobold Mining Shovel
5081:1:1:5:Kodo Hide Bag
5467:1:7:10:Kodo Meat
14062:1:15:40:Kodo Mount
5020:1:13:1:Kolkar Booty Key
5826:1:12:1:Kravel's Scheme
2209:1:2:24:Kris
20868:3:12:61:Lambent Idol
2507:1:2:16:Laminated Recurve Bow
2491:1:2:8:Large Axe
21589:1:15:1:Large Blue Rocket
21714:1:15:1:Large Blue Rocket Cluster
804:1:1:25:Large Blue Sack
3023:1:2:21:Large Bore Blunderbuss
14344:3:7:55:Large Brilliant Shard
5576:1:1:25:Large Brown Sack
2480:1:2:3:Large Club
4370:1:0:26:Large Copper Bomb
5637:1:7:30:Large Fang
11084:3:7:25:Large Glimmering Shard
11139:3:7:35:Large Glowing Shard
21590:1:15:1:Large Green Rocket
21716:1:15:1:Large Green Rocket Cluster
5575:1:1:25:Large Green Sack
1725:1:1:35:Large Knapsack
2445:1:4:22:Large Metal Shield
22203:1:7:1:Large Obsidian Shard
12799:2:7:55:Large Opal
21591:1:15:1:Large Purple Rocket
21717:1:15:1:Large Purple Rocket Cluster
11178:3:7:45:Large Radiant Shard
13893:1:0:55:Large Raw Mightfish
21592:1:15:1:Large Red Rocket
21718:1:15:1:Large Red Rocket Cluster
857:1:1:25:Large Red Sack
2129:1:4:5:Large Round Shield
933:1:1:25:Large Rucksack
4398:1:0:40:Large Seaforium Charge
2486:1:2:3:Large Stone Mace
1288:1:7:1:Large Venom Sac
21593:1:15:1:Large White Rocket
21719:1:15:1:Large White Rocket Cluster
1200:1:4:5:Large Wooden Shield
21595:1:15:1:Large Yellow Rocket
21720:1:15:1:Large Yellow Rocket Cluster
18512:1:7:55:Larval Acid
19292:1:2:34:Last Month's Mutton
277518:1:2:1:Last Week's Ration
19293:1:2:55:Last Year's Mutton
19149:4:4:66:Lava Belt
17011:3:7:60:Lava Core
277960:3:15:40:Lavender Kodo
10054:1:4:46:Lavender Mageweave Shirt
3372:1:7:25:Leaded Vial
5480:1:0:25:Lean Venison
1015:1:7:19:Lean Wolf Flank
12209:1:0:25:Lean Wolf Steak
255721:1:7:36:Leather Tourniquet
227844:3:1:60:Leather-Reinforced Runecloth Bag
15909:1:2:35:Left-Handed Blades
15906:1:2:15:Left-Handed Brass Knuckles
15907:1:2:25:Left-Handed Claw
7097:1:0:5:Leg Meat
224806:2:0:50:Legion Portal Tuner
251290:2:7:60:Legionite Bar
4816:2:4:24:Legionnaire's Leggings
217398:1:0:38:Lesser Arcane Elixir
250342:1:0:25:Lesser Arcane Elixir
10998:2:7:20:Lesser Astral Essence
4278:1:12:1:Lesser Bloodstone Ore
250331:1:0:25:Lesser Cleric's Elixir
19297:2:0:35:Lesser Darkmoon Prize
247239:1:0:13:Lesser Discolored Healing Potion
16202:2:7:50:Lesser Eternal Essence
249232:2:2:54:Lesser Eternal Wand
250939:1:0:45:Lesser Frenzy Potion
858:1:0:13:Lesser Healing Potion
5511:1:0:22:Lesser Healthstone
19006:1:0:22:Lesser Healthstone
19007:1:0:22:Lesser Healthstone
3823:1:0:33:Lesser Invisibility Potion
250340:1:0:25:Lesser Mageblood Elixir
10938:2:7:10:Lesser Magic Essence
11287:2:2:15:Lesser Magic Wand
20747:1:7:50:Lesser Mana Oil
3385:1:0:24:Lesser Mana Potion
250945:1:0:55:Lesser Mender's Potion
1705:2:7:30:Lesser Moonstone
11134:2:7:30:Lesser Mystic Essence
11289:2:2:31:Lesser Mystic Wand
11174:2:7:40:Lesser Nether Essence
250933:1:0:5:Lesser Spellblasting Potion
4623:1:0:43:Lesser Stoneshield Potion
3388:1:0:25:Lesser Troll's Blood Elixir
20746:1:7:40:Lesser Wizard Oil
5766:2:4:27:Lesser Wizard's Robe
274559:3:15:1:Level 23 Cloth Gear
274697:3:15:1:Level 23 Cloth Supplies
274701:3:15:1:Level 23 Enchanting Supplies
274689:3:15:1:Level 23 Herbalism Supplies
276471:3:15:1:Level 23 Hunter Supplies
274561:3:15:1:Level 23 Leather Gear
274562:3:15:1:Level 23 Mail Gear
274684:3:15:1:Level 23 Mining Supplies
274693:3:15:1:Level 23 Skinning Supplies
274563:3:15:1:Level 38 Cloth Gear
274698:3:15:1:Level 38 Cloth Supplies
274702:3:15:1:Level 38 Enchanting Supplies
274690:3:15:1:Level 38 Herbalism Supplies
276472:3:15:1:Level 38 Hunter Supplies
274564:3:15:1:Level 38 Leather Gear
274565:3:15:1:Level 38 Mail Gear
274686:3:15:1:Level 38 Mining Supplies
274694:3:15:1:Level 38 Skinning Supplies
274566:3:15:1:Level 57 Cloth Gear
274699:3:15:1:Level 57 Cloth Supplies
274703:3:15:1:Level 57 Enchanting Supplies
274691:3:15:1:Level 57 Herbalism Supplies
276473:3:15:1:Level 57 Hunter Supplies
274567:3:15:1:Level 57 Leather Gear
274568:3:15:1:Level 57 Mail Gear
274687:3:15:1:Level 57 Mining Supplies
274569:3:15:1:Level 57 Plate Gear
274695:3:15:1:Level 57 Skinning Supplies
274570:3:15:1:Level 60 Cloth Gear
274700:3:15:1:Level 60 Cloth Supplies
274704:3:15:1:Level 60 Enchanting Supplies
274692:3:15:1:Level 60 Herbalism Supplies
276474:3:15:1:Level 60 Hunter Supplies
274571:3:15:1:Level 60 Leather Gear
274572:3:15:1:Level 60 Mail Gear
274688:3:15:1:Level 60 Mining Supplies
274573:3:15:1:Level 60 Plate Gear
274696:3:15:1:Level 60 Skinning Supplies
278066:3:15:1:Level 60 Tradeskill Supplies
11733:2:9:50:Libram of Constitution
23203:3:4:65:Libram of Fervor
18333:2:9:50:Libram of Focus
279248:4:4:65:Libram of Infusion
18334:2:9:50:Libram of Protection
18332:2:9:50:Libram of Rapidity
11736:2:9:50:Libram of Resilience
11732:2:9:50:Libram of Rumination
11734:2:9:50:Libram of Tenacity
11737:2:9:50:Libram of Voracity
21289:3:9:60:Libram: Blessing of Might VII
21288:3:9:60:Libram: Blessing of Wisdom VI
1139:1:9:30:Libram: Cleanse
8912:1:9:10:Libram: Crusader Strike
8914:1:9:22:Libram: Crusader Strike II
8920:1:9:34:Libram: Crusader Strike III
8931:1:9:46:Libram: Crusader Strike IV
8944:1:9:58:Libram: Crusader Strike V
1138:1:9:4:Libram: Divine Favor
1136:1:9:18:Libram: Divine Favor II
5683:1:9:50:Libram: Divine Shield II
5672:1:9:20:Libram: Exorcism
5673:1:9:28:Libram: Exorcism II
5674:1:9:36:Libram: Exorcism III
8929:1:9:44:Libram: Exorcism IV
8939:1:9:52:Libram: Exorcism V
8947:1:9:60:Libram: Exorcism VI
8911:1:9:10:Libram: Fist of Justice
8916:1:9:26:Libram: Fist of Justice II
8921:1:9:40:Libram: Fist of Justice III
8940:1:9:54:Libram: Fist of Justice IV
1141:1:9:6:Libram: Holy Light II
1151:1:9:14:Libram: Holy Light III
1534:1:9:22:Libram: Holy Light IV
21290:3:9:60:Libram: Holy Light IX
4164:1:9:30:Libram: Holy Light V
4165:1:9:38:Libram: Holy Light VI
8933:1:9:46:Libram: Holy Light VII
8941:1:9:54:Libram: Holy Light VIII
8909:1:9:8:Libram: Holy Strike II
8913:1:9:16:Libram: Holy Strike III
8915:1:9:24:Libram: Holy Strike IV
8919:1:9:32:Libram: Holy Strike V
8922:1:9:40:Libram: Holy Strike VI
8934:1:9:48:Libram: Holy Strike VII
8943:1:9:56:Libram: Holy Strike VIII
4167:1:9:40:Libram: Judgement
8935:1:9:50:Libram: Judgement II
8945:1:9:60:Libram: Judgement III
8910:1:9:10:Libram: Lay on Hands
8917:1:9:30:Libram: Lay on Hands II
8937:1:9:50:Libram: Lay on Hands III
1150:1:9:6:Libram: Purify
5685:1:9:40:Libram: Redemption
6133:1:9:14:Libram: Seal of Fury
5658:1:9:8:Libram: Seal of Might
1149:1:9:20:Libram: Seal of Might II
5671:1:9:32:Libram: Seal of Might III
4166:1:9:8:Libram: Seal of Protection
5680:1:9:20:Libram: Seal of Protection II
8918:1:9:30:Libram: Seal of Protection III
5660:1:9:16:Libram: Seal of Righteousness
5661:1:9:26:Libram: Seal of Righteousness II
5662:1:9:36:Libram: Seal of Righteousness III
8930:1:9:46:Libram: Seal of Righteousness IV
8942:1:9:56:Libram: Seal of Righteousness V
5678:1:9:36:Libram: Seal of Sacrifice
5684:1:9:22:Libram: Seal of Salvation
6132:1:9:12:Libram: Seal of Wisdom
5667:1:9:24:Libram: Seal of Wisdom II
5679:1:9:36:Libram: Seal of Wisdom III
1536:1:9:30:Libram: Seal of Wrath
5666:1:9:40:Libram: Seal of Wrath II
8936:1:9:50:Libram: Seal of Wrath III
5670:1:9:60:Libram: Seal of Wrath IV
5676:1:9:20:Libram: Sense Undead
5677:1:9:24:Libram: Turn Undead
5682:1:9:38:Libram: Turn Undead II
8938:1:9:52:Libram: Turn Undead III
273125:2:15:60:Lich's Index Finger
15996:1:15:53:Lifelike Mechanical Toad
3357:1:7:30:Liferoot
2304:1:0:5:Light Armor Kit
2398:1:4:10:Light Chain Armor
2399:1:4:10:Light Chain Belt
2401:1:4:10:Light Chain Boots
2402:1:4:10:Light Chain Bracers
2403:1:4:10:Light Chain Gloves
2400:1:4:10:Light Chain Leggings
15807:1:2:8:Light Crossbow
17056:1:15:1:Light Feather
2500:1:2:7:Light Hammer
783:1:7:10:Light Hide
2318:1:7:10:Light Leather
7281:2:4:14:Light Leather Bracers
7282:2:4:19:Light Leather Pants
7278:1:11:5:Light Leather Quiver
277715:1:1:5:Light Leather Reagent Bag
2110:1:4:4:Light Magesmith Robe
2392:1:4:10:Light Mail Armor
2393:1:4:10:Light Mail Belt
2395:1:4:10:Light Mail Boots
2396:1:4:10:Light Mail Bracers
2397:1:4:10:Light Mail Gloves
2394:1:4:10:Light Mail Leggings
22195:3:4:68:Light Obsidian Belt
2101:1:11:1:Light Quiver
2516:1:6:5:Light Shot
20500:1:7:55:Light Silithid Carapace
13757:1:7:45:Lightning Eel
248613:1:0:25:Lightning in a Bottle
11826:1:0:41:Lil' Smoky
3387:1:0:50:Limited Invulnerability Potion
4238:1:1:5:Linen Bag
1251:1:0:1:Linen Bandage
7026:1:4:9:Linen Belt
2569:2:4:13:Linen Boots
2570:1:4:6:Linen Cloak
2589:1:7:5:Linen Cloth
253664:1:1:5:Linen Reagent Bag
3731:1:7:23:Lion Meat
12640:4:4:61:Lionheart Helm
6201:2:4:12:Lithe Boots
20008:1:0:57:Living Action Potion
15059:3:4:60:Living Breastplate
252561:4:4:61:Living Crown
12803:2:7:55:Living Essence
15060:3:4:57:Living Leggings
15061:3:4:54:Living Shoulders
13933:1:0:55:Lobster Stew
6316:1:0:15:Loch Frenzy Delight
5046:1:0:30:Locked Gift
279960:1:0:4:Lodestone
7806:1:0:5:Lollipop
767:1:2:8:Long Bo Staff
4589:1:7:1:Long Elegant Feather
4326:2:4:37:Long Silken Cloak
928:1:2:25:Long Staff
5116:1:7:1:Long Tail Feather
3028:1:2:34:Longbow
4592:1:0:15:Longjaw Mud Snapper
923:1:2:26:Longsword
279959:1:0:60:Loom
260812:3:15:55:Loot-A-Rang
22261:1:15:1:Love Fool
22279:1:4:1:Lovely Black Dress
4372:2:2:24:Lovingly Crafted Boomstick
213376:3:7:40:Low-Background Truesilver Plates
9252:1:12:1:Lower Map Fragment
5373:1:15:1:Lucky Charm
768:1:2:9:Lumberjack Axe
2112:1:4:9:Lumberjack Jerkin
247884:1:7:5:Luminous Residue
15981:2:4:47:Lunar Sphere
15015:1:4:13:Lupine Cloak
15013:1:4:14:Lupine Cuffs
15019:1:4:21:Lupine Mantle
852:1:2:14:Mace
20007:1:0:50:Mageblood Elixir
249430:2:7:45:Magenta Dye
785:1:7:10:Mageroyal
10050:1:1:35:Mageweave Bag
8544:1:0:1:Mageweave Bandage
4338:1:7:40:Mageweave Cloth
254035:1:1:35:Mageweave Reagent Bag
1399:1:0:8:Magic Candle
2091:1:0:20:Magic Dust
9036:1:0:42:Magic Resistance Potion
232611:1:0:55:Magnificent Trollshine
2526:1:2:34:Main Gauche
241650:1:0:70:Major Discolored Healing Potion
250943:1:0:55:Major Frenzy Potion
13446:1:0:55:Major Healing Potion
9421:1:0:58:Major Healthstone
19012:1:0:58:Major Healthstone
19013:1:0:58:Major Healthstone
13444:1:0:59:Major Mana Potion
250949:1:0:25:Major Mender's Potion
18637:2:4:55:Major Recombobulator
18253:1:0:60:Major Rejuvenation Potion
250937:1:0:5:Major Spellblasting Potion
20004:1:0:58:Major Troll's Blood Elixir
273128:2:15:60:Maker's Spark
774:2:7:7:Malachite
274030:4:7:60:Malleable Essence of Nature
3827:1:0:32:Mana Potion
279956:1:0:4:Mana Well
279267:4:4:65:Mana-infused Cord
205949:1:0:1:Manifold Epiphany
19050:3:4:61:Mantle of the Timbermaw
21298:3:9:60:Manual of Battle Shout VII
24102:3:9:60:Manual of Eviscerate IX
21297:3:9:60:Manual of Heroic Strike IX
21299:3:9:60:Manual of Revenge VI
255724:2:9:26:Manual: Clever Poultice
232434:1:9:70:Manual: Dense Runecloth Bandage
255723:2:9:31:Manual: Greater Healing Potion
16112:1:9:36:Manual: Heavy Silk Bandage
255726:2:9:36:Manual: Leather Tourniquet
16113:1:9:42:Manual: Mageweave Bandage
255729:2:9:55:Manual: Major Healing Potion
255728:2:9:36:Manual: Potent Anti-Venom
255731:2:9:59:Manual: Powerful Poultice
6454:2:9:26:Manual: Strong Anti-Venom
255725:2:9:45:Manual: Superior Healing Potion
255727:2:9:36:Manual: Superior Poultice
255730:2:9:58:Manual: Surgical Tourniquet
17034:1:15:20:Maple Seed
4826:2:2:26:Marauder Axe
248823:1:7:60:Marefoil
13302:1:13:1:Market Row Postbox Key
210499:1:0:20:Marshroom
250600:4:4:61:Martyr's Legplates
191313:1:0:1:Mask of Death
274077:1:12:1:Mason's Note
3855:2:2:37:Massive Iron Axe
11307:2:2:47:Massive Longbow
19943:1:7:60:Massive Mojo
16008:2:4:58:Master Engineer's Goggles
279955:1:0:60:Master Forge
10249:2:4:61:Master's Cloak
15942:2:4:65:Master's Rod
20814:1:2:65:Master's Throwing Dagger
12794:3:2:63:Masterwork Stormhammer
16023:1:0:55:Masterwork Target Dummy
279277:1:0:1:Mathystral Amulet
279276:1:0:1:Mathystral Amulet Fragment
18704:4:12:71:Mature Blue Dragon Sinew
924:1:2:26:Maul
12223:1:7:5:Meaty Bat Wing
10398:1:15:40:Mechanical Chicken
4396:1:4:40:Mechanical Dragonling
11590:1:0:40:Mechanical Repair Kit
4401:1:15:15:Mechanical Squirrel Box
12845:1:12:1:Medallion of Faith
2313:1:0:15:Medium Armor Kit
4232:1:7:20:Medium Hide
2319:1:7:20:Medium Leather
11362:1:11:15:Medium Quiver
11363:1:11:15:Medium Shot Pouch
1205:1:0:25:Melon Juice
3331:1:4:12:Melrache's Cape
205952:1:0:1:Memory of a Shattered World
250946:1:0:5:Mender's Potion
12249:2:2:31:Merciless Axe
6307:1:15:1:Message in a Bottle
2443:1:4:37:Metal Buckler
17189:1:4:34:Metal Buckler
9253:1:12:1:Middle Map Fragment
12250:2:2:34:Midnight Axe
19044:3:4:58:Might of the Timbermaw
13934:1:0:55:Mightfish Steak
4800:2:4:23:Mighty Chain Pants
3492:2:2:30:Mighty Iron Hammer
13442:1:0:51:Mighty Rage Potion
2678:1:7:5:Mild Spices
22765:1:15:1:Mildewed Letter
15211:2:2:22:Militant Shortsword
18675:1:15:1:Military Ranks of the Horde & Alliance
5237:1:0:24:Mind-numbing Poison
6951:1:0:38:Mind-numbing Poison II
9186:1:0:52:Mind-numbing Poison III
2901:1:2:4:Mining Pick
7339:1:4:40:Miniscule Diamond Ring
247754:1:0:5:Minor Arcane Elixir
250330:1:0:5:Minor Cleric's Elixir
19298:2:0:20:Minor Darkmoon Prize
4596:1:0:15:Minor Discolored Healing Potion
250938:1:0:25:Minor Frenzy Potion
118:1:0:5:Minor Healing Potion
5512:1:0:10:Minor Healthstone
19004:1:0:10:Minor Healthstone
19005:1:0:10:Minor Healthstone
250339:1:0:5:Minor Mageblood Elixir
3384:1:0:22:Minor Magic Resistance Potion
20745:1:0:30:Minor Mana Oil
2455:1:0:15:Minor Mana Potion
250944:1:0:55:Minor Mender's Potion
4381:2:4:28:Minor Recombobulator
2456:1:0:15:Minor Rejuvenation Potion
250932:1:0:45:Minor Spellblasting Potion
3382:1:0:8:Minor Troll's Blood Elixir
20744:1:0:15:Minor Wizard Oil
241655:1:0:70:Mishandled Healing Potion
241656:1:0:70:Mishandled Healing Potion
3860:1:7:40:Mithril Bar
10508:2:2:41:Mithril Blunderbuss
21228:1:15:45:Mithril Bound Trunk
10561:1:7:43:Mithril Casing
250609:2:2:45:Mithril Claws
250610:2:2:45:Mithril Claymore
7931:2:4:46:Mithril Coif
10514:1:0:43:Mithril Frag Bomb
10513:2:6:49:Mithril Gyro-Shot
8364:1:0:35:Mithril Head Trout
10510:2:2:44:Mithril Heavy-bore Rifle
5758:2:15:50:Mithril Lockbox
8506:2:15:40:Mithril Lotterybox
10576:1:4:50:Mithril Mechanical Dragonling
3858:1:7:40:Mithril Ore
7924:2:4:43:Mithril Plate Bracers
7925:2:4:44:Mithril Plate Gloves
7920:2:4:42:Mithril Plate Pants
7932:2:4:47:Mithril Plate Shoulders
7967:2:0:43:Mithril Shield Spike
250607:2:2:41:Mithril Shortsword
7969:2:0:43:Mithril Spurs
250611:2:2:47:Mithril Stiletto
10559:1:7:39:Mithril Tube
250608:2:2:43:Mithril Warhammer
11415:1:0:55:Mixed Berries
10719:1:0:41:Mobile Alarm
4542:1:0:25:Moist Cornbread
18288:1:0:1:Molasses Firewater
19163:4:4:70:Molten Belt
279952:1:0:60:Molten Foundry
16983:4:4:60:Molten Helm
18506:3:4:62:Mongoose Boots
278423:2:2:1:Monster - Mining Pick
204688:1:0:1:Monster Hunter's First Rune Fragment
204689:1:0:1:Monster Hunter's Second Rune Fragment
204690:1:0:1:Monster Hunter's Third Rune Fragment
12218:1:0:45:Monster Omelet
7338:1:4:10:Mood Ring
4602:1:0:45:Moon Harvest Pumpkin
1645:1:0:45:Moonberry Juice
18632:1:0:35:Moonbrook Riot Taffy
14342:1:7:55:Mooncloth
14155:2:1:60:Mooncloth Bag
15802:3:4:56:Mooncloth Boots
14140:3:4:62:Mooncloth Circlet
18409:3:4:62:Mooncloth Gloves
14137:3:4:58:Mooncloth Leggings
254133:1:1:60:Mooncloth Reagent Bag
18486:3:4:61:Mooncloth Robe
14139:3:4:61:Mooncloth Shoulders
14138:3:4:60:Mooncloth Vest
219517:1:15:50:Moondragon Scale
21721:1:0:1:Moonglow
6709:2:4:18:Moonglow Vest
219514:1:15:50:Moonroot
4383:2:2:29:Moonsight Rifle
3853:2:2:36:Moonsteel Broadsword
189427:1:15:1:More Raid Consumables
8766:1:0:55:Morning Glory Dew
2532:1:2:46:Morning Star
11040:1:12:50:Morrowgrain
1206:2:7:25:Moss Agate
247786:1:7:5:Mote of Magic
274964:1:15:1:Mote of Unstable Magic
13465:1:7:56:Mountain Silversage
231778:1:0:65:Mountain Spring Water
2898:1:4:7:Mountaineer Chestpiece
279257:4:4:65:Mourning Handguards
249873:1:0:25:Mrrggl Smrrthle
19974:1:12:1:Mudskunk Lure
3087:1:0:15:Mug of Shimmer Stout
205961:1:15:1:Mulgore Bird Meat
4544:1:0:35:Mulgore Spice Bread
20692:2:4:60:Multicolored Band
730:1:7:11:Murloc Eye
1468:1:7:16:Murloc Fin
3663:1:0:10:Murloc Fin Soup
5780:2:4:18:Murloc Scale Belt
5783:2:4:38:Murloc Scale Bracers
5781:2:4:19:Murloc Scale Breastplate
1470:1:1:25:Murloc Skin Bag
268109:1:15:1:Musical Gustjumper
6279:1:12:1:Musty Letter
6280:1:12:1:Musty Missive
6276:1:12:1:Musty Note
6277:1:12:1:Musty Parchment
6278:1:12:1:Musty Scroll
3770:1:0:25:Mutton Chop
216879:1:0:40:Mysterious Troll Scroll
12037:1:7:30:Mystery Meat
12214:1:0:25:Mystery Stew
252452:2:0:30:Mystic Heavy Armor Kit
252436:2:0:15:Mystic Medium Armor Kit
252487:2:0:50:Mystic Rugged Armor Kit
4832:2:4:29:Mystic Sarong
252462:2:0:40:Mystic Thick Armor Kit
14368:1:4:22:Mystic's Shoulder Pads
15946:2:4:23:Mystic's Sphere
15938:2:4:58:Mystical Orb
7072:1:7:25:Naga Scale
3707:1:12:1:Nagaz Parchment
14095:1:4:11:Native Bands
15970:2:4:15:Native Branch
14098:1:4:10:Native Cloak
14102:1:4:13:Native Handwraps
14110:1:4:13:Native Sandals
14099:1:4:12:Native Sash
6052:1:0:38:Nature Protection Potion
948:1:2:1:Nature Sword
51:1:4:1:Neophyte's Boots
53:1:4:1:Neophyte's Shirt
20725:4:7:60:Nexus Crystal
935:3:2:20:Night Watch Shortsword
6530:1:0:20:Nightcrawlers
19169:4:2:70:Nightfall
13931:1:0:45:Nightfin Soup
219399:1:15:25:Nightmare Moss
221299:4:15:1:Nightmares Deck
8197:2:4:47:Nightscape Boots
8195:2:4:46:Nightscape Cloak
8176:2:4:41:Nightscape Headband
8193:2:4:46:Nightscape Pants
8192:2:4:42:Nightscape Shoulders
8175:2:4:41:Nightscape Tunic
15929:2:4:37:Nightsky Orb
4828:2:4:27:Nightwind Belt
7285:2:4:24:Nimble Leather Gloves
260796:1:7:29:No Slip SAF-T Padding
289081:1:0:30:Noggenfogger Elixir
9752:1:4:12:Nomad Bands
9754:1:4:11:Nomad Cloak
9755:1:4:13:Nomad Gloves
9751:1:4:12:Nomad Sandals
9750:1:4:12:Nomad Sash
18401:4:12:60:Nostro's Compendium of Dragon Slaying
247789:1:2:6:Novice's Practice Wand
217346:1:0:60:Numbing Poison
278265:1:0:5:Nutritious Slime Sludge
20871:3:12:61:Obsidian Idol
22191:4:4:72:Obsidian Mail Tunic
226374:1:0:54:Occult Poison I
234444:1:0:60:Occult Poison II
274799:4:15:60:Ochre Skeletal Warhorse
1993:2:4:36:Ogremind Ring
6458:1:0:15:Oil Covered Fish
8956:1:0:41:Oil of Immolation
1177:1:0:8:Oil of Olaf
6358:1:7:15:Oily Blackmouth
732:1:12:9:Okra
2508:1:2:2:Old Blunderbuss
8589:1:15:40:Old Whistle of the Ivory Raptor
8590:1:15:40:Old Whistle of the Obsidian Raptor
58:1:4:1:OLDAcolyte's Belt
141:1:4:1:OLDBrawler's Belt
90:1:4:1:OLDDwarven Initiate's Belt
92:1:4:1:OLDDwarven Initiate's Boots
93:1:4:1:OLDDwarven Initiate's Shirt
46:1:4:1:OLDFootpad's Belt
50:1:4:1:OLDInitiate's Belt
137:1:4:1:OLDNeophyte's Belt
54:1:4:1:OLDNovice's Belt
152:1:4:1:OLDPrimitive Leather Belt
41:1:4:1:OLDRecruit's Belt
146:1:4:1:OLDRugged Trapper's Belt
42:1:4:1:OLDSquire's Belt
89:1:4:1:OLDThick Trapper's Shirt
122:1:4:1:OLDThug Belt
7548:2:4:46:Onyx Choker
20867:3:12:61:Onyx Idol
7547:2:4:46:Onyx Ring
15141:4:4:62:Onyxia Scale Breastplate
15138:3:4:60:Onyxia Scale Cloak
20768:1:15:50:Oozing Bag
15984:2:4:56:Opulent Scepter
6261:1:7:35:Orange Dye
19710:3:12:61:Orange Hakkari Bijou
10056:1:4:43:Orange Mageweave Shirt
10052:1:4:40:Orange Martial Shirt
4838:2:4:26:Orb of Power
7929:2:4:42:Orcish War Leggings
22136:1:15:1:Orgrimmar Gift Collection
22294:1:15:1:Orgrimmar Pledge Collection
2509:1:2:9:Ornate Blunderbuss
16664:2:4:54:Ornate Bracers
4632:2:15:20:Ornate Bronze Lockbox
2444:1:4:50:Ornate Buckler
17190:1:4:47:Ornate Buckler
7936:2:4:49:Ornate Mithril Boots
7935:2:4:48:Ornate Mithril Breastplate
7927:2:4:44:Ornate Mithril Gloves
7937:2:4:49:Ornate Mithril Helm
7926:2:4:44:Ornate Mithril Pants
7928:2:4:45:Ornate Mithril Shoulders
5507:1:0:27:Ornate Spyglass
279253:4:4:65:Outlaw's Collar
15505:1:4:23:Outrunner's Pauldrons
224893:2:0:50:Overcharged Portal Tuner
1189:2:4:20:Overseer's Ring
4796:2:4:25:Owl Bracers
4822:2:4:23:Owl's Disk
22293:1:15:1:Package of Cards
11022:1:12:1:Packet of Tharlendris Seeds
2160:1:4:27:Padded Armor
3591:1:4:27:Padded Belt
2156:1:4:27:Padded Boots
3592:1:4:27:Padded Bracers
2158:1:4:27:Padded Gloves
2159:1:4:27:Padded Pants
14157:1:4:24:Pagan Mantle
15974:2:4:26:Pagan Rod
14158:2:4:26:Pagan Vest
12255:2:4:46:Pale Leggings
2413:1:15:40:Palomino
12354:4:15:60:Palomino Bridle
10518:2:4:45:Parachute Cloak
22287:1:15:1:Parcel of Cards
8496:1:15:20:Parrot Cage (Cockatiel)
8492:1:15:20:Parrot Cage (Green Wing Macaw)
8494:1:15:20:Parrot Cage (Hyacinth Macaw)
8495:1:15:20:Parrot Cage (Senegal)
5859:1:0:1:Party Grenade
10318:1:9:48:Pattern: Admiral's Hat
7085:2:9:38:Pattern: Azure Shoulders
4301:3:9:40:Pattern: Barbaric Belt
18949:1:9:31:Pattern: Barbaric Bracers
4297:2:9:30:Pattern: Barbaric Gloves
251739:3:9:1:Pattern: Beastculler's Adaptive Bracers
251738:3:9:1:Pattern: Beastculler's Adaptive Vest
251740:3:9:1:Pattern: Beastculler's Adaptive Wrap
251755:3:9:1:Pattern: Beastmender's Adaptive Girdle
251753:3:9:1:Pattern: Beastmender's Adaptive Robe
251754:3:9:1:Pattern: Beastmender's Adaptive Wristlinks
18414:4:9:62:Pattern: Belt of the Archmage
22309:2:9:65:Pattern: Big Bag of Enchantment
8390:2:9:48:Pattern: Big Voodoo Cloak
8387:2:9:44:Pattern: Big Voodoo Mask
217260:2:9:44:Pattern: Big Voodoo Mask
8389:2:9:48:Pattern: Big Voodoo Pants
8386:2:9:43:Pattern: Big Voodoo Robe
217262:2:9:43:Pattern: Big Voodoo Robe
254044:3:9:45:Pattern: Black Cord
15759:1:9:58:Pattern: Black Dragonscale Breastplate
252939:4:9:60:Pattern: Black Dragonscale Helm
15781:3:9:62:Pattern: Black Dragonscale Leggings
15770:3:9:60:Pattern: Black Dragonscale Shoulders
254102:3:9:55:Pattern: Black Gloves
5775:2:9:37:Pattern: Black Silk Pack
254008:3:9:35:Pattern: Black Slippers
7289:1:9:20:Pattern: Black Whelp Cloak
252761:3:9:15:Pattern: Black Whelp Slippers
20576:1:9:20:Pattern: Black Whelp Tunic
15751:1:9:57:Pattern: Blue Dragonscale Breastplate
252938:4:9:60:Pattern: Blue Dragonscale Helm
15763:3:9:59:Pattern: Blue Dragonscale Shoulders
6272:1:9:14:Pattern: Blue Linen Robe
6270:1:9:12:Pattern: Blue Linen Vest
6274:1:9:20:Pattern: Blue Overalls
252886:2:9:59:Pattern: Blue Suede Belt
252888:2:9:60:Pattern: Blue Suede Bracers
252866:2:9:53:Pattern: Blue Suede Gloves
252890:2:9:60:Pattern: Blue Suede Hat
252878:2:9:56:Pattern: Blue Suede Pants
252859:2:9:52:Pattern: Blue Suede Shoes
252881:2:9:57:Pattern: Blue Suede Shoulders
4352:2:9:35:Pattern: Boots of the Enchanter
217254:2:9:35:Pattern: Boots of the Enchanter
14510:3:9:62:Pattern: Bottomless Bag
228993:3:9:62:Pattern: Bottomless Bag
254140:2:9:60:Pattern: Bottomless Reagent Bag
252771:3:9:20:Pattern: Brawler's Leather Armor
252814:3:9:30:Pattern: Brawler's Leather Helm
252792:3:9:25:Pattern: Brawler's Leather Pants
14484:2:9:55:Pattern: Brightcloth Cloak
14479:2:9:54:Pattern: Brightcloth Gloves
14494:2:9:58:Pattern: Brightcloth Pants
14478:2:9:54:Pattern: Brightcloth Robe
227910:4:9:62:Pattern: Brilliant Chromatic Cloak
252909:2:9:51:Pattern: Charged Scorpid Belt
252936:2:9:60:Pattern: Charged Scorpid Boots
252927:2:9:56:Pattern: Charged Scorpid Bracers
252930:2:9:56:Pattern: Charged Scorpid Gauntlets
252915:2:9:53:Pattern: Charged Scorpid Helm
252934:2:9:59:Pattern: Charged Scorpid Leggings
252917:2:9:55:Pattern: Charged Scorpid Shoulders
252932:2:9:57:Pattern: Charged Scorpid Vest
15737:2:9:55:Pattern: Chimeric Boots
15746:2:9:56:Pattern: Chimeric Leggings
15755:2:9:58:Pattern: Chimeric Vest
18517:4:9:62:Pattern: Chromatic Cloak
14482:2:9:55:Pattern: Cindercloth Cloak
14476:2:9:54:Pattern: Cindercloth Gloves
14490:2:9:56:Pattern: Cindercloth Pants
14471:2:9:52:Pattern: Cindercloth Vest
10316:2:9:24:Pattern: Colorful Kilt
8384:3:9:40:Pattern: Comfortable Leather Hat
21371:3:9:60:Pattern: Core Felcloth Bag
217244:1:9:41:Pattern: Crimson Silk Robe
7084:2:9:38:Pattern: Crimson Silk Shoulders
217251:2:9:38:Pattern: Crimson Silk Shoulders
252762:3:9:15:Pattern: Dark Leather Boots
7360:2:9:25:Pattern: Dark Leather Gloves
4296:2:9:28:Pattern: Dark Leather Shoulders
2409:2:9:20:Pattern: Dark Leather Tunic
252892:4:9:60:Pattern: Dawn Armor
252773:3:9:20:Pattern: Defender's Leather Armor
252816:3:9:30:Pattern: Defender's Leather Helm
252794:3:9:25:Pattern: Defender's Leather Pants
6476:2:9:23:Pattern: Deviate Scale Belt
6474:1:9:18:Pattern: Deviate Scale Cloak
6475:1:9:21:Pattern: Deviate Scale Gloves
228119:3:9:58:Pattern: Devilcore Gauntlets
228120:3:9:60:Pattern: Devilcore Leggings
15758:1:9:58:Pattern: Devilsaur Gauntlets
15772:3:9:60:Pattern: Devilsaur Leggings
251743:3:9:1:Pattern: Dinodestroyer's Adaptive Belt
251741:3:9:1:Pattern: Dinodestroyer's Adaptive Chestguard
251742:3:9:1:Pattern: Dinodestroyer's Adaptive Wrists
251758:3:9:1:Pattern: Dinomender's Adaptive Chain
251756:3:9:1:Pattern: Dinomender's Adaptive Tunic
251757:3:9:1:Pattern: Dinomender's Adaptive Wrists
7452:3:9:40:Pattern: Dusky Boots
7449:2:9:33:Pattern: Dusky Leather Leggings
254000:2:9:35:Pattern: Earthen Leggings
7086:2:9:39:Pattern: Earthen Silk Belt
217249:2:9:39:Pattern: Earthen Silk Belt
254020:2:9:40:Pattern: Earthen Silk Cuffs
254018:2:9:39:Pattern: Earthen Silk Gloves
254016:2:9:37:Pattern: Earthen Silk Hood
254034:2:9:41:Pattern: Earthen Silk Shoulders
254014:2:9:36:Pattern: Earthen Silk Slippers
254094:2:9:54:Pattern: Earthenweave Boots
254078:2:9:52:Pattern: Earthenweave Cord
254138:2:9:61:Pattern: Earthenweave Crown
254132:2:9:60:Pattern: Earthenweave Cuffs
254076:2:9:52:Pattern: Earthenweave Gloves
254126:2:9:58:Pattern: Earthenweave Leggings
254120:2:9:57:Pattern: Earthenweave Mantle
254122:2:9:59:Pattern: Earthenweave Vest
228477:4:9:62:Pattern: Embroidered Belt of the Archmage
22307:1:9:45:Pattern: Enchanted Mageweave Pouch
22308:1:9:55:Pattern: Enchanted Runecloth Bag
217258:1:9:33:Pattern: Enchanter's Cowl
14492:2:9:57:Pattern: Felcloth Boots
14496:2:9:58:Pattern: Felcloth Hood
14506:2:9:61:Pattern: Felcloth Robe
14508:2:9:62:Pattern: Felcloth Shoulders
254042:3:9:45:Pattern: Fiery Cord
254100:3:9:55:Pattern: Fiery Gloves
254006:3:9:35:Pattern: Fiery Slippers
253980:3:9:30:Pattern: Filigreed Flame Circlet
253906:3:9:20:Pattern: Filigreed Flame Gown
253942:3:9:25:Pattern: Filigreed Flame Leggings
253984:3:9:30:Pattern: Filigreed Pearly Circlet
253910:3:9:20:Pattern: Filigreed Pearly Gown
253946:3:9:25:Pattern: Filigreed Pearly Leggings
253976:3:9:30:Pattern: Filigreed Pristine Circlet
253902:3:9:20:Pattern: Filigreed Pristine Gown
253938:3:9:25:Pattern: Filigreed Pristine Leggings
253982:3:9:30:Pattern: Filigreed Shadow Circlet
253908:3:9:20:Pattern: Filigreed Shadow Gown
253944:3:9:25:Pattern: Filigreed Shadow Leggings
253986:3:9:30:Pattern: Filigreed Shining Circlet
253912:3:9:20:Pattern: Filigreed Shining Gown
253948:3:9:25:Pattern: Filigreed Shining Leggings
253978:3:9:30:Pattern: Filigreed Silky Circlet
253904:3:9:20:Pattern: Filigreed Silky Gown
253940:3:9:25:Pattern: Filigreed Silky Leggings
2406:2:9:15:Pattern: Fine Leather Boots
2408:2:9:15:Pattern: Fine Leather Gloves
5972:2:9:21:Pattern: Fine Leather Pants
18265:3:9:64:Pattern: Flarecore Wraps
252812:2:9:30:Pattern: Forceful Heavy Armor Kit
252784:2:9:15:Pattern: Forceful Medium Armor Kit
252942:2:9:50:Pattern: Forceful Rugged Armor Kit
15761:2:9:59:Pattern: Frostsaber Gloves
15747:2:9:57:Pattern: Frostsaber Leggings
15779:2:9:62:Pattern: Frostsaber Tunic
14474:2:9:53:Pattern: Frostweave Gloves
14489:2:9:56:Pattern: Frostweave Pants
14467:2:9:51:Pattern: Frostweave Robe
14466:2:9:51:Pattern: Frostweave Tunic
254040:3:9:45:Pattern: Frothing Cord
254098:3:9:55:Pattern: Frothing Gloves
254004:3:9:35:Pattern: Frothing Slippers
14635:1:9:37:Pattern: Gem-studded Leather Belt
14473:2:9:53:Pattern: Ghostweave Belt
254130:2:9:60:Pattern: Ghostweave Boots
254074:2:9:52:Pattern: Ghostweave Cord
14477:2:9:54:Pattern: Ghostweave Gloves
254136:2:9:61:Pattern: Ghostweave Hood
254128:2:9:59:Pattern: Ghostweave Mantle
14495:2:9:58:Pattern: Ghostweave Pants
14480:2:9:55:Pattern: Ghostweave Vest
254038:3:9:45:Pattern: Gilded Cord
254096:3:9:55:Pattern: Gilded Gloves
254022:3:9:40:Pattern: Gilded Handwraps
254002:3:9:35:Pattern: Gilded Slippers
14511:4:9:62:Pattern: Gloves of Spell Mastery
17722:2:9:38:Pattern: Gloves of the Greatfather
254046:3:9:45:Pattern: Golden Cord
254104:3:9:55:Pattern: Golden Gloves
254010:3:9:35:Pattern: Golden Slippers
2601:2:9:21:Pattern: Gray Woolen Robe
6275:1:9:23:Pattern: Greater Adept's Robe
15726:1:9:52:Pattern: Green Dragonscale Breastplate
15733:3:9:54:Pattern: Green Dragonscale Leggings
17724:1:9:38:Pattern: Green Holiday Shirt
7090:2:9:33:Pattern: Green Silk Armor
5774:2:9:35:Pattern: Green Silk Pack
7450:2:9:35:Pattern: Green Whelp Armor
4292:2:9:19:Pattern: Green Woolen Bag
4299:2:9:35:Pattern: Guardian Armor
4298:3:9:34:Pattern: Guardian Belt
217266:3:9:34:Pattern: Guardian Belt
5974:2:9:37:Pattern: Guardian Cloak
4300:2:9:39:Pattern: Guardian Leather Bracers
217264:2:9:39:Pattern: Guardian Leather Bracers
7092:2:9:29:Pattern: Hands of Darkness
227902:1:9:58:Pattern: Hardened Black Dragonscale Breastplate
227903:3:9:62:Pattern: Hardened Black Dragonscale Leggings
227904:3:9:60:Pattern: Hardened Black Dragonscale Shoulders
7364:2:9:29:Pattern: Heavy Earthen Gloves
18731:1:9:30:Pattern: Heavy Leather Ball
15743:2:9:56:Pattern: Heavy Scorpid Belt
252928:2:9:56:Pattern: Heavy Scorpid Boots
15738:2:9:55:Pattern: Heavy Scorpid Gauntlets
15748:2:9:57:Pattern: Heavy Scorpid Leggings
15774:2:9:61:Pattern: Heavy Scorpid Shoulders
15727:2:9:53:Pattern: Heavy Scorpid Vest
4346:2:9:20:Pattern: Heavy Woolen Cloak
12716:3:9:61:Pattern: Helm of the Great Chief
7361:2:9:26:Pattern: Herbalist's Gloves
18518:4:9:62:Pattern: Hide of the Wild
4294:2:9:24:Pattern: Hillman's Belt
252804:2:9:27:Pattern: Hillman's Leather Boots
4293:2:9:20:Pattern: Hillman's Leather Vest
227898:1:9:57:Pattern: Honed Blue Dragonscale Breastplate
227899:3:9:59:Pattern: Honed Blue Dragonscale Shoulders
4355:1:9:40:Pattern: Icy Cloak
228317:3:9:62:Pattern: Incandescent Mooncloth Circlet
228318:3:9:58:Pattern: Incandescent Mooncloth Leggings
228303:1:9:61:Pattern: Incandescent Mooncloth Robe
228316:3:9:60:Pattern: Incandescent Mooncloth Vest
215369:2:9:30:Pattern: Invoker's Cord
215370:2:9:30:Pattern: Invoker's Mantle
12728:4:9:63:Pattern: Invulnerable Mail
15760:3:9:58:Pattern: Ironfeather Breastplate
252895:4:9:60:Pattern: Ironfeather Leggings
15735:1:9:54:Pattern: Ironfeather Shoulders
5083:2:9:11:Pattern: Kodo Hide Bag
10314:1:9:46:Pattern: Lavender Mageweave Shirt
228121:2:9:60:Pattern: Leather-Reinforced Runecloth Bag
253665:2:9:5:Pattern: Linen Reagent Bag
15771:3:9:60:Pattern: Living Breastplate
252891:4:9:60:Pattern: Living Crown
228309:1:9:52:Pattern: Living Green Dragonscale Breastplate
228251:3:9:54:Pattern: Living Green Dragonscale Gauntlets
227900:3:9:54:Pattern: Living Green Dragonscale Leggings
15752:3:9:57:Pattern: Living Leggings
15734:1:9:54:Pattern: Living Shoulders
228276:4:9:62:Pattern: Mastercrafted Shifting Cloak
227906:2:9:57:Pattern: Masterwork Volcanic Breastplate
227908:2:9:54:Pattern: Masterwork Volcanic Leggings
227907:2:9:61:Pattern: Masterwork Volcanic Shoulders
252832:3:9:35:Pattern: Mender's Leather Belt
252871:3:9:55:Pattern: Mender's Leather Gauntlets
252847:3:9:45:Pattern: Mender's Leather Shoes
252899:3:9:45:Pattern: Mender's Mail Boots
252921:3:9:55:Pattern: Mender's Mail Gauntlets
14499:2:9:60:Pattern: Mooncloth Bag
14509:3:9:62:Pattern: Mooncloth Circlet
14497:3:9:58:Pattern: Mooncloth Leggings
18487:1:9:61:Pattern: Mooncloth Robe
14507:3:9:61:Pattern: Mooncloth Shoulders
14501:3:9:60:Pattern: Mooncloth Vest
252764:3:9:15:Pattern: Moonglow Boots
6710:2:9:18:Pattern: Moonglow Vest
252763:3:9:15:Pattern: Murloc Scale Shoes
252811:2:9:30:Pattern: Mystic Heavy Armor Kit
252783:2:9:15:Pattern: Mystic Medium Armor Kit
8388:2:9:46:Pattern: Nightscape Cloak
253886:3:9:15:Pattern: Novice Arcanist's Sash
253888:3:9:15:Pattern: Novice Ardent's Sash
10311:1:9:44:Pattern: Orange Martial Shirt
4348:2:9:25:Pattern: Phoenix Gloves
4349:2:9:25:Pattern: Phoenix Pants
7363:2:9:28:Pattern: Pilferer's Gloves
10317:1:9:47:Pattern: Pink Mageweave Shirt
252940:4:9:60:Pattern: Pristine Scorpid Leggings
252826:3:9:35:Pattern: Prowler's Leather Belt
252867:3:9:55:Pattern: Prowler's Leather Gauntlets
252843:3:9:45:Pattern: Prowler's Leather Shoes
254048:3:9:45:Pattern: Radiant Cord
254106:3:9:55:Pattern: Radiant Gloves
254012:3:9:35:Pattern: Radiant Slippers
13288:2:9:33:Pattern: Raptor Hide Belt
13287:2:9:33:Pattern: Raptor Hide Harness
252937:4:9:60:Pattern: Red Dragonscale Leggings
5771:1:9:14:Pattern: Red Linen Bag
2598:2:9:10:Pattern: Red Linen Robe
6271:2:9:12:Pattern: Red Linen Vest
10312:2:9:45:Pattern: Red Mageweave Gloves
10320:2:9:48:Pattern: Red Mageweave Headband
10302:2:9:43:Pattern: Red Mageweave Pants
10315:2:9:47:Pattern: Red Mageweave Shoulders
10300:2:9:43:Pattern: Red Mageweave Vest
7290:1:9:24:Pattern: Red Whelp Gloves
5772:1:9:23:Pattern: Red Woolen Bag
4345:2:9:19:Pattern: Red Woolen Boots
4347:2:9:24:Pattern: Reinforced Woolen Shoulders
4354:3:9:37:Pattern: Rich Purple Silk Shirt
14513:4:9:62:Pattern: Robe of the Archmage
14514:4:9:62:Pattern: Robe of the Void
5773:2:9:30:Pattern: Robes of Arcana
7288:2:9:11:Pattern: Rugged Leather Pants
14468:1:9:52:Pattern: Runecloth Bag
14498:2:9:59:Pattern: Runecloth Headband
14491:2:9:57:Pattern: Runecloth Pants
14504:2:9:61:Pattern: Runecloth Shoulders
14470:2:9:52:Pattern: Runecloth Tunic
20548:3:9:62:Pattern: Runed Stygian Belt
20547:3:9:62:Pattern: Runed Stygian Boots
20546:3:9:62:Pattern: Runed Stygian Leggings
15776:2:9:61:Pattern: Runic Leather Armor
15745:2:9:56:Pattern: Runic Leather Belt
15739:2:9:55:Pattern: Runic Leather Bracers
15731:2:9:54:Pattern: Runic Leather Gauntlets
15765:2:9:60:Pattern: Runic Leather Pants
15777:2:9:62:Pattern: Runic Leather Shoulders
238301:3:9:1:Pattern: Scarlet Augur's Cuffs
238298:3:9:1:Pattern: Scarlet Augur's Hood
238304:3:9:1:Pattern: Scarlet Augur's Leggings
238299:3:9:1:Pattern: Scarlet Augur's Mantle
238302:3:9:1:Pattern: Scarlet Augur's Mitts
238305:3:9:1:Pattern: Scarlet Augur's Soles
238303:3:9:1:Pattern: Scarlet Augur's Strap
238300:3:9:1:Pattern: Scarlet Augur's Vestments
238321:3:9:1:Pattern: Scarlet Huntsman's Boots
238316:3:9:1:Pattern: Scarlet Huntsman's Chain
238319:3:9:1:Pattern: Scarlet Huntsman's Clasp
238314:3:9:1:Pattern: Scarlet Huntsman's Coif
238318:3:9:1:Pattern: Scarlet Huntsman's Handguards
238320:3:9:1:Pattern: Scarlet Huntsman's Legguards
238315:3:9:1:Pattern: Scarlet Huntsman's Pauldrons
238317:3:9:1:Pattern: Scarlet Huntsman's Wristguards
238306:3:9:1:Pattern: Scarlet Infiltrator's Bandana
238311:3:9:1:Pattern: Scarlet Infiltrator's Belt
238309:3:9:1:Pattern: Scarlet Infiltrator's Bracers
238310:3:9:1:Pattern: Scarlet Infiltrator's Gloves
238313:3:9:1:Pattern: Scarlet Infiltrator's Shoes
238307:3:9:1:Pattern: Scarlet Infiltrator's Shoulderpads
238312:3:9:1:Pattern: Scarlet Infiltrator's Trousers
238308:3:9:1:Pattern: Scarlet Infiltrator's Vest
4351:2:9:34:Pattern: Shadow Hood
10463:2:9:49:Pattern: Shadoweave Mask
18239:1:9:40:Pattern: Shadowskin Gloves
18519:4:9:62:Pattern: Shifting Cloak
252830:3:9:35:Pattern: Skirmisher's Leather Belt
252898:3:9:45:Pattern: Skirmisher's Mail Boots
252920:3:9:55:Pattern: Skirmisher's Mail Gauntlets
252827:3:9:35:Pattern: Skulker's Leather Belt
252868:3:9:55:Pattern: Skulker's Leather Gauntlets
252844:3:9:45:Pattern: Skulker's Leather Shoes
252831:3:9:35:Pattern: Skycaller's Leather Belt
252870:3:9:55:Pattern: Skycaller's Leather Gauntlets
252846:3:9:45:Pattern: Skycaller's Leather Shoes
252897:3:9:45:Pattern: Skycaller's Mail Boots
252919:3:9:55:Pattern: Skycaller's Mail Gauntlets
251737:3:9:1:Pattern: Slimeslayer's Adaptive Cord
251736:3:9:1:Pattern: Slimeslayer's Adaptive Cuffs
251735:3:9:1:Pattern: Slimeslayer's Adaptive Robes
251752:3:9:1:Pattern: Slimetender's Adaptive Belt
251751:3:9:1:Pattern: Slimetender's Adaptive Bracers
251750:3:9:1:Pattern: Slimetender's Adaptive Tunic
21358:1:9:52:Pattern: Soul Pouch
4353:2:9:36:Pattern: Spider Belt
4350:2:9:28:Pattern: Spider Silk Slippers
252828:3:9:35:Pattern: Stalker's Leather Belt
252896:3:9:45:Pattern: Stalker's Mail Boots
252918:3:9:55:Pattern: Stalker's Mail Gauntlets
4356:2:9:40:Pattern: Star Belt
12703:3:9:59:Pattern: Storm Gauntlets
254686:2:9:50:Pattern: Stormcloth Boots
254684:2:9:48:Pattern: Stormcloth Headband
254681:2:9:44:Pattern: Stormcloth Pants
254685:2:9:49:Pattern: Stormcloth Shoulders
254683:2:9:45:Pattern: Stormcloth Vest
252775:3:9:20:Pattern: Stormrider's Leather Armor
252818:3:9:30:Pattern: Stormrider's Leather Helm
252796:3:9:25:Pattern: Stormrider's Leather Pants
15753:3:9:57:Pattern: Stormshroud Armor
21548:3:9:62:Pattern: Stormshroud Gloves
15741:1:9:55:Pattern: Stormshroud Pants
15764:3:9:59:Pattern: Stormshroud Shoulders
6390:2:9:24:Pattern: Stylish Blue Shirt
6391:2:9:24:Pattern: Stylish Green Shirt
252929:2:9:56:Pattern: Supple Scorpid Belt
252908:2:9:51:Pattern: Supple Scorpid Boots
252916:2:9:55:Pattern: Supple Scorpid Bracers
252931:2:9:57:Pattern: Supple Scorpid Helm
252914:2:9:53:Pattern: Supple Scorpid Leggings
252935:2:9:60:Pattern: Supple Scorpid Sabatons
252926:2:9:56:Pattern: Supple Scorpid Shoulders
7453:2:9:40:Pattern: Swift Boots
252893:4:9:60:Pattern: Timbermaw Tunic
252858:2:9:52:Pattern: Tooled Leather Belt
252865:2:9:53:Pattern: Tooled Leather Boots
252885:2:9:59:Pattern: Tooled Leather Bracers
252882:2:9:58:Pattern: Tooled Leather Crown
252887:2:9:60:Pattern: Tooled Leather Epaulets
252880:2:9:57:Pattern: Tooled Leather Gauntlets
252889:2:9:60:Pattern: Tooled Leather Pants
252774:3:9:20:Pattern: Totemic Leather Armor
252817:3:9:30:Pattern: Totemic Leather Helm
252795:3:9:25:Pattern: Totemic Leather Pants
8399:2:9:47:Pattern: Tough Scorpid Boots
8397:2:9:44:Pattern: Tough Scorpid Bracers
8395:2:9:44:Pattern: Tough Scorpid Breastplate
8398:2:9:45:Pattern: Tough Scorpid Gloves
8402:2:9:50:Pattern: Tough Scorpid Helm
8401:2:9:49:Pattern: Tough Scorpid Leggings
8400:2:9:48:Pattern: Tough Scorpid Shoulders
252772:3:9:20:Pattern: Trapper's Leather Armor
252815:3:9:30:Pattern: Trapper's Leather Helm
252793:3:9:25:Pattern: Trapper's Leather Pants
7091:2:9:30:Pattern: Truefaith Gloves
14512:4:9:62:Pattern: Truefaith Vestments
217271:1:9:41:Pattern: Turtle Scale Gloves
10326:1:9:50:Pattern: Tuxedo Jacket
10323:1:9:49:Pattern: Tuxedo Pants
10321:1:9:48:Pattern: Tuxedo Shirt
15749:2:9:57:Pattern: Volcanic Breastplate
15732:2:9:54:Pattern: Volcanic Leggings
15775:2:9:61:Pattern: Volcanic Shoulders
15742:1:9:55:Pattern: Warbear Harness
252894:4:9:60:Pattern: Warbear Helm
252829:3:9:35:Pattern: Warden's Leather Belt
252869:3:9:55:Pattern: Warden's Leather Gauntlets
252845:3:9:45:Pattern: Warden's Leather Shoes
10301:2:9:43:Pattern: White Bandit Mask
2407:2:9:13:Pattern: White Leather Jerkin
10325:1:9:50:Pattern: White Wedding Dress
15773:2:9:61:Pattern: Wicked Leather Armor
15768:2:9:60:Pattern: Wicked Leather Belt
252879:2:9:57:Pattern: Wicked Leather Boots
15728:2:9:53:Pattern: Wicked Leather Bracers
15744:2:9:56:Pattern: Wicked Leather Headband
15757:2:9:58:Pattern: Wicked Leather Pants
252884:2:9:59:Pattern: Wicked Leather Shoulders
12691:2:9:54:Pattern: Wildthorn Mail
252776:3:9:20:Pattern: Wisdom's Leather Armor
252819:3:9:30:Pattern: Wisdom's Leather Helm
252797:3:9:25:Pattern: Wisdom's Leather Pants
14485:2:9:55:Pattern: Wizardweave Leggings
14500:2:9:60:Pattern: Wizardweave Robe
14505:2:9:61:Pattern: Wizardweave Turban
253668:2:9:10:Pattern: Woolen Reagent Bag
2868:2:4:25:Patterned Bronze Bracers
249865:1:0:5:Peace Tea
2447:1:7:5:Peacebloom
5542:2:4:19:Pearl-clasped Cloak
5540:2:2:23:Pearl-handled Dagger
19483:1:15:1:Peeling the Onion
8182:1:2:7:Pellet Rifle
2481:1:2:4:Peon Sword
6471:1:7:1:Perfect Deviate Scale
21829:1:15:1:Perfume Bottle
268883:1:0:22:Perishable Healing Potion
268882:1:0:13:Perishable Lesser Healing Potion
268881:1:0:5:Perishable Minor Healing Potion
3332:1:4:9:Perrine's Boots
22384:4:2:63:Persuader
5347:1:2:35:Pestilent Wand
11825:1:0:41:Pet Bombling
13342:1:15:20:Pet Fish
13343:1:15:20:Pet Stone
7961:3:2:49:Phantom Blade
210781:3:4:30:Phoenix Bindings
4331:2:4:25:Phoenix Gloves
4317:2:4:25:Phoenix Pants
19305:1:0:25:Pickled Kodo Foot
7358:2:4:28:Pilferer's Gloves
263512:1:0:15:Pincer Bites
10290:1:7:50:Pink Dye
10055:1:4:47:Pink Mageweave Shirt
22114:1:15:20:Pink Murloc Egg
2414:3:15:40:Pinto Bridle
6517:1:4:10:Pioneer Belt
6518:1:4:11:Pioneer Boots
6519:1:4:10:Pioneer Bracers
7109:1:4:9:Pioneer Buckler
6520:1:4:9:Pioneer Cloak
6521:1:4:11:Pioneer Gloves
9276:1:15:45:Pirate's Footlocker
249426:2:7:60:Pitchblende
5238:1:2:45:Pitchwood Wand
2057:1:2:4:Pitted Defias Shortsword
279951:1:0:60:Plague Doctor's Laboratory
13466:1:7:57:Plaguebloom
280697:1:15:30:Plagued Cockroach
221280:4:15:1:Plagues Deck
274976:1:0:35:Plain Ol' Paletusk
2612:1:4:8:Plain Robe
12835:3:9:63:Plans: Annihilator
12834:3:9:63:Plans: Arcanite Champion
12838:3:9:63:Plans: Arcanite Reaper
7981:2:9:36:Plans: Barbaric Iron Boots
7979:2:9:32:Plans: Barbaric Iron Breastplate
7982:2:9:37:Plans: Barbaric Iron Gloves
7980:2:9:35:Plans: Barbaric Iron Helm
7978:2:9:32:Plans: Barbaric Iron Shoulders
22220:3:9:70:Plans: Black Grasp of the Destroyer
12825:2:9:56:Plans: Blazing Rapier
7992:2:9:44:Plans: Blue Glittering Axe
3609:2:9:10:Plans: Copper Chain Vest
12830:1:9:58:Plans: Corruption
11612:3:9:57:Plans: Dark Iron Plate
11610:3:9:53:Plans: Dark Iron Pulverizer
11611:3:9:55:Plans: Dark Iron Sunderer
20554:3:9:63:Plans: Darkrune Breastplate
20553:3:9:63:Plans: Darkrune Gauntlets
20555:3:9:63:Plans: Darkrune Helm
12821:3:9:55:Plans: Dawn's Edge
12698:3:9:58:Plans: Dawnbringer Shoulders
7993:2:9:48:Plans: Dazzling Mithril Rapier
2883:2:9:25:Plans: Deadly Bronze Poniard
251745:3:9:1:Plans: Earthcrusher's Adaptive Armguards
251744:3:9:1:Plans: Earthcrusher's Adaptive Chestplate
251746:3:9:1:Plans: Earthcrusher's Adaptive Girdle
251760:3:9:1:Plans: Earthweaver's Adaptive Links
251759:3:9:1:Plans: Earthweaver's Adaptive Plate
251761:3:9:1:Plans: Earthweaver's Adaptive Waistguard
17706:2:9:38:Plans: Edge of Winter
12824:2:9:56:Plans: Enchanted Battlehammer
228311:2:9:56:Plans: Finely-Enchanted Battlehammer
3868:2:9:40:Plans: Frost Tiger Blade
12836:3:9:63:Plans: Frostguard
3610:2:9:15:Plans: Gemmed Copper Gauntlets
3867:2:9:34:Plans: Golden Iron Destroyer
3875:3:9:40:Plans: Golden Scale Boots
217276:3:9:40:Plans: Golden Scale Boots
217280:1:9:38:Plans: Golden Scale Coif
3873:2:9:39:Plans: Golden Scale Cuirass
217278:2:9:39:Plans: Golden Scale Cuirass
9367:2:9:41:Plans: Golden Scale Gauntlets
217274:2:9:41:Plans: Golden Scale Gauntlets
3872:2:9:34:Plans: Golden Scale Leggings
217286:2:9:34:Plans: Golden Scale Leggings
3871:3:9:35:Plans: Golden Scale Shoulders
217284:3:9:35:Plans: Golden Scale Shoulders
3611:2:9:29:Plans: Green Iron Boots
3612:2:9:30:Plans: Green Iron Gauntlets
3870:2:9:32:Plans: Green Iron Shoulders
12833:3:9:63:Plans: Hammer of the Titans
228310:3:9:63:Plans: Hardened Frostguard
12162:1:9:32:Plans: Hardened Iron Shortsword
12839:3:9:63:Plans: Heartseeker
7990:2:9:49:Plans: Heavy Mithril Helm
7975:2:9:42:Plans: Heavy Mithril Pants
10713:1:9:40:Plans: Inlaid Mithril Cylinder
228312:4:9:63:Plans: Invincible Mail
5543:2:9:28:Plans: Iridescent Hammer
6045:2:9:33:Plans: Iron Counterweight
6044:2:9:30:Plans: Iron Shield Spike
6735:2:9:20:Plans: Ironforge Breastplate
3866:2:9:35:Plans: Jade Serpentblade
12717:4:9:61:Plans: Lionheart Helm
12837:3:9:63:Plans: Masterwork Stormhammer
3608:2:9:29:Plans: Mighty Iron Hammer
7991:3:9:47:Plans: Mithril Plate Shoulders
7976:3:9:43:Plans: Mithril Shield Spike
7989:2:9:47:Plans: Mithril Spurs
217282:1:9:36:Plans: Moonsteel Broadsword
22390:4:9:63:Plans: Persuader
3874:2:9:37:Plans: Polished Steel Boots
12685:2:9:52:Plans: Radiant Belt
12697:2:9:58:Plans: Radiant Boots
12689:2:9:54:Plans: Radiant Breastplate
12702:2:9:59:Plans: Radiant Circlet
12695:2:9:57:Plans: Radiant Gloves
12713:2:9:61:Plans: Radiant Leggings
228117:3:9:63:Plans: Refined Arcanite Champion
228114:3:9:63:Plans: Refined Arcanite Reaper
2881:2:9:18:Plans: Runed Copper Breastplate
8028:3:9:49:Plans: Runed Mithril Hammer
22389:4:9:64:Plans: Sageblade
228315:4:9:64:Plans: Sageblade of the Archmagus
238324:3:9:1:Plans: Scarlet Soldier's Chestplate
238326:3:9:1:Plans: Scarlet Soldier's Grips
238322:3:9:1:Plans: Scarlet Soldier's Helmet
238328:3:9:1:Plans: Scarlet Soldier's Legplates
238325:3:9:1:Plans: Scarlet Soldier's Protectors
238323:3:9:1:Plans: Scarlet Soldier's Spaulders
238329:3:9:1:Plans: Scarlet Soldier's Stompers
238327:3:9:1:Plans: Scarlet Soldier's Waistguard
12261:2:9:38:Plans: Searing Golden Blade
12827:2:9:57:Plans: Serenity
3869:2:9:40:Plans: Shadow Crescent Axe
5578:2:9:26:Plans: Silvered Bronze Breastplate
10424:2:9:31:Plans: Silvered Bronze Leggings
2882:2:9:25:Plans: Silvered Bronze Shoulders
227905:3:9:63:Plans: Skyrider's Masterwork Stormhammer
6046:2:9:38:Plans: Steel Weapon Chain
228118:4:9:62:Plans: Stronger-hold Gauntlets
228250:4:9:62:Plans: Stronger-hold Gauntlets
12720:4:9:62:Plans: Stronghold Gauntlets
18592:4:9:63:Plans: Sulfuron Hammer
227727:4:9:63:Plans: Sulfuron Hammer
227901:3:9:57:Plans: Tempered Dark Iron Plate
228313:3:9:59:Plans: Tempest Gauntlets
22222:3:9:72:Plans: Thick Obsidian Breastplate
12682:2:9:50:Plans: Thorium Armor
12683:2:9:50:Plans: Thorium Belt
12693:2:9:56:Plans: Thorium Boots
12684:2:9:51:Plans: Thorium Bracers
12694:2:9:56:Plans: Thorium Helm
12704:2:9:60:Plans: Thorium Leggings
12692:2:9:55:Plans: Thorium Shield Spike
22388:4:9:61:Plans: Titanic Leggings
12828:2:9:58:Plans: Volcanic Hammer
228314:3:9:61:Plans: Warcrest of the Great Chief
12711:3:9:60:Plans: Whitesoul Helm
286152:1:0:45:Plated Armorfish
8094:1:4:50:Platemail Armor
8088:1:4:50:Platemail Belt
8089:1:4:50:Platemail Boots
8090:1:4:50:Platemail Bracers
8091:1:4:50:Platemail Gloves
8092:1:4:50:Platemail Helm
8093:1:4:50:Platemail Leggings
22155:1:15:1:Pledge of Adoration: Darnassus
22154:1:15:1:Pledge of Adoration: Ironforge
22156:1:15:1:Pledge of Adoration: Orgrimmar
21975:1:15:1:Pledge of Adoration: Stormwind
22158:1:15:1:Pledge of Adoration: Thunder Bluff
22157:1:15:1:Pledge of Adoration: Undercity
22159:1:15:1:Pledge of Friendship: Darnassus
22160:1:15:1:Pledge of Friendship: Ironforge
22161:1:15:1:Pledge of Friendship: Orgrimmar
22178:1:15:1:Pledge of Friendship: Stormwind
22162:1:15:1:Pledge of Friendship: Thunder Bluff
22163:1:15:1:Pledge of Friendship: Undercity
22120:1:15:1:Pledge of Loyalty: Darnassus
22119:1:15:1:Pledge of Loyalty: Ironforge
22123:1:15:1:Pledge of Loyalty: Orgrimmar
22117:1:15:1:Pledge of Loyalty: Stormwind
22122:1:15:1:Pledge of Loyalty: Thunder Bluff
22121:1:15:1:Pledge of Loyalty: Undercity
13932:1:0:45:Poached Sunscale Salmon
269503:2:4:60:Poacher Boots
5823:1:0:15:Poisonous Mushroom
22781:1:15:1:Polar Bear Collar
22663:4:4:80:Polar Bracers
22662:4:4:80:Polar Gloves
22661:4:4:80:Polar Tunic
2148:1:4:27:Polished Scale Belt
2149:1:4:27:Polished Scale Boots
2150:1:4:27:Polished Scale Bracers
2151:1:4:27:Polished Scale Gloves
2152:1:4:27:Polished Scale Leggings
2153:1:4:27:Polished Scale Vest
2505:1:2:4:Polished Shortbow
3846:2:4:37:Polished Steel Boots
213383:3:7:40:Polished Truesilver Gears
2208:1:2:19:Poniard
237023:1:0:1:Pop-Up Shrub
4403:1:0:33:Portable Bronze Mortar
224912:2:0:50:Portal Tuner Tuner
19277:4:12:1:Portals Deck
235275:4:15:1:Portals Deck
255715:1:7:36:Potent Anti-Venom
250955:1:0:55:Potion of Beast Slaying
9224:1:0:50:Potion of Demon Slaying
250954:1:0:55:Potion of Elemental Purging
274709:1:0:23:Potion of Experience - Level 23
274710:1:0:38:Potion of Experience - Level 38
274711:1:0:57:Potion of Experience - Level 57
274712:1:0:60:Potion of Experience - Level 60
1450:1:0:25:Potion of Fervor
3386:1:0:55:Potion of Poison Cleansing
250327:1:0:45:Potion of Predatory Senses
278069:1:0:60:Potion of Tradeskill Testing - Level 60
250950:1:0:55:Potion of Venomous Blood
19440:1:0:58:Powerful Anti-Venom
12804:1:7:55:Powerful Mojo
255719:1:7:58:Powerful Poultice
18594:1:0:55:Powerful Seaforium Charge
8546:1:0:50:Powerful Smelling Salts
6712:1:15:20:Practice Lock
8177:1:2:7:Practice Sword
15180:2:4:53:Praetorian Girdle
206466:1:0:1:Prairie Crown
205995:1:0:1:Prairie Dog Musk
10394:1:15:30:Prairie Dog Whistle
206469:1:0:1:Prairie Flower
277508:1:15:20:Prairie Wolf Pup Carrier
250075:1:0:55:Prehistoric Pulled Raptor
239092:1:12:1:Preposterously Prosed Postage
21213:2:15:40:Preserved Holly
14674:2:4:55:Pridelord Girdle
15005:1:4:9:Primal Bands
19767:1:7:60:Primal Bat Leather
19687:3:4:65:Primal Batskin Bracers
19686:3:4:65:Primal Batskin Gloves
19685:3:4:65:Primal Batskin Jerkin
15003:1:4:8:Primal Belt
15004:1:4:9:Primal Boots
15006:1:4:9:Primal Buckler
15007:1:4:8:Primal Cape
15008:1:4:10:Primal Mitts
19768:1:7:60:Primal Tiger Leather
154:1:4:1:Primitive Mantle
6134:1:4:1:Primitive Mantle
5743:2:4:40:Prismstone Ring
18335:3:12:1:Pristine Black Diamond
249428:2:7:45:Pristine Hide
249427:2:7:25:Pristine Leather
260624:1:0:45:Pristine Peach
249429:2:7:60:Pristine Scale
252606:4:4:61:Pristine Scorpid Leggings
205943:1:0:1:Prophecy of a Desecrated Citadel
238637:1:0:65:Prowler Steak
19813:2:12:1:Punctured Voodoo Doll
19814:2:12:1:Punctured Voodoo Doll
19815:2:12:1:Punctured Voodoo Doll
19816:2:12:1:Punctured Voodoo Doll
19817:2:12:1:Punctured Voodoo Doll
19818:2:12:1:Punctured Voodoo Doll
19819:2:12:1:Punctured Voodoo Doll
19820:2:12:1:Punctured Voodoo Doll
19821:2:12:1:Punctured Voodoo Doll
252030:1:0:15:Pungent Skycheddar
13462:1:0:57:Purification Potion
4342:1:7:50:Purple Dye
19712:3:12:61:Purple Hakkari Bijou
8831:1:7:42:Purple Lotus
13323:3:15:40:Purple Mechanostrider
17308:1:0:5:Purple Ribboned Holiday Gift
17307:1:0:5:Purple Ribboned Wrapping Paper
21575:1:15:1:Purple Rocket Cluster
265840:4:15:60:Purple Skeletal Horse
18791:4:15:60:Purple Skeletal Warhorse
3262:1:2:3:Putrid Wooden Hammer
6210:1:13:1:PVP - Alliance Mine Deed
6208:1:13:1:PVP - Alliance Tower Plans
6209:1:13:1:PVP - Horde Mine Deed
6207:1:13:1:PVP - Horde Tower Plans
16035:1:4:60:PVP Cloth Helm Horde
16037:1:4:60:PVP Cloth Legs Horde
16036:1:4:60:PVP Cloth Robe Horde
16038:1:4:60:PVP Cloth Shoulder Horde
16030:1:4:60:PVP Plate Boots Alliance
16027:1:4:60:PVP Plate Breastplate Alliance
16034:1:4:60:PVP Plate Cloak Alliance
16029:1:4:60:PVP Plate Gauntlets Alliance
16026:1:4:60:PVP Plate Helm Alliance
16028:1:4:60:PVP Plate Legplates Alliance
16031:1:4:60:PVP Plate Shoulder Alliance
16033:1:4:60:PVP Plate Wrist Alliance
249391:2:7:25:Pyrite
232343:1:0:1:QAEnchant Shield - Law of Nature
854:1:2:16:Quarter Staff
288927:4:4:30:Quick Strike Ring
8217:2:11:45:Quickdraw Quiver
5008:2:4:36:Quicksilver Ring
280797:1:15:20:Rabbit Crate (Arctic)
280801:1:15:20:Rabbit Crate (Brown)
8497:1:15:20:Rabbit Crate (Snowshoe)
208180:1:0:1:Rabbit Musk
12416:2:4:52:Radiant Belt
12419:2:4:58:Radiant Boots
12415:2:4:54:Radiant Breastplate
12417:2:4:59:Radiant Circlet
12418:2:4:57:Radiant Gloves
12420:2:4:61:Radiant Leggings
4032:1:4:50:Radiant Relic Hammer
21033:1:0:55:Radish Kimchi
5631:1:0:14:Rage Potion
250073:1:0:35:Raging Raptor Ribs
189426:1:15:1:Raid Consumables
2496:1:2:8:Raider Shortsword
10407:1:4:21:Raider's Shoulderpads
5095:1:0:15:Rainbow Fin Albacore
15975:2:4:31:Raincaller Scepter
3685:1:7:22:Raptor Egg
12184:1:7:30:Raptor Flesh
4461:1:7:30:Raptor Hide
4456:2:4:33:Raptor Hide Belt
4455:2:4:33:Raptor Hide Harness
5342:1:0:18:Raptor Punch
250076:1:0:45:Raptor Rouladen
1623:1:1:35:Raptor Skin Pouch
6147:2:4:12:Ratty Old Belt
4608:1:0:45:Raw Black Truffle
6291:1:7:5:Raw Brilliant Smallfish
6308:1:7:25:Raw Bristle Whisker Catfish
13754:1:7:45:Raw Glossy Mightfish
21153:1:7:40:Raw Greater Sagefish
6317:1:7:15:Raw Loch Frenzy
6289:1:7:15:Raw Longjaw Mud Snapper
8365:1:7:35:Raw Mithril Head Trout
13759:1:7:45:Raw Nightfin Snapper
13890:1:12:55:Raw Plated Armorfish
6361:1:7:15:Raw Rainbow Fin Albacore
13758:1:7:45:Raw Redgill
6362:1:7:35:Raw Rockscale Cod
21071:1:7:20:Raw Sagefish
6303:1:7:5:Raw Slitherskin Mackerel
8959:1:7:55:Raw Spinefin Halibut
4603:1:7:45:Raw Spotted Yellowtail
13756:1:7:45:Raw Summer Bass
13760:1:7:45:Raw Sunscale Salmon
13889:1:7:55:Raw Whitescale Salmon
13755:1:0:45:Raw Winter Squid
3030:1:6:30:Razor Arrow
12990:3:2:23:Razor's Edge
17747:1:0:50:Razorlash Root
19699:2:12:1:Razzashi Coin
279950:1:0:4:Reagent Bot
13949:1:9:55:Recipe: Baked Salmon
2889:1:9:8:Recipe: Beer Basted Boar Ribs
3679:1:9:15:Recipe: Blood Sausage
6325:1:9:5:Recipe: Brilliant Smallfish
6330:1:9:25:Recipe: Bristle Whisker Catfish
5528:1:9:20:Recipe: Clam Chowder
250368:1:9:1:Recipe: Cleric's Elixir
2698:1:9:15:Recipe: Cooked Crab Claw
13940:1:9:45:Recipe: Cooked Glossy Mightfish
12226:1:9:5:Recipe: Crispy Bat Wing
5488:1:9:20:Recipe: Crispy Lizard Tail
3681:1:9:25:Recipe: Crocolisk Gumbo
3678:1:9:15:Recipe: Crocolisk Steak
3682:1:9:25:Recipe: Curiously Tasty Omelet
232437:1:9:55:Recipe: Darkclaw Bisque
5487:1:9:20:Recipe: Dig Rat Stew
21025:4:9:60:Recipe: Dirge's Kickin' Chimaerok Chops
12239:1:9:40:Recipe: Dragonbreath Chili
9297:2:9:48:Recipe: Draught of Dream Vision
17201:1:9:10:Recipe: Egg Nog
13481:2:9:55:Recipe: Elixir of Brute Force
210709:2:9:25:Recipe: Elixir of Coalesced Regret
3832:2:9:39:Recipe: Elixir of Detect Lesser Invisibility
250370:1:9:1:Recipe: Elixir of Fortitude
17709:1:9:38:Recipe: Elixir of Frost Power
6663:2:9:18:Recipe: Elixir of Giant Growth
9298:2:9:49:Recipe: Elixir of Giants
21547:2:9:50:Recipe: Elixir of Greater Firepower
250389:1:9:1:Recipe: Elixir of Intellect
3396:2:9:28:Recipe: Elixir of Lesser Agility
3830:1:9:35:Recipe: Elixir of Lesser Fortitude
2553:2:9:12:Recipe: Elixir of Minor Agility
250380:1:9:1:Recipe: Elixir of Minor Spirit
6211:1:9:30:Recipe: Elixir of Ogre's Strength
9301:2:9:50:Recipe: Elixir of Shadow Power
250382:1:9:1:Recipe: Elixir of Spirit
250385:1:9:1:Recipe: Elixir of Strength
13478:1:9:53:Recipe: Elixir of Superior Defense
13491:2:9:56:Recipe: Elixir of the Mongoose
13479:2:9:54:Recipe: Elixir of the Sages
13941:1:9:45:Recipe: Filet of Redgill
5485:1:9:15:Recipe: Fillet of Frenzy
13522:2:9:60:Recipe: Flask of Chromatic Resistance
13520:2:9:60:Recipe: Flask of Distilled Wisdom
13518:2:9:60:Recipe: Flask of Petrification
13521:2:9:60:Recipe: Flask of Supreme Power
13519:2:9:60:Recipe: Flask of the Titans
5642:1:9:30:Recipe: Free Action Potion
6039:1:9:35:Recipe: Giant Clam Scorcho
9296:2:9:48:Recipe: Gift of Arthas
17200:1:9:5:Recipe: Gingerbread Cookie
10644:1:9:42:Recipe: Goblin Rocket Fuel
3683:1:9:25:Recipe: Gooey Spider Cake
2697:1:9:15:Recipe: Goretusk Liver Pie
5643:1:9:35:Recipe: Great Rage Potion
13493:2:9:57:Recipe: Greater Arcane Elixir
13497:2:9:58:Recipe: Greater Arcane Protection Potion
13494:2:9:58:Recipe: Greater Fire Protection Potion
13495:2:9:58:Recipe: Greater Frost Protection Potion
13500:2:9:58:Recipe: Greater Holy Protection Potion
13496:2:9:58:Recipe: Greater Nature Protection Potion
13499:2:9:58:Recipe: Greater Shadow Protection Potion
13490:2:9:56:Recipe: Greater Stoneshield Potion
13942:1:9:48:Recipe: Grilled Squid
20075:1:9:30:Recipe: Heavy Crocolisk Stew
13943:1:9:48:Recipe: Hot Smoked Bass
5657:1:9:24:Recipe: Instant Toxin
9295:2:9:47:Recipe: Invisibility Potion
5482:1:9:5:Recipe: Kaldorei Spider Kabob
250983:1:9:1:Recipe: Lesser Frenzy Potion
250989:1:9:1:Recipe: Lesser Mender's Potion
250977:1:9:1:Recipe: Lesser Spellblasting Potion
4624:1:9:43:Recipe: Lesser Stoneshield Potion
3395:2:9:50:Recipe: Limited Invulnerability Potion
13947:1:9:55:Recipe: Lobster Stew
6329:1:9:15:Recipe: Loch Frenzy Delight
6328:1:9:15:Recipe: Longjaw Mud Snapper
9293:2:9:42:Recipe: Magic Resistance Potion
18257:3:9:60:Recipe: Major Rejuvenation Potion
13948:1:9:55:Recipe: Mightfish Steak
13476:2:9:51:Recipe: Mighty Rage Potion
250366:1:9:1:Recipe: Minor Cleric's Elixir
250982:1:9:1:Recipe: Minor Frenzy Potion
250375:1:9:1:Recipe: Minor Mageblood Elixir
3393:1:9:22:Recipe: Minor Magic Resistance Potion
250988:1:9:1:Recipe: Minor Mender's Potion
250976:1:9:1:Recipe: Minor Spellblasting Potion
17062:1:9:30:Recipe: Mithril Head Trout
16110:1:9:45:Recipe: Monster Omelet
3680:1:9:25:Recipe: Murloc Fin Soup
13945:1:9:50:Recipe: Nightfin Soup
9303:1:9:45:Recipe: Philosopher's Stone
263513:1:9:15:Recipe: Pincer Bites
13946:1:9:50:Recipe: Poached Sunscale Salmon
3394:1:9:24:Recipe: Potion of Poison Cleansing
250363:1:9:1:Recipe: Potion of Predatory Senses
13492:2:9:57:Recipe: Purification Potion
5640:1:9:14:Recipe: Rage Potion
6368:1:9:15:Recipe: Rainbow Fin Albacore
2699:1:9:20:Recipe: Redridge Goulash
5484:1:9:10:Recipe: Roasted Kodo Meat
6369:1:9:30:Recipe: Rockscale Cod
21219:1:9:35:Recipe: Sagefish Delight
6661:2:9:18:Recipe: Savory Deviate Delight
251526:2:9:18:Recipe: Savory Whimsyfin Delight
5483:1:9:8:Recipe: Scorpid Surprise
2701:1:9:25:Recipe: Seasoned Wolf Kabob
263511:1:9:15:Recipe: Skywall Souffle
6326:1:9:5:Recipe: Slitherskin Mackerel
6892:1:9:13:Recipe: Smoked Bear Meat
232443:1:9:45:Recipe: Smoked Redgill
21099:1:9:15:Recipe: Smoked Sagefish
3737:1:9:30:Recipe: Soothing Turtle Bisque
16111:1:9:45:Recipe: Spiced Chili Crab
13939:1:9:45:Recipe: Spotted Yellowtail
5486:1:9:15:Recipe: Strider Stew
2700:1:9:20:Recipe: Succulent Pork Ribs
250986:1:9:1:Recipe: Superior Frenzy Potion
13477:1:9:52:Recipe: Superior Mana Potion
250992:1:9:1:Recipe: Superior Mender's Potion
250980:1:9:1:Recipe: Superior Spellblasting Potion
2555:2:9:15:Recipe: Swiftness Potion
3736:1:9:30:Recipe: Tasty Lion Steak
18046:1:9:45:Recipe: Tender Wolf Steak
7678:1:9:15:Recipe: Thistle Tea
12958:1:9:55:Recipe: Transmute Arcanite
13489:2:9:55:Recipe: Transmute Earth to Life
9304:1:9:45:Recipe: Transmute Iron to Gold
284871:1:9:55:Recipe: Transmute Legionite
13488:2:9:55:Recipe: Transmute Life to Earth
13486:2:9:55:Recipe: Transmute Undeath to Water
13487:2:9:55:Recipe: Transmute Water to Undeath
3831:1:9:36:Recipe: Troll's Blood Elixir
728:1:9:15:Recipe: Westfall Stew
9294:2:9:45:Recipe: Wildvine Potion
40:1:4:1:Recruit's Boots
6122:1:4:1:Recruit's Boots
38:1:4:1:Recruit's Shirt
6120:1:4:1:Recruit's Shirt
13324:3:15:40:Red & Blue Mechanostrider
252032:1:0:15:Red Delicious Stormapple
19054:1:15:20:Red Dragon Orb
15414:1:7:60:Red Dragonscale
15047:3:4:61:Red Dragonscale Breastplate
252603:4:4:61:Red Dragonscale Leggings
2604:1:7:10:Red Dye
9318:1:0:20:Red Firework
288338:1:0:20:Red Firework
5740:1:0:20:Red Fireworks Rocket
280795:1:15:30:Red Ground Squirrel Whistle
19707:3:12:61:Red Hakkari Bijou
21305:1:15:1:Red Helper Box
19224:1:0:35:Red Hot Wings
2657:1:1:15:Red Leather Bag
3533:1:4:1:Red Leather C03 Boots
3535:1:4:1:Red Leather C03 Bracers
3528:1:4:1:Red Leather C03 Breastplate
5762:1:1:5:Red Linen Bag
2572:2:4:10:Red Linen Robe
2575:1:4:10:Red Linen Shirt
6239:2:4:12:Red Linen Vest
10051:1:1:35:Red Mageweave Bag
10018:2:4:45:Red Mageweave Gloves
10033:2:4:48:Red Mageweave Headband
10009:2:4:43:Red Mageweave Pants
10029:2:4:47:Red Mageweave Shoulders
10007:2:4:43:Red Mageweave Vest
8563:3:15:40:Red Mechanostrider
11186:1:12:1:Red Power Crystal
5043:1:0:5:Red Ribboned Gift
5042:1:0:5:Red Ribboned Wrapping Paper
21576:1:15:1:Red Rocket Cluster
3419:1:4:20:Red Rose
17969:2:15:1:Red Sack of Gems
13331:3:15:40:Red Skeletal Horse
8624:1:4:10:Red Sparkler
9314:1:0:20:Red Streaks Firework
288339:1:0:20:Red Streaks Firework
6796:1:4:35:Red Swashbuckler's Shirt
13899:1:4:20:Red Traditional Hanbok
7284:2:4:24:Red Whelp Gloves
7287:1:7:1:Red Whelp Scale
34085:1:4:1:Red Winter Clothes
12203:1:7:30:Red Wolf Meat
5763:1:1:15:Red Woolen Bag
4313:2:4:20:Red Woolen Boots
9317:1:0:20:Red, White and Blue Firework
4605:1:0:15:Red-speckled Mushroom
1082:1:0:15:Redridge Goulash
15409:1:7:50:Refined Deeprock Salt
17967:3:7:60:Refined Scale of Onyxia
9718:3:2:38:Reforged Blade of Heroes
159:1:0:5:Refreshing Spring Water
269682:3:15:40:Regal Galestrider
7555:2:4:45:Regal Star
3026:1:2:21:Reinforced Bow
2471:1:4:50:Reinforced Leather Belt
2473:1:4:50:Reinforced Leather Boots
2474:1:4:50:Reinforced Leather Bracers
3893:1:4:50:Reinforced Leather Cap
2475:1:4:50:Reinforced Leather Gloves
2472:1:4:50:Reinforced Leather Pants
2470:1:4:50:Reinforced Leather Vest
2580:2:4:12:Reinforced Linen Cape
13918:1:15:55:Reinforced Locked Chest
4638:2:15:45:Reinforced Steel Lockbox
2442:1:4:27:Reinforced Targe
17192:1:4:24:Reinforced Targe
4315:2:4:24:Reinforced Woolen Shoulders
8630:1:15:40:Reins of the Bengal Tiger
12302:4:15:60:Reins of the Frostsaber
12327:3:15:40:Reins of the Golden Sabercat
8633:1:15:40:Reins of the Leopard
8627:1:15:40:Reins of the Night saber
12303:4:15:60:Reins of the Nightsaber
12325:3:15:40:Reins of the Primal Leopard
8632:3:15:40:Reins of the Spotted Frostsaber
8628:1:15:40:Reins of the Spotted Nightsaber
274706:3:15:40:Reins of the Striped Dawnsaber
8631:3:15:40:Reins of the Striped Frostsaber
8629:3:15:40:Reins of the Striped Nightsaber
18768:4:15:60:Reins of the Swift Dawnsaber
18766:4:15:60:Reins of the Swift Frostsaber
18767:4:15:60:Reins of the Swift Mistsaber
18902:4:15:60:Reins of the Swift Stormsaber
12326:3:15:40:Reins of the Tawny Sabercat
11078:1:13:1:Relic Coffer Key
3002:1:4:30:Relic Horn of Justice
2923:1:4:25:Relic of Righteousness
2919:1:4:30:Relic of the Ancients
3004:1:4:15:Relic of the Dead
3003:1:4:10:Relic of the Eye
3791:1:4:40:Relic of the Light
3005:1:4:20:Relic of Truth
3789:1:4:35:Relic Stone of Piety
279949:1:0:28:Repair Bot
15988:2:4:63:Resplendent Orb
9030:1:0:42:Restorative Potion
2894:1:0:1:Rhapsody Malt
289303:4:2:40:Rhok'delar, Longbow of the Ancient Keepers
278118:1:0:35:Rich Broth
4335:1:4:37:Rich Purple Silk Shirt
15904:1:2:35:Right-Handed Blades
15905:1:2:15:Right-Handed Brass Knuckles
15903:1:2:25:Right-Handed Claw
12811:2:7:60:Righteous Orb
279268:4:4:65:Rime-encrusted Boots
288931:4:4:30:Ring of Spell Power
1462:2:4:25:Ring of the Shadow
2441:1:4:22:Ringed Buckler
17188:1:4:19:Ringed Buckler
5057:1:0:5:Ripe Watermelon
14126:1:4:23:Ritual Amice
15972:2:4:24:Ritual Stein
12210:1:0:25:Roast Raptor
2681:1:0:10:Roasted Boar Meat
5474:1:0:10:Roasted Kodo Meat
8952:1:0:55:Roasted Quail
2614:1:4:17:Robe of Apprenticeship
14136:3:4:57:Robe of Winter Night
5770:2:4:30:Robes of Arcana
279266:4:4:65:Robes of Fiery Devastation
6206:1:2:17:Rock Chipper
279948:1:0:28:Rock Garden
2026:1:2:21:Rock Hammer
2065:1:2:9:Rockjaw Blade
4594:1:0:35:Rockscale Cod
2282:1:2:10:Rodentia Shortsword
22174:1:15:1:Romantic Poem
2534:1:2:44:Rondel
249867:1:0:25:Root Tea
10503:2:4:46:Rose Colored Goggles
249424:2:7:45:Rosecap
2512:1:6:5:Rough Arrow
4357:1:7:5:Rough Blasting Powder
4362:2:2:10:Rough Boomstick
2483:1:2:3:Rough Broad Axe
6350:2:4:18:Rough Bronze Boots
2867:2:4:23:Rough Bronze Bracers
2866:2:4:23:Rough Bronze Cuirass
2865:2:4:21:Rough Bronze Leggings
3480:2:4:22:Rough Bronze Shoulders
4360:1:0:14:Rough Copper Bomb
277672:2:4:10:Rough Copper Chain Boots
10421:2:4:10:Rough Copper Vest
4358:1:0:10:Rough Dynamite
3470:1:7:10:Rough Grinding Stone
1839:1:4:10:Rough Leather Belt
796:1:4:10:Rough Leather Boots
1840:1:4:10:Rough Leather Bracers
797:1:4:10:Rough Leather Gloves
798:1:4:10:Rough Leather Pants
799:1:4:10:Rough Leather Vest
2862:1:0:5:Rough Sharpening Stone
2835:1:7:5:Rough Stone
3239:1:0:5:Rough Weightstone
2377:1:4:10:Round Buckler
17185:1:4:8:Round Buckler
13898:1:4:50:Royal Dangui
2546:2:4:13:Royal Frostmane Girdle
9914:2:4:48:Royal Scepter
16999:3:4:59:Royal Seal of Alexis
249866:1:0:15:Royal Tea
15564:1:0:50:Rugged Armor Kit
8171:1:7:50:Rugged Hide
8170:1:7:50:Rugged Leather
7280:2:4:11:Rugged Leather Pants
129:1:4:1:Rugged Trapper's Boots
148:1:4:1:Rugged Trapper's Shirt
3259:1:15:1:Ruined Bat Hide
2890:1:15:1:Ruined Boar Pelt
4756:1:15:1:Ruined Cat Pelt
6715:1:0:33:Ruined Jumper Cables
18636:1:0:53:Ruined Jumper Cables XL
2934:1:7:5:Ruined Leather Scraps
15696:1:12:1:Ruined Tome
2887:1:15:1:Ruined Wolf Pelt
21151:1:0:1:Rumsey Rum Black Label
21114:1:0:1:Rumsey Rum Dark
20709:1:0:1:Rumsey Rum Light
208767:2:0:1:Rune of Mending
3745:1:12:1:Rune of Opening
17032:1:15:40:Rune of Portals
17031:1:15:20:Rune of Teleportation
208764:2:0:1:Rune of the Mind
203992:2:0:1:Rune of Trickery
14341:1:7:50:Rune Thread
14047:1:7:50:Runecloth
14046:1:1:52:Runecloth Bag
14529:1:0:52:Runecloth Bandage
13856:2:4:51:Runecloth Belt
13864:2:4:56:Runecloth Boots
13860:2:4:53:Runecloth Cloak
254123:2:4:57:Runecloth Cuffs
13863:2:4:55:Runecloth Gloves
13866:2:4:59:Runecloth Headband
13865:2:4:57:Runecloth Pants
254079:1:1:52:Runecloth Reagent Bag
13858:2:4:52:Runecloth Robe
13867:2:4:61:Runecloth Shoulders
13857:2:4:52:Runecloth Tunic
2857:2:4:18:Runed Copper Belt
2854:2:4:19:Runed Copper Bracers
2864:2:4:18:Runed Copper Breastplate
3472:2:4:12:Runed Copper Gauntlets
3473:2:4:13:Runed Copper Pants
7946:2:2:49:Runed Mithril Hammer
20539:3:4:63:Runed Stygian Belt
20537:3:4:63:Runed Stygian Boots
20538:3:4:63:Runed Stygian Leggings
12613:2:4:62:Runic Breastplate
15090:2:4:62:Runic Leather Armor
15093:2:4:56:Runic Leather Belt
15092:2:4:55:Runic Leather Bracers
15091:2:4:54:Runic Leather Gauntlets
15094:2:4:58:Runic Leather Headband
15095:2:4:60:Runic Leather Pants
15096:2:4:62:Runic Leather Shoulders
12611:2:4:60:Runic Plate Boots
12612:2:4:61:Runic Plate Helm
12614:2:4:62:Runic Plate Leggings
12610:2:4:60:Runic Plate Shoulders
15945:2:4:18:Runic Stave
18255:1:0:55:Runn Tum Tuber
18254:1:0:45:Runn Tum Tuber Surprise
3593:1:4:37:Russet Belt
2432:1:4:37:Russet Boots
3594:1:4:37:Russet Bracers
2434:1:4:37:Russet Gloves
3889:1:4:37:Russet Hat
2431:1:4:37:Russet Pants
2429:1:4:37:Russet Vest
2387:1:4:5:Rusted Chain Belt
2389:1:4:5:Rusted Chain Boots
2390:1:4:5:Rusted Chain Bracers
2391:1:4:5:Rusted Chain Gloves
2388:1:4:5:Rusted Chain Leggings
2386:1:4:5:Rusted Chain Vest
2497:1:2:9:Rusted Claymore
280402:1:2:2:Rusty Dagger
4830:2:4:28:Saber Leggings
11938:1:15:1:Sack of Gems
22283:1:15:1:Sack of Homemade Bread
17029:1:15:60:Sacred Candle
2920:1:4:10:Sacred Relic
260799:1:7:35:SAF-T Bell
260805:1:0:48:SAF-T Bomb
260797:1:0:34:SAF-T Bronze Bomb
260804:1:7:43:SAF-T Casing
260814:1:0:50:SAF-T Clever Dynamite
260793:1:0:19:SAF-T Copper Bomb
260810:1:4:50:SAF-T Disposable Parachute
260792:1:0:25:SAF-T Dynamite
260820:2:4:60:SAF-T Emergency Ripper: Everlook
260798:1:0:35:SAF-T Jumbo Dynamite
260828:2:4:60:SAF-T Nitro Boosts
260784:1:7:5:SAF-T Tabs
260830:2:0:60:SAF-T Teleport
260813:1:7:55:SAF-T Tube
279272:3:0:65:SAF-T Ultra Precision Scope
15934:2:4:32:Sage's Stave
249870:1:0:55:Sage's Tea
22383:4:2:64:Sageblade
21217:1:0:55:Sagefish Delight
4289:1:7:10:Salt
15846:1:0:50:Salt Shaker
1164:1:9:1:Sam's Tome
19704:2:12:1:Sandfury Coin
249432:2:7:45:Sandpaper
20476:3:4:62:Sandstalker Bracers
20478:3:4:62:Sandstalker Breastplate
20477:3:4:62:Sandstalker Gauntlets
20424:1:7:55:Sandworm Meat
20423:1:7:1:Sandy Scorpid Claw
15947:2:4:28:Sanguine Star
22295:1:15:1:Satchel of Cards
22252:2:1:65:Satchel of Cenarius
15962:2:4:33:Satyr's Rod
1326:1:0:15:Sauteed Sunfish
22529:1:12:1:Savage Frond
12616:2:4:63:Savage Mail Boots
12617:2:4:63:Savage Mail Shoulders
12615:2:4:62:Savage Mail Tunic
6657:1:0:10:Savory Deviate Delight
260627:1:0:55:Savory Shen'dralar Steak
250065:1:0:45:Savory Stag Sliders
250068:1:0:55:Savory Turtle Stew
251525:1:0:10:Savory Whimsyfin Delight
15410:3:7:60:Scale of Onyxia
275617:3:4:58:Scalegut Belt
275616:3:4:58:Scalegut Clenchers
275618:3:4:58:Scalegut Treaders
1853:1:4:22:Scalemail Belt
287:1:4:22:Scalemail Boots
1852:1:4:22:Scalemail Bracers
718:1:4:22:Scalemail Gloves
286:1:4:22:Scalemail Pants
285:1:4:22:Scalemail Vest
21761:1:13:1:Scarab Coffer Key
268418:2:7:46:Scarce Herb Seeds
12973:1:13:1:Scarlet Cannonball
241089:2:2:10:Scarlet Dagger
241090:2:2:28:Scarlet Great Axe
3260:1:4:4:Scarlet Initiate Robes
208085:1:15:1:Scarlet Lieutenant Signet Ring
241086:1:4:5:Scarlet Tower Shield
17027:1:15:36:Scented Candle
20447:1:12:1:Scepter of Beckoning: Fire
20449:1:12:1:Scepter of Beckoning: Stone
20448:1:12:1:Scepter of Beckoning: Thunder
20450:1:12:1:Scepter of Beckoning: Water
16055:2:9:60:Schematic: Arcane Bomb
16054:2:9:60:Schematic: Arcanite Dragonling
18649:1:9:30:Schematic: Blue Firework
10601:2:9:35:Schematic: Bright-Eye Goggles
10603:2:9:44:Schematic: Catseye Ultra Goggles
4415:3:9:37:Schematic: Craftsman's Monocle
16049:2:9:57:Schematic: Dark Iron Bomb
16048:2:9:55:Schematic: Dark Iron Rifle
4413:2:9:32:Schematic: Discombobulator Ray
251748:2:9:1:Schematic: Enormous Tranquilizer Dart
264231:1:9:60:Schematic: EZ and SAF Field Transporter: Mt. Hyjal
264212:1:9:38:Schematic: EZ-Thro Bronze Mortar
264205:1:9:26:Schematic: EZ-Thro Copper Bomb XL
264227:1:9:60:Schematic: EZ-Thro Dark Bomb
6716:2:9:20:Schematic: EZ-Thro Dynamite
264229:1:9:60:Schematic: EZ-Thro Field Transporter: Gadgetzan
264211:1:9:38:Schematic: EZ-Thro Fireproof Fuse
264213:1:9:40:Schematic: EZ-Thro Grenade
264239:1:9:60:Schematic: EZ-Thro Magnetic Displacer
264228:1:9:60:Schematic: EZ-Thro Mana Bomb
264225:1:9:57:Schematic: EZ-Thro Shell
264226:1:9:57:Schematic: EZ-Thro Thorium Grenade
264218:1:9:48:Schematic: EZ-Thro Tru-Trigger
264204:1:9:20:Schematic: EZ-Thro Wrap
18235:1:9:60:Schematic: Field Repair Bot 74A
4411:2:9:25:Schematic: Flame Deflector
6672:2:9:37:Schematic: Flash Bomb
16056:2:9:61:Schematic: Flawless Arcanite Rifle
251749:2:9:1:Schematic: G.R.R.-Nade
18654:2:9:53:Schematic: Gnomish Alarm-O-Bot
18653:2:9:53:Schematic: Goblin Jumper Cables XL
4416:2:9:39:Schematic: Goblin Land Mine
7192:2:9:26:Schematic: Goblin Rocket Boots
18652:1:9:52:Schematic: Gyrofreeze Ice Reflector
18657:2:9:58:Schematic: Hyper-Radiant Flame Reflector
4417:2:9:40:Schematic: Large Seaforium Charge
16044:2:9:53:Schematic: Lifelike Mechanical Toad
18655:2:9:55:Schematic: Major Recombobulator
16053:2:9:58:Schematic: Master Engineer's Goggles
13311:1:9:40:Schematic: Mechanical Dragonling
4408:2:9:15:Schematic: Mechanical Squirrel
14639:1:9:28:Schematic: Minor Recombobulator
10604:2:9:44:Schematic: Mithril Heavy-bore Rifle
10609:1:9:50:Schematic: Mithril Mechanical Dragonling
4412:2:9:29:Schematic: Moonsight Rifle
264206:1:9:29:Schematic: No Slip SAF-T Padding
10606:2:9:45:Schematic: Parachute Cloak
4414:2:9:33:Schematic: Portable Bronze Mortar
18656:1:9:55:Schematic: Powerful Seaforium Charge
18647:1:9:30:Schematic: Red Firework
264209:1:9:35:Schematic: SAF-T Bell
264215:1:9:43:Schematic: SAF-T Bomb
264207:1:9:29:Schematic: SAF-T Bronze Bomb
264214:1:9:43:Schematic: SAF-T Casing
264224:1:9:50:Schematic: SAF-T Clever Dynamite
264203:1:9:11:Schematic: SAF-T Copper Bomb
264202:1:9:5:Schematic: SAF-T Dynamite
264230:1:9:60:Schematic: SAF-T Emergency Ripper: Everlook
264208:1:9:30:Schematic: SAF-T Jumbo Dynamite
264238:1:9:60:Schematic: SAF-T Nitro Boosts
264201:1:9:5:Schematic: SAF-T Tabs
264240:1:9:60:Schematic: SAF-T Teleport
264223:1:9:55:Schematic: SAF-T Tube
4410:2:9:24:Schematic: Shadow Goggles
264210:1:9:35:Schematic: Shafety Sheep
210178:2:9:25:Schematic: Shredder Autosalvage Unit
251747:2:9:1:Schematic: Sludge Suppressor
4409:2:9:20:Schematic: Small Seaforium Charge
10608:3:9:48:Schematic: Sniper Scope
17720:2:9:38:Schematic: Snowmaster 9000
10605:3:9:45:Schematic: Spellpower Goggles Xtreme
16045:2:9:54:Schematic: Spellpower Goggles Xtreme Plus
16041:1:9:52:Schematic: Thorium Grenade
16043:2:9:52:Schematic: Thorium Rifle
16051:2:9:57:Schematic: Thorium Shells
16042:1:9:52:Schematic: Thorium Widget
264219:1:9:48:Schematic: Tru-Trigger Frag Bomb
18658:2:9:60:Schematic: Ultra-Flash Shadow Reflector
284870:1:9:52:Schematic: Unsanctified Grenade
16052:2:9:58:Schematic: Voice Amplification Modulator
18661:2:9:52:Schematic: World Enlarger
2027:1:2:19:Scimitar
8243:1:0:1:Scooby Snack
14652:2:4:45:Scorpashi Sash
8154:1:7:45:Scorpid Scale
5466:1:7:8:Scorpid Stinger
5473:1:0:10:Scorpid Surprise
8393:1:12:1:Scorpok Pincer
6588:1:4:23:Scouting Spaulders
2128:1:2:4:Scratched Claymore
6494:1:12:1:Scrawled Parchment
282421:1:12:1:Scribbled Note
3012:1:0:20:Scroll of Agility
1477:1:0:35:Scroll of Agility II
4425:1:0:50:Scroll of Agility III
10309:1:0:65:Scroll of Agility IV
213549:1:0:15:Scroll of Arcane Angling
277493:1:0:40:Scroll of Cat Familiar
215257:1:0:15:Scroll of Comprehension
213551:1:0:15:Scroll of Controlled Displacement
217495:1:0:25:Scroll of Cryoblast
289088:1:0:30:Scroll of Endless Fortitude
289330:1:0:30:Scroll of Endless Speed
277483:1:0:25:Scroll of Frog Familiar
277499:1:0:55:Scroll of Greater Cryoblast
277494:2:0:40:Scroll of Imbue Accuracy
277487:2:0:25:Scroll of Imbue Baleflame
277496:2:0:40:Scroll of Imbue Balefrost
275067:2:0:15:Scroll of Imbue Chillknife
277497:2:0:40:Scroll of Imbue Flame
277485:2:0:25:Scroll of Imbue Frost
277500:2:0:55:Scroll of Imbue Greater Flame
277501:2:0:55:Scroll of Imbue Greater Frost
277488:2:0:25:Scroll of Imbue Iceknife
274947:2:0:15:Scroll of Imbue Lesser Flame
277498:2:0:40:Scroll of Imbue Manablade
277502:2:0:55:Scroll of Imbue Precision
277495:2:0:40:Scroll of Imbue Quickening
277489:2:0:25:Scroll of Imbue Spark
277503:2:0:55:Scroll of Imbue Spellbreak
277486:2:0:25:Scroll of Imbue Striking
955:1:0:15:Scroll of Intellect
2290:1:0:30:Scroll of Intellect II
4419:1:0:45:Scroll of Intellect III
10308:1:0:60:Scroll of Intellect IV
277492:1:0:40:Scroll of Khadgar's Unlocking
213548:1:0:40:Scroll of Liminal Passage
213564:1:0:15:Scroll of Minor Evocation
228227:4:0:60:Scroll of Overwhelming Power
3013:1:0:10:Scroll of Protection
1478:1:0:25:Scroll of Protection II
4421:1:0:40:Scroll of Protection III
10305:1:0:55:Scroll of Protection IV
275069:1:0:15:Scroll of Rat Familiar
211800:1:0:15:Scroll of Reintegration
220792:2:0:15:Scroll of Spatial Mending
1181:1:0:10:Scroll of Spirit
1712:1:0:25:Scroll of Spirit II
4424:1:0:40:Scroll of Spirit III
10306:1:0:55:Scroll of Spirit IV
1180:1:0:15:Scroll of Stamina
1711:1:0:30:Scroll of Stamina II
4422:1:0:45:Scroll of Stamina III
10307:1:0:60:Scroll of Stamina IV
954:1:0:20:Scroll of Strength
2289:1:0:35:Scroll of Strength II
4426:1:0:50:Scroll of Strength III
10310:1:0:65:Scroll of Strength IV
211786:1:0:10:Scroll: CHAP BALK WELLES
20518:1:12:1:Scroll: Create Crest of Beckoning
20526:1:12:1:Scroll: Create Crest of Beckoning
20527:1:12:1:Scroll: Create Crest of Beckoning
20528:1:12:1:Scroll: Create Crest of Beckoning
20540:1:12:1:Scroll: Create Scepter of Beckoning
20542:1:12:1:Scroll: Create Scepter of Beckoning
20543:1:12:1:Scroll: Create Scepter of Beckoning
20544:1:12:1:Scroll: Create Scepter of Beckoning
20531:1:12:1:Scroll: Create Signet of Beckoning
20532:1:12:1:Scroll: Create Signet of Beckoning
20533:1:12:1:Scroll: Create Signet of Beckoning
20535:1:12:1:Scroll: Create Signet of Beckoning
211785:1:0:10:Scroll: CWAL
281015:1:0:50:Scroll: DOST OREM
281016:1:0:50:Scroll: FORGOT HOOF THUD
281017:1:0:50:Scroll: KEEP CLEF FOCI
211780:1:0:10:Scroll: KWYJIBO
211787:1:0:10:Scroll: LOWER PING WHOMEVER
211854:1:0:20:Scroll: OMIT KESA
213545:1:0:30:Scroll: PEATCHY ATTAX
281018:1:0:50:Scroll: RARE SERVICHI RADAR
213546:1:0:30:Scroll: SHOOBEEDOOP
211855:1:0:20:Scroll: STHENIC LUNATE
213547:1:0:30:Scroll: THAW WORDS
213544:1:0:30:Scroll: TOPAZ YORAK
213543:1:0:30:Scroll: UPDOG
211853:1:0:20:Scroll: VOCE WELL
211784:1:0:20:Scroll: WUBBA WUBBA
2502:1:2:7:Scuffed Dagger
20767:1:15:40:Scum Covered Bag
262887:3:0:1:Sealed Apprentice's Writ
262890:3:0:1:Sealed Artisan's Writ
248206:3:0:1:Sealed Craftsman's Writ
6357:1:15:35:Sealed Crate
262889:3:0:1:Sealed Expert's Writ
262888:3:0:1:Sealed Journeyman's Writ
12260:2:2:39:Searing Golden Blade
275893:1:15:1:Searing Gourd
273295:1:7:45:Seasonal Fish Steaks
1017:1:0:25:Seasoned Wolf Kabob
217345:1:0:60:Sebacious Poison
12762:1:12:1:Secrecy of Plans
11115:1:13:1:Secret Safe Key
9327:2:12:1:Security DELTA Data Access Card
279947:1:0:60:Seed Hybridizer
7608:2:4:21:Seer's Fine Stein
4698:1:4:21:Seer's Mantle
5049:1:0:5:Self-locking Ironpaper
3448:1:0:15:Senggin Root
22140:1:15:1:Sentinel's Card
12781:3:2:57:Serenity
12258:2:4:44:Serpent Clasp Belt
19235:3:12:1:Seven of Beasts
221296:3:15:1:Seven of Dunes
19274:3:12:1:Seven of Elementals
221305:3:15:1:Seven of Nightmares
221287:3:15:1:Seven of Plagues
19283:3:12:1:Seven of Portals
19264:3:12:1:Seven of Warlords
221278:3:15:1:Seven of Wilds
279945:1:0:60:Sewing Machine
3856:2:2:40:Shadow Crescent Axe
4373:2:4:24:Shadow Goggles
4323:2:4:34:Shadow Hood
3824:1:0:34:Shadow Oil
6048:1:0:27:Shadow Protection Potion
10285:1:7:40:Shadow Silk
945:1:2:1:Shadow Sword
7428:1:7:30:Shadowcat Hide
10031:2:4:48:Shadoweave Boots
10023:2:4:45:Shadoweave Gloves
10025:2:4:49:Shadoweave Mask
10002:2:4:42:Shadoweave Pants
10004:2:4:43:Shadoweave Robe
10028:2:4:47:Shadoweave Shoulders
11885:1:12:60:Shadowforge Torch
1210:2:7:20:Shadowgem
18238:3:4:40:Shadowskin Gloves
260800:1:0:35:Shafety Sheep
12432:1:12:1:Shardtooth E'ko
2515:1:6:15:Sharp Arrow
5635:1:7:15:Sharp Claw
3135:1:2:16:Sharp Throwing Axe
279944:1:0:4:Sharpening Wheel
12904:2:4:61:Shawn's Super Special Swami Hat
22299:1:15:1:Sheaf of Cards
13545:1:12:1:Shellfish
18511:4:4:62:Shifting Cloak
6566:1:4:24:Shimmering Amice
2616:1:4:23:Shimmering Silk Robes
7558:2:4:25:Shimmering Stave
250542:2:4:45:Shining Mithril Boots
250540:2:4:45:Shining Mithril Breastplate
250545:2:4:49:Shining Mithril Gauntlet
250543:2:4:48:Shining Mithril Helm
250544:2:4:49:Shining Mithril Pants
250541:2:4:45:Shining Mithril Pauldrons
2870:3:4:29:Shining Silver Breastplate
16171:1:0:55:Shinsollo
6529:1:0:10:Shiny Bauble
17057:1:15:1:Shiny Fish Scales
4536:1:0:5:Shiny Red Apple
208007:1:13:1:Shipwreck Cache Key
3319:1:2:9:Short Sabre
15810:1:2:25:Short Spear
2132:1:2:4:Short Staff
275892:1:15:1:Short Stout
2131:1:2:3:Shortsword
210147:1:0:1:Shredder Autosalvage Unit
16645:1:12:1:Shredder Operating Manual - Page 1
16654:1:12:1:Shredder Operating Manual - Page 10
16655:1:12:1:Shredder Operating Manual - Page 11
16656:1:12:1:Shredder Operating Manual - Page 12
16646:1:12:1:Shredder Operating Manual - Page 2
16647:1:12:1:Shredder Operating Manual - Page 3
16648:1:12:1:Shredder Operating Manual - Page 4
16649:1:12:1:Shredder Operating Manual - Page 5
16650:1:12:1:Shredder Operating Manual - Page 6
16651:1:12:1:Shredder Operating Manual - Page 7
16652:1:12:1:Shredder Operating Manual - Page 8
16653:1:12:1:Shredder Operating Manual - Page 9
210146:1:0:1:Shredder Turbocharger
6299:1:0:5:Sickly Looking Fish
20432:1:12:1:Signet of Beckoning: Fire
20435:1:12:1:Signet of Beckoning: Stone
20433:1:12:1:Signet of Beckoning: Thunder
20436:1:12:1:Signet of Beckoning: Water
20384:1:12:1:Silithid Carapace Fragment
20498:1:7:55:Silithid Chitin
6450:1:0:1:Silk Bandage
4306:1:7:30:Silk Cloth
7050:2:4:32:Silk Headband
253973:1:1:25:Silk Reagent Bag
4291:1:7:30:Silken Thread
15964:2:4:44:Silksand Star
2842:2:7:10:Silver Bar
4404:1:7:18:Silver Contact
2618:1:4:50:Silver Dress Robes
19714:3:12:61:Silver Hakkari Bijou
272014:2:15:60:Silver Necklace
2775:2:7:10:Silver Ore
7342:1:4:30:Silver Piffeny Band
6338:1:7:20:Silver Rod
20860:2:12:1:Silver Scarab
15869:2:0:20:Silver Skeleton Key
3224:2:4:12:Silver-lined Bracers
4379:2:2:26:Silver-plated Shotgun
15928:2:4:31:Silver-thread Rod
3482:2:4:26:Silvered Bronze Boots
2869:2:4:26:Silvered Bronze Breastplate
3483:2:4:27:Silvered Bronze Gauntlets
10423:2:4:31:Silvered Bronze Leggings
3481:2:4:25:Silvered Bronze Shoulders
765:1:7:5:Silverleaf
9744:1:4:12:Simple Bands
10053:1:4:47:Simple Black Dress
15933:2:4:15:Simple Branch
9745:1:4:11:Simple Cape
9742:1:4:12:Simple Cord
4565:1:2:6:Simple Dagger
6786:1:4:10:Simple Dress
10284:1:7:30:Simple Flour
9746:1:4:13:Simple Gloves
10047:2:4:15:Simple Kilt
10046:1:4:9:Simple Linen Boots
10045:1:4:7:Simple Linen Pants
282422:1:12:1:Simple Note
255716:1:7:16:Simple Poultice
9743:1:4:12:Simple Shoes
3421:1:4:10:Simple Wildflowers
4470:1:7:5:Simple Wood
20737:1:15:1:Singed Corestone
215456:1:15:1:Singed Message
33154:2:15:1:Sinister Squashling
260633:1:0:25:Sip of Lemonale
19234:3:12:1:Six of Beasts
221295:3:15:1:Six of Dunes
19273:3:12:1:Six of Elementals
221304:3:15:1:Six of Nightmares
221286:3:15:1:Six of Plagues
19282:3:12:1:Six of Portals
19263:3:12:1:Six of Warlords
221277:3:15:1:Six of Wilds
2596:1:0:15:Skin of Dwarven Stout
7005:1:2:4:Skinning Knife
283389:1:12:1:Skonk's List
5045:1:0:45:Skull Gift
2066:1:2:8:Skull Hatchet
5047:1:0:40:Skull Wrapping Paper
19705:2:12:1:Skullsplitter Coin
263509:1:0:15:Skywall Souffle
240945:1:0:1:Slice of Carrie's Apple Pie
20766:1:15:30:Slimy Bag
5784:1:7:15:Slimy Murloc Scale
249872:1:0:15:Slimy Smoothie
787:1:0:10:Slitherskin Mackerel
260632:1:0:15:Slushberry Brandy
2102:1:11:1:Small Ammo Pouch
5523:1:7:10:Small Barnacled Clam
5571:1:1:5:Small Black Pouch
828:1:1:5:Small Blue Pouch
21558:1:15:1:Small Blue Rocket
14343:3:7:50:Small Brilliant Shard
4374:1:0:29:Small Bronze Bomb
4496:1:1:5:Small Brown Pouch
6353:1:15:15:Small Chest
6889:1:7:5:Small Egg
4402:1:7:25:Small Flame Sac
5134:1:12:1:Small Furry Paw
10978:3:7:20:Small Glimmering Shard
11138:3:7:30:Small Glowing Shard
4302:2:2:12:Small Green Dagger
5572:1:1:5:Small Green Pouch
21559:1:15:1:Small Green Rocket
2484:1:2:4:Small Knife
7279:1:11:5:Small Leather Ammo Pouch
6354:1:15:20:Small Locked Chest
5498:2:7:15:Small Lustrous Pearl
22202:1:7:1:Small Obsidian Shard
4656:1:0:5:Small Pumpkin
21560:1:15:1:Small Purple Rocket
5439:1:11:5:Small Quiver
11177:3:7:40:Small Radiant Shard
805:1:1:5:Small Red Pouch
21557:1:15:1:Small Red Rocket
11966:1:15:1:Small Sack of Coins
4367:1:0:20:Small Seaforium Charge
2133:1:4:5:Small Shield
17184:1:4:3:Small Shield
5441:1:11:5:Small Shot Pouch
4245:1:1:25:Small Silk Pack
5465:1:7:5:Small Spider Leg
1167:1:4:10:Small Targe
17186:1:4:8:Small Targe
2947:1:2:3:Small Throwing Knife
2498:1:2:8:Small Tomahawk
1475:1:7:1:Small Venom Sac
21561:1:15:1:Small White Rocket
2055:1:2:4:Small Wooden Hammer
21562:1:15:1:Small Yellow Rocket
6890:1:0:10:Smoked Bear Meat
20452:1:0:55:Smoked Desert Dumplings
232438:1:0:45:Smoked Redgill
21072:1:0:20:Smoked Sagefish
278121:1:0:25:Smoked Sausage
269504:1:1:52:Smoking Satchel
2410:1:4:1:Smoky Torch
5208:1:2:20:Smoldering Wand
12529:1:15:59:Smolderweb Carrier
5568:1:6:18:Smooth Pebble
19026:1:0:50:Snake Burst Firework
4538:1:0:25:Snapvine Watermelon
8391:1:12:1:Snickerfang Jowl
10548:1:0:48:Sniper Scope
17202:1:15:5:Snowball
21309:1:15:1:Snowman Kit
17716:1:0:38:Snowmaster 9000
2114:1:4:8:Snowy Robe
269830:1:15:20:Snowy Wolf Pup
250066:1:0:55:Soaring Pamplona
4601:1:0:45:Soft Banana Bread
4582:1:12:1:Soft Bushy Tail
5468:1:7:15:Soft Frenzy Flesh
4312:2:4:16:Soft-soled Linen Boots
6549:1:4:14:Soldier's Cloak
10505:1:7:35:Solid Blasting Powder
2510:1:2:3:Solid Blunderbuss
10507:1:0:35:Solid Dynamite
7966:1:7:35:Solid Grinding Stone
3851:2:2:31:Solid Iron Maul
7964:1:0:35:Solid Sharpening Stone
3033:1:6:30:Solid Shot
7912:1:7:35:Solid Stone
7965:1:0:35:Solid Weightstone
4261:2:4:10:Solliden's Trousers
4782:2:4:18:Solstice Robe
3713:1:7:30:Soothing Spices
3729:1:0:25:Soothing Turtle Bisque
6492:1:12:1:Sooty Parchment
9882:2:4:43:Sorcerer Sphere
3788:1:4:40:Soul Crystal Relic
11083:1:7:25:Soul Dust
20475:1:0:1:Soul Gem
21340:2:1:52:Soul Pouch
211427:3:12:1:Soul Vessel
19774:2:7:50:Souldarite
3703:1:0:1:Southshore Stout
11109:1:0:5:Special Chicken Feed
238641:2:0:65:Specklefin Feast
260629:1:0:1:Spectral Spirits
4684:1:4:13:Spellbinder Belt
2971:1:4:14:Spellbinder Boots
3643:1:4:14:Spellbinder Bracers
4683:1:4:13:Spellbinder Cloak
2972:1:4:14:Spellbinder Gloves
15926:2:4:17:Spellbinder Orb
250934:1:0:5:Spellblasting Potion
10502:2:4:43:Spellpower Goggles Xtreme
15999:2:4:54:Spellpower Goggles Xtreme Plus
19304:1:0:15:Spiced Beef Jerky
12216:1:0:35:Spiced Chili Crab
2680:1:0:10:Spiced Wolf Meat
17408:1:0:45:Spicy Beefstick
249875:1:0:45:Spicy Smoothie
4328:2:4:36:Spider Belt
3174:1:7:10:Spider Ichor
17222:1:0:45:Spider Sausage
4321:2:4:28:Spider Silk Slippers
3328:1:4:9:Spider Web Robe
3182:1:7:20:Spider's Silk
4320:3:4:25:Spidersilk Boots
3329:1:2:11:Spiked Wooden Plank
8957:1:0:55:Spinefin Halibut
279943:1:0:28:Spinning Wheel
4792:2:4:23:Spirit Cloak
2922:1:4:20:Spirit Relic
276541:4:4:61:Spiritcaller Boots
276539:4:4:61:Spiritcaller Gloves
276538:4:4:61:Spiritcaller Kilt
276540:4:4:61:Spiritcaller Mantle
20481:3:4:62:Spitfire Bracers
20479:3:4:62:Spitfire Breastplate
20480:3:4:62:Spitfire Gauntlets
2485:1:2:3:Splintered Board
4606:1:0:25:Spongy Morel
6887:1:0:45:Spotted Yellowtail
44803:2:4:1:Spring Circlet
13847:1:15:25:Spring/Summer Afternoon
13848:1:15:25:Spring/Summer Evening
13846:1:15:25:Spring/Summer Morning
13849:1:15:25:Spring/Summer Night
11474:1:15:47:Sprite Darter Egg
5205:1:0:15:Sprouted Frond
4951:1:4:7:Squealer's Belt
43:1:4:1:Squire's Boots
45:1:4:1:Squire's Shirt
6117:1:4:1:Squire's Shirt
2688:1:0:1:Squirrel Nut
4789:2:4:18:Stable Boots
22289:1:15:1:Stack of Cards
12252:2:2:39:Staff of Protection
5471:1:7:23:Stag Meat
4831:2:4:26:Stalking Pants
250599:4:4:61:Stalwart Helm
4263:1:4:10:Standard Issue Shield
4406:1:0:22:Standard Scope
4329:2:4:40:Star Belt
219454:1:15:50:Star Lotus
7910:2:7:50:Star Ruby
11291:1:7:30:Star Wood
219487:1:15:50:Starshell
219486:2:15:50:Starsilver Ore
279247:4:4:65:Steadfast Libram
260827:2:0:60:Stealthman 52
22728:2:15:55:Steam Tonk Controller
16170:1:0:25:Steamed Mandu
250071:1:0:55:Steaming Stag Steak
17403:1:0:15:Steamwheedle Fizzy Spirits
3859:1:7:35:Steel Bar
7963:2:4:40:Steel Breastplate
4637:2:15:40:Steel Lockbox
7922:2:4:43:Steel Plate Helm
250605:2:2:37:Steel Spear
6041:1:0:38:Steel Weapon Chain
6360:2:2:25:Steelscale Crushfish
250483:2:4:25:Sterling Silver Boots
250487:2:4:30:Sterling Silver Breastplate
250485:2:4:26:Sterling Silver Gauntlet
250484:2:4:26:Sterling Silver Leggings
250486:2:4:27:Sterling Silver Shoulders
2494:1:2:8:Stiletto
781:1:2:9:Stone Gnoll Hammer
6724:6:4:1:Stone of Backus
6728:6:4:1:Stone of Brownell
6708:6:4:1:Stone of Goodman
6711:6:4:1:Stone of Kurtz
6707:6:4:1:Stone of Lapidis
6698:6:4:1:Stone of Pierce
20858:2:12:1:Stone Scarab
15963:2:4:39:Stonecloth Branch
13422:1:7:45:Stonescale Eel
13423:1:7:50:Stonescale Oil
2268:1:2:10:Stonesplinter Blade
5109:1:4:17:Stonesplinter Rags
12632:3:4:59:Storm Gauntlets
250617:3:2:63:Stormcarver
10039:2:4:50:Stormcloth Boots
10011:2:4:44:Stormcloth Gloves
10032:2:4:48:Stormcloth Headband
10010:2:4:44:Stormcloth Pants
10038:2:4:49:Stormcloth Shoulders
10020:2:4:45:Stormcloth Vest
15056:3:4:57:Stormshroud Armor
21278:3:4:62:Stormshroud Gloves
15057:3:4:55:Stormshroud Pants
15058:3:4:59:Stormshroud Shoulders
1707:1:0:35:Stormwind Brie
22131:1:15:1:Stormwind Gift Collection
22143:1:15:1:Stormwind Guard's Card
22285:1:15:1:Stormwind Pledge Collection
269683:3:15:40:Stormy Galestrider
10940:1:7:10:Strange Dust
3820:1:7:20:Stranglekelp
17035:1:15:30:Stranglethorn Seed
249274:2:7:60:Stranglevine
13223:1:12:1:Stratholme Courier's Pouch
4837:2:4:30:Strength of Will
5469:1:7:10:Strider Meat
5477:1:0:10:Strider Stew
729:1:7:10:Stringy Vulture Meat
2672:1:7:5:Stringy Wolf Meat
21552:1:0:45:Striped Yellowtail
6453:1:0:26:Strong Anti-Venom
6365:1:2:10:Strong Fishing Pole
3466:1:7:25:Strong Flux
4636:2:15:35:Strong Iron Lockbox
12639:4:4:62:Stronghold Gauntlets
2464:1:4:37:Studded Belt
1913:2:2:12:Studded Blackjack
2467:1:4:37:Studded Boots
2468:1:4:37:Studded Bracers
2463:1:4:37:Studded Doublet
2469:1:4:37:Studded Gloves
3890:1:4:37:Studded Hat
6524:1:4:22:Studded Leather Harness
2465:1:4:37:Studded Pants
260628:1:0:55:Stuffed Pumpkin
20583:2:4:45:Sturdy Female Dwarf Mask
20584:2:4:45:Sturdy Female Gnome Mask
20585:2:4:45:Sturdy Female Human Mask
20586:2:4:45:Sturdy Female Night Elf Mask
20587:2:4:45:Sturdy Female Orc Mask
20588:2:4:45:Sturdy Female Tauren Mask
20589:2:4:45:Sturdy Female Troll Mask
20590:2:4:45:Sturdy Female Undead Mask
16884:1:15:40:Sturdy Junkbox
2327:1:4:10:Sturdy Leather Bracers
6355:1:15:30:Sturdy Locked Chest
1652:1:1:35:Sturdy Lunchbox
20591:2:4:45:Sturdy Male Dwarf Mask
20592:2:4:45:Sturdy Male Gnome Mask
20593:2:4:45:Sturdy Male Human Mask
20594:2:4:45:Sturdy Male Night Elf Mask
20595:2:4:45:Sturdy Male Orc Mask
20596:2:4:45:Sturdy Male Tauren Mask
20597:2:4:45:Sturdy Male Troll Mask
20598:2:4:45:Sturdy Male Undead Mask
11306:2:2:32:Sturdy Recurve
18633:1:0:15:Styleen's Sour Suckerpop
3427:1:4:40:Stylish Black Shirt
6384:1:4:25:Stylish Blue Shirt
6385:1:4:25:Stylish Green Shirt
4330:1:4:22:Stylish Red Shirt
2685:1:0:25:Succulent Pork Ribs
249410:2:7:25:Sulfuric Acid
17193:4:2:67:Sulfuron Hammer
17203:4:7:60:Sulfuron Ingot
23224:1:0:1:Summer Gift Package
8838:1:7:46:Sungrass
249869:1:0:45:Sunny Tea
238639:1:0:65:Sunrise Omelette
5165:1:12:1:Sunscale Feather
5878:1:0:1:Super Snuff
247242:1:0:45:Superior Discolored Healing Potion
250942:1:0:55:Superior Frenzy Potion
3928:1:0:45:Superior Healing Potion
288896:1:0:30:Superior Healing Potion
13443:1:0:51:Superior Mana Potion
288897:1:0:30:Superior Mana Potion
250948:1:0:55:Superior Mender's Potion
255718:1:7:36:Superior Poultice
250936:1:0:55:Superior Spellblasting Potion
252595:2:4:56:Supple Scorpid Belt
252574:2:4:51:Supple Scorpid Boots
252582:2:4:55:Supple Scorpid Bracers
252597:2:4:57:Supple Scorpid Helm
252580:2:4:53:Supple Scorpid Leggings
252601:2:4:61:Supple Scorpid Sabatons
252592:2:4:56:Supple Scorpid Shoulders
252599:2:4:59:Supple Scorpid Vest
255722:1:7:58:Surgical Tourniquet
275608:3:4:58:Swarmtender's Cord
275609:3:4:58:Swarmtender's Footpads
275607:3:4:58:Swarmtender's Gloves
1708:1:0:35:Sweet Nectar
267341:1:0:60:Sweetpaw Jam
18788:4:15:60:Swift Blue Raptor
7391:2:4:40:Swift Boots
18786:4:15:60:Swift Brown Ram
18777:4:15:60:Swift Brown Steed
269671:4:15:60:Swift Empyrean Galestrider
18508:3:4:62:Swift Flight Bracers
18787:4:15:60:Swift Gray Ram
18772:4:15:60:Swift Green Mechanostrider
18789:4:15:60:Swift Olive Raptor
18790:4:15:60:Swift Orange Raptor
269673:4:15:60:Swift Regal Galestrider
269678:4:15:60:Swift Stormy Galestrider
274933:4:15:60:Swift Umber Galestrider
18773:4:15:60:Swift White Mechanostrider
18785:4:15:60:Swift White Ram
18778:4:15:60:Swift White Steed
18774:4:15:60:Swift Yellow Mechanostrider
1400:1:0:12:Swiftfeather Token
2459:1:0:15:Swiftness Potion
288898:1:0:30:Swiftness Potion
250072:1:0:55:Swiftstrike Steak
2452:1:7:15:Swiftthistle
6372:1:0:20:Swim Speed Potion
255645:1:7:1:Swollen Venom Sac
4793:2:4:24:Sylvan Cloak
22757:3:4:70:Sylvan Crown
11308:2:2:49:Sylvan Shortbow
22758:3:4:70:Sylvan Shoulders
22756:3:4:70:Sylvan Vest
17033:1:15:30:Symbol of Divinity
21177:1:15:60:Symbol of Kings
17347:2:12:1:Syndicate Man Tracker (MURP)
1196:1:2:14:Tabar
1032:1:9:8:Tablet of Agitating Totem
5702:1:9:18:Tablet of Agitating Totem II
4171:1:9:28:Tablet of Agitating Totem III
4181:1:9:38:Tablet of Agitating Totem IV
4170:1:9:30:Tablet of Astral Recall
1035:1:9:10:Tablet of Call Spirit
1603:1:9:40:Tablet of Call Spirit II
9183:1:9:40:Tablet of Chain Heal
9133:1:9:46:Tablet of Chain Heal II
9157:1:9:54:Tablet of Chain Heal III
4189:1:9:32:Tablet of Chain Lightning
9102:1:9:40:Tablet of Chain Lightning II
9140:1:9:48:Tablet of Chain Lightning III
9167:1:9:56:Tablet of Chain Lightning IV
9062:1:9:22:Tablet of Cure Disease
9096:1:9:38:Tablet of Disease Cleansing Totem
9039:1:9:4:Tablet of Earth Shock
9044:1:9:8:Tablet of Earth Shock II
9051:1:9:14:Tablet of Earth Shock III
9069:1:9:24:Tablet of Earth Shock IV
9095:1:9:36:Tablet of Earth Shock V
9142:1:9:48:Tablet of Earth Shock VI
9177:1:9:60:Tablet of Earth Shock VII
9041:1:9:6:Tablet of Earthbind Totem
4168:1:9:16:Tablet of Ensnaring Totem
5714:1:9:34:Tablet of Ensnaring Totem II
5708:1:9:24:Tablet of Ethereal Form
4180:1:9:34:Tablet of Ethereal Form II
5707:1:9:26:Tablet of Far Sight
9049:1:9:12:Tablet of Fire Nova Totem
9065:1:9:22:Tablet of Fire Nova Totem II
9085:1:9:32:Tablet of Fire Nova Totem III
9128:1:9:42:Tablet of Fire Nova Totem IV
9152:1:9:52:Tablet of Fire Nova Totem V
4186:1:9:32:Tablet of Fire Resistance
9075:1:9:18:Tablet of Fire Resistance Totem
9127:1:9:42:Tablet of Fire Resistance Totem II
9170:1:9:58:Tablet of Fire Resistance Totem III
9047:1:9:10:Tablet of Flame Shock
9054:1:9:18:Tablet of Flame Shock II
9074:1:9:28:Tablet of Flame Shock III
9184:1:9:40:Tablet of Flame Shock IV
9151:1:9:52:Tablet of Flame Shock V
23320:3:9:60:Tablet of Flame Shock VI
9072:1:9:26:Tablet of Flametongue Totem
9126:1:9:42:Tablet of Flametongue Totem II
9165:1:9:56:Tablet of Flametongue Totem III
9059:1:9:10:Tablet of Flametongue Weapon
9064:1:9:22:Tablet of Flametongue Weapon II
9094:1:9:36:Tablet of Flametongue Weapon III
9148:1:9:50:Tablet of Flametongue Weapon IV
9066:1:9:24:Tablet of Frost Resistance Totem
9185:1:9:38:Tablet of Frost Resistance Totem II
9158:1:9:54:Tablet of Frost Resistance Totem III
9058:1:9:20:Tablet of Frost Shock
9089:1:9:34:Tablet of Frost Shock II
9135:1:9:46:Tablet of Frost Shock III
9174:1:9:58:Tablet of Frost Shock IV
9057:1:9:20:Tablet of Frostbrand Weapon
9090:1:9:34:Tablet of Frostbrand Weapon II
9139:1:9:48:Tablet of Frostbrand Weapon III
5699:1:9:12:Tablet of Ghost Wolf
5711:1:9:30:Tablet of Ghost Wolf II
9125:1:9:42:Tablet of Grace of Air Totem
9164:1:9:56:Tablet of Grace of Air Totem II
21293:3:9:60:Tablet of Grace of Air Totem III
9078:1:9:30:Tablet of Grounding Totem
4185:1:9:40:Tablet of Group Astral Recall
9081:1:9:30:Tablet of Healing Stream Totem II
9103:1:9:40:Tablet of Healing Stream Totem III
9147:1:9:50:Tablet of Healing Stream Totem IV
9181:1:9:60:Tablet of Healing Stream Totem V
5697:1:9:6:Tablet of Healing Totem
5700:1:9:12:Tablet of Healing Totem II
5705:1:9:20:Tablet of Healing Totem III
5710:1:9:28:Tablet of Healing Totem IV
4183:1:9:36:Tablet of Healing Totem V
9040:1:9:6:Tablet of Healing Wave II
9050:1:9:12:Tablet of Healing Wave III
9056:1:9:18:Tablet of Healing Wave IV
9168:1:9:56:Tablet of Healing Wave IX
9070:1:9:24:Tablet of Healing Wave V
9086:1:9:32:Tablet of Healing Wave VI
9105:1:9:40:Tablet of Healing Wave VII
9143:1:9:48:Tablet of Healing Wave VIII
21291:3:9:60:Tablet of Healing Wave X
4188:1:9:40:Tablet of Invisibility Totem
1037:1:9:10:Tablet of Lightning Bolt II
1058:1:9:18:Tablet of Lightning Bolt III
3129:1:9:26:Tablet of Lightning Bolt IV
4178:1:9:34:Tablet of Lightning Bolt V
9123:1:9:42:Tablet of Lightning Bolt VI
9145:1:9:50:Tablet of Lightning Bolt VII
9169:1:9:58:Tablet of Lightning Bolt VIII
5698:1:9:8:Tablet of Lightning Shield
1048:1:9:16:Tablet of Lightning Shield II
1591:1:9:24:Tablet of Lightning Shield III
4175:1:9:32:Tablet of Lightning Shield IV
9100:1:9:40:Tablet of Lightning Shield V
9137:1:9:48:Tablet of Lightning Shield VI
9162:1:9:56:Tablet of Lightning Shield VII
9079:1:9:30:Tablet of Lightning Shock
9124:1:9:42:Tablet of Lightning Shock II
9159:1:9:54:Tablet of Lightning Shock III
1597:1:9:20:Tablet of Lightning Storm
1619:1:9:30:Tablet of Lightning Storm II
5715:1:9:40:Tablet of Lightning Storm III
9076:1:9:18:Tablet of Magma Totem
9097:1:9:38:Tablet of Magma Totem II
9138:1:9:48:Tablet of Magma Totem III
9171:1:9:58:Tablet of Magma Totem IV
9071:1:9:26:Tablet of Mana Font Totem
9093:1:9:36:Tablet of Mana Font Totem II
9136:1:9:46:Tablet of Mana Font Totem III
9166:1:9:56:Tablet of Mana Font Totem IV
3133:1:9:30:Tablet of Mana Totem
1031:1:9:6:Tablet of Molten Blast
1053:1:9:14:Tablet of Molten Blast II
1588:1:9:22:Tablet of Molten Blast III
3132:1:9:30:Tablet of Molten Blast IV
4184:1:9:38:Tablet of Molten Blast V
9132:1:9:46:Tablet of Molten Blast VI
9156:1:9:54:Tablet of Molten Blast VII
4177:1:9:32:Tablet of Nature Resistance
9080:1:9:30:Tablet of Nature Resistance Totem
9130:1:9:44:Tablet of Nature Resistance Totem II
9178:1:9:60:Tablet of Nature Resistance Totem III
1036:1:9:16:Tablet of Nullify Disease
1063:1:9:26:Tablet of Nullify Disease II
1033:1:9:18:Tablet of Nullify Poison
1061:1:9:26:Tablet of Nullify Poison II
9063:1:9:22:Tablet of Poison Cleansing Totem
1049:1:9:12:Tablet of Purge
9087:1:9:32:Tablet of Purge II
9048:1:9:12:Tablet of Rebirth
1038:1:9:8:Tablet of Restoration II
1057:1:9:16:Tablet of Restoration III
3130:1:9:24:Tablet of Restoration IV
4179:1:9:32:Tablet of Restoration V
5716:1:9:40:Tablet of Restoration VI
9037:1:9:1:Tablet of Rockbiter Weapon
9053:1:9:16:Tablet of Rockbiter Weapon II
9082:1:9:30:Tablet of Rockbiter Weapon III
9129:1:9:44:Tablet of Rockbiter Weapon IV
9175:1:9:58:Tablet of Rockbiter Weapon V
9188:1:9:20:Tablet of Searing Totem II
9083:1:9:30:Tablet of Searing Totem III
9104:1:9:40:Tablet of Searing Totem IV
9146:1:9:50:Tablet of Searing Totem V
9182:1:9:60:Tablet of Searing Totem VI
5701:1:9:14:Tablet of Sentry Totem
9092:1:9:34:Tablet of Sentry Totem
1029:1:9:4:Tablet of Serpent Totem
3125:1:9:10:Tablet of Serpent Totem II
5706:1:9:20:Tablet of Serpent Totem III
5712:1:9:30:Tablet of Serpent Totem IV
4187:1:9:40:Tablet of Serpent Totem V
5696:1:9:4:Tablet of Shock
3126:1:9:12:Tablet of Shock II
3127:1:9:20:Tablet of Shock III
4173:1:9:28:Tablet of Shock IV
4174:1:9:36:Tablet of Shock V
1052:1:9:14:Tablet of Spirit Armor II
1589:1:9:28:Tablet of Spirit Armor III
9043:1:9:8:Tablet of Stoneclaw Totem
9055:1:9:18:Tablet of Stoneclaw Totem II
9077:1:9:18:Tablet of Stoneclaw Totem III
9099:1:9:38:Tablet of Stoneclaw Totem IV
9141:1:9:48:Tablet of Stoneclaw Totem V
9176:1:9:58:Tablet of Stoneclaw Totem VI
9052:1:9:14:Tablet of Stoneskin Totem II
9068:1:9:24:Tablet of Stoneskin Totem III
9091:1:9:34:Tablet of Stoneskin Totem IV
9131:1:9:44:Tablet of Stoneskin Totem V
9161:1:9:54:Tablet of Stoneskin Totem VI
9046:1:9:10:Tablet of Strength of Earth Totem
9067:1:9:24:Tablet of Strength of Earth Totem II
9098:1:9:38:Tablet of Strength of Earth Totem III
9150:1:9:52:Tablet of Strength of Earth Totem IV
21292:3:9:60:Tablet of Strength of Earth Totem V
5713:1:9:32:Tablet of Thunderbolt
5703:1:9:20:Tablet of Thunderclap
4172:1:9:36:Tablet of Thunderclap II
1034:1:9:22:Tablet of Undying Strength
4176:1:9:36:Tablet of Undying Strength II
1030:1:9:10:Tablet of Unyielding Will
4169:1:9:24:Tablet of Unyielding Will II
4182:1:9:38:Tablet of Unyielding Will III
5704:1:9:20:Tablet of Water Breathing
5709:1:9:28:Tablet of Water Walking
9084:1:9:32:Tablet of Windfury Totem
9134:1:9:46:Tablet of Windfury Totem II
9180:1:9:60:Tablet of Windfury Totem III
9073:1:9:26:Tablet of Windfury Weapon
9101:1:9:40:Tablet of Windfury Weapon II
9160:1:9:54:Tablet of Windfury Weapon III
270313:1:15:1:Tale of I'lalai in Zandali
5029:2:4:47:Talisman of the Naga Lord
5504:1:7:23:Tangy Clam Meat
1843:1:4:17:Tanned Leather Belt
843:1:4:17:Tanned Leather Boots
1844:1:4:17:Tanned Leather Bracers
844:1:4:17:Tanned Leather Gloves
846:1:4:17:Tanned Leather Jerkin
845:1:4:17:Tanned Leather Pants
279941:1:0:28:Tanning Rack
4366:1:0:17:Target Dummy
2754:1:2:3:Tarnished Bastard Sword
2380:1:4:5:Tarnished Chain Belt
2383:1:4:5:Tarnished Chain Boots
2384:1:4:5:Tarnished Chain Bracers
2385:1:4:5:Tarnished Chain Gloves
2381:1:4:5:Tarnished Chain Leggings
2379:1:4:5:Tarnished Chain Vest
3728:1:0:35:Tasty Lion Steak
250079:1:0:10:Tasty Raptor Bites
3595:1:4:5:Tattered Cloth Belt
195:1:4:5:Tattered Cloth Boots
3596:1:4:5:Tattered Cloth Bracers
711:1:4:5:Tattered Cloth Gloves
194:1:4:5:Tattered Cloth Pants
193:1:4:5:Tattered Cloth Vest
6493:1:12:1:Tattered Parchment
15293:4:15:60:Teal Kodo
9444:1:4:26:Techbot CPU Shell
4537:1:0:15:Tel'Abim Banana
208608:1:15:1:Teldrassil Bird Meat
253884:2:4:55:Template Item
273455:1:0:1:Template Vellum [DNT]
12206:1:7:40:Tender Crab Meat
3667:1:7:23:Tender Crocolisk Meat
12208:1:7:40:Tender Wolf Meat
18045:1:0:45:Tender Wolf Steak
253378:2:15:20:Tenn's Road-Worn Flute
12033:1:15:60:Thaurissan Family Jewels
18358:3:12:60:The Arcanist's Cookbook
10586:1:0:45:The Big One
18364:3:12:60:The Emerald Dream
18665:4:4:71:The Eye of Shadow
19484:1:15:1:The Frostwolf Artichoke
18361:3:12:60:The Greatest Race of Hunters
20010:1:12:1:The Horde's Hellscream
18359:3:12:60:The Light and How to Swing It
23579:1:0:55:The McWeaksauce Classic
17781:1:12:1:The Pariah's Instructions
7337:1:4:60:The Rock
7741:1:12:1:The Shaft of Tsol
7954:3:2:47:The Shatterer
271659:1:4:1:Thendal Apprentice's Boots
271655:1:4:1:Thendal Apprentice's Shirt
271661:1:4:1:Thendal Novice's Boots
271663:1:4:1:Thendal Novice's Shirt
271665:1:4:1:Thendal Survivalist's Boots
271668:1:4:1:Thendal Survivalist's Shirt
271671:1:4:1:Thendal Warrior's Boots
271669:1:4:1:Thendal Warrior's Shirt
8173:1:0:40:Thick Armor Kit
3597:1:4:22:Thick Cloth Belt
3598:1:4:22:Thick Cloth Bracers
203:1:4:22:Thick Cloth Gloves
201:1:4:22:Thick Cloth Pants
202:1:4:22:Thick Cloth Shoes
200:1:4:22:Thick Cloth Vest
8169:1:7:40:Thick Hide
4304:1:7:40:Thick Leather
8218:2:11:45:Thick Leather Ammo Pouch
272941:1:7:60:Thick Logs
5782:2:4:34:Thick Murloc Armor
5785:1:7:35:Thick Murloc Scale
22196:4:4:72:Thick Obsidian Breastplate
4337:1:7:35:Thick Spider's Silk
3489:2:2:17:Thick War Axe
8368:1:7:40:Thick Wolfhide
5524:1:7:20:Thick-shelled Clam
2121:1:4:5:Thin Cloth Armor
3599:1:4:5:Thin Cloth Belt
3600:1:4:5:Thin Cloth Bracers
2119:1:4:5:Thin Cloth Gloves
2120:1:4:5:Thin Cloth Pants
2117:1:4:5:Thin Cloth Shoes
5082:1:7:10:Thin Kodo Leather
7676:1:0:15:Thistle Tea
15976:2:4:36:Thistlefur Branch
12405:2:4:50:Thorium Armor
12359:1:7:50:Thorium Bar
12406:2:4:50:Thorium Belt
12409:2:4:56:Thorium Boots
12408:2:4:51:Thorium Bracers
12764:2:2:52:Thorium Greatsword
15993:1:0:52:Thorium Grenade
18042:2:6:57:Thorium Headed Arrow
12410:2:4:56:Thorium Helm
12414:2:4:60:Thorium Leggings
5759:2:15:55:Thorium Lockbox
10620:1:7:40:Thorium Ore
250615:3:2:57:Thorium Poleaxe
15995:2:2:52:Thorium Rifle
15997:2:6:57:Thorium Shells
12645:2:0:55:Thorium Shield Spike
16000:1:7:39:Thorium Tube
15994:1:7:52:Thorium Widget
19231:3:12:1:Three of Beasts
221292:3:15:1:Three of Dunes
19270:3:12:1:Three of Elementals
221301:3:15:1:Three of Nightmares
221283:3:15:1:Three of Plagues
19279:3:12:1:Three of Portals
19260:3:12:1:Three of Warlords
221274:3:15:1:Three of Wilds
4959:1:2:7:Throwing Tomahawk
121:1:4:1:Thug Boots
6138:1:4:1:Thug Boots
2105:1:4:1:Thug Shirt
6136:1:4:1:Thug Shirt
6203:2:4:13:Thuggish Shield
2686:1:0:1:Thunder Ale
247824:1:0:1:Thunder Applejack
22135:1:15:1:Thunder Bluff Gift Collection
22297:1:15:1:Thunder Bluff Pledge Collection
5470:1:7:22:Thunder Lizard Tail
4480:1:0:35:Thundering Charm
12202:1:7:30:Tiger Meat
818:2:7:15:Tigerseye
20708:1:15:15:Tightly Sealed Trunk
7228:1:0:25:Tigule's Strawberry Ice Cream
19049:3:4:61:Timbermaw Brawlers
252484:4:4:61:Timbermaw Tunic
3576:1:7:20:Tin Bar
2771:1:7:20:Tin Ore
268503:1:15:30:Tiny Azure Whelpling
5517:1:15:18:Tiny Bronze Key
268502:1:15:30:Tiny Bronze Whelpling
8147:1:15:42:Tiny Copper Key
8499:1:15:30:Tiny Crimson Whelpling
8498:1:15:30:Tiny Emerald Whelpling
5518:1:15:30:Tiny Iron Key
8148:1:15:54:Tiny Silver Key
22385:4:4:60:Titanic Leggings
21267:1:15:1:Toasting Goblet
2490:1:2:9:Tomahawk
2929:1:7:12:Tomb Rot
8807:1:9:18:Tome of Amplify Magic
8821:1:9:30:Tome of Amplify Magic II
8855:1:9:42:Tome of Amplify Magic III
8882:1:9:54:Tome of Amplify Magic IV
18600:3:9:56:Tome of Arcane Brilliance
8804:1:9:14:Tome of Arcane Explosion
8812:1:9:22:Tome of Arcane Explosion II
8822:1:9:30:Tome of Arcane Explosion III
8898:1:9:38:Tome of Arcane Explosion IV
8837:1:9:46:Tome of Arcane Explosion V
8880:1:9:54:Tome of Arcane Explosion VI
8802:1:9:1:Tome of Arcane Intellect
3091:1:9:14:Tome of Arcane Intellect II
3102:1:9:28:Tome of Arcane Intellect III
8852:1:9:42:Tome of Arcane Intellect IV
8883:1:9:56:Tome of Arcane Intellect V
4159:1:9:8:Tome of Arcane Missiles
1559:1:9:16:Tome of Arcane Missiles II
4153:1:9:24:Tome of Arcane Missiles III
8826:1:9:32:Tome of Arcane Missiles IV
8849:1:9:40:Tome of Arcane Missiles V
8862:1:9:48:Tome of Arcane Missiles VI
8885:1:9:56:Tome of Arcane Missiles VII
21280:3:9:60:Tome of Arcane Missiles VIII
5647:1:9:22:Tome of Blink
4162:1:9:38:Tome of Blink II
5649:1:9:20:Tome of Blizzard
3100:1:9:28:Tome of Blizzard II
8832:1:9:36:Tome of Blizzard III
8857:1:9:44:Tome of Blizzard IV
8872:1:9:52:Tome of Blizzard V
8895:1:9:60:Tome of Blizzard VI
975:1:9:10:Tome of Chains of Ice
1004:1:9:30:Tome of Chains of Ice II
8815:1:9:26:Tome of Cone of Cold
8829:1:9:34:Tome of Cone of Cold II
8854:1:9:42:Tome of Cone of Cold III
8866:1:9:50:Tome of Cone of Cold IV
8888:1:9:58:Tome of Cone of Cold V
4141:1:9:6:Tome of Conjure Food
4143:1:9:12:Tome of Conjure Food II
4147:1:9:22:Tome of Conjure Food III
4152:1:9:32:Tome of Conjure Food IV
8853:1:9:42:Tome of Conjure Food V
8871:1:9:52:Tome of Conjure Food VI
22897:3:9:60:Tome of Conjure Food VII
4145:1:9:28:Tome of Conjure Mana Gem
8840:1:9:38:Tome of Conjure Mana Gem II
8861:1:9:48:Tome of Conjure Mana Gem III
8889:1:9:58:Tome of Conjure Mana Gem IV
5644:1:9:4:Tome of Conjure Water
3097:1:9:10:Tome of Conjure Water II
5650:1:9:20:Tome of Conjure Water III
4150:1:9:30:Tome of Conjure Water IV
8850:1:9:40:Tome of Conjure Water V
8868:1:9:50:Tome of Conjure Water VI
8892:1:9:60:Tome of Conjure Water VII
4148:1:9:24:Tome of Counterspell
4157:1:9:12:Tome of Dampen Magic
8813:1:9:24:Tome of Dampen Magic II
8834:1:9:36:Tome of Dampen Magic III
8863:1:9:48:Tome of Dampen Magic IV
8894:1:9:60:Tome of Dampen Magic V
8805:1:9:16:Tome of Detect Magic
3096:1:9:12:Tome of Feather Fall
968:1:9:6:Tome of Fire Blast
3094:1:9:14:Tome of Fire Blast II
3095:1:9:22:Tome of Fire Blast III
8823:1:9:30:Tome of Fire Blast IV
8841:1:9:38:Tome of Fire Blast V
8859:1:9:46:Tome of Fire Blast VI
8878:1:9:54:Tome of Fire Blast VII
1574:1:9:20:Tome of Fire Ward
8820:1:9:30:Tome of Fire Ward II
8843:1:9:40:Tome of Fire Ward III
8869:1:9:50:Tome of Fire Ward IV
8897:1:9:60:Tome of Fire Ward V
8803:1:9:6:Tome of Fireball
973:1:9:12:Tome of Fireball II
992:1:9:12:Tome of Fireball III
4161:1:9:18:Tome of Fireball IV
8860:1:9:48:Tome of Fireball IX
8814:1:9:24:Tome of Fireball V
8824:1:9:30:Tome of Fireball VI
8835:1:9:36:Tome of Fireball VII
8851:1:9:42:Tome of Fireball VIII
8877:1:9:54:Tome of Fireball X
8890:1:9:60:Tome of Fireball XI
21279:3:9:60:Tome of Fireball XII
3089:1:9:16:Tome of Flamestrike
3093:1:9:24:Tome of Flamestrike II
3092:1:9:32:Tome of Flamestrike III
8848:1:9:40:Tome of Flamestrike IV
8864:1:9:48:Tome of Flamestrike V
8886:1:9:56:Tome of Flamestrike VI
974:1:9:10:Tome of Frost Armor II
5648:1:9:20:Tome of Frost Armor III
989:1:9:10:Tome of Frost Nova
1571:1:9:26:Tome of Frost Nova II
3101:1:9:40:Tome of Frost Nova III
8879:1:9:54:Tome of Frost Nova IV
966:1:9:8:Tome of Frost Shield
980:1:9:20:Tome of Frost Shield II
4149:1:9:34:Tome of Frost Shield III
967:1:9:22:Tome of Frost Ward
8876:1:9:32:Tome of Frost Ward II
8825:1:9:42:Tome of Frost Ward III
8875:1:9:52:Tome of Frost Ward IV
22890:3:9:60:Tome of Frost Ward V
3090:1:9:4:Tome of Frostbolt
986:1:9:8:Tome of Frostbolt II
1554:1:9:14:Tome of Frostbolt III
4151:1:9:20:Tome of Frostbolt IV
8867:1:9:50:Tome of Frostbolt IX
8816:1:9:26:Tome of Frostbolt V
8828:1:9:32:Tome of Frostbolt VI
8842:1:9:38:Tome of Frostbolt VII
8856:1:9:44:Tome of Frostbolt VIII
8884:1:9:56:Tome of Frostbolt X
21214:3:9:60:Tome of Frostbolt XI
8870:1:9:50:Tome of Greater Invisibility
994:1:9:30:Tome of Ice Armor
3099:1:9:40:Tome of Ice Armor II
8865:1:9:50:Tome of Ice Armor III
8891:1:9:60:Tome of Ice Armor IV
4160:1:9:38:Tome of Invisibility
6778:1:12:30:Tome of Justice
985:1:9:18:Tome of Khadgar's Unlocking
1567:1:9:30:Tome of Khadgar's Unlocking II
4158:1:9:42:Tome of Khadgar's Unlocking III
8881:1:9:54:Tome of Khadgar's Unlocking IV
1002:1:9:26:Tome of Lesser Invisibility
8808:1:9:20:Tome of Mana Shield
8818:1:9:28:Tome of Mana Shield II
8833:1:9:36:Tome of Mana Shield III
8858:1:9:44:Tome of Mana Shield IV
8873:1:9:52:Tome of Mana Shield V
8896:1:9:60:Tome of Mana Shield VI
6779:1:12:40:Tome of Nobility
4144:3:9:60:Tome of Polymorph: Cow
4142:3:9:60:Tome of Polymorph: Pig
4146:1:9:40:Tome of Polymorph: Sheep
22739:3:9:60:Tome of Polymorph: Turtle
976:1:9:18:Tome of Remove Curse
8806:1:9:18:Tome of Remove Lesser Curse
8811:1:9:22:Tome of Scorch
8819:1:9:28:Tome of Scorch II
8830:1:9:34:Tome of Scorch III
8899:1:9:40:Tome of Scorch IV
8847:1:9:46:Tome of Scorch V
8874:1:9:52:Tome of Scorch VI
8887:1:9:58:Tome of Scorch VII
8809:1:9:8:Tome of Sleep
8810:1:9:20:Tome of Sleep II
8844:1:9:40:Tome of Sleep III
8893:1:9:60:Tome of Sleep IV
3098:1:9:28:Tome of Slow
4154:1:9:40:Tome of Slow II
1568:1:9:30:Tome of Water Elemental
4155:1:9:40:Tome of Water Elemental II
252552:2:4:56:Tooled Leather Armor
252544:2:4:52:Tooled Leather Belt
252545:2:4:53:Tooled Leather Boots
252557:2:4:59:Tooled Leather Bracers
252555:2:4:58:Tooled Leather Crown
252558:2:4:60:Tooled Leather Epaulets
252553:2:4:57:Tooled Leather Gauntlets
252560:2:4:61:Tooled Leather Pants
18780:3:12:60:Top Half of Advanced Armorsmithing: Volume I
18782:3:12:60:Top Half of Advanced Armorsmithing: Volume II
18784:3:12:60:Top Half of Advanced Armorsmithing: Volume III
203785:1:0:1:Top-Left Map Piece
203784:1:0:1:Top-Right Map Piece
248820:2:7:60:Torbernite
235517:1:15:60:Torch
279246:4:2:65:Torch of Light
2932:1:7:40:Torment Vine
11407:1:12:1:Torn Bear Pelt
23199:3:4:65:Totem of the Storm
279249:4:4:65:Totem of Urgency
1080:1:7:15:Tough Condor Meat
4540:1:0:5:Tough Hunk of Bread
117:1:0:5:Tough Jerky
8209:2:4:47:Tough Scorpid Boots
8205:2:4:44:Tough Scorpid Bracers
8203:2:4:44:Tough Scorpid Breastplate
8204:2:4:45:Tough Scorpid Gloves
8208:2:4:50:Tough Scorpid Helm
8206:2:4:49:Tough Scorpid Leggings
8207:2:4:48:Tough Scorpid Shoulders
2314:2:4:24:Toughened Leather Armor
4253:3:4:27:Toughened Leather Gloves
279940:1:0:28:Toxin Study
21277:1:15:60:Tranquil Mechanical Yeti
279256:4:4:65:Tranquil Wristguards
270312:1:15:1:Translated Tale of I'lalai
272124:1:15:1:Translated Tale of I'lalai
135522:1:4:1:Transmog UI Chest Item
135550:1:4:1:Transmog UI Feet Item
135549:1:4:1:Transmog UI Hand Item
135548:1:4:1:Transmog UI Legs Item
135510:1:4:1:Transmog UI Trim Head Item
6127:1:4:1:Trapper's Boots
127:1:4:1:Trapper's Shirt
6130:1:4:1:Trapper's Shirt
279938:1:0:60:Trapper's Workbench
4500:2:1:55:Traveler's Backpack
11026:1:15:35:Tree Frog Box
249868:1:0:35:Triage Tea
4675:1:4:10:Tribal Belt
3284:1:4:12:Tribal Boots
3285:1:4:10:Tribal Bracers
3649:1:4:11:Tribal Buckler
4674:1:4:9:Tribal Cloak
3286:1:4:12:Tribal Gloves
2064:1:2:11:Trogg Club
2787:1:2:3:Trogg Dagger
2054:1:2:4:Trogg Hand Axe
9259:1:15:1:Troll Tribal Necklace
3826:1:0:36:Troll's Blood Elixir
1685:1:1:45:Troll-hide Bag
260809:1:0:48:Tru-Trigger Frag Bomb
7049:2:4:30:Truefaith Gloves
6037:2:7:50:Truesilver Bar
7939:3:4:49:Truesilver Breastplate
7960:3:2:52:Truesilver Champion
7938:3:4:45:Truesilver Gauntlets
7911:2:7:40:Truesilver Ore
11144:1:7:40:Truesilver Rod
22235:1:15:1:Truesilver Shafted Arrow
15871:2:0:40:Truesilver Skeleton Key
18631:1:7:50:Truesilver Transformer
2524:1:2:34:Truncheon
287416:1:0:10:Truskis' Cheesecake Slice
18963:1:15:20:Turtle Egg (Albino)
18965:1:15:20:Turtle Egg (Hawksbill)
18966:1:15:20:Turtle Egg (Leatherback)
18964:1:15:20:Turtle Egg (Loggerhead)
18967:1:15:20:Turtle Egg (Olive)
3712:1:7:30:Turtle Meat
8167:1:7:35:Turtle Scale
8198:2:4:42:Turtle Scale Bracers
8189:2:4:42:Turtle Scale Breastplate
8187:2:4:41:Turtle Scale Gloves
217270:2:4:41:Turtle Scale Gloves
8191:2:4:46:Turtle Scale Helm
8185:2:4:47:Turtle Scale Leggings
10036:1:4:35:Tuxedo Jacket
10035:1:4:35:Tuxedo Pants
10034:1:4:1:Tuxedo Shirt
4728:1:4:1:Twain's Shoulder
250077:1:0:15:Twice-Spiced Raptor Slice
20408:2:4:60:Twilight Cultist Cowl
20406:2:4:60:Twilight Cultist Mantle
20422:1:12:1:Twilight Cultist Medallion of Station
20451:1:12:60:Twilight Cultist Ring of Lordship
20407:2:4:60:Twilight Cultist Robe
20394:1:12:1:Twilight Lexicon - Chapter 1
20395:1:12:1:Twilight Lexicon - Chapter 2
20396:1:12:1:Twilight Lexicon - Chapter 3
7556:2:4:40:Twilight Orb
249144:2:2:42:Twisted Nether Wand
19230:3:12:1:Two of Beasts
221291:3:15:1:Two of Dunes
19269:3:12:1:Two of Elementals
221300:3:15:1:Two of Nightmares
221282:3:15:1:Two of Plagues
19278:3:12:1:Two of Portals
19259:3:12:1:Two of Warlords
221273:3:15:1:Two of Wilds
2489:1:2:7:Two-handed Sword
14083:1:2:4:Tyrande's Staff
268879:1:15:20:Uber Diablo Stone
18639:3:4:60:Ultra-Flash Shadow Reflector
260825:2:15:1:Ultralight Goblin Glider
260822:2:0:60:Ultrasafe Rechargeable Battery
18986:2:15:52:Ultrasafe Transporter: Gadgetzan
274930:3:15:40:Umber Galestrider
12763:1:0:55:Un'Goro Etherfruit
11018:1:12:1:Un'Goro Soil
12219:1:12:1:Unadorned Seal of Ascension
268416:2:7:20:Uncommon Herb Seeds
5052:1:12:1:Unconscious Dig Rat
10450:1:12:1:Undamaged Hippogryph Feather
273130:2:15:60:Undeath Engine
280699:1:15:30:Undercity Cockroach
22134:1:15:1:Undercity Gift Collection
22300:1:15:1:Undercity Pledge Collection
16766:1:0:45:Undermine Clam Chowder
8543:1:0:35:Underwater Mushroom Cap
1217:1:12:1:Unknown Reward
6183:1:0:10:Unlit Poor Torch
13322:3:15:40:Unpainted Mechanostrider
284869:1:0:52:Unsanctified Grenade
10560:1:7:40:Unstable Trigger
268417:2:7:36:Unusual Herb Seeds
282026:2:4:58:Unyielding Battle Signet
9251:1:12:1:Upper Map Fragment
9443:1:12:1:Used Monster Sample
22059:1:15:1:Valentine's Day Card
22058:1:15:1:Valentine's Day Stationery
249871:1:0:5:Venomous Smoothie
15966:2:4:54:Venomshroud Orb
275605:3:4:58:Venomspew Cord
275606:3:4:58:Venomspew Footpads
275604:3:4:58:Venomspew Gloves
7466:2:4:37:Vermilion Band
7467:2:4:35:Vermilion Necklace
20872:3:12:61:Vermillion Idol
16167:1:0:15:Versicolor Treat
2979:1:4:14:Veteran Boots
3213:1:4:13:Veteran Bracers
4677:1:4:12:Veteran Cloak
4678:1:4:14:Veteran Girdle
5117:1:12:1:Vibrant Plume
232344:4:0:60:Vick's VIP Pass
3325:1:2:9:Vile Fin Battle Axe
3327:1:2:9:Vile Fin Oracle Staff
19702:2:12:1:Vilebranch Coin
6075:1:12:1:Vimes's Report
5767:1:4:9:Violet Robes
6589:2:4:26:Viridian Band
249431:2:7:60:Viridian Dye
11137:1:7:35:Vision Dust
15977:2:4:37:Vital Orb
16009:2:4:58:Voice Amplification Modulator
9260:1:0:1:Volatile Rum
15053:2:4:57:Volcanic Breastplate
12792:2:2:58:Volcanic Hammer
15054:2:4:54:Volcanic Leggings
15055:2:4:61:Volcanic Shoulders
1996:2:4:37:Voodoo Band
8396:1:12:1:Vulture Gizzard
2495:1:2:8:Walking Stick
1202:1:4:17:Wall Shield
2525:1:2:35:War Hammer
2533:1:2:45:War Maul
14727:2:4:19:War Paint Legguards
14728:1:4:22:War Paint Shoulder Pads
2535:1:2:45:War Staff
15482:1:4:11:War Torn Bands
15483:1:4:10:War Torn Cape
15480:1:4:13:War Torn Girdle
15481:1:4:13:War Torn Greaves
15484:1:4:12:War Torn Handgrips
15064:3:4:55:Warbear Harness
252485:4:4:61:Warbear Helm
15419:1:7:50:Warbear Leather
15065:3:4:57:Warbear Woolies
275824:3:2:48:Wardcleaver
14864:2:4:59:Warleader's Belt
19257:4:12:1:Warlords Deck
235277:4:15:1:Warlords Deck
2967:1:4:10:Warrior's Boots
3214:1:4:9:Warrior's Bracers
3648:1:4:9:Warrior's Buckler
4658:1:4:8:Warrior's Cloak
4659:1:4:8:Warrior's Girdle
2968:1:4:9:Warrior's Gloves
1438:1:4:9:Warrior's Shield
22374:3:12:60:Wartorn Chain Scrap
22376:3:12:60:Wartorn Cloth Scrap
22373:3:12:60:Wartorn Leather Scrap
22375:3:12:60:Wartorn Plate Scrap
8483:1:12:1:Wastewander Water Pouch
15973:2:4:30:Watcher's Star
5265:1:0:1:Watered-down Beer
6352:1:15:25:Waterlogged Crate
21113:1:15:25:Watertight Trunk
248549:2:15:1:Waylaid Crate
248685:1:0:1:Waylaid Crate: Apprentice Curiosities
248702:2:0:1:Waylaid Crate: Apprentice Fabrics
248682:1:0:1:Waylaid Crate: Apprentice Herbs
248703:2:0:1:Waylaid Crate: Apprentice Ingots
248683:1:0:1:Waylaid Crate: Apprentice Ore
248704:2:0:1:Waylaid Crate: Apprentice Parts
248684:1:0:1:Waylaid Crate: Apprentice Textiles
248699:1:0:1:Waylaid Crate: Artisan Curiosities
248711:2:0:1:Waylaid Crate: Artisan Fabrics
248712:2:0:1:Waylaid Crate: Artisan Ingots
248697:1:0:1:Waylaid Crate: Artisan Ore
248713:2:0:1:Waylaid Crate: Artisan Parts
248698:1:0:1:Waylaid Crate: Artisan Textiles
248695:1:0:1:Waylaid Crate: Earthly Artisan Herbs
248690:1:0:1:Waylaid Crate: Earthly Expert Herbs
248694:1:0:1:Waylaid Crate: Expert Curiosities
248708:2:0:1:Waylaid Crate: Expert Fabrics
248709:2:0:1:Waylaid Crate: Expert Ingots
248692:1:0:1:Waylaid Crate: Expert Ore
248710:2:0:1:Waylaid Crate: Expert Parts
248693:1:0:1:Waylaid Crate: Expert Textiles
248696:1:0:1:Waylaid Crate: Flowering Artisan Herbs
248691:1:0:1:Waylaid Crate: Flowering Expert Herbs
248689:1:0:1:Waylaid Crate: Journeyman Curiosities
248705:2:0:1:Waylaid Crate: Journeyman Fabrics
248686:1:0:1:Waylaid Crate: Journeyman Herbs
248706:2:0:1:Waylaid Crate: Journeyman Ingots
248687:1:0:1:Waylaid Crate: Journeyman Ore
248707:2:0:1:Waylaid Crate: Journeyman Parts
248688:1:0:1:Waylaid Crate: Journeyman Textiles
275642:1:15:1:Waylaid Herbs
2880:1:7:5:Weak Flux
6495:1:12:1:Weatherbeaten Parchment
6489:1:12:1:Weatherworn Parchment
6148:1:4:10:Web-covered Boots
3261:1:4:5:Webbed Cloak
3263:1:4:3:Webbed Pants
6837:1:4:1:Wedding Dress
8493:1:0:1:Weegli's Barrel
3131:1:2:8:Weighted Throwing Axe
12254:2:4:44:Well Oiled Cloak
208140:1:15:1:Wendigo Blood
3008:2:4:11:Wendigo Fur Cloak
733:1:0:15:Westfall Stew
251524:1:7:15:Whimsyfin
4375:1:7:25:Whirring Bronze Gizmo
4781:2:4:20:Whispering Vest
8588:3:15:40:Whistle of the Emerald Raptor
13317:4:15:60:Whistle of the Ivory Raptor
8586:4:15:60:Whistle of the Mottled Red Raptor
8591:3:15:40:Whistle of the Turquoise Raptor
8592:3:15:40:Whistle of the Violet Raptor
10008:2:4:43:White Bandit Mask
275993:3:15:40:White Kodo
5574:1:1:15:White Leather Bag
3547:1:4:1:White Leather D03 Breastplate
2311:2:4:13:White Leather Jerkin
6241:2:4:10:White Linen Robe
2576:1:4:7:White Linen Shirt
13326:4:15:60:White Mechanostrider Mod A
22780:1:15:1:White Murloc Egg
3527:1:4:1:White Night Elf Breastplate
5873:3:15:40:White Ram
21577:1:15:1:White Rocket Cluster
8625:1:4:10:White Sparkler
12205:1:7:40:White Spider Meat
2415:1:15:40:White Stallion
12353:4:15:60:White Stallion Bridle
6795:1:4:32:White Swashbuckler's Shirt
23712:1:15:1:White Tiger Cub
13897:1:4:10:White Traditional Hanbok
6833:1:4:25:White Tuxedo Shirt
10040:1:4:35:White Wedding Dress
6787:2:4:22:White Woolen Dress
12633:3:4:60:Whitesoul Helm
8146:1:7:45:Wicked Claw
15085:2:4:61:Wicked Leather Armor
15088:2:4:60:Wicked Leather Belt
252479:2:4:57:Wicked Leather Boots
15084:2:4:53:Wicked Leather Bracers
15083:2:4:52:Wicked Leather Gauntlets
15086:2:4:56:Wicked Leather Headband
15087:2:4:58:Wicked Leather Pants
252556:2:4:59:Wicked Leather Shoulders
7943:2:2:45:Wicked Mithril Blade
249876:1:0:55:Wicked Smoothie
15327:1:2:40:Wicked Throwing Dagger
17021:1:15:50:Wild Berries
3771:1:0:35:Wild Hog Shank
279258:3:0:65:Wild Leather Armor Kit
8213:2:4:49:Wild Leather Boots
8215:2:4:50:Wild Leather Cloak
8214:2:4:45:Wild Leather Helmet
8212:2:4:50:Wild Leather Leggings
8210:2:4:44:Wild Leather Shoulders
8211:2:4:45:Wild Leather Vest
16169:1:0:35:Wild Ricecake
17024:1:15:50:Wild Root
3355:1:7:22:Wild Steelbloom
17026:1:15:60:Wild Thornroot
12433:1:12:1:Wildkin E'ko
221272:4:15:1:Wilds Deck
12624:3:4:54:Wildthorn Mail
8153:1:7:40:Wildvine
9144:1:0:45:Wildvine Potion
7554:2:4:19:Willow Branch
255663:1:0:1:Windstone
34086:1:4:1:Winter Boots
22324:1:0:55:Winter Kimchi
12431:1:12:1:Winterfall E'ko
12820:1:0:50:Winterfall Firewater
3819:1:7:39:Wintersbite
19047:3:4:58:Wisdom of the Timbermaw
4786:2:4:20:Wise Man's Belt
3322:2:4:10:Wispy Cloak
19703:2:12:1:Witherbark Coin
20750:1:0:50:Wizard Oil
4827:2:4:28:Wizard's Belt
14132:2:4:55:Wizardweave Leggings
14128:2:4:60:Wizardweave Robe
14130:2:4:61:Wizardweave Turban
11846:1:0:15:Wizbang's Special Brew
4794:2:4:25:Wolf Bracers
204907:1:15:1:Wolf Jawbone
8345:3:4:45:Wolfshead Helm
3189:1:2:8:Wood Chopper
11027:1:15:35:Wood Frog Box
2493:1:2:9:Wooden Mallet
4399:1:7:10:Wooden Stock
2501:1:2:9:Wooden Warhammer
3530:1:0:1:Wool Bandage
2592:1:7:15:Wool Cloth
4240:1:1:15:Woolen Bag
2583:2:4:19:Woolen Boots
2584:2:4:16:Woolen Cape
253667:1:1:15:Woolen Reagent Bag
255720:1:7:21:Woolen Tourniquet
23055:1:7:1:Word of Thawing
12264:1:15:59:Worg Carrier
18660:2:0:50:World Enlarger
223168:2:0:45:Worldcore Fragment
37:1:2:2:Worn Axe
12282:1:2:2:Worn Battleaxe
280400:1:2:2:Worn Bludgeon
2092:1:2:2:Worn Dagger
8165:1:7:45:Worn Dragonscale
7996:1:4:20:Worn Fishing Hat
258882:1:2:5:Worn Greatsword
2376:1:4:10:Worn Heater Shield
16883:1:15:30:Worn Junkbox
36:1:2:2:Worn Mace
2504:1:2:2:Worn Shortbow
25:1:2:2:Worn Shortsword
876:1:4:1:Worn Wooden Buckler
2362:1:4:1:Worn Wooden Shield
10918:1:0:32:Wound Poison
10920:1:0:40:Wound Poison II
10921:1:0:48:Wound Poison III
10922:1:0:56:Wound Poison IV
3606:1:4:10:Woven Belt
2367:1:4:10:Woven Boots
3607:1:4:10:Woven Bracers
2369:1:4:10:Woven Gloves
2366:1:4:10:Woven Pants
2364:1:4:10:Woven Vest
5015:1:0:1:Wrapped Item (PT)
21831:1:15:1:Wrappered Gift
5014:1:0:1:Wrapping Paper (PT)
4341:1:7:25:Yellow Dye
19709:3:12:61:Yellow Hakkari Bijou
11188:1:12:1:Yellow Power Crystal
21578:1:15:1:Yellow Rocket Cluster
9315:1:0:20:Yellow Rose Firework
288340:1:0:20:Yellow Rose Firework
17965:2:15:1:Yellow Sack of Gems
278569:1:0:5:Yesterday's Leftovers
251960:2:2:10:Yngwe's Axe
252023:1:0:5:Zaalanarr Sharp
7974:1:7:45:Zesty Clam Meat
19698:2:12:1:Zulian Coin
19975:1:12:1:Zulian Mudskunk
2529:1:2:46:Zweihander
]==]

-- objets liés quand ramassés et fabriqués par une recette : seulement pour la fenêtre Items (pas pour
-- les Besoins : on ne peut pas les donner). Même format. Seulement ceux de GuildUp_Craft.lua.
ns.DONNEES_OBJETS_LIES = [==[
250506:3:4:22:Acolyte's Boots
250516:3:4:17:Acolyte's Chain Belt
250501:3:4:30:Acolyte's Chain Helm
250496:3:4:25:Acolyte's Chain Leggings
250491:3:4:20:Acolyte's Chain Shirt
250511:3:4:20:Acolyte's Gloves
250531:3:4:25:Acolyte's Silvered Chain Helm
250526:3:4:30:Acolyte's Silvered Chain Leggings
250521:3:4:27:Acolyte's Silvered Chain Shirt
13503:2:4:50:Alchemist's Stone
285281:3:2:54:Arcanite Blacksmith Hammer
280311:2:4:45:Bent Goggles
254043:3:4:45:Black Cord
254101:3:4:55:Black Gloves
254027:3:4:40:Black Handwraps
254113:3:4:55:Black Sandals
254007:3:4:35:Black Slippers
254087:3:4:52:Black Waistcord
252424:3:4:15:Black Whelp Slippers
12795:3:2:60:Blood Talon
252490:3:4:20:Brawler's Leather Armor
252428:3:4:17:Brawler's Leather Belt
252439:3:4:22:Brawler's Leather Boots
252494:3:4:20:Brawler's Leather Gloves
252512:3:4:30:Brawler's Leather Helm
252504:3:4:25:Brawler's Leather Hood
252516:3:4:30:Brawler's Leather Legguards
252500:3:4:25:Brawler's Leather Pants
252508:3:4:27:Brawler's Leather Tunic
249385:3:2:60:Brilliant Wand
280308:2:4:35:Clanking Cord
12782:3:2:58:Corruption
285279:2:2:22:Cracked Blacksmith Hammer
250507:3:4:22:Crusader's Boots
250517:3:4:17:Crusader's Chain Belt
250502:3:4:30:Crusader's Chain Helm
250497:3:4:25:Crusader's Chain Leggings
250492:3:4:20:Crusader's Chain Shirt
250512:3:4:20:Crusader's Gloves
250532:3:4:25:Crusader's Silvered Chain Helm
250527:3:4:30:Crusader's Silvered Chain Leggings
250522:3:4:27:Crusader's Silvered Chain Shirt
11604:3:4:59:Dark Iron Plate
252425:3:4:15:Dark Leather Boots
252434:3:4:20:Defender's Leather Armor
252430:3:4:17:Defender's Leather Belt
252441:3:4:22:Defender's Leather Boots
252496:3:4:20:Defender's Leather Gloves
252455:3:4:30:Defender's Leather Helm
252447:3:4:25:Defender's Leather Hood
252457:3:4:30:Defender's Leather Kilt
252445:3:4:25:Defender's Leather Pants
252450:3:4:27:Defender's Leather Tunic
280313:2:4:45:Dented Goggles
249473:3:4:55:Dormant Heart of the Mountain
249454:3:2:50:Dreamstaff
260806:1:4:40:Emergency Field Cloak
228978:3:0:60:Enchanted Sigil: Flowing Waters
217308:2:0:40:Enchanted Sigil: Innovation
250595:3:4:62:Enriched Thorium Breastplate
250597:3:4:63:Enriched Thorium Helm
250596:3:4:63:Enriched Thorium Leggings
254041:3:4:45:Fiery Cord
254099:3:4:55:Fiery Gloves
254025:3:4:40:Fiery Handwraps
254111:3:4:55:Fiery Sandals
254005:3:4:35:Fiery Slippers
254085:3:4:52:Fiery Waistcord
253979:3:4:30:Filigreed Flame Circlet
253905:3:4:20:Filigreed Flame Gown
253941:3:4:25:Filigreed Flame Leggings
253983:3:4:30:Filigreed Pearly Circlet
253909:3:4:20:Filigreed Pearly Gown
253945:3:4:25:Filigreed Pearly Leggings
253975:3:4:30:Filigreed Pristine Circlet
253901:3:4:20:Filigreed Pristine Gown
253937:3:4:25:Filigreed Pristine Leggings
253981:3:4:30:Filigreed Shadow Circlet
253907:3:4:20:Filigreed Shadow Gown
253943:3:4:25:Filigreed Shadow Leggings
253985:3:4:30:Filigreed Shining Circlet
253911:3:4:20:Filigreed Shining Gown
253947:3:4:25:Filigreed Shining Leggings
253977:3:4:30:Filigreed Silky Circlet
253903:3:4:20:Filigreed Silky Gown
253939:3:4:25:Filigreed Silky Leggings
253893:3:4:17:Flame Boots
253953:3:4:25:Flame Circlet
253917:3:4:20:Flame Gloves
253965:3:4:27:Flame Gown
253991:3:4:30:Flame Leggings
253929:3:4:22:Flame Sash
280310:2:4:45:Floppy Goggles
254039:3:4:45:Frothing Cord
254097:3:4:55:Frothing Gloves
254023:3:4:40:Frothing Handwraps
254109:3:4:55:Frothing Sandals
254003:3:4:35:Frothing Slippers
254083:3:4:52:Frothing Waistcord
249469:3:4:55:Frozen Heart of the Mountain
250620:3:4:15:Gemmed Copper Boots
254037:3:4:45:Gilded Cord
254095:3:4:55:Gilded Gloves
254107:3:4:55:Gilded Sandals
254001:3:4:35:Gilded Slippers
254081:3:4:52:Gilded Waistcord
280307:2:4:35:Gizmo Girdle
249392:3:2:30:Glimmering Staff
250482:3:4:15:Glowing Copper Boots
10725:1:4:46:Gnomish Battle Chicken
10645:1:4:48:Gnomish Death Ray
10545:2:4:42:Gnomish Goggles
260824:3:4:60:Gnomish Poultryizer
10587:1:4:46:Goblin Bomb Dispenser
10543:2:4:41:Goblin Construction Helmet
10727:1:4:48:Goblin Dragon Gun
10542:2:4:41:Goblin Mining Helmet
254045:3:4:45:Golden Cord
254103:3:4:55:Golden Gloves
254029:3:4:40:Golden Handwraps
254115:3:4:55:Golden Sandals
254009:3:4:35:Golden Slippers
254089:3:4:52:Golden Waistcord
250504:3:4:22:Guard's Boots
250514:3:4:17:Guard's Chain Belt
250499:3:4:30:Guard's Chain Helm
250494:3:4:25:Guard's Chain Leggings
250489:3:4:20:Guard's Chain Shirt
250509:3:4:20:Guard's Gloves
250529:3:4:25:Guard's Silvered Chain Helm
250524:3:4:30:Guard's Silvered Chain Leggings
250519:3:4:27:Guard's Silvered Chain Shirt
277132:2:0:15:Harvester Override Signalcaster
220606:3:4:60:Idol of the Dream
250560:3:4:35:Justicar's Belt
250550:3:4:45:Justicar's Boots
250570:3:4:40:Justicar's Gauntlet
250555:3:4:55:Justicar's Gloves
250580:3:4:47:Justicar's Pauldrons
250565:3:4:52:Justicar's Sabatons
250575:3:4:55:Justicar's Waistguard
250585:3:4:50:Justicar's Wristguards
250619:3:2:63:Legionite Glaive
228175:3:4:60:Libram of Holy Alacrity
249442:3:4:45:Libram of Invocation
252523:3:4:35:Mender's Leather Belt
252472:3:4:52:Mender's Leather Boots
252543:3:4:50:Mender's Leather Bracers
252551:3:4:55:Mender's Leather Gauntlets
252530:3:4:40:Mender's Leather Gloves
252533:3:4:45:Mender's Leather Shoes
252538:3:4:47:Mender's Leather Shoulders
252477:3:4:55:Mender's Leather Waistguard
252591:3:4:55:Mender's Mail Belt
252565:3:4:45:Mender's Mail Boots
252573:3:4:50:Mender's Mail Bracers
252587:3:4:55:Mender's Mail Gauntlets
252579:3:4:52:Mender's Mail Sabatons
252569:3:4:47:Mender's Mail Shoulders
285280:2:2:39:Mithril Blacksmith Hammer
249470:3:4:55:Molten Heart of the Mountain
252427:3:4:15:Moonglow Boots
252426:3:4:15:Murloc Scale Shoes
249396:3:4:25:Mystic Mushroom
254065:3:4:50:Netherflame Cuffs
254053:3:4:47:Netherflame Shoulders
254063:3:4:50:Netherfroth Cuffs
254051:3:4:47:Netherfroth Shoulders
254061:3:4:50:Nethergeld Cuffs
254049:3:4:47:Nethergeld Shoulders
254071:3:4:50:Netherlight Cuffs
254059:3:4:47:Netherlight Shoulders
254067:3:4:50:Netherpearl Cuffs
254055:3:4:47:Netherpearl Shoulders
254069:3:4:50:Nethershine Cuffs
254057:3:4:47:Nethershine Shoulders
253885:3:4:15:Novice Arcanist's Sash
253887:3:4:15:Novice Ardent's Sash
250556:3:4:35:Officer's Belt
250546:3:4:45:Officer's Boots
250566:3:4:40:Officer's Gauntlet
250551:3:4:55:Officer's Gloves
250576:3:4:47:Officer's Pauldrons
250561:3:4:52:Officer's Sabatons
250571:3:4:55:Officer's Waistguard
250581:3:4:50:Officer's Wristguards
249394:3:4:30:Orb of Mystic Insight
249395:3:4:30:Orb of Souls
12773:2:2:55:Ornate Thorium Handaxe
253897:3:4:17:Pearly Boots
253957:3:4:25:Pearly Circlet
253921:3:4:20:Pearly Gloves
253969:3:4:27:Pearly Gown
253995:3:4:30:Pearly Leggings
253933:3:4:22:Pearly Sash
9149:1:4:45:Philosopher's Stone
249398:3:4:25:Polished Driftwood Icon
250559:3:4:35:Prefect's Belt
250549:3:4:45:Prefect's Boots
250569:3:4:40:Prefect's Gauntlet
250554:3:4:55:Prefect's Gloves
250579:3:4:47:Prefect's Pauldrons
250564:3:4:52:Prefect's Sabatons
250574:3:4:55:Prefect's Waistguard
250584:3:4:50:Prefect's Wristguards
253889:3:4:17:Pristine Boots
253949:3:4:25:Pristine Circlet
253913:3:4:20:Pristine Gloves
253961:3:4:27:Pristine Gown
253987:3:4:30:Pristine Leggings
253925:3:4:22:Pristine Sash
250505:3:4:22:Protector's Boots
250515:3:4:17:Protector's Chain Belt
250500:3:4:30:Protector's Chain Helm
250495:3:4:25:Protector's Chain Leggings
250490:3:4:20:Protector's Chain Shirt
250510:3:4:20:Protector's Gloves
250530:3:4:25:Protector's Silvered Chain Helm
250525:3:4:30:Protector's Silvered Chain Leggings
250520:3:4:27:Protector's Silvered Chain Shirt
252459:3:4:35:Prowler's Leather Belt
252468:3:4:52:Prowler's Leather Boots
252539:3:4:50:Prowler's Leather Bracers
252547:3:4:55:Prowler's Leather Gauntlets
252524:3:4:40:Prowler's Leather Gloves
252465:3:4:45:Prowler's Leather Shoes
252534:3:4:47:Prowler's Leather Shoulders
252473:3:4:55:Prowler's Leather Waistguard
254047:3:4:45:Radiant Cord
254105:3:4:55:Radiant Gloves
254031:3:4:40:Radiant Handwraps
254117:3:4:55:Radiant Sandals
254011:3:4:35:Radiant Slippers
249453:3:2:50:Radiant Staff
254091:3:4:52:Radiant Waistcord
7054:3:4:38:Robe of Power
14152:4:4:62:Robe of the Archmage
14153:4:4:62:Robe of the Void
16207:1:7:58:Runed Arcanite Rod
6218:1:7:5:Runed Copper Rod
11130:1:7:30:Runed Golden Rod
6339:1:7:20:Runed Silver Rod
11145:1:7:40:Runed Truesilver Rod
285276:2:2:33:Satchel of Bronze Bombs
285275:2:2:18:Satchel of Copper Bombs
285278:2:2:57:Satchel of Dark Iron Bombs
285277:2:2:46:Satchel of Iron Bombs
250557:3:4:35:Sentinel's Belt
250547:3:4:45:Sentinel's Boots
250567:3:4:40:Sentinel's Gauntlet
250552:3:4:55:Sentinel's Gloves
250577:3:4:47:Sentinel's Pauldrons
250562:3:4:52:Sentinel's Sabatons
250572:3:4:55:Sentinel's Waistguard
250582:3:4:50:Sentinel's Wristguards
253895:3:4:17:Shadow Boots
253955:3:4:25:Shadow Circlet
253919:3:4:20:Shadow Gloves
253967:3:4:27:Shadow Gown
253993:3:4:30:Shadow Leggings
253931:3:4:22:Shadow Sash
253899:3:4:17:Shining Boots
253959:3:4:25:Shining Circlet
253923:3:4:20:Shining Gloves
253971:3:4:27:Shining Gown
253997:3:4:30:Shining Leggings
253935:3:4:22:Shining Sash
253891:3:4:17:Silky Boots
253951:3:4:25:Silky Circlet
253915:3:4:20:Silky Gloves
253963:3:4:27:Silky Gown
253989:3:4:30:Silky Leggings
253927:3:4:22:Silky Sash
252461:3:4:35:Skirmisher's Leather Belt
252528:3:4:40:Skirmisher's Leather Gloves
252590:3:4:55:Skirmisher's Mail Belt
252564:3:4:45:Skirmisher's Mail Boots
252572:3:4:50:Skirmisher's Mail Bracers
252586:3:4:55:Skirmisher's Mail Gauntlets
252578:3:4:52:Skirmisher's Mail Sabatons
252568:3:4:47:Skirmisher's Mail Shoulders
252520:3:4:35:Skulker's Leather Belt
252469:3:4:52:Skulker's Leather Boots
252540:3:4:50:Skulker's Leather Bracers
252548:3:4:55:Skulker's Leather Gauntlets
252525:3:4:40:Skulker's Leather Gloves
252531:3:4:45:Skulker's Leather Shoes
252535:3:4:47:Skulker's Leather Shoulder
252474:3:4:55:Skulker's Leather Waistguard
252522:3:4:35:Skycaller's Leather Belt
252471:3:4:52:Skycaller's Leather Boots
252542:3:4:50:Skycaller's Leather Bracers
252550:3:4:55:Skycaller's Leather Gauntlets
252529:3:4:40:Skycaller's Leather Gloves
252532:3:4:45:Skycaller's Leather Shoes
252537:3:4:47:Skycaller's Leather Shoulders
252476:3:4:55:Skycaller's Leather Waistguard
252589:3:4:55:Skycaller's Mail Belt
252563:3:4:45:Skycaller's Mail Boots
252571:3:4:50:Skycaller's Mail Bracers
252585:3:4:55:Skycaller's Mail Gauntlets
252577:3:4:52:Skycaller's Mail Sabatons
252567:3:4:47:Skycaller's Mail Shoulders
249393:3:2:30:Soulstaff
252521:3:4:35:Stalker's Leather Belt
252526:3:4:40:Stalker's Leather Gloves
252588:3:4:55:Stalker's Mail Belt
252562:3:4:45:Stalker's Mail Boots
252570:3:4:50:Stalker's Mail Bracers
252584:3:4:55:Stalker's Mail Gauntlets
252576:3:4:52:Stalker's Mail Sabatons
252566:3:4:47:Stalker's Mail Shoulders
252492:3:4:20:Stormrider's Leather Armor
252432:3:4:17:Stormrider's Leather Belt
252443:3:4:22:Stormrider's Leather Boots
252498:3:4:20:Stormrider's Leather Gloves
252514:3:4:30:Stormrider's Leather Helm
252506:3:4:25:Stormrider's Leather Hood
252518:3:4:30:Stormrider's Leather Kilt
252502:3:4:25:Stormrider's Leather Pants
252510:3:4:27:Stormrider's Leather Tunic
250621:3:4:15:Strange Copper Boots
280312:2:4:45:Stuckbutton Goggles
274387:4:6:65:Swiftfeather Arrow
274388:4:6:65:Swiftstrike Shot
249441:3:4:45:Talons of Wrath
249397:3:4:25:Tenets of the Silver Hand
250614:3:2:55:Thorium Cestus
250613:3:2:55:Thorium Greatmace
249443:3:4:45:Totem of Ancestral Protection
228176:3:4:65:Totem of Thunder
252435:3:4:20:Totemic Leather Armor
252431:3:4:17:Totemic Leather Belt
252442:3:4:22:Totemic Leather Boots
252497:3:4:20:Totemic Leather Gloves
252456:3:4:30:Totemic Leather Helm
252448:3:4:25:Totemic Leather Hood
252458:3:4:30:Totemic Leather Leggings
252446:3:4:25:Totemic Leather Pants
252451:3:4:27:Totemic Leather Tunic
252491:3:4:20:Trapper's Leather Armor
252429:3:4:17:Trapper's Leather Belt
252440:3:4:22:Trapper's Leather Boots
252495:3:4:20:Trapper's Leather Gloves
252513:3:4:30:Trapper's Leather Helm
252505:3:4:25:Trapper's Leather Hood
252517:3:4:30:Trapper's Leather Legguards
252501:3:4:25:Trapper's Leather Pants
252509:3:4:27:Trapper's Leather Tunic
14154:4:4:62:Truefaith Vestments
249455:3:4:50:Truesilver Conduit
249456:3:4:50:Twisting Essence Jar
250503:3:4:22:Veteran's Boots
250513:3:4:17:Veteran's Chain Belt
250498:3:4:30:Veteran's Chain Helm
250493:3:4:25:Veteran's Chain Leggings
250488:3:4:20:Veteran's Chain Shirt
250508:3:4:20:Veteran's Gloves
250528:3:4:25:Veteran's Silvered Chain Helm
250523:3:4:30:Veteran's Silvered Chain Leggings
250518:3:4:27:Veteran's Silvered Chain Shirt
252460:3:4:35:Warden's Leather Belt
252470:3:4:52:Warden's Leather Boots
252541:3:4:50:Warden's Leather Bracers
252549:3:4:55:Warden's Leather Gauntlets
252527:3:4:40:Warden's Leather Gloves
252466:3:4:45:Warden's Leather Shoes
252536:3:4:47:Warden's Leather Shoulders
252475:3:4:55:Warden's Leather Waistguard
250558:3:4:35:Warder's Belt
250548:3:4:45:Warder's Boots
250568:3:4:40:Warder's Gauntlet
250553:3:4:55:Warder's Gloves
250578:3:4:47:Warder's Pauldrons
250563:3:4:52:Warder's Sabatons
250573:3:4:55:Warder's Waistguard
250583:3:4:50:Warder's Wristguards
280306:2:4:35:Whimsical Waistwrap
252493:3:4:20:Wisdom's Leather Armor
252433:3:4:17:Wisdom's Leather Belt
252444:3:4:22:Wisdom's Leather Boots
252499:3:4:20:Wisdom's Leather Gloves
252515:3:4:30:Wisdom's Leather Helm
252507:3:4:25:Wisdom's Leather Hood
252519:3:4:30:Wisdom's Leather Leggings
252503:3:4:25:Wisdom's Leather Pants
252511:3:4:27:Wisdom's Leather Tunic
]==]
