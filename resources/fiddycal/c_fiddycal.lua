function firedFiddyCal(weapon, ammo, clipammo, x, y, z, element)
	if ( weapon == 34 ) then -- sniper
		local px, py, pz = getElementPosition(source)
		
		playSound3D("sound.wav", px, py, pz)
		
		if ( source == getLocalPlayer() and ( getElementType(element) == "vehicle" or getElementType(element) == "player" ) ) then -- we are the shooter
			triggerServerEvent("50cal", getLocalPlayer(), element)
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), firedFiddyCal)