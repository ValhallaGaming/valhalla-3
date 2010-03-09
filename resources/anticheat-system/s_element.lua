-- things to protect from clients:
mysql = exports.mysql

addEventHandler("onResourceStart", getResourceRootElement(), 
	function ()
		exports.global:sendMessageToAdmins("[ANTICHEAT] Project Codename 'no-homo' loaded.")
	end
);

addEventHandler("onElementDataChange", getRootElement(), 
	function (index, oldValue)
		local theElement = source
		if (getElementType(theElement) == "player") then
			local isProtected = getElementData(theElement, "p:"..index)
			if (isProtected) then
				-- get real source here
				-- it aint source!
				local sourceClient = source
				
				-- revert data
				setElementData(source, index, oldValue)
				
				-- Get rid of the player
				exports.global:sendMessageToAdmins("[AdmWarn] " .. getPlayerName(sourceClient) .. " sent illegal data")
				exports.logs:logMessage("[AdmWarn] ".. getPlayerIP(sourceClient) .. "/" .. getPlayerName(sourceClient) .. " was banned for manipulating protected data. (Possible hacked client)", 4)
				-- uncomment this when it works
				--local ban = banPlayer(sourceClient, true, false, false, getRootElement(), "Hacked Client.", 0)
			end
		end
	end
);

addEventHandler ( "onPlayerJoin", getRootElement(), 
	function () 
		protectElementData(source, "adminlevel")
		protectElementData(source, "donatorlevel")
		protectElementData(source, "gameaccountid")
		protectElementData(source, "gameaccountusername")
		protectElementData(source, "legitnamechange")
		protectElementData(source, "dbid")
	end
);

function allowElementData(thePlayer, index)
	setElementData(thePlayer, "p:"..index, false, false)
end

function protectElementData(thePlayer, index)
	setElementData(thePlayer, "p:"..index, true, false)
end

function changeProtectedElementData(thePlayer, index, newvalue)
	allowElementData(thePlayer, index)
	setElementData(thePlayer, index, newvalue)
	protectElementData(thePlayer, index)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync)
	allowElementData(thePlayer, index)
	if (sync) then
		setElementData(thePlayer, index, newvalue, sync)
	else
		setElementData(thePlayer, index, newvalue)
	end
	protectElementData(thePlayer, index)
end