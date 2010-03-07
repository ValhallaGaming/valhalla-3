gInteriorName, gOwnerName, gBuyMessage = nil

timer = nil

-- Message on enter
function showIntName(name, ownerName, inttype, cost, fee)
	if (guiGetVisible(gInteriorName)) then
		if isTimer(timer) then
			killTimer(timer)
			timer = nil
		end
		
		destroyElement(gInteriorName)
		gInteriorName = nil
			
		destroyElement(gOwnerName)
		gOwnerName = nil
			
		if (gBuyMessage) then
			destroyElement(gBuyMessage)
			gBuyMessage = nil
		end
	end
	
	if name then
		if (inttype==3) then -- Interior name and Owner for rented
			gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName, "sa-header")
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
		
			gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Rented by: " .. tostring(ownerName), true)
			guiSetFont(gOwnerName, "default-bold-small")
			guiLabelSetHorizontalAlign(gOwnerName, "center", true)
			guiSetAlpha(gOwnerName, 0.0)
		
		else -- Interior name and Owner for the rest
			gInteriorName = guiCreateLabel(0.0, 0.85, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName, "sa-header")
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
			
			gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Owner: " .. tostring(ownerName), true)
			guiSetFont(gOwnerName, "default-bold-small")
			guiLabelSetHorizontalAlign(gOwnerName, "center", true)
			guiSetAlpha(gOwnerName, 0.0)
		end
		if (ownerName=="None") and (inttype==3) then -- Unowned type 3 (rentable)
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Press F to rent for $" .. tostring(cost) .. ".", true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		elseif (ownerName=="None") and (inttype<2) then -- Unowned any other type
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Press F to buy for $" .. tostring(cost) .. ".", true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		else
			local msg = "Press F to enter."
			if fee and fee > 0 then
				msg = "Entrance Fee: $" .. fee
				
				if exports.global:hasMoney( getLocalPlayer(), fee ) then
					msg = msg .. "\nPress F to enter."
				end
			end
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, msg, true)
			guiSetFont(gBuyMessage, "default-bold-small")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		end
		
		timer = setTimer(fadeMessage, 50, 20, true)
	end
end

function fadeMessage(fadein)
	local alpha = guiGetAlpha(gInteriorName)
	
	if (fadein) and (alpha) then
		local newalpha = alpha + 0.05
		guiSetAlpha(gInteriorName, newalpha)
		guiSetAlpha(gOwnerName, newalpha)
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if(newalpha>=1.0) then
			timer = setTimer(hideIntName, 4000, 1)
		end
	elseif (alpha) then
		local newalpha = alpha - 0.05
		guiSetAlpha(gInteriorName, newalpha)
		guiSetAlpha(gOwnerName, newalpha)
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if(newalpha<=0.0) then
			destroyElement(gInteriorName)
			gInteriorName = nil
			
			destroyElement(gOwnerName)
			gOwnerName = nil
			
			if (gBuyMessage) then
				destroyElement(gBuyMessage)
				gBuyMessage = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

addEvent("displayInteriorName", true )
addEventHandler("displayInteriorName", getRootElement(), showIntName)

-- Creation of clientside blips
function createBlipsFromTable(interiors)
	-- remove existing house blips
	for key, value in ipairs(getElementsByType("blip")) do
		local blipicon = getBlipIcon(value)
		
		if (blipicon == 31 or blipicon == 32) then
			destroyElement(value)
		end
	end

	-- spawn the new ones.
	for key, value in ipairs(interiors) do
		createBlipAtXY(interiors[key][1], interiors[key][2], interiors[key][3])
	end
end
addEvent("createBlipsFromTable", true)
addEventHandler("createBlipsFromTable", getRootElement(), createBlipsFromTable)

function createBlipAtXY(inttype, x, y)
	if inttype == 3 then inttype = 0 end
	createBlip(x, y, 10, 31+inttype, 2, 255, 0, 0, 255, 0, 300)
end
addEvent("createBlipAtXY", true)
addEventHandler("createBlipAtXY", getRootElement(), createBlipAtXY)

function removeBlipAtXY(inttype, x, y)
	if inttype == 3 or type(inttype) ~= 'number' then inttype = 0 end
	for key, value in ipairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(value)
		local icon = getBlipIcon(value)
		
		if (icon==31+inttype and bx==x and by==y) then
			destroyElement(value)
			break
		end
	end
end
addEvent("removeBlipAtXY", true)
addEventHandler("removeBlipAtXY", getRootElement(), removeBlipAtXY)

------
local wRightClick, ax, ay = nil
local house = nil
local houseID = nil
local sx, sy = guiGetScreenSize( )
function showHouseMenu( )
	ax = math.max( math.min( sx - 160, ax - 75 ), 10 )
	ay = math.max( math.min( sx - 210, ay - 100 ), 10 )
	wRightClick = guiCreateWindow(ax, ay, 150, 200, "House " .. tostring( houseID ), false)
	
	bLock = guiCreateButton(0.05, 0.13, 0.9, 0.1, "Lock/Unlock", true, wRightClick)
	addEventHandler("onClientGUIClick", bLock, lockUnlockHouse, false)
	
	bCloseMenu = guiCreateButton(0.05, 0.27, 0.9, 0.1, "Close Menu", true, wRightClick)
	addEventHandler("onClientGUIClick", bCloseMenu, hideHouseMenu, false)
