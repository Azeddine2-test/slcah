local cleanBlip = nil
local cleanMarker = nil
local currentCheckpoint = 1

math.randomseed(os.time())

local objects = {
	{18099, -0.6},
	{18100, -0.6},
	{18101, -0.6},
	{2672, -0.6},
	{2674, -0.6},
	{2673, -0.6},
	{2671, -0.6},
	{2670, -0.6},
}

local routes = {

	{2284.1279296875, -2373.498046875, 13.130591392517},
	{2222.7763671875, -2520.7236328125, 13.148285865784},
	{2327.287109375, -2665.91796875, 13.231853485107},
	{2488.21484375, -2597.78125, 13.186689376831},
	{2647.3623046875, -2506.5205078125, 13.21729183197},
	{2763.6591796875, -2457.94921875, 13.246988296509},
	{2631.4169921875, -2402.296875, 13.185778617859},
	{2467.6103515625, -2260.5400390625, 24.787540435791},
	{2299.0283203125, -2068.73046875, 13.081544876099},
	{2429.6982421875, -2051.599609375, 22.246692657471},
	{2679.0966796875, -2051.78515625, 14.760184288025},
	{2646.9951171875, -2007.2021484375, 13.107951164246},
	{2740.4189453125, -1996.9404296875, 13.069913864136},
	{2772.1279296875, -1934.3974609375, 13.051781654358},
	{2652.0341796875, -1834.287109375, 10.568830490112},
	{2645.44921875, -1656.0712890625, 10.435758590698},
	{2612.599609375, -1442.3994140625, 32.187637329102},
	{2514.384765625, -1406.009765625, 28.084421157837},
	{2544.7216796875, -1258.6513671875, 40.982036590576},
	{2568.5751953125, -1290.49609375, 45.685939788818},
	{2568.4326171875, -1427.76953125, 23.556955337524},
	{2483.048828125, -1502.0751953125, 23.561046600342},
	{2412.12109375, -1442.294921875, 23.55703163147},
	{2374.111328125, -1343.87109375, 23.556600570679},
	{2373.244140625, -1212.822265625, 27.154655456543},
	{2272.5478515625, -1144.0712890625, 26.489845275879},
	{2172.90625, -1185.6689453125, 23.937412261963},
	{2095.533203125, -1218.5693359375, 23.529790878296},
	{2030.8603515625, -1133.1728515625, 24.190305709839},
	{1970.0146484375, -1222.4560546875, 24.756576538086},
	{2064.8046875, -1277.8701171875, 23.545303344727},
	{2014.091796875, -1338.3642578125, 23.545425415039},
	{1984.4775390625, -1444.470703125, 13.123719215393},
	{2109.3359375, -1500.7587890625, 23.519411087036},
	{2118.62890625, -1755.59765625, 13.125393867493},
	{2220.6103515625, -1702.4091796875, 13.255124092102},
	{2320.7626953125, -1662.189453125, 13.628649711609},
	{2489.2958984375, -1682.634765625, 13.061127662659},
	{2502.1767578125, -1659.5791015625, 13.110301017761},
	{2339.330078125, -1700.9150390625, 13.084543228149},
	{2411.0126953125, -1740.8818359375, 13.107960700989},
	{2425.58203125, -2006.2978515625, 13.128993034363},
	{2513.3935546875, -2006.181640625, 13.006349563599},
	{2376.4560546875, -2009.7421875, 13.278752326965},
	{2249.91015625, -2049.275390625, 13.123126029968},
	{2236.591796875, -2205.8828125, 13.069226264954},
	{2286.6669921875, -2334.12890625, 13.272040367126},
	
}

function displayNettoyeur(notext)
	if not isElement(blip) then
		blip = createBlip(2290.7724609375, -2361.04296875, 13.272151947021, 0, 4, 255, 255, 0)
	end
	if not notext then
		exports.hud:sendBottomNotification(localPlayer, "Nettoyeur", "Approchez le marqueur jaune sur votre radar et faites /startsweeper pour commencer à travailler.")
	end
