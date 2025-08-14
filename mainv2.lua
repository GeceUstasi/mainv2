-- ExploitFrame UI Library - Complete Framework
-- Usage: local ExploitFrame = loadstring(game:HttpGet("..."))()

local ExploitFrame = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Key System Variables
local KeyValidated = false
local MainGUI = nil

-- Key System
function ExploitFrame:CreateKeySystem(config)
    local keyConfig = {
        Title = config.Title or "Key System",
        Subtitle = config.Subtitle or "Enter your key to access",
        KeyNote = config.KeyNote or "Get key from our Discord!",
        ValidKey = config.Key or "ExploitFrameKey2024",
        SaveKey = config.SaveKey or false,
        FileName = config.FileName or "ExploitFrameKey",
        Callback = config.Callback or function() end
    }
    
    -- Create Key GUI
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "ExploitFrameKeySystem"
    keyGui.ResetOnSpawn = false
    keyGui.Parent = playerGui
    
    -- Background blur
    local keyBg = Instance.new("Frame")
    keyBg.Size = UDim2.new(1, 0, 1, 0)
    keyBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyBg.BackgroundTransparency = 0.3
    keyBg.BorderSizePixel = 0
    keyBg.Parent = keyGui
    
    -- Key Frame
    local keyFrame = Instance.new("Frame")
    keyFrame.Size = UDim2.new(0, 450, 0, 300)
    keyFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    keyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    keyFrame.BorderSizePixel = 2
    keyFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
    keyFrame.Parent = keyBg
    
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 10)
    keyCorner.Parent = keyFrame
    
    local keyStroke = Instance.new("UIStroke")
    keyStroke.Color = Color3.fromRGB(0, 255, 150)
    keyStroke.Thickness = 2
    keyStroke.Transparency = 0.5
    keyStroke.Parent = keyFrame
    
    -- Animated border
    spawn(function()
        while keyFrame.Parent do
            for i = 0, 360, 3 do
                if keyFrame.Parent then
                    local hue = i / 360
                    local color = Color3.fromHSV(hue, 0.8, 1)
                    keyStroke.Color = color
                    keyFrame.BorderColor3 = color
                    wait(0.05)
                else
                    break
                end
            end
        end
    end)
    
    -- Title
    local keyTitle = Instance.new("TextLabel")
    keyTitle.Size = UDim2.new(1, -40, 0, 50)
    keyTitle.Position = UDim2.new(0, 20, 0, 20)
    keyTitle.BackgroundTransparency = 1
    keyTitle.Text = keyConfig.Title
    keyTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
    keyTitle.TextSize = 24
    keyTitle.Font = Enum.Font.Code
    keyTitle.TextXAlignment = Enum.TextXAlignment.Center
    keyTitle.Parent = keyFrame
    
    -- Subtitle
    local keySubtitle = Instance.new("TextLabel")
    keySubtitle.Size = UDim2.new(1, -40, 0, 30)
    keySubtitle.Position = UDim2.new(0, 20, 0, 70)
    keySubtitle.BackgroundTransparency = 1
    keySubtitle.Text = keyConfig.Subtitle
    keySubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    keySubtitle.TextSize = 16
    keySubtitle.Font = Enum.Font.Code
    keySubtitle.TextXAlignment = Enum.TextXAlignment.Center
    keySubtitle.Parent = keyFrame
    
    -- Key Input
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -60, 0, 40)
    keyInput.Position = UDim2.new(0, 30, 0, 120)
    keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    keyInput.BorderSizePixel = 1
    keyInput.BorderColor3 = Color3.fromRGB(0, 255, 150)
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter your key here..."
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyInput.TextSize = 16
    keyInput.Font = Enum.Font.Code
    keyInput.TextXAlignment = Enum.TextXAlignment.Center
    keyInput.Parent = keyFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = keyInput
    
    -- Submit Button
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(0, 150, 0, 35)
    submitBtn.Position = UDim2.new(0.5, -75, 0, 180)
    submitBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    submitBtn.BorderSizePixel = 0
    submitBtn.Text = "SUBMIT KEY"
    submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitBtn.TextSize = 14
    submitBtn.Font = Enum.Font.Code
    submitBtn.Parent = keyFrame
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 6)
    submitCorner.Parent = submitBtn
    
    -- Key Note
    local keyNote = Instance.new("TextLabel")
    keyNote.Size = UDim2.new(1, -40, 0, 40)
    keyNote.Position = UDim2.new(0, 20, 0, 230)
    keyNote.BackgroundTransparency = 1
    keyNote.Text = keyConfig.KeyNote
    keyNote.TextColor3 = Color3.fromRGB(255, 200, 100)
    keyNote.TextSize = 12
    keyNote.Font = Enum.Font.Code
    keyNote.TextXAlignment = Enum.TextXAlignment.Center
    keyNote.TextWrapped = true
    keyNote.Parent = keyFrame
    
    -- Status Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -40, 0, 20)
    statusLabel.Position = UDim2.new(0, 20, 0, 270)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextSize = 12
    statusLabel.Font = Enum.Font.Code
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = keyFrame
    
    -- Key validation
    local function validateKey()
        local enteredKey = keyInput.Text
        if enteredKey == keyConfig.ValidKey then
            statusLabel.Text = "[SUCCESS] Key validated! Loading..."
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            KeyValidated = true
            
            if keyConfig.SaveKey then
                -- Save key logic here
                print("[FRAMEWORK] Key saved!")
            end
            
            wait(1)
            keyGui:Destroy()
            keyConfig.Callback()
        else
            statusLabel.Text = "[ERROR] Invalid key! Try again."
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            keyInput.Text = ""
        end
    end
    
    submitBtn.MouseButton1Click:Connect(validateKey)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateKey()
        end
    end)
    
    return keyGui
