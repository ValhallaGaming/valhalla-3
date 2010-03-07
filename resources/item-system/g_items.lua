g_items = {
	-- name, description, category, model, rx, ry, rz, zoffset
	
	-- categories:
	-- 1 = Food & Drink
	-- 2 = Keys
	-- 3 = Drugs
	-- 4 = Other
	-- 5 = Books
	-- 6 = Clothing & Accessories
	-- 7 = Electronics
	{ "Haggis", "A plump haggis animal, straight from the hills of Scotland.", 1, 2215, 205, 205, 0, 0.01 },
	{ "Cellphone", "A sleek cellphone, look's like a new one too.", 7, 330, 90, 90, 0, -0.05 },
	{ "Vehicle Key", "A vehicle key with a small manufacturers badge on it. (( Opens vehicle ##v ))", 2, 1581, 270, 270, 0, 0 },
	{ "House Key", "A green house key.", 2, 1581, 270, 270, 0, 0 },
	{ "Business Key", "A blue business key.", 2, 1581, 270, 270, 0, 0 },
	{ "Radio", "A black radio.", 7, 330, 90, 90, 0, -0.05 },
	{ "Phonebook", "A torn phonebook.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Sandwich", "A yummy sandwich with cheese.", 1, 2355, 205, 205, 0, 0.06 },
	{ "Softdrink", "A can of Sprunk.", 1, 2647, 0, 0, 0, 0.12 },
	{ "Dice", "A white dice with white dots.", 4, 1271, 0, 0, 0, 0.285 }, 
	{ "Taco", "A greasy mexican taco.", 1, 2215, 205, 205, 0, 0.06 },
	{ "Burger", "A double cheeseburger with bacon.", 1, 2703, 265, 0, 0, 0.06 },
	{ "Donut", "Hot sticky sugar covered donut.", 1, 2222, 0, 0, 0, 0.07 },
	{ "Cookie", "A luxury chocolate chip cookie.", 1, 2222, 0, 0, 0, 0.07 },
	{ "Water", "A bottle of mineral water.", 1, 1484, -15, 30, 0, 0.2 },
	{ "Clothes", "A set of clean clothes. (( Skin ID ##v ))", 6, 2386, 0, 0, 0, 0.1 },
	{ "Watch", "A smart gold watch.", 6, 1271, 0, 0, 0, 0.285 },
	{ "City Guide", "A small city guide booklet.", 5, 2824, 0, 0, 0, -0.01 },
	{ "MP3 Player", "A white, sleek looking MP3 Player. The brand reads EyePod.", 7, 2886, 270, 0, 0, 0.1 },
	{ "Standard Fighting for Dummies", "A book on how to do standard fighting.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Boxing for Dummies", "A book on how to do boxing.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Kung Fu for Dummies", "A book on how to do kung fu.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Knee Head Fighting for Dummies", "A book on how to do grab kick fighting.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Grab Kick Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Elbow Fighting for Dummies", "A book on how to do elbow fighting.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Gas Mask", "A black gas mask, blocks out the effects of gas and flashbangs.", 6, 2386, 0, 0, 0, 0.1 },
	{ "Flashbang", "A small grenade canister with FB written on the side.", 4, 343, 0, 0, 0, 0.1 },
	{ "Glowstick", "A green glowstick.", 4, 343, 0, 0, 0, 0.1 },
	{ "Door Ram", "A red metal door ram.", 4, 1587, 90, 0, 0, 0.05 },
	{ "Cannabis Sativa", "Cannabis Sativa, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0 },
	{ "Cocaine Alkaloid", "Cocaine Alkaloid, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0 },
	{ "Lysergic Acid", "Lysergic Acid, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0 },
	{ "Unprocessed PCP", "Unprocessed PCP, when mixed can create some strong drugs.", 3, 1279, 0, 0, 0, 0 },
	{ "Cocaine", "1g of cocaine.", 3, 1575, 0, 0, 0, 0 },
	{ "Drug 2", "A marijuana joint laced in cocaine.", 3, 1576, 0, 0, 0, 0 },
	{ "Drug 3", "50mg of cocaine laced in lysergic acid.", 3, 1578, 0, 0, 0, -0.02 },
	{ "Drug 4", "50mg of cocaine laced in phencyclidine.", 3, 1579, 0, 0, 0, 0 },
	{ "Marijuana", "A marijuana joint.", 3, 3044, 0, 0, 0, 0 },
	{ "Drug 6", "A marijuana joint laced in lysergic acid.", 3, 1580, 0, 0, 0, 0 },
	{ "Angel Dust", "A marijuana joint laced in phencyclidine.", 3, 1575, 0, 0, 0, -0.02 },
	{ "LSD", "80 micrograms of LSD.", 3, 1576, 0, 0, 0, 0 },
	{ "Drug 9", "100milligrams of yellow liquid.", 3, 1577, 0, 0, 0, 0 },
	{ "PCP Hydrochloride", "10mg of phencyclidine powder.", 3, 1578, 0, 0, 0, 0 },
	{ "Chemistry Set", "A small chemistry set.", 4, 1210, 90, 0, 0, 0.1 },
	{ "Handcuffs", "A pair of metal handcuffs.", 4, 2386, 0, 0, 0, 0.1 },
	{ "Rope", "A long rope.", 4, 1271, 0, 0, 0, 0.285 },
	{ "Handcuff Keys", "A small pair of handcuff keys.", 4, 2386, 0, 0, 0, 0.1 },
	{ "Backpack", "A reasonably sized backpack.", 4, 3026, 270, 0, 0, 0 },
	{ "Fishing Rod", "A 7 foot carbon steel fishing rod.", 4, 338, 80, 0, 0, -0.02 },
	{ "Los Santos Highway Code", "The Los Santos Highway Code.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Chemistry 101",  "An Introduction to Useful Chemistry.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Police Officer's Manual", "The Police Officer's Manual.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Breathalizer", "A small black breathalizer.", 4, 1271, 0, 0, 0, 0.285 },
	{ "Ghettoblaster", "A black Ghettoblaster.", 7, 2226, 0, 0, 0, 0 },
	{ "Business Card", "Steven Pullman - L.V. Freight Depot, Tel: 12555", 4, 1581, 270, 270, 0, 0 },
	{ "Ski Mask", "A Ski mask.", 6, 2386, 0, 0, 0, 0.1 },
	{ "Fuel Can", "A small metal fuel canister.", 4, 1517, 0, 0, 0, 0.15 },
	{ "Ziebrand Beer", "The finest beer, imported from Holland.", 1, 1520, 0, 0, 0, 0.15 },
	{ "Mudkip", "So i herd u liek mudkips? mabako's Favorite.", 1, 1579, 0, 0, 0, 0 },
	{ "Safe", "A safe to store your items in.", 4, 2332, 0, 0, 0, 0 },
	{ "Emergency Light Strobes", "An Emergency Light Strobe which you can put on you car.", 7, 2886, 270, 0, 0, 0.1 },
	{ "Bastradov Vodka", "For your best friends - Bastradov Vodka.", 1, 1512, 0, 0, 0, 0.25 },
	{ "Scottish Whiskey", "The Best Scottish Whiskey, now exclusively made from Haggis.", 1, 1512, 0, 0, 0, 0.25 },
	{ "LSPD Badge", "A Los Santos Police Department badge.", 4, 1581, 270, 270, 0, 0 },
	{ "LSES Identification", "An Los Santos Emergency Service Identification.", 4, 1581, 270, 270, 0, 0 },
	{ "Blindfold", "A black blindfold.", 6, 2386, 0, 0, 0, 0.1 },
	{ "GPS", "A GPS Satnav for a car.", 6, 2886, 270, 0, 0, 0.1 },
	{ "Lottery Ticket", "A Los Santos Lottery ticket.", 6, 1581, 270, 270, 0, 0 },
	{ "Dictionary", "A Dictionary.", 5, 2824, 0, 0, 0, -0.01 },
	{ "First Aid Kit", "Saves a Life. Can be used #v times.", 4, 1240, 90, 0, 0, 0.05 },
	{ "Notebook", "A small collection of blank papers, useful for writing notes. There are #v pages left. ((/writenote))", 4, 2824, 0, 0, 0, -0.01 },
	{ "Note", "The note reads: #v", 4, 2824, 0, 0, 0, -0.01 },
	{ "Elevator Remote", "A small remote to change an elevator's mode.", 2, 364, 0, 0, 0, 0.05 },
	{ "Bomb", "What could possibly happen when you use this?", 4, 363, 270, 0, 0, 0.05 },
	{ "Bomb Remote", "Has a funny red button.", 4, 364, 0, 0, 0, 0.05 },
	{ "Riot Shield", "A heavy riot shield.", 4, 1631, -90, 0, 0, 0.1 },
	{ "Card Deck", "A card deck to play some games.", 4,2824, 0, 0, 0, -0.01 },
	{ "San Andreas Pilot Certificate", "An official permission to fly planes and helicopters.", 4, 1581, 270, 270, 0, 0 },
	{ "Porn Tape", "A porn tape, #v", 4,2824, 0, 0, 0, -0.01 },
	{ "Generic Item", "#v", 4, 1271, 0, 0, 0, 0.285 },
	{ "Fridge", "A fridge to store food and drinks in.", 7, 2147, 0, 0, 0, 0 },
	{ "BT&R Identification", "This BT&R Identification has been issued to #v.", 4, 1581, 270, 270, 0, 0 },
	{ "Coffee", "A small cup of Coffee.", 1, 2647, 0, 0, 0, 0.12 },
	{ "Escort 9500ci Radar Detector", "Detects Police within a half mile.", 7, 330, 90, 90, 0, -0.05 },
	{ "Emergency Siren", "An emergency siren to put in your car.", 7, 330, 90, 90, 0, -0.05 },
	{ "SAN Identifcation", "An SAN Identification issued to #v.", 7, 330, 90, 90, 0, -0.05 },
	{ "LS Government Badge", "A Los Santos Government Badge.", 4, 1581, 270, 270, 0, 0 },
	{ "Earpiece", "A small earpiece, can be connected to a radio.", 7, 1581, 270, 270, 0, 0 },
	{ "Food", "", 1, 2222, 0, 0, 0, 0.07 },
	{ "Helmet", "Ideal for riding bikes.", 6, 2386, 0, 0, 0, 0.1 },
	{ "Eggnog", "Yum Yum.", 1, 2647, 0, 0, 0, 0.1 }, --91
	{ "Turkey", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1 },
	{ "Christmas Pudding", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1 },
	{ "Christmas Present", "I know you want one.", 4, 1220, 0, 0, 0, 0.1 },
	{ "Drink", "", 1, 1484, -15, 30, 0, 0.2 },
	{ "PDA", "A top of the range PDA to view e-mails and browse the internet.", 6, 2886, 270, 0, 0, 0.1 },
	{ "LSES Procedures Manual", "The Los Santos Emergency Service procedures handbook.", 5, 2824, 0, 0, 0, -0.01 },
	{ "Garage Remote", "A small remote to open or close a Garage.", 2, 364, 0, 0, 0, 0.05 },
	{ "Mixed Dinner Tray", "Lets play the guessing game.", 1, 2355, 205, 205, 0, 0.06 },
	{ "Small Milk Carton", "Lumps included!", 1, 2856, 0, 0, 0, 0 },
	{ "Small Juice Carton", "Thirsty?", 1, 2647, 0, 0, 0, 0.12 },
	{ "Cabbage", "For those Vegi-Lovers.", 1, 1271, 0, 0, 0, 0.1 },
	--Chairs = { 1663, 1671, 1720, 1721, 1810, 1811, 2079, 2120, 2121, 2125, 2777, 2788, 1369 }
}

function getItemRotInfo(id)
	if not g_items[id] then
		return 0, 0, 0, 0
	else
		return  g_items[id][5], g_items[id][6], g_items[id][7], g_items[id][8]
	end
end

local function findVehicleName( value )
	for _, theVehicle in pairs( getElementsByType( "vehicle" ) ) do
		if getElementData( theVehicle, "dbid" ) == value then
			return " (" .. getVehicleName( theVehicle ) .. ")"
		end
	end
	return ""
end

function getItemName(id, value)
	if id == -100 then
		return "Body Armor"
	elseif id == -46 then -- MTA Client bug
		return "Parachute"
	elseif id < 0 then
		return getWeaponNameFromID( -id )
	elseif not g_items[id] then
		return "?"
	elseif id == 3 and value then
		return g_items[id][1] .. findVehicleName(value)
	elseif ( id == 4 or id == 5 ) and value then
		local pickup = exports['interior-system']:findParent( nil, value )
		local name = pickup and getElementData( pickup, "name" )
		return g_items[id][1] .. ( name and ( " (" .. name .. ")" ) or "" )
	elseif ( id == 80 ) and value then
		return value
	elseif ( id == 96 ) and value and value ~= 1 then
		return value
	elseif ( id == 89 or id == 95 ) and value and value:find( ";" ) then
		return value:sub( 1, value:find( ";" ) - 1 )
	else
		return g_items[id][1]
	end
end

function getItemValue(id, value)
	if id == 80 then
		return ""
	elseif id == 96 then
		return 1
	elseif id == 89 or id == 95 then
		return value:sub( value:find( ";" ) + 1 )
	else
		return value
	end
end

function getItemDescription(id, value)
	local i = g_items[id]
	if i then
		local desc = i[2]
		if id == 96 and value ~= 1 then
			return desc:gsub("PDA","Laptop")
		else
			return desc:gsub("#v",value)
		end
	end
end

function getItemType(id)
	return ( g_items[id] or { nil, nil, 4 } )[3]
end

function getItemModel(id)
	return ( g_items[id] or { nil, nil, nil, 1271 } )[4]
end
