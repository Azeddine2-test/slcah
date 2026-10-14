txd = engineLoadTXD ("models/model.txd", 17517) 
engineImportTXD(txd, 17517)
engineImportTXD(txd, 14743)

dff = engineLoadDFF ("models/model.dff", 17517) 
engineReplaceModel(dff, 17517, true)

col = engineLoadCOL ("models/model.col") 
engineReplaceCOL(col,17517)

dff = engineLoadDFF ("models/model2.dff", 14743) 
engineReplaceModel(dff, 14743, true)

col = engineLoadCOL ("models/model2.col")
engineReplaceCOL(col,14743)

-- Limit view distance of the interior - Nando 11/04/2023
engineSetModelLODDistance( 14743, 30 )

