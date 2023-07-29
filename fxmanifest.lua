fx_version 'cerulean'
games { 'gta5' }
author 'Fly Development'


server_scripts {
     '@mysql-async/lib/MySQL.lua',
     'server/server.lua',
     'bot.js',
     'config/Config.lua'
} 
client_scripts {
     'client/client.lua',
     'config/Config.lua'
}


ui_page 'web/ui.html'
files {
     'web/ui.html',
     'web/script.js',
     'web/style.css',
     'web/font/*.ttf',
     'web/images/*.png' --Only png images
}

shared_script '@es_extended/imports.lua'