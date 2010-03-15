local has = false

function toggle()
	if ( has ) then
		outputChatBox("50cal turned off.")
		has = false
		removeEventHandler("onClientPlayerWeaponFire", getRootElement(), firedFiddyCal)
	else
		outputChatBox("50cal turned on")
		has = true
		addEventHandler("onClientPlayerWeaponFire", getRootElement(), firedFiddyCal)
	end
end

function firedFiddyCal(weapon, ammo, clipammo, x, y, z, element)
	if ( weapon == 34 ) then -- sniper
		local px, py, pz = getElementPosition(source)
		
		playSound3D("sound.wav", px, py, pz)
		
		if ( source == getLocalPlayer() and ( getElementType(element) == "vehicle" or getElementType(element) == "player" ) ) then -- we are the shooter
			triggerServerEvent("50cal", getLocalPlayer(), element)
		end
	end
end