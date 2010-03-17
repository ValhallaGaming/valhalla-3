function toggleSmoking(thePlayer)
	local smoking = getElementData(thePlayer, "realism:smoking")
	triggerClientEvent("realism:smokingsync", thePlayer, not smoking)
	exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realism:smoking", not smoking, false )
end
addCommandHandler("testsmoke", toggleSmoking)

-- Sync to new players
addEvent("realism:smoking.request", true)
addEventHandler("realism:smoking.request", getRootElement(), 
	function ()
		local players = exports.pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isSmoking = getElementData(thePlayer, "realism:smoking")
			if (isSmoking) then
				triggerClientEvent(source, "realism:smokingsync", thePlayer, isSmoking)
			end
		end
	end
);