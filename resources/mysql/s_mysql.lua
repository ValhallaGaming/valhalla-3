username = get( "username" ) or "mta"
password = get( "password" ) or ""
db = get( "database" ) or "mta"
host = get( "hostname" ) or "localhost"
port = tonumber( get( "port" ) ) or 3306

function getMySQLUsername()
	return username
end

function getMySQLPassword()
	return password
end

function getMySQLDBName()
	return db
end

function getMySQLHost()
	return host
end

function getMySQLPort()
	return port
end