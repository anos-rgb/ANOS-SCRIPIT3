local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character, humanoid, rootPart

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ANOSExploit_" .. math.random(1000, 9999)
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = CoreGui

local states = {
    speed = false,
    fly = false,
    noclip = false,
    fullbright = false,
    antikick = false
}

local settings = {
    walkSpeed = 50,
    flySpeed = 50,
    jumpPower = 100
}

local connections = {}
local savedCheckpoint = nil
local currentTab = "movement"
local flyBodyVelocity = nil

local function setupCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if states.speed then
        humanoid.WalkSpeed = settings.walkSpeed
    end
    
    if states.fly then
        setupFly()
    end
    
    if states.noclip then
        setupNoclip()
    end
end

local function setupFly()
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
    end
    
    if not rootPart then return end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = rootPart
    
    for i = #connections, 1, -1 do
        if connections[i] and connections[i].Name == "FlyConnection" then
            connections[i].Connection:Disconnect()
            table.remove(connections, i)
        end
    end
    
    local buttonsPressed = {
        up = false,
        down = false,
        left = false,
        right = false,
        forward = false,
        back = false
    }
    
    local movementFrame = screenGui:FindFirstChild("MovementFrame")
    if not movementFrame then
        movementFrame = Instance.new("Frame")
        movementFrame.Name = "MovementFrame"
        movementFrame.Size = UDim2.new(0, 200, 0, 200)
        movementFrame.Position = UDim2.new(1, -220, 1, -220)
        movementFrame.BackgroundTransparency = 1
        movementFrame.Parent = screenGui
        
        local upBtn = Instance.new("TextButton")
        upBtn.Size = UDim2.new(0, 60, 0, 40)
        upBtn.Position = UDim2.new(0, 70, 0, 0)
        upBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        upBtn.Text = "UP"
        upBtn.TextColor3 = Color3.new(1, 1, 1)
        upBtn.TextSize = 14
        upBtn.Font = Enum.Font.GothamBold
        upBtn.BorderSizePixel = 0
        upBtn.Parent = movementFrame
        
        local upCorner = Instance.new("UICorner")
        upCorner.CornerRadius = UDim.new(0, 8)
        upCorner.Parent = upBtn
        
        local downBtn = Instance.new("TextButton")
        downBtn.Size = UDim2.new(0, 60, 0, 40)
        downBtn.Position = UDim2.new(0, 70, 0, 160)
        downBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        downBtn.Text = "DOWN"
        downBtn.TextColor3 = Color3.new(1, 1, 1)
        downBtn.TextSize = 14
        downBtn.Font = Enum.Font.GothamBold
        downBtn.BorderSizePixel = 0
        downBtn.Parent = movementFrame
        
        local downCorner = Instance.new("UICorner")
        downCorner.CornerRadius = UDim.new(0, 8)
        downCorner.Parent = downBtn
        
        local leftBtn = Instance.new("TextButton")
        leftBtn.Size = UDim2.new(0, 60, 0, 40)
        leftBtn.Position = UDim2.new(0, 0, 0, 80)
        leftBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        leftBtn.Text = "LEFT"
        leftBtn.TextColor3 = Color3.new(1, 1, 1)
        leftBtn.TextSize = 14
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.BorderSizePixel = 0
        leftBtn.Parent = movementFrame
        
        local leftCorner = Instance.new("UICorner")
        leftCorner.CornerRadius = UDim.new(0, 8)
        leftCorner.Parent = leftBtn
        
        local rightBtn = Instance.new("TextButton")
        rightBtn.Size = UDim2.new(0, 60, 0, 40)
        rightBtn.Position = UDim2.new(0, 140, 0, 80)
        rightBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        rightBtn.Text = "RIGHT"
        rightBtn.TextColor3 = Color3.new(1, 1, 1)
        rightBtn.TextSize = 14
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.BorderSizePixel = 0
        rightBtn.Parent = movementFrame
        
        local rightCorner = Instance.new("UICorner")
        rightCorner.CornerRadius = UDim.new(0, 8)
        rightCorner.Parent = rightBtn
        
        local forwardBtn = Instance.new("TextButton")
        forwardBtn.Size = UDim2.new(0, 60, 0, 40)
        forwardBtn.Position = UDim2.new(0, 70, 0, 40)
        forwardBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        forwardBtn.Text = "FWD"
        forwardBtn.TextColor3 = Color3.new(1, 1, 1)
        forwardBtn.TextSize = 14
        forwardBtn.Font = Enum.Font.GothamBold
        forwardBtn.BorderSizePixel = 0
        forwardBtn.Parent = movementFrame
        
        local forwardCorner = Instance.new("UICorner")
        forwardCorner.CornerRadius = UDim.new(0, 8)
        forwardCorner.Parent = forwardBtn
        
        local backBtn = Instance.new("TextButton")
        backBtn.Size = UDim2.new(0, 60, 0, 40)
        backBtn.Position = UDim2.new(0, 70, 0, 120)
        backBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        backBtn.Text = "BACK"
        backBtn.TextColor3 = Color3.new(1, 1, 1)
        backBtn.TextSize = 14
        backBtn.Font = Enum.Font.GothamBold
        backBtn.BorderSizePixel = 0
        backBtn.Parent = movementFrame
        
        local backCorner = Instance.new("UICorner")
        backCorner.CornerRadius = UDim.new(0, 8)
        backCorner.Parent = backBtn
        
        upBtn.MouseButton1Down:Connect(function()
            buttonsPressed.up = true
            upBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        end)
        upBtn.MouseButton1Up:Connect(function()
            buttonsPressed.up = false
            upBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end)
        
        downBtn.MouseButton1Down:Connect(function()
            buttonsPressed.down = true
            downBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        end)
        downBtn.MouseButton1Up:Connect(function()
            buttonsPressed.down = false
            downBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end)
        
        leftBtn.MouseButton1Down:Connect(function()
            buttonsPressed.left = true
            leftBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        end)
        leftBtn.MouseButton1Up:Connect(function()
            buttonsPressed.left = false
            leftBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end)
        
        rightBtn.MouseButton1Down:Connect(function()
            buttonsPressed.right = true
            rightBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        end)
        rightBtn.MouseButton1Up:Connect(function()
            buttonsPressed.right = false
            rightBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end)
        
        forwardBtn.MouseButton1Down:Connect(function()
            buttonsPressed.forward = true
            forwardBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        end)
        forwardBtn.MouseButton1Up:Connect(function()
            buttonsPressed.forward = false
            forwardBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end)
        
        backBtn.MouseButton1Down:Connect(function()
            buttonsPressed.back = true
            backBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        end)
        backBtn.MouseButton1Up:Connect(function()
            buttonsPressed.back = false
            backBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end)
    end
    
    local flyConnection = RunService.Heartbeat:Connect(function()
        if not states.fly or not flyBodyVelocity or not flyBodyVelocity.Parent then
            return
        end
        
        local moveVector = Vector3.new(0, 0, 0)
        local camera = Workspace.CurrentCamera
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or buttonsPressed.forward then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) or buttonsPressed.back then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or buttonsPressed.left then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or buttonsPressed.right then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or buttonsPressed.up then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or buttonsPressed.down then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        flyBodyVelocity.Velocity = moveVector * settings.flySpeed
    end)
    
    table.insert(connections, {Name = "FlyConnection", Connection = flyConnection})
