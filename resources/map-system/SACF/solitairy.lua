local objects = 
{
	createObject(14858, 748.44982910156, -3207.7587890625, 4532.8999023438, 0, 0, 0, 4),
	createObject(14858, 730.41284179688, -3209.4853515625, 4528.7983398438, 0, 0, 0, 4),
	createObject(14858, 698.58850097656, -3146.6887207031, 4532.9155273438, 0, 0, 90, 4),
	createObject(14858, 637.50366210938, -3196.5473632813, 4532.9389648438, 0, 0, 180, 4),
	createObject(14858, 687.365234375, -3257.478515625, 4532.9545898438, 0, 0, 270, 4),
	createObject(2952, 691.23748779297, -3203.8193359375, 4527.7822265625, 0, 0, 90, 4),
	createObject(1800, 693.88977050781, -3204.2270507813, 4527.8681640625, 0, 0, 0, 4),
	createObject(2514, 691.68737792969, -3200.9299316406, 4527.8681640625, 0, 0, 0, 4),
	createObject(2739, 692.20104980469, -3200.9245605469, 4527.8681640625, 0, 0, 0, 4)
}

local col = createColSphere(692.20104980469, -3200.9245605469, 4527.8681640625,100)
addEventHandler( "onClientColShapeHit", col,
	function( element )
		if element == getLocalPlayer( ) then
			for key, value in pairs( objects ) do
				setElementDimension( value, getElementDimension( element ) )
			end
		end
	end
)