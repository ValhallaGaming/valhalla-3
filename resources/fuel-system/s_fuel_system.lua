mysql = exports.mysql

fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

FUEL_PRICE = 2
MAX_FUEL = 100

oldFuel = { }
syncedPlayers = { }

-- cache the fuel
for key, value in ipairs(getElementsByType("vehicle")) do
	if (isElement(value)) then
		local fuel = getElementData(value, "fuel")
		oldFuel[value] = fuel
	end
end

function syncFuelOnEnter(player)
	local fuel = getElementData(source, "fuel")

	if (syncedPlayers[player] == nil) or (tonumber(oldFuel[source]) ~= tonumber(fuel)) then -- sync it if we haven't already got it's data, or it's changed
		
		if (syncedPlayers[player] == nil) then
			syncedPlayers[player] = true
		end
		
		oldFuel[source] = fuel
		
		if (fuel~=100) then
			triggerClientEvent(player, "syncFuel", source, fuel)
		else
			triggerClientEvent(player, "syncFuel", source)
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), syncFuelOnEnter)

function playerQuit()
	syncedPlayers[source] = nil
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)

function onDestroy()
	if (getElementType(source)=="vehicle") then
		oldFuel[source] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), onDestroy)
	

function fuelDepleting()
	local players = exports.pool:getPoolElementsByType("player")
	for k, v in ipairs(players) do
		if isPedInVehicle(v) then
			local veh = getPedOccupiedVehicle(v)
			if (veh) then
				local seat = getPedOccupiedVehicleSeat(v)
				
				if (seat==0) then
					local model = getElementModel(veh)
					if not (fuellessVehicle[model]) then -- Don't display it if it doesnt have fuel...
						
						local oldx = getElementData(veh, "oldx")
						local oldy = getElementData(veh, "oldy")
						local oldz = getElementData(veh, "oldz")
						local fuel = getElementData(veh, "fuel")
						local engine = getElementData(veh, "engine")
						
						local x, y, z = getElementPosition(veh)
						
						if engine == 1 then
							if fuel >= 1 then
								distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
								if (distance==0) then
									distance = 5  -- fuel leaking away when not moving
								end
								newFuel = fuel - (distance/200)
								setElementData(veh, "fuel", newFuel, false)
								triggerClientEvent(v, "syncFuel", veh, newFuel)
								oldFuel[veh] = newFuel
								setElementData(veh, "oldx", x, false)
								setElementData(veh, "oldy", y, false)
								setElementData(veh, "oldz", z, false)
								
								if newFuel < 1 then
									setVehicleEngineState(veh, false)
									setElementData(veh, "engine", 0, false)
									toggleControl(v, 'brake_reverse', false)
								end
							end
						end
					end
				end
			end
		end
	end
end
setTimer(fuelDepleting, 10000, 0)

function FuelDepetingEmptyVehicles()
	local vehicles = exports.pool:getPoolElementsByType("vehicle")
	for ka, theVehicle in ipairs(vehicles) do
		local enginestatus = getElementData(theVehicle, "engine")
		local vehid = getElementData(theVehicle, "dbid")
		
		if (enginestatus == 1) then
			local driver = getVehicleOccupant(theVehicle)
			if (driver == false) then
				local fuel = getElementData(theVehicle, "fuel")
				if fuel >= 1 then
					local newFuel = fuel - (30/200)
					setElementData(theVehicle, "fuel", newFuel, false)
					if (newFuel<1) then
						setVehicleEngineState(theVehicle, false)
						setElementData(theVehicle, "engine", 0, false)
					end
				end
			end
		end
	end
end
setTimer(FuelDepetingEmptyVehicles, 30000,0)

