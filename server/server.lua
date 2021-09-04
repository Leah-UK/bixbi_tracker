ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetResourceState('bixbi_core') ~= 'started' ) then
        print('Bixbi_Tracker - ERROR: Bixbi_Core hasn\'t been found! This could cause errors!')
    end
end)

Citizen.CreateThread(function()
	while true do
		for group, info in pairs(groupBlips) do
            for _, user in pairs(info.users) do
                local xPlayer = ESX.GetPlayerFromId(user.playerId)
                if (xPlayer.getInventoryItem('tracker').count > 0) then
                    groupBlips[group].users[user.playerId].coords = xPlayer.coords
                    xPlayer.triggerEvent('bixbi_core:UpdateTrackerLocs', groupBlips[group].users)

                    if (#taggedPlayers > 0 and xPlayer.job.name == 'police') then
                        for _, tag in pairs(taggedPlayers) do
                            local xTarget = ESX.GetPlayerFromId(tag.playerId)
                            taggedPlayers[tag.playerId].coords = xTarget.coords
                            xPlayer.triggerEvent('bixbi_core:UpdateTagLocs', taggedPlayers)
                        end
                    end
                end
            end
        end	
		Citizen.Wait(3000)
	end
end)