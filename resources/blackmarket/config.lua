--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		BlackMarket
    Date:		23/05/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.BMScript = SL.BMScript or {};
SL.BMScript.Config = SL.BMScript.Config or {};


--[[----------------------------------------
    --> Config
--]]----------------------------------------
SL.BMScript.Config = {
    ['base'] = {
        PREFIX = '[BlackMarket] ',
    },

    --[[
        INFORMATION: Si vous souhaitez restreindre l'accès à certains items, mettez la valeur "Stock Max" (la 4ème) à 0.
                    /!\ --> Sauf pour les munitions, cela se gère automatiquement en BDD <-- /!\

        /!\ SI VOUS SOUHAITEZ MODIFIER (AJOUTER UN ITEM NOTAMMENT) PRÉVENEZ MOI AVANT TOUTES MODIFICATIONS /!\
        ---> TOUTE MODIFICATION MAL EFFECTUÉE POURRAIT ENTRAÎNER DES BUGS <---
        ---> TOUTE MODIFICATION MAL EFFECTUÉE POURRAIT ENTRAÎNER DES BUGS <---
        ---> TOUTE MODIFICATION MAL EFFECTUÉE POURRAIT ENTRAÎNER DES BUGS <---

        Exemple : 
            {'Matériaux RPG', 50000, 373, 0, 5, 8, 35}, --> La 4ème valeur est à 0, donc l'item ne sera pas disponible à l'achat.

        Voici la liste des FactionType :
            0 = GANG ;
            1 = MAFIA ;
            10 = STREET MAFIA

        Dans la partie "weapons", si la liste des FactionType est vide = personne n'a accès à l'item. (Il n'apparaîtra donc pas dans le menu, c'est également un moyen de le restrict)
    
        --> Si vous souhaitez ajouter une arme, vérifiez bien le dernier id entre crochet (ex: [23]) utilisé (catégories materials et others confondues) et ajoutez +1 <--
        --> Si vous souhaitez ajouter une arme, vérifiez bien le dernier id entre crochet (ex: [23]) utilisé (catégories materials et others confondues) et ajoutez +1 <--
        --> Si vous souhaitez ajouter une arme, vérifiez bien le dernier id entre crochet (ex: [23]) utilisé (catégories materials et others confondues) et ajoutez +1 <--
    ]]--

    ['weapons'] = {
        ['materials'] = { -- Name ; Price ; ItemID ; Stock Max ; Taken slot ; Amount of materials required ; ItemValue ; FactionType Access
            [1] = {'Matériaux AK-47', 1900, 359, 10, 3, 5, 30, {1}},
            [2] = {'Matériaux UZI', 2000, 360, 9, 2, 3, 28, {10}},
            [3] = {'Matériaux Desert Eagle', 2500, 361, 6, 2, 2, 24, {10}},
            [4] = {'Matériaux Colt', 1000, 362, 10, 1, 2, 22, {10}},
            [5] = {'Matériaux Silencieux', 1000, 363, 15, 1, 3, 23, {1}},
            [6] = {'Molotov', 5000, 115, 2, 1, 0, 18, {0}},
            [7] = {'Matériaux Tec-9', 1850, 365, 12, 2, 3, 32, {10}},
            [8] = {'Matériaux MP5', 3500, 374, 0, 3, 4, 29, {}}, -- non dispo atm
            [9] = {'Matériaux M4', 2400, 367, 10, 4, 5, 31, {1}},
            [10] = {'Matériaux Shotgun', 1875, 368, 8, 3, 4, 25, {1}},
            [11] = {'Matériaux Sawn Off', 2150, 369, 12, 2, 3, 26, {10}},
            [12] = {'Matériaux Rifle', 2400, 370, 5, 3, 5, 33, {10}},
            [13] = {'Matériaux Sniper', 2400, 371, 5, 4, 5, 34, {1}},
            -- [14] = {'Grenade', 7500, 115, 0, 1, 0, 16, {1}},
            [15] = {'Matériaux RPG', 50000, 373, 0, 5, 8, 35, {}}, -- non dispo atm
            [28] = {'Couteau', 800, 115, 5, 0, 0, 4, {0, 1, 10}},
        },
         
        --> N'a pas besoin d'être modifié !
        ['ammos'] = { -- Name ; Price ; Stock Max ; Taken Slot ; Concerned weapons 
            [1] = {'9x19mm', 350, 10, 0, {22, 23, 28, 29, 32}},
            [2] = {'.45 ACP', 450, 15, 0, {24}},
            [3] = {'7.62mm', 800, 8, 0, {30, 33, 34, 38}},
            [4] = {'5.56mm', 900, 7, 0, {31}},
            [5] = {'12 Gauge', 600, 5, 0, {25, 26, 27}},
            [6] = {'Ogive hautement explosive', 1000, 10, 0, {35, 36}},
        },

        ['others'] = { -- Name ; Price ; ItemID ; Stock Max ; Taken Slot ; FactionType Access
            -- [16] = {'Atelier', 35000, 366, 1, 1, {1, 10}}, -- Désactivé en attendant la possibilité de l'achat unique par faction
            [17] = {'Laboratoire', 38000, 378, 0, 1, {1, 10}},

            [18] = {'Gilet pare-balles (25%)', 1300, 400, 4, 1, {10}},
            [19] = {'Gilet pare-balles (50%)', 2000, 401, 2, 2, {1}},

            [20] = {'Graine de marijuana', 200, 287, 15, 1, {0}},
            [21] = {'Fentanyl', 5, 386, 1000, 1, {10}},
            [22] = {'Éthylone', 5, 389, 1000, 1, {1}},

            [23] = {'Masque à gaz', 2500, 26, 2, 0, {0, 1, 10}},

            [24] = {'Accès Chopshop', 0, 0, 1, 1, {10}},
            [25] = {'Accès Pawnshop', 0, 0, 1, 1, {1}},
            [26] = {'Boîtier électronique', 69, 503, 1, 1, {0}},
            [27] = {'Accès Homejacking', 0, 0, 1, 1, {0}},

            [29] = {'Ammoniaque', 10, 402, 1000, 1, {0}},
            [30] = {'Pseudoephedrine', 10, 403, 1000, 1, {0}},
            [31] = {'Dexamethasone', 10, 404, 1000, 1, {10}},
            [32] = {'Benzoylecgonine', 10, 381, 1000, 1, {1}},
        },
    }, 
};
