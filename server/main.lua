local QBCore = exports['qb-core']:GetCoreObject()

-- Functions
local function GetReputationXP(Player, identifier)
    return Player.PlayerData.metadata['pe-jobrep'][identifier] or false
end

local function GetReputationLevel(Player, identifier)
    local currentXp = GetReputationXP(Player, identifier)
    for k,v in pairs(Config.Reputation[identifier]['grades']) do
        local gradeMaximum = v.maximum
        local gradeMinimum = v.minimum

        if currentXp > gradeMinimum and currentXp < gradeMaximum then
            return k
        end
    end
    return false
end

local function AddReputationType(identifier, grades, actions, isJob)
    local isJob = isJob or false
    if not identifier or not grades or not actions then Utility_DebugMessage('server/main.lua', 'AddReputationType()', string.format('Tried adding a reputation type (%s) but not all of the arguments were filled out.', identifier)) return end
    if Config.Reputation[identifier] then Utility_DebugMessage('server/main.lua', 'AddReputationType()', 'Tried adding a reputation type (%s) but it seems that type already exists.', identifier) return end

    Config.Reputation[identifier] = {
        ['grades'] = grades,
        ['actions'] = actions,
        ['isJob'] = isJob
    }

    if Config.Reputation[identifier] then return true else return false end
end

local function AddReputation(args)
    if not Utility_CheckRequiredArguments(args) then return end
    local source = args.source
    local identifier = args.identifier

    local reputationTable = Utility_DoesReputationExist(identifier)
    if not reputationTable then
        local message = string.format('Tried to add %d points to %s for %s but that reputation identifier does not exist.', amount, GetPlayerName(source), identifier)
        Utility_DebugMessage('server/main.lua', 'AddReputation()', message)
        Utility_DiscordLog('red', 'pe-reputation | server/main.lua | AddReputation()', '| FAILED | ' .. message)
        return
    end

    local isJob = reputationTable['isJob']
    local isOther = not isJob
    local action = args.action
    local amount = reputationTable['actions'][action] or Config.DefaultAction
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    local grades = reputationTable['grades']

    if isJob then
        local currentPlayerGrade = Player.PlayerData.job.grade
        if GetReputationLevel(Player, identifier) ~= currentPlayerGrade then
            Player.Functions.SetJob(identifier, GetReputationLevel(Player, identifier))
            local message = string.format('While calculating the new rep for %s, we had to set their job as they weren\'t the proper grade for their reputation xp.', Player.PlayerData.name)
            Utility_DebugMessage('server/main.lua', 'AddReputation()', message)
            Utility_DiscordLog('red', 'pe-reputation | server/main.lua | AddReputation()', '| FAILED | ' .. message)
        end
        local configGrade = grades[currentPlayerGrade]
        local newXp = GetReputationXP(Player, identifier)
        if newXp > configGrade.maximum then
            -- add rep, promote
            Utility_AddPlayerReputation(Player, identifier, amount)
            local newGrade = GetReputationLevel(Player, identifier)
            Player.Functions.SetJob(identifier, newGrade)
            Utility_Notify(Player.PlayerData.source, 'You have been promoted!', 'success')
        elseif newXp < configGrade.maximum and newXp > configGrade.minimum then
            -- add rep, don't promote
            Utility_AddPlayerReputation(Player, identifier, amount)
            Utility_DiscordLog('green', 'pe-reputation | server/main.lua | AddReputation()', string.format('| SUCCESS | %s (%s) has gained %d reputation points towards %s -> Action: %s.', Player.PlayerData.name, Player.PlayerData.citizenid, amount, identifier, action))
        else
            -- already max grade.
            -- don't add rep, don't promote.
            Utility_DiscordLog('blue', 'pe-reputation | server/main.lua | AddReputation()', string.format('| INFO | %s (%s) should\'ve gained %d reputation points towards %s, but they are already the max level -> Action: %s.', Player.PlayerData.name, Player.PlayerData.citizenid, amount, identifier, action))
        end
    elseif isOther then
    end
end

local function UpdateReputationForAllPlayers()
    -- Unfinished; will return to at a later time.
end

-- Exports
exports("AddReputationType", AddReputationType)
exports("AddReputation", AddReputation)

-- Events
AddEventHandler('onResourceStart', function(r)
    if GetCurrentResourceName() ~= r then return end
	if Config.DebugDevelopmentURL then
        print(GetConvar("web_baseUrl", "not found"))
    end
end)

RegisterServerEvent('pe-reputation:server:AddReputationType')
AddEventHandler('pe-reputation:server:AddReputationType', AddReputationType)

RegisterServerEvent('pe-reputation:server:AddReputation')
AddEventHandler('pe-reputation:server:AddReputation', AddReputation)

-- Callbacks