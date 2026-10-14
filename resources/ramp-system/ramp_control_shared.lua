-- If you are using this script for a vG/Owl server, you may want to use this by enabling it as "true", and setting an item ID below. 
-- This gives the creating admin a remote control that they can give to the player, or they can spawn another etc.
-- If this setting is disabled as "false", you will need to stand next to the control on the lift post and press "E", this will open the lift prompt.

useVGItem = true
VGItemID = 151

--[[
	Add the following function under function useItem() in item-system/c_item_system.lua
	
	elseif (itemID==VGItemID) then --(Change the VGItemID to the Item ID)
		triggerEvent("liftControlGUI", localPlayer, itemValue, true)
		hideInventory()
		return
]]

-- This is whether to output the "playerAMe" event in roleplay servers, in order to output aMe's for actions.
useAmeEvent = true