end

local function setupNoclip()
    for i = #connections, 1, -1 do
        if connections[i] and connections[i].Name == "NoclipConnection" then
            connections[i].Connection:Disconnect()
            table.remove(connections, i)
        end
    end
    
    local noclipConnection = RunService.Stepped:Connect(function()
        if not states.noclip or not character then return end
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    table.insert(connections, {Name = "NoclipConnection", Connection = noclipConnection})
end

local function loadingAnimation()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 400, 0, 200)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = screenGui
    
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 20)
    loadingCorner.Parent = loadingFrame
    
    local loadingGradient = Instance.new("UIGradient")
    loadingGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150))
    }
    loadingGradient.Rotation = 45
    loadingGradient.Parent = loadingFrame
    
    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Size = UDim2.new(1, -20, 0, 50)
    loadingTitle.Position = UDim2.new(0, 10, 0, 20)
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.Text = "ANOS EXPLOIT"
    loadingTitle.TextColor3 = Color3.new(1, 1, 1)
    loadingTitle.TextSize = 24
    loadingTitle.Font = Enum.Font.GothamBold
    loadingTitle.TextStrokeTransparency = 0.5
    loadingTitle.Parent = loadingFrame
    
    local loadingSubtitle = Instance.new("TextLabel")
    loadingSubtitle.Size = UDim2.new(1, -20, 0, 30)
    loadingSubtitle.Position = UDim2.new(0, 10, 0, 70)
    loadingSubtitle.BackgroundTransparency = 1
    loadingSubtitle.Text = "Premium Edition Loading..."
    loadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingSubtitle.TextSize = 14
    loadingSubtitle.Font = Enum.Font.Gotham
    loadingSubtitle.Parent = loadingFrame
    
    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, -40, 0, 8)
    progressBg.Position = UDim2.new(0, 20, 0, 130)
    progressBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = loadingFrame
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 4)
    progressCorner.Parent = progressBg
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(0, 4)
    progressBarCorner.Parent = progressBar
    
    local logoFrame = Instance.new("Frame")
    logoFrame.Size = UDim2.new(0, 60, 0, 60)
    logoFrame.Position = UDim2.new(0.5, -30, 0, 150)
    logoFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    logoFrame.BorderSizePixel = 0
    logoFrame.Parent = loadingFrame
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 30)
    logoCorner.Parent = logoFrame
    
    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "A"
    logoText.TextColor3 = Color3.new(1, 1, 1)
    logoText.TextScaled = true
    logoText.Font = Enum.Font.GothamBold
    logoText.Parent = logoFrame
    
    TweenService:Create(progressBar, TweenInfo.new(3), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    
    local rotationTween = TweenService:Create(logoFrame, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    rotationTween:Play()
    
    task.wait(3)
    
    TweenService:Create(loadingFrame, TweenInfo.new(0.5), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    
    task.wait(0.5)
    loadingFrame:Destroy()
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 0, 150)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

local glowFrame = Instance.new("Frame")
glowFrame.Size = UDim2.new(1, 20, 1, 20)
glowFrame.Position = UDim2.new(0, -10, 0, -10)
glowFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
glowFrame.BackgroundTransparency = 0.8
glowFrame.BorderSizePixel = 0
glowFrame.ZIndex = mainFrame.ZIndex - 1
glowFrame.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 25)
glowCorner.Parent = glowFrame

local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 70)
headerFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = headerFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
}
headerGradient.Rotation = 45
headerGradient.Parent = headerFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 300, 0, 40)
titleLabel.Position = UDim2.new(0, 20, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ANOS EXPLOIT"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextStrokeTransparency = 0.5
titleLabel.Parent = headerFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 20)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = headerFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 15)
minCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 20)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 15)
closeCorner.Parent = closeBtn

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 50)
tabFrame.Position = UDim2.new(0, 10, 0, 80)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabFrame

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 140)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 6
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 150)
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentFrame

