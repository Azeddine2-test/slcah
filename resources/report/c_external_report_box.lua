-- Nando 08/04/2023

local thisResourceElement = getResourceRootElement(getThisResource())
local sx, sy = guiGetScreenSize()
local width, height = 650,300
local content = {}
local line = 15
local BizNoteFont18 = dxCreateFont ( ":resources/Montserrat-Bold.ttf", 18 ) or "default-bold"
local showBigBox = false
local drawing = false

function updateOverlay(info)
	if showBigBox and info then
		table.insert(content, info)
		playSoundFrontEnd ( 101 )
	end
end
addEvent("report-system:updateOverlay", true)
addEventHandler("report-system:updateOverlay", localPlayer, updateOverlay)

addEventHandler( "onClientElementDataChange", thisResourceElement, 
	function(n, _, value)
		if n == "reportPanel" then
			updateOverlay(value)
		end
	end, false
)

local function drawBigBox()
	if ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( localPlayer, "aim_weapon" ) ) and not isPlayerMapVisible() then
		local w = width
		local h = 16*(line)+30
		local posX = (sx/2)-(w/2)
		local sy1 = getElementData(localPlayer, "recon:whereToDisplayY") or sy
		if sy1 ~= sy then
			sy1 = sy1 + 25
		end
		local posY = sy1-(h+30) 
		
		dxDrawRectangle(posX, posY , w, h , tocolor(0, 0, 0, 100), false)
		
		dxDrawText( "Panel Rapports" , posX+16, posY+10, w-5, 5, tocolor ( 70, 200, 30, 255 ), 1, BizNoteFont18 )
		
		local lastIndex = #content
		local count = 1
		for i = (lastIndex-line+2), (lastIndex) do
			if content[i] then
				dxDrawText( content[i][1] or "" , posX+16, posY+(15*count)+30, w-5, 15, tocolor ( content[i][2] or 255, content[i][3] or 255, content[i][4] or 255, content[i][5] or 255 ), content[i][6] or 1, content[i][7] or "default" )
				count = count + 1
			end
		end
	end
end

local function canSeeBigBox()
	return getElementData(localPlayer, "loggedin")==1
	and exports.hud:isActive(true)
	and showExternalReportBox(localPlayer)
end

local function handleLocalPlayerDataChange(keyName)
	if keyName == "duty_admin" or keyName == "admin_level" or keyName == "duty_supporter" or keyName == "supporter_level" or keyName == "report_panel_mod" or keyName=="loggedin" or keyName=="hide_hud" then
		showBigBox = canSeeBigBox()
		if showBigBox then
			if not drawing then
				updateOverlay()
				addEventHandler("onClientRender", root, drawBigBox, false)
				drawing = true
			end
		else
			if drawing then
				removeEventHandler("onClientRender", root, drawBigBox, false)
				drawing = false
				content = nil
			end
		end
	end
end
addEventHandler("onClientElementDataChange", localPlayer, handleLocalPlayerDataChange, false)

function startAutoUpdate()
	showBigBox = canSeeBigBox()
	if showBigBox then
		updateOverlay()
		addEventHandler("onClientRender", root, drawBigBox, false)
		drawing = true
	end
end
addEventHandler("onClientResourceStart", thisResourceElement, startAutoUpdate, false)
