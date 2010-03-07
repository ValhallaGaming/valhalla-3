governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }
orangeVehicle = { [525]=true, [403]=true, [514]=true, [515]=true, [524]=true, [486]=true, [552]=true }

policevehicles = { }
policevehicleids = { }

-- Bind Keys required
function bindKeys(res)
	bindKey("p", "down", toggleFlashers)
	
	for key, value in ipairs(getElementsByType("vehicle")) do
		if (isElementStreamedIn(value)) then
			local modelid = getElementModel(value)
			if (governmentVehicle[modelid]) or exports.global:hasItem(value, 61) or orangeVehicle[modelid] then
				policevehicles[value] = true
			end
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)

function toggleFlashers()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	
	if (veh) then
		local modelid = getElementModel(veh)
		local blueRed = governmentVehicle[modelid]
		local flashers = exports.global:hasItem(veh, 61)
		local orange = orangeVehicle[modelid]
		if blueRed or orange or flashers then -- Emergency Light Becon
			if not policevehicles[veh] then
				policevehicles[veh] = true
			end
			local lights = getVehicleOverrideLights(veh)
			local state = getElementData(veh, "flashers")
			
			if (lights==2) then
				if not (state) then
					setElementData(veh, "flashers", true, true)
				else
					setElementData(veh, "flashers", nil, true)
				end
			end
		end
	end
end

function streamIn()
	if (getElementType(source)=="vehicle") then
		local modelid = getElementModel(source)
		if (governmentVehicle[modelid]) or exports.global:hasItem(source, 61) or orangeVehicle[modelid] then
			policevehicles[source] = true
		end
	end
end
addEvent("forceElementStreamIn", true)
addEventHandler("forceElementStreamIn", getRootElement(), streamIn)
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if (getElementType(source)=="vehicle") then
		if policevehicles[source] then
			policevehicles[source] = nil
			setVehicleHeadLightColor(source, 255, 255, 255)
			setVehicleLightState(source, 0, 0)
			setVehicleLightState(source, 1, 0)
		end
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

function doFlashes()
	for veh in pairs(policevehicles) do
		if not (isElement(veh)) then
			policevehicles[veh] = nil
		elseif (getElementData(veh, "flashers")) then
			local state = getVehicleLightState(veh, 0)
			
			local modelid = getElementModel(veh)
			local orange = orangeVehicle[modelid]
			if orange then
				setVehicleHeadLightColor(veh, 255, 90, 0)
			else
				if (state==0) then
					setVehicleHeadLightColor(veh, 0, 0, 255)
				else
					setVehicleHeadLightColor(veh, 255, 0, 0)
				end
			end
			
			setVehicleLightState(veh, 0, 1-state)
			setVehicleLightState(veh, 1, state)
		else
			policevehicles[veh] = nil
			setVehicleHeadLightColor(veh, 255, 255, 255)
			setVehicleLightState(veh, 0, 0)
			setVehicleLightState(veh, 1, 0)
		end
	end
end
setTimer(doFlashes, 250, 0)

function vehicleBlown()
	setVehicleHeadLightColor(source, 255, 255, 255)
	setVehicleLightState(source, 0, 0)
	setVehicleLightState(source, 1, 0)
end
addEventHandler("onClientVehicleRespawn", getRootElement(), vehicleBlown)

addEventHandler("onClientResourceStop", getRootElement(),
	function()
		for veh in pairs(policevehicles) do
			setVehicleHeadLightColor(veh, 255, 255, 255)
			setVehicleLightState(veh, 0, 0)
			setVehicleLightState(veh, 1, 0)
		end
		policevehicles = {}
	end
)