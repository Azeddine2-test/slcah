-- Edited by Nando - 03/03/2023

GUIEditor_Window = {}
GUIEditor_TabPanel = {}
GUIEditor_Tab = {}
GUIEditor_Button = {}
GUIEditor_Checkbox = {}
GUIEditor_Label = {}

--"NormalTextColour"
local COLOR_SELECTED = "FF00FF00"
local COLOR_UNSELECTED = "FFAAAAAA"

local screenWidth, screenHeight = guiGetScreenSize()

local guiCheckBoxSetSelected_ = guiCheckBoxSetSelected
function guiCheckBoxSetSelected(element, state)
	if state then
		guiCheckBoxSetSelected_(element, true)
		guiSetProperty(element, "NormalTextColour", COLOR_SELECTED)
	else
		guiCheckBoxSetSelected_(element, false)
		guiSetProperty(element, "NormalTextColour", COLOR_UNSELECTED)
	end
end

function showSettingsWindow(tab)
	closeSettingsWindow()

	if wOptions and isElement(wOptions) then
		guiSetEnabled(wOptions, false)
	end

	if getElementData(getLocalPlayer(), "exclusiveGUI") or not isCameraOnPlayer()  then
		return false
	end

	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)

	local w, h = 740,474
	local x, y = (screenWidth-w)/2, (screenHeight-h)/2
	GUIEditor_Window.main = guiCreateWindow(x,y,w,h,"Paramètres",false)
	guiWindowSetSizable(GUIEditor_Window.main, false)
	GUIEditor_TabPanel.main = guiCreateTabPanel(0.0122,0.0401,0.9757,0.8692,true,GUIEditor_Window.main)


	GUIEditor_Tab.generalSettings = guiCreateTab("Jeu",GUIEditor_TabPanel.main)
	local lineH = 0.0515
	local posY = lineH

	GUIEditor_Checkbox.graphic_motionblur = guiCreateCheckBox(0.036,0.0361,0.2992,lineH,"Flou de mouvement GTA",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "graphic_motionblur") == "1" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_motionblur,true)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_motionblur,false)
	end

	GUIEditor_Checkbox.graphic_skyclouds = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Nuages réalistes",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "graphic_skyclouds") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_skyclouds,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_skyclouds,true)
	end

	posY = posY + lineH

	GUIEditor_Checkbox.streams = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Streaming audio (radio, etc.)",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "streams") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.streams,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.streams,true)
	end

	posY = posY + lineH

	GUIEditor_Checkbox.chatlogs_html = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Logs HTML du tchat",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "chatlogs_html") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.chatlogs_html,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.chatlogs_html,true)
	end

	posY = posY + lineH

	GUIEditor_Checkbox.see_chat_bubble_say = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Bulles de tchat IC",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "see_chat_bubble_say") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.see_chat_bubble_say,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.see_chat_bubble_say,true)
	end
	posY = posY + lineH

	GUIEditor_Checkbox.graphic_typingicon = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Bulles de saisie",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "graphic_typingicon") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_typingicon,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_typingicon,true)
	end

	posY = posY + lineH

	GUIEditor_Checkbox.graphic_nametags = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Voir nametags",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "graphic_nametags") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_nametags,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_nametags,true)
	end

	posY = posY + lineH

	GUIEditor_Checkbox.settings_hud_style = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Voir son propre nametag",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "settings_hud_style") == "1" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.settings_hud_style, true)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.settings_hud_style, false)
	end

	posY = posY + lineH

	GUIEditor_Checkbox.graphic_shaderwater = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Eau/océan réaliste",false,true,GUIEditor_Tab.generalSettings)
	if getResourceFromName("shader_water") then
		if getElementData(localPlayer, "graphic_shaderwater") == "0" then
			guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_shaderwater,false)
		else
			guiCheckBoxSetSelected(GUIEditor_Checkbox.graphic_shaderwater,true)
		end
	else
		guiSetEnabled(GUIEditor_Checkbox.graphic_shaderwater, false)
	end
	posY = posY + lineH

	GUIEditor_Checkbox.vehicle_hotkey = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Raccourcis clavier véhicule",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "vehicle_hotkey") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.vehicle_hotkey,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.vehicle_hotkey,true)
	end
	posY = posY + lineH

	GUIEditor_Checkbox.bind_indicators = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Raccourcis clavier clignotants",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "bind_indicators") == "1" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.bind_indicators, false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.bind_indicators, true)
	end
	posY = posY + lineH

	-- GUIEditor_Checkbox.autopark = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Auto /park à la sortie du véhicule",false,true,GUIEditor_Tab.generalSettings)
	-- if getElementData(localPlayer, "autopark") ~= "1" then
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.autopark,false)
	-- else
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.autopark,true)
	-- end
	-- posY = posY + lineH

	-----------------------------------------------------------------------
	local lineW2 = 0.34
	local posX = lineW2
	posY = 0.0361

	GUIEditor_Checkbox.vehicle_rims = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Jantes personnalisables",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "vehicle_rims") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.vehicle_rims,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.vehicle_rims,true)
	end
	posY = posY + lineH

	GUIEditor_Checkbox.talk_anim = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Animations de tchat IC",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "talk_anim") ~= "1" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.talk_anim,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.talk_anim,true)
	end
	posY = posY + lineH

	-- GUIEditor_Checkbox.pm_username = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Envoyer mon pseudo en /pm",false,true,GUIEditor_Tab.generalSettings)
	-- if getElementData(localPlayer, "pm_username") == "0" then
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.pm_username,false)
	-- else
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.pm_username,true)
	-- end
	-- posY = posY + lineH

	GUIEditor_Checkbox.weapon_show_selector = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Voir la molette de sélection d'armes",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "weapon_show_selector") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.weapon_show_selector,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.weapon_show_selector,true)
	end
	posY = posY + lineH

	-- local groundsnow = exports.global:isResourceRunning('shader_snow_ground') and true or false
	-- if groundsnow then
	-- 	GUIEditor_Checkbox.groundsnow = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Textures de neige",false,true,GUIEditor_Tab.generalSettings)
	-- 	if getElementData(localPlayer, "groundsnow") == "0" then
	-- 		guiCheckBoxSetSelected(GUIEditor_Checkbox.groundsnow,false)
	-- 	else
	-- 		guiCheckBoxSetSelected(GUIEditor_Checkbox.groundsnow,true)
	-- 	end
	-- 	posY = posY + lineH
	-- end

	-- local snowfall = exports.global:isResourceRunning('snow') and true or false
	-- if snowfall then
	-- 	GUIEditor_Checkbox.snowfall = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Effets de chute de neige",false,true,GUIEditor_Tab.generalSettings)
	-- 	if getElementData(localPlayer, "snowfall") == "0" then
	-- 		guiCheckBoxSetSelected(GUIEditor_Checkbox.snowfall,false)
	-- 	else
	-- 		guiCheckBoxSetSelected(GUIEditor_Checkbox.snowfall,true)
	-- 	end
	-- 	posY = posY + lineH
	-- end

	-- local xmas = exports.global:isResourceRunning('xmas') and true or false
	-- if xmas then
	-- 	GUIEditor_Checkbox.xmastreefx = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Effets sur le Sapin de Noël",false,true,GUIEditor_Tab.generalSettings)
	-- 	if getElementData(localPlayer, "xmastreefx") == "0" then
	-- 		guiCheckBoxSetSelected(GUIEditor_Checkbox.xmastreefx,false)
	-- 	else
	-- 		guiCheckBoxSetSelected(GUIEditor_Checkbox.xmastreefx,true)
	-- 	end
	-- 	posY = posY + lineH
	-- end

	GUIEditor_Checkbox.punishment_notification_selector = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Voir les punitions admin dans le tchat",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "punishment_notification_selector") == "1" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.punishment_notification_selector,true)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.punishment_notification_selector,false)
	end
	posY = posY + lineH

	GUIEditor_Checkbox.chat_see_adverts = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Voir les pubs dans le tchat",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "chat_see_adverts") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.chat_see_adverts,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.chat_see_adverts,true)
	end
	posY = posY + lineH

	-- fuck it, we're not using this anymore
	-- GUIEditor_Checkbox.enableNewUIStyle = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Nouveau style de GUI",false,true,GUIEditor_Tab.generalSettings)
	-- if getElementData(localPlayer, "enableNewUIStyle") == "0" then
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.enableNewUIStyle,false)
	-- else
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.enableNewUIStyle,true)
	-- end
	-- posY = posY + lineH

	GUIEditor_Checkbox.sound_icradio = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Effet sonore de radio (/r) IC",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "sound_icradio") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.sound_icradio, false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.sound_icradio, true)
	end
	posY = posY + lineH

	GUIEditor_Checkbox.sound_pms = guiCreateCheckBox(0.0222+posX,posY,0.313,lineH,"Effet sonore de PM (/pm)",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "sound_pms") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.sound_pms, false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.sound_pms, true)
	end
	posY = posY + lineH

	-- GUIEditor_Checkbox.vehicle_discs = guiCreateCheckBox(0.0222+posX,posY,0.413,lineH,"Cacher desc. de mon véhicule avec ALTGR",false,true,GUIEditor_Tab.generalSettings)
	-- if getElementData(localPlayer, "vehicle_description_altgr") == "1" then
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.vehicle_discs,true)
	-- else
	-- 	guiCheckBoxSetSelected(GUIEditor_Checkbox.vehicle_discs,false)
	-- end
	-- posY = posY + lineH
	
	GUIEditor_Checkbox.bus_stops = guiCreateCheckBox(0.0222+posX,posY,0.413,lineH,"Voir les arrêts de bus",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "busstops:hidden") == "1" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.bus_stops,true)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.bus_stops,false)
	end
	posY = posY + lineH
	
	GUIEditor_Checkbox.gang_zones = guiCreateCheckBox(0.0222+posX,posY,0.413,lineH,"Voir les gang-zones sur la map",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "gang_zones:show") == "1" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.gang_zones,true)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.gang_zones,false)
	end
	posY = posY + lineH

	-----------------------------------------------------------------------
	posX = posX + lineW2

	GUIEditor_Checkbox.enableOverlayDescription = guiCreateCheckBox(0.036+posX,0.0361,0.2992,lineH,"Voir les desc. superposées",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "enableOverlayDescription") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescription,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescription,true)
	end

	GUIEditor_Checkbox.enableOverlayDescriptionVeh = guiCreateCheckBox(0.036+posX,0.0361+lineH,0.2992,lineH,"Voir les desc. de véhicules",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "enableOverlayDescriptionVeh") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescriptionVeh,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescriptionVeh,true)
	end

	guiCreateLabel ( 0.036+posX,0.0361+lineH*2+0.005,0.2992,lineH ,  "Font :", true, GUIEditor_Tab.generalSettings )
	cFontVeh = guiCreateComboBox ( 0.036+posX+0.055,0.0361+lineH*2,0.2,lineH,  getElementData(localPlayer, "cFontVeh") or "default", true, GUIEditor_Tab.generalSettings )
	local count1 = 0
	for key, font in pairs(fonts) do
		guiComboBoxAddItem(cFontVeh, type(font[1]) == "string" and font[1] or "BizNoteFont18")
		count1 = count1 + 1
	end
	guiComboBoxAdjustHeight ( cFontVeh, count1 )
	addEventHandler ( "onClientGUIComboBoxAccepted", guiRoot,
		function ( comboBox )
			if ( comboBox == cFontVeh ) then
				local item = guiComboBoxGetSelected ( cFontVeh )
				local text = tostring ( guiComboBoxGetItemText ( cFontVeh , item ) )
				if ( text ~= "" ) then
					updateAccountSettings("cFontVeh", text)
				end
			end
		end
	)

	GUIEditor_Checkbox.enableOverlayDescriptionPro = guiCreateCheckBox(0.036+posX,0.0361+lineH*3,0.2992,lineH,"Voir les desc. de intérieurs",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "enableOverlayDescriptionPro") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescriptionPro,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescriptionPro,true)
	end

	guiCreateLabel ( 0.036+posX,0.0361+lineH*4+0.005,0.2992,lineH ,  "Font :", true, GUIEditor_Tab.generalSettings )
	cFontPro = guiCreateComboBox ( 0.036+posX+0.055,0.0361+lineH*4,0.2,lineH,  getElementData(localPlayer, "cFontPro") or "default", true, GUIEditor_Tab.generalSettings )
	local count1 = 0
	for key, font in pairs(fonts) do
		guiComboBoxAddItem(cFontPro, font[1])
		count1 = count1 + 1
	end
	guiComboBoxAdjustHeight ( cFontPro, count1 )
	addEventHandler ( "onClientGUIComboBoxAccepted", guiRoot,
		function ( comboBox )
			if ( comboBox == cFontPro ) then
				local item = guiComboBoxGetSelected ( cFontPro )
				local text = tostring ( guiComboBoxGetItemText ( cFontPro , item ) )
				if ( text ~= "" ) then
					updateAccountSettings("cFontPro", text)
				end
			end
		end
	)

	GUIEditor_Checkbox.enableOverlayDescriptionNote = guiCreateCheckBox(0.036+posX,0.0361+lineH*5,0.2992,lineH,"Voir les desc. de notes",false,true,GUIEditor_Tab.generalSettings)
	if getElementData(localPlayer, "enableOverlayDescriptionNote") == "0" then
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescriptionNote,false)
	else
		guiCheckBoxSetSelected(GUIEditor_Checkbox.enableOverlayDescriptionNote,true)
	end

	GUIEditor_Tab.Notifications = guiCreateTab("Notifications",GUIEditor_TabPanel.main)
	local lineH = 0.0515
	local posY = lineH

	GUIEditor_Label.graphicSettingsgeneral = guiCreateLabel(0.0222,0.0361,0.313,lineH,"Recevoir des notifications à propos de :",true,GUIEditor_Tab.Notifications)
	guiSetFont(GUIEditor_Label.graphicSettingsgeneral,"default-bold-small")

	GUIEditor_Checkbox.noti_faction_updates = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Factions",false,true,GUIEditor_Tab.Notifications)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.noti_faction_updates,getElementData(localPlayer, "noti_faction_updates") ~= "0")
	posY = posY + lineH

	-- GUIEditor_Checkbox.noti_offline_pm = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"PMs hors ligne",false,true,GUIEditor_Tab.Notifications)
	-- guiCheckBoxSetSelected(GUIEditor_Checkbox.noti_offline_pm,getElementData(localPlayer, "noti_offline_pm") ~= "0")
	-- posY = posY + lineH

	GUIEditor_Checkbox.vehicle_inactivity_scanner = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Inactivité de véhicules",false,true,GUIEditor_Tab.Notifications)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.vehicle_inactivity_scanner,getElementData(localPlayer, "vehicle_inactivity_scanner") ~= "0")
	posY = posY + lineH

	GUIEditor_Checkbox.interior_inactivity_scanner = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Inactivité de biens immobiliers",false,true,GUIEditor_Tab.Notifications)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.interior_inactivity_scanner,getElementData(localPlayer, "interior_inactivity_scanner") ~= "0")
	posY = posY + lineH

	-- GUIEditor_Checkbox.support_center = guiCreateCheckBox(0.036,0.0361+posY,0.2992,lineH,"Support Center",false,true,GUIEditor_Tab.Notifications)
	-- guiCheckBoxSetSelected(GUIEditor_Checkbox.support_center,getElementData(localPlayer, "support_center") ~= "0")

	-- local lineW2 = 0.34
	-- local posX = lineW2
	-- posY = 0.1005
	-- GUIEditor_Label.graphicSettingsgeneral = guiCreateLabel(0.0222+posX,0.0361,0.313,lineH,"Interface :",true,GUIEditor_Tab.Notifications)
	-- guiSetFont(GUIEditor_Label.graphicSettingsgeneral,"default-bold-small")
	-- GUIEditor_Checkbox.noti_no_noti = guiCreateCheckBox(0.036+posX,0.1005,1,lineH,"Voir le bouton même quand il y a aucune notification",false,true,GUIEditor_Tab.Notifications)
	-- guiCheckBoxSetSelected(GUIEditor_Checkbox.noti_no_noti, getElementData(localPlayer, "noti_no_noti") == "1")


	GUIEditor_Tab.Social = guiCreateTab("Social",GUIEditor_TabPanel.main)
	local lineH = 0.0515
	local posY = lineH

	GUIEditor_Label.graphicSettingsgeneral = guiCreateLabel(0.0222,0.0361,0.313,lineH,"Liste d'amis (O) :",true,GUIEditor_Tab.Social)
	guiSetFont(GUIEditor_Label.graphicSettingsgeneral,"default-bold-small")

	-- Nando 10/03/2023 => classic O friends interface forced
	-- GUIEditor_Checkbox.social_classic_user_interface = guiCreateCheckBox(0.036,0.0361+posY,0.888,lineH,"Interface Classique",false,true,GUIEditor_Tab.Social)
	-- guiCheckBoxSetSelected(GUIEditor_Checkbox.social_classic_user_interface,getElementData(localPlayer, "social_classic_user_interface") == "1")
	-- posY = posY + lineH

	GUIEditor_Checkbox.social_invite_only = guiCreateCheckBox(0.036,0.0361+posY,0.888,lineH,"Ne pas recevoir d'invitations",false,true,GUIEditor_Tab.Social)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.social_invite_only,getElementData(localPlayer, "social_invite_only") == "1")
	posY = posY + lineH

	GUIEditor_Checkbox.social_friends_bypass_pmblock = guiCreateCheckBox(0.036,0.0361+posY,0.888,lineH,"Permettre à mes amis de m'envoyer des PM même quand j'ai désactivé",false,true,GUIEditor_Tab.Social)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.social_friends_bypass_pmblock,getElementData(localPlayer, "social_friends_bypass_pmblock") == "1")
	posY = posY + lineH

	GUIEditor_Checkbox.social_friend_updates = guiCreateCheckBox(0.036,0.0361+posY,0.888,lineH,"Recevoir des alertes et des notifications de mes amis",false,true,GUIEditor_Tab.Social)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.social_friend_updates,getElementData(localPlayer, "social_friend_updates") ~= "0")
	posY = posY + lineH

	local indent = 0.02
	GUIEditor_Checkbox.social_friend_updates_on_off = guiCreateCheckBox(0.036+indent,0.0361+posY,0.888,lineH,"Connexion/Déconnexion",false,true,GUIEditor_Tab.Social)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.social_friend_updates_on_off,getElementData(localPlayer, "social_friend_updates_on_off") ~= "0")

	posY = posY + lineH
	GUIEditor_Checkbox.social_friend_updates_char = guiCreateCheckBox(0.036+indent,0.0361+posY,0.888,lineH,"Changement de personnage",false,true,GUIEditor_Tab.Social)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.social_friend_updates_char,getElementData(localPlayer, "social_friend_updates_char") ~= "0")

	posY = posY + lineH
	GUIEditor_Checkbox.social_friend_updates_msg = guiCreateCheckBox(0.036+indent,0.0361+posY,0.888,lineH,"Changement de message",false,true,GUIEditor_Tab.Social)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.social_friend_updates_msg,getElementData(localPlayer, "social_friend_updates_msg") ~= "0")

	posY = posY + lineH
	GUIEditor_Checkbox.social_friend_updates_sound = guiCreateCheckBox(0.036+indent,0.0361+posY,0.888,lineH,"Effet sonore",false,true,GUIEditor_Tab.Social)
	guiCheckBoxSetSelected(GUIEditor_Checkbox.social_friend_updates_sound,getElementData(localPlayer, "social_friend_updates_sound") ~= "0")

	guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_on_off, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))
	guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_msg, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))
	guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_char, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))
	guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_sound, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))

	-- Staff settings
	if exports.integration:isPlayerStaff(localPlayer) then

		GUIEditor_Tab.Staff = guiCreateTab("Staff",GUIEditor_TabPanel.main)
		local lineH = 0.0515
		local posY = lineH

		GUIEditor_Checkbox.auto_check = guiCreateCheckBox(0.0222,posY,0.413,lineH,"Ouvrir /check lors de /ar",false,true,GUIEditor_Tab.Staff)
		if getElementData(localPlayer, "auto_check") == "0" then
			guiCheckBoxSetSelected(GUIEditor_Checkbox.auto_check,false)
		else
			guiCheckBoxSetSelected(GUIEditor_Checkbox.auto_check,true)
		end
		posY = posY + lineH

		GUIEditor_Checkbox.enableIncomingReport = guiCreateCheckBox(0.0222,posY,0.413,lineH,"Effet sonore de nouveau report",false,true,GUIEditor_Tab.Staff)
		if getElementData(localPlayer, "incoming_report_sound") ~= "1" then
			guiCheckBoxSetSelected(GUIEditor_Checkbox.enableIncomingReport,false)
		else
			guiCheckBoxSetSelected(GUIEditor_Checkbox.enableIncomingReport,true)
		end
		posY = posY + lineH

		GUIEditor_Checkbox.enableIncomingPriorityReport = guiCreateCheckBox(0.0222,posY,0.413,lineH,"Effet sonore de report urgent",false,true,GUIEditor_Tab.Staff)
		if getElementData(localPlayer, "incoming_priority_report_sound") ~= "1" then
			guiCheckBoxSetSelected(GUIEditor_Checkbox.enableIncomingPriorityReport,false)
		else
			guiCheckBoxSetSelected(GUIEditor_Checkbox.enableIncomingPriorityReport,true)
		end
		posY = posY + lineH

		GUIEditor_Checkbox.enable_spectate_msgs = guiCreateCheckBox(0.0222,posY,0.413,lineH,"Message quand un admin spectate",false,true,GUIEditor_Tab.Staff)
		if getElementData(localPlayer, "enable_spectate_msgs") == "0" then
			guiCheckBoxSetSelected(GUIEditor_Checkbox.enable_spectate_msgs, false)
		else
			guiCheckBoxSetSelected(GUIEditor_Checkbox.enable_spectate_msgs, true)
		end
		posY = posY + lineH
	end

	------------ Close button ------------

	GUIEditor_Button.mainclose = guiCreateButton(0.0135,0.9135,0.9743,0.0675,"Fermer",true,GUIEditor_Window.main)
	addEventHandler("onClientGUIClick", GUIEditor_Window.main, options_updateGameSettings)
	if tab and GUIEditor_Tab[tab] then
		guiSetSelectedTab ( GUIEditor_TabPanel.main, GUIEditor_Tab[tab] )
	end
