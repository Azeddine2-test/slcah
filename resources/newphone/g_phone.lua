pageTitleColor = tocolor(255, 255, 255, 175)
anticheatRes = "anticheat" -- what is your anticheat resource called? anticheat, or anticheat?

loudspeakerDistance = 5
phoneSpeakDistance = 3

hotlineNumbersOrdered = {
	911,
	9021,
	208208,
	8294,
	311,
	411,
	511
}

hotlineNumbers = {
	[911] = {name="URGENCE"},
	[9021] = {name="Mechanic Garage"},
	[208208] = {name="Auto Parks"},
	[8294] = {name="Taxi"},
	[311] = {name="LSPD non-urgent"},
	[411] = {name="LSES non-urgent"},
	[511] = {name="Gouvernement de SA"},
	
	--[7332] = {name="San News", data="lsn"},
	--[2552] = {name="RS Haul", data="rshaul"},
	--[5555] = {name="Federal Aviation Administration", data="faa"},
	--[211] = {name="Los Santos Courts", data="lscourts"},
	--[7233] = {name="Cargo Group", data="cargogroup"},
	--[8800] = {name="San Andreas Public Transport", data="sapt"},
}

noReplyNumbers = {}--unfinished

weatherDetails = {
	[0] = {name="Very Sunny", temp=28, icon = "files/icons/weather/sunny.png"},
	[1] = {name="Sunny", temp=22, icon = "files/icons/weather/sunny.png"},
	[2] = {name="Very Sunny & Smoggy", temp=24, icon = "files/icons/weather/sunny.png"},
	[3] = {name="Sunny & Smoggy", temp=20, icon = "files/icons/weather/sunny.png"},
	[4] = {name="Cloudy", temp=18, icon = "files/icons/weather/cloudy.png"},
	[5] = {name="Sunny", temp=22, icon = "files/icons/weather/sunny.png"},
	[6] = {name="Very Sunny", temp=28, icon = "files/icons/weather/sunny.png"},
	[7] = {name="Cloudy", temp=18, icon = "files/icons/weather/cloudy.png"},
	[8] = {name="Rainy", temp=18, icon = "files/icons/weather/cloudy.png"},
	[9] = {name="Foggy", temp=19, icon = "files/icons/weather/cloudy.png"},
	[10] = {name="Sunny", temp=22, icon = "files/icons/weather/sunny.png"},
	[11] = {name="Very Sunny", temp=30, icon = "files/icons/weather/sunny.png"},
	[12] = {name="Cloudy", temp=18, icon = "files/icons/weather/cloudy.png"},
	[13] = {name="Very Sunny", temp=30, icon = "files/icons/weather/sunny.png"},
	[14] = {name="Sunny", temp=22, icon = "files/icons/weather/sunny.png"},
	[15] = {name="Cloudy", temp=18, icon = "files/icons/weather/cloudy.png"},
	[16] = {name="Rainy", temp=18, icon = "files/icons/weather/cloudy.png"},
	[17] = {name="Very Sunny", temp=30, icon = "files/icons/weather/sunny.png"},
	[18] = {name="Sunny", temp=22, icon = "files/icons/weather/sunny.png"},
}

phoneButtons = {
	[1] = {displayName = "Paramètres", name = "settings", image="files/icons/Settings.png"},
	[2] = {displayName = "Maps", name = "maps", image="files/icons/Maps.png"},
	[3] = {displayName = "Wallet", name = "wallet", image="files/icons/Wallet.png"},
	[4] = {displayName = "Notes", name = "notes", image="files/icons/Notes.png"},
	[5] = {displayName = "Météo", name = "weather", image="files/icons/Weather.png"},
	[6] = {displayName = "Appel", name = "phone", image="files/icons/Phone.png"},
	[7] = {displayName = "SMS", name = "messages", image="files/icons/Messages.png"},
	[8] = {displayName = "Santé", name = "health", image="files/icons/Health.png"},
	[9] = {displayName = "Contacts", name = "contacts", image="files/icons/Contacts.png"},
	[10] = {displayName = "Annuaire", name = "phonebook", image="files/icons/Phonebook.png"},
	[11] = {displayName = "Pubs", name = "adverts", image="files/icons/Adverts.png"},
	[12] = {displayName = "YouTube", name = "youtube", image="files/icons/YouTube.png"},
}

