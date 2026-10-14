-- Nando: Major optimization refactor (01/04/2023)

local SEEFAR_DISTANCE = 30

local badges = {}
local masks = {}

local newfont = dxCreateFont("chairdrobe-black.otf", 10) or "default-bold"
local newfontscale = 1
local newfontheight = dxGetFontHeight(newfontscale, newfont)

local OUTLINE_COLOR = tocolor(0, 0, 0, 35)
local OUTLINE_SIZE = 2

local streamedPlayers = {}
local playerData = {}

local DEFAULT_DIST = 15
local REDUCED_DIST = 9
local limitdistance = DEFAULT_DIST

local ICON_SIZE = 50

-- local IMG_COLOR = tocolor(255, 255, 255)
-- local TYPING_IMAGE = "chat.png"
-- local TYPING_IMAGE_SIZE = 30
local TYPING_TEXT = "[...]"
local TYPING_TEXT_WIDTH = dxGetTextWidth(TYPING_TEXT, newfontscale, newfont) / 2
local TYPING_TEXT_COLOR = tocolor(249, 139, 6) -- #f98b06 Southland Orange
local TYPING_DN = "chat:player_typing"

local showTypingIcons = true

local lastTypingCheck = getTickCount()


local bubbles = {} -- {text, player, lastTick, alpha, yPos}
local fontHeight = 22
local characteraddition = 50
local maxbubbles = 5
local timeVisible = 5000

function addText(source, text, color, font, sticky, type)

	if not bubbles[source] then
		bubbles[source] = {}
	end

	local tick = getTickCount()
	local info = {
		text = text,
		player = source,
		color = color or {255, 255, 255},
		tick = tick,
		expires = tick + (timeVisible + #text * characteraddition),
		alpha = 0,
		sticky = sticky,
		type = type
	}

	if sticky then
		table.insert(bubbles[source], 1, info)
	else
		table.insert(bubbles[source], info)
	end

	if #bubbles[source] > maxbubbles then
		for k, v in ipairs(bubbles[source]) do
			if not v.sticky then
				table.remove(bubbles[source], k)
				break
			end
		end
	end
end

addEvent("addChatBubble", true)
addEventHandler("addChatBubble", root,
	function(message, command)
		if command == "ado" or command == "ame" then
			addText(source, message, { 194, 162, 218 }, "default-bold", false, command)
		else
			addText(source, message)
		end
	end
)

function removeTexts(player, type)
	local t = bubbles[player] or {}
	for i = #t, 1, -1 do
		if t[i].type == type then
			table.remove(t, i)
		end
	end

	if #t == 0 then
		bubbles[player] = nil
	end
end

function updateStatus(source, n)
	removeTexts(source, n)
	if getElementData(source, "chat:status") then
		addText(source, getElementData(source, "chat:status"), {136, 87, 201}, "default-bold", true, n)
	end
end

--
-- outElastic | Got from https://github.com/EmmanuelOga/easing/blob/master/lib/easing.lua
-- For all easing functions:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning
-- d = duration (total time)
-- a: amplitud
-- p: period
local pi = math.pi
function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < math.abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * math.asin(c/a)
  end

  return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * pi) / p) + c + b
end




local function isInputsActive()
	return (isChatBoxInputActive() or isConsoleActive())
end

local function checkForChat()
	
    local chatBoxOpen = (
        (isInputsActive())
        and (getElementAlpha(localPlayer) == 255)
        and not playerData[localPlayer]["freecam:state"]
        and not playerData[localPlayer].reconx
    )
    local syncChange = false

    if chatBoxOpen and not playerData[localPlayer][TYPING_DN] then
        syncChange = true
    elseif (not chatBoxOpen) and playerData[localPlayer][TYPING_DN] then
        syncChange = true
    end

    if (syncChange) then
        setElementData(localPlayer, TYPING_DN, chatBoxOpen, true)
    end
end


