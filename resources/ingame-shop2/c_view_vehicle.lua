function viewVIPVehicle(vehicleID)
	clearStore()
	
	if donatorStoreGUI.image["people_logo"] and isElement(donatorStoreGUI.image["people_logo"]) then destroyElement(donatorStoreGUI.image["people_logo"]) end
	if donatorStoreGUI.image["header2"] and isElement(donatorStoreGUI.image["header2"]) then destroyElement(donatorStoreGUI.image["header2"]) end
	
	local k = vehicleID
	local v = VIPShopItems[vehicleID]
	
	local left = 0
	local top = 0
	
	if v then
		donatorStoreGUI.image["viewvip"] = dgsCreateImage(45*px, 250*py, (492*px)*2.2, (298*py)*2.2, "files/itemimages/"..v.image..".png", false, donatorStoreGUI.image["background"])
		dgsSetProperty(donatorStoreGUI.image["viewvip"], "outline",{"out",2,tocolor(255, 255, 255),true,true,true,true})
		donatorStoreGUI.image["viewvip:glow"] = dgsCreateImage(0, 0, (492*px)*2.2, (298*py)*2.2, "files/home/effects.png", false, donatorStoreGUI.image["viewvip"])
		
		local coinCost = v.coins
		local cashCost = v.cash
		
		if v.percentOff and disp_time(v.offerTimestamp-getRealTime().timestamp) then
			donatorStoreGUI.image["viewvip:offer"] = dgsCreateImage(25*px, 0, 59*px, 63*px, "files/home/percent_green.png", false, donatorStoreGUI.image["viewvip:glow"])
			donatorStoreGUI.label["viewvip:offerprice"] = dgsCreateLabel(0, 0, 59*px, 63*py, v.percentOff.."%", false, donatorStoreGUI.image["viewvip:offer"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["viewvip:offerprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["viewvip:offerprice"], "center")
			dgsLabelSetVerticalAlign(donatorStoreGUI.label["viewvip:offerprice"], "center")

			donatorStoreGUI.image["viewvip:coins"] = dgsCreateImage(15*px, (255*py)*2.2, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["viewvip:glow"])
			
			local coinPercent = v.coins / 100
			coinCost = coinPercent * (100-v.percentOff)
			
			donatorStoreGUI.label["viewvip:coins"] = dgsCreateLabel(60*px, (253*py)*2.2, 32*px, 32*px, formatMoney(math.floor(coinCost)).." "..donCurrencyName.."", false, donatorStoreGUI.image["viewvip:glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["viewvip:coins"], "shadow", {1,1,tocolor(0,0,0,100),1})
			donatorStoreGUI.image["viewvip:cash"] = dgsCreateImage(15*px, (275*py)*2.2, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["viewvip:glow"])
			
			local percent = v.cash / 100
			cashCost = percent * (100-v.percentOff)
			
			donatorStoreGUI.label["viewvip:cash"] = dgsCreateLabel(60*px, (273*py)*2.2, 32*px, 32*px, "$"..formatMoney(math.floor(cashCost)).."", false, donatorStoreGUI.image["viewvip:glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["viewvip:cash"], "shadow", {1,1,tocolor(0,0,0,100),1})
			
			donatorStoreGUI.image["viewvip:clock"] = dgsCreateImage(((492*px)*2.2)-20*px, (285*py)*2.2, 14*px, 14*px, "files/home/clock.png", false, donatorStoreGUI.image["viewvip:glow"])
			donatorStoreGUI.label["viewvip:time"] = dgsCreateLabel(((492*px)*2.2)-175*px, (283*py)*2.2, 32*px, 32*px, disp_time(v.offerTimestamp-getRealTime().timestamp), false, donatorStoreGUI.image["viewvip:glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["viewvip:time"], "shadow", {1,1,tocolor(0,0,0,100),1})
			
			timeTimers[k] = setTimer(function()
				if donatorStoreGUI.label["viewvip:time"] and isElement(donatorStoreGUI.label["viewvip:time"]) then dgsSetText(donatorStoreGUI.label["viewvip:time"], disp_time(v.offerTimestamp-getRealTime().timestamp)) end
			end, 1000, 0)
		else
			donatorStoreGUI.image["viewvip:coins"] = dgsCreateImage(15*px, (255*py)*2.2, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["viewvip:glow"])
			donatorStoreGUI.label["viewvip:coins"] = dgsCreateLabel(60*px, (253*py)*2.2, 32*px, 32*px, coinCost.." "..donCurrencyName.."", false, donatorStoreGUI.image["viewvip:glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["viewvip:coins"], "shadow", {1,1,tocolor(0,0,0,100),1})
			donatorStoreGUI.image["viewvip:cash"] = dgsCreateImage(15*px, (275*py)*2.2, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["viewvip:glow"])
			donatorStoreGUI.label["viewvip:cash"] = dgsCreateLabel(60*px, (273*py)*2.2, 32*px, 32*px, "$"..formatMoney(cashCost).."", false, donatorStoreGUI.image["viewvip:glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["viewvip:cash"], "shadow", {1,1,tocolor(0,0,0,100),1})
		end
		
		--name
		--[[donatorStoreGUI.label["viewvip:title"] = dgsCreateLabel(0, 0, ((492*px)*2.2), 20*py, v.name, false, donatorStoreGUI.image["viewvip:glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
		dgsLabelSetHorizontalAlign(donatorStoreGUI.label["viewvip:title"], "center")
		dgsSetProperty(donatorStoreGUI.label["viewvip:title"], "shadow", {1,1,tocolor(0,0,0,100),1})]]
		
		-- info scrollpane
		donatorStoreGUI.scrollpane["viewvip"] = dgsCreateScrollPane(1150*px, 250*py, 750*px, 700*py, false, donatorStoreGUI.image["background"])
		
		donatorStoreGUI.label["viewvip:info:title"] = dgsCreateLabel(0, 0, 750*px, 20*py, v.name, false, donatorStoreGUI.scrollpane["viewvip"], tocolor(255, 255, 255), 2*px, 2*px)
		dgsLabelSetHorizontalAlign(donatorStoreGUI.label["viewvip:info:title"], "center")
		dgsSetProperty(donatorStoreGUI.label["viewvip:info:title"], "shadow", {1,1,tocolor(0,0,0,100),1})
		
		donatorStoreGUI.label["viewvip:info:desc"] = dgsCreateLabel(0, 30, 730*px, 650*py, v.description, false, donatorStoreGUI.scrollpane["viewvip"], tocolor(255, 255, 255), 1.2*px, 1.2*px)
		dgsLabelSetHorizontalAlign(donatorStoreGUI.label["viewvip:info:desc"], "center", true)
		dgsSetProperty(donatorStoreGUI.label["viewvip:info:desc"],"wordbreak",true)
		dgsSetProperty(donatorStoreGUI.label["viewvip:info:desc"],"clip",clip)
		
		donatorStoreGUI.button["buyvehicle"] = dgsCreateButton(sx-(200*px)-45*px, sy-(100*py), 200*px, 65*py, "Acheter", false, donatorStoreGUI.image["background"])
		dgsSetProperty(donatorStoreGUI.button["buyvehicle"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
		addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["buyvehicle"], function()
			triggerServerEvent("purchaseVIPVehicleEvent", localPlayer, k, coinCost, cashCost)
			
			openDonatorStoreGUI()
		end, false)
		
		donatorStoreGUI.button["testdrive"] = dgsCreateButton(sx-(200*px)-45*px-230*px, sy-(100*py), 200*px, 65*py, "Test Drive", false, donatorStoreGUI.image["background"])
		dgsSetProperty(donatorStoreGUI.button["testdrive"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
		addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["testdrive"], function()
			local vehShopID = VIPShopItems[k].vehLibID
			triggerServerEvent("vehicle-manager:handling:createTestVehicle", localPlayer, tonumber(vehShopID), "VIP", false)

			openDonatorStoreGUI()
		end, false)
		
		donatorStoreGUI.button["cancel"] = dgsCreateButton(sx-(200*px)-45*px-230*px-230*px, sy-(100*py), 200*px, 65*py, "Retour", false, donatorStoreGUI.image["background"])
		dgsSetProperty(donatorStoreGUI.button["cancel"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
		addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["cancel"], function()
			local tab = dgsGetSelectedTab(donatorStoreGUI.tabpanel["headertabpanel"])
		
			if tab == donatorStoreGUI.tab["featured"] then
				showFeatured()
			elseif tab == donatorStoreGUI.tab["items"] then
				showItems()
			elseif tab == donatorStoreGUI.tab["vipcarshop"] then
				showCarshop()
			elseif tab == donatorStoreGUI.tab["perks"] then
				showCases()
			elseif tab == donatorStoreGUI.tab["refillgamecoins"] then
				showCoinshop()
			end
		end, false)
	end
end