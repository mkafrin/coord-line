RegisterNetEvent("coord-line:save")
AddEventHandler("coord-line:save", function(coordline)
  local resname = GetCurrentResourceName()
  local format = GetFormat(coordline.name)
  local path = format.getFilePath(coordline)
  local txt = ""
  if format.shouldAppend then
    local oldTxt = LoadResourceFile(resname, path)
    if oldTxt then txt = oldTxt end
  end
  local newTxt = txt .. formatCoordline(coordline, format)
  SaveResourceFile(resname, path, newTxt, -1)
end)

RegisterNetEvent("coord-line:getFormats")
AddEventHandler("coord-line:getFormats", function()
  local src = source
  local out = ""
  local formats = GetFormats()
  for i, v in ipairs(formats) do
    out = out .. v
    if i < #formats then out = out .. ", " end
  end
  TriggerClientEvent("coord-line:formats", src, out)
end)
