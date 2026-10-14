
local vehiculars = { }
local viewDistance = 20
local heightOffset = 1.4
local refreshingInterval = 1
local showing = false
local timerRefresh = nil

local noPlateVehs = {
	[481] = "BMX",
	[509] = "Bike",
	[510] = "Mountain Bike",
	[6651] = "Skateboard",
}

function bindVD()
	bindKey ("lctrl", "down", showNearbyVehicleDescriptions)
	bindKey ("lctrl", "up", removeVD)
end
addEventHandler ( "onClientResourceStart", resourceRoot, bindVD )

function removeVD ( key, keyState )
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		if showing then
			removeEventHandler ( "onClientRender", getRootElement(), showText )
			showing = false
		end
	end
end

function showNearbyVehicleDescriptions()
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		if not showing then
			vehiculars = {}
			for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
				if isElement(nearbyVehicle) then
					vehiculars[index] = nearbyVehicle
				end
			end
			fontStringVeh = getElementData(localPlayer, "cFontVeh") or "clear"
			showing = true
			addEventHandler("onClientRender", getRootElement(), showText)
		end
	end
end

function showText()
	for i = 1, #vehiculars, 1 do
		local theVehicle = vehiculars[i]
		if isElement(theVehicle) and getElementDimension(localPlayer) == getElementDimension(theVehicle) and getElementInterior(localPlayer) == getElementInterior(theVehicle) then
			if not (getPedOccupiedVehicle(localPlayer) == theVehicle and hideOwn and getElementData(localPlayer, "enableOverlayDescriptionVehPin") == "1") then
				local x,y,z = getElementPosition(theVehicle)			
				local cx,cy,cz = getCameraMatrix()
				if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= viewDistance then --Within radius viewDistance
					local px,py,pz = getScreenFromWorldPosition(x,y,z+heightOffset,0.05)
					if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then				
						--INITIAL SHIT
						local toBeShowed = ""
						local fontWidth = 90
						local toBeAdded = ""
						local lines = 0
						if getElementData(theVehicle, "carshop") then
							local brand, model, year = false, false, false
							brand = getElementData(theVehicle, "brand") or false
							if brand then
								model = getElementData(theVehicle, "maximemodel")
								year = getElementData(theVehicle, "year")
								local line = year.." "..brand.." "..model
								local len = dxGetTextWidth(line)
								if len > fontWidth then
									fontWidth = len
								end
								if toBeShowed == "" then
									toBeShowed = toBeShowed..line.."\n"
									lines = lines + 1
								else
									toBeShowed = toBeShowed.."-~-\n"..line.."\n"
									lines = lines + 2
								end
							else
								if toBeShowed == "" then
									toBeShowed = toBeShowed..getVehicleName(theVehicle).."\n"
									lines = lines + 1
								else
									toBeShowed = toBeShowed.."-~-\n"..getVehicleName(theVehicle).."\n"
									lines = lines + 2
								end
							end
							local price = getElementData(theVehicle, "carshop:cost") or 0
							local taxes = getElementData(theVehicle, "carshop:taxcost") or 0
							toBeShowed = toBeShowed.."Price: $"..exports.global:formatMoney(price).."\n Taxes: $"..exports.global:formatMoney(taxes)
							lines = lines+ 2
						else

							--GET DESCRIPTIONS + SIZE
							local descToBeShown = ""
							local job = getElementData(theVehicle, "job")
							if job == 1 then
								descToBeShown = "RS Haul - We'll dump your load."
								lines = lines + 1
							elseif job == 2 then
								descToBeShown = "Yellow Cab Co.\nCall #8294 for a pickup!"
								lines = lines + 2
							elseif job == 3 then
								descToBeShown = "Los Santos Bus"
								lines = lines + 1
							else
								for j = 1, 5 do
									local desc = getElementData(theVehicle, "description:"..j)
									if desc and desc ~= "" and desc ~= "\n" and desc ~= "\t" then
										local len = dxGetTextWidth(desc)
										if len > fontWidth then
											fontWidth = len
										end
										descToBeShown = descToBeShown..desc.."\n"
										lines = lines + 1
									end				
								end
							end
							

							if descToBeShown ~= "" then
								descToBeShown = "-~-\n"..descToBeShown
								lines = lines + 1
							end

			
							
							

							--GET BRAND, MODEL, YEAR
							local brand, model, year = false, false, false
							brand = getElementData(theVehicle, "brand") or false
							if brand then
								model = getElementData(theVehicle, "maximemodel")
								year = getElementData(theVehicle, "year")
								
								local line = year.." "..brand.." "..model
								local len = dxGetTextWidth(line)
								if len > fontWidth then
									fontWidth = len
								end
								
								toBeShowed = toBeShowed..line.."\n"
								lines = lines + 1
							end
							
							--GET VIN+PLATE
							local plate = ""
							local vin = getElementData(theVehicle, "dbid")
							if vin < 0 then
								plate = getVehiclePlateText(theVehicle)
							else
								plate = getElementData(theVehicle, "plate")
							end

							--Following edited by Adams 27/01/14 to accomodate VIN/PLATE hiding.
							if not noPlateVehs[getElementModel(theVehicle)] then
								if getElementData(theVehicle, "show_plate") == 0 then
									if getElementData(localPlayer, "duty_admin") == 1 then
										toBeShowed = toBeShowed.."((Plate: "..plate.."))\n"
										lines = lines + 1
									else
										--toBeShowed = toBeShowed.."* NO PLATE *\n"
									end
								else
									toBeShowed = toBeShowed.."Plate: "..plate.."\n"
									lines = lines + 1
								end
							end
							if getElementData(theVehicle, "show_vin") == 0 then
								if getElementData(localPlayer, "duty_admin") == 1 or getElementData(localPlayer, "duty_supporter") then
									toBeShowed = toBeShowed.."((VIN: "..vin.."))"
									lines = lines + 1
								else
									--toBeShowed = toBeShowed.."* NO VIN *"
								end
							else
								toBeShowed = toBeShowed.."VIN: "..vin
								lines = lines + 1
							end


		
							--GET IMPOUND
							if (exports.vehicle:isVehicleImpounded(theVehicle)) then
								local days = getRealTime().yearday-getElementData(theVehicle, "Impounded")
								toBeShowed = toBeShowed.."\n".."Impounded: " .. days .. " days"
								lines = lines + 1
							end

							local vowner = getElementData(theVehicle, "owner") or -1
							local vfaction = getElementData(theVehicle, "faction") or -1

							if vowner == getElementData(localPlayer, "dbid") or exports.global:isStaffOnDuty(localPlayer) or exports.integration:isPlayerScripter(localPlayer) or exports.integration:isPlayerVCTMember(localPlayer) then
								toBeShowed = toBeShowed.."\nShop ID: "..(getElementData(theVehicle, "vehicle_shop_id") or "None")
								lines = lines + 1
								local ownerName = nil
								if vowner > 0 then
									ownerName = exports.cache:getCharacterNameFromID(vowner)
								elseif vfaction > 0 then
									ownerName = exports.cache:getFactionNameFromId(vfaction)
								end
								local line = "\nOwner: "..(ownerName or "Loading..")
								local len = dxGetTextWidth(line)
								if len > fontWidth then
									fontWidth = len
								end
								toBeShowed = toBeShowed..line
								lines = lines + 1

							end
							local adminDesc = getElementData(theVehicle, "description:admin")
							if adminDesc and adminDesc ~= "" and adminDesc ~= "\n" and adminDesc ~= "\t" then
								local len = dxGetTextWidth(adminDesc)
								if len > fontWidth then
									fontWidth = len
								end
								toBeShowed = toBeShowed.."\n"..adminDesc
								lines = lines + 1
							end	
							toBeShowed = toBeShowed.."\n"..descToBeShown
						end
						
						if fontWidth < 90 then
							fontWidth = 90
						end
						
						--START DRAWING
						local marg = 5
						local oneLineHeight = dxGetFontHeight(1, fontStringVeh)
						local fontHeight = oneLineHeight * lines
						fontWidth = fontWidth*fontType[fontStringVeh][2] --Fix custom fonts
						px = px-(fontWidth/2)
						if getElementData(localPlayer, "bgVeh") ~= "0" then
							dxDrawRectangle(px-marg, py-marg, fontWidth+(marg*2), fontHeight+(marg*2), tocolor(0, 0, 0, 10))
						end
						if getElementData(localPlayer, "borderVeh") ~= "0" then
							dxDrawRectangleBorder(px-marg, py-marg, fontWidth+(marg*2), fontHeight+(marg*2), 1, tocolor(255, 255, 255, 10), true)
						end
						dxDrawText(toBeShowed, px, py, px + fontWidth, (py + fontHeight), tocolor(255,255,255,255), 1, fontStringVeh, "center")
					end
				end
			end
		end
	end
