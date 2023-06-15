local destroying = false
local inZone = false


Citizen.CreateThread(function()

    SetupBlips()

    while true do
        Citizen.Wait(2000)
        local _inZone = false
        for k,v in ipairs(Config.Zones) do

            local playerPed = PlayerPedId()
            local pCoords = GetEntityCoords(playerPed)
            local dist = #(pCoords - v.coords)

            if dist <= v.radius then

                _inZone = true
                if not IsAllowed(v.allowedJobs, v.allowedVehicleModels, v.needOneOfBoth) then
                    DestroyVehicle()
                else
                    Citizen.Wait(5000)
                end
                break
            end
                
        end
        inZone = _inZone

    end

end)

function SetupBlips() 
    if next(Config.Zones) then

        for k, v in pairs(Config.Zones) do
            AddTextEntry('NoFlyZone', Config.BlipData.label)

            local radius_blip = AddBlipForRadius(v.coords, v.radius)
            local blip = AddBlipForCoord(v.coords)

            SetBlipColour(radius_blip, Config.BlipData.Radius.Color)
            SetBlipAlpha(radius_blip, Config.BlipData.Radius.Alpha)

            SetBlipSprite(blip, Config.BlipData.Marker.Sprite)
            SetBlipScale(blip, Config.BlipData.Marker.Scale)
            SetBlipColour(blip, Config.BlipData.Marker.Color)

            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("NoFlyZone")
            AddTextComponentSubstringPlayerName(Config.BlipData.Marker.label)
            EndTextCommandSetBlipName(blip)
        end

    end
end


function DestroyVehicle()
    if not destroying then
        destroying = true
        
        if inZone then
           
            if not HasWeaponAssetLoaded(GetHashKey("WEAPON_RPG")) then
                RequestWeaponAsset(GetHashKey("WEAPON_RPG"), 31, 0)
                while not HasWeaponAssetLoaded(GetHashKey("WEAPON_RPG")) do
                    Wait(0)
                end
            end

            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            local pCoords = GetEntityCoords(veh)
            local from_coords, hit_coords = CalculateHitCoords(pCoords, veh)

            ShootSingleBulletBetweenCoords(f_coords, h_coords, 5000, true, GetHashKey("WEAPON_RPG"), PlayerPedId(), true, false, 2000.0)
            Citizen.Wait(500)
          
            AddExplosion(h_coords, 10, 1.0, true, false, 1.0)
            destroying = false
        end
    end

end

function CalculateHitCoords(c, v)
    local speed = GetEntitySpeed(v)

    local forward = GetEntityForwardVector(v)

    local fireCoords = c + forward * (100.0) + vector3(0.0, 0.0, 30.0)


    local hit = GetEntityCoords(v)
    
    return fireCoords, hit

end

function IsAllowed(allowedJobs, allowedVehicleModels, needBoth)
    local allowedJob = false
    local allowedVehicle = false
    
    local playerPed = PlayerPedId()

    -- Check if player is in a plane or heli
    local isInHeli = IsPedInAnyHeli(playerPed)
    local isInPlane = IsPedInAnyPlane(playerPed)

    if not isInHeli and not isInPlane then
        return true
    end

    -- Check if player is the pilot
    local player_vehicle = GetVehiclePedIsIn(playerPed, false)
    local vehicle_driver = GetPedInVehicleSeat(player_vehicle, -1)

    if not vehicle_driver == playerPed then
        return true
    end

    if #allowedJobs then
        local playerJob = GetPlayerJob()
        for k,v in ipairs(allowedJobs) do
            if playerJob == v then
                allowedJob = true
                break
            end
        end
    end

    if #allowedVehicleModels then
        local playerPed = PlayerPedId()
        local playerVeh = GetVehiclePedIsIn(playerPed, false)
        local playerVehModel = GetEntityModel(playerVeh)
        for k,v in ipairs(allowedVehicleModels) do
            if playerVehModel == GetHashKey(v) then
                allowedVehicle = true
                break
            end
        end
    end

    if needBoth then
        if allowedJob and allowedVehicle then
            return true
        end
    else
        if allowedJob or allowedVehicle then
            return true
        end
    end

    return false
end
