
--[[
	Nando revamp 01/04/2023
]]

local disabledUpgrades = {
	 [1142] = true,
	 [1109] = true,
	 [1008] = true,
	 [1009] = true,
	 [1010] = true,
	 [1158] = true,
 }
 
 local restricted_skins = {
	 [71] = true,
	 [265] = true,
	 [266] = true,
	 [267] = true,
	 [274] = true,
	 [275] = true,
	 [276] = true,
	 [277] = true,
	 [278] = true,
	 [279] = true,
	 [275] = true,
	 [280] = true,
	 [281] = true,
	 [282] = true,
	 [283] = true,
	 [284] = true,
	 [285] = true,
	 [286] = true,
	 [287] = true,
	 [288] = true,
	 [300] = true,
  }
  
bandanas = nil

 function getRestrictedSkins()
	 return restricted_skins
 end
 
 function getDisabledUpgrades()
	 return disabledUpgrades
 end
 local wheelPrice = 2500
 local priceReduce = 1


--[[
	item description is now optional, will be fetched from item-system/g_items.lua if not specifed - Nando
]]
g_shops = {
	 { -- 1
		 name = "General Store",
		 description = "Vous trouverez l'essentiel dont vous avez besoin.",
		 image = "general.png",
 
		 {
			 name = "General",
			 --{ name = "Lottery Ticket", description = "A ticket that can make you or break you.", price = 75, itemID = 68, itemValue = nil, minimum_age = 18 },
			 { name = "Fleurs", description = "Un très beau bouquet de fleurs.", price = 5, itemID = 115, itemValue = 14 },
			 { name = "Annuaire", description = "Un annuaire avec les nuémros de téléphone importants.", price = 30, itemID = 7 },
			 { name = "Dé", description = "Un dé avec 6 faces. Parfait pour jouer.", price = 2, itemID = 10, itemValue = 1 },
			 { name = "Dé à 20 faces", description = "Un dé avec 20 faces.", price = 5, itemID = 10, itemValue = 20 },
			 --{ name = "Club de Golf", description = "Parfait pour frapper ce hole-in-one.", price = 60, itemID = 115, itemValue = 2 },
			 { name = "Batte de Baseball", description = "Pour frapper un Home Run.", price = 900, itemID = 115, itemValue = 5 },
			 --{ name = "Pelle", description = "Outil parfait pour creuser un trou.", price = 40, itemID = 115, itemValue = 6 },
			 --{ name = "Queue de Billard", description = "Pour frapper ces bonnes boules bien dures.", price = 35, itemID = 115, itemValue = 7 },
			 --{ name = "Canne", description = "Pour vous aider à marcher.", price = 65, itemID = 115, itemValue = 15 },
			 --{ name = "Extincteur", description = "Utile en cas d'incendie.", price = 50, itemID = 115, itemValue = 42 },
			 --{ name = "Bombe à graffiti", description = "Promet moi de pas faire de tag avec ça!", price = 50, itemID = 115, itemValue = 41 },
			 { name = "Parachute", description = "Si vous ne voulez pas manger le sol, vous feriez mieux d'en acheter un", price = 400, itemID = 115, itemValue = 46 },
			 { name = "Guide de la Ville", description = "Un petit guide de la ville, pas très à jour.", price = 15, itemID = 18 },
			 { name = "Masque", description = "Une cagoule.", price = 20, itemID = 56 },
			 { name = "Bidon d'essence", description = "Un large Jerrican en métal.", price = 50, itemID = 57, itemValue = 0 },
			--  { name = "Trousse de secours", description = "Sauve une vie.", price = 15, itemID = 70, itemValue = 3 },
			 { name = "Papiers (pour Cigarette)", description = "Papiers pour votre cigarette.", price = 10, itemID = 181, itemValue = 20 },
			 { name = "Bloc-Notes (petit)", description = "Possibilité d'écrire 5 notes.", price = 10, itemID = 71, itemValue = 5 },
			 { name = "Bloc-Notes (moyen)", description = "Possibilité d'écrire 50 notes.", price = 15, itemID = 71, itemValue = 50 },
			 { name = "Bloc-Notes (grand)", description = "Possibilité d'écrire 125 notes.", price = 20, itemID = 71, itemValue = 125 },
			 { name = "Vieux Casque", description = "Un casque couramment utilisé par les personnes à vélo/moto.", price = 100, itemID = 90 },
			 { name = "Casque Moto-Cross", description = "Un casque couramment utilisé par les personnes à moto.", price = 100, itemID = 171},
			 { name = "Casque de Motard", description = "Un casque couramment utilisé par les personnes à moto.", price = 100, itemID = 172},
			 { name = "Paquet de Cigarettes", description = "Fumer tue!", price = 10, itemID = 105, itemValue = 20, minimum_age = 18 },
			 { name = "Briquet", description = "Pour enflammer vos addictions..", price = 45, itemID = 107 },
			-- { name = "Couteau", description = "Un parfait outil de cuisine.", price = 15, itemID = 115, itemValue = 4 },
			 { name = "Paquet de Cartes", description = "Un jeu de cartes.", price = 10, itemID = 77 },
			 { name = "Malette", description = "Une petite malette en cuir.", price = 75, itemID = 160},
			 { name = "Sac à Dos", description = "Un sac à dos de taille moyenne.", price = 30, itemID = 48 },
			 { name = "Sac de Sport", description = "Un sac de sport.", price = 60, itemID = 163},
			 { name = "Livre vierge", description = "Ecrivez votre propre histoire.", price = 40, itemID = 178, itemValue = "New Book"},
			 { name = "Cadenas pôur vélo", description = "Vous permet de verrouiller votre vélo.", price = 250, itemID = 275, itemValue = 1},
		 },
		 {
			 name = "Consommables",
			 { name = "Sandwich", description = "Un délicieux sandwich au fromage.", price = 6, itemID = 8 },
			 { name = "Canette Sprunk", description = "Une canette de Sprunk.", price = 3, itemID = 308 },
			 { name = "Cookie", description = "A luxuty chocolate chip cookie", price = 3, itemID = 14 },
			 { name = "Canette eCola", description = "", price = 3, itemID = 309 },
			 { name = "Canette eCola Zero", description = "", price = 3, itemID = 311 },
			 { name = "Canette Sprunk Extreme", description = "", price = 3, itemID = 310 },
			 { name = "Bouteille d'E-Cola", description = "", price = 3, itemID = 313 },
			 { name = "Bouteille d'eau", description = "", price = 1, itemID = 15, itemValue = 2 },
			 { name = "Bouteille de Sprunk", description = "", price = 3, itemID = 312 },
			 { name = "Pack de bière Pisswasser", description = "", price = 50, itemID = 314 },
			 { name = "Pack de bière Corona", description = "", price = 50, itemID = 315 },
			 { name = "Pack de bière Heineken", description = "", price = 50, itemID = 316 },
		 },
	 },
	 { -- 2
		 name = "Ammunation",
		 description = "Tout ce qu'il vous faut, depuis 1914.",
		 image = "gun.png",
 
		 {
			 name = "Armes & Munitions",
			 { name = "Colt-45 Pistol", description = "A silver Colt-45.", price = 8500, itemID = 115, itemValue = 22, license = true, license_type = 1 },
			 { name = "Desert Eagle Pistol", description = "A shiny Desert Eagle.", price = 12500, itemID = 115, itemValue = 24, license = true, license_type = 1 },
			 { name = "Shotgun", description = "A silver shotgun.", price = 14000, itemID = 115, itemValue = 25, license = true, license_type = 2 },
			 { name = "Country Rifle", description = "A country rifle.", price = 20000, itemID = 115, itemValue = 33, license = true, license_type = 2 },
			 { name = "9mm Ammopack", description = "Cartridge: 9mm, Compactible with Colt 45, Silenced, Uzi, MP5, Tec-9. Bullet Style: Flex Tip Expanding (FTX), Bullet Weight: 7.45 grams, Application: Self Defense.", price = 900, itemID = 116, itemValue = 1, ammo = 25, license = true, license_type = 1 },
			 { name = ".45 ACP Ammopack", description = "Cartridge: .45 ACP, Compactible with Deagle. Bullet Style: Full Metal Jacket (FMJ), Metal Case (MC), Bullet Weight: 11.99 grams, Application: Target, Competition, Training.", price = 1110, itemID = 116, itemValue = 4, ammo = 20, license = true, license_type = 1 },
			 { name = "12 Gauge Ammopack", description = "Cartridge: 12 Gauge, Compactible with Shotgun, Sawed-off, Combat Shotgun. Bullet Style: Factory-style, Bullet Weight: 31.89 grams, Application: Target, Hunting.", price = 1300, itemID = 116, itemValue = 5, ammo = 20, license = true, license_type = 2 },
			 { name = "7.62mm Ammopack", description = "Cartridge: 7.62mm, Compactible with AK-47, Rifle, Sniper, Minigun. Bullet Style: Full Metal Jacket (FMJ), Bullet Weight: 9.66 grams, Application: Practice, Target, Training.", price = 1650, itemID = 116, itemValue = 2, ammo = 30, license = true, license_type = 2 },
			 --{ name = "5.56mm Ammopack", description = "Cartridge: 5.56mm, Compactible with M4. Bullet Style: Full Metal Jacket (FMJ), Bullet Weight: 4.02 grams, Application: Law Enforcement, Plinking.", price = 600, itemID = 116, itemValue = 3, ammo = 30, license = true },
		 }
	 },
	 { -- 3
		 name = "Food Store",
		 description = "De la bonne nourriture. Tout ce qu'il vous faut pour vous remplir la pence.",
		 image = "food.png",
 
		 {
			 name = "Nourriture",
			 -- { name = "Pizza Margherita", description = "Mmh, my pizza!!", price = 10, itemID = 89, itemValue = "Pizza Margherita" },
			 -- { name = "Pizza 4 fromages", description = "Mmh, my pizza!!!", price = 15, itemID = 89, itemValue = "Pizza 4 Fromages" },
			 -- { name = "Pizza Pepperoni", description = "Yummy, a pizza!!", price = 18, itemID = 89, itemValue = "Pizza Pepperoni"},
			 -- { name = "Pizza Hawaïenne", description = "Yummy, a pizza!!", price = 20, itemID = 89, itemValue = "Pizza Ananas" },
			 -- { name = "Pizza Mystère", description = "Yummy, a pizza!!", price = 30, itemID = 89, itemValue = "Pizza Mystere" },
			 { name = "Sandwich", description = "Un délicieux sandwich au fromage", price = 5, itemID = 8 },
			 { name = "Tacos", description = "Un bon vieux Tacos mexicain", price = 7, itemID = 11 },
			 { name = "Burger", description = "A double cheeseburger with bacon", price = 6, itemID = 12 },
			 { name = "Donut", description = "Hot sticky sugar covered donut", price = 3, itemID = 13 },
			 { name = "Cookie", description = "A luxury chocolate chip cookie", price = 3, itemID = 14 },
			 { name = "Hotdog", description = "Nice, tasty hotdog!", price = 5, itemID = 1 },
			 { name = "Pancake", description = "Yummy, a pancake!!", price = 2, itemID = 108 },
			 { name = "Pizza", description = "Miaam. Une pizza.", price = 15, itemID = 306 },
		 },
		 {
			 name = "Boissons",
			 { name = "Canette Sprunk", description = "Une canette de Sprunk.", price = 3, itemID = 308 },
			 { name = "Bouteille d'Eau", description = "Une bouteille d'eau minérale .", price = 3, itemID = 15 },
			 { name = "Canette eCola", description = "Une canette de Sprunk.", price = 3, itemID = 309 },
			 { name = "Canette eCola Zero", description = "Une canette de Sprunk.", price = 3, itemID = 311 },
			 { name = "Canette Sprunk Extreme", description = "Une canette de Sprunk.", price = 3, itemID = 310 },
			 { name = "Bouteille d'E-Cola", description = "", price = 3, itemID = 313},
			 { name = "Bouteille de Sprunk", description = "", price = 3, itemID = 312 },
		 }
	 },
	 { -- 4
		 name = "Sex Shop",
		 description = "Tous les objets nécessaire pour passer une soirée d'enfer!",
		 image = "sex.png",
 
		 {
			 name = "Sexy",
			 { name = "Long Purple Dildo", description = "En forme de zizi mais violet.", price = 20, itemID = 115, itemValue = 10 },
			 { name = "Short Tan Dildo", description = "Un zizi digne des asiatiques.", price = 15, itemID = 115, itemValue = 11 },
			 { name = "Vibrator", description = "Remplace les hommes.", price = 25, itemID = 115, itemValue = 12 },
			 { name = "Fleurs", description = "Réservé aux cannards.", price = 5, itemID = 115, itemValue = 14 },
			 { name = "Menotte", description = "Réservé aux sado.", price = 90, itemID = 45 },
			 { name = "Corde", description = "Un dérivé aux menottes.", price = 15, itemID = 46 },
			 { name = "Bandeau", description = "Pour bander... Les yeux.", price = 15, itemID = 66 },
		 },
		 {
			 name = "Clothes",
			 { name = "Série 87", description = "Vêtements sexy.", price = 55, itemID = 16, itemValue = 87 },
			 { name = "Série 178", description = "Vêtements sexy.", price = 55, itemID = 16, itemValue = 178 },
			 { name = "Série 244", description = "Vêtements sexy.", price = 55, itemID = 16, itemValue = 244 },
			 { name = "Série 246", description = "Vêtements sexy.", price = 55, itemID = 16, itemValue = 246 },
			 { name = "Série 257", description = "Vêtements sexy.", price = 55, itemID = 16, itemValue = 257 },
		 }
	 },
	 { -- 5
		 name = "Magasin de vêtements et d'accessoires",
		 description = "You don't look fat in those!",
		 image = "clothes.png",
		 -- Items to be generated elsewhere.
		 {
			 name = "Vêtements"
		 },
	 },
	 { -- 6
		 name = "Gym",
		 description = "Le meilleur endroit pour apprendre à se battre.",
		 image = "general.png",
 
		 {
			 name = "Style Combat",
			 { name = "Combat Standard pour les Nuls", description = "Pour les novices.", price = 10, itemID = 20 },
			 { name = "Boxe pour les Nuls", description = "Mike Tyson, sous drogue.", price = 50, itemID = 21 },
			 { name = "Kung Fu pour les Nuls", description = "Je pratique le Kung Fu. Tu peux aussi.", price = 50, itemID = 22 },
			 -- item ID 23 is just a greek book, anyhow :o
			 { name = "Grab & Kick pour les Nuls", description = "Je t'attrape, je te soulève!", price = 50, itemID = 24 },
			 { name = "Elbows pour les Nuls", description = "Fils de pute ma lumière..", price = 50, itemID = 25 },
		 }
	 },
	 { -- 7 / fuck this, unused - Nando
		 name = "Rapid Auto Parts - Viozy",
		 description = "If it isn't by Viozy, it's fraud. All sales posted reduced by 50% for exclusive members.",
		 image = "viozy-auto.png",
		 -- {
		-- 	 name = "Tint Application",
		-- 	 { name = "HP Charcoal Window Film", description = "Viozy Window Films ((50 /chance))", price = 305 / priceReduce, itemID = 184, itemValue = "Viozy HP Charcoal Window Tint Film ((50 /chance))" },
		-- 	 { name = "CXP70 Window Film", description = "Viozy CXP70 Window Film ((95 /chance))", price = 490 / priceReduce, itemID = 185, itemValue = "Viozy CXP70 Window Film ((95 /chance))" },
		-- 	 { name = "Border Edge Cutter (Red Anodized)", description = "Border Edge Cutter for Tinting", price = 180 / priceReduce, itemID = 186, itemValue = "Viozy Border Edge Cutter (Red Anodized)" },
		-- 	 { name = "Solar Spectrum Tranmission Meter", description = "Spectrum Meter for testing film before use", price = 1000 / priceReduce, itemID = 187, itemValue = "Viozy Solar Spectrum Tranmission Meter" },
		-- 	 { name = "Tint Chek 2800", description = "Measures the Visible Light Transmission on any film/glass", price = 280 / priceReduce, itemID = 188, itemValue = "Viozy Tint Chek 2800" },
		-- 	 { name = "Equalizer Heatwave Heat Gun", description = "Easy to use heat gun perfect for shrinking back windows", price = 530 / priceReduce, itemID = 189, itemValue = "Viozy Equalizer Heatwave Heat Gun" },
		-- 	 { name = "36 Multi-Purpose Cutter Bucket", description = "Ideal for light cutting jobs while applying tint", price = 120 / priceReduce, itemID = 190, itemValue = "Viozy 36 Multi-Purpose Cutter Bucket" },
		-- 	 { name = "Tint Demonstration Lamp", description = "Effectve presentation of tinted application", price = 150 / priceReduce, itemID = 191, itemValue = "Viozy Tint Demonstration Lamp" },
		-- 	 { name = "Triumph Angled Scraper", description = "6-inch Angled Scraper for applying tint", price = 100 / priceReduce, itemID = 192, itemValue = "Viozy Triumph Angled Scraper" },
		-- 	 { name = "Performax 48oz Hand Sprayer", description = "Performax Hand Sprayer for tint application", price = 200 / priceReduce, itemID = 193, itemValue = "Viozy Performax 48oz Hand Sprayer" },
		-- 	 { name = "Ammonia Bottle", description = "A bottle of ammonia solution", price = 50 / priceReduce, itemID = 260, itemValue = "Ammonia Bottle" },
		 -- },
 
		 -- {
		-- 	 name = "Mechanics",
		-- 	 { name = "Vehicle Ignition - 2010 ((20 /chance))", description = "Vehicle Ignition made by Viozy for 2010", price = 196 / priceReduce, itemID = 194, itemValue = "Viozy Vehicle Ignition - 2010 ((20 /chance))" },
		-- 	 { name = "Vehicle Ignition - 2011 ((30 /chance))", description = "Vehicle Ignition made by Viozy for 2011", price = 254 / priceReduce, itemID = 195, itemValue = "Viozy Vehicle Ignition - 2011 ((30 /chance))" },
		-- 	 { name = "Vehicle Ignition - 2012 ((40 /chance))", description = "Vehicle Ignition made by Viozy for 2012", price = 364 / priceReduce, itemID = 196, itemValue = "Viozy Vehicle Ignition - 2012 ((40 /chance))" },
		-- 	 { name = "Vehicle Ignition - 2013 ((50 /chance))", description = "Vehicle Ignition made by Viozy for 2013", price = 546 / priceReduce, itemID = 197, itemValue = "Viozy Vehicle Ignition - 2013 ((50 /chance))" },
		-- 	 { name = "Vehicle Ignition - 2014 ((70 /chance))", description = "Vehicle Ignition made by Viozy for 2014", price = 929 / priceReduce, itemID = 198, itemValue = "Viozy Vehicle Ignition - 2014 ((70 /chance))" },
		-- 	 { name = "Vehicle Ignition - 2015 ((90 /chance))", description = "Vehicle Ignition made by Viozy for 2015", price = 1765 / priceReduce, itemID = 199, itemValue = "Viozy Vehicle Ignition - 2015 ((90 /chance))" },
		-- 	 { name = "HVT 358 Portable Spark Nano 4.0 ((50 /chance))", description = "GPS HVT 358 Spark Nano 4.0 Portable ((50 /chance to be found)), by Viozy", price = 345 / priceReduce, itemID = 205, itemValue = "Viozy HVT 358 Portable Spark Nano 4.0 ((50 /chance))" },
		-- 	 { name = "Hidden Vehicle Tracker 272 Micro ((30 /chance))", description = "GPS HVT 272 Micro, easy installation ((30 /chance to be found)), by Viozy", price = 840 / priceReduce, itemID = 204, itemValue = "Viozy Hidden Vehicle Tracker 272 Micro ((30 /chance))" },
		-- 	 { name = "Hidden Vehicle Tracker 315 Pro ((Undetectable))", description = "GPS HVT 315 Pro, easy installation ((and undetectable)), by Viozy", price = 2229 / priceReduce, itemID = 203, itemValue = "Viozy Hidden Vehicle Tracker 315 Pro ((Undetectable))" },
		 -- },
		 {
			 name = "Discount Tires",
			 { name = "Access", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1098 },
			 { name = "Virtual", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1097 },
			 { name = "Ahab", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1096 },
			 { name = "Atomic", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1085 },
			 { name = "Trance", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1084 },
			 { name = "Dollar", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1083 },
			 { name = "Import", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1082 },
			 { name = "Grove", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1081 },
			 { name = "Switch", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1080 },
			 { name = "Cutter", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1079 },
			 { name = "Twist", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1078 },
			 { name = "Classic", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1077 },
			 { name = "Wires", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1076 },
			 { name = "Rimshine", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1075 },
			 { name = "Mega", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1074 },
			 { name = "Shadow", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1073 },
			 { name = "Offroad", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1025 },
		 }
 
	 },
	 { -- 8
		 name = "Electronics Store",
		 description = "The latest technology, extremely overpriced just for you.",
		 image = "general.png",
 
		 {
			 name = "Electronics",
			 { name = "Téléphone portable", description = "Un téléphone portable élégant.", price = 800, itemID = 2 },
			 -- { name = "Lampe Torche", description = "Pour éclairer ta lanterne.", price = 25, itemID = 145, itemValue = 100 },
			 { name = "Boombox", description = "Une Boombox noire, pour écouter de la musique avec vos amis.", price = 250, itemID = 54 },
			 { name = "Caméra", description = "Une petite caméra noire.", price = 75, itemID = 115, itemValue = 43 },
			 { name = "Radio", description = "Une radio noire.", price = 50, itemID = 6 },
			 { name = "Montre", description = "Il est l'heure de t'acheter une montre!", price = 25, itemID = 17 },
			 -- { name = "Kit de Chimie", description = "Un petit Kit de Chimie.", price = 2000, itemID = 44 },
			 { name = "GPS Portable", description = "Un GPS, contient également une carte récente (F11).", price = 200, itemID = 111 },
			 { name = "Macbook pro A1286 Core i7", description = "Le PC portable dernier cri pour naviguer sur internet et consulter ses mails.", price = 2200, itemID = 96 },
			 { name = "TV Portable", description = "Une TV Portable, pour regarder la TV partout.", price = 750, itemID = 104 },
			 { name = "Télépéage", description = "Pour votre véhicule. Vous débite automatiquement près d'un péage.", price = 400, itemID = 118 },
			 { name = "Alarme Véhicule", description = "Protège votre véhicule avec une Alarme.", price = 1000, itemID = 130 },
			 -- { name = "Night Vision Goggles", description = "A robust, dependable, high-performance night vision system.", price = 4499, itemID = 115, itemValue = 44 },
			 -- { name = "Infrared Goggles", description = "Lightweight, rugged and a top notch performer and an exceptional choice for hands-free usage.", price = 7499, itemID = 115, itemValue = 45 },
			 { name = "Lampe UV (pour plantes)", description = "Lampe UV (pour plantes).", price = 200, itemID = 288 },
			 { name = "Chargeur d'E-Scooter", description = "Un chargeur pour un e-scooter.", price = 400, itemID = 293 },
			 
		 }
	 },
	 { -- 9
		 name = "Alcohol Store",
		 description = "Everything from Vodka to Beer and the other way round.",
		 image = "general.png",
 
		 {
			 name = "Drinks",
			 { name = "Ziebrand Beer", description = "", price = 10, itemID = 58, minimum_age = 21 },
			 { name = "Bastradov Vodka", description = "", price = 25, itemID = 62, minimum_age = 21 },
			 { name = "Scottish Whiskey", description = "", price = 15, itemID = 63, minimum_age = 21 },
			 --{ name = "Softdrink", description = "A cold can of Sprunk.", price = 3, itemID = 9 },
			 { name = "Pack de bière Pisswasser", description = "", price = 50, itemID = 314 },
			 { name = "Pack de bière Corona", description = "", price = 50, itemID = 315 },
			 { name = "Pack de bière Heineken", description = "", price = 50, itemID = 316 },
			 { name = "Champagne Moët & Chandon Ice Impérial", description = "", price = 50, itemID = 317 },
			 { name = "Champagne Moët & Chandon Nectar Impérial", description = "", price = 50, itemID = 318 },
			 { name = "Champagne Luc Belaire", description = "", price = 50, itemID = 319 },
			 { name = "Champagne Veuve Clicquot", description = "", price = 50, itemID = 320 },
			 { name = "Champagne Bottega", description = "", price = 50, itemID = 321 },
			 { name = "Grey Goose Vodka", description = "", price = 50, itemID = 322 },
			 { name = "Absolut Vodka", description = "", price = 50, itemID = 323 },
			 { name = "Jack Daniel's", description = "", price = 50, itemID = 324 },
			 { name = "Hennessy", description = "", price = 50, itemID = 325 },
			 { name = "Vin blanc", description = "", price = 50, itemID = 326 },
			 { name = "Bouteille de Rosé", description = "", price = 50, itemID = 327 },
			 { name = "Bouteille de Vin Rouge", description = "", price = 50, itemID = 328 },
			 { name = "Bière Pisswasser", description = "", price = 50, itemID = 329 },
			 { name = "Bière Corona", description = "", price = 50, itemID = 330 },
			 { name = "Bière Beck's", description = "", price = 50, itemID = 331 },
		 }
	 },
	 { -- 10
		 name = "Book Store",
		 description = "New things to learn? Sound like... fun?!",
		 image = "general.png",
 
		 {
			 name = "Books",
			 --{ name = "City Guide", description = "A small city guide booklet.", price = 15, itemID = 18 },
			 --{ name = "Los Santos Highway Code", description = "A paperback book.", price = 10, itemID = 50 },
			 { name = "Blank Book", description = "A hardcover book with nothing written in it.", price = 40, itemID = 178, itemValue = "New Book"},
		 }
	 },
	 { -- 11
		 name = "Cafe",
		 description = "You want some chocolate on your rim?",
		 image = "food.png",
 
		 {
			 name = "Food",
			 { name = "Donut", description = "Un donut sucré au sucre", price = 3, itemID = 13 },
			 { name = "Cookie", description = "Un cookie aux pépites de chocolat de luxe.", price = 3, itemID = 14 },
			 { name = "Hotdog", description = "Savoureux hotdog.", price = 5, itemID = 1 },
			 { name = "Tacos", description = "Un tacos mexicain exquis ", price = 7, itemID = 11 },
			 { name = "Burger", description = "Hmmm... My big burger!", price = 6, itemID = 12 },
			 { name = "Pancake", description = "Yummy, un pancake!", price = 2, itemID = 108 },
			 { name = "Pizza", description = "Miaam, les calories!", price = 15, itemID = 306 },
		 },
		 {
			 name = "Drinks",
			 { name = "Coffee", description = "", price = 1, itemID = 83, itemValue = 2 },
			 --{ name = "Softdrink", description = "", price = 3, itemID = 9, itemValue = 3 },
			 { name = "Bouteille d'eau", description = "", price = 1, itemID = 15, itemValue = 2 },
			 { name = "Canette Sprunk", description = "", price = 3, itemID = 308 },
			 { name = "Canette eCola", description = "", price = 3, itemID = 309 },
			 { name = "Canette eCola Zero", description = "", price = 3, itemID = 311 },
			 { name = "Canette Sprunk Extreme", description = "", price = 3, itemID = 310 },
			 { name = "Bouteille d'E-Cola", description = "", price = 3, itemID = 313},
			 { name = "Bouteille d'eau", description = "", price = 1, itemID = 15, itemValue = 2 },
			 { name = "Bouteille de Sprunk", description = "", price = 3, itemID = 312 },
			 { name = "Pack de bière Pisswasser", description = "", price = 50, itemID = 314 },
			 { name = "Pack de bière Corona", description = "", price = 50, itemID = 315 },
			 { name = "Pack de bière Heineken", description = "", price = 50, itemID = 316 },
			 { name = "Champagne Moët & Chandon Ice Impérial", description = "", price = 50, itemID = 317 },
			 { name = "Champagne Moët & Chandon Nectar Impérial", description = "", price = 50, itemID = 318 },
			 { name = "Champagne Luc Belaire", description = "", price = 50, itemID = 319 },
			 { name = "Champagne Veuve Clicquot", description = "", price = 50, itemID = 320 },
			 { name = "Champagne Bottega", description = "", price = 50, itemID = 321 },
			 { name = "Grey Goose Vodka", description = "", price = 50, itemID = 322 },
			 { name = "Absolut Vodka", description = "", price = 50, itemID = 323 },
			 { name = "Jack Daniel's", description = "", price = 50, itemID = 324 },
			 { name = "Hennessy", description = "", price = 50, itemID = 325 },
			 { name = "Vin blanc", description = "", price = 50, itemID = 326 },
			 { name = "Bouteille de Rosé", description = "", price = 50, itemID = 327 },
			 { name = "Bouteille de Vin Rouge", description = "", price = 50, itemID = 328 },
			 { name = "Bière Pisswasser", description = "", price = 50, itemID = 329 },
			 { name = "Bière Corona", description = "", price = 50, itemID = 330 },
			 { name = "Bière Beck's", description = "", price = 50, itemID = 331 },
			 { name = "Ziebrand Beer", description = "", price = 10, itemID = 58, minimum_age = 21 },
			 { name = "Bastradov Vodka", description = "", price = 25, itemID = 62, minimum_age = 21 },
			 { name = "Scottish Whiskey", description = "", price = 15, itemID = 63, minimum_age = 21 },
		 }
	 },
	 { -- 12
		 name = "Santa's Grotto",
		 description = "Ho-ho-ho, Merry Christmas.",
		 image = "general.png",
 
		 {
			 name = "Christmas Items",
			 { name = "Christmas Present", description = "What could be inside?", price = 0, itemID = 94 },
			 { name = "Eggnog", description = "Yum Yum!", price = 0, itemID = 91 },
			 { name = "Turkey", description = "Yum Yum!", price = 0, itemID = 92 },
			 { name = "Christmas Pudding", description = "Yum Yum!", price = 0, itemID = 93 },
		 }
	 },
	 { -- 13
		 name = "Prison Worker",
		 description = "Now that looks... vaguely tasty.",
		 image = "general.png",
 
		 {
			 name  = "Disgusting Stuff",
			 { name = "Mixed Dinner Tray", description = "Lets play the guessing game.", price = 0, itemID = 99 },
			 { name = "Small Milk Carton", description = "Lumps included!", price = 0, itemID = 100 },
			 { name = "Small Juice Carton", description = "Thirsty?", price = 0, itemID = 101 },
		 }
	 },
	 { -- 14
		 name = "One Stop Mod Shop",
		 description = "Any parts you'll ever need!",
		 image = "general.png",
 
		 -- items to be filled in later
		 {
			 name = "Vehicle Parts"
		 }
	 },
	 { -- 15
		 name = "NPC",
		 description = "(( This is just an NPC, not meant to hold any items. ))",
		 image = "general.png",
 
		 {
			 name = "No items"
		 }
	 },
	 { -- 16
		 name = "Magasin d'outils",
		 description = "Besoin d'un truc?!",
		 image = "general.png",
 
		 {
			 name = "Outils",
			 { name = "Club de Golf", description = "Parfait pour frapper ce hole-in-one.", price = 450, itemID = 115, itemValue = 2 },
			 { name = "Pelle", description = "Outil parfait pour creuser un trou.", price = 310, itemID = 115, itemValue = 6 },
			 { name = "Queue de Billard", description = "Pour frapper ces bonnes boules bien dures.", price = 250, itemID = 115, itemValue = 7 },
			 { name = "Canne", description = "Pour vous aider à marcher.", price = 310, itemID = 115, itemValue = 15 },
			 { name = "Extincteur", description = "Utile en cas d'incendie.", price = 520, itemID = 115, itemValue = 42 },
			 { name = "Pied de Biche", description = "Un pied de biche peut-être utile...", price = 358, itemID = 500, itemValue = 1 },
			 { name = "Alarme Maison", description = "Alarme contre les intrusions.", price = 10000, itemID = 501, itemValue = 1 },
			 { name = "Sérrure Maison", description = "Pour un changement de sérrure.", price = 100, itemID = 502, itemValue = 1 },

			},
			 {
				name = "Machines",
				{ name = "Mixeur", description = "Sert à mixer vos ingrédients.", price = 90, itemID = 380 },
				{ name = "Pompe de refroidissement", description = "Utile pour refroidir d'autre mécanisme, il suffit de la brancher.", price = 1250, itemID = 379 },
				{ name = "Lampe UV", description = "Meilleur que le spot des influenceuses!", price = 400, itemID = 288 },
			},
			{
				name = "Pêche & Nature",
				{ name = "Canne à Pêche robuste", description = "Utile pour les poissons les plus dangereux.", price = 650, itemID = 49 },
				{ name = "Canne à Pêche amateur", description = "Pour pêcho.. pêcher.", price = 300, itemID = 377 },
				{ name = "Appâts Pêche (ver))", description = "x1 appât.", price = 5, itemID = 297 },
				{ name = "Appâts Pêche (Hareng)", description = "x1 appât.", price = 8, itemID = 376 },
				{ name = "Pot de plante", description = "Un pot de plante en terre cuite.", price = 30, itemID = 286},
				{ name = "Fertilisant pour plante", description = "Un fertilisant vitaminé pour 10 utilisations.", price = 50, itemID = 289, itemValue = 10},
			},
		 },
	 { -- 17
		 name = "Inutile",
		 description = "Tous les accessoires sont ici!",
		 image = "general.png",
	 },
	 { -- 18
		 name = "Faction Drop NPC - General Items",
		 description = " ",
		 image = "general.png",
	 },
	 { -- 19
		 name = "Faction Drop NPC - Weapons",
		 description = " ",
		 image = "general.png", 
	 },
	 { -- 20
		 name = "Pharmacien",
		 description = " ",
		 image = "general.png",

		 {
			name = "Médicaments",
			{ name = "Naloxone", description = "Nécessite une ordonnance - Aide à combattre la dépendance.", price = 450, itemID = 391, itemValue = 1, needItem = 399, maxCount = 15},
			{ name = "Éphédrine", description = "Une amine sympathicomimétique et un alcaloïde.", price = 10, itemID = 387, itemValue = 1, allowed_to = {1} },
			{ name = "Méthylène", description = "Référénce de la méthylène-dioxy-méthanphétamine.", price = 5, itemID = 382, itemValue = 1, allowed_to = {1, 10} },
			{ name = "Acide sulfurique", description = "Un acide minéral très puissant.", price = 15, itemID = 388, itemValue = 1, allowed_to = {1} },
			{ name = "Acétone", description = "Un isomère du propanal.", price = 10, itemID = 384, itemValue = 1, allowed_to = {1, 10} },
			{ name = "Acide caustique", description = "Un solide blanc de formule chimique.", price = 15, itemID = 383, itemValue = 1, allowed_to = {1, 10} },
			{ name = "Sulfate de potassium", description = "Un composé d'ions.", price = 5, itemID = 385, itemValue = 1, allowed_to = {1, 10} },
			{ name = "Paracétamol", description = "Analgésique et antipyrétique couramment utilisé pour soulager la douleur et la fièvre", price = 5, itemID = 390, itemValue = 1 },
		}
	 },
	 { -- 21
		 name = "Chopshop",
		 description = " ",
		 image = "general.png", 
	 },
	 { -- 22
		name = "Pawnshop",
		description = " ",
		image = "general.png", 

		{
			name = "Items",
			{ name = "Club de Golf", description = "Parfait pour frapper ce hole-in-one.", price = 450, itemID = 115, itemValue = 2 },
			{ name = "Pelle", description = "Outil parfait pour creuser un trou.", price = 310, itemID = 115, itemValue = 6 },
			{ name = "Queue de Billard", description = "Pour frapper ces bonnes boules bien dures.", price = 250, itemID = 115, itemValue = 7 },
			{ name = "Canne", description = "Pour vous aider à marcher.", price = 310, itemID = 115, itemValue = 15 },
			{ name = "Extincteur", description = "Utile en cas d'incendie.", price = 520, itemID = 115, itemValue = 42 },
			{ name = "Pied de Biche", description = "Un pied de biche peut-être utile...", price = 358, itemID = 500, itemValue = 1 },
			{ name = "Caméra", description = "Une petite caméra noire.", price = 75, itemID = 115, itemValue = 43 },
			{ name = "Radio", description = "Une radio noire.", price = 50, itemID = 6 },
			{ name = "Montre", description = "Il est l'heure de t'acheter une montre!", price = 25, itemID = 17 },
			{ name = "Cadenas pôur vélo", description = "Vous permet de verrouiller votre vélo.", price = 250, itemID = 275, itemValue = 1},
			{ name = "Batte de Baseball", description = "Pour frapper un Home Run.", price = 900, itemID = 115, itemValue = 5 },
			{ name = "Vieux Casque", description = "Un casque couramment utilisé par les personnes à vélo/moto.", price = 100, itemID = 90 },
		}
	},
 }
 
