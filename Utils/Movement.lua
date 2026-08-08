-- ===== UTILS/MOVEMENT.LUA =====
local Movement = {}

function Movement:MoveTo(pos)
    local player = game.Players.LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    rootPart.CFrame = CFrame.new(pos)
    wait(0.2)
end

function Movement:TeleportToIsland(Hub, islandName)
    local pos = Hub.Islands[islandName]
    if pos then
        self:MoveTo(pos)
        print("📍 Đã teleport đến: " .. islandName)
    else
        print("❌ Không tìm thấy đảo: " .. islandName)
    end
end

return Movement
