-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Shared/colors.lua : color helpers.

local CFG = VoiceProximity

-- Accepts "#RRGGBB" or { r, g, b } (0 to 1). Returns r, g, b (0 to 1) or nil.
function CFG.ParseColor(value)
    if type(value) == "string" then
        local r, g, b = string.match(value, "^#(%x%x)(%x%x)(%x%x)$")
        if r then
            return tonumber(r, 16) / 255, tonumber(g, 16) / 255, tonumber(b, 16) / 255
        end
        return nil
    end

    if type(value) == "table" and #value == 3 then
        for i = 1, 3 do
            if type(value[i]) ~= "number" or value[i] < 0 or value[i] > 1 then return nil end
        end
        return value[1], value[2], value[3]
    end

    return nil
end

-- Returns a "#rrggbb" string (fallback: turquoise)
function CFG.ToHex(value)
    local r, g, b = CFG.ParseColor(value)
    if not r then return "#2ee6c8" end
    return string.format("#%02x%02x%02x",
        math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5))
end
