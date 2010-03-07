-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

local unemployedPay = 150
local result = mysql_query( handler, "SELECT value FROM settings WHERE name = 'welfare'" )
if result then
	if mysql_num_rows( result ) == 0 then
		mysql_free_result( mysql_query( handler, "INSERT INTO settings (name, value) VALUES ('welfare', " .. unemployedPay .. ")" ) )
	else
		unemployedPay = tonumber( mysql_result( result, 1, 1 ) ) or 150
	end
	mysql_free_result( result )
end
result = nil

-- EVENTS
addEvent("onPlayerJoinFaction", false)
addEventHandler("onPlayerJoinFaction", getRootElement(),
	function(theTeam)
		local id = getElementData(theTeam, "id")
		if id == 1 then
			exports.global:givePlayerAchievement(source, 2)
		elseif id == 2 then
			exports.global:givePlayerAchievement(source, 5)
		elseif id == 3 then
			exports.global:givePlayerAchievement(source, 6)
		end
	end
)

function loadAllFactions(res)
	-- work out how many minutes it is until the next hour
	local mins = getRealTime().minute
	local minutes = 60 - mins
	setTimer(payAllWages, 60000*minutes, 1, true)
	
	local result = mysql_query(handler, "SELECT id, name, bankbalance, type FROM factions")
	local counter = 0
	
	if (result) then
		for result, row in mysql_rows(result) do
			local id = tonumber(row[1])
			local name = row[2]
			local money = tonumber(row[3])
			local factionType = tonumber(row[4])
			
			local theTeam = createTeam(tostring(name))
			exports.pool:allocateElement(theTeam, id)
			setElementData(theTeam, "type", factionType)
			setElementData(theTeam, "money", money)
			setElementData(theTeam, "id", id)
			
			local query2 = mysql_query(handler, "SELECT rank_1, rank_2, rank_3, rank_4, rank_5, rank_6, rank_7, rank_8, rank_9, rank_10, rank_11, rank_12, rank_13, rank_14, rank_15 FROM factions WHERE id='" .. id .. "' LIMIT 1")
			local query3 = mysql_query(handler, "SELECT wage_1, wage_2, wage_3, wage_4, wage_5, wage_6, wage_7, wage_8, wage_9, wage_10, wage_11, wage_12, wage_13, wage_14, wage_15, motd FROM factions WHERE id='" .. id .. "' LIMIT 1")
								
			local rank1, rank2, rank3, rank4, rank5, rank6, rank7, rank8, rank9, rank10, rank11, rank12, rank13, rank14, rank15 = mysql_result(query2, 1, 1), mysql_result(query2, 1, 2), mysql_result(query2, 1, 3), mysql_result(query2, 1, 4), mysql_result(query2, 1, 5), mysql_result(query2, 1, 6), mysql_result(query2, 1, 7), mysql_result(query2, 1, 8), mysql_result(query2, 1, 9), mysql_result(query2, 1, 10), mysql_result(query2, 1, 11), mysql_result(query2, 1, 12), mysql_result(query2, 1, 13), mysql_result(query2, 1, 14), mysql_result(query2, 1, 15)
			local wage1, wage2, wage3, wage4, wage5, wage6, wage7, wage8, wage9, wage10, wage11, wage12, wage13, wage14, wage15 = mysql_result(query3, 1, 1), mysql_result(query3, 1, 2), mysql_result(query3, 1, 3), mysql_result(query3, 1, 4), mysql_result(query3, 1, 5), mysql_result(query3, 1, 6), mysql_result(query3, 1, 7), mysql_result(query3, 1, 8), mysql_result(query3, 1, 9), mysql_result(query3, 1, 10), mysql_result(query3, 1, 11), mysql_result(query3, 1, 12), mysql_result(query3, 1, 13), mysql_result(query3, 1, 14), mysql_result(query3, 1, 15)
	
			local factionRanks = {rank1, rank2, rank3, rank4, rank5, rank6, rank7, rank8, rank9, rank10, rank11, rank12, rank13, rank14, rank15 }
			local factionWages = {wage1, wage2, wage3, wage4, wage5, wage6, wage7, wage8, wage9, wage10, wage11, wage12, wage13, wage14, wage15 }
			for k, v in ipairs(factionWages) do
				factionWages[k] = tonumber(v)
			end
			local motd = mysql_result(query3, 1, 16)
			setElementData(theTeam, "ranks", factionRanks, false)
			setElementData(theTeam, "wages", factionWages, false)
			setElementData(theTeam, "motd", motd, false)
								
			mysql_free_result(query2)
			mysql_free_result(query3)
			counter = counter + 1
		end
		mysql_free_result(result)
		
		local citteam = createTeam("Citizen", 255, 255, 255)
		exports.pool:allocateElement(citteam, -1)
		
		-- set all players into their appropriate faction
		local players = exports.pool:getPoolElementsByType("player")
		for k, thePlayer in ipairs(players) do
			local username = getPlayerName(thePlayer)
			local safeusername = mysql_escape_string(handler, username)
			
			local result = mysql_query(handler, "SELECT faction_id FROM characters WHERE charactername='" .. safeusername .. "' LIMIT 1")
			if (result) then
				local factionID = tonumber(mysql_result(result, 1, 1))

				setElementData(thePlayer, "factionMenu", 0)
				setElementData(thePlayer, "faction", factionID)
				
				mysql_free_result(result)
				if (factionID) then
					if (factionID~=-1) then
						result = mysql_query(handler, "SELECT name FROM factions WHERE id='" .. factionID .. "' LIMIT 1")

						if (result) then
							local factionName = tostring(mysql_result(result, 1, 1))
							local theTeam = getTeamFromName(factionName)
							setPlayerTeam(thePlayer, theTeam)
							mysql_free_result(result)
						end
					else
						local theTeam = getTeamFromName("Citizen")
						setPlayerTeam(thePlayer, theTeam)
					end
				end
			end
		end
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " factions.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllFactions)

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "F3", "down", showFactionMenu)) then
			bindKey(arrayPlayer, "F3", "down", showFactionMenu)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F3", "down", showFactionMenu)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showFactionMenu(source)
	local logged = getElementData(source, "loggedin")
	
	if (logged==1) then
		local menuVisible = getElementData(source, "factionMenu")
		
		if (menuVisible==0) then
			local factionID = getElementData(source, "faction")
			
			if (factionID~=-1) then
				local theTeam = getPlayerTeam(source)
				local query = mysql_query(handler, "SELECT charactername, faction_rank, faction_leader, DATEDIFF(NOW(), lastlogin) FROM characters WHERE faction_ID='" .. factionID .. "' ORDER BY faction_rank DESC, charactername ASC")
				if (query) then
					
					local memberUsernames = {}
					local memberRanks = {}
					local memberLeaders = {}
					local memberOnline = {}
					local memberLastLogin = {}
					local memberLocation = {}
					local factionRanks = getElementData(theTeam, "ranks")
					local factionWages = getElementData(theTeam, "wages")
					local motd = getElementData(theTeam, "motd")
					
					if (motd == "") then motd = nil end
					
					local i = 1
					for result, row in mysql_rows(query) do
						local playerName = row[1]
						memberUsernames[i] = playerName
						memberRanks[i] = row[2]
						
						if (tonumber(row[3])==1) then
							memberLeaders[i] = true
						else
							memberLeaders[i] = false
						end
						
						local login = ""
						
						memberLastLogin[i] = tonumber(row[4])
						
						
						local targetPlayer = getPlayerFromName(tostring(playerName))
						if (targetPlayer) then
							memberOnline[i] = true
							if getElementData(targetPlayer, "hideF3Location") then
								memberLocation[i] = "N/A"
							elseif getElementData(targetPlayer, "loggedin") == 1 then
								local zone, city = exports.global:getElementZoneName(targetPlayer)
								
								if(zone~=city) and (city~=nil) then
									memberLocation[i] = zone .. ", " .. city
								else
									memberLocation[i] = zone
								end
							else
								memberLocation[i] = "Not logged in"
							end
						else
							memberOnline[i] = false
							memberLocation[i] = "N/A"
						end
						i = i + 1
					end
					setElementData(source, "factionMenu", 1)
					mysql_free_result(query)
					
					local theTeam = getPlayerTeam(source)
					triggerClientEvent(source, "showFactionMenu", getRootElement(), motd, memberUsernames, memberRanks, memberLeaders, memberOnline, memberLastLogin, memberLocation, factionRanks, factionWages, theTeam)
				end
			else
				outputChatBox("You are not in a faction.", source)
			end
		else
			triggerClientEvent(source, "hideFactionMenu", getRootElement())
		end
	end
