--[[
    ANOS Miscellaneous Features
    Anti-Kick, Reset, Rejoin, Server Hop, etc.
]]--

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local Helpers = _G.ANOS.Helpers
local Config = _G.ANOS.Config

local Misc = {}
local player = Players.LocalPlayer

-- Anti-Kick
function Misc.EnableAntiKick(enabled)
    Config.States.antiKick = enabled
    
    if enabled then
        local success, error = pcall(function()
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            
            setreadonly(mt, false)
            mt.__namecall = function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    Helpers.Notify("Kick attempt blocked!", 3, "warning")
                    return
                end
                return oldNamecall(self, ...)
            end
            setreadonly(mt, true)
        end)
        
        if success then
            Helpers.Notify("Anti-Kick enabled!", 2, "success")
        else
            Helpers.Notify("Anti-Kick not supported in this executor", 3, "error")
            Config.States.antiKick = false
        end
    else
        Helpers.Notify("Anti-Kick disabled", 2, "info")
    end
end

-- Reset Character
function Misc.ResetCharacter()
    local humanoid = Helpers.GetHumanoid()
    
    if humanoid then
        humanoid.Health = 0
        Helpers.Notify("Character reset", 2, "info")
    end
end

-- Rejoin Server
function Misc.RejoinServer()
    Helpers.Notify("Rejoining server...", 2, "info")
    task.wait(1)
    
    TeleportService:Teleport(game.PlaceId, player)
end

-- Copy Game Link
function Misc.CopyGameLink()
    local link = "https://www.roblox.com/games/" .. game.PlaceId
    
    local success, error = pcall(function()
        setclipboard(link)
    end)
    
    if success then
        Helpers.Notify("Game link copied!", 2, "success")
    else
        Helpers.Notify("Clipboard not supported", 2, "error")
        print("Game Link: " .. link)
    end
end

-- Server Hop
function Misc.ServerHop()
    Helpers.Notify("Finding new server...", 2, "info")
    
    local success, error = pcall(function()
        local Api = "https://games.roblox.com/v1/games/"
        local _place = game.PlaceId
        local _servers = Api .. _place .. "/servers/Public?sortOrder=Asc&limit=100"
        
        local function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor=" .. cursor) or ""))
            return HttpService:JSONDecode(Raw)
        end
        
        local Server, Next
        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        TeleportService:TeleportToPlaceInstance(_place, Server.id, player)
    end)
    
    if not success then
        Helpers.Notify("Server hop failed!", 2, "error")
        warn("Server Hop Error: " .. tostring(error))
    end
end

-- Get Player Info
function Misc.GetPlayerInfo()
    local info = {
        Username = player.Name,
        DisplayName = player.DisplayName,
        UserId = player.UserId,
        AccountAge = player.AccountAge,
        MembershipType = tostring(player.MembershipType)
    }
    
    return info
end

-- Print Player Info
function Misc.PrintPlayerInfo()
    local info = Misc.GetPlayerInfo()
    print("=== Player Information ===")
    print("Username: " .. info.Username)
    print("Display Name: " .. info.DisplayName)
    print("User ID: " .. info.UserId)
    print("Account Age: " .. info.AccountAge .. " days")
    print("Membership: " .. info.MembershipType)
    print("========================")
    
    Helpers.Notify("Player info printed to console", 2, "info")
end

-- Get Game Info
function Misc.GetGameInfo()
    local info = {
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
        Players = #Players:GetPlayers(),
        MaxPlayers = Players.MaxPlayers
    }
    
    return info
end

-- Print Game Info
function Misc.PrintGameInfo()
    local info = Misc.GetGameInfo()
    print("=== Game Information ===")
    print("Place ID: " .. info.PlaceId)
    print("Job ID: " .. info.JobId)
    print("Place Name: " .. info.PlaceName)
    print("Players: " .. info.Players .. "/" .. info.MaxPlayers)
    print("========================")
    
    Helpers.Notify("Game info printed to console", 2, "info")
end

return Misc
