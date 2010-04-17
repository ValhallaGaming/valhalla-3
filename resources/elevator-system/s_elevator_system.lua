mysql = exports.mysql

addEvent("onPlayerInteriorChange", true)

function createElevator(thePlayer, commandName, interior, dimension, ix, iy, iz)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (interior) or not (dimension) or not (ix) or not (iy) or not (iz) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [Dimension ID] [X] [Y] [Z]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			
			interior = tonumber(interior)
			dimension = tonumber(dimension)
			local interiorwithin = getElementInterior(thePlayer)
			local dimensionwithin = getElementDimension(thePlayer)
			ix = tonumber(ix)
			iy = tonumber(iy)
			iz = tonumber(iz)
			id = SmallestElevatorID()
			if id then
				local query = mysql:query_free("INSERT INTO elevators SET id='" .. mysql:escape_string(id) .. "', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', tpx='" .. mysql:escape_string(ix) .. "', tpy='" .. mysql:escape_string(iy) .. "', tpz='" .. mysql:escape_string(iz) .. "', dimensionwithin='" .. mysql:escape_string(dimensionwithin) .. "', interiorwithin='" .. mysql:escape_string(interiorwithin) .. "', dimension='" .. mysql:escape_string(dimension) .. "', interior='" .. mysql:escape_string(interior) .. "'")
				if (query) then
					local pickup = createPickup(x, y, z, 3, 1318)
					exports.pool:allocateElement(pickup)
					local intpickup = createPickup(ix, iy, iz, 3, 1318)
					exports.pool:allocateElement(intpickup)
					
					exports['anticheat-system']:changeProtectedElementDataEx(pickup, "dbid", id, false)
					exports['anticheat-system']:changeProtectedElementDataEx(pickup, "other", intpickup)
					exports['anticheat-system']:changeProtectedElementDataEx(pickup, "car", 0, false)
					setElementInterior(pickup, interiorwithin)
					setElementDimension(pickup, dimensionwithin)
					
					exports['anticheat-system']:changeProtectedElementDataEx(intpickup, "dbid", id, false)
					exports['anticheat-system']:changeProtectedElementDataEx(intpickup, "other", pickup)
					exports['anticheat-system']:changeProtectedElementDataEx(intpickup, "car", 0, false)
					setElementInterior(intpickup, interior)
					setElementDimension(intpickup, dimension)
					
					outputChatBox("Elevator created with ID #" .. id .. "!", thePlayer, 0, 255, 0)
				end
			else
				outputChatBox("There was an error while creating an elevator. Try again.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addelevator", createElevator, false, false)

function loadAllElevators(res)
	local result = mysql:query("SELECT id, x, y, z, tpx, tpy, tpz, dimensionwithin, interiorwithin, dimension, interior, car, disabled FROM elevators")
	local counter = 0
	
	if (result) then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			
			local id = tonumber(row["id"])
			local x = tonumber(row["x"])
			local y = tonumber(row["y"])
			local z = tonumber(row["z"])
			
			local ix = tonumber(row["tpx"])
			local iy = tonumber(row["tpy"])
			local iz = tonumber(row["tpz"])
			
			local dimensionwithin = tonumber(row["dimensionwithin"])
			local interiorwithin = tonumber(row["interiorwithin"])
			
			local dimension = tonumber(row["dimension"])
			local interior = tonumber(row["interior"])
			local car = tonumber(row["car"])
			local disabled = tonumber(row["disabled"])
			
			local pickup = createPickup(x, y, z, 3, disabled == 1 and 1314 or 1318)
			exports.pool:allocateElement(pickup)
			local intpickup = createPickup(ix, iy, iz, 3, disabled == 1 and 1314 or 1318)
			exports.pool:allocateElement(intpickup)
			
			exports['anticheat-system']:changeProtectedElementDataEx(pickup, "dbid", id, false)
			exports['anticheat-system']:changeProtectedElementDataEx(pickup, "other", intpickup)
			exports['anticheat-system']:changeProtectedElementDataEx(pickup, "car", car, false)
			setElementInterior(pickup, interiorwithin)
			setElementDimension(pickup, dimensionwithin)
				
			exports['anticheat-system']:changeProtectedElementDataEx(intpickup, "dbid", id, false)
			exports['anticheat-system']:changeProtectedElementDataEx(intpickup, "other", pickup)
			exports['anticheat-system']:changeProtectedElementDataEx(intpickup, "car", car, false)
			setElementInterior(intpickup, interior)
			setElementDimension(intpickup, dimension)
			counter = counter + 1
		end
		mysql:free_result(result)
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " Elevators.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllElevators)

