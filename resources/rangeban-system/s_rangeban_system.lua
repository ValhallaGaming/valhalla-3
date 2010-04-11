local bans = 
{
	"212.92.*.*", -- Tailor Joe
	"41.249.*.*", -- Joe Harisson
	"120.60.*.*" -- Edd Brown
}

addEventHandler ("onPlayerConnect", getRootElement(), 
	function(playerNick, playerIP, playerUsername, playerSerial, playerVersion)
		for _, v in pairs( bans ) do
			if string.find( playerIP, "^" .. v .. "$" ) then
				cancelEvent( true, "You are banned from this server." )
			end
		end
	end
)