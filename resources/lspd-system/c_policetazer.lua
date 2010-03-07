
txd = engineLoadTXD ( "silenced.txd" )
engineImportTXD ( txd, 2918 )
dff = engineLoadDFF ( "silenced.dff", 2918 )
engineReplaceModel ( dff, 2918 )
--[[
txd = engineLoadTXD("vgsn_billboard.txd")
engineImportTXD(txd, 7301)

txd = engineLoadTXD("billbrd01_lan.txd")
engineImportTXD(txd, 4230)]]--

-- metal detector
local metalSphere = createColTube(214.578125, 123.8212890625, 999.015625, 0.5, 1)
setElementInterior(metalSphere, 10)
setElementDimension(metalSphere, 10583)

function metalDetectorHit(element, dimension)
	local x, y, z = getElementPosition(getLocalPlayer())
	if (getDistanceBetweenPoints3D(214.578125, 123.8212890625, 999.015625, x, y, z) < 10) then
		if ( dimension )  then
			if ( getElementType(element) == "player") then
				
				local meleeammo = getPedTotalAmmo(element, 1)
				local handgunammo = getPedTotalAmmo(element, 2)
				local shotgunammo = getPedTotalAmmo(element, 3)
				local smgammo = getPedTotalAmmo(element, 4)
				local rifleammo = getPedTotalAmmo(element, 5)
				local sniperammo = getPedTotalAmmo(element, 6)
				local heavyammo = getPedTotalAmmo(element, 7)
				local thrownammo = getPedTotalAmmo(element, 8)
				local detonatorammo = getPedTotalAmmo(element, 9)
				
				if (meleeammo>0 or handgunammo>0 or shotgunammo>0 or smgammo>0 or rifleammo>0 or sniperammo>0 or heavyammo>0 or thrownammo>0 or detonatorammo>0) then
					setTimer(playSoundFrontEnd, 100, 10, 5)
				end
			end
		end
	end
end
addEventHandler("onClientColShapeHit", metalSphere, metalDetectorHit)
-- end of metal detector

weapons = { }

function weaponSwitch(prevSlot, newSlot)
	local weapon = getPedWeapon(source, prevSlot)
	local newWeapon = getPedWeapon(source, newSlot)
	
	if (weapons[source] == nil) then
		weapons[source] = { }
	end

	if (weapon == 24) and (isPedInVehicle(source)==false) then
		if (weapons[source][1] == nil or weapons[source][2] ~= weapon or weapons[source][3] ~= isPedDucked(source)) then -- Model never created
			weapons[source][1] = createModel(source, weapon)
			weapons[source][2] = weapon
			weapons[source][3] = isPedDucked(source)
		else
			local object = weapons[source][1]
			destroyElement(object)
			weapons[source] = nil
		end
	elseif weapons[source] and weapons[source][1] and ( newWeapon == 24 or getPedTotalAmmo(source, 2) == 0 ) then
		local object = weapons[source][1]
		if isElement(object) then
			destroyElement(object)
		end
		weapons[source] = nil
	end
end
addEvent("onPlayerWeaponSwitch", true)
addEventHandler("onPlayerWeaponSwitch", getRootElement(), weaponSwitch)
addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(), weaponSwitch)

function switchEvent(oldSlot, newSlot)
	triggerServerEvent("sendWeaponSwitchToAll", getLocalPlayer(), oldSlot, newSlot)
end
addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(), switchEvent)


function playerEntersVehicle(player)
	if (weapons[player]) then
		local object = weapons[player][1]
		
		if (isElement(object)) then
			destroyElement(object)
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), playerEntersVehicle)

function playerExitsVehicle(player)
	if (weapons[player]) and (tonumber(getPedTotalAmmo(player, 2)) or 0) > 0 then
		local weapon = weapons[player][2]
		
		if (weapon) then
			weapons[player][1] = createModel(player, weapon)
			weapons[player][3] = isPedDucked(player)
		end
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), playerExitsVehicle)

function destroyModel()
	if (weapons[value] ~= nil) then
		local object = weapons[value][1]
		destroyElement(object)
		weapons[value] = nil
	end
