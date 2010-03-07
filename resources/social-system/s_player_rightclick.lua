function retrievePlayerInfo(targetPlayer)
	local accid = tonumber(getElementData(source, "gameaccountid"))
	local targetID = tonumber(getElementData(targetPlayer, "gameaccountid"))
	if targetID then
		local result = mysql:query("SELECT friend FROM friends WHERE id = " .. accid .. " AND friend = " .. targetID .. " LIMIT 1")

		if result then
			local friend = false
			if mysql:num_rows( result ) == 1 then
				friend = true
			end
			mysql:free_result( result )
			
			local description = getElementData(targetPlayer, "chardescription")
			local age = getElementData(targetPlayer, "age")
			local weight = getElementData(targetPlayer, "weight")
			local height = getElementData(targetPlayer, "height")
			local race = getElementData(targetPlayer, "race")
			
			triggerClientEvent(source, "displayPlayerMenu", source, targetPlayer, friend, description, age, weight, height, race)
		end
	end
end
addEvent("sendPlayerInfo", true)
addEventHandler("sendPlayerInfo", getRootElement(), retrievePlayerInfo)

function addFriend(player)
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
				outputChatBox("This person is already on your friends list.", source, 255, 0, 0)
			else
				triggerClientEvent(player, "askAcceptFriend", source)
			end
		end
	end
end
addEvent("addFriend", true)
addEventHandler("addFriend", getRootElement(), addFriend)

-- FRISKING
function friskShowItems(player)
	triggerClientEvent(source, "friskShowItems", player, exports['item-system']:getItems(player))
end
addEvent("friskShowItems", true)
addEventHandler("friskShowItems", getRootElement(), friskShowItems)

-- CUFFS
function toggleCuffs(cuffed, player)
	if (cuffed) then
		toggleControl(player, "fire", false)
		toggleControl(player, "sprint", false)
		toggleControl(player, "jump", false)
		toggleControl(player, "next_weapon", false)
		toggleControl(player, "previous_weapon", false)
		toggleControl(player, "accelerate", false)
		toggleControl(player, "brake_reverse", false)
		toggleControl(player, "aim_weapon", false)
	else
		toggleControl(player, "fire", true)
		toggleControl(player, "sprint", true)
		toggleControl(player, "jump", true)
		toggleControl(player, "next_weapon", true)
		toggleControl(player, "previous_weapon", true)
		toggleControl(player, "accelerate", true)
		toggleControl(player, "brake_reverse", true)
		toggleControl(player, "aim_weapon", true)
	end
end

-- RESTRAINING
function restrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	local dbid = getElementData( player, "dbid" )
	
	setTimer(toggleCuffs, 200, 1, true, player)
	
	outputChatBox("You have been restrained by " .. username .. ".", player)
	outputChatBox("You are restraining " .. targetPlayerName .. ".", source)
	setElementData(player, "restrain", 1)
	setElementData(player, "restrainedObj", restrainedObj)
	setElementData(player, "restrainedBy", getElementData(source, "dbid"), false)
	mysql:query_free("UPDATE characters SET cuffed = 1, restrainedby = " .. getElementData(source, "dbid") .. ", restrainedobj = " .. restrainedObj .. " WHERE id = " .. dbid )
	
	exports.global:takeItem(source, restrainedObj)

	if (restrainedObj==45) then -- If handcuffs.. give the key
		exports['item-system']:deleteAll(47, dbid)
		exports.global:giveItem(source, 47, dbid)
	end
	exports.global:removeAnimation(player)
end
addEvent("restrainPlayer", true)
addEventHandler("restrainPlayer", getRootElement(), restrainPlayer)

function unrestrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have been unrestrained by " .. username .. ".", player)
	outputChatBox("You are unrestraining " .. targetPlayerName .. ".", source)
	
	setTimer(toggleCuffs, 200, 1, false, player)
	
	setElementData(player, "restrain", 0)
	removeElementData(player, "restrainedBy")
	removeElementData(player, "restrainedObj")
	
	local dbid = getElementData(player, "dbid")
	if (restrainedObj==45) then -- If handcuffs.. take the key
		exports['item-system']:deleteAll(47, dbid)
	end
	exports.global:giveItem(source, restrainedObj, 1)
	mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. dbid )
	
	exports.global:removeAnimation(player)
end
addEvent("unrestrainPlayer", true)
addEventHandler("unrestrainPlayer", getRootElement(), unrestrainPlayer)

-- BLINDFOLDS
function blindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have been blindfolded by " .. username .. ".", player)
	outputChatBox("You blindfolded " .. targetPlayerName .. ".", source)
	
	exports.global:takeItem(source, 66) -- take their blindfold
	setElementData(player, "blindfold", 1)
	mysql:query_free("UPDATE characters SET blindfold = 1 WHERE id = " .. getElementData( player, "dbid" ) )
	fadeCamera(player, false)
end
addEvent("blindfoldPlayer", true)
addEventHandler("blindfoldPlayer", getRootElement(), blindfoldPlayer)

function removeblindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have had your blindfold removed by " .. username .. ".", player)
	outputChatBox("You removed " .. targetPlayerName .. "'s blindfold.", source)
	
	exports.global:giveItem(source, 66, 1) -- give the remove the blindfold
	removeElementData(player, "blindfold")
	mysql:query_free("UPDATE characters SET blindfold = 0 WHERE id = " .. getElementData( player, "dbid" ) )
	fadeCamera(player, true)
end
addEvent("removeBlindfold", true)
addEventHandler("removeBlindfold", getRootElement(), removeblindfoldPlayer)


-- STABILIZE
function stabilizePlayer(player)
	local found, slot, itemValue = exports.global:hasItem(source, 70)
	if found then
		if itemValue > 1 then
			exports['item-system']:updateItemValue(source, slot, itemValue - 1)
		else
			exports.global:takeItem(source, 70, itemValue)
		end
		
		local username = getPlayerName(source)
		local targetPlayerName = getPlayerName(player)
	
	
		outputChatBox("You have been stabilized by " .. username .. ".", player)
		outputChatBox("You stabilized " .. targetPlayerName .. ".", source)
		triggerEvent("onPlayerStabilize", player)
	end
end
addEvent("stabilizePlayer", true)
addEventHandler("stabilizePlayer", getRootElement(), stabilizePlayer)