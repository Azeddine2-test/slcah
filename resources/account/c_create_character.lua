loadstring(exports.dgs:dgsImportFunction())()
local dgs = {}
local curskin = 1
local dummyPed = nil
local languageselected = 1
local selectedMonth1 = "Janvier"
local scrDay = 1
local gender = 0
local warningBox

local titleFont = dxCreateFont(":assets/fonts/bebas.ttf", 35) or "default-bold"
local subtitleFont = dxCreateFont(":assets/fonts/roboto_light.ttf", 15) or "default-bold"
local editTitleFont = dxCreateFont(":assets/fonts/roboto_bold.ttf", 13) or "default-bold"
local roundRect = dgsCreateRoundRect(10, false, tocolor(18, 18, 20), false, false)
local editFont = dxCreateFont(":assets/fonts/roboto_regular.ttf", 13) or "default-bold"
local smallBold = dxCreateFont(":assets/fonts/roboto_bold.ttf", 10) or "default-bold"

local btnRound = dgsCreateRoundRect(10, false, tocolor(130, 87, 229)) 
local btnRoundHover = dgsCreateRoundRect(10, false, tocolor(123, 54, 201))

local btnRoundGrey = dgsCreateRoundRect(10, false, tocolor(112, 109, 117)) 
local btnRoundGreyHover = dgsCreateRoundRect(10, false, tocolor(122, 111, 148))

