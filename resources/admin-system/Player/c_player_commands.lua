function nudgeNoise(message, type)
   local sound = playSound("Player/nudge.wav")
   setSoundVolume(sound, 0.5) -- set the sound volume to 50%
   setWindowFlashing(true)

   if message then
	   createTrayNotification(message, type)
   end
end
addEvent("playNudgeSound", true)
addEventHandler("playNudgeSound", getLocalPlayer(), nudgeNoise)
addCommandHandler("playthenoise", nudgeNoise)

function doEarthquake(intensity)
	local x, y, z = getElementPosition(getLocalPlayer())
	createExplosion(x, y, z, -1, false, tonumber(intensity), false)
end
addEvent("doEarthquake", true)
addEventHandler("doEarthquake", getLocalPlayer(), doEarthquake)

function streamASound(link)
	playSound(link)
end
addEvent("playSound", true)
addEventHandler("playSound", getRootElement(), streamASound)

function develop(cmd)
	if exports.integration:isPlayerStaff(localPlayer) then
		local enabled = getDevelopmentMode()
		setDevelopmentMode(not enabled)
		if not enabled then
			outputChatBox("Mode développement activé (/showcol, /showsound).", 0, 255, 0)
		else
			outputChatBox("Mode développement désactivé.", 252, 106, 104)
		end
	end
end
addCommandHandler("devmode", develop, false)

function seeFar(localPlayer, value)
	if not value then outputChatBox("Utilisation: /seefar [Valeur (-1 pour réinitialiser)]") end
	if value and tonumber(value) >= 250 and tonumber(value) <= 20000 then
		setFarClipDistance(value)
		outputChatBox("La distance de rendu a été définie à "..value..".")
	elseif value and tonumber(value) == -1 then
		resetFarClipDistance()
	else
		outputChatBox("La distance de rendu doit être entre 250 et 20000.")
	end
end
addCommandHandler("seefar", seeFar)

--CARGO GROUP
local cargoSpawner = {
	button = {},
	window = {},
	edit = {},
	label = {},
	radiobutton = {},
	tabpanel = {},
	tab = {},
	memo = {}
}

