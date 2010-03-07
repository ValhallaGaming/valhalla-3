local myadminWindow = nil

function adminhelp (sourcePlayer, commandName)

    local sourcePlayer = getLocalPlayer()
    local adminLevel = getElementData(sourcePlayer, "adminlevel")
    if (adminLevel > 0) then
        if (myadminWindow == nil) then
            guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
            myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Index of admin commands v5", false)
            local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
            local lists = {}
			for level = 1, 6 do 
				local tab = guiCreateTab("Level " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Command", 0.15)
				guiGridListAddColumn (lists[level], "Syntax", 0.35)
				guiGridListAddColumn (lists[level], "Explanation", 1.3)
			end
            local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button

			local commands =
			{
				-- level 1: Trial Admin
				{
					-- player/*
					{ "/adminlounge", "/adminlounge", "Chill out in the lounge" },
					{ "/forceapp", "/forceapp [player]", "forced the player to reapply at the UCP" },
					{ "/check", "/check [player]", "retrieves specified player's information" },
					{ "/stats", "/stats [player]", "shows players vehicle id's, languages etc" },
					{ "/history", "/history [player]", "checks the admin history of the player" },
					{ "/auncuff", "/auncuff [player]", "uncuffs the player" },
					{ "/mute", "/mute [player]", "mutes the player" },
					{ "/disarm", "/disarm [player]", "takes all weapon from the player" },
					{ "/freconnect", "/freconnect [player]", "reconnects the player" },
					{ "/giveitem", "/giveitem [player] [item id] [item value]", "gives the player the specified item, see /itemlist for ids" },
					{ "/sethp", "/sethp [player] [new hp]", "sets the health of the player" },
					{ "/setarmor", "/setarmor [player] [new armor]", "sets the armor of the player" },
					{ "/setskin", "/setskin [player] [skin id]", "sets the skin of a player" },
					{ "/changename", "/changename [player] [new character name]", "changes the character name" },
					{ "/slap", "/slap [player]", "drops the player from a height of 15" },
					{ "/hugeslap", "/hugeslap [player]", "drops the player from a height of 50" },
					{ "/recon", "/recon [player]", "spectate a player" },
					{ "/fuckrecon", "/stoprecon", "forces recon to stop" },
					{ "/pkick", "/pkick [player] [reason]", "kicks the player from the server" },
					{ "/pban", "/pban [player] [hours] [reason]", "bans the player for the given time, specify 0 as hours for permanent ban" },
					{ "/unban", "/unban [full char name]", "unbans the player with the given character name" },
					{ "/unbanip", "/unbanip [ip]", "unbans the specified ip" },
					{ "/gotoplace", "/gotoplace [ls/sf/lv]", "teleports you to one of those 3 cities" },
					{ "/jail", "/jail [player] [minutes] [reason]", "jails the player, if minutes >= 999 it's permanent" },
					{ "/unjail", "/unjail [player]", "unjails the player" },
					{ "/jailed", "/jailed", "shows a list of players that are in adminjail, including time left and reason" },
					{ "/goto", "/goto [player]", "teleport to another player" },
					{ "/gethere", "/gethere [player]", "teleports the player to you" },
					{ "/sendto", "/gethere [player] [dest. player]", "teleports a player to another one" },
					{ "/freeze", "/freeze [player]", "freezes the player" },
					{ "/unfreeze", "/unfreeze [player]", "unfreezes the player" },
					{ "/mark", "/mark", "saves your current position" },
					{ "/gotomark", "/gotomark", "teleports to the position where you did /mark" },
					{ "/makedonator", "/makedonator [player] [level]", "changes the player's donator level" },
					{ "/adminduty", "/adminduty", "(un)marks you as admin on duty" },
					{ "/setmotd", "/setmotd [message]", "updates the message of the day" },
					{ "/warn", "/warn [player]", "issues a warning, player is banned when having 3 warnings" },
					{ "/showinv", "/showinv [player]", "views the inventory of the player" },
					{ "/togmytag", "/togmytag", "toggles your nametag on and off" },
					{ "/dropme", "/dropme", "drops you off at the current freecam position" },
					{ "/disappear", "/disappear", "toggles invisibility" },
					{ "/findalts", "/findalts [player]", "shows all characters the player has" },
					{ "/setlanguage", "/setlanguage [player] [language] [skill]", "adjusts the skill of a player's language, or learns it to him" },
					{ "/dellanguage", "/dellanguage [player] [language]", "deletes a language from the player's knowledge" },
					{ "/aunblindfold", "/aunblindfold [player]", "unblindfold the player" },
					{ "/givelicense", "/givelicense [player] [type]", "gives the player a license" },
					-- vehicle/*
					{ "/carlist", "/carlist", "Shows an list with vehicle id's and colors" },
					{ "/unflip", "/unflip", "unflips the car" },
					{ "/unlockcivcars", "/unlockcivcars", "unlocks all civilian vehicles" },
					{ "/oldcar", "/oldcar", "retrieves the id of the last car you drove" },
					{ "/thiscar", "/thiscar", "retrieves the id of your current car" },
					{ "/gotocar", "/gotocar [id]", "teleports you to the car with that id" },
					{ "/getcar", "/getcar [id]", "teleports the car to you" },
					{ "/nearbyvehicles", "/nearbyvehicles", "shows all vehicles within a radius of 20" },
					{ "/respawnveh", "/respawnveh [id]", "respawns the vehicle with that id" },
					{ "/respawnall", "/respawnall", "respawns all vehicles" },
					{ "/respawnciv", "/respawnciv", "respawns all civilian (job) vehicles" },
					{ "/addupgrade", "/addupgrade [player] [upgrade id]", "upgrades a players car" },
					{ "/resetupgrades", "/resetupgrades [player]", "removes all upgrades on the player's car" },
					{ "/findveh", "/findveh [name]", "retrieves the model for that vehicle name" },
					{ "/fixveh", "/fixveh [player]", "repairs a player's vehicle" },
					{ "/fixvehs", "/fixvehs", "repairs all vehicles" },
					{ "/fixvehis", "/fixvehis [player]", "fixes the vehicles look, engine may remain broken" },
					{ "/blowveh", "/blowveh [player]", "blows up a players car" },
					{ "/setcarhp", "/setcarhp [player]", "sets the health of a car, full health is 1000." },
					{ "/fuelveh", "/fuelveh [player]", "refills a players vehicle" },
					{ "/fuelvehs", "/fuelvehs", "refills all vehicles" },
					{ "/setcolor", "/setcolor [player] [color 1] [color 2]", "changes the players vehicle colors" },

					-- interior/*
					{ "/getpos", "/getpos", "outputs your current position, interior and dimension" },
					{ "/x", "/x [value]", "increases your x-coordinate by the given value" },
					{ "/y", "/z [value]", "increases your y-coordinate by the given value" },
					{ "/z", "/y [value]", "increases your z-coordinate by the given value" },
					{ "/set*", "/set[any combination of xyz] [coordinates]", "sets your coordinates - available combinations: x, y, z, xyz, xy, xz, yz" },
					{ "/setinteriorexit", "/setinteriorexit  [Interior ID] [TYPE] [Cost] [Name]","adds an interior" },
					{ "/reloadinterior", "/reloadinterior [id]","reloads an interior from the database" },
					{ "/nearbyinteriors", "/nearbyinteriors","shows nearby interiors" },
					{ "/setinteriorname", "/setinteriorname [newname]","changes an interior name" },
					{ "/setfee", "/setfee [amount]","sets an fee on entering the interior" },
					{ "/getinteriorid", "/getinteriorid","Gets the interior id"},
					
					-- election/*
					{ "/addcandidate", "/addcandidate", "add's player to election vote list" },
					{ "/delcandidate", "/delcandidate", "deletes a player to election vote list" },
					{ "/showresults", "/showresults", "shows the results of the election" },
					
					-- factions/*
					{ "/makefaction", "/makefaction [type] [name]", "creates a faction" },
					{ "/renamefaction", "/renamefaction [id] [new name]", "renames a faction" },
					{ "/setfaction", "/setfaction [id] [factionid]", "puts an player into a faction" },
					{ "/delfaction", "/delfaction [id]", "deletes a faction" },
					{ "/showfactions", "/showfactions", "shows a list with factions" },

					{ "/resetbackup", "/resetbackup", "Resets PD's backup system" },
					{ "/resettowbackup", "/resettowbackup", "Resets towing backup system" },
					{ "/aremovespikes", "/aremovespikes", "Removes all the PD spikes" },
					{ "/clearnearbytag", "/clearnearbytag", "Clears nearby tag" },
		
					{ "/changelock", "/changelock", "changes the lock from the vehicle/interior" },		
					{ "/restartgatekeepers", "/restartgatekeepers", "restarts the gatekeepers resource" }
				},
				-- level 2: Admin
				{
					{ "/superman", "/superman", "activates superman" },
					{ "/gotohouse", "/gotohouse [id]", "teleports to the house" },
					-- vehicles
					{ "/veh", "/veh [model] [color 1] [color 2]", "spawns a temporary vehicle" },
					{ "/delveh", "/delveh [id]", "removes the temporary vehicle with that id" },
					{ "/delthisveh", "/delthisveh", "removes the temporary vehicle" },
					
				},
				-- level 3: Super Admin
				{
					{ "/setweather", "/setweather", "change the weather" }
				},
				-- level 4: Lead Admins
				{
					{ "/delveh", "/delveh [id]", "removes the (temporary) vehicle with that id" },
					{ "/delthisveh", "/delthisveh", "removes the (temporary) vehicle" },
					{ "/addatm", "/addatm", "adds an ATM at this spot" },
					{ "/delatm", "/delatm [id]", "deletes an ATM with the id" },
					{ "/nearbyatms", "/nearbyatms", "shows the nearby ATMs" },
					{ "/bigears", "/bigears [player]", "hook yourself between someone's chats" },
					{ "/bigearsf", "/bigearsf [factionid]", "hook yourself between faction chats" },
					{ "/nearbyatms", "/nearbyatms", "shows the nearby ATMs" },
					
					-- objects/*
					{ "/addobject", "/addelevator [objectid]", "creates an object" },
					{ "/nearbyobjects", "/nearbyobjects", "shows nearby objects" },
					{ "/delobject", "/delobject [id]", "deletes an object" },
					
					-- paynspray/*
					{ "/addpaynspray", "/addpaynspray", "creates an pay n spray" },
					{ "/nearbypaynsprays", "/nearbypaynsprays", "shows nearby pay n sprays" },
					{ "/delpaynspray", "/delpaynspray [id]", "deletes an pay n spray" },
					
					-- phone/*
					{ "/addphone", "/addphone", "creates a public phone" },
					{ "/nearbyphones", "/nearbyphones", "shows nearby public phone" },
					{ "/delphone", "/delphone [id]", "deletes a public phone" },
					
					-- interiors/*
					{ "/addelevator", "/addelevator [interior] [dimension] [x] [y] [z]", "creates an elevator" },
					{ "/delelevator", "/delelevator [id]", "deletes an elevator" },
					{ "/nearbyelevators", "/nearbyelevators", "shows nearby elevators" },
					{ "/toggleelevator", "/toggleelevator [id]", "enables/disables an elevator" },
					{ "/enableallelevators", "/enableallelevators", "enables all elevators" },
					
					{ "/addinterior", "/addinterior  [Interior ID] [TYPE] [Cost] [Name]","adds an interior" },
					{ "/sellproperty", "/sellproperty","sells an interior" },
					{ "/delinterior", "/delproperty","deletes an interior" },
					{ "/getinteriorid", "/getinteriorid [id]","shows the current interior" },
					{ "/setinteriorid", "/setinteriorid [id]","changes the interior" },
					{ "/getinteriorprice", "/getinteriorprice","shows the interiors price" },
					{ "/setinteriorprice", "/setinteriorprice [price]","changes the interiors price" },
					{ "/toggleinterior", "/toggleinterior [id]","sets the interior enabled or disabled" },
					{ "/enableallinteriors", "/enableallinteriors","enables all the interiors" },
					
					-- factions/*
					{ "/setfactionleader", "/setfactionleader [id] [factionid]", "puts a player into a faction and makes the player leader" },
					
					-- fuelpoints/*
					{ "/addfuelpoint", "/addfuelpoint", "creates a new fuelpoint" },
					{ "/nearbyfuelpoints", "/nearbyfuelpoints", "shows nearby fuelpoints" },
					{ "/delfuelpoint", "/delfuelpoint [id]", "deletes a fuelpoint" },
					
					-- player/*
					{ "/reskick", "/reskick [amount]", "kicks the given amount of players from the server" },
					{ "/ck", "/ck [player]", "permanently kills the character; spawns a corpse at the location the player is at" },
					{ "/unck", "/unck [player]", "reverts a character kill" },
					{ "/bury", "/bury [player]", "buries the player; removes the ck corpse" },
					{ "/givegun", "/givegun [player] [weapon id] [ammo]", "gives the player the specified weapon" },
					{ "/setmoney", "/setmoney [player] [money]", "sets the players money to that value" },
					{ "/givemoney", "/givemoney [player] [money]", "gives the player money in addition to his current cash" },
					{ "/delveh", "/delveh [id]", "removes the vehicle with that id" },
					{ "/delthisveh", "/delthisveh", "removes the vehicle you currently occupy" },
					{ "/resetcharacter", "/resetcharacter [Firstname_Lastname]", "fully resets the character" }
				},
				-- level 5: Head Admins
				{
					-- player/*
					{ "/hideadmin", "/hideadmin", "toggles hidden/visible the admin status" },
					{ "/ho", "/ho [text]", "send global ooc as hidden admin" },
					{ "/hw", "/hw [player] [text]", "send a pm as hidden admin" },
					{ "/makeadmin", "/makeadmin [player] [rank]", "gives the player an admin rank" },
					
					-- election/*
					{ "/resetpoll", "/resetpoll", "resets the election poll" },
					{ "/openpoll", "/openpoll", "opens the election poll" },
					{ "/closepoll", "/closepoll", "closes the election poll" },
					
					-- resource/*
					{ "/startres", "/startres [resource name]", "starts the resource" },
					{ "/stopres", "/stopres [resource name]", "stops the resource" },
					{ "/restartres", "/restartres [resource name]", "restarts the resource" }
				},
				-- level 6: Owner
				{
				}
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( lists[level] )
					guiGridListSetItemText ( lists[level], row, 1, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 2, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 3, "There are currently no commands specific to this level.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( lists[level] )
						guiGridListSetItemText ( lists[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( lists[level], row, 2, command[2], false, false)
						guiGridListSetItemText ( lists[level], row, 3, command[3], false, false)
					end
				end
			end
			
            addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
                if (button == "left") then
                    if (state == "up") then
                        guiSetVisible(myadminWindow, false)
                        showCursor (false)
                        guiSetInputEnabled(false)
                        myadminWindow = nil
                    end
                end
            end, false)

            guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
        else
            local visible = guiGetVisible (myadminWindow)
            if (visible == false) then
                guiSetVisible( myadminWindow, true)
                showCursor (true)
			else
				showCursor(false)
			end
        end
    end
end
addCommandHandler("ah", adminhelp)