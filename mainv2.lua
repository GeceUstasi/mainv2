-- MODERN ROBLOX GUI FRAMEWORK - AURELIUS STYLE
-- Gelişmiş, modern tasarımlı GUI Framework

local ModernGUI = {}
ModernGUI.__index = ModernGUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Modern Theme
local ModernTheme = {
    -- Ana renkler (Türkuaz tema)
    Primary = Color3.fromRGB(64, 224, 208),        -- Turquoise
    Secondary = Color3.fromRGB(72, 201, 176),      -- Medium turquoise
    Accent = Color3.fromRGB(26, 188, 156),         -- Emerald
    
    -- Arka plan renkleri
    Background = Color3.fromRGB(23, 23, 23),       -- Dark
    Surface = Color3.fromRGB(35, 35, 35),          -- Darker
    SurfaceLight = Color3.fromRGB(45, 45, 45),     -- Medium dark
    
    -- Metin renkleri
    TextPrimary = Color3.fromRGB(255, 255, 255),   -- White
    TextSecondary = Color3.fromRGB(180, 180, 180), -- Light gray
    TextMuted = Color3.fromRGB(120, 120, 120),     -- Gray
    
    -- Durum renkleri
    Success = Color3.fromRGB(46, 204, 113),        -- Green
    Warning = Color3.fromRGB(241, 196, 15),        -- Yellow
    Error = Color3.fromRGB(231, 76, 60),           -- Red
    Info = Color3.fromRGB(52, 152, 219),           -- Blue
    
    -- Efekt renkleri
    Shadow = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(64, 224, 208),
    Border = Color3.fromRGB(60, 60, 60)
}

-- Animation Settings
local AnimationConfig = {
    Speed = 0.3,
    Style = Enum.EasingStyle.Quart,
    Direction = Enum.EasingDirection.Out,
    HoverSpeed = 0.2,
    ClickSpeed = 0.1
}

-- Framework başlatma
function ModernGUI.new(title)
    local self = setmetatable({}, ModernGUI)
    
    self.Title = title or "Modern GUI"
    self.Notifications = {}
    self.Windows = {}
    self.IsVisible = true
    self.CurrentTab = nil
    
    -- Ana ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "ModernGUI_" .. self.Title
    self.ScreenGui.Parent = PlayerGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Bildirim container
    self:_createNotificationSystem()
    
    return self
end

-- Ana window oluşturma (Aurelius benzeri)
function ModernGUI:createMainWindow()
    local window = Instance.new("Frame")
    window.Name = "MainWindow"
    window.Size = UDim2.new(0, 800, 0, 600)
    window.Position = UDim2.new(0.5, -400, 0.5, -300)
    window.BackgroundColor3 = ModernTheme.Background
    window.BorderSizePixel = 0
    window.Parent = self.ScreenGui
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = window
    
    -- Glow effect
    self:_addGlowEffect(window)
    
    -- Sol sidebar (navigation)
    local sidebar = self:_createSidebar(window)
    
    -- Sağ content area
    local contentArea = self:_createContentArea(window)
    
    -- Top bar (title + controls)
    local topBar = self:_createTopBar(window)
    
    -- Draggable
    self:_makeDraggable(window, topBar)
    
    -- Animation in
    self:_animateWindowIn(window)
    
    local windowObj = {
        Frame = window,
        Sidebar = sidebar,
        Content = contentArea,
        TopBar = topBar,
        Tabs = {},
        CurrentTab = nil
    }
    
    table.insert(self.Windows, windowObj)
    return windowObj
end

-- Sidebar oluşturma
function ModernGUI:_createSidebar(parent)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 220, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = ModernTheme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = parent
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = sidebar
    
    -- Logo/Title area
    local logoArea = Instance.new("Frame")
    logoArea.Size = UDim2.new(1, 0, 0, 80)
    logoArea.BackgroundColor3 = ModernTheme.Primary
    logoArea.BorderSizePixel = 0
    logoArea.Parent = sidebar
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 12)
    logoCorner.Parent = logoArea
    
    -- Logo text
    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, -20, 1, 0)
    logoText.Position = UDim2.new(0, 10, 0, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = self.Title:upper()
    logoText.TextColor3 = ModernTheme.Background
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 18
    logoText.TextXAlignment = Enum.TextXAlignment.Left
    logoText.Parent = logoArea
    
    -- Version label
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 60, 0, 20)
    versionLabel.Position = UDim2.new(1, -70, 0, 5)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v1.0.0"
    versionLabel.TextColor3 = ModernTheme.Background
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextSize = 12
    versionLabel.TextTransparency = 0.3
    versionLabel.Parent = logoArea
    
    -- Navigation container
    local navContainer = Instance.new("ScrollingFrame")
    navContainer.Size = UDim2.new(1, 0, 1, -90)
    navContainer.Position = UDim2.new(0, 0, 0, 85)
    navContainer.BackgroundTransparency = 1
    navContainer.BorderSizePixel = 0
    navContainer.ScrollBarThickness = 0
    navContainer.Parent = sidebar
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 2)
    navLayout.Parent = navContainer
    
    return {
        Frame = sidebar,
        Container = navContainer,
        Layout = navLayout,
        Tabs = {}
    }
