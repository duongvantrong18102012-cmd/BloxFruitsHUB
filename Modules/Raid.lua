-- ===== MODULES/RAID.LUA =====
local RaidModule = {}
local isRunning = false

function RaidModule:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("⚔️ Raid đã khởi động")
    
    spawn(function()
        local Movement = Hub.Movement
        local Remote = Hub.Remote
        local Helpers = Hub.Helpers
        local status = Hub.status or {AutoRaid = false}
        local lastTime = 0
        
        while isRunning do
            if status.AutoRaid and tick() - lastTime > math.random(20,30) then
                local root = Helpers:GetRootPart()
                if not root then wait(1) return end
                
                local nearest, bestDist = nil, math.huge
                for _, plr in pairs(game.Players:GetPlayers()) do
                    if plr ~= Helpers:GetPlayer() then
                        local char = plr.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local d = (root.Position - char.HumanoidRootPart.Position).Magnitude
                            if d < bestDist then
                                bestDist = d
                                nearest = char
                            end
                        end
                    end
                end
                
                if nearest then
                    local hrp = nearest:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        Movement:MoveTo(hrp.Position + Vector3.new(2,0,2))
                        Remote:Fire({Type="Raid", Action="Join"})
                    end
                end
                lastTime = tick()
            end
            wait(1)
        end
    end)
end

function RaidModule:Stop()
    isRunning = false
    print("⏹️ Raid đã dừng")
end

return RaidModule
