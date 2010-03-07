local appsbutton = nil
local localPlayer = getLocalPlayer( )

local function updateButton( )
	if getResourceFromName ( 'global' ) then 
		if exports.global:isPlayerAdmin( localPlayer ) and getElementData( localPlayer, "adminduty" ) == 1 then
			local apps = getElementData( getResourceRootElement( ), "openapps" )
			if apps and apps > 0 then
				if not appsbutton then
					appsbutton = guiCreateButton( 0.775, 0.925, 0.05, 0.05, tostring( apps ), true )
					addEventHandler( "onClientGUIClick", appsbutton,
						function( )
							triggerServerEvent( "apps:show", localPlayer )
						end, false
					)
					guiSetAlpha( appsbutton, 0.75 )
				else
					guiSetText( appsbutton, tostring( apps ) )
				end
				return
			end
		end
		if appsbutton then
			destroyElement( appsbutton )
			appsbutton = nil
		end
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement( ), updateButton )
addEventHandler( "onClientElementDataChange", getResourceRootElement( ), updateButton )
addEventHandler( "onClientElementDataChange", localPlayer,
	function( name ) 
		if name == "adminlevel" or name == "adminduty" then
			updateButton( )
		end
	end
)

--

local wAllApps = nil

addEvent( "apps:showall", true )
addEventHandler( "apps:showall", localPlayer,
	function( results )
		if wAllApps then
			destroyElement( wAllApps )
			wAllApps = nil
			
			showCursor( false )
		else
			local sx, sy = guiGetScreenSize()
			wAllApps = guiCreateWindow( sx / 2 - 150, sy / 2 - 250, 300, 500, "Open Applications", false )
			
			gAllApps = guiCreateGridList( 0.03, 0.04, 0.94, 0.88, true, wAllApps )
			local colName = guiGridListAddColumn( gAllApps, "Name", 0.50 )
			local colTime = guiGridListAddColumn( gAllApps, "Time", 0.45 )
			for _, res in pairs( results ) do
				local row = guiGridListAddRow( gAllApps )
				guiGridListSetItemText( gAllApps, row, colName, res[2], false, true )
				guiGridListSetItemData( gAllApps, row, colName, tostring( res[1] ) )
				guiGridListSetItemText( gAllApps, row, colTime, res[3], false, true )
				guiGridListSetItemData( gAllApps, row, colTime, tostring( res[1] ) )
			end
			
			addEventHandler( "onClientGUIDoubleClick", gAllApps,
				function( button )
					if button == "left" then
						local row, col = guiGridListGetSelectedItem( gAllApps )
						if row ~= -1 and col ~= -1 then
							local id = guiGridListGetItemData( gAllApps, row, col )
							triggerServerEvent( "apps:show", localPlayer, tonumber( id ) )
							
							destroyElement( wAllApps )
							wAllApps = nil
							
							showCursor( false )
						else
							outputChatBox( "You need to pick an Application.", 255, 0, 0 )
						end
					end
				end,
				false
			)
			
			bClose = guiCreateButton( 0.03, 0.93, 0.94, 0.07, "Close", true, wAllApps )
			addEventHandler( "onClientGUIClick", bClose,
				function( button, state )
					if button == "left" and state == "up" then
						destroyElement( wAllApps )
						wAllApps = nil
						
						showCursor( false )
					end
				end, false
			)
			
			showCursor( true )
		end
	end
)

--

local wApp = nil
local texts = {}
local account = nil
local accept, deny, close, back, history

