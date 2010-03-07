blackMales = {[0] = true, [7] = true, [14] = true, [15] = true, [16] = true, [17] = true, [18] = true, [20] = true, [21] = true, [22] = true, [24] = true, [25] = true, [28] = true, [35] = true, [36] = true, [50] = true, [51] = true, [66] = true, [67] = true, [78] = true, [79] = true, [80] = true, [83] = true, [84] = true, [102] = true, [103] = true, [104] = true, [105] = true, [106] = true, [107] = true, [134] = true, [136] = true, [142] = true, [143] = true, [144] = true, [156] = true, [163] = true, [166] = true, [168] = true, [176] = true, [180] = true, [182] = true, [183] = true, [185] = true, [220] = true, [221] = true, [222] = true, [249] = true, [253] = true, [260] = true, [262] = true }
whiteMales = {[23] = true, [26] = true, [27] = true, [29] = true, [30] = true, [32] = true, [33] = true, [34] = true, [35] = true, [36] = true, [37] = true, [38] = true, [43] = true, [44] = true, [45] = true, [46] = true, [47] = true, [48] = true, [50] = true, [51] = true, [52] = true, [53] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [68] = true, [70] = true, [72] = true, [73] = true, [78] = true, [81] = true, [82] = true, [94] = true, [95] = true, [96] = true, [97] = true, [98] = true, [99] = true, [100] = true, [101] = true, [108] = true, [109] = true, [110] = true, [111] = true, [112] = true, [113] = true, [114] = true, [115] = true, [116] = true, [120] = true, [121] = true, [122] = true, [124] = true, [125] = true, [126] = true, [127] = true, [128] = true, [132] = true, [133] = true, [135] = true, [137] = true, [146] = true, [147] = true, [153] = true, [154] = true, [155] = true, [158] = true, [159] = true, [160] = true, [161] = true, [162] = true, [164] = true, [165] = true, [170] = true, [171] = true, [173] = true, [174] = true, [175] = true, [177] = true, [179] = true, [181] = true, [184] = true, [186] = true, [187] = true, [188] = true, [189] = true, [200] = true, [202] = true, [204] = true, [206] = true, [209] = true, [212] = true, [213] = true, [217] = true, [223] = true, [230] = true, [234] = true, [235] = true, [236] = true, [240] = true, [241] = true, [242] = true, [247] = true, [248] = true, [250] = true, [252] = true, [254] = true, [255] = true, [258] = true, [259] = true, [261] = true, [264] = true }
asianMales = {[49] = true, [57] = true, [58] = true, [59] = true, [60] = true, [117] = true, [118] = true, [120] = true, [121] = true, [122] = true, [123] = true, [170] = true, [186] = true, [187] = true, [203] = true, [210] = true, [227] = true, [228] = true, [229] = true}
blackFemales = {[9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [40] = true, [41] = true, [63] = true, [64] = true, [69] = true, [76] = true, [91] = true, [139] = true, [148] = true, [190] = true, [195] = true, [207] = true, [215] = true, [218] = true, [219] = true, [238] = true, [243] = true, [244] = true, [245] = true, [256] = true }
whiteFemales = {[12] = true, [31] = true, [38] = true, [39] = true, [40] = true, [41] = true, [53] = true, [54] = true, [55] = true, [56] = true, [64] = true, [75] = true, [77] = true, [85] = true, [86] = true, [87] = true, [88] = true, [89] = true, [90] = true, [91] = true, [92] = true, [93] = true, [129] = true, [130] = true, [131] = true, [138] = true, [140] = true, [145] = true, [150] = true, [151] = true, [152] = true, [157] = true, [172] = true, [178] = true, [192] = true, [193] = true, [194] = true, [196] = true, [197] = true, [198] = true, [199] = true, [201] = true, [205] = true, [211] = true, [214] = true, [216] = true, [224] = true, [225] = true, [226] = true, [231] = true, [232] = true, [233] = true, [237] = true, [243] = true, [246] = true, [251] = true, [257] = true, [263] = true }
asianFemales = {[38] = true, [53] = true, [54] = true, [55] = true, [56] = true, [88] = true, [141] = true, [169] = true, [178] = true, [224] = true, [225] = true, [226] = true, [263] = true}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}

function removeAnimation(player)
	exports.global:removeAnimation(player)
end

function giveHealth(player, health)
	setElementHealth( player, math.min( 100, getElementHealth( player ) + health ) )
end

local shields = { }
local presents = { 1, 7, 8, 15, 11, 12, 19, 26, 59, 71 }

