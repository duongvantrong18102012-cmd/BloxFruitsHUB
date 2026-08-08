-- ===== MODULES/ANTIBAN.LUA =====
local AntiBan = {}
local isRunning = false

function AntiBan:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("🛡️ Anti-Ban đã khởi động")
    
    spawn(function()
        local Config = Hub.Config
        local Helpers = Hub.Helpers
        while isRunning do
            -- Hành vi giả người
            if math.random(1,10) > 7 then
                local camera = workspace.CurrentCamera
                camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(math.random(-30,30)), 0)
            end
            if math.random(1,15) > 13 then
                local humanoid = Helpers:GetHumanoid()
                if humanoid then humanoid:Jump() end
            end
            
            -- Kiểm tra đông người
            if Config.SafeMode then
                local count = 0
                local root = Helpers:GetRootPart()
                if root then
                    for _, plr in pairs(game.Players:GetPlayers()) do
                        if plr ~= Helpers:GetPlayer() then
                            local char = plr.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local d = (root.Position - char.HumanoidRootPart.Position).Magnitude
                                if d < 40 then count = count + 1 end
                            end
                        end
                    end
                    if count > 3 then wait(1.5) end
                end
            end
            
            wait(2)
        end
    end)
end

function AntiBan:Stop()
    isRunning = false
    print("⏹️ Anti-Ban đã dừng")
end

return AntiBan
