mysql = exports.mysql

armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true, [597]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar, SFPD Car
governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }

function createSpray(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local interior = getElementInterior(thePlayer)
		local dimension = getElementDimension(thePlayer)
		
		local id = mysql:query_insert_free("INSERT INTO paynspray SET x='"  .. x .. "', y='" .. y .. "', z='" .. z .. "', interior='" .. interior .. "', dimension='" .. dimension .. "'")
		
		if (id) then		
			local shape = createColSphere(x, y, z, 5)
			exports.pool:allocateElement(shape)
			setElementInterior(shape, interior)
			setElementDimension(shape, dimension)
			setElementData(shape, "dbid", id, false)
			
			local sprayblip = createBlip(x, y, z, 63, 2, 255, 0, 0, 255, 0, 300)
			exports.pool:allocateElement(sprayblip)
			
			outputChatBox("Pay n Spray spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 200000 - Report on forums.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("makepaynspray", createSpray, false, false)

function loadAllSprays(res)
	local result = mysql:query("SELECT id, x, y, z, interior, dimension FROM paynspray")
	local count = 0
	
	if (result) then
		local continue = true
		while continue do
			local row = mysql:fetch_assoc(result)
			if not row then
				break
			end
		
			local id = tonumber(row["id"])
				
			local x = tonumber(row["x"])
			local y = tonumber(row["y"])
			local z = tonumber(row["z"])
				
			local interior = tonumber(row["interior"])
			local dimension = tonumber(row["dimension"])
			
			local sprayblip = createBlip(x, y, z, 63, 2, 255, 0, 0, 255, 0, 300)
			exports.pool:allocateElement(sprayblip)
			
			local shape = createColSphere(x, y, z, 5)
			exports.pool:allocateElement(shape)
			setElementInterior(shape, interior)
			setElementDimension(shape, dimension)
			setElementData(shape, "dbid", id, false)
				
			count = count + 1
		end
		mysql:free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllSprays)

function getNearbySprays(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Pay n Sprays:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theColshape in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			local x, y = getElementPosition(theColshape)
			local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
			if (distance<=10) then
				local dbid = getElementData(theColshape, "dbid")
				outputChatBox("   Pay n Spray with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbypaynsprays", getNearbySprays, false, false)

function delSpray(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local colShape = nil
		
		for key, value in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			if (isElementWithinColShape(thePlayer, value)) then
				colShape = value
			end
		end
		
		if (colShape) then
			local id = getElementData(colShape, "dbid")
			mysql:query_free("DELETE FROM paynspray WHERE id='" .. id .. "'")
			
			outputChatBox("Pay n Spray #" .. id .. " deleted.", thePlayer)
			exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted Pay n Spray #" .. id .. ".")
			destroyElement(colShape)
		else
			outputChatBox("You are not in a Pay n Spray.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("delpaynspray", delSpray, false, false)

function shapeHit(element, matchingDimension)
	if (isElement(element)) and (getElementType(element)=="vehicle") and (matchingDimension) then
		local thePlayer = getVehicleOccupant(element)
		
		if (thePlayer) then
			local faction = getPlayerTeam(thePlayer)
			local ftype = getElementData(faction, "type")
			local fid = getElementData(faction, "id")
			local free = false
			if (ftype==2 or ftype==3 or ftype==4 or fid==30) then
				free = true
			end
			
			if not exports.global:hasMoney(thePlayer, 125) and not free then
				outputChatBox("You cannot afford to have your car worked on.", thePlayer, 255, 0, 0)
			else
				outputChatBox("Welcome to the BT&R Spray. Please wait while we work on your " .. getVehicleName(element) .. ".", thePlayer, 255, 194, 14)
				setTimer(spraySoundEffect, 2000, 5, thePlayer, source)
				setTimer(sprayEffect, 10000, 1, element, thePlayer, source, free)
			end
		end
	end
end
addEventHandler("onColShapeHit", getResourceRootElement(), shapeHit)

function spraySoundEffect(thePlayer, shape)
	if (isElementWithinColShape(thePlayer, shape)) then
		playSoundFrontEnd(thePlayer, 46)
	end
end

function sprayEffect(vehicle, thePlayer, shape, free)
	if (isElementWithinColShape(thePlayer, shape)) then
		outputChatBox(" ", thePlayer)
		outputChatBox(" ", thePlayer)
		outputChatBox("Thank you for visting the BT&R Spray garage. Have a safe journey.", thePlayer, 255, 194, 14)
		
		if not free then
			exports.global:takeMoney(thePlayer, 125, true)
			outputChatBox("BILL: Car Repair - 125$", thePlayer, 255, 194, 14)
		else
			outputChatBox("BILL: Car Repair - 0$", thePlayer, 255, 194, 14)
		end
		
		exports.global:giveMoney(getTeamFromName("Best's Towing and Recovery"), 125)
		
		fixVehicle(vehicle)
		if armoredCars[ getElementModel( vehicle ) ] then
			setVehicleDamageProof(vehicle, true)
		else
			setVehicleDamageProof(vehicle, false)
		end
		if (getElementData(vehicle, "Impounded") == 0) then
			setElementData(vehicle, "enginebroke", 0, false)
		end
	else
		outputChatBox("You forgot to wait for your repair!", thePlayer, 255, 0, 0)
	end
end

function pnsOnEnter(player, seat)
	if seat == 0 then
		for k, v in ipairs(getElementsByType("colshape", getResourceRootElement())) do
			if isElementWithinColShape(source, v) then
				triggerEvent( "onColShapeHit", v, source, getElementDimension(v) == getElementDimension(source))
			end
		end
	end
end
addEventHandler("onVehicleEnter", getRootElement(), pnsOnEnter)
