-- ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local idplayer, rname, type, vips, car, ped, money, useped = 'N/A', 'N/A', 'N/A', 'N/A', nil, nil, nil, false
local open = false

RegisterNetEvent('open:panel')
AddEventHandler('open:panel', function(id, code, ident, vip, car, ped,money)    
    open = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "open_panel",
        id = id,
         code = code, 
         ident = ident, 
         vip = vip, 
         car = car, 
         ped = ped,
         money = money
    })
end)

function PlayerPanel(player)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'playerpanel', {
        title = 'Player management',
        align = 'right',
        elements = {
            {label = 'Set Ped', value = 'setped'},
            {label = 'Remove VIP', value = 'removevip'},
            {label = '<span style = color:red; span>Close</span>', value = 'close'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'setped' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'ped', {
                    title = 'Name PED'
                    }, function(data2, menu2)
                         haskeyped = data2.value
                         	menu2.close()
                            TriggerServerEvent('fly:setped', player, haskeyped)
                        end, function(data, menu)
                      menu.close()
                end)
            elseif action == 'removevip' then
                RemoveVIP(player)
            elseif action == 'close' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
end

RegisterNetEvent('fly:confirmid')
AddEventHandler('fly:confirmid', function(idplayerconfirm, nameplayer)
    SendNUIMessage({
        action = "updatename",
        nameplayer = nameplayer
    })
end)
function GivePanel()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'givepanel', {
        title = 'VIP Admin Menu',
        align = 'right',
        elements = {
            {label = 'ID: '..idplayer, value = 'id'},
            {label = 'Name: '..rname, value = nil},
            {label = 'Type: '..type, value = 'type'},
            {label = 'Confirm', value = 'confirm'}, 
            {label = '<span style = color:red; span>Close</span>', value = 'close'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'id' then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'tag', {
                    title = 'ID Player'
                    }, function(data2, menu2)
                         idplayer = tonumber(data2.value)
                         	menu2.close()
                            TriggerServerEvent('fly:checkid', idplayer)
							-- realid = GetPlayerServerId(PlayerId(idplayer))
							-- rname  = GetPlayerName(PlayerId(realid))
                            menu.close()
                            -- GivePanel()
                        end, function(data, menu)
                      menu.close()
                end)
            elseif action == 'type' then
                TypeMenu()
            elseif action == 'confirm' then
                TriggerServerEvent('give:vip', realid, type, car, ped, money)
                idplayer = 'N/A'
                rname = 'N/A'
                type = 'N/A'
                realid = nil
                car = nil
                money = nil
                ped = nil
                menu.close()
            elseif action == 'close' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
            idplayer = 'N/A'
            rname = 'N/A'
            type = 'N/A'
            realid = nil
            car = nil
            money = nil
            ped = nil
    end)
end

function RemoveVIP(player)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'removepanel', {
        title = 'VIP Admin Menu',
        align = 'right',
        elements = {
            {label = 'Remove VIP', value = 'remove'},
            {label = '<span style = color:red; span>Close</span>', value = 'close'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'remove' then
                TriggerServerEvent("fly:removevip", player)
                ESX.ShowNotification("You removed the VIP privilege of the player with identifier "..player)
                menu.close()
            elseif action == 'close' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
  
end

function TypeMenu()
    local elements = {}
    for k,v in pairs(Config.Vips) do
        table.insert(elements, {label = "VIP: " .. v.Name .." | Cars:".. v.Cars .. "| Ped?: ".. v.Ped .. "| Money: "..v.Money,  value = v.Name, cars = v.Cars, peds = v.Ped, moneyy = v.Money })
    end

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vip_type',
        {
            title = "Type VIP",
            align = "right",
            elements = elements
        },
    function(data2, menu2)

        local action = data2.current.value
        if action then
            type = action
            car = data2.current.cars
            ped = data2.current.peds
            money = data2.current.moneyy
            GivePanel() 
        end
        menu2.close()

    end, function(data2, menu2)
        menu2.close()
    end)
end

function TypeMenuGenerate(typevip, idpjs)
    for k,v in pairs(Config.Vips) do
        if typevip == v.Name then 
            if idpjs == 0 then
            TriggerServerEvent('code:generate', v.Name, v.Cars, v.Ped, v.Money)
            break
            else
                TriggerServerEvent('give:vip', idpjs, v.Name, v.Cars, v.Ped, v.Money)   
                break
            end  
        end
    end
end


RegisterNetEvent('fly:success')
AddEventHandler('fly:success', function(vip, cars, peds, moneyx2)
    local elements = {}
    local id = GetPlayerServerId(PlayerId()) 
        table.insert(elements, {label = 'Your VIP: '..vip, value = nil})
        if cars ~= 0 then
        table.insert(elements, {label = 'Choose my cars ['..cars..']', value = 'choosecar'})
        end
        if not useped then
            table.insert(elements, {label = 'Use my ped ['..peds..']', value = 'ped'})
        else 
            table.insert(elements, {label = 'Restore Character', value = 'fixpj'})
        end
        if moneyx2 ~= 0 then
        table.insert(elements, {label = 'Claim my money $'..moneyx2, value = 'claimmoney'})
        end
        

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vipmenu', {
            title = 'VIP Menu', 
            align = 'right',
            elements = elements

        }, function(data, menu)
            local val = data.current.value
            if val == 'choosecar' then
                Menutochoosevehicle(vip, cars)
            elseif val == 'ped' then
                useped = true
                TriggerServerEvent('fly:checkped')
                 menu.close()
            elseif val == 'fixpj' then
                useped = false
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
                menu.close()
            elseif val == 'claimmoney' then
                TriggerServerEvent('claim:money')
            end
        end, function(data, menu)
            menu.close()
        end)

end)

RegisterNetEvent('fly:spawnped')
AddEventHandler('fly:spawnped', function(ped)
    if ped ~= 'notavailable' then
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
        ESX.ShowNotification("Your vip is not entitled to a ped")
    end
end)

function Menutochoosevehicle(vip, cars)
    local elements = {}  
    for k,v in pairs(Config.Cars) do
        if vip == v.category then
        table.insert(elements,{label = v.label, model = v.model, category = v.category})
        end
    end
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'vip_type',
        {
            title = "Choose your Car ["..cars.."]",
            align = "right",
            elements = elements
        },
    function(data2, menu2)

        local action = data2.current.model
        if action then
            local coords    = GetEntityCoords(PlayerPedId())
            ESX.Game.SpawnVehicle(action, coords, 0.0, function(vehicle) 
                if DoesEntityExist(vehicle) then

                    local vehicleprops = ESX.Game.GetVehicleProperties(vehicle)
                    SetPedIntoVehicle(PlayerPedId(),vehicle,-1)
                    TriggerServerEvent('fly:givecar', action, vehicleprops)	
                end		
            end)
            ESX.UI.Menu.CloseAll()
        end
        menu2.close()

    end, function(data2, menu2)
        menu2.close()
    end)
end


RegisterNUICallback("action", function(data)
    if data.action == "gencode" then
        TypeMenuGenerate(data.tvip, 0)
    elseif data.action == "checkid" then
        TriggerServerEvent('fly:checkid', data.id)
    elseif data.action == "givevip" then
        TypeMenuGenerate(data.tvip2, tonumber(data.idp))
    end
end)

RegisterNUICallback("NUIFocusOff", function(data,cb) 
    SetNuiFocus(false, false)
    cb({})
end)