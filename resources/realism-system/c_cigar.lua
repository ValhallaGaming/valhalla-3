local l_cigar = { }

function setSmoking(player, state)
	setElementData(player,"smoking",state, false)
	if (isElement(player)) then
		if (state) then
			playerExitsVehicle(player)
		else
			playerEntersVehicle(player)
		end
	end
end

function playerExitsVehicle(player)
	if (getElementData(player, "smoking") == true) then
		l_cigar[player] = createModel(player, 3027)
	end
end
addEventHandler("onVehicleExit", getRootElement(), playerExitsVehicle)

function playerEntersVehicle(player)
	if (l_cigar[player]) then
		if (isElement( l_cigar[player] )) then
			destroyElement( l_cigar[player] )
		end
		l_cigar[player] = nil
	end
end

addEventHandler("onVehicleEnter", getRootElement(), playerEntersVehicle)

function removeSigOnExit()
	playerExitsVehicle(source)
end
addEventHandler("onPlayerQuit", getRootElement(), removeSigOnExit)

function syncCigarette(state)
	if (isElement(source)) then
		if (state) then
			setSmoking(source, true)
		else
			setSmoking(source, false)
		end
	end
end
addEvent( "realism:smokingsync", true )
addEventHandler( "realism:smokingsync", getRootElement(), syncCigarette )

addEventHandler( "onClientResourceStart", getResourceRootElement(),
    function ( startedRes )
		triggerServerEvent("realism:smoking.request", getLocalPlayer())
    end
);

function createModel(player, modelid)
	if (l_cigar[player] ~= nil) then
		local currobject = l_cigar[player]
		if (isElement(currobject)) then
			destroyElement(currobject)
			l_cigar[player] = nil
		end
	end
	
	local object = createObject(modelid, 0,0,0)

	setElementCollisionsEnabled(object, false)
	return object
end

function updateCig()
	for thePlayer, theObject in pairs(l_cigar) do
		local bx, by, bz = getPedBonePosition(thePlayer, 36)
		local x, y, z = getElementPosition(thePlayer)
		local r = getPedRotation(thePlayer)
		local dim = getElementDimension(thePlayer)
		local r = r + 170
		if (r > 360) then
			r = r - 360
		end
		
		local ratio = r/360
	
		moveObject ( theObject, 1, bx, by, bz )
		setElementRotation(theObject, 60, 30, r)
		setElementDimension(theObject, dim)
	end
end
addEventHandler("onClientPreRender", getRootElement(), updateCig)