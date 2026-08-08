-- ===== MODULES/STATS.LUA =====
local StatsModule = {}
local isRunning = false

function StatsModule:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("📊 Stats đã khởi động")
    
    spawn(function()
        local Config = Hub.Config
        local Helpers = Hub.Helpers
        local status = Hub.status or {AutoStats = false}
        local lastTime = 0
        
        while isRunning do
            if status.AutoStats and tick() - lastTime > math.random(30,60) then
                local player = Helpers:GetPlayer()
                local statsGui = player.PlayerGui:FindFirstChild("StatsGui")
                if statsGui then
                    for _, stat in ipairs(Config.StatPoints) do
                        local btn = statsGui:FindFirstChild(stat) or statsGui:FindFirstChild("Add"..stat)
                        if btn and btn:IsA("TextButton") then
                            btn:Click()
                            wait(0.1)
                        end
                    end
                end
                lastTime = tick()
            end
            wait(1)
        end
    end)
end

function StatsModule:Stop()
    isRunning = false
    print("⏹️ Stats đã dừng")
end

return StatsModule
