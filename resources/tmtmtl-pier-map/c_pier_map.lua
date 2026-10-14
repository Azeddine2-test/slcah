function replacePierMods()
	engineReplaceModel(engineLoadDFF("files/pieralpha.dff"), 6466, true)
	col = engineLoadCOL( "files/pieralpha.col" )
	engineReplaceCOL( col, 6466 )
	engineReplaceModel(engineLoadDFF("files/pierarcade.dff"), 6289, true)
	col = engineLoadCOL( "files/pierarcade.col" )
	engineReplaceCOL( col, 6289 )
	
	engineImportTXD(engineLoadTXD("files/pierfood.txd"), 6299)
	engineReplaceModel(engineLoadDFF("files/pierfood.dff"), 6299, true)
	col = engineLoadCOL( "files/pierfood.col" )
	engineReplaceCOL( col, 6299 )
	
	engineReplaceModel(engineLoadDFF("files/pierticket.dff"), 6462, true)
	
	local circusMusic = playSound3D("files/circus.mp3", 375.03216552734, -2049.5451660156, 7.8300905227661, true)
	if circusMusic then
		setSoundMaxDistance(circusMusic, 100)
		setSoundVolume(circusMusic, 0.05)
	end
end
addEventHandler("onClientResourceStart", resourceRoot, replacePierMods)