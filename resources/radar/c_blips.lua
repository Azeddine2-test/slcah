created_custom_blips = {}
players_custom_blips = players_custom_blips or {}

createCustomBlip = function(x, y, z, icon, size, r, g, b, a, ordering, visibleDistance)
	if not custom_blips[tonumber(icon)] then
		return "No blip found with this icon."
	end
	
	if not x or not y or not z then
		return "Please set the blip's position."
	end
	
	if not icon then return "Please set the blip's icon." end
	
	if not size then size = 2 end

	local player = client or source;
	table.insert(created_custom_blips, {x = x, y = y, z = z, icon = icon, size = size, r = r or 255, g = g or 255, b = b or 255, a = a or 255, ordering = ordering or 0, visibleDistance = visibleDistance or 16383.0, interior = 0, dimension = 0});
	return true
end

createCustomBlip = function(x, y, z, icon, size, r, g, b, a, ordering, visibleDistance, linked_obj)
	if not custom_blips[tonumber(icon)] then
		return "No blip found with this icon."
	end
	
	if not x or not y or not z then
		return "Please set the blip's position."
	end
	
	if not icon then return "Please set the blip's icon." end
	
	if not size then size = 2 end

	table.insert(created_custom_blips, {x = x, y = y, z = z, icon = icon, size = size, r = r or 255, g = g or 255, b = b or 255, a = a or 255, ordering = ordering or 0, visibleDistance = visibleDistance or 16383.0, interior = 0, dimension = 0, player = player, linked_obj = linked_obj});
	return true
end
addEvent("createCustomBlip", true)
addEventHandler("createCustomBlip", root, createCustomBlip)

--> Add by: Whiletruend
destroyCustomBlip = function(object)
	--> Check: player & blip_id
	if not object then return false; end;

	--> Loop: created_custom_blips
	for k, v in pairs(created_custom_blips) do
		if v.linked_obj == object then
			table.remove(created_custom_blips, k);			
			return true;
		end;
	end;

	--> Check: blip_id
	return false;
end;
addEvent("destroyCustomBlip", true)
addEventHandler("destroyCustomBlip", root, destroyCustomBlip)

getCustomNearestBlip = function(icon)
	if #created_custom_blips > 0 then
		local px, py, pz = getElementPosition(localPlayer)
		local nearest = false

		local lastDistance = getDistanceBetweenPoints3D(px, py, pz, created_custom_blips[#created_custom_blips].x, created_custom_blips[#created_custom_blips].y, created_custom_blips[#created_custom_blips].z)
		print(lastDistance)
		for i, j in ipairs(created_custom_blips) do
			if tonumber(j.icon) == tonumber(icon) then
				if lastDistance >= getDistanceBetweenPoints3D(px, py, pz, j.x, j.y, j.z) then
					lastDistance = getDistanceBetweenPoints3D(px, py, pz, j.x, j.y, j.z)
					nearest = j
				end
			end
		end
		
		return nearest
	end
	
	return false
end

getCustomBlipColor = function(blip)
	if not created_custom_blips[blip] then
		return 255, 255, 255, 255
	end
	
	return created_custom_blips[blip].r, created_custom_blips[blip].g, created_custom_blips[blip].b, created_custom_blips[blip].a
end

--createBlip(1179.779296875, -2245.3916015625, 59.376033782959, 61)
--createBlip(1329.67578125, -2403.8896484375, 57.653179168701, 61)