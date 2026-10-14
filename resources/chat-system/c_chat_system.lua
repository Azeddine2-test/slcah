bindKey("b", "down", "chatbox", "LocalOOC")
bindKey ("u" , "down" , "chatbox", "quickreply")

data = { }
function datachange(value)
	if (data[value] == nil) then
		data[value] = 1
	else
		data[value] = data[value] + 1
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), datachange)

-- Radio sound
function playRadioSound()
	local soundEnabled = getElementData(localPlayer, "sound_icradio") ~= "0"
	if not soundEnabled then return end
	playSoundFrontEnd(47)
	setTimer(playSoundFrontEnd, 700, 1, 48)
	setTimer(playSoundFrontEnd, 800, 1, 48)
end
addEvent( "playRadioSound", true )
addEventHandler( "playRadioSound", getRootElement(), playRadioSound )

-- Radio sounds only (atc.mp3 / pa.mp3)
function playCustomChatSound(sound)
	local soundEnabled = getElementData(localPlayer, "sound_icradio") ~= "0"
	if not soundEnabled then return end
	playSound("sound/"..tostring(sound), false)
end
addEvent( "playCustomChatSound", true )
addEventHandler( "playCustomChatSound", getRootElement(), playCustomChatSound )

local tick = getTickCount()
function showdata()
	local tick2 = getTickCount()
	local time = (tick2 - tick) / 1000
	outputChatBox("Sync for " .. time .. " seconds.")

	local largest = 0
	local largestname = "none"
	for key, value in pairs(data) do
		if (value>=5) then
			if (value>largest) and (value~="scoreboard:reload") then
				largest = value
				largestname = key
			end
			outputChatBox(tostring(key) .. ": ".. value)
		end
	end

	outputChatBox("Largest was: ".. largestname .. ": " .. largest)
end
addCommandHandler("showdata", showdata)


--HQ CHAT FOR PD / MAXIME
function playHQSound()
	playSoundFrontEnd(1)
	setTimer(playSoundFrontEnd, 300, 1, 1)
end
addEvent("playHQSound", true)
addEventHandler("playHQSound", getRootElement(), playHQSound)

--PM SOUND FX / MAXIME
function playPmSound(message)
	local soundEnabled = getElementData(localPlayer, "sound_pms") ~= "0"
	if not soundEnabled then return end
	local pmsound = playSound("sound/pmSoundFX.mp3",false)
	setSoundVolume(pmsound, 0.9)
	if message then
		createTrayNotification(message)
	end
end
addEvent("pmClient",true)
addEventHandler("pmClient",getRootElement(),playPmSound)

-- Nando : screen color
local SW, SH = guiGetScreenSize()
local r1, g1, b1

local drawing = false

local SCREEN_COLORS = {
	["rouge"] = {255, 0, 0},
	["vert"] = {17, 166, 15},
	["bleu"] = {255, 255, 0},
	["noir"] = {0, 0, 0},
	["gris"] = {105, 105, 105},
	["jaune"] = {255, 255, 0},
	["orange"] = {252, 136, 3},
}

local function drawScreenColor()
	dxDrawRectangle(0, 0, SW, SH, tocolor(r1, g1, b1, 255))
end

local function screenColorCommand(commandName, colorOrR, g, b)
	if drawing then
		drawing = false
		removeEventHandler("onClientRender", root, drawScreenColor)
		r1, g1, b1 = nil, nil, nil
		return
	end

	if not colorOrR then
		outputChatBox("USAGE: /"..commandName.." [nom de couleur prédéfinie]", 255, 195, 15)
		local couleurs = ""
		for k, v in pairs(SCREEN_COLORS) do
			couleurs = couleurs..k..", "
		end
		couleurs = string.sub(couleurs, 1, -3)
		outputChatBox("Couleurs disponibles: "..couleurs, 255, 255, 25)
		outputChatBox("ou /"..commandName.." [R] [G] [B]", 255, 195, 15)
		return
	end

	colorOrR = string.lower(colorOrR)

	if tonumber(colorOrR) then
		if (not tonumber(g)) or (not tonumber(b)) then
			return rScreenColor(commandName)
		end
		r1, g1, b1 = tonumber(colorOrR), tonumber(g), tonumber(b)
	else
		local color = SCREEN_COLORS[colorOrR]
		if not color then
			screenColorCommand(commandName)
			return
		end
		r1, g1, b1 = unpack(color)
	end

	addEventHandler("onClientRender", root, drawScreenColor)
	drawing = true
end
addCommandHandler("ecran", screenColorCommand, false)