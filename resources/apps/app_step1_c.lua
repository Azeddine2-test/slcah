

addEvent("apps:beginApplication", true)

local sWidth,sHeight = guiGetScreenSize() 

local function beginApplicationStage()
	-- APP STAGE : ON
	showCursor(true)
	guiSetInputMode("no_binds_when_editing")
	fadeCamera(false, 0)
	playSoundFrontEnd(13)
end
addEventHandler("apps:beginApplication", localPlayer, beginApplicationStage, false)

local COLOR_SEL = "FF00FF00"
local COLOR_UNSEL = "FFFFFFFF"

local guiStep1 = {}
local q = {{},{},{},{},{},{}}
local result = {}
local quests = {}
local timer = nil
function startStep1(quests1, lastRejectedReason)
	local WELCOME_TEXT = "Un administrateur a jugé que vous ne respectiez pas certaines règles essentielles au RP. C'est pourquoi vous devez remplir ce questionnaire afin de pouvoir revenir sur le serveur."
	if lastRejectedReason then
		WELCOME_TEXT = "Motif de refus de votre dernière candidature: "..lastRejectedReason
	end
	
	quests = quests1
	
	local line = 15
	-- local startY = sHeight*0.45
	local startY = sHeight*0.2
	local width = 800
	local startX = (sWidth-width)/2
	local panelH = 80
	local panelW = width/2
	local margin = 30
	guiStep1.intro = guiCreateLabel(startX, startY, width, line*2, WELCOME_TEXT, false )
	guiLabelSetHorizontalAlign(guiStep1.intro, "center", true)
	guiLabelSetColor(guiStep1.intro, 255, 255, 55)
	startX = startX +20
	startY = startY +20
	--col 1 row 1
	guiStep1.q1 = guiCreateScrollPane(startX, startY+line*3, panelW, panelH, false )
	guiStep1.q11 = guiCreateLabel(0, 0, panelW, line, (quests[1].question or "-"), false, guiStep1.q1 )
	guiSetFont(guiStep1.q11, "default-bold-small")
	q[1][1] = guiCreateRadioButton(0, line, panelW, line, (quests[1].answer1 or "-"), false, guiStep1.q1 )
	q[1][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[1].answer2 or "-"), false, guiStep1.q1 )
	q[1][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[1].answer3 or "-"), false, guiStep1.q1 )
	--col 1 row 2
	guiStep1.q2 = guiCreateScrollPane(startX, startY+line*3+panelH, panelW, panelH, false )
	guiStep1.q22 = guiCreateLabel(0, 0, panelW, line, (quests[2].question or "-"), false, guiStep1.q2 )
	guiSetFont(guiStep1.q22, "default-bold-small")
	q[2][1] = guiCreateRadioButton(0, line, panelW, line, (quests[2].answer1 or "-"), false, guiStep1.q2 )
	q[2][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[2].answer2 or "-"), false, guiStep1.q2 )
	q[2][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[2].answer3 or "-"), false, guiStep1.q2 )
	--col 1 row 3
	guiStep1.q3 = guiCreateScrollPane(startX, startY+line*3+panelH*2, panelW, panelH, false )
	guiStep1.q33 = guiCreateLabel(0, 0, panelW, line, (quests[3].question or "-"), false, guiStep1.q3 )
	guiSetFont(guiStep1.q33, "default-bold-small")
	q[3][1] = guiCreateRadioButton(0, line, panelW, line, (quests[3].answer1 or "-"), false, guiStep1.q3 )
	q[3][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[3].answer2 or "-"), false, guiStep1.q3 )
	q[3][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[3].answer3 or "-"), false, guiStep1.q3 )
	--col 2 row 1
	guiStep1.q4 = guiCreateScrollPane(startX+panelW+margin, startY+line*3, panelW, panelH, false )
	guiStep1.q44 = guiCreateLabel(0, 0, panelW, line, (quests[4].question or "-"), false, guiStep1.q4 )
	guiSetFont(guiStep1.q44, "default-bold-small")
	q[4][1] = guiCreateRadioButton(0, line, panelW, line, (quests[4].answer1 or "-"), false, guiStep1.q4 )
	q[4][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[4].answer2 or "-"), false, guiStep1.q4 )
	q[4][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[4].answer3 or "-"), false, guiStep1.q4 )
	--col 2 row 2
	guiStep1.q5 = guiCreateScrollPane(startX+panelW+margin, startY+line*3+panelH, panelW, panelH, false )
	guiStep1.q55 = guiCreateLabel(0, 0, panelW, line, (quests[5].question or "-"), false, guiStep1.q5 )
	guiSetFont(guiStep1.q55, "default-bold-small")
	q[5][1] = guiCreateRadioButton(0, line, panelW, line, (quests[5].answer1 or "-"), false, guiStep1.q5 )
	q[5][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[5].answer2 or "-"), false, guiStep1.q5 )
	q[5][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[5].answer3 or "-"), false, guiStep1.q5 )
	--col 2 row 3
	guiStep1.q6 = guiCreateScrollPane(startX+panelW+margin, startY+line*3+panelH*2, panelW, panelH, false )
	guiStep1.q66 = guiCreateLabel(0, 0, panelW, line, (quests[6].question or "-"), false, guiStep1.q6 )
	guiSetFont(guiStep1.q66, "default-bold-small")
	q[6][1] = guiCreateRadioButton(0, line, panelW, line, (quests[6].answer1 or "-"), false, guiStep1.q6 )
	q[6][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[6].answer2 or "-"), false, guiStep1.q6 )
	q[6][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[6].answer3 or "-"), false, guiStep1.q6 )
	
	local bW, bH = 120, 30
	local bX = (sWidth-bW)/2
	local bY = startY+line*4+panelH*3
	
	guiStep1.next = guiCreateButton ( bX, bY, bW, bH, "Confirmer", false)
	guiSetProperty(guiStep1.next, "NormalTextColour", "FF00FF00")
	guiSetEnabled(guiStep1.next, false)

	-- guiStep1.retest = guiCreateButton ( bX, bY, bW, bH, "Recommencer", false)
	-- guiSetProperty(guiStep1.retest, "NormalTextColour", "FFFFFF00")
	-- guiSetVisible(guiStep1.retest, false)

	addEventHandler ( "onClientGUIClick", root, clickOnApplication)
	
	for i = 1, 6 do
		for k = 1, 3 do
			guiSetProperty( q[i][k], "HoverTextColour", "FFFFFF00") 
		end
	end
