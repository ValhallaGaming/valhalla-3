local mysql = exports.mysql

-- towing impound lot
local towSphere = createColPolygon(2789.131835, -1468.5177, 2789.131835, -1468.5177, 2789.133544, -1425.358398, 2820.9104, -1425.353027, 2820.912597, -1467.778808)
-- pd impound lot
local towSphere2 = createColPolygon(1540.209594, -1602.937377, 1540.209594, -1602.937377, 1590.368408, -1602.958251, 1583.952514, -1617.322265625, 1540.34082, -1617.087524)

local currentReleasePos = 0

function getReleasePosition()
	currentReleasePos = currentReleasePos + 1
	if currentReleasePos > 5 then
		currentReleasePos = 1
	end
	
	local x = 2742.7216796875
	local y = -1474.1484375
	local z = 32
	
	if (currentReleasePos == 1) then
		y = -1474.1484375
	elseif (currentReleasePos == 2) then
		y = -1463.5712890625
	elseif (currentReleasePos == 3) then
		y = -1454.5625
	elseif (currentReleasePos == 4) then
		y = -1444.880859375
	else
		y = -1433.2705078125
	end
	
	return x, y, z
end

function cannotVehpos(thePlayer)
	return isElementWithinColShape(thePlayer, towSphere) and getElementData(thePlayer,"faction") ~= 30
end

-- generic function to check if a guy is in the col polygon and the right team
function CanTowTruckDriverVehPos(thePlayer, commandName)
	local ret = 0
	if (isElementWithinColShape(thePlayer, towSphere) or isElementWithinColShape(thePlayer,towSphere2)) then
		if (getElementData(thePlayer,"faction") == 30) then
			ret = 2
		else
			ret = 1
		end
	end
	return ret
end

--Auto Pay for PD
function CanTowTruckDriverGetPaid(thePlayer, commandName)
	if (isElementWithinColShape(thePlayer,towSphere2)) then
		if (getElementData(thePlayer,"faction") == 30) then
			return true
		end
	end
	return false
end
function UnlockVehicle(element, matchingdimension) 
	if (getElementType(element) == "vehicle" and getVehicleOccupant(element) and getElementData(getVehicleOccupant(element),"faction") == 30 and getElementModel(element) == 525 and getVehicleTowedByVehicle(element)) then
		local temp = element
		while (getVehicleTowedByVehicle(temp)) do
			temp = getVehicleTowedByVehicle(temp)
			local owner = getElementData(temp, "owner")
			local faction = getElementData(temp, "faction")
			local dbid = getElementData(temp, "dbid")
			local impounded = getElementData(temp, "Impounded")
			if (owner > 0) then
				if (faction > 3 or faction < 0) then
					if (source == towSphere2) then
						--PD make sure its not marked as impounded so it cannot be recovered and unlock/undp it
						setVehicleLocked(temp, false)
						setElementData(temp, "Impounded", 0)
						setElementData(temp, "enginebroke", 0, false)
						setVehicleDamageProof(temp, false)
						setVehicleEngineState(temp, false)
						outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", getVehicleOccupant(element), 255, 194, 14)
					else
						if (getElementData(temp, "faction") ~= 30) then
							if (impounded == 0) then
								--unlock it and impound it
								setElementData(temp, "Impounded", getRealTime().yearday)
								setVehicleLocked(temp, false)
								setElementData(temp, "enginebroke", 1, false)
								setVehicleEngineState(temp, false)
								outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", getVehicleOccupant(element), 255, 194, 14)
							end
						end
					end
				else
					outputChatBox("This Faction's vehicle cannot be impounded.", getVehicleOccupant(element), 255, 194, 14)
				end
			end
		end
	end
