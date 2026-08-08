--[[
    AUTO FARM PRO v3.1 – BẢN ĐẦY ĐỦ TÍCH HỢP TẤT CẢ TÍNH NĂNG
    Tác giả: DeepSeek (hỗ trợ)
    Lưu ý: Script chỉ mang tính chất học tập, rủi ro bị khóa tài khoản rất cao.
--]]

-- ===== KHỞI TẠO =====
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local replicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = replicatedStorage:FindFirstChild("RemoteEvent") or replicatedStorage:FindFirstChild("RE")

-- ===== CẤU HÌNH =====
local CONFIG = {
    AttackDistance = 28,
    QuestRadius = 60,
    PickupRadius = 35,
    FarmInterval = 0.3,
    WeaponName = "Blade",               -- Tên vũ khí bạn đang dùng
    SafeMode = true,                    -- Bật để giảm tốc độ khi có đông người
    StatPoints = {"Melee", "Defense", "Sword", "Gun", "Fruit"},
    OnlyRareFruit = false,              -- true: chỉ nhặt trái Rare trở lên
}

-- ===== BIẾN TRẠNG THÁI =====
local status = {
    Farm = true,
    Quest = true,
    PickupFruit = true,
    PickupChest = true,
    AutoHeal = true,
    AutoSeaBeast = false,
    AutoRaid = false,
    AutoStats = false,
    AutoMastery = false,
    AutoMaterial = false,
}

-- ===== DANH SÁCH ĐẢO (SEA 1-3) =====
local islands = {
    -- Sea 1
    ["Starter Island (Pirate)"] = Vector3.new(-50, 10, 0),
    ["Starter Island (Marine)"] = Vector3.new(50, 10, 0),
    ["Jungle"] = Vector3.new(-1200, 50, 2500),
    ["Pirate Village"] = Vector3.new(-500, 30, 3500),
    ["Desert"] = Vector3.new(200, 40, 4000),
    ["Middle Town"] = Vector3.new(600, 50, 4200),
    ["Frozen Village"] = Vector3.new(900, 60, 4500),
    ["Marine Fortress"] = Vector3.new(1500, 70, 4800),
    ["Skylands"] = Vector3.new(2500, 200, 5000),
    ["Prison"] = Vector3.new(3000, 80, 5200),
    ["Colosseum"] = Vector3.new(3500, 50, 5500),
    ["Magma Village"] = Vector3.new(4000, 40, 5800),
    ["Underwater City"] = Vector3.new(4500, -100, 6000),
    ["Upper Skylands"] = Vector3.new(5000, 300, 6200),
    ["Fountain City"] = Vector3.new(5500, 50, 6500),
    -- Sea 2
    ["Kingdom of Rose"] = Vector3.new(-2000, 80, 7000),
    ["Remote Island"] = Vector3.new(-1800, 60, 7200),
    ["Green Zone"] = Vector3.new(-1500, 50, 7500),
    ["Graveyard"] = Vector3.new(-1200, 60, 7800),
    ["Snow Mountain"] = Vector3.new(-900, 80, 8000),
    ["Cursed Ship"] = Vector3.new(-600, 30, 8200),
    ["Hot and Cold"] = Vector3.new(-300, 50, 8500),
    ["Ice Castle"] = Vector3.new(0, 100, 8800),
    ["Forgotten Island"] = Vector3.new(300, 50, 9000),
    -- Sea 3
    ["Port Town"] = Vector3.new(-3000, 20, 9500),
    ["Hydra Island"] = Vector3.new(-2700, 30, 9800),
    ["Great Tree"] = Vector3.new(-2400, 80, 10000),
    ["Floating Turtle"] = Vector3.new(-2000, 120, 10300),
    ["Castle on the Sea"] = Vector3.new(-1600, 50, 10600),
    ["Haunted Castle"] = Vector3.new(-1200, 60, 10900),
    ["Ice Cream Land"] = Vector3.new(-800, 40, 11200),
    ["Chocolate Land"] = Vector3.new(-400, 50, 11500),
    ["Candy Land"] = Vector3.new(0, 60, 11800),
    ["Tiki Outpost"] = Vector3.new(400, 30, 12100),
    ["Submerged Island"] = Vector3.new(300, -50, 12300),
}

