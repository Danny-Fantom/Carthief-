ESX = nil
local PlayerData              	= {}
local currentZone               = ''
local LastZone                  = ''
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local aborted = false
local missieGaande = false
local heeftContract = false

local currentBoostType          = nil
local allspawnPoints            = {}
local alldisablers              = {}
local allDboosts                = {}
local allCboosts                = {}
local allBboosts                = {}
local allAboosts                = {}
local allSboosts                = {}
local allSSboosts               = {}
--local alldeliveries             = {}
local randomdelivery            = 1
local isDisabled                = 0
local isTaken                   = 0
local isDelivered               = 0
local car						= 0
local copblip
local deliveryblip


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

--Add all deliveries to the table and disablers
Citizen.CreateThread(function()
	--[[
	local deliveryids = 1
	for k,v in pairs(Config.Delivery) do
		table.insert(alldeliveries, {
				id = deliveryids,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		deliveryids = deliveryids + 1  
	end
	]]--
	local dboostID = 1
	for k,v in pairs(Config.Dboost) do
		table.insert(allDboosts, {
				id = dboostID,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		dboostID = dboostID + 1  
	end
	local cboostID = 1
	for k,v in pairs(Config.Cboost) do
		table.insert(allCboosts, {
				id = cboostID,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		cboostID = cboostID + 1  
	end
	local BboostID = 1
	for k,v in pairs(Config.Bboost) do
		table.insert(allBboosts, {
				id = BboostID,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		BboostID = BboostID + 1  
	end
	local AboostID = 1
	for k,v in pairs(Config.Aboost) do
		table.insert(allAboosts, {
				id = AboostID,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		AboostID = AboostID + 1  
	end
	local SboostID = 1
	for k,v in pairs(Config.Sboost) do
		table.insert(allSboosts, {
				id = SboostID,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		SboostID = SboostID + 1  
	end
	local SSboostID = 1
	for k,v in pairs(Config.SSboost) do
		table.insert(allSSboosts, {
				id = SSboostID,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				payment = v.Payment,
				car = v.Cars,
		})
		SSboostID = SSboostID + 1  
	end
	local disablerID = 1
	for k,v in pairs(Config.DisablerLocation) do
		table.insert(alldisablers, {
				id = disablerID,
				pos = v.Pos,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
		})
		disablerID = disablerID + 1  
	end
	local spawnID = 1
	for k,v in pairs(Config.VehicleSpawnPoint) do
		table.insert(allspawnPoints, {
				id = spawnID,
				posx = v.Pos.x,
				posy = v.Pos.y,
				posz = v.Pos.z,
				alpha = v.Pos.alpha
		})
		spawnID = spawnID + 1  
	end
end)

function SpawnCar(boostType)
	ESX.TriggerServerCallback('esx_carthief:hascontract', function(heeftContract)
		if heeftContract then
			ESX.TriggerServerCallback('esx_carthief:isActive', function(isActive, cooldown)
				if cooldown <= 0 then
					if isActive == 0 then
						ESX.TriggerServerCallback('esx_carthief:anycops', function(anycops)
							genoegPolitie = false
							if anycops > 0 and boostType == "D" then
								genoegPolitie = true
							end
							if anycops > 2 and boostType == "B" then
								genoegPolitie = true
							end
							if anycops > 3 and boostType == "C" then
								genoegPolitie = true
							end
							if anycops > 4 and boostType == "A" then
								genoegPolitie = true
							end
							if anycops > 5 and boostType == "S" then
								genoegPolitie = true
							end
							if anycops > 6 and boostType == "S+" then
								genoegPolitie = true
							end

							if genoegPolitie then
								aantaldisablers = 0
								TriggerServerEvent('esx_carthief:removeContract', boostType)
								if boostType == "D" then
									TriggerServerEvent('esx_carthief:removeBorg', 1000)
									aantaldisablers = 1
								end
								if boostType == "C" then
									TriggerServerEvent('esx_carthief:removeBorg', 2500)
									aantaldisablers = 1
								end
								if boostType == "B" then
									TriggerServerEvent('esx_carthief:removeBorg', 5000)
									aantaldisablers = 2
								end
								if boostType == "A" then
									TriggerServerEvent('esx_carthief:removeBorg', 10000)
									aantaldisablers = 4
								end
								if boostType == "S" then
									TriggerServerEvent('esx_carthief:removeBorg', 25000)
									aantaldisablers = 7
								end
								if boostType == "S+" then
									TriggerServerEvent('esx_carthief:removeBorg', 50000)
									aantaldisablers = 8
								end
								currentBoostType = boostType
								exports['okokNotify']:Alert('Auto-diefstal', 'Diefstal gestart! kijk op de map voor de rode circel en zoek de auto!', 10000, 'success')
								missieGaande = true
								isTaken = 0
								--Delete old vehicle and remove the old blip (or nothing if there's no old delivery)
								SetEntityAsNoLongerNeeded(car)
								DeleteVehicle(car)
								RemoveBlip(deliveryblip)
								--Register acitivity for server
								TriggerServerEvent('esx_carthief:registerActivity', 1)
								aborted = false
		
								--Get a random delivery point
								--randomdelivery = math.random(1,#alldeliveries)
								if(boostType == 'D') then
									randomdelivery = math.random(1,#allDboosts)
									randomcar = math.random(1,#allDboosts[randomdelivery].car)
									vehiclehash = GetHashKey(allDboosts[randomdelivery].car[randomcar])
									print(randomdelivery)
									print(randomcar)
								end
								if(boostType == 'C') then
									randomdelivery = math.random(1,#allCboosts)
									randomcar = math.random(1,#allCboosts[randomdelivery].car)
									vehiclehash = GetHashKey(allCboosts[randomdelivery].car[randomcar])
									print(randomdelivery)
									print(randomcar)
								end
								if(boostType == 'B') then
									randomdelivery = math.random(1,#allBboosts)
									randomcar = math.random(1,#allBboosts[randomdelivery].car)
									vehiclehash = GetHashKey(allBboosts[randomdelivery].car[randomcar])
									print(randomdelivery)
									print(randomcar)
								end
								if(boostType == 'A') then
									randomdelivery = math.random(1,#allAboosts)
									randomcar = math.random(1,#allAboosts[randomdelivery].car)
									vehiclehash = GetHashKey(allAboosts[randomdelivery].car[randomcar])
									print(randomdelivery)
									print(randomcar)
								end
								if(boostType == 'S') then
									randomdelivery = math.random(1,#allSboosts)
									randomcar = math.random(1,#allSboosts[randomdelivery].car)
									vehiclehash = GetHashKey(allSboosts[randomdelivery].car[randomcar])
									print(randomdelivery)
									print(randomcar)
								end
								if(boostType == 'S+') then
									randomdelivery = math.random(1,#allSSboosts)
									randomcar = math.random(1,#allSSboosts[randomdelivery].car)
									vehiclehash = GetHashKey(allSSboosts[randomdelivery].car[randomcar])
									print(randomdelivery)
									print(randomcar)
								end
								--randomcar = math.random(1,#alldeliveries[randomdelivery].car)
								--Get random location
								spawnPoint = math.random(1,#allspawnPoints)
								
								--Delete vehicles around the area (not sure if it works)
								ClearAreaOfVehicles(allspawnPoints[spawnPoint].posx, allspawnPoints[spawnPoint].posy, allspawnPoints[spawnPoint].posz, 10.0, false, false, false, false, false)
		
								-- blip setten naar auto
								RandomOffSet = math.random(50,150)
								carblip = AddBlipForRadius(allspawnPoints[spawnPoint].posx + RandomOffSet, allspawnPoints[spawnPoint].posy + RandomOffSet, allspawnPoints[spawnPoint].posz, 300.0) -- need to have .0
								SetBlipColour(carblip, 1)
								SetBlipAlpha(carblip, 128)
		
		
								--wachten tot persoon in range is
								doorgaan = true
								while doorgaan and not aborted do
									Wait(0)
									local coords = GetEntityCoords(GetPlayerPed(-1))
									if GetDistanceBetweenCoords(coords, allspawnPoints[spawnPoint].posx, allspawnPoints[spawnPoint].posy, allspawnPoints[spawnPoint].posz, true) < 100 then --persoon gaat in de auto
										doorgaan = false
									end
								end
		
		
								--Spawn Car
								--local vehiclehash = GetHashKey(alldeliveries[randomdelivery].car[randomcar])
								RequestModel(vehiclehash)
								while not HasModelLoaded(vehiclehash) do
									RequestModel(vehiclehash)
									Citizen.Wait(1)
								end
								car = CreateVehicle(vehiclehash, allspawnPoints[spawnPoint].posx, allspawnPoints[spawnPoint].posy, allspawnPoints[spawnPoint].posz, allspawnPoints[spawnPoint].alpha, true, false)
								
								
								--custom boosting aanpassen hier boven
								
								
								
								
								--Teleport player in car
								--TaskWarpPedIntoVehicle(GetPlayerPed(-1), car, -1)
		
								doorgaan = true
		
								while doorgaan and not aborted do
									Wait(0)
									if (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then --persoon gaat in de auto
										isDisabled = 0
										isTaken = 1
										doorgaan = false
										RemoveBlip(carblip)
										exports['okokNotify']:Alert('Auto-diefstal', _U('trackerOn'), 10000, 'info')
										
									end
								end
								TriggerServerEvent('esx_carthief:registerCops', currentBoostType)
								if aborted then
									RemoveBlip(carblip)
								end	

								--------------DISABLER CODE

								while aantaldisablers > 0 and not aborted do
									
									randomDisabler = math.random(1,#alldisablers)
			
									-- blip setten naar disabler
									disabler = AddBlipForCoord(alldisablers[randomDisabler].posx, alldisablers[randomDisabler].posy, alldisablers[randomDisabler].posz)
									SetBlipSprite(disabler, 1)
									SetBlipDisplay(disabler, 4)
									SetBlipScale(disabler, 1.0)
									SetBlipColour(disabler, 5)
									SetBlipAsShortRange(disabler, true)
									BeginTextCommandSetBlipName("STRING")
									AddTextComponentString("Auto")
									EndTextCommandSetBlipName(disabler)
			
									SetBlipRoute(disabler, true)
									
									doorgaan = true
									while doorgaan and not aborted do
										Wait(0)
										local coords = GetEntityCoords(GetPlayerPed(-1))
										if (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) and (GetDistanceBetweenCoords(coords, alldisablers[randomDisabler].posx, alldisablers[randomDisabler].posy, alldisablers[randomDisabler].posz, true) < 7) then --persoon gaat in de auto
											RemoveBlip(disabler)
											doorgaan = false
											--For delivery blip
											aantaldisablers = aantaldisablers - 1
										end
										if aantaldisablers == 3 then
											local veh = GetVehiclePedIsIn(PlayerPedId(),false)
											SetVehicleFixed(veh)
											SetVehicleEngineHealth(veh,1000.0)
										end
									end
									if aborted then
										RemoveBlip(disabler)
									end
								end
								isDisabled = 1
								TriggerServerEvent('esx_carthief:stopalertcops')
								exports['okokNotify']:Alert('Auto-diefstal', _U('trackerOFF'), 10000, 'info')
		
								--Set delivery blip
								if(boostType == "D") then
									deliveryblip = AddBlipForCoord(allDboosts[randomdelivery].posx, allDboosts[randomdelivery].posy, allDboosts[randomdelivery].posz)
								end
								if(boostType == "C") then
									deliveryblip = AddBlipForCoord(allCboosts[randomdelivery].posx, allCboosts[randomdelivery].posy, allDboosts[randomdelivery].posz)
								end
								if(boostType == "B") then
									deliveryblip = AddBlipForCoord(allBboosts[randomdelivery].posx, allBboosts[randomdelivery].posy, allDboosts[randomdelivery].posz)
								end
								if(boostType == "A") then
									deliveryblip = AddBlipForCoord(allAboosts[randomdelivery].posx, allAboosts[randomdelivery].posy, allDboosts[randomdelivery].posz)
								end
								if(boostType == "S") then
									deliveryblip = AddBlipForCoord(allSboosts[randomdelivery].posx, allSboosts[randomdelivery].posy, allSboosts[randomdelivery].posz)
								end
								if(boostType == "S+") then
									deliveryblip = AddBlipForCoord(allSSboosts[randomdelivery].posx, allSSboosts[randomdelivery].posy, allSSboosts[randomdelivery].posz)
								end
								--deliveryblip = AddBlipForCoord(alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz)
								SetBlipSprite(deliveryblip, 1)
								SetBlipDisplay(deliveryblip, 4)
								SetBlipScale(deliveryblip, 1.0)
								SetBlipColour(deliveryblip, 5)
								SetBlipAsShortRange(deliveryblip, true)
								BeginTextCommandSetBlipName("STRING")
								AddTextComponentString("Delivery point")
								EndTextCommandSetBlipName(deliveryblip)
								
								SetBlipRoute(deliveryblip, true)
								if aborted then
									RemoveBlip(deliveryblip)
								end
							else
								if(boostType == "D") then
									exports['okokNotify']:Alert('Auto-diefstal', _U('not_enough_cops') .. '.want er zijn 2 nodig', 10000, 'error')
								end
								if(boostType == "C") then
									exports['okokNotify']:Alert('Auto-diefstal', _U('not_enough_cops') .. '.want er zijn 3 nodig', 10000, 'error')
								end
								if(boostType == "B") then
									exports['okokNotify']:Alert('Auto-diefstal', _U('not_enough_cops') .. '.want er zijn 4 nodig', 10000, 'error')
								end
								if(boostType == "A") then
									exports['okokNotify']:Alert('Auto-diefstal', _U('not_enough_cops') .. '.want er zijn 5 nodig', 10000, 'error')
								end
								if(boostType == "S") then
									exports['okokNotify']:Alert('Auto-diefstal', _U('not_enough_cops') .. '.want er zijn 6 nodig', 10000, 'error')
								end
								if(boostType == "S+") then
									exports['okokNotify']:Alert('Auto-diefstal', _U('not_enough_cops') .. '.want er zijn 8 nodig', 10000, 'error')
								end
							end
						end)
					else
						exports['okokNotify']:Alert('Auto-diefstal', _U('already_robbery'), 10000, 'error')
					end
				else
					exports['okokNotify']:Alert('Auto-diefstal', _U('cooldown', math.ceil(cooldown/1000)), 10000, 'error')
				end
			end)
		else
			exports['okokNotify']:Alert('Auto-diefstal', 'Je hebt niet het ' .. boostType .. ' boost contract', 10000, 'success')
		end
	end , boostType)
end

function FinishDelivery()
  if(GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) and GetEntitySpeed(car) < 3 then
		
		--Delete Car
		SetEntityAsNoLongerNeeded(car)
		DeleteEntity(car)
		
    --Remove delivery zone
    RemoveBlip(deliveryblip)

    --Pay the poor fella
	print(currentBoostType)
	if currentBoostType == "D" then
		finalpayment = allDboosts[randomdelivery].payment
		TriggerServerEvent('esx_carthief:addBorg', 1000)
		TriggerServerEvent('esx_carthief:geefContract', 'C')
	end
	if currentBoostType == "C" then
		finalpayment = allCboosts[randomdelivery].payment
		TriggerServerEvent('esx_carthief:addBorg', 2500)
		TriggerServerEvent('esx_carthief:geefContract', 'B')
	end
	if currentBoostType == "B" then
		finalpayment = allBboosts[randomdelivery].payment
		TriggerServerEvent('esx_carthief:addBorg', 5000)
		TriggerServerEvent('esx_carthief:geefContract', 'A')
	end
	if currentBoostType == "A" then
		finalpayment = allAboosts[randomdelivery].payment
		TriggerServerEvent('esx_carthief:addBorg', 10000)
		TriggerServerEvent('esx_carthief:geefContract', 'S')
	end
	if currentBoostType == "S" then
		finalpayment = allSboosts[randomdelivery].payment
		TriggerServerEvent('esx_carthief:addBorg', 25000)
		TriggerServerEvent('esx_carthief:geefContract', 'SS')
	end
	if currentBoostType == "S+" then
		finalpayment = allSSboosts[randomdelivery].payment
		TriggerServerEvent('esx_carthief:addBorg', 50000)
	end
		--local finalpayment = alldeliveries[randomdelivery].payment
		TriggerServerEvent('esx_carthief:pay', finalpayment)

		--Register Activity
		TriggerServerEvent('esx_carthief:registerActivity', 0)

    --For delivery blip
    isTaken = 0

    --For delivery blip
    isDelivered = 1
		
		--Remove Last Cop Blips
    TriggerServerEvent('esx_carthief:stopalertcops')
	missieGaande = false
		
  else
		exports['okokNotify']:Alert('Auto-diefstal', _U('car_provided_rule'), 10000, 'error')
  end
end

function AbortDelivery()
	--Delete Car
	SetEntityAsNoLongerNeeded(car)
	DeleteEntity(car)

	--Remove delivery zone
	RemoveBlip(deliveryblip)
	RemoveBlip(carblip)
	RemoveBlip(disabler)

	--Register Activity
	TriggerServerEvent('esx_carthief:registerActivity', 0)

	--For delivery blip
	isTaken = 0

	--For delivery blip
	isDelivered = 1

	--Remove Last Cop Blips
	TriggerServerEvent('esx_carthief:stopalertcops')
	missieGaande = false
end

--Check if player left car
Citizen.CreateThread(function()
  while true do
    Wait(1000)
		if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
			exports['okokNotify']:Alert('Auto-diefstal', _U('get_back_car_5m'), 10000, 'error')
			Wait(290000)
			if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
				aborted = true
				exports['okokNotify']:Alert('Auto-diefstal', _U('get_back_car_10s'), 10000, 'error')
				Wait(10000)
				exports['okokNotify']:Alert('Auto-diefstal', _U('mission_failed'), 10000, 'error')
				AbortDelivery()
			end
		end
	end
end)

--Timer zodat mensen niet starten en niks doen
Citizen.CreateThread(function()
	while true do
	  Wait(1000)
		  if missieGaande == true and isTaken == 0 then
			  if  isTaken == 0 then
				exports['okokNotify']:Alert('Auto-diefstal', _U('findcar15'), 10000, 'error')
			  end
			  Wait(300000)
			  if missieGaande == true and isTaken == 0 then
				exports['okokNotify']:Alert('Auto-diefstal', _U('findcar10'), 10000, 'error')
			  end
			  Wait(300000)
			  if missieGaande == true and isTaken == 0 then
				exports['okokNotify']:Alert('Auto-diefstal', _U('findcar5'), 10000, 'error')
			  end
			  Wait(240000)
			  if missieGaande == true and isTaken == 0 then
				exports['okokNotify']:Alert('Auto-diefstal', _U('findcar1'), 10000, 'error')
			  end
			  Wait(60000)
			  missieGaande = false
			  if missieGaande == true and isTaken == 0 then
				exports['okokNotify']:Alert('Auto-diefstal', _U('notfindcar'), 10000, 'error')
				AbortDelivery()
			  end
		  end
	  end
  end)

-- Send location
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(Config.BlipUpdateTime)
    if isTaken == 1 and isDisabled == 0 and IsPedInAnyVehicle(GetPlayerPed(-1)) then
			local coords = GetEntityCoords(GetPlayerPed(-1))
      TriggerServerEvent('esx_carthief:alertcops', coords.x, coords.y, coords.z)
		elseif isTaken == 1 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			TriggerServerEvent('esx_carthief:stopalertcops')
    end
  end
end)

RegisterNetEvent('esx_carthief:removecopblip')
AddEventHandler('esx_carthief:removecopblip', function()
		RemoveBlip(copblip)
end)

RegisterNetEvent('esx_carthief:setcopblip')
AddEventHandler('esx_carthief:setcopblip', function(cx,cy,cz)
		RemoveBlip(copblip)
    copblip = AddBlipForCoord(cx,cy,cz)
    SetBlipSprite(copblip , 161)
    SetBlipScale(copblipy , 2.0)
		SetBlipColour(copblip, 8)
		PulseBlip(copblip)
end)

RegisterNetEvent('esx_carthief:setcopnotification')
AddEventHandler('esx_carthief:setcopnotification', function(boostData)
	if boostData == "D" then
		exports['okokNotify']:Alert('Auto-diefstal', 'Voertuig diefstal, live locatie is gestuurd!', 10000, 'info')
	end
	if boostData == "C" then
		exports['okokNotify']:Alert('Auto-diefstal', 'Voertuig diefstal, live locatie is gestuurd!', 10000, 'info')
	end
	if boostData == "B" then
		exports['okokNotify']:Alert('Auto-diefstal', 'Duur voertuig diefstal, locatie is gedeeld!', 10000, 'info')
	end
	if boostData == "A" then
		exports['okokNotify']:Alert('Auto-diefstal', 'Duur voertuig diefstal, locatie is gedeeld!', 10000, 'info')
	end
	if boostData == "S" then
		exports['okokNotify']:Alert('Auto-diefstal', 'Dubois - onze wagen is gestolen! stuur de poltie', 10000, 'info')
	end
	if boostData == "S+" then
		exports['okokNotify']:Alert('Auto-diefstal', 'Van de akker - onze wagen is gestolen! stuur de poltie', 10000, 'info')
	end
end)

AddEventHandler('esx_carthief:hasEnteredMarker', function(zone)
  if LastZone == 'menucarthief' then
    CurrentAction     = 'carthief_menu'
    CurrentActionMsg  = _U('steal_a_car')
    CurrentActionData = {zone = zone}
  elseif LastZone == 'cardelivered' then
    CurrentAction     = 'cardelivered_menu'
    CurrentActionMsg  = _U('drop_car_off')
    CurrentActionData = {zone = zone}
  end
end)

AddEventHandler('esx_carthief:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
  while true do
		Wait(0)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil
		if isTaken == 1 then
			if currentBoostType == "D" then
				if (GetDistanceBetweenCoords(coords, allDboosts[randomdelivery].posx, allDboosts[randomdelivery].posy, allDboosts[randomdelivery].posz, true) < 3) then
					isInMarker  = true
					currentZone = 'cardelivered'
					LastZone    = 'cardelivered'
				end
			end
			if currentBoostType == "C" then--*
				if (GetDistanceBetweenCoords(coords, allCboosts[randomdelivery].posx, allCboosts[randomdelivery].posy, allCboosts[randomdelivery].posz, true) < 3) then
					isInMarker  = true
					currentZone = 'cardelivered'
					LastZone    = 'cardelivered'
				end
			end
			if currentBoostType == "B" then
				if (GetDistanceBetweenCoords(coords, allBboosts[randomdelivery].posx, allBboosts[randomdelivery].posy, allBboosts[randomdelivery].posz, true) < 3) then
					isInMarker  = true
					currentZone = 'cardelivered'
					LastZone    = 'cardelivered'
				end
			end
			if currentBoostType == "A" then
				if (GetDistanceBetweenCoords(coords, allAboosts[randomdelivery].posx, allAboosts[randomdelivery].posy, allAboosts[randomdelivery].posz, true) < 3) then
					isInMarker  = true
					currentZone = 'cardelivered'
					LastZone    = 'cardelivered'
				end
			end
			if currentBoostType == "S" then
				if (GetDistanceBetweenCoords(coords, allSboosts[randomdelivery].posx, allSboosts[randomdelivery].posy, allSboosts[randomdelivery].posz, true) < 3) then
					isInMarker  = true
					currentZone = 'cardelivered'
					LastZone    = 'cardelivered'
				end
			end
			if currentBoostType == "S+" then
				if (GetDistanceBetweenCoords(coords, allSSboosts[randomdelivery].posx, allSSboosts[randomdelivery].posy, allSSboosts[randomdelivery].posz, true) < 3) then
					isInMarker  = true
					currentZone = 'cardelivered'
					LastZone    = 'cardelivered'
				end
			end
		end
        
		if isInMarker and not HasAlreadyEnteredMarker and isDisabled == 1 then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_carthief:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker and isDisabled == 1 then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_carthief:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CurrentAction ~= nil then
      SetTextComponentFormat('STRING')
      AddTextComponentString(CurrentActionMsg)
      DisplayHelpTextFromStringLabel(0, 0, 1, -1)
      if IsControlJustReleased(0, 38) then
        if CurrentAction == 'carthief_menu' then
          SpawnCar()
        elseif CurrentAction == 'cardelivered_menu' then
          FinishDelivery()
        end
        CurrentAction = nil
      end
    end
  end
end)

-- Display markers for delivery place
Citizen.CreateThread(function()
  while true do
    Wait(0)
	if isTaken == 1 and isDelivered == 0 then
		local coords = GetEntityCoords(GetPlayerPed(-1))
		if currentBoostType == "D" then
			v = allDboosts[randomdelivery]
		end
		if currentBoostType == "C" then
			v = allCboosts[randomdelivery]
		end
		if currentBoostType == "B" then
			v = allBboosts[randomdelivery]
		end
		if currentBoostType == "A" then
			v = allAboosts[randomdelivery]
		end
		if currentBoostType == "S" then
			v = allSboosts[randomdelivery]
		end
		if currentBoostType == "S+" then
			v = allSSboosts[randomdelivery]
		end
		if (GetDistanceBetweenCoords(coords, v.posx, v.posy, v.posz, true) < Config.DrawDistance) then
			DrawMarker(1, v.posx, v.posy, v.posz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 204, 204, 0, 100, false, false, 2, false, false, false, false)
		end
	end
  end
end)

local optiesBoosting = {
    {label = "D (€1.000)", value = 'D'},
    {label = "C (€2.500)", value = 'C'},
    {label = "B (€5.000)", value = 'B'},
    {label = "A (€10.000)", value = 'A'},
    {label = "S (€25.000)", value = 'S'},
    {label = "S+ (€50.000)", value = 'S+'},
}

local optiesCriminaliteit = {
    {label = "Auto diefstal", value = '1'},
    {label = "Zwarte markt", value = '2'},
}

function boostPhone()
    ESX.UI.Menu.Open('default',GetCurrentResourceName(), 'Auto_diefstal',{
        title = "Auto diefstal",
        align = "top-right",
        elements = optiesBoosting
    }, function(data, menu)
        SpawnCar(data.current.value)
    end, 
    function(data, menu)
        menu.close()
    end)
end


RegisterNetEvent('esx_carthief:boost')
AddEventHandler('esx_carthief:boost', function()
	--SpawnCar()
        ESX.UI.Menu.Open('default',GetCurrentResourceName(), 'BlackBerry',{
            title = "BlackBerry",
            align = "top-right",
            elements = optiesCriminaliteit
        }, function(data, menu)
            if data.current.value == '1' then
                boostPhone()
            end
            if data.current.value == '2' then
                TriggerEvent('ZwarteMarktLocatie')
            end
		end, 
		function(data, menu)
			menu.close()
		end)
end)