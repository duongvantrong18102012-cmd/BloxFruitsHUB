-- ===== DATA/FRUITS.LUA =====
local FruitData = {
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
-- Tạo bảng từ khóa để tìm kiếm
local FruitKeywords = {}
for _, f in ipairs(FruitData) do
    table.insert(FruitKeywords, f.Name:lower())
end

return {Data = FruitData, Keywords = FruitKeywords}