-- ===== DANH SÁCH NPC (SEA 1-3) =====
local npcData = {
    -- Quest NPC
    ["Bandit Quest Giver"] = {Sea=1, Type="Quest", Island="Starter Island (Pirate)", Pos=Vector3.new(-50,10,0)},
    ["Marine Quest Giver"] = {Sea=1, Type="Quest", Island="Starter Island (Marine)", Pos=Vector3.new(50,10,0)},
    ["Adventurer"] = {Sea=1, Type="Quest", Island="Jungle", Pos=Vector3.new(-1200,50,2500)},
    ["Desert Adventurer"] = {Sea=1, Type="Quest", Island="Desert", Pos=Vector3.new(200,40,4000)},
    ["Marine Leader"] = {Sea=1, Type="Quest", Island="Marine Fortress", Pos=Vector3.new(1500,70,4800)},
    ["Sky Adventurer"] = {Sea=1, Type="Quest", Island="Skylands", Pos=Vector3.new(2500,200,5000)},
    ["Head Jailer"] = {Sea=1, Type="Quest", Island="Prison", Pos=Vector3.new(3000,80,5200)},
    ["Jail Keeper"] = {Sea=1, Type="Quest", Island="Prison", Pos=Vector3.new(3000,80,5200)},
    ["Submerged Quest Giver 1"] = {Sea=1, Type="Quest", Island="Underwater City", Pos=Vector3.new(4500,-100,6000)},
    ["Submerged Quest Giver 2"] = {Sea=1, Type="Quest", Island="Underwater City", Pos=Vector3.new(4500,-100,6000)},
    ["Sky Quest Giver 2"] = {Sea=1, Type="Quest", Island="Upper Skylands", Pos=Vector3.new(5000,300,6200)},
    ["Area 1 Quest Giver"] = {Sea=2, Type="Quest", Island="Kingdom of Rose", Pos=Vector3.new(-2000,80,7000)},
    ["Marine Quest Giver (Sea 2)"] = {Sea=2, Type="Quest", Island="Green Zone", Pos=Vector3.new(-1500,50,7500)},
    ["Pirate Port Quest Giver"] = {Sea=3, Type="Quest", Island="Port Town", Pos=Vector3.new(-3000,20,9500)},
    ["Hydra Town Quest Giver"] = {Sea=3, Type="Quest", Island="Hydra Island", Pos=Vector3.new(-2700,30,9800)},
    ["Submerged Quest Giver 1 (Sea 3)"] = {Sea=3, Type="Quest", Island="Submerged Island", Pos=Vector3.new(300,-50,12300)},
    ["Submerged Quest Giver 2 (Sea 3)"] = {Sea=3, Type="Quest", Island="Submerged Island", Pos=Vector3.new(300,-50,12300)},
    ["Submerged Quest Giver 3"] = {Sea=3, Type="Quest", Island="Submerged Island", Pos=Vector3.new(300,-50,12300)},
    -- Shop NPC
    ["Blox Fruit Dealer"] = {Sea=1, Type="Shop", Island="Starter Island (Pirate)", Pos=Vector3.new(-50,10,0)},
    ["Sword Dealer"] = {Sea=1, Type="Shop", Island="Starter Island (Pirate)", Pos=Vector3.new(-50,10,0)},
    ["Boat Dealer"] = {Sea=1, Type="Shop", Island="Starter Island (Pirate)", Pos=Vector3.new(-50,10,0)},
    ["Blox Fruit Dealer Cousin"] = {Sea=1, Type="Shop", Island="Jungle", Pos=Vector3.new(-1200,50,2500)},
    ["Sword Dealer of the West"] = {Sea=1, Type="Shop", Island="Pirate Village", Pos=Vector3.new(-500,30,3500)},
    ["Hasan"] = {Sea=1, Type="Shop", Island="Desert", Pos=Vector3.new(200,40,4000)},
    ["Weapon Dealer"] = {Sea=1, Type="Shop", Island="Middle Town", Pos=Vector3.new(600,50,4200)},
    ["Sword Dealer of the East"] = {Sea=1, Type="Shop", Island="Frozen Village", Pos=Vector3.new(900,60,4500)},
    ["Advanced Weapon Dealer"] = {Sea=1, Type="Shop", Island="Marine Fortress", Pos=Vector3.new(1500,70,4800)},
    ["Master Sword Dealer"] = {Sea=1, Type="Shop", Island="Skylands", Pos=Vector3.new(2500,200,5000)},
    ["Mad Scientist"] = {Sea=1, Type="Shop", Island="Skylands", Pos=Vector3.new(2500,200,5000)},
    ["Living Skeleton"] = {Sea=1, Type="Shop", Island="Magma Village", Pos=Vector3.new(4000,40,5800)},
    ["Legendary Sword Dealer"] = {Sea=2, Type="Shop", Island="Kingdom of Rose", Pos=Vector3.new(-2000,80,7000)},
    ["Blox Fruit Dealer (Sea 3)"] = {Sea=3, Type="Shop", Island="Port Town", Pos=Vector3.new(-3000,20,9500)},
    -- Hidden NPC
    ["Yoshi"] = {Sea=1, Type="Hidden", Island="Skylands", Pos=Vector3.new(2500,200,5000), Note="Bán Tomoe Ring"},
    ["Alchemist"] = {Sea=2, Type="Hidden", Island="Green Zone", Pos=Vector3.new(-1500,50,7500), Note="Dưới nấm xanh"},
    ["Shafi"] = {Sea=3, Type="Hidden", Island="Tiki Outpost", Pos=Vector3.new(400,30,12100), Note="Dưới hầm cung điện"},
    ["Sharkman Karate V2 NPC"] = {Sea=3, Type="Hidden", Island="Submerged Island", Pos=Vector3.new(300,-50,12300), Note="Cần đạt yêu cầu"},
    -- Skill Teacher
    ["Ability Teacher"] = {Sea=1, Type="Skill", Island="Frozen Village", Pos=Vector3.new(900,60,4500)},
    ["Water Kung Fu Teacher"] = {Sea=1, Type="Skill", Island="Underwater City", Pos=Vector3.new(4500,-100,6000)},
    ["Instinct Teacher"] = {Sea=1, Type="Skill", Island="Upper Skylands", Pos=Vector3.new(5000,300,6200)},
    ["Dark Step Teacher (Sea 1)"] = {Sea=1, Type="Skill", Island="Pirate Village", Pos=Vector3.new(-500,30,3500)},
    ["Dark Step Teacher (Sea 3)"] = {Sea=3, Type="Skill", Island="Castle on the Sea", Pos=Vector3.new(-1600,50,10600)},
    ["Sharkman Teacher"] = {Sea=3, Type="Skill", Island="Castle on the Sea", Pos=Vector3.new(-1600,50,10600)},
    ["Dragon Talon Sage"] = {Sea=3, Type="Skill", Island="Tiki Outpost", Pos=Vector3.new(400,30,12100)},
}

