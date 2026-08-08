-- ===== MODULES/MASTERY.LUA =====
local MasteryModule = {}
local isRunning = false

function MasteryModule:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("🎯 Mastery đã khởi động")
    
    spawn(function()
        local Config = Hub.Config
        local Helpers = Hub.Helpers
        local status = Hub.status or {AutoMastery = false}
        local lastTime = 0
        
        while isRunning do
            if status.AutoMastery and tick() - lastTime > math.random(10,20) then
                local char = Helpers:GetCharacter()
                local player = Helpers:GetPlayer()
                local humanoid = Helpers:GetHumanoid()
                local tool = char:FindFirstChild(Config.WeaponName) or player.Backpack:FindFirstChild(Config.WeaponName)
                if tool then
                    humanoid:EquipTool(tool)
                    wait(0.2)
                    for i=1,5 do
                        tool:Activate()
                        wait(0.5)
                    end
                end
                lastTime = tick()
            end
            wait(1)
        end
    end)
end

function MasteryModule:Stop()
    isRunning = false
    print("⏹️ Mastery đã dừng")
end

return MasteryModule
