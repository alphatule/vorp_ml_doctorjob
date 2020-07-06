

Citizen.CreateThread(function()
    local checkbox2 = false
    WarMenu.CreateMenu('perso', _U('titulo'))
    WarMenu.SetSubTitle('perso', _U('subtitulo'))
    WarMenu.CreateSubMenu('inv', 'perso', _U('sub_menu'))
    WarMenu.CreateSubMenu('inv1', 'perso', _U('sub_menu2'))
    WarMenu.CreateSubMenu('inv2', 'perso', _U('sub_menu3'))


    while true do

        local ped = GetPlayerPed()
        local coords = GetEntityCoords(PlayerPedId())

        if WarMenu.IsMenuOpened('perso') then

            

            if WarMenu.MenuButton(_U('opciones'), 'inv1') then
            end

            if WarMenu.MenuButton(_U('utensilios'), 'inv2') then
            end
			
			if WarMenu.MenuButton(_U('caballo'), 'inv') then 
            end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('inv1') then
			
			if WarMenu.Button(_U('revivir')) then
			local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then 				
					TriggerServerEvent("vorp_ml_doctorjob:reviveplayer", GetPlayerServerId(closestPlayer))
					TriggerEvent("ml_needs:resetall")
					
				end		
			elseif WarMenu.Button(_U('curar')) then
			local closestPlayer, closestDistance = GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 3.0 then
					TriggerServerEvent("vorp_ml_doctorjob:healplayer", GetPlayerServerId(closestPlayer))
					TriggerEvent("ml_needs:resetall")
					
				end
				elseif WarMenu.Button(_U('curar2')) then
                    local Health = GetAttributeCoreValue(PlayerPedId(), 0)
                    local newHealth = Health + 25
                    local Stamina = GetAttributeCoreValue(PlayerPedId(), 1)
                    local newStamina = Stamina + 25
                    local Health2 = GetEntityHealth(PlayerPedId())
                    local newHealth2 = Health2 + 25
                    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newHealth) --core
                    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) --core
                    SetEntityHealth(PlayerPedId(), newHealth2)
                end

            WarMenu.Display()
        elseif WarMenu.IsMenuOpened('inv') then   

            if WarMenu.Button(_U('caballo')) then
					SpawnHorse()
            end
            WarMenu.Display()

        elseif WarMenu.IsMenuOpened('inv2') then   

            if WarMenu.Button(_U('lazo')) then
                Citizen.InvokeNative(0xB282DC6EBD803C75, GetPlayerPed(), GetHashKey("WEAPON_LASSO"), 500, true, 0)
			
             end
			
            WarMenu.Display()

        elseif whenKeyJustPressed(keys["U"]) then 
           TriggerServerEvent("vorp_ml_doctorjob:checkjob")
        end
		
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('vorp_ml_doctorjob:open')
AddEventHandler('vorp_ml_doctorjob:open', function(cb)
	WarMenu.OpenMenu('perso')
	print ("openmenu")
end)

function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end

--Police Horse

local recentlySpawned = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if recentlySpawned > 0 then
            recentlySpawned = recentlySpawned - 1
        end
    end
end)



function SpawnHorse()
    local localPed = PlayerPedId()
    local randomHorseModel = math.random(1, #Config.Horses)
    local model = GetHashKey(Config.Horses[randomHorseModel])

    RequestModel(model, true)

    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end
    
    local forward = Citizen.InvokeNative(0x2412D9C05BB09B97, localPed)
    local pos = GetEntityCoords(localPed)
    local myHorse = Citizen.InvokeNative(0xD49F9B0955C367DE, model, pos.x, pos.y - 30, pos.z - 0.5, 180.0, true, true, true, true)
    TaskGoToEntity( myHorse, localPed, -1, 7.2, 2.0, 0, 0 )
	Citizen.InvokeNative(0x283978A15512B2FE, myHorse, true)
    SetPedAsGroupMember(myHorse, 0) --Citizen.InvokeNative(0x9F3480FE65DB31B5, myHorse, 0)
	SetModelAsNoLongerNeeded(model) -- Citizen.InvokeNative(0x4AD96EF928BD4F9A, model)
	Citizen.InvokeNative(0xD3A7B003ED343FD9, myHorse, 0x1EE21489, true, true, true)
    Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, myHorse)
end


function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end
    
    for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end


 RegisterNetEvent('vorp_ml_doctorjob:healed')
AddEventHandler('vorp_ml_doctorjob:healed', function()
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
    local Health = GetAttributeCoreValue(PlayerPedId(), 0)
    local newHealth = Health + 50
    local Stamina = GetAttributeCoreValue(PlayerPedId(), 1)
    local newStamina = Stamina + 50
    local Health2 = GetEntityHealth(PlayerPedId())
    local newHealth2 = Health2 + 50
    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newHealth) --core
    Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) --core
    SetEntityHealth(PlayerPedId(), newHealth2)
    print ("healed player")
    end
end)

RegisterNetEvent('vorp_ml_doctorjob:revived')
AddEventHandler('vorp_ml_doctorjob:revived', function()
local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
		--TriggerServerEvent("redemrp:doctorrevive", function()
		--end)
		--TriggerClientEvent("redemrp_respawn:revivepl", function()
		--end)
	local ply = PlayerPedId()
	local coords = GetEntityCoords(ply)
	
	DoScreenFadeOut(1000)
	Wait(1000)
	DoScreenFadeIn(1000)
	--isDead = false
	--timerCount = reviveWait
	NetworkResurrectLocalPlayer(coords, true, true, false)
	ClearTimecycleModifier()
	ClearPedTasksImmediately(ply)
	SetEntityVisible(ply, true)
	NetworkSetFriendlyFireOption(true)


	SetCamActive(gameplaycam, true)
	DisplayHud(true)
	DisplayRadar(true)
	-- TriggerServerEvent("redemrp_respawn:lupocamera", coords, lightning)
    exports.spawnmanager:setAutoSpawn(false)
    print ("revived player")
   end
end)



