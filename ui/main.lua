--[[
    ANOS Main UI Controller
    Manages the main interface
]]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Helpers = _G.ANOS.Helpers
local Themes = _G.ANOS.Themes
local Components = _G.ANOS.Components
local Config = _G.ANOS.Config

local UI = {}
local player = Players.LocalPlayer

-- Main Screen GUI
local screenGui
local mainFrame
local contentFrame
local currentTab = "movement"

-- Initialize UI
function UI.Initialize()
    -- Create Screen GUI
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ANOS_UI_" .. math.random(1000, 9999)
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 999999
    screenGui.Parent = CoreGui
    
    -- Create Main Frame
    UI.CreateMainWindow()
    
    -- Create Toggle Button
    UI.CreateToggleButton()
    
    -- Setup character
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if _G.ANOS.Movement then
            _G.ANOS.Movement.SetupCharacter()
        end
    end)
    
    if player.Character then
        _G.ANOS.Movement.SetupCharacter()
    end
    
    print("ANOS UI Initialized!")
end

-- Create Main Window
function UI.CreateMainWindow()
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 480, 0, 560)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -280)
    mainFrame.BackgroundColor3 = Themes.GetColor("background")
    mainFrame.BackgroundTransparency = Themes.GetTransparency("window")
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    Helpers.CreateCorner(mainFrame, 20)
    Helpers.CreateStroke(mainFrame, Themes.GetColor("border"), 2, Themes.GetTransparency("overlay"))
    
    -- Glow effect
    local glowFrame = Instance.new("Frame")
    glowFrame.Size = UDim2.new(1, 20, 1, 20)
    glowFrame.Position = UDim2.new(0, -10, 0, -10)
    glowFrame.BackgroundColor3 = Themes.GetColor("primary")
    glowFrame.BackgroundTransparency = 0.8
    glowFrame.BorderSizePixel = 0
    glowFrame.ZIndex = mainFrame.ZIndex - 1
    glowFrame.Parent = mainFrame
    Helpers.CreateCorner(glowFrame, 25)
    
    -- Header
    UI.CreateHeader()
    
    -- Tab Frame
    UI.CreateTabBar()
    
    -- Content Frame
    UI.CreateContentFrame()
    
    -- Load Movement Tab by default
    UI.SwitchTab("movement")
end

-- Create Header
function UI.CreateHeader()
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 60)
    headerFrame.BackgroundColor3 = Themes.GetColor("primary")
    headerFrame.BackgroundTransparency = Themes.GetTransparency("panel")
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame
    
    Helpers.CreateCorner(headerFrame, 20)
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 300, 0, 40)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "ANOS EXPLOIT"
    titleLabel.TextColor3 = Themes.GetColor("textPrimary")
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame
    
    -- Version
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 100, 0, 20)
    versionLabel.Position = UDim2.new(0, 20, 1, -25)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v" .. _G.ANOS.Version
    versionLabel.TextColor3 = Themes.GetColor("textSecondary")
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = headerFrame
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 15)
    minimizeBtn.BackgroundColor3 = Themes.GetColor("warning")
    minimizeBtn.BackgroundTransparency = 0.2
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Themes.GetColor("textPrimary")
    minimizeBtn.TextSize = 18
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = headerFrame
    
    Helpers.CreateCorner(minimizeBtn, 15)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        local isMinimized = mainFrame.Size.Y.Offset <= 60
        if isMinimized then
            Helpers.TweenSize(mainFrame, UDim2.new(0, 480, 0, 560), 0.3)
            minimizeBtn.Text = "−"
        else
            Helpers.TweenSize(mainFrame, UDim2.new(0, 480, 0, 60), 0.3)
            minimizeBtn.Text = "+"
        end
    end)
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 15)
    closeBtn.BackgroundColor3 = Themes.GetColor("danger")
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Themes.GetColor("textPrimary")
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = headerFrame
    
    Helpers.CreateCorner(closeBtn, 15)
    
    closeBtn.MouseButton1Click:Connect(function()
        UI.Close()
    end)
end

