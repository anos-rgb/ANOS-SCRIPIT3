--[[
    ANOS Configuration Module
    Stores all settings and states
]]--

local Config = {}

-- Feature States
Config.States = {
    speed = false,
    fly = false,
    noclip = false,
    fullbright = false,
    antiKick = false,
    esp = false,
    xray = false
}

-- Feature Settings
Config.Settings = {
    walkSpeed = 50,
    flySpeed = 50,
    jumpPower = 50,
    
    -- New brightness settings
    brightness = {
        enabled = false,
        level = 3,
        ambient = Color3.fromRGB(200, 200, 200),
        outdoorAmbient = Color3.fromRGB(150, 150, 150)
    }
}

-- UI Configuration
Config.UI = {
    -- Main window
    windowSize = UDim2.new(0, 480, 0, 560),
    windowTransparency = 0.15, -- More transparent (85% transparent)
    
    -- Colors (more subtle)
    primaryColor = Color3.fromRGB(100, 50, 200),    -- Purple
    secondaryColor = Color3.fromRGB(80, 80, 90),    -- Dark gray
    accentColor = Color3.fromRGB(120, 70, 220),     -- Light purple
    successColor = Color3.fromRGB(70, 180, 90),     -- Green
    dangerColor = Color3.fromRGB(220, 70, 70),      -- Red
    warningColor = Color3.fromRGB(240, 180, 50),    -- Yellow
    
    -- Text colors
    textPrimary = Color3.fromRGB(240, 240, 245),
    textSecondary = Color3.fromRGB(180, 180, 190),
    textMuted = Color3.fromRGB(120, 120, 130),
    
    -- Background colors (more transparent)
    backgroundPrimary = Color3.fromRGB(15, 15, 20),
    backgroundSecondary = Color3.fromRGB(25, 25, 32),
    backgroundTertiary = Color3.fromRGB(35, 35, 45)
}

-- Runtime Data
Config.Runtime = {
    currentTab = "movement",
    savedCheckpoint = nil,
    connections = {},
    flyBodyVelocity = nil
}

-- Save/Load Settings (optional)
function Config:Save()
    -- Implement save to DataStore if needed
end

function Config:Load()
    -- Implement load from DataStore if needed
end

function Config:Reset()
    self.States = {
        speed = false,
        fly = false,
        noclip = false,
        fullbright = false,
        antiKick = false,
        esp = false,
        xray = false
    }
    
    self.Settings = {
        walkSpeed = 50,
        flySpeed = 50,
        jumpPower = 100,
        brightness = {
            enabled = false,
            level = 3,
            ambient = Color3.fromRGB(200, 200, 200),
            outdoorAmbient = Color3.fromRGB(150, 150, 150)
        }
    }
end

return Config
