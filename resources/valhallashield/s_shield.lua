function callHome(scripter, admin, fulladmin, superadmin, leadadmin, headadmin)
	if ( getElementData(client, "loggedin") == 1 ) then -- Logged in
		local serverscripter = exports.global:isPlayerScripter(client)
		local serveradmin = exports.global:isPlayerAdmin(client)
		local serverfulladmin = exports.global:isPlayerFullAdmin(client)
		local serversuperadmin = exports.global:isPlayerSuperAdmin(client)
		local serverleadadmin = exports.global:isPlayerLeadAdmin(client)
		local serverheadadmin = exports.global:isPlayerHeadAdmin(client)
	
		if ( (client~=source) or (scripter and not serverscripter) or (admin and not serveradmin) or (admin~=serveradmin) or (fulladmin~=serverfulladmin) or (superadmin~=serversuperadmin) or (leadadmin~=serverleadadmin) or (headadmin~=serverheadadmin) ) then
			local msg = "[AdmWarn] " .. getPlayerName(client) .. " was detected with a hacked client. Player has been banned."
			exports.global:sendMessageToAdmins(msg)
			local accountusername = getElementData(client, "gameaccountusername")
			if ( accountusername ~= nil ) then
				exports.mysql:query_free("UPDATE accounts set banned=1, banned_reason='Hacked Client.', banned_by='Valhalla Shield' where username='" .. exports.mysql:escape_string(accountusername) .. "' LIMIT 1")
			end
			
			local ban = banPlayer(client, true, false, false, getRootElement(), "Hacked Client.", 0)
		else
			triggerClientEvent(client, "callbackOK", client)
		end
	else
		triggerClientEvent(client, "callbackUnknown", client)
	end
end
addEvent("callhome", true)
addEventHandler("callhome", getRootElement(), callHome)

function reconHack(player, alpha)
	exports.global:sendMessageToAdmins( "[AdmWarn] " .. getPlayerName(client) .. " was detected with a recon hack. Be sure to investigate this and possibly ban." )
	exports.global:sendMessageToAdmins( "[AdmWarn] Player saw: " .. getPlayerName(player) .. " with alpha: " .. tostring(alpha) .. ". The legit alpha is: " .. tostring(getElementAlpha(player)) .. "." )
end
addEvent("reconhack", true)
addEventHandler("reconhack", getRootElement(), reconHack)