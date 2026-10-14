-- Remade by Nando
-- 05/04/2023

local sx, sy = guiGetScreenSize()

local info = {}
local ckAmount = 0

-- dx stuff
local textString = ""
local show = false
local drawing = false
local SEP = " ‒ "

local bgColor = tocolor(0, 0, 0, 100)
local textColor = tocolor(255, 255, 255)

local function drawText()
	dxDrawRectangle(0, sy-20, sx, 25, bgColor)
	dxDrawText(textString, 5, sy-17, sx, sy, textColor, 1, "default", "left", "top")
end

local function isStaffOnDuty()
	return exports.integration:isPlayerSupporter(localPlayer, true) or exports.integration:isPlayerTrialAdmin(localPlayer, true)
end

function getMyAdminTitle()
	return exports.global:getPlayerAdminTitle(localPlayer)
end

-- update the labels
local function updateGUI()
	if show then
		local str = ""

		local rank = getMyAdminTitle() or "Staff"
		local username = getElementData(localPlayer, "account:username")
		str = str .. rank .. " " ..username

		local status
		if exports.integration:isPlayerSupporter(localPlayer) then
			status = getElementData(localPlayer, "duty_supporter") == 1 and " (Duty Support ON)" or " (Duty Support OFF)"
		elseif exports.integration:isPlayerTrialAdmin(localPlayer) then
			status = getElementData(localPlayer, "duty_admin") == 1 and " (Duty Admin ON)" or " (Duty Admin OFF)"
		end
		if status then
			str = str .. status
		end

		local admCountOnDuty = info.admCountOnDuty or 0
		local admCountTotal = info.admCountTotal or 0
		str = str .. SEP..admCountOnDuty .. "/" .. admCountTotal .. " administrateurs en service"

		local supCountOnDuty = info.supCountOnDuty or 0
		local supCountTotal = info.supCountTotal or 0
		str = str .. SEP..supCountOnDuty .. "/" .. supCountTotal .. " supports en service"

		local unhandledReports = info.unhandledReports or 0
		if unhandledReports > 0 then
			-- Red
			str = str .. SEP..""..unhandledReports .. " rapport"..(unhandledReports==1 and "" or "s").." non traité"..(unhandledReports==1 and "" or "s")
		end

		local handledReports = info.handledReports or 0
		if handledReports > 0 then
			str = str .. SEP..""..handledReports .. " rapport"..(handledReports==1 and "" or "s").." en traitement"
		end

		local myHandledReports = info.myHandledReports or {}
		local countMyHandledReports = #myHandledReports
		if countMyHandledReports > 0 then
			local myHandledReportsF = ""
			for i, t in ipairs(myHandledReports) do
				myHandledReportsF = myHandledReportsF .. "["..t.."]"
				if i ~= countMyHandledReports then
					myHandledReportsF = myHandledReportsF .. " "
				end
			end
			str = str .. SEP..""..(countMyHandledReports).." rapport"..(countMyHandledReports==1 and "" or "s").." pris en charge par moi: "..myHandledReportsF
		end

		if ckAmount > 0 then
			str = str .. SEP..""..ckAmount .. " demandes de CK non traitées"
		end
		
		textString = str
	end
end

-- create the gui
local function createGUI()
	if exports.integration:isPlayerStaff(localPlayer) then
		local currbar = getElementData(localPlayer, "staff_bar") or "1"
		show = (currbar == "1") and (exports.hud:isActive(true))
		if show then
			updateGUI()
			if not drawing then
				addEventHandler("onClientRender",getRootElement(), drawText)
				drawing = true
			end
		else
			if drawing then
				removeEventHandler("onClientRender",getRootElement(), drawText)
				drawing = false
			end
		end
	else
		show = false
		if drawing then
			removeEventHandler("onClientRender",getRootElement(), drawText)
			drawing = false
		end
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), createGUI, false )
addEventHandler( "onClientElementDataChange", localPlayer, 
	function(n)
		if n == "admin_level" or n == "hiddenadmin" or n=="supporter_level" or n=="duty_supporter" or n=="duty_admin" or n=="hide_hud" or n=="staff_bar" then
			createGUI()
		end
	end, false
)

addEvent( "updateReportsCount", true )
addEventHandler( "updateReportsCount", localPlayer,
	function( info_ )
		info = info_ or {}
		
		createGUI()
	end, false
)


--  CK stuff old

addEvent( "addOneToCKCount", true )
addEventHandler("addOneToCKCount", localPlayer,
	function( )
		ckAmount = ckAmount + 1
		
		createGUI()
	end, false
)

addEvent( "addOneToCKCountFromSpawn", true )
addEventHandler("addOneToCKCountFromSpawn", localPlayer,
	function( )
		if (ckAmount>=1) then
			return
		else
		ckAmount = ckAmount + 1
		
		createGUI()
		end
	end, false
)

addEvent( "subtractOneFromCKCount", true )
addEventHandler("subtractOneFromCKCount", localPlayer,
	function( )
	if (ckAmount~=0) then
		ckAmount = ckAmount - 1
		createGUI()
	else
		ckAmount = 0
	end
	end, false
)
