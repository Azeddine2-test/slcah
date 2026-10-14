--[[ local mem_permissions = {
	[1] = 	{"add_member",			"Inviter"},
	[2] = 	{"del_member",			"Virer"},
	[3] = 	{"modify_ranks",		"Modifier Ranks, Permissions et Salaires"},
	[4] = 	{"modify_faction_note",	"Modifier Notes Faction"},
	[5] = 	{"modify_factionl_note","Modifier Notes Leader Faction"},
	[6] = 	{"respawn_vehs",		"((désactivé))Respawn Faction Vehicules"},
	[7] = 	{"change_member_rank",	"RankUP/RankDOWN des membres"},
	[8] = 	{"manage_interiors",	"Gérer Intérieurs de la faction"},
	[9] = 	{"manage_finance",		"Gérer Finances de la faction"}, 
	[10] = 	{"toggle_chat",			"((désactivé))Activer/Désactiver Faction Chat"},  
	[11] = 	{"modify_leader_note",	"Modifier Leader Notes"}, 
	[12] =  {"edit_motd", 			"Modifier Message of the Day (MOTD)"},
	[21] = 	{"use_fl",				"Utilisation /fl"}, 
	[22] = 	{"use_hq",				"Utilisation /hq et /gov"}, 
	[23] = 	{"make_ads", 			"((pas utilisé))Create faction advertisements"},
	[13] = 	{"modify_duty_settings","Modifier Duty"}, 	-- 16 and above are perms that do not exist for ALL factions
	[14] = 	{"set_member_duty",		"Gérer Duty des membres"}, 		-- If you add something you'll have to edit 'getFactionPermissions'
	[18] = 	{"see_towstats",		"Voir stats fourrière"}, -- obsolete (Nando)
	[19] =  {"use_bm", 				"Utilisation blackmarket"},
	[20] =  {"rem_fine", 			"Enlever des amendes"},
	[21] =  {"garage_management", 	"Garage management"},
} *]]

local mem_permissions = {
	[1] = 	{"add_member",			"Inviter"},
	[2] = 	{"del_member",			"Virer"},
	[3] = 	{"modify_ranks",		"Modifier Ranks, Permissions et Salaires"},
	[4] = 	{"modify_faction_note",	"Modifier Notes Faction"},
	[5] = 	{"modify_factionl_note","Modifier Notes Leader Faction"},
	[6] = 	{"respawn_vehs",		"((désactivé))Respawn Faction Vehicules"},
	[7] = 	{"change_member_rank",	"RankUP/RankDOWN des membres"},
	[8] = 	{"manage_interiors",	"Gérer Intérieurs de la faction"},
	[9] = 	{"manage_finance",		"Gérer Finances de la faction"}, 
	[10] = 	{"toggle_chat",			"((désactivé))Activer/Désactiver Faction Chat"},  
	[11] = 	{"modify_leader_note",	"Modifier Leader Notes"}, 
	[12] =  {"edit_motd", 			"Modifier Message of the Day (MOTD)"},
	[13] = 	{"modify_duty_settings","Modifier Duty"}, 	-- 16 and above are perms that do not exist for ALL factions -- Flash
	[14] = 	{"set_member_duty",		"Gérer Duty des membres"}, 		-- If you add something you'll have to edit 'getFactionPermissions'
	[15] =  {"garage_management", 	"Garage management"},
	[16] =  {"san_news_app_write", 	"San News App Posting"},
	[17] =  {"force_doors", 		"Force doors"},
	--[[ [18] = 	{"see_towstats",		"Voir stats fourrière"}, -- obsolete (Nando)
	[19] =  {"use_bm", 				"Utilisation blackmarket"},
	[20] =  {"rem_fine", 			"Enlever des amendes"},
	[21] = 	{"use_fl",				"Utilisation /fl"}, 
	[22] = 	{"use_hq",				"Utilisation /hq et /gov"},
	[23] = 	{"make_ads", 			"((pas utilisé))Create faction advertisements"}, *]]
}

-- Get Permissions
------------------->>
function hasMemberPermissionTo(player, fID, action)
	if (not player or not action or not fID) then return false end
	if (not isElement(player) or getElementType(player) ~= "player" or type(action) ~= "string") then return false end
	local fID = tonumber(fID)
	local rankID = 0
	local faction = getElementData(player, "faction")
	for i,v in pairs(faction) do
		if i == fID then
			rankID = tonumber(v.rank)
		end	
	end
	if not factionRanks[rankID] then
		return false
	end
	local perm = factionRanks[rankID]["permissions"] or "" 
	if perm ~= true then 
		local perProfile = split(perm, ",")
		for i,v in ipairs(perProfile) do
			v = tonumber(v)
			if (mem_permissions[v] and mem_permissions[v][1] == action) then
				return true
			end
		end
	end	
	return false
end


-- Get Default Permissions
--------------------------->>

function getDefaultPermissionSet(permissions)
	if (not permissions or type(permissions) ~= "string") then return false end
	
	local permTable = {}
	if (permissions == "*") then		-- Founder/Leader Permissions
		for i=1,#mem_permissions do
			table.insert(permTable, i)
		end
		return permTable
	elseif (permissions == "New Member") then
		return {}
	end
end

