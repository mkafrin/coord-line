function round(num, numDecimalPlaces)
  return tonumber(string.format("%.".. numDecimalPlaces .. "f", num))
end

function roundVec(vec, numDecimalPlaces)
  return vector3(round(vec.x, numDecimalPlaces), round(vec.y, numDecimalPlaces), round(vec.z, numDecimalPlaces))
end

function printoutHeader(name)
  return "-- Name: " .. (name or "") .. " | " .. os.date("!%Y-%m-%dT%H:%M:%SZ\n")
end

RegisterNetEvent("coord-line:save")
AddEventHandler("coord-line:save", function(coordline)
  local resname = GetCurrentResourceName()
  local txt = LoadResourceFile(resname, "coordlines.txt") or ""
  local newTxt = txt .. parseCoordline(coordline)
  SaveResourceFile(resname, "coordlines.txt", newTxt, -1)
end)

function parseCoordline(coordline)
  local fwdVectorHeading = math.rad(coordline.heading - 270.0)
  local fwdVector = vector3(math.cos(fwdVectorHeading), math.sin(fwdVectorHeading), 0.0)

  local out = printoutHeader(coordline.name)
  out = out .. "startPoint = " .. roundVec(coordline.startPoint, 3) .. "\n"
  out = out .. "endPoint = " .. roundVec(coordline.endPoint, 3)  .. "\n"
  out = out .. "fwdVector = " .. roundVec(fwdVector, 3) .. "\n"
  out = out .. "heading = " .. coordline.heading + 0.0 .. "\n"
  local coords = coordline.coords
  out = out .. "coords = {" .. "\n"
  for i=1, #coords do
    out = out .. "  " .. roundVec(coords[i], 3) .. "," .. "\n"
  end
  out = out .. "}" .. "\n\n"
  return out
end

