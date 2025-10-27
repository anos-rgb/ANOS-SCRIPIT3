--[[
    ANOS UI Themes
    Define different color schemes and visual styles
]]--

local Themes = {}

-- Default Dark Theme (More subtle and transparent)
Themes.Dark = {
    name = "Dark",
    
    -- Primary colors
    primary = Color3.fromRGB(100, 50, 200),
    primaryLight = Color3.fromRGB(120, 70, 220),
    primaryDark = Color3.fromRGB(80, 40, 180),
    
    -- Accent colors
    accent = Color3.fromRGB(120, 70, 220),
    accentHover = Color3.fromRGB(140, 90, 240),
    
    -- Background (with transparency)
    background = Color3.fromRGB(15, 15, 20),
    backgroundSecondary = Color3.fromRGB(25, 25, 32),
    backgroundTertiary = Color3.fromRGB(35, 35, 45),
    
    -- Transparency levels
    transparency = {
        window = 0.05,
        panel = 0.1,
        button = 0.2,
        overlay = 0.5
    },
    
    -- Text colors
    textPrimary = Color3.fromRGB(240, 240, 245),
    textSecondary = Color3.fromRGB(180, 180, 190),
    textMuted = Color3.fromRGB(120, 120, 130),
    textDisabled = Color3.fromRGB(80, 80, 90),
    
    -- Status colors
    success = Color3.fromRGB(70, 180, 90),
    warning = Color3.fromRGB(240, 180, 50),
    danger = Color3.fromRGB(220, 70, 70),
    info = Color3.fromRGB(70, 140, 220),
    
    -- Border and stroke
    border = Color3.fromRGB(100, 50, 200),
    borderTransparency = 0.3,
    stroke = Color3.fromRGB(255, 255, 255),
    strokeTransparency = 0.7
}

-- Midnight Blue Theme
Themes.Midnight = {
    name = "Midnight",
    
    primary = Color3.fromRGB(50, 100, 200),
    primaryLight = Color3.fromRGB(70, 120, 220),
    primaryDark = Color3.fromRGB(40, 80, 180),
    
    accent = Color3.fromRGB(70, 120, 220),
    accentHover = Color3.fromRGB(90, 140, 240),
    
    background = Color3.fromRGB(10, 15, 25),
    backgroundSecondary = Color3.fromRGB(20, 25, 35),
    backgroundTertiary = Color3.fromRGB(30, 35, 50),
    
    transparency = {
        window = 0.05,
        panel = 0.1,
        button = 0.2,
        overlay = 0.5
    },
    
    textPrimary = Color3.fromRGB(240, 245, 250),
    textSecondary = Color3.fromRGB(180, 190, 200),
    textMuted = Color3.fromRGB(120, 130, 150),
    textDisabled = Color3.fromRGB(80, 90, 110),
    
    success = Color3.fromRGB(70, 200, 120),
    warning = Color3.fromRGB(250, 190, 60),
    danger = Color3.fromRGB(230, 80, 80),
    info = Color3.fromRGB(80, 150, 230),
    
    border = Color3.fromRGB(50, 100, 200),
    borderTransparency = 0.3,
    stroke = Color3.fromRGB(255, 255, 255),
    strokeTransparency = 0.7
}

-- Cyber Green Theme
Themes.Cyber = {
    name = "Cyber",
    
    primary = Color3.fromRGB(50, 200, 100),
    primaryLight = Color3.fromRGB(70, 220, 120),
    primaryDark = Color3.fromRGB(40, 180, 80),
    
    accent = Color3.fromRGB(70, 220, 120),
    accentHover = Color3.fromRGB(90, 240, 140),
    
    background = Color3.fromRGB(10, 20, 15),
    backgroundSecondary = Color3.fromRGB(15, 30, 20),
    backgroundTertiary = Color3.fromRGB(25, 40, 30),
    
    transparency = {
        window = 0.05,
        panel = 0.1,
        button = 0.2,
        overlay = 0.5
    },
    
    textPrimary = Color3.fromRGB(240, 250, 245),
    textSecondary = Color3.fromRGB(180, 200, 190),
    textMuted = Color3.fromRGB(120, 150, 130),
    textDisabled = Color3.fromRGB(80, 110, 90),
    
    success = Color3.fromRGB(80, 220, 130),
    warning = Color3.fromRGB(240, 200, 70),
    danger = Color3.fromRGB(230, 90, 90),
    info = Color3.fromRGB(90, 190, 230),
    
    border = Color3.fromRGB(50, 200, 100),
    borderTransparency = 0.3,
    stroke = Color3.fromRGB(255, 255, 255),
    strokeTransparency = 0.7
}

-- Current active theme
Themes.Current = Themes.Dark

-- Theme switcher
function Themes.SetTheme(themeName)
    local theme = Themes[themeName]
    if theme then
        Themes.Current = theme
        print("Theme changed to: " .. theme.name)
        return true
    end
    return false
end

-- Get color by name
function Themes.GetColor(colorName)
    return Themes.Current[colorName] or Color3.fromRGB(255, 255, 255)
end

-- Get transparency by name
function Themes.GetTransparency(transparencyName)
    if Themes.Current.transparency and Themes.Current.transparency[transparencyName] then
        return Themes.Current.transparency[transparencyName]
    end
    return 0
end

return Themes
