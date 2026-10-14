local dynamicModels = {
	--[34] = { 1000, 1580, 0.03 }, -- cocaine -- We can have these working if drugs used just numbers for item values and not strings
	--[37] = { 1000, 1577, 0.03 }, -- heroin
	--[38] = { 1000, 1578, 0.03 }, -- marijuana
	--[39] = { 1000, 1577, 0.03 }, -- methamphetamine
	[134] = { 20000, 1550, 0.4 }, -- money bag

	-- [ID] = { min value, model, zoffset }
}

function getItemInfo(itemID)
	itemID = tonumber(itemID)
	if not itemID then return nil end
	return g_items[itemID] or nil
end

function getItemRotInfo(id, value)
	if not g_items[id] then
		return 0, 0, 0, 0
	elseif dynamicModels[id] and value and tonumber(value) and tonumber(value) >= dynamicModels[id][1] then
		return g_items[id][5], g_items[id][6], g_items[id][7], dynamicModels[id][3]
	else
		return g_items[id][5], g_items[id][6], g_items[id][7], g_items[id][8]
	end
end

local _vehiclecache = {}
local function findVehicleName( value )
	if _vehiclecache[value] then
		return _vehiclecache[value]
	end

	for _, theVehicle in pairs( getElementsByType( "vehicle" ) ) do
		if getElementData( theVehicle, "dbid" ) == value then
			_vehiclecache[value] = exports.global:getVehicleName( theVehicle )
			return _vehiclecache[value]
		end
	end
	return false
end

function getItemName(id, value, metadata)
	if not id or not tonumber(id) then
		return "Loading.."
	end

	if not metadata then
		metadata = {}
	end

	if id == -100 then
		return "Body Armor"
	elseif id == -46 then -- MTA Client bug
		return "Parachute"
	elseif id < 0 then
		return getWeaponNameFromID( -id )
	elseif not g_items[id] then
		return "?"
	end

	local itemName = metadata.item_name or g_items[id][1]
	if id == 3 and value then
		if metadata.key_name then
			return itemName .. " (" .. metadata.key_name .. ")", metadata.key_name
		else
			local vn = findVehicleName(value)
			if vn then
				return itemName .. " (" .. vn .. ")", vn
			else
				return itemName
			end
		end
	elseif id == 73 or id == 98 then
		return itemName, (metadata and metadata.key_name or nil)
	elseif ( id == 4 or id == 5 ) and value then
		if metadata.key_name then
			return itemName .. " (" .. metadata.key_name .. ")", metadata.key_name
		else
			local pickup = exports.interior_system:findParent( nil, value )
			local name = isElement(pickup) and getElementData( pickup, "name" )
			if name then
				return itemName .. " (" .. name .. ")", name
			else
				return itemName
			end
		end
	elseif ( id == 214 ) and value then
		return value
	elseif ( id == 90 or id == 171 or id == 172 ) and value then
		local itemValue = explode(";", value)
		if itemValue[1] and itemValue[2] then
			local customName = tostring(itemValue[1]).." helmet"
			return customName
		else
			return itemName
		end
	elseif ( id == 89 or id == 95 ) and value and value ~= 1 then
		local parts = exports.global:explode(':', value)
		if parts[1] then
			return tostring(parts[1])
		end
	elseif ( id == 96 ) and value and value ~= 1 then
		return value
	elseif ( id == 109 or id == 110 ) and value and value:find( ";" ) ~= nil then
		return value:sub( 1, value:find( ";" ) - 1 )
	elseif id == 115 and value then
		local itemExploded = explode(":", value )
		return itemExploded[3]
	elseif id == 116 and value then
		local parts = exports.global:explode(':', value)
		local ammo_id = tonumber(parts[1])
		local rounds = tonumber(parts[2])
		if ammo_id and rounds then
			local ammo = exports.weapon:getAmmo( ammo_id )
			if ammo and ammo.cartridge then
				--isGrouped
				return ammo.cartridge..' '..g_items[id][1]
			end
		end
	elseif (id == 150) and value then --ATM card
		local itemExploded = explode(";", value )
		local text = "ATM card"
		if itemExploded and itemExploded[3] then
			if tonumber(itemExploded[3]) == 1 then
				text = text.." - Basic"
			elseif tonumber(itemExploded[3]) == 2 then
				text = text.." - Premium"
			elseif tonumber(itemExploded[3]) == 3 then
				text = text.." - Ultimate"
			end
		end
		return text
	-- elseif(id == 165) then --video disc
	-- 	local disc = tonumber(value) or 0
	-- 	if disc > 1 then
	-- 		local discData = exports.fakevideo:getFakevideoData(disc)
	-- 		if discData then
	-- 			return 'DVD "'..tostring(discData.name)..'"'
	-- 		end
	-- 	else
	-- 		return "Empty DVD"
	-- 	end
	-- 	return "DVD"
	elseif(id == 175) then --poster
		if value and not tonumber(value) then
			local itemExploded = explode(";", value)
			local name = tostring(itemExploded[1].." Poster")
			return name
		else
			return itemName
		end
	-- elseif id == 223 then
	-- 	if value then
	-- 		return split(value, ":")[1]
	-- 	else
	-- 		return itemName
	-- 	end
	elseif id == 273 and value then -- Generic Fish
		local FishValue = explode(":", value)
		return FishValue[1]
	elseif id == 298 or id == 299 or id == 300 or id == 301 then
		if metadata and metadata.species_id then
			local waterType = "freshWater"
			
			if id == 299 then
				waterType = "seaWater"
			elseif id == 300 then
				waterType = "freshWaterTrophy"
			elseif id == 301 then
				waterType = "seaWaterTrophy"
			end
			
			local fishName = exports["fishing"]:getFishName(metadata.species_id, waterType)
			return fishName
		else
			return "Poisson"
		end
	else
		return itemName
	end
