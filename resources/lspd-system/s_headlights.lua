function vehicleBlown()
	exports['anticheat-system']:changeProtectedElementDataEx(source, "flashers", nil, true)
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)