function hitInteriorPickup( thePlayer )
	local pickuptype = getElementData(source, "type")
	
	local pdimension = getElementDimension(thePlayer)
	local idimension = getElementDimension(source)
	
	if pdimension == idimension then -- same dimension?
		local dbid, thePickup, theExit = call( getResourceFromName( "interior-system" ), "findProperty", player, getElementDimension( getElementData( source, "other" ) ) )
		if thePickup and getElementDimension( thePickup ) ~= getElementDimension( theExit ) then
			local name = getElementData( thePickup, "name" )
			
			if name then
				local owner = getElementData( thePickup, "owner" )
				local cost = getElementData( thePickup, "cost" )
				
				local ownerName = exports['vehicle-system']:getCharacterName( owner ) or "None"
				triggerClientEvent(thePlayer, "displayInteriorName", thePlayer, name, ownerName, getElementData( thePickup, "inttype" ), cost, getElementData( thePickup, "fee" ) )
			end
		end
		
		bindKeys( thePlayer, source )
		setTimer( checkLeavePickup, 500, 1, thePlayer, source ) 
	end
	cancelEvent()
end
addEventHandler("onPickupHit", getResourceRootElement(), hitInteriorPickup)

function isInPickup( thePlayer, thePickup, distance )
	local ax, ay, az = getElementPosition(thePlayer)
	local bx, by, bz = getElementPosition(thePickup)
	
	return getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) < ( distance or 2 ) and getElementInterior(thePlayer) == getElementInterior(thePickup) and getElementDimension(thePlayer) == getElementDimension(thePickup)
end

function checkLeavePickup( thePlayer, thePickup )
	if isElement( thePlayer ) then
		if isInPickup( thePlayer, thePickup ) then
			setTimer(checkLeavePickup, 1000, 1, thePlayer, thePickup)
		else
			unbindKeys(thePlayer, thePickup)
		end
	end
end

function func (player, f, down, player, pickup) enterElevator(player, pickup) end 

function bindKeys(player, pickup)
	if (isElement(player)) then
		if not(isKeyBound(player, "enter", "down", func)) then
			bindKey(player, "enter", "down", func, player, pickup)
		end
		
		if not(isKeyBound(player, "f", "down", func)) then
			bindKey(player, "f", "down", func, player, pickup)
		end
		
		exports['anticheat-system']:changeProtectedElementDataEx( player, "interiormarker", true, false )
	end
end

function unbindKeys(player, pickup)
	if (isElement(player)) then
		if (isKeyBound(player, "enter", "down", func)) then
			unbindKey(player, "enter", "down", func, player, pickup)
		end
		
		if (isKeyBound(player, "f", "down", func)) then
			unbindKey(player, "f", "down", func, player, pickup)
		end
		
		exports['anticheat-system']:changeProtectedElementDataEx( player, "interiormarker" )
		triggerClientEvent( player, "displayInteriorName", player )
	end
end


function isInteriorLocked(dimension)
	local result = mysql:query_fetch_assoc("SELECT type, locked FROM `interiors` WHERE id = " .. mysql:escape_string(dimension))
	local locked = false
	if result then
		if tonumber(result["rype"]) ~= 2 and tonumber(result["locked"]) == 1 then 
			locked = true
		end
	end
	return locked
end

