-- ROBLOX GUI FRAMEWORK
-- Gelişmiş GUI Framework Sistemi
-- Kullanım: local GUI = require(script.GuiFramework)

local GuiFramework = {}
GuiFramework.__index = GuiFramework

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Temel değişkenler
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Framework ayarları
local FrameworkSettings = {
    DefaultTheme = {
        Primary = Color3.fromRGB(0, 212, 255),
        Secondary = Color3.fromRGB(0, 153, 204),
        Background = Color3.fromRGB(25, 25, 40),
        Surface = Color3.fromRGB(35, 35, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(255, 100, 100),
        Success = Color3.fromRGB(100, 255, 100),
        Warning = Color3.fromRGB(255, 255, 100),
        Error = Color3.fromRGB(255, 100, 100)
    },
    AnimationSpeed = 0.3,
    CornerRadius = UDim.new(0, 8),
    DefaultFont = Enum.Font.Gotham,
    DefaultTextSize = 14,
    ShadowTransparency = 0.7,
    HoverTransparency = 0.1
}

-- Framework ana sınıfı
function GuiFramework.new(name, parent)
    local self = setmetatable({}, GuiFramework)
    
    self.Name = name or "GuiFramework"
    self.Parent = parent or PlayerGui
    self.Theme = FrameworkSettings.DefaultTheme
    self.Windows = {}
    self.Tabs = {}
    self.Elements = {}
    self.Callbacks = {}
    self.Notifications = {}
    self.Locked = false
    self.Language = "tr"
    
    -- Ana ScreenGui oluştur
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = self.Name
    self.ScreenGui.Parent = self.Parent
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    
    -- Bildirim konteyneri
    self:_createNotificationContainer()
    
    -- Tema desteği
    self:_setupThemeSystem()
    
    return self
end

-- Window oluşturma
function GuiFramework:createWindow(options)
    options = options or {}
    local windowData = {
        Title = options.Title or "Window",
        Size = options.Size or UDim2.new(0, 500, 0, 400),
        Position = options.Position or UDim2.new(0.5, -250, 0.5, -200),
        Resizable = options.Resizable ~= false,
        Minimizable = options.Minimizable ~= false,
        Closable = options.Closable ~= false,
        Draggable = options.Draggable ~= false
    }
    
    -- Ana window frame
    local window = Instance.new("Frame")
    window.Name = "Window_" .. windowData.Title
    window.Size = windowData.Size
    window.Position = windowData.Position
    window.BackgroundColor3 = self.Theme and self.Theme.Background or Color3.fromRGB(25, 25, 40)
    window.BorderSizePixel = 0
    window.Parent = self.ScreenGui
    
    -- Corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = FrameworkSettings.CornerRadius
    corner.Parent = window
    
    -- Shadow efekti
    self:_addShadow(window)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = self.Theme and self.Theme.Primary or Color3.fromRGB(0, 212, 255)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = FrameworkSettings.CornerRadius
    titleCorner.Parent = titleBar
    
    -- Title text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowData.Title
    titleLabel.TextColor3 = self.Theme and self.Theme.Text or Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = FrameworkSettings.DefaultFont
    titleLabel.Parent = titleBar
    
    -- Window kontrolleri
    if windowData.Closable then
        self:_createWindowButton(titleBar, "Close", UDim2.new(1, -35, 0.5, -10), function()
            self:_animateOut(window, function()
                window:Destroy()
            end)
        end)
    end
    
    if windowData.Minimizable then
        self:_createWindowButton(titleBar, "Minimize", UDim2.new(1, -70, 0.5, -10), function()
            self:_toggleMinimize(window)
        end)
    end
    
    -- Content area
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 8
    content.ScrollBarImageColor3 = self.Theme and self.Theme.Primary or Color3.fromRGB(0, 212, 255)
    content.Parent = window
    
    -- Layout
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = content
    
    -- Drag özelliği
    if windowData.Draggable then
        self:_makeDraggable(window, titleBar)
    end
    
    -- Resize özelliği
    if windowData.Resizable then
        self:_makeResizable(window)
    end
    
    -- Animasyonla görünür yap
    self:_animateIn(window)
    
    -- Window nesnesini kaydet
    local windowObj = {
        Frame = window,
        Content = content,
        TitleBar = titleBar,
        Data = windowData,
        Tabs = {},
        Elements = {}
    }
    
    table.insert(self.Windows, windowObj)
    return windowObj
end

-- Tab oluşturma
function GuiFramework:createTab(window, options)
    options = options or {}
    local tabData = {
        Title = options.Title or "Tab",
        Icon = options.Icon or "",
        Active = options.Active or false
    }
    
    -- Tab container (yoksa oluştur)
    local tabContainer = window.Frame:FindFirstChild("TabContainer")
    if not tabContainer then
        tabContainer = Instance.new("Frame")
        tabContainer.Name = "TabContainer"
        tabContainer.Size = UDim2.new(1, -20, 0, 40)
        tabContainer.Position = UDim2.new(0, 10, 0, 50)
        tabContainer.BackgroundColor3 = self.Theme.Surface
        tabContainer.BorderSizePixel = 0
        tabContainer.Parent = window.Frame
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabContainer
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 5)
        tabLayout.Parent = tabContainer
        
        -- Content'i aşağı kaydır
        window.Content.Position = UDim2.new(0, 10, 0, 100)
        window.Content.Size = UDim2.new(1, -20, 1, -110)
    end
    
    -- Tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. tabData.Title
    tabButton.Size = UDim2.new(0, 120, 1, -10)
    tabButton.Position = UDim2.new(0, 5, 0, 5)
    tabButton.BackgroundColor3 = tabData.Active and self.Theme.Primary or self.Theme.Background
    tabButton.BorderSizePixel = 0
    tabButton.Text = tabData.Icon .. " " .. tabData.Title
    tabButton.TextColor3 = self.Theme.Text
    tabButton.Font = FrameworkSettings.DefaultFont
    tabButton.TextScaled = true
    tabButton.Parent = tabContainer
    
    local tabButtonCorner = Instance.new("UICorner")
    tabButtonCorner.CornerRadius = UDim.new(0, 4)
    tabButtonCorner.Parent = tabButton
    
    -- Tab content
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent_" .. tabData.Title
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = tabData.Active
    tabContent.Parent = window.Content
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tabContent
    
    -- Tab değiştirme
    tabButton.MouseButton1Click:Connect(function()
        self:_switchTab(window, tabData.Title)
    end)
    
    -- Hover efekti
    self:_addHoverEffect(tabButton)
    
    local tabObj = {
        Button = tabButton,
        Content = tabContent,
        Data = tabData,
        Elements = {}
    }
    
    table.insert(window.Tabs, tabObj)
    return tabObj
