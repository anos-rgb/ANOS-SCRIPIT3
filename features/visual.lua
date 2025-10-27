--[[
    ANOS Visual Features
    Fullbright, ESP, X-Ray, Fog Removal, Advanced Brightness
]]--

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local Helpers = _G.ANOS.Helpers
local Config = _G.ANOS.Config

local Visual = {}

-- Advanced Fullbright/Brightness System
function Visual.EnableBrightness(enabled)
    Config.States.fullbright = enabled
    
    if enabled then
        -- Save original lighting settings
        if not Config.Runtime.originalLighting then
            Config.Runtime.originalLighting = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                Ambient = Lighting.Ambient
            }
        end
        
        -- Apply brightness settings based on level
        local level = Config.Settings.brightness.level
        
        Lighting.Brightness = 2 + (level * 0.5)
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Config.Settings.brightness.outdoorAmbient
        Lighting.Ambient = Config.Settings.brightness.ambient
        
        -- Remove dark effects
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or 
               obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") then
                obj.Enabled = false
            end
        end
        
        Helpers.Notify("Advanced Brightness enabled! Level: " .. level, 2, "success")
    else
        Visual.DisableBrightness()
        Helpers.Notify("Brightness disabled", 2, "info")
    end
end

function Visual.DisableBrightness()
    if Config.Runtime.originalLighting then
        Lighting.Brightness = Config.Runtime.originalLighting.Brightness
        Lighting.ClockTime = Config.Runtime.originalLighting.ClockTime
        Lighting.FogEnd = Config.Runtime.originalLighting.FogEnd
        Lighting.GlobalShadows = Config.Runtime.originalLighting.GlobalShadows
        Lighting.OutdoorAmbient = Config.Runtime.originalLighting.OutdoorAmbient
        Lighting.Ambient = Config.Runtime.originalLighting.Ambient
        
        -- Re-enable effects
        for _, obj in pairs(Lighting:GetChildren()) do
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or 
               obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") then
                obj.Enabled = true
            end
        end
    end
end

function Visual.SetBrightnessLevel(level)
    Config.Settings.brightness.level = level
    
    if Config.States.fullbright then
        Lighting.Brightness = 2 + (level * 0.5)
        
        -- Adjust ambient based on level
        local ambientValue = 150 + (level * 16)
        Config.Settings.brightness.ambient = Color3.fromRGB(ambientValue, ambientValue, ambientValue)
        Config.Settings.brightness.outdoorAmbient = Color3.fromRGB(ambientValue - 30, ambientValue - 30, ambientValue - 30)
        
        Lighting.Ambient = Config.Settings.brightness.ambient
        Lighting.OutdoorAmbient = Config.Settings.brightness.outdoorAmbient
    end
end

-- ESP Players
function Visual.ToggleESP()
    local player = Players.LocalPlayer
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local highlight = otherPlayer.Character:FindFirstChild("ANOSHighlight")
            
            if highlight then
                highlight:Destroy()
            else
                local esp = Instance.new("Highlight")
                esp.Name = "ANOSHighlight"
                esp.Adornee = otherPlayer.Character
                esp.FillColor = Color3.fromRGB(100, 50, 200)
                esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                esp.FillTransparency = 0.5
                esp.OutlineTransparency = 0
                esp.Parent = otherPlayer.Character
            end
        end
    end
    
    Helpers.Notify("ESP toggled", 2, "info")
end

function Visual.EnableESP(enabled)
    Config.States.esp = enabled
    local player = Players.LocalPlayer
    
    if enabled then
        -- Add ESP to existing players
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local esp = Instance.new("Highlight")
                esp.Name = "ANOSHighlight"
                esp.Adornee = otherPlayer.Character
                esp.FillColor = Color3.fromRGB(100, 50, 200)
                esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                esp.FillTransparency = 0.5
                esp.OutlineTransparency = 0
                esp.Parent = otherPlayer.Character
            end
        end
        
        -- Auto-add ESP to new players
        Helpers.AddConnection("ESPConnection", Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(character)
                task.wait(0.5)
                if Config.States.esp and character then
                    local esp = Instance.new("Highlight")
                    esp.Name = "ANOSHighlight"
                    esp.Adornee = character
                    esp.FillColor = Color3.fromRGB(100, 50, 200)
                    esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                    esp.FillTransparency = 0.5
                    esp.OutlineTransparency = 0
                    esp.Parent = character
                end
            end)
        end))
        
        Helpers.Notify("ESP enabled!", 2, "success")
    else
        -- Remove all ESP
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character then
                local highlight = otherPlayer.Character:FindFirstChild("ANOSHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
        
        Helpers.RemoveConnection("ESPConnection")
        Helpers.Notify("ESP disabled", 2, "info")
    end
end

-- X-Ray Vision
function Visual.ToggleXRay()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name ~= "Terrain" then
            if obj.Transparency < 1 then
                if obj:GetAttribute("OriginalTransparency") then
                    obj.Transparency = obj:GetAttribute("OriginalTransparency")
                    obj:SetAttribute("OriginalTransparency", nil)
                else
                    obj:SetAttribute("OriginalTransparency", obj.Transparency)
                    obj.Transparency = 0.7
                end
            end
        end
    end
    
    Helpers.Notify("X-Ray toggled", 2, "info")
end

-- Remove Fog
function Visual.RemoveFog()
    Lighting.FogStart = 0
    Lighting.FogEnd = math.huge
    
    Helpers.Notify("Fog removed!", 2, "success")
end

-- Night Vision (alternative brightness)
function Visual.ToggleNightVision()
    if not Config.Runtime.nightVisionEnabled then
        Config.Runtime.nightVisionEnabled = true
        
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(180, 200, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 170, 150)
        Lighting.FogEnd = 100000
        
        -- Add green tint
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "ANOSNightVision"
        colorCorrection.TintColor = Color3.fromRGB(150, 255, 150)
        colorCorrection.Brightness = 0.1
        colorCorrection.Parent = Lighting
        
        Helpers.Notify("Night Vision enabled!", 2, "success")
    else
        Config.Runtime.nightVisionEnabled = false
        
        local nightVision = Lighting:FindFirstChild("ANOSNightVision")
        if nightVision then
            nightVision:Destroy()
        end
        
        Visual.DisableBrightness()
        Helpers.Notify("Night Vision disabled", 2, "info")
    end
end

return Visual
