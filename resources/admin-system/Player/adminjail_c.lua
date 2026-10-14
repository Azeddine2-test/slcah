-- Nando opti 10/04/2023

local sw, sh = guiGetScreenSize()

local timer = nil
local drawing = false

local lastJailtime = nil
local currentSecs = ""
local myJailTime = nil
local myJailReason = nil
local myJailerAdmin = nil

local bgColor = tocolor(0, 0, 0, 100)
local whiteColor = 0xffffffff
local remainingColor = tocolor(235, 146, 41, 255)

local w, h = 412, 126
local bgw, bgh = w, h
local bgx, bgy = (sw-bgw)/2, 45

local x, y = (sw-w)/2, 50
local xo, yo = (543-x), (28-y)

function showAdminJailCounter()
	if lastJailtime ~= myJailTime then
		currentSecs = tonumber(myJailTime) and myJailTime*60 or myJailTime
		lastJailtime = myJailTime
		if timer and isTimer(timer) then
			killTimer(timer)
			timer = nil
		end
		if tonumber(currentSecs) then
			timer = setTimer(function ()
				if tonumber(currentSecs) then
					currentSecs = currentSecs - 1
				end
			end, 1000, 59)
		end
	end

    dxDrawRectangle(bgx, bgy, bgw, bgh, bgColor, true)

    dxDrawText("Vous avez été jail pendant", 630-xo, 38-yo, 872-xo, 76-yo, whiteColor, 1.00, "pricedown", "center", "center", false, false, true, false, false)
    dxDrawText("Raison: "..myJailReason, 553-xo, 100-yo, 945-xo, 127-yo, whiteColor, 1.00, "default", "center", "center", false, true, true, false, false)
    dxDrawText(tonumber(currentSecs) and exports.datetime:formatSeconds(currentSecs) or myJailTime, 563-xo, 59-yo, 945-xo, 100-yo, remainingColor, 1.00, "bankgothic", "center", "center", false, false, true, false, false)
    dxDrawText("Jail par: "..myJailerAdmin, 553-xo, 117-yo, 945-xo, 144-yo, whiteColor, 1.00, "default", "center", "bottom", false, true, true, false, false)
end

local function togAdminJailCounter(activate)
	if activate then
		if not drawing then
			addEventHandler("onClientRender", root, showAdminJailCounter, false)
			drawing = true
		end
	else
		if drawing then
			removeEventHandler("onClientRender", root, showAdminJailCounter, false)
			drawing = false
		end
	end
end
addEventHandler("onClientElementDataChange", localPlayer, function(theKey, _, newValue)
	if theKey == "jailtime" then
		if newValue and ((tonumber(newValue) and tonumber(newValue) > 0) or type(newValue)=="string") then

			myJailTime = newValue
			myJailReason = (getElementData(localPlayer, "jailreason") or "Aucune")
			myJailerAdmin = (getElementData(localPlayer, "jailadmin") or "Inconnu")
			lastJailtime = nil
			currentSecs = ""

			togAdminJailCounter(true)
		else
			togAdminJailCounter(false)

			myJailTime = nil
			myJailReason = nil
			myJailerAdmin = nil
			lastJailtime = nil
			currentSecs = ""
		end
	end
end, false)

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "account:loggedin") then
		local newValue = getElementData(localPlayer, "jailtime")
		if newValue and ((tonumber(newValue) and tonumber(newValue) > 0) or type(newValue)=="string") then

			myJailTime = newValue
			myJailReason = (getElementData(localPlayer, "jailreason") or "Sans raison")
			myJailerAdmin = (getElementData(localPlayer, "jailadmin") or "Inconnu")
			lastJailtime = nil
			currentSecs = ""

			togAdminJailCounter(true)
		end
	end
end, false)