local function saveGuns()
	local weapons = {}
	for i = 0, 12 do
		if (getWeaponNameFromID(getPedWeapon(getLocalPlayer(), i))~="Melee") and (getPedTotalAmmo(getLocalPlayer(),i)>0) then
			local weapon = getPedWeapon(getLocalPlayer(), i)
			local ammo = getPedTotalAmmo(getLocalPlayer(), i)
			weapons[weapon] = ammo
		end
	end
	triggerServerEvent("storeDutyGuns", getLocalPlayer(), weapons)
end

addEvent("saveGunsDuty", true)
addEventHandler("saveGunsDuty", getLocalPlayer(), saveGuns)