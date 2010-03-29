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

local images = { }
images["Characters"] = "gui/characters-icon.png"
images["Account"] = "gui/account-icon.png"
images["Help"] = "gui/help-icon.png"
images["Logout"] = "gui/logout-icon.png"
images["Settings"] = "gui/settings-icon.png"
images["Social"] = "gui/social-icon.png"
images["Achievements"] = "gui/achievements-icon.png"

local current = { }

current["Logout"] = { }
current["Logout"]["x"] = 70
current["Logout"]["y"] = height / 100
current["Logout"]["width"] = 90
current["Logout"]["height"] = 80

current["Characters"] = { }
current["Characters"]["x"] = 70
current["Characters"]["y"] = height / 6.35
current["Characters"]["width"] = 131
current["Characters"]["height"] = 120

current["Account"] = { }
current["Account"]["x"] = 70
current["Account"]["y"] = height / 2.7
current["Account"]["width"] = 90
current["Account"]["height"] = 80

current["Social"] = { }
current["Social"]["x"] = 70
current["Social"]["y"] = height / 1.9
current["Social"]["width"] = 90
current["Social"]["height"] = 80

current["Settings"] = { }
current["Settings"]["x"] = 70
current["Settings"]["y"] = height / 1.5
current["Settings"]["width"] = 90
current["Settings"]["height"] = 80

current["Help"] = { }
current["Help"]["x"] = 70
current["Help"]["y"] = height / 1.24
current["Help"]["width"] = 90
current["Help"]["height"] = 80

local xoffset = width / 6
local yoffset = height / 6

local initX = (width / 6.35) + xoffset
local initY = height / 5.2

local initPos = 3
local lowerAlpha = 100

local mainMenuItems = { }

local lowerBound = 0
mainMenuItems[lowerBound] = { }
mainMenuItems[lowerBound]["text"] = "Logout"

local logoutID = 1
mainMenuItems[logoutID] = { }
mainMenuItems[logoutID]["text"] = "Logout"
mainMenuItems[logoutID]["tx"] = initX - 2*xoffset
mainMenuItems[logoutID]["ty"] = initY
mainMenuItems[logoutID]["cx"] = initX - 2*xoffset
mainMenuItems[logoutID]["cy"] = initY
mainMenuItems[logoutID]["alpha"] = lowerAlpha

local accountID = 2
mainMenuItems[accountID] = { }
mainMenuItems[accountID]["text"] = "Account"
mainMenuItems[accountID]["tx"] = initX - xoffset
mainMenuItems[accountID]["ty"] = initY
mainMenuItems[accountID]["cx"] = initX - xoffset
mainMenuItems[accountID]["cy"] = initY
mainMenuItems[accountID]["alpha"] = lowerAlpha

local charactersID = 3
mainMenuItems[charactersID] = { }
mainMenuItems[charactersID]["text"] = "Characters"
mainMenuItems[charactersID]["tx"] = initX
mainMenuItems[charactersID]["ty"] = initY
mainMenuItems[charactersID]["cx"] = initX
mainMenuItems[charactersID]["cy"] = initY
mainMenuItems[charactersID]["alpha"] = 255

local socialID = 4
mainMenuItems[socialID] = { }
mainMenuItems[socialID]["text"] = "Social"
mainMenuItems[socialID]["tx"] = initX + xoffset
mainMenuItems[socialID]["ty"] = initY
mainMenuItems[socialID]["cx"] = initX + xoffset
mainMenuItems[socialID]["cy"] = initY
mainMenuItems[socialID]["alpha"] = lowerAlpha

local achievementsID = 5
mainMenuItems[achievementsID] = { }
mainMenuItems[achievementsID]["text"] = "Achievements"
mainMenuItems[achievementsID]["tx"] = initX + 2*xoffset
mainMenuItems[achievementsID]["ty"] = initY
mainMenuItems[achievementsID]["cx"] = initX + 2*xoffset
mainMenuItems[achievementsID]["cy"] = initY
mainMenuItems[achievementsID]["alpha"] = lowerAlpha

local settingsID = 6
mainMenuItems[settingsID] = { }
mainMenuItems[settingsID]["text"] = "Settings"
mainMenuItems[settingsID]["tx"] = initX + 3*xoffset
mainMenuItems[settingsID]["ty"] = initY
mainMenuItems[settingsID]["cx"] = initX + 3*xoffset
mainMenuItems[settingsID]["cy"] = initY
mainMenuItems[settingsID]["alpha"] = lowerAlpha

local helpID = 7
mainMenuItems[helpID] = { }
mainMenuItems[helpID]["text"] = "Help"
mainMenuItems[helpID]["tx"] = initX + 4*xoffset
mainMenuItems[helpID]["ty"] = initY
mainMenuItems[helpID]["cx"] = initX + 4*xoffset
mainMenuItems[helpID]["cy"] = initY
mainMenuItems[helpID]["alpha"] = lowerAlpha

