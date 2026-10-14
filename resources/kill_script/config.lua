--[[ 
    Team:  	    Southland
    Author:     Whiletruend
    Addon:		Kill Script
    Date:		31/08/2023
]]--


--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.KillScript = SL.KillScript or {};
SL.KillScript.Config = SL.KillScript.Config or {};


--[[----------------------------------------
    --> Config(s)
--]]----------------------------------------
SL.KillScript.Config = {
    ['base'] = {
        PREFIX = '[KillScript] ',
        injured_health = 10, --> How much health when the player get up from an injury
        playerkill_time = 10, --> Time in seconds (6 minutes) (60s x 6mn)
        invincible_time = 2, --> Time in seconds (2 seconds)

        ['messages'] = {
            thirdp_me_killed = "vient d'être achevé(e).",
            thirdp_killed = "(( CE JOUEUR EST DÉCÉDÉ ))",
            firstp_killed = "Vous venez d'être achevé(e) par %s.",
            thirdp_injury_killed = "vient de décéder à la suite de ses blessures.",

            ['light'] = {
                thirdp_injured = "(( Légèrement blessé(e) ))",
                firstp_injured = "Vous venez d'être légèrement blessé(e), vous vous êtes écroulé au sol.\nVous vous releverez dans %d %s sauf si quelqu'un vient vous achever.",
                autome_injured = "a été légèrement blessé(e), s'écroulant au sol.",
                getup_injured = "Vous venez de vous relever, n'oubliez pas de jouer vos blessures.",
                time_injured = 60, --> Time in seconds (1 minute) (60s x 1mn)
            },

            ['heavy'] = {
                thirdp_injured = "(( Grièvement blessé(e) ))",
                firstp_injured = "Vous venez d'être grièvement blessé(e), vous vous êtes écroulé au sol.\nSi personne vient vous réanimer dans %d %s, vous décéderez. Vous pourrez accélerer le processus dans %d %s avec la commande /accepter mort.",
                autome_injured = "a été grièvement blessé(e), s'écroulant au sol.",
                accept_death = "Vous venez d'accélerer le processus de mort.",
                can_accept_death = "Vous pouvez accélerer le processus de mort avec la commande /accepter mort.",
                dead = "Vous êtes mort (PK). Le bouton de respawn apparaîtra dans %d %s.",
                can_respawn = "Vous pouvez désormais respawn. Si vous ne réapparaissez pas dans %d %s, vous le serez alors automatiquement.",
                getup_injured = "Vous venez de vous relever, n'oubliez pas de jouer vos blessures.",
                time_injured = 600, --> Time in seconds (10 minutes) (60s x 10mn)
                time_for_accept = 180, --> Time in seconds (3 minutes) (60s x 3mn)
                time_auto_respawn = 240 --> Time in seconds (4 minute) (60s x 4mn)
            },
        },

        ['3d'] = {
            max_distance = 10, --> Max distance for 3D text (meters)
            font = 'default-bold',
            size = 1,
            height = 0,
        },

        ['controls'] = { --> Controls that will be disabled
            'fire',
            'aim_weapon',
            'enter_exit',
            'next_weapon',
            'previous_weapon',
            'jump',
            'sprint',
            'crouch',
            'action',
            'walk',
            'forwards',
            'backwards',
            'left',
            'right',
            'zoom_in',
            'zoom_out',
        },
    },

    ['weapons'] = {
        ['non_lethal'] = {
            0, 1, 2, 3,     --> Fist, Brass Knuckles, Golf Club, Nightstick
            5, 6, 7, 10,    --> Bat, Shovel, Pool Stick, Dildo
            11, 12, 13, 14, --> Dildo 02, Vibrator, Vibrator 02, Flower
            15, 41, 42, 43, --> Cane, Spraycan, Fire extinguisher, Camera
            44, 45, 46,     --> Night-Vision Goggles, Infra-red, Parachute
        },

        ['lethal'] = {
            4, 8, 9, 22,    --> Knife, Katana, Chainsaw, Colt 45
            23, 24, 25, 26, --> Silenced, Deagle, Shotgun, Sawnoff
            27, 28, 29, 30, --> Combat Shotgun, Uzi, MP5, AK-47
            31, 32, 33, 34, --> M4, Tec-9, Rifle, Sniper
            35, 36, 37, 38, --> Rocket Launcher, Heat-Seeking, Flamethrower, Minigun
            16, 18, 39, 40, --> Grenade, Molotov, Satchel, Bomb
        },
    },
};