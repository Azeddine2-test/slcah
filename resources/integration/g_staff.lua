

adminTitles = {
	[1] = "Modérateur", -- isPlayerTrialAdmin
	[2] = "Administrateur I", -- isPlayerAdmin
	[3] = "Administrateur II", -- isPlayerSeniorAdmin
	[3.5] = "Administrateur III", -- isPlayerSuperAdmin
	[4] = "Manager", -- isPlayerLeadAdmin
	[5] = "CEO", -- isPlayerHeadAdmin
}

function isPlayerHeadAdmin(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_admin') ~= 1 then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 5) or (isPlayerOnlyLeadScripter(player))
end

function isPlayerLeadAdmin(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_admin') ~= 1 then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 4) or (isPlayerOnlyLeadScripter(player))
end

function isPlayerSuperAdmin(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_admin') ~= 1 then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 3.5) or (isPlayerOnlyLeadScripter(player))
end

function isPlayerSeniorAdmin(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_admin') ~= 1 then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 3) or (isPlayerOnlyLeadScripter(player))
end

function isPlayerAdmin(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_admin') ~= 1 then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 2) or (isPlayerOnlyLeadScripter(player))
end

function isPlayerTrialAdmin(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_admin') ~= 1 then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 1) or (isPlayerOnlyLeadScripter(player))
end



function isPlayerSupporter(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_supporter') ~= 1 then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 1)
end

function isPlayerSupportManager(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if duty_required and getElementData(player, 'duty_supporter') ~= 1 then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 2)
end

function isPlayerTester(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 1)
end

function isPlayerScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 2)
end

function isPlayerLeadScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 3)
end 

function isPlayerOnlyLeadScripter(player)
	--> Check: Player
	if not player and not isElement(player) or not getElementType(player) == 'player' then return; end;

	--> Variable(s)
	local scripter_level = getElementData(player, "scripter_level") or 0;
	local admin_level = getElementData(player, "admin_level") or 0;

	--> Return(s)
	return (scripter_level >= 3) and (admin_level < 1);
end;

--LEADER
function isPlayerVehicleConsultant(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	if getElementData(player, "hasVctAdmin") then
		return true
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 2)
end

--MEMBERS
function isPlayerVCTMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 1)
end

--LEADER
function isPlayerMappingTeamLeader(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 2)
end

--MEMBERS
function isPlayerMappingTeamMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 1)
end

function isPlayerFMTMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local fmt_level = getElementData(player, "fmt_level") or 0
	return (fmt_level >= 1)
end

function isPlayerFMTLeader(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local fmt_level = getElementData(player, "fmt_level") or 0
	return (fmt_level >= 2)
end

function isPlayerStaff(player, duty_required)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return 	isPlayerTrialAdmin(player, duty_required)
	or		isPlayerSupporter(player, duty_required)
	or 		isPlayerScripter(player)
	or 		isPlayerVCTMember(player)
	or 		isPlayerMappingTeamMember(player)
	or      isPlayerFMTMember(player)
end

-- internal affairs unused
function isPlayerIA( player )
	return false
end

function getAdminTitles()
	return adminTitles
end
