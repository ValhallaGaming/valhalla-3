local localPlayer = getLocalPlayer()
local projectile = nil
local projectiles = { }
local x, y, z = nil

function gimmepredator()
	projectile = createProjectile(localPlayer, 20, 1153.6865234375, -1391.8251953125, 500.0, 1.0, nil, 90, 0, 0, 0, 0, -1)
	
	--for i = 1, 10 do
	--	projectiles[i] = createProjectile(localPlayer, 20, 1153.6865234375, -1391.8251953125, 100.0, 1.0, nil, 90, 0, 0, 0, 0, -1)
	--end
	showCursor(false)
	addEventHandler("onClientPreRender", getRootElement(), updatePredator)
	addEventHandler("onClientExplosion", localPlayer, explodePredator)
	addEventHandler("onClientCursorMove", getRootElement(), cursorMove)
end
addCommandHandler("pred", gimmepredator)

function cursorMove(cx, cy, absx, absy, wx, wy, wz)
	if ( isElement(projectile) ) then
		if ( wx ~= x ) and ( wy ~= y ) and ( wz~= z) then
			setElementPosition(projectile, wx, wy, z)
		end
		
		--for i = 1, 10 do
		--	setElementPosition(projectiles[i], wx, wy, z)
		--end
	end
end

function updatePredator()
	if ( isElement(projectile ) ) then
		setElementVelocity(projectile, 0, 0, -1)
		local tx, ty, tz = getElementPosition(projectile)
		
		if ( tx > 0 ) then
			x = tx
			y = ty
			z = tz
		end
	end
	setCameraMatrix(x, y, z+20, x, y, z)
	
	-- heat vision on elements
	for key, value in ipairs(getElementsByType("vehicle")) do
		if ( isElementStreamedIn(value) ) then
			if ( isElementOnScreen(value) ) then
				local minx, miny, minz, mx, my, mz = getElementBoundingBox(value)
				local x, y, z = getElementPosition(value)
				dxDrawLine3D(minx+x, miny+y, mz+z+5, minx+x, my+y ,mz+z+5, tocolor(255, 0, 0, 255), 15, false, 0)
				dxDrawLine3D(minx+x, miny+y, mz+z+5, mx+x, miny+y ,mz+z+5, tocolor(255, 0, 0, 255), 15, false, 0)
				dxDrawLine3D(mx+x, my+y, mz+z+5, minx+x, my+y ,mz+z+5, tocolor(255, 0, 0, 255), 15, false, 0)
				dxDrawLine3D(mx+x, miny+y, mz+z+5, mx+x, my+y ,mz+z+5, tocolor(255, 0, 0, 255), 15, false, 0)
			end
		end
	end
end

function explodePredator(x, y, z, type)
	triggerServerEvent("createExplode", getLocalPlayer(), x, y, z)
	setCameraMatrix(x, y, z+10, x, y, z)
	setTimer(setCameraTarget, 2500, 1, localPlayer)
	removeEventHandler("onClientPreRender", getRootElement(), updatePredator)
	removeEventHandler("onClientExplosion", localPlayer, explodePredator)
	removeEventHandler("onClientCursorMove", getRootElement(), cursorMove)
end