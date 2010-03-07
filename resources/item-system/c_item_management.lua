--[[
x hasItem(obj, itemID, itemValue = nil ) -- returns true if the player has that item
x hasSpaceForItem(obj) -- returns true if you can put more stuff in

x getItems(obj) -- returns an array of all items in { slot = { itemID, itemValue } } table
x getInventorySlots(obj) -- returns the number of available inventory slots
]]
local saveditems = {} -- client-side saved items


-- Recieve Items from the server
local function recieveItems( items )
	saveditems[ source ] = items
end

addEvent( "recieveItems", true )
addEventHandler( "recieveItems", getRootElement( ), recieveItems )

-- checks if the element has that specific item
function hasItem(element, itemID, itemValue)
	if not saveditems[element] then
		return false, "Unknown"
	end
	
	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
			return true, key, value[2], value[3]
		end
	end
	return false
end

-- checks if the element has space for adding a new item
function hasSpaceForItem(element, itemID)
	if not saveditems[element] then
		return false, "Unknown"
	end
	
	local keycount = countItems( element, 3 ) + countItems( element, 4 ) + countItems( element, 5 ) + countItems( element, 73 ) + countItems( element, 98 )
	if itemID == 3 or itemID == 4 or itemID == 5 or itemID == 73 or itemID == 98 then
		return keycount < 2 * getInventorySlots(element)
	else
		return #getItems(element) - keycount < getInventorySlots(element)
	end
end

-- count all instances of that object
function countItems( element, itemID, itemValue )
	if not saveditems[element] then
		return 0
	end
	
	local count = 0
	for key, value in pairs(saveditems[element]) do
		if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
			count = count + 1
		end
	end
	return count
end

-- returns a list of all items of that element
function getItems(element)
	if not saveditems[element] then
		return {}, "Unknown"
	end

	return saveditems[element]
end

-- returns the number of available item slots for that element
local function isTruck( element )
	local model = getElementModel( element )
	return model == 499 or model == 482 or model == 498 or model == 609 or model == 524 or model == 455 or model == 414 or model == 582 or model == 443 or model == 514 or model == 413 or model == 515 or model == 440 or model == 459 or model == 408 or model == 456
end

function getInventorySlots(element)
	if getElementType( element ) == "player" then
		if hasItem(element, 48) then
			return 20
		else
			return 10
		end
	elseif getElementType( element ) == "vehicle" then
		if getID( element ) < 0 then
			return 0
		elseif getVehicleType( element ) == "BMX" then
			return 5
		elseif getVehicleType( element ) == "Bike" then
			return 10
		elseif isTruck( element ) then
			return 40
		else
			return 20
		end
	elseif getElementParent(getElementParent(element)) == getResourceRootElement() then -- World Item
		return getElementModel(element) == 2147 and 50 or 10
	else
		return 20
	end
end

-- tell the server we're ready
addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		triggerServerEvent( "itemResourceStarted", getLocalPlayer( ) )
	end
)