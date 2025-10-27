--[[
    ANOS UI Components
    Reusable UI component creators
]]--

local TweenService = game:GetService("TweenService")
local Helpers = _G.ANOS.Helpers
local Themes = _G.ANOS.Themes

local Components = {}

-- Create Button
function Components.CreateButton(config)
    local button = Instance.new("TextButton")
    button.Size = config.size or UDim2.new(1, -10, 0, 50)
    button.BackgroundColor3 = config.color or Themes.GetColor("backgroundSecondary")
    button.BackgroundTransparency = config.transparency or Themes.GetTransparency("button")
    button.Text = config.text or "Button"
    button.TextColor3 = config.textColor or Themes.GetColor("textPrimary")
    button.TextSize = config.textSize or 14
    button.Font = config.font or Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = config.parent
    
    Helpers.CreateCorner(button, config.cornerRadius or 12)
    
    if config.stroke ~= false then
        Helpers.CreateStroke(button, 
            config.strokeColor or Themes.GetColor("stroke"),
            config.strokeThickness or 1,
            config.strokeTransparency or Themes.GetTransparency("overlay")
        )
    end
    
    -- Hover effect
    local originalColor = button.BackgroundColor3
    local hoverColor = config.hoverColor or Themes.GetColor("primary")
    
    button.MouseEnter:Connect(function()
        Helpers.TweenColor(button, hoverColor, 0.2)
        Helpers.TweenSize(button, UDim2.new(
            button.Size.X.Scale, button.Size.X.Offset + 5,
            button.Size.Y.Scale, button.Size.Y.Offset + 2
        ), 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Helpers.TweenColor(button, originalColor, 0.2)
        Helpers.TweenSize(button, config.size or UDim2.new(1, -10, 0, 50), 0.2)
    end)
    
    -- Click effect
    button.MouseButton1Click:Connect(function()
        Helpers.ButtonPressEffect(button)
        if config.callback then
            task.spawn(config.callback, button)
        end
    end)
    
    return button
end

-- Create Toggle Button
function Components.CreateToggle(config)
    local isActive = config.defaultState or false
    
    local button = Components.CreateButton({
        parent = config.parent,
        text = config.text or "Toggle",
        size = config.size,
        color = isActive and Themes.GetColor("success") or Themes.GetColor("backgroundSecondary"),
        callback = function(btn)
            isActive = not isActive
            Helpers.TweenColor(btn, 
                isActive and Themes.GetColor("success") or Themes.GetColor("backgroundSecondary"),
                0.3
            )
            btn.Text = config.textActive and isActive and config.textActive or config.text
            
            if config.callback then
                config.callback(isActive, btn)
            end
        end
    })
    
    return button, function() return isActive end
end

-- Create Slider
function Components.CreateSlider(config)
    local frame = Instance.new("Frame")
    frame.Size = config.size or UDim2.new(1, -10, 0, 80)
    frame.BackgroundColor3 = Themes.GetColor("backgroundSecondary")
    frame.BackgroundTransparency = Themes.GetTransparency("panel")
    frame.BorderSizePixel = 0
    frame.Parent = config.parent
    
    Helpers.CreateCorner(frame, 12)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = (config.title or "Slider") .. ": " .. (config.default or 0)
    label.TextColor3 = Themes.GetColor("textPrimary")
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 25)
    sliderBg.Position = UDim2.new(0, 10, 0, 40)
    sliderBg.BackgroundColor3 = Themes.GetColor("backgroundTertiary")
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    Helpers.CreateCorner(sliderBg, 12)
    
    local sliderFill = Instance.new("Frame")
    local min = config.min or 0
    local max = config.max or 100
    local default = config.default or min
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Themes.GetColor("primary")
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    Helpers.CreateCorner(sliderFill, 12)
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 25, 0, 25)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -12.5, 0.5, -12.5)
    sliderBtn.BackgroundColor3 = Themes.GetColor("textPrimary")
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg
    
    Helpers.CreateCorner(sliderBtn, 12.5)
    
    local dragging = false
    local currentValue = default
    
    local function updateSlider(relativePos)
        relativePos = math.clamp(relativePos, 0, 1)
        currentValue = math.floor(min + (max - min) * relativePos)
        
        sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
        sliderBtn.Position = UDim2.new(relativePos, -12.5, 0.5, -12.5)
        label.Text = (config.title or "Slider") .. ": " .. currentValue
        
        if config.callback then
            config.callback(currentValue)
        end
    end
    
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if dragging then
            local mouse = game:GetService("UserInputService"):GetMouseLocation()
            local relativePos = (mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
            updateSlider(relativePos)
        end
    end)
    
    return frame, function() return currentValue end
end

-- Create Tab Button
function Components.CreateTab(config)
    local tab = Instance.new("TextButton")
    tab.Size = config.size or UDim2.new(0, 100, 1, 0)
    tab.BackgroundColor3 = config.active and Themes.GetColor("primary") or Themes.GetColor("backgroundSecondary")
    tab.BackgroundTransparency = Themes.GetTransparency("button")
    tab.Text = config.text or "Tab"
    tab.TextColor3 = Themes.GetColor("textPrimary")
    tab.TextSize = 12
    tab.Font = Enum.Font.GothamBold
    tab.BorderSizePixel = 0
    tab.Parent = config.parent
    
    Helpers.CreateCorner(tab, 12)
    
    tab.MouseButton1Click:Connect(function()
        if config.callback then
            config.callback(tab)
        end
    end)
    
    return tab
end

-- Create Player List
function Components.CreatePlayerList(config)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local frame = Instance.new("Frame")
    frame.Size = config.size or UDim2.new(1, -10, 0, 200)
    frame.BackgroundColor3 = Themes.GetColor("backgroundSecondary")
    frame.BackgroundTransparency = Themes.GetTransparency("panel")
    frame.BorderSizePixel = 0
    frame.Parent = config.parent
    
    Helpers.CreateCorner(frame, 12)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = config.title or "PLAYERS"
    title.TextColor3 = Themes.GetColor("textPrimary")
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Themes.GetColor("primary")
    scrollFrame.BorderSizePixel = 0
    scrollFrame.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollFrame
    
    local function updateList()
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local totalHeight = 0
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                local playerBtn = Components.CreateButton({
                    parent = scrollFrame,
                    text = otherPlayer.Name,
                    size = UDim2.new(1, -10, 0, 35),
                    textSize = 12,
                    font = Enum.Font.Gotham,
                    callback = function()
                        if config.onPlayerClick then
                            config.onPlayerClick(otherPlayer)
                        end
                    end
                })
                
                totalHeight = totalHeight + 40
            end
        end
        
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end
    
    updateList()
    Players.PlayerAdded:Connect(updateList)
    Players.PlayerRemoving:Connect(updateList)
    
    return frame
end

-- Create Section Header
function Components.CreateSectionHeader(config)
    local header = Instance.new("TextLabel")
    header.Size = config.size or UDim2.new(1, -10, 0, 35)
    header.BackgroundTransparency = 1
    header.Text = config.text or "Section"
    header.TextColor3 = Themes.GetColor("primary")
    header.TextSize = 16
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = config.parent
    
    return header
end

return Components
