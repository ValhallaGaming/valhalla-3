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
				outputDebugString("GUILTY: " .. tostring(sourceClient))
				if (sourceClient) then
					-- revert data
					--changeProtectedElementDataEx(source, index, oldValue, true)
					local newData = getElementData(source, index)
					-- Get rid of the player
					local msg = "[AdmWarn] " .. getPlayerName(sourceClient) .. " sent illegal data (index: "..index .." newvalue:".. tostring(newData) .. " oldvalue:".. tostring(oldValue)  ..")"
					exports.global:sendMessageToAdmins(msg)
					exports.logs:logMessage(msg, 4)
					-- uncomment this when it works
					--local ban = banPlayer(sourceClient, true, false, false, getRootElement(), "Hacked Client.", 0)
				end
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