end

-- // CALL BACKS FROM CLIENT GUI
function callbackUpdateRanks(ranks, wages)
	local theTeam = getPlayerTeam(source)
	local factionID = getElementData(theTeam, "id")
	
	for key, value in ipairs(ranks) do
		ranks[key] = mysql_escape_string(handler, ranks[key])
	end
	
	if (wages) then
		for key, value in ipairs(wages) do
			wages[key] = tonumber(wages[key]) or 0
		end
		
		local update = mysql_query(handler, "UPDATE factions SET wage_1='" .. wages[1] .. "', wage_2='" .. wages[2] .. "', wage_3='" .. wages[3] .. "', wage_4='" .. wages[4] .. "', wage_5='" .. wages[5] .. "', wage_6='" .. wages[6] .. "', wage_7='" .. wages[7] .. "', wage_8='" .. wages[8] .. "', wage_9='" .. wages[9] .. "', wage_10='" .. wages[10] .. "', wage_11='" .. wages[11] .. "', wage_12='" .. wages[12] .. "', wage_13='" .. wages[13] .. "', wage_14='" .. wages[14] .. "', wage_15='" .. wages[15] .. "' WHERE id='" .. factionID .. "'")
		mysql_free_result(update)
		setElementData(theTeam, "wages", wages, false)
	end
	
	local query = mysql_query(handler, "UPDATE factions SET rank_1='" .. ranks[1] .. "', rank_2='" .. ranks[2] .. "', rank_3='" .. ranks[3] .. "', rank_4='" .. ranks[4] .. "', rank_5='" .. ranks[5] .. "', rank_6='" .. ranks[6] .. "', rank_7='" .. ranks[7] .. "', rank_8='" .. ranks[8] .. "', rank_9='" .. ranks[9] .. "', rank_10='" .. ranks[10] .. "', rank_11='" .. ranks[11] .. "', rank_12='" .. ranks[12] .. "', rank_13='" .. ranks[13] .. "', rank_14='" .. ranks[14] .. "', rank_15='" .. ranks[15] .. "' WHERE id='" .. factionID .. "'")
	mysql_free_result(query)
	setElementData(theTeam, "ranks", ranks, false)
	
	outputChatBox("Faction information updated successfully.", source, 0, 255, 0)
	showFactionMenu(source)
end
addEvent("cguiUpdateRanks", true )
addEventHandler("cguiUpdateRanks", getRootElement(), callbackUpdateRanks)


function callbackRespawnVehicles()
	local theTeam = getPlayerTeam(source)
	
	local factionCooldown = getElementData(theTeam, "cooldown")
	
	if not (factionCooldown) then
		local factionID = getElementData(theTeam, "id")
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
			local faction = getElementData(value, "faction")
			if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
				respawnVehicle(value)
			end
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		local username = getPlayerName(source)
		for k, v in ipairs(teamPlayers) do
			outputChatBox(username .. " respawned all unoccupied faction vehicles.", v)
		end

		setTimer(resetFactionCooldown, 600000, 1, theTeam)
		setElementData(theTeam, "cooldown", true, false)
	else
		outputChatBox("You currently cannot respawn your factions vehicles, Please wait a while.", source, 255, 0, 0)
	end
