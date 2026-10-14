pizzaCompany = "WS Pizza Co."

function isPizzaVehicle(theBike, thePlayer)
	if theBike then
		if getElementData(thePlayer, "job") == 9 and getElementData(theBike, "job") == 9 then
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