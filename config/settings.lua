--[[
    ANOS EXPLOIT - Configuration
    Settings dan default values
]]

local Config = {}

-- Default settings untuk features
Config.Defaults = {
    WalkSpeed = 50,
    FlySpeed = 50,
    JumpPower = 100,
    Brightness = 2
}

-- Feature states (akan di-track runtime)
Config.States = {
    Speed = false,
    Fly = false,
    Noclip = false,
    Fullbright = false,
    Brightness = false,
    AntiKick = false,
    ESP = false
}

-- UI Theme colors dengan transparansi
Config.Theme = {
    -- Background colors (lebih transparan)
    MainBg = Color3.fromRGB(15, 15, 20),
    MainBgTransparency = 0.3, -- Tambah transparansi
    
    SecondaryBg = Color3.fromRGB(25, 25, 30),
    SecondaryBgTransparency = 0.4,
    
    ContentBg = Color3.fromRGB(30, 30, 35),
    ContentBgTransparency = 0.5,
    
    -- Accent colors
    Primary = Color3.fromRGB(139, 92, 246), -- Purple (lebih soft)
    PrimaryHover = Color3.fromRGB(167, 139, 250),
    
    Secondary = Color3.fromRGB(59, 130, 246), -- Blue (lebih soft)
    SecondaryHover = Color3.fromRGB(96, 165, 250),
    
    Success = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(251, 146, 60),
    
    -- Text colors
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 210),
    TextMuted = Color3.fromRGB(150, 150, 160),
    
    -- Border
    Border = Color3.fromRGB(139, 92, 246),
    BorderTransparency = 0.5
}

-- UI Layout configuration
Config.Layout = {
    MainFrameSize = UDim2.new(0, 500, 0, 600),
    CornerRadius = 16,
    Padding = 10,
    ButtonHeight = 45,
    SliderHeight = 75
}

-- Hotkeys
Config.Hotkeys = {
    ToggleUI = Enum.KeyCode.RightControl,
    ToggleFly = Enum.KeyCode.F,
    ToggleNoclip = Enum.KeyCode.N
}

-- Anti-detection settings
Config.AntiDetection = {
    RandomizeGuiName = true,
    HideFromDevConsole = true,
    SecureMetatable = true
}

return Config
