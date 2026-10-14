
function toggleEngine( )
	local veh = getPedOccupiedVehicle( localPlayer )
	if veh and getElementData( localPlayer, "realinvehicle" ) == 1 then
		if getPedOccupiedVehicleSeat( localPlayer ) == 0 then
			if not enginelessVehicle[ getElementModel( veh ) ] then
				if getVehicleEngineState( veh ) then
					setVehicleEngineState( veh, false ) -- client side, need to do once more on server to sync.
					triggerServerEvent( 'vehicle:engine:stop', resourceRoot, veh )
					toggleControl( 'accelerate', false )
					toggleControl( 'brake_reverse', false )
				else
					triggerServerEvent( 'vehicle:engine:start', resourceRoot, exports.global:getNearbyElements( veh, 'player' ), veh )
				end
			end
		end
	end
end
addEvent( 'vehicle:toggleEngine', false )
addEventHandler( 'vehicle:toggleEngine', root, toggleEngine )

addEventHandler( 'onClientResourceStart', resourceRoot, function()
	bindKey( "j", "down", toggleEngine )
end)

-- Disable engine and vehicle control state as soon as player starts getting in or get in vehicles. Because by default in GTA, vehicle get started automatically when player gets in.
-- Disable them first then enable them from server as soon as possible.
addEventHandler( 'onClientVehicleStartEnter', root, function( player, seat, door )
	if player == localPlayer and seat == 0 then
		if enginelessVehicle[ getElementModel(source) ] then
			toggleControl( 'accelerate', true )
			toggleControl( 'brake_reverse', true )
		else
			toggleControl( 'accelerate', false )
			toggleControl( 'brake_reverse', false )
		end
	end
end)

addEventHandler( 'onClientVehicleEnter', root, function( player , seat )
	if player == localPlayer and seat == 0 and not enginelessVehicle[ getElementModel(source) ] then
		setVehicleEngineState( source, false )
	end
end)
