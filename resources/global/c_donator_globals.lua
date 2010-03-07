function cisPlayerBronzeDonator(thePlayer)
	return cgetPlayerDonatorLevel(thePlayer) >= 1
end

function cisPlayerSilverDonator(thePlayer)
	return cgetPlayerDonatorLevel(thePlayer) >= 2
end

function cisPlayerGoldDonator(thePlayer)
	return cgetPlayerDonatorLevel(thePlayer) >= 3
end

function cisPlayerPlatinumDonator(thePlayer)
	return cgetPlayerDonatorLevel(thePlayer) >= 4
end

function cisPlayerPearlDonator(thePlayer)
	return cgetPlayerDonatorLevel(thePlayer) >= 5
end

function cisPlayerDiamondDonator(thePlayer)
	return cgetPlayerDonatorLevel(thePlayer) >= 6
end

function cisPlayerGodlyDonator(thePlayer)
	return cgetPlayerDonatorLevel(thePlayer) >= 7
end

function cgetPlayerDonatorLevel(thePlayer)
	return isElement( thePlayer ) and tonumber(getElementData(thePlayer, "donatorlevel")) or 0
end

local titles = { "Bronze Donator", "Silver Donator", "Gold Donator", "Platinum Donator", "Pearl Donator", "Diamond Donator", "Godly Donator" }
function cgetPlayerDonatorTitle(thePlayer)
	return titles[cgetPlayerDonatorLevel(thePlayer)] or "Player"
end
