local Gate = {
	[1] = createObject(988, 1964.342, -2189.776, 13.533, 0, 0, 180),
	[2] = createObject(988, 1958.851, -2189.777, 13.553, 0, 0, 180),
}
local GateName = "LS Airport Gates"
exports.pool:allocateElement(Gate[1])
exports.pool:allocateElement(Gate[2])
local GatePass = "nonoobs"
local open = false


local function ResetOpenState()
	open = false
end

local function closeDoor(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The " .. GateName .. " are now Closed!", thePlayer, 255, 0, 0)
	end
	moveObject(Gate[1], 1000, 1964.342, -2189.776, 13.533, 0, 0, 0)
	moveObject(Gate[2], 1000, 1958.851, -2189.777, 13.553, 0, 0, 0)
	setTimer(ResetOpenState, 1000, 1)
end


-- Gate code / Using local functions to avoid 
local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(1961.697, -2189.776, 13.553, x, y, z)

	if (distance<=20) and (open==false) then
		if exports.global:hasItem(thePlayer, 78) or getPlayerTeam(thePlayer) == getTeamFromName("Los Santos Police Department") or getPlayerTeam(thePlayer) == getTeamFromName("Los Santos Emergency Services") then
			outputChatBox("The " .. GateName .. " are now open!", thePlayer, 0, 255, 0)
			moveObject(Gate[1], 1000, 1968.342, -2189.776, 13.533, 0, 0, 0)
			moveObject(Gate[2], 1000, 1954.342, -2189.776, 13.533, 0, 0, 0)
			setTimer(closeDoor, 5000, 1, thePlayer)
			open = true
		else
			outputChatBox("You need a San Andreas Pilot Certificate.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)