function getShopData(shopID)
	return g_shops[shopID]
end

 -- some initial updating once you start the resource
 function loadLanguages( )
	 local shop = g_shops[ 10 ]
	 for i = 1, exports['language-system']:getLanguageCount() do
		 local ln = exports['language-system']:getLanguageName(i)
		 if ln then
			 table.insert( shop[1], { name = ln .. " Dictionary", description = "A Dictionary, useful for learning " .. ln .. ".", price = 25, itemID = 69, itemValue = i } )
		 end
	 end
 end
 
 addEventHandler( "onResourceStart", resourceRoot, loadLanguages )
 addEventHandler( "onClientResourceStart", resourceRoot, loadLanguages )
 
 -- util
 
 function getMetaItemName(item)
	 local metaName = type(item.metadata) == 'table' and item.metadata.item_name or nil
 
	 return metaName ~= nil and metaName or ''
 end
 
 function checkItemSupplies(shop_type, supplies, itemID, itemValue, itemMetaName)
 	if not bandanas then
	 	bandanas = {}
 		for k, v in pairs(exports['item-system']:getBadges()) do
 			if v.bandana then
 				bandanas[k] = true
 			end
 		end
 	end
	 if supplies then
		 -- regular items
		 if (supplies[itemID .. ":" .. (itemValue or 1)] and supplies[itemID .. ":" .. (itemValue or 1)] > 0) then
			 return true
		 -- generics with meta name
		 elseif (supplies[itemID .. ":" .. (itemValue or 1) .. ":" .. itemMetaName] and supplies[itemID .. ":" .. (itemValue or 1) .. ":" .. itemMetaName] > 0) then
			 return true
		 -- clothes
		 elseif (itemID == 16 and supplies[tostring(itemID)] and supplies[tostring(itemID)] > 0) then
			 return true
		 -- bandanas
		 elseif (bandanas[itemID] and supplies["122"] and supplies["122"] > 0) then
			 return true
		 -- car mods
		 elseif (itemID == 114 and vehicle_upgrades[tonumber(itemValue)-999] and vehicle_upgrades[tonumber(itemValue)-999][3] and supplies["114:" .. vehicle_upgrades[tonumber(itemValue)-999][3]] and supplies["114:" .. vehicle_upgrades[tonumber(itemValue)-999][3]] > 0) then
			 return true
		 end
	 end
	 return false
 end
 
 function getItemFromIndex( shop_type, index, usingStocks, interior )
	 local shop = g_shops[ shop_type ]
	 if shop then
		 if usingStocks and interior then
			 local status = getElementData(interior, "status")
			 local supplies = fromJSON(status.supplies)
			 local govOwned = status.type == 2
			 local counter = 1
			 for _, category in ipairs(shop) do
				 for _, item in ipairs(category) do
					 if checkItemSupplies(shop_type, supplies, item.itemID, item.itemValue, getMetaItemName(item)) or govOwned then
						 if counter == index then
							 return item
						 end
						 counter = counter + 1
					 end
				 end
			 end
		 else
			 for _, category in ipairs(shop) do
				 if index <= #category then
					 return category[index]
				 else
					 index = index - #category
				 end
			 end
		 end
	 end
 end

