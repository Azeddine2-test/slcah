rampGui = nil
id = nil

function applyMods()
   local txd = engineLoadTXD ( "lifts.txd")
   engineImportTXD ( txd, 1853 ) --2052
   
   local dff = engineLoadDFF("liftposts.dff", 2052 ) --2052
   engineReplaceModel(dff, 1853) --2052
   
   local col = engineLoadCOL ( "liftposts.col")
   engineReplaceCOL ( col, 1853 ) --2052
   
   local txd = engineLoadTXD ( "lifts.txd")
   engineImportTXD ( txd, 1854 ) --2053
   
   local dff = engineLoadDFF("ramps.dff", 2053 ) --2053
   engineReplaceModel(dff, 1854) --2053
   
   local col = engineLoadCOL ( "ramps.col")
   engineReplaceCOL ( col, 1854 ) --2053 
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()),
     function()
         applyMods()
         setTimer (applyMods, 1000, 2)
end
)