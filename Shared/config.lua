-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Shared/config.lua : all the package settings are here.

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
    -- (see "mode.<id>" in Shared/lang.lua). "color" = {r, g, b} between 0 and 1,
    -- used for the ground circle.
    modes = {
        { id = "whisper", meters = 3,  color = { 0.45, 0.80, 1.00 } },
        { id = "normal",  meters = 10, color = { 0.18, 0.90, 0.78 } },
        { id = "shout",   meters = 25, color = { 1.00, 0.60, 0.20 } },
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

    -- HUD appearance (pixels / CSS colors)
    hud = {
        right = 22,
        bottom = 22,
        accent = "#2ee6c8",
        idle = "#1f6f66",
        -- true = shows the mode name for ~1.5 s when you switch (no permanent text)
        showLabel = true,
    },
}
