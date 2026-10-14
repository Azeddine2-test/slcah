
-- Dont remove, used by other scripts xd
function copyPosToClipboard( prepairedText)
	setClipboard( prepairedText ) 
end
addEvent("copyPosToClipboard",true)
addEventHandler("copyPosToClipboard", getLocalPlayer(),copyPosToClipboard )