local maxDistance = 30.0
local edgePointRadius = 0.1
local coordRadius = 0.08
local coordCount = 1
local startPoint, endPoint
local pointMoveSelection = 1

local creationEnabled = false
RegisterCommand("coordline", function(src, args)
  local command = args[1]
  if command == "start" then
    creationEnabled = true
    startCreation()
  elseif command == "end" then
    creationEnabled = false
  elseif command == "save" then
    if not startPoint or not endPoint then return end
    local name = GetUserInput("Enter name of coord-line:", "", 30)
    if name == nil then return end
    -- Space between each marker
    local endToStart = endPoint - startPoint
    local coordDelta = endToStart / coordCount
    local halfDelta = coordDelta / 2
    local coords = {}
    for i=1, coordCount do
      local coord = coordDelta * i + startPoint - halfDelta
      coords[#coords + 1] = coord
    end
    TriggerServerEvent("coord-line:save", {startPoint=startPoint, endPoint=endPoint, coords=coords, name=name})
    creationEnabled = false
  elseif command == "last" then
    creationEnabled = true
    startCreation(true)
  end
end)
Citizen.CreateThread(function()
  TriggerEvent('chat:addSuggestion', '/coordline', '', {
    {name="command", help="{start, end, last, save} (required)"},
  })
end)

function startCreation(last)
  if not creationEnabled then return end
  if not last then
    coordCount, startPoint, endPoint = 1, nil, nil
  end
  pointMoveSelection = 1
  Citizen.CreateThread(function()
    while creationEnabled do
      if not startPoint or not endPoint then
        handlePoints()
      else
        handleCoords()
      end
      Wait(0)
    end
  end)
end

function handleCoords()
  -- Space between each marker
  local endToStart = endPoint - startPoint
  local coordDelta = endToStart / coordCount
  local halfDelta = coordDelta / 2
  for i=1, coordCount do
    local coord = coordDelta * i + startPoint - halfDelta
    DrawSphere(coord, coordRadius, 255, 0, 255, 255)
  end
  drawPoints()
  DrawLine(startPoint, endPoint, 0, 127, 255, 255)

  -- Check scroll wheel for input to change coordCount
  BlockWeaponWheelThisFrame()
  DisableControlAction(0, 81, true)
  if IsDisabledControlJustPressed(0, 81) then -- scroll down
    coordCount = math.max(coordCount - 1, 1)
  end
  DisableControlAction(0, 99, true)
  if IsDisabledControlJustPressed(0, 99) then -- scroll up
    coordCount = coordCount + 1
  end

  -- Find closest point the player is looking at between startPoint and endPoint
  -- and handle arrow input for moving that point
  pointMoveSelection = handleNumberInput(pointMoveSelection)
  local rot = GetGameplayCamRot(2)
  if pointMoveSelection == 1 or pointMoveSelection == 3 then
    startPoint = handleArrowInput(startPoint, rot.z)
  end
  if pointMoveSelection == 2 or pointMoveSelection == 3 then
    endPoint = handleArrowInput(endPoint, rot.z)
  end
end

function handlePoints()
  local hit, pos, _, _ = RayCastGamePlayCamera(maxDistance)
  pos = vector3(pos.x, pos.y, pos.z + 0.1)
  if hit then
    drawPoints(pos)
    if startPoint and not endPoint then
      DrawLine(startPoint, pos, 0, 127, 255, 255)
    end
    if IsControlJustPressed(0, 51) then
      if not startPoint then
        startPoint = pos
        print("Set startPoint:", startPoint)
      elseif not endPoint then
        endPoint = pos
        print("Set endPoint:", startPoint)
      end
    end
  end
  if startPoint and endPoint then
    DrawLine(startPoint, endPoint, 0, 127, 255, 255)
  end
end

function drawPoints(pos)
  if not startPoint then
    DrawSphere(pos, edgePointRadius, 0, 255, 0, 255)
  elseif not endPoint then
    DrawSphere(startPoint, edgePointRadius, 0, 255, 0, 255)
    DrawSphere(pos, edgePointRadius, 255, 0, 0, 255)
  else
    DrawSphere(startPoint, edgePointRadius, 0, 255, 0, 255)
    DrawSphere(endPoint, edgePointRadius, 255, 0, 0, 255)
  end
end