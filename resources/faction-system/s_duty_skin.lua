mysql = exports.mysql

function finishDutySkin(x, y, z, rot, dimension, interior, newskin)
	setElementDimension(source, dimension)
	setElementInterior(source, interior)
	setElementPosition(source, x, y, z)
	setPedRotation(source, rot)
	setCameraTarget(source)
	exports['anticheat-system']:changeProtectedElementDataEx(source, "dutyskin", newskin, false)
	exports.mysql:query_free( "UPDATE characters SET dutyskin = " .. newskin .. " WHERE id = " .. getElementData( source, "dbid" ) )
	
	local duty = tonumber(getElementData(source, "duty"))
	if (duty>0) then -- on duty, let's give them the skin now
		setElementModel(source, newskin)
		exports.mysql:query_free( "UPDATE characters SET skin = " .. newskin .. " WHERE id = " .. getElementData( source, "dbid" ) )
	end
end
addEvent("finishDutySkin", true)
addEventHandler("finishDutySkin", getRootElement(), finishDutySkin)

-- INSECURE
function storeWeapons(weapons)
	exports['anticheat-system']:changeProtectedElementDataEx(source, "dutyguns", weapons, true)
end
addEvent("storeDutyGuns", true)
addEventHandler("storeDutyGuns", getRootElement(), storeWeapons)