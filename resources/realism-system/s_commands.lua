-- /LOOK
function lookPlayer(thePlayer, commandName, targetPlayer)
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
				local description = getElementData(targetPlayer, "chardescription")
				local age = getElementData(targetPlayer, "age")
				local weight = getElementData(targetPlayer, "weight")
				local height = getElementData(targetPlayer, "height")
				local race = getElementData(targetPlayer, "race")
				
				if (race==0) then
					race = "Black"
				elseif (race==1) then
					race = "White"
				elseif (race==2) then
					race = "Asian"
				else
					race = "Alien"
				end
				
				outputChatBox("~~~~~~~~~~~~ " .. targetPlayerName .. " ~~~~~~~~~~~~", thePlayer, 255, 194, 14)
				outputChatBox("Age: " .. age .. " years old", thePlayer, 255, 194, 14)
				outputChatBox("Ethnicity: " .. race, thePlayer, 255, 194, 14)
				outputChatBox("Weight: " .. weight .. "kg", thePlayer, 255, 194, 14)
				outputChatBox("Height: " .. height .. "cm", thePlayer, 255, 194, 14)
				outputChatBox("Description: " .. description, thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("look", lookPlayer, false, false)