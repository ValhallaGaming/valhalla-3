local chaticonsHidden = { }

function sendChatIconShown()
	--outputDebugString("NAME:".. getPlayerName(source) )
	local px, py, pz = getElementPosition(source)

	for key, value in ipairs(getElementsByType("player")) do
		local vx, vy, vz = getElementPosition(value)
		
		
		--if ( gpn(source) == "Mikhail strogov") then
			--outputDebugString(tostring(getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz) <= 25 ))
			--outputDebugString(tostring(value==source))
			--outputDebugString(tostring(chaticonsHidden[source]))
		--end
			
		if ( getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz) <= 25 ) and not (value==source) and chaticonsHidden[value]==nil  then -- only send if they can see it and have chaticons enabled
			triggerClientEvent(value, "addChatter", source)
		end
	end
end
addEvent("chat1", true)
addEventHandler("chat1", getRootElement(), sendChatIconShown)

function sendChatIconHidden()
	local px, py, pz = getElementPosition(source)
	for key, value in ipairs(getElementsByType("player")) do
		local vx, vy, vz = getElementPosition(value)
		
		if ( getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz) <= 25 ) and not (value==source) and chaticonsHidden[value]==nil then -- only send if they can see it and have chaticons enabled, persons out of range who COULD see it before, are handled clientside
			triggerClientEvent(value, "delChatter", source)
		end
	end
end
addEvent("chat0", true)
addEventHandler("chat0", getRootElement(), sendChatIconHidden)

function storeChatIconShown()
	chaticonsHidden[source] = nil
end
addEvent("chaticon1", true)
addEventHandler("chaticon1", getRootElement(), storeChatIconShown)

function storeChatIconHidden()
	chaticonsHidden[source] = true
end
addEvent("chaticon0", true)
addEventHandler("chaticon0", getRootElement(), storeChatIconHidden)