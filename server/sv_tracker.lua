groupBlips = {}
local trackedPlayers = {}

ESX.RegisterUsableItem('tracker', function(source)
    TriggerClientEvent('bixbi_tracker:OpenMenu', source)
end)

-- function IsInGroup(id)
-- 	if trackedPlayers[id] == nil then
-- 		return false
-- 	else
-- 		TriggerClientEvent('bixbi_core:Notify', id, 'error', Config.TrackerName .. 'You\'re currently tracking group - ' .. trackedPlayers[id])
-- 		return true
-- 	end
-- end

RegisterServerEvent('bixbi_tracker:Add')
AddEventHandler('bixbi_tracker:Add', function(id, group, colour)
	if (trackedPlayers[id] == nil) then
		local xPlayer = ESX.GetPlayerFromId(id)

		if (groupBlips[group] == nil or groupBlips[group].users == { }) then
			groupBlips[group] = {
				owner = id,
				name = group,
				users = { }
			}
			groupBlips[group].users[id] = { playerId = id, name = xPlayer.name, colour = colour }
			
			trackedPlayers[id] = group
			TriggerClientEvent('bixbi_core:Notify', id, '', Config.TrackerName .. 'You have created the group - ' .. group)
		else
			if (groupBlips[group].users[id] == nil) then
				groupBlips[group].users[id] = { playerId = id, name = xPlayer.name, colour = colour }
				trackedPlayers[id] = group

				for _, player in pairs(groupBlips[group].users) do
					TriggerClientEvent('bixbi_core:Notify', player.playerId, 'success', Config.TrackerName .. xPlayer.name .. ' has joined the group.')
				end
			end
		end
	end
end)

RegisterServerEvent('bixbi_tracker:RemoveAtId')
AddEventHandler('bixbi_tracker:RemoveAtId', function(id)
	local xPlayer = ESX.GetPlayerFromId(id)
	if (xPlayer == nil) then return end
	local group = trackedPlayers[id]

	if (group == nil) then
		xPlayer.triggerEvent('bixbi_core:Notify', 'error', Config.TrackerName .. 'You aren\'t in a group.')
		return
	end

	trackedPlayers[xPlayer.playerId] = nil
	groupBlips[group].users[xPlayer.playerId] = nil

	xPlayer.triggerEvent('bixbi_core:Notify', 'error', Config.TrackerName .. 'You have left the group - ' .. group)

	for _, v in pairs(groupBlips[group].users) do
		TriggerClientEvent('bixbi_core:Notify', v.playerId, 'error', Config.TrackerName .. xPlayer.name .. ' has left the group')
	end	
end)

RegisterServerEvent('bixbi_tracker:Disband')
AddEventHandler('bixbi_tracker:Disband', function(source)
	local group = trackedPlayers[source]
	local groupInfo = groupBlips[group]

	if (groupInfo.owner ~= source or group == "emergency") then
			TriggerClientEvent('bixbi_core:Notify', source, 'error', Config.TrackerName .. 'You do not lead this group. Owner = ' .. groupInfo.owner)
		return
	end

	for _, user in pairs(groupBlips[group].users) do
		TriggerClientEvent('bixbi_core:Notify', user.playerId, 'error', Config.TrackerName .. 'The group has been disbanded.')
		TriggerClientEvent('bixbi_core:RemoveExistingTrackerBlips', user.playerId)
		trackedPlayers[user.playerId] = nil
	end
	groupBlips[group] = nil
end)

AddEventHandler("playerDropped", function()
	TriggerEvent('bixbi_tracker:RemoveAtId', source)
	if (taggedPlayers[id] ~= nil) then taggedPlayers[id] = nil end
end)