end
addEvent("apps:step1", true)
addEventHandler("apps:step1", localPlayer, startStep1, false)

function clickOnApplication()
	if source == guiStep1.next then
		local corrects, incorrects = 0, 0
		for i = 1, 6 do 
			if quests[i].key == getAnswerFromRadio(q[i]) then
				corrects = corrects + 1
			else
				print("incorrect: "..i)
				incorrects = incorrects + 1
			end
		end
		if incorrects > 0 then
			playSoundFrontEnd(4)
			guiSetText(guiStep1.intro, "Oups ! "..(incorrects < 6 and (incorrects .. " de vos réponses") or "Toutes vos réponses").." "..(incorrects <= 1 and "est incorrecte" or "sont incorrectes")..". "..(corrects < 1 and "Aucune" or ("Seulement "..corrects)).." "..(corrects == 1 and "est correcte" or "sont correctes")..". Veuillez changer vos réponses.")
			guiLabelSetColor ( guiStep1.intro, 255, 55, 55 )
			-- guiSetVisible(guiStep1.retest, true)
			-- guiSetVisible(guiStep1.next, false)
		else
			playSoundFrontEnd(6)
			guiSetText(guiStep1.intro, "Bravo ! Vous avez passé la première partie du test. Vous allez être redirigé vers la partie suivante ...")
			guiLabelSetColor ( guiStep1.intro, 0,255,0 )
			-- guiSetEnabled(guiStep1.retest, false)
			guiSetEnabled(guiStep1.next, false)
			guiSetEnabled(guiStep1.q1, false)
			guiSetEnabled(guiStep1.q2, false)
			guiSetEnabled(guiStep1.q3, false)
			guiSetEnabled(guiStep1.q4, false)
			guiSetEnabled(guiStep1.q5, false)
			guiSetEnabled(guiStep1.q6, false)
			
			killTimer1()
			timer = setTimer(function()
				destroyGUIPart(guiStep1)
				triggerServerEvent("apps:finishStep1", root, localPlayer)
			end, 5000, 1)
		end
	-- elseif source == guiStep1.retest then
	-- 	killTimer1()
	-- 	destroyGUIPart(guiStep1)
	-- 	triggerServerEvent("apps:startStep1", root, localPlayer)
	else
		if guiStep1.intro and isElement(guiStep1.intro) and guiGetVisible(guiStep1.intro) then
			--outputDebugString("checking")
			local count = 0
			for i = 1, 6 do
				for j = 1, 3 do
					if q[i][j] and isElement(q[i][j]) and guiRadioButtonGetSelected(q[i][j]) then
						count = count + 1
						result[i] = j
					end
				end
			end
			if count == 6 then
				guiSetEnabled(guiStep1.next, true)
			else
				guiSetEnabled(guiStep1.next, false)
			end
			if getElementType(source) == "gui-radiobutton" then
				playSoundFrontEnd(12)
			end
		end
	end
end

function hideGUIPart(GUIs)
	for i, gui in pairs (GUIs) do
		if gui and isElement(gui) then
			guiSetVisible(gui, false)
		end
	end
end

function showGUIPart(GUIs)
	for i, gui in pairs (GUIs) do
		if gui and isElement(gui) and (gui ~= guiStep1.retest) then
			guiSetVisible(gui, true)
		end
	end
end

function destroyGUIPart(GUIs)
	for i, gui in pairs (GUIs) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	removeEventHandler ( "onClientGUIClick", root, clickOnApplication)
end

function getAnswerFromRadio(radios)
	for i = 1, 3 do
		if guiRadioButtonGetSelected(radios[i]) then
			return tostring(i)
		end
	end
end

function killTimer1()
	if timer and isTimer(timer) then
		killTimer(timer)
	end
end