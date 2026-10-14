timeTimers = {}

loadstring(exports.dgs:dgsImportFunction())()

dgsAddStyle("donshop", "style/donshop", donshop)

dgsSetStyle("donshop", donshop)

sx, sy = guiGetScreenSize()
px, py = sx/1920, sy/1080

donatorStoreGUI = {
	window = {},
	image = {},
	button = {},
	tabpanel = {},
	tab = {},
	label = {},
	line = {},
	scrollpane = {},
	browser = {},
	edit = {},
}

function closeStore()
	coinTrades = false
	
	showCursor(false)
	showChat(true)
	
	if donatorStoreGUI.image["background"] and isElement(donatorStoreGUI.image["background"]) then destroyElement(donatorStoreGUI.image["background"]) end
end

function clearStore()
	for k, v in pairs(timeTimers) do
		if isTimer(v) then
			killTimer(v)
			timeTimers[k] = nil
		end
	end
	
	if donatorStoreGUI.scrollpane["shop"] and isElement(donatorStoreGUI.scrollpane["shop"]) then destroyElement(donatorStoreGUI.scrollpane["shop"]) end
	if donatorStoreGUI.browser["main"] and isElement(donatorStoreGUI.browser["main"]) then destroyElement(donatorStoreGUI.browser["main"]) end
	
	if donatorStoreGUI.image["header3"] and isElement(donatorStoreGUI.image["header3"]) then destroyElement(donatorStoreGUI.image["header3"]) end
	if donatorStoreGUI.image["viewvip"] and isElement(donatorStoreGUI.image["viewvip"]) then destroyElement(donatorStoreGUI.image["viewvip"]) end
	if donatorStoreGUI.image["cointrade:post"] and isElement(donatorStoreGUI.image["cointrade:post"]) then destroyElement(donatorStoreGUI.image["cointrade:post"]) end
	if donatorStoreGUI.scrollpane["viewvip"] and isElement(donatorStoreGUI.scrollpane["viewvip"]) then destroyElement(donatorStoreGUI.scrollpane["viewvip"]) end
	if donatorStoreGUI.button["buyitem"] and isElement(donatorStoreGUI.button["buyitem"]) then destroyElement(donatorStoreGUI.button["buyitem"]) end
	if donatorStoreGUI.button["buyvehicle"] and isElement(donatorStoreGUI.button["buyvehicle"]) then destroyElement(donatorStoreGUI.button["buyvehicle"]) end
	if donatorStoreGUI.button["buyperk"] and isElement(donatorStoreGUI.button["buyperk"]) then destroyElement(donatorStoreGUI.button["buyperk"]) end
	if donatorStoreGUI.button["cancel"] and isElement(donatorStoreGUI.button["cancel"]) then destroyElement(donatorStoreGUI.button["cancel"]) end
	if donatorStoreGUI.button["testdrive"] and isElement(donatorStoreGUI.button["testdrive"]) then destroyElement(donatorStoreGUI.button["testdrive"]) end
	if donatorStoreGUI.button["tradecoins"] and isElement(donatorStoreGUI.button["tradecoins"]) then destroyElement(donatorStoreGUI.button["tradecoins"]) end
	if donatorStoreGUI.button["sellcoins"] and isElement(donatorStoreGUI.button["sellcoins"]) then destroyElement(donatorStoreGUI.button["sellcoins"]) end
	if donatorStoreGUI.label["refillcoinsinfo"] and isElement(donatorStoreGUI.label["refillcoinsinfo"]) then destroyElement(donatorStoreGUI.label["refillcoinsinfo"]) end
	
	return true
end

function setupPage(pageType)
	clearStore()
	
	-- CHANGE IMAGES
	if donatorStoreGUI.image["background"] and isElement(donatorStoreGUI.image["background"]) then
		dgsImageSetImage(donatorStoreGUI.image["background"], dxCreateTexture("files/"..pageType.."/background.png"))
	else
		donatorStoreGUI.image["background"] = dgsCreateImage(0, 0, sx, sy, "files/home/background.png", false)
	end
	
	if donatorStoreGUI.image["people_logo"] and isElement(donatorStoreGUI.image["people_logo"]) then
		dgsImageSetImage(donatorStoreGUI.image["people_logo"], dxCreateTexture("files/"..pageType.."/people_logo.png"))
	else
		donatorStoreGUI.image["people_logo"] = dgsCreateImage((sx-996*px), (sy-636*py), 996*px, 636*py, "files/"..pageType.."/people_logo.png", false, donatorStoreGUI.image["background"])
		dgsSetEnabled(donatorStoreGUI.image["people_logo"], false)
	end
	
	if donatorStoreGUI.image["header2"] and isElement(donatorStoreGUI.image["header2"]) then
		dgsImageSetImage(donatorStoreGUI.image["header2"], dxCreateTexture("files/"..pageType.."/news.png"))
	else
		donatorStoreGUI.image["header2"] = dgsCreateImage(1105*px, 250*py, 770*px, 134*py, "files/home/news.png", false, donatorStoreGUI.image["background"])
		dgsSetProperty(donatorStoreGUI.image["header2"], "outline",{"in",2,tocolor(255, 255, 255),false,false,false,true})
	end
	
	return true
end

function viewItemFuncton(itemID)
	if itemID and VIPShopItems[itemID] and VIPShopItems[itemID].itemType then
		if VIPShopItems[itemID].itemType == 1 then
			viewVIPVehicle(itemID)
		elseif VIPShopItems[itemID].itemType == 2 then
			viewVIPItem(itemID)
		elseif VIPShopItems[itemID].itemType == 3 then
			viewVIPPerk(itemID)
		end	
	end
end