end
addEvent("cguiRespawnVehicles", true )
addEventHandler("cguiRespawnVehicles", getRootElement(), callbackRespawnVehicles)

function resetFactionCooldown(theTeam)
	removeElementData(theTeam, "cooldown")
end

function callbackUpdateMOTD(motd)
	local faction = tonumber(getElementData(source, "faction"))
	local theTeam = getPlayerTeam(source)
	
	if (faction~=-1) then
		local safemotd = mysql_escape_string(handler, motd)
		local query = mysql_query(handler, "UPDATE factions SET motd='" .. tostring(safemotd) .. "' WHERE id='" .. faction .. "'")

		if (query) then
			mysql_free_result(query)
			outputChatBox("You changed your faction's MOTD to '" .. motd .. "'", source, 0, 255, 0)
			setElementData(theTeam, "motd", safemotd, false)
		else
			outputChatBox("Error 300000 - Ensure your MOTD does not include characters such as '@!,.", source, 255, 0, 0)
		end
	end
end
addEvent("cguiUpdateMOTD", true )
addEventHandler("cguiUpdateMOTD", getRootElement(), callbackUpdateMOTD)

function callbackRemovePlayer(removedPlayerName)
	local safename = mysql_escape_string(handler, removedPlayerName)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_id='-1', faction_leader='0', faction_rank='1', dutyskin = 0, duty = 0 WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local theTeam = getPlayerTeam(source)
		local theTeamName = "None"
		if (theTeam) then
			theTeamName = getTeamName(theTeam)
		end
		
		local username = getPlayerName(source)
		
		exports.irc:sendMessage("[SCRIPT] " .. username .. " removed " .. removedPlayerName .. " from faction '" .. tostring(theTeamName) .. "'.")
		
		local removedPlayer = getPlayerFromName(removedPlayerName)
		if (removedPlayer) then -- Player is online
			if (getElementData(source, "factionMenu")==1) then
				triggerClientEvent(removedPlayer, "hideFactionMenu", getRootElement())
			end
			outputChatBox(username .. " removed you from the faction '" .. tostring(theTeamName) .. "'", removedPlayer)
			setPlayerTeam(removedPlayer, getTeamFromName("Citizen"))
			setElementData(removedPlayer, "faction", -1, false)
			setElementData(removedPlayer, "dutyskin", -1, false)
			setElementData(removedPlayer, "factionleader", 0, false)
			if getElementData(removedPlayer, "duty") and getElementData(removedPlayer, "duty") > 0 then
				exports.global:takeAllWeapons(removedPlayer)
				setElementData(removedPlayer, "duty", 0, false)
			end
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		for k, v in ipairs(teamPlayers) do
			if (v~=removedPlayer) then
				outputChatBox(username .. " kicked " .. removedPlayerName .. " from faction '" .. tostring(theTeamName) .. "'.", v)
			end
		end
	else
		outputChatBox("Failed to remove " .. removedPlayerName .. " from the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiKickPlayer", true )
addEventHandler("cguiKickPlayer", getRootElement(), callbackRemovePlayer)

function callbackToggleLeader(playerName, isLeader)
	
	if (isLeader) then -- Make player a leader
		local username = getPlayerName(source)
		local safename = mysql_escape_string(handler, playerName)
		
		local query = mysql_query(handler, "UPDATE characters SET faction_leader='1' WHERE charactername='" .. safename .. "'")
		
		if (query) then
			mysql_free_result(query)
			exports.irc:sendMessage("[SCRIPT] " .. username .. " promoted " .. tostring(playerName) .. " to leader.")
			
			-- Send message to everyone in the faction
			local theTeam = getPlayerTeam(source)
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " promoted " .. playerName .. " to leader.", v)
			end
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				setElementData(thePlayer, "factionleader", 1, false)
			end
		else
			outputChatBox("Failed to promote " .. removedPlayerName .. " to faction leader, Contact an admin.", source, 255, 0, 0)
		end
	else
		local username = getPlayerName(source)
		local safename = mysql_escape_string(handler, playerName)
		
		local query = mysql_query(handler, "UPDATE characters SET faction_leader='0' WHERE charactername='" .. safename .. "'")
		
		if (query) then
			mysql_free_result(query)
			exports.irc:sendMessage("[SCRIPT] " .. username .. " demoted " .. tostring(playerName) .. " to member.")
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				if (getElementData(source, "factionMenu")==1) then
					triggerClientEvent(thePlayer, "hideFactionMenu", getRootElement())
				end
				setElementData(thePlayer, "factionleader", 0, false)
			end
			
			-- Send message to everyone in the faction
			local theTeam = getPlayerTeam(source)
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " demoted " .. playerName .. " to member.", v)
			end
		else
			outputChatBox("Failed to demote " .. removedPlayerName .. " from faction leader, Contact an admin.", source, 255, 0, 0)
		end
	end
end
addEvent("cguiToggleLeader", true )
addEventHandler("cguiToggleLeader", getRootElement(), callbackToggleLeader)

function callbackPromotePlayer(playerName, rankNum, oldRank, newRank)
	local username = getPlayerName(source)
	local safename = mysql_escape_string(handler, playerName)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, set his rank
			setElementData(thePlayer, "factionrank", rankNum)
		end
		
		-- Send message to everyone in the faction
		local theTeam = getPlayerTeam(source)
		if (theTeam) then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " promoted " .. playerName .. " from '" .. oldRank .. "' to '" .. newRank .. "'.", v)
			end
		end
	else
		outputChatBox("Failed to promote " .. removedPlayerName .. " in the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiPromotePlayer", true )
