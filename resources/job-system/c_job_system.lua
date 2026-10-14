-- Nando 10/03/2023

local wEmployment = nil

function showEmploymentWindow()
	if isElement(wEmployment) then
		return
	end

	triggerServerEvent("onEmploymentServer", resourceRoot, false)

	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	wEmployment = guiCreateWindow(x, y, width, height, "Offres d'Emploi", false)

	local jobList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wEmployment)
	guiGridListAddColumn(jobList, "Titre du Job", 0.9)

	for jobID, v in pairsByKeys(CITY_HALL_JOBS) do
		if v.enabled and (v.showInMenu or v.showAsSpecialInMenu) then
			local row = guiGridListAddRow(jobList)
			guiGridListSetItemText(jobList, row, 1, v.name, false, false)
			guiGridListSetItemData(jobList, row, 1, jobID)

			if (v.showAsSpecialInMenu) then
				guiGridListSetItemColor(jobList, row, 1, 255, 255, 0)
			end
		end
	end

	local bAcceptJob = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Accepter", true, wEmployment)
	guiSetProperty(bAcceptJob, "NormalTextColour", "FF00FF00")
	local bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Annuler", true, wEmployment)

	local function acceptJob()
		local row, col = guiGridListGetSelectedItem(jobList)
		local job = getElementData(localPlayer, "job") or 0

		if (row==-1) or (col==-1) then
			exports["srp_notifs"]:add("Veuillez sélectionner un job.", "error")
		else
			local selJob = tonumber(guiGridListGetItemData(jobList, row, 1))
			local jobName = guiGridListGetItemText(jobList, row, 1)
			local jobInfo = CITY_HALL_JOBS[selJob]
			if jobInfo.showAsSpecialInMenu then
				exports["srp_notifs"]:add("Ce job ne peut être obtenu que sous certaines conditions.\nConsultez le guide sur F1.", "error")
				return
			end
			if (getElementData(localPlayer, "job") or 0) > 0 then
				exports["srp_notifs"]:add("Vous êtes déjà employé, veuillez d'abord quitter votre autre emploi (( /quitterjob )).", "error")
				return
			end
			if jobInfo.requireDriversLicense and (getElementData(localPlayer, "license.car") ~= 1) then
				exports["srp_notifs"]:add("Vous avez besoin du permis de conduire.", "error")
				return
			end
			if jobInfo.requireBikeLicense and (getElementData(localPlayer, "license.bike") ~= 1) then
				exports["srp_notifs"]:add("Vous avez besoin du permis de moto.", "error")
				return
			end

			closeJobWindow()
			triggerServerEvent("acceptJob", resourceRoot, selJob)
		end
	end

	addEventHandler("onClientGUIClick", bAcceptJob, acceptJob, false)
	addEventHandler("onClientGUIDoubleClick", jobList, acceptJob, false)

	addEventHandler("onClientGUIClick", bCancel, closeJobWindow, false)
end
addEvent("onEmployment", true)
addEventHandler("onEmployment", getRootElement(), showEmploymentWindow)

function closeJobWindow()
	if isElement(wEmployment) then
		destroyElement(wEmployment)
	end
end

local function showJobMessage(job, notext)
	job = tonumber(job) or -1

	if (job==2) then -- TAXI
		displayTaxiJob(notext)
	else
		resetTaxiJob()
	end
	
	if (job==3) then -- BUS
		displayBusJob(notext)
	else
		resetBusJob()
	end

	if (job==4) then -- SWEEPER
		displayNettoyeur(notext)
	else
		stopNettoyeurJob()
	end

	if (job==5) then -- MECHANIC
		displayMechanicJob(notext)
	end

	if (job==8) then -- GARBAGE
		displayGarbage(notext)
	else
		stopGarbage()
	end
	
	if (job==9) then -- GARBAGE
		displayPizzaDeliveryJob(notext)
	else
		stopPizzaDeliveryJob()
	end
end
addEvent("showJob", true)
addEventHandler("showJob", localPlayer, showJobMessage, false)

function quitJob(job)
	job = tonumber(job) or -1
	local jobInfo = CITY_HALL_JOBS[job]
	if not jobInfo then
		return
	end
	exports["srp_notifs"]:add("Vous avez quitté votre job de "..(jobInfo.name)..".", "success")

	if (job==2) then -- TAXI JOB
		resetTaxiJob()
	elseif (job==3) then -- BUS JOB
		resetBusJob()
	elseif (job==4) then -- SWEEPER
		stopNettoyeurJob()
	elseif (job==5) then -- MECHANIC
		closeMechanicWindow()
	elseif (job==8) then -- GARBAGE
		stopGarbage()
	elseif (job==9) then -- PIZZA
		stopPizzaDeliveryJob()
	end
end
addEvent("quitJob", true)
addEventHandler("quitJob", localPlayer, quitJob)
