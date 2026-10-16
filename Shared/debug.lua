-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Shared/debug.lua : logging and config validation.
-- Note: Nanos World already prefixes every message with the package name.

local CFG = VoiceProximity

-- Log shown only when debug = true. "side" is "SERVER" or "CLIENT".
function CFG.Log(side, message)
    if CFG.debug then
        Console.Log("[DEBUG][" .. side .. "] " .. tostring(message))
    end
end

-- Warning always shown (real problem).
function CFG.Warn(side, message)
    Console.Warn("[" .. side .. "] " .. tostring(message))
end

local function validColor(color)
    if type(color) ~= "table" or #color ~= 3 then return false end
    for i = 1, 3 do
        if type(color[i]) ~= "number" or color[i] < 0 or color[i] > 1 then return false end
    end
    return true
end

-- Checks the config. Returns the list of problems (empty = all good).
function CFG.Validate()
    local problems = {}
    local T = CFG.T

    if not CFG.Lang[CFG.language] then
        table.insert(problems, T("p_lang", tostring(CFG.language)))
    end
    if type(CFG.key) ~= "string" or CFG.key == "" then
        table.insert(problems, T("p_key"))
    end
    if type(CFG.modes) ~= "table" or #CFG.modes < 1 then
        table.insert(problems, T("p_modes_empty"))
        return problems
    end
    if #CFG.modes > 3 then
        table.insert(problems, T("p_modes_many"))
    end
    if type(CFG.defaultMode) ~= "number" or CFG.defaultMode < 1 or CFG.defaultMode > #CFG.modes then
        table.insert(problems, T("p_default", #CFG.modes))
    end
    if type(CFG.unitsPerMeter) ~= "number" or CFG.unitsPerMeter <= 0 then
        table.insert(problems, T("p_units"))
    end

    local c = CFG.circle
    if type(c) ~= "table" or type(c.duration) ~= "number" or c.duration <= 0
        or type(c.expandTime) ~= "number" or c.expandTime < 0
        or type(c.releaseDelay) ~= "number" or c.releaseDelay < 0
        or type(c.maxHold) ~= "number" or c.maxHold <= 0
        or type(c.segments) ~= "number" or c.segments < 8 then
        table.insert(problems, T("p_circle"))
    end

    local previous = 0
    for i, mode in ipairs(CFG.modes) do
        if type(mode.id) ~= "string" or mode.id == "" then
            table.insert(problems, T("p_mode_id", i))
        end
        if mode.color ~= nil and not validColor(mode.color) then
            table.insert(problems, T("p_color", i))
        end
        if type(mode.meters) ~= "number" or mode.meters <= 0 then
            table.insert(problems, T("p_meters_num", i))
        elseif mode.meters <= previous then
            table.insert(problems, T("p_meters_order", i))
        else
            previous = mode.meters
        end
    end

    return problems
end
