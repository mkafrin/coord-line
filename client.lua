local maxDistance = 50.0
local edgePointRadius = 0.1
local coordRadius = 0.08
local coordCount = 1
local startPoint, endPoint
local heading = 0.1
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
    local finalHeading = math.floor(heading) % 360
    TriggerServerEvent("coord-line:save", {startPoint=startPoint, endPoint=endPoint, coords=coords, heading=finalHeading, name=name})
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
    coordCount, heading, startPoint, endPoint = 1, 0.1, nil, nil
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
  local up = vector3(0.0, 0.0, 0.25)
  for i=1, coordCount do
    local coord = coordDelta * i + startPoint - halfDelta
    DrawSphere(coord, coordRadius, 255, 0, 255, 255)
    DrawArrow(coord + up, coordRadius * 2.5, heading, 156, 0, 255, 255)
  end
  drawPoints()
  DrawLine(startPoint, endPoint, 0, 127, 255, 255)

  -- Check scroll wheel for input to change coordCount
  coordCount, heading = handleScrollWheel(coordCount, heading)

  -- Find closest point the player is looking at between startPoint and endPoint
  -- and handle arrow input for moving that point
  pointMoveSelection = handleNumberInput(pointMoveSelection)
  local rot = GetGameplayCamRot(2)
  if pointMoveSelection == 1 or pointMoveSelection == 3 then
    startPoint = handleArrowInput(startPoint, rot.z)
    startPoint = handleHeightInput(startPoint)
  end
  if pointMoveSelection == 2 or pointMoveSelection == 3 then
    endPoint = handleArrowInput(endPoint, rot.z)
    endPoint = handleHeightInput(endPoint)
  end
end

function handlePoints()
  local hit, pos, _, _ = RayCastGamePlayCamera(maxDistance)
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