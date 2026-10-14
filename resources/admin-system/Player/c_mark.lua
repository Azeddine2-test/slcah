local marks = { }
local default = false
local localPlayer = getLocalPlayer( )

function saveMarks( )
	local xml = xmlCreateFile( "Player/mark.xml", "marks" )
	local function saveNode( data, name )
		if #data >= 5 then
			local xml = xmlCreateChild( xml, "mark" )
			if name then
				xmlNodeSetValue( xml, name )
			end
			xmlNodeSetAttribute( xml, "x", data[1] )
			xmlNodeSetAttribute( xml, "y", data[2] )
			xmlNodeSetAttribute( xml, "z", data[3] )
			xmlNodeSetAttribute( xml, "interior", data[4] )
			xmlNodeSetAttribute( xml, "dimension", data[5] )
		end
	end
	if default then
		saveNode( default )
	end
	for key, value in pairs( marks ) do
		saveNode( value, key )
	end
	xmlSaveFile( xml )
	xmlUnloadFile( xml )
end

addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		local xml = xmlLoadFile( "Player/mark.xml" )
		if xml then
			for key, value in ipairs( xmlNodeGetChildren( xml ) ) do
				local name = xmlNodeGetValue( value )
				if name and #name == 0 then
					name = false
				end
				
				local data = { tonumber( xmlNodeGetAttribute( value, "x" ) ), tonumber( xmlNodeGetAttribute( value, "y" ) ), tonumber( xmlNodeGetAttribute( value, "z" ) ), tonumber( xmlNodeGetAttribute( value, "interior" ) ), tonumber( xmlNodeGetAttribute( value, "dimension" ) ), name }
				if not name then
					default = data
				else
					marks[ name ] = data
				end
			end
			xmlUnloadFile( xml )
		end
	end
)

addCommandHandler( "mark",
	function( commandName, ... )
		if exports.integration:isPlayerAdmin( localPlayer )  or exports.integration:isPlayerVehicleConsultant( localPlayer ) or exports.integration:isPlayerMappingTeamMember( localPlayer ) or exports.integration:isPlayerScripter(localPlayer) then
			-- store the mark
			local name = ( ... ) and table.concat( { ... }, " " ):lower( )
			local x, y, z = getElementPosition( localPlayer )
			local interior = getElementInterior( localPlayer )
			local dimension = getElementDimension( localPlayer )
			local data = { x, y, z, interior, dimension, name }
			if not name then
				default = data
			else
				marks[ name ] = data
			end
			
			-- save in the xml
			saveMarks( )
			
			-- success message
			outputChatBox( "[ADMIN] Votre marque "..( name and "'" .. name .. "' " or "par défaut " ).."a été définie avec succès.", 242, 151, 65 )
		end
	end
)

addCommandHandler( "gotomark",
	function( commandName, ... )
		if exports.integration:isPlayerAdmin( localPlayer )  or exports.integration:isPlayerVehicleConsultant( localPlayer ) or exports.integration:isPlayerMappingTeamMember( localPlayer ) or exports.integration:isPlayerScripter(localPlayer) then
			-- store the mark
			local name = ( ... ) and table.concat( { ... }, " " ):lower( )
			if not name then
				if default then
					triggerServerEvent( "gotoMark", localPlayer, unpack( default ) )
				else
					outputChatBox("Erreur: Veuillez placer une marque avec /mark.", 252, 106, 104)
				end
			else
				if marks[ name ] then
					triggerServerEvent( "gotoMark", localPlayer, unpack( marks[ name ] ) )
				else
					outputChatBox("Erreur: Veuillez placer cette marque avec /mark "..name..".", 252, 106, 104)
				end
			end
		end
	end
)

addCommandHandler( "marks",
	function( commandName )
		local count = 1
		if default then
			outputChatBox( "  #" .. count .. ": (par défaut)", 255, 255, 0 )
			count = count + 1
		end
		
		for key, value in pairs( marks ) do
			outputChatBox( "  #" .. count .. ": " .. key, 255, 255, 0 )
			count = count + 1
		end
	end
)

addCommandHandler( "delmark",
	function( commandName, ... )
		if exports.integration:isPlayerAdmin( localPlayer ) or exports.integration:isPlayerVCTMember( localPlayer ) or exports.integration:isPlayerMappingTeamMember( localPlayer ) or exports.integration:isPlayerScripter(localPlayer)  then
			-- store the mark
			local name = ( ... ) and table.concat( { ... }, " " ):lower( )
			if not name then
				if default then
					default = false
					outputChatBox("[ADMIN] Votre marque par défaut a été supprimée.", 242, 151, 65 )
					saveMarks( )
				else
					outputChatBox("Erreur: Veuillez placer une marque avec /mark.", 252, 106, 104 )
				end
			else
				if marks[ name ] then
					marks[ name ] = nil
					outputChatBox( "[ADMIN] Votre marque '" .. name .. "' a été supprimée.", 242, 151, 65 )
					saveMarks( )
				else
					outputChatBox( "Erreur: Veuillez placer cette marque avec /mark " .. name .. ".", 252, 106, 104 )
				end
			end
		end
	end
)
