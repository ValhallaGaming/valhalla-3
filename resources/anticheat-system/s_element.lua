addEventHandler("onResourceStart", getResourceRootElement(), 
	function ()
		exports.global:sendMessageToAdmins("[STATUS] Running Hacked Client Shield.")
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
				local sourceClient = client
				if (sourceClient) then
					cancelEvent()
					local newData = getElementData(source, index)
					local playername = getPlayerName(source) or "Somethings"
					-- Get rid of the player
					local msg = "[AdmWarn] " .. getPlayerName(sourceClient) .. " sent illegal data. Player has been banned."
					local msg2 = " (victim: "..playername.." index: "..index .." newvalue:".. tostring(newData) .. " oldvalue:".. tostring(oldValue)  ..")"
					exports.global:sendMessageToAdmins(msg)
					exports.global:sendMessageToAdmins(msg2)
					exports.logs:logMessage(msg..msg2, 29)
					
					-- uncomment this when it works
					local ban = banPlayer(sourceClient, true, false, false, getRootElement(), "Hacked Client.", 0)
					
					-- revert data
					--changeProtectedElementDataEx(source, index, oldValue, true)
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
	if (thePlayer) and (index) and (newvalue) then
		allowElementData(thePlayer, index)
		if (sync) then
			setElementData(thePlayer, index, newvalue, sync)
		else
			setElementData(thePlayer, index, newvalue)
		end
		protectElementData(thePlayer, index)
		return true
	end
	return false
end