end

function getItemValue(id, value, metadata)
	if id == 80 or id == 89 or id == 95 then
		return ""
	elseif id == 214 then
		return ""
	elseif id == 223 then
		local capacity = 10
		if metadata and metadata.capacity then
			capacity = metadata.capacity
		end
		-- return "Capacity: "..tostring(split(value, ":")[3]).."kg"
		return "Capacity: "..capacity.."kg"
	elseif id == 10 and tostring(value) == "1" then
		return 6
	elseif (id == 89 or id == 95 or id == 109 or id == 110) and value and value:find( ";" ) ~= nil then
		return value:sub( value:find( ";" ) + 1 )
	else
		return value
	end
end

--
-- Vehicle upgrades as names
--
local vehicleupgrades = {
	"Pro Spoiler", "Win Spoiler", "Drag Spoiler", "Alpha Spoiler", "Champ Scoop Hood",
	"Fury Scoop Hood", "Roof Scoop", "Right Sideskirt", "5x Nitro", "2x Nitro",
	"10x Nitro", "Race Scoop Hood", "Worx Scoop Hood", "Round Fog Lights", "Champ Spoiler",
	"Race Spoiler", "Worx Spoiler", "Left Sideskirt", "Upswept Exhaust", "Twin Exhaust",
	"Large Exhaust", "Medium Exhaust", "Small Exhaust", "Fury Spoiler", "Square Fog Lights",
	"Offroad Wheels", "Right Alien Sideskirt (Sultan)", "Left Alien Sideskirt (Sultan)",
	"Alien Exhaust (Sultan)", "X-Flow Exhaust (Sultan)", "Left X-Flow Sideskirt (Sultan)",
	"Right X-Flow Sideskirt (Sultan)", "Alien Roof Vent (Sultan)", "X-Flow Roof Vent (Sultan)",
	"Alien Exhaust (Elegy)", "X-Flow Roof Vent (Elegy)", "Right Alien Sideskirt (Elegy)",
	"X-Flow Exhaust (Elegy)", "Alien Roof Vent (Elegy)", "Left X-Flow Sideskirt (Elegy)",
	"Left Alien Sideskirt (Elegy)", "Right X-Flow Sideskirt (Elegy)", "Right Chrome Sideskirt (Broadway)",
	"Slamin Exhaust (Chrome)", "Chrome Exhaust (Broadway)", "X-Flow Exhaust (Flash)", "Alien Exhaust (Flash)",
	"Right Alien Sideskirt (Flash)", "Right X-Flow Sideskirt (Flash)", "Alien Spoiler (Flash)",
	"X-Flow Spoiler (Flash)", "Left Alien Sideskirt (Flash)", "Left X-Flow Sideskirt (Flash)",
	"X-Flow Roof (Flash)", "Alien Roof (Flash)", "Alien Roof (Stratum)", "Right Alien Sideskirt (Stratum)",
	"Right X-Flow Sideskirt (Stratum)", "Alien Spoiler (Stratum)", "X-Flow Exhaust (Stratum)",
	"X-Flow Spoiler (Stratum)", "X-Flow Roof (Stratum)", "Left Alien Sideskirt (Stratum)",
	"Left X-Flow Sideskirt (Stratum)", "Alien Exhaust (Stratum)", "Alien Exhaust (Jester)",
	"X-FLow Exhaust (Jester)", "Alien Roof (Jester)", "X-Flow Roof (Jester)", "Right Alien Sideskirt (Jester)",
	"Right X-Flow Sideskirt (Jester)", "Left Alien Sideskirt (Jester)", "Left X-Flow Sideskirt (Jester)",
	"Shadow Wheels", "Mega Wheels", "Rimshine Wheels", "Wires Wheels", "Classic Wheels", "Twist Wheels",
	"Cutter Wheels", "Switch Wheels", "Grove Wheels", "Import Wheels", "Dollar Wheels", "Trance Wheels",
	"Atomic Wheels", "Stereo System", "Hydraulics", "Alien Roof (Uranus)", "X-Flow Exhaust (Uranus)",
	"Right Alien Sideskirt (Uranus)", "X-Flow Roof (Uranus)", "Alien Exhaust (Uranus)",
	"Right X-Flow Sideskirt (Uranus)", "Left Alien Sideskirt (Uranus)", "Left X-Flow Sideskirt (Uranus)",
	"Ahab Wheels", "Virtual Wheels", "Access Wheels", "Left Chrome Sideskirt (Broadway)",
	"Chrome Grill (Remington)", "Left 'Chrome Flames' Sideskirt (Remington)",
	"Left 'Chrome Strip' Sideskirt (Savanna)", "Covertible (Blade)", "Chrome Exhaust (Blade)",
	"Slamin Exhaust (Blade)", "Right 'Chrome Arches' Sideskirt (Remington)",
	"Left 'Chrome Strip' Sideskirt (Blade)", "Right 'Chrome Strip' Sideskirt (Blade)",
	"Chrome Rear Bullbars (Slamvan)", "Slamin Rear Bullbars (Slamvan)", false, false, "Chrome Exhaust (Slamvan)",
	"Slamin Exhaust (Slamvan)", "Chrome Front Bullbars (Slamvan)", "Slamin Front Bullbars (Slamvan)",
	"Chrome Front Bumper (Slamvan)", "Right 'Chrome Trim' Sideskirt (Slamvan)",
	"Right 'Wheelcovers' Sideskirt (Slamvan)", "Left 'Chrome Trim' Sideskirt (Slamvan)",
	"Left 'Wheelcovers' Sideskirt (Slamvan)", "Right 'Chrome Flames' Sideskirt (Remington)",
	"Bullbar Chrome Bars (Remington)", "Left 'Chrome Arches' Sideskirt (Remington)", "Bullbar Chrome Lights (Remington)",
	"Chrome Exhaust (Remington)", "Slamin Exhaust (Remington)", "Vinyl Hardtop (Blade)", "Chrome Exhaust (Savanna)",
	"Hardtop (Savanna)", "Softtop (Savanna)", "Slamin Exhaust (Savanna)", "Right 'Chrome Strip' Sideskirt (Savanna)",
	"Right 'Chrome Strip' Sideskirt (Tornado)", "Slamin Exhaust (Tornado)", "Chrome Exhaust (Tornado)",
	"Left 'Chrome Strip' Sideskirt (Tornado)", "Alien Spoiler (Sultan)", "X-Flow Spoiler (Sultan)",
	"X-Flow Rear Bumper (Sultan)", "Alien Rear Bumper (Sultan)", "Left Oval Vents", "Right Oval Vents",
	"Left Square Vents", "Right Square Vents", "X-Flow Spoiler (Elegy)", "Alien Spoiler (Elegy)",
	"X-Flow Rear Bumper (Elegy)", "Alien Rear Bumper (Elegy)", "Alien Rear Bumper (Flash)",
	"X-Flow Rear Bumper (Flash)", "X-Flow Front Bumper (Flash)", "Alien Front Bumper (Flash)",
	"Alien Rear Bumper (Stratum)", "Alien Front Bumper (Stratum)", "X-Flow Rear Bumper (Stratum)",
	"X-Flow Front Bumper (Stratum)", "X-Flow Spoiler (Jester)", "Alien Rear Bumper (Jester)",
	"Alien Front Bumper (Jester)", "X-Flow Rear Bumper (Jester)", "Alien Spoiler (Jester)",
	"X-Flow Spoiler (Uranus)", "Alien Spoiler (Uranus)", "X-Flow Front Bumper (Uranus)",
	"Alien Front Bumper (Uranus)", "X-Flow Rear Bumper (Uranus)", "Alien Rear Bumper (Uranus)",
	"Alien Front Bumper (Sultan)", "X-Flow Front Bumper (Sultan)", "Alien Front Bumper (Elegy)",
	"X-Flow Front Bumper (Elegy)", "X-Flow Front Bumper (Jester)", "Chrome Front Bumper (Broadway)",
	"Slamin Front Bumper (Broadway)", "Chrome Rear Bumper (Broadway)", "Slamin Rear Bumper (Broadway)",
	"Slamin Rear Bumper (Remington)", "Chrome Front Bumper (Remington)", "Chrome Rear Bumper (Remington)",
	"Slamin Front Bumper (Blade)", "Chrome Front Bumper (Blade)", "Slamin Rear Bumper (Blade)",
	"Chrome Rear Bumper (Blade)", "Slamin Front Bumper (Remington)", "Slamin Rear Bumper (Savanna)",
	"Chrome Rear Bumper (Savanna)", "Slamin Front Bumper (Savanna)", "Chrome Front Bumper (Savanna)",
	"Slamin Front Bumper (Tornado)", "Chrome Front Bumper (Tornado)", "Chrome Rear Bumper (Tornado)",
	"Slamin Rear Bumper (Tornado)"
}

