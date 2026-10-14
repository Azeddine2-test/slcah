local talkToPed = nil

DGS = exports["dgs"]

crackheadTalk = {
    button = {},
    window = {},
    label = {},
}

local screenW, screenH = DGS:dgsGetScreenSize()

function openCrackHeadTalkGUI(crackhead)
	if crackhead then
		if getPedOccupiedVehicle(localPlayer) then
			outputChatBox("Vous ne pouvez pas parler à un crackhead depuis votre véhicule.", 255, 0, 0)
			return
		end
		talkToPed = crackhead
		--play animation and face towards 
		triggerServerEvent("playTalkCrackheadAnimation", localPlayer, localPlayer, crackhead)
		
		if not crackheadTalk.window[1] then
			showCursor(true)
			
			crackheadTalk.window[1] = DGS:dgsCreateWindow((screenW - 286) / 2, (screenH - 100) / 2, 286, 160, "Crackhead dit:", false)
			DGS:dgsWindowSetCloseButtonEnabled(crackheadTalk.window[1], false)
			DGS:dgsWindowSetSizable(crackheadTalk.window[1], false)
			
			if getElementData(crackhead, "gotdrugs") then
				drugAskText = "* Le crackhead parait incohérent *"
				
				crackheadTalk.label["crackheadsays"] = DGS:dgsCreateLabel(5, 50, 276, 30, drugAskText, false, crackheadTalk.window[1])
				DGS:dgsSetProperty(crackheadTalk.label["crackheadsays"], "textColor", tocolor(255, 255, 255))
				DGS:dgsSetProperty(crackheadTalk.label["crackheadsays"], "wordBreak", true)
				DGS:dgsLabelSetHorizontalAlign(crackheadTalk.label["crackheadsays"], "center")
								
				crackheadTalk.button[1] = DGS:dgsCreateButton(70, 100, 147, 29, "Fermer", false, crackheadTalk.window[1])   
				addEventHandler("onDgsMouseClickDown", crackheadTalk.button[1], function()
					if source == crackheadTalk.button[1] then
						showCursor(false)
			
						DGS:dgsCloseWindow(crackheadTalk.window[1]) 
						crackheadTalk.window[1] = nil
					end
				end
				)
			else
				local addictType = getElementData(crackhead, "addictType")
				local drugID = tonumber(getElementData(crackhead, "drugtype"))
				local drugAmount = tonumber(getElementData(crackhead, "drugamount"))
				
				if addictType then
					if drugIDs[addictType][drugID].name == "Ecstasy Pill" or drugIDs[addictType][drugID].name == "Ecstasy Pills" then
						gramOrGrams = ""
					elseif drugAmount > 1 then
						gramOrGrams = " grammes de"
					else
						gramOrGrams = " gramme de"
					end
					
					drugAskText = "Hey.. Tu aurais "..drugAmount..""..gramOrGrams.." "..drugIDs[addictType][drugID].name.."?\n J'ai ce qu'il faut... $"..drugIDs[addictType][drugID].price * drugAmount..", c'est ça?"
					
					crackheadTalk.label["crackheadsays"] = DGS:dgsCreateLabel(5, 10, 276, 30, drugAskText, false, crackheadTalk.window[1])
					DGS:dgsSetProperty(crackheadTalk.label["crackheadsays"], "textColor", tocolor(255, 255, 255))
					DGS:dgsSetProperty(crackheadTalk.label["crackheadsays"], "wordBreak", true)
					DGS:dgsLabelSetHorizontalAlign(crackheadTalk.label["crackheadsays"], "center")
					
					crackheadTalk.button[2] = DGS:dgsCreateButton(70, 60, 147, 29, "Oui, j'ai", false, crackheadTalk.window[1])   
					addEventHandler("onDgsMouseClickDown", crackheadTalk.button[2], function()
						if source == crackheadTalk.button[2] then
							triggerServerEvent("sellDrugsToCrackhead", localPlayer, localPlayer, crackhead, drugID, drugAmount)
							showCursor(false)
				
							DGS:dgsCloseWindow(crackheadTalk.window[1]) 
							crackheadTalk.window[1] = nil
							executeCommandHandler("togglecursor")
							
							talkToPed = nil
						end
					end
					)
					DGS:dgsSetEnabled(crackheadTalk.button[2], false)
					
					if exports["item-system"]:hasItem(localPlayer, drugIDs[addictType][drugID].itemID, tonumber(drugAmount)) then
						DGS:dgsSetEnabled(crackheadTalk.button[2], true)
					end
				end
				
				crackheadTalk.button[1] = DGS:dgsCreateButton(70, 100, 147, 29, "Fermer", false, crackheadTalk.window[1])   
				addEventHandler("onDgsMouseClickDown", crackheadTalk.button[1], function()
					if source == crackheadTalk.button[1] then
						showCursor(false)
			
						DGS:dgsCloseWindow(crackheadTalk.window[1]) 
						crackheadTalk.window[1] = nil
						executeCommandHandler("togglecursor")
						
						talkToPed = nil
					end
				end
				)
			end
		end
	end
end
addEvent("openCrackHeadTalkGUI", true)
addEventHandler("openCrackHeadTalkGUI", root, openCrackHeadTalkGUI)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "ped" and talkToPed and talkToPed == source then
		if crackheadTalk.window[1] then
			showCursor(false)
				
			DGS:dgsCloseWindow(crackheadTalk.window[1]) 
			crackheadTalk.window[1] = nil
			executeCommandHandler("togglecursor")
			
			talkToPed = nil
		end
	end
end)