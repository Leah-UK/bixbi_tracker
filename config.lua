Config = {}

Config.Debug = true -- Disable if you aren't developing on the script / Allows live-restarting of the script.

-- Config.EnableVehicleTracking = true
Config.TagCheckTime = 30 -- How often to check database for tag status

-- Only add jobs here that you want to force players to use IF they're part of that job. 
-- For example, if the player is a police officer they should instantly be put inside the group "emergency".
Config.Jobs = {
	police = { colour = 3, selfcolour = true, parent = "emergency", autojoin = true },
	ambulance = { colour = 23, selfcolour = true, parent = "emergency", autojoin = true },
	lostmc = { colour = 76, selfcolour = true, parent = nil, autojoin = false }
	--jobname = {
		-- colourofblip = https://docs.fivem.net/docs/game-references/blips/,
		-- selfcolour = ??, If set to true the player can customize their blip colour themselves.
		-- parent = nil,
		-- autojoin = ??, If set to true the player will automatically join that group on server join.
	--}
}

-- If parent is set then that will be the group they join. If you want this group to be restricted then please add it below.
Config.RestrictedGroups = {"emergency","test"}

-- Set to false(bool) to disable. When enabled and job autojoin is enabled the person must have the item.
Config.AutoPromptItem = 'tracker'
