txd = engineLoadTXD ("models/ls_fire_station.txd", 4012)
engineImportTXD(txd, 4012)
dff = engineLoadDFF ("models/ls_fire_station_terrain.dff", 4012)
engineReplaceModel(dff, 4012, true)
col = engineLoadCOL("models/ls_fire_station_terrain.col")
engineReplaceCOL(col, 4012)

dff = engineLoadDFF ("models/ls_fire_station_road.dff", 5502)
engineReplaceModel(dff, 5502, true)
col = engineLoadCOL("models/ls_fire_station_road.col")
engineReplaceCOL(col, 5502)

txd = engineLoadTXD ("models/ls_fire_station_gdoor.txd", 14822)
engineImportTXD(txd, 14822)
dff = engineLoadDFF ("models/ls_fire_station_gdoor.dff", 14822)
engineReplaceModel(dff, 14822, true)
col = engineLoadCOL("models/ls_fire_station_gdoor.col")
engineReplaceCOL(col, 14822)

engineSetModelLODDistance(14822, 20)

