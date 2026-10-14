-- Nando: Major optimization refactor (18/03/2023)

-- Used in other hud scripts:
HUD_R, HUD_G, HUD_B = 249, 139, 6 -- #f98b06 Southland Orange

local badges = {}
local masks = {}

myData = {}

myVeh = nil
myVehData = nil

--[[
	Script will fetch element data update for these indexes,
	see the function below
]]
local DATA_NAMES = {
	-- badges auto fill
	-- masks auto fill
	["loggedin"] = true,
	["hide_hud"] = true,
	["hud:whereToDisplay"] = true,
	-- ["hud:whereToDisplayY"] = true,
	["donation:nametag"] = true,
	["nametag_on"] = true,
	["donation:lifeTimeNameTag"] = true,
	["lifeTimeNameTag_on"] = true,
	["duty_admin"] = true,
	["duty_supporter"] = true,
	["supporter_level"] = true, -- Required for admin rank change update
	["admin_level"] = true, -- Required for admin rank change update
	["report_panel_mod"] = true,
	["donation:nametag:expiredate"] = true,
	["donation-system:perks"] = true, -- Required for donators:hasPlayerPerk
	["pmblocked"] = true, -- Required for donators:hasPlayerPerk
	["head_turning"] = true,
	["old_walkstyle"] = true,
	["restrain"] = true,
	["blindfold"] = true,
	["faction"] = true, -- Required for factions:isInFactionType
	["deaglemode"] = true,
	["shotgunmode"] = true,
	["firemode"] = true,
	["gloves"] = true,
	["smoking"] = true,
	["seatbelt"] = true,
	["speedo"] = true,
	-- ["autopark"] = true,
}

local function fetchMyVehData()
	myVehData.hasEngine = exports.vehicle:hasVehicleEngine(myVeh)
	myVehData.hasLights = exports.vehicle:hasVehicleLights(myVeh)
	myVehData.handbrake = getElementData(myVeh, "handbrake")
	myVehData.lights = getElementData(myVeh, "lights")
	myVehData.windowStat = getElementData(myVeh, "vehicle:windowstat")
	myVehData.mdcPerms = exports.mdc:hasMDCPermissions(myVeh)
end

local function fetchLocalPlayerElementData()
	myData.loggedIn = getElementData(localPlayer, "loggedin") == 1
	myData.hideHud = getElementData(localPlayer, "hide_hud") or "2"
	myData.whereToDisplay = getElementData(localPlayer, "hud:whereToDisplay")
	-- myData.whereToDisplayY = getElementData(localPlayer, "hud:whereToDisplayY")
	myData.donationNametag = getElementData(localPlayer, "donation:nametag")
	myData.nametagOn = getElementData(localPlayer, "nametag_on")
	myData.donationLifeTimeNametag = getElementData(localPlayer, "donation:lifeTimeNameTag")
	myData.lifeTimeNametagOn = getElementData(localPlayer, "lifeTimeNameTag_on")

	-- Badge color
	local badgeColor = false
	for k, v in pairs(badges) do
		local title = getElementData(localPlayer, k)
		if title then
			badgeColor = {
				badges[k][1], badges[k][2], badges[k][3], -- r,g,b
				badges[k][4], badges[k][5],
				title -- title text
			}
			break
		end
	end
	myData.badgeColor = badgeColor

	-- Mask icons
	local maskIcons = {}
	for k, v in pairs(masks) do
		if getElementData(localPlayer, v[1]) then
			maskIcons[#maskIcons+1] = v[1]
		end
	end
	myData.maskIcons = maskIcons

	-- Admin / Supporter icons
	local dutyAdmin = getElementData(localPlayer, "duty_admin") or 0
	local dutySupporter = getElementData(localPlayer, "duty_supporter") or 0
	myData.dutyAdmin = dutyAdmin == 1
	myData.dutySupporter = dutySupporter == 1
	local iconAdmin = false
	local iconSup = false
	if exports.integration:isPlayerHeadAdmin(localPlayer) then
		iconAdmin = "ceo"
	elseif exports.integration:isPlayerLeadAdmin(localPlayer) then
		iconAdmin = "leada"
	elseif exports.integration:isPlayerSeniorAdmin(localPlayer) then
		iconAdmin = "adm_on"
	elseif exports.integration:isPlayerAdmin(localPlayer) then
		iconAdmin = "adm_on"
	elseif exports.integration:isPlayerTrialAdmin(localPlayer) then
		iconAdmin = "modo"
	end
	if exports.integration:isPlayerSupporter(localPlayer) then
		iconSup = "gm"
	end
	myData.iconAdmin = iconAdmin
	myData.iconSup = iconSup

	myData.report_panel_mod = getElementData(localPlayer, "report_panel_mod")

	myData.donationNametagExpiring = (getElementData(localPlayer, "donation:nametag:expiredate") or "Updating..")

	local hasTogPM, togPMState = exports.donators:hasPlayerPerk(localPlayer, 1)
	myData.hasTogPM = hasTogPM
	myData.togPMState = togPMState

	local hasTogDon, togDonState = exports.donators:hasPlayerPerk(localPlayer, 10)
	myData.hasTogDon = hasTogDon
	myData.togDonState = togDonState

	local hasHidSco, hidScoState = exports.donators:hasPlayerPerk(localPlayer, 12)
	myData.hasHidSco = hasHidSco
	myData.hidScoState = hidScoState

	local hasHidUser, hidUser = exports.donators:hasPlayerPerk(localPlayer, 9)
	myData.hasHidUser = hasHidUser
	myData.hidUser = hidUser

	myData.head_turning = getElementData(localPlayer, "head_turning")
	myData.old_walkstyle = getElementData(localPlayer, "old_walkstyle")
	myData.restrain = getElementData(localPlayer, "restrain")
	myData.blindfold = getElementData(localPlayer, "blindfold")

	myData.inLawFaction = exports.factions:isInFactionType(localPlayer, 2)

	myData.deaglemode = getElementData(localPlayer, "deaglemode")
	myData.shotgunmode = getElementData(localPlayer, "shotgunmode")
	myData.firemode = getElementData(localPlayer, "firemode")

	myData.gloves = getElementData(localPlayer, "gloves")
	myData.smoking = getElementData(localPlayer, "smoking")

	myData.seatbelt = getElementData(localPlayer, "seatbelt")
	myData.speedo = getElementData(localPlayer, "speedo")
	-- myData.autopark = getElementData(localPlayer, "autopark")

	if isElement(myVeh) then
		fetchMyVehData()
	end
end

local function handleLocalPlayerDataChange(dataName, oldValue, newValue)
	if DATA_NAMES[dataName] == nil then
		return
	end
	fetchLocalPlayerElementData()
end
addEventHandler("onClientElementDataChange", localPlayer, handleLocalPlayerDataChange, false)

local function handleVehicleEnter(veh, seat)
	myVeh = veh
	myVehData = {}
	fetchMyVehData()
	removeEventHandler("onClientElementDataChange", myVeh, fetchMyVehData, false)
	addEventHandler("onClientElementDataChange", myVeh, fetchMyVehData, false)
end
addEventHandler("onClientPlayerVehicleEnter", localPlayer, handleVehicleEnter, false)

local function handleVehicleExit(veh, seat)
	if myVeh ~= nil then
		if myVeh == veh then
			removeEventHandler("onClientElementDataChange", myVeh, fetchMyVehData, false)
		end
		myVeh = nil
		myVehData = nil
	end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, handleVehicleExit, false)

