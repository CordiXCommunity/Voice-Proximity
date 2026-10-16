-- Voice Proximity | Creator: Max Cordiau - Cordix
-- Client/circle.lua : ground circle showing the range of the selected voice mode.
-- Drawn with the Debug static class (Debug.DrawLine), only visible by the local player.
-- Quick tap  : the circle stays for circle.duration seconds.
-- Key held   : the circle stays as long as the key is held (+ circle.releaseDelay).

local CFG = VoiceProximity
local T = CFG.T
local SIDE = "CLIENT"

local active = nil      -- { radius, color, started, deadline }
local held = false
local heldSince = 0
local failed = false

local function groundCenter()
    local player = Client.GetLocalPlayer()
    if not player then return nil end
    local character = player:GetControlledCharacter()
    if not character or not character:IsValid() then return nil end
    local location = character:GetLocation()
    return Vector(location.X, location.Y, location.Z - CFG.circle.groundOffset)
end

local function drawCircle(center, radius, color)
    local segments = CFG.circle.segments
    local step = (2 * math.pi) / segments
    local previous = Vector(center.X + radius, center.Y, center.Z)
    for i = 1, segments do
        local angle = i * step
        local nextPoint = Vector(
            center.X + math.cos(angle) * radius,
            center.Y + math.sin(angle) * radius,
            center.Z)
        Debug.DrawLine(previous, nextPoint, color, 0.06, CFG.circle.thickness)
        previous = nextPoint
    end
end

-- Called when the mode key goes down (true) or up (false)
function CFG.SetCircleHeld(isHeld)
    if not CFG.circle.enabled or not CFG.circle.holdToKeep then return end
    if isHeld == held then return end
    held = isHeld

    if isHeld then
        heldSince = os.clock()
        CFG.Log(SIDE, T("circle_hold"))
    elseif active then
        -- a hold only extends the visible time, never shortens it
        local now = os.clock()
        active.deadline = math.max(active.deadline, now + CFG.circle.releaseDelay)
        CFG.Log(SIDE, T("circle_release", CFG.circle.releaseDelay))
    end
end

-- Starts the circle animation for the given mode index
function CFG.ShowCircle(index)
    if not CFG.circle.enabled or failed then return end
    local mode = CFG.modes[index]
    if not mode then return end

    if not groundCenter() then
        CFG.Log(SIDE, T("circle_no_char"))
        return
    end

    local r, g, b = CFG.ParseColor(mode.color)
    if not r then r, g, b = 0.18, 0.90, 0.78 end

    local now = os.clock()
    active = {
        radius = mode.meters * CFG.unitsPerMeter,
        color = Color(r, g, b),
        started = now,
        deadline = now + CFG.circle.duration,
    }
    CFG.Log(SIDE, T("circle_show", mode.id, mode.meters))
end

Client.Subscribe("Tick", function()
    if not active then return end

    local now = os.clock()

    -- while the key is held the circle never expires (bounded by maxHold)
    if held then
        if now - heldSince > CFG.circle.maxHold then
            held = false
            active = nil
            CFG.Log(SIDE, T("circle_hold_max"))
            return
        end
    elseif now > active.deadline then
        active = nil
        return
    end

    local center = groundCenter()
    if not center then return end

    -- ease-out growth from the player's feet to the full radius
    local t = 1
    if CFG.circle.expandTime > 0 then
        t = math.min(1, (now - active.started) / CFG.circle.expandTime)
    end
    local eased = 1 - (1 - t) ^ 3

    local ok, err = pcall(drawCircle, center, active.radius * eased, active.color)
    if not ok then
        failed = true
        active = nil
        CFG.Warn(SIDE, T("circle_fail", tostring(err)))
    end
end)
