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

--[[--------------------------------------------------
Tag Code
]]----------------------------------------------------
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
	
			exports['bixbi_core']:Loading(10000, 'Applying Tag')
			exports['bixbi_core']:playAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -1, false)
			Citizen.Wait(10000)
			ClearPedTasks(PlayerPedId())
	
			TriggerServerEvent('bixbi_tracker:TaggerAdd', GetPlayerServerId(PlayerId()), true, GetPlayerServerId(closestPlayer), keyboard[1].input, tonumber(keyboard[2].input) * 1000)
		end
	end
end

function RemoveTag()
	ESX.UI.Menu.CloseAll()
	
	exports['bixbi_core']:Loading(10000, 'Removing Tag')
	exports['bixbi_core']:playAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', -1, false)
	Citizen.Wait(10000)

	ClearPedTasks(PlayerPedId())
	
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 3.0 then
		TriggerServerEvent('bixbi_tracker:TagRemoveAtId', GetPlayerServerId(closestPlayer))
	end
end