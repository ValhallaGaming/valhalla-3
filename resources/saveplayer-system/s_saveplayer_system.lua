mysql = exports.mysql
tweapons = { }

function initWeapons()
	tweapons[source] = { }
	tweapons[source][1] = ""
	tweapons[source][2] = ""
end
addEventHandler("onPlayerJoin", getRootElement(), initWeapons)

function cleanWeapons(thePlayer)
	tweapons[thePlayer] = nil
end

function saveWeapons(thePlayer)
	if tweapons[thePlayer] then
		local weapons = tweapons[thePlayer][1]
		local ammo = tweapons[thePlayer][2]

		cleanWeapons(thePlayer)
		
		if (weapons~=false) and (ammo~=false) then
			mysql:query_free("UPDATE characters SET weapons='" .. mysql:escape_string(weapons) .. "', ammo='" .. mysql:escape_string(ammo) .. "' WHERE id='" .. mysql:escape_string(getElementData(thePlayer, "dbid")) .. "'")
		end
	end
end

local count = 1
function syncWeapons(weapons, ammo)
	count = count + 1
	tweapons[source] = { weapons, ammo }
end
addEvent("syncWeapons", true)
addEventHandler("syncWeapons", getRootElement(), syncWeapons)


function getWeapons(player)
	return tweapons[player] or { "", "" }
end

function saveAllPlayers()
	outputDebugString("WORLDSAVE INCOMING")
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		triggerEvent("savePlayer", value, "Save All")
	end
end

function syncTIS()
	for key, value in ipairs(getElementsByType("player")) do
		local tis = getElementData(value, "timeinserver")
		if (tis) then
			exports['anticheat-system']:changeProtectedElementDataEx(value, "timeinserver", tonumber(tis)+1, false)
		end
	end
end
setTimer(syncTIS, 60000, 0)

function savePlayer(reason, player)
	local logged = getElementData(source, "loggedin")

	if (logged==1 or reason=="Change Character") then
		saveWeapons(source)
		
		local vehicle = getPedOccupiedVehicle(source)
		
		if (vehicle) then
			local seat = getPedOccupiedVehicleSeat(source)
			triggerEvent("onVehicleExit", vehicle, source, seat)
		end
		
		local x, y, z, rot, health, armour, interior, dimension, cuffed, skin, duty, timeinserver, businessprofit
		
		local x, y, z = getElementPosition(source)
		local rot = getPedRotation(source)
		local health = getElementHealth(source)
		local armor = getPedArmor(source)
		local interior = getElementInterior(source)
		local dimension = getElementDimension(source)
		local d_addiction = ( getElementData(source, "drug.1") or 0 ) .. ";" .. ( getElementData(source, "drug.2") or 0 ) .. ";" .. ( getElementData(source, "drug.3") or 0 ) .. ";" .. ( getElementData(source, "drug.4") or 0 ) .. ";" .. ( getElementData(source, "drug.5") or 0 ) .. ";" .. ( getElementData(source, "drug.6") or 0 ) .. ";" .. ( getElementData(source, "drug.7") or 0 ) .. ";" .. ( getElementData(source, "drug.8") or 0 ) .. ";" .. ( getElementData(source, "drug.9") or 0 ) .. ";" .. ( getElementData(source, "drug.10") or 0 )
		money = getElementData(source, "stevie.money")
		if money and money > 0 then
			money = 'money = money + ' .. money .. ', '
		else
			money = ''
		end
		skin = getElementModel(source)
		
		if getElementData(source, "help") then
			dimension, interior, x, y, z = unpack( getElementData(source, "help") )
		end
		
		-- Fix for #0000984
		if getElementData(source, "businessprofit") and ( reason == "Quit" or reason == "Timed Out" or reason == "Unknown" or reason == "Bad Connection" or reason == "Kicked" or reason == "Banned" ) then
			businessprofit = 'bankmoney = bankmoney + ' .. getElementData(source, "businessprofit") .. ', '
		else
			businessprofit = ''
		end
		
		-- Fix for freecam-tv
		if exports['freecam-tv']:isPlayerFreecamEnabled(source) then 
			x = getElementData(source, "tv:x")
			y = getElementData(source, "tv:y")
			z =  getElementData(source, "tv:z")
			interior = getElementData(source, "tv:int")
			dimension = getElementData(source, "tv:dim") 
		end
		
		local  timeinserver = getElementData(source, "timeinserver")
		-- LAST AREA
		local zone = exports.global:getElementZoneName(source)
		if not zone or #zone == 0 then
			zone = "Unknown"
		end
		
		local update = mysql:query_free("UPDATE characters SET x='" .. mysql:escape_string(x) .. "', y='" .. mysql:escape_string(y) .. "', z='" .. mysql:escape_string(z) .. "', rotation='" .. mysql:escape_string(rot) .. "', health='" .. mysql:escape_string(health) .. "', armor='" .. mysql:escape_string(armor) .. "', dimension_id='" .. mysql:escape_string(dimension) .. "', interior_id='" .. mysql:escape_string(interior) .. "', " .. mysql:escape_string(money) .. mysql:escape_string(businessprofit) .. "lastlogin=NOW(), lastarea='" .. mysql:escape_string(zone) .. "', timeinserver='" .. mysql:escape_string(timeinserver) .. "', d_addiction='" .. mysql:escape_string(d_addiction) .. "' WHERE id=" .. mysql:escape_string(getElementData(source, "dbid")))
		if not (update) then
			outputDebugString( "Saveplayer Update:" )
		end
		
		local update2 = mysql:query_free("UPDATE accounts SET lastlogin=NOW() WHERE id = " .. mysql:escape_string(getElementData(source,"gameaccountid")))
		if not (update2) then
			outputDebugString( "Saveplayer Update2: " )
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", getRootElement(), savePlayer)
setTimer(saveAllPlayers, 3600000, 0)
addCommandHandler("saveall", function(p) if exports.global:isPlayerScripter(p) then saveAllPlayers() outputChatBox("Done.", p) end end)
addCommandHandler("saveme", function(p) triggerEvent("savePlayer", p, "Save Me") end)