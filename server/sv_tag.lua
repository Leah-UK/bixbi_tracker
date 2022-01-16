taggedPlayers = {}
ESX.RegisterUsableItem('trackertag', function(source)
	TriggerClientEvent('bixbi_tracker:OpenTagMenu', source)
end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	Citizen.Wait(1000)
	exports.oxmysql:scalar('SELECT bixbi_tag FROM users WHERE identifier = ?', { xPlayer.identifier	},
	function(result)
		local info = json.decode(result)
		if (info ~= nil and info.time > 0) then
			TriggerEvent('bixbi_tracker:TaggerAdd', playerId, false, playerId, info.reason, info.time)
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.TagCheckTime * 1000)

		for _, player in pairs(taggedPlayers) do
			if (tonumber(player.time) > 0) then
				local UpdateInfo = {time = math.ceil(player.time - (Config.TagCheckTime * 1000)), reason = player.reason}
				taggedPlayers[player.playerId].time = math.ceil(player.time - (Config.TagCheckTime * 1000))
				
				exports.oxmysql:execute('UPDATE users SET bixbi_tag = ? WHERE identifier = ?', 
					{ player.identifier, json.encode(UpdateInfo) })
			else
				TriggerEvent('bixbi_tracker:TagRemoveAtId', player.playerId)
			end
		end
	end
end)

RegisterServerEvent('bixbi_tracker:TagRemoveAtId')
AddEventHandler('bixbi_tracker:TagRemoveAtId', function(id)
	taggedPlayers[id] = nil
	TriggerClientEvent('bixbi_core:Notify', id, '', 'Bixbi Tracker: You are no longer been tracked by the government.')

    local xPlayer = ESX.GetPlayerFromId(id)
    if (xPlayer == nil) then return end
	exports.oxmysql:execute('UPDATE users SET bixbi_tag = ? WHERE identifier = ?', { '{"time":0,"reason":""}', xPlayer.identifier })
end)

RegisterServerEvent('bixbi_tracker:TaggerAdd')
AddEventHandler('bixbi_tracker:TaggerAdd', function(source, isNew, id, reason, time)
	local xPlayer = ESX.GetPlayerFromId(source)
	if (xPlayer.job.name ~= 'police') then return end

	if (taggedPlayers[id] == nil and id ~= nil) then
		local xTarget = ESX.GetPlayerFromId(id)
		if (xTarget ~= nil) then
			taggedPlayers[id] = {}
			taggedPlayers[id].name = xTarget.name
			taggedPlayers[id].reason = reason
			taggedPlayers[id].playerId = id
			taggedPlayers[id].time = time
			taggedPlayers[id].identifier = xTarget.identifier

			table.insert(taggedPlayers, taggedPlayers[id])
			
			xTarget.triggerEvent('bixbi_core:Notify', 'error', 'Bixbi Tracker: You are now been tracked by the authorities.')
			-- xPlayer.triggerEvent('bixbi_tracker:TagReason', reason)
		end

		if (isNew) then
			local UpdateInfo = {time = tonumber(time), reason = reason}				
			exports.oxmysql:execute('UPDATE users SET bixbi_tag = ? WHERE identifier = ?', {		
				xPlayer.identifier, json.encode(UpdateInfo)
			})
			xPlayer.triggerEvent('bixbi_core:Notify', 'success', 'Bixbi Tracker: Target is now being tracked.')
		end
	end
end)