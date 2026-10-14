txd = engineLoadTXD ("models/sevilla_blocks.txd", 3697)
engineImportTXD(txd, 3697)
dff = engineLoadDFF ("models/sevilla_blocks.dff", 3697)
engineReplaceModel(dff, 3697, true)
col = engineLoadCOL("models/sevilla_blocks.col")
engineReplaceCOL(col, 3697)

