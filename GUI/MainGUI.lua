-- ===== GUI/MAINGUI.LUA =====
local MainGUI = {}

function MainGUI:Create(Hub)
    local player = game.Players.LocalPlayer
    local status = {}
    status.Farm = true
    status.Quest = true
    status.PickupFruit = true
    status.PickupChest = true
    status.AutoHeal = true
    status.AutoSeaBeast = false
    status.AutoRaid = false
    status.AutoStats = false
    status.AutoMastery = false
    status.AutoMaterial = false
    Hub.status = status -- chia sẻ trạng thái

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
    title.Text = "⚡ BloxFruits Hub"
    title.TextColor3 = Color3.fromRGB(0,200,255)
    title.Parent = frame

    statusLabel.Size = UDim2.new(1,0,0,20)
    statusLabel.Position = UDim2.new(0,0,0,30)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "🟢 Safe Mode: " .. (Hub.Config.SafeMode and "ON" or "OFF")
    statusLabel.TextColor3 = Hub.Config.SafeMode and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,200,0)
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
        for name,_ in pairs(Hub.Islands) do table.insert(islandNames, name) end
        table.sort(islandNames)
        for _, name in ipairs(islandNames) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9,0,0,28)
            btn.Text = name
            btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Parent = scroll
            btn.MouseButton1Click:Connect(function()
                Hub.Teleport:TeleportToIsland(Hub, name)
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
        for name,_ in pairs(Hub.NPCs) do table.insert(npcNames, name) end
        table.sort(npcNames)
        for _, name in ipairs(npcNames) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.9,0,0,28)
            btn.Text = name .. " (" .. Hub.NPCs[name].Type .. ")"
            btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Parent = scroll
            btn.MouseButton1Click:Connect(function()
                Hub.Teleport:InteractWithNPC(Hub, name)
                npcMenuFrame:Destroy()
                npcMenuOpen = false
            end)
        end
        npcMenuOpen = true
    end)

    print("✅ GUI đã tạo xong")
end

return MainGUI