end
-- Command to impound Bikes:
function setbikeimpound(player, matchingDimension)
	local leader = tonumber( getElementData(player, "factionleader") ) 

	local veh = getPedOccupiedVehicle(player)
	if (getElementData(player,"faction")) == 30 then
		if (isPedInVehicle(player)) then
			if (getVehicleType(veh) == "Bike") or (getVehicleType(veh) == "BMX") then
				local owner = getElementData(veh, "owner")
				local faction = getElementData(veh, "faction")
				local dbid = getElementData(veh, "dbid")
				local impounded = getElementData(veh, "Impounded")
				if (owner > 0) then
					if (faction > 3 or faction < 0) then
						if (source == towSphere2) then
							--PD make sure its not marked as impounded so it cannot be recovered and unlock/undp it
							setVehicleLocked(veh, false)
							setElementData(veh, "Impounded", 0)
							setElementData(veh, "enginebroke", 0, false)
							setVehicleDamageProof(veh, false)
							setVehicleEngineState(veh, false)
							outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", player, 255, 194, 14)
						else
							if (tonumber(leader)==1) then
								if (getElementData(veh, "faction") ~= 30) then
									if (impounded == 0) then
										setElementData(veh, "Impounded", getRealTime().yearday)
										setVehicleLocked(veh, false)
										setElementData(veh, "enginebroke", 1, false)
										setVehicleEngineState(veh, false)
										outputChatBox("((Please remember to /park and /handbrake your vehicle in our car park.))", player, 255, 194, 14)
										isin = false
									end
								end
							else
								outputChatBox("Command only usable by BTR Leader.", player, 255, 194, 14)
							end
						end
					else
						outputChatBox("This Faction's vehicle cannot be impounded.", player, 255, 194, 14)
					end
				end
			else
				outputChatBox("You can only use this command to impound MoterBikes and BMX.", player, 255, 194, 14)
			end
		else
			outputChatBox("You are not in a vehicle.", player, 255, 0, 0)
		end
	end
end
addCommandHandler("impoundbike", setbikeimpound)

addEventHandler("onColShapeHit", towSphere, UnlockVehicle)
addEventHandler("onColShapeHit", towSphere2, UnlockVehicle)



function payRelease(vehID)
	if exports.global:takeMoney(source, 95) then
		exports.global:giveMoney(getTeamFromName("Best's Towing and Recovery"), 95)
		setVehicleFrozen(vehID, false)
		setElementPosition(vehID, getReleasePosition())
		setVehicleRotation(vehID, 0, 0, 0) -- facing north
		setVehicleLocked(vehID, true)
		setElementData(vehID, "enginebroke", 0, false)
		setVehicleDamageProof(vehID, false)
		setVehicleEngineState(vehID, false)
		setElementData(vehID, "handbrake", 0, false)
		setElementData(vehID, "Impounded", 0)
		updateVehPos(vehID)
		triggerEvent("parkVehicle", source, vehID)
		outputChatBox("Your vehicle has been released. (( Please remember to /park your vehicle so it does not respawn in front of our carpark. ))", source, 255, 194, 14)
	else
		outputChatBox("Insufficient Funds.", source, 255, 0, 0)
	end
end
addEvent("releaseCar", true)
addEventHandler("releaseCar", getRootElement(), payRelease)


function disableEntryToTowedVehicles(thePlayer, seat, jacked, door) 
	if (getVehicleTowingVehicle(source)) then
		outputChatBox("You cannot enter a vehicle being towed!", thePlayer, 255, 0, 0)
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), disableEntryToTowedVehicles)

local releaseColShape = createColSphere(223.42578125, 114.265625, 1010.21875, 1)
setElementDimension(releaseColShape, 9001)
function triggerShowImpound(element, match)
	if match then
		local vehElements = {}
		local count = 1
		for key, value in ipairs(getElementsByType("vehicle")) do
			local dbid = getElementData(value, "dbid")
			if (getElementData(value, "Impounded") and getElementData(value, "Impounded") > 0 and ((dbid > 0 and exports.global:hasItem(element, 3, dbid) or (getElementData(value, "faction") == getElementData(element, "faction") and getElementData(value, "owner") == getElementData(element, "dbid"))))) then
				vehElements[count] = value
				count = count + 1
			end
		end

		triggerClientEvent( element, "ShowImpound", element, vehElements)
	end
end
addEventHandler("onColShapeHit", releaseColShape, triggerShowImpound)

