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

--========================= TUTORIAL SCRIPT ==============================================

-- Concrete Gaming Roleplay Server - Tutorial and Quiz script for un-registerd players - written by Peter Gibbons (aka Jason Moore)

local tutorialStage = {}
	tutorialStage[1] = {1942.0830078125, -1738.974609375, 16.3828125, 1942.0830078125, -1760.5703125, 13.3828125} -- idlewood gas station//
	tutorialStage[2] = {1538.626953125, -1675.9375, 19.546875, 1553.8388671875, -1675.6708984375, 16.1953125} --LSPD//
	tutorialStage[3] = {2317.6123046875, -1664.6640625, 17.215812683105, 2317.4755859375, -1651.1640625, 17.221110343933} -- 10 green bottles//
	tutorialStage[4] = {1742.623046875, -1847.7109375, 16.579560279846, 1742.1884765625, -1861.3564453125, 13.577615737915} -- Unity Station//
	tutorialStage[5] = {1685.3681640625, -2309.9150390625, 16.546875, 1685.583984375, -2329.4443359375, 13.546875} -- Airport//
	tutorialStage[6] = {368.0419921875, -2008.1494140625, 7.671875, 383.765625, -2020.935546875, 10.8359375} -- Pier//
	tutorialStage[7] = {1411.384765625, -870.787109375, 78.552024841309, 1415.9248046875, -810.15234375, 78.552024841309} -- Vinewood sign//
	tutorialStage[8] = {1893.955078125, -1165.79296875, 27.048973083496, 1960.4404296875, -1197.3486328125, 26.849721908569} -- Glen Park//
	tutorialStage[9] = {1813.59375, -1682.1796875, 13.546875, 1834.3828125, -1682.400390625, 14.433801651001} -- Alhambra//
	tutorialStage[10] = {2421.8271484375, -1261.2265625, 25.833599090576, 2432.0537109375, -1246.919921875, 25.874616622925} -- Pig Pen//
	tutorialStage[11] = {2817.37890625, -1865.7998046875, 14.219080924988, 2858.4248046875, -1849.91796875, 14.084205627441} -- East Beach
	
local stageTime = 15000
local fadeTime = 2000
local fadeDelay = 300

local tutorialTitles = {}
	tutorialTitles[1] = "WELCOME"
	tutorialTitles[2] = "YOUR NAME"
	tutorialTitles[3] = "ROLEPLAYING"
	tutorialTitles[4] = "IC AND OOC"
	tutorialTitles[5] = "ROLEPLAY RULES"
	tutorialTitles[6] = "EXPLOITING"
	tutorialTitles[7] = "LANGUAGE"
	tutorialTitles[8] = "SERVER RULES"
	tutorialTitles[9] = "STARTING OUT"
	tutorialTitles[10] = "ADMINS"
	tutorialTitles[11] = "MORE INFORMATION"
	

local tutorialText = {}
		tutorialText[1] = {"Hello and welcome to Valhalla Gaming: MTA Roleplay Server.",
					"I see you're new here, so please give us 2 minutes to introduce you the server.",
					"Currently we are the only fully roleplay structured server on MTA, with a constantly",
					"updating script. You can visit the website at http://valhallagaming.net for more info."}
	
	tutorialText[2] = 		{"Roleplay (RP) is a game genre where the players assume the role of a fictional",
					"character. In our server, your name is your identity, and must be in the format ",
					"Firstname_Lastname. It can be anything you want, as long as it's realistic and",
					"not a celebrity name. An example of a valid name is: 'Niko_Harrison'. "}
	
	tutorialText[3] = 		{"You're expected to roleplay at all times. That means acting as you would in",
					"real life. Just because it's possible in GTA, doesn't mean it's ok to do it here.",
					"Even though we have server factions, you can roleplay anything you want,",
					"providing that it follows the server rules."}
	
	tutorialText[4] = 		{"In Character (IC) and Out of Character (OOC) is fundamental to good roleplaying",
					"OOC refers to you, the player, talking about non relevant, off topic things.",
					"To talk OOC to each other, use /o, /b and /pm. IC refers your characters words",
					"being spoken to other characters - try not to confuse the two."}
	
	tutorialText[5] = 		{"There are a number of roleplay terms that you will need to understand, like 'Metagaming' (using",
					"OOC information in a IC situation), or 'Powergaming' (forcing your roleplay on other people.)",
					"For more information about these terms, press F1 in game and all the information you need",
					"to know will be there. We don't like people metagaming or powergaming, so please don't do it!"}
	
	tutorialText[6] = 		{"Gaining an unfair advantage over other players, by using cheats or abusing",
					"bugs won't be tolerated in any way, and will result in a instant ban, so watch",
					"out! ;)  If you see any exploits in the script, please report it to the admins ",
					"straight away or externally onto our forums." }
				      
	tutorialText[7] = 		{"We encourage people from all over the world to play here, but ask that",
					"you all stick to one language - English - so everyone knows whats going on,",
					"even in OOC. If you want to talk in your native language to someone, please",
					"do it over private messages. (/pm)"}
	
	tutorialText[8] = 		{"Our set of server rules are probably very different compared to other MTA servers.",
					"There is a full list available on the website, but some of the most common are:",
					"No deathmatching, advertising other servers and cheating or hacking (obviously...)",
					"No spamming the chat or commands please, and don't use full capitals, thanks!"}

	tutorialText[9] =		 {"So you've just arrived in Los Santos, what do you do? There are plenty",
					"of factions for you to become members of - just roleplay with other players",
					"and you'll soon find yourself rising up the faction ranks. Some factions, like ",
					"the LSPD require you to fill out applications on the forums before you can join."}
	
	tutorialText[10] = 	{"Our admins are here to help you should you need it. If you need help, have a quick question",
					"or wish to report someone for breaking the rules, don't be afraid to use /report  and someone ",
					"will come and help as soon as they can. For larger questions, and account issues, it might be",
					"easier to ask on our forums at http://www.valhallagaming.net/forums/"}
				   
	tutorialText[11] = 	{"For more information on the server, as already mentioned, press F1 during gameplay.",
					"A list of player commands can be found by doing /helpcmds, so please read through and",
					"familarise yourself with them. Alternatively ask one of the admins or players in game.",
					"This marks the end of the tutorial. Thank you for playing. "}
					
					

-- function starts the tutorial
function showTutorial()

	local thePlayer = getLocalPlayer()

	-- set the player to not logged in so they don't see any other random chat
	triggerServerEvent("player:loggedout", getLocalPlayer())
		
	-- if the player hasn't got an element data, set it to 1
	if not (getElementData(thePlayer, "tutorialStage")) then
		setElementData(thePlayer, "tutorialStage", 0, false)
	end
	
	-- ionc
	setElementData(thePlayer, "tutorialStage", getElementData(thePlayer, "tutorialStage")+1, false)

	
	-- stop the player from using any controls to move around or chat
	toggleAllControls (  false )
	-- fade the camera to black so they don't see the teleporting renders
	fadeCamera ( false, fadeTime/1000 ,0,0,0)
	
	-- timer to move the camera to the first location as soon as the screen has gone black.
	setTimer(function()
		
		-- timer to set camera position and fade in after the camera has faded out to black
		setTimer(function()
				
			local stage = getElementData(thePlayer, "tutorialStage")
			
			local camX = tutorialStage[stage][1]
			local camY = tutorialStage[stage][2]
			local camZ = tutorialStage[stage][3]
			local lookX = tutorialStage[stage][4]
			local lookY = tutorialStage[stage][5]
			local lookZ = tutorialStage[stage][6]
			
			setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
			
			-- set the element to outside and dimension 0 so they see th eother players
			setElementInterior(thePlayer, 0)
			setElementDimension(thePlayer, 0)
			
			-- fade the camera in
			fadeCamera( true, fadeTime/1000)
			
			-- call function to output the text
			outputTutorialText(stage)
			
			-- function to fade out after message has been displayed a read
			setTimer(function()
								
				local lastStage = getLastStage()
				
				-- if the player is on the last stage of the tutorial, fade their camera out and...
				if(stage == lastStage) then
					fadeCamera( false, fadeTime/1000, 0,0,0)
						
					setTimer(function()

						-- show the quiz after a certain time
						endTutorial()
						
						setElementData ( thePlayer, "tutorialStage", 0, false )
						
					end, fadeTime+fadeDelay,1 )
				else -- else more stages to go, show the next stage
					showTutorial(thePlayer)
				end
			end, stageTime, 1)
		end, 150, 1)
	end, fadeTime+fadeDelay , 1)
end
addEvent("onShowTutorial", true)
addEventHandler("onShowTutorial", getLocalPlayer(), showTutorial)



-- function returns the number of stages
function getLastStage()

	local lastStage = 0
	
	if(tutorialStage) then
		for i, j in pairs(tutorialStage) do
			lastStage = lastStage + 1
		end
	end
	
	return lastStage
end


-- function outputs the text during the tutorial
function outputTutorialText( stage)
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(tutorialTitles[stage],  255, 0,0, true)
	outputChatBox(" ")
	
	if(tutorialText[stage]) then
		for i, j in pairs(tutorialText[stage]) do
				outputChatBox(j)
		end
	end

end

-- function fade in the camera and sets the player to the quiz room so they can do the quiz
function endTutorial()

	local thePlayer = getLocalPlayer()
	
	-- set the player to not logged in so they don't see the chat
	triggerServerEvent("player:loggedout", getLocalPlayer())
	toggleAllControls(false)
			
	
	setTimer(function()
		setCameraMatrix(368.0419921875, -2008.1494140625, 7.671875, 383.765625, -2020.935546875, 10.8359375)
		
		-- fade the players camera in
		fadeCamera(true, 2)
		
		-- trigger the client to start showing the quiz
		setTimer(function()
			triggerEvent("onClientStartQuiz", thePlayer)
			
		end, 2000, 1)
		
		
	end, 100, 1)

end




   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS, AKA JASON MOORE --------------
   
   
   
   questions = { }
questions[1] = {"What does the term RP stand for?", "Real Playing", "Role Playing", "Record Playing", "Route Playing", 2}
questions[2] = {"When are you allowed to advertise other servers?", "Using /ad", "In out of character chat", "Via PM's (/w)", "Never", 4}
questions[3] = {"What should you do if you see someone hacking?", "Tell an admin using /report", "Ignore it", "/w the hacker and tell them to stop", "Report the hacker in OOC", 1}
questions[4] = {"What is the address of the website and forums?", "www.valhalla.com", "www.valhallagaming.co.uk", "www.valhallagaming.net", "www.vg.com", 3} 
questions[5] = {"I want to get to the other side of Los Santos, how should I do it?", "Ask an admin to teleport you.", "Find a roleplay way to get there, like a taxi.", "Start bunnyhopping to get there faster", "Jump in a random players car and demand them to take you.", 2}
questions[6] = {"What is the correct format for your in game name?", "Firstname", "firstname_lastname", "Firstname_Lastname", "There is no format", 3}
questions[7] = {"Which one of the following names would be acceptable", "David_Beckham", "Niko_Harrison", "Roleplayer_150", "They are all acceptable", 2}
questions[8] = {"When must you roleplay in this server?", "At all times", "Never", "When you feel like it", "Only when other people are", 1}
questions[9] = {"What should you do if you accidently drive your car off a cliff?", "Carry on driving because the car didn't blow up", "Ask an admin to move you to the top of the cliff", "Say it was an OOC accident", "Stop and roleplay a car accident", 4}
questions[10] = {"I want to join a particular gang or mafia, how should I do it?", "Ask an admin to move you into the faction", "Ask in OOC to join the faction", "Roleplay with the gang/mafia until they invite you.", "nil", 3}
questions[11] = {"What does OOC stand for?", "Out of Control", "Out of Character", "Out of Chance", "Out of Coffee", 2}
questions[12] = {"What does IC stand for?", "In Character", "In Chaos", "In Car", "nil", 1}
questions[13] = {"What is Metagaming?", "Killing someone for no reason", "Doing something that is unrealistic in real life", "Forcing your roleplay on other players", "Using Out of Character knowledge in In Character situations", 4}
questions[14] = {"What language should you use in this server?", "French", "English", "Hewbrew", "Anything", 2}
questions[15] = {"When can you talk to another player in your native language?", "In Character chat", "In any Out of Character chat", "Through private messages only.", "Never", 3}
questions[16] = {"Which ones of these is a server rule?", "No Roleplaying", "No Deathmatching", "No Driving", "No Shooting", 2}
questions[17] = {"What would you do if you wanted to contact an admin?", "Use the admin /report system", "Ask in global OOC for an admin", "Private message the admin", "Ask In Character for an admin.", 1}

-- variable for the max number of possible questions
local NoQuestions = 17
local NoQuestionToAnswer = 10
local correctAnswers = 0
local passPercent = 90
		
selection = {}


-- functon makes the intro window for the quiz
function createQuizIntroWindow()

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Roleplay Quiz" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, "	You will now proceed with a short roleplay quiz. This quiz isn't\
										 hard and is only to check that you've followed the tutorial. All \
										of the answers are hidden in the tutorial, and you don't need to \
										get every question correct.\
										\
										Good luck!", true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center")
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Start Quiz" , true ,guiIntroWindow)
	
	guiSetVisible(guiIntroWindow, true)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startQuiz()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)

end


-- function create the question window
function createQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Question "..number.." of "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.1, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.3, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	if not(selection[number][5] == "nil") then
		guiQuestionAnswer4Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][5], true,guiQuestionWindow)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Next Question" , true ,guiQuestionWindow)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Submit Answers" , true ,guiQuestionWindow)
		
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createFinishQuizWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createFinishQuizWindow()

	local score = (correctAnswers/NoQuestionToAnswer)*100

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "End of Quiz", false )
	
	if(score >= passPercent) then
	
		local xmlRoot = xmlCreateFile("vgrptut.xml", "passedtutorial")
		xmlSaveFile(xmlRoot)
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Congratulations! You have passed!", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..score.."%, and the pass mark is "..passPercent.."%. Well done!\
											Please remember to register at the forums (www.valhallagaming.net)\
											if you have not done so.\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center")
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continue" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				toggleAllControls ( true )
				
				createMainUI(getThisResource())
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Sorry, you have not passed this time.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..math.ceil(score).."%, and the pass mark is "..passPercent.."%.\
											You can retake the quiz as many times as you like, so have another shot!\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center")
		
		guiFinalRetakeButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Take Quiz Again" , true ,guiFinishWindow)
		guiFinalTutorialButton = guiCreateButton ( 0.55 , 0.8 , 0.25, 0.1 , "Show Tutorial" , true ,guiFinishWindow)
		
		-- if player click the retake button
		addEventHandler ( "onClientGUIClick", guiFinalRetakeButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				startShowQuizIntro()
			end
		end, false)
		
		-- if player click the show tutorial
		addEventHandler ( "onClientGUIClick", guiFinalTutorialButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers and hide the window
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				guiSetInputEnabled(false)
				
				-- trigger server event to show the tutorial
				showTutorial()
			end
		end, false)
	
	
	
	end

end


-- function is triggerd by the server when it is time for the player to take the quiz
function startShowQuizIntro()
	
	clearChatBox()
	-- reset the players correct answers to 0
	correctAnswers = 0
	-- create the intro window
	createQuizIntroWindow()
	-- Set input enabled
	guiSetInputEnabled(true)