function getItemDescription(id, value, metadata)
	--if true then return "blag" end
	local i = g_items[id]
	if i then
		local desc = i[2]
		if id == 90 or id == 171 or id == 172 then
			local itemValue = explode(";", value)
			if itemValue[3] then
				local helmetDesc = tostring(itemValue[3])
				return helmetDesc
			else
				return desc:gsub("#v",value)
			end
		elseif id == 3 and tonumber(value) == 0 then
			return "Véhicule inconnu"
		elseif (id == 4 or id == 5) and tonumber(value) == 0 then
			return "Propriété inconnue"
		elseif id == 96 and value ~= 1 then
			return desc:gsub("PDA","Laptop")
		elseif id == 114 then
			if tonumber(value) == nil then return nil end
			local v = tonumber(value) - 999
			return desc:gsub("#v", vehicleupgrades[v] or "?")
		-- weapons
		elseif id == 115 then
			local values = explode(':', value)
			if exports.weapon:isWeapAmmoless( tonumber(values[1]) ) then
				return ''
			else
				if values[4] and tonumber(values[4]) then
					return values[4]..' ammo loaded.'
				else
					return '0 ammo loaded.'
				end
			end
		-- ammopack
		elseif id == 116 then
			local values = explode(':', value)
			local bullets = values[2] and tonumber(values[2]) or 0
			return desc:gsub("#v",bullets)
		elseif id == 150 then--ATM card
			local itemExploded = explode(";", value)
			if itemExploded and itemExploded[2] and tonumber(itemExploded[2]) then
				if tonumber( itemExploded[2] ) > 0 then
					return "Card Number: '"..itemExploded[1].."', Owner: '"..tostring(exports.cache:getCharacterNameFromID(itemExploded[2])):gsub("_", " ").."'"
				else
					return "Card Number: '"..itemExploded[1].."', Owner: '"..tostring(exports.cache:getBusinessNameFromID(math.abs(itemExploded[2]))).."'"
				end
			else
				return "Card appears to be broken and is no longer usable."
			end
		elseif id == 152 then--ID card
			local itemExploded = explode(";", value)
			return "Une carte d'identité au nom de "..tostring(itemExploded[1]):gsub("_", " ")..", contenant une photo et d'autres informations."
		elseif id == 178 then
			local yup = split(value, ":")
            return yup[1] .." par ".. yup[2]
		elseif(id == 231) then --container
			if value then
				local itemExploded = explode(";", value)
				if itemExploded[1] then
					local name = tostring(itemExploded[1])
					return name
				else
					return desc
				end
			else
				return desc
			end
		elseif id == 273 then --Generic fish
			local FishValue = explode(":", value)
			return "Weighs a whopping: " .. FishValue[2] .. "lbs"
		elseif id == 292 then
			local scooter = nil
			for _, theVehicle in pairs(getElementsByType("vehicle")) do
				if getElementData(theVehicle, "dbid") == tonumber(value) then
					scooter = theVehicle
				end
			end
			
			if scooter then
				return tostring("Un e-scooter avec "..math.floor(getElementData(scooter, "fuel")).."% de batterie.")
			else
				return "A broken electric scooter."
			end
		elseif (id == 298 or id == 299 or id == 300 or id == 301) and (metadata and metadata.species_id and metadata.weight) then
			local waterType = "freshWater"
			if id == 299 then
				waterType = "seaWater"
			elseif id == 300 then
				waterType = "freshWaterTrophy"
			elseif id == 301 then
				waterType = "seaWaterTrophy"
			end
			
			local fishName = exports["fishing"]:getFishName(metadata.species_id, waterType)
			
			return "Un(e) "..fishName.." pesant "..metadata.weight.."lbs"
		else
			return desc:gsub("#v",value)
		end
	end
