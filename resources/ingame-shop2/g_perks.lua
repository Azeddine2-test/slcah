--[[
	adding percentOff=int = adds it to "featured" on sale.
	
	item types:
		1 - vehicle
		2 - item
		3 - Perk

]] 

moneyPerCoin = 10

VIPShopItems = {

	-- {name="Porsche Cayman (2015)", image="corvette", vehLibID=406, itemType=1, cash=200000, coins=3200, percentOff=10, offerTimestamp=1674743200, description =  
	-- 	[["Prenez place dans ce bolide racé et offrez-vous une expérience de conduite inoubliable. Avec sa carrosserie élégante et sportive, ce coupé 2 portes est un véritable bijou de technologie, conçu pour offrir des performances de pointe à chaque instant. Sous le capot, un moteur six cylindres de 2,7 litres, associé à une boîte de vitesses manuelle à six rapports, vous propulsera de 0 à 100 km/h en seulement 5,4 secondes. Avec ses suspensions et ses freins de haute performance, cette voiture offre une tenue de route impeccable, une stabilité sans faille et une conduite précise à chaque virage. Montez à bord et découvrez une expérience de conduite à couper le souffle avec le Porsche Cayman (2015).
		
	-- 	((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},
		
	-- {name="Range Rover Sport (2015)", image="roversport", vehLibID=397, itemType=1, cash=150000, coins=2750, percentOff=10, offerTimestamp=1674743200, description =  
	-- 	[["Le Range Rover Sport 2015 est un SUV de luxe qui allie une performance hors-pair à un design élégant et sophistiqué. Avec une carrosserie profilée, des phares LED perçants et une calandre chromée imposante, le Range Rover Sport 2015 est un véhicule qui attire l'attention partout où il va. Sous le capot, vous trouverez un moteur puissant et efficace qui offre une conduite souple et réactive. L'intérieur du véhicule est spacieux et confortable, offrant des sièges en cuir de qualité supérieure et des fonctionnalités haut de gamme telles qu'un système audio haut de gamme, un écran tactile central, un toit ouvrant panoramique et bien plus encore. Que vous soyez en ville ou en pleine nature, le Range Rover Sport 2015 est le choix idéal pour les conducteurs qui recherchent la combinaison parfaite entre luxe, performance et polyvalence."

	-- 	((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},
		
	{name="Honda CRM 250 (Sanchez)", image="sanchez", vehLibID=188, itemType=1, cash=25000, coins=1100, percentOff=5, offerTimestamp=1674743200, description = 
		[["Découvrez la puissance et la maniabilité de la Honda CRM 250 ! Ce véhicule tout-terrain est idéal pour les aventuriers en quête de sensations fortes. Avec sa suspension réglable, sa transmission 6 vitesses et son moteur 4 temps, la CRM 250 est parfaitement adaptée aux terrains accidentés et aux chemins de montagne. Grâce à sa conception légère et compacte, cette moto est facile à manœuvrer, que ce soit sur la route ou hors-piste. Alors, qu'attendez-vous pour prendre le guidon de cette bête de course ?"
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},

	--{name="E-Scooter (débridé) - STOCK limité", image="escooter", vehLibID=391, itemType=1, cash=2000, coins=500, description =  
		--[["Montez sur cet E-Scooter débridé pour une expérience de conduite inoubliable ! Avec sa vitesse supérieure, ce scooter électrique est parfait pour les trajets rapides en ville. Vous ne serez plus jamais en retard pour vos rendez-vous ! L'E-Scooter est également très pratique pour se faufiler dans les rues animées et les embouteillages. Ce scooter est à vous, il est complètement débridé et vous pouvez l'utiliser à votre guise pour tous vos déplacements urbains. Avec son design élégant et son fonctionnement écologique, cet E-Scooter est un choix judicieux pour les citoyens soucieux de l'environnement. Alors, n'hésitez plus, achetez votre propre E-Scooter débridé dès maintenant et commencez à rouler en toute liberté !"

		--((Ce véhicule vous coûtera 500 SouthCoins ET 2.000$))]]--[[ }, *]]


	{name="Mercedes W140 S600 (1995)", image="s600", vehLibID=396, itemType=1, cash=80000, coins=2200, percentOff=10, offerTimestamp=1674743200, description =  
		[["Montez à bord du Mercedes W140 S600 et découvrez le mariage parfait entre confort et puissance. Doté d'un moteur V12 développant plus de 400 chevaux, cette berline de luxe est capable d'atteindre les 100 km/h en moins de 6 secondes. L'intérieur spacieux et élégant est équipé de toutes les fonctionnalités modernes que vous attendez d'une voiture de cette catégorie, notamment des sièges en cuir, une climatisation automatique, un système audio haut de gamme et bien plus encore. Profitez d'une conduite souple et silencieuse grâce à la suspension pneumatique, qui s'ajuste automatiquement à la qualité de la route pour un confort optimal. Avec son allure imposante et sa finition soignée, le Mercedes W140 S600 est le choix idéal pour les amateurs de voitures de luxe classiques."
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},

	-- {name="Dodge Challenger Hellcat (2018)", image="dodge_ch", vehLibID=411, itemType=1, cash=80000, coins=2350, percentOff=10, offerTimestamp=1674743200, description =  
	-- 	[["Découvrez la puissance brute de la Dodge Challenger Hellcat (2018) avec son moteur V8 surpuissant, qui saura vous offrir une expérience de conduite inoubliable. Avec son design élégant et agressif à la fois, la Challenger Hellcat ne manquera pas d'attirer tous les regards sur la route. De plus, avec son intérieur spacieux et confortable, vous pourrez profiter de longues heures de conduite sans aucune fatigue. Ne manquez pas l'opportunité de posséder l'un des véhicules les plus iconiques de notre temps.
		
	-- 	((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},

	{name="Mazda RX8 (2005)", image="rx8", vehLibID=451, itemType=1, cash=65000, coins=1800, percentOff=10, offerTimestamp=1694987940, description =  
		[["Découvrez la Mazda RX8 de 2005, une icône du design sportif japonais. Son allure unique avec des portes antagonistes et son moteur rotatif Wankel font d'elle une pièce d'exception dans le monde automobile. Alliant agilité et puissance, la RX8 offre une expérience de conduite inégalée. Pour les passionnés d'innovation et de dynamisme, la Mazda RX8 2005 est le joyau à ne pas manquer.
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},

	{name="Ford Taurus (2016)", image="taurus", vehLibID=449, itemType=1, cash=55000, coins=1500, percentOff=5, offerTimestamp=1694987940, description =  
		[["Découvrez la Ford Taurus 2016, une berline sophistiquée alliant puissance et élégance. Avec son design robuste et ses lignes modernes, elle se démarque sur le bitume. Dotée d'un moteur performant et d'un intérieur spacieux, la Taurus offre à la fois confort et efficacité. Pour ceux qui recherchent fiabilité et raffinement au quotidien, la Ford Taurus 2018 est la réponse parfaite."

		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},
	
	{name="Mercedes SL500 R129 (1994)", image="R129", vehLibID=434, itemType=1, cash=45000, coins=1500, percentOff=5, offerTimestamp=1674743200, description =  
		[["Découvrez la Mercedes-Benz SL500 R129, un coupé sportif de prestige de 1994. Sa ligne élancée et son design élégant feront tourner les têtes sur la route. Ce véhicule de collection est équipé d'un moteur V8 puissant et offre une expérience de conduite unique en son genre. Avec son confort intérieur et sa maniabilité exceptionnelle, la Mercedes-Benz SL500 R129 est le choix idéal."

		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},

	{name="Chevrolet Montecarlo (1988)", image="montecarlo", vehLibID=398, itemType=1, cash=25000, coins=1200, percentOff=10, offerTimestamp=1674743200, description =  
		[["Entrez dans l'univers des années 80 avec la Chevrolet Montecarlo, symbole de puissance et d'élégance de l'époque. Ce coupé sportif au design racé et aux lignes fluides saura vous séduire par son allure intemporelle. Avec son moteur V8 et ses performances hors pair, la Montecarlo vous procurera une expérience de conduite unique en son genre. À bord de ce joyau automobile, chaque trajet deviendra une aventure que vous n'êtes pas prêt d'oublier. Faites tourner les têtes sur la route et laissez-vous emporter par le charme de la Chevrolet Montecarlo."
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},
	


	--{name="Cadillac Escalade (2016)", image="escalade", vehLibID=394, itemType=1, cash=80000, coins=2450, percentOff=5, offerTimestamp=1684702800, description = [[ 


--		"Le Cadillac Escalade 2016 est l'incarnation du luxe et de la performance. 
		
	--	Avec son design raffiné, ses lignes élégantes et sa silhouette puissante, ce SUV de grande taille ne passe pas inaperçu. 
		
		--L'intérieur est tout aussi impressionnant, avec des sièges en cuir confortables et un tableau de bord sophistiqué qui regorge de fonctionnalités. 
		
	--	Sous le capot, le Cadillac Escalade est équipé d'un moteur V8 de 6,2 litres qui offre une puissance de 420 chevaux. 
		
		--Ce véhicule est parfait pour les personnes qui recherchent un SUV luxueux et performant."







		--((Ce véhicule vous coûtera 2450 SouthCoins ET 80.000$, hors promotions))
	--]]},

	
	{name="Ford Thunderbird (1955)", image="thunder", vehLibID=413, itemType=1, cash=28000, coins=1200, percentOff=10, offerTimestamp=1674743200, description =  
		[["Plongez dans l'histoire automobile américaine avec la Ford Thunderbird de 1955. Ce bijou de la route vous transporte dans l'âge d'or des voitures de collection avec son design iconique des années 50. Avec son moteur V8, la Thunderbird offre des performances à couper le souffle et une expérience de conduite incomparable. Vous ne pouvez pas manquer cette occasion de posséder un morceau d'histoire automobile américaine. Prenez le volant de la Ford Thunderbird de 1955 et vivez une expérience de conduite exceptionnelle."

		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},
	
	{name="Mirado Classic (1975)", image="mirado", vehLibID=415, itemType=1, cash=28500, coins=1400, percentOff=10, offerTimestamp=1674743200, description =  
		[["Embarquez à bord de la 1975 Mirado Classic, un bijou de l'industrie automobile inspiré de la mythique Oldsmobile Cutlass. Ce coupé sportif de légende est l'incarnation du luxe et de la puissance, avec son design intemporel et ses lignes fluides. Doté d'un moteur V8, la Mirado Classic vous garantit des performances remarquables et une expérience de conduite unique en son genre. Que ce soit pour un road trip ou une balade en ville, cette voiture d'exception saura vous séduire par son confort et son élégance. N'attendez plus pour ajouter cette merveille à votre collection de voitures de légende. Le véhicule est décapotable, vous pourrez donc à tout moment ouvrir/fermer le toît et profiter du soleil Californien. 
		
		((Vous pouvez réellement capoter/décapoter le toît. C'est l'un des rares véhicules du serveur à avoir cette fonctionnalité))"
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},
	
	{name="Ford Escort RS Turbo (1985)", image="rxt", vehLibID=416, itemType=1, cash=32500, coins=1400, percentOff=10, offerTimestamp=1674743200, description =  
		[["Plongez dans les années 80 avec la Ford Escort RS Turbo, une voiture de sport emblématique qui combine performances et élégance. Avec son moteur turbocharged et son design aérodynamique, cette voiture est prête à vous offrir une expérience de conduite inoubliable. Conduisez la sur les routes de la ville ou faites la rugir sur les circuits de course, la Ford Escort RS Turbo ne vous laissera jamais tomber."
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},
	
	{name="SAAB 900 Turbo (1990)", image="saab", vehLibID=417, itemType=1, cash=36500, coins=1400, percentOff=10, offerTimestamp=1674743200, description =  
		[["Découvrez la puissance et l'élégance de la SAAB 900 Turbo de 1990, une voiture de collection qui allie design scandinave et performances exceptionnelles. Avec son moteur turbo, cette voiture légendaire est capable de vous offrir une expérience de conduite unique en son genre. Profitez du confort de l'habitacle spacieux et laissez-vous emporter par le charme intemporel de la SAAB 900 Turbo. Le véhicule est décapotable, vous pourrez donc à tout moment ouvrir/fermer le toît et profiter du soleil Californien. 
		
		((Vous pouvez réellement capoter/décapoter le toît. C'est l'un des rares véhicules du serveur à avoir cette fonctionnalité))"
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},

	

	--{name="Winnebago RV (1992)", image="zjourney", vehLibID=402, itemType=1, cash=20000, coins=1200, percentOff=10, offerTimestamp=1682114400, description = [[ 


		--"Découvrez la vie de luxe sur la route avec le Winnebago RV 1992. 

		--Avec son design classique et sa finition en aluminium brossé, cet RV est parfait pour les aventures en famille ou les road trips entre amis. 
		
		--Équipé d'un grand lit, d'une kitchenette entièrement fonctionnelle, d'une salle de bain privée et d'un coin salon spacieux, le Winnebago RV est le choix idéal pour les voyageurs à la recherche de confort et de commodité. 
		
		--Avec son moteur puissant et sa suspension améliorée, ce RV vous offrira une expérience de conduite douce et agréable sur la route. 
		
		--Ne manquez pas l'opportunité de vivre l'aventure ultime avec le Winnebago RV 1992!"
		
		
		
		--((Ce véhicule vous coûtera 1100 SouthCoins ET 20.000$, hors promotions))
	--]]},

	--{name="Mercedes 300 SEL (1972)", image="300sel", vehLibID=400, itemType=1, cash=20000, coins=1600, description = [[ 
	--	
--
	--"Découvrez la sophistication allemande dans toute sa splendeur avec cette Mercedes-Benz 300 SEL de 1972. 
	--
	--Ce véhicule de luxe classique offre une conduite exceptionnelle grâce à sa puissante motorisation et sa transmission automatique fluide. 
	--
	--L'intérieur élégant est équipé d'une sellerie en cuir luxueuse et de boiseries haut de gamme qui donnent une ambiance chaleureuse et accueillante. 
	--
	--Laissez-vous séduire par son allure distinguée et sa prestance intemporelle. 
	--
	--Conduisez cette Mercedes 300 SEL pour une expérience de conduite unique et raffinée."
	--]]},

	--{name="Chrysler C300 (2018)", image="chrysler", vehLibID=399, itemType=1, cash=100000, coins=2250, percentOff=5, offerTimestamp=1682460000, description = [[ 


	--	"La puissante Chrysler C300 (2018) est la définition de l'élégance et de la performance. 
		
	--	Avec son design raffiné, ses lignes épurées et son intérieur luxueux, cette voiture est destinée à impressionner. 
		
	--	Dotée d'un moteur V8 de 6,4 litres, la C300 offre une conduite incroyablement douce et rapide. 
		
	--	Avec des fonctionnalités telles que la caméra de recul, l'infodivertissement de pointe et un système audio haut de gamme, cette voiture offre une expérience de conduite sans pareille. 
		
	--	Prenez le volant de cette beauté américaine et profitez du confort et de la performance ultimes."
		
		
		
	--	((Ce véhicule vous coûtera 2250 SouthCoins ET 100.000$, hors promotions))
	--]]},

	

	--{name="Maserati Ghibli (2016)", image="maserati", vehLibID=395, itemType=1, cash=150000, coins=2200, description = [[ 
--
--
	--	"Découvrez la puissance et l'élégance de la Maserati Ghibli (2016). 
--
	--	Avec son design unique et sa carrosserie élancée, cette voiture de sport de luxe est un choix parfait pour les passionnés de la conduite. 
--
	--	Sous le capot, un moteur V6 biturbo de 3,0 litres offre une puissance incroyable et une accélération rapide. 
--
	--	L'intérieur de la Ghibli est tout aussi impressionnant, avec des sièges en cuir fin, une console centrale élégante et une technologie avancée qui vous permet de contrôler la voiture avec aisance. 
	--	
	--	Profitez de chaque trajet avec la Maserati Ghibli (2016), la quintessence du luxe et de la performance automobile."
	--]]},

	--{name="Vapid Huntley (2018)", image="corvette", vehLibID=406, itemType=1, cash=150000, coins=1300, description = [[ 
		
	
	--"Prenez place dans ce bolide racé et offrez-vous une expérience de conduite inoubliable. 
	
	--Avec sa carrosserie élégante et sportive, ce coupé 2 portes est un véritable bijou de technologie, conçu pour offrir des performances de pointe à chaque instant. 
	--
	--Sous le capot, un moteur six cylindres de 2,7 litres, associé à une boîte de vitesses manuelle à six rapports, vous propulsera de 0 à 100 km/h en seulement 5,4 secondes. 
	--
	--Avec ses suspensions et ses freins de haute performance, cette voiture offre une tenue de route impeccable, une stabilité sans faille et une conduite précise à chaque virage. 
	--
	--Montez à bord et découvrez une expérience de conduite à couper le souffle avec le Porsche Cayman (2013)."
	--]]},

	{name="Kaiser Jeep M715 (2002)", image="bodhi", vehLibID=424, itemType=1, cash=30000, coins=1000, percentOff=10, offerTimestamp=1674743200, description =  
		[["Découvrez l'emblématique Kaiser Jeep M715, le véhicule tout-terrain parfait pour les aventuriers en quête de sensations fortes. Avec sa carrosserie robuste et ses performances hors pair, vous pourrez traverser les terrains les plus escarpés sans difficulté. Ne manquez pas cette occasion de posséder un véritable morceau d'histoire automobile et de vivre des moments inoubliables au volant de ce monstre tout-terrain.
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},

	{name="Cadillac Fleetwood Eldorado (1976)", image="eldorado", vehLibID=425, itemType=1, cash=60000, coins=1800, percentOff=10, offerTimestamp=1674743200, description =  
		[["Découvrez le luxe à l'état pur avec la Cadillac Fleetwood Eldorado de 1976. Cette voiture emblématique de l'ère des grosses cylindrées saura vous séduire avec son style élégant et raffiné. Avec son moteur V8 puissant, vous pourrez profiter de performances exceptionnelles pour vous déplacer avec classe et confort. À bord de cette voiture légendaire, chaque trajet sera une expérience unique, marquée par le prestige et le charme intemporel de la marque Cadillac.
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},

	{name="Pontiac Bonneville (1975)", image="pontiac", vehLibID=426, itemType=1, cash=30000, coins=1200, percentOff=10, offerTimestamp=1674743200, description =  
		[["Découvrez l'emblématique Pontiac Bonneville de 1975, un joyau de l'âge d'or américain de l'automobile. Ce coupé de luxe offre un confort inégalé grâce à ses sièges en cuir doux et son intérieur spacieux. Avec son moteur V8 puissant et sa transmission automatique douce, la Bonneville vous procurera une expérience de conduite incroyablement agréable. Profitez de chaque trajet au volant de cette voiture classique, qui allie à la fois élégance, confort et performances. 
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},

	{name="Toyota Sprinter Trueno (1980)", image="futo", vehLibID=427, itemType=1, cash=35000, coins=1400, percentOff=10, offerTimestamp=1674743200, description =  
		[["Découvrez la légendaire Toyota Sprinter Trueno, icône de la culture automobile japonaise des années 80. Avec son design emblématique et son moteur 4 cylindres de 1,6 L, cette voiture sportive offre une expérience de conduite passionnante, agile et rapide. Que ce soit pour des virées en ville ou des courses sur circuit, la Toyota Sprinter Trueno est la voiture parfaite pour les amateurs de sensations fortes.
		
		((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"]]},

	--{name="Mercedes-Benz G65 AMG (2019)", image="g65", vehLibID=410, itemType=1, cash=120000, coins=3500, percentOff=5, offerTimestamp=1682993100, description = [[ 
	
	
		--"Découvrez le summum du luxe et de la puissance avec la Mercedes-Benz G65 AMG de 2019. 
	
		--Cette voiture tout-terrain impressionnante est équipée d'un moteur V12 biturbo de 6,0 L qui produit une puissance de 621 chevaux.

		--Avec sa carrosserie anguleuse et sa suspension robuste, la G65 AMG est prête à affronter tous les terrains, tout en offrant un confort et une sophistication incomparables.
	
		--À bord, vous serez enveloppé dans un intérieur somptueux en cuir, avec des sièges électriques chauffants et ventilés, un système audio premium et un écran tactile central intuitif.
	
		--Avec la Mercedes-Benz G65 AMG, chaque trajet sera une expérience de conduite exceptionnelle, alliant puissance, confort et luxe."
		
		
		
		--((Ce véhicule vous coûtera 3500 SouthCoins ET 120.000$, hors promotion))"
	--]]},

	-- {name="Ford Raptor (2016)", image="fraptor", vehLibID=412, itemType=1, cash=50000, coins=1800, percentOff=10, offerTimestamp=1674743200, description =  
	-- 	[["Découvrez le Ford Raptor 2016, un pick-up tout-terrain puissant et robuste. Avec sa carrosserie imposante et sa suspension de qualité supérieure, vous pourrez affronter les terrains les plus difficiles sans effort. Sous le capot, vous trouverez un moteur V6 EcoBoost de 3,5 L qui produit une puissance de 450 chevaux, ce qui vous permettra de vous déplacer rapidement et efficacement, que ce soit sur ou hors route. Ne manquez pas l'occasion de posséder le Ford Raptor 2016, un pick-up tout-terrain impressionnant qui allie puissance, robustesse et confort."

	-- 	((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))]]},


	--{name="BMW E34 (1988)", image="E34", vehLibID=431, itemType=1, cash=35000, coins=2200, percentOff=5, offerTimestamp=1683338400, description = [[ 
	
	
		--"Découvrez l'élégance allemande avec la BMW E34 de 1988. 
		
	--	Cette voiture de sport iconique offre une conduite fluide et une allure classique, qui ne manquera pas de faire tourner les têtes sur la route. 
		
		--Avec ses performances exceptionnelles et son design soigné, cette BMW E34 est une véritable merveille de l'ingénierie automobile allemande. 
		
		--Prenez le volant de cette beauté et offrez-vous une expérience de conduite inoubliable.

		--((Ce véhicule vous coûtera 2200 SouthCoins ET 35.000$, hors promotion))"
	--]]},


 --  {name="AUDI Q8 (2019) - EDITION LIMITEE", image="Q8", vehLibID=433, itemType=1, cash=115000, coins=3500, percentOff=10, offerTimestamp=1683511200, description = [[ 
	
	--	/!\ CE VEHICULE RESTERA 24H ET NE RESSORTIRA PLUS JAMAIS ! /!\


		--"La Audi Q8 2019 est un SUV de luxe qui allie élégance, sportivité et performances exceptionnelles. 

		--Avec son design avant-gardiste et ses équipements haut de gamme, elle est le choix parfait pour les conducteurs souhaitant allier confort et style. 

		--Son moteur V6 surpuissant et sa transmission intégrale Quattro offrent une expérience de conduite incroyablement dynamique. 

		--À bord de cette Audi Q8, vous pourrez profiter de technologies avancées telles que le Virtual Cockpit, qui offre une interface entièrement numérique et personnalisable pour une expérience de conduite encore plus immersive.

		--((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))"
	--]]},

	--{name="AUDI A6 (2018) - EDITION LIMITEE", image="a6", vehLibID=435, itemType=1, cash=78000, coins=2500, percentOff=10, offerTimestamp=1684098000, description = [[ 
	
	--	/!\ CE VEHICULE NE RESSORTIRA PLUS JAMAIS ! 20 STOCKS SEULEMENT /!\


	--	"Découvrez l'Audi A6 2018, un bijou d'ingénierie alliant luxe, performance et technologie de pointe.

	--	Le design raffiné et élégant de l'Audi A6 attire tous les regards avec ses lignes dynamiques et sa calandre distinctive. 

	--	À l'intérieur, vous serez enveloppé dans un habitacle luxueux, offrant un confort inégalé et des finitions haut de gamme.

	--	Sous le capot, l'Audi A6 est équipée d'un moteur puissant qui délivre des performances exceptionnelles, associées à une tenue de route précise et agile. 

	--	Que ce soit pour les déplacements quotidiens ou les longs voyages, l'Audi A6 2018 vous offre le mariage parfait entre le luxe, le confort et la performance."


	--	((Ce véhicule vous coûtera le prix en SouthCoins ET le prix en $))
	--]]},

	
	--ITEMS START
	--{name="RC Drone", image="drone", itemType=2, cash=2000, coins=100, itemID=291, itemValue=100, percentOff=25, offerTimestamp=1676760445, description = [[ 
	--	Un petit drone équipé d'une caméra. Parfait pour shooter des clips, ou se balader en filmant les alentours.
	--]]},

	--ITEMS START

	-- {name="Véhicule TOUJOURS propre", image="polish", itemType=2, cash=1000, coins=500, itemID=304, itemValue=1, description =  
	-- 	[[Votre véhicule ne se salira plus jamais. Il restera propre à vie.
	-- 	Vous recevrez un item à mettre dans l'inventaire de votre véhicule.]]},

	-- {name="Télécommande Hydraulique", image="lowrider", itemType=2, cash=500, coins=100, itemID=290, itemValue=1, description =  
	-- 	[[Une télécommande vous permettant de contrôler à distance l'hydraulique sur votre véhicule (Il faut équiper votre véhicule de tuning ''Hydraulique'' chez les mécanos). 
	-- 	Fonctionne que pour les Lowriders : Blade, Broadway, Remington, Savanna, Slamvan, Tornado, Voodoo.
	-- 	Très utile pour les shows de lowrider.]]},

	--ITEMS END
	
	--PERKS START

	{name="x1 Skin Unique", image="clothe", itemType=3, coins=700, perkID=false, perkCoin="Skin Coin", perkValue=false, days=-1, description =  
		[[Démarquez-vous en arborant un skin unique qui vous représente. Créez votre propre look et personnalisez votre apparence avec un skin unique visible par tous les joueurs. Ne ratez pas cette occasion de vous démarquer et d'impressionner les autres avec un skin sur mesure!]]},

	{name="x1 Spawn House", image="housespawn", itemType=3, coins=850, perkID=false, perkCoin="House Coin", perkValue=false, days=-1, description =  
		[[Cet avantage vous permet de faire apparaître un spawn de maison là où il n'y en a pas. Par exemple, si vous voyez un extérieur de Maison sympa mais qu'il n'y a pas de spawn pour acheter la maison, alors cet avantage (Spawn House) est ce que vous cherchez ! Une fois le spawn posé, vous pourrez choisir l'intérieur qui vous plaît (parmi une liste). La maison sera à vous!

		((NOTE IMPORTANTE : UNE TAXE (en $) DEVRA ETRE PAYEE A l'ACHAT DE LA HOUSE. LA TAXE DEPEND DE LA ZONE CHOISIE. LISTE DES TAXES SUR LE FORUM -> Informations et Annonces -> Guide & tutoriels -> Prix des houses/biz))]]},

	{name="x1 Spawn Garage", image="garage", itemType=3, coins=650, perkID=false, perkCoin="Garage Coin", perkValue=false, days=-1, description =  
		[[Cet avantage vous permet de faire apparaître un spawn garage. Très utile, il vous permettra de garer vos véhicules en tout sécurité, à l'abris. Une fois le spawn posé, vous pourrez choisir l'intérieur qui vous plaît (parmi une liste). Le garage sera à vous!]]},

    {name="x1 Spawn Biz", image="shopbiz", itemType=3, coins=900, perkID=false, perkCoin="Business Coin", perkValue=false, days=-1, description =  
		[[Vous permet de faire spawn un intérieur Biz. Vous aurez le choix de l'intérieur, et du type de Biz (magasin vêtement, 24/7, restaurant...) Vous aurez le contrôle total sur votre entreprise.

		((NOTE IMPORTANTE : UNE TAXE (en $) DEVRA ETRE PAYEE A l'ACHAT DE LA HOUSE. LA TAXE DEPEND DE LA ZONE CHOISIE. LISTE DES TAXES SUR LE FORUM -> Informations et Annonces -> Guide & tutoriels -> Prix des houses/biz))]]},
		
	{name="x1 Pack Entreprise", image="packentreprise", itemType=3, coins=1500, perkID=false, perkCoin="Pack Entreprise Coin", perkValue=false, days=-1, description =  
		[[Vous permet d'avoir un script afin de pouvoir dynamiser votre entreprise en vous donnant accès à :

        - Gestion des membres et de leurs droits
        - Gestion des finances (Coffre job et salaires)
        - Achat de propriétés pour votre entreprise (biz/véhicules...)

		Plus d'informations sur le forum dans la partie Factions et Organisations -> Entreprises 

		((NOTE IMPORTANTE : N'ACHETEZ PAS CE PACK TANT QUE VOTRE DEMANDE ET L'ADMINISTRATEUR EN CHARGE NE VALIDE PAS VOTRE PROJET.))]]},

	{name="Station Radio personnalisée", image="radioperso", itemType=3, coins=0, perkID=28, perkValue=false, days=-1, description =  
		[[Créez votre propre station radio avec les musiques de votre choix. Tous les joueurs pourront l'écouter dans leur véhicule/boombox! Comment créer sa propre radio avec les musiques de votre choix? Un guide est disponible sur le forum!]]},	

	{name="x1 Rename Personnage", image="rename", itemType=3, coins=300, perkID=false, perkCoin="Rename Coin", perkValue=false, days=-1, description =  
		[[Vous permet de rename un personnage.]]},

	-- DONT FORGET TO CHANGE ALSO IN donators/g_donation_perks.lua for perk id 18
	{name="Numéro Téléphone personnalisé (6 chiffres)", image="phonenumb", itemType=3, coins=200, perkID=18, perkValue=false, days=-1, description =  
	[[Démarquez-vous en obtenant un numéro de téléphone personnalisé.]]},

--    -- DONT FORGET TO CHANGE ALSO IN donators/g_donation_perks.lua for perk id 19
--     {name="Numéro Téléphone personnalisé (5 chiffres)", image="phonenumb", itemType=3, coins=500, perkID=19, perkValue=false, days=-1, description =  
-- 	[[Démarquez-vous en obtenant un numéro de téléphone personnalisé.]]},	

	{name="x1 Spawn Gate/Porte", image="gate", itemType=3, coins=500, perkID=false, perkCoin="Gate Coin", perkValue=false, days=-1, description =  
		[[Vous permet de faire spawn un portail/porte privé. 2 clés vous seront données.]]},

	{name="Mapping Personnalisé", image="mappingperso", itemType=3, coins=1500, perkID=false, perkCoin="Mapping Perso", perkValue=false, days=-1, description =  
		[[Vous permet d'importer un mapping intérieur unique! Au choix :

		- mapping SAMP
		- mapping MTA
		- modèle 3D

		Le nombre de lignes autorisé est de 0 à 1500 ! Ne sont pas supportés par notre convertisseur : 

		- Textures/objets invisibles
		- Changement de transparence sur les objets/textures
		- Les textes.

		Ouvrez un ticket Discord une fois que vous avez le Token dans votre inventaire.]]},

	{name="Mapping Perso. Extérieur (10 Lignes)", image="mappingperso", itemType=3, coins=2000, perkID=false, perkCoin="Mapping Perso (Extérieur 10L)", perkValue=false, days=-1, description =  
		[[Vous permet d'importer un mapping exétrieur unique! Au choix :

		- mapping SAMP
		- mapping MTA
		- modèle 3D

		Le nombre de lignes autorisé est de 0 à 10 ! Ne sont pas supportés par notre convertisseur : 

		- Textures/objets invisibles
		- Changement de transparence sur les objets/textures
		- Les textes.

		Ouvrez un ticket Discord une fois que vous avez le Token dans votre inventaire.]]},

	{name="Mapping Perso. Extérieur (30 Lignes)", image="mappingperso", itemType=3, coins=2500, perkID=false, perkCoin="Mapping Perso (Extérieur 30L)", perkValue=false, days=-1, description =  
		[[Vous permet d'importer un mapping exétrieur unique! Au choix :

		- mapping SAMP
		- mapping MTA
		- modèle 3D

		Le nombre de lignes autorisé est de 0 à 30 ! Ne sont pas supportés par notre convertisseur : 

		- Textures/objets invisibles
		- Changement de transparence sur les objets/textures
		- Les textes.

		Ouvrez un ticket Discord une fois que vous avez le Token dans votre inventaire.]]},

	{name="Déplacement Spawn", image="deplacementspawn", itemType=3, coins=500, perkID=false, perkCoin="Déplacement Spawn", perkValue=false, days=-1, description =  
		[[Vous possédez déjà un spawn mais vous souhaitez le déplacer?]]},

	{name="x1 Spawn Planque", image="planque", itemType=3, coins=650, perkID=false, perkCoin="Planque Coin", perkValue=false, days=-1, description =  
		[[Spawn planque, pour les hors-la-loi.
		
		((NOTE IMPORTANTE : UNE TAXE (en $) DEVRA ETRE PAYEE A l'ACHAT DE LA PLANQUE. LA TAXE DEPEND DE LA ZONE CHOISIE. LISTE DES TAXES SUR LE FORUM -> Informations et Annonces -> Guide & tutoriels -> Prix des houses/biz))]]},
	--{name="Pseudo + Badge OR", image="gold", itemType=3, coins=500, perkID=11, perkValue=false, days=14, description = [[ 
	--	Votre Prenom_Nom au dessus de votre tête (et dans le TAB) sera en Or durant 14 jours.
	--	Vous aurez également un petit badge "Donateur" sous votre pseudo.
	--	Vous pouvez désactiver/activer cette compétence à tout moment. 
	--]]},

	--{name="VIP Chat Channel", image="comingsoon", itemType=3, coins=50, perkID=10, perkValue=false, days=14, description = [[ 
	--	Description goes here.
	--]]},

	--{name="Invisible (TAB)", image="ghost", itemType=3, coins=200, perkID=12, perkValue=false, days=14, description = [[ 
	--	Déjouez les regards indiscrets en devenant invisible dans la liste des joueurs en ligne pendant 14 jours. 
	--	Vous pouvez activer et désactiver cette compétence à tout moment durant cette période. 
	--]]},

	--{name="Automatic Toll Opening", image="comingsoon", itemType=3, coins=100, perkID=27, perkValue=false, days=14, description = [[ 
	--	Description goes here.
	--]]},

	-- {name="Sélection de Perso. Premium (Grove St)", image="grove", itemType=3, coins=200, perkID=24, perkValue=1, days=-1, description =  
	-- 	[[Débloquez un nouvel écran exclusif lors de la sélection de personnage.]]},

	-- {name="Sélection de Perso. Premium (Star Tower)", image="tower", itemType=3, coins=200, perkID=25, perkValue=1, days=-1, description =  
	-- 	[[Débloquez un nouvel écran exclusif lors de la sélection de personnage.]]},

	-- {name="Sélection de Perso. Premium (Mt. Chilliad)", image="chiliad", itemType=3, coins=200, perkID=26, perkValue=1, days=-1, description =  
	-- 	[[Débloquez un nouvel écran exclusif lors de la sélection de personnage.]]},

	--{name="+$25 par PayDay", image="money", itemType=3, coins=100, perkID=4, perkValue=14, days=14, description = [[ 
	--	Recevez un bonus de +25$ chaque PayDay (valable 14 jours).
	--]]},
	--{name="+$75 par Payday", image="money", itemType=3, coins=200, perkID=5, perkValue=14, days=14, description = [[ 
	--	Recevez un bonus de +75$ chaque PayDay (valable 14 jours).
	--]]},
	--{name="Chien", image="dog", itemType=3, coins=1500, perkID=44, perkValue=30, days=30, description = [[ 
	--	Adoptez un adorable chien qui vous accompagnera pendant 30 jours. 
	--	Votre nouveau compagnon pourra vous suivre, se coucher, vous tenir compagnie dehors, dans votre voiture, chez vous ..
	--]]},

	{name="+1 Slot (Intérieur)", image="plus", itemType=3, coins=500, perkID=14, perkValue=false, days=-1, description =  
		[[Obtenez un emplacement supplémentaire de propriété (maison/business...) de façon permanente.]]},

	{name="+1 Slot (Véhicule)", image="plus", itemType=3, coins=300, perkID=15, perkValue=false, days=-1, description =  
		[[Obtenez un emplacement supplémentaire de véhicule de façon permanente.]]},

	{name="+1 Slot (Personnage)", image="plus", itemType=3, coins=300, perkID=42, perkValue=false, days=-1, description = 
		[[Obtenez un emplacement supplémentaire de personnage de façon permanente.]]},

	--{name="Transfert Personnage", image="transfer", itemType=3, coins=700, perkID=false, perkCoin="Transfer Coin", perkValue=false, days=-1, description = [[ 
--		Vous permet de transférer vos assets (argent, véhicules, propriétés) vers un autre de vos personnage.
	--	Cela entrainera automatiquement le CK de votre personnage actuel.
	--]]},

	--{name="Activer/Désactiver PMs", image="onoff", itemType=3, coins=50, perkID=1, perkValue=14, days=14, description = [[ 
	--	Permet d'activer/désactiver les messages privés (valable 14 jours).
	--]]},

	--{name="Activer/Désactiver PUBS", image="onoff", itemType=3, coins=50, perkID=2, perkValue=14, days=14, description = [[ 
	--	Permet d'activer/désactiver les pubs dans le tchat (valable 14 jours).
	--]]},

	--{name="Activer/Désactiver NEWS", image="onoff", itemType=3, coins=50, perkID=3, perkValue=14, days=14, description = [[ 
	--	Permet d'activer/désactiver les messages du San News dans le chat (valable 14 jours).
	--]]},

	-- DONT FORGET TO CHANGE ALSO IN donators/g_donation_perks.lua for perk id 16
	--{name="Rename (COMPTE)", image="rename", itemType=3, coins=250, perkID=16, perkValue=false, days=-1, description = [[ 
		--Permet de rename votre nom de compte. Attention, cela n'est pas un rename du personnage !
	--]]},
	{name="Protection Intérieur Inactivité ", image="sleep", itemType=3, coins=200, perkID=36, perkValue=14, days=30, description =  
		[[Vous permet de protéger vos intérieurs de la suppression dans le cas où vous êtes inactif + de 1 mois. (rajoute 1 mois d'inactivité autorisée supplémentaire)]]},

	{name="Protection Véhicule Inactivité", image="sleep", itemType=3, coins=200, perkID=38, perkValue=14, days=30, description = 
		[[Vous permet de protéger vos véhicules de la suppression dans le cas où vous êtes inactif + de 1 mois. (rajoute 1 mois d'inactivité autorisée supplémentaire)]]},

	{name="Bikelife", image="lowrider", itemType=3, coins=400, perkID=5001, perkValue=false, days=-1, description =  
		[[Vous débloque l'accès à 5 animations d'acrobaties exclusives lorsque vous êtes en Sanchez/Quad (pour l'instant). Pour utiliser, vous devez /bind les commandes suivantes aux touches de votre choix:

		- /kneeknocker
		- /feetonbars
		- /footonbars
		- /nohands
		- /bikekneeknocker

		Ensuite, il faut appuyer sur les boutons que vous avez configuré en étant en wheelie pour activer les animations.]]},

	--PERKS END
	
	
	{name="", image="coins180-280", itemType=4, irlcash=7.99, coins=1000, payLink="https://buy.stripe.com/cN25lDgNZgB67i8fZm", description =  
		[[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fringilla turpis arcu, vitae consectetur sapien varius vel. Proin odio justo, lacinia ac massa et, tincidunt laoreet purus. Pellentesque volutpat commodo dui. Morbi iaculis mollis magna sit amet varius. Donec lectus augue, fermentum vitae finibus ut, sagittis ac elit. In sed risus at purus bibendum ultrices at vel nibh. Mauris non tincidunt erat, ac convallis lectus. Vestibulum vel sem ut urna iaculis volutpat. Vivamus volutpat feugiat ante non consectetur. Sed aliquet, leo vitae mollis feugiat, velit massa consectetur lectus, ut convallis enim mauris fermentum turpis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu felis sit amet lacus rhoncus faucibus quis quis risus. Donec vel lectus tellus. Cras placerat dapibus nunc laoreet porttitor. Suspendisse id imperdiet dolor. Ut maximus velit elit, non cursus ex bibendum ac. Mauris non urna sodales, molestie ligula ac, commodo massa. Vestibulum sed ipsum eleifend, scelerisque tortor eget, porttitor lectus. Nullam augue felis, vehicula non euismod quis, congue id dolor. Quisque finibus elementum arcu, id mollis enim venenatis ac. Morbi odio odio, suscipit vel massa sit amet, egestas venenatis erat. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras aliquam finibus sapien, ut dictum sapien tincidunt quis. Integer ultricies purus nulla, ut aliquet nibh dictum id. Vestibulum non sem sit amet mi interdum sollicitudin ut at nisl. Morbi et risus in erat hendrerit placerat sed vel arcu.]]},

	{name="", image="coins180-290", itemType=4, irlcash=19.99, coins=2800, payLink="https://buy.stripe.com/bIYeWdgNZ5WsdGweVj", description =  
		[[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fringilla turpis arcu, vitae consectetur sapien varius vel. Proin odio justo, lacinia ac massa et, tincidunt laoreet purus. Pellentesque volutpat commodo dui. Morbi iaculis mollis magna sit amet varius. Donec lectus augue, fermentum vitae finibus ut, sagittis ac elit. In sed risus at purus bibendum ultrices at vel nibh. Mauris non tincidunt erat, ac convallis lectus. Vestibulum vel sem ut urna iaculis volutpat. Vivamus volutpat feugiat ante non consectetur. Sed aliquet, leo vitae mollis feugiat, velit massa consectetur lectus, ut convallis enim mauris fermentum turpis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu felis sit amet lacus rhoncus faucibus quis quis risus. Donec vel lectus tellus. Cras placerat dapibus nunc laoreet porttitor. Suspendisse id imperdiet dolor. Ut maximus velit elit, non cursus ex bibendum ac. Mauris non urna sodales, molestie ligula ac, commodo massa. Vestibulum sed ipsum eleifend, scelerisque tortor eget, porttitor lectus. Nullam augue felis, vehicula non euismod quis, congue id dolor. Quisque finibus elementum arcu, id mollis enim venenatis ac. Morbi odio odio, suscipit vel massa sit amet, egestas venenatis erat. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras aliquam finibus sapien, ut dictum sapien tincidunt quis. Integer ultricies purus nulla, ut aliquet nibh dictum id. Vestibulum non sem sit amet mi interdum sollicitudin ut at nisl. Morbi et risus in erat hendrerit placerat sed vel arcu.]]},

	{name="", image="coins180-283", itemType=4, irlcash=31.99, coins=5000, payLink="https://buy.stripe.com/dR6aFX8htckQ6e46oO", description =  
		[[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fringilla turpis arcu, vitae consectetur sapien varius vel. Proin odio justo, lacinia ac massa et, tincidunt laoreet purus. Pellentesque volutpat commodo dui. Morbi iaculis mollis magna sit amet varius. Donec lectus augue, fermentum vitae finibus ut, sagittis ac elit. In sed risus at purus bibendum ultrices at vel nibh. Mauris non tincidunt erat, ac convallis lectus. Vestibulum vel sem ut urna iaculis volutpat. Vivamus volutpat feugiat ante non consectetur. Sed aliquet, leo vitae mollis feugiat, velit massa consectetur lectus, ut convallis enim mauris fermentum turpis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu felis sit amet lacus rhoncus faucibus quis quis risus. Donec vel lectus tellus. Cras placerat dapibus nunc laoreet porttitor. Suspendisse id imperdiet dolor. Ut maximus velit elit, non cursus ex bibendum ac. Mauris non urna sodales, molestie ligula ac, commodo massa. Vestibulum sed ipsum eleifend, scelerisque tortor eget, porttitor lectus. Nullam augue felis, vehicula non euismod quis, congue id dolor. Quisque finibus elementum arcu, id mollis enim venenatis ac. Morbi odio odio, suscipit vel massa sit amet, egestas venenatis erat. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras aliquam finibus sapien, ut dictum sapien tincidunt quis. Integer ultricies purus nulla, ut aliquet nibh dictum id. Vestibulum non sem sit amet mi interdum sollicitudin ut at nisl. Morbi et risus in erat hendrerit placerat sed vel arcu.]]},

	{name="", image="coins180-284", itemType=4, irlcash=79.99, coins=13500, payLink="https://buy.stripe.com/6oEbK18htbgM8mc5kL", description =  
		[[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus fringilla turpis arcu, vitae consectetur sapien varius vel. Proin odio justo, lacinia ac massa et, tincidunt laoreet purus. Pellentesque volutpat commodo dui. Morbi iaculis mollis magna sit amet varius. Donec lectus augue, fermentum vitae finibus ut, sagittis ac elit. In sed risus at purus bibendum ultrices at vel nibh. Mauris non tincidunt erat, ac convallis lectus. Vestibulum vel sem ut urna iaculis volutpat. Vivamus volutpat feugiat ante non consectetur. Sed aliquet, leo vitae mollis feugiat, velit massa consectetur lectus, ut convallis enim mauris fermentum turpis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque eu felis sit amet lacus rhoncus faucibus quis quis risus. Donec vel lectus tellus. Cras placerat dapibus nunc laoreet porttitor. Suspendisse id imperdiet dolor. Ut maximus velit elit, non cursus ex bibendum ac. Mauris non urna sodales, molestie ligula ac, commodo massa. Vestibulum sed ipsum eleifend, scelerisque tortor eget, porttitor lectus. Nullam augue felis, vehicula non euismod quis, congue id dolor. Quisque finibus elementum arcu, id mollis enim venenatis ac. Morbi odio odio, suscipit vel massa sit amet, egestas venenatis erat. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras aliquam finibus sapien, ut dictum sapien tincidunt quis. Integer ultricies purus nulla, ut aliquet nibh dictum id. Vestibulum non sem sit amet mi interdum sollicitudin ut at nisl. Morbi et risus in erat hendrerit placerat sed vel arcu.]]},
}