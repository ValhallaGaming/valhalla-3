local ids = { }

function playerJoin()
	local slot = nil
	
	for i = 1, 128 do
		if (ids[i]==nil) then
			slot = i
			break
		end
	end
	
	ids[slot] = source
	setElementData(source, "playerid", slot)
	exports.pool:allocateElement(source, slot)
end
addEventHandler("onPlayerJoin", getRootElement(), playerJoin)

function playerQuit()
	local slot = getElementData(source, "playerid")
	
	if (slot) then
		ids[slot] = nil
	end
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)

function resourceStart()
	local players = exports.pool:getPoolElementsByType("player")
	
	for key, value in ipairs(players) do
		ids[key] = value
		setElementData(value, "playerid", key)
		exports.pool:allocateElement(value, key)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)
