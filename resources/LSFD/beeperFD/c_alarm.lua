local fdAlarm
function playAlarmAroundTheArea(x, y, z, dist)
	if isElement(fdAlarm) then stopSound(fdAlarm) end
	fdAlarm = playSound3D("beeperFD/alarm.mp3", x, y, z, true)
	setSoundMaxDistance(fdAlarm, dist)
	setSoundMinDistance(fdAlarm, dist/2)
	--reps: (7*4sec)-1sec
	setTimer(function()
		if isElement(fdAlarm) then
			stopSound(fdAlarm)
			fdAlarm = nil
		end
	end, 27000, 1)
end
addEvent("playAlarmAroundTheArea", true)
addEventHandler("playAlarmAroundTheArea", localPlayer, playAlarmAroundTheArea, false)

function playPagerSfxAround(beeper)
	local x, y, z = getElementPosition(beeper)
	local int, dim = getElementInterior(beeper), getElementDimension(beeper)
	local pagerSound = playSound3D("beeperFD/pager.mp3", x, y, z)
	setSoundVolume(pagerSound, 0.8)
	setElementInterior(pagerSound, int)
	setElementDimension(pagerSound, dim)
end
addEvent("playPagerSfxAround", true)
addEventHandler("playPagerSfxAround", localPlayer, playPagerSfxAround, false)