addEventHandler("cguiPromotePlayer", getRootElement(), callbackPromotePlayer)

function callbackDemotePlayer(playerName, rankNum, oldRank, newRank)
	local username = getPlayerName(source)
	local safename = mysql_escape_string(handler, playerName)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, tell them
			setElementData(thePlayer, "factionrank", rankNum)
		end
		
		-- Send message to everyone in the faction
		local theTeam = getPlayerTeam(source)
		if (theTeam) then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(username .. " demoted " .. playerName .. " from '" .. oldRank .. "' to '" .. newRank .. "'.", v)
			end
		end
	else
		outputChatBox("Failed to demote " .. removedPlayerName .. " in the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiDemotePlayer", true )
addEventHandler("cguiDemotePlayer", getRootElement(), callbackDemotePlayer)

function callbackQuitFaction()
	local username = getPlayerName(source)
	local safename = mysql_escape_string(handler, username)
	local theTeam = getPlayerTeam(source)
	local theTeamName = getTeamName(theTeam)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_id='-1', faction_leader='0', dutyskin = -1, duty = 0 WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		outputChatBox("You quit the faction '" .. theTeamName .. "'.", source)
		
		local newTeam = getTeamFromName("Citizen")
		setPlayerTeam(source, newTeam)
		setElementData(source, "faction", -1, false)
		setElementData(source, "dutyskin", -1, false)
		if getElementData(source, "duty") and getElementData(source, "duty") > 0 then
			exports.global:takeAllWeapons(source)
			setElementData(source, "duty", 0, false)
		end
		
		-- Send message to everyone in the faction
		if theTeam ~= newTeam then
			local teamPlayers = getPlayersInTeam(theTeam)
			for k, v in ipairs(teamPlayers) do
				if (v~=thePlayer) then
					outputChatBox(username .. " has quit the faction '" .. theTeamName .. "'.", v)
				end
			end
		end
	else
		outputChatBox("Failed to quit the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiQuitFaction", true )
addEventHandler("cguiQuitFaction", getRootElement(), callbackQuitFaction)

function callbackInvitePlayer(invitedPlayer)
	local faction = tonumber(getElementData(source, "faction"))

	local invitedPlayerNick = getPlayerName(invitedPlayer)
	local safename = mysql_escape_string(handler, invitedPlayerNick)
	
	local query = mysql_query(handler, "UPDATE characters SET faction_leader = 0, faction_id = " .. faction .. ", faction_rank = 1, dutyskin = -1 WHERE charactername='" .. safename .. "'")
	
	if (query) then
		mysql_free_result(query)
		local theTeam = getPlayerTeam(source)
		local theTeamName = getTeamName(theTeam)
		
		local targetTeam = getPlayerTeam(invitedPlayer)
		if (targetTeam~=nil) and (getTeamName(targetTeam)~="Citizen") then
			outputChatBox("Player is already in a faction.", source, 255, 0, 0)
		else
			setPlayerTeam(invitedPlayer, theTeam)
			setElementData(invitedPlayer, "faction", faction)
			outputChatBox("Player " .. invitedPlayerNick .. " is now a member of faction '" .. tostring(theTeamName) .. "'.", source, 0, 255, 0)
							
			if	(invitedPlayer) then
				triggerEvent("onPlayerJoinFaction", invitedPlayer, theTeam)
				setElementData(invitedPlayer, "factionrank", 1)
				setElementData(invitedPlayer, "dutyskin", -1, false)
				outputChatBox("You were set to Faction '" .. tostring(theTeamName) .. ".", invitedPlayer, 255, 194, 14)
			end
		end
	else
		outputChatBox("Player is already in a faction.", source, 255, 0, 0)
	end
end
addEvent("cguiInvitePlayer", true )
addEventHandler("cguiInvitePlayer", getRootElement(), callbackInvitePlayer)

-- // ADMIN COMMANDS
function createFaction(thePlayer, commandName, factionType, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction Type 0=GANG, 1=MAFIA, 2=LAW, 3=GOV, 4=MED, 5=OTHER, 6=NEWS][Faction Name]", thePlayer, 255, 194, 14)
		else
			factionName = table.concat({...}, " ")
			factionType = tonumber(factionType)
			
			local theTeam = createTeam(tostring(factionName))
			if theTeam then
				local query = mysql_query(handler, "INSERT INTO factions SET name='" .. mysql_escape_string(handler, factionName) .. "', bankbalance='0', type='" .. mysql_escape_string(handler, factionType) .. "'")
				
				if (query) then
					local id = mysql_insert_id(handler)
					mysql_free_result(query)
					exports.pool:allocateElement(theTeam, id)
					
					query = mysql_query(handler, "UPDATE factions SET rank_1='Dynamic Rank #1', rank_2='Dynamic Rank #2', rank_3='Dynamic Rank #3', rank_4='Dynamic Rank #4', rank_5='Dynamic Rank #5', rank_6='Dynamic Rank #6', rank_7='Dynamic Rank #7', rank_8='Dynamic Rank #8', rank_9='Dynamic Rank #9', rank_10='Dynamic Rank #10', rank_11='Dynamic Rank #11', rank_12='Dynamic Rank #12', rank_13='Dynamic Rank #13', rank_14='Dynamic Rank #14', rank_15='Dynamic Rank #15', motd='Welcome to the faction.' WHERE id='" .. id .. "'")
					mysql_free_result(query)
					outputChatBox("Faction " .. factionName .. " created with ID #" .. id .. ".", thePlayer, 0, 255, 0)
					setElementData(theTeam, "type", tonumber(factionType))
					setElementData(theTeam, "id", tonumber(id))
					setElementData(theTeam, "money", 0)
					
					local factionRanks = {}
					local factionWages = {}
					for i = 1, 15 do
						factionRanks[i] = "Dynamic Rank #" .. i
						factionWages[i] = 100
					end
					setElementData(theTeam, "ranks", factionRanks, false)
					setElementData(theTeam, "wages", factionWages, false)
					setElementData(theTeam, "motd", "Welcome to the faction.", false)
				else
					destroyElement(theTeam)
					outputChatBox("Error creating faction.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Faction '" .. tostring(factionName) .. "' already exists.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("makefaction", createFaction, false, false)

function adminRenameFaction(thePlayer, commandName, factionID, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID) or not (...)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Faction Name]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				if (theTeam) then
					local factionName = table.concat({...}, " ")
					local updated = mysql_query(handler, "UPDATE factions SET name='" .. mysql_escape_string(handler, factionName) .. "' WHERE id='" .. factionID .. "'")
					
					setTeamName(theTeam, factionName)
					
					mysql_free_result(updated)
					outputChatBox("Faction #" .. factionID .. " was renamed to " .. factionName .. ".", thePlayer, 0, 255, 0)
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("renamefaction", adminRenameFaction, false, false)