end

-- Button oluşturma
function GuiFramework:createButton(parent, options)
    options = options or {}
    local buttonData = {
        Text = options.Text or "Button",
        Size = options.Size or UDim2.new(0, 120, 0, 35),
        Callback = options.Callback or function() end,
        Style = options.Style or "Primary"
    }
    
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. buttonData.Text
    button.Size = buttonData.Size
    button.BackgroundColor3 = self:_getStyleColor(buttonData.Style)
    button.BorderSizePixel = 0
    button.Text = buttonData.Text
    button.TextColor3 = self.Theme.Text
    button.Font = FrameworkSettings.DefaultFont
    button.TextScaled = true
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = FrameworkSettings.CornerRadius
    corner.Parent = button
    
    -- Click eventi
    button.MouseButton1Click:Connect(function()
        if not self.Locked then
            self:_animateClick(button)
            buttonData.Callback()
            self:_triggerCallback("ButtonClicked", {text = buttonData.Text})
        end
    end)
    
    -- Hover efekti
    self:_addHoverEffect(button)
    
    return button
end

-- Toggle/Switch oluşturma
function GuiFramework:createToggle(parent, options)
    options = options or {}
    local toggleData = {
        Text = options.Text or "Toggle",
        Default = options.Default or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Name = "Toggle_" .. toggleData.Text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = toggleData.Text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = UDim2.new(1, -50, 0.5, -12.5)
    toggleFrame.BackgroundColor3 = toggleData.Default and self.Theme.Primary or self.Theme.Surface
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleFrame
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 21, 0, 21)
    toggleButton.Position = toggleData.Default and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    toggleButton.BackgroundColor3 = self.Theme.Text
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = toggleButton
    
    local isToggled = toggleData.Default
    
    -- Click eventi
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleFrame
    
    clickDetector.MouseButton1Click:Connect(function()
        if not self.Locked then
            isToggled = not isToggled
            self:_animateToggle(toggleFrame, toggleButton, isToggled)
            toggleData.Callback(isToggled)
            self:_triggerCallback("ToggleChanged", {text = toggleData.Text, value = isToggled})
        end
    end)
    
    -- Hover efekti
    self:_addHoverEffect(toggleFrame)
    
    container.GetValue = function() return isToggled end
    container.SetValue = function(value)
        isToggled = value
        self:_animateToggle(toggleFrame, toggleButton, isToggled)
    end
    
    return container
end

