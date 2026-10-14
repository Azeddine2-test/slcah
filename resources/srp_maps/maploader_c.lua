--[[
    Southland Roleplay Map Loader

    Author: Fernando
    Created: 13/03/2023
]]

local INVIS_TEXTURES = {
    ["invisible"] = true, -- SAMP https://dev.prineside.com/en/gtasa_samp_game_texture/view/signsurf/
    ["sign"] = true, -- SAMP https://dev.prineside.com/en/gtasa_samp_game_texture/view/signsurf/
}

local RAW_INVISIBLE_SHADER = [[
    struct VS_INPUT
    {
        float4 Position        : POSITION;
    };

    struct PS_INPUT
    {
        float4 Position : POSITION;
    };

    VS_INPUT main_vs(in VS_INPUT IN)
    {
        PS_INPUT OUT;
        OUT.Position = 0;
        return OUT;
    }

    technique
    {
        pass P0
        {
            VertexShader = compile vs_2_0 main_vs(); 
        }
    }
]]

local invisibleTextureShader = dxCreateShader(RAW_INVISIBLE_SHADER, 0, 100, false, "object")

local DESTROY_TEXTURES_EVERY = 1000 * 60 * 2 -- ms
local texDestroyTimer = nil
local objectTextures = {}
local texCache = {}

local lastObject = nil

local loadedMaps = {}

local function loadCustomTextureOnObject(object, customTexture)
    local oTexname = customTexture.texName
    if not oTexname then
        return
    end
    local texPath = customTexture.texPath
    if not texPath then
        return
    end
    objectTextures[lastObject] = objectTextures[lastObject] or {}
    objectTextures[lastObject][#objectTextures[lastObject] + 1] = {
        texmodel = nil,
        texname = texPath,
        oTexname = oTexname,
        tex = nil,
        shader = nil
    }
end

local function createOneObject(mapName, v, forceDimension)
    local basemodelid
    local isCustom, mod, modType = exports["newmodels"]:isCustomModID(v.model, true)
    if isCustom then
        basemodelid = mod.base_id
    else
        basemodelid = v.model
    end

    for i, v in pairs(objectLODs) do
        if v == tonumber(basemodelid) then
            return
        end
    end

    local o = createObject(basemodelid, v.x, v.y, v.z, v.rx, v.ry, v.rz)

    if not o then
        outputDebugString("Failed to create object model " .. v.model .. " at " .. v.x .. ", " .. v.y .. ", " .. v.z .. " (" .. mapName .. ")", 1)
        return
    end

    if isCustom then
        setElementData(o, "objectID", v.model)
    end

    if v.interior then
        setElementInterior(o, v.interior)
    end
    local dimension = forceDimension or v.dimension
    if dimension then
        setElementDimension(o, dimension)
    end
    if v.scale then
        setObjectScale(o, v.scale)
    end
    if v.alpha then
        setElementAlpha(o, v.alpha)
    end
    if v.collisions then
        setElementCollisionsEnabled(o, v.collisions)
    end
    if v.doublesided then
        setElementDoubleSided(o, v.doublesided)
    end
    if v.breakable then
        setObjectBreakable(o, v.breakable)
    end
    if v.frozen then
        setElementFrozen(o, v.frozen)
    end
    if v.customTexture then
        --loadCustomTextureOnObject(o, v.customTexture)
    end
    engineSetModelLODDistance(basemodelid, 300)
    if v.lod then
        local lodElement = createObject(v.lod, 0, 0, 0, 0, 0, 0, true)

        setElementInterior(lodElement, getElementInterior(o))
        setElementDimension(lodElement, getElementDimension(o))
        setElementPosition(lodElement, getElementPosition(o))
        setElementRotation(lodElement, getElementRotation(o))
        setElementCollisionsEnabled(lodElement, false)
        setElementAlpha(lodElement, getElementAlpha(o))
        setElementDoubleSided(lodElement, isElementDoubleSided(o))
        setObjectScale(lodElement, getObjectScale(o))

        setElementParent(lodElement, o)
        setLowLODElement(o, lodElement)

        engineSetModelLODDistance(v.lod, 300)
    end
    return o
end

local function removeOneObject(mapName, v)
    if removeWorldModel(v.model, v.radius, v.x, v.y, v.z, v.interior) then
        return {v.model, v.radius, v.x, v.y, v.z, v.interior}
    end
end

