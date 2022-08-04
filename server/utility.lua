-- Variables
local Colors = {
    ['default'] = 14423100,
    ['blue'] = 255,
    ['red'] = 16711680,
    ['green'] = 65280,
    ['white'] = 16777215,
    ['black'] = 0,
    ['orange'] = 16744192,
    ['yellow'] = 16776960,
    ['pink'] = 16761035,
    ["lightgreen"] = 65309,
}

-- Functions
local function Utility_Notify(source, message, type)
    if Config.NotificationSystem == 'qb-core' then
        TriggerClientEvent('QBCore:Notify', source, message, type)
    end
end

local function Utility_AddPlayerReputation(Player, identifier, amount)
    Player.PlayerData.metadata['pe-jobrep'] = Player.PlayerData.metadata['pe-jobrep'] or {}
    Player.PlayerData.metadata['pe-jobrep'][identifier] = Player.PlayerData.metadata['pe-jobrep'][identifier] + amount
    Player.Functions.UpdatePlayerData()
end

local function Utility_SetPlayerReputation(Player, identifier, amount)
    Player.PlayerData.metadata['pe-jobrep'] = Player.PlayerData.metadata['pe-jobrep'] or {}
    Player.PlayerData.metadata['pe-jobrep'][identifier] = amount
    Player.Functions.UpdatePlayerData()
end

local function Utility_CheckRequiredArguments(args)
    local verification = {
        ['source'] = false,
        ['identifier'] = false,
        ['action'] = false
    }
    
    for k,v in pairs(args) do
        if verification[k] ~= nil then verification[k] = true end
    end
    
    local retval = true
    for k,v in pairs(verification) do
        if not v then
            retval = false
        end
    end
    
    return retval
end

local function Utility_DoesReputationExist(identifier)
    return Config.Reputation[identifier] or false
end

local function Utility_DebugMessage(file, calledFunction, message)
    if not Config.DebugMessages then return end
    print('pe-reputation | ' .. file .. ' | ' .. calledFunction .. ' -> ' .. message)
end

local function Utility_DiscordLog(color, title, message)
    if not Config.UseDiscord then return end
    if GetConvar("web_baseUrl", "") == Config.DevelopmentServerURL then return end
    local embedData = {
        {
            ['title'] = title,
            ['color'] = Colors[color] or Colors['default'],
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = message,
            ['author'] = {
                ['name'] = 'Project Express',
            },
        }
    }
    PerformHttpRequest(Config.DiscordWebhook, function() end, 'POST', json.encode({ username = 'Project Express', embeds = embedData}), { ['Content-Type'] = 'application/json' })
end

local function Utility_GetGradeBasedOnXp(identifier, xp)
    for k,v in pairs(Config.Reputation[identifier]['grades']) do
        local gradeMaximum = v.maximum
        local gradeMinimum = v.minimum

        if xp > gradeMinimum and xp < gradeMaximum then
            return k
        end
    end
    return false
end