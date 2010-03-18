local objects = 
{
	createObject(14858, 748.44982910156, -3207.7587890625, 4532.8999023438, 0, 0, 0, 3),
	createObject(14858, 730.41284179688, -3209.4853515625, 4528.7983398438, 0, 0, 0, 3),
	createObject(14858, 698.58850097656, -3146.6887207031, 4532.9155273438, 0, 0, 90, 3),
	createObject(14858, 637.50366210938, -3196.5473632813, 4532.9389648438, 0, 0, 180, 3),
	createObject(14858, 687.36541748047, -3257.478515625, 4532.9545898438, 0, 0, 270, 3),
	createObject(2952, 691.86938476563, -3203.8193359375, 4527.7822265625, 0, 0, 90, 3)
}

local col = createColSphere(691.86938476563, -3203.8193359375, 4527.7822265625,15)
addEventHandler( "onClientColShapeHit", col,
	function( element )
		if element == getLocalPlayer( ) then
			for key, value in pairs( objects ) do
				setElementDimension( value, getElementDimension( element ) )
			end
		end
	end
)