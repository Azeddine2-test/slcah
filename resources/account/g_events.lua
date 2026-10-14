-- Global Events
addEvent("accounts:characters:list", true)
addEvent("accounts:characters:spawn", true)
addEvent("accounts:characters:change", true)
addEvent("accounts:characters:logout", true)
addEvent("accounts:characters:new", true)
addEvent("accounts:options", true)
addEvent("accounts:options:settings", true)	-- 
addEvent("accounts:options:settings", true)
addEvent("accounts:logout", true)

-- Local events
addEvent("accounts:settings:loadGraphicSettings", true)
addEvent("onCharacterLogin", true)
addEvent("onClientChangeChar", false)
addEvent("account:changingchar", true)

-- Shared variables
-- newsURL = "http://owlgaming.net/server/news.php"
-- rulesURL = "http://owlgaming.net/server/rules.php"

-- default spawn position while no character is selected.
defaultCharacterSelectionSpawnPosition = { -1480, -1688, 13 }

-- Global functions
function checkValidCharacterName(theText)
	local foundSpace, valid = false, true
	local lastChar, current = ' ', ''
	for i = 1, #theText do
		local char = theText:sub( i, i )
		if char == ' ' then -- it's a space
			if i == #theText then -- space at the end of name is not allowed
				valid = false
				return false, "Vous ne pouvez pas avoir d'espace à la fin\n du nom"
			else
				foundSpace = true -- we have at least two name parts
			end
			
			if #current < 2 then -- check if name's part is at least 2 chars
				valid = false
				return false, "Votre nom ne peut pas être aussi petit"
			end
			current = ''
		elseif lastChar == ' ' then -- this char follows a space, we need a capital letter
			if char < 'A' or char > 'Z' then
				valid = false
				return false, "Vous n'avez pas utilisé de majuscule."
			end
			current = current .. char
		elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) or (char == "'") then -- can have letters anywhere in the name
			current = current .. char
		else -- unrecognized char (numbers, special chars)
			valid = false
			return false, "Caractères invalides dans le nom.\nVous ne pouvez utiliser que\n A-Z, a-z et espace"
		end
		lastChar = char
	end
	
	if valid and foundSpace and #theText <= 22 and #theText >= 2 then
		return true, "Looking good!" -- passed
	else
		return false, "Le nom est trop long ou trop court \n(min 2, max 22)" -- failed for the checks
	end
end