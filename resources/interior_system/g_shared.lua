-- Defines
INTERIOR_X = 1
INTERIOR_Y = 2
INTERIOR_Z = 3
INTERIOR_INT = 4
INTERIOR_DIM = 5
INTERIOR_ANGLE = 6
INTERIOR_FEE = 7

INTERIOR_TYPE = 1
INTERIOR_DISABLED = 2
INTERIOR_LOCKED = 3
INTERIOR_OWNER = 4
INTERIOR_COST = 5
INTERIOR_SUPPLIES = 6
INTERIOR_FACTION = 7

INTERIOR_TYPES = {
	[0] = "Résidentiel",
	[1] = "Biz",
	[2] = "Propriété de l'état",
	[3] = "Location",
	[4] = "Planque",
	[5] = "Biz - Hidden",
}

-- Nando (24/02/2023)
function canAdminLockVehicles(player)
	return exports.integration:isPlayerSeniorAdmin(player) and getElementData(player, "duty_admin") == 1
end

function canEnterInterior(theInterior)
	local interiorID = getElementData(theInterior, "dbid")
	if interiorID then
		local interiorStatus = getElementData(theInterior, "status")
		if interiorStatus.disabled then
			return false, 1, "Cet intérieur est actuellement désactivé."
		elseif interiorStatus.locked then
			return false, 2, "Vous essayez de bouger la poignée de porte, mais vous remarquez que celle-ci est verrouillée."
		end
		return true
	end
	return false, 3, "Script error 100.4"
end

function isInteriorForSale( theInterior )
	local interiorStatus = getElementData(theInterior, "status") 
	if not interiorStatus then
		return false
	end

	if interiorStatus.type ~= 2 then
		if interiorStatus.owner <= 0 and interiorStatus.faction <= 0 then
			if interiorStatus.locked then
				if not interiorStatus.disabled then
					return true
				end
			end
		end
	end		
	return false
end

function isPlayerInteriorTenant(player, interiorID)
	local dbid, entrance, exit, interiorType, interiorElement = findProperty(nil, interiorID)
	
	if dbid > 0 then
		local tenants = getElementData(interiorElement, "tenants")
		local charid = getElementData(player, "dbid")

		for i, v in ipairs(tenants) do
			if v.charid == charid then
				return true
			end
		end
	end
end

function getInteriorTenantCount(interiorID)
	local dbid, entrance, exit, interiorType, interiorElement = findProperty(nil, interiorID)
	
	if dbid > 0 then
		return #getElementData(interiorElement, "tenants")
	end
end


function tempFix( tab )
	--[[
	INTERIOR_X = 1
	INTERIOR_Y = 2
	INTERIOR_Z = 3
	INTERIOR_INT = 4
	INTERIOR_DIM = 5
	INTERIOR_ANGLE = 6
	INTERIOR_FEE = 7

	INTERIOR_TYPE = 1
	INTERIOR_DISABLED = 2
	INTERIOR_LOCKED = 3
	INTERIOR_OWNER = 4
	INTERIOR_COST = 5
	INTERIOR_SUPPLIES = 6
	INTERIOR_FACTION = 7
	]]
	tab.x = tab.x or tab[INTERIOR_X]
	tab.y = tab.y or tab[INTERIOR_Y]
	tab.z = tab.z or tab[INTERIOR_Z]
	tab.int = tab.int or tab[INTERIOR_INT]
	tab.dim = tab.dim or tab[INTERIOR_DIM]
	tab.rot = tab.rot or tab[INTERIOR_ANGLE]
	tab.fee = tab.fee or tab[INTERIOR_FEE]
	tab.type = tab.type or tab[INTERIOR_TYPE]
	tab.disabled = tab.disabled or tab[INTERIOR_DISABLED]
	tab.locked = tab.locked or tab[INTERIOR_LOCKED]
	tab.owner = tab.owner or tab[INTERIOR_OWNER]
	tab.supplies = tab.supplies or tab[INTERIOR_SUPPLIES]
	tab.faction = tab.faction or tab[INTERIOR_FACTION]
	return tab
end