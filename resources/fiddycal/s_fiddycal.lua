function fiddycal(target)
	if ( getElementType(target) == "vehicle" ) then -- its a 50cal, it destroys cars!
		blowVehicle(target, true)
	elseif ( getElementType(target) == "player" ) then
		setElementHealth(target, 0)
		if ( isElement(target) ) then
			outputChatBox("You got killed by the 50cal Sniper Rifle!", target, 255, 0, 0)
		end
	end
end
addEvent("50cal", true)
addEventHandler("50cal", getRootElement(), fiddycal)