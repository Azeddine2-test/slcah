function getAdminTitles()
	return exports.integration:getAdminTitles()
end

function getAdmins(onduty)
	local players = exports.pool:getPoolElementsByType("player")
	local admins = {}
	for key, value in ipairs(players) do
		if exports.integration:isPlayerTrialAdmin(value, onduty) and getElementData(value, "loggedin") == 1 then
			table.insert(admins,value)
		end
	end
	return admins
end

function getPlayerAdminLevel(thePlayer)
	return (isElement( thePlayer ) and getElementData(thePlayer, "admin_level")) or 0
end

function getPlayerAdminTitle(thePlayer)
	if isElement(thePlayer) then
		if exports.integration:isPlayerTrialAdmin(thePlayer) then
			local adminTitles = getAdminTitles()
			local text = exports.integration:isPlayerOnlyLeadScripter(thePlayer) and "Lead Dév." or (adminTitles[getPlayerAdminLevel(thePlayer)] or "Player")

			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
			if (hiddenAdmin==1) then
				text = text .. " (Caché)"
			end

			return text
		elseif exports.integration:isPlayerSupporter(thePlayer) then
			return "Support"
		elseif exports.integration:isPlayerLeadScripter(thePlayer) then
			return "Lead Dév."
		elseif exports.integration:isPlayerScripter(thePlayer) then
			return "Développeur"
		elseif exports.integration:isPlayerTester(thePlayer) then
			return "Testeur"
		elseif exports.integration:isPlayerFMTLeader(thePlayer) then
			return "FMT Leader"
		elseif exports.integration:isPlayerFMTMember(thePlayer) then
			return "FMT Member"
		elseif exports.integration:isPlayerVehicleConsultant(thePlayer) then
			return "VCT Leader"
		elseif exports.integration:isPlayerVCTMember(thePlayer) then
			return "VCT Member"
		elseif exports.integration:isPlayerMappingTeamLeader(thePlayer) then
			return "MT Leader"
		elseif exports.integration:isPlayerMappingTeamMember(thePlayer) then
			return "MT Member"
		else
			return "Player"
		end
	end
end

--[[ GM ]]--
function getGameMasters(onduty)
	local players = exports.pool:getPoolElementsByType("player")
	local gameMasters = { }
	for key, value in ipairs(players) do
		if exports.integration:isPlayerSupporter(value, onduty) then
			table.insert(gameMasters, value)
		end
	end
	return gameMasters
end

--[[ /GM ]]--

local scripters = {
}

local lvl2scripters = {

}

local internalaffairs = {

}

function isPlayerLvl2Scripter(thePlayer)
	return lvl2scripters[thePlayer] or lvl2scripters[ getElementData(thePlayer, "account:username") or "nobody" ] or false
end

function isPlayerIA(thePlayer)
	return internalaffairs[thePlayer] or internalaffairs[ getElementData(thePlayer, "account:username") or "nobody" ] or false
end

function isPlayerScripter(thePlayer)
	return exports["integration"]:isPlayerScripter(thePlayer)
end

function getAdminTitle1(thePlayer)
	local adminTitles = getAdminTitles()
	local title = adminTitles[getPlayerAdminLevel(thePlayer)] or false
	local username = getElementData(thePlayer, "account:username")
	if not title then
		if exports.integration:isPlayerSupporter(thePlayer) then
			return "Support "..username
		else
			return "Player "..username
		end
	end
	if getElementData(thePlayer, "hiddenadmin") == 1 then
		return "Un administrateur"
	else
		return title.." "..username
	end
end

function isStaffOnDuty(thePlayer)
	return isAdminOnDuty(thePlayer) or isSupporterOnDuty(thePlayer)
end

function isStaff(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)
	else
		return false
	end
end

function isAdminOnDuty(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.integration:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "duty_admin") == 1)
	else
		return false
	end
end

function isSupporterOnDuty(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.integration:isPlayerSupporter(thePlayer) and (getElementData(thePlayer, "duty_supporter") == 1)
	else
		return false
	end
end
