entryMessageEnabled = true
entryMessage = "Bienvenue au skatepark. Si vous n'êtes pas familier avec les règles, veuillez vous rendre au marqueur jaune 'i' à l'entrée."

infoPickupsEnabled = true
infoPickupLocations = {
	{1863.9013671875, -1391.4072265625, 13.484829902649},
	{1897.8330078125, -1353.4970703125, 13.482772827148},
	{1955.759765625, -1448.4755859375, 13.478991508484},
}

infoPickupText = [[Veillez à respecter l'esprit du jeu de rôle. 
Même si vous avez la possibilité (grâce au script) de faire des cascades à tout moment, 
vous n'êtes pas obligé de le faire. Assurez-vous que cela reste cohérent avec votre personnage.


Scripts: 
Lorsque vous êtes dans le skatepark, vous pouvez faire des "fakies" (reculer), pédaler plus vite et sauter plus haut. 
En utilisant les touches 'A' et 'E', vous pouvez mieux pivoter pour réaliser des astuces rotatives comme les 180, 360, flairs, etc.
Vous pouvez également utiliser les flèches "Haut" et "Bas" pour pivoter vers l'avant et l'arrière, ce qui vous permet de réaliser des figures avant et arrière. 
La gravité est légèrement réduite pour permettre des transitions plus fluides et une meilleure physique.

Astuce: Vous pouvez changer vos touches Haut/Bas avec le clique gauche/droit de votre souris par exemple!
Pour cela, rendez vous directement dans ECHAP - Paramètres - Touches]]

bmxCol = createColPolygon( 
	1862.216796875, -1450.5458984375,
	1862.216796875, -1450.5458984375,
	1862.185546875, -1351.2451171875,
	1976.10546875, -1351.2451171875,
	1976.10546875, -1450.31640625
)

bikeIDs = {
	[481] = true,
	[510] = true,
	[6651] = true,
}

-- Vehicles in this faction won't be allowed to leave the colshape (auto respawned if attempted)
bikesFactionID = 11