--//Chaos
-- Fuck you Chaos, why overcomplicate this - Nando 25/03/2023

-- dont change
reportTypes = {
	[1] = {"Question Générale", { "admin", "support" }, "SUP", 82, 255, 110, "Si vous avez besoin d'aide." },
	[2] = {"Problème avec un Joueur", { "admin" }, "ADM", 255, 115, 115, "Si vous avez eu un soucis avec un joueur." },
}

function getReportTypes( type )
	return type and reportTypes[type] or reportTypes
end

function getReportInfo(row)
	
	local staff
	if reportTypes[tonumber(row)] then
		staff = reportTypes[tonumber(row)][2]
	else
		row = 1
		staff = reportTypes[1][2]
	end

	local name = reportTypes[row][1]
	local abrv = reportTypes[row][3]
	local red = reportTypes[row][4]
	local green = reportTypes[row][5]
	local blue = reportTypes[row][6]
	
	return staff, name, abrv, red, green, blue
end

function isSupporterReport(row)
	if not reportTypes[row] then return false end
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if v == "support" then
			return true
		end
	end
	return false
end

function isAdminReport(row)
	if not reportTypes[row] then return false end
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if v == "admin" then
			return true
		end
	end
	return false
end

function showExternalReportBox(thePlayer)
	if not isElement(thePlayer) then return false end
	return (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer))
	and (getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3")
end