local function getTextureNameFromIndex(model, index)
    local modelName = engineGetModelNameFromID(model) or nil
    if not modelName then
        outputDebugString("SRP_MAPS: Failed to get model name for model " .. model, 1)
        return
    end
    modelName = string.lower(modelName)..".dff"
    local info = SA_MATLIB[modelName]
    if not info then
        outputDebugString("SRP_MAPS: "..modelName.." ("..model..") is not in SA_MATLIB", 1)
        return
    end
    for _, val in ipairs(info) do
        if val.index == index then
            return val.name
        end
    end
    -- outputDebugString("SRP_MAPS: "..index.." is not an index for "..modelName.." ("..model..")", 1)
end

local function getTextureFromModelAndName(model, name)
    local textures = engineGetModelTextures(model, {name}) or nil
    if not textures then return end
    for _, texture in pairs(textures) do
        return texture
    end
end

local function getCustomTexture(texPath)
    local tex = dxCreateTexture(texPath)
    if not tex then
        return
    end
    return tex
end

local function loadOneObjectTexture(mapName, v)
    if not lastObject then return end
    local oModel = getElementData(lastObject, "objectID") or getElementModel(lastObject)
    if not oModel then return end
    local index = v.index -- Number
    local oTexname = getTextureNameFromIndex(oModel, index)
    if not oTexname then
        return
    end
    local model = v.model -- Number
    local texname = v.texname -- String
    local color = v.color -- String
    local a,r,g,b
    if type(color) == "string" and string.match(color, "0x") ~= nil then
        color = string.gsub(color, "0x", "#")
        local a1,r1,g1,b1 = getColorFromString(color)
        if a1 and not (a1==0 and r1==0 and g1==0 and b1==0) then
            a,r,g,b = a1,r1,g1,b1
        end
    end
    if not (texname == "none" or model == -1) then
        local tex = getTextureFromModelAndName(model, texname)
        if not tex then
            outputDebugString("Failed to get texture " .. texname .. " from model " .. model, 2)
            return
        end
        destroyElement(tex)
    end
    objectTextures[lastObject] = objectTextures[lastObject] or {}
    objectTextures[lastObject][#objectTextures[lastObject] + 1] = {
        texmodel = model,
        texname = texname,
        oTexname = oTexname,
        colorR = r,
        colorG = g,
        colorB = b,
        colorA = a,
        tex = nil,
        shader = nil
    }
    -- TEMP
    --[[
    local mat_info = getElementData(lastObject, "material_info") or {}
    table.insert(mat_info, {
        mat_index = index,
        tex_name = texname,
        target_tex_name = oTexname
    })
    setElementData(lastObject, "material_info", mat_info, false)
    --]]
end

local function loadOneObjectTextureText(mapName, v)
    local index = v.index -- Number
    local text = v.text -- String
    local size = v.size -- Table [width, height]
    local font = v.font -- String
    local fontSize = v.fontSize -- Number
    local bold = v.bold -- Number 0/1
    local fontColor = v.fontColor -- Number
    local backColor = v.backColor -- Number
    local align = v.align -- String
    -- TODO
end

local function applyTexturesOnObject(o)
    if not objectTextures[o] then return end
    for k, v in pairs(objectTextures[o]) do
        if not (isElement(v.shader)) then
            local tex
            if isElement(v.tex) then
                tex = v.tex
            end
            if (not tex) and (not (v.texname == "none" or v.model == -1)) then
                if not texCache[v.texname] then
                    if v.texmodel then
                        tex = getTextureFromModelAndName(v.texmodel, v.texname)
                    else
                        tex = getCustomTexture(v.texname)
                    end
                    texCache[v.texname] = tex
                else
                    tex = texCache[v.texname]
                end
            end
            local shader
            local noDestroy = false
            if INVIS_TEXTURES[v.texname] or (not tex) then
                shader = invisibleTextureShader
                noDestroy = true
            else
                shader = dxCreateShader("replace-tex.fx", 0, 100, false, "object")
                if shader then
                    if v.colorR then
                        local r,g,b,a = v.colorR, v.colorG, v.colorB, v.colorA
                        dxSetShaderValue(shader, "gRed", r/255)
                        dxSetShaderValue(shader, "gGreen", g/255)
                        dxSetShaderValue(shader, "gBlue", b/255)
                        dxSetShaderValue(shader, "gAlpha", a/255)
                    end
                    if tex then
                        dxSetShaderValue(shader, "gTexture", tex)
                    end
                end
            end
            if shader then
                engineApplyShaderToWorldTexture(shader, v.oTexname, o)
                objectTextures[o][k].texname = v.texname
                objectTextures[o][k].tex = tex
                objectTextures[o][k].shader = shader
                objectTextures[o][k].noDestroy = noDestroy
            end
        end
    end
end

