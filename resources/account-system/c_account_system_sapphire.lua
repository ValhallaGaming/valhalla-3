local version = "0.1"

function hasBeta()	
	local xmlRoot = xmlLoadFile( "sapphirebeta.xml" )
	if (xmlRoot) then
		local betaNode = xmlFindChild(xmlRoot, "beta", 0)

		if (betaNode) then
			return true
		end
		return false
	end
	
	return false
end

if ( hasBeta() ) then
	triggerServerEvent("hasBeta", getLocalPlayer())

function stopNameChange(oldNick, newNick)
	if (source==getLocalPlayer()) then
		local legitNameChange = getElementData(getLocalPlayer(), "legitnamechange")

		if (oldNick~=newNick) and (legitNameChange==0) then
			triggerServerEvent("resetName", getLocalPlayer(), oldNick, newNick) 
			outputChatBox("Click 'Change Character' if you wish to change your roleplay identity.", 255, 0, 0)
		end
	end
end
addEventHandler("onClientPlayerChangeNick", getRootElement(), stopNameChange)

function onPlayerSpawn()
	showCursor(false)
	
	local interior = getElementInterior(source)
	setCameraInterior(interior)
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), onPlayerSpawn)

function clearChatBox()
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
	outputChatBox("")
end

function hideInterfaceComponents()
	--triggerEvent("hideHud", getLocalPlayer())
	showPlayerHudComponent("weapon", false)
	showPlayerHudComponent("ammo", false)
	showPlayerHudComponent("vehicle_name", false)
	showPlayerHudComponent("money", false)
	showPlayerHudComponent("clock", false)
	showPlayerHudComponent("health", false)
	showPlayerHudComponent("armour", false)
	showPlayerHudComponent("breath", false)
	showPlayerHudComponent("area_name", false)
	showPlayerHudComponent("radar", false)
	--triggerEvent("hideHud", getLocalPlayer())
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), hideInterfaceComponents)








---------------------- [ ACCOUNT SCRIPT ] ----------------------
-- increasing this will reshow the tos as updated
local tosversion = 100
local toswindow, tos, bAccept, bDecline = nil
function checkTOS()
	local xmlRoot = xmlLoadFile("vgrptos.xml")
	
	if (xmlRoot) then
		local tosNode = xmlFindChild(xmlRoot, "tosversion", 0)
		
		if (tosNode) then
			local tversion = xmlNodeGetValue(tosNode)
			if (tversion) and (tversion~="") then				
				if (tonumber(tversion)~=tosversion) then
					xmlRoot = nil
				end
			else
				xmlRoot = nil
			end
		else
			xmlRoot = nil
		end
	end
	
	if not (xmlRoot) then -- User hasn't accepted terms of service or is out of date
		local width, height = 700, 300
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		toswindow = guiCreateWindow(x, y, width, height, "Terms of Service", false)
		guiWindowSetMovable(toswindow, false)
		
		tos = guiCreateMemo(0.025, 0.1, 0.95, 0.7, "", true, toswindow)
		guiSetText(tos, "By connecting, playing, registering and logging into this server you agree to the following terms and conditions (Last revised 17/October/2008). \n\n- You will not use any external software to 'hack' or cheat in the game.\n- You will not exploit any bugs within the script to gain an advantage over other players.\n- Your account and character are property of Valhalla Gaming.\n- Your account may be removed after 30 days of inactivity (character inactivity does not count).\n\n Visit www.valhallagaming.net if you require any assistance with these terms.")
		guiEditSetReadOnly(tos, true)
		
		bAccept = guiCreateButton(0.1, 0.8, 0.4, 0.15, "Accept", true, toswindow)
		bDecline = guiCreateButton(0.51, 0.8, 0.4, 0.15, "Decline", true, toswindow)
		addEventHandler("onClientGUIClick", bAccept, acceptTOS, false)
		addEventHandler("onClientGUIClick", bDecline, declineTOS, false)
		
		showCursor( true )
	else
		triggerServerEvent("getSalt", getLocalPlayer(), scripter)
	end
end
addEventHandler( "onClientResourceStart", getResourceRootElement( ), checkTOS )

function acceptTOS(button, state)
	local theFile = xmlCreateFile("vgrptos.xml", "tosversion")
	if (theFile) then
		local node = xmlCreateChild(theFile, "tosversion")
		xmlNodeSetValue(node, tostring(tosversion))
		xmlSaveFile(theFile)
	end
	destroyElement(toswindow)
	toswindow = nil
	
	triggerServerEvent("getSalt", getLocalPlayer(), scripter)
end

function declineTOS(button, state)
	triggerServerEvent("declineTOS", getLocalPlayer())
end

function generateTimestamp(daysAhead)
	return tostring( 50000000 + getRealTime().year * 366 + getRealTime().yearday + daysAhead )
end

function storeSalt(theSalt, theIP)
	ip = theIP
	salt = theSalt
	
	if xmlLoadFile("vgrptut.xml") then
		createXMB()
	else
		showTutorial()
		showCursor(true)
		showChat(true)
	end
end
addEvent("sendSalt", true)
addEventHandler("sendSalt", getRootElement(), storeSalt)

-- ////////////////// tognametags
local nametags = true
function toggleNametags()
	if (nametags) then
		nametags = false
		outputChatBox("Nametags are no longer visible.", 255, 0, 0)
		triggerEvent("hidenametags", getLocalPlayer())
	elseif not (nametags) then
		nametags = true
		outputChatBox("Nametags are now visible.", 0, 255, 0)
		triggerEvent("shownametags", getLocalPlayer())
	end
end
addCommandHandler("tognametags", toggleNametags)
addCommandHandler("togglenametags", toggleNametags)

--============================================================
--							XMB
--============================================================
width, height = guiGetScreenSize()

state = 0
------ STATES
-- 0 = login screen
-- 1 = logged in

function shutdownXMB()
	fadeCamera(false, 0.0)
end
addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()), shutdownXMB)

logoAlpha = 255
logoAlphaDir = 0

errorMsg = nil
errorMsgx = 0
errorMsgy = 0

local xoffset = width / 6
local yoffset = height / 6

local initX = (width / 6.35) + xoffset
local initY = height / 5.2

local initPos = 3
local lowerAlpha = 100

local logoutID = 1
local accountID = 2
local charactersID = 3
local socialID = 4
local achievementsID = 5
local settingsID = 6
local helpID = 7

local mainMenuItems =
{
	[logoutID] = { text = "Logout" },
	[accountID] = { text = "Account" },
	[charactersID] = { text = "Characters" },
	[socialID] = { text = "Social" },
	[achievementsID] = { text = "Achievements" },
	[settingsID] = { text = "Settings" },
	[helpID] = { text = "Help" }
}

local images = { }
for i = 1, #mainMenuItems do
	local v = mainMenuItems[i]
	v.tx = initX + ( i - initPos ) * xoffset
	v.ty = initY
	v.cx = v.tx
	v.cy = v.ty
	v.alpha = initPos == i and 255 or lowerAlpha
	
	images[v.text] = "gui/" .. v.text:lower() .. "-icon.png"
end

local fontHeight1 = dxGetFontHeight(1, "default-bold")
local fontHeight2 = dxGetFontHeight(0.9, "default")

-- SUBMENUS
local characterMenu = { }

