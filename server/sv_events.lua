RegisterNetEvent("coord-line:save")
AddEventHandler("coord-line:save", function(coordline)
  local resname = GetCurrentResourceName()
  local txt = LoadResourceFile(resname, "coordlines.txt") or ""
  local newTxt = txt .. formatCoordline(coordline)
  SaveResourceFile(resname, "coordlines.txt", newTxt, -1)
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
