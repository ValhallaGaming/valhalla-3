local lockTimer = nil
local truckruns = { }
local truckwage = { }
local truckroute = { }
local truck = { [414] = true }

function giveTruckingMoney(vehicle)
	outputChatBox("You earned $" .. ( truckwage[vehicle] or 0 ) .. " on your trucking runs.", source, 255, 194, 15)
	exports.global:giveMoney(source, truckwage[vehicle])

	-- respawn the vehicle
	setElementData(source, "realinvehicle", 0, false)
	removePedFromVehicle(source, vehicle)
	respawnVehicle(vehicle)
	setVehicleLocked(vehicle, false)
	setElementVelocity(vehicle,0,0,0)
	
	-- reset runs/wage
	truckruns[vehicle] = nil
	truckwage[vehicle] = nil
end
addEvent("giveTruckingMoney", true)
addEventHandler("giveTruckingMoney", getRootElement(), giveTruckingMoney)


function checkTruckingEnterVehicle(thePlayer, seat)
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and seat == 0 and truck[getElementModel(source)] and getElementData(source,"job") == 1 and getElementData(thePlayer,"job") == 1 then
		triggerClientEvent(thePlayer, "startTruckJob", thePlayer, truckroute[source] or -1)
		if (truckruns[vehicle] ~= nil) and (truckwage[vehicle] > 0) then
			triggerClientEvent(thePlayer, "spawnFinishMarkerTruckJob", thePlayer)
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), checkTruckingEnterVehicle)

function startEnterTruck(thePlayer, seat, jacked)
	if seat == 0 and truck[getElementModel(source)] and getElementData(thePlayer,"job") == 1 and jacked then -- if someone try to jack the driver stop him
		if isTimer(lockTimer) then
			killTimer(lockTimer)
			lockTimer = nil
		end
		setVehicleLocked(source, true)
		lockTimer = setTimer(setVehicleLocked, 5000, 1, source, false)
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterTruck)

function saveDeliveryProgress(vehicle, earned)
	if (truckruns[vehicle] == nil) then
		truckruns[vehicle] = 0
		truckwage[vehicle] = 0
	end
	
	truckruns[vehicle] = truckruns[vehicle] + 1
	truckwage[vehicle] = truckwage[vehicle] + earned
	
	outputChatBox("You completed your " .. truckruns[vehicle] .. ".  trucking run in this truck and earned $" .. earned .. ".", source, 0, 255, 0)
	
	if (truckruns[vehicle] == 25) then
		outputChatBox("#FF9933Your trunk is empty! Return to the #CC0000warehouse #FF9933first.", source, 0, 0, 0, true)
	else 
		outputChatBox("#FF9933You can now either return to the #CC0000warehouse #FF9933and obtain your wage", source, 0, 0, 0, true)
		outputChatBox("#FF9933or continue onto the next #FFFF00drop off point#FF9933 and increase your wage.", source, 0, 0, 0, true)
		triggerClientEvent( source, "loadNewCheckpointTruckJob",  source)
		triggerEvent("updateGlobalSupplies", source, math.random(1,10))
	end
end
addEvent("saveDeliveryProgress", true)
addEventHandler("saveDeliveryProgress", getRootElement(), saveDeliveryProgress)

function updateNextCheckpoint(vehicle, pointid)
	truckroute[vehicle] = pointid
end
addEvent("updateNextCheckpoint", true)
addEventHandler("updateNextCheckpoint", getRootElement(), updateNextCheckpoint)

function restoreTruckingJob()
	if getElementData(source, "job") == 1 then
		triggerClientEvent(source, "restoreTruckerJob", source)
	end
end
addEventHandler("restoreJob", getRootElement(), restoreTruckingJob)