function newCharacter_init(characterID, characterData)
    Characters_deactivateGUI()
    if characterID and (characterBeingModified == characterID) then
        characterBeingModified = {characterID, characterData}
    end

	local function applyImageHoverEffect(element)
		addEventHandler("onDgsMouseEnter", element, function()
			dgsSetProperty(element, "color", tocolor(200, 200, 200))
		end, false)
		addEventHandler("onDgsMouseLeave", element, function()
			dgsSetProperty(element, "color", tocolor(255, 255, 255))
		end, false)
	end

	triggerEvent("weather:update", root) -- fix weather?
	
	dgsSetInputEnabled(true)
	setCameraInterior(14)
	setCameraMatrix(254.7190,  -41.1370,  1002, 256.7190,  -41.1370,  1002 )
	dummyPed = createPed(217, 258,  -42,  1002)
	setElementInterior(dummyPed, 14)
	setElementInterior(getLocalPlayer(), 14)
	setPedRotation(dummyPed, 87)
	setElementDimension(dummyPed, getElementDimension(getLocalPlayer()))
	fadeCamera ( true, 1, 0,0,0 )
	local screenX, screenY = dgsGetScreenSize()
	local x, y = 122, 42

	setTimer(function()
		showCursor(true)
	end, 1000, 1)

	dgs["_root"] = dgsCreateImage(0, 0, 645, screenY, "img/new_char_bg.png", false)
	--dgsWindowSetSizable(dgs["_root"], false)
	dgs["_root2"] = dgsCreateScrollPane(0,0, 645, screenY-30, false, dgs["_root"])

	local label = dgsCreateLabel(x, y, 243, 84, (characterBeingModified and "MODIFIEZ VOTRE PERSONNAGE") or "Welcome to Southland.", false, dgs["_root2"])
	dgsSetFont(label, titleFont)
	dgsSetProperty(label, "wordBreak", true)

	y = y + 84 + 35
	local label = dgsCreateLabel(x, y, 400, 46, (characterBeingModified and "Vous devez modifier votre personnage suite à son CK.") or "Pour créer votre personnage, remplissez les informations ci-dessous", false, dgs["_root2"])
	dgsSetFont(label, subtitleFont)
	dgsSetProperty(label, "wordBreak", true)

	y = y + 46 + 50
	local label = dgsCreateLabel(x, y, 72, 21, "Identité", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)

	y = y + 15 + 20
	dgs["txtCharName"] = dgsCreateEdit(x, y, 400, 64, "", false, dgs["_root2"], tocolor(255, 255, 255), 1, 1, roundRect, tocolor(112, 112, 112, 150))
	local passIcon = dgsCreateImage(13, 24, 20, 16, ":assets/images/identity.png", false, dgs["txtCharName"])
	dgsEditSetPlaceHolder(dgs["txtCharName"], "Prénom Nom")
	dgsSetProperty(dgs["txtCharName"], "padding", {42.41, 17})
	dgsSetProperty(dgs["txtCharName"], "placeHolderFont", editFont)
	dgsSetFont(dgs["txtCharName"], editFont)

	y = y + 70 + 10
	local img = dgsCreateImage(x, y, 16, 16, ":assets/images/rules.png", false, dgs["_root2"])
	local label = dgsCreateLabel(x + 21, y, 241, 48, "Le nom doit suivre les règles suivantes:\n* Prénom et nom\n* Vous n'êtes pas autorisé à utiliser des noms célèbres", false, dgs["_root2"])
	dgsSetFont(label, smallBold)

	y = y + 16 + 48 + 18
	local label = dgsCreateLabel(x, y, 72, 21, "Sexe", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)

	y = y + 21 + 23
	rbMale = dgsCreateImage(x, y, 39.6, 39.6, roundRect, false, dgs["_root2"])
	dgsSetProperty(rbMale, "color", tocolor(130, 87, 229))
	addEventHandler("onDgsMouseEnter", rbMale, function()
		dgsSetProperty(rbMale, "color", tocolor(110, 84, 168))
	end, false)
	addEventHandler("onDgsMouseLeave", rbMale, function()
		if gender == 0 then
			dgsSetProperty(rbMale, "color", tocolor(130, 87, 229))
		else
			dgsSetProperty(rbMale, "color", tocolor(112, 112, 112, 150))
		end
	end, false)
	local img = dgsCreateImage(7.43, 7.43, 24.75, 24.75, ":assets/images/male.png", false, rbMale)
	dgsSetEnabled(img, false)
	local label = dgsCreateLabel(x + 39.6 + 11.4, y + 7, 62, 14, "Homme", false, dgs["_root2"])
	dgsSetFont(label, editFont)
	addEventHandler("onDgsMouseClickUp", rbMale, function()
		dgsSetProperty(rbFemale, "color", tocolor(112, 112, 112, 150))
		dgsSetProperty(rbMale, "color", tocolor(130, 87, 229))

		gender = 0
		newCharacter_updateGender()
	end, false)

	x = x + 39.6 + 95
	rbFemale = dgsCreateImage(x, y, 39.6, 39.6, roundRect, false, dgs["_root2"])
	dgsSetProperty(rbFemale, "color", tocolor(112, 112, 112, 150))
	addEventHandler("onDgsMouseEnter", rbFemale, function()
		dgsSetProperty(rbFemale, "color", tocolor(110, 84, 168))
	end, false)
	addEventHandler("onDgsMouseLeave", rbFemale, function()
		if gender == 1 then
			dgsSetProperty(rbFemale, "color", tocolor(130, 87, 229))
		else
			dgsSetProperty(rbFemale, "color", tocolor(112, 112, 112, 150))
		end
	end, false)
	local img = dgsCreateImage(7.43, 7.43, 24.75, 24.75, ":assets/images/female.png", false, rbFemale)
	dgsSetEnabled(img, false)
	local label = dgsCreateLabel(x + 39.6 + 11.4, y + 7, 62, 14, "Femme", false, dgs["_root2"])
	dgsSetFont(label, editFont)
	addEventHandler("onDgsMouseClickUp", rbFemale, function()
		dgsSetProperty(rbMale, "color", tocolor(112, 112, 112, 150))
		dgsSetProperty(rbFemale, "color", tocolor(130, 87, 229))

		gender = 1
		newCharacter_updateGender()
	end, false)

	y = y - 21 - 23
	x = x + 135
	local label = dgsCreateLabel(x, y, 72, 21, "Skin", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)

	y = y + 21 + 31
	btnPrevSkin = dgsCreateImage(x, y, 20, 20, ":assets/images/prev.png", false, dgs["_root2"])
	applyImageHoverEffect(btnPrevSkin)
	addEventHandler("onDgsMouseClickUp", btnPrevSkin, function()
		newCharacter_changeSkin(-1)
	end, false)

	x = x + 20 + 18
	skinLabel = dgsCreateLabel(x, y, 37, 18, "Skin 1", false, dgs["_root2"])
	dgsSetFont(skinLabel, editFont)

	x = x + 20 + 50
	btnNextSkin = dgsCreateImage(x, y, 20, 20, ":assets/images/next.png", false, dgs["_root2"])
	applyImageHoverEffect(btnNextSkin)
	addEventHandler("onDgsMouseClickUp", btnNextSkin, function()
		newCharacter_changeSkin(1)
	end, false)

	x, y = 122, y + 39.6 + 10
	local label = dgsCreateLabel(x, y, 48, 21, "Taille", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)

	y = y + 21 + 10
	dgs["scrHeight"] = dgsCreateScrollBar ( x, y, 184, 5, true, false, dgs["_root2"])
	addEventHandler("onDgsElementScroll", dgs["scrHeight"], newCharacter_updateScrollBars, false)
	dgsSetProperty(dgs["scrHeight"], "StepSize", "0.02")
	dgsSetProperty(dgs["scrHeight"], "cursorColor", {tocolor(217, 217, 217), tocolor(217, 217, 217), tocolor(217, 217, 217)})
	dgsSetProperty(dgs["scrHeight"],"troughColor",{tocolor(130, 87, 229), tocolor(217, 217, 217, 40)})

	y = y + 5 + 5
	heightLabel = dgsCreateLabel(x + 184/2 - 30, y, 41, 16, "150CM", false, dgs["_root2"])
	dgsSetFont(heightLabel, editFont)

	x, y = x + 167 + 50, y - 42.5
	local label = dgsCreateLabel(x, y, 48, 21, "Poids", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)

	y = y + 21 + 10
	dgs["scrWeight"] = dgsCreateScrollBar ( x, y, 184, 5, true, false, dgs["_root2"])
	addEventHandler("onDgsElementScroll", dgs["scrWeight"], newCharacter_updateScrollBars, false)
	dgsSetProperty(dgs["scrWeight"], "StepSize", "0.02")
	dgsSetProperty(dgs["scrWeight"], "cursorColor", {tocolor(217, 217, 217), tocolor(217, 217, 217), tocolor(217, 217, 217)})
	dgsSetProperty(dgs["scrWeight"],"troughColor",{tocolor(130, 87, 229), tocolor(217, 217, 217, 40)})

	y = y + 5 + 5
	weightLabel = dgsCreateLabel(x + 184/2 - 30, y, 41, 16, "50KG", false, dgs["_root2"])
	dgsSetFont(weightLabel, editFont)
	
	y = y + 16 + 20
	x = 122
	local label = dgsCreateLabel(x, y, 48, 21, "Date de naissance", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)

	y = y + 21 + 10
	dgs["drpMonth"] = dgsCreateComboBox ( x, y, 157, 36, "Janvier", false, dgs["_root2"])
	dgsComboBoxAddItem(dgs["drpMonth"], "Janvier")
	dgsComboBoxAddItem(dgs["drpMonth"], "Février")
	dgsComboBoxAddItem(dgs["drpMonth"], "Mars")
	dgsComboBoxAddItem(dgs["drpMonth"], "Avril")
	dgsComboBoxAddItem(dgs["drpMonth"], "Mai")
	dgsComboBoxAddItem(dgs["drpMonth"], "Juin")
	dgsComboBoxAddItem(dgs["drpMonth"], "Juillet")
	dgsComboBoxAddItem(dgs["drpMonth"], "Août")
	dgsComboBoxAddItem(dgs["drpMonth"], "Septembre")
	dgsComboBoxAddItem(dgs["drpMonth"], "Octobre")
	dgsComboBoxAddItem(dgs["drpMonth"], "Novembre")
	dgsComboBoxAddItem(dgs["drpMonth"], "Décembre")

	x = x + 157 + 91
	dgs["drpDay"] =  dgsCreateComboBox ( x, y, 157, 36, "Jour", false, dgs["_root2"])
	local dayCap = daysInMonth(selectedMonth, year) or 31
	for i = 1, dayCap do
		dgsComboBoxAddItem(dgs["drpDay"], i)
	end
	dgsComboBoxSetSelectedItem(dgs["drpDay"], 1)

	x, y = 122, y + 16 + 35
	local label = dgsCreateLabel(x, y, 48, 21, "Age", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)

	y = y + 21 + 10
	scrAge =  dgsCreateScrollBar ( x, y, 410, 5, true, false, dgs["_root2"])
	addEventHandler("onDgsElementScroll", scrAge, newCharacter_updateScrollBars, false)
	dgsSetProperty(scrAge, "cursorColor", {tocolor(217, 217, 217), tocolor(217, 217, 217), tocolor(217, 217, 217)})
	dgsSetProperty(scrAge, "troughColor",{tocolor(130, 87, 229), tocolor(217, 217, 217, 40)})

	y = y + 5 + 10
	ageLabel = dgsCreateLabel(x + 410/2 - 30, y, 41, 16, "16 ans", false, dgs["_root2"])
	dgsSetFont(ageLabel, editFont)

	addEventHandler ( "onDgsComboBoxSelect", dgs["drpDay"], function ( comboBox )
		local item = dgsComboBoxGetSelectedItem ( dgs["drpDay"] )
		scrDay = tonumber ( dgsComboBoxGetItemText ( dgs["drpDay"] , item ) )
	end, false)

	addEventHandler ( "onDgsComboBoxSelect", dgs["drpMonth"], function ( comboBox )
		local item = dgsComboBoxGetSelectedItem ( dgs["drpMonth"] )
		selectedMonth1 = tostring ( dgsComboBoxGetItemText ( dgs["drpMonth"] , item ) )

		local year = getBirthday(tonumber(scrAge))
		selectedMonth = monthToNumber(selectedMonth1)
		local dayCap = daysInMonth(selectedMonth, year) or 31

		dgsComboBoxClear(dgs["drpDay"])
		for i = 1, dayCap do
			dgsComboBoxAddItem(dgs["drpDay"], i)
		end
	end, false)

	x, y = 122, y + 16 + 35
	local label = dgsCreateLabel(x, y, 48, 21, "Langue parlée (IC) : Anglais", false, dgs["_root2"])
	dgsSetFont(label, editTitleFont)
	y = y + 21 + 10

	lblLanguageDisplay = dgsCreateLabel(x, y, 44, 18, "Vous pourrez apprendre d'autres langues plus tard", false, dgs["_root2"])
	dgsSetFont(lblLanguageDisplay, smallBold)

	-- y = y + 21 + 15
	-- btnLanguagePrev = dgsCreateImage(x, y, 24, 24, ":assets/images/prev.png", false, dgs["_root2"])
	-- addEventHandler("onDgsMouseClickUp", btnLanguagePrev, function()
	-- 	newCharacter_updateLanguage()
	-- end, false)

	-- lblLanguageDisplay = dgsCreateLabel(x + 24 + 10, y, 44, 18, "Anglais", false, dgs["_root2"])
	-- dgsSetFont(lblLanguageDisplay, editFont)

	-- x = x + 24 + 5 + 70
	-- btnLanguageNext = dgsCreateImage(x, y, 24, 24, ":assets/images/next.png", false, dgs["_root2"])
	-- addEventHandler("onDgsMouseClickUp", btnLanguageNext, function()
	-- 	newCharacter_updateLanguage()
	-- end, false)

	x, y = 122, y + 50
	bClose = dgsCreateButton(x, y, 176, 64, "ANNULER", false, dgs["_root2"], tocolor(255, 255, 255), 1, 1, btnRoundGrey, btnRoundGrey, btnRoundGrey)
	addEventHandler("onDgsMouseEnter", bClose, function()
		dgsSetProperty(bClose, "image", btnRoundGreyHover)
	end, false)
	addEventHandler("onDgsMouseLeave", bClose, function()
		dgsSetProperty(bClose, "image", btnRoundGrey)
	end, false)
	dgsSetFont(bClose, editTitleFont)

	x = x + 176 + 50
	bCreate = dgsCreateButton(x, y, 176, 64, (characterBeingModified and "Modifier") or "CRÉER", false, dgs["_root2"], tocolor(255, 255, 255), 1, 1, btnRound, btnRound, btnRound)
	addEventHandler("onDgsMouseEnter", bCreate, function()
		dgsSetProperty(bCreate, "image", btnRoundHover)
	end, false)
	addEventHandler("onDgsMouseLeave", bCreate, function()
		dgsSetProperty(bCreate, "image", btnRound)
	end, false)
	dgsSetFont(bCreate, editTitleFont)
	addEventHandler("onDgsMouseClickUp", bCreate, function()
        newCharacter_attemptCreateCharacter()
	end, false)
	dgsSetProperty(bCreate,"color",{tocolor(130, 87, 229),tocolor(130, 87, 229),tocolor(130, 87, 229)})

	addEventHandler("onDgsMouseClickUp", bClose, function()
		newCharacter_cancel()
	end, false)

	newCharacter_changeSkin()
	newCharacter_updateScrollBars()
    if characterBeingModified then
        gender = characterBeingModified[2].gender
        dgsSetText(dgs["txtCharName"], string.gsub(characterBeingModified[2].charactername, "_", " "))
        dgsSetProperty(rbMale, "color", tocolor(112, 112, 112, 150))
        dgsSetProperty(rbFemale, "color", tocolor(112, 112, 112, 150))
		dgsSetProperty(((gender == 0) and rbMale) or rbFemale, "color", tocolor(130, 87, 229))
        dgsComboBoxSetSelectedItem(dgs["drpMonth"], characterBeingModified[2].month)
        dgsComboBoxSetSelectedItem(dgs["drpDay"], characterBeingModified[2].day)
        dgsScrollBarSetScrollPosition(dgs["scrHeight"], (characterBeingModified[2].height - 150)*2)
        dgsScrollBarSetScrollPosition(dgs["scrWeight"], characterBeingModified[2].weight - 50)
        dgsScrollBarSetScrollPosition(scrAge, (characterBeingModified[2].age - 16)/0.8)
        newCharacter_updateGender()
        for i, j in ipairs(newCharacters_getSkinArray()) do
            if j == characterBeingModified[2].skin then
                curskin = i
                break
            end
        end
        newCharacter_changeSkin()
    end
