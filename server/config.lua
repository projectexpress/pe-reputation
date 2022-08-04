Config = {}

-- Discord Integration
Config.UseDiscord = false
Config.DiscordWebhook = ''
Config.DebugDevelopmentURL = false
Config.DevelopmentServerURL = ''

-- General Options
-- -> This option lets you set a default reputation amount in case the specified amount in code is not found. This is simply a fallback option to ensure the player still receives some amount of reputation.
Config.DefaultAction = 1
-- -> Would you like debug messages to be sent to the server console.
Config.DebugMessages = true
-- -> Which notification system do you use? Currently only supports 'qb-core'.
Config.NotificationSystem = 'qb-core'

-- Reputation Table
-- -> This table defines all of the identifiers, levels, actions, and other important details for adding and removing reputation.
Config.Reputation = {
    ['burgershot'] = {
        ['grades'] = {
            ['0'] = {
                minimum = 0,
                maximum = 10000
            },
            ['1'] = {
                minimum = 20001,
                maximum = 30000
            },
            ['2'] = {
                minimum = 30001,
                maximum = 40000
            },
            ['3'] = {
                minimum = 40001,
                maximum = 50000
            },
            ['4'] = {
                minimum = 50001,
                maximum = 60000
            },
        },
        ['actions'] = {
            ['sold_burger'] = 2
        },
        ['isJob'] = true
    }
}