

addCommandHandler("debugsl", function()
	outputConsole("[Southland Debug - Client]  DEBUT")
	local info = dxGetStatus ()
	for k, v in pairs (info) do
		outputConsole (k .. " : " .. tostring (v))
	end
	outputConsole("[Southland Debug - Client]  FIN")
end, false)





addEvent("admin:openTempMemobox", true)

local memoWindows = {}

addEventHandler("admin:openTempMemobox", localPlayer, function(title, content, readonly)
    local existing = memoWindows[title]
    if isElement(existing) then
        destroyElement(existing)
    end
    memoWindows[title] = guiCreateWindow(0.2, 0.2, 0.6, 0.6, title, true)
    local memo = guiCreateMemo(0.05, 0.05, 0.9, 0.8, content, true, memoWindows[title])
    guiMemoSetReadOnly(memo, readonly or false)
    guiWindowSetSizable(memoWindows[title], false)
    guiBringToFront(memoWindows[title])
    local closeButton = guiCreateButton(0.05, 0.875, 0.9, 0.06, "Fermer", true, memoWindows[title])
    addEventHandler("onClientGUIClick", closeButton, function()
        destroyElement(memoWindows[title])
        memoWindows[title] = nil
    end, false)

end, false)