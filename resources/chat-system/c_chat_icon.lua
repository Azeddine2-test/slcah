-- Nando 07/01/2022

local IMG_COLOR = tocolor(255, 255, 255)
local TYPING_IMAGE = "chat.png"
local TYPING_DN = "chat:player_typing"

local playersTyping = {}
local showTypingIcons = true

local imTyping = false

local function isInputsActive()
	return (isChatBoxInputActive() or isConsoleActive())
end

function checkForChat()
	
    local chatBoxOpen = (
        (isInputsActive())
        and (getElementAlpha(localPlayer) == 255)
        and not getElementData(localPlayer, "freecam:state")
        and not getElementData(localPlayer, "reconx")
    )
    local syncChange = false

    if not imTyping and chatBoxOpen then
        syncChange = true
    elseif imTyping and not chatBoxOpen then
        syncChange = true
    end

    if (syncChange) then
        imTyping = chatBoxOpen
        setElementData(localPlayer, TYPING_DN, imTyping, true)
    end
end
setTimer(checkForChat, 200, 0)

function drawTypingIcons()
    if not showTypingIcons then return end

    local x,y,z = getElementPosition(localPlayer)
	local pint = getElementInterior(localPlayer)
	local pdim = getElementDimension(localPlayer)
	local reconx = getElementData(localPlayer, "reconx")

	for player, _ in pairs(playersTyping) do
		if (isElement(player)) then
            if getElementInterior(player) == pint and getElementDimension(player) == pdim then
                local px, py, pz = getPedBonePosition(player, 8)
                pz = pz + 0.27

                local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
                if isElementOnScreen(player) and ((dist <= 25) and (isLineOfSightClear(x,y,z,px,py,pz, true, false, false, true, false, false, false)) or reconx) then
                    local screenX, screenY = getScreenFromWorldPosition(px, py, pz)
                    if (screenX and screenY) then
                        dist = dist / 5
                            
                        if (dist<1) then dist = 1 end
                        if (dist>4 and reconx) then dist = 4 end

                        local width, height = 40 / dist, 40 / dist
                        screenX, screenY = screenX - width / 2, screenY - height / 2
                        
                        local draw = dxDrawImage(screenX, screenY, width, height, TYPING_IMAGE, 0, 0, 0, IMG_COLOR)
                    end
                end
            else
                playersTyping[player] = nil
            end
		else
			playersTyping[player] = nil
		end
	end
end
addEventHandler("onClientRender", root, drawTypingIcons)

function handleTypingDataChange(dn, oldValue, newValue)
    if dn ~= TYPING_DN then return end

    if newValue then
        playersTyping[source] = true
    else
        playersTyping[source] = nil
    end
end
addEventHandler("onClientElementDataChange", root, handleTypingDataChange)

function updateStreamedPlayers()
    for k, player in ipairs(getElementsByType("player", true)) do
        if player ~= localPlayer then
            local isTyping = getElementData(player, TYPING_DN)
            if isTyping then
                playersTyping[player] = true
            else
                playersTyping[player] = nil
            end
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, updateStreamedPlayers)

function applyClientConfigSettings()
	showTypingIcons = getElementData(localPlayer, 'graphic_typingicon') ~= "0"
    
    updateStreamedPlayers()
end
addEvent('accounts:settings:graphic_typingicon', false)
addEventHandler('accounts:settings:graphic_typingicon', root, applyClientConfigSettings)
addEventHandler('onClientResourceStart', resourceRoot, applyClientConfigSettings)
