function getAdmins()
	local players = exports.pool:getPoolElementsByType("player")
	
	local admins = { }
	local count = 1
	
	for key, value in ipairs(players) do
		if isPlayerAdmin(value) and getPlayerAdminLevel(value) <= 6 then
			admins[count] = value
			count = count + 1
		end
	end
	return admins
end

function isPlayerAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 1
end

function isPlayerFullAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 2
end

function isPlayerSuperAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 3
end

function isPlayerHeadAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 5
end

function isPlayerLeadAdmin(thePlayer)
	return getPlayerAdminLevel(thePlayer) >= 4
end

function getPlayerAdminLevel(thePlayer)
	return isElement( thePlayer ) and tonumber(getElementData(thePlayer, "adminlevel")) or 0
end

local titles = { "Trial Admin", "Admin", "Super Admin", "Lead Admin", "Head Admin", "Owner" }
function getPlayerAdminTitle(thePlayer)
	local text = titles[getPlayerAdminLevel(thePlayer)] or "Player"
	
	local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
	if (hiddenAdmin==1) then
		text = text .. " (Hidden)"
	end

	return text
end

-- Do not even think of adding your own name here unless you made a couple of recent commits.
local scripterAccounts = {
	Daniels = true,
	mabako = true,
	Mount = true,
	ryden = true,
	herbjr = true --because he is awesome
}
function isPlayerScripter(thePlayer)
	return getElementType(thePlayer) == "console" or scripterAccounts[getElementData(thePlayer, "gameaccountusername")] or false
end
