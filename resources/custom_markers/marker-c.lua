local interiorData = setmetatable({}, {__mode = "k"})
local interiorDataLastSync = getTickCount()
local visibleInteriors = {}

local visibleMarkers = {}

local textures = {}
local markers = {}
local viewDistance = 30
local colors = {
    icon = tocolor(0, 255, 0),
    base = tocolor(0, 255, 0)
}
local sizes = {
    icon = 0.7,
    base = 0.8
}
local animation = {
    duration = 1000,
    easing = "InOutQuad",
    pulseMultiplier = 0.2
}
local icons = {
    ["base"] = "assets/base.png",
    "house",
    "garage",
    "biz",
    "block",
}

local getAnimatedValue = createAnimation(
    animation.duration,
    animation.easing,
    animation.pulseMultiplier
)

local function preloadTextures()
    table.foreach(icons, function(k, v)
        local name = k
        local path = v

        if type(k) == "number" then
            name = v
            path = strf("assets/icons/%s.png", v)
        end

        textures[name] = dxCreateTexture(path, "dxt5", false, "clamp")
    end)
end

local function drawMarkers()
    if type(visibleMarkers) ~= "table" then
        return
    end

    local x, y, z = getElementPosition(localPlayer)

    for i, marker in pairs(visibleMarkers) do
        local animatedValue = getAnimatedValue()
        local mx, my, mz = 
            marker.position.x,
            marker.position.y,
            marker.position.z

        if isElement(marker.colshape) then
            mx, my, mz = getElementPosition(marker.colshape)
            --if not marker.tickCount or getTickCount() - marker.tickCount >= 1000 then
                --[[ marker.groundPosition = getGroundPosition(
                    mx, my, mz
                )

                marker.tickCount = getTickCount() *]]
            --end
            --[[ if not marker.groundPosition then

            end *]]

            --local groundPosition = 0.03 + marker.groundPosition

            if isElement(textures[marker.icon]) then
                dxDrawMaterialLine3D(
                    mx, my, mz + sizes.icon + animatedValue - 0.3,
                    mx, my, mz + animatedValue - 0.3,
                    textures[marker.icon],
                    sizes.icon,
                    marker.iconColor or colors.icon
                )
            end
            
            local baseSize = sizes.base + animatedValue

            mz = mz - 0.9

            if isElement(textures["base"]) then
                dxDrawMaterialLine3D(
                    mx, my - baseSize / 2, mz,
                    mx, my + baseSize / 2, mz,
                    textures["base"],
                    baseSize,
                    marker.baseColor or colors.base,
                    false,
                    mx, my, mz + 1
                )
            end
        else
            deleteCustomMarker(marker.dbid)
        end
    end

    local animatedValue = getAnimatedValue()
    local lDimension = getElementDimension(localPlayer)
    local lInterior = getElementInterior(localPlayer)
    local px, py, pz = getElementPosition(localPlayer)

    if getTickCount() - interiorDataLastSync > 1000 then
        interiorDataLastSync, visibleInteriors = getTickCount(), {}

        for i, colshape in ipairs(getElementsByType("colshape")) do
            local pickup = getElementParent(colshape)

            if getElementType(pickup) == "interior" or getElementType(pickup) == "elevator" then
                local dimension = getElementDimension(colshape)
                local interior = getElementInterior(colshape)
    
                if lDimension == dimension and lInterior == interior then
                    local mx, my, mz = getElementPosition(colshape)
    
                    local distance = getDistanceBetweenPoints3D(px, py, pz, mx, my, mz)
    
                    if distance < viewDistance then
                        local data = getElementData(colshape, "customMarkerData", false)

                        if data then
                            data.iconColor = data.iconColor or tocolor(255, 255, 255, 150) -- Use the given value or set a default
                            data.baseColor = data.baseColor or tocolor(255, 255, 255, 150) -- Use the given value or set a default

                            if not data.disabled then
                                if data.owner == -1 and data.faction == 0 then
                                    data.iconColor = tocolor(255, 188, 30, 200)
                                end
                            else
                                data.iconColor = tocolor(255, 255, 255, 100)
                            end

                            if getElementData(pickup, "isForRent") and #getElementData(pickup, "tenants") < 2 then
                                data.iconColor = tocolor(188, 255, 188, 200)
                            end

                            table.insert(visibleInteriors, {
                                colshape = colshape,
                                data = data
                            })
                        end
                    end
                end
            end
        end
    end

    for i, interior in ipairs(visibleInteriors) do
        if isElement(interior.colshape) then
            local icon = interior.data.icon
            local iconColor = interior.data.iconColor
            local baseColor = interior.data.baseColor
    
            local mx, my, mz = getElementPosition(interior.colshape)
    
            if isElement(textures[icon]) then
                dxDrawMaterialLine3D(
                    mx, my, mz + sizes.icon + animatedValue - 0.3,
                    mx, my, mz + animatedValue - 0.3,
                    textures[icon],
                    sizes.icon,
                    iconColor or colors.icon
                )
            end
            
            local baseSize = sizes.base + animatedValue
    
            if isElement(textures["base"]) then
                mz = mz - 0.9
    
                dxDrawMaterialLine3D(
                    mx, my - baseSize / 2, mz,
                    mx, my + baseSize / 2, mz,
                    textures["base"],
                    baseSize,
                    baseColor or colors.base,
                    false,
                    mx, my, mz + 1
                )
            end
        end
    end
    
