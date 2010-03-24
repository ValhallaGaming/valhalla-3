

function transferDimension(thePlayer, theDimension)
	if (theDimension ~= nil) and (objects[theDimension] ~= nil) then
		local objTable = { }
		local objID = 0
		for id, dimension in ipairs(objdimension) do
			if (dimension == theDimension) then
				objID = objID + 1
				objTable[objID] = objects[id]
			end
		end
		outputDebugString("obj-sys-serv: sending " .. theDimension .. " to " .. getPlayerName(thePlayer) .. " (".. #objTable .. " objects)" )
		triggerClientEvent(thePlayer, "object:sync", getRootElement(), objTable, theDimension)
	end
end

function tranferDimension2(theDimension)
	transferDimension(source, theDimension)
end
addEvent( "object:requestsync", true )
addEventHandler( "object:requestsync", getRootElement(), tranferDimension2 )

function syncDimension(theDimension)
	if (theDimension ~= -1) then
		local players = exports.pool:getPoolElementsByType("player")
		for k, thePlayer in ipairs(players) do
			local playerDimension = getElementDimension(thePlayer)
			if (theDimension == playerDimension) then
				transferDimension(thePlayer, theDimension)
			end
		end
	end
end