end

function getItemType(id)
	return ( g_items[id] or { nil, nil, 4 } )[3]
end

function getItemModel(id, value, metadata)
	if not metadata then
		metadata = {}
	end
	if metadata.model then
		return tonumber(metadata.model) or 1271
	end
	--[[if (id == 80 or id == 89 or id == 95) and value then
		local itemExploded = explode(":", value )
		return tonumber(itemExploded[2]) or 1271
	else]]if id == 115 and value then
		local itemExploded = explode(":", value )
		return weaponmodels[ tonumber(itemExploded[1]) ] or 1271
	elseif id == 223 and value then
		local itemExploded = explode(":", value)
		return tonumber(itemExploded[2])
	elseif ( id == 89 or id == 95 ) and value and value ~= 1 then
		local parts = exports.global:explode(':', value)
		if parts[2] then
			return tonumber(parts[2])
		end
	elseif dynamicModels[id] and tonumber(value) and tonumber(value) >= dynamicModels[id][1] then
		return dynamicModels[id][2]
	else
		return ( g_items[id] or { nil, nil, nil, 1271 } )[4]
	end
end

function explode(div,str)
	return exports.global:explode(div, str)
end

function getItemTab(id)
	if getItemType( id ) == 2 then
		return 3
	elseif getItemType( id ) == 8 or getItemType( id ) == 9 then
		return 4
	elseif getItemType( id ) == 10 then
		return 1
	else
		return 2
	end