function adminSetPlayerFaction(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Faction ID (-1 for none)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end

				local query = mysql_query(handler, "UPDATE characters SET faction_leader = 0, faction_id = " .. factionID .. ", faction_rank = 1, duty = 0, dutyskin = -1 WHERE id=" .. getElementData(targetPlayer, "dbid"))
				
				if (query) then
					mysql_free_result(query)
				
					setPlayerTeam(targetPlayer, theTeam)
					if factionID > 0 then
						setElementData(targetPlayer, "faction", factionID)
						setElementData(targetPlayer, "factionrank", 1)
						setElementData(targetPlayer, "dutyskin", -1, false)
						if getElementData(targetPlayer, "duty") and getElementData(targetPlayer, "duty") > 0 then
							exports.global:takeAllWeapons(targetPlayer)
							setElementData(targetPlayer, "duty", 0, false)
						end
						
						outputChatBox("Player " .. targetPlayerNick .. " is now a member of faction '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
						triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
						outputChatBox("You were set to Faction '" .. getTeamName(theTeam) .. ".", targetPlayer, 255, 194, 14)
						
						exports.logs:logMessage("[FACTION] " .. getPlayerName( thePlayer ) .. " set " .. getPlayerName( targetPlayer ) .. " to faction " .. getTeamName(theTeam) .. " (#" .. factionID .. ")", 15)
					else
						setElementData(targetPlayer, "faction", -1)
						setElementData(targetPlayer, "factionrank", 1)
						setElementData(targetPlayer, "dutyskin", -1, false)
						if getElementData(targetPlayer, "duty") and getElementData(targetPlayer, "duty") > 0 then
							exports.global:takeAllWeapons(targetPlayer)
							setElementData(targetPlayer, "duty", 0, false)
						end
						
						outputChatBox("Player " .. targetPlayerNick .. " was set to no faction.", thePlayer, 0, 255, 0)
						outputChatBox("You were removed from your faction.", targetPlayer, 255, 0, 0)
						
						exports.logs:logMessage("[FACTION] " .. getPlayerName( thePlayer ) .. " set " .. getPlayerName( targetPlayer ) .. " to no faction", 15)
					end
				end
			end
		end
	end
end
addCommandHandler("setfaction", adminSetPlayerFaction, false, false)

function adminSetFactionLeader(thePlayer, commandName, partialNick, factionID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name] [Faction ID]", thePlayer, 255, 194, 14)
		elseif factionID > 0 then
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end
				
				local query = mysql_query(handler, "UPDATE characters SET faction_leader = 1, faction_id = " .. tonumber(factionID) .. ", faction_rank = 1, dutyskin = -1, duty = 0 WHERE id = " .. getElementData(targetPlayer, "dbid"))
				
				if (query) then
					mysql_free_result(query)
					setPlayerTeam(targetPlayer, theTeam)
					setElementData(targetPlayer, "faction", factionID, false)
					setElementData(targetPlayer, "factionrank", 1)
					setElementData(targetPlayer, "dutyskin", -1, false)
					if getElementData(targetPlayer, "duty") and getElementData(targetPlayer, "duty") > 0 then
						exports.global:takeAllWeapons(targetPlayer)
						setElementData(targetPlayer, "duty", 0, false)
					end
					
					outputChatBox("Player " .. targetPlayerNick .. " is now a leader of faction '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
					triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
					outputChatBox("You were set to the leader of Faction '" .. getTeamName(theTeam) .. ".", targetPlayer, 255, 194, 14)
					
					exports.logs:logMessage("[FACTIONLEADER] " .. getPlayerName( thePlayer ) .. " set " .. getPlayerName( targetPlayer ) .. " to factionleader of " .. getTeamName(theTeam) .. " (#" .. factionID .. ")", 15)
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setfactionleader", adminSetFactionLeader, false, false)

function adminDeleteFaction(thePlayer, commandName, factionID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				
				if (theTeam) then
					if factionID == 57 then
						outputChatBox("So you did it! HA! Logged. Now stop deleting factions needed for the script. -Mount", thePlayer, 255, 0, 0)
						exports.logs:logMessage("[BANKFACTION] " .. getPlayerName( thePlayer ) .. " tried to delete faction " .. getTeamName(theTeam) .. " (#" .. factionID .. ")", 15)
					else
						local deleted = mysql_query(handler, "DELETE FROM factions WHERE id='" .. factionID .. "'")
						
						mysql_free_result(deleted)
						outputChatBox("Faction #" .. factionID .. " was deleted.", thePlayer, 0, 255, 0)
						exports.logs:logMessage("[FACTION] " .. getPlayerName( thePlayer ) .. " deleted faction " .. getTeamName(theTeam) .. " (#" .. factionID .. ")", 15)
						local civTeam = getTeamFromName("Citizen")
						for key, value in pairs( getPlayersInTeam( theTeam ) ) do
							setPlayerTeam( value, civTeam )
							setElementData( value, "faction", -1 )
						end
						destroyElement( theTeam )
					end
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delfaction", adminDeleteFaction, false, false)

function adminShowFactions(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local result = mysql_query(handler, "SELECT id, name, type, (SELECT COUNT(*) FROM characters c WHERE c.faction_id = f.id) FROM factions f ORDER BY id ASC")
		
		
		
		if (result) then
			local factions = { }
			local key = 1
			
			for result, row in mysql_rows(result) do
				factions[key] = { }
				factions[key][1] = row[1]
				factions[key][2] = row[2]
				factions[key][3] = row[3]
				
				local team = getTeamFromName(row[2])
				if team then
					factions[key][4] = #getPlayersInTeam(team) .. " / " .. row[4]
				else
					factions[key][4] = "?? / " .. row[4]
				end
				key = key + 1
			end
			
			mysql_free_result(result)
			triggerClientEvent(thePlayer, "showFactionList", getRootElement(), factions)
		else
			outputChatBox("Error 300001 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("showfactions", adminShowFactions, false, false)

function setFactionMoney(thePlayer, commandName, factionID, amount)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (factionID) or not (amount)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					exports.global:setMoney(theTeam, amount)
					outputChatBox("Set faction '" .. getTeamName(theTeam) .. "'s money to " .. amount .. " $.", thePlayer, 255, 194, 14)
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setfactionmoney", setFactionMoney, false, false)

function setFactionBudget(thePlayer, commandName, factionID, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 10 then
		local amount = tonumber( amount )
		if not factionID or not amount or amount < 0 then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					if getElementData(theTeam, "type") >= 2 and getElementData(theTeam, "type") <= 6 then
						if exports.global:takeMoney(getPlayerTeam(thePlayer), amount) then
							exports.global:giveMoney(theTeam, amount)
							outputChatBox("You added $" .. amount .. " to the budget of '" .. getTeamName(theTeam) .. "' (Total: " .. exports.global:getMoney(theTeam) .. ").", thePlayer, 255, 194, 14)
							mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(getPlayerTeam(thePlayer), "id") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 8)" ) )
						else
							outputChatBox("You can't afford this.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("You can't set a budget for that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setbudget", setFactionBudget, false, false)

function setTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 10 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 30 then
			outputChatBox("SYNTAX: /" .. commandName .. " [0-30%]", thePlayer, 255, 194, 14)
		else
			exports.global:setTaxAmount(amount)
			outputChatBox("New Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("settax", setTax, false, false)

function setIncomeTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 10 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 25 then
			outputChatBox("SYNTAX: /" .. commandName .. " [0-25%]", thePlayer, 255, 194, 14)
		else
			exports.global:setIncomeTaxAmount(amount)
			outputChatBox("New Income Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setincometax", setIncomeTax, false, false)

function setWelfare(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 10 then
		local amount = tonumber( amount )
		if not amount or amount <= 0 then
			outputChatBox("SYNTAX: /" .. commandName .. " [Money]", thePlayer, 255, 194, 14)
		else
			unemployedPay = amount
			outputChatBox("New Welfare is $" .. unemployedPay .. "/payday", thePlayer, 0, 255, 0)
			mysql_free_result( mysql_query( handler, "UPDATE settings SET value = " .. unemployedPay .. " WHERE name = 'welfare'" ) )
		end
	end
end
addCommandHandler("setwelfare", setWelfare, false, false)

function getTax(thePlayer)
	outputChatBox( "Welfare: $" .. unemployedPay, thePlayer, 255, 194, 14 )
	outputChatBox( "Tax: " .. ( exports.global:getTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
	outputChatBox( "Income Tax: " .. ( exports.global:getIncomeTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
end
addCommandHandler("gettax", getTax, false, false)

-- /////////////// WAGES
local governmentIncome = 0

local taxVehicles = {}
local vehicleCount = {}
local taxHouses = {}

local rc = 10
local bike = 15
local low = 25
local offroad = 35
local sport = 100
local van = 50
local bus = 75
local truck = 200
local boat = 300 -- except dinghy
local heli = 500
local plane = 750
local race = 75
local vehicleTaxes = {
	offroad, low, sport, truck, low, low, 1000, truck, truck, 200, -- dumper, stretch
	low, sport, low, van, van, sport, truck, heli, van, low,
	low, low, low, van, low, 1000, low, truck, van, sport, -- hunter
	boat, bus, 1000, truck, offroad, van, low, bus, low, low, -- rhino
	van, rc, low, truck, 500, low, boat, heli, bike, 0, -- monster, tram
	van, sport, boat, boat, boat, truck, van, 10, low, van, -- caddie
	plane, bike, bike, bike, rc, rc, low, low, bike, heli,
	van, bike, boat, 20, low, low, plane, sport, low, low, -- dinghy
	sport, bike, van, van, boat, 10, 75, heli, heli, offroad, -- baggage, dozer
	offroad, low, low, boat, low, offroad, low, heli, van, van,
	low, rc, low, low, low, offroad, sport, low, van, bike,
	bike, plane, plane, plane, truck, truck, low, low, low, plane,
	plane * 10, bike, bike, bike, truck, van, low, low, truck, low, -- hydra
	10, 20, offroad, low, low, low, low, 0, 0, offroad, -- forklift, tractor, 2x train
	low, sport, low, van, truck, low, low, low, rc, low,
	low, low, van, plane, van, low, 500, 500, race, race, -- 2x monster
	race, low, race, heli, rc, low, low, low, offroad, 0, -- train trailer
	0, 10, 10, offroad, 15, low, low, 3*plane, truck, low,-- train trailer, kart, mower, sweeper, at400
	low, bike, van, low, van, low, bike, race, van, low,
	0, van, 2*plane, plane, rc, boat, low, low, low, offroad, -- train trailer, andromeda
	low, truck, race, sport, low, low, low, low, low, van,
	low, low
}
function payWage(player, pay, faction, tax)
	local governmentIncome = 0
	local bankmoney = getElementData(player, "bankmoney")
	local interestrate = 0.004
	local noWage = pay == 0
	
	-- DONATOR PERKS
	local donator = getElementData(player, "donatorlevel")
	local donatormoney = 0 
	if (donator==1) then
		donatormoney = donatormoney + 25
		interestrate = interestrate + 0.001
	elseif (donator==2) then
		donatormoney = donatormoney + 50
		interestrate = interestrate + 0.002
	elseif (donator==3) then
		donatormoney = donatormoney + 75
		interestrate = interestrate + 0.003
	elseif (donator==4) then
		donatormoney = donatormoney + 100
		interestrate = interestrate + 0.004
	elseif (donator==5) then
		donatormoney = donatormoney + 125
		interestrate = interestrate + 0.005
	elseif (donator==6) then
		donatormoney = donatormoney + 150
		interestrate = interestrate + 0.006
	elseif (donator==7) then
		donatormoney = donatormoney + 250
		interestrate = interestrate + 0.006
	end
	
	local interest = math.ceil(interestrate * bankmoney)
	mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (-57, " .. getElementData(player, "dbid") .. ", " .. interest .. ", 'BANKINTEREST', 6)" ) )
	
	local incomeTax = exports.global:getIncomeTaxAmount()
	
	-- business money
	local profit = getElementData(player, "businessprofit")
	setElementData(player, "businessprofit", 0, false)
	bankmoney = bankmoney + math.max( 0, pay ) + interest + profit + donatormoney

	
	-- rentable houses
	local rent = 0
	local rented = nil -- store id in here
	local dbid = tonumber(getElementData(player, "dbid"))
	for key, value in ipairs(getElementsByType("pickup", getResourceRootElement(getResourceFromName("interior-system")))) do
		local owner = tonumber(getElementData(value, "owner"))
		if (owner) and (owner == dbid) and (getElementData(value, "name")) and (tonumber(getElementData(value, "inttype")) == 3) and (tonumber(getElementData(value, "cost")) > 0) then
			rent = rent + tonumber(getElementData(value, "cost"))
			rented = tonumber(getElementData(value, "dbid"))
		end
	end
	
	if not faction then
		if pay >= 0 then
			governmentIncome = governmentIncome - pay
			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (-3, " .. getElementData(player, "dbid") .. ", " .. pay .. ", 'STATEBENEFITS', 6)" ) )
		else
			pay = 0
		end
	else
		if pay >= 0 then	
			local teamid = getElementData(player, "faction")
			if teamid <= 0 then
				teamid = 0
			else
				teamid = -teamid
			end
			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. teamid .. ", " .. getElementData(player, "dbid") .. ", " .. pay .. ", 'WAGE', 6)" ) )
		else
			pay = 0
		end
	end
	
	if tax > 0 then
		pay = pay - tax
		bankmoney = bankmoney - tax
		governmentIncome = governmentIncome + tax
		mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", -3, " .. tax .. ", 'INCOMETAX', 6)" ) )
	end
	
	local vtax = taxVehicles[ getElementData(player, "dbid") ] or 0
	if vtax > 0 then
		vtax = math.min( vtax, bankmoney )
		bankmoney = bankmoney - vtax
		
		if vtax > pay+profit+interest+donatormoney then
			exports.global:givePlayerAchievement(player, 19)
		end
		
		mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", -3, " .. vtax .. ", 'VEHICLETAX', 6)" ) )

		
		governmentIncome = governmentIncome + vtax
	end
	
	local ptax = taxHouses[ getElementData(player, "dbid") ] or 0
	if ptax > 0 then
		ptax = math.floor( ptax * 0.6 )
		ptax = math.min( ptax, bankmoney )
		bankmoney = bankmoney - ptax
		governmentIncome = governmentIncome + ptax
		mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", -3, " .. ptax .. ", 'PROPERTYTAX', 6)" ) )
	end
	
	if (rent > 0) then
		if (rent > bankmoney)   then
			rent = -1
			call( getResourceFromName( "interior-system" ), "publicSellProperty", player, rented, false, true )
		else
			exports.global:givePlayerAchievement(player, 11)
			bankmoney = bankmoney - rent
			
			-- gov shouldnt get anything of this
			--governmentIncome = governmentIncome + rent
			mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(player, "dbid") .. ", 0, " .. rent .. ", 'HOUSERENT', 6)" ) )
		end
	end

	-- save the bankmoney
	setElementData(player, "bankmoney", bankmoney)
	
	local grossincome = pay+profit+interest+donatormoney-rent-vtax-ptax
		
	-- let the client tell them the (bad) news
	triggerClientEvent(player, "cPayDay", player, faction, noWage and -1 or pay, profit, interest, donatormoney, tax, incomeTax, vtax, ptax, rent, grossincome)
	
	-- Insert in Transactions
	
	-- 0 is government
	-- -3 is faction government
	
	
	--mysql_free_result( mysql_query( handler, "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (0, " .. getElementData(player, "dbid") .. ", " .. grossincome .. ", '', 7)" ) )
	return governmentIncome
end

function payAllWages(timer)
	if timer then
		local mins = getRealTime().minute
		local minutes = 60 - mins
		setTimer(payAllWages, 60000*minutes, 1, true)
	end
	
	-- collect all vehicle info
	taxVehicles = {}
	vehicleCount = {}
	for _, veh in pairs(getElementsByType("vehicle")) do
		if isElement(veh) then
			local owner, faction = tonumber(getElementData(veh, "owner")) or 0, tonumber(getElementData(veh, "faction")) or 0
			if faction < 0 and owner > 0 then -- non-faction vehicles
				taxVehicles[owner] = ( taxVehicles[owner] or 0 ) + ( vehicleTaxes[getElementModel(veh)-399] or 25 )
				vehicleCount[owner] = ( vehicleCount[owner] or 0 ) + 1
				if vehicleCount[owner] > 3 then -- $50 for having too much vehicles, per vehicle more than 3
					taxVehicles[owner] = taxVehicles[owner] + 50
				end
			end
		end
	end
	
	-- count all player props
	taxHouses = { }
	for _, property in pairs( getElementsByType( "pickup", getResourceRootElement( getResourceFromName( "interior-system" ) ) ) ) do
		if getElementData( property, "cost" ) and getElementData( property, "owner" ) > 0 and getElementData( property, "inttype" ) < 2  then -- owned, not rented houses
			taxHouses[ getElementData( property, "owner" ) ] = ( taxHouses[ getElementData( property, "owner" ) ] or 0 ) + 0.005 * getElementData( property, "cost" )
		end
	end
	
	local players = exports.pool:getPoolElementsByType("player")
	
	local govAmount = exports.global:getMoney(getTeamFromName("Government of Los Santos"))
	
	for key, value in ipairs(players) do
		local logged = getElementData(value, "loggedin")
		local timeinserver = getElementData(value, "timeinserver")
		
		-- Pay Check tooltip
		if(getResourceFromName("tooltips-system"))then
			triggerClientEvent(value,"tooltips:showHelp", getRootElement(),12)
		end
		
		if (logged==1) and (timeinserver>=60) then
			mysql_free_result( mysql_query( handler, "UPDATE characters SET jobcontract = jobcontract - 1 WHERE id = " .. getElementData( value, "dbid" ) .. " AND jobcontract > 0" ) )
			if getElementData(value, "license.car") and getElementData(value, "license.car") < 0 then
				setElementData(value, "license.car", getElementData(value, "license.car") + 1)
				mysql_free_result( mysql_query( handler, "UPDATE characters SET car_license = car_license + 1 WHERE id = " .. getElementData( value, "dbid" ) ) )
			end
			if getElementData(value, "license.gun") and getElementData(value, "license.gun") < 0 then
				setElementData(value, "license.gun", getElementData(value, "license.gun") + 1)
				mysql_free_result( mysql_query( handler, "UPDATE characters SET gun_license = gun_license + 1 WHERE id = " .. getElementData( value, "dbid" ) ) )
			end
			local playerFaction = getElementData(value, "faction")
			if (playerFaction~=-1) then -- In a faction
				local theTeam = getPlayerTeam(value)
				local factionType = getElementData(theTeam, "type")
				
				if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) then -- Factions with wages
					local username = getPlayerName(value)
					
					local factionRankresult = mysql_query(handler, "SELECT faction_rank FROM characters WHERE id = " .. getElementData( value, "dbid" ) .. " LIMIT 1")
					local factionRank = mysql_result(factionRankresult, 1, 1)
					mysql_free_result(factionRankresult)
					
					local rankWageresult = mysql_query(handler, "SELECT wage_" .. factionRank .. " FROM factions WHERE id='" .. playerFaction .. "'")
					local rankWage = tonumber(mysql_result(rankWageresult, 1, 1))
					mysql_free_result(rankWageresult)
					
					local taxes = 0
					if not exports.global:takeMoney(theTeam, rankWage) then
						rankWage = -1
					else
						local incomeTax = exports.global:getIncomeTaxAmount()
						taxes = math.ceil( incomeTax * rankWage )
					end
					
					govAmount = govAmount + payWage( value, rankWage, true, taxes )
				else
					if unemployedPay >= govAmount then
						unemployedPay = -1
					end
					
					govAmount = govAmount + payWage( value, unemployedPay, false, 0 )
				end
			else
				if unemployedPay >= govAmount then
					unemployedPay = -1
				end
				
				govAmount = govAmount + payWage( value, unemployedPay, false, 0 )
			end
			
			setElementData(value, "timeinserver", timeinserver-60, false)

			local hoursplayed = getElementData(value, "hoursplayed") or 0
			setElementData(value, "hoursplayed", hoursplayed+1, false)
			mysql_free_result( mysql_query( handler, "UPDATE characters SET hoursplayed = hoursplayed + 1, bankmoney = " .. getElementData( value, "bankmoney" ) .. " WHERE id = " .. getElementData( value, "dbid" ) ) )
		elseif (logged==1) and (timeinserver) and (timeinserver<60) then
			outputChatBox("You have not played long enough to recieve a payday. (You require another " .. 60-timeinserver .. " Minutes of play.)", value, 255, 0, 0)
		end
	end
	
	-- Store the government money
	exports.global:setMoney(getTeamFromName("Government of Los Santos"), govAmount)
	exports.irc:sendMessage("[SCRIPT] All wages & state benefits paid.")
end


function adminDoPayday(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:isPlayerLeadAdmin(thePlayer)) then
			payAllWages(false)
		end
	end
end
addCommandHandler("dopayday", adminDoPayday)

function timeSaved(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local timeinserver = getElementData(thePlayer, "timeinserver")
		
		if (timeinserver>60) then
			timeinserver = 60
		end
		
		outputChatBox("You currently have " .. timeinserver .. " Minutes played.", thePlayer, 255, 195, 14)
		outputChatBox("You require another " .. 60-timeinserver .. " Minutes to obtain a payday.", thePlayer, 255, 195, 14)
	end
end
addCommandHandler("timesaved", timeSaved)
