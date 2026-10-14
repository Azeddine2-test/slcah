-- temp fix for MTA Issue 6846: exports.global:getVehicleType with trailers returns empty string client-side
function getVehicleType( ... )
	local ret = exports.global:getVehicleType( ... )
	if ret == "" then
		return "Trailer"
	end
	return ret
end
