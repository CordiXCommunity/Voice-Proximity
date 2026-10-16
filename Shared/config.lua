-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Shared/config.lua : all the package settings are here.
-- Colors: use "#RRGGBB" (ex: "#2ee6c8"). For the HUD you can also use CSS colors
-- like "rgba(10, 12, 14, 0.62)".

VoiceProximity = {
    -- Language of ALL visible texts (console + in game): "fr" or "en"
    language = "fr",

    -- Debug mode: true = detailed console messages (server and client),
    -- config self-test at startup and test commands. false = silent.
    debug = false,

    -- Key used to go to the next mode (whisper > normal > shout > whisper...)
    key = "F5",

    -- Mode on spawn: index in the "modes" list below (2 = normal)
    defaultMode = 2,

    -- Ranges in METERS. Edit freely. "id" is used for the translated name
    -- (see "mode.<id>" in Shared/lang.lua).
    -- "color" is the color of this mode: ground circle, notification dot and,
    -- if hud.followModeColor = true, the HUD itself.
    modes = {
        { id = "whisper", meters = 3,  color = "#73ccff" },
        { id = "normal",  meters = 10, color = "#2ee6c8" },
        { id = "shout",   meters = 25, color = "#ff9933" },
    },

    -- Meters -> Nanos World units multiplier (1 unit = 1 cm).
    -- If the range is 100 times too big or too small, set it to 1.
    unitsPerMeter = 100,

    -- Ground circle shown when you change mode (only you see it)
    circle = {
        enabled = true,
        duration = 2.5,      -- seconds the circle stays visible after a quick tap
        expandTime = 0.35,   -- seconds for the circle to grow from your feet to its full size
        holdToKeep = true,   -- true = the circle stays visible as long as you hold the key
        releaseDelay = 0.4,  -- seconds the circle stays after you release a held key
        maxHold = 10,        -- safety: maximum seconds a held key keeps the circle
        thickness = 3,       -- line thickness
        groundOffset = 90,   -- distance between the character center and the ground (units)
        segments = 64,       -- smoothness of the circle
    },

    -- Small notification shown at every mode change ("Voice: Whisper (3 m)")
    notification = {
        enabled = true,
        duration = 2,        -- seconds
        showRange = true,    -- true = adds the range in meters
    },

    -- HUD appearance
    hud = {
        -- "bottom-right", "bottom-left", "top-right" or "top-left"
        position = "bottom-right",
        marginX = 22,                          -- pixels from the left/right edge
        marginY = 22,                          -- pixels from the top/bottom edge

        background = "rgba(10, 12, 14, 0.62)", -- HUD background
        border = "rgba(255, 255, 255, 0.05)",  -- HUD border
        textColor = "#e8fffb",                 -- notification text

        micIdle = "#1f6f66",                   -- microphone when you are silent
        micTalking = "#2ee6c8",                -- microphone when you talk
        neon = "#2ee6c8",                      -- color of the neon glow when you talk
        neonSize = 7,                          -- glow size in pixels (0 = no glow)
        neonPulse = true,                      -- true = the glow gently pulses while you talk

        barsOn = "#2ee6c8",                    -- active mode bars
        barsOff = "rgba(255, 255, 255, 0.16)", -- inactive bars

        -- true = micTalking, neon, barsOn and the notification dot use the color of the current mode
        followModeColor = false,
    },
}
