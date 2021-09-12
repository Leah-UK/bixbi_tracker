RegisterNetEvent('bixbi_tracker:OpenMenu')
AddEventHandler('bixbi_tracker:OpenMenu', function(source)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'MainMenu', {
		title    = Config.TrackerName .. 'Main Menu',
		align    = 'right',
		elements = {
			{label = 'Join', value = 'join'},
			{label = 'Disband', value = 'disband'},
			{label = 'Leave', value = 'leave'}

	}}, function(data, menu)
		if data.current.value == 'join' then
			JoinGroup(GetPlayerServerId(PlayerId()))
		elseif data.current.value == 'disband' then
            TriggerServerEvent('bixbi_tracker:Disband', GetPlayerServerId(PlayerId()))
			ESX.UI.Menu.CloseAll()
		elseif data.current.value == 'leave' then
            TriggerServerEvent('bixbi_tracker:RemoveAtId', source)
            ESX.UI.Menu.CloseAll()
		end
	end, function(data, menu)
		menu.close()
	end)
end)

function JoinGroup(source)
	if Config.Jobs[ESX.PlayerData.job.name] ~= nil then
		local group = ESX.PlayerData.job.name
		if Config.Jobs[ESX.PlayerData.job.name].parent ~= nil then
			group = Config.Jobs[ESX.PlayerData.job.name].parent
		end

		if Config.Jobs[ESX.PlayerData.job.name].colour == -1 or Config.Jobs[ESX.PlayerData.job.name].selfcolour == true then
			TrackerMenu(group, Config.Jobs[ESX.PlayerData.job.name].colour)
		else
			TriggerServerEvent('bixbi_tracker:Add', source, group, Config.Jobs[ESX.PlayerData.job.name].colour)
			ESX.UI.Menu.CloseAll()
		end
	else
		ESX.UI.Menu.Open(
		'dialog', GetCurrentResourceName(), 'GroupName',
		{
		title = "Name of Group"
		},
		function(data4, menu4)
			local group = data4.value

			if Config.Jobs[group] == nil and not IsInRestrictedList(group) then
				menu4.close()
				TrackerMenu(group, -1)
			else
				exports['bixbi_core']:Notify('error', Config.TrackerName .. 'You do not have access to this channel.')
				ESX.UI.Menu.CloseAll()
			end
			
		end, function(data4, menu4)
			menu4.close()
		end)
	end
end

function TrackerMenu(group, colourInput)
	local elements = {
		{label = 'Red', value = 'red'},
		{label = 'Green', value = 'green'},
		{label = 'Blue', value = 'blue'},
		{label = 'Purple', value = 'purple'},
		{label = 'Pink', value = 'pink'},
		{label = 'Yellow', value = 'yellow'},
		{label = 'White', value = 'white'}
	}

	if (colourInput ~= -1) then
		table.insert(elements, {label = 'Default', value = 'default'})
	end
	table.insert(elements, {label = 'Custom', value = 'custom'})

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Tracker-Colour', {
		title    = 'Tracker Colour',
		align    = 'right',
		elements = elements

	}, function(data2, menu2)
		local colourChosen = data2.current.value
		local colour = 0
		if colourChosen == 'red' then
			colour = 1
		elseif colourChosen == 'green' then
			colour = 2
		elseif colourChosen == 'blue' then
			colour = 3
		elseif colourChosen == 'purple' then
			colour = 27
		elseif colourChosen == 'pink' then
			colour = 34
		elseif colourChosen == 'yellow' then
			colour = 46
		elseif colourChosen == 'default' then
			colour = colourInput
		elseif colourChosen == 'custom' then
			colour = CustomColour()
		else
			colour = 0
		end

		TriggerServerEvent('bixbi_tracker:Add', GetPlayerServerId(PlayerId()), group, colour)
		ESX.UI.Menu.CloseAll()

	end, function(data2, menu2)
		menu2.close()
	end)
end


RegisterNetEvent('bixbi_tracker:OpenTagMenu')
AddEventHandler('bixbi_tracker:OpenTagMenu', function(source)
	ESX.UI.Menu.CloseAll()
	if source == nil then source = GetPlayerServerId(PlayerId()) end

	-- if Config.TagJobs[ESX.PlayerData.job.name] == nil then
	-- 	exports['bixbi_core']:Notify('error', Config.TrackerName .. 'you cannot access this.')
	-- 	return
	-- end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'MainMenu', {
		title    = Config.TrackerName .. 'Main Menu',
		align    = 'right',
		elements = {
			{label = 'Add Tag', value = 'add'},
			{label = 'Remove Tag', value = 'remove'}

	}}, function(data, menu)
		if data.current.value == 'add' then
			AddNewTag()
		elseif data.current.value == 'remove' then
			RemoveTag()
		end
	end, function(data, menu)
		menu.close()
	end)
end)