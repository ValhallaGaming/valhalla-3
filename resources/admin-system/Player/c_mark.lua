addEvent( "saveTempMark", true )
addEventHandler( "saveTempMark", getLocalPlayer( ),
	function( x, y, z, interior, dimension )
		local xml = xmlCreateFile( "Player/mark.xml", "mark" )
		if xml then
			xmlNodeSetAttribute( xml, "x", x )
			xmlNodeSetAttribute( xml, "y", y )
			xmlNodeSetAttribute( xml, "z", z )
			xmlNodeSetAttribute( xml, "interior", interior )
			xmlNodeSetAttribute( xml, "dimension", dimension )
			xmlSaveFile( xml )
			xmlUnloadFile( xml )
		end
	end
)

addEventHandler( "onClientResourceStart", resourceRoot,
	function( )
		local xml = xmlLoadFile( "Player/mark.xml" )
		if xml then
			triggerServerEvent( "loadTempMark", getLocalPlayer( ), tonumber( xmlNodeGetAttribute( xml, "x" ) ), tonumber( xmlNodeGetAttribute( xml, "y" ) ), tonumber( xmlNodeGetAttribute( xml, "z" ) ), tonumber( xmlNodeGetAttribute( xml, "interior" ) ), tonumber( xmlNodeGetAttribute( xml, "dimension" ) ) )
			xmlUnloadFile( xml )
		end
	end
)