-- from mta wiki
local maleSkins = {1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 311, 312}
local femaleSkins = {9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304}

local restricted_skins = {
	[71] = true,
	[265] = true,
	[266] = true,
	[267] = true,
	[274] = true,
	[275] = true,
	[276] = true,
	[277] = true,
	[278] = true,
	[279] = true,
	[275] = true,
	[280] = true,
	[281] = true,
	[282] = true,
	[283] = true,
	[284] = true,
	[285] = true,
	[286] = true,
	[287] = true,
	[288] = true,
	[300] = true,
 }

 --local simplesmallcache = {}
 function updateItems( shop_type, gender )
	 if shop_type == 5 then -- clothes shop
	 	if not bandanas then
	 		bandanas = {}
	 		for k, v in pairs(exports['item-system']:getBadges()) do
	 			if v.bandana then
	 				bandanas[k] = true
	 			end
	 		end
	 	end

		-- load the shop
		local shop = g_shops[shop_type]

		-- clear all items
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end

		local mySkins = maleSkins
		if gender ~= 0 then
			mySkins = femaleSkins
			shop[1].name = "Vêtements pour Femme"
		else
			shop[1].name = "Vêtements pour Homme"
		end

		for _, skinid in ipairs(mySkins) do
			if not restricted_skins[skinid] then
				table.insert( shop[1], { name = "Skin ID " .. skinid, description = "", price = 50, itemID = 16, itemValue = skinid } )
			end
		end

		shop[2] = {
			name = 'Bandanas'
		}

		for itemID, _ in pairs(bandanas) do
			shop[2][#(shop[2])+1] = {itemID=itemID, price=20}
		end
 
		 -- simplesmallcache[tostring(race) .. "|" .. tostring(gender)] = shop
	 elseif shop_type == 14 then
		 -- param (race)= vehicle model
		 --[[local c = simplesmallcache["vm"]
		 if c then
			 return
		 end]]
 
		 -- remove old data
		 for _, category in ipairs(shop) do
			 while #category > 0 do
				 table.remove( category, i )
			 end
		 end
 
		 for v = 1000, 1193 do
			 if vehicle_upgrades[v-999] then
				 local str = exports['item-system']:getItemDescription( 114, v )
 
				 local p = str:find("%(")
				 local vehicleName = ""
				 if p then
					 vehicleName = str:sub(p+1, #str-1) .. " - "
					 str = str:sub(1, p-2)
				 end
				 if not disabledUpgrades[v] then
					 table.insert( shop[1], { name = vehicleName .. ( getVehicleUpgradeSlotName(v) or "Lights" ), description = str, price = vehicle_upgrades[v-999][2], itemID = 114, itemValue = v})
				 end
			 end
		 end
		 -- bar battery
		 table.insert( shop[1], { name = exports['item-system']:getItemName( 232 ), description = exports['item-system']:getItemDescription( 232, 1 ), price = 130*2, itemID = 232, itemValue = 1} )
	 end
 end
 
 function getFittingSkins()
	 return fittingskins
 end
 
 
 function getDiscount( player, shoptype )
	 local discount = 1
	 if shoptype == 7 then
		 discount = discount * 0.5
	 elseif shoptype == 14 then
		 discount = discount * 0.5
	 end
 
	 if exports.donators:hasPlayerPerk( player, 8 ) then
		 discount = discount * 0.8
	 end
	 return discount
 end
 