wallpapers = {
	[1] = {wallpapername = "Custom", image="files/wallpapers/1.png", textColor={0, 0, 0}},
	[2] = {wallpapername = "Galaxy", image="files/wallpapers/2.png", textColor={255, 255, 255}},
	[3] = {wallpapername = "Tokyo", image="files/wallpapers/3.png", textColor={255, 255, 255}},
	[4] = {wallpapername = "Nature", image="files/wallpapers/4.png", textColor={255, 255, 255}},
	[5] = {wallpapername = "Blossom", image="files/wallpapers/5.png", textColor={0, 0, 0}},
	[6] = {wallpapername = "Hearts", image="files/wallpapers/6.png", textColor={0, 0, 0}},
	[7] = {wallpapername = "Night Bridge", image="files/wallpapers/7.png", textColor={255, 255, 255}},
	[8] = {wallpapername = "Camo", image="files/wallpapers/8.png", textColor={255, 255, 255}},
	[9] = {wallpapername = "Space", image="files/wallpapers/9.png", textColor={255, 255, 255}},
	[10] = {wallpapername = "Galaxy Forrest", image="files/wallpapers/10.png", textColor={255, 255, 255}},
	[11] = {wallpapername = "Stay Fresh", image="files/wallpapers/11.png", textColor={0, 0, 0}},
	[12] = {wallpapername = "Abstract", image="files/wallpapers/12.png", textColor={255, 255, 255}},
	[13] = {wallpapername = "Clouds", image="files/wallpapers/13.png", textColor={255, 255, 255}},
	[14] = {wallpapername = "Biker", image="files/wallpapers/14.png", textColor={255, 255, 255}},
	[15] = {wallpapername = "Marble", image="files/wallpapers/15.png", textColor={255, 255, 255}},
}

customWallpaperID = 1

ringtones = {
	[1] = {ringtonename = "iPhone", sound="files/sounds/ring1.mp3", volume=0.4},
	[2] = {ringtonename = "Squad", sound="files/sounds/oldcell.mp3", volume=0.4},
	[3] = {ringtonename = "Cyber", sound="files/sounds/cyber.mp3", volume=0.4},
	[4] = {ringtonename = "Chime", sound="files/sounds/chime.mp3", volume=0.8},
	[5] = {ringtonename = "Vibrate", sound="files/sounds/vibrate.mp3", volume=0.8},
}

messagetones = {
	[1] = {messagetonename = "SMS 1", sound="files/sounds/sms.mp3", volume=0.4},
	[2] = {messagetonename = "SMS 2", sound="files/sounds/sms2.mp3", volume=0.4},
	[3] = {messagetonename = "SMS 3", sound="files/sounds/sending_you_an_sms.mp3", volume=0.4},
	[4] = {messagetonename = "Silencieux", sound="files/sounds/vibrate.mp3", volume=0.4},
}

blips_name = {
	[0] = "Bus Stop",
	[2] = "Tracked Vehicle",
	[5] = "LSIA",
	[22] = "Hospital",
	[11] = "Scrapyard",
	[14] = "Factory",
	[21] = "Panorama",
	[41] = "City Hall",
	[45] = "Binco",
	[30] = "LSPD",
	[36] = "DMV",
	[54] = "Gym",
	[55] = "Gas Station",
	[52] = "Bank",
	[47] = "Fishing",
	[56] = "Car Shop",
	[63] = "Pay 'n' Spray",
	[32] = "My Property",
	[40] = "Job",
	[51] = "Job",
	[58] = "Vehicle Rental",
}

