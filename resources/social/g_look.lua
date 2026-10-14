local function checkLength( value )
	return value and #value >= 0 and #value <= 165
end

local allowedImageHosts = {
	["imgur.com"] = true,
}
local imageExtensions = {
	[".jpg"] = true,
	[".png"] = true,
	[".gif"] = true,
}
function verifyImageURL(url, notEmpty)
	if not notEmpty then
		if not url or url == "" then
			return true
		end
	end
	if string.find(url, "http://", 1, true) or string.find(url, "https://", 1, true) then
		local domain = url:match("[%w%.]*%.(%w+%.%w+)") or url:match("^%w+://([^/]+)")
		if allowedImageHosts[domain] then
			local _extensions = ""
			for extension, _ in pairs(imageExtensions) do
				if _extensions ~= "" then
					_extensions = _extensions..", "..extension
				else
					_extensions = extension
				end
				if string.find(url, extension, 1, true) then
					return true
				end
			end			
		end
	end
	return false
end

editables = {
	{ name = "Poids", index = "weight", verify = function( v ) return tonumber( v ) and tonumber( v ) >= 30 and tonumber( v ) <= 200 end, instructions = "Entrez un poids en kg, entre 30 et 200." },
	{ name = "Taille", index = "height", verify = function( v ) return tonumber( v ) and tonumber( v ) >= 70 and tonumber( v ) <= 220 end, instructions = "Entrez une taille en cm, entre 70 et 220." },
	{ name = "Couleur Cheveux", index = 1, verify = checkLength },
	{ name = "Style Cheveux", index = 2, verify = checkLength },
	{ name = "Description Visage", index = 3, verify = checkLength },
	{ name = "Description Physique", index = 4, verify = checkLength },
	{ name = "Vêtements", index = 5, verify = checkLength },
	{ name = "Accessoires", index = 6, verify = checkLength },
	{ name = "Photo", index = 7, verify = verifyImageURL, instructions = "Entrez un lien imgur pour montrer à quoi votre personnage ressemble." }
}