local sounds = { }

-- Bind Keys required
function bindKeys(res)
	bindKey("n", "down", toggleSirens)
	
	for key, value in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(value) then
			if getElementData(value, "siren") then
				sounds[value] = playSound3D("siren.wav", 0, 0, 0, true)
				attachElements( sounds[value], value )
				setSoundVolume(sounds[value], 0.6)
				setSoundMaxDistance(sounds[value], 45)
			end
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeys)

function toggleSirens()
	local veh = getPedOccupiedVehicle(getLocalPlayer())
	
	if (veh) then
		if getElementData(veh, "siren") then
			setElementData(veh, "siren", false)
		elseif exports.global:hasItem(veh, 85) then
			setElementData(veh, "siren", true)
		end
	end
end

function streamIn()
	if getElementType( source ) == "vehicle" and getElementData( source, "siren" ) and not sounds[ source ] then
		sounds[source] = playSound3D("siren.wav", 0, 0, 0, true)
		attachElements( sounds[source], source )
		setSoundVolume(sounds[source], 0.6)
		setSoundMaxDistance(sounds[source], 45)
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function streamOut()
	if getElementType( source ) == "vehicle" and sounds[source] then
		destroyElement( source )
		sounds[ source ] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), streamOut)

function updateSirens( name )
	if name == "siren" and isElementStreamedIn( source ) and getElementType( source ) == "vehicle" then
		local attached = getAttachedElements( source )
		if attached then
			for key, value in ipairs( attached ) do
				if getElementType( value ) == "sound" and value ~= sounds[ source ] then
					destroyElement( value )
				end
			end
		end
		
		if not getElementData( source, name ) then
			if sounds[ source ] then
				destroyElement( sounds[ source ] )
				sounds[ source ] = nil
			end
		else
			if not sounds[ source ] then
				sounds[source] = playSound3D("siren.wav", 0, 0, 0, true)
				attachElements( sounds[source], source )
				setSoundVolume(sounds[source], 0.6)
				setSoundMaxDistance(sounds[source], 45)
			end
		end
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), updateSirens)