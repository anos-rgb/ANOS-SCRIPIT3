--[[
    ANOS EXPLOIT - Utility Functions
    Helper functions untuk berbagai keperluan
]]

local TweenService = game:GetService("TweenService")

local Utils = {}

-- Tween helper
function Utils.Tween(object, duration, properties, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Create rounded corner
function Utils.AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

-- Create stroke/border
function Utils.AddStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

-- Create gradient
function Utils.AddGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    
    if colors then
        local colorSequence = {}
        for i, color in ipairs(colors) do
            table.insert(colorSequence, ColorSequenceKeypoint.new((i-1)/(#colors-1), color))
        end
        gradient.Color = ColorSequence.new(colorSequence)
    end
    
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

-- Notify user
function Utils.Notify(title, message, duration)
    local notifDuration = duration or 3
    
    -- Simple notification (bisa dikembangkan lebih lanjut)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title or "ANOS Exploit",
        Text = message or "",
        Duration = notifDuration,
        Icon = ""
    })
end

-- Safe get service
function Utils.GetService(serviceName)
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    
    return success and service or nil
end

-- Check if player exists
function Utils.PlayerExists(playerName)
    local Players = game:GetService("Players")
    for _, player in pairs(Players:GetPlayers()) do
        if player.Name == playerName or player.DisplayName == playerName then
            return true, player
        end
    end
    return false, nil
end

-- Get player's character
function Utils.GetPlayerCharacter(player)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            return player.Character, humanoid, rootPart
        end
    end
    return nil, nil, nil
end

-- Safe teleport
function Utils.Teleport(targetCFrame, attempts)
    attempts = attempts or 3
    local core = _G.ANOS.Core
    
    if not core or not core.RootPart then
        return false
    end
    
    for i = 1, attempts do
        core.RootPart.CFrame = targetCFrame
        task.wait(0.1)
        
        -- Check if teleport successful
        local distance = (core.RootPart.Position - targetCFrame.Position).Magnitude
        if distance < 10 then
            return true
        end
    end
    
    return false
end

-- Format number
function Utils.FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.1fK", num / 1000)
    else
        return tostring(math.floor(num))
    end
end

-- Deep copy table
function Utils.DeepCopy(original)
    local copy
    if type(original) == 'table' then
        copy = {}
        for key, value in next, original, nil do
            copy[Utils.DeepCopy(key)] = Utils.DeepCopy(value)
        end
        setmetatable(copy, Utils.DeepCopy(getmetatable(original)))
    else
        copy = original
    end
    return copy
end

-- Lerp function
function Utils.Lerp(a, b, t)
    return a + (b - a) * t
end

-- Clamp function
function Utils.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

return Utils
