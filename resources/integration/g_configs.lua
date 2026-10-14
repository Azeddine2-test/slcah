mysql = exports.mysql

staffTitles = {
	[1] = {
		[0] = "Player",
		[1] = "Modérateur",
		[2] = "Administrateur I",
		[3] = "Administrateur II",
		[3.5] = "Administrateur III",
		[4] = "Manager",
		[5] = "CEO"
	}, 
	[2] = {
		[0] = "Player",
		[1] = "Support",
		[2] = "Lead Support",
	}, 
	[3] = {
		[0] = "Player",
		[1] = "VT Member",
		[2] = "VT Leader",
	}, 
	[4] = {
		[0] = "Player",
		[1] = "Testeur",
		[2] = "Développeur",
		[3] = "Lead Dév.",
	}, 
	[5] = {
		[0] = "Player",
		[1] = "Mapper",
		[2] = "Lead Mapper",
	}, 
	[6] = {
		[0] = "Player",
		[1] = "FT Member",
		[2] = "FT Leader",
	}
}
function getStaffTitle(teamID, rankID) 
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end