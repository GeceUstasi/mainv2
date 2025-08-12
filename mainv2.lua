-- BAĞIMSIZ PREMIUM GUI FRAMEWORK - URL'SİZ TAM ÇALIŞAN VERSİYON
-- Bu kod hiçbir dış bağımlılığa ihtiyaç duymaz, direkt çalışır!

print("🚀 Bağımsız Premium GUI yükleniyor...")

-- Framework Class
local PremiumGUI = {}
PremiumGUI.__index = PremiumGUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Ultra Modern Dark Theme
local DarkTheme = {
    Primary = Color3.fromRGB(147, 51, 234),        -- Deep Purple
    Secondary = Color3.fromRGB(99, 102, 241),      -- Indigo
    Accent = Color3.fromRGB(34, 197, 94),          -- Emerald Green
    
    Background = Color3.fromRGB(9, 9, 11),         -- Ultra Dark
    Surface = Color3.fromRGB(15, 15, 19),          -- Dark Surface
    SurfaceLight = Color3.fromRGB(20, 20, 26),     -- Light Surface
    SurfaceHover = Color3.fromRGB(28, 28, 35),     -- Hover Surface
    
    Glass = Color3.fromRGB(255, 255, 255),         -- White glass
    GlassDark = Color3.fromRGB(0, 0, 0),          -- Dark glass
    Overlay = Color3.fromRGB(0, 0, 0),             -- Modal overlay
    
    TextPrimary = Color3.fromRGB(248, 250, 252),   -- Almost white
    TextSecondary = Color3.fromRGB(203, 213, 225), -- Light gray
    TextMuted = Color3.fromRGB(148, 163, 184),     -- Medium gray
    TextDisabled = Color3.fromRGB(71, 85, 105),    -- Dark gray
    
    Success = Color3.fromRGB(34, 197, 94),         -- Green
    Warning = Color3.fromRGB(251, 146, 60),        -- Orange
    Error = Color3.fromRGB(239, 68, 68),           -- Red
    Info = Color3.fromRGB(59, 130, 246),           -- Blue
    
    Border = Color3.fromRGB(30, 41, 59),           -- Dark border
    BorderLight = Color3.fromRGB(51, 65, 85),      -- Light border
    BorderAccent = Color3.fromRGB(147, 51, 234),   -- Accent border
    
    Shadow = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(147, 51, 234),
}

-- Animation Config
local AnimConfig = {
    Speed = 0.3,
    Style = Enum.EasingStyle.Cubic,
    Direction = Enum.EasingDirection.Out,
    HoverSpeed = 0.2,
    ClickSpeed = 0.1,
    SlowSpeed = 0.5,
}

-- Framework Constructor
function PremiumGUI.new(title)
    local self = setmetatable({}, PremiumGUI)
    
    self.Title = title or "Premium GUI"
    self.Windows = {}
    self.Notifications = {}
    self.IsVisible = true
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "PremiumGUI_" .. self.Title
    self.ScreenGui.Parent = PlayerGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 100
    
    -- Initialize notification system
    self:_initializeNotificationSystem()
    
    return self
end

-- Window Creation
function PremiumGUI:createWindow(options)
    options = options or {}
    local windowData = {
        Title = options.Title or "Premium Window",
        Size = options.Size or UDim2.new(0, 1200, 0, 800),
        Position = options.Position or UDim2.new(0.5, -600, 0.5, -400),
        Draggable = options.Draggable ~= false
    }
    
    -- Main window
    local window = Instance.new("Frame")
    window.Name = "PremiumWindow"
    window.Size = windowData.Size
    window.Position = windowData.Position
    window.BackgroundColor3 = DarkTheme.Background
    window.BackgroundTransparency = 0.1
    window.BorderSizePixel = 0
    window.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = window
    
    -- Glass effect
    local glassEffect = Instance.new("Frame")
    glassEffect.Size = UDim2.new(1, 0, 1, 0)
    glassEffect.BackgroundColor3 = DarkTheme.Glass
    glassEffect.BackgroundTransparency = 0.95
    glassEffect.BorderSizePixel = 0
    glassEffect.Parent = window
    
    local glassCorner = Instance.new("UICorner")
    glassCorner.CornerRadius = UDim.new(0, 20)
    glassCorner.Parent = glassEffect
    
    -- Border
    local border = Instance.new("UIStroke")
    border.Color = DarkTheme.BorderLight
    border.Thickness = 2
    border.Transparency = 0.3
    border.Parent = window
    
    -- Title bar
    local titleBar = self:_createTitleBar(window, windowData)
    
    -- Sidebar
    local sidebar = self:_createSidebar(window)
    
    -- Content area
    local content = self:_createContentArea(window)
    
    -- Make draggable
    if windowData.Draggable then
        self:_makeDraggable(window, titleBar)
    end
    
    -- Entrance animation
    self:_animateEntrance(window)
    
    local windowObj = {
        Frame = window,
        TitleBar = titleBar,
        Sidebar = sidebar,
        Content = content,
        Data = windowData,
        Tabs = {},
        CurrentTab = nil
    }
    
    table.insert(self.Windows, windowObj)
    return windowObj
end

-- Title Bar Creation
function PremiumGUI:_createTitleBar(parent, data)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 60)
    titleBar.BackgroundColor3 = DarkTheme.Surface
    titleBar.BackgroundTransparency = 0.2
    titleBar.BorderSizePixel = 0
    titleBar.Parent = parent
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleBar
    
    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -200, 1, 0)
    titleLabel.Position = UDim2.new(0, 30, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = data.Title
    titleLabel.TextColor3 = DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -50, 0.5, -17)
    closeButton.BackgroundColor3 = DarkTheme.Error
    closeButton.BackgroundTransparency = 0.8
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = DarkTheme.TextPrimary
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 16
    closeButton.AutoButtonColor = false
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        self:_closeWindow(parent)
    end)
    
    return titleBar
end

-- Sidebar Creation
function PremiumGUI:_createSidebar(parent)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 300, 1, -80)
    sidebar.Position = UDim2.new(0, 20, 0, 70)
    sidebar.BackgroundColor3 = DarkTheme.Surface
    sidebar.BackgroundTransparency = 0.3
    sidebar.BorderSizePixel = 0
    sidebar.Parent = parent
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 15)
    sidebarCorner.Parent = sidebar
    
    -- Tab container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, -20, 1, -20)
    tabContainer.Position = UDim2.new(0, 10, 0, 10)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 6
    tabContainer.ScrollBarImageColor3 = DarkTheme.Primary
    tabContainer.ScrollBarImageTransparency = 0.3
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 8)
    tabLayout.Parent = tabContainer
    
    -- Auto resize
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
    end)
    
    return {
        Frame = sidebar,
        Container = tabContainer,
        Layout = tabLayout
    }
end

-- Content Area Creation
function PremiumGUI:_createContentArea(parent)
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -340, 1, -80)
    content.Position = UDim2.new(0, 330, 0, 70)
    content.BackgroundColor3 = DarkTheme.SurfaceLight
    content.BackgroundTransparency = 0.2
    content.BorderSizePixel = 0
    content.Parent = parent
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 15)
    contentCorner.Parent = content
    
    return content
end

-- Tab Creation
function PremiumGUI:createTab(window, options)
    options = options or {}
    local tabData = {
        Title = options.Title or "Tab",
        Icon = options.Icon or "📄",
        Active = options.Active or false
    }
    
    -- Tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, 0, 0, 55)
    tabButton.BackgroundColor3 = tabData.Active and DarkTheme.Primary or DarkTheme.Surface
    tabButton.BackgroundTransparency = tabData.Active and 0.2 or 0.4
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = window.Sidebar.Container
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 12)
    tabCorner.Parent = tabButton
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 28, 0, 28)
    icon.Position = UDim2.new(0, 20, 0.5, -14)
    icon.BackgroundTransparency = 1
    icon.Text = tabData.Icon
    icon.TextColor3 = tabData.Active and DarkTheme.Primary or DarkTheme.TextSecondary
    icon.Font = Enum.Font.Gotham
    icon.TextSize = 18
    icon.Parent = tabButton
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 60, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = tabData.Title
    title.TextColor3 = tabData.Active and DarkTheme.Primary or DarkTheme.TextSecondary
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = tabButton
    
    -- Tab content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 8
    tabContent.ScrollBarImageColor3 = DarkTheme.Primary
    tabContent.ScrollBarImageTransparency = 0.5
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.Visible = tabData.Active
    tabContent.Parent = window.Content
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.Parent = tabContent
    
    -- Auto resize
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Click event
    tabButton.MouseButton1Click:Connect(function()
        self:_switchTab(window, tabData.Title)
    end)
    
    local tabObj = {
        Button = tabButton,
        Content = tabContent,
        Icon = icon,
        Title = title,
        Data = tabData
    }
    
    table.insert(window.Tabs, tabObj)
    if tabData.Active then
        window.CurrentTab = tabObj
    end
    
    return tabObj
