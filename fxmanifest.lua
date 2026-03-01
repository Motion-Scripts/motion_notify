fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Motion Scripts'
description 'Motion Notify - Modern Notification System with Sound Support'
version '1.1.4'

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

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/alert.ogg',
}

exports {
    'Notify',
}
