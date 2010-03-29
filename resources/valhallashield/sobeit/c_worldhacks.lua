local localPlayer = getLocalPlayer()
local cooldown = false
local count = 0

local function resetCooldown()
	cooldown = false
end

function checkForSobeit()
	if ( cooldown == false ) then
		if ( isWorldSpecialPropertyEnabled("hovercars") or isWorldSpecialPropertyEnabled("aircars") or isWorldSpecialPropertyEnabled("extrabunny") or isWorldSpecialPropertyEnabled("extrajump") ) then
			cooldown = true
			count = count + 1
			triggerServerEvent("alertSobeit", localPlayer, count)
			setTimer(resetCooldown, 10000, 1)
		end
	end
end
setTimer(checkForSobeit, 1000, 0)