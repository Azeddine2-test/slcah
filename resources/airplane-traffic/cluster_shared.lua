--[[

	Creating a cluster over the entire GTA map
	Each cell of the cluster can be used to store data in.
	This will reduce in the long run a lot of data requests from elements that have a fixed position on the map.

]] --
----- 
Cluster = {}
local clusterSize = 30
local mapCellSize = 6000 / clusterSize
local halfClusterSize = (clusterSize / 2)

local function setCellData( self, key, value )
	self.dataCollection[key] = value
	return self
end

local function getCellData( self, key ) return self.dataCollection[key] end

function Cluster:new()
	local sourceMap = {}
	o = o or { sourceMap = sourceMap } -- create object if user does not provide one
	setmetatable( o, self )
	self.__index = self

	for x = 0, clusterSize do
		local row = {}
		sourceMap[x - halfClusterSize] = row
		for y = 0, clusterSize do
			row[y - halfClusterSize] = { x = x - halfClusterSize, y = y - halfClusterSize, dataCollection = {}, setData = setCellData, getData = getCellData }
		end
	end

	o.mapCellSize = mapCellSize
	o.boundary = { min = -(halfClusterSize), max = halfClusterSize }

	return o
end

do
	--[[

		For developing:
		- Looping through the table using a coroutine
		- One at the time.
		- Process terrain functions. (for example getGroundPosition)
		
		An async interval required: timer / onClientRender 

		Untested at the moment, not recommended to use.

	]]
	local nextCell = function( callBack, cells )

		local itemCount = #cells
		for i = 1, itemCount do
			local cell = cells[i]
			callBack( cell, i, itemCount )
			coroutine.yield()
		end
	end

	function Cluster:newNextCellCoroutine( callBack, finishedCallBack )

		local sourceMap = self.sourceMap

		local cells = {}
		for _, row in pairs( sourceMap ) do for _, cell in pairs( row ) do cells[#cells + 1] = cell end end

		local thread = coroutine.create( nextCell )

		return function()
			local status = coroutine.status( thread )

			if status == "suspended" or status == "normal" then
				local resumeStatus = false
				resumeStatus = coroutine.resume( thread, callBack, cells )
				if coroutine.status( thread ) == "dead" then finishedCallBack() end
				return resumeStatus
			end
			if status == "dead" then return false end
		end
	end
end

function Cluster:forEachCell( callBack )
	-- Note: There is no loop order.
	local sourceMap = self.sourceMap

	--[[
		Callback Information:
		(cell table, sourceMapX int, sourceMapY int)
	]]
	for x, row in pairs( sourceMap ) do for y, cell in pairs( row ) do callBack( cell, x, y ) end end
end

function Cluster:getCellFromWorldMap( x, y )
	x = math.floor( x / mapCellSize + 0.5 )
	y = math.floor( y / mapCellSize + 0.5 )

	local boundary = self.boundary
	if x < boundary.min then
		x = boundary.min
	elseif x > boundary.max then
		x = boundary.max
	end
	if y < boundary.min then
		y = boundary.min
	elseif y > boundary.max then
		y = boundary.max
	end

	local row = self.sourceMap[x]
	if not row then return false end
	return row[y] or false
end

function Cluster:getCellWorldPosition( cell ) return cell.x * mapCellSize, cell.y * mapCellSize end

function Cluster:getCellFromSourceMap( x, y )

	local boundary = self.boundary
	if x < boundary.min then
		x = boundary.min
	elseif x > boundary.max then
		x = boundary.max
	end
	if y < boundary.min then
		y = boundary.min

	elseif y > boundary.max then
		y = boundary.max
	end

	local row = self.sourceMap[x]
	if not row then return false end
	return row[y] or false
end

function Cluster:getCellsBetweenCells( cell1, cell2 )
	if not cell1 or not cell2 then return {} end

	local x1, y1 = math.min( cell1.x + halfClusterSize, cell2.x + halfClusterSize ), math.min( cell1.y + halfClusterSize, cell2.y + halfClusterSize )
	local x2, y2 = math.max( cell1.x + halfClusterSize, cell2.x + halfClusterSize ), math.max( cell1.y + halfClusterSize, cell2.y + halfClusterSize )

	local cells = {}
	for x = x1, x2 do for y = y1, y2 do cells[#cells + 1] = self:getCellFromSourceMap( x - halfClusterSize, y - halfClusterSize ) end end
	return cells
end