end

-- Content area oluşturma
function ModernGUI:_createContentArea(parent)
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -240, 1, -70)
    contentArea.Position = UDim2.new(0, 230, 0, 60)
    contentArea.BackgroundColor3 = ModernTheme.SurfaceLight
    contentArea.BorderSizePixel = 0
    contentArea.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = contentArea
    
    -- Content scroll frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -20)
    scrollFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = ModernTheme.Primary
    scrollFrame.Parent = contentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.Parent = scrollFrame
    
    return {
        Frame = contentArea,
        ScrollFrame = scrollFrame,
        Layout = contentLayout
    }
end

-- Top bar oluşturma
function ModernGUI:_createTopBar(parent)
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundColor3 = ModernTheme.Background
    topBar.BorderSizePixel = 0
    topBar.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = topBar
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -150, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = ""
    titleLabel.TextColor3 = ModernTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    -- Control buttons
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 120, 0, 30)
    controlsFrame.Position = UDim2.new(1, -130, 0.5, -15)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = topBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.Padding = UDim.new(0, 5)
    controlsLayout.Parent = controlsFrame
    
    -- Minimize button
    local minimizeBtn = self:_createControlButton(controlsFrame, "−", ModernTheme.Warning, function()
        self:_minimizeWindow(parent)
    end)
    
    -- Close button
    local closeBtn = self:_createControlButton(controlsFrame, "×", ModernTheme.Error, function()
        self:_closeWindow(parent)
    end)
    
    return {
        Frame = topBar,
        Title = titleLabel,
        Controls = controlsFrame
    }
end

-- Tab oluşturma (sidebar'da)
function ModernGUI:createTab(window, options)
    options = options or {}
    local tabData = {
        Title = options.Title or "Tab",
        Icon = options.Icon or "📄",
        Active = options.Active or false
    }
    
    -- Tab button (sidebar'da)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -10, 0, 45)
    tabButton.Position = UDim2.new(0, 5, 0, 0)
    tabButton.BackgroundColor3 = tabData.Active and ModernTheme.Primary or Color3.fromRGB(0,0,0)
    tabButton.BackgroundTransparency = tabData.Active and 0 or 1
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.Parent = window.Sidebar.Container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = tabButton
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.Position = UDim2.new(0, 15, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = tabData.Icon
    iconLabel.TextColor3 = tabData.Active and ModernTheme.Background or ModernTheme.TextSecondary
    iconLabel.Font = Enum.Font.Gotham
    iconLabel.TextSize = 18
    iconLabel.Parent = tabButton
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -55, 1, 0)
    titleLabel.Position = UDim2.new(0, 50, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = tabData.Title
    titleLabel.TextColor3 = tabData.Active and ModernTheme.Background or ModernTheme.TextSecondary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = tabButton
    
    -- Content frame (content area'da)
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = tabData.Active
    tabContent.Parent = window.Content.ScrollFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.Parent = tabContent
    
    -- Click event
    tabButton.MouseButton1Click:Connect(function()
        self:_switchTab(window, tabData.Title)
    end)
    
    -- Hover effects
    self:_addModernHoverEffect(tabButton, iconLabel, titleLabel, tabData.Active)
    
    local tabObj = {
        Button = tabButton,
        Content = tabContent,
        Icon = iconLabel,
        Title = titleLabel,
        Data = tabData
    }
    
    table.insert(window.Tabs, tabObj)
    table.insert(window.Sidebar.Tabs, tabObj)
    
    -- İlk tab'ı aktif yap
    if #window.Tabs == 1 then
        window.TopBar.Title.Text = tabData.Title
    end
    
    return tabObj
end

-- Modern button oluşturma
function ModernGUI:createButton(parent, options)
    options = options or {}
    local buttonData = {
        Text = options.Text or "Button",
        Icon = options.Icon or "",
        Style = options.Style or "Primary", -- Primary, Secondary, Success, Warning, Error
        Size = options.Size or UDim2.new(0, 200, 0, 40),
        Callback = options.Callback or function() end
    }
    
    local button = Instance.new("TextButton")
    button.Size = buttonData.Size
    button.BackgroundColor3 = self:_getButtonColor(buttonData.Style)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230))
    }
    gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.95),
        NumberSequenceKeypoint.new(1, 0.9)
    }
    gradient.Parent = button
    
    -- Icon (if provided)
    if buttonData.Icon ~= "" then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 25, 1, 0)
        iconLabel.Position = UDim2.new(0, 15, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = buttonData.Icon
        iconLabel.TextColor3 = ModernTheme.TextPrimary
        iconLabel.Font = Enum.Font.Gotham
        iconLabel.TextSize = 16
        iconLabel.Parent = button
    end
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, buttonData.Icon ~= "" and -45 or -30, 1, 0)
    textLabel.Position = UDim2.new(0, buttonData.Icon ~= "" and 40 or 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = buttonData.Text
    textLabel.TextColor3 = ModernTheme.TextPrimary
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = button
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        self:_animateButtonClick(button)
        buttonData.Callback()
    end)
    
    -- Hover effect
    self:_addButtonHoverEffect(button)
    
    return button
