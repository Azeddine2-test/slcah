blackjackGameStartTimeSeconds = 15
blackjackMoveTimeSeconds = 15

globalOrIntegration = "integration"

local odsEnabled = false

function ods(message)
	if not odsEnabled then return end
	
	local prefix = "[TM]"
	outputDebugString(prefix.." "..message, 4, 68, 71, 242)
end

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )  -- Get the matrix
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z                               -- Return the transformed point
end

function table.copy(tab, recursive)
    local ret = {}
    for key, value in pairs(tab) do
        if (type(value) == "table") and recursive then ret[key] = table.copy(value)
        else ret[key] = value end
    end
    return ret
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

blackjackTableLevels = {
	[1] = {
		tableName="Low Bets",
		betIncrements = {
			[1] = 2,
			[2] = 5,
			[3] = 10,
			[4] = 20,
			[5] = 35,
		},
		--[[win21 = 2,
		winBJ = 2.5,]] -- these have no use atm
	},
	[2] = {
		tableName="Medium Bets",
		betIncrements = {
			[1] = 50,
			[2] = 75,
			[3] = 100,
			[4] = 150,
			[5] = 250,
		},
		--[[win21 = 2,
		winBJ = 2.5,]] -- these have no use atm
	},
	[3] = {
		tableName="High Rollers",
		betIncrements = {
			[1] = 500,
			[2] = 1000,
			[3] = 2500,
			[4] = 5000,
			[5] = 10000,
		},
		--[[win21 = 2,
		winBJ = 2.5,]] -- these have no use atm
	},
}