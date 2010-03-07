mysql = exports.mysql

addEventHandler( "onResourceStart", getResourceRootElement(),
	function()
		-- delete all old wiretransfers
		mysql:query_free("DELETE FROM wiretransfers WHERE time < NOW() - INTERVAL 2 WEEK" )
	end
)

bankPickup = createPickup(2356.2719, 2361.5007, 2022.5257, 3, 1274)
exports.pool:allocateElement(bankPickup)
local shape = getElementColShape(bankPickup)
setElementInterior(shape, 3)
setElementInterior(bankPickup, 3)

function pickupUse(thePlayer)
	cancelEvent()
	
	local faction_id = tonumber( getElementData(thePlayer, "faction") )
	local faction_leader = tonumber( getElementData(thePlayer, "factionleader"))
		
	local isInFaction = false
	local isFactionLeader = false
		
	if (faction_id>0) then
		isInFaction = true
	end
		
	if (faction_leader==1) then
		isFactionLeader = true
	end
		
	local faction = getPlayerTeam(thePlayer)
	local money = exports.global:getMoney(faction)
	triggerClientEvent(thePlayer, "showBankUI", bankPickup, isInFaction, isFactionLeader, money, true, 0)
end
addEventHandler("onPickupHit", bankPickup, pickupUse)

function withdrawMoneyPersonal(amount)
	local money = getElementData(source, "bankmoney") - amount
	if money >= 0 then
		exports.global:giveMoney(source, amount)
		
		setElementData(source, "bankmoney", money)
		saveBank(source)
		
		mysql:query_free("INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (0, " .. getElementData(source, "dbid") .. ", " .. -amount .. ", '', 0)" )

		outputChatBox("You withdraw " .. amount .. "$ from your personal account.", source, 255, 194, 14)
	else
		outputChatBox( "No.", source, 255, 0, 0 )
	end
end
addEvent("withdrawMoneyPersonal", true)
addEventHandler("withdrawMoneyPersonal", getRootElement(), withdrawMoneyPersonal)

function depositMoneyPersonal(amount)
	if exports.global:takeMoney(source, amount) then
		local money = getElementData(source, "bankmoney")
		setElementData(source, "bankmoney", money+amount)
		saveBank(source)
		mysql:query_free("INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(source, "dbid") .. ", 0, " .. amount .. ", '', 1)" )
		outputChatBox("You deposited " .. amount .. "$ into your personal account.", source, 255, 194, 14)
	end
end
addEvent("depositMoneyPersonal", true)
addEventHandler("depositMoneyPersonal", getRootElement(), depositMoneyPersonal)

function withdrawMoneyBusiness(amount)
	local theTeam = getPlayerTeam(source)
	if exports.global:takeMoney(theTeam, amount) then
		if exports.global:giveMoney(source, amount) then
			mysql:query_free("INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(theTeam, "id") .. ", " .. getElementData(source, "dbid") .. ", " .. amount .. ", '', 4)" ) 
			outputChatBox("You withdraw " .. amount .. "$ from your business account.", source, 255, 194, 14)
		end
	end
end
addEvent("withdrawMoneyBusiness", true)
addEventHandler("withdrawMoneyBusiness", getRootElement(), withdrawMoneyBusiness)

function depositMoneyBusiness(amount)
	if exports.global:takeMoney(source, amount) then
		local theTeam = getPlayerTeam(source)
		if exports.global:giveMoney(theTeam, amount) then
			mysql:query_free("INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(source, "dbid") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 5)" )
			outputChatBox("You deposited " .. amount .. "$ into your business account.", source, 255, 194, 14)
		end
	end
end
addEvent("depositMoneyBusiness", true)
addEventHandler("depositMoneyBusiness", getRootElement(), depositMoneyBusiness)

function transferMoneyToPersonal(business, name, amount, reason)
	reason = mysql:escape_string(reason)
	local reciever = getPlayerFromName(string.gsub(name," ","_"))
	local dbid = nil
	if not reciever then
		local result = mysql:query("SELECT id FROM characters WHERE charactername='" .. mysql:escape_string(string.gsub(name," ","_")) .. "' LIMIT 1")
		if result then
			if mysql:num_rows(result) > 0 then
				local row = mysql:fetch_assoc(result)
				dbid = tonumber(row["id"])
				found = true
			end
			mysql:free_result(result)
		else
			outputDebugString("s_bank_system.lua: mysql:query failed", 1, 255, 0, 0)
		end
	else
		dbid = getElementData(reciever, "dbid")
	end
	
	if not dbid and not reciever then
		outputChatBox("Player not found. Please enter the full character name.", source, 255, 0, 0)
	else
		if business then
			local theTeam = getPlayerTeam(source)
			if exports.global:takeMoney(theTeam, amount) then
				mysql:query_free("INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. ( -getElementData( theTeam, "id" ) ) .. ", " .. dbid .. ", " .. amount .. ", '" .. reason .. "', 3)" )
			end
		else
			if reciever == source then
				outputChatBox("You can't wiretransfer money to yourself.", source, 255, 0, 0)
				return
			end
			if getElementData(source, "bankmoney") - amount >= 0 then
				setElementData(source, "bankmoney", getElementData(source, "bankmoney") - amount)
				mysql:query_free("INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. getElementData(source, "dbid") .. ", " .. dbid .. ", " .. amount .. ", '" .. reason .. "', 2)" ) 
			else
				outputChatBox( "No.", source, 255, 0, 0 )
				return
			end
		end
		
		if reciever then
			setElementData(reciever, "bankmoney", getElementData(reciever, "bankmoney") + amount)
			saveBank(reciever)
		else
			mysql:query_free("UPDATE characters SET bankmoney=bankmoney+" .. amount .. " WHERE id=" .. dbid)
		end
		triggerClientEvent(source, "hideBankUI", source)
		outputChatBox("You transfered " .. amount .. "$ from your "..(business and "business" or "personal").." account to "..name..(string.sub(name,-1) == "s" and "'" or "'s").." account.", source, 255, 194, 14)
		
		saveBank(source)
	end