end

-- Modern toggle oluşturma
function ModernGUI:createToggle(parent, options)
    options = options or {}
    local toggleData = {
        Text = options.Text or "Toggle",
        Default = options.Default or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Background
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = ModernTheme.Surface
    background.BorderSizePixel = 0
    background.Parent = container
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = background
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -80, 1, 0)
    textLabel.Position = UDim2.new(0, 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = toggleData.Text
    textLabel.TextColor3 = ModernTheme.TextPrimary
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = background
    
    -- Toggle switch
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Size = UDim2.new(0, 50, 0, 25)
    toggleSwitch.Position = UDim2.new(1, -60, 0.5, -12.5)
    toggleSwitch.BackgroundColor3 = toggleData.Default and ModernTheme.Primary or ModernTheme.Border
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Parent = background
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch
    
    -- Toggle knob
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 21, 0, 21)
    toggleKnob.Position = toggleData.Default and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleKnob.BackgroundColor3 = ModernTheme.TextPrimary
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Parent = toggleSwitch
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob
    
    local isToggled = toggleData.Default
    
    -- Click detector
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = background
    
    clickDetector.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        self:_animateToggle(toggleSwitch, toggleKnob, isToggled)
        toggleData.Callback(isToggled)
    end)
    
    -- Hover effect
    self:_addHoverEffect(background)
    
    container.GetValue = function() return isToggled end
    container.SetValue = function(value)
        isToggled = value
        self:_animateToggle(toggleSwitch, toggleKnob, isToggled)
    end
    
    return container
end

-- Modern slider oluşturma
function ModernGUI:createSlider(parent, options)
    options = options or {}
    local sliderData = {
        Text = options.Text or "Slider",
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 70)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Background
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = ModernTheme.Surface
    background.BorderSizePixel = 0
    background.Parent = container
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = background
    
    -- Title and value
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = sliderData.Text
    titleLabel.TextColor3 = ModernTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = background
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 25)
    valueLabel.Position = UDim2.new(1, -70, 0, 10)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(sliderData.Default)
    valueLabel.TextColor3 = ModernTheme.Primary
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.Parent = background
    
    -- Slider track
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -30, 0, 6)
    sliderTrack.Position = UDim2.new(0, 15, 0, 45)
    sliderTrack.BackgroundColor3 = ModernTheme.Border
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = background
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((sliderData.Default - sliderData.Min) / (sliderData.Max - sliderData.Min), 0, 1, 0)
    sliderFill.BackgroundColor3 = ModernTheme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    -- Slider knob
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 18, 0, 18)
    sliderKnob.Position = UDim2.new((sliderData.Default - sliderData.Min) / (sliderData.Max - sliderData.Min), -9, 0.5, -9)
    sliderKnob.BackgroundColor3 = ModernTheme.Primary
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderTrack
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    -- Glow effect for knob
    self:_addGlowEffect(sliderKnob, ModernTheme.Primary)
    
    local currentValue = sliderData.Default
    local dragging = false
    
    -- Drag functionality
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(sliderData.Min + (sliderData.Max - sliderData.Min) * relativeX)
        
        local tweenInfo = TweenInfo.new(AnimationConfig.HoverSpeed, AnimationConfig.Style, AnimationConfig.Direction)
        TweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
        TweenService:Create(sliderKnob, tweenInfo, {Position = UDim2.new(relativeX, -9, 0.5, -9)}):Play()
        
        valueLabel.Text = tostring(currentValue)
        sliderData.Callback(currentValue)
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    container.GetValue = function() return currentValue end
    container.SetValue = function(value)
        currentValue = math.clamp(value, sliderData.Min, sliderData.Max)
        local relativeX = (currentValue - sliderData.Min) / (sliderData.Max - sliderData.Min)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderKnob.Position = UDim2.new(relativeX, -9, 0.5, -9)
        valueLabel.Text = tostring(currentValue)
    end
    
    return container
end

-- Modern notification sistemi
function ModernGUI:createNotification(options)
    options = options or {}
    local notifData = {
        Title = options.Title or "Notification",
        Text = options.Text or "",
        Type = options.Type or "Info", -- Info, Success, Warning, Error
        Duration = options.Duration or 4
    }
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 350, 0, 90)
    notification.Position = UDim2.new(1, 370, 0, 20 + #self.Notifications * 100)
    notification.BackgroundColor3 = ModernTheme.Surface
    notification.BorderSizePixel = 0
    notification.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
