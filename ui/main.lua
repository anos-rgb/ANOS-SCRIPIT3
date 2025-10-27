--[[
    ANOS EXPLOIT - Main UI
    Creates and manages the main interface
]]

local TweenService = game:GetService("TweenService")

local UI = {}
UI.MainFrame = nil
UI.ContentFrame = nil
UI.CurrentTab = "movement"
UI.ToggleButton = nil

-- Create Loading Animation
function UI.ShowLoading()
    local screenGui = _G.ANOS.Core.ScreenGui
    local theme = _G.ANOS.Config.Theme
    local utils = _G.ANOS.Utils
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(0, 400, 0, 200)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    loadingFrame.BackgroundColor3 = theme.MainBg
    loadingFrame.BackgroundTransparency = theme.MainBgTransparency
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = screenGui
    
    utils.AddCorner(loadingFrame, 20)
    utils.AddStroke(loadingFrame, theme.Border, 2, 0.5)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 50)
    title.Position = UDim2.new(0, 20, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "ANOS EXPLOIT"
    title.TextColor3 = theme.TextPrimary
    title.TextSize = 28
    title.Font = Enum.Font.GothamBold
    title.Parent = loadingFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 30)
    subtitle.Position = UDim2.new(0, 20, 0, 80)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Edition v" .. _G.ANOS.Version
    subtitle.TextColor3 = theme.TextSecondary
    subtitle.TextSize = 14
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = loadingFrame
    
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -60, 0, 6)
    progressBg.Position = UDim2.new(0, 30, 0, 140)
    progressBg.BackgroundColor3 = theme.ContentBg
    progressBg.BackgroundTransparency = 0.3
    progressBg.BorderSizePixel = 0
    progressBg.Parent = loadingFrame
    
    utils.AddCorner(progressBg, 3)
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = theme.Primary
    progressBar.BackgroundTransparency = 0.2
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    utils.AddCorner(progressBar, 3)
    
    -- Animate progress
    TweenService:Create(progressBar, TweenInfo.new(2.5), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    
    task.wait(2.5)
    
    -- Fade out
    utils.Tween(loadingFrame, 0.5, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    
    for _, child in pairs(loadingFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            utils.Tween(child, 0.5, {BackgroundTransparency = 1, TextTransparency = 1})
        end
    end
    
    task.wait(0.5)
    loadingFrame:Destroy()
end

-- Create Main UI
function UI.Create()
    local screenGui = _G.ANOS.Core.ScreenGui
    local theme = _G.ANOS.Config.Theme
    local utils = _G.ANOS.Utils
    local layout = _G.ANOS.Config.Layout
    
    -- Show loading first
    UI.ShowLoading()
    
    -- Create main frame
    UI.MainFrame = Instance.new("Frame")
    UI.MainFrame.Name = "MainFrame"
    UI.MainFrame.Size = layout.MainFrameSize
    UI.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    UI.MainFrame.BackgroundColor3 = theme.MainBg
    UI.MainFrame.BackgroundTransparency = theme.MainBgTransparency
    UI.MainFrame.BorderSizePixel = 0
    UI.MainFrame.Active = true
    UI.MainFrame.Draggable = true
    UI.MainFrame.Visible = false
    UI.MainFrame.Parent = screenGui
    
    utils.AddCorner(UI.MainFrame, layout.CornerRadius)
    utils.AddStroke(UI.MainFrame, theme.Border, 2, theme.BorderTransparency)
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = theme.SecondaryBg
    header.BackgroundTransparency = theme.SecondaryBgTransparency
    header.BorderSizePixel = 0
    header.Parent = UI.MainFrame
    
    utils.AddCorner(header, layout.CornerRadius)
    utils.AddGradient(header, {theme.Primary, theme.Secondary}, 45)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "ANOS EXPLOIT"
    title.TextColor3 = theme.TextPrimary
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Minimize button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 15)
    minimizeBtn.BackgroundColor3 = theme.Warning
    minimizeBtn.BackgroundTransparency = 0.2
    minimizeBtn.Text = "—"
    minimizeBtn.TextColor3 = theme.TextPrimary
    minimizeBtn.TextSize = 16
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = header
    
    utils.AddCorner(minimizeBtn, 15)
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 15)
    closeBtn.BackgroundColor3 = theme.Danger
    closeBtn.BackgroundTransparency = 0.2
    closeBtn.Text = "×"
    closeBtn.TextColor3 = theme.TextPrimary
    closeBtn.TextSize = 20
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header
    
    utils.AddCorner(closeBtn, 15)
    
    -- Tab container
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 0, 45)
    tabFrame.Position = UDim2.new(0, 10, 0, 70)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = UI.MainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabFrame
    
    -- Content frame (scrolling)
    UI.ContentFrame = Instance.new("ScrollingFrame")
    UI.ContentFrame.Size = UDim2.new(1, -20, 1, -125)
    UI.ContentFrame.Position = UDim2.new(0, 10, 0, 125)
    UI.ContentFrame.BackgroundTransparency = 1
    UI.ContentFrame.ScrollBarThickness = 4
    UI.ContentFrame.ScrollBarImageColor3 = theme.Primary
    UI.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    UI.ContentFrame.BorderSizePixel = 0
    UI.ContentFrame.Parent = UI.MainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = UI.ContentFrame
    
    -- Auto-resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        UI.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Create tabs
    UI.CreateTabs(tabFrame)
    
    -- Setup button events
    minimizeBtn.MouseButton1Click:Connect(function()
        local isMinimized = UI.MainFrame.Size.Y.Offset <= 60
        if isMinimized then
            utils.Tween(UI.MainFrame, 0.3, {Size = layout.MainFrameSize})
            minimizeBtn.Text = "—"
        else
            utils.Tween(UI.MainFrame, 0.3, {Size = UDim2.new(0, 500, 0, 60)})
            minimizeBtn.Text = "+"
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        UI.MainFrame.Visible = false
    end)
    
    -- Create toggle button
    UI.CreateToggleButton()
    
    -- Load initial tab
    UI.SwitchTab("movement")
    
    -- Show UI
    UI.MainFrame.Visible = true
