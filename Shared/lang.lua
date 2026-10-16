-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Shared/lang.lua : translations. To add a language, copy a block,
-- change its code (ex: "es") and translate the values. Keep the keys.

local CFG = VoiceProximity

CFG.Lang = {
    fr = {
        -- in game
        ["mode.whisper"] = "Chuchoter",
        ["mode.normal"]  = "Normal",
        ["mode.shout"]   = "Crier",

        -- config checks
        ["p_lang"]        = "language \"%s\" inconnue, anglais utilisé à la place",
        ["p_key"]         = "key doit être un texte non vide (ex : \"F5\")",
        ["p_modes_empty"] = "modes doit contenir au moins 1 mode",
        ["p_modes_many"]  = "le HUD affiche 3 barres : au-delà de 3 modes, les barres ne suivront pas",
        ["p_default"]     = "defaultMode doit être entre 1 et %s",
        ["p_units"]       = "unitsPerMeter doit être un nombre > 0",
        ["p_meters_num"]  = "modes[%s].meters doit être un nombre > 0",
        ["p_meters_order"]= "modes[%s].meters doit être plus grand que le mode précédent",
        ["p_mode_id"]     = "modes[%s].id doit être un texte non vide",
        ["p_color"]       = "modes[%s].color doit être { r, g, b } avec des valeurs entre 0 et 1",
        ["p_circle"]      = "circle : duration > 0, expandTime >= 0, releaseDelay >= 0, maxHold > 0 et segments >= 8",

        -- server
        ["config_problem"] = "CONFIG : %s",
        ["config_valid"]   = "configuration valide (%s modes, touche %s)",
        ["ready"]          = "prêt (%s modes, debug=%s, langue=%s)",
        ["spawn_player"]   = "%s est apparu",
        ["unknown_mode"]   = "mode inconnu : %s",
        ["mode_applied"]   = "%s -> %s (%s m = %s unités)",
        ["setvoip_fail"]   = "échec de SetVOIP pour %s : %s",
        ["mode_sent"]      = "mode %s envoyé à %s",
        ["key_received"]   = "touche reçue de %s (mode actuel %s)",
        ["state_requested"]= "état demandé par %s",

        -- commands
        ["need_debug"]       = "active debug = true dans Shared/config.lua",
        ["cmd_registered"]   = "commandes de debug enregistrées : voice_debug, voice_test, voice_setmode",
        ["cmd_debug_desc"]   = "Rapport debug de Voice Proximity",
        ["cmd_test_desc"]    = "Simule le changement de mode sans joueur",
        ["cmd_setmode_desc"] = "Force le mode vocal d'un joueur",
        ["report_title"]     = "=== RAPPORT ===",
        ["report_cfg"]       = "touche : %s | mode par défaut : %s | unités/m : %s | langue : %s",
        ["report_mode"]      = "  mode %s : %s (%s m = %s unités)",
        ["report_check_ok"]  = "vérification de la config : OK",
        ["report_check_n"]   = "vérification de la config : %s problème(s)",
        ["report_player"]    = "  joueur %s : %s (%s m)",
        ["report_player_no"] = "  joueur %s : aucun mode",
        ["report_none"]      = "  aucun joueur connecté",
        ["test_title"]       = "=== SIMULATION (aucun joueur requis) ===",
        ["test_press"]       = "  appui %s -> mode %s : %s, %s m, %s unités",
        ["test_loop"]        = "la boucle doit revenir au mode de départ après %s appuis",
        ["setmode_usage"]    = "Usage : voice_setmode <nom du joueur> <1-%s>",
        ["player_not_found"] = "joueur introuvable : %s",

        -- client
        ["loading_hud"]    = "chargement du HUD",
        ["hud_ready"]      = "HUD prêt",
        ["mode_received"]  = "mode reçu du serveur : %s",
        ["mic_speaking"]   = "micro : parle",
        ["mic_silent"]     = "micro : silence",
        ["key_pressed"]    = "touche %s appuyée, demande envoyée au serveur",
        ["key_released"]   = "touche %s relâchée",
        ["client_ready"]   = "client prêt, touche = %s, langue = %s",
        ["circle_show"]    = "cercle affiché : mode %s, rayon %s m",
        ["circle_hold"]    = "touche maintenue : le cercle reste affiché",
        ["circle_release"] = "touche relâchée : le cercle disparaît dans %s s",
        ["circle_hold_max"]= "durée maximale de maintien atteinte, cercle retiré",
        ["circle_fail"]    = "dessin du cercle impossible (Debug.DrawLine) : %s",
        ["circle_no_char"] = "pas de personnage contrôlé, cercle ignoré",
    },

    en = {
        -- in game
        ["mode.whisper"] = "Whisper",
        ["mode.normal"]  = "Normal",
        ["mode.shout"]   = "Shout",

        -- config checks
        ["p_lang"]        = "unknown language \"%s\", English used instead",
        ["p_key"]         = "key must be a non-empty text (e.g. \"F5\")",
        ["p_modes_empty"] = "modes must contain at least 1 mode",
        ["p_modes_many"]  = "the HUD shows 3 bars: with more than 3 modes the bars will not follow",
        ["p_default"]     = "defaultMode must be between 1 and %s",
        ["p_units"]       = "unitsPerMeter must be a number > 0",
        ["p_meters_num"]  = "modes[%s].meters must be a number > 0",
        ["p_meters_order"]= "modes[%s].meters must be greater than the previous mode",
        ["p_mode_id"]     = "modes[%s].id must be a non-empty text",
        ["p_color"]       = "modes[%s].color must be { r, g, b } with values between 0 and 1",
        ["p_circle"]      = "circle: duration > 0, expandTime >= 0, releaseDelay >= 0, maxHold > 0 and segments >= 8",

        -- server
        ["config_problem"] = "CONFIG: %s",
        ["config_valid"]   = "valid configuration (%s modes, key %s)",
        ["ready"]          = "ready (%s modes, debug=%s, language=%s)",
        ["spawn_player"]   = "%s spawned",
        ["unknown_mode"]   = "unknown mode: %s",
        ["mode_applied"]   = "%s -> %s (%s m = %s units)",
        ["setvoip_fail"]   = "SetVOIP failed for %s: %s",
        ["mode_sent"]      = "mode %s sent to %s",
        ["key_received"]   = "key received from %s (current mode %s)",
        ["state_requested"]= "state requested by %s",

        -- commands
        ["need_debug"]       = "set debug = true in Shared/config.lua",
        ["cmd_registered"]   = "debug commands registered: voice_debug, voice_test, voice_setmode",
        ["cmd_debug_desc"]   = "Voice Proximity debug report",
        ["cmd_test_desc"]    = "Simulates mode switching without a player",
        ["cmd_setmode_desc"] = "Forces a player's voice mode",
        ["report_title"]     = "=== REPORT ===",
        ["report_cfg"]       = "key: %s | default mode: %s | units/m: %s | language: %s",
        ["report_mode"]      = "  mode %s: %s (%s m = %s units)",
        ["report_check_ok"]  = "config check: OK",
        ["report_check_n"]   = "config check: %s problem(s)",
        ["report_player"]    = "  player %s: %s (%s m)",
        ["report_player_no"] = "  player %s: no mode",
        ["report_none"]      = "  no player connected",
        ["test_title"]       = "=== SIMULATION (no player required) ===",
        ["test_press"]       = "  press %s -> mode %s: %s, %s m, %s units",
        ["test_loop"]        = "the loop must return to the starting mode after %s presses",
        ["setmode_usage"]    = "Usage: voice_setmode <player name> <1-%s>",
        ["player_not_found"] = "player not found: %s",

        -- client
        ["loading_hud"]    = "loading HUD",
        ["hud_ready"]      = "HUD ready",
        ["mode_received"]  = "mode received from server: %s",
        ["mic_speaking"]   = "microphone: speaking",
        ["mic_silent"]     = "microphone: silent",
        ["key_pressed"]    = "key %s pressed, request sent to server",
        ["key_released"]   = "key %s released",
        ["client_ready"]   = "client ready, key = %s, language = %s",
        ["circle_show"]    = "circle shown: mode %s, radius %s m",
        ["circle_hold"]    = "key held: the circle stays visible",
        ["circle_release"] = "key released: the circle disappears in %s s",
        ["circle_hold_max"]= "maximum hold time reached, circle removed",
        ["circle_fail"]    = "could not draw the circle (Debug.DrawLine): %s",
        ["circle_no_char"] = "no controlled character, circle skipped",
    },
}

-- CFG.T("key", ...) : translated text (falls back to English, then to the key)
function CFG.T(key, ...)
    local pack = CFG.Lang[CFG.language] or CFG.Lang.en
    local text = pack[key] or CFG.Lang.en[key] or key
    if select("#", ...) > 0 then
        local ok, result = pcall(string.format, text, ...)
        if ok then return result end
    end
    return text
end

-- Translated name of a mode (uses "mode.<id>", falls back to the id)
function CFG.ModeName(mode)
    local key = "mode." .. tostring(mode.id)
    local name = CFG.T(key)
    if name == key then return tostring(mode.id) end
    return name
end