end

function getItemWeight( itemID, itemValue, metadata )
	if not metadata then
		if(detailedDebug and sourceResource) then
			local theSource = getResourceName(sourceResource)
			outputDebugString("getItemWeight: metadata: missing (source: "..tostring(theSource)..")", 2)
		end
		metadata = {}
	elseif type(metadata) ~= "table" then
		if detailedDebug then
			local theSource
			if(sourceResource) then
				theSource = getResourceName(sourceResource)
			else
				theSource = "unknown"
			end
			outputDebugString("getItemWeight: metadata:"..tostring(metadata).." (source: "..tostring(theSource)..")", 2)
		end
		metadata = {}
	end
	if metadata.weight then
		if itemID > 297 and itemID < 302 then
			return 0
		end
		
		return tonumber(metadata.weight) or 1
	else
		local weight = g_items[ itemID ] and g_items[ itemID ].weight
		if not weight then return 0 end
		return type(weight) == "function" and weight( tonumber(itemValue) or itemValue ) or weight
	end
end

function getItemScale( itemID, itemValue, metadata )
	if not metadata then
		metadata = {}
	end
	if metadata.scale then
		return tonumber(metadata.scale) or 1
	end
	local scale = g_items[ itemID ] and g_items[ itemID ].scale
	return scale
end

--> Get items total weight (for one item)
--[[ function getItemsWeight(player, itemID, itemValue, metadata)
	--> Variable(s)
	local total_weight = 0;
	local item_amount = 0;
	local items = getItems(player);
	
	--> Loop: Get item amount
	for key, value in ipairs(items) do
		if value[1] == itemID then
			item_amount = item_amount + 1;
		end;
	end;

	--> Loop: Get item weight
	for key, value in ipairs(getItems(player)) do
		if value[1] == itemID then
			total_weight = total_weight + getItemWeight(itemID, value[2], value[3]);
		end;
	end;

	--> Return: Total weight
	return total_weight;
end; ]]

