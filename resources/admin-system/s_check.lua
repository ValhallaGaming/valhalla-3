function doCheck(sourcePlayer, command, ...)
	if (exports.global:isPlayerAdmin(sourcePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. command .. " [Partial Player Name / ID]", sourcePlayer, 255, 194, 14)
		else
			local noob = exports.global:findPlayerByPartialNick(sourcePlayer, table.concat({...},"_"))
			if (noob) then
				local logged = getElementData(noob, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", sourcePlayer, 255, 0, 0)
				else
					if noob and isElement(noob) then
						local ip = getPlayerIP(noob)
						local adminreports = tonumber(getElementData(noob, "adminreports"))
						local donatorlevel = exports.global:getPlayerDonatorTitle(noob)
						
						-- get admin note
						local note = ""
						local warns = "?"
						local result = mysql:query_fetch_assoc("SELECT adminnote, warns FROM accounts WHERE id = " .. mysql:escape_string(tostring(getElementData(noob, "gameaccountid"))) )
						if result then
							local text = result["adminnote"]
							if text ~= mysql_null() then
								note = text
							end
							
							warns = tonumber( result["warns"] ) or "?"
						end
						
						-- get admin history count
						local history = '?'
						local result = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM adminhistory WHERE user = " .. mysql:escape_string(tostring(getElementData(noob, "gameaccountid"))) )
						if result then
							history = tonumber( result["numbr"] ) or '?'
						end
						
						triggerClientEvent( sourcePlayer, "onCheck", noob, ip, adminreports, donatorlevel, note, history, warns)
					end
				end
			end
		end
	end
end
addCommandHandler("check", doCheck)

function savePlayerNote( target, text )
	if exports.global:isPlayerAdmin(source) then
		local account = getElementData(target, "gameaccountid")
		if account then
			local result = mysql:query_free("UPDATE accounts SET adminnote = '" .. mysql:escape_string( text ) .. "' WHERE id = " .. mysql:escape_string(account) )
			if result then
				outputChatBox( "Note for the " .. getPlayerName( target ):gsub("_", " ") .. " (" .. getElementData( target, "gameaccountusername" ) .. ") has been updated.", source, 0, 255, 0 )
			else
				outputChatBox( "Note Update failed.", source, 255, 0, 0 )
			end
		else
			outputChatBox( "Unable to get Account ID.", source, 255, 0, 0 )
		end
	end
end
addEvent( "savePlayerNote", true )
addEventHandler( "savePlayerNote", getRootElement(), savePlayerNote )

function showAdminHistory( target )
	if exports.global:isPlayerAdmin( source ) then
		local targetID = getElementData( target, "gameaccountid" )
		if targetID then
			local result = mysql:query("SELECT date, action, reason, duration, a.username as username, user_char FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin WHERE user = " .. mysql:escape_string(targetID) .. " ORDER BY h.id DESC" )
			if result then
				local info = {}
				local continue = true
				while continue do
					local row = mysql:fetch_assoc(result)
					if not row then break end
					
					local tempr = {}
					tempr[1] = row["date"]
					tempr[2] = row["action"]
					tempr[3] = row["reason"]
					tempr[4] = row["duration"]
					tempr[5] = row["username"]
					tempr[6] = row["user_char"]
					
					table.insert( info, tempr )
				end
				
				triggerClientEvent( source, "cshowAdminHistory", target, info )
				mysql:free_result( result )
			else
				outputChatBox( "Failed to retrieve history.", source, 255, 0, 0)
			end
		else
			outputChatBox("Unable to find the account id.", source, 255, 0, 0)
		end
	end
end
addEvent( "showAdminHistory", true )
addEventHandler( "showAdminHistory", getRootElement(), showAdminHistory )

function showOfflineAdminHistory( gameaccountid )
	if exports.global:isPlayerAdmin( source ) and tonumber(gameaccountid) then
		local targetID = gameaccountid
		local result = mysql:query("SELECT date, action, reason, duration, a.username, user_char FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin WHERE user = " .. mysql:escape_string(targetID) .. " ORDER BY h.id DESC" )
		if result then
			local info = {}
			local continue = true
			while continue do
				local row = mysql:fetch_assoc(result)
				if not row then break end
				local record = {}
				record[1] = row["date"]
				record[2] = row["action"]
				record[3] = row["reason"]
				record[4] = row["duration"]
				record[5] = row["username"]
				record[6] = row["user_char"]
				
				table.insert( info, record )
			end
			triggerClientEvent( source, "cshowAdminHistory", source, info )
			mysql:free_result( result )
		else
			outputDebugString( "admin-system\showOfflineAdminHistory: Error." )
			outputChatBox( "Failed to retrieve history.", source, 255, 0, 0)
		end
	end
end
addEvent( "showOfflineAdminHistory", true )
addEventHandler( "showOfflineAdminHistory", getRootElement(), showOfflineAdminHistory )

addCommandHandler( "history", 
	function( thePlayer, commandName, ... )
		if exports.global:isPlayerAdmin( thePlayer ) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(nil, table.concat({...},"_"))
				if targetPlayer then
					local logged = getElementData(targetPlayer, "loggedin")
					if (logged==0) then
						outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
					else
						triggerEvent("showAdminHistory", thePlayer, targetPlayer)
					end
				else
					local targetPlayerName = table.concat({...},"_")
					-- select by charactername
					local result = mysql:query("SELECT account FROM characters WHERE charactername = '" .. mysql:escape_string(targetPlayerName ) .. "'" )
					if result then
						if mysql:num_rows( result ) == 1 then
							local row = mysql:fetch_assoc(result)
							local id = row["account"] or '0'
							triggerEvent("showOfflineAdminHistory", thePlayer, id)
							mysql:free_result( result )
							return
						else
							-- select by account
							local result2 = mysql:query("SELECT id FROM accounts WHERE username = '" .. mysql:escape_string( targetPlayerName ) .. "'" )
							if result2 then
								if mysql:num_rows( result2 ) == 1 then
									local row2 = mysql:fetch_assoc(result2)
									local id = tonumber( row2["id"] ) or '0'
									triggerEvent("showOfflineAdminHistory", thePlayer, id)
									mysql:free_result( result2 )
									return
								end
								mysql:free_result( result2 )
							end
						end
						mysql:free_result( result )
					end
					outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
)