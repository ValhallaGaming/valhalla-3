local objGateh1 = createObject(968, 1544.6875, -1630.785546875, 13.1828125, 0, 90, 90)
exports.pool:allocateElement(objGateh1)
local objGateh2 = createObject(968, 617.0810546875, -1510.084765625, 14.801913604736, 0, 90, 90)
exports.pool:allocateElement(objGateh2)

createObject(970, 1544.318359375, -1621.5888671875, 13, 0, 0, 90)
createObject(970, 1544.318359375, -1619.5888671875, 13, 0, 0, 90)

createObject(970, 1544.318359375, -1634.5888671875, 13, 0, 0, 90)
createObject(970, 1544.318359375, -1637.5888671875, 13, 0, 0, 90)

local open = false
local which = 0

-- Gate code
function usePDSideGarageGate(thePlayer)	
	local x, y, z = getElementPosition(thePlayer)
	local distance1 = getDistanceBetweenPoints3D(1544.6875, -1630.785546875, 13.1828125, x, y, z)
	local distance2 = getDistanceBetweenPoints3D(617.0810546875, -1510.084765625, 14.801913604736, x, y, z)		

	if (distance1<=10) and (open==false) then
		if (exports.global:hasItem(thePlayer, 64) or exports.global:hasItem(thePlayer, 82)) then
			open = true
			which = 1
			outputChatBox("LSPD Barrier is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateh1, 1000, 1544.6875, -1630.785546875, 13.1828125, 0, -90, 0)
			setTimer(closePDSideGarageGate, 5000, 1, thePlayer)
		end
	elseif (distance2<=10) and (open==false) then
		if (exports.global:hasItem(thePlayer, 64)) then
			open = true
			which = 2
			outputChatBox("LSPD Barrier is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGateh2, 1000, 617.0810546875, -1510.084765625, 14.801913604736, 0, -90, 0)
			setTimer(closePDSideGarageGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDSideGarageGate)

function closePDSideGarageGate(thePlayer)
	setTimer(resetState7, 1000, 1)
	if (which==1) then
		which = 0
		moveObject(objGateh1, 1000, 1544.6875, -1630.785546875, 13.1828125, 0, 90, 0)
	elseif (which==2) then
		which = 0
		moveObject(objGateh2, 1000, 617.0810546875, -1510.084765625, 14.801913604736, 0, 90, 0)	
	end
end

function resetState7()
	open = false
end

-- PD billboards
-- billboard on main street
--createObject(1268, 1314.1861328125, -1595.7373046875, 17.182812, 0, 0, 90)
--createObject(7301, 1314.1861328125, -1595.7373046875, 22.382812, 0, 0, 135)
--createObject(7301, 1314.1861328125, -1593.7373046875, 22.382812, 0, 0, 315)

-- pershing
--createObject(7301, 1480.7919921875, -1750.3037109375, 29.0, 0, 0, 315)

-- lspd cpu
--createObject(7301, 615.517578125, -1459.5380859375, 21.85, 0, 0, 225)

