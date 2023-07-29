local webhook = ''

exports('GiveVip', function(id, typevip)
    local car, ped, money = nil, nil, nil
        local xPlayer = ESX.GetPlayerFromId(tonumber(id))
        for k,v in pairs(Config.Vips) do
            if typevip == v.Name then 
                car = v.Cars
                ped = v.Ped
                money = v.Money
            end 
        end
        if xPlayer then
            TriggerEvent('fly:givevip', tonumber(id), typevip, car, ped, money)
        else   
            TriggerEvent('fly:givevipident', id, typevip, car, ped, money)
        end
end)

exports('GenerateCode', function(typevip)
    local car, ped,money = nil, nil, nil
    for k,v in pairs(Config.Vips) do
        if typevip == v.Name then 
            car = v.Cars
            ped = v.Ped
            money = v.Money
        end 
    end
    a = string.random(13)
    MySQL.Sync.execute('INSERT INTO fly_vip (identifier, code, vip ,car, ped, money) VALUES (@identifier, @code,@vip, @car, @ped, @money)', {
        ['identifier'] = 'notredeem',
        ['@code'] = a,
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
end)

exports('GetVipInfo', function(id)
    local info = {
        options = {},
    }
    for k,v in pairs(Config.Vips) do
        table.insert(info.options, {label = v.Name, value = v.Name, emoji = v.Emoji, ped = v.Ped, cars = v.Cars, money = v.Money, id = id } )
    end
    TriggerEvent("fly_vipsystemv2:SendInfo",info)
end)

exports('SearchVip', function()
    TriggerEvent('fly:searchvip')
end)

exports('SetPed', function(id, haskey)
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            TriggerEvent('fly:setpedid', id, haskey)          
        else
        TriggerEvent('fly:setpedident', id, haskey)
    end 
end)

exports('Removevip', function(id)
    local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then    
                TriggerEvent('fly:removevip', xPlayer.getIdentifier())
        else
            TriggerEvent('fly:removevip', id)
        end 
end)


RegisterNetEvent('fly:checkid')
AddEventHandler('fly:checkid', function(idplayer)
    local Player = ESX.GetPlayerFromId(source)
    local name = GetPlayerName(idplayer)
        local xPlayer = ESX.GetPlayerFromId(idplayer)
        if xPlayer then
            TriggerClientEvent('fly:confirmid',  -1, idplayer, name)
        else   
            idplayer = 'N/A'
            name = 'N/A'
            TriggerClientEvent('fly:confirmid',  -1, idplayer, name)
            Player.showNotification("This player is not online")
    end 
end)

RegisterNetEvent('code:generate')
AddEventHandler('code:generate', function(typevip, car, ped, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    a = string.random(13)
    MySQL.Sync.execute('INSERT INTO fly_vip (identifier, code, vip ,car, ped, money) VALUES (@identifier, @code,@vip, @car, @ped, @money)', {
        ['@identifier'] = 'notredeem',
        ['@code'] = a,
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
    xPlayer.showNotification("You generated a VIP code, check the log channel to see the code generated")
    LogDiscord("License: **"..xPlayer.identifier.."** has generated the code `"..a.."` with category "..typevip.."")
end)

RegisterNetEvent('fly:givevip')
AddEventHandler('fly:givevip', function(id, typevip, car, ped, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerVIP = ESX.GetPlayerFromId(id)
    a = string.random(13)
    local result = MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier', {['@identifier'] = PlayerVIP.getIdentifier()})
    if result[1] == nil then
    MySQL.Sync.execute('INSERT INTO fly_vip (code, identifier, vip ,car, ped, money) VALUES (@code, @identifier,@vip, @car, @ped, @money)', {
        ['@code'] = a,
        ['@identifier'] = PlayerVIP.getIdentifier(),
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
    PlayerVIP.showNotification("You have been granted VIP privilege")
         if xPlayer then
            xPlayer.showNotification("You gave VIP privileges to the player with ID: "..id)
            LogDiscord("License: **"..xPlayer.getIdentifier().."** Steam Name: **"..xPlayer.GetPlayerName().."** has given him a vip "..typevip.." to License: **"..PlayerVIP.getIdentifier().."** Steam Name: **"..PlayerVIP.getName().."**")
            else
                local embed = {
                    color = "GOLD", 
                    title = 'Error',
                    description = ' You gave VIP privileges to the player with ID: '..PlayerVIP.getIdentifier()..'  `'..a..'`'
                }
                TriggerEvent('fly_vipsystemv2:SendEmbed', embed)
        end
    else
        if xPlayer then
            xPlayer.showNotification("Already vip")
        else
            local embed = {
                color = "RED", 
                title = 'Error',
                description = ' Already vip.'
            }
            TriggerEvent('fly_vipsystemv2:SendEmbed', embed)
        end
    end
end)

RegisterNetEvent('fly:givevipident')
AddEventHandler('fly:givevipident', function(id, typevip, car, ped, money)
    a = string.random(13)
    MySQL.Sync.execute('INSERT INTO fly_vip (code, identifier, vip ,car, ped, money) VALUES (@code, @identifier,@vip, @car, @ped, @money)', {
        ['@code'] = a,
        ['@identifier'] = id,
        ['@vip'] = typevip,
        ['@car'] = car,
        ['@ped'] = ped,
        ['@money'] = money
    })
    local embed = {
        color = "GOLD", 
        title = 'SUCCESS',
        description = ' You gave VIP privileges to the player with ID: '..id.. '`'..a..'`'
    }
    TriggerEvent('fly_vipsystemv2:SendEmbed', embed)
end)

-- For UI Panel
RegisterNetEvent('fly:delvip')
AddEventHandler('fly:delvip', function(id)
    MySQL.Async.execute("DELETE FROM fly_vip WHERE id = @id",{['@id'] = id}) 
end)

-- For Discord Function
RegisterNetEvent('fly:removevip')
AddEventHandler('fly:removevip', function(player)
    MySQL.Async.execute("DELETE FROM fly_vip WHERE identifier = @identifier",{['@identifier'] = player}) 
    local embed = {
        color = "RED", 
        title = 'Error',
        description = ' Player '..player..' vip has been withdrawn.'
    }
    TriggerEvent('fly_vipsystemv2:SendEmbed', embed)
end)

RegisterNetEvent('fly:redeem')
AddEventHandler('fly:redeem', function(code)
    local source = source
    print(code, source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE code = @code', {['@code'] = code})
    if result[1] ~= nil then
        local result2 = MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier AND code = @code', {['@code'] = code, ['@identifier'] = 'notredeem'})
        
        if result2[1] ~= nil then
        xPlayer.showNotification("Congratulations, you now have access to VIP privileges")
        MySQL.Sync.execute('UPDATE fly_vip SET identifier = @identifier WHERE code = @code', {
            ['@identifier'] = xPlayer.getIdentifier(),
            ['@code'] = code
        })
        else
            xPlayer.showNotification("Someone already redeemed this code")
        end
    else
        xPlayer.showNotification("Invalid code")
    end
end)




local charset = {}

for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end


function string.random(length)
	math.randomseed(os.time())
	if length > 0 then
		return string.random(length - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end


ESX.RegisterServerCallback("fly:vipplayers", function(source, cb)
	
	local playersvip = {}

	MySQL.Async.fetchAll("SELECT identifier FROM fly_vip WHERE identifier != @identifier", { ["@identifier"] = 'notredeem' }, function(result)

		for i = 1, #result, 1 do
			table.insert(playersvip, {identifier = result[i].identifier })
		end

		cb(playersvip)
	end)
end)

RegisterNetEvent('fly:searchvip')
AddEventHandler('fly:searchvip', function()
    MySQL.Async.fetchAll("SELECT * FROM fly_vip ", function(result)
        local embed = {
            fields = {},
            color = "#2f3136", 
            title = 'Results',
            description = ''
        }
		for i = 1, #result, 1 do
			table.insert(embed.fields, {name = '`'..result[i].code..'`' , value = result[i].identifier,  inline = true})
		end
        TriggerEvent('fly_vipsystemv2:SendEmbed', embed)

	end)
	
end)




ESX.RegisterCommand('vippanel', "admin", function(xPlayer, args, showError)
    xPlayer.triggerEvent('open:panel')
end)

RegisterNetEvent('fly:showlist')
AddEventHandler('fly:showlist', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    print(source)
    local result = MySQL.Sync.fetchAll("SELECT * FROM fly_vip ")
    if result[1] ~= nil then
        for i = 1, #result, 1 do
            xPlayer.triggerEvent('show:list', result[i].id, result[i].code, result[i].identifier, result[i].vip, result[i].car, result[i].ped, result[i].money)
        end
    else
        xPlayer.triggerEvent('show:list', 'No data available', 'No data available', 'No data available', 'No data available', 'No data available', 'No data available', 'null')
    end
end)


RegisterCommand('vipmenu', function(source)
    TriggerEvent("fly:checkvip", source)
end)

local totalcars, haveped, totalmoney = nil, nil, nil
RegisterNetEvent('fly:checkvip')
AddEventHandler('fly:checkvip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local result =  MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier', {['@identifier'] = xPlayer.getIdentifier()})
    if result[1] ~= nil then
        xPlayer.triggerEvent('fly:success', result[1].vip, result[1].car, result[1].ped, result[1].money)
    else
        xPlayer.triggerEvent('panelnovip')
    end
end)


RegisterNetEvent('fly:checkped')
AddEventHandler('fly:checkped', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
	local result =  MySQL.Sync.fetchAll('SELECT ped FROM fly_vip WHERE identifier = @identifier', {['@identifier'] = xPlayer.getIdentifier()})
    if result[1] ~= nil then
        xPlayer.triggerEvent('fly:spawnped', result[1].ped)
    end
end)

RegisterNetEvent('fly:setped')
AddEventHandler('fly:setped', function(id, haskeyped)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result =  MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE id = @id AND ped != @ped', {['@id'] = id, ['@ped'] = 'notavailable'})
    if result[1] ~= nil then
    MySQL.Sync.execute('UPDATE fly_vip SET ped = @ped WHERE id = @id ', {
        ['@id'] = id,
        ['@ped'] = haskeyped,
    })
    xPlayer.showNotification('You have given the ped '..haskeyped)
    else
        if xPlayer then
        xPlayer.showNotification("Player vip does not allow peds")
        else
            local embed = {
                color = "RED", 
                title = 'Error',
                description = ' Player vip does not allow peds'
            }
            TriggerEvent('fly_vipsystemv2:SendEmbed', embed)
        end
    end
end)

-- to prevent bugs
RegisterNetEvent('fly:setpedident')
AddEventHandler('fly:setpedident', function(id, haskeyped)
    print(id, haskeyped)
    local result =  MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier AND ped != @ped', {['@identifier'] = id, ['@ped'] = 'notavailable'})
    if result[1] ~= nil then
    MySQL.Sync.execute('UPDATE fly_vip SET ped = @ped WHERE identifier = @identifier ', {
        ['@identifier'] = id,
        ['@ped'] = haskeyped,
    })
    local embed = {
        color = "GREEN", 
        title = 'Success',
        description = ' Ped '..result[1].ped..' changed to '..haskeyped..' for '..id
    }
    TriggerEvent('fly_vipsystemv2:SendEmbed', embed)  
    else
            local embed = {
                color = "RED", 
                title = 'Error',
                description = ' Player vip does not allow peds'
            }
            TriggerEvent('fly_vipsystemv2:SendEmbed', embed)  
    end
end)


RegisterNetEvent('fly:setpedid')
AddEventHandler('fly:setpedid', function(player, haskeyped)
    local xPlayer = ESX.GetPlayerFromId(player)
    local result =  MySQL.Sync.fetchAll('SELECT * FROM fly_vip WHERE identifier = @identifier AND ped != @notped', {['@identifier'] = xPlayer.getIdentifier(), ['@notped'] = 'notavailable'})
    if result[1] ~= nil then
    MySQL.Sync.execute('UPDATE fly_vip SET ped = @ped WHERE identifier = @identifier ', {
        ['@identifier'] = xPlayer.getIdentifier(),
        ['@ped'] = haskeyped,
    })
    local embed = {
        color = "GREEN", 
        title = 'Success',
        description = ' Ped '..result[1].ped..' changed to '..haskeyped..' for '..xPlayer.getIdentifier()
    }
    TriggerEvent('fly_vipsystemv2:SendEmbed', embed)
    else
        local embed = {
            color = "RED", 
            title = 'Error',
            description = ' Player vip does not allow peds'
        }
        TriggerEvent('fly_vipsystemv2:SendEmbed', embed)
    end
end)

RegisterNetEvent('claim:money')
AddEventHandler('claim:money', function(quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result =  MySQL.Sync.fetchAll('SELECT money FROM fly_vip WHERE identifier = @identifier AND money != 0', {['@identifier'] = xPlayer.getIdentifier()})
    if result[1] ~= nil then
        print(quantity)
        xPlayer.addAccountMoney('bank', quantity)
        xPlayer.showNotification('You received the $'..quantity..' reward for being vip')
        MySQL.Sync.execute('UPDATE fly_vip SET money = money - @quantity WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier(),
            ['@quantity'] = quantity
        })
    else
        xPlayer.showNotification('You have already made use of this reward')
    end
end)

RegisterServerEvent('fly:givecar')
AddEventHandler('fly:givecar', function (model, vehicleprops)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored, type) VALUES (@owner, @plate, @vehicle, @stored, @type)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleprops.plate,
		['@vehicle'] = json.encode(vehicleprops),
        ['@type']  = 'car',
		['@stored']  = 1
	}, function ()
        xPlayer.showNotification("You have received your "..model..", enjoy it")
	end)
    MySQL.Sync.execute('UPDATE fly_vip SET car = car - 1 WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.getIdentifier()
    })
end)



function LogDiscord(msg)
    if webhook~=nil then
        PerformHttpRequest(webhook, function(a,b,c)end, "POST", json.encode({embeds={{title="Fly VIP V2 Logs",description=msg}}}), {["Content-Type"]="application/json"})
    end
end

