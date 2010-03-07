function beanbagFired(x, y, z, target)
	local px, py, pz = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if (distance<35) then
		if (isElement(target) and getElementType(target)=="player") then			
			setElementData(target, "tazed", 1, false)
			toggleAllControls(target, false, true, false)
			exports.global:applyAnimation(target, "ped", "FLOOR_hit_f", -1, false, false, true)
			setTimer(removeAnimationX, 10005, 1, target)
		end
	end
end
addEvent("beanbagFired", true )
addEventHandler("beanbagFired", getRootElement(), beanbagFired)

function removeAnimationX(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		exports.global:removeAnimation(thePlayer)
		toggleAllControls(thePlayer, true, true, true)
	end
end