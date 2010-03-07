local Gate = {
	[1] = createObject(4100,1577.4779052734,-1617.7227783203,14.1,0,0,320.31500244141),
	[2] = createObject(4100,1587.1,-1611.25,14.1,0,0,25.804992675781),
}
local GateName = "PD Impound Gate"
exports.pool:allocateElement(Gate[1])
exports.pool:allocateElement(Gate[2])
local open = false


local function ResetOpenState()
	open = false
end

local function closeDoor(thePlayer)
	moveObject(Gate[1], 1000, 1577.4779052734,-1617.7227783203,14.1, 0, 0, 0)
	moveObject(Gate[2], 1000, 1587.1,-1611.25,14.1, 0, 0, 0)
	setTimer(ResetOpenState, 1000, 1)
end


-- Gate code / Using local functions to avoid 
local function useDoor(thePlayer, commandName, ...)
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(1581.0400390625, -1617.6396484375, 13.3828125, x, y, z)
		
	if (distance<=10) and (open==false) then
		if (exports.global:hasItem(thePlayer, 64) or exports.global:hasItem(thePlayer, 82)) then
			outputChatBox("The " .. GateName .. " is now open!", thePlayer, 0, 255, 0)
			moveObject(Gate[1], 1000, 1570.4779052734,-1617.7227783203,14.1, 0, 0, 0)
			moveObject(Gate[2], 1000, 1588.2482910156,-1608.6553955078,14.1, 0, 0, 0)
			setTimer(closeDoor, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useDoor)