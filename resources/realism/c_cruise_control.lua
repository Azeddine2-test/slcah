
local ccEnabled = false
local theVehicle = nil
local targetSpeed = 0

function doCruiseControl()
    if not isElement(theVehicle) or not getVehicleEngineState(theVehicle) then
        deactivateCruiseControl()
        return false
    end
    local x,y = angle(theVehicle)
    if (x < 5) then
        local targetSpeedTmp = getElementSpeed(theVehicle)
        if (targetSpeedTmp > targetSpeed) then
            setPedControlState(localPlayer, "accelerate",false)
        elseif (targetSpeedTmp < targetSpeed) then
            setPedControlState(localPlayer, "accelerate",true)
        end
    end
end

function activateCruiseControl()
    addEventHandler("onClientRender", getRootElement(), doCruiseControl)
    ccEnabled = true
    bindMe()
end

function deactivateCruiseControl()
    removeEventHandler("onClientRender", getRootElement(), doCruiseControl)
    setPedControlState(localPlayer, "accelerate",false)
    ccEnabled = false
    exports.hud:sendBottomNotification(localPlayer, "Régulateur", "Régulateur désactivé.")
end

function applyCruiseControl()
	theVehicle = getPedOccupiedVehicle( getLocalPlayer() )
	if (theVehicle) then
		if exports.global:getVehicleType(theVehicle) == "Helicopter" then return end
		
		if (getVehicleOccupant(theVehicle) == getLocalPlayer()) then
			if (getVehicleEngineState ( theVehicle ) == true) then
				if (ccEnabled) then
					deactivateCruiseControl()
				else
					targetSpeed = getElementSpeed(theVehicle)
					if targetSpeed > 10 then
						if (exports.global:getVehicleType(theVehicle) == "Automobile" or exports.global:getVehicleType(theVehicle) == "Bike" or exports.global:getVehicleType(theVehicle) =="Boat" or exports.global:getVehicleType(theVehicle) == "Train" or exports.global:getVehicleType(theVehicle) == "Plane" or exports.global:getVehicleType(theVehicle) == "Helicopter") then
							exports.hud:sendBottomNotification(localPlayer, "Régulateur Activé", "Utilisez - et + pour ajuster la vitesse.")
							activateCruiseControl()
						end
					else
                        exports.hud:sendBottomNotification(localPlayer, "Cruise Control", "Cruise Control can be used for maintaining speed, not pulling up.")
					end
				end
            else
                exports.hud:sendBottomNotification(localPlayer, "Cruise Control", "The engine is not turned on!")
			end
		end
	end
end
addEvent("realism:togCc", true)
addEventHandler("realism:togCc", root, applyCruiseControl)

addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), function(veh, seat)
    if (seat==0) then
        if (ccEnabled) then
            deactivateCruiseControl()
        end
    end
end)

function increaseCruiseControl()
    if (ccEnabled) then
        targetSpeed = targetSpeed + 5
        
        local tV = getPedOccupiedVehicle(getLocalPlayer()) 
        if (tV) then
            local maxSpeed = limitSpeed[getElementModel(tV)]
            if maxSpeed then 
                if targetSpeed > maxSpeed then
                    targetSpeed = maxSpeed
                end
            end
        end 
    end
end


function decreaseCruiseControl()
    if (ccEnabled) then
        targetSpeed = targetSpeed - 5
    end
end


function startAccel()
    if (ccEnabled) then
        deactivateCruiseControl()
    end
end


function stopAccel()
    if (ccEnabled) then
        deactivateCruiseControl()
    end
end


function restrictBikes(manual) 
    local tV = getPedOccupiedVehicle(getLocalPlayer()) 
    if (tV) then
        local maxSpeed = limitSpeed[getElementModel(tV)]
        if maxSpeed then 
            tS = getVehicleVelocity(tV) 
            if tS > maxSpeed then 
                toggleControl("accelerate",false) 
            else 
                toggleControl("accelerate", true) 
            end 
        end
    end 
end


function bindMe()
    bindKey("brake_reverse", "down", stopAccel)
    bindKey("accelerate", "down", startAccel)
end

    function loadMe( startedRes )
        bindKey("-", "down", decreaseCruiseControl)
        bindKey("num_sub", "down", decreaseCruiseControl)
        
        bindKey("=", "down", increaseCruiseControl)
        bindKey("num_add", "down", increaseCruiseControl)
        
        addCommandHandler("cc", applyCruiseControl)
        addCommandHandler("cruisecontrol", applyCruiseControl)
        bindMe()
    end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()) , loadMe)

function isCcEnabled()
    return ccEnabled
end

function resourceStart()
	bindKey("c", "down", function()
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		applyCruiseControl()
	end) 
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStart)