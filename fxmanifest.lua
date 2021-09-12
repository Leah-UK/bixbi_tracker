--[[----------------------------------
Creation Date:	24/01/21
]]------------------------------------
fx_version 'adamant'
game 'gta5'
author 'Leah#0001'
version '1.1'
versioncheck 'https://raw.githubusercontent.com/Leah-UK/bixbi_tracker/master/fxmanifest.lua'

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
    -- '@mysql-async/lib/MySQL.lua',
	'server/server.lua',
    'server/sv_tracker.lua',
	'server/sv_tag.lua'
}

dependencies {
	'oxmysql',
	'bixbi_core',
	'nh-keyboard'
}