local xmbAlpha = 1.0
local currentItem = 3
local currentItemAlpha = 1.0
local lastItemLeft = 2
local lastItemRight = 4
local lastItemAlpha = 1.0

local loadedCharacters = false
local loadedAchievements = false
local loadedFriends = false
local loadedAccount = false
local loadedHelp = false
local loadedSettings = false
local loadingImageRotation = 0

local mtaUsername = nil
local MTAaccountTimer = nil

local tFriends =  { }
local tAchievements =  { }
local tAccount = { }
local tHelp = { }

local currentVerticalItem = 1
lastKey = 0
function drawBG()
	local width, height = guiGetScreenSize()
	-- background
	dxDrawRectangle(0, 0, width, height, tocolor(0, 0, 0, 200 * xmbAlpha), false)
	
	-- top right text and image
	dxDrawText("Valhalla MTA Server", width - 350,80, width-200, 30, tocolor(255, 255, 255, 200 * xmbAlpha), 0.7, "bankgothic", "center", "middle", false, false, false)
	dxDrawText("Sapphire V" .. version, width - 350, 100, width-200, 30, tocolor(255, 255, 255, 200 * xmbAlpha), 0.5, "bankgothic", "center", "middle", false, false, false)
	dxDrawImage(width - 131, 30, 131, 120, "gui/valhalla1.png", 0, 0, 0, tocolor(255, 255, 255, 200 * xmbAlpha), false)
	
	-- fading
	local step = 3
	if (logoAlpha > 0) and (logoAlphaDir == 0) then
		logoAlpha = logoAlpha - step
	elseif (logoAlpha <= 0) and (logoAlphaDir == 0) then
		logoAlphaDir = 1
		logoAlpha = logoAlpha + step
	elseif (logoAlpha < 255) and (logoAlphaDir == 1) then
		logoAlpha = logoAlpha + step
	elseif (logoAlpha >= 255) and (logoAlphaDir == 1) then
		logoAlphaDir = 0
		logoAlpha = logoAlpha - step
	end
	-- end fading
	
	-- error msg
	if (errorMsg ~= nil) then
		dxDrawText(errorMsg, errorMsgx, errorMsgy, errorMsgx, errorMsgy, tocolor(255, 0, 0, logoAlpha * xmbAlpha), 0.5, "bankgothic", "center", "middle", false, false, false)
	end
	
	if (state == 0 ) then -- login screen
		dxDrawLine(50, height / 4, width - 50, height / 4, tocolor(255, 255, 255, 255), 2, false)
		dxDrawText("Login", 80, height / 5, 80, height / 5, tocolor(255, 255, 255, 255), 0.7, "bankgothic", "center", "middle", false, false, false)
	elseif (state == 1 ) then -- attempt login
		dxDrawLine(50, height / 4, width - 50, height / 4, tocolor(255, 255, 255, 255), 2, false)
		dxDrawText("Login", 80, height / 5, 80, height / 5, tocolor(255, 255, 255, 255), 0.7, "bankgothic", "center", "middle", false, false, false)
		local x, y = guiGetPosition(tUsername, false)
		dxDrawText("Attempting to Login...", x, y, x, y, tocolor(255, 255, 255, logoAlpha * xmbAlpha), 0.7, "bankgothic", "center", "middle", false, false, false)
	elseif (state >= 2 ) then -- main XMB
		dxDrawLine(mainMenuItems[1].cx, height / 5, mainMenuItems[#mainMenuItems].cx + 131, height / 5, tocolor(255, 255, 255, 155 * xmbAlpha), 2, false)
		
		-- serial
		dxDrawText(tostring(md5(getElementData(getLocalPlayer(),"gameaccountusername"))), xoffset * 0.3, 10, 150, 30, tocolor(255, 255, 255, 200 * xmbAlpha), 0.8, "verdana", "center", "middle", false, false, false)
		
		-- draw our vertical menus
		-- put the if statements inside, so the logic is still updated!
		drawCharacters()
		drawAchievements()
		drawFriends()
		drawAccount()
		drawSettings()
		drawHelp()
		
		if (lastItemAlpha > 0.0) then
			lastItemAlpha = lastItemAlpha - 0.1
		elseif lastItemAlpha ~= 0 then
			lastItemAlpha = 0
		end
		
		if currentItemAlpha < 1.0 then
			currentItemAlpha = currentItemAlpha + 0.1
		elseif currentItemAlpha ~= 1 then
			currentItemAlpha = 1
		end
		
		dxDrawImage(initX, initY + 20, 130, 93, "gui/icon-glow.png", 0, 0, 0, tocolor(255, 255, 255, logoAlpha * xmbAlpha))
		for i = 1, #mainMenuItems do
			local tx = mainMenuItems[i].tx
			local ty = mainMenuItems[i].ty
			local cx = mainMenuItems[i].cx
			local cy = mainMenuItems[i].cy
			local text = mainMenuItems[i].text
			local alpha = mainMenuItems[i].alpha
		
			-- ANIMATIONS
			if ( round(cx, -1) < round(tx, -1) ) then -- we need to move right!
				mainMenuItems[i].cx = mainMenuItems[i].cx + 10
			end
			
			if ( round(cx, -1) > round(tx, -1) ) then -- we need to move left!
				mainMenuItems[i].cx = mainMenuItems[i].cx - 10
			end
			
			if ( round(cx, -1) == round(initX, -1) ) then -- its the selected
				dxDrawText(text, cx+30, cy+120, cx+100, cy+140, tocolor(255, 255, 255, logoAlpha * xmbAlpha), 0.5, "bankgothic", "center", "middle")
			end
			
			-- ALPHA SMOOTHING
			if ( round(tx, -1) == round(initX, -1) and round(alpha, -1) < 255 ) then
				mainMenuItems[i].alpha = mainMenuItems[i].alpha + 10
			elseif ( tx ~= initX and round(alpha, -1) ~= lowerAlpha ) then
				mainMenuItems[i].alpha = mainMenuItems[i].alpha - 10
			end
			
			if ( mainMenuItems[i].alpha > 255 ) then
				mainMenuItems[i].alpha = 255
			end
		
			dxDrawImage(cx, cy, 131, 120, images[text], 0, 0, 0, tocolor(255, 255, 255, mainMenuItems[i].alpha * xmbAlpha))
		end
	end
end

function round(num, idp)
	if (idp) then
		local mult = 10^idp
		return math.floor(num * mult + 0.5) / mult
	end
	return math.floor(num + 0.5)
end


function createXMB(isChangeAccount)
	guiSetInputEnabled(true)
	addEventHandler("onClientRender", getRootElement(), drawBG)
	showChat(false)
	
	fadeCamera(true)
	setCameraMatrix(1401.4228515625, -887.6865234375, 76.401107788086, 1415.453125, -811.09375, 80.234382629395)

	createXMBLogin(isChangeAccount)
end


--------------------------------------------------------------------
--						LOGIN & REGISTER
--------------------------------------------------------------------
lUsername, lPassword, tUsername, tPassword, bLogin, bRegister, chkRememberLogin, chkAutoLogin = nil
function createXMBLogin(isChangeAccount)
	lUsername = guiCreateLabel(width /2.65, height /2.5, 100, 50, "Username:", false)
	guiSetFont(lUsername, "default-bold-small")
	
	tUsername = guiCreateEdit(width /2.25, height /2.5, 100, 17, "Username", false)
	guiSetFont(tUsername, "default-bold-small")
	guiEditSetMaxLength(tUsername, 32)
	
	lPassword = guiCreateLabel(width /2.65, height /2.3, 100, 50, "Password:", false)
	guiSetFont(lPassword, "default-bold-small")
	
	tPassword = guiCreateEdit(width /2.25, height /2.3, 100, 17, "Password", false)
	guiSetFont(tPassword, "default-bold-small")
	guiEditSetMasked(tPassword, true)
	guiEditSetMaxLength(tPassword, 32)
	
	chkRememberLogin = guiCreateCheckBox(width /2.65, height /2.15, 175, 17, "Remember My Details", false, false)
	addEventHandler("onClientGUIClick", chkRememberLogin, updateRemember)
	guiSetFont(chkRememberLogin, "default-bold-small")
	
	chkAutoLogin = guiCreateCheckBox(width /2.65, height /2.05, 175, 17, "Log in Automatically", false, false)
	guiSetFont(chkAutoLogin, "default-bold-small")
	
	bLogin = guiCreateButton(width /2.65, height /1.9, 75, 17, "Login", false)
	guiSetFont(bLogin, "default-bold-small")
	addEventHandler("onClientGUIClick", bLogin, validateLogin, false)
	
	bRegister = guiCreateButton(width /2.15, height /1.9, 75, 17, "Register", false)
	guiSetFont(bRegister, "default-bold-small")
	
	loginImage = guiCreateStaticImage(width/4, height/2.8, 128, 128, "gui/folder-user.png", false)
	
	loadSavedDetails(isChangeAccount)
end

function updateRemember()
	if (guiCheckBoxGetSelected(chkRememberLogin)) then
		guiSetEnabled(chkAutoLogin, true)
	else
		guiSetEnabled(chkAutoLogin, false)
		guiCheckBoxSetSelected(chkAutoLogin, false)
	end
end

function loadSavedDetails(isChangeAccount)
	local xmlRoot = xmlLoadFile( ip == "127.0.0.1" and "vgrploginlocal.xml" or "vgrplogin.xml" )
	if (xmlRoot) then
		local usernameNode = xmlFindChild(xmlRoot, "username", 0)
		local passwordNode = xmlFindChild(xmlRoot, "password", 0)
		local autologinNode = xmlFindChild(xmlRoot, "autologin", 0)
		local timestampNode = xmlFindChild(xmlRoot, "timestamp", 0)
		local timestamphashNode = xmlFindChild(xmlRoot, "timestamphash", 0)
		local iphashNode = xmlFindChild(xmlRoot, "iphash", 0)
		local uname = nil
		
		if (usernameNode) then
			uname = xmlNodeGetValue(usernameNode)
		end
		
		if (timestampNode and timestamphashNode and iphashNode) then -- no security information? no continuing.
			local timestamp = xmlNodeGetValue(timestampNode)
			local timestampHash = xmlNodeGetValue(timestamphashNode)
			local ipHash = xmlNodeGetValue(iphashNode)
			local currTimestamp = generateTimestamp(0)
			
			-- Split the current ip up
			local octet1 = gettok(ip, 1, string.byte("."))
			local octet2 = gettok(ip, 2, string.byte("."))
			local hashedIP = md5(octet1 .. octet2 .. salt .. uname)
			
			if ( md5(timestamp .. salt) ~= timestampHash) then
				showError(4)
				guiCheckBoxSetSelected(chkAutoLogin, false)
			elseif ( ipHash ~= hashedIP ) then
				showError(5)
				guiCheckBoxSetSelected(chkAutoLogin, false)
			elseif ( currTimestamp >= timestamp ) then
				showError(6)
				guiCheckBoxSetSelected(chkAutoLogin, false)
			else
				if (uname) and (uname~="") then
					guiSetText(tUsername, tostring(uname))
					guiCheckBoxSetSelected(chkRememberLogin, true)
				end
				
				if (passwordNode) then
					local pword = xmlNodeGetValue(passwordNode)
					if (pword) and (pword~="") then
						guiSetText(tPassword, tostring(pword))
						guiCheckBoxSetSelected(chkRememberLogin, true)
					else
						guiSetEnabled(chkAutoLogin, false)
					end
				end
				
				if (autologinNode) then
					local autolog = xmlNodeGetValue(autologinNode)
					if (autolog) and (autolog=="1") then
						
						if(guiGetEnabled(chkAutoLogin)) then
							guiCheckBoxSetSelected(chkAutoLogin, true)
							if not (isChangeAccount) then
								validateLogin()
							end
						end
					end
				else
					guiCheckBoxSetSelected(chkAutoLogin, false)
				end
			end
		end
	end
end

function validateLogin()
	local username = guiGetText(tUsername)
	local password = guiGetText(tPassword)
	
	if (string.len(username)<3) then
		outputChatBox("Your username is too short. You must enter 3 or more characters.", 255, 0, 0)
	elseif (string.find(username, ";", 0)) or (string.find(username, "'", 0)) or (string.find(username, "@", 0)) or (string.find(username, ",", 0)) then
		outputChatBox("Your name cannot contain ;,@.'", 255, 0, 0)
	elseif (string.len(password)<6) then
		outputChatBox("Your password is too short. You must enter 6 or more characters.", 255, 0, 0)
	elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
		outputChatBox("Your password cannot contain ;,@'.", 255, 0, 0)
	else
		if (string.len(password)~=32) then
			password = md5(salt .. password)
		end
		
		local vinfo = getVersion()
		local operatingsystem = vinfo.os
		
		state = 1
		toggleLoginVisibility(false)
		
		
		triggerServerEvent("attemptLogin", getLocalPlayer(), username, password) 
		
		local saveInfo = guiCheckBoxGetSelected(chkRememberLogin)
		local autoLogin = guiCheckBoxGetSelected(chkAutoLogin)
		
		local theFile = xmlCreateFile( ip == "127.0.0.1" and "vgrploginlocal.xml" or "vgrplogin.xml", "login")
		if (theFile) then
			if (saveInfo) then
				local node = xmlCreateChild(theFile, "username")
				xmlNodeSetValue(node, tostring(username))
				
				local node = xmlCreateChild(theFile, "password")
				xmlNodeSetValue(node, tostring(password))
				
				local node = xmlCreateChild(theFile, "autologin")
				if (autoLogin) then
					xmlNodeSetValue(node, tostring(1))
				else
					xmlNodeSetValue(node, tostring(0))
				end
				
				-- security information
				local node = xmlCreateChild(theFile, "timestamp")
				local timestamp = generateTimestamp(7)
				xmlNodeSetValue(node, tostring(timestamp))
				
				local node = xmlCreateChild(theFile, "timestamphash")
				local timestamphash = md5(timestamp .. salt)
				xmlNodeSetValue(node, tostring(timestamphash))
				
				local node = xmlCreateChild(theFile, "iphash")
				local octet1 = gettok(ip, 1, string.byte("."))
				local octet2 = gettok(ip, 2, string.byte("."))
				local hashedIP = md5(octet1 .. octet2 .. salt .. tostring(username))
				xmlNodeSetValue(node, tostring(hashedIP))
			else
				local node = xmlCreateChild(theFile, "username")
				xmlNodeSetValue(node, "")
				
				local node = xmlCreateChild(theFile, "password")
				xmlNodeSetValue(node, "")
				
				local node = xmlCreateChild(theFile, "autologin")
				xmlNodeSetValue(node, tostring(0))
				
				local node = xmlCreateChild(theFile, "timestamp")
				xmlNodeSetValue(node, "")
				
				local node = xmlCreateChild(theFile, "timestamphash")
				xmlNodeSetValue(node, "")
				
				local node = xmlCreateChild(theFile, "iphash")
				xmlNodeSetValue(node, "")
			end
			xmlSaveFile(theFile)
		end
	end
end

function toggleLoginVisibility(visible)
	guiSetVisible(lUsername, visible)
	guiSetVisible(tUsername, visible)
	guiSetVisible(lPassword, visible)
	guiSetVisible(tPassword, visible)
	guiSetVisible(loginImage, visible)
	guiSetVisible(bLogin, visible)
	guiSetVisible(bRegister, visible)
	guiSetVisible(chkRememberLogin, visible)
	guiSetVisible(chkAutoLogin, visible)
end

--------------------------------------------------------------------
--- ERROR CODES
-- 1 = WRONG PW OR USERNAME
-- 2 = ACCOUNT ALREADY LOGGED IN
-- 3 = ACCOUNT BANNED
-- 4 = LOGIN FILE MODIFIED EXTERNALLY
-- 5 = LOGIN FILE DOES NOT BELONG TO THIS PC
-- 6 = LOGIN FILE EXPIRED
errorTimer = nil
function showError(errorCode)
	if (errorCode == 1) then -- wrong pw
		errorMsg = "Invalid Username or Password"
		errorMsgx, errorMsgy = guiGetPosition(tUsername, false)
		local width = guiGetSize(tUsername, false)
		errorMsgx = errorMsgx + (width * 2.5)
		toggleLoginVisibility(true)
		state = 0
	elseif (errorCode == 2) then -- account in use
		errorMsg = "This account is currently in use"
		errorMsgx, errorMsgy = guiGetPosition(tUsername, false)
		local width = guiGetSize(tUsername, false)
		errorMsgx = errorMsgx + (width * 2.5)
		toggleLoginVisibility(true)
		state = 0
	elseif (errorCode == 3) then -- account banned
		errorMsg = "That account is banned"
		errorMsgx, errorMsgy = guiGetPosition(tUsername, false)
		local width = guiGetSize(tUsername, false)
		errorMsgx = errorMsgx + (width * 2.5)
		toggleLoginVisibility(true)
		state = 0
	elseif (errorCode == 4) then
		errorMsg = "Login file was modified externally"
		errorMsgx, errorMsgy = guiGetPosition(tUsername, false)
		local width = guiGetSize(tUsername, false)
		errorMsgx = errorMsgx + (width * 2.5)
		toggleLoginVisibility(true)
		state = 0
	elseif (errorCode == 5) then
		errorMsg = "Login file does not belong to this PC"
		errorMsgx, errorMsgy = guiGetPosition(tUsername, false)
		local width = guiGetSize(tUsername, false)
		errorMsgx = errorMsgx + (width * 2.5)
		toggleLoginVisibility(true)
		state = 0
	elseif (errorCode == 6) then
		errorMsg = "Login file has expired"
		errorMsgx, errorMsgy = guiGetPosition(tUsername, false)
		local width = guiGetSize(tUsername, false)
		errorMsgx = errorMsgx + (width * 2.5)
		toggleLoginVisibility(true)
		state = 0
	end
	
	playSoundFrontEnd(4)
	if (isTimer(errorTimer)) then
		killTimer(errorTimer)
	end
	errorTimer = setTimer(resetError, 5000, 1)
end
addEvent("loginFail", true)
addEventHandler("loginFail", getRootElement(), showError)

function resetError()
	errorMsg = nil
end
--------------------------------------------------------------------------

keyTimer = nil
function moveRight()
	if ( round(mainMenuItems[#mainMenuItems].tx, -1) > initX ) then -- can move left
		for i = 1, #mainMenuItems do
			mainMenuItems[i].tx = mainMenuItems[i].tx - xoffset
			
			if ( round(initX, -1) == round(mainMenuItems[i].tx, -1) ) then
				currentItem = i
				currentItemAlpha = 0.0
				lastItemAlpha = 1.0

				lastItemLeft = i - 1
				lastItemRight = i + 1
			end
		end
		keyTimer = setTimer(checkKeyState, 400, 1, "arrow_r")
		lastKey = 1
	end
end

function moveLeft()
	if ( mainMenuItems[1].tx < initX) then -- can move left
		lastItemAlpha = 1.0
		for i = 1, #mainMenuItems do
			mainMenuItems[i].tx = mainMenuItems[i].tx + xoffset
			
			if ( round(initX, -1) == round(mainMenuItems[i].tx, -1) ) then
				currentItem = i
				currentItemAlpha = 0.0
				lastItemAlpha = 1.0
				
				lastItemLeft = i - 1
				lastItemRight = i + 1
			end
		end
		
		
		keyTimer = setTimer(checkKeyState, 400, 1, "arrow_l")
		lastKey = 2
	end
end

function moveDown()
	local items = { [accountID] = tAccount, [charactersID] = characterMenu, [socialID] = tFriends, [achievementsID] = tAchievements, [helpID] = tHelp }
	local t = items[ currentItem ]
	if t then
		if ( math.ceil( t[#t].ty ) > math.ceil(initY + yoffset + 40) ) then -- can move down
			lastItemAlpha = 1.0
			for i = 1, #t do
				if ( round(t[i].ty, -1) == round(initY + xoffset, -1) ) then -- its selected
					t[i].ty = t[i].ty - 2*yoffset
					
					if currentItem == charactersID and not isLoggedIn() then
						setElementModel(getLocalPlayer(), tonumber(t[i + 1].skin))
					end
				elseif ( round(t[i].ty, -1) < round(initY + xoffset, -1) ) then -- its in the no mans land
					t[i].ty = t[i].ty - yoffset
				else
					t[i].ty = t[i].ty - yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_d")
			lastKey = 3
		end
	end
end

function isLoggedIn()
	return getElementData(getLocalPlayer(), "loggedin") == 1
end

function moveUp()
	local items = { [accountID] = tAccount, [charactersID] = characterMenu, [socialID] = tFriends, [achievementsID] = tAchievements, [helpID] = tHelp }
	local t = items[ currentItem ]
	if t then
		if ( math.ceil( t[1].ty ) < math.ceil(initY + yoffset + 40) ) then -- can move up
			local selIndex = nil
			for k = 1, #t do
				local i = #t - (k - 1)
				if ( round(t[i].ty, -1) == round(initY + xoffset, -1) ) then -- its selected
					t[i].ty = t[i].ty + yoffset
					selIndex = i - 1
					
				elseif (i == selIndex) then -- new selected
					t[i].ty = t[i].ty + 2*yoffset
					
					if currentItem == characterMenu and not isLoggedIn() then
						setElementModel(getLocalPlayer(), tonumber(t[i].skin))
					end
				else
					t[i].ty = t[i].ty + yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_u")
			lastKey = 4
		end
	end
end

function checkKeyState(key)
	if (getKeyState(key)) then
		if ( key == "arrow_l" ) then
			moveLeft()
		elseif ( key == "arrow_r" ) then
			moveRight()
		elseif ( key == "arrow_u" ) then
			moveUp()
		elseif ( key == "arrow_d" ) then
			moveDown()
		end
	else
		keyTimer = nil
	end
end

local currentCharacterID = nil
function selectItemFromVerticalMenu()
	if isPlayerDead( getLocalPlayer( ) ) and getElementData( getLocalPlayer( ), "dbid" ) then
		return
	elseif ( currentItem == charactersID ) then
		-- lets determine which character is selected
		for k = 1, #characterMenu do
			local i = #characterMenu - (k - 1)

			if ( round(characterMenu[k].ty, -1) >= round(initY + xoffset, -1) - 100) then -- selected
				if ( currentCharacterID == k ) then
					hideXMB()
					return
				end
				
				local name = characterMenu[k].name
				local skin = characterMenu[k].skin
				local cked = characterMenu[k].cked
				if not cked or cked == 0 then
					currentCharacterID = k
					state = 3
					triggerServerEvent("spawnCharacter", getLocalPlayer(), name, getVersion().mta)

					hideXMB()
				else
					outputChatBox( name .. " is dead.", 255, 0, 0 )
				end
				break
			end
		end
	elseif ( currentItem == accountID ) then
		for k = 1, #tAccount do
			local i = #tAccount - (k - 1)
			if ( round(tAccount[k].ty, -1) >= round(initY + xoffset, -1) - 100) then -- selected
				local title = tAccount[k].title
				
				if ( title == "Revert to Pre-Beta" ) then -- leave the beta
					local xml = xmlLoadFile("sapphirebeta.xml")
					local betaNode = xmlFindChild(xml, "beta", 0)
					xmlDestroyNode(betaNode)
					xmlSaveFile(xml)
					xmlUnloadFile(xml)
					triggerServerEvent("acceptBeta", getLocalPlayer())
				end
				break
			end
		end
	elseif ( currentItem == logoutID ) then
		-- cleanup
		removeEventHandler("onClientRender", getRootElement(), drawBG)
		state = 0
		
		triggerServerEvent("accountplayer:loggedout", getLocalPlayer())
		
		unbindKey("arrow_l", "down", moveLeft)
		unbindKey("arrow_r", "down", moveRight)
		unbindKey("arrow_u", "down", moveUp)
		unbindKey("arrow_d", "down", moveDown)
		unbindKey("enter", "down", selectItemFromVerticalMenu)
		removeCommandHandler("home", toggleXMB)
		
		createXMB(true)
	end
end


function drawCharacters()
	local currentAlpha = 0
	if currentItem == charactersID then
		currentAlpha = xmbAlpha * currentItemAlpha
	elseif ( lastItemLeft == charactersID and lastKey == 1 ) or ( lastItemRight == charactersID and lastKey == 2 ) then
		currentAlpha = xmbAlpha * lastItemAlpha
	end
		
	if currentAlpha < 0.001 then
		return
	end
	
	local cx = mainMenuItems[charactersID].cx + 30
	if ( loadedCharacters ) then
		for i = 1, #characterMenu do
			local name = characterMenu[i].name
			local age = characterMenu[i].age
			local cked = characterMenu[i].cked
			local cy = characterMenu[i].cy
			local ty = characterMenu[i].ty
			local faction = characterMenu[i].faction
			local rank = characterMenu[i].rank
			local lastseen = characterMenu[i].lastseen
			local skin = characterMenu[i].skin
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			alpha = alpha * currentAlpha
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				characterMenu[i].cy = characterMenu[i].cy - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				characterMenu[i].cy = characterMenu[i].cy + 10
			end
			
			local gender = characterMenu[i].gender == 0 and "Male" or "Female"			
			local agestring = age .. " year old " .. gender
			
			local factionstring = faction
			if cked and cked > 0 then
				factionstring = "Dead."
			elseif rank then
				factionstring = rank .. " of '" .. faction .. "'."
			end
			
			local laststring = "Last Seen: Today"
			if (tonumber(lastseen) > 0) then
				laststring = "Last Seen: " .. lastseen .. " Days Ago."
			end
			
			local color = tocolor(255, 255, 255, alpha)
			
			
			dxDrawText(name, cx-10, cy, cx + dxGetTextWidth(name, 1, "default-bold"), cy + fontHeight1, color, 1, "default-bold", "center", "middle")
			dxDrawText(agestring, cx, cy+20, cx + dxGetTextWidth(agestring, 0.9), cy + 20 + fontHeight2, color, 0.9, "default", "center", "middle")
			dxDrawText(factionstring, cx, cy+40, cx + dxGetTextWidth(factionstring, 0.9), cy + 40 + fontHeight2, color, 0.9, "default", "center", "middle")
			dxDrawText(laststring, cx, cy+60, cx + dxGetTextWidth(laststring, 0.9), cy + 60 + fontHeight2, color, 0.9, "default", "center", "middle")
			
			dxDrawImage(cx - 108, cy, 78, 64, "img/" .. ("%03d"):format(skin) .. ".png", 0, 0, 0, color)
		end
	else
		dxDrawImage(cx + 5, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * 150))
		loadingImageRotation = loadingImageRotation + 5
	end
end

local visible = true
function hideXMB()
	unbindKey("arrow_l", "down", moveLeft)
	unbindKey("arrow_r", "down", moveRight)
	unbindKey("arrow_u", "down", moveUp)
	unbindKey("arrow_d", "down", moveDown)
	unbindKey("enter", "down", selectItemFromVerticalMenu)

	visible = false
	
	addEventHandler("onClientRender", getRootElement(), decreaseAlpha)
end

function toggleXMB()
	if ( visible or not isPlayerDead( getLocalPlayer( ) ) ) and state == 3 and not fading then
		fading = true
		if ( visible ) then
			hideXMB()
		else
			showXMB()
		end
	end
end

function decreaseAlpha()
	if ( xmbAlpha > 0.0 ) then
		xmbAlpha = xmbAlpha - 0.1
	else
		toggleAllControls(true, true, true)
		guiSetInputEnabled(false)
		showCursor(false)
		showChat(true)
			
		showPlayerHudComponent("weapon", true)
		showPlayerHudComponent("ammo", true)
		showPlayerHudComponent("vehicle_name", false)
		showPlayerHudComponent("money", true)		
		showPlayerHudComponent("health", true)
		showPlayerHudComponent("armour", true)
		showPlayerHudComponent("breath", true)
		showPlayerHudComponent("radar", true)
		showPlayerHudComponent("area_name", true)
	
		fading = false
	
		removeEventHandler("onClientRender", getRootElement(), decreaseAlpha)
		removeEventHandler("onClientRender", getRootElement(), drawBG)
	end
end

function increaseAlpha()
	if ( xmbAlpha < 1.0 ) then
		xmbAlpha = xmbAlpha + 0.1
	else
		fading = false
		updateFriends()
		removeEventHandler("onClientRender", getRootElement(), increaseAlpha)
	end
end

function showXMB()
	bindKey("arrow_l", "down", moveLeft)
	bindKey("arrow_r", "down", moveRight)
	bindKey("arrow_u", "down", moveUp)
	bindKey("arrow_d", "down", moveDown)
	bindKey("enter", "down", selectItemFromVerticalMenu)

	visible = true
	toggleAllControls(false, true, true)
	guiSetInputEnabled(false)
	showCursor(false)
	showChat(false)
		
	showPlayerHudComponent("weapon", false)
	showPlayerHudComponent("ammo", false)
	showPlayerHudComponent("vehicle_name", false)
	showPlayerHudComponent("money", false)		
	showPlayerHudComponent("health", false)
	showPlayerHudComponent("armour", false)
	showPlayerHudComponent("breath", false)
	showPlayerHudComponent("radar", false)
	showPlayerHudComponent("area_name", false)

	
	addEventHandler("onClientRender", getRootElement(), increaseAlpha)
	addEventHandler("onClientRender", getRootElement(), drawBG)
end

------------- FRIENDS
function saveFriends(friends, friendsmessage)
	local resource = getResourceFromName("achievement-system")
	
	-- load ourself
	tFriends[1] = { id = getElementData(getLocalPlayer(), "gameaccountid"), username = getElementData(getLocalPlayer(), "gameaccountusername"), message = friendsmessage, country = getElementData(getLocalPlayer(), "country"), online = true, character = nil, cy = initY - yoffset + 40, ty = initY - yoffset + 40 }
	
	for k,v in pairs(friends) do
		local id, username, message, country = unpack( v )
		tFriends[k+1] = { id = id, username = username, message = message, country = country, cy = initY + k*yoffset + 40, ty = initY + k*yoffset + 40 }
		tFriends[k+1].online, tFriends[k].character = isPlayerOnline(id)
	end
	loadedFriends = true
end
addEvent("returnFriends", true)
addEventHandler("returnFriends", getRootElement(), saveFriends)

function updateFriends()
	for i = 1, #tFriends do
		local id = tFriends[i].id
		local online = tFriends[i].online
		
		if ( i ~= 1 ) then
			tFriends[i].online, tFriends[i].character = isPlayerOnline(id)
		end
	end
end

function isPlayerOnline(id)
	for key, value in ipairs(getElementsByType("player")) do
		local pid = getElementData(value, "gameaccountid")

		if (id==pid) then
			return true, string.gsub(getPlayerName(value), "_", " ")
		end
	end
	return false
end

function isSpawned(id)
	for key, value in ipairs(getElementsByType("player")) do
		local pid = getElementData(value, "gameaccountid")

		if (id==pid) then
			return getElementData(value, "loggedin") == 1
		end
	end
	return false
end

function drawFriends()
	local currentAlpha = 0
	if currentItem == socialID then
		currentAlpha = xmbAlpha * currentItemAlpha
	elseif ( lastItemLeft == socialID and lastKey == 1 ) or ( lastItemRight == socialID and lastKey == 2 ) then
		currentAlpha = xmbAlpha * lastItemAlpha
	end
	
	if currentAlpha < 0.001 then
		return
	end
	
	local cx = mainMenuItems[socialID].cx + 30
	if ( loadedFriends ) then
		for i = 1, #tFriends do
			local id = tFriends[i].id
			local name = tFriends[i].username
			local message = "'" .. tFriends[i].message .. "'"
			local country = string.lower(tFriends[i].country)
			local online = tFriends[i].online
			local character = tFriends[i].character
			local cy = tFriends[i].cy
			local ty = tFriends[i].ty
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			alpha = alpha * currentAlpha
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tFriends[i].cy = tFriends[i].cy - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tFriends[i].cy = tFriends[i].cy + 10
			end
			
			local statusText = "Currently Offline"
			local characterText = nil
			
			if (online) then
				if ( i ~= 1 ) then
					statusText = "Online Now!"
				else
					statusText = "You are Online!"
				end
				
				if ( isSpawned(id) ) then
					if ( id == getElementData(getLocalPlayer(), "gameaccountid") ) then
						character = getPlayerName(getLocalPlayer())
					end
					
					if ( character == nil ) then
						characterText = "Currently at Home Menu"
					else
						characterText = "Playing as '" .. character .. "'."
					end
				else
					characterText = "Currently at Home Menu"
				end
			end
			
			local color = tocolor(255, 255, 255, alpha)
			
			
			dxDrawText(name, cx-10, cy, cx + dxGetTextWidth(name, 1, "default-bold"), cy + fontHeight1, color, 1, "default-bold", "center", "middle")
			dxDrawText(statusText, cx, cy+20, cx + dxGetTextWidth(statusText, 0.9), cy + 20 + fontHeight2, color, 0.9, "default", "center", "middle")
			dxDrawText(message, cx, cy+40, cx + dxGetTextWidth(message, 0.9), cy + 40 + fontHeight2, color, 0.9, "default", "center", "middle")
				
			if (characterText) then
				dxDrawText(characterText, cx, cy+60, cx + dxGetTextWidth(characterText, 0.9), cy + 40 + fontHeight2, color, 0.9, "default", "center", "middle")
			end
				
			dxDrawImage(cx - 46, cy, 16, 11, ":social-system/images/flags/" .. country .. ".png", 0, 0, 0, color)
		end
	else
		dxDrawImage(cx + 5, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, currentAlpha * 150))
		loadingImageRotation = loadingImageRotation + 5
	end
end


----------- ACHIEVEMENTS
function saveAchievements(achievements)
	local resource = getResourceFromName("achievement-system")
	
	for k,v in pairs(achievements) do
		tAchievements[k] = { date = v[2], cy = initY + k * yoffset + 40, ty = initY + k * yoffset + 40 }
		tAchievements[k].name, tAchievements[k].desc, tAchievements[k].points = unpack( call( getResourceFromName( "achievement-system" ), "getAchievementInfo", v[1] ) )
	end
	loadedAchievements = true
end
addEvent("returnAchievements", true)
addEventHandler("returnAchievements", getRootElement(), saveAchievements)

function drawAchievements()
	local currentAlpha = 0
	if currentItem == achievementsID then
		currentAlpha = xmbAlpha * currentItemAlpha
	elseif ( lastItemLeft == achievementsID and lastKey == 1 ) or ( lastItemRight == achievementsID and lastKey == 2 ) then
		currentAlpha = xmbAlpha * lastItemAlpha
	end
		
	if currentAlpha < 0.001 then
		return
	end
	
	local cx = mainMenuItems[achievementsID].cx
	if ( loadedAchievements ) then
		for i = 1, #tAchievements do
			local name = tAchievements[i].name
			local desc = tAchievements[i].desc
			local points = "Points: " .. tostring(tAchievements[i].points)
			local date = "Unlocked: " .. tostring(tAchievements[i].date)
			local cy = tAchievements[i].cy
			local ty = tAchievements[i].ty
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			alpha = alpha * currentAlpha
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tAchievements[i].cy = tAchievements[i].cy - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tAchievements[i].cy = tAchievements[i].cy + 10
			end
			
			local color = tocolor(255, 255, 255, alpha)

			
			dxDrawText(name, cx-10, cy, cx + dxGetTextWidth(name, 1, "default-bold"), cy + fontHeight1, color, 1, "default-bold", "center", "middle")
			dxDrawText(desc, cx, cy+20, cx + dxGetTextWidth(desc, 0.9), cy + 20 + fontHeight2, color, 0.9, "default", "center", "middle")
			dxDrawText(points, cx, cy+40, cx + dxGetTextWidth(points, 0.9), cy + 40 + fontHeight2, color, 0.9, "default", "center", "middle")
			dxDrawText(date, cx, cy+60, cx + dxGetTextWidth(date, 0.9), cy + 60 + fontHeight2, color, "default", "center", "middle")
			
			dxDrawImage(cx - 108, cy, 78, 64, ":achievement-system/achievement.png", 0, 0, 0, color)
		end
	else
		dxDrawImage(cx + 5, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, currentAlpha * 150))
		loadingImageRotation = loadingImageRotation + 5
	end
end

function checkForMTAAccount()
	--[[
	if ( getPlayerUserName() ) then
		outputDebugString("DETECTED MTA ACCOUNT: " .. getPlayerUserName())
		mtaUsername = getPlayerUserName()
		triggerServerEvent("storeMTAUsername", getLocalPlayer())
		killTimer(MTAaccountTimer)
		MTAaccountTimer = nil
		
		tAccount[1].title = "MTA Account"
		tAccount[1].text = tostring(getPlayerUserName())
	end
	]]--
end

-- Detect friends logging in
local friendAlertUsername = nil
local friendAlertTimer = nil
local friendAlertType = 0
local friendAlertAlpha = 0
local friendAlertFadeIn = true
local friendAlertVisible = false
local friendAlertCharname = nil
function friendLogin(username)
	for i = 1, #tFriends do
		if ( tostring(tFriends[i].username) == username ) then
			friendAlertType = 0
			showFriendOnline(username)
			break
		end
	end
end
addEvent("onPlayerAccountLogin", true)
addEventHandler("onPlayerAccountLogin", getRootElement(), friendLogin)

function characterChange(charname, username)
	local username = getElementData(source, "gameaccountusername")
	for i = 1, #tFriends do
		if ( tostring(tFriends[i].username) == username ) then
			friendAlertType = 1
			friendAlertCharname = string.gsub(charname, "_", " ")
			showFriendOnline(username)
			break
		end
	end
end
addEvent("onPlayerCharacterChange", true)
addEventHandler("onPlayerCharacterChange", getRootElement(), characterChange)

function showFriendOnline(username)
	if ( friendAlertVisible ) then
		hideFriendAlert()
		removeEventHandler("onClientRender", getRootElement(), showFriendAlert)
	end
	
	-- disable hud elements
	showPlayerHudComponent("clock", false)
	showPlayerHudComponent("weapon", false)
	showPlayerHudComponent("ammo", false)
	showPlayerHudComponent("health", false)
	showPlayerHudComponent("armour", false)
	showPlayerHudComponent("breath", false)
	showPlayerHudComponent("money", false)

	friendAlertVisible = true
	friendAlertFadeIn = true
	friendAlertUsername = username
	friendAlertAlpha = 0
	addEventHandler("onClientRender", getRootElement(), showFriendAlert)
end

function hideFriendAlert()
	if ( isTimer(friendAlertTimer) ) then
		killTimer(friendAlertTimer)
		friendAlertTimer = nil
	end
	
	friendAlertFadeIn = false
end

function showFriendAlert()
	if ( friendAlertAlpha < 150 and friendAlertFadeIn ) then
		friendAlertAlpha = friendAlertAlpha + 5
	elseif ( friendAlertAlpha > 0 and not friendAlertFadeIn ) then
		friendAlertAlpha = friendAlertAlpha - 5
	end
	
	if ( friendAlertAlpha >= 150 and friendAlertFadeIn and not isTimer(friendAlertTimer) ) then
		friendAlertTimer = setTimer(hideFriendAlert, 3000, 1)
	elseif ( friendAlertAlpha <= 0 and not friendAlertFadeIn ) then
		-- enable hud elements
		showPlayerHudComponent("clock", true)
		showPlayerHudComponent("weapon", true)
		showPlayerHudComponent("ammo", true)
		showPlayerHudComponent("health", true)
		showPlayerHudComponent("armour", true)
		showPlayerHudComponent("breath", true)
		showPlayerHudComponent("money", true)
		
		friendAlertAlpha = 0
		removeEventHandler("onClientRender", getRootElement(), showFriendAlert)
		
		friendAlertVisible = false
	end
	
	dxDrawRectangle(width - xoffset*2, 30, xoffset*1.9, 120, tocolor(0, 0, 0, friendAlertAlpha), false)
	
	local x = width - xoffset*2
	local y = 30
	dxDrawText(friendAlertUsername, x+10, y+10, x + xoffset*1.9, y + 120, tocolor(0,0,0, friendAlertAlpha + 50), 2, "sans", "center", "center", false, false, false)
	dxDrawText(friendAlertUsername, x, y, x + xoffset*1.9, y + 120, tocolor(255, 255, 255, friendAlertAlpha + 50), 2, "sans", "center", "center", false, false, false)

	if ( friendAlertType == 0 ) then
		local x = width - xoffset*1.6
		local y = 20 + dxGetFontHeight(2, "sans")
		dxDrawText("has just signed in.", x+10, y+10, x + xoffset*1.8, y + 120, tocolor(0,0,0, friendAlertAlpha + 50), 1, "sans", "center", "center", false, false, false)
		dxDrawText("has just signed in.", x, y, x + xoffset*1.8, y + 120, tocolor(255, 255, 255, friendAlertAlpha + 50), 1, "sans", "center", "center", false, false, false)
	elseif ( friendAlertType == 1 ) then
		local x = width - xoffset*2.0
		local y = 20 + dxGetFontHeight(2, "sans")
		dxDrawText("is now playing as '" .. friendAlertCharname .. "'", x+10, y+10, x + xoffset*2.2, y + 120, tocolor(0,0,0, friendAlertAlpha + 50), 1, "sans", "center", "center", false, false, false)
		dxDrawText("is now playing as '" .. friendAlertCharname .. "'", x, y, x + xoffset*2.2, y + 120, tocolor(255, 255, 255, friendAlertAlpha + 50), 1, "sans", "center", "center", false, false, false)
	end
end

function drawAccount()
	local currentAlpha = 0
	if currentItem == accountID then
		currentAlpha = xmbAlpha * currentItemAlpha
	elseif ( lastItemLeft == accountID and lastKey == 1 ) or ( lastItemRight == accountID and lastKey == 2 ) then
		currentAlpha = xmbAlpha * lastItemAlpha
	end
	
	if currentAlpha == 0 then
		return
	end
	
	local cx = mainMenuItems[accountID].cx + 30
	if ( loadedAccount ) then
		for i = 1, #tAccount do
			local title = tAccount[i].title
			local text = tAccount[i].text
			local cy = tAccount[i].cy
			local ty = tAccount[i].ty
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			alpha = alpha * currentAlpha
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tAccount[i].cy = tAccount[i].cy - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tAccount[i].cy = tAccount[i].cy + 10
			end
			
			local color = tocolor(255, 255, 255, alpha)
			
			dxDrawText(title, cx-10, cy, cx + dxGetTextWidth(title, 1, "default-bold"), cy + fontHeight1, color, 1, "default-bold", "center", "middle")
			dxDrawText(text, cx, cy+20, cx + dxGetTextWidth(text, 0.9, "default"), cy + 20 + fontHeight2, color, 0.9, "default", "left", "middle")
		end
	else
		dxDrawImage(cx + 5, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, currentAlpha * 150))
		loadingImageRotation = loadingImageRotation + 5
	end
end

function drawSettings()
	local currentAlpha = 0
	if currentItem == settingsID then
		currentAlpha = xmbAlpha * currentItemAlpha
	elseif ( lastItemLeft == settingsID and lastKey == 1 ) or ( lastItemRight == settingsID and lastKey == 2 ) then
		currentAlpha = xmbAlpha * lastItemAlpha
	end
	
	if currentAlpha == 0 then
		return
	end
	
	local cx = mainMenuItems[settingsID].cx + 30
	if ( loadedSettings ) then
		
	else
		dxDrawImage(cx + 5, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, currentAlpha * 150))
		loadingImageRotation = loadingImageRotation + 5
	end
end

function drawHelp()
	local currentAlpha = 0
	if currentItem == helpID then
		currentAlpha = xmbAlpha * currentItemAlpha
	elseif ( lastItemLeft == helpID and lastKey == 1 ) or ( lastItemRight == helpID and lastKey == 2 ) then
		currentAlpha = xmbAlpha * lastItemAlpha
	end
	
	if currentAlpha == 0 then
		return
	end
	
	local cx = mainMenuItems[helpID].cx + 30
	if ( loadedHelp ) then
		for i = 1, #tHelp do
			local title = tHelp[i].title
			local text = tHelp[i].text
			local cy = tHelp[i].cy
			local ty = tHelp[i].ty
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			alpha = alpha * currentAlpha
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tHelp[i].cy = tHelp[i].cy - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tHelp[i].cy = tHelp[i].cy + 10
			end
			
			local color = tocolor(255, 255, 255, alpha)
			
			dxDrawText(title, cx-10, cy, cx + dxGetTextWidth(title, 1, "default-bold"), cy + fontHeight1, color, 1, "default-bold", "center", "middle")
			dxDrawText(text, cx, cy+20, cx + dxGetTextWidth(text, 0.9), cy + 20 + fontHeight2, color, 0.9, "default", "left", "middle")
		end
	else
		dxDrawImage(cx + 5, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, currentAlpha * 150))
		loadingImageRotation = loadingImageRotation + 5
	end
end

function manageCamera()
	setControlState("change_camera", true)
end

function createXMBMain(characters)
	setCameraMatrix(1401.4228515625, -887.6865234375, 76.401107788086, 1415.453125, -811.09375, 80.234382629395)
	
	state = 2
	
	toggleAllControls(false, true, true)
	guiSetInputEnabled(false)
	bindKey("arrow_l", "down", moveLeft)
	bindKey("arrow_r", "down", moveRight)
	bindKey("arrow_u", "down", moveUp)
	bindKey("arrow_d", "down", moveDown)
	bindKey("enter", "down", selectItemFromVerticalMenu)
	toggleControl("change_camera", false)
	
	keys = getBoundKeys("change_camera")
	for name, state in pairs(keys) do
		if ( name ~= "home" ) then
			bindKey(name, "down", manageCamera)
		end
	end
	addCommandHandler("home", toggleXMB)
	bindKey("home", "down", "home")
end
addEvent("loginOK", true)
addEventHandler("loginOK", getRootElement(), createXMBMain)

function saveHelpInformation()
	tHelp = {
		{ title = "My Reports", text = "You currently have no tickets open." },
		{ title = "Reports Affecting Me", text = "You currently have no reports regarding yourself." },
		{ title = "Report a Bug", text = "Select this to report a bug directly to Mantis." }
	}
	
	for k, v in ipairs( tHelp ) do
		v.cy = initY + k * yoffset + 40
		v.ty = v.cy
	end
	
	loadedHelp = true
end

function saveAccountInformation(mtausername)
	-- FORUM ACCOUNT
	tAccount[1] = { }
	tAccount[1].title = "Revert to Pre-Beta"
	tAccount[1].text = "Select this to revert to the Pre-Sapphire GUI."
	tAccount[1].cx = initX
	tAccount[1].cy = initY + yoffset + 40
	tAccount[1].tx = initX
	tAccount[1].ty = initY + yoffset + 40

	-- MTA USERNAME/ACCOUNT
	if ( mtausername ) then
		mtaUsername = mtausername
		
		tAccount[2] = { }
		tAccount[2].title = "MTA Account"
		tAccount[2].text = mtausername
	else
		MTAaccountTimer = setTimer(checkForMTAAccount, 1000, 0)
		tAccount[2] = { }
		tAccount[2].title = "MTA Account"
		tAccount[2].text = "You currently have no account linked.\nLog into one under Settings -> Community to link it."
	end
	tAccount[2].cx = initX
	tAccount[2].cy = initY + 2*yoffset + 40
	tAccount[2].tx = initX
	tAccount[2].ty = initY + 2*yoffset + 40
	
	-- FORUM ACCOUNT
	tAccount[3] = { }
	tAccount[3].title = "Forum Account"
	tAccount[3].text = "You currently have no forum account linked.\nSelect this option to link one."
	tAccount[3].cx = initX
	tAccount[3].cy = initY + 3*yoffset + 40
	tAccount[3].tx = initX
	tAccount[3].ty = initY + 3*yoffset + 40
	
	-- PSN ACCOUNT
	tAccount[4] = { }
	tAccount[4].title = "Playstation Network® Account"
	tAccount[4].text = "You currently have no Playstation Network® account linked.\nSelect this option to link one."
	tAccount[4].cx = initX
	tAccount[4].cy = initY + 4*yoffset + 40
	tAccount[4].tx = initX
	tAccount[4].ty = initY + 4*yoffset + 40
	
	-- XBOX LIVE ACCOUNT
	tAccount[5] = { }
	tAccount[5].title = "Xbox Live® Account"
	tAccount[5].text = "You currently have no Xbox Live® account linked.\nSelect this option to link one."
	tAccount[5].cx = initX
	tAccount[5].cy = initY + 5*yoffset + 40
	tAccount[5].tx = initX
	tAccount[5].ty = initY + 5*yoffset + 40
	
	-- STEAM ACCOUNT
	tAccount[6] = { }
	tAccount[6].title = "Steam® Account"
	tAccount[6].text = "You currently have no Steam® account linked.\nSelect this option to link one."
	tAccount[6].cx = initX
	tAccount[6].cy = initY + 6*yoffset + 40
	tAccount[6].tx = initX
	tAccount[6].ty = initY + 6*yoffset + 40
	
	loadedAccount = true
	saveHelpInformation()
end
addEvent("storeAccountInformation", true)
addEventHandler("storeAccountInformation", getLocalPlayer(), saveAccountInformation)

function saveCharacters(characters)
	-- load the characters
	setCameraMatrix(1401.4228515625, -887.6865234375, 76.401107788086, 1415.453125, -811.09375, 80.234382629395)
	for k, v in ipairs(characters) do	
		characterMenu[k] = { id = v[1], name = v[2]:gsub("_", " "), cked = v[3], lastarea = v[4], age = v[5], gender = v[6], faction = v[7] or "Not in a faction.", rank = v[8], skin = v[9], lastseen = v[10], cy = initY + k * yoffset + 40, ty = initY + k * yoffset + 40 }
	end
	loadedCharacters = true
end
addEvent("showCharacterSelection", true)
addEventHandler("showCharacterSelection", getRootElement(), saveCharacters)
end