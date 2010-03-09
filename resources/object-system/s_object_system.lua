mysql = exports.mysql

function createNewObject(thePlayer, commandName, modelid)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (modelid) then
			outputChatBox("SYNTAX: " .. commandName .. " [Model ID]", thePlayer, 255, 194, 14)
		else
			local x, y, z = getElementPosition(thePlayer)
			z = z - 1
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local rotation = getPedRotation(thePlayer)
			
			local query = mysql:query_insert_free("INSERT INTO objects SET x='"  .. x .. "', y='" .. y .. "', z='" .. z .. "', interior='" .. interior .. "', dimension='" .. dimension .. "', modelid='" .. modelid .. "', rotation='" .. rotation .. "'")
			
			if (query) then
				local id = query
				
				local object = createObject(tonumber(modelid), x, y, z, 0, 0, rotation)
				exports.pool:allocateElement(object)
				
				if (object) then
					setElementInterior(object, interior)
					setElementDimension(object, dimension)
					exports['anticheat-system']:changeProtectedElementDataEx(object, "dbid", id, false)
					
					outputChatBox("Object " .. modelid .. " spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
					exports.logs:logMessage("[/addobject] " .. getElementData(thePlayer, "gameaccountusername") .. "/".. getPlayerName(thePlayer) .." made object " .. id .." (model " .. modelid .. ")", 4)
				else
					outputChatBox("Error 400001 - Report on forums.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Error 400000 - Report on forums.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addobject", createNewObject, false, false)

function loadAllObjects(res)
	local result = mysql:query("SELECT id, x, y, z, interior, dimension, rotation, modelid FROM objects")
	local count = 0
	
	if (result) then
		local continue = true
		while continue do
			row = mysql:fetch_assoc(result)
			if not row then
				break
			end
			local id = tonumber(row["id"])
				
			local x = tonumber(row["x"])
			local y = tonumber(row["y"])
			local z = tonumber(row["z"])
				
			local interior = tonumber(row["interior"])
			local dimension = tonumber(row["dimension"])
			
			local rotation = tonumber(row["rotation"])
			local modelid = tonumber(row["modelid"])
				
			local object = createObject(modelid, x, y, z, 0, 0, rotation)
			
			if (object) then
				exports.pool:allocateElement(object)
				setElementInterior(object, interior)
				setElementDimension(object, dimension)
				exports['anticheat-system']:changeProtectedElementDataEx(object, "dbid", id, false)
					
				count = count + 1
			end
		end
		mysql:free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllObjects)

function getNearbyObjects(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Objects:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(exports.pool:getPoolElementsByType("object")) do
			local dbid = getElementData(theObject, "dbid")
			if (dbid) then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10) then
					local modelid = getElementModel(theObject)
					outputChatBox("   Object (" .. modelid .. ") with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyobjects", getNearbyObjects, false, false)

function delObject(thePlayer, commandName, targetID)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
				
			for key, value in ipairs(exports.pool:getPoolElementsByType("object")) do
				local dbid = getElementData(value, "dbid")

				if (dbid) then
					if (dbid==tonumber(targetID)) then
						object = value
					end
				end
			end
			
			if (object) then
				local id = getElementData(object, "dbid")
				local result = mysql:query_free("DELETE FROM objects WHERE id='" .. id .. "'")
						
				outputChatBox("Object #" .. id .. " deleted.", thePlayer)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted Object #" .. id .. ".")
				destroyElement(object)
			else
				outputChatBox("Invalid object ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delobject", delObject, false, false)