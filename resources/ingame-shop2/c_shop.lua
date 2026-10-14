dgsSetRenderSetting("postGUI",true)

local donStoreShow = false

function donStoreBind()
	addCommandHandler("vipstore", openDonatorStoreGUI)
	bindKey("F2", "down", "vipstore")
end
addEventHandler("onClientResourceStart", getRootElement(), donStoreBind)

function openDonatorStoreGUI()
	if not donStoreShow then
		if getElementData(localPlayer, "loggedin") == 1 then
			displayStoreMain()
			donStoreShow = true
		end
	else
		closeStore()
		donStoreShow = false
	end
end

function displayStoreMain()
	showCursor(true)
	showChat(false)
	
	-- BACKGROUND AND PERSON LOGO
	donatorStoreGUI.image["background"] = dgsCreateImage(0, 0, sx, sy, "files/home/background.png", false)
	donatorStoreGUI.image["people_logo"] = dgsCreateImage((sx-996*px), (sy-636*py), 996*px, 636*py, "files/home/people_logo.png", false, donatorStoreGUI.image["background"])
	dgsSetEnabled(donatorStoreGUI.image["people_logo"], false)
	
	-- MEET NEW PLACES? 
	donatorStoreGUI.image["header2"] = dgsCreateImage(1105*px, 250*py, 770*px, 134*py, "files/home/news.png", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.image["header2"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	
	-- HEADER
	donatorStoreGUI.image["header"] = dgsCreateImage(45*px, 30*py, 1830*px, 151*py, "files/grey.png", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.image["header"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	donatorStoreGUI.image["headerlogo"] = dgsCreateImage(60*px, 24*py, 224*px, 114*py, "files/logo.png", false, donatorStoreGUI.image["header"])
	
	donatorStoreGUI.image["coinbox"] = dgsCreateImage(1350*px, 53*py, 170*px, 45*py, "files/coin.png", false, donatorStoreGUI.image["header"])
	donatorStoreGUI.image["coinboxicon"] = dgsCreateImage(10*px, 10*py, 30*px, 30*py, "files/icon_coin.png", false, donatorStoreGUI.image["coinbox"])
	donatorStoreGUI.button["coinboxadd"] = dgsCreateButton(1530*px, 53*py, 45*px, 45*py, "+", false, donatorStoreGUI.image["header"])
	addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["coinboxadd"], function()
		dgsSetSelectedTab(donatorStoreGUI.tabpanel["headertabpanel"], donatorStoreGUI.tab["refillgamecoins"])
	end, false)
	
	local donCoins = getElementData(localPlayer, "credits") or 0
	donatorStoreGUI.label["coinboxamount"] = dgsCreateLabel(45*px, 15*py, 150*px, 15*py, donCoins, false, donatorStoreGUI.image["coinbox"], tocolor(200, 200, 200), 1.25*px, 1.25*px)
	
	donatorStoreGUI.image["moneybox"] = dgsCreateImage(1600*px, 53*py, 170*px, 45*py, "files/money.png", false, donatorStoreGUI.image["header"])
	donatorStoreGUI.image["moneyboxicon"] = dgsCreateImage(10*px, 10*py, 30*px, 30*py, "files/icon_money.png", false, donatorStoreGUI.image["moneybox"])
	--donatorStoreGUI.button["moneyboxadd"] = dgsCreateButton(1780*px, 53*py, 45*px, 45*py, "+", false, donatorStoreGUI.image["header"])
	
	local cashMoney = getElementData(localPlayer, "bankmoney") or 0
	donatorStoreGUI.label["moneyboxamount"] = dgsCreateLabel(45*px, 15*py, 150*px, 15*py, cashMoney, false, donatorStoreGUI.image["moneybox"], tocolor(200, 200, 200), 1.25*px, 1.25*px)

	-- HEADER TABS
	donatorStoreGUI.tabpanel["headertabpanel"] = dgsCreateTabPanel(450*px, 60*py, 640*px, 20, false, donatorStoreGUI.image["header"], 20)

	--dgsCenterElement(donatorStoreGUI.tabpanel["headertabpanel"], false, true)
	dgsSetProperty(donatorStoreGUI.tabpanel["headertabpanel"], "bgColor", tocolor(0,0,0,0))
	dgsSetProperty(donatorStoreGUI.tabpanel["headertabpanel"], "tabGapSize", {0.04,true})
	
	donatorStoreGUI.tab["featured"] = dgsCreateTab("PROMOS", donatorStoreGUI.tabpanel["headertabpanel"])
	donatorStoreGUI.tab["items"] = dgsCreateTab("ITEMS PREMIUM", donatorStoreGUI.tabpanel["headertabpanel"])
	donatorStoreGUI.tab["vipcarshop"] = dgsCreateTab("VIP CARSHOP", donatorStoreGUI.tabpanel["headertabpanel"])
	donatorStoreGUI.tab["perks"] = dgsCreateTab("AVANTAGES PREMIUM", donatorStoreGUI.tabpanel["headertabpanel"])
	donatorStoreGUI.tab["refillgamecoins"] = dgsCreateTab("RECHARGER "..string.upper(donCurrencyName).."", donatorStoreGUI.tabpanel["headertabpanel"])
	
	dgsSetProperty(donatorStoreGUI.tab["featured"], "tabColor", {tocolor(0,0,0,0), tocolor(255,255,255,150), tocolor(249,139,6,255)})
	dgsSetProperty(donatorStoreGUI.tab["items"], "tabColor", {tocolor(0,0,0,0), tocolor(255,255,255,150), tocolor(249,139,6,255)})
	dgsSetProperty(donatorStoreGUI.tab["vipcarshop"], "tabColor", {tocolor(0,0,0,0), tocolor(255,255,255,150), tocolor(249,139,6,255)})
	dgsSetProperty(donatorStoreGUI.tab["perks"], "tabColor", {tocolor(0,0,0,0), tocolor(255,255,255,150), tocolor(249,139,6,255)})
	dgsSetProperty(donatorStoreGUI.tab["refillgamecoins"], "tabColor", {tocolor(0,0,0,0), tocolor(255,255,255,150), tocolor(249,139,6,255)})
	
	addEventHandler("onDgsTabSelect", donatorStoreGUI.tabpanel["headertabpanel"], function ( new, old )
		coinTrades = false
		
		if source == donatorStoreGUI.tab["featured"] then
			showFeatured()
		elseif source == donatorStoreGUI.tab["items"] then
			showItems()
		elseif source == donatorStoreGUI.tab["vipcarshop"] then
			showCarshop()
		elseif source == donatorStoreGUI.tab["perks"] then
			showPerks()
		elseif source == donatorStoreGUI.tab["refillgamecoins"] then
			showCoinshop()
		end
	end)
	-- HEADER TABS
		
	-- BOTTOM RIGHT BUTTONS
	donatorStoreGUI.button["close"] = dgsCreateButton(45*px, sy-(100*py), 200*px, 65*py, "FERMER", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.button["close"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["close"], function()
		openDonatorStoreGUI()
	end, false)
	--dgsSetProperty(donatorStoreGUI.button["close"], "image", "files/btn_transparent.png")
	
	--donatorStoreGUI.button["settings"] = dgsCreateButton(45*px + 230*px, sy-(100*py), 200*px, 65*py, "--", false, donatorStoreGUI.image["background"])
	--dgsSetEnabled(donatorStoreGUI.button["settings"], false)
	--dgsSetProperty(donatorStoreGUI.button["settings"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	--dgsSetProperty(donatorStoreGUI.button["close"], "iconImage", {"files/icon_leave.png", "files/icon_leave.png", "files/icon_leave.png"})
	
	donatorStoreGUI.label["playingas"] = dgsCreateLabel(45*px + 230*px + 230*px, sy-(90*py), 224*px, 114*py, "Nom:", false, donatorStoreGUI.image["background"], tocolor(200, 200, 200), 0.7, 0.7)
	donatorStoreGUI.label["charusername"] = dgsCreateLabel(45*px + 230*px + 230*px, sy-(75*py), 224*px, 114*py, getPlayerName(localPlayer):gsub("_", " ").." ("..getElementData(localPlayer, "account:username")..")", false, donatorStoreGUI.image["background"], false, 1.2, 1.2)
	
	showFeatured()
end

function showFeatured()
	setupPage("home")
	
	-- FEATURED SCROLL PANE
	donatorStoreGUI.scrollpane["shop"] = dgsCreateScrollPane(45*px, 250*py, 1025*px, 675*py, false, donatorStoreGUI.image["background"])
	--dgsSetProperty(donatorStoreGUI.scrollpane["shop"], "outline",{"in",2,tocolor(255, 255, 255),true,true,true,true})
	
	local side = false
	local left = 0
	local top = 0
	for k, v in ipairs(VIPShopItems) do
		if v.percentOff and (v.itemType == 1 or v.itemType == 2 or v.itemType == 3) and disp_time(v.offerTimestamp-getRealTime().timestamp) then -- if it's on offer, with items enabled
		--if v.percentOff and (v.itemType == 1 or v.itemType == 3) then -- if it's on offer
			donatorStoreGUI.image["featured:"..k] = dgsCreateImage(0 + left, 0 + top, 492*px, 298*px, "files/itemimages/"..v.image..".png", false, donatorStoreGUI.scrollpane["shop"])
			donatorStoreGUI.image["featured:"..k..":glow"] = dgsCreateImage(0, 0, 492*px, 298*px, "files/home/effects.png", false, donatorStoreGUI.image["featured:"..k])

			addEventHandler("onDgsMouseClickDown", donatorStoreGUI.image["featured:"..k..":glow"], function()
				viewItemFuncton(k)
			end, false)
			
			donatorStoreGUI.image["featured:"..k..":offer"] = dgsCreateImage(25*px, 0, 59*px, 63*px, "files/home/percent_green.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
			donatorStoreGUI.label["featured:"..k..":offerprice"] = dgsCreateLabel(0, 0, 59*px, 63*py, v.percentOff.."%", false, donatorStoreGUI.image["featured:"..k..":offer"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":offerprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
			dgsLabelSetVerticalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
			
			local coinPercent = v.coins / 100
			local newCoinCost = coinPercent * (100-v.percentOff)
			
			local cashPercent = v.cash / 100
			local newCashCost = cashPercent * (100-v.percentOff)
			
			donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 220*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
			donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 223*px, 32*px, 32*px, math.floor(newCoinCost).." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			donatorStoreGUI.image["featured:"..k..":cash"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
			donatorStoreGUI.label["featured:"..k..":cashprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, "$"..formatMoney(math.floor(newCashCost)).."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			
			donatorStoreGUI.image["featured:"..k..":timeclock"] = dgsCreateImage(492*px-20*px, 270*px, 14*px, 14*px, "files/home/clock.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
			donatorStoreGUI.label["featured:"..k..":time"] = dgsCreateLabel(492*px-175*px, 266*px, 32*px, 32*px, disp_time(v.offerTimestamp-getRealTime().timestamp), false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":time"], "shadow", {1,1,tocolor(0,0,0,100),1})
			timeTimers[k] = setTimer(function()
				if donatorStoreGUI.label["featured:"..k..":time"] and isElement(donatorStoreGUI.label["featured:"..k..":time"]) then dgsSetText(donatorStoreGUI.label["featured:"..k..":time"], disp_time(v.offerTimestamp-getRealTime().timestamp)) end			
			end, 1000, 0)
			
			--name
			donatorStoreGUI.label["featured:"..k..":title"] = dgsCreateLabel(0, 10*px, 492*px, 20*py, v.name, false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":title"], "center")
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":title"], "shadow", {1,1,tocolor(0,0,0,100),1})

			if side then 
				left = 0
				top = top + 320*px
				side = false
			else
				left = 492*px + 15*px
				side = true
			end
		end
	end	
end

function showItems()
	setupPage("items")
	
	-- FEATURED SCROLL PANE
	donatorStoreGUI.scrollpane["shop"] = dgsCreateScrollPane(45*px, 250*py, 1025*px, 675*py, false, donatorStoreGUI.image["background"])
	--dgsSetProperty(donatorStoreGUI.scrollpane["shop"], "outline",{"in",2,tocolor(255, 255, 255),true,true,true,true})
	
	local side = false
	local left = 0
	local top = 0
	for k, v in ipairs(VIPShopItems) do
		if v.itemType == 2 then -- if it's an item
			donatorStoreGUI.image["featured:"..k] = dgsCreateImage(0 + left, 0 + top, 492*px, 298*px, "files/itemimages/"..v.image..".png", false, donatorStoreGUI.scrollpane["shop"])
			donatorStoreGUI.image["featured:"..k..":glow"] = dgsCreateImage(0, 0, 492*px, 298*px, "files/home/effects.png", false, donatorStoreGUI.image["featured:"..k])
			
			addEventHandler("onDgsMouseClickDown", donatorStoreGUI.image["featured:"..k..":glow"], function()
				viewItemFuncton(k)
			end, false)
			
			if v.percentOff and disp_time(v.offerTimestamp-getRealTime().timestamp) then 	-- if it's on offer, show the offer
				donatorStoreGUI.image["featured:"..k..":offer"] = dgsCreateImage(25*px, 0, 59*px, 63*px, "files/home/percent_green.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":offerprice"] = dgsCreateLabel(0, 0, 59*px, 63*py, v.percentOff.."%", false, donatorStoreGUI.image["featured:"..k..":offer"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":offerprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
				dgsLabelSetVerticalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
				
				donatorStoreGUI.image["featured:"..k..":timeclock"] = dgsCreateImage(492*px-20*px, 270*px, 14*px, 14*px, "files/home/clock.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":time"] = dgsCreateLabel(492*px-175*px, 266*px, 32*px, 32*px, disp_time(v.offerTimestamp-getRealTime().timestamp), false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":time"], "shadow", {1,1,tocolor(0,0,0,100),1})
				timeTimers[k] = setTimer(function()
					if donatorStoreGUI.label["featured:"..k..":time"] and isElement(donatorStoreGUI.label["featured:"..k..":time"]) then dgsSetText(donatorStoreGUI.label["featured:"..k..":time"], disp_time(v.offerTimestamp-getRealTime().timestamp)) end				
				end, 1000, 0)
				
				local coinPercent = v.coins / 100
				local newCoinCost = coinPercent * (100-v.percentOff)
				
				local cashPercent = v.cash / 100
				local newCashCost = cashPercent * (100-v.percentOff)
				
				donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 220*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 223*px, 32*px, 32*px, math.floor(newCoinCost).." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				donatorStoreGUI.image["featured:"..k..":cash"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":cashprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, "$"..formatMoney(math.floor(newCashCost)).."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			else
				donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 220*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 223*px, 32*px, 32*px, v.coins.." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				donatorStoreGUI.image["featured:"..k..":cash"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":cashprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, "$"..formatMoney(v.cash).."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			end
			
			--name
			donatorStoreGUI.label["featured:"..k..":title"] = dgsCreateLabel(0, 10*px, 492*px, 20*px, v.name, false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":title"], "center")
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":title"], "shadow", {1,1,tocolor(0,0,0,100),1})

			if side then 
				left = 0
				top = top + 320*px
				side = false
			else
				left = 492*px + 15*px
				side = true
			end
		end
	end	
end

function showCarshop()
	setupPage("carshop")
	
	-- FEATURED SCROLL PANE
	donatorStoreGUI.scrollpane["shop"] = dgsCreateScrollPane(45*px, 250*py, 1025*px, 675*py, false, donatorStoreGUI.image["background"])
	--dgsSetProperty(donatorStoreGUI.scrollpane["shop"], "outline",{"in",2,tocolor(255, 255, 255),true,true,true,true})
	
	local side = false
	local left = 0
	local top = 0
	for k, v in ipairs(VIPShopItems) do
		if v.itemType == 1 then -- if it's an item
			donatorStoreGUI.image["featured:"..k] = dgsCreateImage(0 + left, 0 + top, 492*px, 298*px, "files/itemimages/"..v.image..".png", false, donatorStoreGUI.scrollpane["shop"])
			donatorStoreGUI.image["featured:"..k..":glow"] = dgsCreateImage(0, 0, 492*px, 298*px, "files/home/effects.png", false, donatorStoreGUI.image["featured:"..k])
			
			addEventHandler("onDgsMouseClickDown", donatorStoreGUI.image["featured:"..k..":glow"], function()
				viewItemFuncton(k)
			end, false)
			
			if v.percentOff and disp_time(v.offerTimestamp-getRealTime().timestamp) then 	-- if it's on offer, show the offer
				donatorStoreGUI.image["featured:"..k..":offer"] = dgsCreateImage(25*px, 0, 59*px, 63*px, "files/home/percent_green.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":offerprice"] = dgsCreateLabel(0, 0, 59*px, 63*py, v.percentOff.."%", false, donatorStoreGUI.image["featured:"..k..":offer"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":offerprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
				dgsLabelSetVerticalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
				
				donatorStoreGUI.image["featured:"..k..":timeclock"] = dgsCreateImage(492*px-20*px, 270*px, 14*px, 14*px, "files/home/clock.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":time"] = dgsCreateLabel(492*px-175*px, 266*px, 32*px, 32*px, disp_time(v.offerTimestamp-getRealTime().timestamp), false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":time"], "shadow", {1,1,tocolor(0,0,0,100),1})
				
				timeTimers[k] = setTimer(function()
					if donatorStoreGUI.label["featured:"..k..":time"] and isElement(donatorStoreGUI.label["featured:"..k..":time"]) then dgsSetText(donatorStoreGUI.label["featured:"..k..":time"], disp_time(v.offerTimestamp-getRealTime().timestamp)) end				
				end, 1000, 0)
				
				local coinPercent = v.coins / 100
				local newCoinCost = coinPercent * (100-v.percentOff)
				
				local cashPercent = v.cash / 100
				local newCashCost = cashPercent * (100-v.percentOff)
				
				donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 220*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 223*px, 32*px, 32*px, math.floor(newCoinCost).." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				donatorStoreGUI.image["featured:"..k..":cash"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":cashprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, "$"..formatMoney(math.floor(newCashCost)).."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			else
				donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 220*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 223*px, 32*px, 32*px, v.coins.." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				donatorStoreGUI.image["featured:"..k..":cash"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":cashprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, "$"..formatMoney(v.cash).."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			end
			
			--name
			donatorStoreGUI.label["featured:"..k..":title"] = dgsCreateLabel(0, 10*px, 492*px, 20*px, v.name, false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":title"], "center")
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":title"], "shadow", {1,1,tocolor(0,0,0,100),1})

			if side then 
				left = 0
				top = top + 320*px
				side = false
			else
				left = 492*px + 15*px
				side = true
			end
		end
	end	
end

function showPerks()
	setupPage("perks")
	
	-- FEATURED SCROLL PANE
	donatorStoreGUI.scrollpane["shop"] = dgsCreateScrollPane(45*px, 250*py, 1025*px, 675*py, false, donatorStoreGUI.image["background"])
	--dgsSetProperty(donatorStoreGUI.scrollpane["shop"], "outline",{"in",2,tocolor(255, 255, 255),true,true,true,true})
	
	local side = false
	local left = 0
	local top = 0
	for k, v in ipairs(VIPShopItems) do
		if v.itemType == 3 then -- if it's an item
			donatorStoreGUI.image["featured:"..k] = dgsCreateImage(0 + left, 0 + top, 492*px, 298*px, "files/itemimages/"..v.image..".png", false, donatorStoreGUI.scrollpane["shop"])
			donatorStoreGUI.image["featured:"..k..":glow"] = dgsCreateImage(0, 0, 492*px, 298*px, "files/home/effects.png", false, donatorStoreGUI.image["featured:"..k])
			
			addEventHandler("onDgsMouseClickDown", donatorStoreGUI.image["featured:"..k..":glow"], function()
				viewItemFuncton(k)
			end, false)
			
			if v.percentOff and disp_time(v.offerTimestamp-getRealTime().timestamp) then 	-- if it's on offer, show the offer
				donatorStoreGUI.image["featured:"..k..":offer"] = dgsCreateImage(25*px, 0, 59*px, 63*px, "files/home/percent_green.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":offerprice"] = dgsCreateLabel(0, 0, 59*px, 63*py, v.percentOff.."%", false, donatorStoreGUI.image["featured:"..k..":offer"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":offerprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
				dgsLabelSetVerticalAlign(donatorStoreGUI.label["featured:"..k..":offerprice"], "center")
				
				donatorStoreGUI.image["featured:"..k..":timeclock"] = dgsCreateImage(492*px-20*px, 270*px, 14*px, 14*px, "files/home/clock.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":time"] = dgsCreateLabel(492*px-175*px, 266*px, 32*px, 32*px, disp_time(v.offerTimestamp-getRealTime().timestamp), false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":time"], "shadow", {1,1,tocolor(0,0,0,100),1})
				
				timeTimers[k] = setTimer(function()
					local k = k
					if donatorStoreGUI.label["featured:"..k..":time"] and isElement(donatorStoreGUI.label["featured:"..k..":time"]) then dgsSetText(donatorStoreGUI.label["featured:"..k..":time"], disp_time(v.offerTimestamp-getRealTime().timestamp)) end				
				end, 1000, 0)
				
				local coinPercent = v.coins / 100
				local newCoinCost = coinPercent * (100-v.percentOff)
				
				local cashPercent = v.cash / 100
				local newCashCost = cashPercent * (100-v.percentOff)
				
				donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 220*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 223*px, 32*px, 32*px, math.floor(newCoinCost).." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				donatorStoreGUI.image["featured:"..k..":cash"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
				donatorStoreGUI.label["featured:"..k..":cashprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, "$"..formatMoney(math.floor(newCashCost)).."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
				dgsSetProperty(donatorStoreGUI.label["featured:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
			else
				local cashCost2 = formatMoney(v.cash)
				if cashCost2 == "0" and v.coins and v.coins ~= 0 then
					donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
					donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, v.coins.." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
					dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})

				elseif v.coins and v.coins ~= 0 then
					donatorStoreGUI.image["featured:"..k..":coins"] = dgsCreateImage(15*px, 220*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
					donatorStoreGUI.label["featured:"..k..":coinsprice"] = dgsCreateLabel(60*px, 223*px, 32*px, 32*px, v.coins.." "..donCurrencyName.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
					dgsSetProperty(donatorStoreGUI.label["featured:"..k..":coinsprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
					
					donatorStoreGUI.image["featured:"..k..":cash"] = dgsCreateImage(15*px, 260*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["featured:"..k..":glow"])
					donatorStoreGUI.label["featured:"..k..":cashprice"] = dgsCreateLabel(60*px, 263*px, 32*px, 32*px, "$"..cashCost2.."", false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
					dgsSetProperty(donatorStoreGUI.label["featured:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				end
			end
			
			--name
			donatorStoreGUI.label["featured:"..k..":title"] = dgsCreateLabel(0, 10*px, 492*px, 20*px, v.name, false, donatorStoreGUI.image["featured:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["featured:"..k..":title"], "center")
			dgsSetProperty(donatorStoreGUI.label["featured:"..k..":title"], "shadow", {1,1,tocolor(0,0,0,100),1})

			if side then 
				left = 0
				top = top + 320*px
				side = false
			else
				left = 492*px + 15*px
				side = true
			end
		end
	end	
end

function showCoinshop()
	if setupPage("coinstore") then
		--[[
		donatorStoreGUI.browser["main"] = dgsCreateBrowser(45*px, 250*py, 1025*px, 675*py, false, donatorStoreGUI.image["background"])
		addEventHandler("onClientBrowserCreated", donatorStoreGUI.browser["main"], function()
			setBrowserProperty(donatorStoreGUI.browser["main"], "mobile", "1")
			if loadBrowserURL(donatorStoreGUI.browser["main"], "https://google.com") then
				outputDebugString("loaded")
			end
		end, false)]]
		
		donatorStoreGUI.label["refillcoinsinfo"] = dgsCreateLabel(45*px, 275*py, 1000*px, 63*py, "* Vous serez redirigé vers notre prestataire de paiement sécurisé, Square, où vous pourrez finaliser votre paiement. Vos informations de paiement ne seront ni partagées ni stockées avec nous. Notre équipe ne vous les demandera jamais. Si vous remarquez quelque chose de suspect, signalez-le immédiatement via F1. *", false, donatorStoreGUI.image["background"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
		dgsLabelSetHorizontalAlign(donatorStoreGUI.label["refillcoinsinfo"], "center", true)
		dgsSetProperty(donatorStoreGUI.label["refillcoinsinfo"],"wordbreak",true)
		
		-- FEATURED SCROLL PANE
		donatorStoreGUI.scrollpane["shop"] = dgsCreateScrollPane(45*px, 450*py, 1480*px, 440*py, false, donatorStoreGUI.image["background"])
		--dgsSetProperty(donatorStoreGUI.scrollpane["shop"], "outline",{"in",2,tocolor(255, 255, 255),true,true,true,true})
		
		local side = false
		local left = 0
		local top = 20*py
		
		for k, v in ipairs(VIPShopItems) do
			if v.itemType == 4 then -- if it's an item
				donatorStoreGUI.image["coinstore:"..k] = dgsCreateImage(0 + left, 0+top, 298*px, 298*py, "files/itemimages/"..v.image..".png", false, donatorStoreGUI.scrollpane["shop"])
				donatorStoreGUI.image["coinstore:"..k..":glow"] = dgsCreateImage(0, 0, 298*px, 298*py, "files/home/effects.png", false, donatorStoreGUI.image["coinstore:"..k])
				
				if v.percentOff and disp_time(v.offerTimestamp-getRealTime().timestamp) then 	-- if it's on offer, show the offer
					donatorStoreGUI.image["coinstore:"..k..":offer"] = dgsCreateImage(25*px, 0, 59*px, 63*px, "files/home/percent_green.png", false, donatorStoreGUI.image["coinstore:"..k..":glow"])
					donatorStoreGUI.label["coinstore:"..k..":offerprice"] = dgsCreateLabel(0, 0, 59*px, 63*py, v.percentOff.."%", false, donatorStoreGUI.image["coinstore:"..k..":offer"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
					dgsSetProperty(donatorStoreGUI.label["coinstore:"..k..":offerprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
					dgsLabelSetHorizontalAlign(donatorStoreGUI.label["coinstore:"..k..":offerprice"], "center")
					dgsLabelSetVerticalAlign(donatorStoreGUI.label["coinstore:"..k..":offerprice"], "center")
					
					donatorStoreGUI.image["coinstore:"..k..":timeclock"] = dgsCreateImage(298*px-20*px, 250*px, 14*px, 14*px, "files/home/clock.png", false, donatorStoreGUI.image["coinstore:"..k..":glow"])
					donatorStoreGUI.label["coinstore:"..k..":time"] = dgsCreateLabel(298*px-155*px, 266*px, 32*px, 32*px, disp_time(v.offerTimestamp-getRealTime().timestamp), false, donatorStoreGUI.image["coinstore:"..k..":glow"], tocolor(255, 255, 255), 1.5*px, 1.5*px)
					dgsSetProperty(donatorStoreGUI.label["coinstore:"..k..":time"], "shadow", {1,1,tocolor(0,0,0,100),1})
					
					timeTimers[k] = setTimer(function()
						if donatorStoreGUI.label["coinstore:"..k..":time"] and isElement(donatorStoreGUI.label["coinstore:"..k..":time"]) then dgsSetText(donatorStoreGUI.label["coinstore:"..k..":time"], disp_time(v.offerTimestamp-getRealTime().timestamp)) end
					end, 1000, 0)
					
					local cashPercent = v.irlcash / 100
					local newCashCost = cashPercent * (100-v.percentOff)
				
					donatorStoreGUI.image["coinstore:"..k..":cash"] = dgsCreateImage(15*px, 266*px, 24*px, 24*px, "files/icon_dollar.png", false, donatorStoreGUI.image["coinstore:"..k..":glow"])
					donatorStoreGUI.label["coinstore:"..k..":cashprice"] = dgsCreateLabel(50*px, 263*px, 32*px, 32*px, ""..formatMoney(math.floor(newCashCost)).."", false, donatorStoreGUI.image["coinstore:"..k..":glow"], tocolor(255, 255, 255), 2*px, 2*px)
					dgsSetProperty(donatorStoreGUI.label["coinstore:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				else
					donatorStoreGUI.image["coinstore:"..k..":cash"] = dgsCreateImage(15*px, 266*px, 24*px, 24*px, "files/icon_dollar.png", false, donatorStoreGUI.image["coinstore:"..k..":glow"])
					donatorStoreGUI.label["coinstore:"..k..":cashprice"] = dgsCreateLabel(50*px, 263*px, 32*px, 32*px, ""..formatMoney(v.irlcash).."", false, donatorStoreGUI.image["coinstore:"..k..":glow"], tocolor(255, 255, 255), 2*px, 2*px)
					dgsSetProperty(donatorStoreGUI.label["coinstore:"..k..":cashprice"], "shadow", {1,1,tocolor(0,0,0,100),1})
				end
				
				--name
				donatorStoreGUI.label["coinstore:"..k..":title"] = dgsCreateLabel(0, 10*px, 298*px, 20*px, v.name, false, donatorStoreGUI.image["coinstore:"..k..":glow"], tocolor(255, 255, 255), 2*px, 2*px)
				dgsLabelSetHorizontalAlign(donatorStoreGUI.label["coinstore:"..k..":title"], "center")
				dgsSetProperty(donatorStoreGUI.label["coinstore:"..k..":title"], "shadow", {1,1,tocolor(0,0,0,100),1})
				
				donatorStoreGUI.button["coinstore:"..k..":buy"] = dgsCreateButton(0 + left, 0+top+315*px, 298*px, 50*py, "Acheter", false, donatorStoreGUI.scrollpane["shop"])
				dgsSetProperty(donatorStoreGUI.button["coinstore:"..k..":buy"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
				dgsSetProperty(donatorStoreGUI.button["coinstore:"..k..":buy"], "color",{tocolor(0, 255, 0, 100), tocolor(0, 255, 0, 150), tocolor(0, 255, 0, 120)})
				addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["coinstore:"..k..":buy"], function()
					openBrowserURL(v.payLink, donatorStoreGUI.browser["main"])
					--purchaseCoinStore(v.payLink)
				end, false)
				
				left = left + (298*px + 15*px)
			end
		end	
		
		donatorStoreGUI.button["tradecoins"] = dgsCreateButton(sx-(200*px)-395*px, sy-(100*py), 200*px, 65*py, "TRADE", false, donatorStoreGUI.image["background"])
		dgsSetProperty(donatorStoreGUI.button["tradecoins"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
		addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["tradecoins"], function()
			viewCoinTrades()
		end, false)
	end
end

--[[function purchaseCoinStore(link)
	clearStore()
	
	if donatorStoreGUI.image["people_logo"] and isElement(donatorStoreGUI.image["people_logo"]) then destroyElement(donatorStoreGUI.image["people_logo"]) end
	if donatorStoreGUI.image["header2"] and isElement(donatorStoreGUI.image["header2"]) then destroyElement(donatorStoreGUI.image["header2"]) end
	
	donatorStoreGUI.browser["main"] = dgsCreateBrowser(45*px, 250*py, 1830*px, 675*py, false, donatorStoreGUI.image["background"])
	addEventHandler("onClientBrowserCreated", donatorStoreGUI.browser["main"], function()
		--setBrowserProperty(donatorStoreGUI.browser["main"], "mobile", "1")
		if openBrowserURL(link, donatorStoreGUI.browser["main"]) then
			--outputDebugString("loaded")
		end
	end, false)
	
	donatorStoreGUI.button["cancel"] = dgsCreateButton(sx-(200*px)-45*px, sy-(100*py), 200*px, 65*py, "Retour", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.button["cancel"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["cancel"], function()
		local tab = dgsGetSelectedTab(donatorStoreGUI.tabpanel["headertabpanel"])
	
		if tab == donatorStoreGUI.tab["refillgamecoins"] then
			showCoinshop()
			
			coinTrades = false
		end
	end, false)
end]]