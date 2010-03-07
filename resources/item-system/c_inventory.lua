-- Configuration
local background_color = tocolor( 0, 0, 0, 127 )
local background_error_color = tocolor( 255, 0, 0, 127 )
local background_movetoelement_color = tocolor( 127, 127, 255, 63 )
local empty_color = tocolor( 127, 127, 127, 10 )
local full_color = tocolor( 255, 255, 255, 10 )
local tooltip_text_color = tocolor( 255, 255, 255, 255 )
local tooltip_background_color = tocolor( 0, 0, 0, 190 )
local active_tab_color = tocolor( 127, 255, 127, 127 )

--

local rows = 5

local box = 80
local spacer = 10
local sbox = spacer + box

local sx, sy = guiGetScreenSize()

local localPlayer = getLocalPlayer( )

local inventory = false -- elements to display
local show = false -- defines wherever to show the inventory or not
local useHQimages = nil

--

local clickDown = false
waitingForItemDrop = false
local hoverElement = false

local hoverItemSlot = false
local clickItemSlot = false

local hoverWorldItem = false
local clickWorldItem = false

local isCursorOverInventory = false
local activeTab = 1
local hoverAction = false
local actionIcons =
{
	{ 48, tocolor( 255, 255, 127, 63 ), "Items" },
	{ 4, tocolor( 255, 255, 127, 63 ), "Keys" },
	{ -28, tocolor( 255, 255, 127, 63 ), "Weapons" },
	{ -202, tocolor( 127, 255, 127, 63 ), "Drop Item", "Press CTRL while selecting an item to automatically drop it." },
	{ -201, tocolor( 127, 127, 255, 63 ), "Show Item" },
	{ -200, tocolor( 255, 127, 127, 63 ), "Destroy Item", "Press DELETE while selecting an item to automatically delete it." }
}

local savedArmor = false

--

local function getHoverElement( )
	local cursorX, cursorY, absX, absY, absZ = getCursorPosition( )
	local cameraX, cameraY, cameraZ = getWorldFromScreenPosition( cursorX, cursorY, 0.1 )
	local a, b, c, d, element = processLineOfSight( cameraX, cameraY, cameraZ, absX, absY, absZ )
	if element and getElementParent(getElementParent(element)) == getResourceRootElement() then
		return element
	elseif b and c and d then
		element = nil
		local x, y, z = nil
		local maxdist = 0.34
		for key, value in ipairs(getElementsByType("object",getResourceRootElement())) do
			if isElementStreamedIn(value) and isElementOnScreen(value) then
				x, y, z = getElementPosition(value)
				local dist = getDistanceBetweenPoints3D(x, y, z, b, c, d)
				
				if dist < maxdist then
					element = value
					maxdist = dist
				end
			end
		end
		if element then
			local px, py, pz = getElementPosition( localPlayer )
			return getDistanceBetweenPoints3D( px, py, pz, getElementPosition( element ) ) < 10 and element
		end
	end
end

local function tooltip( x, y, text, text2 )
	text = tostring( text )
	if text2 then
		text2 = tostring( text2 )
	end
	
	if text == text2 then
		text2 = nil
	end
	
	local width = dxGetTextWidth( text, 1, "clear" ) + 20
	if text2 then
		width = math.max( width, dxGetTextWidth( text2, 1, "clear" ) + 20 )
		text = text .. "\n" .. text2
	end
	local height = 10 * ( text2 and 5 or 3 )
	x = math.max( 10, math.min( x, sx - width - 10 ) )
	y = math.max( 10, math.min( y, sy - height - 10 ) )
	
	dxDrawRectangle( x, y, width, height, tooltip_background_color, true )
	dxDrawText( text, x, y, x + width, y + height, tooltip_text_color, 1, "clear", "center", "center", false, false, true )
end

local function isInBox( x, y, xmin, xmax, ymin, ymax )
	return x >= xmin and x <= xmax and y >= ymin and y <= ymax
end

