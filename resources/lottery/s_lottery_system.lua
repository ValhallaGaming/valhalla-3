mysql = exports.mysql

function correctTime(res)
	local hour, minutes = getTime()
	if hour == 18 and minutes == 00 then
		drawLottery()
	else
		local minutesLeft = 60 - minutes
		local hoursLeft = 17 - hour
		if hoursLeft < 0 then
			drawTime = ((hoursLeft*60)+1440) + minutesLeft
		else
			drawTime = (hoursLeft*60) + minutesLeft
		end
		drawTimer = setTimer ( drawLottery, drawTime*60000, 1 )
		outputDebugString("Lottery will be drawn in "..drawTime.." minutes.")		
		drawTime = 0
	end
	
	-- check for lottery setting
	local result = mysql:query("SELECT value FROM settings WHERE name = 'lotteryjackpot'" )
	if result then
		if mysql:num_rows(result) == 0 then
			mysql:query_free("INSERT INTO settings (name, value) VALUES ('lotteryjackpot', 0)")
		end
		mysql:free_result( result )
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), correctTime)

function giveTicket(aPlayer)
	local PlayerID = getElementData(aPlayer, "dbid")
	local ticketNumber = tostring(math.random(1000, 9999))
	local result = mysql:query("SELECT characterid FROM lottery WHERE ticketnumber = " .. ticketNumber )
	if (mysql:num_rows(result) == 0) then
		mysql:free_result( result )
		mysql:query_free( "INSERT INTO lottery (characterid, ticketnumber) VALUES (" .. PlayerID .. ", " .. ticketNumber .. " )" ) 
		mysql:query_free( "UPDATE settings SET value = value + 30 WHERE name = 'lotteryjackpot'" ) 
		return tonumber(ticketNumber), 40 -- should be above the value + xxx
	else
		mysql:free_result( result )
		local result = mysql:query_fetch_assoc("SELECT COUNT(*) as tickets FROM lottery" )
		if result then
			if tonumber( result["tickets"] ) >= 8999 then
				return false
			end
			
		else
			return giveTicket(aPlayer)
		end
	end
end

function drawLottery()
	local query = mysql:query_fetch_assoc("SELECT value FROM settings WHERE name = 'lotteryjackpot'")
	local jackpot = query["value"]
	
	local drawNumbers = tostring(math.random(1000, 9999))
	local result = mysql:query("SELECT characterid as id, c.charactername as name FROM lottery l LEFT JOIN characters c ON l.characterid = c.id  WHERE ticketnumber = " .. drawNumbers)
	if (mysql:num_rows(result) ~= 0) then
		local row = mysql:fetch_assoc(result)
		local charid = row["id"]
		local charname = row["name"]
		local player = getPlayerFromName(charname)
		if player then
			local bankmoney = getElementData(player, "bankmoney")
			setElementData(player, "bankmoney", bankmoney+jackpot)
		else
			mysql:query_free("UPDATE characters SET bankmoney=bankmoney+" .. jackpot .. " WHERE id=" .. charid)
		end
		mysql:query_free( "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (0, " .. charid .. ", " .. jackpot .. ", 'Won lottery', 3)" )
		mysql:query_free( "UPDATE settings SET value = 0 WHERE name = 'lotteryjackpot'" )
		outputChatBox("* [LOTTERY] The winner of the lottery is: " .. charname:gsub("_", " ") .. "! The Jackpot of $" .. jackpot .. " will be transfered to his/her account.", getRootElement(), 0, 255, 0)
	else
		outputChatBox("* [LOTTERY] Nobody wins. The jackpot of $" .. jackpot .. " has been accumulated.", getRootElement(), 255, 255, 0)
	end
	drawTimer2 = setTimer ( drawLottery, 86400000, 1 )
	mysql:free_result(result)
	
	mysql:query_free("TRUNCATE TABLE lottery")
	call( getResourceFromName( "item-system" ), "deleteAll", 68 )
end

addCommandHandler( "forcedrawlottery", function( thePlayer ) if exports.global:isPlayerLeadAdmin( thePlayer ) then drawLottery() end end )