function toggleLaser(thePlayer)
	local laser = getElementData(thePlayer, "laser")
	
	if (laser) then
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "laser")
		outputChatBox("Your weapon laser is now ON.",thePlayer, 0, 255, 0)
	else
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "laser", 0, true)
		outputChatBox("Your weapon laser is now OFF.",thePlayer, 255, 0, 0)
	end
end
addCommandHandler("toglaser", toggleLaser, false)
addCommandHandler("togglelaser", toggleLaser, false)