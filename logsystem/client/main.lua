local connections = {}
local kills = {}
local vehicles = {}
local weapons = {}
local chat = {}
local isAdmin = false

local firstSpawn = true
AddEventHandler("playerSpawned", function()
  if(firstSpawn) then
    TriggerServerEvent("logs:playerConnected")
    firstSpawn = false
  end
end)



Citizen.CreateThread(function()
  if(config.debug) then
    Citizen.Wait(1000)
    TriggerServerEvent("logs:playerConnected")
  end
  SetNuiFocus(false, false)

  SendNUIMessage({
    setResourceName = true,
    name = GetCurrentResourceName()
  })



  SendNUIMessage({
    setString = true,
    killercoords=getString("killercoords"),
    targetcoords=getString("targetcoords"),
    localisation=getString("localisation")
  })

  while true do
    Citizen.Wait(1)
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)

    if(IsControlJustPressed(1, config.openMenuKey) and (isAdmin or config.debug)) then
      SetNuiFocus(true, true)
      SendNUIMessage({
        show=true,
        connections=connections,
        kills=kills,
        vehicles=vehicles,
        weapons=weapons,
        chat=chat
      })
    end
  end

end)


RegisterNUICallback("closeMenu", function(data,cb)
  SetNuiFocus(false, false)
  cb("ok")
end)



function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end



RegisterNetEvent("logs:setAdmin")
AddEventHandler("logs:setAdmin", function(admin)
  isAdmin = admin
end)


RegisterNetEvent("logs:updateConnections")
AddEventHandler("logs:updateConnections", function(newArray)
  if(isAdmin or config.debug) then
    connections = newArray
  end
end)
RegisterNetEvent("logs:updateKills")
AddEventHandler("logs:updateKills", function(newArray)
  if(isAdmin or config.debug) then
    kills = newArray
  end
end)
RegisterNetEvent("logs:updateVehicles")
AddEventHandler("logs:updateVehicles", function(newArray)
  if(isAdmin or config.debug) then
    vehicles = newArray
  end
end)
RegisterNetEvent("logs:updateWeapons")
AddEventHandler("logs:updateWeapons", function(newArray)
  if(isAdmin or config.debug) then
    weapons = newArray
  end
end)
RegisterNetEvent("logs:updateChat")
AddEventHandler("logs:updateChat", function(newArray)
  if(isAdmin or config.debug) then
    chat = newArray
  end
end)
