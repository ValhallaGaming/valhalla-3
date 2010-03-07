mysql = exports.mysql

function onLicenseServer()
	local gender = getElementData(source, "gender")
	if (gender == 0) then
		exports.global:sendLocalText(source, "Officer Johnson says: Hello Sir, do you want to apply for a license?", nil, nil, nil, 10)
	else
		exports.global:sendLocalText(source, "Officer Johnson says: Hello Ma'am, do you want to apply for a license?", nil, nil, nil, 10)
	end
end

addEvent("onLicenseServer", true)
addEventHandler("onLicenseServer", getRootElement(), onLicenseServer)

function giveLicense(license, cost)
	if (license==1) then -- car drivers license
		local theVehicle = getPedOccupiedVehicle(source)
		setElementData(source, "realinvehicle", 0, false)
		removePedFromVehicle(source)
		respawnVehicle(theVehicle)
		setElementData(source, "license.car", 1)
		setElementData(theVehicle, "handbrake", 1, false)
		setVehicleFrozen(theVehicle, true)
		mysql:query_free("UPDATE characters SET car_license='1' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
		outputChatBox("Congratulations, you've passed the second part of your driving examination.", source, 255, 194, 14)
		outputChatBox("You are now fully licenses to drive on the public streets. You have paid the $350 processing fee.", source, 255, 194, 14)
		exports.global:takeMoney(source, cost)
	elseif (license==2) then
		setElementData(source, "license.gun", 1)
		mysql:free_result("UPDATE characters SET gun_license='1' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
		outputChatBox("You obtained your weapons license.", source, 255, 194, 14)
		exports.global:takeMoney(source, cost)
	end
end
addEvent("acceptLicense", true)
addEventHandler("acceptLicense", getRootElement(), giveLicense)

function payFee(amount)
	exports.global:takeMoney(source, amount)
end
addEvent("payFee", true)
addEventHandler("payFee", getRootElement(), payFee)

function passTheory()
	setElementData(source,"license.car",3) -- Set data to "theory passed"
	mysql:query_free("UPDATE characters SET car_license='3' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
end
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), passTheory)

function showLicenses(thePlayer, commandName, targetPlayer)
	local loggedin = getElementData(thePlayer, "loggedin")

	if (loggedin==1) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					outputChatBox("You have shown your licenses to " .. targetPlayerName .. ".", thePlayer, 255, 194, 14)
					outputChatBox(getPlayerName(thePlayer) .. " has shown you their licenses.", targetPlayer, 255, 194, 14)
					
					local gunlicense = getElementData(thePlayer, "license.gun")
					local carlicense = getElementData(thePlayer, "license.car")
					
					local guns, cars
					
					if (gunlicense<=0) then
						guns = "No"
					else
						guns = "Yes"
					end
					
					if (carlicense<=0) then
						cars = "No"
					elseif (carlicense==3)then
						cars = "Theory test passed"
					else
						cars = "Yes"
					end
					
					outputChatBox("~-~-~-~- " .. getPlayerName(thePlayer) .. "'s Licenses -~-~-~-~", targetPlayer, 255, 194, 14)
					outputChatBox("        Weapon License: " .. guns, targetPlayer, 255, 194, 14)
					outputChatBox("        Car License: " .. cars, targetPlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("showlicenses", showLicenses, false, false)


function checkDMVCars(player, seat)
	-- aka civilian previons
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and getElementModel(source) == 436 then
		if getElementData(player,"license.car") == 3 then
			outputChatBox("(( You can use 'J' to start the engine and /handbrake to release the handbrake. ))", player, 0, 255, 0)
		elseif seat > 0 then
			outputChatBox("(( This DMV Car is for the Driving Test only. ))", player, 255, 194, 14)
		else
			outputChatBox("(( This DMV Car is for the Driving Test only. ))", player, 255, 0, 0)
			cancelEvent()
		end
	end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), checkDMVCars)