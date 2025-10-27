--[[
    ANOS EXPLOIT - Visual Module
    Fullbright, ESP, Brightness, dan visual features
]]

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local Visual = {}
Visual.OriginalLighting = {}

-- Save original lighting settings
function Visual.SaveLighting()
    Visual.OriginalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        GlobalShadows = Lighting.GlobalShadows,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        ColorShift_Top = Lighting.ColorShift_Top,
        ColorShift_Bottom = Lighting.ColorShift_Bottom
    }
end

-- Fullbright
function Visual.EnableFullbright()
    local config = _G.ANOS.Config
    config.States.Fullbright = true
    
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    
    _G.ANOS.Utils.Notify("Visual", "Fullbright enabled!", 2)
end

function Visual.DisableFullbright()
    local config = _G.ANOS.Config
    config.States.Fullbright = false
    
    -- Restore original lighting
    for property, value in pairs(Visual.OriginalLighting) do
        Lighting[property] = value
    end
    
    _G.ANOS.Utils.Notify("Visual", "Fullbright disabled", 2)
end

function Visual.ToggleFullbright()
    if _G.ANOS.Config.States.Fullbright then
        Visual.DisableFullbright()
    else
        Visual.EnableFullbright()
    end
end

-- Brightness Enhancement (NEW FEATURE!)
function Visual.EnableBrightness()
    local config = _G.ANOS.Config
    config.States.Brightness = true
    
    -- Set extreme brightness untuk dark games
    Lighting.Brightness = config.Defaults.Brightness
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    Lighting.FogEnd = 999999
    Lighting.FogStart = 0
    Lighting.GlobalShadows = false
    Lighting.ClockTime = 14
    
    -- Tambah bloom untuk efek lebih terang
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Name = "ANOSBrightness"
        bloom.Enabled = true
        bloom.Intensity = 0.5
        bloom.Size = 24
        bloom.Threshold = 0
        bloom.Parent = Lighting
    end
    
    _G.ANOS.Utils.Notify("Brightness", "Extreme brightness enabled!", 2)
end

function Visual.DisableBrightness()
    local config = _G.ANOS.Config
    config.States.Brightness = false
    
    -- Remove bloom
    local bloom = Lighting:FindFirstChild("ANOSBrightness")
    if bloom then
        bloom:Destroy()
    end
    
    -- Restore lighting
    for property, value in pairs(Visual.OriginalLighting) do
        Lighting[property] = value
    end
    
    _G.ANOS.Utils.Notify("Brightness", "Brightness disabled", 2)
end

function Visual.ToggleBrightness()
    if _G.ANOS.Config.States.Brightness then
        Visual.DisableBrightness()
    else
        Visual.EnableBrightness()
    end
end

function Visual.SetBrightness(value)
    _G.ANOS.Config.Defaults.Brightness = value
    
    if _G.ANOS.Config.States.Brightness then
        Lighting.Brightness = value
    end
end

-- ESP Players
function Visual.EnableESP()
    local config = _G.ANOS.Config
    config.States.ESP = true
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= _G.ANOS.Player and otherPlayer.Character then
            Visual.AddESP(otherPlayer.Character)
        end
    end
    
    _G.ANOS.Utils.Notify("ESP", "ESP enabled!", 2)
end

function Visual.DisableESP()
    local config = _G.ANOS.Config
    config.States.ESP = false
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Character then
            Visual.RemoveESP(otherPlayer.Character)
        end
    end
    
    _G.ANOS.Utils.Notify("ESP", "ESP disabled", 2)
end

function Visual.ToggleESP()
    if _G.ANOS.Config.States.ESP then
        Visual.DisableESP()
    else
        Visual.EnableESP()
    end
end

function Visual.AddESP(character)
    if not character then return end
    
    local highlight = character:FindFirstChild("ANOSHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ANOSHighlight"
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(139, 92, 246)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = character
    end
end

function Visual.RemoveESP(character)
    if not character then return end
    
    local highlight = character:FindFirstChild("ANOSHighlight")
    if highlight then
        highlight:Destroy()
    end
end

-- X-Ray Vision
function Visual.ToggleXRay()
    local Workspace = game:GetService("Workspace")
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Terrain" then
            if obj.Transparency < 1 then
                obj.Transparency = obj.Transparency == 0.5 and obj:GetAttribute("OriginalTransparency") or 0.5
                
                if obj.Transparency == 0.5 then
                    obj:SetAttribute("OriginalTransparency", 0)
                end
            end
        end
    end
    
    _G.ANOS.Utils.Notify("X-Ray", "X-Ray toggled!", 2)
end

-- Remove Fog
function Visual.RemoveFog()
    Lighting.FogStart = 0
    Lighting.FogEnd = math.huge
    
    _G.ANOS.Utils.Notify("Fog", "Fog removed!", 2)
end

-- Restore Fog
function Visual.RestoreFog()
    Lighting.FogStart = Visual.OriginalLighting.FogStart or 0
    Lighting.FogEnd = Visual.OriginalLighting.FogEnd or 100000
    
    _G.ANOS.Utils.Notify("Fog", "Fog restored", 2)
end

-- Cleanup
function Visual.Cleanup()
    Visual.DisableFullbright()
    Visual.DisableBrightness()
    Visual.DisableESP()
end

-- Initialize
Visual.SaveLighting()

return Visual