function buildCargoGUI(admin)
	if not admin then admin = false end

	if isElement(cargoSpawner.window[1]) then	
		if not guiGetVisible(cargoSpawner.window[1]) then
			guiSetVisible(cargoSpawner.window[1], true)

			guiSetInputMode("no_binds_when_editing")
			triggerEvent("cursorShow", localPlayer)
		else
			guiSetVisible(cargoSpawner.window[1], false)

			guiSetInputMode("allow_binds")
			triggerEvent("cursorHide", localPlayer)
		end
		return
	end

	guiSetInputMode("no_binds_when_editing")
	triggerEvent("cursorShow", localPlayer)
	
	
	cargoSpawner.window[1] = guiCreateWindow(938, 354, 471, 389, "Objet générique", false)
	guiWindowSetSizable(cargoSpawner.window[1], false)
	exports.global:centerWindow(cargoSpawner.window[1])

	cargoSpawner.button[1] = guiCreateButton(339, 350, 122, 29, "Fermer", false, cargoSpawner.window[1])
	cargoSpawner.button[3] = guiCreateButton(10, 350, 122, 29, "Réinitialiser", false, cargoSpawner.window[1])
	guiSetProperty(cargoSpawner.button[3], "NormalTextColour", "FFAAAAAA")

	cargoSpawner.tabpanel[1] = guiCreateTabPanel(10, 30, 451, 310, false, cargoSpawner.window[1])

	cargoSpawner.tab[1] = guiCreateTab("Objet générique", cargoSpawner.tabpanel[1])

	cargoSpawner.label[1] = guiCreateLabel(20, 29, 190, 17, "Prix unitaire", false, cargoSpawner.tab[1])
	cargoSpawner.edit[1] = guiCreateEdit(10, 51, 208, 27, "0", false, cargoSpawner.tab[1])
	cargoSpawner.label[2] = guiCreateLabel(243, 29, 190, 17, "Quantité (max. 30)", false, cargoSpawner.tab[1])
	cargoSpawner.edit[2] = guiCreateEdit(233, 51, 208, 27, "1", false, cargoSpawner.tab[1])
	cargoSpawner.label[3] = guiCreateLabel(20, 105, 190, 17, "Nom", false, cargoSpawner.tab[1])
	cargoSpawner.edit[3] = guiCreateEdit(10, 126, 208, 27, "Objet générique", false, cargoSpawner.tab[1])
	cargoSpawner.label[4] = guiCreateLabel(243, 105, 190, 17, "ID objet", false, cargoSpawner.tab[1])
	cargoSpawner.edit[4] = guiCreateEdit(233, 126, 208, 27, "1271", false, cargoSpawner.tab[1])
	cargoSpawner.label[5] = guiCreateLabel(20, 180, 190, 17, "Taille", false, cargoSpawner.tab[1])
	cargoSpawner.edit[5] = guiCreateEdit(10, 201, 208, 27, "1", false, cargoSpawner.tab[1])
	cargoSpawner.label[6] = guiCreateLabel(243, 180, 190, 17, "Poids en kg", false, cargoSpawner.tab[1])
	cargoSpawner.edit[6] = guiCreateEdit(233, 201, 208, 27, "0.5", false, cargoSpawner.tab[1])

	cargoSpawner.button[2] = guiCreateButton(10, 246, 431, 29, "Créer", false, cargoSpawner.tab[1])
	guiSetProperty(cargoSpawner.button[2], "NormalTextColour", "FF00FF00")

	cargoSpawner.tab[2] = guiCreateTab("Stockage générique", cargoSpawner.tabpanel[1])

	cargoSpawner.label[201] = guiCreateLabel(20, 29, 190, 17, "Prix unitaire", false, cargoSpawner.tab[2])
	cargoSpawner.edit[201] = guiCreateEdit(10, 51, 208, 27, "0", false, cargoSpawner.tab[2])
	cargoSpawner.label[202] = guiCreateLabel(243, 29, 190, 17, "Quantité (max. 30)", false, cargoSpawner.tab[2])
	cargoSpawner.edit[202] = guiCreateEdit(233, 51, 208, 27, "1", false, cargoSpawner.tab[2])
	cargoSpawner.label[203] = guiCreateLabel(20, 105, 190, 17, "Nom", false, cargoSpawner.tab[2])
	cargoSpawner.edit[203] = guiCreateEdit(10, 126, 208, 27, "Stockage générique", false, cargoSpawner.tab[2])
	cargoSpawner.label[204] = guiCreateLabel(243, 105, 190, 17, "ID objet", false, cargoSpawner.tab[2])
	cargoSpawner.edit[204] = guiCreateEdit(233, 126, 208, 27, "2163", false, cargoSpawner.tab[2])
	cargoSpawner.label[205] = guiCreateLabel(20, 180, 190, 17, "Taille", false, cargoSpawner.tab[2])
	cargoSpawner.edit[205] = guiCreateEdit(10, 201, 208, 27, "1", false, cargoSpawner.tab[2])
	cargoSpawner.label[206] = guiCreateLabel(243, 180, 190, 17, "Capacité de stockage en kg", false, cargoSpawner.tab[2])
	cargoSpawner.edit[206] = guiCreateEdit(233, 201, 208, 27, "50", false, cargoSpawner.tab[2])
	
	cargoSpawner.button[200] = guiCreateButton(10, 246, 431, 29, "Créer", false, cargoSpawner.tab[2])
	guiSetProperty(cargoSpawner.button[200], "NormalTextColour", "FF00FF00")

	local function validateFields(createBtn)
		
		local itemID, price, quantity, name, model, scale, weight, capacity
		if createBtn == cargoSpawner.button[2] then
			itemID = 80

			price = tonumber(guiGetText(cargoSpawner.edit[1]))
			quantity = tonumber(guiGetText(cargoSpawner.edit[2]))
			name = guiGetText(cargoSpawner.edit[3])
			model = tonumber(guiGetText(cargoSpawner.edit[4]))
			scale = tonumber(guiGetText(cargoSpawner.edit[5]))
			weight = tonumber(guiGetText(cargoSpawner.edit[6]))

			if (not weight) or not (weight > 0 and weight <= 10) then
				return false, "Poids doit être >= 0 et <= 10."
			end
		else
			itemID = 223

			price = tonumber(guiGetText(cargoSpawner.edit[201]))
			quantity = tonumber(guiGetText(cargoSpawner.edit[202]))
			name = guiGetText(cargoSpawner.edit[203])
			model = tonumber(guiGetText(cargoSpawner.edit[204]))
			scale = tonumber(guiGetText(cargoSpawner.edit[205]))
			capacity = tonumber(guiGetText(cargoSpawner.edit[206]))

			if (not capacity) or not (capacity > 0 and capacity <= 1000000) then
				return false, "Capacité doit être >= 0 et <= 1000000."
			end
		end
		
		-- checks
		if (not price) or (price == 0 and not admin) then
			return false, "Prix doit être > 0."
		end
		if (not quantity) or (quantity > 30 or quantity < 1) then
			return false, "Quantité dôit être >= 0 et <= 30."
		end
		if (string.len(name) < 3) then
			return false, "Nom trop court (min. 3 caractères)."
		end
		if (not model) then
			return false, "ID objet doit être numérique."
		end
		if (not scale) or not (scale > 0 and scale <= 10) then
			return false, "Taille doit être >= 0 et <= 10."
		end

		return itemID, price, quantity, name, model, scale, weight, capacity
	end


	addEventHandler("onClientGUIClick", cargoSpawner.window[1], function()
		if source == cargoSpawner.button[1] then --close window
			guiSetVisible(cargoSpawner.window[1], false)
			guiSetInputMode("allow_binds")
			triggerEvent("cursorHide", localPlayer)

		elseif source == cargoSpawner.button[3] then --reset fields
			destroyElement(cargoSpawner.window[1])
			buildCargoGUI(admin)

		elseif source == cargoSpawner.button[2] or source == cargoSpawner.button[200] then --create item
			
			local itemID, price, quantity, name, model, scale, weight, capacity = validateFields(source)
			if not itemID then
				return genericAlert("Erreur", price, "OK", 252, 106, 104)
			end

			local itemValue = 1
			local metadata = {
				['item_name'] = name,
				['model'] = model,
				['scale'] = scale,
				['weight'] = weight or nil,
				['capacity'] = capacity or nil,
			}

			triggerServerEvent("createCargoGeneric", getResourceRootElement(), localPlayer, admin, itemID, itemValue, metadata, price, quantity)
		end
	end)
