local Gate = {
	[1] = createObject(969,1067.46875,1357.6520996094,9.8972969055176),
	[2] = createObject(969,1067.2158203125,1357.6619873047,9.8972969055176,0,0,180),
}


local GateName = "ES Academy Gates"
exports.pool:allocateElement(Gate[1])
exports.pool:allocateElement(Gate[2])
local open = false


local function ResetOpenState()
	open = false
end

local function closeDoor(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The " .. GateName .. " are now Closed!", thePlayer, 255, 0, 0)
	end
	moveObject(Gate[1], 1000, 1067.46875,1357.6520996094,9.8972969055176)
	moveObject(Gate[2], 1000, 1067.2158203125,1357.6619873047,9.8972969055176)
	setTimer(ResetOpenState, 1000, 1)
end


-- Gate code / Using local functions to avoid 
local function useDoor(thePlayer, commandName)
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(1067.46875,1357.6520996094,9.8972969055176, x, y, z)

	if (distance<=20) and (open==false) then
		if exports.global:hasItem(thePlayer, 65) then
			outputChatBox("The " .. GateName .. " are now open!", thePlayer, 0, 255, 0)
			moveObject(Gate[1], 1000, 1072.46875,1357.6520996094,9.8972969055176)
			moveObject(Gate[2], 1000, 1062.2158203125,1357.6619873047,9.8972969055176)
			setTimer(closeDoor, 5000, 1, thePlayer)
			open = true
		else
			outputChatBox("You need a San Andreas Pilot Certificate.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)