local function createTab(name, id)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 100, 1, 0)
    tab.BackgroundColor3 = id == currentTab and Color3.fromRGB(255, 0, 150) or Color3.fromRGB(50, 50, 60)
    tab.Text = name
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.TextSize = 12
    tab.Font = Enum.Font.GothamBold
    tab.BorderSizePixel = 0
    tab.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tab
    
    return tab
end

local movementTab = createTab("MOVEMENT", "movement")
local visualTab = createTab("VISUAL", "visual")
local teleportTab = createTab("TELEPORT", "teleport")
local miscTab = createTab("MISC", "misc")

local buttonStates = {}

local function createButton(text, color, id, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.new(1, 1, 1)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.8
    btnStroke.Parent = btn
    
    buttonStates[id] = {
        button = btn,
        defaultColor = color,
        activeColor = Color3.fromRGB(40, 167, 69),
        callback = callback
    }
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, -5, 0, 55)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 50)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -15, 0, 45)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 50)}):Play()
        
        if callback then
            callback(btn)
        end
    end)
    
    return btn
end

local function updateButton(id, isActive, text)
    if not buttonStates[id] then return end
    
    local btnData = buttonStates[id]
    btnData.button.Text = text
    btnData.button.BackgroundColor3 = isActive and btnData.activeColor or btnData.defaultColor
