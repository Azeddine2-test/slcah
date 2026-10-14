--[[
 * ***********************************************************************************************************************
 * Copyright (c) 2015 OwlGaming Community - All Rights Reserved
 * All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ***********************************************************************************************************************
 ]]

function explode(div,str)
	if (div=='') then return false end
	local pos,arr = 0,{}
	-- for each divider found
	for st,sp in function() return string.find(str,div,pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
		pos = sp + 1 -- Jump past current divider
	end
	table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
	return arr
end

function implode(div, arr)
	return table.concat(arr,div)
end


function getUrlFromString(message)
	if not message or string.len(message) < 1 then
		return false
	end

	for _, v in ipairs(split(message, ' ')) do
		if v:sub(1, 7) == 'http://' or v:sub(1, 8) == 'https://' or v:sub(1, 4) == 'www.' or v:sub(1, 8) == 'owl.pm' then
			return v
		end
	end
	
	return false
end

function getRandomSkin()
	while true do 
		local ran = math.random(1,288)
		local ped = createPed(ran, 0, 0, 3)
		if ped then
			destroyElement(ped)
			return ran
		end
	end
end

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function formatWeight(kg)
	kg = tonumber(kg)
	if kg < 1000 then
		return round(kg,2).." kg(s)"
	else 
		return round(kg/1000,2).." tons"
	end
end

function formatLength(meters)
	meters = tonumber(meters) or 0
	if meters >=1000 then
		return round(meters/1000, 2).." km(s)"
	else
		return round(meters,2).." meter(s)"
	end
end

function getPedWeapons(ped,from_slot, to_slot)
	from_slot = tonumber(from_slot) or 2
	to_slot = tonumber(to_slot) or 9
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i=from_slot,to_slot do
			local wep = getPedWeapon(ped,i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons,wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end

function countTable(table)
	local count = 0
	for i, k in pairs(table) do
		count = count + 1
	end
	return count
end

function mergeTables(table1, table2)
    if not table1 or not table2 then return end
    if type(table1) ~= "table" or type(table2) ~= "table" then return end
   
    local mergedTable = {}
    for key, value in ipairs(table1) do
        table.insert(mergedTable, value)
    end
    for key, value in ipairs(table2) do
        table.insert(mergedTable, value)
    end
 
    if #mergedTable > 0 then
        return mergedTable
    end
end

-- Nando 05/04/2023

function rgbToHex(rgb)
	-- local hexadecimal = '0X'
	local hexadecimal = ''

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end


function getNametagColor(player, mode)
	local r,g,b = getPlayerNametagColor(player)
	if mode == "hex" then
		return rgbToHex({r,g,b})
	end
	return r,g,b
end


--[[function formatMoney(amount)
	if not amount or not tonumber(amount) then
		amount = 0
	end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end--]]

function formatMoney(amount)
	if not amount or not tonumber(amount) then
		amount = 0
	end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)',"%1'"):reverse())..right
end





function hideAttached(source, object)
	if source then
		if not object then
			local attachedObjs = exports["pAttach"]:getAttacheds(source)
			if attachedObjs then
				for k, v in pairs(attachedObjs) do
					setElementAlpha(v, 0)
				end
			end
		else
			setElementAlpha(object, 0)
		end
	end
end

function showAttached(source, object)
	if source then
		if not object then
			local attachedObjs = exports["pAttach"]:getAttacheds(source)
			if attachedObjs then
				for k, v in pairs(attachedObjs) do
					if not getElementData(v, "hidden") then
						setElementAlpha(v, 255)
					end
				end
			end
		else
			setElementAlpha(object, 255)
		end
	end
end