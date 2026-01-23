fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Motion Scripts'
description 'Motion Notify - Modern Notification System with Sound Support'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua',
    '_versioncheck.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/alert.ogg',
}

exports {
    'Notify',
}