end
 addEvent("onClientStartQuiz", true)
 addEventHandler( "onClientStartQuiz", getLocalPlayer() ,  startShowQuizIntro)
 
 
 -- function starts the quiz
 function startQuiz()
 
	-- choose a random set of questions
	chooseQuizQuestions()
	-- create the question window with question number 1
	createQuestionWindow(1)
 
 end
 
 
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseQuizQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(questionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (questionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function questionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questions[number][1]) then
			same = 1 -- set same to 1
		end
		
	end
	
	-- if same is 1, question already selected to return true
	if(same == 1) then
		return true
	else
		return false
	end
  
 end
 










---------------------- [ ACCOUNT SCRIPT ] ----------------------
lLostSecurityKey, tLostSecurityKey, bForgot, chkRemember, chkAutoLogin, bLogin, lLogUsername, lLogUsernameNote, tLogUsername, tLogPassword, lLogPassword, tabPanelMain, tabLogin, tabRegister, tabForgot, lRegUsername, tRegUsername, lRegUsernameNote, lRegPassword, tRegPassword, lRegPassword2, tRegPassword2, bRegister, wDelConfirmation = nil
-- increasing this will reshow the tos as updated
tosversion = 100

toswindow, tos, bAccept, bDecline = nil
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
	end
end

function acceptTOS(button, state)
	local theFile = xmlCreateFile("vgrptos.xml", "tosversion")
	if (theFile) then
		local node = xmlCreateChild(theFile, "tosversion")
		xmlNodeSetValue(node, tostring(tosversion))
		xmlSaveFile(theFile)
	end
	destroyElement(toswindow)
	toswindow = nil
end

function declineTOS(button, state)
	triggerServerEvent("declineTOS", getLocalPlayer())
end


function renderWelcomeMessage()
	local screenWidth, screenHeight = guiGetScreenSize()
	dxDrawText("Welcome to Valhalla Gaming", 36, screenHeight-61, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "pricedown")
    dxDrawText("Welcome to Valhalla Gaming", 34, screenHeight-63, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	
	local version = exports.global:getScriptVersion()
	
	dxDrawText("Version " .. version, screenWidth-170, screenHeight-61, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "pricedown")
    dxDrawText("Version " .. version, screenWidth-168, screenHeight-63, screenWidth, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	
	dxDrawLine(0, screenHeight-30, screenWidth, screenHeight-30, tocolor(255, 255, 255, 150), 2)
end

function cleanupScenarioOne()
	if (scen1Timer) then
		killTimer(scen1Timer)
		scen1Timer = nil
	end
	
	if (scen1Timer2) then
		killTimer(scen1Timer2)
		scen1Timer2 = nil
	end

	if (scen1Car1) then
		destroyElement(scen1Car1)
		scen1Car1 = nil
	end
	
	if (scen1Car2) then
		destroyElement(scen1Car2)
		scen1Car2 = nil
	end
	
	if (scen1Car3) then
		destroyElement(scen1Car3)
		scen1Car3 = nil
	end
	
	if (scen1Car4) then
		destroyElement(scen1Car4)
		scen1Car4 = nil
	end
	
	if (scen1Car5) then
		destroyElement(scen1Car5)
		scen1Car5 = nil
	end
	
	if (scen1Car6) then
		destroyElement(scen1Car6)
		scen1Car6 = nil
	end
	
	if (scen1Officer) then
		destroyElement(scen1Officer)
		scen1Officer = nil
	end
end

scenario = -1
scen1Car1, scen1Car2, scen1Car3, scen1Car4, scen1Car5, scen1Car6, scen1Officer, scen1Timer, scen1Timer2 = nil
function loadScenarioOne()
	scenario = 1
	local id = getElementData(getLocalPlayer(), "playerid")
	
	if not (id) then
		id = 0
	end
	
	--[[
	setElementDimension(getLocalPlayer(), 65400+id)
	setElementAlpha(getLocalPlayer(), 255)
	setElementPosition(getLocalPlayer(), 1944.0075683594, -1750.8298339844, 14.382812)
	setElementInterior(getLocalPlayer(), 0)
	setCameraInterior(0)

	-- Car
	scen1Car1 = createVehicle(542, 2074.8247070313, 1012.0288085938, 10.671875, 0, 0, 1.2417)
	setElementDimension(scen1Car1, 65400+id)
	setVehicleEngineState(scen1Car1, true)
	setVehicleOverrideLights(scen1Car1, 2)
	
	-- Car 2
	scen1Car2 = createVehicle(598, 2074.8215332031, 1005.6492919922, 10.671875, 0, 0, 1.2417)
	setElementDimension(scen1Car2, 65400+id)
	setVehicleEngineState(scen1Car2, true)
	setVehicleSirensOn(scen1Car2, true)
	setVehicleOverrideLights(scen1Car2, 2)
	
	-- Car 3
	scen1Car3 = createVehicle(598, 2074.8215332031, 1018.6492919922, 10.671875, 0, 0, 1.2417)
	setElementDimension(scen1Car3, 65400+id)
	setVehicleEngineState(scen1Car3, true)
	setVehicleSirensOn(scen1Car3, true)
	setVehicleOverrideLights(scen1Car3, 2)
	
	-- CHASE
	-- Car
	scen1Car4 = createVehicle(542, 2066.4184570313, 883.01971435547, 7.1771411895752, 0, 0, 360)
	setElementDimension(scen1Car4, 65400+id)
	setVehicleEngineState(scen1Car4, true)
	setVehicleOverrideLights(scen1Car4, 2)
	
	-- Car
	scen1Car5 = createVehicle(598, 2069.53515625, 868.87261962891, 6.8626842498779, 0, 0, 360)
	setElementDimension(scen1Car5, 65400+id)
	setVehicleEngineState(scen1Car5, true)
	setVehicleOverrideLights(scen1Car5, 2)
	setVehicleSirensOn(scen1Car5, true)
	
	-- Car
	scen1Car6 = createVehicle(598, 2063.2297363281, 866.16375732422, 6.8054342269897, 0, 0, 360)
	setElementDimension(scen1Car6, 65400+id)
	setVehicleEngineState(scen1Car6, true)
	setVehicleOverrideLights(scen1Car6, 2)
	setVehicleSirensOn(scen1Car6, true)
	
	scen1Timer = setTimer(updateScenario1, 50, 300)
	scen1Timer2 = setTimer(resetScenario1, 16000, 1)
	
	-- OFFICER
	scen1Officer1 = createPed(282, 2072.5834960938, 1011.3972167969, 10.67187)
	setPedRotation(scen1Officer1, 274.4475)
	setElementDimension(scen1Officer1, 65400+id)

	]]--
	-- CAMERA
	setCameraInterior(0)
	setCameraMatrix(183.5517578125, -2022.1845703125, 44.808246612549, 365.8310546875, -2031.2275390625, 30.186800003052)
end

function updateScenario1()
	--local x1, y1, z1 = getElementPosition(scen1Car4)
	--setElementPosition(scen1Car4, x1, y1+2.5, z1)
	
	--local x2, y2, z2 = getElementPosition(scen1Car5)
	--setElementPosition(scen1Car5, x2, y2+2.5, z2)
	
	--local x3, y3, z3 = getElementPosition(scen1Car6)
	--setElementPosition(scen1Car6, x3, y3+2.5, z3)
end

function resetScenario1()
	killTimer(scen1Timer)
	killTimer(scen1Timer2)
	
	local id = getElementData(getLocalPlayer(), "playerid")
	
	if not (id) then
		id = 0
	end
	
	destroyElement(scen1Car4)
	scen1Car4 = nil
	
	destroyElement(scen1Car5)
	scen1Car5 = nil
	
	destroyElement(scen1Car6)
	scen1Car6 = nil

	-- CHASE
	-- Car
	scen1Car4 = createVehicle(542, 2066.4184570313, 883.01971435547, 7.1771411895752, 0, 0, 360)
	setElementDimension(scen1Car4, 65400+id)
	setVehicleEngineState(scen1Car4, true)
	setVehicleOverrideLights(scen1Car4, 2)
	
	-- Car
	scen1Car5 = createVehicle(598, 2069.53515625, 868.87261962891, 6.8626842498779, 0, 0, 360)
	setElementDimension(scen1Car5, 65400+id)
	setVehicleEngineState(scen1Car5, true)
	setVehicleOverrideLights(scen1Car5, 2)
	setVehicleSirensOn(scen1Car5, true)
	
	-- Car
	scen1Car6 = createVehicle(598, 2063.2297363281, 866.16375732422, 6.8054342269897, 0, 0, 360)
	setElementDimension(scen1Car6, 65400+id)
	setVehicleEngineState(scen1Car6, true)
	setVehicleOverrideLights(scen1Car6, 2)
	setVehicleSirensOn(scen1Car6, true)
	
	scen1Timer = setTimer(updateScenario1, 50, 300)
	scen1Timer2 = setTimer(resetScenario1, 15000, 1)
end

triggerServerEvent("getSalt", getLocalPlayer(), scripter)

function generateTimestamp(daysAhead)
	return tostring( 50000000 + getRealTime().year * 366 + getRealTime().yearday + daysAhead )
end

function validateDetails()
	if (source==bRegister) then
		local username = guiGetText(tRegUsername)
		local password1 = guiGetText(tRegPassword)
		local password2 = guiGetText(tRegPassword2)
		
		local password = password1 .. password2
		
		clearChatBox()
		if (string.len(username)<3) then
			outputChatBox("Your username is too short. You must enter 3 or more characters.", 255, 0, 0)
		elseif (string.find(username, ";", 0)) or (string.find(username, "'", 0)) or (string.find(username, "@", 0)) or (string.find(username, ",", 0)) then
			outputChatBox("Your name cannot contain ;,@'.", 255, 0, 0)
		elseif (string.len(password1)<6) then
			outputChatBox("Your password is too short. You must enter 6 or more characters.", 255, 0, 0)
		elseif (string.len(password1)>=30) then
			outputChatBox("Your password is too long. You must enter less than 30 characters.", 255, 0, 0)
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("Your password cannot contain ;,@'.", 255, 0, 0)
		elseif (password1~=password2) then
			outputChatBox("The passwords you entered do not match.", 255, 0, 0)
		else
			showChat(true)
			triggerServerEvent("attemptRegister", getLocalPlayer(), username, password1) 
		end
	elseif (source==bLogin) then
		local username = guiGetText(tLogUsername)
		local password = guiGetText(tLogPassword)
		
		clearChatBox()
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
			triggerServerEvent("attemptLogin", getLocalPlayer(), username, password, operatingsystem) 
			
			local saveInfo = guiCheckBoxGetSelected(chkRemember)
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
end

function storeSalt(theSalt, theIP)
	ip = theIP
	salt = theSalt
	
	if (not hasBeta()) then
		createMainUI(getThisResource())
	else
		createXMB()
	end
end
addEvent("sendSalt", true)
addEventHandler("sendSalt", getRootElement(), storeSalt)

function createMainUI(res, isChangeAccount)

	if (res==getThisResource()) then
		sent = false
		local tutFile = xmlLoadFile("vgrptut.xml")
		local regFile = xmlLoadFile("vgrpreg.xml")
		
		if (tutFile) or (regFile) then
			-- Set the camera to a nice view
			local cameraRand = math.random(1, 1)
			
			
			if (cameraRand==1) then
				loadScenarioOne()
				addEventHandler("onClientRender", getRootElement(), renderWelcomeMessage)
			end
			fadeCamera(true)
			
			if (bChangeAccount) then
				destroyElement(bChangeAccount)
				bChangeAccount = nil
			end
			
			checkTOS() -- Terms of Service
			
			local width, height = 400, 200
			
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)

			if (scrWidth<1024) and (scrHeight<768) then
				outputChatBox("WARNING: You are running on a low resolution. We recommend atleast 1024x768.", 255, 0, 0)
			end
			
			--[[
			local version = tonumber(string.sub(getVersion().type, 10, string.len(getVersion().type)))
			if (getVersion().type~="Custom" and getVersion().type~="Release") and sversion then
				if (version~=nil) then
					if (version<sversion) then
						clearChatBox()
						showChat(true)
						outputChatBox("You are using an older nightly. You require r" .. sversion .. ".")
						outputChatBox("You can obtain this at http://nightly.mtasa.com")
						return
					end
				end
			end
			]]--
				
			tabPanelMain = guiCreateTabPanel(x, y, width, height, false)
			
			if (regFile) then -- User has already registered on this PC before.
				tabLogin = guiCreateTab("Login to Account", tabPanelMain)
				tabRegister = guiCreateTab("Register Account", tabPanelMain)
				tabForgot = guiCreateTab("Forgot Details", tabPanelMain)
			else
				tabRegister = guiCreateTab("Register Account", tabPanelMain)
				tabLogin = guiCreateTab("Login to Account", tabPanelMain)
				tabForgot = guiCreateTab("Forgot Details", tabPanelMain)
			end
			
			guiSetAlpha(tabPanelMain, 0)
			
			lRegUsername = guiCreateLabel(0.025, 0.15, 0.95, 0.95, "To join this server you must submit an application at: \n\n\nwww.ValhallaGaming.net/mtaucp.\n\n\n We aim to respond to all applications within a few hours. \n\n This helps us pick out undesirable players such as Deathmatchers.", true, tabRegister)
			--lRegUsernameNote = guiCreateLabel(0.225, 0.25, 0.8, 0.2, "NOTE: This is NOT your character's name.", true, tabRegister)
			guiLabelSetHorizontalAlign(lRegUsername, "center")
			guiSetFont(lRegUsername, "default-bold-small")
			
			--lRegUsername = guiCreateLabel(0.2, 0.15, 0.3, 0.1, "Account Name:", true, tabRegister)
			--lRegUsernameNote = guiCreateLabel(0.225, 0.25, 0.8, 0.2, "NOTE: This is NOT your character's name.", true, tabRegister)
			--guiSetFont(lRegUsernameNote, "default-bold-small")
			
			--tRegUsername = guiCreateEdit(0.425, 0.15, 0.3, 0.1, "Memorable Name", true, tabRegister)
			--guiEditSetMaxLength(tRegUsername, 16)
			
			--lRegPassword = guiCreateLabel(0.15, 0.45, 0.3, 0.1, "Account Password:", true, tabRegister)
			--tRegPassword = guiCreateEdit(0.425, 0.45, 0.3, 0.1, "password", true, tabRegister)
			--guiEditSetMasked(tRegPassword, true)
			--guiEditSetMaxLength(tRegPassword, 29)
			
			--lRegPassword2 = guiCreateLabel(0.165, 0.575, 0.3, 0.1, "Confirm Password:", true, tabRegister)
			--tRegPassword2 = guiCreateEdit(0.425, 0.575, 0.3, 0.1, "password", true, tabRegister)
			--guiEditSetMasked(tRegPassword2, true)
			--guiEditSetMaxLength(tRegPassword2, 29)
			
			--bRegister = guiCreateButton(0.25, 0.75, 0.5, 0.2, "Register", true, tabRegister)
			--addEventHandler("onClientGUIClick", bRegister, validateDetails, false)
			
			-- LOGIN
			lLogUsername = guiCreateLabel(0.2, 0.2, 0.3, 0.1, "Account Name:", true, tabLogin)
			lLogUsernameNote = guiCreateLabel(0.225, 0.3, 0.8, 0.2, "NOTE: This is NOT your character's name.", true, tabLogin)
			guiSetFont(lLogUsernameNote, "default-bold-small")
			
			
			tLogUsername = guiCreateEdit(0.425, 0.2, 0.3, 0.1, "", true, tabLogin)
			guiEditSetMaxLength(tLogUsername, 32)
			
			lLogPassword = guiCreateLabel(0.15, 0.45, 0.3, 0.1, "Account Password:", true, tabLogin)
			tLogPassword = guiCreateEdit(0.425, 0.45, 0.3, 0.1, "", true, tabLogin)
			guiEditSetMasked(tLogPassword, true)
			guiEditSetMaxLength(tLogPassword, 32)
			
			chkRemember = guiCreateCheckBox(0.35, 0.52, 0.5, 0.15, "Remember my Details", false, true, tabLogin)
			chkAutoLogin = guiCreateCheckBox(0.35, 0.62, 0.5, 0.15, "Automatic Login", false, true, tabLogin)
			
			addEventHandler("onClientGUIClick", chkRemember, updateLoginState)
			
			bLogin = guiCreateButton(0.25, 0.75, 0.5, 0.2, "Login", true, tabLogin)
			addEventHandler("onClientGUIClick", bLogin, validateDetails, false)
			
			-- FORGOTTEN DETAILS
			lLostSecurityKey = guiCreateLabel(0.025, 0.15, 0.95, 0.95, "To retrieve your username and password please visit the UCP: \n\n\nwww.ValhallaGaming.net/mtaucp.", true, tabForgot)
			guiLabelSetHorizontalAlign(lLostSecurityKey, "center")
			guiSetFont(lLostSecurityKey, "default-bold-small")
			
			--tLostSecurityKey = guiCreateEdit(0.37, 0.4, 0.5, 0.1, "", true, tabForgot)
			--guiEditSetMaxLength(tLostSecurityKey, 30)
			
			--bForgot = guiCreateButton(0.25, 0.75, 0.5, 0.2, "Retrieve Details", true, tabForgot)
			--addEventHandler("onClientGUIClick", bForgot, retrieveDetails, false)
			
			-- LOAD SAVED USER INFO 
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
						outputChatBox("The login file stored on this computer has been modified externally.", 255, 0, 0)
						guiCheckBoxSetSelected(chkAutoLogin, false)
						showChat(true)
					elseif ( ipHash ~= hashedIP ) then
						outputChatBox("The login file on this computer does not belong to this computer.", 255, 0, 0)
						guiCheckBoxSetSelected(chkAutoLogin, false)
						showChat(true)
					elseif ( currTimestamp >= timestamp ) then
						outputChatBox("The login file stored on this computer has expired.", 255, 0, 0)
						guiCheckBoxSetSelected(chkAutoLogin, false)
						showChat(true)
					else
						if (uname) and (uname~="") then
							guiSetText(tLogUsername, tostring(uname))
							guiCheckBoxSetSelected(chkRemember, true)
						end
						
						if (passwordNode) then
							local pword = xmlNodeGetValue(passwordNode)
							if (pword) and (pword~="") then
								guiSetText(tLogPassword, tostring(pword))
								guiCheckBoxSetSelected(chkRemember, true)
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
										triggerServerEvent("attemptLogin", getLocalPlayer(), guiGetText(tLogUsername), guiGetText(tLogPassword)) 
									end
								end
							end
						else
							guiCheckBoxSetSelected(chkAutoLogin, false)
						end
					end
				end
			end
			
			if (toswindow) then
				guiBringToFront(toswindow)
			end
			setTimer(fadeWindow, 50, 20)
		else
			showChat(true)
			showTutorial()
		end
	end
end
--addEventHandler("onClientResourceStart", getRootElement(), createMainUI)

function retrieveDetails()
	if (source==bForgot) then
		local securityKey = guiGetText(tLostSecurityKey)
		
		clearChatBox()
		if (string.len(securityKey)<5) then
			outputChatBox("Your email must be 5 characters long.", 255, 0, 0)
		elseif (not string.find(securityKey, "@", 0))  then
			outputChatBox("Your email must contain an @ symbol.", 255, 0, 0)
		else
			guiSetText(tLostSecurityKey, "")
			showChat(true)
			triggerServerEvent("retrieveDetails", getLocalPlayer(), securityKey)
		end
	end
end

function updateLoginState()
	if (guiCheckBoxGetSelected(chkRemember)) then
		guiSetEnabled(chkAutoLogin, true)
	else
		guiSetEnabled(chkAutoLogin, false)
		guiCheckBoxSetSelected(chkAutoLogin, false)
	end
end

function fadeWindow()
	if (tabPanelMain) then
		local alpha = guiGetAlpha(tabPanelMain)
		local newalpha = alpha + 0.1
		guiSetAlpha(tabPanelMain, newalpha)
		
		if(newalpha>=0.7) then
			guiSetAlpha(tabPanelMain, 0.75)
			showCursor(true)
			guiSetInputEnabled(true)
		end
	end
end

function hideUI(regged)
	local xmlRoot = xmlCreateFile("vgrpreg.xml", "registered")
	if (xmlRoot) then
		xmlSaveFile(xmlRoot)
	end

	showCursor(false)
	guiSetInputEnabled(false)
	
	cleanupScenarioOne()
	cleanupEmail()
	
	if (tabPanelMain) then
		destroyElement(tabPanelMain)
		tabPanelMain = nil
	end
	
	if (tabPanelCharacter) then
		destroyElement(tabPanelCharacter)
		tabPanelCharacter = nil
	end
	
	removeEventHandler("onClientRender", getRootElement(), renderWelcomeMessage)
	
	if (regged) then
		createMainUI(getThisResource())
	end
	
	if (bChangeAccount) then
		destroyElement(bChangeAccount)
		bChangeAccount = nil
	end
	
	if wDelConfirmation then
		destroyElement(wDelConfirmation)
		wDelConfirmation = nil
	end
end
addEvent("hideUI", true)
addEventHandler("hideUI", getRootElement(), hideUI)

tabPanelCharacter, tabCharacter, tabAccount, tabAchievements, tabStatistics, tableAccounts, lCharacters, paneCharacters, lCreateFakepane, lCreateBG, lCreateName, lCreateImage = nil
paneChars = { }
tableAchievements, tableStatistics, iAchievementCount, iAchievementPointsCount = nil
bEditChar = nil
bDeleteChar = nil
bChangeAccount = nil

sent = false
function changedTab(tab)
	if (tab==tabAchievements) and not (sent) then
		sent = true
		lLoading = guiCreateLabel(0.45, 0.4, 0.3, 0.3, "Loading...", true, tabAchievements)
		guiSetFont(lLoading, "default-bold-small")
		triggerServerEvent("requestAchievements", getLocalPlayer())
	end
end

function showCharacterUI(accounts, firstTime, needsEmail)
	sent = false
	if (bChangeChar) then
		destroyElement(bChangeChar)
		bChangeChar = nil
	end
	
	-- Change Account button
	bChangeAccount = guiCreateButton(0.835, 0.925, 0.15, 0.05, "Change Account", true)
	guiSetAlpha(bChangeAccount, 0.75)
	addEventHandler("onClientGUIClick", bChangeAccount, changeAccount)
	
	--triggerEvent("hideHud", getLocalPlayer())
	if not (firstTime) then
		showChat(false)
	end
	setElementAlpha(getLocalPlayer(), 255)
	
	setCameraInterior(14)
	setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375)
	fadeCamera(true)
	
	tableAccounts = accounts
	--iAchievementCount = achievementCount
	--iAchievementPointsCount = achievementPointsCount
	--tableAchievements = achievements
	
	toggleAllControls(false, true, false)

	local width, height = 420, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCharacter = guiCreateTabPanel(5, y, width, height, false)
	tabCharacter = guiCreateTab("Character Selection", tabPanelCharacter)
	tabAccount = guiCreateTab("Account Management", tabPanelCharacter)
	tabAchievements = guiCreateTab("Achievements", tabPanelCharacter)
	addEventHandler("onClientGUITabSwitched", tabPanelCharacter, changedTab)
	
	displayAccountManagement()
	--displayAchievements()

	-- Character Info
	local charsDead, charsAlive = 0, 0
	
	for key, value in pairs(accounts) do
		if (tonumber(accounts[key][3])==1) then
			charsDead = charsDead + 1
		else
			charsAlive = charsAlive + 1
		end
	end
	
	lCharacters = guiCreateLabel(0.05, 0.025, 0.9, 0.15, "Characters: " .. #accounts .. " (" .. charsAlive .. " Alive, " .. charsDead .. " Dead).", true, tabCharacter)
	guiSetFont(lCharacters, "default-bold-small")
	
	paneCharacters = guiCreateScrollPane(0.05, 0.075, 0.9, 0.8, true, tabCharacter)
	
	paneChars = { }
	local y = 0.0
	local height = 0.2
	
	for key, value in pairs(accounts) do
		local charname = string.gsub(tostring(accounts[key][2]), "_", " ")
		local cked = tonumber(accounts[key][3])
		local area = accounts[key][4]
		local age = accounts[key][5]
		local gender = tonumber(accounts[key][6])
		local factionName = accounts[key][7]
		local factionRank = accounts[key][8]
		local skinID = tostring(accounts[key][9])
		--local charyearday = tonumber(accounts[key][10])
		--local charyear = tonumber(accounts[key][11])
		local difference = tonumber(accounts[key][10])
		local login = ""
		
		-- Compare the TIME
		--local time = getRealTime()
		--local year = 1900+time.year
		--local yearday = time.yearday

		if (not difference) then
			login = "Never"
		else
			--local difference = yearday - charyearday
			
			if (difference==0) then
				login = "Today"
			elseif (difference==1) then
				login = tostring(difference) .. " day ago"
			else
				login = tostring(difference) .. " days ago"
			end
		end
		
		--Fix skin ID
		if (string.len(skinID)==2) then
			skinID = "0" .. skinID
		elseif (string.len(skinID)==1) then
			skinID = "00" .. skinID
		end
		
		-- Gender
		if (gender==nil) then
			gender = "Male"
		else
			gender = "Female"
		end
		
		paneChars[key] = {}
		paneChars[key][7] = guiCreateScrollPane(0.0, y, 1.0, 0.35, true, paneCharacters)
		paneChars[key][1] = guiCreateStaticImage(0.0, 0.1, 0.95, 0.5, "img/charbg0.png", true, paneChars[key][7])
		paneChars[key][8] = cked
		
		if (cked==nil) then
			paneChars[key][2] = guiCreateLabel(0.3, 0.1, 0.5, 0.2, tostring(charname), true, paneChars[key][7])
		else
			paneChars[key][2] = guiCreateLabel(0.3, 0.1, 0.5, 0.2, tostring(charname) .. " (Deceased)", true, paneChars[key][7])
		end
		
		paneChars[key][3] = guiCreateStaticImage(0.05, 0.1, 0.2, 0.5, "img/" .. skinID .. ".png", true, paneChars[key][7])
		paneChars[key][4] = guiCreateLabel(0.3, 0.25, 0.7, 0.2, age .. " year old " .. gender .. ".", true, paneChars[key][7])
		
		if (factionRank==nil) then
			paneChars[key][5] = guiCreateLabel(0.3, 0.35, 0.7, 0.2, "Not in a faction.", true, paneChars[key][7])
		else
			paneChars[key][5] = guiCreateLabel(0.3, 0.35, 0.7, 0.2, tostring(factionRank) .. " of '" .. tostring(factionName) .. "'.", true, paneChars[key][7])
		end
		
		if (login~="Never") then
			paneChars[key][6] = guiCreateLabel(0.3, 0.45, 0.7, 0.2, "Last seen: " .. login .. " at " .. area .. ".", true, paneChars[key][7])
		else
			paneChars[key][6] = guiCreateLabel(0.3, 0.45, 0.7, 0.2, "Last seen: Never", true, paneChars[key][7])
		end
		
		addEventHandler("onClientGUIClick", paneChars[key][1], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][2], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][3], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][4], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][5], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][6], selectedCharacter)
		addEventHandler("onClientGUIClick", paneChars[key][7], selectedCharacter)
		
		addEventHandler("onClientGUIDoubleClick", paneChars[key][1], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][2], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][3], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][4], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][5], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][6], dcselectedCharacter)
		addEventHandler("onClientGUIDoubleClick", paneChars[key][7], dcselectedCharacter)
		
		-- Set the fonts
		guiSetFont(paneChars[key][2], "default-bold-small")
		guiSetFont(paneChars[key][4], "default-small")
		guiSetFont(paneChars[key][5], "default-small")
		guiSetFont(paneChars[key][6], "default-small")
		
		y = y + 0.205
	end
	
	-- For character creation
	lCreateFakepane = guiCreateScrollPane(0.0, y-0.015, 1.0, 0.35, true, paneCharacters)
	lCreateBG = guiCreateStaticImage(0.0, 0.1, 0.95, 0.5, "img/charbg0.png", true, lCreateFakepane)
	lCreateName = guiCreateLabel(0.3, 0.1, 0.5, 0.2, "Create a character", true, lCreateFakepane)
	lCreateImage = guiCreateStaticImage(0.05, 0.07, 0.2, 0.53, "img/newchar.png", true, lCreateFakepane)

	guiSetFont(lCreateName, "default-bold-small")
	
	addEventHandler("onClientGUIClick", lCreateFakepane, selectedCharacter)
	--addEventHandler("onClientGUIClick", lCreateBG, selectedCharacter)
	--addEventHandler("onClientGUIClick", lCreateName, selectedCharacter)
	--addEventHandler("onClientGUIClick", lCreateImage, selectedCharacter)
	
	addEventHandler("onClientGUIDoubleClick", lCreateFakepane, dcselectedCharacter)
	addEventHandler("onClientGUIDoubleClick", lCreateBG, dcselectedCharacter)
	addEventHandler("onClientGUIDoubleClick", lCreateName, dcselectedCharacter)
	addEventHandler("onClientGUIDoubleClick", lCreateImage, dcselectedCharacter)
	
	-- Edit Char button
	bEditChar = guiCreateButton(0.05, 0.875, 0.9, 0.05, "Edit Character", true, tabCharacter)
	addEventHandler("onClientGUIClick", bEditChar, editSelectedCharacter, false)
	
	-- Delete char button
	bDeleteChar = guiCreateButton(0.05, 0.925, 0.9, 0.05, "Delete Character", true, tabCharacter)
	addEventHandler("onClientGUIClick", bDeleteChar, deleteSelectedCharacter, false)
	
	guiSetVisible(bEditChar, false)
	guiSetVisible(bDeleteChar, false)
	
	guiSetAlpha(tabPanelCharacter, 0.75)
	showCursor(true)
	setElementAlpha(getLocalPlayer(), 0)
	fadeCamera(true, 2)
	
	if ( needsEmail ) then
		promptEmail()
	end
	
	guiSetInputEnabled(true)
