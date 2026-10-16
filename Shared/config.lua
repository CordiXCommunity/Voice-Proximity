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
    -- (see "mode.<id>" in Shared/lang.lua).
    modes = {
        { id = "whisper", meters = 3 },
        { id = "normal",  meters = 10 },
        { id = "shout",   meters = 25 },
    },

    -- Meters -> Nanos World units multiplier (1 unit = 1 cm).
    -- If the range is 100 times too big or too small, set it to 1.
    unitsPerMeter = 100,

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
