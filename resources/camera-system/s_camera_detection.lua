function monitorSpeed(theVehicle, matchingDimension)
	if (matchingDimension) and (getElementType(theVehicle)=="vehicle") then
		local enabled = getElementData(source, "speedcam:enabled")
		if (enabled) then
			local thePlayer = getVehicleOccupant(theVehicle)
			if thePlayer then
				local maxSpeed = getElementData(source, "speedcam:maxspeed")
				local timer = setTimer(checkSpeed, 300, 30, theVehicle, thePlayer, source, maxSpeed)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:timer", timer, false)
			end
		end
	end
end

function stopMonitorSpeed(theVehicle, matchingDimension)
	if (matchingDimension) and (getElementType(theVehicle)=="vehicle") then
		local thePlayer = getVehicleOccupant(theVehicle)
		if thePlayer then
			local timer = getElementData(thePlayer, "speedcam:timer")
			if isTimer( timer ) then
				killTimer( timer )
			end
			exports['anticheat-system']:changeProtectedElementDataEx( thePlayer, "speedcam:timer" )
		end
	end
end

function checkSpeed(theVehicle, thePlayer, colshape, maxSpeed)
	local currentSpeed = math.floor(exports.global:getVehicleVelocity(theVehicle))
	
	if (currentSpeed > maxSpeed) then
		local timer = getElementData(thePlayer, "speedcam:timer")
		if timer then
			killTimer(timer)
		end
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:timer")

		-- Flash!
		for i = 0, getVehicleMaxPassengers(theVehicle) do
			local p = getVehicleOccupant(theVehicle, i)
			if p then
				triggerClientEvent(p, "speedcam:cameraEffect", p)
			end
		end
		local x, y, z = getElementPosition(thePlayer)
		setTimer(sendWarningToCops, 500, 1, theVehicle, thePlayer, currentSpeed, x, y, z)
	end
end

function sendWarningToCops(theVehicle, thePlayer, speed, x, y, z)

	local direction = "in an unknown direction"
	local areaName = getZoneName(x, y, z)
	local nx, ny, nz = getElementPosition(thePlayer)
	local vehicleName = getVehicleName(theVehicle)
	
	local dx = nx - x
	local dy = ny - y
	
	if dy > math.abs(dx) then
		direction = "northbound"
	elseif dy < -math.abs(dx) then
		direction = "southbound"
	elseif dx > math.abs(dy) then
		direction = "eastbound"
	elseif dx < -math.abs(dy) then
		direction = "westbound"
	end
	
	if not (vehicleName == "Police LS") then
		local theTeam = getTeamFromName("Los Santos Police Department")
		local teamPlayers = getPlayersInTeam(theTeam)
		for key, value in ipairs(teamPlayers) do
		local duty = tonumber(getElementData(value, "duty"))
			if (duty>0) then
				outputChatBox("[RADIO] All units, Traffic violation at " .. areaName .. ".", value, 255, 194, 14)
				outputChatBox("[RADIO] Vehicle was a " .. vehicleName .. " travelling at " .. tostring(math.ceil(speed)) .. " KPH.", value, 255, 194, 14)
				outputChatBox("[RADIO] The plate is '"..  getVehiclePlateText ( theVehicle ) .."' and heading " .. direction .. ".", value, 255, 194, 14)
			end
		end
	end
end
