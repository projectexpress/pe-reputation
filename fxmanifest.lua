fx_version 'cerulean'
game 'gta5'

description 'pe-reputation'
author 'Project Express'
version '0.0.1'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/utility.lua',
    'server/*.lua',
}

dependencies {
    'qb-core',
    'oxmysql'
}

lua54 'yes'