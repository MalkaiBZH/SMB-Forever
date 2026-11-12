-- GuildUp : noms français de tous les objets échangeables du jeu (ni liés quand ramassés, ni de quête,
-- ni gris), pour chercher un objet par son nom dans les Besoins même sans l'avoir sur soi.
-- Généré depuis les données du client WoW Forever 1.60.1.70862, français (wago.tools : ItemSparse, Item)
-- par outils/generer_objets.py. Ne pas modifier à la main.
-- Une ligne par objet : id:qualité:classe:niveau d'objet:nom (classe 7 = artisanat, 5 = composant)
-- Client anglais (enUS, enGB) : ce fichier ne fait rien, GuildUp_Objets_enUS.lua donne les noms anglais.
-- Le texte n'est alors gardé nulle part : il disparaît avec le fichier après son chargement.

local NOM_ADDON, ns = ...

local langue = GetLocale and GetLocale()
if langue == "enUS" or langue == "enGB" then return end

ns.DONNEES_OBJETS = [==[
20351:2:4:63:63 Green Frost Belt
20352:2:4:63:63 Green Frost Bindings
20355:2:4:63:63 Green Frost Gloves
20311:2:4:63:63 Green Rogue Belt
20314:2:4:63:63 Green Rogue Bracers
20280:2:2:63:63 Green Warrior Axe
20285:2:2:63:63 Green Warrior Gun
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
18512:1:7:55:Acide de larve
249410:2:7:25:Acide sulfurique
3355:1:7:22:Aciérite sauvage
1206:2:7:25:Agate mousse
18660:2:0:50:Agrandisseur de monde
275619:3:4:58:Agrippeurs de garde-couvée
275616:3:4:58:Agrippeurs de tripécaille
7909:2:7:45:Aigue-marine
3404:1:7:35:Aile de busard
4457:1:0:35:Aile de busard grillée
12223:1:7:5:Aile de chauve-souris charnue
12224:1:0:10:Aile de chauve-souris croustillante
1468:1:7:16:Aileron de murloc
19224:1:0:35:Ailes de poulet pimentées
7069:1:7:25:Air élémentaire
10719:1:0:41:Alarme mobile
18631:1:7:50:Altérateur de vrai-argent
6566:1:4:24:Amict chatoyant
14126:1:4:23:Amict rituel
19166:4:2:66:Amnistie noire
279277:1:0:1:Amulette de Mathystra
289297:4:2:40:Anathème
8589:1:15:40:Ancien sifflet de raptor ivoire
8590:1:15:40:Ancien sifflet de raptor obsidienne
2896:1:15:34:Angoisse progressive
13422:1:7:45:Anguille pierre-écaille
13757:1:7:45:Anguille électrique
17030:1:5:30:Ankh
12947:6:4:60:Anneau audacieux d'Alex
7338:1:4:10:Anneau changeant
7341:1:4:20:Anneau cubique de Zirconia
7426:2:4:30:Anneau céruléen
7342:1:4:30:Anneau d'argent de Piffeny
20451:1:12:60:Anneau d'autorité de sectateur du crépuscule
7497:2:4:40:Anneau d'ivoire
7547:2:4:46:Anneau d'onyx
1993:2:4:36:Anneau de concentration
288927:4:4:30:Anneau de frappe rapide
1077:2:4:26:Anneau de mage défias
288931:4:4:30:Anneau de puissance des sorts
1189:2:4:20:Anneau de surveillant
5008:2:4:36:Anneau de vif-argent
1462:2:4:25:Anneau des ténèbres
20721:3:4:65:Anneau du sectateur
272001:2:15:60:Anneau d’or
20692:2:4:60:Anneau multicolore
5743:2:4:40:Anneau prismatique
1996:2:4:37:Anneau vaudou
7466:2:4:37:Anneau vermeil
6589:2:4:26:Anneau viridien
7339:1:4:40:Anneau à minuscule diamant
288928:4:4:30:Anneau épais en sombrefer
12798:3:2:63:Annihilateur
239092:1:12:1:Annonce affreusement ampoulée
6452:1:0:16:Anti-venin
255715:1:7:36:Anti-venin efficace
19440:1:0:58:Anti-venin puissant
19974:1:12:1:Appât au Puant de vase
268880:1:0:10:Appât « secret »
210410:1:15:1:Appât à mordeuse d’eau douce
13843:1:15:25:Après-midi automnal/hivernal
13847:1:15:25:Après-midi printanier/estival
15809:1:2:34:Arbalète lourde
15807:1:2:8:Arbalète légère
237023:1:0:1:Arbuste improvisé
2507:1:2:16:Arc courbe composite
2506:1:2:8:Arc courbe en bois de corne
3027:1:2:25:Arc courbe lourd
11305:2:2:35:Arc court dense
2505:1:2:4:Arc court poli
11308:2:2:49:Arc court sylvestre
8179:1:2:6:Arc de cadet
14394:1:2:1:Arc endurant
4763:2:2:9:Arc incurvé de noirbois
3028:1:2:34:Arc long
11307:2:2:47:Arc long de puissance
11306:2:2:32:Arc long solide
3026:1:2:21:Arc renforcé
213379:3:7:40:Arcano-filament hyperconducteur
6038:1:0:35:Ardeur de palourde géante
15085:2:4:61:Armure corrompue en cuir
10384:2:4:65:Armure d'Hypérion
7375:2:4:35:Armure de dragonnet vert
4256:2:4:35:Armure de gardien
252483:4:4:61:Armure de l’aube
8094:1:4:50:Armure de plates
4190:1:4:27:Armure de plumes
7374:2:4:35:Armure en cuir mat
2314:2:4:24:Armure en cuir raffermi
236:1:4:22:Armure en cuir traité
252480:2:4:58:Armure en suédine bleue
12405:2:4:50:Armure en thorium
837:1:4:17:Armure en toile renforcée
252552:2:4:56:Armure ouvragée en cuir
15090:2:4:62:Armure runique en cuir
15056:3:4:57:Armure tempétueuse
4255:2:4:31:Armure verte en cuir
7065:2:4:33:Armure verte en soie
5782:2:4:34:Armure épaisse de murloc
19268:3:12:1:As d'Elémentaires
221298:3:15:1:As de Cauchemar
221290:3:15:1:As de Dunes
19227:3:12:1:As de Fauves
221271:3:15:1:As de Nature
221281:3:15:1:As de Plaies
19276:3:12:1:As de Portails
19258:3:12:1:As de Seigneurs de guerre
22136:1:15:1:Assortiment de cadeaux d'Orgrimmar
22133:1:15:1:Assortiment de cadeaux de Darnassus
22132:1:15:1:Assortiment de cadeaux de Forgefer
22134:1:15:1:Assortiment de cadeaux de Fossoyeuse
22131:1:15:1:Assortiment de cadeaux de Hurlevent
22262:1:15:1:Assortiment de cadeaux de l'Alliance
22263:1:15:1:Assortiment de cadeaux de la Horde
22135:1:15:1:Assortiment de cadeaux de Thunder Bluff
22294:1:15:1:Assortiment de serments d'Orgrimmar
22290:1:15:1:Assortiment de serments de Darnassus
22286:1:15:1:Assortiment de serments de Forgefer
22300:1:15:1:Assortiment de serments de Fossoyeuse
22285:1:15:1:Assortiment de serments de Hurlevent
22297:1:15:1:Assortiment de serments de Thunder Bluff
6530:1:0:20:Asticots
6533:1:0:30:Attracteur de poissons aquadynamique
8839:1:7:47:Aveuglette
250618:3:2:63:Bagh Nakh
288930:4:4:30:Bague de cautérisation
5000:2:4:26:Bague de corail
281927:2:4:27:Bague de Rochecœur
288929:4:4:30:Bague de Sulfuras
5210:1:2:25:Baguette ardente
249234:2:2:48:Baguette branchonirique
5209:1:2:21:Baguette d'obscurité
5239:1:2:46:Baguette de Blackbone
5236:1:2:34:Baguette de combustible
5211:1:2:25:Baguette de crépuscule
5208:1:2:20:Baguette de fonte
5347:1:2:35:Baguette de pestilence
5238:1:2:45:Baguette de Pitchwood
249144:2:2:42:Baguette du Néant distordue
247789:1:2:6:Baguette d’entraînement de novice
11287:2:2:15:Baguette magique inférieure
11288:2:2:23:Baguette magique supérieure
11289:2:2:31:Baguette mystique inférieure
217287:2:2:35:Baguette mystique supérieure
15945:2:4:18:Baguette runique
249232:2:2:54:Baguette éternelle inférieure
249237:2:2:60:Baguette éternelle supérieure
249796:1:0:55:Baies d’Hyjal
17021:1:15:50:Baies sauvages
3335:1:2:6:Balai de fermier
3033:1:6:30:Balle dure
8069:1:6:35:Balle dure fabriquée
18662:1:0:1:Balle en cuir lourd
3465:2:6:36:Balle explosive
10513:2:6:49:Balle gyroscopique en mithril
2519:1:6:15:Balle lourde
8068:1:6:20:Balle lourde fabriquée
2516:1:6:5:Balle légère
8067:1:6:10:Balle légère fabriquée
11284:1:6:45:Balles de précision
10512:2:6:42:Balles perçantes en mithril
22287:1:15:1:Ballot de cartes
4537:1:0:15:Banane de Tel'Abim
8953:1:0:55:Bananes frites
3530:1:0:1:Bandage en laine
1251:1:0:1:Bandage en lin
6450:1:0:1:Bandage en soie
8544:1:0:1:Bandage en tisse-mage
14529:1:0:52:Bandage en étoffe runique
23684:1:0:60:Bandage imprégné de cristaux
3531:1:0:1:Bandage épais en laine
2581:1:0:1:Bandage épais en lin
6451:1:0:1:Bandage épais en soie
8545:1:0:1:Bandage épais en tisse-mage
14530:1:0:58:Bandage épais en étoffe runique
232433:1:0:70:Bandage épais en étoffe runique
210781:3:4:30:Bandages du phénix
15086:2:4:56:Bandeau corrompu en cuir
3536:1:4:1:Bandeau de chasseur de démon
8176:2:4:41:Bandeau de la nuit
7050:2:4:32:Bandeau en soie
13866:2:4:59:Bandeau en étoffe runique
10032:2:4:48:Bandeau en étoffe-tempête
10024:2:4:46:Bandeau noir en tisse-mage
10033:2:4:48:Bandeau rouge en tisse-mage
15094:2:4:58:Bandeau runique en cuir
279972:1:0:4:Bannière de faction
279973:1:0:4:Bannière de faction
241090:2:2:28:Bardiche écarlate
13917:1:15:55:Barracuda de 103 livres
13914:1:15:55:Barracuda de 70 livres
13915:1:15:55:Barracuda de 85 livres
13916:1:15:55:Barracuda de 92 livres
13754:1:7:45:Barracuda luisant cru
13927:1:0:45:Barracuda luisant cuit
18635:1:0:45:Barre aux noisettes de Bellara
3859:1:7:35:Barre d'acier
12360:2:7:55:Barre d'arcanite
2842:2:7:10:Barre d'argent
3577:2:7:30:Barre d'or
17771:5:7:60:Barre d'élémentium
3576:1:7:20:Barre d'étain
2841:1:7:20:Barre de bronze
7807:1:0:5:Barre de chocolat
2840:1:7:10:Barre de cuivre
3575:1:7:30:Barre de fer
251290:2:7:60:Barre de légionite
3860:1:7:40:Barre de mithril
11371:1:7:50:Barre de sombrefer
12359:1:7:50:Barre de thorium
12655:1:7:55:Barre de thorium enchanté
251291:2:7:60:Barre de thorium lourd
6037:2:7:50:Barre de vrai-argent
249726:2:7:55:Barre d’azerothium
19049:3:4:61:Batailleurs grumegueules
10558:1:7:30:Batterie en or
260822:2:0:60:Batterie rechargeable super sûre
213558:1:12:1:Baume élémentaire
249425:2:7:45:Bauxite
2683:1:0:15:Beignet de crabe
268912:1:0:15:Beignet de crabe en fin de vie
15808:1:2:21:Belle arbalète légère
3422:1:4:30:Belles fleurs sauvages
10030:2:4:48:Bicorne d'amiral
2595:1:0:35:Bidon de bourbon des terres Ingrates
4375:1:7:25:Bidule bourdonnant en bronze
5227:1:0:37:Bijou de mana vide
19714:3:12:61:Bijou hakkari argenté
19708:3:12:61:Bijou hakkari bleu
19713:3:12:61:Bijou hakkari bronze
19715:3:12:61:Bijou hakkari doré
19709:3:12:61:Bijou hakkari jaune
19710:3:12:61:Bijou hakkari orange
19707:3:12:61:Bijou hakkari rouge
19711:3:12:61:Bijou hakkari vert
19712:3:12:61:Bijou hakkari violet
12033:1:15:60:Bijoux de la famille Thaurissan
4960:1:6:7:Bille d'éclair
17197:1:0:10:Biscuit de pain d'épice
13724:1:0:55:Biscuit enrichi en manne
232436:1:0:55:Bisque de Pince-noire
3729:1:0:25:Bisque de tortue apaisante
22173:1:15:1:Bière artisanale naine
2894:1:0:1:Bière au malt Rhapsody
19222:1:0:1:Bière bon marché
12003:1:0:55:Bière brune naine
5265:1:0:1:Bière coupée
17402:1:0:35:Bière du Grandpère Hiver
3703:1:0:1:Bière d’Austrivage
17404:1:0:15:Bière mélangée
11846:1:0:15:Bière spéciale de Wizbang
3024:1:2:26:BKP 2700 "Massacreur"
3025:1:2:36:BKP 42 "Ultra"
20513:2:12:1:Blason abyssal
20420:1:12:1:Blason de signal : Eau
20416:1:12:1:Blason de signal : Feu
20419:1:12:1:Blason de signal : Pierre
20418:1:12:1:Blason de signal : Tonnerre
2070:1:0:5:Bleu de Darnassus
280703:1:15:30:Boa de la jungle
2320:1:7:5:Bobine de fil grossier
2321:1:7:20:Bobine de fil raffiné
4291:1:7:30:Bobine de soie
8343:1:7:40:Bobine de soie lourde
279967:1:0:4:Bocal à poisson
19304:1:0:15:Boeuf séché épicé
11291:1:7:30:Bois d'étoile
12769:3:2:54:Bois morne taillé
4470:1:7:5:Bois simple
19299:1:0:25:Boisson gazeuse de la foire
260818:1:0:60:Bombe de mana Ev-Lan
16040:1:0:60:Bombe des arcanes
260797:1:0:34:Bombe en bronze SUR-T
260793:1:0:19:Bombe en cuivre SUR-T
260795:1:0:31:Bombe en cuivre XL Ev-Lan
16005:1:0:57:Bombe en sombrefer
10562:1:0:47:Bombe explosive
10514:1:0:43:Bombe explosive en mithril
260809:1:0:48:Bombe explosive VRÉ-clencheur
4360:1:0:14:Bombe grossière en cuivre
260805:1:0:48:Bombe SUR-T
260817:1:0:60:Bombe ténébreuse Ev-Lan
4852:1:0:37:Bombe éclairante
11825:1:0:41:Bombinette
11303:2:2:16:Bon arc court
11304:2:2:19:Bon arc long
5264:1:12:1:Bon pour une bière gratuite
274976:1:0:35:Bonne vieille viande de brochepâle
4788:2:4:20:Bottes agiles
3289:1:4:11:Bottes ancestrales
8209:2:4:47:Bottes armées du scorpide
7916:2:4:36:Bottes barbares en fer
2426:1:4:50:Bottes brigandines
250542:2:4:45:Bottes brillantes en mithril
2438:1:4:50:Bottes brodées
2432:1:4:37:Bottes brun-roux
250587:2:4:52:Bottes bénies en plaques
168664:2:4:1:Bottes cachées
15073:2:4:55:Bottes chimériques
252479:2:4:57:Bottes corrompues en cuir
55:1:4:1:Bottes d'apprenti
6506:1:4:11:Bottes d'infanterie
4789:2:4:18:Bottes d'écurie
43:1:4:1:Bottes d'écuyer
140:1:4:1:Bottes de bagarreur
3279:1:4:12:Bottes de bataille en anneaux
269503:2:4:60:Bottes de braconnage
9759:1:4:13:Bottes de cadet
2975:1:4:14:Bottes de chasse
275612:3:4:58:Bottes de cloque-bilieuse
2959:1:4:9:Bottes de compagnon
271673:1:4:1:Bottes de crapule du bosquet
7351:1:4:11:Bottes de disciple
47:1:4:1:Bottes de détrousseur
15481:1:4:13:Bottes de guerre déchirées
2967:1:4:10:Bottes de guerrier
271671:1:4:1:Bottes de guerrier de Thendal
19056:3:4:58:Bottes de l'Aube d'argent
4325:2:4:35:Bottes de l'enchanteur
18506:3:4:62:Bottes de la mangouste
8197:2:4:47:Bottes de la nuit
22760:3:4:70:Bottes de la ronceraie
2971:1:4:14:Bottes de lieur de sort
276541:4:4:61:Bottes de mande-esprit
121:1:4:1:Bottes de nervi
6138:1:4:1:Bottes de nervi
271661:1:4:1:Bottes de novice de Thendal
51:1:4:1:Bottes de néophyte
3332:1:4:9:Bottes de Perrine
6518:1:4:11:Bottes de pionnier
8089:1:4:50:Bottes de plates
4195:1:4:27:Bottes de plumes
7391:2:4:40:Bottes de rapidité
40:1:4:1:Bottes de recrue
6122:1:4:1:Bottes de recrue
15071:2:4:55:Bottes de sabre-de-givre
275615:3:4:58:Bottes de saccage-essaim
271665:1:4:1:Bottes de survivaliste de Thendal
2979:1:4:14:Bottes de vétéran
7095:1:4:9:Bottes des tourbières
7027:2:4:28:Bottes des ténèbres
250534:2:4:35:Bottes dorées dures
15473:1:4:10:Bottes du destrier
16982:4:4:59:Bottes du Magma
6127:1:4:1:Bottes du trappeur
271659:1:4:1:Bottes d’apprenti de Thendal
34086:1:4:1:Bottes d’hiver
252449:2:4:27:Bottes d’homme des collines en cuir
3846:2:4:37:Bottes en acier poli
3469:2:4:10:Bottes en anneaux de cuivre
2420:1:4:37:Bottes en anneaux doublés
2401:1:4:10:Bottes en anneaux légers
2389:1:4:5:Bottes en anneaux rouillés
2383:1:4:5:Bottes en anneaux ternis
250483:2:4:25:Bottes en argent fin
3482:2:4:26:Bottes en bronze argenté
2143:1:4:27:Bottes en cuir bouilli
2963:1:4:9:Bottes en cuir brûlé
2467:1:4:37:Bottes en cuir clouté
2302:1:4:8:Bottes en cuir cousu main
2123:1:4:5:Bottes en cuir craquelé
2309:2:4:15:Bottes en cuir estampé
2315:2:4:20:Bottes en cuir gris
3542:1:4:1:Bottes en cuir gris D02
796:1:4:10:Bottes en cuir grossier
2473:1:4:50:Bottes en cuir renforcé
3533:1:4:1:Bottes en cuir rouge C03
210:1:4:5:Bottes en cuir sale
8213:2:4:49:Bottes en cuir sauvage
843:1:4:17:Bottes en cuir tanné
238:1:4:22:Bottes en cuir traité
3484:2:4:29:Bottes en fer émeraude
14108:2:4:57:Bottes en gangrétoffe
2583:2:4:19:Bottes en laine
2569:2:4:13:Bottes en lin
4312:2:4:16:Bottes en lin à semelle souple
10046:1:4:9:Bottes en lin écru
849:1:4:17:Bottes en mailles
2395:1:4:10:Bottes en mailles légères
12616:2:4:63:Bottes en mailles sauvages
4320:3:4:25:Bottes en soie d'araignée
20039:4:4:70:Bottes en sombrefer
12409:2:4:56:Bottes en thorium
254129:2:4:60:Bottes en tisse-fantôme
10031:2:4:48:Bottes en tisse-ombre
254093:2:4:54:Bottes en tisse-terrestre
19684:3:4:65:Bottes en vignesang
287:1:4:22:Bottes en écailles
16984:4:4:61:Bottes en écailles de dragon noir
252602:2:4:61:Bottes en écailles de scorpide chargées
252574:2:4:51:Bottes en écailles de scorpide souples
252594:2:4:56:Bottes en écailles de scorpide épaisses
3847:2:4:40:Bottes en écailles dorées
2149:1:4:27:Bottes en écailles polies
10044:2:4:49:Bottes en étoffe cendrée
15802:3:4:56:Bottes en étoffe lunaire
195:1:4:5:Bottes en étoffe rapiécées
13864:2:4:56:Bottes en étoffe runique
10039:2:4:50:Bottes en étoffe-tempête
2373:1:4:10:Bottes endommagées en cuir
14384:1:4:1:Bottes endurantes
277672:2:4:10:Bottes grossières en anneaux de cuivre
6350:2:4:18:Bottes grossières en bronze
12426:2:4:59:Bottes impériales en plaques
279268:4:4:65:Bottes incrustées de givre
7933:2:4:47:Bottes lourdes en mithril
19048:3:4:61:Bottes lourdes grumegueule
2156:1:4:27:Bottes matelassées
7390:2:4:40:Bottes mattes
3541:1:4:1:Bottes noires en cuir D02
10026:2:4:46:Bottes noires en tisse-mage
7936:2:4:49:Bottes ornées en mithril
252545:2:4:53:Bottes ouvragées en cuir
6148:1:4:10:Bottes poussiéreuses
15004:1:4:9:Bottes primordiales
12419:2:4:58:Bottes radieuses
129:1:4:1:Bottes robustes de trappeur
4313:2:4:20:Bottes rouges en laine
12611:2:4:60:Bottes runiques en plaques
20537:3:4:63:Bottes runiques ténébreuses
6201:2:4:12:Bottes souples
277027:2:4:11:Bottes tisse-souffle azur
277003:2:4:11:Bottes tisse-souffle nuageuses
2367:1:4:10:Bottes tissées
3284:1:4:12:Bottes tribales
2307:2:4:18:Bottes élégantes en cuir
10724:2:4:45:Bottes-fusées gnomes
7189:2:4:45:Bottes-fusées gobelines
277033:2:4:11:Bottillons mêle-vent azur
277009:2:4:11:Bottillons mêle-vent nuageux
3311:1:4:15:Bottines de cérémonie en cuir
275621:3:4:58:Bottines de garde-couvée
275618:3:4:58:Bottines de tripécaille
3321:1:4:9:Bottines en fourrure grise
6358:1:7:15:Bouche-noire huileux
263512:1:0:15:Bouchées à la chair de pinces
7071:1:7:30:Boucle en fer
11199:1:4:1:Bouclier d'ingénieur 1
11200:1:4:1:Bouclier d'ingénieur 2
11201:1:4:1:Bouclier d'ingénieur 3
3650:1:4:9:Bouclier de guerre
1438:1:4:9:Bouclier de guerrier
22198:4:4:70:Bouclier dentelé en obsidienne
6203:2:4:13:Bouclier des nervis
15478:1:4:8:Bouclier du destrier
14393:1:4:1:Bouclier endurant
4263:1:4:10:Bouclier militaire
9444:1:4:26:Bouclier processeur de Techbot
279262:4:4:65:Bouclier sempervirent
3220:1:0:15:Boudin
279962:1:0:4:Bougie d’encens
1399:1:0:8:Bougie magique
17027:1:15:36:Bougie parfumée
17029:1:15:60:Bougie sacrée
17028:1:15:48:Bougie sanctifiée
278118:1:0:35:Bouillon savoureux
17202:1:15:5:Boule de neige
21038:1:0:5:Boule de neige durcie
12973:1:13:1:Boulet de canon écarlate
20452:1:0:55:Boulettes fumées du désert
288339:1:0:20:Bouquet de feux d’artifice rouges
3423:1:4:50:Bouquet de roses blanches
3424:1:4:60:Bouquet de roses noires
9314:1:0:20:Bouquet rouge
18287:1:0:1:Bourbe
22250:2:1:20:Bourse d'herbes
21340:2:1:52:Bourse d'âme
22246:2:1:45:Bourse enchantée en tisse-mage
273050:1:15:1:Bourse noiregueule
19300:1:0:45:Bouteille d'eau de Berceau-de-l'Hiver
2723:1:0:1:Bouteille de Dalaran noir
1072:1:0:25:Bouteille de tord-boyaux pleine
6651:1:2:12:Bouteille de vin brisée
21309:1:15:1:Boîte de bonhomme de neige
6827:1:15:40:Boîte de fournitures
9541:1:15:47:Boîte de fournitures
19291:1:1:45:Boîte de rangement de Sombrelune
9539:1:15:1:Boîte de rations
22291:1:15:1:Boîte de sculptures sur bois
9540:1:15:1:Boîte de sorts
22292:1:15:1:Boîte de tartelettes
21305:1:15:1:Boîte à assistant rouge
21301:1:15:1:Boîte à assistant vert
274041:1:15:1:Boîte à documents
11027:1:15:35:Boîte à Grenouille forestière
11026:1:15:35:Boîte à Grenouille sylvestre
8502:2:15:20:Boîte-surprise en bronze
8504:2:15:30:Boîte-surprise en fer
8506:2:15:40:Boîte-surprise en mithril
8503:2:15:25:Boîte-surprise lourde en bronze
8505:2:15:35:Boîte-surprise lourde en fer
8507:2:15:45:Boîte-surprise lourde en mithril
15985:2:4:57:Branche arachnéenne
15976:2:4:36:Branche crin-de-chardon
7094:1:2:10:Branche de bois
7554:2:4:19:Branche de saule
9769:2:4:27:Branche en tisse-vert
15970:2:4:15:Branche indigène
15933:2:4:15:Branche simple
15936:2:4:55:Branche tissée de crépuscule
15963:2:4:39:Branche étoffe-de-pierre
3642:1:4:9:Brassards ancestraux
8205:2:4:44:Brassards armés du scorpide
18948:3:4:32:Brassards barbares
3644:1:4:12:Brassards barbares en tissu
3224:2:4:12:Brassards bordés d'argent
2427:1:4:50:Brassards brigandines
3588:1:4:50:Brassards brodés
3594:1:4:37:Brassards brun-roux
250590:2:4:57:Brassards bénis en plaques
168665:2:4:1:Brassards cachés
15084:2:4:53:Brassards corrompus en cuir
763:2:4:12:Brassards couverts de glace
6507:1:4:10:Brassards d'infanterie
3280:1:4:9:Brassards de bataille en anneaux
9760:1:4:12:Brassards de cadet
3207:1:4:14:Brassards de chasse
3641:1:4:8:Brassards de compagnon
20481:3:4:62:Brassards de crache-feu
3312:1:4:13:Brassards de cérémonie en cuir
7350:1:4:10:Brassards de disciple
7386:2:4:38:Brassards de dragonnet vert
4260:2:4:39:Brassards de gardien en cuir
3214:1:4:9:Brassards de guerrier
4795:2:4:25:Brassards de l'ours
4796:2:4:25:Brassards de la chouette
3643:1:4:14:Brassards de lieur de sort
6519:1:4:10:Brassards de pionnier
8090:1:4:50:Brassards de plates
4194:1:4:27:Brassards de plumes
20476:3:4:62:Brassards de traqueuse des sables
18508:3:4:62:Brassards de vol rapide
3213:1:4:13:Brassards de vétéran
3303:1:4:12:Brassards des eaux stagnantes
1213:1:4:14:Brassards des gnolls
250535:2:4:37:Brassards dorés durs
15297:1:4:11:Brassards du grizzly
4794:2:4:25:Brassards du loup
2421:1:4:37:Brassards en anneaux doublés
2402:1:4:10:Brassards en anneaux légers
2390:1:4:5:Brassards en anneaux rouillés
2384:1:4:5:Brassards en anneaux ternis
2144:1:4:27:Brassards en cuir bouilli
3200:1:4:8:Brassards en cuir brûlé
2468:1:4:37:Brassards en cuir clouté
7277:1:4:9:Brassards en cuir cousu main
2124:1:4:5:Brassards en cuir craquelé
3546:1:4:1:Brassards en cuir gris D02
1840:1:4:10:Brassards en cuir grossier
7281:2:4:14:Brassards en cuir léger
2474:1:4:50:Brassards en cuir renforcé
3535:1:4:1:Brassards en cuir rouge C03
1836:1:4:5:Brassards en cuir sale
1844:1:4:17:Brassards en cuir tanné
1850:1:4:22:Brassards en cuir traité
2853:1:4:7:Brassards en cuivre
3835:2:4:33:Brassards en fer émeraude
1846:1:4:17:Brassards en mailles
2396:1:4:10:Brassards en mailles légères
19687:3:4:65:Brassards en peau de chauve-souris primordiale
7924:2:4:43:Brassards en plaques de mithril
17014:4:4:59:Brassards en sombrefer
252559:2:4:60:Brassards en suédine bleue
12408:2:4:51:Brassards en thorium
3590:1:4:17:Brassards en toile renforcée
1852:1:4:22:Brassards en écailles
5783:2:4:38:Brassards en écailles de murloc
252593:2:4:56:Brassards en écailles de scorpide chargées
252582:2:4:55:Brassards en écailles de scorpide souples
15077:2:4:51:Brassards en écailles de scorpide épaisses
8198:2:4:42:Brassards en écailles de tortue
6040:2:4:37:Brassards en écailles dorées
2150:1:4:27:Brassards en écailles polies
3600:1:4:5:Brassards en étoffe légère
3596:1:4:5:Brassards en étoffe rapiécés
3598:1:4:22:Brassards en étoffe épaisse
2374:1:4:10:Brassards endommagés en cuir
14383:1:4:1:Brassards endurants
3323:2:4:10:Brassards fantomatiques
22665:4:4:80:Brassards glacécaille
2867:2:4:23:Brassards grossiers en bronze
2868:2:4:25:Brassards guillochés en bronze
12425:2:4:54:Brassards impériaux en plaques
3592:1:4:27:Brassards matelassés
7378:2:4:37:Brassards mats
3545:1:4:1:Brassards noirs en cuir D02
16664:2:4:54:Brassards ornés
252557:2:4:59:Brassards ouvragés en cuir
22671:4:4:80:Brassards plaie-de-glace
22663:4:4:80:Brassards polaires
15092:2:4:55:Brassards runiques en cuir
2854:2:4:19:Brassards runiques en cuivre
2327:1:4:10:Brassards solides en cuir
277023:2:4:10:Brassards tisse-souffle azur
276999:2:4:10:Brassards tisse-souffle nuageux
3607:1:4:10:Brassards tissés
3285:1:4:10:Brassards tribaux
3603:1:4:10:Brassards tricotés
4259:2:4:36:Brassards verts en cuir
4308:2:4:12:Brassards verts en lin
3828:1:0:39:Breuvage de détection de l’invisibilité inférieure
9233:1:0:50:Breuvage de détection des démons
9154:1:0:46:Breuvage de détection des morts-vivants
8827:1:0:34:Breuvage de marche sur l’eau
5996:1:0:18:Breuvage de respiration aquatique
18294:1:0:45:Breuvage de respiration aquatique supérieure
9197:1:0:48:Breuvage de vision de rêve
10592:1:0:40:Breuvage d’œil de chat
12353:4:15:60:Bride d'étalon blanc
2411:3:15:40:Bride d'étalon noir
5656:3:15:40:Bride de cheval bai
5655:3:15:40:Bride de jument alezane
12354:4:15:60:Bride de palomino
2414:3:15:40:Bride de pinto
1707:1:0:35:Brie de Hurlevent
2423:1:4:50:Brigandine
17408:1:0:45:Brochette de Boeuf épicé
15076:2:4:53:Broigne en écailles de scorpide épaisses
2153:1:4:27:Broigne polie
6807:1:0:35:Brouet de cuisses de grenouille
5478:1:0:25:Brouet de rat
5477:1:0:10:Brouet de trotteur
250070:1:0:55:Bruscitt d’ours
5013:1:0:15:Bulbe fertile
2523:1:2:35:Bullova
1194:1:2:4:Bâtarde
2754:1:2:3:Bâtarde ternie
854:1:2:16:Bâton
2132:1:2:4:Bâton court
2503:1:2:8:Bâton court d'adepte
2487:1:2:4:Bâton d'acolyte
7609:2:4:35:Bâton d'ambre de doyen
3327:1:2:9:Bâton d'Oracle Aileron noir
15979:2:4:42:Bâton de braise-soie
2527:1:2:36:Bâton de combat
15925:2:4:10:Bâton de compagnon
2535:1:2:45:Bâton de guerre
2495:1:2:8:Bâton de marche
12252:2:2:39:Bâton de protection
15934:2:4:32:Bâton de sage
14083:1:2:4:Bâton de Tyrande
2067:1:2:10:Bâton des froideurs
14392:1:2:1:Bâton endurant
2257:1:2:10:Bâton frostmane
1388:1:2:3:Bâton noueux
2030:1:2:20:Bâton noueux
3661:1:2:2:Bâton simple
15971:2:4:20:Bâtonnet aborigène
15928:2:4:31:Bâtonnet broché d'argent
15978:2:4:41:Bâtonnet de géomancien
15942:2:4:65:Bâtonnet de maître
11128:1:7:30:Bâtonnet doré
15962:2:4:33:Bâtonnet du satyre
16206:1:7:55:Bâtonnet en arcanite
6338:1:7:20:Bâtonnet en argent
6217:1:7:5:Bâtonnet en cuivre
11144:1:7:40:Bâtonnet en vrai-argent
15974:2:4:26:Bâtonnet païen
15935:2:4:34:Bâtonnet solide
15982:2:4:51:Bâtonnet tissé de sang
21939:1:12:1:Bâtonnet élémentaire de corruption
15989:2:4:65:Bâtonnet éternel
21168:1:15:20:Bébé requin
23712:1:15:1:Bébé tigre blanc
5873:3:15:40:Bélier blanc
18785:4:15:60:Bélier blanc rapide
5872:3:15:40:Bélier brun
18786:4:15:60:Bélier brun rapide
13329:4:15:60:Bélier de givre
5864:3:15:40:Bélier gris
18787:4:15:60:Bélier gris rapide
13328:4:15:60:Bélier noir
289296:4:2:40:Bénédiction
272941:1:7:60:Bûches épaisses
274490:2:4:40:Cache-sabots de centaure
5044:1:0:5:Cadeau au ruban bleu
5043:1:0:5:Cadeau au ruban rouge
21979:1:15:1:Cadeau d'adoration : Darnassus
21980:1:15:1:Cadeau d'adoration : Forgefer
22166:1:15:1:Cadeau d'adoration : Fossoyeuse
21981:1:15:1:Cadeau d'adoration : Hurlevent
22164:1:15:1:Cadeau d'adoration : Orgrimmar
22165:1:15:1:Cadeau d'adoration : Thunder Bluff
22167:1:15:1:Cadeau d'amitié : Darnassus
22168:1:15:1:Cadeau d'amitié : Forgefer
22172:1:15:1:Cadeau d'amitié : Fossoyeuse
22170:1:15:1:Cadeau d'amitié : Hurlevent
22169:1:15:1:Cadeau d'amitié : Orgrimmar
22171:1:15:1:Cadeau d'amitié : Thunder Bluff
5045:1:0:45:Cadeau du crâne
21831:1:15:1:Cadeau enveloppé
5046:1:0:30:Cadeau verrouillé
10393:1:15:30:Cafard
280699:1:15:30:Cafard de Fossoyeuse
280697:1:15:30:Cafard pestiféré
8496:1:15:20:Cage de perroquet (Cockatiel)
8492:1:15:20:Cage de perroquet (Macaw ailes vertes)
8494:1:15:20:Cage de perroquet (Macaw jacinthe)
8495:1:15:20:Cage de perroquet (Sénégal)
3239:1:0:5:Caillou brut
12643:1:0:45:Caillou dense
3240:1:0:15:Caillou grossier
5568:1:6:18:Caillou lisse
3241:1:0:25:Caillou lourd
18640:1:0:1:Caillou rigolo
7965:1:0:35:Caillou solide
4401:1:15:15:Caisse d'Ecureuil mécanique
22288:1:15:1:Caisse de bière artisanale
12529:1:15:59:Caisse de Couveuse
280797:1:15:20:Caisse de lapin (arctique)
280801:1:15:20:Caisse de lapin (marron)
8497:1:15:20:Caisse de lapin (patte-blanche)
12264:1:15:59:Caisse de worg
248549:2:15:1:Caisse détournée
248707:2:0:1:Caisse détournée : composants de compagnon
248704:2:0:1:Caisse détournée : composants d’apprenti
248713:2:0:1:Caisse détournée : composants d’artisan
248710:2:0:1:Caisse détournée : composants d’expert
248689:1:0:1:Caisse détournée : curiosités de compagnon
248685:1:0:1:Caisse détournée : curiosités d’apprenti
248699:1:0:1:Caisse détournée : curiosités d’artisan
248694:1:0:1:Caisse détournée : curiosités d’expert
248706:2:0:1:Caisse détournée : lingots de compagnon
248703:2:0:1:Caisse détournée : lingots d’apprenti
248712:2:0:1:Caisse détournée : lingots d’artisan
248709:2:0:1:Caisse détournée : lingots d’expert
248687:1:0:1:Caisse détournée : minerai de compagnon
248683:1:0:1:Caisse détournée : minerai d’apprenti
248697:1:0:1:Caisse détournée : minerai d’artisan
248692:1:0:1:Caisse détournée : minerai d’expert
248686:1:0:1:Caisse détournée : plantes de compagnon
248682:1:0:1:Caisse détournée : plantes d’apprenti
248695:1:0:1:Caisse détournée : plantes terreuses d’artisan
248690:1:0:1:Caisse détournée : plantes terreuses d’expert
248696:1:0:1:Caisse détournée : plantes à fleurs d’artisan
248691:1:0:1:Caisse détournée : plantes à fleurs d’expert
248688:1:0:1:Caisse détournée : textiles de compagnon
248684:1:0:1:Caisse détournée : textiles d’apprenti
248698:1:0:1:Caisse détournée : textiles d’artisan
248693:1:0:1:Caisse détournée : textiles d’expert
248705:2:0:1:Caisse détournée : étoffes de compagnon
248702:2:0:1:Caisse détournée : étoffes d’apprenti
248711:2:0:1:Caisse détournée : étoffes d’artisan
248708:2:0:1:Caisse détournée : étoffes d’expert
6352:1:15:25:Caisse détrempée
10561:1:7:43:Caisse en mithril
6351:1:15:15:Caisse endommagée
13874:1:15:45:Caisse lourde
6357:1:15:35:Caisse scellée
13928:1:0:45:Calmar grillé
13755:1:0:45:Calmar hivernal cru
13467:1:7:58:Calot de glace
247824:1:0:1:Calva du tonnerre
250537:2:4:40:Camail doré dur
7931:2:4:46:Camail en mithril
3837:2:4:38:Camail en écailles dorées
260827:2:0:60:Camoufleur 52
6256:1:2:1:Canne à pêche
14116:1:4:14:Cape aborigène
4671:1:4:9:Cape ancestrale
4799:2:4:23:Cape antique
7053:2:4:35:Cape azur en soie
4686:1:4:12:Cape barbare en tissu
12254:2:4:44:Cape bien huilée
5542:2:4:19:Cape brodée de perles
4665:1:4:8:Cape brûlée
134111:2:4:1:Cape cachée
18511:4:4:62:Cape changeante
18509:4:4:62:Cape chromatique
7056:2:4:36:Cape cramoisie en soie
3719:2:4:30:Cape d'homme des collines
6508:1:4:9:Cape d'infanterie
4790:2:4:25:Cape d'Inferno
6555:1:4:14:Cape de barde
4668:1:4:9:Cape de bataille en anneaux
9761:1:4:11:Cape de cadet
4689:1:4:13:Cape de chasse
4662:1:4:8:Cape de compagnon
4692:1:4:12:Cape de cérémonie
6514:1:4:10:Cape de disciple
7283:2:4:20:Cape de dragonnet noir
14134:3:4:55:Cape de feu
5965:2:4:37:Cape de gardien
7377:2:4:36:Cape de givre en cuir
15483:1:4:10:Cape de guerre déchirée
4658:1:4:8:Cape de guerrier
8195:2:4:46:Cape de la nuit
279270:4:4:65:Cape de la terre et du ciel
4683:1:4:13:Cape de lieur de sort
10249:2:4:61:Cape de maître
3331:1:4:12:Cape de Melrache
9754:1:4:11:Cape de nomade
6520:1:4:9:Cape de pionnier
18413:3:4:62:Cape de sauvegarde
6549:1:4:14:Cape de soldat
4677:1:4:12:Cape de vétéran
4680:1:4:13:Cape des eaux stagnantes
15475:1:4:8:Cape du destrier
8216:2:4:48:Cape du grand vaudou
15299:1:4:10:Cape du grizzly
7276:1:4:9:Cape en cuir cousu main
2310:2:4:13:Cape en cuir estampé
8215:2:4:50:Cape en cuir sauvage
3008:2:4:11:Cape en fourrure de wendigo
2584:2:4:16:Cape en laine
4311:2:4:21:Cape en laine épaisse
2570:1:4:6:Cape en lin
2580:2:4:12:Cape en lin renforcé
15138:3:4:60:Cape en écailles d'Onyxia
6466:2:4:18:Cape en écailles de déviant
14044:2:4:55:Cape en étoffe cendrée
14103:2:4:55:Cape en étoffe lumineuse
13860:2:4:53:Cape en étoffe runique
14385:1:4:1:Cape endurante
3261:1:4:5:Cape entoilée
4797:2:4:25:Cape flamboyante
22658:4:4:80:Cape glaciaire
4327:3:4:40:Cape glaciale
14098:1:4:10:Cape indigène
15015:1:4:13:Cape lupine
3322:2:4:10:Cape légère
15490:1:4:14:Cape maculée de sang
2316:2:4:22:Cape noire en cuir
10518:2:4:45:Cape parachute
14088:1:4:8:Cape perlée
15007:1:4:8:Cape primordiale
12253:2:4:41:Cape rouge brillante
4798:2:4:25:Cape runique lourde
9745:1:4:11:Cape simple
4792:2:4:23:Cape spirituelle
4793:2:4:24:Cape sylvestre
4674:1:4:9:Cape tribale
2308:2:4:15:Cape élégante en cuir
422:1:0:25:Caprice des nains
5172:1:15:30:Capsule de léthargie
4322:2:4:33:Capuche d'enchanteur
20408:2:4:60:Capuche de sectateur du crépuscule
277054:2:4:35:Capuche fil-tempête azur
277046:2:4:35:Capuche fil-tempête nuageuse
15324:2:2:56:Carabine brûle-flanc
8181:1:2:9:Carabine de chasse
10510:2:2:44:Carabine de gros calibre en mithril
279273:4:2:65:Carabine de précision hyper luxe Mod. XVII
18282:4:2:65:Carabine de tireur d'élite endurci
16007:3:2:61:Carabine en arcanite sans défaut
16004:3:2:55:Carabine en sombrefer
15995:2:2:52:Carabine en thorium
4383:2:2:29:Carabine vise-lune
8182:1:2:7:Carabine à plomb
18632:1:0:35:Caramel de Ruisselune
20501:1:7:55:Carapace lourde de silithide
20500:1:7:55:Carapace légère de silithide
9061:1:7:42:Carburant de fusée des gobelins
8217:2:11:45:Carquois de tir rapide
7278:1:11:5:Carquois en cuir léger
7371:2:11:35:Carquois lourd
2101:1:11:1:Carquois léger
11362:1:11:15:Carquois moyen
7808:1:0:5:Carré de chocolat
9254:1:12:40:Carte au trésor de Cuergo
1357:1:12:10:Carte au trésor du capitaine Sander
9327:2:12:1:Carte d'accès aux données niveau DELTA
22141:1:15:1:Carte de garde de Forgefer
22143:1:15:1:Carte de garde de Hurlevent
22145:1:15:1:Carte de garde moisie
22144:1:15:1:Carte de gardien des Hauts
22142:1:15:1:Carte de grunt
22059:1:15:1:Carte de la St-Valentin
237037:1:15:15:Carte de membre du club de la Haute
22140:1:15:1:Carte de sentinelle
221299:4:15:1:Cartes de Cauchemar
221289:4:15:1:Cartes de Dunes
221272:4:15:1:Cartes de Nature
221280:4:15:1:Cartes de Plaies
5105:1:15:20:Cartouche explosive
8208:2:4:50:Casque armé du scorpide
7915:2:4:35:Casque barbare en fer
3894:1:4:50:Casque brigandine
8348:3:4:50:Casque de feu
16983:4:4:60:Casque de la fournaise
22759:3:4:70:Casque de la ronceraie
10506:2:4:46:Casque de scaphandrier
3891:1:4:37:Casque en anneaux doublés
8214:2:4:45:Casque en cuir sauvage
15080:2:4:59:Casque en écailles de scorpide épaisses
8191:2:4:46:Casque en écailles de tortue
3529:1:4:1:Casque noir d'elfe de la nuit
8345:3:4:45:Casque tête-de-loup
19223:1:0:5:Casse-croûte de Sombrelune
2880:1:7:5:Catalyseur léger
3466:1:7:25:Catalyseur puissant
18567:1:7:60:Catalyseur élémentaire
255718:1:7:36:Cataplasme excellent
255719:1:7:58:Cataplasme puissant
255717:1:7:26:Cataplasme rusé
255716:1:7:16:Cataplasme simple
4672:1:4:10:Ceinture ancestrale
7052:2:4:35:Ceinture azur en soie
4264:2:4:40:Ceinture barbare
4687:1:4:14:Ceinture barbare en tissu
2424:1:4:50:Ceinture brigandine
3587:1:4:50:Ceinture brodée
3593:1:4:37:Ceinture brun-roux
250592:2:4:59:Ceinture bénie en plaques
143539:2:4:1:Ceinture cachée
15088:2:4:60:Ceinture corrompue en cuir
7055:2:4:35:Ceinture cramoisie en soie
4250:2:4:25:Ceinture d'homme des collines
6509:1:4:10:Ceinture d'infanterie
9758:1:4:12:Ceinture de cadet
4690:1:4:13:Ceinture de chasse
14864:2:4:59:Ceinture de chef de guerre
4663:1:4:9:Ceinture de compagnon
4693:1:4:14:Ceinture de cérémonie en cuir
275620:3:4:58:Ceinture de garde-couvée
4258:2:4:34:Ceinture de gardien
4786:2:4:20:Ceinture de grand sage
4328:2:4:36:Ceinture de l'araignée
18405:4:4:62:Ceinture de l'archimage
4329:2:4:40:Ceinture de l'étoile
19163:4:4:70:Ceinture de la fournaise
22761:3:4:70:Ceinture de la ronceraie
19149:4:4:66:Ceinture de lave
4684:1:4:13:Ceinture de lieur de sort
6517:1:4:10:Ceinture de pionnier
8088:1:4:50:Ceinture de plates
10721:2:4:43:Ceinture de prévention gnome
4827:2:4:28:Ceinture de sorcier
275617:3:4:58:Ceinture de tripécaille
15472:1:4:9:Ceinture du destrier
15302:1:4:11:Ceinture du grizzly
4951:1:4:7:Ceinture du hurleur
19162:4:4:70:Ceinture du Magma
4829:2:4:29:Ceinture du rêveur
4828:2:4:27:Ceinture du vent nocturne
2851:2:4:11:Ceinture en anneaux de cuivre
2419:1:4:37:Ceinture en anneaux doublés
2399:1:4:10:Ceinture en anneaux légers
2387:1:4:5:Ceinture en anneaux rouillés
2380:1:4:5:Ceinture en anneaux ternis
2142:1:4:27:Ceinture en cuir bouilli
4666:1:4:9:Ceinture en cuir brûlé
2464:1:4:37:Ceinture en cuir clouté
4262:3:4:37:Ceinture en cuir clouté de gemmes
4237:2:4:10:Ceinture en cuir cousu main
2122:1:4:5:Ceinture en cuir craquelé
1839:1:4:10:Ceinture en cuir grossier
2471:1:4:50:Ceinture en cuir renforcé
1835:1:4:5:Ceinture en cuir sale
1843:1:4:17:Ceinture en cuir tanné
1849:1:4:22:Ceinture en cuir traité
7026:1:4:9:Ceinture en lin
1845:1:4:17:Ceinture en mailles
2393:1:4:10:Ceinture en mailles légères
4456:2:4:33:Ceinture en peau de raptor
252481:2:4:59:Ceinture en suédine bleue
12406:2:4:50:Ceinture en thorium
14143:2:4:53:Ceinture en tisse-fantôme
3589:1:4:17:Ceinture en toile renforcée
1853:1:4:22:Ceinture en écailles
6468:3:4:23:Ceinture en écailles de déviant
5780:2:4:18:Ceinture en écailles de murloc
252575:2:4:51:Ceinture en écailles de scorpide chargées
252595:2:4:56:Ceinture en écailles de scorpide souples
15082:2:4:56:Ceinture en écailles de scorpide épaisses
2148:1:4:27:Ceinture en écailles polies
3599:1:4:5:Ceinture en étoffe légère
3595:1:4:5:Ceinture en étoffe rapiécée
13856:2:4:51:Ceinture en étoffe runique
3597:1:4:22:Ceinture en étoffe épaisse
2371:1:4:10:Ceinture endommagée en cuir
14390:1:4:1:Ceinture endurante
12424:2:4:53:Ceinture impériale en plaques
15388:2:4:52:Ceinture Jadefeu
12257:2:4:42:Ceinture lourde abimée
22197:3:4:68:Ceinture lourde en obsidienne
22195:3:4:68:Ceinture légère en obsidienne
3591:1:4:27:Ceinture matelassée
7387:2:4:39:Ceinture matte
4249:2:4:25:Ceinture noire en cuir
252544:2:4:52:Ceinture ouvragée en cuir
15003:1:4:8:Ceinture primordiale
12416:2:4:52:Ceinture radieuse
15093:2:4:56:Ceinture runique en cuir
2857:2:4:18:Ceinture runique en cuivre
20539:3:4:63:Ceinture runique ténébreuse
7061:2:4:39:Ceinture terrestre en soie
277025:2:4:10:Ceinture tisse-souffle azur
277001:2:4:10:Ceinture tisse-souffle nuageuse
3606:1:4:10:Ceinture tissée
4675:1:4:10:Ceinture tribale
3602:1:4:10:Ceinture tricotée
4257:2:4:32:Ceinture verte en cuir
12258:2:4:44:Ceinture à boucle serpentine
4246:2:4:16:Ceinture élégante en cuir
19043:3:4:58:Ceinture épaisse grumegueule
4669:1:4:10:Ceinturon de bataille en anneaux
18504:3:4:62:Ceinturon de clairvoyance
275611:3:4:58:Ceinturon de cloque-bilieuse
15480:1:4:13:Ceinturon de guerre déchiré
4659:1:4:8:Ceinturon de guerrier
19051:3:4:58:Ceinturon de l'Aube
275614:3:4:58:Ceinturon de saccage-essaim
4678:1:4:14:Ceinturon de vétéran
4681:1:4:14:Ceinturon des eaux stagnantes
14674:2:4:55:Ceinturon du seigneur de la harde
16989:4:4:59:Ceinturon en anneaux de feu
15180:2:4:53:Ceinturon prétorien
2546:2:4:13:Ceinturon royal Frostmane
8394:1:12:1:Cerveau de basilic
1081:1:7:15:Chair croustillante d'araignée
2674:1:7:13:Chair de clampant
5503:1:7:14:Chair de palourde
4655:1:7:35:Chair de palourde géante
7974:1:7:45:Chair de palourde piquante
5504:1:7:23:Chair de palourde relevée
12184:1:7:30:Chair de raptor
20424:1:7:55:Chair de ver des sables
249695:1:12:1:Chair gangrenée
5468:1:7:15:Chair tendre de Furie
279979:1:0:4:Chaise du camp
210499:1:0:20:Champifond
8845:1:7:47:Champignon fantôme
8543:1:0:35:Champignon sous-marin
267474:1:0:5:Champignon sylvestre de grand vent
5823:1:0:15:Champignon venimeux
4605:1:0:15:Champignon à pois rouges
12790:3:2:63:Championne en arcanite
7960:3:2:52:Championne en vrai-argent
21713:1:0:1:Chandelle d'Elune
3892:1:4:50:Chapeau brodé
3889:1:4:37:Chapeau brun-roux
8174:2:4:40:Chapeau de cuir confortable
7996:1:4:20:Chapeau de pêcheur usé
3890:1:4:37:Chapeau en cuir clouté
252482:2:4:61:Chapeau en suédine bleue
14386:1:4:1:Chapeau endurant
12904:2:4:61:Chapeau pandit super spécial de Shawn
21577:1:15:1:Chapelet de comètes blanche
21571:1:15:1:Chapelet de comètes bleues
21578:1:15:1:Chapelet de comètes jaunes
21576:1:15:1:Chapelet de comètes rouges
21574:1:15:1:Chapelet de comètes vertes
21575:1:15:1:Chapelet de comètes violettes
21719:1:15:1:Chapelet de grandes comètes blanches
21714:1:15:1:Chapelet de grandes comètes bleues
21720:1:15:1:Chapelet de grandes comètes jaunes
21718:1:15:1:Chapelet de grandes comètes rouges
21716:1:15:1:Chapelet de grandes comètes vertes
21717:1:15:1:Chapelet de grandes comètes violettes
7048:2:4:29:Chaperon azur en soie
4323:2:4:34:Chaperon des ombres
14111:2:4:58:Chaperon en gangrétoffe
254135:2:4:61:Chaperon en tisse-fantôme
254015:2:4:37:Chaperon terrestre en soie
277050:2:4:35:Chaperon tisse-souffle azur
277042:2:4:35:Chaperon tisse-souffle nuageux
249424:2:7:45:Chaperose
3857:1:7:30:Charbon
234012:1:7:60:Chardon de ruche
2452:1:7:15:Chardonnier
10646:1:0:41:Charge de sapeur gobelin
4479:1:0:35:Charme ardent
4481:1:0:35:Charme armorié
5373:1:15:1:Charme de chance
4480:1:0:35:Charme de tonnerre
277026:2:4:12:Chausses tisse-souffle azur
277002:2:4:12:Chausses tisse-souffle nuageuses
59:1:4:1:Chaussures d'acolyte
252467:2:4:52:Chaussures en suédine bleue
840:1:4:17:Chaussures en toile renforcée
2117:1:4:5:Chaussures en étoffe légère
202:1:4:22:Chaussures en étoffe épaisse
277039:2:4:11:Chaussures fil-tempête azur
277015:2:4:11:Chaussures fil-tempête nuageuses
6836:1:4:1:Chaussures habillées
9743:1:4:12:Chaussures simples
277019:2:4:10:Chaîne forge-ciel azur
276995:2:4:10:Chaîne forge-ciel nuageuse
3927:1:0:45:Cheddar affiné
252030:1:0:15:Cheddar des cieux âcre
273815:1:4:1:Chemise aérienne de cherchevent
16060:1:4:20:Chemise blanche classique
6795:1:4:32:Chemise blanche de bretteur
6833:1:4:25:Chemise blanche de smoking
2576:1:4:7:Chemise blanche en lin
4334:1:4:34:Chemise blanche habillée
6384:1:4:25:Chemise bleue d'apparat
2577:1:4:10:Chemise bleue en lin
142503:2:4:1:Chemise cachée
6097:1:4:1:Chemise d'acolyte
6096:1:4:1:Chemise d'apprenti
45:1:4:1:Chemise d'écuyer
6117:1:4:1:Chemise d'écuyer
271675:1:4:1:Chemise de crapule du bosquet
49:1:4:1:Chemise de détrousseur
271669:1:4:1:Chemise de guerrier de Thendal
5107:1:4:14:Chemise de matelot
2105:1:4:1:Chemise de nervi
6136:1:4:1:Chemise de nervi
271663:1:4:1:Chemise de novice de Thendal
53:1:4:1:Chemise de néophyte
38:1:4:1:Chemise de recrue
6120:1:4:1:Chemise de recrue
10034:1:4:1:Chemise de smoking
271668:1:4:1:Chemise de survivaliste de Thendal
127:1:4:1:Chemise de trappeur
6130:1:4:1:Chemise du trappeur
271655:1:4:1:Chemise d’apprenti de Thendal
3428:1:4:20:Chemise grise classique
2587:1:4:20:Chemise grise en laine
3426:1:4:30:Chemise jaune soutenu
4332:1:4:27:Chemise jaune éclatant
10054:1:4:46:Chemise lavande en tisse-mage
16059:1:4:20:Chemise marron classique
4344:1:4:7:Chemise marron en lin
3427:1:4:40:Chemise noire d'apparat
4336:1:4:40:Chemise noire de bretteur
4333:1:4:31:Chemise noire en soie
10056:1:4:43:Chemise orange en tisse-mage
10052:1:4:40:Chemise orange martiale
148:1:4:1:Chemise robuste de trappeur
10055:1:4:47:Chemise rose en tisse-mage
4330:1:4:22:Chemise rouge d'apparat
6796:1:4:35:Chemise rouge de bretteur
2575:1:4:10:Chemise rouge en lin
6385:1:4:25:Chemise verte d'apparat
17723:1:4:40:Chemise verte de fête
2579:1:4:14:Chemise verte en lin
274799:4:15:60:Cheval de guerre squelette ocre
13334:4:15:60:Cheval de guerre squelette vert
18791:4:15:60:Cheval de guerre squelette violet
13333:3:15:40:Cheval squelette bai
13332:3:15:40:Cheval squelette bleu
276063:3:15:40:Cheval squelette noir
13331:3:15:40:Cheval squelette rouge
265839:4:15:60:Cheval squelette sombre
265838:4:15:60:Cheval squelette vert
265840:4:15:60:Cheval squelette violet
20514:3:12:1:Chevalière abyssale
282080:2:4:57:Chevalière calcinée
282026:2:4:58:Chevalière de bataille inflexible
208085:1:15:1:Chevalière de lieutenant écarlate
20436:1:12:1:Chevalière de signal : Eau
20432:1:12:1:Chevalière de signal : Feu
20435:1:12:1:Chevalière de signal : Pierre
20433:1:12:1:Chevalière de signal : Tonnerre
12216:1:0:35:Chili de crabe épicé
12217:1:0:35:Chili de souffle de dragon
20498:1:7:55:Chitine de silithide
11325:1:0:1:Chope de bière sombrefer
15932:2:4:12:Chope de disciple
21171:1:15:1:Chope de fête remplie
21173:1:15:1:Chope de fête vide
21174:1:15:1:Chope de fête vide
3087:1:0:15:Chope de Shimmer Stout
7608:2:4:21:Chope ornée de prophète
15972:2:4:24:Chope rituelle
8501:1:15:30:Chouette-faucon
8625:1:4:10:Cierge magique blanc
8626:1:4:10:Cierge magique bleu
8624:1:4:10:Cierge magique rouge
2027:1:2:19:Cimeterre
280399:1:2:2:Cimeterre endommagé
4560:1:2:6:Cimeterre fin
19272:3:12:1:Cinq d'Elémentaires
221303:3:15:1:Cinq de Cauchemar
221294:3:15:1:Cinq de Dunes
19233:3:12:1:Cinq de Fauves
221276:3:15:1:Cinq de Nature
221285:3:15:1:Cinq de Plaies
19281:3:12:1:Cinq de Portails
19262:3:12:1:Cinq de Seigneurs de guerre
3864:2:7:40:Citrine
260628:1:0:55:Citrouille farcie
4602:1:0:45:Citrouille lunaire
1198:1:2:15:Claymore
7955:2:2:11:Claymore en cuivre
250610:2:2:45:Claymore en mithril
2497:1:2:9:Claymore rouillée
4817:2:2:22:Claymore sacrée
2128:1:2:4:Claymore éraflée
260799:1:7:35:Cloche SUR-T
21308:1:15:1:Clochette tintinnabulante
5916:1:13:1:Clé d'appareil gnome
5937:1:13:1:Clé d'appareil gobelin
4882:1:13:1:Clé de Benedict
208007:1:13:1:Clé de cache de l’épave
208749:1:13:1:Clé de cache pin-tordu
21761:1:13:1:Clé de coffre de scarabées
21762:1:13:1:Clé de coffre de scarabées supérieur
17262:1:13:1:Clé de James
211471:1:13:1:Clé de la Bondissante
13304:1:13:1:Clé de la boîte à lettres de l'allée du Festival
13302:1:13:1:Clé de la boîte à lettres de l'allée du Marché
13305:1:13:1:Clé de la boîte à lettres de la place des Anciens
13303:1:13:1:Clé de la boîte à lettres de la place des Croisés
13306:1:13:1:Clé de la boîte à lettres de la place du Roi
13307:1:13:1:Clé de la boîte à lettres d’Ezra Grimm
206975:1:13:1:Clé de l’entrepôt d’artéfact
11818:1:12:43:Clé des toilettes de Crasseboue
8444:1:0:1:Clé du bourreau
5020:1:13:1:Clé du butin des Kolkar
9249:2:13:1:Clé du capitaine
17242:1:13:1:Clé du coffre de Salem
11115:1:13:1:Clé du coffre secret
11078:1:13:1:Clé du coffret à relique
208005:1:13:1:Clé du coffret à reliques Agamand
11197:1:13:1:Clé du gardien noir
11602:1:13:1:Clé du Sinistre dévoreur
6219:1:2:10:Clé plate
10360:1:15:30:Cobra noir
22393:3:9:60:Codex : Prière de protection contre l'Ombre
17413:3:9:48:Codex : Prière de Robustesse
17414:3:9:60:Codex : Prière de Robustesse II
8976:1:9:32:Codex d'Abolir maladie
1089:1:9:14:Codex d'Annuler maladie
4287:1:9:32:Codex d'Annuler maladie II
8963:1:9:20:Codex d'Apaisement
8981:1:9:36:Codex d'Apaisement II
9014:1:9:52:Codex d'Apaisement III
8958:1:9:10:Codex d'Attaque mentale
8962:1:9:16:Codex d'Attaque mentale II
8967:1:9:22:Codex d'Attaque mentale III
8972:1:9:28:Codex d'Attaque mentale IV
9027:1:9:58:Codex d'Attaque mentale IX
8980:1:9:34:Codex d'Attaque mentale V
8990:1:9:40:Codex d'Attaque mentale VI
9002:1:9:46:Codex d'Attaque mentale VII
9015:1:9:52:Codex d'Attaque mentale VIII
1109:1:9:30:Codex d'Emprise
8966:1:9:20:Codex d'Entraves des morts-vivants
8986:1:9:40:Codex d'Entraves des morts-vivants II
9031:1:9:60:Codex d'Entraves des morts-vivants III
4274:1:9:36:Codex d'Esquive miraculeuse
8955:1:9:8:Codex d'Oubli
8965:1:9:20:Codex d'Oubli II
8975:1:9:30:Codex d'Oubli III
8989:1:9:40:Codex d'Oubli IV
9007:1:9:50:Codex d'Oubli V
9029:1:9:60:Codex d'Oubli VI
8968:1:9:24:Codex de Brûlure de mana
8977:1:9:32:Codex de Brûlure de mana II
8988:1:9:40:Codex de Brûlure de mana III
9005:1:9:48:Codex de Brûlure de mana IV
9021:1:9:56:Codex de Brûlure de mana V
1091:1:9:6:Codex de Châtiment sacré II
1100:1:9:14:Codex de Châtiment sacré III
3120:1:9:22:Codex de Châtiment sacré IV
4271:1:9:30:Codex de Châtiment sacré V
4284:1:9:38:Codex de Châtiment sacré VI
9003:1:9:46:Codex de Châtiment sacré VI
9016:1:9:54:Codex de Châtiment sacré VIII
8974:1:9:30:Codex de Contrôle mental
8997:1:9:44:Codex de Contrôle mental II
9024:1:9:58:Codex de Contrôle mental III
8961:1:9:14:Codex de Cri psychique
8971:1:9:28:Codex de Cri psychique II
8992:1:9:42:Codex de Cri psychique III
9020:1:9:56:Codex de Cri psychique IV
1095:1:9:18:Codex de Dissipation de la magie
4282:1:9:36:Codex de Dissiper magie II
4275:1:9:38:Codex de Dégénérescence mentale
1093:1:9:22:Codex de Délivrance de la malédiction
4288:1:9:38:Codex de Délivrance de la malédiction II
1086:1:9:12:Codex de Feu intérieur
4266:1:9:20:Codex de Feu intérieur II
3124:1:9:30:Codex de Feu intérieur III
8991:1:9:40:Codex de Feu intérieur IV
9009:1:9:50:Codex de Feu intérieur V
9033:1:9:60:Codex de Feu intérieur VI
8960:1:9:14:Codex de Guérison des maladies
3121:1:9:34:Codex de Lévitation
1087:1:9:4:Codex de Mot de l’ombre : Douleur
1096:1:9:10:Codex de Mot de l’ombre : Douleur II
1641:1:9:18:Codex de Mot de l’ombre : Douleur III
1658:1:9:26:Codex de Mot de l’ombre : Douleur IV
4279:1:9:34:Codex de Mot de l’ombre : Douleur V
8994:1:9:42:Codex de Mot de l’ombre : Douleur VI
9011:1:9:50:Codex de Mot de l’ombre : Douleur VII
9028:1:9:58:Codex de Mot de l’ombre : Douleur VIII
3114:1:9:24:Codex de Mot de l’ombre : Désarroi
4277:1:9:36:Codex de Mot de l’ombre : Désarroi II
4267:1:9:20:Codex de Mot de l’ombre : Maladresse
4276:1:9:32:Codex de Mot de l’ombre : Maladresse II
3113:1:9:6:Codex de Mot sacré : Bouclier
3116:1:9:12:Codex de Mot sacré : Bouclier II
3122:1:9:18:Codex de Mot sacré : Bouclier III
4280:1:9:24:Codex de Mot sacré : Bouclier IV
9018:1:9:54:Codex de Mot sacré : Bouclier IX
3119:1:9:30:Codex de Mot sacré : Bouclier V
1651:1:9:36:Codex de Mot sacré : Bouclier VI
8995:1:9:42:Codex de Mot sacré : Bouclier VII
9006:1:9:48:Codex de Mot sacré : Bouclier VIII
9035:1:9:60:Codex de Mot sacré : Bouclier X
8954:1:9:1:Codex de Mot sacré : Robustesse
1112:1:9:12:Codex de Mot sacré : Robustesse II
3123:1:9:24:Codex de Mot sacré : Robustesse III
4285:1:9:36:Codex de Mot sacré : Robustesse IV
9004:1:9:48:Codex de Mot sacré : Robustesse V
9034:1:9:60:Codex de Mot sacré : Robustesse VI
4269:1:9:30:Codex de Prière de soins
4286:1:9:40:Codex de Prière de soins II
9008:1:9:50:Codex de Prière de soins II
9032:1:9:60:Codex de Prière de soins IV
21287:3:9:60:Codex de Prière de soins V
4272:1:9:30:Codex de Protection contre le Sacré
8987:1:9:40:Codex de Protection contre le Sacré II
9017:1:9:54:Codex de Protection contre le Sacré III
4281:1:9:30:Codex de Protection contre l’ombre
8993:1:9:42:Codex de Protection contre l’ombre II
9023:1:9:56:Codex de Protection contre l’ombre III
1084:1:9:8:Codex de Rénovation
1088:1:9:14:Codex de Rénovation II
1108:1:9:20:Codex de Rénovation III
3115:1:9:26:Codex de Rénovation IV
9019:1:9:56:Codex de Rénovation IX
1101:1:9:32:Codex de Rénovation V
1105:1:9:38:Codex de Rénovation VI
9000:1:9:44:Codex de Rénovation VI
9012:1:9:50:Codex de Rénovation VIII
21285:3:9:60:Codex de Rénovation X
1090:1:9:10:Codex de Résurrection
1657:1:9:26:Codex de Résurrection II
8996:1:9:42:Codex de Résurrection II
9026:1:9:58:Codex de Résurrection IV
4273:1:9:16:Codex de soins
4268:1:9:22:Codex de Soins II
4270:1:9:28:Codex de Soins III
1092:1:9:4:Codex de Soins inférieurs II
1102:1:9:10:Codex de Soins inférieurs III
1648:1:9:34:Codex de Soins IV
8964:1:9:20:Codex de Soins rapides
8969:1:9:26:Codex de Soins rapides II
8978:1:9:32:Codex de Soins rapides III
8983:1:9:38:Codex de Soins rapides IV
8999:1:9:44:Codex de Soins rapides V
9010:1:9:50:Codex de Soins rapides VI
9022:1:9:56:Codex de Soins rapides VII
3118:1:9:40:Codex de Soins supérieurs
9001:1:9:46:Codex de Soins supérieurs II
9013:1:9:52:Codex de Soins supérieurs III
9025:1:9:58:Codex de Soins supérieurs IV
21284:3:9:60:Codex de Soins supérieurs V
1111:1:9:6:Codex de Sommeil
1676:1:9:20:Codex de Sommeil II
4283:1:9:40:Codex de Sommeil III
1085:1:9:22:Codex de Vision télépathique
8998:1:9:44:Codex de Vision télépathique II
10286:1:7:45:Coeur de fauve
7077:1:7:45:Coeur de feu
21816:1:15:1:Coeur en sucre
21817:1:15:1:Coeur en sucre
21818:1:15:1:Coeur en sucre
21819:1:15:1:Coeur en sucre
21820:1:15:1:Coeur en sucre
21821:1:15:1:Coeur en sucre
21822:1:15:1:Coeur en sucre
21823:1:15:1:Coeur en sucre
12778:1:12:1:Coffre de documents
9276:1:15:45:Coffre de pirate
6356:1:15:8:Coffre endommagé
6355:1:15:30:Coffre solide verrouillé
13875:1:15:45:Coffre à fermetures en fer
13918:1:15:55:Coffre à fermetures renforcées
4637:2:15:40:Coffret d'acier
4638:2:15:45:Coffret d'acier renforcé
5760:2:15:60:Coffret d'éternium
5759:2:15:55:Coffret de thorium
4634:2:15:30:Coffret en fer
5758:2:15:50:Coffret en mithril
16882:1:15:20:Coffret endommagé
16885:1:15:50:Coffret lourd
4633:2:15:25:Coffret lourd en bronze
4632:2:15:20:Coffret orné en bronze
16884:1:15:40:Coffret solide
16883:1:15:30:Coffret usé
10726:2:4:47:Coiffe de contrôle mental gnome
3893:1:4:50:Coiffe en cuir renforcé
279253:4:4:65:Collerette de hors-la-loi
22781:1:15:1:Collier d'ours polaire
20695:3:4:63:Collier de guerre abyssal
272014:2:15:60:Collier en argent
9259:1:15:1:Collier tribal troll
7467:2:4:35:Collier vermeil
22728:2:15:55:Commande de chariotte à vapeur
22622:1:12:60:Commission d'artisan - Anguilles pierre-écaille
22624:1:12:60:Commission d'artisan - Anguilles électriques
22605:1:12:60:Commission d'artisan - Bandeaux corrompus en cuir
22610:1:12:60:Commission d'artisan - Bottes en étoffe runique
22600:1:12:60:Commission d'artisan - Cailloux denses
22607:1:12:60:Commission d'artisan - Ceintures corrompues en cuir
22613:1:12:60:Commission d'artisan - Charges de sapeur gobelin
22615:1:12:60:Commission d'artisan - Coqs de combat gnome
22626:1:12:60:Commission d'artisan - Courante-surprise
22604:1:12:60:Commission d'artisan - Diadèmes radieux
22621:1:12:60:Commission d'artisan - Flacon de pétrification
22603:1:12:60:Commission d'artisan - Grandes haches en thorium
22614:1:12:60:Commission d'artisan - Grenades en thorium
22602:1:12:60:Commission d'artisan - Marteaux volcaniques
22625:1:12:60:Commission d'artisan - Pains de saumon
22601:1:12:60:Commission d'artisan - Pansières impériales
22609:1:12:60:Commission d'artisan - Pantalons en étoffe lumineuse
22608:1:12:60:Commission d'artisan - Pantalons runiques en cuir
22623:1:12:60:Commission d'artisan - Poissons cuirassés
22617:1:12:60:Commission d'artisan - Potions de mana majeures
22619:1:12:60:Commission d'artisan - Potions de protection contre le Givre supérieures
22620:1:12:60:Commission d'artisan - Potions de protection contre les Arcanes supérieures
22618:1:12:60:Commission d'artisan - Potions de soins majeures
22606:1:12:60:Commission d'artisan - Renforts d'armure robustes
22612:1:12:60:Commission d'artisan - Robes en étoffe runique
22611:1:12:60:Commission d'artisan - Sacs en étoffe runique
22616:1:12:60:Commission d'artisan - Tubes en thorium
262888:3:0:1:Commission de compagnon scellée
262887:3:0:1:Commission d’apprenti scellée
248206:3:0:1:Commission d’artisan scellée
262890:3:0:1:Commission d’artisan scellée
264140:3:0:1:Commission d’artisan : altérateur de vrai-argent
264037:3:0:1:Commission d’artisan : balle dure fabriquée
264038:3:0:1:Commission d’artisan : balle en cuir lourd
264146:3:0:1:Commission d’artisan : bandeau runique en cuir
264091:3:0:1:Commission d’artisan : bombe en sombrefer
264088:3:0:1:Commission d’artisan : bombe explosive en mithril
264086:3:0:1:Commission d’artisan : bombe éclairante
264098:3:0:1:Commission d’artisan : bottes de rapidité
264151:3:0:1:Commission d’artisan : bottes de sabre-de-givre
264028:3:0:1:Commission d’artisan : bottes en fer émeraude
264156:3:0:1:Commission d’artisan : bottes en gangrétoffe
264154:3:0:1:Commission d’artisan : bottes en étoffe runique
264052:3:0:1:Commission d’artisan : bottes rouges en laine
264160:3:0:1:Commission d’artisan : bourse d’âme
264108:3:0:1:Commission d’artisan : bourse enchantée en tisse-mage
264147:3:0:1:Commission d’artisan : brassards corrompus en cuir
264094:3:0:1:Commission d’artisan : brassards mats
264150:3:0:1:Commission d’artisan : brassards runiques en cuir
264119:3:0:1:Commission d’artisan : breuvage de détection des démons
264019:3:0:1:Commission d’artisan : breuvage de respiration aquatique
264060:3:0:1:Commission d’artisan : breuvage d’œil de chat
264021:3:0:1:Commission d’artisan : bâtonnet doré
264077:3:0:1:Commission d’artisan : bâtonnet en vrai-argent
264074:3:0:1:Commission d’artisan : camail en écailles dorées
264093:3:0:1:Commission d’artisan : cape de gardien
264031:3:0:1:Commission d’artisan : carabine vise-lune
264065:3:0:1:Commission d’artisan : carburant de fusée gobelin
264097:3:0:1:Commission d’artisan : carquois de tir rapide
264043:3:0:1:Commission d’artisan : carquois lourd
264095:3:0:1:Commission d’artisan : casque en cuir sauvage
264109:3:0:1:Commission d’artisan : ceinture de l’étoile
264126:3:0:1:Commission d’artisan : ceinture radieuse
264115:3:0:1:Commission d’artisan : ceinture terrestre en soie
264092:3:0:1:Commission d’artisan : chapeau de cuir confortable
264049:3:0:1:Commission d’artisan : chaperon azur en soie
264112:3:0:1:Commission d’artisan : chemise orange martiale
264133:3:0:1:Commission d’artisan : coutelas d’ébène
264136:3:0:1:Commission d’artisan : crapaud mécanique
264102:3:0:1:Commission d’artisan : cuirasse en écailles de tortue
264145:3:0:1:Commission d’artisan : cuirasse volcanique
264069:3:0:1:Commission d’artisan : cylindre damasquiné en mithril
264020:3:0:1:Commission d’artisan : dague à manche de perles
264125:3:0:1:Commission d’artisan : diadème radieux
264120:3:0:1:Commission d’artisan : don d’Arthas
264070:3:0:1:Commission d’artisan : dragonne en acier
264085:3:0:1:Commission d’artisan : déclencheur instable
264138:3:0:1:Commission d’artisan : défibrillateur gobelin XL
264124:3:0:1:Commission d’artisan : eau-de-feu distillée
264121:3:0:1:Commission d’artisan : flacon de résistance chromatique
264130:3:0:1:Commission d’artisan : gantelets de sombrerune
264026:3:0:1:Commission d’artisan : gantelets en fer émeraude
264078:3:0:1:Commission d’artisan : gantelets en écailles dorées
264045:3:0:1:Commission d’artisan : gants barbares
264042:3:0:1:Commission d’artisan : gants de chapardeur
264040:3:0:1:Commission d’artisan : gants d’herboriste
264046:3:0:1:Commission d’artisan : gants en cuir de dragonnet rouge
264105:3:0:1:Commission d’artisan : gants en tisse-ombre
264103:3:0:1:Commission d’artisan : giberne en cuir épais
264148:3:0:1:Commission d’artisan : gilet chimérique
264159:3:0:1:Commission d’artisan : gilet en tisse-fantôme
264110:3:0:1:Commission d’artisan : gilet noir en tisse-mage
264027:3:0:1:Commission d’artisan : grand couteau en bronze
264036:3:0:1:Commission d’artisan : grande bombe en bronze
264131:3:0:1:Commission d’artisan : grande hache en thorium
264079:3:0:1:Commission d’artisan : hache lourde en mithril
264072:3:0:1:Commission d’artisan : hache lumineuse bleue
264068:3:0:1:Commission d’artisan : heaume en plaques d’acier
264149:3:0:1:Commission d’artisan : heaume en écailles de scorpide épaisses
264064:3:0:1:Commission d’artisan : huile des ténèbres
264127:3:0:1:Commission d’artisan : jambières de guerre orques
264025:3:0:1:Commission d’artisan : jambières grossières en bronze
264053:3:0:1:Commission d’artisan : kilt coloré
264076:3:0:1:Commission d’artisan : lame corrompue en mithril
264135:3:0:1:Commission d’artisan : lentille verte
264134:3:0:1:Commission d’artisan : leurre ouvragé
264081:3:0:1:Commission d’artisan : leurre perfectionné
264029:3:0:1:Commission d’artisan : longue-vue ornée
264141:3:0:1:Commission d’artisan : lunette de sniper
264087:3:0:1:Commission d’artisan : lunettes de feu
264034:3:0:1:Commission d’artisan : lunettes des ombres
264084:3:0:1:Commission d’artisan : lunettes d’œil de chat
264022:3:0:1:Commission d’artisan : marteau iridescent
264113:3:0:1:Commission d’artisan : masque blanc de bandit
264100:3:0:1:Commission d’artisan : masque du grand vaudou
264158:3:0:1:Commission d’artisan : masque en tisse-ombre
264024:3:0:1:Commission d’artisan : masse lourde en bronze
264089:3:0:1:Commission d’artisan : micro-ajusteur gyromatique
264083:3:0:1:Commission d’artisan : mine gobeline
264082:3:0:1:Commission d’artisan : monocle d’artisan
264030:3:0:1:Commission d’artisan : mouton explosif
264055:3:0:1:Commission d’artisan : mules en soie d’araignée
264129:3:0:1:Commission d’artisan : pansière impériale
264143:3:0:1:Commission d’artisan : pantalon corrompu en cuir
264051:3:0:1:Commission d’artisan : pantalon du phénix
264039:3:0:1:Commission d’artisan : pantalon raffiné en cuir
264111:3:0:1:Commission d’artisan : pantalon rouge en tisse-mage
264132:3:0:1:Commission d’artisan : passe-partout en arcanite
264023:3:0:1:Commission d’artisan : passe-partout en argent
264080:3:0:1:Commission d’artisan : petit dragon mécanique
264050:3:0:1:Commission d’artisan : petit sac en soie
264075:3:0:1:Commission d’artisan : pierre à aiguiser solide
264058:3:0:1:Commission d’artisan : potion de bouclier de pierre inférieure
264061:3:0:1:Commission d’artisan : potion de grande rage
264015:3:0:1:Commission d’artisan : potion de libre action
264062:3:0:1:Commission d’artisan : potion de mana
264013:3:0:1:Commission d’artisan : potion de mana inférieure
264059:3:0:1:Commission d’artisan : potion de protection contre la nature
264063:3:0:1:Commission d’artisan : potion de protection contre le feu
264118:3:0:1:Commission d’artisan : potion de protection contre le feu supérieure
264056:3:0:1:Commission d’artisan : potion de protection contre le givre
264014:3:0:1:Commission d’artisan : potion de protection contre l’ombre
264123:3:0:1:Commission d’artisan : potion de régénération majeure
264067:3:0:1:Commission d’artisan : potion de sauvageonne
264117:3:0:1:Commission d’artisan : potion de sommeil sans rêve
264116:3:0:1:Commission d’artisan : potion de tueur de démons
264057:3:0:1:Commission d’artisan : potion d’invisibilité inférieure
264122:3:0:1:Commission d’artisan : potion d’invulnérabilité limitée
264032:3:0:1:Commission d’artisan : recombobulateur mineur
264106:3:0:1:Commission d’artisan : robe cramoisie en soie
264047:3:0:1:Commission d’artisan : robe de sorcier inférieur
264101:3:0:1:Commission d’artisan : robe du grand vaudou
264054:3:0:1:Commission d’artisan : robe d’adepte supérieur
264107:3:0:1:Commission d’artisan : robe en tisse-ombre
264114:3:0:1:Commission d’artisan : robe en étoffe cendrée
264137:3:0:1:Commission d’artisan : robot d’alarme gnome
264139:3:0:1:Commission d’artisan : robot réparateur 74A
264157:3:0:1:Commission d’artisan : sac d’herbes cénarien
264104:3:0:1:Commission d’artisan : sac en tisse-mage
264153:3:0:1:Commission d’artisan : sac en étoffe runique
264048:3:0:1:Commission d’artisan : salopette bleue
264033:3:0:1:Commission d’artisan : serrure d’entraînement
264144:3:0:1:Commission d’artisan : tenue d’ogre gordok
264090:3:0:1:Commission d’artisan : trousse de réparation mécanique
264041:3:0:1:Commission d’artisan : tunique noire en cuir
264152:3:0:1:Commission d’artisan : turban en tisse-sorcier
264035:3:0:1:Commission d’artisan : télécommande universelle gnome
264155:3:0:1:Commission d’artisan : veste de smoking
264142:3:0:1:Commission d’artisan : yéti mécanique paisible
264018:3:0:1:Commission d’artisan : élixir de défense
264011:3:0:1:Commission d’artisan : élixir de force d’ogre
264012:3:0:1:Commission d’artisan : élixir de sagesse
264017:3:0:1:Commission d’artisan : élixir de sang de Troll inférieur
264066:3:0:1:Commission d’artisan : élixir d’Agilité
264016:3:0:1:Commission d’artisan : élixir d’Agilité inférieure
264099:3:0:1:Commission d’artisan : épaulières de la nuit
264096:3:0:1:Commission d’artisan : épaulières en cuir sauvage
264044:3:0:1:Commission d’artisan : épaulières noires en cuir
264071:3:0:1:Commission d’artisan : épaulières ornées en mithril
264128:3:0:1:Commission d’artisan : éperons en mithril
264073:3:0:1:Commission d’artisan : épée large en acier lunaire
262889:3:0:1:Commission d’expert scellée
217017:1:15:1:Concours de pêche !
19225:1:0:55:Confiserie grillée
267341:1:0:60:Confiture patte-douce
5131:1:9:13:Connaissance : déguisement de Brisepierre
5126:1:9:13:Connaissance : Déguisement de Défias
5129:1:9:22:Connaissance : Déguisement de nain sombrefer
5127:1:9:13:Connaissance : Déguisement de Pirate des Mers du sud
5130:1:9:13:Connaissance : Déguisement de sorcier de Dalaran
5132:1:9:22:Connaissance : Déguisement du Syndicat
4404:1:7:18:Contact en argent
270312:1:15:1:Conte d’I’lalai traduit
272124:1:15:1:Conte d’I’lalai traduit
4387:1:7:32:Contrefiche en fer
6043:1:0:33:Contrepoids en fer
18360:3:12:60:Contrôler les ombres
16006:1:7:58:Convertisseur d'arcanite délicat
11023:1:15:35:Coq d'Ancona
260804:1:7:43:Coque SUR-T
219487:1:15:50:Coquille stellaire
12351:4:15:60:Cor du loup arctique
1133:1:15:40:Cor du loup blanc
5668:3:15:40:Cor du loup brun
18796:4:15:60:Cor du loup brun rapide
1132:3:15:40:Cor du loup des bois
18797:4:15:60:Cor du loup des bois rapide
1134:1:15:40:Cor du loup gris
18798:4:15:60:Cor du loup gris rapide
1041:3:15:40:Cor du loup noir
5665:3:15:40:Cor du loup redoutable
5663:1:15:40:Cor du loup rouge
12330:4:15:60:Cor du loup rouge
279252:4:4:65:Corde cintrée de Sylvancienne
275608:3:4:58:Corde de couve-colonie
275605:3:4:58:Corde de crache-venin
14661:2:4:49:Corde de vigilant
215366:2:4:30:Corde d’invocatrice
254073:2:4:52:Corde en tisse-fantôme
254077:2:4:52:Corde en tisse-terrestre
277037:2:4:10:Corde fil-tempête azur
277013:2:4:10:Corde fil-tempête nuageuse
279267:4:4:65:Corde imprégnée de mana
14093:1:4:9:Corde perlée
9742:1:4:12:Corde simple
8583:1:15:40:Corne du cheval squelette
7959:3:2:50:Corruptrice
6730:2:4:16:Cotte d'anneaux de Forgefer
2398:1:4:10:Cotte d'anneaux légère
847:1:4:17:Cotte de mailles
11606:2:4:56:Cotte de mailles en sombrefer
277016:2:4:12:Cotte de mailles forge-ciel azur
276992:2:4:12:Cotte de mailles forge-ciel nuageuse
12641:4:4:63:Cotte de mailles invulnérable
2392:1:4:10:Cotte de mailles légère
12624:3:4:54:Cotte de mailles Ronce-sauvage
15905:1:2:15:Coup de poing de droitier en laiton
15906:1:2:15:Coup de poing de gaucher en laiton
250602:2:2:21:Coup de poing en laiton
21267:1:15:1:Coupe de "santé"
3189:1:2:8:Coupe-bois
18254:1:0:45:Courante-surprise
275893:1:15:1:Courge brûlante
208760:1:0:1:Couronne de la clairière
206466:1:0:1:Couronne de prairie
254137:2:4:61:Couronne en tisse-terrestre
252555:2:4:58:Couronne ouvragée en cuir
22757:3:4:70:Couronne sylvestre
252561:4:4:61:Couronne vivante
12774:3:2:55:Courroux de l'aube
273636:1:7:45:Couteau de chef
3108:1:2:27:Couteau de lancer lourd
3107:1:2:16:Couteau de lancer perçant
260811:1:7:50:Couteau de l’armée gnome
3225:2:2:11:Couteau taché de sang
7005:1:2:4:Couteau à dépecer
12247:2:2:32:Couteau à lame large
851:1:2:15:Coutelas
18263:4:4:64:Couvre-bras Coeur-de-braise
277052:2:4:35:Couvre-chef mêle-vent azur
277044:2:4:35:Couvre-chef mêle-vent nuageux
15996:1:15:53:Crapaud mécanique
273131:2:15:60:Cris en bouteille
254131:2:4:60:Crispins en tisse-terrestre
254123:2:4:57:Crispins en étoffe runique
277035:2:4:10:Crispins fil-tempête azur
277011:2:4:10:Crispins fil-tempête nuageux
15013:1:4:14:Crispins lupins
14087:1:4:8:Crispins perlées
254019:2:4:40:Crispins terrestres en soie
20725:4:7:60:Cristal de nexus
11184:1:12:1:Cristal de puissance bleu
11188:1:12:1:Cristal de puissance jaune
11186:1:12:1:Cristal de puissance rouge
11185:1:12:1:Cristal de puissance vert
282418:1:12:1:Cristal de rappel bourdonnant
282416:1:12:1:Cristal de rappel luminescent
12363:2:7:60:Cristal des arcanes
2799:1:12:1:Croc de gorille
2522:1:2:35:Croissant
3856:2:2:40:Croissant des ombres
275627:3:4:58:Croquenots de couverain
275624:3:4:58:Croquenots de sangtaille
4399:1:7:10:Crosse en bois
4400:1:7:25:Crosse lourde
2594:1:0:25:Cruche d’hydromiel nain
13545:1:12:1:Crustacé
12783:3:2:63:Crève-coeur
19169:4:2:70:Crépuscule
15419:1:7:50:Cuir d'ours de guerre
19767:1:7:60:Cuir de chauve-souris primordiale
15423:1:7:50:Cuir de chimère
15417:1:7:50:Cuir de diablosaure
6498:1:12:1:Cuir de kodo gravé
6499:1:12:1:Cuir de kodo gravé
6500:1:12:1:Cuir de kodo gravé
6501:1:12:1:Cuir de kodo gravé
15422:1:7:50:Cuir de sabre-de-givre
19768:1:7:60:Cuir de tigre primordial
17012:1:7:60:Cuir du Magma
12810:1:7:55:Cuir enchanté
213369:3:7:40:Cuir faiblement luminescent
5082:1:7:10:Cuir fin de kodo
249427:2:7:25:Cuir immaculé
4234:1:7:30:Cuir lourd
2318:1:7:10:Cuir léger
2319:1:7:20:Cuir moyen
8170:1:7:50:Cuir robuste
5108:1:4:32:Cuir sombrefer
4304:1:7:40:Cuir épais
8203:2:4:44:Cuirasse armée du scorpide
7914:2:4:32:Cuirasse barbare en fer
3547:1:4:1:Cuirasse blanche en cuir D03
250540:2:4:45:Cuirasse brillante en mithril
3527:1:4:1:Cuirasse d'elfe de la nuit blanche
3522:1:4:1:Cuirasse d'elfe de la nuit noire
19690:3:4:65:Cuirasse d'âmesang
20479:3:4:62:Cuirasse de crache-feu
6731:2:4:20:Cuirasse de Forgefer
8349:3:4:50:Cuirasse de plumes
20380:4:4:68:Cuirasse de rêvécaille
20550:3:4:63:Cuirasse de sombrerune
20478:3:4:62:Cuirasse de traqueuse des sables
19693:3:4:65:Cuirasse de ténébrâme
250601:4:4:61:Cuirasse du salut
19688:3:4:65:Cuirasse du tigre-sang
7963:2:4:40:Cuirasse en acier
250487:2:4:30:Cuirasse en argent fin
2870:3:4:29:Cuirasse en argent lumineux
2869:2:4:26:Cuirasse en bronze argenté
15066:3:4:58:Cuirasse en plumacier
12618:3:4:63:Cuirasse en thorium enchanté
7939:3:4:49:Cuirasse en vrai-argent
15141:4:4:62:Cuirasse en écailles d'Onyxia
8367:3:4:51:Cuirasse en écailles de dragon
15048:3:4:57:Cuirasse en écailles de dragon bleu
15050:3:4:58:Cuirasse en écailles de dragon noir
15047:3:4:61:Cuirasse en écailles de dragon rouge
15045:3:4:52:Cuirasse en écailles de dragon vert
5781:2:4:19:Cuirasse en écailles de murloc
8189:2:4:42:Cuirasse en écailles de tortue
3845:2:4:40:Cuirasse en écailles dorées
22664:4:4:80:Cuirasse glacécaille
3538:1:4:1:Cuirasse grise en cuir D02
2866:2:4:23:Cuirasse grossière en bronze
7930:2:4:46:Cuirasse lourde en mithril
3537:1:4:1:Cuirasse noire en cuir D02
7935:2:4:48:Cuirasse ornée en mithril
22669:4:4:80:Cuirasse plaie-de-glace
12415:2:4:54:Cuirasse radieuse
3528:1:4:1:Cuirasse rouge en cuir C03
12613:2:4:62:Cuirasse runique
2864:2:4:18:Cuirasse runique en cuivre
15059:3:4:60:Cuirasse vivante
15053:2:4:57:Cuirasse volcanique
22196:4:4:72:Cuirasse épaisse en obsidienne
250598:4:4:61:Cuissards de champion
250600:4:4:61:Cuissards de martyr
279265:4:4:65:Cuissards en azerothium
2287:1:0:15:Cuissot
209059:1:15:1:Cuissot de broche-tripes
7062:2:4:39:Culotte cramoisie en soie
4309:2:4:14:Culottes en lin cousu main
9060:1:7:42:Cylindre damasquiné en mithril
7191:1:7:26:Câble avec fusible
8948:1:0:55:Cèpe des rois séché
3770:1:0:25:Côtelette de mouton
3727:1:0:25:Côtelettes de lion épicées
250073:1:0:35:Côtelettes de raptor bouillantes
13851:1:0:35:Côtes de loup épicées
2685:1:0:25:Côtes de porc aux herbes
2687:1:0:15:Côtes de porc séchées
2677:1:7:14:Côtes de sanglier
2886:1:7:5:Côtes de sanglier des rochers
2888:1:0:10:Côtes de sanglier à la bière
241652:1:7:1:Cœur de bête décoloré
273127:2:15:60:Cœur de golem
286405:1:0:1:Cœur fleuri
3184:2:2:20:Dague crochet
12259:2:2:36:Dague d'acier luisante
20814:1:2:65:Dague de jet du maître
15327:1:2:40:Dague de lancer corrompue
2946:1:2:8:Dague de lancer équilibrée
3296:1:2:3:Dague du mort
7166:2:2:11:Dague en cuivre
24071:3:2:69:Dague quelconque
280402:1:2:2:Dague rouillée
4565:1:2:6:Dague simple
2787:1:2:3:Dague trogg
2092:1:2:2:Dague usée
5540:2:2:23:Dague à perles
241089:2:2:10:Dague écarlate
2502:1:2:7:Dague éraflée
414:1:0:15:Dalaran piquant
13895:1:4:60:Dangui de cérémonie
13898:1:4:50:Dangui royal
5466:1:7:8:Dard de scorpide
2236:3:2:25:Dard noir
19052:3:4:58:Demi-bottes de l'aube
901:1:15:1:Deptecated White Stallion Summoning (Mount)
3852:2:2:34:Destructeur en fer doré
17016:3:2:65:Destructeur en sombrefer
19269:3:12:1:Deux d'Elémentaires
221300:3:15:1:Deux de Cauchemar
221291:3:15:1:Deux de Dunes
19230:3:12:1:Deux de Fauves
221273:3:15:1:Deux de Nature
221282:3:15:1:Deux de Plaies
19278:3:12:1:Deux de Portails
19259:3:12:1:Deux de Seigneurs de guerre
204689:1:0:1:Deuxième fragment de rune de chasseurs de monstres
4056:1:12:35:Devinette de Cortello
18688:1:12:1:Diablotin en bouteille
44803:2:4:1:Diadème du printemps
10041:3:4:50:Diadème en tisse-rêve
14140:3:4:62:Diadème en étoffe lunaire
12417:2:4:59:Diadème radieux
12800:2:7:60:Diamant d'Azeroth
11754:2:12:1:Diamant noir
18335:3:12:1:Diamant noir parfait
269900:2:15:1:Dispositif de déploiement de bannière centaure
18168:4:4:65:Disque de force réactif
4822:2:4:23:Disque de la chouette
9088:1:0:48:Don d'Arthas
250603:2:2:25:Dory en bronze
3821:1:7:34:Dorépine
2463:1:4:37:Doublet en cuir clouté
2895:1:15:22:Douleur progressive
2453:1:7:20:Doulourante
7558:2:4:25:Douve chatoyante
12284:1:12:1:Draco-Incarcinatrix 900
6041:1:0:38:Dragonne en acier
277053:2:4:35:Drapé mêle-vent azur
277045:2:4:35:Drapé mêle-vent nuageux
4358:1:0:10:Dynamite basique
18641:1:0:45:Dynamite dense
6714:1:0:25:Dynamite Ev-Lan
18588:1:0:40:Dynamite Ev-Lan II
260814:1:0:50:Dynamite futée SUR-T
4365:1:0:20:Dynamite grossière
260798:1:0:35:Dynamite géante SUR-T
4378:1:0:30:Dynamite puissante
10507:1:0:35:Dynamite solide
260792:1:0:25:Dynamite SUR-T
22373:3:12:60:Débris d'armure en cuir
22374:3:12:60:Débris d'armure en mailles
22375:3:12:60:Débris d'armure en plaques
22376:3:12:60:Débris d'armure en tissu
260820:2:4:60:Déchiqueteur d’urgence SUR-T – Long-Guet
18984:2:15:55:Déchiquetteur dimensionnel - Long-guet
17015:3:2:65:Déchireur en sombrefer
12784:3:2:63:Déchireuse en arcanite
10560:1:7:40:Déclencheur instable
2324:1:7:5:Décolorant
11607:3:2:57:Découpeuse en sombrefer
6715:1:0:33:Défibrillateur abîmé
18636:1:0:53:Défibrillateur abîmé XL
7148:1:4:33:Défibrillateur gobelin
18587:1:4:53:Défibrillateurs gobelins XL
6657:1:0:10:Délice de déviant
251525:1:0:10:Délice de fantaileron
6316:1:0:15:Délice de furie du loch
21217:1:0:55:Délice de sagerelle
252032:1:0:15:Délicieuse pomme d’orage rouge
250079:1:0:10:Délicieuses bouchées au raptor
4607:1:0:35:Délicieux humus des grottes
3728:1:0:35:Délicieux steak de lion
184937:1:0:60:Déplaceur de chronochance
212160:1:0:60:Déplaceur de chronochance
12433:1:12:1:E'ko d'Indomptable
12435:1:12:1:E'ko de Chardon de glace
12436:1:12:1:E'ko de Cognegivre
12432:1:12:1:E'ko de Croc acéré
12434:1:12:1:E'ko de Noroît
12430:1:12:1:E'ko de sabre-de-givre
12431:1:12:1:E'ko des Tombe-hiver
9451:1:0:25:Eau bouillonnante
8079:1:0:65:Eau cristalline invoquée
21833:1:15:1:Eau de Cologne
12820:1:0:50:Eau de feu des Tombe-hiver
1851:1:0:24:Eau de purification
159:1:0:5:Eau de source
231778:1:0:65:Eau de source des montagnes
252031:1:0:5:Eau de source fraîche
3772:1:0:35:Eau de source invoquée
17196:1:0:5:Eau de vie spéciale
4791:1:0:35:Eau enchantée
2288:1:0:15:Eau fraîche invoquée
5350:1:0:5:Eau invoquée
8077:1:0:45:Eau minérale invoquée
2136:1:0:25:Eau purifiée invoquée
8078:1:0:55:Eau pétillante invoquée
7070:1:7:25:Eau élémentaire
18288:1:0:1:Eau-de-feu de mélasse
246948:1:0:45:Eau-de-feu distillée
260632:1:0:15:Eau-de-vie de baie glacée
12607:3:7:1:Ecaille chromatique brillante
15410:3:7:60:Ecaille d'Onyxia
17967:3:7:60:Ecaille d'Onyxia raffinée
15415:1:7:50:Ecaille de dragon bleu
15416:1:7:55:Ecaille de dragon noir
15414:1:7:60:Ecaille de dragon rouge
8165:1:7:45:Ecaille de dragon usée
15412:1:7:50:Ecaille de dragon vert
7286:1:7:1:Ecaille de dragonnet noir
7287:1:7:1:Ecaille de dragonnet rouge
7392:1:7:1:Ecaille de dragonnet vert
6470:1:7:1:Ecaille de déviant
6471:1:7:1:Ecaille de déviant parfaite
7072:1:7:25:Ecaille de naga
8154:1:7:45:Ecaille de scorpide
15408:1:7:55:Ecaille de scorpide épaisse
8167:1:7:35:Ecaille de tortue
5784:1:7:15:Ecailles de murloc visqueuses
5785:1:7:35:Ecailles de murloc épaisses
17057:1:15:1:Ecailles de poisson brillantes
9443:1:12:1:Echantillon de monstre utilisé
3320:1:4:9:Echarpe d'ossomancien
6513:1:4:10:Echarpe de disciple
14099:1:4:12:Echarpe indigène
14652:2:4:45:Echarpe scorpashi
15224:2:2:25:Ecrasante
2451:1:4:50:Ecu noble
1201:1:4:10:Ecu terne
247883:2:7:10:Effigie en cire rudimentaire
250075:1:0:55:Effiloché de raptor préhistorique
2450:1:7:15:Eglantine
8949:1:0:37:Elixir d'Agilité
3390:1:0:28:Elixir d'Agilité inférieur
2457:1:0:12:Elixir d'Agilité mineure
9187:1:0:48:Elixir d'Agilité supérieure
9179:1:0:47:Elixir d'Intelligence supérieure
5997:1:0:5:Elixir de défense mineure
13453:1:0:55:Elixir de Force de brute
13452:1:0:56:Elixir de la Mangouste
9264:1:0:50:Elixir de Puissance de l'ombre
17708:1:0:38:Elixir de Puissance du givre
2458:1:0:12:Elixir de Robustesse mineure
3383:1:0:20:Elixir de Sagesse
6662:1:0:18:Elixir de Taille de géant
9155:1:0:47:Elixir des arcanes
217398:1:0:38:Elixir des arcanes inférieur
13454:1:0:57:Elixir des arcanes supérieur
13447:1:0:44:Elixir des Sages
20007:1:0:50:Elixir magesang
22384:4:2:63:Eloquente
260794:1:7:15:Emballage Ev-Lan
8932:1:0:55:Emmental d'Alterac
22194:4:4:70:Emprise noire du Destructeur
232611:1:0:55:Encaustique troll magnifique
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
273500:1:0:1:Enchantement de bottes (Agilité inférieure)
273479:1:0:1:Enchantement de bottes (Agilité mineure)
273556:1:0:1:Enchantement de bottes (Agilité supérieure)
273537:1:0:1:Enchantement de bottes (Agilité)
273503:1:0:1:Enchantement de bottes (Endurance inférieure)
273478:1:0:1:Enchantement de bottes (Endurance mineure)
273555:1:0:1:Enchantement de bottes (Endurance supérieure)
273523:1:0:1:Enchantement de bottes (Endurance)
273512:1:0:1:Enchantement de bottes (Esprit inférieur)
273557:1:0:1:Enchantement de bottes (Esprit)
273530:1:0:1:Enchantement de bottes (Vitesse mineure)
289559:1:0:1:Enchantement de bottes – Vitesse
273513:1:0:1:Enchantement de bouclier (Blocage inférieur)
273605:1:0:1:Enchantement de bouclier (Coup critique)
273602:1:0:1:Enchantement de bouclier (Endurance excellente)
273498:1:0:1:Enchantement de bouclier (Endurance inférieure)
273480:1:0:1:Enchantement de bouclier (Endurance mineure)
273554:1:0:1:Enchantement de bouclier (Endurance supérieure)
273521:1:0:1:Enchantement de bouclier (Endurance)
273553:1:0:1:Enchantement de bouclier (Esprit excellent)
273485:1:0:1:Enchantement de bouclier (Esprit inférieur)
273532:1:0:1:Enchantement de bouclier (Esprit supérieur)
273509:1:0:1:Enchantement de bouclier (Esprit)
273592:1:0:1:Enchantement de bouclier (Loi de la nature)
273484:1:0:1:Enchantement de bouclier (Protection inférieure)
273536:1:0:1:Enchantement de bouclier (Résistance au givre)
273585:1:0:1:Enchantement de bouclier (Résistance à la nature supérieure)
273620:1:0:1:Enchantement de brassards (Agilité excellente)
273613:1:0:1:Enchantement de brassards (Agilité inférieure)
273470:1:0:1:Enchantement de brassards (Agilité mineure)
273616:1:0:1:Enchantement de brassards (Agilité supérieure)
273597:1:0:1:Enchantement de brassards (Agilité)
273614:1:0:1:Enchantement de brassards (Agilité)
273626:1:0:1:Enchantement de brassards (Déviation excellente)
273504:1:0:1:Enchantement de brassards (Déviation inférieure)
273461:1:0:1:Enchantement de brassards (Déviation mineure)
273535:1:0:1:Enchantement de brassards (Déviation)
273548:1:0:1:Enchantement de brassards (Endurance excellente)
273486:1:0:1:Enchantement de brassards (Endurance inférieure)
273464:1:0:1:Enchantement de brassards (Endurance mineure)
273458:1:0:1:Enchantement de brassards (Endurance médiocre)
273542:1:0:1:Enchantement de brassards (Endurance supérieure)
273505:1:0:1:Enchantement de brassards (Endurance)
273546:1:0:1:Enchantement de brassards (Esprit excellent)
273476:1:0:1:Enchantement de brassards (Esprit inférieur)
273467:1:0:1:Enchantement de brassards (Esprit mineur)
273525:1:0:1:Enchantement de brassards (Esprit supérieur)
273502:1:0:1:Enchantement de brassards (Esprit)
273547:1:0:1:Enchantement de brassards (Force excellente)
273471:1:0:1:Enchantement de brassards (Force mineure)
273539:1:0:1:Enchantement de brassards (Force supérieure)
273510:1:0:1:Enchantement de brassards (Force)
273625:1:0:1:Enchantement de brassards (Intelligence excellente)
273496:1:0:1:Enchantement de brassards (Intelligence inférieure)
273611:1:0:1:Enchantement de brassards (Intelligence mineure)
273545:1:0:1:Enchantement de brassards (Intelligence supérieure)
273522:1:0:1:Enchantement de brassards (Intelligence)
273615:1:0:1:Enchantement de brassards (Pouvoir de guérison inférieur)
273612:1:0:1:Enchantement de brassards (Pouvoir de guérison mineur)
273575:1:0:1:Enchantement de brassards (Pouvoir de guérison)
273606:1:0:1:Enchantement de brassards (Puissance des sorts supérieure)
273596:1:0:1:Enchantement de brassards (Puissance des sorts)
273574:1:0:1:Enchantement de brassards (Régénération de mana)
273528:1:0:1:Enchantement de cape (Agilité inférieure)
273482:1:0:1:Enchantement de cape (Agilité mineure)
273604:1:0:1:Enchantement de cape (Agilité)
273586:1:0:1:Enchantement de cape (Camouflage)
273587:1:0:1:Enchantement de cape (Discrétion)
273552:1:0:1:Enchantement de cape (Défense excellente)
273518:1:0:1:Enchantement de cape (Défense supérieure)
273499:1:0:1:Enchantement de cape (Défense)
273588:1:0:1:Enchantement de cape (Esquive)
273483:1:0:1:Enchantement de cape (Protection inférieure)
273468:1:0:1:Enchantement de cape (Protection mineure)
273477:1:0:1:Enchantement de cape (Résistance au feu inférieure)
273584:1:0:1:Enchantement de cape (Résistance au feu supérieure)
273508:1:0:1:Enchantement de cape (Résistance au feu)
273463:1:0:1:Enchantement de cape (Résistance mineure)
273551:1:0:1:Enchantement de cape (Résistance supérieure)
273488:1:0:1:Enchantement de cape (Résistance à l’ombre inférieure)
273519:1:0:1:Enchantement de cape (Résistance)
273633:1:0:1:Enchantement de collier (Agilité)
273634:1:0:1:Enchantement de collier (Déviation)
273630:1:0:1:Enchantement de collier (Force)
273632:1:0:1:Enchantement de collier (Pouvoir de guérison)
273631:1:0:1:Enchantement de collier (Puissance des sorts)
273583:1:0:1:Enchantement de gants (Agilité excellente)
273549:1:0:1:Enchantement de gants (Agilité supérieure)
273520:1:0:1:Enchantement de gants (Agilité)
273619:1:0:1:Enchantement de gants (Dépeçage avancé)
273516:1:0:1:Enchantement de gants (Dépeçage)
273623:1:0:1:Enchantement de gants (Force excellente)
273550:1:0:1:Enchantement de gants (Force supérieure)
273529:1:0:1:Enchantement de gants (Force)
274426:1:0:1:Enchantement de gants (Griffe du lotus)
273527:1:0:1:Enchantement de gants (Herboristerie avancée)
273494:1:0:1:Enchantement de gants (Herboristerie)
273544:1:0:1:Enchantement de gants (Hâte mineure)
273578:1:0:1:Enchantement de gants (Menace)
273524:1:0:1:Enchantement de gants (Minage avancé)
273493:1:0:1:Enchantement de gants (Minage)
273582:1:0:1:Enchantement de gants (Pouvoir de guérison)
273595:1:0:1:Enchantement de gants (Pouvoir des arcanes)
273579:1:0:1:Enchantement de gants (Puissance de l’ombre)
273581:1:0:1:Enchantement de gants (Puissance du feu)
273580:1:0:1:Enchantement de gants (Puissance du givre)
273624:1:0:1:Enchantement de gants (Puissance naturelle)
273594:1:0:1:Enchantement de gants (Puissance sacrée)
273495:1:0:1:Enchantement de gants (Pêche)
273543:1:0:1:Enchantement de gants (Équitation)
273491:1:0:1:Enchantement de plastron (Absorption inférieure)
273460:1:0:1:Enchantement de plastron (Absorption mineure)
273635:1:0:1:Enchantement de plastron (Absorption)
273517:1:0:1:Enchantement de plastron (Caractéristiques inférieures)
273497:1:0:1:Enchantement de plastron (Caractéristiques mineures)
273558:1:0:1:Enchantement de plastron (Caractéristiques supérieures)
273593:1:0:1:Enchantement de plastron (Caractéristiques vivantes)
273540:1:0:1:Enchantement de plastron (Caractéristiques)
273526:1:0:1:Enchantement de plastron (Endurance excellente)
273466:1:0:1:Enchantement de plastron (Endurance inférieure)
273559:1:0:1:Enchantement de plastron (Endurance majeure)
273459:1:0:1:Enchantement de plastron (Endurance médiocre)
273501:1:0:1:Enchantement de plastron (Endurance supérieure)
273475:1:0:1:Enchantement de plastron (Endurance)
273534:1:0:1:Enchantement de plastron (Intelligence excellente)
273469:1:0:1:Enchantement de plastron (Intelligence inférieure)
273560:1:0:1:Enchantement de plastron (Intelligence majeure)
273462:1:0:1:Enchantement de plastron (Intelligence mineure)
273511:1:0:1:Enchantement de plastron (Intelligence supérieure)
273492:1:0:1:Enchantement de plastron (Intelligence)
273591:1:0:1:Enchantement de plastron (Électrocution vengeresse)
273573:1:0:1:Enchantement d’arme (Agilité)
273531:1:0:1:Enchantement d’arme (Arme flamboyante)
273565:1:0:1:Enchantement d’arme (Arme impie)
273627:1:0:1:Enchantement d’arme (Clairvoyance)
273566:1:0:1:Enchantement d’arme (Croisé)
273590:1:0:1:Enchantement d’arme (Démantèlement)
273576:1:0:1:Enchantement d’arme (Esprit renforcé)
273572:1:0:1:Enchantement d’arme (Force)
273563:1:0:1:Enchantement d’arme (Frappe excellente)
273487:1:0:1:Enchantement d’arme (Frappe inférieure)
273473:1:0:1:Enchantement d’arme (Frappe mineure)
273541:1:0:1:Enchantement d’arme (Frappe supérieure)
273514:1:0:1:Enchantement d’arme (Frappe)
273561:1:0:1:Enchantement d’arme (Frisson glacial)
273607:1:0:1:Enchantement d’arme (Grand croisé)
273609:1:0:1:Enchantement d’arme (Grand sorcier)
273577:1:0:1:Enchantement d’arme (Intelligence renforcée)
273571:1:0:1:Enchantement d’arme (Pouvoir de guérison)
273569:1:0:1:Enchantement d’arme (Puissance de l’hiver)
273570:1:0:1:Enchantement d’arme (Puissance des sorts)
273628:1:0:1:Enchantement d’arme (Récupération)
273629:1:0:1:Enchantement d’arme (Révélation)
273506:1:0:1:Enchantement d’arme (Tueur de bête inférieur)
273472:1:0:1:Enchantement d’arme (Tueur de bête mineur)
273533:1:0:1:Enchantement d’arme (Tueur de démon)
273507:1:0:1:Enchantement d’arme (Tueur d’élémentaire inférieur)
273564:1:0:1:Enchantement d’arme (Vol de vie)
273599:1:0:1:Enchantement d’objet en main gauche (Esprit remarquable)
273598:1:0:1:Enchantement d’objet en main gauche (Intelligence excellente)
273600:1:0:1:Enchantement d’objet en main gauche (Sagesse)
279988:1:0:28:Enclume
10647:1:7:50:Encre d'ingénieur
19441:1:7:1:Enorme glande à venin
4728:1:4:1:Epaulière de Twain
8207:2:4:48:Epaulières armées du scorpide
7060:2:4:38:Epaulières azur
5964:2:4:35:Epaulières barbares
7913:2:4:32:Epaulières barbares en fer
134112:2:4:1:Epaulières cachées
7059:2:4:38:Epaulières cramoisies en soie
4251:2:4:26:Epaulières d'homme des collines
19691:3:4:65:Epaulières d'âmesang
10405:1:4:22:Epaulières de bandit
19059:3:4:61:Epaulières de l'Aube d'argent
8192:2:4:42:Epaulières de la nuit
4835:2:4:30:Epaulières de soldat d'élite
19695:3:4:65:Epaulières de ténébrâme
12625:3:4:58:Epaulières du point du jour
19689:3:4:65:Epaulières du tigre-sang
16988:4:4:62:Epaulières en anneaux de feu
3481:2:4:25:Epaulières en bronze argenté
8210:2:4:44:Epaulières en cuir sauvage
3840:2:4:32:Epaulières en fer émeraude
14112:2:4:62:Epaulières en gangrétoffe
12617:2:4:63:Epaulières en mailles sauvages
15067:3:4:54:Epaulières en plumacier
11605:2:4:58:Epaulières en sombrefer
10028:2:4:47:Epaulières en tisse-ombre
15049:3:4:59:Epaulières en écailles de dragon bleu
15051:3:4:60:Epaulières en écailles de dragon noir
15081:2:4:61:Epaulières en écailles de scorpide épaisses
3841:2:4:35:Epaulières en écailles dorées
14139:3:4:61:Epaulières en étoffe lunaire
13867:2:4:61:Epaulières en étoffe runique
10038:2:4:49:Epaulières en étoffe-tempête
4833:2:4:28:Epaulières glorieuses
3480:2:4:22:Epaulières grossières en bronze
12428:2:4:53:Epaulières impériales en plaques
7918:2:4:41:Epaulières lourdes en mithril
4252:2:4:28:Epaulières noires en cuir
10027:2:4:46:Epaulières noires en tisse-mage
4315:2:4:24:Epaulières renforcées en laine
10029:2:4:47:Epaulières rouges en tisse-mage
15096:2:4:62:Epaulières runiques en cuir
12610:2:4:60:Epaulières runiques en plaques
22758:3:4:70:Epaulières sylvestres
15058:3:4:59:Epaulières tempétueuses
7352:2:4:27:Epaulières terrestres en cuir
7057:2:4:36:Epaulières vertes en soie
15061:3:4:54:Epaulières vivantes
15055:2:4:61:Epaulières volcaniques
7969:2:0:43:Eperons en mithril
3713:1:7:30:Epices apaisantes
2678:1:7:5:Epices douces
2692:1:7:20:Epices fortes
17194:1:15:5:Epices spéciales
2131:1:2:3:Epée courte
2496:1:2:8:Epée courte d'écumeur
2057:1:2:4:Epée courte défias
2850:2:2:24:Epée courte en bronze
2847:2:2:10:Epée courte en cuivre
3849:2:2:32:Epée courte en fer trempé
2258:1:2:8:Epée courte frostmane
15211:2:2:22:Epée courte militante
2282:1:2:10:Epée courte Rodentia
3853:2:2:36:Epée d'acier lunaire
8177:1:2:7:Epée d'entraînement
7957:2:2:26:Epée de guerre en bronze
12764:2:2:52:Epée de guerre en thorium
948:1:2:1:Epée de la nature
2481:1:2:4:Epée de péon
935:3:2:20:Epée de veilleur
945:1:2:1:Epée des ténèbres
4818:2:2:24:Epée du bourreau
14391:1:2:1:Epée endurante
997:1:2:1:Epée flamboyante de faiblesse
2520:1:2:36:Epée large
4765:2:2:14:Epée large en émail
923:1:2:26:Epée longue
864:2:2:38:Epée longue des chevaliers
2489:1:2:7:Epée à deux mains
20367:3:15:1:Equipement de chasse
2024:1:2:21:Espadon
250541:2:4:45:Espauliers brillants en mithril
4694:1:4:22:Espauliers brunis
250586:2:4:52:Espauliers bénis en plaques
15505:1:4:23:Espauliers d'estafette
5319:1:4:20:Espauliers de fracas
250539:2:4:40:Espauliers dorés durs
279255:4:4:65:Espauliers d’éternité
277049:2:4:35:Espauliers forge-ciel azur
277041:2:4:35:Espauliers forge-ciel nuageux
1445:1:4:23:Espauliers rochenoires
4372:2:2:24:Espingole amoureusement construite
2511:1:2:14:Espingole de chasseur
4362:2:2:10:Espingole grossière
1119:1:0:25:Esprits en bouteille
10998:2:7:20:Essence astrale inférieure
11082:2:7:25:Essence astrale supérieure
8923:1:15:50:Essence d'agonie
7082:2:7:55:Essence d'air
7080:2:7:55:Essence d'eau
2930:1:15:22:Essence de douleur
7078:2:7:55:Essence de feu
257348:3:5:60:Essence de l’innovation
10938:2:7:10:Essence de magie inférieure
10939:2:7:15:Essence de magie supérieure
12808:2:7:55:Essence de non-mort
7076:2:7:55:Essence de terre
12803:2:7:55:Essence de vie
11174:2:7:40:Essence du néant inférieure
11175:2:7:45:Essence du néant supérieure
273129:2:15:60:Essence d’anarchie
274030:4:7:60:Essence malléable de la nature
11134:2:7:30:Essence mystique inférieure
11135:2:7:35:Essence mystique supérieure
16202:2:7:50:Essence éternelle inférieure
16203:2:7:55:Essence éternelle supérieure
258882:1:2:5:Estramaçon usé
2415:1:15:40:Etalon blanc
2592:1:7:15:Etoffe de laine
2589:1:7:5:Etoffe de lin
4306:1:7:30:Etoffe de soie
4338:1:7:40:Etoffe de tisse-mage
14342:1:7:55:Etoffe lunaire
14047:1:7:50:Etoffe runique
15986:2:4:60:Etoile d'ossomancien
15967:2:4:59:Etoile de bien-né
15973:2:4:30:Etoile de gardien
15931:2:4:61:Etoile des arcanes
2532:1:2:46:Etoile du matin
7555:2:4:45:Etoile régalienne
15964:2:4:44:Etoile Sable-soie
15947:2:4:28:Etoile sanguine
3820:1:7:20:Etouffante
22660:3:4:70:Etreinte de Gaïa
11242:1:12:1:Evoroot
5878:1:0:1:Excellent tabac
16084:1:9:30:Expert en premiers soins - Sous les pansements
16083:1:9:30:Expert pêcheur - Vous et la perche
260808:1:7:48:EZ-Thro Tru-Trigger
2528:1:2:46:Falchion
13343:1:15:20:Familier pierre
13342:1:15:20:Familier poisson
251524:1:7:15:Fantaileron
10284:1:7:30:Farine simple
922:1:2:26:Faux dace
2029:1:2:20:Fendoir
3293:1:2:3:Fendoir du mort
279970:1:0:28:Fermenteur
238641:2:0:65:Festin de loche à taches claires
279957:1:0:28:Festin de Macaron
19026:1:0:50:Feu d'artifice "Explosion serpentine"
20908:1:15:1:Feu d'artifice du festival de Nian
288336:1:0:20:Feu d’artifice bleu
288340:1:0:20:Feu d’artifice rose jaune
288338:1:0:20:Feu d’artifice rouge
288337:1:0:20:Feu d’artifice vert
7068:1:7:25:Feu élémentaire
765:1:7:5:Feuillargent
5049:1:0:5:Feuille de fer verrouillée
1401:1:0:14:Feuille de Thé vert
13463:1:7:54:Feuillerêve
11040:1:12:50:Fibre d'aurore
259891:2:2:48:Fidèle carabine de Berdun
16583:1:15:60:Figurine démoniaque
14341:1:7:50:Fil runique
21024:1:7:60:Filet de chimaerok
238638:1:0:65:Filet de flanc
5476:1:0:15:Filet de furie
13930:1:0:45:Filet de rouget
273295:1:7:45:Filets de poisson de saison
8925:1:7:35:Fiole de cristal
5024:1:15:15:Fiole de glace
18256:1:7:55:Fiole imprégnée
3372:1:7:25:Fiole plombée
3371:1:7:1:Fiole vide
189421:1:15:1:Fire Resist Leather Gear
189419:1:15:1:Fire Resist Plate Gear
189420:1:15:1:Fire Resist Plate Gear
8152:1:7:40:Flacon de grand mojo
274273:2:0:60:Flacon de justesse naturelle
8151:1:7:40:Flacon de mojo
21829:1:15:1:Flacon de parfum
13512:1:0:60:Flacon de pouvoir suprême
274275:2:0:60:Flacon de précision naturelle
13506:1:0:60:Flacon de pétrification
274276:2:0:60:Flacon de rapidité naturelle
13513:1:0:60:Flacon de résistance chromatique
13511:1:0:60:Flacon de sagesse distillée
2593:1:0:15:Flacon de Tawny de Hurlevent
13510:1:0:60:Flacon des Titans
274274:2:0:60:Flacon d’agression naturelle
2521:1:2:36:Flamberge
23083:1:15:1:Flamme captive
250069:1:0:55:Flanchet au poivre
252029:1:0:15:Flanchet d’hippogriffe
814:1:7:1:Flasque d'huile
23247:1:15:1:Fleur ardente
4625:1:7:41:Fleur de feu
208609:1:0:1:Fleur de la clairière
13466:1:7:57:Fleur de peste
206469:1:0:1:Fleur de prairie
19295:1:4:20:Fleur de Sombrelune
22177:1:15:1:Fleurs fraîchement cueillies
3421:1:4:10:Fleurs sauvages simples
18942:1:12:1:Flux embrasé
11285:1:6:45:Flèche barbelée
22235:1:15:1:Flèche en vrai-argent
10579:3:6:42:Flèche explosive
2512:1:6:5:Flèche grossière
2515:1:6:15:Flèche pointue
3030:1:6:30:Flèche rasoir
3464:2:6:35:Flèche à plumes
18042:2:6:57:Flèches à pointe de thorium
925:1:2:25:Fléau
8957:1:0:55:Flétan épineux
8959:1:7:55:Flétan épineux cru
253378:2:15:20:Flûte usée de Tenn
723:1:7:12:Foie de Broche-tripes
19931:3:12:1:Folie mojo des Gurubashi
279952:1:0:60:Fonderie en fusion
4837:2:4:30:Force de la volonté
279987:1:0:60:Forge arcanique
279955:1:0:60:Forge magistrale
6377:2:9:25:Formule : Bottes enchantées (Agilité mineure)
6376:2:9:25:Formule : Bottes enchantées (Endurance mineure)
11813:2:9:53:Formule : Coeur fumant de la montagne
11207:2:9:53:Formule : Enchantement d'arme (Arme flamboyante)
16252:2:9:61:Formule : Enchantement d'arme (Croisé)
16250:2:9:60:Formule : Enchantement d'arme (Frappe excellente)
16223:2:9:57:Formule : Enchantement d'arme (Frisson glacial)
17725:2:9:38:Formule : Enchantement d'arme (Puissance de l'hiver)
11165:2:9:35:Formule : Enchantement d'arme (Tueur d'élémentaire inférieur)
11164:2:9:35:Formule : Enchantement d'arme (Tueur de bête inférieur)
6348:2:9:20:Formule : Enchantement d'arme (Tueur de bête mineur)
11208:2:9:46:Formule : Enchantement d'arme (Tueur de démon)
16254:3:9:62:Formule : Enchantement d'arme (Vol de vie)
11038:2:9:22:Formule : Enchantement d'arme 2M (Esprit inférieur)
16255:2:9:62:Formule : Enchantement d'arme 2M (Esprit majeur)
6349:1:9:20:Formule : Enchantement d'arme 2M (Intelligence inférieure)
16249:2:9:60:Formule : Enchantement d'arme 2M (Intelligence majeure)
16247:2:9:59:Formule : Enchantement d'arme 2M - Impact excellent
16245:2:9:59:Formule : Enchantement de bottes (Agilité supérieure)
16215:2:9:52:Formule : Enchantement de bottes (Endurance supérieure)
11167:2:9:38:Formule : Enchantement de bottes (Esprit inférieur)
16220:2:9:55:Formule : Enchantement de bottes (Esprit)
11168:2:9:39:Formule : Enchantement de bouclier (Blocage inférieur)
11202:2:9:42:Formule : Enchantement de bouclier (Endurance)
16222:2:9:56:Formule : Enchantement de bouclier (Esprit excellent)
11081:2:9:22:Formule : Enchantement de bouclier (Protection inférieure)
11224:2:9:47:Formule : Enchantement de bouclier (Résistance au givre)
6375:2:9:24:Formule : Enchantement de bracelet (Esprit inférieur)
16246:2:9:59:Formule : Enchantement de bracelet (Force excellente)
11223:2:9:47:Formule : Enchantement de bracelets (Déviation)
16251:2:9:60:Formule : Enchantement de bracelets (Endurance excellente)
11225:2:9:49:Formule : Enchantement de bracelets (Endurance supérieure)
16218:2:9:54:Formule : Enchantement de bracelets (Esprit excellent)
6344:2:9:17:Formule : Enchantement de bracelets (Esprit mineur)
11204:2:9:44:Formule : Enchantement de bracelets (Esprit supérieur)
11101:2:9:28:Formule : Enchantement de bracelets (Force inférieure)
6347:2:9:19:Formule : Enchantement de bracelets (Force mineure)
16214:2:9:51:Formule : Enchantement de bracelets (Intelligence supérieure)
11206:2:9:45:Formule : Enchantement de cape (Agilité inférieure)
16224:1:9:57:Formule : Enchantement de cape (Défense excellent)
11098:2:9:27:Formule : Enchantement de cape (Résistance aux ténèbres inférieure)
16216:2:9:53:Formule : Enchantement de cape (Résistance supérieure)
16219:2:9:54:Formule : Enchantement de gants (Agilité supérieure)
11166:2:9:40:Formule : Enchantement de gants (Dépeçage)
11226:2:9:50:Formule : Enchantement de gants (Equitation)
16244:2:9:59:Formule : Enchantement de gants (Force supérieure)
11205:2:9:45:Formule : Enchantement de gants (Herboristerie avancée)
11151:2:9:29:Formule : Enchantement de gants (Herboristerie)
11203:2:9:43:Formule : Enchantement de gants (Minage avancé)
11150:2:9:29:Formule : Enchantement de gants (Minage)
11152:2:9:29:Formule : Enchantement de gants (Pêche)
16253:2:9:62:Formule : Enchantement de plastron (Caractéristiques supérieures)
20754:1:9:50:Formule : Huile de mana inférieure
20752:1:9:30:Formule : Huile de mana mineure
20755:1:9:55:Formule : Huile de sorcier
20753:1:9:40:Formule : Huile de sorcier inférieure
20758:1:9:15:Formule : Huile de sorcier mineure
6345:2:9:18:Formule : Imprégnation de cape (Protection)
6222:2:9:12:Formule : Imprégnation de plastron (Esprit mineur)
6343:2:9:14:Formule : Imprégnation de plastron (Esprit)
8547:2:9:50:Formule : Puissants sels odorants
289560:2:9:50:Formule : enchantement de bottes – Vitesse
16221:1:9:55:Formule : enchantement de plastron (Endurance majeure)
6346:2:9:19:Formule : enchantement de plastron (Intelligence inférieure)
16242:2:9:58:Formule : enchantement de plastron (Intelligence majeure)
6342:2:9:12:Formule : enchantement de plastron (Intelligence mineure)
16248:2:9:59:Formule : enchantement d’arme (Arme impie)
223163:2:9:15:Formule : parchemin de guérison spatiale
248613:1:0:25:Foudre en bouteille
7548:2:4:46:Foulard d'onyx
279982:1:0:60:Four en fer
276471:3:15:1:Fournitures de chasse de niveau 23
276472:3:15:1:Fournitures de chasse de niveau 38
276473:3:15:1:Fournitures de chasse de niveau 57
276474:3:15:1:Fournitures de chasse de niveau 60
274697:3:15:1:Fournitures de couture de niveau 23
274698:3:15:1:Fournitures de couture de niveau 38
274699:3:15:1:Fournitures de couture de niveau 57
274700:3:15:1:Fournitures de couture de niveau 60
274693:3:15:1:Fournitures de dépeçage de niveau 23
274694:3:15:1:Fournitures de dépeçage de niveau 38
274695:3:15:1:Fournitures de dépeçage de niveau 57
274696:3:15:1:Fournitures de dépeçage de niveau 60
278066:3:15:1:Fournitures d’artisanat de niveau 60
274701:3:15:1:Fournitures d’enchantement de niveau 23
274702:3:15:1:Fournitures d’enchantement de niveau 38
274703:3:15:1:Fournitures d’enchantement de niveau 57
274704:3:15:1:Fournitures d’enchantement de niveau 60
274689:3:15:1:Fournitures d’herboriste de niveau 23
274690:3:15:1:Fournitures d’herboriste de niveau 38
274691:3:15:1:Fournitures d’herboriste de niveau 57
274692:3:15:1:Fournitures d’herboriste de niveau 60
274684:3:15:1:Fournitures minières de niveau 23
274686:3:15:1:Fournitures minières de niveau 38
274687:3:15:1:Fournitures minières de niveau 57
274688:3:15:1:Fournitures minières de niveau 60
9253:1:12:1:Fragment central de la carte
20384:1:12:1:Fragment de carapace de silithide
10593:2:12:1:Fragment de draenéthyste imparfait
3006:1:4:25:Fragment de relique sacrée
223168:2:0:45:Fragment du noyau du monde
279276:1:0:1:Fragment d’amulette de Mathystra
9252:1:12:1:Fragment inférieur de la carte
9251:1:12:1:Fragment supérieur de la carte
22526:1:12:1:Fragments d'os
2530:1:2:46:Francisque
3190:1:2:8:Frappeur
249874:1:0:35:Frappé calcifié
249872:1:0:15:Frappé gélatineux
249876:1:0:55:Frappé pernicieux
249871:1:0:5:Frappé venimeux
249875:1:0:45:Frappé épicé
16167:1:0:15:Friandise versicolore
249873:1:0:25:Frppl mrrggl
12763:1:0:55:Fruit du néant Un'Goro
19167:4:2:66:Fureur noire
6317:1:7:15:Furie du loch crue
4379:2:2:26:Fusil plaqué argent
9315:1:0:20:Fusée "rose jaune"
9317:1:0:20:Fusée bleu blanc rouge
9312:1:0:20:Fusée bleue
5740:1:0:20:Fusée de feu d'artifice rouge
9318:1:0:20:Fusée rouge
9313:1:0:20:Fusée verte
2160:1:4:27:Gambison
248819:2:7:60:Gangrecristal
248825:1:7:60:Gangrecuir
248824:1:7:60:Gangrepeau
14256:1:7:50:Gangrétoffe
250545:2:4:49:Gantelets brillants en mithril
250588:2:4:54:Gantelets bénis en plaques
19157:4:4:70:Gantelets chromatiques
15083:2:4:52:Gantelets corrompus en cuir
6510:1:4:11:Gantelets d'infanterie
19692:3:4:65:Gantelets d'âmesang
9762:1:4:13:Gantelets de cadet
20480:3:4:62:Gantelets de crache-feu
6733:2:4:28:Gantelets de Forgefer
12639:4:4:62:Gantelets de la forteresse
8346:3:4:46:Gantelets de la mer
20549:3:4:63:Gantelets de sombrerune
20477:3:4:62:Gantelets de traqueuse des sables
3304:1:4:14:Gantelets des eaux stagnantes
15063:3:4:58:Gantelets diablosaures
250538:2:4:40:Gantelets dorés durs
250485:2:4:26:Gantelets en argent fin
3483:2:4:27:Gantelets en bronze argenté
3485:2:4:30:Gantelets en fer émeraude
12631:3:4:58:Gantelets en plaques de feu
19164:4:4:70:Gantelets en sombrefer
7938:3:4:45:Gantelets en vrai-argent
8347:3:4:45:Gantelets en écailles de dragon
20296:3:4:56:Gantelets en écailles de dragon vert
252596:2:4:56:Gantelets en écailles de scorpide chargées
15078:2:4:55:Gantelets en écailles de scorpide épaisses
9366:2:4:41:Gantelets en écailles dorées
217273:2:4:41:Gantelets en écailles dorées
277018:2:4:11:Gantelets forge-ciel azur
276994:2:4:11:Gantelets forge-ciel nuageux
22666:4:4:80:Gantelets glacécaille
250589:2:4:57:Gantelets impériaux en plaques
7919:2:4:41:Gantelets lourds en mithril
279264:4:4:65:Gantelets lourds en thorium
3474:2:4:15:Gantelets ornementés en cuivre
252553:2:4:57:Gantelets ouvragés en cuir
22670:4:4:80:Gantelets plaie-de-glace
12418:2:4:57:Gantelets radieux
15091:2:4:54:Gantelets runiques en cuir
3472:2:4:12:Gantelets runiques en cuivre
12632:3:4:59:Gantelets tempêtes
3290:1:4:12:Gants ancestraux
8204:2:4:45:Gants armés du scorpide
4319:2:4:29:Gants azur en soie
4254:2:4:30:Gants barbares
7917:2:4:37:Gants barbares en fer
2428:1:4:50:Gants brigandines
2440:1:4:50:Gants brodés
2434:1:4:37:Gants brun-roux
158329:2:4:1:Gants cachés
15074:2:4:53:Gants chimériques
16979:4:4:62:Gants Coeur-de-braise
7064:2:4:42:Gants cramoisis en soie
7285:2:4:24:Gants d'agilité en cuir
3526:1:4:1:Gants d'elfe de la nuit noirs
7349:2:4:27:Gants d'herboriste
4247:2:4:29:Gants d'homme des collines en cuir
18408:3:4:62:Gants d'Inferno
3281:1:4:11:Gants de bataille en anneaux
7358:2:4:28:Gants de chapardeur
2960:1:4:9:Gants de compagnon
275607:3:4:58:Gants de couve-colonie
275604:3:4:58:Gants de crache-venin
6515:1:4:11:Gants de disciple
7348:2:4:25:Gants de fabricant d'arcs
5966:2:4:38:Gants de gardien
2968:1:4:9:Gants de guerrier
19057:3:4:61:Gants de l'Aube
2972:1:4:14:Gants de lieur de sort
276539:4:4:61:Gants de mande-esprit
14146:4:4:62:Gants de maîtrise magique
4318:2:4:26:Gants de méditation
9755:1:4:13:Gants de nomade
6521:1:4:11:Gants de pionnier
8091:1:4:50:Gants de plates
15070:2:4:59:Gants de sabre-de-givre
7049:2:4:30:Gants de vraie foi
17721:2:4:38:Gants du Grandpère
15300:1:4:14:Gants du grizzly
4331:2:4:25:Gants du phénix
2422:1:4:37:Gants en anneaux doublés
2403:1:4:10:Gants en anneaux légers
2391:1:4:5:Gants en anneaux rouillés
2385:1:4:5:Gants en anneaux ternis
2145:1:4:27:Gants en cuir bouilli
2964:1:4:10:Gants en cuir brûlé
2469:1:4:37:Gants en cuir clouté
2125:1:4:5:Gants en cuir craquelé
7284:2:4:24:Gants en cuir de dragonnet rouge
4239:2:4:13:Gants en cuir estampé
797:1:4:10:Gants en cuir grossier
4253:3:4:27:Gants en cuir raffermi
2475:1:4:50:Gants en cuir renforcé
714:1:4:5:Gants en cuir sale
844:1:4:17:Gants en cuir tanné
239:1:4:22:Gants en cuir traité
18407:3:4:62:Gants en gangrétoffe
4310:2:4:17:Gants en laine épaisse
4307:2:4:10:Gants en lin épais
850:1:4:17:Gants en mailles
2397:1:4:10:Gants en mailles légères
18238:3:4:40:Gants en peau d'ombre
19686:3:4:65:Gants en peau de chauve-souris primordiale
7925:2:4:44:Gants en plaques de mithril
252546:2:4:53:Gants en suédine bleue
14142:2:4:54:Gants en tisse-fantôme
10023:2:4:45:Gants en tisse-ombre
10019:3:4:45:Gants en tisse-rêve
254075:2:4:52:Gants en tisse-terrestre
839:1:4:17:Gants en toile renforcée
718:1:4:22:Gants en écailles
6467:2:4:21:Gants en écailles de déviant
8187:2:4:41:Gants en écailles de tortue
217270:2:4:41:Gants en écailles de tortue
2151:1:4:27:Gants en écailles polies
14043:2:4:54:Gants en étoffe cendrée
14101:2:4:54:Gants en étoffe lumineuse
18409:3:4:62:Gants en étoffe lunaire
2119:1:4:5:Gants en étoffe légère
711:1:4:5:Gants en étoffe rapiécés
13863:2:4:55:Gants en étoffe runique
203:1:4:22:Gants en étoffe épaisse
10011:2:4:44:Gants en étoffe-tempête
2375:1:4:10:Gants endommagés en cuir
14387:1:4:1:Gants endurants
22654:4:4:80:Gants glaciaires
2158:1:4:27:Gants matelassés
4248:2:4:26:Gants noirs en cuir
10003:2:4:43:Gants noirs en tisse-mage
7927:2:4:44:Gants ornés en mithril
14089:1:4:10:Gants perlés
22662:4:4:80:Gants polaires
10018:2:4:45:Gants rouges en tisse-mage
9746:1:4:13:Gants simples
21278:3:4:62:Gants tempétueux
254017:2:4:39:Gants terrestres en soie
7359:2:4:29:Gants terrestres lourds
13870:2:4:53:Gants tisse-givre
277024:2:4:11:Gants tisse-souffle azur
277000:2:4:11:Gants tisse-souffle nuageux
2369:1:4:10:Gants tissés
3286:1:4:12:Gants tribaux
793:1:4:10:Gants tricotés
2312:2:4:15:Gants élégants en cuir
19168:4:2:70:Garde noire
277029:2:4:10:Garde-bras mêle-vent azur
277005:2:4:10:Garde-bras mêle-vent nuageux
14550:4:4:49:Garde-bras plaie-des-lames
277020:2:4:12:Garde-jambes forge-ciel azur
276996:2:4:12:Garde-jambes forge-ciel nuageux
279257:4:4:65:Garde-mains endeuillés
279256:4:4:65:Garde-poignets de tranquillité
269501:2:4:60:Garde-poignets en mailles elfiques
277017:2:4:10:Garde-poignets forge-ciel azur
276993:2:4:10:Garde-poignets forge-ciel nuageux
12797:3:2:63:Gardienne de givre
18356:3:12:60:Garona : une étude en discrétion et en trahison
255722:1:7:58:Garrot chirurgical
255721:1:7:36:Garrot en cuir
255720:1:7:21:Garrot en laine
275682:1:15:1:Gelée nerveuse
278265:1:0:5:Gelée nutritive
20475:1:0:1:Gemme d'âme
5223:1:0:28:Gemme de mana vide
6244:1:0:1:ggggfg
7372:2:11:35:Giberne en cuir lourd
8218:2:11:45:Giberne en cuir épais
3855:2:2:37:Gigantesque hache en fer
4324:2:4:30:Gilet azur en soie
2578:2:4:14:Gilet barbare en lin
6240:2:4:12:Gilet bleu en lin
2435:1:4:50:Gilet brodé
2429:1:4:37:Gilet brun-roux
15075:2:4:58:Gilet chimérique
7058:2:4:37:Gilet cramoisi en soie
4244:2:4:20:Gilet d'homme des collines en cuir
4781:2:4:20:Gilet des murmures
2141:1:4:27:Gilet en cuir bouilli
5957:2:4:10:Gilet en cuir cousu main
2127:1:4:5:Gilet en cuir craquelé
2300:2:4:12:Gilet en cuir estampé
799:1:4:10:Gilet en cuir grossier
2470:1:4:50:Gilet en cuir renforcé
85:1:4:5:Gilet en cuir sale
8211:2:4:45:Gilet en cuir sauvage
14141:2:4:55:Gilet en tisse-fantôme
10021:3:4:45:Gilet en tisse-rêve
254121:2:4:59:Gilet en tisse-terrestre
19682:3:4:65:Gilet en vignesang
252598:2:4:57:Gilet en écailles de scorpide chargées
252599:2:4:59:Gilet en écailles de scorpide souples
14042:2:4:52:Gilet en étoffe cendrée
14138:3:4:60:Gilet en étoffe lunaire
193:1:4:5:Gilet en étoffe rapiécée
200:1:4:22:Gilet en étoffe épaisse
10020:2:4:45:Gilet en étoffe-tempête
277034:2:4:12:Gilet fil-tempête azur
277010:2:4:12:Gilet fil-tempête nuageux
2108:1:4:4:Gilet frostmane en cuir
22652:4:4:80:Gilet glaciaire
6709:2:4:18:Gilet Lueur-de-lune
2568:1:4:8:Gilet marron en lin
9998:2:4:41:Gilet noir en tisse-mage
14158:2:4:26:Gilet païen
6239:2:4:12:Gilet rouge en lin
10007:2:4:43:Gilet rouge en tisse-mage
22756:3:4:70:Gilet sylvestre
7051:2:4:34:Gilet terrestre
2364:1:4:10:Gilet tissé
2582:2:4:17:Gilet vert en laine
7228:1:0:25:Glace à la fraise d’Aguilor
2488:1:2:9:Glaive
255645:1:7:1:Glande à venin enflée
12586:1:0:50:Glande à venin immature
7079:1:7:45:Globe d'eau
3664:1:0:25:Gombo de crocilisque
260633:1:0:25:Gorgée de limebière
6290:1:0:10:Goujon brillant
6291:1:7:5:Goujon brillant cru
1082:1:0:15:Goulash des Carmines
2130:1:2:3:Gourdin
4563:1:2:9:Gourdin de Billy
3294:1:2:3:Gourdin du mort
2485:1:2:3:Gourdin fendu
2259:1:2:8:Gourdin frostmane
16792:2:2:37:Gourdin géant
2064:1:2:11:Gourdin trogg
280400:1:2:2:Gourdin usé
18675:1:15:1:Grades de la Horde & de l'Alliance
17034:1:15:20:Graine d'érable
17038:1:15:60:Graine de bois de fer
17037:1:15:50:Graine de charme
17036:1:15:40:Graine de frêne
17035:1:15:30:Graine de strangleronce
268415:2:7:5:Graines de plantes communes
268416:2:7:20:Graines de plantes inhabituelles
268418:2:7:46:Graines de plantes peu courantes
268417:2:7:36:Graines de plantes singulières
238642:2:0:65:Grand banquet de homard
13893:1:0:55:Grand barracuda cru
1200:1:4:5:Grand bouclier en bois
2445:1:4:22:Grand bouclier en métal
2129:1:4:5:Grand bouclier rond
241086:1:4:5:Grand bouclier écarlate
767:1:2:8:Grand bâton
928:1:2:25:Grand bâton
12251:2:2:37:Grand bâton
3848:2:2:20:Grand couteau en bronze
5637:1:7:30:Grand croc
2480:1:2:3:Grand gourdin
18793:4:15:60:Grand kodo blanc
18794:4:15:60:Grand kodo brun
18795:4:15:60:Grand kodo gris
6214:2:2:16:Grand maillet en cuivre
2446:1:4:27:Grand pavois
804:1:1:25:Grand sac bleu
4499:1:1:35:Grand sac brun
5576:1:1:25:Grand sac brun
22249:2:1:65:Grand sac d'enchantement
21194:3:1:62:Grand sac de D'Sak
857:1:1:25:Grand sac rouge
5575:1:1:25:Grand sac vert
933:1:1:25:Grand sac à dos
1725:1:1:35:Grand sac à dos
14344:3:7:55:Grand éclat brillant
22203:1:7:1:Grand éclat d'obsidienne
280803:1:15:30:Grand-duc
4380:1:0:33:Grande bombe en bronze
4370:1:0:26:Grande bombe en cuivre
4394:1:0:43:Grande bombe en fer
6367:1:2:30:Grande canne à pêche en fer
4398:1:0:40:Grande charge d'hydroglycérine
8500:1:15:30:Grande chouette cornue
21593:1:15:1:Grande comète blanche
21589:1:15:1:Grande comète bleue
21595:1:15:1:Grande comète jaune
21592:1:15:1:Grande comète rouge
21590:1:15:1:Grande comète verte
21591:1:15:1:Grande comète violette
1288:1:7:1:Grande glande à venin
2531:1:2:44:Grande hache
12775:2:2:56:Grande hache en thorium
2486:1:2:3:Grande masse en pierre
7945:2:2:46:Grande masse noire
12799:2:7:55:Grande opale
21153:1:7:40:Grande sagerelle crue
247786:1:7:5:Granule de magie
274964:1:15:1:Granule de magie instable
250617:3:2:63:Grave-Tempête
19055:1:15:20:Green Dragon Orb
4390:1:0:35:Grenade en fer
15993:1:0:52:Grenade en thorium
260816:1:0:57:Grenade en thorium Ev-Lan
260803:1:0:40:Grenade Ev-Lan
284869:1:0:52:Grenade non sanctifiée
5859:1:0:1:Grenade à fragmentation
19306:1:0:45:Grenouille croustillante
5635:1:7:15:Griffe aiguisée
15903:1:2:25:Griffe de droitier
15907:1:2:25:Griffe de gaucher
20423:1:7:1:Griffe de scorpide sableuse
275610:3:4:58:Griffes de cloque-bilieuse
275613:3:4:58:Griffes de saccage-essaim
250609:2:2:45:Griffes en mithril
1244:1:9:22:Grimoire d'Armure démoniaque
3139:1:9:34:Grimoire d'Armure démoniaque II
9218:1:9:30:Grimoire d'Asservir démon
1228:1:9:6:Grimoire d'Ebullition
3140:1:9:18:Grimoire d'Ebullition II
4220:1:9:30:Grimoire d'Ebullition III
3143:1:9:6:Grimoire d'Esprit ardent
3144:1:9:16:Grimoire d'Esprit ardent II
3146:1:9:28:Grimoire d'Esprit ardent III
4219:1:9:40:Grimoire d'Esprit ardent IV
4208:1:9:32:Grimoire d'Explosion mentale
9190:1:9:1:Grimoire d'Immolation
1245:1:9:10:Grimoire d'Immolation II
4200:1:9:22:Grimoire d'Immolation III
4205:1:9:34:Grimoire d'Immolation IV
21282:3:9:60:Grimoire d'immolation VIII
4201:1:9:28:Grimoire d'Oeil de Kilrogg
4198:1:9:12:Grimoire de Captation d'âme
4199:1:9:20:Grimoire de Captation d'âme II
4204:1:9:28:Grimoire de Captation d'âme III
4217:1:9:36:Grimoire de Captation d'âme IV
5727:1:9:40:Grimoire de Captation de mana
9198:1:9:12:Grimoire de Captation de vie
9204:1:9:20:Grimoire de Captation de vie II
9215:1:9:28:Grimoire de Captation de vie III
9226:1:9:36:Grimoire de Captation de vie IV
9193:1:9:6:Grimoire de Connexion
9202:1:9:18:Grimoire de Connexion II
9217:1:9:30:Grimoire de Connexion III
9192:1:9:4:Grimoire de Corruption
9201:1:9:16:Grimoire de Corruption II
9216:1:9:28:Grimoire de Corruption III
9231:1:9:40:Grimoire de Corruption IV
21283:3:9:60:Grimoire de Corruption VII
1229:1:9:18:Grimoire de Création de Pierre d'âme
4218:1:9:26:Grimoire de Création de pierre de sang
4210:1:9:14:Grimoire de Création de pierre de sang inférieure
5726:1:9:38:Grimoire de Création de pierre de sang supérieure
5721:1:9:34:Grimoire de Création de Pierre de sort
9207:1:9:24:Grimoire de Créer Pierre de sang II
9228:1:9:36:Grimoire de Créer Pierre de sang III
3141:1:9:14:Grimoire de Drain de vie
5719:1:9:22:Grimoire de Drain de vie II
4214:1:9:30:Grimoire de Drain de vie III
1250:1:9:26:Grimoire de Détection d'Invisibilité inférieure
4221:1:9:40:Grimoire de Détection de l'invisibilité
1224:1:9:24:Grimoire de Détection des démons
1681:1:9:16:Grimoire de Faiblesse
9219:1:9:30:Grimoire de Flammes infernales
22891:3:9:60:Grimoire de Gardien de l'ombre IV
4209:1:9:30:Grimoire de Gardien de l’ombre
4216:1:9:40:Grimoire de Gardien sacré
9194:1:9:8:Grimoire de Malédiction d'agonie
9205:1:9:20:Grimoire de Malédiction d'agonie II
9221:1:9:32:Grimoire de Malédiction d'agonie III
4207:1:9:30:Grimoire de Malédiction d'Archimonde
9191:1:9:4:Grimoire de Malédiction de faiblesse
9200:1:9:14:Grimoire de Malédiction de faiblesse II
9209:1:9:24:Grimoire de Malédiction de faiblesse III
9223:1:9:34:Grimoire de Malédiction de faiblesse IV
3134:1:9:4:Grimoire de Malédiction de Mannoroth
5720:1:9:20:Grimoire de Malédiction de Mannoroth II
4212:1:9:32:Grimoire de Malédiction de Mannoroth III
3142:1:9:10:Grimoire de Malédiction de Sargeras
4206:1:9:24:Grimoire de Malédiction de Sargeras II
5723:1:9:36:Grimoire de Malédiction de Sargeras III
9199:1:9:12:Grimoire de Malédiction de témérité
9211:1:9:26:Grimoire de Malédiction de témérité II
9230:1:9:40:Grimoire de Malédiction de témérité III
5724:1:9:22:Grimoire de Malédiction des langages
9222:1:9:32:Grimoire de Malédiction des éléments
1232:1:9:10:Grimoire de Peau de démon II
4211:1:9:14:Grimoire de Pestilence
4203:1:9:26:Grimoire de Pestilence II
5725:1:9:38:Grimoire de Pestilence III
1238:1:9:8:Grimoire de Peur
4202:1:9:24:Grimoire de Peur II
5729:1:9:40:Grimoire de Peur III
4215:1:9:20:Grimoire de Pluie de feu
5728:1:9:40:Grimoire de Pluie de feu II
1246:1:9:16:Grimoire de Respiration démoniaque
9195:1:9:10:Grimoire de Siphon d'âme
9208:1:9:24:Grimoire de Siphon d'âme II
9227:1:9:36:Grimoire de Siphon d'âme III
1239:1:9:26:Grimoire de Siphon de mana
5722:1:9:36:Grimoire de Siphon de mana II
9229:1:9:36:Grimoire de Siphon de vie IV
21281:3:9:60:Grimoire de Trait de l'ombre X
1231:1:9:6:Grimoire de Trait de l’ombre II
1243:1:9:12:Grimoire de Trait de l’ombre III
3138:1:9:20:Grimoire de Trait de l’ombre IV
9212:1:9:28:Grimoire de Trait de l’ombre V
9225:1:9:36:Grimoire de Trait de l’ombre VI
9203:1:9:20:Grimoire du Rituel d'invocation
4600:1:0:35:Grog à la cerise
731:1:7:12:Groin de Broche-tripes
8846:1:7:50:Gromsang
11937:1:15:1:Gros sac de pièces
11178:3:7:45:Gros éclat irradiant
11139:3:7:35:Gros éclat luminescent
11084:3:7:25:Gros éclat scintillant
277021:2:4:11:Grèves forge-ciel azur
276997:2:4:11:Grèves forge-ciel nuageuses
21307:3:9:60:Guide : Aspect du faucon VII
21304:3:9:60:Guide : Flèches multiples V
21306:3:9:60:Guide : Morsure du serpent IX
279969:1:0:28:Guide de terrain
4389:1:7:34:Gyrochronatome
260625:1:0:45:Gâteau de riz décoré
16169:1:0:35:Gâteau de riz sauvage
8396:1:12:1:Gésier de vautour
21542:1:4:1:Habit de fête
4825:2:2:29:Hache calleuse
2134:1:2:4:Hache courte
926:1:2:25:Hache de bataille
768:1:2:9:Hache de bûcheron
4824:2:2:27:Hache de confusion
279260:4:2:65:Hache de défense de la forêt
4568:2:2:21:Hache de grunt
3325:1:2:9:Hache de guerre Aileron noir
7958:2:2:27:Hache de guerre en bronze
3488:2:2:13:Hache de guerre en cuivre
3489:2:2:17:Hache de guerre lourde
12282:1:2:2:Hache de guerre usée
3135:1:2:16:Hache de lancer aiguisée
3111:1:2:3:Hache de lancer grossière
3137:1:2:27:Hache de lancer mortelle
15326:1:2:40:Hache de lancer resplendissante
3131:1:2:8:Hache de lancer équilibrée
4826:2:2:26:Hache de maraudeur
12250:2:2:34:Hache de minuit
927:1:2:24:Hache double
2499:1:2:9:Hache double
250612:2:2:48:Hache d’armes chargée en mithril
250615:3:2:57:Hache d’hast en thorium
251960:2:2:10:Hache d’Yngwe
2849:2:2:23:Hache en bronze
2845:1:2:9:Hache en cuivre
12249:2:2:31:Hache impitoyable
2479:1:2:4:Hache large
2483:1:2:3:Hache large grossière
2491:1:2:8:Hache lourde
7941:2:2:42:Hache lourde en mithril
7942:2:2:44:Hache lumineuse bleue
2054:1:2:4:Hache trogg
2025:1:2:20:Hache ébarbée
853:1:2:16:Hachette
2260:1:2:9:Hachette frostmane
2066:1:2:8:Hachette mâcheroc
250067:1:0:55:Hachis de chauve-souris
5109:1:4:17:Haillons brisepierre
4033:1:4:50:Halo de l'aube
13900:1:4:40:Hanbok nuptial vert
13896:1:4:30:Hanbok nuptial vert foncé
13897:1:4:10:Hanbok traditionnel blanc
13899:1:4:20:Hanbok traditionnel rouge
248823:1:7:60:Hantefeuille
224806:2:0:50:Harmonisateur de portail de la Légion
224893:2:0:50:Harmonisateur de portail surchargé
224912:2:0:50:Harmonisateur d’harmonisateur de portail
5875:1:15:40:Harnais : bélier bleu
5874:1:15:40:Harnais : bélier noir
5739:2:4:38:Harnais barbare
6125:1:4:1:Harnais de bagarreur
6526:1:4:37:Harnais de combat
6525:1:4:27:Harnais de grunt
15064:3:4:55:Harnais de l'ours de guerre
6524:1:4:22:Harnais en cuir clouté
4455:2:4:33:Harnais en peau de raptor
2370:1:4:10:Harnais endommagé en cuir
277022:2:4:12:Harnais tisse-souffle azur
276998:2:4:12:Harnais tisse-souffle nuageux
6523:1:4:17:Harnais à boucle
285:1:4:22:Haubergeon d'écailles
10421:2:4:10:Haubergeon grossier en cuivre
3844:3:4:36:Haubert en fer émeraude
250543:2:4:48:Heaume brillant en mithril
250593:2:4:60:Heaume béni en plaques
134110:2:4:1:Heaume caché
12640:4:4:61:Heaume Coeur-de-lion
12633:3:4:60:Heaume d'âme blanche
252485:4:4:61:Heaume de l’ours de guerre
8092:1:4:50:Heaume de plates
20551:3:4:63:Heaume de sombrerune
12636:3:4:61:Heaume du grand chef
3836:2:4:34:Heaume en fer émeraude
7922:2:4:43:Heaume en plaques d'acier
19148:4:4:66:Heaume en sombrefer
12410:2:4:56:Heaume en thorium
12620:3:4:62:Heaume en thorium enchanté
252604:4:4:61:Heaume en écailles de dragon bleu
252605:4:4:61:Heaume en écailles de dragon noir
252581:2:4:53:Heaume en écailles de scorpide chargées
252597:2:4:57:Heaume en écailles de scorpide souples
277048:2:4:35:Heaume forge-ciel azur
277040:2:4:35:Heaume forge-ciel nuageux
12427:2:4:59:Heaume impérial en plaques
250599:4:4:61:Heaume infrangible
7934:2:4:47:Heaume lourd en mithril
7937:2:4:49:Heaume orné en mithril
12612:2:4:61:Heaume runique en plaques
10588:2:4:47:Heaume-fusée gobelin
961:1:0:5:Herbe de soins
5173:1:15:30:Herbe mortelle
3819:1:7:39:Hivernale
13909:1:15:55:Homard de 12 livres
13910:1:15:55:Homard de 15 livres
13911:1:15:55:Homard de 19 livres
13912:1:15:55:Homard de 21 livres
13913:1:15:55:Homard de 22 livres
13907:1:15:55:Homard de 7 livres
13908:1:15:55:Homard de 9 livres
13888:1:7:55:Homard Pince-noire
1274:1:12:1:Houblon
21213:2:15:40:Houx préservé
8956:1:0:41:Huile d'immolation
1177:1:0:8:Huile d'Olaf
6370:1:7:15:Huile de bouche-noire
6371:1:7:25:Huile de feu
20748:1:0:55:Huile de mana brillante
20747:1:7:50:Huile de mana inférieure
20745:1:0:30:Huile de mana mineure
13423:1:7:50:Huile de pierre-écaille
17058:1:15:1:Huile de poisson
20750:1:0:50:Huile de sorcier
20749:1:0:55:Huile de sorcier brillante
20746:1:7:40:Huile de sorcier inférieure
20744:1:0:15:Huile de sorcier mineure
3824:1:0:34:Huile des ténèbres
3829:1:0:40:Huile glaciale
19275:3:12:1:Huit d'Elémentaires
221306:3:15:1:Huit de Cauchemar
221297:3:15:1:Huit de Dunes
19236:3:12:1:Huit de Fauves
221279:3:15:1:Huit de Nature
221288:3:15:1:Huit de Plaies
19284:3:12:1:Huit de Portails
19265:3:12:1:Huit de Seigneurs de guerre
11018:1:12:1:Humus d'Un'Goro
279966:1:0:60:Hutte de pêche
279947:1:0:60:Hybrideur de graines
18283:3:0:60:Hyperviseur Biznicks 247 x 128
3174:1:7:10:Ichor d'araignée
7972:1:7:45:Ichor de non-mort
23227:1:12:1:iCoke Gift Box Voucher
19642:1:12:1:iCoke Prize Voucher
22822:1:12:1:iCoke Prize Voucher
20866:3:12:61:Idole azur
20868:3:12:61:Idole brillante
20873:3:12:61:Idole d'albâtre
20869:3:12:61:Idole d'ambre
20867:3:12:61:Idole d'onyx
20870:3:12:61:Idole de jaspe
20882:3:12:61:Idole de la guerre
23197:3:4:65:Idole de la lune
20881:3:12:61:Idole de la lutte
20876:3:12:61:Idole de la mort
20875:3:12:61:Idole de la nuit
20878:3:12:61:Idole de la renaissance
20879:3:12:61:Idole de la vie
279250:4:4:65:Idole de rapidité
279251:4:4:65:Idole des ours jumeaux
20877:3:12:61:Idole du sage
20874:3:12:61:Idole du soleil
20871:3:12:61:Idole en obsidienne
20872:3:12:61:Idole vermillon
9311:1:0:1:Imprimerie par défaut
273125:2:15:60:Index de liche
279450:2:15:1:Insigne cassé
1400:1:0:12:Insigne de Swiftfeather
875:1:15:1:Invocation de cheval bai
255007:1:7:1:Isoressort de golem
2121:1:4:5:Jacque en étoffe légère
1529:2:7:35:Jade
2207:1:2:16:Jambiya
19683:3:4:65:Jambières  en vignesang
8206:2:4:49:Jambières armées du scorpide
14727:2:4:19:Jambières aux peintures de guerre
5963:2:4:34:Jambières barbares
2425:1:4:50:Jambières brigandines
250591:2:4:59:Jambières bénies en plaques
15072:2:4:56:Jambières chimériques
19165:4:4:70:Jambières Coeur-de-braise
7929:2:4:42:Jambières de guerre orques
15065:3:4:57:Jambières de l'ours de guerre
4816:2:4:24:Jambières de légionnaire
8093:1:4:50:Jambières de plates
15069:2:4:57:Jambières de sabre-de-givre
19694:3:4:65:Jambières de ténébrâme
15062:3:4:60:Jambières diablosaures
250536:2:4:38:Jambières dorées dures
4830:2:4:28:Jambières du sabre
2418:1:4:37:Jambières en anneaux doublés
2400:1:4:10:Jambières en anneaux légers
2388:1:4:5:Jambières en anneaux rouillés
2381:1:4:5:Jambières en anneaux ternis
250484:2:4:26:Jambières en argent fin
10423:2:4:31:Jambières en bronze argenté
7373:2:4:33:Jambières en cuir mat
8212:2:4:50:Jambières en cuir sauvage
3842:2:4:31:Jambières en fer émeraude
2394:1:4:10:Jambières en mailles légères
7920:2:4:42:Jambières en plaques de mithril
252486:4:4:61:Jambières en plumacier
17013:4:4:60:Jambières en sombrefer
12414:2:4:60:Jambières en thorium
12619:3:4:63:Jambières en thorium enchanté
14132:2:4:55:Jambières en tisse-sorcier
254125:2:4:58:Jambières en tisse-terrestre
20295:3:4:60:Jambières en écailles de dragon bleu
15052:3:4:62:Jambières en écailles de dragon noir
252603:4:4:61:Jambières en écailles de dragon rouge
15046:3:4:54:Jambières en écailles de dragon vert
252600:2:4:59:Jambières en écailles de scorpide chargées
252606:4:4:61:Jambières en écailles de scorpide immaculées
252580:2:4:53:Jambières en écailles de scorpide souples
15079:2:4:57:Jambières en écailles de scorpide épaisses
8185:2:4:47:Jambières en écailles de tortue
3843:2:4:34:Jambières en écailles dorées
2152:1:4:27:Jambières en écailles polies
12256:2:4:49:Jambières en étoffe cendrée
14137:3:4:58:Jambières en étoffe lunaire
14388:1:4:1:Jambières endurantes
277038:2:4:12:Jambières fil-tempête azur
277014:2:4:12:Jambières fil-tempête nuageuses
2865:2:4:21:Jambières grossières en bronze
12429:2:4:61:Jambières impériales en plaques
7921:2:4:42:Jambières lourdes en mithril
7926:2:4:44:Jambières ornées en mithril
12255:2:4:46:Jambières pâles
12420:2:4:61:Jambières radieuses
12614:2:4:62:Jambières runiques en plaques
20538:3:4:63:Jambières runiques ténébreuses
253999:2:4:35:Jambières terrestres
22385:4:4:60:Jambières titanesques
15060:3:4:57:Jambières vivantes
15054:2:4:54:Jambières volcaniques
4599:1:0:45:Jambonneau traité
279948:1:0:28:Jardin de pierres
3771:1:0:35:Jarret de cochon sauvage
13876:1:15:45:Jaune-queue de 40 livres
13877:1:15:45:Jaune-queue de 47 livres
13878:1:15:45:Jaune-queue de 53 livres
13879:1:15:45:Jaune-queue de 59 livres
13880:1:15:45:Jaune-queue de 68 livres
21552:1:0:45:Jaune-queue rayé
6887:1:0:45:Jaune-queue tacheté
4603:1:7:45:Jaune-queue tacheté cru
10822:1:15:30:Jeune dragonnet sombre
23713:1:15:1:Jeune hippogrpyhe
8391:1:12:1:Joues de Raillecroc
5791:1:12:29:Journal d'Henrig Lonebrow
3711:1:12:1:Journal de recherche de Belamoore
277533:1:15:1:Journal gangrené
5075:1:12:1:Joyau de sang
6786:1:4:10:Jupe simple
1645:1:0:45:Jus de baie lunaire
1205:1:0:25:Jus de melon
252027:1:0:15:Jus d’aérelles
10048:2:4:19:Kilt coloré
276538:4:4:61:Kilt de mande-esprit
10047:2:4:15:Kilt simple
22324:1:0:55:Kimchi d'hiver
21031:1:0:55:Kimchi de chou
21033:1:0:55:Kimchi de radis
9529:1:15:1:Kit d'équipement de guerrier interne N25
9532:1:15:1:Kit d'équipement de Guerrier interne N30
279981:1:0:4:Kit de feu de camp basique
279961:1:0:18:Kit de feu de camp de compagnon
279974:1:0:40:Kit de feu de camp de spécialiste
4391:1:0:35:Kit de moissonneur compact
275993:3:15:40:Kodo blanc
15293:4:15:60:Kodo bleu
15290:3:15:40:Kodo brun
15277:3:15:40:Kodo gris
277960:3:15:40:Kodo lavande
15292:4:15:60:Kodo vert
2209:1:2:24:Kris
7947:2:2:51:Kriss d'ébène
5472:1:0:10:Kébab d'araignée kaldorei
1017:1:0:25:Kébab de loup assaisonné
17119:1:0:15:Kébab de Rat des profondeurs
19484:1:15:1:L'artichaut loup-de-givre
18665:4:4:71:L'Oeil de l'ombre
7741:1:12:1:La Hampe de Tsol
18359:3:12:60:La lumière et comment l'altérer
18361:3:12:60:La plus grande race de chasseurs
279951:1:0:60:Laboratoire de médecin de peste
279990:1:0:60:Laboratoire d’alchimie
12990:3:2:23:Lacératrice
17198:1:0:10:Lait de poule
1179:1:0:15:Lait glacé
2268:1:2:10:Lame brisepierre
7943:2:2:45:Lame corrompue en mithril
15904:1:2:35:Lame de droitier
15909:1:2:35:Lame de gaucher
17704:2:2:38:Lame de l'hiver
9719:3:15:38:Lame des héros brisée
9718:3:2:38:Lame des héros reforgée
12260:2:2:39:Lame dorée flamboyante
3295:1:2:3:Lame du mort
279259:4:2:65:Lame en bois-de-fer
7961:3:2:49:Lame fantôme
4766:2:2:13:Lame farouche
22383:4:2:64:Lame feuille-de-saule
12976:3:2:20:Lame Ironpatch
2065:1:2:9:Lame mâcheroc
1384:1:2:3:Lame terne
15810:1:2:25:Lance courte
250605:2:2:37:Lance en acier
15811:1:2:35:Lance lourde
12802:3:2:60:Lance noire
10720:1:4:42:Lance-filet automatique gnome
21570:1:15:1:Lanceur de chapelets
21569:1:15:1:Lanceur de fusée
260784:1:7:5:Languette SUR-T
277031:2:4:10:Lanière mêle-vent azur
277007:2:4:10:Lanière mêle-vent nuageuse
2934:1:7:5:Lanières de cuir déchirées
8836:1:7:44:Larmes d'Arthas
7954:3:2:47:Le Briseur
18357:3:12:60:Le codex de défense
270313:1:15:1:Le conte d’I’lalai en zandali
20010:1:12:1:Le Cri de la Horde
18401:4:12:60:Le guide de Nostro du tueur de dragons
18363:3:12:60:Le Horion de givre et vous
10586:1:0:45:Le Mastoc
7337:1:4:60:Le Rocher
18364:3:12:60:Le Rêve d'Emeraude
19998:3:4:65:Lentille en vignesang
10504:3:4:49:Lentille verte
17781:1:12:1:Les instructions du Paria
18769:3:12:60:Les plates en thorium enchanté
18770:3:12:60:Les plates en thorium enchanté
18771:3:12:60:Les plates en thorium enchanté
18358:3:12:60:Les recettes de l’arcaniste
2725:1:12:1:Les vertes collines de Strangleronce - Page 1
2734:1:12:1:Les vertes collines de Strangleronce - Page 10
2735:1:12:1:Les vertes collines de Strangleronce - Page 11
2738:1:12:1:Les vertes collines de Strangleronce - Page 14
2740:1:12:1:Les vertes collines de Strangleronce - Page 16
2742:1:12:1:Les vertes collines de Strangleronce - Page 18
2744:1:12:1:Les vertes collines de Strangleronce - Page 20
2745:1:12:1:Les vertes collines de Strangleronce - Page 21
2748:1:12:1:Les vertes collines de Strangleronce - Page 24
2749:1:12:1:Les vertes collines de Strangleronce - Page 25
2750:1:12:1:Les vertes collines de Strangleronce - Page 26
2751:1:12:1:Les vertes collines de Strangleronce - Page 27
2728:1:12:1:Les vertes collines de Strangleronce - Page 4
2730:1:12:1:Les vertes collines de Strangleronce - Page 6
2732:1:12:1:Les vertes collines de Strangleronce - Page 8
6279:1:12:1:Lettre moisie
4366:1:0:17:Leurre
16023:1:0:55:Leurre ouvragé
4392:1:0:37:Leurre perfectionné
20394:1:12:1:Lexique du crépuscule - Chapitre 1
20395:1:12:1:Lexique du crépuscule - Chapitre 2
20396:1:12:1:Lexique du crépuscule - Chapitre 3
22299:1:15:1:Liasse de cartes
5683:1:9:50:Libram : Bouclier divin II
21289:3:9:60:Libram : Bénédiction de puissance VII
21288:3:9:60:Libram : Bénédiction de sagesse VI
5676:1:9:20:Libram : Détection des morts-vivants
1139:1:9:30:Libram : Epuration
5672:1:9:20:Libram : Exorcisme
5673:1:9:28:Libram : Exorcisme II
5674:1:9:36:Libram : Exorcisme III
8929:1:9:44:Libram : Exorcisme IV
8939:1:9:52:Libram : Exorcisme V
8947:1:9:60:Libram : Exorcisme VI
1138:1:9:4:Libram : Faveur divine
1136:1:9:18:Libram : Faveur divine II
8909:1:9:8:Libram : Frappe sacrée II
8913:1:9:16:Libram : Frappe sacrée III
8915:1:9:24:Libram : Frappe sacrée IV
8919:1:9:32:Libram : Frappe sacrée V
8922:1:9:40:Libram : Frappe sacrée VI
8934:1:9:48:Libram : Frappe sacrée VII
8943:1:9:56:Libram : Frappe sacrée VIII
8910:1:9:10:Libram : Imposition des mains
8917:1:9:30:Libram : Imposition des mains II
8937:1:9:50:Libram : Imposition des mains III
8912:1:9:10:Libram : Inquisition
8914:1:9:22:Libram : Inquisition II
8920:1:9:34:Libram : Inquisition III
8931:1:9:46:Libram : Inquisition IV
8944:1:9:58:Libram : Inquisition V
4167:1:9:40:Libram : Jugement
8935:1:9:50:Libram : Jugement II
8945:1:9:60:Libram : Jugement III
1141:1:9:6:Libram : Lumière sacrée II
1151:1:9:14:Libram : Lumière sacrée III
1534:1:9:22:Libram : Lumière sacrée IV
21290:3:9:60:Libram : Lumière sacrée IX
4164:1:9:30:Libram : Lumière sacrée V
4165:1:9:38:Libram : Lumière sacrée VI
8933:1:9:46:Libram : Lumière sacrée VI
8941:1:9:54:Libram : Lumière sacrée VIII
8911:1:9:10:Libram : Poing de la Justice
8916:1:9:26:Libram : Poing de la Justice II
8921:1:9:40:Libram : Poing de la Justice III
8940:1:9:54:Libram : Poing de la Justice IV
1150:1:9:6:Libram : Purification
5677:1:9:24:Libram : Renvoi des morts-vivants
5682:1:9:38:Libram : Renvoi des morts-vivants I
8938:1:9:52:Libram : Renvoi des morts-vivants III
5685:1:9:40:Libram : Rédemption
1536:1:9:30:Libram : Sceau de colère
5666:1:9:40:Libram : Sceau de colère II
8936:1:9:50:Libram : Sceau de colère II
5670:1:9:60:Libram : Sceau de colère V
6133:1:9:14:Libram : Sceau de fureur
5660:1:9:16:Libram : Sceau de piété
5661:1:9:26:Libram : Sceau de piété II
5662:1:9:36:Libram : Sceau de piété III
8930:1:9:46:Libram : Sceau de piété IV
8942:1:9:56:Libram : Sceau de piété V
4166:1:9:8:Libram : Sceau de protection
5680:1:9:20:Libram : Sceau de protection II
8918:1:9:30:Libram : Sceau de protection II
5658:1:9:8:Libram : Sceau de puissance
1149:1:9:20:Libram : Sceau de puissance II
5671:1:9:32:Libram : Sceau de puissance III
5678:1:9:36:Libram : Sceau de sacrifice
6132:1:9:12:Libram : Sceau de sagesse
5667:1:9:24:Libram : Sceau de sagesse II
5679:1:9:36:Libram : Sceau de sagesse III
5684:1:9:22:Libram : Sceau de salut
205863:1:15:1:Libram corrompu
11733:2:9:50:Libram de constitution
23203:3:4:65:Libram de ferveur
18333:2:9:50:Libram de focalisation
18334:2:9:50:Libram de protection
18332:2:9:50:Libram de rapidité
11732:2:9:50:Libram de rumination
11736:2:9:50:Libram de résistance
11734:2:9:50:Libram de ténacité
11737:2:9:50:Libram de voracité
279248:4:4:65:Libram d’imprégnation
279247:4:4:65:Libram inébranlable
249399:2:7:25:Lichen à volants
17203:4:7:60:Lingot de sulfuron
250081:1:0:55:Linguines aux palourdes
283389:1:12:1:Liste de Skonk
8685:1:12:1:Livraison de Houle de Dran
17682:3:9:50:Livre : Don du fauve
17683:3:9:60:Livre : Don du fauve II
4223:1:9:36:Livre d'Abolir magie
8760:1:9:26:Livre d'Abolir poison
8787:1:9:22:Livre d'Apaiser les animaux
8788:1:9:38:Livre d'Apaiser les animaux II
8789:1:9:54:Livre d'Apaiser les animaux III
1341:1:9:4:Livre d'Eclat lunaire
1886:1:9:10:Livre d'Eclat lunaire II
1882:1:9:16:Livre d'Eclat lunaire III
4228:1:9:22:Livre d'Eclat lunaire IV
8777:1:9:52:Livre d'Eclat lunaire IX
8763:1:9:28:Livre d'Eclat lunaire V
8770:1:9:34:Livre d'Eclat lunaire VI
8903:1:9:40:Livre d'Eclat lunaire VII
8904:1:9:46:Livre d'Eclat lunaire VIII
8796:1:9:58:Livre d'Eclat lunaire X
5139:1:9:6:Livre d'Epines
5148:1:9:14:Livre d'Epines II
5154:1:9:24:Livre d'Epines III
8769:1:9:34:Livre d'Epines IV
8782:1:9:44:Livre d'Epines V
8792:1:9:54:Livre d'Epines VI
8744:1:9:6:Livre de Colère
5142:1:9:6:Livre de Colère II
5149:1:9:14:Livre de Colère III
5151:1:9:22:Livre de Colère IV
5156:1:9:30:Livre de Colère V
4226:1:9:38:Livre de Colère VI
8784:1:9:46:Livre de Colère VII
8793:1:9:54:Livre de Colère VIII
16072:1:9:30:Livre de cuisine pour expert
8758:1:9:22:Livre de Délivrance de la malédiction
8757:1:9:20:Livre de Feu stellaire
8761:1:9:26:Livre de Feu stellaire II
8768:1:9:34:Livre de Feu stellaire III
8907:1:9:42:Livre de Feu stellaire IV
8780:1:9:50:Livre de Feu stellaire V
8798:1:9:58:Livre de Feu stellaire VI
21295:3:9:60:Livre de Feu stellaire VII
1332:1:9:14:Livre de Guérison du poison
1328:1:9:18:Livre de Lucioles
8764:1:9:30:Livre de Lucioles II
8779:1:9:42:Livre de Lucioles III
8790:1:9:54:Livre de Lucioles IV
8743:1:9:1:Livre de Marque du fauve
8776:1:9:50:Livre de Marque du fauve
8902:1:9:40:Livre de Marque du fauve
5155:1:9:10:Livre de Marque du fauve II
5163:1:9:20:Livre de Marque du fauve III
5153:1:9:30:Livre de Marque du fauve IV
8799:1:9:60:Livre de Marque du fauve VII
24101:3:9:60:Livre de Morsure féroce V
5730:1:9:4:Livre de Récupération
1334:1:9:10:Livre de Récupération II
1877:1:9:16:Livre de Récupération III
3088:1:9:22:Livre de Récupération IV
8785:1:9:52:Livre de Récupération IX
8762:1:9:28:Livre de Récupération V
8771:1:9:34:Livre de Récupération VI
8778:1:9:40:Livre de Récupération VII
8906:1:9:46:Livre de Récupération VIII
8797:1:9:58:Livre de Récupération X
21296:3:9:60:Livre de Récupération XI
5141:1:9:12:Livre de Rétablissement
8756:1:9:18:Livre de Rétablissement II
8759:1:9:24:Livre de Rétablissement III
8765:1:9:30:Livre de Rétablissement IV
8800:1:9:60:Livre de Rétablissement IX
8772:1:9:36:Livre de Rétablissement V
8905:1:9:42:Livre de Rétablissement VI
8781:1:9:48:Livre de Rétablissement VII
8791:1:9:54:Livre de Rétablissement VIII
1339:1:9:8:Livre de Sarments
5147:1:9:18:Livre de Sarments II
4225:1:9:28:Livre de Sarments III
8900:1:9:38:Livre de Sarments IV
8773:1:9:48:Livre de Sarments V
8795:1:9:58:Livre de Sarments VI
8745:1:9:8:Livre de Toucher guérisseur
5145:1:9:8:Livre de Toucher guérisseur II
5150:1:9:14:Livre de Toucher guérisseur III
5152:1:9:20:Livre de Toucher guérisseur IV
8783:1:9:50:Livre de Toucher guérisseur IX
5160:1:9:26:Livre de Toucher guérisseur V
4230:1:9:32:Livre de Toucher guérisseur VI
8774:1:9:38:Livre de Toucher guérisseur VII
8901:1:9:44:Livre de Toucher guérisseur VIII
8794:1:9:56:Livre de Toucher guérisseur X
21294:3:9:60:Livre de Toucher guérisseur XI
5158:1:9:30:Livre de Tranquillité
8775:1:9:40:Livre de Tranquillité II
8786:1:9:50:Livre de Tranquillité III
8801:1:9:60:Livre de Tranquillité IV
4326:2:4:37:Longue cape en soie
5116:1:7:1:Longue plume de queue
4589:1:7:1:Longue plume élégante
5507:1:0:27:Longue-vue ornée
2417:1:4:37:Lorica doublée
3471:2:4:10:Lorica en cuivre
2109:1:4:5:Lorica frostmane
2386:1:4:5:Lorica rouillée
2379:1:4:5:Lorica ternie
19297:2:0:35:Lot de Sombrelune (inférieur)
19298:2:0:20:Lot de Sombrelune (mineur)
19296:2:0:50:Lot de Sombrelune (supérieur)
248822:2:7:60:Lotus mortifère
13468:2:7:60:Lotus noir
8831:1:7:42:Lotus pourpre
219454:1:15:50:Lotus stellaire
4778:2:2:19:Lourde masse à pointes
3487:2:2:19:Lourde épée large en cuivre
269830:1:15:20:Louveteau neigeux
21721:1:0:1:Lueur de la lune
4405:1:0:12:Lunette basique
4407:1:0:36:Lunette de précision
10548:1:0:48:Lunette de sniper
10546:1:0:42:Lunette mortelle
4406:1:0:22:Lunette standard
10499:2:4:35:Lunettes d'oeil brillant
10501:2:4:44:Lunettes d'oeil de chat
15999:2:4:54:Lunettes de concentration extrême
10500:2:4:41:Lunettes de feu
10502:2:4:43:Lunettes de fortification des sorts
16008:2:4:58:Lunettes de maître ingénieur
4368:2:4:20:Lunettes de tigre volant
4373:2:4:24:Lunettes des ombres
279272:3:0:65:Lunettes d’ultra-précision SUR-T
19999:3:4:65:Lunettes en vignesang
10503:2:4:46:Lunettes roses
4385:2:4:30:Lunettes teintées vertes
279976:1:0:4:Luth enchanté
6292:1:15:15:Lutjan de 10 livres
6294:1:15:15:Lutjan de 12 livres
6295:1:15:15:Lutjan de 15 livres
6359:1:7:25:Lutjan de nagefeu
13759:1:7:45:Lutjan nagenuit cru
4592:1:0:15:Lutjan à longue mâchoire
6289:1:7:15:Lutjan à longue mâchoire cru
279945:1:0:60:Machine à coudre
785:1:7:10:Mage royal
279960:1:0:4:Magnétite
924:1:2:26:Maillet
2533:1:2:45:Maillet de guerre
2493:1:2:9:Maillet en bois
4777:2:2:18:Maillet en bois de fer
19170:4:2:70:Main d'ébène
2526:1:2:34:Main gauche
7047:2:4:29:Mains des ténèbres
774:2:7:7:Malachite
21150:1:15:35:Malle cerclée de fer
21228:1:15:45:Malle cerclée de mithril
20708:1:15:15:Malle soigneusement scellée
21113:1:15:25:Malle étanche
15474:1:4:8:Manchettes du destrier
16170:1:0:25:Mandu vapeur
15484:1:4:12:Manicles de guerre déchirées
16980:4:4:61:Mantelet Coeur-de-braise
14170:1:4:22:Mantelet de boucanier
276540:4:4:61:Mantelet de mande-esprit
4196:3:4:30:Mantelet de plumes
4698:1:4:21:Mantelet de prophète
20406:2:4:60:Mantelet de sectateur du crépuscule
19050:3:4:61:Mantelet des Grumegueules
19058:3:4:61:Mantelet doré de l'Aube
215365:2:4:30:Mantelet d’invocatrice
254127:2:4:59:Mantelet en tisse-fantôme
254119:2:4:57:Mantelet en tisse-terrestre
15019:1:4:21:Mantelet lupin
14157:1:4:24:Mantelet païen
154:1:4:1:Mantelet primitif
6134:1:4:1:Mantelet primitif
16113:1:9:42:Manuel : Bandage en tisse-mage
16112:1:9:36:Manuel : Bandage épais en soie
6454:2:9:26:Manuel : Sérum anti-venin supérieur
24102:3:9:60:Manuel d'Eviscération IX
16645:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 1
16654:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 10
16655:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 11
16656:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 12
16646:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 2
16647:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 3
16648:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 4
16649:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 5
16650:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 6
16651:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 7
16652:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 8
16653:1:12:1:Manuel d'utilisation du Déchiqueteur - Page 9
21298:3:9:60:Manuel de Cri de guerre VII
21297:3:9:60:Manuel de Frappe héroïque IX
21299:3:9:60:Manuel de Vengeance VI
255728:2:9:36:Manuel : anti-venin efficace
232434:1:9:70:Manuel : bandage épais en étoffe runique
255727:2:9:36:Manuel : cataplasme excellent
255731:2:9:59:Manuel : cataplasme puissant
255724:2:9:26:Manuel : cataplasme rusé
255730:2:9:58:Manuel : garrot chirurgical
255726:2:9:36:Manuel : garrot en cuir
255725:2:9:45:Manuel : potion de soins excellente
255729:2:9:55:Manuel : potion de soins majeure
255723:2:9:31:Manuel : potion de soins supérieure
6644:1:15:5:Maquereau boursouflé
787:1:0:10:Maquereau ombré
6303:1:7:5:Maquereau ombré cru
2028:1:2:21:Marteau
12772:2:2:54:Marteau damasquiné en thorium
5956:1:2:1:Marteau de forgeron
289292:4:2:35:Marteau de fureur bestiale
2525:1:2:35:Marteau de guerre
2501:1:2:9:Marteau de guerre en bois
7956:2:2:25:Marteau de guerre en bronze
250608:2:2:43:Marteau de guerre en mithril
12776:3:2:56:Marteau de guerre enchanté
1389:1:2:7:Marteau de mine kobold
12796:3:2:63:Marteau des Titans
2194:3:2:25:Marteau diamant
810:4:2:54:Marteau du vent nordique
2361:1:2:2:Marteau détérioré
3262:1:2:3:Marteau en bois vermoulu
2026:1:2:21:Marteau en pierre
781:1:2:9:Marteau en pierre de gnoll
17193:4:2:67:Marteau en sulfuron
5541:2:2:28:Marteau iridescent
2500:1:2:7:Marteau léger
7946:2:2:49:Marteau runique en mithril
12792:2:2:58:Marteau volcanique
12794:3:2:63:Marteau-tempête ouvragé
10008:2:4:43:Masque blanc de bandit
20593:2:4:45:Masque d'humain solide
20585:2:4:45:Masque d'humaine solide
20595:2:4:45:Masque d'orc solide
20587:2:4:45:Masque d'orque solide
20584:2:4:45:Masque de gnome solide (F)
20592:2:4:45:Masque de gnome solide (H)
20598:2:4:45:Masque de mort-vivant solide
20590:2:4:45:Masque de morte-vivante solide
20591:2:4:45:Masque de nain solide
20583:2:4:45:Masque de naine solide
20596:2:4:45:Masque de tauren solide
20588:2:4:45:Masque de taurène solide
20597:2:4:45:Masque de troll solide
20589:2:4:45:Masque de trollesse solide
8201:2:4:44:Masque du grand vaudou
10025:2:4:49:Masque en tisse-ombre
191313:1:0:1:Masque funéraire
20586:2:4:45:Masque solide d’Elfe de la nuit (femme)
20594:2:4:45:Masque solide d’Elfe de la nuit (homme)
852:1:2:14:Masse
1913:2:2:12:Masse cloutée
2848:2:2:22:Masse en bronze
2844:1:2:9:Masse en cuivre
1197:1:2:15:Masse géante
3491:2:2:25:Masse lourde en bronze
766:1:2:7:Masse à ailettes
13842:1:15:25:Matin automnal/hivernal
13846:1:15:25:Matin printanier/estival
2524:1:2:34:Matraque
17716:1:0:38:Maître-neige 9000
23578:1:0:59:McWeaksauce allégée
23579:1:0:55:McWeaksauce classique
6307:1:15:1:Message dans une bouteille
215458:1:15:1:Message joint
215459:1:15:1:Message joint
215460:1:15:1:Message joint
215456:1:15:1:Message roussi
279944:1:0:4:Meule à aiguiser
10498:1:7:35:Micro-ajusteur gyromatique
19960:1:12:1:Miel cristallisé
4395:1:0:39:Mine gobeline
2775:2:7:10:Minerai d'argent
3340:1:12:22:Minerai d'incendicite
5833:1:12:1:Minerai d'Indurium
2776:2:7:25:Minerai d'or
18562:4:7:60:Minerai d'élémentium
2771:1:7:20:Minerai d'étain
2770:1:7:10:Minerai de cuivre
2772:1:7:30:Minerai de fer
219401:1:15:25:Minerai de fer froid
3858:1:7:40:Minerai de mithril
4278:1:12:1:Minerai de pierre de sang inférieur
11099:1:7:55:Minerai de sombrefer
11370:1:7:50:Minerai de sombrefer
10620:1:7:40:Minerai de thorium
248815:1:7:60:Minerai de thorium lourd
7911:2:7:40:Minerai de vrai-argent
219486:2:15:50:Minerai d’astrargent
250065:1:0:45:Mini-burgers de cerf savoureux
19450:1:15:35:Mini-maison de jubelin
268502:1:15:30:Minuscule dragonnet de bronze
268503:1:15:30:Minuscule dragonnet d’azur
8499:1:15:30:Minuscule jeune dragonnet cramoisi
8498:1:15:30:Minuscule jeune dragonnet d'émeraude
22765:1:15:1:Missive moisie
2139:1:2:3:Miséricorde
12248:2:2:34:Miséricorde audacieuse
250616:2:2:57:Miséricorde audacieuse
6202:2:4:13:Mitaines blindées
277030:2:4:11:Mitaines mêle-vent azur
277006:2:4:11:Mitaines mêle-vent nuageuses
15008:1:4:10:Mitaines primordiales
16009:2:4:58:Modulateur d'amplification vocale
4363:1:7:13:Modulateur en cuivre
18779:3:12:60:Moitié inférieure de La Forge d'armure pour les experts : volume I
18781:3:12:60:Moitié inférieure de La Forge d'armure pour les experts : volume II
18783:3:12:60:Moitié inférieure de La Forge d'armure pour les experts : volume III
18780:3:12:60:Moitié supérieure de La Forge d'armure pour les experts : volume I
18782:3:12:60:Moitié supérieure de La Forge d'armure pour les experts : volume II
18784:3:12:60:Moitié supérieure de La Forge d'armure pour les experts : volume III
12804:1:7:55:Mojo puissant
19943:1:7:60:Mojo écrasant
22284:1:15:1:Monceau de cartes
4393:2:4:37:Monocle d'artisan
278423:2:2:1:Monstre – Pioche de minage
14062:1:15:40:Monture kodo
4540:1:0:5:Morceau de pain rassis
769:1:7:5:Morceau de viande de sanglier
203786:1:0:1:Morceau inférieur droit de carte
203787:1:0:1:Morceau inférieur gauche de carte
203784:1:0:1:Morceau supérieur droit de carte
203785:1:0:1:Morceau supérieur gauche de carte
22525:1:12:1:Morceaux de démon des cryptes
22528:1:12:1:Morceaux de sombrefer
189427:1:15:1:More Raid Consumables
4606:1:0:25:Morilles spongieuses
1352:1:12:22:Mortier de crâne craquelé
10577:1:4:41:Mortier des gobelins
260802:1:4:39:Mortier en bronze Ev-Lan
4403:1:0:33:Mortier portable en bronze
4594:1:0:35:Morue rochécaille
6362:1:7:35:Morue rochécaille crue
23055:1:7:1:Mot de dégel
273130:2:15:60:Moteur de la non-mort
219399:1:15:25:Mousse des cauchemars
17403:1:0:15:Mousseux de Gentepression
3358:1:7:37:Moustache de Khadgar
19293:1:2:55:Mouton de l'an dernier
260800:1:0:35:Mouton de sécurité
19292:1:2:34:Mouton du mois dernier
4384:1:0:30:Mouton explosif
5349:1:0:5:Muffin invoqué
15301:1:4:13:Mules du grizzly
4321:2:4:28:Mules en soie d'araignée
254013:2:4:36:Mules terrestres en soie
210138:1:0:1:Munition de Sombrefer
205995:1:0:1:Musc de chien de prairie
208607:1:0:1:Musc de daim
208180:1:0:1:Musc de lapin
6280:1:12:1:Musty Missive
204907:1:15:1:Mâchoire de loup
207973:1:15:1:Mâchoire de molosse
260801:1:7:39:Mèche ignifugée Ev-Lan
13326:4:15:60:Mécanotrotteur blanc Mod A
18773:4:15:60:Mécanotrotteur blanc rapide
8595:3:15:40:Mécanotrotteur bleu
13327:4:15:60:Mécanotrotteur bleu clair Mod A
13322:3:15:40:Mécanotrotteur brut
18774:4:15:60:Mécanotrotteur jaune rapide
8563:3:15:40:Mécanotrotteur rouge
13324:3:15:40:Mécanotrotteur rouge & bleu
13321:3:15:40:Mécanotrotteur vert
18772:4:15:60:Mécanotrotteur vert rapide
13323:3:15:40:Mécanotrotteur violet
12845:1:12:1:Médaillon de foi
7740:1:12:1:Médaillon de Gni'kiv
20422:1:12:1:Médaillon de statut de sectateur du crépuscule
11415:1:0:55:Mélange de baies
12238:1:0:15:Mérou de Sombrivage
279959:1:0:60:Métier à tisser
18300:1:0:65:Nectar d'Hyjal
1708:1:0:35:Nectar sucré
260828:2:4:60:Nitro-survolteurs SUR-T
2688:1:0:1:Noisette
282419:1:12:1:Note chiffonnée
10839:1:15:1:Note cristallisée
10840:1:15:1:Note cristallisée
274077:1:12:1:Note de Mason
208086:1:15:1:Note de service écarlate urgente falsifiée
282421:1:12:1:Note gribouillée
6276:1:12:1:Note moisie
282422:1:12:1:Note simple
21142:1:15:1:Note trouvée sur le bureau du seigneur Victor Nefarius
11109:1:0:5:Nourriture spéciale pour poulet
17010:3:7:60:Noyau de feu
17011:3:7:60:Noyau de lave
7075:1:7:45:Noyau de terre
22527:1:12:1:Noyau des éléments
13845:1:15:25:Nuit automnale/hivernale
13849:1:15:25:Nuit printannière/estivale
135548:1:4:1:Objet de jambes – IU de transmogrification
135549:1:4:1:Objet de mains – IU de transmogrification
135550:1:4:1:Objet de pieds – IU de transmogrification
135522:1:4:1:Objet de torse – IU de transmogrification
213427:2:15:40:Objet recyclé sali
9308:1:12:1:Objet sali
15997:2:6:57:Obus en thorium
260815:1:7:57:Obus Ev-Lan
5079:2:4:40:Oeil de basilic Oeil-de-glace
11404:1:12:1:Oeil de chauve-souris maléfique
730:1:7:11:Oeil de murloc
6811:1:0:20:Oeil de poisson aquadynamique
818:2:7:15:Oeil de tigre
1210:2:7:20:Oeil ténébreux
11111:1:12:37:Oeuf brisé de Fée fléchetteuse
11474:1:15:47:Oeuf de Fée fléchetteuse
20371:1:15:20:Oeuf de murloc bleu
22114:1:15:20:Oeuf de murloc rose
3685:1:7:22:Oeuf de raptor
18963:1:15:20:Oeuf de tortue albinos
18964:1:15:20:Oeuf de tortue caouanne
18965:1:15:20:Oeuf de tortue imbriquée
18966:1:15:20:Oeuf de tortue lyre
18967:1:15:20:Oeuf de tortue olivâtre
12207:1:7:45:Oeuf géant
6888:1:0:10:Oeufs aux herbes
732:1:12:9:Okra
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
3665:1:0:25:Omelette au goût étrange
250080:1:0:15:Omelette de petit déjeuner
238639:1:0:65:Omelette du Lever de soleil
12218:1:0:45:Omelette monstrueuse
219444:1:15:40:Oniracine
9360:1:0:1:Or de Cuergo
9361:1:0:1:Or de Cuergo avec un ver
15944:2:4:12:Orbe ancestral
15987:2:4:61:Orbe astral
15912:2:4:23:Orbe de boucanier
15926:2:4:17:Orbe de lieur de sort
12811:2:7:60:Orbe de piété
4838:2:4:26:Orbe de puissance
15980:2:4:46:Orbe de Sombrebrume
7556:2:4:40:Orbe du crépuscule
15966:2:4:54:Orbe du voile vénéneux
4836:2:4:28:Orbe ignifugé
15938:2:4:58:Orbe mystique
15929:2:4:37:Orbe nocturne
15969:2:4:10:Orbe perlé
15988:2:4:63:Orbe resplendissant
9800:2:4:29:Orbe sylvestre
15977:2:4:37:Orbe vital
8483:1:12:1:Outre de Bat-le-désert
2596:1:0:15:Outre de bière naine
2447:1:7:5:Pacifique
22176:1:15:1:Pain artisanal
8076:1:0:55:Pain au lait invoqué
252028:1:0:5:Pain aux aérelles frais
278119:1:0:5:Pain beurre
4601:1:0:45:Pain de banane doux
4542:1:0:25:Pain de maïs moelleux
8075:1:0:45:Pain de route invoqué
13935:1:0:55:Pain de saumon
1114:1:0:25:Pain de seigle invoqué
1113:1:0:15:Pain invoqué
1487:1:0:35:Pain noir invoqué
4541:1:0:15:Pain sorti du four
4544:1:0:35:Pain épicé de Mulgore
18777:4:15:60:Palefroi bai rapide
18778:4:15:60:Palefroi blanc rapide
22529:1:12:1:Palme sauvage
2413:1:15:40:Palomino
5524:1:7:20:Palourde à coque épaisse
7973:1:7:40:Palourde à large bouche
5525:1:0:10:Palourdes bouillies
5527:1:0:25:Palourdes gobelines
250066:1:0:55:Pamplona d’envergure
22296:1:15:1:Panier de fleurs
277508:1:15:20:Panier de louveteau des prairies
8485:1:15:20:Panier à chat (Bombay)
8489:1:15:20:Panier à chat (chaton blanc)
11903:1:15:40:Panier à chat (chaton corrompu)
8486:1:15:20:Panier à chat (Cornouailles)
8490:1:15:20:Panier à chat (Siamois)
8488:1:15:20:Panier à chat (tigré argent)
8491:1:15:20:Panier à chat (tigré noir)
8487:1:15:20:Panier à chat (tigré orange)
12422:2:4:60:Pansière impériale
7046:2:4:28:Pantalon azur en soie
250544:2:4:49:Pantalon brillant en mithril
2437:1:4:50:Pantalon brodé
2431:1:4:37:Pantalon brun-roux
216696:2:4:1:Pantalon caché
15087:2:4:58:Pantalon corrompu en cuir
5962:2:4:32:Pantalon de gardien
8193:2:4:46:Pantalon de la nuit
10035:1:4:35:Pantalon de smoking
6835:1:4:23:Pantalon de smoking noir
4261:2:4:10:Pantalon de Solliden
279254:4:4:65:Pantalon de Sylvancienne
4831:2:4:26:Pantalon de traque
8202:2:4:47:Pantalon du grand vaudou
4317:2:4:25:Pantalon du phénix
2852:2:4:10:Pantalon en anneaux de cuivre
2146:1:4:27:Pantalon en cuir bouilli
2465:1:4:37:Pantalon en cuir clouté
2303:2:4:10:Pantalon en cuir cousu main
2126:1:4:5:Pantalon en cuir craquelé
4242:2:4:15:Pantalon en cuir estampé
798:1:4:10:Pantalon en cuir grossier
7282:2:4:19:Pantalon en cuir léger
2472:1:4:50:Pantalon en cuir renforcé
7280:2:4:11:Pantalon en cuir robuste
209:1:4:5:Pantalon en cuir sale
845:1:4:17:Pantalon en cuir tanné
237:1:4:22:Pantalon en cuir traité
14107:2:4:55:Pantalon en gangrétoffe
4316:2:4:22:Pantalon en laine épaisse
10045:1:4:7:Pantalon en lin écru
848:1:4:17:Pantalon en mailles
4800:2:4:23:Pantalon en mailles de la puissance
252478:2:4:56:Pantalon en suédine bleue
14144:2:4:58:Pantalon en tisse-fantôme
10002:2:4:42:Pantalon en tisse-ombre
838:1:4:17:Pantalon en toile renforcée
286:1:4:22:Pantalon en écailles
14045:2:4:56:Pantalon en étoffe cendrée
14104:2:4:58:Pantalon en étoffe lumineuse
2120:1:4:5:Pantalon en étoffe légère
194:1:4:5:Pantalon en étoffe rapiécé
13865:2:4:57:Pantalon en étoffe runique
201:1:4:22:Pantalon en étoffe épaisse
10010:2:4:44:Pantalon en étoffe-tempête
2372:1:4:10:Pantalon endommagé en cuir
3263:1:4:3:Pantalon entoilé
4343:2:4:10:Pantalon marron en lin
2159:1:4:27:Pantalon matelassé
277032:2:4:12:Pantalon mêle-vent azur
277008:2:4:12:Pantalon mêle-vent nuageux
5961:2:4:23:Pantalon noir en cuir
9999:2:4:41:Pantalon noir en tisse-mage
252560:2:4:61:Pantalon ouvragé en cuir
10009:2:4:43:Pantalon rouge en tisse-mage
15095:2:4:60:Pantalon runique en cuir
3473:2:4:13:Pantalon runique en cuivre
15057:3:4:55:Pantalon tempétueux
13871:2:4:56:Pantalon tisse-givre
2366:1:4:10:Pantalon tissé
794:1:4:10:Pantalon tricoté
5958:2:4:21:Pantalon élégant en cuir
5047:1:0:40:Papier d'emballage au crâne
21830:1:15:1:Papier d'emballage vide
5048:1:0:5:Papier d'emballage à ruban bleu
17303:1:0:5:Papier d'emballage à ruban bleu
5042:1:0:5:Papier d'emballage à ruban rouge
17304:1:0:5:Papier d'emballage à ruban vert
17307:1:0:5:Papier d'emballage à ruban violet
249432:2:7:45:Papier de verre
6277:1:12:1:Papier moisi
18154:1:0:1:Papier à lettre Blizzard
22058:1:15:1:Papier à lettres de la St-Valentin
17302:1:0:5:Paquet cadeau à ruban bleu
17305:1:0:5:Paquet cadeau à ruban vert
17308:1:0:5:Paquet cadeau à ruban violet
22293:1:15:1:Paquet de cartes
12445:1:12:1:Paquet de Felnok
260810:1:4:50:Parachute jetable SUR-T
20518:1:12:1:Parchemin : Création d'un blason de signal
20526:1:12:1:Parchemin : Création d'un blason de signal
20527:1:12:1:Parchemin : Création d'un blason de signal
20528:1:12:1:Parchemin : Création d'un blason de signal
20540:1:12:1:Parchemin : Création d'un sceptre de signal
20542:1:12:1:Parchemin : Création d'un sceptre de signal
20543:1:12:1:Parchemin : Création d'un sceptre de signal
20544:1:12:1:Parchemin : Création d'un sceptre de signal
20531:1:12:1:Parchemin : Création d'une chevalière de signal
20532:1:12:1:Parchemin : Création d'une chevalière de signal
20533:1:12:1:Parchemin : Création d'une chevalière de signal
20535:1:12:1:Parchemin : Création d'une chevalière de signal
282423:1:12:1:Parchemin consacré
3012:1:0:20:Parchemin d'Agilité
1477:1:0:35:Parchemin d'Agilité II
4425:1:0:50:Parchemin d'Agilité III
10309:1:0:65:Parchemin d'Agilité IV
1180:1:0:15:Parchemin d'endurance
1711:1:0:30:Parchemin d'Endurance II
4422:1:0:45:Parchemin d'Endurance III
10307:1:0:60:Parchemin d'Endurance IV
1181:1:0:10:Parchemin d'esprit
1712:1:0:25:Parchemin d'Esprit II
4424:1:0:40:Parchemin d'Esprit III
10306:1:0:55:Parchemin d'Esprit IV
955:1:0:15:Parchemin d'intelligence
2290:1:0:30:Parchemin d'Intelligence II
4419:1:0:45:Parchemin d'intelligence III
10308:1:0:60:Parchemin d'Intelligence IV
215257:1:0:15:Parchemin de compréhension
275067:2:0:15:Parchemin de couteau gelé imprégné
217495:1:0:25:Parchemin de cryo-détonation
277499:1:0:55:Parchemin de cryo-détonation supérieure
213551:1:0:15:Parchemin de déplacement contrôlé
277492:1:0:40:Parchemin de déverrouillage de Khadgar
277493:1:0:40:Parchemin de familier chat
277483:1:0:25:Parchemin de familier grenouille
275069:1:0:15:Parchemin de familier rat
274947:2:0:15:Parchemin de flamme inférieure imprégnée
954:1:0:20:Parchemin de force
2289:1:0:35:Parchemin de Force II
4426:1:0:50:Parchemin de force III
10310:1:0:65:Parchemin de Force IV
220792:2:0:15:Parchemin de guérison spatiale
3707:1:12:1:Parchemin de Nagaz
213548:1:0:40:Parchemin de passage liminal
3013:1:0:10:Parchemin de Protection
1478:1:0:25:Parchemin de Protection II
4421:1:0:40:Parchemin de Protection III
10305:1:0:55:Parchemin de Protection IV
213549:1:0:15:Parchemin de pêche arcanique
289088:1:0:30:Parchemin de robustesse infinie
211800:1:0:15:Parchemin de réintégration
289330:1:0:30:Parchemin de vitesse infinie
6496:1:12:1:Parchemin détaillé
6495:1:12:1:Parchemin détrempé
228227:4:0:60:Parchemin d’apprenti de puissance accablante
277503:2:0:55:Parchemin d’imprégnation de brise-sort
277488:2:0:25:Parchemin d’imprégnation de couteau de glace
277497:2:0:40:Parchemin d’imprégnation de flamme
277500:2:0:55:Parchemin d’imprégnation de flamme supérieure
277487:2:0:25:Parchemin d’imprégnation de flammosphère
277486:2:0:25:Parchemin d’imprégnation de frappe
277485:2:0:25:Parchemin d’imprégnation de givre
277501:2:0:55:Parchemin d’imprégnation de givre supérieur
277494:2:0:40:Parchemin d’imprégnation de justesse
277498:2:0:40:Parchemin d’imprégnation de lame de mana
277502:2:0:55:Parchemin d’imprégnation de précision
277496:2:0:40:Parchemin d’imprégnation de torvegivre
277495:2:0:40:Parchemin d’imprégnation de vivacité
277489:2:0:25:Parchemin d’imprégnation d’étincelle
213564:1:0:15:Parchemin d’évocation mineure
6494:1:12:1:Parchemin griffonné
6278:1:12:1:Parchemin moisi
6490:1:12:1:Parchemin noir
6492:1:12:1:Parchemin noirci
6489:1:12:1:Parchemin passé
282420:1:12:1:Parchemin plié
3790:1:4:35:Parchemin relique consacré
6491:1:12:1:Parchemin rugueux
216880:1:0:40:Parchemin troll déchiffré
216879:1:0:40:Parchemin troll mystérieux
6493:1:12:1:Parchemin usé
10648:1:7:40:Parchemin vierge
6620:1:12:1:Parchemin élaboré
213543:1:0:30:Parchemin : BONHOMME
211786:1:0:10:Parchemin : CHAP BALK WELLES
213545:1:0:30:Parchemin : CHUTE D’AGUERRI
213547:1:0:30:Parchemin : ELLUQE PÉÉE
211785:1:0:10:Parchemin : FIGERF
211780:1:0:10:Parchemin : KWYJIBO
211787:1:0:10:Parchemin : LOWER PING WHOMEVER
281017:1:0:50:Parchemin : NAÉF CORCOINCH
211854:1:0:20:Parchemin : OMIT KESA
281018:1:0:50:Parchemin : RANSTOR TEULÀ TRES
281016:1:0:50:Parchemin : RIÉLFÉCH RIATF AC
211855:1:0:20:Parchemin : STHENIC LUNATE
281015:1:0:50:Parchemin : STIONE DUPPLS
213546:1:0:30:Parchemin : TAGADAAA
211853:1:0:20:Parchemin : VOCE WELL
211784:1:0:20:Parchemin : WUBBA WUBBA
213544:1:0:30:Parchemin : ZOO ET DU KAFÊ
4376:1:0:25:Pare-flammes
4386:1:0:31:Pare-glace
287416:1:0:10:Part de cheesecake de Truskis
15872:2:0:55:Passe-partout en arcanite
15869:2:0:20:Passe-partout en argent
15870:2:0:30:Passe-partout en or
15871:2:0:40:Passe-partout en vrai-argent
4538:1:0:25:Pastèque claquevigne
5057:1:0:5:Pastèque mûre
15773:2:9:61:Patron : Armure corrompue en cuir
7450:2:9:35:Patron : Armure de dragonnet vert
4299:2:9:35:Patron : Armure de gardien
15776:2:9:61:Patron : Armure runique en cuir
15753:3:9:57:Patron : Armure tempétueuse
7090:2:9:33:Patron : Armure verte en soie
18731:1:9:30:Patron : Balle en cuir lourd
15744:2:9:56:Patron : Bandeau corrompu en cuir
14498:2:9:59:Patron : Bandeau en étoffe runique
10320:2:9:48:Patron : Bandeau rouge en tisse-mage
10318:1:9:48:Patron : Bicorne d'amiral
8399:2:9:47:Patron : Bottes armées du scorpide
15737:2:9:55:Patron : Bottes chimériques
4352:2:9:35:Patron : Bottes de l'enchanteur
7453:2:9:40:Patron : Bottes de rapidité
14492:2:9:57:Patron : Bottes en gangrétoffe
7452:3:9:40:Patron : Bottes mattes
4345:2:9:19:Patron : Bottes rouges en laine
2406:2:9:15:Patron : Bottes élégantes en cuir
21358:1:9:52:Patron : Bourse d'âme
22307:1:9:45:Patron : Bourse enchantée en tisse-mage
8397:2:9:44:Patron : Brassards armés du scorpide
18949:1:9:31:Patron : Brassards barbares
15728:2:9:53:Patron : Brassards corrompus en cuir
4300:2:9:39:Patron : Brassards de gardien en cuir
15739:2:9:55:Patron : Brassards runiques en cuir
15727:2:9:53:Patron : Broigne en écailles de scorpide épaisses
18519:4:9:62:Patron : Cape changeante
18517:4:9:62:Patron : Cape chromatique
7289:1:9:20:Patron : Cape de dragonnet noir
8388:2:9:46:Patron : Cape de la nuit
5974:2:9:37:Patron : Cape du gardien
8390:2:9:48:Patron : Cape du grand vaudou
4346:2:9:20:Patron : Cape en laine épaisse
6474:1:9:18:Patron : Cape en écailles de déviant
14482:2:9:55:Patron : Cape en étoffe cendrée
14484:2:9:55:Patron : Cape en étoffe lumineuse
4355:1:9:40:Patron : Cape glaciale
8402:2:9:50:Patron : Casque armé du scorpide
4301:3:9:40:Patron : Ceinture barbare
15768:2:9:60:Patron : Ceinture corrompue en cuir
4294:2:9:24:Patron : Ceinture d'homme des collines
4353:2:9:36:Patron : Ceinture de l'araignée
18414:4:9:62:Patron : Ceinture de l'archimage
4356:2:9:40:Patron : Ceinture de l'étoile
4298:3:9:34:Patron : Ceinture du gardien
14635:1:9:37:Patron : Ceinture en cuir cloutée de gemmes
13288:2:9:33:Patron : Ceinture en peau de raptor
14473:2:9:53:Patron : Ceinture en tisse-fantôme
6476:2:9:23:Patron : Ceinture en écailles de déviant
15743:2:9:56:Patron : Ceinture en écailles de scorpide épaisses
15745:2:9:56:Patron : Ceinture runique en cuir
20548:3:9:62:Patron : Ceinture runique ténébreuse
7086:2:9:39:Patron : Ceinture terrestre en soie
8384:3:9:40:Patron : Chapeau de cuir confortable
4351:2:9:34:Patron : Chaperon des ombres
14496:2:9:58:Patron : Chaperon en gangrétoffe
6390:2:9:24:Patron : Chemise bleue d'apparat
10321:1:9:48:Patron : Chemise de smoking
10314:1:9:46:Patron : Chemise lavande en tisse-mage
10311:1:9:44:Patron : Chemise orange martiale
10317:1:9:47:Patron : Chemise rose en tisse-mage
6391:2:9:24:Patron : Chemise verte d'apparat
17724:1:9:38:Patron : Chemise verte de fête
18265:3:9:64:Patron : Couvre-bras Coeur-de-braise
8395:2:9:44:Patron : Cuirasse armée du scorpide
15760:3:9:58:Patron : Cuirasse en plumacier
15751:1:9:57:Patron : Cuirasse en écailles de dragon bleu
15759:1:9:58:Patron : Cuirasse en écailles de dragon noir
15726:1:9:52:Patron : Cuirasse en écailles de dragon vert
15771:3:9:60:Patron : Cuirasse vivante
15749:2:9:57:Patron : Cuirasse volcanique
14509:3:9:62:Patron : Diadème en étoffe lunaire
8400:2:9:48:Patron : Epaulières armées du scorpide
7084:2:9:38:Patron : Epaulières cramoisies en soie
7085:2:9:38:Patron : Epaulières d'azur
14508:2:9:62:Patron : Epaulières en gangrétoffe
15735:1:9:54:Patron : Epaulières en plumacier
15763:3:9:59:Patron : Epaulières en écailles de dragon bleu
15770:3:9:60:Patron : Epaulières en écailles de dragon noir
15774:2:9:61:Patron : Epaulières en écailles de scorpide épaisses
14507:3:9:61:Patron : Epaulières en étoffe lunaire
14504:2:9:61:Patron : Epaulières en étoffe runique
4296:2:9:28:Patron : Epaulières noires en cuir
4347:2:9:24:Patron : Epaulières renforcées en laine
10315:2:9:47:Patron : Epaulières rouges en tisse-mage
15777:2:9:62:Patron : Epaulières runiques en cuir
15764:3:9:59:Patron : Epaulières tempétueuses
15734:1:9:54:Patron : Epaulières vivantes
15775:2:9:61:Patron : Epaulières volcaniques
15758:1:9:58:Patron : Gantelets diablosaures
15738:2:9:55:Patron : Gantelets en écailles de scorpide épaisses
15731:2:9:54:Patron : Gantelets runiques en cuir
8398:2:9:45:Patron : Gants armés du scorpide
4297:2:9:30:Patron : Gants barbare
7361:2:9:26:Patron : Gants d'herboriste
7363:2:9:28:Patron : Gants de chapardeur
14511:4:9:62:Patron : Gants de maîtrise magique
15761:2:9:59:Patron : Gants de sabre-de-givre
7091:2:9:30:Patron : Gants de vraie foi
17722:2:9:38:Patron : Gants du Grandpère
4348:2:9:25:Patron : Gants du phénix
7290:1:9:24:Patron : Gants en cuir de dragonnet rouge
18239:1:9:40:Patron : Gants en peau d'ombre
14477:2:9:54:Patron : Gants en tisse-fantôme
6475:1:9:21:Patron : Gants en écailles de déviant
14476:2:9:54:Patron : Gants en étoffe cendrée
14479:2:9:54:Patron : Gants en étoffe lumineuse
7360:2:9:25:Patron : Gants noirs en cuir
10312:2:9:45:Patron : Gants rouges en tisse-mage
21548:3:9:62:Patron : Gants tempétueux
7364:2:9:29:Patron : Gants terrestres lourds
14474:2:9:53:Patron : Gants tisse-givre
2408:2:9:15:Patron : Gants élégants en cuir
6270:1:9:12:Patron : Gilet bleu en lin
15755:2:9:58:Patron : Gilet chimérique
4293:2:9:20:Patron : Gilet d'homme des collines en cuir
14480:2:9:55:Patron : Gilet en tisse-fantôme
14471:2:9:52:Patron : Gilet en étoffe cendrée
14501:3:9:60:Patron : Gilet en étoffe lunaire
6710:2:9:18:Patron : Gilet Lueur-de-lune
6271:2:9:12:Patron : Gilet rouge en lin
10300:2:9:43:Patron : Gilet rouge en tisse-mage
22309:2:9:65:Patron : Grand sac d'enchantement
14512:4:9:62:Patron : Habit de vraie foi
15742:1:9:55:Patron : Harnais de l'ours de guerre
13287:2:9:33:Patron : Harnais en peau de raptor
8401:2:9:49:Patron : Jambières armées du scorpide
15746:2:9:56:Patron : Jambières chimériques
15747:2:9:57:Patron : Jambières de sabre-de-givre
15772:3:9:60:Patron : Jambières diablosaures
7449:2:9:33:Patron : Jambières en cuir mat
14485:2:9:55:Patron : Jambières en tisse-sorcier
15781:3:9:62:Patron : Jambières en écailles de dragon noir
15733:3:9:54:Patron : Jambières en écailles de dragon vert
15748:2:9:57:Patron : Jambières en écailles de scorpide épaisses
14497:3:9:58:Patron : Jambières en étoffe lunaire
15752:3:9:57:Patron : Jambières vivantes
15732:2:9:54:Patron : Jambières volcaniques
10316:2:9:24:Patron : Kilt coloré
7092:2:9:29:Patron : Mains des ténèbres
10301:2:9:43:Patron : Masque blanc de bandit
8387:2:9:44:Patron : Masque du grand vaudou
10463:2:9:49:Patron : Masque en tisse-ombre
4350:2:9:28:Patron : Mules en soie d'araignée
15757:2:9:58:Patron : Pantalon corrompu en cuir
10323:1:9:49:Patron : Pantalon de smoking
8389:2:9:48:Patron : Pantalon du grand vaudou
4349:2:9:25:Patron : Pantalon du phénix
7288:2:9:11:Patron : Pantalon en cuir robuste
14495:2:9:58:Patron : Pantalon en tisse-fantôme
14490:2:9:56:Patron : Pantalon en étoffe cendrée
14494:2:9:58:Patron : Pantalon en étoffe lumineuse
14491:2:9:57:Patron : Pantalon en étoffe runique
10302:2:9:43:Patron : Pantalon rouge en tisse-mage
15765:2:9:60:Patron : Pantalon runique en cuir
15741:1:9:55:Patron : Pantalon tempétueux
14489:2:9:56:Patron : Pantalon tisse-givre
5972:2:9:21:Patron : Pantalon élégant en cuir
18518:4:9:62:Patron : Peau du Fauve
2407:2:9:13:Patron : Pourpoint blanc en cuir
4354:3:9:37:Patron : Riche chemise violette en soie
10325:1:9:50:Patron : Robe blanche de mariée
6272:1:9:14:Patron : Robe bleue en lin
6275:1:9:23:Patron : Robe d'adepte supérieur
5773:2:9:30:Patron : Robe d'Arcana
14513:4:9:62:Patron : Robe de l'archimage
8386:2:9:43:Patron : Robe du grand vaudou
14514:4:9:62:Patron : Robe du Vide
14506:2:9:61:Patron : Robe en gangrétoffe
14500:2:9:60:Patron : Robe en tisse-sorcier
14478:2:9:54:Patron : Robe en étoffe lumineuse
18487:1:9:61:Patron : Robe en étoffe lunaire
2601:2:9:21:Patron : Robe grise en laine
2598:2:9:10:Patron : Robe rouge en lin
14467:2:9:51:Patron : Robe tisse-givre
21371:3:9:60:Patron : Sac en gangrétoffe du Magma
5083:2:9:11:Patron : Sac en peau de kodo
14499:2:9:60:Patron : Sac en étoffe lunaire
14468:1:9:52:Patron : Sac en étoffe runique
22308:1:9:55:Patron : Sac enchanté en étoffe runique
5775:2:9:37:Patron : Sac noir en soie
5772:1:9:23:Patron : Sac rouge en laine
5771:1:9:14:Patron : Sac rouge en lin
14510:3:9:62:Patron : Sac sans fond
4292:2:9:19:Patron : Sac vert en laine
5774:2:9:35:Patron : Sac vert en soie
6274:1:9:20:Patron : Salopette bleue
20576:1:9:20:Patron : Tunique de dragonnet noir
15779:2:9:62:Patron : Tunique de sabre-de-givre
14470:2:9:52:Patron : Tunique en étoffe runique
2409:2:9:20:Patron : Tunique noire en cuir
14466:2:9:51:Patron : Tunique tisse-givre
14505:2:9:61:Patron : Turban en tisse-sorcier
10326:1:9:50:Patron : Veste de smoking
20547:3:9:62:Patron: Bottes runiques ténébreuses
20546:3:9:62:Patron: Jambières runiques ténébreuses
252771:3:9:20:Patron : armure de bagarreur en cuir
252775:3:9:20:Patron : armure de chevaucheur de tempête en cuir
252773:3:9:20:Patron : armure de défenseur en cuir
252892:4:9:60:Patron : armure de l’aube
252776:3:9:20:Patron : armure de sagesse en cuir
252772:3:9:20:Patron : armure de trappeur en cuir
252774:3:9:20:Patron : armure totémique en cuir
238303:3:9:1:Patron : attache d’augure écarlate
238306:3:9:1:Patron : bandana d’infiltrateur écarlate
254684:2:9:48:Patron : bandeau en étoffe-tempête
252879:2:9:57:Patron : bottes corrompues en cuir
238321:3:9:1:Patron : bottes de chasseur écarlate
217254:2:9:35:Patron : Bottes de l’enchanteur
252897:3:9:45:Patron : bottes de mande-ciel en mailles
252899:3:9:45:Patron : bottes de soigneur en mailles
252896:3:9:45:Patron : bottes de traqueur en mailles
252898:3:9:45:Patron : bottes d’escarmouche en mailles
252804:2:9:27:Patron : bottes d’homme des collines en cuir
254130:2:9:60:Patron : bottes en tisse-fantôme
254094:2:9:54:Patron : bottes en tisse-terrestre
252936:2:9:60:Patron : bottes en écailles de scorpide chargées
252908:2:9:51:Patron : bottes en écailles de scorpide souples
252928:2:9:56:Patron : bottes en écailles de scorpide épaisses
254686:2:9:50:Patron : bottes en étoffe-tempête
252764:3:9:15:Patron : bottes lueur-de-lune
252762:3:9:15:Patron : bottes noires en cuir
252865:2:9:53:Patron : bottes ouvragées en cuir
251751:3:9:1:Patron : brassards adaptables de soins de gelées
251739:3:9:1:Patron : brassards adaptables d’abattage de bêtes
217264:2:9:39:Patron : Brassards de gardien en cuir
238309:3:9:1:Patron : brassards d’infiltrateur écarlate
252888:2:9:60:Patron : brassards en suédine bleue
252927:2:9:56:Patron : brassards en écailles de scorpide chargées
252916:2:9:55:Patron : brassards en écailles de scorpide souples
252885:2:9:59:Patron : brassards ouvragés en cuir
238314:3:9:1:Patron : camail de chasseur écarlate
228276:4:9:62:Patron : Cape changeante ouvragée
227910:4:9:62:Patron : Cape chromatique brillante
217258:1:9:33:Patron : Capuche d’enchanteur
252814:3:9:30:Patron : casque de bagarreur en cuir
252818:3:9:30:Patron : casque de chevaucheur de tempête en cuir
252816:3:9:30:Patron : casque de défenseur en cuir
252819:3:9:30:Patron : casque de sagesse en cuir
252815:3:9:30:Patron : casque de trappeur en cuir
252817:3:9:30:Patron : casque totémique en cuir
251743:3:9:1:Patron : ceinture adaptable de destruction de dinosaures
251752:3:9:1:Patron : Ceinture adaptable de soins de gelées
228477:4:9:62:Patron : Ceinture brodée de l’archimage
252827:3:9:35:Patron : ceinture de furtivité en cuir
252829:3:9:35:Patron : ceinture de garde en cuir
217266:3:9:34:Patron : Ceinture de gardien
252831:3:9:35:Patron : ceinture de mande-ciel en cuir
252826:3:9:35:Patron : ceinture de rôdeur en cuir
252832:3:9:35:Patron : ceinture de soigneur en cuir
252828:3:9:35:Patron : ceinture de traqueur en cuir
252830:3:9:35:Patron : ceinture d’escarmouche en cuir
238311:3:9:1:Patron : ceinture d’infiltrateur écarlate
252886:2:9:59:Patron : ceinture en suédine bleue
252909:2:9:51:Patron : ceinture en écailles de scorpide chargées
252929:2:9:56:Patron : ceinture en écailles de scorpide souples
252858:2:9:52:Patron : ceinture ouvragée en cuir
217249:2:9:39:Patron : Ceinture terrestre en soie
251755:3:9:1:Patron : ceinturon adaptable de soins des bêtes
252890:2:9:60:Patron : chapeau en suédine bleue
238298:3:9:1:Patron : chaperon d’augure écarlate
254136:2:9:61:Patron : chaperon en tisse-fantôme
254016:2:9:37:Patron : chaperon terrestre en soie
238312:3:9:1:Patron : chausses d’infiltrateur écarlate
252844:3:9:45:Patron : chaussures de furtivité en cuir
252845:3:9:45:Patron : chaussures de garde en cuir
252846:3:9:45:Patron : chaussures de mande-ciel en cuir
252843:3:9:45:Patron : chaussures de rôdeur en cuir
252847:3:9:45:Patron : chaussures de soigneur en cuir
238313:3:9:1:Patron : chaussures d’infiltrateur écarlate
252859:2:9:52:Patron : chaussures en suédine bleue
252763:3:9:15:Patron : chaussures en écailles de Murloc
251758:3:9:1:Patron : chaîne adaptable de soins des dinosaures
238316:3:9:1:Patron : chaîne de chasseur écarlate
251737:3:9:1:Patron : corde adaptable de tuerie de gelées
254038:3:9:45:Patron : corde ambrée
254046:3:9:45:Patron : corde dorée
215369:2:9:30:Patron : Corde d’invocatrice
254042:3:9:45:Patron : corde embrasée
254074:2:9:52:Patron : corde en tisse-fantôme
254078:2:9:52:Patron : corde en tisse-terrestre
254044:3:9:45:Patron : corde noire
254048:3:9:45:Patron : corde radieuse
254040:3:9:45:Patron : corde écumeuse
251741:3:9:1:Patron : corselet adaptable de destruction de dinosaures
12728:4:9:63:Patron : cotte de mailles invulnérable
12691:2:9:54:Patron : cotte de mailles Ronce-sauvage
254138:2:9:61:Patron : couronne en tisse-terrestre
252882:2:9:58:Patron : couronne ouvragée en cuir
252891:4:9:60:Patron : couronne vivante
251736:3:9:1:Patron : crispins adaptables de tuerie de gelées
238301:3:9:1:Patron : crispins d’augure écarlate
254132:2:9:60:Patron : crispins en tisse-terrestre
254020:2:9:40:Patron : crispins terrestres en soie
227898:1:9:57:Patron : Cuirasse en écailles de dragon bleu affûtées
227902:1:9:58:Patron : Cuirasse en écailles de dragon noir durcies
228309:1:9:52:Patron : Cuirasse en écailles de dragon vert vivantes
227906:2:9:57:Patron : Cuirasse volcanique ouvragée
253986:3:9:30:Patron : diadème brillant filigrané
253980:3:9:30:Patron : diadème des flammes filigrané
228317:3:9:62:Patron : Diadème en étoffe lunaire incandescent
253976:3:9:30:Patron : diadème immaculé filigrané
253984:3:9:30:Patron : diadème nacré filigrané
253982:3:9:30:Patron : diadème ombreux filigrané
253978:3:9:30:Patron : diadème soyeux filigrané
238315:3:9:1:Patron : espauliers de chasseur écarlate
238319:3:9:1:Patron : fermoir de chasseur écarlate
252868:3:9:55:Patron : gantelets de furtivité en cuir
252869:3:9:55:Patron : gantelets de garde en cuir
252870:3:9:55:Patron : gantelets de mande-ciel en cuir
252919:3:9:55:Patron : gantelets de mande-ciel en mailles
252867:3:9:55:Patron : gantelets de rôdeur en cuir
252871:3:9:55:Patron : gantelets de soigneur en cuir
252921:3:9:55:Patron : gantelets de soigneur en mailles
252918:3:9:55:Patron : gantelets de traqueur en mailles
228119:3:9:58:Patron : Gantelets diablocœur
252920:3:9:55:Patron : gantelets d’escarmouche en mailles
228251:3:9:54:Patron : Gantelets en écailles de dragon vert vivantes
252930:2:9:56:Patron : gantelets en écailles de scorpide chargées
252880:2:9:57:Patron : gantelets ouvragés en cuir
12703:3:9:59:Patron : gantelets tempêtes
254096:3:9:55:Patron : gants ambrés
254104:3:9:55:Patron : gants dorés
238310:3:9:1:Patron : gants d’infiltrateur écarlate
254100:3:9:55:Patron : gants embrasés
252866:2:9:53:Patron : gants en suédine bleue
254076:2:9:52:Patron : gants en tisse-terrestre
217271:1:9:41:Patron : Gants en écailles de tortue
254102:3:9:55:Patron : gants noirs
254106:3:9:55:Patron : gants radieux
254018:2:9:39:Patron : gants terrestres en soie
254098:3:9:55:Patron : gants écumeux
238320:3:9:1:Patron : garde-jambes de chasseur écarlate
238318:3:9:1:Patron : garde-mains de chasseur écarlate.
238317:3:9:1:Patron : garde-poignets de chasseur écarlate
251738:3:9:1:Patron : gilet adaptable d’abattage de bêtes
238308:3:9:1:Patron : gilet d’infiltrateur écarlate
254122:2:9:59:Patron : gilet en tisse-terrestre
252932:2:9:57:Patron : gilet en écailles de scorpide chargées
228316:3:9:60:Patron : Gilet en étoffe lunaire incandescent
254683:2:9:45:Patron : gilet en étoffe-tempête
238300:3:9:1:Patron : habits d’augure écarlate
252894:4:9:60:Patron : heaume de l’ours de guerre
12716:3:9:61:Patron : heaume du grand chef
252938:4:9:60:Patron : heaume en écailles de dragon bleu
252939:4:9:60:Patron : heaume en écailles de dragon noir
252915:2:9:53:Patron : heaume en écailles de scorpide chargées
252931:2:9:57:Patron : heaume en écailles de scorpide souples
253948:3:9:25:Patron : jambières brillantes filigranées
253942:3:9:25:Patron : jambières des flammes filigranées
228120:3:9:60:Patron : Jambières diablocœur
238304:3:9:1:Patron : jambières d’augure écarlate
252895:4:9:60:Patron : jambières en plumacier
254126:2:9:58:Patron : jambières en tisse-terrestre
227903:3:9:62:Patron : Jambières en écailles de dragon noir durcies
252937:4:9:60:Patron : jambières en écailles de dragon rouge
227900:3:9:54:Patron : Jambières en écailles de dragon vert vivantes
252934:2:9:59:Patron : jambières en écailles de scorpide chargées
252940:4:9:60:Patron : jambières en écailles de scorpide immaculées
252914:2:9:53:Patron : jambières en écailles de scorpide souples
228318:3:9:58:Patron : Jambières en étoffe lunaire incandescentes
253938:3:9:25:Patron : jambières immaculées filigranées
253946:3:9:25:Patron : jambières nacrées filigranées
253944:3:9:25:Patron : jambières ombreuses filigranées
253940:3:9:25:Patron : jambières soyeuses filigranées
254000:2:9:35:Patron : jambières terrestres
227908:2:9:54:Patron : Jambières volcaniques ouvragées
251754:3:9:1:Patron : lie-poignets adaptable de soins des bêtes
238299:3:9:1:Patron : mantelet d’augure écarlate
215370:2:9:30:Patron : Mantelet d’invocatrice
254128:2:9:59:Patron : mantelet en tisse-fantôme
254120:2:9:57:Patron : mantelet en tisse-terrestre
217260:2:9:44:Patron : Masque du grand vaudou
238302:3:9:1:Patron : mitaines d’augure écarlate
254002:3:9:35:Patron : mules ambrées
252761:3:9:15:Patron : mules de dragonnet noir
254010:3:9:35:Patron : mules dorées
254006:3:9:35:Patron : mules embrasées
254008:3:9:35:Patron : mules noires
254012:3:9:35:Patron : mules radieuses
254014:2:9:36:Patron : mules terrestres en soie
254004:3:9:35:Patron : mules écumeuses
252792:3:9:25:Patron : pantalon de bagarreur en cuir
252796:3:9:25:Patron : pantalon de chevaucheur de tempête en cuir
252794:3:9:25:Patron : pantalon de défenseur en cuir
252797:3:9:25:Patron : pantalon de sagesse en cuir
252793:3:9:25:Patron : pantalon de trappeur en cuir
252878:2:9:56:Patron : pantalon en suédine bleue
254681:2:9:44:Patron : pantalon en étoffe-tempête
252889:2:9:60:Patron : pantalon ouvragé en cuir
252795:3:9:25:Patron : pantalon totémique en cuir
251742:3:9:1:Patron : poignets adaptables de destruction de dinosaures
251757:3:9:1:Patron : poignets adaptables de soins des dinosaures
254022:3:9:40:Patron : protège-mains ambrés
238307:3:9:1:Patron : protège-épaules d’infiltrateur écarlate
252811:2:9:30:Patron : renfort d’armure lourd mystique
252812:2:9:30:Patron : renfort d’armure lourd énergique
252783:2:9:15:Patron : renfort d’armure moyen mystique
252784:2:9:15:Patron : renfort d’armure moyen énergique
252942:2:9:50:Patron : renfort d’armure robuste énergique
251753:3:9:1:Patron : robe adaptable de soins des bêtes
251735:3:9:1:Patron : robe adaptable de tuerie de gelées
253912:3:9:20:Patron : robe brillante filigranée
217244:1:9:41:Patron : Robe cramoisie en soie
253906:3:9:20:Patron : robe des flammes filigranée
217262:2:9:43:Patron : Robe du grand vaudou
228303:1:9:61:Patron : Robe en étoffe lunaire incandescente
253902:3:9:20:Patron : robe immaculée filigranée
253910:3:9:20:Patron : robe nacrée filigranée
253908:3:9:20:Patron : robe ombreuse filigranée
253904:3:9:20:Patron : robe soyeuse filigranée
251740:3:9:1:Patron : ruban adaptable d’abattage de bêtes
253668:2:9:10:Patron : sac de composants en laine
253665:2:9:5:Patron : sac de composants en lin
254140:2:9:60:Patron : sac de composants sans fond
228121:2:9:60:Patron : Sac en étoffe runique renforcé de cuir
228993:3:9:62:Patron : Sac sans fond
238305:3:9:1:Patron : semelles d’augure écarlate
252935:2:9:60:Patron : solerets en écailles de scorpide souples
251750:3:9:1:Patron : tunique adaptable de soins de gelées
251756:3:9:1:Patron : tunique adaptable de soins des dinosaures
252893:4:9:60:Patron : tunique grumegueule
253888:3:9:15:Patron : écharpe ardente de novice
253886:3:9:15:Patron : écharpe d’arcaniste novice
252887:2:9:60:Patron : épaulettes ouvragées en cuir
252884:2:9:59:Patron : épaulières corrompues en cuir
217251:2:9:38:Patron : Épaulières cramoisies en soie
252881:2:9:57:Patron : épaulières en suédine bleue
227899:3:9:59:Patron : Épaulières en écailles de dragon bleu affûtées
227904:3:9:60:Patron : Épaulières en écailles de dragon noir durcies
252917:2:9:55:Patron : épaulières en écailles de scorpide chargées
252926:2:9:56:Patron : épaulières en écailles de scorpide souples
254685:2:9:49:Patron : épaulières en étoffe-tempête
254034:2:9:41:Patron : épaulières terrestres en soie
227907:2:9:61:Patron : Épaulières volcaniques ouvragées
2251:1:7:25:Patte d'araignée fondante
9681:1:0:45:Pattes de roi clampant grillées
250076:1:0:45:Paupiette de raptor
1202:1:4:17:Pavois
2448:1:4:37:Pavois lourd
11407:1:12:1:Peau d'ours déchirée
3259:1:15:1:Peau de chauve-souris déchirée
4756:1:15:1:Peau de félin abîmée
7428:1:7:30:Peau de félin des ombres
2887:1:15:1:Peau de loup déchirée
8368:1:7:40:Peau de loup épaisse
4461:1:7:30:Peau de raptor
2890:1:15:1:Peau de sanglier déchirée
18510:4:4:62:Peau du Fauve
249428:2:7:45:Peau immaculée
4235:1:7:30:Peau lourde
4236:1:7:30:Peau lourde traitée
783:1:7:10:Peau légère
4231:1:7:10:Peau légère traitée
4232:1:7:20:Peau moyenne
4233:1:7:20:Peau moyenne traitée
8171:1:7:50:Peau robuste
15407:1:7:50:Peau robuste traitée
8169:1:7:40:Peau épaisse
8172:1:7:40:Peau épaisse traitée
249426:2:7:60:Pechblende
19483:1:15:1:Peler l'oignon
1195:1:2:6:Pelle de kobold
18023:3:4:59:Pendentif en rubis de sang
275724:2:7:10:Pendentif maléficié
13756:1:7:45:Perche estivale crue
13929:1:0:45:Perche fumée
4611:1:7:1:Perle bleue
13926:2:7:40:Perle dorée
5500:2:7:25:Perle iridescente
7971:2:7:40:Perle noire
2133:1:4:5:Petit bouclier
17184:1:4:3:Petit bouclier
5439:1:11:5:Petit carquois
6353:1:15:15:Petit coffre
6354:1:15:20:Petit coffre verrouillé
2484:1:2:4:Petit couteau
2947:1:2:3:Petit couteau de lancer
16022:3:4:60:Petit dragon en arcanite
4396:1:4:40:Petit dragon mécanique
10576:1:4:50:Petit dragon mécanique en mithril
11826:1:0:41:Petit fumant
2055:1:2:4:Petit marteau en bois
6889:1:7:5:Petit oeuf
21313:3:1:62:Petit sac de D'Sak
4402:1:7:25:Petit sac de flammes
11966:1:15:1:Petit sac de pièces
4245:1:1:25:Petit sac en soie
2498:1:2:8:Petit tomahawk
14343:3:7:50:Petit éclat brillant
22202:1:7:1:Petit éclat d'obsidienne
11177:3:7:40:Petit éclat irradiant
11138:3:7:30:Petit éclat luminescent
10978:3:7:20:Petit éclat scintillant
275892:1:15:1:Petite bière brune
4374:1:0:29:Petite bombe en bronze
828:1:1:5:Petite bourse bleue
5571:1:1:5:Petite bourse noire
805:1:1:5:Petite bourse rouge
5572:1:1:5:Petite bourse verte
4367:1:0:20:Petite charge d'hydroglycérine
4656:1:0:5:Petite citrouille
8148:1:15:54:Petite clé en argent
5517:1:15:18:Petite clé en bronze
8147:1:15:42:Petite clé en cuivre
5518:1:15:30:Petite clé en fer
21561:1:15:1:Petite comète blanche
21558:1:15:1:Petite comète bleue
21562:1:15:1:Petite comète jaune
21557:1:15:1:Petite comète rouge
21559:1:15:1:Petite comète verte
21560:1:15:1:Petite comète violette
4302:2:2:12:Petite dague verte
2102:1:11:1:Petite giberne
7279:1:11:5:Petite giberne en cuir
1475:1:7:1:Petite glande à venin
5523:1:7:10:Petite palourde spiralée
5465:1:7:5:Petite patte d'araignée
5134:1:12:1:Petite patte en fourrure
5498:2:7:15:Petite perle satinée
5441:1:11:5:Petite sacoche de poudre
4496:1:1:5:Petite sacoche marron
1167:1:4:10:Petite targe
17186:1:4:8:Petite targe
6183:1:0:10:Petite torche éteinte
11108:1:12:1:Photographie décolorée
207631:1:0:1:Phéromone d’aspic
19305:1:0:25:Pied de kodo mariné
2835:1:7:5:Pierre brute
21536:1:15:1:Pierre d'Elune
6724:6:4:1:Pierre de Backus
6728:6:4:1:Pierre de Brownell
12809:2:7:60:Pierre de gardien
6708:6:4:1:Pierre de Goodman
6711:6:4:1:Pierre de Kurtz
6707:6:4:1:Pierre de Lapidis
1705:2:7:30:Pierre de lune inférieure
219515:2:15:50:Pierre de lune supérieure
6698:6:4:1:Pierre de Pierce
5406:1:0:1:Pierre de sang mineure vide
5229:1:0:38:Pierre de sang supérieure vide
5509:1:0:34:Pierre de soins
19008:1:0:34:Pierre de soins
19009:1:0:34:Pierre de soins
5511:1:0:22:Pierre de soins inférieure
19006:1:0:22:Pierre de soins inférieure
19007:1:0:22:Pierre de soins inférieure
9421:1:0:58:Pierre de soins majeure
19012:1:0:58:Pierre de soins majeure
19013:1:0:58:Pierre de soins majeure
5512:1:0:10:Pierre de soins mineure
19004:1:0:10:Pierre de soins mineure
19005:1:0:10:Pierre de soins mineure
5510:1:0:46:Pierre de soins supérieure
19010:1:0:46:Pierre de soins supérieure
19011:1:0:46:Pierre de soins supérieure
255663:1:0:1:Pierre de vent
12365:1:7:45:Pierre dense
20737:1:15:1:Pierre du Magma roussie
268879:1:15:20:Pierre d’Uber Diablo
2836:1:7:15:Pierre grossière
5565:1:15:55:Pierre infernale
2838:1:7:25:Pierre lourde
7912:1:7:35:Pierre solide
2862:1:0:5:Pierre à aiguiser brute
211845:2:7:25:Pierre à aiguiser de Brassenoire
12404:1:0:45:Pierre à aiguiser dense
2863:1:0:15:Pierre à aiguiser grossière
2871:1:0:25:Pierre à aiguiser lourde
7964:1:0:35:Pierre à aiguiser solide
18262:2:0:60:Pierre à aiguiser élémentaire
22289:1:15:1:Pile de cartes
2675:1:7:13:Pince de clampant
2682:1:0:10:Pince de crabe farcie
8393:1:12:1:Pince de scorpok
6206:1:2:17:Pioche
778:1:2:7:Pioche de kobold
2901:1:2:4:Pioche de mineur
260829:2:4:60:Piston magnétique Ev-Lan
19706:2:12:1:Pièce Bloodscalp
19701:2:12:1:Pièce Gurubashi
19700:2:12:1:Pièce hakkari
19699:2:12:1:Pièce Razzashi
19704:2:12:1:Pièce Sandfury
19705:2:12:1:Pièce Skullsplitter
19702:2:12:1:Pièce Vilebranch
19703:2:12:1:Pièce Witherbark
19698:2:12:1:Pièce zulienne
274917:1:0:12:Piège cassant
258773:1:12:1:Piège à fléchettes cassé
5826:1:12:1:Plan de Kravel
3329:1:2:11:Planche cloutée
260825:2:15:1:Planeur gobelin ultraléger
12835:3:9:63:Plans : Annihilateur
12682:2:9:50:Plans : Armure en thorium
7981:2:9:36:Plans : Bottes barbares en fer
3874:2:9:37:Plans : Bottes en acier poli
3611:2:9:29:Plans : Bottes en fer émeraude
12693:2:9:56:Plans : Bottes en thorium
3875:3:9:40:Plans : Bottes en écailles dorées
12697:2:9:58:Plans : Bottes radieuses
12684:2:9:51:Plans : Brassards en thorium
7980:2:9:35:Plans : Casque barbare en fer
12683:2:9:50:Plans : Ceinture en thorium
12685:2:9:52:Plans : Ceinture radieuse
12834:3:9:63:Plans : Championne en arcanite
6045:2:9:33:Plans : Contrepoids en fer
12830:1:9:58:Plans : Corruption
12821:3:9:55:Plans : Courroux de l'aube
3869:2:9:40:Plans : Croissant des ombres
12839:3:9:63:Plans : Crève-coeur
7979:2:9:32:Plans : Cuirasse barbare en fer
6735:2:9:20:Plans : Cuirasse de Forgefer
20554:3:9:63:Plans : Cuirasse de sombrerune
5578:2:9:26:Plans : Cuirasse en bronze argenté
3873:2:9:39:Plans : Cuirasse en écailles dorées
12689:2:9:54:Plans : Cuirasse radieuse
2881:2:9:18:Plans : Cuirasse runique en cuivre
22222:3:9:72:Plans : Cuirasse épaisse en obsidienne
10713:1:9:40:Plans : Cylindre damasquiné en mithril
3867:2:9:34:Plans : Destructeur en fer doré
12702:2:9:59:Plans : Diadème radieux
6046:2:9:38:Plans : Dragonne en acier
12838:3:9:63:Plans : Déchireuse en arcanite
11611:3:9:55:Plans : Découpeuse en sombrefer
22390:4:9:63:Plans : Eloquente
22220:3:9:70:Plans : Emprise noire du Destructeur
7978:2:9:32:Plans : Epaulières barbares en fer
12698:3:9:58:Plans : Epaulières du point du jour
2882:2:9:25:Plans : Epaulières en bronze argenté
3870:2:9:32:Plans : Epaulières en fer émeraude
3871:3:9:35:Plans : Epaulières en écailles dorées
7989:2:9:47:Plans : Eperons en mithril
12162:1:9:32:Plans : Epée courte en fer trempé
12720:4:9:62:Plans : Gantelets de la forteresse
20553:3:9:63:Plans : Gantelets de sombrerune
3612:2:9:30:Plans : Gantelets en fer émeraude
9367:2:9:41:Plans : Gantelets en écailles dorées
3610:2:9:15:Plans : Gantelets ornementés en cuivre
12695:2:9:57:Plans : Gantelets radieux
7982:2:9:37:Plans : Gants barbares en fer
12836:3:9:63:Plans : Gardienne de givre
7992:2:9:44:Plans : Hache lumineuse bleue
11612:3:9:57:Plans : Harnois en sombrefer
12717:4:9:61:Plans : Heaume Coeur-de-lion
12711:3:9:60:Plans : Heaume d'âme blanche
20555:3:9:63:Plans : Heaume de sombrerune
12694:2:9:56:Plans : Heaume en thorium
7990:2:9:49:Plans : Heaume lourd en mithril
10424:2:9:31:Plans : Jambières en bronze argenté
12704:2:9:60:Plans : Jambières en thorium
3872:2:9:34:Plans : Jambières en écailles dorées
7975:2:9:42:Plans : Jambières lourdes en mithril
12713:2:9:61:Plans : Jambières radieuses
22388:4:9:61:Plans : Jambières titanesques
17706:2:9:38:Plans : Lame de l'hiver
12261:2:9:38:Plans : Lame dorée flamboyante
22389:4:9:64:Plans : Lame feuille-de-saule
3609:2:9:10:Plans : Lorica en cuivre
12824:2:9:56:Plans : Marteau de guerre enchanté
12833:3:9:63:Plans : Marteau des Titans
18592:4:9:63:Plans : Marteau en sulfuron
5543:2:9:28:Plans : Marteau iridescent
8028:3:9:49:Plans : Marteau runique en mithril
12828:2:9:58:Plans : Marteau volcanique
12837:3:9:63:Plans : Marteau-tempête ouvragé
2883:2:9:25:Plans : Poignard mortel en bronze
6044:2:9:30:Plans : Pointe de bouclier en fer
7976:3:9:43:Plans : Pointe de bouclier en mithril
12692:2:9:55:Plans : Pointe de bouclier en thorium
3608:2:9:29:Plans : Puissant marteau en fer
11610:3:9:53:Plans : Pulvériseur en sombrefer
12825:2:9:56:Plans : Rapière flamboyante
7993:2:9:48:Plans : Rapière éblouissante en mithril
3866:2:9:35:Plans : Serpentine de jade
12827:2:9:57:Plans : Sérénité
3868:2:9:40:Plans : Tigresse glaciale
251759:3:9:1:Plans : armure de plaques adaptable de tisse-terre
217276:3:9:40:Plans : Bottes en écailles dorées
217280:1:9:38:Plans : Camail en écailles dorées
238322:3:9:1:Plans : casque de soldat écarlate
251746:3:9:1:Plans : ceinturon adaptable de cogneterre
228117:3:9:63:Plans : Championne en arcanite raffinée
228314:3:9:61:Plans : Cimier de guerre du grand chef
238329:3:9:1:Plans : croquenots de soldat écarlate
217278:2:9:39:Plans : Cuirasse en écailles dorées
238328:3:9:1:Plans : cuissards de soldat écarlate
228114:3:9:63:Plans : Faucheuse en arcanite raffinée
228118:4:9:62:Plans : Gantelets de forteresse majeure
228250:4:9:62:Plans : Gantelets de forteresse majeure
228313:3:9:59:Plans : Gantelets de la tempête
217274:2:9:41:Plans : Gantelets en écailles dorées
228310:3:9:63:Plans : Garde de givre durcie
251745:3:9:1:Plans : garde-bras adaptables de cogneterre
227901:3:9:57:Plans : Harnois en sombrefer trempé
217286:2:9:34:Plans : Jambières en écailles dorées
228315:4:9:64:Plans : Lame feuille-de-saule de l’archimagus
251760:3:9:1:Plans : liens adaptables de tisse-terre
228312:4:9:63:Plans : Maille invincible
228311:2:9:56:Plans : Marteau d’armes subtilement enchanté
227727:4:9:63:Plans : Marteau en sulfuron
227905:3:9:63:Plans : Marteau-tempête ouvragé de vol dynamique
251744:3:9:1:Plans : pansière adaptable de cogneterre
238324:3:9:1:Plans : pansière de soldat écarlate
238326:3:9:1:Plans : poignes de soldat écarlate
238325:3:9:1:Plans : protecteurs de soldat écarlate
251761:3:9:1:Plans : sangle adaptable de tisse-terre
238327:3:9:1:Plans : sangle de soldat écarlate
238323:3:9:1:Plans : spallières de soldat écarlate
7991:3:9:47:Plans : épaulières en plaques de mithril
217284:3:9:35:Plans : Épaulières en écailles dorées
217282:1:9:36:Plans : Épée large en acier lunaire
5066:1:0:15:Plante des crevasses
275642:1:15:1:Plantes égarées
273096:2:9:25:Plan : chevalet de tannage
273086:2:9:25:Plan : enclume
273085:2:9:25:Plan : fermenteur
273102:2:9:25:Plan : festin de Macaron
273087:2:9:25:Plan : feu de camp de compagnon
273101:2:9:40:Plan : feu de camp de spécialiste
273122:2:9:60:Plan : fonderie en fusion
273116:2:9:60:Plan : forge arcanique
273113:2:9:60:Plan : forge magistrale
273115:2:9:60:Plan : four en fer
273098:2:9:25:Plan : guide de terrain
273119:2:9:60:Plan : hutte de pêche
273120:2:9:60:Plan : hybrideur de graines
273097:2:9:25:Plan : jardin de pierres
273118:2:9:60:Plan : laboratoire de médecin de peste
273112:2:9:60:Plan : laboratoire d’alchimie
273121:2:9:60:Plan : machine à coudre
273124:2:9:60:Plan : métier à tisser
273092:2:9:25:Plan : robot réparateur
273099:2:9:25:Plan : rouet
273141:2:9:25:Plan : râtelier de pêche
273103:2:9:25:Plan : récupérateur arcanique
273106:2:9:25:Plan : serre
273109:2:9:60:Plan : établi de trappeur
273117:2:9:60:Plan : établi d’anarchiste
273105:2:9:25:Plan : étude des toxines
269502:2:4:58:Plaque naine
213376:3:7:40:Plaques en vrai-argent faiblement radioactif
250594:2:4:61:Plastron béni en plaques
168659:2:4:1:Plastron caché
2898:1:4:7:Plastron de montagnard
278120:1:0:35:Plateau de fruits
15420:1:7:50:Plumacier
10450:1:12:1:Plume d'hippogryphe sans défaut
17056:1:15:1:Plume légère
8168:1:7:45:Plume noire
5165:1:12:1:Plume solécaille
5117:1:12:1:Plume vibrante
260812:3:15:55:Plumerang
11022:1:12:1:Pochette de graines de Tharlendis
2208:1:2:19:Poignard
3490:2:2:25:Poignard mortel en bronze
275625:3:4:58:Poignes de couverain
275622:3:4:58:Poignes de sangtaille
14115:1:4:14:Poignets aborigènes
15482:1:4:11:Poignets de guerre déchirés
9752:1:4:12:Poignets de nomade
22655:4:4:80:Poignets glaciaires
14095:1:4:11:Poignets indigènes
15005:1:4:9:Poignets primordiaux
9744:1:4:12:Poignets simples
4359:1:7:8:Poignée de boulons en cuivre
22218:1:15:1:Poignée de pétales de rose
4096:1:15:1:Poil de gorille grossier
250604:2:2:31:Poings de fer
6042:1:0:30:Pointe de bouclier en fer
7967:2:0:43:Pointe de bouclier en mithril
12645:2:0:55:Pointe de bouclier en thorium
240945:1:0:1:Pointe de tarte aux pommes de Carrie
3775:1:0:20:Poison affaiblissant
3776:1:0:50:Poison affaiblissant II
217346:1:0:60:Poison ankylosant
217347:1:0:60:Poison atrophiant
5237:1:0:24:Poison de distraction mentale
6951:1:0:38:Poison de distraction mentale II
9186:1:0:52:Poison de distraction mentale III
10918:1:0:32:Poison douloureux
10920:1:0:40:Poison douloureux II
10921:1:0:48:Poison douloureux III
10922:1:0:56:Poison douloureux IV
6947:1:0:20:Poison instantané
6949:1:0:28:Poison instantané II
6950:1:0:36:Poison instantané III
8926:1:0:44:Poison instantané IV
8927:1:0:52:Poison instantané V
8928:1:0:60:Poison instantané VI
2892:1:0:30:Poison mortel
2893:1:0:38:Poison mortel II
8984:1:0:46:Poison mortel III
8985:1:0:54:Poison mortel IV
20844:1:0:60:Poison mortel V
226374:1:0:54:Poison occulte I
234444:1:0:60:Poison occulte II
217345:1:0:60:Poison sébacé
6360:2:2:25:Poisson aux écailles d'acier
286152:1:0:45:Poisson cuirassé
13890:1:12:55:Poisson cuirassé cru
6522:1:0:15:Poisson déviant
6458:1:0:15:Poisson huileux
6299:1:0:5:Poisson maladif
6309:1:15:15:Poisson-chat de 17 livres
6310:1:15:15:Poisson-chat de 19 livres
6311:1:15:15:Poisson-chat de 22 livres
6363:1:15:25:Poisson-chat de 26 livres
6364:1:15:25:Poisson-chat de 32 livres
4593:1:0:25:Poisson-chat moustachu
6308:1:7:25:Poisson-chat moustachu cru
1326:1:0:15:Poisson-lune sauté
250074:1:0:35:Poitrine d’ours
4539:1:0:35:Pomme dorette
4536:1:0:5:Pomme rouge brillante
260807:1:0:45:Porte-créature compact
9172:1:0:47:Potion d'invisibilité
3823:1:0:33:Potion d'Invisibilité inférieure
3387:1:0:50:Potion d'invulnérabilité limitée
4623:1:0:43:Potion de Bouclier de pierre inférieure
13455:1:0:56:Potion de Bouclier de pierre supérieure
250951:1:0:5:Potion de brume caustique
1450:1:0:25:Potion de ferveur
250953:1:0:45:Potion de feu draconique
250940:1:0:55:Potion de frénésie
250942:1:0:55:Potion de frénésie excellente
250939:1:0:45:Potion de frénésie inférieure
250943:1:0:55:Potion de frénésie majeure
250938:1:0:25:Potion de frénésie mineure
250941:1:0:45:Potion de frénésie supérieure
5633:1:0:35:Potion de Grande rage
5634:1:0:30:Potion de libre action
3827:1:0:32:Potion de mana
13443:1:0:51:Potion de mana excellente
288897:1:0:30:Potion de mana excellente
3385:1:0:24:Potion de mana inférieure
13444:1:0:59:Potion de mana majeure
2455:1:0:15:Potion de mana mineure
6149:1:0:41:Potion de mana supérieure
6372:1:0:20:Potion de Nage rapide
6048:1:0:27:Potion de protection contre l'Ombre
13459:1:0:58:Potion de protection contre l'Ombre supérieure
6052:1:0:38:Potion de protection contre la Nature
13458:1:0:58:Potion de protection contre la Nature supérieure
6049:1:0:33:Potion de protection contre le Feu
13457:1:0:58:Potion de protection contre le Feu supérieure
6050:1:0:38:Potion de protection contre le Givre
13456:1:0:58:Potion de protection contre le Givre supérieure
6051:1:0:20:Potion de protection contre le Sacré
13460:1:0:58:Potion de protection contre le Sacré supérieure
13461:1:0:58:Potion de protection contre les Arcanes supérieure
250954:1:0:55:Potion de purge d’élémentaires
13462:1:0:57:Potion de purification
3386:1:0:55:Potion de purification du poison
5631:1:0:14:Potion de Rage
13442:1:0:51:Potion de rage puissante
2459:1:0:15:Potion de rapidité
288898:1:0:30:Potion de rapidité
9030:1:0:42:Potion de restauration
18253:1:0:60:Potion de régénération majeure
2456:1:0:15:Potion de régénération mineure
9036:1:0:42:Potion de résistance à la magie
3384:1:0:22:Potion de résistance à la magie mineure
250950:1:0:55:Potion de sang envenimé
9144:1:0:45:Potion de sauvageonne
250327:1:0:45:Potion de sens de prédateur
250946:1:0:5:Potion de soigneur
250948:1:0:55:Potion de soigneur excellente
250945:1:0:55:Potion de soigneur inférieure
250949:1:0:25:Potion de soigneur majeure
250944:1:0:55:Potion de soigneur mineure
250947:1:0:25:Potion de soigneur supérieure
929:1:0:22:Potion de soins
247240:1:0:22:Potion de soins décolorée
3928:1:0:45:Potion de soins excellente
288896:1:0:30:Potion de soins excellente
247242:1:0:45:Potion de soins excellente décolorée
858:1:0:13:Potion de soins inférieure
247239:1:0:13:Potion de soins inférieure décolorée
268882:1:0:13:Potion de soins inférieure périssable
13446:1:0:55:Potion de soins majeure
241650:1:0:70:Potion de soins majeure décolorée
241655:1:0:70:Potion de soins manipulée sans soin
241656:1:0:70:Potion de soins manipulée sans soin
118:1:0:5:Potion de soins mineure
4596:1:0:15:Potion de soins mineure décolorée
268881:1:0:5:Potion de soins mineure périssable
268883:1:0:22:Potion de soins périssable
1710:1:0:31:Potion de soins supérieure
247241:1:0:31:Potion de soins supérieure décolorée
12190:1:0:45:Potion de sommeil sans rêve
20002:1:0:60:Potion de sommeil sans rêve supérieure
250955:1:0:55:Potion de tueur de bêtes
9224:1:0:50:Potion de tueur de démons
20008:1:0:57:Potion de vive action
250934:1:0:5:Potion d’explosion de sorts
250936:1:0:55:Potion d’explosion de sorts excellente
250933:1:0:5:Potion d’explosion de sorts inférieure
250937:1:0:5:Potion d’explosion de sorts majeure
250932:1:0:45:Potion d’explosion de sorts mineure
250935:1:0:55:Potion d’explosion de sorts supérieure
274709:1:0:23:Potion d’expérience – niveau 23
274710:1:0:38:Potion d’expérience – niveau 38
274711:1:0:57:Potion d’expérience – niveau 57
274712:1:0:60:Potion d’expérience – niveau 60
278069:1:0:60:Potion of Tradeskill Testing - Level 60
5530:1:15:34:Poudre aveuglante
4357:1:7:5:Poudre d'explosion basique
15992:1:7:50:Poudre d'explosion dense
4364:1:7:15:Poudre d'explosion grossière
4377:1:7:25:Poudre d'explosion majeure
16204:1:7:55:Poudre d'illusion
2928:1:15:20:Poudre de délabrement
17020:1:15:56:Poudre des arcanes
10505:1:7:35:Poudre noire solide
5140:1:15:20:Poudre éclipsante
10398:1:15:40:Poulet mécanique
8952:1:0:55:Poulet rôti
8392:1:12:1:Poumon de sanglier éclaté
19813:2:12:1:Poupée vaudou percée
19814:2:12:1:Poupée vaudou percée
19815:2:12:1:Poupée vaudou percée
19816:2:12:1:Poupée vaudou percée
19817:2:12:1:Poupée vaudou percée
19818:2:12:1:Poupée vaudou percée
19819:2:12:1:Poupée vaudou percée
19820:2:12:1:Poupée vaudou percée
19821:2:12:1:Poupée vaudou percée
20009:1:12:1:Pour la Lumière !
2311:2:4:13:Pourpoint blanc en cuir
2112:1:4:9:Pourpoint de bûcheron
846:1:4:17:Pourpoint en cuir tanné
19685:3:4:65:Pourpoint en peau de chauve-souris primordiale
277028:2:4:12:Pourpoint mêle-vent azur
277004:2:4:12:Pourpoint mêle-vent nuageux
280615:1:15:20:Poussin trotteur des trombes
13159:1:12:1:Poussière d'os
11083:1:7:25:Poussière d'âme
8924:1:15:30:Poussière de détérioration
219445:2:15:40:Poussière de pyrite
11176:1:7:45:Poussière de rêve
11137:1:7:35:Poussière de vision
17019:1:15:42:Poussière des arcanes
2091:1:0:20:Poussière magique
2929:1:7:12:Poussière tombale
10940:1:7:10:Poussière étrange
19044:3:4:58:Pouvoir des Grumegueules
22174:1:15:1:Poème romantique
204688:1:0:1:Premier fragment de rune de chasseurs de monstres
205943:1:0:1:Prophétie d’une citadelle profanée
12286:1:12:1:Prototype d'Oeufilloscope
254021:3:4:40:Protège-mains ambrés
15476:1:4:10:Protège-mains du destrier
277036:2:4:11:Protège-mains fil-tempête azur
277012:2:4:11:Protège-mains fil-tempête nuageux
14102:1:4:13:Protège-mains indigènes
14169:1:4:21:Protège-épaules aborigènes
14728:1:4:22:Protège-épaules aux peintures de guerre
10407:1:4:21:Protège-épaules d'écumeur
14368:1:4:22:Protège-épaules de mystique
14389:3:4:1:Protège-épaules endurants
15313:1:4:24:Protège-épaules farouches
15496:1:4:21:Protège-épaules maculées de sang
19975:1:12:1:Puant de vase zulien
3492:2:2:30:Puissant marteau en fer
18594:1:0:55:Puissante charge d'hydroglycérine
8546:1:0:50:Puissants sels odorants
279956:1:0:4:Puits de mana
11608:3:2:55:Pulvériseur en sombrefer
5342:1:0:18:Punch du raptor
6210:1:13:1:PVP - Mine de l'Alliance
6209:1:13:1:PVP - Mine de la Horde
6208:1:13:1:PVP - Plans de la tour de l'Alliance
6207:1:13:1:PVP - Plans de la tour de la Horde
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
21023:1:0:55:Pyro-côtelettes de chimaerok à la Dirge
3818:1:7:32:Pâlerette
279269:4:4:65:Pèlerine gangrenée
269902:1:0:1:Pédale en forme de sabot
272016:1:15:60:Pépite d’or
21747:1:15:1:Pétards de fête
16168:1:0:45:Pêche céleste
260624:1:0:45:Pêche en parfait état
232343:1:0:1:QAEnchant Shield - Law of Nature
19271:3:12:1:Quatre d'Elémentaires
221302:3:15:1:Quatre de Cauchemar
221293:3:15:1:Quatre de Dunes
19232:3:12:1:Quatre de Fauves
221275:3:15:1:Quatre de Nature
221284:3:15:1:Quatre de Plaies
19280:3:12:1:Quatre de Portails
19261:3:12:1:Quatre de Seigneurs de guerre
1703:1:0:35:Queue de basilic de cristal
5479:1:0:15:Queue de lézard croquante
5470:1:7:22:Queue de lézard-tonnerre
4582:1:12:1:Queue fournie soyeuse
18255:1:0:55:Racine de Courante
3448:1:0:15:Racine de Senggin
17747:1:0:50:Racine de Tranchefouet
219514:1:15:50:Racine lunaire
17024:1:15:50:Racine sauvage
5205:1:0:15:Racine éclose
5206:1:0:12:Racines d'agression
274971:1:0:35:Ragoût de fruits de mer saumâtre
13933:1:0:55:Ragoût de homard
12212:1:0:45:Ragoût de la jungle
733:1:0:15:Ragoût de la marche de l'Ouest
250068:1:0:55:Ragoût de tortue savoureux
12214:1:0:25:Ragoût mystère
20074:1:0:35:Ragoût épais de crocilisque
12215:1:0:35:Ragoût épais de kodo
189426:1:15:1:Raid Consumables
12777:3:2:56:Rapière flamboyante
7944:2:2:48:Rapière éblouissante en mithril
6075:1:12:1:Rapport de Vimaire
18788:4:15:60:Raptor bleu rapide
18790:4:15:60:Raptor orange rapide
18789:4:15:60:Raptor vert olive rapide
5051:1:12:1:Rat fouisseur
5052:1:12:1:Rat fouisseur inconscient
277518:1:2:1:Ration de la semaine passée
4388:1:0:32:Rayon discombobulateur
10716:1:4:41:Rayon réducteur gnome
5643:1:9:35:Recette  : Potion de Grande rage
5657:1:9:24:Recette  : Toxine instantané
12226:1:9:5:Recette : Aile de chauve-souris croustillante
6039:1:9:35:Recette : Ardeur de palourde géante
13940:1:9:45:Recette : Barracuda luisant cuit
17200:1:9:5:Recette : Biscuit de pain d'épice
3737:1:9:30:Recette : Bisque de tortue apaisante
3679:1:9:15:Recette : Boudin
5487:1:9:20:Recette : Brouet de rat
5486:1:9:15:Recette : Brouet de trotteur
13942:1:9:48:Recette : Calmar grillé
10644:1:9:42:Recette : Carburant de fusée des gobelins
16111:1:9:45:Recette : Chili de crabe épicé
12239:1:9:40:Recette : Chili de souffle de dragon
2700:1:9:20:Recette : Côtes de porc aux herbes
2889:1:9:8:Recette : Côtes de sanglier à la bière
9296:2:9:48:Recette : Don d'Arthas
6661:2:9:18:Recette : Délice de déviant
6329:1:9:15:Recette : Délice de furie du loch
21219:1:9:35:Recette : Délice de sagerelle
3736:1:9:30:Recette : Délicieux steak de lion
3396:2:9:28:Recette : Elixir d'Agilité inférieur
2553:2:9:12:Recette : Elixir d'Agilité mineure
13478:1:9:53:Recette : Elixir de Défense excellente
3832:2:9:39:Recette : Elixir de Détection d'Invisibilité inférieure
6211:1:9:30:Recette : Elixir de Force d'ogre
13481:2:9:55:Recette : Elixir de Force de brute
13491:2:9:56:Recette : Elixir de la Mangouste
21547:2:9:50:Recette : Elixir de maîtrise du feu supérieure
9301:2:9:50:Recette : Elixir de Puissance de l'ombre
17709:1:9:38:Recette : Elixir de Puissance du givre
6663:2:9:18:Recette : Elixir de Taille de géant
13493:2:9:57:Recette : Elixir des arcanes supérieur
9298:2:9:49:Recette : Elixir des géants
13479:2:9:54:Recette : Elixir des Sages
5485:1:9:15:Recette : Filet de furie
13941:1:9:45:Recette : Filet de rouget
13521:2:9:60:Recette : Flacon de pouvoir suprême
13518:2:9:60:Recette : Flacon de pétrification
13522:2:9:60:Recette : Flacon de résistance chromatique
13520:2:9:60:Recette : Flacon de sagesse distillée
13519:2:9:60:Recette : Flacon des Titans
3681:1:9:25:Recette : Gombo de crocilisque
6325:1:9:5:Recette : Goujon brillant
2699:1:9:20:Recette : Goulash des Carmines
13939:1:9:45:Recette : Jaune-queue tacheté
5482:1:9:5:Recette : Kébab d'araignée kaldorei
2701:1:9:25:Recette : Kébab de loup assaisonné
17201:1:9:10:Recette : Lait de poule
6328:1:9:15:Recette : Lutjan à longue mâchoire
6326:1:9:5:Recette : Maquereau ombré
6369:1:9:30:Recette : Morue rochécaille
3682:1:9:25:Recette : Omelette au goût étrange
16110:1:9:45:Recette : Omelette monstrueuse
13949:1:9:55:Recette : Pain de saumon
13943:1:9:48:Recette : Perche fumée
9303:1:9:45:Recette : Pierre philosophale
2698:1:9:15:Recette : Pince de crabe farcie
6330:1:9:25:Recette : Poisson-chat moustachu
9295:2:9:47:Recette : Potion d'invisibilité
3395:2:9:50:Recette : Potion d'invulnérabilité limitée
4624:1:9:43:Recette : Potion de Bouclier de pierre inférieure
13490:2:9:56:Recette : Potion de Bouclier de pierre supérieure
5642:1:9:30:Recette : Potion de libre action
13477:1:9:52:Recette : Potion de mana excellente
13499:2:9:58:Recette : Potion de protection contre l'Ombre supérieure
13496:2:9:58:Recette : Potion de protection contre la Nature supérieure
13494:2:9:58:Recette : Potion de protection contre le Feu supérieure
13495:2:9:58:Recette : Potion de protection contre le Givre supérieure
13500:2:9:58:Recette : Potion de protection contre le Sacré supérieure
13497:2:9:58:Recette : Potion de protection contre les Arcanes supérieure
13492:2:9:57:Recette : Potion de Purification
5640:1:9:14:Recette : Potion de rage
13476:2:9:51:Recette : Potion de rage puissante
2555:2:9:15:Recette : Potion de Rapidité
18257:3:9:60:Recette : Potion de régénération majeure
9293:2:9:42:Recette : Potion de résistance à la magie
3393:1:9:22:Recette : Potion de résistance à la magie mineure
9294:2:9:45:Recette : Potion de sauvageonne
21025:4:9:60:Recette : Pyro-côtelettes de chimaerok à la Dirge
5488:1:9:20:Recette : Queue de lézard croquante
13947:1:9:55:Recette : Ragoût de homard
728:1:9:15:Recette : Ragoût de la marche de l'Ouest
20075:1:9:30:Recette : Ragoût épais de crocilisque
21099:1:9:15:Recette : Sagerelle fumée
13946:1:9:50:Recette : Saumon solécaille poché
3680:1:9:25:Recette : Soupe aux ailerons de murloc
13945:1:9:50:Recette : Soupe de lutjan nagenuit
5528:1:9:20:Recette : Soupe de palourdes
13948:1:9:55:Recette : Steak de barracuda
3678:1:9:15:Recette : Steak de crocilisque
18046:1:9:45:Recette : Steak de loup tendre
5483:1:9:8:Recette : Surprise du scorpide
6368:1:9:15:Recette : Thon arc-en-ciel
7678:1:9:15:Recette : Thé de chardon
2697:1:9:15:Recette : Tourte au foie de Broche-tripes
3683:1:9:25:Recette : Tourte d'araignée fondante
12958:1:9:55:Recette : Transmutation d'arcanite
13487:2:9:55:Recette : Transmutation de l'Eau en Non-mort
13489:2:9:55:Recette : Transmutation de la Terre en Vie
13488:2:9:55:Recette : Transmutation de la Vie en Terre
9304:1:9:45:Recette : Transmutation du fer en or
13486:2:9:55:Recette : Transmutation du Non-mort en Eau
17062:1:9:30:Recette : Truite tête-mithril
6892:1:9:13:Recette : Viande d'ours fumée
5484:1:9:10:Recette : Viande de kodo rôtie
232437:1:9:55:Recette : bisque de Pince-noire
263513:1:9:15:Recette : bouchées à la chair de pinces
9297:2:9:48:Recette : breuvage de vision de rêve
251526:2:9:18:Recette : délice de fantaileron
250986:1:9:1:Recette : potion de frénésie excellente
250983:1:9:1:Recette : potion de frénésie inférieure
250982:1:9:1:Recette : potion de frénésie mineure
3394:1:9:24:Recette : potion de purification du poison
250363:1:9:1:Recette : potion de sens de prédateur
250992:1:9:1:Recette : potion de soigneur excellente
250989:1:9:1:Recette : potion de soigneur inférieure
250988:1:9:1:Recette : potion de soigneur mineure
250980:1:9:1:Recette : potion d’explosion de sorts excellente
250977:1:9:1:Recette : potion d’explosion de sorts inférieure
250976:1:9:1:Recette : potion d’explosion de sorts mineure
232443:1:9:45:Recette : rouget fumé
263511:1:9:15:Recette : soufflé de Mur-Céleste
284871:1:9:55:Recette : transmutation de légionite
250385:1:9:1:Recette : élixir de Force
250370:1:9:1:Recette : élixir de robustesse
3830:1:9:35:Recette : élixir de robustesse inférieure
3831:1:9:36:Recette : élixir de sang de Troll
250368:1:9:1:Recette : élixir des clercs
250366:1:9:1:Recette : élixir des clercs mineur
210709:2:9:25:Recette : élixir des regrets accumulés
250382:1:9:1:Recette : élixir d’Esprit
250380:1:9:1:Recette : élixir d’Esprit mineur
250389:1:9:1:Recette : élixir d’Intelligence
250375:1:9:1:Recette : élixir magesang mineur
18637:2:4:55:Recombobulateur majeur
4381:2:4:28:Recombobulateur mineur
21300:3:9:60:Recueil : Attaque sournoise IX
21303:3:9:60:Recueil : Feinte V
21302:3:9:60:Recueil : Poison mortel V
22298:1:15:1:Recueil de poèmes romantiques
19054:1:15:20:Red Dragon Orb
2921:1:4:15:Relique bénie
2923:1:4:25:Relique de Droiture
3003:1:4:10:Relique de l'Oeil
3002:1:4:30:Relique de la Corne de Justice
3791:1:4:40:Relique de la Lumière
3789:1:4:35:Relique de la Pierre de piété
3005:1:4:20:Relique de la Vérité
2919:1:4:30:Relique des Anciens
3004:1:4:15:Relique des morts
4031:1:4:45:Relique du charme sacré
3788:1:4:40:Relique du Cristal d'âme
4032:1:4:50:Relique Marteau irradiant
2920:1:4:10:Relique sacrée
4030:1:4:45:Relique sacrée de l'eau
2922:1:4:20:Relique spirituelle
260796:1:7:29:Rembourrage antidérapant SUR-T
2633:1:0:26:Remède tropical
18251:3:0:60:Renfort d'armure du Magma
4265:1:0:30:Renfort d'armure lourd
2304:1:0:5:Renfort d'armure léger
2313:1:0:15:Renfort d'armure moyen
15564:1:0:50:Renfort d'armure robuste
8173:1:0:40:Renfort d'armure épais
279258:3:0:65:Renfort d’armure en cuir fauve
252452:2:0:30:Renfort d’armure lourd mystique
252453:2:0:30:Renfort d’armure lourd énergique
252436:2:0:15:Renfort d’armure moyen mystique
252437:2:0:15:Renfort d’armure moyen énergique
252487:2:0:50:Renfort d’armure robuste mystique
252488:2:0:50:Renfort d’armure robuste énergique
252462:2:0:40:Renfort d’armure épais mystique
252463:2:0:40:Renfort d’armure épais énergique
278569:1:0:5:Restes d’hier
215430:1:7:40:Retombée de Gnomeregan
228980:1:0:50:Revêtement de bouclier conducteur
21140:1:0:1:Reçu de l'hôtel des ventes
289303:4:2:40:Rhok’delar, arc long des Gardiens anciens
21114:1:0:1:Rhum brun de Rumsey
21151:1:0:1:Rhum de Rumsey label noir
20709:1:0:1:Rhum doux de Rumsey
9260:1:0:1:Rhum explosif
4335:1:4:37:Riche chemise violette en soie
2617:1:4:37:Robe ardente
2618:1:4:50:Robe argentée
10040:1:4:35:Robe blanche de mariée
6787:2:4:22:Robe blanche en laine
6241:2:4:10:Robe blanche en lin
6242:2:4:14:Robe bleue en lin
2616:1:4:23:Robe chatoyante en soie
2615:1:4:29:Robe chromatique
19156:4:4:66:Robe Coeur-de-braise
7063:2:4:41:Robe cramoisie en soie
6264:2:4:23:Robe d'adepte supérieur
2614:1:4:17:Robe d'apprentissage
5770:2:4:30:Robe d'Arcana
279266:4:4:65:Robe de dévastation ardente
21154:1:4:1:Robe de fête
10143:2:4:64:Robe de grand conseiller
14136:3:4:57:Robe de la nuit hivernale
6837:1:4:1:Robe de mariage
7809:1:4:30:Robe de Pâques
20407:2:4:60:Robe de sectateur du crépuscule
5110:1:4:18:Robe de sorcier de Dalaran
5766:2:4:27:Robe de sorcier inférieur
8200:2:4:43:Robe du grand vaudou
4782:2:4:18:Robe du solstice
14106:2:4:61:Robe en gangrétoffe
7066:1:4:27:Robe en soie exotique
10004:2:4:43:Robe en tisse-ombre
14128:2:4:60:Robe en tisse-sorcier
10042:2:4:45:Robe en étoffe cendrée
14100:2:4:54:Robe en étoffe lumineuse
18486:3:4:61:Robe en étoffe lunaire
13858:2:4:52:Robe en étoffe runique
2585:2:4:21:Robe grise en laine
2110:1:4:4:Robe légère de fèvre-mage
6238:2:4:10:Robe marron en lin
2114:1:4:8:Robe neigeuse
10001:2:4:42:Robe noire en tisse-mage
10053:1:4:47:Robe noire simple
2572:2:4:10:Robe rouge en lin
2612:1:4:8:Robe sobre
13868:2:4:51:Robe tisse-givre
3328:1:4:9:Robe toile d'araignée
6243:2:4:18:Robe verte en laine
5767:1:4:9:Robe violette
2613:1:4:13:Robe à double couture
3260:1:4:4:Robe écarlate d'initié
18645:1:0:53:Robot d'alarme gnome
279949:1:0:28:Robot réparateur
18232:1:0:60:Robot réparateur 74A
279950:1:0:4:Robot vendeur de composants
17026:1:15:60:Ronceterre sauvage
2534:1:2:44:Rondache
1178:1:0:8:Roquette explosive
3420:1:4:40:Rose noire
3419:1:4:20:Rose rouge
15994:1:7:52:Rouage en thorium
213383:3:7:40:Rouages polis en vrai-argent
17406:1:0:15:Roue de fromage de fête
279943:1:0:28:Rouet
13758:1:7:45:Rouget cru
13885:1:15:45:Rouget de 34 livres
13886:1:15:45:Rouget de 37 livres
13882:1:15:45:Rouget de 42 livres
13883:1:15:45:Rouget de 45 livres
13884:1:15:45:Rouget de 49 livres
13887:1:15:45:Rouget de 52 livres
232438:1:0:45:Rouget fumé
2997:1:7:25:Rouleau d'étoffe de laine
4305:1:7:35:Rouleau d'étoffe de soie
2996:1:7:10:Rouleau d'étoffe en lin
14048:1:7:55:Rouleau d'étoffe runique
4339:1:7:45:Rouleau de tisse-mage
22895:1:0:65:Roulés à la cannelle invoqués
7910:2:7:50:Rubis étoilé
3745:1:12:1:Rune d'ouverture
203726:2:0:1:Rune de Cutty
22682:3:7:80:Rune de givre
208767:2:0:1:Rune de guérison
208764:2:0:1:Rune de l’esprit
203992:2:0:1:Rune de supercherie
17031:1:15:20:Rune de téléportation
17032:1:15:40:Rune des portails
20520:2:7:55:Rune ténébreuse
279965:1:0:28:Râtelier de pêche
279941:1:0:28:Râtelier de tannage
211427:3:12:1:Réceptacle d’âme
23022:1:15:1:Récompense du bougon
1217:1:12:1:Récompense inconnue
279985:1:0:28:Récupérateur arcanique
18638:3:4:58:Réflectoflamme hyper-radiant
18634:3:4:52:Réflectoglace gyrogivre
18639:3:4:60:Réflectombre ultra-flash
19221:1:0:1:Réserve spéciale de Sombrelune
18945:1:12:1:Résidu de sombrefer
247884:1:7:5:Résidu lumineux
8633:1:15:40:Rênes de léopard
12325:3:15:40:Rênes de léopard
18767:4:15:60:Rênes de sabre-de-brume rapide
12302:4:15:60:Rênes de sabre-de-givre
18766:4:15:60:Rênes de sabre-de-givre rapide
8631:3:15:40:Rênes de sabre-de-givre rayé
8632:3:15:40:Rênes de sabre-de-givre tacheté
18768:4:15:60:Rênes de sabre-de-l'aube rapide
274706:3:15:40:Rênes de sabre-de-l’aube rayé
8627:1:15:40:Rênes de sabre-de-nuit
12303:4:15:60:Rênes de sabre-de-nuit
8629:3:15:40:Rênes de sabre-de-nuit rayé
8628:1:15:40:Rênes de sabre-de-nuit tacheté
18902:4:15:60:Rênes de sabre-tempête rapide
8630:1:15:40:Rênes de tigre du Bengale
12327:3:15:40:Rênes de tigre à dents de sabre doré
12326:3:15:40:Rênes de tigre à dents de sabre fauve
20381:2:7:63:Rêvécaille
12210:1:0:25:Rôti de raptor
19183:1:0:1:Sable de sablier
3319:1:2:9:Sabre court
5574:1:1:15:Sac blanc en cuir
856:1:1:15:Sac bleu en cuir
20767:1:15:40:Sac couvert de crasse
22251:2:1:55:Sac d'herbes cénarien
22295:1:15:1:Sac de cartes
277715:1:1:5:Sac de composants en cuir léger
253667:1:1:15:Sac de composants en laine
253664:1:1:5:Sac de composants en lin
253973:1:1:25:Sac de composants en soie
254035:1:1:35:Sac de composants en tisse-mage
254133:1:1:60:Sac de composants en étoffe lunaire
254079:1:1:52:Sac de composants en étoffe runique
254139:1:1:62:Sac de composants sans fond
21193:3:1:62:Sac de D'Sak
11938:1:15:1:Sac de gemmes
17962:2:15:1:Sac de gemmes bleu
17964:2:15:1:Sac de gemmes gris
17965:2:15:1:Sac de gemmes jaune
17969:2:15:1:Sac de gemmes rouge
17963:2:15:1:Sac de gemmes vert
22283:1:15:1:Sac de pain artisanal
13330:1:1:1:Sac de radis de Derek
279271:4:1:65:Sac d’âme gangresang
2657:1:1:15:Sac en cuir rouge
21341:3:1:57:Sac en gangrétoffe
21342:4:1:60:Sac en gangrétoffe du Magma
4240:1:1:15:Sac en laine
4238:1:1:5:Sac en lin
3233:1:1:15:Sac en peau de gnoll
5081:1:1:5:Sac en peau de kodo
1470:1:1:25:Sac en peau de murloc
1685:1:1:45:Sac en peau de troll
10050:1:1:35:Sac en tisse-mage
239148:4:1:1:Sac en étoffe de l’Aube cramoisie
14155:2:1:60:Sac en étoffe lunaire
14046:1:1:52:Sac en étoffe runique
227844:3:1:60:Sac en étoffe runique renforcé de cuir
22248:2:1:55:Sac enchanté en étoffe runique
4497:1:1:25:Sac lourd marron
5765:1:1:25:Sac noir en soie
5763:1:1:15:Sac rouge en laine
5762:1:1:5:Sac rouge en lin
10051:1:1:35:Sac rouge en tisse-mage
14156:3:1:62:Sac sans fond
20768:1:15:50:Sac vaseux
5573:1:1:15:Sac vert en cuir
4241:1:1:15:Sac vert en laine
5764:1:1:25:Sac vert en soie
20766:1:15:30:Sac visqueux
1977:1:1:1:Sac à 20 emplacements
3914:1:1:45:Sac à dos de compagnon
239147:3:1:1:Sac à dos de croisade
4500:2:1:55:Sac à dos de voyageur
22252:2:1:65:Sacoche de Cénarius
13223:1:12:1:Sacoche du Messager de Stratholme
1623:1:1:35:Sacoche en peau de raptor
269504:1:1:52:Sacoche fumante
4498:1:1:15:Sacoche marron en cuir
11363:1:11:15:Sacoche moyenne de poudre
21195:3:1:62:Sactastique de D'Sak
21071:1:7:20:Sagerelle crue
21072:1:0:20:Sagerelle fumée
19047:3:4:58:Sagesse des Grumegueules
18362:3:12:60:Sainte Bolognaise : Ce que la lumière ne vous dit pas
278122:1:0:55:Salade de carottes
6263:2:4:20:Salopette bleue
9751:1:4:12:Sandales de nomade
14110:1:4:13:Sandales indigènes
14086:1:4:10:Sandales perlées
792:1:4:10:Sandales tricotées
5402:1:12:1:Sang d'Anacondra
5400:1:12:1:Sang de Cobrahn
204906:1:15:1:Sang de gnoll
11382:2:7:50:Sang de la montagne
5401:1:12:1:Sang de Pythas
19933:1:15:1:Sang de scorpide luminescent
5403:1:12:1:Sang de Serpentis
208140:1:15:1:Sang de wendigo
10460:1:13:1:Sang hakkari
3356:1:7:24:Sang-royal
11444:1:0:55:Sanglier du Sinistre dévoreur
13464:1:7:52:Sansam doré
12361:2:7:55:Saphir bleu
2932:1:7:40:Sarment du tourment
4832:2:4:29:Sarong mystique
17222:1:0:45:Saucisse d'araignée
278121:1:0:25:Saucisse fumée
248821:1:7:60:Sauge démoniaque
13465:1:7:56:Sauge-argent des montagnes
13889:1:7:55:Saumon Blanchécaille cru
13901:1:15:55:Saumon de 15 livres
13902:1:15:55:Saumon de 18 livres
13903:1:15:55:Saumon de 22 livres
13904:1:15:55:Saumon de 25 livres
13905:1:15:55:Saumon de 29 livres
13906:1:15:55:Saumon de 32 livres
13760:1:7:45:Saumon solécaille cru
13932:1:0:45:Saumon solécaille poché
268109:1:15:1:Saute-poussière chanteur
288926:4:4:30:Sautoir du seigneur du Feu
8153:1:7:40:Sauvageonne
20860:2:12:1:Scarabée d'argent
20863:2:12:1:Scarabée d'argile
20865:2:12:1:Scarabée d'ivoire
20859:2:12:1:Scarabée d'or
20864:2:12:1:Scarabée d'os
20862:2:12:1:Scarabée de cristal
20858:2:12:1:Scarabée de pierre
20861:2:12:1:Scarabée en bronze
12219:1:12:1:Sceau d'ascension non décoré
16999:3:4:59:Sceau royal d'Alexis
20515:4:12:1:Sceptre abyssal
15975:2:4:31:Sceptre d'invocateur de pluie
15939:2:4:59:Sceptre de conseiller
15983:2:4:52:Sceptre de Gaïa
15941:2:4:64:Sceptre de grand conseiller
20450:1:12:1:Sceptre de signal : Eau
20447:1:12:1:Sceptre de signal : Feu
20449:1:12:1:Sceptre de signal : Pierre
20448:1:12:1:Sceptre de signal : Tonnerre
15930:2:4:56:Sceptre impérial rouge
15984:2:4:56:Sceptre opulent
9914:2:4:48:Sceptre royal
15940:2:4:62:Sceptre élégant
264218:1:9:48:Schematic: EZ-Thro Tru-Trigger
264219:1:9:48:Schematic: Tru-Trigger Frag Bomb
18661:2:9:52:Schéma : Agrandisseur de monde
16055:2:9:60:Schéma : Bombe des arcanes
16049:2:9:57:Schéma : Bombe en sombrefer
6672:2:9:37:Schéma : Bombe éclairante
7192:2:9:26:Schéma : Bottes-fusées gobelines
10606:2:9:45:Schéma : Cape parachute
10604:2:9:44:Schéma : Carabine de gros calibre en mithril
16056:2:9:61:Schéma : Carabine en arcanite sans défaut
16048:2:9:55:Schéma : Carabine en sombrefer
16043:2:9:52:Schéma : Carabine en thorium
4412:2:9:29:Schéma : Carabine vise-lune
16044:2:9:53:Schéma : Crapaud mécanique
6716:2:9:20:Schéma : Dynamite Ev-Lan
18653:2:9:53:Schéma : Défibrillateur gobelin XL
4408:2:9:15:Schéma : Ecureuil mécanique
18649:1:9:30:Schéma : Fusée bleue
18647:1:9:30:Schéma : Fusée rouge
4417:2:9:40:Schéma : Grande charge d'hydroglycérine
16041:1:9:52:Schéma : Grenade en thorium
10608:3:9:48:Schéma : Lunette de sniper
10601:2:9:35:Schéma : Lunettes d'oeil brillant
10603:2:9:44:Schéma : Lunettes d'oeil de chat
16045:2:9:54:Schéma : Lunettes de concentration extrême
10605:3:9:45:Schéma : Lunettes de fortification des sorts
16053:2:9:58:Schéma : Lunettes de maître ingénieur
4410:2:9:24:Schéma : Lunettes des ombres
17720:2:9:38:Schéma : MaîtreNeige 9000
4416:2:9:39:Schéma : Mine gobeline
16052:2:9:58:Schéma : Modulateur d'amplification vocale
4415:3:9:37:Schéma : Monocle de l'artisan
4414:2:9:33:Schéma : Mortier portable en bronze
16051:2:9:57:Schéma : Obus en thorium
4411:2:9:25:Schéma : Pare-flammes
16054:2:9:60:Schéma : Petit dragon en arcanite
13311:1:9:40:Schéma : Petit dragon mécanique
10609:1:9:50:Schéma : Petit dragon mécanique en mithril
4409:2:9:20:Schéma : Petite charge d'hydroglycérine
18656:1:9:55:Schéma : Puissante charge d'hydroglycérine
4413:2:9:32:Schéma : Rayon discombobulateur
18655:2:9:55:Schéma : Recombobulateur majeur
14639:1:9:28:Schéma : Recombobulateur mineur
18654:2:9:53:Schéma : Robot d'alarme gnome
18235:1:9:60:Schéma : Robot réparateur 74A
16042:1:9:52:Schéma : Rouages en thorium
18657:2:9:58:Schéma : Réflectoflamme hyper-radiant
18652:1:9:52:Schéma : Réflectoglace gyrogivre
18658:2:9:60:Schéma : Réflectombre ultra-flash
264228:1:9:60:Schéma : bombe de mana Ev-Lan
264207:1:9:29:Schéma : bombe en bronze SUR-T
264203:1:9:11:Schéma : bombe en cuivre SUR-T
264205:1:9:26:Schéma : bombe en cuivre XL Ev-Lan
264215:1:9:43:Schéma : bombe SUR-T
264227:1:9:60:Schéma : bombe ténébreuse Ev-Lan
264209:1:9:35:Schéma : cloche SUR-T
264214:1:9:43:Schéma : coque SUR-T
264224:1:9:50:Schéma : dynamite futée SUR-T
264208:1:9:30:Schéma : dynamite géante SUR-T
264202:1:9:5:Schéma : dynamite SUR-T
264230:1:9:60:Schéma : déchiqueteur d’urgence SUR-T – Long-Guet
264204:1:9:20:Schéma : emballage Ev-Lan
251749:2:9:1:Schéma : G.R.R.-Nade
264226:1:9:57:Schéma : grenade en thorium Ev-Lan
264213:1:9:40:Schéma : grenade Ev-Lan
284870:1:9:52:Schéma : grenade non sanctifiée
264201:1:9:5:Schéma : languette SUR-T
264212:1:9:38:Schéma : mortier en bronze Ev-Lan
264210:1:9:35:Schéma : mouton de sécurité
264211:1:9:38:Schéma : mèche ignifugée Ev-Lan
264238:1:9:60:Schéma : nitro-survolteurs SUR-T
264225:1:9:57:Schéma : obus Ev-Lan
264239:1:9:60:Schéma : piston magnétique Ev-Lan
264206:1:9:29:Schéma : rembourrage antidérapant SUR-T
251747:2:9:1:Schéma : suppresseur de vase
264229:1:9:60:Schéma : transporteur de terrain Ev-Lan vers Gadgetzan
264231:1:9:60:Schéma : transporteur de terrain SUR-VLAN vers le mont Hyjal
264223:1:9:55:Schéma : tube SUR-T
264240:1:9:60:Schéma : téléporteur SUR-T
210178:2:9:25:Schéma : unité d’autorecyclage de déchiqueteur
251748:2:9:1:Schéma : énorme fléchette tranquillisante
275824:3:2:48:Scinde-protection
8243:1:0:1:Scoubiscuits
21960:1:15:1:Sculpture sur bois
12762:1:12:1:Secret des plans
4289:1:7:10:Sel
8150:1:7:40:Sel de Fonderoc
15409:1:7:50:Sel de Fonderoc raffiné
239016:1:7:1:Sels sacrés
276468:1:15:1:Sels sacrés consacrés
19274:3:12:1:Sept d'Elémentaires
221305:3:15:1:Sept de Cauchemar
221296:3:15:1:Sept de Dunes
19235:3:12:1:Sept de Fauves
221278:3:15:1:Sept de Nature
221287:3:15:1:Sept de Plaies
19283:3:12:1:Sept de Portails
19264:3:12:1:Sept de Seigneurs de guerre
22158:1:15:1:Serment d'adoration :  Thunder Bluff
22155:1:15:1:Serment d'adoration : Darnassus
22154:1:15:1:Serment d'adoration : Forgefer
22157:1:15:1:Serment d'adoration : Fossoyeuse
21975:1:15:1:Serment d'adoration : Hurlevent
22156:1:15:1:Serment d'adoration : Orgrimmar
22159:1:15:1:Serment d'amitié :  Darnassus
22160:1:15:1:Serment d'amitié : Forgefer
22163:1:15:1:Serment d'amitié : Fossoyeuse
22178:1:15:1:Serment d'amitié : Hurlevent
22161:1:15:1:Serment d'amitié : Orgrimmar
22162:1:15:1:Serment d'amitié : Thunder Bluff
22120:1:15:1:Serment de loyauté : Darnassus
22119:1:15:1:Serment de loyauté : Forgefer
22121:1:15:1:Serment de loyauté : Fossoyeuse
22117:1:15:1:Serment de loyauté : Hurlevent
22123:1:15:1:Serment de loyauté : Orgrimmar
22122:1:15:1:Serment de loyauté : Thunder Bluff
10361:1:15:30:Serpent brun
10392:1:15:30:Serpent cramoisi
3850:2:2:35:Serpentine de jade
279964:1:0:28:Serre
8146:1:7:45:Serre cruelle
6712:1:15:20:Serrure d'entraînement
16171:1:0:55:Shinsollo
10394:1:15:30:Sifflet de chien de prairie
13317:4:15:60:Sifflet de raptor ivoire
8586:4:15:60:Sifflet de raptor rouge tacheté
8591:3:15:40:Sifflet de raptor turquoise
8592:3:15:40:Sifflet de raptor violet
8588:3:15:40:Sifflet de raptor émeraude
280794:1:15:30:Sifflet d’écureuil terrestre brun
280795:1:15:30:Sifflet d’écureuil terrestre roux
4471:1:7:5:Silex et amadou
3470:1:7:10:Silex à aiguiser brut
12644:1:7:45:Silex à aiguiser dense
3478:1:7:20:Silex à aiguiser grossier
3486:1:7:25:Silex à aiguiser lourd
7966:1:7:35:Silex à aiguiser solide
19273:3:12:1:Six d'Elémentaires
221304:3:15:1:Six de Cauchemar
221295:3:15:1:Six de Dunes
19234:3:12:1:Six de Fauves
221277:3:15:1:Six de Nature
221286:3:15:1:Six de Plaies
19282:3:12:1:Six de Portails
19263:3:12:1:Six de Seigneurs de guerre
6834:1:4:1:Smoking noir
3182:1:7:20:Soie d'araignée
14227:1:7:50:Soie d'araignée toilacier
4337:1:7:35:Soie d'araignée épaisse
10285:1:7:40:Soie des ténèbres
13844:1:15:25:Soirée automnale/hivernale
13848:1:15:25:Soirée printanière/estivale
8838:1:7:46:Soleillette
279263:4:4:65:Solerets en thorium appauvri
252601:2:4:61:Solerets en écailles de scorpide souples
1652:1:1:35:Solide boîte de repas
6365:1:2:10:Solide canne à pêche
4636:2:15:35:Solide coffret en fer
3851:2:2:31:Solide maillet en fer
7340:1:4:50:Solitaire sans défaut
7081:1:7:45:Souffle de vent
263509:1:0:15:Soufflé de Mur-Céleste
1402:1:0:12:Soufre
275609:3:4:58:Souliers de couve-colonie
275606:3:4:58:Souliers de crache-venin
3663:1:0:10:Soupe aux ailerons de murloc
16166:1:0:5:Soupe de haricots
13931:1:0:45:Soupe de lutjan nagenuit
5526:1:0:15:Soupe de palourdes
16766:1:0:45:Soupe de palourdes d'Undermine
8766:1:0:55:Soupe de rosée matinale
205952:1:0:1:Souvenir d’un monde brisé
6579:1:4:24:Spallières de défenseur
6588:1:4:23:Spallières de l'éclaireur
4700:1:4:21:Spallières en cuir gravé
277051:2:4:35:Spallières tisse-souffle azur
277043:2:4:35:Spallières tisse-souffle nuageuses
15918:2:4:38:Sphère d'invocateur
8244:3:12:1:Sphère de draenéthyste sans défaut
7610:2:4:41:Sphère de l'aurore
15946:2:4:23:Sphère de mystique
9882:2:4:43:Sphère de sorcier
15937:2:4:51:Sphère hivernale
15981:2:4:47:Sphère lunaire
15927:2:4:27:Sphère éclatante
15968:2:4:64:Sphère élunarienne
260629:1:0:1:Spiritueux spectraux
33154:2:15:1:Sprotchelin sinistre
272000:3:15:60:Statue dorée
13934:1:0:55:Steak de barracuda
250071:1:0:55:Steak de cerf fumant
2684:1:0:15:Steak de coyote
3662:1:0:15:Steak de crocilisque
268913:1:0:15:Steak de crocilisque en fin de vie
250072:1:0:55:Steak de frappe rapide
3726:1:0:15:Steak de grand ours
1015:1:7:19:Steak de loup
12209:1:0:25:Steak de loup
18045:1:0:45:Steak de loup tendre
238637:1:0:65:Steak de rôdeur
260627:1:0:55:Steak shen’dralar savoureux
249274:2:7:60:Stranglevigne
4382:1:7:29:Structure en bronze
2494:1:2:8:Stylet
250611:2:2:47:Stylet en mithril
7806:1:0:5:Sucette
18633:1:0:15:Sucette amère de Styleen
17344:1:0:5:Sucre d'orge
20769:1:15:55:Suinteux dégoûtant
19267:4:12:1:Suite d'Elémentaires
19228:4:12:1:Suite de fauves
235278:4:15:1:Suite de Fauves
19277:4:12:1:Suite de Portails
235275:4:15:1:Suite de Portails
19257:4:12:1:Suite de Seigneurs de guerre
235277:4:15:1:Suite de Seigneurs de guerre
235276:4:15:1:Suite d’Élémentaires
23224:1:0:1:Summer Gift Package
22279:1:4:1:Superbe robe noire
275626:3:4:58:Support de couverain
275623:3:4:58:Support de sangtaille
11584:1:0:5:Surprise aux pommes de cactus
16971:1:0:45:Surprise de palourdes
5473:1:0:10:Surprise du scorpide
17033:1:15:30:Symbole de divinité
21177:1:15:60:Symbole des rois
4397:1:4:40:Système d'occultation gnome
6453:1:0:26:Sérum anti-venin supérieur
12781:3:2:57:Sérénité
1196:1:2:14:Tabard
142504:2:4:1:Tabard caché
5976:1:4:1:Tabard de guilde
282294:1:4:1:Tabard de guilde
1036:1:9:16:Tablette d'Annuler maladie
1063:1:9:26:Tablette d'Annuler maladie II
1033:1:9:18:Tablette d'Annuler poison
1061:1:9:26:Tablette d'Annuler poison II
1035:1:9:10:Tablette d'Appel des esprits
1603:1:9:40:Tablette d'Appel des esprits II
9037:1:9:1:Tablette d'Arme Croque-roc
9053:1:9:16:Tablette d'Arme Croque-roc II
9082:1:9:30:Tablette d'Arme Croque-roc III
9129:1:9:44:Tablette d'Arme Croque-roc IV
9175:1:9:58:Tablette d'Arme Croque-roc V
9057:1:9:20:Tablette d'Arme de givre
9090:1:9:34:Tablette d'Arme de givre II
9139:1:9:48:Tablette d'Arme de givre III
9073:1:9:26:Tablette d'arme furie-des-vents
9101:1:9:40:Tablette d'arme furie-des-vents II
9160:1:9:54:Tablette d'arme furie-des-vents III
1052:1:9:14:Tablette d'Armure spirituelle II
1589:1:9:28:Tablette d'Armure spirituelle III
1588:1:9:22:Tablette d'Eclair de glace III
1031:1:9:6:Tablette d'Eclair de lave
1053:1:9:14:Tablette d'Eclair de lave II
3132:1:9:30:Tablette d'Eclair de lave IV
4184:1:9:38:Tablette d'Eclair de lave V
9132:1:9:46:Tablette d'Eclair de lave VI
9156:1:9:54:Tablette d'Eclair de lave VII
1037:1:9:10:Tablette d'Eclair II
1058:1:9:18:Tablette d'Eclair III
3129:1:9:26:Tablette d'Eclair IV
4178:1:9:34:Tablette d'Eclair V
9123:1:9:42:Tablette d'Eclair VI
9145:1:9:50:Tablette d'Eclair VII
9169:1:9:58:Tablette d'Eclair VIII
1049:1:9:12:Tablette d'Expiation
9087:1:9:32:Tablette d'Expiation II
5696:1:9:4:Tablette d'Horion
9047:1:9:10:Tablette d'Horion de flammes
9054:1:9:18:Tablette d'Horion de flammes II
9074:1:9:28:Tablette d'Horion de flammes III
9184:1:9:40:Tablette d'Horion de flammes IV
9151:1:9:52:Tablette d'Horion de flammes V
23320:3:9:60:Tablette d'Horion de flammes VI
9079:1:9:30:Tablette d'Horion de foudre
9124:1:9:42:Tablette d'Horion de foudre II
9159:1:9:54:Tablette d'Horion de foudre III
9058:1:9:20:Tablette d'Horion de givre
9089:1:9:34:Tablette d'Horion de givre II
9135:1:9:46:Tablette d'Horion de givre III
9174:1:9:58:Tablette d'Horion de givre IV
9039:1:9:4:Tablette d'Horion de terre
9044:1:9:8:Tablette d'Horion de terre II
9051:1:9:14:Tablette d'Horion de terre III
9069:1:9:24:Tablette d'Horion de terre IV
9095:1:9:36:Tablette d'Horion de terre V
9142:1:9:48:Tablette d'Horion de terre VI
9177:1:9:60:Tablette d'Horion de terre VII
3126:1:9:12:Tablette d'Horion II
3127:1:9:20:Tablette d'Horion III
4173:1:9:28:Tablette d'Horion IV
4174:1:9:36:Tablette d'Horion V
5698:1:9:8:Tablette de Bouclier de foudre
1048:1:9:16:Tablette de Bouclier de foudre II
1591:1:9:24:Tablette de Bouclier de foudre III
4175:1:9:32:Tablette de Bouclier de foudre IV
9100:1:9:40:Tablette de Bouclier de foudre V
9137:1:9:48:Tablette de Bouclier de foudre VI
9162:1:9:56:Tablette de Bouclier de foudre VII
4189:1:9:32:Tablette de Chaîne d'éclairs
9102:1:9:40:Tablette de Chaîne d'éclairs II
9140:1:9:48:Tablette de Chaîne d'éclairs III
9167:1:9:56:Tablette de Chaîne d'éclairs IV
5703:1:9:20:Tablette de Coup de tonnerre
4172:1:9:36:Tablette de Coup de tonnerre II
5707:1:9:26:Tablette de Double vue
1034:1:9:22:Tablette de Force permanente
4176:1:9:36:Tablette de Force permanente II
5708:1:9:24:Tablette de Forme éthérée
4180:1:9:34:Tablette de Forme éthérée II
9062:1:9:22:Tablette de Guérison des maladies
9059:1:9:10:Tablette de Langue de feu
9064:1:9:22:Tablette de Langue de feu II
9094:1:9:36:Tablette de Langue de feu III
9148:1:9:50:Tablette de Langue de feu IV
5699:1:9:12:Tablette de Loup fantôme
5711:1:9:30:Tablette de Loup fantôme II
5709:1:9:28:Tablette de Marche sur l'eau
4170:1:9:30:Tablette de Rappel astral
4185:1:9:40:Tablette de Rappel astral (groupe)
9048:1:9:12:Tablette de Renaissance
5704:1:9:20:Tablette de Respiration aquatique
1038:1:9:8:Tablette de Restauration II
1057:1:9:16:Tablette de Restauration III
3130:1:9:24:Tablette de Restauration IV
4179:1:9:32:Tablette de Restauration V
5716:1:9:40:Tablette de Restauration VI
4186:1:9:32:Tablette de résistance au Feu
4177:1:9:32:Tablette de résistance à la Nature
9183:1:9:40:Tablette de Salve de guérison
9133:1:9:46:Tablette de Salve de guérison II
9157:1:9:54:Tablette de Salve de guérison III
1597:1:9:20:Tablette de Tempête de foudre
1619:1:9:30:Tablette de Tempête de foudre II
5715:1:9:40:Tablette de Tempête de foudre III
1032:1:9:8:Tablette de Totem d'agitation
5702:1:9:18:Tablette de Totem d'agitation II
4171:1:9:28:Tablette de Totem d'agitation III
4181:1:9:38:Tablette de Totem d'agitation IV
4168:1:9:16:Tablette de Totem d'enracinement
5714:1:9:34:Tablette de Totem d'enracinement II
4188:1:9:40:Tablette de Totem d'invisibilité
9046:1:9:10:Tablette de Totem de Force de la Terre
9067:1:9:24:Tablette de Totem de Force de la Terre II
9098:1:9:38:Tablette de Totem de Force de la Terre III
9150:1:9:52:Tablette de Totem de Force de la Terre IV
21292:3:9:60:Tablette de Totem de force de la terre V
9078:1:9:30:Tablette de Totem de Glèbe
9125:1:9:42:Tablette de Totem de Grâce aérienne
9164:1:9:56:Tablette de Totem de Grâce aérienne II
21293:3:9:60:Tablette de Totem de grâce aérienne III
9041:1:9:6:Tablette de Totem de lien terrestre
9076:1:9:18:Tablette de Totem de Magma
9097:1:9:38:Tablette de Totem de Magma II
9138:1:9:48:Tablette de Totem de Magma III
9171:1:9:58:Tablette de Totem de Magma IV
3133:1:9:30:Tablette de Totem de mana
9071:1:9:26:Tablette de Totem de mana
9093:1:9:36:Tablette de Totem de mana II
9136:1:9:46:Tablette de Totem de mana III
9166:1:9:56:Tablette de Totem de mana IV
9096:1:9:38:Tablette de Totem de Purification des maladies
9063:1:9:22:Tablette de Totem de Purification du poison
9075:1:9:18:Tablette de Totem de résistance au Feu
9127:1:9:42:Tablette de Totem de résistance au Feu II
9170:1:9:58:Tablette de Totem de résistance au Feu III
9066:1:9:24:Tablette de Totem de résistance au Givre
9185:1:9:38:Tablette de Totem de résistance au Givre II
9158:1:9:54:Tablette de Totem de résistance au Givre III
9080:1:9:30:Tablette de Totem de résistance à la Nature
9130:1:9:44:Tablette de Totem de résistance à la Nature II
9178:1:9:60:Tablette de Totem de résistance à la Nature III
5697:1:9:6:Tablette de Totem de soins
4183:1:9:36:Tablette de Totem de soins  V
5700:1:9:12:Tablette de Totem de soins II
5705:1:9:20:Tablette de Totem de soins III
5710:1:9:28:Tablette de Totem de soins IV
3125:1:9:10:Tablette de Totem du serpent II
5706:1:9:20:Tablette de Totem du serpent III
5712:1:9:30:Tablette de Totem du serpent IV
4187:1:9:40:Tablette de Totem du serpent V
9084:1:9:32:Tablette de Totem Furie-des-vents
9134:1:9:46:Tablette de Totem Furie-des-vents II
9180:1:9:60:Tablette de Totem Furie-des-vents III
9043:1:9:8:Tablette de Totem Griffe de pierre
9055:1:9:18:Tablette de Totem Griffe de pierre II
9077:1:9:18:Tablette de Totem Griffe de pierre III
9099:1:9:38:Tablette de Totem Griffe de pierre IV
9141:1:9:48:Tablette de Totem Griffe de pierre V
9176:1:9:58:Tablette de Totem Griffe de pierre VI
9081:1:9:30:Tablette de Totem guérisseur II
9103:1:9:40:Tablette de Totem guérisseur III
9147:1:9:50:Tablette de Totem guérisseur IV
9181:1:9:60:Tablette de Totem guérisseur V
9188:1:9:20:Tablette de Totem incendiaire II
9083:1:9:30:Tablette de Totem incendiaire III
9104:1:9:40:Tablette de Totem incendiaire IV
9146:1:9:50:Tablette de Totem incendiaire V
9182:1:9:60:Tablette de Totem incendiaire VI
9072:1:9:26:Tablette de Totem Langue de feu
9126:1:9:42:Tablette de Totem Langue de feu II
9165:1:9:56:Tablette de Totem Langue de feu III
9049:1:9:12:Tablette de Totem Nova de feu
9065:1:9:22:Tablette de Totem Nova de feu II
9085:1:9:32:Tablette de Totem Nova de feu III
9128:1:9:42:Tablette de Totem Nova de feu IV
9152:1:9:52:Tablette de Totem Nova de feu V
9052:1:9:14:Tablette de Totem Peau de pierre II
9068:1:9:24:Tablette de Totem Peau de pierre III
9091:1:9:34:Tablette de Totem Peau de pierre IV
9131:1:9:44:Tablette de Totem Peau de pierre V
9161:1:9:54:Tablette de Totem Peau de pierre VI
5701:1:9:14:Tablette de Totem sentinelle
9092:1:9:34:Tablette de Totem sentinelle
5713:1:9:32:Tablette de Trait de tonnerre
9040:1:9:6:Tablette de Vague de soins II
9050:1:9:12:Tablette de Vague de soins III
9056:1:9:18:Tablette de Vague de soins IV
9168:1:9:56:Tablette de Vague de soins IX
9070:1:9:24:Tablette de Vague de soins V
9086:1:9:32:Tablette de Vague de soins VI
9105:1:9:40:Tablette de Vague de soins VII
9143:1:9:48:Tablette de Vague de soins VIII
21291:3:9:60:Tablette de Vague de soins X
1030:1:9:10:Tablette de Volonté inflexible
4169:1:9:24:Tablette de Volonté inflexible II
4182:1:9:38:Tablette de Volonté inflexible III
1029:1:9:4:Tablette du totem du serpent
7427:2:4:31:Talisman céruléen
5029:2:4:47:Talisman du seigneur naga
15846:1:0:50:Tamis à sel
17183:1:4:3:Targe abîmée
2441:1:4:22:Targe annelée
17188:1:4:19:Targe annelée
1193:1:4:17:Targe cerclée
17187:1:4:14:Targe cerclée
4820:2:4:25:Targe de gardien
3648:1:4:9:Targe de guerrier
4821:2:4:23:Targe de l'ours
7109:1:4:9:Targe de pionnier
2443:1:4:37:Targe en métal
17189:1:4:34:Targe en métal
2444:1:4:50:Targe ornée
17190:1:4:47:Targe ornée
15006:1:4:9:Targe primordiale
2442:1:4:27:Targe renforcée
17192:1:4:24:Targe renforcée
2377:1:4:10:Targe ronde
17185:1:4:8:Targe ronde
3649:1:4:11:Targe tribale
1166:1:4:5:Targe ébréchée
252026:1:0:15:Tarte aux aérelles
8950:1:0:55:Tarte aux cerises maison
22175:1:15:1:Tartelette sortie du four
6260:1:7:10:Teinture bleue
249409:2:7:25:Teinture céruléenne
9210:1:7:49:Teinture fantôme
4340:1:7:25:Teinture grise
4341:1:7:25:Teinture jaune
249430:2:7:45:Teinture magenta
2325:1:7:40:Teinture noire
6261:1:7:35:Teinture orange
4342:1:7:50:Teinture pourpre
10290:1:7:50:Teinture rose
2604:1:7:10:Teinture rouge
2605:1:7:15:Teinture verte
249431:2:7:60:Teinture viridienne
253884:2:4:55:Template Item
273455:1:0:1:Template Vellum [DNT]
18704:4:12:71:Tendon de dragon bleu adulte
279978:1:0:4:Tente du camp
18258:2:12:55:Tenue d'ogre gordok
7067:1:7:25:Terre élémentaire
2449:1:7:5:Terrestrine
20541:1:12:1:Texte du crépuscule décodé
20545:1:12:1:Texte du crépuscule décodé
20552:1:12:1:Texte du crépuscule décodé
20676:1:12:1:Texte du crépuscule décodé
20677:1:12:1:Texte du crépuscule décodé
20678:1:12:1:Texte du crépuscule décodé
20679:1:12:1:Texte du crépuscule décodé
5095:1:0:15:Thon arc-en-ciel
6361:1:7:15:Thon arc-en-ciel cru
6646:1:15:15:Thon boursouflé
250533:2:4:34:Thorax doré dur
2686:1:0:1:Thunder Ale
249867:1:0:25:Thé aux racines
7676:1:0:15:Thé de chardon
10841:1:0:35:Thé de dorépine
249865:1:0:5:Thé de sérénité
249868:1:0:35:Thé de triage
249870:1:0:55:Thé des sages
17405:1:15:35:Thé du jardin vert
249869:1:0:45:Thé du soleil
249866:1:0:15:Thé royal
3854:2:2:40:Tigresse glaciale
2490:1:2:9:Tomahawk
4959:1:2:7:Tomahawk de jet
2482:1:2:3:Tomahawk inférieur
3369:1:7:24:Tombeline
8807:1:9:18:Tome d'Amplification de la magie
8821:1:9:30:Tome d'Amplification de la magie II
8855:1:9:42:Tome d'Amplification de la magie III
8882:1:9:54:Tome d'Amplification de la magie IV
974:1:9:10:Tome d'Armure de givre II
5648:1:9:20:Tome d'Armure de givre III
994:1:9:30:Tome d'Armure de glace
3099:1:9:40:Tome d'Armure de glace II
8865:1:9:50:Tome d'Armure de glace II
8891:1:9:60:Tome d'Armure de glace IV
4157:1:9:12:Tome d'Atténuation de la magie
8813:1:9:24:Tome d'Atténuation de la magie II
8834:1:9:36:Tome d'Atténuation de la magie III
8863:1:9:48:Tome d'Atténuation de la magie IV
8894:1:9:60:Tome d'Atténuation de la magie V
3090:1:9:4:Tome d'Eclair de givre
986:1:9:8:Tome d'Eclair de givre II
4151:1:9:20:Tome d'Eclair de givre IV
8867:1:9:50:Tome d'Eclair de givre IX
8816:1:9:26:Tome d'Eclair de givre V
8828:1:9:32:Tome d'Eclair de givre VI
8842:1:9:38:Tome d'Eclair de givre VII
8856:1:9:44:Tome d'Eclair de givre VIII
8884:1:9:56:Tome d'Eclair de givre X
21214:3:9:60:Tome d'Eclair de givre XI
1568:1:9:30:Tome d'Elémentaire d'eau
4155:1:9:40:Tome d'Elémentaire d'eau II
975:1:9:10:Tome d'Entraves de glace
1004:1:9:30:Tome d'Entraves de glace II
8804:1:9:14:Tome d'Explosion des arcanes
8812:1:9:22:Tome d'Explosion des arcanes II
8822:1:9:30:Tome d'Explosion des arcanes III
8898:1:9:38:Tome d'Explosion des arcanes IV
8837:1:9:46:Tome d'Explosion des arcanes V
8880:1:9:54:Tome d'Explosion des arcanes VI
18600:3:9:56:Tome d'Illumination des arcanes
8802:1:9:1:Tome d'Intelligence des arcanes
3091:1:9:14:Tome d'Intelligence des arcanes II
3102:1:9:28:Tome d'Intelligence des arcanes III
8852:1:9:42:Tome d'Intelligence des arcanes IV
8883:1:9:56:Tome d'Intelligence des arcanes V
4160:1:9:38:Tome d'Invisibilité
1002:1:9:26:Tome d'Invisibilité inférieure
8870:1:9:50:Tome d'Invisibilité supérieure
5644:1:9:4:Tome d'Invocation d'eau
3097:1:9:10:Tome d'Invocation d'eau II
5650:1:9:20:Tome d'Invocation d'eau III
4150:1:9:30:Tome d'Invocation d'eau IV
8850:1:9:40:Tome d'Invocation d'eau V
8868:1:9:50:Tome d'Invocation d'eau VI
8892:1:9:60:Tome d'Invocation d'eau VII
4145:1:9:28:Tome d'Invocation de gemme de mana
4141:1:9:6:Tome d'Invocation de nourriture
4143:1:9:12:Tome d'Invocation de nourriture II
4147:1:9:22:Tome d'Invocation de nourriture III
4152:1:9:32:Tome d'Invocation de nourriture IV
8853:1:9:42:Tome d'Invocation de nourriture V
8871:1:9:52:Tome d'Invocation de nourriture VI
22897:3:9:60:Tome d'Invocation de nourriture VII
8861:1:9:48:Tome d'Invoquer Gemme de mana III
5649:1:9:20:Tome de Blizzard
3100:1:9:28:Tome de Blizzard II
8832:1:9:36:Tome de Blizzard II
8857:1:9:44:Tome de Blizzard IV
8872:1:9:52:Tome de Blizzard V
8895:1:9:60:Tome de Blizzard VI
966:1:9:8:Tome de Bouclier de givre
980:1:9:20:Tome de Bouclier de givre II
4149:1:9:34:Tome de Bouclier de givre III
8808:1:9:20:Tome de Bouclier de mana
8818:1:9:28:Tome de Bouclier de mana II
8833:1:9:36:Tome de Bouclier de mana III
8858:1:9:44:Tome de Bouclier de mana IV
8873:1:9:52:Tome de Bouclier de mana V
8896:1:9:60:Tome de Bouclier de mana VI
8803:1:9:6:Tome de Boule de feu
973:1:9:12:Tome de Boule de feu II
992:1:9:12:Tome de Boule de feu III
4161:1:9:18:Tome de Boule de feu IV
8860:1:9:48:Tome de Boule de feu IX
8814:1:9:24:Tome de Boule de feu V
8824:1:9:30:Tome de Boule de feu VI
8835:1:9:36:Tome de Boule de feu VII
8851:1:9:42:Tome de Boule de feu VIII
8877:1:9:54:Tome de Boule de feu X
8890:1:9:60:Tome de Boule de feu XI
21279:3:9:60:Tome de Boule de feu XII
8811:1:9:22:Tome de Brûlure
8819:1:9:28:Tome de Brûlure II
8830:1:9:34:Tome de Brûlure III
8899:1:9:40:Tome de Brûlure IV
8847:1:9:46:Tome de Brûlure V
8874:1:9:52:Tome de Brûlure VI
8887:1:9:58:Tome de Brûlure VII
3089:1:9:16:Tome de Choc de flammes
3092:1:9:32:Tome de Choc de flammes II
3093:1:9:24:Tome de Choc de flammes II
8848:1:9:40:Tome de Choc de flammes IV
8864:1:9:48:Tome de Choc de flammes V
8886:1:9:56:Tome de Choc de flammes VI
4148:1:9:24:Tome de Contre-sort
8815:1:9:26:Tome de Cône de froid
8829:1:9:34:Tome de Cône de froid II
8854:1:9:42:Tome de Cône de froid III
8866:1:9:50:Tome de Cône de froid IV
8888:1:9:58:Tome de Cône de froid V
976:1:9:18:Tome de Délivrance de la malédiction
8806:1:9:18:Tome de Délivrance de la malédiction inférieure
8805:1:9:16:Tome de Détection de la magie
985:1:9:18:Tome de Déverrouillage de Khadgar
8881:1:9:54:Tome de Déverrouillage de Khadgar
1567:1:9:30:Tome de Déverrouillage de Khadgar II
4158:1:9:42:Tome de Déverrouillage de Khadgar II
1574:1:9:20:Tome de Gardien de feu
8820:1:9:30:Tome de Gardien de feu II
8843:1:9:40:Tome de Gardien de feu III
8869:1:9:50:Tome de Gardien de feu IV
8897:1:9:60:Tome de Gardien de feu V
967:1:9:22:Tome de Gardien de givre
8876:1:9:32:Tome de Gardien de givre II
8825:1:9:42:Tome de Gardien de givre III
8875:1:9:52:Tome de Gardien de givre IV
22890:3:9:60:Tome de Gardien de givre V
6778:1:12:30:Tome de justice
3098:1:9:28:Tome de Lenteur
4154:1:9:40:Tome de Lenteur II
4142:3:9:60:Tome de Métamorphose : Cochon
4146:1:9:40:Tome de Métamorphose : Mouton
22739:3:9:60:Tome de métamorphose : Tortue
4144:3:9:60:Tome de Métamorphose : Vache
6779:1:12:40:Tome de noblesse
989:1:9:10:Tome de Nova de givre
1571:1:9:26:Tome de Nova de givre II
3101:1:9:40:Tome de Nova de givre III
8879:1:9:54:Tome de Nova de givre IV
1559:1:9:16:Tome de Projectile des arcanes II
21280:3:9:60:Tome de Projectile des arcanes VIII
4159:1:9:8:Tome de Projectiles des arcanes
4153:1:9:24:Tome de Projectiles des arcanes III
8826:1:9:32:Tome de Projectiles des arcanes IV
8849:1:9:40:Tome de Projectiles des arcanes V
8862:1:9:48:Tome de Projectiles des arcanes VI
8885:1:9:56:Tome de Projectiles des arcanes VII
1164:1:9:1:Tome de Sam
8809:1:9:8:Tome de Sommeil
8810:1:9:20:Tome de Sommeil II
8844:1:9:40:Tome de Sommeil III
8893:1:9:60:Tome de Sommeil IV
968:1:9:6:Tome de Trait de feu
3094:1:9:14:Tome de Trait de feu II
3095:1:9:22:Tome de Trait de feu III
8823:1:9:30:Tome de Trait de feu IV
8841:1:9:38:Tome de Trait de feu V
8859:1:9:46:Tome de Trait de feu VI
8878:1:9:54:Tome de Trait de feu VII
1554:1:9:14:Tome de Trait de givre III
5647:1:9:22:Tome de Transfert
4162:1:9:38:Tome de Transfert II
3096:1:9:12:Tome du Chute de plumes
15696:1:12:1:Tome en pièces
8840:1:9:38:Tome of Conjure Mana Gem II
8889:1:9:58:Tome of Conjure Mana Gem IV
8493:1:0:1:Tonneau de Weegli
248820:2:7:60:Torbernite
235517:1:15:60:Torche
279246:4:2:65:Torche de lumière
6182:1:4:10:Torche faible
2410:1:4:1:Torche fumante
11885:1:12:60:Torche ombreforge
254432:2:15:1:Totem centaure sculpté
23199:3:4:65:Totem de l'orage
279249:4:4:65:Totem d’urgence
2927:1:15:40:Tourment progressif
724:1:0:15:Tourte au foie de Broche-tripes
21030:1:0:45:Tourte au kimchi de Darnassus
3666:1:0:25:Tourte d'araignée fondante
12213:1:0:15:Tourte surprise
17407:1:0:35:Tourte à la viande maison de Graccu
22261:1:15:1:Tourtereau
5654:1:15:24:Toxine instantanée
20405:1:12:1:Transcription décodée de la tablette
135510:1:4:1:Transmog UI Trim Head Item
260819:2:4:60:Transporteur de terrain Ev-Lan vers Gadgetzan
260821:2:4:60:Transporteur de terrain SUR-VLAN vers le mont Hyjal
260823:2:15:60:Transporteur dimensionnel vers le mont Hyjal
18986:2:15:52:Transporteur ultra-sécurisé : Gadgetzan
17347:2:12:1:Traqueur du Syndicat (MURP)
288900:4:2:30:Trembleterre
3172:1:7:10:Tripes de sanglier
2492:1:2:7:Trique
19270:3:12:1:Trois d'Elémentaires
221301:3:15:1:Trois de Cauchemar
221292:3:15:1:Trois de Dunes
19231:3:12:1:Trois de Fauves
221274:3:15:1:Trois de Nature
221283:3:15:1:Trois de Plaies
19279:3:12:1:Trois de Portails
19260:3:12:1:Trois de Seigneurs de guerre
204690:1:0:1:Troisième fragment de rune de chasseurs de monstres
3041:2:2:31:Tromblon "Oeil du mage"
3023:1:2:21:Tromblon de gros calibre
10508:2:2:41:Tromblon en mithril
4369:2:2:21:Tromblon mortel
2509:1:2:9:Tromblon orné
2510:1:2:3:Tromblon solide
269681:3:15:40:Trotteur des trombes empyréen
269671:4:15:60:Trotteur des trombes empyréen rapide
274930:3:15:40:Trotteur des trombes ombreux
274933:4:15:60:Trotteur des trombes ombreux rapide
269682:3:15:40:Trotteur des trombes régalien
269673:4:15:60:Trotteur des trombes régalien rapide
269683:3:15:40:Trotteur des trombes tempêtueux
269678:4:15:60:Trotteur des trombes tempêtueux rapide
279968:1:0:4:Trousse de premiers soins
11590:1:0:40:Trousse de réparation mécanique
4608:1:0:45:Truffe noire brute
8364:1:0:35:Truite tête-mithril
8365:1:7:35:Truite tête-mithril crue
9265:2:12:45:Trésor caché de Cuergo
4371:1:7:21:Tube en bronze
4361:1:7:10:Tube en cuivre
10559:1:7:39:Tube en mithril
16000:1:7:39:Tube en thorium
260813:1:7:55:Tube SUR-T
10264:2:4:65:Tunique d'aventurier
20575:2:4:20:Tunique de dragonnet noir
8175:2:4:41:Tunique de la nuit
22191:4:4:72:Tunique de mailles en obsidienne
15068:2:4:62:Tunique de sabre-de-givre
12615:2:4:62:Tunique en mailles sauvages
13857:2:4:52:Tunique en étoffe runique
14382:1:4:1:Tunique endurante
252484:4:4:61:Tunique grumegueule
2317:2:4:20:Tunique noire en cuir
22661:4:4:80:Tunique polaire
13869:2:4:51:Tunique tisse-givre
795:1:4:10:Tunique tricotée
4243:2:4:17:Tunique élégante en cuir
14130:2:4:61:Turban en tisse-sorcier
210146:1:0:1:Turbochargeur de déchiqueteur
7506:2:4:25:Télécommande universelle gnome
260830:2:0:60:Téléporteur SUR-T
4604:1:0:5:Tête de champignon sylvestre
20337:1:0:1:Tête de gnome sur une pique
281282:1:0:47:Un petit quelque chose
216637:1:15:1:Un tas de pièces aléatoires
18664:1:15:1:Un traité sur les grades
4098:1:12:45:Une note soigneusement pliée
210147:1:0:1:Unité d’autorecyclage de déchiqueteur
4639:1:12:1:Varech enchanté
5480:1:0:25:Venaison dégraissée
13546:1:0:35:Ventre-rouge
7307:1:0:30:Ver mangeur de chair
6532:1:0:30:Verroterie
6529:1:0:10:Verroterie brillante
279261:4:2:65:Vertmartel
10036:1:4:35:Veste de smoking
12205:1:7:40:Viande d'araignée blanche
3173:1:7:11:Viande d'ours
6890:1:0:10:Viande d'ours fumée
5471:1:7:23:Viande de cerf
208192:1:15:1:Viande de cochon de Dun Morogh
207590:1:15:1:Viande de cochon de Durotar
1080:1:7:15:Viande de condor coriace
2673:1:7:10:Viande de coyote
12206:1:7:40:Viande de crabe tendre
2924:1:7:14:Viande de crocilisque
3667:1:7:23:Viande de crocilisque tendre
3730:1:7:21:Viande de grand ours
5467:1:7:10:Viande de kodo
5474:1:0:10:Viande de kodo rôtie
12204:1:7:35:Viande de kodo épaisse
3731:1:7:23:Viande de lion
2679:1:0:10:Viande de loup grillée
2672:1:7:5:Viande de loup maigre
12203:1:7:30:Viande de loup rouge
12208:1:7:40:Viande de loup tendre
2680:1:0:10:Viande de loup épicée
7097:1:0:5:Viande de mollet
2681:1:0:10:Viande de sanglier rôtie
12202:1:7:30:Viande de tigre
3712:1:7:30:Viande de tortue
5469:1:7:10:Viande de trotteur
252022:1:0:5:Viande de trotteur des trombes séchée
205961:1:15:1:Viande d’oiseau de Mulgore
208608:1:15:1:Viande d’oiseau de Teldrassil
729:1:7:10:Viande filandreuse de vautour
12037:1:7:30:Viande mystère
117:1:0:5:Viande séchée coriace
232344:4:0:60:Vick's VIP Pass
2504:1:2:2:Vieil arc court
2376:1:4:10:Vieil écu
6147:2:4:12:Vieille ceinture miteuse
37:1:2:2:Vieille hache
36:1:2:2:Vieille masse
876:1:4:1:Vieille targe en bois
25:1:2:2:Vieille épée courte
3357:1:7:30:Vietérule
2362:1:4:1:Vieux bouclier en bois
35:1:2:2:Vieux bâton
2508:1:2:2:Vieux tromblon
19726:2:7:60:Vignesang
260631:1:0:15:Vin arcanique
4595:1:0:1:Vin de Junglevine
9262:1:7:40:Vitriol noir
34085:1:4:1:Vêtements d’hiver rouge
34087:1:4:1:Vêtements d’hiver vert
5015:1:0:1:Wrapped Item (PT)
5014:1:0:1:Wrapping Paper (PT)
21277:1:15:60:Yéti mécanique paisible
252023:1:0:5:Zaalanarr piquant
2529:1:2:46:Zweihander
252264:1:15:1:« Or »
19774:2:7:50:Âmarite
219446:1:15:40:Écaille de dragon imprégnée du rêve
219517:1:15:50:Écaille de dragon lunaire
219402:1:15:25:Écaille de dragon touchée par le rêve
249429:2:7:60:Écaille immaculée
260623:1:0:35:Échantillon de fruits confits
9750:1:4:12:Écharpe de nomade
289081:1:0:30:Élixir Brouillecaboche
289329:1:0:30:Élixir de croissance infinie
8951:1:0:39:Élixir de défense
3389:1:0:26:Élixir de défense inférieure
13445:1:0:53:Élixir de défense supérieure
250349:1:0:45:Élixir de Force
3391:1:0:30:Élixir de force d’ogre
2454:1:0:5:Élixir de Force mineure
247755:1:0:5:Élixir de Force mineure
9206:1:0:48:Élixir de Force supérieure
250350:1:0:55:Élixir de férocité
250348:1:0:55:Élixir de la baleine
250337:1:0:55:Élixir de la chouette
250329:1:0:55:Élixir de la phalange
289321:1:0:30:Élixir de mana infini
250343:1:0:55:Élixir de puissance de la nature
6373:1:0:28:Élixir de puissance du feu
289083:1:0:30:Élixir de puissance infinie
21546:1:0:50:Élixir de puissance sacrée
289086:1:0:30:Élixir de rapidité infinie
250334:1:0:45:Élixir de robustesse
3825:1:0:35:Élixir de robustesse inférieure
250335:1:0:55:Élixir de robustesse supérieure
250328:1:0:55:Élixir de ruse
250336:1:0:55:Élixir de régénération maudite
3826:1:0:36:Élixir de sang de Troll
3388:1:0:25:Élixir de sang de Troll inférieur
20004:1:0:58:Élixir de sang de Troll majeur
3382:1:0:8:Élixir de sang de Troll mineur
289084:1:0:30:Élixir de soins infinis
250342:1:0:25:Élixir des arcanes inférieur
247754:1:0:5:Élixir des arcanes mineur
250332:1:0:45:Élixir des clercs
250331:1:0:25:Élixir des clercs inférieur
250330:1:0:5:Élixir des clercs mineur
250333:1:0:55:Élixir des clercs supérieur
210708:1:0:25:Élixir des regrets accumulés
250338:1:0:55:Élixir des sages
250351:1:0:55:Élixir du grizzly
250346:1:0:45:Élixir d’Esprit
250345:1:0:25:Élixir d’Esprit inférieur
250344:1:0:5:Élixir d’Esprit mineur
250347:1:0:55:Élixir d’Esprit supérieur
289334:1:0:30:Élixir d’expérience infinie
250354:1:0:45:Élixir d’Intelligence
289082:1:0:30:Élixir d’Intelligence infinie
250353:1:0:25:Élixir d’Intelligence inférieure
289087:1:0:30:Élixir d’opportunité infinie
250340:1:0:25:Élixir magesang inférieur
250339:1:0:5:Élixir magesang mineur
250341:1:0:55:Élixir magesang supérieur
221470:3:12:1:Émeraude de rêve
250077:1:0:15:Émincé de raptor aux deux épices
272015:1:15:60:Énorme gemme de quartz
12364:2:7:60:Énorme émeraude
277055:2:4:35:Épaulettes fil-tempête azur
277047:2:4:35:Épaulettes fil-tempête nuageuses
252558:2:4:60:Épaulettes ouvragées en cuir
252556:2:4:59:Épaulières corrompues en cuir
250486:2:4:27:Épaulières en argent fin
7932:2:4:47:Épaulières en plaques de mithril
252554:2:4:57:Épaulières en suédine bleue
252583:2:4:55:Épaulières en écailles de scorpide chargées
252592:2:4:56:Épaulières en écailles de scorpide souples
7928:2:4:45:Épaulières ornées en mithril
254033:2:4:41:Épaulières terrestres en soie
4314:2:4:22:Épaulières à double couture en laine
239017:2:7:1:Épices exquises
205948:1:0:1:Épiphanie anodine
205942:1:0:1:Épiphanie chimérique
205949:1:0:1:Épiphanie multiple
250607:2:2:41:Épée courte en mithril
274561:3:15:1:Équipement en cuir de niveau 23
274564:3:15:1:Équipement en cuir de niveau 38
274567:3:15:1:Équipement en cuir de niveau 57
274571:3:15:1:Équipement en cuir de niveau 60
274562:3:15:1:Équipement en mailles de niveau 23
274565:3:15:1:Équipement en mailles de niveau 38
274568:3:15:1:Équipement en mailles de niveau 57
274572:3:15:1:Équipement en mailles de niveau 60
274569:3:15:1:Équipement en plaques de niveau 57
274573:3:15:1:Équipement en plaques de niveau 60
274559:3:15:1:Équipement en tissu de niveau 23
274563:3:15:1:Équipement en tissu de niveau 38
274566:3:15:1:Équipement en tissu de niveau 57
274570:3:15:1:Équipement en tissu de niveau 60
279938:1:0:60:Établi de trappeur
279989:1:0:60:Établi d’anarchiste
273128:2:15:60:Étincelle d’invention
250606:2:2:38:Étoile du matin en fer
279940:1:0:28:Étude des toxines
22780:1:15:1:Œuf de murloc blanc
250078:1:0:35:Œufs brouillés géants
278117:1:0:15:Œufs durs
]==]

-- objets liés quand ramassés et fabriqués par une recette : seulement pour la fenêtre Items (pas pour
-- les Besoins : on ne peut pas les donner). Même format. Seulement ceux de GuildUp_Craft.lua.
ns.DONNEES_OBJETS_LIES = [==[
252490:3:4:20:Armure de bagarreur en cuir
252492:3:4:20:Armure de chevaucheur de tempête en cuir
252434:3:4:20:Armure de défenseur en cuir
252493:3:4:20:Armure de sagesse en cuir
252491:3:4:20:Armure de trappeur en cuir
252435:3:4:20:Armure totémique en cuir
249385:3:2:60:Baguette brillante
280306:2:4:35:Baudrier fantaisiste
253899:3:4:17:Bottes brillantes
250482:3:4:15:Bottes brillantes en cuivre
252439:3:4:22:Bottes de bagarreur en cuir
252443:3:4:22:Bottes de chevaucheur de tempête en cuir
250507:3:4:22:Bottes de croisé
252441:3:4:22:Bottes de défenseur en cuir
252469:3:4:52:Bottes de furtivité en cuir
250504:3:4:22:Bottes de garde
252470:3:4:52:Bottes de garde en cuir
250548:3:4:45:Bottes de grand gardien
250550:3:4:45:Bottes de justicier
252471:3:4:52:Bottes de mande-ciel en cuir
252563:3:4:45:Bottes de mande-ciel en mailles
250505:3:4:22:Bottes de protecteur
250549:3:4:45:Bottes de préfet
252468:3:4:52:Bottes de rôdeur en cuir
252444:3:4:22:Bottes de sagesse en cuir
250547:3:4:45:Bottes de sentinelle
252472:3:4:52:Bottes de soigneur en cuir
252565:3:4:45:Bottes de soigneur en mailles
252440:3:4:22:Bottes de trappeur en cuir
252562:3:4:45:Bottes de traqueur en mailles
250503:3:4:22:Bottes de vétéran
253893:3:4:17:Bottes des flammes
250506:3:4:22:Bottes d’acolyte
252564:3:4:45:Bottes d’escarmouche en mailles
250546:3:4:45:Bottes d’officier
253889:3:4:17:Bottes immaculées
252427:3:4:15:Bottes lueur-de-lune
253897:3:4:17:Bottes nacrées
252425:3:4:15:Bottes noires en cuir
253895:3:4:17:Bottes ombreuses
250620:3:4:15:Bottes ornées en cuivre
253891:3:4:17:Bottes soyeuses
252442:3:4:22:Bottes totémiques en cuir
250621:3:4:15:Bottes étranges en cuivre
252540:3:4:50:Brassards de furtivité en cuir
252541:3:4:50:Brassards de garde en cuir
252542:3:4:50:Brassards de mande-ciel en cuir
252571:3:4:50:Brassards de mande-ciel en mailles
252539:3:4:50:Brassards de rôdeur en cuir
252543:3:4:50:Brassards de soigneur en cuir
252573:3:4:50:Brassards de soigneur en mailles
252570:3:4:50:Brassards de traqueur en mailles
252572:3:4:50:Brassards d’escarmouche en mailles
249393:3:2:30:Bâton des âmes
249454:3:2:50:Bâton onirique
249453:3:2:50:Bâton radieux
249392:3:2:30:Bâton scintillant
16207:1:7:58:Bâtonnet runique en arcanite
6339:1:7:20:Bâtonnet runique en argent
6218:1:7:5:Bâtonnet runique en cuivre
11130:1:7:30:Bâtonnet runique en or
11145:1:7:40:Bâtonnet runique en vrai-argent
228978:3:0:60:Cachet enchanté : eaux courantes
217308:2:0:40:Cachet enchanté : innovation
260806:1:4:40:Cape d’urgence de terrain
252512:3:4:30:Casque de bagarreur en cuir
10543:2:4:41:Casque de chantier gobelin
252514:3:4:30:Casque de chevaucheur de tempête en cuir
252455:3:4:30:Casque de défenseur en cuir
10542:2:4:41:Casque de mineur gobelin
252515:3:4:30:Casque de sagesse en cuir
252513:3:4:30:Casque de trappeur en cuir
252456:3:4:30:Casque totémique en cuir
252428:3:4:17:Ceinture de bagarreur en cuir
252432:3:4:17:Ceinture de chevaucheur de tempête en cuir
250517:3:4:17:Ceinture de croisé en anneaux
252430:3:4:17:Ceinture de défenseur en cuir
252520:3:4:35:Ceinture de furtivité en cuir
250514:3:4:17:Ceinture de garde en anneaux
252460:3:4:35:Ceinture de garde en cuir
250558:3:4:35:Ceinture de grand gardien
250560:3:4:35:Ceinture de justicier
252522:3:4:35:Ceinture de mande-ciel en cuir
252589:3:4:55:Ceinture de mande-ciel en mailles
250515:3:4:17:Ceinture de protecteur en anneaux
250559:3:4:35:Ceinture de préfet
252459:3:4:35:Ceinture de rôdeur en cuir
252433:3:4:17:Ceinture de sagesse en cuir
250557:3:4:35:Ceinture de sentinelle
252523:3:4:35:Ceinture de soigneur en cuir
252591:3:4:55:Ceinture de soigneur en mailles
252429:3:4:17:Ceinture de trappeur en cuir
252521:3:4:35:Ceinture de traqueur en cuir
252588:3:4:55:Ceinture de traqueur en mailles
250513:3:4:17:Ceinture de vétéran en anneaux
250516:3:4:17:Ceinture d’acolyte en anneaux
252461:3:4:35:Ceinture d’escarmouche en cuir
252590:3:4:55:Ceinture d’escarmouche en mailles
250556:3:4:35:Ceinture d’officier
252431:3:4:17:Ceinture totémique en cuir
280307:2:4:35:Ceinturon à gadgets
250614:3:2:55:Ceste en thorium
249396:3:4:25:Champignon mystique
252504:3:4:25:Chaperon de bagarreur en cuir
252506:3:4:25:Chaperon de chevaucheur de tempête en cuir
252447:3:4:25:Chaperon de défenseur en cuir
252507:3:4:25:Chaperon de sagesse en cuir
252505:3:4:25:Chaperon de trappeur en cuir
252448:3:4:25:Chaperon totémique en cuir
252531:3:4:45:Chaussures de furtivité en cuir
252466:3:4:45:Chaussures de garde en cuir
252532:3:4:45:Chaussures de mande-ciel en cuir
252465:3:4:45:Chaussures de rôdeur en cuir
252533:3:4:45:Chaussures de soigneur en cuir
252426:3:4:15:Chaussures en écailles de Murloc
249455:3:4:50:Conduit en vrai-argent
10725:1:4:46:Coq de combat gnome
254037:3:4:45:Corde ambrée
254081:3:4:52:Corde cintrée ambrée
254089:3:4:52:Corde cintrée dorée
254085:3:4:52:Corde cintrée embrasée
254087:3:4:52:Corde cintrée noire
254091:3:4:52:Corde cintrée radieuse
254083:3:4:52:Corde cintrée écumeuse
280308:2:4:35:Corde cliquetante
254045:3:4:45:Corde dorée
254041:3:4:45:Corde embrasée
254043:3:4:45:Corde noire
254047:3:4:45:Corde radieuse
254039:3:4:45:Corde écumeuse
12782:3:2:58:Corruption
250522:3:4:27:Cotte d’anneaux argentés de croisé
250519:3:4:27:Cotte d’anneaux argentés de garde
250520:3:4:27:Cotte d’anneaux argentés de protecteur
250518:3:4:27:Cotte d’anneaux argentés de vétéran
250521:3:4:27:Cotte d’anneaux argentés d’acolyte
250492:3:4:20:Cotte d’anneaux de croisé
250489:3:4:20:Cotte d’anneaux de garde
250490:3:4:20:Cotte d’anneaux de protecteur
250488:3:4:20:Cotte d’anneaux de vétéran
250491:3:4:20:Cotte d’anneaux d’acolyte
254065:3:4:50:Crispins de flamme-du-Néant
254071:3:4:50:Crispins de lumière-du-Néant
254067:3:4:50:Crispins de perle-du-Néant
254061:3:4:50:Crispins d’or-du-Néant
254069:3:4:50:Crispins d’éclat-du-Néant
254063:3:4:50:Crispins d’écume-du-Néant
250595:3:4:62:Cuirasse en thorium enrichi
249470:3:4:55:Cœur brûlant de la montagne
249473:3:4:55:Cœur dormant de la montagne
249469:3:4:55:Cœur gelé de la montagne
253959:3:4:25:Diadème brillant
253985:3:4:30:Diadème brillant filigrané
253953:3:4:25:Diadème des flammes
253979:3:4:30:Diadème des flammes filigrané
253949:3:4:25:Diadème immaculé
253975:3:4:30:Diadème immaculé filigrané
253957:3:4:25:Diadème nacré
253983:3:4:30:Diadème nacré filigrané
253955:3:4:25:Diadème ombreux
253981:3:4:30:Diadème ombreux filigrané
253951:3:4:25:Diadème soyeux
253977:3:4:30:Diadème soyeux filigrané
10587:1:4:46:Distributeur de bombes des gobelins
249397:3:4:25:Doctrines de la Main d’argent
250578:3:4:47:Espauliers de grand gardien
250580:3:4:47:Espauliers de justicier
250579:3:4:47:Espauliers de préfet
250577:3:4:47:Espauliers de sentinelle
250576:3:4:47:Espauliers d’officier
274387:4:6:65:Flèche plumevive
10727:1:4:48:Fusil-dragon des gobelins
252548:3:4:55:Gantelets de furtivité en cuir
252549:3:4:55:Gantelets de garde en cuir
250568:3:4:40:Gantelets de grand gardien
250570:3:4:40:Gantelets de justicier
252550:3:4:55:Gantelets de mande-ciel en cuir
252585:3:4:55:Gantelets de mande-ciel en mailles
250569:3:4:40:Gantelets de préfet
252547:3:4:55:Gantelets de rôdeur en cuir
250567:3:4:40:Gantelets de sentinelle
252551:3:4:55:Gantelets de soigneur en cuir
252587:3:4:55:Gantelets de soigneur en mailles
252584:3:4:55:Gantelets de traqueur en mailles
252586:3:4:55:Gantelets d’escarmouche en mailles
250566:3:4:40:Gantelets d’officier
254095:3:4:55:Gants ambrés
253923:3:4:20:Gants brillants
252494:3:4:20:Gants de bagarreur en cuir
252498:3:4:20:Gants de chevaucheur de tempête en cuir
250512:3:4:20:Gants de croisé
252496:3:4:20:Gants de défenseur en cuir
252525:3:4:40:Gants de furtivité en cuir
250509:3:4:20:Gants de garde
252527:3:4:40:Gants de garde en cuir
250553:3:4:55:Gants de grand gardien
250555:3:4:55:Gants de justicier
252529:3:4:40:Gants de mande-ciel en cuir
250510:3:4:20:Gants de protecteur
250554:3:4:55:Gants de préfet
252524:3:4:40:Gants de rôdeur en cuir
252499:3:4:20:Gants de sagesse en cuir
250552:3:4:55:Gants de sentinelle
252530:3:4:40:Gants de soigneur en cuir
252495:3:4:20:Gants de trappeur en cuir
252526:3:4:40:Gants de traqueur en cuir
250508:3:4:20:Gants de vétéran
253917:3:4:20:Gants des flammes
254103:3:4:55:Gants dorés
250511:3:4:20:Gants d’acolyte
252528:3:4:40:Gants d’escarmouche en cuir
250551:3:4:55:Gants d’officier
254099:3:4:55:Gants embrasés
253913:3:4:20:Gants immaculés
253921:3:4:20:Gants nacrés
254101:3:4:55:Gants noirs
253919:3:4:20:Gants ombreux
254105:3:4:55:Gants radieux
253915:3:4:20:Gants soyeux
252497:3:4:20:Gants totémiques en cuir
254097:3:4:55:Gants écumeux
252516:3:4:30:Garde-jambes de bagarreur en cuir
252517:3:4:30:Garde-jambes de trappeur en cuir
250583:3:4:50:Garde-poignets de grand gardien
250585:3:4:50:Garde-poignets de justicier
250584:3:4:50:Garde-poignets de préfet
250582:3:4:50:Garde-poignets de sentinelle
250581:3:4:50:Garde-poignets d’officier
250619:3:2:63:Glaive en légionite
14154:4:4:62:Habit de vraie foi
12773:2:2:55:Hachette ornée en thorium
11604:3:4:59:Harnois en sombrefer
250502:3:4:30:Heaume de croisé en anneaux
250532:3:4:25:Heaume de croisé en anneaux argentés
250499:3:4:30:Heaume de garde en anneaux
250529:3:4:25:Heaume de garde en anneaux argentés
250500:3:4:30:Heaume de protecteur en anneaux
250530:3:4:25:Heaume de protecteur en anneaux argentés
250498:3:4:30:Heaume de vétéran en anneaux
250528:3:4:25:Heaume de vétéran en anneaux argentés
250501:3:4:30:Heaume d’acolyte en anneaux
250531:3:4:25:Heaume d’acolyte en anneaux argentés
250597:3:4:63:Heaume en thorium enrichi
249398:3:4:25:Icône en bois flotté poli
220606:3:4:60:Idole du Rêve
253997:3:4:30:Jambières brillantes
253947:3:4:25:Jambières brillantes filigranées
250497:3:4:25:Jambières de croisé en anneaux
250527:3:4:30:Jambières de croisé en anneaux argentés
250494:3:4:25:Jambières de garde en anneaux
250524:3:4:30:Jambières de garde en anneaux argentés
250495:3:4:25:Jambières de protecteur en anneaux
250525:3:4:30:Jambières de protecteur en anneaux argentés
252519:3:4:30:Jambières de sagesse en cuir
250493:3:4:25:Jambières de vétéran en anneaux
250523:3:4:30:Jambières de vétéran en anneaux argentés
253991:3:4:30:Jambières des flammes
253941:3:4:25:Jambières des flammes filigranées
250496:3:4:25:Jambières d’acolyte en anneaux
250526:3:4:30:Jambières d’acolyte en anneaux argentés
250596:3:4:63:Jambières en thorium enrichi
253987:3:4:30:Jambières immaculées
253937:3:4:25:Jambières immaculées filigranées
253995:3:4:30:Jambières nacrées
253945:3:4:25:Jambières nacrées filigranées
253993:3:4:30:Jambières ombreuses
253943:3:4:25:Jambières ombreuses filigranées
253989:3:4:30:Jambières soyeuses
253939:3:4:25:Jambières soyeuses filigranées
252458:3:4:30:Jambières totémiques en cuir
249456:3:4:50:Jarre d’essence distordue
252518:3:4:30:Kilt de chevaucheur de tempête en cuir
252457:3:4:30:Kilt de défenseur en cuir
277132:2:0:15:Lanceur de signal de supplanteur de moissonneur
228175:3:4:60:Libram de la sainte rapidité
249442:3:4:45:Libram d’invocation
280313:2:4:45:Lunettes cabossées
10545:2:4:42:Lunettes gnomes
280310:2:4:45:Lunettes molles
280311:2:4:45:Lunettes tordues
280312:2:4:45:Lunettes à bouton cassé
285281:3:2:54:Marteau de forgeron en arcanite
285280:2:2:39:Marteau de forgeron en mithril
285279:2:2:22:Marteau de forgeron fêlé
254001:3:4:35:Mules ambrées
252424:3:4:15:Mules de dragonnet noir
254009:3:4:35:Mules dorées
254005:3:4:35:Mules embrasées
254007:3:4:35:Mules noires
254011:3:4:35:Mules radieuses
254003:3:4:35:Mules écumeuses
274388:4:6:65:Munitions de frappe rapide
249394:3:4:30:Orbe de clairvoyance mystique
249395:3:4:30:Orbe des âmes
252500:3:4:25:Pantalon de bagarreur en cuir
252502:3:4:25:Pantalon de chevaucheur de tempête en cuir
252445:3:4:25:Pantalon de défenseur en cuir
252503:3:4:25:Pantalon de sagesse en cuir
252501:3:4:25:Pantalon de trappeur en cuir
252446:3:4:25:Pantalon totémique en cuir
13503:2:4:50:Pierre des alchimistes
9149:1:4:45:Pierre philosophale
250613:3:2:55:Plombée en thorium
260824:3:4:60:Pouletisateur gnome
254029:3:4:40:Protège-mains dorés
254025:3:4:40:Protège-mains embrasés
254027:3:4:40:Protège-mains noirs
254031:3:4:40:Protège-mains radieux
254023:3:4:40:Protège-mains écumeux
10645:1:4:48:Rayon mortel gnome
253971:3:4:27:Robe brillante
253911:3:4:20:Robe brillante filigranée
14152:4:4:62:Robe de l'archimage
7054:3:4:38:Robe de puissance
253965:3:4:27:Robe des flammes
253905:3:4:20:Robe des flammes filigranée
14153:4:4:62:Robe du Vide
253961:3:4:27:Robe immaculée
253901:3:4:20:Robe immaculée filigranée
253969:3:4:27:Robe nacrée
253909:3:4:20:Robe nacrée filigranée
253967:3:4:27:Robe ombreuse
253907:3:4:20:Robe ombreuse filigranée
253963:3:4:27:Robe soyeuse
253903:3:4:20:Robe soyeuse filigranée
285276:2:2:33:Sacoche de bombes en bronze
285275:2:2:18:Sacoche de bombes en cuivre
285277:2:2:46:Sacoche de bombes en fer
285278:2:2:57:Sacoche de bombes en sombrefer
254107:3:4:55:Sandales ambrées
254115:3:4:55:Sandales dorées
254111:3:4:55:Sandales embrasées
254113:3:4:55:Sandales noires
254117:3:4:55:Sandales radieuses
254109:3:4:55:Sandales écumeuses
252474:3:4:55:Sangle de furtivité en cuir
252475:3:4:55:Sangle de garde en cuir
250573:3:4:55:Sangle de grand gardien
250575:3:4:55:Sangle de justicier
252476:3:4:55:Sangle de mande-ciel en cuir
250574:3:4:55:Sangle de préfet
252473:3:4:55:Sangle de rôdeur en cuir
250572:3:4:55:Sangle de sentinelle
252477:3:4:55:Sangle de soigneur en cuir
250571:3:4:55:Sangle d’officier
12795:3:2:60:Serre de sang
249441:3:4:45:Serres de la colère
250563:3:4:52:Solerets de grand gardien
250565:3:4:52:Solerets de justicier
252577:3:4:52:Solerets de mande-ciel en mailles
250564:3:4:52:Solerets de préfet
250562:3:4:52:Solerets de sentinelle
252579:3:4:52:Solerets de soigneur en mailles
252576:3:4:52:Solerets de traqueur en mailles
252578:3:4:52:Solerets d’escarmouche en mailles
250561:3:4:52:Solerets d’officier
249443:3:4:45:Totem de protection ancestrale
228176:3:4:65:Totem du tonnerre
252508:3:4:27:Tunique de bagarreur en cuir
252510:3:4:27:Tunique de chevaucheur de tempête en cuir
252450:3:4:27:Tunique de défenseur en cuir
252511:3:4:27:Tunique de sagesse en cuir
252509:3:4:27:Tunique de trappeur en cuir
252451:3:4:27:Tunique totémique en cuir
253887:3:4:15:Écharpe ardente de novice
253935:3:4:22:Écharpe brillante
253929:3:4:22:Écharpe des flammes
253885:3:4:15:Écharpe d’arcaniste novice
253925:3:4:22:Écharpe immaculée
253933:3:4:22:Écharpe nacrée
253931:3:4:22:Écharpe ombreuse
253927:3:4:22:Écharpe soyeuse
254053:3:4:47:Épaulières de flamme-du-Néant
252535:3:4:47:Épaulières de furtivité en cuir
252536:3:4:47:Épaulières de garde en cuir
254059:3:4:47:Épaulières de lumière-du-Néant
252537:3:4:47:Épaulières de mande-ciel en cuir
252567:3:4:47:Épaulières de mande-ciel en mailles
254055:3:4:47:Épaulières de perle-du-Néant
252534:3:4:47:Épaulières de rôdeur en cuir
252538:3:4:47:Épaulières de soigneur en cuir
252569:3:4:47:Épaulières de soigneur en mailles
252566:3:4:47:Épaulières de traqueur en mailles
252568:3:4:47:Épaulières d’escarmouche en mailles
254049:3:4:47:Épaulières d’or-du-Néant
254057:3:4:47:Épaulières d’éclat-du-Néant
254051:3:4:47:Épaulières d’écume-du-Néant
]==]
