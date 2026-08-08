-- ===== MODULES/FARM.LUA =====
local FarmModule = {}
local isRunning = false

function FarmModule:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("🚀 Farm đã khởi động")
    
    spawn(function()
        local Config = Hub.Config
        local Helpers = Hub.Helpers
        local Movement = Hub.Movement
        local Remote = Hub.Remote
        local status = Hub.status or {Farm = true} -- sẽ được gán từ GUI

        while isRunning and status.Farm do
            local monster = Helpers:GetNearestMonster()
            if monster then
                local hrp = monster:FindFirstChild("HumanoidRootPart")
                if hrp then
                    Movement:MoveTo(hrp.Position + Vector3.new(3,0,3))
                    Remote:Fire({Type="Attack", Target=monster, Weapon=Config.WeaponName})
                    -- Dự phòng tấn công bằng tool
                    local player = Helpers:GetPlayer()
                    local char = Helpers:GetCharacter()
                    local tool = player.Backpack:FindFirstChild(Config.WeaponName) or char:FindFirstChild(Config.WeaponName)
                    if tool then
                        local humanoid = Helpers:GetHumanoid()
                        humanoid:EquipTool(tool)
                        wait(0.1)
                        tool:Activate()
                    end
                    wait(math.random(10,30)/100)
                end
            else
                local root = Helpers:GetRootPart()
                if root then
                    local randomPos = root.Position + Vector3.new(math.random(-50,50),0,math.random(-50,50))
                    Movement:MoveTo(randomPos)
                    wait(math.random(50,100)/100)
                end
            end
            wait(Config.FarmInterval)
        end
    end)
end

function FarmModule:Stop()
    isRunning = false
    print("⏹️ Farm đã dừng")
end

return FarmModule