--[[
Car Teleport Modes:
0: players only
1: players and vehicles
2: vehicles only
3: no entrance
]]--
function enterElevator(player, pickup)
	local cartp = getElementData( pickup, "car" )
	if cartp == 3 then
		outputChatBox("You try the door handle, but it seems to be locked.", player, 255, 0,0, true)
		return
	end
	
	vehicle = getPedOccupiedVehicle( player )
	if isInPickup ( player, pickup ) and ( ( vehicle and cartp ~= 0 and getVehicleOccupant( vehicle ) == player ) or not vehicle ) then
		if not vehicle and cartp == 2 then
			outputChatBox( "This entrance is for vehicles only.", player, 255, 0, 0 )
			return
		end
		
		if getElementModel( pickup ) == 1314 then
			outputChatBox( "This interior is currently disabled.", player, 255, 0, 0 )
			return
		end
		
		local other = getElementData( pickup, "other" )
		
		local x, y, z = getElementPosition( other )
		local interior = getElementInterior( other )
		local dimension = getElementDimension( other )
		
		-- find the pickup inside to see if the house is locked
		local ldimension = getElementDimension( pickup )
		
		local locked = false
		if ldimension == 0 and dimension ~= 0 then -- entering a house
			locked = isInteriorLocked(dimension)
		elseif ldimension ~= 0 and dimension == 0 then -- leaving a house
			locked = isInteriorLocked(ldimension)
		elseif ldimension ~= 0 and dimension ~= 0 and ldimension ~= dimension then -- changing between two houses
			locked = isInteriorLocked(ldimension) or isInteriorLocked(dimension)
		else -- outside
			locked = false
		end
		
		if locked then
			outputChatBox("You try the door handle, but it seems to be locked.", player, 255, 0,0, true)
			return
		end
		
		-- check for entrance fee
		local dbid, thePickup = call( getResourceFromName( "interior-system" ), "findProperty", player, dimension )
		if dimension ~= ldimension and thePickup then
			if getElementData( player, "adminduty" ) ~= 1 and not exports.global:hasItem( player, 5, getElementData( thePickup, "dbid" ) ) then
				local fee = getElementData( thePickup, "fee" )
				if fee and fee > 0 then
					if not exports.global:takeMoney( player, fee ) then
						outputChatBox( "You don't have enough money with you to enter this interior.", player, 255, 0, 0 )
						return
					else
						local ownerid = getElementData( thePickup, "owner" )
						local query = mysql:query_free("UPDATE characters SET bankmoney = bankmoney + " .. mysql:escape_string(fee) .. " WHERE id = " .. mysql:escape_string(ownerid) )
						if query then							
							for k, v in pairs( getElementsByType( "player" ) ) do
								if isElement( v ) then
									if getElementData( v, "dbid" ) == ownerid then
										exports['anticheat-system']:changeProtectedElementDataEx( v, "businessprofit", getElementData( v, "businessprofit" ) + fee, false )
										break
									end
								end
							end
						else
							outputChatBox( "Error 9019 - Report on Forums.", player, 255, 0, 0 )
						end
					end
				end
			end
		end
		
		if vehicle then
			exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "health", getElementHealth(vehicle), false)
			for i = 0, getVehicleMaxPassengers( vehicle ) do
				local p = getVehicleOccupant( vehicle )
				if p then
					-- fade camera to black
					fadeCamera ( p, false, 1,0,0,0 )
					
					triggerClientEvent( p, "CantFallOffBike", p )
				end
			end
		else
			-- fade camera to black
			fadeCamera ( player, false, 1,0,0,0 )
		end
		
		-- teleport the player during the black fade
		if vehicle then
			setTimer(function()
				if isElement(vehicle) then
					local offset = getElementData(vehicle, "groundoffset") or 2
					setElementInterior(vehicle, interior)
					setElementDimension(vehicle, dimension)
					setElementPosition(vehicle, x, y, z - 1 + offset)
					setElementVelocity(vehicle, 0, 0, 0)
					setVehicleTurnVelocity(vehicle, 0, 0, 0)
					local rx, ry, rz = getVehicleRotation(vehicle)
					setVehicleRotation(vehicle, 0, 0, rz)
					setTimer(setVehicleTurnVelocity, 50, 2, vehicle, 0, 0, 0)
					
					setElementHealth(vehicle, getElementData(vehicle, "health"))
					exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "health")
					
					setVehicleFrozen(vehicle, true)
					setTimer(setVehicleFrozen, 1500, 1, vehicle, false)
					
					for i = 0, getVehicleMaxPassengers( vehicle ) do
						local player = getVehicleOccupant( vehicle, i )
						if player then
							setElementInterior(player, interior)
							setCameraInterior(player, interior)
							setElementDimension(player, dimension)
							setCameraTarget(player)
							
							triggerEvent("onPlayerInteriorChange", player, pickup, other)
							
							-- fade camera in
							setTimer(fadeCamera, 1000, 1 , player , true, 2)
							
							triggerClientEvent(player, "usedElevator", player)
							setPedFrozen(player, true)
							setPedGravity(player, 0)
						end
					end
				end
			end, 1000, 1)
		elseif isElement(player) then
			setPedGravity( player, 0 )
			triggerClientEvent(player, "setPlayerInsideInterior", pickup, other)
		end
		playSoundFrontEnd(player, 40)
	end
end

function resetGravity()
	setPedFrozen(source, false)
	setPedGravity(source, 0.008)
end
addEvent("resetGravity", true)
addEventHandler("resetGravity", getRootElement(), resetGravity)

