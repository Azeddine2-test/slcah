-- Nando 08/04/2023

local thisResourceElement = getResourceRootElement(getThisResource())
local sx, sy = guiGetScreenSize()
local width = 600

local content = {
	{("                                                                           AUCUNE DEMANDE"), tocolor(255, 56, 56), 1,"default-bold" }
}
local contentCount = 1

local showTopRightBox = false
local drawing = false
local bgColor = tocolor(0, 0, 0, 150)

local function drawTopRightBox()
	local heightTemp = 16*(contentCount)+30
	dxDrawRectangle(sx-width-5+40, 45, width, heightTemp, bgColor)
	
	for i=1, contentCount do
		local v = content[i]
		if v then
			dxDrawText( v[1] or "", sx-width+10+40, (16*i)+40, width-5, 15,
			v[2], v[3] or 1, v[4] or "default",	"left", "top")
		end
	end
end

addEvent("report:receiveReportsList", true)
addEventHandler("report:receiveReportsList", localPlayer, function(list)
	content = list
	contentCount = #content
	if contentCount == 0 then
		content = {
			{("                                                                           AUCUNE DEMANDE"), tocolor(255, 56, 56), 1,"default-bold" }
		}
		contentCount = 1
	end
end)

local function canSeeTopRightBox()
	return getElementData(localPlayer, "loggedin")==1
	and exports.hud:isActive(true)
	and (exports.integration:isPlayerTrialAdmin(localPlayer) or exports.integration:isPlayerSupporter(localPlayer))
	and (getElementData(localPlayer, "report_panel_mod") == "1" or getElementData(localPlayer, "report_panel_mod") == "3")
end

local function handleLocalPlayerDataChange(keyName)
	if keyName == "duty_admin" or keyName == "admin_level" or keyName == "duty_supporter" or keyName == "supporter_level" or keyName == "report_panel_mod" or keyName=="loggedin" or keyName=="hide_hud" then
		showTopRightBox = canSeeTopRightBox()
		if showTopRightBox then
			if not drawing then
				addEventHandler("onClientRender", root, drawTopRightBox, false)
				drawing = true
			end
		else
			if drawing then
				removeEventHandler("onClientRender", root, drawTopRightBox, false)
				drawing = false
			end
		end
	end
end
addEventHandler("onClientElementDataChange", localPlayer, handleLocalPlayerDataChange, false)

function startAutoUpdate()
	showTopRightBox = canSeeTopRightBox()
	if showTopRightBox then
		addEventHandler("onClientRender", root, drawTopRightBox, false)
		drawing = true
	end
end
addEventHandler("onClientResourceStart", thisResourceElement, startAutoUpdate, false)
