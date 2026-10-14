
local screenWidth, screenHeight = guiGetScreenSize()
local show = false
local width, height = 246,300
local sx, sy = guiGetScreenSize()
local content = {}
local timerClose = nil
local cooldownTime = 20 --seconds
local BizNoteFont20 = dxCreateFont ( ":resources/Montserrat-Bold.ttf", 16 ) or "default-bold"
local toBeDrawnWidth = width
local justClicked = false
local posXOffset, posYOffset = 0, 0

local function renderOverlayTopRight()
	if ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( localPlayer, "aim_weapon" ) ) then
			
		dxDrawRectangle(sx-toBeDrawnWidth-5+posXOffset, 5+posYOffset, toBeDrawnWidth, 16*(#content)+30, tocolor(0, 0, 0, 100), false)
		
		local pinned = getElementData(localPlayer, "hud:pin")
		if isCursorShowing() then
			local cursorX, cursorY, cwX, cwY, cwZ = getCursorPosition()
			cursorX, cursorY = cursorX * screenWidth, cursorY * screenHeight
			if justClicked and isInBox( cursorX, cursorY, sx-5+posXOffset-35, sx-5+posXOffset-35 + 25, (5+posYOffset)+10, (5+posYOffset)+10 + 25 ) then
				if pinned then
					unpinIt()
				else
					pinIt()
				end
				playToggleSound()
			end
		end
		justClicked = false
		dxDrawImage ( sx-5+posXOffset-35, (5+posYOffset)+10, 25, 25, (pinned and "images/pinned.png" or "images/pin.png" ),0, 0, 0, tocolor(255,255,255), false )
		
		for i=1, #content do
			if content[i] then
				local currentWidth = dxGetTextWidth ( (content[i][1] or "" ) , 1 , "default") + 30
				if currentWidth > toBeDrawnWidth then
					toBeDrawnWidth = currentWidth
				end
				
				if i == 1 or content[i][7] == "title" then --Title
					if not BizNoteFont20 then
						BizNoteFont20 = dxCreateFont ( ":resources/Montserrat-Bold.ttf", 16 ) or "default-bold"
					end
					dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+10+posXOffset, (16*i)+posYOffset, toBeDrawnWidth-5, 15,
					tocolor (content[i][2] or HUD_R,content[i][3] or HUD_G,content[i][4] or HUD_B, content[i][5] or 255),
					1, BizNoteFont20 )
				else
					dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+10+posXOffset, (16*i)+posYOffset, toBeDrawnWidth-5, 15,
					tocolor ( content[i][2] or 255, content[i][3] or 255, content[i][4] or 255, content[i][5] or 255 ),
					content[i][6] or 1, content[i][7] or "default" )
				end
			end
		end
	end
end

function drawOverlayTopRight(info)
	if getElementData(localPlayer, 'loggedin') ~= 1 then return end

	local pinned = getElementData(localPlayer, "hud:pin")
	if not pinned and timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
	if info then
		content = info
		content[1][1] = string.sub(content[1][1], 1, 1)..string.sub(content[1][1], 2)
	else
		return false
	end
	
	posYOffset = 42

	if content then
		if not show then
			addEventHandler("onClientRender", root, renderOverlayTopRight)
			show = true
		end
	end
	
	toBeDrawnWidth = width

	playSoundFrontEnd ( 101 )
	if cooldownTime ~= 0 and not pinned then
		timerClose = setTimer(function()
			if show then
				removeEventHandler("onClientRender", root, renderOverlayTopRight)
				show = false
			end
		end, cooldownTime*1000, 1)
	end
	
	for i=1, #info do
		outputConsole(info[i][1] or "")
	end
end
addEvent("hudOverlay:drawOverlayTopRight", true)
addEventHandler("hudOverlay:drawOverlayTopRight", localPlayer, drawOverlayTopRight)

function pinIt()
	setElementData(localPlayer, "hud:pin", true, false)
	if timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
end

function unpinIt()
	pinIt()
	setElementData(localPlayer, "hud:pin", false, false)
	timerClose = setTimer(function()
		if show then
			removeEventHandler("onClientRender", root, renderOverlayTopRight)
			show = false
		end
	end, 3000, 1)
end

--TO DETECT CLICK ON DX BOX / MAXIME
addEventHandler( "onClientClick", root,
	function( button, state )
		if show and button == "left" and state == "up" then
			justClicked = true
		end
	end
)