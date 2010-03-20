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
	
	local theTeam = getTeamFromName("Los Santos Police Department")
	local teamPlayers = getPlayersInTeam(theTeam)
	for key, value in ipairs(teamPlayers) do
		local duty = tonumber(getElementData(value, "duty"))
		if (duty>0) then
			outputChatBox("[RADIO] All units, we have a traffic violation at " .. areaName .. ".", value, 255, 194, 14)
			outputChatBox("[RADIO] Vehicle was a " .. vehicleName .. " travelling at " .. tostring(math.ceil(speed)) .. " KPH.", value, 255, 194, 14)
			outputChatBox("[RADIO] The plate is '"..  getVehiclePlateText ( theVehicle ) .."' and heading " .. direction .. ".", value, 255, 194, 14)
		end
	end
end

------------ Admin management ------------

mysql = exports.mysql

function loadAllTrafficCams(res)
	local result = mysql:query("SELECT id FROM `speedcams` ORDER BY `id` ASC")

	if (result) then
		local run = true
		while run do
			local row = exports.mysql:fetch_assoc(result)
			if not row then break end
			
			loadOneTrafficCam(row["id"])
		end
	end
	mysql:free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllTrafficCams)

function loadOneTrafficCam(id)
	local row = mysql:query_fetch_assoc("SELECT * FROM `speedcams` WHERE `id`='"..mysql:escape_string(id).."'")
	if (row) then
		local id = tonumber(row["id"])
		local maxspeed = tonumber(row["maxspeed"])		
		local interior = tonumber(row["interior"])
		local dimension = tonumber(row["dimension"])
		local x = tonumber(row["x"])
		local y = tonumber(row["y"])
		local z = tonumber(row["z"])-4
		local radius = tonumber(row["radius"])	
		
		local enabled
		local state = tonumber(row["enabled"])
		
		if (state == 1) then
			enabled = true
		else
			enabled = false
		end

		-- And spawn it
		local colTube = createColTube(x, y, z, radius, 15)
		exports.pool:allocateElement(colTube)
		exports['anticheat-system']:changeProtectedElementDataEx(colTube, "speedcam", true, false)
		exports['anticheat-system']:changeProtectedElementDataEx(colTube, "speedcam:dbid", id, false)
		exports['anticheat-system']:changeProtectedElementDataEx(colTube, "speedcam:maxspeed", maxspeed, false)
		exports['anticheat-system']:changeProtectedElementDataEx(colTube, "speedcam:enabled", enabled, false)
			
		setElementInterior(colTube, interior)
		setElementDimension(colTube, dimension)
		
		-- Hook it up to the event system
		addEventHandler("onColShapeHit", colTube, monitorSpeed)
		addEventHandler("onColShapeLeave", colTube, stopMonitorSpeed)
	end
end

function createTrafficCam(thePlayer, commandName, maxSpeed)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (maxSpeed) then
			outputChatBox("SYNTAX: /" .. commandName .. " [trigger speed in KPH]", thePlayer, 255, 194, 14)
		else
			if (tonumber(maxSpeed) > 35) then
				local x, y, z = getElementPosition(thePlayer)
				local dimension = getElementDimension(thePlayer)
				local interior = getElementInterior(thePlayer)
				
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new", true, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new:x", x, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new:y", y, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new:z", z, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new:dimension", dimension, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new:interior", interior, false)
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new:maxspeed", tonumber(maxSpeed), false)
				outputChatBox("Okay, stored. Now set the outside of the speedcam with /setradius.", thePlayer, 255, 0, 0)
			else
				outputChatBox("The trigger speed needs to be above 35 KPH.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addspeedcam", createTrafficCam, false, false)

function setTrafficCamRadius(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local checkPoint = getElementData(thePlayer, "speedcam:new")
		if (checkPoint) then
			-- Load saved data
			local x = getElementData(thePlayer, "speedcam:new:x")
			local y = getElementData(thePlayer, "speedcam:new:y")
			local z = getElementData(thePlayer, "speedcam:new:z")
			local dimension = getElementData(thePlayer, "speedcam:new:dimension")
			local interior = getElementData(thePlayer, "speedcam:new:interior")
			local maxspeed = getElementData(thePlayer, "speedcam:new:maxspeed")
			
			-- Fetch new data
			local newx, newy, newz = getElementPosition(thePlayer)
			local newdimension = getElementDimension(thePlayer)
			local newinterior = getElementInterior(thePlayer)
			
			-- Calulate radius
			local radius = math.floor(getDistanceBetweenPoints2D(x, y, newx, newy))
			if (radius > 99) then
				outputChatBox("Radius is too big.", thePlayer, 255, 0, 0)
			else
				exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "speedcam:new", false, false)
				local id = mysql:query_insert_free("INSERT INTO `speedcams` SET `enabled`='1', `radius`='".. mysql:escape_string(radius) .."', `maxspeed`='"..mysql:escape_string(maxspeed).."', `x`='" .. mysql:escape_string(x) .. "', `y`='" .. mysql:escape_string(y) .. "', `z`='" .. mysql:escape_string(z) .. "', interior='" .. mysql:escape_string(interior) .. "', dimension='" .. mysql:escape_string(dimension) .. "'")
				if (id) then
					exports.irc:sendMessage("[ADMIN] " .. getPlayerName( thePlayer ) .. " spawned speedcam " .. id)
					loadOneTrafficCam(id)
				else
					outputChatBox("Failed to create speedcam.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setradius", setTrafficCamRadius, false, false)

function delTrafficCam(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local colShape = nil
			
		for key, possibleSpeedcam in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local isSpeedcam = getElementData(possibleSpeedcam, "speedcam")
			if (isSpeedcam) then
				if (isElementWithinColShape(thePlayer, possibleSpeedcam)) then
					colShape = possibleSpeedcam
				end
			end
		end
		
		if (colShape) then
			local id = getElementData(colShape, "speedcam:dbid")
			local result = mysql:query_free("DELETE FROM `speedcams` WHERE `id`='" .. mysql:escape_string(id) .. "'")				
			outputChatBox("Speedcam #" .. id .. " deleted.", thePlayer)
			exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " deleted speedcam #" .. id .. ".")
			destroyElement(colShape)
		else
			outputChatBox("You are not in a fuel station.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delspeedcam", delTrafficCam, false, false)

function getNearbyTrafficCams(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Speedcams:", thePlayer, 255, 126, 0)
		local found = false
		
		for k, theColshape in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local isSpeedcam = getElementData(theColshape, "speedcam")
			if (isSpeedcam) then
				local x, y = getElementPosition(theColshape)
				local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
				if (distance<=20) then
					local dbid = getElementData(theColshape, "speedcam:dbid")
					outputChatBox("   ID " .. dbid .. ".", thePlayer, 255, 126, 0)
					found = true
				end
			end
		end
		
		if not (found) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyspeedcams", getNearbyTrafficCams, false, false)