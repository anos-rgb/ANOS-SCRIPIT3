--[[
    ANOS EXPLOIT - Premium Edition
    Main Entry Point
    
    GitHub: https://github.com/anos-rgb/ANOS-SCRIPIT3
    
    Installation:
    1. Download all files from GitHub
    2. Load this main file: loadstring(game:HttpGet(""https://raw.githubusercontent.com/anos-rgb/ANOS-SCRIPIT3/main/"))()
]]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- GitHub Raw URL
local GITHUB_BASE = "https://raw.githubusercontent.com/anos-rgb/ANOS-SCRIPIT3/main/"

-- Global ANOS namespace
_G.ANOS = _G.ANOS or {}
_G.ANOS.Version = "2.0.0"
_G.ANOS.Loaded = false

-- Prevent multiple instances
if _G.ANOS.Loaded then
    warn("ANOS Exploit is already loaded!")
    return
end

-- Loading function with error handling
local function loadModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(GITHUB_BASE .. path))()
    end)
    
    if not success then
        warn("Failed to load module: " .. path)
        warn("Error: " .. tostring(result))
        return nil
    end
    
    return result
end

-- Loading animation
local function showLoadingScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ANOSLoading_" .. math.random(1000, 9999)
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.Parent = CoreGui
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 400, 0, 200)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    loadingFrame.BackgroundTransparency = 0.1
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = loadingFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 50, 200)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = loadingFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "ANOS EXPLOIT"
    title.TextColor3 = Color3.fromRGB(100, 50, 200)
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = loadingFrame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 30)
    status.Position = UDim2.new(0, 20, 0, 80)
    status.BackgroundTransparency = 1
    status.Text = "Loading modules..."
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.TextSize = 14
    status.Font = Enum.Font.Gotham
    status.Parent = loadingFrame
    
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -40, 0, 6)
    progressBg.Position = UDim2.new(0, 20, 0, 130)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = loadingFrame
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 3)
    progressCorner.Parent = progressBg
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(0, 3)
    progressBarCorner.Parent = progressBar
    
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(1, -40, 0, 25)
    version.Position = UDim2.new(0, 20, 1, -45)
    version.BackgroundTransparency = 1
    version.Text = "Version " .. _G.ANOS.Version
    version.TextColor3 = Color3.fromRGB(150, 150, 150)
    version.TextSize = 12
    version.Font = Enum.Font.Gotham
    version.Parent = loadingFrame
    
    return screenGui, status, progressBar
end

-- Main loading sequence
local function initialize()
    print("=== ANOS EXPLOIT v" .. _G.ANOS.Version .. " ===")
    print("Loading...")
    
    local loadingGui, statusLabel, progressBar = showLoadingScreen()
    
    -- Module loading sequence
    local modules = {
        {name = "Config", path = "config/settings.lua", var = "Config"},
        {name = "Helpers", path = "utils/helpers.lua", var = "Helpers"},
        {name = "Themes", path = "ui/themes.lua", var = "Themes"},
        {name = "Components", path = "ui/components.lua", var = "Components"},
        {name = "Movement", path = "features/movement.lua", var = "Movement"},
        {name = "Visual", path = "features/visual.lua", var = "Visual"},
        {name = "Teleport", path = "features/teleport.lua", var = "Teleport"},
        {name = "Misc", path = "features/misc.lua", var = "Misc"},
        {name = "UI", path = "ui/main.lua", var = "UI"}
    }
    
    for i, module in ipairs(modules) do
        statusLabel.Text = "Loading " .. module.name .. "..."
        progressBar.Size = UDim2.new(i / #modules, 0, 1, 0)
        
        local result = loadModule(module.path)
        if result then
            _G.ANOS[module.var] = result
            print("✓ Loaded: " .. module.name)
        else
            warn("✗ Failed: " .. module.name)
        end
        
        task.wait(0.1)
    end
    
    -- Initialize UI
    statusLabel.Text = "Initializing UI..."
    task.wait(0.5)
    
    if _G.ANOS.UI then
        _G.ANOS.UI.Initialize()
    end
    
    -- Cleanup loading screen
    task.wait(0.5)
    loadingGui:Destroy()
    
    _G.ANOS.Loaded = true
    print("=== ANOS EXPLOIT LOADED SUCCESSFULLY ===")
end

-- Error handling wrapper
local success, error = pcall(initialize)

if not success then
    warn("ANOS Exploit failed to load!")
    warn("Error: " .. tostring(error))
end
