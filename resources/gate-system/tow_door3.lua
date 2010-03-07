local objGatec = createObject(10671, 2812.6376953125, -1468.373046875, 17.148530960083, 0, 0, 88.978271484375)
exports.pool:allocateElement(objGatec)

local open = false

-- Gate code
function useImpoundDoorc(thePlayer)
	local team = getPlayerTeam(thePlayer)
	if (team==getTeamFromName("Best's Towing and Recovery")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(2812.6376953125, -1468.373046875, 17.148530960083, x, y, z)

		if (distance<=15) and (open==false) then
			open = true
			outputChatBox("The impound lot gate is now open!", thePlayer, 0, 255, 0)
			moveObject(objGatec, 1000, 2812.6259765625, -1466.4775390625, 18.799030303955, 0,90,0)
			setTimer(closeImpoundDoorc, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", useImpoundDoorc)

function closeImpoundDoorc(thePlayer)
	moveObject(objGatec, 1000, 2812.6376953125, -1468.373046875, 17.148530960083, 0, -90, 0)
	setTimer(resetState1c, 1000, 1)
end


function resetState1c()
	open = false
end