end

-- Main Framework
function ExploitFrame:CreateWindow(config)
    if not KeyValidated then
        warn("[ExploitFrame] Key system must be validated first!")
        return
    end
    
    local windowConfig = {
        Name = config.Name or "ExploitFrame",
        LoadingTitle = config.LoadingTitle or "ExploitFrame Interface",
        LoadingSubtitle = config.LoadingSubtitle or "by ExploitFrame Team",
        ConfigurationSaving = {
            Enabled = config.ConfigurationSaving and config.ConfigurationSaving.Enabled or false,
            FolderName = config.ConfigurationSaving and config.ConfigurationSaving.FolderName or "ExploitFrame",
            FileName = config.ConfigurationSaving and config.ConfigurationSaving.FileName or "config"
        },
        Discord = {
            Enabled = config.Discord and config.Discord.Enabled or false,
            Invite = config.Discord and config.Discord.Invite or "discord.gg/exploitframe",
            RememberJoins = config.Discord and config.Discord.RememberJoins or true
        },
        KeySystem = false -- Already handled
    }
    
    -- Loading Screen
    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "ExploitFrameLoading"
    loadingGui.ResetOnSpawn = false
    loadingGui.Parent = playerGui
    
    local loadingBg = Instance.new("Frame")
    loadingBg.Size = UDim2.new(1, 0, 1, 0)
    loadingBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loadingBg.BackgroundTransparency = 0.2
    loadingBg.BorderSizePixel = 0
    loadingBg.Parent = loadingGui
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 400, 0, 250)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    loadingFrame.BorderSizePixel = 2
    loadingFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
    loadingFrame.Parent = loadingBg
    
    local loadingCorner = Instance.new("UICorner")
    loadingCorner.CornerRadius = UDim.new(0, 10)
    loadingCorner.Parent = loadingFrame
    
    local loadingTitle = Instance.new("TextLabel")
    loadingTitle.Size = UDim2.new(1, -40, 0, 50)
    loadingTitle.Position = UDim2.new(0, 20, 0, 30)
    loadingTitle.BackgroundTransparency = 1
    loadingTitle.Text = windowConfig.LoadingTitle
    loadingTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
    loadingTitle.TextSize = 24
    loadingTitle.Font = Enum.Font.Code
    loadingTitle.TextXAlignment = Enum.TextXAlignment.Center
    loadingTitle.Parent = loadingFrame
    
    local loadingSubtitle = Instance.new("TextLabel")
    loadingSubtitle.Size = UDim2.new(1, -40, 0, 30)
    loadingSubtitle.Position = UDim2.new(0, 20, 0, 80)
    loadingSubtitle.BackgroundTransparency = 1
    loadingSubtitle.Text = windowConfig.LoadingSubtitle
    loadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingSubtitle.TextSize = 16
    loadingSubtitle.Font = Enum.Font.Code
    loadingSubtitle.TextXAlignment = Enum.TextXAlignment.Center
    loadingSubtitle.Parent = loadingFrame
    
    -- Loading bar
    local loadingBarBg = Instance.new("Frame")
    loadingBarBg.Size = UDim2.new(1, -60, 0, 8)
    loadingBarBg.Position = UDim2.new(0, 30, 0, 140)
    loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    loadingBarBg.BorderSizePixel = 0
    loadingBarBg.Parent = loadingFrame
    
    local loadingBarCorner = Instance.new("UICorner")
    loadingBarCorner.CornerRadius = UDim.new(0, 4)
    loadingBarCorner.Parent = loadingBarBg
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = loadingBarBg
    
    local loadingBarFillCorner = Instance.new("UICorner")
    loadingBarFillCorner.CornerRadius = UDim.new(0, 4)
    loadingBarFillCorner.Parent = loadingBar
    
    local loadingStatus = Instance.new("TextLabel")
    loadingStatus.Size = UDim2.new(1, -40, 0, 30)
    loadingStatus.Position = UDim2.new(0, 20, 0, 160)
    loadingStatus.BackgroundTransparency = 1
    loadingStatus.Text = "Initializing..."
    loadingStatus.TextColor3 = Color3.fromRGB(150, 150, 150)
    loadingStatus.TextSize = 12
    loadingStatus.Font = Enum.Font.Code
    loadingStatus.TextXAlignment = Enum.TextXAlignment.Center
    loadingStatus.Parent = loadingFrame
    
    -- Loading animation
    local loadingSteps = {
        {text = "Loading framework...", progress = 0.2},
        {text = "Setting up interface...", progress = 0.4},
        {text = "Initializing components...", progress = 0.6},
        {text = "Applying configurations...", progress = 0.8},
        {text = "Ready to use!", progress = 1.0}
    }
    
    spawn(function()
        for _, step in ipairs(loadingSteps) do
            loadingStatus.Text = step.text
            TweenService:Create(loadingBar, TweenInfo.new(0.5), {
                Size = UDim2.new(step.progress, 0, 1, 0)
            }):Play()
            wait(0.8)
        end
        wait(0.5)
        loadingGui:Destroy()
    end)
    
    -- Create main window after loading
    wait(4)
    
    -- Main GUI
    MainGUI = Instance.new("ScreenGui")
    MainGUI.Name = "ExploitFrameMain"
    MainGUI.ResetOnSpawn = false
    MainGUI.Parent = playerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 750, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -375, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
    mainFrame.Visible = false
    mainFrame.Parent = MainGUI
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(0, 255, 150)
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.3
    mainStroke.Parent = mainFrame
    
    -- Animated glow
    spawn(function()
        while mainFrame.Parent do
            for i = 0, 360, 3 do
                if mainFrame.Parent then
                    local hue = i / 360
                    local color = Color3.fromHSV(hue, 0.8, 1)
                    mainStroke.Color = color
                    mainFrame.BorderColor3 = color
                    wait(0.03)
                else
                    break
                end
            end
        end
    end)
    
    -- Draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = ">>> " .. windowConfig.Name .. " v1.0 <<<"
    titleText.TextColor3 = Color3.fromRGB(0, 255, 150)
    titleText.TextSize = 18
    titleText.Font = Enum.Font.Code
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 25)
    closeButton.Position = UDim2.new(1, -35, 0, 7.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 25)
    minimizeButton.Position = UDim2.new(1, -70, 0, 7.5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "_"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 14
    minimizeButton.Font = Enum.Font.SourceSansBold
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeButton
    
    -- Tab container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 200, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local tabMask = Instance.new("Frame")
    tabMask.Size = UDim2.new(1, 0, 1, 0)
    tabMask.BackgroundTransparency = 1
    tabMask.ClipsDescendants = true
    tabMask.Parent = tabContainer
    
    local tabBg = Instance.new("Frame")
    tabBg.Size = UDim2.new(1, 0, 1, 8)
    tabBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    tabBg.BorderSizePixel = 0
    tabBg.Parent = tabMask
    
    local tabBgCorner = Instance.new("UICorner")
    tabBgCorner.CornerRadius = UDim.new(0, 8)
    tabBgCorner.Parent = tabBg
    
    local tabScrollFrame = Instance.new("ScrollingFrame")
    tabScrollFrame.Size = UDim2.new(1, -10, 1, -10)
    tabScrollFrame.Position = UDim2.new(0, 5, 0, 5)
    tabScrollFrame.BackgroundTransparency = 1
    tabScrollFrame.BorderSizePixel = 0
    tabScrollFrame.ScrollBarThickness = 4
    tabScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
    tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScrollFrame.Parent = tabContainer
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabScrollFrame
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -200, 1, -40)
    contentFrame.Position = UDim2.new(0, 200, 0, 40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local contentMask = Instance.new("Frame")
    contentMask.Size = UDim2.new(1, 0, 1, 0)
    contentMask.BackgroundTransparency = 1
    contentMask.ClipsDescendants = true
    contentMask.Parent = contentFrame
    
    local contentBg = Instance.new("Frame")
    contentBg.Size = UDim2.new(1, 8, 1, 8)
    contentBg.Position = UDim2.new(0, -8, 0, 0)
    contentBg.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    contentBg.BorderSizePixel = 0
    contentBg.Parent = contentMask
    
    local contentBgCorner = Instance.new("UICorner")
    contentBgCorner.CornerRadius = UDim.new(0, 8)
    contentBgCorner.Parent = contentBg
    
    -- Content title
    local contentTitle = Instance.new("TextLabel")
    contentTitle.Size = UDim2.new(1, -20, 0, 40)
    contentTitle.Position = UDim2.new(0, 10, 0, 10)
    contentTitle.BackgroundTransparency = 1
    contentTitle.Text = "[FRAMEWORK] >> WELCOME"
    contentTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
    contentTitle.TextSize = 20
    contentTitle.Font = Enum.Font.Code
    contentTitle.TextXAlignment = Enum.TextXAlignment.Left
    contentTitle.Parent = contentFrame
    
    -- Content container
    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Size = UDim2.new(1, -20, 1, -60)
    contentContainer.Position = UDim2.new(0, 10, 0, 50)
    contentContainer.BackgroundTransparency = 1
    contentContainer.BorderSizePixel = 0
    contentContainer.ScrollBarThickness = 6
    contentContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentContainer.Parent = contentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = contentContainer
    
    -- Toggle button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 120, 0, 40)
    toggleButton.Position = UDim2.new(0, 20, 0, 20)
    toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggleButton.BorderSizePixel = 1
    toggleButton.BorderColor3 = Color3.fromRGB(0, 255, 150)
    toggleButton.Text = windowConfig.Name
    toggleButton.TextColor3 = Color3.fromRGB(0, 255, 150)
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.Code
    toggleButton.Parent = MainGUI
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    -- Variables
    local activeTab = nil
    local tabs = {}
    
    -- Window object
    local window = {
        Frame = mainFrame,
        ContentContainer = contentContainer,
        ContentTitle = contentTitle,
        TabContainer = tabScrollFrame,
        ToggleButton = toggleButton
    }
    
    -- Toggle functionality
    toggleButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        if mainFrame.Visible then
            toggleButton.Text = "HIDE " .. windowConfig.Name
            toggleButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        else
            toggleButton.Text = windowConfig.Name
            toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        toggleButton.Text = windowConfig.Name
        toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        toggleButton.Text = windowConfig.Name
        toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end)
    
    -- ESC key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Escape and mainFrame.Visible then
            mainFrame.Visible = false
            toggleButton.Text = windowConfig.Name
            toggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        end
    end)
    
    -- Canvas size updates
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Window methods
    function window:CreateTab(config)
        local tabConfig = {
            Name = config.Name or "Tab",
            Image = config.Image or ">>",
            Visible = config.Visible ~= false
        }
        
        -- Tab button
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(1, 0, 0, 45)
        tab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        tab.BorderSizePixel = 1
        tab.BorderColor3 = Color3.fromRGB(50, 50, 70)
        tab.Text = ""
        tab.Visible = tabConfig.Visible
        tab.Parent = tabScrollFrame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tab
        
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Size = UDim2.new(0, 35, 1, 0)
        tabIcon.Position = UDim2.new(0, 5, 0, 0)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tabConfig.Image
        tabIcon.TextColor3 = Color3.fromRGB(0, 255, 150)
        tabIcon.TextSize = 18
        tabIcon.Font = Enum.Font.Code
        tabIcon.Parent = tab
        
        local tabText = Instance.new("TextLabel")
        tabText.Size = UDim2.new(1, -45, 1, 0)
        tabText.Position = UDim2.new(0, 40, 0, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = tabConfig.Name
        tabText.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabText.TextSize = 14
        tabText.Font = Enum.Font.Code
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        tabText.Parent = tab
        
        -- Tab content container
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentContainer
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 8)
        tabContentLayout.Parent = tabContent
        
        -- Tab object
        local tabObj = {
            Button = tab,
            Content = tabContent,
            ContentLayout = tabContentLayout,
            Name = tabConfig.Name,
            Sections = {}
        }
        
        tabs[#tabs + 1] = tabObj
        
        -- Tab hover effects
        tab.MouseEnter:Connect(function()
            if tab ~= activeTab then
                TweenService:Create(tab, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                }):Play()
            end
        end)
        
        tab.MouseLeave:Connect(function()
            if tab ~= activeTab then
                TweenService:Create(tab, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                }):Play()
            end
        end)
        
        -- Tab click
        tab.MouseButton1Click:Connect(function()
            -- Deactivate old tab
            if activeTab then
                activeTab.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                activeTab.BorderColor3 = Color3.fromRGB(50, 50, 70)
                for _, t in pairs(tabs) do
                    if t.Button == activeTab then
                        t.Content.Visible = false
                        break
                    end
                end
            end
            
            -- Activate new tab
            activeTab = tab
            tab.BackgroundColor3 = Color3.fromRGB(0, 60, 30)
            tab.BorderColor3 = Color3.fromRGB(0, 255, 150)
            tabContent.Visible = true
            
            contentTitle.Text = "[" .. string.upper(tabConfig.Name) .. "] >> " .. string.upper(tabConfig.Name) .. " PANEL"
        end)
        
        -- Tab methods
        function tabObj:CreateSection(config)
            local sectionConfig = {
                Name = config.Name or "Section",
                Side = config.Side or "Auto" -- Left, Right, Auto
            }
            
            local section = Instance.new("Frame")
            section.Size = UDim2.new(1, 0, 0, 0) -- Auto size
            section.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            section.BorderSizePixel = 1
            section.BorderColor3 = Color3.fromRGB(60, 60, 80)
            section.Parent = tabContent
            
            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 6)
            sectionCorner.Parent = section
            
            -- Section header
            local sectionHeader = Instance.new("Frame")
            sectionHeader.Size = UDim2.new(1, 0, 0, 35)
            sectionHeader.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            sectionHeader.BorderSizePixel = 0
            sectionHeader.Parent = section
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 6)
            headerCorner.Parent = sectionHeader
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Size = UDim2.new(1, -20, 1, 0)
            sectionTitle.Position = UDim2.new(0, 10, 0, 0)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = "[SECTION] >> " .. sectionConfig.Name
            sectionTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
            sectionTitle.TextSize = 14
            sectionTitle.Font = Enum.Font.Code
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = sectionHeader
            
            -- Section content
            local sectionContent = Instance.new("Frame")
            sectionContent.Size = UDim2.new(1, -10, 1, -40)
            sectionContent.Position = UDim2.new(0, 5, 0, 35)
            sectionContent.BackgroundTransparency = 1
            sectionContent.Parent = section
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 5)
            sectionLayout.Parent = sectionContent
            
            -- Auto-resize section
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                section.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 45)
            end)
            
            local sectionObj = {
                Frame = section,
                Content = sectionContent,
                Layout = sectionLayout,
                Name = sectionConfig.Name
            }
            
            tabObj.Sections[#tabObj.Sections + 1] = sectionObj
            
            -- Section methods
            function sectionObj:CreateLabel(config)
                local labelConfig = {
                    Text = config.Text or "Label",
                    TextSize = config.TextSize or 14,
                    TextColor = config.TextColor or Color3.fromRGB(255, 255, 255)
                }
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 25)
                label.BackgroundTransparency = 1
                label.Text = labelConfig.Text
                label.TextColor3 = labelConfig.TextColor
                label.TextSize = labelConfig.TextSize
                label.Font = Enum.Font.Code
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextWrapped = true
                label.Parent = sectionContent
                
                return {
                    Frame = label,
                    SetText = function(self, text)
                        label.Text = text
                    end,
                    SetColor = function(self, color)
                        label.TextColor3 = color
                    end
                }
            end
            
            function sectionObj:CreateParagraph(config)
                local paragraphConfig = {
                    Title = config.Title or "Paragraph",
                    Content = config.Content or "Content text here..."
                }
                
                local paragraphFrame = Instance.new("Frame")
                paragraphFrame.Size = UDim2.new(1, 0, 0, 50)
                paragraphFrame.BackgroundTransparency = 1
                paragraphFrame.Parent = sectionContent
                
                local titleLabel = Instance.new("TextLabel")
                titleLabel.Size = UDim2.new(1, 0, 0, 20)
                titleLabel.BackgroundTransparency = 1
                titleLabel.Text = paragraphConfig.Title
                titleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                titleLabel.TextSize = 16
                titleLabel.Font = Enum.Font.Code
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Parent = paragraphFrame
                
                local contentLabel = Instance.new("TextLabel")
                contentLabel.Size = UDim2.new(1, 0, 1, -20)
                contentLabel.Position = UDim2.new(0, 0, 0, 20)
                contentLabel.BackgroundTransparency = 1
                contentLabel.Text = paragraphConfig.Content
                contentLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                contentLabel.TextSize = 12
                contentLabel.Font = Enum.Font.Code
                contentLabel.TextXAlignment = Enum.TextXAlignment.Left
                contentLabel.TextYAlignment = Enum.TextYAlignment.Top
                contentLabel.TextWrapped = true
                contentLabel.Parent = paragraphFrame
                
                return {
                    Frame = paragraphFrame,
                    SetTitle = function(self, title)
                        titleLabel.Text = title
                    end,
                    SetContent = function(self, content)
                        contentLabel.Text = content
                    end
                }
            end
            
            function sectionObj:CreateDivider(config)
                local dividerConfig = {
                    Text = config and config.Text or nil
                }
                
                local divider = Instance.new("Frame")
                divider.Size = UDim2.new(1, 0, 0, dividerConfig.Text and 25 or 10)
                divider.BackgroundTransparency = 1
                divider.Parent = sectionContent
                
                if dividerConfig.Text then
                    local dividerText = Instance.new("TextLabel")
                    dividerText.Size = UDim2.new(1, 0, 0, 15)
                    dividerText.Position = UDim2.new(0, 0, 0, 5)
                    dividerText.BackgroundTransparency = 1
                    dividerText.Text = dividerConfig.Text
                    dividerText.TextColor3 = Color3.fromRGB(150, 150, 150)
                    dividerText.TextSize = 12
                    dividerText.Font = Enum.Font.Code
                    dividerText.TextXAlignment = Enum.TextXAlignment.Center
                    dividerText.Parent = divider
                end
                
                local dividerLine = Instance.new("Frame")
                dividerLine.Size = UDim2.new(1, -20, 0, 1)
                dividerLine.Position = UDim2.new(0, 10, 0.5, 0)
                dividerLine.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                dividerLine.BorderSizePixel = 0
                dividerLine.Parent = divider
                
                return {Frame = divider}
            end
            
            function sectionObj:CreateButton(config)
                local buttonConfig = {
                    Name = config.Name or "Button",
                    Callback = config.Callback or function() end
                }
                
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 35)
                button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                button.BorderSizePixel = 0
                button.Text = buttonConfig.Name
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.Font = Enum.Font.Code
                button.Parent = sectionContent
                
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = button
                
                button.MouseEnter:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(60, 180, 60)
                    }):Play()
                end)
                
                button.MouseLeave:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                    }):Play()
                end)
                
                button.MouseButton1Click:Connect(function()
                    button.Text = "Executed!"
                    wait(1)
                    button.Text = buttonConfig.Name
                    buttonConfig.Callback()
                end)
                
                return {
                    Frame = button,
                    SetText = function(self, text)
                        buttonConfig.Name = text
                        button.Text = text
                    end,
                    SetCallback = function(self, callback)
                        buttonConfig.Callback = callback
                    end
                }
            end
            
            function sectionObj:CreateToggle(config)
                local toggleConfig = {
                    Name = config.Name or "Toggle",
                    CurrentValue = config.CurrentValue or false,
                    Flag = config.Flag or nil,
                    Callback = config.Callback or function() end
                }
                
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, 0, 0, 35)
                toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                toggleFrame.BorderSizePixel = 1
                toggleFrame.BorderColor3 = Color3.fromRGB(60, 60, 80)
                toggleFrame.Parent = sectionContent
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 6)
                toggleCorner.Parent = toggleFrame
                
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Size = UDim2.new(1, -60, 1, 0)
                toggleLabel.Position = UDim2.new(0, 10, 0, 0)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = toggleConfig.Name
                toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleLabel.TextSize = 14
                toggleLabel.Font = Enum.Font.Code
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Parent = toggleFrame
                
                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(0, 40, 0, 20)
                toggleButton.Position = UDim2.new(1, -50, 0.5, -10)
                toggleButton.BackgroundColor3 = toggleConfig.CurrentValue and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
                toggleButton.BorderSizePixel = 0
                toggleButton.Text = toggleConfig.CurrentValue and "ON" or "OFF"
                toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleButton.TextSize = 10
                toggleButton.Font = Enum.Font.Code
                toggleButton.Parent = toggleFrame
                
                local toggleBtnCorner = Instance.new("UICorner")
                toggleBtnCorner.CornerRadius = UDim.new(0, 4)
                toggleBtnCorner.Parent = toggleButton
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggleConfig.CurrentValue = not toggleConfig.CurrentValue
                    
                    toggleButton.Text = toggleConfig.CurrentValue and "ON" or "OFF"
                    toggleButton.BackgroundColor3 = toggleConfig.CurrentValue and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
                    toggleFrame.BorderColor3 = toggleConfig.CurrentValue and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(60, 60, 80)
                    
                    toggleConfig.Callback(toggleConfig.CurrentValue)
                end)
                
                return {
                    Frame = toggleFrame,
                    SetValue = function(self, value)
                        toggleConfig.CurrentValue = value
                        toggleButton.Text = value and "ON" or "OFF"
                        toggleButton.BackgroundColor3 = value and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
                        toggleFrame.BorderColor3 = value and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(60, 60, 80)
                    end,
                    GetValue = function(self)
                        return toggleConfig.CurrentValue
                    end
                }
            end
            
            function sectionObj:CreateSlider(config)
                local sliderConfig = {
                    Name = config.Name or "Slider",
                    Range = config.Range or {0, 100},
                    Increment = config.Increment or 1,
                    CurrentValue = config.CurrentValue or config.Range[1],
                    Flag = config.Flag or nil,
                    Callback = config.Callback or function() end
                }
                
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 55)
                sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
                sliderFrame.BorderSizePixel = 1
                sliderFrame.BorderColor3 = Color3.fromRGB(60, 60, 80)
                sliderFrame.Parent = sectionContent
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 6)
                sliderCorner.Parent = sliderFrame
                
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(1, -60, 0, 20)
                sliderLabel.Position = UDim2.new(0, 10, 0, 5)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = sliderConfig.Name
                sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                sliderLabel.TextSize = 14
                sliderLabel.Font = Enum.Font.Code
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Parent = sliderFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 50, 0, 20)
                valueLabel.Position = UDim2.new(1, -55, 0, 5)
                valueLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                valueLabel.BorderSizePixel = 1
                valueLabel.BorderColor3 = Color3.fromRGB(0, 255, 150)
                valueLabel.Text = tostring(sliderConfig.CurrentValue)
                valueLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
                valueLabel.TextSize = 12
                valueLabel.Font = Enum.Font.Code
                valueLabel.Parent = sliderFrame
                
                local valueLabelCorner = Instance.new("UICorner")
                valueLabelCorner.CornerRadius = UDim.new(0, 4)
                valueLabelCorner.Parent = valueLabel
                
                local sliderTrack = Instance.new("Frame")
                sliderTrack.Size = UDim2.new(1, -20, 0, 6)
                sliderTrack.Position = UDim2.new(0, 10, 0, 35)
                sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                sliderTrack.BorderSizePixel = 0
                sliderTrack.Parent = sliderFrame
                
                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(0, 3)
                trackCorner.Parent = sliderTrack
                
                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderTrack
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 3)
                fillCorner.Parent = sliderFill
                
                local sliderHandle = Instance.new("Frame")
                sliderHandle.Size = UDim2.new(0, 12, 0, 12)
                sliderHandle.Position = UDim2.new(0, -6, 0.5, -6)
                sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderHandle.BorderSizePixel = 1
                sliderHandle.BorderColor3 = Color3.fromRGB(0, 255, 150)
                sliderHandle.Parent = sliderTrack
                
                local handleCorner = Instance.new("UICorner")
                handleCorner.CornerRadius = UDim.new(1, 0)
                handleCorner.Parent = sliderHandle
                
                local dragging = false
                
                local function updateSlider(value)
                    local range = sliderConfig.Range[2] - sliderConfig.Range[1]
                    local percentage = (value - sliderConfig.Range[1]) / range
                    percentage = math.clamp(percentage, 0, 1)
                    
                    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    sliderHandle.Position = UDim2.new(percentage, -6, 0.5, -6)
                    valueLabel.Text = tostring(math.floor(value / sliderConfig.Increment) * sliderConfig.Increment)
                    sliderConfig.CurrentValue = value
                    
                    sliderConfig.Callback(value)
                end
                
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = UserInputService:GetMouseLocation()
                        local trackPos = sliderTrack.AbsolutePosition.X
                        local trackSize = sliderTrack.AbsoluteSize.X
                        local percentage = math.clamp((mouse.X - trackPos) / trackSize, 0, 1)
                        local value = sliderConfig.Range[1] + (sliderConfig.Range[2] - sliderConfig.Range[1]) * percentage
                        updateSlider(value)
                    end
                end)
                
                updateSlider(sliderConfig.CurrentValue)
                
                return {
                    Frame = sliderFrame,
                    SetValue = function(self, value)
                        updateSlider(value)
                    end,
                    GetValue = function(self)
                        return sliderConfig.CurrentValue
                    end
                }
            end
            
            return sectionObj
        end
        
        return tabObj
    end
    
    return window
