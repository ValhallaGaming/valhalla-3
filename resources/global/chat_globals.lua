oocState = getElementData(getRootElement(),"globalooc:state") or 0

function getOOCState()
	return oocState
end

function setOOCState(state)
	oocState = state
	setElementData(getRootElement(),"globalooc:state", state, false)
end

function sendMessageToAdmins(message)
	local players = exports.pool:getPoolElementsByType("player")
	
	for k, thePlayer in ipairs(players) do
		if (exports.global:isPlayerAdmin(thePlayer)) then
			outputChatBox(tostring(message), thePlayer, 255, 0, 0)
		end
	end
end

function findPlayerByPartialNick(thePlayer, partialNick)
	if not partialNick and not isElement(thePlayer) and type( thePlayer ) == "string" then
		outputDebugString( "Incorrect Parameters in findPlayerByPartialNick" )
		partialNick = thePlayer
		thePlayer = nil
	end
	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	local partialNick = string.lower(partialNick)

	if thePlayer and partialNick == "*" then
		return thePlayer, getPlayerName(thePlayer):gsub("_", " ")
	elseif getPlayerFromName(partialNick) then
		return getPlayerFromName(partialNick), getPlayerName( getPlayerFromName(partialNick) ):gsub("_", " ")
	-- IDS
	elseif tonumber(partialNick) then
		matchPlayer = exports.pool:getElement("player", tonumber(partialNick))
		candidates = { matchPlayer }
	else -- Look for player nicks
		local players = exports.pool:getPoolElementsByType("player")
		for playerKey, arrayPlayer in ipairs(players) do
			if isElement(arrayPlayer) then
				local playerName = string.lower(getPlayerName(arrayPlayer))
				
				if(string.find(playerName, tostring(partialNick))) then
					local posStart, posEnd = string.find(playerName, tostring(partialNick))
					if posEnd - posStart > matchNickAccuracy then
						-- better match
						matchNickAccuracy = posEnd-posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						candidates = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						-- found someone who matches up the same way, so pretend we didnt find any
						matchNick = nil
						matchPlayer = nil
						table.insert( candidates, arrayPlayer )
					end
				end
			end
		end
	end
	
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement( thePlayer ) then
			if #candidates == 0 then
				outputChatBox("No such player found.", thePlayer, 255, 0, 0)
			else
				outputChatBox( #candidates .. " players matching:", thePlayer, 255, 194, 14)
				for _, arrayPlayer in ipairs( candidates ) do
					outputChatBox("  (" .. tostring( getElementData( arrayPlayer, "playerid" ) ) .. ") " .. getPlayerName( arrayPlayer ), thePlayer, 255, 255, 0)
				end
			end
		end
		return false
	else
		return matchPlayer, getPlayerName( matchPlayer ):gsub("_", " ")
	end
end

function getNearbyElements(root, type, distance)
	local x, y, z = getElementPosition(root)
	local elements = {}
	
	if getElementType(root) == "player" and exports['freecam-tv']:isPlayerFreecamEnabled(root) then return elements end
	
	for index, nearbyElement in ipairs(getElementsByType(type)) do
		if isElement(nearbyElement) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyElement)) < ( distance or 20 ) then
			if getElementDimension(root) == getElementDimension(nearbyElement) then
				table.insert( elements, nearbyElement )
			end
		end
	end
	return elements
end

function sendLocalText(root, message, r, g, b, distance, exclude)
	exclude = exclude or {}
	local x, y, z = getElementPosition(root)
	
	if getElementType(root) == "player" and exports['freecam-tv']:isPlayerFreecamEnabled(root) then return end
	
	local shownto = 0
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < ( distance or 20 ) then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if not exclude[nearbyPlayer] and not isPedDead(nearbyPlayer) and logged==1 and getElementDimension(root) == getElementDimension(nearbyPlayer) then
				outputChatBox(message, nearbyPlayer, r, g, b)
				shownto = shownto + 1
			end
		end
	end
	
	if getElementType(root) == "player" and shownto > 0 and getElementDimension(root) == 127 then -- TV SHOW!
		exports['freecam-tv']:add(shownto, message)
	end
end
addEvent("sendLocalText", true)
addEventHandler("sendLocalText", getRootElement(), sendLocalText)

function sendLocalMeAction(thePlayer, message)
	sendLocalText(thePlayer, " *" .. getPlayerName(thePlayer):gsub("_", " ") .. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
end
addEvent("sendLocalMeAction", true)
addEventHandler("sendLocalMeAction", getRootElement(), sendLocalMeAction)

function sendLocalDoAction(thePlayer, message)
	sendLocalText(thePlayer, " * " .. message .. " *      ((" .. getPlayerName(thePlayer):gsub("_", " ") .. "))", 255, 51, 102)
end