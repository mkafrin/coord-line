local formatters = {}

local function printoutHeader(name)
  return "-- Name: " .. (name or "") .. " | " .. os.date("!%Y-%m-%dT%H:%M:%SZ")
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%.".. numDecimalPlaces .. "f", num))
end

function roundVec(vec, numDecimalPlaces)
  return vector3(round(vec.x, numDecimalPlaces), round(vec.y, numDecimalPlaces), round(vec.z, numDecimalPlaces))
end

function AddFormat(name, onBeforeVectors, onVectors, onAfterVectors)
  local format = {
    name = name,
    onBeforeVectors = onBeforeVectors,
    onVectors = onVectors,
    onAfterVectors = onAfterVectors,
  }
  formatters[name] = format
end

function GetFormats()
  local formats = {}
  for k, v in pairs(formatters) do formats[#formats+1] = v.name end
  return formats
end

function formatCoordline(coordline)
  local formatName = coordline.format
  if formatName == nil or formatName == "" then
    print("Warning: Format was either nil or not found. Falling back to default.")
    formatName = "default"
  end
  local format = formatters[formatName]
  local headerText = printoutHeader(coordline.name)
  local beforeText = format.onBeforeVectors(coordline)
  local vectorsText = format.onVectors(coordline)
  local afterText = format.onAfterVectors(coordline)
  return ("%s\n%s%s%s\n"):format(headerText, beforeText, vectorsText, afterText)
end