----------------------------
-- natslife.net (IC blog) --
----------------------------

-- Website owner's forum name: mabako
-- Website owner's Character's name: Natalie Stafford

local function returnPosts( result, ... )
	if result ~= "ERROR" then
		result = { result, ... }
		local file = xmlCreateFile( "websites/natslife.xml", "cache" )
		for key, value in pairs( result ) do
			local node = xmlCreateChild( file, "entry" )
			xmlNodeSetAttribute( node, "id", key )
			xmlNodeSetAttribute( node, "title", value.post_title )
			xmlNodeSetValue( node, value.post_content )
			xmlNodeSetAttribute( node, "date", value.post_date_gmt )
		end
		xmlSaveFile( file )
		xmlUnloadFile( file )
	end
end

addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		callRemote( "http://natslife.net/pda.php", returnPosts )
	end
)