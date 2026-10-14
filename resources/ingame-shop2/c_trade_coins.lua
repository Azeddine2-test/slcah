coinTrades = false

function viewCoinTrades()
	clearStore()
	
	if donatorStoreGUI.image["people_logo"] and isElement(donatorStoreGUI.image["people_logo"]) then destroyElement(donatorStoreGUI.image["people_logo"]) end
	if donatorStoreGUI.image["header2"] and isElement(donatorStoreGUI.image["header2"]) then destroyElement(donatorStoreGUI.image["header2"]) end
	
	donatorStoreGUI.image["header3"] = dgsCreateImage(1105*px, 210*py, 770*px, 134*py, "files/coinauction/news.png", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.image["header3"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	dgsCenterElement(donatorStoreGUI.image["header3"], false, true)
	
	-- FEATURED SCROLL PANE
	donatorStoreGUI.scrollpane["shop"] = dgsCreateScrollPane(45*px, 375*py, 1830*px, 550*py, false, donatorStoreGUI.image["background"])
	--dgsSetProperty(donatorStoreGUI.scrollpane["shop"], "outline",{"in",2,tocolor(255, 255, 255),true,true,true,true})
	
	if coinTrades then
		local top = 0
		local left = 0
		for k, v in ipairs(coinTrades) do
			donatorStoreGUI.image["cointrade:"..k] = dgsCreateImage(0 + left, 0 + top, 240*px, 300*py, "files/coinauction/postit.png", false, donatorStoreGUI.scrollpane["shop"])
			dgsSetProperty(donatorStoreGUI.image["cointrade:"..k], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
			
			donatorStoreGUI.label["cointrade:"..k..":poster"] = dgsCreateLabel(0, 20*py, 240*px, 20*py, v.accUsername, false, donatorStoreGUI.image["cointrade:"..k], tocolor(255, 255, 255), 1.75*px, 1.75*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["cointrade:"..k..":poster"], "center")
			
			donatorStoreGUI.label["cointrade:"..k..":sellingtitle"] = dgsCreateLabel(0, 60*py, 240*px, 20*py,  "Vend:", false, donatorStoreGUI.image["cointrade:"..k], tocolor(100, 100, 100), 1.25*px, 1.25*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["cointrade:"..k..":sellingtitle"], "center")
			
			donatorStoreGUI.image["cointrade:"..k..":coins"] = dgsCreateImage(15*px, 85*px, 32*px, 32*px, "files/icon_coin.png", false, donatorStoreGUI.image["cointrade:"..k])
			donatorStoreGUI.label["cointrade:"..k..":amount"] = dgsCreateLabel(0, 90*py, 240*px, 20*py, formatMoney(v.coins).." "..donCurrencyName.."", false, donatorStoreGUI.image["cointrade:"..k], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["cointrade:"..k..":amount"], "center")
			
			donatorStoreGUI.label["cointrade:"..k..":pricetitle"] = dgsCreateLabel(0, 130*py, 240*px, 20*py,  "Prix:", false, donatorStoreGUI.image["cointrade:"..k], tocolor(100, 100, 100), 1.25*px, 1.25*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["cointrade:"..k..":pricetitle"], "center")
			
			donatorStoreGUI.image["cointrade:"..k..":cash"] = dgsCreateImage(15*px, 155*px, 32*px, 32*px, "files/icon_money.png", false, donatorStoreGUI.image["cointrade:"..k])
			donatorStoreGUI.label["cointrade:"..k..":cost"] = dgsCreateLabel(0, 160*py, 240*px, 20*py, "$"..formatMoney(v.cash).."", false, donatorStoreGUI.image["cointrade:"..k], tocolor(255, 255, 255), 1.5*px, 1.5*px)
			dgsLabelSetHorizontalAlign(donatorStoreGUI.label["cointrade:"..k..":cost"], "center")
			
			if getElementData(localPlayer, "account:id") == tonumber(v.accid) then
				donatorStoreGUI.button["cointrade:"..k..":remove"] = dgsCreateButton(55*px, 230*py, 140*px, 40*py, "Retirer", false, donatorStoreGUI.image["cointrade:"..k])
				dgsSetProperty(donatorStoreGUI.button["cointrade:"..k..":remove"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
				dgsSetProperty(donatorStoreGUI.button["cointrade:"..k..":remove"], "color",{tocolor(0, 255, 0, 100), tocolor(0, 255, 0, 150), tocolor(0, 255, 0, 120)})
				--dgsSetProperty(donatorStoreGUI.button["cointrade:"..k..":purchase"], "textColor",{tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255)})
				addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["cointrade:"..k..":remove"], function()
					triggerServerEvent("removeCoinTradeEvent", localPlayer, v.tradeid)
					
					openDonatorStoreGUI()
				end, false)
			else
				donatorStoreGUI.button["cointrade:"..k..":purchase"] = dgsCreateButton(55*px, 230*py, 140*px, 40*py, "Acheter", false, donatorStoreGUI.image["cointrade:"..k])
				dgsSetProperty(donatorStoreGUI.button["cointrade:"..k..":purchase"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
				dgsSetProperty(donatorStoreGUI.button["cointrade:"..k..":purchase"], "color",{tocolor(0, 255, 0, 100), tocolor(0, 255, 0, 150), tocolor(0, 255, 0, 120)})
				--dgsSetProperty(donatorStoreGUI.button["cointrade:"..k..":purchase"], "textColor",{tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255), tocolor(0, 0, 0, 255)})
				addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["cointrade:"..k..":purchase"], function()
					triggerServerEvent("purchaseCoinTradeEvent", localPlayer, v.tradeid, v.coins, v.cash, v.accid)
					
					openDonatorStoreGUI()
				end, false)
			end
					
			if left + 260*px > 1800*px then
				left = 0
				
				top = top + 310*py
			else
				left = left + 260*px
			end
		end
	else
		triggerServerEvent("getCoinTradesEvent", localPlayer)
	end
	
	donatorStoreGUI.button["sellcoins"] = dgsCreateButton(sx-(200*px)-230*px-45*px, sy-(100*py), 200*px, 65*py, "Vendre "..donCurrencyName.."", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.button["sellcoins"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["sellcoins"], function()
		postCoinTrade()
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
end

function receivedCoinTrades(newCoinTrades)
	coinTrades = newCoinTrades
	
	viewCoinTrades()
end
addEvent("receivedCoinTradesEvent", true)
addEventHandler("receivedCoinTradesEvent", root, receivedCoinTrades)

function postCoinTrade()
	clearStore()
	
	if donatorStoreGUI.image["people_logo"] and isElement(donatorStoreGUI.image["people_logo"]) then destroyElement(donatorStoreGUI.image["people_logo"]) end
	if donatorStoreGUI.image["header2"] and isElement(donatorStoreGUI.image["header2"]) then destroyElement(donatorStoreGUI.image["header2"]) end
	
	donatorStoreGUI.image["cointrade:post"] = dgsCreateImage(0, 0, 340*px, 400*py, "files/coinauction/postit.png", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.image["cointrade:post"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	dgsCenterElement(donatorStoreGUI.image["cointrade:post"])
	
	donatorStoreGUI.label["cointrade:tradetitle"] = dgsCreateLabel(5, 10*py, 240*px, 20*py, "Poster un Trade:", false, donatorStoreGUI.image["cointrade:post"], tocolor(255, 255, 255, 200), 1.75*px, 1.75*px)
	
	donatorStoreGUI.label["cointrade:amounttitle"] = dgsCreateLabel(5, 80*py, 240*px, 20*py, "Montant de "..donCurrencyName.." à vendre :", false, donatorStoreGUI.image["cointrade:post"], tocolor(255, 255, 255, 200), 1.5*px, 1.5*px)
	
	donatorStoreGUI.edit["cointrade:amountedit"] = dgsCreateEdit(5, 110*py, 325*px, 40*py, "", false, donatorStoreGUI.image["cointrade:post"])
	dgsEditSetTextFilter(donatorStoreGUI.edit["cointrade:amountedit"], "%D")
	
	donatorStoreGUI.label["cointrade:cashtitle"] = dgsCreateLabel(5, 180*py, 240*px, 20*py, "Prix de vente:", false, donatorStoreGUI.image["cointrade:post"], tocolor(255, 255, 255, 200), 1.5*px, 1.5*px)
	
	donatorStoreGUI.edit["cointrade:cashedit"] = dgsCreateEdit(5, 210*py, 325*px, 40*py, "", false, donatorStoreGUI.image["cointrade:post"])
	dgsEditSetTextFilter(donatorStoreGUI.edit["cointrade:amountedit"], "%D")
	
	donatorStoreGUI.button["cointrade:post"] = dgsCreateButton(55*px, 300*py, 240*px, 40*py, "Poster", false, donatorStoreGUI.image["cointrade:post"])
	dgsSetProperty(donatorStoreGUI.button["cointrade:post"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	dgsSetProperty(donatorStoreGUI.button["cointrade:post"], "color",{tocolor(0, 255, 0, 100), tocolor(0, 255, 0, 150), tocolor(0, 255, 0, 120)})
	addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["cointrade:post"], function()
		triggerServerEvent("postCoinTradeEvent", localPlayer, dgsGetText(donatorStoreGUI.edit["cointrade:amountedit"]), dgsGetText(donatorStoreGUI.edit["cointrade:cashedit"]))
		
		openDonatorStoreGUI()
	end, false)
	
	donatorStoreGUI.button["cancel"] = dgsCreateButton(sx-(200*px)-45*px, sy-(100*py), 200*px, 65*py, "Back", false, donatorStoreGUI.image["background"])
	dgsSetProperty(donatorStoreGUI.button["cancel"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	addEventHandler("onDgsMouseClickDown", donatorStoreGUI.button["cancel"], function()
		local tab = dgsGetSelectedTab(donatorStoreGUI.tabpanel["headertabpanel"])
		
		if tab == donatorStoreGUI.tab["refillgamecoins"] then
			coinTrades = false
			
			viewCoinTrades()
		end
	end, false)
end