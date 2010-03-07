mysql = exports.mysql

----------------------[KEY BINDS]--------------------
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		setElementData(arrayPlayer, "friends.visible", 0, true)
		if not(isKeyBound(arrayPlayer, "o", "down", "friends")) then
			bindKey(arrayPlayer, "o", "down", "friends")
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "o", "down", "friends")
	
	setElementData(source, "friends.visible", 0, true)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function toggleFriends(source)
	local logged = getElementData(source, "gameaccountloggedin")
	
	if logged == 1 then
		local visible = getElementData(source, "friends.visible")
		
		if visible == 0 then -- not already showing
			local accid = tonumber(getElementData(source, "gameaccountid"))
			
			local achresult = mysql:query_fetch_assoc("SELECT COUNT(*) as tempnr FROM achievements WHERE account='" .. accid .. "' LIMIT 1")
			local myachievements = achresult["tempnr"]
			
			-- load friends list
			local result = mysql:query("SELECT f.friend, a.username, a.friendsmessage, DATEDIFF(NOW(), a.lastlogin) as daytimediff, a.country, ( SELECT COUNT(*) FROM achievements b WHERE b.account = a.id ) as archievements, HOUR(TIMEDIFF(NOW(), a.lastlogin)) as hourtimediff, MINUTE(TIMEDIFF(NOW(), a.lastlogin)) as minutetimediff FROM friends f LEFT JOIN accounts a ON f.friend = a.id WHERE f.id = ".. accid .. " ORDER BY a.lastlogin DESC" )
			if result then
				local friends = { }
				local run = true
				while run do
					local row = exports.mysql:fetch_assoc(result)
					if not (row) then
						break
					end
					local id = tonumber( row["friend"] )
					local account = row["username"]
					
					if account == mysql_null( ) then -- account doesn't exist any longer, drop friends
						mysql:query_free("DELETE FROM friends WHERE id = " .. id .. " OR friend = " .. id )
					else
						-- Last online
						local time = getRealTime()
						local years = (1900+time.year)
						local yearday = time.yearday

						local timeoffline = tonumber( row["daytimediff"] ) -- time offline
						local hour, minute = tonumber( row["hourtimediff"] ), tonumber( row["minutetimediff"] )
						
						local player = nil
						for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
							if isElement(value) and getElementData(value, "gameaccountid") == id then
								player = value
								break
							end
						end
						
						local state = "Offline"
						
						if player then
							table.insert( friends, 1, { id, account, row["friendsmessage"], row["country"], tonumber( row["archievements"] ) } )
						else
							table.insert( friends, { id, account, row["friendsmessage"], row["country"], tonumber( row["archievements"] ), timeoffline, hour == 0 and -minute or hour } )
						end
					end
				end
				
				mysql:free_result( result )
				
				local friendsmessage = ""
				local result = mysql:query_fetch_assoc("SELECT friendsmessage FROM accounts WHERE id = " .. accid )
				if result then
					friendsmessage = result["friendsmessage"]
					if friendsmessage == mysql_null( ) then
						friendsmessage = ""
					end
				else
					outputDebugString( "Friendmessage load failed:  s_friends.lua\toggleFriends" )
				end
				triggerClientEvent( source, "showFriendsList", source, friends, friendsmessage, myachievements )
			else
				outputDebugString( "Friends load failed: s_friends.lua\toggleFriends" )
				outputChatBox("Error 600000 - Could not retrieve friends list.", source, 255, 0, 0)
			end
		else
			triggerClientEvent( source, "hideFriendsList", source )
		end
	end
end
addCommandHandler("friends", toggleFriends)
addEvent("sendFriends", false)
addEventHandler("sendFriends", getRootElement(), toggleFriends)

function updateFriendsMessage(message)
	local safemessage = mysql:escape_string(tostring(message))
	local accid = getElementData(source, "gameaccountid")
	
	local query = mysql:query_free("UPDATE accounts SET friendsmessage='" .. safemessage .. "' WHERE id='" .. accid .. "'")
	if not (query) then
		outputChatBox("Error updating friends message - ensure you used no special characters!", source, 255, 0, 0)
	end
end
addEvent("updateFriendsMessage", true)
addEventHandler("updateFriendsMessage", getRootElement(), updateFriendsMessage)

function removeFriend(id, username)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local result = mysql:query_free("DELETE FROM friends WHERE id = " .. accid .. " AND friend = " .. id )
	if result then
		local friends = getElementData(source, "friends")
		if friends then
			friends[ tonumber(id) ] = nil
			setElementData(source, "friends", friends, false)
		end
	end
end
addEvent("removeFriend", true)
addEventHandler("removeFriend", getRootElement(), removeFriend)

function addFriendToDB(player, source)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local targetID = tonumber(getElementData(player, "gameaccountid"))
	local countresult = mysql:query_fetch_assoc("SELECT COUNT(*) as tempnr FROM friends WHERE id='" .. accid .. "' LIMIT 1")
	local count = tonumber(countresult["tempnr"])
	if (count >=23) then
		outputChatBox("Your friends list is currently full.", source, 255, 0, 0)
	else
		local friends = getElementData(source, "friends")	
		if friends then
			if (friends[ targetID ] == true) then
				outputChatBox("'" .. getPlayerName(player) .. "' is already on your friends list.", source, 255, 194, 14)
			else 
				local result = mysql:query_free("INSERT INTO friends VALUES (" .. accid .. ", " .. targetID .. ")")
				if result then
					friends[ targetID ] = true
					setElementData(source, "friends", friends, false)
				
					outputChatBox("'" .. getPlayerName(player) .. "' was added to your friends list.", source, 255, 194, 14)
				else
					outputDebugString( "Add Friend failed in s_friends.lua\addFriendToDB")
				end
			end
		end
	end
end

function acceptFriendRequest(player)
	addFriendToDB(player, source)
	addFriendToDB(source, player)
end
addEvent("acceptFriendSystemRequest", true)
addEventHandler("acceptFriendSystemRequest", getRootElement(), acceptFriendRequest)

function declineFriendRequest(targetPlayer)
	outputChatBox(getPlayerName(source):gsub("_", " ") .. " declined your friend request.", targetPlayer, 255, 0, 0)
	outputChatBox(" You have declined ".. getPlayerName(targetPlayer):gsub("_", " ") .."'s friend request.", source, 255, 0, 0)
end
addEvent("declineFriendSystemRequest", true)
addEventHandler("declineFriendSystemRequest", getRootElement(), declineFriendRequest)