function getItemsWeight(player, itemID, itemValue, metadata)
	--> Variable(s)
	local total_weight = 0;
	local item_amount = 0;
	local items = getItems(player);
	
	--> Loop: Get item amount
	for key, value in ipairs(items) do
		if value[1] == itemID then
			item_amount = item_amount + 1;
		end;
	end;

	--> Loop: Get item weight
	for key, value in ipairs(getItems(player)) do
		if value[1] == itemID then
			total_weight = total_weight + (getItemWeight(itemID, value[2], value[3]) * value[2]);
		end;
	end;

	--> Return: Total weight
	return total_weight;
end;

--> Get items count from weight
function getItemsCountFromWeight(player, itemID, weight)
	--> Variable(s)
	local item_weight = getItemWeight(itemID, 1);

	--> Return: Total count
	return math.floor(weight / item_weight);
end;

--[[ <export function="getItemsCountFromWeight" type="shared" />
    <export function="getItemsWeightFromCount" type="shared" /> ]]
function getItemAlpha(itemID, itemValue, metadata)
	if not metadata then
		metadata = {}
	end
	if metadata.alpha then
		return tonumber(metadata.alpha)
	end
	local alpha = g_items[ itemID ] and g_items[ itemID ].alpha
	return alpha
end
function getItemDoubleSided( itemID, itemValue, metadata )
	local dblsided = g_items[ itemID ] and g_items[ itemID ].doubleSided
	return dblsided
end
function getItemCollisions ( itemID, itemValue, metadata )
	local no_collisions = g_items[ itemID ] and g_items[ itemID ].no_collisions
	if no_collisions then
		return false
	end
	local artifactName = g_items[ itemID ] and g_items[ itemID ].artifactName
	if artifactName then
		return exports.artifacts:hasCollisions(artifactName)
	end
	return true
end
function getItemTexture( itemID, itemValue, metadata )
	if itemID == 80 and itemValue then --generic
		--[[itemValue = explode(":", itemValue)
		if itemValue[4] and itemValue[5] then
			if itemValue[4] ~= "false" and itemValue[5] ~= "false" then
				local texture = { {"http://"..tostring(itemValue[4]), tostring(itemValue[5])} }
				return texture
			end
		end]]
		if metadata and metadata.url and metadata.texture then
			local texture = { { metadata.url, metadata.texture } }
			return texture
		end
	elseif itemID == 90 or itemID == 171 or itemID == 172 then --helmet
		if itemValue or metadata then
			local texname = {
				[90] = "helmet",
				[171] = "helmet_b",
				[172] = "helmet_f"
			}
			itemValue = explode(";", itemValue)
			local url
			if metadata then
				url = metadata.url
			end
			if url then
				local texture = { {tostring(url), texname[itemID]} }
				return texture
		    elseif itemValue[2] then
				local texture = { {tostring(itemValue[2]), texname[itemID]} }
				return texture
			end
		end
	elseif itemID == 167 and itemValue then --framed picture
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "cj_painting34"} }
			return texture
		end
	elseif itemID == 175 and itemValue then --poster
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "cj_don_post_2"} }
			return texture
		end
	elseif itemID == 231 and itemValue then --container
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = {}
			local insert = {tostring(itemValue[2]), "frate64_red"}
			table.insert(texture, insert)
			if itemValue[3] then
				local insert = {tostring(itemValue[3]), "frate_doors128red"}
				table.insert(texture, insert)
			end
			return texture
		end
	elseif itemID == 271 then
		if metadata and metadata.url then
			local texture = { { metadata.url, "Bdup2_mask" } }
			return texture
		end
	end
	if metadata then
		local texture = metadata["textures"]
		if texture then
			return texture
		end
	end
	local texture = g_items[ itemID ] and g_items[ itemID ].texture
	return texture
end
function getItemPreventSpawn( itemID, itemValue )
	local preventSpawn = g_items[ itemID ] and g_items[ itemID ].preventSpawn
	return preventSpawn
end
function getItemUseNewPickupMethod( itemID )
	local use = g_items[ itemID ] and g_items[ itemID ].newPickupMethod
	return use
	--return true
end
function getItemHideItemValue( itemID )
	local use = g_items[ itemID ] and g_items[ itemID ].hideItemValue
	return use
end
function isItem( id )
	return g_items[tonumber(id)]
end
function isStorageItem( itemID, itemValue ) --true if item can hold other items
	local storage = g_items[ itemID ] and g_items[ itemID ].storage
	return storage
