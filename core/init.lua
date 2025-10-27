--[[
    ANOS EXPLOIT - Core System
    Handles initialization dan core functionality
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Core = {}
Core.Connections = {}
Core.ScreenGui = nil
Core.Character = nil
Core.Humanoid = nil
Core.RootPart = nil

-- Initialize core sistem
function Core.Initialize()
    print("[ANOS Core] Initializing...")
    
    -- Create main ScreenGui
    Core.ScreenGui = Instance.new("ScreenGui")
    Core.ScreenGui.Name = "ANOSExploit_" .. math.random(1000, 9999)
    Core.ScreenGui.ResetOnSpawn = false
    Core.ScreenGui.DisplayOrder = 999999
    Core.ScreenGui.IgnoreGuiInset = true
    
    -- Protect dari detection jika ada
    if syn and syn.protect_gui then
        syn.protect_gui(Core.ScreenGui)
    elseif gethui then
        Core.ScreenGui.Parent = gethui()
    else
        Core.ScreenGui.Parent = CoreGui
    end
    
    -- Setup character references
    Core.SetupCharacter()
    
    -- Handle character respawn
    _G.ANOS.Player.CharacterAdded:Connect(function()
        task.wait(0.5)
        Core.SetupCharacter()
        Core.RestoreStates()
    end)
    
    -- Setup hotkeys
    Core.SetupHotkeys()
    
    print("[ANOS Core] Initialized successfully")
end

-- Setup character references
function Core.SetupCharacter()
    Core.Character = _G.ANOS.Player.Character or _G.ANOS.Player.CharacterAdded:Wait()
    Core.Humanoid = Core.Character:WaitForChild("Humanoid")
    Core.RootPart = Core.Character:WaitForChild("HumanoidRootPart")
    
    print("[ANOS Core] Character setup complete")
end

-- Restore states setelah respawn
function Core.RestoreStates()
    local config = _G.ANOS.Config
    if not config then return end
    
    -- Restore speed
    if config.States.Speed then
        Core.Humanoid.WalkSpeed = config.Defaults.WalkSpeed
    end
    
    -- Restore fly
    if config.States.Fly and _G.ANOS.Modules.Movement then
        _G.ANOS.Modules.Movement.EnableFly()
    end
    
    -- Restore noclip
    if config.States.Noclip and _G.ANOS.Modules.Movement then
        _G.ANOS.Modules.Movement.EnableNoclip()
    end
    
    print("[ANOS Core] States restored")
end

-- Setup hotkeys
function Core.SetupHotkeys()
    local UserInputService = game:GetService("UserInputService")
    local config = _G.ANOS.Config
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Toggle UI
        if input.KeyCode == config.Hotkeys.ToggleUI then
            if _G.ANOS.UI and _G.ANOS.UI.MainFrame then
                _G.ANOS.UI.MainFrame.Visible = not _G.ANOS.UI.MainFrame.Visible
            end
        end
        
        -- Toggle Fly
        if input.KeyCode == config.Hotkeys.ToggleFly then
            if _G.ANOS.Modules.Movement then
                _G.ANOS.Modules.Movement.ToggleFly()
            end
        end
        
        -- Toggle Noclip
        if input.KeyCode == config.Hotkeys.ToggleNoclip then
            if _G.ANOS.Modules.Movement then
                _G.ANOS.Modules.Movement.ToggleNoclip()
            end
        end
    end)
end

-- Add connection untuk tracking
function Core.AddConnection(name, connection)
    Core.Connections[name] = connection
end

-- Remove connection
function Core.RemoveConnection(name)
    if Core.Connections[name] then
        Core.Connections[name]:Disconnect()
        Core.Connections[name] = nil
    end
end

-- Cleanup semua
function Core.Cleanup()
    print("[ANOS Core] Cleaning up...")
    
    -- Disconnect all connections
    for name, connection in pairs(Core.Connections) do
        if connection then
            connection:Disconnect()
        end
    end
    Core.Connections = {}
    
    -- Restore character state
    if Core.Character then
        -- Restore collisions
        for _, part in pairs(Core.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        
        -- Restore humanoid
        if Core.Humanoid then
            Core.Humanoid.WalkSpeed = 16
            Core.Humanoid.JumpPower = 50
        end
    end
    
    -- Destroy GUI
    if Core.ScreenGui then
        Core.ScreenGui:Destroy()
    end
    
    print("[ANOS Core] Cleanup complete")
end

return Core
