-- Default position on start of the resource
local x = 
local y = -1393.1240234375
local z = 1022.1019897461
local int = 3
local dim = 127

-- Some variables needed
local marker = nil

function setPlayerFreecamEnabled(player)
	if not isPlayerFreecamEnabled(player) then
		removePedFromVehicle(player)
		setElementData(player, "realinvehicle", 0, false)
		local startX, startY, startZ = getElementPosition(player)
		setElementData(player, "tv:dim", getElementDimension(player), false)
		setElementData(player, "tv:int", getElementInterior(player), false)
		setElementData(player, "tv:x", startX, false)
		setElementData(player, "tv:y", startY, false)
		setElementData(player, "tv:z", startZ, false)
		setElementDimension(player, dim)
		setElementInterior(player, int)
		setElementAlpha(player, 0)
		setElementData(player, "reconx", true)
		return triggerClientEvent(player,"doSetFreecamEnabledTV", getRootElement(), x,y,z, false)
	else
		return false
	end
end

function moveCamera(newx, newy, newz, newint, newdim)
	if (marker) then
		destroyElement(marker)
	end
	
	marker = createMarker( newx, newy, newz, 'corona', 1, 255, 127, 0, 127)
	setElementInterior(marker, newint)
	setElementDimension(marker, 65535)
	
	x = newx
	y = newy
	z = newz
	int = newint
	dim = newdim
	return true
end

-- Move to the default position
moveCamera(x, y, z, int, dim)

function setPlayerFreecamDisabled(player)
	if isPlayerFreecamEnabled(player) then
		setElementDimension(player, getElementData(player, "tv:dim"))
		setElementInterior(player, getElementData(player, "tv:int"))
		setElementAlpha(player, 255)
		removeElementData(player, "reconx", true)
		
		return triggerClientEvent(player,"doSetFreecamDisabledTV", getRootElement(), false)
	else
		return false
	end
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOptionTV", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecamTV:state")
end



-- 

local earnings = 0
local watching = 0

--

addCommandHandler("tv",
	function(player)
		if isPlayerFreecamEnabled(player) then
			setPlayerFreecamDisabled(player)
		elseif isTVRunning() then
			setPlayerFreecamEnabled(player)
		else
			outputChatBox("There's no TV Show running.", player, 255, 194, 14)
		end
	end
)

addCommandHandler("movetv",
	function(player)
		if getElementData(player, "faction") == 20 then
			if isTVRunning() then
				outputChatBox("There is already a TV show running.", player, 255, 0, 0)
			else
				-- I like to ... move it!
				local posX, posY, posZ = getElementPosition(player)
				local posDim = getElementDimension(player)
				local posInt = getElementInterior(player)
				if moveCamera(posX, posY, posZ, posInt, posDim) then
					for k, v in ipairs( getElementsByType( "player" ) ) do
						if getElementData(v, "faction") == 20 then
							outputChatBox("[TV] ".. getPlayerName(player):gsub("_", " ") .. " moved the camera position.", v, 200, 100, 200)
						end
					end
				else
					outputChatBox("Error!", player, 255, 0,0)
				end
			end
		end
	end
)

addCommandHandler("starttv",
	function(player)
		if getElementData(player, "faction") == 20 then
			if not isTVRunning() then
				outputChatBox("[TV] " .. getPlayerName(player):gsub("_", " ") .. " started a TV Show. (( /tv to watch ))", getRootElement( ), 200, 100, 200)
				exports.logs:logMessage("(start) " .. getPlayerName(player):gsub("_", " ") .. " started a TV Show.", 20)
				watching = 0
				earnings = 0
			else
				outputChatBox("The TV Show is already running.", player, 255, 0, 0)
			end
		end
	end
)

addCommandHandler("endtv",
	function(player)
		if getElementData(player, "faction") == 20 then
			if isTVRunning() then
				outputChatBox("[TV] " .. getPlayerName(player):gsub("_", " ") .. " ended the TV Show.", getRootElement( ), 200, 100, 200)
				
				for k, v in ipairs( getElementsByType( "player" ) ) do
					if isPlayerFreecamEnabled(v) then
						setPlayerFreecamDisabled(v)
					end
					
					if getElementData(v, "faction") == 20 then
						outputChatBox("[TV] Max. Viewers: " .. watching .. ", Earnings: $" .. earnings, v, 200, 100, 200)
					end
				end
				
				exports.logs:logMessage("(stop) " .. getPlayerName(player):gsub("_", " ") .. " ended the TV Show.", 20)
				exports.logs:logMessage("(stats) Max. Viewers: " .. watching, 20)
				exports.logs:logMessage("(stats) Earnings: $" .. earnings, 20)
			else
				outputChatBox("There's no TV Show running.", player, 255, 0, 0)
			end
		end
	end
)

function isTVRunning()
	return not getElementDimension(marker) == 65535
end

function add( shownto, message )
	if isTVRunning() then
		watching = math.max( shownto, watching )
		earnings = earnings + 10 * shownto
		
		exports.global:giveMoney(getTeamFromName"San Andreas Network", 10 * shownto)
		exports.logs:logMessage( "($" .. ( 10 * shownto ) .. ") " .. message, 20)
	else
		exports.logs:logMessage( "(off) " .. message, 20)
	end
end