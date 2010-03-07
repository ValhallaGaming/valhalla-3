function resourceStart(res)
	setTimer(saveGuns, 60000, 0)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resourceStart)

local lastweaponstring = nil
local lastammostring = nil

function saveGuns()
	local loggedin = getElementData(getLocalPlayer(), "loggedin")
	
	if (loggedin==1) then
		local weaponstring = ""
		local ammostring = ""
		
		for i=0, 12 do
			local weapon = getPedWeapon(getLocalPlayer(), i)
			if weapon then
				local ammo = math.min( getPedTotalAmmo(getLocalPlayer(), i), getElementData(getLocalPlayer(), "ACweapon" .. weapon) or 0 )
				
				if ammo > 0 then
					weaponstring = weaponstring .. weapon .. ";"
					ammostring = ammostring .. ammo .. ";"
				end
			end
		end
		
		if (ammostring~=lastammostring) or (weaponstring~=lastweaponstring) then -- only sync if it's changed
			triggerServerEvent("syncWeapons", getLocalPlayer(), weaponstring, ammostring)
			lastammostring = ammostring
			lastweaponstring = weaponstring
		end
	end
end

addEvent("saveGuns", true)
addEventHandler("saveGuns", getRootElement(), saveGuns)