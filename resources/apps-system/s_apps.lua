mysql = exports.mysql

local function updateAppCount( )
	local result = mysql:query_fetch_assoc( "SELECT COUNT(*) AS count FROM accounts WHERE appstate = 1" )
	if result then
		setElementData( getResourceRootElement( ), "openapps", tonumber( result.count ) )
		return tonumber( result.count )
	end
	return -1
end

addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		updateAppCount( )
		setTimer( updateAppCount, 60000, 0 )
	end
)

--

addEvent( "apps:show", true )
addEventHandler( "apps:show", getRootElement( ), 
	function( id )
		if exports.global:isPlayerAdmin( source ) then
			if id and tonumber( id ) then
				local result = mysql:query_fetch_assoc( "SELECT id, username, appgamingexperience, appcountry, applanguage, apphow, appwhy, appexpectations, appdefinitions, appfirstcharacter, appclarifications, appreason, appstate, adminnote, ( SELECT COUNT(*) FROM adminhistory WHERE id = " .. id .. ") AS history FROM accounts WHERE id = " .. id )
				if result then
					if tonumber( result.appstate ) == 1 then -- application is open
						for key, value in pairs( result ) do
							if value == mysql_null( ) then
								result[ key ] = ""
							else
								result[ key ] = tonumber( value ) or value
							end
						end
						triggerClientEvent( source, "apps:showsingle", source, result )
						return
					else
						outputChatBox( "The application of " .. result.username .. " has been processed already.", source, 255, 0, 0 )
					end
				end
			end
			
		
			local result = mysql:query( "SELECT id, username, appdatetime FROM accounts WHERE appstate = 1 ORDER BY appdatetime ASC" )
			if result then
				local table = { }
				while true do
					local row = mysql:fetch_assoc( result )
					if row then
						table[ #table + 1 ] = { tonumber( row.id ), row.username, row.appdatetime }
					else
						break
					end
				end
				if #table == 0 then
					outputChatBox( "There are no new applications.", source, 0, 255, 0 )
				else
					triggerClientEvent( source, "apps:showall", source, table )
				end
				mysql:free_result( result )
			end
		end
	end
)

--

addEvent( "apps:update", true )
addEventHandler( "apps:update", getRootElement( ),
	function( account, state, reason )
		if exports.global:isPlayerAdmin( source ) and ( state == 2 or state == 3 ) and tonumber( account.id ) then
			mysql:query_free( "UPDATE accounts SET appstate = " .. state .. ", appreason = '" .. mysql:escape_string( reason ) .. "', apphandler = '" .. mysql:escape_string( getElementData( source, "gameaccountusername" ) ) .. "', appdatetime=NOW() + INTERVAL 1 DAY WHERE id = " .. account.id .. " LIMIT 1" )
			outputChatBox( "You have now " .. ( state == 3 and "accepted " or "denied " ) .. account.name .. "'s application.", source, 0, 255, 0 )
			if updateAppCount( ) > 0 then
				triggerEvent( "apps:show", source )
			end
		end
	end
)

addEvent( "apps:showhistory", true )
addEventHandler( "apps:showhistory", getRootElement( ),
	function( account )
		if exports.global:isPlayerAdmin( source ) and tonumber(account.id) then
			local targetID = account.id
			local result = mysql:query("SELECT date, action, reason, duration, a.username, user_char FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin WHERE user = " .. targetID .. " ORDER BY h.id DESC" )
			if result then
				local info = {}
				local continue = true
				while continue do
					local row = mysql:fetch_assoc(result)
					if not row then break end
					local record = {}
					record[1] = row["date"]
					record[2] = row["action"]
					record[3] = row["reason"]
					record[4] = row["duration"]
					record[5] = row["username"]
					record[6] = row["user_char"]
					
					table.insert( info, record )
				end
				triggerClientEvent( source, "cshowAdminHistory", source, info )
				mysql:free_result( result )
			else
				outputDebugString( "apps-system\apps:showhistory: Error." )
				outputChatBox( "Failed to retrieve history.", source, 255, 0, 0)
			end
		end
	end
)
