addEvent("onPlayerInteriorChange", true)
local intTable = {}
local safeTable = {}

-- START OF INTERIOR SYSTEM SCRIPT

-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = mysql_query(handler, "SELECT MIN(e1.id+1) AS nextID FROM interiors AS e1 LEFT JOIN interiors AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	if result then
		local id = tonumber(mysql_result(result, 1, 1)) or 1
		mysql_free_result(result)
		return id
	end
	return false
end

function createInterior(thePlayer, commandName, interiorId, inttype, cost, ...)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local cost = tonumber(cost)
		if not (interiorId) or not (inttype) or not (cost) or not (...) or ((tonumber(inttype)<0) or (tonumber(inttype)>3)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID] [TYPE] [Cost] [Name]", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 0: House", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 1: Business", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 2: Government (Unbuyable)", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 3: Rentable", thePlayer, 255, 194, 14)
		elseif not exports.global:takeMoney(getTeamFromName("Government of Los Santos"), cost) then
			outputChatBox("The government can't afford this property.", thePlayer, 255, 0, 0)
		else
			name = table.concat({...}, " ")
			
			local x, y, z = getElementPosition(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local interiorwithin = getElementInterior(thePlayer)
			
			local inttype = tonumber(inttype)
			local owner = nil
			local locked = nil
			
			if (inttype==2) then
				owner = 0
				locked = 0
			else
				owner = -1
				locked = 1
			end
			
			interior = interiors[tonumber(interiorId)]
			if interior then
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				local max_items = interior[6]
				
				local rot = getPedRotation(thePlayer)
				local id = SmallestID()
				local query = mysql_query(handler, "INSERT INTO interiors SET id=" .. id .. ",x='" .. x .. "', y='" .. y .."', z='" .. z .."', type='" .. inttype .. "', owner='" .. owner .. "', locked='" .. locked .. "', cost='" .. cost .. "', name='" .. mysql_escape_string(handler, name) .. "', interior='" .. interiorw .. "', interiorx='" .. ix .. "', interiory='" .. iy .. "', interiorz='" .. iz .. "', dimensionwithin='" .. dimension .. "', interiorwithin='" .. interiorwithin .. "', angle='" .. optAngle .. "', angleexit='" .. rot .. "', max_items='" .. max_items .. "', fee=0")
				
				if (query) then
					outputChatBox("Created Interior with ID " .. id .. ".", thePlayer, 255, 194, 14)
					mysql_free_result(query)
					reloadOneInterior(id, false, false)
				else
					outputChatBox("Failed to create interior - Invalid characters used in name of the interior.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Failed to create interior - There is no such interior (" .. ( interiorID or "??" ) .. ").", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addinterior", createInterior, false, false)

function updateInteriorExit(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local interior = getElementInterior(thePlayer)
		
		if (interior==0) then
			outputChatBox("You are not in an interior.", thePlayer, 255, 0, 0)
		else
			local dbid = getElementDimension(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			local rot = getPedRotation(thePlayer)
			local query = mysql_query(handler, "UPDATE interiors SET interiorx='" .. x .. "', interiory='" .. y .. "', interiorz='" .. z .. "', angle='" .. rot .. "' WHERE id='" .. dbid .. "'")
			
			if (query) then
				mysql_free_result(query)
			end
			
			local dbid, entrance, exit = findProperty( thePlayer )
			if exit then
				setElementPosition(exit, x, y, z)
			end
			outputChatBox("Interior Exit Position Updated!", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setinteriorexit", updateInteriorExit, false, false)

function findProperty(thePlayer, dimension)
	local dbid = dimension or getElementDimension( thePlayer )
	if dbid > 0 then
		if intTable[dbid] then
			local entrance, exit = unpack( intTable[dbid] )
			return dbid, entrance, exit, getElementData(entrance,"inttype")
		end
	end
	return 0
end

local function cleanupProperty( id )
	if id > 0 then
		if exports.mysql:query_free( "DELETE FROM dancers WHERE dimension = " .. id ) then
			local res = getResourceRootElement( getResourceFromName( "dancer-system" ) )
			if res then
				for key, value in pairs( getElementsByType( "ped", res ) ) do
					if getElementDimension( value ) == id then
						destroyElement( value )
					end
				end
			end
		end
		
		if exports.mysql:query_free( "DELETE FROM shops WHERE dimension = " .. id ) then
			local res = getResourceRootElement( getResourceFromName( "shop-system" ) )
			if res then
				for key, value in pairs( getElementsByType( "ped", res ) ) do
					if getElementDimension( value ) == id then
						destroyElement( value )
					end
				end
			end
		end
		
		if exports.mysql:query_free( "DELETE FROM atms WHERE dimension = " .. id ) then
			local res = getResourceRootElement( getResourceFromName( "bank-system" ) )
			if res then
				for key, value in pairs( getElementsByType( "object", res ) ) do
					if getElementDimension( value ) == id then
						destroyElement( value )
					end
				end
			end
		end
		
		if exports.mysql:query_free( "DELETE FROM objects WHERE dimension = " .. id ) then
			local res = getResourceRootElement( getResourceFromName( "object-system" ) )
			if res then
				for key, value in pairs( getElementsByType( "object", res ) ) do
					if getElementDimension( value ) == id then
						destroyElement( value )
					end
				end
			end
		end
	end
end

function sellProperty(thePlayer, commandName)
	local dbid, entrance, exit, interiorType = findProperty( thePlayer )
	if dbid > 0 then
		if interiorType == 2 then
			outputChatBox("You cannot sell a government property.", thePlayer, 255, 0, 0)
		elseif interiorType ~= 3 and commandName == "unrent" then
			outputChatBox("You do not rent this property.", thePlayer, 255, 0, 0)
		else
			if exports.global:isPlayerLeadAdmin(thePlayer) or getElementData(entrance, "owner") == getElementData(thePlayer, "dbid") then
				publicSellProperty(thePlayer, dbid, true, true)
				cleanupProperty(dbid)
			else
				outputChatBox("You do not own this property.", thePlayer, 255, 0, 0)
			end
		end
	else 
		outputChatBox("You are not in a property.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("sellproperty", sellProperty, false, false)
addCommandHandler("unrent", sellProperty, false, false)

function publicSellProperty(thePlayer, dbid, showmessages, givemoney)
	local dbid, entrance, exit, interiorType = findProperty( thePlayer, dbid )
	local query = mysql_query(handler, "UPDATE interiors SET owner=-1, locked=1, safepositionX=NULL, safepositionY=NULL, safepositionZ=NULL, safepositionRZ=NULL, fee=0 WHERE id='" .. dbid .. "'")
	if query then
		mysql_free_result(query)
		
		if getElementDimension(thePlayer) == dbid then
			setElementInterior(thePlayer, getElementInterior(entrance))
			setCameraInterior(thePlayer, getElementInterior(entrance))
			
			setElementDimension(thePlayer, getElementDimension(entrance))
			setElementPosition(thePlayer, getElementPosition(entrance))
			removeElementData(thePlayer, "interiormarker")
		end

		if safeTable[dbid] then
			local safe = safeTable[dbid]
			call( getResourceFromName( "item-system" ), "clearItems", safe )
			destroyElement(safe)
			safeTable[dbid] = nil
		end
		
		if interiorType == 0 or interiorType == 1 then
			if getElementData(entrance, "owner") == getElementData(thePlayer, "dbid") then
				local money = math.ceil(getElementData(entrance, "cost") * 2/3)
				if givemoney then
					exports.global:giveMoney(thePlayer, money)
					exports.global:takeMoney(getTeamFromName("Government of Los Santos"), money, true)
				end
				
				if showmessages then
					outputChatBox("You sold your property for " .. money .. "$.", thePlayer, 0, 255, 0)
				end
				
				-- take all keys
				call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
				call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
				
				triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, getElementPosition(entrance))
			else
				if showmessages then
					outputChatBox("You set this property to unowned.", thePlayer, 0, 255, 0)
				end
			end
		else
			if showmessages then
				outputChatBox("You are no longer renting this property.", thePlayer, 0, 255, 0)
			end
			call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
			call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
			triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, getElementPosition(entrance))
		end

		destroyElement(entrance)
		destroyElement(exit)
		intTable[dbid] = nil
		
		reloadOneInterior(dbid, false)
	else
		outputChatBox("Error 504914 - Report on forums.", thePlayer, 255, 0, 0)
	end
end

function sellTo(thePlayer, commandName, targetPlayerName)
	-- only works in dimensions
	local dbid, entrance, exit, interiorType = findProperty( thePlayer )
	if dbid > 0 and not isPedInVehicle( thePlayer ) then
		if interiorType == 2 then
			outputChatBox("You cannot sell a government property.", thePlayer, 255, 0, 0)
		elseif not targetPlayerName then
			outputChatBox("SYNTAX: /" .. commandName .. " [partial player name / id]", thePlayer, 255, 194, 14)
			outputChatBox("Sells the Property you're in to that Player.", thePlayer, 255, 194, 14)
			outputChatBox("Ask the buyer to use /pay to recieve the money for the Property.", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer and getElementData(targetPlayer, "dbid") then
				local px, py, pz = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 20 and getElementDimension(targetPlayer) == getElementDimension(thePlayer) then
					if getElementData(entrance, "owner") == getElementData(thePlayer, "dbid") or exports.global:isPlayerLeadAdmin(thePlayer) then
						if getElementData(targetPlayer, "dbid") ~= getElementData(entrance, "owner") then
							if exports.global:hasSpaceForItem(targetPlayer, 4) then
								local query = mysql_query(handler, "UPDATE interiors SET owner = '" .. getElementData(targetPlayer, "dbid") .. "' WHERE id='" .. dbid .. "'")
								if query then
									mysql_free_result(query)
									
									
									
									setElementData(entrance, "owner", getElementData(targetPlayer, "dbid"))
									setElementData(exit, "owner", getElementData(targetPlayer, "dbid"))
									
									local keytype = 4
									if interiorType == 1 then
										keytype = 5
									end
									
									call( getResourceFromName( "item-system" ), "deleteAll", 4, dbid )
									call( getResourceFromName( "item-system" ), "deleteAll", 5, dbid )
									exports.global:giveItem(targetPlayer, keytype, dbid)
									
									triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, getElementPosition(entrance))
									triggerClientEvent(targetPlayer, "createBlipAtXY", targetPlayer, interiorType, getElementPosition(entrance))
									
									local rent = getElementData(entrance, "rent")
									
									if interiorType == 0 or interiorType == 1 then
										outputChatBox("You've successfully sold your property to " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
										outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " sold you this property.", targetPlayer, 0, 255, 0)
									else
										outputChatBox(targetPlayerName .. " has taken over your rent contract.", thePlayer, 0, 255, 0)
										outputChatBox("You did take over " .. getPlayerName(thePlayer):gsub("_", " ") .. "'s renting contract.",  targetPlayer, 0, 255, 0)
									end
									
								else
									outputChatBox("Error 09002 - Report on Forums.", thePlayer, 255, 0, 0)
								end
							else
								outputChatBox(targetPlayerName .. " has no space for the property keys.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("You can't sell your own property to yourself.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("This property is not yours.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("You are too far away from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("sell", sellTo)

function deleteInterior(thePlayer, commandName)
	if (exports.global:isPlayerLeadAdmin(thePlayer)) then
		local interior = getElementInterior(thePlayer)
		
		if (interior==0) then
			outputChatBox("You are not in an interior.", thePlayer, 255, 0, 0)
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			if dbid > 0 then
				-- move all players outside
				for key, value in pairs( getElementsByType( "player" ) ) do
					if isElement( value ) and getElementDimension( value ) == dbid then
						setElementInterior( value, getElementInterior( entrance ) )
						setCameraInterior( value, getElementInterior( entrance ) )
						setElementDimension( value, getElementDimension( entrance ) )
						setElementPosition( value, getElementPosition( entrance ) )
						removeElementData( value, "interiormarker" )
						
						triggerEvent("onPlayerInteriorChange", value, exit, entrance)
					end
				end
				
				-- destroy the safe
				local safe = safeTable[dbid]
				if safe then
					call( getResourceFromName( "item-system" ), "clearItems", safe )
					destroyElement(safe)
					safeTable[dbid] = nil
				end
				
				-- destroy the entrance and exit
				destroyElement( entrance )
				destroyElement( exit )
				intTable[dbid] = nil
				
				local query = mysql_query(handler, "DELETE FROM interiors WHERE id='" .. dbid .. "'")
				
				if (query) then
					mysql_free_result(query)
					cleanupProperty(dbid)
					outputChatBox("Interior #" .. dbid .. " Deleted!", thePlayer, 0, 255, 0)
					exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted interior #" .. dbid .. ".")
				else
					outputChatBox("Error 50001 - Report on forums.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("delinterior", deleteInterior, false, false)

function reloadInterior(thePlayer, commandName, interiorID)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not interiorID then
			outputChatBox("SYNTAX: /" .. commandName .. " [Interior ID]", thePlayer, 255, 194, 14)
		else
			local dbid, entrance, exit, interiorType = findProperty( thePlayer, tonumber(interiorID) )
			if dbid ~= 0 then
				destroyElement(entrance)
				destroyElement(exit)
				intTable[dbid] = nil
				
				reloadOneInterior(dbid, false)
				outputChatBox("Reloaded Interior #" .. dbid, thePlayer, 0, 255, 0)
			else
				if reloadOneInterior(tonumber(interiorID), false) then
					outputChatBox("Loaded Interior #" .. tonumber(interiorID), thePlayer, 0, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("reloadinterior", reloadInterior, false, false)

function reloadOneInterior(id, hasCoroutine, displayircmessage)
	if (hasCoroutine==nil) then
		hasCoroutine = false
	end

	if displayircmessage == nil then
		displayircmessage = false
	end
	
	local result = mysql_unbuffered_query(handler, "SELECT * FROM interiors WHERE id = " .. id )
	if result then
		local row = mysql_fetch_assoc( result )
		mysql_free_result( result )
		
		if (hasCoroutine) then
			coroutine.yield()
		end
		
		if row then
			for k, v in pairs( row ) do
				if v == null then
					row[k] = nil
				else
					row[k] = tonumber(v) or v
				end
			end
			
			local pickup = createPickup( row.x, row.y, row.z, 3, row.disabled == 1 and 1314 or ( row.type == 2 and 1318 or ( row.owner < 1 and ( row.type == 1 and 1272 or 1273 ) or 1318 ) ) )
			local intpickup = createPickup( row.interiorx, row.interiory, row.interiorz, 3, 1318 )
			exports.pool:allocateElement(pickup)
			exports.pool:allocateElement(intpickup)
			setElementData( pickup, "other", intpickup, false )
			setElementData( intpickup, "other", pickup, false )
			
			if (hasCoroutine) then
				coroutine.yield()
			end
			
			setPickupElementData(pickup, row.id, row.angle, row.locked, row.owner, row.type, row.cost, row.name, row.max_items, row.tennant, row.rent, row.interiorwithin, row.dimensionwithin, row.money, row.type == 1 and row.fee or 0)
			setIntPickupElementData(intpickup, row.id, row.angleexit, row.locked, row.owner, row.type, row.interior)
			
			if safeTable[row.id] then
				destroyElement( safeTable[row.id] )
				safeTable[row.id] = nil
			end
			
			if row.safepositionX and row.safepositionY and row.safepositionZ ~= mysql_null() and row.safepositionRZ then
				local tempobject = createObject(2332, row.safepositionX, row.safepositionY, row.safepositionZ, 0, 0, row.safepositionRZ)
				setElementInterior(tempobject, row.interior)
				setElementDimension(tempobject, row.id)
				safeTable[row.id] = tempobject
			end
			
			intTable[row.id] = { pickup, intpickup }
			
			return true
		else
			outputDebugString( "Invalid Int" .. id )
			return false
		end
	else
		outputDebugString( "Loading Interiors Error: " .. mysql_error( handler ) )
	end
end

local threads = { }
function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end

function loadAllInteriors()
	local players = exports.pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		removeElementData(thePlayer, "interiormarker")
	end
		
	local result = mysql_unbuffered_query(handler, "SELECT id FROM interiors")
	local counter = 0
	if (result) then
		local ids = {}
		for result, row in mysql_rows(result) do
			ids[ tonumber(row[1]) ] = true
			counter = counter + 1
		end
		mysql_free_result(result)
		
		for id in pairs( ids ) do
			local co = coroutine.create(reloadOneInterior)
			coroutine.resume(co, id, true)
			table.insert(threads, co)
		end
		exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " interiors.")
		setTimer(resume, 1000, 4)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), loadAllInteriors)

function setPickupElementData(pickup, id, optAngle, locked, owner, inttype, cost, name, max_items, tennant, rent, interiorwithin, dimension, money, fee)
	if(pickup) then
		setElementData(pickup, "dbid", id)
		setElementData(pickup, "angle", optAngle, false)
		setElementData(pickup, "locked", locked, false)
		setElementData(pickup, "owner", owner, false)
		setElementData(pickup, "inttype", inttype, false)
		setElementData(pickup, "cost", cost, false)
		setElementData(pickup, "name", name)
		setElementData(pickup, "max_items", max_items, false)
		setElementData(pickup, "tennant", tennant, false)
		setElementData(pickup, "rent", rent, false)
		setElementData(pickup, "money", money, false)
		setElementData(pickup, "fee", fee, false)
		setElementDimension(pickup, dimension)
		setElementInterior(pickup, interiorwithin)
	end
end

function setIntPickupElementData(intpickup, id, rot, locked, owner, inttype, interior)
	if(intpickup) then
		-- For Interior Pickup
		setElementData(intpickup, "dbid", id)
		setElementData(intpickup, "angle", rot, false)
		setElementData(intpickup, "locked", locked, false)
		setElementData(intpickup, "owner", owner, false)
		setElementData(intpickup, "inttype", inttype, false)
		setElementInterior(intpickup, interior)
		setElementDimension(intpickup, id)
		setElementData(intpickup, "type", "interiorexit") -- To identify it later
	end
end

-- Bind Keys required
function func (player, f, down, player, pickup) enterInterior(player, pickup) end 

function bindKeys(player, pickup)
	if (isElement(player)) then
		if not(isKeyBound(player, "enter", "down", func)) then
			bindKey(player, "enter", "down", func, player, pickup)
		end
		
		if not(isKeyBound(player, "f", "down", func)) then
			bindKey(player, "f", "down", func, player, pickup)
		end
		
		setElementData( player, "interiormarker", true, false )
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
		
		removeElementData( player, "interiormarker" )
		triggerClientEvent( player, "displayInteriorName", player )
	end
end

function isInPickup( thePlayer, thePickup, distance )
	if isElement( thePlayer ) and isElement( thePickup ) then
		local ax, ay, az = getElementPosition(thePlayer)
		local bx, by, bz = getElementPosition(thePickup)
		
		return getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) < ( distance or 2 ) and getElementInterior(thePlayer) == getElementInterior(thePickup) and getElementDimension(thePlayer) == getElementDimension(thePickup)
	else
		return false
	end
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

function hitInteriorPickup(thePlayer)
	local pickuptype = getElementData(source, "type")
	
	local pdimension = getElementDimension(thePlayer)
	local idimension = getElementDimension(source)
	
	if pdimension == idimension then -- same dimension?
		local name = getElementData( source, "name" )
		
		if name then
			local owner = getElementData( source, "owner" )
			local cost = getElementData( source, "cost" )
			
			local ownerName = exports['vehicle-system']:getCharacterName( owner ) or "None"
			triggerClientEvent(thePlayer, "displayInteriorName", thePlayer, name, ownerName, getElementData( source, "inttype" ), cost, getElementData( source, "fee" ) )
		end
		
		bindKeys( thePlayer, source )
		setTimer( checkLeavePickup, 500, 1, thePlayer, source ) 
	end
	cancelEvent() -- Stop it despawning
end
addEventHandler("onPickupHit", getResourceRootElement(), hitInteriorPickup)

function buyInterior(player, pickup, cost, isHouse, isRentable)
	if isRentable then
		local result = mysql_query( handler, "SELECT COUNT(*) FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" )
		if result then
			local count = tonumber(mysql_result( result, 1, 1 ))
			if count ~= 0 then
				outputChatBox("You are already renting another house.", player, 255, 0, 0)
				return
			end
			mysql_free_result(result)
		end
	elseif not exports.global:hasSpaceForItem(player, 4) then
		outputChatBox("You do not have the space for the keys.", player, 255, 0, 0)
		return
	end
	
	if exports.global:takeMoney(player, cost) then
		if (isHouse) then
			outputChatBox("Congratulations! You have just bought this house for $" .. cost .. ".", player, 255, 194, 14)
			exports.global:giveMoney( getTeamFromName("Government of Los Santos"), cost )
		elseif (isRentable) then
			outputChatBox("Congratulations! You are now renting this property for $" .. cost .. ".", player, 255, 194, 14)
		else
			outputChatBox("Congratulations! You have just bought this business for $" .. cost .. ".", player, 255, 194, 14)
			exports.global:giveMoney( getTeamFromName("Government of Los Santos"), cost )
		end
		
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		
		local inttype = getElementData( pickup, "inttype" )
		local ix, iy = getElementPosition( pickup )
		
		for key, value in pairs( intTable[pickupid] ) do
			destroyElement(value)
		end
		intTable[pickupid] = nil
		
		mysql_free_result( mysql_query( handler, "UPDATE interiors SET owner='" .. charid .. "', locked=0 WHERE id='" .. pickupid .. "'") )
		
		-- make sure it's an unqiue key
		call( getResourceFromName( "item-system" ), "deleteAll", 4, pickupid )
		call( getResourceFromName( "item-system" ), "deleteAll", 5, pickupid )
		
		if (isHouse) then
			-- Achievement
			exports.global:givePlayerAchievement(player, 9)
			exports.global:giveItem(player, 4, pickupid)
		elseif isRentable then
			exports.global:giveItem(player, 4, pickupid)
		else
			-- Achievement
			exports.global:givePlayerAchievement(player, 10)
			exports.global:giveItem(player, 5, pickupid)
		end
		
		reloadOneInterior(tonumber(pickupid), false, false)
		triggerClientEvent(player, "createBlipAtXY", player, inttype, ix, iy)
			
		playSoundFrontEnd(player, 20)
	else
		outputChatBox("Sorry, you cannot afford to purchase this property.", player, 255, 194, 14)
		playSoundFrontEnd(player, 1)
	end
end

function vehicleStartEnter(thePlayer)
	if getElementData(thePlayer, "interiormarker") then
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), vehicleStartEnter)
addEventHandler("onVehicleStartExit", getRootElement(), vehicleStartEnter)

function enterInterior( thePlayer, thePickup )
	-- if the player is entering a pickup
	if thePickup and not getPedOccupiedVehicle(thePlayer) then
		-- if pickup and player are in the same place
		if getElementDimension(thePickup) == getElementDimension(thePlayer) then
		
			local inttype = getElementData(thePickup, "inttype")
			local locked = getElementData(thePickup, "locked")
			
			-- if the pickup collided with is an interior
			if getElementData(thePickup, "name") then
				-- might be disabled, so you cant enter (but still leave)
				if getElementModel(thePickup) == 1314 then
					outputChatBox("This interior is currently disabled.", thePlayer, 255, 0, 0)
					return
				end
				
				local owner = getElementData(thePickup, "owner")
				local cost = getElementData(thePickup, "cost")
                
				-- if the interior is unlocked
				if locked == 0 then 
					setPlayerInsideInterior(thePickup, thePlayer)
				elseif locked == 1 and owner == -1 then
					if inttype == 0 then -- unowned house
						buyInterior(thePlayer, thePickup, cost, true, false)
					elseif inttype == 1 then -- unowned business
						buyInterior(thePlayer, thePickup, cost, false, false)
					elseif inttype == 3 then -- unowned rentable appartment
						buyInterior(thePlayer, thePickup, cost, false, true)
					end
				else -- interior is locked
					outputChatBox("You try the door handle, but it seems to be locked.", thePlayer, 255, 0,0, true)
				end
				
			-- if it is an exit marker, its unlocked or is government then
			else
				if locked == 0 then
					setPlayerInsideInterior( thePickup, thePlayer )
				else
					outputChatBox("You try the door handle, but it seems to be locked.", thePlayer, 255, 0,0, true)
				end
			end
		end
	end
end


function setPlayerInsideInterior(thePickup, thePlayer)
	-- check for entrance fee
	if getElementData( thePlayer, "adminduty" ) ~= 1 and not exports.global:hasItem( thePlayer, 5, getElementData( thePickup, "dbid" ) ) and not (getElementData(thePlayer,"ESbadge") == 1) and not (getElementData(thePlayer,"PDbadge") == 1) and not (getElementData(thePlayer,"GOVbadge") == 1) and not (getElementData(thePlayer,"SANbadge") == 1) then
		local fee = getElementData( thePickup, "fee" )
		if fee and fee > 0 then
			if not exports.global:takeMoney( thePlayer, fee ) then
				outputChatBox( "You don't have enough money with you to enter this interior.", thePlayer, 255, 0, 0 )
				return
			else
				local ownerid = getElementData( thePickup, "owner" )
				local query = mysql_query( handler, "UPDATE characters SET bankmoney = bankmoney + " .. fee .. " WHERE id = " .. ownerid )
				if query then
					mysql_free_result( query )
					
					for k, v in pairs( getElementsByType( "player" ) ) do
						if isElement( v ) then
							if getElementData( v, "dbid" ) == ownerid then
								setElementData( v, "businessprofit", getElementData( v, "businessprofit" ) + fee, false )
								break
							end
						end
					end
				else
					outputChatBox( "Error 9018 - Report on Forums.", thePlayer, 255, 0, 0 )
				end
			end
		end
	end
	-- teleport the player inside the interior
	local other = getElementData( thePickup, "other" )
	if other then
		local rot = getElementData(thePickup, "angle")
		setPedGravity( thePlayer, 0 )
		triggerClientEvent(thePlayer, "setPlayerInsideInterior", thePickup, other, angle)
	end
end

function getNearbyInteriors(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		outputChatBox("Nearby Interiors:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, thePickup in ipairs(exports.pool:getPoolElementsByType("pickup")) do
			local name = getElementData( thePickup, "name" )
			if name then
				local x, y, z = getElementPosition(thePickup)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance<=10 and getElementDimension(thePickup) == dimension) then
					local dbid = getElementData(thePickup, "dbid")
					outputChatBox("   Interior with ID " .. dbid .. ": " .. name, thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyinteriors", getNearbyInteriors, false, false)

function changeInteriorName( thePlayer, commandName, ...)
	if (exports.global:isPlayerAdmin(thePlayer)) then -- Is the player an admin?
		local id = getElementDimension(thePlayer)
		if not (...) then -- is the command complete?
			outputChatBox("SYNTAX: /" .. commandName .." [New Name]", thePlayer, 255, 194, 14) -- if command is not complete show the syntax.
		elseif (dimension==0) then
			outputChatBox("You are not inside an interior.", thePlayer, 255, 0, 0)
		else
			name = table.concat({...}, " ")
		
			local query = mysql_query(handler, "UPDATE interiors SET name='" .. mysql_escape_string(handler, name) .. "' WHERE id='" .. id .. "'") -- Update the name in the sql.
			mysql_free_result(query)
			outputChatBox("Interior name changed to ".. name ..".", thePlayer, 0, 255, 0) -- Output confirmation.
			
			-- update the name on the markers...
			for k, thePickup in ipairs(exports.pool:getPoolElementsByType("pickup")) do
				local dbid = getElementData( thePickup, "dbid" )
				if dbid and dbid == id then
					if getElementData( thePickup, "name" ) then
						setElementData( thePickup, "name", name )
						break
					end
				end
			end
		end
	end
end
addCommandHandler("setinteriorname", changeInteriorName, false, false) -- the command "/setInteriorName".

--[[ SAFES ]]
function addSafeAtPosition( thePlayer, x, y, z, rotz )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if dbid == 0 or dbid > 19000 then -- vehicle interiors are 20k + dbid, so 19000 = temp -1000
		return 2
	elseif ((exports.global:hasItem( thePlayer, 5, dbid ) or exports.global:hasItem( thePlayer, 4, dbid))) then
		if safeTable[dbid] then
			outputChatBox("There is already a safe in this property. Type /movesafe to move it.", thePlayer, 255, 0, 0)
			return 1
		else
			z = z - 0.5
			rotz = rotz + 180
			local query = mysql_query(handler, "UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'") -- Update the name in the sql.
			mysql_free_result(query)
			local tempobject = createObject(2332, x, y, z, 0, 0, rotz)
			setElementInterior(tempobject, interior)
			setElementDimension(tempobject, dbid)
			safeTable[dbid] = tempobject
			call( getResourceFromName( "item-system" ), "clearItems", tempobject )
			return 0
		end
	end
	return 3
end
function moveSafe ( thePlayer, commandName )
	local x,y,z = getElementPosition( thePlayer )
	local rotz = getPedRotation( thePlayer )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if ((exports.global:hasItem( thePlayer, 5, dbid ) or exports.global:hasItem( thePlayer, 4, dbid))) then
		if dbid > 0 and safeTable[dbid] then
			local oldsafe = safeTable[dbid]
			z = z - 0.5
			rotz = rotz + 180
			local query = mysql_query(handler, "UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'") -- Update the name in the sql.
			mysql_free_result(query)
			setElementPosition(safeTable[dbid], x, y, z)
			setObjectRotation(safeTable[dbid], 0, 0, rotz)
		else
			outputChatBox("You need a safe to move!", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("You need the keys of this interior to move the Safe.", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("movesafe", moveSafe)

local function hasKey( source, key )
	return  getElementData(source, "adminduty") == 1 or exports.global:hasItem(source, 4, key) or exports.global:hasItem(source, 5,key)
end
addEvent( "lockUnlockHouse",false )
addEventHandler( "lockUnlockHouse", getRootElement(),
	function( )
		local itemValue = nil
		local found = nil
		local nearbyPickups = exports.global:getNearbyElements(source, "pickup", 5)
		local elevatorres = getResourceRootElement(getResourceFromName("elevator-system"))
		local min = 5
		for key, value in ipairs(nearbyPickups) do
			if isElement( value ) then
				local vx, vy, vz = getElementPosition(value)
				local x, y, z = getElementPosition(source)
				local dist = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
				if dist <= min then
					local dbid = getElementData(value, "dbid")
					if hasKey(source, dbid)then -- house found
						found = value
						itemValue = dbid
						min = dist
					elseif getElementData( value, "other" ) and getElementParent( getElementParent( value ) ) == elevatorres then
						-- it's an elevator
						if hasKey(source, getElementDimension( value ) ) then
							found = value
							itemValue = getElementDimension( value )
							min = dist
						elseif hasKey(source, getElementDimension( getElementData( value, "other" ) ) ) then
							found = value
							itemValue = getElementDimension( getElementData( value, "other" ) )
							min = dist
						end
					end
				end
			end
		end
		
		if found and itemValue then
			local result = mysql_query(handler, "SELECT 1-locked FROM interiors WHERE id = " .. itemValue)
			local locked = 0
			if result then
				locked = tonumber(mysql_result(result, 1, 1))
				mysql_free_result(result)
			end
			
			mysql_free_result( mysql_query(handler, "UPDATE interiors SET locked='" .. locked .. "' WHERE id='" .. itemValue .. "' LIMIT 1") )
			if locked == 0 then
				exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
			else
				exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
			end
			
			for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
				local dbid = getElementData(value, "dbid")
				if dbid == itemValue then
					setElementData(value, "locked", locked, false)
				end
			end
		else
			cancelEvent( )
		end	
	end
)


addEvent( "lockUnlockHouseID",true )
addEventHandler( "lockUnlockHouseID", getRootElement(),
	function( id )
		if id and hasKey(source, id) then
			local result = mysql_query(handler, "SELECT 1-locked FROM interiors WHERE id = " .. id)
			local locked = 0
			if result then
				locked = tonumber(mysql_result(result, 1, 1))
				mysql_free_result(result)
			end
			
			mysql_free_result( mysql_query(handler, "UPDATE interiors SET locked='" .. locked .. "' WHERE id='" .. id .. "' LIMIT 1") )
			if locked == 0 then
				exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
			else
				exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
			end
			
			for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
				local dbid = getElementData(value, "dbid")
				if dbid == id then
					setElementData(value, "locked", locked, false)
				end
			end
		else
			cancelEvent( )
		end	
	end
)

function setFee( thePlayer, commandName, theFee )
	if not theFee or not tonumber( theFee ) then
		outputChatBox( "SYNTAX: /" .. commandName .. " [Fee]", thePlayer, 255, 194, 14 )
	else
		local dbid, entrance, exit = findProperty( thePlayer )
		if entrance then
			local theFee = tonumber( theFee )
			if theFee >= 0 then
				if getElementData( entrance, "inttype" ) == 1 then
					if exports.global:isPlayerAdmin( thePlayer ) or getElementData( entrance, "owner" ) == getElementData( thePlayer, "dbid" ) then
						-- check if you can set a fee for that biz
						local x, y, z = getElementPosition( exit )
						local interior = getElementInterior( exit )
						
						local canHazFee, intID = false
						if exports.global:isPlayerSuperAdmin( thePlayer ) then
							canHazFee = true
						elseif getElementData( entrance, "fee" ) > 0 then
							canHazFee = true
						else
							for k, v in pairs( interiors ) do
								if interior == v[1] and getDistanceBetweenPoints3D( x, y, z, v[2], v[3], v[4] ) < 10 then
									if v[7] then
										canHazFee = true
									end
									intID = k
									break
								end
							end
						end
						
						if canHazFee then
							local query = mysql_query( handler, "UPDATE interiors SET fee = " .. theFee .. " WHERE id = " .. dbid )
							if query then
								mysql_free_result( query )
								setElementData( entrance, "fee", theFee )
								
								outputChatBox( "The entrance fee for '" .. getElementData( entrance, "name" ) .. "' is now $" .. theFee .. ".", thePlayer, 0, 255, 0 )
							else
								outputDebugString( "/" .. commandName .. ": " .. mysql_error( handler ) )
								outputChatBox( "Error 9017 - Report on Forums.", thePlayer, 255, 0, 0 )
							end
						else
							outputChatBox( "You can't charge a fee for this business.", thePlayer, 255, 0, 0 )
							outputDebugString( "Int Map ID: " .. tostring( intID ) ) 
						end
					else
						outputChatBox( "This business is not yours.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "This interior is no business.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You can only use positive values!", thePlayer, 255, 0, 0 )
			end
		else
			outputChatBox( "You are not in an interior!", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "setfee", setFee )

function findParent( element, dimension )
	local dbid, entrance = findProperty( element, dimension )
	return entrance
end

function gotoHouse( thePlayer, commandName, houseID )
	if exports.global:isPlayerFullAdmin( thePlayer ) then
		houseID = tonumber( houseID )
		if not houseID then
			outputChatBox( "SYNTAX: /" .. commandName .. " [House/Biz ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit = findProperty( thePlayer, houseID )
			if entrance then
				local dimension = getElementDimension( entrance )
				local interior = getElementInterior( entrance )
				local x, y, z = getElementPosition( entrance )
				
				setElementInterior(thePlayer, interior)
				setCameraInterior(thePlayer, interior)
				setElementDimension(thePlayer, dimension)
				setElementPosition(thePlayer, x, y, z)
				
				outputChatBox( "Teleported to House #" .. houseID, thePlayer, 0, 255, 0 )
			else
				outputChatBox( "Invalid House.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "gotohouse", gotoHouse )

function setInteriorID( thePlayer, commandName, interiorID )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		interiorID = tonumber( interiorID )
		if not interiorID then
			outputChatBox( "SYNTAX: /" .. commandName .. " [interior id] - changes the house interior", thePlayer, 255, 194, 14 )
		elseif not interiors[interiorID] then
			outputChatBox( "Invalid ID.", thePlayer, 255, 0, 0 )
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			if exit then
				local interior = interiors[interiorID]
				local ix = interior[2]
				local iy = interior[3]
				local iz = interior[4]
				local optAngle = interior[5]
				local interiorw = interior[1]
				
				local query = mysql_query(handler, "UPDATE interiors SET interior=" .. interiorw .. ", interiorx=" .. ix .. ", interiory=" .. iy .. ", interiorz=" .. iz .. ", angle=" .. optAngle .. " WHERE id=" .. dbid)
				if query then
					mysql_free_result( query )
					
					setElementPosition( exit, ix, iy, iz )
					setElementInterior( exit, interiorw )
					
					local safe = safeTable[ dbid ]
					if safe then
						setElementInterior( safe, interiorw )
					end
					
					for key, value in pairs( getElementsByType( "player" ) ) do
						if isElement( value ) and getElementDimension( value ) == dbid then
							setElementPosition( value, ix, iy, iz )
							setElementInterior( value, interiorw )
							setCameraInterior( value, interiorw )
						end
					end
					
					outputChatBox( "Interior Updated.", thePlayer, 0, 255, 0 )
				else
					outputChatBox( "Interior Update failed.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriorid", setInteriorID )

function setInteriorPrice( thePlayer, commandName, cost )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		cost = tonumber( cost )
		if not cost then
			outputChatBox( "SYNTAX: /" .. commandName .. " [price] - changes the house price", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit = findProperty( thePlayer )
			if exit then
				local query = mysql_query(handler, "UPDATE interiors SET cost=" .. cost .. " WHERE id=" .. dbid)
				if query then
					mysql_free_result( query )
					
					setElementData(entrance, "cost", cost, false)
					
					outputChatBox( "Interior Updated.", thePlayer, 0, 255, 0 )
					exports.logs:logMessage("[/SETINTERIORPRICE] " .. getElementData(thePlayer, "gameaccountusername") .. "/".. getPlayerName(thePlayer) .." set the interiorprice of ".. dbid .." to ".. cost , 4)

				else
					outputChatBox( "Interior Update failed.", thePlayer, 255, 0, 0 )
				end
			else
				outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler( "setinteriorprice", setInteriorPrice )

function getInteriorPrice( thePlayer )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		local dbid, entrance, exit = findProperty( thePlayer )
		if exit then
			outputChatBox( "This Interior costs $" .. getElementData(entrance, "cost") .. ".", thePlayer, 255, 194, 14 )
		else
			outputChatBox( "You are not in an interior.", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler( "getinteriorprice", getInteriorPrice )

function getInteriorID( thePlayer, commandName )
	local c = 0
	local interior = getElementInterior( thePlayer )
	local x, y, z = getElementPosition( thePlayer )
	for k, v in pairs( interiors ) do
		if interior == v[1] and getDistanceBetweenPoints3D( x, y, z, v[2], v[3], v[4] ) < 10 then
			outputChatBox( "Interior ID: " .. k, thePlayer )
			c = c + 1
		end
	end
	if c == 0 then
		outputChatBox( "Interior ID not found.", thePlayer )
	end
end
addCommandHandler( "getinteriorid", getInteriorID )

function toggleInterior( thePlayer, commandName, id )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		id = tonumber( id )
		if not id then
			outputChatBox( "SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, entrance, exit, inttype = findProperty( thePlayer, id )
			if entrance then
				if getElementModel( entrance ) == 1314 then
					mysql_free_result( mysql_query( handler, "UPDATE interiors SET disabled = 0 WHERE id = " .. dbid ) )
					if inttype == 2 or getElementData( entrance, "owner" ) > 0 then
						setPickupType( entrance, 3, 1318 )
					elseif inttype == 0 or inttype == 3 then
						setPickupType( entrance, 3, 1272 )
					else
						setPickupType( entrance, 3, 1273 )
					end
					
					outputChatBox( "House #" .. dbid .. " enabled.", thePlayer, 0, 255, 0 )
				else
					mysql_free_result( mysql_query( handler, "UPDATE interiors SET disabled = 1 WHERE id = " .. dbid ) )
					
					setPickupType( entrance, 3, 1314 )
					
					outputChatBox( "House #" .. dbid .. " disabled.", thePlayer, 255, 0, 0 )
				end
			end
		end
	end
end
addCommandHandler( "toggleinterior", toggleInterior )

function enableAllInteriors( thePlayer )
	if exports.global:isPlayerLeadAdmin( thePlayer ) then
		local result = mysql_query(handler, "SELECT id FROM interiors WHERE disabled = 1")
		if result then
			for result, row in mysql_rows(result) do
				local dbid, entrance, exit, inttype = findProperty( thePlayer, tonumber( row[1] ) )
				if entrance then
					if getElementModel( entrance ) == 1314 then
						if inttype == 2 or getElementData( entrance, "owner" ) > 0 then
							setPickupType( entrance, 3, 1318 )
						elseif inttype == 0 or inttype == 3 then
							setPickupType( entrance, 3, 1272 )
						else
							setPickupType( entrance, 3, 1273 )
						end
					end
				end
			end
			mysql_free_result(result)
			mysql_free_result( mysql_query( handler, "UPDATE interiors SET disabled = 0 WHERE disabled = 1" ) )
		end
	end
end
addCommandHandler( "enableallinteriors", enableAllInteriors )

addEventHandler("onPlayerInteriorChange", getRootElement( ),
	function( pickup, other )
		setElementDimension( source, getElementDimension( other ) )
		setElementInterior( source, getElementInterior( other ) )
		setCameraInterior( source, getElementInterior( other ) )
	end
)