end

function dxDrawRectangleBorder(x, y, width, height, borderWidth, color, out, postGUI)
	if out then
		--[[Left]]	dxDrawRectangle(x - borderWidth, y, borderWidth, height, color, postGUI)
		--[[Right]]	dxDrawRectangle(x + width, y, borderWidth, height, color, postGUI)
		--[[Top]]	dxDrawRectangle(x - borderWidth, y - borderWidth, width + (borderWidth * 2), borderWidth, color, postGUI)
		--[[Botm]]	dxDrawRectangle(x - borderWidth, y + height, width + (borderWidth * 2), borderWidth, color, postGUI)
	else
		local halfW = width / 2
		local halfH = height / 2
		--[[Left]]	dxDrawRectangle(x, y, math.clip(0, borderWidth, halfW), height, color, postGUI)
		--[[Right]]	dxDrawRectangle(x + width - math.clip(0, borderWidth, halfW), y, math.clip(0, borderWidth, halfW), height, color, postGUI)
		--[[Top]]	dxDrawRectangle(x + math.clip(0, borderWidth, halfW), y, width - (math.clip(0, borderWidth, halfW) * 2), math.clip(0, borderWidth, halfH), color, postGUI)
		--[[Botm]]	dxDrawRectangle(x + math.clip(0, borderWidth, halfW), y + height - math.clip(0, borderWidth, halfH), width - (math.clip(0, borderWidth, halfW) * 2), math.clip(0, borderWidth, halfH), color, postGUI)
	end
end

function refreshNearByVehs()

	for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
		if isElement(nearbyVehicle) then
			vehiculars[index] = nearbyVehicle
		end
	end
	if showing then
		removeEventHandler ( "onClientRender", getRootElement(), showText )
		addEventHandler("onClientRender", getRootElement(), showText)
	end

end