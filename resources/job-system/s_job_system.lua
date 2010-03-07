mysql = exports.mysql

chDimension = 125
chInterior = 3

-- CALL BACKS FROM CLIENT

function onEmploymentServer()
	exports.global:sendLocalText(source, "Jessie Smith says: Hello, are you looking for a new job?", nil, nil, nil, 10)
	exports.global:sendLocalText(source, " *Jessie Smith hands over a list with jobs to " .. getPlayerName(source):gsub("_", " ") .. ".", 255, 51, 102)
end

addEvent("onEmploymentServer", true)
addEventHandler("onEmploymentServer", getRootElement(), onEmploymentServer)

function givePlayerJob(jobID)
	local charname = getPlayerName(source)
	
	setElementData(source, "job", jobID)
	mysql:query_free("UPDATE characters SET job=" .. jobID .. ", jobcontract = 3 WHERE id = " .. getElementData(source, "dbid") )
	
	exports.global:givePlayerAchievement(source, 30)

	if (jobID==4) then -- CITY MAINTENANCE
		exports.global:giveWeapon(source, 41, 1500, true)
		outputChatBox("Use this paint to paint over tags you find.", source, 255, 194, 14)
		setElementData(source, "tag", 9)
		mysql:query_free("UPDATE characters SET tag=9 WHERE id = " .. getElementData(source, "dbid") )
	end
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), givePlayerJob)

function quitJob(source)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local job = getElementData(source, "job")
		if job == 0 then
			outputChatBox("You are currently unemployed.", source, 255, 0, 0)
		else
			local result = mysql:query_fetch_assoc("SELECT jobcontract FROM characters WHERE id = " .. getElementData(source, "dbid") )
			if result then
				local contracttime = tonumber( result["jobcontract"] ) or 0
				if contracttime > 0 then
					outputChatBox( "You need to wait " .. contracttime .. " payday(s) before you can leave your job.", source, 255, 0, 0)
				else
					setElementData(source, "job", 0)
					mysql:query_free("UPDATE characters SET job=0 WHERE id = " .. getElementData(source, "dbid") )
					if job == 4 then
						setElementData(source, "tag", 1)
						mysql:query_free("UPDATE characters SET tag=1 WHERE id = " .. getElementData(source, "dbid") )
					end
					
					triggerClientEvent(source, "quitJob", source, job)
				end
			else
				outputDebugString( "QuitJob: SQL error" )
			end
		end
	end
end

addCommandHandler("endjob", quitJob, false, false)
addCommandHandler("quitjob", quitJob, false, false)

function resetContract( thePlayer, commandName, targetPlayerName )
	if exports.global:isPlayerAdmin( thePlayer ) then
		if targetPlayerName then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if targetPlayer then
				if getElementData( targetPlayer, "loggedin" ) == 1 then
					local result = mysql:query_free("UPDATE characters SET jobcontract = 0 WHERE id = " .. getElementData( targetPlayer, "dbid" ) .. " AND jobcontract > 0" )
					if result then
						outputChatBox( "Reset Job Contract for " .. targetPlayerName, thePlayer, 0, 255, 0 )
					else
						outputChatBox( "Failed to reset Job Contract Time.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14 )
		end
	end
end
addCommandHandler("resetcontract", resetContract, false, false)