function updateVehPos(veh)
	local x, y, z = getElementPosition(veh)
	local rx, ry, rz = getVehicleRotation(veh)
		
	local interior = getElementInterior(veh)
	local dimension = getElementDimension(veh)
	local dbid = getElementData(veh, "dbid")	
	mysql:query_free("UPDATE vehicles SET x='" .. x .. "', y='" .. y .."', z='" .. z .. "', rotx='" .. rx .. "', roty='" .. ry .. "', rotz='" .. rz .. "', currx='" .. x .. "', curry='" .. y .. "', currz='" .. z .. "', currrx='" .. rx .. "', currry='" .. ry .. "', currrz='" .. rz .. "', interior='" .. interior .. "', currinterior='" .. interior .. "', dimension='" .. dimension .. "', currdimension='" .. dimension .. "' WHERE id='" .. dbid .. "'")
	setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
	setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
end

function updateTowingVehicle(theTruck)
	local thePlayer = getVehicleOccupant(theTruck)
	if (thePlayer) then
		if (getElementData(thePlayer,"faction") == 30) then
			local owner = getElementData(source, "owner")
			local faction = getElementData(source, "faction")
			local carName = getVehicleName(source)
			
			if owner < 0 and faction == -1 then
				outputChatBox("(( This " .. carName .. " is a civilian vehicle. ))", thePlayer, 255, 195, 14)
			elseif (faction==-1) and (owner>0) then
				local ownerName = exports["vehicle-system"]:getCharacterName(owner)
				outputChatBox("(( This " .. carName .. " belongs to " .. ownerName .. ". ))", thePlayer, 255, 195, 14)
			else
				local row = mysql:query_fetch_assoc("SELECT name FROM factions WHERE id='" .. faction .. "' LIMIT 1")
			
				if not (row == false) then
					local ownerName = row.name
					outputChatBox("(( This " .. carName .. " belongs to the " .. ownerName .. " faction. ))", thePlayer, 255, 195, 14)
				end
			end
			
			if (getElementData(source, "Impounded") > 0) then
				local output = getRealTime().yearday-getElementData(source, "Impounded")
				outputChatBox("(( This " .. carName .. " has been Impounded for: " .. output .. (output == 1 and " Day." or " Days.") .. " ))", thePlayer, 255, 195, 14)
			end
			
			-- fix for handbraked vehicles
			local handbrake = getElementData(source, "handbrake")
			if (handbrake == 1) then
				setElementData(source, "handbrake",0,false)
				setVehicleFrozen(source, false)
			end
		end
		if thePlayer then
			exports.logs:logMessage("[TOW] " .. getPlayerName( thePlayer ) .. " started towing vehicle #" .. getElementData(source, "dbid") .. ", owned by " .. tostring(exports['vehicle-system']:getCharacterName(getElementData(source,"owner"))) .. ", from " .. table.concat({exports.global:getElementZoneName(source)}, ", ") .. " (pos = " .. table.concat({getElementPosition(source)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(source)}, ", ") .. ", health = " .. getElementHealth(source) .. ")", 14)
		end
	end
end

addEventHandler("onTrailerAttach", getRootElement(), updateTowingVehicle)

function updateCivilianVehicles(theTruck)
	if (isElementWithinColShape(theTruck, towSphere)) then
		local owner = getElementData(source, "owner")
		local faction = getElementData(source, "faction")
		local dbid = getElementData(source, "dbid")

		if (dbid >= 0 and faction == -1 and owner < 0) then
			exports.global:giveMoney(getTeamFromName("Best's Towing and Recovery"), 95)
			outputChatBox("The state has un-impounded the vehicle you where towing.", getVehicleOccupant(theTruck), 255, 194, 14)
			respawnVehicle(source)
		end
	end
	
	if getVehicleOccupant(theTruck) then
		exports.logs:logMessage("[TOW STOP] " .. getPlayerName( getVehicleOccupant(theTruck) ) .. " stopped towing vehicle #" .. getElementData(source, "dbid") .. ", owned by " .. tostring(exports['vehicle-system']:getCharacterName(getElementData(source,"owner"))) .. ", in " .. table.concat({exports.global:getElementZoneName(source)}, ", ") .. " (pos = " .. table.concat({getElementPosition(source)}, ", ") .. ", rot = ".. table.concat({getVehicleRotation(source)}, ", ") .. ", health = " .. getElementHealth(source) .. ")", 14)
	end
end
addEventHandler("onTrailerDetach", getRootElement(), updateCivilianVehicles)
