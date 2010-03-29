function alertSobeit(count)
	local msg = "[AdmWarn][Count: " .. tostring(count) .. "] " .. getPlayerName(client) .. " has s0beit running!"
	exports.global:sendMessageToAdmins(msg)
end
addEvent("alertSobeit", true)
addEventHandler("alertSobeit", getRootElement(), alertSobeit)