-- callbacks
function useItem(itemSlot, additional)
	local items = getItems(source)
	local itemID = items[itemSlot][1]
	local itemValue = items[itemSlot][2]
	local itemName = getItemName( itemID, itemValue )
	if isPedDead(source) or getElementData(source, "injuriedanimation") then return end
	if itemID then
		if (itemID==1) then -- haggis
			setElementHealth(source, 100)
			exports.global:sendLocalMeAction(source, "eats a plump haggis.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==3) then -- car key
			local veh = getPedOccupiedVehicle(source)
			if veh and getElementData(veh, "dbid") == itemValue then
				triggerEvent("lockUnlockInsideVehicle", source, veh)
			else
				-- unlock nearby cars
				local value = exports.pool:getElement( "vehicle", itemValue )
				if value then
					local vx, vy, vz = getElementPosition(value)
					local x, y, z = getElementPosition(source)
						
					if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 30 then -- car found
						triggerEvent("lockUnlockOutsideVehicle", source, value)
					else
						outputChatBox("You are too far from the vehicle.", source, 255, 194, 14)
					end
				else
					outputChatBox("Invalid Vehicle.", source, 255, 194, 14)
				end
			end
		elseif (itemID==4) or (itemID==5) then -- house key or business key
			local itemValue = tonumber(itemValue)
			local found = nil
			local elevatorres = getResourceRootElement(getResourceFromName("elevator-system"))
			
			local x, y, z = getElementPosition(source)
			local colSphere = createColSphere(x, y, z, 5)
			
			for key, value in ipairs(getElementsWithinColShape(colSphere, "pickup")) do
				local dbid = getElementData(value, "dbid")
				if dbid == itemValue then -- house found
					found = value
					break
				elseif getElementData( value, "other" ) and getElementParent( getElementParent( value ) ) == elevatorres then
					-- it's an elevator
					if getElementDimension( value ) == itemValue then
						found = value
						break
					elseif getElementDimension( getElementData( value, "other" ) ) == itemValue then
						found = value
						break
					end
				end
			end
			destroyElement(colSphere)
			
			if not found then
				outputChatBox("You are too far from the door.", source, 255, 194, 14)
			else
				local locked = tonumber(getElementData(found, "locked"))
				
				
				if not locked then locked = 1 end
				
				locked = 1 - locked
				
				mysql_free_result( mysql_query(handler, "UPDATE interiors SET locked='" .. locked .. "' WHERE id='" .. itemValue .. "' LIMIT 1") )
				
				if locked == 0 then
					exports.global:sendLocalMeAction(source, "puts the key in the door to unlock it.")
				else
					exports.global:sendLocalMeAction(source, "puts the key in the door to lock it.")
				end
				
				setElementData(found, "locked", locked, false)
				for key, value in ipairs(getElementsByType("pickup")) do
					if (value~=found) then
						local dbid = getElementData(value, "dbid")
						if dbid == itemValue then
							setElementData(value, "locked", locked, false)
							break
						end
					end
				end
				
			end
		elseif (itemID==73) then -- elevator remote
			local itemValue = tonumber(itemValue)
			local found = nil
			for key, value in ipairs( getElementsByType( "pickup", getResourceRootElement( getResourceFromName( "elevator-system" ) ) ) ) do
				local vx, vy, vz = getElementPosition(value)
				local x, y, z = getElementPosition(source)
				
				if getDistanceBetweenPoints3D(x, y, z, vx, vy, vz) <= 5 then
					local dbid = getElementData(value, "dbid")
					if dbid == itemValue then -- elevator found
						found = value
						break
					end
				end
			end
			
			if not found then
				outputChatBox("You are too far from the door.", source, 255, 194, 14)
			else
				triggerEvent( "toggleCarTeleportMode", found, source )
			end
		elseif (itemID==8) then -- sandwich
			giveHealth(source, 50)
			exports.global:applyAnimation(source, "food", "eat_burger", 4000, false, true, true)
			toggleAllControls(source, true, true, true)
			exports.global:sendLocalMeAction(source, "eats a sandwich.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==9) then -- sprunk
			giveHealth(source, 30)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", 4000, false, true, true)
			toggleAllControls(source, true, true, true)
			exports.global:sendLocalMeAction(source, "drinks a sprunk.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==10) then -- red dice
			exports.global:sendLocalText(source, " *((Dice)) " .. getPlayerName(source):gsub("_", " ") .. " rolls a dice and gets " .. math.random( 1, 6 ) ..".", 255, 51, 102)
		elseif (itemID==11) then -- taco
			giveHealth(source, 10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "eats a taco.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==12) then -- cheeseburger
			giveHealth(source, 10)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", 4000, false, true, true)
			setTimer(removeAnimation, 4000, 1, source)
			exports.global:sendLocalMeAction(source, "eats a cheeseburger.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==13) then -- donut
			setElementHealth(source, 100)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "eats a donut.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==14) then -- cookie
			giveHealth(source, 80)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "eats a cookie.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==15) then -- water
			giveHealth(source, 90)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "drinks a bottle of water.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==16) then -- clothes
			local result = mysql_query(handler, "SELECT gender,skincolor FROM characters WHERE id='" .. getElementData(source, "dbid") .. "' LIMIT 1")
			local gender = tonumber(mysql_result(result,1,1))
			local race = tonumber(mysql_result(result,1,2))
			mysql_free_result(result)
			
			local skin = tonumber(itemValue)
			if fittingskins[gender] and fittingskins[gender][race] and fittingskins[gender][race][skin] then
				local vehicle, veholdstate = getPedOccupiedVehicle ( source ), nil
				if vehicle then
					veholdstate = getVehicleEngineState ( vehicle )		
				end
				setElementModel(source, skin)
				mysql_free_result( mysql_query( handler, "UPDATE characters SET skin = " .. skin .. " WHERE id = " .. getElementData( source, "dbid" ) ) )
				if setElementData(source, "casualskin", skin, false) then
					mysql_free_result( mysql_query( handler, "UPDATE characters SET casualskin = " .. skin .. " WHERE id = " .. getElementData(source, "dbid") ) )
				end
				exports.global:sendLocalMeAction(source, "changes their clothes.")
				if vehicle then
					setTimer(setVehicleEngineState, 200, 1, vehicle, veholdstate)
				end
			else
				outputChatBox("These clothes do not fit you.", source, 255, 0, 0)
			end
		elseif (itemID==17) then -- watch
			exports.global:sendLocalMeAction(source, "looks at their watch.")
			outputChatBox("The time is " .. string.format("%02d:%02d", getTime()) .. ".", source, 255, 194, 14)
			exports.global:applyAnimation(source, "COP_AMBIENT", "Coplook_watch", 4000, false, true, true)
		elseif (itemID==20) then -- STANDARD FIGHTING
			setPedFightingStyle(source, 4)
			outputChatBox("You read a book on how to do Standard Fighting.", source, 255, 194, 14)
		elseif (itemID==21) then -- BOXING
			setPedFightingStyle(source, 5)
			outputChatBox("You read a book on how to do Boxing.", source, 255, 194, 14)
			mysql_free_result( mysql_query( handler, "UPDATE characters SET fightstyle = 5 WHERE id = " .. getElementData( source, "dbid" ) ) )
		elseif (itemID==22) then -- KUNG FU
			setPedFightingStyle(source, 6)
			outputChatBox("You read a book on how to do Kung Fu.", source, 255, 194, 14)
			mysql_free_result( mysql_query( handler, "UPDATE characters SET fightstyle = 6 WHERE id = " .. getElementData( source, "dbid" ) ) )
		elseif (itemID==23) then -- KNEE HEAD
			setPedFightingStyle(source, 7)
			outputChatBox("You read a book on how to do Knee Head Fighting.", source, 255, 194, 14)
			mysql_free_result( mysql_query( handler, "UPDATE characters SET fightstyle = 7 WHERE id = " .. getElementData( source, "dbid" ) ) )
		elseif (itemID==24) then -- GRAB KICK
			setPedFightingStyle(source, 15)
			outputChatBox("You read a book on how to do Grab Kick Fighting.", source, 255, 194, 14)
			mysql_free_result( mysql_query( handler, "UPDATE characters SET fightstyle = 15 WHERE id = " .. getElementData( source, "dbid" ) ) )
		elseif (itemID==25) then -- ELBOWS
			setPedFightingStyle(source, 16)
			outputChatBox("You read a book on how to do Elbow Fighting.", source, 255, 194, 14)
			mysql_free_result( mysql_query( handler, "UPDATE characters SET fightstyle = 16 WHERE id = " .. getElementData( source, "dbid" ) ) )
		elseif (itemID==26) then -- GASMASK
			local gasmask = getElementData(source, "gasmask")
			
			if not (gasmask) or (gasmask==0) then
				exports.global:sendLocalMeAction(source, "slips a black gas mask over their face.")
				
				-- can't see their name
				local fixedName =  "Unknown Person (Gas Mask)"
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "gasmask", 1, true)
			elseif (gasmask==1) then
				exports.global:sendLocalMeAction(source, "slips a black gas mask off their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local name = string.gsub(getPlayerName(source), "_", " ")
				setPlayerNametagText(source, tostring(name))

				removeElementData(source, "gasmask")
			end
		elseif (itemID==27) then -- FLASHBANG
			takeItemFromSlot(source, itemSlot)
			
			local obj = createObject(343, unpack(additional))
			exports.pool:allocateElement(obj)
			setTimer(explodeFlash, math.random(500, 600), 1, obj)
			exports.global:sendLocalMeAction(source, "throws a flashbang.")
		elseif (itemID==28) then -- GLOWSTICK
			takeItemFromSlot(source, itemSlot)
			
			local x, y, groundz = unpack(additional)
			local marker = createMarker(x, y, groundz, "corona", 1, 0, 255, 0, 150)
			exports.pool:allocateElement(marker)
			exports.global:sendLocalMeAction(source, "drops a glowstick.")
			setTimer(destroyElement, 600000, 1, marker)
		elseif (itemID==29) then -- RAM
			if getElementData(source, "duty") == 1 then
				local found, id = nil
				local distance = 99999
				for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
					local dbid = getElementData(value, "dbid")
					local vx, vy, vz = getElementPosition(value)
					local x, y, z = getElementPosition(source)
					
					local dist = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)
					if (dist<=5) then -- house found
						if (dist<distance) then
							found = value
							id = dbid
							distance = dist
						end
					end
				end
				
				if not (found) then
					outputChatBox("You are not near a door.", source, 255, 194, 14)
				else
					local locked = getElementData(found, "locked")
					
					if (locked==1) then
						setElementData(found, "locked", 0, false)
						local query = mysql_query(handler, "UPDATE interiors SET locked='0' WHERE id='" .. id .. "' LIMIT 1")
						mysql_free_result(query)
						exports.global:sendLocalMeAction(source, "swings the ram into the door, opening it.")
						
						for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
							local dbid = getElementData(value, "dbid")
							if (dbid==id) and (value~=found) then
								setElementData(value, "locked", 0, false)
							end
						end
					else
						outputChatBox("That door is not locked.", source, 255, 0, 0)
					end
				end
			else
				outputChatBox("You are not on SWAT duty.", source, 255, 0, 0)
			end
		elseif (itemID>=34 and itemID<=44) then -- DRUGS
			takeItemFromSlot(source, itemSlot)
			
			if getPedOccupiedVehicle(source) and ( itemID == 38 or itemID == 42 ) then
				outputChatBox("You take some " .. itemName .. ", but nothing happens...", source, 255, 0, 0)
			else
				exports.global:sendLocalMeAction(source, "takes some " .. itemName .. ".")
			end
		elseif (itemID==49) then
			triggerEvent( "fish", source )
		elseif (itemID==50) then -- highway code book
			local bookTitle = "The Los Santos Highway Code"
			local bookName = "LSHighwayCode"
			exports.global:sendLocalMeAction(source, "reads ".. bookTitle ..".")
			triggerClientEvent( source, "showBook", source, bookName, bookTitle )
		elseif (itemID==51) then -- chemistry book
			local bookTitle = "Chemistry 101"
			local bookName = "Chemistry101"
			exports.global:sendLocalMeAction(source, "reads ".. bookTitle ..".")
			triggerClientEvent( source, "showBook", source, bookName, bookTitle )
		elseif (itemID==52) then -- PD manual book
			local bookTitle = "The Police Officer's Manual"
			local bookName = "PDmanual"
			exports.global:sendLocalMeAction(source, "reads ".. bookTitle ..".")
			triggerClientEvent( source, "showBook", source, bookName, bookTitle )
		elseif (itemID==54) then -- GHETTOBLASTER
			exports.global:sendLocalMeAction(source, "places a ghettoblaster on the ground.")
			local x, y, z = unpack(additional)
			
			triggerEvent("dropItem", source, itemSlot, x, y, z+0.3)
		elseif (itemID==55) then -- Stevie's business card
			exports.global:sendLocalMeAction(source, "looks at a piece of paper.")
			outputChatBox("The card reads: 'Steven Pullman - L.V. Freight Depot, Tel: 12555'", source, 255, 51, 102)
		elseif (itemID==56) then -- MASK
			local mask = getElementData(source, "mask")
			
			if not (mask) or (mask==0) then
				exports.global:sendLocalMeAction(source, "slips a mask over their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local fixedName = "Unknown Person (Mask)"
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "mask", 1, false)
			elseif (mask==1) then
				exports.global:sendLocalMeAction(source, "slips a mask off their face.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local name = string.gsub(getPlayerName(source), "_", " ")
				setPlayerNametagText(source, tostring(name))

				setElementData(source, "mask", 0, false)
			end
		elseif (itemID==57) then -- FUEL CAN
			local nearbyVehicles = exports.global:getNearbyElements(source, "vehicle")
			
			if #nearbyVehicles < 1 then return end
			
			local found = nil
			local shortest = 6
			local x, y, z = getElementPosition(source)
			for i, veh in ipairs(nearbyVehicles) do
				local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
				if shortest > distanceToVehicle then
					shortest = distanceToVehicle
					found = veh
				end
			end
			
			if found then
				triggerEvent("fillFuelTankVehicle", source, found, itemValue)
			else
				outputChatBox("You are too far from a vehicle.", source, 255, 194, 14)
			end
		elseif (itemID==58) then
			takeItemFromSlot(source, itemSlot)
			exports.global:sendLocalMeAction(source, "drinks some good Ziebrand Beer.")
			setElementHealth(source,getElementHealth(source)-5)
		elseif (itemID==59) then -- MUDKIP
			takeItemFromSlot(source, itemSlot)
			exports.global:sendLocalMeAction(source, "eats a mudkip.")
			killPed(source)
		elseif (itemID==60) then
			local x,y,z = getElementPosition(source)
			local rz = getPedRotation(source)
			local dimension = getElementDimension(source)
			local retval = call(getResourceFromName("interior-system"), "addSafeAtPosition", source, x,y,z, rz) --0 no error, 1 safe already exists, 2 player does not own interior
			if (retval == 0) then
				exports.global:sendLocalMeAction(source, "Places a safe.")
				takeItemFromSlot(source, itemSlot)
			elseif (retval == 2) then
				outputChatBox("You are not inside an interior.", source, 255, 0, 0)
			elseif (retval == 3) then
				outputChatBox("You need to own the interior you are placing the safe in!", source, 255, 0, 0)
			end
		elseif (itemID==62) then
			takeItemFromSlot(source, itemSlot)
			exports.global:sendLocalMeAction(source, "drinks some pure Bastradov Vodka.")
			setElementHealth(source,getElementHealth(source)-10)
		elseif (itemID==63) then
			takeItemFromSlot(source, itemSlot)
			exports.global:sendLocalMeAction(source, "drinks some Scottish Whiskey.")
			setElementHealth(source,getElementHealth(source)-10)
		elseif (itemID==64) then -- PD Badge
			if(getElementData(source,"PDbadge")==1)then
				removeElementData(source,"PDbadge")
				exports.global:sendLocalMeAction(source, "removes a Police Badge.")
			else
				if(getElementData(source,"ESbadge")==1)then
					removeElementData(source,"ESbadge")
					exports.global:sendLocalMeAction(source, "removes an Emergency Services ID.")
				end
				if(getElementData(source,"GOVbadge")==1)then
					removeElementData(source,"GOVbadge")
					exports.global:sendLocalMeAction(source, "removes a Government Badge.")
				end
				if(getElementData(source,"SANbadge")==1)then
					removeElementData(source,"SANbadge")
					exports.global:sendLocalMeAction(source, "removes a SAN ID.")
				end
				setElementData(source,"PDbadge", 1, false)
				exports.global:sendLocalMeAction(source, "puts on a Police Badge.")
			end
			exports.global:updateNametagColor(source)
		elseif (itemID==65) then -- ES ID Card
			if(getElementData(source,"ESbadge")==1)then
				removeElementData(source,"ESbadge")
				exports.global:sendLocalMeAction(source, "removes an Emergency Services ID.")			
			else
				if(getElementData(source,"PDbadge")==1)then
					removeElementData(source,"PDbadge")
					exports.global:sendLocalMeAction(source, "removes a Police Badge.")
				end
				if(getElementData(source,"GOVbadge")==1)then
					removeElementData(source,"GOVbadge")
					exports.global:sendLocalMeAction(source, "removes a Government Badge.")
				end
				if(getElementData(source,"SANbadge")==1)then
					removeElementData(source,"SANbadge")
					exports.global:sendLocalMeAction(source, "removes a SAN ID.")
				end
				setElementData(source,"ESbadge", 1, false)
				exports.global:sendLocalMeAction(source, "puts on an Emergency Services ID.")
			end
			exports.global:updateNametagColor(source)
		elseif (itemID==69) then -- Dictionary
			local learned = call(getResourceFromName("language-system"), "learnLanguage", source, itemValue, true)
			local lang = call(getResourceFromName("language-system"), "getLanguageName", itemValue)
			
			if (learned) then
				takeItem(source, itemID, itemValue)
				outputChatBox("You have learnt basic " .. lang .. ", Press F6 to manage your languages.", source, 0, 255, 0)
			end
		elseif (itemID==72) then -- Note
			exports.global:sendLocalMeAction(source, "reads a note.")
		elseif (itemID==74) then
			takeItemFromSlot(source, itemSlot)
			local x, y, z = getElementPosition(source)
			createExplosion( x, y, z, 10, source )
			createExplosion( x, y, z, 10, source )
		elseif (itemID==75) then
			exports.global:sendLocalMeAction(source, "pushes some kind of red button which reads 'do not push'.")
			local px, py, pz = getElementPosition(source)
			for k, v in pairs( getElementsByType( "object", getResourceRootElement( ) ) ) do
				if isElement( v ) and getElementData( v, "itemID" ) == 74 and getElementData( v, "itemValue" ) == itemValue then
					local x, y, z = getElementPosition( v )
					if getDistanceBetweenPoints3D( x, y, z, px, py, pz ) < 200 then
						mysql_free_result( mysql_query( handler, "DELETE FROM worlditems WHERE id = " .. getElementData( v, "id" ) ) )
						createExplosion( x, y, z, 10, source )
						createExplosion( x, y, z, 10, source )
						destroyElement( v )
					end
				end
			end
			
			for k, v in pairs( exports.global:getNearbyElements(source, "vehicle", 200) ) do
				if hasItem( v, 74, itemValue ) then
					blowVehicle( v )
					
					while hasItem( v, 74 ) do
						takeItem( v, 74 )
					end
				end
			end
			
			for k, v in pairs( exports.global:getNearbyElements(source, "player", 200) ) do
				if hasItem( v, 74, itemValue ) then
					local x, y, z = getElementPosition( v )
					createExplosion( x, y, z, 10, source )
					createExplosion( x, y, z, 10, source )
					
					while hasItem( v, 74 ) do
						takeItem( v, 74 )
					end
				end
			end
		elseif (itemID==76) then -- SHIELD
			if (shields[source]) then -- Already using the shield
				destroyElement(shields[source])
				shields[source] = nil
			else
				local x, y, z = getElementPosition(source)
				local rot = getPedRotation(source)
				
				x = x + math.sin(math.rad(rot)) * 1.5
				y = y + math.cos(math.rad(rot)) * 1.5
				
				local object = createObject(1631, x, y, z)
				attachElements(object, source, 0, 1, 0)
				shields[source] = object
			end
		elseif (itemID==77) then -- Card Deck
			local cards = { "Ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King" }
			local number = math.random( 1, #cards )
			exports.global:sendLocalText(source, " *((Cards)) " .. getPlayerName(source):gsub("_", " ") .. " draws a card and gets a" .. ( number == 1 and "n" or "" ) .. " " .. cards[number] ..".", 255, 51, 102)
		elseif (itemID==79) then -- Porn tape
			exports.global:applyAnimation( source, "PAULNMAC", "wank_loop", -1, true, false, false)
		elseif (itemID==80) then -- Generic Item
			showItem(itemName)
		elseif (itemID==83) then -- Coffee
			giveHealth(source, 40)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "drinks a cup of coffee.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==86) then -- SAN ID
			if(getElementData(source,"SANbadge")==1)then
				removeElementData(source,"SANbadge")
				exports.global:sendLocalMeAction(source, "removes a SAN ID.")			
			else
				if(getElementData(source,"PDbadge")==1)then
					removeElementData(source,"PDbadge")
					exports.global:sendLocalMeAction(source, "removes a Police Badge.")
				end
				if(getElementData(source,"ESbadge")==1)then
					removeElementData(source,"ESbadge")
					exports.global:sendLocalMeAction(source, "removes an Emergency Services ID.")
				end
				if(getElementData(source,"GOVbadge")==1)then
					removeElementData(source,"GOVbadge")
					exports.global:sendLocalMeAction(source, "removes a Government Badge.")
				end
				setElementData(source,"SANbadge", 1, false)
				exports.global:sendLocalMeAction(source, "puts on a SAN ID.")
			end
			exports.global:updateNametagColor(source)
		elseif (itemID==87) then -- Gov badge
			if(getElementData(source,"GOVbadge")==1)then
				removeElementData(source,"GOVbadge")
				exports.global:sendLocalMeAction(source, "removes a Government Badge.")			
			else
				if(getElementData(source,"PDbadge")==1)then
					removeElementData(source,"PDbadge")
					exports.global:sendLocalMeAction(source, "removes a Police Badge.")
				end
				if(getElementData(source,"ESbadge")==1)then
					removeElementData(source,"ESbadge")
					exports.global:sendLocalMeAction(source, "removes an Emergency Services ID.")
				end
				if(getElementData(source,"SANbadge")==1)then
					removeElementData(source,"SANbadge")
					exports.global:sendLocalMeAction(source, "removes a SAN ID.")
				end
				setElementData(source,"GOVbadge", 1, false)
				exports.global:sendLocalMeAction(source, "puts on a Government Badge.")
			end
			exports.global:updateNametagColor(source)
		elseif (itemID==88) then -- earpiece
			outputChatBox("You can use this earpiece with an radio.", source, 255, 194, 14)
		elseif (itemID==89) then -- Generic Food
			giveHealth(source, tonumber(getItemValue(itemID, itemValue)))
			exports.global:applyAnimation(source, "food", "eat_burger", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "eats a " .. itemName .. ".")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==90) then -- Helmet
			local mask = getElementData(source, "helmet")
			
			if not (mask) or (mask==0) then
				exports.global:sendLocalMeAction(source, "puts a helmet over their head.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local fixedName = "Unknown Person (Helmet)"
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "helmet", 1, false)
			elseif (mask==1) then
				exports.global:sendLocalMeAction(source, "puts a helmet off their head.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local name = string.gsub(getPlayerName(source), "_", " ")
				setPlayerNametagText(source, tostring(name))

				setElementData(source, "helmet", 0, false)
			end
		elseif (itemID==91) then
			takeItemFromSlot(source, itemSlot)
			exports.global:sendLocalMeAction(source, "drinks some good Eggnog.")
			setElementHealth(source, 100)
		elseif (itemID==92) then
			setElementHealth(source, 100)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "eats some Turkey.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==93) then
			setElementHealth(source, 100)
			exports.global:applyAnimation(source, "FOOD", "EAT_Burger", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "eats some Christmas Pudding.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==94) then
			call(getResourceFromName("achievement-system"), "givePlayerAchievement", source, 47)
			local id = math.random(1, 10)
			local prizeID = presents[id]
			takeItemFromSlot(source, itemSlot)
			giveItem(source, prizeID, 1)
			exports.global:sendLocalMeAction(source, "opens a Christmas Present")
		elseif (itemID==95) then -- Generic Drink
			giveHealth(source, tonumber(getItemValue(itemID, itemValue)))
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", 4000, false, true, true)
			exports.global:sendLocalMeAction(source, "drinks some " .. itemName .. ".")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==96) then -- PDA
			exports.global:sendLocalMeAction(source, "turns their " .. ( itemValue == 1 and "PDA" or itemValue ) .. " on.")
			triggerClientEvent(source, "useCompItem", source)
		elseif (itemID==97) then -- LSES Procedures Manual (book)
			local bookTitle = "LSES Procedure Manual"
			local bookName = "LSESProcedureManual"
			exports.global:sendLocalMeAction(source, "reads ".. bookTitle ..".")
			triggerClientEvent( source, "showBook", source, bookName, bookTitle )
		elseif (itemID==98) then -- Garage Remote
			local id = tonumber( itemValue )
			if id and id >= 0 and id <= 49 then
				setGarageOpen(itemValue, not isGarageOpen(itemValue))
				
				local garages = {}
				for i = 0, 49 do
					garages[i] = isGarageOpen(i)
				end
				mysql_free_result( mysql_query(handler, "UPDATE settings SET value = '" .. mysql_escape_string( handler, toJSON( garages ) ) .. "' WHERE name = 'garagestates'" ) )
			end
		elseif (itemID==99) then --[ADDED: 2/22/10 by herbjr] tray
			giveHealth(source, 50)
			exports.global:applyAnimation(source, "food", "eat_burger", 4000, false, true, true)
			toggleAllControls(source, true, true, true)
			exports.global:sendLocalMeAction(source, "eats the food from the tray.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==100) then --[ADDED: 2/22/10 by herbjr] milk
			giveHealth(source, 30)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", 4000, false, true, true)
			toggleAllControls(source, true, true, true)
			exports.global:sendLocalMeAction(source, "drinks a small carton of milk.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==101) then --[ADDED: 2/22/10 by herbjr] juice
			giveHealth(source, 30)
			exports.global:applyAnimation(source, "VENDING", "VEND_Drink_P", 4000, false, true, true)
			toggleAllControls(source, true, true, true)
			exports.global:sendLocalMeAction(source, "drinks a small carton of juice.")
			takeItemFromSlot(source, itemSlot)
		elseif (itemID==102) then --[ADDED: 2/23/10 by herbjr] Cabbage (Asked for by Misha)
			giveHealth(source, 15)
			exports.global:applyAnimation(source, "food", "eat_burger", 4000, false, true, true)
			toggleAllControls(source, true, true, true)
			exports.global:sendLocalMeAction(source, "eats a head of Cabbage.")
			takeItemFromSlot(source, itemSlot)
		else
			outputChatBox("Error 800001 - Report on http://bugs.valhallagaming.net", source, 255, 0, 0)
		end
	end
end
addEvent("useItem", true)
addEventHandler("useItem", getRootElement(), useItem)
addCommandHandler("useitem",
	function(thePlayer, commandName, itemID, ...)
		if tonumber( itemID ) then
			local args = {...}
			local itemValue
			if #args > 0 then
				itemValue = table.concat(args, " ")
				itemValue = tonumber(itemValue) or itemValue
			end
			
			local has, slot = hasItem(thePlayer, tonumber( itemID ), itemValue)
			if has then
				triggerEvent("useItem", thePlayer, slot)
			end
		end
	end
)

function explodeFlash(obj, x, y, z)
	local players = exports.global:getNearbyElements(obj, "player")
	
	destroyElement(obj)
	for key, value in ipairs(players) do
		local gasmask = getElementData(value, "gasmask")
		
		if (not gasmask) or (gasmask==0) then
			playSoundFrontEnd(value, 47)
			fadeCamera(value, false, 0.5, 255, 255, 255)
			setTimer(cancelEffect, 5000, 1, value)
			setTimer(playSoundFrontEnd, 1000, 1, value, 48)
		end
	end
end

function cancelEffect(thePlayer)
	fadeCamera(thePlayer, true, 6.0)
end

tags = {1524, 1525, 1526, 1527, 1528, 1529, 1530, 1531 }

function destroyGlowStick(marker)
	destroyElement(marker)
end

function destroyItem(itemID)
	if isPedDead(source) or getElementData(source, "injuriedanimation") then return end
	local itemName = ""
	if itemID and itemID > 0 then
		local itemSlot = itemID
		local item = getItems( source )[itemSlot]
		if item then
			local itemID = item[1]
			local itemValue = item[2]
			
			if itemID == 48 and countItems( source, 48 ) == 1 then -- backpack
				local keycount = countItems( source, 3 ) + countItems( source, 4 ) + countItems( source, 5 )
				if keycount > getInventorySlots(source) or #getItems( source ) - keycount - 1 > getInventorySlots(source) / 2 then
					return
				end
			end
			
			itemName = getItemName( itemID )
			takeItemFromSlot(source, itemSlot)
			
			if itemID == 2 or itemID == 17 then
				triggerClientEvent(source, "updateHudClock", source)
			elseif tonumber(itemID) == 16 and tonumber(itemValue) == getPedSkin(source) and not exports.global:hasItem(source, 16, tonumber(itemValue)) then
				local result = mysql_query(handler, "SELECT skincolor, gender FROM characters WHERE id='" .. getElementData(source, "dbid") .. "' LIMIT 1")
				local skincolor = tonumber(mysql_result(result, 1, 1))
				local gender = tonumber(mysql_result(result, 1, 2))
				
				if (gender==0) then -- MALE
					if (skincolor==0) then -- BLACK
						setElementModel(source, 80)
					elseif (skincolor==1 or skincolor==2) then -- WHITE
						setElementModel(source, 252)
					end
				elseif (gender==1) then -- FEMALE
					if (skincolor==0) then -- BLACK
						setElementModel(source, 139)
					elseif (skincolor==1) then -- WHITE
						setElementModel(source, 138)
					elseif (skincolor==2) then -- ASIAN
						setElementModel(source, 140)
					end
				end
				mysql_free_result( mysql_query( handler, "UPDATE characters SET skin = " .. getElementModel( source ) .. " WHERE id = " .. getElementData( source, "dbid" ) ) )
				mysql_free_result(result)
			elseif tonumber(itemID) == 64 and not exports.global:hasItem(source, 64) then
				removeElementData(source,"PDbadge")
				exports.global:sendLocalMeAction(source, "removes a Police Badge.")
				exports.global:updateNametagColor(source)
			elseif  tonumber(itemID) == 65 and not exports.global:hasItem(source, 65)then
				removeElementData(source,"ESbadge")
				exports.global:sendLocalMeAction(source, "removes an Emergency Services ID.")
				exports.global:updateNametagColor(source)
			elseif  tonumber(itemID) == 86 and not hasItem(source, 86)then
				removeElementData(source,"SANbadge")
				exports.global:sendLocalMeAction(source, "removes a SAN ID.")
				exports.global:updateNametagColor(source)
			elseif tonumber(itemID) == 87 and not hasItem(source, 87) then
				removeElementData(source,"GOVbadge")
				exports.global:sendLocalMeAction(source, "removes a Government Badge.")
				exports.global:updateNametagColor(source)
			elseif tonumber(itemID) == 76 and not exports.global:hasItem(source, 76) then
				destroyElement(shields[source])
				shields[source] = nil
			elseif tonumber(itemID) == 80 then
				itemName = itemValue
			end
		end
	else
		if itemID == -100 then
			setPedArmor(source, 0)
			itemName = "Body Armor"
		else
			exports.global:takeWeapon(source, tonumber(-itemID))
			itemName = getWeaponNameFromID( -itemID )
		end
	end
	outputChatBox("You destroyed a " .. itemName .. ".", source, 255, 194, 14)
	exports.global:sendLocalMeAction(source, "destroyed a " .. itemName .. ".")
end
addEvent("destroyItem", true)
addEventHandler("destroyItem", getRootElement(), destroyItem)

weaponmodels = { [1]=331, [2]=333, [3]=326, [4]=335, [5]=336, [6]=337, [7]=338, [8]=339, [9]=341, [15]=326, [22]=346, [23]=347, [24]=348, [25]=349, [26]=350, [27]=351, [28]=352, [29]=353, [32]=372, [30]=355, [31]=356, [33]=357, [34]=358, [35]=359, [36]=360, [37]=361, [38]=362, [16]=342, [17]=343, [18]=344, [39]=363, [41]=365, [42]=366, [43]=367, [10]=321, [11]=322, [12]=323, [14]=325, [44]=368, [45]=369, [46]=371, [40]=364, [100]=373 }

function dropItem(itemID, x, y, z, ammo, keepammo)
	if isPedDead(source) or getElementData(source, "injuriedanimation") then return end
	
	local interior = getElementInterior(source)
	local dimension = getElementDimension(source)
	
	local rz2 = getPedRotation(source)
	if not ammo then
		local itemSlot = itemID
		local itemID, itemValue = unpack( getItems( source )[ itemSlot ] )
		
		if itemID == 60 then
			outputChatBox( "This Item can't be dropped.", source )
		elseif itemID == 81 and dimension == 0 then
			outputChatBox( "You need to drop this item in an interior.", source )
		else
			local insert = mysql_query(handler, "INSERT INTO worlditems SET itemid='" .. itemID .. "', itemvalue='" .. mysql_escape_string(handler, itemValue) .. "', creationdate = NOW(), x = " .. x .. ", y = " .. y .. ", z= " .. z .. ", dimension = " .. dimension .. ", interior = " .. interior .. ", rz = " .. rz2 .. ", creator=" .. getElementData(source, "dbid"))
			if insert then
				local id = mysql_insert_id(handler)
				mysql_free_result(insert)
				
				outputChatBox("You dropped a " .. getItemName( itemID, itemValue ) .. ".", source, 255, 194, 14)
				
				-- Animation
				exports.global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
				toggleAllControls( source, true, true, true )
				
				-- Create Object
				local modelid = getItemModel(tonumber(itemID))
				
				local rx, ry, rz, zoffset = getItemRotInfo(itemID)
				local obj = createObject(modelid, x, y, z + zoffset - 0.05, rx, ry, rz+rz2)
				exports.pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				if (itemID==76) then
					moveObject(obj, 200, x, y, z + zoffset, 90, 0, 0)
				else
					moveObject(obj, 200, x, y, z + zoffset)
				end
				
				setElementData(obj, "id", id, false)
				setElementData(obj, "itemID", itemID)
				setElementData(obj, "itemValue", itemValue)
				setElementData(obj, "creator", getElementData(source, "dbid"), false)
				
				takeItemFromSlot( source, itemSlot )
				
				-- Dropped his backpack
				if itemID == 48 and countItems( source, 48 ) == 0 then
					local keycount = countItems( source, 3 ) + countItems( source, 4 ) + countItems( source, 5 )
					for i = #getItems( source ), 1, -1 do
						if keycount <= 2 * getInventorySlots(source) then
							break
						elseif getItems( source )[ i ] == 3 or getItems( source )[ i ] == 4 or getItems( source )[ i ] == 5 then
							moveItem( source, obj, i )
							keycount = keycount - 1
						end
					end
					
					for i = #getItems( source ), 1, -1 do
						if #getItems( source ) - keycount <= getInventorySlots(source) then
							break
						elseif getItems( source )[ i ] ~= 3 and getItems( source )[ i ] ~= 4 and getItems( source )[ i ] ~= 5 then
							moveItem( source, obj, i )
						end
					end
				end
				
				if itemID == 2 or itemID == 17 then
					triggerClientEvent(source, "updateHudClock", source)
				-- Check if he drops his current clothes
				elseif itemID == 16 and itemValue == getPedSkin(source) and not hasItem(source, 16, itemValue) then
					local result = mysql_query(handler, "SELECT skincolor, gender FROM characters WHERE id='" .. getElementData(source, "dbid") .. "' LIMIT 1")
					local skincolor = tonumber(mysql_result(result, 1, 1))
					local gender = tonumber(mysql_result(result, 1, 2))
					
					if (gender==0) then -- MALE
						if (skincolor==0) then -- BLACK
							setElementModel(source, 80)
						elseif (skincolor==1 or skincolor==2) then -- WHITE
							setElementModel(source, 252)
						end
					elseif (gender==1) then -- FEMALE
						if (skincolor==0) then -- BLACK
							setElementModel(source, 139)
						elseif (skincolor==1) then -- WHITE
							setElementModel(source, 138)
						elseif (skincolor==2) then -- ASIAN
							setElementModel(source, 140)
						end
					end
					mysql_free_result(result)
				elseif tonumber(itemID) == 64 and not hasItem(source, 64) then
					removeElementData(source,"PDbadge")
					exports.global:sendLocalMeAction(source, "removes a Police Badge.")
					exports.global:updateNametagColor(source)
				elseif  tonumber(itemID) == 65 and not hasItem(source, 65)then
					removeElementData(source,"ESbadge")
					exports.global:sendLocalMeAction(source, "removes an Emergency Services ID.")
					exports.global:updateNametagColor(source)
				elseif  tonumber(itemID) == 86 and not hasItem(source, 86)then
					removeElementData(source,"SANbadge")
					exports.global:sendLocalMeAction(source, "removes a SAN ID.")
					exports.global:updateNametagColor(source)
				elseif tonumber(itemID) == 87 and not hasItem(source, 87) then
					removeElementData(source,"GOVbadge")
					exports.global:sendLocalMeAction(source, "removes a Government Badge.")
					exports.global:updateNametagColor(source)
				elseif tonumber(itemID)== 76 and not exports.global:hasItem(source, 76) then
					destroyElement(shields[source])
					shields[source] = nil
				end
				exports.global:sendLocalMeAction(source, "dropped a " .. getItemName( itemID, itemValue ) .. ".")
			else
				outputDebugString( mysql_error( handler ) )
			end
		end
	else
		if tonumber(getElementData(source, "duty")) > 0 then
			outputChatBox("You can't drop your weapons while being on duty.", source, 255, 0, 0)
		elseif tonumber(getElementData(source, "job")) == 4 and itemID == 41 then
			outputChatBox("You can't drop this spray can.", source, 255, 0, 0)
		else
			if ammo <= 0 then
				return
			end
			
			outputChatBox("You dropped a " .. ( getWeaponNameFromID( itemID ) or "Body Armor" ) .. ".", source, 255, 194, 14)
			
			-- Animation
			exports.global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
			toggleAllControls( source, true, true, true )
				
			if itemID == 100 then
				z = z + 0.1
				setPedArmor(source, 0)
			end
			
			local query = mysql_query(handler, "INSERT INTO worlditems SET itemid=" .. -itemID .. ", itemvalue=" .. ammo .. ", creationdate=NOW(), x=" .. x .. ", y=" .. y .. ", z=" .. z+0.1 .. ", dimension=" .. dimension .. ", interior=" .. interior .. ", rz = " .. rz2)
			if query then
				local id = mysql_insert_id(handler)
				mysql_free_result(query)
				
				exports.global:takeWeapon(source, itemID)
				if keepammo then
					exports.global:giveWeapon(source, itemID, keepammo)
				end
				
				local modelid = 2969
				-- MODEL ID
				if (itemID==100) then
					modelid = 1242
				elseif (itemID==42) then
					modelid = 2690
				else
					modelid = weaponmodels[itemID]
				end
				
				local obj = createObject(modelid, x, y, z - 0.4, 75, -10, rz2)
				exports.pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				moveObject(obj, 200, x, y, z+0.1)
				
				setElementData(obj, "id", id, false)
				setElementData(obj, "itemID", -itemID)
				setElementData(obj, "itemValue", ammo)
				
				exports.global:sendLocalMeAction(source, "dropped a " .. getItemName( -itemID ) .. ".")
			else
				outputDebugString( mysql_error( handler ) )
			end
		end
	end
	triggerClientEvent( source, "finishItemDrop", source )
end
addEvent("dropItem", true)
addEventHandler("dropItem", getRootElement(), dropItem)

local function moveItem(item, x, y, z)
	local result = mysql_query( handler, "UPDATE worlditems SET x = " .. x .. ", y = " .. y .. ", z = " .. z .. " WHERE id = " .. getElementData( item, "id" ) )
	if result then
		mysql_free_result( result )
		
		local itemID = getElementData(item, "itemID")
		if itemID > 0 then
			local rx, ry, rz, zoffset = getItemRotInfo(itemID)
			z = z + zoffset
		elseif itemID == 100 then
			z = z + 0.1
		end
		setElementPosition(item, x, y, z)
	end
end
addEvent("moveItem", true)
addEventHandler("moveItem", getRootElement(), moveItem)

function loadWorldItems(res)
	
	-- delete items too old
	local query = mysql_query( handler, "DELETE FROM worlditems WHERE DATEDIFF(NOW(), creationdate) > 7 AND itemID != 81" )
	if query then
		mysql_free_result( query )
	else
		outputDebugString( mysql_error( handler ) )
	end
	
	-- actually load items
	local result = mysql_query(handler, "SELECT id, itemid, itemvalue, x, y, z, dimension, interior, rz, creator FROM worlditems")
	for result, row in mysql_rows(result) do
		local id = tonumber(row[1])
		local itemID = tonumber(row[2])
		local itemValue = tonumber(row[3]) or row[3]
		local x = tonumber(row[4])
		local y = tonumber(row[5])
		local z = tonumber(row[6])
		local dimension = tonumber(row[7])
		local interior = tonumber(row[8])
		local rz2 = tonumber(row[9])
		local creator = tonumber(row[10])
		
		if itemID < 0 then -- weapon
			itemID = -itemID
			local modelid = 2969
			-- MODEL ID
			if itemValue == 100 then
				modelid = 1242
			elseif itemValue == 42 then
				modelid = 2690
			else
				modelid = weaponmodels[itemID]
			end
		
			local obj = createObject(modelid, x, y, z - 0.1, 75, -10, rz2)
			exports.pool:allocateElement(obj)
			setElementDimension(obj, dimension)
			setElementInterior(obj, interior)
			setElementData(obj, "id", id, false)
			setElementData(obj, "itemID", -itemID)
			setElementData(obj, "itemValue", itemValue)
			setElementData(obj, "creator", creator, false)
		else
			local modelid = getItemModel(itemID)
			
			local rx, ry, rz, zoffset = getItemRotInfo(itemID)
			local obj = createObject(modelid, x, y, z + ( zoffset or 0 ), rx, ry, rz+rz2)
			
			exports.pool:allocateElement(obj)
			setElementDimension(obj, dimension)
			setElementInterior(obj, interior)
			setElementData(obj, "id", id)
			setElementData(obj, "itemID", itemID)
			setElementData(obj, "itemValue", itemValue)
			setElementData(obj, "creator", creator, false)
		end
	end
	exports.irc:sendMessage("[SCRIPT] Loaded " .. tonumber(mysql_num_rows(result)) .. " world items.")
	mysql_free_result(result)
end
addEventHandler("onResourceStart", getResourceRootElement(), loadWorldItems)

function showItem(itemName)
	if isPedDead(source) or getElementData(source, "injuriedanimation") then return end
	exports.global:sendLocalMeAction(source, "shows everyone a " .. itemName .. ".")
end
addEvent("showItem", true)
addEventHandler("showItem", getRootElement(), showItem)

function resetAnim(thePlayer)
	exports.global:removeAnimation(thePlayer)
end

function pickupItem(object, leftammo)
	if not isElement(object) then
		return
	end
	
	local x, y, z = getElementPosition(source)
	local ox, oy, oz = getElementPosition(object)
	
	if (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<10) then	
		
		-- Inventory Tooltip
		if (getResourceFromName("tooltips-system"))then
			triggerClientEvent(source,"tooltips:showHelp",source,14)
		end
		
		-- Animation
		exports.global:applyAnimation(source, "CARRY", "liftup", 600, false, true, true)
		
		local id = getElementData(object, "id")
		
		local itemID = getElementData(object, "itemID")
		local itemValue = getElementData(object, "itemValue")
		if itemID > 0 then
			mysql_free_result( mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. id .. "'") )
			
			giveItem(source, itemID, itemValue)
			
			while #getItems(object) > 0 do
				moveItem(object, source, 1)
			end
			destroyElement(object)
		elseif itemID == -100 then
			mysql_free_result( mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. id .. "'") )
			destroyElement(object)
			
			setPedArmor(source, itemValue)
		else
			if leftammo and itemValue > leftammo then
				itemValue = itemValue - leftammo
				setElementData(object, "itemValue", itemValue)
				
				mysql_free_result( mysql_query(handler, "UPDATE worlditems SET itemvalue=" .. itemValue .. " WHERE id=" .. id) )
				
				itemValue = leftammo
			else
				mysql_free_result( mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. id .. "'") )
				destroyElement(object)
			end
			exports.global:giveWeapon(source, -itemID, itemValue, true)
		end
		outputChatBox("You picked up a " .. getItemName( itemID, itemValue ) .. ".", source, 255, 194, 14)
		exports.global:sendLocalMeAction(source, "bends over and picks up a " .. getItemName( itemID, itemValue ) .. ".")
		if itemID == 2 or itemID == 17 then
			triggerClientEvent(source, "updateHudClock", source)
		end
	else
		outputDebugString("Distance between Player and Pickup too large")
	end
end
addEvent("pickupItem", true)
addEventHandler("pickupItem", getRootElement(), pickupItem)

function breathTest(thePlayer, commandName, targetPlayer)
	if (exports.global:hasItem(thePlayer, 53)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					local alcohollevel = getElementData(targetPlayer, "alcohollevel")
					
					if not (alcohollevel) then alcohollevel = 0 end
					
					outputChatBox(targetPlayerName .. "'s Alcohol Levels: " .. alcohollevel .. ".", thePlayer, 255, 194, 15)
				end
			end
		end
	end
end
addCommandHandler("breathtest", breathTest, false, false)

function getNearbyItems(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Items:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement())) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) then
					outputChatBox("   #" .. dbid .. " by " .. ( exports['vehicle-system']:getCharacterName( getElementData(theObject, "creator") ) or "?" ) .. ": " .. ( getItemName( getElementData(theObject, "itemID") ) or "?" ) .. "(" .. getElementData(theObject, "itemID") .. ") with Value " .. tostring( getElementData(theObject, "itemValue") ), thePlayer, 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyitems", getNearbyItems, false, false)

function delItem(thePlayer, commandName, targetID)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (targetID) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local object = nil
			targetID = tonumber( targetID )
			
			for key, value in ipairs(getElementsByType("object", getResourceRootElement())) do
				local dbid = getElementData(value, "id")
				if dbid and dbid == targetID then
					object = value
					break
				end
			end
			
			if object then
				local id = getElementData(object, "id")
				local result = mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. id .. "'")
						
				if (result) then
					mysql_free_result(result)
				end
						
				outputChatBox("Item #" .. id .. " deleted.", thePlayer)
				exports.irc:sendMessage(getPlayerName(thePlayer) .. " deleted Item #" .. id .. ".")
				destroyElement(object)
			else
				outputChatBox("Invalid item ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delitem", delItem, false, false)

function getNearbyItems(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Items:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", getResourceRootElement())) do
			local dbid = getElementData(theObject, "id")
			
			if dbid then
				local x, y, z = getElementPosition(theObject)
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				
				if distance <= 10 and getElementDimension(theObject) == getElementDimension(thePlayer) and getElementInterior(theObject) == getElementInterior(thePlayer) then
					local id = getElementData(theObject, "id")
					mysql_free_result( mysql_query(handler, "DELETE FROM worlditems WHERE id='" .. id .. "'") )
					destroyElement(theObject)
					count = count + 1
				end
			end
		end
		
		outputChatBox( count .. " Items deleted.", thePlayer, 255, 126, 0)
	end
end
addCommandHandler("delnearbyitems", getNearbyItems, false, false)

function showInventoryRemote(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				triggerEvent("subscribeToInventoryChanges",thePlayer,targetPlayer)
				triggerClientEvent(thePlayer,"showInventory",thePlayer,targetPlayer, unpack(exports['saveplayer-system']:getWeapons(targetPlayer)))
			end
		end
	end
end
addCommandHandler("showinv", showInventoryRemote, false, false)

-- /issueBadge Command - A commnad for leaders of the PD and ES factions to issue a police badge or ES ID badge item to their members. This will be the only IC way badges can be created.
function givePlayerBadge(thePlayer, commandName, targetPlayer, badgeNumber )
	local theTeam = getPlayerTeam(thePlayer)
	local teamName = getTeamName(theTeam)
	
	if (teamName=="Los Santos Police Department") or (teamName=="Los Santos Emergency Services") or (teamName=="Government of Los Santos") or (teamName=="San Andreas Network") or (teamName=="Best's Towing and Recovery") then -- Are they in the PD or ES or Gov?
		local leader = getElementData(thePlayer, "factionleader")
		
		if not (tonumber(leader)==1) then -- If the player is not the leader
			outputChatBox("You must be a faction leader to issue badges.", thePlayer, 255, 0, 0) -- If they aren't leader they can't give out badges.
		else	
			if not (targetPlayer) or ( not (badgeNumber) and teamName~="San Andreas Network" ) or ( not (badgeNumber) and teamName~="Best's Towing and Recovery") then
				outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID][Badge Number]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if targetPlayer then -- is the player online?
					local targetPlayerName = targetPlayerName:gsub("_", " ")
					local logged = getElementData(targetPlayer, "loggedin")
					if (logged==0) then -- Are they logged in?
						outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
					else
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
							outputChatBox("You are too far away to issue this player a badge.", thePlayer, 255, 0, 0)
						elseif (teamName=="Los Santos Police Department") then -- If the player is a PD leader
							exports.global:giveItem(targetPlayer, 64, badgeNumber) -- Give the player the badge.
							exports.global:sendLocalMeAction(thePlayer, "issues "..targetPlayerName.." a police badge with number "..badgeNumber..".")
						elseif (teamName=="Los Santos Emergency Services") then -- If the player is a ES leader
							exports.global:giveItem(targetPlayer, 65, badgeNumber) -- Give the player the badge.
							exports.global:sendLocalMeAction(thePlayer, "issues "..targetPlayerName.." a Los Santos Emergency Service ID badge with number "..badgeNumber..".")
						elseif (teamName=="San Andreas Network") then -- If the player is a GOV leader
							exports.global:giveItem(targetPlayer, 86, getPlayerName(targetPlayer):gsub("_", " ")) -- Give the player the badge.
							exports.global:sendLocalMeAction(thePlayer, "issues "..targetPlayerName.." a SAN ID.")
						elseif (teamName=="Government of Los Santos") then -- If the player is a GOV leader
							exports.global:giveItem(targetPlayer, 87, badgeNumber) -- Give the player the badge.
							exports.global:sendLocalMeAction(thePlayer, "issues "..targetPlayerName.." a Los Santos Government badge with number "..badgeNumber..".")
						elseif (teamName=="Best's Towing and Recovery") then
							exports.global:giveItem(targetPlayer, 82, getPlayerName(targetPlayer):gsub("_", " "))
							exports.global:sendLocalMeAction(thePlayer, "issues "..targetPlayerName.." a Best's Towing and Recovery ID.")						
						end
					end
				end
			end
		end
	end
end
addCommandHandler("issuebadge", givePlayerBadge, false, false)

function issuePilotCertificate(thePlayer, commandName, targetPlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(targetPlayer)
			if targetPlayer then -- is the player online?
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					exports.global:giveItem(targetPlayer, 78, targetPlayerName) -- Give the player the certificate.
				end
			end
		end
	end
end
addCommandHandler("issuepilotcertificate", issuePilotCertificate, false, false)

function writeNote(thePlayer, commandName, ...)
	if not (...) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Text]", thePlayer, 255, 194, 14)
	elseif not hasSpaceForItem( thePlayer, 72 ) then
		outputChatBox("You can't carry more notes around.", thePlayer, 255, 0, 0)
	else
		local found, slot, itemValue = hasItem( thePlayer, 71 )
		if found then
			
			giveItem( thePlayer, 72, table.concat({...}, " ") )
			exports.global:sendLocalMeAction(thePlayer, "writes a note on a piece of paper.")
			
			if itemValue > 1 then
				updateItemValue( thePlayer, slot, itemValue - 1 )
			else
				takeItemFromSlot( thePlayer, slot )
			end
		else
			outputChatBox("You don't have any empty paper.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("writenote", writeNote, false, false)

function changeLock(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local dbid = getElementData( theVehicle, "dbid" )
			if dbid > 0 then
				exports.logs:logMessage( "[VEHICLE] " .. getPlayerName( thePlayer ) .. " changed the lock for Vehicle #" .. dbid .. " (" .. getVehicleName( theVehicle ) .. ")", 16) 
				deleteAll( 3, dbid )
				giveItem( thePlayer, 3, dbid )
				outputChatBox( "Locks for this vehicle have been changed.", thePlayer, 0, 255,0  )
			else
				outputChatBox( "This is only a temporary vehicle.", thePlayer, 255, 0, 0 )
			end
		else
			local dbid, entrance, exit, interiortype = exports['interior-system']:findProperty( thePlayer )
			if dbid > 0 then
				if interiortype == 2 then
					outputChatBox( "This is a government property.", thePlayer, 255, 0, 0 )
				else
					local itemid = interiortype == 1 and 5 or 4
					exports.logs:logMessage( "[HOUSE] " .. getPlayerName( thePlayer ) .. " changed the lock for House #" .. dbid .. " (" .. getElementData( entrance, "name" ) .. ")", 16) 
					deleteAll( 4, dbid )
					deleteAll( 5, dbid )
					giveItem( thePlayer, itemid, dbid )
					outputChatBox( "Locks for this house have been changed.", thePlayer, 0, 255,0  )
				end
			else
				outputChatBox( "You need to be in an interior or a vehicle to change locks.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler("changelock", changeLock, false, false)