end
addEvent("transferMoneyToPersonal", true)
addEventHandler("transferMoneyToPersonal", getRootElement(), transferMoneyToPersonal)

-- TRANSACTION HISTORY STUFF

--[[
	Transaction Types:
	0: Withdraw Personal
	1: Deposit Personal
	2: Transfer from Personal to Personal
	3: Transfer from Business to Personal
	4: Withdraw Business
	5: Deposit Business
	6: Wage/State Benefits
	7: everything in payday except Wage/State Benefits
	8: faction budget
]]

function tellTransfersPersonal()
	local dbid = getElementData(source, "dbid")
	tellTransfers(source, dbid, "recievePersonalTransfer")
end

function tellTransfersBusiness()
	local dbid = tonumber(getElementData(getPlayerTeam(source), "id")) or 0
	if dbid > 0 then
		tellTransfers(source, -dbid, "recieveBusinessTransfer")
	end
end

function tellTransfers(source, dbid, event)
	local where = "( `from` = " .. dbid .. " OR `to` = " .. dbid .. " )"
	if dbid < 0 then
		where = where .. " AND type != 6" -- skip paydays for factions 
	else
		where = where .. " AND type != 4 AND type != 5" -- skip stuff that's not paid from bank money
	end
	
	-- `w.time` - INTERVAL 1 hour as 'newtime'
	-- hour correction
	
	local query = mysql:query("SELECT w.*, a.charactername as characterfrom, b.charactername as characterto,w.`time` - INTERVAL 1 hour as 'newtime' FROM wiretransfers w LEFT JOIN characters a ON a.id = `from` LEFT JOIN characters b ON b.id = `to` WHERE " .. where .. " ORDER BY id DESC LIMIT 40")
	if query then
		local continue = true
		while continue do
			row = mysql:fetch_assoc(query)
			if not row then break end
			
			local id = tonumber(row["id"])
			local amount = tonumber(row["amount"])
			--local time = row[6]
			local time = row["newtime"]
			local type = tonumber(row["type"])
			local reason = row["reason"]
			if reason == mysql_null() then
				reason = ""
			end
			
			local from, to = "-", "-"
			if row["characterfrom"] ~= mysql_null() then
				from = row["characterfrom"]:gsub("_", " ")
			elseif tonumber(row["from"]) then
				num = tonumber(row["from"]) 
				if num < 0 then
					from = getTeamName(exports.pool:getElement("team", -num))
				elseif num == 0 and ( type == 6 or type == 7 ) then
					from = "Government"
				end
			end
			if row["characterto"] ~= mysql_null() then
				to = row["characterto"]:gsub("_", " ")
			elseif tonumber(row["to"]) and tonumber(row["to"]) < 0 then
				to = getTeamName(exports.pool:getElement("team", -tonumber(row["to"])))
			end
			
			if type >= 2 and type <= 5 and tonumber(row[2]) == dbid then
				amount = -amount
			end
			
			if amount < 0 then
				amount = "-$" .. -amount
			else
				amount = "$" .. amount
			end
			
			triggerClientEvent(source, event, source, id, amount, time, type, from, to, reason)
		end
		mysql:free_result(query)
	else
		outputDebugString("Mysql error @ s_bank_system.lua\tellTransfers", 2)
	end
end

addEvent("tellTransfersPersonal", true)
addEventHandler("tellTransfersPersonal", getRootElement(), tellTransfersPersonal)

addEvent("tellTransfersBusiness", true)
addEventHandler("tellTransfersBusiness", getRootElement(), tellTransfersBusiness)

--

function saveBank( thePlayer )
	if getElementData( thePlayer, "loggedin" ) == 1 then
		mysql:query_free("UPDATE characters SET bankmoney=" .. (tonumber(getElementData( thePlayer, "bankmoney" )) or 0) .. " WHERE id=" .. getElementData( thePlayer, "dbid" ))
	end
end