end

function newCharacter_updateGender()
	local diff = 0
	if (source == dgs["btnPrevSkin"]) then
		diff = -1
	elseif (source == dgs["btnNextSkin"]) then
		diff = 1
	else
		curskin = 1
	end

	newCharacter_changeSkin(diff)
end

-- function newCharacter_updateLanguage()

-- 	if source == btnLanguagePrev then
-- 		if languageselected == 1 then
-- 			languageselected = call( getResourceFromName( "language-system" ), "getLanguageCount" )
-- 		else
-- 			languageselected = languageselected - 1
-- 		end
-- 	elseif source == btnLanguageNext then
-- 		if languageselected == call( getResourceFromName( "language-system" ), "getLanguageCount" ) then
-- 			languageselected = 1
-- 		else
-- 			languageselected = languageselected + 1
-- 		end
-- 	end

-- 	dgsSetText(lblLanguageDisplay, tostring(call( getResourceFromName( "language-system" ), "getLanguageName", languageselected )))
-- end

function newCharacter_updateScrollBars()
	local scrollHeight = dgsScrollBarGetScrollPosition(dgs["scrHeight"])
	scrollHeight = math.floor((scrollHeight / 2) + 150)

	local scrWeight = dgsScrollBarGetScrollPosition(dgs["scrWeight"])
	scrWeight = math.floor(scrWeight + 50)

	local scrAge = dgsScrollBarGetScrollPosition(scrAge)
	scrAge = math.floor( (scrAge * 0.8 ) + 16 )

	--local scrollHeight = tonumber(dgsGetProperty(dgs["scrHeight"], "ScrollPosition")) * 100
	--scrollHeight = math.floor((scrollHeight / 2) + 150)
	dgsSetText(heightLabel, ""..scrollHeight.." CM")

	--local scrWeight = tonumber(dgsGetProperty(dgs["scrWeight"], "ScrollPosition")) * 310
	--scrWeight = math.floor(scrWeight + 40)
	dgsSetText(weightLabel, ""..scrWeight.." KG")

	--local scrAge = tonumber(dgsGetProperty(dgs["scrAge"], "ScrollPosition")) * 100
	--scrAge = math.floor( (scrAge * 0.8 ) + 16 )
	dgsSetText(ageLabel, ""..scrAge.." ans")
