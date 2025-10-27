--[[
    ANOS EXPLOIT - Movement Module
    Speed, Fly, Noclip, dan movement features
]]

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Movement = {}
Movement.FlyBodyVelocity = nil
Movement.FlyControls = nil

-- Speed Hack
function Movement.EnableSpeed()
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    if not core.Humanoid then return end
    
    config.States.Speed = true
    core.Humanoid.WalkSpeed = config.Defaults.WalkSpeed
    
    _G.ANOS.Utils.Notify("Speed", "Speed hack enabled!", 2)
end

function Movement.DisableSpeed()
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    if not core.Humanoid then return end
    
    config.States.Speed = false
    core.Humanoid.WalkSpeed = 16
    
    _G.ANOS.Utils.Notify("Speed", "Speed hack disabled", 2)
end

function Movement.ToggleSpeed()
    if _G.ANOS.Config.States.Speed then
        Movement.DisableSpeed()
    else
        Movement.EnableSpeed()
    end
end

-- Fly Hack
function Movement.EnableFly()
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    if not core.RootPart then return end
    
    config.States.Fly = true
    
    -- Create BodyVelocity
    if Movement.FlyBodyVelocity then
        Movement.FlyBodyVelocity:Destroy()
    end
    
    Movement.FlyBodyVelocity = Instance.new("BodyVelocity")
    Movement.FlyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    Movement.FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Movement.FlyBodyVelocity.Parent = core.RootPart
    
    -- Fly connection
    core.RemoveConnection("FlyUpdate")
    
    local flyConnection = RunService.Heartbeat:Connect(function()
        if not config.States.Fly or not Movement.FlyBodyVelocity then return end
        
        local moveVector = Vector3.new(0, 0, 0)
        local camera = Workspace.CurrentCamera
        
        -- WASD movement
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        Movement.FlyBodyVelocity.Velocity = moveVector * config.Defaults.FlySpeed
    end)
    
    core.AddConnection("FlyUpdate", flyConnection)
    
    _G.ANOS.Utils.Notify("Fly", "Fly hack enabled! Use WASD + Space/Shift", 3)
end

function Movement.DisableFly()
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    config.States.Fly = false
    
    if Movement.FlyBodyVelocity then
        Movement.FlyBodyVelocity:Destroy()
        Movement.FlyBodyVelocity = nil
    end
    
    core.RemoveConnection("FlyUpdate")
    
    _G.ANOS.Utils.Notify("Fly", "Fly hack disabled", 2)
end

function Movement.ToggleFly()
    if _G.ANOS.Config.States.Fly then
        Movement.DisableFly()
    else
        Movement.EnableFly()
    end
end

-- Noclip Hack
function Movement.EnableNoclip()
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    if not core.Character then return end
    
    config.States.Noclip = true
    
    core.RemoveConnection("NoclipUpdate")
    
    local noclipConnection = RunService.Stepped:Connect(function()
        if not config.States.Noclip or not core.Character then return end
        
        for _, part in pairs(core.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    core.AddConnection("NoclipUpdate", noclipConnection)
    
    _G.ANOS.Utils.Notify("Noclip", "Noclip enabled!", 2)
end

function Movement.DisableNoclip()
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    config.States.Noclip = false
    
    core.RemoveConnection("NoclipUpdate")
    
    if core.Character then
        for _, part in pairs(core.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    _G.ANOS.Utils.Notify("Noclip", "Noclip disabled", 2)
end

function Movement.ToggleNoclip()
    if _G.ANOS.Config.States.Noclip then
        Movement.DisableNoclip()
    else
        Movement.EnableNoclip()
    end
end

-- Set Walk Speed
function Movement.SetWalkSpeed(speed)
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    config.Defaults.WalkSpeed = speed
    
    if config.States.Speed and core.Humanoid then
        core.Humanoid.WalkSpeed = speed
    end
end

-- Set Fly Speed
function Movement.SetFlySpeed(speed)
    _G.ANOS.Config.Defaults.FlySpeed = speed
end

-- Infinite Jump
function Movement.InfiniteJump()
    local core = _G.ANOS.Core
    local config = _G.ANOS.Config
    
    if not core.Humanoid then return end
    
    core.Humanoid.JumpPower = config.Defaults.JumpPower
    core.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end

-- Cleanup
function Movement.Cleanup()
    Movement.DisableFly()
    Movement.DisableNoclip()
    Movement.DisableSpeed()
end

return Movement
