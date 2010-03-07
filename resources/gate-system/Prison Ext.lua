local gates =
{
	{ gate = createObject( 986, 845, -3246.5, 13.6 ), offset = { -6.5, 0, 0, 0, 0, 0 } },
	{ gate = createObject( 986, 745, -3346, 10.25, 0, 0, 0.75 ), offset = { 6.5, 0, 0, 0, 0, 0 } },
	{ gate = createObject( 985, 876.1, -3372.7, 13.6, 0, 0, 180 ), offset = { -6.5, 0, 0, 0, 0, 0 } } 
}


local function resetBusy( shortestID )
	gates[ shortestID ].busy = nil
end

local function closeDoor( shortestID )
	gate = gates[ shortestID ]
	local nx, ny, nz = getElementPosition( gate.gate )
	moveObject( gate.gate, 1000, nx - gate.offset[1], ny - gate.offset[2], nz - gate.offset[3], -gate.offset[4], -gate.offset[5], -gate.offset[6] )
	gate.busy = true
	gate.timer = nil
	setTimer( resetBusy, 1000, 1, shortestID )
end

local function openDoor(thePlayer, commandName, pass)
	if getTeamName(getPlayerTeam(thePlayer)) == "San Andreas Correctional Facility" and getElementDimension(thePlayer) == 0 then
		local shortest, shortestID, dist = nil, nil, 10
		local px, py, pz = getElementPosition(thePlayer)
		
		for id, gate in pairs(gates) do
			local d = getDistanceBetweenPoints3D(px,py,pz,getElementPosition(gate.gate))
			if d < dist then
				shortest = gate
				shortestID = id
				dist = d
			end
		end
		
		if shortest then
			if shortest.busy then
				return
			elseif shortest.timer then
				killTimer( shortest.timer )
				shortest.timer = nil
				outputChatBox( "The door is already open!", thePlayer, 0, 255, 0 )
			else
				local nx, ny, nz = getElementPosition( shortest.gate )
				moveObject( shortest.gate, 1000, nx + shortest.offset[1], ny + shortest.offset[2], nz + shortest.offset[3], shortest.offset[4], shortest.offset[5], shortest.offset[6] )
				outputChatBox( "You opened the door!", thePlayer, 0, 255, 0 )
			end
			shortest.timer = setTimer( closeDoor, 5000, 1, shortestID )
		end
	end
end
addCommandHandler( "gate", openDoor)