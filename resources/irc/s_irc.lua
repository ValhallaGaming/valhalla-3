local server = "irc.gtanet.com"
local port = 6667
local username = "ValhallaGaming"
local channeladmins = "#Valhalla.admins"
local password = ""

local conn = { }
local count = 0
local distribute = 1
local lastmessage = nil
local lastmessagefrom = nil

function spawnBot(deaf)
	local id = count+1
	local nickname = username .. id
	conn[id] = ircOpen(server, port, nickname, channeladmins, password)
	count = id
	
	if (deaf) then
		ircRaw(conn[id], "MODE "..nickname.." +d")
	end
end

function initIRC()
	if not getElementData(getRootElement(), "irc:init") then
		ircInit()
		setElementData(getRootElement(), "irc:init", true, false)
	end
	--spawnBot(false)
	--spawnBot(true)
	--spawnBot(true)
	
	sendMessage("Server Started.")
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), initIRC)

function stopIRC()
	sendMessage("Server Stopped.")

	for id, connection in ipairs(conn) do
		ircDisconnect(connection)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), stopIRC)

function sendMessage(message)
	--[[if count > 0 then
		ircMessage(conn[distribute], channeladmins, tostring(message))
		
		distribute = distribute + 1
		if (distribute > count) then
			distribute = 1
		end
	end]]
end

function sendAdminMessage(message)
	--[[if count > 0 then
		ircMessage(conn[distribute], channeladmins, tostring(message))
		
		distribute = distribute + 1
		if (distribute > count) then
			distribute = 1
		end
	end]]
end

function sendRawCommand(command)
--[[
	if count > 0 then
		ircRaw(conn[distribute],tostring(command))

		distribute = distribute + 1
		if (distribute > count) then
			distribute = 1
		end
	end]]
end

function irc_onPrivMsg( szChannel, szNick, szText )
	if string.find( szNick, username ) == 1 then
		-- do nothing
	else
		if szChannel == channeladmins then
			if (szNick == lastmessagefrom) and (szText == lastmessage) then
				-- ignore the message
			else
				lastmessagefrom = szNick
				lastmessage = szText
				-- is it a command?
				if string.sub( szText, 1, 1 ) == "!" then
					processCommands( szChannel, szNick, szText )
				end
			end
		end
	end
end

function processCommands ( szChannel, szNick, szText )
	-- asay, broadcast to /a
	if string.find( szText, "!asay" ) == 1 then
		local message =  string.sub( szText, 7 )
		exports.logs:logMessage("[Admin Chat FROM IRC] " .. szNick .. ": " .. message, 3)
		sendAdminMessage("[IRC Admin Chat] " .. szNick .. ": " .. message)
		local players = exports.pool:getPoolElementsByType("player")
		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			
			if(exports.global:isPlayerAdmin(arrayPlayer)) and (logged==1) then
				outputChatBox("IRC Admin " .. szNick .. ": " .. message, arrayPlayer, 51, 255, 102)
			end
		end
	-- dumbass function
	elseif string.find( szText, "!players" ) == 1 then
		sendAdminMessage("4There are currently " .. getPlayerCount() .. " players connected" )
	end
end