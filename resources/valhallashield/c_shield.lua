local VSalpha = 0
VSstate = 0
local rotation = 0
local width, height = guiGetScreenSize()
local xoffset = width / 6
local yoffset = height / 6

local startTick = 0
local endTick = 0

function doCallHomeEvent()
	local scripter = exports.global:isPlayerScripter(getLocalPlayer())
	local admin = exports.global:isPlayerAdmin(getLocalPlayer())
	local fulladmin = exports.global:isPlayerFullAdmin(getLocalPlayer())
	local superadmin = exports.global:isPlayerSuperAdmin(getLocalPlayer())
	local leadadmin = exports.global:isPlayerLeadAdmin(getLocalPlayer())
	local headadmin = exports.global:isPlayerHeadAdmin(getLocalPlayer())
	triggerServerEvent("callhome", getLocalPlayer(), scripter, admin, fulladmin, superadmin, leadadmin, headadmin)
end

function doCallhome()
	startTick = getTickCount()
	addEventHandler("onClientRender", getRootElement(), drawValhallaShield)
	
	VSstate = 0
	VSalpha = 0
	rotation = 0
	endTick = 0
	
	setTimer(doCallHomeEvent, 1000, 1)
end

local time = math.random(5, 10) * 60000
setTimer(doCallhome, time, 1)

function callbackOK()
	endTick = getTickCount() - startTick
	VSstate = 1
end
addEvent("callbackOK", true)
addEventHandler("callbackOK", getRootElement(), callbackOK)

function callbackUnknown()
	endTick = getTickCount() - startTick
	VSstate = 3
end
addEvent("callbackUnknown", true)
addEventHandler("callbackUnknown", getRootElement(), callbackUnknown)

function hideValhallaShield()
	if ( VSstate == 1 ) then
		VSstate = 2
	elseif ( VSstate == 3 ) then
		VSstate = 4
	end
end

local timer = nil
function drawValhallaShield()
	if ( VSalpha < 150 and VSstate  ~= 2 and VSstate ~= 4) then
		VSalpha = VSalpha + 10
	elseif ( VSalpha > 0 and (VSstate  == 2 or VSstate == 4) ) then
		VSalpha = VSalpha - 5

		if ( VSalpha <= 0 ) then
			local time = math.random(5, 10) * 60000
			setTimer(doCallhome, time, 1)
			removeEventHandler("onClientRender", getRootElement(), drawValhallaShield)
		end
	end
	
	-- DRAW BACKGROUND
	dxDrawRectangle(width - xoffset*4.5, height - yoffset * 1.2, xoffset*3, 120, tocolor(0, 0, 0, VSalpha), false)
	
	local imageName = ":account-system/gui/loading.png"
	local text = "Performing Client Verification..."
	local subtext = "No private information will be obtained during this scan."
	local subtext2 = "Scan completed in " .. tostring(math.floor(endTick/1000)) .. " second(s)."
	
	if ( VSstate == 0 ) then
		rotation = rotation + 5
	elseif ( VSstate == 1 ) then
		rotation = 0
		imageName = "gui/shield/shield_ok.png"
		text = "Client Verification OK"
		subtext = "No private information was obtained during this scan."
		
		if not ( isTimer(timer) ) then
			timer = setTimer(hideValhallaShield, 3000, 1)
		end
	elseif ( VSstate == 2 ) then 
		rotation = 0
		imageName = "gui/shield/shield_ok.png"
		text = "Client Verification OK"
		subtext = "No private information was obtained during this scan."
	elseif ( VSstate == 3 ) then 
		rotation = 0
		imageName = "gui/shield/shield_question.png"
		text = "Could Not Verify At This Time"
		subtext = "No private information was obtained during this scan."
		
		if not ( isTimer(timer) ) then
			timer = setTimer(hideValhallaShield, 3000, 1)
		end
	elseif ( VSstate == 4 ) then 
		rotation = 0
		imageName = "gui/shield/shield_question.png"
		text = "Could Not Verify At This Time"
		subtext = "No private information was obtained during this scan."
	end	

	local x = width - xoffset*4.05 - 64
	local y = (height - yoffset * 1.22) + dxGetFontHeight(2, "sans")
	dxDrawImage(x, y, 64, 64, imageName, rotation, 0, 0, tocolor(255, 255, 255, VSalpha), false)
	
	local x = width - xoffset*3.8
	local y = (height - yoffset * 1.4) + dxGetFontHeight(2, "sans")
	local textAlpha = VSalpha + 50
	
	if ( VSstate == 2 or VSstate == 4 ) then
		textAlpha = VSalpha
	end
	
	dxDrawText(text, x, y+10, x + xoffset*1.9, y + 120, tocolor(0,0,0, textAlpha), 2, "sans", "center", "center", false, false, false)
	dxDrawText(text, x, y, x + xoffset*1.9, y + 120, tocolor(255, 255, 255, textAlpha), 2, "sans", "center", "center", false, false, false)

	local x = width - xoffset*3.76
	local y = (height - yoffset * 1.25) + dxGetFontHeight(2, "sans")
	dxDrawText(subtext, x+10, y+10, x + xoffset*1.8, y + 120, tocolor(0,0,0, textAlpha), 0.8, "sans", "center", "center", false, false, false)
	dxDrawText(subtext, x, y, x + xoffset*1.8, y + 120, tocolor(255, 255, 255, textAlpha), 0.8, "sans", "center", "center", false, false, false)
	
	
	if ( VSstate > 0 ) then
	local x = width - xoffset*3.76
	local y = (height - yoffset * 1.15) + dxGetFontHeight(2, "sans")
	dxDrawText(subtext2, x+10, y+10, x + xoffset*1.8, y + 120, tocolor(0,0,0, textAlpha), 0.8, "sans", "center", "center", false, false, false)
	dxDrawText(subtext2, x, y, x + xoffset*1.8, y + 120, tocolor(255, 255, 255, textAlpha), 0.8, "sans", "center", "center", false, false, false)
	end
end