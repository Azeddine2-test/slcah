--[[
	Nando

	Popup message box

	Created: 08/04/2023
]]

local SW, SH = guiGetScreenSize()
local DGS = exports.dgs
local wins = {}

-- Exported
function popup(content)
	assert(type(content)=="table", "Bad argument @ 'popup' [expected table at argument 1, got "..type(content).."]")
	assert(type(content.message)=="string", "Expected message in table at argument 1, got "..type(content.message))
	
	local title = content.title or "Information"
	local closeButtonText = content.closeButtonText or "Fermer"

	local _, countLines = string.gsub(content.message, "\n", "\n")
	local height = 120 + (countLines * 20)
	local longestLineW = 0
	for line in string.gmatch(content.message, "[^\n]+") do
		local lineW = dxGetTextWidth(line, 1, "default-bold")
		if lineW > longestLineW then
			longestLineW = lineW
		end
	end
	local width = longestLineW + 20

	local winId = #wins+1
	wins[winId] = DGS:dgsCreateWindow((SW-width)/2, (SH-height)/2, width, height, title, false)
	DGS:dgsWindowSetSizable(wins[winId], false)
	DGS:dgsWindowSetCloseButtonEnabled(wins[winId], false)
	DGS:dgsSetProperty(wins[winId], "colorCoded", true)

	local text = DGS:dgsCreateLabel(10, 15, width-20, height-120, content.message, false, wins[winId])
	DGS:dgsLabelSetHorizontalAlign(text, "center", false)
	DGS:dgsLabelSetVerticalAlign(text, "center")

	local closeButton = DGS:dgsCreateButton(10, height-65, width-20, 30, closeButtonText, false, wins[winId])
	addEventHandler("onDgsMouseClickUp", closeButton, function()
		triggerEvent("cursorHide", localPlayer)
		destroyElement(wins[winId])
		wins[winId] = nil
	end, false)

	triggerEvent("cursorShow", localPlayer)
end
addEvent("hud:popup", true)
addEventHandler("hud:popup", localPlayer, popup, false)