--[[     table.foreach(visibleMarkers, function(_, marker)
        local animatedValue = getAnimatedValue()
        local mx, my, mz = 
            marker.position.x,
            marker.position.y,
            marker.position.z
        
        local groundPosition = 0.03 + getGroundPosition(
            mx, my, mz
        )

        if isElement(textures[marker.icon]) then
            dxDrawMaterialLine3D(
                mx, my, mz + sizes.icon + animatedValue - 0.3,
                mx, my, mz + animatedValue - 0.3,
                textures[marker.icon],
                sizes.icon,
                marker.iconColor or colors.icon
            )
        end

        local baseSize = sizes.base + animatedValue

        if isElement(textures["base"]) then
            dxDrawMaterialLine3D(
                mx, my - baseSize / 2, groundPosition,
                mx, my + baseSize / 2, groundPosition,
                textures["base"],
                baseSize,
                marker.baseColor or colors.base,
                false,
                mx, my, groundPosition + 1
            )
        end
    end) *]]
end

local checked = getTickCount()

local function calculateVisibleMarkers()
    local period = 300

    local tick = getTickCount()
    local passed = tick - checked

    if passed >= period then
        visibleMarkers = getVisibleMarkers(localPlayer, markers, viewDistance)
        checked = tick
    end

    return visibleMarkers
end

function createCustomMarker(icon, position, colshape, dimension, interior, dbid, owner, disabled, faction, iconColor, baseColor)
    iconColor = iconColor or tocolor(255, 255, 255, 150) -- Use the given value or set a default
    baseColor = baseColor or tocolor(255, 255, 255, 150) -- Use the given value or set a default

    if not disabled then
        if owner == -1 and faction == 0 then
            iconColor = tocolor(255, 188, 30, 200)
        end
    else
        iconColor = tocolor(255, 255, 255, 100)
    end

    local marker = {
        icon = icon,
        position = position,
        colshape = colshape,
        dimension = dimension,
        interior = interior,
        iconColor = iconColor,
        baseColor = baseColor,
        dbid = dbid,
    }

    table.insert(markers, marker) -- Add the new marker to the list of markers
end

function deleteCustomMarker(dbid)
    for i = #markers, 1, -1 do
        local marker = markers[i]

        if marker.dbid == dbid then
            table.remove(markers, i)
        end
    end
    --[[ for index, marker in ipairs(markers) do
        if marker.dbid == dbid then
            table.remove(markers, index)
            break
        end
    end *]]
    visibleMarkers = calculateVisibleMarkers()
end
addEvent('deleteCustomMarker', true)
addEventHandler('deleteCustomMarker', getRootElement(), deleteCustomMarker)

function deleteCustomMarkers()
    markers = {}
    visibleMarkers = calculateVisibleMarkers()
end
addEvent('deleteCustomMarkers', true)
addEventHandler('deleteCustomMarkers', getRootElement(), deleteCustomMarkers)

addEventHandler("onClientResourceStart", resourceRoot, preloadTextures)
addEventHandler("onClientPreRender", root, calculateVisibleMarkers)

addEventHandler("onClientResourceStart", root,
    function(res)
        if getResourceName(res) == "hud" then
            if exports.hud:isActive(true) then
                removeEventHandler("onClientRender", root, drawMarkers)

                if exports.hud:isActive(true) then
                    addEventHandler("onClientRender", root, drawMarkers)
                else
                    removeEventHandler("onClientRender", root, drawMarkers)
                end
            end
        elseif res == resource then
            if getResourceFromName("hud") and getResourceState(getResourceFromName("hud")) == "running" then
                removeEventHandler("onClientRender", root, drawMarkers)

                if exports.hud:isActive(true) then
                    addEventHandler("onClientRender", root, drawMarkers)
                else
                    removeEventHandler("onClientRender", root, drawMarkers)
                end
            end
        end
    end
)

local function handleLocalPlayerDataChange(dataName, oldValue, newValue)
    if dataName == "hide_hud" then
        removeEventHandler("onClientRender", root, drawMarkers)

        if exports.hud:isActive(true) then
            addEventHandler("onClientRender", root, drawMarkers)
        else
            removeEventHandler("onClientRender", root, drawMarkers)
        end
    end
end
addEventHandler("onClientElementDataChange", localPlayer, handleLocalPlayerDataChange, false)