end

function lockUnlockHouse( )
	local px, py, pz = getElementPosition(getLocalPlayer())
	local x, y, z = getElementPosition(house)
	if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 5 then
		triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID )
	end
	hideHouseMenu()
end

function hideHouseMenu( )
	if wRightClick then
		destroyElement( wRightClick )
		wRightClick = nil
		showCursor( false )
	end
	house = nil
	houseID = nil
end

local function hasKey( key )
	return exports.global:hasItem(getLocalPlayer(), 4, key) or exports.global:hasItem(getLocalPlayer(), 5,key)
end
function clickHouse(button, state, absX, absY, wx, wy, wz, e)
	if (button == "right") and (state=="down") and not e then
		if getElementData(getLocalPlayer(), "exclusiveGUI") then
			return
		end
		
		local element, id = nil, nil
		local px, py, pz = getElementPosition(getLocalPlayer())
		local x, y, z = nil
		local interiorres = getResourceRootElement(getResourceFromName("interior-system"))
		local elevatorres = getResourceRootElement(getResourceFromName("elevator-system"))
		for key, value in ipairs(getElementsByType("pickup")) do
			if isElementStreamedIn(value) then
				x, y, z = getElementPosition(value)
				local minx, miny, minz, maxx, maxy, maxz
				local offset = 4
				
				minx = x - offset
				miny = y - offset
				minz = z - offset
				
				maxx = x + offset
				maxy = y + offset
				maxz = z + offset
				
				if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
					local dbid = getElementData(value, "dbid")
					if hasKey(dbid) and getElementParent( getElementParent( value ) ) == interiorres then -- house found
						element = value
						id = dbid
						break
					elseif getElementData( value, "other" ) and getElementParent( getElementParent( value ) ) == elevatorres then
						-- it's an elevator
						if hasKey(getElementDimension( value ) ) then
							element = value
							id = getElementDimension( value )
							break
						elseif hasKey(getElementDimension( getElementData( value, "other" ) ) ) then
							element = value
							id = getElementDimension( getElementData( value, "other" ) )
							break
						end
					end
				end
			end
		end
		
		if element then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 5 then
				ax, ay = getScreenFromWorldPosition(x, y, z, 0, false)
				if ax then
					hideHouseMenu()
					house = element
					houseID = id
					showHouseMenu()
				end
			else
				outputChatBox("You are too far away from this house.", 255, 0, 0)
			end
		else
			hideHouseMenu()
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickHouse, true)

local cache = { }
function findProperty(thePlayer, dimension)
	local dbid = dimension or getElementDimension( thePlayer )
	if dbid > 0 then
		if cache[ dbid ] then
			return unpack( cache[ dbid ] )
		end
		-- find the entrance and exit
		local entrance, exit = nil, nil
		for key, value in pairs(getElementsByType( "pickup", getResourceRootElement() )) do
			if getElementData(value, "name") then
				if getElementData(value, "dbid") == dbid then
					entrance = value
					break
				end
			end
		end
		
		if entrance then
			cache[ dbid ] = { dbid, entrance }
			return dbid, entrance
		end
	end
	cache[ dbid ] = { 0 }
	return 0
end

function findParent( element, dimension )
	local dbid, entrance = findProperty( element, dimension )
	return entrance
end

--

local localPlayer = getLocalPlayer()
local inttimer = nil

addEvent( "setPlayerInsideInterior", true )
addEventHandler( "setPlayerInsideInterior", getRootElement( ),
	function( other, rot )
		if inttimer then
			return
		end
		
		local dimension = getElementDimension( other )
		local interior = getElementInterior( other )
		local x, y, z = getElementPosition( other )
		
		-- fade camera to black
		fadeCamera( false, 1,0,0,0 )
		setPedFrozen( localPlayer, true )
		
		-- teleport the player during the black fade
		inttimer = setTimer(function(localPlayer, thePickup, other)
			inttimer = nil
			if isElement(localPlayer) then
				setElementInterior(localPlayer, interior)
				setCameraInterior(interior)
				setElementDimension(localPlayer, dimension)
				setElementPosition(localPlayer, x, y, z)
				if rot then
					setPedRotation(localPlayer, rot)
				end
				
				triggerEvent("usedElevator", localPlayer)
				setPedFrozen(localPlayer, true)
				
				triggerServerEvent("onPlayerInteriorChange", localPlayer, thePickup, other)
				
				-- fade camera in
				setTimer(fadeCamera, 1000, 1, true, 2)
				setTimer(setPedFrozen, 2000, 1, localPlayer, false )
			end
		end, 1000, 1, localPlayer, thePickup, other)
	end
)