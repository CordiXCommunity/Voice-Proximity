-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Server/commands.lua : console commands to test without being in game.
-- They only work when debug = true in Shared/config.lua.

local CFG = VoiceProximity
local T = CFG.T
local SIDE = "SERVER"

local function requireDebug()
    if not CFG.debug then
        Console.Warn(T("need_debug"))
        return false
    end
    return true
end

local function out(text)
    Console.Log(text)
end

-- voice_debug : prints the config and each connected player's state
Console.RegisterCommand("voice_debug", function()
    if not requireDebug() then return end

    out(T("report_title"))
    out(T("report_cfg", tostring(CFG.key), tostring(CFG.defaultMode),
        tostring(CFG.unitsPerMeter), tostring(CFG.language)))
    for i, mode in ipairs(CFG.modes) do
        out(T("report_mode", i, mode.id, mode.meters, mode.meters * CFG.unitsPerMeter, CFG.ToHex(mode.color)))
    end

    local problems = CFG.Validate()
    if #problems == 0 then
        out(T("report_check_ok"))
    else
        out(T("report_check_n", #problems))
        for _, problem in ipairs(problems) do
            Console.Warn("  - " .. problem)
        end
    end

    local count = 0
    for _, player in pairs(Player.GetAll()) do
        count = count + 1
        local index = player:GetValue("voice_mode")
        local mode = index and CFG.modes[index]
        if mode then
            out(T("report_player", tostring(player:GetName()), mode.id, mode.meters))
        else
            out(T("report_player_no", tostring(player:GetName())))
        end
    end
    if count == 0 then out(T("report_none")) end
end, T("cmd_debug_desc"))

-- voice_test : simulates key presses, no player needed
Console.RegisterCommand("voice_test", function()
    if not requireDebug() then return end

    out(T("test_title"))
    local current = CFG.defaultMode
    for press = 1, #CFG.modes + 1 do
        current = (current % #CFG.modes) + 1
        local mode = CFG.modes[current]
        out(T("test_press", press, current, mode.id, mode.meters, mode.meters * CFG.unitsPerMeter))
    end
    out(T("test_loop", #CFG.modes))
end, T("cmd_test_desc"))

-- voice_setmode <name> <1-n> : forces a connected player's mode
Console.RegisterCommand("voice_setmode", function(name, index)
    if not requireDebug() then return end

    index = tonumber(index)
    if not name or not index or not CFG.modes[index] then
        Console.Warn(T("setmode_usage", #CFG.modes))
        return
    end

    for _, player in pairs(Player.GetAll()) do
        if player:GetName() == name then
            CFG.Apply(player, index)
            return
        end
    end
    Console.Warn(T("player_not_found", tostring(name)))
end, T("cmd_setmode_desc"), { "name", "mode" })

CFG.Log(SIDE, T("cmd_registered"))
