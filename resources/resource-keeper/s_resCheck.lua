--Add any resources needing to be checked here
local mainRes = { "admin-system", "account-system", "global" }

--Sends messages to Head Admins and Scripters
function displayAdminM(message)
	for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
		local logged = getElementData(arrayPlayer, "loggedin")
		if (logged) then
			if exports.global:isPlayerHeadAdmin(arrayPlayer) or exports.global:isPlayerScripter(arrayPlayer) then
				outputChatBox("ResWarn: " .. message, arrayPlayer, 255, 194, 14)
			end
		end
	end
end

--The magic
local attempts = { 0, 0 }
local count = 0
function checkRes(res)
	for i, res in ipairs(mainRes) do
		local resName = getResourceFromName(res)
		if (resName) then
			local cState = getResourceState(resName)
			if (cState ~= "running") then
				displayAdminM("Resource '" .. res .. "' was not running. Attempting to start missing resource.")
				local startingRes = startResource(resName, true)
				if (attempts[i] < 4) then
					if not (startingRes) then
						displayAdminM("Fail to load Resource '" .. res .. "'.")
						local nreasonRes = getResourceLoadFailureReason(resName)
						displayAdminM("Reason: " .. nreasonRes)
						attempts[i] = attempts[i] + 1
					else
						displayAdminM("Resource '" .. res .. "' started successfully.")
					end
				end
			end
			count = count + 1

			if count == #mainRes then
				displayAdminM("All resources are running as they should")
				count = 0
			end
		end
	end
	setTimer(checkRes, 3600000, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(), checkRes)

function runResCheck(admin, command)
	if (command == "rescheck") then
		if (exports.global:isPlayerHeadAdmin(admin) or exports.global:isPlayerScripter(admin)) then
			outputChatBox("Running Resource Checker:", admin, 0, 255, 0)
			checkRes()
		end
	elseif (command == "rcs") then
		if (exports.global:isPlayerHeadAdmin(admin) or exports.global:isPlayerScripter(admin)) then
			outputChatBox("Resource Keeper is running.", admin, 0, 255, 0)
		end
	end
end
addCommandHandler("rescheck", runResCheck)
addCommandHandler("rcs", runResCheck)