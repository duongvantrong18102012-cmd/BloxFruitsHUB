-- ===== MODULES/SEABEAST.LUA =====
local SeaBeastModule = {}
local isRunning = false

function SeaBeastModule:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("🌊 Sea Beast đã khởi động")
    
    spawn(function()
        local Movement = Hub.Movement
        local Remote = Hub.Remote
        local Helpers = Hub.Helpers
        local status = Hub.status or {AutoSeaBeast = false}
        local lastTime = 0
        
        while isRunning do
            if status.AutoSeaBeast and tick() - lastTime > math.random(15,25) then
                local root = Helpers:GetRootPart()
                if not root then wait(1) return end
                
                local nearest, bestDist = nil, math.huge
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name:lower():find("sea") or obj.Name:lower():find("beast") then
                        local hrp = obj:FindFirstChild("HumanoidRootPart")
                        if hrp and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                            local d = (root.Position - hrp.Position).Magnitude
                            if d < bestDist then
                                bestDist = d
                                nearest = obj
                            end
                        end
                    end
                end
                
                if nearest then
                    local hrp = nearest:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        Movement:MoveTo(hrp.Position + Vector3.new(5,5,5))
                        Remote:Fire({Type="Attack", Target=nearest, Weapon=Hub.Config.WeaponName})
                    end
                else
                    local randomPos = root.Position + Vector3.new(math.random(-100,100),0,math.random(-100,100))
                    Movement:MoveTo(randomPos)
                end
                lastTime = tick()
            end
            wait(1)
        end
    end)
end

function SeaBeastModule:Stop()
    isRunning = false
    print("⏹️ Sea Beast đã dừng")
end

return SeaBeastModule
