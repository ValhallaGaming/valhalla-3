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
		l_cigar[player] = createModel(player, 1485) -- or 3027 or 3044
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

-- in mouth
--[[
function createModel(player, modelid)
	local x, y, z = getElementPosition(player)
	
	if (l_cigar[player] ~= nil) then
		local currobject = l_cigar[player]
		if (isElement(currobject)) then
			destroyElement(currobject)
			l_cigar[player] = nil
		end
	end
	
    local object = createObject ( modelid, 0, 0, 0 )
    attachElements ( object, player, 0.05, 0, 0.7, 0, 45, 118 ) 
	
	setElementCollisionsEnabled(object, false)
	return object
end]]

-- todo it more perfect clientside... in hands
function createModel(player, modelid)
	--local bx, by, bz = getPedBonePosition(player, 35) -- or 25
	--local x, y, z = getElementPosition(player)
	--local r = getPedRotation(player)
				
	--local ox, oy, oz = bx-x+0.13, -0.1, 0
	
	if (l_cigar[player] ~= nil) then
		local currobject = l_cigar[player]
		if (isElement(currobject)) then
			destroyElement(currobject)
			l_cigar[player] = nil
		end
	end
	
	--local object = createObject(modelid, bx, by, bz)
	local object = createObject(modelid, 0,0,0)
	--attachElements(object, player, ox, oy, oz, 0, 60, 180)
	
	setElementCollisionsEnabled(object, false)
	return object
end

function updateCig()
	for thePlayer, theObject in pairs(l_cigar) do
		local bx, by, bz = getPedBonePosition(thePlayer, 35)
		local x, y, z = getElementPosition(thePlayer)
		--local r = getPedRotation(thePlayer)
					
		local ox, oy, oz = bx-x+0.13, -0.1, 0
		moveObject ( theObject, 1, bx, by, bz )
	end
end
addEventHandler("onClientRender", getRootElement(), updateCig)