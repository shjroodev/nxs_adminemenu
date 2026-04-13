fx_version 'bodacious'
lua54 'yes' 
game 'gta5' 

author '@shjroo'
description 'NXS Admin Menu - Staff System'
version '1.0'

escrow_ignore {
    "config.lua",
    "server_config.lua"
}

client_scripts {
    'client.lua'
}

shared_scripts {
    'config.lua',
}
server_scripts {
   '@mysql-async/lib/MySQL.lua',
   'server_config.lua',
   'server.lua',
   'botapi.lua'
}

ui_page 'web/index.html'

files {
    'web/*.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/fonts/*.otf',
}