local function destroyTexturesOnObject(o, oTexname)
    if not objectTextures[o] then return end

    local texturesToDestroy = {}
    for k, v in pairs(objectTextures[o]) do
        if ((not oTexname) or (oTexname and oTexname == v.oTexname)) and isElement(v.shader) then
            engineRemoveShaderFromWorldTexture(v.shader, v.oTexname, o)
            if not v.noDestroy then
                destroyElement(v.shader)
                objectTextures[o][k].shader = nil
            end
            if isElement(v.tex) then
                texturesToDestroy[v.texname] = true
            end
        end
    end

    for texName, _ in pairs(texturesToDestroy) do
        local texUsed = false
        for obj, texs in pairs(objectTextures) do
            for k, v in pairs(texs) do
                if v.texname == texName and isElement(v.shader) then
                    texUsed = true
                    break
                end
            end
        end
        if not texUsed then
            for texname2, tex2 in pairs(texCache) do
                if texname2 == texName then
                    destroyElement(tex2)
                    texCache[texname2] = nil
                    break
                end
            end
            for obj, texs in pairs(objectTextures) do
                for k, v in pairs(texs) do
                    if v.texname == texName and isElement(v.shader) then
                        objectTextures[obj][k].tex = nil
                    end
                end
            end
        end
    end
end

local function handleElementDestroy()
    if source and getElementType(source) == "object" then
        destroyTexturesOnObject(source)
    end
end
addEventHandler("onClientElementDestroy", resourceRoot, handleElementDestroy)

local function applyStreamedInObjectTextures()
    for _, o in ipairs(getElementsByType("object")) do
        if isElementStreamedIn(o) then
            applyTexturesOnObject(o)
        end
    end
end

local function handleElementStreamIn()
    if source and getElementType(source) == "object" then
        applyTexturesOnObject(source)
    end
end
addEventHandler("onClientElementStreamIn", resourceRoot, handleElementStreamIn)

local function initTextureDestroyerTimer()
    if isTimer(texDestroyTimer) then return end
    texDestroyTimer = setTimer(function()
        for o, _ in pairs(objectTextures) do
            if not isElementStreamedIn(o) then
                destroyTexturesOnObject(o)
            end
        end
    end, DESTROY_TEXTURES_EVERY, 0) 
end

function loadOneMap(mapName, mapContent, forceDimension)
    loadedMaps[mapName] = {}
    for i, v in ipairs(mapContent) do
        if v.f == "object" then
            -- spawns new object
            local o = createOneObject(mapName, v.variables, forceDimension)
            lastObject = o
            if o then
                table.insert(loadedMaps[mapName], {
                    k="object",
                    v=o
                })
            end
        elseif v.f == "remove" then
            -- removes model from world
            local rpos = removeOneObject(mapName, v.variables)
            if rpos then
                table.insert(loadedMaps[mapName], {
                    k="remove",
                    v=rpos
                })
            end
        elseif v.f == "material" then
            -- applies on last object
            loadOneObjectTexture(mapName, v.variables)
        elseif v.f == "materialtext" then
            -- applies on last object
            loadOneObjectTextureText(mapName, v.variables)
        end
    end
    lastObject = nil
    if eventName ~= "srp_maps:loadAllMaps" then
        setTimer(applyStreamedInObjectTextures, 1000, 1)
    end
    return true
end

function updateMapDimension(mapName, dimension)
    if not loadedMaps[mapName] then return end
    for i, v in ipairs(loadedMaps[mapName]) do
        if v.k == "object" then
            if isElement(v.v) then
                if getElementDimension(v.v) == dimension then return true end
                setElementDimension(v.v, dimension)
            end
        end
    end
    return true
end

function unloadOneMap(mapName)
    if not loadedMaps[mapName] then return end
    for i, v in ipairs(loadedMaps[mapName]) do
        if v.k == "object" then
            if isElement(v.v) then
                destroyElement(v.v)
                objectTextures[v.v] = nil
            end
        elseif v.k == "remove" then
            local model = v.v[1]
            local radius = v.v[2]
            local x = v.v[3]
            local y = v.v[4]
            local z = v.v[5]
            local interior = v.v[6]
            restoreWorldModel(model, radius, x, y, z, interior)
        end
    end
    loadedMaps[mapName] = nil
    return true
end

local function unloadAllMaps()
    for mapName, _ in pairs(loadedMaps) do
        unloadOneMap(mapName)
    end
end
addEventHandler("onClientResourceStop", resourceRoot, unloadAllMaps, false)

function isMapLoaded(mapName)
    return loadedMaps[mapName] ~= nil
end