end

function newCharacter_changeSkin(diff)
	local array = newCharacters_getSkinArray()
	local skin = 0
	if (diff ~= nil) then
		curskin = curskin + diff
	end

	if (curskin > #array or curskin < 1) then
		curskin = 1
		skin = array[1]
	else
		curskin = curskin
		skin = array[curskin]
	end

	if skin ~= nil then
		setElementModel(dummyPed, tonumber(skin))
		dgsSetText(skinLabel, "Skin " .. skin)
	end
end

-- For the skin selection
males = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 1, 2, 45, 46, 47, 48, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 268, 269, 270, 271, 290, 291, 292, 293, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294, 295, 296, 297, 299, 302, 303, 306, 307, 308, 310, 312}
females = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298, 9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 256, 304, 38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

function newCharacters_getSkinArray()
	local array = { }
	if gender == 0 then -- MALE
		array = males
	elseif gender == 1 then -- FEMALE
		array = females
	else
		outputChatBox("Sélectionnez d'abord un sexe!", 0, 255, 0)
	end
	
	return array
end

function newCharacter_cancel(hideSelection)
	dgsSetInputEnabled(false)
	destroyElement(dummyPed)
	destroyElement(dgs["_root"])
	if dgs['langWindow'] then
		destroyElement(dgs['langWindow'])
	end
	if isElement(warningBox) then
		destroyElement(warningBox)
		warningBox = nil
	end
	dgs = {}
	curskin = 1
	dummyPed = nil
	languageselected = 1
    characterBeingModified = false
	if hideSelection ~= true then
		Characters_showSelection()
	end
	clearChat()
