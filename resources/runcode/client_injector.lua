local INJECTED_SCRIPTS = {}

function injectScript ( script )
	if exports.global:isPlayerScripter( getLocalPlayer( ) ) and type(script) == "string" and #script > 0 then
		script = script:lower()
		if INJECTED_SCRIPTS[script] then
			outputChatBox("Script '" .. script .. "' already loaded.", 255, 0, 0)
			return false
		else
			local xmlFile = xmlLoadFile ( "scripts/" .. script .. ".lua" )
			if not xmlFile then
				outputChatBox ( "Error: Couldn't open scripts/" .. script .. ".lua", 255, 0, 0 )
				return false
			else
				local code = xmlNodeGetValue ( xmlFile )
				local chunk = loadstring(code)
				if not chunk then
					outputChatBox ( "Error: cannot compile scripts/" .. script .. ".lua", 255, 0, 0 )
					return false
				else
					local newEnv = { globalVars = {}, wrappers = { commands = {}, events = {}, binds = {}, timers = {}, elements = {} } }
					for k, v in pairs(_G) do
						if k ~= "INJECTED_SCRIPTS" then
							newEnv.globalVars[k] = v
						end
					end
					chunk = setfenv ( chunk, newEnv.globalVars )
					
					-- Export some MTA functions that require wrapping
					newEnv.wrappers.table = table
					newEnv.wrappers.ipairs = ipairs
					newEnv.wrappers.pairs = pairs
					newEnv.wrappers._addCommandHandler = addCommandHandler
					newEnv.wrappers._removeCommandHandler = removeCommandHandler
					newEnv.wrappers._addEventHandler = addEventHandler
					newEnv.wrappers._removeEventHandler = removeEventHandler
					newEnv.wrappers._bindKey = bindKey
					newEnv.wrappers._unbindKey = unbindKey
					newEnv.wrappers._setTimer = setTimer
					newEnv.wrappers._killTimer = killTimer
					newEnv.wrappers._destroyElement = destroyElement
					newEnv.wrappers._playSound = playSound
					newEnv.wrappers._playSound3D = playSound3D
					newEnv.wrappers._createBlip = createBlip
					newEnv.wrappers._createBlipAttachedTo = createBlipAttachedTo
					newEnv.wrappers._createColCircle = createColCircle
					newEnv.wrappers._createColCuboid = createColCuboid
					newEnv.wrappers._createColRectangle = createColRectangle
					newEnv.wrappers._createColSphere = createColSphere
					newEnv.wrappers._createColTube = createColTube
					newEnv.wrappers._createColPolygon = createColPolygon
					newEnv.wrappers._createElement = createElement
					newEnv.wrappers._engineImportCOL = engineImportCOL
					newEnv.wrappers._engineImportTXD = engineImportTXD
					newEnv.wrappers._engineLoadCOL = engineLoadCOL
					newEnv.wrappers._engineLoadDFF = engineLoadDFF
					newEnv.wrappers._engineLoadTXD = engineLoadTXD
					newEnv.wrappers._guiCreateButton = guiCreateButton
					newEnv.wrappers._guiCreateCheckBox = guiCreateCheckBox
					newEnv.wrappers._guiCreateEdit = guiCreateEdit
					newEnv.wrappers._guiCreateGridList = guiCreateGridList
					newEnv.wrappers._guiCreateMemo = guiCreateMemo
					newEnv.wrappers._guiCreateProgressBar = guiCreateProgressBar
					newEnv.wrappers._guiCreateRadioButton = guiCreateRadioButton
					newEnv.wrappers._guiCreateScrollBar = guiCreateScrollBar
					newEnv.wrappers._guiCreateScrollPane = guiCreateScrollPane
					newEnv.wrappers._guiCreateStaticImage = guiCreateStaticImage
					newEnv.wrappers._guiCreateTabPanel = guiCreateTabPanel
					newEnv.wrappers._guiCreateTab = guiCreateTab
					newEnv.wrappers._guiCreateLabel = guiCreateLabel
					newEnv.wrappers._guiCreateWindow = guiCreateWindow
					newEnv.wrappers._createMarker = createMarker
					newEnv.wrappers._createObject = createObject
					newEnv.wrappers._createPed = createPed
					newEnv.wrappers._createPickup = createPickup
					newEnv.wrappers._createProjectile = createProjectile
					newEnv.wrappers._createRadarArea = createRadarArea
					newEnv.wrappers._createVehicle = createVehicle
					newEnv.wrappers._createWater = createWater
					newEnv.globalVars.addCommandHandler = setfenv ( function ( cmd, fn, ... )
						-- Create a state
						local state = { cmd, fn }
						table.insert ( commands, state )
						return _addCommandHandler ( cmd, fn, ... )
					end, newEnv.wrappers )
					newEnv.globalVars.removeCommandHandler = setfenv ( function ( cmd, fn, ... )
						-- Find the states to remove
						for k, state in ipairs ( commands ) do
							if state[1] == cmd and ( fn == state[2] or not fn ) then
								table.remove ( commands, k )
							end
						end
						return _removeCommandHandler ( cmd, fn, ... )
					end, newEnv.wrappers )
					newEnv.globalVars.addEventHandler = setfenv ( function ( evt, entity, fn, ... )
						-- Create a state
						local state = { evt, entity, fn }
						table.insert ( events, state )
						return _addEventHandler ( evt, entity, fn, ... )
					end, newEnv.wrappers )
					newEnv.globalVars.removeEventHandler = setfenv ( function ( evt, entity, fn, ... )
						-- Find the states to remove
						for k, state in ipairs ( events ) do
							if state[1] == evt and ( state[2] == entity or not entity ) and ( state[3] == fn or not fn ) then
								table.remove ( events, k )
							end
						end
						return _removeEventHandler ( evt, entity, fn, ... )
					end, newEnv.wrappers )
					newEnv.globalVars.bindKey = setfenv ( function ( key, keyState, fn, ... )
						-- Create a state
						local state = { key, keyState, fn }
						table.insert ( binds, state )
						return _bindKey ( key, keyState, fn, ... )
					end, newEnv.wrappers )
					newEnv.globalVars.unbindKey = setfenv ( function ( key, keyState, fn, ... )
						-- Find the states to remove
						for k, state in ipairs ( binds ) do
							if state[1] == key and ( state[2] == keyState or not keyState ) and ( state[3] == fn or not fn ) then
								table.remove ( binds, k )
							end
						end
						return _unbindKey ( key, keyState, fn, ... )
					end, newEnv.wrappers )
					newEnv.globalVars.setTimer = setfenv ( function ( ... )
						-- Get the timer element
						local theTimer = _setTimer ( ... )
						if theTimer then
							timers[theTimer] = true
						end
						return theTimer
					end, newEnv.wrappers )
					newEnv.globalVars.killTimer = setfenv ( function ( theTimer )
						if theTimer then timers[theTimer] = nil end
						return _killTimer ( theTimer )
					end, newEnv.wrappers )
					newEnv.globalVars.playSound  = setfenv ( function ( ... )
						local element = _playSound  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.playSound3D  = setfenv ( function ( ... )
						local element = _playSound3D  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.destroyElement  = setfenv ( function ( element )
						if element then elements[ element ] = nil end
						return _destroyElement ( element )
					end, newEnv.wrappers )
					newEnv.globalVars.createBlip  = setfenv ( function ( ... )
						local element = _createBlip  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createBlipAttachedTo  = setfenv ( function ( ... )
						local element = _createBlipAttachedTo  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createColCircle  = setfenv ( function ( ... )
						local element = _createColCircle  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createColCuboid  = setfenv ( function ( ... )
						local element = _createColCuboid  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createColRectangle  = setfenv ( function ( ... )
						local element = _createColRectangle  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createColSphere  = setfenv ( function ( ... )
						local element = _createColSphere  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createColTube  = setfenv ( function ( ... )
						local element = _createColTube  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createColPolygon  = setfenv ( function ( ... )
						local element = _createColPolygon  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createElement  = setfenv ( function ( ... )
						local element = _createElement  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.engineImportCOL  = setfenv ( function ( ... )
						local element = _engineImportCOL  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.engineImportTXD  = setfenv ( function ( ... )
						local element = _engineImportTXD  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.engineLoadCOL  = setfenv ( function ( ... )
						local element = _engineLoadCOL  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.engineLoadDFF  = setfenv ( function ( ... )
						local element = _engineLoadDFF  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.engineLoadTXD  = setfenv ( function ( ... )
						local element = _engineLoadTXD  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateButton  = setfenv ( function ( ... )
						local element = _guiCreateButton  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateCheckBox  = setfenv ( function ( ... )
						local element = _guiCreateCheckBox  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateEdit  = setfenv ( function ( ... )
						local element = _guiCreateEdit  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateGridList  = setfenv ( function ( ... )
						local element = _guiCreateGridList  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateMemo  = setfenv ( function ( ... )
						local element = _guiCreateMemo  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateProgressBar  = setfenv ( function ( ... )
						local element = _guiCreateProgressBar  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateRadioButton  = setfenv ( function ( ... )
						local element = _guiCreateRadioButton  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateScrollBar  = setfenv ( function ( ... )
						local element = _guiCreateScrollBar  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateScrollPane  = setfenv ( function ( ... )
						local element = _guiCreateScrollPane  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateStaticImage  = setfenv ( function ( ... )
						local element = _guiCreateStaticImage  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateTabPanel  = setfenv ( function ( ... )
						local element = _guiCreateTabPanel  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateTab  = setfenv ( function ( ... )
						local element = _guiCreateTab  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateLabel  = setfenv ( function ( ... )
						local element = _guiCreateLabel  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.guiCreateWindow  = setfenv ( function ( ... )
						local element = _guiCreateWindow  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createMarker  = setfenv ( function ( ... )
						local element = _createMarker  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createObject  = setfenv ( function ( ... )
						local element = _createObject  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createPed  = setfenv ( function ( ... )
						local element = _createPed  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createPickup  = setfenv ( function ( ... )
						local element = _createPickup  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createProjectile = setfenv ( function ( ... )
						local element = _createProjectile ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createRadarArea  = setfenv ( function ( ... )
						local element = _createRadarArea  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createVehicle  = setfenv ( function ( ... )
						local element = _createVehicle  ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					newEnv.globalVars.createWater = setfenv ( function ( ... )
						local element = _createWater ( ... )
						if element then
							elements[ element ] = true
						end
						return element
					end, newEnv.wrappers )
					
					INJECTED_SCRIPTS[script] = newEnv
					chunk ()
					outputChatBox ( "Script '" .. script .. ".lua' loaded", 0, 255, 0 )
					return true
				end
			end
		end
	end
	
	return false
end

local function uninjectScript ( script )
	if exports.global:isPlayerScripter( getLocalPlayer( ) ) and type(script) == "string" and #script > 0 then
		script = script:lower()
		if not INJECTED_SCRIPTS[script] then
			outputChatBox("Script '" .. script .. ".lua' not loaded.", 255, 0, 0)
			return false
		else
			-- Unload all commands, events, keybinds and timers
			local wrappers = INJECTED_SCRIPTS[script].wrappers
			for k, v in ipairs ( wrappers.commands ) do
				removeCommandHandler ( v[1], v[2] )
			end
			for k, v in ipairs ( wrappers.events ) do
				removeEventHandler ( v[1], v[2], v[3] )
			end
			for k, v in ipairs ( wrappers.binds ) do
				unbindKey ( v[1], v[2], v[3] )
			end
			for k, v in pairs ( wrappers.timers ) do
				killTimer ( v )
			end
			for element in pairs ( wrappers.elements ) do
				destroyElement ( element )
			end
			INJECTED_SCRIPTS[script] = nil
			outputChatBox("Script '" .. script .. ".lua' unloaded.", 0, 255, 0)
			return true
		end
	end
	
	return false
end

addCommandHandler ( "inject", function ( c, ... ) injectScript ( table.concat( { ... }, " " ) ) end )
addCommandHandler ( "uninject", function ( c, ... ) uninjectScript ( table.concat( { ... }, " " ) ) end )
addCommandHandler ( "reinject", function ( c, ... ) if uninjectScript ( table.concat( { ... }, " " ) ) then injectScript ( table.concat( { ... }, " " ) ) end end )