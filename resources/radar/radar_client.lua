local screenSx, screenSy = guiGetScreenSize()

local scalarX = math.min(math.max(screenSx / 1920, 0.6), 1)
local scalarY = math.min(math.max(screenSy / 1080, 0.6), 1)

local function getPedMaxHealth(ped)
    return math.max(1, 100 + (getPedStat(ped, 24) - 569) / 4.31)
end

local radar = {}

radar.marginX = uiEngine.math.roundToInt(57 * scalarX)
radar.marginY = uiEngine.math.roundToInt(80 * scalarY)
radar.size = uiEngine.math.roundToInt(251 * scalarY)
radar.borderSize = uiEngine.math.roundToInt(1 * scalarY)
radar.barGap = uiEngine.math.roundToInt(2 * scalarY)
radar.barSize = uiEngine.math.roundToInt(2 * scalarY)
radar.localPlayerBlipSizeX = uiEngine.math.roundToInt(13 * scalarY)
radar.localPlayerBlipSizeY = uiEngine.math.roundToInt(16 * scalarY)
radar.blipSizeX = uiEngine.math.roundToInt(20 * scalarY)
radar.blipSizeY = uiEngine.math.roundToInt(20 * scalarY)
radar.gpsLineWidth = uiEngine.math.roundToInt(4 * scalarY)
radar.zoneGap = uiEngine.math.roundToInt(20 * scalarY)
radar.healthStartAngle = uiEngine.math.roundToInt(-200 + radar.barGap / 2)
radar.healthEndAngle = uiEngine.math.roundToInt(60 - radar.barGap / 2)
radar.armorStartAngle = uiEngine.math.roundToInt(60 + radar.barGap / 2)
radar.armorEndAngle = uiEngine.math.roundToInt(160 - radar.barGap / 2)
radar.font1 = dxCreateFont("fonts/Montserrat-Regular.ttf", 12) or "default"
radar.font2 = dxCreateFont("fonts/Montserrat-Bold.ttf", 12) or "default"
radar.zoom = 0.5
radar.color1 = {0, 0, 0, 0.25}
radar.color2 = {123, 122, 122, 0.25}
radar.color3 = {255, 255, 255, 1}
radar.color4 = {255, 171, 45, 1}
radar.color5 = {255, 255, 255, 0.2}
radar.color6 = {255, 171, 45, 0.2}

radar.cubicbezierLinear = uiEngine.cubicbezier.linear()
radar.textures = {}

radar.images = {
    "images/circle251.png",
    "images/empty-circle251.png",
    "images/empty-circle257.png",
    "images/circle2.png",
    "images/localplayerblip13-16.png",
}

for i, v in ipairs(radar.images) do
    radar.textures[v] = dxCreateTexture(v, "argb", true, "clamp")
end

radar.textures["images/map.png"] = dxCreateTexture("images/map.png", "dxt5", true, "clamp")

