function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
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
  local out = printoutHeader(coordline.name)
  out = out .. "startPoint = " .. coordline.startPoint .. "\n"
  out = out .. "endPoint = " .. coordline.endPoint  .. "\n"
  local coords = coordline.coords
  out = out .. "coords = {" .. "\n"
  for i=1, #coords do
    out = out .. "  " .. roundVec(coords[i], 2) .. "," .. "\n"
  end
  out = out .. "}" .. "\n\n"
  return out
end