end
addEvent("createCargoGUI", true)
addEventHandler("createCargoGUI", getRootElement(), buildCargoGUI)

function genericAlert(title, text, btnText, r, g, b)
	genericAlertClose()
	cargoSpawner.window[2] = guiCreateWindow(0, 0, 400, 100, tostring(title), false)
	guiWindowSetSizable(cargoSpawner.window[2], false)
	exports.global:centerWindow(cargoSpawner.window[2])
	cargoSpawner.label[2001] = guiCreateLabel(20, 15, 360, 30, tostring(text), false, cargoSpawner.window[2])
	guiLabelSetHorizontalAlign(cargoSpawner.label[2001], "center", true)
	guiLabelSetVerticalAlign(cargoSpawner.label[2001], "center")
	if tonumber(r) and tonumber(g) and tonumber(b) then
		guiLabelSetColor(cargoSpawner.label[2001], r, g, b)
	end
	cargoSpawner.button[2001] = guiCreateButton(20, 50, 360, 30, btnText, false, cargoSpawner.window[2])

	addEventHandler("onClientGUIClick", cargoSpawner.button[2001], function()
		genericAlertClose()
	end, false)

	if isElement(cargoSpawner.window[1]) then
		guiSetEnabled(cargoSpawner.window[1], false)
	end
end
function genericAlertClose()
	if cargoSpawner.window[2] then
		if isElement(cargoSpawner.window[2]) then
			destroyElement(cargoSpawner.window[2])
		end
		cargoSpawner.window[2] = nil
		if isElement(cargoSpawner.window[1]) then
			guiSetEnabled(cargoSpawner.window[1], true)
		end
	end
end

function createCargoCommand()
	if exports.integration:isPlayerSeniorAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer) then
		buildCargoGUI(true)
	end
end
addCommandHandler("makegeneric", createCargoCommand)



