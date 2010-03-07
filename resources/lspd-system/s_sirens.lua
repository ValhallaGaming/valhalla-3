function vehicleBlown()
	removeElementData(source, "siren")
end
addEventHandler("onVehicleRespawn", getRootElement(), vehicleBlown)