end

-- Show the GUI after everything loads
spawn(function()
    wait(4.5)
    if MainGUI and MainGUI:FindFirstChild("MainFrame") then
        MainGUI.MainFrame.Visible = true
    end
end)

return ExploitFrame

--[[
USAGE EXAMPLE:

-- Load the library
local ExploitFrame = loadstring(game:HttpGet("your-url-here"))()

-- Create key system
ExploitFrame:CreateKeySystem({
    Title = "My Exploit Hub",
    Subtitle = "Premium Access Required",
    KeyNote = "Join our Discord for free key!",
    Key = "MySecretKey123",
    SaveKey = true,
    FileName = "MyExploitKey",
    Callback = function()
        print("Key validated! Loading main GUI...")
        
        -- Create main window
        local Window = ExploitFrame:CreateWindow({
            Name = "My Exploit Hub",
            LoadingTitle = "My Exploit Hub v2.1",
            LoadingSubtitle = "Loading premium features...",
            ConfigurationSaving = {
                Enabled = true,
                FolderName = "MyExploitHub",
                FileName = "config"
            },
            Discord = {
                Enabled = true,
                Invite = "discord.gg/myserver",
                RememberJoins = true
            }
        })
        
        -- Create tabs
        local PlayerTab = Window:CreateTab({
            Name = "Player",
            Image = "👤",
            Visible = true
        })
        
        local VisualTab = Window:CreateTab({
            Name = "Visual", 
            Image = "👁️",
            Visible = true
        })
        
        -- Create sections in tabs
        local MovementSection = PlayerTab:CreateSection({
            Name = "Movement Hacks"
        })
        
        local CombatSection = PlayerTab:CreateSection({
            Name = "Combat Features"
        })
        
        local ESPSection = VisualTab:CreateSection({
            Name = "ESP Settings"
        })
        
        -- Add elements to sections
        MovementSection:CreateLabel({
            Text = "Player movement modifications"
        })
        
        MovementSection:CreateParagraph({
            Title = "Speed Information",
            Content = "Modify your walking speed. Default is 16. Be careful with high values!"
        })
        
        MovementSection:CreateDivider({
            Text = "Speed Controls"
        })
        
        MovementSection:CreateSlider({
            Name = "Walk Speed",
            Range = {1, 500},
            Increment = 1,
            CurrentValue = 16,
            Callback = function(value)
                if game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                end
                print("Speed set to:", value)
            end
        })
        
        MovementSection:CreateToggle({
            Name = "Fly Hack",
            CurrentValue = false,
            Callback = function(value)
                print("Fly hack:", value and "enabled" or "disabled")
                -- Fly hack code here
            end
        })
        
        MovementSection:CreateButton({
            Name = "Reset Character",
            Callback = function()
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                print("Character reset!")
            end
        })
        
        CombatSection:CreateToggle({
            Name = "Infinite Ammo",
            CurrentValue = false,
            Callback = function(value)
                print("Infinite ammo:", value and "enabled" or "disabled")
            end
        })
        
        ESPSection:CreateLabel({
            Text = "Visual enhancement settings"
        })
        
        ESPSection:CreateToggle({
            Name = "Player ESP",
            CurrentValue = false,
            Callback = function(value)
                print("ESP:", value and "enabled" or "disabled")
            end
        })
        
        print("ExploitFrame GUI loaded successfully!")
    end
})
]]
