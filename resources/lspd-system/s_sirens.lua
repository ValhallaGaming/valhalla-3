function vehicleBlown()
	exports['anticheat-system']:changeProtectedElementDataEx(source, "siren")
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)