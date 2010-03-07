local gates =
{
	{ gate = createObject(2930,1027.1369628906,1224.3851318359,1497.0358886719,0,0,0.5), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.0869140625,1229.38671875,1497.0609130859,0,0,359.5), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.1362304688,1234.4113769531,1497.0108642578,0,0,359.24987792969), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.0405273438,1239.3923339844,1497.0108642578,0,0,0.9974365234375), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.0880126953,1244.3858642578,1497.0108642578,0,0,358.99426269531), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.1276855469,1252.8576660156,1497.0358886719,0,0,359), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.0454101563,1257.8975830078,1497.0859375,0,0,1.2447509765625), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1026.9455566406,1257.8990478516,1492.8597412109,0,0,356.99145507813), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.1110839844,1252.912109375,1492.8597412109,0,0,357.73974609375), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.1099853516,1244.4077148438,1492.8718261719,0,0,357.25), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.1105957031,1239.4049072266,1492.8968505859,0,0,359.49792480469), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1026.9722900391,1234.4020996094,1492.8968505859,0,0,2.99462890625), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.0509033203,1229.3874511719,1492.8968505859,0,0,1.7437744140625), offset = { 0, 1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1027.1134033203,1224.3118896484,1492.8968505859,0,0,359.74133300781), offset = { 0, 1.6, 0, 0, 0, 0 } },
	
	{ gate = createObject(2930,1029.2973632813,1222.7392578125,1492.8968505859,0,0,90.310852050781), offset = { -1.6, 0, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1041.3427734375, 1216.19140625,1492.8968505859,0,0,90.310852050781), offset = { -1.6, 0, 0, 0, 0, 0 } },
	
	{ gate = createObject(2930,1047.2878417969,1224.7700195313,1492.9468994141,0,0,183.322265625), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.171875,1229.8406982422,1492.9468994141,0,0,181.31787109375), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.140625,1234.7893066406,1492.8968505859,0,0,179.81286621094), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.1362304688,1239.8891601563,1492.9468994141,0,0,179.30773925781), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.1390380859,1244.8482666016,1492.9719238281,0,0,179.80236816406), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.1364746094,1253.3820800781,1492.9468994141,0,0,179.30224609375), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.1357421875,1253.3818359375,1497.0970458984,0,0,180.046875), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.1594238281,1244.7836914063,1497.0970458984,0,0,180.0439453125), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.236328125,1241.4412841797,1497.1109619141,0,0,0.25), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.2122802734,1236.5057373047,1497.0859375,0,0,359.99719238281), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.2163085938,1231.5112304688,1497.0859375,0,0,0.4945068359375), offset = { 0, -1.6, 0, 0, 0, 0 } },
	{ gate = createObject(2930,1047.2163085938,1226.5112304688,1497.0859375,0,0,0.4945068359375), offset = { 0, -1.6, 0, 0, 0, 0 } },
}

for _, gate in pairs(gates) do
	setElementInterior(gate.gate, 3)
	setElementDimension(gate.gate, 778)
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
	if getTeamName(getPlayerTeam(thePlayer)) == "San Andreas Correctional Facility" and getElementDimension(thePlayer) == 778 then
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