end

-- Create Tabs
function UI.CreateTabs(parent)
    local Components = _G.ANOS.UI.Components or require(script.Parent.components)
    
    local tabs = {
        {Name = "movement", Text = "MOVEMENT"},
        {Name = "visual", Text = "VISUAL"},
        {Name = "teleport", Text = "TELEPORT"},
        {Name = "misc", Text = "MISC"}
    }
    
    for _, tabData in ipairs(tabs) do
        local tab = Components.CreateTab(parent, {
            Name = tabData.Name .. "Tab",
            Text = tabData.Text,
            Active = tabData.Name == UI.CurrentTab,
            Callback = function()
                UI.SwitchTab(tabData.Name)
            end
        })
    end
end

-- Switch Tab
function UI.SwitchTab(tabName)
    UI.CurrentTab = tabName
    
    -- Clear content
    for _, child in pairs(UI.ContentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    
    -- Update tab colors
    local tabFrame = UI.MainFrame:FindFirstChild("Frame")
    if tabFrame then
        for _, tab in pairs(tabFrame:GetChildren()) do
            if tab:IsA("TextButton") then
                local isActive = string.lower(tab.Text) == string.upper(tabName) or tab.Name:find(tabName)
                _G.ANOS.Utils.Tween(tab, 0.2, {
                    BackgroundColor3 = isActive and _G.ANOS.Config.Theme.Primary or _G.ANOS.Config.Theme.SecondaryBg,
                    BackgroundTransparency = isActive and 0.1 or 0.4
                })
            end
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
    local Components = _G.ANOS.UI.Components or require(script.Parent.components)
    local Movement = _G.ANOS.Modules.Movement
    
    Components.CreateToggle(UI.ContentFrame, {
        Name = "SpeedToggle",
        Text = "Speed Hack",
        ActiveText = "✓ Speed Hack",
        InactiveText = "Speed Hack",
        State = _G.ANOS.Config.States.Speed,
        Callback = function(state)
            Movement.ToggleSpeed()
        end
    })
    
    Components.CreateSlider(UI.ContentFrame, {
        Title = "Walk Speed",
        Min = 16,
        Max = 200,
        Default = _G.ANOS.Config.Defaults.WalkSpeed,
        Callback = function(value)
            Movement.SetWalkSpeed(value)
        end
    })
    
    Components.CreateToggle(UI.ContentFrame, {
        Name = "FlyToggle",
        Text = "Fly Hack",
        ActiveText = "✓ Fly Hack",
        InactiveText = "Fly Hack",
        State = _G.ANOS.Config.States.Fly,
        Callback = function(state)
            Movement.ToggleFly()
        end
    })
    
    Components.CreateSlider(UI.ContentFrame, {
        Title = "Fly Speed",
        Min = 16,
        Max = 200,
        Default = _G.ANOS.Config.Defaults.FlySpeed,
        Callback = function(value)
            Movement.SetFlySpeed(value)
        end
    })
    
    Components.CreateToggle(UI.ContentFrame, {
        Name = "NoclipToggle",
        Text = "Noclip",
        ActiveText = "✓ Noclip",
        InactiveText = "Noclip",
        State = _G.ANOS.Config.States.Noclip,
        Callback = function(state)
            Movement.ToggleNoclip()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "Infinite Jump",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            Movement.InfiniteJump()
        end
    })
end

-- Load Visual Tab
function UI.LoadVisualTab()
    local Components = _G.ANOS.UI.Components or require(script.Parent.components)
    local Visual = _G.ANOS.Modules.Visual
    
    Components.CreateToggle(UI.ContentFrame, {
        Name = "FullbrightToggle",
        Text = "Fullbright",
        ActiveText = "✓ Fullbright",
        InactiveText = "Fullbright",
        State = _G.ANOS.Config.States.Fullbright,
        Callback = function(state)
            Visual.ToggleFullbright()
        end
    })
    
    -- NEW: Brightness Feature
    Components.CreateToggle(UI.ContentFrame, {
        Name = "BrightnessToggle",
        Text = "Extreme Brightness",
        ActiveText = "✓ Extreme Brightness",
        InactiveText = "Extreme Brightness",
        State = _G.ANOS.Config.States.Brightness,
        Callback = function(state)
            Visual.ToggleBrightness()
        end
    })
    
    Components.CreateSlider(UI.ContentFrame, {
        Title = "Brightness Level",
        Min = 1,
        Max = 10,
        Default = _G.ANOS.Config.Defaults.Brightness,
        Callback = function(value)
            Visual.SetBrightness(value)
        end
    })
    
    Components.CreateToggle(UI.ContentFrame, {
        Name = "ESPToggle",
        Text = "ESP Players",
        ActiveText = "✓ ESP Players",
        InactiveText = "ESP Players",
        State = _G.ANOS.Config.States.ESP,
        Callback = function(state)
            Visual.ToggleESP()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "X-Ray Vision",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            Visual.ToggleXRay()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "Remove Fog",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            Visual.RemoveFog()
        end
    })
end

-- Load Teleport Tab
function UI.LoadTeleportTab()
    local Components = _G.ANOS.UI.Components or require(script.Parent.components)
    local Teleport = _G.ANOS.Modules.Teleport
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "💾 Save Checkpoint",
        Color = _G.ANOS.Config.Theme.Success,
        Callback = function()
            Teleport.SaveCheckpoint()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "📍 Load Checkpoint",
        Color = _G.ANOS.Config.Theme.Secondary,
        Callback = function()
            Teleport.LoadCheckpoint()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "🏠 Teleport to Spawn",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            Teleport.ToSpawn()
        end
    })
    
    Components.CreateSeparator(UI.ContentFrame)
    
    -- Player list
    UI.CreatePlayerList()