function deleteElevator(thePlayer, commandName, id)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
			
			local counter = 0
			for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
				local pickupID = tonumber(getElementData(thePickup, "dbid"))
				if pickupID == id then
					destroyElement(thePickup)
					counter = counter + 1
				end
			end
			
			if (counter>0) then -- ID Exists
				mysql:query_free("DELETE FROM elevators WHERE id='" .. mysql:escape_string(id) .. "'")

				outputChatBox("Elevator #" .. id .. " Deleted!", thePlayer, 0, 255, 0)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted elevator #" .. id .. ".")
			else
				outputChatBox("Elevator ID does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delelevator", deleteElevator, false, false)

function TempDelete(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
			if isInPickup(thePlayer, thePickup) then
				local dbid = getElementData(thePickup, "dbid")
				local query = mysql:query_free( "DELETE FROM elevators WHERE id='" .. mysql:escape_string(dbid) .. "'")
				if (query) then
					outputChatBox(" Elevator deleted", thePlayer)
				end
			end
		end
	end
end
addCommandHandler("tempdelete", TempDelete, false, false)

function getNearbyElevators(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Elevators:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
			if isInPickup(thePlayer, thePickup, 10) then
				local dbid = getElementData(thePickup, "dbid")
				outputChatBox("   Elevator with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyelevators", getNearbyElevators, false, false)

function SmallestElevatorID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql:query_fetch_assoc("SELECT MIN(e1.id+1) AS nextID FROM elevators AS e1 LEFT JOIN elevators AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		return tonumber(result["nextID"])
	end
	return false
end

addEvent( "toggleCarTeleportMode", false )
addEventHandler( "toggleCarTeleportMode", getRootElement(),
	function( player )
		local mode = ( getElementData( source, "car" ) + 1 ) % 4
		local query = mysql:query_free("UPDATE elevators SET car = " .. mysql:escape_string(mode) .. " WHERE id = " .. mysql:escape_string(getElementData( source, "dbid" )) )
		if query then
			if mode == 0 then
				outputChatBox( "You changed the mode to 'players only'.", player, 0, 255, 0 )
			elseif mode == 1 then
				outputChatBox( "You changed the mode to 'players and vehicles'.", player, 0, 255, 0 )
			elseif mode == 2 then
				outputChatBox( "You changed the mode to 'vehicles only'.", player, 0, 255, 0 )
			else
				outputChatBox( "You changed the mode to 'no entrance'.", player, 0, 255, 0 )
			end
			
			exports['anticheat-system']:changeProtectedElementDataEx( source, "car", mode, false )
			exports['anticheat-system']:changeProtectedElementDataEx( getElementData( source, "other" ), "car", mode )
		else
			outputChatBox( "Error 9019 - Report on Forums.", player, 255, 0, 0 )
		end
	end
)

function toggleElevator( thePlayer, commandName, id )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		id = tonumber( id )
		if not id then
			outputChatBox( "SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14 )
		else
			local pickup = nil
			for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
				local dbid = getElementData(thePickup, "dbid")
				if dbid == id then
					pickup = thePickup
					break
				end
			end
			
			if pickup then
				if getElementModel( pickup ) == 1314 then
					mysql:query_free("UPDATE elevators SET disabled = 0 WHERE id = " .. mysql:escape_string(id) )
					
					setPickupType( pickup, 3, 1318 )
					setPickupType( getElementData( pickup, "other" ), 3, 1318 )
					
					outputChatBox( "Elevator #" .. id .. " enabled.", thePlayer, 0, 255, 0 )
				else
					mysql:query_free("UPDATE elevators SET disabled = 1 WHERE id = " .. mysql:escape_string(id) )
					
					setPickupType( pickup, 3, 1314 )
					setPickupType( getElementData( pickup, "other" ), 3, 1314 )
					
					outputChatBox( "Elevator #" .. id .. " disabled.", thePlayer, 255, 0, 0 )
				end
			end
		end
	end
end
addCommandHandler( "toggleelevator", toggleElevator )

function enableAllElevators( thePlayer )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		mysql:query_free("UPDATE elevators SET disabled = 0 WHERE disabled = 1" )
		for k, thePickup in ipairs(getElementsByType("pickup", getResourceRootElement())) do
			if getElementModel( thePickup ) == 1314 then
				setPickupType( thePickup, 3, 1318 )
			end
		end
	end
end
addCommandHandler( "enableallelevators", enableAllElevators )