-- Create Tab Bar
function UI.CreateTabBar()
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 0, 45)
    tabFrame.Position = UDim2.new(0, 10, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = mainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabFrame
    
    -- Create tabs
    local tabs = {
        {name = "MOVEMENT", id = "movement"},
        {name = "VISUAL", id = "visual"},
        {name = "TELEPORT", id = "teleport"},
        {name = "MISC", id = "misc"}
    }
    
    for _, tabData in ipairs(tabs) do
        local tab = Components.CreateTab({
            parent = tabFrame,
            text = tabData.name,
            size = UDim2.new(0, 110, 1, 0),
            active = tabData.id == currentTab,
            callback = function()
                UI.SwitchTab(tabData.id)
            end
        })
    end
end

-- Create Content Frame
function UI.CreateContentFrame()
    contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Size = UDim2.new(1, -20, 1, -125)
    contentFrame.Position = UDim2.new(0, 10, 0, 125)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Themes.GetColor("primary")
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentFrame
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
end

-- Switch Tab
function UI.SwitchTab(tabName)
    currentTab = tabName
    
    -- Clear content
    for _, child in pairs(contentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    -- Update tab buttons
    for _, tab in pairs(mainFrame:FindFirstChild("Frame"):GetChildren()) do
        if tab:IsA("TextButton") then
            tab.BackgroundColor3 = Themes.GetColor("backgroundSecondary")
        end
    end
    
    -- Load tab content
    if tabName == "movement" then
        UI.LoadMovementTab()
    elseif tabName == "visual" then
        UI.LoadVisualTab()
    elseif tabName == "teleport" then
        UI.LoadTeleportTab()
    elseif tabName == "misc" then
        UI.LoadMiscTab()
    end
end

-- Load Movement Tab
function UI.LoadMovementTab()
    local Movement = _G.ANOS.Movement
    
    Components.CreateToggle({
        parent = contentFrame,
        text = "SPEED HACK",
        textActive = "DISABLE SPEED",
        defaultState = Config.States.speed,
        callback = function(enabled)
            Movement.EnableSpeed(enabled)
        end
    })
    
    Components.CreateSlider({
        parent = contentFrame,
        title = "Walk Speed",
        min = 16,
        max = 200,
        default = Config.Settings.walkSpeed,
        callback = function(value)
            Movement.SetWalkSpeed(value)
        end
    })
    
    Components.CreateToggle({
        parent = contentFrame,
        text = "FLY HACK",
        textActive = "DISABLE FLY",
        defaultState = Config.States.fly,
        callback = function(enabled)
            Movement.EnableFly(enabled)
        end
    })
    
    Components.CreateSlider({
        parent = contentFrame,
        title = "Fly Speed",
        min = 16,
        max = 200,
        default = Config.Settings.flySpeed,
        callback = function(value)
            Movement.SetFlySpeed(value)
        end
    })
    
    Components.CreateToggle({
        parent = contentFrame,
        text = "NOCLIP HACK",
        textActive = "DISABLE NOCLIP",
        defaultState = Config.States.noclip,
        callback = function(enabled)
            Movement.EnableNoclip(enabled)
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "INFINITE JUMP",
        color = Themes.GetColor("info"),
        callback = function()
            Movement.InfiniteJump()
        end
    })
end

-- Load Visual Tab
function UI.LoadVisualTab()
    local Visual = _G.ANOS.Visual
    
    Components.CreateToggle({
        parent = contentFrame,
        text = "ADVANCED BRIGHTNESS",
        textActive = "DISABLE BRIGHTNESS",
        defaultState = Config.States.fullbright,
        callback = function(enabled)
            Visual.EnableBrightness(enabled)
        end
    })
    
    Components.CreateSlider({
        parent = contentFrame,
        title = "Brightness Level",
        min = 1,
        max = 5,
        default = Config.Settings.brightness.level,
        callback = function(value)
            Visual.SetBrightnessLevel(value)
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "TOGGLE ESP",
        color = Themes.GetColor("info"),
        callback = function()
            Visual.ToggleESP()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "TOGGLE X-RAY",
        color = Themes.GetColor("danger"),
        callback = function()
            Visual.ToggleXRay()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "REMOVE FOG",
        color = Themes.GetColor("success"),
        callback = function()
            Visual.RemoveFog()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "NIGHT VISION",
        color = Themes.GetColor("warning"),
        callback = function()
            Visual.ToggleNightVision()
        end
    })
end

-- Load Teleport Tab
function UI.LoadTeleportTab()
    local Teleport = _G.ANOS.Teleport
    
    Components.CreateButton({
        parent = contentFrame,
        text = "SAVE CHECKPOINT",
        color = Themes.GetColor("success"),
        callback = function()
            Teleport.SaveCheckpoint()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "LOAD CHECKPOINT",
        color = Themes.GetColor("info"),
        callback = function()
            Teleport.LoadCheckpoint()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "TELEPORT TO SPAWN",
        color = Themes.GetColor("backgroundSecondary"),
        callback = function()
            Teleport.ToSpawn()
        end
    })
    
    Components.CreatePlayerList({
        parent = contentFrame,
        title = "TELEPORT TO PLAYERS",
        size = UDim2.new(1, -10, 0, 220),
        onPlayerClick = function(targetPlayer)
            Teleport.ToPlayer(targetPlayer)
        end
    })
end

-- Load Misc Tab
function UI.LoadMiscTab()
    local Misc = _G.ANOS.Misc
    
    Components.CreateToggle({
        parent = contentFrame,
        text = "ANTI-KICK",
        textActive = "DISABLE ANTI-KICK",
        defaultState = Config.States.antiKick,
        callback = function(enabled)
            Misc.EnableAntiKick(enabled)
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "RESET CHARACTER",
        color = Themes.GetColor("danger"),
        callback = function()
            Misc.ResetCharacter()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "REJOIN SERVER",
        color = Themes.GetColor("backgroundSecondary"),
        callback = function()
            Misc.RejoinServer()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "COPY GAME LINK",
        color = Themes.GetColor("info"),
        callback = function()
            Misc.CopyGameLink()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "SERVER HOP",
        color = Themes.GetColor("warning"),
        callback = function()
            Misc.ServerHop()
        end
    })
    
    Components.CreateButton({
        parent = contentFrame,
        text = "PLAYER INFO",
        color = Themes.GetColor("success"),
        callback = function()
            Misc.PrintPlayerInfo()
        end
    })
end

-- Create Toggle Button
function UI.CreateToggleButton()
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 70, 0, 70)
    toggleBtn.Position = UDim2.new(0, 20, 0, 100)
    toggleBtn.BackgroundColor3 = Themes.GetColor("primary")
    toggleBtn.BackgroundTransparency = 0.2
    toggleBtn.Text = "A"
    toggleBtn.TextColor3 = Themes.GetColor("textPrimary")
    toggleBtn.TextSize = 24
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.ZIndex = 999999
    toggleBtn.Parent = screenGui
    
    Helpers.CreateCorner(toggleBtn, 35)
    
    -- Glow
    local toggleGlow = Instance.new("Frame")
    toggleGlow.Size = UDim2.new(1, 10, 1, 10)
    toggleGlow.Position = UDim2.new(0, -5, 0, -5)
    toggleGlow.BackgroundColor3 = Themes.GetColor("primary")
    toggleGlow.BackgroundTransparency = 0.7
    toggleGlow.BorderSizePixel = 0
    toggleGlow.ZIndex = toggleBtn.ZIndex - 1
    toggleGlow.Parent = toggleBtn
    Helpers.CreateCorner(toggleGlow, 40)
    
    toggleBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        Helpers.ButtonPressEffect(toggleBtn)
    end)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggleBtn.Position
        end
    end)
    
    toggleBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                toggleBtn.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    toggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Close UI
function UI.Close()
    Helpers.DisconnectAll()
    
    if Config.Runtime.flyBodyVelocity then
        Config.Runtime.flyBodyVelocity:Destroy()
    end
    
    if Config.States.noclip then
        _G.ANOS.Movement.DisableNoclip()
    end
    
    if Config.States.speed then
        local humanoid = Helpers.GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end
    
    screenGui:Destroy()
    Helpers.Notify("ANOS Exploit closed", 2, "info")
end

return UI
