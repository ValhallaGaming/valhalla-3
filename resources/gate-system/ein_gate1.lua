local Gate = {
	[1] = createObject(5779, -96.087005615234, -52.888311004639, 3.6868686676025, 0, 0, 70.559594726563 ),
}
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
	moveObject(Gate[1], 1000, -96.087005615234, -52.888311004639, 3.6868686676025, 0, 0, 0 )
	setTimer(ResetBusyState, 1000, 1)
end

local function openDoor(thePlayer)
	open = true
	busy = true
	moveObject(Gate[1], 1000, -96.087005615234, -52.888311004639, 6.8, 0, 0, 0 )
	setTimer(ResetBusyState, 1000, 1)
end

local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)

	local distance = getDistanceBetweenPoints3D(-96.087005615234, -52.788311004639, 3.6868686676025, x, y, z)
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