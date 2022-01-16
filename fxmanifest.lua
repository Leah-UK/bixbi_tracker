--[[----------------------------------
Creation Date:	24/01/21
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Leah#0001'
version '1.1.3'
versioncheck 'https://raw.githubusercontent.com/Leah-UK/bixbi_tracker/master/fxmanifest.lua'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua', -- Remove if you're using a version before ESX 1.3
	'config.lua'
}

client_scripts {
    'client/client.lua',
	'client/cl_menus.lua',
	'client/cl_locations.lua'
} 
 
server_scripts {
    -- '@mysql-async/lib/MySQL.lua',
	'server/server.lua',
    'server/sv_tracker.lua',
	'server/sv_tag.lua'
}

dependencies {
	'bixbi_core'--,
	-- 'ox_inventory'
}