local theFont = guiCreateFont( ":resources/Montserrat-Bold.ttf", 20 ) or "default-bold-small"
function useVehicleInterior(key, keyState, vehicle)
	--outputDebugString("useVehicleInterior()")
	--if(key == "f" and keyState == "down") then
		unbindKey("enter_exit", "down", useVehicleInterior)
		--unbindKey("space", "down", useVehicleInterior)
		hideIntName()
		--outputDebugString("useVehicleInterior() ok")
		triggerServerEvent("enterVehicleInterior", getLocalPlayer(), vehicle)
		cancelEvent()
	--end
end

function vehInteriorGUI()
	--outputDebugString("vehInteriorGUI()")
	if (isElement(gInteriorName) and guiGetVisible(gInteriorName)) then
		if isTimer(timer) then
			killTimer(timer)
			timer = nil
		end

		destroyElement(gInteriorName)
		gInteriorName = nil

		destroyElement(gOwnerName)
		gOwnerName = nil

		unbindKey("enter_exit", "down", useVehicleInterior)
		--unbindKey("space", "down", useVehicleInterior)
	end
	local px,py,pz = getElementPosition(getLocalPlayer())
	local x,y,z = getElementPosition(source)

	gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, "Intérieur", true)
	if not theFont then
		theFont = guiCreateFont( ":resources/Montserrat-Bold.ttf", 20 ) or "default-bold-small"
	end
	guiSetFont(gInteriorName, theFont)
	guiLabelSetHorizontalAlign(gInteriorName, "center", true)
	guiSetAlpha(gInteriorName, 0.0)

	gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Appuyez 'F' pour entrer", true)
	guiSetFont(gOwnerName, "default-bold-small")
	guiLabelSetHorizontalAlign(gOwnerName, "center", true)
	guiSetAlpha(gOwnerName, 0.0)

	timer = setTimer(fadeMessage, 50, 20, true)

	--outputDebugString("source: "..tostring(source))
	local result = bindKey("enter_exit", "down", useVehicleInterior, source)
	--outputDebugString("bind key = "..tostring(result))
	--bindKey("space", "down", useVehicleInterior, source)
end
addEvent("vehicle-interiors:showInteriorGUI", true)
addEventHandler("vehicle-interiors:showInteriorGUI", getRootElement(), vehInteriorGUI)
function hideVehInteriorGUI()
	--outputDebugString("unbound")
	unbindKey("enter_exit", "down", useVehicleInterior)
	--unbindKey("space", "down", useVehicleInterior)
	hideIntName()
end
addEvent("vehicle-interiors:hideInteriorGUI", true)
addEventHandler("vehicle-interiors:hideInteriorGUI", getRootElement(), hideVehInteriorGUI)


function changeTexture(model)
	--outputDebugString("applying texture ("..tostring(model)..")")
	if(model == 577) then --AT-400
		local txd = engineLoadTXD("files/at400_interior.txd")
		engineImportTXD(txd,14548)
	elseif(model == 592) then --Andromada
		--restore
		local txd = engineLoadTXD("files/ab_cargo_int.txd")
		engineImportTXD(txd,14548)
	else
		--restore
		local txd = engineLoadTXD("files/ab_cargo_int.txd")
		engineImportTXD(txd,14548)
	end
end
addEvent("vehicle-interiors:changeTextures", true)
addEventHandler("vehicle-interiors:changeTextures", getRootElement(), changeTexture)

function fadeMessage(fadein)
	if gInteriorName then
		local alpha = guiGetAlpha(gInteriorName)

		if (fadein) and (alpha) then
			local newalpha = alpha + 0.05
			guiSetAlpha(gInteriorName, newalpha)
			guiSetAlpha(gOwnerName, newalpha)

			if(newalpha>=1.0) then
				timer = setTimer(hideIntName, 4000, 1)
			end
		elseif (alpha) then
			local newalpha = alpha - 0.05
			guiSetAlpha(gInteriorName, newalpha)
			guiSetAlpha(gOwnerName, newalpha)

			if (gBuyMessage) then
				guiSetAlpha(gBuyMessage, newalpha)
			end

			if(newalpha<=0.0) then
				destroyElement(gInteriorName)
				gInteriorName = nil

				destroyElement(gOwnerName)
				gOwnerName = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end


addEvent("vehicle-interiors.createCustomMarker", true)
addEventHandler("vehicle-interiors.createCustomMarker", resourceRoot,
	function(data)
		exports["custom_markers"]:createCustomMarker(unpack(data)) --, int[INTERIOR_OWNER], int[INTERIOR_DISABLED], int[INTERIOR_FACTION]
	end
)

addEvent("vehicle-interiors.deleteCustomMarker", true)
addEventHandler("vehicle-interiors.deleteCustomMarker", resourceRoot,
	function(data)
		triggerEvent("deleteCustomMarker", unpack(data))
	end
)