function getMapContent(path, mapEncodeKey)
    local content = {}

    if fileExists("cache/" .. path) then
        local file = fileOpen("cache/" .. path, true)

        if file then
            local data = fileRead(file, fileGetSize(file))

            fileClose(file)

            local fileContent = fromJSON(decodeString("tea", data, {
                key = mapEncodeKey
            }))

            if fileContent then
                content = fileContent
            end
        end
    end

    return content
end

local function loadAllMaps(list, mapEncodeKey)
    unloadAllMaps()
    for i, map in ipairs(list) do
        --loadOneMap(map.name, map.content)
        loadOneMap(map.name, getMapContent(map.path, mapEncodeKey))
    end
    initTextureDestroyerTimer()
    applyStreamedInObjectTextures()
end
--addEvent("srp_maps:loadAllMaps", true)
--addEventHandler("srp_maps:loadAllMaps", localPlayer, loadAllMaps, false)

local function handleModListUpdated()
    --triggerServerEvent("srp_maps:requestReloadMaps", resourceRoot)
    triggerServerEvent("srp_maps:mapLoadGetChecksums", localPlayer)
end
--addEventHandler("accounts:onPlayerLogin", localPlayer, handleModListUpdated, false)
addEventHandler("newmodels:onModListReceived", localPlayer, handleModListUpdated, false)

addEvent("srp_maps:mapLoadValidateChecksums", true)
addEventHandler("srp_maps:mapLoadValidateChecksums", localPlayer,
    function(mapsToValidate, mapEncodeKey)
        local mapsToDownload = {}

        for path, checksum in pairs(mapsToValidate) do
            local isValid = false

            if fileExists("cache/" .. path) then
                local file = fileOpen("cache/" .. path, true)

                if file then
                    local content = fileRead(file, fileGetSize(file))

                    fileClose(file)

                    if md5(content) == checksum then
                        isValid = true
                    end
                end
            end

            if not isValid then
                mapsToDownload[path] = true
            end
        end

        if next(mapsToDownload) then
            triggerServerEvent("srp_maps:mapLoadDownloadMaps", localPlayer, mapsToDownload)
        else
            triggerServerEvent("srp_maps:mapLoadGetData", localPlayer)
        end
    end
)

addEvent("srp_maps:mapLoadSaveMaps", true)
addEventHandler("srp_maps:mapLoadSaveMaps", localPlayer,
    function(mapsToSave, mapEncodeKey)
        for path, contentJSON in pairs(mapsToSave) do
            if fileExists("cache/" .. path) then
                fileDelete("cache/" .. path)
            end

            local file = fileCreate("cache/" .. path)

            if file then
                fileWrite(file, encodeString("tea", contentJSON, {
                    key = mapEncodeKey
                }))

                fileClose(file)
            end
        end

        triggerServerEvent("srp_maps:mapLoadGetData", localPlayer)
    end
)

addEvent("srp_maps:loadMaps", true)
addEventHandler("srp_maps:loadMaps", localPlayer,
    function(mapsData, mapEncodeKey)
        local mapsToLoad, interiorsToLoad = {}, {}

        for i, map in ipairs(mapsData) do
            if not map.interiorValues then
                table.insert(mapsToLoad, map)
            else
                table.insert(interiorsToLoad, map)
            end
        end

        if #mapsToLoad > 0 then
            loadAllMaps(mapsToLoad, mapEncodeKey)
        end

        if #interiorsToLoad > 0 then
            prepareAllInteriors(interiorsToLoad, mapEncodeKey)
        end
    end
)


--[[
    Author: Fernando
    Script: client.lua
    Commands (clientside):
        - /tdo: test draw objects
]]


local tmatDrawing = false
function togDrawMaterials()
    tmatDrawing = not tmatDrawing
    outputChatBox("Displaying custom object materials: "..(tmatDrawing and "Yes" or "No"), 50,255,50)

    if tmatDrawing then
        addEventHandler( "onClientRender", root, drawObjects)
    else
        removeEventHandler( "onClientRender", root, drawObjects)
    end
end
-- addCommandHandler("tmats", togDrawMaterials, false)

