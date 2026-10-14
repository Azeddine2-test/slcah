--BANKING APP START
function phoneAppBanking()	
	setupPhoneApp ("banking")
	
	phoneGUI.image["bankingicon"] = dgsCreateImage(0, 100, 512/4, 256/4, "files/icons/banking.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["bankingicon"], false, true)
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 170, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
	
	phoneGUI.label["balance"] = dgsCreateLabel(10, 180, 167, 10, personalBalanceText, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["balance"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["balance"], phoneBoldFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["balance"], "center")
	dgsCenterElement(phoneGUI.label["balance"], false, true)
	
	phoneGUI.label["balanceamount"] = dgsCreateLabel(10, 200, 167, 10, ""..currencyText..""..exports["global"]:formatMoney(tonumber(getElementData(localPlayer, "bankmoney"))).."", false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["balanceamount"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["balanceamount"], phoneBoldFont)
	dgsLabelSetHorizontalAlign(phoneGUI.label["balanceamount"], "center")
	dgsCenterElement(phoneGUI.label["balanceamount"], false, true)
	
	phoneGUI.image["seperator"] = dgsCreateImage(10, 405, 369*scaleRatio, 5*scaleRatio, "files/seperator.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,100))
	dgsCenterElement(phoneGUI.image["seperator"], false, true)
end
--BANKING APP END