end
function getItemWeightCapacity( itemID, itemValue, metadata ) --weight capacity for shelf items
	if itemID == 223 then --Storage generic by Chaos
		-- local capacity = tonumber(split(itemValue, ":")[3]) or 10
		local capacity = tonumber(metadata.capacity) or 10
		return capacity
	else
		if g_items[ itemID ] and g_items[ itemID ].capacity then
			local capacity = tonumber(g_items[ itemID ].capacity)
			if capacity then
				return capacity
			end
		end
		return 0
	end
end
function canStorageTakeItem( itemID, itemValue, addItemID, addItemValue )
	if g_items[ itemID ] and g_items[ itemID ].acceptItems then
		local acceptedItems = g_items[ itemID ].acceptItems
		if acceptedItems[addItemID] or acceptedItems[-getItemType(addItemID)] then
			return true
		else
			return false
		end
	else
		return true
	end
end

function getArtifactName(itemID)
	local itemInfo = g_items[itemID]
	if itemInfo then
		return itemInfo.artifactName
	end
end

function hasBlindfold(player)
	for itemID, v in pairs(g_items) do
		if v.blindfoldItem == true then
			if hasItem(player, itemID) then
				return itemID
			end
		end
	end
	return false
end

function isFoodItem(itemID)
	local itemInfo = g_items[itemID]
	if itemInfo then
		local eatHeal = itemInfo.eatHeal
		if eatHeal then
			return true
		end
	end
	return false
end

function isDrinkItem(itemID)

	local itemInfo = g_items[itemID]
	if itemInfo then
		local drinkHeal = itemInfo.drinkHeal
		if drinkHeal then
			return true, true
		end
		local drinkLoseHP = itemInfo.drinkLoseHP
		if drinkLoseHP then
			return true, false
		end
	end
	return false
end

function canItemBeMoved(itemID, player, vehicle)
	if vehicle and getElementType(vehicle) == "vehicle" then
		--> Variable(s)
		local vehicle_faction_id = getElementData(vehicle, "faction");
		local vehicle_faction_element = exports.pool:getElement("team", vehicle_faction_id);
		
		--> Check: Vehicle Faction Element
		if vehicle_faction_element then
			--> Variable(s)
			local vehicle_faction_type = getElementData(vehicle_faction_element, "type");
			local is_player_lspd = exports.factions:isInFactionType(player, 2);

			--> Check: Vehicle Faction Type & Player LSPD
			if vehicle_faction_type == 2 and is_player_lspd then
				return true;
			end;
		end;
	end;

	--[[ if vehicle then
		if exports['pd-system']:isOwnedByFactionType(vehicle, 2) and exports.factions:isPlayerInFactionType(player, 2) then return true; end;
	end; ]]
	if itemID == 139 and exports.factions:isInFactionType(player, 2) then return true; end; --> Traqueur (whiletruend)
	local itemInfo = g_items[itemID]
	if itemInfo then
		if itemInfo.onlyAdminCanMove then
			return exports.integration:isPlayerTrialAdmin(player, true)
		end
		return true
	end
	return false
end

itemBannedByAltAltChecker = {
	[2] = true, --CELLPHONE
	[3] = true, --VEHICLE KEY
	[4] = true, --HOUSE KEY
	[5] = true, --BUSINESS KEY
	[68] = true, --LOTTERY TICKET
	[73] = true, --ELEVATOR REMOTE
	[74] = true, --BOMB
	[75] = true, --BOMB REMOTE
	[98] = true, --GARAGE REMOTE
	[114] = true, --VEHICLE UPGRADE
	[115] = true, --WEAPONS
	[116] = true, --AMMOPACKS
	[134] = true, --MONEY
	[150] = true, --ATM CARD
}

