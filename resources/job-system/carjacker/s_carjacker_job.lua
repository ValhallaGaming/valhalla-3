local count = 0

function createTimer(res)
	local selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(), createTimer)

function selectPlayer()
	-- get a random player
	local theChosenOne = getRandomPlayer()
	count = count+1

	if (isElement(theChosenOne)) then	
		local logged = getElementData(theChosenOne, "loggedin")
		if not (logged) then
			if (count<10) then
				selectPlayer() -- if this player is not a friend of Hunter's go back and select another player
				outputDebugString("Player not logged in")
			else
				selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
				outputDebugString("no players found")
				count = 0
			end
		elseif getElementData( theChosenOne, "phoneoff" ) == 1 then
			local gender = getElementData(theChosenOne, "gender")
			local genderm = "his"
			if (gender == 1) then
				genderm = "her"
			end
		
			outputDebugString("Player " .. getPlayerName(theChosenOne) .. " has " .. genderm .. " phone off")
		else
			local query = mysql:query_fetch_assoc("SELECT hunter FROM characters WHERE charactername='" .. mysql:escape_string(getPlayerName(theChosenOne)) .."'")
			local huntersFriend = tonumber( query["hunter"] )
			
			if (huntersFriend == 0) then  -- are they a friend of hunter?
				if (count<10) then -- check 10 players before resetting the timer.
					selectPlayer() -- if this player is not a friend of Hunter's go back and select another player
				else
					selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
					count = 0
				end
			else
				if (getElementData(theChosenOne,"missionModel")) then -- player is already on car jacking mission.
					if (count<10) then
						selectPlayer() -- if this player is already on a car jacking mission go back and select another player.
					else
						selectPlayerTimer = setTimer(selectPlayer, 300000, 1)
						count = 0
					end
				else				
					count = 0
					if(exports.global:hasItem(theChosenOne,2))then
						exports.global:sendLocalMeAction(theChosenOne,"receives a text message.")
						triggerClientEvent(theChosenOne, "createHunterMarkers", theChosenOne)
					end	
					local selectionTime = math.random(1200000,2400000) -- random time between 20 and 40 minutes
					selectPlayerTimer = setTimer(selectPlayer, selectionTime, 1) -- start the selectPlayerTimer again for the next person.
				end
			end
		end
	end
end
-- addCommandHandler("starthunter", selectPlayer)

function dropOffCar()
	local thePlayer = source
	if(getElementData(thePlayer, "missionModel")) then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		if not(vehicle) then
			outputChatBox("You were supposed to deliver a car.", thePlayer, 255, 0, 0)
		else
			local requestedModel = getElementData(thePlayer,"missionModel")
			local requestedName = getVehicleNameFromModel(requestedModel)
			local deliveredName = getVehicleName(vehicle)
			local deliveredModel = getVehicleModelFromName(deliveredName)
			if (requestedModel~=deliveredModel) then
				outputChatBox("Hunter says: I wanted you to bring a ".. requestedName .. ", what am I supposed to do with a " .. deliveredName .. "?", thePlayer, 255, 255, 255)
			else
				local health = getElementHealth(vehicle)
				local profit = math.floor(health*1.5)
				exports.global:giveMoney(thePlayer, profit)
				exports.global:sendLocalText(thePlayer, "Hunter says: Thanks, man. Here's $" .. profit .. " for the car. I'll call you again soon.", nil, nil, nil, 20)
				
				-- cleanup
				setElementData(thePlayer, "realinvehicle", 0, false)
				removePedFromVehicle(thePlayer, vehicle)
				
				
				local dbid = tonumber(getElementData(vehicle, "dbid"))
				
				if (dbid>0) then
					respawnVehicle (vehicle)
					setVehicleLocked(vehicle, false)
				else
					destroyElement(vehicle)
				end
				removeElementData(thePlayer, "missionModel")
				triggerClientEvent(thePlayer, "jackerCleanup", thePlayer)
			end
		end
	end
end
addEvent("dropOffCar", true)
addEventHandler("dropOffCar", getRootElement(), dropOffCar)
