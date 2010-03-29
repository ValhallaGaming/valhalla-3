local VSalpha = 0
VSstate = 0
local rotation = 0
local width, height = guiGetScreenSize()
local xoffset = width / 6
local yoffset = height / 6

local startTick = 0
local endTick = 0

function doCallHomeEvent()
	checkCanSeeReconners()
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

function checkCanSeeReconners()
	for k,v in ipairs(getElementsByType("player")) do
		if ( getElementData(v, "reconx") then
			if ( getElementAlpha(v) > 0 ) then
				triggerServerEvent("reconhack", getLocalPlayer())
			end
		end
	end
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
	dxDrawRectangle(xoffset*0.05, height - yoffset * 0.32, xoffset*1.5, 25, tocolor(0, 0, 0, VSalpha), false)
	
	local imageName = ":account-system/gui/loading.png"
	local text = "Performing Client Verification..."
	
	if ( VSstate == 0 ) then
		rotation = rotation + 5
	elseif ( VSstate == 1 ) then
		rotation = 0
		imageName = "gui/shield/shield_ok.png"
		text = "Client Verification OK"
		
		if not ( isTimer(timer) ) then
			timer = setTimer(hideValhallaShield, 3000, 1)
		end
	elseif ( VSstate == 2 ) then 
		rotation = 0
		imageName = "gui/shield/shield_ok.png"
		text = "Client Verification OK"
	elseif ( VSstate == 3 ) then 
		rotation = 0
		imageName = "gui/shield/shield_question.png"
		text = "Could Not Verify At This Time"
		
		if not ( isTimer(timer) ) then
			timer = setTimer(hideValhallaShield, 3000, 1)
		end
	elseif ( VSstate == 4 ) then 
		rotation = 0
		imageName = "gui/shield/shield_question.png"
		text = "Could Not Verify At This Time"
	end	

	local x = xoffset*0.06
	local y = (height - yoffset * 0.3)
	dxDrawImage(x, y, 20, 20, imageName, rotation, 0, 0, tocolor(255, 255, 255, VSalpha), false)
	
	local x = xoffset*0.06
	local y = (height - yoffset * 0.3)
	local textAlpha = VSalpha + 50
	
	if ( VSstate == 2 or VSstate == 4 ) then
		textAlpha = VSalpha
	end

	dxDrawText(text, x, y, x + xoffset*1.6, y + dxGetFontHeight(1, "sans"), tocolor(255, 255, 255, textAlpha), 1, "sans", "center", "center", false, false, false)
end