local QBCore = exports['qb-core']:GetCoreObject()
local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local PlayerData		= {}
local inRange = false
local LoadModels = {"w_am_flare", "p_cargo_chute_s", "ex_prop_adv_case_sm", "cuban800", "s_m_m_pilot_02"}
local display = false
local phoneModel = `prop_npc_phone_02`

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

function hitman2()
    QBCore.Functions.Notify("Kill your target, everything on it is yours")
    local assasin = true
    local ped = PlayerPedId()
    local anim = "amb@world_human_smoking@male@male_b@base"
    local model = Config.mod[math.random(1, #(Config.mod))]
    local x = Config.posi[math.random(1, #(Config.posi))]
    price = Config.items[math.random(1, #(Config.items))]
    amounth = math.random(1, 7)
    RequestModel(model) 
    while not HasModelLoaded(model) do Citizen.Wait(100) end
    local kurban = CreatePed(4, model, x.x, x.y, x.z-1.0, x.w, true, false)
	blip = AddBlipForEntity(kurban)
    SetBlipSprite(blip, 303)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 0.6)
	SetPedFleeAttributes(kurban, 0, 0)
    SetPedAsEnemy(kurban,true)
	SetPedMaxHealth(kurban, 900)
	SetPedAlertness(kurban, 3)
	SetPedCombatRange(kurban, 0)
    SetPedCanRagdoll(kurban, false)
	SetPedConfigFlag(kurban, 224, true)
    SetPedSuffersCriticalHits(kurban, false)
	SetPedCombatMovement(kurban, 2)
	SetRelationshipBetweenGroups(5, GetHashKey(kurban), GetHashKey(ped)) 
	SetPedRelationshipGroupHash(kurban, GetHashKey("ped"))
	GiveWeaponToPed(kurban, GetHashKey("WEAPON_PISTOL"), 20, false, true)
	SetPedDropsWeaponsWhenDead(kurban, false)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do Citizen.Wait(10) end
    TaskPlayAnim(kurban, anim, "base", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        assa = GetEntityCoords(kurban)
        inRange = false
        local dist = #(pos - assa)
        if dist < 20 then
            inRange = true
            if #(pos - vector3(assa.x, assa.y, assa.z)) < 1.5 then
                if IsEntityDead(kurban) then
                    DrawText3Ds(assa, '~g~[E] ~w~ check his pocket')
                    if IsControlJustPressed(0, 38) then
                        local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                        RequestAnimDict(animDict)
                        while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end
                        TaskPlayAnim(ped, animDict, "machinic_loop_mechandplayer", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
                        Citizen.Wait(5000)
                        ClearPedTasksImmediately(ped)
                        RemoveAnimDict(animDict)
                        TriggerServerEvent("gamemode:server:ItemHandler", price, amounth)
                        QBCore.Functions.Notify("You find something")
                        DeleteEntity(kurban)
                        return false
                    end
                end
            end
        end
        if not inRange then
            Wait(1000)
        end
        Wait(2)
    end
end

DrawText3Ds = function(coords, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(coords.x, coords.y, coords.z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

function selectmission(gorev)
	if gorev == 1 then
		airdrop(true, 400)
	elseif gorev == 2 then
		hitman2()
	elseif gorev == 3 then
		tveh()
	elseif gorev == 4 then
		pezevenk()
	end
end

function CrateDrop(planeSpawnDistance, dropCoords)
    CreateThread(function()
        blip = AddBlipForCoord(dropCoords)
        SetBlipSprite(blip, 572)
        SetBlipColour(blip, 25)
        SetBlipAsShortRange(blip, false)
        SetBlipScale(blip, 1.0)
        BeginTextCommandSetBlipName("STRING")
    	AddTextComponentString("AirDrop")
    	EndTextCommandSetBlipName(blip)
        SetTimeout( 2 * 60 * 1000, function()            	               
            for i = 1, #LoadModels do
                RequestModel(GetHashKey(LoadModels[i]))
                while not HasModelLoaded(GetHashKey(LoadModels[i])) do
                    Wait(0)
                end
            end
            RequestAnimDict("p_cargo_chute_s")
            while not HasAnimDictLoaded("p_cargo_chute_s") do
                Wait(0)
            end            
            RequestWeaponAsset(GetHashKey("weapon_flare"))
            while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
                Wait(0)
            end                   
            local rHeading = math.random(0, 360) + 0.0
            local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0
            local theta = (rHeading / 180.0) * 3.14
            local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0)
            local dx = dropCoords.x - rPlaneSpawn.x
            local dy = dropCoords.y - rPlaneSpawn.y
			local drop = true
            local heading = GetHeadingFromVector_2d(dx, dy)
            aircraft = CreateVehicle(GetHashKey("cuban800"), rPlaneSpawn, heading, true, true)
            SetEntityHeading(aircraft, heading)
            SetVehicleDoorsLocked(aircraft, 2)
            SetEntityDynamic(aircraft, true)
            ActivatePhysics(aircraft)
            SetVehicleForwardSpeed(aircraft, 60.0)
            SetHeliBladesFullSpeed(aircraft)
            SetVehicleEngineOn(aircraft, true, true, false)
            ControlLandingGear(aircraft, 3)
            OpenBombBayDoors(aircraft)
            SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)
            pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
            SetBlockingOfNonTemporaryEvents(pilot, true)
            SetPedRandomComponentVariation(pilot, false)
            SetPedKeepTask(pilot, true)
            SetPlaneMinHeightAboveTerrain(aircraft, 50)
            TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), 60.0, 0, GetHashKey("cuban800"), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence
            local droparea = vector2(dropCoords.x, dropCoords.y)
            local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
            while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do
                Wait(100)
                planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
            end
            if IsEntityDead(pilot) then 
                QBCore.Functions.Notify("Pilot is dead")
                return
            end
            TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey("cuban800"), 262144, -1.0, -1.0)
            SetEntityAsNoLongerNeeded(pilot) 
            SetEntityAsNoLongerNeeded(aircraft)      
            QBCore.Functions.Notify("The plane is on the way")
            local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0)                        
            crate = CreateObject(GetHashKey("ex_prop_adv_case_sm"), crateSpawn, true, true, true)

            SetEntityLodDist(crate, 1000)
            ActivatePhysics(crate)
            SetDamping(crate, 2, 0.1)
            SetEntityVelocity(crate, 0.0, 0.0, -0.2)
            parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, true, true, true)
            SetEntityLodDist(parachute, 1000)
            SetEntityVelocity(parachute, 0.0, 0.0, -0.2)       
            AttachEntityToEntity(parachute, crate, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)            
            -- Sound
            soundID = GetSoundId()
            PlaySoundFromEntity(soundID, "Crate_Beeps", parachute, "MP_CRATE_DROP_SOUNDS", true, 0)            
            -- Checks when the crate is at the dropsite and delete the parachute
            local parachuteCoords = vector3(GetEntityCoords(parachute))            
            while #(parachuteCoords - dropCoords) > 5.0 do
                Wait(100)
                parachuteCoords = vector3(GetEntityCoords(parachute))
            end
            ShootSingleBulletBetweenCoords(dropCoords, dropCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0)            
            DetachEntity(parachute, true, true)            
            DeleteEntity(parachute)
            StopSound(soundID)
            ReleaseSoundId(soundID)
			while drop do
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local drop1 = GetEntityCoords(crate)
				inRange = false
				local dist = #(pos - drop1)

				if dist < 40 then
					inRange = true
					if #(pos - vector3(drop1.x, drop1.y, drop1.z)) < 3.5 then
						DrawText3Ds(drop1, '~g~[E] ~w~ open drop')
						if IsControlJustPressed(0, 38) then
							if IsPedArmed(PlayerPedId(), 4) then
								if not IsEntityDead(PlayerPedId()) then
									if not IsPedInAnyVehicle(PlayerPedId()) then
                                        price = Config.items[math.random(1, #(Config.items))]
                                        amounth = math.random(5, 25)
                                        local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
                                        RequestAnimDict(animDict)
                                        while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end
                                        TaskPlayAnim(ped, animDict, "machinic_loop_mechandplayer", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
                                        Citizen.Wait(5000)
                                        ClearPedTasksImmediately(ped)
                                        RemoveAnimDict(animDict)
										TriggerServerEvent("gamemode:server:ItemHandler", price, amounth)
										QBCore.Functions.Notify("You opened the drop")										
										DeleteEntity(crate)
                                        RemoveBlip(blip)
                                        drop = false
									else
										QBCore.Functions.Notify("you must be outside the vehicle")
									end
								else
									QBCore.Functions.Notify("you can't open it when you are dead")
								end
							else
								QBCore.Functions.Notify("You can't open the airdrop without your gun")
							end
						end
					end
				end
				if not inRange then
					Wait(1000)
				end
				Wait(2)
			end
            for i = 1, #LoadModels do
                Wait(0)
                SetModelAsNoLongerNeeded(GetHashKey(LoadModels[i]))
            end
            RemoveWeaponAsset(GetHashKey("w_am_flare"))         
        end)  
    end)
end

RegisterNetEvent("gamemode:client:StartDrop", function(roofCheck, planeSpawnDistance, dropCoords)
    CreateThread(function()          
        if dropCoords.x and dropCoords.y and dropCoords.z and tonumber(dropCoords.x) and tonumber(dropCoords.y) and tonumber(dropCoords.z) then            
        else
            dropCoords = {0.0, 0.0, 72.0}            
        end
        RequestWeaponAsset(GetHashKey("weapon_flare"))
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end
        if roofCheck and roofCheck ~= "false" then
            local ray = StartShapeTestRay(vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), vector3(dropCoords.x, dropCoords.y, dropCoords.z), -1, -1, 0)
            local _, hit, impactCoords = GetShapeTestResult(ray)
            if hit == 0 or (hit == 1 and #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)) < 10.0) then             
                CrateDrop(planeSpawnDistance, dropCoords)
            else            
                return
            end
        else            
            CrateDrop(amount, planeSpawnDistance, dropCoords)
        end
    end)
end)

function airdrop(roofCheck, planeSpawnDistance)
	QBCore.Functions.Notify("Quickly go to the specified location")
    air = Config.aird[math.random(1, #(Config.aird))]
    TriggerEvent("gamemode:client:StartDrop", roofCheck or false, planeSpawnDistance or 400.0, air)  
end

function tveh()
    QBCore.Functions.Notify("Find the car, bring it to the delivery zone and get your money")
    vehicle = Config.veh[math.random(1, #(Config.veh))]
    place = Config.varea[math.random(1, #(Config.varea))]
    model = Config.mod[math.random(1, #(Config.mod))]
    onetime = true
    RequestModel(model)
    RequestModel(GetHashKey(vehicle)) 
    while not HasModelLoaded(model) or not HasModelLoaded(GetHashKey(vehicle)) do Citizen.Wait(0) end
    arac = CreateVehicle(GetHashKey(vehicle), place.x, place.y, place.z, place.w , true, true)
    SetVehicleDoorsLocked(arac, 1)
    bl = AddBlipForEntity(arac)
    SetBlipSprite(bl, 225)
    SetBlipColour(bl, 1)
    SetBlipAsShortRange(bl, false)
    SetBlipScale(bl, 0.7)
    driver = CreatePedInsideVehicle(arac, 1, GetHashKey(model), -1, true, true)
    ClearPedTasks(driver)
    TaskReactAndFleePed(driver, PlayerPedId())
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(arac)
        local mission = vector3(725.53, -694.38, 27.51)
        inRange = false
        local dist = #(pos - mission)
        if IsPedInVehicle(ped, arac, True) and onetime == true then
            QBCore.Functions.Notify("Go to the delivery zone")
            blip = AddBlipForCoord(mission)
            SetBlipSprite(blip, 1)
            SetBlipDisplay(blip, 2)
            SetBlipScale(blip, 1.0)
            SetBlipAsShortRange(blip, false)
            SetBlipColour(blip, 3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName("delivery zone")
            EndTextCommandSetBlipName(blip)
            SetBlipRoute(blip, true)
            onetime = false
        end
        if dist < 20 then
            inRange = true
            if #(pos - vector3(mission.x, mission.y, mission.z)) < 8 then
                if not IsPedInVehicle(ped, arac, True) then
                    DrawText3Ds(mission, '~g~[E] ~w~ deliver the car')
                    if IsControlJustPressed(0, 38) then
                        local animDict = "anim@amb@casino@luxury_suite@suite_phone@"
                        RequestAnimDict(animDict)
                        while not HasAnimDictLoaded(animDict) do Citizen.Wait(10) end
                        TaskPlayAnim(ped, animDict, "f_pick_up_mp_f_freemode_01", 8.0, 1.0, -1, 2, 0, 0, 0, 0 ) 
                        Citizen.Wait(8000)
                        ClearPedTasksImmediately(ped)
                        RemoveAnimDict(animDict)
                        TriggerServerEvent("gamemode:server:getMoney", Config.price1)
                        QBCore.Functions.Notify("Mission accomplished")
                        Citizen.Wait(5000)
                        DeleteEntity(arac)
                        local blip = RemoveBlip(blip)
                        return false
                    end
                end
            end
        end
        if not inRange then
            Wait(1000)
        end
        Wait(2)
    end
end

function pezevenk()
    QBCore.Functions.Notify("Take the escort in your car and take it to the client")
    anim = "amb@world_human_smoking@female@base"
    x = Config.posi[math.random(1, #(Config.posi))]
    model = Config.hok[math.random(1, #(Config.hok))]
    RequestModel(model) 
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    escort = CreatePed(4, model, x.x, x.y, x.z, x.w, true, true)
    RequestAnimDict(anim)
    while not HasAnimDictLoaded(anim) do Citizen.Wait(10) end
    TaskPlayAnim(escort, anim, "base", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
    blip = AddBlipForEntity(escort)
    SetBlipSprite(blip, 121)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, false)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Escort")
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        esc = GetEntityCoords(escort)
        inRange = false
        local dist = #(pos - esc)
        if  IsEntityDead(escort) then
            QBCore.Functions.Notify("Escort is dead")
            RemoveBlip(blip)
            return false
        end
        if dist < 20 then
            inRange = true
            if #(pos - vector3(esc.x, esc.y, esc.z)) < 5 then
                DrawText3Ds(esc, '~g~[E] ~w~ get in the car')
                veh = GetVehiclePedIsIn(ped,  true)
                if IsControlJustPressed(0, 38) then
                    if veh == 0 then
                        QBCore.Functions.Notify("You should have a car for it or side seat full")
                    elseif veh ~= 0 and IsVehicleSeatFree(veh, 0) then
                        QBCore.Functions.Notify("Take her to the client")
                        SetEntityAsMissionEntity(escort)
                        SetBlockingOfNonTemporaryEvents(escort, true)
                        TaskEnterVehicle(escort, veh, -1, 0, 1.0, 1, 0)
                        PlayAmbientSpeech1(escort, "Generic_Hows_It_Going", "Speech_Params_Force")
                        blip = RemoveBlip(blip)
                        place1 = Config.dest[math.random(1, #(Config.dest))]
                        blip2 = AddBlipForCoord(place1)
                        SetBlipSprite(blip2, 121)
                        SetBlipDisplay(blip2, 2)
                        SetBlipScale(blip2, 0.8)
                        SetBlipAsShortRange(blip2, false)
                        SetBlipColour(blip2, 1)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentSubstringPlayerName("Destination")
                        EndTextCommandSetBlipName(blip2)
                        SetBlipRoute(blip2, true)
                        while true do
                            hooker = GetEntityCoords(escort)
                            inRange2 = false
                            local dist2 = #(hooker - place1)
                            if  IsEntityDead(escort) then
                                QBCore.Functions.Notify("Escort is dead")
                                RemoveBlip(blip2)
                                return false
                            end
                            if dist2 < 20 then
                                inRange2 = true
                                if #(hooker - vector3(place1.x, place1.y, place1.z)) < 5 then
                                    DrawText3Ds(place1, '~g~[E] ~w~ we arrived')
                                    if IsControlJustPressed(0, 38) then
                                        QBCore.Functions.Notify("You got your money")
                                        RemoveBlip(blip2)
                                        TaskLeaveVehicle(escort, veh, 0)
                                        SetPedAsNoLongerNeeded(escort)
                                        TriggerServerEvent("gamemode:server:getMoney", Config.price2)
                                        return false
                                    end
                                end
                            end
                            if not inRange then
                                Wait(1000)
                            end
                            Wait(2)
                        end
                        return false
                    end
                end	
            end
        end
        if not inRange then
            Wait(1000)
        end
        Wait(2)
    end

end

function newPhoneProp()
	deletePhone()
	RequestModel(phoneModel)
	while not HasModelLoaded(phoneModel) do
		Wait(1)
	end
	phoneProp = CreateObject(phoneModel, 1.0, 1.0, 1.0, 1, 1, 0)

	local bone = GetPedBoneIndex(PlayerPedId(), 28422)
	if phoneModel == `prop_cs_phone_01` then
		AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 50.0, 320.0, 50.0, 1, 1, 0, 0, 2, 1)
	else
		AttachEntityToEntity(phoneProp, PlayerPedId(), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
	end
end

function deletePhone()
	if phoneProp ~= 0 then
		DeleteObject(phoneProp)
		phoneProp = 0
	end
end

RegisterNetEvent('gamemode:client:UseIllegalphone', function()
    ped = PlayerPedId()
    anime = "amb@world_human_stand_mobile@male@text@base"
    newPhoneProp()
    RequestAnimDict(anime)
    while not HasAnimDictLoaded(anime) do Citizen.Wait(10) end
    TaskPlayAnim(ped, anime, "base", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
	SetDisplay(not display)
end)

RegisterNUICallback("exit", function(data)
    ped = PlayerPedId()
    deletePhone()
    StopAnimTask(ped, "amb@world_human_stand_mobile@male@text@base", "base", 2.5)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)

RegisterNUICallback('mission', function(data,cb)
    selectmission(data.mission)
    cb({})
end)
