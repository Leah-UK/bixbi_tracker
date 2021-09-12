ESX = nil 
Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(1) 
    end
end) 

AddEventHandler('onResourceStart', function(resourceName)
	if (resourceName == GetCurrentResourceName() and Config.Debug) then
		while (ESX == nil) do
            Citizen.Wait(100)
        end
        
        Citizen.Wait(10000)
        ESX.PlayerLoaded = true
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler("esx:playerLoaded", function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true

	Citizen.Wait(2000)
	if (Config.Jobs[ESX.PlayerData.job.name] ~= nil and Config.Jobs[ESX.PlayerData.job.name].autojoin and exports['bixbi_core']:itemCount('tracker') > 0) then
		JoinGroup(ESX.PlayerData.playerId)
	end
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function IsInRestrictedList(groupName)
	for k,v in pairs(Config.RestrictedGroups) do
		if v == groupName then
			return true
		end
	end
	return false
end

function CustomColour()
	local keyboard = exports["nh-keyboard"]:KeyboardInput({
		header = "Custom Colour", 
		rows = {
			{
				id = 0, 
				txt = "Number - docs.fivem.net/docs/game-references/blips/"
			}
		}
	})
	if keyboard ~= nil then
		if keyboard[1].input == nil then return 0 end
		local number = tonumber(keyboard[1].input)
		if (number == nil) then return 0 end

		if (number > 84 or number < 0) then number = 0 end
		return number
	end
end

function AddNewTag()
	ESX.UI.Menu.CloseAll()

	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		local keyboard = exports["nh-keyboard"]:KeyboardInput({
			header = "Add Tag", 
			rows = {
				{
					id = 0, 
					txt = "Reason"
				},
				{
					id = 1, 
					txt = "Length (minutes)"
				}
			}
		})
		if keyboard ~= nil then
			if keyboard[1].input == nil or keyboard[2].input == nil then return end
			if tonumber(keyboard[2].input == nil) then return end

			local playerPed = PlayerPedId()
	
			exports['bixbi_core']:Loading(10000, 'Applying Tag')
			exports['bixbi_core']:playAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -1, false)
			local ped = GetPlayerPed(closestPlayer)
			FreezeEntityPosition(ped, true)
			
			Citizen.Wait(10000)
			ClearPedTasks(playerPed)
			FreezeEntityPosition(ped, false)

			TriggerServerEvent('bixbi_tracker:TaggerAdd', GetPlayerServerId(PlayerId()), true, GetPlayerServerId(closestPlayer), keyboard[1].input, tonumber(keyboard[2].input) * 60000)
		end
	end
end

function RemoveTag()
	ESX.UI.Menu.CloseAll()
	local playerPed = PlayerPedId()
	
	exports['bixbi_core']:Loading(10000, 'Removing Tag')
	exports['bixbi_core']:playAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -1, false)
	Citizen.Wait(10000)

	ClearPedTasks(playerPed)
	
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('bixbi_tracker:TagRemoveAtId', GetPlayerServerId(closestPlayer))
	end
end