local upperBound = 8
mainMenuItems[upperBound] = { }
mainMenuItems[upperBound]["text"] = "Logout"

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
		dxDrawLine(mainMenuItems[1]["cx"], height / 5, mainMenuItems[#mainMenuItems - 1]["cx"] + 131, height / 5, tocolor(255, 255, 255, 155 * xmbAlpha), 2, false)
		
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
		end
		
		if (currentItemAlpha < 1.0) then
			currentItemAlpha = currentItemAlpha + 0.1
		end
		
		-- draw our progressBar
		if (mainMenuItems[currentItem]["text"] == "Characters") then
			--local linex = characterMenu[1]["cx"] - 100
			--dxDrawLine(linex, characterMenu[1]["cy"], linex, characterMenu[#characterMenu]["cy"] + 85, tocolor(255, 255, 255, 155), 2, false)
		end
		
		dxDrawImage(initX, initY + 20, 130, 93, "gui/icon-glow.png", 0, 0, 0, tocolor(255, 255, 255, logoAlpha * xmbAlpha), false)
		for i = 1, #mainMenuItems - 1 do
			local tx = mainMenuItems[i]["tx"]
			local ty = mainMenuItems[i]["ty"]
			local cx = mainMenuItems[i]["cx"]
			local cy = mainMenuItems[i]["cy"]
			local text = mainMenuItems[i]["text"]
			local alpha = mainMenuItems[i]["alpha"]
		
			-- ANIMATIONS
			if ( round(cx, -1) < round(tx, -1) ) then -- we need to move right!
				mainMenuItems[i]["cx"] = mainMenuItems[i]["cx"] + 10
			end
			
			if ( round(cx, -1) > round(tx, -1) ) then -- we need to move left!
				mainMenuItems[i]["cx"] = mainMenuItems[i]["cx"] - 10
			end
			
			if ( round(cx, -1) == round(initX, -1) ) then -- its the selected
				dxDrawText(text, cx+30, cy+120, cx+100, cy+140, tocolor(255, 255, 255, logoAlpha * xmbAlpha), 0.5, "bankgothic", "center", "middle", false, false, false)
			end
			
			-- ALPHA SMOOTHING
			if ( round(tx, -1) == round(initX, -1) and round(alpha, -1) < 255 ) then
				mainMenuItems[i]["alpha"] = mainMenuItems[i]["alpha"] + 10
			elseif ( tx ~= initX and round(alpha, -1) ~= lowerAlpha ) then
				mainMenuItems[i]["alpha"] = mainMenuItems[i]["alpha"] - 10
			end
			
			if ( mainMenuItems[i]["alpha"] > 255 ) then
				mainMenuItems[i]["alpha"] = 255
			end
		
			dxDrawImage(cx, cy, 131, 120, images[text], 0, 0, 0, tocolor(255, 255, 255, mainMenuItems[i]["alpha"] * xmbAlpha), false)
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
	if ( round(mainMenuItems[#mainMenuItems - 1]["tx"], -1) > initX ) then -- can move left
		for i = 1, #mainMenuItems - 1 do
			mainMenuItems[i]["tx"] = mainMenuItems[i]["tx"] - xoffset
			
			if ( round(initX, -1) == round(mainMenuItems[i]["tx"], -1) ) then
				currentItem = i
				currentItemAlpha = 0.0
				lastItemAlpha = 1.0

				lastItemLeft = i - 1
				lastItemRight = i + 1
			end
		end
		keyTimer = setTimer(checkKeyState, 200, 1, "arrow_r")
		lastKey = 1
	end
end

function moveLeft()
	if ( mainMenuItems[1]["tx"] < initX) then -- can move left
		lastItemAlpha = 1.0
		for i = 1, #mainMenuItems - 1 do
			mainMenuItems[i]["tx"] = mainMenuItems[i]["tx"] + xoffset
			
			if ( round(initX, -1) == round(mainMenuItems[i]["tx"], -1) ) then
				currentItem = i
				currentItemAlpha = 0.0
				lastItemAlpha = 1.0
				
				lastItemLeft = i - 1
				lastItemRight = i + 1
			end
		end
		
		
		keyTimer = setTimer(checkKeyState, 200, 1, "arrow_l")
		lastKey = 2
	end
end

function moveDown()
	-- CHARACTERS
	if ( currentItem == charactersID ) then
		if ( characterMenu[#characterMenu]["ty"] > (initY + yoffset + 40) ) then -- can move up
			lastItemAlpha = 1.0
			for i = 1, #characterMenu do
				if ( round(characterMenu[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					characterMenu[i]["ty"] = characterMenu[i]["ty"] - 2*yoffset
					
					if ( not isLoggedIn() ) then
						setElementModel(getLocalPlayer(), tonumber(characterMenu[i + 1]["skin"]))
					end
				elseif ( round(characterMenu[i]["ty"], -1) < round(initY + xoffset, -1) ) then -- its in the no mans land
					characterMenu[i]["ty"] = characterMenu[i]["ty"] - yoffset
				else
					characterMenu[i]["ty"] = characterMenu[i]["ty"] - yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_d")
			lastKey = 3
		end
		
	-- ACHIEVEMENTS
	elseif ( currentItem == achievementsID ) then
		if ( tAchievements[#tAchievements]["ty"] > (initY + xoffset + 40) ) then -- can move up
			lastItemAlpha = 1.0
			for i = 1, #tAchievements do
				if ( round(tAchievements[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					tAchievements[i]["ty"] = tAchievements[i]["ty"] - 2*yoffset
				else
					tAchievements[i]["ty"] = tAchievements[i]["ty"] - yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_d")
			lastKey = 3
		end
		
	-- FRIENDS
	elseif ( currentItem == socialID ) then
		if ( tFriends[#tFriends]["ty"] > (initY + yoffset + 40) ) then -- can move up
			lastItemAlpha = 1.0
			for i = 1, #tFriends do
				if ( round(tFriends[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					tFriends[i]["ty"] = tFriends[i]["ty"] - 2*yoffset
				else
					tFriends[i]["ty"] = tFriends[i]["ty"] - yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_d")
			lastKey = 3
		end
		
	-- ACCOUNT
	elseif ( currentItem == accountID ) then
		if ( tAccount[#tAccount]["ty"] > (initY + yoffset + 40) ) then -- can move up
			lastItemAlpha = 1.0
			for i = 1, #tAccount do
				if ( round(tAccount[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					tAccount[i]["ty"] = tAccount[i]["ty"] - 2*yoffset
				elseif ( round(tAccount[i]["ty"], -1) < round(initY + xoffset, -1) ) then -- its in the no mans land
					tAccount[i]["ty"] = tAccount[i]["ty"] - yoffset
				else
					tAccount[i]["ty"] = tAccount[i]["ty"] - yoffset
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
	-- CHARACTERS
	if ( currentItem == charactersID ) then
		if ( characterMenu[1]["ty"] < (initY + yoffset + 40) ) then -- can move down
			local selIndex = nil
			for k = 1, #characterMenu do
				local i = #characterMenu - (k - 1)
				if ( round(characterMenu[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					characterMenu[i]["ty"] = characterMenu[i]["ty"] + yoffset
					selIndex = i - 1
					
				elseif (i == selIndex) then -- new selected
					characterMenu[i]["ty"] = characterMenu[i]["ty"] + 2*yoffset
					
					if ( not isLoggedIn() ) then
						setElementModel(getLocalPlayer(), tonumber(characterMenu[i]["skin"]))
					end
				else
					characterMenu[i]["ty"] = characterMenu[i]["ty"] + yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_u")
			lastKey = 4
		end
	
	-- ACHIEVEMENTS
	elseif ( currentItem == achievementsID ) then
		if ( tAchievements[1]["ty"] < (initY + yoffset + 40) ) then -- can move down
			local selIndex = nil
			for k = 1, #tAchievements do
				local i = #tAchievements - (k - 1)
				if ( round(tAchievements[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					tAchievements[i]["ty"] = tAchievements[i]["ty"] + yoffset
					selIndex = i - 1
				elseif (i == selIndex) then -- new selected
					tAchievements[i]["ty"] = tAchievements[i]["ty"] + 2*yoffset
				else
					tAchievements[i]["ty"] = tAchievements[i]["ty"] + yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_u")
			lastKey = 4
		end
		
	-- FRIENDS
	elseif ( currentItem == socialID ) then
		if ( tFriends[1]["ty"] < (initY + yoffset + 40) ) then -- can move down
			local selIndex = nil
			for k = 1, #tFriends do
				local i = #tFriends - (k - 1)
				if ( round(tFriends[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					tFriends[i]["ty"] = tFriends[i]["ty"] + yoffset
					selIndex = i - 1
				elseif (i == selIndex) then -- new selected
					tFriends[i]["ty"] = tFriends[i]["ty"] + 2*yoffset
				else
					tFriends[i]["ty"] = tFriends[i]["ty"] + yoffset
				end
			end
			keyTimer = setTimer(checkKeyState, 200, 1, "arrow_u")
			lastKey = 4
		end
		
	-- ACCOUNT
	elseif ( currentItem == accountID ) then
		if ( tAccount[1]["ty"] < (initY + yoffset + 40) ) then -- can move down
			local selIndex = nil
			for k = 1, #tAccount do
				local i = #tAccount - (k - 1)
				if ( round(tAccount[i]["ty"], -1) == round(initY + xoffset, -1) ) then -- its selected
					tAccount[i]["ty"] = tAccount[i]["ty"] + yoffset
					selIndex = i - 1
				elseif (i == selIndex) then -- new selected
					tAccount[i]["ty"] = tAccount[i]["ty"] + 2*yoffset
				else
					tAccount[i]["ty"] = tAccount[i]["ty"] + yoffset
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
	elseif ( mainMenuItems[currentItem]["text"] == "Characters" ) then
		-- lets determine which character is selected
		for k = 1, #characterMenu do
			local i = #characterMenu - (k - 1)

			if ( round(characterMenu[k]["ty"], -1) >= round(initY + xoffset, -1) - 100) then -- selected
				if ( currentCharacterID == k ) then
					hideXMB()
					return
				end
				
				local name = characterMenu[k]["name"]
				local skin = characterMenu[k]["skin"]
				local cked = characterMenu[k]["cked"]
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
	elseif ( mainMenuItems[currentItem]["text"] == "Account" ) then
		for k = 1, #tAccount do
			local i = #tAccount - (k - 1)
			if ( round(tAccount[k]["ty"], -1) >= round(initY + xoffset, -1) - 100) then -- selected
				local title = tAccount[k]["title"]
				
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
	elseif ( mainMenuItems[currentItem]["text"] == "Logout" ) then
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
	if ( loadedCharacters ) then
		for i = 1, #characterMenu do
			local name = characterMenu[i]["name"]
			local age = characterMenu[i]["age"]
			local cked = characterMenu[i]["cked"]
			local cx = characterMenu[i]["cx"]
			local cy = characterMenu[i]["cy"]
			local tx = characterMenu[i]["tx"]
			local ty = characterMenu[i]["ty"]
			local faction = characterMenu[i]["faction"]
			local rank = characterMenu[i]["rank"]
			local lastseen = characterMenu[i]["lastseen"]
			local skin = characterMenu[i]["skin"]
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				--if ( round(ty, -1) == round((initY - yoffset + 40), -1) ) then -- up top = move faster since we're covering twice the distance
				--	characterMenu[i]["cy"] = characterMenu[i]["cy"] - 10
				--else
					characterMenu[i]["cy"] = characterMenu[i]["cy"] - 10
				--end
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				--if ( round(ty, -1) == round((initY + yoffset + 40), -1) ) then -- up top = move faster since we're covering twice the distance
				--	characterMenu[i]["cy"] = characterMenu[i]["cy"] + 10
				--else
					characterMenu[i]["cy"] = characterMenu[i]["cy"] + 10
				--end
			end
			
			local gender = characterMenu[i]["gender"]
			if (gender == 0) then
				gender = "Male"
			else
				gender = "Female"
			end
			
			local agestring = age .. " year old " .. gender
			local factionstring = faction
			if cked and cked > 0 then
				factionstring = "Dead"
			elseif rank then
				factionstring = rank .. " of '" .. faction .. "'."
			end
			
			local laststring = "Last Seen: Today"
			if (tonumber(lastseen) > 0) then
				laststring = "Last Seen: " .. lastseen .. " Days Ago."
			end
			
			if ( mainMenuItems[currentItem]["text"] == "Characters") then
				cx = mainMenuItems[currentItem]["cx"]
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(agestring, cx+30, cy+20, cx + 30 + dxGetTextWidth(agestring, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(factionstring, cx+30, cy+40, cx + 30 + dxGetTextWidth(factionstring, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(laststring, cx+30, cy+60, cx + 30 + dxGetTextWidth(laststring, 0.9, "default"), cy + 60 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				if ( tonumber(skin) < 100 ) then skin = "0" .. skin end
				dxDrawImage(cx - 78, cy, 78, 64, "img/" .. skin .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), false)
			
			elseif ( mainMenuItems[lastItemLeft]["text"] == "Characters" and lastKey == 1 ) then 
				cx = mainMenuItems[charactersID]["cx"]
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(agestring, cx+30, cy+20, cx + 30 + dxGetTextWidth(agestring, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(factionstring, cx+30, cy+40, cx + 30 + dxGetTextWidth(factionstring, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(laststring, cx+30, cy+60, cx + 30 + dxGetTextWidth(laststring, 0.9, "default"), cy + 60 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				if ( tonumber(skin) < 100 ) then skin = "0" .. skin end
				dxDrawImage(cx - 78, cy, 78, 64, "img/" .. skin .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), false)
			elseif ( mainMenuItems[lastItemRight]["text"] == "Characters" and lastKey == 2  ) then
				cx = mainMenuItems[charactersID]["cx"]
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(agestring, cx+30, cy+20, cx + 30 + dxGetTextWidth(agestring, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(factionstring, cx+30, cy+40, cx + 30 + dxGetTextWidth(factionstring, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(laststring, cx+30, cy+60, cx + 30 + dxGetTextWidth(laststring, 0.9, "default"), cy + 60 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				if ( tonumber(skin) < 100 ) then skin = "0" .. skin end
				dxDrawImage(cx - 78, cy, 78, 64, "img/" .. skin .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), false)
			--[[else
				cx = mainMenuItems[charactersID]["cx"]
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * 0.6), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(agestring, cx+30, cy+20, cx + 30 + dxGetTextWidth(agestring, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * 0.6), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(factionstring, cx+30, cy+40, cx + 30 + dxGetTextWidth(factionstring, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * 0.6), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(laststring, cx+30, cy+60, cx + 30 + dxGetTextWidth(laststring, 0.9, "default"), cy + 60 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * 0.6), 0.9, "default", "center", "middle", false, false, false)
				
				if ( tonumber(skin) < 100 ) then skin = "0" .. skin end
				dxDrawImage(cx - 78, cy, 78, 64, "img/" .. skin .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * 0.6), false)
			]]end
		end
	else
		if ( mainMenuItems[currentItem]["text"] == "Characters") then
			dxDrawImage(mainMenuItems[charactersID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * currentItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemLeft]["text"] == "Characters" and lastKey == 1 ) then 
			dxDrawImage(mainMenuItems[charactersID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemRight]["text"] == "Characters" and lastKey == 2  ) then
			dxDrawImage(mainMenuItems[charactersID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		end
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
	tFriends[1] = { }
	tFriends[1]["id"] = getElementData(getLocalPlayer(), "gameaccountid")
	tFriends[1]["username"] = getElementData(getLocalPlayer(), "gameaccountusername")
	tFriends[1]["message"] = friendsmessage
	tFriends[1]["country"] = getElementData(getLocalPlayer(), "country")
	tFriends[1]["online"] = true
	tFriends[1]["character"] = nil
	tFriends[1]["cx"] = initX
	tFriends[1]["cy"] = initY - yoffset + 40
	tFriends[1]["tx"] = initX
	tFriends[1]["ty"] = initY - yoffset + 40
	
	for k,v in pairs(friends) do
		tFriends[k+1] = { }
		
		local id, username, message, country = unpack( v )
		
		tFriends[k+1]["id"] = id
		tFriends[k+1]["username"] = username
		tFriends[k+1]["message"] = message
		tFriends[k+1]["country"] = country
		tFriends[k+1]["online"], tFriends[k]["character"] = isPlayerOnline(id)
		tFriends[k+1]["cx"] = initX
		tFriends[k+1]["cy"] = initY + k*yoffset + 40
		tFriends[k+1]["tx"] = initX
		tFriends[k+1]["ty"] = initY + k*yoffset + 40
	end
	loadedFriends = true
end
addEvent("returnFriends", true)
addEventHandler("returnFriends", getRootElement(), saveFriends)

function updateFriends()
	for i = 1, #tFriends do
		local id = tFriends[i]["id"]
		local online = tFriends[i]["online"]
		
		if ( i ~= 1 ) then
			tFriends[i]["online"], tFriends[i]["character"] = isPlayerOnline(id)
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
	if ( loadedFriends ) then
		for i = 1, #tFriends do
			local id = tFriends[i]["id"]
			local name = tFriends[i]["username"]
			local message = "'" .. tFriends[i]["message"] .. "'"
			local country = string.lower(tFriends[i]["country"])
			local online = tFriends[i]["online"]
			local character = tFriends[i]["character"]
			local cx = tFriends[i]["cx"]
			local cy = tFriends[i]["cy"]
			local tx = tFriends[i]["tx"]
			local ty = tFriends[i]["ty"]
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tFriends[i]["cy"] = tFriends[i]["cy"] - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tFriends[i]["cy"] = tFriends[i]["cy"] + 10
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

			cx = mainMenuItems[socialID]["cx"]
			if ( mainMenuItems[currentItem]["text"] == "Social") then
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(statusText, cx+30, cy+20, cx + 30 + dxGetTextWidth(statusText, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(message, cx+30, cy+40, cx + 30 + dxGetTextWidth(message, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				if (characterText) then
					dxDrawText(characterText, cx+30, cy+60, cx + 30 + dxGetTextWidth(characterText, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				end
				
				dxDrawImage(cx - 16, cy, 16, 11, ":social-system/images/flags/" .. country .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), false)
			elseif ( mainMenuItems[lastItemLeft]["text"] == "Social" and lastKey == 1 ) then 
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(statusText, cx+30, cy+20, cx + 30 + dxGetTextWidth(statusText, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(message, cx+30, cy+40, cx + 30 + dxGetTextWidth(message, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				if (characterText) then
					dxDrawText(characterText, cx+30, cy+60, cx + 30 + dxGetTextWidth(characterText, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				end
				
				dxDrawImage(cx - 16, cy, 16, 11, ":social-system/images/flags/" .. country .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), false)
			elseif ( mainMenuItems[lastItemRight]["text"] == "Social" and lastKey == 2  ) then
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(statusText, cx+30, cy+20, cx + 30 + dxGetTextWidth(statusText, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(message, cx+30, cy+40, cx + 30 + dxGetTextWidth(message, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				if (characterText) then
					dxDrawText(characterText, cx+30, cy+60, cx + 30 + dxGetTextWidth(characterText, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				end
				
				dxDrawImage(cx - 16, cy, 16, 11, ":social-system/images/flags/" .. country .. ".png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), false)
			end
		end
	else
		if ( mainMenuItems[currentItem]["text"] == "Social") then
			dxDrawImage(mainMenuItems[socialID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * currentItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemLeft]["text"] == "Social" and lastKey == 1 ) then 
			dxDrawImage(mainMenuItems[socialID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemRight]["text"] == "Social" and lastKey == 2  ) then
			dxDrawImage(mainMenuItems[socialID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		end
	end
end


----------- ACHIEVEMENTS
function saveAchievements(achievements)
	local resource = getResourceFromName("achievement-system")
	
	for k,v in pairs(achievements) do
		tAchievements[k] = { }
		
		tAchievements[k]["name"], tAchievements[k]["desc"], tAchievements[k]["points"] = unpack( call( getResourceFromName( "achievement-system" ), "getAchievementInfo", v[1] ) )
		tAchievements[k]["date"] = v[2]
		tAchievements[k]["cx"] = initX
		tAchievements[k]["cy"] = initY + k*yoffset + 40
		tAchievements[k]["tx"] = initX
		tAchievements[k]["ty"] = initY + k*yoffset + 40
	end
	loadedAchievements = true
end
addEvent("returnAchievements", true)
addEventHandler("returnAchievements", getRootElement(), saveAchievements)

function drawAchievements()
	if ( loadedAchievements ) then
		for i = 1, #tAchievements do
			local name = tAchievements[i]["name"]
			local desc = tAchievements[i]["desc"]
			local points = "Points: " .. tostring(tAchievements[i]["points"])
			local date = "Unlocked: " .. tostring(tAchievements[i]["date"])
			local cx = tAchievements[i]["cx"]
			local cy = tAchievements[i]["cy"]
			local tx = tAchievements[i]["tx"]
			local ty = tAchievements[i]["ty"]
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tAchievements[i]["cy"] = tAchievements[i]["cy"] - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tAchievements[i]["cy"] = tAchievements[i]["cy"] + 10
			end

			cx = mainMenuItems[achievementsID]["cx"]
			if ( mainMenuItems[currentItem]["text"] == "Achievements") then
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(desc, cx+30, cy+20, cx + 30 + dxGetTextWidth(desc, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(points, cx+30, cy+40, cx + 30 + dxGetTextWidth(points, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(date, cx+30, cy+60, cx + 30 + dxGetTextWidth(date, 0.9, "default"), cy + 60 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				dxDrawImage(cx - 78, cy, 78, 64, ":achievement-system/achievement.png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), false)
			elseif ( mainMenuItems[lastItemLeft]["text"] == "Achievements" and lastKey == 1 ) then 
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(desc, cx+30, cy+20, cx + 30 + dxGetTextWidth(desc, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(points, cx+30, cy+40, cx + 30 + dxGetTextWidth(points, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(date, cx+30, cy+60, cx + 30 + dxGetTextWidth(date, 0.9, "default"), cy + 60 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				dxDrawImage(cx - 78, cy, 78, 64, ":achievement-system/achievement.png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), false)
			elseif ( mainMenuItems[lastItemRight]["text"] == "Achievements" and lastKey == 2  ) then
				dxDrawText(name, cx+20, cy, cx + 30 + dxGetTextWidth(name, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(desc, cx+30, cy+20, cx + 30 + dxGetTextWidth(desc, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(points, cx+30, cy+40, cx + 30 + dxGetTextWidth(points, 0.9, "default"), cy + 40 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				dxDrawText(date, cx+30, cy+60, cx + 30 + dxGetTextWidth(date, 0.9, "default"), cy + 60 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "center", "middle", false, false, false)
				
				dxDrawImage(cx - 78, cy, 78, 64, ":achievement-system/achievement.png", 0, 0, 0, tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), false)
			end
		end
	else
		if ( mainMenuItems[currentItem]["text"] == "Achievements") then
			dxDrawImage(mainMenuItems[achievementsID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * currentItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemLeft]["text"] == "Achievements" and lastKey == 1 ) then 
			dxDrawImage(mainMenuItems[achievementsID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemRight]["text"] == "Achievements" and lastKey == 2  ) then
			dxDrawImage(mainMenuItems[achievementsID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		end
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
		
		tAccount[1]["title"] = "MTA Account"
		tAccount[1]["text"] = tostring(getPlayerUserName())
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
		if ( tostring(tFriends[i]["username"]) == username ) then
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
		if ( tostring(tFriends[i]["username"]) == username ) then
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
	if ( loadedAccount ) then
		for i = 1, #tAccount do
			local title = tAccount[i]["title"]
			local text = tAccount[i]["text"]
			local cx = tAccount[i]["cx"]
			local cy = tAccount[i]["cy"]
			local tx = tAccount[i]["tx"]
			local ty = tAccount[i]["ty"]
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tAccount[i]["cy"] = tAccount[i]["cy"] - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tAccount[i]["cy"] = tAccount[i]["cy"] + 10
			end

			cx = mainMenuItems[accountID]["cx"]
			if ( mainMenuItems[currentItem]["text"] == "Account") then
				dxDrawText(title, cx+20, cy, cx + 30 + dxGetTextWidth(title, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(text, cx+30, cy+20, cx + 30 + dxGetTextWidth(text, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "left", "middle", false, false, false)
			elseif ( mainMenuItems[lastItemLeft]["text"] == "Account" and lastKey == 1 ) then 
				dxDrawText(title, cx+20, cy, cx + 30 + dxGetTextWidth(title, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(text, cx+30, cy+20, cx + 30 + dxGetTextWidth(text, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "left", "middle", false, false, false)
			elseif ( mainMenuItems[lastItemRight]["text"] == "Account" and lastKey == 2  ) then
				dxDrawText(title, cx+20, cy, cx + 30 + dxGetTextWidth(title, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(text, cx+30, cy+20, cx + 30 + dxGetTextWidth(text, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "left", "middle", false, false, false)
			end
		end
	else
		if ( mainMenuItems[currentItem]["text"] == "Account") then
			dxDrawImage(mainMenuItems[accountID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * currentItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemLeft]["text"] == "Account" and lastKey == 1 ) then 
			dxDrawImage(mainMenuItems[accountID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemRight]["text"] == "Account" and lastKey == 2  ) then
			dxDrawImage(mainMenuItems[accountID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		end
	end
end

function drawSettings()
	if ( loadedSettings ) then
		
	else
		if ( mainMenuItems[currentItem]["text"] == "Settings") then
			dxDrawImage(mainMenuItems[settingsID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * currentItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemLeft]["text"] == "Settings" and lastKey == 1 ) then 
			dxDrawImage(mainMenuItems[settingsID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemRight]["text"] == "Settings" and lastKey == 2  ) then
			dxDrawImage(mainMenuItems[settingsID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		end
	end
end

function drawHelp()
	if ( loadedHelp ) then
		for i = 1, #tHelp do
			local title = tHelp[i]["title"]
			local text = tHelp[i]["text"]
			local cx = tHelp[i]["cx"]
			local cy = tHelp[i]["cy"]
			local tx = tHelp[i]["tx"]
			local ty = tHelp[i]["ty"]
			
			local dist = getDistanceBetweenPoints2D(0, initY + yoffset + 40, 0, cy)
			
			local alpha = 255
			if ( cy < (initY + 2*yoffset)) then
				alpha = 255 - ( dist/ 2 )
			else
				alpha = 255 - (dist / 2)
			end
			
			-- ANIMATIONS
			if ( round(cy, -1) > round(ty, -1) ) then -- we need to move down!
				tHelp[i]["cy"] = tHelp[i]["cy"] - 10
			end
			
			if ( round(cy, -1) < round(ty, -1) ) then -- we need to move up!
				tHelp[i]["cy"] = tHelp[i]["cy"] + 10
			end

			cx = mainMenuItems[helpID]["cx"]
			if ( mainMenuItems[currentItem]["text"] == "Help") then
				dxDrawText(title, cx+20, cy, cx + 30 + dxGetTextWidth(title, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(text, cx+30, cy+20, cx + 30 + dxGetTextWidth(text, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * currentItemAlpha), 0.9, "default", "left", "middle", false, false, false)
			elseif ( mainMenuItems[lastItemLeft]["text"] == "Help" and lastKey == 1 ) then 
				dxDrawText(title, cx+20, cy, cx + 30 + dxGetTextWidth(title, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(text, cx+30, cy+20, cx + 30 + dxGetTextWidth(text, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "left", "middle", false, false, false)
			elseif ( mainMenuItems[lastItemRight]["text"] == "Help" and lastKey == 2  ) then
				dxDrawText(title, cx+20, cy, cx + 30 + dxGetTextWidth(title, 1, "default-bold"), cy + dxGetFontHeight(1, "default-bold"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 1, "default-bold", "center", "middle", false, false, false)
				dxDrawText(text, cx+30, cy+20, cx + 30 + dxGetTextWidth(text, 0.9, "default"), cy + 20 + dxGetFontHeight(0.9, "default"), tocolor(255, 255, 255, alpha * xmbAlpha * lastItemAlpha), 0.9, "default", "left", "middle", false, false, false)
			end
		end
	else
		if ( mainMenuItems[currentItem]["text"] == "Help") then
			dxDrawImage(mainMenuItems[helpID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * currentItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemLeft]["text"] == "Help" and lastKey == 1 ) then 
			dxDrawImage(mainMenuItems[helpID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		elseif ( mainMenuItems[lastItemRight]["text"] == "Help" and lastKey == 2  ) then
			dxDrawImage(mainMenuItems[helpID]["cx"] + 35, initY + yoffset + 40, 66, 66, "gui/loading.png", loadingImageRotation, 0, 0, tocolor(255, 255, 255, xmbAlpha * lastItemAlpha * 150), false)
			loadingImageRotation = loadingImageRotation + 5
		end
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
			outputDebugString(tostring(name))
			bindKey(name, "down", manageCamera)
		end
	end
	addCommandHandler("home", toggleXMB)
	bindKey("home", "down", "home")
end
addEvent("loginOK", true)
addEventHandler("loginOK", getRootElement(), createXMBMain)

function saveHelpInformation()
	-- REPORTS
	tHelp[1] = { }
	tHelp[1]["title"] = "My Reports"
	tHelp[1]["text"] = "You currently have no tickets open."
	tHelp[1]["cx"] = initX
	tHelp[1]["cy"] = initY + 1*yoffset + 40
	tHelp[1]["tx"] = initX
	tHelp[1]["ty"] = initY + 1*yoffset + 40
	
	-- REPORTS ABOUT YOU
	tHelp[2] = { }
	tHelp[2]["title"] = "Reports Affecting Me"
	tHelp[2]["text"] = "You currently have no reports regarding yourself."
	tHelp[2]["cx"] = initX
	tHelp[2]["cy"] = initY + 2*yoffset + 40
	tHelp[2]["tx"] = initX
	tHelp[2]["ty"] = initY + 2*yoffset + 40
	
	-- REPORT BUG
	tHelp[3] = { }
	tHelp[3]["title"] = "Report a Bug"
	tHelp[3]["text"] = "Select this to report a bug directly to Mantis."
	tHelp[3]["cx"] = initX
	tHelp[3]["cy"] = initY + 3*yoffset + 40
	tHelp[3]["tx"] = initX
	tHelp[3]["ty"] = initY + 3*yoffset + 40
	
	loadedHelp = true
end

function saveAccountInformation(mtausername)
	-- FORUM ACCOUNT
	tAccount[1] = { }
	tAccount[1]["title"] = "Revert to Pre-Beta"
	tAccount[1]["text"] = "Select this to revert to the Pre-Sapphire GUI."
	tAccount[1]["cx"] = initX
	tAccount[1]["cy"] = initY + yoffset + 40
	tAccount[1]["tx"] = initX
	tAccount[1]["ty"] = initY + yoffset + 40

	-- MTA USERNAME/ACCOUNT
	if ( mtausername ) then
		mtaUsername = mtausername
		
		tAccount[2] = { }
		tAccount[2]["title"] = "MTA Account"
		tAccount[2]["text"] = mtausername
	else
		MTAaccountTimer = setTimer(checkForMTAAccount, 1000, 0)
		tAccount[2] = { }
		tAccount[2]["title"] = "MTA Account"
		tAccount[2]["text"] = "You currently have no account linked.\nLog into one under Settings -> Community to link it."
	end
	tAccount[2]["cx"] = initX
	tAccount[2]["cy"] = initY + 2*yoffset + 40
	tAccount[2]["tx"] = initX
	tAccount[2]["ty"] = initY + 2*yoffset + 40
	
	-- FORUM ACCOUNT
	tAccount[3] = { }
	tAccount[3]["title"] = "Forum Account"
	tAccount[3]["text"] = "You currently have no forum account linked.\nSelect this option to link one."
	tAccount[3]["cx"] = initX
	tAccount[3]["cy"] = initY + 3*yoffset + 40
	tAccount[3]["tx"] = initX
	tAccount[3]["ty"] = initY + 3*yoffset + 40
	
	-- PSN ACCOUNT
	tAccount[4] = { }
	tAccount[4]["title"] = "Playstation Network® Account"
	tAccount[4]["text"] = "You currently have no Playstation Network® account linked.\nSelect this option to link one."
	tAccount[4]["cx"] = initX
	tAccount[4]["cy"] = initY + 4*yoffset + 40
	tAccount[4]["tx"] = initX
	tAccount[4]["ty"] = initY + 4*yoffset + 40
	
	-- XBOX LIVE ACCOUNT
	tAccount[5] = { }
	tAccount[5]["title"] = "Xbox Live® Account"
	tAccount[5]["text"] = "You currently have no Xbox Live® account linked.\nSelect this option to link one."
	tAccount[5]["cx"] = initX
	tAccount[5]["cy"] = initY + 5*yoffset + 40
	tAccount[5]["tx"] = initX
	tAccount[5]["ty"] = initY + 5*yoffset + 40
	
	-- STEAM ACCOUNT
	tAccount[6] = { }
	tAccount[6]["title"] = "Steam® Account"
	tAccount[6]["text"] = "You currently have no Steam® account linked.\nSelect this option to link one."
	tAccount[6]["cx"] = initX
	tAccount[6]["cy"] = initY + 6*yoffset + 40
	tAccount[6]["tx"] = initX
	tAccount[6]["ty"] = initY + 6*yoffset + 40
	
	loadedAccount = true
	saveHelpInformation()
end
addEvent("storeAccountInformation", true)
addEventHandler("storeAccountInformation", getLocalPlayer(), saveAccountInformation)

function saveCharacters(characters)
	-- load the characters
	setCameraMatrix(1401.4228515625, -887.6865234375, 76.401107788086, 1415.453125, -811.09375, 80.234382629395)
	for k, v in ipairs(characters) do	
		characterMenu[k] = { }
		characterMenu[k]["id"] = v[1]
		characterMenu[k]["name"] = string.gsub(v[2], "_", " ")
		characterMenu[k]["cked"] = v[3]
		characterMenu[k]["lastarea"] = v[4]
		characterMenu[k]["age"] = v[5]
		
		if ( v[6] == 1 ) then
			characterMenu[k]["gender"] = v[6]
		else
			characterMenu[k]["gender"] = 0
		end
		
		if ( v[7] ~= nil ) then
			characterMenu[k]["faction"] = v[7]
		else
			characterMenu[k]["faction"] = "Not in a faction."
		end
		characterMenu[k]["rank"] = v[8]
		characterMenu[k]["skin"] = v[9]
		characterMenu[k]["lastseen"] = v[10]
		
		characterMenu[k]["cx"] = initX
		characterMenu[k]["cy"] = initY + k*yoffset + 40
		characterMenu[k]["tx"] = initX
		characterMenu[k]["ty"] = initY + k*yoffset + 40
	end
	loadedCharacters = true
end
addEvent("showCharacterSelection", true)
addEventHandler("showCharacterSelection", getRootElement(), saveCharacters)
end