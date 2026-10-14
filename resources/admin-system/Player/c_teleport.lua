--[[
	@title
		Teleport Manager
	@author
		Chase
	@copyright
		2015 - OwlGaming
	@description
        Dynamic locations for /gotoplace, revised application for more efficient abilities.
		http://forums.owlgaming.net/showthread.php?36981

        Special thanks to Chaos
--]]
local gui = {}
local data = {}

function openLocationManager(locationData)
    if locationData and type(locationData) == "table" then
        data = locationData
    end

    terminateLocationManager()
    showCursor(true)

    local w, h = 400, 250

    gui.manager = guiCreateWindow(0, 0, w, h, "Lieux de téléportation", false)
    exports.global:centerWindow(gui.manager)

    gui.grid = guiCreateGridList(10, 23, 380, 172, false, gui.manager)
    gui.colID = guiGridListAddColumn(gui.grid, "ID", 0.1)
    gui.colValue = guiGridListAddColumn(gui.grid, "Valeur", 0.2)
    gui.colDesc = guiGridListAddColumn(gui.grid, "Description", 0.4)
    gui.colCreator = guiGridListAddColumn(gui.grid, "Staff", 0.2)

    for v, k in pairs(data) do
        gui.row = guiGridListAddRow(gui.grid)
        local a, b = gui.grid, gui.row
        guiGridListSetItemText(a, b, gui.colID, k["id"], false, true)
        guiGridListSetItemText(a, b, gui.colValue, k["location_value"], false, false)
        guiGridListSetItemText(a, b, gui.colDesc, k["location_description"], false, false)
        guiGridListSetItemText(a, b, gui.colCreator, exports.cache:getUsernameFromId(k["location_creator"]) or "Inconnu", false, false)
    end

    gui.addNew = guiCreateButton(10, 205, 71, 35, "Ajouter", false, gui.manager)
    checkElementUse(gui.addNew)
    addEventHandler("onClientGUIClick", gui.addNew, function ()
            openNewLocation()
            exports.global:playSoundSuccess()
    end, false)

    gui.deleteSelected = guiCreateButton(87, 205, 71, 35, "Supprimer", false, gui.manager)
    checkElementUse(gui.deleteSelected)
    addEventHandler("onClientGUIClick", gui.deleteSelected, function ()
            local r, c = guiGridListGetSelectedItem(gui.grid)
            if r ~= -1 and c ~= -1 then
                local id = guiGridListGetItemText(gui.grid, r, 1)
                triggerServerEvent("deleteLocation", localPlayer, localPlayer, id)
                exports.global:playSoundCreate()
                terminateLocationManager()
                updateLocations()
            else
                exports.global:playSoundError()
                exports.hud:sendBottomNotification(localPlayer, "Gestionnaire de lieu", "Veuillez sélectionner un lieu.")
            end
    end, false)

    gui.closeWindow = guiCreateButton(299, 205, 91, 35, "Fermer", false, gui.manager)
    addEventHandler("onClientGUIClick", gui.closeWindow, function ()
            if source == gui.closeWindow then
                terminateLocationManager()
            end
    end, false)

    if not canManage(localPlayer) then
        guiSetEnabled(gui.addNew, false)
        guiSetEnabled(gui.deletedSelected, false)
    end
end
addEvent("client:openLocationManager", true)
addEventHandler("client:openLocationManager", root, openLocationManager)

function terminateLocationManager()
    if gui.manager and isElement(gui.manager) then
        destroyElement(gui.manager)
        gui.manager = nil
        showCursor(false)
        terminateNewLocation()
    end
end

