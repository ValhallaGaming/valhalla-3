gezn = getElementZoneName

-- custom areas
local hospitalcol = createColCuboid( 1520, 1750, 2070, 100, 80, 30 )
setElementInterior( hospitalcol, 4 )

local bankcol = createColSphere( 2347, 2369, 2022, 100 )
setElementInterior( bankcol, 3 )

local custommaps =
{ 
	[ hospitalcol ] = { 'All Saints General Hospital', 'Los Santos' },
	[ bankcol ] = { 'Bank of Los Santos', 'Los Santos' }
}

-- caching to improve efficiency
local cache = { [true] = {}, [false] = {} }

function getElementZoneName( element, citiesonly )
	if citiesonly ~= true and citiesonly ~= false then citiesonly = false end
	
	-- check for hospital
	for col, name in pairs( custommaps ) do
		if getElementDimension( element ) == getElementDimension( col ) and getElementInterior( element ) == getElementInterior( col ) and isElementWithinColShape( element, col ) then
			return citiesonly and name[2] or name[1]
		end
	end
	
	if getElementDimension( element ) >= 19000 then
		local vehicle = exports.pool:getElement( "vehicle", getElementDimension( element ) - 20000 )
		if vehicle then
			return ( getElementZoneName( vehicle, citiesonly ) or "?" ) .. " [" .. getVehicleName( vehicle ) .. "]"
		end
	elseif not cache[citiesonly][ getElementDimension( element ) ] then
		name = ''
		if getElementDimension( element ) > 0 then
			if citiesonly then
				local parent = exports['interior-system']:findParent( element )
				if parent then
					name = getElementZoneName( parent, citiesonly, true )
				end
			else
				local dimension, entrance = exports['interior-system']:findProperty( element )
				if entrance then
					name = getElementData( entrance, 'name' )
				end
			end
			cache[citiesonly][ getElementDimension( element ) ] = name
		else
			name = gezn( element, citiesonly ), gezn( element, not citiesonly )
		end
		
		return name
	else
		return cache[citiesonly][ getElementDimension( element ) ]
	end
end
