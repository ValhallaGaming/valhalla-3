local Gate = {
	[1] = createObject(988, 1154.0626220703, -626.15966796875, 104.99081420898, 0, 0, 6.49)
}
exports.pool:allocateElement(Gate[1])
local GatePass = "scotlandalba"
local open = false

local function ResetOpenState()
	open = false
end

local function closeDoor()
	moveObject(Gate[1], 2000, 1154.0626220703, -626.15966796875, 104.99081420898, 0, 0, 100)
	setTimer(ResetOpenState, 2000, 1)
end

local function openDoor()
	moveObject(Gate[1], 2000, 1157.0626220703, -623.15966796875, 104.99081420898, 0, 0, -100)
	setTimer(closeDoor, 6000, 1)
	open = true
end

local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(1154.0626220703, -626.15966796875, 104.99081420898, x, y, z)

	if (distance<=25) and (open==false) then
		if (password == GatePass) then
			openDoor()
		else
			outputChatBox("Invalid Password", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)
