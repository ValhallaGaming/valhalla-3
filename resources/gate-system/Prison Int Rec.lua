local gates =
{
	{ gate = createObject(2930,1029.3315917969,1252.9636230469,1480.3161621094,0,0,268.69067382813), offset = { -1.6, 0, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1051.1315917969,1252.9636230469,1480.3161621094,0,0,268.69067382813), offset = { -1.25, 0, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1051.5295410156,1247.4937744141,1480.2661132813,0,0,268.68713378906), offset = { -1.6, 0, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.2731933594,1215.9949951172,1486.6497802734,0,0,268.69067382813), offset = { -1.6, 0, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1030.6450195313,1220.3881835938,1486.6497802734,0,0,270.93713378906), offset = { -1.6, 0, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1050.6791992188,1208.3216552734,1480.3145751953,0,0,359.5), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1031.6176757813,1206.3282470703,1480.2713623047,0,0,271.91064453125), offset = { -1.6, 0, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1031.5676757813,1195.082470703,1480.2713623047,0,0,271.91064453125), offset = { -1.6, 0, 0, 0, 0, 0 } },
}

for _, gate in pairs(gates) do
	setElementInterior(gate.gate, 3)
	setElementDimension(gate.gate, 777)
end

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
	if getTeamName(getPlayerTeam(thePlayer)) == "San Andreas Correctional Facility" and getElementDimension(thePlayer) == 777 then
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