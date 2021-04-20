local function onBeforeVectors(coordline)
  local formatString = [[
startPoint = %s
endPoint = %s
fwdVector = %s
heading = %s
]]

  local fwdVectorHeading = math.rad(coordline.heading - 270.0)
  local fwdVector = vector3(math.cos(fwdVectorHeading), math.sin(fwdVectorHeading), 0.0)

  return formatString:format(roundVec(coordline.startPoint, 3), roundVec(coordline.endPoint, 3), roundVec(fwdVector, 3), coordline.heading + 0.0)
end

local function onVectors(coordline)
  local coords = coordline.coords
  local formatString = "coords = {\n%s\n}\n"

  local coordsFormatted = ""
  for i = 1, #coords do
    local formattedCoord = "  " .. roundVec(coords[i], 3) .. ","
    if i < #coords then formattedCoord = formattedCoord .. "\n" end
    coordsFormatted = coordsFormatted .. formattedCoord
  end

  return formatString:format(coordsFormatted)
end

local function onAfterVectors(coordline)
  return ""
end

CreateThread(function()
  AddFormat("default", onBeforeVectors, onVectors, onAfterVectors)
end)
