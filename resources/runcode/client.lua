local function runString (commandstring)
	-- some stuff we might need
	vehicle = getPedOccupiedVehicle(getLocalPlayer()) or getPedContactElement(getLocalPlayer())
	car = vehicle
	p = getPlayerFromName
	c = getPedOccupiedVehicle
	set = setElementData
	get = getElementData
	
	outputChatBoxR("Executing client-side command: "..commandstring)
	local notReturned
	--First we test with return
	local commandFunction,errorMsg = loadstring("return "..commandstring)
	if errorMsg then
		--It failed.  Lets try without "return"
		notReturned = true
		commandFunction, errorMsg = loadstring(commandstring)
	end
	if errorMsg then
		--It still failed.  Print the error message and stop the function
		outputChatBoxR("Error: "..errorMsg)
		return
	end
	--Finally, lets execute our function
	results = { pcall(commandFunction) }
	if not results[1] then
		--It failed.
		outputChatBoxR("Error: "..results[2])
		return
	end
	if not notReturned then
		local resultsString = ""
		local first = true
		for i = 2, #results do
			if first then
				first = false
			else
				resultsString = resultsString..", "
			end
			local resultType = type(results[i])
			if isElement(results[i]) then
				resultType = "element:"..getElementType(results[i])
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		outputChatBoxR("Command results: "..resultsString)
	elseif not errorMsg then
		outputChatBoxR("Command executed!")
	end
end

addEvent("doCrun", true)
addEventHandler("doCrun", getRootElement(), runString)

local function loadScripts()
	if getResourceFromName ( 'global' ) then 
		if exports.global:isPlayerScripter(getLocalPlayer()) then
			setElementData( getLocalPlayer(), "runcode:hideoutput", true )
			local client = xmlLoadFile( "autoload.lua" )
			if client then
				local children = xmlNodeGetChildren( client )
				if children then
					for k, v in ipairs( children ) do
						if xmlNodeGetName( v ) == "c" then
							triggerEvent("doCrun", getLocalPlayer(), xmlNodeGetValue( v ))
						elseif xmlNodeGetName( v ) == "s" then
							triggerServerEvent("doSrun", getLocalPlayer(), xmlNodeGetValue( v ))
						elseif xmlNodeGetName( v ) == "f" then
							injectScript( xmlNodeGetValue( v ) )
						end
					end
				end
			end
			setElementData( getLocalPlayer(), "runcode:hideoutput", false )
		end
	end
end
addEvent("runcode:loadScripts", true)
addEventHandler("runcode:loadScripts", getLocalPlayer(), loadScripts)
addEventHandler("onClientResourceStart", getResourceRootElement(), loadScripts)