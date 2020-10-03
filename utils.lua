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
      return nil
    elseif keyboardStatus == 2 then -- cancelled
      return nil
    elseif keyboardStatus == 1 then -- finished editing
      return GetOnscreenKeyboardResult()
    else
      Wait(0)
    end
  end
end

function DrawSphere(pos, radius, r, g, b, a)
  DrawMarker(28, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, r, g, b, a, false, false, 2, nil, nil, false)
end

function handleArrowInput(center, heading)
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
