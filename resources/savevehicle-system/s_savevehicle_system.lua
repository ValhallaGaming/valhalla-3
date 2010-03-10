mysql = exports.mysql

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function saveVehicle(source)
	local dbid = tonumber(getElementData(source, "dbid")) or -1
	
	if isElement(source) and getElementType(source) == "vehicle" and dbid >= 0 then -- Check it's a permanently spawned vehicle and not a job vehicle
		local tick = getTickCount()
		local model = getElementModel(source)
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getVehicleRotation(source)
		
		local owner = getElementData(source, "owner")
		
		if (owner~=-1) then
			local col1, col2, col3, col4 = getVehicleColor(source)
			if getElementData(source, "oldcolors") then
				col1, col2, col3, col4 = unpack(getElementData(source, "oldcolors"))
			end
			
			local fuel = getElementData(source, "fuel")
			
			local engine = getElementData(source, "engine")
			
			local locked = isVehicleLocked(source)
			
			if (locked) then
				locked = 1
			else
				locked = 0
			end
			
			local lights = getVehicleOverrideLights(source)
				
			local sirens = getVehicleSirensOn(source)
				
			if (sirens) then
				sirens = 1
			else
				sirens = 0
			end
				
			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(source)
				
			mysql:query_free("UPDATE vehicles SET model='" .. mysql:escape_string(model) .. "', currx='" .. mysql:escape_string(round(x, 6)) .. "', curry='" .. mysql:escape_string(round(y, 6)) .. "', currz='" .. mysql:escape_string(round(z, 6)) .. "', currrx='" .. mysql:escape_string(rx) .. "', currry='" .. mysql:escape_string(ry) .. "', currrz='" .. mysql:escape_string(rz) .. "', color1='" .. mysql:escape_string(col1) .. "', color2='" .. mysql:escape_string(col2) .. "', fuel='" .. mysql:escape_string(fuel) .. "', engine='" .. mysql:escape_string(engine) .. "', locked='" .. mysql:escape_string(locked) .. "', lights='" .. mysql:escape_string(lights) .. "', wheel1='" .. mysql:escape_string(wheel1) .. "', wheel2='" .. mysql:escape_string(wheel2) .. "', wheel3='" .. mysql:escape_string(wheel3) .. "', wheel4='" .. mysql:escape_string(wheel4) .. "' WHERE id='" .. mysql:escape_string(dbid) .. "'")
			local panel0 = getVehiclePanelState(source, 0)
			local panel1 = getVehiclePanelState(source, 1)
			local panel2 = getVehiclePanelState(source, 2)
			local panel3 = getVehiclePanelState(source, 3)
			local panel4 = getVehiclePanelState(source, 4)
			local panel5 = getVehiclePanelState(source, 5)
			local panel6 = getVehiclePanelState(source, 6)
				
			local door1 = getVehicleDoorState(source, 0)
			local door2 = getVehicleDoorState(source, 1)
			local door3 = getVehicleDoorState(source, 2)
			local door4 = getVehicleDoorState(source, 3)
			local door5 = getVehicleDoorState(source, 4)
			local door6 = getVehicleDoorState(source, 5)
			
			local upgrade0 = getElementData( source, "oldupgrade" .. 0 ) or getVehicleUpgradeOnSlot(source, 0)
			local upgrade1 = getElementData( source, "oldupgrade" .. 1 ) or getVehicleUpgradeOnSlot(source, 1)
			local upgrade2 = getElementData( source, "oldupgrade" .. 2 ) or getVehicleUpgradeOnSlot(source, 2)
			local upgrade3 = getElementData( source, "oldupgrade" .. 3 ) or getVehicleUpgradeOnSlot(source, 3)
			local upgrade4 = getElementData( source, "oldupgrade" .. 4 ) or getVehicleUpgradeOnSlot(source, 4)
			local upgrade5 = getElementData( source, "oldupgrade" .. 5 ) or getVehicleUpgradeOnSlot(source, 5)
			local upgrade6 = getElementData( source, "oldupgrade" .. 6 ) or getVehicleUpgradeOnSlot(source, 6)
			local upgrade7 = getElementData( source, "oldupgrade" .. 7 ) or getVehicleUpgradeOnSlot(source, 7)
			local upgrade8 = getElementData( source, "oldupgrade" .. 8 ) or getVehicleUpgradeOnSlot(source, 8)
			local upgrade9 = getElementData( source, "oldupgrade" .. 9 ) or getVehicleUpgradeOnSlot(source, 9)
			local upgrade10 = getElementData( source, "oldupgrade" .. 10 ) or getVehicleUpgradeOnSlot(source, 10)
			local upgrade11 = getElementData( source, "oldupgrade" .. 11 ) or getVehicleUpgradeOnSlot(source, 11)
			local upgrade12 = getElementData( source, "oldupgrade" .. 12 ) or getVehicleUpgradeOnSlot(source, 12)
			local upgrade13 = getElementData( source, "oldupgrade" .. 13 ) or getVehicleUpgradeOnSlot(source, 13)
			local upgrade14 = getElementData( source, "oldupgrade" .. 14 ) or getVehicleUpgradeOnSlot(source, 14)
			local upgrade15 = getElementData( source, "oldupgrade" .. 15 ) or getVehicleUpgradeOnSlot(source, 15)
			local upgrade16 = getElementData( source, "oldupgrade" .. 16 ) or getVehicleUpgradeOnSlot(source, 16)

			local Impounded = getElementData(source, "Impounded") or 0

			local handbrake = getElementData(source, "handbrake") or 0
			
			local health = getElementHealth(source)
			
			local paintjob = getVehiclePaintjob(source)
			if getElementData(source, "oldpaintjob") then
				paintjob = getElementData(source, "oldpaintjob")
			end
			
			local dimension = getElementDimension(source)
			local interior = getElementInterior(source)
			
			mysql:query_free("UPDATE vehicles SET panel0='" .. mysql:escape_string(panel0) .. "', panel1='" .. mysql:escape_string(panel1) .. "', panel2='" .. mysql:escape_string(panel2) .. "', panel3='" .. mysql:escape_string(panel3) .. "', panel4='" .. mysql:escape_string(panel4) .. "', panel5='" .. mysql:escape_string(panel5) .. "', panel6='" .. mysql:escape_string(panel6) .. "', door1='" .. mysql:escape_string(door1) .. "', door2='" .. mysql:escape_string(door2) .. "', door3='" .. mysql:escape_string(door3) .. "', door4='" .. mysql:escape_string(door4) .. "', door5='" .. mysql:escape_string(door5) .. "', door6='" .. mysql:escape_string(door6) .. "', hp='" .. mysql:escape_string(health) .. "', sirens='" .. mysql:escape_string(sirens) .. "', paintjob='" .. mysql:escape_string(paintjob) .. "', currdimension='" .. mysql:escape_string(dimension) .. "', currinterior='" .. mysql:escape_string(interior) .. "' WHERE id='" .. mysql:escape_string(dbid) .. "'")
			mysql:query_free("UPDATE vehicles SET upgrade0='" .. mysql:escape_string(upgrade0) .. "', upgrade1='" .. mysql:escape_string(upgrade1) .. "', upgrade2='" .. mysql:escape_string(upgrade2) .. "', upgrade3='" .. mysql:escape_string(upgrade3) .. "', upgrade4='" .. mysql:escape_string(upgrade4) .. "', upgrade5='" .. mysql:escape_string(upgrade5) .. "', upgrade6='" .. mysql:escape_string(upgrade6) .. "', upgrade7='" .. mysql:escape_string(upgrade7) .. "', upgrade8='" .. mysql:escape_string(upgrade8) .. "', upgrade9='" .. mysql:escape_string(upgrade9) .. "', upgrade10='" .. mysql:escape_string(upgrade10) .. "', upgrade11='" .. mysql:escape_string(upgrade11) .. "', upgrade12='" .. mysql:escape_string(upgrade12) .. "', upgrade13='" .. mysql:escape_string(upgrade13) .. "', upgrade14='" .. mysql:escape_string(upgrade14) .. "', upgrade15='" .. mysql:escape_string(upgrade15) .. "', upgrade16='" .. mysql:escape_string(upgrade16) .. "', Impounded='" .. mysql:escape_string(tonumber(Impounded)) .. "', handbrake='" .. mysql:escape_string(tonumber(handbrake)) .. "' WHERE id='" .. mysql:escape_string(dbid) .. "'")
			
			
			local timeTaken = (getTickCount() - tick)/1000
		end
	end
end

local function saveVehicleOnExit(thePlayer, seat)
	saveVehicle(source)
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicleOnExit)