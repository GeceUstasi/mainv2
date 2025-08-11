-- DÜZELTED MODERN ROBLOX GUI FRAMEWORK - AURELIUS STYLE
-- Hataları giderilmiş, tam çalışan versiyon

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

-- Modern Theme (Aurelius benzeri)
local ModernTheme = {
    -- Ana renkler (Türkuaz/Teal tema)
    Primary = Color3.fromRGB(64, 224, 208),        -- Turquoise
    Secondary = Color3.fromRGB(72, 201, 176),      -- Medium turquoise
    Accent = Color3.fromRGB(26, 188, 156),         -- Emerald
    
    -- Arka plan renkleri
    Background = Color3.fromRGB(20, 20, 30),       -- Very dark blue
    Surface = Color3.fromRGB(30, 30, 45),          -- Dark blue
    SurfaceLight = Color3.fromRGB(40, 40, 60),     -- Medium dark blue
    
    -- Metin renkleri
    TextPrimary = Color3.fromRGB(255, 255, 255),   -- White
    TextSecondary = Color3.fromRGB(180, 180, 190), -- Light gray
    TextMuted = Color3.fromRGB(120, 120, 140),     -- Gray
    
    -- Durum renkleri
    Success = Color3.fromRGB(46, 204, 113),        -- Green
    Warning = Color3.fromRGB(241, 196, 15),        -- Yellow
    Error = Color3.fromRGB(231, 76, 60),           -- Red
    Info = Color3.fromRGB(52, 152, 219),           -- Blue
    
    -- Efekt renkleri
    Shadow = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(64, 224, 208),
    Border = Color3.fromRGB(50, 50, 70)
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
    window.Size = UDim2.new(0, 900, 0, 650)
    window.Position = UDim2.new(0.5, -450, 0.5, -325)
    window.BackgroundColor3 = ModernTheme.Background
    window.BorderSizePixel = 0
    window.Parent = self.ScreenGui
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
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

-- Sidebar oluşturma (Sol menü)
function ModernGUI:_createSidebar(parent)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 240, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = ModernTheme.Surface
    sidebar.BorderSizePixel = 0
    sidebar.Parent = parent
    
    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = sidebar
    
    -- Logo/Title area
    local logoArea = Instance.new("Frame")
    logoArea.Size = UDim2.new(1, 0, 0, 70)
    logoArea.BackgroundColor3 = ModernTheme.Primary
    logoArea.BorderSizePixel = 0
    logoArea.Parent = sidebar
    
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 10)
    logoCorner.Parent = logoArea
    
    -- Logo text
    local logoText = Instance.new("TextLabel")
    logoText.Size = UDim2.new(1, -20, 0.6, 0)
    logoText.Position = UDim2.new(0, 10, 0, 5)
    logoText.BackgroundTransparency = 1
    logoText.Text = self.Title:upper()
    logoText.TextColor3 = ModernTheme.Background
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 20
    logoText.TextXAlignment = Enum.TextXAlignment.Left
    logoText.Parent = logoArea
    
    -- Version label
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(1, -20, 0.4, 0)
    versionLabel.Position = UDim2.new(0, 10, 0.6, 0)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "v1.0.0"
    versionLabel.TextColor3 = ModernTheme.Background
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextSize = 12
    versionLabel.TextTransparency = 0.3
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = logoArea
    
    -- Navigation container
    local navContainer = Instance.new("ScrollingFrame")
    navContainer.Size = UDim2.new(1, 0, 1, -80)
    navContainer.Position = UDim2.new(0, 0, 0, 75)
    navContainer.BackgroundTransparency = 1
    navContainer.BorderSizePixel = 0
    navContainer.ScrollBarThickness = 0
    navContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    navContainer.Parent = sidebar
    
    local navLayout = Instance.new("UIListLayout")
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 5)
    navLayout.Parent = navContainer
    
    -- Auto resize canvas
    navLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        navContainer.CanvasSize = UDim2.new(0, 0, 0, navLayout.AbsoluteContentSize.Y + 10)
    end)
    
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
    contentArea.Size = UDim2.new(1, -260, 1, -60)
    contentArea.Position = UDim2.new(0, 250, 0, 50)
    contentArea.BackgroundColor3 = ModernTheme.SurfaceLight
    contentArea.BorderSizePixel = 0
    contentArea.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = contentArea
    
    -- Content scroll frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -20)
    scrollFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = ModernTheme.Primary
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = contentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = scrollFrame
    
    -- Auto resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
    
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
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = ModernTheme.Background
    topBar.BorderSizePixel = 0
    topBar.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = topBar
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Home"
    titleLabel.TextColor3 = ModernTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topBar
    
    -- Control buttons
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Size = UDim2.new(0, 80, 0, 25)
    controlsFrame.Position = UDim2.new(1, -90, 0.5, -12.5)
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

-- Tab oluşturma (sidebar'da) - DÜZELTİLMİŞ
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
    tabButton.BackgroundColor3 = tabData.Active and ModernTheme.Primary or Color3.fromRGB(0, 0, 0)
    tabButton.BackgroundTransparency = tabData.Active and 0 or 1
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
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
    iconLabel.TextSize = 16
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
    contentLayout.Padding = UDim.new(0, 10)
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
        Style = options.Style or "Primary",
        Size = options.Size or UDim2.new(1, 0, 0, 40),
        Callback = options.Callback or function() end
    }
    
    local button = Instance.new("TextButton")
    button.Size = buttonData.Size
    button.BackgroundColor3 = self:_getButtonColor(buttonData.Style)
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    -- Icon (if provided)
    local iconLabel
    if buttonData.Icon ~= "" then
        iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 20, 1, 0)
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
    textLabel.Size = UDim2.new(1, buttonData.Icon ~= "" and -40 or -30, 1, 0)
    textLabel.Position = UDim2.new(0, buttonData.Icon ~= "" and 35 or 15, 0, 0)
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
    container.Size = UDim2.new(1, 0, 0, 45)
    container.BackgroundColor3 = ModernTheme.Surface
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = container
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -70, 1, 0)
    textLabel.Position = UDim2.new(0, 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = toggleData.Text
    textLabel.TextColor3 = ModernTheme.TextPrimary
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = container
    
    -- Toggle switch
    local toggleSwitch = Instance.new("Frame")
    toggleSwitch.Size = UDim2.new(0, 50, 0, 24)
    toggleSwitch.Position = UDim2.new(1, -60, 0.5, -12)
    toggleSwitch.BackgroundColor3 = toggleData.Default and ModernTheme.Primary or ModernTheme.Border
    toggleSwitch.BorderSizePixel = 0
    toggleSwitch.Parent = container
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = toggleSwitch
    
    -- Toggle knob
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 20, 0, 20)
    toggleKnob.Position = toggleData.Default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
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
    clickDetector.Parent = container
    
    clickDetector.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        self:_animateToggle(toggleSwitch, toggleKnob, isToggled)
        toggleData.Callback(isToggled)
    end)
    
    -- Hover effect
    self:_addHoverEffect(container)
    
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
    container.Size = UDim2.new(1, 0, 0, 65)
    container.BackgroundColor3 = ModernTheme.Surface
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 8)
    bgCorner.Parent = container
    
    -- Title and value
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = sliderData.Text
    titleLabel.TextColor3 = ModernTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 25)
    valueLabel.Position = UDim2.new(1, -60, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(sliderData.Default)
    valueLabel.TextColor3 = ModernTheme.Primary
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 14
    valueLabel.Parent = container
    
    -- Slider track
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -30, 0, 6)
    sliderTrack.Position = UDim2.new(0, 15, 0, 40)
    sliderTrack.BackgroundColor3 = ModernTheme.Border
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = container
    
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
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new((sliderData.Default - sliderData.Min) / (sliderData.Max - sliderData.Min), -8, 0.5, -8)
    sliderKnob.BackgroundColor3 = ModernTheme.Primary
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderTrack
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    local currentValue = sliderData.Default
    local dragging = false
    
    -- Drag functionality
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(sliderData.Min + (sliderData.Max - sliderData.Min) * relativeX)
        
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
        
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
        sliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
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
        Type = options.Type or "Info",
        Duration = options.Duration or 4
    }
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 320, 0, 80)
    notification.Position = UDim2.new(1, 340, 0, 20 + #self.Notifications * 90)
    notification.BackgroundColor3 = ModernTheme.Surface
    notification.BorderSizePixel = 0
    notification.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    -- Colored left border
    local border = Instance.new("Frame")
    border.Size = UDim2.new(0, 4, 1, 0)
    border.BackgroundColor3 = self:_getNotificationColor(notifData.Type)
    border.BorderSizePixel = 0
    border.Parent = notification
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 10)
    borderCorner.Parent = border
    
    -- Icon
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 1, 0)
    iconLabel.Position = UDim2.new(0, 15, 0, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = self:_getNotificationIcon(notifData.Type)
    iconLabel.TextColor3 = self:_getNotificationColor(notifData.Type)
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 18
    iconLabel.Parent = notification
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 0, 25)
    titleLabel.Position = UDim2.new(0, 60, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = notifData.Title
    titleLabel.TextColor3 = ModernTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -100, 0, 40)
    textLabel.Position = UDim2.new(0, 60, 0, 30)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = notifData.Text
    textLabel.TextColor3 = ModernTheme.TextSecondary
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Parent = notification
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "×"
    closeButton.TextColor3 = ModernTheme.TextMuted
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.Parent = notification
    
    closeButton.MouseButton1Click:Connect(function()
        self:_removeNotification(notification)
    end)
    
    -- Slide in animation
    local slideInTween = TweenService:Create(notification, 
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -330, 0, 20 + #self.Notifications * 90)}
    )
    slideInTween:Play()
    
    table.insert(self.Notifications, notification)
    
    -- Auto remove
    if notifData.Duration > 0 then
        task.spawn(function()
            task.wait(notifData.Duration)
            self:_removeNotification(notification)
        end)
    end
    
    return notification
end

-- Yardımcı fonksiyonlar

function ModernGUI:_createNotificationSystem()
    -- Bildirim sistemi konteyner
end

function ModernGUI:_addGlowEffect(element, color)
    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 6, 1, 6)
    glow.Position = UDim2.new(0, -3, 0, -3)
    glow.BackgroundColor3 = color or ModernTheme.Primary
    glow.BackgroundTransparency = 0.9
    glow.BorderSizePixel = 0
    glow.ZIndex = element.ZIndex - 1
    glow.Parent = element.Parent
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 13)
    glowCorner.Parent = glow
end

function ModernGUI:_addModernHoverEffect(button, icon, title, isActive)
    button.MouseEnter:Connect(function()
        if not isActive then
            local tweenInfo = TweenInfo.new(AnimationConfig.HoverSpeed, AnimationConfig.Style, AnimationConfig.Direction)
            TweenService:Create(button, tweenInfo, {
                BackgroundColor3 = ModernTheme.SurfaceLight,
                BackgroundTransparency = 0
            }):Play()
            TweenService:Create(icon, tweenInfo, {TextColor3 = ModernTheme.Primary}):Play()
            TweenService:Create(title, tweenInfo, {TextColor3 = ModernTheme.TextPrimary}):Play()
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isActive then
            local tweenInfo = TweenInfo.new(AnimationConfig.HoverSpeed, AnimationConfig.Style, AnimationConfig.Direction)
            TweenService:Create(button, tweenInfo, {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(icon, tweenInfo, {TextColor3 = ModernTheme.TextSecondary}):Play()
            TweenService:Create(title, tweenInfo, {TextColor3 = ModernTheme.TextSecondary}):Play()
        end
    end)
end

function ModernGUI:_addButtonHoverEffect(button)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        local hoverColor = Color3.new(
            math.min(originalColor.R * 1.1, 1),
            math.min(originalColor.G * 1.1, 1),
            math.min(originalColor.B * 1.1, 1)
        )
        local tweenInfo = TweenInfo.new(AnimationConfig.HoverSpeed, AnimationConfig.Style, AnimationConfig.Direction)
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(AnimationConfig.HoverSpeed, AnimationConfig.Style, AnimationConfig.Direction)
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = originalColor}):Play()
    end)
end

function ModernGUI:_addHoverEffect(element)
    local originalColor = element.BackgroundColor3
    
    element.MouseEnter:Connect(function()
        local hoverColor = Color3.new(
            math.min(originalColor.R + 0.05, 1),
            math.min(originalColor.G + 0.05, 1),
            math.min(originalColor.B + 0.05, 1)
        )
        local tweenInfo = TweenInfo.new(AnimationConfig.HoverSpeed, AnimationConfig.Style, AnimationConfig.Direction)
        TweenService:Create(element, tweenInfo, {BackgroundColor3 = hoverColor}):Play()
    end)
    
    element.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(AnimationConfig.HoverSpeed, AnimationConfig.Style, AnimationConfig.Direction)
        TweenService:Create(element, tweenInfo, {BackgroundColor3 = originalColor}):Play()
    end)
end

function ModernGUI:_animateWindowIn(window)
    window.Size = UDim2.new(0, 0, 0, 0)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(window, tweenInfo, {
        Size = UDim2.new(0, 900, 0, 650),
        Position = UDim2.new(0.5, -450, 0.5, -325)
    }):Play()
end

function ModernGUI:_animateButtonClick(button)
    local originalSize = button.Size
    
    local shrinkTween = TweenService:Create(button,
        TweenInfo.new(AnimationConfig.ClickSpeed, AnimationConfig.Style, AnimationConfig.Direction),
        {Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95,
                         originalSize.Y.Scale * 0.95, originalSize.Y.Offset * 0.95)}
    )
    
    shrinkTween.Completed:Connect(function()
        TweenService:Create(button,
            TweenInfo.new(AnimationConfig.ClickSpeed, AnimationConfig.Style, AnimationConfig.Direction),
            {Size = originalSize}
        ):Play()
    end)
    
    shrinkTween:Play()
end

function ModernGUI:_animateToggle(toggleSwitch, toggleKnob, isToggled)
    local tweenInfo = TweenInfo.new(AnimationConfig.Speed, AnimationConfig.Style, AnimationConfig.Direction)
    
    TweenService:Create(toggleSwitch, tweenInfo, {
        BackgroundColor3 = isToggled and ModernTheme.Primary or ModernTheme.Border
    }):Play()
    
    TweenService:Create(toggleKnob, tweenInfo, {
        Position = isToggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    }):Play()
end

function ModernGUI:_switchTab(window, tabName)
    for _, tab in pairs(window.Tabs) do
        if tab.Data.Title == tabName then
            -- Activate tab
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = ModernTheme.Primary
            tab.Button.BackgroundTransparency = 0
            tab.Icon.TextColor3 = ModernTheme.Background
            tab.Title.TextColor3 = ModernTheme.Background
            tab.Data.Active = true
            
            -- Update window title
            window.TopBar.Title.Text = tabName
        else
            -- Deactivate tab
            tab.Content.Visible = false
            tab.Button.BackgroundTransparency = 1
            tab.Icon.TextColor3 = ModernTheme.TextSecondary
            tab.Title.TextColor3 = ModernTheme.TextSecondary
            tab.Data.Active = false
        end
    end
end

function ModernGUI:_makeDraggable(window, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragHandle.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function ModernGUI:_createControlButton(parent, text, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 25, 0, 25)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = ModernTheme.TextPrimary
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    self:_addButtonHoverEffect(button)
    
    return button
end

function ModernGUI:_minimizeWindow(window)
    local isMinimized = window:GetAttribute("Minimized") or false
    local originalSize = window:GetAttribute("OriginalSize") or window.Size
    
    if not isMinimized then
        window:SetAttribute("OriginalSize", window.Size)
        local tweenInfo = TweenInfo.new(AnimationConfig.Speed, AnimationConfig.Style, AnimationConfig.Direction)
        TweenService:Create(window, tweenInfo, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35)}):Play()
    else
        local tweenInfo = TweenInfo.new(AnimationConfig.Speed, AnimationConfig.Style, AnimationConfig.Direction)
        TweenService:Create(window, tweenInfo, {Size = originalSize}):Play()
    end
    
    window:SetAttribute("Minimized", not isMinimized)
end

function ModernGUI:_closeWindow(window)
    local tweenInfo = TweenInfo.new(AnimationConfig.Speed, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local closeTween = TweenService:Create(window, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    
    closeTween.Completed:Connect(function()
        window:Destroy()
    end)
    
    closeTween:Play()
end

function ModernGUI:_removeNotification(notification)
    local index = table.find(self.Notifications, notification)
    if index then
        table.remove(self.Notifications, index)
        
        local slideOutTween = TweenService:Create(notification,
            TweenInfo.new(AnimationConfig.Speed, AnimationConfig.Style, AnimationConfig.Direction),
            {Position = UDim2.new(1, 340, 0, notification.Position.Y.Offset)}
        )
        
        slideOutTween.Completed:Connect(function()
            notification:Destroy()
            
            -- Reposition remaining notifications
            for i, notif in ipairs(self.Notifications) do
                TweenService:Create(notif,
                    TweenInfo.new(AnimationConfig.Speed, AnimationConfig.Style, AnimationConfig.Direction),
                    {Position = UDim2.new(1, -330, 0, 20 + (i-1) * 90)}
                ):Play()
            end
        end)
        
        slideOutTween:Play()
    end
end

function ModernGUI:_getButtonColor(style)
    local colors = {
        Primary = ModernTheme.Primary,
        Secondary = ModernTheme.Secondary,
        Success = ModernTheme.Success,
        Warning = ModernTheme.Warning,
        Error = ModernTheme.Error,
        Info = ModernTheme.Info
    }
    return colors[style] or ModernTheme.Primary
end

function ModernGUI:_getNotificationColor(type)
    local colors = {
        Info = ModernTheme.Info,
        Success = ModernTheme.Success,
        Warning = ModernTheme.Warning,
        Error = ModernTheme.Error
    }
    return colors[type] or ModernTheme.Info
end

function ModernGUI:_getNotificationIcon(type)
    local icons = {
        Info = "ℹ️",
        Success = "✅",
        Warning = "⚠️",
        Error = "❌"
    }
    return icons[type] or "ℹ️"
end

-- Framework'ü yok etme
function ModernGUI:destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    self.Windows = {}
    self.Notifications = {}
end

return ModernGUI
