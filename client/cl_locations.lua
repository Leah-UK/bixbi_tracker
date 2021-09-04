local currentTrackerBlips = {}
local currentTagBlips = {}
RegisterNetEvent('bixbi_core:UpdateTrackerLocs')
AddEventHandler('bixbi_core:UpdateTrackerLocs', function(Players)
	TriggerEvent('bixbi_core:RemoveExistingTrackerBlips')
    RefreshTrackerBlips(Players)
end)

RegisterNetEvent('bixbi_core:UpdateTagLocs')
AddEventHandler('bixbi_core:UpdateTagLocs', function(Players)
	RemoveExistingTagBlips()
    RefreshTagBlips(Players)
end)

function RefreshTrackerBlips(Players)
    local playerPos = GetEntityCoords(PlayerPedId())
	for id, user in pairs(Players) do
        if (id ~= GetPlayerServerId(PlayerId())) then
            local blip = nil

            if (#(playerPos - vector3(user.coords.x, user.coords.y, user.coords.z)) <= 300) then
                local player = GetPlayerFromServerId(id)
                local ped = GetPlayerPed(player)

                local possible_blip = GetBlipFromEntity(ped)
                if possible_blip ~= 0 then
                    RemoveBlip(possible_blip)
                end

                blip = AddBlipForEntity(ped)
            elseif (user and user.coords) then
                blip = AddBlipForCoord(user.coords.x, user.coords.y, user.coords.z)
            end

            SetBlipSprite(blip, 1)
            SetBlipColour(blip, user.colour)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 4)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(user.name)
            EndTextCommandSetBlipName(blip)
            table.insert(currentTrackerBlips, blip)
        end
    end
end

RegisterNetEvent('bixbi_core:RemoveExistingTrackerBlips')
AddEventHandler('bixbi_core:RemoveExistingTrackerBlips', function()
	for i = #currentTrackerBlips, 1, -1 do
		local b = currentTrackerBlips[i]
		if b ~= 0 then
			RemoveBlip(b)
			table.remove(currentTrackerBlips, i)
		end
	end
end)

function RefreshTagBlips(Players)
    local playerPos = GetEntityCoords(PlayerPedId())
	for id, user in pairs(Players) do
		if (id ~= GetPlayerServerId(PlayerId())) then
            local blip = nil

            if (#(playerPos - vector3(user.coords.x, user.coords.y, user.coords.z)) <= 300) then
                local player = GetPlayerFromServerId(id)
                local ped = GetPlayerPed(player)
    
                local possible_blip = GetBlipFromEntity(ped)
                if possible_blip ~= 0 then
                    RemoveBlip(possible_blip)
                end
    
                blip = AddBlipForEntity(ped)
            elseif (user and user.coords) then
                blip = AddBlipForCoord(user.coords.x, user.coords.y, user.coords.z)
            end

			SetBlipSprite(blip, 188)
            SetBlipColour(blip, 3)
            SetBlipAsShortRange(blip, true)
            SetBlipDisplay(blip, 4)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(user.name .. ' - ' .. user.reason)
            EndTextCommandSetBlipName(blip)
            table.insert(currentTagBlips, blip)
		end
	end
end

function RemoveExistingTagBlips()
	for i = #currentTagBlips, 1, -1 do
		local b = currentTagBlips[i]
		if b ~= 0 then
			RemoveBlip(b)
			table.remove(currentTagBlips, i)
		end
	end
end