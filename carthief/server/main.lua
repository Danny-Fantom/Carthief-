ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('boostPhone', function(playerId)
    TriggerClientEvent('esx_carthief:boost', playerId)
end)

local activity = 0
local activitySource = 0
local cooldown = 0

RegisterServerEvent('esx_carthief:pay')
AddEventHandler('esx_carthief:pay', function(payment)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addAccountMoney('black_money',tonumber(payment))
	
	--Add cooldown
	cooldown = Config.CooldownMinutes * 60000
	--melding
	TriggerClientEvent('okokNotify:Alert', source, "SUCCESS", "Je hebt " .. payment .. " betaald gekregen", 10000, 'success')
end)

RegisterServerEvent('esx_carthief:addBorg')
AddEventHandler('esx_carthief:addBorg', function(payment)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addAccountMoney('bank',tonumber(payment))
	--melding
	TriggerClientEvent('okokNotify:Alert', source, "SUCCESS", "Je hebt " .. payment .. " borg terug gekregen", 10000, 'success')
end)

RegisterServerEvent('esx_carthief:removeBorg')
AddEventHandler('esx_carthief:removeBorg', function(payment)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeAccountMoney('bank',tonumber(payment))
	--melding
	TriggerClientEvent('okokNotify:Alert', source, "SUCCESS", "Er is " .. payment .. " af geschreven als borg", 10000, 'success')
end)

RegisterServerEvent('esx_carthief:geefContract')
AddEventHandler('esx_carthief:geefContract', function(data)
	--cb(data)
	if data == "D" then
		cb(true)
	end
	if data == "S+" then
		data = 'SS'
	end
	string = data .. 'boost' -- Cboost
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(string,1)

end)

RegisterServerEvent('esx_carthief:removeContract')
AddEventHandler('esx_carthief:removeContract', function(data)
	--cb(data)
	if data == "D" then
		cb(true)
	end
	if data == "S+" then
		data = 'SS'
	end
	string = data .. 'boost' -- Cboost
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(string,1)

end)

ESX.RegisterServerCallback('esx_carthief:hascontract', function(source, cb, data)
	--cb(data)
	if data == "D" then
		cb(true)
	end
	if data == "S+" then
		data = 'SS'
	end
	string = data .. 'boost' -- Cboost
	local xPlayer = ESX.GetPlayerFromId(source)
	if(xPlayer.getInventoryItem(string).count > 0) then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_carthief:anycops',function(source, cb)
  local anycops = 0
  local playerList = ESX.GetPlayers()
  for i=1, #playerList, 1 do
    local _source = playerList[i]
    local xPlayer = ESX.GetPlayerFromId(_source)
    local playerjob = xPlayer.job.name
    if playerjob == 'police' or playerjob == 'kmar' then
      anycops = anycops + 1
    end
  end
  cb(anycops)
end)

ESX.RegisterServerCallback('esx_carthief:isActive',function(source, cb)
  cb(activity, cooldown)
end)

RegisterServerEvent('esx_carthief:registerActivity')
AddEventHandler('esx_carthief:registerActivity', function(value)
	activity = value
end)

RegisterServerEvent('esx_carthief:registerCops')
AddEventHandler('esx_carthief:registerCops', function(boostType)
	if true then
		activitySource = source
		--Send notification to cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'kmar' then
				TriggerClientEvent('esx_carthief:setcopnotification', xPlayers[i],boostType)
			end
		end
	else
		activitySource = 0
	end
end)

RegisterServerEvent('esx_carthief:alertcops')
AddEventHandler('esx_carthief:alertcops', function(cx,cy,cz)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'kmar' then
			TriggerClientEvent('esx_carthief:setcopblip', xPlayers[i], cx,cy,cz)
		end
	end
end)

RegisterServerEvent('esx_carthief:stopalertcops')
AddEventHandler('esx_carthief:stopalertcops', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'kmar' then
			TriggerClientEvent('esx_carthief:removecopblip', xPlayers[i])
		end
	end
end)

AddEventHandler('playerDropped', function ()
	local _source = source
	if _source == activitySource then
		--Remove blip for all cops
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' or xPlayer.job.name == 'kmar' then
				TriggerClientEvent('esx_carthief:removecopblip', xPlayers[i])
			end
		end
		--Set activity to 0
		activity = 0
		activitySource = 0
		cooldown = 0
	end
end)

--Cooldown manager
AddEventHandler('onResourceStart', function(resource)
	while true do
		Wait(5000)
		if cooldown > 0 then
			cooldown = cooldown - 5000
		end
	end
end)
