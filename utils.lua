blockinput = false
local pi, sin, cos, abs, rad = math.pi, math.sin, math.cos, math.abs, math.rad
local function RotationToDirection(rotation)
  local adjustedRotation =
  {
    x = (pi / 180) * rotation.x,
    y = (pi / 180) * rotation.y,
    z = (pi / 180) * rotation.z
  }
  local direction =
  {
    x = -sin(adjustedRotation.z) * abs(cos(adjustedRotation.x)),
    y = cos(adjustedRotation.z) * abs(cos(adjustedRotation.x)),
    z = sin(adjustedRotation.x)
  }
  return direction
end

local function rotate(origin, point, theta)
  if theta == 0.0 then return point end

  local p = point - origin
  local pX, pY = p.x, p.y
  theta = rad(theta)
  local cosTheta = cos(theta)
  local sinTheta = sin(theta)
  local x = pX * cosTheta - pY * sinTheta
  local y = pX * sinTheta + pY * cosTheta
  return vector3(x, y, 0.0) + origin
end
 
function RayCastGamePlayCamera(distance)
  local cameraRotation = GetGameplayCamRot()
  local cameraCoord = GetGameplayCamCoord()
  --local right, direction, up, pos = GetCamMatrix(GetRenderingCam())
  --local cameraCoord = pos
  local direction = RotationToDirection(cameraRotation)
  local destination =
  {
    x = cameraCoord.x + direction.x * distance,
    y = cameraCoord.y + direction.y * distance,
    z = cameraCoord.z + direction.z * distance
  }
  local ray = StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z,
  destination.x, destination.y, destination.z, 1, -1, 0)
  local rayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(ray)
  return hit, endCoords, entityHit, surfaceNormal
end

-- GetUserInput function inspired by vMenu (https://github.com/TomGrobbe/vMenu/blob/master/vMenu/CommonFunctions.cs)
function GetUserInput(windowTitle, defaultText, maxInputLength)
  blockinput = true
  -- Create the window title string.
  local resourceName = string.upper(GetCurrentResourceName())
  local textEntry = resourceName .. "_WINDOW_TITLE"
  if windowTitle == nil then
    windowTitle = "Enter:"
  end
  AddTextEntry(textEntry, windowTitle)

  -- Display the input box.
  DisplayOnscreenKeyboard(1, textEntry, "", defaultText or "", "", "", "", maxInputLength or 30)
  Wait(0)
  -- Wait for a result.
  while true do
    local keyboardStatus = UpdateOnscreenKeyboard();
    if keyboardStatus == 3 then -- not displaying input field anymore somehow
      blockinput = false
      return nil
    elseif keyboardStatus == 2 then -- cancelled
      blockinput = false
      return nil
    elseif keyboardStatus == 1 then -- finished editing
      blockinput = false
      return GetOnscreenKeyboardResult()
    else
      Wait(0)
    end
  end
end

function DrawSphere(pos, radius, r, g, b, a)
  DrawMarker(28, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, false, false, 2, nil, nil, false)
end

function handleHeightInput(coord)
  if blockinput then return coord end
  delta = 0.05
  DisableControlAction(0, 36, true)
  if IsDisabledControlPressed(0, 36) then -- ctrl held down
    delta = 0.01
  end
  DisableControlAction(0, 23, true)
  DisableControlAction(0, 140, true)
  DisableControlAction(0, 47, true)
  if IsDisabledControlPressed(0, 23) then -- F
    return vector3(coord.x, coord.y, coord.z - delta)
  elseif IsDisabledControlPressed(0, 140) then -- R
    return vector3(coord.x, coord.y, coord.z + delta)
  elseif IsDisabledControlJustPressed(0, 47) then -- G
    local success, groundZ = GetGroundZFor_3dCoord(coord.x, coord.y, coord.z + 0.1, 0)
    if not success then
      print("Coord-line: Point is below the ground, raise above the ground and try pressing G again!")
    else
      return vector3(coord.x, coord.y, groundZ)
    end
    return coord
  else
    return coord
  end
end

function handleArrowInput(center, heading)
  if blockinput then return center end
  delta = 0.05
  DisableControlAction(0, 36, true)
  if IsDisabledControlPressed(0, 36) then -- ctrl held down
    delta = 0.01
  end
  DisableControlAction(0, 27, true)
  if IsDisabledControlPressed(0, 27) then -- arrow up
    local newCenter =  rotate(center, vector3(center.x, center.y + delta, center.z), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end
  if IsControlPressed(0, 173) then -- arrow down
    local newCenter =  rotate(center, vector3(center.x, center.y - delta, center.z), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end
  if IsControlPressed(0, 174) then -- arrow left
    local newCenter =  rotate(center, vector3(center.x - delta, center.y, center.z), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end
  if IsControlPressed(0, 175) then -- arrow right
    local newCenter =  rotate(center, vector3(center.x + delta, center.y, center.z), heading)
    return vector3(newCenter.x, newCenter.y, center.z)
  end
  return center
end

function handleNumberInput(num)
  if blockinput then return num end
  local one, two, three = 157, 158, 160
  DisableControlAction(0, one, true)
  DisableControlAction(0, two, true)
  DisableControlAction(0, three, true)

  if IsDisabledControlJustPressed(0, one) then
    return 1
  elseif IsDisabledControlJustPressed(0, two) then
    return 2
  elseif IsDisabledControlJustPressed(0, three) then
    return 3
  else
    return num
  end
end