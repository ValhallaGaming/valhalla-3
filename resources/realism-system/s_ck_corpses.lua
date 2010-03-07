mysql = exports.mysql

function addCharacterKillBody( x, y, z, rotation, skin, id, name, interior, dimension )
	local ped = createPed(skin, x, y, z)
	setPedRotation(ped, rotation)
	setElementData(ped, "ckid", id, false)
	setElementData(ped, "name", name:gsub("_", " "), false)
	setElementInterior(ped, interior)
	setElementDimension(ped, dimension)
	--setTimer(setPedAnimation, 100, 1, ped, "WUZI", "CS_Dead_Guy", -1, false, false, false)
	killPed(ped)
end

function loadAllCorpses(res)
	local result = mysql:query("SELECT x, y, z, skin, rotation, id, charactername, interior_id, dimension_id FROM characters WHERE cked = 1")
	
	local counter = 0
	local rowc = 1
	
	if (result) then
		local continue = true
		while continue do
			local row = mysql:fetch_assoc(result)
			if not row then
				break
			end
			local x = tonumber(row["x"])
			local y = tonumber(row["y"])
			local z = tonumber(row["z"])
			local skin = tonumber(row["skin"])
			local rotation = tonumber(row["rotation"])
			local id = tonumber(row["id"])
			local name = row["charactername"]
			if name == mysql_null() then
				name = ""
			end
			local interior = tonumber(row["interior_id"])
			local dimension = tonumber(row["dimension_id"])
			
			addCharacterKillBody(x, y, z, rotation, skin, id, name, interior, dimension)
		end
		mysql:free_result(result)
	end
	
	-- Garage Stuff
	local result = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name = 'garagestates'" )
	if result then
		local res = result["value"]
		local garages = fromJSON( res )
		
		if garages then
			for i = 0, 49 do
				setGarageOpen( i, garages[tostring(i)] )
			end
		else
			outputDebugString( "Failed to load Garage States" )
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllCorpses)

function getNearbyCKs(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Character Kill Bodies:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, v in ipairs(getElementsByType("ped", getResourceRootElement())) do
			local x, y, z = getElementPosition(v)
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
			if (distance<=20) then
				outputChatBox("   " .. getElementData(v, "name"), thePlayer, 255, 126, 0)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbycks", getNearbyCKs, false, false)

-- in remembrance of
local function showCKList( thePlayer, data )
	exports.global:givePlayerAchievement( thePlayer, 40 )
	local result = mysql:query("SELECT charactername FROM characters WHERE cked = " .. data .. " ORDER BY charactername")
	if result then
		local names = {}
		local continue = true
		while continue do
			row = mysql:fetch_assoc(result)
			if not row then
				break
			end
			local name = row["charactername"]
			if name ~= mysql_null() then
				names[ #names + 1 ] = name
			end
		end
		triggerClientEvent( thePlayer, "showCKList", thePlayer, names, data )
		mysql:free_result(result)
	end
end

local ckBuried = createPickup( 815, -1100, 25.8, 3, 1254 )
addEventHandler( "onPickupHit", ckBuried,
	function( thePlayer )
		cancelEvent()
		showCKList( thePlayer, 2 )
	end
)

local ckMissing = createPickup( 819, -1100, 25.8, 3, 1314 )
addEventHandler( "onPickupHit", ckMissing,
	function( thePlayer )
		cancelEvent()
		showCKList( thePlayer, 1 )
	end
)