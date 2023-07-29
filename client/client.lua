-- ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)
local IsDead = false

RegisterNetEvent('open:panel')
AddEventHandler('open:panel', function()    
   if not IsDead then
    for k,v in pairs(Config.Vips) do
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open_panel",
         viptypes = v.Name
    })
        end
    end
end)

RegisterNetEvent('show:list')
AddEventHandler('show:list', function(id, code, ident, vip, car, ped,money)    

    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "show_list",
        id = id,
         code = code, 
         ident = ident, 
         vip = vip, 
         car = car, 
         ped = ped,
         money = money
    })

end)


RegisterNetEvent('panelnovip')
AddEventHandler('panelnovip', function()    
    if not IsDead then
    SetNuiFocus(true, true)
    SendNUIMessage({
        type="open_novip"
    })
    end
end)


RegisterNetEvent('fly:confirmid')
AddEventHandler('fly:confirmid', function(idplayerconfirm, nameplayer)
    SendNUIMessage({
        action = "updatename",
        nameplayer = nameplayer
    })
end)



function TypeMenuGenerate(typevip, idpjs)
    for k,v in pairs(Config.Vips) do
        if typevip == v.Name then 
            if idpjs == 0 then
            TriggerServerEvent('code:generate', v.Name, v.Cars, v.Ped, v.Money)
            break
            else
                TriggerServerEvent('fly:givevip', idpjs, v.Name, v.Cars, v.Ped, v.Money)   
                break
            end  
        end
    end
end


RegisterNetEvent('fly:success')
AddEventHandler('fly:success', function(vip, cars, peds, moneyx2)
    if not IsDead then
        for k,v in pairs(Config.Cars) do
            if vip == v.category then    
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "open_vip",
            vip = vip,
            cars = cars, 
            peds = peds, 
            moneyx2 = moneyx2,
            carmodel = v.model,
            carslabel = v.label,
            imagen = v.imagen
        })
            end
        end
    end
end)

RegisterNetEvent('fly:spawnped')
AddEventHandler('fly:spawnped', function(ped)
    if ped ~= 'notavailable' or ped ~= '1' then
        local modelHash = GetHashKey(ped)
        SetPedDefaultComponentVariation(PlayerPedId())
        ESX.Streaming.RequestModel(modelHash, function()
            SetPlayerModel(PlayerId(), modelHash)
            SetPedDefaultComponentVariation(PlayerPedId())
            SetModelAsNoLongerNeeded(modelHash)
            TriggerEvent('esx:restoreLoadout')
            SetPedComponentVariation(PlayerPedId(), 8, 0, 0, 2)
        end)
    else
        ESX.ShowNotification("Your vip is not entitled to a ped or you do not have one assigned")
    end
end)

RegisterNetEvent('fly:resetskin')
AddEventHandler('fly:resetskin', function()
    local hp = GetEntityHealth(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
                TriggerEvent('dpc:ApplyClothing')
                SetEntityHealth(PlayerPedId(), hp)
            end)
        end)
    end)
end)


RegisterNUICallback("action", function(data)
    if  data.action == "showlist" then
        TriggerServerEvent("fly:showlist")
    elseif data.action == "gencode" then
        TypeMenuGenerate(data.tvip, 0)
    elseif data.action == "checkid" then
        TriggerServerEvent('fly:checkid', data.id)
    elseif data.action == "givevip" then
        TypeMenuGenerate(data.tvip2, tonumber(data.idp))
    elseif data.action == "claimcar" then 
        local coords    = GetEntityCoords(PlayerPedId())
        ESX.Game.SpawnVehicle(data.carclaimed, coords, 0.0, function(vehicle) 
            if DoesEntityExist(vehicle) then

                local vehicleprops = ESX.Game.GetVehicleProperties(vehicle)
                SetPedIntoVehicle(PlayerPedId(),vehicle,-1)
                TriggerServerEvent('fly:givecar', data.carclaimed, vehicleprops)	
            end		
        end)
    elseif data.action == "withdraw" then
        TriggerServerEvent('claim:money', data.moneyw)
    elseif data.action =="changeped" then
        TriggerServerEvent('fly:setped', data.id, data.ped)
    elseif data.action == "spawnped" then
        TriggerEvent('fly:spawnped', data.playerped)
    elseif data.action == "resetskin" then
        TriggerEvent('fly:resetskin')
    elseif data.action == "delvip" then
        TriggerServerEvent("fly:delvip", data.idvip)
    elseif data.action == "redeemvip" then
        TriggerServerEvent('fly:redeem', data.code)
    end
end)

RegisterNUICallback("NUIFocusOff", function(data,cb) 
    SetNuiFocus(false, false)
    cb({})
end)




AddEventHandler('esx:onPlayerDeath', function(data)
    IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    IsDead = false
end)