function drawObjects()

    local px,py,pz = getElementPosition(localPlayer)
    local int,dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
    local lx, ly, lz = getCameraMatrix()

    for k, obj in ipairs(getElementsWithinRange(px,py,pz, 35, "object")) do

        local i,d = getElementInterior(obj), getElementDimension(obj)
        if d == dim and i == int then
            local x,y,z = getElementPosition(obj)

            local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, x,y,z,
            false, false, false, false, false, false, false, true, obj)

            if not collision then

                local dx, dy, distance = getScreenFromWorldPosition(x,y,z)
                if dx and dy then
                    dy = dy+20

                    local text
                    local mat_info = getElementData(obj, "material_info") or false
                    if mat_info then
                        text = "ID "..getElementModel(obj).."\n"
                        local temp = ""
                        for k, mat in pairs(mat_info) do
                            temp=temp.."["..mat.mat_index.."] "..mat.target_tex_name.." => "..mat.tex_name.."\n"
                        end
                        text = text..temp
                    end

                    if text then
                        dxDrawText(text, dx, dy, dx, dy, "0xffffa200", 1, "default", "center")
                    end
                end
            end
        end
    end
end

local tobjDrawing = false
function togDrawObjects()
    tobjDrawing = not tobjDrawing
    outputChatBox("Displaying objects: "..(tobjDrawing and "Yes" or "No"), 50,255,50)

    if tobjDrawing then
        addEventHandler( "onClientRender", root, drawObjects2)
    else
        removeEventHandler( "onClientRender", root, drawObjects2)
    end
end
addCommandHandler("tobjs", togDrawObjects, false)

function drawObjects2()
    
    local px,py,pz = getElementPosition(localPlayer)
    local int,dim = getElementInterior(localPlayer), getElementDimension(localPlayer)
    local lx, ly, lz = getCameraMatrix()

    for k, obj in ipairs(getElementsWithinRange(px,py,pz, 35, "object")) do

        local i,d = getElementInterior(obj), getElementDimension(obj)
        if d == dim and i == int then
            local x,y,z = getElementPosition(obj)

            local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, x,y,z,
            false, false, false, false, false, false, false, true, obj)

            if not collision then

                local dx, dy, distance = getScreenFromWorldPosition(x,y,z)
                if dx and dy then
                    dy = dy+20
                    dxDrawText(getElementData(obj, "objectID") or getElementModel(obj), dx, dy, dx, dy, "0xffffff00", 1, "default", "center")
                end
            end
        end
    end
end

local SW, SH = guiGetScreenSize()
local twobjDrawing = false
local currInfo
function togDrawWorldObjects()
    twobjDrawing = not twobjDrawing
    outputChatBox("Displaying world objects: "..(twobjDrawing and "Yes - Hover your mouse over the objects - /cwobj to copy info" or "No"), 50,255,50)
    currInfo = nil

    if twobjDrawing then
        addEventHandler( "onClientRender", root, drawWorldObjects)
    else
        removeEventHandler( "onClientRender", root, drawWorldObjects)
    end
end
addCommandHandler("twobjs", togDrawWorldObjects, false)

function drawWorldObjects()
    if not isCursorShowing() then return end
    local px, py, pz = getCameraMatrix()
    local cx, cy, worldx, worldy, worldz = getCursorPosition()
    local text = string.format( "Cursor world position: X=%.4f Y=%.4f Z=%.4f \n", worldx, worldy, worldz )
    local hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material, lighting, piece,
    worldModelID,
    worldModelPositionX, worldModelPositionY, worldModelPositionZ,
    worldModelRotationX, worldModelRotationY, worldModelRotationZ, 
    worldLODModelID = processLineOfSight(px, py, pz, worldx, worldy, worldz, true, false, false, false, false, true, true, true, nil, true)
    -- dxDrawText(inspect({
    --     hit, hitX, hitY, hitZ, hitElement, normalX, normalY, normalZ, material, lighting, piece, worldModelID, worldModelPositionX, worldModelPositionY, worldModelPositionZ, worldModelRotationX, worldModelRotationY, worldModelRotationZ, worldLODModelID
    -- }), 15, 15)
    if worldModelID then
        text = text.."\nWorld model ID: "..worldModelID
        local worldModelName = engineGetModelNameFromID(worldModelID)
        if worldModelName then
            text = text.." ("..worldModelName..")"
        end
    end
    if worldLODModelID then
        text = text.."\nWorld LOD model ID: "..worldLODModelID
    end
    if worldModelPositionX then
        text = text.."\nWorld model position: X="..worldModelPositionX.." Y="..worldModelPositionY.." Z="..worldModelPositionZ
    end
    if worldModelRotationX then
        text = text.."\nWorld model rotation: X="..worldModelRotationX.." Y="..worldModelRotationY.." Z="..worldModelRotationZ
    end
    dxDrawText(text, 0, 0, SW, SH, tocolor( 255, 255, 255 ), 1, "default", "center", "center" )
    currInfo = text
end

addCommandHandler("cwobj", function()
    if currInfo then
        setClipboard(currInfo)
        outputChatBox("Copied to clipboard!")
    end
end)