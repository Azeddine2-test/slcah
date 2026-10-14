-- Nando 06/03/2023

--[[
	Organised job IDs

	enabled: players can have this job. If disabled, any players with this job will be forced unemployed
	showInMenu: job will be listed in the jobs city hall menu
	showAsSpecialInMenu: job will be listed in menu but a message pops up if you try to obtain it
	requireDriversLicense: can only take the job if you have a valid drivers license
	requireBikeLicense: can only take the job if you have a valid bike license

]]
CITY_HALL_JOBS = {
    --[[
	[1] = {
		enabled = true,
		showInMenu = true,
		requireDriversLicense = true,
		name = "Livreur", hasVehicles = true, preventEnter = true,
	},
    ]]
	[2] = {
		enabled = true,
		showInMenu = true,
		requireDriversLicense = true,
		name = "Chauffeur Taxi", hasVehicles = true, preventEnter = true,
	},
	[3] = {
		enabled = true,
		showInMenu = true,
		requireDriversLicense = true,
		name = "Chauffeur Bus", hasVehicles = true, preventEnter = true,
	},
	[4] = {
		enabled = true,
		showInMenu = true,
		name = "Nettoyeur", hasVehicles = true, preventEnter = true,
	},
	[5] = {
		enabled = false,
		showAsSpecialInMenu = true,
		name = "Mécanicien", hasVehicles = false,
	},
	[6] = {
		enabled = false,
		name = "Serrurier", hasVehicles = false,
	},
	[7] = {
		enabled = false,
		requireDriversLicense = true,
		name = "Chauffeur Poids Lourd", hasVehicles = true, preventEnter = true,
	},
	[8] = {
		enabled = false,
		showInMenu = true,
		requireDriversLicense = true,
		name = "Eboueur", hasVehicles = true, preventEnter = true,
	},
	-- Désactiver "smowg"
	[9] = {
		enabled = false,
		showInMenu = false,
		name = "Livreur Pizza", hasVehicles = true, preventEnter = true,
	},
}

function getJobTitleFromID(jobID)
	jobID = tonumber(jobID) or 0
	local jobInfo = CITY_HALL_JOBS[jobID]
	if jobInfo then
		return jobInfo.name
	end
	return false
end

function pairsByKeys(t)
	local a = {}
	for n in pairs(t) do
		table.insert(a, n)
	end
	table.sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end
