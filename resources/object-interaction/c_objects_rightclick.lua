local debugModelOutput = false

function clickObject(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(localPlayer, "exclusiveGUI") then
		return
	end
	if getElementData(localPlayer, "inventoryManager.bagUIOpen") or getElementData(localPlayer, "inventoryManager.vehicleUIOpen") then
		return
	end
	if (element) and (getElementType(element)=="object" or getElementType(element)=="ped") and (button=="right") and (state=="down") then
		local x, y, z = getElementPosition(getLocalPlayer())
		local eX, eY, eZ = getElementPosition(element)
		local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(element)
		local addDistance = 0 --compensate for object size
		if minX then
			local boundingBoxBiggestDist = 0
			if minX > boundingBoxBiggestDist then
				boundingBoxBiggestDist = minX
			end
			if minY > boundingBoxBiggestDist then
				boundingBoxBiggestDist = minY
			end
			if maxX > boundingBoxBiggestDist then
				boundingBoxBiggestDist = maxX
			end
			if maxY > boundingBoxBiggestDist then
				boundingBoxBiggestDist = maxY
			end
			addDistance = boundingBoxBiggestDist
		end
		local maxDistance = 3 + addDistance
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=maxDistance) then
			local rcMenu
			local row = {}
			local model = getElementModel(element)

			if getElementType(element)=="object" then
				if getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then
					local itemID = tonumber(getElementData(element, "itemID")) or 0
					local itemValue = getElementData(element, "itemValue")
					local metadata = getElementData(element, "metadata") or {}
					local itemName = tostring(exports.global:getItemName(itemID, itemValue, metadata))

					if exports['item-world']:can(localPlayer, "use", element) then
						if not rcMenu then rcMenu = exports.rightclick:create(itemName) end
						--print(exports['item-system']:isStorageItem(itemID, itemValue), itemID, itemValue)
						if exports['item-system']:isStorageItem(itemID, itemValue) then -- Storage
							row.a = exports.rightclick:addrow("Inventaire")
							addEventHandler("onClientGUIClick", row.a,  function (button, state)
								if not getElementData ( localPlayer, "exclusiveGUI" ) then
									triggerServerEvent( "openFreakinInventory", getLocalPlayer(), element, absX, absY )
								end
							end, false)
						elseif itemID == 54 or itemID == 176 then -- Ghettoblaster
							row.a = exports.rightclick:addrow("Changer Radio")
							addEventHandler("onClientGUIClick", row.a,  function (button, state)
								triggerEvent("item:showMenu", getLocalPlayer(), element, absX, absY)
							end, false)
						elseif itemID == 96 then
							row.a = exports.rightclick:addrow("Utiliser")
							addEventHandler("onClientGUIClick", row.a,  function (button, state)
								triggerEvent("useCompItem", localPlayer)
								triggerServerEvent("computers:on", localPlayer)
							end, false)
						elseif(exports.sittablechairs:isSittableChair(element)) then
							if(exports.sittablechairs:canSitOnChair(element)) then
								row.a = exports.rightclick:addrow("S'assoir")
								addEventHandler("onClientGUIClick", row.a,  function (button, state)
									exports.sittablechairs:attemptToSitOnChair(element)
								end, false)
							end
						end
					end

					if exports['item-world']:can(localPlayer, "move", element) then
						if not rcMenu then rcMenu = exports.rightclick:create(itemName) end
						row.move = exports.rightclick:addrow("Déplacer")
						addEventHandler("onClientGUIClick", row.move,  function (button, state)
							triggerEvent("item:move", root, element)
						end, false)
					end
					if exports['item-world']:can(localPlayer, "pickup", element) then			
						if not rcMenu then rcMenu = exports.rightclick:create(itemName) end
						row.pickup = exports.rightclick:addrow("Ramasser")
						addEventHandler("onClientGUIClick", row.pickup,  function (button, state)
							if itemID ~= 223 and itemID ~= 103 then
								if exports.global:hasSpaceForItem(localPlayer, itemID, itemValue, metadata) then
									triggerServerEvent("pickupItem", getLocalPlayer(), element)
								else
									outputChatBox("Pas assez de place dans l'inventaire.", 255, 0, 0)
								end
							else
								areYouSure(element)
							end
						end, false)

						if (exports["item-system"]:getItemInfo(itemID) or {}).extendInventorySpace then
							row.inspect = exports.rightclick:addrow("Inspecter")

							addEventHandler("onClientGUIClick", row.inspect,  function (button, state)
								triggerEvent("inventoryManager.openInspectGUI", localPlayer, element)
							end, false);
						end


						--> If the item is the workbench (blackmarket), we can open the crafting menu
						if itemID == 366 then
							row.craft = exports.rightclick:addrow("Ouvrir le menu de craft")
							addEventHandler("onClientGUIClick", row.craft,  function (button, state)
								triggerServerEvent("onPlayerOpenCraftingMenu", localPlayer);
							end, false);
						end;

						--> If the item is the blender (drug system), we can open the corresponding menu
						if itemID == 380 then
							if getElementData(element, 'drugs:blender:ready') then
								row.pickup = exports.rightclick:addrow("Prendre le mélange");
								addEventHandler("onClientGUIClick", row.pickup,  function (button, state)
									triggerServerEvent("onPlayerTakeBlenderMix", localPlayer, element);
								end, false);
							else
								row.mix = exports.rightclick:addrow("Ouvrir le menu des mélanges");
								addEventHandler("onClientGUIClick", row.mix,  function (button, state)
									if getElementData(localPlayer, "inventory:opened") then
										return outputChatBox("[Drogue] Vous ne pouvez pas ouvrir le menu de craft en ayant l'inventaire ouvert.", 255, 0, 0);
									elseif getElementData(element, 'drugs:blender:in_use') then
										return outputChatBox("[Drogue] Le mixeur est en cours d'utilisation.", 255, 0, 0);
									else
										triggerServerEvent("onPlayerOpenMixMenu", localPlayer);
									end;
								end, false);
							end;
						end;

						--> If the item is the reactor (drug system)
						if itemID == 378 then
							if getElementData(element, 'drugs:reactor:attached') then
								if getElementData(localPlayer, 'drugs:player:is_holding_blend_mix') and not getElementData(element, 'drugs:reactor:have_blend_mix') then
									row.deposit = exports.rightclick:addrow("Déposer le mélange");
									addEventHandler("onClientGUIClick", row.deposit,  function (button, state)
										triggerServerEvent("onPlayerDepositMix", localPlayer, element);
									end, false);
								end;

								if getElementData(element, 'drugs:reactor:have_blend_mix') and not getElementData(element, 'drugs:reactor:is_finished') then
									row.config = exports.rightclick:addrow("Configurer le réacteur");
									addEventHandler("onClientGUIClick", row.config,  function (button, state)
										triggerServerEvent("onPlayerOpenReactorConfig", localPlayer, element);
									end, false);
								elseif getElementData(element, 'drugs:reactor:is_finished') then
									row.pickup = exports.rightclick:addrow("Prendre la drogue");
									addEventHandler("onClientGUIClick", row.pickup,  function (button, state)
										triggerServerEvent("onPlayerTakeReactorDrug", localPlayer, element, localPlayer);
									end, false);
								end;
							else
								row.attach = exports.rightclick:addrow("Attacher la pompe");
								addEventHandler("onClientGUIClick", row.attach,  function (button, state)
									triggerServerEvent("onPlayerAttachPump", localPlayer, element);
								end, false);
							end;
						end;

						if exports['item-system']:isStorageItem(itemID, itemValue) then -- Storage
							row.logs = exports.rightclick:addrow("Logs")
							addEventHandler("onClientGUIClick", row.logs,  function (button, state)
								triggerEvent("item-system.openStorageLogs", localPlayer, element, absX, absY)
							end, false)
						end
					end
					if exports['item-world']:canEditItemProperties(localPlayer, element) then
						if not rcMenu then rcMenu = exports.rightclick:create(itemName) end
						row.properties = exports.rightclick:addrow("Propriétés")
						addEventHandler("onClientGUIClick", row.properties,  function (button, state)
							triggerEvent("showItemProperties", localPlayer, element)
						end, false)
					end


					if exports.integration:isPlayerTrialAdmin(localPlayer, true) then
						-- TODO: Delete item

						local rowMapLine = exports.rightclick:addrow("Copier ligne Map")
						addEventHandler("onClientGUIClick", rowMapLine,  function (button, state)

							local customID = getElementData(element, "objectID")
							if customID then
								outputChatBox("Attention: cet objet n'existe pas dans le Map Editor normal (newmodel).", 255, 255, 0)
							end

							local model2 = customID or model
							local x,y,z = getElementPosition(element)
							local rx,ry,rz = getElementRotation(element)
							local int, dim = getElementInterior(element), getElementDimension(element)
							local doublesided = isElementDoubleSided(element)
							local scale = getObjectScale(element)
							local itemWorldId = tonumber(getElementData(element, "id"))
							local name = "objet:" .. (itemWorldId or "?")
							local line = '<object id="%s", breakable="false", interior="%d", alpha="255", dimension="%d", model="%d", scale="%d", doublesided="%s", collisions="true", posX="%f", posY="%f", posZ="%f", rotX="%f", rotY="%f", rotZ="%f"></object>'
							line = line:format(name, int, dim, model2, scale, (doublesided and "true" or "false"), x,y,z, rx,ry,rz)

							if setClipboard(line) then
								outputChatBox("Copié dans le presse-papier.", 0, 255, 0)
							else
								outputChatBox("Erreur: Impossible de copier dans le presse-papier.", 255, 0, 0)
							end
						end, false)
					end
				else


					if getElementData(element, "jetwasher") then
						if not rcMenu then rcMenu = exports.rightclick:create("Jet Wash") end
						local useB = exports.rightclick:addrow("Utiliser")
						addEventHandler("onClientGUIClick", useB,  function (button, state)
							triggerEvent("jetwash:use", localPlayer)
						end, false)
					elseif(exports.sittablechairs:isSittableChair(element)) then
						if(exports.sittablechairs:canSitOnChair(element)) then
							if not rcMenu then rcMenu = exports.rightclick:create("Chaise") end
							row.a = exports.rightclick:addrow("S'assoir")
							addEventHandler("onClientGUIClick", row.a,  function (button, state)
								exports.sittablechairs:attemptToSitOnChair(element)
							end, false)
						end
					end
				end

				if getElementData(element, "stretcher") then --Stretcher (ES)
					if not rcMenu then  rcMenu = exports.rightclick:create("Brancard") end
					row.a = exports.rightclick:addrow("Prendre")
					addEventHandler("onClientGUIClick", row.a,  function (button, state)
						triggerServerEvent("stretcher:takeStretcher", root, element)
					end, true)
				elseif(model == 962) then --Airport gate control box
					local airGateID = getElementData(element, "airport.gate.id")
					if airGateID then
						if not rcMenu then  rcMenu = exports.rightclick:create("Control Box") end
						row.a = exports.rightclick:addrow("Control Gate")
						addEventHandler("onClientGUIClick", row.a,  function (button, state)
							triggerEvent("airport-gates:controlGUI", getLocalPlayer(), element)
						end, false)
					end
				-- elseif(model == 1819) then --Airport fuel
				-- 	local airFuel = getElementData(element, "airport.fuel")
				-- 	if airFuel then
				-- 		outputDebugString("Air fuel: TODO")
				-- 	end
				else
					if debugModelOutput then
						lastDebugModelElement = element
						outputChatBox("Model ID "..tostring(model))
						outputChatBox("Breakable: "..tostring(isObjectBreakable(element)))
						--[[
						local mapsres = getResourceDynamicElementRoot(getResourceFromName("maps"))
						local objectParent = getElementParent(getElementParent(element))
						if getElementType(objectParent) == "resource" then
							if mapsres == objectParent then
								outputChatBox("From resource: maps")
							end
						end
						--]]
						local objectIdentity = getElementData(element, "id")
						if objectIdentity then
							outputChatBox("ID: "..tostring(objectIdentity))
						end
						--outputDebugString("parent type = "..tostring(getElementType(objectParent)))
						--if getElementType(objectParent) == "resource" then
							--local objectResourceName = tostring(getResourceName(getResourceRootElement(objectParent)))
							--outputChatBox("Parent: "..objectResourceName)
							--if objectResourceName == "maps" then
								local objectPosX, objectPosY, objectPosZ = getElementPosition(element)
								local objectRotX, objectRotY, objectRotZ = getElementRotation(element)
								local mapformat = '<object id="object" breakable="'..tostring(isObjectBreakable(element))..'" interior="'..tostring(getElementInterior(element))..'" alpha="'..tostring(getElementAlpha(element))..'" model="'..tostring(model)..'" doublesided="'..tostring(getElementData(element, "doublesided") and true)..'" scale="'..tostring(getObjectScale(element) or 0)..'" dimension="'..tostring(getElementDimension(element))..'" posX="'..tostring(objectPosX)..'" posY="'..tostring(objectPosY)..'" posZ="'..tostring(objectPosZ)..'" rotX="'..tostring(objectRotX)..'" rotY="'..tostring(objectRotY)..'" rotZ="'..tostring(objectRotZ)..'"></object>'
								outputConsole(mapformat)
							--end
						--end
					end
				end
			elseif getElementType(element) == "ped" then
				local corpseID = getElementData(element, "morgue.worldCorpseID")

				if corpseID then
					if getElementData(localPlayer, "morgue.isCarryingBodyBag") and not getElementData(localPlayer, "morgue.isCarryingBodyInABag") then
						if not rcMenu then  rcMenu = exports.rightclick:create("Corpse") end
						row.a = exports.rightclick:addrow("Ramasser le corps")
						addEventHandler("onClientGUIClick", row.a,  function (button, state)
							triggerServerEvent("client.morgue.onPlayerRequestTakeBody", localPlayer, corpseID)
						end)
					end

					if not rcMenu then  rcMenu = exports.rightclick:create("Corpse") end
					row.a = exports.rightclick:addrow("Voir informations")
					addEventHandler("onClientGUIClick", row.a,  function (button, state)
						triggerServerEvent("client.morgue.onPlayerRequestViewBodyInfo", localPlayer, corpseID)
					end)
				end

				if getElementData(element, "morgue.npc") then
					if getElementData(localPlayer, "morgue.isCarryingBodyInABag") then
						if not rcMenu then  rcMenu = exports.rightclick:create(getElementData(element, "name")) end
						row.a = exports.rightclick:addrow("Rendre le corps (+$" .. getElementData(element, "morgue.corpseHandOverPrice") .. ")")
						addEventHandler("onClientGUIClick", row.a,  function (button, state)
							if getElementData(localPlayer, "morgue.isCarryingBodyInABag") then
								triggerServerEvent("client.morgue.onPlayerRequestHandOverBodyToMorgue", localPlayer)
							end
						end)
					end

					if getElementData(element, "morgue.currentCorpse") then
						if not rcMenu then  rcMenu = exports.rightclick:create(getElementData(element, "name")) end
						row.a = exports.rightclick:addrow("Faire une autopsie")
						addEventHandler("onClientGUIClick", row.a,  function (button, state)
							if getElementData(element, "morgue.currentCorpse") then
								triggerServerEvent("client.morgue.onPlayerRequestPerformAutopsy", localPlayer)
							end
						end)
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickObject, true)