-- VARIABILIZED NAMES ETC FOR THE PHONE, EASIER TRANSLATION. START

	--SETTINGS PAGE START
		securitySettingsTitleText = "Sécurité"
		wallpaperSettingsTitleText = "Fond d'ecran"
		ringtoneSettingsTitleText = "Sonnerie"
		messagetoneSettingsTitleText = "Sonnerie"
		settingsTitleText = "Pramètres"
		wallpaperURLText = "Fond Ecran URL:"
		redRgbText = "RGB Red: (0-255)"
		greenRgbText = "RGB Green: (0-255)"
		blueRgbText = "RGB Blue: (0-255)"
		errorNotifText = "(Invalide)"
		errorNotifColor = tocolor(255, 100, 100)
		
		customWallpaperText = "Fond Ecran Custom"
		
		selectedWallpaperText = "Fond Ecran sélectionné:"
		saveWallpaperText = "Sauvegarder"
		
		selectedMessageToneText = "Sonnerie sélectionnée:"
		saveMessageToneText = "Sauvegarder"
		
		selectedRingtoneText = "Sonnerie sélectionnée:"
		saveRingtoneText = "Sauvegarder"
		soundModeText = "Mode"
		
		hideCallerIDText = "Numéro masqué:"
	--SETTINGS PAGE END
	
	--SECURITY PAGE START
		securityTitleText = "Sécurité"
		pinCodeLabelText = "Code PIN:"
		noPinText = "PAS DE PIN"
		removePinText = "Retirer PIN"
		changePinText = "Changer PIN"
		pinLengthText = "4 caractères requis."
		newPinCodeText = "Nouveau PIN:"
		incorrectPinText = "Incorrecte PIN"
		pinTitleText = "PIN:"
	--SECURITY PAGE END
	
	--MAPS PAGE START
		mapsTitleText = "Maps"
	--MAPS PAGE END
	
	--WEATHER 
		noSignalText = "Pas de signal..."
	-- WEATHER END
	
	--WALLET PAGE START
		personalBalanceText = "Compte Personnel:"
		currencyText = "$"
	--WALLET PAGE END
	
	--NOTES PAGE START
		notesTitleText = "Notes"
		createNoteText = "Créer Note"
		editNoteText = "Modif. Note"
		saveNoteText = "Sauv. Note"
		deleteNoteText = "Suppr. Note"
	--NOTES PAGE END
	
	--PHONE PAGE START
		phoneTitleText = "Appel"
		phoneNumberAreaCode = "(555)-"
	--PHONE PAGE END
	
	--PHONE PAGE START
		messagesTitleText = "Messages"
		newMessageText = "Nouveau Message"
		phoneNumberMessageText = "Numéro:"
		receivedMessageText = "Reçu"
		sentMessageText = "Envoyé"
		incomingCallText = "Appel reçu"
		callingText = "En appel"
		lineBusyText = "Ligne occupée"
		callDisconnectedText = "Appel déconnecté"
		hiddenNumberText = "Numéro masqué"
		callHistoryTitleText = "Historique appels"
		inText = "↑"
		outText = "↓"
	--PHONE PAGE END
	
	--HEALTH PAGE START
		healthTitleText = "Vie"
		hitpointsText = "Hitpoints"
		armorText = "Armure"
	--HEALTH PAGE END
	
	--CONTACTS PAGE START
		contactsTitleText = "Contacts"
		myNumberText = "Mon Numéro:"
		newContactTitleText = "Nouveau Contact"
		editContactTitleText = "Modif. Contact"
		newContactNameText = "Nom:"
		newContactNumberText = "Numéro:"
		newContactNote = "Note:"
		saveContactText = "Sauvegarder"
		deleteContactText = "Suppr. Contact"
		alreadySavedNumberText = "Déjà dans vos contacts!"
	--CONTACTS PAGE END
	
	--PHONEBOOK PAGE START
		phonebookTitleText = "Annuaire"
	--PHONEBOOK PAGE END
	
	--ADVERTS PAGE START
		postAdvertPrice = 75
		advertsTitleText = "Pubs"
		viewAdvertTitleText = "Voir PUB"
		fetchingAdvertsText = "Chargement..."
		postAdvertTitleText = "Poster une PUB"
		editAdvertTitleText = "Modifier PUB"
		advertSettingsTitleText = "Paramètres"
		
		advertTitleText = "Titre:"
		advertPriceText = "Prix: $"
		advertDescText = "Description:"
		-- advertPhotoText = "Photo: (URL)"
		advertTypeText = "Type:"
		checkAdvertText = "Vérifier"
		postAdvertText = "Poster"
		editAdvertText = "Modif. PUB"
		deleteAdvertText = "Suppr. PUB"
		maxAdvertsText = "Vous avez atteint le nombre maximal de pubs! \n\nSupprimez en si vous voulez en poster une autre."
		oocUsernameText = "Pseudo OOC:"
		phoneAdText = "Contact:"
		postedByText = "Posté par:"
		postedDateText = "Date:"
	--ADVERTS PAGE END
	
	--/AME'S, NOTIFICATIONS ETC FOR PHONE START
		pullPhoneOutText = "prend son téléphone."
		pullPhoneOutText2 = "prend son %s."
		putsPhoneAwayText = "range son téléphone."
		putsPhoneAwayText2 = "range son %s."
		turnPhoneOnText = "allume son téléphone."
		turnPhoneOffText = "éteint son téléphone."
		sendTextMessageText = "envoie un message."
		receiveTextMessageText = "reçoit un message."
		startCallingText = "appelle quelqu'un."
		startRingingText = "a son téléphone qui sonne."
		answerCallText = "répond au téléphone."
		speakIntoPhoneText = "Utilisez /p ou /t pour parler normalement (hors téléphone)."
		endCallText = "raccroche."
		smsReceivedText = "SMS reçu %s (sur %s)."
		theNumberText = "du numéro "
		theContactText = "de "
		theNumberCallingText = "Le numéro "
		phoneIsCallingText = "%s vous appelle (sur %s)."
		phoneIsCalling2Text = "vous appelle!"
		pTalkText = "[Téléphone]"
		loudSpeakerText = "[Téléphone en haut parleur]"
		radioChatText = "[RADIO]"
	--/AME'S, NOTIFICATIONS ETC FOR PHONE END
	
	--UPDATE V2.0 FIX: 
		advertOutputText = "PUBLICITÉ"
		advertFirstTimeText = "Hey, c'est la première fois que vous venez ici! \n\nChoisissez un pseudo:"
		changeLaterText = "Vous ne pourrez plus changer!"
		saveUsernameText = "Sauvegarder"
		welcomeBackText = "Bienvenue,"
		youCurrentlyHaveText = "Vous avez"
		activeListingsText = "annonces actives."
		otherAdvertsTitleText = "Autres:"
		propertyAdvertsTitleText = "Propriétés:"
		vehicleAdvertsTitleText = "Véhicules:"
		checkWallpaperText = "Check"
		saveWallpaperText = "Sauvegarder"
		homeTabText = "Home"
		propertyTabText = "Propriétés"
		vehiclesTabText = "Véhicules"
		otherTabText = "Autres"
		
		crimesTabText = "Crimes"
		eventsTabText = "Events"
		latestNewsText = "Latest News:"
		editNewsTitleText = "Edit News"
		editNewsText = "Edit News"
		deleteNewsText = "Delete News"
