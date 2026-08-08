-- ===== UTILS/HELPERS.LUA =====
local Helpers = {}

function Helpers:GetPlayer()
    return game.Players.LocalPlayer
end

function Helpers:GetCharacter()
    local player = self:GetPlayer()
    return player.Character or player.CharacterAdded:Wait()
end

function Helpers:GetRootPart()
    local char = self:GetCharacter()
    return char:FindFirstChild("HumanoidRootPart")
end

function Helpers:GetHumanoid()
    local char = self:GetCharacter()
    return char:FindFirstChild("Humanoid")
end

function Helpers:GetNearestMonster()
    local rootPart = self:GetRootPart()
    if not rootPart then return nil end
    local nearest, bestDist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and not obj:FindFirstChild("PlayerGui") then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp and obj.Humanoid.Health > 0 and obj.Humanoid.Health < 9999 then
                local d = (rootPart.Position - hrp.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

return Helpers
