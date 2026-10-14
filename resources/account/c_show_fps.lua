local fps = 0
local nextTick = 0
local showing = false
local x, y = guiGetScreenSize()

local function updateFPS(msSinceLastFrame)
    -- FPS are the frames per second, so count the frames rendered per milisecond using frame delta time and then convert that to frames per second.
    local now = getTickCount()
    if (now >= nextTick) then
        fps = (1 / msSinceLastFrame) * 1000
        nextTick = now + 1000
    end
end
addEventHandler("onClientPreRender", root, updateFPS)

local function renderFPS()
	dxDrawText("FPS: " .. math.floor(fps), 5, y-100, 100, y-20, 0xaaffffff, 1, "default", "left", "bottom", false, false, false, true)
end

local function toggleFPSDisplay(cmd)
	if (showing) then
		removeEventHandler("onClientRender", root, renderFPS)
		showing = false
	else
		addEventHandler("onClientRender", root, renderFPS)
		showing = true
	end
end
addCommandHandler("showfps", toggleFPSDisplay, false)
addCommandHandler("fps", toggleFPSDisplay, false)
-- toggleFPSDisplay()