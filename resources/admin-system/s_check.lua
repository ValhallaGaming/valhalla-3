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
						local result = mysql:query_fetch_assoc("SELECT adminnote, warns FROM accounts WHERE id = " .. tostring(getElementData(noob, "gameaccountid")) )
						if result then
							local text = result["adminnote"]
							if text ~= mysql_null() then
								note = text
							end
							
							warns = tonumber( result["warns"] ) or "?"
						end
						
						-- get admin history count
						local history = '?'
						local result = mysql:query_fetch_assoc("SELECT COUNT(*) as numbr FROM adminhistory WHERE user = " .. tostring(getElementData(noob, "gameaccountid")) )
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
			local result = mysql:query_free("UPDATE accounts SET adminnote = '" .. mysql:escape_string( text ) .. "' WHERE id = " .. account )
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
			local result = mysql:query("SELECT date, action, reason, duration, a.username as username, user_char FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin WHERE user = " .. targetID .. " ORDER BY h.id DESC" )
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

addCommandHandler( "history", 
	function( thePlayer, commandName, ... )
		if exports.global:isPlayerAdmin( thePlayer ) then
			if not (...) then
				outputChatBox("SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
			else
				local targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, table.concat({...},"_"))
				local logged = getElementData(targetPlayer, "loggedin")
				if targetPlayer then
					if (logged==0) then
						outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
					else
						triggerEvent("showAdminHistory", thePlayer, targetPlayer)
					end
				end
			end
		end
	end
)