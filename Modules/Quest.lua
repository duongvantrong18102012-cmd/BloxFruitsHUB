-- ===== MODULES/QUEST.LUA =====
local QuestModule = {}
local isRunning = false

function QuestModule:Start(Hub)
    if isRunning then return end
    isRunning = true
    print("📜 Quest đã khởi động")
    
    spawn(function()
        local Config = Hub.Config
        local NPCs = Hub.NPCs
        local Movement = Hub.Movement
        local Remote = Hub.Remote
        local Helpers = Hub.Helpers
        local status = Hub.status or {Quest = true}
        local lastTime = 0

        while isRunning and status.Quest do
            if tick() - lastTime > math.random(8,15) then
                local player = Helpers:GetPlayer()
                local root = Helpers:GetRootPart()
                if not root then wait(1) return end
                
                -- Tìm NPC quest gần nhất trong danh sách
                local nearest, bestDist = nil, math.huge
                for name, data in pairs(NPCs) do
                    if data.Type == "Quest" and data.Pos then
                        local d = (root.Position - data.Pos).Magnitude
                        if d < bestDist then
                            bestDist = d
                            nearest = {Name=name, Data=data}
                        end
                    end
                end
                
                if nearest then
                    local pos = nearest.Data.Pos
                    if (root.Position - pos).Magnitude > Config.QuestRadius then
                        Movement:MoveTo(pos + Vector3.new(2,0,2))
                        wait(0.5)
                    end
                    Remote:Fire({Type="Quest", NPC=nearest.Name, Action="Interact"})
                    -- Dự phòng phím E
                    local vInput = game:GetService("VirtualInputManager")
                    vInput:SendKeyEvent(true, "E", false, nil)
                    wait(0.2)
                    vInput:SendKeyEvent(false, "E", false, nil)
                end
                lastTime = tick()
            end
            wait(1)
        end
    end)
end

function QuestModule:Stop()
    isRunning = false
    print("⏹️ Quest đã dừng")
end

return QuestModule
