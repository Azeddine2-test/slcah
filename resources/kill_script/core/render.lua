--[[
    Team:   	Southland
    Author:     Whiletruend
    Addon:		Complete Kill Script 
    Date:		08/05/2023
]]--

--[[----------------------------------------
    --> Base(s)
--]]----------------------------------------
SL = SL or {};
SL.KillScript = SL.KillScript or {};


--[[----------------------------------------
    --> Method(s)
--]]----------------------------------------
--@ Method: dxDrawBorderedText
--@ Description: Draw a bordered text on the screen
--@ Return: void
function SL.KillScript:dxDrawBorderedText(outline, text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    -- Check
    if not (outline and text and left and top and right and bottom and color and scale and font) then return end

    -- Variable(s)
    local width, height = right - left, bottom - top
    local half_outline = outline * 2;

    -- Loop
    for oX = -outline, outline do
        for oY = -outline, outline do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, 0xFF000000, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
        end
    end

    -- Draw
    dxDrawText(text, left, top, right, bottom, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

--@ Method: dxDrawTextOnElement
--@ Description: Draw a text on an element
--@ Return: void
function SL.KillScript:dxDrawTextOnElement(element, text, height, distance, red, green, blue, alpha, size, font, ...)
    --> Check
    if not element or not text or not height or not distance or not red or not green or not blue or not alpha or not size or not font then return; end;

    --> Variable(s)
    local x, y, z = getElementPosition(element);
    local x2, y2, z2 = getCameraMatrix();
    local distance = distance * 2 or 20;
    local height = height or 1;

    --> Condition(s)
    if isLineOfSightClear(x, y, z + 2, x2, y2, z2, ...) then
        --> Variable(s)
        local scr_x, scr_y = getScreenFromWorldPosition(x, y, z + height);

        --> Condition(s)
        if scr_x and scr_y then
            --> Variable(s)
            local calc_dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2);

            --> Condition(s)
            if calc_dist < distance then
                --> Variable(s)
                SL.KillScript:dxDrawBorderedText(
                    1,
                    tostring(text),
                    scr_x + 2,
                    scr_y + 2,
                    scr_x,
                    scr_y,
                    tocolor(red or 255, green or 255, blue or 255, alpha or 255),
                    size or 1,
                    font or "default-bold",
                    "center",
                    "center"
                );
            end;
        end;
    end;
end;