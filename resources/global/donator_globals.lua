function getDonators()
	local players = exports.pool:getPoolElementsByType("player")
	
	local donators = { }
	
	for key, value in ipairs(players) do
		if isPlayerBronzeDonator( value ) then
			table.insert( donators, value )
		end
	end
	return donators
end

function isPlayerBronzeDonator(thePlayer)
	return getPlayerDonatorLevel(thePlayer) >= 1
end

function isPlayerSilverDonator(thePlayer)
	return getPlayerDonatorLevel(thePlayer) >= 2
end

function isPlayerGoldDonator(thePlayer)
	return getPlayerDonatorLevel(thePlayer) >= 3
end

function isPlayerPlatinumDonator(thePlayer)
	return getPlayerDonatorLevel(thePlayer) >= 4
end

function isPlayerPearlDonator(thePlayer)
	return getPlayerDonatorLevel(thePlayer) >= 5
end

function isPlayerDiamondDonator(thePlayer)
	return getPlayerDonatorLevel(thePlayer) >= 6
end

function isPlayerGodlyDonator(thePlayer)
	return getPlayerDonatorLevel(thePlayer) >= 7
end

function getPlayerDonatorLevel(thePlayer)
	return isElement( thePlayer ) and tonumber(getElementData(thePlayer, "donatorlevel")) or 0
end

local titles = { "Bronze Donator", "Silver Donator", "Gold Donator", "Platinum Donator", "Pearl Donator", "Diamond Donator", "Godly Donator" }
function getPlayerDonatorTitle(thePlayer)
	return titles[getPlayerDonatorLevel(thePlayer)] or "Player"
end
