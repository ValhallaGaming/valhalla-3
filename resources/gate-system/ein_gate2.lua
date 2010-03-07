local Gate = {
	[1] = createObject(5779, -86.335319519043, -24.826784896851, 3.686868667602, 0, 0, 250.82580566406),
}
local GateName = "Best's Gate"
exports.pool:allocateElement(Gate[1])
local GatePass = "ohayena123"
local open = false
local busy = false

local function ResetBusyState()
	busy = false
end

local function closeDoor(thePlayer)
	open = false
	busy = true
	moveObject(Gate[1], 1000, -86.335319519043, -24.826784896851, 3.686868667602, 0, 0, 0 )
	setTimer(ResetBusyState, 1000, 1)
end

local function openDoor(thePlayer)
	open = true
	busy = true
	moveObject(Gate[1], 1000, -86.335319519043, -24.826784896851, 6.886868667602, 0, 0, 0, 0 )
	setTimer(ResetBusyState, 1000, 1)
end

local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)

	local distance = getDistanceBetweenPoints3D(-86.335319519043, -24.826784896851, 3.686868667602, x, y, z)
	if (distance<=10) and (busy==false) then
		if (password == GatePass) then
			if (open) then
				closeDoor(thePlayer)
			else
				openDoor(thePlayer)
			end
		else
			outputChatBox("Invalid Password", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)