-- VARIABILIZED NAMES ETC FOR THE PHONE, EASIER TRANSLATION. END

-- Global functions
function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
    
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
    
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
    
    return timestamp
end

function getATimeStamp()
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second

    local monthday = time.monthday
	local month = time.month
	local year = time.year

    local formattedTime = string.format("%02d-%02d %02d:%02d", month + 1, monthday, hours, minutes)
	return formattedTime
end

local extensions = { 
	[".jpg"] = true,
	[".png"] = true,
}

function isURLValid(url)
	local url = url:lower()
	local _extensions = ""
	
	for extension, _ in pairs ( extensions ) do
		if _extensions ~= "" then
			_extensions = _extensions .. ", " .. extension
		else
			_extensions = extension
		end
		
		if string.find ( url, extension, 1, true ) then
			return true
		end
	end
	
	return false, "Invalid image extension. Accepted types are: " .. _extensions
end

function table.reverse(t) 
    local reversedTable = {} 
    local itemCount = #t  
    for k, v in ipairs(t) do 
        reversedTable[itemCount + 1 - k] = v  
    end 
    return reversedTable  
end 

alphabetSortFunc = [[
	local arg = {...}
	local a = arg[1]
	local b = arg[2]
	local column = dgsElementData[self].sortColumn
	local texta,textb = a[column][1],b[column][1]
	return texta < textb
]]

function getPhoneTime()
	local hour, minute = getTime()
	return string.format("%02d:%02d", hour, minute)
end

function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0
    local iter = function()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end