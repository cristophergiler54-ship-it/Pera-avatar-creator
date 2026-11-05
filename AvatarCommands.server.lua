-- =====================================
-- 🍐 PERA AVATAR COMMANDS
-- Place this Script in ServerScriptService.
-- =====================================

local Players = game:GetService("Players")

local function applyHeadless(character)
    local head = character:FindFirstChild("Head")
    if not head then
        return
    end

    head.Transparency = 1

    for _, child in ipairs(head:GetChildren()) do
        if child:IsA("Decal") then
            child.Transparency = 1
        end
    end
end

local function applyKorblox(character)
    -- Cosmetic effect: hide the lower right leg and foot.
    for _, partName in ipairs({ "RightLowerLeg", "RightFoot" }) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
end

local function setupPlayer(player)
    player.Chatted:Connect(function(message)
        local character = player.Character
        if not character then
            return
        end

        local command = string.lower(message)

        -- Accept both spellings so /headlles works as requested.
        if command == "/headlles" or command == "/headless" then
            applyHeadless(character)
        elseif command == "/korblox" then
            applyKorblox(character)
        elseif command == "/reset" then
            player:LoadCharacter()
        end
    end)
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end
