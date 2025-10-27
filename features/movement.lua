--[[
    ANOS Movement Features
    Speed, Fly, Noclip, Jump
]]--

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Helpers = _G.ANOS.Helpers
local Config = _G.ANOS.Config

local Movement = {}

-- Speed Hack
function Movement.EnableSpeed(enabled)
    Config.States.speed = enabled
    local humanoid = Helpers.GetHumanoid()
    
    if humanoid then
        if enabled then
            humanoid.WalkSpeed = Config.Settings.walkSpeed
            Helpers.Notify("Speed Hack enabled!", 2, "success")
        else
            humanoid.WalkSpeed = 16
            Helpers.Notify("Speed Hack disabled", 2, "info")
        end
    end
end

function Movement.SetWalkSpeed(speed)
    Config.Settings.walkSpeed = speed
    if Config.States.speed then
        local humanoid = Helpers.GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

-- Fly Hack
function Movement.EnableFly(enabled)
    Config.States.fly = enabled
    
    if enabled then
        Movement.SetupFly()
        Helpers.Notify("Fly Hack enabled! Use WASD + Space/Shift", 3, "success")
    else
        Movement.DisableFly()
        Helpers.Notify("Fly Hack disabled", 2, "info")
    end
end

function Movement.SetupFly()
    local rootPart = Helpers.GetRootPart()
    if not rootPart then return end
    
    -- Clean up old fly
    if Config.Runtime.flyBodyVelocity then
        Config.Runtime.flyBodyVelocity:Destroy()
    end
    
    -- Create new body velocity
    Config.Runtime.flyBodyVelocity = Instance.new("BodyVelocity")
    Config.Runtime.flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    Config.Runtime.flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Config.Runtime.flyBodyVelocity.Parent = rootPart
    
    -- Remove old fly connection
    Helpers.RemoveConnection("FlyConnection")
    
    -- Create fly loop
    local flyConnection = RunService.Heartbeat:Connect(function()
        if not Config.States.fly or not Config.Runtime.flyBodyVelocity or not Config.Runtime.flyBodyVelocity.Parent then
            return
        end
        
        local moveVector = Vector3.new(0, 0, 0)
        local camera = Workspace.CurrentCamera
        
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
        
        Config.Runtime.flyBodyVelocity.Velocity = moveVector * Config.Settings.flySpeed
    end)
    
    Helpers.AddConnection("FlyConnection", flyConnection)
end

function Movement.DisableFly()
    if Config.Runtime.flyBodyVelocity then
        Config.Runtime.flyBodyVelocity:Destroy()
        Config.Runtime.flyBodyVelocity = nil
    end
    
    Helpers.RemoveConnection("FlyConnection")
end

function Movement.SetFlySpeed(speed)
    Config.Settings.flySpeed = speed
end

-- Noclip Hack
function Movement.EnableNoclip(enabled)
    Config.States.noclip = enabled
    
    if enabled then
        Movement.SetupNoclip()
        Helpers.Notify("Noclip enabled!", 2, "success")
    else
        Movement.DisableNoclip()
        Helpers.Notify("Noclip disabled", 2, "info")
    end
end

function Movement.SetupNoclip()
    Helpers.RemoveConnection("NoclipConnection")
    
    local noclipConnection = RunService.Stepped:Connect(function()
        if not Config.States.noclip then return end
        
        local character = Helpers.GetCharacter()
        if not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    Helpers.AddConnection("NoclipConnection", noclipConnection)
end

function Movement.DisableNoclip()
    Helpers.RemoveConnection("NoclipConnection")
    
    local character = Helpers.GetCharacter()
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Infinite Jump
function Movement.InfiniteJump()
    local humanoid = Helpers.GetHumanoid()
    if humanoid then
        humanoid.JumpPower = Config.Settings.jumpPower
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        Helpers.Notify("Jumped!", 1, "info")
    end
end

function Movement.SetJumpPower(power)
    Config.Settings.jumpPower = power
end

-- Character Setup (call on respawn)
function Movement.SetupCharacter()
    if Config.States.speed then
        Movement.EnableSpeed(true)
    end
    
    if Config.States.fly then
        Movement.SetupFly()
    end
    
    if Config.States.noclip then
        Movement.SetupNoclip()
    end
end

return Movement