end

local function createSlider(title, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BorderSizePixel = 0
    frame.Parent = contentFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. default
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 25)
    sliderBg.Position = UDim2.new(0, 10, 0, 40)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 12)
    sliderCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 12)
    fillCorner.Parent = sliderFill
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 25, 0, 25)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -12.5, 0.5, -12.5)
    sliderBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderBtn.Text = ""
    sliderBtn.BorderSizePixel = 0
    sliderBtn.Parent = sliderBg
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12.5)
    btnCorner.Parent = sliderBtn
    
    local dragging = false
    local currentValue = default
    
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.Heartbeat:Connect(function()
        if dragging then
            local mouse = UserInputService:GetMouseLocation()
            local relativePos = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * relativePos)
            
            sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
            sliderBtn.Position = UDim2.new(relativePos, -12.5, 0.5, -12.5)
            label.Text = title .. ": " .. currentValue
            
            if callback then callback(currentValue) end
        end
    end)
    
    return frame
end

local function createPlayerList()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BorderSizePixel = 0
    frame.Parent = contentFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "TELEPORT TO PLAYERS"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -40)
    scrollFrame.Position = UDim2.new(0, 5, 0, 35)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 150)
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
                local playerBtn = Instance.new("TextButton")
                playerBtn.Size = UDim2.new(1, -10, 0, 35)
                playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                playerBtn.Text = otherPlayer.Name
                playerBtn.TextColor3 = Color3.new(1, 1, 1)
                playerBtn.TextSize = 12
                playerBtn.Font = Enum.Font.Gotham
                playerBtn.BorderSizePixel = 0
                playerBtn.Parent = scrollFrame
                
                local playerCorner = Instance.new("UICorner")
                playerCorner.CornerRadius = UDim.new(0, 8)
                playerCorner.Parent = playerBtn
                
                playerBtn.MouseEnter:Connect(function()
                    TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 150)}):Play()
                end)
                
                playerBtn.MouseLeave:Connect(function()
                    TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
                end)
                
                playerBtn.MouseButton1Click:Connect(function()
                    if otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if rootPart then
                            rootPart.CFrame = otherPlayer.Character.HumanoidRootPart.CFrame
                        end
                    end
                end)
                
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