-- ===== DANH SÁCH TRÁI ÁC QUỶ ĐẦY ĐỦ =====
local fruitData = {
    -- Common
    {Name="Rocket", Rarity="Common", Type="Natural"},
    {Name="Spin", Rarity="Common", Type="Natural"},
    {Name="Chop", Rarity="Common", Type="Natural"},
    {Name="Spring", Rarity="Common", Type="Natural"},
    {Name="Bomb", Rarity="Common", Type="Natural"},
    {Name="Smoke", Rarity="Common", Type="Elemental"},
    {Name="Spike", Rarity="Common", Type="Natural"},
    -- Uncommon
    {Name="Flame", Rarity="Uncommon", Type="Elemental"},
    {Name="Falcon", Rarity="Uncommon", Type="Beast"},
    {Name="Ice", Rarity="Uncommon", Type="Elemental"},
    {Name="Sand", Rarity="Uncommon", Type="Elemental"},
    {Name="Dark", Rarity="Uncommon", Type="Elemental"},
    {Name="Diamond", Rarity="Uncommon", Type="Natural"},
    -- Rare
    {Name="Light", Rarity="Rare", Type="Elemental"},
    {Name="Rubber", Rarity="Rare", Type="Natural"},
    {Name="Barrier", Rarity="Rare", Type="Natural"},
    {Name="Ghost", Rarity="Rare", Type="Natural"},
    {Name="Magma", Rarity="Rare", Type="Elemental"},
    -- Legendary
    {Name="Quake", Rarity="Legendary", Type="Natural"},
    {Name="Buddha", Rarity="Legendary", Type="Beast"},
    {Name="Love", Rarity="Legendary", Type="Natural"},
    {Name="Spider", Rarity="Legendary", Type="Natural"},
    {Name="Sound", Rarity="Legendary", Type="Natural"},
    {Name="Phoenix", Rarity="Legendary", Type="Beast"},
    {Name="Portal", Rarity="Legendary", Type="Natural"},
    {Name="Rumble", Rarity="Legendary", Type="Elemental"},
    {Name="Pain", Rarity="Legendary", Type="Natural"},
    {Name="Blizzard", Rarity="Legendary", Type="Elemental"},
    {Name="Gravity", Rarity="Legendary", Type="Natural"},
    {Name="Mammoth", Rarity="Legendary", Type="Beast"},
    {Name="T-Rex", Rarity="Legendary", Type="Beast"},
    -- Mythical
    {Name="Dough", Rarity="Mythical", Type="Elemental"},
    {Name="Shadow", Rarity="Mythical", Type="Natural"},
    {Name="Venom", Rarity="Mythical", Type="Natural"},
    {Name="Spirit", Rarity="Mythical", Type="Natural"},
    {Name="Gas", Rarity="Mythical", Type="Elemental"},
    {Name="Control", Rarity="Mythical", Type="Natural"},
    {Name="Yeti", Rarity="Mythical", Type="Beast"},
    {Name="Tiger", Rarity="Mythical", Type="Beast"},
    {Name="Dragon", Rarity="Mythical", Type="Beast"},
    {Name="Kitsune", Rarity="Mythical", Type="Beast"},
}

