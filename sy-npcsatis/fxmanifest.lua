fx_version 'cerulean'
game 'gta5'

description 'NPC Üzerinden Eşya Satış Scripti'
version '1.0.0'

shared_script '@qb-core/shared/locale.lua'
server_script 'server.lua'
client_script 'client.lua'

dependencies {
    'qb-core',
    'qb-target'
}
