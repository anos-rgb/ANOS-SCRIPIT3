--[[
    ANOS EXPLOIT - Misc Module
    Miscellaneous features
]]

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Misc = {}

-- Anti-Kick
function Misc.EnableAntiKick()
    local config = _G.ANOS.Config
    config.States.AntiKick = true
    
    -- Hook metamethods
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        
        if method == "Kick" then
            _G.ANOS.Utils.Notify("Anti-Kick", "Blocked kick attempt!", 3)
            return
        end
        
        return oldNamecall(self, ...)
    end)
    
    setreadonly(mt, true)
    
    _G.ANOS.Utils.Notify("Anti-Kick", "Anti-Kick enabled!", 2)
end

function Misc.DisableAntiKick()
    _G.ANOS.Config.States.AntiKick = false
    _G.ANOS.Utils.Notify("Anti-Kick", "Anti-Kick disabled", 2)
end

function Misc.ToggleAntiKick()
    if _G.ANOS.Config.States.AntiKick then
        Misc.DisableAntiKick()
    else
        Misc.EnableAntiKick()
    end
end

-- Reset Character
function Misc.ResetCharacter()
    local core = _G.ANOS.Core
    
    if core.Humanoid then
        core.Humanoid.Health = 0
        _G.ANOS.Utils.Notify("Reset", "Character reset!", 2)
    end
end

-- Rejoin Server
function Misc.RejoinServer()
    _G.ANOS.Utils.Notify("Rejoin", "Rejoining server...", 2)
    task.wait(1)
    
    TeleportService:Teleport(game.PlaceId, _G.ANOS.Player)
end

-- Copy Game Link
function Misc.CopyGameLink()
    local link = "https://www.roblox.com/games/" .. game.PlaceId
    
    if setclipboard then
        setclipboard(link)
        _G.ANOS.Utils.Notify("Clipboard", "Game link copied!", 2)
    else
        _G.ANOS.Utils.Notify("Error", "Clipboard not supported!", 2)
    end
end

-- Server Hop
function Misc.ServerHop()
    _G.ANOS.Utils.Notify("Server Hop", "Finding new server...", 2)
    
    local success, result = pcall(function()
        local Api = "https://games.roblox.com/v1/games/"
        local PlaceId = game.PlaceId
        local ServersUrl = Api .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        
        local function ListServers(cursor)
            local url = ServersUrl .. ((cursor and "&cursor=" .. cursor) or "")
            local raw = game:HttpGet(url)
            return HttpService:JSONDecode(raw)
        end
        
        local servers
        local nextCursor
        
        repeat
            servers = ListServers(nextCursor)
            nextCursor = servers.nextPageCursor
            
            for _, server in pairs(servers.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, _G.ANOS.Player)
                    return
                end
            end
        until not nextCursor
        
        _G.ANOS.Utils.Notify("Server Hop", "No available servers!", 3)
    end)
    
    if not success then
        _G.ANOS.Utils.Notify("Error", "Server hop failed!", 2)
        warn(result)
    end
end

-- Get FPS
function Misc.GetFPS()
    local RunService = game:GetService("RunService")
    local fps = 0
    local lastTime = tick()
    local frameCount = 0
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        frameCount = frameCount + 1
        
        if tick() - lastTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastTime = tick()
        end
    end)
    
    task.wait(1.1)
    connection:Disconnect()
    
    return fps
end

-- Show FPS Counter
function Misc.ToggleFPSCounter()
    local screenGui = _G.ANOS.Core.ScreenGui
    local fpsLabel = screenGui:FindFirstChild("FPSCounter")
    
    if fpsLabel then
        fpsLabel:Destroy()
        return
    end
    
    fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSCounter"
    fpsLabel.Size = UDim2.new(0, 100, 0, 30)
    fpsLabel.Position = UDim2.new(1, -110, 0, 10)
    fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.BackgroundTransparency = 0.5
    fpsLabel.TextColor3 = Color3.new(1, 1, 1)
    fpsLabel.TextSize = 16
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.Text = "FPS: 0"
    fpsLabel.Parent = screenGui
    
    _G.ANOS.Utils.AddCorner(fpsLabel, 8)
    
    -- Update FPS
    local RunService = game:GetService("RunService")
    local lastTime = tick()
    local frameCount = 0
    local fps = 0
    
    local connection = RunService.Heartbeat:Connect(function()
        if not fpsLabel or not fpsLabel.Parent then
            connection:Disconnect()
            return
        end
        
        frameCount = frameCount + 1
        
        if tick() - lastTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastTime = tick()
            
            fpsLabel.Text = "FPS: " .. fps
            
            -- Color based on FPS
            if fps >= 60 then
                fpsLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
            elseif fps >= 30 then
                fpsLabel.TextColor3 = Color3.fromRGB(251, 146, 60)
            else
                fpsLabel.TextColor3 = Color3.fromRGB(239, 68, 68)
            end
        end
    end)
end

-- Get Player Info
function Misc.GetPlayerInfo()
    local player = _G.ANOS.Player
    
    return {
        Name = player.Name,
        DisplayName = player.DisplayName,
        UserId = player.UserId,
        AccountAge = player.AccountAge,
        MembershipType = tostring(player.MembershipType)
    }
end

-- Show Player Info
function Misc.ShowPlayerInfo()
    local info = Misc.GetPlayerInfo()
    local message = string.format(
        "Name: %s\nDisplay: %s\nID: %d\nAge: %d days\nMembership: %s",
        info.Name,
        info.DisplayName,
        info.UserId,
        info.AccountAge,
        info.MembershipType
    )
    
    _G.ANOS.Utils.Notify("Player Info", message, 5)
end

return Misc
