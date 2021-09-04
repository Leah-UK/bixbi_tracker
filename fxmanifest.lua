--[[----------------------------------
Creation Date:	24/01/21
]]------------------------------------
fx_version 'adamant'
game 'gta5'
author 'Leah#0001'
version '1.0.0'
versioncheck 'https://raw.githubusercontent.com/Leah-UK/bixbi_tracker/main/fxmanifest.lua'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
    'client/client.lua',
	'client/cl_menus.lua',
	'client/cl_locations.lua'
} 
 
server_scripts {
	'@AntiEventSpam/include.lua',
    '@mysql-async/lib/MySQL.lua',
	'server/server.lua',
    'server/sv_tracker.lua',
	'server/sv_tag.lua'
}

dependencies {
	'bixbi_core',
	'nh-keyboard'
}