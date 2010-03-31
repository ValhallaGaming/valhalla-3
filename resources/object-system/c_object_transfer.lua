local objects = { }
local oldDimension = 65535

function receiveSync(dimensionObjects, theDimension)
	outputDebugString("obj-sys: received dimension " .. theDimension .. " with " .. #dimensionObjects .. " objects")

	clearObjects(theDimension)
	objects[theDimension] = dimensionObjects
	
	streamDimensionIn(theDimension)
end
addEvent( "object:sync", true )
addEventHandler( "object:sync", getRootElement(), receiveSync )

function clearObjects(theDimension)
	local t = theDimension and { [theDimension] = objects[theDimension] } or objects
	for dimension, objs in pairs(t) do
		outputDebugString("obj-sys: cleaning objects in dimension " .. dimension)
		for id, object in ipairs(objs) do
			if object.o then
				destroyElement( object.o )
				object.o = nil
			end
		end
	end
end

function clearCache(theDimension)
	outputDebugString("obj-sys: received clear request for dimension " .. theDimension or -1)
	clearObjects(theDimension)
	if theDimension then
		objects[theDimension] = nil
	else
		objects = { }
	end
end
addEvent( "object:clear", true )
addEventHandler( "object:clear", getRootElement(), clearCache )

function createObjectEx(m,x,y,z,a,b,c,i,d)
	local t=createObject(m,x,y,z,a,b,c)
	setElementDimension(t,d)
	setElementInterior(t,i)
	return t
end

function streamDimensionIn(theDimension)
	if objects[theDimension] then
		outputDebugString("obj-sys: streaming objects in dimension " .. theDimension)
		for id, data in ipairs(objects[theDimension]) do
			data.o = createObjectEx(data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], theDimension)
		end
	end
end

function detectInteriorChange()
	local currentDimension = getElementDimension( getLocalPlayer() )
	if (currentDimension ~= oldDimension) and not (currentDimension == 65535) then
		clearObjects()
		if not objects[currentDimension] then
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