function setupGates()
	for _, element in ipairs(exports.pool:getPoolElementsByType("object")) do
		if getElementData(element, "gate") then
			setObjectBreakable(element, false)
		end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, setupGates)