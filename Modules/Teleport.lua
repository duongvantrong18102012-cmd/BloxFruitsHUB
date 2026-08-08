-- ===== MODULES/TELEPORT.LUA =====
local TeleportModule = {}

function TeleportModule:TeleportToIsland(Hub, islandName)
    Hub.Movement:TeleportToIsland(Hub, islandName)
end

function TeleportModule:InteractWithNPC(Hub, npcName)
    local npc = Hub.NPCs[npcName]
    if npc and npc.Pos then
        Hub.Movement:MoveTo(npc.Pos + Vector3.new(2,0,2))
        wait(0.5)
        Hub.Remote:Fire({Type="Interact", NPC=npcName})
        local vInput = game:GetService("VirtualInputManager")
        vInput:SendKeyEvent(true, "E", false, nil)
        wait(0.2)
        vInput:SendKeyEvent(false, "E", false, nil)
        print("Đã tương tác với " .. npcName)
    else
        print("❌ Không tìm thấy NPC: " .. npcName)
    end
end

return TeleportModule
