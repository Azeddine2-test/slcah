
local sWidth,sHeight = guiGetScreenSize() 

local guiStep2 = {}
local quests_p2 = {}
local q2 = {}
local PART2_TEXT = "Veuillez répondre aux questions suivantes. Votre candidature sera analisée par un membre du staff."
function startStep2(questsFromServer, lastRejectedReason)
	local theText = PART2_TEXT
	if lastRejectedReason then
		theText = "Motif de refus de votre dernière candidature: "..lastRejectedReason
	end

	quests_p2 = questsFromServer
	
	local line = 15
	-- local startY = sHeight*0.45
	local startY = sHeight*0.2
	local width = 800
	local startX = (sWidth-width)/2
	local panelH = 130
	local panelW = width/2
	local margin = 35
	guiStep2.intro = guiCreateLabel(startX, startY, width, line*2, theText, false )
	guiLabelSetHorizontalAlign(guiStep2.intro, "center", true)
	guiLabelSetColor(guiStep2.intro, 255,255,55)

	startX = startX-10
	startY = startY+10
	--col 1 row 1
	guiStep2.q1 = guiCreateScrollPane(startX, startY+line*3, panelW, panelH, false )
	guiStep2.q11 = guiCreateLabel(0, 0, panelW, line*2, (quests_p2[1] or "-"), false, guiStep2.q1 )
	guiSetFont(guiStep2.q11, "default-bold-small")
	guiLabelSetHorizontalAlign(guiStep2.q11, "left", true)
	guiLabelSetVerticalAlign(guiStep2.q11, "center", true)
	q2[1] = guiCreateMemo(0, line*2, panelW, line*6, "", false, guiStep2.q1 )
	
	--col 1 row 2
	guiStep2.q2 = guiCreateScrollPane(startX, startY+line*3+panelH, panelW, panelH, false )
	guiStep2.q22 = guiCreateLabel(0, 0, panelW, line*2, (quests_p2[2] or "-"), false, guiStep2.q2 )
	guiSetFont(guiStep2.q22, "default-bold-small")
	guiLabelSetHorizontalAlign(guiStep2.q22, "left", true)
	guiLabelSetVerticalAlign(guiStep2.q22, "center", true)
	q2[2] = guiCreateMemo(0, line*2, panelW, line*6, "", false, guiStep2.q2 )
	
	--col 2 row 1
	guiStep2.q3 = guiCreateScrollPane(startX+panelW+margin, startY+line*3, panelW, panelH, false )
	guiStep2.q33 = guiCreateLabel(0, 0, panelW, line*2, (quests_p2[3] or "-"), false, guiStep2.q3 )
	guiSetFont(guiStep2.q33, "default-bold-small")
	guiLabelSetHorizontalAlign(guiStep2.q33, "left", true)
	guiLabelSetVerticalAlign(guiStep2.q33, "center", true)
	q2[3] = guiCreateMemo(0, line*2, panelW, line*6, "", false, guiStep2.q3 )
	
	--col 2 row 2
	guiStep2.q4 = guiCreateScrollPane(startX+panelW+margin, startY+line*3+panelH, panelW, panelH, false )
	guiStep2.q44 = guiCreateLabel(0, 0, panelW, line*2, (quests_p2[4] or "-"), false, guiStep2.q4 )
	guiSetFont(guiStep2.q44, "default-bold-small")
	guiLabelSetHorizontalAlign(guiStep2.q44, "left", true)
	guiLabelSetVerticalAlign(guiStep2.q44, "center", true)
	q2[4] = guiCreateMemo(0, line*2, panelW, line*6, "", false, guiStep2.q4 )
	
	local bW, bH = 120, 30
	local bX = (sWidth-bW)/2
	local bY = startY+line*4+panelH*2
	
	guiStep2.next = guiCreateButton ( bX, bY, bW, bH, "Soumettre", false)
	guiSetProperty(guiStep2.next, "NormalTextColour", "FF00FF00")

	addEventHandler ( "onClientGUIClick", guiStep2.next, validateApp, false)
	addEventHandler ( "onClientGUIChanged", q2[1], resetNoti, false)
	addEventHandler ( "onClientGUIChanged", q2[2], resetNoti, false)	
	addEventHandler ( "onClientGUIChanged", q2[3], resetNoti, false)
	addEventHandler ( "onClientGUIChanged", q2[4], resetNoti, false)
end
addEvent("apps:startStep2", true)
addEventHandler("apps:startStep2", localPlayer, startStep2, false)

function validateApp()
	local quest1 = string.len(guiGetText(q2[1]))
	local quest2 = string.len(guiGetText(q2[2]))
	local quest3 = string.len(guiGetText(q2[3]))
	local quest4 = string.len(guiGetText(q2[4]))
	
	if quest1==0 or quest2==0 or quest3==0 or quest4==0 then
		guiSetText(guiStep2.intro, "Vous n'avez pas répondu à toutes les questions.")
		guiLabelSetColor(guiStep2.intro, 255,0,0)
		return
	end

	local MIN_CHARS = 20
	if quest1<MIN_CHARS or quest2<MIN_CHARS or quest3<MIN_CHARS or quest4<MIN_CHARS then
		guiSetText(guiStep2.intro, "Un minimum de "..MIN_CHARS.." caractères est requis pour chaque réponse.")
		guiLabelSetColor(guiStep2.intro, 255,0,0)
		return
	end

	guiSetText(guiStep2.intro, "Veuillez patienter...")
	guiLabelSetColor(guiStep2.intro, 0,255,0)
	guiSetEnabled(guiStep2.next, false)
	guiSetEnabled(guiStep2.q1, false)
	guiSetEnabled(guiStep2.q2, false)
	guiSetEnabled(guiStep2.q3, false)
	guiSetEnabled(guiStep2.q4, false)
	setTimer(function()
		triggerServerEvent("apps:processPart2", root, quests_p2, {guiGetText(q2[1]), guiGetText(q2[2]), guiGetText(q2[3]), guiGetText(q2[4])})
		destroyGUIPart2()
	end, 3000, 1)
end

function resetNoti()
	if guiStep2.intro and isElement(guiStep2.intro) and guiGetVisible(guiStep2.intro) then
		guiSetText(guiStep2.intro, PART2_TEXT)
		guiLabelSetColor(guiStep2.intro, 255,255,55)
	end
end

function destroyGUIPart2()
	for i, gui in pairs (guiStep2) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	guiStep2 = {}
end