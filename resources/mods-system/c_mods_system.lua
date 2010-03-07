function applyMods()
	----------------------
	-- Pig Pen Interior --
	----------------------
	-- Bar
	pigpen1 = engineLoadTXD("ls/lee_stripclub1.txd")
	engineImportTXD(pigpen1, 14831)
	
	-- corver stage + seat
	pigpen2 = engineLoadTXD("ls/lee_stripclub.txd")
	engineImportTXD(pigpen2, 14832)
	-- Backwall seats
	engineImportTXD(pigpen2, 14833)
	-- columns
	engineImportTXD(pigpen2, 14835)
	-- corner seats
	engineImportTXD(pigpen2, 14837)
	-- main interior structure
	engineImportTXD(pigpen2, 14838)	
	
	------------------------
	-- bus Stop --
	------------------------
	busStop = engineLoadTXD("ls/bustopm.txd")
	engineImportTXD(busStop, 1257)
			
	----------------
	-- Gang Tags --
	----------------
	tag1 = engineLoadTXD("tags/tags_lafront.txd") -- vG logo
	engineImportTXD(tag1, 1524)
	
	tag2 = engineLoadTXD("tags/tags_lakilo.txd") -- MTA 
	engineImportTXD(tag2, 1525)

	tag3 = engineLoadTXD ( "tags/tags_larifa.txd" ) -- Crips
	engineImportTXD ( tag3, 1526 )

	-- tag4 = engineLoadTXD ( "tags/tags_larollin.txd" )
	-- engineImportTXD ( tag4, 1527 )

	-- tag5 = engineLoadTXD ( "tags/tags_laseville.txd" )
	-- engineImportTXD ( tag5, 1528 )

	-- tag6 = engineLoadTXD ( "tags/tags_latemple.txd" )
	-- engineImportTXD ( tag6, 1529 )

	-- tag7 = engineLoadTXD ( "tags/tags_lavagos.txd" )
	-- engineImportTXD ( tag7, 1530 )

	tag8 = engineLoadTXD ( "tags/tags_laazteca.txd" ) -- Los Malvados
	engineImportTXD ( tag8, 1531 )
	
	---------
	-- BTR --
	---------
	towing = engineLoadTXD ( "ls/eastbeach3c_lae2.txd" )
	engineImportTXD ( towing, 17555 )
	
	---------------
	-- Moscovian --
	---------------
	moscovian = engineLoadTXD( "ls/gangblok1_lae2.txd" )
	engineImportTXD ( moscovian, 17700 )
end
addEventHandler("onClientResourceStart", getResourceRootElement(), applyMods)