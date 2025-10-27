--[[
    ANOS Helper Functions
    Common utility functions used across modules
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Helpers = {}
local player = Players.LocalPlayer

-- Get Character Components
function Helpers.GetCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

function Helpers.GetHumanoid()
    local character = Helpers.GetCharacter()
    return character and character:FindFirstChildOfClass("Humanoid")
end

function Helpers.GetRootPart()
    local character = Helpers.GetCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

-- Tween Helpers
function Helpers.TweenPosition(instance, targetPosition, duration)
    duration = duration or 0.3
    TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = targetPosition}
    ):Play()
end

function Helpers.TweenSize(instance, targetSize, duration)
    duration = duration or 0.3
    TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = targetSize}
    ):Play()
end

function Helpers.TweenColor(instance, targetColor, duration)
    duration = duration or 0.3
    TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = targetColor}
    ):Play()
end

function Helpers.TweenTransparency(instance, targetTransparency, duration)
    duration = duration or 0.3
    TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = targetTransparency}
    ):Play()
end

-- UI Helpers
function Helpers.CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

function Helpers.CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

function Helpers.CreateGradient(parent, colorSequence, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- Animation Effects
function Helpers.ButtonPressEffect(button)
    local originalSize = button.Size
    Helpers.TweenSize(button, UDim2.new(
        originalSize.X.Scale * 0.95,
        originalSize.X.Offset * 0.95,
        originalSize.Y.Scale * 0.95,
        originalSize.Y.Offset * 0.95
    ), 0.1)
    
    task.wait(0.1)
    
    Helpers.TweenSize(button, originalSize, 0.1)
end

function Helpers.ButtonHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        Helpers.TweenColor(button, hoverColor, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Helpers.TweenColor(button, originalColor, 0.2)
    end)
end

-- Connection Management
function Helpers.AddConnection(name, connection)
    if not _G.ANOS.Config.Runtime.connections then
        _G.ANOS.Config.Runtime.connections = {}
    end
    
    table.insert(_G.ANOS.Config.Runtime.connections, {
        Name = name,
        Connection = connection
    })
end

function Helpers.RemoveConnection(name)
    local connections = _G.ANOS.Config.Runtime.connections
    if not connections then return end
    
    for i = #connections, 1, -1 do
        if connections[i] and connections[i].Name == name then
            connections[i].Connection:Disconnect()
            table.remove(connections, i)
        end
    end
end

function Helpers.DisconnectAll()
    local connections = _G.ANOS.Config.Runtime.connections
    if not connections then return end
    
    for _, connection in pairs(connections) do
        if connection.Connection then
            connection.Connection:Disconnect()
        end
    end
    
    _G.ANOS.Config.Runtime.connections = {}
end

-- Notification System
function Helpers.Notify(message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"
    
    local colors = {
        info = _G.ANOS.Config.UI.primaryColor,
        success = _G.ANOS.Config.UI.successColor,
        warning = _G.ANOS.Config.UI.warningColor,
        error = _G.ANOS.Config.UI.dangerColor
    }
    
    -- Create notification (implement full notification UI if needed)
    print("[ANOS] " .. message)
end

-- Math Helpers
function Helpers.Lerp(a, b, t)
    return a + (b - a) * t
end

function Helpers.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- String Helpers
function Helpers.FormatNumber(number)
    return tostring(math.floor(number))
end

return Helpers
