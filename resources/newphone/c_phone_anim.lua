
function setUsingPhone(player)	
	setElementBoneRotation(player, 23, -7.3021475088808e-08, -77.045669555664, 20)
	setElementBoneRotation(player, 24, 156.05712890625, 6.4960169792175, -10.051412582397)
	setElementBoneRotation(player, 25, 0.42805814743042, 69.017868041992, -2.0940234661102)
	updateElementRpHAnim(player)
end

function setCallingPhone(player)	
	setElementBoneRotation(player, 21, 26.456909179688, 111.29893493652, 78.521766662598)
	setElementBoneRotation(player, 22, 11.221781730652, -33.32625579834, -61.457588195801)
	setElementBoneRotation(player, 23, -9.9999971389771, -145.67315673828, 3)
	setElementBoneRotation(player, 24, 120, 25, 30)
	setElementBoneRotation(player, 25, 0.42805814743042, 69.017868041992, -2.0940234661102)
	setElementBoneRotation(player, 26, 0, 46.970352172852, -0)
	updateElementRpHAnim(player)
end

local attachedPhones = {}
local animatingPlayers = {}
local animating = false

function updateCustomAnimPlayers()
    for ped, v in pairs(animatingPlayers) do
    	if isElement(ped) then
			if isElementStreamedIn(ped) then
				if v.animType == "calling" then
					setCallingPhone(ped)
				elseif v.animType == "videoCall" then
					
				else
					setUsingPhone(ped)
				end
				if not v.attachUpdated then
					exports.pAttach:attach(attachedPhones[ped], ped, "weapon", 0.053, 0.048, 0.025, 87, -111, -51)
					animatingPlayers[ped].attachUpdated = true
				end
			end
		else
			handlePhoneAnimationUpdate(ped, false, false)
		end
	end
end

function handlePhoneAnimationUpdate(thePlayer, animType, state)
	if not state then
		animatingPlayers[thePlayer] = nil
		if isElement(attachedPhones[thePlayer]) then
			destroyElement(attachedPhones[thePlayer])
		end
		attachedPhones[thePlayer] = nil
	else
		if not isElement(attachedPhones[thePlayer]) then
			local x,y,z = getElementPosition(thePlayer)
			local i,d = getElementInterior(thePlayer), getElementDimension(thePlayer)
			local obj = createObject(1875, x, y, z)
			setElementData(obj, "objectID", 100105, false)
			setObjectScale(obj, 0.85)
			setElementPosition(obj, x,y,z)
			setElementInterior(obj, i)
			setElementDimension(obj, d)
			attachedPhones[thePlayer] = obj
		end
		animatingPlayers[thePlayer] = {
			animType = animType,
			attachUpdated = false
		}
	end

	for ped, v in pairs(animatingPlayers) do
		if not animating then
			animating = true
			addEventHandler ("onClientPedsProcessed", root, updateCustomAnimPlayers, false, "high+4")
		end
		return
	end

	animating = false
	removeEventHandler ("onClientPedsProcessed", root, updateCustomAnimPlayers)
end
addEvent("newphone:animUpdate", true)
addEventHandler("newphone:animUpdate", localPlayer, handlePhoneAnimationUpdate)
