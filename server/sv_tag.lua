if (Config.EnableTrackerTag) then
	ESX.RegisterUsableItem('trackertag', function(source)
		TriggerClientEvent('bixbi_tracker:OpenTagMenu', source)
	end)

	taggedPlayers = {}
	AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
		Citizen.Wait(1000)
		MySQL.Async.fetchAll('SELECT bixbi_tag FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			for _,v in pairs(result) do
				local info = json.decode(v.bixbi_tag)
				if info.time > 0 then
					TriggerEvent('bixbi_tracker:TaggerAdd', false, playerId, info.reason, info.time)
				end
			end
		end)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(Config.TagCheckTime * 1000)

			for playerId, player in pairs(taggedPlayers) do
				if (tonumber(player.time) > 0) then
					local UpdateInfo = {time = math.ceil(player.time - (Config.TagCheckTime * 1000)), reason = player.reason}
					taggedPlayers[playerId].time = math.ceil(player.time - (Config.TagCheckTime * 1000))
					
					MySQL.Async.execute('UPDATE users SET bixbi_tag = @bixbi_tag WHERE identifier = @identifier', {		
						['@identifier'] = player.xpid,
						['@bixbi_tag'] = json.encode(UpdateInfo)
					})
				else
					TriggerEvent('bixbi_tracker:TagRemoveAtId', playerId)
				end
			end
		end
	end)

	RegisterServerEvent('bixbi_tracker:TagRemoveAtId')
	AddEventHandler('bixbi_tracker:TagRemoveAtId', function(id)
		local xPlayer = ESX.GetPlayerFromId(id)
		taggedPlayers[id] = nil
		TriggerClientEvent('bixbi_core:Notify', id, '', Config.TrackerName .. 'You are no longer been tracked by the government.')

		MySQL.Async.execute('UPDATE users SET bixbi_tag = @bixbi_tag WHERE identifier = @identifier', {		
			['@identifier'] = xPlayer.identifier,
			['@bixbi_tag'] = '{"time":0,"reason":""}'
		})
	end)

	RegisterServerEvent('bixbi_tracker:TaggerAdd')
	AddEventHandler('bixbi_tracker:TaggerAdd', function(source, isNew, id, reason, time)
		local xPlayer = ESX.GetPlayerFromId(source)
		if (xPlayer.job.name ~= 'police') then return end

		if taggedPlayers[id] == nil and id ~= nil then
			local xPlayer = ESX.GetPlayerFromId(id)
			if xPlayer ~= nil then
				taggedPlayers[id] = {}
				taggedPlayers[id].name = xPlayer.name
				taggedPlayers[id].reason = reason
				taggedPlayers[id].playerId = id
				taggedPlayers[id].time = time
				taggedPlayers[id].xpid = xPlayer.identifier
				
				xPlayer.triggerEvent('bixbi_core:Notify', '', Config.TrackerName .. 'You are now been tracked by the authorities.')
				xPlayer.triggerEvent('bixbi_tracker:TagReason', reason)
			end

			if (isNew) then
				local UpdateInfo = {time = tonumber(time), reason = reason}				
				MySQL.Async.execute('UPDATE users SET bixbi_tag = @bixbi_tag WHERE identifier = @identifier', {		
					['@identifier'] = xPlayer.identifier,
					['@bixbi_tag'] = json.encode(UpdateInfo)
				})
			end
		end
	end)
end