end

-- Create Player List
function UI.CreatePlayerList()
    local theme = _G.ANOS.Config.Theme
    local utils = _G.ANOS.Utils
    local Teleport = _G.ANOS.Modules.Teleport
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 200)
    frame.BackgroundColor3 = theme.SecondaryBg
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = UI.ContentFrame
    
    utils.AddCorner(frame, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "👥 TELEPORT TO PLAYERS"
    title.TextColor3 = theme.TextPrimary
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = theme.Primary
    scrollFrame.BorderSizePixel = 0
    scrollFrame.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scrollFrame
    
    local function updatePlayerList()
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local players = Teleport.GetPlayerList()
        
        for _, playerData in ipairs(players) do
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, -10, 0, 32)
            playerBtn.BackgroundColor3 = theme.ContentBg
            playerBtn.BackgroundTransparency = 0.4
            playerBtn.Text = playerData.DisplayName .. " (@" .. playerData.Name .. ")"
            playerBtn.TextColor3 = theme.TextPrimary
            playerBtn.TextSize = 11
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.BorderSizePixel = 0
            playerBtn.Parent = scrollFrame
            
            utils.AddCorner(playerBtn, 8)
            
            playerBtn.MouseEnter:Connect(function()
                utils.Tween(playerBtn, 0.2, {BackgroundColor3 = theme.Primary, BackgroundTransparency = 0.2})
            end)
            
            playerBtn.MouseLeave:Connect(function()
                utils.Tween(playerBtn, 0.2, {BackgroundColor3 = theme.ContentBg, BackgroundTransparency = 0.4})
            end)
            
            playerBtn.MouseButton1Click:Connect(function()
                Teleport.ToPlayer(playerData.Name)
            end)
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
    end
    
    updatePlayerList()
    
    game:GetService("Players").PlayerAdded:Connect(updatePlayerList)
    game:GetService("Players").PlayerRemoving:Connect(updatePlayerList)