function openNewLocation()
    terminateNewLocation()
    terminateLocationManager()
    showCursor(true)
    guiSetInputEnabled(true)

    if canManage(localPlayer) then

        local w, h = 400, 150
        local status = "Votre position actuelle va être utilisée pour ce lieu."
        local c1, c2, c3 = 255, 255, 255 --white
        local r = 1
        local failures = 0
        local fool = getElementData(localPlayer, "account:username")

        gui.newLocation = guiCreateWindow(0, 0, w, h, "Ajouter un lieu de téléportation", false)
        exports.global:centerWindow(gui.newLocation)

        gui.valueLabel = guiCreateLabel(10, 53, 54, 15, "Valeur", false, gui.newLocation)
        gui.valueInput = guiCreateEdit(10, 28, 150, 25, "", false, gui.newLocation)
        checkElementUse(gui.valueInput)

        gui.descLabel = guiCreateLabel(164, 53, 118, 15, "Description du lieu", false, gui.newLocation)
        gui.descInput = guiCreateEdit(164, 28, 226, 25, "", false, gui.newLocation)
        checkElementUse(gui.descInput)

        gui.localeMessage = guiCreateLabel(10, 78, 380, 22, status, false, gui.newLocation)
        gui.localeStatusColor = guiLabelSetColor(gui.localeMessage, c1, c2, c3)

        gui.newCreate = guiCreateButton(240, 110, 150, 30, "Ajouter", false, gui.newLocation)
        checkElementUse(gui.newCreate)


            -- [[ Create Location Window ]] --
            addEventHandler("onClientGUIClick", gui.newCreate, function ()
                if source == gui.newCreate then --1
                    local newValue = guiGetText(gui.valueInput)
                    local newDesc = guiGetText(gui.descInput)

                    if string.len(newValue) < r or string.len(newDesc) < r then
                        exports.global:playSoundError()

                        -- Easter Egg failure messages
                        local failedGroup = {
                            "Veuillez insérer la valeur et la description du lieu.",
                            "Allez, insère une valeur et une description, merde !",
                            "Bon, je vois que tu ne veux pas le faire : valeur + description.",
                            "J'ai compris, t'as juste rien à faire de ta vie, je vois.",
                            "Est-ce que t'as déjà mangé un Apanyan Burger ?",
                            "Tu savais que c'est Silvio qui te parle là ?",
                            "Allez, casse-toi d'ici maintenant, laisse tomber pour le lieu.",
                        }

                        if (failures < 7) then
                            failures = failures + 1
                        end

                        failureMessage = failedGroup[failures]
                            -- When it reaches 18, it disables the input OR it will continue to change the text
                            if failureMessage == "Allez, casse-toi d'ici maintenant, laisse tomber pour le lieu." then
                                checkElementUse(gui.descInput, false, "True", "True")
                                guiSetText(gui.localeMessage, failedGroup[7])
                            else
                                local c1, c2, c3 = 252, 106, 104 --red
                                guiLabelSetColor(gui.localeMessage, c1, c2, c3)
                                guiSetText(gui.localeMessage, failureMessage)
                            end

                        return
                    end


                        if string.len(newValue) >= 10 or string.len(newDesc) >= 25 then
                            guiSetText(gui.localeMessage, "La valeur et la description doivent être entre 10 et 25 caractères.")
                            local c1, c2, c3 = 252, 106, 104 --red
                            guiLabelSetColor(gui.localeMessage, c1, c2, c3)
						elseif string.find(newValue, " ") then
							guiSetText(gui.localeMessage, "La valeur ne peut pas contenir d'epsace.")
                            local c1, c2, c3 = 252, 106, 104 --red
                            guiLabelSetColor(gui.localeMessage, c1, c2, c3)
                        else
                            triggerServerEvent("addNewLocation", localPlayer, localPlayer, newValue, newDesc)
                            exports.global:playSoundCreate()
                            updateLocations()
                            terminateNewLocation()

                        end
                end
            end)

    gui.closeNewWindow = guiCreateButton(10, 110, 90, 30, "Annuler", false, gui.newLocation)
    addEventHandler("onClientGUIClick", gui.closeNewWindow,
        function()
            if source == gui.closeNewWindow then
                terminateNewLocation()
            end
        end)
    end
end

function terminateNewLocation()
    if gui.newLocation and isElement(gui.newLocation) then
        destroyElement(gui.newLocation)
        openLocationManager()
        gui.newLocation = nil
        showCursor(true)
        guiSetInputEnabled(false)
    end
end

function updateLocations()
    triggerServerEvent("server:openLocationManager", root, localPlayer)
end

-- [[ Permissions ]] --

function checkElementUse(element, property, value, value2)
    -- automatically will disable buttons, primarily; is used for other statements
    if not property then property = "Disabled" end
    if not value or not value2 then value = "True" value2 = "False"  end

    if exports.integration:isPlayerLeadAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer) then
        return guiSetProperty(element, property, value2)
    else
        return guiSetProperty(element, property, value)
    end
end

function canView(thePlayer)
    -- groups who can open /tps
    if exports.integration:isPlayerSupporter(thePlayer) or exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerLeadAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) then
        return true
    else
        return false
    end
end

function canManage(thePlayer)
    -- groups who can manage (add, delete) /tps
    -- same definition as checkElementUse()
    if exports.integration:isPlayerSeniorAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer) then
        return true
    else
        return false
    end
end
