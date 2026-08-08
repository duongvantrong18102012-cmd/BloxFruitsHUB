-- ===== MODULES/PICKUP.LUA =====
local PickupModule = {}
local isRunning = false

function PickupModule:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("🍎 Pickup đã khởi động")
    
    local Config = Hub.Config
    local Fruits = Hub.Fruits
    local Movement = Hub.Movement
    local Helpers = Hub.Helpers
    local Remote = Hub.Remote
    local status = Hub.status or {PickupFruit = true, PickupChest = true, AutoMaterial = true}
    local lastFruit = 0
    local lastChest = 0
    local lastMaterial = 0
    
    spawn(function()
        while isRunning do
            local root = Helpers:GetRootPart()
            if not root then wait(1) return end
            
            -- Nhặt Fruit
            if status.PickupFruit and tick() - lastFruit > math.random(3,6) then
                self:PickupFruit(Hub, root)
                lastFruit = tick()
            end
            
            -- Nhặt Chest
            if status.PickupChest and tick() - lastChest > math.random(5,8) then
                self:PickupChest(Hub, root)
                lastChest = tick()
            end
            
            -- Nhặt Material
            if status.AutoMaterial and tick() - lastMaterial > math.random(4,8) then
                self:PickupMaterial(Hub, root)
                lastMaterial = tick()
            end
            
            wait(1)
        end
    end)
end

function PickupModule:PickupFruit(Hub, root)
    local Fruits = Hub.Fruits
    local Movement = Hub.Movement
    local Config = Hub.Config
    local onlyRare = Config.OnlyRareFruit
    
    local nearest, bestDist, bestRank = nil, math.huge, 0
    local rankMap = {Common=1, Uncommon=2, Rare=3, Legendary=4, Mythical=5}
    
    for _, obj in pairs(workspace:GetChildren()) do
        local name = obj.Name:lower()
        local found = false
        for _, kw in ipairs(Fruits.Keywords) do
            if name:find(kw) then
                found = true
                break
            end
        end
        if found then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChild("Part")
            if hrp then
                local dist = (root.Position - hrp.Position).Magnitude
                local rarity = "Common"
                for _, f in ipairs(Fruits.Data) do
                    if name:find(f.Name:lower()) then
                        rarity = f.Rarity
                        break
                    end
                end
                local rank = rankMap[rarity] or 1
                if onlyRare and rank < 3 then continue end
                if rank > bestRank or (rank == bestRank and dist < bestDist) then
                    bestRank = rank
                    bestDist = dist
                    nearest = obj
                end
            end
        end
    end
    
    if nearest then
        local pos = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Handle") or nearest:FindFirstChild("Part")
        if pos and (root.Position - pos.Position).Magnitude <= Config.PickupRadius then
            Movement:MoveTo(pos.Position)
            wait(0.3)
        end
    end
end

function PickupModule:PickupChest(Hub, root)
    local Movement = Hub.Movement
    local Config = Hub.Config
    local nearest, bestDist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("chest") then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChild("Part")
            if hrp then
                local d = (root.Position - hrp.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    nearest = obj
                end
            end
        end
    end
    if nearest then
        local pos = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Handle") or nearest:FindFirstChild("Part")
        if pos and (root.Position - pos.Position).Magnitude <= Config.PickupRadius then
            Movement:MoveTo(pos.Position)
            wait(0.3)
            local vInput = game:GetService("VirtualInputManager")
            vInput:SendKeyEvent(true, "E", false, nil)
            wait(0.2)
            vInput:SendKeyEvent(false, "E", false, nil)
        end
    end
end

function PickupModule:PickupMaterial(Hub, root)
    local Movement = Hub.Movement
    local Config = Hub.Config
    local nearest, bestDist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("material") or obj.Name:lower():find("fragment") or obj.Name:lower():find("bone") then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Part")
            if hrp then
                local d = (root.Position - hrp.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    nearest = obj
                end
            end
        end
    end
    if nearest then
        local pos = nearest:FindFirstChild("HumanoidRootPart") or nearest:FindFirstChild("Part")
        if pos and (root.Position - pos.Position).Magnitude <= Config.PickupRadius then
            Movement:MoveTo(pos.Position)
            wait(0.3)
        end
    end
end

function PickupModule:Stop()
    isRunning = false
    print("⏹️ Pickup đã dừng")
end

return PickupModule
