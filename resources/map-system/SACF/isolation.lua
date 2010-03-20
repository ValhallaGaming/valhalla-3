local objects = 
{
	createObject(14858, 748.44982910156, -2207.7587890625, 1532.8999023438, 0, 0, 0, 4),
	createObject(14858, 730.41284179688, -2209.4853515625, 1528.7983398438, 0, 0, 0, 4),
	createObject(14858, 698.58850097656, -2146.6887207031, 1532.9155273438, 0, 0, 90, 4),
	createObject(14858, 637.50366210938, -2196.5473632813, 1532.9389648438, 0, 0, 180, 4),
	createObject(14858, 687.36541748047, -2257.478515625, 1532.9545898438, 0, 0, 270, 4),
	createObject(2952, 691.86938476563, -2203.8193359375, 1527.7822265625, 0, 0, 90, 4)
}

for key,value in pairs (objects) do
	setElementStreamable ( value, false)
end

local col = createColSphere(694.2880859375, -2203.408203125, 1528.8681640625,8)
setElementInterior(col, 4)
addEventHandler( "onClientColShapeHit", col,
	function( element )
		if element == getLocalPlayer( ) then
			for key, value in pairs( objects ) do
				setElementDimension( value, getElementDimension( element ) )
			end
		end
	end
)