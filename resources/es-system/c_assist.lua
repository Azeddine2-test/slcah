local backupBlips, backupPlayers = {}, {};
addEvent('createBackupBlip2', true);
addEvent('destroyBackupBlip2', true);

addEventHandler('createBackupBlip2', root, function()
	--> Check: If the blip is already created
	if backupBlips[source] then destroyElement(backupBlips[source]); backupBlips[source] = nil; end;

	--> Create the blip
	local x, y, z = getElementPosition(source);
	local r, g, b = math.random(0, 255), math.random(0, 255), math.random(0, 255);
	backupBlips[source] = createBlip(x, y, z, 0, 3, r, g, b, 255, 255, 32767);
	attachElements(backupBlips[source], source);
end);

addEventHandler('destroyBackupBlip2', root, function()
	--> Check: If the blip is already created
	if backupBlips[source] then destroyElement(backupBlips[source]); backupBlips[source] = nil; end;
end);