-- Tạo bảng từ khóa tìm kiếm trái
local fruitKeywords = {}
for _, f in ipairs(fruitData) do
    table.insert(fruitKeywords, f.Name:lower())
end

-- ===== HÀM TIỆN ÍCH =====
local function moveTo(pos)
    if not rootPart then return end
    rootPart.CFrame = CFrame.new(pos)
    wait(CONFIG.SafeMode and 0.25 or 0.1)
end

local function teleportToIsland(name)
    local pos = islands[name]
    if pos then
        moveTo(pos)
        print("📍 Đã teleport đến: " .. name)
    else
        print("❌ Không tìm thấy đảo: " .. name)
    end
end

local function fireRemote(data)
    if remoteEvent then
        remoteEvent:FireServer(data)
    end
end

-- ===== TÌM QUÁI VẬT =====
local function getNearestMonster()
    local nearest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and not obj:FindFirstChild("PlayerGui") then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp and obj.Humanoid.Health > 0 and obj.Humanoid.Health < 9999 then
                local d = (rootPart.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

-- ===== TẤN CÔNG =====
local function attackMonster(monster)
    if not monster or not status.Farm then return end
    local hrp = monster:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local attackPos = hrp.Position + Vector3.new(3,0,3)
    moveTo(attackPos)
    fireRemote({Type="Attack", Target=monster, Weapon=CONFIG.WeaponName})
    -- Dự phòng tấn công bằng tool
    local tool = player.Backpack:FindFirstChild(CONFIG.WeaponName) or character:FindFirstChild(CONFIG.WeaponName)
    if tool then
        humanoid:EquipTool(tool)
        wait(0.1)
        tool:Activate()
    end
end

-- ===== TÌM NPC QUEST GẦN NHẤT (theo danh sách) =====
local function getNearestQuestNPC()
    local nearest, dist = nil, math.huge
    for name, data in pairs(npcData) do
        if data.Type == "Quest" then
            local pos = data.Pos
            if pos then
                local d = (rootPart.Position - pos).Magnitude
                if d < dist then
                    dist = d
                    nearest = {Name=name, Data=data}
                end
            end
        end
    end
    return nearest
end

-- ===== NHẬN/NỘP QUEST =====
local function doQuest()
    if not status.Quest then return end
    local npc = getNearestQuestNPC()
    if npc then
        local pos = npc.Data.Pos
        if pos and (rootPart.Position - pos).Magnitude > CONFIG.QuestRadius then
            moveTo(pos + Vector3.new(2,0,2))
            wait(0.5)
        end
        fireRemote({Type="Quest", NPC=npc.Name, Action="Interact"})
        -- Dự phòng E
        local vInput = game:GetService("VirtualInputManager")
        vInput:SendKeyEvent(true, "E", false, nil)
        wait(0.2)
        vInput:SendKeyEvent(false, "E", false, nil)
    else
        -- Fallback: tìm NPC bằng cách cũ
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                local name = obj.Name:lower()
                if name:find("quest") or name:find("npc") or name:find("guru") then
                    local pos = obj.HumanoidRootPart.Position
                    if (rootPart.Position - pos).Magnitude > CONFIG.QuestRadius then
                        moveTo(pos + Vector3.new(2,0,2))
                        wait(0.5)
                    end
                    fireRemote({Type="Quest", NPC=obj.Name, Action="Interact"})
                    break
                end
            end
        end
    end
end

-- ===== NHẶT TRÁI (CẢI TIẾN VỚI ƯU TIÊN ĐỘ HIẾM) =====
local function getNearestFruit()
    local nearest = nil
    local bestDist = math.huge
    local bestRarity = 0
    local rarityRank = {Common=1, Uncommon=2, Rare=3, Legendary=4, Mythical=5}

    for _, obj in pairs(workspace:GetChildren()) do
        local objName = obj.Name:lower()
        local found = false
        local matchedFruit = nil
        for _, kw in ipairs(fruitKeywords) do
            if objName:find(kw) then
                found = true
                matchedFruit = kw
                break
            end
        end
        if found then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChild("Part")
            if hrp then
                local dist = (rootPart.Position - hrp.Position).Magnitude
                local rarity = "Common"
                for _, f in ipairs(fruitData) do
                    if f.Name:lower() == matchedFruit then
                        rarity = f.Rarity
                        break
                    end
                end
                local rank = rarityRank[rarity] or 0

                if CONFIG.OnlyRareFruit and rank < 3 then
                    goto continue
                end

                if rank > bestRarity or (rank == bestRarity and dist < bestDist) then
                    bestRarity = rank
                    bestDist = dist
                    nearest = obj
                end
                ::continue::
            end
        end
    end
    return nearest
end

local function pickupFruit()
    if not status.PickupFruit then return end
    local fruit = getNearestFruit()
    if fruit then
        local pos = fruit:FindFirstChild("HumanoidRootPart") or fruit:FindFirstChild("Handle") or fruit:FindFirstChild("Part")
        if pos and (rootPart.Position - pos.Position).Magnitude <= CONFIG.PickupRadius then
            local fruitName = fruit.Name
            for _, f in ipairs(fruitData) do
                if fruitName:lower():find(f.Name:lower()) then
                    fruitName = f.Name
                    if f.Rarity == "Mythical" or f.Rarity == "Legendary" then
                        print("🌟 PHÁT HIỆN TRÁI " .. f.Rarity:upper() .. ": " .. f.Name)
                    end
                    break
                end
            end
            moveTo(pos.Position)
            wait(0.3)
        end
    end
end

-- ===== NHẶT CHEST =====
local function getNearestChest()
    local nearest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("chest") then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Handle") or obj:FindFirstChild("Part")
            if hrp then
                local d = (rootPart.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

local function pickupChest()
    if not status.PickupChest then return end
    local chest = getNearestChest()
    if chest then
        local pos = chest:FindFirstChild("HumanoidRootPart") or chest:FindFirstChild("Handle") or chest:FindFirstChild("Part")
        if pos and (rootPart.Position - pos.Position).Magnitude <= CONFIG.PickupRadius then
            moveTo(pos.Position)
            wait(0.3)
            local vInput = game:GetService("VirtualInputManager")
            vInput:SendKeyEvent(true, "E", false, nil)
            wait(0.2)
            vInput:SendKeyEvent(false, "E", false, nil)
        end
    end
end

-- ===== AUTO HEAL =====
local function autoHeal()
    if not status.AutoHeal then return end
    if humanoid.Health < humanoid.MaxHealth * 0.4 then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("heal") or tool.Name:lower():find("fruit")) then
                humanoid:EquipTool(tool)
                wait(0.2)
                tool:Activate()
                break
            end
        end
    end
end

-- ===== AUTO SEA BEAST =====
local function getNearestSeaBeast()
    local nearest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("sea") or obj.Name:lower():find("beast") then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                local d = (rootPart.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

local function autoSeaBeast()
    if not status.AutoSeaBeast then return end
    local beast = getNearestSeaBeast()
    if beast then
        local hrp = beast:FindFirstChild("HumanoidRootPart")
        if hrp then
            moveTo(hrp.Position + Vector3.new(5,5,5))
            fireRemote({Type="Attack", Target=beast, Weapon=CONFIG.WeaponName})
        end
    else
        -- Tìm kiếm xung quanh biển
        local randomSeaPos = rootPart.Position + Vector3.new(math.random(-100,100),0,math.random(-100,100))
        moveTo(randomSeaPos)
    end
end

-- ===== AUTO RAID =====
local function getNearestRaidPlayer()
    local nearest, dist = nil, math.huge
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local d = (rootPart.Position - char.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = char
                end
            end
        end
    end
    return nearest
end

local function autoRaid()
    if not status.AutoRaid then return end
    local raidPlayer = getNearestRaidPlayer()
    if raidPlayer then
        local hrp = raidPlayer:FindFirstChild("HumanoidRootPart")
        if hrp then
            moveTo(hrp.Position + Vector3.new(2,0,2))
            fireRemote({Type="Raid", Action="Join"})
        end
    end
end

-- ===== AUTO STATS =====
local function autoStats()
    if not status.AutoStats then return end
    local statsGui = player.PlayerGui:FindFirstChild("StatsGui")
    if statsGui then
        for _, stat in pairs(CONFIG.StatPoints) do
            local btn = statsGui:FindFirstChild(stat) or statsGui:FindFirstChild("Add"..stat)
            if btn and btn:IsA("TextButton") then
                btn:Click()
                wait(0.1)
            end
        end
    end
end

-- ===== AUTO MASTERY =====
local function autoMastery()
    if not status.AutoMastery then return end
    local tool = character:FindFirstChild(CONFIG.WeaponName) or player.Backpack:FindFirstChild(CONFIG.WeaponName)
    if tool then
        humanoid:EquipTool(tool)
        wait(0.2)
        for i=1,5 do
            tool:Activate()
            wait(0.5)
        end
    end
end

-- ===== AUTO MATERIAL =====
local function getNearestMaterial()
    local nearest, dist = nil, math.huge
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("material") or obj.Name:lower():find("fragment") or obj.Name:lower():find("bone") then
            local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Part")
            if hrp then
                local d = (rootPart.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

local function autoMaterial()
    if not status.AutoMaterial then return end
    local mat = getNearestMaterial()
    if mat then
        local pos = mat:FindFirstChild("HumanoidRootPart") or mat:FindFirstChild("Part")
        if pos and (rootPart.Position - pos.Position).Magnitude <= CONFIG.PickupRadius then
            moveTo(pos.Position)
            wait(0.3)
        end
    end
end

-- ===== ANTI-BAN: HÀNH VI GIẢ NGƯỜI =====
local function humanBehavior()
    if math.random(1,10) > 7 then
        local camera = workspace.CurrentCamera
        camera.CFrame = camera.CFrame * CFrame.Angles(0, math.rad(math.random(-30,30)), 0)
    end
    if math.random(1,15) > 13 then
        humanoid:Jump()
    end
end

local function isSuspicious()
    local count = 0
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local dist = (rootPart.Position - char.HumanoidRootPart.Position).Magnitude
                if dist < 40 then count = count + 1 end
            end
        end
    end
    return count > 3
end

-- ===== KIỂM TRA NPC ẨN =====
local function checkHiddenNPCs()
    for name, data in pairs(npcData) do
        if data.Type == "Hidden" then
            local pos = data.Pos
            if pos and (rootPart.Position - pos).Magnitude < 20 then
                print("🔎 Phát hiện NPC ẩn: " .. name .. " - " .. (data.Note or ""))
                -- Có thể tự động tương tác ở đây
            end
        end
    end
end

-- ===== VÒNG LẶP CHÍNH =====
spawn(function()
    local lastQuestTime = 0
    local lastFruitTime = 0
    local lastChestTime = 0
    local lastHealTime = 0
    local lastStatsTime = 0
    local lastMasteryTime = 0
    local lastMaterialTime = 0
    local lastBeastTime = 0
    local lastRaidTime = 0
    local lastHiddenCheck = 0

    while wait(CONFIG.FarmInterval) do
        -- Anti-Ban
        humanBehavior()
        if isSuspicious() and CONFIG.SafeMode then
            wait(1.5)
        end

        -- Farm
        if status.Farm then
            local monster = getNearestMonster()
            if monster then
                attackMonster(monster)
                wait(math.random(10,30)/100)
            else
                local randomPos = rootPart.Position + Vector3.new(math.random(-50,50),0,math.random(-50,50))
                moveTo(randomPos)
                wait(math.random(50,100)/100)
            end
        end

        -- Quest
        if status.Quest and tick() - lastQuestTime > math.random(8,15) then
            doQuest()
            lastQuestTime = tick()
        end

        -- Pickup Fruit
        if status.PickupFruit and tick() - lastFruitTime > math.random(3,6) then
            pickupFruit()
            lastFruitTime = tick()
        end

        -- Pickup Chest
        if status.PickupChest and tick() - lastChestTime > math.random(5,8) then
            pickupChest()
            lastChestTime = tick()
        end

        -- Auto Heal
        if status.AutoHeal and tick() - lastHealTime > 2 then
            autoHeal()
            lastHealTime = tick()
        end

        -- Auto Stats
        if status.AutoStats and tick() - lastStatsTime > math.random(30,60) then
            autoStats()
            lastStatsTime = tick()
        end

        -- Auto Mastery
        if status.AutoMastery and tick() - lastMasteryTime > math.random(10,20) then
            autoMastery()
            lastMasteryTime = tick()
        end

        -- Auto Material
        if status.AutoMaterial and tick() - lastMaterialTime > math.random(4,8) then
            autoMaterial()
            lastMaterialTime = tick()
        end

        -- Auto Sea Beast
        if status.AutoSeaBeast and tick() - lastBeastTime > math.random(15,25) then
            autoSeaBeast()
            lastBeastTime = tick()
        end

        -- Auto Raid
        if status.AutoRaid and tick() - lastRaidTime > math.random(20,30) then
            autoRaid()
            lastRaidTime = tick()
        end

        -- Kiểm tra NPC ẩn mỗi 30s
        if tick() - lastHiddenCheck > 30 then
            checkHiddenNPCs()
            lastHiddenCheck = tick()
        end
    end
end)

-- ===== TẠO GUI =====
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local statusLabel = Instance.new("TextLabel")

screenGui.Parent = player.PlayerGui
frame.Size = UDim2.new(0, 280, 0, 480)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(10,10,20)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "⚡ AUTO FARM PRO v3.1"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.Parent = frame

statusLabel.Size = UDim2.new(1,0,0,20)
statusLabel.Position = UDim2.new(0,0,0,30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "🟢 Safe Mode: " .. (CONFIG.SafeMode and "ON" or "OFF")
statusLabel.TextColor3 = CONFIG.SafeMode and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,200,0)
statusLabel.Parent = frame

local function createToggle(text, yPos, varName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,28)
    btn.Position = UDim2.new(0.05,0,0,yPos)
    btn.Text = text .. ": " .. (status[varName] and "BẬT" or "TẮT")
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = status[varName] and Color3.fromRGB(0,160,0) or Color3.fromRGB(160,0,0)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        status[varName] = not status[varName]
        btn.Text = text .. ": " .. (status[varName] and "BẬT" or "TẮT")
        btn.BackgroundColor3 = status[varName] and Color3.fromRGB(0,160,0) or Color3.fromRGB(160,0,0)
    end)
end

createToggle("🔹 Farm", 55, "Farm")
createToggle("📜 Quest", 88, "Quest")
createToggle("🍎 Fruit", 121, "PickupFruit")
createToggle("📦 Chest", 154, "PickupChest")
createToggle("❤️ Heal", 187, "AutoHeal")
createToggle("🌊 Sea Beast", 220, "AutoSeaBeast")
createToggle("⚔️ Raid", 253, "AutoRaid")
createToggle("📊 Stats", 286, "AutoStats")
createToggle("🎯 Mastery", 319, "AutoMastery")
createToggle("🧱 Material", 352, "AutoMaterial")

-- Nút Teleport
local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0.9,0,0,30)
teleportBtn.Position = UDim2.new(0.05,0,0,385)
teleportBtn.Text = "📡 Mở danh sách đảo"
teleportBtn.TextColor3 = Color3.fromRGB(255,255,255)
teleportBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
teleportBtn.Parent = frame

local teleportMenuOpen = false
local menuFrame = nil

teleportBtn.MouseButton1Click:Connect(function()
    if teleportMenuOpen then
        if menuFrame then menuFrame:Destroy() end
        teleportMenuOpen = false
        return
    end
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0,200,0,400)
    menuFrame.Position = UDim2.new(1.05,0,0,0)
    menuFrame.BackgroundColor3 = Color3.fromRGB(20,20,35)
    menuFrame.BackgroundTransparency = 0.1
    menuFrame.Parent = frame
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.BackgroundTransparency = 1
    scroll.Parent = menuFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,3)
    layout.Parent = scroll
    local islandNames = {}
    for name,_ in pairs(islands) do table.insert(islandNames, name) end
    table.sort(islandNames)
    for _, name in ipairs(islandNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9,0,0,28)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Parent = scroll
        btn.MouseButton1Click:Connect(function()
            teleportToIsland(name)
            menuFrame:Destroy()
            teleportMenuOpen = false
        end)
    end
    teleportMenuOpen = true
end)

