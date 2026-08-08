-- ===== CONFIG.LUA =====
local Config = {
    AttackDistance = 28,
    QuestRadius = 60,
    PickupRadius = 35,
    FarmInterval = 0.3,
    WeaponName = "Blade",          -- Tên vũ khí đang dùng
    SafeMode = true,               -- Bật giảm tốc khi đông người
    StatPoints = {"Melee", "Defense", "Sword", "Gun", "Fruit"},
    OnlyRareFruit = false,         -- true: chỉ nhặt trái Rare trở lên
}

return Config
