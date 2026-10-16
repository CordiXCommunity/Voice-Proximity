-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Client/voice.lua : HUD, notification, mode switch key and speech detection.

local CFG = VoiceProximity
local T = CFG.T
local SIDE = "CLIENT"

local state = { mode = CFG.defaultMode, talking = false }
local synced = false
local lastPress = 0

CFG.Log(SIDE, T("loading_hud"))
local ui = WebUI("Voice Proximity", "file://UI/index.html")
pcall(function() ui:SetVisibility(WidgetVisibility.HitTestInvisible) end)

-- Notification texts and mode colors for the HUD (indexed like CFG.modes)
local function notificationText(index)
    local mode = CFG.modes[index]
    local name = CFG.ModeName(mode)
    if CFG.notification.showRange then
        return T("notif.mode_range", name, mode.meters)
    end
    return T("notif.mode", name)
end

local function buildInit()
    local texts, colors = {}, {}
    for i, mode in ipairs(CFG.modes) do
        texts[i] = notificationText(i)
        colors[i] = CFG.ToHex(mode.color)
    end
    return {
        hud = CFG.hud,
        notification = {
            enabled = CFG.notification.enabled,
            duration = CFG.notification.duration,
        },
        texts = texts,
        colors = colors,
        debug = CFG.debug,
    }
end

ui:Subscribe("Ready", function()
    CFG.Log(SIDE, T("hud_ready"))
    ui:CallEvent("Init", buildInit())
    ui:CallEvent("SetMode", state.mode, false)
    ui:CallEvent("SetTalking", state.talking)
    Events.CallRemote("VoiceProximity:Request")
end)

Events.SubscribeRemote("VoiceProximity:Mode", function(index)
    CFG.Log(SIDE, T("mode_received", tostring(index)))

    -- notification and circle only on a real change, not on the first sync after joining
    local changed = synced and index ~= state.mode
    state.mode = index
    synced = true

    ui:CallEvent("SetMode", index, changed)
    if changed then
        if CFG.notification.enabled then
            CFG.Log(SIDE, T("notif_shown", notificationText(index)))
        end
        CFG.ShowCircle(index)
    end
end)

Player.Subscribe("VOIP", function(player, is_talking)
    if player ~= Client.GetLocalPlayer() then return end
    state.talking = is_talking and true or false
    CFG.Log(SIDE, state.talking and T("mic_speaking") or T("mic_silent"))
    ui:CallEvent("SetTalking", state.talking)
end)

Input.Subscribe("KeyPress", function(key_name)
    if key_name ~= CFG.key then return end

    -- remember that the key is down so the circle stays while it is held
    CFG.SetCircleHeld(true)

    local now = os.clock()
    if now - lastPress < 0.25 then return end
    lastPress = now
    CFG.Log(SIDE, T("key_pressed", CFG.key))
    Events.CallRemote("VoiceProximity:Cycle")
end)

Input.Subscribe("KeyUp", function(key_name)
    if key_name ~= CFG.key then return end
    CFG.Log(SIDE, T("key_released", CFG.key))
    CFG.SetCircleHeld(false)
end)

CFG.Log(SIDE, T("client_ready", tostring(CFG.key), tostring(CFG.language)))