local function fetchInitialData()
	for k, v in pairs(exports['item-system']:getBadges()) do
		badges[v[1]] = {
			v[4][1], v[4][2], v[4][3], -- r,g,b
			v[5], v.bandana or false,
			v[1] -- element data name
		}
		DATA_NAMES[v[1]] = true
	end

	masks = exports['item-system']:getMasks()
	for k, v in pairs(masks) do
		DATA_NAMES[v[1]] = true
	end

	fetchLocalPlayerElementData()

	local veh = getPedOccupiedVehicle(localPlayer)
	if veh then
		handleVehicleEnter(veh, getPedOccupiedVehicleSeat(localPlayer))
	end

	--addEventHandler("onClientRender", root, drawHUD)
end

local function initStuff(res)
	if getResourceName(res) == "item-system" then
		fetchInitialData()
	elseif (res == resource and getResourceFromName("item-system")) then 
		setTimer(fetchInitialData, 2500, 1)
	end
end
addEventHandler("onClientResourceStart", root, initStuff)
 
local screenWidth, screenHeight = guiGetScreenSize()
local iconW, iconH = 34, 64
local fontToolTip = "clear"
local tooltip_background_color = tocolor( 0, 0, 0, 180 )
local tooltip_text_color = tocolor( 255, 255, 255, 255 )

-- CHECK IF MOUSE IS WITHIN A DX BOX
-- used in other hud script(s)
function isInBox( x, y, xmin, xmax, ymin, ymax )
	return x >= xmin and x <= xmax and y >= ymin and y <= ymax
end

-- SHOW TOOLTIP AT CURSOR POSITION
local function tooltip( x, y, text, text2 )
	text = tostring( text )
	if text2 then
		text2 = tostring( text2 )
	end
	
	if text == text2 then
		text2 = nil
	end
	
	local width = dxGetTextWidth( text, 1, fontToolTip ) + 20
	if text2 then
		width = math.max( width, dxGetTextWidth( text2, 1, fontToolTip ) + 20 )
		text = text .. "\n" .. text2
	end
	local height = 10 * ( text2 and 5 or 3 )
	x = math.max( 10, math.min( x, screenWidth - width - 10 ) )
	y = math.max( 10, math.min( y, screenHeight - height - 10 ) ) + iconH/3
	
	dxDrawRectangle( x, y, width, height, tooltip_background_color, true )
	dxDrawText( text, x, y, x + width, y + height, tooltip_text_color, 1, fontToolTip, "center", "center", false, false, true )
end

-- Exported
function isFull()
	if getData then
		local hideHud = getElementData(localPlayer, "hide_hud") or "2"
		return (hideHud == "1")
	else
		return myData.hideHud == "1"
	end
end
-- Exported
function isMinimalistic()
	if getData then
		local hideHud = getElementData(localPlayer, "hide_hud") or "2"
		return (hideHud == "2")
	else
		return myData.hideHud == "2"
	end
end
-- Exported
function isActive(getData)
	if getData then
		local hideHud = getElementData(localPlayer, "hide_hud") or "2"
		return not (hideHud == "0" or hideHud == "-1")
	else
		return not (myData.hideHud == "0" or myData.hideHud == "-1")
	end
end