--[[
	Script will fetch element data update for these indexes,
	see the function below
]]
local DATA_NAMES = {
	-- badges auto fill
	-- masks auto fill
	["loggedin"] = function(d) return "isLoggedIn", (d == 1) end,
	["playerid"] = true,
	["hide_hud"] = function(d) return "isActive", (not (d=="0" or d=="-1")) end,
	["graphic_nametags"] = function(d) return "showNametags", (d ~= "0") end,
	["settings_hud_style"] = function(d) return "isNewStyle", (d == "1") end,
	["invisible"] = true,
	["seeNametagsPlayersFar"] = true,
	["reconx"] = true,
	["freecam:state"] = true,
	["staff_duty"] = "staff",
	["hiddenadmin"] = "staff",
	["duty_admin"] = "staff",
	["duty_supporter"] = "staff",
	["supporter_level"] = "staff", -- Required for admin rank change update
	["admin_level"] = "staff", -- Required for admin rank change update
	-- ["donation:nametag"] = "don_tag",
	-- ["nametag_on"] = "don_tag",
	["afk"] = function(d) return "afk", (d and "afk" or false) end,
	["gloves"] = function(d) return "afk", (d and "gloves" or false) end,
	["seatbelt"] = function(d) return "afk", (d and "seatbelt" or false) end,
	--["smoking"] = function(d) return "afk", (d and "cigarette" or false) end,
	["restrain"] = function(d) return "afk", (d==1 and "handcuffs" or false) end,
	["blindfold"] = function(d) return "afk", (d==1 and "blindfold" or false) end,
	["chat:status"] = function(d, p) updateStatus(p, "status") end,
	[TYPING_DN] = true,
}

local function updateDrawDistanceDynamic()
	if getElementDimension(localPlayer) > 0 then
		limitdistance = REDUCED_DIST
		return
	end
	local c = 0
	for _, player in pairs(streamedPlayers) do
		c = c + 1
	end

	if c > 10 then
		limitdistance = REDUCED_DIST
	else
		limitdistance = DEFAULT_DIST
	end
end
addEventHandler("onClientElementDimensionChange", localPlayer, updateDrawDistanceDynamic, false)

