-- ===== LOADER.LUA =====
-- File này được gọi từ loadstring
local Hub = {}

-- Hàm tải module từ GitHub
local function LoadModule(path)
    local url = "https://raw.githubusercontent.com/duongvantrong18102012-cmd/BloxFruitsHUB/main/" .. path
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("⚠️ Lỗi tải module: " .. path .. "\n" .. result)
        return {}
    end
    return result
end

print("🔄 Đang tải Hub BloxFruits...")

-- Tải cấu hình
Hub.Config = LoadModule("Config.lua")

-- Tải dữ liệu
Hub.Islands = LoadModule("Data/Islands.lua")
Hub.NPCs = LoadModule("Data/NPCs.lua")
Hub.Fruits = LoadModule("Data/Fruits.lua")

-- Tải tiện ích
Hub.Movement = LoadModule("Utils/Movement.lua")
Hub.Remote = LoadModule("Utils/Remote.lua")
Hub.Helpers = LoadModule("Utils/Helpers.lua")

-- Tải module chức năng
Hub.Farm = LoadModule("Modules/Farm.lua")
Hub.Quest = LoadModule("Modules/Quest.lua")
Hub.Pickup = LoadModule("Modules/Pickup.lua")
Hub.SeaBeast = LoadModule("Modules/SeaBeast.lua")
Hub.Raid = LoadModule("Modules/Raid.lua")
Hub.Stats = LoadModule("Modules/Stats.lua")
Hub.Mastery = LoadModule("Modules/Mastery.lua")
Hub.Material = LoadModule("Modules/Material.lua")
Hub.AntiBan = LoadModule("Modules/AntiBan.lua")
Hub.Teleport = LoadModule("Modules/Teleport.lua")
Hub.GUI = LoadModule("GUI/MainGUI.lua")

-- Khởi tạo Hub
print("✅ Tất cả module đã tải. Đang khởi tạo...")
Hub.GUI:Create(Hub)

-- Chạy các chức năng nền
Hub.AntiBan:Start(Hub)
Hub.Farm:Start(Hub)
Hub.Quest:Start(Hub)
Hub.Pickup:Start(Hub)
-- ... các module khác

print("🚀 BloxFruits Hub đã sẵn sàng!")

return Hub
