local pdgates = 
{
	{
		{ createObject(1495,2228.6408691406,-1179.44921875,928.0791015625,0,0,270), 90 }
	},
	{
		{ createObject(1495,2220.1379394531,-1155.8570556641,928.04266357422,0,0,0), -90 }
	},
	{
		{ createObject(1495,2236.82421875,-1163.3504638672,928.05700683594,0,0,270), -90 }
	}
}

for _, group in pairs(pdgates) do
	for _, gate in ipairs(group) do
		setElementInterior(gate[1], 3)
		setElementDimension(gate[1], 10631)
	end
end

local function resetBusy( shortestID )
	pdgates[ shortestID ].busy = nil
end

local function closeDoor( shortestID )
	group = pdgates[ shortestID ]
	for _, gate in ipairs(group) do
		local nx, ny, nz = getElementPosition( gate[1] )
		moveObject( gate[1], 1000, nx, ny, nz, 0, 0, -gate[2] )
	end
	group.busy = true
	group.timer = nil
	setTimer( resetBusy, 1000, 1, shortestID )
end

local function openDoor(thePlayer)
	if getElementDimension(thePlayer) == 10631 and getElementInterior(thePlayer) == 3 and exports.global:hasItem(thePlayer, 65) then
		local shortest, shortestID, dist = nil, nil, 5
		local px, py, pz = getElementPosition(thePlayer)
		
		for id, group in pairs(pdgates) do
			for _, gate in ipairs(group) do
				local d = getDistanceBetweenPoints3D(px,py,pz,getElementPosition(gate[1]))
				if d < dist then
					shortest = group
					shortestID = id
					dist = d
				end
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
				for _, gate in ipairs(shortest) do
					local nx, ny, nz = getElementPosition( gate[1] )
					moveObject( gate[1], 1000, nx, ny, nz, 0, 0, gate[2] )
				end
				outputChatBox( "You opened the door!", thePlayer, 0, 255, 0 )
			end
			shortest.timer = setTimer( closeDoor, 5000, 1, shortestID )
		end
	end
end
addCommandHandler( "gate", openDoor)
