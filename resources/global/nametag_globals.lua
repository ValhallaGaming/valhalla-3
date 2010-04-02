function updateNametagColor(thePlayer)
	if getElementData(thePlayer, "loggedin") ~= 1 then
		setPlayerNametagColor(thePlayer, 127, 127, 127)
	elseif isPlayerAdmin(thePlayer) and getElementData(thePlayer, "adminduty") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 then -- Admin duty
		setPlayerNametagColor(thePlayer, 255, 194, 14)
	elseif (getElementData(thePlayer,"PDbadge")==1) then -- PD Badge
		setPlayerNametagColor(thePlayer, 0, 100, 255)
	elseif (getElementData(thePlayer,"ESbadge")==1) then -- ES Badge
		setPlayerNametagColor(thePlayer, 175, 50, 50)
	elseif (getElementData(thePlayer,"GOVbadge")==1) then -- GOV Badge
		setPlayerNametagColor(thePlayer, 50, 150, 50)
	elseif (getElementData(thePlayer,"SANbadge")==1) then -- SAN Badge
		setPlayerNametagColor(thePlayer, 150, 150, 255)
	elseif (getElementData(thePlayer,"USMSbadge")==1) then -- USMS Badge || Not sure about the color, may cause confusion between ES and USMS? 
		setPlayerNametagColor(thePlayer, 100, 0, 0)
	elseif isPlayerBronzeDonator(thePlayer) then -- Donator
		setPlayerNametagColor(thePlayer, 167, 133, 63)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end

for key, value in ipairs( getElementsByType( "player" ) ) do
	updateNametagColor( value )
end