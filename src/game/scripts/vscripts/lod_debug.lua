local Debug = {}

-- require('lib/util_aar')

-- Init debug functions
function Debug:init()
    -- Only allow init once
    if self.doneInit then return end
    self.doneInit = true
    self.init = nil

    -- copy self into global scope
    _G.Debug = self

    -- Debug command for debugging, this command will only work for Ash47
    Convars:RegisterCommand('player_say', function(...)
        local arg = {...}
        table.remove(arg,1)
        local sayType = tonumber(arg[1])
        table.remove(arg,1)

        local cmdPlayer = Convars:GetCommandClient()
        local text = table.concat(arg, " ")

        print("Chat")

        if (sayType == 4) then
            print(4)
        elseif (sayType == 3) then
            print(3)
        elseif (sayType == 2) and PlayerSay.teamChatCallback then
            print(2)
        elseif PlayerSay.allChatCallback then
            print(1)
        end
    end, 'player say', 0)

    Convars:RegisterCommand('kill_team', function(c, team)
        for _,v in pairs(Entities:FindAllByName("npc_dota_hero*")) do
            if IsValidEntity(v) and v:IsNull() == false and v.GetPlayerOwnerID and not v:IsClone() and not v:HasModifier("modifier_arc_warden_tempest_double") then
                print(v:GetTeamNumber(), tonumber(team), team)
                if v:GetTeamNumber() == tonumber(team) then
                    
                    v:Kill(nil, v)
                end
            end
        end
    end, 'kill_team', 0)

    Convars:RegisterCommand('test_aar_duel', function(...)
        local ply = Convars:GetCommandClient()
        if not ply then return end
        local playerID = ply:GetPlayerID()

        local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

        -- _G.duel()
        initDuel()
    end, 'test', 0)

    Convars:RegisterCommand('test_aar_duel_end', function(...)
        local ply = Convars:GetCommandClient()
        if not ply then return end
        local playerID = ply:GetPlayerID()

        local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

        endDuel()
    end, 'test', 0)

    -- Debug command for debugging, this command will only work for Ash47
    Convars:RegisterCommand('lua_exec', function(...)
        local ply = Convars:GetCommandClient()
        if not ply then return end
        local playerID = ply:GetPlayerID()
        local steamID = PlayerResource:GetSteamAccountID(playerID)
        if steamID ~= 28090256 then return end

        local theArgs = {...}
        if #theArgs == 1 then return end

        local toExec = ''
        for i=2,#theArgs do
            toExec = toExec .. ' ' .. theArgs[i]
        end

        -- Execute Lua Code
        print(toExec)
        local res = loadstring(toExec)
        if res then
            -- Run it inside a protected call
            local status, err = pcall(function()
                res()
            end)

            -- Did it fail?
            if not status then
                print(err)
            end
        end
    end, 'test', 0)
end

-- Makes the server say stuff
function Debug:say(txt)
    -- Ensure we have a string
    txt = tostring(txt)

    -- Make the server say it
    SendToServerConsole('say "' .. txt .. '"')
end

-- Lists out all the modifiers a given player has
function Debug:listModifiers(playerID)
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    if not hero then
        print('Failed to find here with playerID = ' .. playerID)
        return
    end

    -- Find all modifiers
    --local modifiers = hero:FindAllModifiers()

    print('Modifiers for playerID = ' .. playerID)
    --for k,modifier in pairs(modifiers) do
    --    print(modifier:GetClassname())
    --end

    local count = hero:GetModifierCount()
    for i=0,count-1 do
        print(hero:GetModifierNameByIndex(i))
    end
end

return Debug