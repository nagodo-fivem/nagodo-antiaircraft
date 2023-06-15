fx_version 'cerulean'
game  'gta5' 

author 'Nagodo'

shared_scripts {
    'shared/config.lua'
}

client_scripts {
    'client/main.lua',
    'client/job.lua',
}

escrow_ignore {
    'shared/config.lua',
    'client/job.lua',
}

lua54 'yes'