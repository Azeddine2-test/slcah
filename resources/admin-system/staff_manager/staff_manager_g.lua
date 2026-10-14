--MAXIME / 2015.1.8

function canPlayerAccessStaffManager(player)
	return exports.integration:isPlayerSeniorAdmin(player) or exports.integration:isPlayerLeadScripter(player)
end
	