end

function startNettoyeurJob()

	local myJob = getElementData(localPlayer, "job") or 0
	if myJob ~= 4 then
		return exports["srp_notifs"]:add("Vous ne travaillez pas comme Nettoyeur.", "error")
	end
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh or ((getElementData(veh, "job") or 0) ~= myJob) then
		return exports["srp_notifs"]:add("Vous devez être dans un véhicule de travail pour commencer à travailler.", "error")
	end

	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if seat ~= 0 then
		return exports["srp_notifs"]:add("Vous devez être au volant pour commencer à travailler.", "error")
	end
    if isElement(cleanBlip) then
        return
    end

    currentCheckpoint = 1
    createNettoyeurCheckpoints()

	triggerServerEvent("lspd:toggleFlashers", root)
	outputChatBox("Nettoyeur - Suivez les marqueurs pour nettoyer la rue. Appuyez sur P pour les stroboscopes.", 255, 255, 255)
end
addCommandHandler("startsweeper", startNettoyeurJob)

local function enterNettoyeur(theVehicle, seat)
	local myJob = getElementData(localPlayer, "job") or 0
	if myJob == 4 and ((getElementData(theVehicle, "job") or 0) == myJob) and seat == 0 then
		if isElement(cleanBlip) then
			return
		end
		outputChatBox("Nettoyeur - Faites /startsweeper pour commencer à travailler.", 255, 255, 255)
	end
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, enterNettoyeur)

function createNettoyeurCheckpoints()
	local myJob1 = getElementData(localPlayer, "job") or 0
	if myJob1 ~= 4 then
		return exports["srp_notifs"]:add("Vous ne travaillez pas comme Nettoyeur.", "error")
	end

    if currentCheckpoint > #routes then
        if isElement(trashObject) then destroyElement(trashObject) end
		outputChatBox("Nettoyeur - Vous avez terminé votre tournée, faites /startsweeper pour en recommencer une.", 0, 255, 0)
		triggerServerEvent("lspd:toggleFlashers", root, "OFF")
		triggerServerEvent("job:sweeper:giveMoney", resourceRoot)
		return
    end

    local route = routes[currentCheckpoint]

    cleanBlip = createBlip(route[1], route[2], route[3], 0, 2, 128, 255, 0)
    cleanMarker = createMarker(route[1], route[2], route[3] - 1, "cylinder", 3, 128, 255, 0, 0)

    if isElement(trashObject) then destroyElement(trashObject) end
	local robj = math.random(1, #objects)
	robj = objects[robj]
    trashObject = createObject(robj[1], route[1], route[2], route[3] + robj[2])

    currentCheckpoint = currentCheckpoint + 1

    addEventHandler("onClientMarkerHit", cleanMarker, function(player)
        if player == localPlayer then
			local myJob = getElementData(localPlayer, "job") or 0
			if myJob ~= 4 then
				stopNettoyeurJob()
				return exports["srp_notifs"]:add("Vous ne travaillez pas comme Nettoyeur.", "error")
			end

			local veh = getPedOccupiedVehicle(localPlayer)
            if not veh or ((getElementData(veh, "job") or 0) ~= myJob) then
				return exports["srp_notifs"]:add("Vous devez être dans un véhicule de travail pour nettoyer.", "error")
            end

			if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end

			exports["srp_notifs"]:add("Point "..(currentCheckpoint - 1).." sur "..#routes.." nettoyé.", "success_MUTED")

            destroyElement(cleanBlip)
            destroyElement(cleanMarker)
            createNettoyeurCheckpoints()
        end
    end)
end

function stopNettoyeurJob()
    if isElement(cleanBlip) then
        destroyElement(cleanBlip)
        destroyElement(cleanMarker)
    end
end
addEventHandler("onClientChangeChar", localPlayer, stopNettoyeurJob, false)
