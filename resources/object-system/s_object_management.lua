mysql = exports.mysql

objects = { }
objdimension = { }
local tablec = 1

function loadDimension(theDimension)
	local count = 0

	-- build us an awesome query.
	local query = "SELECT * FROM `objects` "
	if (theDimension ~= nil) and (tonumber(theDimension) ~= -1) then
		query = query .. "WHERE `dimension`='".. mysql:escape_string(theDimension).. "' " 
	else
		theDimension = -1
		query = query .. "ORDER BY `dimension` ASC"
	end

	-- Clear the old data
	for id, dimensiona in ipairs(objdimension) do
		if (dimensiona == theDimension) or (theDimension == -1) then
			objects[id] = nil
			objdimension[id] = nil
		end
	end

	local result = mysql:query(query)
	if (result) then
		while true do
			local row = mysql:fetch_assoc(result)
			if not row then	break end
			local dbid = tonumber(row["id"])
			local dimension = tonumber(row["dimension"])
			
			count = count + 1
						
			if not (objects[dimension]) then
				objects[dimension] = { }
			end
			

			local temparr = { }
			temparr[1] = tonumber(row["model"])
			temparr[2] = tonumber(row["posX"])
			temparr[3] = tonumber(row["posY"])
			temparr[4] = tonumber(row["posZ"])
			temparr[5] = tonumber(row["rotX"])
			temparr[6] = tonumber(row["rotY"])
			temparr[7] = tonumber(row["rotZ"])
			temparr[8] = tonumber(row["interior"])
			temparr[9] = dimension
			
			table.insert(objects, tablec, temparr)
			table.insert(objdimension, tablec, dimension)
		end
		mysql:free_result(result)
	end

	syncDimension(theDimension)
	return count
end

function reloadDimension(thePlayer, commandName, dimensionID)
	if exports.global:isPlayerAdmin(thePlayer) then
		if dimensionID then
			if (tonumber(dimensionID) >= 0) then
				triggerClientEvent("object:clear", getRootElement(), dimensionID)
				
				local count = loadDimension(tonumber(dimensionID))
				if (count > 0) then
					outputChatBox( "Reloaded " .. count .. " items in interior ".. dimensionID, thePlayer, 0, 255, 0 )
				end
			end
		end
	end
end
addCommandHandler("reloadinterior", reloadDimension, false, false)

function reloadInteriorObjects(theDimension)
	if (theDimension) and (tonumber(dimensionID) >= 0) then
		triggerClientEvent("object:clear", getRootElement(), dimensionID)
		loadDimension(tonumber(dimensionID))
	end
end

function removeInteriorObjects(theDimension)
	if (theDimension) and (tonumber(dimensionID) >= 0) then
		mysql:query_free("DELETE FROM `objects` WHERE `dimension`='".. mysql:escape_string(theDimension).."'")
		triggerClientEvent("object:clear", getRootElement(), dimensionID)
		loadDimension(tonumber(dimensionID))
	end
end

function startObjectSystem(res)
	loadDimension(-1)
end
addEventHandler("onResourceStart", getResourceRootElement(), startObjectSystem)