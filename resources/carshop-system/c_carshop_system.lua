local rc = 10
local bike = 15
local low = 25
local offroad = 35
local sport = 100
local van = 50
local bus = 75
local truck = 200
local boat = 300 -- except dinghy
local heli = 500
local plane = 750
local race = 75
local vehicleTaxes = {
	offroad, low, sport, truck, low, low, 1000, truck, truck, 200, -- dumper, stretch
	low, sport, low, van, van, sport, truck, heli, van, low,
	low, low, low, van, low, 1000, low, truck, van, sport, -- hunter
	boat, bus, 1000, truck, offroad, van, low, bus, low, low, -- rhino
	van, rc, low, truck, 500, low, boat, heli, bike, 0, -- monster, tram
	van, sport, boat, boat, boat, truck, van, 10, low, van, -- caddie
	plane, bike, bike, bike, rc, rc, low, low, bike, heli,
	van, bike, boat, 20, low, low, plane, sport, low, low, -- dinghy
	sport, bike, van, van, boat, 10, 75, heli, heli, offroad, -- baggage, dozer
	offroad, low, low, boat, low, offroad, low, heli, van, van,
	low, rc, low, low, low, offroad, sport, low, van, bike,
	bike, plane, plane, plane, truck, truck, low, low, low, plane,
	plane * 10, bike, bike, bike, truck, van, low, low, truck, low, -- hydra
	10, 20, offroad, low, low, low, low, 0, 0, offroad, -- forklift, tractor, 2x train
	low, sport, low, van, truck, low, low, low, rc, low,
	low, low, van, plane, van, low, 500, 500, race, race, -- 2x monster
	race, low, race, heli, rc, low, low, low, offroad, 0, -- train trailer
	0, 10, 10, offroad, 15, low, low, 3*plane, truck, low,-- train trailer, kart, mower, sweeper, at400
	low, bike, van, low, van, low, bike, race, van, low,
	0, van, 2*plane, plane, rc, boat, low, low, low, offroad, -- train trailer, andromeda
	low, truck, race, sport, low, low, low, low, low, van,
	low, low
}

car, wCars, bClose, bBuy, gCars, lCost, lColors, sCol1, sCol2 = nil
activeShop, shopID = nil

local function countVehicles( )
	vehiclecount = {}
	for key, value in pairs( getElementsByType( "vehicle" ) ) do
		if isElement( value ) then
			local model = getElementModel( value )
			if vehiclecount[ model ] then
				vehiclecount[ model ] = vehiclecount[ model ] + 1
			else
				vehiclecount[ model ] = 1
			end
		end
	end
end

local function copy( t )
	if type(t) == 'table' then
		local r = {}
		for k, v in pairs( t ) do
			r[k] = copy( v )
		end
		return r
	else
		return t
	end
end

local function sort( a, b )
	return a[2] < b[2]
end

function showCarshopUI(id)
	shopID = id
	
	countVehicles()
	activeShop = copy( g_shops[id] )
	
	local width, height = 400, 200
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth - width
	local y = scrHeight/10
	
	wCars = guiCreateWindow(x, y, width, height, activeShop.name .. ": Purchase a Vehicle", false)
	guiWindowSetSizable(wCars, false)
	
	bClose = guiCreateButton(0.6, 0.85, 0.2, 0.1, "Close", true, wCars)
	bBuy = guiCreateButton(0.825, 0.85, 0.2, 0.1, "Buy", true, wCars)
	addEventHandler("onClientGUIClick", bClose, hideCarshopUI, false)
	addEventHandler("onClientGUIClick", bBuy, buyCar, false)
	
	car = createVehicle(451, unpack(activeShop.previewpos))
	setVehicleColor(car, 0, 0, 0, 0)
	setVehicleEngineState(car, true)
	setVehicleOverrideLights(car, 2)
	
	if activeShop.rotate then
		addEventHandler("onClientRender", getRootElement(), rotateCar)
	end
	
	-- sort by price
	for key, value in ipairs( activeShop ) do
		if value[1] and value[2] and vehiclecount[ value[1] ] then
			value[2] = value[2] + ( vehiclecount[ value[1] ] or 0 ) * 600
		end
	end
	table.sort( activeShop, sort )
	
	gCars = guiCreateGridList(0.05, 0.1, 0.5, 0.75, true, wCars)
	addEventHandler("onClientGUIClick", gCars, updateCar, false)
	local col = guiGridListAddColumn(gCars, "Vehicle Model", 0.9)
	for key, value in ipairs( activeShop ) do
		local row = guiGridListAddRow(gCars)
		guiGridListSetItemText(gCars, row, col, tostring(getVehicleNameFromModel(value[1])), false, false)
		guiGridListSetItemData(gCars, row, col, tostring(key), false, false)
	end
	
	lCost = guiCreateLabel(0.15, 0.85, 0.4, 0.1, "Cost: --- - Tax: ---", true, wCars)
	guiSetFont(lCost, "default-bold-small")
	guiLabelSetHorizontalAlign(lCost, "right")
	guiGridListSetSelectedItem(gCars, 0, 1)
	
	updateCar()
	
	lColors = guiCreateLabel(0.6, 0.15, 0.2, 0.1, "Colors:", true, wCars)
	guiSetFont(lColors, "default-bold-small")
	
	sCol1 = guiCreateScrollBar(0.6, 0.25, 0.35, 0.1, true, true, wCars)
	sCol2 = guiCreateScrollBar(0.6, 0.35, 0.35, 0.1, true, true, wCars)
	
	addEventHandler("onClientGUIScroll", sCol1, updateColors)
	addEventHandler("onClientGUIScroll", sCol2, updateColors)
	
	guiSetProperty(sCol1, "StepSize", "0.01")
	guiSetProperty(sCol2, "StepSize", "0.01")
	
	setCameraMatrix(unpack(activeShop.cameramatrix))
	
	guiSetInputEnabled(true)
	
	outputChatBox("Welcome to " .. activeShop.name .. ".")
