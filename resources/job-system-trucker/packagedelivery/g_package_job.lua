deliveryCompanyName = "RS Haul"

function isPackageVehicle(theVehicle, thePlayer)
	if theVehicle and thePlayer then
		if getElementData(thePlayer, "job") == 1 and getElementData(theVehicle, "job") == 101 then
			return true, "job"
		end
	end
	return false
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end