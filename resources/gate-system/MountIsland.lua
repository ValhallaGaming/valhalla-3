 --   <object id="gate closed" model="976" interior="0" dimension="0" posX="3323.5270996094" posY="-1803.0314941406" posZ="0.56797444820404" rotX="0" rotY="0" rotZ="11.909912109375" />
 --   <object id="object (phils_compnd_gate) (1)" model="976" interior="0" dimension="0" posX="3326.0151367188" posY="-1802.7016601563" posZ="0.59789043664932" rotX="0" rotY="0" rotZ="7.9376220703125" />
 
 -- map offsets
local x = 500
local y = 2740

local Gate = {
	[1] = createObject(976, x+3323.5270996094, y+-1803.0314941406, 0.56797444820404, 0, 0, 11.909912109375)
}
exports.pool:allocateElement(Gate[1])
local GatePass = "myislandnotyours!"
local open = false

local function ResetOpenState()
	open = false
end

local function closeDoor()
	moveObject(Gate[1], 2000, x+3323.5270996094, y+-1803.0314941406, 0.56797444820404, 0, 0, 4)
	setTimer(ResetOpenState, 2000, 1)
end

local function openDoor()
	moveObject(Gate[1], 2000, x+3326.0151367188, y+-1802.7016601563, 0.59789043664932, 0, 0, -4)
	setTimer(closeDoor, 6000, 1)
	open = true
end

local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(3823.5270996094, 938.0314941406, 0.56797444820404, x, y, z)

	if (distance<=25) and (open==false) then
		if (password == GatePass) then
			openDoor()
		else
			outputChatBox("Invalid Password", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)