-- Slider oluşturma
function GuiFramework:createSlider(parent, options)
    options = options or {}
    local sliderData = {
        Text = options.Text or "Slider",
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Name = "Slider_" .. sliderData.Text
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = sliderData.Text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 60, 0, 20)
    valueLabel.Position = UDim2.new(1, -60, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(sliderData.Default)
    valueLabel.TextColor3 = self.Theme.Primary
    valueLabel.Font = FrameworkSettings.DefaultFont
    valueLabel.TextScaled = true
    valueLabel.Parent = container
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 8)
    sliderFrame.Position = UDim2.new(0, 0, 0, 30)
    sliderFrame.BackgroundColor3 = self.Theme.Surface
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = container
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(1, 0)
    sliderCorner.Parent = sliderFrame
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((sliderData.Default - sliderData.Min) / (sliderData.Max - sliderData.Min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = self.Theme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("Frame")
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((sliderData.Default - sliderData.Min) / (sliderData.Max - sliderData.Min), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = self.Theme.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    local currentValue = sliderData.Default
    local dragging = false
    
    -- Drag functionality
    local function updateSlider(input)
        if not self.Locked then
            local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(sliderData.Min + (sliderData.Max - sliderData.Min) * relativeX)
            
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
            TweenService:Create(sliderButton, tweenInfo, {Position = UDim2.new(relativeX, -10, 0.5, -10)}):Play()
            
            valueLabel.Text = tostring(currentValue)
            sliderData.Callback(currentValue)
            self:_triggerCallback("SliderChanged", {text = sliderData.Text, value = currentValue})
        end
    end
    
    sliderFrame.InputBegan:Connect(function(input)
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
        sliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
        valueLabel.Text = tostring(currentValue)
    end
    
    return container
end

-- Textbox oluşturma
function GuiFramework:createTextbox(parent, options)
    options = options or {}
    local textboxData = {
        Text = options.Text or "Textbox",
        Placeholder = options.Placeholder or "Enter text...",
        Default = options.Default or "",
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Name = "Textbox_" .. textboxData.Text
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = textboxData.Text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, 0, 0, 35)
    textbox.Position = UDim2.new(0, 0, 0, 25)
    textbox.BackgroundColor3 = self.Theme.Surface
    textbox.BorderSizePixel = 0
    textbox.Text = textboxData.Default
    textbox.PlaceholderText = textboxData.Placeholder
    textbox.TextColor3 = self.Theme.Text
    textbox.PlaceholderColor3 = self.Theme.TextSecondary
    textbox.Font = FrameworkSettings.DefaultFont
    textbox.TextScaled = true
    textbox.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = FrameworkSettings.CornerRadius
    corner.Parent = textbox
    
    -- Focus efektleri
    textbox.Focused:Connect(function()
        if not self.Locked then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(textbox, tweenInfo, {BackgroundColor3 = self.Theme.Primary}):Play()
        end
    end)
    
    textbox.FocusLost:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(textbox, tweenInfo, {BackgroundColor3 = self.Theme.Surface}):Play()
        textboxData.Callback(textbox.Text)
        self:_triggerCallback("TextboxChanged", {text = textboxData.Text, value = textbox.Text})
    end)
    
    container.GetValue = function() return textbox.Text end
    container.SetValue = function(value) textbox.Text = value end
    
    return container
end

-- Dropdown oluşturma
function GuiFramework:createDropdown(parent, options)
    options = options or {}
    local dropdownData = {
        Text = options.Text or "Dropdown",
        Options = options.Options or {"Option 1", "Option 2", "Option 3"},
        Default = options.Default or options.Options[1],
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Name = "Dropdown_" .. dropdownData.Text
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = dropdownData.Text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 0, 35)
    dropdown.Position = UDim2.new(0, 0, 0, 25)
    dropdown.BackgroundColor3 = self.Theme.Surface
    dropdown.BorderSizePixel = 0
    dropdown.Text = dropdownData.Default .. " ▼"
    dropdown.TextColor3 = self.Theme.Text
    dropdown.Font = FrameworkSettings.DefaultFont
    dropdown.TextScaled = true
    dropdown.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = FrameworkSettings.CornerRadius
    corner.Parent = dropdown
    
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Size = UDim2.new(1, 0, 0, math.min(#dropdownData.Options * 35, 140))
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = self.Theme.Surface
    optionsFrame.BorderSizePixel = 0
    optionsFrame.Visible = false
    optionsFrame.ScrollBarThickness = 6
    optionsFrame.Parent = dropdown
    
    local optionsCorner = Instance.new("UICorner")
    optionsCorner.CornerRadius = FrameworkSettings.CornerRadius
    optionsCorner.Parent = optionsFrame
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsFrame
    
    local currentValue = dropdownData.Default
    local isOpen = false
    
    -- Options oluştur
    for _, option in ipairs(dropdownData.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, 0, 0, 35)
        optionButton.BackgroundColor3 = self.Theme.Surface
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = self.Theme.Text
        optionButton.Font = FrameworkSettings.DefaultFont
        optionButton.TextScaled = true
        optionButton.Parent = optionsFrame
        
        optionButton.MouseButton1Click:Connect(function()
            if not self.Locked then
                currentValue = option
                dropdown.Text = option .. " ▼"
                optionsFrame.Visible = false
                isOpen = false
                container.Size = UDim2.new(1, 0, 0, 60)
                dropdownData.Callback(option)
                self:_triggerCallback("DropdownChanged", {text = dropdownData.Text, value = option})
            end
        end)
        
        self:_addHoverEffect(optionButton)
    end
    
    -- Canvas size ayarla
    optionsFrame.CanvasSize = UDim2.new(0, 0, 0, #dropdownData.Options * 35)
    
    -- Click eventi
    dropdown.MouseButton1Click:Connect(function()
        if not self.Locked then
            isOpen = not isOpen
            optionsFrame.Visible = isOpen
            container.Size = UDim2.new(1, 0, 0, isOpen and (60 + optionsFrame.AbsoluteSize.Y + 5) or 60)
            dropdown.Text = currentValue .. (isOpen and " ▲" or " ▼")
        end
    end)
    
    self:_addHoverEffect(dropdown)
    
    container.GetValue = function() return currentValue end
    container.SetValue = function(value)
        if table.find(dropdownData.Options, value) then
            currentValue = value
            dropdown.Text = value .. (isOpen and " ▲" or " ▼")
        end
    end
    
    return container
end

-- Color Picker oluşturma
function GuiFramework:createColorPicker(parent, options)
    options = options or {}
    local colorData = {
        Text = options.Text or "Color Picker",
        Default = options.Default or Color3.fromRGB(255, 255, 255),
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Name = "ColorPicker_" .. colorData.Text
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = colorData.Text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Size = UDim2.new(0, 40, 0, 40)
    colorDisplay.Position = UDim2.new(1, -40, 0, 10)
    colorDisplay.BackgroundColor3 = colorData.Default
    colorDisplay.BorderSizePixel = 0
    colorDisplay.Parent = container
    
    local displayCorner = Instance.new("UICorner")
    displayCorner.CornerRadius = FrameworkSettings.CornerRadius
    displayCorner.Parent = colorDisplay
    
    -- Color picker button
    local pickerButton = Instance.new("TextButton")
    pickerButton.Size = UDim2.new(1, 0, 1, 0)
    pickerButton.BackgroundTransparency = 1
    pickerButton.Text = ""
    pickerButton.Parent = colorDisplay
    
    local currentColor = colorData.Default
    
    pickerButton.MouseButton1Click:Connect(function()
        if not self.Locked then
            self:_openColorPicker(currentColor, function(newColor)
                currentColor = newColor
                colorDisplay.BackgroundColor3 = newColor
                colorData.Callback(newColor)
                self:_triggerCallback("ColorChanged", {text = colorData.Text, value = newColor})
            end)
        end
    end)
    
    self:_addHoverEffect(colorDisplay)
    
    container.GetValue = function() return currentColor end
    container.SetValue = function(color)
        currentColor = color
        colorDisplay.BackgroundColor3 = color
    end
    
    return container
end

-- Notification sistemi
function GuiFramework:createNotification(options)
    options = options or {}
    local notificationData = {
        Title = options.Title or "Notification",
        Text = options.Text or "",
        Duration = options.Duration or 3,
        Type = options.Type or "Info" -- Info, Success, Warning, Error
    }
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(1, 320, 0, #self.Notifications * 90 + 20)
    notification.BackgroundColor3 = self:_getNotificationColor(notificationData.Type)
    notification.BorderSizePixel = 0
    notification.Parent = self.NotificationContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = FrameworkSettings.CornerRadius
    corner.Parent = notification
    
    -- Shadow
    self:_addShadow(notification)
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = notificationData.Title
    title.TextColor3 = self.Theme.Text
    title.Font = FrameworkSettings.DefaultFont
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.FontSize = Enum.FontSize.Size18
    title.Parent = notification
    
    -- Text
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -60, 0, 45)
    text.Position = UDim2.new(0, 10, 0, 30)
    text.BackgroundTransparency = 1
    text.Text = notificationData.Text
    text.TextColor3 = self.Theme.TextSecondary
    text.Font = FrameworkSettings.DefaultFont
    text.TextScaled = true
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextWrapped = true
    text.Parent = notification
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -45, 0, 5)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✕"
    closeButton.TextColor3 = self.Theme.Text
    closeButton.Font = FrameworkSettings.DefaultFont
    closeButton.TextScaled = true
    closeButton.Parent = notification
    
    closeButton.MouseButton1Click:Connect(function()
        self:_removeNotification(notification)
    end)
    
    -- Animasyon
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(notification, tweenInfo, {Position = UDim2.new(1, -310, 0, #self.Notifications * 90 + 20)}):Play()
    
    table.insert(self.Notifications, notification)
    
    -- Otomatik kaldırma
    if notificationData.Duration > 0 then
        wait(notificationData.Duration)
        self:_removeNotification(notification)
    end
    
    return notification
end

-- Group Box oluşturma
function GuiFramework:createGroupBox(parent, options)
    options = options or {}
    local groupData = {
        Text = options.Text or "Group",
        Size = options.Size or UDim2.new(1, 0, 0, 200)
    }
    
    local groupBox = Instance.new("Frame")
    groupBox.Name = "GroupBox_" .. groupData.Text
    groupBox.Size = groupData.Size
    groupBox.BackgroundColor3 = self.Theme.Surface
    groupBox.BorderSizePixel = 0
    groupBox.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = FrameworkSettings.CornerRadius
    corner.Parent = groupBox
    
    -- Border efekti
    local border = Instance.new("UIStroke")
    border.Color = self.Theme.Primary
    border.Transparency = 0.7
    border.Thickness = 2
    border.Parent = groupBox
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = groupData.Text
    title.TextColor3 = self.Theme.Primary
    title.Font = FrameworkSettings.DefaultFont
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = groupBox
    
    -- Content area
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -20, 1, -45)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = self.Theme.Primary
    content.Parent = groupBox
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = content
    
    return {Frame = groupBox, Content = content}
end

-- Sub Tab oluşturma
function GuiFramework:createSubTab(parent, options)
    options = options or {}
    local subTabData = {
        Tabs = options.Tabs or {"SubTab 1", "SubTab 2"}
    }
    
    local container = Instance.new("Frame")
    container.Name = "SubTabContainer"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Sub tab buttons
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 0, 35)
    tabFrame.BackgroundColor3 = self.Theme.Background
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = container
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -45)
    contentFrame.Position = UDim2.new(0, 0, 0, 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = container
    
    local subTabs = {}
    local activeSubTab = 1
    
    for i, tabName in ipairs(subTabData.Tabs) do
        -- Sub tab button
        local subTabButton = Instance.new("TextButton")
        subTabButton.Size = UDim2.new(1/#subTabData.Tabs, -5, 1, -10)
        subTabButton.Position = UDim2.new(0, 5, 0, 5)
        subTabButton.BackgroundColor3 = i == 1 and self.Theme.Primary or self.Theme.Surface
        subTabButton.BorderSizePixel = 0
        subTabButton.Text = tabName
        subTabButton.TextColor3 = self.Theme.Text
        subTabButton.Font = FrameworkSettings.DefaultFont
        subTabButton.TextScaled = true
        subTabButton.Parent = tabFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 4)
        buttonCorner.Parent = subTabButton
        
        -- Sub tab content
        local subTabContent = Instance.new("ScrollingFrame")
        subTabContent.Size = UDim2.new(1, 0, 1, 0)
        subTabContent.BackgroundTransparency = 1
        subTabContent.BorderSizePixel = 0
        subTabContent.Visible = i == 1
        subTabContent.ScrollBarThickness = 6
        subTabContent.Parent = contentFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = subTabContent
        
        subTabButton.MouseButton1Click:Connect(function()
            if not self.Locked then
                -- Hide all sub tabs
                for _, subTab in ipairs(subTabs) do
                    subTab.Content.Visible = false
                    subTab.Button.BackgroundColor3 = self.Theme.Surface
                end
                
                -- Show selected sub tab
                subTabContent.Visible = true
                subTabButton.BackgroundColor3 = self.Theme.Primary
                activeSubTab = i
            end
        end)
        
        self:_addHoverEffect(subTabButton)
        
        table.insert(subTabs, {
            Button = subTabButton,
            Content = subTabContent,
            Name = tabName
        })
    end
    
    return {Container = container, SubTabs = subTabs}
end

-- Keybind oluşturma
function GuiFramework:createKeybind(parent, options)
    options = options or {}
    local keybindData = {
        Text = options.Text or "Keybind",
        Default = options.Default or Enum.KeyCode.F,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Name = "Keybind_" .. keybindData.Text
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = keybindData.Text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local keybindButton = Instance.new("TextButton")
    keybindButton.Size = UDim2.new(0, 70, 0, 30)
    keybindButton.Position = UDim2.new(1, -70, 0.5, -15)
    keybindButton.BackgroundColor3 = self.Theme.Surface
    keybindButton.BorderSizePixel = 0
    keybindButton.Text = keybindData.Default.Name
    keybindButton.TextColor3 = self.Theme.Text
    keybindButton.Font = FrameworkSettings.DefaultFont
    keybindButton.TextScaled = true
    keybindButton.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = keybindButton
    
    local currentKey = keybindData.Default
    local isBinding = false
    
    keybindButton.MouseButton1Click:Connect(function()
        if not self.Locked then
            isBinding = true
            keybindButton.Text = "..."
            keybindButton.BackgroundColor3 = self.Theme.Primary
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isBinding and not gameProcessed then
            currentKey = input.KeyCode
            keybindButton.Text = currentKey.Name
            keybindButton.BackgroundColor3 = self.Theme.Surface
            isBinding = false
        elseif input.KeyCode == currentKey and not gameProcessed then
            keybindData.Callback()
            self:_triggerCallback("KeybindPressed", {text = keybindData.Text, key = currentKey})
        end
    end)
    
    self:_addHoverEffect(keybindButton)
    
    container.GetValue = function() return currentKey end
    container.SetValue = function(key)
        currentKey = key
        keybindButton.Text = key.Name
    end
    
    return container
end

-- Progress Bar oluşturma
function GuiFramework:createProgressBar(parent, options)
    options = options or {}
    local progressData = {
        Text = options.Text or "Progress",
        Value = options.Value or 0,
        Max = options.Max or 100
    }
    
    local container = Instance.new("Frame")
    container.Name = "ProgressBar_" .. progressData.Text
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = progressData.Text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Size = UDim2.new(0, 60, 0, 20)
    percentLabel.Position = UDim2.new(1, -60, 0, 0)
    percentLabel.BackgroundTransparency = 1
    percentLabel.Text = math.floor((progressData.Value / progressData.Max) * 100) .. "%"
    percentLabel.TextColor3 = self.Theme.Primary
    percentLabel.Font = FrameworkSettings.DefaultFont
    percentLabel.TextScaled = true
    percentLabel.Parent = container
    
    local progressFrame = Instance.new("Frame")
    progressFrame.Size = UDim2.new(1, 0, 0, 20)
    progressFrame.Position = UDim2.new(0, 0, 0, 25)
    progressFrame.BackgroundColor3 = self.Theme.Surface
    progressFrame.BorderSizePixel = 0
    progressFrame.Parent = container
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressFrame
    
    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(progressData.Value / progressData.Max, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = self.Theme.Primary
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = progressFill
    
    container.SetValue = function(value)
        local clampedValue = math.clamp(value, 0, progressData.Max)
        local percentage = clampedValue / progressData.Max
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        
        percentLabel.Text = math.floor(percentage * 100) .. "%"
        progressData.Value = clampedValue
    end
    
    container.GetValue = function() return progressData.Value end
    
    return container
end

-- Yardımcı fonksiyonlar

function GuiFramework:_createNotificationContainer()
    self.NotificationContainer = Instance.new("Frame")
    self.NotificationContainer.Name = "NotificationContainer"
    self.NotificationContainer.Size = UDim2.new(1, 0, 1, 0)
    self.NotificationContainer.BackgroundTransparency = 1
    self.NotificationContainer.Parent = self.ScreenGui
end

function GuiFramework:_setupThemeSystem()
    -- Tema değiştirme fonksiyonu
    self.ChangeTheme = function(newTheme)
        self.Theme = newTheme
        self:_updateAllElements()
    end
end

function GuiFramework:_addShadow(element)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 6, 1, 6)
    shadow.Position = UDim2.new(0, -3, 0, 3)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = FrameworkSettings.ShadowTransparency
    shadow.BorderSizePixel = 0
    shadow.ZIndex = element.ZIndex - 1
    shadow.Parent = element.Parent
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = FrameworkSettings.CornerRadius
    shadowCorner.Parent = shadow
end

function GuiFramework:_addHoverEffect(element)
    local originalColor = element.BackgroundColor3
    
    element.MouseEnter:Connect(function()
        if not self.Locked then
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local hoverColor = Color3.new(
                math.min(originalColor.R + 0.1, 1),
                math.min(originalColor.G + 0.1, 1),
                math.min(originalColor.B + 0.1, 1)
            )
            TweenService:Create(element, tweenInfo, {BackgroundColor3 = hoverColor}):Play()
        end
    end)
    
    element.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(element, tweenInfo, {BackgroundColor3 = originalColor}):Play()
    end)
end

function GuiFramework:_animateIn(element)
    element.Size = UDim2.new(0, 0, 0, 0)
    element.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(element, tweenInfo, {
        Size = element:GetAttribute("OriginalSize") or UDim2.new(0, 500, 0, 400),
        Position = element:GetAttribute("OriginalPosition") or UDim2.new(0.5, -250, 0.5, -200)
    }):Play()
end

function GuiFramework:_animateOut(element, callback)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tween = TweenService:Create(element, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    
    tween.Completed:Connect(callback)
    tween:Play()
end

function GuiFramework:_animateClick(element)
    local originalSize = element.Size
    
    local shrinkTween = TweenService:Create(element, 
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Size = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95, 
                         originalSize.Y.Scale * 0.95, originalSize.Y.Offset * 0.95)}
    )
    
    shrinkTween.Completed:Connect(function()
        local expandTween = TweenService:Create(element,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = originalSize}
        )
        expandTween:Play()
    end)
    
    shrinkTween:Play()
end

function GuiFramework:_animateToggle(toggleFrame, toggleButton, isToggled)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(toggleFrame, tweenInfo, {
        BackgroundColor3 = isToggled and self.Theme.Primary or self.Theme.Surface
    }):Play()
    
    TweenService:Create(toggleButton, tweenInfo, {
        Position = isToggled and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
    }):Play()
end

function GuiFramework:_getStyleColor(style)
    local colors = {
        Primary = self.Theme.Primary,
        Secondary = self.Theme.Secondary,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error
    }
    return colors[style] or self.Theme.Primary
end

function GuiFramework:_getNotificationColor(type)
    local colors = {
        Info = self.Theme.Primary,
        Success = self.Theme.Success,
        Warning = self.Theme.Warning,
        Error = self.Theme.Error
    }
    return colors[type] or self.Theme.Primary
end

function GuiFramework:_triggerCallback(event, data)
    if self.Callbacks[event] then
        for _, callback in ipairs(self.Callbacks[event]) do
            callback(data)
        end
    end
end

function GuiFramework:_switchTab(window, tabName)
    for _, tab in ipairs(window.Tabs) do
        if tab.Data.Title == tabName then
            tab.Content.Visible = true
            tab.Button.BackgroundColor3 = self.Theme.Primary
        else
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = self.Theme.Background
        end
    end
end

function GuiFramework:_makeDraggable(window, titleBar)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
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

function GuiFramework:_makeResizable(window)
    local resizeButton = Instance.new("TextButton")
    resizeButton.Size = UDim2.new(0, 20, 0, 20)
    resizeButton.Position = UDim2.new(1, -20, 1, -20)
    resizeButton.BackgroundColor3 = self.Theme.Primary
    resizeButton.BorderSizePixel = 0
    resizeButton.Text = "⟋"
    resizeButton.TextColor3 = self.Theme.Text
    resizeButton.Font = FrameworkSettings.DefaultFont
    resizeButton.TextScaled = true
    resizeButton.Parent = window
    
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    resizeButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = window.Size
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newSize = UDim2.new(startSize.X.Scale, 
                                     math.max(300, startSize.X.Offset + delta.X),
                                     startSize.Y.Scale,
                                     math.max(200, startSize.Y.Offset + delta.Y))
            window.Size = newSize
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function GuiFramework:_openColorPicker(currentColor, callback)
    -- Basit color picker implementation
    -- Gerçek projede daha gelişmiş bir color picker eklenebilir
    local colors = {
        Color3.fromRGB(255, 0, 0),    -- Red
        Color3.fromRGB(0, 255, 0),    -- Green
        Color3.fromRGB(0, 0, 255),    -- Blue
        Color3.fromRGB(255, 255, 0),  -- Yellow
        Color3.fromRGB(255, 0, 255),  -- Magenta
        Color3.fromRGB(0, 255, 255),  -- Cyan
        Color3.fromRGB(255, 255, 255), -- White
        Color3.fromRGB(0, 0, 0)       -- Black
    }
    
    local colorWindow = self:createWindow({
        Title = "Color Picker",
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, -150, 0.5, -100)
    })
    
    for i, color in ipairs(colors) do
        local colorButton = Instance.new("TextButton")
        colorButton.Size = UDim2.new(0, 30, 0, 30)
        colorButton.Position = UDim2.new(0, ((i-1) % 4) * 35 + 10, 0, math.floor((i-1) / 4) * 35 + 10)
        colorButton.BackgroundColor3 = color
        colorButton.BorderSizePixel = 0
        colorButton.Text = ""
        colorButton.Parent = colorWindow.Content
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = colorButton
        
        colorButton.MouseButton1Click:Connect(function()
            callback(color)
            colorWindow.Frame:Destroy()
        end)
        
        self:_addHoverEffect(colorButton)
    end
end

function GuiFramework:_removeNotification(notification)
    local index = table.find(self.Notifications, notification)
    if index then
        table.remove(self.Notifications, index)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(notification, tweenInfo, {Position = UDim2.new(1, 320, 0, notification.Position.Y.Offset)}):Play()
        
        wait(0.3)
        notification:Destroy()
        
        -- Diğer bildirimleri yeniden konumlandır
        for i, notif in ipairs(self.Notifications) do
            TweenService:Create(notif, tweenInfo, {Position = UDim2.new(1, -310, 0, (i-1) * 90 + 20)}):Play()
        end
    end
end

function GuiFramework:_toggleMinimize(window)
    local isMinimized = window:GetAttribute("Minimized") or false
    local originalSize = window:GetAttribute("OriginalSize") or window.Size
    
    if not isMinimized then
        window:SetAttribute("OriginalSize", window.Size)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(window, tweenInfo, {Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 40)}):Play()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(window, tweenInfo, {Size = originalSize}):Play()
    end
    
    window:SetAttribute("Minimized", not isMinimized)
end

function GuiFramework:_createWindowButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Position = position
    button.BackgroundColor3 = self.Theme.Error
    button.BorderSizePixel = 0
    button.Text = text == "Close" and "✕" or "−"
    button.TextColor3 = self.Theme.Text
    button.Font = FrameworkSettings.DefaultFont
    button.TextScaled = true
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    self:_addHoverEffect(button)
    
    return button
end

-- Gelişmiş özellikler

-- Multi-language support
function GuiFramework:setLanguage(language)
    self.Language = language
    local translations = self:_getTranslations()
    self:_updateLanguage(translations[language] or translations["en"])
end

function GuiFramework:_getTranslations()
    return {
        tr = {
            close = "Kapat",
            minimize = "Küçült",
            maximize = "Büyüt",
            notification = "Bildirim",
            error = "Hata",
            warning = "Uyarı",
            success = "Başarılı",
            info = "Bilgi"
        },
        en = {
            close = "Close",
            minimize = "Minimize", 
            maximize = "Maximize",
            notification = "Notification",
            error = "Error",
            warning = "Warning",
            success = "Success",
            info = "Info"
        },
        es = {
            close = "Cerrar",
            minimize = "Minimizar",
            maximize = "Maximizar", 
            notification = "Notificación",
            error = "Error",
            warning = "Advertencia",
            success = "Éxito",
            info = "Información"
        }
    }
end

-- Tema değiştirme
function GuiFramework:setTheme(theme)
    if type(theme) == "string" then
        local presetThemes = {
            Dark = {
                Primary = Color3.fromRGB(0, 212, 255),
                Secondary = Color3.fromRGB(0, 153, 204),
                Background = Color3.fromRGB(25, 25, 40),
                Surface = Color3.fromRGB(35, 35, 55),
                Text = Color3.fromRGB(255, 255, 255),
                TextSecondary = Color3.fromRGB(200, 200, 200),
                Accent = Color3.fromRGB(255, 100, 100),
                Success = Color3.fromRGB(100, 255, 100),
                Warning = Color3.fromRGB(255, 255, 100),
                Error = Color3.fromRGB(255, 100, 100)
            },
            Light = {
                Primary = Color3.fromRGB(0, 122, 255),
                Secondary = Color3.fromRGB(0, 100, 200),
                Background = Color3.fromRGB(245, 245, 245),
                Surface = Color3.fromRGB(255, 255, 255),
                Text = Color3.fromRGB(0, 0, 0),
                TextSecondary = Color3.fromRGB(100, 100, 100),
                Accent = Color3.fromRGB(255, 59, 48),
                Success = Color3.fromRGB(52, 199, 89),
                Warning = Color3.fromRGB(255, 204, 0),
                Error = Color3.fromRGB(255, 59, 48)
            },
            Purple = {
                Primary = Color3.fromRGB(138, 43, 226),
                Secondary = Color3.fromRGB(106, 27, 154),
                Background = Color3.fromRGB(30, 25, 40),
                Surface = Color3.fromRGB(45, 35, 60),
                Text = Color3.fromRGB(255, 255, 255),
                TextSecondary = Color3.fromRGB(200, 200, 200),
                Accent = Color3.fromRGB(255, 20, 147),
                Success = Color3.fromRGB(100, 255, 100),
                Warning = Color3.fromRGB(255, 255, 100),
                Error = Color3.fromRGB(255, 100, 100)
            }
        }
        self.Theme = presetThemes[theme] or presetThemes.Dark
    else
        self.Theme = theme
    end
    
    self:_updateAllElements()
end

-- Element kilitleme/açma
function GuiFramework:lockElements()
    self.Locked = true
    self:createNotification({
        Title = "UI Locked",
        Text = "All UI elements have been locked",
        Type = "Warning",
        Duration = 2
    })
end

function GuiFramework:unlockElements()
    self.Locked = false
    self:createNotification({
        Title = "UI Unlocked", 
        Text = "All UI elements have been unlocked",
        Type = "Success",
        Duration = 2
    })
end

-- Callback sistemi
function GuiFramework:onEvent(event, callback)
    if not self.Callbacks[event] then
        self.Callbacks[event] = {}
    end
    table.insert(self.Callbacks[event], callback)
end

-- Debug ve hata ayıklama
function GuiFramework:enableDebug()
    self.DebugMode = true
    print("[GuiFramework] Debug mode enabled")
    
    -- Debug window oluştur
    local debugWindow = self:createWindow({
        Title = "Debug Console",
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0, 20, 0, 20)
    })
    
    local debugOutput = Instance.new("TextLabel")
    debugOutput.Size = UDim2.new(1, 0, 1, 0)
    debugOutput.BackgroundTransparency = 1
    debugOutput.Text = "Debug console active...\n"
    debugOutput.TextColor3 = self.Theme.Text
    debugOutput.Font = Enum.Font.Code
    debugOutput.TextSize = 12
    debugOutput.TextXAlignment = Enum.TextXAlignment.Left
    debugOutput.TextYAlignment = Enum.TextYAlignment.Top
    debugOutput.TextWrapped = true
    debugOutput.Parent = debugWindow.Content
    
    self.DebugOutput = debugOutput
end

function GuiFramework:debugLog(message)
    if self.DebugMode and self.DebugOutput then
        local timestamp = os.date("%H:%M:%S")
        self.DebugOutput.Text = self.DebugOutput.Text .. string.format("[%s] %s\n", timestamp, message)
    end
end

-- Performans optimizasyonu
function GuiFramework:optimizePerformance()
    -- Gereksiz animasyonları durdur
    FrameworkSettings.AnimationSpeed = 0.1
    
    -- Scrolling frame'lerin canvas size'ını otomatik ayarla
    for _, window in ipairs(self.Windows) do
        if window.Content and window.Content:IsA("ScrollingFrame") then
            local layout = window.Content:FindFirstChild("UIListLayout")
            if layout then
                layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    window.Content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
                end)
            end
        end
    end
end

-- Otomatik boyutlandırma
function GuiFramework:enableAutoSizing()
    -- Tüm text elementlerini otomatik boyutlandır
    local function setupAutoSizing(element)
        if element:IsA("TextLabel") or element:IsA("TextButton") then
            element.TextScaled = true
        end
        
        for _, child in ipairs(element:GetChildren()) do
            setupAutoSizing(child)
        end
    end
    
    setupAutoSizing(self.ScreenGui)
end

-- Element arama ve filtreleme
function GuiFramework:findElement(name)
    local function searchRecursive(parent, targetName)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name:find(targetName) then
                return child
            end
            local result = searchRecursive(child, targetName)
            if result then return result end
        end
        return nil
    end
    
    return searchRecursive(self.ScreenGui, name)
end

-- Dinamik layout sistemi
function GuiFramework:createDynamicLayout(parent, options)
    options = options or {}
    local layoutType = options.Type or "List" -- List, Grid, Flow
    
    if layoutType == "List" then
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, options.Padding or 5)
        layout.FillDirection = options.Direction or Enum.FillDirection.Vertical
        layout.Parent = parent
        return layout
        
    elseif layoutType == "Grid" then
        local layout = Instance.new("UIGridLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.CellPadding = UDim2.new(0, options.Padding or 5, 0, options.Padding or 5)
        layout.CellSize = options.CellSize or UDim2.new(0, 100, 0, 100)
        layout.Parent = parent
        return layout
        
    elseif layoutType == "Flow" then
        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, options.Padding or 5)
        layout.Wraps = true
        layout.Parent = parent
        return layout
    end
