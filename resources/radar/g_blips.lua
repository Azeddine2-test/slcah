custom_blips = {
	[64] = {name = "Paintball"},
	[65] = {name = "Concess Utilitaires"},
	[84] = {name = "Concess 2 roues"},
	[86] = {name = "Tribunal"},
	[120] = {name = 'LSPD-Microphone'},
	[121] = {name = "Pharmacie"},
	[122] = {name = "Magasin d'outils"},
}

isCustomBlip = function(id)
	return custom_blips[id] ~= nil
end