addEvent( "apps:showsingle", true )
addEventHandler( "apps:showsingle", localPlayer,
	function( info )
		-- appdefinitions, appfirstcharacter, appclarifications, appreason, appstate, adminnote, ( SELECT COUNT(*) FROM adminhistory 
		account = { id = tonumber( info.id ), name = info.username }
		if not wApp then
			local sx, sy = guiGetScreenSize()
			wApp = guiCreateWindow( sx / 2 - 365, sy / 2 - 280, 730, 560, "Review Application", false )
			guiWindowSetSizable( wApp, false )
			
			texts.username = { guiCreateLabel( 10, 22, 170, 16, "", false, wApp ), "Username: " }
			texts.id = { guiCreateLabel( 180, 22, 110, 16, "", false, wApp ), "Account ID: " }
			texts.history = { guiCreateLabel( 300, 22, 70, 16, "", false, wApp ), "History: " }
			texts.appcountry = { guiCreateLabel( 10, 38, 200, 16, "", false, wApp ), "Country: " }
			texts.applanguage = { guiCreateLabel( 220, 38, 140, 16, "", false, wApp ), "Language: " }
			
			texts.appgamingexperience = { guiCreateMemo( 10, 70, 350, 100, "", false, wApp ), nil, guiCreateLabel( 10, 54, 350, 16, "Tell us about your gaming Experience:", false, wApp ) }
			texts.apphow = { guiCreateMemo( 10, 192, 350, 100, "", false, wApp ), nil, guiCreateLabel( 10, 176, 350, 16, "How did you get into Grand Theft Auto Roleplay?", false, wApp ) }
			texts.appwhy = { guiCreateMemo( 10, 316, 350, 100, "", false, wApp ), nil, guiCreateLabel( 10, 300, 350, 16, "Why did you choose the Valhalla Gaming MTA Roleplay server?", false, wApp ) }
			
			texts.appexpectations = { guiCreateMemo( 10, 440, 350, 100, "", false, wApp ), nil, guiCreateLabel( 10, 424, 350, 16, "Expectations and what do you hope?", false, wApp ) }
			texts.appdefinitions = { guiCreateMemo( 365, 38, 350, 100, "", false, wApp ), nil, guiCreateLabel( 365, 22, 350, 16, "  Metagaming/Powergaming?", false, wApp ) }
			texts.appfirstcharacter = { guiCreateMemo( 365, 160, 350, 100, "", false, wApp ), nil, guiCreateLabel( 365, 144, 350, 16, "First Character?", false, wApp ) }
			texts.appclarifications = { guiCreateMemo( 365, 282, 350, 50, "", false, wApp ), nil, guiCreateLabel( 365, 266, 350, 16, "Clarifications?", false, wApp ) }
			
			texts.appreason = { guiCreateMemo( 365, 382, 350, 70, "", false, wApp ), nil, guiCreateLabel( 365, 366, 350, 16, "Reason", false, wApp ) }
			texts.adminnote = { guiCreateMemo( 365, 476, 350, 64, "", false, wApp ), nil, guiCreateLabel( 365, 460, 350, 16, "Admin Note", false, wApp ) }
			
			accept = guiCreateButton( 365, 340, 80, 20, "Accept", false, wApp )
			addEventHandler( "onClientGUIClick", accept,
				function( button, state )
					if button == "left" and state == "up" then
						guiSetVisible( wApp, false )
						guiSetInputEnabled( false )
						triggerServerEvent( "apps:update", localPlayer, account, 3, guiGetText( texts.appreason[1] ) or "" )
					end
				end, false
			)
			
			deny = guiCreateButton( 450, 340, 80, 20, "Deny", false, wApp )
			addEventHandler( "onClientGUIClick", deny,
				function( button, state )
					if button == "left" and state == "up" then
						guiSetVisible( wApp, false )
						guiSetInputEnabled( false )
						triggerServerEvent( "apps:update", localPlayer, account, 2, guiGetText( texts.appreason[1] ) or "" )
					end
				end, false
			)
			
			close = guiCreateButton( 535, 340, 80, 20, "Close", false, wApp )
			addEventHandler( "onClientGUIClick", close,
				function( button, state )
					if button == "left" and state == "up" then
						guiSetVisible( wApp, false )
						guiSetInputEnabled( false )
					end
				end, false
			)
			--back = guiCreateButton( 620, 340, 80, 20, "Back", false, wApp )
			--addEventHandler( "onClientGUIClick", back,
			--	function( button, state )
			--		if button == "left" and state == "up" then
			--			guiSetVisible( wApp, false )
			--			guiSetInputEnabled( false )
			--			triggerServerEvent( "apps:show", localPlayer )
			--		end
			--	end, false
			--)
			history = guiCreateButton( 620, 340, 80, 20, "History", false, wApp )
			addEventHandler( "onClientGUIClick", history,
				function( button, state )
					if button == "left" and state == "up" then
						--guiSetVisible( wApp, false )
						--guiSetInputEnabled( false )
						triggerServerEvent( "apps:showhistory", localPlayer, account )
					end
				end, false
			)
			
		else
			guiSetVisible( wApp, true )
		end
		guiSetInputEnabled( true )
		
		for key, value in pairs( texts ) do
			guiSetText( value[1], ( value[2] or "" ) .. ( info[key] or "" ) )
		end
	end
)