function drawHUD()
	if not isPlayerMapVisible() and myData.loggedIn then
		local ax, ay = screenWidth - iconW - 5, 5
		local bx, by = screenWidth - iconW, screenHeight - iconH + 4
		local cursorX, cursorY, cwX, cwY, cwZ = getCursorPosition()
		local tooltips = {}
		local tooltips_bottom = {}
		local isBike = false
		
		--THIS IS TO LET THE FORUMS PM CHECKER KNOW WHERE TO DISPLAY
		-- if myData.whereToDisplayY ~= ay then
		-- 	setElementData(localPlayer, "hud:whereToDisplayY", ay, false)
		-- 	myData.whereToDisplayY = ay
		-- end

		-- TOGGLE HUD 
		--[[ if (myData.hideHud) == "2" then
			dxDrawImage(ax,ay,iconH,iconH,"images/hud/tagmode.png")
			table.insert(tooltips, "settings:hud:tagmode:newstyle:minimal")
			ax = ax - iconW
		elseif (myData.hideHud) == "1" then
			dxDrawImage(ax,ay,iconH,iconH,"images/hud/tagmode.png")
			table.insert(tooltips, "settings:hud:tagmode:newstyle:on")
			ax = ax - iconW
		elseif (myData.hideHud) == "0" then
			dxDrawImage(ax,ay,iconH,iconH,"images/hud/tagmode.png", 0, 0, 0, disabled_item(100))
			table.insert(tooltips, "settings:hud:tagmode:newstyle:off")
			ax = ax - iconW
		end *]]

		if isActive() then
			
			-- ADMIN / SUPPORTER
			--[[ local iconAdmin = myData.iconAdmin
			local iconSup = myData.iconSup
			if iconAdmin then
				if myData.dutyAdmin then
					dxDrawImage(ax, ay, iconH, iconH, "images/hud/"..iconAdmin..".png")
					tooltips[#tooltips+1] = "adminonduty"
				else
					dxDrawImage(ax, ay, iconH, iconH, "images/hud/"..iconAdmin..".png", 0, 0, 0, disabled_item(100))
					tooltips[#tooltips+1] = "adminoffduty"
				end
				ax = ax - iconW
			end
			if iconSup then
				if myData.dutySupporter then
					dxDrawImage(ax, ay, iconH, iconH, "images/hud/"..iconSup..".png")
					tooltips[#tooltips+1] = "gmonduty"
				else
					dxDrawImage(ax, ay, iconH, iconH, "images/hud/"..iconSup..".png", 0, 0, 0, disabled_item(100))
					tooltips[#tooltips+1] = "gmoffduty"
				end
				ax = ax - iconW
			end
			
			-- REPORT PANEL TAG 
			if (iconAdmin or iconSup)then
				if myData.report_panel_mod == "1" then
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/reportpanel_on.png")
					table.insert(tooltips, "report_panel_mod:1")
				elseif myData.report_panel_mod == "2" then
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/reportpanel_on.png")
					table.insert(tooltips, "report_panel_mod:2")
				elseif myData.report_panel_mod == "3" then
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/reportpanel_on.png")
					table.insert(tooltips, "report_panel_mod:3")
				else
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/reportpanel_on.png", 0, 0, 0, disabled_item(100))
					table.insert(tooltips, "report_panel_mod:0")
				end
				ax = ax - iconW
			end

			local armor = getPedArmor( localPlayer )
			if armor > 0 then
				dxDrawImage(ax,ay,iconH,iconH,"images/hud/armour2.png", 0, 0, 0, disabled_item(255/100*armor))
				table.insert(tooltips, "armour") 
				ax = ax - iconW
			end	 *]]
			
			--HEATH
			--[[ local health = getElementHealth( localPlayer )
			local tick = math.floor(getTickCount () / 1000) % 2
			local healthV = "health2"
			local healthV2 = disabled_item(255/100*health)
			if health <= 30 and tick == 0 then
				healthV = "bleeding"
				healthV2 = disabled_item(255)
			elseif (health <= 30) then
				healthV = "lowhp"
				healthV2 = disabled_item(255)
			end
			table.insert(tooltips, "health")
			dxDrawImage(ax,ay,iconH,iconH,"images/hud/"..healthV..".png", 0, 0, 0, healthV2)
			ax = ax - iconW

			if myData.restrain == 1 then
				dxDrawImage(ax,ay,iconH,iconH,"images/hud/handcuffs.png")
				ax = ax - iconW
				table.insert(tooltips, "handcuffs")
			end

			if myData.blindfold == 1 then
				dxDrawImage(ax,ay,iconH,iconH,"images/hud/blindfold.png")
				ax = ax - iconW
				table.insert(tooltips, "blindfold")
			end
			
			if myData.gloves then
				dxDrawImage(ax,ay,iconH,iconH,"images/hud/gloves.png")
				table.insert(tooltips, "gloves")
				ax = ax - iconW
			end

			if myData.smoking then
				dxDrawImage(ax,ay,iconH,iconH,"images/hud/cigarette.png")
				table.insert(tooltips, "cigarette")
				ax = ax - iconW
			end
		
			if myData.badgeColor then
				local title = myData.badgeColor[6]
				if title then
					if myData.badgeColor[5] then
						local r,g,b = myData.badgeColor[1], myData.badgeColor[2], myData.badgeColor[3]
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/bandana.png", 0, 0, 0, tocolor(r,g,b))
						table.insert(tooltips, "bandana") 
					elseif myData.badgeColor[4] then
						local v = "badge" .. tostring(myData.badgeColor[4] < 3 and myData.badgeColor[4] or 1)
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/" .. v..".png")
						table.insert(tooltips, v) 
					end
					ax = ax - iconW
				end
			end
			if #myData.maskIcons > 0 then
				for i=1, #myData.maskIcons do
					local maskIcon = myData.maskIcons[i]
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/"..maskIcon..".png")
					table.insert(tooltips, maskIcon) 
					ax = ax - iconW
				end
			end *]]

			-- DEAGLE MODE
			--[[ if myData.inLawFaction
			and (getPedWeapon(localPlayer) == 24) and (getPedTotalAmmo(localPlayer) > 0) then
				local deagleMode = myData.deaglemode
				if (deagleMode == 0) then -- tazer
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/dtazer.png")
				elseif (deagleMode == 1) then-- lethal
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/dglock.png")
				elseif (deagleMode == 2) then-- radar
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/dradar.png")
				end
				ax = ax - iconW
				table.insert(tooltips, {"deaglemode", deagleMode})
			end *]]
			
			-- SHOTGUN MODE 
			--[[ if myData.inLawFaction
			and (getPedWeapon(localPlayer) == 25) and (getPedTotalAmmo(localPlayer) > 0) then
				local shotgunMode = myData.shotgunmode
				if shotgunMode == 0 then -- beanbag
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/shotbean2.png")
				elseif shotgunMode == 1 then -- lethal
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/shotlethal2.png")
				end
				ax = ax - iconW
				table.insert(tooltips, {"shotgunmode", shotgunMode } )
			end
			
			if (getPedWeapon(localPlayer)==31)
			or (getPedWeapon(localPlayer)==30)
			or (getPedWeapon(localPlayer)==29)
			or (getPedWeapon(localPlayer)==28)
			or (getPedWeapon(localPlayer)==32)
			and (getPedTotalAmmo(localPlayer) > 0) then
				local fireMode = myData.firemode
				if (fireMode == 0) then -- auto
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/auto.png")
					table.insert(tooltips, "firemode:auto")
				elseif (fireMode == 1) then-- semi-auto
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/semiauto.png")
					table.insert(tooltips, "firemode:semi")
				end
				ax = ax - iconW
			end *]]

			-- HUD ON (not minimalistic)
			if myData.hideHud == "1" then

				--GOLDEN NAMETAG 
				--[[ if myData.donationNametag then -- Golden nametag
					if myData.nametagOn then
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/donor.png")
						table.insert(tooltips, "nametag_on")
						ax = ax - iconW
					else
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/donor.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips, "nametag_off")
						ax = ax - iconW
					end
				else
					if myData.donationLifeTimeNametag then
						if myData.lifeTimeNametagOn then
							dxDrawImage(ax,ay,iconH,iconH,"images/hud/donor.png")
							table.insert(tooltips, "lifeTimeNameTag_on")
							ax = ax - iconW
						else
							dxDrawImage(ax,ay,iconH,iconH,"images/hud/donor.png", 0, 0, 0, disabled_item(100))
							table.insert(tooltips, "lifeTimeNameTag_off")
							ax = ax - iconW
						end
					end
				end *]]
				
				-- TOGGLE PMS 
				--[[ local hasTogPM, togPMState = myData.hasTogPM, myData.togPMState
				if hasTogPM then
					if tonumber(togPMState) == 1 then
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/togpm.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips, "settings:hud:togpm:off")
						ax = ax - iconW
					else
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/togpm.png")
						table.insert(tooltips, "settings:hud:togpm:on")
						ax = ax - iconW
					end
				end *]]
				
				-- TOGGLE DON CHAT 
				--[[ local hasTogDon, togDonState = myData.hasTogDon, myData.togDonState
				if hasTogDon then
					if tonumber(togDonState) ~= 0 then
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/togdon.png")
						table.insert(tooltips, "settings:hud:togdon:on")
						ax = ax - iconW
					else
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/togdon.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips, "settings:hud:togdon:off")
						ax = ax - iconW
					end
				end *]]
				
			
				-- WALKING STYLE
				--[[ if not myData.old_walkstyle then
					dxDrawImage(ax,ay,iconH,iconH,"images/hud/walkingstyle.png")
					table.insert(tooltips, "settings:hud:walkingstyle")
					ax = ax - iconW
				end *]]
				
				-- HEAD TURNING STYLE
				-- Nando: deactivated head movement | 07/03/2023
				-- if myData.head_turning == "1" then
				-- 	dxDrawImage(ax,ay,iconH,iconH,"images/hud/head_turning.png")
				-- 	table.insert(tooltips, "settings:hud:head_turning:1")
				-- 	ax = ax - iconW
				-- elseif myData.head_turning == "2" then
				-- 	dxDrawImage(ax,ay,iconH,iconH,"images/hud/head_turning.png")
				-- 	table.insert(tooltips, "settings:hud:head_turning:2")
				-- 	ax = ax - iconW
				-- else
				-- 	dxDrawImage(ax,ay,iconH,iconH,"images/hud/head_turning.png", 0, 0, 0, disabled_item(100))
				-- 	table.insert(tooltips, "settings:hud:head_turning:0")
				-- 	ax = ax - iconW
				-- end
				
				-- toggle hidden scoreboard 
				--[[ local hasHidSco, hidScoState = myData.hasHidSco, myData.hidScoState
				if hasHidSco then
					if tonumber(hidScoState) == 1 then
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/hidden_scoreboard.png")
						table.insert(tooltips, "settings:hud:hidden_scoreboard:on")
					else
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/hidden_scoreboard.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips, "settings:hud:hidden_scoreboard:off")
					end
					ax = ax - iconW
				end *]]
				
				-- toggle hidden username 
				--[[ local hasHidUser, hidUser = myData.hasHidUser, myData.hidUser
				if hasHidUser then
					if tonumber(hidUser) == 1 then
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/hide_username.png")
						table.insert(tooltips, "settings:hud:hidden_username:on")
					else
						dxDrawImage(ax,ay,iconH,iconH,"images/hud/hide_username.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips, "settings:hud:hidden_username:off")
					end
					ax = ax - iconW
				end *]]

				-- Offline pm 
				--[[ dxDrawImage(ax,ay,iconH,iconH,"images/hud/opm.png", 0, 0, 0, tocolor(255,255,0))
				table.insert(tooltips, "settings:hud:opm")
				ax = ax - iconW *]]
			end


			-- For notifications icon (resource: announcement)
			ax = ax - iconW
			if myData.whereToDisplay ~= ax then
				setElementData(localPlayer, "hud:whereToDisplay", ax, false)
				myData.whereToDisplay = ax
			end

			--[[ if isElement(myVeh) then
				local vehType = exports.global:getVehicleType(myVeh)
				-- TOGGLE MODE / BOTTOM 
				if myVehData.hasEngine then
					if getVehicleEngineState(myVeh) then
						dxDrawImage(bx,by,iconH,iconH,"images/hud/engine.png")
						table.insert(tooltips_bottom, "settings:hud:engine:on")
						bx = bx - iconW
					else
						dxDrawImage(bx,by,iconH,iconH,"images/hud/engine.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips_bottom, "settings:hud:engine:off")
						bx = bx - iconW
					end
				end

				if myVehData.handbrake == 0 then
					if vehType == "Boat" then
						dxDrawImage(bx,by,iconH,iconH,"images/hud/boathandbrake.png", 0, 0, 0, disabled_item(100))
					else
						dxDrawImage(bx,by,iconH,iconH,"images/hud/handbrake.png", 0, 0, 0, disabled_item(100))
					end
					table.insert(tooltips_bottom, "settings:hud:handbrake:off")
					bx = bx - iconW
				else
					if vehType == "Boat" then
						dxDrawImage(bx,by,iconH,iconH,"images/hud/boathandbrake.png", 0, 0, 0)
					else
						dxDrawImage(bx,by,iconH,iconH,"images/hud/handbrake.png", 0, 0, 0)
					end
					table.insert(tooltips_bottom, "settings:hud:handbrake:on")
					bx = bx - iconW
				end

				if myVehData.hasLights then
					local light_state = myVehData.lights or 0
					if light_state > 0 then
						dxDrawImage(bx,by,iconH,iconH,"images/hud/headlights_"..light_state..".png")
						table.insert(tooltips_bottom, "settings:hud:headlights:"..light_state)
						bx = bx - iconW
					else
						dxDrawImage(bx,by,iconH,iconH,"images/hud/headlights_1.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips_bottom, "settings:hud:headlights:0")
						bx = bx - iconW
					end
				end

				--BELT 
				if (vehType ~= "BMX" and vehType ~= "Bike") then
					if myData.seatbelt then
						dxDrawImage(bx,by,iconH,iconH,"images/hud/seatbelt.png")
						table.insert(tooltips_bottom, "belt:on")
					else
						dxDrawImage(bx,by,iconH,iconH,"images/hud/seatbelt.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips_bottom, "belt:off")
					end
					bx = bx - iconW

					--WINDOWS
					if (myVehData.windowStat == 1) then
						dxDrawImage(bx,by,iconH,iconH,"images/hud/window2.png")
						table.insert(tooltips_bottom, "windowstat:down")
					else
						dxDrawImage(bx,by,iconH,iconH,"images/hud/window.png")
						table.insert(tooltips_bottom, "windowstat:up")
					end
					bx = bx - iconW

					--Lock 
					if isVehicleLocked(myVeh) then
						dxDrawImage(bx,by,iconH,iconH,"images/hud/carlock.png")
						table.insert(tooltips_bottom, "hud:carlock:on")
					else
						dxDrawImage(bx,by,iconH,iconH,"images/hud/carlock.png", 0, 0, 0, disabled_item(100))
						table.insert(tooltips_bottom, "hud:carlock:off")
					end
					bx = bx - iconW
					isBike = false
				else
					isBike = true
				end
				
				if exports["realism"]:isCcEnabled() then
					dxDrawImage(bx,by,iconH,iconH,"images/hud/cc.png")
					table.insert(tooltips_bottom, "cc:on")
				else
					dxDrawImage(bx,by,iconH,iconH,"images/hud/cc.png", 0, 0, 0, disabled_item(100))
					table.insert(tooltips_bottom, "cc:off")
				end
				bx = bx - iconW
				
				if myData.speedo == "1" then
					dxDrawImage(bx,by,iconH,iconH,"images/hud/speedo.png")
					table.insert(tooltips_bottom, "settings:hud:speedo:kmh")
					bx = bx - iconW
				elseif myData.speedo == "2" then
					dxDrawImage(bx,by,iconH,iconH,"images/hud/speedo.png")
					table.insert(tooltips_bottom, "settings:hud:speedo:mph")
					bx = bx - iconW
				else 
					dxDrawImage(bx,by,iconH,iconH,"images/hud/speedo.png", 0, 0, 0, disabled_item(100))
					table.insert(tooltips_bottom, "settings:hud:speedo:off")
					bx = bx - iconW
				end

				-- TOGGLE AUTOPARK / BOTTOM 
				-- if myData.autopark == "1" then
				-- 	dxDrawImage(bx,by,iconH,iconH,"images/hud/autopark.png")
				-- 	table.insert(tooltips_bottom, "settings:hud:autopark:on")
				-- 	bx = bx - iconW
				-- else
				-- 	dxDrawImage(bx,by,iconH,iconH,"images/hud/autopark.png", 0, 0, 0, disabled_item(100))
				-- 	table.insert(tooltips_bottom, "settings:hud:autopark:off")
				-- 	bx = bx - iconW
				-- end

				-- MDC for LEO/ BOTTOM 
				if myVehData.mdcPerms then
					dxDrawImage(bx,by,iconH,iconH,"images/hud/mdc.png")
					table.insert(tooltips_bottom, "settings:hud:mdc")
					bx = bx - iconW
				end
			end *]]
		end

		--SHOWING TOOLTIP + ACTIONS ON CLIENT CLICK 
		if isCursorShowing() then
			ax, ay = screenWidth, 0
			bx, by = screenWidth, screenHeight - iconH + 4
			cursorX, cursorY = cursorX * screenWidth, cursorY * screenHeight
			
			for i = 1, #tooltips do
				ax = ax - iconW
				if isInBox( cursorX, cursorY, ax, ax + iconW, ay, ay + iconH/2 ) then
					--ADMIN DUTY 
					if tooltips[i] == "adminonduty" then
						tooltip( cursorX, cursorY, "Duty Admin: ON", "Cliquer pour se mettre Off-Duty")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_admin", 0)
							--triggerServerEvent("updateNametagColor", localPlayer)
							playToggleSound()
						end
					elseif tooltips[i] == "adminoffduty" then
						tooltip( cursorX, cursorY, "Duty Admin: OFF", "Cliquer pour se mettre On-Duty")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_admin", 1)
							--triggerServerEvent("updateNametagColor", localPlayer)
							playToggleSound()
						end
					--GM DUTY 
					elseif tooltips[i] == "gmonduty" then
						tooltip( cursorX, cursorY, "Duty Support: ON", "Cliquer pour se mettre Off-Duty")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_supporter", 0)
							--triggerServerEvent("updateNametagColor", localPlayer)
							playToggleSound()
						end
					elseif tooltips[i] == "gmoffduty" then
						tooltip( cursorX, cursorY, "Duty Support: OFF", "Cliquer pour se mettre On-Duty")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "duty_supporter", 1)
							--triggerServerEvent("updateNametagColor", localPlayer)
							playToggleSound()
						end
					--GOLDEN NAMETAGE 
					elseif tooltips[i] == "nametag_on" then
						tooltip( cursorX, cursorY, "Tag Premium: ON", "Date d'expiration: "..myData.donationNametagExpiring)
						if justClicked then
							triggerServerEvent("global:toggleGoldenNametag", localPlayer)
							playToggleSound()
						end
					elseif tooltips[i] == "nametag_off" then
						tooltip( cursorX, cursorY, "Tag Premium: OFF", "Date d'expiration: "..myData.donationNametagExpiring)
						if justClicked then
							triggerServerEvent("global:toggleGoldenNametag", localPlayer)
							playToggleSound()
						end
					elseif tooltips[i] == "lifeTimeNameTag_on" then
						tooltip( cursorX, cursorY, "Tag Premium: ON", "Date d'expiration: Jamais")
						if justClicked then
							triggerServerEvent("global:toggleGoldenNametag", localPlayer)
							playToggleSound()
						end
					elseif tooltips[i] == "lifeTimeNameTag_off" then
						tooltip( cursorX, cursorY, "Tag Premium: OFF", "Date d'expiration: Jamais")
						if justClicked then
							triggerServerEvent("global:toggleGoldenNametag", localPlayer)
							playToggleSound()
						end
					--REPORT PANEL 
					elseif tooltips[i] == "report_panel_mod:0" then
						tooltip( cursorX, cursorY, "Panel Rapports - OFF", "Cliquer pour activer.")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "1")
							playToggleSound()
						end
					elseif tooltips[i] == "report_panel_mod:1" then
						tooltip( cursorX, cursorY, "Panel Rapports - Mode 1 (haut à droite seulement)", "Cliquer pour changer de mode.")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "2")
							playToggleSound()
						end
					elseif tooltips[i] == "report_panel_mod:2" then
						tooltip( cursorX, cursorY, "Panel Rapports - Mode 2 (milieu seulement)", "Cliquer pour changer de mode.")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "3")
							playToggleSound()
						end
					elseif tooltips[i] == "report_panel_mod:3" then
						tooltip( cursorX, cursorY, "Panel Rapports - Mode 3 (les deux)", "Cliquer pour cacher.")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "0")
							playToggleSound()
						end
					--HP 
					elseif tooltips[i] == "health" then
						tooltip( cursorX, cursorY, "Vie: "..math.ceil(getElementHealth(localPlayer)) .. "%")
					-- Armor
					elseif tooltips[i] == "armour" then
						tooltip( cursorX, cursorY, "Armure: "..math.ceil(getPedArmor(localPlayer)) .. "%")		
					--STYLE
					elseif tooltips[i] == "settings:hud:tagmode:newstyle:minimal" then
						tooltip( cursorX, cursorY, "HUD ON - Minimaliste", "Cliquer pour cacher.\n/toghud pour enlever cette icône.")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "hide_hud", "0")
							playToggleSound()
						end
					elseif tooltips[i] == "settings:hud:tagmode:newstyle:on" then
						tooltip( cursorX, cursorY, "HUD ON", "Cliquer pour passer en mode Minimaliste.\n/toghud pour enlever cette icône.")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "hide_hud", "2")
							playToggleSound()
						end
					elseif tooltips[i] == "settings:hud:tagmode:newstyle:off" then
						tooltip( cursorX, cursorY, "HUD OFF", "Cliquer pour activer.\n/toghud pour enlever cette icône.")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "hide_hud", "1")
							playToggleSound()
						end
					--WALKING STYLE 
					elseif tooltips[i] == "settings:hud:walkingstyle" then
						tooltip( cursorX, cursorY, "Style de Marche: "..getPedWalkingStyle(localPlayer), "Cliquer pour changer le style.")
						if justClicked then
							triggerServerEvent("realism:switchWalkingStyle", localPlayer)
							playToggleSound()
						end
					-- DEAGLE MODE
					elseif tooltips[i][1] == "deaglemode" then
						local mode = tooltips[i][2]
						if mode == 0 then
							tooltip( cursorX, cursorY, "Mode Taser", "Cliquer ou appuyer sur 'N' pour changer de mode.")
						elseif mode == 1 then
							tooltip( cursorX, cursorY, "Mode Létal", "Cliquer ou appuyer sur 'N' pour changer de mode.")
						elseif mode == 2 then
							tooltip( cursorX, cursorY, "Mode Radar", "Cliquer ou appuyer sur 'N' pour changer de mode.")
						end
						if justClicked then
							exports["pd-system"]:switchMode()
							playToggleSound()
						end
					-- SHOTGUN MODE
					elseif tooltips[i][1] == "shotgunmode" then
						local mode = tooltips[i][2]
						if mode == 0 then
							-- beanbag mode
							tooltip( cursorX, cursorY, "Mode Non Létal", "Cliquer ou appuyer sur 'N' pour changer de mode.")
						elseif mode == 1 then
							tooltip( cursorX, cursorY, "Mode Létal", "Cliquer ou appuyer sur 'N' pour changer de mode.")
						end
						if justClicked then
							exports["pd-system"]:switchModeShotgun()
							playToggleSound()
						end
					-- HEAD TURNING 
					-- Nando: deactivated head movement | 07/03/2023
					-- elseif tooltips[i] == "settings:hud:head_turning:0" then
					-- 	tooltip( cursorX, cursorY, "Mouvements de tête OFF", "Cliquer pour activer.")
					-- 	if justClicked then
					-- 		triggerEvent("accounts:settings:updateCharacterSettings", localPlayer, "head_turning", "1")
					-- 		playToggleSound()
					-- 	end
					-- elseif tooltips[i] == "settings:hud:head_turning:1" then
					-- 	tooltip( cursorX, cursorY, "Regarder les éléments autour.", "Cliquer pour changer de mode.")
					-- 	if justClicked then
					-- 		triggerEvent("accounts:settings:updateCharacterSettings", localPlayer, "head_turning", "2")
					-- 		playToggleSound()
					-- 	end
					-- elseif tooltips[i] == "settings:hud:head_turning:2" then
					-- 	tooltip( cursorX, cursorY, "Regarder où pointe la caméra.", "Cliquer pour désactiver.")
					-- 	if justClicked then
					-- 		triggerEvent("accounts:settings:updateCharacterSettings", localPlayer, "head_turning", "0")
					-- 		playToggleSound()
					-- 	end
					--TOGPM 
					elseif tooltips[i] == "settings:hud:togpm:on" then
						tooltip( cursorX, cursorY, "PMs: ON", "Cliquer pour ignorer les messages entrants.")
						if justClicked then
							triggerServerEvent("chat:togpm", localPlayer,localPlayer)
							playToggleSound()
						end
					elseif tooltips[i] == "settings:hud:togpm:off" then
						tooltip( cursorX, cursorY, "PMs: OFF", "Cliquer pour recevoir les messages entrants.")
						if justClicked then
							triggerServerEvent("chat:togpm", localPlayer,localPlayer)
							playToggleSound()
						end
					--TOGDON 
					elseif tooltips[i] == "settings:hud:togdon:on" then
						tooltip( cursorX, cursorY, "Tchat Premium: ON", "Cliquer pour désactiver.")
						if justClicked then
							exports.donators:updatePerkValue(localPlayer, 10, 0)
							playToggleSound()
						end
					elseif tooltips[i] == "settings:hud:togdon:off" then
						tooltip( cursorX, cursorY, "Tchat Premium: OFF", "Cliquer pour activer.")
						if justClicked then
							exports.donators:updatePerkValue(localPlayer, 10, 1)
							playToggleSound()
						end
					--tog hidden from scoreboard 
					elseif tooltips[i] == "settings:hud:hidden_scoreboard:on" then
						tooltip( cursorX, cursorY, "Invisible sur le TAB: ON", "Cliquer pour désactiver.")
						if justClicked then
							exports.donators:updatePerkValue(localPlayer, 12, 0)
							playToggleSound()
						end
					elseif tooltips[i] == "settings:hud:hidden_scoreboard:off" then
						tooltip( cursorX, cursorY, "Invisible sur le TAB: OFF", "Cliquer pour activer.")
						if justClicked then
							exports.donators:updatePerkValue(localPlayer, 12, 1)
							playToggleSound()
						end
					--tog hidden username 
					elseif tooltips[i] == "settings:hud:hidden_username:on" then
						tooltip( cursorX, cursorY, "Pseudo Caché: ON", "Cliquer pour désactiver.")
						if justClicked then
							exports.donators:updatePerkValue(localPlayer, 9, 0)
							playToggleSound()
						end
					elseif tooltips[i] == "settings:hud:hidden_username:off" then
						tooltip( cursorX, cursorY, "Pseudo Caché: OFF", "Cliquer pour activer.")
						if justClicked then
							exports.donators:updatePerkValue(localPlayer, 9, 1)
							playToggleSound()
						end
					elseif tooltips[i] == "settings:hud:opm" then
						tooltip( cursorX, cursorY, "Envoyer un PM hors ligne.", "Cliquer pour envoyer. Ou utilisez /opm [Pseudo] [Message]")
						if justClicked then
							executeCommandHandler("opm")
							playToggleSound()
						end
					elseif tooltips[i] == "notifications_icon" then
						tooltip( cursorX, cursorY, "Notifications du compte.", "Cliquer pour ouvrir. Double-clic droit pour supprimer les dernières 15 notifications.")
					elseif tooltips[i] == "firemode:auto" then
						tooltip( cursorX, cursorY, "Mode de tir: Full-auto", "Cliquer pour changer (ou appuyer sur 'N').")
						if justClicked then
							triggerEvent("weapon:firemode_switchFireMode", localPlayer)
							playToggleSound()
						end
					elseif tooltips[i] == "firemode:semi" then
						tooltip( cursorX, cursorY, "Mode de tir: Semi-auto", "Cliquer pour changer (ou appuyer sur 'N').")
						if justClicked then
							triggerEvent("weapon:firemode_switchFireMode", localPlayer)
							playToggleSound()
						end
					-- elseif justClicked then
					-- 	outputDebugString('You clicked ' .. tooltips[i])
					end
				end
			end

			--[[ for i = 1, #tooltips_bottom do
				bx = bx - iconW
				if isInBox( cursorX, cursorY, bx, bx + iconW, by, by + iconH/2 ) then
					--AUTOPARK / BOTTOM 
					
					if tooltips_bottom[i] == "settings:hud:engine:on" then
						tooltip( cursorX, cursorY, "Moteur - ON", "'J' ou /engine")
						if justClicked then
							triggerEvent( 'vehicle:toggleEngine', localPlayer )
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "settings:hud:engine:off" then
						tooltip( cursorX, cursorY, "Moteur - OFF", "'J' ou /engine")
						if justClicked then
							triggerEvent( 'vehicle:toggleEngine', localPlayer )
							playToggleSound()
						end

					elseif tooltips_bottom[i] == "settings:hud:handbrake:on" then
						if isBike then
							tooltip( cursorX, cursorY, "Béquille - ON", "'G' ou /kickstand")
						else
							tooltip( cursorX, cursorY, "Frein à main - ON", "'G' ou /handbrake")
						end
						if justClicked then
							exports['realism']:doHandbrake()
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "settings:hud:handbrake:off" then
						if isBike then
							tooltip( cursorX, cursorY, "Béquille - OFF", "'G' ou /kickstand")
						else
							tooltip( cursorX, cursorY, "Frein à main - OFF", "'G' ou /handbrake")
						end
						if justClicked then
							exports['realism']:doHandbrake()
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "settings:hud:headlights:0" then
						tooltip( cursorX, cursorY, "Phares - OFF", "'L' ou /lights")
						if justClicked then
							triggerServerEvent('togLightsVehicle', localPlayer)
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "settings:hud:headlights:1" then
						tooltip( cursorX, cursorY, "Phares - State 1", "'L' ou /lights")
						if justClicked then
							triggerServerEvent('togLightsVehicle', localPlayer)
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "settings:hud:headlights:2" then
						tooltip( cursorX, cursorY, "Phares - State 2", "'L' ou /lights")
						if justClicked then
							triggerServerEvent('togLightsVehicle', localPlayer)
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "hud:carlock:on" then
						tooltip( cursorX, cursorY, "Portes LOCK", "'K' ou /lock")
						if justClicked then
							triggerServerEvent('togLockVehicle', localPlayer, localPlayer)
							playToggleSound()
						end

					elseif tooltips_bottom[i] == "hud:carlock:off" then
						tooltip( cursorX, cursorY, "Portes UNLOCK", "'K' ou /lock")
						if justClicked then
							triggerServerEvent('togLockVehicle', localPlayer, localPlayer)
							playToggleSound()
						end

					elseif tooltips_bottom[i] == "settings:hud:speedo:off" then
						tooltip( cursorX, cursorY, "Speedo mode - OFF", " ")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "speedo", "1")
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "settings:hud:speedo:kmh" then
						tooltip( cursorX, cursorY, "Speedo mode - KM/H", " ")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "speedo", "2")
							playToggleSound()
						end
					elseif tooltips_bottom[i] == "settings:hud:speedo:mph" then
						tooltip( cursorX, cursorY, "Speedo mode - MPH", " ")
						if justClicked then
							triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "speedo", "0")
							playToggleSound()
						end
					-- seatbelt
					elseif tooltips_bottom[i] == 'belt:on' then
						tooltip( cursorX, cursorY, 'Vous avez la ceinture..', "',' ou /belt")
						if justClicked then
							triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
							playToggleSound()
						end
					elseif tooltips_bottom[i] == 'belt:off' then
						tooltip( cursorX, cursorY, 'Ceinture pas mise.', "'Z' ou /belt")
						if justClicked then
							triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
							playToggleSound()
						end
					--Window state
					elseif tooltips_bottom[i] == 'windowstat:up' then
						tooltip( cursorX, cursorY, 'Fenêtres fermées.', "'X' ou /togwindow")
						if justClicked then
							triggerServerEvent('vehicle:togWindow', localPlayer)
							playToggleSound()
						end
					elseif tooltips_bottom[i] == 'windowstat:down' then
						tooltip( cursorX, cursorY, 'Fenêtres ouvertes.', "'X' ou /togwindow")
						if justClicked then
							triggerServerEvent('vehicle:togWindow', localPlayer)
							playToggleSound()
						end
					--CC state
					elseif tooltips_bottom[i] == 'cc:on' then
						tooltip( cursorX, cursorY, 'Régulateur ON.', "'C' ou /cc")
						if justClicked then
							triggerEvent('realism:togCc', localPlayer)
							playToggleSound()
						end
					elseif tooltips_bottom[i] == 'cc:off' then
						tooltip( cursorX, cursorY, 'Régulateur OFF.', "'C' ou /cc")
						if justClicked then
							triggerEvent('realism:togCc', localPlayer)
							playToggleSound()
						end
					-- auto park
					-- elseif tooltips_bottom[i] == "settings:hud:autopark:on" then
					-- 	tooltip( cursorX, cursorY, "Auto-Park ON", "Cliquer pour désactiver.")
					-- 	if justClicked then
					-- 		triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "autopark", "0")
					-- 		playToggleSound()
					-- 	end
					-- elseif tooltips_bottom[i] == "settings:hud:autopark:off" then
					-- 	tooltip( cursorX, cursorY, "Auto-Park OFF (/garer automatique)", "Cliquer pour activer.")
					-- 	if justClicked then
					-- 		triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "autopark", "1")
					-- 		playToggleSound()
					-- 	end
					elseif tooltips_bottom[i] == "settings:hud:mdc" then
						tooltip( cursorX, cursorY, "Mobile Digital Computer", "Cliquer pour ouvrir.")
						if justClicked then
							triggerEvent("mdc:loginW", localPlayer)
							playToggleSound()
						end
					end
				end
			end *]]
		end
	end
	justClicked = false
end

function playToggleSound()
	playSound(":resources/toggle.mp3")
end

--TO DETECT CLICK ON DX BOX 
addEventHandler( "onClientClick", root,
	function( button, state )
		if button == "left" and state == "up" then
			justClicked = true
		end
	end
)

function disabled_item(value)
	return tocolor(value,value,value)
end

addCommandHandler("rpanel",
	function()
		local iconAdmin = myData.iconAdmin
		local iconSup = myData.iconSup

		if (iconAdmin or iconSup)then
			if myData.report_panel_mod == "1" then
				triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "2")
			elseif myData.report_panel_mod == "2" then
				triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "3")
			elseif myData.report_panel_mod == "3" then
				triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "0")
			else
				triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "1")
			end
		end
	end
)

function changeWalkStyle(cmd, id)
	id = tonumber(id)

	if id and id > 0 and id < 29 then
		triggerServerEvent("realism:switchWalkingStyle", localPlayer, id)
	else
		outputChatBox("Syntax: /" .. cmd .. " [1-28]", 255, 194, 14)
	end
end

addCommandHandler("walkstyle", changeWalkStyle)
addCommandHandler("stylemarche", changeWalkStyle)