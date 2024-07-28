-- This script is created by fill_ma_hooters

ESX = nil

-- Retrieve ESX instance
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Define the command to spawn a vehicle
RegisterCommand('spawnvehicle', function(source, args, rawCommand)
    -- Get ESX player data
    local xPlayer = ESX.GetPlayerFromId(source)

    -- Check if the player is an admin
    if xPlayer and xPlayer.getGroup() == 'admin' then
        -- Check if the player has specified a vehicle model
        if #args < 1 then
            TriggerClientEvent('chat:addMessage', source, {
                args = { "Usage: /spawnvehicle [vehicle_name]" }
            })
            return
        end

        -- Get the vehicle model from the command arguments
        local vehicleName = args[1]

        -- Request the vehicle model
        RequestModel(vehicleName)

        -- Wait until the model is loaded
        while not HasModelLoaded(vehicleName) do
            Wait(500)
        end

        -- Get the player's coordinates
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)

        -- Create the vehicle at the player's coordinates
        local vehicle = CreateVehicle(vehicleName, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
        
        -- Set the player as the driver of the vehicle
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

        -- Notify the player
        TriggerClientEvent('chat:addMessage', source, {
            args = { "Vehicle spawned: " .. vehicleName }
        })

        -- Release the vehicle model
        SetModelAsNoLongerNeeded(vehicleName)
    else
        -- Notify the player if they are not an admin
        TriggerClientEvent('chat:addMessage', source, {
            args = { "You do not have permission to use this command." }
        })
    end
end, false)
