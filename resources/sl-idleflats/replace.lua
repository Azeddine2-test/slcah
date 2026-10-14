-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

txd = engineLoadTXD( 'idlewoodflats15.txd' ) 
engineImportTXD( txd, 5418 ) 
dff = engineLoadDFF('idlewoodflats21.DFF', 5418) 
engineReplaceModel( dff, 5418 )
col = engineLoadCOL("idlewoodflats21.col", 5418)
engineReplaceCOL( col, 5418 )


txd = engineLoadTXD( 'laeroads2s.txd' ) 
engineImportTXD( txd, 5509 ) 
dff = engineLoadDFF('laeroad47.dff', 5509) 
engineReplaceModel( dff, 5509 )
col = engineLoadCOL("laeroad44.col", 5509)
engineReplaceCOL( col, 5509 )


txd = engineLoadTXD( 'laeroads2s.txd' ) 
engineImportTXD( txd, 5508 ) 
dff = engineLoadDFF('laeroad43.dff', 5508) 
engineReplaceModel( dff, 5508 )
col = engineLoadCOL("laeroad43.col", 5508)
engineReplaceCOL( col, 5508 )

txd = engineLoadTXD( 'lodidlewoodflats.txd' ) 
engineImportTXD( txd, 5530 ) 
dff = engineLoadDFF('lodidlewoodflats.DFF', 5530) 
engineReplaceModel( dff, 5530 )


engineSetModelLODDistance(5530, 300)

removeWorldModel ( 1408, 30, 2112.94, -1797.09, 19.33 )
removeWorldModel ( 1432, 30, 2112.94, -1797.09, 19.33 )
removeWorldModel ( 1226, 1, 2114.719, -1785.180, 16.398)
removeWorldModel ( 712, 1, 2100.8125, -1764.3750, 21.3906)
removeWorldModel ( 150, 1, 2100.8125, -1764.3750, 21.3906)
removeWorldModel(12049, 1, 2100.8125, -1764.375, 21.3906)