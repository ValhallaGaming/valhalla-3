-- /fish to start fishing.
function startFishing(thePlayer)
	if (isElement(thePlayer)) then
		local logged = getElementData(thePlayer, "loggedin")
		if (logged==1) then
			local result = mysql:query_fetch_assoc("SELECT fish FROM characters WHERE id=" .. mysql:escape_string(getElementData(thePlayer, "dbid")))
			local oldcatch = tonumber(result["fish"])

			if not (thePlayer) then
				thePlayer = source
			end
			if not(exports.global:hasItem(thePlayer, 49)) then -- does the player have the fishing rod item?
				outputChatBox("You need a fishing rod to fish.", thePlayer, 255, 0, 0)
			else
				triggerClientEvent(thePlayer, "castLine", getRootElement(), oldcatch)
			end
		end
	end
end
addCommandHandler("fish", startFishing, false, false)
addEvent("fish")
addEventHandler("fish", getRootElement(), startFishing)

function theycasttheirline()
	exports.global:sendLocalMeAction(source,"casts their line.")
end
addEvent("castOutput", true)
addEventHandler("castOutput", getRootElement(), theycasttheirline)

function theyHaveABite()
	exports.global:sendLocalMeAction(source,"has a bite!")
end
addEvent("fishOnLine", true)
addEventHandler("fishOnLine", getRootElement(), theyHaveABite)


function lineSnap() ----- Snapped line.
	exports.global:takeItem(source, 49) -- fishing rod
	exports.global:sendLocalMeAction(source,"snaps their fishing line.")
end
addEvent("lineSnap",true)
addEventHandler("lineSnap", getRootElement(), lineSnap)

----- Successfully reeled in the fish.
function catchFish(fishSize, totalCatch)
	exports.global:sendLocalMeAction(source,"catches a fish weighing ".. fishSize .."lbs.")
	if (fishSize >= 100) then
		exports.global:givePlayerAchievement(source, 35)
	end
	mysql:query_free("UPDATE characters SET fish=" .. mysql:escape_string(tonumber(totalCatch)) .. " WHERE id=" .. mysql:escape_string(getElementData(source, "dbid")))
end
addEvent("catchFish", true)
addEventHandler("catchFish", getRootElement(), catchFish)

------ /sellfish
function unloadCatch( totalCatch, profit)
	exports.global:sendLocalMeAction(source,"sells " .. totalCatch .."lbs of fish.")
	exports.global:giveMoney(source, profit)
	mysql:query_free("UPDATE characters SET fish=0 WHERE id=" .. mysql:escape_string(getElementData(source, "dbid")))
end
addEvent("sellcatch", true)
addEventHandler("sellcatch", getRootElement(), unloadCatch)

------- give a hint when logging on
function fishingNotice()
	local result = mysql:query_fetch_assoc("SELECT fish FROM characters WHERE id=" .. mysql:escape_string(getElementData(source, "dbid")))
	local catch = tonumber(result["fish"])
	
	if catch > 0 then
		triggerClientEvent(source, "restoreFishingJob", source, catch)
	end
end
addEventHandler("restoreJob", getRootElement(), fishingNotice)