local function switchTab(tabName)
    currentTab = tabName
    
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, tab in pairs(tabFrame:GetChildren()) do
        if tab:IsA("TextButton") then
            tab.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        end
    end
    
    if tabName == "movement" then
        movementTab.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        
        createButton("SPEED HACK", Color3.fromRGB(40, 120, 83), "speed", function()
            states.speed = not states.speed
            if states.speed then
                if humanoid then
                    humanoid.WalkSpeed = settings.walkSpeed
                end
            else
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
            updateButton("speed", states.speed, states.speed and "DISABLE SPEED" or "SPEED HACK")
        end)
        
        createSlider("Walk Speed", 16, 200, 50, function(value)
            settings.walkSpeed = value
            if states.speed and humanoid then
                humanoid.WalkSpeed = value
            end
        end)
        
        createButton("FLY HACK", Color3.fromRGB(13, 110, 253), "fly", function()
            states.fly = not states.fly
            if states.fly then
                setupFly()
            else
                if flyBodyVelocity then
                    flyBodyVelocity:Destroy()
                    flyBodyVelocity = nil
                end
                for i = #connections, 1, -1 do
                    if connections[i] and connections[i].Name == "FlyConnection" then
                        connections[i].Connection:Disconnect()
                        table.remove(connections, i)
                    end
                end
                local movementFrame = screenGui:FindFirstChild("MovementFrame")
                if movementFrame then
                    movementFrame:Destroy()
                end
            end
            updateButton("fly", states.fly, states.fly and "DISABLE FLY" or "FLY HACK")
        end)
        
        createSlider("Fly Speed", 16, 200, 50, function(value)
            settings.flySpeed = value
        end)
        
        createButton("NOCLIP HACK", Color3.fromRGB(220, 53, 69), "noclip", function()
            states.noclip = not states.noclip
            if states.noclip then
                setupNoclip()
            else
                for i = #connections, 1, -1 do
                    if connections[i] and connections[i].Name == "NoclipConnection" then
                        connections[i].Connection:Disconnect()
                        table.remove(connections, i)
                    end
                end
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
            updateButton("noclip", states.noclip, states.noclip and "DISABLE NOCLIP" or "NOCLIP HACK")
        end)
        
        createButton("INFINITE JUMP", Color3.fromRGB(108, 117, 125), "jump", function()
            if humanoid then
                humanoid.JumpPower = settings.jumpPower
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        
    elseif tabName == "visual" then
        visualTab.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        
        createButton("FULLBRIGHT", Color3.fromRGB(255, 193, 7), "fullbright", function()
            states.fullbright = not states.fullbright
            if states.fullbright then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
                Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            else
                Lighting.Brightness = 1
                Lighting.ClockTime = 14
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = true
                Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
            end
            updateButton("fullbright", states.fullbright, states.fullbright and "DISABLE FULLBRIGHT" or "FULLBRIGHT")
        end)
        
        createButton("ESP PLAYERS", Color3.fromRGB(0, 123, 255), "esp", function()
            for _, otherPlayer in pairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local highlight = otherPlayer.Character:FindFirstChild("ESPHighlight")
                    if highlight then
                        highlight:Destroy()
                    else
                        local esp = Instance.new("Highlight")
                        esp.Name = "ESPHighlight"
                        esp.Adornee = otherPlayer.Character
                        esp.FillColor = Color3.fromRGB(255, 0, 150)
                        esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                        esp.FillTransparency = 0.5
                        esp.OutlineTransparency = 0
                        esp.Parent = otherPlayer.Character
                    end
                end
            end
        end)
        
        createButton("X-RAY VISION", Color3.fromRGB(220, 53, 69), "xray", function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name ~= "Terrain" then
                    if obj.Transparency < 1 then
                        obj.Transparency = obj.Transparency == 0.5 and 0 or 0.5
                    end
                end
            end
        end)
        
        createButton("REMOVE FOG", Color3.fromRGB(40, 167, 69), "fog", function()
            Lighting.FogStart = 0
            Lighting.FogEnd = math.huge
        end)
        
    elseif tabName == "teleport" then
        teleportTab.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        
        createButton("SAVE CHECKPOINT", Color3.fromRGB(40, 167, 69), "save", function()
            if rootPart then
                savedCheckpoint = rootPart.CFrame
            end
        end)
        
        createButton("LOAD CHECKPOINT", Color3.fromRGB(0, 123, 255), "load", function()
            if savedCheckpoint and rootPart then
                rootPart.CFrame = savedCheckpoint
            end
        end)
        
        createButton("TELEPORT TO SPAWN", Color3.fromRGB(108, 117, 125), "spawn", function()
            if rootPart then
                rootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end)
        
        createPlayerList()
        
    elseif tabName == "misc" then
        miscTab.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
        
        createButton("ANTI-KICK", Color3.fromRGB(220, 53, 69), "antikick", function()
            states.antikick = not states.antikick
            if states.antikick then
                local mt = getrawmetatable(game)
                local oldNamecall = mt.__namecall
                setreadonly(mt, false)
                mt.__namecall = function(self, ...)
                    local method = getnamecallmethod()
                    if method == "Kick" then
                        return
                    end
                    return oldNamecall(self, ...)
                end
                setreadonly(mt, true)
            end
            updateButton("antikick", states.antikick, states.antikick and "DISABLE ANTI-KICK" or "ANTI-KICK")
        end)
        
        createButton("RESET CHARACTER", Color3.fromRGB(255, 69, 58), "reset", function()
            if humanoid then
                humanoid.Health = 0
            end
        end)
        
        createButton("REJOIN SERVER", Color3.fromRGB(108, 117, 125), "rejoin", function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end)
        
        createButton("COPY GAME LINK", Color3.fromRGB(0, 123, 255), "copy", function()
            setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
        end)
        
        createButton("SERVER HOP", Color3.fromRGB(255, 193, 7), "hop", function()
            local Http = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local Api = "https://games.roblox.com/v1/games/"
            
            local _place = game.PlaceId
            local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
            
            function ListServers(cursor)
                local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
                return Http:JSONDecode(Raw)
            end
            
            local Server, Next; repeat
                local Servers = ListServers(Next)
                Server = Servers.data[1]
                Next = Servers.nextPageCursor
            until Server
            
            TeleportService:TeleportToPlaceInstance(_place, Server.id, player)
        end)
    end
end

local function setupButtons()
    minimizeBtn.MouseButton1Click:Connect(function()
        local isMinimized = mainFrame.Size.Y.Offset <= 70
        if isMinimized then
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 600)}):Play()
            minimizeBtn.Text = "—"
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 70)}):Play()
            minimizeBtn.Text = "+"
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        for _, connection in pairs(connections) do
            if connection.Connection then
                connection.Connection:Disconnect()
            end
        end
        
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
        end
        
        if states.noclip and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        if states.speed and humanoid then
            humanoid.WalkSpeed = 16
        end
        
        screenGui:Destroy()
    end)
    
    movementTab.MouseButton1Click:Connect(function() switchTab("movement") end)
    visualTab.MouseButton1Click:Connect(function() switchTab("visual") end)
    teleportTab.MouseButton1Click:Connect(function() switchTab("teleport") end)
    miscTab.MouseButton1Click:Connect(function() switchTab("misc") end)
