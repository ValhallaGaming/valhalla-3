function fiddycal(target)
	if ( getElementType(target) == "vehicle" ) then -- its a 50cal, it destroys cars!
		setElementHealth(target, 100)
	elseif ( getElementType(target) == "vehicle" ) then
		setElementHealth(target, 0)
	end
end
addEvent("50cal", true)
addEventHandler("50cal", getRootElement(), fiddycal)