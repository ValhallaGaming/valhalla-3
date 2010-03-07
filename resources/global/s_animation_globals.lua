function applyAnimation(thePlayer, block, name, animtime, loop, updatePosition, forced)
	if animtime==nil then animtime=-1 end
	if loop==nil then loop=true end
	if updatePosition==nil then updatePosition=true end
	if forced==nil then forced=true end

	if isElement(thePlayer) and getElementType(thePlayer)=="player" and not getPedOccupiedVehicle(thePlayer) and getElementData(thePlayer, "freeze") ~= 1 then
		if getElementData(thePlayer, "injuriedanimation") or ( not forced and getElementData(thePlayer, "forcedanimation") ) then
			return false
		end
		
		triggerEvent("bindAnimationStopKey", thePlayer)
		toggleAllControls(thePlayer, false, true, false)
		
		if (forced) then
			setElementData(thePlayer, "forcedanimation", 1)
		else
			removeElementData(thePlayer, "forcedanimation")
		end
		
		local setanim = setPedAnimation(thePlayer, block, name, animtime, loop, updatePosition, false)
		if animtime > 100 then
			setTimer(setPedAnimation, 50, 2, thePlayer, block, name, animtime, loop, updatePosition, false)
		end
		if animtime > 50 then
			setElementData(thePlayer, "animationt", setTimer(removeAnimation, animtime, 1, thePlayer), false)
		end
		return setanim
	else
		return false
	end
end

function onSpawn()
	setPedAnimation(source)
	toggleAllControls(source, true, true, false)
	removeElementData(source, "forcedanimation")
end
addEventHandler("onPlayerSpawn", getRootElement(), onSpawn)

addEvent( "onPlayerStopAnimation", true )
function removeAnimation(thePlayer)
	if isElement(thePlayer) and getElementType(thePlayer)=="player" and getElementData(thePlayer, "freeze") ~= 1 and not getElementData(thePlayer, "injuriedanimation") then
		if isTimer( getElementData( thePlayer, "animationt" ) ) then
			killTimer( getElementData( thePlayer, "animationt" ) )
		end
		local setanim = setPedAnimation(thePlayer)
		removeElementData(thePlayer, "forcedanimation")
		removeElementData(thePlayer, "animationt")
		toggleAllControls(thePlayer, true, true, false)
		setPedAnimation(thePlayer)
		setTimer(setPedAnimation, 50, 2, thePlayer)
		setTimer(triggerEvent, 100, 1, "onPlayerStopAnimation", thePlayer)
		return setanim
	else
		return false
	end
end