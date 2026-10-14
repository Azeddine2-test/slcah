--[[ 
    Team:  	    Southland
    Author:     Whiletruend
    Addon:		Overdose script for 'Drugs' resource
    Date:		04/09/2023
]]--


--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.Overdose = SL.Overdose or {};
SL.Overdose.Config = SL.Overdose.Config or {};


--[[----------------------------------------
    --> Config(s)
--]]----------------------------------------
SL.Overdose.Config = {
    ['base'] = {
        PREFIX = '[Drogue] ',
        check_time = 3600, --> Time in seconds between each verifications (1 hr) (60s x 60mn)

        ['messages'] = {
            ['unconscious'] = {
                firstp_message = 'Vous avez perdu connaissance suite à votre dépendance à la drogue. Vous vous relèverez dans %d %s.',
                autome_message = 'a perdu connaissance.',
                getup_message = 'Vous avez repris connaissance.',
                timer_event = 60, --> Time in seconds (2 minutes) (60s x 1mn)
            },

            ['start_overdose'] = {
                firstp_message = 'Vous commencez à avoir des tremblements dû à votre dépendance à la drogue. Si vous ne prenez pas de drogue dans %d %s, vous ferez une overdose.',
                autome_message = 'rentre dans une transe anormale. Son corps subit des tremblements incontrôlables.',
                timer_event = 600, --> Time in seconds (6 minutes) (60s x 6mn)
            },

            ['overdose'] = {
                firstp_message = 'Vous avez fait une overdose suite à votre dépendance à la drogue. Si personne vient vous réanimer dans %d %s, vous décéderez.',
                autome_message = 'a fait une overdose.',
                timer_event = 360, --> Time in seconds (6 minutes) (60s x 6mn)
            },
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
};