-- Nút tương tác NPC
local npcBtn = Instance.new("TextButton")
npcBtn.Size = UDim2.new(0.9,0,0,30)
npcBtn.Position = UDim2.new(0.05,0,0,420)
npcBtn.Text = "🤖 Tương tác NPC"
npcBtn.TextColor3 = Color3.fromRGB(255,255,255)
npcBtn.BackgroundColor3 = Color3.fromRGB(150,50,200)
npcBtn.Parent = frame

local npcMenuOpen = false
local npcMenuFrame = nil

npcBtn.MouseButton1Click:Connect(function()
    if npcMenuOpen then
        if npcMenuFrame then npcMenuFrame:Destroy() end
        npcMenuOpen = false
        return
    end
    npcMenuFrame = Instance.new("Frame")
    npcMenuFrame.Size = UDim2.new(0,200,0,400)
    npcMenuFrame.Position = UDim2.new(1.05,0,0,0)
    npcMenuFrame.BackgroundColor3 = Color3.fromRGB(20,20,35)
    npcMenuFrame.BackgroundTransparency = 0.1
    npcMenuFrame.Parent = frame
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1,0,1,0)
    scroll.BackgroundTransparency = 1
    scroll.Parent = npcMenuFrame
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,3)
    layout.Parent = scroll
    local npcNames = {}
    for name,_ in pairs(npcData) do table.insert(npcNames, name) end
    table.sort(npcNames)
    for _, name in ipairs(npcNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9,0,0,28)
        btn.Text = name .. " (" .. npcData[name].Type .. ")"
        btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Parent = scroll
        btn.MouseButton1Click:Connect(function()
            local data = npcData[name]
            if data.Pos then
                moveTo(data.Pos + Vector3.new(2,0,2))
                wait(0.5)
                fireRemote({Type="Interact", NPC=name})
                local vInput = game:GetService("VirtualInputManager")
                vInput:SendKeyEvent(true, "E", false, nil)
                wait(0.2)
                vInput:SendKeyEvent(false, "E", false, nil)
                print("Đã tương tác với " .. name)
                npcMenuFrame:Destroy()
                npcMenuOpen = false
            end
        end)
    end
    npcMenuOpen = true
end)

print("✅ Auto Farm Pro v3.1 đã khởi động với danh sách trái ác quỷ đầy đủ!")