end
addEvent("showCarshopUI", true)
addEventHandler("showCarshopUI", getRootElement(), showCarshopUI)

function updateCar()
	local row, col = guiGridListGetSelectedItem(gCars)
	
	if row ~= -1 and col ~= -1 then
		local key = tonumber(guiGridListGetItemData(gCars, row, col))
		local value = activeShop[key]
		setElementModel(car, value[1])
		guiSetText(lCost, "Cost: " .. tostring(value[2]) .. "$" .. " - Tax: " .. ( vehicleTaxes[value[1]-399] or 25 ) .. "$")
		
		local money = exports.global:getMoney(getLocalPlayer())
		if value[2] > money then
			guiLabelSetColor(lCost, 255, 0, 0)
			guiSetEnabled(bBuy, false)
		else
			guiLabelSetColor(lCost, 0, 255, 0)
			guiSetEnabled(bBuy, true)
		end
	else
		guiSetEnabled(bBuy, false)
	end
end

function updateColors()
	local col1 = guiScrollBarGetScrollPosition(sCol1)
	local col2 = guiScrollBarGetScrollPosition(sCol2)
	setVehicleColor(car, col1, col2, col1, col2)
end

function rotateCar()
	local rx, ry, rz = getElementRotation(car)
	setElementRotation(car, rx > 5 and rx < 355 and 0 or rx, ry > 5 and ry < 355 and 0 or ry, rz+1)
	
	local x, y, z = unpack(activeShop.previewpos)
	if getDistanceBetweenPoints3D(x, y, z, getElementPosition(car)) > 2 then
		setElementPosition(car, x, y, z)
	end
end

function hideCarshopUI()
	destroyElement(bClose)
	bClose = nil
	
	destroyElement(bBuy)
	bBuy = nil
	
	destroyElement(car)
	car = nil
	
	destroyElement(gCars)
	gCars = nil
	
	destroyElement(lCost)
	lCost = nil
	
	destroyElement(lColors)
	lColors = nil
	
	destroyElement(sCol1)
	sCol1 = nil
	
	destroyElement(sCol2)
	sCol2 = nil
	
	destroyElement(wCars)
	wCars = nil
	
	if activeShop.rotate then
		removeEventHandler("onClientRender", getRootElement(), rotateCar)
	end
	
	activeShop = nil
	shopID = nil

	setCameraTarget(getLocalPlayer())
	guiSetInputEnabled(false)
end

function buyCar(button)
	if (button=="left") then
		if exports.global:hasSpaceForItem(getLocalPlayer(), 3) then
			local row, col = guiGridListGetSelectedItem(gCars)
			local key = tonumber(guiGridListGetItemData(gCars, row, col))
			local value = activeShop[key]
			local car = value[1]
			local cost = value[2]
			local col1 = guiScrollBarGetScrollPosition(sCol1)
			local col2 = guiScrollBarGetScrollPosition(sCol2)
			
			local px, py, pz, prz = unpack(activeShop.player)
			local x, y, z, rz = unpack(activeShop.car)
			local shopid = shopID

			hideCarshopUI()
			triggerServerEvent("buyCar", getLocalPlayer(), car, cost, col1, col2, x, y, z, rz, px, py, pz, prz, shopid)
		else
			outputChatBox("You can't carry the car keys - your inventory is full.", 255, 0, 0)
		end
	end
end
