local formatters = {}

function printoutHeader(name)
  return "-- Name: " .. (name or "") .. " | " .. os.date("!%Y-%m-%dT%H:%M:%SZ")
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%.".. numDecimalPlaces .. "f", num))
end

function roundVec(vec, numDecimalPlaces)
  return vector3(round(vec.x, numDecimalPlaces), round(vec.y, numDecimalPlaces), round(vec.z, numDecimalPlaces))
end

function AddFormat(name, getFilePath, shouldAppend, onBeforeVectors, onVectors, onAfterVectors)
  local format = {
    name = name,
    getFilePath = getFilePath,
    shouldAppend = shouldAppend,
    onBeforeVectors = onBeforeVectors,
    onVectors = onVectors,
    onAfterVectors = onAfterVectors,
  }
  formatters[name] = format
end

function GetFormat(name)
  if name == nil or name == "" or formatters[name] == nil then
    print("Warning: Format was either nil or not found. Falling back to default.")
    name = "default"
  end
  return formatters[name]
end

function GetFormats()
  local formats = {}
  for k, v in pairs(formatters) do formats[#formats+1] = v.name end
  return formats
end

function formatCoordline(coordline, format)
  local beforeText = format.onBeforeVectors(coordline)
  local vectorsText = format.onVectors(coordline)
  local afterText = format.onAfterVectors(coordline)
  return ("%s%s%s\n"):format(beforeText, vectorsText, afterText)
end