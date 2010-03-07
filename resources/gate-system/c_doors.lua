addEventHandler( "onClientElementDataChange", getResourceRootElement( ),
	function( name )
		if name == "door:closed" then
			setObjectStatic( source, getElementData( source, name ) )
		end
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement( ),
	function( )
		for key, value in pairs( getElementsByType( "object" ) ) do
			setObjectStatic( value, getElementData( value, "door:closed" ) )
		end
	end
)