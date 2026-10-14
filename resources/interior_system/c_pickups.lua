--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

local hitPickup = nil
function enterInterior()
    --> Check
    if isPedDead(localPlayer) then return; end;
    
    if not hitPickup then return end

    local localDimension = getElementDimension( localPlayer )

    local foundInterior = getElementParent(hitPickup)
    local interiorID = getElementData(foundInterior, "dbid")
    if interiorID then
        local canEnter, errorCode, errorMsg = canEnterInterior(foundInterior)
        if canEnter or isInteriorForSale( foundInterior ) then
            if getElementType(foundInterior) == "interior" then
                triggerServerEvent("interior:enter", foundInterior)
            else
                triggerServerEvent("elevator:enter", foundInterior, getElementData(hitPickup, "type") == "entrance")
            end
        else
            outputChatBox(errorMsg, 255, 0, 0)
        end
    end
end

function bindKeys()
    bindKey("enter", "down", enterInterior)
    bindKey( "f", "down", enterInterior)
    toggleControl("enter_exit", false)
end

function unbindKeys()
    unbindKey("enter", "down", enterInterior)
    unbindKey("f", "down", enterInterior)
    toggleControl("enter_exit", true)
end

local isLastSourceInterior = nil
function hitInteriorPickup(theElement, matchingdimension)
    local pickup = getElementParent(source)
    if getElementType(pickup) == "interior" or getElementType(pickup) == "elevator" then
        local isVehicle = false
        local theVehicle = getPedOccupiedVehicle(localPlayer)
        if theVehicle and theVehicle == theElement and getVehicleOccupant ( theVehicle, 0 ) == localPlayer then
            isVehicle = true
        end

        if matchingdimension and (theElement == localPlayer or isVehicle)  then
            if getElementType(pickup) == "interior" or getElementType(pickup) == "elevator" then
                unbindKeys()
                bindKeys()
                hitPickup = source
                -- playSoundFrontEnd(2)

                setElementData(localPlayer, "hitInteriorID", getElementData(pickup, "dbid"))

                if getElementType(pickup) == "interior" then
                   isLastSourceInterior = true
                else
                    isLastSourceInterior = nil
                end
            end
        end
        cancelEvent()
    end
end
addEventHandler("onClientColShapeHit",  root, hitInteriorPickup)

function leaveInteriorPickup(theElement, matchingdimension)
    local isVehicle = false
    local theVehicle = getPedOccupiedVehicle(localPlayer)
    if theVehicle and theVehicle == theElement and getVehicleOccupant(theVehicle, 0) == localPlayer then
        isVehicle = true
    end

    if hitPickup == source and (theElement == localPlayer or isVehicle) then
        hitPickup = nil
        unbindKeys()

        setElementData(localPlayer, "hitInteriorID", nil)
    end
end
addEventHandler("onClientColShapeLeave",  root, leaveInteriorPickup)

function hideInteriorPickup()
	hitPickup = nil
end
addEventHandler("account:changingchar", localPlayer, hideInteriorPickup)

local scrWidth, scrHeight = guiGetScreenSize()
local yOffset = scrHeight-130 -- MS: Adjusted from 110 to 130 to account for a new line of text for address (Avoid clipping at bottom of screen)
local margin = 3
local textShadowDistance = 3
local intNameFont, BizNoteFont
local function makeFonts()
    intNameFont = intNameFont or dxCreateFont( ":resources/Montserrat-Bold.ttf", 30 ) or "default-bold"
    BizNoteFont = BizNoteFont or dxCreateFont( ":resources/Montserrat-Bold.ttf", 21 ) or "default-bold"
end

