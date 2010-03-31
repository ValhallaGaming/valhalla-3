mysql = exports.mysql
local threads = {}
local toLoad = {}
objects = { }
local tablec = 1

function loadDimension(dimension)
	if dimension and dimension > 0 then
		objects[ dimension ] = { }
		
		local result = mysql:query("SELECT * FROM `objects` WHERE dimension = " .. dimension)
		if (result) then
			while true do
				local row = mysql:fetch_assoc(result)
				if not row then	break end
				
				for key, value in pairs( row ) do
					row[key] = tonumber(value)
				end
				
				table.insert( objects[ dimension ], { row.model, row.posX, row.posY, row.posZ, row.rotX, row.rotY, row.rotZ, row.interior } )
			end
			mysql:free_result(result)
		end

		syncDimension(theDimension)
		return #objects[ dimension ]
	end
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
	local result = mysql:query("SELECT distinct(`dimension`) FROM `objects` ORDER BY `dimension` ASC")
	if (result) then
		while true do
			row = mysql:fetch_assoc(result)
			if not row then break end

			local co = coroutine.create(loadDimension)
			coroutine.resume(co, tonumber(row.dimension))
			table.insert(threads, co)
		end
	end
	mysql:free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), startObjectSystem)

function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end