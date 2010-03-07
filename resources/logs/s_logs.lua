enumTypes = {
	"chat",
	"ads",
	"adminchat",
	"admincmds",
	"moneytransfers",
	"faction",
	"meactions",
	"pms",
	"vehicles",
	"san-photo",
	"kills",
	"anticheat",
	"itemspawn",
	"tow",
	"setfaction",
	"changelock",
	"moveitems",
	"news",
	"do",
	"tv",
	"adminlock",
	"weaponspawn",
	"moneyspawn",
	"sqlqueries",
	"stevie"
}


function logMessage(message, type)
	local filename = nil
	local r = getRealTime()
	local partialname = enumTypes[type]
	
	if (partialname == nil) then return end
	
	if partialname == "admincmds" or partialname == "moneyspawn" or partialname == "weaponspawn" or partialname == "sqlqueries" or partialname == "stevie" then
		filename = "/hiddenlogs/" .. partialname .. ".log"
	else
		filename = "/logs/" .. partialname .. ".log"
	end
	
	
	local file = createFileIfNotExists(filename)
	local size = fileGetSize(file)
	fileSetPos(file, size)
	fileWrite(file, "[" .. ("%04d-%02d-%02d %02d:%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour,r.minute) .. "] " .. message .. "\r\n")
	fileFlush(file)
	fileClose(file)
	
	return true
end

function createFileIfNotExists(filename)
	local file = fileOpen(filename)
	
	if not (file) then
		file = fileCreate(filename)
	end
	
	return file
end