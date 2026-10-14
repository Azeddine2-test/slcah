--MAXIME
local deathSound = nil
local ckSound = nil
function playerWasted (thePlayer)
	deathSound = playSound("deathFX/wasted.mp3",false)
	setSoundVolume(deathSound, 0.2)
	--setGameSpeed (0.1)
end
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), playerWasted )

function playerSpawn()
	if deathSound and isElement(deathSound) then
		destroyElement(deathSound)
	end
	--setGameSpeed (1)
end
addEventHandler ( "onClientPlayerSpawn", getLocalPlayer(), playerSpawn )

local gui = {}
function showCkWindow()
	setTimer(function()
		triggerEvent("accounts:logout", localPlayer)
		--setGameSpeed (1)
		closeCkWindow()

		ckSound = playSound("deathFX/cked.mp3",false)
		setSoundVolume(ckSound, 0.4)

		triggerEvent("es-system:closeRespawnButton", localPlayer)

		gui.window = guiCreateStaticImage(0, 0, 350, 300, ":resources/window_body.png", false)
		exports.global:centerWindow(gui.window)

		gui.label = guiCreateLabel(0.05, 0.05, 0.9, 0.7, string.gsub(getPlayerName(localPlayer), "_", " ").." a été CK!\n\nCK (Character kill) La façon la moins commune dont un personnage est tué dans le jeu et n'est utilisée que dans des situations où c'est nécessaire.\nLorsque vous êtes tué par un CK, c'est permanent et la seule façon de récupérer les biens détenus par ce personnage est de modifier ses informations.\nVous êtes maintenant redirigé vers l'écran de sélection des personnages, veuillez cliquer sur votre personnage afin de procéder à ses modifications pour effecuter une demande de réintégration.", true, gui.window)
		guiLabelSetHorizontalAlign(gui.label, "left", true)
		guiLabelSetVerticalAlign(gui.label, "center", true)

		gui.bClose = guiCreateButton(0.05, 0.8, 0.9, 0.15, "OK", true, gui.window)
		addEventHandler("onClientGUIClick", gui.bClose,
		function ()
			if source == gui.bClose then
				closeCkWindow()
			end
		end, false)
	end, 2000, 1)
end
addEvent("showCkWindow", true)
addEventHandler ( "showCkWindow", localPlayer, showCkWindow )

function closeCkWindow()
	if gui.window and isElement(gui.window) then
		destroyElement(gui.window)
		--setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	end
end
