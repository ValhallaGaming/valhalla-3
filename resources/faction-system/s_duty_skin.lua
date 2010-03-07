function finishDutySkin(x, y, z, rot, dimension, interior, newskin)
	setElementDimension(source, dimension)
	setElementInterior(source, interior)
	setElementPosition(source, x, y, z)
	setPedRotation(source, rot)
	setCameraTarget(source)
	setElementData(source, "dutyskin", newskin, false)
	mysql_free_result( mysql_query( handler, "UPDATE characters SET dutyskin = " .. newskin .. " WHERE id = " .. getElementData( source, "dbid" ) ) )
	
	local duty = tonumber(getElementData(source, "duty"))
	if (duty>0) then -- on duty, let's give them the skin now
		setElementModel(source, newskin)
		mysql_free_result( mysql_query( handler, "UPDATE characters SET skin = " .. newskin .. " WHERE id = " .. getElementData( source, "dbid" ) ) )
	end
end
addEvent("finishDutySkin", true)
addEventHandler("finishDutySkin", getRootElement(), finishDutySkin)
