function hasSpaceForItem( ... )
	return call( getResourceFromName( "item-system" ), "hasSpaceForItem", ... )
end

function hasItem( ... )
	return call( getResourceFromName( "item-system" ), "hasItem", ... )
end

function getItemName( ... )
	return call( getResourceFromName( "item-system" ), "getItemName", ... )
end