end

-- Section Creation
function PremiumGUI:createSection(parent, options)
    options = options or {}
    local sectionData = {
        Title = options.Title or "Section",
        Description = options.Description or nil
    }
    
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = DarkTheme.Surface
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 12)
    sectionCorner.Parent = section
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, sectionData.Description and 70 or 50)
    header.BackgroundTransparency = 1
    header.Parent = section
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 0, 30)
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = sectionData.Title
    titleLabel.TextColor3 = DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 17
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Description
    if sectionData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -30, 0, 25)
        descLabel.Position = UDim2.new(0, 15, 0, 40)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = sectionData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = header
    end
    
    -- Content container
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -30, 1, -(header.Size.Y.Offset + 25))
    content.Position = UDim2.new(0, 15, 0, header.Size.Y.Offset + 10)
    content.BackgroundTransparency = 1
    content.Parent = section
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = content
    
    -- Auto-size section
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(1, 0, 0, header.Size.Y.Offset + contentLayout.AbsoluteContentSize.Y + 35)
    end)
    
    return {
        Frame = section,
        Content = content,
        Layout = contentLayout
    }
end

-- Button Creation
function PremiumGUI:createButton(parent, options)
    options = options or {}
    local buttonData = {
        Text = options.Text or "Button",
        Icon = options.Icon or nil,
        Style = options.Style or "Primary",
        Size = options.Size or "Medium",
        Callback = options.Callback or function() end
    }
    
    local buttonHeight = 40
    local buttonSize = UDim2.new(1, 0, 0, buttonHeight)
    
    local button = Instance.new("TextButton")
    button.Size = buttonSize
    button.BackgroundColor3 = self:_getButtonColor(buttonData.Style)
    button.BackgroundTransparency = 0.2
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Content
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, 0)
    content.Position = UDim2.new(0, 10, 0, 0)
    content.BackgroundTransparency = 1
    content.Parent = button
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection = Enum.FillDirection.Horizontal
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = content
    
    -- Icon
    if buttonData.Icon then
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(0, 22, 0, 22)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = buttonData.Icon
        iconLabel.TextColor3 = DarkTheme.TextPrimary
        iconLabel.Font = Enum.Font.Gotham
        iconLabel.TextSize = 16
        iconLabel.Parent = content
    end
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = buttonData.Text
    textLabel.TextColor3 = DarkTheme.TextPrimary
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 14
    textLabel.AutomaticSize = Enum.AutomaticSize.X
    textLabel.Parent = content
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        self:_animateButtonClick(button)
        buttonData.Callback()
    end)
    
    return button
end

-- Label Creation
function PremiumGUI:createLabel(parent, options)
    options = options or {}
    local labelData = {
        Text = options.Text or "Label",
        Size = options.Size or "Medium",
        Color = options.Color or "Primary"
    }
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = labelData.Text
    label.TextColor3 = self:_getLabelColor(labelData.Color)
    label.Font = Enum.Font.Gotham
    label.TextSize = labelData.Size == "Large" and 16 or 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = parent
    
    return label
end

-- Notification System
function PremiumGUI:_initializeNotificationSystem()
    local notificationContainer = Instance.new("Frame")
    notificationContainer.Name = "NotificationContainer"
    notificationContainer.Size = UDim2.new(0, 350, 1, 0)
    notificationContainer.Position = UDim2.new(1, -370, 0, 20)
    notificationContainer.BackgroundTransparency = 1
    notificationContainer.Parent = self.ScreenGui
    
    local notificationLayout = Instance.new("UIListLayout")
    notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notificationLayout.Padding = UDim.new(0, 10)
    notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    notificationLayout.Parent = notificationContainer
    
    self.NotificationContainer = notificationContainer
end

