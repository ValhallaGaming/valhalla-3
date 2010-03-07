-- cells
cells =
{
	createColSphere( 227.5, 114.7, 999.02, 2 ),
	createColSphere( 223.5, 114.7, 999.02, 2 ),
	createColSphere( 219.5, 114.7, 999.02, 2 ),
	createColSphere( 215.5, 114.7, 999.02, 2 ),
	
	createColSphere( 227.5, 114.7, 999.02, 2 ),
	createColSphere( 223.5, 114.7, 999.02, 2 ),
	createColSphere( 219.5, 114.7, 999.02, 2 ),
	createColSphere( 215.5, 114.7, 999.02, 2 ),	
}

for k, v in pairs( cells ) do
	setElementInterior( v, 10 )
	setElementDimension( v, k <= 4 and 1 or 10583 )
end

function isInArrestColshape( thePlayer )
	for k, v in pairs( cells ) do
		if isElementWithinColShape( thePlayer, v ) and getElementDimension( thePlayer ) == getElementDimension( v ) then
			return k
		end
	end
	return false
end

-- /arrest
function arrestPlayer(thePlayer, commandName, targetPlayerNick, fine, jailtime, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (jailtime) then
			jailtime = tonumber(jailtime)
		end
		
		local playerCol = isInArrestColshape(thePlayer)
		if (factionType==2) and playerCol then
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>180) then
				outputChatBox("SYNTAX: /arrest [Player Partial Nick / ID] [Fine] [Jail Time (Minutes 1->180)] [Crimes Committed]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local targetCol = isInArrestColshape(targetPlayer)
					
					if not targetCol then
						outputChatBox("The player is not within range of the booking desk.", thePlayer, 255, 0, 0)
					elseif targetCol ~= playerCol then
						outputChatBox("The player is standing infront of another cell.", thePlayer, 255, 0, 0)
					else
						local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
						local username  = getPlayerName(thePlayer)
						local reason = table.concat({...}, " ")
						
						if (jailTimer) then
							outputChatBox("This player is already serving a jail sentance.", thePlayer, 255, 0, 0)
						else
							local finebank = false
							local targetPlayerhasmoney = exports.global:getMoney(targetPlayer, true)
							local amount = tonumber(fine)
							if not exports.global:takeMoney(targetPlayer, amount) then
								finebank = true
								exports.global:takeMoney(targetPlayer, targetPlayerhasmoney)
								local fineleft = amount - targetPlayerhasmoney
								local bankmoney = getElementData(targetPlayer, "bankmoney")
								setElementData(targetPlayer, "bankmoney", bankmoney-fineleft)
							end
						
							local theTimer = setTimer(timerPDUnjailPlayer, 60000, jailtime, targetPlayer)
							setElementData(targetPlayer, "pd.jailserved", 0, false)
							setElementData(targetPlayer, "pd.jailtime", jailtime, false)
							setElementData(targetPlayer, "pd.jailtimer", theTimer, false)
							
							toggleControl(targetPlayer,'next_weapon',false)
							toggleControl(targetPlayer,'previous_weapon',false)
							toggleControl(targetPlayer,'fire',false)
							toggleControl(targetPlayer,'aim_weapon',false)
							
							-- auto-uncuff
							local restrainedObj = getElementData(targetPlayer, "restrainedObj")
							if restrainedObj then
								toggleControl(targetPlayer, "sprint", true)
								toggleControl(targetPlayer, "jump", true)
								toggleControl(targetPlayer, "accelerate", true)
								toggleControl(targetPlayer, "brake_reverse", true)
								setElementData(targetPlayer, "restrain", 0)
								removeElementData(targetPlayer, "restrainedBy")
								removeElementData(targetPlayer, "restrainedObj")
								if restrainedObj == 45 then -- If handcuffs.. take the key
									local dbid = getElementData(targetPlayer, "dbid")
									exports['item-system']:deleteAll(47, dbid)
								end
								exports.global:giveItem(thePlayer, restrainedObj, 1)
								mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. getElementData( targetPlayer, "dbid" ) )
							end
							setPedWeaponSlot(targetPlayer,0)
							
							setElementData(targetPlayer, "pd.jailstation", targetCol)
							
							mysql:query_free("UPDATE characters SET pdjail='1', pdjail_time='" .. jailtime .. "', pdjail_station='" .. targetCol .. "', cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. getElementData( targetPlayer, "dbid" ) )
							outputChatBox("You jailed " .. targetPlayerNick .. " for " .. jailtime .. " Minutes.", thePlayer, 255, 0, 0)
							
							local x, y, z = getElementPosition(cells[targetCol])
							setElementPosition(targetPlayer, x, y - 5, z)
							setPedRotation(targetPlayer, 0)
							
							-- Trigger the event
							exports.global:givePlayerAchievement(thePlayer, 7)
							exports.global:givePlayerAchievement(targetPlayer, 8)
							
							-- Show the message to the faction
							local theTeam = getTeamFromName("Los Santos Police Department")
							local teamPlayers = getPlayersInTeam(theTeam)

							local factionID = getElementData(thePlayer, "faction")
							local factionRank = getElementData(thePlayer, "factionrank")
														
							local factionRanks = getElementData(theTeam, "ranks")
							local factionRankTitle = factionRanks[factionRank]
							
							outputChatBox("You were arrested by " .. username .. " for " .. jailtime .. " minute(s).", targetPlayer, 0, 102, 255)
							outputChatBox("Crimes Committed: " .. reason .. ".", targetPlayer, 0, 102, 255)
							if (finebank == true) then
								outputChatBox("The rest of the fine has been taken from your banking account.", targetPlayer, 0, 102, 255)
							end
							
							for key, value in ipairs(teamPlayers) do
								if (isSouthDivision) then
									outputChatBox(factionRankTitle .. " " .. username .. " arrested " .. targetPlayerNick .. " for " .. jailtime .. " minute(s). (South Division)", value, 0, 102, 255)
									outputChatBox("Crimes Committed: " .. reason .. ".", value, 0, 102, 255)
								else
									outputChatBox(factionRankTitle .. " " .. username .. " arrested " .. targetPlayerNick .. " for " .. jailtime .. " minute(s).", value, 0, 102, 255)
									outputChatBox("Crimes Committed: " .. reason .. ".", value, 0, 102, 255)
								end
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("arrest", arrestPlayer)

function timerPDUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = tonumber(getElementData(jailedPlayer, "pd.jailserved"))
		local timeLeft = getElementData(jailedPlayer, "pd.jailtime")
		local theMagicTimer = getElementData(jailedPlayer, "pd.jailtimer") -- 0001290: PD /release bug
		local username = getPlayerName(jailedPlayer)
		setElementData(jailedPlayer, "pd.jailserved", tonumber(timeServed)+1, false)
		local timeLeft = timeLeft - 1
		setElementData(jailedPlayer, "pd.jailtime", timeLeft, false)

		if (timeLeft<=0) and (theMagicTimer) then
			killTimer(theMagicTimer) -- 0001290: PD /release bug
			fadeCamera(jailedPlayer, false)
			mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. getElementData(jailedPlayer, "dbid"))
			setElementDimension(jailedPlayer, getElementData(jailedPlayer, "pd.jailstation") <= 4 and 1 or 10583)
			setElementInterior(jailedPlayer, 10)
			setCameraInterior(jailedPlayer, 10)

			setElementPosition(jailedPlayer, 241.3583984375, 115.232421875, 1003.2257080078)
			setPedRotation(jailedPlayer, 270)
				
			setElementData(jailedPlayer, "pd.jailserved", 0, false)
			setElementData(jailedPlayer, "pd.jailtime", 0, false)
			removeElementData(jailedPlayer, "pd.jailtimer")
			removeElementData(jailedPlayer, "pd.jailstation")
			
			toggleControl(jailedPlayer,'next_weapon',true)
			toggleControl(jailedPlayer,'previous_weapon',true)
			toggleControl(jailedPlayer,'fire',true)
			toggleControl(jailedPlayer,'aim_weapon',true)
			
			fadeCamera(jailedPlayer, true)
			outputChatBox("Your time has been served.", jailedPlayer, 0, 255, 0)

		elseif (timeLeft>0) then
			mysql:query_free("UPDATE characters SET pdjail_time='" .. timeLeft .. "' WHERE id=" .. getElementData(jailedPlayer, "dbid"))
		end
	end
end

function showJailtime(thePlayer)
	local ajailtime = getElementData(thePlayer, "jailtime")
	if ajailtime then
		outputChatBox("You have " .. ajailtime .. " minutes remaining on your admin jail.", thePlayer, 255, 194, 14)
	else
		local isJailed = getElementData(thePlayer, "pd.jailtimer")
		
		if not (isJailed) then
			outputChatBox("You are not jailed.", thePlayer, 255, 0, 0)
		else
			local jailtime = getElementData(thePlayer, "pd.jailtime")
			outputChatBox("You have " .. jailtime .. " minutes remaining of your jail sentance.", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("jailtime", showJailtime)

function jailRelease(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if factionType == 2 and isInArrestColshape(thePlayer) then
			if not (targetPlayerNick) then
				outputChatBox("SYNTAX: /release [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
					local username  = getPlayerName(thePlayer)
						
					if (jailTimer) then
						setElementData(targetPlayer, "pd.jailtime", 1, false)
						timerPDUnjailPlayer(targetPlayer)
					else
						outputChatBox("This player is not serving a jail sentance.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("release", jailRelease)