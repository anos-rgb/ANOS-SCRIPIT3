--[[
    ANOS EXPLOIT - Teleport Module
    Teleportation features
]]

local Players = game:GetService("Players")

local Teleport = {}
Teleport.SavedCheckpoint = nil

-- Save Checkpoint
function Teleport.SaveCheckpoint()
    local core = _G.ANOS.Core
    
    if not core.RootPart then
        _G.ANOS.Utils.Notify("Teleport", "Cannot save checkpoint!", 2)
        return
    end
    
    Teleport.SavedCheckpoint = core.RootPart.CFrame
    _G.ANOS.Utils.Notify("Checkpoint", "Checkpoint saved!", 2)
end

-- Load Checkpoint
function Teleport.LoadCheckpoint()
    local core = _G.ANOS.Core
    
    if not Teleport.SavedCheckpoint then
        _G.ANOS.Utils.Notify("Teleport", "No checkpoint saved!", 2)
        return
    end
    
    if not core.RootPart then
        _G.ANOS.Utils.Notify("Teleport", "Cannot load checkpoint!", 2)
        return
    end
    
    local success = _G.ANOS.Utils.Teleport(Teleport.SavedCheckpoint)
    
    if success then
        _G.ANOS.Utils.Notify("Checkpoint", "Teleported to checkpoint!", 2)
    else
        _G.ANOS.Utils.Notify("Teleport", "Failed to teleport!", 2)
    end
end

-- Teleport to Spawn
function Teleport.ToSpawn()
    local core = _G.ANOS.Core
    
    if not core.RootPart then
        _G.ANOS.Utils.Notify("Teleport", "Cannot teleport!", 2)
        return
    end
    
    -- Try to find spawn location
    local spawnLocation = game:GetService("Workspace"):FindFirstChild("SpawnLocation")
    local targetCFrame
    
    if spawnLocation then
        targetCFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
    else
        targetCFrame = CFrame.new(0, 50, 0)
    end
    
    local success = _G.ANOS.Utils.Teleport(targetCFrame)
    
    if success then
        _G.ANOS.Utils.Notify("Teleport", "Teleported to spawn!", 2)
    else
        _G.ANOS.Utils.Notify("Teleport", "Failed to teleport!", 2)
    end
end

-- Teleport to Player
function Teleport.ToPlayer(playerName)
    local core = _G.ANOS.Core
    
    if not core.RootPart then
        _G.ANOS.Utils.Notify("Teleport", "Cannot teleport!", 2)
        return
    end
    
    local exists, targetPlayer = _G.ANOS.Utils.PlayerExists(playerName)
    
    if not exists or not targetPlayer then
        _G.ANOS.Utils.Notify("Teleport", "Player not found!", 2)
        return
    end
    
    local _, _, targetRoot = _G.ANOS.Utils.GetPlayerCharacter(targetPlayer)
    
    if not targetRoot then
        _G.ANOS.Utils.Notify("Teleport", "Player has no character!", 2)
        return
    end
    
    local success = _G.ANOS.Utils.Teleport(targetRoot.CFrame + Vector3.new(0, 3, 0))
    
    if success then
        _G.ANOS.Utils.Notify("Teleport", "Teleported to " .. targetPlayer.Name .. "!", 2)
    else
        _G.ANOS.Utils.Notify("Teleport", "Failed to teleport!", 2)
    end
end

-- Get All Players (for UI list)
function Teleport.GetPlayerList()
    local playerList = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= _G.ANOS.Player then
            table.insert(playerList, {
                Name = player.Name,
                DisplayName = player.DisplayName,
                Player = player
            })
        end
    end
    
    return playerList
end

-- Teleport to Coordinates
function Teleport.ToCoordinates(x, y, z)
    local core = _G.ANOS.Core
    
    if not core.RootPart then
        _G.ANOS.Utils.Notify("Teleport", "Cannot teleport!", 2)
        return
    end
    
    local targetCFrame = CFrame.new(x, y, z)
    local success = _G.ANOS.Utils.Teleport(targetCFrame)
    
    if success then
        _G.ANOS.Utils.Notify("Teleport", string.format("Teleported to %.0f, %.0f, %.0f!", x, y, z), 2)
    else
        _G.ANOS.Utils.Notify("Teleport", "Failed to teleport!", 2)
    end
end

-- Teleport Behind Player (for trolling)
function Teleport.BehindPlayer(playerName)
    local core = _G.ANOS.Core
    
    if not core.RootPart then return end
    
    local exists, targetPlayer = _G.ANOS.Utils.PlayerExists(playerName)
    if not exists or not targetPlayer then return end
    
    local _, _, targetRoot = _G.ANOS.Utils.GetPlayerCharacter(targetPlayer)
    if not targetRoot then return end
    
    local behindCFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
    _G.ANOS.Utils.Teleport(behindCFrame)
end

return Teleport