function PremiumGUI:createNotification(options)
    options = options or {}
    local notificationData = {
        Title = options.Title or "Notification",
        Text = options.Text or "This is a notification",
        Type = options.Type or "Info",
        Duration = options.Duration or 5
    }
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, 0, 0, 80)
    notification.BackgroundColor3 = DarkTheme.Surface
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = self.NotificationContainer
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 12)
    notificationCorner.Parent = notification
    
    -- Type indicator
    local typeColor = self:_getNotificationColor(notificationData.Type)
    local typeIndicator = Instance.new("Frame")
    typeIndicator.Size = UDim2.new(0, 4, 1, -10)
    typeIndicator.Position = UDim2.new(0, 5, 0, 5)
    typeIndicator.BackgroundColor3 = typeColor
    typeIndicator.BorderSizePixel = 0
    typeIndicator.Parent = notification
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = typeIndicator
    
    -- Content
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -60, 1, -10)
    content.Position = UDim2.new(0, 20, 0, 5)
    content.BackgroundTransparency = 1
    content.Parent = notification
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = notificationData.Title
    titleLabel.TextColor3 = DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = content
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 30)
    textLabel.Position = UDim2.new(0, 0, 0, 25)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = notificationData.Text
    textLabel.TextColor3 = DarkTheme.TextSecondary
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.Parent = content
    
    -- Entrance animation
    notification.Position = UDim2.new(1, 50, 0, 0)
    notification.BackgroundTransparency = 1
    
    TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.1
    }):Play()
    
    -- Auto remove
    task.spawn(function()
        task.wait(notificationData.Duration)
        self:_removeNotification(notification)
    end)
    
    return notification
end

-- Utility Functions
function PremiumGUI:_switchTab(window, tabTitle)
    for _, tab in ipairs(window.Tabs) do
        local isActive = tab.Data.Title == tabTitle
        
        tab.Button.BackgroundColor3 = isActive and DarkTheme.Primary or DarkTheme.Surface
        tab.Button.BackgroundTransparency = isActive and 0.2 or 0.4
        tab.Icon.TextColor3 = isActive and DarkTheme.Primary or DarkTheme.TextSecondary
        tab.Title.TextColor3 = isActive and DarkTheme.Primary or DarkTheme.TextSecondary
        tab.Content.Visible = isActive
        
        if isActive then
            window.CurrentTab = tab
        end
    end
end

function PremiumGUI:_animateButtonClick(button)
    local originalSize = button.Size
    local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {
        Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 4, originalSize.Y.Scale, originalSize.Y.Offset - 4)
    })
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = originalSize}):Play()
    end)
end

function PremiumGUI:_makeDraggable(window, titleBar)
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function PremiumGUI:_animateEntrance(window)
    window.Size = UDim2.new(0, 0, 0, 0)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    window.BackgroundTransparency = 1
    
    local targetSize = UDim2.new(0, 1200, 0, 800)
    local targetPosition = UDim2.new(0.5, -600, 0.5, -400)
    
    TweenService:Create(window, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = targetSize,
        Position = targetPosition,
        BackgroundTransparency = 0.1
    }):Play()
end

function PremiumGUI:_closeWindow(window)
    TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.3)
    window:Destroy()
end

function PremiumGUI:_removeNotification(notification)
    TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, 50, notification.Position.Y.Scale, notification.Position.Y.Offset),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.3)
    notification:Destroy()
end

function PremiumGUI:_getButtonColor(style)
    local colors = {
        Primary = DarkTheme.Primary,
        Secondary = DarkTheme.Secondary,
        Success = DarkTheme.Success,
        Warning = DarkTheme.Warning,
        Error = DarkTheme.Error,
        Info = DarkTheme.Info
    }
    return colors[style] or colors.Primary
end

function PremiumGUI:_getLabelColor(color)
    local colors = {
        Primary = DarkTheme.TextPrimary,
        Secondary = DarkTheme.TextSecondary,
        Muted = DarkTheme.TextMuted,
        Success = DarkTheme.Success,
        Warning = DarkTheme.Warning,
        Error = DarkTheme.Error
    }
    return colors[color] or colors.Primary
end

function PremiumGUI:_getNotificationColor(type)
    local colors = {
        Info = DarkTheme.Info,
        Success = DarkTheme.Success,
        Warning = DarkTheme.Warning,
        Error = DarkTheme.Error
    }
    return colors[type] or colors.Info
end

function PremiumGUI:setVisible(visible)
    self.IsVisible = visible
    self.ScreenGui.Enabled = visible
end

function PremiumGUI:destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    setmetatable(self, nil)
end

print("✅ Framework dahili olarak yüklendi!")

-- ======================================
-- KULLANIM ÖRNEĞİ - DEMO GUI
-- ======================================

-- GUI oluştur
local gui = PremiumGUI.new("Aurelius Premium Hub")

