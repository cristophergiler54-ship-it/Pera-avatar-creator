-- 🍐 PERA AVATAR COMMANDS
-- Coloca este Script dentro de ServerScriptService.

local Players = game:GetService("Players")

local HEADLESS_ID = 134082579
local KORBLOX_LEG_ID = 139607718

-- Guarda la apariencia original una sola vez, antes del primer cambio.
local originalDescriptions = {}

local function applyItem(player, itemId, property)
    local character = player.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end

    local success, description = pcall(function()
        return humanoid:GetAppliedDescription()
    end)
    if not success or not description then
        warn("No se pudo obtener la apariencia de " .. player.Name)
        return
    end

    if not originalDescriptions[player] then
        originalDescriptions[player] = description:Clone()
    end

    if property == "Head" then
        description.Head = itemId
    elseif property == "RightLeg" then
        description.RightLeg = itemId
    else
        description:Destroy()
        return
    end

    local applied, err = pcall(function()
        humanoid:ApplyDescription(description)
    end)
    description:Destroy()

    if not applied then
        warn("No se pudo aplicar la apariencia a " .. player.Name .. ": " .. tostring(err))
    end
end

local function resetAppearance(player)
    local original = originalDescriptions[player]
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not original or not humanoid then
        return
    end

    local description = original:Clone()
    local applied, err = pcall(function()
        humanoid:ApplyDescription(description)
    end)
    description:Destroy()

    if applied then
        original:Destroy()
        originalDescriptions[player] = nil
    else
        warn("No se pudo restaurar la apariencia de " .. player.Name .. ": " .. tostring(err))
    end
end

local function setupPlayer(player)
    player.Chatted:Connect(function(message)
        local command = string.lower(message):match("^%s*(.-)%s*$")

        if command == "/headless" then
            applyItem(player, HEADLESS_ID, "Head")
        elseif command == "/korblox" then
            applyItem(player, KORBLOX_LEG_ID, "RightLeg")
        elseif command == "/reset" then
            resetAppearance(player)
        end
    end)
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerRemoving:Connect(function(player)
    local original = originalDescriptions[player]
    if original then
        original:Destroy()
        originalDescriptions[player] = nil
    end
end)
