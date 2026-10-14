function table.random ( theTable )
    return theTable[math.random ( #theTable )]
end

function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

local minItems = 1
local maxItems = 10

weaponDealerItems = {
	["lowlevelwepdealer"] = {
		{name = "Colt 45", itemID = 115, itemValue=22, price = 500},
		{name = "Colt 45 Magazine", itemID = 116, itemValue="22:17", price = 100},
		{name = "TEC 9", itemID = 115, itemValue=32, price = 1800},
		{name = "TEC 9 Magazine", itemID = 116, itemValue="32:30", price = 250},
		{name = "UZI", itemID = 115, itemValue=28, price = 1700},
		{name = "UZI Magazine", itemID = 116, itemValue="28:30", price = 225},
		{name = "Pump Shotgun", itemID = 115, itemValue=25, price = 900},
		{name = "Pump Shotgun Cartridges", itemID = 116, itemValue="25:6", price = 80},
		{name = "Sawn Off Shotgun", itemID = 115, itemValue=26, price = 780},
		{name = "Sawn Off Shotgun Cartridges", itemID = 116, itemValue="26:2", price = 50},
		{name = "Country Rifle", itemID = 115, itemValue=33, price = 1500},
		{name = "Country Rifle Magazine", itemID = 116, itemValue="33:6", price = 150},
	},
	["highlevelwepdealer"] = {
		{name = "Deagle", itemID = 115, itemValue=24, price = 1500},
		{name = "Deagle Magazine", itemID = 116, itemValue="24:7", price = 300},
		{name = "Suppressed Pistol", itemID = 115, itemValue=23, price = 2500},
		{name = "Suppressed Pistol Magazine", itemID = 116, itemValue="23:17", price = 500},
		{name = "SPAS-12", itemID = 115, itemValue=27, price = 14500},
		{name = "SPAS-12 Cartridges", itemID = 116, itemValue="27:6", price = 1300},
		{name = "MP5", itemID = 115, itemValue=28, price = 6500},
		{name = "MP5 Magazine", itemID = 116, itemValue="28:30", price = 1050},
		{name = "AK-47", itemID = 115, itemValue=30, price = 7500},
		{name = "AK-47 Magazine", itemID = 116, itemValue="30:30", price = 1250},
		{name = "M4", itemID = 115, itemValue=31, price = 12500},
		{name = "M4 Magazine", itemID = 116, itemValue="31:30", price = 2000},
		{name = "Sniper Rifle", itemID = 115, itemValue=34, price = 30000},
		{name = "Sniper Rifle Magazine", itemID = 116, itemValue="34:10", price = 1000},
	},
	["lowleveldrugdealer"] = { -- change these to drug id's, you have so many tbh lol so I dunno which ones you want in here?
		{name = "CHANGE ME", itemID = 115, itemValue=24, price = 1500},
		{name = "CHANGE ME", itemID = 116, itemValue="24:7", price = 300},
	},
	["highleveldrugdealer"] = { -- change these to drug id's, you have so many tbh lol so I dunno which ones you want in here?
		{name = "Heroin", itemID = 37, itemValue=10, price = 200},
		{name = "Crack", itemID = 224, itemValue=10, price = 150},
		{name = "Weed", itemID = 38, itemValue=10, price = 50},
		{name = "Ecstasy Pill", itemID = 36, itemValue=10, price = 45},
		{name = "Cocaine", itemID = 34, itemValue=10, price = 100},
		
		--[[A AJOUTER : 
		Lysergic
		Cocaine Alka
		Cannabis Sativa
		Unprocessed PCP
		
		LSD
		MORPHINE
		METH
		EPINEPHRINE	
		SHROOMS
		PCP
		MARIJUANA SEEDS ]]--
		
	},
}

function getRandomItemList(dealerType)
	if dealerType and weaponDealerItems[dealerType] then
		local randomItems = {}
		
		for i=minItems, maxItems do
			local mathChance = math.random(1, 2)
			
			if mathChance == 1 then
				randomItems[#randomItems + 1] = table.random(weaponDealerItems[dealerType])
			end
			
			i = i + 1
		end

		return randomItems 
	else
		return false
	end
end

function willDealerTalkToPlayer(dealerType, thePlayer)
	if dealerType and thePlayer then
		if dealerType == "highleveldrugdealer" or dealerType == "highlevelwepdealer" then
			
		else
			return true
		end
	else 
		return false
	end
end