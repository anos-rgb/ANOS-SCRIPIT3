--[[
    ANOS EXPLOIT - Premium Edition
    Version: 2.0
    Main Entry Point
    
    Struktur Folder:
    ANOS-Exploit/
    ├── anos.lua (file ini)
    ├── config/settings.lua
    ├── core/init.lua
    ├── core/character.lua
    ├── ui/main.lua
    ├── ui/components.lua
    ├── ui/themes.lua
    ├── modules/movement.lua
    ├── modules/visual.lua
    ├── modules/teleport.lua
    ├── modules/misc.lua
    └── utils/helpers.lua
]]

-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Global namespace untuk ANOS
_G.ANOS = _G.ANOS or {}
_G.ANOS.Version = "2.0"
_G.ANOS.Player = Players.LocalPlayer

-- Load modules dengan error handling
local function loadModule(path, name)
    local success, module = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/anos-rgb/ANOS-SCRIPIT3/" .. path))()
    end)
    
    if success then
        print("[ANOS] Loaded: " .. name)
        return module
    else
        warn("[ANOS] Failed to load: " .. name)
        warn(module)
        return nil
    end
end

-- Load core modules
print("[ANOS] Initializing ANOS Exploit v" .. _G.ANOS.Version)

_G.ANOS.Config = loadModule("config/settings.lua", "Config")
_G.ANOS.Utils = loadModule("utils/helpers.lua", "Utils")
_G.ANOS.Core = loadModule("core/init.lua", "Core")
_G.ANOS.UI = loadModule("ui/main.lua", "UI")

-- Load feature modules
_G.ANOS.Modules = {
    Movement = loadModule("modules/movement.lua", "Movement Module"),
    Visual = loadModule("modules/visual.lua", "Visual Module"),
    Teleport = loadModule("modules/teleport.lua", "Teleport Module"),
    Misc = loadModule("modules/misc.lua", "Misc Module")
}

-- Initialize sistem
if _G.ANOS.Core then
    _G.ANOS.Core.Initialize()
end

if _G.ANOS.UI then
    _G.ANOS.UI.Create()
end

print("[ANOS] Initialization complete!")
print("[ANOS] Press the ANOS button to open menu")

-- Cleanup saat script di-destroy
local screenGui = CoreGui:FindFirstChild("ANOSExploit_" .. math.random(1000, 9999))
if screenGui then
    screenGui.Destroying:Connect(function()
        if _G.ANOS.Core then
            _G.ANOS.Core.Cleanup()
        end
        print("[ANOS] Cleaned up successfully")
    end)
end