function areYouSure( element )
	local SCREEN_X, SCREEN_Y = guiGetScreenSize()
	local check = { }
	local width = 300 -- The width of our window
	local height = 140 -- The height of our window
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	check.window = guiCreateWindow( x, y, width, height, "Ramasser", false )

	check.message = guiCreateLabel( 10, 30, width - 20, 20, "Etes-vous sûr de vouloir ramasser ce contenaire?", false, check.window )
	check.this = guiCreateLabel(10, 50, width - 20, 30, "Cela va supprimer définitivement tous les items dans son inventaire!", false, check.window)
	guiLabelSetHorizontalAlign( check.this, "center", true)
	guiLabelSetHorizontalAlign( check.message, "center", true)

	check.closeButton = guiCreateButton( 10, 87, width / 2 - 15, 40, "Annuler", false, check.window )
	addEventHandler( "onClientGUIClick", check.closeButton,
		function ()
			destroyElement( check.window )
			check = { }
		end
	)

	check.deleteButton = guiCreateButton( width / 2 + 5, 87, width / 2 - 15, 40, "Continuer", false, check.window )
	guiSetProperty(check.deleteButton, "NormalTextColour", "FFFF0000")
	addEventHandler( "onClientGUIClick", check.deleteButton,
		function ()
			triggerServerEvent("pickupItem", getLocalPlayer(), element)
			destroyElement( check.window )
			check = { }
		end
	)
end

function debugToggleModelOutput(thePlayer, commandName)
	--if exports.integration:isPlayerScripter(thePlayer) then
		debugModelOutput = not debugModelOutput
		outputChatBox("DBG: ModelOutput set to "..tostring(debugModelOutput))
	--end
end
-- addCommandHandler("debugmodeloutput", debugToggleModelOutput)

function debugDeleteLastModel(thePlayer, commandName)
	if debugModelOutput then
		--if exports.integration:isPlayerScripter(thePlayer) then
		if exports.integration:isPlayerTrialAdmin(thePlayer) then
			if lastDebugModelElement then
				if isElement(lastDebugModelElement) then
					destroyElement(lastDebugModelElement)
				end
			end
			debugModelOutput = not debugModelOutput
			outputChatBox("DBG: ModelOutput set to "..tostring(debugModelOutput))
		end
	end
end
-- addCommandHandler("deletelastdebugmodel", debugDeleteLastModel)

addEventHandler("onClientObjectBreak", root,
	function()
		--local isBreakable = isObjectBreakable(source)
		--if not isBreakable then
			cancelEvent()
		--end
		--outputDebugString("object-interaction/c_objects_rightclick: Object breakable "..tostring(isBreakable))
	end
)