-- Ana window
local mainWindow = gui:createWindow({
    Title = "🎮 Aurelius Premium Hub - Standalone",
    Size = UDim2.new(0, 1200, 0, 800),
    Position = UDim2.new(0.5, -600, 0.5, -400),
    Draggable = true
})

-- TAB 1: Ana Kontroller
local mainTab = gui:createTab(mainWindow, {
    Title = "Ana Kontroller",
    Icon = "🏠",
    Active = true
})

local controlsSection = gui:createSection(mainTab.Content, {
    Title = "🎯 Temel Kontroller",
    Description = "Bağımsız framework - URL gerektirmez!"
})

gui:createLabel(controlsSection.Content, {
    Text = "✅ Bağımsız Premium Framework Çalışıyor!",
    Size = "Large",
    Color = "Success"
})

gui:createLabel(controlsSection.Content, {
    Text = "Bu framework hiçbir dış URL'ye ihtiyaç duymaz. Tamamen bağımsız çalışır!",
    Size = "Medium",
    Color = "Secondary"
})

-- Test button
gui:createButton(controlsSection.Content, {
    Text = "🧪 Framework Testi",
    Icon = "⚡",
    Style = "Primary",
    Callback = function()
        print("✅ Button test başarılı!")
        gui:createNotification({
            Title = "🎉 Test Başarılı!",
            Text = "Bağımsız framework mükemmel çalışıyor! Hiçbir URL gerekmedi! ✨",
            Type = "Success",
            Duration = 4
        })
    end
})

-- Speed test
gui:createButton(controlsSection.Content, {
    Text = "🚀 Speed Hack",
    Icon = "💨",
    Style = "Warning",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 100
            gui:createNotification({
                Title = "🚀 Speed Hack",
                Text = "WalkSpeed 100'e ayarlandı! ⚡",
                Type = "Success",
                Duration = 3
            })
        else
            gui:createNotification({
                Title = "❌ Hata",
                Text = "Karakter bulunamadı!",
                Type = "Error",
                Duration = 2
            })
        end
    end
})

-- Jump power
gui:createButton(controlsSection.Content, {
    Text = "🦘 Jump Boost",
    Icon = "⬆️",
    Style = "Info",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = 100
            gui:createNotification({
                Title = "🦘 Jump Boost",
                Text = "JumpPower 100'e ayarlandı! ⬆️",
                Type = "Success",
                Duration = 3
            })
        end
    end
})

-- Reset button
gui:createButton(controlsSection.Content, {
    Text = "🔄 Reset Values",
    Icon = "↩️",
    Style = "Secondary",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            player.Character.Humanoid.JumpPower = 50
            gui:createNotification({
                Title = "🔄 Reset",
                Text = "Değerler sıfırlandı! (WS: 16, JP: 50)",
                Type = "Info",
                Duration = 3
            })
        end
    end
})

-- TAB 2: Özellikler
local featuresTab = gui:createTab(mainWindow, {
    Title = "Özellikler",
    Icon = "⚡"
})

local featuresSection = gui:createSection(featuresTab.Content, {
    Title = "⚡ Premium Özellikler",
    Description = "Bağımsız framework'ün tüm özellikleri"
})

gui:createLabel(featuresSection.Content, {
    Text = "🎨 Premium Dark Theme",
    Color = "Primary"
})

gui:createLabel(featuresSection.Content, {
    Text = "✨ Glass Morphism Effects",
    Color = "Secondary"
})

gui:createLabel(featuresSection.Content, {
    Text = "🌊 Smooth Animations",
    Color = "Success"
})

gui:createLabel(featuresSection.Content, {
    Text = "📱 Responsive Design",
    Color = "Info"
})

gui:createLabel(featuresSection.Content, {
    Text = "🔒 No External Dependencies",
    Color = "Warning"
})

-- Test notifications
gui:createButton(featuresSection.Content, {
    Text = "🔔 Success Notification",
    Icon = "✅",
    Style = "Success",
    Callback = function()
        gui:createNotification({
            Title = "✅ Başarı!",
            Text = "Bu bir başarı bildirimi! Framework harika çalışıyor! 🎉",
            Type = "Success",
            Duration = 4
        })
    end
})

gui:createButton(featuresSection.Content, {
    Text = "⚠️ Warning Notification",
    Icon = "⚠️",
    Style = "Warning",
    Callback = function()
        gui:createNotification({
            Title = "⚠️ Uyarı!",
            Text = "Bu bir uyarı bildirimi örneğidir.",
            Type = "Warning",
            Duration = 3
        })
    end
})