end
addEventHandler("onClientPlayerWasted", getRootElement(), destroyModel)
addEventHandler("onClientPlayerQuit", getRootElement(), destroyModel)

function createModel(player, weapon)
	local bx, by, bz = getPedBonePosition(player, 41)
	crouched = isPedDucked(player)

	local objectID = 2918
	
	if (weapons[player] ~= nil) then
		local currobject = weapons[player][1]
		if (isElement(currobject)) then
			destroyElement(currobject)
		end
	end
	
	local oz = 0.09
	
	if (crouched) then
		oz = -0.525
	end
	
	local object = createObject(objectID, bx-0.19, by-0.1, oz)
	attachElements(object, player, -0.19, -0.1, oz, 0, 60, 90)
	setElementCollisionsEnabled(object, false)
	return object
end

--[[
-- aiming code
aimweapons = { }
function showTazer()
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) and (isElementStreamedIn(value)) then
			local weapon = getPedWeapon(value)
			
			if (weapon==24) then
				local deaglemode = getElementData(value, "deaglemode")

				if (deaglemode==nil or deaglemode==0) then

					--local sx, sy, sz = getPedWeaponMuzzlePosition(value)
					local sx, sy, sz = getPedBonePosition(value, 34)
					local task = getPedTask(value, "secondary", 0)
					
					if (task=="TASK_SIMPLE_USE_GUN") then --(task=="TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(value)) then
						if (aimweapons[value]~=nil) then
							-- reposition its rotation
							local x, y, z = getElementPosition(value)
							
							local object1 = aimweapons[value][1]
							local object2 = aimweapons[value][4]
							
							detachElements(value, object1)
							detachElements(value, object2)
							
							-- Calc angle
							local rx = 0
							local ry = 10
							local rz = 90
							
							local sx, sy, sz = getPedWeaponMuzzlePosition(value)
							local ex, ey, ez = getPedTargetEnd(value)
							
							local rot = getPedRotation(value)
							local hy = y + math.cos(math.rad(rot)) * 5
							
							local h = getDistanceBetweenPoints3D(sx, sy, sz, ex, ey, ez)
							local o = getDistanceBetweenPoints3D(sx, sy, sz, ex, ey, z)
							
							local c = o / h
							local r = math.cos(c) * 100
							
							ez = math.ceil(ez)
							z = math.ceil(z)

							if ( ez > (z+5) ) then -- aiming up
								r = r - 40
							elseif ( ez < z - 5 ) then -- aiming down
								r = 360 - (r - 10)
							else -- aiming forward
								r = r - 60
							end

							
							local rot = getPedRotation(value)
							local sx, sy, sz = getPedBonePosition(value, 36)
							if (r ~= 0) then
								setElementPosition(object1, sx, sy, sz)
								setElementRotation(object1, rx, 365-r, rot+90)
								
								setElementPosition(object2, sx, sy, sz)
								setElementRotation(object2, rx, 365-r, rot+90)
							end
						elseif (aimweapons[value]==nil) then
							local object = createObject(2918, sx-0.19, sy-0.1, sz)
							local object2 = createObject(2918, sx-0.19, sy-0.1, sz)
							local x, y, z = getElementPosition(value)
							
							local ox = (sx +  0.6) - x
							local oy = (sy + 0.15) - y
							local oz = (sz - 0.01) - z
							
							local ox2 = (sx +  0.57) - x
							local oy2 = (sy + 0.15) - y
							local oz2 = (sz - 0.01) - z
							
							setObjectScale(object, 1.5)
							setElementCollisionsEnabled(object, false)
							
							setObjectScale(object2, 1.5)
							setElementCollisionsEnabled(object2, false)
							aimweapons[value] = { }
							aimweapons[value][1] = object
							aimweapons[value][2] = 24
							aimweapons[value][3] = isPedDucked(value)
							aimweapons[value][4] = object2
						end
					elseif (aimweapons[value]~=nil) then
						destroyElement(aimweapons[value][1])
						destroyElement(aimweapons[value][4])
						aimweapons[value] = nil
					end
				elseif (aimweapons[value]~=nil) then
					destroyElement(aimweapons[value][1])
					destroyElement(aimweapons[value][4])
					aimweapons[value] = nil
				end
			end
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), showTazer)

]]--