function getPlayerMaxCarryWeight(element)
	local weightCount = 20 -- Default storage capability in kg

	-- Add the highest inv space increase
	local containers = {}
	for itemID, v in pairs(g_items) do
		local extendInventorySpace = v.extendInventorySpace
		if extendInventorySpace and hasItem(element, itemID) then
			containers[#containers+1] = extendInventorySpace
		end
	end
	local countContainers = #containers
	if countContainers > 0 then
		table.sort(containers, function(a,b) return a>b end)
		weightCount = weightCount + containers[1]
	end
	return weightCount
end

splittableItems = {
	[30]=" gram(s)", [31]=" gram(s)", [32]=" gram(s)", [33]=" gram(s)", [34]=" gram(s)", [35]=" ml(s)", [36]=" tablet(s)",
	[37]=" gram(s)", [38]=" gram(s)", [39]=" gram(s)", [40]=" ml(s)", [41]=" tab(s)", [42]=" shroom(s)", [43]=" tablet(s)", [134] = " money",
	[147]="picture frame", [116] = "ammopack", [287] = ' ', [381]=" ", [382]=" ", [383]=" ", [384]=" ", [385]=" ", [386]=" ", [387]=" ", 
	[388]=" ", [389]=" ", [390]=" ", [391]=" ", [392]=" ", [393] = " ", [394] = " ", [395] = " "
 }


-- returns the number of available item slots for that element
function isTruck( element )
	local model = getElementModel( element )
	return model == 498 or model == 609 or model == 499 or model == 524 or model == 455 or model == 414 or model == 456
end

function isVan(element)
	local model = getElementModel( element )
	return model == 482 or model == 440 or model == 418 or model == 413 or model == 459 or model == 582 or model == 423
end

function isSUV( element )
	local model = getElementModel( element )
	return model == 400 or model == 489 or model == 579 or model == 582 or model == 490
end

function isTrailer(element)
	local model = getElementModel(element)
	return model == 435 or model == 450 or model == 591
end

function table.compare( a1, a2 )
	if 
		type( a1 ) == 'table' and
		type( a2 ) == 'table'
	then
	
		local function size( t )
			if type( t ) ~= 'table' then
				return false 
			end
			local n = 0
			for _ in pairs( t ) do
				n = n + 1
			end
			return n
		end

		if size( a1 ) == 0 and size( a2 ) == 0 then
			return true
		elseif size( a1 ) ~= size( a2 ) then
			return false
		end
		
		for _, v in pairs( a1 ) do
			local v2 = a2[ _ ]
			if type( v ) == type( v2 ) then
				if type( v ) == 'table' and type( v2 ) == 'table' then
					if size( v ) ~= size( v2 ) then
						return false
					end
					if size( v ) > 0 and size( v2 ) > 0 then
						if not table.compare( v, v2 ) then 
							return false 
						end
					end	
				elseif 
					type( v ) == 'string' or type( v ) == 'number' and
					type( v2 ) == 'string' or type( v2 ) == 'number'
				then
					if v ~= v2 then
						return false
					end
				else
					return false
				end
			else
				return false
			end
		end
		return true
	end
	return false
end

function matchingMetadata(data1, data2)
	return table.compare(data1, data2)
end

function getID(element)
	if getElementType(element) == "player" then -- Player
		return tonumber(getElementData(element, "dbid")) or 0
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return tonumber(getElementData(element, "dbid")) or 0
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then -- World Item
		return tonumber(getElementData(element, "id")) or 0
	elseif getElementType(element) == "object" and getElementData(element, "bank:atm") then -- ATM
		return tonumber(getElementData(element, "dbid")) or 0
	elseif getElementType(element) == "ped" then -- Ped
		return tonumber(getElementData(element, "dbid")) or 0
	elseif getElementType(element) == "interior" then -- Interior
		return tonumber(getElementData(element, "dbid")) or 0
	else
		return 0
	end
end

-- returns the 'type' column content
function getType(element)
	if getElementType(element) == "player" then -- Player
		return 1
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return 2
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then -- World Item
		return 3
	elseif getElementType(element) == "object" and getElementData(element, "bank:atm") then -- ATM
		return 4
	elseif getElementType(element) == "ped" then -- Ped
		return 5
	elseif getElementType(element) == "interior" then -- Interior
		return 6
	else
		return 255
	end
end

function getMaxWeight(element)
	if getElementType( element ) == "player" then
		return getPlayerMaxCarryWeight( element )
	elseif getElementType( element ) == "vehicle" then
		if getID( element ) < 0 then
			return -1
		elseif exports.global:getVehicleType( element ) == "BMX" then
			return 1
		elseif exports.global:getVehicleType( element ) == "Bike" then
			return 10
		elseif isVan( element ) then
			return 80
		elseif isTruck( element ) then
			return 120
		elseif isSUV( element ) then
			return 75
		elseif isTrailer( element ) then
			return 350
		else
			return 20
		end
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then -- World Item
		local itemID = getElementData(element, "itemID")
		local itemValue = getElementData(element, "itemValue")
		local metadata = getElementData(element, "metadata")
		return getItemWeightCapacity( itemID, itemValue, metadata )
	elseif getElementType( element ) == "interior" then
		return 20 -- mailboxes
	else
		return 20
	end
end