end
addEvent("accounts:settings:fetchSettings", true)
addEventHandler("accounts:settings:fetchSettings", localPlayer, showSettingsWindow)

function closeSettingsWindow()
	if isElement(GUIEditor_Window.main) then
		destroyElement(GUIEditor_Window.main)
		GUIEditor_Window = {}
		GUIEditor_TabPanel = {}
		GUIEditor_Tab = {}
		GUIEditor_Button = {}
		GUIEditor_Checkbox = {}
		GUIEditor_Label = {}
	end

	if wOptions and isElement(wOptions) then
		guiSetEnabled(wOptions, true)
	end
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	-- exports.OwlGamingLogs:closeInfoBox()
end

function options_updateGameSettings()
	if getElementType(source) == "gui-checkbox" then
		local color = guiGetProperty(source, "NormalTextColour")
		if color ~= COLOR_SELECTED and color ~= COLOR_UNSELECTED then
			return
		end
		if guiCheckBoxGetSelected(source) then
			guiSetProperty(source, "NormalTextColour", COLOR_SELECTED)
		else
			guiSetProperty(source, "NormalTextColour", COLOR_UNSELECTED)
		end
	end
	if source == GUIEditor_Button.mainclose then
		closeSettingsWindow()
	elseif source == GUIEditor_Checkbox.graphic_motionblur then
		local name, value = "graphic_motionblur", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_motionblur ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_skyclouds then
		local name, value = "graphic_skyclouds", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_skyclouds ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.streams then
		local name, value = "streams", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.streams ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_nametags then
		local name, value = "graphic_nametags", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_nametags ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.settings_hud_style then
		local name, value = "settings_hud_style", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.settings_hud_style ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.chatlogs_html then
		local name, value = "chatlogs_html", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.chatlogs_html ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.see_chat_bubble_say then
		local name, value = "see_chat_bubble_say", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.see_chat_bubble_say ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_typingicon then
		local name, value = "graphic_typingicon", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_typingicon ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_shaderradar then
		local name, value = "graphic_shaderradar", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_shaderradar ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_shaderwater then
		local name, value = "graphic_shaderwater", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_shaderwater ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_shaderveh then
		local name, value = "graphic_shaderveh", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_shaderveh ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_shaderveh_reflect then
		local name, value = "graphic_shaderveh_reflect", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_shaderveh_reflect ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.graphic_shader_darker_night then
		local name, value = "graphic_shader_darker_night", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.graphic_shader_darker_night ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.enableOverlayDescription then
		local name, value = "enableOverlayDescription", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.enableOverlayDescription ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.enableOverlayDescriptionVeh then
		local name, value = "enableOverlayDescriptionVeh", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.enableOverlayDescriptionVeh ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.enableOverlayDescriptionPro then
		local name, value = "enableOverlayDescriptionPro", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.enableOverlayDescriptionPro ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.enableOverlayDescriptionNote then
		local name, value = "enableOverlayDescriptionNote", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.enableOverlayDescriptionNote ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	-- elseif source == GUIEditor_Checkbox.autopark then
	-- 	local name, value = "autopark", "0"
	-- 	if guiCheckBoxGetSelected ( GUIEditor_Checkbox.autopark ) then
	-- 		value = "1"
	-- 	end
	-- 	updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.vehicle_hotkey then
		local name, value = "vehicle_hotkey", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.vehicle_hotkey ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.vehicle_rims then
		local name, value = "vehicle_rims", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.vehicle_rims ) then
			value = "1"
		end
		updateAccountSettings(name, value)
		triggerEvent("vehicle_rims", getRootElement(), value)
	elseif source == GUIEditor_Checkbox.chat_see_adverts then
		local name, value = "chat_see_adverts", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.chat_see_adverts ) then
			value = "1"
		end
		updateCharacterSettings(name, value)
	-- elseif source == GUIEditor_Checkbox.cellphone_log then
	-- 	local name, value = "cellphone_log", "0"
	-- 	if guiCheckBoxGetSelected ( GUIEditor_Checkbox.cellphone_log ) then
	-- 		value = "1"
	-- 		exports.OwlGamingLogs:drawInfoBox()
	-- 	end
	elseif source == GUIEditor_Checkbox.talk_anim then
		local name, value = "talk_anim", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.talk_anim ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.pm_username then
		local name, value = "pm_username", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.pm_username ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.weapon_show_selector then
		local name, value = "weapon_show_selector", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.weapon_show_selector ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.noti_faction_updates then
		local name, value = "noti_faction_updates", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.noti_faction_updates ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	-- elseif source == GUIEditor_Checkbox.noti_offline_pm then
	-- 	local name, value = "noti_offline_pm", "0"
	-- 	if guiCheckBoxGetSelected ( GUIEditor_Checkbox.noti_offline_pm ) then
	-- 		value = "1"
	-- 	end
	-- 	updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.vehicle_inactivity_scanner then
		local name, value = "vehicle_inactivity_scanner", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.vehicle_inactivity_scanner ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.interior_inactivity_scanner then
		local name, value = "interior_inactivity_scanner", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.interior_inactivity_scanner ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.support_center then
		local name, value = "support_center", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.support_center ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	-- elseif source == GUIEditor_Checkbox.noti_no_noti then
	-- 	local name, value = "noti_no_noti", "0"
	-- 	if guiCheckBoxGetSelected ( GUIEditor_Checkbox.noti_no_noti ) then
	-- 		value = "1"
	-- 	end
	-- 	updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.social_classic_user_interface then
		local name, value = "social_classic_user_interface", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_classic_user_interface ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.social_invite_only then
		local name, value = "social_invite_only", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_invite_only ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.social_friends_bypass_pmblock then
		local name, value = "social_friends_bypass_pmblock", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friends_bypass_pmblock ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.social_friend_updates then
		local name, value = "social_friend_updates", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ) then
			value = "1"
		end
		updateAccountSettings(name, value)
		guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_on_off, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))
		guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_msg, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))
		guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_char, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))
		guiSetEnabled(GUIEditor_Checkbox.social_friend_updates_sound, guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates ))
	elseif source == GUIEditor_Checkbox.social_friend_updates_on_off then
		local name, value = "social_friend_updates_on_off", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates_on_off ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.social_friend_updates_msg then
		local name, value = "social_friend_updates_msg", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates_msg ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.social_friend_updates_char then
		local name, value = "social_friend_updates_char", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates_char ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.social_friend_updates_sound then
		local name, value = "social_friend_updates_sound", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.social_friend_updates_sound ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.bind_indicators then
		local name, value = "bind_indicators", "1"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.bind_indicators ) then
			value = "0"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.dynamic_lighting then
		local name, value = "dynamic_lighting", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.dynamic_lighting ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.groundsnow then
		local name, value = "groundsnow", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.groundsnow ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.snowfall then
		local name, value = "snowfall", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.snowfall ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.xmastreefx then
		local name, value = "xmastreefx", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.xmastreefx ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.auto_check then
		local name, value = "auto_check", "0"
		if guiCheckBoxGetSelected ( GUIEditor_Checkbox.auto_check ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.punishment_notification_selector then
		local name, value = "punishment_notification_selector", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.punishment_notification_selector ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	-- elseif source == GUIEditor_Checkbox.enableNewUIStyle then
	-- 	local name, value = "enableNewUIStyle", "0"
	-- 	if guiCheckBoxGetSelected( GUIEditor_Checkbox.enableNewUIStyle ) then
	-- 		value = "1"
	-- 	end
	-- 	updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.enableIncomingReport then
		local name, value = "incoming_report_sound", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.enableIncomingReport ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.enableIncomingPriorityReport then
		local name, value = "incoming_priority_report_sound", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.enableIncomingReport ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.enable_spectate_msgs then
		local name, value = "enable_spectate_msgs", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.enable_spectate_msgs ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.sound_icradio then
		local name, value = "sound_icradio", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.sound_icradio ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.sound_pms then
		local name, value = "sound_pms", "0"
		if guiCheckBoxGetSelected( GUIEditor_Checkbox.sound_pms ) then
			value = "1"
		end
		updateAccountSettings(name, value)
	-- elseif source == GUIEditor_Checkbox.vehicle_discs then 
	-- 	local name, value = "vehicle_description_altgr", "0"
	-- 	if guiCheckBoxGetSelected(GUIEditor_Checkbox.vehicle_discs) then
	-- 		value = "1"
	-- 	end
	-- 	updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.bus_stops then 
		local name, value = "busstops:hidden", "0"
		if guiCheckBoxGetSelected(GUIEditor_Checkbox.bus_stops) then
			value = "1"
		end
		updateAccountSettings(name, value)
	elseif source == GUIEditor_Checkbox.gang_zones then 
		local name, value = "gang_zones:show", "0"
		if guiCheckBoxGetSelected(GUIEditor_Checkbox.gang_zones) then
			value = "1"
		end
		updateAccountSettings(name, value)
	end
end

function applyGameSettings(name, value)
	if name and value then
		if name == "duty_admin" or name == "duty_supporter" or name == "wrn:style" then
			value = tonumber(value) or value
		end
		setElementData(localPlayer, name, value, true)
		if name == "graphic_motionblur" then
			if (value == "1") then
				setBlurLevel(40)
			else
				setBlurLevel(0)
			end
		elseif name == "graphic_skyclouds" then
			if (value == "0") then
				setCloudsEnabled ( false )
			else
				setCloudsEnabled ( true )
			end
		elseif name == "streams" then
			triggerEvent("accounts:settings:updateCarRadio", localPlayer)
		elseif name == "graphic_typingicon" then
			triggerEvent("accounts:settings:graphic_typingicon", localPlayer)
		elseif name == "graphic_shaderradar" then
			--triggerEvent("accounts:settings:graphic_shaderradar", localPlayer)
		elseif name == "graphic_shaderwater" then
			triggerEvent("accounts:settings:graphic_shaderwater", localPlayer)
		elseif name == "graphic_shaderveh" then
			triggerEvent("accounts:settings:graphic_shaderveh", localPlayer)

		elseif name == "groundsnow" then
			local groundsnow = exports.global:isResourceRunning('shader_snow_ground') and true or false
			if groundsnow then
				if value == "0" then
					triggerEvent("switchGoundSnow", resourceRoot, false)
				elseif( value == "1") then
					triggerEvent("switchGoundSnow", resourceRoot, true)
				end
			end
		elseif name == "xmastreefx" then
			local xmas = exports.global:isResourceRunning('xmas') and true or false
			if xmas then
				if value == "0" then
					triggerEvent("xmas:updateTreeFX", root, true, false)
				elseif( value == "1") then
					triggerEvent("xmas:updateTreeFX", root, true, true)
				end
			end
		elseif name == "hide_hud" or name == "gang_zones:show" then
			triggerEvent("newRadar:update", localPlayer)
		-- elseif name == "enableNewUIStyle" then
		-- 	triggerEvent("hud:guiReset", localPlayer, nil, value)
		-- elseif name == "vehicle_description_altgr" then 
		-- 	triggerEvent("description:updateOwnView", localPlayer, value)
		end
	end
end

function updateAccountSettings(name, value)
	applyGameSettings(name, value)
	triggerServerEvent("saveClientAccountSettingsOnServer", localPlayer, name, value)
end
addEvent("accounts:settings:updateAccountSettings", true)
addEventHandler("accounts:settings:updateAccountSettings", localPlayer, updateAccountSettings)

function applyCharacterSettings(name, value)
	if name and value then
		setElementData(localPlayer, name, value, true)
		--outputDebugString("applyCharacterSettings".." "..name.." "..value)

		-- Nando: deactivated head movement | 07/03/2023
		-- if name == "head_turning" then
		-- 	triggerEvent("realism:updateLookAt", localPlayer)
		-- end
	end
end
addEvent("accounts:settings:applyCharacterSettings", true)
addEventHandler("accounts:settings:applyCharacterSettings", localPlayer, applyCharacterSettings)

function updateCharacterSettings(name, value)
	applyCharacterSettings(name, value)
	triggerServerEvent("saveClientCharacterSettingsOnServer", localPlayer, name, value)
end
addEvent("accounts:settings:updateCharacterSettings", true)
addEventHandler("accounts:settings:updateCharacterSettings", localPlayer, updateCharacterSettings)

function loadAccountSettings(settingsFromServer)
	if settingsFromServer then
		for i = 1, #settingsFromServer do
			if settingsFromServer[i][1] and settingsFromServer[i][2] then
				applyGameSettings(settingsFromServer[i][1], settingsFromServer[i][2])
			end
		end
	end
end
addEvent("accounts:settings:loadAccountSettings", true)
addEventHandler("accounts:settings:loadAccountSettings", localPlayer, loadAccountSettings)


function loadCharacterSettings(settingsFromServer)
	if settingsFromServer then
		for i = 1, #settingsFromServer do
			if settingsFromServer[i][1] and settingsFromServer[i][2] then
				applyCharacterSettings(settingsFromServer[i][1], settingsFromServer[i][2])
			end
		end
	end
end
addEvent("accounts:settings:loadCharacterSettings", true)
addEventHandler("accounts:settings:loadCharacterSettings", localPlayer, loadCharacterSettings)

function cleanUp()
	setElementData(localPlayer, "exclusiveGUI", false, false)
end
addEventHandler("onClientResourceStart", resourceRoot, cleanUp)

local oldhud
local function cmdToggleHud(cmd, chatToo)
	if not getElementData(localPlayer, "account:loggedin") then return end

	local currhud = getElementData(localPlayer, "hide_hud") or "2"
	if currhud == "-1" then
		-- set back to old or minimalistic
		updateAccountSettings('hide_hud', oldhud or "2")
		oldhud = nil

		if chatToo == true and not isChatVisible() then
			showChat(true)
		end
	else
		oldhud = currhud
		updateAccountSettings('hide_hud', "-1")

		if chatToo == true and isChatVisible() then
			showChat(false)
		end
	end
end
addCommandHandler("togglehud", cmdToggleHud, false)
addCommandHandler("toghud", cmdToggleHud, false)

local function toggleHudAndChat()
	if not getElementData(localPlayer, "account:loggedin") then return end

	cmdToggleHud("toghud", true)
end
bindKey("F7", "down", toggleHudAndChat)

local function cmdToggleStaffBar(cmd)
	if not getElementData(localPlayer, "account:loggedin") then return end

	local currbar = getElementData(localPlayer, "staff_bar") or "1"
	if currbar == "1" then
		outputChatBox("La barre de staff est désormais désactivée.", 255, 255, 0)
		updateAccountSettings('staff_bar', "0")
	else
		outputChatBox("La barre de staff est désormais activée.", 0, 255, 0)
		updateAccountSettings('staff_bar', "1")
	end
end
addCommandHandler("togbar", cmdToggleStaffBar, false)

local function cmdToggleStaffDuty(cmd)
	if not getElementData(localPlayer, "account:loggedin") then return end
	
	local currduty = getElementData(localPlayer, "staff_duty") or "1"
	if currduty == "1" then
		outputChatBox("Votre nametag ne changera plus de couleur quand vous serez en duty staff.", 255, 255, 0)
		updateAccountSettings('staff_duty', "0")
	else
		outputChatBox("Votre nametag changera maintenant de couleur quand vous serez en duty staff.", 0, 255, 0)
		updateAccountSettings('staff_duty', "1")
	end
end
addCommandHandler("togduty", cmdToggleStaffDuty, false)

local function cmdToggleNametags(cmd)

	local currtags = getElementData(localPlayer, "graphic_nametags") or "1"
	if currtags == "1" then
		exports["srp_notifs"]:add("Nametags cachés", "warnings")
		updateAccountSettings('graphic_nametags', "0")
	else
		exports["srp_notifs"]:add("Nametags activés", "success")
		updateAccountSettings('graphic_nametags', "1")
	end
end
addCommandHandler("nametags", cmdToggleNametags, false)
addCommandHandler("nametag", cmdToggleNametags, false)
addCommandHandler("tognametag", cmdToggleNametags, false)
addCommandHandler("tognametags", cmdToggleNametags, false)