end

-- Load Misc Tab
function UI.LoadMiscTab()
    local Components = _G.ANOS.UI.Components or require(script.Parent.components)
    local Misc = _G.ANOS.Modules.Misc
    
    Components.CreateToggle(UI.ContentFrame, {
        Name = "AntiKickToggle",
        Text = "Anti-Kick",
        ActiveText = "✓ Anti-Kick",
        InactiveText = "Anti-Kick",
        State = _G.ANOS.Config.States.AntiKick,
        Callback = function(state)
            Misc.ToggleAntiKick()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "📊 FPS Counter",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            Misc.ToggleFPSCounter()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "ℹ️ Player Info",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            Misc.ShowPlayerInfo()
        end
    })
    
    Components.CreateSeparator(UI.ContentFrame)
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "🔄 Reset Character",
        Color = _G.ANOS.Config.Theme.Danger,
        Callback = function()
            Misc.ResetCharacter()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "🔄 Rejoin Server",
        Color = _G.ANOS.Config.Theme.Warning,
        Callback = function()
            Misc.RejoinServer()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "🎲 Server Hop",
        Color = _G.ANOS.Config.Theme.Secondary,
        Callback = function()
            Misc.ServerHop()
        end
    })
    
    Components.CreateButton(UI.ContentFrame, {
        Text = "📋 Copy Game Link",
        Color = _G.ANOS.Config.Theme.SecondaryBg,
        Callback = function()
            Misc.CopyGameLink()
        end
    })
end

-- Create Toggle Button (Floating button)
function UI.CreateToggleButton()
    local screenGui = _G.ANOS.Core.ScreenGui
    local theme = _G.ANOS.Config.Theme
    local utils = _G.ANOS.Utils
    
    UI.ToggleButton = Instance.new("TextButton")
    UI.ToggleButton.Size = UDim2.new(0, 70, 0, 70)
    UI.ToggleButton.Position = UDim2.new(0, 20, 0, 100)
    UI.ToggleButton.BackgroundColor3 = theme.Primary
    UI.ToggleButton.BackgroundTransparency = 0.2
    UI.ToggleButton.Text = "A"
    UI.ToggleButton.TextColor3 = theme.TextPrimary
    UI.ToggleButton.TextSize = 28
    UI.ToggleButton.Font = Enum.Font.GothamBold
    UI.ToggleButton.BorderSizePixel = 0
    UI.ToggleButton.ZIndex = 999999
    UI.ToggleButton.Parent = screenGui
    
    utils.AddCorner(UI.ToggleButton, 35)
    utils.AddGradient(UI.ToggleButton, {theme.Primary, theme.Secondary}, 45)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    UI.ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = UI.ToggleButton.Position
        end
    end)
    
    UI.ToggleButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                UI.ToggleButton.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    UI.ToggleButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Toggle UI on click
    UI.ToggleButton.MouseButton1Click:Connect(function()
        if not dragging then
            UI.MainFrame.Visible = not UI.MainFrame.Visible
            utils.Tween(UI.ToggleButton, 0.1, {Size = UDim2.new(0, 60, 0, 60)})
            task.wait(0.1)
            utils.Tween(UI.ToggleButton, 0.1, {Size = UDim2.new(0, 70, 0, 70)})
        end
    end)
end

-- Store Components reference
UI.Components = _G.ANOS.UI and _G.ANOS.UI.Components

return UI