end


function LoginScreen_showWarningMessage( message )

	if (isElement(warningBox)) then
		destroyElement(warningBox)
	end

	local SW, SH = guiGetScreenSize()
	local WW, WH = 420, 120
	warningBox = dgsCreateWindow(SW - WW - 10, SH/2-WH/2, WW, WH, "Attention", false)
	dgsWindowSetCloseButtonEnabled( warningBox, false )
	local warningMessage = dgsCreateLabel( 15, 15, WW-(15*2), 40, message, false, warningBox )
	dgsLabelSetHorizontalAlign( warningMessage, "center", true )
	dgsLabelSetVerticalAlign( warningMessage, "center" )
	local warningOk = dgsCreateButton( WW/2 - 70/2, 65, 70, 20, "OK", false, warningBox )
	addEventHandler( "onDgsMouseClickUp", warningOk, function()
		destroyElement(warningBox)
		warningBox = nil
	end, false )
	dgsBringToFront( warningBox )
end
addEventHandler("accounts:error:window", localPlayer, LoginScreen_showWarningMessage)

function newCharacter_attemptCreateCharacter()
	local characterName = dgsGetText(dgs["txtCharName"])
	if characterName == "" then
		LoginScreen_showWarningMessage( "Veuillez entrer un nom de personnage (ex : John Doe)." )
		return
	end
	local nameCheckPassed, nameCheckError = checkValidCharacterName(characterName)
	if not nameCheckPassed then
		LoginScreen_showWarningMessage( nameCheckError )
		return
	end

	if not gender then
		LoginScreen_showWarningMessage( "Veuillez sélectionner le sexe de votre personnage." )
		return
	end

	local skin = getElementModel( dummyPed )
	if not skin then
		LoginScreen_showWarningMessage( "Erreur de traitement du skin de votre personnage." )
		return
	end

	local scrollHeight = dgsScrollBarGetScrollPosition(dgs["scrHeight"])
	scrollHeight = math.floor((scrollHeight / 2) + 150)

	local scrWeight = dgsScrollBarGetScrollPosition(dgs["scrWeight"])
	scrWeight = math.floor(scrWeight + 50)

	local scrAge = dgsScrollBarGetScrollPosition(scrAge)
	scrAge = math.floor( (scrAge * 0.8 ) + 16 )

	if languageselected == nil then
		LoginScreen_showWarningMessage( "Veuillez sélectionner une langue." )
		return
	end
	
	dgsSetEnabled(dgs["_root"], false)
    triggerServerEvent("accounts:characters:new", getLocalPlayer(), characterBeingModified and characterBeingModified[1], characterName, characterDescription, gender, skin, scrollHeight, scrWeight, scrAge, languageselected, selectedMonth, scrDay)
