function toggleSmoking(thePlayer, commandName, hand)
	-- hand 0: left
	-- hand 1: right
	if not (hand) then
		hand = 0
	else
		hand = tonumber(hand)
	end

	local smoking = getElementData(thePlayer, "realism:smoking")
	triggerClientEvent("realism:smokingsync", thePlayer, not smoking, hand)
	exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realism:smoking", not smoking, false )
	exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "realism:smoking:hand", hand, false )
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
				local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
				triggerClientEvent(source, "realism:smokingsync", thePlayer, isSmoking, smokingHand)
			end
		end
	end
);