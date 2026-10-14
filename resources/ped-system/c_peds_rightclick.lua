wPedRightClick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent=false

function clickPed(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(localPlayer, "exclusiveGUI") then
		return
	end
	if not element then
		local camX, camY, camZ = getCameraMatrix()
		local cursorX, cursorY, endX, endY, endZ = getCursorPosition()

		if not endX then return end -- Prevents a bug with inventory because the cursor is removed quickly.
		local x = {processLineOfSight(camX, camY, camZ, endX, endY, endZ, true, true, true, true, true, true, false, true, localPlayer, true)}
		local hit, _, _, _, _, _, _, _, mat, _, _, buildingId, bx, by, bz = unpack(x)
		if hit and isElement(buildingId) then
			element = buildingId
			outputDebugString("Used hack to get hidden element")
		end
	end
	if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") and (sent==false) and (element~=localPlayer) then
		rcMenu = false
		row = {}
		local interact = getElementData(element, "rpp.npc.type")
		local name = getElementData(element, "rpp.npc.name") or getElementData(element, "name") or "NPC"
		if (interact and interact ~= "false") then
			local x, y, z = getElementPosition(localPlayer)
			function table.find(t, v)
				--> Condition(s)
				if type(t) ~= 'table' then return false; end;

				--> Loop
				for k, v2 in pairs(t) do
					--> Condition(s)
					if v2 == v then return k; end;
				end;

				--> Return
				return false;
			end;
			if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
				if (wPedRightClick) then
					hidePedMenu()
				end

				ax = absX
				ay = absY
				player = element
				closing = false
				
				-- BLACKMARKET VENDOR
				if interact == 'blackmarket.vendor' then
					--> Variable(s)
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")

					--> Event
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						--> Variable(s)
						local factionsID = {};
						local factionsType = {};

						--> Loop(s)
						for k, v in pairs(getElementData(localPlayer, 'faction')) do table.insert(factionsID, k); end; --> Get the different factions ID of the player
						for k, v in pairs(factionsID) do table.insert(factionsType, exports.factions:getFactionType(v)); end; --> Get the faction type of the player

						--> Check if the player is currently in an illegal faction (type = 0, 1 or 10)
						if (table.find(factionsType, 0)) or (table.find(factionsType, 1)) or (table.find(factionsType, 10)) then
							--> Variable(s)
							local isLeader = exports.factions:hasMemberPermissionTo(localPlayer, factionsID[table.find(factionsType, 0)], 'add_member') or exports.factions:hasMemberPermissionTo(localPlayer, factionsID[table.find(factionsType, 1)], 'add_member') or exports.factions:hasMemberPermissionTo(localPlayer, factionsID[table.find(factionsType, 10)], 'add_member');
							local message = '';

							--> Check: If the player is the leader of the faction
							if isLeader then
								local factionID = factionsID[table.find(factionsType, 0)] or factionsID[table.find(factionsType, 1)] or factionsID[table.find(factionsType, 10)];
								return triggerServerEvent('onPlayerOpenBlackmarket', localPlayer, factionID, element);
								--triggerEvent('blackmarket:GUI:open', localPlayer, element, factionsID[table.find(factionsType, 0)]);
							else
								--> Set: Message
								message = "Écoute p'tit, j'parle qu'aux gros bras de chez toi. Maintenant dégage.";

								--> Return: Server Event
								return triggerServerEvent('makeBlackmarketNPCSpeak', localPlayer, element, message);
							end
						else
							--> Set: Message
							message = "Si tu veux pas d'ennuis, j'te conseille de dégager.";
 
							--> Return: Server Event
							return triggerServerEvent('makeBlackmarketNPCSpeak', localPlayer, element, message);
							--outputChatBox("Si tu veux pas d'ennuis, j'te conseille de dégager.", 255, 255, 255, true);
						end
					end, true)
				--DRUG BUYERS
				elseif interact=="drugaddict" then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("openCrackHeadTalkGUI", localPlayer, element)
					end, true)
					
				elseif interact=="edgydrugs" then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("openCrackHeadTalkGUI", localPlayer, element)
					end, true)
				elseif(interact == "lowlevelwepdealer") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("talkToDealerPed", localPlayer, localPlayer, element, 1)
					end, true)
				elseif(interact == "highlevelwepdealer") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("talkToDealerPed", localPlayer, localPlayer, element, 2)
					end, true)
				elseif(interact == "lowleveldrugdealer") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("talkToDealerPed", localPlayer, localPlayer, element, 1)
					end, true)
				elseif(interact == "highleveldrugdealer") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("talkToDealerPed", localPlayer, localPlayer, element, 2)
					end, true)
				elseif interact == "fishmonger" then	
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("showFishmongerGUI", localPlayer, element)
					end, true)
				elseif interact == "delivery:trader" then	
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("showDeliveryTraderGUI", localPlayer, element)
					end, true)
				elseif interact == "skinped" then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("skinupload:openGUI", localPlayer)
					end, true)
				elseif interact == "dirtymoney" then	
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("showDirtyMoneyGUI", localPlayer)
					end, true)
				--CITY HALL: RECEPTION (aka. Jessie Smith)
				elseif(interact == "ch.reception") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cityhall:jesped", localPlayer)
					end, true)

				--CITY HALL: JOB PINBOARD
				elseif(interact == "ch.jobboard") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onEmployment", localPlayer)
					end, true)

				--CITY HALL: LICENSE PLATES REGISTRATION
				elseif(interact == "ch.plates") then --City Hall: License plates registration
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cBeginPlate", localPlayer, element)
					end, true)

				--CITY HALL: BUSINESS REGISTRY
				-- elseif(interact == "ch.bizreg") then
				-- 	rcMenu = exports.rightclick:create(name)
				-- 	row.talk = exports.rightclick:addrow("Parler")
				-- 	addEventHandler("onClientGUIClick", row.talk,  function (button, state)
				-- 		triggerEvent("onRegistryPed", localPlayer)
				-- 	end, true)

				--CITY HALL: POLITICAL PARTY REGISTRY
				elseif(interact == "ch.politics") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("onPoliticsPed", element)
					end, true)

				--BANK: Banking ped
				elseif(interact == "bank.banking") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("bank:showGeneralServiceGUI", localPlayer, element)
					end, true)

				--BANK: ATM cards ped
				elseif(interact == "bank.cards") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("bank-system:bankerInteraction", localPlayer, element)
					end, true)

				-- PD: Citations
				elseif(interact == "pd.tickets") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("fetchTickets", localPlayer, ped)
					end, true)

				--FUEL STATION PED
				elseif(interact == "fuel") then --Fuel station ped
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("fuel:startConvo", element)
					end, true)

				--TOLL BOOTH PED
				elseif(interact == "toll") then --Toll booth ped
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("toll:startConvo", element)
					end, true)

				--SAN RECEPTION PED
				elseif(interact == "san.reception") then --SAN reception ped
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("toll:startConvo", element)
					end, true)


				--MISSION: STEVEN PULLMAN
				elseif(interact == "mission.pullman") then --Mission: Steven Pullman
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startStevieConvo", localPlayer)
						if (getElementData(element, "activeConvo")~=1) then
							triggerEvent ( "stevieIntroEvent", localPlayer) -- Trigger Client side function to create GUI.
						end
					end, true)
				--MISSION: HUNTER
				elseif(interact == "mission.hunter") then --Mission: Hunter
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startHunterConvo", localPlayer)
					end, true)
				--MISSION: ROOK
				elseif(interact == "mission.rook") then --Mission: Rook
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startRookConvo", localPlayer)
					end, true)


				--DMV: GET DRIVERS LICENSE
				elseif(interact == "dmv.license") then --DMV: Get drivers license
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onLicense", localPlayer, element)
					end, true)

				--DMV: LICENSE PLATES REGISTRATION
				elseif(interact == "dmv.plates") then --City Hall: License plates registration
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cBeginPlate", localPlayer, element)
					end, true)

				--ELECTION PED
				elseif(interact == "election") then --Election ped
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Voter")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("electionWantVote", localPlayer)
					end, true)

				--IMPOUND LOT PED
				elseif(interact == "impound") then --Impound lot ped
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("onTowMisterTalk", localPlayer)
					end, true)

				--FAA: Theory Exams
				elseif(interact == "faa.theory") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onLicense", localPlayer, element)
					end, true)

				--CITY HALL: GUARD
				elseif(interact == "ch.guard") then --City Hall: guard
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("gateCityHall", localPlayer)
					end, true)

				--GATEANGBASE (AIRMAN CONNOR)
				elseif(interact == "gateangbase") then --gateangbase (Airman Connor)
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("gateAngBase", localPlayer)
					end, true)

				--SFES RECEPTION PED
				elseif(interact == "sfes.reception") then --SFES: reception ped
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("lses:popupPedMenu", localPlayer, element)
					end, true)

				--ES HOSPITAL FRONT DESK
				elseif(interact == "hospital.frontdesk") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("lses:ped:hospitalfrontdesk", localPlayer, element)
					end, true)

				--Prison arrival
				elseif(interact == "prison.arrival") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("prison:prisonPedArrival", localPlayer, element)
					end, true)

				--Prison release
				elseif(interact == "prison.release") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("prison:prisonPedRelease", localPlayer, element)
					end, true)

				--MISSION: CLARICE
				elseif(interact == "mission.clarice") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startClariceConvo", localPlayer)
					end, true)
					row.util = exports.rightclick:addrow("WooHoo_clarice")
					addEventHandler("onClientGUIClick", row.util,  function (button, state)
						local x,y,z = getElementPosition(element)
						local player = localPlayer
						setElementPosition(player, x, y, z)
						--setElementRotation(player, 266, 0, 0)
						setPedAnimation(element, "SEX", "SEX_1_Cum_W", -1, false, false)
						setPedAnimation(player, "SEX", "SEX_1_Cum_P", -1, false, false)
						setTimer(setPedAnimation, 7000, 1, player)
						setTimer(setPedAnimation, 7200, 1, element, "BEACH", "bather")
					end, true)

				--MISSION: CONSTRUCTION SITE JOB
				elseif(interact == "constructionwork") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onConstructionJobPed", localPlayer, element)
					end, true)

				--CHRISTMAS: SANTA
				elseif(interact == "santa") then
					rcMenu = exports.rightclick:create(name)
					row.get = exports.rightclick:addrow("Get Coke")
					addEventHandler("onClientGUIClick", row.get,  function (button, state)
						triggerServerEvent("xmas:santaGetCoke", localPlayer, element)
					end, true)
					if exports.global:hasItem(localPlayer, 211) then --has christmas lottery ticket
						row.claim = exports.rightclick:addrow("Claim Prize")
						addEventHandler("onClientGUIClick", row.claim,  function (button, state)
							triggerServerEvent("xmas:useChristmasLotteryTicket", localPlayer, element)
						end, true)
					end

				--ELECTIONS: Ped for vote GUI (anumaz)
				elseif(interact == "electionsped") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("elections:votegui", localPlayer)
					end, true)

				--SFIA: Pilot mission (anumaz)
				elseif(interact == "pilotmission") then
					rcMenu = exports.rightclick:create(name)
					row.getlisting = exports.rightclick:addrow("Get listing")
					addEventHandler("onClientGUIClick", row.getlisting, function ()
							triggerEvent("pilotmission:startGUI", getResourceRootElement( getResourceFromName("sfia") ))
						end, false)
					local temp_table = getElementData(getResourceRootElement( getResourceFromName("sfia") ), "sfia_pilots:table")
					local name = string.gsub(getPlayerName(localPlayer), "_", " ")
					for k, v in pairs(temp_table) do
						if v["charactername"] == name then
							row.gettask = exports.rightclick:addrow("Get task")
							addEventHandler("onClientGUIClick", row.gettask, function ()
									triggerEvent("pilotmission:domission", getResourceRootElement( getResourceFromName("sfia") ))
								end, false)
							break
						end
					end

				--K9 dog
				elseif(interact == "k9") then
					rcMenu = exports.rightclick:create(getElementData(element, "rpp.npc.name") or "Dog")
					if getElementData(element, "besitzer") == getPlayerName(localPlayer) then
						row.talk = exports.rightclick:addrow("Status")
						addEventHandler("onClientGUIClick", row.talk,  function (button, state)
							local currentStatus = getElementData(element, "k9:status")
							if currentStatus == 1 then
								setElementData(element, "k9:status", 0)
							elseif currentStatus == 0 then
								setElementData(element, "k9:status", 1)
							else
								setElementData(element, "k9:status", 1)
							end
						end, true)
					end

				--Locksmith
				elseif(interact == "locksmith") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("locksmithGUI", localPlayer, localPlayer)
					end, true)

				--FAA RECEPTION PED
				elseif(interact == "faa.reception") then --FAA: reception ped
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("airport:ped:receptionistFAA", localPlayer, element)
					end, true)

				--FAA: Gatekeeper LSA
				elseif(interact == "faa.gatekeeper.lsa") then --FAA: Gatekeeper LSA
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("airport:ped:LSAgatekeeper", localPlayer, element)
					end, true)

				--FAA: VMAT spawning
				elseif(interact == "faa.vmat") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Parler")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("airport:ped:vmat", localPlayer, element)
					end, true)
				--Easter event
				--[[elseif(interact == "easter") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Exchange Eggs")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("easter:exchange", localPlayer, element)
					end, true)
					row.redeem = exports.rightclick:addrow("Redeem prize")
					addEventHandler("onClientGUIClick", row.redeem,  function (button, state)
						triggerServerEvent("easter:redeem", localPlayer, element)
					end, true)]]
				--BMX event
				--[[elseif(interact == "bmxevent") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Participate")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("bmx:join", localPlayer, element)
					end, true)
					row.queue = exports.rightclick:addrow("Get queue")
					addEventHandler("onClientGUIClick", row.queue,  function (button, state)
						triggerServerEvent("bmx:queue", localPlayer, element)
					end, true)
					row.spectate = exports.rightclick:addrow("Spectate")
					addEventHandler("onClientGUIClick", row.spectate,  function (button, state)
						triggerServerEvent("bmx:spectate", localPlayer, element)
					end, true)]]
				elseif string.find(interact, "paintball") then
					rcMenu = exports.rightclick:create(name)
					if (interact == "paintball.feedback") then
						row.talk = exports.rightclick:addrow("Feedback")
						addEventHandler("onClientGUIClick", row.talk,  function (button, state)
							triggerServerEvent("event:getFeedbackGUI", localPlayer)
						end, true)
					elseif (interact == "paintball.leaderboard") then
						row.talk = exports.rightclick:addrow("Leaderboard")
						addEventHandler("onClientGUIClick", row.talk,  function (button, state)
							triggerServerEvent("event:getLeaderboardGUI", localPlayer)
						end, true)
					else
						row.talk = exports.rightclick:addrow("Participer ($50)")
						addEventHandler("onClientGUIClick", row.talk,  function (button, state)
							triggerServerEvent("event:getPaintballGUI", localPlayer, interact)
						end, true)
					end
				--Cargo Group generic item spawn
				-- elseif(interact == "cargo.generics") then
				-- 	if getElementData(localPlayer, "loggedin") == 1 then
				-- 		local allowedFactions = {
				-- 			-- [147] = true, -- Dinoco
				-- 			-- [212] = true, -- Sparta Inc.
				-- 			-- [159] = true, -- Western Solutions LLC.
				-- 		}
				-- 		local factionID = exports.factions:getCurrentFactionDuty(localPlayer) or 0
				-- 		if (allowedFactions[factionID]) then
				-- 			local isLeader = exports.factions:hasMemberPermissionTo(localPlayer, factionID, "add_member")
				-- 			if isLeader then
				-- 				rcMenu = exports.rightclick:create(name)
				-- 				row.talk = exports.rightclick:addrow("Parler")
				-- 				addEventHandler("onClientGUIClick", row.talk,  function (button, state)
				-- 					triggerEvent("createCargoGUI", localPlayer)
				-- 				end, true)
				-- 			end
				-- 		end
				-- 	end
				--Shipping Order
				elseif(interact == "cargo.shippingorder") then
					rcMenu = exports.rightclick:create(name)
					row.talk = exports.rightclick:addrow("Shipping orders")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cargo:shippingOrderGUI", localPlayer, element)
					end, true)

				end --all elseif's for interact types goes overneath this line

				--STRETCHER SYSTEM
				local stretcherElement = getElementData(localPlayer, "realism:stretcher:hasStretcher")
				if stretcherElement then
					local stretcherPlayer =  getElementData( stretcherElement, "realism:stretcher:playerOnIt" )
					if stretcherPlayer and stretcherPlayer == element then
						if not rcMenu then
							rcMenu = exports.rightclick:create(name)
						end
						row.stretcher = exports.rightclick:addrow("Retirer du brancard")
						addEventHandler("onClientGUIClick", row.stretcher, function (button, state)
							triggerServerEvent("stretcher:takePedFromStretcher", localPlayer, element)
						end, false)
					end
					if not stretcherPlayer then
						if not rcMenu then
							rcMenu = exports.rightclick:create(name)
						end
						row.stretcher = exports.rightclick:addrow("Allonger sur le brancard")
						addEventHandler("onClientGUIClick", row.stretcher, function (button, state)
							triggerServerEvent("stretcher:movePedOntoStretcher", localPlayer, element)
						end, false)
					end
				end


				--HEAL SYSTEM
				if(getElementHealth(element) < 50) then
					if exports.factions:isInFactionType(localPlayer, 4) then --if player is in ES faction and has a first aid kit
						if not rcMenu then
							rcMenu = exports.rightclick:create(name)
						end
						row.heal = exports.rightclick:addrow("Heal")
						addEventHandler("onClientGUIClick", row.heal, function (button, state)
							triggerServerEvent("peds:healPed", localPlayer, localPlayer, element)
						end, false)
					end
				end
			end
		else --if not interact

		end

		--ADMIN CMDS
		if (getElementData(element, "rpp.npc.dbid")) then
			if exports.integration:isPlayerLeadAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer) then
				--outputDebugString("spawnposdata: "..tostring(getElementData(element, "rpp.npc.spawnpos")))
				--if(getElementData(element, "rpp.npc.spawnpos")) then
					if not rcMenu then
						rcMenu = exports.rightclick:create(name)
					end
					--if getElementData(element, "dbid") then
						row.admEdit = exports.rightclick:addrow("ADM: Edit")
						addEventHandler("onClientGUIClick", row.admEdit, function (button, state)
							adminEditPedGui(element)
						end, false)
					--end

					row.respawn = exports.rightclick:addrow("ADM: Respawn")
					addEventHandler("onClientGUIClick", row.respawn, function (button, state)
						triggerServerEvent("peds:respawnPed", localPlayer, localPlayer, element)
					end, false)
				--end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPed, true)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil

	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedRightClick)) then
		destroyElement(wPedRightClick)
	end
	wPedRightClick = nil

	rcMenu = nil
	row = nil

	ax = nil
	ay = nil
	sent=false
	--showCursor(false)

end
