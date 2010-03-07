local doors =
{
	{
		pass = 'natsroom',
		createObject(1502,1285.5,-823.4,1088.93,0,0,90),
		createObject(1502,1285.44,-820.37,1088.93,0,0,270)
	}
}

for _, group in pairs(doors) do
	for _, door in ipairs(group) do
		setElementInterior(door, 5)
		setElementDimension(door, 1252)
		setElementData(door, "door:closed", true)
	end
end


local function openDoor(thePlayer, commandName, password)
	if getElementDimension(thePlayer) == 1252 and getElementInterior(thePlayer) == 5 then
		local shortest, shortestID, dist = nil, nil, 5
		local px, py, pz = getElementPosition(thePlayer)
		
		for id, group in pairs(doors) do
			for _, door in ipairs(group) do
				if password == group.pass then 
					local d = getDistanceBetweenPoints3D(px,py,pz,getElementPosition(door))
					if d < dist then
						shortest = group
						shortestID = id
						dist = d
					end
				end
			end
		end
		
		if shortest then
			for _, door in ipairs(shortest) do
				setElementData(door, "door:closed", not getElementData(door, "door:closed"))
			end
		end
	end
end
addCommandHandler("gate", openDoor)
addCommandHandler("door", openDoor)