-- [////ADMIN COMMANDS/////]
function createFuelPoint(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		
		local id = mysql:query_insert_free("INSERT INTO fuelstations SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', interior='" .. interior .. "', dimension='" .. dimension .. "'")
		if (id) then
			local theSphere = createColSphere(x, y, z, 20)
			exports.pool:allocateElement(theSphere)
			setElementDimension(theSphere, dimension)
			setElementInterior(theSphere, interior)
			setElementData(theSphere, "type", "fuel", false)
			setElementData(theSphere, "dbid", id, false)
			
			outputChatBox("Fuel point added with ID #" .. id .. ".", thePlayer)
			exports.irc:sendMessage("[ADMIN] " .. getPlayerName( thePlayer ) .. " spawned fuel point " .. id)
		else
			outputChatBox("Failed to create fuel point.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("addfuelpoint", createFuelPoint, false, false)

function getNearbyFuelpoints(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Fuelpoints:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theColshape in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local colshapeType = getElementData(theColshape, "type")
			if (colshapeType) then
				if (colshapeType=="fuel") then
					local x, y = getElementPosition(theColshape)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					if (distance<=10) then
						local dbid = getElementData(theColshape, "dbid")
						outputChatBox("   Fuelpoint with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyfuelpoints", getNearbyFuelpoints, false, false)

function randomizeFuelPrice()
	FUEL_PRICE = math.random(1, 2) / 3
end
setTimer(randomizeFuelPrice, 3600000, randomizeFuelPrice)

function loadFuelPoints(res)
	local result = mysql:query("SELECT id, x, y, z, dimension, interior FROM fuelstations")
	local counter = 0
	
	if (result) then
		local continue = true
		while continue do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			
			local id = row["id"]
			local x = tonumber(row["x"])
			local y = tonumber(row["y"])
			local z = tonumber(row["z"])
			
			local dimension = tonumber(row["dimension"])
			local interior = tonumber(row["interior"])
			
			local theSphere = createColSphere(x, y, z, 20)
			exports.pool:allocateElement(theSphere)
			setElementDimension(theSphere, dimension)
			setElementInterior(theSphere, interior)
			setElementData(theSphere, "type", "fuel", false)
			setElementData(theSphere, "dbid", id, false)
			counter = counter + 1
		end
		mysql:free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadFuelPoints)

local vehiclesFueling = { }
function fillVehicle(thePlayer, commandName, amount)
	local amount = tonumber(amount)
	if not (isPedInVehicle(thePlayer)) then
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	else
		local colShape = nil
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			if isElement(value) then
				local shapeType = getElementData(value, "type")
				if (shapeType) then
					if (shapeType=="fuel") then
						if (isElementWithinColShape(thePlayer, value)) then
							colShape = value
						end
					end
				end
			end
		end
		
		if (colShape) then
			local veh = getPedOccupiedVehicle(thePlayer)
			local currFuel = tonumber(getElementData(veh, "fuel"))
			--outputDebugString(tostring(vehiclesFueling[veh]))
			if (math.ceil(currFuel)==MAX_FUEL) then
				outputChatBox("This vehicle is already full.", thePlayer, 255, 0, 0)
			elseif (vehiclesFueling[veh] ~= nil) then
				outputChatBox("You are already filling this vehicle.", thePlayer, 255, 0, 0)
			elseif (getVehicleEngineState(veh) == true) then
				outputChatBox("You cannot fill a car with a running engine.", thePlayer, 255, 0, 0)
			else
				local faction = getPlayerTeam(thePlayer)
				local ftype = getElementData(faction, "type")
				local fid = getElementData(faction, "id")
				
				if (ftype~=2) and (ftype~=3) and (ftype~=4) and (fid~=30) and not (exports.global:isPlayerSilverDonator(thePlayer)) then
					local money = exports.global:getMoney(thePlayer)
					
					local tax = exports.global:getTaxAmount()
					local cost = FUEL_PRICE + (tax*FUEL_PRICE)
					local litresAffordable = math.ceil(money/cost)
					
					if amount and amount <= litresAffordable and amount > 0 then
						litresAffordable = amount
					end
					
					if (litresAffordable>100) then
						litresAffordable=100
					end
					
					if (litresAffordable+currFuel>100) then
						litresAffordable = 100 - currFuel
					end
					
					if (litresAffordable==0) then
						outputChatBox("You cannot afford any fuel.", thePlayer, 255, 0, 0)
					else
						vehiclesFueling[veh] = true
						outputChatBox("Refilling Vehicle...", thePlayer)
						setTimer(fuelTheVehicle, 5000, 1, thePlayer, veh, colShape, litresAffordable, false)
					end
				else
					vehiclesFueling[veh] = true
					outputChatBox("Refilling Vehicle...", thePlayer)
					
					litresAffordable = 100
					if (litresAffordable+currFuel>100) then
						litresAffordable = 100 - currFuel
					end
					
					setTimer(fuelTheVehicle, 5000, 1, thePlayer, veh, colShape, litresAffordable, true)
				end
			end
		end
	end
end
addCommandHandler("fill", fillVehicle)

function fillCan(thePlayer, commandName, amount)
	local amount = tonumber(amount)
	if not (exports.global:hasItem(thePlayer, 57)) then
		outputChatBox("You do not have a fuel can.", thePlayer, 255, 0, 0)
	else
		local colShape = nil
		
		for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local shapeType = getElementData(value, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					if (isElementWithinColShape(thePlayer, value)) then
						colShape = value
					end
				end
			end
		end
		
		if (colShape) then
			local currFuel = 25
			local slot = -1
			local items = exports['item-system']:getItems(thePlayer)
			for k, v in pairs( items ) do
				if v[1] == 57 and v[2] < 25 then
					currFuel = v[2]
					slot = k
					break
				end
			end

			if (math.ceil(currFuel)==25) then
				outputChatBox("This fuel can is already full.", thePlayer)
			else
				local faction = getPlayerTeam(thePlayer)
				local ftype = getElementData(faction, "type")
				
				if (ftype~=2) and (ftype~=3) and (ftype~=4) then
					local money = exports.global:getMoney(thePlayer)
					
					local tax = exports.global:getTaxAmount()
					local cost = FUEL_PRICE + (tax*FUEL_PRICE)
					local litresAffordable = math.ceil(money/cost)
					
					if amount and amount <= litresAffordable and amount > 0 then
						litresAffordable = amount
					end
					
					if (litresAffordable>25) then
						litresAffordable=25
					end
					
					if (litresAffordable+currFuel>25) then
						litresAffordable = 25 - currFuel
					end
						
					if (litresAffordable==0) then
						outputChatBox("You cannot afford any fuel.", thePlayer, 255, 0, 0)
					else
						local fuelCost = math.floor(litresAffordable*cost)
						outputChatBox("Gas Station Receipt:", thePlayer)
						outputChatBox("    " .. math.ceil(litresAffordable) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
						exports.global:takeMoney(thePlayer, fuelCost, true)
						exports['item-system']:updateItemValue(thePlayer, slot, currFuel+litresAffordable)
					end
				else
					litresAffordable = 25
					if (litresAffordable+currFuel>25) then
						litresAffordable = 25 - currFuel
					end
					
					fuelCost = 0
					outputChatBox("Gas Station Receipt:", thePlayer)
					outputChatBox("    " .. math.ceil(litresAffordable) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
					exports['item-system']:updateItemValue(thePlayer, slot, currFuel+litresAffordable)
				end
			end
		end
	end
end
addCommandHandler("fillcan", fillCan)

function fuelTheVehicle(thePlayer, theVehicle, theShape, theLitres, free)
	local colShape = nil
	
	for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
		if isElement(value) then
			local shapeType = getElementData(value, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					if (isElementWithinColShape(thePlayer, value)) then
						colShape = value
					end
				end
			end
		end
	end
	
	
	-- Check the player didn't move
	if (colShape) then
		if (colShape==theShape) then
			if (getVehicleEngineState(theVehicle) == false) then
				local tax = exports.global:getTaxAmount()
				local fuelCost = math.floor(theLitres*(FUEL_PRICE + (tax*FUEL_PRICE)))

				if (free) then
					fuelCost = 0
				end
				
				exports.global:takeMoney(thePlayer, fuelCost, true)
			
				local loldFuel = getElementData(theVehicle, "fuel")
				local newFuel = loldFuel+theLitres
				setElementData(theVehicle, "fuel", newFuel, false)
				triggerClientEvent(thePlayer, "syncFuel", theVehicle, newFuel)
				oldFuel[theVehicle] = newFuel
				--triggerClientEvent(thePlayer, "setClientFuel", thePlayer, newFuel)
				
				outputChatBox("Gas Station Receipt:", thePlayer)
				outputChatBox("    " .. math.ceil(theLitres) .. " Litres of petrol    -    " .. fuelCost .. "$", thePlayer)
			else
				outputChatBox("Fueling aborted, you've started the engine.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Don't want my fuel?", thePlayer)
		end
	else
		outputChatBox("Don't want my fuel?", thePlayer)
	end
	vehiclesFueling[theVehicle] = nil
end

function delFuelPoint(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local colShape = nil
			
		for key, value in ipairs(exports.pool:getPoolElementsByType("colshape")) do
			local shapeType = getElementData(value, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					if (isElementWithinColShape(thePlayer, value)) then
						colShape = value
					end
				end
			end
		end
		
		if (colShape) then
			local shapeType = getElementData(colShape, "type")
			if (shapeType) then
				if (shapeType=="fuel") then
					local id = getElementData(colShape, "dbid")
					local result = mysql:query_free("DELETE FROM fuelstations WHERE id='" .. id .. "'")				
					outputChatBox("Fuel station #" .. id .. " deleted.", thePlayer)
					exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " deleted fuel station #" .. id .. ".")
					destroyElement(colShape)
				end
			else
				outputChatBox("You are not in a fuel station.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("You are not in a fuel station.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delfuelpoint", delFuelPoint, false, false)