local objects = 
{
	createObject(14858, 748.44982910156, -2207.7587890625, 2532.8999023438, 0, 0, 0, 5),
	createObject(14858, 730.41284179688, -2209.4853515625, 2528.7983398438, 0, 0, 0, 5),
	createObject(14858, 698.58850097656, -2146.6887207031, 2532.9155273438, 0, 0, 90, 5),
	createObject(14858, 637.50366210938, -2196.5473632813, 2532.9389648438, 0, 0, 180, 5),
	createObject(14858, 687.365234375, -2257.478515625, 2532.9545898438, 0, 0, 270, 5),
	createObject(2952, 691.23748779297, -2203.8193359375, 2527.7822265625, 0, 0, 90, 5),
	createObject(1800, 693.88977050781, -2204.2270507813, 2527.8681640625, 0, 0, 0, 5),
	createObject(2514, 691.68737792969, -2200.9299316406, 2527.8681640625, 0, 0, 0, 5),
	createObject(2739, 692.20104980469, -2200.9245605469, 2527.8681640625, 0, 0, 0, 5)
}

for key,value in pairs (objects) do
	setElementStreamable ( value, false)
end

local col = createColSphere(691.806640625, -2203.0498046875, 2529.478515625,15)
setElementInterior(col,5)
addEventHandler( "onClientColShapeHit", col,
	function( element )
		if element == getLocalPlayer( ) then
			for key, value in pairs( objects ) do
				setElementDimension( value, getElementDimension( element ) )
			end
		end
	end
)