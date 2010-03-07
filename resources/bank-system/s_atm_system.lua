function createATM(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) and ( getElementDimension(thePlayer) > 0 or exports.global:isPlayerScripter(thePlayer) ) then
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		local x, y, z  = getElementPosition(thePlayer)
		local rotation = getPedRotation(thePlayer)
		
		z = z - 0.3
		
		local id = mysql:query_insert_free("INSERT INTO atms SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', dimension='" .. dimension .. "', interior='" .. interior .. "', rotation='" .. rotation .. "',`limit`=5000")
				
		if (id) then
			local object = createObject(2942, x, y, z, 0, 0, rotation-180)
			exports.pool:allocateElement(object)
			setElementDimension(object, dimension)
			setElementInterior(object, interior)
			setElementData(object, "depositable", 0, false)
			setElementData(object, "limit", 5000, false)
			
			local px = x + math.sin(math.rad(-rotation)) * 0.8
			local py = y + math.cos(math.rad(-rotation)) * 0.8
			local pz = z
			
			setElementData(object, "dbid", id, false)

			x = x + ((math.cos(math.rad(rotation)))*5)
			y = y + ((math.sin(math.rad(rotation)))*5)
			setElementPosition(thePlayer, x, y, z)
			
			outputChatBox("ATM created with ID #" .. id .. "!", thePlayer, 0, 255, 0)
		else
			outputChatBox("There was an error while creating an ATM. Try again.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("addatm", createATM, false, false)

function loadAllATMs()
	local result = mysql:query("SELECT id, x, y, z, rotation, dimension, interior, deposit, `limit` FROM atms")
	local counter = 0
	
	if (result) then
		local continue = true
		while continue do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			
			local id = tonumber(row["id"])
			local x = tonumber(row["x"])
			local y = tonumber(row["y"])
			local z = tonumber(row["z"])

			local rotation = tonumber(row["rotation"])
			local dimension = tonumber(row["dimension"])
			local interior = tonumber(row["interior"])
			local deposit = tonumber(row["deposit"])
			local limit = tonumber(row["limit"])
			
			local object = createObject(2942, x, y, z, 0, 0, rotation-180)
			exports.pool:allocateElement(object)
			setElementDimension(object, dimension)
			setElementInterior(object, interior)
			setElementData(object, "depositable", deposit, false)
			setElementData(object, "limit", limit, false)
			
			local px = x + math.sin(math.rad(-rotation)) * 0.8
			local py = y + math.cos(math.rad(-rotation)) * 0.8
			local pz = z
			
			setElementData(object, "dbid", id, false)
			
			counter = counter + 1
		end
		mysql:free_result(result)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllATMs)

function deleteATM(thePlayer, commandName, id)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
				
			local counter = 0
			local objects = getElementsByType("object", getResourceRootElement())
			for k, theObject in ipairs(objects) do
				local objectID = getElementData(theObject, "dbid")
				if (objectID==id) then
					destroyElement(theObject)
					counter = counter + 1
				end
			end
			
			if (counter>0) then -- ID Exists
				local query = mysql:query_free("DELETE FROM atms WHERE id='" .. id .. "'")
				
				outputChatBox("ATM #" .. id .. " Deleted!", thePlayer, 0, 255, 0)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted ATM #" .. id .. ".")
			else
				outputChatBox("ATM ID does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delatm", deleteATM, false, false)

function getNearbyATMs(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby ATMs:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement())) do
			local x, y, z = getElementPosition(theObject)
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
			if (distance<=10) then
				local dbid = getElementData(theObject, "dbid")
				outputChatBox("   ATM with ID " .. dbid .. ".", thePlayer)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyatms", getNearbyATMs, false, false)

function showATMInterface(atm)
	local faction_id = tonumber( getElementData(source, "faction") )
	local faction_leader = tonumber( getElementData(source, "factionleader") )

	local isInFaction = false
	local isFactionLeader = false
	
	if faction_id and faction_id > 0 then
		isInFaction = true
		if faction_leader == 1 then
			isFactionLeader = true
		end
	end
	
	local faction = getPlayerTeam(source)
	local money = exports.global:getMoney(faction)

	local depositable = getElementData(atm, "depositable")
	local deposit = false
	if (depositable == 1) then
		deposit = true
	end
	local limit = getElementData(atm, "limit")
	
	triggerClientEvent(source, "showBankUI", atm, isInFaction, isFactionLeader, money, deposit, limit)
end
addEvent( "requestATMInterface", true )
addEventHandler( "requestATMInterface", getRootElement(), showATMInterface )