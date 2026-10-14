
local stepCount = 0
addEventHandler("onClientPedStep", localPlayer,
 function(leftFoot)
	if source == localPlayer then
		stepCount = stepCount + 1
		if isElement(phoneGUI.label["stepslabel"]) then
			dgsSetText(phoneGUI.label["stepslabel"], exports["global"]:formatMoney(stepCount).. " Steps")
		end
	end
 end
)

--HEALTH APP START
function phoneAppHealth()
	setupPhoneApp("health")

	phoneGUI.label["titlelabel"] = dgsCreateLabel(20*scaleRatio, 125*scaleRatio, dxGetTextWidth(healthTitleText, 0.8, phoneBigBoldFont), 10, healthTitleText, false, phoneGUI.image["phonewallpaper"], false, 0.8, 0.8)
	dgsSetProperty(phoneGUI.label["titlelabel"], "textColor", pageTitleColor)
	dgsSetFont(phoneGUI.label["titlelabel"], phoneBigBoldFont)
	
	local healthOffset = 40
	phoneGUI.image["hpicon"] = dgsCreateImage(0, 70+healthOffset, 67, 67, "files/icons/hp.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["hpicon"], false, true)
	
	phoneGUI.label["hplabel"] = dgsCreateLabel(10, 135+healthOffset, dxGetTextWidth(hitpointsText, 1, phoneBoldFont), 10, hitpointsText, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["hplabel"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["hplabel"], phoneBoldFont)
	dgsCenterElement(phoneGUI.label["hplabel"], false, true)
	
	phoneGUI.label["currenthplabel"] = dgsCreateLabel(10, 155+healthOffset, dxGetTextWidth(math.floor(getElementHealth(localPlayer)), 1, phoneBigBoldFont), 10, math.floor(getElementHealth(localPlayer)), false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["currenthplabel"], "textColor", tocolor(100, 100, 100))
	dgsSetFont(phoneGUI.label["currenthplabel"], phoneBigBoldFont)
	dgsCenterElement(phoneGUI.label["currenthplabel"], false, true)
	
	phoneGUI.image["armoricon"] = dgsCreateImage(0, 190+healthOffset, 67, 67, "files/icons/armor.png", false, phoneGUI.image["phonewallpaper"], tocolor(255,255,255,255))
	dgsCenterElement(phoneGUI.image["armoricon"], false, true)
	
	phoneGUI.label["armorlabel"] = dgsCreateLabel(10, 260+healthOffset, dxGetTextWidth(armorText, 1, phoneBoldFont), 10, armorText, false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["armorlabel"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["armorlabel"], phoneBoldFont)
	dgsCenterElement(phoneGUI.label["armorlabel"], false, true)
	
	phoneGUI.label["currentarmorlabel"] = dgsCreateLabel(10, 280+healthOffset, dxGetTextWidth(getPedArmor(localPlayer), 1, phoneBigBoldFont), 10, getPedArmor(localPlayer), false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["currentarmorlabel"], "textColor", tocolor(100, 100, 100))
	dgsSetFont(phoneGUI.label["currentarmorlabel"], phoneBigBoldFont)
	dgsCenterElement(phoneGUI.label["currentarmorlabel"], false, true)
	
	phoneGUI.label["stepslabel"] = dgsCreateLabel(10, 330+healthOffset, dxGetTextWidth(exports["global"]:formatMoney(stepCount).. " Steps", 1, phoneBoldFont), 10, exports["global"]:formatMoney(stepCount).. " Steps", false, phoneGUI.image["phonewallpaper"])
	dgsSetProperty(phoneGUI.label["stepslabel"], "textColor", tocolor(255, 255, 255))
	dgsSetFont(phoneGUI.label["stepslabel"], phoneBoldFont)
	dgsCenterElement(phoneGUI.label["stepslabel"], false, true)
end
--HEALTH APP END