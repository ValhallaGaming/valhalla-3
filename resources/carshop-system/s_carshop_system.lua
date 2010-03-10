local mysql = exports.mysql

carshopPickup = createPickup(544.4990234375, -1292.7890625, 17.2421875, 3, 1239)
exports['anticheat-system']:changeProtectedElementDataEx(carshopPickup, "shopid", 1, false)

boatshopPickup = createPickup(715.35546875, -1705.5791015625, 2.4296875, 3, 1239)
exports['anticheat-system']:changeProtectedElementDataEx(boatshopPickup, "shopid", 2, false)

cheapcarshopPickup = createPickup( 2131.8115234375, -1151.3212890625, 24.060283660889, 3, 1239)
exports['anticheat-system']:changeProtectedElementDataEx(cheapcarshopPickup, "shopid", 3, false)

function pickupUse(thePlayer)
	if getElementData(source, "shopid") then
		if getElementData(thePlayer, "license.car") == 1 then
			triggerClientEvent(thePlayer, "showCarshopUI", thePlayer, getElementData(source, "shopid"))
		else
			outputChatBox("You need a Driving License to buy a car.", thePlayer, 255, 0, 0)
		end
	end
	cancelEvent()
end
addEventHandler("onPickupHit", getResourceRootElement(), pickupUse)

function buyCar(id, cost, col1, col2, x, y, z, rz, px, py, pz, prz, shopID)
	if exports.global:hasMoney(source, cost) then
		if exports.global:canPlayerBuyVehicle(source) then
			outputChatBox("You bought a " .. getVehicleNameFromModel(id) .. " for " .. cost .. "$. Enjoy!", source, 255, 194, 14)
			
			if shopID == 1 then
				outputChatBox("You can set this vehicles spawn position by parking it and typing /park", source, 255, 194, 14)
				outputChatBox("Vehicles parked near the dealership or bus spawn point will be deleted without notice.", source, 255, 0, 0)
			elseif shopID == 2 then
				outputChatBox("You can set this boats spawn position by parking it and typing /park", source, 255, 194, 14)
				outputChatBox("Boats parked near the marina will be deleted without notice.", source, 255, 0, 0)
			end
			outputChatBox("If you do not use /park within an hour, your car will be DELETED.", source, 255, 0, 0)
			outputChatBox("Press 'K' to unlock this vehicle.", source, 255, 194, 14)
			makeCar(source, id, cost, col1, col2, x, y, z, rz, px, py, pz, prz)
		else
			outputChatBox("You tried to buy a car, but you have too many vehicles already.", source, 255, 0, 0)
		end
	end
end
addEvent("buyCar", true)
addEventHandler("buyCar", getRootElement(), buyCar)

function makeCar(thePlayer, id, cost, col1, col2, x, y, z, rz, px, py, pz, prz)
	if not exports.global:takeMoney(thePlayer, cost) then
		return
	end
	
	if not exports.global:canPlayerBuyVehicle(source) then
		return
	end
	
	local rx = 0
	local ry = 0
		
	setElementPosition(thePlayer, px, py, pz)
	setPedRotation(thePlayer, prz)
	
	local username = getPlayerName(thePlayer)
	local dbid = getElementData(thePlayer, "dbid")
	
	local letter1 = string.char(math.random(65,90))
	local letter2 = string.char(math.random(65,90))
	local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
	local locked = 0
		
	local insertid = mysql:query_insert_free("INSERT INTO vehicles SET model='" .. mysql:escape_string(id) .. "', x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotx='" .. mysql:escape_string(rx) .. "', roty='" .. mysql:escape_string(ry) .. "', rotz='" .. mysql:escape_string(rz) .. "', color1='" .. mysql:escape_string(col1) .. "', color2='" .. mysql:escape_string(col2) .. "', faction='-1', owner='" .. mysql:escape_string(dbid) .. "', plate='" .. mysql:escape_string(plate) .. "', currx='" .. mysql:escape_string(x) .. "', curry='" .. mysql:escape_string(y) .. "', currz='" .. mysql:escape_string(z) .. "', currrx='0', currry='0', currrz='" .. mysql:escape_string(rz) .. "', locked='" .. mysql:escape_string(locked) .. "'")
	
	if (insertid) then
		local veh = call( getResourceFromName( "vehicle-system" ), "createShopVehicle", insertid, id, x, y, z, 0, 0, rz, plate )
		
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", 100, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "Impounded", 0)
		
		setVehicleRespawnPosition(veh, x, y, z, 0, 0, rz)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "respawnposition", {x, y, z, 0, 0, rz}, false)
		setVehicleLocked(veh, false)
		
		setVehicleColor(veh, col1, col2, col1, col2)
		
		setVehicleOverrideLights(veh, 1)
		setVehicleEngineState(veh, false)
		setVehicleFuelTankExplodable(veh, false)
		
		-- make sure it's an unique key
		call( getResourceFromName( "item-system" ), "deleteAll", 3, insertid )
		exports.global:giveItem( thePlayer, 3, insertid )
		
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "fuel", 100, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "engine", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldx", x, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldy", y, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "oldz", z, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "faction", -1)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "owner", dbid, false)
		exports['anticheat-system']:changeProtectedElementDataEx(veh, "job", 0, false)
		
		if getVehicleType(veh) == "Boat" then
			exports.global:givePlayerAchievement(thePlayer, 27)
		else
			exports.global:givePlayerAchievement(thePlayer, 17) -- my ride
		end
		
		exports.logs:logMessage("[CAR SHOP] " .. getPlayerName( thePlayer ) .. " bought car #" .. insertid .. " (" .. getVehicleNameFromModel( id ) .. ")", 9)
	end
end