local function updatePlayerElementData(player, dataName, newValue)
	if not playerData[player] then
		playerData[player] = {}
	end
	local customFunc = DATA_NAMES[dataName]
	local isFunc = type(customFunc) == "function"
	if isFunc or customFunc == true then
		
		local dataName2, newValue2 = dataName, newValue
		if isFunc then
			dataName2, newValue2 = customFunc(newValue, player)
			if not dataName2 then
				return
			end
		end
		playerData[player][dataName2] = newValue2

	elseif customFunc == "badges" then
		-- Badge color
		local badgeColor = false
		for k, v in pairs(badges) do
			local title = getElementData(player, k)
			if title then
				badgeColor = {
					badges[k][1], badges[k][2], badges[k][3], -- r,g,b
					badges[k][4], badges[k][5],
					title -- title text
				}
				break
			end
		end
		playerData[player]["badgeColor"] = badgeColor
	elseif customFunc == "masks" then
		-- Mask icon
		local maskIcons = {}
		for k, v in pairs(masks) do
			if getElementData(player, v[1]) then
				maskIcons[#maskIcons+1] = v[1]
			end
		end
		playerData[player]["maskIcons"] = maskIcons
	elseif customFunc == "staff" then
		
		-- Admin / Supporter icons
		local hiddenAdmin = getElementData(player, "hiddenadmin") or 0
		local dutyAdmin = getElementData(player, "duty_admin") or 0
		local dutySup = getElementData(player, "duty_supporter") or 0
		local dutyShowing = getElementData(player, "staff_duty") ~= "0"
		local iconAdmin = false
		local iconSup = false
		local staffTitle = false
		if (hiddenAdmin == 0 and dutyShowing) then
			if dutyAdmin == 1 then
				if exports.integration:isPlayerHeadAdmin(player) then
					iconAdmin = "ceo"
				elseif exports.integration:isPlayerLeadAdmin(player) then
					iconAdmin = "leada"
				elseif exports.integration:isPlayerSeniorAdmin(player) then
					iconAdmin = "adm_on"
				elseif exports.integration:isPlayerAdmin(player) then
					iconAdmin = "adm_on"
				elseif exports.integration:isPlayerTrialAdmin(player) then
					iconAdmin = "modo"
				end
			end
			if dutySup == 1 and exports.integration:isPlayerSupporter(player) then
				iconSup = "gm"
			end
			staffTitle = exports.global:getPlayerAdminTitle(player)
		end
		playerData[player].iconAdmin = iconAdmin
		playerData[player].iconSup = iconSup
		playerData[player].staffTitle = staffTitle
	-- elseif customFunc == "don_tag" then
	-- 	-- Donator icon
	-- 	local donatorIcon = getElementData(player, "donation:nametag") and getElementData(player, "nametag_on") and "donor" or false
	-- 	playerData[player].donatorIcon = donatorIcon
	end
end

local function fetchPlayerElementData(player)
	for dataName, _ in pairs(DATA_NAMES) do
		updatePlayerElementData(player, dataName, getElementData(player, dataName))
	end

	updateDrawDistanceDynamic()

	-- outputDebugString("Fetched player data for " .. getPlayerName(player))
	return true
end

local function fetchPedElementData(ped)
	if not playerData[ped] then
		playerData[ped] = {}
	end
	playerData[ped].talk = getElementData(ped, "talk") == 1
	playerData[ped].nametag = getElementData(ped, "nametag")
	local pedName = getElementData(ped, "name")
	if pedName then
		pedName = pedName:gsub("_", " ")
	else
		pedName = "NPC"
	end
	playerData[ped].name = pedName
	playerData[ped].twidth = dxGetTextWidth(pedName, newfontscale, newfont) / 2
	playerData[ped].textVerticalOffset = getElementData(ped, "textVerticalOffset") or 0
	playerData[ped].disableBorderedText = getElementData(ped, "disableBorderedText")
	playerData[ped].textBold = getElementData(ped, "textBold")

	updateDrawDistanceDynamic()
	-- outputDebugString("Fetched ped data for " .. pedName)
end

local function isNearElementToDraw(element, lx, ly, lz, px, py, pz, dim, int, isNewStyle, seeNametagsFarPlayers)
	
	if getElementDimension(element) == dim and getElementInterior(element)==int then
		local x, y, z = getElementPosition(element)
		local distance = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
		if (element~=localPlayer or isNewStyle) then
			if (distance<limitdistance or (seeNametagsFarPlayers and distance<SEEFAR_DISTANCE)) then
				if not (isPedDucked(element)) then
					z = z + 1
				else
					z = z + 0.5
				end

				if getElementData(element, "morgue.worldCorpseID") then
					z = z - 1
				end

				local sx, sy = getScreenFromWorldPosition(x, y, z)
				if sx and sy and (( isLineOfSightClear(lx, ly, lz, x, y, z, true, false, false, true, false, false, false) ) or (seeNametagsFarPlayers)) then
					return sx, sy, distance
				end
			end
		end
	end
	return false
end

local function handleDataChange(dataName, oldValue, newValue)
	if DATA_NAMES[dataName] == nil then
		return
	end
	local et = getElementType(source)
	if et == "player" then
		if source == localPlayer or (isElementStreamedIn(source) and playerData[source] ~= nil) then
			updatePlayerElementData(source, dataName, newValue)
		end
	elseif et == "ped" then
		if (isElementStreamedIn(source) and playerData[source] ~= nil) then
			fetchPedElementData(source)
		end
	end
end
addEventHandler("onClientElementDataChange", root, handleDataChange)

local function handleElementStreamIn()
	local et = getElementType(source)
	if (et == "player" or et == "ped") and source ~= localPlayer then
		streamedPlayers[source] = et
	end
end
addEventHandler("onClientElementStreamIn", root, handleElementStreamIn)

local function handleElementStreamOut()
	local et = getElementType(source)
	if (et == "player" or et == "ped") and source ~= localPlayer then
		streamedPlayers[source] = nil
		playerData[source] = nil
		bubbles[source] = nil
		-- outputDebugString("[nametags] Element data cleared for " .. getPlayerName(source))
	end
end
addEventHandler("onClientElementStreamOut", root, handleElementStreamOut)
addEventHandler("onClientElementDestroy", root, handleElementStreamOut)
addEventHandler("onClientPlayerQuit", root, handleElementStreamOut)

local function fetchInitialData()
	for k, v in pairs(exports['item-system']:getBadges()) do
		badges[v[1]] = {
			v[4][1], v[4][2], v[4][3], -- r,g,b
			v[5], v.bandana or false,
			v[1] -- element data name
		}
		DATA_NAMES[v[1]] = "badges"
	end

	masks = exports['item-system']:getMasks()
	for k, v in pairs(masks) do
		DATA_NAMES[v[1]] = "masks"
	end

	streamedPlayers[localPlayer] = "player"

	for _, player in ipairs(getElementsByType("player", root, true)) do
		streamedPlayers[player] = "player"
	end
	for _, ped in ipairs(getElementsByType("ped", root, true)) do
		streamedPlayers[ped] = "ped"
	end

	fetchPlayerElementData(localPlayer)

	removeEventHandler("onClientRender", root, renderNametags)
	addEventHandler("onClientRender", root, renderNametags)
end

local function initStuff(res)
	if getResourceName(res) == "item-system" then
		fetchInitialData()
	elseif (res == resource and getResourceFromName("item-system")) then 
		setTimer(fetchInitialData, 2500, 1)
	end
end
addEventHandler("onClientResourceStart", root, initStuff)

local function getPlayerIcons(tick, vehicle, localVehicle, data, name, player, badgeColor)
	local badgeName
	local tinted = false
	local r,g,b = 255, 255, 255
	local icons = {}

	-- ADMIN / SUPPORTER
	local iconAdmin = data.iconAdmin
	local iconSup = data.iconSup
	-- if iconAdmin then
	-- 	icons[#icons+1] = iconAdmin
	-- end
	-- if iconSup then
	-- 	icons[#icons+1] = iconSup
	-- end
	if iconAdmin or iconSup then
		r,g,b = getPlayerNametagColor(player)
		name = getElementData(player, "account:username")
		badgeName = data.staffTitle
	end

	if getElementData(player, "camhack.state") then
		icons[#icons+1] = "camhack"
	end

	-- DONATOR
	-- local donatorIcon = data.donatorIcon
	-- if donatorIcon then
	-- 	icons[#icons+1] = donatorIcon
	-- end

	-- AFK
	local afk = data.afk
	if afk then
		icons[#icons+1] = afk
	end

	-- local maskIcons = data.maskIcons
	-- if #maskIcons > 0 then
	-- 	for i=1, #maskIcons do
	-- 		local maskIcon = maskIcons[i]
	-- 		if maskIcon then
	-- 			icons[#icons+1] = maskIcon
	-- 		end
	-- 	end
	-- end

	-- local gloves = data.gloves
	-- if gloves then
	-- 	icons[#icons+1] = gloves
	-- end

	if vehicle then
		local windowsDown = getElementData(vehicle, "vehicle:windowstat") == 1
		if (not windowsDown) and vehicle ~= localVehicle and getElementData(vehicle, "tinted") then
			name = "Inconnu (Teinté)"
			tinted = true
		end
		if windowsDown then
			icons[#icons+1] = 'window2'
		end
	end

	if not tinted then
		-- pretty damn hard to see thru tint
		if vehicle and exports.global:getVehicleType(vehicle) ~= "Bike" then
			local seatbelt = data.seatbelt
			if seatbelt then
				icons[#icons+1] = seatbelt
			end
		end

		-- local smoking = data.smoking
		-- if smoking then
		-- 	icons[#icons+1] = smoking
		-- end

		--if #maskIcons > 0 then
		--	name = "Inconnu"
		--end
		 if badgeColor then
		 	if badgeColor[5] then
		 		local r,g,b = badgeColor[1], badgeColor[2], badgeColor[3]
		-- 		icons[#icons+1] = {'bandana', tocolor(r,g,b)}
		-- 		name = "Inconnu (Bandana)"
		 	elseif badgeColor[4] then
		 		local title = badgeColor[6]
				icons[#icons+1] = "badge" .. tostring(badgeColor[4] < 3 and badgeColor[4] or 1)
		 		badgeName = title
		 	end
		 end
		 if (not badgeName) and badgeColor and not badgeColor[5] and badgeColor[4] then
		 	local title = badgeColor[6]
			icons[#icons+1] = "badge" .. tostring(badgeColor[4] < 3 and badgeColor[4] or 1)
		 	badgeName = title
		 end

		local health = getElementHealth( player )
		tick = math.floor(tick / 1000) % 2
		if health <= 5 and tick == 0 then
			icons[#icons+1] = 'bleeding'
		elseif (health <= 10) then
			icons[#icons+1] = 'lowhp'
		end

		-- local restrain = data.restrain
		-- if restrain then
		-- 	icons[#icons+1] = restrain
		-- end

		-- local blindfold = data.blindfold
		-- if blindfold then
		-- 	icons[#icons+1] = blindfold
		-- end

		-- if getPedArmor( player ) > 50 and getPedArmor( player ) < 76 then
		-- 	icons[#icons+1] = 'armour'
		-- elseif getPedArmor( player ) > 75 then
		-- 	icons[#icons+1] = 'armour2'
		-- end
	end

	return name, badgeName, icons, tinted, r,g,b
end

-- function table.size(tab)
--     local length = 0
--     for _ in pairs(tab) do length = length + 1 end
--     return length
-- end

function dxDrawBorderedText (outline, text, left, top, right, bottom, color, scale, font, ...)
    for oX = (outline * -1), outline do
        for oY = (outline * -1), outline do
            dxDrawText(text, left + oX, top + oY, right + oX, bottom + oY, OUTLINE_COLOR, scale, font, ...)
        end
    end
    dxDrawText(text, left, top, right, bottom, color, scale, font, ...)
end

function renderNametags()
	if isPlayerMapVisible() then
		return
	end
	local lpData = playerData[localPlayer]
	if not lpData.showNametags then
		return
	end
	if not lpData.isActive then
		return
	end
	if lastTypingCheck > 1000 then
		lastTypingCheck = getTickCount()
		checkForChat()
	end

	local lx, ly, lz = getCameraMatrix()
	local px, py, pz = getElementPosition(localPlayer)
	local dim = getElementDimension(localPlayer)
	local int = getElementInterior(localPlayer)
	local isNewStyle = lpData.isNewStyle
	local seeNametagsFarPlayers = false
	if lpData.invisible or lpData.seeNametagsPlayersFar then
		seeNametagsFarPlayers = true
	end
	local localVehicle = getPedOccupiedVehicle(localPlayer)
	local tick = getTickCount ()
	local ctrlDown = getKeyState("lctrl") or getKeyState("rctrl")

	for player, et in pairs(streamedPlayers) do
		local sx, sy, distance = isNearElementToDraw(player, lx, ly, lz, px, py, pz, dim, int, isNewStyle, seeNametagsFarPlayers)
		if sx then
			if et == "ped" then
				if not playerData[player] then
					fetchPedElementData(player)
				else
					local data = playerData[player]
					local name = data.name
					local twidth = data.twidth
					local left = sx - twidth
					local right = sx + twidth
					local top = sy - newfontheight * newfontscale + data.textVerticalOffset
					local bottom = sy + newfontheight * newfontscale + data.textVerticalOffset
					
					if data.disableBorderedText then
						dxDrawText(name, left, top, right, bottom, 0xffffffff, newfontscale, data.textBold and "default-bold" or newfont, "center", "center", false, false, false, true)
					else
						dxDrawBorderedText(OUTLINE_SIZE, name, left, top, right, bottom, 0xffffffff, newfontscale, data.textBold and "default-bold" or newfont, "center", "center", false, false, false, true)
					end
				end

				local ty = -4

				if bubbles[player] then
					if #bubbles[player] > 0 then
						
						for k,v in ipairs(bubbles[player]) do
							if tick < v.expires or v.sticky then

								local elapsedTime = tick - v.tick
								local duration = v.expires - v.tick
								
								if not v.yPos then
									v.yPos = (sy + ty)
								end
								local width = dxGetTextWidth(v.text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
								local yPos = outElastic(elapsedTime, v.yPos - 10, ((sy + ty) - fontHeight*k ) - v.yPos, 1000, 5, 500)

								
								dxDrawRectangle(sx - (12 + (0.5 * width)), yPos - 2, width + 23, 19, tocolor(20, 20, 20, 200))
								dxDrawRectangle(sx - (12 + (0.5 * width)), yPos + 16, width + 23, 1, tocolor(v.color[1], v.color[2], v.color[3], 255))
								dxDrawText(v.text, sx - (0.5 * width), yPos, sx - (0.5 * width), yPos - (k * fontHeight), tocolor(unpack(v.color)), 1, "default-bold", "left", "top")
							else
								table.remove(bubbles[player], k)
							end
						end

						ty = ty - (#bubbles[player] * fontHeight) - 5
					end

					if #bubbles[player] == 0 then
						bubbles[player] = nil
					end
				end
			else
				if not playerData[player] then
					fetchPlayerElementData(player)
				else
					local data = playerData[player]
					if data.isLoggedIn and getElementAlpha(player)==255 and (not (data.reconx or data["freecam:state"])) then

						local name = exports.global:getPlayerName(player)
						local badgeColor = data.badgeColor
						local badgeName
						local tinted = false
						local vehicle = getPedOccupiedVehicle(player) or nil
						local r,g,b = 255, 255, 255
						name, badgeName, icons, tinted, r,g,b = getPlayerIcons(tick, vehicle, localVehicle, data, name, player, badgeColor)
                        
						local iconsy = sy + 10
						local iconCount = #icons
						local ICON_X_OFFSET = 6
						local ICON_SIZE2 = ICON_SIZE/1.7
						
						if iconCount > 0 then
							local iconsx = sx - (iconCount * ICON_SIZE2) / 2
							for i=1, #icons do
								local iconx = iconsx + (i - 1) * ICON_SIZE2
								local icon = icons[i]
								if type(icon)=="table" then
									dxDrawImage(iconx + ICON_X_OFFSET, iconsy, ICON_SIZE, ICON_SIZE, ":hud/images/hud/" .. icon[1] .. ".png", 0,0,0,icon[2])
								else
									dxDrawImage(iconx + ICON_X_OFFSET, iconsy, ICON_SIZE, ICON_SIZE, ":hud/images/hud/" .. icon .. ".png")
								end
							end
						end



						-- local id = data.playerid
						-- if not isNewStyle then
						-- 	name = name.." ("..id..")"
						-- else

							if ctrlDown then
								name = name.." ("..data.playerid..")"
							end
						-- end

						local twidth1 = dxGetTextWidth(name, newfontscale, newfont) / 2
						local left = sx - twidth1
						local right = sx + twidth1
						local top = sy - newfontheight * newfontscale
						local bottom = sy + newfontheight * newfontscale
						
						dxDrawBorderedText(OUTLINE_SIZE, name, left, top, right, bottom, tocolor(r,g,b), newfontscale, newfont, "center", "center")
						
						local ty = -4

						if badgeName then
							-- draw badge title above
							local twidth2 = dxGetTextWidth(badgeName, newfontscale, newfont) / 2
							local badgeLeft = sx - twidth2
							local badgeRight = sx + twidth2
							local badgeTop = sy - newfontheight * newfontscale - 20
							local badgeBottom = sy + newfontheight * newfontscale - 20

							if not badgeColor then
								dxDrawBorderedText(OUTLINE_SIZE, badgeName, badgeLeft, badgeTop, badgeRight, badgeBottom, tocolor(r,g,b), newfontscale, newfont, "center", "center")
							else
								dxDrawBorderedText(OUTLINE_SIZE, badgeName, badgeLeft, badgeTop, badgeRight, badgeBottom, tocolor(badgeColor[1], badgeColor[2], badgeColor[3]), newfontscale, newfont, "center", "center")
							end

							ty = ty - newfontheight
						end

						if bubbles[player] then
							if #bubbles[player] > 0 then
								
								for k,v in ipairs(bubbles[player]) do
									if tick < v.expires or v.sticky then

										local elapsedTime = tick - v.tick
										local duration = v.expires - v.tick
										
										if not v.yPos then
											v.yPos = (sy + ty)
										end
										local width = dxGetTextWidth(v.text:gsub("#%x%x%x%x%x%x", ""), 1, "default-bold")
										local yPos = outElastic(elapsedTime, v.yPos - 10, ((sy + ty) - fontHeight*k ) - v.yPos, 1000, 5, 500)

										
										dxDrawRectangle(sx - (12 + (0.5 * width)), yPos - 2, width + 23, 19, tocolor(20, 20, 20, 200))
										dxDrawRectangle(sx - (12 + (0.5 * width)), yPos + 16, width + 23, 1, tocolor(v.color[1], v.color[2], v.color[3], 255))
										dxDrawText(v.text, sx - (0.5 * width), yPos, sx - (0.5 * width), yPos - (k * fontHeight), tocolor(unpack(v.color)), 1, "default-bold", "left", "top")
									else
										table.remove(bubbles[player], k)
									end
								end

								ty = ty - (#bubbles[player] * fontHeight) - 5
							end

							if #bubbles[player] == 0 then
								bubbles[player] = nil
							end
						end
						
						if showTypingIcons and data[TYPING_DN] then
							ty = sy + ty

							local typingLeft = sx - TYPING_TEXT_WIDTH
							local typingRight = sx + TYPING_TEXT_WIDTH
							local typingTop = ty - newfontheight * newfontscale - 20
							local typingBottom = ty + newfontheight * newfontscale - 20

							dxDrawBorderedText(OUTLINE_SIZE, TYPING_TEXT, typingLeft, typingTop, typingRight, typingBottom, TYPING_TEXT_COLOR, newfontscale, newfont, "center", "center")
							-- dxDrawImage(sx - TYPING_IMAGE_SIxZE / 2, ty - TYPING_IMAGE_SIZE / 2, TYPING_IMAGE_SIZE, TYPING_IMAGE_SIZE, TYPING_IMAGE, 0, 0, 0, IMG_COLOR)
						end
					end
				end
			end
		end
	end
end
function moneyUpdateFX(state, amount)
	if amount and tonumber(amount) and tonumber(amount) > 0 then
		local text = "+$"..exports.global:formatMoney(amount)
		if state then
			triggerEvent("shop:playCollectMoneySound", localPlayer)
		else
			triggerEvent("shop:playPayWageSound", localPlayer)
			text = "-$"..exports.global:formatMoney(amount)
		end
		local money = getElementData(localPlayer, "money") or 0
		local bankmoney = getElementData(localPlayer, "bankmoney") or 0
		local info = {{"Finance"},{""}}
		table.insert(info, {"Cash: $"..exports.global:formatMoney(money).." ("..text..")"})
		table.insert(info, {"Banque: $"..exports.global:formatMoney(bankmoney)})
		triggerEvent("hudOverlay:drawOverlayTopRight", localPlayer, info )
	end
end
addEvent("moneyUpdateFX", true)
addEventHandler("moneyUpdateFX", root, moneyUpdateFX)

function bankMoneyUpdateFX(state, amount)
	if amount and tonumber(amount) and tonumber(amount) > 0 then
		local text = "+$"..exports.global:formatMoney(amount)
		if state then
			triggerEvent("shop:playCollectMoneySound", localPlayer)
		else
			triggerEvent("shop:playPayWageSound", localPlayer)
			text = "-$"..exports.global:formatMoney(amount)
		end
		local money = getElementData(localPlayer, "money") or 0
		local bankmoney = getElementData(localPlayer, "bankmoney") or 0
		local info = {{"Finance"},{""}}
		table.insert(info, {"Cash: $"..exports.global:formatMoney(money)})
		table.insert(info, {"Banque: $"..exports.global:formatMoney(bankmoney).." ("..text..")"})
		triggerEvent("hudOverlay:drawOverlayTopRight", localPlayer, info )
	end
end
addEvent("bankMoneyUpdateFX", true)
addEventHandler("bankMoneyUpdateFX", root, bankMoneyUpdateFX)

local function applyClientConfigSettings()
	showTypingIcons = getElementData(localPlayer, 'graphic_typingicon') ~= "0"
end
addEvent('accounts:settings:graphic_typingicon', false)
addEventHandler('accounts:settings:graphic_typingicon', root, applyClientConfigSettings)
addEventHandler('onClientResourceStart', resourceRoot, applyClientConfigSettings)
