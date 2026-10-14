-- MAXIME / 2015.1.31

function getPlayerNameFirstLast(player)
	local name = exports.global:getPlayerName(player)
	local parts = exports.global:explode(" ", name)
	return parts[1], parts[#parts]
end

function isTowingCompany(dep)
	if dep == "TC1" then
		return true
	elseif dep == "TC2" then
		return true
	end
	
	return false
end