end

-- Tooltip sistemi
function GuiFramework:addTooltip(element, text)
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 40)
    tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tooltip.BackgroundTransparency = 0.2
    tooltip.BorderSizePixel = 0
    tooltip.Visible = false
    tooltip.ZIndex = 1000
    tooltip.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = tooltip
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Theme.Text
    label.Font = FrameworkSettings.DefaultFont
    label.TextScaled = true
    label.TextWrapped = true
    label.Parent = tooltip
    
    element.MouseEnter:Connect(function()
        tooltip.Visible = true
        tooltip.Position = UDim2.new(0, element.AbsolutePosition.X, 0, element.AbsolutePosition.Y - 50)
    end)
    
    element.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)
end

-- Animasyon sistemi
function GuiFramework:createCustomAnimation(element, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or FrameworkSettings.AnimationSpeed,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    
    return tween
end

-- Global güncelleme fonksiyonu
function GuiFramework:_updateAllElements()
    -- Tüm elementleri yeni tema ile güncelle
    local function updateRecursive(element)
        if element:IsA("Frame") or element:IsA("TextButton") then
            -- Renk güncellemeleri burada yapılır
        elseif element:IsA("TextLabel") then
            element.TextColor3 = self.Theme.Text
        end
        
        for _, child in ipairs(element:GetChildren()) do
            updateRecursive(child)
        end
    end
    
    updateRecursive(self.ScreenGui)
end

-- Framework'ü yok etme
function GuiFramework:destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    -- Tüm bağlantıları temizle
    for event, callbacks in pairs(self.Callbacks) do
        self.Callbacks[event] = {}
    end
    
    self.Windows = {}
    self.Tabs = {}
    self.Elements = {}
    self.Notifications = {}
end

-- Kullanım örneği ve API dokümantasyonu
--[[
KULLANIM ÖRNEĞİ:

-- Framework'ü başlat
local GUI = GuiFramework.new("MyGUI")

-- Window oluştur
local mainWindow = GUI:createWindow({
    Title = "Ana Window",
    Size = UDim2.new(0, 600, 0, 500),
    Position = UDim2.new(0.5, -300, 0.5, -250)
})

-- Tab oluştur
local homeTab = GUI:createTab(mainWindow, {
    Title = "Ana Sayfa",
    Icon = "🏠",
    Active = true
})

-- Elementler ekle
GUI:createButton(homeTab.Content, {
    Text = "Test Butonu",
    Callback = function()
        GUI:createNotification({
            Title = "Başarılı!",
            Text = "Buton tıklandı!",
            Type = "Success"
        })
    end
})

local toggle = GUI:createToggle(homeTab.Content, {
    Text = "Özellik Aç/Kapat",
    Default = false,
    Callback = function(value)
        print("Toggle değeri:", value)
    end
})

local slider = GUI:createSlider(homeTab.Content, {
    Text = "Hız Ayarı",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Hız:", value)
    end
})

-- Callback sistemi
GUI:onEvent("ButtonClicked", function(data)
    print("Buton tıklandı:", data.text)
end)

-- Tema değiştir
GUI:setTheme("Purple")

-- Dil değiştir
GUI:setLanguage("tr")

-- Debug modu
GUI:enableDebug()

TÜM ÖZELLİKLER:
✓ Kolay entegrasyon
✓ Modern tasarım
✓ Buton (Button)
✓ Anahtar (Toggle)
✓ Kaydırıcı (Slider)
✓ Metin kutusu (Textbox)
✓ Dropdown menü
✓ Renk seçici (Colorpicker)
✓ Sekmeler (Tabs)
✓ Bildirimler (Notification)
✓ Yüksek özelleştirilebilirlik
✓ Callback fonksiyonları
✓ Hafif ve performans dostu
✓ Kullanıcı dostu arayüz
✓ Dinamik tema desteği
✓ Kolay hata ayıklama
✓ Hızlı entegrasyon
✓ Alt sekmeler (Sub-tabs)
✓ Grup kutuları (Group boxes)
✓ Ayrı paneller (Separate windows/panels)
✓ Kaydırılabilir alanlar (Scrollable containers)
✓ Animasyonlu geçişler
✓ UI elemanları üzerinde fare efektleri (hover, click)
✓ Çoklu dil desteği
✓ Otomatik boyutlandırma
✓ UI öğeleri üzerinde kilitleme ve görünürlük kontrolü
✓ Keybind sistemi
✓ Progress bar
✓ Tooltip sistemi
✓ Dinamik layout
✓ Element arama
✓ Custom animasyonlar
✓ Performans optimizasyonu

]]

return GuiFramework