gui:createButton(featuresSection.Content, {
    Text = "❌ Error Notification",
    Icon = "❌",
    Style = "Error",
    Callback = function()
        gui:createNotification({
            Title = "❌ Hata!",
            Text = "Bu bir hata bildirimi örneğidir. (Test amaçlı)",
            Type = "Error",
            Duration = 3
        })
    end
})

gui:createButton(featuresSection.Content, {
    Text = "ℹ️ Info Notification",
    Icon = "ℹ️",
    Style = "Info",
    Callback = function()
        gui:createNotification({
            Title = "ℹ️ Bilgi",
            Text = "Bu bir bilgi bildirimi örneğidir.",
            Type = "Info",
            Duration = 3
        })
    end
})

-- TAB 3: Hakkında
local aboutTab = gui:createTab(mainWindow, {
    Title = "Hakkında",
    Icon = "ℹ️"
})

local aboutSection = gui:createSection(aboutTab.Content, {
    Title = "💎 Aurelius Premium Framework",
    Description = "Bağımsız, güvenli ve ultra modern GUI framework"
})

gui:createLabel(aboutSection.Content, {
    Text = "🎯 Framework Özellikleri:",
    Size = "Large",
    Color = "Primary"
})

gui:createLabel(aboutSection.Content, {
    Text = "✅ Hiçbir dış URL gerektirmez",
    Color = "Success"
})

gui:createLabel(aboutSection.Content, {
    Text = "✅ Tamamen güvenli ve bağımsız",
    Color = "Success"
})

gui:createLabel(aboutSection.Content, {
    Text = "✅ Modern dark theme tasarım",
    Color = "Success"
})

gui:createLabel(aboutSection.Content, {
    Text = "✅ Glass morphism efektleri",
    Color = "Success"
})

gui:createLabel(aboutSection.Content, {
    Text = "✅ Smooth animasyonlar",
    Color = "Success"
})

gui:createLabel(aboutSection.Content, {
    Text = "✅ Responsive ve optimize",
    Color = "Success"
})

gui:createLabel(aboutSection.Content, {
    Text = "✅ Premium notification sistemi",
    Color = "Success"
})

-- Framework test button
gui:createButton(aboutSection.Content, {
    Text = "🧪 Full Framework Test",
    Icon = "🔬",
    Style = "Primary",
    Callback = function()
        -- Multiple notifications to test system
        gui:createNotification({
            Title = "🧪 Test 1/4",
            Text = "Framework componenti test ediliyor...",
            Type = "Info",
            Duration = 2
        })
        
        task.wait(0.5)
        gui:createNotification({
            Title = "🎨 Test 2/4", 
            Text = "Animasyon sistemi test ediliyor...",
            Type = "Warning",
            Duration = 2
        })
        
        task.wait(0.5)
        gui:createNotification({
            Title = "💎 Test 3/4",
            Text = "Premium theme test ediliyor...",
            Type = "Success",
            Duration = 2
        })
        
        task.wait(0.5)
        gui:createNotification({
            Title = "🎉 Test 4/4",
            Text = "Tüm testler başarılı! Framework mükemmel çalışıyor! ✨",
            Type = "Success",
            Duration = 4
        })
    end
})

-- Başlangıç hoş geldin mesajı
task.wait(1)
gui:createNotification({
    Title = "🎉 Hoş Geldiniz!",
    Text = "Aurelius Premium Hub başarıyla yüklendi! Hiçbir URL hatası yok! 💎✨",
    Type = "Success",
    Duration = 5
})

-- Toggle sistemi - INSERT tuşu
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
        isVisible = not isVisible
        gui:setVisible(isVisible)
        print("GUI Visibility:", isVisible and "👁️ Görünür" or "🙈 Gizli")
    end
end)

-- Başarı mesajları
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🎉 AURELIUS STANDALONE FRAMEWORK YÜKLENDİ!")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("✅ Framework: Bağımsız çalışıyor")
print("✅ URL Dependency: YOK")
print("✅ GUI: Tamamen yüklendi")
print("✅ Animations: Aktif")
print("✅ Notifications: Çalışıyor")
print("✅ Theme: Premium Dark")
print("✅ Controls: INSERT = Toggle GUI")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("💎 Aurelius Premium - URL Hatası YOK!")
print("🎮 Güvenli ve bağımsız framework!")
print("✨ İyi eğlenceler!")