end
wEmail, lEmailInfo, lEmail, tEmail, bSubmitEmail = nil
function promptEmail()
	guiSetAlpha(tabPanelCharacter, 0.3)
	guiSetEnabled(tabPanelCharacter, false)
	
	local width, height = 400, 200
	
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
			
	wEmail = guiCreateWindow(x, y, width, height, "Email Address Required!", false)
	
	lEmailInfo = guiCreateLabel(0.02, 0.1, 0.95, 0.3, "Our records show that you currently do not have an email address linked to your account.\n\nThis email address will be used should you forget your details.", true, wEmail)
	guiLabelSetHorizontalAlign(lEmailInfo, "center", true)
	guiSetFont(lEmailInfo, "default-bold-small")
	
	lEmail = guiCreateLabel(0.15, 0.6, 0.3, 0.3, "Email Address:", true, wEmail)
	guiSetFont(lEmail, "default-bold-small")
	
	tEmail = guiCreateEdit(0.38, 0.59, 0.5, 0.1, "email@address.com", true, wEmail)
	guiSetFont(tEmail, "default-bold-small")
	addEventHandler("onClientGUIChanged", tEmail, checkEmail, false)
	
	bSubmitEmail = guiCreateButton(0.15, 0.75, 0.7, 0.15, "Submit", true, wEmail)
	addEventHandler("onClientGUIClick", bSubmitEmail, submitEmail, false)
	guiSetFont(bSubmitEmail, "default-bold-small")
	guiSetEnabled(bSubmitEmail, false)
	guiSetAlpha(bSubmitEmail, 0.5)
end

function submitEmail()
	local email = guiGetText(tEmail)
	cleanupEmail()
	guiSetAlpha(tabPanelCharacter, 0.7)
	guiSetEnabled(tabPanelCharacter, true)
	
	triggerServerEvent("storeEmail", getLocalPlayer(), email)
end

function checkEmail()
	local text = guiGetText(source)
	
	local length = text:len()
	local atSymbol = text:find("@")
	
	if ( length > 5 and atSymbol ~= nil ) then
		guiSetEnabled(bSubmitEmail, true)
		guiSetAlpha(bSubmitEmail, 1.0)
	else
		guiSetEnabled(bSubmitEmail, false)
		guiSetAlpha(bSubmitEmail, 0.5)
	end
end

function cleanupEmail()
	if ( tabPanelCharacter ) then
		guiSetAlpha(tabPanelCharacter, 0.7)
		guiSetEnabled(tabPanelCharacter, true)
	end
	
	if ( wEmail ) then
		destroyElement(wEmail)
		wEmail = nil
		lEmail = nil
		lEmailInfo = nil
		tEmail = nil
		bSubmitEmail = nil
	end
end

function changeAccount(button, state)
	if (source==bChangeAccount) and (button=="left") then
		local id = getElementData(getLocalPlayer(), "gameaccountid")
		showCursor(false)
		cancelCreation()
		hideUI()
		
		createMainUI(getThisResource(), true)
		--destroyElement(bChangeAccount)
		--bChangeAccount = nil
		triggerServerEvent("account:loggedout", getLocalPlayer())
	end
end

fading = false
tmrHideMouse = nil

function fadePlayerIn(newChar)
	local alpha = getElementAlpha(getLocalPlayer())
	setElementAlpha(getLocalPlayer(), alpha+25)
	if ((alpha+25)>=250) then
		setElementAlpha(getLocalPlayer(), 255)
		showCursor(true)
		fading = false
	end
end

triggering = false
spawned = false

function deleteSelectedCharacter(button, state)
	if (button=="left") and (state=="up") and (source==bDeleteChar) then
		if (selectedChar) and not wDelConfirmation then
			local charname = tostring(guiGetText(paneChars[selectedChar][2]))
			local sx, sy = guiGetScreenSize() 
			wDelConfirmation = guiCreateWindow(sx/2 - 125,sy/2 - 50,250,100,"Deletion Confirmation", false)
			local lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3,"Do you really want to delete the character "..charname.."?",true,wDelConfirmation)
							  guiLabelSetHorizontalAlign (lQuestion,"center",true)
			local bYes = guiCreateButton(0.1,0.65,0.37,0.23,"Yes",true,wDelConfirmation)
			local bNo = guiCreateButton(0.53,0.65,0.37,0.23,"No",true,wDelConfirmation)
			addEventHandler("onClientGUIClick", getRootElement(), 
				function(button)
					if (button=="left") then
						if source == bYes then
							triggerServerEvent("deleteCharacter", getLocalPlayer(), charname)
							deleteCharacter(charname)
						elseif source == bNo then
							if wDelConfirmation then
								destroyElement(wDelConfirmation)
								wDelConfirmation = nil
							end
						end
					end
				end
			)
		end
	end
end

function deleteCharacter(charname)
	hideUI()
	tableAccounts[selectedChar] = nil
	showCharacterUI(tableAccounts, false)
end
			
addEvent("onClientChooseCharacter", false)
function dcselectedCharacter(button, state)
	if (button=="left") and (state=="up") then
		if (source~=lCreateFakepane) and (source~=lCreateBG) and (source~=lCreateName) and (source~=lCreateImage) then
			if not (triggering) then
				triggering = true
			
				-- Find the key that was hit
				local foundkey = nil
				for key, value in pairs(paneChars) do
					for i, j in pairs(paneChars[key]) do
						if (j==source) then
							foundkey = key
						end
					end
				end
				
				local charname = tostring(guiGetText(paneChars[foundkey][2]))
				local cked = string.find(charname, "(Deceased)")

				if (cked==nil) then
					fadeCamera(false, 1)
					setCameraInterior(0)
					spawned = true
					destroyElement(tabPanelCharacter)
					playSoundFrontEnd(32)
					sent = false
					triggerServerEvent("spawnCharacter", getLocalPlayer(), charname, getVersion().mta)
					setTimer(resetTriggers, 100, 1)
					setTimer(showCursor, 50, 30, false)
					
					toggleAllControls(true, true, true)
					guiSetInputEnabled(false)
					showCursor(false)
					showChat(true)
					showLogoutPanel()
					
					--triggerEvent("showHud", getLocalPlayer())
					showPlayerHudComponent("weapon", true)
					showPlayerHudComponent("ammo", true)
					showPlayerHudComponent("vehicle_name", false)
					showPlayerHudComponent("money", true)		
					showPlayerHudComponent("health", true)
					showPlayerHudComponent("armour", true)
					showPlayerHudComponent("breath", true)
					showPlayerHudComponent("radar", true)
					showPlayerHudComponent("area_name", true)
				else
					triggering = false
					setTimer(playSoundFrontEnd, 500, 3, 20)
				end
			end
		else
			if (creation==false) then
				creation = true
				guiSetVisible(tabPanelCharacter, false)
				characterCreation()
				playSoundFrontEnd(32)
			end
		end
	end
end



bChangeChar = nil
selectedChar = nil
function showLogoutPanel()
	bChangeChar = guiCreateButton(0.835, 0.925, 0.15, 0.05, "Change Character", true)
	guiSetAlpha(bChangeChar, 0.75)
	addEventHandler("onClientGUIClick", bChangeChar, changeCharacter)
end

addEvent("onClientChangeChar", false)
function changeCharacter(button, state)
	if (source==bChangeChar) and (button=="left") then
		local id = getElementData(getLocalPlayer(), "gameaccountid")
		destroyElement(bChangeChar)
		bChangeChar = nil
		showCursor(false)
		triggerEvent("onClientChangeChar", getLocalPlayer())
		triggerServerEvent("sendAccounts", getLocalPlayer(), getLocalPlayer(), id, true)
		triggerServerEvent("player:loggedout", getLocalPlayer())
	end
end

function resetTriggers()
	triggering = false
end

function unhideCursor()
	if not (spawned) then
		showCursor(true)
	else
		showCursor(false)
	end
end

