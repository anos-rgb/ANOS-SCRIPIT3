--[[
    ANOS Teleport Features
    Checkpoint, Player TP, Spawn TP
]]--

local Helpers = _G.ANOS.Helpers
local Config = _G.ANOS.Config

local Teleport = {}

-- Save Checkpoint
function Teleport.SaveCheckpoint()
    local rootPart = Helpers.GetRootPart()
    
    if rootPart then
        Config.Runtime.savedCheckpoint = rootPart.CFrame
        Helpers.Notify("Checkpoint saved!", 2, "success")
        return true
    else
        Helpers.Notify("Failed to save checkpoint", 2, "error")
        return false
    end
end

-- Load Checkpoint
function Teleport.LoadCheckpoint()
    if not Config.Runtime.savedCheckpoint then
        Helpers.Notify("No checkpoint saved!", 2, "warning")
        return false
    end
    
    local rootPart = Helpers.GetRootPart()
    
    if rootPart then
        rootPart.CFrame = Config.Runtime.savedCheckpoint
        Helpers.Notify("Teleported to checkpoint!", 2, "success")
        return true
    else
        Helpers.Notify("Failed to teleport", 2, "error")
        return false
    end
end

-- Teleport to Spawn
function Teleport.ToSpawn()
    local rootPart = Helpers.GetRootPart()
    
    if rootPart then
        rootPart.CFrame = CFrame.new(0, 50, 0)
        Helpers.Notify("Teleported to spawn!", 2, "success")
        return true
    else
        Helpers.Notify("Failed to teleport", 2, "error")
        return false
    end
end

-- Teleport to Player
function Teleport.ToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        Helpers.Notify("Player not found!", 2, "error")
        return false
    end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local rootPart = Helpers.GetRootPart()
    
    if targetRoot and rootPart then
        rootPart.CFrame = targetRoot.CFrame
        Helpers.Notify("Teleported to " .. targetPlayer.Name, 2, "success")
        return true
    else
        Helpers.Notify("Failed to teleport to player", 2, "error")
        return false
    end
end

-- Teleport to Coordinates
function Teleport.ToCoordinates(x, y, z)
    local rootPart = Helpers.GetRootPart()
    
    if rootPart then
        rootPart.CFrame = CFrame.new(x, y, z)
        Helpers.Notify(string.format("Teleported to (%.0f, %.0f, %.0f)", x, y, z), 2, "success")
        return true
    else
        Helpers.Notify("Failed to teleport", 2, "error")
        return false
    end
end

return Teleport
