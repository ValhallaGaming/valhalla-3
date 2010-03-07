mysql = exports.mysql

-- PUBLIC PHONES
addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		local result = mysql:query("SELECT id, x, y, z, dimension FROM publicphones")
		if (result) then
			local continue = true
			while continue do
				row = mysql:fetch_assoc(result)
				if not (row) then
					break
				end
				local id = tonumber(row["id"])
					
				local x = tonumber(row["x"])
				local y = tonumber(row["y"])
				local z = tonumber(row["z"])
					
				local dimension = tonumber(row["dimension"])
				
				local shape = createColSphere(x, y, z, 1)
				exports.pool:allocateElement(shape)
				setElementDimension(shape, dimension)
				setElementData(shape, "dbid", id, false)
			end
			mysql:free_result(result)
		end
	end
)

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM publicphones AS e1 LEFT JOIN publicphones AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function addPhone(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		
		local id = SmallestID()
		local query = mysql:query_free("INSERT INTO publicphones SET id=" .. id .. ", x="  .. x .. ", y=" .. y .. ", z=" .. z .. ", dimension=" .. dimension)
		
		if (query) then
			
			local shape = createColSphere(x, y, z, 1)
			exports.pool:allocateElement(shape)
			setElementDimension(shape, dimension)
			setElementData(shape, "dbid", id, false)
			
			outputChatBox("Public Phone spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 200001 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("addphone", addPhone, false, false)

function getNearbyPhones(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Phones:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theColshape in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			local x, y = getElementPosition(theColshape)
			local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
			if (distance<=20) then
				local dbid = getElementData(theColshape, "dbid")
				outputChatBox("   Public Phone with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyphones", getNearbyPhones, false, false)

function delPhone(thePlayer, commandName, id)
	if exports.global:isPlayerLeadAdmin(thePlayer) then
		local id = tonumber(id)
		if not id then
			outputChatBox( "SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14 )
		else
			local colShape = nil
			
			for key, value in ipairs(getElementsByType("colshape", getResourceRootElement())) do
				if getElementData(value, "dbid") == id then
					colShape = value
				end
			end
			
			if (colShape) then
				local id = getElementData(colShape, "dbid")
				local result = mysql:query_free("DELETE FROM publicphones WHERE id=" .. id)
				
				outputChatBox("Phone #" .. id .. " deleted.", thePlayer)
				destroyElement(colShape)
			else
				outputChatBox("You are not in a Pay n Spray.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delphone", delPhone, false, false)


-- CELL PHONES
function callSomeone(thePlayer, commandName, phoneNumber, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local msg = "takes out a cell phone."
		local publicphone = nil
		for k, v in pairs( getElementsByType( "colshape", getResourceRootElement( ) ) ) do
			if isElementWithinColShape( thePlayer, v ) then
				for kx, vx in pairs( getElementsByType( "player" ) ) do
					if getElementData( vx, "call.col" ) == v then
						outputChatBox( "Someone else is already using this phone.", thePlayer, 255, 0, 0 )
						return
					end
				end
				publicphone = v
				msg = "reaches for the public phone."
				break
			end
		end
		
		if publicphone or exports.global:hasItem(thePlayer, 2) then
			if not (phoneNumber) then
				outputChatBox("SYNTAX: /call [Phone Number]", thePlayer, 255, 194, 14)
			elseif getElementData(thePlayer, "phoneoff") == 1 then
				outputChatBox("Your phone is off.", thePlayer, 255, 0, 0)
			else
				local calling = getElementData(thePlayer, "calling")
				
				if (calling) then -- Using phone already
					outputChatBox("You are already using your phone.", thePlayer, 255, 0, 0)
				elseif getElementData(thePlayer, "injuriedanimation") then
					outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
				else
					
					if phoneNumber == "911" then
						exports.global:sendLocalMeAction(thePlayer, msg)
						outputChatBox("911 Operator says: 911 emergency. Please state your location.", thePlayer)
						setElementData(thePlayer, "callprogress", 1, false)
						setElementData(thePlayer, "phonestate", 1)
						setElementData(thePlayer, "calling", 911)
						
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
						setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
						setTimer(startPhoneAnim, 3050, 1, thePlayer)
					elseif phoneNumber == "311" then
						exports.global:sendLocalMeAction(thePlayer, msg)
						outputChatBox("LSPD Operator says: LSPD Hotline. Please state your location.", thePlayer)
						setElementData(thePlayer, "callprogress", 1, false)
						setElementData(thePlayer, "phonestate", 1)
						setElementData(thePlayer, "calling", 311)
						
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
						setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
						setTimer(startPhoneAnim, 3050, 1, thePlayer)
					elseif phoneNumber == "999" then
						exports.global:sendLocalMeAction(thePlayer, msg)
						outputChatBox("BT&R Operator says: Best's Towing and Recovery. Please state your location.", thePlayer)
						setElementData(thePlayer, "callprogress", 1, false)
						setElementData(thePlayer, "phonestate", 1)
						setElementData(thePlayer, "calling", 999)
						
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
						setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
						setTimer(startPhoneAnim, 3050, 1, thePlayer)
					elseif phoneNumber == "1501" then
						if (publicphone) then
							outputChatBox("Computer voice: This service is not available on this phone.", thePlayer)
						else
							exports.global:sendLocalMeAction(thePlayer, msg)
							outputChatBox("Computer voice: You are now calling with a secret number.", thePlayer)
							setElementData(thePlayer,"cellphone.secret",1, false)
							exports.global:sendLocalMeAction(thePlayer, "hangs up their phone.")
						end
					elseif phoneNumber == "1502" then
						if (publicphone) then
							outputChatBox("Computer voice: This service is not available on this phone.", thePlayer)
						else
							exports.global:sendLocalMeAction(thePlayer, msg)
							outputChatBox("Computer voice: You are now calling with a normal number.", thePlayer)
							setElementData(thePlayer,"cellphone.secret",0, false)
							exports.global:sendLocalMeAction(thePlayer, "hangs up their phone.")
						end
					elseif phoneNumber == "8294" then
						exports.global:sendLocalMeAction(thePlayer, msg)
						outputChatBox("Taxi Operator says: Los Santos Cabs here. Please state your location.", thePlayer)
						setElementData(thePlayer, "callprogress", 1, false)
						setElementData(thePlayer, "phonestate", 1)
						setElementData(thePlayer, "calling", 8294)
						
						exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
						setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
						setTimer(startPhoneAnim, 3050, 1, thePlayer)
					elseif phoneNumber == "12555" then
						if not executeCommandHandler( "12555", thePlayer ) then
							outputChatBox("You get a dead tone...", thePlayer, 255, 194, 14)
						end
					else
						exports.global:sendLocalMeAction(thePlayer, msg)
						local found, foundElement, foundPhoneItemValue = false
						
						for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
							local logged = getElementData(value, "loggedin")
							
							if (logged==1) then
								local number = getElementData(value, "cellnumber")
								if (number==tonumber(phoneNumber)) then
									found = true
									foundElement = value
								end
							end
							
							if (found) then
								local find = false
								find,_,foundPhoneItemValue = exports.global:hasItem(foundElement, 2)
								if not find then -- Check the target has a phone, if not, they weren't found
									found, foundElement = false
								else
									break
								end
							end
						end
						
						if not exports.global:isPlayerSilverDonator(thePlayer) and not exports.global:hasMoney(thePlayer, 10) then
							outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
						elseif not found or foundElement == thePlayer then -- Player with this phone number isnt online...
							outputChatBox("You get a dead tone...", thePlayer, 255, 194, 14)
						elseif getElementData(foundElement, "phoneoff") == 1 then
							outputChatBox("The phone you are trying to call is switched off.", thePlayer, 255, 194, 14)
						else
							local targetCalling = getElementData(foundElement, "calling")
							
							if (targetCalling) then
								outputChatBox("You get a busy tone.", thePlayer)
							else
								setElementData(thePlayer, "call.col", publicphone, false)
								setElementData(thePlayer, "calling", foundElement, false)
								setElementData(thePlayer, "called", true, false)
								setElementData(foundElement, "calling", thePlayer, false)
								
								-- local player
								exports.global:applyAnimation(thePlayer, "ped", "phone_in", 3000, false)
								setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
								setTimer(startPhoneAnim, 3002, 1, thePlayer)
								setTimer(startPhoneAnim, 3050, 1, thePlayer)
								
								--player around target and target start ringing
								if foundPhoneItemValue ~= 0 then -- not vibrate mode
									for _,nearbyPlayer in ipairs(exports.global:getNearbyElements(foundElement, "player"), 10) do
										triggerClientEvent(nearbyPlayer, "startRinging", foundElement, 1, foundPhoneItemValue)
									end
								end
								
								-- target player
								exports.global:sendLocalMeAction(foundElement, "'s Phone starts to ring.")
								
								local secret = getElementData(thePlayer, "cellphone.secret")
								local cellphone = getElementData(thePlayer, "cellnumber")
								if (secret == 1 or publicphone) then
									outputChatBox("Your phone is ringing. The display shows Unknown Number (( /pickup to answer ))", foundElement, 255, 194, 14)
								else
									outputChatBox("Your phone is ringing. The display shows #".. cellphone .. " (( /pickup to answer ))", foundElement, 255, 194, 14)
								end
								
								
								
								exports.global:givePlayerAchievement(thePlayer, 16) -- On the Blower
								
								-- Give the target 30 seconds to answer the call
								setTimer(cancelCall, 30000, 1, thePlayer)
								setTimer(cancelCall, 30000, 1, foundElement)
							end
						end
					end
				end
			end
		else
			outputChatBox("Believe it or not, it's hard to dial on a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("call", callSomeone)
addEvent("remoteCall", true)
addEventHandler("remoteCall", getRootElement(), callSomeone)

function startPhoneAnim(thePlayer)
	exports.global:applyAnimation(thePlayer, "ped", "phone_talk", -1, true, true, true)
	setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
end
function stopPhoneAnim(thePlayer)
--	exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1300, false)
--	setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
	setElementData(thePlayer, "forcedanimation", false)
	toggleAllControls(thePlayer, true, true, false)
--	setTimer(setPedAnimation, 50, 2, thePlayer)
	setTimer(triggerEvent, 100, 1, "onPlayerStopAnimation", thePlayer, true )
end
	

function cancelCall(thePlayer)
	local phoneState = getElementData(thePlayer, "phonestate")
	
	if (phoneState==0) then
		setElementData(thePlayer, "calling", nil, false)
		setElementData(thePlayer, "called", nil, false)
		setElementData(thePlayer, "call.col", nil, false)
	end
end

function answerPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then -- 2 = Cell phone item
			local phoneState = getElementData(thePlayer, "phonestate")
			local calling = getElementData(thePlayer, "calling")
			
			if (calling) then
				if (phoneState==0) then
					local target = calling
					outputChatBox("You picked up the phone. (( /p to talk ))", thePlayer)
					outputChatBox("They picked up the phone.", target)
					exports.global:sendLocalMeAction(thePlayer, "takes out a cell phone.")
					setElementData(thePlayer, "phonestate", 1, false) -- Your in an actual call
					setElementData(calling, "phonestate", 1, false) -- Your in an actual call
					exports.global:sendLocalMeAction(thePlayer, "answers their cellphone.")
					
					for _,nearbyPlayer in ipairs(exports.global:getNearbyElements(target, "player", 10)) do
						triggerClientEvent(nearbyPlayer, "stopRinging", thePlayer)
					end
					
--					exports.global:applyAnimation(calling, "ped", "phone_in", 3000, false, false, false)
					setTimer(toggleAllControls, 150, 1, calling, true, true, true)
					setTimer(startPhoneAnim, 3002, 1, thePlayer)
					setTimer(stopPhoneAnim, 4050, 1, thePlayer)
				end
			elseif not (calling) then
				outputChatBox("Your phone is not ringing.", thePlayer, 255, 0, 0)
			elseif (phoneState==1) or (phoneState==2) then
				outputChatBox("Your phone is already in use.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("pickup", answerPhone)

function hangupPhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then -- 2 = Cell phone item
			local calling = getElementData(thePlayer, "calling")
			
			if (calling) then
				if (type(calling)~="number") then
					local phoneState = getElementData(thePlayer, "phonestate")
					if phoneState >= 1 then -- lets charge the player
						if (getElementData(thePlayer, "called")) then
							if not exports.global:isPlayerSilverDonator(thePlayer) then
								exports.global:takeMoney(thePlayer, 10, true)
							end
						else
							if not exports.global:isPlayerSilverDonator(calling) then
								exports.global:takeMoney(calling, 10, true)
							end
						end
					end
					removeElementData(calling, "calling")
					if (isElement(calling)) then
						outputChatBox("They hung up.", calling)
					end
					removeElementData(calling, "caller")
					removeElementData(calling, "call.col")
					setElementData(calling, "phonestate", 0, false)
					exports.global:applyAnimation(calling, "ped", "phone_out", 1300, false)
					setTimer(toggleAllControls, 150, 1, calling, true, true, true)
				end
				
				removeElementData(thePlayer, "calling")
				removeElementData(thePlayer, "caller")
				removeElementData(thePlayer, "callprogress")
				removeElementData(thePlayer, "call.situation")
				removeElementData(thePlayer, "call.location")
				removeElementData(thePlayer, "call.col")
				setElementData(thePlayer, "phonestate", 0, false)
				exports.global:sendLocalMeAction(thePlayer, "hangs up their phone.")
				
				exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1300, false)
				setTimer(toggleAllControls, 150, 1, thePlayer, true, true, true)
			else
				outputChatBox("Your phone is not in use.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("hangup", hangupPhone)
addEventHandler( "onColShapeLeave", getResourceRootElement(),
	function( thePlayer )
		if getElementData( thePlayer, "call.col" ) == source then
			executeCommandHandler( "hangup", thePlayer )
		end
	end
)
addEventHandler( "onPlayerQuit", getRootElement(),
	function( )
		local calling = getElementData( source, "calling" )
		if isElement( calling ) then
			executeCommandHandler( "hangup", calling )
		end
	end
)

function loudSpeaker(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then -- 2 = Cell phone item
			local phoneState = getElementData(thePlayer, "phonestate")
			
			if (phoneState==1) then
				exports.global:sendLocalMeAction(thePlayer, "turns on loudspeaker on the phone.")
				outputChatBox("You flick your phone onto loudspeaker.", thePlayer)
				setElementData(thePlayer, "phonestate", 2, false)
			elseif (phoneState==2) then
				exports.global:sendLocalMeAction(thePlayer, "turns off loudspeaker on the phone.")
				outputChatBox("You flick your phone off of loudspeaker.", thePlayer)
				setElementData(thePlayer, "phonestate", 1, false)
			else
				outputChatBox("You are not in a call.", thePlayer, 255, 0 ,0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("loudspeaker", loudSpeaker)

function talkPhone(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then -- 71 = Cell phone item
			if not (...) then
				outputChatBox("SYNTAX: /p [Message]", thePlayer, 255, 194, 14)
			elseif getElementData(thePlayer, "injuriedanimation") then
				outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
			else
				local phoneState = getElementData(thePlayer, "phonestate")
				
				if (phoneState>=1) then -- The player is in a call, not just dialing (2= loudspeaker)
					local message = table.concat({...}, " ")
					local username = getPlayerName(thePlayer):gsub("_", " ")
					local phoneNumber = getElementData( thePlayer, "call.col" ) and "?" or getElementData(thePlayer, "cellnumber")
					
					local languageslot = getElementData(thePlayer, "languages.current")
					local language = getElementData(thePlayer, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
					
					local target = getElementData(thePlayer, "calling")
					
					local callprogress = getElementData(thePlayer, "callprogress")
					if (callprogress) then
						outputChatBox("You [Cellphone]: " ..message, thePlayer)
						-- Send it to nearby players of the speaker
						exports.global:sendLocalText(thePlayer, username .. " [Cellphone]: " .. message, nil, nil, nil, 10, {[thePlayer] = true})
						
						if (tonumber(target)==911) then -- EMERGENCY SERVICES
							if (callprogress==1) then -- Requesting the location
								setElementData(thePlayer, "call.location", message)
								setElementData(thePlayer, "callprogress", 2)
								outputChatBox("911 Operator says: Can you describe your emergency please?", thePlayer)
								return
							elseif (callprogress==2) then -- Requesting the situation
								outputChatBox("911 Operator says: Thanks for your call, we've dispatched a unit to your location.", thePlayer)
								
								local location = getElementData(thePlayer, "call.location")
								local theTeam = getTeamFromName("Los Santos Police Department")
								local theTeamES = getTeamFromName("Los Santos Emergency Services")
								local teamMembers = getPlayersInTeam(theTeam)
								local teamMembersES = getPlayersInTeam(theTeamES)
								
								for key, value in ipairs(teamMembers) do
									outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
									outputChatBox("[RADIO] Situation: '" .. message .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 0, 183, 239)
									outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 0, 183, 239)
								end
								
								for key, value in ipairs(teamMembersES) do
									outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
									outputChatBox("[RADIO] Situation: '" .. message .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 0, 183, 239)
									outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 0, 183, 239)
								end
								
								removeElementData(thePlayer, "calling")
								removeElementData(thePlayer, "caller")
								removeElementData(thePlayer, "callprogress")
								removeElementData(thePlayer, "call.location")
								setElementData(thePlayer, "phonestate", 0, false)
								exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
								
								exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1000, false, true, true)
								toggleAllControls(thePlayer, true, true, true)
								return
							end
						elseif (tonumber(target)==311) then -- EMERGENCY SERVICES
							if (callprogress==1) then -- Requesting the location
								setElementData(thePlayer, "call.location", message)
								setElementData(thePlayer, "callprogress", 2)
								outputChatBox("LSPD Operator says: Can you describe your emergency please?", thePlayer)
								return
							elseif (callprogress==2) then -- Requesting the situation
								outputChatBox("LSPD Operator says: Thanks for your call, we've dispatched a unit to your location.", thePlayer)
								
								local location = getElementData(thePlayer, "call.location")
								local theTeam = getTeamFromName("Los Santos Police Department")
								local teamMembers = getPlayersInTeam(theTeam)
								
								for key, value in ipairs(teamMembers) do
									outputChatBox("[RADIO] This is dispatch, We've got a report via the non-emergency line, Over.", value, 245, 40, 135)
									outputChatBox("[RADIO] Situation: '" .. message .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 245, 40, 135)
									outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 245, 40, 135)
								end
								
								removeElementData(thePlayer, "calling")
								removeElementData(thePlayer, "caller")
								removeElementData(thePlayer, "callprogress")
								removeElementData(thePlayer, "call.location")
								setElementData(thePlayer, "phonestate", 0, false)
								exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
								
								exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1000, false, true, true)
								toggleAllControls(thePlayer, true, true, true)
								return
							end
						elseif (tonumber(target)==999) then -- TOWING
							if (callprogress==1) then -- Requesting the location
								setElementData(thePlayer, "call.location", message)
								setElementData(thePlayer, "callprogress", 2)
								outputChatBox("BT&R Operator says: Can you describe the situation please?", thePlayer)
								return
							elseif (callprogress==2) then -- Requesting the situation
								outputChatBox("BT&R Operator says: Thanks for your call, we've dispatched a unit to your location.", thePlayer)
								
								local location = getElementData(thePlayer, "call.location")
								local theTeam = getTeamFromName("Best's Towing and Recovery")
								local teamMembers = getPlayersInTeam(theTeam)
								
								for key, value in ipairs(teamMembers) do
									outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
									outputChatBox("[RADIO] Situation: '" .. message .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 0, 183, 239)
									outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', Over. ((" .. getPlayerName(thePlayer):gsub("_"," ") .. "))", value, 0, 183, 239)
								end
								
								removeElementData(thePlayer, "calling")
								removeElementData(thePlayer, "caller")
								removeElementData(thePlayer, "callprogress")
								removeElementData(thePlayer, "call.location")
								setElementData(thePlayer, "phonestate", 0, false)
								exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
								
								exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1000, false, true, true)
								toggleAllControls(thePlayer, true, true, true)
								return
							end
						elseif (tonumber(target)==8294) then -- TAXI
							if (callprogress==1) then
								local founddriver = false								
								
								for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
									local job = getElementData(value, "job")
									
									if (job == 2) then
										local car = getPedOccupiedVehicle(value)
										if car and (getElementModel(car)==438 or getElementModel(car)==420) then
											outputChatBox("[New Fare] " .. getPlayerName(thePlayer):gsub("_"," ") .." Ph:" .. phoneNumber .. " Location: " .. message .."." , value, 0, 183, 239)
											founddriver = true
										end
									end
								end
								
								if founddriver == true then
									outputChatBox("Taxi Operator says: Thanks for your call, a taxi will be with you shortly.", thePlayer)
								else
									outputChatBox("Taxi Operator says: There is no taxi available in that area, please try again later.", thePlayer)
								end
								removeElementData(thePlayer, "calling")
								removeElementData(thePlayer, "caller")
								removeElementData(thePlayer, "callprogress")
								removeElementData(thePlayer, "call.location")
								setElementData(thePlayer, "phonestate", 0, false)
								exports.global:sendLocalMeAction(thePlayer, "hangs up their cellphone.")
								
								exports.global:applyAnimation(thePlayer, "ped", "phone_out", 1000, false, true, true)
								toggleAllControls(thePlayer, true, true, true)
								return
							end
						end
					end
					
					message = call( getResourceFromName( "chat-system" ), "trunklateText", thePlayer, call( getResourceFromName( "chat-system" ), "trunklateText", target, message ) )
					local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, target, message, language)
					
					outputChatBox("[" .. languagename .. "] ((" .. username .. ")) [Cellphone]: " .. message2, target)
					
					-- Send the message to the person on the other end of the line
					
					outputChatBox("[" .. languagename .. "] You [Cellphone]: " ..message, thePlayer)
					
					-- Send it to nearby players of the speaker
					exports.global:sendLocalText(thePlayer, username .. " [Cellphone]: " .. message, nil, nil, nil, 10, {[thePlayer] = true})
					
					local phoneState = getElementData(target, "phonestate")
					-- Send it to the listener, if they have loud speaker
					if (phoneState==2) then -- Loudspeaker
						local x, y, z = getElementPosition(target)
						local username = getPlayerName(target):gsub("_", " ")
						
						for index, nearbyPlayer in ipairs(getElementsByType("player")) do
							if isElement(nearbyPlayer) and nearbyPlayer ~= target and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < 40 and getElementDimension(nearbyPlayer) == getElementDimension(target) then
								local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, nearbyPlayer, message, language)
								outputChatBox("[" .. languagename .. "] " .. username .. "'s Cellphone Loudspeaker: " .. message2, nearbyPlayer)
							end
						end
					end
				else
					outputChatBox("You are not on a call.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("p", talkPhone)

function phoneBook(thePlayer, commandName, partialNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 7)) then -- 7 = Phonebook item
			if not (partialNick) then
				outputChatBox("SYNTAX: /phonebook [Partial Name]", thePlayer, 255, 194, 14)
			else
				exports.global:sendLocalMeAction(thePlayer, "looks into their phonebook.")
				local result = mysql:query("SELECT cellnumber, charactername FROM characters WHERE charactername LIKE '%" .. mysql:escape_string(partialNick) .. "%' AND cellnumber >= 15000")
				
				if (mysql:num_rows(result)>0) then
					local continue = true
					while true do
						local row = mysql:fetch_assoc(result)
						if not row then break end
						local phoneNumber = tonumber(row["cellnumber"])
						local username = tostring(row["charactername"])
						username = string.gsub(username, "_", " ")
						
						outputChatBox(username .. " - #" .. phoneNumber .. ".", thePlayer)
					end
				else
					outputChatBox("You find no one with that name.", thePlayer, 255, 194, 14)
				end
				mysql:free_result(result)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a phonebook you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("phonebook", phoneBook)

function togglePhone(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if logged == 1 and ( exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerBronzeDonator(thePlayer) ) then
		if getElementData( thePlayer, "calling" ) then
			outputChatBox("You are using your phone!", thePlayer, 255, 0, 0)
		else
			local phoneoff = getElementData( thePlayer, "phoneoff" )
			
			if phoneoff == 1 then
				outputChatBox("You switched your phone on.", thePlayer, 0, 255, 0)
			else
				outputChatBox("You switched your phone off.", thePlayer, 255, 0, 0)
			end
			setElementData(thePlayer, "phoneoff", 1 - phoneoff, false)
			mysql:query_free( "UPDATE characters SET phoneoff=" .. ( 1 - phoneoff ) .. " WHERE id = " .. getElementData(thePlayer, "dbid") )
		end
	end
end
addCommandHandler("togglephone", togglePhone)

function saveCurrentRingtone(itemValue)
	if itemValue then
		exports.global:takeItem(source, 2)
		exports.global:giveItem(source, 2, itemValue)
	end
end
addEvent("saveRingtone", true)
addEventHandler("saveRingtone", getRootElement(), saveCurrentRingtone)

function sendSMS(thePlayer, commandName, number, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (exports.global:hasItem(thePlayer, 2)) then -- 71 = Cell phone item
			number = tonumber( number )
			if not number or ( number ~= 999 and not (...) ) then
				outputChatBox("SYNTAX: /" .. commandName .. " [number] [message]", thePlayer, 255, 194, 14)
			elseif getElementData(thePlayer, "phoneoff") == 1 then
				outputChatBox("Your phone is off.", thePlayer, 255, 0, 0)
			elseif getElementData(thePlayer, "injuriedanimation") then
				outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
			elseif exports.global:hasMoney(thePlayer, 1) or exports.global:isPlayerSilverDonator(thePlayer) then
				if number == 999 then
					if not exports.global:isPlayerSilverDonator(thePlayer) then
						exports.global:takeMoney(thePlayer, 1)
					end
					
					exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
					outputChatBox("You [SMS to #999]: info", thePlayer, 120, 255, 80)
					
					setTimer( 
						function( thePlayer )
							if isElement( thePlayer ) then
								local id = getElementData( thePlayer, "dbid" )
								if id then
									local impounded = mysql:query_fetch_assoc("SELECT COUNT(*) as no FROM vehicles WHERE owner = " .. id .. " and Impounded > 0")
									if impounded then
										local amount = tonumber(impounded["no"])
										exports.global:sendLocalMeAction(thePlayer, "receives a text message.")
										if amount > 0 then
											outputChatBox("((Best's Towing & Recovery)) #999 [SMS]: " .. amount .. " of your vehicles are impounded. Head over to the Impound to release them.", thePlayer, 120, 255, 80)
										else
											outputChatBox("((Best's Towing & Recovery)) #999 [SMS]: None of your vehicles are impounded.", thePlayer, 120, 255, 80)
										end
									end
								end
							end
						end, 3000, 1, thePlayer
					)
				else
					local target = nil
					
					for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
						local logged = getElementData(value, "loggedin")
						
						if (logged==1) then
							if number == tonumber(getElementData(value, "cellnumber")) then
								if exports.global:hasItem(value, 2) then -- Check the target has a phone, if not, they weren't found
									target = value
									break
								end
							end
						end
					end
					
					local languageslot = getElementData(thePlayer, "languages.current")
					local language = getElementData(thePlayer, "languages.lang" .. languageslot)
					local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
					local message = table.concat({...}, " ")
					
					if target then
						if target == thePlayer then
							outputChatBox( "You can't send yourself a message.", thePlayer, 255, 0, 0 )
						elseif getElementData(target, "phoneoff") == 1 then
							exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
							outputChatBox("[" .. languagename .. "] You [SMS to #" .. number .. "]: " .. message, thePlayer, 120, 255, 80)
							
							setTimer( outputChatBox, 3000, 1, "((Automated Message)) The phone with that number is currently off.", thePlayer, 120, 255, 80 )
						else
							local username = getPlayerName(thePlayer):gsub("_", " ")
							local phoneNumber = getElementData(thePlayer, "cellnumber")
								
							local message2 = call(getResourceFromName("language-system"), "applyLanguage", thePlayer, target, message, language)
							
							
							exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
							exports.global:sendLocalMeAction(target, "receives a text message.")
							-- Send the message to the person on the other end of the line
							outputChatBox("[" .. languagename .. "] ((" .. username .. ")) #" .. phoneNumber .. " [SMS]: " .. message2, target, 120, 255, 80)
							outputChatBox("[" .. languagename .. "] You [SMS to #" .. number .. "]: " .. message, thePlayer, 120, 255, 80)
							
							if not exports.global:isPlayerSilverDonator(thePlayer) then
								exports.global:takeMoney(thePlayer, 1)
							end
						end
					else
						exports.global:sendLocalMeAction(thePlayer, "sends a text message.")
						outputChatBox("[" .. languagename .. "] You [SMS to #" .. number .. "]: " .. message, thePlayer, 120, 255, 80)
						
						setTimer( outputChatBox, 3000, 1, "((Automated Message)) The recipient of the message could not be found.", thePlayer, 120, 255, 80)
					end
				end
			else
				outputChatBox("You cannot afford a SMS.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("sms", sendSMS)