end

function newCharacter_response(statusID, statusSubID)
	if (statusID == 3) then
		if not characterBeingModified and canSpawn then
			fadeCamera(false, 0)
			showCursor(false)
			newCharacter_cancel(true)
			triggerServerEvent("accounts:characters:spawn", getLocalPlayer(), statusSubID, nil, nil, nil, nil, true)
			showChat(true)
		else
			-- Back to character selection
			newCharacter_cancel()
		end
		return
	end

	if statusID == 2 and statusSubID == 1 then
		LoginScreen_showWarningMessage( "Ce nom de personnage est déjà pris.\nDésolé :-(" )
	else
		LoginScreen_showWarningMessage( "Erreur : code "..tostring(statusID).."-"..tostring(statusSubID) )
	end
	dgsSetEnabled(dgs["_root"], true)
end
addEvent("accounts:characters:new", true)
addEventHandler("accounts:characters:new", getRootElement(), newCharacter_response)

function isThisYearLeap(year)
     if (tonumber(year)%4) == 0 then
          return true
     else
          return false
     end
end

function monthToNumber(monthName)
	if not monthName then
		return 1
	else
		if monthName == "Janvier" then
			return 1
		elseif monthName == "Février" then
			return 2
		elseif monthName == "Mars" then
			return 3
		elseif monthName == "Avril" then
			return 4
		elseif monthName == "Mai" then
			return 5
		elseif monthName == "Juin" then
			return 6
		elseif monthName == "Juillet" then
			return 7
		elseif monthName == "Août" then
			return 8
		elseif monthName == "Septembre" then
			return 9
		elseif monthName == "Octobre" then
			return 10
		elseif monthName == "Novembre" then
			return 11
		elseif monthName == "Décembre" then
			return 12
		else
			return 1
		end
	end
end

function daysInMonth(month, year)
	if not month or not year or not tonumber(month) or not tonumber(year) then
		return 31
	else
		month = tonumber(month)
		year = tonumber(year)
	end

	if month == 1 then
		return 31
	elseif month == 2 then
		if isThisYearLeap(year) then
			return 29
		else
			return 28
		end
	elseif month == 3 then
		return 31
	elseif month == 4 then
		 return 30
	elseif month == 5 then
		return 31
	elseif month == 6 then
		return 30
	elseif month == 7 then
		return 31
	elseif month == 8 then
		return 31
	elseif month == 9 then
		return 30
	elseif month == 10 then
		return 31
	elseif month == 11 then
		return 30
	elseif month == 12 then
		return 31
	else
		return 31
	end
end

function getBirthday(age)
	if not age or not tonumber(age) then
		return 2015
	else
		age = tonumber(age)
	end

	local time = getRealTime()
	time.year = time.year + 1900
	return (time.year - age)
end
