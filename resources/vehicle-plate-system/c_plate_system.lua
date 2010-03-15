local gabby = createPed(150, 1472.7734375, -1768.6142578125, 1250.9575195313)
setPedRotation(gabby, 266.27145385742)
setElementDimension(gabby, 125)
setElementInterior(gabby, 3)
setElementData(gabby, "talk", 1)
setElementData(gabby, "name", "Gabrielle McCoy")
setPedFrozen(gabby, true)
setPedAnimation(gabby, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false)

local plateCheck, newplates, efinalWindow = nil

function cBeginGUI()
	local lplayer = getLocalPlayer()
	triggerServerEvent("platePedTalk", lplayer, 1)
	
	local width, height = 100, 50
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)		

	greetingWindow = guiCreateWindow(x, y, width, height, "Are You?", false)
	
	local width2, height2 = 10, 10
	local x = scrWidth/2 - (width2/2)
	local y = scrHeight/2 - (height2/2)	
	
	--Buttons
	yes = guiCreateButton(0.10, 0.50, 0.30, 0.50, "Yes", true, greetingWindow)
	addEventHandler("onClientGUIClick", yes, PlateWindow)
	--Buttons
	no = guiCreateButton(0.60, 0.50, 0.30, 0.50, "No", true, greetingWindow)
	addEventHandler("onClientGUIClick", no, closeWindow)
	
	--Quick Settings
	guiWindowSetSizable(greetingWindow, false)
	guiWindowSetMovable(greetingWindow, true)
	guiSetVisible(greetingWindow, true)
	showCursor(true)
end
addEvent("cBeginPlate", true)
addEventHandler("cBeginPlate", getRootElement(), cBeginGUI)

function PlateWindow()
	local lplayer = getLocalPlayer()
	if (source==yes) then
			destroyElement(greetingWindow)
			local lplayer = getLocalPlayer()
			
			triggerServerEvent("platePedTalk", lplayer, 3)	
			
			local width, height = 300, 400
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)
			
			mainVehWindow = guiCreateWindow(x, y, width, height, "Vehicle License Plate: Registration", false)
			
			guiCreateLabel(0.03, 0.08, 2.0, 0.1, "Which vehicle would you like to register plates for?", true, mainVehWindow)
			vehlist = guiCreateGridList(0.03, 0.15, 1, 0.73, true, mainVehWindow)
			
			ovid = guiGridListAddColumn(vehlist, "ID", 0.2)
			ov = guiGridListAddColumn(vehlist, "Owned Vehicles", 0.4)
			ovcp = guiGridListAddColumn(vehlist, "Current Plates", 0.3)
			
			local myid = getElementData(lplayer, "dbid")
			local av = getElementsByType("vehicle")
			if (tonumber(myid)) then
				for i,v in ipairs(av) do
					if (getElementData(v, "owner")) and (getElementData(v, "owner") == myid) then
						local row = guiGridListAddRow(vehlist)
						local vid = getElementData(v, "dbid")
						local vm = getElementModel(v)
						if (getVehicleType(vm) == "Automobile") or (getVehicleType(vm) == "Bike") or (getVehicleType(vm) == "Monster Truck") then
							--Create ID
							guiGridListSetItemText(vehlist, row, ovid, tostring(vid), false, false) --ID
							--Create Models
							guiGridListSetItemText(vehlist, row, ov, tostring(getVehicleNameFromModel(vm)), false, false) -- Model
							--Create Plates
							guiGridListSetItemText(vehlist, row, ovcp, tostring(getVehiclePlateText(v)), false, false) -- Plates
						end
					end
				end
			end

			--Buttons
			close = guiCreateButton(0.50, 0.90, 0.50, 0.10, "Exit Screen", true, mainVehWindow)
			addEventHandler("onClientGUIClick", close, closeWindow)
			
			--OnDoubleClick
			addEventHandler("onClientGUIDoubleClick", vehlist, editPlateWindow)
			
			--Quick Settings
			guiWindowSetSizable(mainVehWindow, false)
			guiWindowSetMovable(mainVehWindow, true)
			guiSetVisible(mainVehWindow, true)
			showCursor(true)
	end
end

