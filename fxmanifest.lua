fx_version 'cerulean'
game 'gta5'
Author 'Samy'
description 'Samy_Extras'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config/*.lua'
}

files {
    'locales/*.json'
}

client_scripts {
    'client/*.lua'
}

escrow_ignore {
    'client/*.lua',
    'config/*.lua',
    'locales/*.json'
}