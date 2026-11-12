-- GuildUp : noms de tous les objets échangeables du jeu (ni liés quand ramassés, ni de quête,
-- ni gris), pour chercher un objet par son nom dans les Besoins même sans l'avoir sur soi.
-- Généré depuis les données du client WoW Forever 1.60.1.70862, français (wago.tools : ItemSparse).
-- Une ligne par objet : id:qualité:classe:niveau d'objet:nom (classe 7 = artisanat, 5 = composant)

local NOM_ADDON, ns = ...

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

-- objets liés quand ramassés (butin de boss, objets fabriqués…) : seulement pour la fenêtre Items
-- et l'encyclopédie (pas pour les Besoins : on ne peut pas les donner). Même format.
ns.DONNEES_OBJETS_LIES = [==[
20353:2:4:63:63 Green Frost Boots
20354:2:4:63:63 Green Frost Crown
20356:2:4:63:63 Green Frost Leggings
20357:2:4:63:63 Green Frost Mantle
20358:2:4:63:63 Green Frost Neck
20359:2:4:63:63 Green Frost Ring
20360:2:4:63:63 Green Frost Robes
20361:2:4:63:63 Green Frost Shroud
20362:2:2:63:63 Green Frost Staff
20363:2:2:63:63 Green Frost Wand
20312:2:4:63:63 Green Rogue Boots
20313:2:2:63:63 Green Rogue Bow
20315:2:4:63:63 Green Rogue Cap
20316:2:4:63:63 Green Rogue Cloak
20317:2:2:63:63 Green Rogue Dagger
20318:2:4:63:63 Green Rogue Gloves
20319:2:4:63:63 Green Rogue Neck
20320:2:4:63:63 Green Rogue Pants
20321:2:4:63:63 Green Rogue Ring
20322:2:4:63:63 Green Rogue Spaulders
20323:2:4:63:63 Green Rogue Tunic
20281:2:4:63:63 Green Warrior Bracelets
20282:2:4:63:63 Green Warrior Breastplate
20283:2:4:63:63 Green Warrior Cloak
20284:2:4:63:63 Green Warrior Gauntlets
20286:2:4:63:63 Green Warrior Helm
20287:2:4:63:63 Green Warrior Legplates
20288:2:4:63:63 Green Warrior Neck
20289:2:4:63:63 Green Warrior Pauldrons
20290:2:4:63:63 Green Warrior Ring
20291:2:4:63:63 Green Warrior Sabatons
20292:2:4:63:63 Green Warrior Waistband
20326:4:4:90:90 Epic Frost Boots
20327:4:4:90:90 Epic Frost Crown
20329:4:4:90:90 Epic Frost Leggings
20330:4:4:90:90 Epic Frost Mantle
20332:4:4:90:90 Epic Frost Neck
20333:4:4:90:90 Epic Frost Ring
20331:4:4:90:90 Epic Frost Robes
20336:4:4:90:90 Epic Frost Shroud
20334:4:2:90:90 Epic Frost Staff
20335:4:2:90:90 Epic Frost Wand
20268:4:4:90:90 Epic Rogue Boots
20278:4:2:90:90 Epic Rogue Bow
20270:4:4:90:90 Epic Rogue Cap
20276:4:4:90:90 Epic Rogue Cloak
20279:4:2:90:90 Epic Rogue Dagger
20271:4:4:90:90 Epic Rogue Gloves
20275:4:4:90:90 Epic Rogue Neck
20272:4:4:90:90 Epic Rogue Pants
20277:4:4:90:90 Epic Rogue Ring
20273:4:4:90:90 Epic Rogue Spaulders
20274:4:4:90:90 Epic Rogue Tunic
20135:4:4:90:90 Epic Warrior Bracelets
20136:4:4:90:90 Epic Warrior Breastplate
20145:4:4:90:90 Epic Warrior Cloak
20137:4:4:90:90 Epic Warrior Gauntlets
20138:4:4:90:90 Epic Warrior Helm
20139:4:4:90:90 Epic Warrior Legplates
20143:4:4:90:90 Epic Warrior Neck
20140:4:4:90:90 Epic Warrior Pauldrons
20144:4:4:90:90 Epic Warrior Ring
20141:4:4:90:90 Epic Warrior Sabatons
20142:4:4:90:90 Epic Warrior Waistband
20340:2:4:90:90 Green Frost Boots
20341:2:4:90:90 Green Frost Crown
20343:2:4:90:90 Green Frost Leggings
20344:2:4:90:90 Green Frost Mantle
20345:2:4:90:90 Green Frost Neck
20346:2:4:90:90 Green Frost Ring
20347:2:4:90:90 Green Frost Robes
20348:2:4:90:90 Green Frost Shroud
20349:2:2:90:90 Green Frost Staff
20350:2:2:90:90 Green Frost Wand
20298:2:4:90:90 Green Rogue Boots
20299:2:2:90:90 Green Rogue Bow
20301:2:4:90:90 Green Rogue Cap
20302:2:4:90:90 Green Rogue Cloak
20303:2:2:90:90 Green Rogue Dagger
20304:2:4:90:90 Green Rogue Gloves
20305:2:4:90:90 Green Rogue Neck
20306:2:4:90:90 Green Rogue Pants
20307:2:4:90:90 Green Rogue Ring
20308:2:4:90:90 Green Rogue Spaulders
20309:2:4:90:90 Green Rogue Tunic
20239:2:4:90:90 Green Warrior Bracelets
20240:2:4:90:90 Green Warrior Breastplate
20241:2:4:90:90 Green Warrior Cloak
20242:2:4:90:90 Green Warrior Gauntlets
20246:2:4:90:90 Green Warrior Helm
20247:2:4:90:90 Green Warrior Legplates
20248:2:4:90:90 Green Warrior Neck
20249:2:4:90:90 Green Warrior Pauldrons
20250:2:4:90:90 Green Warrior Ring
20251:2:4:90:90 Green Warrior Sabatons
20252:2:4:90:90 Green Warrior Waistband
281588:3:2:60:Abattage de la nature
209844:1:5:25:Abrégé de Dalaran vol. 23
226856:1:12:53:Accélérateur de flottaison guidée
20808:1:15:1:Affectation de combat
21131:1:15:1:Affectation de combat complémentaire
21132:1:15:1:Affectation logistique
21266:1:15:1:Affectation logistique
20805:1:15:1:Affectation logistique complémentaire
21386:1:15:1:Affectation logistique complémentaire
20809:1:15:1:Affectation tactique
21133:1:15:1:Affectation tactique complémentaire
5514:1:4:28:Agate de mana
20402:2:15:60:Agent de Nozdormu
13357:1:12:1:Agitateur osseux
2908:2:2:20:Aiguillon
21616:4:2:78:Aiguillon d'Huhuran
18871:4:2:78:Aiguillon de grand seigneur de guerre
21126:4:2:84:Aiguillon de la mort
272602:4:2:65:Aiguillon de qualité de grand seigneur de guerre
274419:3:2:58:Aiguillon à ours
4932:1:2:11:Aile de la harpie
21946:1:12:1:Alambic ectoplasmique
13475:2:4:55:Alliance de la famille Dalson
275837:2:2:58:Allumette de Gangrechique
209843:1:5:25:Almanach de Nar’thalas vol. 74
20413:1:0:1:Aléatoire
191280:3:0:1:Amas de spores fongiques
260169:2:4:52:Amict de chagrin
15812:2:4:56:Amict de l'orchidée
17601:3:4:63:Amict de lieutenant-commandant en satin
272501:4:4:65:Amict de qualité de magus général
272817:3:4:60:Amict de qualité en étoffe du Vide
16536:4:4:74:Amict de seigneur de guerre en soie
17047:2:4:30:Amict luminescent
11884:2:4:33:Amict lunaires
9417:3:4:47:Amulette archaïque
21529:4:4:77:Amulette de bouclier contre l'ombre
10299:2:4:31:Amulette de Gnomeregan
22657:4:4:60:Amulette de l'Aube
19491:4:4:65:Amulette de la Sombrelune
272184:2:4:43:Amulette de la vengeance
277204:2:4:23:Amulette de l’érudit
271806:2:4:43:Amulette de survivant
259892:2:4:52:Amulette de Trouilleffroi purifiée
21608:4:4:81:Amulette de Vek'nilash
21702:4:4:73:Amulette de vile sauvegarde
21507:4:4:70:Amulette des Sables changeants
16309:3:4:63:Amulette drakefeu
21712:4:4:88:Amulette du dieu déchu
272185:2:4:43:Amulette du pardon
272438:3:4:65:Analyseur de faiblesse
18609:4:2:75:Anathème
21230:1:15:60:Ancien artefact qiraji
98550:3:15:1:Ancien en fleurs
21650:4:2:77:Ancien éventreur qiraji
3209:2:2:32:Ancienne épée de guerre
3438:1:0:8:Ankh de Résurrection
4988:2:4:50:Anneau ardent en obsidienne
12102:2:4:54:Anneau aristocratique
18585:3:4:35:Anneau d'allégeance
11868:2:4:53:Anneau d'apnée
1116:2:4:31:Anneau d'argent pur
18543:4:4:66:Anneau d'Entropie
9362:2:4:31:Anneau d'or brillant
11862:2:4:52:Anneau d'os blanc
19382:4:4:83:Anneau d'élémentium pur
23065:4:4:92:Anneau de Brise-terre
6790:2:4:32:Anneau de calme
1449:2:4:24:Anneau de canalisation mineure
272406:3:4:65:Anneau de canaliste
19140:4:4:71:Anneau de cautérisation
5313:2:4:25:Anneau de clan totémique
4550:2:4:46:Anneau de Coldwater
9655:2:4:50:Anneau de concentration
19403:4:4:75:Anneau de Concentration forcée
275045:3:4:45:Anneau de corne ogre
18402:2:4:57:Anneau de cristal luminescent
20888:3:12:1:Anneau de cérémonie qiraji
19325:4:4:60:Anneau de Don Julio
21563:4:4:60:Anneau de Don Rodrigue
3235:2:4:20:Anneau de dédain
276202:2:4:45:Anneau de désengagement
23037:4:4:85:Anneau de ferveur spirituelle
20682:4:4:65:Anneau de focalisation élémentaire
23061:4:4:92:Anneau de foi
3760:2:4:32:Anneau de Fossoyeuse
18821:4:4:67:Anneau de frappe rapide
21477:3:4:74:Anneau de fureur
21677:4:4:78:Anneau de fureur qiraji
23062:4:4:92:Anneau de givrefeu
10298:2:4:30:Anneau de Gnomeregan
6678:2:4:28:Anneau de grâce elfique
21396:4:4:65:Anneau de justice éternelle
13812:2:4:58:Anneau de l'Aube
21601:4:4:81:Anneau de l'empereur Vek'lor
17692:2:4:23:Anneau de la corne
20632:4:4:71:Anneau de la déchirure d'esprit
23060:4:4:92:Anneau de la faucheuse d'os
23237:4:4:83:Anneau de la flamme éternelle
9642:2:4:50:Anneau de la grande tortue
15467:2:4:31:Anneau de la Ligue des Inventeurs
270053:2:4:35:Anneau de la ruine
21399:4:4:65:Anneau de la tempête imminente
18586:3:4:35:Anneau de Lonetree
19510:3:4:63:Anneau de légionnaire
19511:3:4:53:Anneau de légionnaire
19512:3:4:43:Anneau de légionnaire
19513:3:4:33:Anneau de légionnaire
20429:3:4:23:Anneau de légionnaire
17000:2:4:62:Anneau de l’âme en peine
20884:3:12:1:Anneau de magistrat qiraji
23064:4:4:92:Anneau de marcherêve
275043:3:4:45:Anneau de maître du sang
4549:2:4:46:Anneau de mer de feu
4118:2:4:50:Anneau de nez de Poobah
21707:4:4:73:Anneau de pensée foisonnante
23063:4:4:92:Anneau de pestecoeur
281635:3:4:35:Anneau de philanthrope
4135:2:4:35:Anneau de pierre de sang
18400:2:4:57:Anneau de pierre vivante
19514:3:4:63:Anneau de protecteur
19515:3:4:43:Anneau de protecteur
19516:3:4:53:Anneau de protecteur
19517:3:4:33:Anneau de protecteur
20439:3:4:23:Anneau de protecteur
15855:3:4:60:Anneau de protection
19147:4:4:66:Anneau de puissance de sort
21182:3:4:66:Anneau de puissance terrestre
270050:2:4:34:Anneau de rage
10739:2:4:53:Anneau de robustesse
23066:4:4:92:Anneau de rédemption
21411:4:4:65:Anneau de sagesse infinie
11869:2:4:53:Anneau de Sha'ni
19434:4:4:70:Anneau de sombre domination
19302:3:4:55:Anneau de Sombrelune
19038:2:4:48:Anneau de subtilité
19138:4:4:78:Anneau de Sulfuras
273800:2:4:58:Anneau de Thomas
23067:4:4:92:Anneau de traqueur des cryptes
21687:4:4:76:Anneau de ténèbres d'Ukko
21408:4:4:65:Anneau de vie interminable
272409:3:4:65:Anneau de vigilance
1319:2:4:25:Anneau de volonté de fer
15702:2:4:55:Anneau des chimistes
275740:3:4:61:Anneau des cycles de la nature
2043:2:4:35:Anneau des Esprits glacés
18398:3:4:63:Anneau des flots
15689:2:4:35:Anneau des marchands
21417:4:4:65:Anneau des noms inexprimés
20624:4:4:72:Anneau des non-vivants
21405:4:4:65:Anneau des ombres voilées
21526:4:4:77:Anneau des profondeurs glacées
19109:3:4:63:Anneau des racines profondes
21414:4:4:65:Anneau des secrets scellés
21483:3:4:73:Anneau des vents du désert
21836:4:4:71:Anneau du chaos de Rytssin
271808:2:4:43:Anneau du charognard
5351:2:4:20:Anneau du chasseur de primes
5622:2:4:22:Anneau du clergé
21179:3:4:62:Anneau du courroux terrestre
3739:2:4:25:Anneau du crâne
23059:4:4:92:Anneau du cuirassier
21709:4:4:88:Anneau du dieu déchu
21681:4:4:78:Anneau du dévoré
21620:4:4:78:Anneau du martyr
21596:4:4:88:Anneau du tueur de dieu
210251:1:4:20:Anneau d’argent ciselé
270109:2:4:50:Anneau d’auriculaire de Smotts
278019:2:4:35:Anneau d’excuses
270051:2:4:35:Anneau d’héritage de Ladimore
210250:1:4:20:Anneau d’or ciselé
274746:2:4:35:Anneau d’orteil de géant des mers
281252:2:4:26:Anneau en griffe de harpie
11945:2:4:53:Anneau en sombrefer
281320:3:4:32:Anneau gravé de runes
270052:2:4:35:Anneau lacustre
4535:2:4:31:Anneau mémorial de Forgefer
18760:3:4:62:Anneau nécromantique
9622:2:4:35:Anneau Reedknot
278017:2:4:35:Anneau remboursé
278018:2:4:35:Anneau renégocié
281718:2:4:1:Anneau restauré
277208:2:4:45:Anneau résolu
6669:2:4:25:Anneau sacré
9326:1:12:28:Anneau sali
2917:2:4:34:Anneau tranquille
18879:4:4:66:Anneau épais en sombrefer
270101:2:4:49:Appareil de flottaison gnome
232324:3:13:1:Appeau à oiseau
241190:2:15:1:Appeau à oiseau
19785:3:15:60:Appel de l'épervier
4546:1:0:37:Appel du raptor
208855:1:0:1:Appât de thon arc-en-ciel
18837:4:2:78:Arbalète de grand seigneur de guerre
272595:4:2:65:Arbalète de qualité de grand seigneur de guerre
277111:1:2:14:Arbalète zéphrali
22347:3:2:65:Arbalète à répétition de Fahrad
18835:4:2:78:Arc courbe de grand seigneur de guerre
273877:1:2:10:Arc court de Souffle-Bise
273879:1:2:5:Arc court élégant
5596:1:2:11:Arc d'Ashwood
19562:3:2:63:Arc d'estafette
19563:3:2:53:Arc d'estafette
19564:3:2:43:Arc d'estafette
19565:3:2:33:Arc d'estafette
20438:3:2:23:Arc d'estafette
5346:2:2:14:Arc de bataille orc
2903:2:2:15:Arc de chasse de Daryl
276686:1:2:10:Arc de chasse de novice
277254:3:2:45:Arc de cherche-vérité
20368:3:2:60:Arc de fermeté quelconque
276685:2:2:14:Arc de la milice
4110:2:2:45:Arc de maître-chasseur
17686:2:2:43:Arc de maître-chasseur
281142:1:15:1:Arc de Merrick
19558:3:2:63:Arc de voltigeur
19559:3:2:53:Arc de voltigeur
19560:3:2:43:Arc de voltigeur
19561:3:2:33:Arc de voltigeur
20437:3:2:23:Arc de voltigeur
12447:1:2:5:Arc des chardons
19114:2:2:51:Arc des Hautes-terres
3742:2:2:28:Arc des pilleurs
4931:1:2:11:Arc en noyer
275439:2:2:57:Arc en os de Bourdeflame
16996:3:2:62:Arc Gorewood
281264:2:2:29:Arc ignoble
275441:2:2:57:Arc long de crémation
270107:2:2:50:Arc long taché de sang
5817:2:2:30:Arc Lunaris
12449:1:2:5:Arc primitif
217315:2:2:27:Arc précis
281732:2:2:1:Arc restauré
277110:1:2:14:Arc zéphrali
272594:4:2:65:Arc à double courbure de qualité de grand seigneur de guerre
18330:2:12:50:Arcanum de focalisation
18331:2:12:50:Arcanum de protection
18329:2:12:50:Arcanum de rapidité
2000:2:2:35:Archeus
203754:1:5:10:Archimage Antonidas : L’autobiographie intégrale
227747:1:12:50:Archives de famille
18836:4:2:78:Arme à répétition de connétable
272842:4:2:65:Arme à répétition de qualité de connétable
271800:3:2:42:Armement magram récupéré
21232:4:15:60:Armes impériales qiraji
252490:3:4:20:Armure de bagarreur en cuir
16417:3:4:63:Armure de chevalier-capitaine en cuir
252492:3:4:20:Armure de chevaucheur de tempête en cuir
252434:3:4:20:Armure de défenseur en cuir
5420:2:4:14:Armure de la Banshee
6670:2:4:27:Armure de la panthère
3566:2:4:29:Armure de la plaie des raptors
22872:3:4:68:Armure de légionnaire en plaques
263401:2:4:11:Armure de martyr
15471:2:4:29:Armure de peau coriace
272479:3:4:60:Armure de plaques cimentières de qualité
272506:4:4:65:Armure de plaques cimentières de qualité de seigneur de guerre
260178:2:4:52:Armure de plaques de garde d’honneur
16477:4:4:74:Armure de plaques de grand maréchal
16513:3:4:63:Armure de plaques de légionnaire
272786:4:4:65:Armure de plaques de qualité de grand maréchal
16541:4:4:74:Armure de plaques de seigneur de guerre
260181:2:4:52:Armure de plaques de sentinelle
273348:4:4:65:Armure de qualité de seigneur de guerre en mailles annelées
272726:3:4:60:Armure de qualité en cuir
252493:3:4:20:Armure de sagesse en cuir
4929:1:4:9:Armure de scorpide légère
16577:4:4:74:Armure de seigneur de guerre en mailles
7950:2:4:42:Armure de Thero-shan
252491:3:4:20:Armure de trappeur en cuir
5814:2:4:30:Armure du ruisseau
257879:1:4:10:Armure en peau de frièregriffe
4508:2:4:42:Armure souillée de sang
252435:3:4:20:Armure totémique en cuir
20469:1:15:1:Articles du Vrai Croyant décodés
205183:1:15:1:Artéfact alimenté par la corruption
205182:1:15:1:Artéfact déchargé
205181:1:15:1:Artéfact non identifié
255155:1:12:1:Assemblage autocognitif de précision
272437:3:4:65:Assistant de combat adaptatif
210177:1:5:10:Ataeric : À propos des curiosités des arcanes
22589:5:2:90:Atiesh, grand bâton du Gardien
22630:5:2:90:Atiesh, grand bâton du Gardien
22631:5:2:90:Atiesh, grand bâton du Gardien
22632:5:2:90:Atiesh, grand bâton du Gardien
22737:5:15:60:Atiesh, grand bâton du Gardien
281371:2:15:61:Attracteur élémentaire
12650:1:0:1:Atténuateur en phase
19789:3:15:60:Aura prophétique
220053:2:12:1:Autorisation d’embauche : Ashenvale, mission I
220054:2:12:1:Autorisation d’embauche : Ashenvale, mission II
220055:2:12:1:Autorisation d’embauche : Ashenvale, mission III
220056:2:12:1:Autorisation d’embauche : Ashenvale, mission IV
220061:2:12:1:Autorisation d’embauche : Ashenvale, mission IX
220057:2:12:1:Autorisation d’embauche : Ashenvale, mission V
220058:2:12:1:Autorisation d’embauche : Ashenvale, mission VI
220059:2:12:1:Autorisation d’embauche : Ashenvale, mission VII
220060:2:12:1:Autorisation d’embauche : Ashenvale, mission VIII
220062:2:12:1:Autorisation d’embauche : Ashenvale, mission X
220063:2:12:1:Autorisation d’embauche : Ashenvale, mission XI
220064:2:12:1:Autorisation d’embauche : Ashenvale, mission XII
220065:2:12:1:Autorisation d’embauche : Ashenvale, mission XIII
220066:2:12:1:Autorisation d’embauche : Ashenvale, mission XIV
220067:2:12:1:Autorisation d’embauche : Ashenvale, mission XV
220068:2:12:1:Autorisation d’embauche : Ashenvale, mission XVI
220069:2:12:1:Autorisation d’embauche : Ashenvale, mission XVII
220070:2:12:1:Autorisation d’embauche : Ashenvale, mission XVIII
219963:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission I
219965:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission II
219983:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission III
219984:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission IV
219989:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission IX
219985:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission V
219986:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission VI
219987:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission VII
219988:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission VIII
219990:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission X
219991:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XI
219992:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XII
219993:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XIII
219994:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XIV
219995:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XV
219996:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XVI
219997:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XVII
219998:2:12:1:Autorisation d’embauche : bois de la Pénombre, mission XVIII
220089:2:12:1:Autorisation d’embauche : Feralas, mission I
220090:2:12:1:Autorisation d’embauche : Feralas, mission II
220091:2:12:1:Autorisation d’embauche : Feralas, mission III
220092:2:12:1:Autorisation d’embauche : Feralas, mission IV
220097:2:12:1:Autorisation d’embauche : Feralas, mission IX
220093:2:12:1:Autorisation d’embauche : Feralas, mission V
220094:2:12:1:Autorisation d’embauche : Feralas, mission VI
220095:2:12:1:Autorisation d’embauche : Feralas, mission VII
220096:2:12:1:Autorisation d’embauche : Feralas, mission VIII
220098:2:12:1:Autorisation d’embauche : Feralas, mission X
220099:2:12:1:Autorisation d’embauche : Feralas, mission XI
220100:2:12:1:Autorisation d’embauche : Feralas, mission XII
220101:2:12:1:Autorisation d’embauche : Feralas, mission XIII
220102:2:12:1:Autorisation d’embauche : Feralas, mission XIV
220103:2:12:1:Autorisation d’embauche : Feralas, mission XV
220104:2:12:1:Autorisation d’embauche : Feralas, mission XVI
220105:2:12:1:Autorisation d’embauche : Feralas, mission XVII
220106:2:12:1:Autorisation d’embauche : Feralas, mission XVIII
220071:2:12:1:Autorisation d’embauche : Hinterlands, mission I
220072:2:12:1:Autorisation d’embauche : Hinterlands, mission II
220073:2:12:1:Autorisation d’embauche : Hinterlands, mission III
220074:2:12:1:Autorisation d’embauche : Hinterlands, mission IV
220079:2:12:1:Autorisation d’embauche : Hinterlands, mission IX
220075:2:12:1:Autorisation d’embauche : Hinterlands, mission V
220076:2:12:1:Autorisation d’embauche : Hinterlands, mission VI
220077:2:12:1:Autorisation d’embauche : Hinterlands, mission VII
220078:2:12:1:Autorisation d’embauche : Hinterlands, mission VIII
220080:2:12:1:Autorisation d’embauche : Hinterlands, mission X
220081:2:12:1:Autorisation d’embauche : Hinterlands, mission XI
220082:2:12:1:Autorisation d’embauche : Hinterlands, mission XII
220083:2:12:1:Autorisation d’embauche : Hinterlands, mission XIII
220084:2:12:1:Autorisation d’embauche : Hinterlands, mission XIV
220085:2:12:1:Autorisation d’embauche : Hinterlands, mission XV
220086:2:12:1:Autorisation d’embauche : Hinterlands, mission XVI
220087:2:12:1:Autorisation d’embauche : Hinterlands, mission XVII
220088:2:12:1:Autorisation d’embauche : Hinterlands, mission XVIII
221314:1:12:1:Avis de recherche
285354:4:15:20:Azurbie
254779:2:2:12:A’sharahm, la tempête déchaînée
7970:1:0:1:B.G.A.C.
275738:3:4:61:Babiole de Jereman
228136:1:5:60:Badaboum !
20802:2:12:1:Badge cénarien de combat
20800:2:12:1:Badge cénarien de logistique
20801:2:12:1:Badge cénarien de tactique
274961:2:4:39:Bague de bruticide
22725:3:4:70:Bague de Cenarius
275044:3:4:45:Bague de combat à mort
19518:3:4:63:Bague de conseiller
19519:3:4:53:Bague de conseiller
19520:3:4:43:Bague de conseiller
19521:3:4:33:Bague de conseiller
20426:3:4:23:Bague de conseiller
19522:3:4:63:Bague de gardien du savoir
19523:3:4:53:Bague de gardien du savoir
19524:3:4:43:Bague de gardien du savoir
19525:3:4:33:Bague de gardien du savoir
20431:3:4:23:Bague de gardien du savoir
23031:4:4:83:Bague de l'inévitable
271809:2:4:43:Bague de la désolation
272407:3:4:65:Bague de Lumière bénie
271913:3:4:63:Bague de militant
271914:3:4:53:Bague de militant
271915:3:4:43:Bague de militant
271916:3:4:33:Bague de militant
22681:3:4:66:Bague de piété
19397:4:4:75:Bague de Rochenoire
22961:4:4:83:Bague de réanimation
22680:3:4:66:Bague de résolution
19376:4:4:83:Bague de rétorsion d'Archimtiros
274915:2:4:38:Bague de sacristie
23038:4:4:85:Bague des forces contre-nature
22939:4:4:83:Bague des prières inexaucées
23028:4:4:83:Bague du grêlon
19384:4:4:83:Bague du Maître-tueur de dragon
272064:3:4:63:Bague d’insurgé
272065:3:4:53:Bague d’insurgé
272066:3:4:43:Bague d’insurgé
272067:3:4:33:Bague d’insurgé
281268:1:4:9:Bague rituelle vidée d’énergie
249385:3:2:60:Baguette brillante
243065:2:15:1:Baguette brisée
5250:2:2:28:Baguette carbonisée
5244:2:2:30:Baguette consacrée
7514:3:2:40:Baguette d'Icefury
5240:2:2:21:Baguette d'Illumination
5818:2:2:30:Baguette d'éclat lunaire
5242:2:2:16:Baguette de cendres
11263:3:2:40:Baguette de force du Néant
5235:1:2:7:Baguette de l'alchimiste
21328:1:15:1:Baguette de liesse festive
270084:2:2:43:Baguette de maître-chasseur
274919:2:2:40:Baguette de néophyte
5252:2:2:21:Baguette de putréfaction
7513:3:2:40:Baguette de Ragefire
15857:3:4:60:Baguette de résistance magique
6677:2:2:26:Baguette de sortilèges
263430:2:2:10:Baguette de soufflebranche
263428:1:2:6:Baguette de sourcier
15465:2:2:28:Baguette du dard
19108:3:2:63:Baguette du froid mordant
209819:1:15:1:Baguette d’apprivoisement de wyverne
5604:2:2:13:Baguette elfique
15204:2:2:18:Baguette en pierre de lune
4547:2:2:40:Baguette gnome
209840:1:15:25:Baguette noueuse de magie sauvage
281733:2:2:1:Baguette restaurée
5092:1:2:23:Baguette Tranchecrin carbonisée
5248:2:2:37:Baguette éclairante
11950:1:0:55:Baies de fleur-de-vent
274958:1:12:1:Baies particulièrement goûteuses
22954:4:4:85:Baiser de l'araignée
18860:4:2:78:Balayeur de rue de grand seigneur de guerre
272599:4:2:65:Balayeur de rue de qualité de grand seigneur de guerre
17505:1:12:1:Balise d'Ichman
8704:2:12:43:Balise de détresse OOX-09/HL
8623:2:12:43:Balise de détresse OOX-17/TN
8705:2:12:40:Balise de détresse OOX-22/FE
17324:1:12:1:Balise de Guse
17507:1:12:1:Balise de Slidore
17506:1:12:1:Balise de Vipore
19317:2:6:54:Balle de glace
270226:2:4:50:Banane d’or
20235:1:0:35:Bandage en soie de profanateur
20244:1:0:35:Bandage en soie des Hautes-terres
272056:1:0:35:Bandage en soie des îles des Sombrelances
20067:1:0:35:Bandage en soie du bassin d'Arathi
19068:1:0:35:Bandage en soie du goulet des Chanteguerres
20232:1:0:45:Bandage en tisse-mage de profanateur
20237:1:0:45:Bandage en tisse-mage des Hautes-terres
272057:1:0:45:Bandage en tisse-mage des îles des Sombrelances
20065:1:0:45:Bandage en tisse-mage du bassin d'Arathi
19067:1:0:45:Bandage en tisse-mage du goulet des Chanteguerres
20234:1:0:55:Bandage en étoffe runique de profanateur
20243:1:0:55:Bandage en étoffe runique des Hautes-terres
272058:1:0:55:Bandage en étoffe runique des îles des Sombrelances
20066:1:0:55:Bandage en étoffe runique du bassin d'Arathi
19066:1:0:55:Bandage en étoffe runique du goulet des Chanteguerres
19307:1:0:58:Bandage épais en étoffe runique d'Alterac
281675:2:4:30:Bandeau anti-incendie de Comté-du-Lac
279391:1:4:23:Bandeau de Taurajo
274021:3:4:1:Bandeau des Tarides
274742:2:4:25:Bandelettes de Cabestan
287626:3:4:1:Bannière ambrée de maître-lame
208739:1:15:1:Bannière de guerre de la Horde
21986:1:12:1:Bannière de provocation
21983:1:12:1:Bannière de provocation incomplète
278030:2:15:35:Bannière écarlate
281253:2:2:17:Bardiche de montagnard
268548:1:12:7:Baril de poudre vide
21243:2:15:45:Barracuda luisant boursouflé
20390:1:0:55:Barre de chocolat
16789:2:2:36:Barre du capitaine Rackmore
191477:4:15:60:Barre d’attache squelettique
278468:4:4:65:Barricade de qualité de connétable
278469:4:4:65:Barricade de qualité de grand seigneur de guerre
274418:3:4:58:Barricade de terrier
271798:2:4:38:Barrière de désespoir
275051:2:4:46:Barrière du Crépuscule
275649:2:4:59:Barrière en écorce de roncier
9661:2:4:43:Barrière naturelle
275049:2:4:46:Bastion de Fort-Lointain
9607:2:4:25:Bastion de Hurlevent
275827:2:4:56:Baudrier cousu en laine
274185:4:4:65:Baudrier de qualité de chevalier-capitaine en mailles plates
274208:4:4:65:Baudrier de qualité de chevalier-capitaine en mailles rivetées
274200:4:4:65:Baudrier de qualité de chevalier-capitaine en écailles
273338:4:4:65:Baudrier de qualité de légionnaire en mailles
273346:4:4:65:Baudrier de qualité de légionnaire en mailles annelées
272540:4:4:65:Baudrier de qualité de légionnaire riveté
273367:3:4:60:Baudrier de qualité en cuir de kodo
272463:3:4:60:Baudrier de qualité en peau de dragon
273388:3:4:60:Baudrier de qualité en peau de wyrm
280306:2:4:35:Baudrier fantaisiste
257329:1:4:9:Baudrier lisse
276898:3:4:38:Baume (au cœur)
1970:1:0:24:Baume de restauration
11516:1:12:1:Baume végétal cénarien
234820:1:12:1:Bave acide
208800:1:5:10:Baxtan : Sur les magies destructrices
8644:1:12:1:Bel oeuf
281309:2:4:30:Bermuda de tranchegueule
20601:1:15:1:Besace de butin
3604:2:11:25:Besace des Veilleurs
206177:1:0:7:Beurre de pignons de pin
235786:2:7:1:Bibelot de Karazhan
12185:3:4:60:Bicorne d'amiral de la Voile sanglante
227745:1:12:50:Bijou de famille
280390:1:12:1:Bijou en pierre gravée
220775:2:12:1:Billet d’échange d’ingénierie
5768:1:12:1:Billet pour la course gnome
5769:1:12:1:Billet pour la course gobelin
274761:3:4:55:Bipeur de prêtre parachutiste
21254:1:0:55:Biscuit du Voile d'hiver
19301:1:0:60:Biscuit enrichi en manne d'Alterac
23246:1:0:1:Bière de fête flamboyante
213528:1:15:40:Bière embaumée
18284:2:0:1:Bière-massue de Kreeg
23041:4:4:90:Blason de tueur
15703:2:4:55:Blouse de chimiste
270082:2:4:42:Blouse de cérémonie
270118:3:4:54:Blouse en étoffe cendrée
18663:1:12:1:Bocal de J'eevee
226472:1:15:1:Bocal d’ombres de Stratholme
275671:2:4:59:Boisson d’agent de terrain
210330:1:15:20:Bon tuyau
20557:1:0:1:Bonbon à la citrouille de la Sanssaint
20389:1:0:55:Bonbons
209027:1:0:1:Bonbons pour crabes
11905:2:4:56:Boomerang de Linken
274720:2:4:57:Bottes abandonnées
287624:3:4:1:Bottes ambrées de maître-lame
9633:2:4:45:Bottes artisanales de Jangdor
9630:2:4:45:Bottes artisanales de Pratt
253899:3:4:17:Bottes brillantes
250482:3:4:15:Bottes brillantes en cuivre
16977:3:4:27:Bottes chanteguerres
15406:2:4:17:Bottes crustacéennes
22107:4:4:60:Bottes Cœur-Farouche
20715:3:4:63:Bottes d'arpenteur de dunes
6095:2:4:24:Bottes d'errance
11872:2:4:54:Bottes d'Eschewal
4109:2:4:41:Bottes d'Excelsior
6791:2:4:40:Bottes d'Hellion
21995:4:4:60:Bottes d'héroïsme
21373:4:4:78:Bottes d'implorateur de tempête
9645:2:4:49:Bottes d'inventeur gnome
22087:4:4:60:Bottes d'Âmeforge
4136:2:4:42:Bottes darkspear
252439:3:4:22:Bottes de bagarreur en cuir
22061:4:4:60:Bottes de belluaire
6666:2:4:22:Bottes de boueux
22468:4:4:86:Bottes de Brise-terre
860:1:4:13:Bottes de cavalier
263308:2:4:11:Bottes de chasse à la secte
16985:2:4:25:Bottes de Cherchevent
16401:3:4:63:Bottes de chevalier-lieutenant en anneaux
16392:3:4:63:Bottes de chevalier-lieutenant en cuir
16393:3:4:63:Bottes de chevalier-lieutenant en peau de dragon
16405:3:4:63:Bottes de chevalier-lieutenant en plaques
17594:3:4:63:Bottes de chevalier-lieutenant en satin
16369:3:4:63:Bottes de chevalier-lieutenant en soie
17562:3:4:63:Bottes de chevalier-lieutenant en tisse-effroi
252443:3:4:22:Bottes de chevaucheur de tempête en cuir
11919:2:4:55:Bottes de Cragplate
250507:3:4:22:Bottes de croisé
21359:4:4:78:Bottes de dispensateur de mort
6092:2:4:18:Bottes de dragonnet noir
270094:2:4:45:Bottes de dragonnet noir
9519:2:4:36:Bottes de Durtfeet
252441:3:4:22:Bottes de défenseur en cuir
11191:1:4:10:Bottes de fermier
11908:2:4:55:Bottes de fouilles de l'Archéologue
252469:3:4:52:Bottes de furtivité en cuir
250504:3:4:22:Bottes de garde
16531:3:4:63:Bottes de garde de sang en anneaux
16498:3:4:63:Bottes de garde de sang en cuir
16518:3:4:63:Bottes de garde de sang en mailles
16494:3:4:63:Bottes de garde de sang en peau de dragon
16509:3:4:63:Bottes de garde de sang en plaques
17616:3:4:63:Bottes de garde de sang en satin
17576:3:4:63:Bottes de garde de sang en tisse-effroi
252470:3:4:52:Bottes de garde en cuir
271734:1:4:1:Bottes de garde-paix shen’dorei
250548:3:4:45:Bottes de grand gardien
16558:4:4:71:Bottes de général en cuir
16573:4:4:71:Bottes de général en mailles
16554:4:4:71:Bottes de général en peau de dragon
16545:4:4:71:Bottes de général en plaques
17618:4:4:71:Bottes de général en satin
16539:4:4:71:Bottes de général en soie
17586:4:4:71:Bottes de général en tisse-effroi
250550:3:4:45:Bottes de justicier
6191:2:4:24:Bottes de Kimbra
21344:4:4:78:Bottes de l'énigme
21600:4:4:81:Bottes de l'épiphanie
12050:2:4:54:Bottes de la brume
21355:4:4:78:Bottes de la genèse
17688:2:4:40:Bottes de la jungle
270006:2:4:17:Bottes de la milice du peuple
15458:2:4:28:Bottes de la toundra
270066:2:4:39:Bottes de la tour
22744:2:4:1:Bottes de la Voile sanglante
5320:2:4:16:Bottes de lamelles matelassées
4946:1:4:10:Bottes de légèreté
271723:1:4:1:Bottes de magistère shen’dorei
252471:3:4:52:Bottes de mande-ciel en cuir
252563:3:4:45:Bottes de mande-ciel en mailles
21532:4:4:77:Bottes de manœuvre
6482:2:4:24:Bottes de marchefeu
22492:4:4:86:Bottes de marcherêve
16462:4:4:71:Bottes de maréchal en anneaux
16446:4:4:71:Bottes de maréchal en cuir
16459:4:4:71:Bottes de maréchal en peau de dragon
16483:4:4:71:Bottes de maréchal en plaques
16437:4:4:71:Bottes de maréchal en soie
17583:4:4:71:Bottes de maréchal en tisse-effroi
5399:1:4:5:Bottes de pistage
4906:1:4:7:Bottes de pluie
20186:3:4:63:Bottes de Profanateur en cuir
20187:3:4:43:Bottes de Profanateur en cuir
20188:3:4:33:Bottes de Profanateur en cuir
20189:3:4:53:Bottes de Profanateur en cuir
20167:3:4:63:Bottes de Profanateur en cuir de lézard
20168:3:4:43:Bottes de Profanateur en cuir de lézard
20169:3:4:33:Bottes de Profanateur en cuir de lézard
20170:3:4:53:Bottes de Profanateur en cuir de lézard
20159:3:4:63:Bottes de Profanateur en tissu
20160:3:4:53:Bottes de Profanateur en tissu
20161:3:4:43:Bottes de Profanateur en tissu
20162:3:4:33:Bottes de Profanateur en tissu
250505:3:4:22:Bottes de protecteur
250549:3:4:45:Bottes de préfet
19969:2:4:40:Bottes de pêche extrême de Nat Pagle
273418:4:4:65:Bottes de qualité de centurion en cuir de kodo
273336:4:4:65:Bottes de qualité de centurion en mailles
273344:4:4:65:Bottes de qualité de centurion en mailles annelées
272519:4:4:65:Bottes de qualité de centurion en peau de dragon
273410:4:4:65:Bottes de qualité de centurion en peau de wyrm
272510:4:4:65:Bottes de qualité de centurion en plaques cimentières
272570:4:4:65:Bottes de qualité de centurion en satin
272554:4:4:65:Bottes de qualité de centurion en tisse-gangrène
274237:4:4:65:Bottes de qualité de centurion en écailles
274251:4:4:65:Bottes de qualité de centurion lamellaires
272538:4:4:65:Bottes de qualité de centurion rivetées
273429:4:4:65:Bottes de qualité de centurion soyeuses
272781:4:4:65:Bottes de qualité de chevalier-champion de chevalerie
272771:4:4:65:Bottes de qualité de chevalier-champion en mailles
274183:4:4:65:Bottes de qualité de chevalier-champion en mailles plates
274206:4:4:65:Bottes de qualité de chevalier-champion en mailles rivetées
272768:4:4:65:Bottes de qualité de chevalier-champion en peau de bête
273404:4:4:65:Bottes de qualité de chevalier-champion en peau du Rêve
273396:4:4:65:Bottes de qualité de chevalier-champion en peau lunaire
272792:4:4:65:Bottes de qualité de chevalier-champion en plaques
272807:4:4:65:Bottes de qualité de chevalier-champion en tisse-effroi
274198:4:4:65:Bottes de qualité de chevalier-champion en écailles
273330:4:4:65:Bottes de qualité de chevalier-champion lumineuses
272504:4:4:65:Bottes de qualité de magus centurion
272496:3:4:60:Bottes de qualité en anneaux
272704:3:4:60:Bottes de qualité en cuir
272713:3:4:60:Bottes de qualité en mailles
272462:3:4:60:Bottes de qualité en peau de dragon
272716:3:4:60:Bottes de qualité en plaques
272477:3:4:60:Bottes de qualité en plaques cimentières
272568:3:4:60:Bottes de qualité en satin
272701:3:4:60:Bottes de qualité en soie
272794:3:4:60:Bottes de qualité en tisse-effroi
272552:3:4:60:Bottes de qualité en tisse-gangrène
272810:3:4:60:Bottes de qualité en étoffe du Vide
273443:3:4:60:Bottes de qualité en étoffe lunaire
11853:2:4:18:Bottes de randonnée
263420:1:4:8:Bottes de randonnée
3454:1:4:14:Bottes de reconnaissance
22430:4:4:86:Bottes de rédemption
252468:3:4:52:Bottes de rôdeur en cuir
252444:3:4:22:Bottes de sagesse en cuir
250547:3:4:45:Bottes de sentinelle
252472:3:4:52:Bottes de soigneur en cuir
252565:3:4:45:Bottes de soigneur en mailles
2691:1:4:5:Bottes de tailleur
20714:3:4:63:Bottes de tempête de sable
7952:2:4:36:Bottes de Thero-shan
252440:3:4:22:Bottes de trappeur en cuir
22440:4:4:86:Bottes de traqueur des cryptes
252562:3:4:45:Bottes de traqueur en mailles
5821:2:4:24:Bottes de Traqueur noir
270013:2:4:20:Bottes de travail de mineur
2037:2:4:18:Bottes de tunnelier
21645:4:4:77:Bottes de tunnelière de la ruche
15697:2:4:38:Bottes de voleur de kodo
250503:3:4:22:Bottes de vétéran
10701:2:4:45:Bottes de Zua'tec
271757:1:4:1:Bottes de zélote al’aketh
15104:2:4:39:Bottes des ailés
257340:1:4:10:Bottes des champs
22096:4:4:60:Bottes des Cinq tonnerres
10748:2:4:41:Bottes des errants
253893:3:4:17:Bottes des flammes
10707:2:4:52:Bottes des forgeurs
20052:3:4:63:Bottes des Hautes-terres en cuir
20112:3:4:53:Bottes des Hautes-terres en cuir
20113:3:4:43:Bottes des Hautes-terres en cuir
20114:3:4:33:Bottes des Hautes-terres en cuir
20053:3:4:63:Bottes des Hautes-terres en cuir de lézard
20100:3:4:53:Bottes des Hautes-terres en cuir de lézard
20101:3:4:43:Bottes des Hautes-terres en cuir de lézard
20102:3:4:33:Bottes des Hautes-terres en cuir de lézard
20054:3:4:63:Bottes des Hautes-terres en tissu
20094:3:4:53:Bottes des Hautes-terres en tissu
20095:3:4:43:Bottes des Hautes-terres en tissu
20096:3:4:33:Bottes des Hautes-terres en tissu
9658:2:4:43:Bottes des Maharishi
15398:1:4:14:Bottes des mareyeurs
2949:2:4:25:Bottes des marins
6173:1:4:5:Bottes des neiges
6668:2:4:27:Bottes du conscrit
21365:4:4:78:Bottes du Frappeur
4972:1:4:10:Bottes du grimpeur des collines
3447:1:4:8:Bottes du marcheur des cryptes
15461:2:4:25:Bottes du pas rapide
22064:4:4:60:Bottes du sorcier
22365:4:15:60:Bottes désacralisées
274747:2:4:35:Bottes détrempées
250506:3:4:22:Bottes d’acolyte
260167:2:4:52:Bottes d’aventurier perdues
279176:1:4:1:Bottes d’aventurier vétéran
252564:3:4:45:Bottes d’escarmouche en mailles
277218:2:4:28:Bottes d’incinérateur
250546:3:4:45:Bottes d’officier
271747:1:4:1:Bottes d’oracle des cieux shen’dorei
4936:1:4:8:Bottes empoussiérées
281700:2:4:1:Bottes en cuir restaurées
4653:2:4:45:Bottes en fer armé
3274:1:4:5:Bottes en lin
281708:2:4:1:Bottes en mailles restaurées
2910:2:4:25:Bottes en or de la milice
4942:1:4:12:Bottes en peau de tigre
21613:4:4:81:Bottes en peau de ver
3439:1:4:8:Bottes en peau de zombie
260185:3:4:55:Bottes en peau d’hippogriffe
281716:2:4:1:Bottes en plaques restaurées
10700:2:4:45:Bottes Encarmine
9646:2:4:49:Bottes engloutissantes gnomes
9601:1:4:12:Bottes fourrées
253889:3:4:17:Bottes immaculées
16472:4:4:71:Bottes lamellaires de maréchal
252427:3:4:15:Bottes lueur-de-lune
3764:2:4:40:Bottes Mantis
20641:2:4:45:Bottes mojo des Mers du sud
253897:3:4:17:Bottes nacrées
252425:3:4:15:Bottes noires en cuir
253895:3:4:17:Bottes ombreuses
250620:3:4:15:Bottes ornées en cuivre
21648:4:4:76:Bottes recomposées
281317:2:4:51:Bottes rougepierre
9662:2:4:43:Bottes Rushridge
5311:2:4:21:Bottes sanglées
9637:2:4:45:Bottes Shinkicker
22003:4:4:60:Bottes Sombremante
4915:1:4:5:Bottes souples en laine
253891:3:4:17:Bottes soyeuses
252442:3:4:22:Bottes totémiques en cuir
10653:2:4:30:Bottes Trailblazer
1173:1:4:10:Bottes usées
257341:1:4:10:Bottes usées par le vent
277091:1:4:14:Bottes zéphrali
3741:2:4:24:Bottes écrasantes
250621:3:4:15:Bottes étranges en cuivre
272746:4:4:65:Bottillons de qualité de chevalier-champion en soie
272453:3:4:60:Bottillons de qualité de magus
272705:3:4:60:Bottillons de qualité en peau de bête
273379:3:4:60:Bottillons de qualité en peau du Rêve
273370:3:4:60:Bottillons de qualité en peau lunaire
12021:3:4:54:Bottillons renforcés
277097:1:4:14:Bottillons zéphrali
21338:4:4:78:Bottines d'implorateur funeste
23281:3:4:66:Bottines de chevalier-lieutenant en peau de dragon
22852:3:4:66:Bottines de garde de sang en peau de dragon
16485:3:4:63:Bottines de garde de sang en soie
21349:4:4:78:Bottines de l'oracle
272523:4:4:65:Bottines de qualité de centurion en pelombre
272606:3:4:60:Bottines de qualité en cuir de kodo
273383:3:4:60:Bottines de qualité en peau de wyrm
277234:2:4:28:Bottines empressées
273875:2:4:15:Bottines empyréennes
21162:2:15:15:Bouche-noire huileux boursouflé
277209:2:4:40:Boucle assommante
271670:2:4:33:Boucle de vie
20502:3:4:52:Bouclier d'écorcefer
16660:2:4:27:Bouclier de Driftmire
257255:2:4:8:Bouclier de défense des hautes-terres
3450:2:4:15:Bouclier de Faerleia
281147:1:15:1:Bouclier de Grant
1547:2:4:30:Bouclier de la Foi
15207:2:4:20:Bouclier de renforcement
7120:2:4:20:Bouclier de Ruga
4652:2:4:45:Bouclier de Salbac
11915:2:4:55:Bouclier de Shizzle
9706:2:4:43:Bouclier de Tharg
5357:2:4:27:Bouclier des vallons
4507:2:4:42:Bouclier du combattant des abîmes
6078:1:4:5:Bouclier du lancier
2916:2:4:34:Bouclier du lion d'or
209873:1:15:25:Bouclier du tueur de dragon
21610:4:4:81:Bouclier en écailles de ver
276334:2:4:57:Bouclier façonné à la main
5395:1:4:5:Bouclier forestier
270065:2:4:38:Bouclier oublié de long-voyant
15695:2:4:38:Bouclier riveté
15466:2:4:28:Bouclier résonnant
5325:2:4:16:Bouclier soudé
263305:2:4:10:Bouclier soufflé
276889:2:4:24:Bouclier tissépine
5094:1:4:24:Bouclier Tranchecrin
4967:1:4:11:Bouclier tribal
3761:2:4:32:Bouclier Tête de mort
18209:1:0:42:Bougie chargée
274918:1:0:38:Bougie de protection
12924:1:0:1:Bougie de rituel
2562:1:4:23:Bouquet de bégonias écarlates
281318:2:4:29:Bouquet de fleurs d’Auberdine
22206:2:4:1:Bouquet de roses rouges
249898:1:15:50:Bourgeon de flagellin fané
249897:1:15:50:Bourgeon de flagellin fleuri
249895:1:15:50:Bourgeon de flagellin givré
249896:1:15:50:Bourgeon de flagellin viridien
221371:1:15:1:Bourse de kidnappeur
284583:1:15:1:Bourse de pièces
284584:1:15:1:Bourse de pièces
284585:1:15:1:Bourse de pièces
284586:1:15:1:Bourse de pièces
289439:3:15:1:Bourse de poussière pourpre
277113:1:1:1:Bourse d’herbes d’apprenti
277200:1:1:5:Bourse en cuir brûlée
276891:2:1:29:Bourse en soie d’araignée
4130:2:4:50:Boussole de Smotts
18144:1:12:60:Bout d'os humain
271343:1:15:20:Bout de note
6729:2:2:38:Boute-feu de Fizzle
5253:2:2:40:Boute-feu gobelin
19318:1:0:55:Bouteille d'eau de source d'Alterac
268825:1:12:1:Bouteille de murmures
274948:2:2:42:Bouteille du port de Poudremèche
234818:1:12:1:Bouteille d’essence
275669:2:4:59:Boxeurs d’Uppercut
277239:2:4:45:Boxeurs enchâssés
22244:2:1:30:Boîte d'âmes
6756:1:1:5:Boîte de bijoux
21812:1:15:1:Boîte de chocolats
10695:1:15:1:Boîte de fioles vides
208768:1:15:1:Boîte d’allumettes de boucanier
4613:1:12:30:Boîte noire corrodée
10590:1:12:30:Boîte noire corrodée
9537:1:15:1:Boîte soigneusement empaquetée
5857:1:12:1:Boîte à surprises gnome
5858:1:12:1:Boîte à surprises gobeline
23002:1:15:1:Boîte à tortue
22260:1:0:1:Bracelet d'amitié
22259:1:0:1:Bracelet d'amitié non distribué
281272:2:4:10:Bracelet d’amitié de Brog
281273:2:4:10:Bracelet d’amitié de Migi
281269:2:4:10:Bracelet d’amitié de Mogra
281271:2:4:10:Bracelet d’amitié de Puk
281270:2:4:10:Bracelet d’amitié de Thra
275831:2:4:58:Bracelet hauteplume
260183:3:4:55:Bracelet sacré
263336:2:4:13:Bracelets chantevent
16394:3:4:60:Bracelets de chevalier-capitaine en cuir
16395:3:4:60:Bracelets de chevalier-capitaine en peau de dragon
16404:3:4:60:Bracelets de chevalier-capitaine en plaques
17595:3:4:60:Bracelets de chevalier-capitaine en satin
16370:3:4:60:Bracelets de chevalier-capitaine en soie
17563:3:4:60:Bracelets de chevalier-capitaine en tissu-effroi
16570:4:4:65:Bracelets de général en chaînes
16559:4:4:65:Bracelets de général en cuir
16576:4:4:65:Bracelets de général en mailles
16553:4:4:65:Bracelets de général en peau de dragon
17619:4:4:65:Bracelets de général en satin
16538:4:4:65:Bracelets de général en soie
17587:4:4:65:Bracelets de général en tissu-effroi
270028:2:4:27:Bracelets de harpie
16517:3:4:60:Bracelets de légionnaire en chaînes
16512:3:4:60:Bracelets de légionnaire en plaques
17615:3:4:60:Bracelets de légionnaire en satin
17575:3:4:60:Bracelets de légionnaire en tissu-effroi
16461:4:4:65:Bracelets de maréchal en chaînes
16481:4:4:65:Bracelets de maréchal en plaques
17606:4:4:65:Bracelets de maréchal en satin
16438:4:4:65:Bracelets de maréchal en soie
17582:4:4:65:Bracelets de maréchal en tissu-effroi
21604:4:4:81:Bracelets de rédemption royale
16445:4:4:65:Bracelets en peau de dragon de maréchal
16412:3:4:60:Bracelets lamellaires de chevalier-capitaine
4132:2:4:37:Brachiales darkspear
272721:3:4:60:Brachiales de qualité de chevalerie
272769:4:4:65:Brachiales de qualité de chevalier-capitaine en cuir
272524:4:4:65:Brachiales de qualité de légionnaire en pelombre
272707:3:4:60:Brachiales de qualité en peau de bête
272834:3:4:60:Brachiales de qualité en peau du Rêve
272835:3:4:60:Brachiales de qualité en peau lunaire
274229:3:4:60:Brachiales de qualité en écailles
274257:3:4:60:Brachiales de qualité lamellaires
273364:3:4:60:Brachiales de qualité lumineuses
18452:3:4:63:Brachiales de sergent-major en cuir
18453:3:4:50:Brachiales de sergent-major en cuir
18454:3:4:63:Brachiales de sergent-major en cuir de dragon
18455:3:4:50:Brachiales de sergent-major en cuir de dragon
19717:4:12:1:Brachiales primordiales hakkari
270080:2:4:40:Bracières arathies
270100:2:4:47:Bracières de flibustier
270103:2:4:51:Bracières d’aide à la recharge
12455:1:12:60:Braise de Juju
227801:2:7:1:Braise des terres de Feu
210763:1:12:1:Branche d’Altek
5249:2:2:40:Branchette ardente
221256:1:15:1:Bras droit de l’Oblitérateur
221257:1:15:1:Bras gauche de l’Oblitérateur
22014:1:12:1:Brasero béni
22057:1:12:1:Brasero d'invocation
22049:1:12:1:Brasero de signal
22050:1:12:1:Brasero de signal
22051:1:12:1:Brasero de signal
22052:1:12:1:Brasero de signal
22056:1:12:1:Brasero de signal
279177:1:4:1:Brassard d’aventurier vétéran
3453:1:4:12:Brassards capitonnés
23379:2:0:58:Brassards cendrés
271732:2:4:33:Brassards chargés de poussière
277238:2:4:45:Brassards chatoyants
1182:1:4:10:Brassards cloutés de cuivre
22108:3:4:65:Brassards Cœur-Farouche
18429:3:4:63:Brassards d'adjudant en plaques
18430:3:4:50:Brassards d'adjudant en plaques
19830:4:4:61:Brassards d'augure zandalar
6793:2:4:40:Brassards d'Auric
22667:4:4:60:Brassards d'espoir
21602:4:4:81:Brassards d'exécution quiraji
19840:4:4:61:Brassards d'haruspice zandalar
21996:3:4:65:Brassards d'héroïsme
19836:4:4:61:Brassards d'insensé zandalar
22088:3:4:65:Brassards d'Âmeforge
15796:2:4:59:Brassards d'écume
11469:2:4:47:Brassards de bandelettes sanglantes
16981:2:4:20:Brassards de Barbe-huante
19578:4:4:65:Brassards de berserker
19580:4:4:55:Brassards de berserker
19581:4:4:45:Brassards de berserker
16402:3:4:60:Brassards de chevalier-capitaine en chaînes
4745:2:4:40:Brassards de chevaucheur martial
15400:1:4:14:Brassards de coquillage
5590:1:4:11:Brassards de corde
6062:1:4:10:Brassards de corde épaisse
22423:4:4:88:Brassards de cuirassier
263338:2:4:13:Brassards de défense
21184:4:4:62:Brassards de Fonderoc
21611:4:4:81:Brassards de fouisseur
252540:3:4:50:Brassards de furtivité en cuir
252541:3:4:50:Brassards de garde en cuir
6061:1:4:8:Brassards de grisepierre
16546:4:4:65:Brassards de général en plaques
11875:2:4:54:Brassards de la brise
270010:2:4:20:Brassards de la crête du raptor
15403:2:4:18:Brassards de la dorsale
22483:4:4:88:Brassards de la faucheuse d'os
270076:2:4:40:Brassards de la marée
710:1:4:14:Brassards de la milice du peuple
16493:3:4:60:Brassards de légionnaire en peau de dragon
252542:3:4:50:Brassards de mande-ciel en cuir
252571:3:4:50:Brassards de mande-ciel en mailles
16460:4:4:65:Brassards de maréchal en cuir
4908:1:4:5:Brassards de nomade
19833:4:4:61:Brassards de prédateur zandalar
272770:4:4:65:Brassards de qualité de chevalier-capitaine en mailles
274186:4:4:65:Brassards de qualité de chevalier-capitaine en mailles plates
274209:4:4:65:Brassards de qualité de chevalier-capitaine en mailles rivetées
272754:4:4:65:Brassards de qualité de chevalier-capitaine en peau de bête
273397:4:4:65:Brassards de qualité de chevalier-capitaine en peau du Rêve
273389:4:4:65:Brassards de qualité de chevalier-capitaine en peau lunaire
272790:4:4:65:Brassards de qualité de chevalier-capitaine en plaques
272747:4:4:65:Brassards de qualité de chevalier-capitaine en soie
274201:4:4:65:Brassards de qualité de chevalier-capitaine en écailles
272822:4:4:65:Brassards de qualité de chevalier-capitaine en étoffe du Vide
273425:4:4:65:Brassards de qualité de chevalier-capitaine en étoffe lunaire
273417:4:4:65:Brassards de qualité de légionnaire en cuir de kodo
273339:4:4:65:Brassards de qualité de légionnaire en mailles
273347:4:4:65:Brassards de qualité de légionnaire en mailles annelées
272518:4:4:65:Brassards de qualité de légionnaire en peau de dragon
273409:4:4:65:Brassards de qualité de légionnaire en peau de wyrm
272571:4:4:65:Brassards de qualité de légionnaire en satin
272555:4:4:65:Brassards de qualité de légionnaire en tisse-gangrène
272541:4:4:65:Brassards de qualité de légionnaire rivetés
273430:4:4:65:Brassards de qualité de légionnaire soyeux
272483:3:4:60:Brassards de qualité en anneaux
272706:3:4:60:Brassards de qualité en cuir
272579:3:4:60:Brassards de qualité en plaques cimentières
272795:3:4:60:Brassards de qualité en tisse-effroi
272551:3:4:60:Brassards de qualité en tisse-gangrène
21584:4:4:88:Brassards de rétorsion éternelle
252539:3:4:50:Brassards de rôdeur en cuir
252543:3:4:50:Brassards de soigneur en cuir
252573:3:4:50:Brassards de soigneur en mailles
270068:2:4:39:Brassards de Stromgarde
22668:4:4:60:Brassards de subterfuge
2326:1:4:10:Brassards de tisse-lierre
252570:3:4:50:Brassards de traqueur en mailles
19587:4:4:65:Brassards de traqueuse sylvestre
19589:4:4:55:Brassards de traqueuse sylvestre
19590:4:4:45:Brassards de traqueuse sylvestre
10461:2:4:45:Brassards des ténèbres
15864:2:4:39:Brassards du condor
21594:4:4:88:Brassards du fils déchu
15462:2:4:25:Brassards du terreau
22355:4:15:60:Brassards désacralisées
272580:3:4:50:Brassards d’adjudant en plaques
252572:3:4:50:Brassards d’escarmouche en mailles
6177:1:4:12:Brassards en fer forgé
6060:1:4:5:Brassards en lin
3158:1:4:12:Brassards en peau brûlée
270033:2:4:27:Brassards en peau de démon
6070:1:4:5:Brassards en peau de loup
257280:1:4:5:Brassards en peau de vuldrène
3435:1:4:8:Brassards en peau de zombie
11187:1:4:5:Brassards en tiges entrelacées
281688:2:4:1:Brassards en tissu restaurés
4979:2:4:42:Brassards enchantés en étoffe de pierre
5419:1:4:7:Brassards farouches
21186:4:4:62:Brassards Furie-du-roc
277230:2:4:45:Brassards grisécailles
16469:4:4:65:Brassards lamellaires de maréchal
6665:2:4:26:Brassards maléficiés
22071:3:4:65:Brassards Mortebrume
4545:2:4:40:Brassards radieux en argent
11849:1:4:5:Brassards rouillés
4744:2:4:39:Brassards runiques des arcanes
22004:3:4:65:Brassards Sombremante
6675:2:4:27:Brassards trempés
22079:3:4:65:Brassards vertueux
277087:1:4:14:Brassards zéphrali
257331:1:4:10:Brassards à bandes de cuivre
17352:1:0:45:Breuvage de mana excellent
17351:1:0:55:Breuvage de mana majeur
221261:2:15:45:Breuvage de murmure sauvage
17349:1:0:45:Breuvage de soins excellent
17348:1:0:55:Breuvage de soins majeur
12846:1:4:1:Brevet de l'Aube d'argent
18241:4:15:40:Bride de palefroi de guerre noir
21246:2:12:60:Briefing de combat I
21749:2:12:60:Briefing de combat I
21247:2:12:60:Briefing de combat II
21750:2:12:60:Briefing de combat II
20942:2:12:60:Briefing de combat III
21248:2:12:60:Briefing de combat IV
21253:2:12:60:Briefing de combat IX
21249:2:12:60:Briefing de combat V
21250:2:12:60:Briefing de combat VI
21251:2:12:60:Briefing de combat VII
21252:2:12:60:Briefing de combat VIII
21255:2:12:60:Briefing de combat X
21256:2:12:60:Briefing de combat XI
20941:2:12:60:Briefing de combat XII
20807:2:12:60:Briefing logistique I
21378:2:12:60:Briefing logistique I
20939:2:12:60:Briefing logistique II
21379:2:12:60:Briefing logistique II
20940:2:12:60:Briefing logistique III
21380:2:12:60:Briefing logistique III
21257:2:12:60:Briefing logistique IV
21258:2:12:60:Briefing logistique IV
21265:2:12:60:Briefing logistique IX
21381:2:12:60:Briefing logistique IX
21259:2:12:60:Briefing logistique V
21382:2:12:60:Briefing logistique V
21260:2:12:60:Briefing logistique VI
21261:2:12:60:Briefing logistique VI
21263:2:12:60:Briefing logistique VII
21264:2:12:60:Briefing logistique VII
21262:2:12:60:Briefing logistique VIII
21384:2:12:60:Briefing logistique VIII
20806:2:12:60:Briefing logistique X
21385:2:12:60:Briefing logistique X
21514:2:12:60:Briefing logistique XI
232549:2:12:60:Briefing logistique VI
21245:2:12:60:Briefing tactique I
20945:2:12:60:Briefing tactique II
20946:2:12:60:Briefing tactique III
21751:2:12:60:Briefing tactique III
20947:2:12:60:Briefing tactique IV
20944:2:12:60:Briefing tactique IX
20948:2:12:60:Briefing tactique V
21165:2:12:60:Briefing tactique VI
21166:2:12:60:Briefing tactique VII
21167:2:12:60:Briefing tactique VIII
20943:2:12:60:Briefing tactique X
20080:2:0:65:Brillance de Zanza
23794:2:0:65:Brillance de Zanza permanente
242270:3:0:1:Brillance du Grand arcaniste
242271:3:0:1:Brillance du Grand croisé
242362:3:0:1:Brillance du Grand Inquisiteur
242269:3:0:1:Brillance du Grand sorcier
18399:3:4:63:Brise de l'océan
246164:2:2:13:Brise-crâne
3440:2:2:13:Brise-os
277136:2:13:1:Broche des Gardiennes
269741:2:4:58:Broche en runebois parfumé
21625:4:4:78:Broche scarabée
23285:3:4:66:Brodequins de chevalier-lieutenant en cuir
23289:3:4:66:Brodequins de chevalier-lieutenant en satin
23291:3:4:66:Brodequins de chevalier-lieutenant en soie
23283:3:4:66:Brodequins de chevalier-lieutenant en tisse-effroi
22856:3:4:66:Brodequins de garde de sang en cuir
22859:3:4:66:Brodequins de garde de sang en satin
22860:3:4:66:Brodequins de garde de sang en soie
22855:3:4:66:Brodequins de garde de sang en tisse-effroi
263309:2:4:11:Brodequins de la liberté
272484:3:4:60:Brodequins de qualité en mailles
273355:3:4:60:Brodequins de qualité en mailles annelées
274217:3:4:60:Brodequins de qualité en mailles rivetées
272608:3:4:60:Brodequins de qualité en pelombre
274176:3:4:60:Brodequins de qualité en écailles
272611:3:4:60:Brodequins de qualité soyeux
270019:2:4:24:Brodequins du loch
5626:2:2:20:Broie-crâne
7229:2:4:13:Broigne d'explorateur
6502:2:4:22:Broigne violette
23164:1:0:1:Bubbly Beverage
206966:1:13:1:Bulbe de satyrienne
277534:2:15:1:Butin de l’arène
5779:1:2:5:Bâtarde des Réprouvés
19101:3:2:65:Bâton blanchi
10704:2:2:46:Bâton Chillnail
1010:1:2:8:Bâton court
19102:3:2:65:Bâton crépitant
9517:3:2:40:Bâton céleste
21273:4:2:79:Bâton d'acolyte qiraji béni
21275:4:2:79:Bâton d'augure qiraji béni
15397:2:2:14:Bâton d'Oakthrush
20069:4:2:60:Bâton d'écorcefer
20220:4:2:60:Bâton d'écorcefer
4938:1:2:11:Bâton de bois abîmé
263434:2:2:10:Bâton de bête ailée
1434:1:0:7:Bâton de cire luminescent
257282:1:2:5:Bâton de combat de novice
274940:2:2:40:Bâton de combat déséquilibré
6215:2:2:13:Bâton de combat équilibré
257343:2:2:13:Bâton de combat équilibré
18873:4:2:78:Bâton de connétable
15106:2:2:40:Bâton de Dar'Orahil
9654:2:2:50:Bâton de flamboyance
5241:2:2:18:Bâton de flammes nain
19570:3:2:63:Bâton de gardien du savoir
19571:3:2:53:Bâton de gardien du savoir
19572:3:2:43:Bâton de gardien du savoir
19573:3:2:33:Bâton de gardien du savoir
20434:3:2:23:Bâton de gardien du savoir
18874:4:2:78:Bâton de guerre de grand seigneur de guerre
270049:2:2:32:Bâton de guerre de Mavoris
272603:4:2:65:Bâton de guerre de qualité de grand seigneur de guerre
210724:1:12:1:Bâton de Hirzek
1159:1:2:5:Bâton de la milice
9513:2:2:10:Bâton de Ley
260207:2:2:55:Bâton de l’archimage Selwyn
5581:1:2:5:Bâton de marche lisse
16889:2:2:24:Bâton de marche poli
5778:1:2:5:Bâton de marche primitif
221976:2:15:40:Bâton de nature malade
15105:2:2:40:Bâton de Noh'Orahil
272850:4:2:65:Bâton de qualité de connétable
277253:2:2:43:Bâton de ruse brutale
271767:3:2:33:Bâton de soins
3446:2:2:13:Bâton de sombrebois
15109:3:2:25:Bâton de Soran'ruk
5326:2:2:18:Bâton de vision
9514:2:2:10:Bâton des arcanes
5393:1:2:5:Bâton des chardons
271797:2:2:38:Bâton des révélations
249393:3:2:30:Bâton des âmes
3277:1:2:5:Bâton du Bourreau
5306:2:2:20:Bâton du cavalier céleste
275291:2:2:58:Bâton du Cri-Puissant
4961:1:2:10:Bâton du gardien des rêves
5613:2:2:23:Bâton du purificateur
10826:2:2:48:Bâton du savoir
275648:2:2:59:Bâton en écorce noueuse purifié
20522:3:2:52:Bâton farouche
10698:2:2:60:Bâton Felbane en azsharite enchanté
221975:2:15:40:Bâton Griffebois brisé
9603:2:2:10:Bâton Gritroot
15206:2:4:20:Bâton Jadefinger
248008:2:2:12:Bâton magique d’apprenti
4134:2:2:46:Bâton mystique de Nimboya
20724:2:2:62:Bâton noirbois corrompu
19566:3:2:63:Bâton noueux de conseiller
19567:3:2:53:Bâton noueux de conseiller
19568:3:2:43:Bâton noueux de conseiller
19569:3:2:33:Bâton noueux de conseiller
20425:3:2:23:Bâton noueux de conseiller
249454:3:2:50:Bâton onirique
249453:3:2:50:Bâton radieux
18707:4:12:71:Bâton runique gravé des Anciens
228659:4:12:71:Bâton runique gravé des anciens
249392:3:2:30:Bâton scintillant
5246:2:2:30:Bâtonnet d'excavation
11860:2:2:46:Bâtonnet d'éclair chargé
3738:2:2:25:Bâtonnet de brasseur
3452:2:2:22:Bâtonnet de céranium
5247:2:2:40:Bâtonnet de désolation
5356:2:2:27:Bâtonnet de flétrissure
191272:3:0:1:Bâtonnet de nécromancie
5462:1:12:1:Bâtonnet de transformation de Dartol
213426:1:0:1:Bâtonnet d’éclair ogre
16894:2:2:21:Bâtonnet en cristal transparent
2950:2:2:25:Bâtonnet glacial
5547:1:12:1:Bâtonnet reconstitué
16207:1:7:58:Bâtonnet runique en arcanite
6339:1:7:20:Bâtonnet runique en argent
6218:1:7:5:Bâtonnet runique en cuivre
11130:1:7:30:Bâtonnet runique en or
11145:1:7:40:Bâtonnet runique en vrai-argent
11857:2:2:46:Bâtonnet sanctifié
18244:4:15:40:Bélier de guerre noir
18608:4:2:75:Bénédiction
12384:1:12:1:Cache de Mau'ari
11887:1:15:1:Cache du Cercle cénarien
284271:1:15:1:Cache d’urgence
274756:2:4:55:Cache-oreilles peu pratique
20076:3:12:60:Cachet de mojo zandalar
20077:3:12:60:Cachet de puissance zandalar
20078:3:12:60:Cachet de sérénité zandalar
231789:1:15:1:Cachet du gardien
227451:1:15:1:Cachet d’émission
228978:3:0:60:Cachet enchanté : eaux courantes
228979:4:9:60:Cachet enchanté : eaux courantes
215141:4:9:46:Cachet enchanté : innovation
217308:2:0:40:Cachet enchanté : innovation
21363:1:15:1:Cadeau de fête
228189:3:13:1:Cadeau de Gob
21216:1:15:1:Cadeau extra-spécial des Gourmandises Fumebois
21270:1:15:1:Cadeau secoué doucement
21191:1:15:1:Cadeau soigneusement emballé
17726:1:15:1:Cadeau spécial des Gourmandises Fumebois
21327:1:15:1:Cadeau tic-taquant
21310:1:15:1:Cadeau à l'emballage multicolore
23015:1:15:1:Cage à rat
16418:3:4:63:Cagoule de lieutenant-commandant en cuir
202641:1:15:1:Cahier recouvert de boue
19598:2:4:60:Caillou de Kajaro
19599:3:4:60:Caillou de Kajaro
19600:3:4:68:Caillou de Kajaro
268558:1:12:7:Caillou porte-bonheur de Trogg
8647:1:12:1:Caisse d'oeufs
248766:1:15:1:Caisse de compagnon scellée
248771:2:15:1:Caisse de compagnon scellée
248776:3:15:1:Caisse de compagnon scellée
226405:2:15:60:Caisse de fournitures de Terremine endommagée
236414:2:15:60:Caisse de fournitures de Terremine endommagée
272151:2:15:60:Caisse de fournitures de Terremine endommagée
213371:2:7:40:Caisse de solution de gniode contaminée
248765:1:15:1:Caisse d’apprenti scellée
248770:2:15:1:Caisse d’apprenti scellée
248775:3:15:1:Caisse d’apprenti scellée
248768:1:15:1:Caisse d’artisan scellée
248773:2:15:1:Caisse d’artisan scellée
248778:3:15:1:Caisse d’artisan scellée
248767:1:15:1:Caisse d’expert scellée
248772:2:15:1:Caisse d’expert scellée
248777:3:15:1:Caisse d’expert scellée
248769:1:15:1:Caisse d’élite scellée
248774:2:15:1:Caisse d’élite scellée
248779:3:15:1:Caisse d’élite scellée
277332:1:1:15:Caisse éraflée
19016:5:12:70:Calice de la renaissance
287974:1:0:45:Calmar grillé
7130:2:4:31:Camail de brutalité
6971:2:4:31:Camail en acier trempé
281701:2:4:1:Camail en mailles restauré
1282:2:4:33:Camail en métal étincelant
23033:4:4:83:Camail glacécaille
12122:2:15:50:Camelote de Kum'isha
5776:1:2:5:Canne de doyen
12225:1:2:10:Canne à pêche de la famille Blump
19970:3:2:20:Canne à pêche en arcanite
4598:1:0:35:Canne à pêche gobeline
3567:2:2:19:Canne à pêche naine
276203:3:2:45:Canne à pêche primitive
18855:4:2:78:Canon à main de connétable
272846:4:2:65:Canon à main de qualité de connétable
22233:2:1:60:Cantine de Zigris
271716:3:4:33:Cape anti-poussière de la Ligue des explorateurs
273654:2:4:29:Cape au fil de cristal
277206:2:4:41:Cape brillante
9703:2:4:43:Cape brûlée
274740:2:4:25:Cape capitonnée
257277:1:4:5:Cape courte balayée par la brise
11850:1:4:5:Cape courte de chauve-souris du crépuscule
4944:1:4:12:Cape cousue à la main
3833:1:4:8:Cape d'adepte
9660:2:4:43:Cape d'astronome
5343:2:4:18:Cape d'aubergiste
3070:1:4:5:Cape d'enseigne
15815:2:4:60:Cape d'Hameya
6667:2:4:27:Cape d'ingénieur
5618:1:4:11:Cape d'éclaireur
11858:2:4:45:Cape de briscard
7739:2:4:18:Cape de bûcheron
16658:2:4:32:Cape de chasseur de fauves
5314:2:4:20:Cape de chasseur de sanglier
257943:2:4:8:Cape de chasseur simple
21583:4:4:88:Cape de clarté
4933:1:4:9:Cape de combattant aguerri
19085:3:4:60:Cape de conseiller loup-de-givre
19530:3:4:63:Cape de conservateur
19531:3:4:53:Cape de conservateur
19532:3:4:43:Cape de conservateur
19533:3:4:33:Cape de conservateur
20428:3:4:23:Cape de conservateur
4504:2:4:31:Cape de garde nain
20068:4:4:65:Cape de garde noir
271735:1:4:1:Cape de garde-paix shen’dorei
3749:2:4:30:Cape de grand apothicaire
281319:3:4:32:Cape de guerre de golem
21397:4:4:67:Cape de justice éternelle
2902:2:4:30:Cape de la foi
20073:4:4:65:Cape de la garde d'honneur
9699:2:4:33:Cape de la garnison
3511:2:4:15:Cape de la milice du peuple
275050:2:4:46:Cape de la secte
277205:3:4:35:Cape de la tempête divine
21400:4:4:67:Cape de la tempête imminente
19083:3:4:60:Cape de légionnaire loup-de-givre
286427:2:4:15:Cape de l’honorable hôte
281250:2:4:11:Cape de l’oracle sylvestre
271724:1:4:1:Cape de magistère shen’dorei
9635:2:4:45:Cape de maître apothicaire
2953:2:4:33:Cape de maître du guet
281289:2:4:13:Cape de Plumelame
272578:3:4:60:Cape de qualité de sergent
272698:3:4:60:Cape de qualité de sergent
19086:3:4:60:Cape de sage foudrepique
10821:2:4:15:Cape de semeur
16341:3:4:50:Cape de sergent
18427:3:4:35:Cape de sergent
18461:3:4:63:Cape de sergent
272451:3:4:50:Cape de sergent
19526:3:4:63:Cape de soigneur de bataille
19527:3:4:53:Cape de soigneur de bataille
19528:3:4:43:Cape de soigneur de bataille
19529:3:4:33:Cape de soigneur de bataille
20427:3:4:23:Cape de soigneur de bataille
19084:3:4:60:Cape de soldat foudrepique
4114:2:4:42:Cape de sombreflux
4963:1:4:8:Cape de Thunderhorn
21409:4:4:67:Cape de vie interminable
6745:2:4:33:Cape de vélocité
271758:1:4:1:Cape de zélote al’aketh
19121:3:4:51:Cape des bois profonds
11873:2:4:56:Cape des brumes éthérées
16990:2:4:27:Cape des fées
21406:4:4:67:Cape des ombres voilées
244352:1:4:1:Cape des pattes voilées
5610:2:4:15:Cape des terres venteuses
5405:1:4:5:Cape drapée
6832:3:4:42:Cape du chancre
21710:4:4:88:Cape du dieu déchu
15789:2:4:56:Cape du fleuve profond
16661:2:4:27:Cape du saule souple
21403:4:4:67:Cape du sentier invisible
16315:3:4:30:Cape du Sergent-major
16336:3:4:45:Cape du Sergent-major
16337:3:4:60:Cape du Sergent-major
4958:1:4:8:Cape délavée
4920:1:4:5:Cape détériorée
275711:3:4:61:Cape d’aile de chimère
257275:1:4:5:Cape d’apprentie forestière
263417:1:4:8:Cape d’aventurier
279179:1:4:1:Cape d’aventurier vétéran
281305:2:4:31:Cape d’excavation
271748:1:4:1:Cape d’oracle des cieux shen’dorei
260806:1:4:40:Cape d’urgence de terrain
2805:2:4:34:Cape en fourrure de yéti
2905:1:4:10:Cape en peau de chèvre
21187:3:4:62:Cape en tisse-terre
11847:1:4:5:Cape endommagée
1270:2:4:15:Cape finement tissée
4854:1:4:11:Cape griffée par les démons
20219:3:4:59:Cape hakkari rapiécée
20218:3:4:59:Cape hakkari terne
286426:2:4:15:Cape liée à l’honneur
275833:2:4:57:Cape poil-de-pin
281717:2:4:1:Cape restaurée
2240:1:4:15:Cape robuste
3582:2:4:18:Cape résistante à l'acide
3153:1:4:9:Cape tachée d'huile
5591:1:4:11:Cape tachée de pluie
11475:1:4:5:Cape tachée de vin
277207:2:4:40:Cape vieillie
22109:4:4:60:Capuche Cœur-Farouche
274023:3:4:1:Capuche de Bat-le-désert volée
17610:3:4:63:Capuche de champion en satin
23263:3:4:71:Capuche de champion en soie
23255:3:4:71:Capuche de champion en tisse-effroi
23318:3:4:71:Capuche de lieutenant-commandant en soie
23310:3:4:71:Capuche de lieutenant-commandant en tisse-effroi
272498:4:4:65:Capuche de qualité de magus seigneur de guerre
272575:4:4:65:Capuche de qualité de seigneur de guerre en satin
273434:4:4:65:Capuche de qualité de seigneur de guerre soyeuse
272562:3:4:60:Capuche de qualité en satin
272671:3:4:60:Capuche de qualité en tisse-effroi
272643:3:4:60:Capuche de qualité en tisse-gangrène
17623:4:4:74:Capuche de seigneur de guerre en satin
16533:4:4:74:Capuche de seigneur de guerre en soie
281539:2:4:59:Capuche en fourrure d’ours
3732:1:4:30:Capuche simple
2904:2:2:16:Carabine de chasse de Daryl
12448:1:2:5:Carabine de chasse légère
4111:2:2:45:Carabine de maître-chasseur
17687:2:2:43:Carabine de maître-chasseur
3079:2:2:12:Carabine de Skorn
4086:2:2:37:Carabine foudroyante
217314:2:2:27:Carabine vise-lune
15205:2:2:20:Carabine œil-de-chouette
259893:1:15:1:Carapace de Nécrobi
5877:1:12:28:Carapace de silithide craquelée
20929:4:12:1:Carapace du Dieu très ancien
20933:4:12:1:Carcasse du Dieu très ancien
19790:3:15:60:Caresse de l'animiste
19784:3:15:60:Caresse de la Mort
13080:3:4:63:Caresse de la Veuve
216491:1:0:1:Cargaison de bois de Strangleronce
211365:2:7:10:Cargaison d’approvisionnement
211367:2:7:10:Cargaison d’approvisionnement
211368:2:7:10:Cargaison d’approvisionnement
211839:2:7:25:Cargaison d’approvisionnement
211840:2:7:25:Cargaison d’approvisionnement
211841:2:7:25:Cargaison d’approvisionnement
217337:2:7:40:Cargaison d’approvisionnement
217338:2:7:40:Cargaison d’approvisionnement
217339:2:7:40:Cargaison d’approvisionnement
221008:2:7:50:Cargaison d’approvisionnement
221009:2:7:50:Cargaison d’approvisionnement
221010:2:7:50:Cargaison d’approvisionnement
237504:2:7:50:Cargaison d’approvisionnement
210772:2:7:10:Cargaison d’approvisionnement : barres de cuivre
3493:2:2:30:Carnassier
3573:1:11:15:Carquois de chasse
274926:2:11:40:Carquois de matriarche
3605:2:11:25:Carquois des Veilleurs
19319:3:11:60:Carquois en cuir de harpie
208220:1:0:1:Carte au trésor de Dun Morogh
207110:1:0:1:Carte au trésor de Durotar
208605:1:0:1:Carte au trésor de Teldrassil
208034:1:0:1:Carte au trésor de Tirisfal
203750:1:0:1:Carte au trésor d’Elwyn
210329:1:15:1:Carte au trésor d’Hillsbrad
4851:1:12:1:Carte couverte de poussière
277649:1:15:10:Carte de bibliothèque de Fossoyeuse
277648:1:15:10:Carte de bibliothèque de Hurlevent
10790:1:12:1:Carte de membre des ingénieurs gnomes
10791:1:12:1:Carte de membre des ingénieurs gobelins
19288:4:4:66:Carte de Sombrelune : Dragon bleu
19287:4:4:66:Carte de Sombrelune : Héroïsme
19289:4:4:66:Carte de Sombrelune : Maelström
19290:4:4:66:Carte de Sombrelune : Néant distordu
21037:1:15:1:Carte grossière
9279:1:12:1:Carte perforée blanche
271745:1:15:1:Carte sanglante
274268:1:12:1:Carte sombrefer
19320:3:11:60:Cartouchière en peau de gnoll
19723:4:12:1:Casaque primordiale hakkari
21999:4:4:60:Casque d'héroïsme
22091:4:4:60:Casque d'Âmeforge
252512:3:4:30:Casque de bagarreur en cuir
23251:3:4:71:Casque de champion en anneaux
16506:3:4:63:Casque de champion en cuir
23257:3:4:71:Casque de champion en cuir
16503:3:4:63:Casque de champion en peau de dragon
23244:3:4:71:Casque de champion en plaques
10543:2:4:41:Casque de chantier gobelin
252514:3:4:30:Casque de chevaucheur de tempête en cuir
11913:2:4:55:Casque de Clayridge
22418:4:4:88:Casque de cuirassier
21360:4:4:81:Casque de dispensateur de mort
252455:3:4:30:Casque de défenseur en cuir
271738:1:4:1:Casque de garde-paix shen’dorei
16465:4:4:74:Casque de grand maréchal en anneaux
16478:4:4:74:Casque de grand maréchal en plaques
22478:4:4:88:Casque de la faucheuse d'os
21353:4:4:81:Casque de la genèse
16428:3:4:63:Casque de lieutenant-commandant en anneaux
23306:3:4:71:Casque de lieutenant-commandant en anneaux
23312:3:4:71:Casque de lieutenant-commandant en cuir
16429:3:4:63:Casque de lieutenant-commandant en plaques
10741:2:4:53:Casque de Lordrec
271727:1:4:1:Casque de magistère shen’dorei
10542:2:4:41:Casque de mineur gobelin
272760:4:4:65:Casque de qualité de grand maréchal en peau de bête
273402:4:4:65:Casque de qualité de grand maréchal en peau du Rêve
273394:4:4:65:Casque de qualité de grand maréchal en peau lunaire
272787:4:4:65:Casque de qualité de grand maréchal en plaques
272531:4:4:65:Casque de qualité de seigneur de guerre en anneaux
273414:4:4:65:Casque de qualité de seigneur de guerre en cuir de kodo
272515:4:4:65:Casque de qualité de seigneur de guerre en peau de dragon
273406:4:4:65:Casque de qualité de seigneur de guerre en peau de wyrm
272737:3:4:60:Casque de qualité en mailles
252515:3:4:30:Casque de sagesse en cuir
16561:4:4:74:Casque de seigneur de guerre en cuir
16550:4:4:74:Casque de seigneur de guerre en peau de dragon
9664:2:4:45:Casque de sentinelle
252513:3:4:30:Casque de trappeur en cuir
271761:1:4:1:Casque de zélote al’aketh
21669:4:4:76:Casque des lianes rampantes
21317:2:4:55:Casque du guide
18807:3:4:62:Casque du pouvoir latent
209872:1:15:25:Casque du tueur de dragon
271751:1:4:1:Casque d’oracle des cieux shen’dorei
16474:4:4:74:Casque lamellaire de grand maréchal
16434:3:4:63:Casque lamellaire de lieutenant-commandant
23020:4:4:83:Casque polaire
22689:3:4:66:Casque sanctifié en cuir
252456:3:4:30:Casque totémique en cuir
270048:2:2:32:Casse-tête d’Uthil
9678:2:2:43:Castagneur de Tok'kar
287622:3:4:1:Ceinture ambrée de maître-lame
22106:3:4:65:Ceinture Cœur-Farouche
15588:2:4:35:Ceinture d'acier armé
21586:4:4:88:Ceinture d'agonie sans fin
19829:4:4:61:Ceinture d'augure zandalar
19839:4:4:61:Ceinture d'haruspice zandalar
15399:2:4:14:Ceinture d'herbe-sèche
16987:2:4:27:Ceinture d'hurleur
21994:3:4:65:Ceinture d'héroïsme
11909:2:4:55:Ceinture d'outils d'excavateur
22086:3:4:65:Ceinture d'Âmeforge
16659:2:4:27:Ceinture d'équilibriste
252428:3:4:17:Ceinture de bagarreur en cuir
22010:3:4:65:Ceinture de belluaire
6788:2:4:42:Ceinture de chasse kolkar
11936:2:4:20:Ceinture de chasseur de reliques
272410:4:4:60:Ceinture de cherchevent
16400:3:4:60:Ceinture de chevalier-capitaine en chaînes
16398:3:4:60:Ceinture de chevalier-capitaine en cuir
16399:3:4:60:Ceinture de chevalier-capitaine en peau de dragon
16407:3:4:60:Ceinture de chevalier-capitaine en plaques
17597:3:4:60:Ceinture de chevalier-capitaine en satin
16367:3:4:60:Ceinture de chevalier-capitaine en soie
17565:3:4:60:Ceinture de chevalier-capitaine en tissu-effroi
252432:3:4:17:Ceinture de chevaucheur de tempête en cuir
3217:2:4:15:Ceinture de contremaître
4131:2:4:44:Ceinture de corruption
250517:3:4:17:Ceinture de croisé en anneaux
19089:3:4:60:Ceinture de cuir loup-de-givre
252430:3:4:17:Ceinture de défenseur en cuir
22518:4:4:88:Ceinture de foi
272397:4:4:60:Ceinture de forestier
252520:3:4:35:Ceinture de furtivité en cuir
250514:3:4:17:Ceinture de garde en anneaux
252460:3:4:35:Ceinture de garde en cuir
271733:1:4:1:Ceinture de garde-paix shen’dorei
22502:4:4:88:Ceinture de givrefeu
250558:3:4:35:Ceinture de grand gardien
16572:4:4:65:Ceinture de général en chaînes
16557:4:4:65:Ceinture de général en cuir
16575:4:4:65:Ceinture de général en mailles
16556:4:4:65:Ceinture de général en peau de dragon
16547:4:4:65:Ceinture de général en plaques
17621:4:4:65:Ceinture de général en satin
16537:4:4:65:Ceinture de général en soie
17589:4:4:65:Ceinture de général en tissu-effroi
250560:3:4:35:Ceinture de justicier
21606:4:4:81:Ceinture de l'empereur déchu
1154:1:4:14:Ceinture de la milice du peuple
19826:4:4:61:Ceinture de libre-penseur zandalar
9687:2:4:33:Ceinture de lutteur
16529:3:4:60:Ceinture de légionnaire en chaînes
16500:3:4:60:Ceinture de légionnaire en cuir
16520:3:4:60:Ceinture de légionnaire en mailles
16495:3:4:60:Ceinture de légionnaire en peau de dragon
16511:3:4:60:Ceinture de légionnaire en plaques
17614:3:4:60:Ceinture de légionnaire en satin
16488:3:4:60:Ceinture de légionnaire en soie
17574:3:4:60:Ceinture de légionnaire en tissu-effroi
271722:1:4:1:Ceinture de magistère shen’dorei
19088:3:4:60:Ceinture de mailles loup-de-givre
252522:3:4:35:Ceinture de mande-ciel en cuir
252589:3:4:55:Ceinture de mande-ciel en mailles
16464:4:4:65:Ceinture de maréchal en chaînes
16458:4:4:65:Ceinture de maréchal en cuir
16447:4:4:65:Ceinture de maréchal en peau de dragon
16482:4:4:65:Ceinture de maréchal en plaques
17609:4:4:65:Ceinture de maréchal en satin
16439:4:4:65:Ceinture de maréchal en soie
17585:4:4:65:Ceinture de maréchal en tissu-effroi
4954:1:4:5:Ceinture de nomade
22510:4:4:88:Ceinture de pestecoeur
19087:3:4:60:Ceinture de plaques loup-de-givre
250515:3:4:17:Ceinture de protecteur en anneaux
19832:4:4:61:Ceinture de prédateur zandalar
250559:3:4:35:Ceinture de préfet
272779:4:4:65:Ceinture de qualité de chevalier-capitaine de chevalerie
273328:4:4:65:Ceinture de qualité de chevalier-capitaine lumineuse
273420:4:4:65:Ceinture de qualité de légionnaire en cuir de kodo
272521:4:4:65:Ceinture de qualité de légionnaire en peau de dragon
273412:4:4:65:Ceinture de qualité de légionnaire en peau de wyrm
272557:4:4:65:Ceinture de qualité de légionnaire en tisse-gangrène
274235:4:4:65:Ceinture de qualité de légionnaire en écailles
274249:4:4:65:Ceinture de qualité de légionnaire lamellaire
272456:3:4:60:Ceinture de qualité de magus
272710:3:4:60:Ceinture de qualité en cuir
272797:3:4:60:Ceinture de qualité en tisse-effroi
272550:3:4:60:Ceinture de qualité en tisse-gangrène
272404:4:4:60:Ceinture de redresseur de torts
19823:4:4:61:Ceinture de redresseur de torts zandalar
252459:3:4:35:Ceinture de rôdeur en cuir
252433:3:4:17:Ceinture de sagesse en cuir
250557:3:4:35:Ceinture de sentinelle
252523:3:4:35:Ceinture de soigneur en cuir
252591:3:4:55:Ceinture de soigneur en mailles
6726:2:4:41:Ceinture de sécurité personnalisée de Razzeric
2186:1:4:5:Ceinture de tailleur
5458:1:4:10:Ceinture de terrebois
19090:3:4:60:Ceinture de tissu loup-de-givre
272396:4:4:60:Ceinture de transfert
252429:3:4:17:Ceinture de trappeur en cuir
252521:3:4:35:Ceinture de traqueur en cuir
252588:3:4:55:Ceinture de traqueur en mailles
20217:3:4:70:Ceinture de têtes minuscules
20216:3:4:70:Ceinture de têtes préservées
20215:3:4:70:Ceinture de têtes réduites
20213:3:4:70:Ceinture de têtes rétrécies
250513:3:4:17:Ceinture de vétéran en anneaux
271756:1:4:1:Ceinture de zélote al’aketh
263405:2:4:15:Ceinture des lames
260196:2:4:55:Ceinture des ombres
10462:2:4:47:Ceinture des ténèbres
6719:2:4:30:Ceinture des vents
7107:2:4:33:Ceinture des étoiles
3762:1:1:35:Ceinture du Bibliothécaire
257263:1:4:5:Ceinture du bosquet Thendal
3758:2:4:33:Ceinture du Croisé
9682:2:4:44:Ceinture du cuistot en cuir
21312:2:4:48:Ceinture du protecteur
22062:3:4:65:Ceinture du sorcier
16608:2:4:16:Ceinture du Verseau
3583:1:4:12:Ceinture défraîchie
22370:4:15:60:Ceinture désacralisée
250516:3:4:17:Ceinture d’acolyte en anneaux
279174:1:4:1:Ceinture d’aventurier vétéran
252461:3:4:35:Ceinture d’escarmouche en cuir
252590:3:4:55:Ceinture d’escarmouche en mailles
250556:3:4:35:Ceinture d’officier
270087:2:4:43:Ceinture d’Ogre épaisse
271746:1:4:1:Ceinture d’oracle des cieux shen’dorei
257272:1:4:5:Ceinture en anneaux célestes
4913:1:4:5:Ceinture en anneaux peints
6058:1:4:5:Ceinture en cuir noirci
11848:1:4:5:Ceinture en lin
281706:2:4:1:Ceinture en mailles restaurée
5936:1:4:8:Ceinture en peau d'animal
263424:1:4:10:Ceinture en peau de loup
277240:2:4:45:Ceinture en plaques dorée
281714:2:4:1:Ceinture en plaques restaurée
281690:2:4:1:Ceinture en tissu restaurée
10820:2:4:15:Ceinture Jackseed
16411:3:4:60:Ceinture lamellaire de chevalier-capitaine
16470:4:4:65:Ceinture lamellaire de maréchal
22070:3:4:65:Ceinture Mortebrume
275741:3:4:61:Ceinture rivetée de Ketharas
21598:4:4:81:Ceinture royale qiraji
2172:1:4:5:Ceinture rustique
21609:4:4:81:Ceinture régénérante de Vek'nilash
5328:2:4:15:Ceinture sanglée
22002:3:4:65:Ceinture Sombremante
4919:1:4:5:Ceinture souple en laine
260179:2:4:52:Ceinture tissée d’écorce
252431:3:4:17:Ceinture totémique en cuir
15813:2:4:56:Ceinture tressée d'or
276724:2:4:24:Ceinture trophée
22078:3:4:65:Ceinture vertueuse
277089:1:4:14:Ceinture zéphrali
3437:1:4:8:Ceinture à boucle
281323:2:4:27:Ceinture à boucle d’esprit
281266:1:4:8:Ceinture à fourrure
2690:1:4:5:Ceinture à loquet
260182:2:4:52:Ceinture élunaire
5592:1:4:11:Ceinturon d'entrave
5355:2:4:28:Ceinturon de belluaire
3753:2:4:34:Ceinturon de berger
275434:2:4:59:Ceinturon de bourbe-né
22470:4:4:88:Ceinturon de Brise-terre
272399:4:4:60:Ceinturon de cherche-tempête
271769:2:4:33:Ceinturon de Daewyn
15709:2:4:58:Ceinturon de Gearforge
10706:2:4:47:Ceinturon de la nuit
5275:2:4:15:Ceinturon de lien
19125:2:4:49:Ceinturon de mailles calcinées
22494:4:4:88:Ceinturon de marcherêve
20150:3:4:63:Ceinturon de Profanateur en anneaux
20151:3:4:53:Ceinturon de Profanateur en anneaux
20152:3:4:33:Ceinturon de Profanateur en anneaux
20153:3:4:43:Ceinturon de Profanateur en anneaux
20190:3:4:63:Ceinturon de Profanateur en cuir
20191:3:4:33:Ceinturon de Profanateur en cuir
20192:3:4:43:Ceinturon de Profanateur en cuir
20193:3:4:53:Ceinturon de Profanateur en cuir
20171:3:4:63:Ceinturon de Profanateur en cuir de lézard
20172:3:4:33:Ceinturon de Profanateur en cuir de lézard
20173:3:4:43:Ceinturon de Profanateur en cuir de lézard
20174:3:4:53:Ceinturon de Profanateur en cuir de lézard
20195:3:4:63:Ceinturon de Profanateur en mailles
20196:3:4:53:Ceinturon de Profanateur en mailles
20197:3:4:33:Ceinturon de Profanateur en mailles
20198:3:4:43:Ceinturon de Profanateur en mailles
20204:3:4:63:Ceinturon de Profanateur en plaques
20205:3:4:53:Ceinturon de Profanateur en plaques
20206:3:4:43:Ceinturon de Profanateur en plaques
20207:3:4:33:Ceinturon de Profanateur en plaques
20163:3:4:63:Ceinturon de Profanateur en tissu
20164:3:4:33:Ceinturon de Profanateur en tissu
20165:3:4:53:Ceinturon de Profanateur en tissu
20166:3:4:43:Ceinturon de Profanateur en tissu
20178:3:4:33:Ceinturon de Profanateur lamellaire
20180:3:4:43:Ceinturon de Profanateur lamellaire
272773:4:4:65:Ceinturon de qualité de chevalier-capitaine en mailles
272791:4:4:65:Ceinturon de qualité de chevalier-capitaine en plaques
272537:4:4:65:Ceinturon de qualité de légionnaire en anneaux
272522:4:4:65:Ceinturon de qualité de légionnaire en pelombre
272512:4:4:65:Ceinturon de qualité de légionnaire en plaques cimentières
272494:3:4:60:Ceinturon de qualité en anneaux
272712:3:4:60:Ceinturon de qualité en mailles
273372:3:4:60:Ceinturon de qualité en mailles
273362:3:4:60:Ceinturon de qualité en mailles annelées
274214:3:4:60:Ceinturon de qualité en mailles plates
274224:3:4:60:Ceinturon de qualité en mailles rivetées
272711:3:4:60:Ceinturon de qualité en peau de bête
273378:3:4:60:Ceinturon de qualité en peau du Rêve
273369:3:4:60:Ceinturon de qualité en peau lunaire
272468:3:4:60:Ceinturon de qualité en pelombre
273325:3:4:60:Ceinturon de qualité en plaques
273324:3:4:60:Ceinturon de qualité en plaques cimentières
274225:3:4:60:Ceinturon de qualité en écailles
273352:3:4:60:Ceinturon de qualité riveté
11861:2:4:46:Ceinturon de représailles
15587:2:4:35:Ceinturon de Ringtail
22431:4:4:88:Ceinturon de rédemption
7948:2:4:32:Ceinturon de Thero-shan
22442:4:4:88:Ceinturon de traqueur des cryptes
15404:2:4:18:Ceinturon des brisants
20043:3:4:63:Ceinturon des Hautes-terres en anneaux
20088:3:4:53:Ceinturon des Hautes-terres en anneaux
20089:3:4:43:Ceinturon des Hautes-terres en anneaux
20090:3:4:33:Ceinturon des Hautes-terres en anneaux
20045:3:4:63:Ceinturon des Hautes-terres en cuir
20115:3:4:53:Ceinturon des Hautes-terres en cuir
20116:3:4:43:Ceinturon des Hautes-terres en cuir
20117:3:4:33:Ceinturon des Hautes-terres en cuir
20046:3:4:63:Ceinturon des Hautes-terres en cuir de lézard
20103:3:4:53:Ceinturon des Hautes-terres en cuir de lézard
20104:3:4:43:Ceinturon des Hautes-terres en cuir de lézard
20105:3:4:33:Ceinturon des Hautes-terres en cuir de lézard
20044:3:4:63:Ceinturon des Hautes-terres en mailles
20118:3:4:53:Ceinturon des Hautes-terres en mailles
20119:3:4:43:Ceinturon des Hautes-terres en mailles
20120:3:4:33:Ceinturon des Hautes-terres en mailles
20041:3:4:63:Ceinturon des Hautes-terres en plaques
20124:3:4:53:Ceinturon des Hautes-terres en plaques
20125:3:4:43:Ceinturon des Hautes-terres en plaques
20126:3:4:33:Ceinturon des Hautes-terres en plaques
20047:3:4:63:Ceinturon des Hautes-terres en tissu
20097:3:4:53:Ceinturon des Hautes-terres en tissu
20098:3:4:43:Ceinturon des Hautes-terres en tissu
20099:3:4:33:Ceinturon des Hautes-terres en tissu
20042:3:4:63:Ceinturon des Hautes-terres lamellaire
20106:3:4:53:Ceinturon des Hautes-terres lamellaire
20107:3:4:43:Ceinturon des Hautes-terres lamellaire
20108:3:4:33:Ceinturon des Hautes-terres lamellaire
22363:4:15:60:Ceinturon désacralisé
11229:2:4:32:Ceinturon en écailles luisantes
9666:2:4:50:Ceinturon Forte-corne
19093:3:4:60:Ceinturon foudrepique en cuir
19092:3:4:60:Ceinturon foudrepique en mailles
19091:3:4:60:Ceinturon foudrepique en plaques
19094:3:4:60:Ceinturon foudrepique en tissu
20177:3:4:63:Ceinturon lamellaire de Profanateur
20179:3:4:53:Ceinturon lamellaire de Profanateur
19719:4:12:1:Ceinturon primordial hakkari
280307:2:4:35:Ceinturon à gadgets
247684:1:12:1:Cendres oubliées
19065:3:4:59:Cercle d'émeraude
19432:4:4:75:Cercle de la force appliquée
16441:4:4:74:Cerclet de grand maréchal
272750:4:4:65:Cerclet de qualité de grand maréchal en soie
271627:2:15:1:Certificat de couture
271622:2:15:1:Certificat de forge
271626:2:15:1:Certificat de travail du cuir
7907:1:15:16:Certificat des voleurs
271621:2:15:1:Certificat d’alchimie
271624:2:15:1:Certificat d’enchantement
271625:2:15:1:Certificat d’ingénierie
250614:3:2:55:Ceste en thorium
23279:3:4:66:Cestes de chevalier-lieutenant en anneaux
22862:3:4:66:Cestes de garde de sang en anneaux
16499:3:4:63:Cestes de garde de sang en cuir
22867:3:4:66:Cestes de garde de sang en mailles
272617:3:4:60:Cestes de qualité en mailles
273358:3:4:60:Cestes de qualité en mailles annelées
274220:3:4:60:Cestes de qualité en mailles rivetées
272467:3:4:60:Cestes de qualité en pelombre
274193:3:4:60:Cestes de qualité en écailles
17328:1:12:1:Chair de commandant foudrepique
17327:1:12:1:Chair de lieutenant foudrepique
17326:1:12:1:Chair de soldat foudrepique
272439:3:4:65:Champ de sérénité
249396:3:4:25:Champignon mystique
277219:2:4:30:Chapeau confortable de Salomon
3556:2:4:30:Chapeau de mage d’effroi
244230:1:4:1:Chapeau de paille des courants gelés
276272:3:4:1:Chapeau de pêche de maître pêcheur
259846:2:4:48:Chapeau de pêche à large bord
19972:2:4:40:Chapeau du pêcheur chanceux
19039:2:4:48:Chapeau imperméable de Zorbin
21615:4:4:81:Chapeau égaré de Don Rigoberto
272507:4:4:65:Chapel de qualité de seigneur de guerre en plaques cimentières
21744:1:0:1:Chapelet de comètes porte-bonheur
260171:2:4:52:Chapelet grumegueule
22273:3:4:52:Chaperon d'ombrelune
252504:3:4:25:Chaperon de bagarreur en cuir
23261:3:4:71:Chaperon de champion en satin
16489:3:4:63:Chaperon de champion en soie
17570:3:4:63:Chaperon de champion en tisse-effroi
252506:3:4:25:Chaperon de chevaucheur de tempête en cuir
252447:3:4:25:Chaperon de défenseur en cuir
23316:3:4:71:Chaperon de lieutenant-commandant en satin
12064:1:4:1:Chaperon de maître de jeu
272457:3:4:60:Chaperon de qualité de magus
272559:4:4:65:Chaperon de qualité de seigneur de guerre en tisse-gangrène
272677:3:4:60:Chaperon de qualité en étoffe lunaire
272649:3:4:60:Chaperon de qualité soyeux
252507:3:4:25:Chaperon de sagesse en cuir
17591:4:4:74:Chaperon de seigneur de guerre en tisse-effroi
252505:3:4:25:Chaperon de trappeur en cuir
279180:1:4:1:Chaperon d’aventurier vétéran
281693:2:4:1:Chaperon en cuir restauré
277227:2:4:30:Chaperon en mailles de magistrat
252448:3:4:25:Chaperon totémique en cuir
221325:1:7:40:Charge explosive Desctructop
268505:1:12:1:Charge explosive déclenchable à distance
210186:1:15:25:Charge perforante
21690:4:4:75:Charme d'Angelista
211779:1:5:1:Charme de compréhension
19952:4:4:65:Charme de courage de Gri'lek
19957:4:4:65:Charme de destruction d'Hazza'rah
19950:4:4:68:Charme de héros zandalarien
19959:4:4:65:Charme de magie d'Hazza'rah
19955:4:4:65:Charme de nature de Wushoolay
19951:4:4:65:Charme de puissance de Gri'lek
211813:2:12:1:Charme de sentinelle d’Aile-argent
19958:4:4:65:Charme de soin d'Hazza'rah
19954:4:4:65:Charme de supercherie de Renataki
19953:4:4:65:Charme des bêtes de Renataki
21504:4:4:70:Charme des Sables changeants
19956:4:4:65:Charme-esprits de Wushoolay
5863:1:15:1:Charte de guilde
281473:1:15:1:Charte de guilde
281322:1:4:9:Chauffe-pieds de Hurlegivre
281316:2:4:51:Chausses chaînetoyantes
281310:2:4:30:Chausses de carnage
272499:4:4:65:Chausses de qualité de magus général
272470:3:4:60:Chausses de qualité en peau de peau de dragon
272563:3:4:60:Chausses de qualité en satin
2571:1:4:7:Chausses de Viny
10655:1:4:5:Chausses en jonc tressé
9600:1:4:12:Chausses lacées
79:1:4:5:Chausses naines en tissu
10043:2:4:31:Chausses pieuses
281298:2:4:49:Chausses toquées de Ti’ik
277090:1:4:14:Chausses zéphrali
80:1:4:5:Chaussures bordées de fourrure
257281:1:4:5:Chaussures bordées de fourrure
4137:2:4:42:Chaussures darkspear
252531:3:4:45:Chaussures de furtivité en cuir
252466:3:4:45:Chaussures de garde en cuir
252532:3:4:45:Chaussures de mande-ciel en cuir
252465:3:4:45:Chaussures de rôdeur en cuir
252533:3:4:45:Chaussures de soigneur en cuir
276274:3:4:25:Chaussures de surf
257257:1:4:5:Chaussures du bosquet Thendal
277226:2:4:28:Chaussures décousues
263406:2:4:15:Chaussures empyréennes
281692:2:4:1:Chaussures en tissu restaurées
252426:3:4:15:Chaussures en écailles de Murloc
274719:2:4:57:Chaussures oubliées
277103:1:4:14:Chaussures zéphrali
20410:1:0:1:Chauve-souris
277232:2:4:35:Chaîne abandonnée de geôlier
274757:2:4:55:Chaîne de ceinture médiocre
281636:3:4:58:Chaîne de garde de musée
277083:1:4:14:Chaîne zéphrali
23125:3:4:60:Chaînes de la liche
223323:1:4:55:Chemise
273813:1:4:1:Chemise aérienne de garde-paix
273812:1:4:1:Chemise aérienne de magistère
273814:1:4:1:Chemise aérienne d’oracle des cieux
22742:2:4:1:Chemise de la Voile sanglante
11840:1:4:55:Chemise de maître bâtisseur
3342:1:4:15:Chemise du capitaine Sander
14617:1:4:1:Chemise du scieur d'os
270334:1:4:1:Chemise tachée de sueur
859:1:4:17:Chemise élégante
9516:2:4:31:Chemisette du noeud astral
273816:1:4:10:Chemisette d’apprenti
18248:4:15:40:Cheval de guerre squelette rouge
8703:2:12:45:Chevalière d'expertise
277210:3:4:25:Chevalière de Bois-du-Bûcher
275982:4:4:65:Chevalière de clairvoyance de garde
275973:3:4:68:Chevalière de clairvoyance de traque
275977:4:4:60:Chevalière de clairvoyance de veille
275969:3:4:63:Chevalière de clairvoyance d’initiation
272408:3:4:65:Chevalière de coupe-gorge
275983:4:4:65:Chevalière de détermination de garde
275974:3:4:68:Chevalière de détermination de traque
275979:4:4:60:Chevalière de détermination de veille
275970:3:4:63:Chevalière de détermination d’initiation
21393:4:4:65:Chevalière de force inflexible
275981:4:4:65:Chevalière de férocité de garde
275972:3:4:68:Chevalière de férocité de traque
275976:4:4:60:Chevalière de férocité de veille
275968:3:4:63:Chevalière de férocité d’initiation
6757:2:4:38:Chevalière de Jaina
20600:4:4:72:Chevalière de Malfurion
21436:1:15:1:Chevalière de mérite de l'Alliance
21438:1:15:1:Chevalière de mérite de la Horde
281304:2:4:31:Chevalière de prospecteur
271908:3:4:63:Chevalière de Theramore
271909:3:4:53:Chevalière de Theramore
271910:3:4:43:Chevalière de Theramore
271911:3:4:33:Chevalière de Theramore
275984:4:4:65:Chevalière de vigilance de garde
275975:3:4:68:Chevalière de vigilance de traque
275980:4:4:60:Chevalière de vigilance de veille
275971:3:4:63:Chevalière de vigilance d’initiation
23018:4:4:83:Chevalière du défenseur déchu
21402:4:4:65:Chevalière du sentier invisible
18403:4:4:65:Chevalière du tueur de dragon
21196:4:4:60:Chevalière du Vol de bronze
21197:4:4:65:Chevalière du Vol de bronze
21198:4:4:70:Chevalière du Vol de bronze
21199:4:4:75:Chevalière du Vol de bronze
21200:4:4:80:Chevalière du Vol de bronze
21201:4:4:60:Chevalière du Vol de bronze
21202:4:4:65:Chevalière du Vol de bronze
21203:4:4:70:Chevalière du Vol de bronze
21204:4:4:75:Chevalière du Vol de bronze
21205:4:4:80:Chevalière du Vol de bronze
21206:4:4:60:Chevalière du Vol de bronze
21207:4:4:65:Chevalière du Vol de bronze
21208:4:4:70:Chevalière du Vol de bronze
21209:4:4:75:Chevalière du Vol de bronze
21210:4:4:80:Chevalière du Vol de bronze
281288:2:4:57:Chevalière shen’dorei
272068:3:4:63:Chevalière sombrelance
272069:3:4:53:Chevalière sombrelance
272070:3:4:43:Chevalière sombrelance
272071:3:4:33:Chevalière sombrelance
274748:3:2:35:Chevrotine de cogneur de Baie-du-Butin
19141:2:4:50:Chiffon
271740:2:4:33:Chiffon à polir les couteaux
5951:1:0:30:Chiffon à poussière
11917:2:4:55:Chiffon à tuyères de Shizzle
21180:4:4:66:Choc de terre
277247:2:2:12:Chope de souvenirs confus
2820:2:4:50:Chouette chronomètre
279393:3:2:30:Chutegivre
6185:1:4:5:Châle de l'ours
277289:2:4:23:Châle de voyage
3449:2:4:15:Châle mystique
19721:4:12:1:Châle primordial hakkari
263403:2:4:11:Cilice de regret
257333:1:2:10:Cimeterre courbe
270092:2:2:45:Cimeterre des Flots noirs
277257:3:4:29:Cimier de Colline-aux-Corbeaux
6223:2:4:35:Cimier de Darkshire
8007:1:0:48:Citrine de mana
23161:1:0:55:Citronnade fraîchement pressée
211534:1:0:1:Clairvoyance primordiale
276200:2:4:45:Claqueurs de clampant
18876:4:2:78:Claymore de connétable
272851:4:2:65:Claymore de qualité de connétable
6893:1:13:1:Clé d'atelier
227928:1:15:1:Clé de boîte à outils
214435:1:13:1:Clé de cage à puma
227930:1:15:1:Clé de cassette
210963:1:13:1:Clé de clairvoyant
238345:1:12:1:Clé de dame Sesspira
282285:1:0:1:Clé de déboiseur
7442:1:12:1:Clé de Gyromast
267089:1:13:1:Clé de la base des Krol’dok
216523:1:13:1:Clé de la cage rouillée
13873:1:13:1:Clé de la Chambre des visions
18266:1:13:1:Clé de la cour des Gordok
5396:1:13:1:Clé de la gorge des Vents brûlants
237011:3:13:1:Clé de la herse
18268:1:13:1:Clé de la porte intérieure des Gordok
245675:1:13:1:Clé de la porte intérieure des Gordok
11140:1:13:1:Clé de la prison
209030:1:13:1:Clé de la réserve d’équipement
12382:2:13:1:Clé de la ville
268520:1:12:1:Clé de Lamora
229362:1:15:1:Clé de l’entrepôt
11855:2:4:19:Clé de Tork
18250:2:15:1:Clé des menottes gordok
12738:1:12:1:Clé des toilettes de Dalson
277507:2:13:1:Clé des égouts de Dalaran
12739:1:12:1:Clé du cabinet de Dalson
210968:1:13:1:Clé du reliquaire
271721:1:13:1:Clé d’Ogre krol’dok
18249:1:13:1:Clé en croissant
281358:1:13:1:Clé en pierre
221324:1:13:1:Clé fragile
210209:1:13:1:Clé jumelle
13140:1:12:49:Clé rouge sang
263313:2:2:10:Clé à molette fiable
8411:1:0:1:Cocktail de jus de poumon
23715:1:0:1:Cocktail de jus de poumon permanent
276895:2:4:30:Cocon de métamorphose
220353:1:5:50:Codex d’adjurateur
19802:4:12:58:Coeur d'Hakkar
13164:3:4:61:Coeur de l'Ecaille
257126:1:12:1:Coeur de l’Oblitérateur
18147:1:12:60:Coeur de Réprouvé
5179:1:12:5:Coeur moussu
20602:1:15:1:Coffre de butin
13247:2:15:60:Coffre de l'Intendant Zigris
221471:2:15:55:Coffre des gardiens d’émeraude
10752:2:15:55:Coffre incrusté d'émeraudes
19425:2:0:1:Coffre mystérieux
270257:2:15:15:Coffret du capitaine Sander
208838:2:15:20:Coffret Sombrefer
281723:2:2:1:Cogneur restauré
4124:2:4:40:Coiffe d'harmonie
22013:4:4:60:Coiffe de belluaire
277211:2:4:46:Coiffe de réflexion de Dudd
20643:2:4:47:Coiffe de réserviste de Fossoyeuse
22097:4:4:60:Coiffe des Cinq tonnerres
270093:2:4:45:Coiffe des Flots noirs
4543:2:4:40:Coiffe en peau de drake blanc
22005:4:4:60:Coiffe Sombremante
6720:2:4:37:Coiffure de chasseur d'esprit
17602:4:4:74:Coiffure de grand maréchal
21377:1:12:1:Coiffure de plumes mort-bois
272818:4:4:65:Coiffure de qualité de grand maréchal en étoffe du Vide
273421:4:4:65:Coiffure de qualité de grand maréchal en étoffe lunaire
260195:2:4:55:Coiffure des damnés
23032:4:4:83:Coiffure glaciale
270067:2:4:39:Coiffure sauvage
274417:3:4:58:Colifichet peau-d’écorce
281730:2:4:1:Colifichet restauré
4941:1:0:10:Colle très collante
21664:4:4:77:Collier barbelé
7666:2:12:37:Collier brisé
7716:1:12:1:Collier brisé
1187:2:0:33:Collier clouté
20622:4:4:71:Collier coeur-de-dragon
11946:2:4:52:Collier d'opale rougeoyante
23058:4:4:92:Collier de canalisation de vie
249698:1:12:1:Collier de charmes ornés de plumes
17689:1:12:1:Collier de dressage foudrepique
18355:3:4:60:Collier de Ferra
13811:2:4:60:Collier de l'Aube
260247:1:15:1:Collier de la mélancolie
19159:3:4:51:Collier de lierre tressé
23036:4:4:83:Collier de nécropsie
13583:3:15:20:Collier de panda
180089:1:15:20:Collier de panda
281166:3:15:20:Collier de panda
12558:1:12:52:Collier de plumes bleues
23007:1:15:1:Collier de porcelet
21678:4:4:76:Collier de pureté
10778:2:4:60:Collier de sanctuaire
19303:3:4:55:Collier de Sombrelune
20685:4:4:65:Collier du front de mer
4112:2:4:44:Collier du Grand chaman
18814:4:4:78:Collier du Seigneur du Feu
271807:2:4:43:Collier défraîchi
21531:4:4:77:Collier en dents de drake
15690:2:4:41:Collier en os de kodo
281302:2:4:44:Collier en écailles de dragonnet
259461:1:15:1:Collier partiellement digéré
22981:4:4:83:Collier perdu de Gluth
281719:2:4:1:Collier restauré
221974:2:15:40:Collier Totem-sinistre
18206:1:12:1:Colonne vertébrale de nain
210323:1:15:1:Combinaison du coffre
210187:1:15:25:Commande de la KapitalRisk
22568:1:15:1:Commission d'artisan scellée
280611:3:15:40:Compagnon fidèle d’aventurier aguerri
6093:2:2:27:Concassorc
19978:1:15:1:Concours de pêche !
249455:3:4:50:Conduit en vrai-argent
281265:2:4:20:Confiance de guette-chemin
262917:1:15:1:Conteneur homologué
3668:1:12:30:Contrat de l'assassin
18628:4:12:60:Contrat de la Confrérie du Thorium
227730:4:12:60:Contrat de la Confrérie du Thorium
274957:2:4:38:Convoyeurs à bois
286727:4:15:60:Coq cramoisi
10725:1:4:46:Coq de combat gnome
274749:3:4:35:Coquillage souvenir
219414:1:15:25:Coquilles d’œufs brisées
19029:4:15:60:Cor du hurleur loup-de-givre
18245:4:15:40:Cor du loup de guerre noir
254037:3:4:45:Corde ambrée
254081:3:4:52:Corde cintrée ambrée
281260:2:4:50:Corde cintrée ancestrale
270007:2:4:18:Corde cintrée de mineur usée
272402:4:4:60:Corde cintrée de prophète
272405:4:4:60:Corde cintrée de rédemption
254089:3:4:52:Corde cintrée dorée
254085:3:4:52:Corde cintrée embrasée
254087:3:4:52:Corde cintrée noire
254091:3:4:52:Corde cintrée radieuse
254083:3:4:52:Corde cintrée écumeuse
280308:2:4:35:Corde cliquetante
272187:3:4:43:Corde couverte d’épines
263335:2:4:13:Corde de chasseur
272398:4:4:60:Corde de conservateur
272813:3:4:60:Corde de qualité en étoffe du Vide
273449:3:4:60:Corde de qualité en étoffe lunaire
22098:3:4:65:Corde des Cinq tonnerres
254045:3:4:45:Corde dorée
254041:3:4:45:Corde embrasée
272401:4:4:60:Corde en élunite
254043:3:4:45:Corde noire
281261:2:4:55:Corde parsemée de cristaux
254047:3:4:45:Corde radieuse
277101:1:4:14:Corde zéphrali
277216:2:4:45:Corde à couture croisée
254039:3:4:45:Corde écumeuse
9657:2:4:49:Cordelière de la charmille
260184:3:4:55:Cordelière de marcheur des falaises
272394:4:4:60:Cordelière de pénitence
272720:3:4:60:Cordelière de qualité de chevalerie
272767:4:4:65:Cordelière de qualité de chevalier-capitaine en cuir
272573:4:4:65:Cordelière de qualité de légionnaire en satin
273432:4:4:65:Cordelière de qualité de légionnaire soyeuse
274228:3:4:60:Cordelière de qualité en écailles
274259:3:4:60:Cordelière de qualité lamellaire
273366:3:4:60:Cordelière de qualité lumineuse
277224:2:4:35:Cordelière de réducteur de tête de Kurzen
5609:2:4:22:Cordelière inébranlable
15469:2:4:29:Cordelière Windsong
23027:4:4:85:Cordialité du pardon
19842:4:4:61:Cordon de confesseur zandalar
10000:1:12:40:Corne de Margol
275736:3:4:61:Corne de Ve’han
221971:2:15:40:Corne du serment onirique
235256:1:12:1:Corne legashi coupée
12782:3:2:58:Corruption
16430:3:4:63:Corselet de chevalier-capitaine en plaques
272739:3:4:60:Corselet de qualité en plaques
281711:2:4:1:Corselet en plaques restauré
276899:3:4:38:Cosse articulaire
274379:2:15:1:Cosse en éveil
249900:1:15:1:Cosse régurgitée
3166:2:4:15:Cotte d'anneaux Coeur-de-fer
3733:2:4:23:Cotte d'anneaux de guerre orque
1273:2:4:25:Cotte d'anneaux de la forêt
7336:2:4:24:Cotte d'anneaux forestière
263333:2:4:13:Cotte de mailles de garde-paix
274187:4:4:65:Cotte de mailles plates de qualité de grand maréchal
274210:4:4:65:Cotte de mailles rivetées de qualité de grand maréchal
272542:4:4:65:Cotte de mailles rivetées de seigneur de guerre
277080:1:4:14:Cotte de mailles zéphrali
250522:3:4:27:Cotte d’anneaux argentés de croisé
250519:3:4:27:Cotte d’anneaux argentés de garde
250520:3:4:27:Cotte d’anneaux argentés de protecteur
250518:3:4:27:Cotte d’anneaux argentés de vétéran
250521:3:4:27:Cotte d’anneaux argentés d’acolyte
250492:3:4:20:Cotte d’anneaux de croisé
250489:3:4:20:Cotte d’anneaux de garde
6773:2:4:42:Cotte d’anneaux de maraudeur kolkar
250490:3:4:20:Cotte d’anneaux de protecteur
250488:3:4:20:Cotte d’anneaux de vétéran
250491:3:4:20:Cotte d’anneaux d’acolyte
274202:4:4:65:Cotte d’écailles de qualité de grand maréchal
273340:4:4:65:Cottes de mailles de qualité de seigneur de guerre
15198:1:4:40:Couleurs de chevalier
272695:1:4:40:Couleurs de chevalier
287090:1:4:17:Coupe-papier
274928:2:2:39:Couperet de Kurty
281720:2:2:1:Couperet restauré
19807:1:15:45:Courbine
17578:4:4:74:Couronne de grand maréchal
23323:1:4:1:Couronne de la fête du Feu
16416:3:4:63:Couronne de lieutenant-commandant
272802:4:4:65:Couronne de qualité de grand maréchal en tisse-effroi
272725:3:4:60:Couronne de qualité en soie
21329:4:4:81:Couronne du Conquérant
22065:4:4:60:Couronne du sorcier
21387:4:4:81:Couronne du Vengeur
22080:4:4:60:Couronne vertueuse
21190:4:4:66:Courroux de Cénarius
19621:4:4:65:Courroux du maelström
272849:4:2:65:Couteau de brèche de qualité de connétable
4974:2:2:12:Couteau de combat compact
2195:1:2:5:Couteau de Courbenclume
2225:1:2:11:Couteau de cuisine
3445:1:2:12:Couteau de cérémonie
274383:2:2:58:Couteau de Kanai
20086:2:2:52:Couteau de lancer du crépuscule d'acier
10547:1:2:8:Couteau des campeurs
251485:2:2:24:Couteau d’Edward
2137:1:2:5:Couteau tailladant
277108:1:2:14:Couteau zéphrali
269716:2:2:18:Couteau à dépecer effilé
3581:2:2:18:Couteau-scie
263432:2:2:10:Coutelas de furtivité
16890:2:2:24:Coutelas de Slatemetal
272181:2:2:43:Coutelas fantasmatique
12735:2:12:1:Couture d'Abomination effilochée
6789:2:4:42:Couverture de cérémonie centaure
2165:1:4:10:Couverture de la Vieille Blanchy
4113:2:4:45:Couverture-médecine
19846:4:4:61:Couvre-bras d'illusionniste zandalar
19843:4:4:61:Couvre-bras de confesseur zandalar
19848:4:4:61:Couvre-bras de démoniaque zandalar
263414:1:4:8:Couvre-bras de voyageur
22466:4:4:88:Couvre-chef de Brise-terre
22490:4:4:88:Couvre-chef de marcherêve
22428:4:4:88:Couvre-chef de rédemption
22438:4:4:88:Couvre-chef de traqueur des cryptes
22360:4:15:60:Couvre-chef désacralisé
19986:3:4:52:Couvre-oeil de pirate
274022:3:4:1:Couvre-œil de dur-à-cuire
276105:2:4:43:Couvre-œil du maître-éclaireur
4127:2:2:40:Crache-mitraille
17002:2:2:61:Cracheur d'ichor
270112:2:4:53:Cravache de chevaucheur de griffon
209849:1:5:25:Crimes contre l’anatomie
19941:2:12:1:Crinière de Wushoolay
9638:2:4:50:Crispins chéloniens
277214:2:4:35:Crispins croûtés
16486:3:4:63:Crispins d'adjudant en soie
18437:3:4:50:Crispins d'adjudant en soie
4133:2:4:37:Crispins darkspear
254065:3:4:50:Crispins de flamme-du-Néant
2032:2:4:36:Crispins de Gallan
5612:1:4:13:Crispins de lierre
270091:2:4:44:Crispins de loup de mer usés
254071:3:4:50:Crispins de lumière-du-Néant
254067:3:4:50:Crispins de perle-du-Néant
272806:4:4:65:Crispins de qualité de chevalier-capitaine en tisse-effroi
272454:3:4:60:Crispins de qualité de magus
272503:4:4:65:Crispins de qualité de magus légionnaire
272567:3:4:60:Crispins de qualité en satin
272702:3:4:60:Crispins de qualité en soie
272811:3:4:60:Crispins de qualité en étoffe du Vide
273444:3:4:60:Crispins de qualité en étoffe lunaire
273450:3:4:60:Crispins de qualité soyeux
18456:3:4:63:Crispins de sergent-major en soie
18457:3:4:50:Crispins de sergent-major en soie
270073:2:4:40:Crispins de Stromgarde
251486:2:4:24:Crispins de Tabitha
254061:3:4:50:Crispins d’or-du-Néant
254069:3:4:50:Crispins d’éclat-du-Néant
254063:3:4:50:Crispins d’écume-du-Néant
16791:2:4:38:Crispins flot-de-soie
272186:3:4:43:Crispins luxuriants
277222:2:4:58:Crispins ornés de peinture de guerre
277099:1:4:14:Crispins zéphrali
263425:1:4:10:Crispins élégants
263311:2:4:11:Crispins éraflés
243203:1:15:1:Cristal colossal
246888:1:15:1:Cristal colossal
19344:4:4:76:Cristal d'alignement sur la nature
11566:1:12:55:Cristal d'explosion
20636:4:4:71:Cristal d'hibernation
269233:1:12:1:Cristal de cendre imprégné
11563:1:12:55:Cristal de concentration
260201:2:4:55:Cristal de mémoire de Bien-né
11564:1:12:55:Cristal de protection
11562:1:12:55:Cristal de restauration
11565:1:12:55:Cristal de réduction
21218:3:15:60:Cristal de résonance qiraji bleu
21324:3:15:60:Cristal de résonance qiraji jaune
21176:5:15:60:Cristal de résonance qiraji noir
21321:3:15:60:Cristal de résonance qiraji rouge
21323:3:15:60:Cristal de résonance qiraji vert
11567:1:12:55:Cristal de rétribution
17423:1:12:1:Cristal de tempête
209838:1:15:25:Cristal hypnotique
221317:1:0:50:Cristaux telluriques de Feralas
221319:1:0:50:Cristaux telluriques de Rochenoire
221320:1:0:50:Cristaux telluriques des Hinterlands
221318:1:0:50:Cristaux telluriques d’Azshara
221973:2:15:40:Croc de Chasse-rêves
281314:3:2:32:Croc de Dragon soumis
21523:4:2:76:Croc de Korialstrasz
20214:4:2:60:Croc de l'esprit
213709:1:15:1:Croc de serpent-nuage
191661:3:0:1:Croc d’araignée monstrueux
277190:1:12:1:Crochet de Githyiss
6738:2:2:35:Croissant sanglant
281259:2:4:50:Croquenots de Pierrêche
276727:2:4:30:Croquenots scintillants
4945:1:0:9:Crâne au faible rougeoiement
207733:1:15:1:Crâne de Kul Tiras
4984:2:4:41:Crâne de malédiction imminente
271777:1:12:1:Crâne rongé
3431:2:4:25:Cuir clouté d'os
11228:1:15:1:Cuir de dragon frénétique
10575:1:15:1:Cuir de dragon noir
3750:2:4:30:Cuirasse côtelée
21997:4:4:60:Cuirasse d'héroïsme
22089:4:4:60:Cuirasse d'Âmeforge
22416:4:4:92:Cuirasse de cuirassier
16466:4:4:74:Cuirasse de grand maréchal en anneaux
16452:4:4:74:Cuirasse de grand maréchal en peau de dragon
22476:4:4:92:Cuirasse de la faucheuse d'os
19825:4:4:65:Cuirasse de libre-penseur zandalar
16525:3:4:63:Cuirasse de légionnaire en anneaux
16504:3:4:63:Cuirasse de légionnaire en peau de dragon
272742:3:4:60:Cuirasse de qualité de chevalerie
272775:4:4:65:Cuirasse de qualité de grand maréchal en mailles
272761:4:4:65:Cuirasse de qualité de grand maréchal en peau de bête
273403:4:4:65:Cuirasse de qualité de grand maréchal en peau du Rêve
273395:4:4:65:Cuirasse de qualité de grand maréchal en peau lunaire
272528:4:4:65:Cuirasse de qualité de seigneur de guerre en pelombre
272490:3:4:60:Cuirasse de qualité en anneaux
272472:3:4:60:Cuirasse de qualité en peau de dragon
274230:3:4:60:Cuirasse de qualité en écailles
274244:3:4:60:Cuirasse de qualité lamellaire
272852:3:4:60:Cuirasse de qualité lumineuse
270096:2:4:46:Cuirasse de rebelle
19822:4:4:65:Cuirasse de redresseur de torts zandalar
16563:4:4:74:Cuirasse de seigneur de guerre en cuir
11193:2:4:57:Cuirasse des vents brûlants
21331:4:4:88:Cuirasse du Conquérant
21389:4:4:88:Cuirasse du Vengeur
22349:4:15:60:Cuirasse désacralisée
250595:3:4:62:Cuirasse en thorium enrichi
16433:3:4:63:Cuirasse lamellaire de chevalier-capitaine
23272:3:4:68:Cuirasse lamellaire de chevalier-capitaine
12106:2:4:60:Cuirasse peau-de-roche
259890:2:4:48:Cuissarde de pêche des grands fonds
277233:2:4:45:Cuissards cliquetants en mailles
22000:3:4:66:Cuissards d'héroïsme
22092:3:4:66:Cuissards d'Âmeforge
10740:2:4:53:Cuissards de centurion
23293:3:4:68:Cuissards de chevalier-capitaine en anneaux
23299:3:4:68:Cuissards de chevalier-capitaine en cuir
23302:3:4:68:Cuissards de chevalier-capitaine en satin
23304:3:4:68:Cuissards de chevalier-capitaine en soie
23296:3:4:68:Cuissards de chevalier-capitaine en tisse-effroi
22417:4:4:88:Cuissards de cuirassier
21667:4:4:76:Cuissards de lumière flamboyante
22875:3:4:68:Cuissards de légionnaire en anneaux
22880:3:4:68:Cuissards de légionnaire en cuir
22887:3:4:68:Cuissards de légionnaire en mailles
22882:3:4:68:Cuissards de légionnaire en satin
22883:3:4:68:Cuissards de légionnaire en soie
22881:3:4:68:Cuissards de légionnaire en tisse-effroi
22489:4:4:88:Cuissards de marcherêve
19117:2:4:50:Cuissards de plaques de bois laquées
274240:4:4:65:Cuissards de qualité de général en écailles
272784:4:4:65:Cuissards de qualité de maréchal de chevalerie
273333:4:4:65:Cuissards de qualité de maréchal lumineux
22427:4:4:88:Cuissards de rédemption
20699:3:4:63:Cuissards de réserviste cénariens
20700:3:4:63:Cuissards de réserviste cénariens
22672:4:4:65:Cuissards de sentinelle en plaques
22753:4:4:65:Cuissards de sentinelle lamellaires
22437:4:4:88:Cuissards de traqueur des cryptes
21332:4:4:81:Cuissards du Conquérant
21390:4:4:81:Cuissards du Vengeur
22359:4:15:60:Cuissards désacralisés
20639:4:4:72:Cuissards ornés de glyphes étranges
277241:2:4:45:Cuissards à doubles plaques
274151:1:12:1:Cuissot de sabre-de-nuit tendre
22477:4:4:88:Cuissots de la faucheuse d'os
20701:3:4:63:Cuissots de réserviste cénariens
20702:3:4:63:Cuissots de réserviste cénariens
22352:4:15:60:Cuissots désacralisés
11916:2:4:55:Culasse de Shizzle
1436:2:4:17:Culotte des frontaliers
5310:2:4:20:Culotte du loup de mer
276201:2:4:45:Culotte égarée
276888:2:2:24:Cure-dent huran
282064:2:2:12:Côte perdue de Tim
277248:3:2:45:Côte rituelle ébréchée
249470:3:4:55:Cœur brûlant de la montagne
221326:1:15:1:Cœur de cerf sacré
228105:4:12:60:Cœur de flamme semperardent
208158:1:15:1:Cœur de trogg en parfait état
249473:3:4:55:Cœur dormant de la montagne
249469:3:4:55:Cœur gelé de la montagne
2218:2:2:13:Dague d'artisan
6969:2:2:15:Dague d'Elunite
6981:2:2:15:Dague d'Umbral
15396:2:2:14:Dague de Curvewood
6980:2:2:15:Dague de Haggard
7116:2:2:15:Dague de l'héritier
2224:1:2:5:Dague de la milice
260172:2:2:52:Dague de l’assassin
277515:2:2:33:Dague de négociation
15706:2:2:57:Dague de poursuite
257346:2:2:13:Dague de prestelame
257283:1:2:5:Dague de reconnaissance des Forestiers
7327:2:2:15:Dague de Thun'grim
4947:2:2:11:Dague dentelée
5392:1:2:5:Dague des chardons
21404:4:2:70:Dague des ombres voilées
3268:1:2:5:Dague des Réprouvés
15783:2:2:60:Dague du chasseur de bête
10703:2:2:45:Dague démoniaque
281143:1:15:1:Dague d’Ira
260180:2:2:52:Dague d’éclaireuse
20647:2:2:59:Dague en cristal noir
10697:2:2:60:Dague Felbane en azsharite enchanté
281722:2:2:1:Dague restaurée
191292:3:0:1:Dague rituelle
281331:1:12:35:Dague rituelle des Sculpte-vents
257332:1:2:10:Dague rituelle tachée
281297:2:2:25:Dague royale
19100:3:2:65:Dague électrifiée
281257:2:2:16:Dague-croc de Daguecroc
270887:3:15:1:Demande de licence publicitaire
270888:3:15:1:Demande de licence publicitaire
210213:1:13:1:Demi-clé de la sœur
210212:1:13:1:Demi-clé du frère
18207:1:12:1:Dent d'orc
19940:2:12:1:Dent de Renataki
277981:2:4:44:Dent d’Ogre souvenir
227687:2:12:1:Dent en or préférée d’Orthas
22688:3:2:66:Dernière chance de Verimonde
211269:1:12:1:Dessin primitif
19030:4:15:60:Destrier de bataille foudrepique
23465:4:2:78:Destructeur de grand seigneur de guerre
272682:4:2:65:Destructeur de qualité de grand seigneur de guerre
4983:2:2:42:Destructeur de roc
271667:2:2:33:Destructeur en bois-de-fer
269742:2:2:18:Deuxième arme préférée de Walton
277256:2:2:45:Deuxième baguette préférée de Dudd
231844:1:0:1:Deuxième fragment de cachet
271812:3:4:43:Diadème abandonné
253959:3:4:25:Diadème brillant
253985:3:4:30:Diadème brillant filigrané
21372:4:4:81:Diadème d'implorateur de tempête
21337:4:4:81:Diadème d'implorateur funeste
22514:4:4:88:Diadème de foi
22498:4:4:88:Diadème de givrefeu
21347:4:4:81:Diadème de l'énigme
17598:3:4:63:Diadème de lieutenant-commandant
22506:4:4:88:Diadème de pestecoeur
272814:3:4:60:Diadème de qualité en étoffe du Vide
20930:4:12:1:Diadème de Vek'lor
20926:4:12:1:Diadème de Vek'nilash
253953:3:4:25:Diadème des flammes
253979:3:4:30:Diadème des flammes filigrané
21366:4:4:81:Diadème du Frappeur
22367:4:15:60:Diadème désacralisé
253949:3:4:25:Diadème immaculé
253975:3:4:30:Diadème immaculé filigrané
253957:3:4:25:Diadème nacré
253983:3:4:30:Diadème nacré filigrané
253955:3:4:25:Diadème ombreux
253981:3:4:30:Diadème ombreux filigrané
253951:3:4:25:Diadème soyeux
253977:3:4:30:Diadème soyeux filigrané
219518:1:12:50:Diatribe de harpie
10587:1:4:46:Distributeur de bombes des gobelins
276721:2:4:10:DNT CHEST
276719:2:4:10:DNT HEAD
276725:2:4:10:DNT LEGS
249397:3:4:25:Doctrines de la Main d’argent
281263:2:2:29:Doigt de liche malfaisante
6774:2:4:42:Doigt de traître
19697:1:4:1:Don de la moisson
271871:4:0:60:Don du galop
242268:2:0:1:Donnez un enchantement à un Croisé…
22648:1:15:1:Dossier sur la Ruche'Ashi
22649:1:15:1:Dossier sur la Ruche'Regal
22650:1:15:1:Dossier sur la Ruche'Zora
22239:1:0:1:Douce surprise
21522:4:2:76:Douleur de Shadowsong
15804:2:4:56:Drapé cerise
15468:2:4:29:Drapé chantevent
21394:4:4:67:Drapé de force inflexible
272413:3:4:65:Drapé de récupération
17523:2:4:58:Drapé de Smokey
275046:2:4:46:Drapé de suzerain du Crépuscule
21415:4:4:67:Drapé des secrets scellés
275668:2:4:59:Drapé du sommet
274035:2:4:57:Drapé en peau de cerf
20885:3:12:1:Drapé martial qiraji
20889:3:12:1:Drapé royal qiraji
276204:3:4:45:Déchets de Lamine
17384:3:12:1:Déchiqueteur portable de Zinfizzlex
17410:3:12:1:Déchiqueteur portatif de Zinfizzlex
3451:2:4:18:Décoction de lueur nocturne
9679:2:2:43:Découpeur de Tok'kar
6186:2:2:18:Découpeur de trogg
18830:4:2:78:Découpeuse de connétable
272840:4:2:65:Découpeuse de qualité de connétable
274920:2:2:40:Découpeuse du Crépuscule
21326:4:4:62:Défenseur des Grumegueules
6187:2:4:17:Défenseur nain
268873:4:4:62:Défenseur peau-d’écorce
9643:2:4:51:Déflecteur optomatique
277288:2:2:23:Dégagement de guide
22236:1:0:1:Délice au lait
23455:4:2:78:Démolisseur de connétable
272858:4:2:65:Démolisseur de qualité de connétable
184938:2:0:60:Déplaceur de chronochance surchargé
22237:1:0:1:Désir noir
6194:2:2:32:Désosseuse
5693:1:12:1:Détonateur à distance (Bleu)
5692:1:12:1:Détonateur à distance (Rouge)
242267:2:0:1:D’arcaniste à archimage
22151:1:12:1:Eau bénite d'Anthion
737:1:12:1:Eau de la source sacrée
8432:1:0:1:Eau de Mixilpixil
13180:1:12:1:Eau sacrée de Stratholme
13920:1:12:55:Ecaille de dragon luisante
17685:1:15:1:Echantillon de Gourmandises Fumebois
11570:1:12:1:Echantillon de phéromone préservé
6740:2:4:29:Echarpe azur
4117:2:4:44:Echarpe brûlante
16975:3:4:27:Echarpe chanteguerre
3442:1:4:12:Echarpe d'apprenti
15707:2:4:58:Echarpe de Brantwood
9636:2:4:45:Echarpe de bretteur
6477:2:4:20:Echarpe de la prairie
22743:2:4:1:Echarpe de la Voile sanglante
3747:2:4:30:Echarpe de méditation
10747:2:4:41:Echarpe de professeur
3344:2:4:15:Echarpe du capitaine Sander
6780:2:4:36:Echarpe lilas
19720:4:12:1:Echarpe primordiale hakkari
983:1:4:9:Echarpe rouge en lin
15791:2:4:58:Echarpe turquoise
18762:3:4:54:Eclat de la Flamme verte
12296:2:2:17:Eclat de la milice du peuple
18659:4:12:71:Eclat de Nordrassil
17142:5:2:70:Eclat du Souilleur
10441:1:12:15:Eclat luminescent
18708:1:12:71:Ecorce pétrifiée
3462:2:2:24:Ecorcheuse
6478:2:4:23:Ecrabouille-rat
6188:2:4:15:Ecrase-boue
4964:2:2:12:Ecraseur gobelin
271805:3:4:42:Effigie de triple damnation
18825:4:4:78:Egide de connétable
10686:2:4:55:Egide de guerre
19345:4:4:76:Egide de préservation
19724:4:12:1:Egide primordiale hakkari
22192:1:0:60:Elixir d'esquive de varech de sang
22193:1:0:60:Elixir de résistance de varech de sang
8529:1:0:45:Elixir Noggenfogger
5321:2:2:20:Elégante épée courte
232455:7:7:1:Emblème de déshonneur
232456:7:7:1:Emblème de l’Œil pourpre
217718:1:15:1:Emblème de magie du sang
232454:7:7:1:Emblème des dieux sauvages
232457:7:7:1:Emblème du cœur du monde
17124:1:12:1:Emblème du Syndicat
217717:1:15:1:Emblème vide
12646:1:12:1:Emeraude d'Infus
280607:3:2:40:Emprise de la foudre
253260:1:15:60:Encabulateur d’imitation morphologique miniature
281040:1:15:1:Encens préparé
275730:2:15:61:Encensoir arcanique
5421:1:0:45:Enchantement d'éclat flamboyant
273490:1:0:1:Enchantement de brassards (Force inférieure)
12564:1:12:23:Engagement d'assassin
10702:2:4:43:Enormes bottes d'ogre
227360:4:15:55:Ensemble bottes, jambes et épaules astrales
227379:4:15:55:Ensemble bottes, jambes et épaules corrompues
227370:4:15:55:Ensemble bottes, jambes et épaules de la volonté divine
227371:4:15:55:Ensemble bottes, jambes et épaules de l’aube
227377:4:15:55:Ensemble bottes, jambes et épaules de l’impact
227376:4:15:55:Ensemble bottes, jambes et épaules de l’éruption
227366:4:15:55:Ensemble bottes, jambes et épaules de poursuivant
227372:4:15:55:Ensemble bottes, jambes et épaules du crépuscule
227373:4:15:55:Ensemble bottes, jambes et épaules du frisson
227361:4:15:55:Ensemble bottes, jambes et épaules du gardien
227365:4:15:55:Ensemble bottes, jambes et épaules du soigneur
227375:4:15:55:Ensemble bottes, jambes et épaules du soulagement
227359:4:15:55:Ensemble bottes, jambes et épaules félines
227381:4:15:55:Ensemble bottes, jambes et épaules inamovibles
227382:4:15:55:Ensemble bottes, jambes et épaules irrésistibles
227368:4:15:55:Ensemble bottes, jambes et épaules miséricordieuses
227369:4:15:55:Ensemble bottes, jambes et épaules radieuses
227338:4:15:55:Ensemble gants et ceinture astraux
227354:4:15:55:Ensemble gants et ceinture corrompus
227345:4:15:55:Ensemble gants et ceinture de la volonté divine
227346:4:15:55:Ensemble gants et ceinture de l’aube
227341:4:15:55:Ensemble gants et ceinture de poursuivant
227347:4:15:55:Ensemble gants et ceinture du crépuscule
227348:4:15:55:Ensemble gants et ceinture du frisson
227339:4:15:55:Ensemble gants et ceinture du gardien
227340:4:15:55:Ensemble gants et ceinture du soigneur
227350:4:15:55:Ensemble gants et ceinture du soulagement
227352:4:15:55:Ensemble gants et ceinture d’impact
227351:4:15:55:Ensemble gants et ceinture d’éruption
227337:4:15:55:Ensemble gants et ceinture félins
227356:4:15:55:Ensemble gants et ceinture inamovibles
227357:4:15:55:Ensemble gants et ceinture irrésistibles
227343:4:15:55:Ensemble gants et ceinture miséricordieux
227344:4:15:55:Ensemble gants et ceinture radieux
227384:4:15:55:Ensemble heaume et plastron astraux
227401:4:15:55:Ensemble heaume et plastron corrompus
227392:4:15:55:Ensemble heaume et plastron de la volonté divine
227393:4:15:55:Ensemble heaume et plastron de l’aube
227388:4:15:55:Ensemble heaume et plastron de poursuivant
227394:4:15:55:Ensemble heaume et plastron du crépuscule
227395:4:15:55:Ensemble heaume et plastron du frisson
227385:4:15:55:Ensemble heaume et plastron du gardien
227387:4:15:55:Ensemble heaume et plastron du soigneur
227397:4:15:55:Ensemble heaume et plastron du soulagement
227399:4:15:55:Ensemble heaume et plastron d’impact
227398:4:15:55:Ensemble heaume et plastron d’éruption
227383:4:15:55:Ensemble heaume et plastron félins
227403:4:15:55:Ensemble heaume et plastron inamovibles
227404:4:15:55:Ensemble heaume et plastron irrésistibles
227390:4:15:55:Ensemble heaume et plastron miséricordieux
227391:4:15:55:Ensemble heaume et plastron radieux
287647:3:0:1:Ensemble : armure ambrée de maître-lame
271744:1:0:1:Ensemble : atours de garde-paix shen’dorei
271731:1:0:1:Ensemble : atours de magistère shen’dorei
271765:1:0:1:Ensemble : atours de zélote al’aketh
271755:1:0:1:Ensemble : atours d’oracle des cieux shen’dorei
244231:1:0:1:Ensemble : costume de pêche eau-plate
279182:1:0:1:Ensemble : tenue d’extérieur d’aventurier vétéran
281301:2:4:49:Entraves sacrificielles
209031:1:15:1:Enveloppe discrète
4433:1:12:25:Enveloppe détrempée
21746:1:0:1:Enveloppe rouge porte-bonheur
209845:1:5:25:Envoûtements et glamours
16457:4:4:74:Epaulettes de grand maréchal en cuir
16423:3:4:63:Epaulettes de lieutenant-commandant en peau de dragon
20176:4:4:65:Epaulettes de Profanateur
16551:4:4:74:Epaulettes de seigneur de guerre en peau de dragon
20061:4:4:65:Epaulettes des Hautes-terres
3765:2:4:40:Epauliers de brigand
16793:2:4:38:Epaulières d'Arcmetal
23252:3:4:71:Epaulières de champion en anneaux
23258:3:4:71:Epaulières de champion en cuir
16524:3:4:63:Epaulières de champion en mailles
23254:3:4:71:Epaulières de champion en peau de dragon
23243:3:4:71:Epaulières de champion en plaques
17573:3:4:63:Epaulières de champion en tisse-effroi
11502:2:4:46:Epaulières de connaissance en cuir
17580:4:4:74:Epaulières de grand maréchal en tisse-effroi
23307:3:4:71:Epaulières de lieutenant-commandant en anneaux
23313:3:4:71:Epaulières de lieutenant-commandant en cuir
23309:3:4:71:Epaulières de lieutenant-commandant en peau de dragon
23315:3:4:71:Epaulières de lieutenant-commandant en plaques
20194:4:4:65:Epaulières de Profanateur en cuir
20175:4:4:65:Epaulières de Profanateur en cuir de lézard
16568:4:4:74:Epaulières de seigneur de guerre en anneaux
16544:4:4:74:Epaulières de seigneur de guerre en plaques
20059:4:4:65:Epaulières des Hautes-terres en cuir
20060:4:4:65:Epaulières des Hautes-terres en cuir de lézard
15457:2:4:28:Epaulières du désert
6189:2:4:24:Epaulières en mailles solides
10745:2:4:50:Epaulières Kaylari
16436:3:4:63:Epaulières lamellaires de lieutenant-commandant
23277:3:4:71:Epaulières lamellaires de lieutenant-commandant
5102:1:12:10:Epine caudale d'Owatanka
15335:2:2:14:Epée courte de Briarsteel
16891:2:2:21:Epée courte de Claystone
3572:2:2:17:Epée courte de Daryl
1161:1:2:5:Epée courte de la milice
3455:1:2:11:Epée courte de Traqueur noir
3267:1:2:5:Epée courte des Réprouvés
15800:2:2:58:Epée courte intrépide
15801:2:2:58:Epée courte vaillante
6967:2:2:15:Epée d'Elunite
6984:2:2:15:Epée d'Umbral
6741:1:2:29:Epée de guerre orque
6985:2:2:15:Epée de Haggard
7118:2:2:15:Epée de l'héritier
19550:3:2:63:Epée de légionnaire
19551:3:2:53:Epée de légionnaire
19552:3:2:43:Epée de légionnaire
19553:3:2:33:Epée de légionnaire
20430:3:2:23:Epée de légionnaire
19554:3:2:63:Epée de protecteur
19555:3:2:53:Epée de protecteur
19556:3:2:43:Epée de protecteur
19557:3:2:33:Epée de protecteur
20440:3:2:23:Epée de protecteur
281308:2:2:42:Epée de rechange de Jameson
1008:1:2:10:Epée de taille
7329:2:2:15:Epée de Thun'grim
6977:3:2:40:Epée de tourbillon
4977:2:2:41:Epée de Trépas-d'Orgrim
5615:2:2:20:Epée du bûcheron
4987:2:2:45:Epée du capitaine nain
10696:2:2:60:Epée Felbane en azsharite enchanté
12584:4:2:78:Epée longue de connétable
21521:4:2:76:Epée runique du Rouge
15705:2:2:57:Epée Tidecrest
21376:4:4:78:Espauliers d'implorateur de tempête
16528:3:4:63:Espauliers de champion en anneaux
23260:3:4:71:Espauliers de champion en mailles
16516:3:4:63:Espauliers de champion en plaques
276720:2:4:22:Espauliers de criminalité
22419:4:4:86:Espauliers de cuirassier
271743:1:4:1:Espauliers de garde-paix shen’dorei
227947:3:4:56:Espauliers de golem ajustés
250578:3:4:47:Espauliers de grand gardien
250580:3:4:47:Espauliers de justicier
277236:3:4:45:Espauliers de justification
21639:4:4:77:Espauliers de l'Implacable
22479:4:4:86:Espauliers de la faucheuse d'os
16427:3:4:63:Espauliers de lieutenant-commandant en anneaux
16432:3:4:63:Espauliers de lieutenant-commandant en plaques
275737:3:4:61:Espauliers de l’ermite
271730:1:4:1:Espauliers de magistère shen’dorei
6747:2:4:40:Espauliers de massacreur
20158:4:4:65:Espauliers de Profanateur en anneaux
20203:4:4:65:Espauliers de Profanateur en mailles
250579:3:4:47:Espauliers de préfet
274241:4:4:65:Espauliers de qualité de général en écailles
274255:4:4:65:Espauliers de qualité de général lamellaires
272785:4:4:65:Espauliers de qualité de maréchal de chevalerie
273334:4:4:65:Espauliers de qualité de maréchal lumineux
272648:3:4:60:Espauliers de qualité en mailles
272736:3:4:60:Espauliers de qualité en mailles
273360:3:4:60:Espauliers de qualité en mailles annelées
274222:3:4:60:Espauliers de qualité en mailles rivetées
272741:3:4:60:Espauliers de qualité en plaques
274197:3:4:60:Espauliers de qualité en écailles
250577:3:4:47:Espauliers de sentinelle
271955:4:4:65:Espauliers de Theramore
271764:1:4:1:Espauliers de zélote al’aketh
22101:3:4:65:Espauliers des Cinq tonnerres
20055:4:4:65:Espauliers des Hautes-terres en anneaux
20056:4:4:65:Espauliers des Hautes-terres en mailles
21367:4:4:81:Espauliers du Frappeur
21391:4:4:78:Espauliers du Vengeur
22354:4:15:60:Espauliers désacralisés
250576:3:4:47:Espauliers d’officier
271754:1:4:1:Espauliers d’oracle des cieux shen’dorei
4123:2:4:37:Espauliers en métal glacial
277228:2:4:45:Espauliers en écailles de serpent
11889:2:4:50:Espauliers en écorce de fer
16476:4:4:74:Espauliers lamellaires de grand maréchal
22940:4:4:83:Espauliers plaie-de-glace
6792:2:4:40:Espauliers sanguins
4443:2:4:36:Espauliers sinistres
272105:4:4:65:Espauliers sombrelances
281276:2:4:50:Espauliers tueurs d’écailles
275296:2:2:58:Espingole mort-bois
276332:2:2:57:Espoir d’Abigail
281258:2:4:33:Espoir d’Essène
276783:1:12:1:Esprit de vindicte
20079:2:0:65:Esprit de Zanza
23795:2:0:65:Esprit de Zanza permanent
9686:2:2:51:Esprit du dragon féérique
11751:1:12:1:Essence ardente
9258:1:12:1:Essence Byltan
230908:4:12:71:Essence de feu imprégnée
230909:4:12:71:Essence de feu épuisée
230948:4:12:71:Essence de givre imprégnée
230949:4:12:71:Essence de givre épuisée
18815:4:4:75:Essence de la Flamme pure
191656:4:0:1:Essence de la mort
217719:1:15:1:Essence de magie du sang
209841:1:15:25:Essence de magie sauvage
9256:1:12:1:Essence Imbel
9255:1:12:1:Essence Lahassa
9257:1:12:1:Essence Samha
287648:3:2:1:Estramaçon ambré de maître-lame
269717:2:2:18:Estramaçon de Fauvétripe
272179:2:2:43:Estramaçon des passés glorieux
263407:2:2:15:Estramaçon empyréen
277104:1:2:14:Estramaçon zéphrali
19718:4:12:1:Etançon primordial hakkari
18606:1:0:1:Etendard de bataille de l'Alliance
18607:1:0:1:Etendard de bataille de la Horde
19045:3:0:1:Etendard de bataille foudrepique
19046:3:0:1:Etendard de bataille loup-de-givre
3463:2:2:35:Etoile d'argent
21322:2:4:58:Etreinte d'ursa
22707:4:4:80:Etreinte de glace de Ramaladni
13509:2:0:60:Etreinte de prévoyance
19786:3:15:60:Etreinte vigilante du vaudouisan
13154:1:0:1:Etudes des arcanes de Jael'marin
5279:2:2:20:Eventreur de harpies
17046:2:2:31:Eventreuse
3755:2:2:32:Eviscératrice
211487:2:0:1:Explosifs de démolition
5695:1:12:1:Explosifs NG-5 (Bleus)
5694:1:12:1:Explosifs NG-5 (Rouges)
219773:1:15:1:Exposé de mission : Ashenvale
219526:1:15:1:Exposé de mission : bois de la Pénombre
219775:1:15:1:Exposé de mission : Feralas
219774:1:15:1:Exposé de mission : Hinterlands
9647:2:4:48:Expérience de vol ratée
260348:1:15:1:Extrait de journal à peine lisible, page I
260349:1:15:1:Extrait de journal à peine lisible, page II
260350:1:15:1:Extrait de journal à peine lisible, page III
260351:1:15:1:Extrait de journal à peine lisible, page IV
260357:1:15:1:Extrait de journal à peine lisible, page IX
260352:1:15:1:Extrait de journal à peine lisible, page V
260353:1:15:1:Extrait de journal à peine lisible, page VI
260354:1:15:1:Extrait de journal à peine lisible, page VII
260356:1:15:1:Extrait de journal à peine lisible, page VIII
260358:1:15:1:Extrait de journal à peine lisible, page X
281042:1:15:1:Fagot de brindilles de cèdre séchées
20409:1:0:1:Fantôme
209042:1:15:1:Farine d’os de poisson
4128:2:2:41:Fatale
276695:2:2:15:Faucheteigne de moissonneur
21392:4:2:70:Faucille de force inflexible
19727:3:7:60:Faucille de sang
231796:4:12:71:Faux du Chaos épuisée (dévoreur)
231795:4:12:71:Faux du Chaos épuisée (ensorcellement)
231793:4:12:71:Faux du Chaos épuisée (malice)
231794:4:12:71:Faux du Chaos épuisée (Vide)
21401:4:2:70:Faux du sentier invisible
219404:1:12:25:Faux d’ombre
262902:1:15:1:Faux reçu de livraison
6970:2:4:20:Faveur de Furen
19022:2:2:50:FC-5000 de Nat Pagle, pêcheur de l'extrême
3586:2:2:16:Fendeuse
18828:4:2:78:Fendoir de grand seigneur de guerre
4126:2:2:34:Fendoir de la guérilla
272592:4:2:65:Fendoir de qualité de grand seigneur de guerre
281721:2:2:1:Fendoir restauré
213373:2:7:40:Ferraille réfléchissante
23714:1:4:20:Feu d'artifice violet perpétuel
20414:1:0:1:Feu follet
221972:2:15:40:Feu pyronirique
18703:4:12:71:Feuille ancienne pétrifiée
18714:4:11:75:Feuille d'Ancien cousue de tendons
281313:3:2:32:Fidèle épée
5332:1:15:1:Figurine de chat luminescente
281043:1:15:1:Fil de tendons
12734:1:12:1:Fil écarlate enchanté
20084:3:15:52:Filet de chasse
213554:1:12:1:Fiole d’eau cristalline
10687:1:0:1:Fiole vide marquée N°1
10688:1:0:1:Fiole vide marquée N°2
10689:1:0:1:Fiole vide marquée N°3
10690:1:0:1:Fiole vide marquée N°4
23176:1:0:1:Fizzy Energy Drink
280544:4:15:60:Fièregriffe céruléen
12771:1:12:52:Flacon d'eau de feu vide
744:2:4:44:Flacon de botte de Thunderbrew
19115:2:4:51:Flacon de mojo sylvestre
281294:2:4:25:Flacon d’apothicaire utilisé
227924:1:15:60:Flacon insolite
18630:1:12:1:Flambeau du Jugement dernier
5813:2:2:32:Flamme d'Emil
23179:1:12:1:Flamme d'Orgrimmar
23184:1:12:1:Flamme de Darnassus
23183:1:12:1:Flamme de Forgefer
23181:1:12:1:Flamme de Fossoyeuse
23182:1:12:1:Flamme de Hurlevent
23180:1:12:1:Flamme de Thunder Bluff
6766:1:12:25:Flayed Demon Skin (old2)
19316:2:6:54:Flèche de glace
22200:1:15:1:Flèche en argent
274387:4:6:65:Flèche plumevive
7297:1:4:33:Fléau de Morbent
11668:1:12:54:Flûte de Xavaric
22238:1:0:1:Fondant aux myrtilles
9684:2:2:51:Force de l'hippogryphe
19574:2:4:60:Force de Mugamba
19575:3:4:60:Force de Mugamba
19576:3:4:68:Force de Mugamba
9683:2:2:50:Force du tréant
249511:2:9:42:Formula: Enchant 2H Weapon - Lesser Agility
249513:2:9:44:Formula: Enchant 2H Weapon - Lesser Strength
249526:2:9:60:Formula: Enchant 2H Weapon - Mighty Healing Power
249525:2:9:60:Formula: Enchant 2H Weapon - Mighty Spell Power
274394:3:9:1:Formula: Enchant 2H Weapon - Spellblasting
249523:2:9:58:Formula: Enchant 2H Weapon - Strength
19442:1:9:58:Formule : Anti-venin puissant
16243:1:9:58:Formule : Bâtonnet runique en arcanite
22392:1:9:58:Formule : Enchantd'arme 2M - Agilité
19445:1:9:58:Formule : Enchantement d'arme (Agilité)
19448:1:9:66:Formule : Enchantement d'arme (Esprit renforcé)
19444:1:9:58:Formule : Enchantement d'arme (Force)
19449:1:9:70:Formule : Enchantement d'arme (Intelligence renforcée)
18260:3:9:60:Formule : Enchantement d'arme (Pouvoir de guérison)
18259:3:9:60:Formule : Enchantement d'arme (Puissance de sort)
16217:1:9:53:Formule : Enchantement de bouclier (Endurance supérieure)
11163:2:9:34:Formule : Enchantement de bracelets (Déviation inférieure)
19446:1:9:58:Formule : Enchantement de bracelets (Régénération de mana)
19447:1:9:64:Formule : Enchantement de bracelets (Soin)
11039:2:9:22:Formule : Enchantement de cape (Agilité mineure)
20734:3:9:70:Formule : Enchantement de cape (Camouflage)
20735:3:9:70:Formule : Enchantement de cape (Discrétion)
20736:3:9:70:Formule : Enchantement de cape (Esquive)
20732:1:9:70:Formule : Enchantement de cape (Résistance au feu supérieure)
20733:1:9:70:Formule : Enchantement de cape (Résistance à la nature supérieure)
20726:3:9:70:Formule : Enchantement de gants (Menace)
20730:3:9:70:Formule : Enchantement de gants (Pouvoir de guérison)
20727:3:9:70:Formule : Enchantement de gants (Puissance de l'ombre)
20729:3:9:70:Formule : Enchantement de gants (Puissance du feu)
20728:3:9:70:Formule : Enchantement de gants (Puissance du givre)
20731:3:9:70:Formule : Enchantement de gants - Agilité excellente
20757:1:9:60:Formule : Huile de mana brillante
20756:1:9:60:Formule : Huile de sorcier brillante
249537:3:9:60:Formule : baguette brillante
249512:2:9:43:Formule : baguette du bosquet du Rêve
249487:2:9:37:Formule : baguette du Néant distordue
249515:2:9:49:Formule : baguette éternelle inférieure
249522:2:9:55:Formule : baguette éternelle supérieure
249483:3:9:28:Formule : bâton des âmes
249507:3:9:44:Formule : bâton onirique
249506:3:9:44:Formule : bâton radieux
249482:3:9:28:Formule : bâton scintillant
249476:3:9:26:Formule : champignon mystique
249508:3:9:44:Formule : conduit en vrai-argent
249520:3:9:53:Formule : cœur brûlant de la montagne
249521:3:9:53:Formule : cœur dormant de la montagne
249519:3:9:53:Formule : cœur gelé de la montagne
249477:3:9:26:Formule : doctrines de la Main d’argent
232610:1:9:60:Formule : encaustique troll magnifique
274400:3:9:1:Formule : enchantement de bouclier (Coup critique)
274395:3:9:1:Formule : enchantement de bouclier (Endurance excellente)
228982:3:9:60:Formule : Enchantement de bouclier (Loi de la nature)
249524:2:9:59:Formule : enchantement de brassards (Agilité excellente)
249486:2:9:1:Formule : enchantement de brassards (Agilité inférieure)
249514:2:9:48:Formule : enchantement de brassards (Agilité supérieure)
249488:2:9:38:Formule : enchantement de brassards (Agilité)
249539:2:9:60:Formule : enchantement de brassards (Déviation excellente)
249538:2:9:60:Formule : enchantement de brassards (Intelligence excellente)
249474:2:9:14:Formule : enchantement de brassards (Intelligence mineure)
249489:2:9:1:Formule : enchantement de brassards (Pouvoir de guérison inférieur)
249475:2:9:18:Formule : enchantement de brassards (Pouvoir de guérison mineur)
274401:3:9:1:Formule : enchantement de brassards (Puissance des sorts supérieure)
274399:3:9:1:Formule : enchantement de cape (Agilité)
229008:1:9:70:Formule : Enchantement de cape (Résistance au Feu supérieure)
229009:1:9:70:Formule : Enchantement de cape (Résistance à la Nature supérieure)
249504:2:9:42:Formule : enchantement de collier (Agilité)
249505:2:9:42:Formule : enchantement de collier (Déviation)
249496:2:9:42:Formule : enchantement de collier (Force)
249503:2:9:42:Formule : enchantement de collier (Pouvoir de guérison)
249502:2:9:42:Formule : enchantement de collier (Puissance des sorts)
249516:2:9:50:Formule : enchantement de gants (Dépeçage avancé)
274398:3:9:1:Formule : enchantement de gants (Force excellente)
274424:2:9:55:Formule : enchantement de gants (Griffe du lotus)
249534:2:9:60:Formule : enchantement de gants (Puissance arcanique)
249535:2:9:60:Formule : enchantement de gants (Puissance naturelle)
249536:2:9:60:Formule : enchantement de gants (Puissance sacrée)
249510:2:9:44:Formule : enchantement de plastron (Absorption)
215138:4:9:46:Formule : Enchantement de plastron (Électrocution vengeresse)
249479:2:9:28:Formule : enchantement d’arme (Clairvoyance)
215129:4:9:45:Formule : Enchantement d’arme (Démantèlement)
241191:3:9:80:Formule : enchantement d’arme (Grand croisé)
241201:3:9:80:Formule : enchantement d’arme (Grand sorcier)
249480:2:9:28:Formule : enchantement d’arme (Récupération)
249481:2:9:28:Formule : enchantement d’arme (Révélation)
241195:3:9:80:Formule : enchantement d’arme à deux mains (Grand arcaniste)
242361:3:9:80:Formule : enchantement d’arme à deux mains (Grand Inquisiteur)
274392:3:9:1:Formule : Enchantement d’objet en main gauche (Esprit remarquable)
274391:3:9:1:Formule : Enchantement d’objet en main gauche (Intelligence excellente)
274393:3:9:1:Formule : Enchantement d’objet en main gauche (Sagesse)
249478:3:9:26:Formule : icône en bois flotté poli
279299:4:9:1:Formule : idole de rapidité
279300:4:9:1:Formule : idole des ours jumeaux
249529:3:9:60:Formule : idole du Rêve
249509:3:9:44:Formule : jarre d’essence distordue
249530:3:9:60:Formule : libram de la sainte rapidité
279297:4:9:1:Formule : libram d’imprégnation
249494:3:9:42:Formule : libram d’invocation
279296:4:9:1:Formule : libram inébranlable
249484:3:9:28:Formule : orbe de clairvoyance mystique
249485:3:9:28:Formule : orbe des âmes
228981:1:9:55:Formule : Revêtement de bouclier conducteur
249493:3:9:42:Formule : serres du courroux
279295:4:9:1:Formule : torche de lumière
249495:3:9:42:Formule : totem de protection ancestrale
249532:3:9:60:Formule : totem de tonnerre
279298:4:9:1:Formule : totem d’urgence
15862:2:2:54:Foudroyante
21505:4:4:70:Foulard des Sables changeants
12458:1:12:60:Fourberie de Juju
21509:1:15:10:Fournitures de l'effort de guerre d'Ahn'Qiraj
21510:1:15:20:Fournitures de l'effort de guerre d'Ahn'Qiraj
21511:1:15:30:Fournitures de l'effort de guerre d'Ahn'Qiraj
21512:1:15:40:Fournitures de l'effort de guerre d'Ahn'Qiraj
21513:1:15:50:Fournitures de l'effort de guerre d'Ahn'Qiraj
6172:1:12:30:Fournitures perdues
211321:2:7:10:Fournitures égarées : baguettes magiques inférieures
211838:2:7:25:Fournitures égarées : bandages épais en laine
211332:2:7:10:Fournitures égarées : bandages épais en lin
215419:2:7:35:Fournitures égarées : bandages épais en soie
220921:2:7:45:Fournitures égarées : bandages épais en tisse-mage
220940:2:7:45:Fournitures égarées : bandeaux noirs en tisse-mage
211819:2:7:25:Fournitures égarées : barres de bronze
210771:2:7:10:Fournitures égarées : barres de cuivre
215386:2:7:35:Fournitures égarées : barres de mithril
220925:2:7:45:Fournitures égarées : barres de thorium
220928:2:7:45:Fournitures égarées : barres de thorium enchanté
220924:2:7:45:Fournitures égarées : barres de vrai-argent
211820:2:7:25:Fournitures égarées : barres d’argent
215385:2:7:35:Fournitures égarées : barres d’or
215417:2:7:35:Fournitures égarées : bisque de tortue apaisante
220931:2:7:45:Fournitures égarées : bombes explosives
211323:2:7:10:Fournitures égarées : bombes grossières en cuivre
211825:2:7:25:Fournitures égarées : bottes grossières en bronze
215405:2:7:40:Fournitures égarées : bottes-fusées gnomes
220938:2:7:45:Fournitures égarées : brassards corrompus en cuir
215398:2:7:30:Fournitures égarées : brassards en fer émeraude
215409:2:7:40:Fournitures égarées : brassards en écailles de tortue
220939:2:7:45:Fournitures égarées : brassards runiques en cuir
211827:2:7:25:Fournitures égarées : bâtonnets runiques en argent
220934:2:7:45:Fournitures égarées : camails en mithril
211834:2:7:25:Fournitures égarées : capes brodées de perles
215411:2:7:30:Fournitures égarées : capes de givre en cuir
211831:2:7:25:Fournitures égarées : capes noires en cuir
220933:2:7:45:Fournitures égarées : carabines en thorium
211325:2:7:10:Fournitures égarées : ceintures cousues main en cuir
220935:2:7:45:Fournitures égarées : ceintures en thorium
220941:2:7:45:Fournitures égarées : ceintures en étoffe runique
215410:2:7:35:Fournitures égarées : ceintures mates
211823:2:7:25:Fournitures égarées : chardonniers
215413:2:7:30:Fournitures égarées : chemises blanches habillées
220942:2:7:45:Fournitures égarées : chemises de smoking
211833:2:7:25:Fournitures égarées : chemises grises en laine
211821:2:7:25:Fournitures égarées : cuir moyen
215388:2:7:35:Fournitures égarées : cuir épais
211315:2:7:10:Fournitures égarées : cuirs légers
220926:2:7:45:Fournitures égarées : cuirs robustes
215414:2:7:35:Fournitures égarées : culottes cramoisies en soie
211822:2:7:25:Fournitures égarées : doulourantes
211324:2:7:10:Fournitures égarées : espingoles grossières
211317:2:7:10:Fournitures égarées : feuillargents
220923:2:7:45:Fournitures égarées : feuillerêves
220936:2:7:45:Fournitures égarées : gantelets en vrai-argent
215399:2:7:35:Fournitures égarées : gantelets lourds en mithril
215408:2:7:30:Fournitures égarées : gants du gardien
215412:2:7:35:Fournitures égarées : gants en peau d’ombre
211326:2:7:10:Fournitures égarées : gilets en cuir estampé
211331:2:7:10:Fournitures égarées : goujons brillants
215402:2:7:30:Fournitures égarées : grandes bombes en fer
220932:2:7:45:Fournitures égarées : grenades en thorium
215397:2:7:40:Fournitures égarées : haches massives en fer
215391:2:7:30:Fournitures égarées : hivernale
215421:2:7:30:Fournitures égarées : huile de feu
211828:2:7:25:Fournitures égarées : huile de mana mineure
211322:2:7:10:Fournitures égarées : huiles de sorcier mineures
215401:2:7:35:Fournitures égarées : kits de moissonneur compact
211830:2:7:25:Fournitures égarées : longues-vues ornées
215392:2:7:35:Fournitures égarées : lotus pourpre
215403:2:7:30:Fournitures égarées : lunettes mortelles
215416:2:7:40:Fournitures égarées : masques blancs de bandit
215406:2:7:40:Fournitures égarées : mortiers gobelins
215420:2:7:30:Fournitures égarées : morue rochécaille
215390:2:7:35:Fournitures égarées : moustache de Khadgar
211316:2:7:10:Fournitures égarées : pacifiques
211837:2:7:25:Fournitures égarées : palourdes gobelines
211327:2:7:10:Fournitures égarées : pantalons marron en lin
211320:2:7:10:Fournitures égarées : pantalons runiques en cuivre
211826:2:7:25:Fournitures égarées : passe-partout en argent
215387:2:7:30:Fournitures égarées : peau lourde
220927:2:7:45:Fournitures égarées : peau épaisse
211829:2:7:25:Fournitures égarées : petites bombes en bronze
211933:2:7:10:Fournitures égarées : pierre brute
215394:2:7:40:Fournitures égarées : potions de bouclier de pierre inférieures
220929:2:7:45:Fournitures égarées : potions de mana excellentes
211824:2:7:25:Fournitures égarées : potions de mana inférieures
211934:2:7:10:Fournitures égarées : potions de soin
220930:2:7:45:Fournitures égarées : potions de soins majeures
211318:2:7:10:Fournitures égarées : potions de soins mineures
215393:2:7:35:Fournitures égarées : potions de soins supérieures
215389:2:7:30:Fournitures égarées : pâlerette
220937:2:7:45:Fournitures égarées : renforts d’armure robustes
215415:2:7:35:Fournitures égarées : riches chemises violettes en soie
211328:2:7:10:Fournitures égarées : robes marron en lin
211835:2:7:25:Fournitures égarées : sagerelles fumées
215418:2:7:35:Fournitures égarées : saucisses d’araignée
215400:2:7:30:Fournitures égarées : silex à aiguiser solides
220922:2:7:45:Fournitures égarées : soleillettes
220919:2:7:45:Fournitures égarées : soupes de lutjan nagenuit
220918:2:7:45:Fournitures égarées : soupes de palourdes de Terremine
220920:2:7:45:Fournitures égarées : steaks de loup tendres
215404:2:7:40:Fournitures égarées : tromblons en mithril
211836:2:7:25:Fournitures égarées : viande d’ours fumée
211330:2:7:10:Fournitures égarées : viandes de loup épicées
211935:2:7:25:Fournitures égarées : élixir de maîtrise du feu
215396:2:7:40:Fournitures égarées : élixirs de défense supérieure
215395:2:7:35:Fournitures égarées : élixirs d’agilité
215407:2:7:35:Fournitures égarées : épaulières barbares
211832:2:7:25:Fournitures égarées : épaulières d’homme des collines
211319:2:7:10:Fournitures égarées : épées courtes en cuivre
211329:2:7:10:Fournitures égarées : œufs aux herbes
205364:1:15:1:Fourre-tout d’acolyte
208223:1:15:1:Fourre-tout d’acolyte
271719:3:4:33:Fourrures du Cercle terrestre
11906:2:2:55:Fracasse-bêtes
281724:2:2:1:Fracasseur restauré
277106:1:2:14:Fracasseur zéphrali
22726:5:15:60:Fragment d'Atiesh
6265:1:15:10:Fragment d'âme
11515:1:12:1:Fragment d'âme corrompue
17409:2:12:54:Fragment de cristal incrusté
4743:2:4:50:Fragment de cristal palpitant
221353:1:12:1:Fragment de feu
221356:1:12:1:Fragment de feu luminescent
18501:1:12:1:Fragment de gangrevigne
21891:4:4:75:Fragment de l'étoile tombée
239012:5:7:60:Fragment de lumière cristallisée
227549:1:15:1:Fragment de parchemin
235867:1:15:1:Fragment de parchemin
281350:2:13:1:Fragment de pierre-clé
284092:3:15:1:Fragment de pierre-clé
284093:4:15:1:Fragment de pierre-clé
19942:2:12:1:Fragment de rêve d'Hazza'rah
221355:1:12:1:Fragment de terre
221358:1:12:1:Fragment de terre luminescent
220375:1:12:1:Fragment d’air
220525:1:12:1:Fragment d’air luminescent
221354:1:12:1:Fragment d’eau
221357:1:12:1:Fragment d’eau luminescent
205019:1:15:10:Fragment d’âme impure
225929:1:15:1:Fragment d’âme pestiférée
205020:1:15:10:Fragment d’âme pure
215443:1:12:40:Fragments d’orbe fracassé
5614:2:2:31:Frappe du Séraphin
274944:2:2:40:Frappeuse de flaire-sang
284664:2:15:30:Friandise pour mule de bât
19103:3:2:65:Frimaire
12457:1:12:60:Frisson de Juju
19994:1:0:55:Fruit de la moisson
13810:1:0:55:Fruit solaire béni
12459:1:12:60:Fuite de Juju
21809:3:4:71:Fureur de l'essaim oublié
209851:1:5:25:Fureur de la terre
13474:2:2:56:Fusil du fermier Dalson
10727:1:4:48:Fusil-dragon des gobelins
274024:3:4:1:Fédora flamboyant de Klaqueboulon
3360:1:4:30:Fémur de Balafré
21622:4:2:78:Fémur de silithide aiguisé
271801:3:2:42:Férocité abandonnée
21488:3:4:73:Fétiche d'épines chitineuses
21647:4:4:77:Fétiche du ravageur des sables
226526:1:12:1:Gadget cassé
21815:1:0:1:Gage d'amour
219927:2:12:50:Gage d’émeraude
253017:1:12:60:Gangrenelle corrompue
11514:1:12:1:Gangrimpante
234819:4:4:71:Gantelet démoniaque
235044:4:4:71:Gantelet démoniaque couvert de bave
15823:2:4:55:Gantelets brique-d'acier
263337:2:4:13:Gantelets briseurs
16978:3:4:27:Gantelets chanteguerres
277231:2:4:45:Gantelets conducteurs
5589:1:4:10:Gantelets couverts de mousse
6063:1:4:8:Gantelets d'acier glacé
21581:4:4:88:Gantelets d'annihilation
21998:4:4:55:Gantelets d'héroïsme
22090:4:4:55:Gantelets d'Âmeforge
7129:2:4:31:Gantelets de brutalité
16496:3:4:63:Gantelets de champion en peau de dragon
16403:3:4:63:Gantelets de chevalier-lieutenant en anneaux
16396:3:4:63:Gantelets de chevalier-lieutenant en cuir
16406:3:4:63:Gantelets de chevalier-lieutenant en plaques
23286:3:4:66:Gantelets de chevalier-lieutenant en plaques
272095:4:4:65:Gantelets de chevaucheur
272096:4:4:55:Gantelets de chevaucheur
22421:4:4:88:Gantelets de cuirassier
21674:4:4:76:Gantelets de détermination inébranlable
252548:3:4:55:Gantelets de furtivité en cuir
16530:3:4:63:Gantelets de garde de sang en anneaux
22868:3:4:66:Gantelets de garde de sang en plaques
252549:3:4:55:Gantelets de garde en cuir
250568:3:4:40:Gantelets de grand gardien
16574:4:4:71:Gantelets de général en mailles
16548:4:4:71:Gantelets de général en plaques
1360:1:4:10:Gantelets de Hurlevent en mailles
250570:3:4:40:Gantelets de justicier
21624:4:4:78:Gantelets de Kalimdor
15795:2:4:58:Gantelets de la brume émeraude
22481:4:4:88:Gantelets de la faucheuse d'os
20712:3:4:63:Gantelets de la marche aride
270034:2:4:27:Gantelets de l’ombre
252550:3:4:55:Gantelets de mande-ciel en cuir
252585:3:4:55:Gantelets de mande-ciel en mailles
16448:4:4:71:Gantelets de maréchal en peau de dragon
16484:4:4:71:Gantelets de maréchal en plaques
19126:2:4:49:Gantelets de plaques mâchefer
250569:3:4:40:Gantelets de préfet
273337:4:4:65:Gantelets de qualité de champion en mailles
273345:4:4:65:Gantelets de qualité de champion en mailles annelées
272513:4:4:65:Gantelets de qualité de champion en plaques cimentières
272539:4:4:65:Gantelets de qualité de champion rivetés
272719:3:4:60:Gantelets de qualité de chevalerie
274184:4:4:65:Gantelets de qualité de lieutenant-commandant en mailles plates
274207:4:4:65:Gantelets de qualité de lieutenant-commandant en mailles rivetées
272757:4:4:65:Gantelets de qualité de lieutenant-commandant en peau de bête
273399:4:4:65:Gantelets de qualité de lieutenant-commandant en peau du Rêve
273391:4:4:65:Gantelets de qualité de lieutenant-commandant en peau lunaire
272793:4:4:65:Gantelets de qualité de lieutenant-commandant en plaques
274199:4:4:65:Gantelets de qualité de lieutenant-commandant en écailles
272495:3:4:60:Gantelets de qualité en anneaux
272708:3:4:60:Gantelets de qualité en cuir
272464:3:4:60:Gantelets de qualité en cuir de kodo
272715:3:4:60:Gantelets de qualité en mailles
273382:3:4:60:Gantelets de qualité en peau de wyrm
272717:3:4:60:Gantelets de qualité en plaques
274227:3:4:60:Gantelets de qualité en écailles
274256:3:4:60:Gantelets de qualité lamellaires
273363:3:4:60:Gantelets de qualité lumineux
252547:3:4:55:Gantelets de rôdeur en cuir
250567:3:4:40:Gantelets de sentinelle
252551:3:4:55:Gantelets de soigneur en cuir
252587:3:4:55:Gantelets de soigneur en mailles
271940:4:4:65:Gantelets de Theramore
271941:4:4:55:Gantelets de Theramore
20713:3:4:63:Gantelets de traqueur du désert
252584:3:4:55:Gantelets de traqueur en mailles
23078:3:4:63:Gantelets de tueur de mort-vivant
3559:2:4:21:Gantelets de veilleur
22099:4:4:55:Gantelets des cinq tonnerres
21623:4:4:78:Gantelets du champion vertueux
15402:2:4:14:Gantelets du collet
5822:2:4:24:Gantelets du hallier
21585:4:4:88:Gantelets du sombre orage
20650:2:4:60:Gantelets du vent du désert
22357:4:15:60:Gantelets désacralisés
263426:1:4:10:Gantelets d’ancien commandant
252586:3:4:55:Gantelets d’escarmouche en mailles
250566:3:4:40:Gantelets d’officier
6974:2:4:31:Gantelets en acier trempé
12051:2:4:54:Gantelets en laiton
3458:2:4:18:Gantelets en mailles robustes
213391:4:4:45:Gantelets en mithril électrifiés INUTILISÉS
12812:3:12:60:Gantelets en plaques inachevés
11867:2:4:53:Gantelets exaspérants
6794:2:4:40:Gantelets flamme-tempête
23274:3:4:66:Gantelets lamellaires de chevalier-capitaine
16410:3:4:63:Gantelets lamellaires de chevalier-lieutenant
270038:2:4:30:Gantelets runiques
276723:2:4:18:Gantelets sages
277082:1:4:14:Gantelets zéphrali
5312:2:4:21:Gantelets à rivets
254095:3:4:55:Gants ambrés
287625:3:4:1:Gants ambrés de maître-lame
9632:2:4:45:Gants artisanaux de Jangdor
9631:2:4:45:Gants artisanaux de Pratt
253923:3:4:20:Gants brillants
22110:4:4:55:Gants Cœur-Farouche
5394:1:4:5:Gants d'entraînement d'archer
1303:2:4:20:Gants d'ouvrier du pont
15405:2:4:17:Gants d'écailleur
719:1:4:5:Gants d'éleveur de lapins
6171:1:4:5:Gants d'éleveur de loups
2547:1:4:5:Gants d'éleveur de sangliers
1304:2:4:20:Gants d'équitation
252494:3:4:20:Gants de bagarreur en cuir
22015:4:4:55:Gants de belluaire
3754:2:4:33:Gants de berger
10637:2:4:15:Gants de brasseur
4107:2:4:37:Gants de chasseur de tigres
16397:3:4:63:Gants de chevalier-lieutenant en peau de dragon
17596:3:4:63:Gants de chevalier-lieutenant en satin
16391:3:4:63:Gants de chevalier-lieutenant en soie
17564:3:4:63:Gants de chevalier-lieutenant en tisse-effroi
252498:3:4:20:Gants de chevaucheur de tempête en cuir
9698:2:4:33:Gants de clairvoyance
21672:4:4:76:Gants de coercition
6727:2:4:41:Gants de course de Razzeric
5939:1:4:8:Gants de couture
250512:3:4:20:Gants de croisé
16994:2:4:60:Gants de Crépuscaile
1302:2:4:18:Gants de dragonnet noir
252496:3:4:20:Gants de défenseur en cuir
22517:4:4:88:Gants de foi
252525:3:4:40:Gants de furtivité en cuir
250509:3:4:20:Gants de garde
16510:3:4:63:Gants de garde de sang en plaques
17617:3:4:63:Gants de garde de sang en satin
16487:3:4:63:Gants de garde de sang en soie
17577:3:4:63:Gants de garde de sang en tisse-effroi
252527:3:4:40:Gants de garde en cuir
271737:1:4:1:Gants de garde-paix shen’dorei
21318:2:4:58:Gants de gardien de la terre
22501:4:4:88:Gants de givrefeu
250553:3:4:55:Gants de grand gardien
11918:2:4:55:Gants de Grotslab
16571:4:4:71:Gants de général en anneaux
16555:4:4:71:Gants de général en peau de dragon
17620:4:4:71:Gants de général en satin
17588:4:4:71:Gants de général en tisse-effroi
5606:1:4:9:Gants de jardinage
250555:3:4:55:Gants de justicier
6744:2:4:33:Gants de Kapelan
21888:4:4:71:Gants de l'immortel
20717:3:4:63:Gants de la fleur du désert
5299:2:4:20:Gants de la lune
263306:2:4:11:Gants de la Noctegriffe
4509:2:4:40:Gants de loup de mer
271726:1:4:1:Gants de magistère shen’dorei
252529:3:4:40:Gants de mande-ciel en cuir
16740:2:4:31:Gants de manipulation du Déchiqueteur
9634:2:4:46:Gants de manipulation habile
17608:4:4:71:Gants de maréchal en satin
16440:4:4:71:Gants de maréchal en soie
17584:4:4:71:Gants de maréchal en tisse-effroi
2036:2:4:18:Gants de mine poussiéreux
2230:2:4:24:Gants de musculation
6732:2:4:38:Gants de mécanicien gnome
10636:1:4:5:Gants de nomade
22509:4:4:88:Gants de pestecoeur
3152:1:4:9:Gants de pilotage
275715:2:4:57:Gants de pilote de fusée
250510:3:4:20:Gants de protecteur
250554:3:4:55:Gants de préfet
21178:3:4:62:Gants de puissance terrestre
23084:3:4:63:Gants de purification des morts-vivants
272536:4:4:65:Gants de qualité de champion en anneaux
273419:4:4:65:Gants de qualité de champion en cuir de kodo
272520:4:4:65:Gants de qualité de champion en peau de dragon
273411:4:4:65:Gants de qualité de champion en peau de wyrm
272572:4:4:65:Gants de qualité de champion en satin
272556:4:4:65:Gants de qualité de champion en tisse-gangrène
274236:4:4:65:Gants de qualité de champion en écailles
274250:4:4:65:Gants de qualité de champion lamellaires
273431:4:4:65:Gants de qualité de champion soyeux
272780:4:4:65:Gants de qualité de lieutenant-commandant de chevalerie
272749:4:4:65:Gants de qualité de lieutenant-commandant en soie
272808:4:4:65:Gants de qualité de lieutenant-commandant en tisse-effroi
272824:4:4:65:Gants de qualité de lieutenant-commandant en étoffe du Vide
273427:4:4:65:Gants de qualité de lieutenant-commandant en étoffe lunaire
273329:4:4:65:Gants de qualité de lieutenant-commandant lumineux
272455:3:4:60:Gants de qualité de magus
272709:3:4:60:Gants de qualité en peau de bête
273377:3:4:60:Gants de qualité en peau du Rêve
273368:3:4:60:Gants de qualité en peau lunaire
272478:3:4:60:Gants de qualité en plaques cimentières
272569:3:4:60:Gants de qualité en satin
272703:3:4:60:Gants de qualité en soie
272796:3:4:60:Gants de qualité en tisse-effroi
272553:3:4:60:Gants de qualité en tisse-gangrène
272812:3:4:60:Gants de qualité en étoffe du Vide
273445:3:4:60:Gants de qualité en étoffe lunaire
5337:2:4:16:Gants de randonnée
11888:2:4:50:Gants de recherche de Quintis
252524:3:4:40:Gants de rôdeur en cuir
252499:3:4:20:Gants de sagesse en cuir
273876:2:4:13:Gants de sectateur brisé
250552:3:4:55:Gants de sentinelle
252530:3:4:40:Gants de soigneur en cuir
16738:2:4:48:Gants de sèchegraine
11192:1:4:5:Gants de tailleur
252495:3:4:20:Gants de trappeur en cuir
252526:3:4:40:Gants de traqueur en cuir
270012:2:4:20:Gants de travail de mineur
281315:2:4:16:Gants de vil-poil
11190:1:4:5:Gants de Viny
12522:2:4:15:Gants de vol de Bingles
9704:2:4:43:Gants de voleur de bétail
277223:2:4:45:Gants de voyage
250508:3:4:20:Gants de vétéran
271760:1:4:1:Gants de zélote al’aketh
253917:3:4:20:Gants des flammes
257328:1:4:8:Gants des hautes-terres
254103:3:4:55:Gants dorés
257264:1:4:5:Gants du bosquet Thendal
9665:2:4:50:Gants du cimier ailé
21319:2:4:58:Gants du guide
21619:4:4:78:Gants du messie
16986:2:4:25:Gants du Pic de sable
21890:4:4:75:Gants du prophète déchu
22066:4:4:55:Gants du sorcier
21605:4:4:81:Gants du temple caché
15463:2:4:25:Gants du trotteur solitaire
5630:2:4:20:Gants du vent mordant
7106:2:4:33:Gants du zodiaque
22371:4:15:60:Gants désacralisés
4914:1:4:5:Gants détériorés en cuir
250511:3:4:20:Gants d’acolyte
270089:2:4:45:Gants d’agent de Forgefer
270072:2:4:40:Gants d’assassin d’Alterac
279178:1:4:1:Gants d’aventurier vétéran
252528:3:4:40:Gants d’escarmouche en cuir
250551:3:4:55:Gants d’officier
271750:1:4:1:Gants d’oracle des cieux shen’dorei
254099:3:4:55:Gants embrasés
257338:1:4:10:Gants en anneaux de Valanaar
4910:1:4:5:Gants en anneaux peints
15708:2:4:58:Gants en cuir chancreux
19119:2:4:50:Gants en cuir de chouettard
281697:2:4:1:Gants en cuir restaurés
16873:2:4:38:Gants en fourrure tressée
10654:2:4:30:Gants en jute tressée
3275:1:4:5:Gants en lin
270004:2:4:14:Gants en peau de Murloc
20716:3:4:63:Gants en peau de ver des sables
15401:2:4:14:Gants goutte-de-puits
253913:3:4:20:Gants immaculés
16471:4:4:71:Gants lamellaires de maréchal
1359:1:4:8:Gants marqués d'un lion
253921:3:4:20:Gants nacrés
254101:3:4:55:Gants noirs
253919:3:4:20:Gants ombreux
4121:2:4:35:Gants ornementés
5629:2:4:20:Gants poing-de-marteau
254105:3:4:55:Gants radieux
4962:1:4:8:Gants rembourrés
22006:4:4:55:Gants Sombremante
253915:3:4:20:Gants soyeux
3565:2:4:20:Gants tachés de bière
12299:1:4:8:Gants toilés
252497:3:4:20:Gants totémiques en cuir
263310:2:4:11:Gants tristechant
7738:2:4:18:Gants vert sapin
22081:4:4:55:Gants vertueux
3759:2:4:33:Gants vitaux des sages
277088:1:4:14:Gants zéphrali
254097:3:4:55:Gants écumeux
280696:3:4:40:Garde d’élémentaliste
274758:2:4:55:Garde givremétal
22635:3:15:60:Garde sauvage
16497:3:4:63:Garde-bras d'adjudant en cuir
18435:3:4:50:Garde-bras d'adjudant en cuir
18434:3:4:63:Garde-bras d'adjudant en cuir de dragon
18436:3:4:50:Garde-bras d'adjudant en cuir de dragon
5315:2:4:18:Garde-bras de bûcheron
19827:4:4:61:Garde-bras de libre-penseur zandalar
270105:2:4:50:Garde-bras de protecteur
272778:4:4:65:Garde-bras de qualité de chevalier-capitaine de chevalerie
273327:4:4:65:Garde-bras de qualité de chevalier-capitaine lumineux
272511:4:4:65:Garde-bras de qualité de légionnaire en plaques cimentières
274234:4:4:65:Garde-bras de qualité de légionnaire en écailles
274248:4:4:65:Garde-bras de qualité de légionnaire lamellaires
272461:3:4:60:Garde-bras de qualité en cuir de kodo
272830:3:4:60:Garde-bras de qualité en mailles
272582:3:4:60:Garde-bras de qualité en peau de dragon
273381:3:4:60:Garde-bras de qualité en peau de wyrm
272465:3:4:60:Garde-bras de qualité en pelombre
19824:4:4:61:Garde-bras de redresseur de torts zandalar
270110:2:4:50:Garde-bras de second
18448:3:4:63:Garde-bras de sergent-major en mailles
18449:3:4:50:Garde-bras de sergent-major en mailles
277093:1:4:14:Garde-bras zéphrali
22636:3:15:60:Garde-glace
287623:3:4:1:Garde-jambes ambrés de maître-lame
252516:3:4:30:Garde-jambes de bagarreur en cuir
263340:2:4:13:Garde-jambes de garde-paix
272532:4:4:65:Garde-jambes de qualité de général en anneaux
272529:4:4:65:Garde-jambes de qualité de général en pelombre
272776:4:4:65:Garde-jambes de qualité de maréchal en mailles
272759:4:4:65:Garde-jambes de qualité de maréchal en peau de bête
273401:4:4:65:Garde-jambes de qualité de maréchal en peau du Rêve
273393:4:4:65:Garde-jambes de qualité de maréchal en peau lunaire
272728:3:4:60:Garde-jambes de qualité en cuir
272636:3:4:60:Garde-jambes de qualité en mailles
273359:3:4:60:Garde-jambes de qualité en mailles annelées
274221:3:4:60:Garde-jambes de qualité en mailles rivetées
272481:3:4:60:Garde-jambes de qualité en plaques cimentières
272657:3:4:60:Garde-jambes de qualité en tisse-effroi
272630:3:4:60:Garde-jambes de qualité en tisse-gangrène
274195:3:4:60:Garde-jambes de qualité en écailles
272663:3:4:60:Garde-jambes de qualité soyeux
252517:3:4:30:Garde-jambes de trappeur en cuir
263423:1:4:7:Garde-jambes des hautes-terres en mailles
270077:2:4:40:Garde-jambes du ressac
279175:1:4:1:Garde-jambes d’aventurier vétéran
281707:2:4:1:Garde-jambes en mailles restaurés
277084:1:4:14:Garde-jambes zéphrali
22469:4:4:88:Garde-mains de Brise-terre
16540:4:4:71:Garde-mains de général en soie
22493:4:4:88:Garde-mains de marcherêve
272505:4:4:65:Garde-mains de qualité de magus champion
22426:4:4:88:Garde-mains de rédemption
22441:4:4:88:Garde-mains de traqueur des cryptes
23082:3:4:63:Garde-mains de tueur de mort-vivant
22364:4:15:60:Garde-mains désacralisés
281713:2:4:1:Garde-mains en plaques restaurés
6784:2:4:36:Garde-mains à fermoir
16532:3:4:63:Garde-poignets d'adjudant en mailles
18432:3:4:50:Garde-poignets d'adjudant en mailles
4973:1:4:10:Garde-poignets de chasseur des plaines
4928:1:4:8:Garde-poignets de coureur des sables
281251:2:4:24:Garde-poignets de coursier
15459:2:4:28:Garde-poignets de dur-labeur
21588:4:4:88:Garde-poignets de fureur élémentaire
250583:3:4:50:Garde-poignets de grand gardien
250585:3:4:50:Garde-poignets de justicier
19582:4:4:65:Garde-poignets de messager du vent
19583:4:4:55:Garde-poignets de messager du vent
19584:4:4:45:Garde-poignets de messager du vent
21618:4:4:78:Garde-poignets de profanateur de ruche
250584:3:4:50:Garde-poignets de préfet
21587:4:4:88:Garde-poignets de punition
272535:4:4:65:Garde-poignets de qualité de légionnaire en anneaux
273353:3:4:60:Garde-poignets de qualité en mailles
273361:3:4:60:Garde-poignets de qualité en mailles annelées
274182:3:4:60:Garde-poignets de qualité en mailles plates
274223:3:4:60:Garde-poignets de qualité en mailles rivetées
272828:3:4:60:Garde-poignets de qualité en plaques
274215:3:4:60:Garde-poignets de qualité en écailles
272497:3:4:60:Garde-poignets de qualité rivetés
250582:3:4:50:Garde-poignets de sentinelle
18445:3:4:63:Garde-poignets de sergent-major en plaques
18447:3:4:50:Garde-poignets de sergent-major en plaques
272581:3:4:50:Garde-poignets d’adjudant en mailles
250581:3:4:50:Garde-poignets d’officier
1306:2:4:20:Garde-poignets en crinière de loup
281704:2:4:1:Garde-poignets en mailles restaurés
281712:2:4:1:Garde-poignets en plaques restaurés
257339:1:4:10:Garde-poignets en soie céleste
16794:2:4:38:Garde-poignets poigne-d'acier
274750:2:4:45:Garde-poignets réfléchissants
275739:3:4:61:Garde-poignets sauvages
277081:1:4:14:Garde-poignets zéphrali
1183:1:4:10:Garde-poignets élastiques
16480:4:4:74:Garde-épaules de grand maréchal en plaques
272789:4:4:65:Garde-épaules de qualité de maréchal en plaques
270044:2:4:35:Garde-épaules de Sombre-Comté
281702:2:4:1:Garde-épaules en mailles restaurés
228130:2:15:60:Gardien altruiste
228131:2:15:60:Gardien altruiste
211940:3:2:64:Gardienne tribale d’Ecks’av
6436:1:12:1:Gemme ardente
277154:1:15:1:Gemme corrompue
12337:2:12:1:Gemme de Bloodaxe
12336:2:12:1:Gemme de Pierre-du-pic
19395:4:4:75:Gemme de récupération
12335:2:12:1:Gemme de Smolderthorn
19339:4:4:76:Gemme de vivacité d'esprit
23057:4:4:92:Gemme des innocents enchaînés
19341:4:4:76:Gemme donneuse de vie
17765:1:12:1:Gemme du cinquième khan
17762:1:12:1:Gemme du deuxième khan
17761:1:12:1:Gemme du premier khan
17764:1:12:1:Gemme du quatrième khan
17763:1:12:1:Gemme du troisième khan
19336:4:4:76:Gemme imprégnée d'arcanes
3574:1:11:15:Giberne de chasse
22113:4:4:60:Gilet Cœur-Farouche
21364:4:4:88:Gilet de dispensateur de mort
271742:1:4:1:Gilet de garde-paix shen’dorei
21311:2:4:48:Gilet de gardien de la terre
3752:2:4:22:Gilet de grunt
21357:4:4:88:Gilet de la genèse
3444:1:4:11:Gilet de laboureur
271729:1:4:1:Gilet de magistère shen’dorei
6059:1:4:5:Gilet de nomade
21183:3:4:66:Gilet de puissance de la terre
271763:1:4:1:Gilet de zélote al’aketh
22102:4:4:60:Gilet des Cinq tonnerres
257878:1:4:10:Gilet des hautes-terres en anneaux
263408:1:4:5:Gilet d’extermination
271753:1:4:1:Gilet d’oracle des cieux shen’dorei
281284:2:4:11:Gilet en hurlepeau
3270:1:4:5:Gilet en lin
281687:2:4:1:Gilet en tissu restauré
281303:2:4:44:Gilet en écailles blanchies
274942:2:4:40:Gilet peau-hirsute
4916:1:4:5:Gilet souple en laine
277098:1:4:14:Gilet zéphrali
229368:3:15:1:Gill’el
18583:6:2:100:Glaive de guerre d'Azzinoth (droit)
18584:6:2:100:Glaive de guerre d'Azzinoth (gauche)
250619:3:2:63:Glaive en légionite
16408:2:12:23:Globe d'eau souillée
16782:2:12:21:Globe d'eau étrange
279275:2:12:1:Globe d’eau trouble
23040:4:4:90:Glyphe de déviation
20525:3:4:52:Glyphe terrestre
20464:1:15:1:Glyphes d'appel
18670:1:12:1:Glyphes de Xoroth
20399:1:0:1:Gnome lépreux
8424:1:0:1:Gomme de gésier
23721:1:0:1:Gomme de gésier permanente
18627:1:12:1:Gong de Dethmoora
6643:2:15:5:Goujon brillant boursouflé
12922:1:0:1:Gourde vide
278002:2:2:11:Gourdin de la vallée
272600:4:2:65:Gourdin de qualité de grand seigneur de guerre
5587:2:2:13:Gourdin de ronceterre
271802:3:2:42:Gourdin des vertus bafouées
4924:1:2:5:Gourdin primitif
277107:1:2:14:Gourdin zéphrali
18297:1:0:60:Graine d'épineux
277910:2:4:40:Graine de fleur mystique
209041:1:15:1:Graines de citrouille magique
246265:2:4:14:Grand bouclier en bois récupéré
7007:1:12:1:Grand butin de Backus
271803:3:2:42:Grand bâton des nécrokhans
281727:2:2:1:Grand bâton restauré
277109:1:2:14:Grand bâton zéphrali
4935:1:4:8:Grand ceinturon en métal
835:1:0:12:Grand filet
20949:1:12:1:Grand livre magique
257345:2:2:13:Grand marteau bien poli
19024:3:4:55:Grand maître de l'arène
276887:2:2:24:Grand méchant cogneur
6176:1:4:5:Grand pavois nain
243299:1:15:1:Grand sac d’or
6754:1:1:15:Grande bourse
1566:2:2:17:Grande lame de la milice du peuple
257273:1:2:5:Grande lame usée
3461:2:4:24:Grande robe de l'adjudicateur
16413:3:4:63:Grande tenue de chevalier-capitaine en soie
272500:4:4:65:Grande tenue de qualité de magus seigneur de guerre
272722:3:4:60:Grande tenue de qualité en soie
16535:4:4:74:Grande tenue de seigneur de guerre en soie
18877:4:2:78:Grande épée de grand seigneur de guerre
272604:4:2:65:Grande épée de qualité de grand seigneur de guerre
285963:1:12:1:Granule de corruption
216645:2:5:1:Granule de ténèbres
281280:2:4:60:Grave-montagnes
10830:1:0:53:Grenade à fragmentation M73
280605:3:2:40:Griffe de porte-marées
16305:2:12:20:Griffe de Serres-tranchantes
276338:2:2:57:Griffe de Shalla’kal
5457:1:0:5:Griffe de Vaudou abîmée
18844:4:2:78:Griffe droite de grand seigneur de guerre
272597:4:2:65:Griffe droite de qualité de grand seigneur de guerre
20070:4:2:60:Griffe du sage
18848:4:2:78:Griffe gauche de grand seigneur de guerre
272598:4:2:65:Griffe gauche de qualité de grand seigneur de guerre
11863:2:2:52:Griffes d'os blanc
20003:3:2:52:Griffes de diablosaure
20005:3:2:52:Griffes de diablosaure
16302:1:9:8:Grimoire d'Eclair de feu (rang 2)
16316:1:9:18:Grimoire d'Eclair de feu (rang 3)
16317:1:9:28:Grimoire d'Eclair de feu (rang 4)
16318:1:9:38:Grimoire d'Eclair de feu (rang 5)
16319:1:9:48:Grimoire d'Eclair de feu (rang 6)
16320:1:9:58:Grimoire d'Eclair de feu (rang 7)
9214:2:9:50:Grimoire d'Inferno
16380:1:9:32:Grimoire d'Invisibilité inférieure
16375:1:9:22:Grimoire de Baiser apaisant (rang 1)
16376:1:9:34:Grimoire de Baiser apaisant (rang 2)
16377:1:9:46:Grimoire de Baiser apaisant (rang 3)
16378:1:9:58:Grimoire de Baiser apaisant (rang 4)
16326:1:9:14:Grimoire de Bouclier de feu (rang 1)
16327:1:9:24:Grimoire de Bouclier de feu (rang 2)
16328:1:9:34:Grimoire de Bouclier de feu (rang 3)
16329:1:9:44:Grimoire de Bouclier de feu (rang 4)
16330:1:9:54:Grimoire de Bouclier de feu (rang 5)
16331:1:9:12:Grimoire de Changement de phase
16357:1:9:18:Grimoire de Consumer l’ombre (rang 1)
16358:1:9:26:Grimoire de Consumer l’ombre (rang 2)
16359:1:9:34:Grimoire de Consumer l’ombre (rang 3)
16360:1:9:42:Grimoire de Consumer l’ombre (rang 4)
16361:1:9:50:Grimoire de Consumer l’ombre (rang 5)
16362:1:9:58:Grimoire de Consumer l’ombre (rang 6)
16384:1:9:32:Grimoire de Corruption sanguine (rang 1)
16385:1:9:40:Grimoire de Corruption sanguine (rang 2)
16386:1:9:48:Grimoire de Corruption sanguine (rang 3)
16387:1:9:56:Grimoire de Corruption sanguine (rang 4)
16381:1:9:38:Grimoire de Festin magique (rang 2)
16382:1:9:46:Grimoire de Festin magique (rang 3)
16383:1:9:54:Grimoire de Festin magique (rang 4)
16368:1:9:28:Grimoire de Fouet de la douleur (rang 2)
16371:1:9:36:Grimoire de Fouet de la douleur (rang 3)
16372:1:9:44:Grimoire de Fouet de la douleur (rang 4)
16373:1:9:52:Grimoire de Fouet de la douleur (rang 5)
16374:1:9:60:Grimoire de Fouet de la douleur (rang 6)
4213:2:9:60:Grimoire de Malédiction
16321:1:9:4:Grimoire de Pacte de sang (rang 1)
16322:1:9:14:Grimoire de Pacte de sang (rang 2)
16323:1:9:26:Grimoire de Pacte de sang (rang 3)
16324:1:9:38:Grimoire de Pacte de sang (rang 4)
16325:1:9:50:Grimoire de Pacte de sang (rang 5)
16390:1:9:42:Grimoire de Paranoïa
16351:1:9:16:Grimoire de Sacrifice (rang 1)
16352:1:9:24:Grimoire de Sacrifice (rang 2)
16353:1:9:32:Grimoire de Sacrifice (rang 3)
16354:1:9:40:Grimoire de Sacrifice (rang 4)
16355:1:9:48:Grimoire de Sacrifice (rang 5)
16356:1:9:56:Grimoire de Sacrifice (rang 6)
16363:1:9:24:Grimoire de Souffrance (rang 1)
16364:1:9:36:Grimoire de Souffrance (rang 2)
16365:1:9:48:Grimoire de Souffrance (rang 3)
16366:1:9:60:Grimoire de Souffrance (rang 4)
16379:1:9:26:Grimoire de Séduction
16346:1:9:20:Grimoire de Tourment (rang 2)
16347:1:9:30:Grimoire de Tourment (rang 3)
16348:1:9:40:Grimoire de Tourment (rang 4)
16349:1:9:50:Grimoire de Tourment (rang 5)
16350:1:9:60:Grimoire de Tourment (rang 6)
16388:1:9:36:Grimoire de Verrou magique (rang 1)
16389:1:9:52:Grimoire de Verrou magique (rang 2)
216748:2:0:25:Grimoire du portail d’invocation
281306:2:4:31:Grimoire marqué par les flammes
221344:3:4:55:Grimoire personnel
21325:2:0:58:Grinche mécanique
18269:2:0:1:Grog vert gordok
21181:3:4:66:Grâce de la Terre
274916:2:4:38:Grèves de bedeau
23278:3:4:66:Grèves de chevalier-lieutenant en anneaux
23287:3:4:66:Grèves de chevalier-lieutenant en plaques
22843:3:4:66:Grèves de garde de sang en anneaux
22857:3:4:66:Grèves de garde de sang en mailles
22858:3:4:66:Grèves de garde de sang en plaques
5944:2:4:15:Grèves de la milice du peuple
20154:3:4:63:Grèves de Profanateur en anneaux
20155:3:4:53:Grèves de Profanateur en anneaux
20156:3:4:43:Grèves de Profanateur en anneaux
20157:3:4:33:Grèves de Profanateur en anneaux
20199:3:4:63:Grèves de Profanateur en mailles
20200:3:4:43:Grèves de Profanateur en mailles
20201:3:4:33:Grèves de Profanateur en mailles
20202:3:4:53:Grèves de Profanateur en mailles
20208:3:4:63:Grèves de Profanateur en plaques
20209:3:4:43:Grèves de Profanateur en plaques
20210:3:4:33:Grèves de Profanateur en plaques
20211:3:4:53:Grèves de Profanateur en plaques
20181:3:4:63:Grèves de Profanateur lamellaires
20182:3:4:33:Grèves de Profanateur lamellaires
20183:3:4:43:Grèves de Profanateur lamellaires
20185:3:4:53:Grèves de Profanateur lamellaires
274192:3:4:60:Grèves de qualité en mailles plates
272609:3:4:60:Grèves de qualité rivetées
20050:3:4:63:Grèves des Hautes-terres en anneaux
20091:3:4:53:Grèves des Hautes-terres en anneaux
20092:3:4:43:Grèves des Hautes-terres en anneaux
20093:3:4:33:Grèves des Hautes-terres en anneaux
20051:3:4:63:Grèves des Hautes-terres en mailles
20121:3:4:53:Grèves des Hautes-terres en mailles
20122:3:4:43:Grèves des Hautes-terres en mailles
20123:3:4:33:Grèves des Hautes-terres en mailles
20048:3:4:63:Grèves des Hautes-terres en plaques
20127:3:4:53:Grèves des Hautes-terres en plaques
20128:3:4:43:Grèves des Hautes-terres en plaques
20129:3:4:33:Grèves des Hautes-terres en plaques
20049:3:4:63:Grèves des Hautes-terres lamellaires
20109:3:4:53:Grèves des Hautes-terres lamellaires
20110:3:4:43:Grèves des Hautes-terres lamellaires
20111:3:4:33:Grèves des Hautes-terres lamellaires
21333:4:4:78:Grèves du Conquérant
275438:2:4:58:Grèves du deuil
21388:4:4:78:Grèves du Vengeur
276341:2:4:58:Grèves d’écraseur de peste
277242:2:4:45:Grèves en runargent
20710:3:4:63:Grèves incrustées de cristaux
20711:3:4:63:Grèves revêtues de cristaux
277085:1:4:14:Grèves zéphrali
21519:1:15:1:Gui
17004:2:2:61:Guide de Sarah
213563:1:15:1:Guide de terrain
281699:2:4:1:Guêtres en cuir restaurées
21215:1:0:65:Gâteau aux fruits secs de Graccu
208847:1:15:1:Géode en forme de crâne
208848:1:15:1:Géode en forme de crâne fêlé
215683:1:5:25:Géomancie : une montagne de puissance
9649:2:4:55:Habit de faveur royale
21544:1:4:1:Habit de fête bleu
21541:1:4:1:Habit de fête noir
21543:1:4:1:Habit de fête turquoise
17605:4:4:74:Habit de grand maréchal en satin
16443:4:4:74:Habit de grand maréchal en soie
21351:4:4:88:Habit de l'oracle
17612:3:4:63:Habit de légionnaire en satin
272752:4:4:65:Habit de qualité de grand maréchal en soie
22281:1:4:1:Habit de soirée bleu
22277:1:4:1:Habit de soirée rouge
22282:1:4:1:Habit de soirée violet
14154:4:4:62:Habit de vraie foi
257344:2:4:13:Habits de contemple-ciel
272821:4:4:65:Habits de qualité de grand maréchal en étoffe du Vide
273424:4:4:65:Habits de qualité de grand maréchal en étoffe lunaire
272564:3:4:60:Habits de qualité en satin
272839:4:2:65:Hache courte de qualité de connétable
239013:5:7:60:Hache cristalline
6966:2:2:15:Hache d'Elunite
6978:2:2:15:Hache d'Umbral
18831:4:2:78:Hache de bataille de grand seigneur de guerre
272593:4:2:65:Hache de bataille de qualité de grand seigneur de guerre
2907:2:2:20:Hache de bûcheron naine
2047:1:2:5:Hache de Courbenclume
5459:2:2:13:Hache de défenseur
21242:4:2:79:Hache de guerre qiraji bénie
6979:2:2:15:Hache de Haggard
7115:2:2:15:Hache de l'héritier
21135:3:2:63:Hache de lancer de l'assassin
3154:2:2:18:Hache de Thelsamar
7326:2:2:15:Hache de Thun'grim
6975:3:2:40:Hache de tourbillon
5318:2:2:20:Hache de Zhovur
1386:1:2:5:Hache des chardons
2044:2:2:35:Hache des Esprits glacés
5777:1:2:5:Hache du brave
10744:2:2:51:Hache du drake d'ébène
274929:2:2:39:Hache d’abattage d’Hurley
1011:1:2:8:Hache tranchante
4965:1:2:10:Hache à main de Sabot-de-Sang
5344:2:2:14:Hache à pointe
18827:4:2:78:Hachette de connétable
3071:1:2:12:Hachette découpante
12773:2:2:55:Hachette ornée en thorium
4923:1:2:5:Hachette primitive
276340:2:4:60:Hakama de maître-lame
19979:3:4:65:Hameçon du maître pêcheur
22727:5:15:60:Hampe d'Atiesh
6798:2:2:37:Haquebute explosive
15688:1:12:1:Haricots magiques
4968:1:4:11:Harnais lié
277086:1:4:14:Harnais zéphrali
12970:3:4:63:Harnois de cérémonie de général
11604:3:4:59:Harnois en sombrefer
274963:2:2:42:Harpon couvert de pourriture
208773:1:0:1:Harpon de pêche
209047:1:0:1:Harpon noueux
281296:2:2:25:Hast de chevalier
19128:2:4:50:Haubergeon calciné
10656:1:4:5:Haubergeon d'écorce
3151:1:4:10:Haubergeon de sapeur
21320:2:4:58:Haubergeon du protecteur
3273:1:4:5:Haubergeon robuste
19828:4:4:65:Haubert d'augure zandalar
21374:4:4:88:Haubert d'implorateur de tempête
7133:3:4:30:Haubert de brutalité
16425:3:4:63:Haubert de chevalier-capitaine en anneaux
23292:3:4:68:Haubert de chevalier-capitaine en anneaux
23300:3:4:68:Haubert de chevalier-capitaine en plaques
22874:3:4:68:Haubert de légionnaire en anneaux
16505:3:4:63:Haubert de légionnaire en cuir
22876:3:4:68:Haubert de légionnaire en mailles
273413:4:4:65:Haubert de qualité de seigneur de guerre en cuir de kodo
272514:4:4:65:Haubert de qualité de seigneur de guerre en peau de dragon
273405:4:4:65:Haubert de qualité de seigneur de guerre en peau de wyrm
272734:3:4:60:Haubert de qualité en mailles
274194:3:4:60:Haubert de qualité en mailles plates
272473:3:4:60:Haubert de qualité en pelombre
272625:3:4:60:Haubert de qualité riveté
16549:4:4:74:Haubert de seigneur de guerre en peau de dragon
21370:4:4:88:Haubert du Frappeur
15787:2:4:59:Haubert du saule
6972:3:4:30:Haubert en acier trempé
11194:2:4:57:Haubert en écailles prismatiques
16521:3:4:63:Heaume de champion en mailles
16514:3:4:63:Heaume de champion en plaques
12018:3:4:54:Heaume de conservateur
250502:3:4:30:Heaume de croisé en anneaux
250532:3:4:25:Heaume de croisé en anneaux argentés
250499:3:4:30:Heaume de garde en anneaux
250529:3:4:25:Heaume de garde en anneaux argentés
16451:4:4:74:Heaume de grand maréchal en peau de dragon
23314:3:4:71:Heaume de lieutenant-commandant en plaques
250500:3:4:30:Heaume de protecteur en anneaux
250530:3:4:25:Heaume de protecteur en anneaux argentés
272774:4:4:65:Heaume de qualité de grand maréchal en mailles
274188:4:4:65:Heaume de qualité de grand maréchal en mailles plates
274211:4:4:65:Heaume de qualité de grand maréchal en mailles rivetées
274203:4:4:65:Heaume de qualité de grand maréchal en écailles
273341:4:4:65:Heaume de qualité de seigneur de guerre en mailles
273349:4:4:65:Heaume de qualité de seigneur de guerre en mailles annelées
272526:4:4:65:Heaume de qualité de seigneur de guerre en pelombre
272543:4:4:65:Heaume de qualité de seigneur de guerre riveté
272486:3:4:60:Heaume de qualité en mailles
273356:3:4:60:Heaume de qualité en mailles annelées
274218:3:4:60:Heaume de qualité en mailles rivetées
272471:3:4:60:Heaume de qualité en peau de dragon
272738:3:4:60:Heaume de qualité en plaques
274178:3:4:60:Heaume de qualité en écailles
16566:4:4:74:Heaume de seigneur de guerre en anneaux
16578:4:4:74:Heaume de seigneur de guerre en mailles
16542:4:4:74:Heaume de seigneur de guerre en plaques
250498:3:4:30:Heaume de vétéran en anneaux
250528:3:4:25:Heaume de vétéran en anneaux argentés
22353:4:15:60:Heaume désacralisé
250501:3:4:30:Heaume d’acolyte en anneaux
250531:3:4:25:Heaume d’acolyte en anneaux argentés
281709:2:4:1:Heaume en plaques restauré
250597:3:4:63:Heaume en thorium enrichi
281685:2:4:1:Heaume en tissu restauré
23019:4:4:83:Heaume plaie-de-glace
9250:1:12:40:Horaires du navire
271720:3:4:30:Houseaux en peau de crocilisque
21212:1:0:40:Houx frais
8095:1:0:1:Huile d'Hinott
1322:1:0:21:Huile de foie de poisson
23123:2:0:55:Huile de sorcier bénite
287979:1:7:40:Huile de sorcier inférieure
211815:1:0:1:Hymne de bataille d’Aile-argent
272450:1:4:40:Héraut de garde de pierre
15199:1:4:40:Héraut du Garde de pierre
264908:1:4:1:Héritage antique
21520:4:2:76:Héritage de Ravencrest
276901:2:4:54:Héroïsme avunculaire
206384:2:4:5:Icône astrale
206385:2:4:5:Icône clastique
206376:2:4:5:Icône de barricade
230008:4:13:77:Icône de combattant de Linkue
206389:2:4:5:Icône de soufre
206382:2:4:10:Icône de tempête
206381:2:4:1:Icône dyadique
249398:3:4:25:Icône en bois flotté poli
206386:2:4:1:Icône galvanique
206390:2:4:5:Icône ichthyane
270298:1:12:10:Icône impie
206387:2:4:25:Icône kajarique
206383:2:4:5:Icône lithique
206388:2:4:1:Icône sulfureuse
206391:2:4:5:Icône syzygique
270276:2:4:51:Icône vilebranche purifiée
225838:2:4:1:Icône voltaïque
23716:1:4:1:Idole d'ogre sculptée
227444:2:4:60:Idole de la chasseresse
206954:2:4:10:Idole de la rage ursine
23004:4:4:83:Idole de longévité
213594:2:4:40:Idole de moquerie
203990:2:0:1:Idole de mutilation
210229:2:0:1:Idole de mutilation
22399:4:4:78:Idole de santé
272429:3:4:65:Idole de synthèse
263411:2:4:16:Idole des flots changeants
210534:2:4:25:Idole du fauve
220606:3:4:60:Idole du Rêve
220915:2:4:50:Idole du traînard enragé
210195:2:4:10:Idole déséquilibrée
272428:3:4:65:Idole enragée
208689:2:4:20:Idole féroce
272430:3:4:65:Idole grouillante
272427:3:4:65:Idole hurlante
208414:2:4:5:Idole lunaire
22637:3:15:60:Idole primordiale hakkari
219999:2:12:1:Incursions de cauchemar : Ashenvale, mission I
220000:2:12:1:Incursions de cauchemar : Ashenvale, mission II
220001:2:12:1:Incursions de cauchemar : Ashenvale, mission III
220002:2:12:1:Incursions de cauchemar : Ashenvale, mission IV
220007:2:12:1:Incursions de cauchemar : Ashenvale, mission IX
220003:2:12:1:Incursions de cauchemar : Ashenvale, mission V
220004:2:12:1:Incursions de cauchemar : Ashenvale, mission VI
220005:2:12:1:Incursions de cauchemar : Ashenvale, mission VII
220006:2:12:1:Incursions de cauchemar : Ashenvale, mission VIII
220008:2:12:1:Incursions de cauchemar : Ashenvale, mission X
220009:2:12:1:Incursions de cauchemar : Ashenvale, mission XI
220010:2:12:1:Incursions de cauchemar : Ashenvale, mission XII
220011:2:12:1:Incursions de cauchemar : Ashenvale, mission XIII
220012:2:12:1:Incursions de cauchemar : Ashenvale, mission XIV
220013:2:12:1:Incursions de cauchemar : Ashenvale, mission XV
220014:2:12:1:Incursions de cauchemar : Ashenvale, mission XVI
220015:2:12:1:Incursions de cauchemar : Ashenvale, mission XVII
220016:2:12:1:Incursions de cauchemar : Ashenvale, mission XVIII
219962:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission I
219966:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission II
219967:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission III
219968:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission IV
219973:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission IX
219969:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission V
219970:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission VI
219971:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission VII
219972:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission VIII
219974:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission X
219975:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XI
219976:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XII
219977:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XIII
219978:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XIV
219979:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XV
219980:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XVI
219981:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XVII
219982:2:12:1:Incursions de cauchemar : bois de la Pénombre, mission XVIII
220035:2:12:1:Incursions de cauchemar : Feralas, mission I
220036:2:12:1:Incursions de cauchemar : Feralas, mission II
220037:2:12:1:Incursions de cauchemar : Feralas, mission III
220038:2:12:1:Incursions de cauchemar : Feralas, mission IV
220043:2:12:1:Incursions de cauchemar : Feralas, mission IX
220039:2:12:1:Incursions de cauchemar : Feralas, mission V
220040:2:12:1:Incursions de cauchemar : Feralas, mission VI
220041:2:12:1:Incursions de cauchemar : Feralas, mission VII
220042:2:12:1:Incursions de cauchemar : Feralas, mission VIII
220044:2:12:1:Incursions de cauchemar : Feralas, mission X
220045:2:12:1:Incursions de cauchemar : Feralas, mission XI
220046:2:12:1:Incursions de cauchemar : Feralas, mission XII
220047:2:12:1:Incursions de cauchemar : Feralas, mission XIII
220048:2:12:1:Incursions de cauchemar : Feralas, mission XIV
220049:2:12:1:Incursions de cauchemar : Feralas, mission XV
220050:2:12:1:Incursions de cauchemar : Feralas, mission XVI
220051:2:12:1:Incursions de cauchemar : Feralas, mission XVII
220052:2:12:1:Incursions de cauchemar : Feralas, mission XVIII
220017:2:12:1:Incursions de cauchemar : Hinterlands, mission I
220018:2:12:1:Incursions de cauchemar : Hinterlands, mission II
220019:2:12:1:Incursions de cauchemar : Hinterlands, mission III
220020:2:12:1:Incursions de cauchemar : Hinterlands, mission IV
220025:2:12:1:Incursions de cauchemar : Hinterlands, mission IX
220021:2:12:1:Incursions de cauchemar : Hinterlands, mission V
220022:2:12:1:Incursions de cauchemar : Hinterlands, mission VI
220023:2:12:1:Incursions de cauchemar : Hinterlands, mission VII
220024:2:12:1:Incursions de cauchemar : Hinterlands, mission VIII
220026:2:12:1:Incursions de cauchemar : Hinterlands, mission X
220027:2:12:1:Incursions de cauchemar : Hinterlands, mission XI
220028:2:12:1:Incursions de cauchemar : Hinterlands, mission XII
220029:2:12:1:Incursions de cauchemar : Hinterlands, mission XIII
220030:2:12:1:Incursions de cauchemar : Hinterlands, mission XIV
220031:2:12:1:Incursions de cauchemar : Hinterlands, mission XV
220032:2:12:1:Incursions de cauchemar : Hinterlands, mission XVI
220033:2:12:1:Incursions de cauchemar : Hinterlands, mission XVII
220034:2:12:1:Incursions de cauchemar : Hinterlands, mission XVIII
21670:4:4:76:Insigne de garde-essaim
19948:4:4:68:Insigne de héros zandalarien
18854:3:4:1:Insigne de l'Alliance
18856:3:4:1:Insigne de l'Alliance
18857:3:4:1:Insigne de l'Alliance
18858:3:4:1:Insigne de l'Alliance
18859:3:4:1:Insigne de l'Alliance
18862:3:4:1:Insigne de l'Alliance
18863:3:4:1:Insigne de l'Alliance
18864:3:4:1:Insigne de l'Alliance
22523:2:15:1:Insigne de l'Aube
22524:2:15:1:Insigne de la Croisade
18834:3:4:1:Insigne de la Horde
18845:3:4:1:Insigne de la Horde
18846:3:4:1:Insigne de la Horde
18849:3:4:1:Insigne de la Horde
18850:3:4:1:Insigne de la Horde
18851:3:4:1:Insigne de la Horde
18852:3:4:1:Insigne de la Horde
18853:3:4:1:Insigne de la Horde
209619:3:4:1:Insigne de la Horde
209620:3:4:1:Insigne de la Horde
209621:3:4:1:Insigne de la Horde
209622:3:4:1:Insigne de la Horde
209623:3:4:1:Insigne de la Horde
209624:3:4:1:Insigne de la Horde
209625:3:4:1:Insigne de la Horde
209626:3:4:1:Insigne de la Horde
209611:3:4:1:Insigne de l’Alliance
209612:3:4:1:Insigne de l’Alliance
209613:3:4:1:Insigne de l’Alliance
209614:3:4:1:Insigne de l’Alliance
209615:3:4:1:Insigne de l’Alliance
209616:3:4:1:Insigne de l’Alliance
209617:3:4:1:Insigne de l’Alliance
209618:3:4:1:Insigne de l’Alliance
274968:3:4:60:Insigne de qualité de sergent-chef
274969:3:4:60:Insigne de qualité de sergent-chef
21229:1:15:60:Insigne de seigneur qiraji
15200:3:4:35:Insigne de sergent-chef
16335:3:4:63:Insigne de sergent-chef
18428:3:4:50:Insigne de sergent-chef
18442:3:4:35:Insigne de sergent-chef
18443:3:4:63:Insigne de sergent-chef
18444:3:4:50:Insigne de sergent-chef
268535:1:12:1:Insigne ensanglanté
17691:2:4:60:Insigne foudrepique grade 1
17900:2:4:60:Insigne foudrepique grade 2
17901:2:4:60:Insigne foudrepique grade 3
17902:3:4:60:Insigne foudrepique grade 4
17903:3:4:60:Insigne foudrepique grade 5
17904:4:4:60:Insigne foudrepique grade 6
17690:2:4:60:Insigne loup-de-givre grade 1
17905:2:4:60:Insigne loup-de-givre grade 2
17906:2:4:60:Insigne loup-de-givre grade 3
17907:3:4:60:Insigne loup-de-givre grade 4
17908:3:4:60:Insigne loup-de-givre grade 5
17909:4:4:60:Insigne loup-de-givre grade 6
10418:2:4:50:Insigne rougeoyant en mithril
274444:3:4:1:Insigne supérieur de la Horde
274445:3:4:1:Insigne supérieur de l’Alliance
18987:1:12:55:Instructions de Blackhand
18818:1:12:1:Instructions de Mor'zul
7516:1:0:1:Instructions de Tabetha
7587:1:12:1:Instructions de Thun'grim
285356:1:12:1:Instructions du conseiller Emerson
285357:1:12:1:Instructions du conseiller Nazgrel
13356:1:12:1:Intensificateur somatique
226679:3:0:60:Intuition du vagabond intemporel
215434:4:9:40:INUTILISÉ
241613:3:0:1:Inutilisé
21711:1:0:55:Invitation à la fête lunaire
5513:1:0:38:Jade de mana
22747:4:4:65:Jambière de voltigeur en soie
253997:3:4:30:Jambières brillantes
253947:3:4:25:Jambières brillantes filigranées
270011:2:4:21:Jambières brodées
12107:2:4:60:Jambières chuchotantes
21375:4:4:81:Jambières d'implorateur de tempête
270056:2:4:37:Jambières de bibliothécaire de Stromgarde
7132:2:4:29:Jambières de brutalité
4741:2:4:37:Jambières de cavalier de Stromgarde
16426:3:4:63:Jambières de chevalier-capitaine en anneaux
16419:3:4:63:Jambières de chevalier-capitaine en cuir
16422:3:4:63:Jambières de chevalier-capitaine en peau de dragon
23295:3:4:68:Jambières de chevalier-capitaine en peau de dragon
16431:3:4:63:Jambières de chevalier-capitaine en plaques
23301:3:4:68:Jambières de chevalier-capitaine en plaques
17599:3:4:63:Jambières de chevalier-capitaine en satin
17567:3:4:63:Jambières de chevalier-capitaine en tisse-effroi
2694:2:4:17:Jambières de colon
250497:3:4:25:Jambières de croisé en anneaux
250527:3:4:30:Jambières de croisé en anneaux argentés
21362:4:4:81:Jambières de dispensateur de mort
12105:2:4:60:Jambières de fierté
22513:4:4:88:Jambières de foi
6084:2:4:13:Jambières de garde de Hurlevent
250494:3:4:25:Jambières de garde en anneaux
250524:3:4:30:Jambières de garde en anneaux argentés
257342:2:4:13:Jambières de garde-paix d’élite
271739:1:4:1:Jambières de garde-paix shen’dorei
15202:2:4:18:Jambières de gardien de fauves
22497:4:4:88:Jambières de givrefeu
15203:2:4:18:Jambières de Guststorm
16567:4:4:71:Jambières de général en anneaux
16564:4:4:71:Jambières de général en cuir
16579:4:4:71:Jambières de général en mailles
16552:4:4:71:Jambières de général en peau de dragon
16543:4:4:71:Jambières de général en plaques
17625:4:4:71:Jambières de général en satin
4970:1:4:9:Jambières de kodo mal tannées
21316:2:4:55:Jambières de l'ursa
21346:4:4:81:Jambières de l'énigme
5398:1:4:5:Jambières de la canopée
11911:2:4:55:Jambières de la canopée
274939:2:4:40:Jambières de la garde du Sud
12295:2:4:15:Jambières de la milice du peuple
16527:3:4:63:Jambières de légionnaire en anneaux
16508:3:4:63:Jambières de légionnaire en cuir
16523:3:4:63:Jambières de légionnaire en mailles
22878:3:4:68:Jambières de légionnaire en peau de dragon
16515:3:4:63:Jambières de légionnaire en plaques
22873:3:4:68:Jambières de légionnaire en plaques
17571:3:4:63:Jambières de légionnaire en tisse-effroi
271728:1:4:1:Jambières de magistère shen’dorei
16467:4:4:71:Jambières de maréchal en anneaux
16456:4:4:71:Jambières de maréchal en cuir
16450:4:4:71:Jambières de maréchal en peau de dragon
16479:4:4:71:Jambières de maréchal en plaques
16442:4:4:71:Jambières de maréchal en soie
17579:4:4:71:Jambières de maréchal en tisse-effroi
270090:2:4:44:Jambières de mendiant
22505:4:4:88:Jambières de pestecoeur
19124:2:4:48:Jambières de plaques mâchefer
277225:2:4:45:Jambières de plumes
250495:3:4:25:Jambières de protecteur en anneaux
250525:3:4:30:Jambières de protecteur en anneaux argentés
272744:3:4:60:Jambières de qualité de chevalerie
273416:4:4:65:Jambières de qualité de général en cuir de kodo
273342:4:4:65:Jambières de qualité de général en mailles
273350:4:4:65:Jambières de qualité de général en mailles annelées
272517:4:4:65:Jambières de qualité de général en peau de dragon
273408:4:4:65:Jambières de qualité de général en peau de wyrm
272508:4:4:65:Jambières de qualité de général en plaques cimentières
272577:4:4:65:Jambières de qualité de général en satin
272544:4:4:65:Jambières de qualité de général rivetées
272765:4:4:65:Jambières de qualité de maréchal en cuir
274189:4:4:65:Jambières de qualité de maréchal en mailles plates
274212:4:4:65:Jambières de qualité de maréchal en mailles rivetées
272788:4:4:65:Jambières de qualité de maréchal en plaques
272751:4:4:65:Jambières de qualité de maréchal en soie
272803:4:4:65:Jambières de qualité de maréchal en tisse-effroi
274204:4:4:65:Jambières de qualité de maréchal en écailles
272492:3:4:60:Jambières de qualité en anneaux
272627:3:4:60:Jambières de qualité en cuir de kodo
272735:3:4:60:Jambières de qualité en mailles
274180:3:4:60:Jambières de qualité en mailles plates
272731:3:4:60:Jambières de qualité en peau de bête
273385:3:4:60:Jambières de qualité en peau de wyrm
273373:3:4:60:Jambières de qualité en peau du Rêve
272656:3:4:60:Jambières de qualité en peau lunaire
272476:3:4:60:Jambières de qualité en pelombre
272740:3:4:60:Jambières de qualité en plaques
272723:3:4:60:Jambières de qualité en soie
274232:3:4:60:Jambières de qualité en écailles
272815:3:4:60:Jambières de qualité en étoffe du Vide
273447:3:4:60:Jambières de qualité en étoffe lunaire
274245:3:4:60:Jambières de qualité lamellaires
272853:3:4:60:Jambières de qualité lumineuses
272488:3:4:60:Jambières de qualité rivetées
20703:3:4:63:Jambières de réserviste cénariennes
20704:3:4:63:Jambières de réserviste cénariennes
252519:3:4:30:Jambières de sagesse en cuir
22748:4:4:65:Jambières de sentinelle en anneaux
22752:4:4:65:Jambières de sentinelle en soie
7949:2:4:36:Jambières de Thero-shan
270111:2:4:51:Jambières de Troll des forêts
11882:2:4:56:Jambières de voltigeur
22673:4:4:65:Jambières de voltigeur en anneaux
22676:4:4:65:Jambières de voltigeur en mailles
22651:4:4:65:Jambières de voltigeur en plaques
250493:3:4:25:Jambières de vétéran en anneaux
250523:3:4:30:Jambières de vétéran en anneaux argentés
12041:3:4:54:Jambières de Windshear
271762:1:4:1:Jambières de zélote al’aketh
9652:2:4:53:Jambières des chevaucheurs de gryphon
10742:2:4:51:Jambières des dragons
253991:3:4:30:Jambières des flammes
253941:3:4:25:Jambières des flammes filigranées
3751:2:4:30:Jambières des mercenaires
22690:3:4:66:Jambières du chassepeste
4909:2:4:15:Jambières du chasseur de kodo
4108:2:4:40:Jambières du chasseur de panthères
21368:4:4:81:Jambières du Frappeur
15470:2:4:29:Jambières du Garde des plaines
6671:2:4:27:Jambières du molosse
15456:2:4:37:Jambières du pas léger
22067:3:4:66:Jambières du sorcier
5617:2:4:13:Jambières du vagabond
11852:1:4:5:Jambières du vagabond
22366:4:15:60:Jambières désacralisées
4917:1:4:5:Jambières détériorées en anneaux
250496:3:4:25:Jambières d’acolyte en anneaux
250526:3:4:30:Jambières d’acolyte en anneaux argentés
270097:2:4:46:Jambières d’archer
271752:1:4:1:Jambières d’oracle des cieux shen’dorei
6973:2:4:29:Jambières en acier trempé
10635:1:4:5:Jambières en anneaux peints
17006:2:4:27:Jambières en cobalt
9599:2:4:10:Jambières en mailles d'écorce
2545:2:4:26:Jambières en mailles de l'apprenti
263422:1:4:7:Jambières en patchwork
3272:1:4:5:Jambières en peau de zombie
281715:2:4:1:Jambières en plaques restaurées
250596:3:4:63:Jambières en thorium enrichi
11910:2:4:55:Jambières enchâssées
21530:4:4:77:Jambières enchâssées d'onyx
270037:2:4:28:Jambières fumantes
22700:4:4:80:Jambières glaciaires
22702:4:4:80:Jambières glacécaille
253987:3:4:30:Jambières immaculées
253937:3:4:25:Jambières immaculées filigranées
16435:3:4:63:Jambières lamellaires de chevalier-capitaine
23273:3:4:68:Jambières lamellaires de chevalier-capitaine
16475:4:4:71:Jambières lamellaires de maréchal
274254:4:4:65:Jambières lamellaires de qualité de général
22072:3:4:66:Jambières Mortebrume
253995:3:4:30:Jambières nacrées
253945:3:4:25:Jambières nacrées filigranées
20524:3:4:52:Jambières ombrepoil
253993:3:4:30:Jambières ombreuses
253943:3:4:25:Jambières ombreuses filigranées
22699:4:4:80:Jambières plaie-de-glace
22701:4:4:80:Jambières polaires
4921:1:4:5:Jambières poussiéreuses
253989:3:4:30:Jambières soyeuses
273436:4:4:65:Jambières soyeuses de qualité de général
253939:3:4:25:Jambières soyeuses filigranées
252458:3:4:30:Jambières totémiques en cuir
276339:2:4:57:Jambières traitées en peau de cerf
277102:1:4:14:Jambières zéphrali
274943:2:4:40:Jambières écrase-Gnoll
9380:3:2:50:Jang'thraze le Protecteur
11024:1:12:1:Jardinières de printemps
249456:3:4:50:Jarre d’essence distordue
17115:1:12:1:Jeton de l'écureuil
17116:1:12:1:Jeton de l'écureuil
122270:1:18:1:Jeton WoW
122284:1:18:1:Jeton WoW
23570:4:4:81:Jom Gabbar
281634:3:4:35:Jonc de recherche de terrain
281673:2:4:28:Jonc de sacrifice
243177:3:13:1:Jouet ingénieux
8046:1:9:1:Journal de Kearnen
221017:1:15:1:Journal de Keldara
203755:1:5:10:Journal de recherche de l’archimage Théocritus
21130:1:15:1:Journal de Weavil
7295:1:12:1:Journal des messages de Tazan
221192:2:15:1:Journal des rêves
260347:1:15:1:Journal en lambeaux
7668:1:15:1:Journal maculé de sang
12842:1:12:52:Journal mal écrit
270225:2:4:51:Joyau de capitaine de la garde
19601:4:4:65:Joyau de Kajaro
8050:1:12:1:Joyau de Tallonkai
277519:3:0:60:Joyau enchanté de Nelanna
20936:4:12:1:Joyau qiraji béni
20887:4:12:1:Joyau qiraji ciselé
20937:4:12:1:Joyau qiraji enchassé
20883:4:12:1:Joyau qiraji orné de glyphes
19884:4:2:66:Jugement de Jin'do
257278:1:4:5:Jupe ordinaire
22085:3:4:66:Jupe vertueuse
13813:1:0:55:Jus de Fruit solaire béni
274093:3:13:60:Kaléidoscope lumineux
257335:1:4:10:Kilt balayé par la brise
22111:3:4:66:Kilt Cœur-Farouche
22465:4:4:88:Kilt de Brise-terre
252518:3:4:30:Kilt de chevaucheur de tempête en cuir
252457:3:4:30:Kilt de défenseur en cuir
4976:2:4:41:Kilt de Mistspray
22100:3:4:66:Kilt des Cinq tonnerres
274741:2:4:25:Kilt fripé
10834:1:15:1:Kit de Gangrechien traqueur
213565:1:15:1:Kit d’entomologiste novice
18247:4:15:40:Kodo de guerre noir
22379:3:2:65:Kriss de Shivsprocket
21416:4:2:70:Kriss des noms inexprimés
275647:2:2:59:Kriss rituel purifié
10595:2:15:1:Kum'isha's Junk
23046:4:4:90:L'essence contenue de Saphiron
13152:1:0:1:L'histoire sans conclusion
19321:4:4:60:L'Objet inébranlable
18646:4:4:71:L'Oeil de la divinité
19591:2:4:60:L'Oeil de Zuldazar
19592:3:4:60:L'Oeil de Zuldazar
19593:3:4:68:L'Oeil de Zuldazar
19594:4:4:65:L'Oeil omnivoyant de Zuldazar
23558:4:4:81:La Carapace du fouisseur
7146:2:13:1:La Clé écarlate
21152:1:12:1:La Corruption du cauchemar
228138:1:5:60:La Dame et le Chevalier
19323:4:2:60:La Force irrésistible
20415:1:15:1:La Guerre des sables changeants
228141:1:5:60:La nécromancie pour les nuls
274483:1:15:1:La Voie chamanique
9705:2:4:43:Lacet de Tharg
13582:3:15:20:Laisse de zergling
281167:3:15:20:Laisse de zergling
21241:1:0:55:Lait de poule du Voile d'hiver
18489:4:12:1:Lame ancienne brute
9602:2:2:10:Lame Brushwood
248007:2:2:12:Lame courte de la milice
19542:3:2:63:Lame d'éclaireur
19543:3:2:53:Lame d'éclaireur
19544:3:2:43:Lame d'éclaireur
19545:3:2:33:Lame d'éclaireur
20441:3:2:23:Lame d'éclaireur
281628:3:2:52:Lame de Bandarion
15782:2:2:60:Lame de bestiaire
18843:4:2:78:Lame de connétable (main droite)
18847:4:2:78:Lame de connétable (main gauche)
11856:2:2:45:Lame de cérémonie elfique
281059:1:0:1:Lame de déboiseur desserrée
276335:2:2:60:Lame de garde funeste polie
16345:4:2:78:Lame de grand seigneur de guerre
21395:4:2:70:Lame de justice éternelle
4925:1:2:5:Lame de main primitive
7298:2:2:13:Lame de malice
281293:2:2:25:Lame de nécrotraqueur abîmée
272844:4:2:65:Lame de qualité de connétable (main droite)
272845:4:2:65:Lame de qualité de connétable (main gauche)
272452:4:2:65:Lame de qualité de grand seigneur de guerre
5627:2:2:20:Lame de relique
19546:3:2:63:Lame de sentinelle
19547:3:2:53:Lame de sentinelle
19548:3:2:43:Lame de sentinelle
19549:3:2:33:Lame de sentinelle
20443:3:2:23:Lame de Sentinelle
268484:2:2:31:Lame de sélénargent
263973:1:12:1:Lame de tromperie
18957:2:2:10:Lame des broussailles
5586:1:2:5:Lame des chardons
21413:4:2:70:Lame des secrets scellés
19018:5:12:80:Lame du baiser du vent dormante
271796:2:2:38:Lame du clan Magram
10049:2:2:25:Lame du diaboliste
270070:2:2:40:Lame du dément
275742:2:2:59:Lame du fléau des démons
275836:2:2:57:Lame d’acolyte
275729:2:2:57:Lame d’hélice rouillée
19099:3:2:65:Lame glaciale
277246:3:2:36:Lame ornée de rubis
268052:1:12:1:Lame recouverte de bigorneaux
277105:1:2:14:Lame zéphrali
277988:2:2:11:Lame écrin-de-sabot
19019:5:2:80:Lame-tonnerre, épée bénie du Cherchevent
289294:5:2:45:Lame-tonnerre, épée bénie du Cherchevent
276102:2:2:42:Lame-vent
11864:2:2:52:Lance d'os blanc
271794:2:2:38:Lance de Centaure
19106:3:2:63:Lance de glace barbelée
209874:1:15:25:Lance du tueur de dragon
275645:2:2:59:Lance reforgée
281725:2:2:1:Lance restaurée
8051:1:12:1:Lance-fusée
277132:2:0:15:Lanceur de signal de supplanteur de moissonneur
16992:2:2:60:Lanceur explosif de Smokey
277095:1:4:14:Lanière zéphrali
213370:2:7:40:Lanières de cuir irradiées
21540:2:15:40:Lanterne d'Elune
74611:2:15:1:Lanterne de festival
74610:2:15:1:Lanterne lunaire
5323:2:4:25:Lanterne éternelle
268647:1:12:1:Large amas d’appâts
5611:2:4:16:Larme de douleur
22935:4:4:83:Larme de givre
19379:4:4:83:Larme de Neltharion
213552:1:5:1:Larme de Theradras
213553:1:5:1:Larme de Theradras
23557:4:2:81:Larve du Grand ver
219345:3:4:50:Lasso infernal
247846:1:0:1:Le B.a.-ba de la collecte de peaux
21103:4:15:1:Le draconique pour les nuls
21104:4:15:1:Le draconique pour les nuls
21105:4:15:1:Le draconique pour les nuls
21106:4:15:1:Le draconique pour les nuls
21107:4:15:1:Le draconique pour les nuls
21108:4:15:1:Le draconique pour les nuls
21109:4:15:1:Le draconique pour les nuls
21110:4:15:1:Le draconique pour les nuls
21111:1:12:1:Le draconique pour les nuls : volume II
228140:1:5:60:Le Fléau : menace morte-vivante ou phénomène incompris ?
277250:3:2:45:Le fêle-crâne
228134:1:5:60:Le guide complet du nord de Kalimdor
220347:1:5:50:Le liminal et l’arcane
19337:4:4:76:Le Livre noir
19324:4:2:60:Le Lobotomiseur
247840:1:0:1:Le Minage pour les nuls
22520:4:15:60:Le phylactère of Kel'Thuzad
22656:4:2:60:Le Purificateur
21175:1:15:60:Le Sceptre des Sables changeants
215824:1:5:25:Le soin des familiers démoniaques pour les pas doués
22377:3:2:65:Le tisonnier de Thunderwood
19312:4:4:60:Lei du Donneur de vie
215815:1:5:25:Les bases de la magie défensive
213165:1:5:25:Les basilics : faut-il avoir peur de se faire pétrifier ?
215817:1:5:25:Les démons et vous
18582:6:2:100:Les Lames Jumelles d'Azzinoth
207972:1:5:10:Les leçons de Ta’zo
215820:1:5:25:Les Momies : le guide des morts-vivants répugnants
13151:1:0:1:Les études Mystiques d'Hor'ank
22723:1:12:1:Lettre du gardien des registres
20460:1:15:60:Lettre perdue de Brann Bronzebeard
20461:1:15:60:Lettre perdue de Brann Bronzebeard
10443:1:12:48:Lettre roussie
8383:1:15:1:Lettre simple
21314:1:15:1:Lettres et notes sur Metzen
1144:1:9:34:Libram : Bouclier divin
1146:1:9:12:Libram : Résurrection
211472:2:4:25:Libram de bannissement
205218:2:4:5:Libram de découverte
213513:2:4:40:Libram de délivrance
22402:4:4:78:Libram de grâce
205420:2:4:1:Libram de jugement
208851:2:4:10:Libram de justice
228175:3:4:60:Libram de la sainte rapidité
23006:4:4:83:Libram de lumière
272435:3:4:65:Libram de législation
272434:3:4:65:Libram de sentinelle
208849:2:4:10:Libram des bénédictions
249442:3:4:45:Libram d’invocation
272436:3:4:65:Libram d’économie
275347:2:4:59:Lichemort
18563:5:15:70:Liens du Cherchevent
18564:5:15:70:Liens du Cherchevent
19971:2:0:45:Ligne de pêche à toute épreuve en éternium
12288:1:12:1:Limon corrompu en boîte
12736:1:12:1:Liquide d’embaumement de Murmegivre
236002:1:12:1:Liste de composants
239246:1:12:1:Liste de courses de Foiramorce
5352:1:12:20:Livre : Les puissances d'en-bas
239021:1:9:1:Livre de recettes de Carrie
191609:3:12:60:Livre des pierres de mort : amas de spores fongiques
191614:4:12:60:Livre des pierres de mort : barre d’attache squelettique
191608:3:12:60:Livre des pierres de mort : bâtonnet de nécromancie
191666:3:12:60:Livre des pierres de mort : croc d’araignée monstrueux
191610:3:12:60:Livre des pierres de mort : dague rituelle
191550:1:12:60:Livre des pierres de mort : masque funéraire
191606:2:12:60:Livre des pierres de mort : orbe de corruption
191611:4:12:60:Livre des pierres de mort : phylactère de secours
191607:3:12:60:Livre des pierres de mort : relique squelette
191613:4:12:60:Livre des pierres de mort : rune de bonne fortune
191605:2:12:60:Livre des pierres de mort : rune de téléportation I
191612:4:12:60:Livre des pierres de mort : rune de téléportation II
191664:3:12:60:Livre des pierres de mort : éclairs de Thaddius
247834:1:15:1:Livre grignoté
18715:4:2:75:Lok'delar, bâton des Gardiens anciens
20487:4:2:75:Lok'delar, bâton des Gardiens anciens DEP
4840:1:2:10:Longue baïonnette
10638:2:4:15:Longue cape drapée
4922:1:4:5:Lorica abîmée
1275:2:4:25:Lorica d'adjoint
277229:2:4:45:Lorica endurante
277651:1:15:15:Lot de parchemins
211499:3:15:25:Loup voltigeur de recrue
275028:2:4:45:Lueur de mine du Crépuscule
277260:3:4:45:Lueur nocturne de chercheur
279392:3:2:30:Luison
5816:1:0:25:Lumière d'Elune
231909:4:13:1:Lumière stellaire cristallisée
17224:2:12:1:Lunette d'observation
17364:2:12:1:Lunette d'observation
280313:2:4:45:Lunettes cabossées
9653:2:4:50:Lunettes de sprinter
10545:2:4:42:Lunettes gnomes
280310:2:4:45:Lunettes molles
280311:2:4:45:Lunettes tordues
280312:2:4:45:Lunettes à bouton cassé
6645:2:15:15:Lutjan boursouflé
21163:2:15:25:Lutjan de nagefeu boursouflé
4129:2:4:44:Légendaire
220346:1:5:50:Légendes des Eaugures
208185:1:5:10:L’abécédaire métaphysique de l’apothicaire
23451:4:2:78:Magelame de connétable
272856:4:2:65:Magelame de qualité de connétable
228133:1:5:60:Magma ou lave ?
18629:1:12:1:Magnétite noire
11265:3:2:42:Maillet de Cragwood
266889:1:12:1:Maillet de guerre de Komuk
10544:1:2:5:Maillet des chardons
3269:1:2:5:Maillet des Réprouvés
9241:1:12:1:Maillet sacré
208765:2:15:1:Main secourable
208766:2:15:1:Main secourable
260211:3:4:56:Mains de panique
7951:2:4:32:Mains de Thero-shan
19788:3:15:60:Maléfice porte-guigne
20890:4:12:1:Manche orné qiraji
20886:4:12:1:Manche à pointes qiraji
22011:3:4:65:Manchettes de belluaire
20928:4:12:1:Manchettes de commandement qiraji
20932:4:12:1:Manchettes de domination qiraji
19595:4:4:65:Manchettes de dryade
19596:4:4:55:Manchettes de dryade
19597:4:4:45:Manchettes de dryade
22519:4:4:88:Manchettes de foi
22503:4:4:88:Manchettes de givrefeu
22511:4:4:88:Manchettes de pestecoeur
22095:3:4:65:Manchettes des Cinq tonnerres
22063:3:4:65:Manchettes du sorcier
22369:4:15:60:Manchettes désacralisées
286737:1:4:8:Manchettes d’Avala
4969:1:4:10:Manchettes fortifiées
19716:4:12:1:Manchettes primordiales hakkari
275390:2:4:59:Manchettes superficielles
20403:2:15:60:Mandataire de Nozdormu
281274:2:2:11:Mande-foudre improvisé
20031:1:0:65:Mangue d'essence
16454:4:4:71:Manicles de maréchal en cuir
272763:4:4:65:Manicles de qualité de lieutenant-commandant en cuir
6722:2:4:30:Maniques bestiales
3560:2:4:35:Mantelet d'honneur
19845:4:4:61:Mantelet d'illusionniste zandalar
21335:4:4:78:Mantelet d'implorateur funeste
19835:4:4:61:Mantelet d'insensé zandalar
22016:3:4:65:Mantelet de belluaire
16507:3:4:63:Mantelet de champion en cuir
23262:3:4:71:Mantelet de champion en satin
23264:3:4:71:Mantelet de champion en soie
19841:4:4:68:Mantelet de confesseur zandalar
16995:2:4:60:Mantelet de Crépuscaile
19849:4:4:61:Mantelet de démoniaque zandalar
2913:2:4:28:Mantelet de Gamn en soie
17604:4:4:74:Mantelet de grand maréchal en satin
18182:2:12:60:Mantelet de l'Aube chromatique
18169:2:12:60:Mantelet de l'Aube de flammes
18170:2:12:60:Mantelet de l'Aube de givre
18173:2:12:60:Mantelet de l'Aube de l'ombre
18172:2:12:60:Mantelet de l'Aube de la nature
18171:2:12:60:Mantelet de l'Aube des arcanes
21350:4:4:78:Mantelet de l'oracle
15784:2:4:59:Mantelet de la brise cristalline
23324:1:4:1:Mantelet de la fête du Feu
281538:2:4:59:Mantelet de la matriarche
23317:3:4:71:Mantelet de lieutenant-commandant en satin
23319:3:4:71:Mantelet de lieutenant-commandant en soie
17569:3:4:63:Mantelet de lieutenant-commandant en tisse-effroi
19831:4:4:68:Mantelet de prédateur zandalar
244229:1:4:1:Mantelet de pêche
272574:4:4:65:Mantelet de qualité de général en satin
272558:4:4:65:Mantelet de qualité de général en tisse-gangrène
273433:4:4:65:Mantelet de qualité de général soyeux
272680:3:4:60:Mantelet de qualité de magus
272820:4:4:65:Mantelet de qualité de maréchal en étoffe du Vide
273423:4:4:65:Mantelet de qualité de maréchal en étoffe lunaire
272475:3:4:60:Mantelet de qualité en pelombre
272801:3:4:60:Mantelet de qualité en tisse-effroi
272678:3:4:60:Mantelet de qualité en étoffe lunaire
272650:3:4:60:Mantelet de qualité soyeux
17622:4:4:74:Mantelet de seigneur de guerre en satin
17590:4:4:74:Mantelet de seigneur de guerre en tisse-effroi
21665:4:4:77:Mantelet de vengeance cruelle
5820:2:4:32:Mantelet des fées
11874:2:4:56:Mantelet des nuages
22068:3:4:65:Mantelet du sorcier
16739:2:4:48:Mantelet en bois d'acacia
4140:2:4:34:Mantelet en feuille de palmier
22968:4:4:83:Mantelet glacial
22073:3:4:65:Mantelet Mortebrume
5274:2:4:27:Mantelet rose
21694:4:4:75:Mantelet ternaire
281275:2:4:50:Mantelet tueur d’écailles
6664:2:4:26:Mantelet vaudou
22082:3:4:65:Mantelet vertueux
270046:2:4:30:Mantelet éthérien
6619:1:9:10:Manuel : La voie de la défense
6897:1:9:30:Manuel : La voie du berserker
16642:1:12:1:Manuel d'utilisation du Déchiqueteur - Chapitre 1
16643:1:12:1:Manuel d'utilisation du Déchiqueteur - Chapitre 2
16644:1:12:1:Manuel d'utilisation du Déchiqueteur - Chapitre 3
5088:1:12:1:Manuel de la console de contrôle
6621:1:9:10:Manuel de provocation
209847:1:5:25:Manuel des systèmes arcaniques
10832:1:12:1:Manuel du propriétaire du gangrechien traqueur
211777:1:15:1:Manuscrit naga
22320:1:15:1:Marchandises premier choix de Mux
20560:2:0:1:Marque d'honneur de la vallée d'Alterac
19322:2:12:1:Marque d'honneur des Chanteguerres
20559:2:0:1:Marque d'honneur du bassin d'Arathi
20558:2:0:1:Marque d'honneur du goulet des Chanteguerres
19858:2:12:1:Marque d'honneur zandalar
22732:4:4:88:Marque de C'Thun
21508:2:12:1:Marque de Cénarius
19588:4:4:65:Marque de héros
23195:1:0:60:Marque de l'Aube
23194:1:0:60:Marque de l'Aube inférieure
23196:1:0:60:Marque de l'Aube supérieure
21515:2:12:1:Marque de Remulos
17759:2:4:60:Marque de résolution
20646:2:2:59:Marque de trotteur des sables
12844:2:12:1:Marque de valeur de l'Aube d'argent
211814:2:12:1:Marque de voltigeur chanteguerre
23206:4:4:90:Marque du champion
23207:4:4:90:Marque du champion
19579:2:4:60:Marque du païen
19585:3:4:60:Marque du païen
19586:3:4:68:Marque du païen
274895:2:0:1:Marque d’honneur des îles des Sombrelances
263435:2:4:10:Marque d’Urs’endris
15692:2:2:38:Marqueur de kodo
270071:2:2:40:Marteau au cœur noir
15464:2:2:28:Marteau brutal
1009:2:2:13:Marteau compact
18867:4:2:78:Marteau d'armes de connétable
6968:2:2:15:Marteau d'Elunite
8708:4:2:50:Marteau d'expertise
6983:2:2:15:Marteau d'Haggard
5324:2:2:16:Marteau d'ingénieur
11120:2:2:55:Marteau de Belgrom
5595:1:2:11:Marteau de bois
260209:2:2:55:Marteau de Chantevrai
281586:3:2:60:Marteau de chantier de Sylvancienne
248005:2:2:12:Marteau de Comté-du-Nord
2048:1:2:5:Marteau de Courbenclume
22380:3:2:65:Marteau de culture de Simona
5322:2:2:26:Marteau de démolition
285281:3:2:54:Marteau de forgeron en arcanite
285280:2:2:39:Marteau de forgeron en mithril
285279:2:2:22:Marteau de forgeron fêlé
20580:4:2:71:Marteau de fureur bestiale
23454:4:2:78:Marteau de guerre de connétable
5579:1:2:5:Marteau de guerre de la milice
272857:4:2:65:Marteau de guerre de qualité de connétable
21268:4:2:79:Marteau de guerre qiraji béni
4548:2:2:41:Marteau de guerre servomécanique
7117:2:2:15:Marteau de l'héritier
5580:1:2:5:Marteau de la milice
1480:2:2:17:Marteau de la milice du peuple
21398:4:2:70:Marteau de la tempête imminente
4978:2:2:36:Marteau de Ryedol
21410:4:2:70:Marteau de sagesse infinie
4971:2:2:12:Marteau de Skorn
17003:2:2:61:Marteau de Skullstone
271766:3:2:33:Marteau de soulèvement
270088:2:2:45:Marteau de thane
6976:3:2:40:Marteau de tourbillon
9240:2:12:1:Marteau de Zul'Farrak
4511:2:2:40:Marteau des Flots noirs
3103:2:2:12:Marteau des Frigères
272848:4:2:65:Marteau d’armes de qualité de connétable
5345:2:2:14:Marteau en bois de fer
20648:3:2:63:Marteau forgé à froid
19104:3:2:65:Marteau foudrepique
263314:2:2:10:Marteau à toiture
257276:1:2:5:Marteau-pioche de garde-paix
9651:2:2:53:Marteau-tempête des chevaucheurs de gryphon
277244:3:2:45:Marteleurs de garde
21612:4:4:81:Marteleurs en écailles de ver
20566:1:4:1:Masque d'humain fragile
20565:1:4:1:Masque d'humaine fragile
20570:1:4:1:Masque d'orc fragile
20569:1:4:1:Masque d'orque fragile
20392:1:4:1:Masque de gnome fragile (F)
20391:1:4:1:Masque de gnome fragile (H)
16455:4:4:74:Masque de grand maréchal en cuir
20573:1:4:1:Masque de mort-vivant fragile
20574:1:4:1:Masque de morte-vivante fragile
20561:1:4:1:Masque de nain fragile
20562:1:4:1:Masque de naine fragile
272764:4:4:65:Masque de qualité de grand maréchal en cuir
20572:1:4:1:Masque de tauren fragile
20571:1:4:1:Masque de taurène fragile
7953:2:4:42:Masque de Thero-shan
20568:1:4:1:Masque de troll fragile
20567:1:4:1:Masque de trollesse fragile
20563:1:4:1:Masque fragile d’Elfe de la nuit (femme)
20564:1:4:1:Masque fragile d’Elfe de la nuit (homme)
22074:4:4:60:Masque Mortebrume
23464:4:2:78:Masse d'armes de grand seigneur de guerre
6982:2:2:15:Masse d'Umbral
5761:1:2:5:Masse de Courbenclume
1382:1:2:5:Masse de pierre
7328:2:2:15:Masse de Thun'grim
21407:4:2:70:Masse de vie interminable
272681:4:2:65:Masse d’armes de qualité de grand seigneur de guerre
281254:2:2:17:Masse d’envahisseur
4948:2:2:11:Masse hérissée
270108:2:2:50:Masse longue ensanglantée
271804:3:2:42:Masse écrase-âmes
18866:4:2:78:Massue de grand seigneur de guerre
269025:2:12:1:Mastic de cérémonie
260212:3:4:56:Mauvais chapeau
18706:2:4:40:Maître de l'arène
260166:2:2:52:Meilleure massue de Hurlerage
276722:2:4:24:Menottes de Gnoll
210967:1:15:1:Message confidentiel
274974:2:15:1:Message dans une bouteille
281330:1:12:35:Message de l’archimagistère
209029:1:15:1:Message d’Émilie
213378:2:7:40:Microfilament instable
9644:2:4:51:Minuteur thermostatique
277844:2:4:40:Miroir du mirage
278744:2:12:40:Miroir du mirage
269773:1:12:1:Missive du Crépuscule
265476:1:12:1:Missive déchirée
219930:1:12:1:Missive sanglante
18838:4:2:78:Miséricorde de connétable
272843:4:2:65:Miséricorde de qualité de connétable
16560:4:4:71:Mitaines de général en cuir
272525:4:4:65:Mitaines de qualité de champion en pelombre
274745:2:4:35:Mitaines de récure-pont
1479:1:4:12:Mitaines de Salma
270086:2:4:43:Mitaines d’Ogre surdimensionnées
10550:1:4:12:Mitaines en laine
277094:1:4:14:Mitaines zéphrali
272314:1:12:1:Mixture neutralisante
22344:1:15:1:Mode d'emploi du brasero d'invocation
18146:1:12:60:Mojo de troll darkspear
276199:3:4:1:Monocle d’arrogance
281020:2:4:8:Monstre – bouclier, Éolide (blanc)
277555:2:4:8:Monstre – bouclier, Éolide (gris)
239688:3:2:44:Monstre – Lance 2M – Cavalier écarlate – Lance
239618:3:2:44:Monstre – Épée 1M – Épée de vainqueur (Alt)
216633:1:12:1:Montant hydraulique en vrai-argent
16343:1:15:40:Monture de garde de sang
16344:1:15:60:Monture de lieutenant-général
20221:5:15:60:Monture fabuleuse
225943:1:15:1:Morceau de chair rance
271870:1:15:1:Morceau de charbon
11512:1:12:1:Morceau de peau contaminée
231903:1:12:79:Morceau d’étoffe déchirée
207107:1:0:1:Morceau inférieur droit de carte
208037:1:0:1:Morceau inférieur droit de carte
208218:1:0:1:Morceau inférieur droit de carte
208603:1:0:1:Morceau inférieur droit de carte
207106:1:0:1:Morceau inférieur gauche de carte
208038:1:0:1:Morceau inférieur gauche de carte
208219:1:0:1:Morceau inférieur gauche de carte
208604:1:0:1:Morceau inférieur gauche de carte
207109:1:0:1:Morceau supérieur droit de carte
208035:1:0:1:Morceau supérieur droit de carte
208213:1:0:1:Morceau supérieur droit de carte
208601:1:0:1:Morceau supérieur droit de carte
207108:1:0:1:Morceau supérieur gauche de carte
208036:1:0:1:Morceau supérieur gauche de carte
208215:1:0:1:Morceau supérieur gauche de carte
208602:1:0:1:Morceau supérieur gauche de carte
17422:1:12:1:Morceaux d'armures
22348:3:2:65:Mortulus prime
21164:2:15:35:Morue rochécaille boursouflée
219448:1:12:40:Moteur onirique
267137:1:12:1:Moulage krol’dok
267138:1:12:1:Moulage krol’dok
5309:2:2:20:Mousquet de corsaire
12446:1:2:5:Mousquet de Courbenclume
21272:4:2:79:Mousquet qiraji béni
277979:2:2:44:Mouton de marteleur
271810:3:4:43:Mue de Nécrobi
254001:3:4:35:Mules ambrées
252424:3:4:15:Mules de dragonnet noir
270104:2:4:50:Mules de marchepierre
11508:1:4:1:Mules de maître de jeu
263339:2:4:13:Mules de Souffle-Bise
254009:3:4:35:Mules dorées
254005:3:4:35:Mules embrasées
254007:3:4:35:Mules noires
254011:3:4:35:Mules radieuses
254003:3:4:35:Mules écumeuses
274388:4:6:65:Munitions de frappe rapide
221518:3:2:53:Murmure
20645:2:4:60:Murmure de la nature
17626:1:12:1:Muselière de loup des glaces
227796:1:0:60:Mystérieux parchemin « darnassien »
227797:1:0:60:Mystérieux parchemin « darnassien »
13325:3:15:40:Mécanotrotteur vert fluorescent
17504:1:12:1:Médaille de commandant loup-de-givre
17503:1:12:1:Médaille de lieutenant loup-de-givre
17502:1:12:1:Médaille de soldat loup-de-givre
15799:2:4:58:Médaille de valeur héroïque
15704:2:4:60:Médaille des chasseurs
17111:4:4:68:Médaillon Blazefury
11196:2:4:57:Médaillon d'explosion mentale
16623:2:4:57:Médaillon d'opaline
22139:1:12:1:Médaillon d'Ysida
19534:3:4:63:Médaillon d'éclaireur
19535:3:4:53:Médaillon d'éclaireur
19536:3:4:43:Médaillon d'éclaireur
19537:3:4:33:Médaillon d'éclaireur
20442:3:4:23:Médaillon d'éclaireur
12585:1:15:65:Médaillon de Hurlevent
19949:4:4:68:Médaillon de héros zandalarien
22659:4:4:60:Médaillon de l'Aube
281321:3:4:32:Médaillon de pierre des géants
19538:3:4:63:Médaillon de sentinelle
19539:3:4:53:Médaillon de sentinelle
19540:3:4:43:Médaillon de sentinelle
19541:3:4:33:Médaillon de sentinelle
20444:3:4:23:Médaillon de Sentinelle
19383:4:4:83:Médaillon du Maître-tueur de dragon
221370:1:15:1:Médaillon précieux
270275:2:4:51:Médaillon vilebranche purifié
19040:2:2:48:Méga-trancheur de Zorbin
216619:2:0:33:Mélange étudiant
23034:4:4:83:Nax PH Crit Plate Shoulders
19997:1:0:55:Nectar de la moisson
20398:1:0:1:Ninja
3822:2:2:32:Noirâtre runique
205864:1:15:1:Note calcinée
207098:1:15:1:Note de Ba’so
203723:1:15:1:Note de Cutty
5174:1:12:1:Note de Neeru
208205:1:15:1:Note de Ratnoir
205184:1:15:1:Note d’acolyte
208224:1:15:1:Note d’acolyte
212748:2:15:30:Note en lambeaux
272319:2:12:30:Note en lambeaux
16790:1:15:17:Note humide
213421:1:15:1:Note roussie
228144:1:12:50:Note étrange
208183:2:15:10:Notes de l’apothicaire
225954:2:15:60:Notes de sort calcinées
225938:2:15:60:Notes de sort déchirées
225939:2:15:60:Notes de sort déchirées
225940:2:15:60:Notes de sort déchirées
225941:2:15:60:Notes de sort déchirées
208854:2:15:10:Notes de sort mâchonnées
213632:2:15:10:Notes de sort partielles
213633:2:15:10:Notes de sort partielles
213634:2:15:10:Notes de sort partielles
211691:2:0:25:Notes de sorts : Déflagration des arcanes
211514:2:0:25:Notes de sorts : Régénération de masse
209028:2:15:10:Notes de sort : ABOTM BEIVEVN
203751:2:15:10:Notes de sort : ALEEV DJEG LTACO
235599:2:0:1:Notes de sort : Anomalie temporelle
221480:2:0:50:Notes de sort : Armure de la fournaise
213112:2:0:40:Notes de sort : Barrage de projectiles
225689:2:0:60:Notes de sort : Barrage des arcanes
208799:2:0:10:Notes de sort : Bombe vivante
235597:2:0:1:Notes de sort : Congélation
203747:2:9:10:Notes de sort : Doigts de givre
203746:2:9:10:Notes de sort : Flamme vivante
203753:2:15:10:Notes de sort : GDDOT EG IEVSIR
208853:2:9:10:Notes de sort : Gel mental
203749:2:9:10:Notes de sort : Illumination
210179:2:15:10:Notes de sort : ILMEGAI SARRBES
203748:2:9:10:Notes de sort : Incandescence
203745:2:9:10:Notes de sort : Javelot de glace
210655:2:15:10:Notes de sort : MPERORENT LS ETME
208754:2:15:10:Notes de sort : NIGÉO NÉRÉRAT
225690:2:0:60:Notes de sort : Orbe gelé
221487:2:0:50:Notes de sort : Protection avancée
210654:2:9:25:Notes de sort : Remonter le temps
208753:2:9:10:Notes de sort : Régénération
225691:2:0:60:Notes de sort : Surchauffe
223147:2:0:50:Notes de sort : Trait de bûcher
203752:2:15:10:Notes de sort : VALAFM EVNTMIE
235598:2:0:1:Notes de sort : Veines glaciales
211386:2:9:25:Notes de sort : Éruption d’arcanes
219519:1:12:50:Notes du gardien fou
204864:2:15:10:Notes d’apprenti Azora
213127:1:15:10:Notes mystiques partielles
6996:1:12:1:Notes sur les armes de Jordan
267454:1:12:1:Notes sur les armes de Trevan
235899:1:12:1:Noyau corrompu
216636:1:12:1:Noyau du Vide chargé
216635:2:12:1:Noyau du Vide épuisé
225675:1:15:1:Noyau d’obsidienne couvert de suie
225676:1:15:1:Noyau d’obsidienne en fusion
276423:1:15:1:Noyau d’élémentaire instable
209058:1:15:1:Noyau élémentaire
20644:4:12:63:Objet noyé dans les cauchemars
21221:4:12:60:Oeil de C'Thun
23001:4:4:85:Oeil de diminution
11753:1:12:1:Oeil de Kajal
4903:1:12:4:Oeil de l'ombre ardente
21473:3:4:74:Oeil de Moam
2943:2:4:31:Oeil de Paleth
17204:5:7:60:Oeil de Sulfuras
23047:4:4:90:Oeil du mort
8564:1:12:1:Oeuf d'hippogryphe
19462:1:15:35:Oeuf de jubelin
20651:1:15:20:Oeuf de murloc orange
11110:1:15:1:Oeuf de poule
8643:1:12:1:Oeuf extraordinaire
11471:1:12:1:Oeuf fragile de Fée fléchetteuse
11102:1:12:1:Oeuf non-éclos de Fée fléchetteuse
8645:1:12:1:Oeuf ordinaire
8646:1:12:1:Oeuf pourri
12144:1:13:1:Oeufilloscope
211482:1:13:1:Offrande Briselance
217720:1:15:1:Offrande de chair
217721:1:15:1:Offrande d’os
221262:2:15:45:Offrande sauvage
213737:1:12:1:Offrande à l’esprit du vent
5331:1:15:1:OLDBlackfathom MAGIC Relic
4704:1:2:1:OLDCeremonial Club
5410:1:2:1:OLDCeremonial Club
22638:3:15:60:Ombregarde
18595:2:0:1:Opale de sang
21185:4:4:62:Orbe calme-terre
10831:1:12:1:Orbe corrompu
10708:2:4:52:Orbe Crânesort
7515:3:4:40:Orbe céleste
11870:2:4:54:Orbe d'oubli
281291:3:4:21:Orbe de canalisation de Mathystra
249394:3:4:30:Orbe de clairvoyance mystique
191268:2:0:1:Orbe de corruption
15108:3:4:40:Orbe de Dar'Orahil
210765:1:12:1:Orbe de Des
12805:2:4:46:Orbe de feu
11859:2:4:45:Orbe de jadelune
7508:2:4:10:Orbe de Ley
15107:3:4:40:Orbe de Noh'Orahil
260208:2:4:55:Orbe de prélat
19426:4:4:65:Orbe de Sombrelune
6898:3:4:25:Orbe de Soran'ruk
277661:1:12:1:Orbe de tempête émoussé
4125:2:4:46:Orbe de tranquillité
7507:2:4:10:Orbe des arcanes
249395:3:4:30:Orbe des âmes
19366:4:4:83:Orbe du Maître-tueur de dragon
10709:2:4:55:Orbe funéraire
272180:2:2:43:Ordre de magistère spectral
21143:1:12:60:Ordre de mission non signé
23024:1:12:1:Ordre de mission préparé
20810:1:12:1:Ordre de mission signé
17353:1:12:1:Ordres d'assaut de Foudrepique
17442:1:12:1:Ordres d'assaut du clan Loup-de-Givre
281629:1:12:1:Ordres de patrouille
21159:1:12:60:Ordres de reconnaissance de la Ruche'Zora
215468:1:12:1:Ordres du grand croisé
12780:1:12:1:Ordres du général Drakkisath
12563:1:12:1:Ordres du seigneur de guerre Goretooth
258771:1:15:1:Oreille de sectateur al’aketh
18951:2:4:50:Oreiller d'atterrissage d'Evonice
18950:1:12:1:Oreiller de Pillaclencher
277980:2:4:44:Os d’Ogre
277714:3:15:1:Ourson spectral
275698:2:2:58:Outil de réparation de Yaely
5060:1:15:15:Outils de voleur
7872:1:7:15:Outils de voleur rouillés
278049:1:12:1:Outils d’excavation
280614:3:15:20:Pachimari
286756:4:15:60:Pack de loup spectral
277115:1:1:1:Pack de minage d’apprenti
281356:1:15:1:Page brûlée
281347:1:15:1:Page déchirée
203756:2:15:10:Page 1 des notes d’apprenti Azora
203960:2:15:10:Page 2 des notes d’apprenti Azora
203961:2:15:10:Page 3 des notes d’apprenti Azora
203962:2:15:10:Page 4 des notes d’apprenti Azora
23160:1:0:55:Pain de l'amitié
19696:1:0:55:Pain de la moisson
282018:1:0:1:Pain revitalisant
16338:1:15:40:Palefroi de chevalier-lieutenant
16339:1:15:60:Palefroi de commandant
191480:4:15:60:Palefroi squelettique
18776:4:15:60:Palomino rapide
279939:1:1:5:Panier de collecte
19035:2:15:50:Panier de pique-nique spécial de Lard
270883:2:15:1:Panneau de couture
270879:2:15:1:Panneau de cuisine
270878:2:15:1:Panneau de forge
270882:2:15:1:Panneau de travail du cuir
270877:2:15:1:Panneau d’alchimie
270868:3:15:1:Panneau d’artisanat nain
270870:3:15:1:Panneau d’artisanat orc
270880:2:15:1:Panneau d’enchantement
270881:2:15:1:Panneau d’ingénierie
21042:1:15:1:Panoplie spéciale de Narain
11195:2:4:57:Pansière de guerre
6721:2:4:24:Pansière de Kor
272782:4:4:65:Pansière de qualité de grand maréchal de chevalerie
273331:4:4:65:Pansière de qualité de grand maréchal lumineuse
274238:4:4:65:Pansière de qualité de seigneur de guerre en écailles
277237:2:4:45:Pansière inspirante
16473:4:4:74:Pansière lamellaire de grand maréchal
274252:4:4:65:Pansière lamellaire de qualité de seigneur de guerre
21336:4:4:81:Pantalon d'implorateur funeste
5941:1:4:11:Pantalon d'écailles de cuivre
252500:3:4:25:Pantalon de bagarreur en cuir
22017:3:4:66:Pantalon de belluaire
1832:2:4:17:Pantalon de chance
16414:3:4:63:Pantalon de chevalier-capitaine en soie
252502:3:4:25:Pantalon de chevaucheur de tempête en cuir
252445:3:4:25:Pantalon de défenseur en cuir
2238:1:4:10:Pantalon de gavroche
16534:4:4:71:Pantalon de général en soie
17593:4:4:71:Pantalon de général en tisse-effroi
263409:1:4:5:Pantalon de jardinage
21352:4:4:81:Pantalon de l'oracle
5016:2:4:35:Pantalon de l'ouvrier
21356:4:4:81:Pantalon de la genèse
22745:2:4:1:Pantalon de la Voile sanglante
16502:3:4:63:Pantalon de légionnaire en peau de dragon
17611:3:4:63:Pantalon de légionnaire en satin
16490:3:4:63:Pantalon de légionnaire en soie
17603:4:4:71:Pantalon de maréchal en satin
3578:2:4:15:Pantalon de moissonneur
263330:2:4:13:Pantalon de pisteur
272561:4:4:65:Pantalon de qualité de général en tisse-gangrène
272458:3:4:60:Pantalon de qualité de magus
272819:4:4:65:Pantalon de qualité de maréchal en étoffe du Vide
273422:4:4:65:Pantalon de qualité de maréchal en étoffe lunaire
10549:2:4:12:Pantalon de Rancher
6282:2:4:32:Pantalon de rituel funéraire
20705:3:4:63:Pantalon de réserviste cénarien
20707:3:4:63:Pantalon de réserviste cénarien
20706:3:4:63:Pantalon de réserviste cénarien
252503:3:4:25:Pantalon de sagesse en cuir
22749:4:4:65:Pantalon de sentinelle en cuir
22750:4:4:65:Pantalon de sentinelle en peau de lézard
1310:2:4:20:Pantalon de Smith
252501:3:4:25:Pantalon de trappeur en cuir
2954:2:4:33:Pantalon de veilleur
22740:4:4:65:Pantalon de voltigeur en cuir
22741:4:4:65:Pantalon de voltigeur en peau de lézard
6737:2:4:35:Pantalon des feuilles sèches
4505:2:4:31:Pantalon des marécages
6659:2:4:20:Pantalon du scarabée
6713:1:4:5:Pantalon déchiré
270057:2:4:37:Pantalon d’agent de Stromgarde
281283:2:4:11:Pantalon d’aile raccomodée
270122:2:4:55:Pantalon d’hier
2818:2:4:15:Pantalon en cuir étiré
281295:2:4:29:Pantalon en fourrure
270014:2:4:20:Pantalon en peau de daim
270020:2:4:24:Pantalon en peau de Gnoll
281691:2:4:1:Pantalon en tissu restauré
270114:2:4:51:Pantalon en écailles de dragon
281267:2:4:8:Pantalon en écailles de raptor
270083:2:4:42:Pantalon ensanglanté
3457:2:4:18:Pantalon estampillé
5327:2:4:18:Pantalon graisseux d'artisan
6076:1:4:5:Pantalon moulant
61:1:4:5:Pantalon nain en cuir
2237:1:4:10:Pantalon raccommodé
277217:2:4:45:Pantalon recousu
22007:3:4:66:Pantalon Sombremante
252446:3:4:25:Pantalon totémique en cuir
263307:2:4:11:Pantalon trombenoire
257334:1:4:10:Pantalon très usé
277096:1:4:14:Pantalon zéphrali
227931:1:15:1:Paquet caché
273318:1:15:1:Paquet de fournitures de compagnon
273319:1:15:1:Paquet de fournitures d’apprenti
273321:1:15:1:Paquet de fournitures d’artisan
273320:1:15:1:Paquet de fournitures d’expert
8484:1:15:1:Paquet de la Co. des eaux Gadgetzan
281041:1:15:1:Paquet d’herbes
17727:1:15:1:Paquet-cadeau de Gourmandises Fumebois
9363:1:15:1:Paquet-cadeau du Décapeur
20231:1:0:1:Paquetage amélioré d'Arathor
20228:1:0:1:Paquetage amélioré de Profanateur
19152:1:0:1:Paquetage amélioré de sentinelle
285173:1:0:1:Paquetage amélioré de Sombrelance
285170:1:0:1:Paquetage amélioré de Theramore
19153:1:0:1:Paquetage amélioré de voltigeur
20233:1:0:1:Paquetage de base d'Arathor
20229:1:0:1:Paquetage de base de Profanateur
19150:1:0:1:Paquetage de base de sentinelle
285171:1:0:1:Paquetage de base de Sombrelance
285168:1:0:1:Paquetage de base de Theramore
19154:1:0:1:Paquetage de base de voltigeur
172070:1:15:1:Paquetage du service client
281680:2:15:60:Paquetage du service client
20236:1:0:1:Paquetage ordinaire d'Arathor
20230:1:0:1:Paquetage ordinaire de Profanateur
19151:1:0:1:Paquetage ordinaire de sentinelle
285172:1:0:1:Paquetage ordinaire de Sombrelance
285169:1:0:1:Paquetage ordinaire de Theramore
19155:1:0:1:Paquetage ordinaire de voltigeur
10684:1:0:25:Parachute colossal
272011:1:15:1:Paratonnerre ogre activé
277484:1:0:25:Parchemin de distraction de bête
231298:2:0:10:Parchemin de guérison spatiale mineure
223171:2:0:45:Parchemin de géomancie
217496:3:0:40:Parchemin de la lame
19343:4:4:76:Parchemin de lumière aveuglante
213550:1:0:25:Parchemin de métamorphose : melon étrange
211957:2:0:25:Parchemin de pouvoir des Arcanes I
211955:2:0:25:Parchemin de protection arcanique : feu I
211956:2:0:25:Parchemin de protection arcanique : givre I
211954:2:0:25:Parchemin de précision des arcanes I
277504:3:0:55:Parchemin de présence d’esprit
211953:2:0:25:Parchemin de récupération arcanique I
277491:1:0:40:Parchemin de réprimande d’élémentaires
12730:1:12:1:Parchemin de Warosh
10818:1:12:50:Parchemin de Yeh'kinya
281349:1:15:1:Parchemin des ténèbres
281348:1:15:1:Parchemin du chaos
277490:3:0:25:Parchemin du sabre
3706:1:12:30:Parchemin ensorcelé
9370:1:12:38:Parchemin Gordunni
217161:1:15:40:Parchemin mystique déchiré
10621:1:0:15:Parchemin runique
273658:1:15:23:Parchemin taché de sang
209848:1:5:25:Parchemins de Goaz
229897:1:15:1:Parchemin : Création d’une chevalière de signal
230903:4:12:71:Parchemin : essence de feu
230947:4:12:71:Parchemin : essence de givre
231304:4:12:71:Parchemin : NOGRIÉSU ESAPILATE ERUMINE
230946:4:12:71:Parchemin : SEENECS ED VIREG
13158:1:12:1:Paroles du Grand Chef
210667:1:12:25:Particule de rage infernale
210668:1:12:25:Particule de rage sismique
210665:1:12:25:Particule de rage torrentielle
274800:1:12:55:Partie de pêche
209608:1:13:1:Passe-partout du capitaine
281292:3:4:21:Patience d’Onu
7613:1:9:31:Patron : Armure verte en cuir
5788:2:9:34:Patron : Armure épaisse de murloc
15756:1:9:58:Patron : Bandeau runique en cuir
19327:1:9:64:Patron : Batailleurs grumegueules
19216:1:9:58:Patron : Bottes de l'Aube d'argent
18515:3:9:62:Patron : Bottes de la mangouste
15740:1:9:55:Patron : Bottes de sabre-de-givre
17022:1:9:59:Patron : Bottes du Magma
8406:2:9:49:Patron : Bottes en cuir sauvage
19766:1:9:65:Patron : Bottes en vignesang
17025:1:9:60:Patron : Bottes en écailles de dragon noir
14488:1:9:56:Patron : Bottes en étoffe runique
7451:2:9:38:Patron : Brassards de dragonnet vert
18516:3:9:62:Patron : Brassards de vol rapide
19771:1:9:65:Patron : Brassards en peau de chauve-souris primordiale
5789:2:9:38:Patron : Brassards en écailles de murloc
15724:1:9:51:Patron : Brassards en écailles de scorpide épaisses
7089:1:9:35:Patron : Cape azur en soie
7087:1:9:36:Patron : Cape cramoisie en soie
14486:3:9:55:Patron : Cape de Feu
18418:3:9:62:Patron : Cape de sauvegarde
8408:2:9:50:Patron : Cape en cuir sauvage
14472:1:9:53:Patron : Cape en étoffe runique
14630:1:9:33:Patron : Capuche d'enchanteur
17023:1:9:60:Patron : Casque de la fournaise
8405:2:9:45:Patron : Casque en cuir sauvage
19333:1:9:70:Patron : Ceinture de la fournaise
19330:1:9:66:Patron : Ceinture de lave
19332:1:9:70:Patron : Ceinture du Magma
5786:1:9:18:Patron : Ceinture en écailles de murloc
18514:3:9:62:Patron : Ceinturon de clairvoyance
14627:1:9:27:Patron : Chemise jaune vif
10728:1:9:40:Patron : Chemise noire de bretteur
6401:1:9:31:Patron : Chemise noire en soie
22773:1:9:70:Patron : Couronne sylvestre
19772:1:9:65:Patron : Cuirasse du tigre-sang
15730:3:9:61:Patron : Cuirasse en écailles de dragon rouge
5787:1:9:19:Patron : Cuirasse en écailles de murloc
19328:1:9:58:Patron : Demi-bottes de l'aube
19217:1:9:64:Patron : Epaulières de l'Aube d'argent
8409:2:9:42:Patron : Epaulières de la nuit
19773:1:9:65:Patron : Epaulières du tigre-sang
8403:2:9:44:Patron : Epaulières en cuir sauvage
22772:1:9:70:Patron : Epaulières sylvestres
7362:1:9:27:Patron : Epaulières terrestres en cuir
14526:1:9:55:Patron : Etoffe lunaire
22683:1:9:70:Patron : Etreinte de Gaïa
19331:1:9:70:Patron : Gantelets chromatiques
15725:1:9:52:Patron : Gantelets corrompus en cuir
7114:1:9:29:Patron : Gants azur en soie
15729:1:9:53:Patron : Gants chimériques
17018:1:9:62:Patron : Gants Coeur-de-braise
18416:3:9:62:Patron : gants d'Inferno
18415:3:9:62:Patron : Gants en gangrétoffe
19770:1:9:65:Patron : Gants en peau de chauve-souris primordiale
8385:1:9:41:Patron : Gants en écailles de tortue
18417:3:9:62:Patron : Gants en étoffe lunaire
14481:1:9:55:Patron : Gants en étoffe runique
8404:2:9:45:Patron : Gilet en cuir sauvage
19764:1:9:65:Patron : Gilet en vignesang
22774:1:9:70:Patron : Gilet sylvestre
21723:2:9:50:Patron : Habit de fête
20253:1:9:55:Patron : Harnais de l'ours de guerre
15762:1:9:59:Patron : Heaume en écailles de scorpide épaisses
19765:1:9:65:Patron : Jambières  en vignesang
5973:1:9:34:Patron : Jambières barbares
19220:1:9:70:Patron : Jambières Coeur-de-braise
20254:1:9:57:Patron : Jambières de l'ours de guerre
8407:2:9:50:Patron : Jambières en cuir sauvage
17017:1:9:61:Patron : Mantelet Coeur-de-braise
19218:3:9:64:Patron : Mantelet des Grumegueules
19329:1:9:64:Patron : Mantelet doré de l'Aube
14483:1:9:55:Patron : Pantalon en gangrétoffe
19769:1:9:65:Patron : Pourpoint en peau de chauve-souris primordiale
19326:1:9:58:Patron : Pouvoir des Grumegueules
18252:3:9:60:Patron : Renfort d'armure du Magma
19219:1:9:66:Patron : Robe Coeur-de-braise
7088:1:9:41:Patron : Robe cramoisie en soie
21722:2:9:50:Patron : Robe de fête
14493:3:9:57:Patron : Robe de la nuit hivernale
14469:1:9:52:Patron : Robe en étoffe runique
22310:1:9:55:Patron : Sac d'herbes cénarien
22312:1:9:65:Patron : Sacoche de Cénarius
19215:1:9:58:Patron : Sagesse des Grumegueules
275595:3:9:1:Patron : agrippeurs de garde-couvée
275592:3:9:1:Patron : agrippeurs de tripécaille
215368:3:9:40:Patron : Arcano-filament hyperconducteur
252883:2:9:58:Patron : armure en suédine bleue
252877:2:9:56:Patron : armure ouvragée en cuir
211247:2:9:30:Patron : Bandages du phénix
253900:3:9:17:Patron : bottes brillantes
274011:4:9:1:Patron : bottes cœur-de-démon
252786:3:9:22:Patron : bottes de bagarreur en cuir
252790:3:9:22:Patron : bottes de chevaucheur de tempête en cuir
275588:3:9:1:Patron : bottes de cloque-bilieuse
273995:4:9:1:Patron : bottes de conviction
252788:3:9:22:Patron : bottes de défenseur en cuir
252861:3:9:52:Patron : bottes de furtivité en cuir
273975:4:9:1:Patron : bottes de fuse-mana
252862:3:9:52:Patron : bottes de garde en cuir
273963:4:9:1:Patron : bottes de gardien du bosquet
227896:1:9:58:Patron : Bottes de l’Aube d’argent
252863:3:9:52:Patron : bottes de mande-ciel en cuir
276545:4:9:1:Patron : bottes de mande-esprit
252860:3:9:52:Patron : bottes de rôdeur en cuir
275591:3:9:1:Patron : bottes de saccage-essaim
252791:3:9:22:Patron : bottes de sagesse en cuir
252864:3:9:52:Patron : bottes de soigneur en cuir
252787:3:9:22:Patron : bottes de trappeur en cuir
253894:3:9:17:Patron : bottes des flammes
34262:2:9:1:Patron : Bottes d’hiver
253890:3:9:17:Patron : bottes immaculées
279317:4:9:1:Patron : bottes incrustées de givre
19204:1:9:64:Patron : bottes lourdes grumegueules
253898:3:9:17:Patron : bottes nacrées
253896:3:9:17:Patron : bottes ombreuses
273999:4:9:1:Patron : bottes sombrepoint
253892:3:9:17:Patron : bottes soyeuses
276963:2:9:1:Patron : bottes tisse-souffle azur
276939:2:9:1:Patron : bottes tisse-souffle nuageuses
252789:3:9:22:Patron : bottes totémiques en cuir
276969:2:9:1:Patron : bottillons mêle-vent azur
276945:2:9:1:Patron : bottillons mêle-vent nuageux
273991:4:9:1:Patron : bottines de conviction
275597:3:9:1:Patron : bottines de garde-couvée
273967:4:9:1:Patron : bottines de gardien du bosquet
274003:4:9:1:Patron : bottines de mande-esprit
275594:3:9:1:Patron : bottines de tripécaille
252854:3:9:50:Patron : brassards de furtivité en cuir
252855:3:9:50:Patron : brassards de garde en cuir
252856:3:9:50:Patron : brassards de mande-ciel en cuir
252905:3:9:50:Patron : brassards de mande-ciel en mailles
252853:3:9:50:Patron : brassards de rôdeur en cuir
252857:3:9:50:Patron : brassards de soigneur en cuir
252907:3:9:50:Patron : brassards de soigneur en mailles
252904:3:9:50:Patron : brassards de traqueur en mailles
252906:3:9:50:Patron : brassards d’escarmouche en mailles
276959:2:9:1:Patron : brassards tisse-souffle azur
276935:2:9:1:Patron : brassards tisse-souffle nuageux
274491:2:9:44:Patron : cache-sabots de centaure
215422:4:9:40:Patron : Camail hyperconducteur en écailles lumineux
279319:4:9:1:Patron : cape de la terre et du ciel
276990:2:9:1:Patron : capuche fil-tempête azur
276982:2:9:1:Patron : capuche fil-tempête nuageuse
215152:4:9:40:Patron : Capuche gneuro-liée luminescente
252765:3:9:17:Patron : ceinture de bagarreur en cuir
252769:3:9:17:Patron : ceinture de chevaucheur de tempête en cuir
252767:3:9:17:Patron : ceinture de défenseur en cuir
275596:3:9:1:Patron : ceinture de garde-couvée
252923:3:9:55:Patron : ceinture de mande-ciel en mailles
252770:3:9:17:Patron : ceinture de sagesse en cuir
252925:3:9:55:Patron : ceinture de soigneur en mailles
252766:3:9:17:Patron : ceinture de trappeur en cuir
252922:3:9:55:Patron : ceinture de traqueur en mailles
275593:3:9:1:Patron : ceinture de tripécaille
252924:3:9:55:Patron : ceinture d’escarmouche en mailles
276961:2:9:1:Patron : ceinture tisse-souffle azur
276937:2:9:1:Patron : ceinture tisse-souffle nuageuse
252768:3:9:17:Patron : ceinture totémique en cuir
19202:1:9:58:Patron : ceinture épaisse grumegueule
228319:3:9:62:Patron : Ceinturon de clairvoyance des arcanes
275587:3:9:1:Patron : ceinturon de cloque-bilieuse
275590:3:9:1:Patron : ceinturon de saccage-essaim
215424:4:9:40:Patron : Chaperon antiradiation en écailles
252798:3:9:25:Patron : chaperon de bagarreur en cuir
215423:4:9:40:Patron : Chaperon de canalisation gneuro-conducteur
252802:3:9:25:Patron : chaperon de chevaucheur de tempête en cuir
252800:3:9:25:Patron : chaperon de défenseur en cuir
252803:3:9:25:Patron : chaperon de sagesse en cuir
252799:3:9:25:Patron : chaperon de trappeur en cuir
276986:2:9:1:Patron : chaperon tisse-souffle azur
276978:2:9:1:Patron : chaperon tisse-souffle nuageux
252801:3:9:25:Patron : chaperon totémique en cuir
273952:4:9:1:Patron : chausses de gardien du bosquet
276962:2:9:1:Patron : chausses tisse-souffle azur
276938:2:9:1:Patron : chausses tisse-souffle nuageuses
276975:2:9:1:Patron : chaussures fil-tempête azur
276951:2:9:1:Patron : chaussures fil-tempête nuageuses
279302:4:9:1:Patron : collerette de hors-la-loi
254082:3:9:52:Patron : corde cintrée ambrée
279301:4:9:1:Patron : corde cintrée de Sylvancienne
254090:3:9:52:Patron : corde cintrée dorée
254086:3:9:52:Patron : corde cintrée embrasée
254088:3:9:52:Patron : corde cintrée noire
254092:3:9:52:Patron : corde cintrée radieuse
254084:3:9:52:Patron : corde cintrée écumeuse
275584:3:9:1:Patron : corde de couve-colonie
275581:3:9:1:Patron : corde de crache-venin
276973:2:9:1:Patron : corde fil-tempête azur
276949:2:9:1:Patron : corde fil-tempête nuageuse
279316:4:9:1:Patron : corde imprégnée de mana
276988:2:9:1:Patron : couvre-chef mêle-vent azur
276980:2:9:1:Patron : couvre-chef mêle-vent nuageux
254066:3:9:50:Patron : crispins de flamme-du-Néant
254072:3:9:50:Patron : crispins de lumière-du-Néant
254068:3:9:50:Patron : crispins de perle-du-Néant
254062:3:9:50:Patron : crispins d’or-du-Néant
254070:3:9:50:Patron : crispins d’éclat-du-Néant
254064:3:9:50:Patron : crispins d’écume-du-Néant
254124:2:9:57:Patron : crispins en étoffe runique
276971:2:9:1:Patron : crispins fil-tempête azur
276947:2:9:1:Patron : crispins fil-tempête nuageux
273955:4:9:1:Patron : croquenots de gardien du bosquet
215367:3:9:40:Patron : Cuir faiblement luminescent
253960:3:9:25:Patron : diadème brillant
253954:3:9:25:Patron : diadème des flammes
253950:3:9:25:Patron : diadème immaculé
253958:3:9:25:Patron : diadème nacré
253956:3:9:25:Patron : diadème ombreux
253952:3:9:25:Patron : diadème soyeux
276989:2:9:1:Patron : drapé mêle-vent azur
276981:2:9:1:Patron : drapé mêle-vent nuageux
273994:4:9:1:Patron : espauliers de conviction
273962:4:9:1:Patron : espauliers de gardien du bosquet
279304:4:9:1:Patron : espauliers d’éternité
273965:4:9:1:Patron : gantelets de gardien du bosquet
274005:4:9:1:Patron : gantelets de mande-esprit
273969:4:9:1:Patron : gantelets de traqueur sauvage
253924:3:9:20:Patron : gants brillants
274009:4:9:1:Patron : gants cœur-de-démon
252777:3:9:20:Patron : gants de bagarreur en cuir
252781:3:9:20:Patron : gants de chevaucheur de tempête en cuir
273989:4:9:1:Patron : gants de conviction
275583:3:9:1:Patron : gants de couve-colonie
275580:3:9:1:Patron : gants de crache-venin
252779:3:9:20:Patron : gants de défenseur en cuir
252837:3:9:40:Patron : gants de furtivité en cuir
273973:4:9:1:Patron : gants de fuse-mana
252839:3:9:40:Patron : gants de garde en cuir
252841:3:9:40:Patron : gants de mande-ciel en cuir
276543:4:9:1:Patron : gants de mande-esprit
252836:3:9:40:Patron : gants de rôdeur en cuir
252782:3:9:20:Patron : gants de sagesse en cuir
252842:3:9:40:Patron : gants de soigneur en cuir
252778:3:9:20:Patron : gants de trappeur en cuir
252838:3:9:40:Patron : gants de traqueur en cuir
253918:3:9:20:Patron : gants des flammes
252840:3:9:40:Patron : gants d’escarmouche en cuir
254682:2:9:1:Patron : gants en étoffe-tempête
253914:3:9:20:Patron : gants immaculés
253922:3:9:20:Patron : gants nacrés
253920:3:9:20:Patron : gants ombreux
273997:4:9:1:Patron : gants sombrepoint
253916:3:9:20:Patron : gants soyeux
276960:2:9:1:Patron : gants tisse-souffle azur
276936:2:9:1:Patron : gants tisse-souffle nuageux
252780:3:9:20:Patron : gants totémiques en cuir
276965:2:9:1:Patron : garde-bras mêle-vent azur
276941:2:9:1:Patron : garde-bras mêle-vent nuageux
252820:3:9:30:Patron : garde-jambes de bagarreur en cuir
273960:4:9:1:Patron : garde-jambes de gardien du bosquet
252821:3:9:30:Patron : garde-jambes de trappeur en cuir
273968:4:9:1:Patron : garde-jambes de traqueur sauvage
273993:4:9:1:Patron : garde-mains de conviction
273961:4:9:1:Patron : garde-mains de gardien du bosquet
279306:4:9:1:Patron : garde-mains endeuillés
279305:4:9:1:Patron : garde-poignets de tranquillité
238928:2:9:1:Patron : giberne écarlate
252933:2:9:59:Patron : gilet en écailles de scorpide souples
276970:2:9:1:Patron : gilet fil-tempête azur
276946:2:9:1:Patron : gilet fil-tempête nuageux
275586:3:9:1:Patron : griffes de cloque-bilieuse
275589:3:9:1:Patron : griffes de saccage-essaim
274007:4:9:1:Patron : grèves de mande-esprit
273971:4:9:1:Patron : grèves de traqueur sauvage
276958:2:9:1:Patron : harnais tisse-souffle azur
276934:2:9:1:Patron : harnais tisse-souffle nuageux
253998:3:9:30:Patron : jambières brillantes
274008:4:9:1:Patron : jambières cœur-de-démon
273992:4:9:1:Patron : jambières de conviction
273964:4:9:1:Patron : jambières de gardien du bosquet
274000:4:9:1:Patron : jambières de mande-esprit
252825:3:9:30:Patron : jambières de sagesse en cuir
253992:3:9:30:Patron : jambières des flammes
276974:2:9:1:Patron : jambières fil-tempête azur
276950:2:9:1:Patron : jambières fil-tempête nuageuses
253988:3:9:30:Patron : jambières immaculées
253996:3:9:30:Patron : jambières nacrées
253994:3:9:30:Patron : jambières ombreuses
253990:3:9:30:Patron : jambières soyeuses
252823:3:9:30:Patron : jambières totémiques en cuir
252824:3:9:30:Patron : kilt de chevaucheur de tempête en cuir
252822:3:9:30:Patron : kilt de défenseur en cuir
273956:4:9:1:Patron : kilt de gardien du bosquet
276542:4:9:1:Patron : kilt de mande-esprit
276967:2:9:1:Patron : lanière mêle-vent azur
276943:2:9:1:Patron : lanière mêle-vent nuageuse
273990:4:9:1:Patron : mantelet de conviction
273974:4:9:1:Patron : mantelet de fuse-mana
273958:4:9:1:Patron : mantelet de gardien du bosquet
276544:4:9:1:Patron : mantelet de mande-esprit
227895:1:9:64:Patron : Mantelet doré de l’Aube
273957:4:9:1:Patron : mitaines de gardien du bosquet
276966:2:9:1:Patron : mitaines mêle-vent azur
276942:2:9:1:Patron : mitaines mêle-vent nuageuses
215149:4:9:40:Patron : Monocle gneuro-lié en arcano-filament
273988:4:9:1:Patron : pantalon de conviction
273972:4:9:1:Patron : pantalon de fuse-mana
274004:4:9:1:Patron : pantalon de mande-esprit
279303:4:9:1:Patron : pantalon de Sylvancienne
276968:2:9:1:Patron : pantalon mêle-vent azur
276944:2:9:1:Patron : pantalon mêle-vent nuageux
273996:4:9:1:Patron : pantalon sombrepoint
273953:4:9:1:Patron : poignes de gardien du bosquet
274001:4:9:1:Patron : poignes de mande-esprit
276964:2:9:1:Patron : pourpoint mêle-vent azur
276940:2:9:1:Patron : pourpoint mêle-vent nuageux
228301:3:9:62:Patron : Protège-bras de vol rapide
254030:3:9:40:Patron : protège-mains dorés
254026:3:9:40:Patron : protège-mains embrasés
276972:2:9:1:Patron : protège-mains fil-tempête azur
276948:2:9:1:Patron : protège-mains fil-tempête nuageux
254028:3:9:40:Patron : protège-mains noirs
254032:3:9:40:Patron : protège-mains radieux
254024:3:9:40:Patron : protège-mains écumeux
273954:4:9:1:Patron : protège-épaules de gardien du bosquet
279318:4:9:1:Patron : pèlerine gangrenée
279307:4:9:1:Patron : renfort d’armure en cuir fauve
252941:2:9:50:Patron : renfort d’armure robuste mystique
252833:2:9:1:Patron : renfort d’armure épais mystique
252834:2:9:40:Patron : renfort d’armure épais énergique
253972:3:9:27:Patron : robe brillante
279315:4:9:1:Patron : robe de dévastation ardente
253966:3:9:27:Patron : robe des flammes
253962:3:9:27:Patron : robe immaculée
253970:3:9:27:Patron : robe nacrée
253968:3:9:27:Patron : robe ombreuse
253964:3:9:27:Patron : robe soyeuse
277716:2:9:5:Patron : sac de composants en cuir léger
253974:2:9:25:Patron : sac de composants en soie
254036:2:9:40:Patron : sac de composants en tisse-mage
254134:2:9:60:Patron : sac de composants en étoffe lunaire
254080:2:9:50:Patron : sac de composants en étoffe runique
279320:4:9:1:Patron : sac d’âme gangresang
239150:4:9:1:Patron : sac en étoffe de l’Aube cramoisie
239149:3:9:1:Patron : sac à dos de croisade
254108:3:9:55:Patron : sandales ambrées
273959:4:9:1:Patron : sandales de gardien du bosquet
254116:3:9:55:Patron : sandales dorées
254112:3:9:55:Patron : sandales embrasées
254114:3:9:55:Patron : sandales noires
254118:3:9:55:Patron : sandales radieuses
254110:3:9:55:Patron : sandales écumeuses
252873:3:9:55:Patron : sangle de furtivité en cuir
252874:3:9:55:Patron : sangle de garde en cuir
252875:3:9:55:Patron : sangle de mande-ciel en cuir
252872:3:9:55:Patron : sangle de rôdeur en cuir
252876:3:9:55:Patron : sangle de soigneur en cuir
252911:3:9:52:Patron : solerets de mande-ciel en mailles
252913:3:9:52:Patron : solerets de soigneur en mailles
252910:3:9:52:Patron : solerets de traqueur en mailles
252912:3:9:52:Patron : solerets d’escarmouche en mailles
275585:3:9:1:Patron : souliers de couve-colonie
275582:3:9:1:Patron : souliers de crache-venin
274010:4:9:1:Patron : spallières cœur-de-démon
273966:4:9:1:Patron : spallières de gardien du bosquet
274002:4:9:1:Patron : spallières de mande-esprit
273970:4:9:1:Patron : spallières de traqueur sauvage
273998:4:9:1:Patron : spallières sombrepoint
276987:2:9:1:Patron : spallières tisse-souffle azur
276979:2:9:1:Patron : spallières tisse-souffle nuageuses
252805:3:9:27:Patron : tunique de bagarreur en cuir
252809:3:9:27:Patron : tunique de chevaucheur de tempête en cuir
252807:3:9:27:Patron : tunique de défenseur en cuir
252810:3:9:27:Patron : tunique de sagesse en cuir
252806:3:9:27:Patron : tunique de trappeur en cuir
252808:3:9:27:Patron : tunique totémique en cuir
34319:2:9:1:Patron : vêtements d’hiver rouge
34261:2:9:1:Patron : vêtements d’hiver vert
253936:3:9:22:Patron : écharpe brillante
253930:3:9:22:Patron : écharpe des flammes
253926:3:9:22:Patron : écharpe immaculée
253934:3:9:22:Patron : écharpe nacrée
253932:3:9:22:Patron : écharpe ombreuse
253928:3:9:22:Patron : écharpe soyeuse
274006:4:9:1:Patron : épaulettes de mande-esprit
276991:2:9:1:Patron : épaulettes fil-tempête azur
276983:2:9:1:Patron : épaulettes fil-tempête nuageuses
254054:3:9:47:Patron : épaulières de flamme-du-Néant
252849:3:9:47:Patron : épaulières de furtivité en cuir
252850:3:9:47:Patron : épaulières de garde en cuir
254060:3:9:47:Patron : épaulières de lumière-du-Néant
227897:1:9:64:Patron : Épaulières de l’Aube d’argent
252851:3:9:47:Patron : épaulières de mande-ciel en cuir
252901:3:9:47:Patron : épaulières de mande-ciel en mailles
254056:3:9:47:Patron : épaulières de perle-du-Néant
252848:3:9:47:Patron : épaulières de rôdeur en cuir
252852:3:9:47:Patron : épaulières de soigneur en cuir
252903:3:9:47:Patron : épaulières de soigneur en mailles
252900:3:9:47:Patron : épaulières de traqueur en mailles
252902:3:9:47:Patron : épaulières d’escarmouche en mailles
254050:3:9:47:Patron : épaulières d’or-du-Néant
254058:3:9:47:Patron : épaulières d’éclat-du-Néant
254052:3:9:47:Patron : épaulières d’écume-du-Néant
238927:2:9:1:Patron : carquois écarlate
16303:2:12:20:Patte d'Ursangous
207732:1:15:1:Patte de makrura
208160:1:15:1:Patte sectionnée de wendigo
18826:4:4:78:Pavois de grand seigneur de guerre
272591:4:4:65:Pavois de qualité de grand seigneur de guerre
21269:4:4:79:Pavois qiraji béni
17642:1:12:1:Peau de bélier d'Alterac
20310:1:12:25:Peau de démon écorché
17643:1:12:1:Peau de loup des glaces
18969:1:12:40:Peau de yéti en parfait état
18972:1:12:40:Peau de yéti parfaite
12753:2:12:1:Peau des ombres
20931:4:12:1:Peau du Grand ver des sables
22230:3:4:52:Peau Gueule-d'horreur
20927:4:12:1:Peau intacte d'Ouro
263312:2:2:10:Pelle à plantations
277202:3:4:58:Pendentif de chercheur d’artéfact
19096:3:4:60:Pendentif de conseiller loup-de-givre
22943:4:4:83:Pendentif de la pierre pernicieuse
19095:3:4:60:Pendentif de légionnaire loup-de-givre
281286:2:4:57:Pendentif de l’Ordre suprême
281281:2:4:60:Pendentif de murmure du givre
4614:2:4:35:Pendentif de Myzrael
275838:2:4:58:Pendentif de piétine-poussière
19098:3:4:60:Pendentif de sage foudrepique
281287:2:4:57:Pendentif de Sculpte-vent
19097:3:4:60:Pendentif de soldat foudrepique
22947:4:4:85:Pendentif des noms oubliés
281657:3:4:41:Pendentif des rives Claires corrompu
21506:4:4:70:Pendentif des Sables changeants
19371:4:4:74:Pendentif du dragon déchu
21700:4:4:73:Pendentif du gardien qiraji
20649:2:4:60:Pendentif du prisme solaire
277203:2:4:23:Pendentif d’érudition
18404:4:4:65:Pendentif en dent d'Onyxia
272072:3:4:63:Pendentif protecteur sombrelance
272073:3:4:53:Pendentif protecteur sombrelance
272074:3:4:43:Pendentif protecteur sombrelance
272075:3:4:33:Pendentif protecteur sombrelance
1962:1:12:15:Pendentif sombrepoil luminescent
268560:1:12:7:Pendentif troll
9680:2:2:43:Perforeuse de Tok'kar
23163:1:0:1:Performer's Wand
219491:1:12:50:Perle onirique
21383:1:12:1:Perles d'esprit tombe-hiver
22149:3:4:63:Perles de mojo ogre
22150:3:4:63:Perles de puissance ogre
276336:2:4:60:Perles d’esprit de Yashiro
263439:1:12:1:Perles tribales mort-bois
276275:3:15:1:Petit appât amer
23327:1:0:1:Petit pain grillé
15699:1:15:1:Petit paquet marron emballé
17008:1:15:28:Petit parchemin
280567:1:0:1:Petit sac de gemmes
274386:2:4:58:Petit soldat
22243:2:1:20:Petite bourse d'âme
276279:1:15:1:Petite bourse de pièces
282015:1:1:5:Petite sacoche marron restaurée
191312:4:4:60:Phylactère de secours
15886:1:12:50:Phylactère de Timolain
210568:1:15:1:Phylactère décrépit
269247:1:15:1:Phylactère inerte
2263:2:2:25:Phytolame
221258:1:15:1:Pied droit de l’Oblitérateur
221259:1:15:1:Pied gauche de l’Oblitérateur
227932:1:15:1:Pied-de-biche rouillé
251723:1:15:1:Pierre chargée
274955:2:4:42:Pierre cubique de Cognerok
1199:1:0:8:Pierre d'âme
16893:1:0:40:Pierre d'âme
16892:1:0:30:Pierre d'âme inférieure
16896:1:0:60:Pierre d'âme majeure
5232:1:0:18:Pierre d'âme mineure
16895:1:0:50:Pierre d'âme supérieure
13584:3:15:20:Pierre de Diablo
281168:3:15:20:Pierre de Diablo
13699:1:4:36:Pierre de feu
1254:1:4:28:Pierre de feu inférieure
13701:1:4:56:Pierre de feu majeure
13700:1:4:46:Pierre de feu supérieure
6948:1:15:1:Pierre de foyer
282006:1:0:1:Pierre de foyer croulante
21745:1:0:1:Pierre de lune des anciens
191204:2:0:1:Pierre de mort inférieure
191249:2:0:1:Pierre de mort supérieure
20620:1:15:50:Pierre de pouvoir sacrée
5522:1:4:36:Pierre de sort
13603:1:4:60:Pierre de sort majeure
13602:1:4:48:Pierre de sort supérieure
13503:2:4:50:Pierre des alchimistes
12843:2:12:1:Pierre du Fléau des corrupteurs
12841:1:12:1:Pierre du Fléau des envahisseurs
12840:1:12:1:Pierre du Fléau des serviteurs
5815:2:2:31:Pierre glaciale
221191:3:13:1:Pierre onirique
9149:1:4:45:Pierre philosophale
281352:1:13:1:Pierre runique ancienne
4843:1:12:1:Pierre runique d'améthyste
4844:1:12:1:Pierre runique d'opale
4845:1:12:1:Pierre runique de diamant
281359:1:13:1:Pierre runique inerte
287978:1:0:5:Pierre à aiguiser brute
23122:2:0:55:Pierre à aiguiser consacrée
287980:2:0:60:Pierre à aiguiser élémentaire
259357:1:15:1:Pierre-clé ardente
213381:2:7:40:Pile de rouages ternis
246165:2:2:13:Pilon en bois flotté
3570:2:2:16:Pilon fracasseur
271799:2:2:38:Pince de clampant du désert
20723:2:2:62:Pioche loyale de Brann
1893:2:2:20:Piolet vengeur
12533:1:0:1:Pique de fortune
12848:1:12:1:Pique tachée de sang
6797:2:2:37:Pique-oeil
20397:1:0:1:Pirate
202256:2:2:12:Pistolet orné de corsaire
21100:1:12:1:Pièce des ancêtres
228324:4:12:50:Pièce du carnage en or
274754:3:4:45:Pièce détachée suspecte
274026:3:15:1:Pièce d’extraordinaire extravagance
208823:1:0:1:Pièce à offrandes
209056:1:15:1:Pièces détachées de moissonneur
237024:3:15:1:Place d’opéra
220349:1:5:50:Plan de Formepierre
1307:1:12:7:Plan de route du Collecteur
19208:1:9:66:Plans : Amnistie noire
20040:1:9:70:Plans : Bottes en sombrefer
12700:2:9:59:Plans : Bottes impériales en plaques
12707:2:9:60:Plans : Bottes runiques en plaques
22219:1:9:70:Plans : Bouclier dentelé en obsidienne
12690:2:9:54:Plans : Bracelets impériaux en plaques
17051:3:9:59:Plans : Brassards en sombrefer
22705:1:9:80:Plans : Brassards plaie-de-glace
6047:1:9:38:Plans : Camail en écailles dorées
12688:2:9:53:Plans : Ceinture impériale en plaques
19203:1:9:58:Plans : Ceinturon de l'Aube
17049:3:9:59:Plans : Ceinturon en anneaux de feu
11614:2:9:54:Plans : Cotte de mailles en sombrefer
19212:1:9:70:Plans : Crépuscule
19776:1:9:65:Plans : Cuirasse d'âmesang
19779:1:9:65:Plans : Cuirasse de ténébrâme
12696:3:9:57:Plans : Cuirasse démoniaque
12727:3:9:63:Plans : Cuirasse en thorium enchanté
22703:1:9:80:Plans : Cuirasse plaie-de-glace
12718:2:9:62:Plans : Cuirasse runique
17060:3:9:65:Plans : Destructeur en sombrefer
17059:3:9:65:Plans : Déchireur en sombrefer
19777:1:9:65:Plans : Epaulières d'âmesang
19781:1:9:65:Plans : Epaulières de ténébrâme
17053:3:9:62:Plans : Epaulières en anneaux de feu
11615:2:9:56:Plans : Epaulières en sombrefer
12687:2:9:53:Plans : Epaulières impériales en plaques
12706:2:9:60:Plans : Epaulières runiques en plaques
12163:1:9:36:Plans : Epée d'acier lunaire
19209:1:9:66:Plans : Fureur noire
19778:1:9:65:Plans : Gantelets d'âmesang
12699:3:9:58:Plans : Gantelets en plaques de feu
19207:1:9:70:Plans : Gantelets en sombrefer
22704:1:9:80:Plans : Gantelets plaie-de-glace
19205:1:9:64:Plans : Gants de l'Aube
7984:2:9:44:Plans : Gants ornés en mithril
19211:1:9:70:Plans : Garde noire
12164:1:9:37:Plans : Gigantesque hache en fer
12823:1:9:56:Plans : Grande hache en thorium
12819:2:9:55:Plans : Hachette ornée en thorium
19206:1:9:66:Plans : Heaume en sombrefer
12725:3:9:63:Plans : Heaume en thorium enchanté
12701:2:9:59:Plans : Heaume impérial en plaques
12714:2:9:61:Plans : Heaume runique en plaques
19780:1:9:65:Plans : Jambières de ténébrâme
17052:3:9:60:Plans : Jambières en sombrefer
12726:3:9:63:Plans : Jambières en thorium enchanté
12715:2:9:61:Plans : Jambières impériales en plaques
7983:2:9:44:Plans : Jambières ornées en mithril
12719:2:9:62:Plans : Jambières runiques en plaques
8030:1:9:51:Plans : Kriss d'ébène
8029:2:9:45:Plans : Lame corrompue en mithril
19210:1:9:70:Plans : Main d'ébène
12705:2:9:60:Plans : Pansière impériale
18264:3:9:60:Plans : Pierre à aiguiser élémentaire
10858:1:9:31:Plans : Solide maillet en fer
22221:1:9:72:Plans : Tunique de mailles en obsidienne
5737:1:12:1:Plans des opérations spéciales : Alpha & Bêta
281031:1:12:1:Plans d’expansion de Mulgore
251470:3:9:60:Plans : Bagh Nakh
251334:3:9:15:Plans : bottes brillantes en cuivre
251394:2:9:45:Plans : bottes brillantes en mithril
251439:2:9:52:Plans : bottes bénies en plaques
251359:3:9:22:Plans : bottes de croisé
251356:3:9:22:Plans : bottes de garde
251400:3:9:45:Plans : bottes de grand gardien
251402:3:9:45:Plans : bottes de justicier
251357:3:9:22:Plans : bottes de protecteur
251401:3:9:45:Plans : bottes de préfet
251399:3:9:45:Plans : bottes de sentinelle
251355:3:9:22:Plans : bottes de vétéran
251386:2:9:35:Plans : bottes dorées dures
251358:3:9:22:Plans : bottes d’acolyte
251398:3:9:45:Plans : bottes d’officier
251335:2:9:25:Plans : bottes en argent fin
277673:2:9:1:Plans : bottes grossières en anneaux de cuivre
251332:3:9:15:Plans : bottes ornées en cuivre
251333:3:9:15:Plans : bottes étranges en cuivre
273983:4:9:1:Plans : bottines de la justice
279311:4:9:1:Plans : bouclier sempervirent
251442:2:9:57:Plans : brassards bénis en plaques
251387:2:9:37:Plans : brassards dorés durs
7995:1:9:43:Plans : brassards en plaques de mithril
215383:4:9:45:Plans : Cage cérébrale en vrai-argent réfléchissant
251389:2:9:40:Plans : camail doré dur
215155:4:9:45:Plans : casque anti-interférences trempé
251444:2:9:59:Plans : ceinture bénie en plaques
251369:3:9:17:Plans : ceinture de croisé en anneaux
251366:3:9:17:Plans : ceinture de garde en anneaux
251410:3:9:35:Plans : ceinture de grand gardien
251412:3:9:35:Plans : ceinture de justicier
251367:3:9:17:Plans : ceinture de protecteur en anneaux
251411:3:9:35:Plans : ceinture de préfet
251409:3:9:35:Plans : ceinture de sentinelle
251365:3:9:17:Plans : ceinture de vétéran en anneaux
251368:3:9:17:Plans : ceinture d’acolyte en anneaux
251408:3:9:35:Plans : ceinture d’officier
251466:3:9:55:Plans : ceste en thorium
276955:2:9:1:Plans : chaîne forge-ciel azur
276931:2:9:1:Plans : chaîne forge-ciel nuageuse
251462:2:9:45:Plans : claymore en mithril
276952:2:9:1:Plans : cotte de mailles forge-ciel azur
276928:2:9:1:Plans : cotte de mailles forge-ciel nuageuse
251374:3:9:27:Plans : cotte d’anneaux argentés de croisé
251371:3:9:27:Plans : cotte d’anneaux argentés de garde
251372:3:9:27:Plans : cotte d’anneaux argentés de protecteur
251370:3:9:27:Plans : cotte d’anneaux argentés de vétéran
251373:3:9:27:Plans : cotte d’anneaux argentés d’acolyte
251344:3:9:20:Plans : cotte d’anneaux de croisé
251341:3:9:20:Plans : cotte d’anneaux de garde
251342:3:9:20:Plans : cotte d’anneaux de protecteur
251340:3:9:20:Plans : cotte d’anneaux de vétéran
251343:3:9:20:Plans : cotte d’anneaux d’acolyte
251454:2:9:21:Plans : coup de poing en laiton
275603:3:9:1:Plans : croquenots de couverain
275600:3:9:1:Plans : croquenots de sangtaille
251392:2:9:45:Plans : cuirasse brillante en mithril
251453:4:9:60:Plans : cuirasse du salut
251339:2:9:30:Plans : cuirasse en argent fin
251447:3:9:60:Plans : cuirasse en thorium enrichi
251450:4:9:60:Plans : cuissards de champion
274012:4:9:1:Plans : cuissards de gloire
273980:4:9:1:Plans : cuissards de la justice
251452:4:9:60:Plans : cuissards de martyr
279314:4:9:1:Plans : cuissards en azerothium
251455:2:9:25:Plans : dory en bronze
251393:2:9:45:Plans : espauliers brillants en mithril
251438:2:9:52:Plans : espauliers bénis en plaques
274018:4:9:1:Plans : espauliers de gloire
251430:3:9:47:Plans : espauliers de grand gardien
251432:3:9:47:Plans : espauliers de justicier
273986:4:9:1:Plans : espauliers de la justice
251431:3:9:47:Plans : espauliers de préfet
251429:3:9:47:Plans : espauliers de sentinelle
251391:2:9:40:Plans : espauliers dorés durs
251428:3:9:47:Plans : espauliers d’officier
276985:2:9:1:Plans : espauliers forge-ciel azur
276977:2:9:1:Plans : espauliers forge-ciel nuageux
251397:2:9:49:Plans : gantelets brillants en mithril
251440:2:9:54:Plans : gantelets bénis en plaques
274013:4:9:1:Plans : gantelets de gloire
251420:3:9:40:Plans : gantelets de grand gardien
251422:3:9:40:Plans : gantelets de justicier
273977:4:9:1:Plans : gantelets de la justice
251421:3:9:40:Plans : gantelets de préfet
251419:3:9:40:Plans : gantelets de sentinelle
251390:2:9:40:Plans : gantelets dorés durs
251418:3:9:40:Plans : gantelets d’officier
251337:2:9:26:Plans : gantelets en argent fin
227909:3:9:58:Plans : Gantelets en plaques de feu de la technique cachée
276954:2:9:1:Plans : gantelets forge-ciel azur
276930:2:9:1:Plans : gantelets forge-ciel nuageux
251441:2:9:57:Plans : gantelets impériaux en plaques
279313:4:9:1:Plans : gantelets lourds en thorium
251364:3:9:20:Plans : gants de croisé
251361:3:9:20:Plans : gants de garde
251405:3:9:55:Plans : gants de grand gardien
251407:3:9:55:Plans : gants de justicier
273981:4:9:1:Plans : gants de la justice
251362:3:9:20:Plans : gants de protecteur
251406:3:9:55:Plans : gants de préfet
251404:3:9:55:Plans : gants de sentinelle
251360:3:9:20:Plans : gants de vétéran
251363:3:9:20:Plans : gants d’acolyte
251403:3:9:55:Plans : gants d’officier
274016:4:9:1:Plans : garde-jambes de gloire
273984:4:9:1:Plans : garde-jambes de la justice
276956:2:9:1:Plans : garde-jambes forge-ciel azur
276932:2:9:1:Plans : garde-jambes forge-ciel nuageux
274017:4:9:1:Plans : garde-mains de gloire
273985:4:9:1:Plans : garde-mains de la justice
251435:3:9:50:Plans : garde-poignets de grand gardien
251437:3:9:50:Plans : garde-poignets de justicier
251436:3:9:50:Plans : garde-poignets de préfet
251434:3:9:50:Plans : garde-poignets de sentinelle
251433:3:9:50:Plans : garde-poignets d’officier
276953:2:9:1:Plans : garde-poignets forge-ciel azur
276929:2:9:1:Plans : garde-poignets forge-ciel nuageux
251471:3:9:60:Plans : glaive en légionite
251469:3:9:60:Plans : Grave-Tempête
251461:2:9:45:Plans : griffes en mithril
274015:4:9:1:Plans : grèves de gloire
273979:4:9:1:Plans : grèves de la justice
276957:2:9:1:Plans : grèves forge-ciel azur
276933:2:9:1:Plans : grèves forge-ciel nuageuses
279309:4:9:1:Plans : hache de défense de la forêt
251464:2:9:48:Plans : hache d’armes chargée en mithril
251467:3:9:57:Plans : hache d’hast en thorium
251395:3:9:48:Plans : heaume brillant en mithril
251445:2:9:60:Plans : heaume béni en plaques
251354:3:9:30:Plans : heaume de croisé en anneaux
251384:3:9:25:Plans : heaume de croisé en anneaux argentés
251351:3:9:30:Plans : heaume de garde en anneaux
251381:3:9:25:Plans : heaume de garde en anneaux argentés
251352:3:9:30:Plans : heaume de protecteur en anneaux
251382:3:9:25:Plans : heaume de protecteur en anneaux argentés
251350:3:9:30:Plans : heaume de vétéran en anneaux
251380:3:9:25:Plans : heaume de vétéran en anneaux argentés
251353:3:9:30:Plans : heaume d’acolyte en anneaux
251383:3:9:25:Plans : heaume d’acolyte en anneaux argentés
251449:3:9:60:Plans : heaume en thorium enrichi
276984:2:9:1:Plans : heaume forge-ciel azur
276976:2:9:1:Plans : heaume forge-ciel nuageux
251451:4:9:60:Plans : heaume infrangible
251443:2:9:59:Plans : jambières bénies en plaques
251349:3:9:25:Plans : jambières de croisé en anneaux
251379:3:9:30:Plans : jambières de croisé en anneaux argentés
251346:3:9:25:Plans : jambières de garde en anneaux
251376:3:9:30:Plans : jambières de garde en anneaux argentés
273976:4:9:1:Plans : jambières de la justice
251347:3:9:25:Plans : jambières de protecteur en anneaux
251377:3:9:30:Plans : jambières de protecteur en anneaux argentés
251345:3:9:25:Plans : jambières de vétéran en anneaux
251375:3:9:30:Plans : jambières de vétéran en anneaux argentés
251388:2:9:38:Plans : jambières dorées dures
251348:3:9:25:Plans : jambières d’acolyte en anneaux
251378:3:9:30:Plans : jambières d’acolyte en anneaux argentés
251336:2:9:26:Plans : jambières en argent fin
251448:3:9:60:Plans : jambières en thorium enrichi
279308:4:9:1:Plans : lame en bois-de-fer
251457:2:9:37:Plans : lance en acier
210779:2:9:38:Plans : mantelet de la Deuxième guerre
285291:3:9:1:Plans : marteau de forgeron en arcanite
285290:2:9:1:Plans : marteau de forgeron en mithril
285289:2:9:1:Plans : marteau de forgeron fêlé
251460:2:9:43:Plans : marteau de guerre en mithril
251468:3:9:57:Plans : miséricorde audacieuse
251396:2:9:49:Plans : pantalon brillant en mithril
215384:3:9:45:Plans : Plaques en vrai-argent faiblement radioactif
251446:2:9:60:Plans : plastron béni en plaques
251465:3:9:55:Plans : plombée en thorium
275601:3:9:1:Plans : poignes de couverain
275598:3:9:1:Plans : poignes de sangtaille
251456:2:9:31:Plans : poings de fer
251425:3:9:55:Plans : sangle de grand gardien
251427:3:9:55:Plans : sangle de justicier
251426:3:9:55:Plans : sangle de préfet
251424:3:9:55:Plans : sangle de sentinelle
251423:3:9:55:Plans : sangle d’officier
274019:4:9:1:Plans : solerets de gloire
251415:3:9:52:Plans : solerets de grand gardien
251417:3:9:52:Plans : solerets de justicier
273987:4:9:1:Plans : solerets de la justice
251416:3:9:52:Plans : solerets de préfet
251414:3:9:52:Plans : solerets de sentinelle
251413:3:9:52:Plans : solerets d’officier
279312:4:9:1:Plans : solerets en thorium appauvri
273978:4:9:1:Plans : spallières de la justice
251463:2:9:47:Plans : stylet en mithril
275602:3:9:1:Plans : support de couverain
275599:3:9:1:Plans : support de sangtaille
251385:2:9:34:Plans : thorax doré dur
279310:4:9:1:Plans : vertmartel
273982:4:9:1:Plans : épaulettes de la justice
274014:4:9:1:Plans : épaulières de gloire
251338:2:9:27:Plans : épaulières en argent fin
7985:2:9:45:Plans : épaulières ornées en mithril
251459:2:9:41:Plans : épée courte en mithril
251458:2:9:38:Plans : étoile du matin en fer
276900:2:4:54:Plaques de Denrick
281278:2:4:50:Plaques d’épaule tueuses d’écailles
274384:2:4:58:Plaques illisibles
287621:3:4:1:Plastron ambré de maître-lame
12806:3:12:60:Plastron couvert de runes inachevé
23298:3:4:68:Plastron de chevalier-capitaine en cuir
23294:3:4:68:Plastron de chevalier-capitaine en peau de dragon
263410:1:4:5:Plastron de gardienne en mailles
16453:4:4:74:Plastron de grand maréchal en cuir
13090:3:4:63:Plastron de l'élu
9650:2:4:55:Plastron de la garde d'honneur
22879:3:4:68:Plastron de légionnaire en cuir
16522:3:4:63:Plastron de légionnaire en mailles
22877:3:4:68:Plastron de légionnaire en peau de dragon
272762:4:4:65:Plastron de qualité de grand maréchal en cuir
272530:4:4:65:Plastron de qualité de seigneur de guerre en anneaux
272626:3:4:60:Plastron de qualité en cuir de kodo
272487:3:4:60:Plastron de qualité en mailles
273357:3:4:60:Plastron de qualité en mailles annelées
274219:3:4:60:Plastron de qualité en mailles rivetées
273384:3:4:60:Plastron de qualité en peau de wyrm
274179:3:4:60:Plastron de qualité en écailles
16565:4:4:74:Plastron de seigneur de guerre en anneaux
9663:2:4:45:Plastron du cavalier de l'aube
279173:1:4:1:Plastron d’aventurier vétéran
281703:2:4:1:Plastron en mailles restauré
275666:2:4:59:Plateau de Blanchetête
15797:2:4:59:Plates de bras scintillantes
250613:3:2:55:Plombée en thorium
262896:1:15:1:Plume de faussaire
213701:1:15:1:Plume de harpie puissante
5103:1:12:10:Plume de Washte Pawne
271664:2:2:33:Poids de charme
5093:1:2:21:Poignard de Tranchecrin
23284:3:4:66:Poignes de chevalier-lieutenant en cuir
23280:3:4:66:Poignes de chevalier-lieutenant en peau de dragon
22864:3:4:66:Poignes de garde de sang en cuir
16519:3:4:63:Poignes de garde de sang en mailles
22863:3:4:66:Poignes de garde de sang en peau de dragon
274755:2:4:55:Poignes de Gentepression
9656:2:4:49:Poignes de granit
16463:4:4:71:Poignes de maréchal en anneaux
15585:2:4:35:Poignes de Pardoc
272772:4:4:65:Poignes de qualité de lieutenant-commandant en mailles
274177:3:4:60:Poignes de qualité en mailles plates
272614:3:4:60:Poignes de qualité en peau de dragon
272485:3:4:60:Poignes de qualité rivetées
281705:2:4:1:Poignes en mailles restaurées
4940:1:4:10:Poignes voilées
276278:1:15:1:Poignée de pièces
211419:2:15:25:Poignée d’écailles changeantes
21188:4:2:66:Poing de Cénarius
17733:3:2:53:Poing de pierre
6953:3:2:31:Poing de Verigan
281279:2:4:60:Poings de géant de grêle
19996:1:0:55:Poisson de la moisson
6647:2:15:25:Poisson-chat moustachu boursouflé
20516:1:0:55:Pomme d'amour
8683:1:12:1:Pomme fraîche de Clara
228132:1:5:60:Pommes de terre mortes-vivantes
3561:2:4:26:Poncho de résistance
13473:2:4:54:Porte-bonheur de Felstone
13262:5:2:76:Porte-cendres
263992:1:13:1:Porte-clés de surveillant
276637:1:0:1:Portefeuille de monnaie
11953:1:0:1:Pot d'échantillon pur vide
11948:1:0:1:Pot de Limon corrompu vide
11914:1:0:1:Pot de Limon maudit vide
3251:1:12:1:Potion de Bethor
8423:1:0:1:Potion de cortex cérébral
23719:1:0:1:Potion de cortex cérébral permanente
281234:1:0:1:Potion de dissimulation du Berceau-de-l’Hiver
287976:1:0:30:Potion de libre action
18841:1:0:51:Potion de mana de combat
287969:1:0:24:Potion de mana inférieure
287968:1:0:15:Potion de mana mineure
282013:1:0:60:Potion de mana restaurée
223912:2:0:57:Potion de purification
287975:1:0:15:Potion de rapidité
277259:3:4:45:Potion de restauration fermentée
18839:1:0:45:Potion de soins de combat
287967:1:0:13:Potion de soins inférieure
223913:2:0:55:Potion de soins majeure
287966:1:0:5:Potion de soins mineure
282011:1:0:60:Potion de soins restaurée
223914:2:0:31:Potion de soins supérieure
287977:1:0:31:Potion de soins supérieure
18802:1:12:1:Potion des ténèbres
8412:1:0:1:Poudre de scorpok terrestre
23718:1:0:1:Poudre de scorpok terrestre permanente
5397:1:13:1:Poudre à canon de défias
287963:1:0:55:Poulet rôti
260824:3:4:60:Pouletisateur gnome
15814:2:2:60:Pourfendeuse d'Hameya
263421:1:4:7:Pourpoint de bandit
15786:2:4:59:Pourpoint de veine-fougère
277092:1:4:14:Pourpoint zéphrali
11315:1:12:1:Pousse de Pétale-de-sang
12451:1:12:60:Pouvoir de Juju
23548:4:12:60:Pouvoir du Fléau
280317:1:2:5:Poêle à frire
276902:2:2:54:Premier arc de jeunesse
231843:1:0:1:Premier fragment de cachet
9518:2:4:36:Presse-boue
272684:4:2:65:Prestelame de qualité de grand seigneur de guerre
23467:4:2:78:Prestelame de seigneur de guerre
20463:1:12:1:Prisme cristallin orné de glyphes
213735:3:12:1:Processeur N.O.Y.A.U G-7 en état neuf
213736:2:12:1:Processeur N.O.Y.A.U G-7 rouillé
215450:1:4:20:Projet Tabard (Aidan)
213140:2:0:40:Prophétie de chemin accéléré
205932:2:0:10:Prophétie de la chute d’un roi
221981:2:0:50:Prophétie de la tribu perdue
211530:2:0:25:Prophétie de la ville ensorcelée
221979:2:0:50:Prophétie de l’hiver verdoyant
213142:2:0:40:Prophétie de malveillance captive
211490:2:0:25:Prophétie des mille lumières
211531:2:0:25:Prophétie des sept visiteurs
221980:2:0:50:Prophétie du chaos éveillé
219449:1:12:40:Prophétie d’Azshara
205953:2:0:25:Prophétie d’un vœu brisé
205947:2:0:10:Prophétie d’une citadelle profanée
21614:4:4:81:Protecteur en peau de ver
16998:3:4:62:Protecteur sacré
274752:2:4:45:Protection de tempête de sable
275633:1:0:57:Protection en queue de renard
242266:2:0:1:Protections de pros
209057:1:0:1:Prototype de moteur
10746:2:4:50:Protège-bras d'acier runique
23259:3:4:71:Protège-front de champion en mailles
23253:3:4:71:Protège-front de champion en peau de dragon
17566:3:4:63:Protège-front de lieutenant-commandant
23308:3:4:71:Protège-front de lieutenant-commandant en peau de dragon
272743:3:4:60:Protège-front de qualité de chevalerie
272641:3:4:60:Protège-front de qualité en cuir de kodo
274196:3:4:60:Protège-front de qualité en mailles plates
273386:3:4:60:Protège-front de qualité en peau de wyrm
273374:3:4:60:Protège-front de qualité en peau du Rêve
272669:3:4:60:Protège-front de qualité en peau lunaire
272474:3:4:60:Protège-front de qualité en pelombre
272480:3:4:60:Protège-front de qualité en plaques cimentières
274231:3:4:60:Protège-front de qualité en écailles
274246:3:4:60:Protège-front de qualité lamellaire
272854:3:4:60:Protège-front de qualité lumineux
272647:3:4:60:Protège-front de qualité riveté
10743:2:4:51:Protège-front drakefeu
23276:3:4:71:Protège-front lamellaire de lieutenant-commandant
19123:2:4:48:Protège-mains calorifères
23288:3:4:66:Protège-mains de chevalier-lieutenant en satin
23290:3:4:66:Protège-mains de chevalier-lieutenant en soie
23282:3:4:66:Protège-mains de chevalier-lieutenant en tisse-effroi
272097:4:4:65:Protège-mains de chevaucheur
272098:4:4:55:Protège-mains de chevaucheur
22869:3:4:66:Protège-mains de garde de sang en satin
22870:3:4:66:Protège-mains de garde de sang en soie
22865:3:4:66:Protège-mains de garde de sang en tisse-effroi
272619:3:4:60:Protège-mains de qualité soyeux
271945:4:4:65:Protège-mains de Theramore
271946:4:4:55:Protège-mains de Theramore
23081:3:4:63:Protège-mains de tueur de mort-vivant
254029:3:4:40:Protège-mains dorés
254025:3:4:40:Protège-mains embrasés
281689:2:4:1:Protège-mains en tissu restaurés
16741:2:4:31:Protège-mains huilés
22077:4:4:55:Protège-mains Mortebrume
254027:3:4:40:Protège-mains noirs
254031:3:4:40:Protège-mains radieux
277215:2:4:58:Protège-mains simples
19116:2:4:50:Protège-mains vertefeuille
277100:1:4:14:Protège-mains zéphrali
254023:3:4:40:Protège-mains écumeux
22471:4:4:88:Protège-poignets de Brise-terre
22495:4:4:88:Protège-poignets de marcherêve
22424:4:4:88:Protège-poignets de rédemption
22443:4:4:88:Protège-poignets de traqueur des cryptes
10705:2:4:47:Protège-poignets du saule épineux
22362:4:15:60:Protège-poignets désacralisés
281696:2:4:1:Protège-poignets en cuir restaurés
272755:4:4:65:Protège-tibias de qualité de chevalier-champion en cuir
17613:3:4:63:Protège-épaules de champion en satin
16492:3:4:63:Protège-épaules de champion en soie
22515:4:4:86:Protège-épaules de foi
22499:4:4:86:Protège-épaules de givrefeu
21345:4:4:78:Protège-épaules de l'énigme
21354:4:4:78:Protège-épaules de la genèse
22507:4:4:86:Protège-épaules de pestecoeur
272565:3:4:60:Protège-épaules de qualité en satin
22368:4:15:60:Protège-épaules désacralisés
279181:1:4:1:Protège-épaules d’aventurier vétéran
22941:4:4:83:Protège-épaules polaires
19422:1:12:1:Prédiction de la foire de Sombrelune
19229:1:15:1:Prédiction de Sayge n°1
19245:1:15:1:Prédiction de Sayge n°10
19246:1:15:1:Prédiction de Sayge n°11
19247:1:15:1:Prédiction de Sayge n°12
19248:1:15:1:Prédiction de Sayge n°13
19249:1:15:1:Prédiction de Sayge n°14
19250:1:15:1:Prédiction de Sayge n°15
19251:1:15:1:Prédiction de Sayge n°16
19253:1:15:1:Prédiction de Sayge n°17
19252:1:15:1:Prédiction de Sayge n°18
19237:1:15:1:Prédiction de Sayge n°19
19256:1:15:1:Prédiction de Sayge n°2
19266:1:15:1:Prédiction de Sayge n°20
19254:1:15:1:Prédiction de Sayge n°21
19255:1:15:1:Prédiction de Sayge n°22
19423:1:15:10:Prédiction de Sayge n°23
19424:1:15:10:Prédiction de Sayge n°24
19443:1:15:10:Prédiction de Sayge n°25
19451:1:15:1:Prédiction de Sayge n°26
19452:1:15:10:Prédiction de Sayge n°27
19453:1:15:1:Prédiction de Sayge n°28
19454:1:15:1:Prédiction de Sayge n°29
19238:1:15:1:Prédiction de Sayge n°3
19239:1:15:1:Prédiction de Sayge n°4
19240:1:15:1:Prédiction de Sayge n°5
19241:1:15:1:Prédiction de Sayge n°6
19242:1:15:1:Prédiction de Sayge n°7
19243:1:15:1:Prédiction de Sayge n°8
19244:1:15:1:Prédiction de Sayge n°9
226678:4:15:60:Prémonition et Prévoyance du combat
19782:3:15:60:Présence de la puissance
19787:3:15:60:Présence de la vision
21244:4:2:79:Pugio qiraji béni
21189:4:4:62:Puissance de Cénarius
12460:1:12:60:Puissance de Juju
23545:4:12:60:Puissance du Fléau
280740:1:15:1:Puits de vent shen’dorei
272601:4:2:65:Pulvériseur de qualité de grand seigneur de guerre
18868:4:2:78:Pulvériseur de seigneur de guerre
18865:4:2:78:Punisseur de connétable
272847:4:2:65:Punisseur de qualité de connétable
272589:3:4:60:Pèlerine de qualité de sergent
272699:3:4:60:Pèlerine de qualité de sergent
16342:3:4:63:Pèlerine de sergent
18440:3:4:35:Pèlerine de sergent
18441:3:4:50:Pèlerine de sergent
13371:2:4:58:Père des flammes
276694:2:2:15:Pétard veinard du capitaine Sander
15691:2:2:38:Pétoire de flanqueur
24358:4:4:6:QATest +1000 Spell Dmg Ring
23271:1:15:55:QATest Darkmoon Faire Tickets
242363:2:0:1:Qui, quoi, où, quand et au bûcher ! Les cinq clés d’une inquisition réussie
17333:1:12:1:Quintessence aquatique
22754:1:12:1:Quintessence éternelle
8410:1:0:1:R.O.I.D.S.
23722:1:0:1:R.O.I.D.S. permanent
14894:1:0:51:Racine de lis
282283:3:4:32:Racine malveillante
234817:1:12:60:Racines enchâssées dans la pierre
12450:1:12:60:Rafale de Juju
19577:4:4:65:Rage de Mugamba
280604:3:2:40:Rage du cyclone
262433:1:0:60:Ragoût d’Hyjal de Ketharas
20081:2:0:65:Rapidité de Zanza
23796:2:0:65:Rapidité de Zanza permanente
23008:1:12:1:Rapport de recherches scellé
23010:1:12:1:Rapport de recherches scellé
23011:1:12:1:Rapport de recherches scellé
23012:1:12:1:Rapport de recherches scellé
23013:1:12:1:Rapport de recherches scellé
23016:1:12:1:Rapport de recherches scellé
263930:1:12:1:Rapport de reconnaissance de Fort-Lointain
21161:1:12:60:Rapport de reconnaissance de la Ruche'Ashi
21160:1:12:60:Rapport de reconnaissance de la Ruche'Regal
21158:1:12:60:Rapport de reconnaissance de la Ruche'Zora
219928:1:12:50:Rapport de surveillance : Agol’watha
219926:1:12:40:Rapport de surveillance : camp de bûcherons chanteguerre
219924:1:12:40:Rapport de surveillance : Chant des forêts
219958:1:12:50:Rapport de surveillance : Colosses jumeaux
219803:1:12:25:Rapport de surveillance : ferme des Yorgen
219957:1:12:50:Rapport de surveillance : Oneiros
219938:1:12:50:Rapport de surveillance : rocher de l’Affût
219959:1:12:50:Rapport de surveillance : ruines de Vent-du-Corbeau
219925:1:12:40:Rapport de surveillance : Satyrnaar
219937:1:12:50:Rapport de surveillance : Shaol’watha
219776:1:12:25:Rapport de surveillance : tertre des ogres Vul’Gol
219778:1:12:25:Rapport de surveillance : verger Pourrissant
219759:1:12:25:Rapport de terrain de Charla
219772:1:12:50:Rapport de terrain de Fallia
219770:1:12:40:Rapport de terrain de Gemeron
219771:1:12:50:Rapport de terrain de Thandros
16746:1:12:1:Rapport du clan Chanteguerre
19872:4:15:60:Raptor razzashi rapide
19804:2:15:45:Rascasse pâle
18840:4:2:78:Rasoir de grand seigneur de guerre
272596:4:2:65:Rasoir de qualité de grand seigneur de guerre
20223:1:0:35:Ration de campagne de profanateur
20226:1:0:35:Ration de campagne des Hautes-terres
20063:1:0:35:Ration de campagne du bassin d'Arathi
19062:1:0:35:Ration de campagne du goulet des Chanteguerres
20224:1:0:45:Ration de fer de profanateur
20227:1:0:45:Ration de fer des Hautes-terres
20064:1:0:45:Ration de fer du bassin d'Arathi
19061:1:0:45:Ration de fer du goulet des Chanteguerres
20222:1:0:55:Ration enrichie de profanateur
20225:1:0:55:Ration enrichie des Hautes-terres
20062:1:0:55:Ration enrichie du bassin d'Arathi
19060:1:0:55:Ration enrichie du goulet des Chanteguerres
272053:1:0:35:Rations de campagne des îles des Sombrelances
272054:1:0:45:Rations de fer des îles des Sombrelances
277950:2:4:40:Rations des Bat-le-désert
272055:1:0:55:Rations enrichies des îles des Sombrelances
21537:1:0:55:Raviolis de fête
10645:1:4:48:Rayon mortel gnome
4609:1:9:35:Recette : Aile de busard grillée
18267:2:9:55:Recette : Courante-surprise
3735:1:9:25:Recette : Côtelettes de lion épicées
12229:1:9:35:Recette : Côtes de loup épicées
6068:1:9:33:Recette : Huile des ténèbres
14634:2:9:40:Recette : Huile glaciale
13517:1:9:50:Recette : Pierre des alchimistes
13501:2:9:59:Recette : Potion de mana majeure
6054:1:9:27:Recette : Potion de protection contre l'Ombre
6057:1:9:38:Recette : Potion de protection contre la Nature
6055:1:9:33:Recette : Potion de protection contre le Feu
6056:1:9:38:Recette : Potion de protection contre le Givre
6053:1:9:20:Recette : Potion de protection contre le Sacré
20013:1:9:57:Recette : Potion de vive action
12231:1:9:35:Recette : Ragoût de la jungle
12233:1:9:35:Recette : Ragoût mystère
12240:1:9:40:Recette : Ragoût épais de kodo
12228:1:9:35:Recette : Rôti de raptor
20012:1:9:55:Recette : Sommeil sans rêve supérieur
16767:1:9:45:Recette : Soupe de palourdes d'Undermine
3734:1:9:25:Recette : Steak de grand ours
12227:1:9:25:Recette : Steak de loup
9302:1:9:49:Recette : Teinture fantôme
18160:2:9:15:Recette : Thé de chardon
12232:1:9:35:Recette : Tourte surprise
13482:2:9:55:Recette : Transmutation de l'Air en Feu
13485:2:9:55:Recette : Transmutation de l'Eau en Air
13484:2:9:55:Recette : Transmutation de la Terre en Eau
13483:2:9:55:Recette : Transmutation du Feu en Terre
20761:1:9:60:Recette : Transmutation du feu élémentaire
9305:1:9:45:Recette : Transmutation du mithril en vrai-argent
5489:1:9:25:Recette : Venaison dégraissée
274977:1:9:1:Recette : bonne vieille viande de brochepâle
250178:1:9:1:Recette : bruscitt d’ours
274415:1:9:1:Recette : confiture patte-douce
250181:1:9:1:Recette : côtelettes de raptor bouillantes
250187:1:9:1:Recette : délicieuses bouchées au raptor
236754:2:9:12:Recette : eau-de-feu distillée
250183:1:9:1:Recette : effiloché de raptor préhistorique
20011:1:9:55:Recette : Elixir magesang
238649:1:9:1:Recette : festin de loche à taches claires
238646:1:9:1:Recette : filet de flanc
274277:3:9:1:Recette : flacon de justesse naturelle
274279:3:9:1:Recette : flacon de précision naturelle
274280:3:9:1:Recette : flacon de rapidité naturelle
274278:3:9:1:Recette : flacon d’agression naturelle
250177:1:9:1:Recette : flanchet au poivre
249888:1:9:1:Recette : frappé calcifié
249886:1:9:1:Recette : frappé gélatineux
249890:1:9:1:Recette : frappé pernicieux
249885:1:9:1:Recette : frappé venimeux
249889:1:9:1:Recette : frappé épicé
249887:1:9:1:Recette : frppl mrrggl
215433:3:9:40:Recette : Gniode isolant
238650:1:9:1:Recette : grand banquet de homard
250175:1:9:1:Recette : hachis de chauve-souris
250189:1:9:1:Recette : linguines aux palourdes
250173:1:9:1:Recette : mini-burgers de cerf savoureux
250188:1:9:1:Recette : omelette de petit déjeuner
238647:1:9:1:Recette : omelette du Lever de soleil
250174:1:9:1:Recette : pamplona d’envergure
250184:1:9:1:Recette : paupiette de raptor
286153:1:9:45:Recette : poisson cuirassé
250182:1:9:1:Recette : poitrine d’ours
250995:1:9:1:Recette : potion de brume caustique
250997:1:9:1:Recette : potion de feu draconique
250984:1:9:1:Recette : potion de frénésie
250987:1:9:1:Recette : potion de frénésie majeure
250985:2:9:1:Recette : potion de frénésie supérieure
250998:1:9:1:Recette : potion de purge d’élémentaires
215163:4:9:45:Recette : Potion de régénération faiblement irradiée
250994:1:9:1:Recette : potion de sang envenimé
250990:1:9:1:Recette : potion de soigneur
250993:1:9:1:Recette : potion de soigneur majeure
250991:1:9:1:Recette : potion de soigneur supérieure
241651:2:9:10:Recette : potion de soins majeure décolorée
4597:2:9:10:Recette : potion de soins mineure décolorée
250999:1:9:1:Recette : potion de tueur de bêtes
9300:1:9:50:Recette : potion de tueur de démons
250978:1:9:1:Recette : potion d’explosion de sorts
250981:1:9:1:Recette : potion d’explosion de sorts majeure
250979:2:9:1:Recette : potion d’explosion de sorts supérieure
274972:1:9:50:Recette : ragoût de fruits de mer saumâtre
250176:1:9:1:Recette : ragoût de tortue savoureux
250179:1:9:1:Recette : steak de cerf fumant
250180:1:9:1:Recette : steak de frappe rapide
238645:1:9:1:Recette : steak de rôdeur
249881:1:9:1:Recette : thé aux racines
249879:1:9:1:Recette : thé de sérénité
249882:1:9:1:Recette : thé de triage
249884:1:9:1:Recette : thé des sages
249883:1:9:1:Recette : thé du soleil
249880:1:9:1:Recette : thé royal
250386:1:9:1:Recette : élixir de férocité
250384:1:9:1:Recette : élixir de la baleine
250373:1:9:1:Recette : élixir de la chouette
250365:1:9:1:Recette : élixir de la phalange
250379:1:9:1:Recette : élixir de puissance de la nature
250371:1:9:1:Recette : élixir de robustesse supérieure
250364:1:9:1:Recette : élixir de ruse
250372:1:9:1:Recette : élixir de régénération maudite
20014:1:9:58:Recette : élixir de sang de Troll majeur
217399:2:9:40:Recette : élixir des arcanes inférieur
250378:1:9:1:Recette : élixir des arcanes inférieur
250367:1:9:1:Recette : élixir des clercs inférieur
250369:1:9:1:Recette : élixir des clercs supérieur
250374:1:9:1:Recette : élixir des sages
250387:1:9:1:Recette : élixir du grizzly
250381:1:9:1:Recette : élixir d’Esprit inférieur
250383:1:9:1:Recette : élixir d’Esprit supérieur
250388:1:9:1:Recette : élixir d’Intelligence inférieure
250376:1:9:1:Recette : élixir magesang inférieur
250377:1:9:1:Recette : élixir magesang supérieur
250185:1:9:1:Recette : émincé de raptor aux deux épices
250186:1:9:1:Recette : œufs brouillés géants
22719:1:15:60:Recueil d'Omarion
275688:1:0:60:Recycleur de puissance
270102:2:4:51:Redirigeurs de projectile
23042:4:4:85:Reflet d'Horreb
23172:1:0:55:Refreshing Red Apple
253259:1:15:60:Refroidisseuse
258526:1:7:1:Registre de vol
266427:1:12:1:Registre du grand maréchal
232358:4:12:79:Reliquaire vide
216947:1:12:1:Relique de Dalaran bourdonnante
216945:1:12:1:Relique de Dalaran curieuse
216951:1:12:1:Relique de Dalaran glissante
216950:1:12:1:Relique de Dalaran inquiétante
216949:1:12:1:Relique de Dalaran lourde
216946:1:12:1:Relique de Dalaran scintillante
216948:1:12:1:Relique de Dalaran étrange
270865:1:12:1:Relique des Titans
270866:1:12:1:Relique des Titans
287958:1:12:1:Relique des Titans
287959:1:12:1:Relique des Titans
219490:1:12:50:Relique d’Elune
236878:2:15:1:Relique mystérieuse
236879:2:15:1:Relique mystérieuse
236880:2:15:1:Relique mystérieuse
191414:3:0:1:Relique squelette
21112:1:12:1:Reliure magique
281637:3:4:58:Rempart antique
277286:2:2:23:Requête d’envahissement
254695:1:12:60:Restes gangrenés
208222:2:2:57:Revancharde de vieux garde
18713:4:2:75:Rhok'delar, arc long des Gardiens anciens
20488:4:2:75:Rhok'delar, arc long des Gardiens anciens DEP
287972:1:0:1:Rhum brun de Rumsey
17048:1:0:1:Rhum de Rumsey
227286:1:0:1:Rhum de Rumsey chaud à la crème
18968:4:4:60:Ring of Critical Testing
18970:4:4:60:Ring of Critical Testing 2
18971:4:4:60:Ring of Critical Testing 3
18982:4:4:60:Ring of Critical Testing 4
6503:2:4:22:Robe bigarrée
19129:2:4:49:Robe brasillante
253971:3:4:27:Robe brillante
253911:3:4:20:Robe brillante filigranée
257330:1:4:10:Robe cousue à la main
20034:4:4:65:Robe d'illusionniste zandalar
21334:4:4:88:Robe d'implorateur funeste
2231:2:4:40:Robe d'Inferno
17600:3:4:63:Robe de chevalier-capitaine en satin
17568:3:4:63:Robe de chevalier-capitaine en tisse-effroi
1171:1:4:10:Robe de confection
20033:4:4:65:Robe de démoniaque zandalar
22512:4:4:92:Robe de foi
270079:2:4:41:Robe de féticheur
21538:1:4:1:Robe de fête rose
21157:1:4:1:Robe de fête verte
21539:1:4:1:Robe de fête violette
271736:1:4:1:Robe de garde-paix shen’dorei
3558:2:4:25:Robe de gardien des tourbières
22496:4:4:92:Robe de givrefeu
17581:4:4:74:Robe de grand maréchal en tisse-effroi
14152:4:4:62:Robe de l'archimage
21343:4:4:88:Robe de l'énigme
16491:3:4:63:Robe de légionnaire en soie
17572:3:4:63:Robe de légionnaire en tisse-effroi
4989:2:4:50:Robe de mage-dragon
271725:1:4:1:Robe de magistère shen’dorei
2586:1:4:1:Robe de maître de jeu
16605:2:4:5:Robe de moine de la lumière
1561:2:4:15:Robe de moissonneur
274941:2:4:40:Robe de mystique des collines hirsutes
21040:1:4:1:Robe de Narain
22504:4:4:92:Robe de pestecoeur
7054:3:4:38:Robe de puissance
272805:4:4:65:Robe de qualité de grand maréchal en tisse-effroi
272459:3:4:60:Robe de qualité de magus
272576:4:4:65:Robe de qualité de seigneur de guerre en satin
272560:4:4:65:Robe de qualité de seigneur de guerre en tisse-gangrène
273435:4:4:65:Robe de qualité de seigneur de guerre soyeuse
272800:3:4:60:Robe de qualité en tisse-effroi
272548:3:4:60:Robe de qualité en tisse-gangrène
272816:3:4:60:Robe de qualité en étoffe du Vide
273448:3:4:60:Robe de qualité en étoffe lunaire
270035:2:4:27:Robe de récupérateur
274946:2:4:40:Robe de sang de Gnoll
17624:4:4:74:Robe de seigneur de guerre en satin
17592:4:4:74:Robe de seigneur de guerre en tisse-effroi
3555:2:4:25:Robe de Solomon
271759:1:4:1:Robe de zélote al’aketh
4120:2:4:40:Robe des eaux cristallines
21527:4:4:77:Robe des eaux sombres
253965:3:4:27:Robe des flammes
253905:3:4:20:Robe des flammes filigranée
5812:2:4:25:Robe des temps anciens
9598:2:4:10:Robe du dormeur
7510:2:4:20:Robe du feu-sorcier mineur
3161:2:4:15:Robe du gardien
7511:2:4:31:Robe du noeud astral
7512:2:4:31:Robe du Néant
21663:4:4:77:Robe du saint gardien
22069:4:4:60:Robe du sorcier
14153:4:4:62:Robe du Vide
22351:4:15:60:Robe désacralisée
270000:2:4:13:Robe d’apprenti sorcier
270022:2:4:20:Robe d’archéologue
3216:1:4:10:Robe d’hiver chaude
271749:1:4:1:Robe d’oracle des cieux shen’dorei
7334:2:4:28:Robe efflorescente
7509:2:4:20:Robe en tisse-mana
11189:1:4:5:Robe forestière
253961:3:4:27:Robe immaculée
253901:3:4:20:Robe immaculée filigranée
16606:2:4:5:Robe juju maléfique
16604:2:4:10:Robe lunaire d'Elune
22075:4:4:60:Robe Mortebrume
253969:3:4:27:Robe nacrée
253909:3:4:20:Robe nacrée filigranée
253967:3:4:27:Robe ombreuse
253907:3:4:20:Robe ombreuse filigranée
15455:2:4:37:Robe Poussière-d'automne
281299:2:4:49:Robe rituelle impie
270113:2:4:50:Robe roussie en étoffe
16607:2:4:5:Robe sacrificielle d'acolyte
6900:3:4:38:Robe sanglante dorée enchantée
253963:3:4:27:Robe soyeuse
253903:3:4:20:Robe soyeuse filigranée
22083:4:4:60:Robe vertueuse
274760:3:4:55:Robot de livraison de Long-Guet
23549:4:12:60:Robustesse du Fléau
49715:2:4:1:Rose à jamais ravissante
271618:1:4:1:Roses rejetées
275818:4:15:1:Rosy
16788:2:4:36:Roue du capitaine Rackmore
13881:2:15:45:Rouget boursouflé
20256:2:12:1:Ruban de sacrifice du goulet des Chanteguerres
263404:2:2:13:Ruban des heures
12647:1:12:1:Rubis de Felhas
8008:1:0:58:Rubis de mana
221418:1:0:50:Rugissement d’agamaggan
208860:1:5:10:Rumi de Gnomeregan : Le recueil d’œuvres
205230:2:0:1:Rune cauchemardesque
213117:2:0:40:Rune de berserk
226587:2:0:60:Rune de bombardement
191459:4:0:1:Rune de bonne fortune
235604:2:0:1:Rune de Bouclier de piété
210746:2:0:25:Rune de Bouclier de terre
213131:2:0:40:Rune de boucliers saints
227922:2:0:60:Rune de bretteur
203994:2:0:25:Rune de Breuvage mortel
221483:2:0:50:Rune de brûlure
208750:2:0:10:Rune de Canalisation
19120:2:4:51:Rune de capitaine de la garde
221461:2:0:50:Rune de carnage
235605:2:0:1:Rune de Choc et effroi
220165:2:0:50:Rune de colère
213124:2:0:40:Rune de combat rapproché
225740:2:0:60:Rune de constance
205979:2:0:1:Rune de Contournement
221428:2:0:50:Rune de Coup bas
206992:2:0:25:Rune de Coup de crâne
208772:2:0:10:Rune de Coup de sabre
210015:2:0:25:Rune de Coup déchaîné
227921:2:0:60:Rune de couteaux
210137:2:0:25:Rune de croissance sauvage
208771:2:0:10:Rune de Danse des lames
21567:3:4:45:Rune de devoir
21568:3:4:25:Rune de devoir
220610:2:0:50:Rune de dextérité mentale
225686:2:0:60:Rune de Décimation
206032:2:0:1:Rune de Découpe
220913:2:0:50:Rune de démolition
232460:2:0:50:Rune de Déplacement
232461:2:0:50:Rune de Désespoir
221515:2:0:50:Rune de détonation
204703:2:0:1:Rune de Dévastation
235601:2:0:1:Rune de Fanatisme
213126:2:0:40:Rune de ferrailleuse
221445:2:0:50:Rune de feu focalisé
210569:2:0:25:Rune de Flagellation
221433:2:0:50:Rune de focalisation
204795:2:0:1:Rune de Frappe des ténèbres
208778:2:0:10:Rune de Frappe rapide
210596:2:0:25:Rune de Frappes de cobra
204441:2:0:1:Rune de Frénésie sanglante
211393:2:0:25:Rune de Fureur obsessionnelle
210811:2:0:25:Rune de Fureur primordiale
213138:2:0:40:Rune de gaucher
204912:2:0:1:Rune de Grâce
219147:2:0:50:Rune de Grâce
212551:2:0:40:Rune de Guerre
211387:2:0:25:Rune de Guide de lumière
226252:2:0:60:Rune de guérilla
220614:2:0:50:Rune de horion statique
206168:2:0:1:Rune de la chimère
213110:2:0:40:Rune de la commandante
217736:2:0:50:Rune de la coterie
221020:2:0:50:Rune de la déesse de la lune
213120:2:0:40:Rune de la rêveuse
213086:2:0:40:Rune de la tempête
220754:2:0:50:Rune de la tempête de vent
208687:2:0:10:Rune de Lacérer
212559:2:0:40:Rune de Lame empoisonnée
213096:2:0:40:Rune de leurres
205897:2:0:1:Rune de Lumière divine
227746:2:0:60:Rune de l’Arbre-monde
213137:2:0:40:Rune de l’assaillant
213139:2:0:40:Rune de l’assassin
221517:2:0:50:Rune de l’effusion de sang
227749:2:0:60:Rune de l’étoile filante
211476:2:0:25:Rune de l’Éveil du feu
210653:2:0:25:Rune de Main gauche
225688:2:0:60:Rune de Marque du chaos
235602:2:0:1:Rune de Marteau du vertueux
203993:2:0:1:Rune de Massacre
208701:2:0:10:Rune de Maîtrise des bêtes
221514:2:0:50:Rune de maîtrise du Feu
216606:2:0:40:Rune de maîtrise à deux mains
213102:2:0:40:Rune de méchanceté
213074:2:0:40:Rune de nourrissement
213094:2:0:40:Rune de Nova de feu
220617:2:0:50:Rune de pandémie
210979:2:0:40:Rune de Pas de l’ombre
211301:2:0:40:Rune de Perce-faille
21565:3:4:45:Rune de perfection
21566:3:4:25:Rune de perfection
213128:2:0:40:Rune de piété
211391:2:0:25:Rune de Pluie guérisseuse
210825:2:0:25:Rune de Porteguerre
206963:2:0:1:Rune de potentiel naturel
211205:2:0:1:Rune de Pourfendeur de cobras
211385:2:0:25:Rune de Propagation du serpent
204174:2:0:1:Rune de précision
213104:2:0:40:Rune de Précision impitoyable
213093:2:0:40:Rune de puissance
221513:2:0:50:Rune de puissance
232462:2:0:50:Rune de Puissance purifiante
213109:2:0:40:Rune de Rage concentrée
210573:2:0:25:Rune de Rage dévorante
212562:2:0:40:Rune de Rage guérisseuse
208741:2:0:10:Rune de Rage infinie
18149:2:12:60:Rune de rappel
18150:2:12:60:Rune de rappel
220612:2:0:50:Rune de raz-de-marée
221490:2:0:50:Rune de remous
232459:2:0:50:Rune de Retour de flamme
213125:2:0:40:Rune de Revigoration
205683:2:0:1:Rune de Réprimandes
210820:2:0:25:Rune de Sacrifice
232458:2:0:50:Rune de Sanctuaire amélioré
213100:2:0:40:Rune de Savoir interdit
205022:2:0:1:Rune de Siphon d’âme
210823:2:0:25:Rune de Spécialisation Ambidextrie
226413:2:0:50:Rune de Spécialisation Arcanes
226411:2:0:50:Rune de Spécialisation Armes de pugilat
226412:2:0:50:Rune de Spécialisation Armes d’hast
226410:2:0:50:Rune de Spécialisation Armes à distance
226419:2:0:50:Rune de Spécialisation Combat farouche
226409:2:0:50:Rune de Spécialisation Dague
226694:2:0:50:Rune de Spécialisation Défense
231828:2:0:50:Rune de Spécialisation en méditation
231829:2:0:50:Rune de Spécialisation en soins
226414:2:0:50:Rune de Spécialisation Feu
226415:2:0:50:Rune de Spécialisation Givre
226407:2:0:50:Rune de Spécialisation Hache
226408:2:0:50:Rune de Spécialisation Masse
226416:2:0:50:Rune de Spécialisation Nature
226417:2:0:50:Rune de Spécialisation Ombre
226418:2:0:50:Rune de Spécialisation Sacré
226406:2:0:50:Rune de Spécialisation Épée
213136:2:0:40:Rune de subtilité
220616:2:0:50:Rune de surcharge
210817:2:0:25:Rune de survie
213090:2:0:40:Rune de synergie
205215:2:0:1:Rune de Tactiques
211390:2:0:25:Rune de Taquinerie
227456:2:0:60:Rune de Tempête cramoisie
235600:2:0:1:Rune de Tempête divine
208758:2:0:10:Rune de terre
213122:2:0:40:Rune de tir assuré
208777:2:0:1:Rune de tir de précision
206169:2:0:1:Rune de Tir explosif
203991:2:0:1:Rune de Tireur rapide
204809:2:0:1:Rune de tonnerre furieux
220613:2:0:50:Rune de tonnerre grondant
205228:2:0:1:Rune de Trait du chaos
19340:4:4:76:Rune de transformation
210980:2:0:25:Rune de transformation
212549:2:0:40:Rune de trappeur
191267:2:0:1:Rune de téléportation : antichambre
191288:4:0:1:Rune de téléportation : antre du Wyrm de givre
212561:2:0:40:Rune de Ténèbres enflammées
213103:2:0:40:Rune de Vague de sang
221489:2:0:50:Rune de vengeance
235603:2:0:1:Rune de Vengeance vertueuse
210322:2:0:25:Rune de venin
206970:2:0:1:Rune de vie
206155:2:0:1:Rune de visée
208744:2:0:10:Rune des Traits d’ombre
210500:2:0:20:Rune des étoiles
221510:2:0:50:Rune du chevalier
220682:2:0:50:Rune du débridé
220791:2:0:50:Rune du félin de la jungle
221499:2:0:50:Rune du gangregarde
213132:2:0:40:Rune du gardien
220164:2:0:50:Rune du gladiateur
221473:2:0:50:Rune du guetteur
210818:2:0:25:Rune du Loup solitaire
223288:2:0:50:Rune du marteau
210824:2:0:25:Rune du pacte
226680:3:0:60:Rune du premier guerrier
221511:2:0:50:Rune du protecteur
220687:2:0:50:Rune du raptor
213118:2:0:40:Rune du roi de la jungle
213452:2:15:1:Rune du Sacré inerte
221267:2:0:50:Rune du sanguinaire
206989:2:0:1:Rune du soleil
211488:2:0:25:Rune du vengeur
220217:2:0:50:Rune du Vorace
12662:2:7:50:Rune démoniaque
221482:2:0:50:Rune d’affliction
211392:2:0:25:Rune d’Affliction éternelle
225687:2:0:60:Rune d’Armure infernale
204716:2:0:1:Rune d’assaut frénétique
220618:2:0:50:Rune d’aura d’immolation
220360:2:0:50:Rune d’efflorescence
221512:2:0:50:Rune d’empressement
213141:2:0:40:Rune d’espoir
225914:2:0:60:Rune d’esprit lié
213123:2:0:40:Rune d’exposition
213130:2:0:40:Rune d’imprégnations
211477:2:0:25:Rune d’Incinérer
225955:2:0:60:Rune d’ingéniosité
206264:2:0:1:Rune d’Inspiration
213119:2:0:40:Rune d’instinct
213111:2:0:40:Rune d’intervention
204806:2:0:1:Rune d’Ivresse de la victoire
213101:2:0:40:Rune d’ombreflamme
209852:2:0:25:Rune d’Ordre de tuer
212548:2:0:40:Rune d’éclipse
205685:2:0:1:Rune d’Égide
221516:2:0:50:Rune d’énergie primale
213129:2:0:40:Rune d’Étreinte de la Lumière
212560:2:0:40:Rune d’Éveil ancestral
213098:2:0:40:Rune d’Évocation
22484:2:15:1:Rune nécrotique
209850:1:5:25:Runes des rois-sorciers
210252:2:0:25:Runes du surin
215822:1:5:25:RwlRwlRwlRwl !
226404:2:12:60:Réal de Terremine terni
212225:3:12:30:Réceptacle d’âme infini
7866:1:12:1:Récipient thaumaturgique vide
247841:1:0:1:Récolte sauvage
216618:1:15:1:Récompense du capitaine Aransas
276242:1:15:1:Réplique de bâtonnet de transformation de Dartol
281060:3:15:1:Réplique de carabine à air comprimé de Forgefer
276236:3:15:1:Réplique de carabine à air comprimé de Forgefer dans son étui
281290:2:4:26:Réplique de collier à croissant de lune
268812:1:12:1:Résidu d’horreur murmurante
23547:4:12:60:Résistance du Fléau
13354:1:12:1:Résonateur ectoplasmique
22115:1:12:1:Révélateur de fantômes extradimensionnel
13335:3:15:60:Rênes de destrier de la mort
21736:3:15:60:Rênes de gryphon de monte
262766:4:15:1:Rênes de kodo de bât
23193:4:15:60:Rênes de palefroi squelettique
13086:4:15:60:Rênes de sabre-de-givre de Berceau-de-l'Hiver
18242:4:15:40:Rênes de tigre de guerre noir
234465:4:15:60:Rênes de tigre spectral rapide
277718:4:15:1:Rênes d’ours spectral
21235:1:0:55:Rôti du Voile d'hiver
23211:1:0:1:S'morc grillé
3434:1:0:7:Sable de léthargie
5099:1:12:10:Sabot de Lakota'mani
18145:1:12:60:Sabot de tauren
275723:1:12:6:Sabot d’Halikor
211498:3:15:25:Sabre-de-nuit sentinelle de recrue
20400:2:1:1:Sac citrouille
3352:1:1:25:Sac couvert de vase
221491:2:0:40:Sac crocs-d’ombre
23215:1:0:1:Sac d'ingrédients de s'morc
21041:1:12:1:Sac d'or
1191:1:0:8:Sac de billes
20603:1:15:1:Sac de butin
21528:2:15:60:Sac de butin colossal
3343:1:1:15:Sac de butin du capitaine Sander
211527:3:15:40:Sac de couchage douillet
21640:1:15:1:Sac de feux d'artifice de la fête lunaire
22679:3:1:60:Sac de fournitures
217014:2:0:40:Sac de fournitures
237263:2:0:40:Sac de fournitures
20393:1:15:1:Sac de friandises
202251:1:0:8:Sac de friandises pour animaux
10683:1:1:55:Sac de l'explorateur
11324:1:1:45:Sac de l'explorateur
16057:1:1:35:Sac de l'explorateur
211799:1:15:1:Sac de marchandises volées
1537:1:1:1:Sac de nourriture de la Vieille Blanchy
1127:1:0:20:Sac de poudre noire
21156:1:15:1:Sac de scarabées
231644:2:15:60:Sac d’enchantement de geôlier
231642:2:15:60:Sac d’herbes de geôlier
12849:2:12:61:Sac embrassé par un démon
4930:1:1:5:Sac en cuir fait main
11845:1:1:1:Sac en cuir fait main
287971:1:1:15:Sac en laine
10959:2:1:55:Sac en peau de démon
918:1:1:25:Sac en peau de déviant
19914:3:1:55:Sac en peau de panthère
276892:2:1:29:Sac en soie d’araignée
282017:1:1:25:Sac lourd marron restauré
15866:2:4:15:Sac médecine de voile-poussière
275722:1:12:4:Sac perdu d’Ukor
238681:1:0:60:Sac poussiéreux
277845:1:1:60:Sac relativement grand
280088:1:1:5:Sac soyeux de dents de sabre
9587:1:1:45:Sac spirituel
285353:3:4:1:Sac à dos de l’exploration éternelle
280623:1:4:1:Sac à dos d’aventurier aguerri
17966:2:1:55:Sac à dos en cuir d'Onyxia
287620:3:4:1:Sac à dos totémique robuste
279936:1:1:5:Sac à livres
277977:1:1:6:Sac à loquet en canevas
16768:2:4:52:Sac-médecine furbolg
21813:1:15:1:Sachet de bonbons
4981:1:1:35:Sacoche d'Agmond
22152:1:15:1:Sacoche d'Anthion
22137:1:15:1:Sacoche d'Ysida
285276:2:2:33:Sacoche de bombes en bronze
285275:2:2:18:Sacoche de bombes en cuivre
285277:2:2:46:Sacoche de bombes en fer
285278:2:2:57:Sacoche de bombes en sombrefer
282286:1:1:5:Sacoche de chantier naval
270017:2:1:20:Sacoche de chasse
277114:1:1:1:Sacoche de dépeçage d’apprenti
260307:1:1:58:Sacoche de la poste d’Hyjal
10479:2:15:50:Sacoche de marchand de Kovic
228327:1:15:50:Sacoche de pièces du carnage en argent
280766:2:4:33:Sacoche de potions
11020:1:12:1:Sacoche de printemps
271994:1:15:1:Sacoche de Terremine
2082:1:1:5:Sacoche de Wizbang
5603:1:1:15:Sacoche de Wizbang
1729:1:1:25:Sacoche des Veilleurs
21315:1:15:1:Sacoche Fumebois
282016:1:1:15:Sacoche marron en cuir restaurée
262801:2:1:60:Sacoche peau-d’écorce
235852:2:12:1:Sacoche pourpre
256935:1:1:5:Sacoche simple en cuir
222962:1:0:50:Sagesse d’Hyjal
284868:1:0:52:Sainte grenade d’Alterac
11582:1:15:1:Salve infernale
274743:3:4:25:Samophlange défectueux
254107:3:4:55:Sandales ambrées
22516:4:4:86:Sandales de foi
22500:4:4:86:Sandales de givrefeu
17607:4:4:71:Sandales de maréchal en satin
22508:4:4:86:Sandales de pestecoeur
272823:4:4:65:Sandales de qualité de chevalier-champion en étoffe du Vide
273426:4:4:65:Sandales de qualité de chevalier-champion en étoffe lunaire
254115:3:4:55:Sandales dorées
4139:2:4:37:Sandales du marcheur de la jungle
22372:4:15:60:Sandales désacralisées
254111:3:4:55:Sandales embrasées
274721:2:4:57:Sandales en lambeaux
16409:3:4:63:Sandales lamellaires de chevalier-lieutenant
22076:4:4:60:Sandales Mortebrume
254113:3:4:55:Sandales noires
254117:3:4:55:Sandales radieuses
22084:4:4:60:Sandales vertueuses
254109:3:4:55:Sandales écumeuses
221345:3:12:45:Sang corrompu d’Eranikus
10779:2:4:60:Sang de démon
19939:2:12:1:Sang de Gri'lek
17306:1:12:1:Sang de soldat foudrepique
12938:1:12:60:Sang des héros
13523:1:12:1:Sang des innocents
231841:4:12:79:Sang du Porteur de Lumière
232312:4:12:79:Sang du Porteur de Lumière
268705:1:12:1:Sang et bataille
11752:1:12:1:Sang noir du Tourmenté
22422:4:4:88:Sangle de cuirassier
252474:3:4:55:Sangle de furtivité en cuir
252475:3:4:55:Sangle de garde en cuir
250573:3:4:55:Sangle de grand gardien
250575:3:4:55:Sangle de justicier
22482:4:4:88:Sangle de la faucheuse d'os
252476:3:4:55:Sangle de mande-ciel en cuir
250574:3:4:55:Sangle de préfet
272756:4:4:65:Sangle de qualité de chevalier-capitaine en peau de bête
273398:4:4:65:Sangle de qualité de chevalier-capitaine en peau du Rêve
273390:4:4:65:Sangle de qualité de chevalier-capitaine en peau lunaire
252473:3:4:55:Sangle de rôdeur en cuir
250572:3:4:55:Sangle de sentinelle
252477:3:4:55:Sangle de soigneur en cuir
272403:4:4:60:Sangle des vaillants
22356:4:15:60:Sangle désacralisée
272395:4:4:60:Sangle d’assassin
250571:3:4:55:Sangle d’officier
281698:2:4:1:Sangle en cuir restaurée
281262:2:4:55:Sangle parsemée de cristaux
19995:1:0:55:Sanglier de la moisson
19107:3:2:63:Sanguinaire
6638:1:0:1:Sapta d'air
6637:1:0:1:Sapta d'eau
6636:1:0:1:Sapta de feu
6635:1:0:1:Sapta de terre
23326:1:0:1:Saucisse du solstice d'été
13891:2:15:55:Saumon blanchécaille boursouflé
23169:3:4:35:Sautoir glacé de Scorn
19805:2:15:45:Scalaire de Keefer
19431:4:4:75:Scarabée d'obstruction de Styleen
21685:4:4:76:Scarabée pétrifié
275244:4:4:65:Sceau de ceinture de qualité enhardi
272060:3:4:53:Sceau de chevaucheur implacable
272062:3:4:38:Sceau de chevaucheur implacable
274020:4:15:1:Sceau de forge-armure
275242:4:4:65:Sceau de jambes de qualité enhardi
276333:2:4:57:Sceau de la famille Sawyer
236357:2:15:61:Sceau de l’Aube de chevalier
236382:2:15:61:Sceau de l’Aube de chevalier
236393:2:15:61:Sceau de l’Aube de chevalier
236354:1:15:61:Sceau de l’Aube d’aspirant
236385:1:15:61:Sceau de l’Aube d’aspirant
236396:1:15:61:Sceau de l’Aube d’aspirant
236384:1:15:61:Sceau de l’Aube d’initié
236355:1:15:61:Sceau de l’Aube d’initié
236395:1:15:61:Sceau de l’Aube d’initié
236356:2:15:61:Sceau de l’Aube d’écuyer
236383:2:15:61:Sceau de l’Aube d’écuyer
236394:2:15:61:Sceau de l’Aube d’écuyer
271917:3:4:63:Sceau de l’expédition
271918:3:4:53:Sceau de l’expédition
271919:3:4:43:Sceau de l’expédition
271920:3:4:33:Sceau de l’expédition
275239:4:4:65:Sceau de mains de qualité enhardi
275243:4:4:65:Sceau de pieds de qualité enhardi
275240:4:4:65:Sceau de poignets de qualité enhardi
275238:4:4:65:Sceau de torse de qualité enhardi
275241:4:4:65:Sceau de tête de qualité enhardi
2933:3:4:31:Sceau de Wrynn
23025:4:4:85:Sceau des damnés
275685:2:4:59:Sceau du Service de Renseignement de Hurlevent
275229:4:4:65:Sceau d’épaules de qualité enhardi
271903:3:4:53:Sceau enrichi
271905:3:4:38:Sceau enrichi
271904:3:4:38:Sceau porte-bonheur de volontaire
271906:3:4:53:Sceau porte-bonheur de volontaire
272059:3:4:38:Sceau vaudou sombrelance
272061:3:4:53:Sceau vaudou sombrelance
17191:3:12:1:Sceptre de Celebras
281312:3:2:32:Sceptre de Dragon déchu
15863:2:2:54:Sceptre des tombes
21839:4:2:84:Sceptre du faux prophète
4122:2:2:37:Sceptre fracassant
275293:2:2:58:Sceptre peau-d’écorce
21597:4:4:81:Sceptre royal de Vek'lor
18651:1:9:52:Schéma : Altérateur de vrai-argent
11828:2:9:41:Schéma : Bombinette
18292:3:9:65:Schéma : Carabine de tireur d'élite endurci
10607:1:9:46:Schéma : Casque de scaphandrier
21730:2:9:45:Schéma : Chapelet de comètes bleues
21732:2:9:45:Schéma : Chapelet de comètes rouges
21731:2:9:45:Schéma : Chapelet de comètes vertes
21733:2:9:55:Schéma : Chapelet de grandes comètes bleues
21735:2:9:55:Schéma : Chapelet de grandes comètes rouges
21734:2:9:55:Schéma : Chapelet de grandes comètes vertes
22729:1:9:55:Schéma : Commande de chariotte à vapeur
16050:1:9:57:Schéma : Convertisseur d'arcanite délicat
18291:3:9:65:Schéma : Disque de force réactif
18650:1:9:40:Schéma : Dynamite Ev-Lan II
7561:1:9:33:Schéma : Défibrillateur gobelin
13309:1:9:24:Schéma : Espingole amoureusement construite
19027:1:9:50:Schéma : Feu d'artifice "Explosion serpentine"
18648:1:9:30:Schéma : Fusée verte
21727:2:9:35:Schéma : Grande comète bleue
21729:2:9:35:Schéma : Grande comète rouge
21728:2:9:35:Schéma : Grande comète verte
18290:3:9:60:Schéma : Hyperviseur Biznicks 247 x 128
21737:2:9:55:Schéma : Lanceur de chapelets
21738:2:9:45:Schéma : Lanceur de fusées
20001:1:9:65:Schéma : Lentille en vignesang
16046:1:9:55:Schéma : Leurre ouvragé
13310:1:9:36:Schéma : Lunette de précision
10602:1:9:42:Schéma : Lunette mortelle
20000:1:9:65:Schéma : Lunettes en vignesang
13308:1:9:31:Schéma : Pare-glace
11827:2:9:40:Schéma : Petit fumant
21724:2:9:25:Schéma : Petite comète bleue
21726:2:9:25:Schéma : Petite comète rouge
21725:2:9:25:Schéma : Petite comète verte
7742:1:9:40:Schéma : Système d'occultation gnome
16047:1:9:55:Schéma : Tube en thorium
7560:1:9:25:Schéma : Télécommande universelle gnome
239222:3:9:1:Schéma : arbuste improvisé
264232:1:9:60:Schéma : batterie rechargeable super sûre
280321:2:9:1:Schéma : baudrier fantaisiste
215432:4:9:40:Schéma : Bombe à radiations Ev-Lan
215431:4:9:40:Schéma : Bombe à radiations puissante
264237:1:9:60:Schéma : Camoufleur 52
264216:1:9:40:Schéma : cape d’urgence de terrain
279322:4:9:1:Schéma : carabine de précision hyper luxe Mod. XVII
221336:2:9:38:Schéma : Casque de mineur gobelin
280322:2:9:1:Schéma : ceinturon à gadgets
286083:2:9:25:Schéma : chapelet de fusées blanches
286084:2:9:25:Schéma : chapelet de fusées jaunes
286082:2:9:25:Schéma : chapelet de fusées violettes
280323:2:9:1:Schéma : corde cliquetante
264221:1:9:50:Schéma : couteau de l’armée gnome
269901:2:9:1:Schéma : dispositif de déploiement de bannière centaure
215156:4:9:45:Schéma : Feuille d’or hyperconductrice
274389:4:9:1:Schéma : flèche plumevive
286086:2:9:35:Schéma : grand chapelet de fusées blanches
286087:2:9:35:Schéma : grand chapelet de fusées jaunes
286085:2:9:35:Schéma : grand chapelet de fusées violettes
286080:2:9:35:Schéma : grande fusée blanche
286081:2:9:35:Schéma : grande fusée jaune
286079:2:9:35:Schéma : grande fusée violette
277470:1:9:15:Schéma : lanceur de signal de supplanteur de moissonneur
280324:2:9:1:Schéma : lanière dentelée
280328:2:9:1:Schéma : lunettes cabossées
279321:4:9:1:Schéma : lunettes d’ultra-précision SUR-T
280325:2:9:1:Schéma : lunettes molles
280326:2:9:1:Schéma : lunettes tordues
280327:2:9:1:Schéma : lunettes à bouton cassé
264236:1:9:60:Schéma : machine météorologique gnome
274390:4:9:1:Schéma : munitions de frappe rapide
215153:4:9:40:Schéma : Mur de rouages en vrai-argent
264220:1:9:50:Schéma : parachute jetable SUR-T
286077:2:9:25:Schéma : petite fusée blanche
286078:2:9:25:Schéma : petite fusée jaune
286076:2:9:25:Schéma : petite fusée violette
264235:1:9:60:Schéma : planeur gobelin ultraléger
264222:1:9:55:Schéma : plumerang
264217:1:9:45:Schéma : porte-créature compact
264234:1:9:60:Schéma : pouletisateur gnome
269903:2:9:1:Schéma : pédale en forme de sabot
215429:3:9:40:Schéma : Rouages polis en vrai-argent
212230:3:9:41:Schéma : réceptacle d’âme
285286:2:9:1:Schéma : sacoche de bombes en bronze
285285:2:9:1:Schéma : sacoche de bombes en cuivre
285287:2:9:1:Schéma : sacoche de bombes en fer
285288:2:9:1:Schéma : sacoche de bombes en sombrefer
236872:2:9:1:Schéma : senseur à censeur navrant
264233:1:9:60:Schéma : transporteur dimensionnel vers le mont Hyjal
238789:3:9:1:Schéma : transporteur semi-sécurisé – Nouvelle-Avalon
274759:3:4:55:Sculpte-chemin de Long-Guet
213583:2:12:1:Sculpture en soufre
276273:3:4:1:Seau de poissons vide
20640:2:4:45:Seau de tête des Mers du sud
209846:1:5:25:Secrets des Rêveurs
1176:1:0:8:Sels odorants
21693:4:4:75:Semblance du dévoreur
281285:2:4:11:Semelles écaillaileron
5605:1:2:10:Serpette
12795:3:2:60:Serre de sang
281256:2:4:20:Serre-tête reconverti
249441:3:4:45:Serres de la colère
9648:2:4:48:Serviette en cotte de mailles
213105:2:2:40:Shawarmageddon
18598:1:15:10:Sifflet d'orphelin humain
18597:1:15:10:Sifflet d'orphelin orc
8066:1:12:1:Sifflet de Fizzule
216492:3:15:40:Sifflet de raptor tacheté
240836:3:13:1:Sifflet de Thisalee
18246:4:15:40:Sifflet du raptor de guerre noir
46102:4:15:60:Sifflet du ravasaure peau-de-venin
19783:3:15:60:Signe du syncrétiste
275700:2:2:58:Silencieux de lanceur de glaive
281044:1:15:1:Silex et amadou de cérémonie
22420:4:4:86:Solerets de cuirassier
250563:3:4:52:Solerets de grand gardien
16569:4:4:71:Solerets de général en anneaux
250565:3:4:52:Solerets de justicier
22480:4:4:86:Solerets de la faucheuse d'os
252577:3:4:52:Solerets de mande-ciel en mailles
250564:3:4:52:Solerets de préfet
272534:4:4:65:Solerets de qualité de centurion en anneaux
272718:3:4:60:Solerets de qualité de chevalerie
274226:3:4:60:Solerets de qualité en écailles
274258:3:4:60:Solerets de qualité lamellaires
273365:3:4:60:Solerets de qualité lumineux
250562:3:4:52:Solerets de sentinelle
252579:3:4:52:Solerets de soigneur en mailles
252576:3:4:52:Solerets de traqueur en mailles
274718:2:4:57:Solerets de vétéran perdu
22358:4:15:60:Solerets désacralisés
252578:3:4:52:Solerets d’escarmouche en mailles
250561:3:4:52:Solerets d’officier
23275:3:4:66:Solerets lamellaires de chevalier-capitaine
4939:2:2:11:Solide bâtarde
1158:1:2:10:Solide masse en métal
257337:1:2:10:Solide massue en cuivre
3834:1:4:8:Solide pantalon en toile
211528:1:0:1:Sombre clairvoyance
21134:4:2:84:Sombre doloire de la démence
260186:2:2:55:Sombrelame
226546:1:4:1:Sonar du désert
23466:4:2:78:Sorcelame de grand seigneur de guerre
272683:4:2:65:Sorcelame de qualité de grand seigneur de guerre
220345:1:5:50:Sorcellerie sanguine
270085:2:2:43:Sorcépée de maître-chasseur
280456:1:15:1:Sorj Charançon
11952:1:0:55:Souffle de dragon nocturne
19118:2:2:50:Souffle de la Nature
19602:2:4:60:Souillure de Kezan
19603:3:4:60:Souillure de Kezan
19604:3:4:68:Souillure de Kezan
19605:4:4:65:Souillure irrésistible de Kezan
287964:1:0:55:Soupe de rosée matinale
8524:2:12:1:Source d'énergie modèle 4711-FTZ
205946:2:0:25:Souvenir de la trahison d’un dirigeant
205951:2:0:10:Souvenir d’un acolyte tourmenté
205905:2:0:10:Souvenir d’un champion dévoué
205940:2:0:10:Souvenir d’un noir dessein
205945:2:0:10:Souvenir d’un sauveur en captivité
208828:1:0:1:Souvenir d’un vœu brisé
20184:4:4:65:Spallière de Profanateur lamellaire
20058:4:4:65:Spallière des Hautes-terres lamellaire
271811:3:4:43:Spallières claquantes en carapace
22112:3:4:65:Spallières Cœur-Farouche
17769:2:4:47:Spallières d'armoise
22001:3:4:65:Spallières d'héroïsme
22093:3:4:65:Spallières d'Âmeforge
22467:4:4:86:Spallières de Brise-terre
16501:3:4:63:Spallières de champion en peau de dragon
23256:3:4:71:Spallières de champion en tisse-effroi
21361:4:4:78:Spallières de dispensateur de mort
16468:4:4:74:Spallières de grand maréchal en anneaux
16449:4:4:74:Spallières de grand maréchal en peau de dragon
16444:4:4:74:Spallières de grand maréchal en soie
16420:3:4:63:Spallières de lieutenant-commandant en cuir
16415:3:4:63:Spallières de lieutenant-commandant en soie
23311:3:4:71:Spallières de lieutenant-commandant en tisse-effroi
22491:4:4:86:Spallières de marcherêve
20212:4:4:65:Spallières de Profanateur en plaques
273343:4:4:65:Spallières de qualité de général en mailles
273351:4:4:65:Spallières de qualité de général en mailles annelées
272527:4:4:65:Spallières de qualité de général en pelombre
272545:4:4:65:Spallières de qualité de général rivetées
272777:4:4:65:Spallières de qualité de maréchal en mailles
274190:4:4:65:Spallières de qualité de maréchal en mailles plates
274213:4:4:65:Spallières de qualité de maréchal en mailles rivetées
272758:4:4:65:Spallières de qualité de maréchal en peau de bête
273400:4:4:65:Spallières de qualité de maréchal en peau du Rêve
273392:4:4:65:Spallières de qualité de maréchal en peau lunaire
272753:4:4:65:Spallières de qualité de maréchal en soie
274205:4:4:65:Spallières de qualité de maréchal en écailles
272729:3:4:60:Spallières de qualité en cuir
272469:3:4:60:Spallières de qualité en peau de dragon
272724:3:4:60:Spallières de qualité en soie
15698:2:4:38:Spallières de renforcement
22429:4:4:86:Spallières de rédemption
16562:4:4:74:Spallières de seigneur de guerre en cuir
16580:4:4:74:Spallières de seigneur de guerre en mailles
11871:2:4:54:Spallières de Snarkshaw
22439:4:4:86:Spallières de traqueur des cryptes
20057:4:4:65:Spallières des Hautes-terres en plaques
21330:4:4:78:Spallières du Conquérant
15792:2:4:58:Spallières du laboureur
19037:2:4:48:Spallières du pic d'Emeraude
22361:4:15:60:Spallières désacralisées
274751:2:4:45:Spallières d’insolation
281694:2:4:1:Spallières en cuir restaurées
15822:2:4:55:Spallières en peau d'ombre
22967:4:4:83:Spallières glacécaille
277220:2:4:45:Spallières miteuses
22008:3:4:65:Spallières Sombremante
274616:1:15:1:Spiritueux éthernel
20411:1:0:1:Squelette
272440:3:4:65:Stabilisateur de poigne de défense
275985:3:15:60:Statuette de hibou non souillée
287973:1:0:45:Steak de loup tendre
4952:1:0:15:Stormstout
20388:1:0:55:Sucette
17182:5:2:80:Sulfuras, Main de Ragnaros
289295:5:2:45:Sulfuras, Main de Ragnaros
22278:1:4:1:Superbe robe bleue
22276:1:4:1:Superbe robe rouge
22280:1:4:1:Superbe robe violette
210043:1:12:1:Symbole de la deuxième chouette
210044:1:12:1:Symbole de la première chouette
210026:1:12:1:Symbole de la troisième chouette
6866:1:12:12:Symbole de vie
221315:3:4:60:Symboles de voyage
15197:1:4:20:Tabard d'éclaireur
19506:1:4:20:Tabard de bataille Aile-argent
19505:1:4:20:Tabard de bataille chanteguerre
20132:1:4:20:Tabard de bataille d'Arathor
276504:1:4:20:Tabard de bataille de Theramore
20131:1:4:20:Tabard de bataille des Profanateurs
19032:1:4:20:Tabard de bataille foudrepique
19031:1:4:20:Tabard de bataille loup-de-givre
276502:1:4:20:Tabard de bataille sombrelance
11364:1:4:1:Tabard de Hurlevent
22999:1:4:60:Tabard de l'Aube d'argent
262765:1:4:20:Tabard de l’Administration commerciale d’Azeroth
285352:4:4:1:Tabard de l’exploration éternelle
281631:1:4:1:Tabard de l’édition Collector
191481:4:4:1:Tabard de Maîtrise
15196:1:4:20:Tabard de soldat
272694:1:4:20:Tabard de soldat
274025:1:4:1:Tabard des Gardiens d’Hyjal
262764:1:4:20:Tabard des Transports logistiques Durotar
275042:1:4:20:Tabard du donjon de Fort-Lointain
285327:1:4:1:Tabard du Kirin Tor
19160:1:4:1:Tabard du vainqueur de l'affrontement
277717:3:4:1:Tabard d’ours spectral
272449:1:4:20:Tabard d’éclaireur
19722:4:12:1:Tabard primordial hakkari
280729:1:4:1:Tabard shen’dorei
280404:1:4:1:Tabard « Lordaeron pour toujours »
280449:1:4:20:Tabard éolide
260205:2:4:55:Tablette de recherches de Bien-né
6801:2:4:40:Tablier baroque
19806:2:15:45:Talang dezien
23053:4:4:92:Talisman bouillonnant de Stormrage
19406:4:4:75:Talisman croc-de-drake
20071:3:4:63:Talisman d'Arathor
21117:3:4:53:Talisman d'Arathor
21118:3:4:43:Talisman d'Arathor
21119:3:4:33:Talisman d'Arathor
22678:4:4:60:Talisman d'ascendance
15856:3:4:60:Talisman de grande lumière
19614:2:4:60:Talisman de l'ombre zandalarien
19615:3:4:60:Talisman de l'ombre zandalarien
19616:3:4:68:Talisman de l'ombre zandalarien
17782:5:4:80:Talisman de l'éclat de lien
19617:4:4:65:Talisman de maîtrise de l'ombre zandalarien
19377:4:4:83:Talisman de perfidie de Prestor
18820:4:4:66:Talisman de pouvoir éphémère
21115:3:4:53:Talisman de profanateur
21116:3:4:43:Talisman de profanateur
21120:3:4:33:Talisman de profanateur
18406:4:4:65:Talisman de sang d'Onyxia
276337:2:4:59:Talisman de Thaelemaches
19213:2:12:1:Talisman de vaillance d'Aile-argent
17783:5:4:80:Talisman du fragment de lien
20072:3:4:63:Talisman du Profanateur
4430:2:4:43:Talisman éthéré
211816:1:0:1:Tambour de bataille chanteguerre
18240:2:7:1:Tanin ogre
263329:2:2:9:Tapette à voltemouches
15865:2:4:39:Targe d'Anchorhold
6746:2:4:40:Targe de basalte
4937:1:4:9:Targe de charge
3743:2:4:28:Targe de factionnaire
7748:2:4:45:Targe de Forcestone
3276:1:4:5:Targe de Garde noir
257336:1:4:10:Targe de garde-paix
4115:2:4:37:Targe de Grom'gol
2249:1:4:10:Targe de la milice
4975:2:4:39:Targe de vigilance
1557:2:4:20:Targe des Mers
5593:1:4:11:Targe des rochers
3160:2:4:15:Targe doublée de fer
6676:2:4:27:Targe du connétable
6828:2:4:38:Targe du visionnaire
1276:2:4:27:Targe en acier trempé
5302:2:4:20:Targe en cobalt
5940:1:4:12:Targe en os
2900:1:4:10:Targe en pierre
4911:1:4:5:Targe en écorce épaisse
281307:2:4:31:Targe gueule-de-dragon
3763:2:4:40:Targe lunaire
281731:2:4:1:Targe restaurée
23435:1:0:1:Tarte au sureau
251917:1:0:5:Tarte maison de Falorne
208833:1:0:1:Tarte malveillante
19803:2:15:45:Tassergal à dos rayé
23175:1:0:55:Tasty Summer Treat
221199:1:0:1:Teinture de satyrienne
16997:3:2:62:Tempétueuse
18705:4:12:71:Tendon de dragon noir adulte
18724:4:12:71:Tendon de dragon noir enchanté
21579:4:4:88:Tentacule de C'Thun vaincu
288185:1:15:1:Tente d'aventurier
21237:4:15:60:Tenue de parade impériale qiraji
219405:1:12:25:Texte de l’ogre magi
7868:1:15:16:Thieven' Kit
16622:2:2:57:Thornflinger
15723:2:0:60:Thé sucré
21348:4:4:81:Tiare de l'oracle
19902:4:15:60:Tigre zulien rapide
16993:2:2:60:Tire-flammes de Smokey
277255:2:2:12:Tireur égaré
1972:1:12:8:Titre de propriété de la marche de l'Ouest
3898:1:12:1:Titre du Bibliothécaire
13153:1:0:1:Tom de Mal'cin Vorail
1383:1:2:5:Tomahawk
3443:1:2:10:Tomahawk de cérémonie
13149:1:0:1:Tome d'invocation Eldarathian Vol. 1
275989:2:15:1:Tome de Dalaran
23468:4:4:78:Tome de destruction de grand seigneur de guerre
272685:4:4:65:Tome de destruction de qualité de grand seigneur de guerre
6775:1:12:12:Tome de divinité
6916:1:12:12:Tome de divinité
19308:4:4:60:Tome de domination des arcanes
19309:4:4:60:Tome de force d'ombre
237041:2:9:60:Tome de fusée éclairante enchantée
23469:4:4:78:Tome de guérison de grand seigneur
272686:4:4:65:Tome de guérison de qualité de grand seigneur de guerre
19311:4:4:60:Tome de l'arcane ardente
6777:1:12:20:Tome de piété
23452:4:4:78:Tome de puissance de connétable
278158:4:4:65:Tome de puissance de qualité de connétable
23453:4:4:78:Tome de restauration de connétable
278157:4:4:65:Tome de restauration de qualité de connétable
16665:2:9:60:Tome de Tir tranquillisant
6776:1:12:20:Tome de valeur
19989:3:4:52:Tome des ombres dévorantes
280943:1:15:15:Tome des techniques de forge de la famille Tremayne
18602:3:4:60:Tome du Sacrifice
19310:4:4:60:Tome du Seigneur de glace
204905:1:15:1:Tome inquiétant
207731:1:15:1:Tome inquiétant
207974:1:15:1:Tome inquiétant
208139:1:15:1:Tome inquiétant
276561:1:12:1:Tome noir
274935:1:0:45:Tonique de Tessa
17223:4:2:63:Tonitruante
1262:1:0:15:Tonneau de Tonnebière
4926:1:12:11:Tonneau vide de Chen
1172:2:4:21:Torche de Grayson
7344:2:4:33:Torche de la sainte flamme
2808:1:2:29:Torche des Flammes
287627:3:4:1:Torque ambré de maître-lame
23023:4:4:83:Torque de sadique
21582:4:4:88:Torsade  du Dieu très ancien
21607:4:4:81:Torsade de l'empereur déchu
286724:4:15:60:Tortue de mer verdoyante
23720:1:15:20:Tortue de monte
272433:3:4:65:Totem ardent
1131:2:4:25:Totem d'affliction
5178:1:15:30:Totem d'air
5177:1:15:20:Totem d'eau
208843:1:0:1:Totem de bataille
5176:1:15:10:Totem de feu
23005:4:4:83:Totem de l'eau courante
272432:3:4:65:Totem de l’orage
249443:3:4:45:Totem de protection ancestrale
263436:2:4:10:Totem de tempête de feu
5175:1:15:4:Totem de terre
22396:4:4:78:Totem de vie
263412:2:4:10:Totem des flammes chargées
272431:3:4:65:Totem des marées
228176:3:4:65:Totem du tonnerre
210253:2:0:15:Totem putride
20741:1:15:45:Totem rituel mort-bois
20742:1:15:50:Totem rituel tombe-hiver
274420:3:2:58:Totem sage-patte
19342:4:4:76:Totem venimeux
16769:2:2:52:Totem-médecine furbolg
21695:4:4:75:Toucher d'Angelista
19315:4:4:60:Toucher de Therazane
18143:1:12:60:Touffe de cheveux de gnome
275957:1:15:60:Touffe de fourrure de renard
5340:2:2:15:Touille-chaudron
11854:2:2:19:Tournevis Samophlange
274753:3:2:45:Tournevis égaré de Jhordy
281030:1:12:1:Traité d’entente
11907:2:2:55:Tranche-bêtes
270069:2:2:41:Tranche-esprit
9521:2:2:41:Tranche-tête
22378:3:2:65:Trancheur de Ravenholdt
277243:3:2:45:Tranchoir plaiedargent
282284:2:2:10:Tranchoir tissebois
17073:4:2:66:Trembleterre
5757:2:2:20:Trique de bois dur
231845:1:0:1:Troisième fragment de cachet
212568:3:0:60:Trophée tête-de-loup
18243:4:15:40:Trotteur de bataille noir
15446:1:12:1:Trousse d'adjoint de Hurlevent
221018:1:15:1:Trousse de secours de terrain
20453:1:12:1:Trousse de transcription du géologue
8366:2:15:35:Truite tête-mithril boursouflée
23162:1:1:60:Très grand sac
10569:1:15:50:Trésor du Vol noir
220446:2:0:15:Trésor venu d’ailleurs
223148:2:0:25:Trésor venu d’ailleurs
223149:2:0:35:Trésor venu d’ailleurs
223150:2:0:45:Trésor venu d’ailleurs
223151:2:0:55:Trésor venu d’ailleurs
224836:2:0:45:Trésor venu d’ailleurs
224848:2:0:45:Trésor venu d’ailleurs
224849:2:0:45:Trésor venu d’ailleurs
224850:2:0:45:Trésor venu d’ailleurs
224851:2:0:45:Trésor venu d’ailleurs
228615:2:0:60:Trésor venu d’ailleurs
11951:1:0:55:Tubercule de navetille
9520:2:2:41:Tueuse muette
19042:2:4:48:Tunique artisanale de Jangdor
19041:2:4:48:Tunique artisanale de Pratt
3585:2:4:22:Tunique camouflée
19127:2:4:50:Tunique carbonisée en cuir
5341:2:4:15:Tunique couverte de spores
19838:4:4:65:Tunique d'haruspice zandalar
19834:4:4:65:Tunique d'insensé zandalar
12104:2:4:60:Tunique d'épines tavelées
252508:3:4:27:Tunique de bagarreur en cuir
22060:4:4:60:Tunique de belluaire
22464:4:4:92:Tunique de Brise-terre
11851:1:4:5:Tunique de charognard
4119:2:4:43:Tunique de chasseur de raptors
16421:3:4:63:Tunique de chevalier-capitaine en peau de dragon
23303:3:4:68:Tunique de chevalier-capitaine en satin
23305:3:4:68:Tunique de chevalier-capitaine en soie
23297:3:4:68:Tunique de chevalier-capitaine en tisse-effroi
252510:3:4:27:Tunique de chevaucheur de tempête en cuir
252450:3:4:27:Tunique de défenseur en cuir
6085:2:4:13:Tunique de fantassin
10827:2:4:48:Tunique de géomètre
22885:3:4:68:Tunique de légionnaire en satin
22886:3:4:68:Tunique de légionnaire en soie
22884:3:4:68:Tunique de légionnaire en tisse-effroi
22488:4:4:92:Tunique de marcherêve
5317:2:4:25:Tunique de mousse sèche
5316:2:4:25:Tunique de nacrécorce
277221:2:4:45:Tunique de naturaliste du Totem-sinistre
281324:2:4:17:Tunique de navigation
272730:3:4:60:Tunique de qualité en peau de bête
273380:3:4:60:Tunique de qualité en peau du Rêve
273371:3:4:60:Tunique de qualité en peau lunaire
272634:3:4:60:Tunique de qualité soyeuse
17005:2:4:27:Tunique de rustre
22425:4:4:92:Tunique de rédemption
11876:2:4:56:Tunique de rôdeur des plaines
252511:3:4:27:Tunique de sagesse en cuir
252509:3:4:27:Tunique de trappeur en cuir
22436:4:4:92:Tunique de traqueur des cryptes
4138:2:4:45:Tunique des Flots noirs
60:1:4:5:Tunique doublée
7335:2:4:28:Tunique du grizzly
9515:2:4:31:Tunique du Néant
22350:4:15:60:Tunique désacralisée
263332:2:4:13:Tunique d’ancien
281695:2:4:1:Tunique en cuir restaurée
2817:2:4:12:Tunique en cuir souple
275708:3:4:61:Tunique en peau de Ghansurok
274938:2:4:40:Tunique en peau de Gnoll
257274:1:4:5:Tunique fluide
4907:1:4:5:Tunique forestière
20642:2:4:47:Tunique noble antique
275832:2:4:57:Tunique plume-de-corbeau
22009:4:4:60:Tunique Sombremante
252451:3:4:27:Tunique totémique en cuir
21039:1:4:1:Turban de Narain
21517:4:4:75:Turban gnome de puissance psychique
275701:2:2:58:Tuyau plaqué en cuivre
231877:3:4:1:Tyler's Balanced Bobble
280438:1:15:1:Tête abominable
18142:1:12:60:Tête coupée d'elfe de la nuit
12534:1:12:1:Tête d'Omokk
18422:4:12:60:Tête d'Onyxia
18423:4:12:60:Tête d'Onyxia
21220:4:12:60:Tête d'Ossirian l'Intouché
13250:1:12:1:Tête de Balnazzar
207062:1:15:1:Tête de centaure coupée
207975:1:15:1:Tête de chauve-souris coupée
208610:1:15:1:Tête de chouette coupée
247826:1:12:1:Tête de Coassie
270332:1:15:1:Tête de Fredd
204478:1:15:1:Tête de Gnoll coupée
206995:1:15:1:Tête de harpie coupée
206994:1:15:1:Tête de huran coupée
204476:1:15:1:Tête de Kobold coupée
268559:1:12:7:Tête de léopard
221260:1:15:1:Tête de l’Oblitérateur
204477:1:15:1:Tête de Murloc coupée
19002:4:12:60:Tête de Nefarian
19003:4:12:60:Tête de Nefarian
227911:1:12:1:Tête de Rend Main-noire
270436:1:12:1:Tête de Rudolph Gelhardt
271612:1:12:1:Tête de Scaldaron
271613:1:12:1:Tête de Scaldaron
16304:2:12:20:Tête de Shadumbra
208611:1:15:1:Tête de tigre coupée
4953:1:0:17:Tête de Trogg
208159:1:15:1:Tête de troll coupée
5138:1:12:10:Tête du moissonneur
208612:1:15:1:Tête d’araignée coupée
247862:1:12:1:Tête d’Ormepatte
260210:3:4:56:Un bouclier plus grand
286210:1:15:1:Un cadeau du Voile d’hiver
22975:1:12:45:Un document taché
220352:1:5:50:Un esprit métallique
11116:2:15:48:Un journal abîmé
6755:1:15:25:Un petit coffre de gemmes
5335:1:15:18:Un sac de pièces
15902:1:15:55:Un sac miraculeux
215816:1:5:25:Un tissage de mensonges : mythes et légendes démystifiés
2794:1:12:20:Un vieux livre d'histoire
10456:1:15:15:Une bourse rebondie
22970:1:12:45:Une enveloppe tachée de sang
18513:4:12:1:Une lame elfique inachevée
228695:4:12:1:Une lame elfique inachevée
22977:1:12:45:Une lettre déchirée
2839:1:12:4:Une lettre pour Yvette
2874:1:12:16:Une lettre qui n'a pas été envoyée.
276897:3:4:38:Une leçon de destruction
22973:1:12:45:Une missive froissée
11446:1:12:50:Une note chiffonnée
22972:1:12:45:Une note détériorée
265932:1:12:50:Une note imprégnée de sang
10664:1:12:45:Une note pour le magus Rimtori
22974:1:12:45:Une page abîmée
11883:1:15:56:Une sacoche surprise
3317:1:12:12:Une tête qui parle
22746:2:15:1:Uniforme de boucanier
210955:1:15:1:Uniforme d’initié écarlate
221316:1:4:55:Uniforme exigeant de Premo
10773:2:15:1:Urne hakkari
19610:2:4:60:Varech enchanté des Mers du sud
19611:3:4:60:Varech enchanté des Mers du sud
19612:3:4:68:Varech enchanté des Mers du sud
19613:4:4:65:Varech enchanté des Mers du sud en parfait état
276754:3:4:55:Veille de Fracécorce
213529:1:15:40:Venin visqueux
272783:4:4:65:Ventaille de qualité de grand maréchal de chevalerie
273332:4:4:65:Ventaille de qualité de grand maréchal lumineuse
274239:4:4:65:Ventaille de qualité de seigneur de guerre en écailles
274253:4:4:65:Ventaille lamellaire de qualité de seigneur de guerre
11569:1:12:1:Viande de battrodon préservée
225942:1:15:1:Viande de sanglier contaminée
4957:1:1:5:Vieille bourse
221498:1:1:35:Vieille boîte à outils
2173:1:4:5:Vieille ceinture en cuir
221497:1:13:1:Vieille clé
4881:1:12:1:Vieille enveloppe
11463:2:12:40:Vieux colis
276896:3:15:1:Vin chatoyant de Lune-d’Argent éternel
276903:2:2:52:Vin chatoyant perforeur
276904:2:4:52:Vin chatoyant spirituel
18833:4:2:78:Viseur de connétable
272841:4:2:65:Viseur de qualité de connétable
19606:2:4:60:Vision de Voodress
19607:3:4:60:Vision de Voodress
19608:3:4:68:Vision de Voodress
19609:4:4:65:Vision limpide de Voodress
213599:2:0:10:Vision troublante
277235:2:4:45:Visière de soldat
6739:2:2:29:Visée du rôdeur
11513:1:12:1:Vitriol contaminé
23456:4:2:78:Vivelame de connétable
272859:4:2:65:Vivelame de qualité de connétable
260168:2:4:52:Voile de deuil
16424:3:4:63:Voile de lieutenant-commandant en peau de dragon
272727:3:4:60:Voile de qualité en cuir
272733:3:4:60:Voile de qualité en peau de bête
21412:4:4:67:Voile de sagesse infinie
21418:4:4:67:Voile des noms inexprimés
9685:2:2:51:Volonté du géant des montagnes
10652:2:2:51:Volonté du géant des montagnes
18869:4:2:78:Vouge de connétable
220350:1:5:50:Voyages venimeux
19618:2:4:60:Vrille du maelström
19619:3:4:60:Vrille du maelström
19620:3:4:68:Vrille du maelström
277514:2:4:33:Vêtements rapiécés d’Aka’rai
211941:3:2:66:Yari de marche-vent
15778:2:0:58:Yéti mécanique
232652:4:13:60:Zila Amanemodas
208743:1:15:1:Âme de cupidité
231800:1:15:1:Âme de Des’Altek
231799:1:15:1:Âme de dévoreur
209045:1:15:1:Âme de la mer
231792:1:15:1:Âme de malice
231797:1:15:1:Âme du Vide
231798:1:15:1:Âme d’ensorcellement
221978:1:15:10:Âme d’explorateur
18799:1:12:1:Âme rachetée du destrier
270270:2:4:38:Écaille du Courbe-Marée
280459:1:12:1:Écaille imprégnée de cristaux
274776:1:12:1:Échantillon de racine non infecté
221019:1:15:1:Échantillon de satyrienne
209043:1:15:1:Échantillon de terre fertile
253887:3:4:15:Écharpe ardente de novice
253935:3:4:22:Écharpe brillante
263402:2:4:11:Écharpe de chagrin
272748:4:4:65:Écharpe de qualité de chevalier-capitaine en soie
272809:4:4:65:Écharpe de qualité de chevalier-capitaine en tisse-effroi
272825:4:4:65:Écharpe de qualité de chevalier-capitaine en étoffe du Vide
273428:4:4:65:Écharpe de qualité de chevalier-capitaine en étoffe lunaire
272502:4:4:65:Écharpe de qualité de magus légionnaire
272566:3:4:60:Écharpe de qualité en satin
272700:3:4:60:Écharpe de qualité en soie
275437:3:4:60:Écharpe de qualité soyeuse
244228:1:4:1:Écharpe de sage pompette
253929:3:4:22:Écharpe des flammes
253885:3:4:15:Écharpe d’arcaniste novice
253925:3:4:22:Écharpe immaculée
253933:3:4:22:Écharpe nacrée
253931:3:4:22:Écharpe ombreuse
253927:3:4:22:Écharpe soyeuse
226208:1:15:1:Écho de Barthilas
226209:1:15:1:Écho de Dathrohan
206985:2:0:5:Écho de l’alpha
226210:1:15:1:Écho de Maleki
226211:1:15:1:Écho de Nerub’enkan
215428:1:15:1:Écho de Theramore
226213:1:15:1:Écho de Vaillefendre
226214:1:15:1:Écho de Willey
210589:2:0:1:Écho des ancêtres
215426:1:15:1:Écho du cimetière
215425:1:15:1:Écho du marécage
226207:1:15:1:Écho d’Anastari
215427:1:15:1:Écho d’Arathi
226212:1:15:1:Écho d’Ymiron
191660:3:0:1:Éclairs de Thaddius
277178:3:15:1:Éclat chagriné corrompu
277172:3:15:1:Éclat de Froidhurle corrompu
277175:3:15:1:Éclat de Griffe-nouée corrompu
277174:3:15:1:Éclat de la Tisseffroi corrompu
239011:5:7:60:Éclat de lumière cristallisée
228749:4:12:71:Éclat de Nordrassil
10659:2:4:57:Éclat des Sabots-Fendus
277179:3:15:1:Éclat d’Améthrax corrompu
281587:3:2:60:Écorcheuse de Largeflanc
274744:3:2:25:Écraseur des Tarides
277245:3:2:45:Écraseur maréchine
268579:1:15:1:Écu de Lordaeron
275521:1:15:1:Écu de Lordaeron
266428:1:12:50:Écu du maréchal Ryan
277258:3:4:45:Écu d’élucidation
280347:1:15:10:Écureuil trombenoire
263431:2:4:10:Égide de défense
272838:4:4:65:Égide de qualité de connétable
210712:1:0:1:Élixir de clairvoyance
274922:1:0:38:Émanations du marécage des rives Claires
229894:2:12:1:Émeraude de rêve
276280:1:15:1:Énorme sac de pièces
273415:4:4:65:Épaulettes de qualité de général en cuir de kodo
272516:4:4:65:Épaulettes de qualité de général en peau de dragon
273407:4:4:65:Épaulettes de qualité de général en peau de wyrm
272766:4:4:65:Épaulettes de qualité de maréchal en cuir
272732:3:4:60:Épaulettes de qualité en peau de bête
277212:2:4:45:Épaulettes tissâme
287628:3:4:1:Épaulières ambrées de maître-lame
254053:3:4:47:Épaulières de flamme-du-Néant
252535:3:4:47:Épaulières de furtivité en cuir
252536:3:4:47:Épaulières de garde en cuir
270039:2:4:29:Épaulières de griffe de raptor
254059:3:4:47:Épaulières de lumière-du-Néant
252537:3:4:47:Épaulières de mande-ciel en cuir
252567:3:4:47:Épaulières de mande-ciel en mailles
254055:3:4:47:Épaulières de perle-du-Néant
272745:3:4:60:Épaulières de qualité de chevalerie
272533:4:4:65:Épaulières de qualité de général en anneaux
272509:4:4:65:Épaulières de qualité de général en plaques cimentières
272804:4:4:65:Épaulières de qualité de maréchal en tisse-effroi
272640:3:4:60:Épaulières de qualité en anneaux
272642:3:4:60:Épaulières de qualité en cuir de kodo
274181:3:4:60:Épaulières de qualité en mailles plates
273387:3:4:60:Épaulières de qualité en peau de wyrm
273375:3:4:60:Épaulières de qualité en peau du Rêve
272670:3:4:60:Épaulières de qualité en peau lunaire
272637:3:4:60:Épaulières de qualité en plaques cimentières
272549:3:4:60:Épaulières de qualité en tisse-gangrène
274233:3:4:60:Épaulières de qualité en écailles
274247:3:4:60:Épaulières de qualité lamellaires
272855:3:4:60:Épaulières de qualité lumineuses
272489:3:4:60:Épaulières de qualité rivetées
252534:3:4:47:Épaulières de rôdeur en cuir
252538:3:4:47:Épaulières de soigneur en cuir
252569:3:4:47:Épaulières de soigneur en mailles
252566:3:4:47:Épaulières de traqueur en mailles
252568:3:4:47:Épaulières d’escarmouche en mailles
254049:3:4:47:Épaulières d’or-du-Néant
254057:3:4:47:Épaulières d’éclat-du-Néant
254051:3:4:47:Épaulières d’écume-du-Néant
281710:2:4:1:Épaulières en plaques restaurées
281686:2:4:1:Épaulières en tissu restaurées
281277:2:4:50:Épaulières tueuses d’écailles
213143:2:0:40:Épiphanie apocryphe
228126:2:0:60:Épiphanie apéritive
210822:2:0:25:Épiphanie harmonieuse
228123:2:0:60:Épiphanie jubilatoire
213144:2:0:40:Épiphanie lumineuse
221481:2:0:50:Épiphanie nihiliste
228124:2:0:60:Épiphanie onirique
212552:2:0:40:Épiphanie psychosophique
205944:2:0:10:Épiphanie réciproque
221488:2:0:50:Épiphanie résolue
205950:2:0:25:Épiphanie ténébreuse
281728:2:2:1:Épée courte restaurée
248006:2:2:12:Épée de la milice
281145:1:15:1:Épée de Silvia
271795:2:2:38:Épée large d’errance
272693:4:2:65:Épée longue de qualité de connétable
281729:2:2:1:Épée longue restaurée
276886:2:2:24:Épée trophée de Chol’aruk
269777:1:12:1:Étinceleur à déclenchement rapide
280179:1:12:1:Étiquette d’envoi
280180:1:12:1:Étiquette d’envoi
220348:1:5:50:Étiquette quotidienne
274165:1:12:60:Étoffe d’éternité
281660:2:2:27:Étoile de fer
270106:2:2:50:Étoiles de lancer cruelles
228135:1:5:60:Étude de la Lumière
223337:2:12:50:Œil brûlant
210953:1:12:25:Œil de Bhossca
275630:2:4:58:Œil d’influence épuisé
223334:2:12:50:Œil luminescent
223330:2:12:50:Œil palpitant
223331:2:12:50:Œil palpitant
223336:2:12:50:Œil perçant
223335:2:12:50:Œil suintant
223333:2:12:50:Œil torve
223332:2:12:50:Œil vibrant
208682:1:15:1:Œuf abandonné de gueule d’acier
219520:1:12:50:Œuf de dragon lueur-de-lune
219447:1:12:40:Œuf de dragon touché par le rêve
219488:1:12:50:Œuf de dragon touché par les étoiles
219406:1:12:25:Œuf de dragon vert non éclos
274956:1:15:1:Œuf de poule sauvage
221544:1:15:1:Œuf du corbeau des tempêtes
]==]