function editPlateWindow()
	local sr, sc = guiGridListGetSelectedItem(vehlist)
	svnum = guiGridListGetItemText(vehlist, sr, sc)
	if (source==vehlist) and not (svnum=="") then
		local width, height = 250, 210
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		efinalWindow = guiCreateWindow(x, y, width, height, "Please suppy the proper information:", false)
		local mainT = guiCreateLabel(0.03, 0.08, 2.0, 0.1, "Registering plates for vehicle #" .. svnum .. ".", true, efinalWindow)
		guiLabelSetHorizontalAlign(mainT, nil, true)
	
		guiCreateLabel(0.03, 0.22, 2.0, 0.1, "Please enter your new plate:", true, efinalWindow)
		newplates = guiCreateEdit(0.03, 0.30, 2.0, 0.1, "", true, efinalWindow)
		guiEditSetMaxLength(newplates, 8)
		
		addEventHandler("onClientGUIChanged", newplates, checkPlate) 
		
		plateCheck = guiCreateLabel(0.03, 0.41, 2.0, 0.1, "Invalid plate", true, efinalWindow)
		guiLabelSetColor(plateCheck, 255, 0, 0)
		
		--Buttons
		finalx = guiCreateButton(0.25, 0.75, 0.50, 0.10, "Exit Screen", true, efinalWindow)
		addEventHandler("onClientGUIClick", finalx, closeWindow)
		submitNP = guiCreateButton(0.25, 0.60, 0.50, 0.10, "Submit Registration", true, efinalWindow)
		addEventHandler("onClientGUIClick", submitNP, getPlateNText)
		
		--Quick Settings
		guiSetInputEnabled(true)
		guiSetEnabled(mainVehWindow, false)
		guiWindowSetSizable(efinalWindow, false)
		guiWindowSetMovable(efinalWindow, true)
		guiSetVisible(efinalWindow, true)
		showCursor(true)
	end
end


function checkPlate()
	if (source==newplates) then
		local theText = guiGetText(source)
		
		local foundSpace, valid = false, true
		local lastChar, current = ' ', ''
		for i = 1, #theText do
			local char = theText:sub( i, i )
			if char == ' ' then -- it's a space
				if i == #theText then -- space at the end of name is not allowed
					valid = false
					break
				else
					foundSpace = true -- we have at least two name parts
				end
				
				if #current < 2 then -- check if name's part is at least 2 chars
					valid = false
					break
				end
				current = ''
			elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) then -- can have letters anywhere in the name
				current = current .. char
			elseif ( char >= '0' and char <= '9') then
				current = current .. char
			else -- unrecognized char (numbers, special chars)
				valid = false
				break
			end
			lastChar = char
		end
		
		destroyElement(plateCheck)
		if valid  and #theText < 9 and #current >= 4 then
			plateCheck = guiCreateLabel(0.03, 0.41, 2.0, 0.1, "Valid plate", true, efinalWindow)
			guiLabelSetColor(plateCheck, 0, 255, 0)
		else
			plateCheck = guiCreateLabel(0.03, 0.41, 2.0, 0.1, "Invalid plate", true, efinalWindow)
			guiLabelSetColor(plateCheck, 255, 0, 0)
		end
	end
end

function getPlateNText()
	if (source==submitNP) and (newplates) then	
		local data = guiGetText(newplates)
		local vehid = tonumber(svnum)
		triggerServerEvent("sNewPlates", getLocalPlayer(), data, vehid)
		
		guiSetInputEnabled(false)
		destroyElement(mainVehWindow)
		destroyElement(efinalWindow)
		showCursor(false)
	end
end

function closeWindow()
	if (source==close) then
		showCursor(false)
		destroyElement(mainVehWindow)
		toggleAllControls(true)
	elseif (source==no) then
		showCursor(false)
		destroyElement(greetingWindow)
		toggleAllControls(true)
		triggerServerEvent("platePedTalk", getLocalPlayer(), 4)
	elseif (source==finalx) then
		guiSetInputEnabled(false)
		destroyElement(mainVehWindow)
		destroyElement(efinalWindow)
		showCursor(false)
		toggleAllControls(true)
	end
end