local isBallInHand = false
local balls = { }
local playerAnimTimers = {}
local playerAnims = {}

function gBall(ballid)
	balls [ ballid ] = source
    setElementCollisionsEnabled(source, false)
end
addEvent("basketball:announceball" , true )
addEventHandler("basketball:announceball",getRootElement(),gBall)

function onResourceStart(resource)
	if (resource == getThisResource()) then
		if #balls == 0 then
			triggerServerEvent("basketball:announceball", source)
		end
	end
end
addEventHandler("onClientResourceStart", getRootElement(), onResourceStart)

addEventHandler("onClientPlayerQuit", root,
	function()
		if isTimer(playerAnimTimers[source]) then
			killTimer(playerAnimTimers[source])

			playerAnimTimers[source] = nil
		end

		playerAnims[source] = nil
	end
)


function updateBallStatus(ballElement, isBallInHand, doDropball, delayAnimReset)
	local source = source

	if (isBallInHand) then
		local boX, boY, boZ = getPedBonePosition(source, 26)
		local boZ = boZ - 0.1
		setElementPosition(ballElement, boX, boY, boZ)
		
		if source == getLocalPlayer() then
			isBallInHand = true
		end

        --setPedAnimation(source, "bsktball", "bball_idleloop_o", 1, false, false, false, true, 250, false)
        --setTimer(setPedAnimation, 50, 0, source, "bsktball", "bball_idleloop", 1, true, false, false, true, 250, false)

		playerAnimTimers[source] = setTimer(
			function()
				if isElement(source) then
					if not getElementData(source, "basketball.isShootingBall", false) then
						setPedAnimation(source, "bsktball", playerAnims[source], 1, false, true, false, true, 250, false)
					end
				else
					if isTimer(playerAnimTimers[source]) then
						killTimer(playerAnimTimers[source])

						playerAnimTimers[source] = nil
					end
				end
			end,
		100, 0)
	else
		if doDropball then
			local pX,pY,pZ = getElementPosition(source)
			local pZ = pZ - 0.9
			setElementPosition(ballElement, pX, pY, pZ)
	
			setTimer(
				function()
					if isTimer(playerAnimTimers[source]) then
						killTimer(playerAnimTimers[source])
			
						playerAnimTimers[source] = nil
					end
			
                    setPedAnimation(source, "bsktball", playerAnims[source], 1, false, true, true, false, 250, true)

					playerAnims[source] = nil
				end, 
			delayAnimReset and 750 or 100, 1, source)
		end		
		
		if source == getLocalPlayer() then
			isBallInHand = false
		end
	end
end
addEvent("basketball:cstatus",true)
addEventHandler("basketball:cstatus",getRootElement(),updateBallStatus)

function updateBallPositions()
	for ballID,ballElement in pairs(balls) do
		local personHoldingIt = getElementData(ballElement, "heldby")
		if personHoldingIt then
			if (isElement(personHoldingIt)) then
				local pX,pY,pZ = getPedBonePosition(personHoldingIt, 26)
				local x, y, z = getElementPosition(personHoldingIt)
				local pZ = z - 0.3 + (pZ - z) * 2
				setElementPosition(ballElement, pX, pY, pZ)

				if getPedControlState(personHoldingIt, "forwards") or getPedControlState(personHoldingIt, "backwards") or getPedControlState(personHoldingIt, "left") or getPedControlState(personHoldingIt, "right") then
					if getPedControlState(personHoldingIt, "sprint") then
						playerAnims[personHoldingIt] = "bball_run"

						if personHoldingIt == localPlayer then
							local fwX, fwY, fwZ = getMatrixForward(getElementMatrix(personHoldingIt))

							setElementPosition(personHoldingIt, x + fwX * 0.02, y + fwY * 0.02, z + fwZ * 0.02, false)
						end
					else
						playerAnims[personHoldingIt] = "bball_walk"
					end
				else
					playerAnims[personHoldingIt] = "bball_idleloop"
				end
			end
		end
	end
end
addEventHandler("onClientRender", getRootElement(), updateBallPositions)

function togBall(commandName)
	if isPedInVehicle(getLocalPlayer()) then
		return
	end
	local pX,pY,pZ=getElementPosition(getLocalPlayer())
	
	for ballID,ballObject in pairs(balls) do
		local bX,bY,bZ=getElementPosition(ballObject)
			if getDistanceBetweenPoints2D(pX,pY,bX,bY ) < 1 then
				if not isBallInHand then
					setPedWeaponSlot(getLocalPlayer(),0)
					triggerServerEvent("basketball:status", ballObject, not isBallInHand)
				end
			end
	end
end
addCommandHandler("pickball",togBall)

function playBoardSound(bSound, theBasket)
	local playerX, playerY, playerZ = getElementPosition( getLocalPlayer() )
	local basketX, basketY, basketZ = getElementPosition( theBasket )
	if getDistanceBetweenPoints3D(playerX, playerY, playerZ, basketX, basketY, basketZ ) < 30 then
		if (bSound == 1) then
			local theSound = playSound3D("bball/board.ogg", basketX, basketY, basketZ)
		elseif (bSound == 2) then
			local theSound = playSound3D("bball/drible.ogg", basketX, basketY, basketZ)
			setSoundVolume(theSound, 0.2)
		elseif (bSound == 3) then
			local theSound = playSound3D("bball/board.ogg", basketX, basketY, basketZ)
			setSoundMaxDistance(theSound, 15)
		elseif (bSound == 4) then
			local theSound = playSound3D("bball/boardhit.ogg", basketX, basketY, basketZ)
			setSoundVolume(theSound, 0.5)
			setSoundMaxDistance(theSound, 18)
		end
	end
end
addEvent("bball:soundBoard",true)
addEventHandler("bball:soundBoard",getLocalPlayer(), playBoardSound )

function getMatrixForward(m)
    return m[2][1], m[2][2], m[2][3]
end