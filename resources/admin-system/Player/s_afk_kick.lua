function kickAFKPlayer()
	if not exports.global:isPlayerScripter(source) then
		kickPlayer(source, getRootElement(), "Away From Keyboard")
	end
end
addEvent("AFKKick", true)
addEventHandler("AFKKick", getRootElement(), kickAFKPlayer)