local languagecount = 0

strings = setmetatable( { },
	{
		__newindex = function( t, key, value )
			languagecount = languagecount + 1
			value.order = languagecount
			rawset( t, key, value )
		end
	}
)