-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Server/voice.lua : handles each player's voice mode and range.

local CFG = VoiceProximity
local T = CFG.T
local SIDE = "SERVER"

local function valid(entity)
    return entity ~= nil and entity.IsValid ~= nil and entity:IsValid()
end

local function sendState(player)
    local index = player:GetValue("voice_mode") or CFG.defaultMode
    Events.CallRemote("VoiceProximity:Mode", player, Reliability.Reliable, index)
    CFG.Log(SIDE, T("mode_sent", index, tostring(player:GetName())))
end

function CFG.Apply(player, index)
    if not valid(player) then return false end
    local mode = CFG.modes[index]
    if not mode then
        CFG.Warn(SIDE, T("unknown_mode", tostring(index)))
        return false
    end

    player:SetValue("voice_mode", index, false)

    local units = mode.meters * CFG.unitsPerMeter
    local ok, err = pcall(function()
        player:SetVOIPLocalSetting(VOIPSetting.Both)
        player:SetVOIPLocalMaxDistance(units)
    end)
    if ok then
        CFG.Log(SIDE, T("mode_applied", tostring(player:GetName()), mode.id, mode.meters, units))
    else
        CFG.Warn(SIDE, T("setvoip_fail", tostring(player:GetName()), tostring(err)))
    end

    sendState(player)
    return ok
end

Events.SubscribeRemote("VoiceProximity:Cycle", function(player)
    local current = player:GetValue("voice_mode") or CFG.defaultMode
    CFG.Log(SIDE, T("key_received", tostring(player:GetName()), current))
    CFG.Apply(player, (current % #CFG.modes) + 1)
end)

Events.SubscribeRemote("VoiceProximity:Request", function(player)
    CFG.Log(SIDE, T("state_requested", tostring(player:GetName())))
    CFG.Apply(player, player:GetValue("voice_mode") or CFG.defaultMode)
end)

Player.Subscribe("Spawn", function(player)
    CFG.Log(SIDE, T("spawn_player", tostring(player:GetName())))
    CFG.Apply(player, CFG.defaultMode)
    Timer.SetTimeout(function()
        if valid(player) then sendState(player) end
    end, 1500)
end)

Package.Subscribe("Load", function()
    local problems = CFG.Validate()
    if #problems > 0 then
        for _, problem in ipairs(problems) do
            CFG.Warn(SIDE, T("config_problem", problem))
        end
    else
        CFG.Log(SIDE, T("config_valid", #CFG.modes, CFG.key))
    end

    for _, player in pairs(Player.GetAll()) do
        CFG.Apply(player, player:GetValue("voice_mode") or CFG.defaultMode)
    end

    Console.Log(T("ready", #CFG.modes, tostring(CFG.debug), tostring(CFG.language)))
end)
