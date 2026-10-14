-- ERMAGHERD PLS DONT STEEL M8

function hookItUpM82()
	-- Load up teh shitz
	bild = engineLoadDFF("files/ce_terminal1.dff", 13295)
	engineReplaceModel(bild, 13295)
	bildtxd = engineLoadTXD("files/ce_terminal.txd")
	engineImportTXD(bildtxd, 13295)
	bildcol = engineLoadCOL("files/ce_terminal1.col")
    engineReplaceCOL(bildcol, 13295)
end

addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()),
     function()
        hookItUpM82()
        setTimer (hookItUpM82, 2000, 2)
end
)