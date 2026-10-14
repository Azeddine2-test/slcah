--[[

	Nando major revamp 2023

]]

-- To find out the last item ID so you can add a new item use
-- /lastitemid
-- ⚠️ When adding new Items don't forget to set the right category

-- Order:
-- name, description, category, model, rx, ry, rz, zoffset

-- Categories:
-- 1 = Food & Drink
-- 2 = Keys
-- 3 = Drugs
-- 4 = Other
-- 5 = Books
-- 6 = Clothing & Accessories
-- 7 = Electronics
-- 8 = guns
-- 9 = bullets
-- 10 = wallet

g_items = {

	--
	-- FOOD
	--
	[1] = { "Hotdog", "Un hotdog appétissant et savoureux.", 1, 19346, 0, 0, 0, 0.02, weight = 0.1, eatHeal=true },
	[8] = { "Sandwich", "Un délicieux sandwich au fromage.", 1, 2769, 0, 0, 0, 0.0, weight = 0.1, eatHeal=true },
	[11] = { "Taco", "Un taco mexicain gras.", 1, 2769, 0, 0, 0, 0.0, weight = 0.1, eatHeal=true },
	[12] = { "Burger", "Un double cheeseburger avec bacon.", 1, 2703, 265, 0, 0, 0.06, weight = 0.1, eatHeal=true },
	[13] = { "Donut", "Un donut chaud couvert de sucre collant.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1 , eatHeal=true},
	[14] = { "Cookie", "Un biscuit de luxe aux pépites de chocolat.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1, eatHeal=true },
	[92] = { "Dinde", "Miam Miam.", 1, 2222, 0, 0, 0, 0.1, weight = 1, eatHeal=true },
	[93] = { "Pudding de Noël", "Miam Miam.", 1, 2222, 0, 0, 0, 0.1, weight = 0.1 , eatHeal=true},
	[99] = { "Mixed Dinner Tray", "Lets play the guessing game.", 1, 2355, 205, 205, 0, 0.06, weight = 0.1, eatHeal=true },
	[102] = { "Chou", "Pour les amoureux de végétariens.", 1, 1271, 0, 0, 0, 0.1, weight = 0.1, eatHeal=true },
	[108] = { "Pancake", "Yummy, a pancake!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1, eatHeal=true },
	[109] = { "Fruit", "Yummy, healthy food!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1, eatHeal=true },
	[110] = { "Légume", "Yummy, healthy food!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1 , eatHeal=true},
	[213] = { "Pinnekjott", "Exciter's christmas favourite.", 1, 2215, 205, 205, 0, 0.06, weight = 0.1, eatHeal=true },
	[306] = { "Pizza", "Miam Miam.", 1, 2814, 0, 0, 0, 0.0, weight = 0.1, eatHeal=true },

	--
	-- NON-ALCOHOLIC DRINKS
	--
	[83] = { "Café", "Un petit café.", 1, 19835, 0, 0, 0, 0.09, weight = 0.5, drinkHeal=true },
	[91] = { "Lait de poule", "Miam Miam.", 1, 2647, 0, 0, 0, 0.5, weight = 0.5, drinkHeal=true }, --91
	[100] = { "Carton de Lait", "Des grumeaux inclus!", 1, 19569, 0, 0, 0, 0, weight = 0.5, drinkHeal=true },
	[101] = { "Carton de Jus", "Assoiffé?", 1, 19563, 0, 0, 0, 0, weight = 0.5, drinkHeal=true },
	[308] = { "Canette Sprunk", "", 1, 100001, 0, 0, 0, 0.0, weight = 0.5, drinkHeal=true },
	[309] = { "Canette eCola", "", 1, 100002, 0, 0, 0, 0.0, weight = 0.5, drinkHeal=true },
	[310] = { "Canette Sprunk Extreme", "", 1, 100003, 0, 0, 0, 0.0, weight = 0.5, drinkHeal=true },
	[311] = { "Canette eCola Zero", "", 1, 100004, 0, 0, 0, 0.0, weight = 0.5, drinkHeal=true },
	[312] = { "Bouteille de Sprunk", "", 1, 100005, 0, 0, 0, 0.0, weight = 0.5, drinkHeal=true },
	[313] = { "Bouteille d'E-Cola", "", 1, 100006, 0, 0, 0, 0.0, weight = 0.5, drinkHeal=true },
	[15] = { "Bouteille d'eau", "Une bouteille d'eau minérale.", 1, 100060, 0, 0, 0, 0, weight = 0.5, drinkHeal=true },


	--
	-- ALCOHOL
	--
	[58] = 	{ "Bière Ziebrand", "La meilleure bière, importée des Pays-Bas.", 1, 1520, 0, 0, 0, 0.15, weight = 0.5, drinkLoseHP=true },
	[62] = { "Bastradov Vodka", "Pour vos meilleurs amis - Vodka Bastradov..", 1, 1512, 0, 0, 0, 0.25, weight = 0.5 , drinkLoseHP=true},
	[63] = { "Whisky écossais", "Le meilleur whisky écossais, maintenant fabriqué à partir d'haggis.", 1, 19820, 0, 0, 0, 0.02, weight = 0.5, drinkLoseHP=true },
	[317] = { "Champagne Moët & Chandon Ice Impérial", "", 1, 100010, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},
	[318] = { "Champagne Moët & Chandon Nectar Impérial", "", 1, 100011, 0, 0, 0, 0.0, weight = 0.5, drinkLoseHP=true },
	[319] = { "Champagne Luc Belaire", "", 1, 100012, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},
	[320] = { "Champagne Veuve Clicquot", "", 1, 100013, 0, 0, 0, 0.0, weight = 0.5, drinkLoseHP=true },
	[321] = { "Champagne Bottega", "", 1, 100014, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},
	[322] = { "Bouteille de Grey Goose Vodka", "", 1, 100021, 0, 0, 0, 0.0, weight = 0.5, drinkLoseHP=true },
	[323] = { "Bouteille de Absolut Vodka", "", 1, 100022, 0, 0, 0, 0.0, weight = 0.5, drinkLoseHP=true },
	[324] = { "Bouteille de Jack Daniel's", "", 1, 100023, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},
	[325] = { "Bouteille de Hennessy", "", 1, 100024, 0, 0, 0, 0.0, weight = 0.5, drinkLoseHP=true },
	[326] = { "Bouteille de Vin blanc", "", 1, 100025, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},
	[327] = { "Bouteille de Rosé", "", 1, 100025, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},
	[328] = { "Bouteille de Vin rouge", "", 1, 100025, 0, 0, 0, 0.0, weight = 0.5, drinkLoseHP=true },
	[329] = { "Bière Pisswasser", "", 1, 100057, 0, 0, 0, 0.0, weight = 0.5, drinkLoseHP=true },
	[330] = { "Bière Corona", "", 1, 100058, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},
	[331] = { "Bière Beck's", "", 1, 100059, 0, 0, 0, 0.0, weight = 0.5 , drinkLoseHP=true},


	--
	-- DRUGS & RELATED
	--
	[30] = { "Cannabis Sativa", "Le Cannabis Sativa, mélangé peut créer des drogues fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[31] = { "Alcaloïde de Cocaine", "L'Alcaloïde de Cocaine, mélangé peut créer des drogues fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[32] = { "Acide Lysergique", "L'Acide Lysergique, mélangé peut créer des drogues fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[33] = { "PCP non traité", "Le PCP non traité, mélangé peut créer des drogues fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	--[34] = { "Cocaine", "Une substance en poudre donnant un coup de boost d'énergie.", 3, 100064, 0, 0, 0, 0, weight = 0.1 },
	[35] = { "Morphine", "Une substance en pilules ou liquide avec des effets forts.", 3, 100070, 0, 0, 0, -0.02, weight = 0.1 },
	[36] = { "Ecstasy", "Des pilules avec des visuels forts et de l'europhorie.", 3, 100062, 0, 0, 0, 0.07, weight = 0.1 },
	--[37] = { "Héroïne", "Une substance en poudre ou liquide avec des effets ralentissants et une forte europhorie.", 3, 100065, 0, 0, 0, 0, weight = 0.1 },
	[38] = { "Marijuana", "Vert, bonne odeur.", 3, 100063, 0, 0, 0, 0.05, weight = 0.1 },
	[39] = { "Méthamphétamine", "Une substance en cristaux avec des effets de boost d'énergie.", 3, 100063, 0, 0, 0, 0, weight = 0.1 },
	[40] = { "Épinéphrine (Adrénaline)", "L'Épinéphrine - une substance liquide qui augmente l'adrénaline.", 3, 1575, 0, 0, 0, -0.02, weight = 0.1 },
	[41] = { "LSD", "L'acide lysergique avec de la diethylamide, donne des visuels amusants.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[42] = { "Champignons", "Des champignons secs dorés de l'enseignante.", 3, 1577, 0, 0, 0, 0, weight = 0.1 },
	[43] = { "PCP", "Poudre de phencyclidine.", 3, 100070, 0, 0, 0, 0, weight = 0.1 },
	[44] = { "Kit de chimie", "Un petit kit de chimie.", 4, 1210, 90, 0, 0, 0.1, weight = 3 },
	[105] = { "Paquet de cigarettes", "Paquet avec #v cigarettes dedans.", 6, 19897, 0, 0, 0, 0.015, weight = function(v) return 0.1 + v*0.03 end }, -- 105
	[106] = { "Cigarette", "Quelque chose que vous pouvez fumer.", 6, 3044 , 270, 0, 0, 0.1, weight = 0.03 }, -- 106
	[224] = { "Crack", "Une substance de type petite pierre, qui donne une intense sensation d'euphorie lorsqu'elle est fumée.", 3, 1575, 0, 0, 0, 0, weight = 0.1 },
	[225] = { "Ketamine", "Une substance en poudre qui produit une expérience hors du corps lorsqu'elle est injectée, et une brève poussée d'énergie et d'euphorie lorsqu'elle est sniffée.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[226] = { "Oxycodone", "Un analgésique de prescription qui est souvent prescrit pour la douleur modérée à sévère.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[227] = { "Rohypnol", "Une substance en forme de comprimé, souvent écrasée en poudre; également appelé drogue du viol. Les utilisateurs ressentent souvent une perte de contrôle musculaire, une confusion, une somnolence et une amnésie.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[228] = { "Xanax", "Une substance en forme de comprimé couramment prescrite pour soulager les symptômes d'anxiété et de panique.", 3, 100071, 0, 0, 0, 0.05, weight = 0.1 },
	[181] = { "Paquet de feuilles à rouler", "Papier à rouler transparent. Le paquet contient #v feuilles.", 4, 19896 , 0, 0, 0, 0, weight = function(v) return 0.1 + v*0.03 end },
	[182] = { "Joint roulé", "Un joint roulé de marijuana pure.", 4, 1485, 270, 0, 0, 0.1, weight = 0.03 },
	[132] = { "Bouteille de prescription", "Une bouteille de prescription, contenant des médicaments sur ordonnance.", 3, 100072, 0, 0, 0, 0.04, weight = 0.1 }, --132
	[260] = { "Ammonia Bottle", "A bottle of ammonia.", 1, 1484, -15, 30, 0, 0.2, weight = 1 }, --Chaos
	[286] = { "Pot de plante", "Un pot de plante en terre cuite.", 4, 2203, 0, 0, 0, -0.01, weight = 0.01, hideItemValue = true },
	[287] = { "Graine de marijuana", "Une graine de pot.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01, hideItemValue = true },
	[289] = { "Aliment pour plante", "Une bouteille d'aliment pour plantes avec #v utilisations.", 4, 1520, 0, 0, 0, -0.01, weight = 0.01, hideItemValue = true },
	[107] = { "Briquet", "Cela produit du feu si vous l'utilisez correctement.", 6, 19998, 0, 0, 0, 0.1, weight = 0.05 }, -- 107
	[348] = { "Seringue", "", 3, 100026, 90, 0, 0, 0.1, weight = 0.1},
	[349] = { "Backwoods", "", 3, 100027, 90, 0, 0, 0.1, weight = 0.1},
	--[358] = { "MDMA", "A MODIFIER...", 3, 100064, 0, 0, 0, 0, weight = 0.1 },


	--
	-- WEAPONS
	--
	[271] = { "Douilles", "#v", 4, 2061, 90, 0, 0, 0, weight = 0.1, scale = 0.2 }, 
	[115] = { "Weapon", "#v ", 8, 2886, 270, 0, 1, 0.1, 2, weight = function( v )
																		local weaponID = tonumber( explode(":", v)[1] )
																		return weaponID and weaponweights[ weaponID ] or 1
																	end
	},
	[116] = { "Chargeur", "Ammopack with #v bullets inside.", 9, 2040, 0, 1, 0, 0.1, 3,
		weight = function( v )
			local packs = explode(":", v)
			local ammo_id = tonumber( packs[1] )
			local bullets = tonumber( packs[2] )
			if ammo_id and bullets then
				local ammunition = exports.weapon:getAmmo(ammo_id)
				return ammunition and exports.global:round(ammunition.bullet_weight*bullets, 3)
			end
			return 0.2
		end
	},

	-- Blackmarket's materials
	[359] = {"Matériaux AK-47", "Pièces nécessaires pour la construction d'une AK-47", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[360] = {"Matériaux UZI", "Pièces nécessaires pour la construction d'un UZI", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[361] = {"Matériaux Desert Eagle", "Pièces nécessaires pour la construction d'un Desert Eagle", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[362] = {"Matériaux Colt", "Pièces nécessaires pour la construction d'un Colt", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[363] = {"Matériaux Silencieux", "Pièces nécessaires pour la construction d'un Silencieux", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[364] = {"Matériaux Molotov", "Pièces nécessaires pour la construction de Molotov", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[365] = {"Matériaux Tec-9", "Pièces nécessaires pour la construction d'un Tec-9", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[367] = {"Matériaux M4", "Pièces nécessaires pour la construction d'un M4", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[368] = {"Matériaux Shotgun", "Pièces nécessaires pour la construction d'un Shotgun", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[369] = {"Matériaux Sawn Off", "Pièces nécessaires pour la construction d'un Sawn Off", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[370] = {"Matériaux Rifle", "Pièces nécessaires pour la construction d'un Rifle", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[371] = {"Matériaux Sniper", "Pièces nécessaires pour la construction d'un Sniper", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[372] = {"Matériaux Grenade", "Pièces nécessaires pour la construction d'un Grenade", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[373] = {"Matériaux RPG", "Pièces nécessaires pour la construction d'un RPG", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 
	[374] = {"Matériaux MP5", "Pièces nécessaires pour la construction d'un MP5", 8, 1579,  0,  0,  0,  0,  weight = 0.5, scale = 1}, 

	-- Drug system's materials
	[378] = {"Réacteur", "Outil nécessaire pour la création de diverses drogues", 3, 920, 0, 0, 0, 0, weight = 2, scale = 1},
	[379] = {"Pompe", "Outil nécessaire pour la création de diverses drogues", 3, 943, 0, 0, 0, 0, weight = 3, scale = 0.5},
	[380] = {"Mixeur", "Outil nécessaire pour la création de diverses drogues", 3, 19830, 0, 0, 0, 0, weight = 1, scale = 1},

	-- Drug system's components
	[381] = {"Benzoylecgonine", "Métabolite principal de la cocaïne, utilisé comme marqueur de dépistage de l'usage de cette drogue.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[382] = {"Méthylène", "Référence générale à la méthylène-dioxy-méthamphétamine (MDMA), un stimulant psychoactif souvent utilisé comme drogue récréative.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[383] = {"Acide Caustique", "Substance corrosive, utilisée pour diverses applications industrielles, comme déboucheur de canalisations ou dans la production de savon.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[384] = {"Acétone", "Solvant couramment utilisé pour enlever le vernis à ongles, nettoyer certaines surfaces et dans diverses applications industrielles.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[385] = {"Sulfate de potassium", "Composé chimique utilisé comme engrais, additif alimentaire et dans certains produits pharmaceutiques.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[386] = {"Fentanyl", "Puissant analgésique opioïde synthétique, prescrit pour le traitement de la douleur sévère, mais aussi détourné à des fins d'abus.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[387] = {"Éphrédine", "Alcaloïde stimulant, utilisé parfois dans les médicaments contre le rhume et les allergies, ainsi que dans certaines drogues illicites.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[388] = {"Acide sulfurique", "Acide fort et corrosif utilisé dans diverses industries, notamment la fabrication de produits chimiques et le traitement des métaux.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[389] = {"Éthylone", "Stimulant synthétique de la famille des cathinones, qui peut agir comme une drogue récréative aux effets similaires à ceux de l'ecstasy.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[390] = {"Paracétamol", "Analgésique et antipyrétique couramment utilisé pour soulager la douleur et la fièvre, disponible en vente libre dans de nombreux pays.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[402] = {"Ammoniaque", "Composé chimique NH3, utilisé en réfrigération et dans la production d'engrais.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[403] = {"Pseudoephedrine", "Composé chimique. Décongestionnant nasal.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},
	[404] = {"Dexamethasone", "Corticostéroïde anti-inflammatoire.", 3, 1575, 0, 0, 0, 0, weight = 0.1, scale = 1},

	-- Drug system's drugs
	[391] = {"Naloxone", "Anti-dépendance puissant.", 3, 1575, 0, 0, 0, 0, weight = 0.5, scale = 1},
	[392] = {"Cocaine", "Puissant stimulant, hautement addictif. (#vg)", 3, 1578, 0, 0, 0, 0, weight = function(v) return v / 1000 or 0.1; end, scale = 1},
	[393] = {"Heroine", "Opioïde, analgésique, très addictif. (#vg)", 3, 1578, 0, 0, 0, 0, weight = function(v) return v / 1000 or 0.1; end, scale = 1},
	[394] = {"MDMA", "Stimulant empathogène, risques pour la santé. (#vg)", 3, 1578, 0, 0, 0, 0, weight = function(v) return v / 1000 or 0.1; end, scale = 1},
	[395] = {"Drogue inconnue", "Celle-ci semble avoir été créée récemment. Effets inconnus. (#vg)", 3, 1576, 0, 0, 0, 0, weight = function(v) return v or 1; end, scale = 1},
	[405] = {"Méthamphétamine", "Puissant stimulant, drogue illicite. (#vg)", 3, 1576, 0, 0, 0, 0, weight = function(v) return v or 1; end, scale = 1},
	[406] = {"Crack", "Forme de cocaïne, drogue puissante. (#vg)", 3, 1576, 0, 0, 0, 0, weight = function(v) return v or 1; end, scale = 1},
	[407] = {"Stéroïdes", "Composés chimiques, utilisés médicalement ou abusés pour améliorer les performances sportives. (#vg)", 3, 1576, 0, 0, 0, 0, weight = function(v) return v or 1; end, scale = 1},

	-- LSPD Rework's items
	[396] = {'Microphone', "Microphone relié, permet d'écouter des conversations.", 4, 19610, 0, 0, 0, 0, weight = 0.5, scale = 1};

	-- LSES Rework's items
	[399] = {'Ordonnance de Naloxone', "Permettant l'achat de Naloxone, un puissant médicament agissant sur les overdoses.", 4, 2894, 0, 0, 0, -0.01, weight = 0.1},

	--
	-- FISHING
	--
	[298] = { "Poisson d'eau douce", "Un poisson d'eau douce.", 4, 19792, 0, 0, 0, 0.011, weight = 0.5 },
	[299] = { "Poisson d'eau salée", "Un poisson d'eau salée.", 4, 19792, 0, 0, 0, 0.011, weight = 0.5 },
	[300] = { "Poisson d'eau douce en trophée", "Un poisson d'eau douce en trophée.", 4, 19792, 0, 0, 0, 0.011, weight = 0.5 },
	[301] = { "Poisson d'eau salée en trophée", "Un poisson d'eau salée en trophée.", 4, 19792, 0, 0, 0, 0.011, weight = 0.5 },

--T1 (Worms)
	[296] = { "Paquet d'appâts de pêche (ver)", "Un paquet de #v appâts de pêche.", 4, 19792, 0, 0, 0, 0.011, weight = 0.5 },
	[297] = { "Appât de pêche (ver)", "Un morceau d'appât de pêche.", 4, 19792, 0, 0, 0, 0.011, weight = 0.15 },

--T2 (FISH / HERRING)
	[375] = { "Paquet d'appâts de pêche T2 (Hareng)", "Un paquet de #v appâts de pêche.", 4, 19792, 0, 0, 0, 0.011, weight = 0.5 },
	[376] = { "Appât de pêche (Hareng)", "Un morceau d'appât de pêche.", 4, 19792, 0, 0, 0, 0.011, weight = 0.15 },

-- New Rod

	[377] = { "Canne à pêche amateur", "Une canne à pêche en acier carbone de 7 pieds.", 4, 338, 80, 0, 0, -0.02, weight = 1.5,
    artifactName = "rod", canToggleArtifact=true },
    
	--
	-- KEYS / REMOTES
	--
	[3] = { "Clé de véhicule", "Une clé de véhicule avec une petite plaque.", 2, 11746, 90, 0, 0, 0.012, weight = 0.1, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[4] = { "Clé de maison", "Une clé de maison verte.", 2, 11746, 90, 0, 0, 0.012, weight = 0.1, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[5] = { "Clé Business", "Une clé de biz bleue.", 2, 11746, 90, 0, 0, 0.012, weight = 0.1, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[73] = { "Télécommande Elevator", "Une petite télécommande pour changer le mode d'un Elevator.", 2, 364, 0, 0, 0, 0.05, weight = 0.3, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[47] = { "Clés de menottes", "Une petite paire de clés de menottes.", 4, 11746, 90, 0, 0, 0.012, weight = 0.05 },
	[98] = { "Télécommande de garage", "Une petite télécommande pour ouvrir ou fermer un garage.", 2, 364, 0, 0, 0, 0.05, weight = 0.3, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[290] = { "Télécommande hydraulique", "Une télécommande sans fil pour des hydrauliques avancées.", 4, 331, 0, 0, 0, -0.01, weight = 0.01, hideItemValue = true },
	[291] = { "Drone RC", "Un drone télécommandé avec #v batterie restante.", 4, 331, 0, 0, 0, -0.01, weight = 0.01, hideItemValue = true },
	[292] = { "E-Scooter", "Une trottinette électrique pliée.", 4, 1867, 0, 0, 0, -0.01, weight = 0.01, hideItemValue = true },
	[151] = { "Contrôleur de rampe", "Un dispositif distant pour une rampe de véhicule.", 2, 364, 0, 0, 0, 0.05, weight = 0.3 },
	[170] = { "Keycard", "A swipe card for #v", 2, 19792, 0, 0, 0, 0.011, weight = 0.1 }, -- Exciter
	[248] = { "Projector Remote", "A small remote to control the projector ##v.", 2, 364, 0, 0, 0, 0.05, weight = 0.3, ooc_item_value = true },
	
	--
	-- ELECTRONICS
	--
	[2] = { "Téléphone portable", "Un téléphone portable élégant, semble neuf.", 7, 330, 90, 90, 0, 0, weight = 0.3,
		metadata = { item_name = { type = 'string', rank = 'player' } } },
	[17] = { "Montre", "Une montre pour savoir l'heure.", 7, 1271, 0, 0, 0, 0.285, weight = 0.1,
		metadata = { item_name = { type = 'string', rank = 'staff' } } },
	[6] = { "Radio", "Une radio noire..", 7, 19942, 0, 0, 0, 0.08, weight = 0.2 },
	[54] = { "Boombox", "Une Boombox noire, pour écouter de la musique.", 7, 2226, 0, 0, 0, 0, weight = 3,
	newPickupMethod = true },
	[96] = { "Macbook Pro A1286 Core i7", "Un Macbook haut de gamme pour consulter les e-mails et naviguer sur internet.", 7, 100088, 0, 0, 180, 0.01, weight = 1 },
	[104] = { "TV Portable", "Une TV portable pour regarder des émissions de télévision.", 7, 1518, 0, 0, 0, 0.29, weight = 1 },
	[111] = { "GPS Portable", "Un GPS, contient également une carte récente (F11).", 7, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 111
	[288] = { "Lumière de culture", "Une lumière de culture.", 7, 100111, 0, 0, 0, -0.01, weight = 0.01, hideItemValue = true },
	[293] = { "Chargeur d'E-Scooter", "Un chargeur pour un e-scooter.", 7, 18874, 0, 0, 0, 0, weight = 0.01, hideItemValue = true },
	[350] = { "Balance électronique", "", 7, 100067, 90, 0, 0, 0.1, weight = 0.4},
	[351] = { "Compteur de billets", "", 7, 100068, 90, 0, 0, 0.1, weight = 0.4},
	[176] = { "Haut-Parleur", "Un grand haut-parleur noir.", 7, 2232, 0, 0, 0, 0.6, weight = 3 },
	
	--
	-- BOOKS / NOTES
	--
	[18] = { "Guide de la ville", "Un petit guide de la ville.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[20] = { "Combat standard pour les débutants", "Un livre sur comment faire du combat standard.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[21] = { "Boxe pour les débutants", "Un livre sur comment faire de la boxe.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[22] = { "Kung Fu pour les débutants", "Un livre sur comment faire du kung fu.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[23] = { "Genou/Tete pour les débutants", "Un livre sur comment faire du combat de saisie de pied.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[24] = { "Grab Kick Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[25] = { "Elbow Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[50] = { "Los Santos Highway Code", "Le code de la route de Los Santos.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[97] = { "Manuel LSES ", "Un manuel comportant plusieurs pages.", 5, 2824, 0, 0, 0, -0.01, weight = 0.5 },
	[52] = { "Manuel LSPD", "Le manuel du parfait policier.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[69] = { "Dictionnaire", "Un dictionnaire.", 5, 2824, 0, 0, 0, -0.01, weight = 1.5 },
	[71] = { "Bloc-Note", "Un petit ensemble de feuilles vierges, utile pour écrire des notes. Il reste #v pages. ((/writenote))", 4, 2894, 0, 0, 0, -0.01, weight = function(v) return v*0.01 end },
	[72] = { "Note", "La note indique : #v", 4, 2894, 0, 0, 0, 0.01, weight = 0.01 },
    [178] = { "Livre", "#v", 5, 2824, 0, 0, 0, -0.1, weight = 0.1}, -- Chaos
	[267] = { "Citation", "#v", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 },
	[305] = { "Reçu", "#v", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 },
	[51] = { "Chemistry 101",  "Introduction à la chimie utile.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },

	--
	-- SERVICE ITEMS (PD, FD, etc)
	--
	[27] = { "Flashbang", "Une petite grenade en forme de cannette avec FB écrit sur le côté.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[285] = { "Sabot", "Un dispositif de blocage de roue pour un véhicule.", 4, 1879, 270, 270, 0, 0, weight = 0.1},
	[28] = { "Bâton lumineux", "Un bâton lumineux vert.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[29] = { "Bélier de porte", "Un bélier de porte en métal rouge.", 4, 1587, 90, 0, 0, 0.05, weight = 3 },
	[45] = { "Menottes", "Une paire de menottes en métal.", 4, 19418, 90, 0, 0, 0.011, weight = 0.4 },
	[46] = { "Corde", "Une longue corde.", 4, 1271, 0, 0, 0, 0.285, weight = 0.3 },
	[53] = { "Breathalizer", "Un petit breathealyser noir.", 4, 1271, 0, 0, 0, 0.285, weight = 0.2 },
	[70] = { "Trousse de secours", "Sauve une vie. Peut être utilisé #v fois.", 4, 1240, 90, 0, 0, 0.05, weight = function(v) return v/3 end },
	[76] = { "Bouclier anti-émeute", "Un grand bouclier en plastique pour se protéger.", 4, 100079, 0, 0, 0, 0.1, weight = 5,
	artifactName = "shield", canToggleArtifact=true },
	-- [88] = { "Oreillette", "Une petite oreillette, peut être connectée à un radio.", 7, 19792, 0, 0, 0, 0.011, weight = 0.15 },
	[113] = { "Paquet de Bâtons Lumineux", "Paquet avec #v bâtons lumineux dedans, de la marque 'Vendredi'.", 6, 1210, 270, 0, 0, 0.1, weight = function(v) return v * 0.2 end }, -- 113
	[126] = { "Ceinturon de service", "Un ceinturon de service en cuir noir brillant, avec de nombreux étuis.", 4, 2386, 270, 0, 0, 0, weight = 0,
	extendInventorySpace=25, space = 25 }, -- 126
	[137] = { "Snake Cam", "Une caméra de serpent utilisée dans les opérations SWAT.", 7, 330, 90, 90, 0, -0.05, weight = 0.3 }, -- 137
	[141] = { "Mégaphone", "Un dispositif en forme de cône utilisé pour intensifier ou diriger votre voix.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 }, --141
	[143] = { "Mobile Data Terminal", "A Mobile Data Terminal.", 7, 2886, 0, 0, 180, 0.1, weight = 0.1 }, -- 143
	[174] = { "FAA Electronical Map Book", "Electronic device displaying information and maps around all San Andreas.", 4, 1271, 0, 0, 0, -0.01, weight = 0.01 }, -- Anumaz
	[177] = { "Dispositif de Dispatch", "Un dispositif de déploiement à distance connecté au Dispatcher.", 7, 19792, 0, 0, 0, 0.011, weight = 0.01 }, -- anumaz
	[209] = { "FLU Device", "An eletronical device by Firearms Licensing Unit", 7, 1271, 0, 0, 0, 0, weight = 0.1}, -- anumaz
	[217] = { "Beeper", "An eletronical beeper used on specific frequencies.", 7, 1271, 0, 0, 0, 0, weight = 0.1}, -- anumaz, currently used for lsfd /alarm

	--
	-- BADGES
	--
	[64] = { "Badge LSPD", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[65] = { "Badge LSFD", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[87] = { "Badge LSGOV", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[82] = { "Badge Mechanic Garage", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[295] = { "Badge AutoParks", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[246] = { "Badge LSBank", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 }, --Exciter
	[86] = { "Badge SANN", "#v", 10, 330, 90, 90, 0, -0.05, weight = 0.3 },
	[131] = { "Badge FAA", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 }, -- 131
	[233] = { "Badge FBI", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[156] = { "Badge Justice", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },

	-- CARDS / LICENSES
	--
	[173] = { "Papiers pour vente de véhicule", "Document nécessaire pour vendre un véhicule à quelqu'un d'autre.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, -- Anumaz
	[78] = { "San Andreas Pilot Certificate", "An official permission to fly planes and helicopters.", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[55] = { "Carte de visite", "#v", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },
	[133] = { "Permis de conduire automobile", "Un permis de conduire de Los Santos.", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },
	[148] = { "Open Carry Weapon License", "Un permis de port d'arme.", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[149] = { "Concealed Carry Weapon License - LSPD", "A firearm permit which allows the concealment of a firearm, issued by LSPD.", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[215] = { "Concealed Carry Weapon License - SAHP", "A firearm permit which allows the concealment of a firearm, issued by SAHP.", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[216] = { "Tier 3 Weaponry License - SAN ANDREAS", "A firearm permit which allows the handling of Tier 3 weaponry, issued by the ATF bureau.", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 },
	[150] = { "Carte Bancaire", "Une carte en plastique utilisée pour faire des transactions avec un montant très limité par jour à partir d'un guichet automatique (ATM)", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },
	[152] = { "Carte d'identité", "Une carte d'identité, état de San Andreas.", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },
	[153] = { "Permis de conduire - Moto", "Un permis de conduire à Los Santos", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },
	[154] = { "Permis de pêche", "Un permis de pêche à Los Santos", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },
	[155] = { "Permis de conduire - Bateau", "Un permis de conduire à Los Santos", 10, 19792, 0, 0, 0, 0.011, weight = 0.1 },
	
	--
	-- CLOTHES, WEARABLES & RELATED 
	--
	[16] = { "Vêtements", "Un ensemble de vêtements propres. (( Skin ID ##v ))", 6, 2386, 0, 0, 0, 0.1, weight = 1, metadata = { item_name = { type = 'string', rank = 'player', max_length = 50 } } },
	[26] = { "Masque à gaz", "Un masque à gaz noir, bloque les effets des gaz et des flashbangs.", 6, 100078, 0, 0, 0, 0.1, weight = 0.5,
		artifactName = "gasmask", },
	[48] = { "Sac à dos", "Un sac à dos raisonnable en taille.", 4, 3026, 270, 0, 0, 0, weight = 1,
	artifactName="backpack", autoAddArtifact=true, extendInventorySpace=10, space = 10 },
	[49] = { "Canne à pêche robuste", "Une canne à pêche en acier carbone de 7 pieds.", 4, 338, 80, 0, 0, -0.02, weight = 1.5,
	artifactName = "rod", canToggleArtifact=true },
	[56] = { "Cagoule", "Un masque de ski.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2, artifactName = "cagoule" },
	[90] = { "Casque de motocross", "Idéal pour conduire des motos.", 6, 100075, 0, 0, 0, 0.2, weight = 1.5, scale = 1,
		hideItemValue = true, -- metadata = { url = { type = 'string', rank = 'player', max_length = 50 } }
		artifactName = "helmet",
	},
	[66] = { "Bandeau", "Un chiffon pour bander les yeux de quelqu'un.", 6, 100045, 0, 0, 0, 0.1, weight = 0.1, blindfoldItem = true },
	[120] = { "Équipement de plongée", "Te permet de rester sous l'eau pendant un certain temps.", 6, 1271, 0, 0, 0, 0.285, weight = 4 }, --120
	[160] = { "Mallette", "Une mallette.", 6, 1210, 90, 0, 0, 0.1, weight = 0.4, 
		artifactName="briefcase", autoAddArtifact=true, extendInventorySpace=5, space = 5}, -- Exciter
	[171] = { "Casque de motard", "Idéal pour les motos.", 6, 100076, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true, --metadata = { url = { type = 'string', rank = 'player', max_length = 50 } }
	artifactName="bikerhelmet" },
	[172] = { "Casque intégral", "Idéal pour les motos.", 6, 100077, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true, -- metadata = { url = { type = 'string', rank = 'player', max_length = 50 } }
	artifactName="fullfacehelmet" },
	[240] = { "Christmas Hat", "A festive hat.", 6, 100094, 0, 0, 0, 0.1, weight = 0.1,
	artifactName="christmashat"}, -- Chaos
	[270] = { "Gants", "Une paire de gants que vous pouvez porter.", 6, 2386, 0, 0, 0, 0.1, weight = 0.1, hideItemValue = true, metadata = { item_name = { type = 'string', rank = 'player', max_length = 50 } } }, -- Hurley
	[219] = { "Gilet pare-balles (caché)", "Armure: #v%", 6, 1242, 90, 0, 0, 0.1, weight = 1 },
	[220] = { "Gilet pare-balles (Police v1)", "Armure: #v%", 6, 100081, 90, 0, 0, 0.1, weight = 1 },
	[221] = { "Gilet pare-balles (Police v2)", "Armure: #v%", 6, 100082, 90, 0, 0, 0.1, weight = 1 },
	[307] = { "Gilet pare-balles (Médecin)", "Armure: #v%", 6, 100083, 90, 0, 0, 0.1, weight = 1 },

	--> Blackmarket's kevlars
	[400] = { "Gilet pare-balles (Discret)", "Armure: #v%", 6, 1242, 90, 0, 0, 0.1, weight = 1 },
	[401] = { "Gilet pare-balles", "Armure: #v%", 6, 100083, 90, 0, 0, 0.1, weight = 1 },

	[163] = { "Sac de sport", "Un sac de sport noir.", 6, 100074, 90, 0, 0, 0.2, weight = 0.4,
	artifactName="dufflebag", autoAddArtifact=true, extendInventorySpace=15, space = 15},
	[164] = { "Sac médical", "Sac contenant un équipement médical avancé.", 6, 100085, 0, 0, 0, 0.2, weight = 0.5,
	artifactName="medicbag", autoAddArtifact=true, extendInventorySpace=25, space = 25},
	[339] = { "Sac boutique", "", 6, 100020, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac_papier", autoAddArtifact=true, extendInventorySpace=7, space = 7},
	[340] = { "Sac à dos Eastpak", "", 6, 100030, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac1", autoAddArtifact=true, extendInventorySpace=10, space = 10},
	[341] = { "Sac à dos Jansport", "", 6, 100031, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac2", autoAddArtifact=true, extendInventorySpace=10, space = 10},
	[342] = { "Sac à dos E-ZIP", "", 6, 100032, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac3", autoAddArtifact=true, extendInventorySpace=10, space = 10},
	[343] = { "Sac à dos Camouflage", "", 6, 100033, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac4", autoAddArtifact=true, extendInventorySpace=10, space = 10},
	[344] = { "Sac à dos Bleu à motifs", "", 6, 100034, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac5", autoAddArtifact=true, extendInventorySpace=10, space = 10},
	[345] = { "Sac de sport Noir", "", 6, 100035, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac6", autoAddArtifact=true, extendInventorySpace=15, space = 15},
	[346] = { "Sac de sport Bleu foncé", "", 6, 100036, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac7", autoAddArtifact=true, extendInventorySpace=15, space = 15},
	[347] = { "Sac à main", "", 6, 100037, 90, 0, 0, 0.1, weight = 0.1,
	artifactName="sac8", autoAddArtifact=true, extendInventorySpace=8, space = 8},


	--
	-- BANDANAS
	--
	-- [defined as badge below]   Image: bandana.png colored
	[158] = { "Bandana vert", "", 6, 100042, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_vert" },
	[135] = { "Bandana bleu", "", 6, 100043, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_bleu" },
	[136] = { "Bandana marron", "", 6, 100044, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_marron" },
	[237] = { "Bandana noir", "", 6, 100045, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_noir"},
	[338] = { "Bandana tête de mort", "", 6, 100046, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_skull"},
	[123] = { "Bandana rouge", "", 6, 100047, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_rouge" },
	[124] = { "Bandana jaune", "", 6, 100048, 0, 0, 0, 0.1, weight = 0.2 , artifactName="bandana_jaune"},
	[125] = { "Bandana violet", "", 6, 100049, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_violet" },
	[122] = { "Bandana bleu clair", "", 6, 100095, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_bleu_clair" },
	[168] = { "Bandana orange", "", 6, 100096, 0, 0, 0, 0.1, weight = 0.2 , artifactName="bandana_orange"},
	[238] = { "Bandana gris", "", 6, 100097, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_gris"},
	[239] = { "Bandana blanc", "", 6, 100098, 0, 0, 0, 0.1, weight = 0.2, artifactName="bandana_blanc"},

	-- [defined as badge below]   Image: headband.png colored
	[337] = { "Bandeau vert", "", 6, 100050, 0, 0, 0, 0.1, weight = 0.1, artifactName="bandeau_vert" },
	[336] = { "Bandeau bleu", "", 6, 100051, 0, 0, 0, 0.1, weight = 0.1, artifactName="bandeau_bleu" },
	[352] = { "Bandeau marron", "", 6, 100052, 0, 0, 0, 0.1, weight = 0.1 , artifactName="bandeau_marron"},
	[334] = { "Bandeau noir", "", 6, 100053, 0, 0, 0, 0.1, weight = 0.1, artifactName="bandeau_noir" },
	[335] = { "Bandeau rouge", "", 6, 100054, 0, 0, 0, 0.1, weight = 0.1 , artifactName="bandeau_rouge"},
	[333] = { "Bandeau jaune", "", 6, 100055, 0, 0, 0, 0.1, weight = 0.1 , artifactName="bandeau_jaune"},
	[353] = { "Bandeau violet", "", 6, 100056, 0, 0, 0, 0.1, weight = 0.1 , artifactName="bandeau_violet"},
	[354] = { "Bandeau bleu clair", "", 6, 100099, 0, 0, 0, 0.1, weight = 0.1, artifactName="bandeau_bleu_clair" },
	[355] = { "Bandeau orange", "", 6, 100100, 0, 0, 0, 0.1, weight = 0.1, artifactName="bandeau_orange" },
	[356] = { "Bandeau gris", "", 6, 100101, 0, 0, 0, 0.1, weight = 0.1 , artifactName="bandeau_gris"},
	[357] = { "Bandeau blanc", "", 6, 100102, 0, 0, 0, 0.1, weight = 0.1 , artifactName="bandeau_blanc"},

	--
	-- OOC ITEMS
	--
	[303] = { "(( Coin OOC ))", "#v", 4, 1212, 0, 0, 0, 0, weight = 0 },
	
	--
	-- BOITES / SIMPLES OBJETS
	--
	[80] = { "Generic Item", "#v", 4, 1271, 0, 0, 0, 0, weight = 1, newPickupMethod = true, metadata = { 
			
			item_name = { type = 'string', rank = 'staff' },
			model = { type = 'integer', rank = 'staff' },
			alpha = { type = 'integer', rank = 'staff' },
			scale = { type = 'string', rank = 'staff' },
			disable_col = { type = 'boolean', rank = 'staff' },
			doublesided = { type = 'boolean', rank = 'staff' },
			-- url = { type = 'string', rank = 'staff' },
			-- texture = { type = 'string', rank = 'staff' },
			weight = { type = 'string', rank = 'staff' },
		}
	},
	[223] = { "Storage Generic", "#v", 4, 3761, -0.15, 0, 85, 0.2, weight = 2, newPickupMethod = true, storage = true, metadata = {
			
			capacity = { type = 'integer', rank = 'staff' },
			item_name = { type = 'string', rank = 'staff' },
			alpha = { type = 'integer', rank = 'staff' },
			model = { type = 'integer', rank = 'staff' },
			doublesided = { type = 'boolean', rank = 'staff' },
			disable_col = { type = 'boolean', rank = 'staff' },
			scale = { type = 'string', rank = 'staff' },
			-- url = { type = 'string', rank = 'staff' },
			-- texture = { type = 'string', rank = 'staff' },
		}
	},
	[157] = { "Boîte à outils", "Une boîte à outils rouge en métal contenant divers outils", 4, 19921, 0, 0, 0, 0, weight = 0.5 },
	[121] = { "Boîte de fournitures", "Jolie grande boîte pleine de fournitures!", 4, 1271, 0, 0, 0, 0.285,
		weight = function(v) return tonumber(v) and tonumber(v) or 50 end },-- supplies system
	[314] = { "Pack de bière Budweiser", "", 4, 100007, 0, 0, 0, 0.0, weight = 0.5 },
	[315] = { "Pack de biere Corona", "", 4, 100008, 0, 0, 0, 0.0, weight = 0.5 },
	[316] = { "Pack de bière Heineken", "", 4, 100009, 0, 0, 0, 0.0, weight = 0.5 },

	--
	-- VEHICLE RELATED
	--
	[118] = { "Passe pour peage", "Mets-le dans ta voiture, te facture à chaque passage à un péage.", 7, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 118
	[130] = { "Système d'alarme de véhicule", "Un système d'alarme de véhicule.", 7, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 130
	[212] = { "Snow Tires", "Stick to the ground like velcro!", 4, 1098, 0, 0, 0, 0, weight = 1}, -- Exciter
	[275] = { "Cadenas pour vélo", "Cadenas pour vélo.", 4, 1271, 0, 0, 0, 0, weight = 0.1}, -- SjoerdPSV
	[294] = { "Polissage de carrosserie", "Un pot de cirage pour la peinture du véhicule.", 4, 2894, 0, 0, 0, -0.01, weight = 1, hideItemValue = true },
	[304] = { "(( Toujours Propre ))", "A placer dans un véhicule.", 4, 1212, 0, 0, 0, 0, weight = 0 },
	[114] = { "Vehicle Upgrade", "#v", 4, 1271, 0, 0, 0, 0.285, weight = 1.5 }, -- 114
	[117] = { "Rampe", "Utile pour charger les DFT-30.", 4, 1210, 270, 1, 0, 0.1, 3, weight = 5, onlyAdminCanMove = true  }, -- 117
	[61] = { "Emergency Light Strobes", "An Emergency Light Strobe which you can put in your car.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1, onlyAdminCanMove = true },
	[85] = { "Sirène d'urgence (police)", "Une sirène d'urgence pour mettre dans votre voiture.", 7, 330, 90, 90, 0, -0.05, weight = 0.2, onlyAdminCanMove = true },
	[84] = { "Escort 9500ci Radar Detector", "Détecte la police à moins d'un kilomètre.", 7, 330, 90, 90, 0, -0.05, weight = 1 },
	[264] = { "VMAT ADS-B", "Airport ground vehicle tracking unit.", 6, 2886, 0, 0, 180, 0.1, weight = 0.9 }, --Exciter
	[139] = { "Traqueur véhicule", "Un dispositif utilisé pour suivre la position du véhicule", 7, 1271, 0, 0, 0, 0.285, weight = 0.2, onlyAdminCanMove = true }, --139
	[144] = { "Yellow Strobe", "A yellow strobe to put on your car.", 7, 2886, 270, 0, 0, 0.1, weight = 0.1, onlyAdminCanMove = true }, -- 144
	[261] = { "Emergency Siren (Firetruck)", "An emergency siren to put in your car.", 7, 330, 90, 90, 0, -0.05, weight = 0.2, image = 85, onlyAdminCanMove = true }, -- Chaos
	[269] = { "Emergency Siren (Ambulance)", "An emergency siren to put in your car.", 7, 330, 90, 90, 0, -0.05, weight = 0.2, image = 85, onlyAdminCanMove = true }, -- Hurley
	[284] = { "ANPR System", "Automatic NumberPlate Recognition.", 4, 367, 270, 270, 0, 0, weight = 0.1, onlyAdminCanMove = true},
	[140] = { "Orange Light Strobes", "An Orange Light Strobe which you can put on you car.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1, onlyAdminCanMove = true }, --140
	[57] = { "Bidon d'essence", "Un large bidon d'essence en métal.", 4, 1650, 0, 0, 0, 0.30, weight = 1 }, -- would prolly to make sense to make it heavier if filled
	

	--
	-- OTHERS / MISC
	--
	[302] = { "Argent sale", "$#v d'argent sale.", 10, 100069, 0, 0, 0, 0.05, weight = 0.2 },
	[134] = { "Argent (Cash)", "Dollars des Etats-Unis.", 10, 100069, 0, 0, 0, 0.05, weight = 0.2 }, -- 134
	[211] = { "A Christmas Lottery Ticket", "From the Coca-Cola Santa.", 10, 19792, 0, 0, 0, 0.011, weight = 0.1}, -- Exciter
	[10] = { "Dé", "Un dé rouge avec des points blancs sur #v côtés.", 4, 1271, 0, 0, 0, 0.285, weight = 0.1 },
	[77] = { "Paquet de cartes", "Un jeu de cartes!.", 4,2824, 0, 0, 0, -0.01, weight = 0.1 },
	[68] = { "Billet de loterie", "Un billet de loterie à Los Santos.", 6, 2894, 0, 0, 0, -0.01, weight = 0.1 },
	[79] = { "Porn Tape", "A porn tape, #v", 4,2824, 0, 0, 0, -0.01, weight = 0.2 },
	[94] = { "Cadeau de Noël", "Je sais que tu en veux un.", 4, 1220, 0, 0, 0, 0.1, weight = 1 },

	-- Blackmarket workbench
	[366] = {"Atelier", "Permet la construction de divers objets.", 4, 100110,  0,  0,  0,  0,  weight = 1, scale = 1}, 

	-- Blackmarket

	[500] = {"Pied de biche", "Utile dans certaines situations.", 4, 1210,  0,  0,  0,  0,  weight = 1, scale = 1}, 
	[503] = {"Boîtier électronique", "Utile dans certaines situations.", 4, 1210,  0,  0,  0,  0,  weight = 1, scale = 1}, 

	--

	[501] = {"Alarme véhicule", "Système d'alarme pour véhicule", 4, 1210,  0,  0,  0,  0,  weight = 1, scale = 1}, 
	[502] = {"Nouvelle sérrure", "Sérrure de porte", 4, 1210,  0,  0,  0,  0,  weight = 1, scale = 1},

	--

	[504] = {"Shoulder-mounted Camera", "Shoulder-mounted Camera", 4, 1210,  0,  0,  0,  0,  weight = 2, scale = 1}, 
	[505] = { "TV Portable", "Une TV portable pour regarder des émissions de télévision.", 7, 19786, 0, 0, 0, 0.7, weight = 1 },


	--
	-- OLD / DEACTIVATED
	--
	-- [138] = { "Système de véhicule appât", "Un dispositif utilisé dans les opérations de police.", 4, 1271, 0, 0, 0, 0.285, weight = 0.5 }, -- 138
	-- [262] = { "Token (( House Token ))", "A small plastic token. (( Used to purchase a new house of < $40,000 value ))", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, --Chaos
	-- [263] = { "Token (( Jeton de véhicule ))", "Un petit jeton en plastique. (( Utilisé pour acheter un nouveau véhicule de valeur < $10 000 ))", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, --Chaos

	-- [210] = { "Coca-Cola Christmas", "A bottle of coke, christmas edition.", 1, 2880, 180, 0, 0, 0, weight = 0.2}, -- Exciter
	-- [9] = { "Boisson gazeuse", "Une canette de Sprunk.", 1, 2647, 0, 0, 0, 0.12, weight = 0.2 },
	-- [7] = { "Annuaire", "Un annuaire déchiré.", 5, 2824, 0, 0, 0, -0.01, weight = 2 },
	-- [19] = { "Lecteur MP3", "Un lecteur MP3 blanc et élégant. La marque lit EyePod.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 },
	--[59] = { "Mudkip", "So i herd u liek mudkips? mabako's Favorite.", 1, 1579, 0, 0, 0, 0, weight = 0 },
	-- [60] = { "Coffre-fort", "Un coffre-fort pour ranger vos objets.", 4, 2332, 0, 0, 0, 0, weight = 5 }, -- Deprecated (now use storage generics) | Nando
	--[67] = { "GPS", "(( This item is currently disabled. ))", 6, 1210, 270, 0, 0, 0.1, weight = 0.8 },
	--[74] = { "Bomb", "What could possibly happen when you use this?", 4, 363, 270, 0, 0, 0.05, weight = 2 },
	--[75] = { "Bomb Remote", "Has a funny red button.", 4, 364, 0, 0, 0, 0.05, weight = 100000 },
	
	-- Fuck this item, use storage generics instead - Nando
	-- [81] = { "Réfrigérateur", "Un réfrigérateur pour stocker de la nourriture et des boissons.", 7, 2147, 0, 0, 0, 0, weight = 0.1, storage = true, capacity = 50, acceptItems = {[-1] = true} },
	
	-- No longer used (Nando)
	-- [89] = { "Generic Food", "#v", 1, 2222, 0, 0, 0, 0.07, weight = 0.5, newPickupMethod = true },
	-- [95] = { "Generic Drink", "#v", 1, 1455, 0, 0, 0, 0, weight = 0.5, newPickupMethod = true }, --[95] = { "Drink", "", 1, 1484, -15, 30, 0, 0.2, weight = 1 },

	-- Fuck this item, use storage generic instead.
	-- [103] = { "Étagère", "Une grande étagère pour ranger des objets.", 4, 3761, -0.15, 0, 85, 1.95, weight = 0.1, storage = true, capacity = 100 },



	-- We wont use the owl interior texture-system now
	-- [147] = { "Wallpaper", "For retexturing your interior.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, --147

	-- [162] = { "Gilet pare-balles", "Gilet pare-balles", 6, 19142, 90, 0, 0, 0.1, weight = 4}, -- Exciter
	-- [165] = { "DVD", "Un disque vidéo.", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, -- Exciter
	-- [166] = { "ClubTec VS1000", "Système vidéo.", 4, 3388, 0, 0, 90, -0.01, weight = 5, scale = 0.6, newPickupMethod = true }, -- Exciter


	-- Not used currently - Nando
	-- [175] = { "Poster", "Un poster publicitaire.", 4, 2717, 0, 0, 0, 0.7, weight = 0.01, hideItemValue = true }, -- Exciter
    -- [179] = { "Motif de voiture", "Un motif pour décorer votre voiture.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, -- Exciter

	-- NO LONGER USED - Nando
    -- [183] = { "Viozy Membership Card", "Viozy Businesses Exclusive Membership", 10, 19792, 0, 0, 0, 0.011, weight = 0.3 }, --  Chase
    -- [184] = { "HP Charcoal Window Film", "Viozy HP Charcoal Window Film ((50 /chance))", 4, 1271, 0, 0, 0, 0, weight = 0.6 }, -- Chase
    -- [185] = { "CXP70 Window Film", "Viozy CXP70 Window Film ((95 /chance))", 4, 1271, 0, 0, 0, 0, weight = 0.3 }, -- Chase
    -- [186] = { "Viozy Border Edge Cutter (Red Anodized)", "Border Edge Cutter for Tinting", 4, 1271, 0, 0, 0, 0, weight = 0.05 }, -- Chase
    -- [187] = { "Viozy Solar Spectrum Tranmission Meter", "Spectrum Meter for testing film before use", 7, 1271, 0, 0, 0, 0, weight = 2 }, -- Chase
    -- [188] = { "Viozy Tint Chek 2800", "Measures the Visible Light Transmission on any film/glass", 7, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    -- [189] = { "Viozy Equalizer Heatwave Heat Gun", "Easy to use heat gun perfect for shrinking back windows", 7, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    -- [190] = { "Viozy 36 Multi-Purpose Cutter Bucket", "Ideal for light cutting jobs while applying tint", 4, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    -- [191] = { "Viozy Tint Demonstration Lamp", "Effectve presentation of tinted application", 7, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    -- [192] = { "Viozy Triumph Angled Scraper", "6-inch Angled Scraper for applying tint", 4, 1271, 0, 0, 0, 0, weight = 0.3 }, -- Chase
    -- [193] = { "Viozy Performax 48oz Hand Sprayer", "Performax Hand Sprayer for tint application", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    -- [194] = { "Viozy Vehicle Ignition - 2010 ((20 /chance))", "Vehicle Ignition made by Viozy for 2010", 4, 1271, 0, 0, 0, 0, weight = 1.5 }, -- Chase
    -- [195] = { "Viozy Vehicle Ignition - 2011 ((30 /chance))", "Vehicle Ignition made by Viozy for 2011", 4, 1271, 0, 0, 0, 0, weight = 1.3 }, -- Chase
    -- [196] = { "Viozy Vehicle Ignition - 2012 ((40 /chance))", "Vehicle Ignition made by Viozy for 2012", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    -- [197] = { "Viozy Vehicle Ignition - 2013 ((50 /chance))", "Vehicle Ignition made by Viozy for 2013", 4, 1271, 0, 0, 0, 0, weight = 0.8 }, -- Chase
    -- [198] = { "Viozy Vehicle Ignition - 2014 ((70 /chance))", "Vehicle Ignition made by Viozy for 2014", 4, 1271, 0, 0, 0, 0, weight = 0.6 }, -- Chase
    -- [199] = { "Viozy Vehicle Ignition - 2015 ((90 /chance))", "Vehicle Ignition made by Viozy for 2015", 4, 1271, 0, 0, 0, 0, weight = 0.4 }, -- Chase
    --[200] = { "Viozy Vehicle Ignition - 2016", "Vehicle Ignition not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    --[201] = { "Viozy Vehicle Ignition - 2017", "Vehicle Ignition not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    --[202] = { "Viozy Vehicle Ignition - 2018", "Vehicle Ignition not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    -- [203] = { "Viozy Hidden Vehicle Tracker 315 Pro ((Undetectable))", "GPS HVT 315 Pro, easy installation ((and undetectable)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 3 }, -- Chase
    -- [204] = { "Viozy Hidden Vehicle Tracker 272 Micro ((30 /chance))", "GPS HVT 272 Micro, easy installation ((30 /chance to be found)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    -- [205] = { "Viozy HVT 358 Portable Spark Nano 4.0 ((50 /chance))", "GPS HVT 358 Spark Nano 4.0 Portable ((50 /chance to be found)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 0.2 }, -- Chase

	--[206] = { "Wheat Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	--[207] = { "Barley Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	--[208] = { "Oat Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos


	-- Not used currently - Nando
	-- [214] = { "Generic Drug", "#v", 3, 1576, 0, 0, 0, 0.07, weight = 0.1}, -- Chaos


	-- Fuck this item, use storage generic instead
	-- [231] = { "Shipping Container", "A large freight container.", 4, 2934, 0, 0, 0, 1.44, weight = 0.1, hideItemValue = true, storage = true, capacity = 200 }, --Exciter --preventSpawn = true --value= registration;textureSides;textureDoors
	
	-- [242] = { "Workbench", "A bench to build things on.", 4, 936, 0, 0, 0, 0, weight = 4, storage = true, capacity = 20 }, --Exciter, factory system --preventSpawn = true
	-- [243] = { "Factory Machine", "A machine to produce things.", 4, 14584, 0, 0, 0, 0, weight = 5, storage = true, capacity = 50 }, --Exciter, factory system --preventSpawn = true
	-- [244] = { "Oven", "A oven for cooking and baking.", 4, 2417, 0, 0, 0, 0, weight = 4, storage = true, capacity = 10 }, --Exciter, factory system --preventSpawn = true
	-- [252] = { "Dumpster", "A dumpster.", 4, 1344, 0, 0, 0, 0, weight = 4, hideItemValue = true, storage = true, capacity = 200 }, --Exciter
	-- [253] = { "Garbage Bin", "A garbage bin.", 4, 1344, 270, 270, 0, 0, weight = 3, hideItemValue = true, storage = true, capacity = 50 }, --Exciter
	-- [254] = { "Litter", "#vkg of litter.", 4, 1344, 270, 270, 0, 0, weight = function(v) return v end }, --Exciter --math.floor((v/50)*(10^2)+0.5)/(10^2)
	-- [255] = { "Waste", "#vkg of waste.", 4, 1344, 270, 270, 0, 0, weight = function(v) return v end }, --Exciter
	-- [256] = { "Blu-Ray", "A video disc.", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, --Exciter
	-- [257] = { "ClubTec VS2000", "Video System.", 4, 3388, 0, 0, 90, -0.01, weight = 6, newPickupMethod = true, image = 166 }, --Exciter
	-- [268] = { "Surfboard", "A surfboard.", 4, 2406, 0, 0, 0, 1.2, weight = 2 }, --Exciter

	-- [272] = { "Labrador", "#v", 4, 2351, 0, 0, 0, 0.9, weight = 5 }, -- (Dog) Yannick
	-- [273] = { "Generic Fish", "#v", 4, 1604, 0, 90, 0, 0.07, weight = 0.1},
	-- [274] = { "Ice Skates", "Perfect for skating on ice!", 6, 1852, 0, 0, 0, 1, weight = 0.1},


	-- Not used currently
	-- [167] = { "Cadre photo (cadre doré)", "Mettez votre photo et accrochez-la sur votre mur.", 4, 2287, 0, 0, 0, 0, weight = 1, doubleSided = true, newPickupMethod = true }, -- Exciter
	
}


weaponmodels = {
	[1]=331, [2]=333, [3]=326, [4]=335, [5]=336, [6]=337, [7]=338, [8]=339, [9]=341,
	[15]=326, [22]=346, [23]=347, [24]=348, [25]=349, [26]=350, [27]=351, [28]=352,
	[29]=353, [32]=372, [30]=355, [31]=356, [33]=357, [34]=358, [35]=359, [36]=360,
	[37]=361, [38]=362, [16]=342, [17]=343, [18]=344, [39]=363, [41]=365, [42]=366,
	[43]=367, [10]=321, [11]=322, [12]=323, [14]=325, [44]=368, [45]=369, [46]=371,
	[40]=364, [100]=373
}

-- other melee weapons?
weaponweights = {
	[22] = 1.14, [23] = 1.24, [24] = 2, [25] = 3.1, [26] = 2.1, [27] = 4.2, [28] = 3.6, [29] = 2.640, [30] = 4.3, [31] = 2.68, [32] = 3.6, [33] = 4.0, [34] = 4.3
}

--
-- Badges
--

function getBadges( )
	return {
		-- [itemID] = {
		-- 		elementData, name(unused), factionIDs, color, iconID}    iconID: 1 = ID, 2 = badge
		
		-- first value is ELEMENT DATA name, it's not actually displayed anywhere - Nando

		-- bandanas
		[158] = { "bandana vert", false,				{[-1] = true}, {50,150,50},	false, bandana = true},
		[135] = { "bandana bleu", false,					{[-1] = true}, {0,100,255},	false, bandana = true},
		[136] = { "bandana marron", false,				{[-1] = true}, {125,63,50},	false, bandana = true},
		[237] = { "bandana noir", false, 				{[-1] = true}, {100,100,100}, 	false, bandana = true},
		[338] = { "bandana tête de mort", false, 		{[-1] = true}, {100,55,55}, 	false, bandana = true},
		[123] = { "bandana rouge", false,					{[-1] = true}, {220,0,0},	false, bandana = true},
		[124] = { "bandana jaune", false,				{[-1] = true}, {255,250,0},	false, bandana = true},
		[125] = { "bandana violet", false,				{[-1] = true}, {220,0,255},	false, bandana = true},
		[122] = { "bandana bleu clair", false,		{[-1] = true}, {0,185,200},	false, bandana = true},
		[168] = { "bandana orange", false,				{[-1] = true}, {210,105,30},false, bandana = true},
		[238] = { "bandana gris", false,					{[-1] = true}, {150,150,150},false, bandana = true},
		[239] = { "bandana blanc", false, 				{[-1] = true}, {255,255,255},false, bandana = true},

		-- headbands
		[337] = { "bandeau vert", false, 				{[-1] = true}, {50,150,50},false, headband = true},
		[336] = { "bandeau bleu", false, 				{[-1] = true}, {0,100,255},false, headband = true},
		[352] = { "bandeau marron", false, 				{[-1] = true}, {125,63,50},false, headband = true},
		[334] = { "bandeau noir", false, 				{[-1] = true}, {100, 100, 100},false, headband = true},
		[335] = { "bandeau rouge", false, 				{[-1] = true}, {220,0,0},false, headband = true},
		[333] = { "bandeau jaune", false, 				{[-1] = true}, {255,250,0},false, headband = true},
		[353] = { "bandeau violet", false, 				{[-1] = true}, {220,0,255},false, headband = true},
		[354] = { "bandeau bleu clair", false, 			{[-1] = true}, {0,185,200},false, headband = true},
		[355] = { "bandeau orange", false, 				{[-1] = true}, {210,105,30},false, headband = true},
		[356] = { "bandeau gris", false, 				{[-1] = true}, {150,150,150},false, headband = true},
		[357] = { "bandeau blanc", false, 				{[-1] = true}, {255,255,255},false, headband = true},

		-- faction badges		
		[64]  = { "badge LSPD", 		false,			{[1] = true},				 	{0,100,255, true},	2},
		[65]  = { "badge LSFD", 		false, {[2] = true},	    {175, 50, 50},	1},
		[87]  = { "badge LSGOV", 		false,			{[3] = true},				 	{118, 177, 219},	1},
		[82] = { "TC1 ID", false,	{[4] = true},	{255,136,0},	1},
		[295] = { "TC2 ID", false,	{[10] = true},	{255,136,0},	1},
		[246] = { "Bank of Los Santos ID", false, {[5] = true}, {144, 195, 212}, 1},
		[86]  = { "badge SANN",		false,				{[8] = true},					{150,150,255},	1},
		[131] = { "badge FAA", false, {[9] = true}, {222, 184, 135, true},	2},
		[233] = { "badge FBI", false, {[84] = true}, {11, 97, 11}, 2},
		[156]  = { "badge Justice SA", 		false,			{[85] = true},				 	 {0, 102, 255}, 2},
	}
end

-- badges/IDs should generally be in the wallet.
for k, v in pairs(getBadges()) do
	if not v[3][-1] and g_items[k][3] ~= 10 then
		outputDebugString('Badge/ID' .. k .. ' is not in wallet.')
	end
end

--
-- Mask Data
--
function getMasks( )
	return {
		-- [itemID] = { elementData, textWhenPuttingOn, textWhentakingOff, hideIdentity }
		[26]  = {"gasmask",			"enfile un masque à gas",	"retire un masque à gas",	true},
		[56]  = {"mask",			"enfile une cagoule",						"retire sa cagoule",				true},
		[90]  = {"helmet",			"enfile un casque sur sa tête",				"retire son casque",				false},
		[120] = {"scuba",			"puts scuba gear on",						"takes scuba gear off",						true},
		[171] = {"bikerhelmet",		"enfile un casque sur sa tête",				"retire son casque",				false},
		[172] = {"fullfacehelmet",	"enfile un casque sur sa tête",				"retire son casque",				true},
		[240] = {"christmashat",	"puts a #name on their head",				"takes a #name off their head",				false},
	}
end

--
-- Armor [Nando]
--
ARMOR_ITEMS = {
	-- ame ON, ame OFF, artifact name
	[219]  = {"enfile un gilet pare-balle sous ses vêtements", "retire son gilet par balle"},
	[220]  = {"enfile un gilet pare-balle", "retire le gilet par balle", "vest_lspd1"},
	[221]  = {"enfile un gilet pare-balle", "retire le gilet par balle", "vest_lspd2"},
	[307]  = {"enfile un gilet pare-balle", "retire le gilet par balle", "vest_lsfd"},

	--> New: Vests
	[400]  = {"enfile un gilet pare-balle sous ses vêtements", "retire son gilet par balle"},
	[401]  = {"enfile un gilet pare-balle", "retire le gilet par balle"},
}

MISSING_IMAGE_PATH = ":account/img/nil.png"