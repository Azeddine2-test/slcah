function handleDamages( attacker, weapon, bodypart, loss)

	local veh = getPedOccupiedVehicle(localPlayer)
	if veh and isVehicleDamageProof(veh) then 
		return cancelEvent()
	end

	if weapon == 42 then -- Fire Extinguisher
		--return cancelEvent()
	end

	if weapon == 17 then -- Fire Extinguisher
		--return cancelEvent()
	end

	if weapon == 41 then -- Fire Extinguisher
		--return cancelEvent()
	end

	if weapon == 54 and getElementDimension(localPlayer) > 0 then
		exports["srp_notifs"]:add("Vous pouvez utiliser /antifall pour revenir à l'entrée de l'intérieur, si besoin", "warning", "topcenter", 30000)
		return cancelEvent()
	end

	if bodypart == 9 then
		if weapon == 24 then
			local deagleMode = getElementData(attacker, "deaglemode")
			if deagleMode == 0 then -- Tazer cancel headshot
				return cancelEvent()
			end
		elseif weapon == 25 then
			local shotgunMode = getElementData(attacker, "shotgunmode")
			if shotgunMode == 0 then -- Beanbag cancel headshot
				return cancelEvent()
			end
		end
	end
	local isUsingMDMA = getElementData(source, "usingMDMA") or false
	if isUsingMDMA then
		local weaponDamage = getWeaponProperty(weapon, "poor", "damage") 
		if weaponDamage then 
			local mdmaBonus = math.floor(loss * 0.2) -- -20% du damage
			local playerHealth = getElementHealth(source) or 50
			setElementHealth(source, math.max(0, playerHealth + mdmaBonus))
			return cancelEvent()
		end 
	end
	if weapon <= 15 then 
		if attacker and getElementType(attacker) == "player" then 
			local isAttackerUsingHeroine = getElementData(attacker, "usingHeroine") or false
			if isAttackerUsingHeroine then 
				local heroineBonus = loss * 0.2 -- +20% du damage
				local playerHealth = getElementHealth(source) or 50
				setElementHealth(source, math.max(0, playerHealth - heroineBonus))
				return cancelEvent()
			end
		end
	end
end
addEventHandler("onClientPlayerDamage", root, handleDamages)