function radar.create()
    if not radar.created then
        local function setCircleShaderAngles(circleShader, startAngleDeg, endAngleDeg)
            dxSetShaderValue(circleShader, "startAngle", math.rad(startAngleDeg % 361) - math.pi)
            dxSetShaderValue(circleShader, "endAngle", math.rad(endAngleDeg % 361) - math.pi)
        end

        local createCircleShader = function(texture, startAngleDeg, endAngleDeg)
            local circleShader = dxCreateShader(radar.circleShaderRawData)
    
            if isElement(circleShader) then
                dxSetShaderValue(circleShader, "tex", texture)
    
                setCircleShaderAngles(circleShader, startAngleDeg, endAngleDeg)
    
                return circleShader
            end
        end

        local isBarTexture = isElement(radar.textures["images/empty-circle257.png"])

        radar.renderer = uiEngine.animRect.create({
            x = radar.marginX + radar.barSize + radar.barGap,
            y = screenSy - radar.marginY - (radar.barSize + radar.barGap) - radar.size,
            sx = radar.size,
            sy = radar.size,
            alphaSpeed = 350,
            alphaCubicbezier = radar.cubicbezierLinear,
            customData = {
                --rt = dxCreateRenderTarget(radar.size, radar.size, true),
                healthShader = isBarTexture and createCircleShader(radar.textures["images/empty-circle257.png"], 0, 0),
                armorShader = isBarTexture and createCircleShader(radar.textures["images/empty-circle257.png"], 0, 0),
                healthBgShader = isBarTexture and createCircleShader(radar.textures["images/empty-circle257.png"], radar.healthStartAngle, radar.healthEndAngle),
                armorBgShader = isBarTexture and createCircleShader(radar.textures["images/empty-circle257.png"], radar.armorStartAngle, radar.armorEndAngle),
                mapShader = dxCreateShader("files/hud_mask.fx")
            }
        })

        local renderer = radar.renderer

        --[[ if isElement(renderer.customData.rt) then
            dxSetTextureEdge(renderer.customData.rt, "border", 0)
        end *]]

        if isElement(renderer.customData.mapShader) then
            do
                local texture = radar.textures["images/map.png"]

                if isElement(texture) then
                    dxSetShaderValue(renderer.customData.mapShader, "sPicTexture", texture)
                end
            end

            do
                local texture = radar.textures["images/circle251.png"]

                if isElement(texture) then
                    dxSetShaderValue(renderer.customData.mapShader, "sMaskTexture", texture)
                end
            end
        end

        renderer.customData.onRender = uiEngine.event.create({
            arg = renderer,
            eventName = "onClientRender",
            attachedTo = root,
            handlerFunction = function(object)
                if getElementInterior(localPlayer) > 0 --[[ or radarMegjelenitve *]] then 
                    return 
                end

                local alpha = object.alpha
    
                if alpha > 0 then
                    local x = object.position.x
                    local y = object.position.y

                    local size = radar.size

                    local zoomScaled = radar.zoom * scalarY
            
                    local centerX = uiEngine.math.roundToInt(x + size / 2)
                    local centerY = uiEngine.math.roundToInt(y + size / 2)
            
                    local ct = localPlayer--getCameraTarget() or getCamera()
                    --local ct = getElementType(ct) == "vehicle" and getVehicleOccupant(ct) or ct
                    local ctx, cty, ctz = getElementPosition(ct)
                    local cx, cy, cz, clx, cly, clz = getCameraMatrix()

                    local cameraRotation = uiEngine.math.getRotationBetweenPoints2D(cx, cy, clx, cly, 0)

                    do
                        local shader = object.customData.mapShader

                        if isElement(shader) then
                            local scale = (size / 6000) * (1 / zoomScaled)

                            dxSetShaderValue(shader, "gUVPosition", ctx / 6000, cty / -6000)
                            dxSetShaderValue(shader, "gUVScale", scale, scale)
                            dxSetShaderValue(shader, "gUVRotAngle", math.rad(-cameraRotation))

                            uiEngine.render.drawImageAligned(centerX, centerY, size, size, shader, 0, 0, 0, tocolor(255, 255, 255, alpha * 0.5), false, false, "center", "center")
                        end
                    end

                    do
                        local texture = radar.textures["images/circle251.png"]

                        if isElement(texture) then
                            local r, g, b, a = unpack(radar.color1)

                            uiEngine.render.drawImageAligned(centerX, centerY, size, size, texture, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                        end
                    end

                    do
                        local texture = radar.textures["images/empty-circle251.png"]

                        if isElement(texture) then
                            local r, g, b, a = unpack(radar.color2)

                            uiEngine.render.drawImageAligned(centerX, centerY, size, size, texture, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                        end
                    end

                    if getElementType(ct) == "player" then
                        local offset = (radar.barGap + radar.barSize) * 2
                        
                        local x = x - offset / 2
                        local y = y - offset / 2
                        local size = radar.size + offset

                        local barRoundDistance = radar.size / 2 + offset / 2 - radar.barSize / 2

                        do
                            local shader = object.customData.healthBgShader
    
                            if isElement(shader) then
                                local r, g, b, a = unpack(radar.color5)
                                
                                uiEngine.render.drawImageAligned(centerX, centerY, size, size, shader, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                            end
                        end

                        do
                            local shader = object.customData.armorBgShader
    
                            if isElement(shader) then
                                local r, g, b, a = unpack(radar.color6)
                                
                                uiEngine.render.drawImageAligned(centerX, centerY, size, size, shader, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                            end
                        end

                        do
                            local shader = object.customData.healthShader
    
                            if isElement(shader) then
                                local r, g, b, a = unpack(radar.color3)
    
                                local healthValue = uiEngine.math.clamp(getElementHealth(ct) / 150--[[ getPedMaxHealth(ct) *]], 0, 1)
                                local endAngle = uiEngine.math.reMap(healthValue, 0, 1, radar.healthStartAngle, radar.healthEndAngle)
    
                                setCircleShaderAngles(shader, radar.healthStartAngle - 1, endAngle)
    
                                uiEngine.render.drawImageAligned(centerX, centerY, size, size, shader, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
    
                                if healthValue > 0 then
                                    local texture = radar.textures["images/circle2.png"]
    
                                    if isElement(texture) then
                                        do
                                            local x, y = uiEngine.math.getPositionFromDistanceRotation2D(centerX, centerY, barRoundDistance, radar.healthStartAngle - 90)
        
                                            uiEngine.render.drawImageAligned(x, y, radar.barSize, radar.barSize, texture, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                                        end

                                        do
                                            local x, y = uiEngine.math.getPositionFromDistanceRotation2D(centerX, centerY, barRoundDistance, endAngle - 90)

                                            uiEngine.render.drawImageAligned(x, y, radar.barSize, radar.barSize, texture, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                                        end
                                    end
                                end
                            end
                        end
    
                        do
                            local shader = object.customData.armorShader
    
                            if isElement(shader) then
                                local r, g, b, a = unpack(radar.color4)
    
                                local armorValue = uiEngine.math.clamp(getPedArmor(ct) / 100, 0, 1)
                                local endAngle = uiEngine.math.reMap(armorValue, 0, 1, radar.armorStartAngle, radar.armorEndAngle)
    
                                setCircleShaderAngles(shader, radar.armorStartAngle, endAngle)
    
                                uiEngine.render.drawImageAligned(centerX, centerY, size, size, shader, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")

                                if armorValue > 0 then
                                    local texture = radar.textures["images/circle2.png"]
    
                                    if isElement(texture) then
                                        do
                                            local x, y = uiEngine.math.getPositionFromDistanceRotation2D(centerX, centerY, barRoundDistance, radar.armorStartAngle - 90)
        
                                            uiEngine.render.drawImageAligned(x, y, radar.barSize, radar.barSize, texture, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                                        end

                                        do
                                            local x, y = uiEngine.math.getPositionFromDistanceRotation2D(centerX, centerY, barRoundDistance, endAngle - 90)

                                            uiEngine.render.drawImageAligned(x, y, radar.barSize, radar.barSize, texture, 0, 0, 0, tocolor(r, g, b, alpha * a), false, false, "center", "center")
                                        end
                                    end
                                end
                            end
                        end
                    end

                    do
                        local ux, uy = nil, nil

                        local lineWidth = radar.gpsLineWidth * zoomScaled

                        for k, v in ipairs(gpsPontok) do
                            local ex, ey = v.x, v.y

                            local distanceToElement = getDistanceBetweenPoints2D(ctx, cty, ex, ey)
                            local distance = distanceToElement * zoomScaled

                            if distance <= size / 2 then
                                local lx, ly = uiEngine.math.getPositionFromDistanceRotation2D(centerX, centerY, distance, cameraRotation - uiEngine.math.getRotationBetweenPoints2D(ctx, cty, ex, ey, 90))

                                if ux and uy then
                                    dxDrawLine(ux, uy, lx, ly, tocolor(255, 0, 0, alpha), lineWidth)
                                end

                                ux, uy = lx, ly
                            end
                        end
                    end

                    do
                        local blipSizeX = radar.blipSizeX
                        local blipSizeY = radar.blipSizeY

                        local localPlayerDimension = getElementDimension(localPlayer)
                        local localPlayerInterior = getElementDimension(localPlayer)

                        for i, v in ipairs(getElementsByType("blip")) do
                            local ex, ey = getElementPosition(v)
                            local actualDist = getDistanceBetweenPoints2D(ctx, cty, ex, ey)
                            local maxDist = getBlipVisibleDistance(v)
                        
                            if actualDist <= maxDist and getElementDimension(v) == localPlayerDimension and getElementInterior(v) == localPlayerInterior then
                                local blipIcon = getBlipIcon(v)
                                local bcR, bcG, bcB = 255, 255, 255

                                if blipIcon == 0 then
                                    bcR, bcG, bcB = getBlipColor(v)
                                end

                                if not (blipIcon == 0 and (((bcR == 255 and bcG == 63 and bcB == 63) or (bcR == 127 and bcG == 255 and bcB == 63) or (bcR == 255 and bcG == 255 and bcB == 63)) and getBusStopsHiddenValue() == 0)) then
                                    local bid = getElementData(v, "sajatIkon") or blipIcon
                                    local _, _, _, bcA = getBlipColor(v)
                                    local bcR, bcG, bcB = 255, 255, 255

                                    if blipIcon == 0 then
                                        bcR, bcG, bcB = getBlipColor(v)
                                    end

                                    local textureName = "blip" .. tostring(bid)

                                    if not isElement(radar.textures[textureName]) then
                                        radar.textures[textureName] = dxCreateTexture("blips/"..bid..".png", "argb", true, "clamp")
                                    end

                                    local distanceToElement = getDistanceBetweenPoints2D(ctx, cty, ex, ey)
                                    local blipX, blipY = uiEngine.math.getPositionFromDistanceRotation2D(centerX, centerY, math.min(distanceToElement * zoomScaled, size / 2 - math.max(blipSizeX, blipSizeY) / 2 - 5), cameraRotation - uiEngine.math.getRotationBetweenPoints2D(ctx, cty, ex, ey, 90))

                                    uiEngine.render.drawImageAligned(blipX, blipY, blipSizeX, blipSizeY, radar.textures[textureName], blipRotation, 0, 0, tocolor(bcR, bcG, bcB, alpha * bcA / 255), false, false, "center", "center")
                                end
                            end
                        end

                        for i = 1, #created_custom_blips do
                            local customBlip = created_custom_blips[i]
                            local ex, ey = customBlip.x, customBlip.y
                            local actualDist = getDistanceBetweenPoints2D(ctx, cty, ex, ey)
                            local maxDist = customBlip.visibleDistance
                            
                            if actualDist <= (maxDist or 350) and customBlip.dimension == localPlayerDimension and customBlip.interior == localPlayerInterior then
                                local bid = customBlip.icon
                                local bcR, bcG, bcB, bcA = getCustomBlipColor(i)
                                
                                local textureName = "blip" .. tostring(bid)

                                if not isElement(radar.textures[textureName]) then
                                    radar.textures[textureName] = dxCreateTexture("blips/"..bid..".png", "argb", true, "clamp")
                                end

                                local distanceToElement = getDistanceBetweenPoints2D(ctx, cty, ex, ey)
                                local blipX, blipY = uiEngine.math.getPositionFromDistanceRotation2D(centerX, centerY, math.min(distanceToElement * zoomScaled, size / 2 - math.max(blipSizeX, blipSizeY) / 2 - 5), cameraRotation - uiEngine.math.getRotationBetweenPoints2D(ctx, cty, ex, ey, 90))

                                uiEngine.render.drawImageAligned(blipX, blipY, blipSizeX, blipSizeY, radar.textures[textureName], blipRotation, 0, 0, tocolor(bcR, bcG, bcB, alpha * bcA / 255), false, false, "center", "center")
                            end
                        end
                    end

                    do
                        local texture = radar.textures["images/localplayerblip13-16.png"]

                        if isElement(texture) then
                            local ctMatrix2 = getElementMatrix(ct)[2]
                
                            local rotation = cameraRotation - uiEngine.math.getRotationBetweenPoints2D(ctx + ctMatrix2[1], cty + ctMatrix2[2], ctx, cty, -180)

                            uiEngine.render.drawImageAligned(centerX, centerY, radar.localPlayerBlipSizeX, radar.localPlayerBlipSizeY, texture, rotation, 0, 0, tocolor(255, 255, 255, alpha), false, true, "center", "center")
                        end
                    end

                    if object.alphaState then
                        local cityName = getZoneName(ctx, cty, ctz, false)
                        local islandx, islandy = 4440.701171875, 1716.4150390625

                        if cityName == "Unknown" and getDistanceBetweenPoints2D(islandx, islandy, ctx, ctz) < 500 then 
                            cityName = "San Andreas Coast" 
                        end

                        local zoneName = exports.gps:getPlayerStreetLocation(ct) or "Unknown"

                        local updateAnim = false

                        if radar.zoneRenderer.customData.cityName ~= cityName then
                            radar.zoneRenderer.customData.cityName = cityName

                            updateAnim = true
                        end

                        if radar.zoneRenderer.customData.zoneName ~= zoneName then
                            radar.zoneRenderer.customData.zoneName = zoneName

                            updateAnim = true
                        end

                        if updateAnim then
                            uiEngine.animRect.setAlphaState(radar.zoneRenderer, nil)
                            uiEngine.animRect.setAlphaAnimationState(radar.zoneRenderer, true)
                        end
                    end
                end
            end
        })

        uiEngine.event.addEventHandler(renderer.customData.onRender)

        radar.zoneRenderer = uiEngine.animRect.create({
            x = radar.renderer.position.x + radar.size / 2,
            y = radar.renderer.position.y + radar.size + radar.zoneGap,
            sx = 0,
            sy = 0,
            alphaSpeed = radar.renderer.alphaAnimation.speed,
            alphaCubicbezier = radar.renderer.alphaAnimation.cubicbezier,
            customData = {}
        })

        local zoneRenderer = radar.zoneRenderer

        zoneRenderer.customData.onRender = uiEngine.event.create({
            arg = zoneRenderer,
            eventName = "onClientRender",
            attachedTo = root,
            handlerFunction = function(object)
                if getElementInterior(localPlayer) > 0 --[[ or radarMegjelenitve *]] then 
                    return 
                end

                local alpha = object.alpha
    
                if alpha > 0 then
                    local x = object.position.x
                    local y = object.position.y

                    if object.customData.cityName then
                        dxDrawText(object.customData.cityName, x, y, x, y, tocolor(255, 255, 255, alpha), 1 * scalarY, radar.font2, "center")
                    end

                    if object.customData.zoneName then
                        local y = y + uiEngine.math.roundToInt(20 * scalarY)

                        dxDrawText(object.customData.zoneName, x, y, x, y, tocolor(255, 255, 255, alpha), 1 * scalarY, radar.font1, "center")
                    end
                end
            end
        })

        uiEngine.event.addEventHandler(zoneRenderer.customData.onRender)

        radar.created = true
    end
end

function radar.destroy()
    if radar.created then
        uiEngine.animRect.destroy(radar.renderer)
        uiEngine.animRect.destroy(radar.zoneRenderer)

        radar.created = nil
    end
end

function radar.setState(state)
    if radar.created then
        uiEngine.animRect.setAlphaAnimationState(radar.renderer, state)
        uiEngine.animRect.setAlphaAnimationState(radar.zoneRenderer, state)
    end
end

radar.circleShaderRawData = [[
    texture tex;

    float startAngle = -3.14;
    float endAngle = 3.14;

    sampler Sampler0 = sampler_state
    {
        Texture = (tex);
    };

    float4 PixelShaderFunction(float2 coords: TEXCOORD0, float4 diffuse: COLOR0) : COLOR0   
    {
        float2 uv = float2(coords.x, coords.y) - float2(0.5, 0.5);

        float angle = atan2(-uv.x, uv.y);

        if (startAngle > endAngle)
        {
            if (angle < startAngle && angle > endAngle)
                return 0;
        }
        else
        {
            if (angle < startAngle || angle > endAngle)
                return 0;
        }

        return tex2D(Sampler0, coords) * diffuse;
    }
    
    technique circle
    {
        pass Pass0
        {
            PixelShader = compile ps_2_0 PixelShaderFunction();
        }
    }

    technique fallback
    {
        pass Pass0
        {

        }
    } 
]]

newRadar = radar

radar.create()
--radar.setState(true)
--setElementHealth(localPlayer, 25)
--setPedArmor(localPlayer, 50)