function selectedCharacter(button, state)
	if (button=="left") and (state=="up") then
		playSoundFrontEnd(32)
		if (source~=lCreateFakepane) and (source~=lCreateBG) and (source~=lCreateName) and (source~=lCreateImage) then
			
			local found = false
			local key = 0
			for i, j in pairs(paneChars) do
				local isthis = false
				for k, v in pairs(paneChars[i]) do
			        if (v==source) then
						isthis = true
						found = true
						key = i
					end
				end
				
				guiBringToFront(paneChars[i][2])
				guiBringToFront(paneChars[i][3])
				guiBringToFront(paneChars[i][4])
				guiBringToFront(paneChars[i][5])
				guiBringToFront(paneChars[i][6])
				guiBringToFront(paneChars[i][7])
				
				guiBringToFront(lCreateBG)
				guiBringToFront(lCreateFakepane)
				guiBringToFront(lCreateName)
				guiBringToFront(lCreateImage)
				if not (isthis) then
					guiStaticImageLoadImage(paneChars[i][1], "img/charbg0.png")
				end
			end

			if (found) then
				guiStaticImageLoadImage(paneChars[key][1], "img/charbg1.png")
				selectedChar = key
				guiStaticImageLoadImage(lCreateBG, "img/charbg0.png")

				local skinID = tonumber(tableAccounts[key][9])
				local cked = tonumber(tableAccounts[key][3])
				setElementModel(getLocalPlayer(), skinID)
					
				local rand = math.random(1,6)
				if (rand==1) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "shift", -1, true, true, true)
				elseif (rand==2) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "shldr", -1, true, true, true)
				elseif (rand==3) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "stretch", -1, true, true, true)
				elseif (rand==4) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "strleg", -1, true, true, true)
				elseif (rand==5) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "time", -1, true, true, true)
				elseif (rand==6) then
					exports.global:applyAnimation(getLocalPlayer(), "ON_LOOKERS", "wave_loop", -1, true, true, true)
				end
				
				setElementAlpha(getLocalPlayer(), 0)
					
				if (cked==nil) then
					--if (skinID==0) then -- Load CJ's clothes etc.
					--	local charname = tableAccounts[key][2]
					--	triggerServerEvent("spawnClothes", getLocalPlayer(), charname)
					--end
					fading = true
						
					if (isTimer(tmrFadeIn)) then killTimer(tmrFadeIn) end
					
					tmrHideMouse = setTimer(unhideCursor, 200, 1)
					tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
					
					guiSetVisible(bEditChar, true)
					guiSetVisible(bDeleteChar, true)
				else
					local x, y, z = getElementPosition(getLocalPlayer())
					setElementAlpha(getLocalPlayer(), 0)
					tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
					exports.global:applyAnimation(getLocalPlayer(), "WUZI", "CS_Dead_Guy", -1, true, false, true)

					guiSetVisible(bEditChar, false)
					guiSetVisible(bDeleteChar, false)
				end
			end
			
		else
			if (isTimer(tmrFadeIn)) then killTimer(tmrFadeIn) end
			
			for key, value in ipairs(paneChars) do
				guiStaticImageLoadImage(paneChars[key][1], "img/charbg0.png")
			end
			selectedChar = nil
			
			guiBringToFront(lCreateBG)
			guiBringToFront(lCreateFakepane)
			guiBringToFront(lCreateName)
			guiBringToFront(lCreateImage)
			guiStaticImageLoadImage(lCreateBG, "img/charbg1.png")
			
			-- Player effect
			setElementModel(getLocalPlayer(), 264)
			
			local rand = math.random(1,6)
				if (rand==1) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "shift", -1, true, false, true)
				elseif (rand==2) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "shldr", -1, true, false, true)
				elseif (rand==3) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "stretch", -1, true, false, true)
				elseif (rand==4) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "strleg", -1, true, false, true)
				elseif (rand==5) then
					exports.global:applyAnimation(getLocalPlayer(), "PLAYIDLES", "time", -1, true, false, true)
				elseif (rand==6) then
					exports.global:applyAnimation(getLocalPlayer(), "ON_LOOKERS", "wave_loop", -1, true, false, true)
				end
				
			-- optomize this
			--triggerServerEvent("stripPlayer", getLocalPlayer())
			setElementAlpha(getLocalPlayer(), 0)
				
				
			fading = true
			
			tmrHideMouse = setTimer(unhideCursor, 200, 1)
			tmrFadeIn = setTimer(fadePlayerIn, 50, 10)
			
			guiSetVisible(bEditChar, false)
			guiSetVisible(bDeleteChar, false)
		end
	end
end

-- /////////////////////////////// CHARACTER CREATION ////////////////////////////////////
tabPanelCreation, bCancel, bNext, lType, rNormal, rCJ = nil

-- Step 1
fatness = 0
muscles = 0
name = ""

tabCreationOne, lName, tName, lRestrictions, bRotate = nil

creation = false

function characterCreation()
	local width, height = 400, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
	tabCreationOne = guiCreateTab("Character Creation: Step 1", tabPanelCreation)
	guiSetAlpha(tabPanelCreation, 0.75)
	
	rot = 120.0
	addEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
	
	--lType = guiCreateLabel(0.1, 0.45, 0.25, 0.1, "Character Type:", true, tabCreationOne)
	--guiSetFont(lType, "default-bold-small")
	
	--rCJ = guiCreateRadioButton(0.15, 0.5, 0.6, 0.05, "CJ - Ultimate customization", true, tabCreationOne)
	--rNormal = guiCreateRadioButton(0.15, 0.65, 0.6, 0.05, "Normal - Pedestrian skin", true, tabCreationOne)
	
	
	--guiRadioButtonSetSelected(rCJ, true)
	--addEventHandler("onClientGUIClick", rNormal, spawnNormal, false)
	--addEventHandler("onClientGUIClick", rCJ, spawnCJ, false)
	
	
	--guiSetFont(rNormal, "default-bold-small")
	--guiSetFont(rCJ, "default-bold-small")
	
	bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationOne)
	addEventHandler("onClientGUIClick", bNext, loadNextPage, false)
	
	bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationOne)
	addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
	
	-- Step 1 tab contents
	lName = guiCreateLabel(0.1, 0.05, 0.25, 0.1, "Character Name:", true, tabCreationOne) 
	tName = guiCreateEdit(0.35, 0.05, 0.4, 0.05, "Joe Bloggs", true, tabCreationOne)
	
	addEventHandler("onClientGUIChanged", tName, checkName) 
	guiSetFont(lName, "default-bold-small")
	
	lRestrictions = guiCreateLabel(0.0, 0.105, 1.0, 0.3, "Restrictions: \n\n - Must NOT contain underscores, use spaces. \n - Must be a realistic, roleplay name \n - Must be less than 23 characters long \n - Must be two words, Firstname Lastname \n - Cannot contain numbers \n - Cannot contain special characters such as $@';", true, tabCreationOne)
	guiLabelSetColor(lRestrictions, 0, 255, 0)
	guiLabelSetHorizontalAlign(lRestrictions, "center")
	guiSetFont(lRestrictions,"default-bold-small")
	
	bRotate = guiCreateButton(0.835, 0.855, 0.15, 0.05, "Pause Camera", true)
	guiSetAlpha(bRotate, 0.75)
	addEventHandler("onClientGUIClick", bRotate, pauseCameraMovement, false)
	
	showCursor(true)
	guiSetInputEnabled(true)
end

function pauseCameraMovement()
	if not (removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)) then
		addEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
		guiSetText(bRotate, "Pause Camera")
	else
		guiSetText(bRotate, "Un-Pause Camera")
	end
end

function spawnCJ(button, state)
	--[[
	if (button=="left") and (state=="up") then
		setElementModel(getLocalPlayer(), 0) 
		for i = 0, 17 do
			removePlayerClothes(getLocalPlayer(), i)
		end
	end
	]]--
end

function spawnNormal(button, state)
	if (button=="left") and (state=="up") then
		skinint = math.random(1, #blackMales)
		skin = blackMales[skinint]
		setElementModel(getLocalPlayer(), skin)
		curskin = skinint
	end
end

function checkName()
	if (source==tName) then
		local theText = guiGetText(source)
		
		local foundSpace, valid = false, true
		local lastChar, current = ' ', ''
		for i = 1, #theText do
			local char = theText:sub( i, i )
			if char == ' ' then -- it's a space
				if i == #theText then -- space at the end of name is not allowed
					valid = false
					break
				else
					foundSpace = true -- we have at least two name parts
				end
				
				if #current < 2 then -- check if name's part is at least 2 chars
					valid = false
					break
				end
				current = ''
			elseif lastChar == ' ' then -- this char follows a space, we need a capital letter
				if char < 'A' or char > 'Z' then
					valid = false
					break
				end
				current = current .. char
			elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) then -- can have letters anywhere in the name
				current = current .. char
			else -- unrecognized char (numbers, special chars)
				valid = false
				break
			end
			lastChar = char
		end
		
		if valid and foundSpace and #theText < 22 and #current >= 2 then
			guiLabelSetColor(lRestrictions, 0, 255, 0)
			guiSetEnabled(bNext, true)
		else
			guiLabelSetColor(lRestrictions, 255, 0, 0)
			guiSetEnabled(bNext, false)
		end
	end
end

function cancelCreation(button, state)
			--triggerServerEvent("stripPlayer", getLocalPlayer())
			removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
			
			if (isElement(bRotate)) then
				destroyElement(bRotate)
			end
			bRotate = nil
			local playerid = getElementData(getLocalPlayer(), "playerid")
			setElementInterior(getLocalPlayer(), 14)
			setElementDimension(getLocalPlayer(), 65000+playerid)
			setElementPosition(getLocalPlayer(), 258.43417358398, -41.489139556885, 1002.0234375)
			setPedRotation(getLocalPlayer(), 268.19247436523)
			
			creation = false
			
			if (isElement(tabPanelCreation)) then
				destroyElement(tabPanelCreation)
			end
			tabPanelCreation = nil
			
			
			setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375)
			setCameraInterior(14)
			fadeCamera(true)
			
			--addEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
			guiSetVisible(tabPanelCharacter, true)
end

rot = 120.0
function moveCameraToCreation()
	local pX, pY, pZ = getElementPosition(getLocalPlayer())
	local x = pX + math.cos(math.deg(rot))*2
	local y = pY + math.sin(math.deg(rot))*2
		
	local sight, eX, eY, eZ = processLineOfSight(pX, pY, pZ, x, y, pZ+1, true, true, false)
			
	if (sight) then
		setCameraMatrix(eX, eY, eZ, pX, pY, pZ+0.2)
	else
		setCameraMatrix(x, y, pZ+1, pX, pY, pZ+0.2)
	end
	rot = rot + 0.0001
end

function loadNextPage(button, state)
	if (button=="left") and (state=="up") then
		triggerServerEvent("doesCharacterExist", getLocalPlayer(), guiGetText(tName))
	end
end

function nextPage(exists)
	if (exists) then
		guiSetText(tName, "Already Taken")
		guiLabelSetColor(lRestrictions, 255, 0, 0)
		guiSetEnabled(bNext, false)
	elseif not (exists) then
		--local CJ = guiRadioButtonGetSelected(rCJ)
			
		name = guiGetText(tName)
		destroyElement(tabCreationOne)
		tabCreationOne = nil
			
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		--if (CJ) then
		--	characterCreationStep2CJ()
		--else
			characterCreationStep2Normal()
		--end
	end
end
addEvent("characterNextStep", true )
addEventHandler("characterNextStep", getRootElement(), nextPage)

tabCreationTwo, fatInc, fatDec, lFat, lFatDesc, muscleInc, muscleDec, lMuscle, lMuscleDesc = nil
lDescriptionNormal, lGender, rMale, rFemale, lSkinColour, rBlack, rWhite, rAsian, tempPane, lChangeSkin, nextSkin, prevSkin = nil
gender = 0
skincolour = 1
curskin = 0

blackMales = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264 }
asianMales = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229}
blackFemales = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

function characterCreationStep2Normal()
	gender = 0
	skincolour = 1
	curskin = 0
	
	local width, height = 400, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
	tabCreationTwo = guiCreateTab("Character Creation: Step 2", tabPanelCreation)
	guiSetAlpha(tabPanelCreation, 0.75)
	
	lDescriptionNormal = guiCreateLabel(0.1, 0.025, 0.9, 0.15, "Design your character", true, tabCreationTwo) 
	guiSetFont(lDescriptionNormal, "sa-header")
	
	--/////////////
	-- GENDER
	--/////////////
	lGender = guiCreateLabel(0.1, 0.225, 0.25, 0.15, "Gender:", true, tabCreationTwo)
	guiSetFont(lGender, "default-bold-small")

	rMale =  guiCreateRadioButton(0.4, 0.225, 0.15, 0.05, "Male", true, tabCreationTwo)
	rFemale =  guiCreateRadioButton(0.65, 0.225, 0.15, 0.05, "Female", true, tabCreationTwo)
	guiRadioButtonSetSelected(rMale, true)
	addEventHandler("onClientGUIClick", rMale, normalSetMale, false)
	addEventHandler("onClientGUIClick", rFemale, normalSetFemale, false)
	
	--/////////////
	-- SKIN COLOUR
	--/////////////
	tempPane = guiCreateScrollPane(0.05, 0.35, 0.9, 0.4, true, tabCreationTwo)
	lSkinColour = guiCreateLabel(0.1, 0.375, 0.25, 0.15, "Skin Colour:", true, tempPane)
	guiSetFont(lSkinColour, "default-bold-small")

	rBlack =  guiCreateRadioButton(0.4, 0.385, 0.15, 0.15, "Black", true, tempPane)
	rWhite =  guiCreateRadioButton(0.6, 0.385, 0.15, 0.15, "White", true, tempPane)
	rAsian =  guiCreateRadioButton(0.8, 0.385, 0.15, 0.15, "Asian", true, tempPane)
	guiRadioButtonSetSelected(rWhite, true)
	addEventHandler("onClientGUIClick", rBlack, normalSetBlack, true, false, false)
	addEventHandler("onClientGUIClick", rWhite, normalSetWhite, false, true, false)
	addEventHandler("onClientGUIClick", rAsian, normalSetAsian, false, false, true)
	
	--/////////////
	-- SKIN
	--/////////////
	lChangeSkin = guiCreateLabel(0.1, 0.535, 0.25, 0.2, "Skin:", true, tempPane) 
	guiSetFont(lChangeSkin, "default-bold-small")
	
	prevSkin =  guiCreateButton(0.3, 0.525, 0.2, 0.15, "<-", true, tempPane)
	addEventHandler("onClientGUIClick", prevSkin, adjustNormalSkin, false)
	
	nextSkin =  guiCreateButton(0.6, 0.525, 0.2, 0.15, "->", true, tempPane)
	addEventHandler("onClientGUIClick", nextSkin, adjustNormalSkin, false)
	
	-- NEXT/BACK
	bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bNext, characterCreationStep5, false)
	
	bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
end