local function getWeapons( )
	local weapons = { }
	
	for i = 0, 12 do
		if getPedWeapon(localPlayer, i) and getPedWeapon(localPlayer, i) ~= 0 then
			local ammo = math.min( getPedTotalAmmo(getLocalPlayer(), i), getElementData(getLocalPlayer(), "ACweapon" .. getPedWeapon(localPlayer, i)) or 0 )
			if ammo > 0 then
				weapons[ #weapons + 1 ] = { -getPedWeapon(localPlayer, i), ammo, -i, false }
			end
		end
	end
	
	local armor = math.floor( getPedArmor( localPlayer ) )
	if armor > 0 then
		weapons[ #weapons + 1 ] = { -100, armor, -100, false }
	end
	savedArmor = armor
	
	return weapons
end

local function getImage( itemID, itemValue )
	if itemID ~= 16 then
		if useHQimages == nil then
			if dxDrawImage( 0, 0, 1, 1, "hqimages/" .. itemID .. ".png" ) then
				useHQimages = true
			else
				useHQimages = false
			end
		end
		

		return ( useHQimages and "hq" or "" ) .. "images/" .. itemID .. ".png"
	else
		return ":account-system/img/" .. ("%03d"):format(itemValue) .. ".png"
	end
end

addEventHandler( "onClientRender", getRootElement( ),
	function( )
		hoverItemSlot = false
		hoverWorldItem = false
		hoverAction = false
		isCursorOverInventory = false
		hoverElement = false
		
		if not guiGetInputEnabled( ) and not isMTAWindowActive( ) and isCursorShowing( ) then
			local cursorX, cursorY, cwX, cwY, cwZ = getCursorPosition( )
			local cursorX, cursorY = cursorX * sx, cursorY * sy
			
			-- background
			if activeTab == 3 or not inventory or ( activeTab == 3 and savedArmor ~= math.floor( getPedArmor( localPlayer ) ) ) then
				if activeTab == 3 then
					inventory = getWeapons( )
				else
					local items = getItems( localPlayer )
					if items then
						inventory = {}
						for k, v in ipairs( items ) do
							if ( activeTab == 2 ) ~= ( getItemType( v[1] ) ~= 2 ) then
								inventory[ #inventory + 1 ] = { v[1], v[2], v[3], k }
							end
						end
					else
						return
					end
				end
			end
			
			local isMove = clickDown and clickItemSlot and ( getTickCount( ) - clickDown >= 200 ) -- dragging items from inv
			local columns = math.ceil( #inventory / 5 )
			local x = sx - columns * sbox - spacer
			local y = ( sy - rows * sbox - spacer ) / 2 + sbox + spacer
			
			if show then
				-- inventory buttons
				local x2 = x - sbox
				local irows = isMove and 4 or 1
				local jrows = isMove and 6 or 3
				local y2 = y + sbox
				dxDrawRectangle( x2, y2, sbox, ( jrows - irows + 1 ) * sbox + spacer, background_color )
				for i = irows, jrows do
					local icon = actionIcons[ i ]
					local boxx = x2 + spacer
					local boxy = y2 + spacer + sbox * ( i - irows )
					dxDrawRectangle( boxx, boxy, box, box, i == activeTab and active_tab_color or icon[2] )
					dxDrawImage( boxx, boxy, box, box, getImage( icon[1] ) )
					
					if not clickWorldItem and isInBox( cursorX, cursorY, boxx, boxx + box, boxy, boxy + box ) then
						if i <= 3 then
							if not isMove then -- tabs
								tooltip( cursorX, cursorY, icon[3], icon[4] )
								hoverAction = i
							end
						elseif isMove then
							tooltip( cursorX, cursorY, icon[3], icon[4] )
							hoverAction = i
						end
					end
				end
				
				isCursorOverInventory = isInBox( cursorX, cursorY, x, sx, y, y + rows * sbox + spacer ) or isInBox( cursorX, cursorY, x2, x2 + sbox, y2, y2 + ( jrows - irows + 1 ) * sbox + spacer )
				
				-- actual inv
				dxDrawRectangle( x, y, columns * sbox + spacer, rows * sbox + spacer, background_color )
				for i = 1, columns * 5 do
					local col = math.floor( ( i - 1 ) / 5 )
					local row = ( i - 1 ) % 5
					
					local boxx = x + col * sbox + spacer
					local boxy = y + row * sbox + spacer
					
					local item = inventory[ i ]
					if item then
						if not isMove or item[4] ~= clickItemSlot.id then
							dxDrawRectangle( boxx, boxy, box, box, full_color )
							dxDrawImage( boxx, boxy, box, box, getImage( item[1], item[2] ) )
							
							-- ammo count for weapons
							if activeTab == 3 then
								dxDrawText( tostring( item[2] ), boxx + 2, boxy + 2, boxx + box - 2, boxy + box - 2, tooltip_text_color, 1, "clear", "right", "bottom", false, false, true )
							end
							
							if not isMove and not clickWorldItem and isInBox( cursorX, cursorY, boxx, boxx + box, boxy, boxy + box ) then
								local itemName = getItemName( item[1], item[2] )
								local itemValue = getItemValue( item[1], item[2] )
								if itemValue and #tostring( itemValue ) > 0 and itemValue ~= 1 then
									itemName = itemName .. " (" .. itemValue .. ")"
								end
								tooltip( cursorX, cursorY, itemName, activeTab == 1 and getItemDescription( item[1], item[2] ) )
								hoverItemSlot = { invslot = i, id = item[4], x = boxx, y = boxy }
							end
						end
					else
						dxDrawRectangle( boxx, boxy, box, box, empty_color )
					end
				end
			end
			
			if clickDown and ( getTickCount( ) - clickDown >= 200 ) and ( clickItemSlot or clickWorldItem ) then
				local boxx, boxy, item
				local color = full_color
				local col, x, y, z
				if clickWorldItem then
					item = { getElementData( clickWorldItem, "itemID" ), getElementData( clickWorldItem, "itemValue" ), false, false }
					boxx = cursorX - spacer - box / 2
					boxy = cursorY - spacer - box / 2
					if isCursorOverInventory then
						if not hasSpaceForItem( localPlayer, item[1] ) then
							color = background_error_color
						end
					else
						-- check if we can drop there
						local cameraX, cameraY, cameraZ = getWorldFromScreenPosition( cursorX, cursorY, 0.1 )
						col, x, y, z, hoverElement = processLineOfSight( cameraX, cameraY, cameraZ, cwX, cwY, cwZ )
						if not col or getDistanceBetweenPoints3D( x, y, z, getElementPosition( localPlayer ) ) >= 10 then
							color = background_error_color
						elseif hoverElement then
							if getElementType( hoverElement ) == "vehicle" then
								color = isVehicleLocked( hoverElement ) and background_error_color or background_movetoelement_color
							elseif getElementType( hoverElement ) == "player" then
								color = item[1] < 0 and background_error_color or background_movetoelement_color
							elseif getElementModel( hoverElement ) == 2332 then -- safe
								color = ( hasItem( localPlayer, 4, getElementDimension( localPlayer ) ) or hasItem( localPlayer, 5, getElementDimension( localPlayer ) ) ) and background_movetoelement_color or background_error_color
							elseif getElementModel( hoverElement ) == 2147 then -- fridge
								color = getItemType( item[ 1 ] ) == 1 and background_movetoelement_color or background_error_color
							else
								color = full_color
							end
						end
					end
				else
					item = inventory[ clickItemSlot.invslot ]
					boxx = clickItemSlot.rx + cursorX
					boxy = clickItemSlot.ry + cursorY

					if not isCursorOverInventory then
						-- check if we can drop there
						local cameraX, cameraY, cameraZ = getWorldFromScreenPosition( cursorX, cursorY, 0.1 )
						col, x, y, z, hoverElement = processLineOfSight( cameraX, cameraY, cameraZ, cwX, cwY, cwZ )
						if not col or getDistanceBetweenPoints3D( x, y, z, getElementPosition( localPlayer ) ) >= 10 then
							color = background_error_color
						elseif hoverElement then
							if getElementType( hoverElement ) == "vehicle" then
								color = isVehicleLocked( hoverElement ) and background_error_color or background_movetoelement_color
							elseif getElementType( hoverElement ) == "player" then
								color = item[1] < 0 and background_error_color or background_movetoelement_color
							elseif getElementModel( hoverElement ) == 2332 then -- safe
								color = ( hasItem( localPlayer, 4, getElementDimension( localPlayer ) ) or hasItem( localPlayer, 5, getElementDimension( localPlayer ) ) ) and background_movetoelement_color or background_error_color
							elseif getElementModel( hoverElement ) == 2147 then -- fridge
								color = getItemType( item[ 1 ] ) == 1 and background_movetoelement_color or background_error_color
							elseif getElementParent(getElementParent(hoverElement)) ~= getResourceRootElement() or hoverElement == getHoverElement() then
								color = full_color
							else
								color = background_error_color
							end
						end

					end
				end
				
				dxDrawRectangle( boxx - spacer, boxy - spacer, box + 2 * spacer, box + 2 * spacer, background_color )
				dxDrawRectangle( boxx, boxy, box, box, color )
				dxDrawImage( boxx, boxy, box, box, getImage( item[1], item[2] ) )
				if hoverElement then
					if color == background_movetoelement_color then
						local name = ""
						if getElementType( hoverElement ) == "player" then
							name = getPlayerName( hoverElement ):gsub( "_", " " )
						elseif getElementType( hoverElement ) == "vehicle" then
							name = getVehicleName( hoverElement ) .. " (#" .. getElementData( hoverElement, "dbid" ) .. ")"
						elseif getElementModel( hoverElement ) == 2147 then
							name = "Fridge"
						elseif getElementModel( hoverElement ) == 2332 then
							name = "Safe"
						end
						tooltip( boxx + sbox, boxy + ( box - 50 ) / 2, getItemName( item[1], item[2] ), "Move to " .. name .. "." )
					elseif color == full_color then
						hoverElement = nil
					else
						hoverElement = false
					end
				else
					hoverElement = nil
				end
			end
			
			if show then
				-- hide any tooltips while over the inventory
				if isCursorOverInventory or clickWorldItem then
					return
				end
			end
			
			local element = getHoverElement()
			if element then
				local itemID = getElementData( element, "itemID" )
				local itemValue = getElementData( element, "itemValue" )
				local itemName = getItemName( itemID, itemValue )
				
				local itemValue = getItemValue( itemID, itemValue )
				if itemValue and #tostring( itemValue ) > 0 and itemValue ~= 1 then 
					itemName = itemName .. " (" .. itemValue .. ")"
				end
				
				tooltip( cursorX, cursorY, itemName, getItemDescription( itemID, itemValue ) )
				hoverWorldItem = element
			end
		end
	end
)

addEventHandler( "recieveItems", getRootElement( ), 
	function( )
		inventory = false
	end
)

addEventHandler( "onClientClick", getRootElement( ),
	function( button, state, cursorX, cursorY, worldX, worldY, worldZ )
		if not waitingForItemDrop then
			if button == "left" then
				if hoverItemSlot or clickItemSlot then
					if state == "down" then
						clickDown = getTickCount( )
						clickItemSlot = hoverItemSlot
						clickItemSlot.rx = clickItemSlot.x - cursorX
						clickItemSlot.ry = clickItemSlot.y - cursorY
					end
					
					if state == "down" and getKeyState( "delete" ) then -- quick delete
						state = "up"
						clickDown = 0
						hoverAction = 6
					elseif state == "down" and ( getKeyState( "lctrl" ) or getKeyState( "rctrl" ) ) then -- quick drop
						state = "up"
						clickDown = 0
						hoverAction = 4
					end
					
					if state == "up" and clickItemSlot then
						if getTickCount( ) - clickDown < 200 then
							if isCursorOverInventory then
								useItem( inventory[ clickItemSlot.invslot ][ 1 ] < 0 and inventory[ clickItemSlot.invslot ][ 3 ] or clickItemSlot.id )
							end
						else
							if not isCursorOverInventory then
								-- Drag&Drop
								if getDistanceBetweenPoints3D( worldX, worldY, worldZ, getElementPosition( localPlayer ) ) < 10 then
									local item = inventory[ clickItemSlot.invslot ]
									local itemID = item[1]
									local itemValue = item[2]
									if hoverElement == nil then
										if itemID > 0 then
											waitingForItemDrop = true
											triggerServerEvent( "dropItem", localPlayer, clickItemSlot.id, worldX, worldY, worldZ )
										elseif itemID == -100 then
											waitingForItemDrop = true
											triggerServerEvent( "dropItem", localPlayer, 100, worldX, worldY, worldZ, savedArmor )
										else
											-- weapon
											local slot = -item[3]
											if slot >= 2 and slot <= 9 then
												openWeaponDropGUI(-itemID, itemValue, worldX, worldY, worldZ)
											else
												waitingForItemDrop = true
												triggerServerEvent( "dropItem", localPlayer, -itemID, worldX, worldY, worldZ, itemValue )
											end
										end
									elseif hoverElement then
										if itemID > 0 then
											waitingForItemDrop = true
											triggerServerEvent( "moveToElement", localPlayer, hoverElement, clickItemSlot.id, nil, "finishItemDrop" )
										elseif itemID == -100 then
											triggerServerEvent( "moveToElement", localPlayer, hoverElement, clickItemSlot.id, true, "finishItemDrop" )
										else
											triggerServerEvent( "moveToElement", localPlayer, hoverElement, -itemID, itemValue, "finishItemDrop" )
										end
									end
								end
							elseif hoverAction == 4 then
								local item = inventory[ clickItemSlot.invslot ]
								local itemID = item[ 1 ]
								local itemValue = item[2]
								
								local matrix = getElementMatrix(getLocalPlayer())
								local oldX = 0
								local oldY = 1
								local oldZ = 0
								local x = oldX * matrix[1][1] + oldY * matrix [2][1] + oldZ * matrix [3][1] + matrix [4][1]
								local y = oldX * matrix[1][2] + oldY * matrix [2][2] + oldZ * matrix [3][2] + matrix [4][2]
								local z = oldX * matrix[1][3] + oldY * matrix [2][3] + oldZ * matrix [3][3] + matrix [4][3]
								
								local z = getGroundPosition( x, y, z + 2 )
								
								if itemID > 0 then
									waitingForItemDrop = true
									triggerServerEvent( "dropItem", localPlayer, clickItemSlot.id, x, y, z )
								elseif itemID == -100 then
									waitingForItemDrop = true
									triggerServerEvent( "dropItem", localPlayer, 100, x, y, z, savedArmor )
								else
									-- weapon
									local slot = -item[3]
									if slot >= 2 and slot <= 9 then
										openWeaponDropGUI(-itemID, itemValue, x, y, z)
									else
										waitingForItemDrop = true
										triggerServerEvent( "dropItem", localPlayer, -itemID, x, y, z, itemValue )
									end
								end
							elseif hoverAction == 5 then
								-- Show Item
								local item = inventory[ clickItemSlot.invslot ]
								local itemName, itemValue = getItemName( item[1], item[2] ), getItemValue( item[1], item[2] )
								if itemName == "Note" then
									itemName = itemName .. ", reading " .. itemValue
								elseif itemName == "Porn Tape" then
									itemName = itemName .. ", " .. itemValue
								elseif itemName == "BT&R Identification" then
									itemName = itemName .. ", issued to " .. itemValue
								elseif itemName == "SAN Identifcation" then
									itemName = itemName .. ", issued to " .. itemValue
								end
								triggerServerEvent( "showItem", localPlayer, itemName )
							elseif hoverAction == 6 then
								local item = inventory[ clickItemSlot.invslot ]
								local itemID = item[ 1 ]
								local itemSlot = itemID < 0 and itemID or clickItemSlot.id
								if itemID == 48 and countItems( localPlayer, 48 ) == 1 then -- backpack
									local keycount = countItems( localPlayer, 3 ) + countItems( localPlayer, 4 ) + countItems( localPlayer, 5 ) + countItems( localPlayer, 73 )
									if keycount > getInventorySlots(localPlayer) or #getItems( localPlayer ) - keycount - 1 > getInventorySlots(localPlayer) / 2 then
										outputChatBox("You have too much stuff in your inventory.")
									else
										triggerServerEvent( "destroyItem", localPlayer, itemSlot )
									end
								else
									triggerServerEvent( "destroyItem", localPlayer, itemSlot )
								end
							end
						end
						hoverItemSlot = false
						clickItemSlot = false
						clickDown = false
					end
				elseif hoverWorldItem or clickWorldItem then
					if state == "down" then
						if getElementData( hoverWorldItem, "itemID" ) == 81 then
							triggerServerEvent( "openFreakinInventory", getLocalPlayer(), hoverWorldItem, cursorX, cursorY )
						else
							clickDown = getTickCount( )
							clickWorldItem = hoverWorldItem
							setElementAlpha( clickWorldItem, 127 )
						end
					elseif state == "up" and clickWorldItem then
						setElementAlpha( clickWorldItem, 255 )

						if getTickCount( ) - clickDown < 200 then
							pickupItem( "left", "down", clickWorldItem )
						else
							if isCursorOverInventory then
								pickupItem( "left", "down", clickWorldItem )
							else
								-- Drag&Drop, bitches
								if getDistanceBetweenPoints3D( worldX, worldY, worldZ, getElementPosition( localPlayer ) ) < 10 then
									if hoverElement == nil then
										triggerServerEvent( "moveItem", localPlayer, clickWorldItem, worldX, worldY, worldZ )
									elseif hoverElement then
										triggerServerEvent( "moveWorldItemToElement", localPlayer, clickWorldItem, hoverElement )
									end
								end
							end
						end
						
						clickWorldItem = false
						cursorDown = false
					end
				elseif isCursorOverInventory and hoverAction and state == "down" then
					if show then
						if activeTab == hoverAction then
							show = false
							showCursor( false )
							exports["realism-system"]:showSpeedo()
						else
							activeTab = hoverAction
						end
					else
						activeTab = hoverAction
						show = true
					end
					inventory = false
				end
			elseif button == "right" then
				if clickItemSlot then
					clickItemSlot = false
					clickDown = false
				end
				if clickWorldItem then
					setElementAlpha( clickWorldItem, 255 )
					clickWorldItem = false
					clickDown = false
				end
				if state == "up" and hoverWorldItem then
					if getElementData( hoverWorldItem, "itemID" ) == 81 then -- Fridge
						triggerServerEvent( "openFreakinInventory", getLocalPlayer(), hoverWorldItem, cursorX, cursorY )
					elseif getElementData( hoverWorldItem, "itemID" ) == 54 then -- Ghettoblaster
						item = hoverWorldItem
						ax, ay = cursorX, cursorY
						showItemMenu( )
					end
				end
			end
		end
	end
)

bindKey( "i", "down",
	function( )
		if show then
			show = false
			showCursor( false )
			exports["realism-system"]:showSpeedo()
		elseif not getElementData(localPlayer, "adminjailed") and not getElementData(localPlayer, "pd.jailstation") then
			show = true
			showCursor( true )
			exports["realism-system"]:hideSpeedo()
		else
			outputChatBox("You can't access your inventory in jail", 255, 0, 0)
		end
	end
)

addEventHandler( "onClientElementDataChange", localPlayer,
	function( name )
		if show and activeTab == 3 and name:sub( 1, 8 ) == "ACweapon" then
			inventory = getWeapons( )
		end
	end
)

addEvent( "finishItemDrop", true )
addEventHandler("finishItemDrop", getLocalPlayer(),
	function( )
		waitingForItemDrop = false
		inventory = false
	end
)

--

function hideNewInventory( )
	if show then
		show = false
		showCursor( false )
		exports["realism-system"]:showSpeedo()
	end
end