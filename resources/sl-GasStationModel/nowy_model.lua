
txd = engineLoadTXD ("modele/budynek.txd", 5489) 
dff = engineLoadDFF ("modele/budynek1.dff", 5489) 
col = engineLoadCOL ("modele/budynek1.col") 
engineImportTXD(txd, 5489)
engineReplaceModel(dff, 5489, true)
engineReplaceCOL(col,5489)

txd = engineLoadTXD ("modele/budynek.txd", 5409) 
dff = engineLoadDFF ("modele/budynek2.dff", 5409) 
col = engineLoadCOL ("modele/budynek2.col") 
engineImportTXD(txd, 5409)
engineReplaceModel(dff, 5409)
engineReplaceCOL(col,5409)

txd = engineLoadTXD ("modele/budynek.txd", 14581) 
dff = engineLoadDFF ("modele/budynek3.dff", 14581) 
col = engineLoadCOL ("modele/budynek3.col") 
engineImportTXD(txd, 14581)
engineReplaceModel(dff, 14581)
engineReplaceCOL(col,14581)

-- Limit view distance of the interior - Nando 11/04/2023
engineSetModelLODDistance(14581, 30)

txd = engineLoadTXD ("modele/budynek.txd", 14814) 
dff = engineLoadDFF ("modele/glass.dff", 14814) 
col = engineLoadCOL ("modele/glass.col") 
engineImportTXD(txd, 14814)
engineReplaceModel(dff, 14814, true)
engineReplaceCOL(col,14814)

txd = engineLoadTXD ("modele/budynek.txd", 1856) 
dff = engineLoadDFF ("modele/door.dff", 1856) 
col = engineLoadCOL ("modele/door.col") 
engineImportTXD(txd, 1856)
engineReplaceModel(dff, 1856, true)
engineReplaceCOL(col,1856)

engineSetModelLODDistance(1856, 20)

-- functional door that u can push: - Nando
engineSetModelPhysicalPropertiesGroup(1856, 147)

removeWorldModel ( 5681, 1, 1921.48, -1778.91, 18.5781 )
removeWorldModel ( 1412, 1, 1906.77, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1912.05, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1917.32, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1922.59, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1927.85, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1933.12, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1938.39, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1943.69, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1948.98, -1797.42, 13.8125 )
removeWorldModel ( 1412, 1, 1951.61, -1800.06, 13.8125 )
removeWorldModel ( 1412, 1, 1951.61, -1805.33, 13.8125 )
removeWorldModel ( 1412, 1, 1951.61, -1810.59, 13.8125 )
removeWorldModel ( 1412, 1, 1951.61, -1815.86, 13.8125 )












  


