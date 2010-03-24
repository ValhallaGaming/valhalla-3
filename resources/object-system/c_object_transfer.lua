local objects = { }
local currentObjects = { } 
local oldDimension = 65535
local dimensions = { }
local cdim = 0

function receiveSync(dimensionObjects, theDimension)
	outputDebugString("obj-sys: received dimension " .. theDimension .. " with " .. #dimensionObjects .. " objects")

	clearObjects(theDimension)
	objects[theDimension] = dimensionObjects
	cdim = cdim+1
	dimensions[cdim]=theDimension
	
	streamDimensionIn(theDimension)
end
addEvent( "object:sync", true )
addEventHandler( "object:sync", getRootElement(), receiveSync )

function clearObjects(theDimension)
	if (theDimension) then
		outputDebugString("obj-sys: cleaning objects in dimension " .. theDimension)
		if (objects[theDimension]) then
			for id, data in ipairs(objects[theDimension]) do
				if (currentObjects[id]) then
					setElementStreamable (currentObjects[id] ,true )
					destroyElement(currentObjects[id])
					currentObjects[id] = nil
				end
			end
		end
	else
		outputDebugString("obj-sys: cleaning objects in all dimensions")
		for key, dimension in ipairs(dimensions) do
			for id, data2 in ipairs(objects[dimension]) do
				if (currentObjects[id]) then
					setElementStreamable (currentObjects[id] ,true )
					destroyElement(currentObjects[id])
					currentObjects[id] = nil
				end
			end
		end
	end
end

function clearCache(theDimension)
	outputDebugString("obj-sys: received clear request for dimension " .. theDimension or -1)
	if (theDimension) then
		if (objects[theDimension]) then
			for id, data in ipairs(objects[theDimension]) do
				if (currentObjects[id]) then
					destroyElement(currentObjects[id])
					currentObjects[id] = nil
				end
			end
			objects[theDimension] = nil
		end
	else
		for key, dimension in ipairs(dimensions) do
			for id, data2 in ipairs(objects[dimension]) do
				if (currentObjects[id]) then
					destroyElement(currentObjects[id])
					currentObjects[id] = nil
				end
			end
		end
		objects = nil
	end
end
addEvent( "object:clear", true )
addEventHandler( "object:clear", getRootElement(), clearCache )

function createObjectEx(m,x,y,z,a,b,c,i,d)
	local t=createObject(m,x,y,z,a,b,c)
	if d then
		setElementDimension(t,d)
	end
	if i then
		setElementInterior(t,i)
	end
	return t
end

function streamDimensionIn(theDimension)
	if (objects[theDimension]) then
		outputDebugString("obj-sys: streaming objects in dimension " .. theDimension)
		for id, data in ipairs(objects[theDimension]) do
			local tmpObject = createObjectEx(data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9])
			currentObjects[id] = tmpObject
		end
	end
end

function detectInteriorChange()
	local currentDimension = getElementDimension( getLocalPlayer() )
	if (currentDimension ~= oldDimension) and not (currentDimension == 65535) then
		clearObjects()
		if not (objects[currentDimension]) then
			outputDebugString("obj-sys: requesting dimension " .. currentDimension)
			triggerServerEvent("object:requestsync", getLocalPlayer(), currentDimension)
			
		else
			outputDebugString("obj-sys: loading from cache. dimension " .. currentDimension)
			streamDimensionIn(currentDimension)
		end
		oldDimension = currentDimension
	end
end
addEventHandler ("onClientPreRender", getRootElement(), detectInteriorChange)