function adjustNormalSkin(button, state)
	if (button=="left") and (state=="up") then
		if (source==nextSkin) then
			local array = nil
			if (skincolour==0) then -- BLACK
				if (gender==0) then -- BLACK MALE
					array = blackMales
				elseif (gender==1) then -- BLACK FEMALE
					array = blackFemales
				end
			elseif (skincolour==1) then -- WHITE
				if (gender==0) then -- WHITE MALE
					array = whiteMales
				elseif (gender==1) then -- WHITE FEMALE
					array = whiteFemales
				end
			elseif (skincolour==2) then -- ASIAN
				if (gender==0) then -- ASIAN MALE
					array = asianMales
				elseif (gender==1) then -- ASIAN FEMALE
					array = asianFemales
				end
			end
			
			-- Get the next skin
			if (curskin==#array) then
				curskin = 1
				skin = array[1]
				setElementModel(getLocalPlayer(), tonumber(skin))
			else
				curskin = curskin + 1
				skin = array[curskin]
				setElementModel(getLocalPlayer(), tonumber(skin))
			end
		elseif (source==prevSkin) then
			local array = nil
			if (skincolour==0) then -- BLACK
				if (gender==0) then -- BLACK MALE
					array = blackMales
				elseif (gender==1) then -- BLACK FEMALE
					array = blackFemales
				end
			elseif (skincolour==1) then -- WHITE
				if (gender==0) then -- WHITE MALE
					array = whiteMales
				elseif (gender==1) then -- WHITE FEMALE
					array = whiteFemales
				end
			elseif (skincolour==2) then -- ASIAN
				if (gender==0) then -- ASIAN MALE
					array = asianMales
				elseif (gender==1) then -- ASIAN FEMALE
					array = asianFemales
				end
			end
			
			-- Get the next skin
			if (curskin==1) then
				curskin = #array
				skin = array[1]
				setElementModel(getLocalPlayer(), tonumber(skin))
			else
				curskin = curskin - 1
				skin = array[curskin]
				setElementModel(getLocalPlayer(), tonumber(skin))
			end
		end
	end
end

function normalSetMale(button, state)
	if (source==rMale) and (button=="left") and (state=="up") then
		gender = 0
		generateSkin()
	end
end

function normalSetFemale(button, state)
	if (source==rFemale) and (button=="left") and (state=="up") then
		gender = 1
		generateSkin()
	end
end

function normalSetBlack(button, state)
	if (source==rBlack) and (button=="left") and (state=="up") then
		skincolour = 0
		generateSkin()
	end
end

function normalSetWhite(button, state)
	if (source==rWhite) and (button=="left") and (state=="up") then
		skincolour = 1
		generateSkin()
	end
end

function normalSetAsian(button, state)
	if (source==rAsian) and (button=="left") and (state=="up") then
		skincolour = 2
		generateSkin()
	end
end

function generateSkin()
	local skinint = 0
	if (gender==0) then -- MALE
		if (skincolour==0) then -- BLACK
			skinint = math.random(1, #blackMales)
			skin = blackMales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==1) then -- WHITE
			skinint = math.random(1, #whiteMales)
			skin = whiteMales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==2) then -- ASIAN
			skinint = math.random(1, #asianMales)
			skin = asianMales[skinint]
			setElementModel(getLocalPlayer(), skin)
		end
	elseif (gender==1) then -- FEMALE
		if (skincolour==0) then -- BLACK
			skinint = math.random(1, #blackFemales)
			skin = blackFemales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==1) then -- WHITE
			skinint = math.random(1, #whiteFemales)
			skin = whiteFemales[skinint]
			setElementModel(getLocalPlayer(), skin)
		elseif (skincolour==2) then -- ASIAN
			skinint = math.random(1, #asianFemales)
			skin = asianFemales[skinint]
			setElementModel(getLocalPlayer(), skin)
		end
	end
	curskin = skinint
end
	
--[[
function characterCreationStep2CJ()
	fatness = 0
	muscles = 0
	gender = 0
	skincolour = 0
	local width, height = 400, 400
			
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
	tabCreationTwo = guiCreateTab("Character Creation: Step 2", tabPanelCreation)
	guiSetAlpha(tabPanelCreation, 0.75)
	
	--/////////////
	-- FAT
	--/////////////
	lFat = guiCreateLabel(0.1, 0.025, 0.25, 0.15, "Fat", true, tabCreationTwo) 
	guiSetFont(lFat, "sa-header")
	
	lFatDesc = guiCreateLabel(0.1, 0.15, 0.9, 0.1, "Be able to climb a wall: Will he or won't he?", true, tabCreationTwo)
	guiSetFont(lFatDesc, "default-bold-small")
	
	fatDec =  guiCreateButton(0.15, 0.225, 0.2, 0.1, "-", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", fatDec, adjustFatness, false)
	
	fatInc =  guiCreateButton(0.45, 0.225, 0.2, 0.1, "+", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", fatInc, adjustFatness, false)
	
	--/////////////
	-- MUSCLES
	--/////////////
	lMuscle = guiCreateLabel(0.1, 0.375, 0.4, 0.15, "Muscles", true, tabCreationTwo)
	guiSetFont(lMuscle, "sa-header")
	
	lMuscleDesc = guiCreateLabel(0.1, 0.5, 0.9, 0.1, "Rocky Balboa or Minnie Mouse?", true, tabCreationTwo)
	guiSetFont(lMuscleDesc, "default-bold-small")
	
	muscleDec =  guiCreateButton(0.15, 0.575, 0.2, 0.1, "-", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", muscleDec, adjustMuscles, false)
	
	muscleInc =  guiCreateButton(0.45, 0.575, 0.2, 0.1, "+", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", muscleInc, adjustMuscles, false)
	
	-- NEXT/BACK
	bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bNext, characterCreationStep3CJ, false)
	
	bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationTwo)
	addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
end

function adjustFatness(button, state)
	if (button=="left") and (state=="up") then
		if (source==fatDec) then
			if (fatness>=99) then
				fatness = fatness - 99
				triggerServerEvent("adjustFatness", getLocalPlayer(), fatness)
			end
		elseif (source==fatInc) then
			if (fatness<=900) then
				fatness = fatness + 99
				triggerServerEvent("adjustFatness", getLocalPlayer(), fatness)
			end
		end
	end
end

function adjustMuscles(button, state)
	if (button=="left") and (state=="up") then
		if (source==muscleDec) then
			if (muscles>=99) then
				muscles = muscles - 99
				triggerServerEvent("adjustMuscles", getLocalPlayer(), muscles)
			end
		elseif (source==muscleInc) then
			if (muscles<=900) then
				muscles = muscles + 99
				triggerServerEvent("adjustMuscles", getLocalPlayer(), muscles)
			end
		end
	end
end


leftUpperArmTattoos = { {"NONE", "NONE"}, {"4WEED", "4weed"}, {"4RIP", "4rip"}, {"4SPIDER", "4spider"} }
leftLowerArmTattoos = { {"NONE", "NONE"}, {"5GUN", "5gun"}, {"5CROSS", "5cross"}, {"5CROSS2", "5cross2"}, {"5CROSS3", "5cross3"}  }
rightUpperArmTattoos = { {"NONE", "NONE"}, {"6AZTEC", "6aztec"}, {"6CROWN", "6crown"}, {"6CLOWN", "6clown"}, {"6AFRICA", "6africa"} }
rightLowerArmTattoos = { {"NONE", "NONE"}, {"7CROSS", "7cross"}, {"7CROSS2", "7cross2"}, {"7MARY", "7mary"} }
backTattoos = { {"NONE", "NONE"}, {"8SA", "8sa"}, {"8SA2", "8sa2"}, {"8SA3", "8sa3"}, {"8WESTSD", "8westside"}, {"8SANTOS", "8santos"}, {"8POKER", "8poker"}, {"8GUN", "8gun"} }
leftChestTattoos = { {"NONE", "NONE"}, {"9CROWN", "9crown"}, {"9GUN", "9GUN"}, {"9GUN2", "9gun2"}, {"9HOMBY", "9homeboy"}, {"9BULLT", "9bullet"}, {"9RASTA", "9rasta"} }
rightChestTattoos = { {"NONE", "NONE"}, {"10LS", "10ls"}, {"10LS2", "10ls2"}, {"10LS3", "10ls3"}, {"10LS4", "10ls4"}, {"10ls5", "10ls5"}, {"10OG", "10og"}, {"10WEED", "10weed"} }
stomachTattoos = { {"NONE", "NONE"}, {"11GROVE", "11grove"}, {"11GROV2", "11grove2"}, {"11GROV3", "11grove3"}, {"11DICE", "11dice"}, {"11DICE2", "11dice2"}, {"11JAIL", "11jail"}, {"11GGIFT", "11godsgift"} }
lowerBackTattoos = { {"NONE", "NONE"}, {"12ANGEL", "12angels"}, {"12MAYBR", "12mayabird"}, {"12DAGER", "12dagger"}, {"12BNDIT", "12bandit"}, {"12CROSS", "12cross7"}, {"12MYFAC", "12mayafce"} }

lTattoos, lLeftUpperArm, bLeftUpperPrev, bLeftUpperNext, lLeftLowerArm, bLeftLowerPrev, bLeftLowNext, lRightUpperArm, bRightUpperPrev, bRightUpperNext, lRightLowerArm, bRightLowerPrev, bRightLowNext, lBackTattoo, bBackTattooPrev, bBackTattooNext, lLeftChest, bLeftChestPrev, bLeftChestNext = nil
lRightChest, bRightChestPrev, bRightChestNext, lStomach, bStomachPrev, bStomachNext, lLowBack, bLowBackPrev, bLowBackNext = nil
lLeftUpperArmInfo, lLeftLowerArmInfo, lRightUpperArmInfo, lRightLowerArmInfo, lBackTattooInfo, lLeftChestInfo, lRightChestInfo, lStomachInfo, lLowerBackInfo = nil
luTattoo = 1
llTattoo = 1
ruTattoo = 1
rlTattoo = 1
bTattoo = 1
lcTattoo = 1
rcTattoo = 1
sTattoo = 1
lbTattoo = 1

function characterCreationStep3CJ()
		gender = 0
		skincolour = 0
		local width, height = 400, 400
		
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		destroyElement(tabCreationTwo)
		tabCreationTwo = nil
		
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
		tabCreationThree = guiCreateTab("Character Creation: Step 3", tabPanelCreation)
		guiSetAlpha(tabPanelCreation, 0.75)
		
		lTattoos = guiCreateLabel(0.1, 0.025, 0.25, 0.15, "Tattoos", true, tabCreationThree) 
		guiSetFont(lTattoos, "sa-header")
		
		--/////////////
		-- LEFT UPPER ARM
		--/////////////
		lLeftUpperArmInfo = guiCreateLabel(0.87, 0.125, 0.13, 0.15, "1/" .. #leftUpperArmTattoos, true, tabCreationThree)
		guiSetFont(lLeftUpperArmInfo, "default-bold-small")
		
		lLeftUpperArm = guiCreateLabel(0.1, 0.125, 0.25, 0.15, "Left Upper Arm:", true, tabCreationThree)
		guiSetFont(lLeftUpperArm, "default-bold-small")
		
		bLeftUpperPrev =  guiCreateButton(0.4, 0.125, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftUpperPrev, adjustTattoos, false)
		
		bLeftUpperNext =  guiCreateButton(0.65, 0.125, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftUpperNext, adjustTattoos, false)
		
		--/////////////
		-- LEFT LOWER ARM
		--/////////////
		lLeftLowerArmInfo = guiCreateLabel(0.87, 0.18, 0.13, 0.15, "1/" .. #leftLowerArmTattoos, true, tabCreationThree)
		guiSetFont(lLeftLowerArmInfo, "default-bold-small")
		
		lLeftLowerArm = guiCreateLabel(0.1, 0.18, 0.25, 0.15, "Left Lower Arm:", true, tabCreationThree)
		guiSetFont(lLeftLowerArm, "default-bold-small")
		
		bLeftLowerPrev =  guiCreateButton(0.4, 0.18, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftLowerPrev, adjustTattoos, false)
		
		bLeftLowerNext =  guiCreateButton(0.65, 0.18, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftLowerNext, adjustTattoos, false)
		
		--/////////////
		-- RIGHT UPPER ARM
		--/////////////
		lRightUpperArmInfo = guiCreateLabel(0.87, 0.235, 0.13, 0.15, "1/" .. #rightUpperArmTattoos, true, tabCreationThree)
		guiSetFont(lRightUpperArmInfo, "default-bold-small")
		
		lRightUpperArm = guiCreateLabel(0.1, 0.235, 0.25, 0.15, "Right Upper Arm:", true, tabCreationThree)
		guiSetFont(lRightUpperArm, "default-bold-small")
		
		bRightUpperPrev =  guiCreateButton(0.4, 0.235, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightUpperPrev, adjustTattoos, false)
		
		bRightUpperNext =  guiCreateButton(0.65, 0.235, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightUpperNext, adjustTattoos, false)
		
		--/////////////
		-- RIGHT LOWER ARM
		--/////////////
		lRightLowerArmInfo = guiCreateLabel(0.87, 0.29, 0.13, 0.15, "1/" .. #rightLowerArmTattoos, true, tabCreationThree)
		guiSetFont(lRightLowerArmInfo, "default-bold-small")
		
		lRightLowerArm = guiCreateLabel(0.1, 0.29, 0.25, 0.15, "Right Lower Arm:", true, tabCreationThree)
		guiSetFont(lRightLowerArm, "default-bold-small")
		
		bRightLowerPrev =  guiCreateButton(0.4, 0.29, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightLowerPrev, adjustTattoos, false)
		
		bRightLowerNext =  guiCreateButton(0.65, 0.29, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightLowerNext, adjustTattoos, false)
		
		--/////////////
		-- BACK
		--/////////////
		lBackTattooInfo = guiCreateLabel(0.87, 0.345, 0.13, 0.15, "1/" .. #backTattoos, true, tabCreationThree)
		guiSetFont(lBackTattooInfo, "default-bold-small")
		
		lBackTattoo = guiCreateLabel(0.1, 0.345, 0.25, 0.15, "Back:", true, tabCreationThree)
		guiSetFont(lBackTattoo, "default-bold-small")
		
		bBackTattooPrev =  guiCreateButton(0.4, 0.345, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bBackTattooPrev, adjustTattoos, false)
		
		bBackTattooNext =  guiCreateButton(0.65, 0.345, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bBackTattooNext, adjustTattoos, false)
		
		--/////////////
		-- LEFT CHEST
		--/////////////
		lLeftChestInfo = guiCreateLabel(0.87, 0.4, 0.13, 0.15, "1/" .. #leftChestTattoos, true, tabCreationThree)
		guiSetFont(lLeftChestInfo, "default-bold-small")
		
		lLeftChest = guiCreateLabel(0.1, 0.4, 0.25, 0.15, "Left Chest:", true, tabCreationThree)
		guiSetFont(lLeftChest, "default-bold-small")
		
		bLeftChestPrev =  guiCreateButton(0.4, 0.4, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftChestPrev, adjustTattoos, false)
		
		bLeftChestNext =  guiCreateButton(0.65, 0.4, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLeftChestNext, adjustTattoos, false)
		
		--/////////////
		-- RIGHT CHEST
		--/////////////
		lRightChestInfo = guiCreateLabel(0.87, 0.455, 0.13, 0.15, "1/" .. #rightChestTattoos, true, tabCreationThree)
		guiSetFont(lRightChestInfo, "default-bold-small")
		
		lRightChest = guiCreateLabel(0.1, 0.455, 0.25, 0.15, "Right Chest:", true, tabCreationThree)
		guiSetFont(lRightChest, "default-bold-small")
		
		bRightChestPrev =  guiCreateButton(0.4, 0.455, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightChestPrev, adjustTattoos, false)
		
		bRightChestNext =  guiCreateButton(0.65, 0.455, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bRightChestNext, adjustTattoos, false)
		
		--/////////////
		-- STOMACH
		--/////////////
		lStomachInfo = guiCreateLabel(0.87, 0.51, 0.13, 0.15, "1/" .. #stomachTattoos, true, tabCreationThree)
		guiSetFont(lStomachInfo, "default-bold-small")
		
		lStomach = guiCreateLabel(0.1, 0.51, 0.25, 0.15, "Stomach:", true, tabCreationThree)
		guiSetFont(lStomach, "default-bold-small")
		
		bStomachPrev =  guiCreateButton(0.4, 0.51, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bStomachPrev, adjustTattoos, false)
		
		bStomachNext =  guiCreateButton(0.65, 0.51, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bStomachNext, adjustTattoos, false)
		
		--/////////////
		-- LOW BACK
		--/////////////
		lLowerBackInfo = guiCreateLabel(0.87, 0.565, 0.13, 0.15, "1/" .. #lowerBackTattoos, true, tabCreationThree)
		guiSetFont(lLowerBackInfo, "default-bold-small")
		
		lLowBack = guiCreateLabel(0.1, 0.565, 0.25, 0.15, "Lower Back:", true, tabCreationThree)
		guiSetFont(lLowBack, "default-bold-small")
		
		bLowBackPrev =  guiCreateButton(0.4, 0.565, 0.2, 0.05, "<-", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLowBackPrev, adjustTattoos, false)
		
		bLowBackNext =  guiCreateButton(0.65, 0.565, 0.2, 0.05, "->", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bLowBackNext, adjustTattoos, false)
		
		--/////////////
		-- NEXT/BACK
		--/////////////
		bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bNext, characterCreationStep4CJ, false)
		
		bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationThree)
		addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
end

function adjustTattoos(button, state)
	if (button=="left") and (state=="up") then
	
		-- //////////////////////////////////////////////
		-- LEFT UPPER ARM
		-- //////////////////////////////////////////////
		if (source==bLeftUpperNext) then
			if (luTattoo==#leftUpperArmTattoos) then
				luTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			else
				luTattoo = luTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			end
		end
		
		if (source==bLeftUpperPrev) then
			if (luTattoo<=1) then
				luTattoo = #leftUpperArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			else
				luTattoo = luTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftUpperArmTattoos[luTattoo][1],  leftUpperArmTattoos[luTattoo][2], 4)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LEFT LOWER ARM
		-- //////////////////////////////////////////////
		if (source==bLeftLowerNext) then
			if (llTattoo==#leftLowerArmTattoos) then
				llTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			else
				llTattoo = llTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			end
		end
		
		if (source==bLeftLowerPrev) then
			if (llTattoo<=1) then
				llTattoo = #leftLowerArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			else
				llTattoo = llTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftLowerArmTattoos[llTattoo][1],  leftLowerArmTattoos[llTattoo][2], 5)
			end
		end
		
		-- //////////////////////////////////////////////
		-- RIGHT UPPER ARM
		-- //////////////////////////////////////////////
		if (source==bRightUpperNext) then
			if (ruTattoo==#rightUpperArmTattoos) then
				ruTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			else
				ruTattoo = ruTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			end
		end
		
		if (source==bRightUpperPrev) then
			if (ruTattoo<=1) then
				ruTattoo = #rightUpperArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			else
				ruTattoo = ruTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightUpperArmTattoos[ruTattoo][1],  rightUpperArmTattoos[ruTattoo][2], 6)
			end
		end
		
		-- //////////////////////////////////////////////
		-- RIGHT LOWER ARM
		-- //////////////////////////////////////////////
		if (source==bRightLowerNext) then
			if (rlTattoo==#rightLowerArmTattoos) then
				rlTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			else
				rlTattoo = rlTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			end
		end
		
		if (source==bRightLowerPrev) then
			if (rlTattoo<=1) then
				rlTattoo = #rightLowerArmTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			else
				rlTattoo = rlTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightLowerArmTattoos[rlTattoo][1],  rightLowerArmTattoos[rlTattoo][2], 7)
			end
		end
		
		-- //////////////////////////////////////////////
		-- BACK
		-- //////////////////////////////////////////////
		if (source==bBackTattooNext) then
			if (bTattoo==#backTattoos) then
				bTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), backTattoos[bTattoo][1], backTattoos[bTattoo][2], 8)
			else
				bTattoo = bTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), backTattoos[bTattoo][1],  backTattoos[bTattoo][2], 8)
			end
		end
		
		if (source==bBackTattooPrev) then
			if (bTattoo<=1) then
				bTattoo = #backTattoos
				triggerServerEvent("addClothes", getLocalPlayer(),backTattoos[bTattoo][1],  backTattoos[bTattoo][2], 8)
			else
				bTattoo = bTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), backTattoos[bTattoo][1],  backTattoos[bTattoo][2], 8)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LEFT CHEST
		-- //////////////////////////////////////////////
		if (source==bLeftChestNext) then
			if (lcTattoo==#leftChestTattoos) then
				lcTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			else
				lcTattoo = lcTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			end
		end
		
		if (source==bLeftChestPrev) then
			if (lcTattoo<=1) then
				lcTattoo = #leftChestTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			else
				lcTattoo = lcTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), leftChestTattoos[lcTattoo][1], leftChestTattoos[lcTattoo][2], 9)
			end
		end
		
		-- //////////////////////////////////////////////
		-- RIGHT CHEST
		-- //////////////////////////////////////////////
		if (source==bRightChestNext) then
			if (rcTattoo==#rightChestTattoos) then
				rcTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			else
				rcTattoo = rcTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			end
		end
		
		if (source==bRightChestPrev) then
			if (rcTattoo<=1) then
				rcTattoo = #rightChestTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			else
				rcTattoo = rcTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), rightChestTattoos[rcTattoo][1], rightChestTattoos[rcTattoo][2], 10)
			end
		end
		
		-- //////////////////////////////////////////////
		-- STOMACH
		-- //////////////////////////////////////////////
		if (source==bStomachNext) then
			if (sTattoo==#stomachTattoos) then
				sTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1], stomachTattoos[sTattoo][2], 11)
			else
				sTattoo = sTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1],  stomachTattoos[sTattoo][2], 11)
			end
		end
		
		if (source==bStomachPrev) then
			if (sTattoo<=1) then
				sTattoo = #stomachTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1],  stomachTattoos[sTattoo][2], 11)
			else
				sTattoo = sTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), stomachTattoos[sTattoo][1],  stomachTattoos[sTattoo][2], 11)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LOWER BACK
		-- //////////////////////////////////////////////
		if (source==bLowBackNext) then
			if (lbTattoo==#lowerBackTattoos) then
				lbTattoo = 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			else
				lbTattoo = lbTattoo + 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			end
		end
		
		if (source==bLowBackPrev) then
			if (lbTattoo<=1) then
				lbTattoo = #lowerBackTattoos
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			else
				lbTattoo = lbTattoo - 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerBackTattoos[lbTattoo][1], lowerBackTattoos[lbTattoo][2], 12)
			end
		end
		
		guiSetText(lLeftUpperArmInfo, luTattoo .. "/" .. #leftUpperArmTattoos)
		guiSetText(lLeftLowerArmInfo, llTattoo .. "/" .. #leftLowerArmTattoos)
		guiSetText(lRightUpperArmInfo, ruTattoo .. "/" .. #rightUpperArmTattoos)
		guiSetText(lRightLowerArmInfo, rlTattoo .. "/" .. #rightLowerArmTattoos)
		guiSetText(lBackTattooInfo, bTattoo .. "/" .. #backTattoos)
		guiSetText(lLeftChestInfo, lcTattoo .. "/" .. #leftChestTattoos)
		guiSetText(lRightChestInfo, rcTattoo .. "/" .. #rightChestTattoos)
		guiSetText(lStomachInfo, sTattoo .. "/" .. #stomachTattoos)
		guiSetText(lLowerBackInfo, lbTattoo .. "/" .. #lowerBackTattoos)
	end
end

-- /////////////////////////
-- CJ STEP 4
-- /////////////////////////
hair = { {"player_face", "head"}, {"hairblond", "head"}, {"hairred", "head"}, {"hairblue", "head"}, {"hairgreen", "head"}, {"hairpink", "head"}, {"bald", "head"}, {"baldbeard", "head"}, {"baldtash", "head"}, {"baldgoatee", "head"}, {"highfade", "head"}, {"highafro", "highafro"}, {"wedge", "wedge"}, {"slope", "slope"}, {"jhericurl", "jheri"}, {"cornrows", "cornrows"}, {"cornrowsb", "cornrows"}, {"tramline", "tramline"}, {"groovecut", "groovecut"}, {"mohawk", "mohawk"}, {"mohawkblond", "mohawk"}, {"mohawkpink", "mohawk"}, {"mohawkbeard", "mohawk"}, {"afro", "afro"}, {"afrotash", "afro"}, {"afrobeard", "afro"}, {"afroblond", "afro"}, {"flattop", "flattop"}, {"elvishair", "elvishair"}, {"beard", "head"}, {"tash", "head"}, {"goatee", "head"}, {"afrogoatee", "afro"} }
hats = { {"NONE", "NONE"}, {"bandred", "bandana"}, {"bandblue", "bandana"}, {"bandgang", "bandana"}, {"bandblack", "bandana"}, {"bandred2", "bandknots"}, {"bandblue2", "bandknots"}, {"bandblack2", "bandknots"}, {"bandgang2", "bandknots"}, {"capknitgrn", "capknit"}, {"captruck", "captruck"}, {"cowboy", "cowboy"}, {"hattiger", "cowboy"}, {"helmet", "helmet"}, {"moto", "moto"}, {"boxingcap", "boxingcap"}, {"hockey", "hockeymask"}, {"capgang", "cap"}, {"capgangback", "capblack"}, {"capgangside", "capside"}, {"capgangover", "capovereye"}, {"capgangup", "caprimup"}, {"bikerhelmet", "bikerhelmet"}, {"capred", "cap"}, {"capredback", "capback"}, {"capredside", "capside"}, {"capredover", "capovereye"}, {"capredup", "caprimup"}, {"capblue", "cap"}, {"capblueback", "capback"}, {"capblueside", "capside"}, {"capblueover", "capovereye"}, {"capblueup", "caprimup"}, {"skullyblk", "scullycap"}, {"skullygrn", "skullycap"}, {"hatmancblk", "hatmanc"}, {"hatmancplaid", "hatmanc"}, {"capzip", "cap"}, {"capzipback", "capback"}, {"capzipside", "capside"}, {"capzipover", "capovereye"}, {"capzipup", "caprimup"}, {"beretred", "beret"}, {"beretblk", "beret"}, {"capblk", "cap"}, {"capblkback", "capback"}, {"capblkside", "capside"}, {"capblkeover", "capovereye"}, {"capblkup", "caprimup"}, {"trilbydrk", "trilby"}, {"trilbylght", "trilby"}, {"bowler", "bowler"}, {"bolwerred", "bowlerred"}, {"bowlerblue", "bowler"}, {"bowleryellow", "bowler"}, {"boater", "boater"}, {"bowlergang", "bowler"}, {"boaterblk", "boater"} }
necks = { {"NONE", "NONE"}, {"dogtag", "neck"}, {"neckafrica", "neck"}, {"stopwatch", "neck"}, {"necksaints", "neck"}, {"neckhash", "neck"}, {"necksilver", "neck2"}, {"neckgold", "neck2"}, {"neckropes", "neck2"}, {"neckropg", "neck2"}, {"neckls", "neck2"}, {"neckdollar", "neck2"}, {"neckcross", "neck2"} }
faces = { {"NONE", "NONE"}, {"groucho", "grouchos"}, {"zorro", "zorromask"}, {"eyepatch", "glasses01"}, {"glasses04", "glasses04"}, {"bandred3", "bandmask"}, {"bandblue3", "bandmask"}, {"bandgang3", "bandmask"}, {"bandblack3", "bandmask"}, {"glasses01dark", "glasses01"}, {"glasses04dark", "glasses04"}, {"glasses03", "glasses03"}, {"glasses03red", "glasses03"}, {"glasses03blue", "glasses03"}, {"glasses03dark", "glasses03"}, {"glasses05dark", "glasses03"}, {"glasses05", "glasses03"} }
upperbody = { {"torso", "player_torso"}, {"vestblack", "vest"}, {"vest", "vest"}, {"tshirt2horiz", "tshirt2"}, {"tshirtwhite", "tshirt"}, {"tshirtlovels", "tshirt"}, {"tshirtblunts", "tshirt"}, {"shirtbplaid", "shirtb"}, {"shirtbcheck", "shirtb"}, {"field", "field"}, {"tshirterisyell", "tshirt"}, {"tshirterisorn", "tshirt"}, {"trackytop2eris", "trackytop2"}, {"bbjackrim", "bbjack"}, {"bbjackrstar", "bbjack"}, {"baskballdrib", "basjball"}, {"sixtyniners", "tshirt"}, {"bandits", "baseball"}, {"tshirtprored", "tshirt"}, {"tshirtproblk", "tshirt"}, {"trackytop1pro", "trackytop1"}, {"hockeytop", "sweat"}, {"bbjersey", "sleevt"}, {"shellsuit", "trackytop1"}, {"tshirtheatwht", "tshirt"}, {"tshirtbobomonk", "tshirt"}, {"tshirtbobored", "tshirt"}, {"tshirtbase5", "tshirt"}, {"tshirtsuburb", "tshirt"}, {"hoodyamerc", "hoodya"}, {"hoodyabase5", "hoodya"}, {"hoodayarockstar", "hoodya"}, {"wcoatblue", "wcoat"}, {"coach", "coach"}, {"coachsemi", "coach"}, {"sweatrstar", "sweat"}, {"hoodyAblue", "hoodyA"}, {"hoodyAblack", "hoodyA"}, {"hoodyAgreen", "hoodyA"}, {"sleevtbrown", "sleevt"}, {"shirtablue", "shirta"}, {"shirtayellow", "shirta"}, {"shirtagrey", "shirta"}, {"shirtbgang", "shirtb"}, {"tshirtzipcrm", "tshirt"}, {"tshirtzipgry", "tshirt"}, {"denimfade", "denim"}, {"bowling", "hawaii"}, {"hoodjackbeige", "hoodjack"}, {"baskballoc", "baskball"}, {"tshirtlocgrey", "tshirt"}, {"tshirtmaddgrey", "tshirt"}, {"tshirtmaddgrn", "tshirt"}, {"suit1grey", "suit1"}, {"suit1blk", "suit1"}, {"leather", "leather"}, {"painter", "painter"}, {"hawaiiwht", "hawaii"}, {"hawaiired", "hawaii"}, {"sportjack", "trackytop1"}, {"suit1red", "suit1"}, {"suit1blue", "suit1"}, {"suit1yellow", "suit1"}, {"suit2grn", "suit2"}, {"tuxedo", "suit2"}, {"suit1gang", "suit1"}, {"letter", "sleevt"} }
wrists = { {"NONE", "NONE"}, {"watchpink", "watch"}, {"watchyellow", "watch"}, {"watchpro", "watch"}, {"watchpro2", "watch"}, {"watchsub1", "watch"}, {"watchsub2", "watch"}, {"watchzip1", "watch"}, {"watchzip2", "watch"}, {"watchgno", "watch"}, {"watchgno2", "watch"}, {"watchcro", "watch"}, {"watchcro2", "watch"} }
lowerbody = { {"player_legs", "legs"}, {"worktrcamogrn", "worktr"}, {"worktrcamogry", "worktr"}, {"worktrgrey", "worktr"}, {"worktrhaki", "worktr"}, {"tracktr", "tracktr"}, {"trackteris", "tracktr"}, {"jeansdenim", "jeans"}, {"legsblack", "legs"}, {"legsheart", "legs"}, {"beiegetr", "chinosb"}, {"trackpro", "tracktr"}, {"tracktrwhstr", "tracktr"}, {"tracktrblue", "tracktr"}, {"tracktrgang", "tracktr"}, {"bbshortwht", "boxingshort"}, {"bbshortred", "boxingshort"}, {"shellsuittr", "tracktr"}, {"shortsgrey", "shorts"}, {"shortskhaki", "shorts"}, {"chongergrey", "chonger"}, {"chongergang", "chonger"}, {"chongerred", "chonger"}, {"chongerblue", "chonger"}, {"shortsgang", "shorts"}, {"denimsgang", "jeans"}, {"denimsred", "jeans"}, {"chinosbiege", "chinosb"}, {"chinoskhaki", "chinosb"}, {"cutoffchinos", "shorts"}, {"cutoffchinesblue", "shorts"}, {"chinosblack", "chinosb"}, {"chinosblue", "chinosb"}, {"leathertr", "leathertr"}, {"leathertrchaps", "leathertr"}, {"suit1trgrey", "suit1tr"}, {"suit1trblk", "suit1tr"}, {"cutoffdenims", "shorts"}, {"suit1trred", "suit1tr"}, {"suit1trblue", "suit1tr"}, {"suit1tryellow", "suit1tr"}, {"suit1trgreen", "suit1tr"}, {"suit1trblk2", "suit1tr"}, {"suit1trgang", "suit1tr"} }
feet = { {"foot", "feet"}, {"cowboyboot2", "biker"}, {"bask2semi", "bask1"}, {"bask1eris", "bask1"}, {"sneakerbincgang", "sneaker"}, {"sneakerbincblue", "sneakers"}, {"sneakerbincblk", "sneaker"}, {"sandal", "flipflop"}, {"sandalsock", "flipflop"}, {"flipflop", "flipflop"}, {"hitop", "bask1"}, {"convproblk", "conv"}, {"convproblu", "conv"}, {"convprogrn", "conv"}, {"sneakerprored", "sneaker"}, {"sneakerproblu", "sneakers"}, {"sneakerprowht", "sneaker"}, {"bask1prowht", "bask1"}, {"bask1problk", "bask1"}, {"boxingshoe", "biker"}, {"convheatblk", "conv"}, {"convheatred", "conv"}, {"convheatorn", "conv"}, {"sneakerheatwht", "sneaker"}, {"sneakerheatgry", "sneaker"}, {"sneakerheatblk", "sneaker"}, {"bask2heatwht", "bask1"}, {"bask2headband", "bask1"}, {"timbergrey", "back1t"}, {"timberred", "bask1"}, {"timberfawn", "bask1"}, {"timberhike", "bask1"}, {"cowboyboot", "biker"}, {"biker", "biker"}, {"snakeskin", "biker"}, {"shoedressblk", "shoe"}, {"shoedressbrn", "shoe"}, {"shoespatz", "shoe"} } 
costumes = { {"NONE", "NONE"}, {"valet", "valet"}, {"countrytr", "countrytr"}, {"croupier", "valet"}, {"pimptr", "pimptr"} }

lAppearance, lHair, lHairInfo, bHairPrev, bHairNext, lHat, lHatInfo, bHatPrev, bHatNext, lNeck, lNeckInfo, bNeckPrev, bNeckNext, lFace, lFaceInfo, bFacePrev, bFaceNext, lUpperBody, lUpperBodyInfo, bUpperBodyPrev, bUpperBodyNext, lWrists, lWristsInfo, bWristsPrev, bWristsNext, lLowerBody, lLowerBodyInfo, bLowerBodyPrev, bLowerBodyNext, lFeet, lFeetInfo, bFeetPrev, bFeetNext, lCostumes, lCostumesInfo, bCostumesPrev, bCostumesNext = nil

curhair = 1
curhat = 1
curneck = 1
curface = 1
curupper = 1
curwrist = 1
curlower = 1
curfeet = 1
curcostume = 1

function characterCreationStep4CJ(button, state)
	if (source==bNext) and (button=="left") and (state=="up") then
		-- Cleanup
		destroyElement(tabCreationThree)
		tabCreationThree = nil
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		curhair = 1
		curhat = 1
		curneck = 1
		curface = 1
		curupper = 1
		curwrist = 1
		curlower = 1
		curfeet = 1
		curcostume = 1
		
		local width, height = 400, 400
		
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
		tabCreationFour = guiCreateTab("Character Creation: Step 4", tabPanelCreation)
		guiSetAlpha(tabPanelCreation, 0.75)
		
		lAppearance = guiCreateLabel(0.1, 0.025, 0.8, 0.15, "Appearance", true, tabCreationFour) 
		guiSetFont(lAppearance, "sa-header")
		
		--/////////////
		-- HAIR
		--/////////////
		lHairInfo = guiCreateLabel(0.87, 0.125, 0.13, 0.15, "1/" .. #hair, true, tabCreationFour)
		guiSetFont(lHairInfo, "default-bold-small")
		
		lHair = guiCreateLabel(0.1, 0.125, 0.25, 0.15, "Hair:", true, tabCreationFour)
		guiSetFont(lHair, "default-bold-small")
		
		bHairPrev =  guiCreateButton(0.4, 0.125, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHairPrev, adjustClothes, false)
		
		bHairNext =  guiCreateButton(0.65, 0.125, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHairNext, adjustClothes, false)
		
		--/////////////
		-- HATS
		--/////////////
		lHatInfo = guiCreateLabel(0.87, 0.18, 0.13, 0.15, "1/" .. #hats, true, tabCreationFour)
		guiSetFont(lHatInfo, "default-bold-small")
		
		lHat = guiCreateLabel(0.1, 0.18, 0.25, 0.15, "Hat:", true, tabCreationFour)
		guiSetFont(lHat, "default-bold-small")
		
		bHatPrev =  guiCreateButton(0.4, 0.18, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHatPrev, adjustClothes, false)
		
		bHatNext =  guiCreateButton(0.65, 0.18, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bHatNext, adjustClothes, false)
		
		--/////////////
		-- NECK
		--/////////////
		lNeckInfo = guiCreateLabel(0.87, 0.235, 0.13, 0.15, "1/" .. #necks, true, tabCreationFour)
		guiSetFont(lNeckInfo, "default-bold-small")
		
		lNeck = guiCreateLabel(0.1, 0.235, 0.25, 0.15, "Neck:", true, tabCreationFour)
		guiSetFont(lNeck, "default-bold-small")
		
		bNeckPrev =  guiCreateButton(0.4, 0.235, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bNeckPrev, adjustClothes)
		
		bNeckNext =  guiCreateButton(0.65, 0.235, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bNeckNext, adjustClothes)
		
		--/////////////
		-- FACE
		--/////////////
		lFaceInfo = guiCreateLabel(0.87, 0.29, 0.13, 0.15, "1/" .. #faces, true, tabCreationFour)
		guiSetFont(lFaceInfo, "default-bold-small")
		
		lFace = guiCreateLabel(0.1, 0.29, 0.25, 0.15, "Face:", true, tabCreationFour)
		guiSetFont(lFace, "default-bold-small")
		
		bFacePrev =  guiCreateButton(0.4, 0.29, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFacePrev, adjustClothes, false)
		
		bFaceNext =  guiCreateButton(0.65, 0.29, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFaceNext, adjustClothes, false)
		
		--/////////////
		-- UPPER BODY
		--/////////////
		lUpperBodyInfo = guiCreateLabel(0.87, 0.345, 0.13, 0.15, "1/" .. #upperbody, true, tabCreationFour)
		guiSetFont(lUpperBodyInfo, "default-bold-small")
		
		lUpperBody = guiCreateLabel(0.1, 0.345, 0.25, 0.15, "Upper Body:", true, tabCreationFour)
		guiSetFont(lUpperBody, "default-bold-small")
		
		bUpperBodyPrev =  guiCreateButton(0.4, 0.345, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bUpperBodyPrev, adjustClothes)
		
		bUpperBodyNext =  guiCreateButton(0.65, 0.345, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bUpperBodyNext, adjustClothes)
		
		--/////////////
		-- WRISTS
		--/////////////
		lWristsInfo = guiCreateLabel(0.87, 0.4, 0.13, 0.15, "1/" .. #wrists, true, tabCreationFour)
		guiSetFont(lWristsInfo, "default-bold-small")
		
		lWrists = guiCreateLabel(0.1, 0.4, 0.25, 0.15, "Wrists:", true, tabCreationFour)
		guiSetFont(lWrists, "default-bold-small")
		
		bWristsPrev =  guiCreateButton(0.4, 0.4, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bWristsPrev, adjustClothes, false)
		
		bWristsNext =  guiCreateButton(0.65, 0.4, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bWristsNext, adjustClothes, false)
		
		--/////////////
		-- LOWER BODY
		--/////////////
		lLowerBodyInfo = guiCreateLabel(0.87, 0.455, 0.13, 0.15, "1/" .. #lowerbody, true, tabCreationFour)
		guiSetFont(lLowerBodyInfo, "default-bold-small")
		
		lLowerBody = guiCreateLabel(0.1, 0.455, 0.25, 0.15, "Lower Body:", true, tabCreationFour)
		guiSetFont(lLowerBody, "default-bold-small")
		
		bLowerBodyPrev =  guiCreateButton(0.4, 0.455, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bLowerBodyPrev, adjustClothes, false)
		
		bLowerBodyNext =  guiCreateButton(0.65, 0.455, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bLowerBodyNext, adjustClothes, false)
		
		--/////////////
		-- FEET
		--/////////////
		lFeetInfo = guiCreateLabel(0.87, 0.51, 0.13, 0.15, "1/" .. #feet, true, tabCreationFour)
		guiSetFont(lFeetInfo, "default-bold-small")
		
		lFeet = guiCreateLabel(0.1, 0.51, 0.25, 0.15, "Feet:", true, tabCreationFour)
		guiSetFont(lFeet, "default-bold-small")
		
		bFeetPrev =  guiCreateButton(0.4, 0.51, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFeetPrev, adjustClothes, false)
		
		bFeetNext =  guiCreateButton(0.65, 0.51, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bFeetNext, adjustClothes, false)
		
		--/////////////
		-- COSTUMES
		--/////////////
		lCostumesInfo = guiCreateLabel(0.87, 0.565, 0.13, 0.15, "1/" .. #costumes, true, tabCreationFour)
		guiSetFont(lCostumesInfo, "default-bold-small")
		
		lCostumes = guiCreateLabel(0.1, 0.565, 0.25, 0.15, "Costumes:", true, tabCreationFour)
		guiSetFont(lCostumes, "default-bold-small")
		
		bCostumesPrev =  guiCreateButton(0.4, 0.565, 0.2, 0.05, "<-", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bCostumesPrev, adjustClothes, false)
		
		bCostumesNext =  guiCreateButton(0.65, 0.565, 0.2, 0.05, "->", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bCostumesNext, adjustClothes, false)
		
		--/////////////
		-- NEXT/BACK
		--/////////////
		bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bNext, characterCreationStep5, false)
		
		bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationFour)
		addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
	end
end

function adjustClothes(button, state)
	if (button=="left") and (state=="up") then
	
		-- //////////////////////////////////////////////
		-- HAIR
		-- //////////////////////////////////////////////
		if (source==bHairNext) then
			if (curhair==#hair) then
				curhair = 1
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			else
				curhair = curhair + 1
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			end
		end
		
		if (source==bHairPrev) then
			if (curhair<=1) then
				curhair = #hair
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			else
				curhair = curhair - 1
				triggerServerEvent("addClothes", getLocalPlayer(), hair[curhair][1],  hair[curhair][2], 1)
			end
		end
		
		-- //////////////////////////////////////////////
		-- HATS
		-- //////////////////////////////////////////////
		if (source==bHatNext) then
			if (curhat==#hats) then
				curhat = 1
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			else
				curhat = curhat + 1
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			end
		end
		
		if (source==bHatPrev) then
			if (curhat<=1) then
				curhat = #hats
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			else
				curhat = curhat - 1
				triggerServerEvent("addClothes", getLocalPlayer(), hats[curhat][1],  hats[curhat][2], 16)
			end
		end
		
		-- //////////////////////////////////////////////
		-- NECK
		-- //////////////////////////////////////////////
		if (source==bNeckNext) then
			if (curneck==#necks) then
				curneck = 1
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			else
				curneck = curneck + 1
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			end
		end
		
		if (source==bNeckPrev) then
			if (curneck<=1) then
				curneck = #necks
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			else
				curneck = curneck - 1
				triggerServerEvent("addClothes", getLocalPlayer(), necks[curneck][1],  necks[curneck][2], 13)
			end
		end
		
		-- //////////////////////////////////////////////
		-- FACE
		-- //////////////////////////////////////////////
		if (source==bFaceNext) then
			if (curface==#faces) then
				curface = 1
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			else
				curface = curface + 1
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			end
		end
		
		if (source==bFacePrev) then
			if (curface<=1) then
				curface = #faces
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			else
				curface = curface - 1
				triggerServerEvent("addClothes", getLocalPlayer(), faces[curface][1],  faces[curface][2], 15)
			end
		end
		
		-- //////////////////////////////////////////////
		-- UPPER
		-- //////////////////////////////////////////////
		if (source==bUpperBodyNext) then
			if (curupper==#upperbody) then
				curupper = 1
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			else
				curupper = curupper + 1
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			end
		end
		
		if (source==bUpperBodyPrev) then
			if (curupper<=1) then
				curupper = #upperbody
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			else
				curupper = curupper - 1
				triggerServerEvent("addClothes", getLocalPlayer(), upperbody[curupper][1],  upperbody[curupper][2], 0)
			end
		end
		
		-- //////////////////////////////////////////////
		-- WRISTS
		-- //////////////////////////////////////////////
		if (source==bWristsNext) then
			if (curwrist==#wrists) then
				curwrist = 1
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			else
				curwrist = curwrist + 1
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			end
		end
		
		if (source==bWristsPrev) then
			if (curwrist<=1) then
				curwrist = #wrists
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			else
				curwrist = curwrist - 1
				triggerServerEvent("addClothes", getLocalPlayer(), wrists[curwrist][1],  wrists[curwrist][2], 14)
			end
		end
		
		-- //////////////////////////////////////////////
		-- LOWER
		-- //////////////////////////////////////////////
		if (source==bLowerBodyNext) then
			if (curlower==#lowerbody) then
				curlower = 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			else
				curlower = curlower + 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			end
		end
		
		if (source==bLowerBodyPrev) then
			if (curlower<=1) then
				curlower = #lowerbody
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			else
				curlower = curlower - 1
				triggerServerEvent("addClothes", getLocalPlayer(), lowerbody[curlower][1],  lowerbody[curlower][2], 2)
			end
		end
		
		-- //////////////////////////////////////////////
		-- FEET
		-- //////////////////////////////////////////////
		if (source==bFeetNext) then
			if (curfeet==#feet) then
				curfeet = 1
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			else
				curfeet = curfeet + 1
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			end
		end
		
		if (source==bFeetPrev) then
			if (curfeet<=1) then
				curfeet = #feet
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			else
				curfeet = curfeet - 1
				triggerServerEvent("addClothes", getLocalPlayer(), feet[curfeet][1],  feet[curfeet][2], 3)
			end
		end
		
		-- //////////////////////////////////////////////
		-- COSTUME
		-- //////////////////////////////////////////////
		if (source==bCostumesNext) then
			if (curcostume==#costumes) then
				curcostume = 1
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			else
				curcostume = curcostume + 1
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			end
		end
		
		if (source==bCostumesPrev) then
			if (curcostume<=1) then
				curcostume = #costumes
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			else
				curcostume = curcostume - 1
				triggerServerEvent("addClothes", getLocalPlayer(), costumes[curcostume][1],  costumes[curcostume][2], 17)
			end
		end
		
		guiSetText(lHairInfo, curhair .. "/" .. #hair)
		guiSetText(lHatInfo, curhat .. "/" .. #hats)
		guiSetText(lNeckInfo, curneck .. "/" .. #necks)
		guiSetText(lFaceInfo, curface .. "/" .. #faces)
		guiSetText(lUpperBodyInfo, curupper .. "/" .. #upperbody)
		guiSetText(lWristsInfo, curwrist .. "/" .. #wrists)
		guiSetText(lLowerBodyInfo, curlower .. "/" .. #lowerbody)
		guiSetText(lFeetInfo, curfeet .. "/" .. #feet)
		guiSetText(lCostumesInfo, curcostume .. "/" .. #costumes)
	end
end

-- ///////////////////////
-- CJ STEP 5
-- ///////////////////////
lInformation, lHeight, tHeight, lWeight, tWeight, lCharDesc, tCharDesc, lAge, tAge = nil
weight, height, description = "", "", ""
age = 24
]]--

function characterCreationStep5(button, state)
	if (button=="left") and (state=="up") and (source==bNext) then
		-- Cleanup
		if (tabCreationFour) then
			destroyElement(tabCreationFour)
			tabCreationFour = nil
		elseif (tabCreationTwo) then
			destroyElement(tabCreationTwo)
			tabCreationTwo = nil
		end
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		
		local width, height = 400, 400
		
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
		tabCreationFive = guiCreateTab("Character Creation: Almost Done!", tabPanelCreation)
		guiSetAlpha(tabPanelCreation, 0.75)
		
		lInformation = guiCreateLabel(0.1, 0.025, 0.8, 0.15, "Information", true, tabCreationFive) 
		guiSetFont(lInformation, "sa-header")
		
		--/////////////
		-- HEIGHT
		--/////////////
		lHeight = guiCreateLabel(0.1, 0.145, 0.5, 0.15, "Height (cm)(between 100 and 200):", true, tabCreationFive)
		guiSetFont(lHeight, "default-bold-small")
		guiLabelSetColor(lHeight, 0, 255, 0)
		
		tHeight = guiCreateEdit(0.635, 0.143, 0.15, 0.05, "170", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tHeight, checkInput)
		
		--/////////////
		-- WEIGHT
		--/////////////
		lWeight = guiCreateLabel(0.1, 0.215, 0.5, 0.15, "Weight (kg)(between 40 and 200):", true, tabCreationFive)
		guiSetFont(lWeight, "default-bold-small")
		guiLabelSetColor(lWeight, 0, 255, 0)
		
		tWeight = guiCreateEdit(0.635, 0.213, 0.15, 0.05, "70", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tWeight, checkInput)
		
		--/////////////
		-- AGE
		--/////////////
		lAge = guiCreateLabel(0.1, 0.285, 0.5, 0.15, "Age (between 18 and 80):", true, tabCreationFive)
		guiSetFont(lAge, "default-bold-small")
		guiLabelSetColor(lAge, 0, 255, 0)
		
		tAge = guiCreateEdit(0.635, 0.283, 0.15, 0.05, "24", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tAge, checkInput)
		
		--/////////////
		-- DESCRIPTION
		--/////////////
		lCharDesc = guiCreateLabel(0.1, 0.385, 0.8, 0.15, "Description(between 30 and 100 characters):", true, tabCreationFive)
		guiSetFont(lCharDesc, "default-bold-small")
		guiLabelSetColor(lCharDesc, 0, 255, 0)
		
		tCharDesc = guiCreateMemo(0.1, 0.455, 0.8, 0.25, "A description of your character and his/her visual appearance. Other players can see this.", true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tCharDesc, checkInput)
		
		--/////////////
		-- NEXT/BACK
		--/////////////
		bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Next", true, tabCreationFive)
		addEventHandler("onClientGUIClick", bNext, characterCreationStep6, false)
		
		bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationFive)
		addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
	end
end

heightvalid = true 
weightvalid = true
descvalid = true
agevalid = true
function checkInput()
	if (source==tHeight) then
		if not (tostring(type(tonumber(guiGetText(tHeight)))) == "number") then
			guiLabelSetColor(lHeight, 255, 0, 0)
			heightvalid = false
		elseif (tonumber(guiGetText(tHeight))<100) or (tonumber(guiGetText(tHeight))>200) then
			guiLabelSetColor(lHeight, 255, 0, 0)
			heightvalid = false
		else
			guiLabelSetColor(lHeight, 0, 255, 0)
			heightvalid = true
		end
	elseif (source==tWeight) then
		if not (tostring(type(tonumber(guiGetText(tWeight)))) == "number") then
			guiLabelSetColor(lWeight, 255, 0, 0)
			weightvalid = false
		elseif (tonumber(guiGetText(tWeight))<40) or (tonumber(guiGetText(tWeight))>200) then
			guiLabelSetColor(lWeight, 255, 0, 0)
			weightvalid = false
		else
			guiLabelSetColor(lWeight, 0, 255, 0)
			weightvalid = true
		end
	elseif (source==tAge) then
		if not (tostring(type(tonumber(guiGetText(tAge)))) == "number") then
			guiLabelSetColor(lAge, 255, 0, 0)
			agevalid = false
		elseif (tonumber(guiGetText(tAge))<18) or (tonumber(guiGetText(tAge))>80) then
			guiLabelSetColor(lAge, 255, 0, 0)
			agevalid = false
		else
			guiLabelSetColor(lAge, 0, 255, 0)
			agevalid = true
		end
	elseif (source==tCharDesc) then
		if (string.len(guiGetText(tCharDesc))<30) or (string.len(guiGetText(tCharDesc))>100) then
			guiLabelSetColor(lCharDesc, 255, 0, 0)
			descvalid = false
		else
			guiLabelSetColor(lCharDesc, 0, 255, 0)
			descvalid = true
		end
	end
end

tabCreationFive, lTransport, rTrain, rBus, rAeroplane, rBoat, transObject, transVehicle, lastSelected, anim = nil
language = 1
function characterCreationStep6(button, state)
	if (button=="left") and (state=="up") and (source==bNext) then
		if (heightvalid) and (weightvalid) and (descvalid) and (agevalid) then
			height = guiGetText(tHeight)
			weight = guiGetText(tWeight)
			age = guiGetText(tAge)
			description = guiGetText(tCharDesc)
		
			-- Cleanup
			destroyElement(tabCreationFive)
			tabCreationFive = nil
			destroyElement(tabPanelCreation)
			tabPanelCreation = nil
			
			local width, height = 400, 400
			
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)

			tabPanelCreation = guiCreateTabPanel(5, y, width, height, false)
			tabCreationSix = guiCreateTab("Character Creation: Last Page!", tabPanelCreation)
			guiSetAlpha(tabPanelCreation, 0.75)
			
			lInformation = guiCreateLabel(0.1, 0.025, 0.8, 0.15, "Just a little more...", true, tabCreationSix) 
			guiSetFont(lInformation, "sa-header")
			
			--/////////////
			-- TRANSPORT
			--/////////////
			lTransport = guiCreateLabel(0.1, 0.145, 0.8, 0.15, "Transport - How did you arrive in Los Santos?", true, tabCreationSix)
			guiSetFont(lTransport, "default-bold-small")
			
			rAeroplane = guiCreateRadioButton(0.15, 0.2, 0.6, 0.05, "Aeroplane", true, tabCreationSix)
			rBus = guiCreateRadioButton(0.15, 0.25, 0.6, 0.05, "Bus", true, tabCreationSix)
			
			addEventHandler("onClientGUIClick", rBus, busEffect, false)
			addEventHandler("onClientGUIClick", rAeroplane, aeroplaneEffect, false)
			
			lLanguage = guiCreateLabel(0.1, 0.45, 0.8, 0.15, "What is your Character's mother tongue?", true, tabCreationSix)
			guiSetFont(lLanguage, "default-bold-small")
			
			lCharLanguage = guiCreateLabel(0.3, 0.52, 0.2, 0.05, "English", true, tabCreationSix)
			guiLabelSetHorizontalAlign( lCharLanguage, "center" )
			language = 1
			
			lLangPrevious = guiCreateButton(0.23, 0.51, 0.07, 0.07, "<-", true, tabCreationSix)
			lLangNext = guiCreateButton(0.5, 0.51, 0.07, 0.07, "->", true, tabCreationSix)
			
			addEventHandler("onClientGUIClick", lLangPrevious,
				function( button, state )
					if button == "left" and state == "up" then
						if language == 1 then
							language = call( getResourceFromName( "language-system" ), "getLanguageCount" )
						else
							language = language - 1
						end
						guiSetText(lCharLanguage, call( getResourceFromName( "language-system" ), "getLanguageName", language ))
					end
				end, false
			)
			
			addEventHandler("onClientGUIClick", lLangNext,
				function( button, state )
					if button == "left" and state == "up" then
						if language == call( getResourceFromName( "language-system" ), "getLanguageCount" ) then
							language = 1
						else
							language = language + 1
						end
						guiSetText(lCharLanguage, call( getResourceFromName( "language-system" ), "getLanguageName", language ))
					end
				end, false
			)

			--/////////////
			-- NEXT/BACK
			--/////////////
			bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "That's it, Were Done!", true, tabCreationSix)
			addEventHandler("onClientGUIClick", bNext, characterCreationFinal, false)
			
			bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationSix)
			addEventHandler("onClientGUIClick", bCancel, cancelCreation, false)
		end
	end
end

--/////////////////////
-- BUS EFFECT
--/////////////////////
function busEffect(button, state)
	if (source==rBus) and (button=="left") and (state=="up") and not (lastSelected==rBus) and not (anim) then
		lastSelected = source -- Avoid duplicates
		fadeCamera(false, 1, 0, 0, 0)
		setCameraInterior(0)
		
		setElementInterior(getLocalPlayer(), 0)
		setCameraInterior(0)
		setElementPosition(getLocalPlayer(), 1742.1884765625, -1861.3564453125, 13.577615737915)
		setPedRotation(getLocalPlayer(), 0.98605346679688)
		setElementAlpha(getLocalPlayer(), 255)

		removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
		setCameraMatrix(1742.623046875, -1847.7109375, 16.579560279846, 1742.1884765625, -1861.3564453125, 13.577615737915)
		
		fadeCamera(true)
	end
end

--/////////////////////
-- AEROPLANE EFFECT
--/////////////////////
function aeroplaneEffect(button, state)
	if (source==rAeroplane) and (button=="left") and (state=="up") and not (lastSelected==rAeroplane) and not (anim) then
		lastSelected = source -- Avoid duplicates
		fadeCamera(false, 1, 0, 0, 0)
		setCameraInterior(0)
		
		setElementInterior(getLocalPlayer(), 0)
		setElementPosition(getLocalPlayer(), 1685.583984375, -2329.4443359375, 13.546875)
		setPedRotation(getLocalPlayer(), 0.79379272460938)
		setElementAlpha(getLocalPlayer(), 255)

		removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
		setCameraMatrix(1685.3681640625, -2309.9150390625, 16.546875, 1685.583984375, -2329.4443359375, 13.546875)
		fadeCamera(true, 1)
	end
end

-- ////////////////
-- FINAL
--/////////////////
function characterCreationFinal(button, state)
	if (source==bNext) and (button=="left") and (state=="up") and not (anim) then
		local train = guiRadioButtonGetSelected(rTrain)
		local bus = guiRadioButtonGetSelected(rBus)
		local aeroplane = guiRadioButtonGetSelected(rAeroplane)
		
		if (train or bus or aeroplane) then
			local transport
			if (train) then
				transport = 0
			elseif (bus) then
				transport = 1
			elseif (aeroplane) then
				transport = 2
			end
			local skin = getElementModel(getLocalPlayer())
			creation = false
			destroyElement(tabPanelCreation)
			tabPanelCreation = nil
			
			-- cleanup
			removeEventHandler("onClientRender", getRootElement(), moveCameraToCreation)
			
			destroyElement(bRotate)
			bRotate = nil
			
			local playerid = getElementData(getLocalPlayer(), "playerid")
			setElementInterior(getLocalPlayer(), 14)
			setElementDimension(getLocalPlayer(), 65000+playerid)
			setElementPosition(getLocalPlayer(), 258.43417358398, -41.489139556885, 1002.0234375)
			setPedRotation(getLocalPlayer(), 268.19247436523)
			
			setCameraMatrix(257.20394897461, -40.330944824219, 1002.5234375, 260.32162475586, -41.565814971924, 1002.0234375)
			setCameraInterior(14)
			fadeCamera(true)
			-- end cleanup

			
			if (skin==0) then -- CJ
				local clothes = { curhair, curhat, curneck, curface, curupper, curwrist, curlower, curfeet, curcostume, luTattoo, llTattoo, ruTattoo, rlTattoo, bTattoo, lcTattoo, rcTattoo, sTattoo, lbTattoo }
				triggerServerEvent("createCharacter", getLocalPlayer(), name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language, clothes)
			else
				triggerServerEvent("createCharacter", getLocalPlayer(), name, gender, skincolour, weight, height, fatness, muscles, transport, description, age, skin, language)
			end
		end
	end
end

--/////////////////////////////////////////////////////////////////
--DISPLAY STATISTICS
--/////////////////////////////////////////////////////////////////
lStatistics, lPoints, paneStatistics = nil
tabPanel, tabMystats, tabAllstats = nil

--/////////////////////////////////////////////////////////////////
--DISPLAY ACHIEVEMENTS
--/////////////////////////////////////////////////////////////////
lAchievements, lLoading, lPoints, paneAchievements, pane = nil
tableAchievements, iAchievementCount, iAchievementPointsCount = nil
function displayAchievements(achievements)
	destroyElement(lLoading)
	lLoading = nil

	paneAchievements = guiCreateScrollPane(0.05, 0.125, 0.9, 0.85, true, tabAchievements)
	
	pane = { }
	
	local currpoints = 0
	
	local y = 0.0
	local height = 0.2
	local resource = getResourceFromName("achievement-system")
	
	for key, value in pairs(achievements) do
		local name, desc, points = unpack( call( getResourceFromName( "achievement-system" ), "getAchievementInfo", value[1] ) )
		local date = value[2]
		
		pane[key] = {}
		pane[key][7] = guiCreateScrollPane(0.0, y, 1.0, 0.35, true, paneAchievements)
		pane[key][6] = guiCreateStaticImage(0.0, 0.1, 0.95, 0.5, ":achievement-system/bg.png", true, pane[key][7])
		
		pane[key][1] = guiCreateLabel(0.225, 0.1, 0.7, 0.2, tostring(name) .. " (" .. date .. ").", true, pane[key][7])
		guiSetFont(pane[key][1], "default-bold-small")
		guiLabelSetHorizontalAlign(pane[key][1], "center")
		
		pane[key][3] = guiCreateStaticImage(0.05, 0.1, 0.2, 0.5, ":achievement-system/achievement.png", true, pane[key][7], resource)
		pane[key][4] = guiCreateLabel(0.05, 0.45, 0.2, 0.2, tostring(points) .. " Pts", true, pane[key][7])
		guiLabelSetHorizontalAlign(pane[key][4], "center")
		guiSetFont(pane[key][4], "default-bold-small")
		
		pane[key][5] = guiCreateLabel(0.225, 0.25, 0.7, 0.6, tostring(desc), true, pane[key][7])
		guiLabelSetHorizontalAlign(pane[key][5], "center")
		guiSetFont(pane[key][5], "default-small")
		
		y = y + 0.205
		currpoints = currpoints + points
	end

	local iAchievementCount = call( getResourceFromName( "achievement-system" ), "getAchievementCount" )
	lAchievements = guiCreateLabel(0.05, 0.025, 0.9, 0.15, #achievements .. " Achievements of a possible " .. iAchievementCount .. " (" .. tostring(math.ceil((#achievements/iAchievementCount)*100)) .. "%).", true, tabAchievements)
	guiSetFont(lAchievements, "default-bold-small")
	
	local iAchievementPointsCount = call( getResourceFromName( "achievement-system" ), "getAchievementPoints" )
	lPoints = guiCreateLabel(0.05, 0.07, 0.9, 0.15, currpoints .. " Achievement Points of a possible " .. iAchievementPointsCount .. " (" .. tostring(math.ceil((currpoints/iAchievementPointsCount)*100)) .. "%).", true, tabAchievements)
	guiSetFont(lPoints, "default-bold-small")
end


--/////////////////////////////////////////////////////////////////
--DISPLAY ACCOUNT MANAGEMENT
--////////////////////////////////////////////////////////////////
lDonator, lAdmin, lMuted, chkBlur, lChangePassword, lCurrPassword, tCurrPassword, lNewPassword1, NewPassword1, lNewPassword2, tNewPassword2, bSavePass = nil
function displayAccountManagement()
	-- DONATOR
	local donator = tonumber(getElementData(getLocalPlayer(), "donatorlevel"))
	lDonator = guiCreateLabel(0.2, 0.05, 0.5, 0.05, "Donator: ", true, tabAccount)
	guiSetFont(lDonator, "default-bold-small")

	if (donator==0) then
		guiSetText(lDonator, "Donator: No")
	elseif (donator>1) then
		local title = tostring(exports.global:cgetPlayerDonatorTitle(getLocalPlayer()))
		guiSetText(lDonator, "Donator: " .. title)
	end
	
	-- ADMIN
	local admin = getElementData(getLocalPlayer(), "adminlevel")
	lAdmin = guiCreateLabel(0.2, 0.1, 0.5, 0.05, "Admin: ", true, tabAccount)
	guiSetFont(lAdmin, "default-bold-small")
	if (admin==0) then
		guiSetText(lAdmin, "Admin: No")
	else
		guiSetText(lAdmin, "Admin: Yes (" .. tostring(admin) .. ")")
	end
	
	-- MUTED
	local muted = getElementData(getLocalPlayer(), "muted")
	lMuted = guiCreateLabel(0.2, 0.15, 0.5, 0.05, "Muted: ", true, tabAccount)
	guiSetFont(lMuted, "default-bold-small")
	if (muted==0) then
		guiSetText(lMuted, "Muted: No")
	else
		guiSetText(lMuted, "Muted: Yes")
	end
	
	-- MTA USERNAME
	--local mtausername = getPlayerUserName(getLocalPlayer())
	--lMTAusername = guiCreateLabel(0.2, 0.2, 0.5, 0.05, "MTA Username: " .. mtausername, true, tabAccount)
	--guiSetFont(lMTAusername, "default-bold-small")
	
	-- MTA SERIAL
	--local mtaserial = getElementData(getLocalPlayer(), "serial")
	--mtaserial = string.sub(mtaserial, 1,4) .. "-" ..  string.sub(mtaserial, 5,8) .. "-" ..   string.sub(mtaserial, 9,12) .. "-" ..  string.sub(mtaserial, 13,16)  .. "-" .. string.sub(mtaserial, 17,20)  .. "-" .. string.sub(mtaserial, 21,24) .. "-" .. string.sub(mtaserial, 25,28) .. "-" .. string.sub(mtaserial, 29,32)
	--lMTAserial = guiCreateLabel(0.2, 0.25, 0.8, 0.05, "MTA Serial: " .. mtaserial, true, tabAccount)
	--guiSetFont(lMTAserial, "default-bold-small")
	
	-- BLUR
	local blur = getElementData(getLocalPlayer(), "blur")
	chkBlur = guiCreateCheckBox(0.2, 0.2, 0.5, 0.1, "Vehicle Blur", false, true, tabAccount)
	guiSetFont(chkBlur, "default-bold-small")
	if (blur==0) then
		guiCheckBoxSetSelected(chkBlur, false)
	else
		guiCheckBoxSetSelected(chkBlur, true)
	end
	addEventHandler("onClientGUIClick", chkBlur, clientToggleBlur, false)
	
	-- CHANGE PASSWORD
	lChangePassword = guiCreateLabel(0.375, 0.35, 0.5, 0.05, "Change Password", true, tabAccount)
	guiSetFont(lChangePassword, "default-bold-small")
	
	lCurrPassword = guiCreateLabel(0.1, 0.405, 0.5, 0.05, "Current Password: ", true, tabAccount)
	guiSetFont(lCurrPassword, "default-bold-small")
	tCurrPassword = guiCreateEdit(0.4, 0.4, 0.4, 0.05, "", true, tabAccount)
	guiEditSetMasked(tCurrPassword, true)
	
	lNewPassword1 = guiCreateLabel(0.1, 0.505, 0.5, 0.05, "New Password: ", true, tabAccount)
	guiSetFont(lNewPassword1, "default-bold-small")
	tNewPassword1 = guiCreateEdit(0.4, 0.5, 0.4, 0.05, "", true, tabAccount)
	guiEditSetMasked(tNewPassword1, true)
	
	lNewPassword2 = guiCreateLabel(0.1, 0.56, 0.5, 0.05, "New Password: ", true, tabAccount)
	guiSetFont(lNewPassword2, "default-bold-small")
	tNewPassword2 = guiCreateEdit(0.4, 0.555, 0.4, 0.05, "", true, tabAccount)
	guiEditSetMasked(tNewPassword2, true)
	
	bSavePass = guiCreateButton(0.25, 0.65, 0.5, 0.1, "Save Password", true, tabAccount)
	addEventHandler("onClientGUIClick", bSavePass, savePassword, false)
end

function clientToggleBlur()
	local blur = guiCheckBoxGetSelected(chkBlur)
	
	if (blur) then
		triggerServerEvent("updateBlurLevel", getLocalPlayer(), true)
	else
		triggerServerEvent("updateBlurLevel", getLocalPlayer(), false)
	end
end

function savePassword(button, state)
	if (source==bSavePass) and (button=="left") and (state=="up") then
		showChat(true)
		local password = guiGetText(tCurrPassword)
		local password1 = guiGetText(tNewPassword1)
		local password2 = guiGetText(tNewPassword2)
		
		
		if (string.len(password1)<6) or (string.len(password2)<6) then
			outputChatBox("Your new password is too short. You must enter 6 or more characters.", 255, 0, 0)
		elseif (string.len(password)<6)  then
			outputChatBox("Your current password is too short. You must enter 6 or more characters.", 255, 0, 0)
		elseif (string.find(password, ";", 0)) or (string.find(password, "'", 0)) or (string.find(password, "@", 0)) or (string.find(password, ",", 0)) then
			outputChatBox("Your current password cannot contain ;,@'.", 255, 0, 0)
		elseif (string.find(password1, ";", 0)) or (string.find(password1, "'", 0)) or (string.find(password1, "@", 0)) or (string.find(password1, ",", 0)) then
			outputChatBox("Your new password cannot contain ;,@'.", 255, 0, 0)
		elseif (password1~=password2) then
			outputChatBox("The new passwords you entered do not match.", 255, 0, 0)
		else
			triggerServerEvent("cguiSavePassword", getLocalPlayer(), password, password1)
		end
	end
end


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


--/////////////////////////////////////////////////////////////////
--DISPLAY CHARACTER EDITING
--////////////////////////////////////////////////////////////////
local charGender = 0
function editSelectedCharacter(button, state)
	if button=="left" and state=="up" and selectedChar and paneChars[selectedChar] then
		triggerServerEvent("requestEditCharInformation", getLocalPlayer(), guiGetText(paneChars[selectedChar][2]))
	end
end
function editCharacter(height, weight, age, description, gender)
	if selectedChar and paneChars[selectedChar] then
		charGender = gender
		
		guiSetVisible(tabPanelCharacter, false)
		
		local xwidth, xheight = 400, 400
		
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (xwidth/2)
		local y = scrHeight/2 - (xheight/2)
		
		tabPanelCreation = guiCreateTabPanel(5, y, xwidth, xheight, false)
		tabCreationFive = guiCreateTab("Character Editing", tabPanelCreation)
		guiSetAlpha(tabPanelCreation, 0.75)
		
		lInformation = guiCreateLabel(0.1, 0.025, 0.8, 0.15, tostring(guiGetText(paneChars[selectedChar][2])), true, tabCreationFive) 
		guiSetFont(lInformation, "sa-header")
		
		--/////////////
		-- HEIGHT
		--/////////////
		lHeight = guiCreateLabel(0.1, 0.145, 0.5, 0.15, "Height (cm)(between 100 and 200):", true, tabCreationFive)
		guiSetFont(lHeight, "default-bold-small")
		guiLabelSetColor(lHeight, 0, 255, 0)
		
		tHeight = guiCreateEdit(0.635, 0.143, 0.15, 0.05, height, true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tHeight, checkInput)
		
		--/////////////
		-- WEIGHT
		--/////////////
		lWeight = guiCreateLabel(0.1, 0.215, 0.5, 0.15, "Weight (kg)(between 40 and 200):", true, tabCreationFive)
		guiSetFont(lWeight, "default-bold-small")
		guiLabelSetColor(lWeight, 0, 255, 0)
		
		tWeight = guiCreateEdit(0.635, 0.213, 0.15, 0.05, weight, true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tWeight, checkInput)
		
		--/////////////
		-- AGE
		--/////////////
		lAge = guiCreateLabel(0.1, 0.285, 0.5, 0.15, "Age (between 18 and 80):", true, tabCreationFive)
		guiSetFont(lAge, "default-bold-small")
		guiLabelSetColor(lAge, 0, 255, 0)
		
		tAge = guiCreateEdit(0.635, 0.283, 0.15, 0.05, age, true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tAge, checkInput)
		
		--/////////////
		-- DESCRIPTION
		--/////////////
		lCharDesc = guiCreateLabel(0.1, 0.385, 0.8, 0.15, "Description(between 30 and 100 characters):", true, tabCreationFive)
		guiSetFont(lCharDesc, "default-bold-small")
		guiLabelSetColor(lCharDesc, 0, 255, 0)
		
		tCharDesc = guiCreateMemo(0.1, 0.455, 0.8, 0.25, description, true, tabCreationFive)
		addEventHandler("onClientGUIChanged", tCharDesc, checkInput)
		
		--/////////////
		-- SAVE/CANCEL
		--/////////////
		bNext = guiCreateButton(0.05, 0.75, 0.9, 0.1, "Save", true, tabCreationFive)
		addEventHandler("onClientGUIClick", bNext, updateEditedCharacter, false)
		
		bCancel = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Cancel", true, tabCreationFive)
		addEventHandler("onClientGUIClick", bCancel,
			function()
				destroyElement(tabPanelCreation)
				tabPanelCreation = nil
				guiSetVisible(tabPanelCharacter, true)
			end, false)
	end
end
addEvent("sendEditingInformation", true)
addEventHandler("sendEditingInformation", getLocalPlayer(), editCharacter)

function updateEditedCharacter()
	if heightvalid and weightvalid and descvalid and agevalid and selectedChar then
		height = tonumber(guiGetText(tHeight))
		weight = tonumber(guiGetText(tWeight))
		age = tonumber(guiGetText(tAge))
		description = guiGetText(tCharDesc)
		
		triggerServerEvent("updateEditedCharacter", getLocalPlayer(), guiGetText(paneChars[selectedChar][2]), height, weight, age, description)
		
		destroyElement(tabPanelCreation)
		tabPanelCreation = nil
		guiSetVisible(tabPanelCharacter, true)
		
		-- update character screen (avoids us from reloading all accounts)
		local gender = "Male" 
		if charGender == 1 then
			gender = "Female"
		end
		guiSetText(paneChars[selectedChar][4], age .. " year old " .. gender .. ".", true)
	end
end

local oldvisible
function checkForRadarMap()
	local visible = not isPlayerMapVisible()
	if visible ~= oldvisible then
		if bChangeChar and isElement(bChangeChar) then
			guiSetVisible(bChangeChar, visible)
		end
		if bChangeAccount and isElement(bChangeAccount) then
			guiSetVisible(bChangeAccount, visible)
		end
	end
end
addEventHandler( "onClientRender", getRootElement(), checkForRadarMap )




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
	if ( mainMenuItems[currentItem]["text"] == "Characters" ) then
		-- lets determine which character is selected
		for k = 1, #characterMenu do
			local i = #characterMenu - (k - 1)

			if ( round(characterMenu[k]["ty"], -1) >= round(initY + xoffset, -1) - 100) then -- selected
				if ( currentCharacterID == k ) then
					hideXMB()
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
		unbindKey("home", "down", toggleXMB)
		
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
	if ( state == 3 and not fading ) then
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

local friendAlertUsername = nil
local friendAlertTimer = nil
local friendAlertAlpha = 0
local friendAlertFadeIn = true
local friendAlertVisible = false
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

	local x = width - xoffset*1.6
	local y = 20 + dxGetFontHeight(2, "sans")
	dxDrawText("has just signed in.", x+10, y+10, x + xoffset*1.8, y + 120, tocolor(0,0,0, friendAlertAlpha + 50), 1, "sans", "center", "center", false, false, false)
	dxDrawText("has just signed in.", x, y, x + xoffset*1.8, y + 120, tocolor(255, 255, 255, friendAlertAlpha + 50), 1, "sans", "center", "center", false, false, false)
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
	bindKey("home", "down", toggleXMB)
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
	tAccount[4]["title"] = "Playstation Network� Account"
	tAccount[4]["text"] = "You currently have no Playstation Network� account linked.\nSelect this option to link one."
	tAccount[4]["cx"] = initX
	tAccount[4]["cy"] = initY + 4*yoffset + 40
	tAccount[4]["tx"] = initX
	tAccount[4]["ty"] = initY + 4*yoffset + 40
	
	-- XBOX LIVE ACCOUNT
	tAccount[5] = { }
	tAccount[5]["title"] = "Xbox Live� Account"
	tAccount[5]["text"] = "You currently have no Xbox Live� account linked.\nSelect this option to link one."
	tAccount[5]["cx"] = initX
	tAccount[5]["cy"] = initY + 5*yoffset + 40
	tAccount[5]["tx"] = initX
	tAccount[5]["ty"] = initY + 5*yoffset + 40
	
	-- STEAM ACCOUNT
	tAccount[6] = { }
	tAccount[6]["title"] = "Steam� Account"
	tAccount[6]["text"] = "You currently have no Steam� account linked.\nSelect this option to link one."
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