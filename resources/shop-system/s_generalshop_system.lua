mysql = exports.mysql

-- respawn dead npcs after two minute
addEventHandler("onPedWasted", getResourceRootElement(),
	function()
		setTimer(
			function( source )
				local x,y,z = getElementPosition(source)
				local rotation = getElementData(source, "rotation")
				local interior = getElementInterior(source)
				local dimension = getElementDimension(source)
				local dbid = getElementData(source, "dbid")
				local shoptype = getElementData(source, "shoptype")
				local skin = getElementModel(source)
				
				destroyElement(source)
				createShopKeeper(x,y,z,interior,dimension,dbid,shoptype,rotation,skin)
			end,
			120000, 1, source
		)
	end
)

local skins = { { 211, 217 }, { 179 }, false, { 178 }, { 82 }, { 80, 81 }, { 28, 29 }, { 169 }, { 171, 172 }, { 142 }, { 171 }, { 171, 172 }, {71} }

function createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation, skin)
	if not skin then
		skin = 0
		
		if shoptype == 3 then
			skin = 168
			-- needs differences for burgershot etc
			if interior == 5 then
				skin = 155
			elseif interior == 9 then
				skin = 167
			elseif interior == 10 then
				skin = 205
			elseif dimension == 1355 then
				skin = 171
			end
			-- interior 17 = donut shop
		else
			-- clothes, interior 5 = victim
			-- clothes, interior 15 = binco
			-- clothes, interior 18 = zip
			skin = skins[shoptype][math.random( 1, #skins[shoptype] )]
		end
	end
	
	local ped = createPed(skin, x, y, z)
	setPedRotation(ped, rotation)
	setElementDimension(ped, dimension)
	setElementInterior(ped, interior)
	exports.pool:allocateElement(ped)
	setElementData(ped, "shopkeeper", true)
	setPedFrozen(ped, true)
	
	setElementData(ped, "dbid", id, false)
	setElementData(ped, "type", "shop", false)
	setElementData(ped, "shoptype", shoptype, false)
	setElementData(ped, "rotation", rotation, false)
end

function isGun(weaponID)
	if weaponID <= 15 or weaponID >= 41 then
		return false
	end
	return true
end

function createGeneralshop(thePlayer, commandName, shoptype, skin)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if(tonumber(shoptype)) then
			if((tonumber(shoptype) >= 1) and (tonumber(shoptype) < 14)) then
				local skin = tonumber(skin)
				if skin then
					local ped = createPed(skin, 0, 0, 3)
					if not ped then
						outputChatBox("Invalid Skin.", thePlayer, 255, 0, 0)
						return
					else
						destroyElement(ped)
					end
				else
					skin = -1
				end
				local x, y, z = getElementPosition(thePlayer)
				local dimension = getElementDimension(thePlayer)
				local interior = getElementInterior(thePlayer)
				local rotation = math.ceil(getPedRotation(thePlayer) / 30)*30
				
				local id = mysql:query_insert_free("INSERT INTO shops SET x='" .. x .. "', y='" .. y .. "', z='" .. z .. "', dimension='" .. dimension .. "', interior='" .. interior .. "', shoptype='" .. shoptype .. "', rotation='" .. rotation .. "',skin="..skin)
				
				if (id) then
					createShopKeeper(x,y,z,interior,dimension,id,tonumber(shoptype),rotation,skin ~= -1 and skin)

					exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) .. " created shop #" .. id .. " - type "..shoptype..".")
					outputChatBox("General shop created with ID #" .. id .. " and type "..shoptype..".", thePlayer, 0, 255, 0)
					exports.logs:logMessage("[/makeshop] " .. getElementData(thePlayer, "gameaccountusername") .. "/".. getPlayerName(thePlayer) .." did make shop id " .. id .. " with type " .. shoptype, 4)
				else
					outputChatBox("Error creating shop.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Type must be between 1 and 10.", thePlayer, 255, 194, 14)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [shop type] [optional skin]", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 1 = General Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 2 = Gun + Ammo Shop", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 3 = Food Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 4 = Sex Shop", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 5 = Clothes Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 6 = Gym Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 7 = Drug Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 8 = Electronics Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 9 = Alcohol Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 10 = Book Store", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 11 = Cafe", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 12 = Christmas", thePlayer, 255, 194, 14)
			outputChatBox("TYPE 13 = Prison Food Shop", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("makeshop", createGeneralshop, false, false)

function getNearbyGeneralshops(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby shops:", thePlayer, 255, 126, 0)
		local count = 0
		
		local dimension = getElementDimension(thePlayer)
		
		for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
			local pedType = getElementData(thePed, "type")
			if (pedType) then
				if (pedType=="shop") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local shoptype = getElementData(thePed, "shoptype")
						outputChatBox("   Shop with ID " .. dbid .. " and type "..shoptype..".", thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyshops", getNearbyGeneralshops, false, false)

function deleteGeneralShop(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local counter = 0
			
			for k, thePed in ipairs(exports.pool:getPoolElementsByType("ped")) do
				local pedType = getElementData(thePed, "type")
				if (pedType) then
					if (pedType=="shop") then
						local dbid = getElementData(thePed, "dbid")
						if (tonumber(id)==dbid) then
							destroyElement(thePed)
							mysql:query_free("DELETE FROM shops WHERE id='" .. dbid .. "' LIMIT 1")
							exports.irc:sendMessage("[ADMIN] " .. getPlayerName(thePlayer) ..  " deleted shop with ID #" .. id .. ".")
							outputChatBox("Deleted shop with ID #" .. id .. ".", thePlayer, 0, 255, 0)
							counter = counter + 1
						end
					end
				end
			end
			
			if (counter==0) then
				outputChatBox("No shops with such an ID exists.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delshop", deleteGeneralShop, false, false)

function loadAllGeneralshops(res)
	local result = mysql:query("SELECT id, x, y, z, dimension, interior, shoptype, rotation, skin FROM shops")
	
	local counter = 0
	
	while true do
		local row = exports.mysql:fetch_assoc(result)
		if not (row) then
			break
		end
		
		local id = tonumber(row["id"])
		local x = tonumber(row["x"])
		local y = tonumber(row["y"])
		local z = tonumber(row["z"])
			
		local dimension = tonumber(row["dimension"])
		local interior = tonumber(row["interior"])
		local shoptype = tonumber(row["shoptype"])
		
		local rotation = tonumber(row["rotation"])
		local skin = tonumber(row["skin"])
			
		createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation,skin ~= -1 and skin)
		counter = counter + 1
	end
	mysql:free_result(result)

	exports.irc:sendMessage("[SCRIPT] Loaded " .. counter .. " general shops.")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllGeneralshops)

function clickStoreKeeper(ped)
	local shoptype = getElementData(ped, "shoptype")

	local race = 1

	local race, gender = -1, -1
	if(shoptype == 5) then -- if its a clothes shop, we also need the players race
		gender = getElementData(source,"gender")
		race = getElementData(source,"race")
	end
	triggerClientEvent(source, "showGeneralshopUI", source, shoptype, race, gender)
end
addEvent("onClickStoreKeeper", true)
addEventHandler("onClickStoreKeeper", getRootElement(), clickStoreKeeper)


function calcSupplyCosts(thePlayer, itemID, isWeapon, supplyCost)
	if not isweapon and id ~= 68 then
		if exports.global:isPlayerPearlDonator(thePlayer) then
			return math.ceil( 0.5 * supplyCost )
		elseif exports.global:isPlayerSilverDonator(thePlayer) then
			return math.ceil( 0.75 * supplyCost )
		end
	end
	return supplyCost
end


function givePlayerBoughtItem(itemID, itemValue, theCost, isWeapon, name, supplyCost)
	supplyCost = calcSupplyCosts(source, itemID, isWeapon, supplyCost)
	local interior = getElementDimension(source)
	
	if (itemID==48) then -- BACKPACK = UNIQUE
		if (exports.global:hasItem(source, itemID)) then
			outputChatBox("You already have one of this item, this item is unique.", source, 255, 0, 0)
			return
		end
	end
	
	local inttype = nil
	local supplies = nil
	local dbid, thePickup = call( getResourceFromName( "interior-system" ), "findProperty", source)
	if thePickup then
		inttype = getElementData(thePickup, "inttype")
	end
	
	if inttype == 1 then
		local result = mysql:query_fetch_assoc("SELECT supplies FROM interiors WHERE id='" .. interior .. "' LIMIT 1")
		supplies = tonumber(result["supplies"])
	end
	
	if not exports.global:hasMoney(source, theCost) then
		outputChatBox("You cannot afford this item.", source, 255, 0, 0)
	else
		if inttype==1 and supplies<supplyCost then
			outputChatBox("This item is out of stock.", source, 255, 0, 0)
			local owner = getElementData(thePickup, "owner")
			local theOwner = nil
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local id = getElementData(value, "dbid")
				if (id==owner) then
					theOwner = value
				end
			end
			
			if (theOwner) then
				exports.global:givePlayerAchievement(theOwner, 28)
				outputChatBox("Supplies in your shop are empty!!! Be sure to fill them up, or you risk losing business.", theOwner, 255, 0, 0)
			end
		else
			if (isWeapon==nil) then
				if exports.global:takeMoney(source, theCost) then
					local skin = tonumber(itemValue) or 264
					exports.global:giveItem(source, 16, skin)
					setElementModel(source, skin)
					mysql:query_free("UPDATE characters SET skin = " .. skin .. " WHERE id = " .. getElementData( source, "dbid" ) )
					if setElementData(source, "casualskin", skin, false) then
						mysql:query_free("UPDATE characters SET casualskin = " .. skin .. " WHERE id = " .. getElementData(source, "dbid") )
					end
					exports.global:givePlayerAchievement(source, 21)
				end
			elseif (isWeapon==false) and (itemID==68) then
				local ticketNumber, moniez = exports.lottery:giveTicket(source)
				if ticketNumber ~= false then
					exports.global:takeMoney(source, tonumber(theCost))
					outputChatBox("You bought a " .. name .. ". The ticket number is: " .. ticketNumber .. ".", source, 255, 194, 14)
					outputChatBox("The money will be transfered to your bank account if you win.", source, 255, 194, 14)
					theCost = theCost - moniez
				else
					outputChatBox("I'm sorry, the lottery is already closed. Wait for the next round.", source, 255, 194, 14)
				end
			elseif (isWeapon==false) then
				if(exports.global:giveItem(source, itemID, itemValue)) then
					if exports.global:takeMoney(source, theCost) then
						if (itemID~=30) and (itemID~=31) and (itemID~=32) and (itemID~=33) then
							outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
							outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
							exports.global:givePlayerAchievement(source, 22)
							if itemID == 2 or itemID == 17 then
								triggerClientEvent(source, "updateHudClock", source)
							end
						else
							outputChatBox("You stole some " .. name .. ".", source, 255, 194, 14)
						end
					end
				else
					outputChatBox("You do not have enough space to purchase that item.", source, 255, 0, 0)
				end
			elseif (isWeapon) and (itemValue==-1) then -- fighting styles!
				if exports.global:takeMoney(source, theCost) then
					outputChatBox("You learnt " .. name .. ".", source, 255, 194, 14)
					outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
					
					itemID = tonumber(itemID)
					
					if (itemID==4) then
						exports.global:giveItem(source, 20, 1)
					elseif (itemID==5) then
						exports.global:giveItem(source, 21, 1)
					elseif (itemID==6) then
						exports.global:giveItem(source, 22, 1)
					elseif (itemID==7) then
						exports.global:giveItem(source, 23, 1)
					elseif (itemID==15) then
						exports.global:giveItem(source, 24, 1)
					elseif (itemID==16) then
						exports.global:giveItem(source, 25, 1)
					else
						return
					end
					setPedFightingStyle(source, itemID)
					mysql:query_free("UPDATE characters SET fightstyle = " .. itemID .. " WHERE id = " .. getElementData( source, "dbid" ) )
					
					exports.global:givePlayerAchievement(source, 20)
				end
			else
				if (itemID==999) then
					if exports.global:takeMoney(source, tonumber(theCost)) then
						setPedArmor(source, 50)
						outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
						outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
					end
				elseif isWeapon and isGun(tonumber(itemID)) then
					-- licensing check
					local gunlicense = getElementData(source, "license.gun")
					if (gunlicense==1) then
						if exports.global:takeMoney(source, theCost) then
							outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
							outputChatBox("You have $".. exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
							exports.global:giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
							exports.global:giveMoney(getTeamFromName("Government of Los Santos"), math.floor(theCost/2))
						end
					else
						outputChatBox("You do not have a weapons license - You can buy this license at the LSPD.", source, 255, 194, 14)
					end
				else
					if exports.global:takeMoney(source, theCost) then
						outputChatBox("You bought a " .. name .. ".", source, 255, 194, 14)
						outputChatBox("You have $"..exports.global:getMoney(source).." left in your wallet.", source, 255, 194, 14)
						exports.global:giveWeapon(source, tonumber(itemID), tonumber(itemValue), true)
						exports.global:givePlayerAchievement(source, 22)
						exports.global:giveMoney(getTeamFromName("Government of Los Santos"), math.floor(theCost/2))
					end
				end
			end
			
			if inttype == 1 then
				local query = mysql:query_free("UPDATE interiors SET supplies = supplies - " .. ( tonumber(supplyCost) or 1 ) .. " WHERE id='" .. interior .. "'")
				-- give the money to the shop owner
				local owner = getElementData(thePickup, "owner")
				local theOwner = nil
				for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
					local id = getElementData(value, "dbid")
					if (id==owner) then
						theOwner = value
					end
				end
				
				if (theOwner) then
					local profits = getElementData(theOwner, "businessprofit")
					setElementData(theOwner, "businessprofit", profits+theCost, false)
				else
					mysql:query_free( "UPDATE characters SET bankmoney=bankmoney + " .. tonumber(theCost) .. " WHERE id = " .. owner .. " LIMIT 1")
				end
				
				if (supplies-1<10) then
					if (theOwner) then
						outputChatBox("Supplies in your shop are running low! (Less than 10). Be sure to fill them up, or you risk losing business.", theOwner, 255, 0, 0)
					end
				end
			end
		end
	end
end
addEvent("ItemBought", true )
addEventHandler("ItemBought", getRootElement(), givePlayerBoughtItem, itemID, ammoAmount, theCost)

globalSupplies = 0

function updateGlobalSupplies(value)
	globalSupplies = globalSupplies + value
	mysql:query_free("UPDATE settings SET value='" .. globalSupplies .. "' WHERE name='globalsupplies'")
end
addEvent("updateGlobalSupplies", true)
addEventHandler("updateGlobalSupplies", getRootElement(), updateGlobalSupplies)

function checkSupplies(thePlayer)
	local dbid, entrance, exit, inttype = exports['interior-system']:findProperty( thePlayer )
	
	if (dbid==0) then
		outputChatBox("You are not in a business.", thePlayer, 255, 0, 0)
	else
		owner = getElementData(entrance, "owner")
		
		if (tonumber(owner)==getElementData(thePlayer, "dbid") or exports.global:hasItem(thePlayer, 4, dbid) or exports.global:hasItem(thePlayer, 5, dbid)) and (inttype==1) then
			local query = mysql:query_fetch_assoc("SELECT supplies FROM interiors WHERE id='" .. dbid .. "' LIMIT 1")
			local supplies = query["supplies"]	
			outputChatBox("This business has " .. supplies .. " supplies.", thePlayer, 255, 194, 14)
		else
			outputChatBox("You are not in a business or do you do own the business.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("checksupplies", checkSupplies, false, false)

function orderSupplies(thePlayer, commandName, amount)
	if not (amount) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Amount of Supplies]", thePlayer, 255, 194, 14)
	else
		local dbid, entrance, exit, inttype = exports['interior-system']:findProperty( thePlayer )
		
		if (dbid==0) then
			outputChatBox("You are not in a business.", thePlayer, 255, 0, 0)
		else
			owner = getElementData(entrance, "owner")
			
			if (tonumber(owner)==getElementData(thePlayer, "dbid") or exports.global:hasItem(thePlayer, 4, dbid) or exports.global:hasItem(thePlayer, 5, dbid)) and (inttype==1) then
				amount = tonumber(amount)
				
				if (amount>globalSupplies) then
					outputChatBox("Supplier: Sorry, we do not have that many supplies in stock currently.", thePlayer, 255, 194, 14)
				else
					local cost = amount*2
					
					if not exports.global:takeMoney(thePlayer, cost) then
						outputChatBox("You cannot afford that many supplies. (Cost is 2$ per supply).", thePlayer, 255, 0, 0)
					else
						globalSupplies = globalSupplies - amount
						mysql:query_free("UPDATE settings SET value='" .. globalSupplies .. "' where name='globalsupplies'")
						mysql:query_free("UPDATE interiors SET supplies= supplies + " .. amount .. " where id='" .. dbid .. "'")
						outputChatBox("You bought " .. amount .. " supplies for your business.", thePlayer, 255, 194, 14)
					end
				end
			else
				outputChatBox("You are not in a business or do you do own the business.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("ordersupplies", orderSupplies, false, false)

function resStart()
	local result = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name='globalsupplies' LIMIT 1")
	globalSupplies = result["value"]
end
addEventHandler("onResourceStart", getResourceRootElement(), resStart)