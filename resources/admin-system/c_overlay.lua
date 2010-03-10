local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

local openReports = 0
local handledReports = 0
local unansweredReports = {}
local ownReports = {}

-- dx stuff
local textString = ""
local show = false
local ondutystatus = false

-- Admin Titles
function getAdminTitle(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel")) or 0
	local text = ({ "Trial Admin", "Admin", "Super Admin", "Lead Admin", "Head Admin", "Owner", nil, nil, nil, "Scripter" })[adminLevel] or "Player"
	
	local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
	if (hiddenAdmin==1) then
		text = text .. " (Hidden)"
	end
	return text
end

function getAdminCount()
	local online, duty, lead, leadduty = 0, 0, 0, 0
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local level = getElementData( value, "adminlevel" ) or 0
			if level >= 1 and level <= 6 then
				online = online + 1
				
				local aod = getElementData( value, "adminduty" ) or 0
				if aod == 1 then
					duty = duty + 1
				end
				
				if level >= 4 then
					lead = lead + 1
					if aod == 1 then
						leadduty = leadduty + 1
					end
				end
			end
		end
	end
	return online, duty, lead, leadduty
end

-- update the labels
local function updateGUI()
	if show then
		local online, duty, lead, leadduty = getAdminCount()
		
		local reporttext = ""
		if #unansweredReports > 0 then
			reporttext = ": #" .. table.concat(unansweredReports, ", #")
		end
		
		local ownreporttext = ""
		if #ownReports > 0 then
			ownreporttext = ": #" .. table.concat(ownReports, ", #")
		end
		
		local onduty = getElementData( localPlayer, "adminlevel" ) <= 6 and "Off Duty" .. " :: " or ""
		if getElementData( localPlayer, "adminduty" ) == 1 then
			onduty = "On Duty" .. " :: "
		end
		textString = getAdminTitle( localPlayer ) .. " :: " .. onduty .. getElementData( localPlayer, "gameaccountusername" ) .. " :: " .. duty .. "/" .. online .. " Admins :: " .. leadduty .. "/" .. lead .. " Lead+ Admins" .. ( getElementData( localPlayer, "adminlevel" ) <= 6 and ( " :: " .. ( openReports - handledReports ) .. " unanswered reports" .. reporttext .. " :: " .. handledReports .. " handled reports" .. ownreporttext ) or "" )
	end
end

-- create the gui
local function createGUI()
	show = false
	--ondutystatus = false
	local adminlevel = getElementData( localPlayer, "adminlevel" )
	local adminduty = getElementData( localPlayer, "adminduty" )
	if adminlevel then
		if adminlevel > 0 then
			show = true
			if (adminduty ~= 0) then
				ondutystatus = true
			else
				ondutystatus = false
			end
			updateGUI()
		end
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), createGUI, false )
addEventHandler( "onClientElementDataChange", localPlayer, 
	function(n)
		if n == "adminlevel" or n == "hiddenadmin" then
			createGUI()
		end
	end, false
)

addEventHandler( "onClientElementDataChange", getRootElement(), 
	function(n)
		if getElementType(source) == "player" and ( n == "adminlevel" or n == "adminduty" ) then
			updateGUI()
		end
	end
)

addEvent( "updateReportsCount", true )
addEventHandler( "updateReportsCount", localPlayer,
	function( open, handled, unanswered, own )
		openReports = open
		handledReports = handled
		unansweredReports = unanswered
		ownReports = own or {}
		updateGUI()
	end, false
)

addEventHandler( "onClientPlayerQuit", getRootElement(), updateGUI )

function drawText ( )
	if show then
		local color
		--if ondutystatus then
			color = tocolor ( 255, 255, 255, 255 )
		--else
		--	color = tocolor ( 139, 137, 137, 255 )
		--end
		dxDrawText( textString, 5, sy-13, sx, sy, color, 0.85, "default" )
	end
end
addEventHandler("onClientRender",getRootElement(), drawText)