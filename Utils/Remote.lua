-- ===== UTILS/REMOTE.LUA =====
local Remote = {}

function Remote:GetRemote()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    return replicatedStorage:FindFirstChild("RemoteEvent") or replicatedStorage:FindFirstChild("RE")
end

function Remote:Fire(data)
    local remote = self:GetRemote()
    if remote then
        remote:FireServer(data)
    end
end

return Remote
