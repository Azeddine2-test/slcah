-- Just shows a message
local sWidth,sHeight = guiGetScreenSize() 

local guiStep3 = {}
function startStep3(infoFromServer, canRetry)
	local info = {
		text = "Votre candidature n'a pas encore été traitée.\n\nMerci de votre patience.",
		r = 255,
		g = 255,
		b = 255,
	}
	
	destroyGUIPart3()
	if infoFromServer then
		info = infoFromServer
	end
	
	local line = 15
	-- local startY = sHeight*0.45
	local height = line*10
	local startY = sHeight*0.2
	local width = 800
	local startX = (sWidth-width)/2
	guiStep3.intro = guiCreateLabel(startX, startY, width, height, info.text, false )
	guiLabelSetColor(guiStep3.intro, info.r, info.g, info.b)
	guiLabelSetHorizontalAlign(guiStep3.intro, "center", true)
	guiLabelSetVerticalAlign(guiStep3.intro, "center", true)

	if canRetry then
		guiStep3.retry = guiCreateButton(startX, startY + height + 10, width, 30, "Réessayer", false)
		addEventHandler("onClientGUIClick", guiStep3.retry, function()
			guiSetEnabled(source, false)
			triggerServerEvent("apps:movePlayerBackToStep2", resourceRoot)
		end, false)
	end
end
addEvent("apps:startStep3", true)
addEventHandler("apps:startStep3", localPlayer, startStep3, false)

function destroyGUIPart3(finishedAppStage)
	for i, gui in pairs (guiStep3) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	guiStep3 = {}
	
	-- APP STAGE : OFF
	if (finishedAppStage == true) then
		showCursor(false)
		guiSetInputMode("allow_binds")
		fadeCamera(true, 0)
	end
end
addEvent("apps:destroyGUIPart3", true)
addEventHandler("apps:destroyGUIPart3", localPlayer, destroyGUIPart3, false)
