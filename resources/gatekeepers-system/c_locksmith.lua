-- Nando 06/03/2023 edited
-- Now only for house keys (vehicle keys are duped by mechs now)

local cost = 50 -- cost in dollars per key

local KEY_TYPE_HOUSE_BIZ = "Clé ((Intérieur))"
local KEY_TYPE_ELEVATOR = "Clé ((Téléporteur))"

local GUIEditor = {
    edit = {},
    button = {},
    window = {},
    label = {},
    combobox = {}
}
local title = "Que puis-je faire pour vous ?"
function createGUI()
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then destroyElement(GUIEditor.window[1]) end

	GUIEditor.window[1] = guiCreateWindow(656, 279, 272, 180, "Serrurier - $"..cost.." par clé", false)
	guiWindowSetSizable(GUIEditor.window[1], false)

	GUIEditor.label[1] = guiCreateLabel(0.03, 0.12, 0.93, 0.09, title, true, GUIEditor.window[1])
	GUIEditor.combobox[1] = guiCreateComboBox(0.03, 0.27, 0.47, 0.69, "Type de clé", true, GUIEditor.window[1])
	guiComboBoxAddItem(GUIEditor.combobox[1], KEY_TYPE_HOUSE_BIZ)
	guiComboBoxAddItem(GUIEditor.combobox[1], KEY_TYPE_ELEVATOR)

	GUIEditor.edit[1] = guiCreateEdit(0.52, 0.41, 0.43, 0.13, "", true, GUIEditor.window[1])
	GUIEditor.label[2] = guiCreateLabel(0.53, 0.29, 0.40, 0.12, "ID de la clé", true, GUIEditor.window[1])
	GUIEditor.label[3] = guiCreateProgressBar(0.53, 0.60, 0.42, 0.10, true, GUIEditor.window[1])
	GUIEditor.button[1] = guiCreateButton(0.53, 0.75, 0.23, 0.18, "Dupliquer", true, GUIEditor.window[1])
	guiSetProperty(GUIEditor.button[1], "NormalTextColour", "FF00FF00")
	addEventHandler("onClientGUIClick", GUIEditor.button[1], function ()
			local type = guiGetText(GUIEditor.combobox[1]) or "Error"
			local id = guiGetText(GUIEditor.edit[1]) or "ID Error"
			duplicateKey(type, id)
		end, false)

	GUIEditor.button[2] = guiCreateButton(0.76, 0.75, 0.19, 0.18, "Annuler", true, GUIEditor.window[1])
	addEventHandler("onClientGUIClick", GUIEditor.button[2], function ()
			destroyElement(GUIEditor.window[1])
			guiSetInputMode("allow_binds")
		end, false)
		
	guiSetInputMode("no_binds_when_editing")
	
	triggerEvent("hud:convertUI", localPlayer, GUIEditor.window[1])
end
addEvent("locksmithGUI", true)
addEventHandler("locksmithGUI", localPlayer, createGUI)

function duplicateKey(type, id)
	local keytypes = nil

	id = tonumber(id)
	if not id then -- checks if its an actual number
		guiSetText( GUIEditor.label[1], "Vous devez entrer un nombre (ID de la clé)." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], title)
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if type == KEY_TYPE_HOUSE_BIZ then keytypes = {4,5} end
	if type == KEY_TYPE_ELEVATOR then keytypes = {73} end
	if keytypes == nil then -- if hasn't chosen any key type from dropdown menu
		guiSetText( GUIEditor.label[1], "Vous devez choisir un type de clé." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], title)
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	local foundKeytype = nil
	for k,v in ipairs(keytypes) do
		if exports.global:hasItem(localPlayer, v, id) then -- checks if you have the key on you
			foundKeytype = v
			break
		end
	end
	if not foundKeytype then -- checks if you actually have the key on you
		guiSetText( GUIEditor.label[1], "Vous n'avez pas cette clé sur vous." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], title)
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if not exports.global:hasMoney(localPlayer, cost) then -- checks if the player has enough money to get it duplicated
		guiSetText( GUIEditor.label[1], "Vous n'avez pas assez d'argent." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], title)
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if not exports.global:hasSpaceForItem(localPlayer, foundKeytype, id) then -- checks if the player has enough space in his inventory
		guiSetText( GUIEditor.label[1], "Vous n'avez pas assez d'espace dans votre inventaire." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], title)
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	guiSetText(GUIEditor.label[1], "Duplication en cours...")
	guiLabelSetColor(GUIEditor.label[1], 0, 255, 0)

	guiProgressBarSetProgress(GUIEditor.label[3], 0)
	guiSetEnabled(GUIEditor.window[1], false)
	setTimer( function()
		if isElement(GUIEditor.label[3]) then
			guiProgressBarSetProgress (GUIEditor.label[3], guiProgressBarGetProgress(GUIEditor.label[3]) + 5 )
		end
	end, 500, 20)
	setTimer(function ()
		if isElement(GUIEditor.window[1]) then
			guiSetText(GUIEditor.label[1], "C'est fait !")
			guiSetEnabled(GUIEditor.window[1], true)

			triggerServerEvent("locksmithNPC:givekey", resourceRoot, foundKeytype, id, cost)
		end
	end, 10000, 1)
end