function renderInteriorName()
    if hitPickup and isElement(hitPickup) then
        local theInterior = hitPickup
        local intStatus = getElementData(theInterior, "status")
        local intType = intStatus.type
        if intType == 4 or intType == 5 then return false end
        makeFonts()
        local intInst = "Appuyez 'F' pour entrer"

        --Draw int name
        local intName = ""
        if isLastSourceInterior then
            intName = getElementData(theInterior, "name")
        end
        local intName_width = dxGetTextWidth ( intName, 1, intNameFont )+textShadowDistance*2
        local intName_left = (scrWidth-intName_width)/2
        local intName_height = dxGetFontHeight ( 1, intNameFont )
        local intName_top = (yOffset-intName_height)
        local intName_right = intName_left + intName_width
        local intName_bottom = intName_top + intName_height

        local textColor = tocolor(255,255,255,255)
		
        -- interior name positions
        local n_l = intName_left
        local n_t = intName_top
        local n_r = intName_right
        local n_b = intName_bottom

        -- interior preview positions
        local img_w, img_h = math.max(400,intName_width+20), 125
        local img_l = (scrWidth-img_w)/2
        local img_t = scrHeight-img_h-40

        intName_top = intName_top + intName_height

        if isLastSourceInterior then
            --Draw biz note
            local bizNote = getElementData(theInterior, "business:note")
            if intType == 1 and bizNote and type(bizNote) == "string" and string.len(bizNote) > 0 then
                local bizNote_width = dxGetTextWidth ( bizNote, 1, BizNoteFont )+20
                local bizNote_left = (scrWidth-bizNote_width)/2
                local bizNote_height = dxGetFontHeight ( 1, BizNoteFont )
                intName_top = intName_top - margin
                local bizNote_right = bizNote_left + bizNote_width
                local bizNote_bottom = intName_top + bizNote_height
                dxDrawText ( bizNote , bizNote_left , intName_top , bizNote_right, bizNote_bottom, textColor,
                        1, BizNoteFont, "center", "center", false, true )
                intName_top = intName_top + bizNote_height
            end

			--MS: Draw Address - Only accounts for if it has an actual address set, doesn't account for the main interior's address if it's a sub-int, as that's not really needed here.
			local intAddress = getElementData(theInterior, "address")
			if intAddress and intAddress ~= "" then
				local intAddress = "Address: "..intAddress
				local intAddress_width = dxGetTextWidth ( intAddress, 1, "default" )
                local intAddress_left = (scrWidth-intAddress_width)/2
                local intAddress_height = dxGetFontHeight ( 1, "default" )
                intName_top = intName_top + margin
                local intAddress_right = intAddress_left + intAddress_width
                local intAddress_bottom = intName_top + intAddress_height
                dxDrawText ( intAddress , intAddress_left , intName_top , intAddress_right, intAddress_bottom, textColor,
                        1, "default", "center", "center", false, true )
                intName_top = intName_top + intAddress_height
			end

            -- Draw owner
            local intOwner = ""
            local ckio = canPlayerKnowInteriorOwner(theInterior)
            if intStatus.owner > 0 then
                local ownerName = exports.cache:getCharacterNameFromID(intStatus.owner)
                if intType == 3 then
                    if ckio then
                        intOwner = "Loué par "..(ownerName or "..Loading..")
                    end
                elseif intType ~= 2 then
                    if ckio then
                        intOwner = "Acheté par "..(ownerName or "..Loading..")
                    end
                end
            elseif intStatus.faction > 0 then
                local ownerName = exports.cache:getFactionNameFromId(intStatus.faction)
                if intType ~= 2 then
                    if ckio then
                        intOwner = "Acheté par "..(ownerName or "..Loading..")
                    end
                end
            else
                if intType == 2 then
                elseif intType == 3 then
                    local intPrice = exports.global:formatMoney(intStatus.cost)
                    intOwner = "En location: $"..intPrice
                else
                    local intPrice = exports.global:formatMoney(intStatus.cost)
                    intOwner = "En vente: $"..intPrice
                    intInst = "Appuyez 'F' pour acheter"
                end
            end

            local intOwner_width = dxGetTextWidth ( intOwner, 1, "default" )
            local intOwner_left = (scrWidth-intOwner_width)/2
            local intOwner_height = dxGetFontHeight ( 1, "default" )
            intName_top = intName_top + margin
            local intOwner_right = intOwner_left + intOwner_width
            local intOwner_bottom = intName_top + intOwner_height
            dxDrawText ( intOwner , intOwner_left , intName_top , intOwner_right, intOwner_bottom, textColor,
                    1, "default", "center", "center", false, true )
            intName_top = intName_top + intOwner_height

            -- Draw entrance fees
            local intEntranceFees = ""
            if intType == 1 then
                if intStatus.entranceFees > 0 then
                    intEntranceFees = "Prix d'entrée: $"..intStatus.entranceFees
                    
                    local intEntranceFees_width = dxGetTextWidth ( intEntranceFees, 1, "default" )
                    local intEntranceFees_left = (scrWidth-intEntranceFees_width)/2
                    local intEntranceFees_height = dxGetFontHeight ( 1, "default" )
                    intName_top = intName_top + margin
                    local intEntranceFees_right = intEntranceFees_left + intEntranceFees_width
                    local intEntranceFees_bottom = intName_top + intEntranceFees_height
                    dxDrawText ( intEntranceFees , intEntranceFees_left , intName_top , intEntranceFees_right, intEntranceFees_bottom, textColor,
                            1, "default", "center", "center", false, true )
                    intName_top = intName_top + intEntranceFees_height
                end
            end
        end

        dxDrawText ( intName or "Unknown Interior", n_l+textShadowDistance , n_t+textShadowDistance , n_r+textShadowDistance, n_b+textShadowDistance, tocolor(0,0,0,255),
                    1, intNameFont, "center", "center", false, true )
        dxDrawText ( intName or "Unknown Interior", n_l , n_t , n_r, n_b, textColor,
                    1, intNameFont, "center", "center", false, true )

        --Draw instructions
        local intInst_width = dxGetTextWidth ( intInst, 1, "default" )
        local intInst_left = (scrWidth-intInst_width)/2
        local intInst_height = dxGetFontHeight ( 1, "default" )
        intName_top = intName_top + margin
        local intInst_right = intInst_left + intInst_width
        local intInst_bottom = intName_top + intInst_height
        dxDrawText ( intInst , intInst_left , intName_top , intInst_right, intInst_bottom, textColor,
                1, "default", "center", "center", false, true )
        intName_top = intName_top + intInst_height

        -- Interior ID for admins/factions with MDC access to interior information
        if isLastSourceInterior and canPlayerSeeInteriorID(theInterior) then
            local intId = "(( ID: " .. getElementData(theInterior, "dbid") .. " ))"
            local intId_width = dxGetTextWidth ( intId, 1, "default" )
            local intId_left = (scrWidth-intId_width)/2
            local intId_height = dxGetFontHeight ( 1, "default" )
            intName_top = intName_top + margin
            local intId_right = intId_left + intId_width
            local intId_bottom = intName_top + intId_height
            dxDrawText ( intId , intId_left , intName_top , intId_right, intId_bottom, textColor,
                    1, "default", "center", "center", false, true )
            intName_top = intName_top + intId_height
        end
    else
        --removeEventHandler("onClientRender", root, renderInteriorName)
        unbindKeys()
    end
end
addEventHandler("onClientRender", root, renderInteriorName)

function canPlayerKnowInteriorOwner(theInterior)
    return  (getElementData(theInterior, "status").owner == 0) -- unown.
        or  (exports.integration:isPlayerTrialAdmin(localPlayer) and (getElementData(localPlayer, "duty_admin") == 1))
        or  (getElementData(localPlayer, "dbid") == getElementData(theInterior, "status").owner)
end

function canPlayerSeeInteriorID(theInterior)
    local factionTable = getElementData(localPlayer, "faction")
    return  factionTable[1] -- LSPD
        or  factionTable[3] -- Gov
		or  factionTable[50] -- SCoSA
        or  factionTable[59] -- SAHP
        or  (exports.integration:isPlayerTrialAdmin(localPlayer) and (getElementData(localPlayer, "duty_admin") == 1))
        or  (exports.integration:isPlayerSupporter(localPlayer) and (getElementData(localPlayer, "duty_supporter") == 1))
        or  (exports.integration:isPlayerMappingTeamMember(localPlayer))
end
