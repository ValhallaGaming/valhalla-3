function toggleFiring(enabled, showJamMessage)
	toggleControl(source, "fire", enabled)
	
	if (showJamMessage) then
		exports.global:sendLocalMeAction(source, "'s weapon jams.")
	end
end
addEvent("togglefiring", true)
addEventHandler("togglefiring", getRootElement(), toggleFiring)

function resourceStart(res)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		toggleControl(value, "fire", true)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)