end

local function initialize()
    player.CharacterAdded:Connect(setupCharacter)
    if player.Character then
        setupCharacter()
    end
    
    setupButtons()
    
    task.spawn(function()
        loadingAnimation()
        switchTab("movement")
        
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -250, 0.5, -300)
        }):Play()
    end)
end

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 80, 0, 80)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
toggleBtn.Text = "ANOS"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.ZIndex = 999999
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 40)
toggleCorner.Parent = toggleBtn

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
}
toggleGradient.Rotation = 45
toggleGradient.Parent = toggleBtn

local toggleGlow = Instance.new("Frame")
toggleGlow.Size = UDim2.new(1, 10, 1, 10)
toggleGlow.Position = UDim2.new(0, -5, 0, -5)
toggleGlow.BackgroundColor3 = Color3.fromRGB(255, 0, 150)
toggleGlow.BackgroundTransparency = 0.7
toggleGlow.BorderSizePixel = 0
toggleGlow.ZIndex = toggleBtn.ZIndex - 1
toggleGlow.Parent = toggleBtn

local toggleGlowCorner = Instance.new("UICorner")
toggleGlowCorner.CornerRadius = UDim.new(0, 45)
toggleGlowCorner.Parent = toggleGlow

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    TweenService:Create(toggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 70, 0, 70)}):Play()
    task.wait(0.1)
    TweenService:Create(toggleBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 80, 0, 80)}):Play()
end)

local draggingToggle = false
local dragStart = nil
local startPos = nil

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStart = input.Position
        startPos = toggleBtn.Position
    end
end)

toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingToggle then
            local delta = input.Position - dragStart
            toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

toggleBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = false
    end
end)

initialize()