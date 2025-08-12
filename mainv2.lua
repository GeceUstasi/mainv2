-- Keybind Creation
function PremiumGUI:createKeybind(parent, options)
    options = options or {}
    local keybindData = {
        Text = options.Text or "Keybind",
        Description = options.Description or nil,
        Default = options.Default or Enum.KeyCode.F,
        Disabled = options.Disabled or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, keybindData.Description and 75 or 55)
    container.BackgroundColor3 = DarkTheme.Surface
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    -- Glass effect
    local containerGlass = Instance.new("Frame")
    containerGlass.Size = UDim2.new(1, 0, 1, 0)
    containerGlass.BackgroundColor3 = DarkTheme.Glass
    containerGlass.BackgroundTransparency = 0.96
    containerGlass.BorderSizePixel = 0
    containerGlass.Parent = container
    
    local containerGlassCorner = Instance.new("UICorner")
    containerGlassCorner.CornerRadius = UDim.new(0, 10)
    containerGlassCorner.Parent = containerGlass
    
    -- Text container
    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, -100, 1, 0)
    textContainer.Position = UDim2.new(0, 20, 0, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = container
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, keybindData.Description and 8 or 15)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = keybindData.Text
    titleLabel.TextColor3 = keybindData.Disabled and DarkTheme.TextDisabled or DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = textContainer
    
    -- Description
    if keybindData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, 0, 0, 20)
        descLabel.Position = UDim2.new(0, 0, 0, 35)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = keybindData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = textContainer
    end
    
    -- Keybind button
    local keybindButton = Instance.new("TextButton")
    keybindButton.Size = UDim2.new(0, 70, 0, 30)
    keybindButton.Position = UDim2.new(1, -85, 0.5, -15)
    keybindButton.BackgroundColor3 = DarkTheme.Background
    keybindButton.BackgroundTransparency = 0.3
    keybindButton.BorderSizePixel = 0
    keybindButton.Text = keybindData.Default.Name
    keybindButton.TextColor3 = DarkTheme.TextPrimary
    keybindButton.Font = Enum.Font.GothamSemibold
    keybindButton.TextSize = 13
    keybindButton.AutoButtonColor = false
    keybindButton.Parent = container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = keybindButton
    
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = DarkTheme.Border
    buttonBorder.Thickness = 2
    buttonBorder.Transparency = 0.5
    buttonBorder.Parent = keybindButton
    
    local currentKey = keybindData.Default
    local isBinding = false
    
    -- Keybind detection
    keybindButton.MouseButton1Click:Connect(function()
        if not keybindData.Disabled then
            isBinding = true
            keybindButton.Text = "..."
            buttonBorder.Color = DarkTheme.Warning
            buttonBorder.Transparency = 0.2
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            keybindButton.Text = currentKey.Name
            isBinding = false
            buttonBorder.Color = DarkTheme.Border
            buttonBorder.Transparency = 0.5
            keybindData.Callback(currentKey)
        elseif not gameProcessed and input.KeyCode == currentKey then
            keybindData.Callback(currentKey)
        end
    end)
    
    -- Cancel binding on click outside
    UserInputService.InputBegan:Connect(function(input)
        if isBinding and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local buttonPos = keybindButton.AbsolutePosition
            local buttonSize = keybindButton.AbsoluteSize
            
            if mousePos.X < buttonPos.X or mousePos.X > buttonPos.X + buttonSize.X or 
               mousePos.Y < buttonPos.Y or mousePos.Y > buttonPos.Y + buttonSize.Y then
                isBinding = false
                keybindButton.Text = currentKey.Name
                buttonBorder.Color = DarkTheme.Border
                buttonBorder.Transparency = 0.5
            end
        end
    end)
    
    container.GetValue = function() return currentKey end
    container.SetValue = function(key)
        currentKey = key
        keybindButton.Text = key.Name
    end
    
    return container
end

-- Separator Creation
function PremiumGUI:createSeparator(parent, options)
    options = options or {}
    local separatorData = {
        Text = options.Text or nil,
        Size = options.Size or "Medium"
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, separatorData.Text and 35 or 15)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Separator line
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, separatorData.Text and -40 or 0, 0, 2)
    line.Position = UDim2.new(0, separatorData.Text and 20 or 0, 0.5, -1)
    line.BackgroundColor3 = DarkTheme.Border
    line.BackgroundTransparency = 0.3
    line.BorderSizePixel = 0
    line.Parent = container
    
    local lineCorner = Instance.new("UICorner")
    lineCorner.CornerRadius = UDim.new(1, 0)
    lineCorner.Parent = line
    
    -- Text label (if provided)
    if separatorData.Text then
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -40, 1, 0)
        textLabel.Position = UDim2.new(0, 20, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = separatorData.Text
        textLabel.TextColor3 = DarkTheme.TextMuted
        textLabel.Font = Enum.Font.GothamSemibold
        textLabel.TextSize = 14
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
        textLabel.Parent = container
    end
    
    return container
end

-- Folder/Group Creation
function PremiumGUI:createFolder(parent, options)
    options = options or {}
    local folderData = {
        Title = options.Title or "Folder",
        Icon = options.Icon or "📁",
        Open = options.Open ~= false
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundColor3 = DarkTheme.Surface
    container.BackgroundTransparency = 0.5
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    -- Glass effect
    local containerGlass = Instance.new("Frame")
    containerGlass.Size = UDim2.new(1, 0, 1, 0)
    containerGlass.BackgroundColor3 = DarkTheme.Glass
    containerGlass.BackgroundTransparency = 0.97
    containerGlass.BorderSizePixel = 0
    containerGlass.Parent = container
    
    local containerGlassCorner = Instance.new("UICorner")
    containerGlassCorner.CornerRadius = UDim.new(0, 10)
    containerGlassCorner.Parent = containerGlass
    
    -- Header
    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundTransparency = 1
    header.Text = ""
    header.AutoButtonColor = false
    header.Parent = container
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 15, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Text = folderData.Icon
    icon.TextColor3 = DarkTheme.Primary
    icon.Font = Enum.Font.Gotham
    icon.TextSize = 16
    icon.Parent = header
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 50, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = folderData.Title
    titleLabel.TextColor3 = DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Expand arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 0, 20)
    arrow.Position = UDim2.new(1, -35, 0.5, -10)
    arrow.BackgroundTransparency = 1
    arrow.Text = folderData.Open and "▼" or "▶"
    arrow.TextColor3 = DarkTheme.TextSecondary
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 12
    arrow.Parent = header
    
    -- Content area
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -30, 0, 0)
    content.Position = UDim2.new(0, 15, 0, 50)
    content.BackgroundTransparency = 1
    content.Visible = folderData.Open
    content.Parent = container
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = content
    
    -- Auto-size folder
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.Size = UDim2.new(1, -30, 0, contentLayout.AbsoluteContentSize.Y)
        container.Size = UDim2.new(1, 0, 0, 50 + (folderData.Open and contentLayout.AbsoluteContentSize.Y + 15 or 0))
    end)
    
    -- Toggle folder
    header.MouseButton1Click:Connect(function()
        folderData.Open = not folderData.Open
        content.Visible = folderData.Open
        arrow.Text = folderData.Open and "▼" or "▶"
        
        local targetSize = UDim2.new(1, 0, 0, 50 + (folderData.Open and contentLayout.AbsoluteContentSize.Y + 15 or 0))
        TweenService:Create(container, TweenInfo.new(0.3), {Size = targetSize}):Play()
    end)
    
    -- Hover effect
    self:_addHoverEffect(header)
    
    -- Initial size
    container.Size = UDim2.new(1, 0, 0, 50)
    
    return {
        Frame = container,
        Content = content,
        Layout = contentLayout,
        Header = header
    }
end

-- Image Creation
function PremiumGUI:createImage(parent, options)
    options = options or {}
    local imageData = {
        Image = options.Image or "rbxasset://textures/ui/GuiImagePlaceholder.png",
        Size = options.Size or UDim2.new(0, 100, 0, 100),
        ScaleType = options.ScaleType or Enum.ScaleType.Fit,
        Description = options.Description or nil
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, imageData.Size.Y.Offset + (imageData.Description and 25 or 0))
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    -- Image
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = imageData.Size
    imageLabel.Position = UDim2.new(0.5, -imageData.Size.X.Offset/2, 0, 0)
    imageLabel.BackgroundColor3 = DarkTheme.Surface
    imageLabel.BackgroundTransparency = 0.3
    imageLabel.BorderSizePixel = 0
    imageLabel.Image = imageData.Image
    imageLabel.ScaleType = imageData.ScaleType
    imageLabel.Parent = container
    
    local imageCorner = Instance.new("UICorner")
    imageCorner.CornerRadius = UDim.new(0, 10)
    imageCorner.Parent = imageLabel
    
    local imageBorder = Instance.new("UIStroke")
    imageBorder.Color = DarkTheme.BorderLight
    imageBorder.Thickness = 2
    imageBorder.Transparency = 0.5
    imageBorder.Parent = imageLabel
    
    -- Description
    if imageData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, 0, 0, 20)
        descLabel.Position = UDim2.new(0, 0, 1, -20)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = imageData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Center
        descLabel.Parent = container
    end
    
    return imageLabel
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
        Type = options.Type or "Info", -- Info, Success, Warning, Error
        Duration = options.Duration or 5,
        Actions = options.Actions or nil
    }
    
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, 0, 0, notificationData.Actions and 120 or 80)
    notification.BackgroundColor3 = DarkTheme.Surface
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = self.NotificationContainer
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 12)
    notificationCorner.Parent = notification
    
    -- Glass effect
    local notificationGlass = Instance.new("Frame")
    notificationGlass.Size = UDim2.new(1, 0, 1, 0)
    notificationGlass.BackgroundColor3 = DarkTheme.Glass
    notificationGlass.BackgroundTransparency = 0.95
    notificationGlass.BorderSizePixel = 0
    notificationGlass.Parent = notification
    
    local notificationGlassCorner = Instance.new("UICorner")
    notificationGlassCorner.CornerRadius = UDim.new(0, 12)
    notificationGlassCorner.Parent = notificationGlass
    
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
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = DarkTheme.Error
    closeButton.BackgroundTransparency = 0.8
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = DarkTheme.TextPrimary
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 12
    closeButton.AutoButtonColor = false
    closeButton.Parent = notification
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    -- Actions (if provided)
    if notificationData.Actions then
        local actionsContainer = Instance.new("Frame")
        actionsContainer.Size = UDim2.new(1, -20, 0, 35)
        actionsContainer.Position = UDim2.new(0, 10, 1, -40)
        actionsContainer.BackgroundTransparency = 1
        actionsContainer.Parent = notification
        
        local actionsLayout = Instance.new("UIListLayout")
        actionsLayout.FillDirection = Enum.FillDirection.Horizontal
        actionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        actionsLayout.Padding = UDim.new(0, 8)
        actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        actionsLayout.Parent = actionsContainer
        
        for _, action in ipairs(notificationData.Actions) do
            local actionButton = Instance.new("TextButton")
            actionButton.Size = UDim2.new(0, 80, 1, 0)
            actionButton.BackgroundColor3 = action.Style == "Primary" and DarkTheme.Primary or DarkTheme.Surface
            actionButton.BackgroundTransparency = 0.2
            actionButton.BorderSizePixel = 0
            actionButton.Text = action.Text
            actionButton.TextColor3 = DarkTheme.TextPrimary
            actionButton.Font = Enum.Font.GothamSemibold
            actionButton.TextSize = 12
            actionButton.AutoButtonColor = false
            actionButton.Parent = actionsContainer
            
            local actionCorner = Instance.new("UICorner")
            actionCorner.CornerRadius = UDim.new(0, 6)
            actionCorner.Parent = actionButton
            
            actionButton.MouseButton1Click:Connect(function()
                if action.Callback then
                    action.Callback()
                end
                self:_removeNotification(notification)
            end)
        end
    end
    
    -- Entrance animation
    notification.Position = UDim2.new(1, 50, 0, 0)
    notification.BackgroundTransparency = 1
    
    TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.1
    }):Play()
    
    -- Auto remove
    task.wait(notificationData.Duration)
    self:_removeNotification(notification)
    
    -- Close button
    closeButton.MouseButton1Click:Connect(function()
        self:_removeNotification(notification)
    end)
    
    return notification
endner.CornerRadius = UDim.new(0, 10)
    popupCorner.Parent = colorPopup
    
    local popupBorder = Instance.new("UIStroke")
    popupBorder.Color = DarkTheme.BorderLight
    popupBorder.Thickness = 2
    popupBorder.Transparency = 0.3
    popupBorder.Parent = colorPopup
    
    -- Color grid
    local colorGrid = Instance.new("Frame")
    colorGrid.Size = UDim2.new(1, -20, 1, -20)
    colorGrid.Position = UDim2.new(0, 10, 0, 10)
    colorGrid.BackgroundTransparency = 1
    colorGrid.Parent = colorPopup
    
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.CellSize = UDim2.new(0, 30, 0, 30)
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.Parent = colorGrid
    
    -- Create color buttons
    for i, color in ipairs(colorPalette) do
        local colorButton = Instance.new("TextButton")
        colorButton.Size = UDim2.new(0, 30, 0, 30)
        colorButton.BackgroundColor3 = color
        colorButton.BorderSizePixel = 0
        colorButton.Text = ""
        colorButton.Parent = colorGrid
        
        local colorCorner = Instance.new("UICorner")
        colorCorner.CornerRadius = UDim.new(0, 6)
        colorCorner.Parent = colorButton
        
        local colorBorder = Instance.new("UIStroke")
        colorBorder.Color = DarkTheme.BorderLight
        colorBorder.Thickness = 1
        colorBorder.Transparency = 0.5
        colorBorder.Parent = colorButton
        
        colorButton.MouseButton1Click:Connect(function()
            currentColor = color
            colorPreview.BackgroundColor3 = color
            colorPopup.Visible = false
            colorData.Callback(color)
        end)
        
        -- Hover effect
        colorButton.MouseEnter:Connect(function()
            TweenService:Create(colorBorder, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
        end)
        
        colorButton.MouseLeave:Connect(function()
            TweenService:Create(colorBorder, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
        end)
    end
    
    -- Toggle color picker
    pickerButton.MouseButton1Click:Connect(function()
        if not colorData.Disabled then
            colorPopup.Visible = not colorPopup.Visible
        end
    end)
    
    container.GetValue = function() return currentColor end
    container.SetValue = function(color)
        currentColor = color
        colorPreview.BackgroundColor3 = color
    end
    
    return container
end

-- Keybind Creation
function PremiumGUI:createKeybind(parent, options)
    options = options or {}
    local keybindData-- Dropdown Creation
function PremiumGUI:createDropdown(parent, options)
    options = options or {}
    local dropdownData = {
        Text = options.Text or "Dropdown",
        Description = options.Description or nil,
        Options = options.Options or {"Option 1", "Option 2", "Option 3"},
        Default = options.Default or options.Options[1],
        Searchable = options.Searchable or false,
        MaxHeight = options.MaxHeight or 250,
        Disabled = options.Disabled or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, dropdownData.Description and 95 or 75)
    container.BackgroundColor3 = DarkTheme.Surface
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    -- Glass effect
    local containerGlass = Instance.new("Frame")
    containerGlass.Size = UDim2.new(1, 0, 1, 0)
    containerGlass.BackgroundColor3 = DarkTheme.Glass
    containerGlass.BackgroundTransparency = 0.96
    containerGlass.BorderSizePixel = 0
    containerGlass.Parent = container
    
    local containerGlassCorner = Instance.new("UICorner")
    containerGlassCorner.CornerRadius = UDim.new(0, 10)
    containerGlassCorner.Parent = containerGlass
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -40, 0, 30)
    header.Position = UDim2.new(0, 20, 0, 10)
    header.BackgroundTransparency = 1
    header.Parent = container
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = dropdownData.Text
    titleLabel.TextColor3 = dropdownData.Disabled and DarkTheme.TextDisabled or DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Description
    if dropdownData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -40, 0, 20)
        descLabel.Position = UDim2.new(0, 20, 0, 40)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = dropdownData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = container
    end
    
    -- Dropdown button
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(1, -40, 0, 35)
    dropdownButton.Position = UDim2.new(0, 20, 1, -45)
    dropdownButton.BackgroundColor3 = DarkTheme.Background
    dropdownButton.BackgroundTransparency = 0.3
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = ""
    dropdownButton.AutoButtonColor = false
    dropdownButton.Parent = container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = dropdownButton
    
    -- Button border
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = DarkTheme.Border
    buttonBorder.Thickness = 2
    buttonBorder.Transparency = 0.5
    buttonBorder.Parent = dropdownButton
    
    -- Button content
    local buttonContent = Instance.new("Frame")
    buttonContent.Size = UDim2.new(1, -20, 1, 0)
    buttonContent.Position = UDim2.new(0, 10, 0, 0)
    buttonContent.BackgroundTransparency = 1
    buttonContent.Parent = dropdownButton
    
    -- Selected text
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(1, -25, 1, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = dropdownData.Default
    selectedLabel.TextColor3 = DarkTheme.TextPrimary
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.Parent = buttonContent
    
    -- Dropdown arrow
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 25, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = DarkTheme.TextSecondary
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 14
    arrow.Parent = buttonContent
    
    -- Dropdown list
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(1, -40, 0, math.min(#dropdownData.Options * 40 + (dropdownData.Searchable and 50 or 10), dropdownData.MaxHeight))
    dropdownList.Position = UDim2.new(0, 20, 1, -10)
    dropdownList.BackgroundColor3 = DarkTheme.Surface
    dropdownList.BackgroundTransparency = 0.1
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.ZIndex = 15
    dropdownList.Parent = container
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = dropdownList
    
    -- List border
    local listBorder = Instance.new("UIStroke")
    listBorder.Color = DarkTheme.BorderLight
    listBorder.Thickness = 2
    listBorder.Transparency = 0.3
    listBorder.Parent = dropdownList
    
    -- Search box
    local searchBox
    if dropdownData.Searchable then
        searchBox = Instance.new("TextBox")
        searchBox.Size = UDim2.new(1, -20, 0, 35)
        searchBox.Position = UDim2.new(0, 10, 0, 8)
        searchBox.BackgroundColor3 = DarkTheme.Background
        searchBox.BackgroundTransparency = 0.3
        searchBox.BorderSizePixel = 0
        searchBox.PlaceholderText = "Search options..."
        searchBox.PlaceholderColor3 = DarkTheme.TextMuted
        searchBox.Text = ""
        searchBox.TextColor3 = DarkTheme.TextPrimary
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 14
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.Parent = dropdownList
        
        local searchCorner = Instance.new("UICorner")
        searchCorner.CornerRadius = UDim.new(0, 6)
        searchCorner.Parent = searchBox
    end
    
    -- Options container
    local optionsContainer = Instance.new("ScrollingFrame")
    optionsContainer.Size = UDim2.new(1, -10, 1, dropdownData.Searchable and -55 or -10)
    optionsContainer.Position = UDim2.new(0, 5, 0, dropdownData.Searchable and 50 or 5)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.BorderSizePixel = 0
    optionsContainer.ScrollBarThickness = 6
    optionsContainer.ScrollBarImageColor3 = DarkTheme.Primary
    optionsContainer.ScrollBarImageTransparency = 0.5
    optionsContainer.CanvasSize = UDim2.new(0, 0, 0, #dropdownData.Options * 40)
    optionsContainer.Parent = dropdownList
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsContainer
    
    -- Create option buttons
    local selectedValue = dropdownData.Default
    local optionButtons = {}
    
    for i, option in ipairs(dropdownData.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Size = UDim2.new(1, -10, 0, 38)
        optionButton.BackgroundColor3 = DarkTheme.SurfaceHover
        optionButton.BackgroundTransparency = 0.8
        optionButton.BorderSizePixel = 0
        optionButton.Text = ""
        optionButton.AutoButtonColor = false
        optionButton.Parent = optionsContainer
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 6)
        optionCorner.Parent = optionButton
        
        local optionLabel = Instance.new("TextLabel")
        optionLabel.Size = UDim2.new(1, -20, 1, 0)
        optionLabel.Position = UDim2.new(0, 10, 0, 0)
        optionLabel.BackgroundTransparency = 1
        optionLabel.Text = option
        optionLabel.TextColor3 = DarkTheme.TextPrimary
        optionLabel.Font = Enum.Font.Gotham
        optionLabel.TextSize = 14
        optionLabel.TextXAlignment = Enum.TextXAlignment.Left
        optionLabel.Parent = optionButton
        
        -- Click event
        optionButton.MouseButton1Click:Connect(function()
            selectedValue = option
            selectedLabel.Text = option
            dropdownList.Visible = false
            arrow.Text = "▼"
            dropdownData.Callback(option)
        end)
        
        -- Hover effect
        optionButton.MouseEnter:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            TweenService:Create(optionButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
        end)
        
        table.insert(optionButtons, {Button = optionButton, Label = optionLabel, Text = option})
    end
    
    -- Search functionality
    if dropdownData.Searchable then
        searchBox.Changed:Connect(function(property)
            if property == "Text" then
                local searchText = searchBox.Text:lower()
                for _, optionData in ipairs(optionButtons) do
                    local visible = searchText == "" or optionData.Text:lower():find(searchText)
                    optionData.Button.Visible = visible
                end
            end
        end)
    end
    
    -- Toggle dropdown
    local isOpen = false
    dropdownButton.MouseButton1Click:Connect(function()
        if not dropdownData.Disabled then
            isOpen = not isOpen
            dropdownList.Visible = isOpen
            arrow.Text = isOpen and "▲" or "▼"
            
            if isOpen and dropdownData.Searchable then
                searchBox:CaptureFocus()
            end
        end
    end)
    
    -- Close dropdown when clicking outside
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local listPos = dropdownList.AbsolutePosition
            local listSize = dropdownList.AbsoluteSize
            
            if isOpen and (mousePos.X < listPos.X or mousePos.X > listPos.X + listSize.X or 
                          mousePos.Y < listPos.Y or mousePos.Y > listPos.Y + listSize.Y) then
                isOpen = false
                dropdownList.Visible = false
                arrow.Text = "▼"
            end
        end
    end)
    
    container.GetValue = function() return selectedValue end
    container.SetValue = function(value)
        selectedValue = value
        selectedLabel.Text = value
    end
    
    return container
end

-- Multi-Select Dropdown
function PremiumGUI:createMultiDropdown(parent, options)
    options = options or {}
    local multiData = {
        Text = options.Text or "Multi-Select",
        Description = options.Description or nil,
        Options = options.Options or {"Option 1", "Option 2", "Option 3"},
        Default = options.Default or {},
        MaxSelections = options.MaxSelections or nil,
        Disabled = options.Disabled or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, multiData.Description and 95 or 75)
    container.BackgroundColor3 = DarkTheme.Surface
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    -- Glass effect
    local containerGlass = Instance.new("Frame")
    containerGlass.Size = UDim2.new(1, 0, 1, 0)
    containerGlass.BackgroundColor3 = DarkTheme.Glass
    containerGlass.BackgroundTransparency = 0.96
    containerGlass.BorderSizePixel = 0
    containerGlass.Parent = container
    
    local containerGlassCorner = Instance.new("UICorner")
    containerGlassCorner.CornerRadius = UDim.new(0, 10)
    containerGlassCorner.Parent = containerGlass
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -40, 0, 30)
    header.Position = UDim2.new(0, 20, 0, 10)
    header.BackgroundTransparency = 1
    header.Parent = container
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = multiData.Text
    titleLabel.TextColor3 = multiData.Disabled and DarkTheme.TextDisabled or DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Description
    if multiData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -40, 0, 20)
        descLabel.Position = UDim2.new(0, 20, 0, 40)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = multiData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = container
    end
    
    local selectedValues = {}
    for _, value in ipairs(multiData.Default) do
        selectedValues[value] = true
    end
    
    -- Display selected count
    local multiButton = Instance.new("TextButton")
    multiButton.Size = UDim2.new(1, -40, 0, 35)
    multiButton.Position = UDim2.new(0, 20, 1, -45)
    multiButton.BackgroundColor3 = DarkTheme.Background
    multiButton.BackgroundTransparency = 0.3
    multiButton.BorderSizePixel = 0
    multiButton.Text = ""
    multiButton.AutoButtonColor = false
    multiButton.Parent = container
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = multiButton
    
    local buttonBorder = Instance.new("UIStroke")
    buttonBorder.Color = DarkTheme.Border
    buttonBorder.Thickness = 2
    buttonBorder.Transparency = 0.5
    buttonBorder.Parent = multiButton
    
    local buttonContent = Instance.new("Frame")
    buttonContent.Size = UDim2.new(1, -20, 1, 0)
    buttonContent.Position = UDim2.new(0, 10, 0, 0)
    buttonContent.BackgroundTransparency = 1
    buttonContent.Parent = multiButton
    
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(1, -25, 1, 0)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = #multiData.Default > 0 and (#multiData.Default .. " selected") or "None selected"
    selectedLabel.TextColor3 = DarkTheme.TextPrimary
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.Parent = buttonContent
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 25, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = DarkTheme.TextSecondary
    arrow.Font = Enum.Font.Gotham
    arrow.TextSize = 14
    arrow.Parent = buttonContent
    
    -- Multi-select list
    local multiList = Instance.new("Frame")
    multiList.Size = UDim2.new(1, -40, 0, math.min(#multiData.Options * 40 + 10, 250))
    multiList.Position = UDim2.new(0, 20, 1, -10)
    multiList.BackgroundColor3 = DarkTheme.Surface
    multiList.BackgroundTransparency = 0.1
    multiList.BorderSizePixel = 0
    multiList.Visible = false
    multiList.ZIndex = 15
    multiList.Parent = container
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = multiList
    
    local listBorder = Instance.new("UIStroke")
    listBorder.Color = DarkTheme.BorderLight
    listBorder.Thickness = 2
    listBorder.Transparency = 0.3
    listBorder.Parent = multiList
    
    -- Options container
    local optionsContainer = Instance.new("ScrollingFrame")
    optionsContainer.Size = UDim2.new(1, -10, 1, -10)
    optionsContainer.Position = UDim2.new(0, 5, 0, 5)
    optionsContainer.BackgroundTransparency = 1
    optionsContainer.BorderSizePixel = 0
    optionsContainer.ScrollBarThickness = 6
    optionsContainer.ScrollBarImageColor3 = DarkTheme.Primary
    optionsContainer.ScrollBarImageTransparency = 0.5
    optionsContainer.CanvasSize = UDim2.new(0, 0, 0, #multiData.Options * 40)
    optionsContainer.Parent = multiList
    
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Padding = UDim.new(0, 2)
    optionsLayout.Parent = optionsContainer
    
    -- Create option checkboxes
    local function updateSelectedDisplay()
        local count = 0
        for _ in pairs(selectedValues) do
            count = count + 1
        end
        selectedLabel.Text = count > 0 and (count .. " selected") or "None selected"
        
        local selectedList = {}
        for value in pairs(selectedValues) do
            table.insert(selectedList, value)
        end
        multiData.Callback(selectedList)
    end
    
    for i, option in ipairs(multiData.Options) do
        local optionContainer = Instance.new("Frame")
        optionContainer.Size = UDim2.new(1, -10, 0, 38)
        optionContainer.BackgroundColor3 = DarkTheme.SurfaceHover
        optionContainer.BackgroundTransparency = 0.8
        optionContainer.BorderSizePixel = 0
        optionContainer.Parent = optionsContainer
        
        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 6)
        optionCorner.Parent = optionContainer
        
        -- Checkbox
        local checkbox = Instance.new("Frame")
        checkbox.Size = UDim2.new(0, 20, 0, 20)
        checkbox.Position = UDim2.new(0, 10, 0.5, -10)
        checkbox.BackgroundColor3 = selectedValues[option] and DarkTheme.Primary or DarkTheme.Background
        checkbox.BackgroundTransparency = 0.2
        checkbox.BorderSizePixel = 0
        checkbox.Parent = optionContainer
        
        local checkboxCorner = Instance.new("UICorner")
        checkboxCorner.CornerRadius = UDim.new(0, 4)
        checkboxCorner.Parent = checkbox
        
        local checkboxBorder = Instance.new("UIStroke")
        checkboxBorder.Color = DarkTheme.Border
        checkboxBorder.Thickness = 2
        checkboxBorder.Transparency = 0.5
        checkboxBorder.Parent = checkbox
        
        -- Checkmark
        local checkmark = Instance.new("TextLabel")
        checkmark.Size = UDim2.new(1, 0, 1, 0)
        checkmark.BackgroundTransparency = 1
        checkmark.Text = selectedValues[option] and "✓" or ""
        checkmark.TextColor3 = DarkTheme.TextPrimary
        checkmark.Font = Enum.Font.GothamBold
        checkmark.TextSize = 14
        checkmark.Parent = checkbox
        
        -- Option label
        local optionLabel = Instance.new("TextLabel")
        optionLabel.Size = UDim2.new(1, -50, 1, 0)
        optionLabel.Position = UDim2.new(0, 40, 0, 0)
        optionLabel.BackgroundTransparency = 1
        optionLabel.Text = option
        optionLabel.TextColor3 = DarkTheme.TextPrimary
        optionLabel.Font = Enum.Font.Gotham
        optionLabel.TextSize = 14
        optionLabel.TextXAlignment = Enum.TextXAlignment.Left
        optionLabel.Parent = optionContainer
        
        -- Click detector
        local clickDetector = Instance.new("TextButton")
        clickDetector.Size = UDim2.new(1, 0, 1, 0)
        clickDetector.BackgroundTransparency = 1
        clickDetector.Text = ""
        clickDetector.Parent = optionContainer
        
        clickDetector.MouseButton1Click:Connect(function()
            if multiData.MaxSelections then
                local currentCount = 0
                for _ in pairs(selectedValues) do
                    currentCount = currentCount + 1
                end
                
                if not selectedValues[option] and currentCount >= multiData.MaxSelections then
                    return
                end
            end
            
            selectedValues[option] = not selectedValues[option] or nil
            checkbox.BackgroundColor3 = selectedValues[option] and DarkTheme.Primary or DarkTheme.Background
            checkmark.Text = selectedValues[option] and "✓" or ""
            updateSelectedDisplay()
        end)
        
        -- Hover effect
        clickDetector.MouseEnter:Connect(function()
            TweenService:Create(optionContainer, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end)
        
        clickDetector.MouseLeave:Connect(function()
            TweenService:Create(optionContainer, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
        end)
    end
    
    -- Toggle multi-select
    local isOpen = false
    multiButton.MouseButton1Click:Connect(function()
        if not multiData.Disabled then
            isOpen = not isOpen
            multiList.Visible = isOpen
            arrow.Text = isOpen and "▲" or "▼"
        end
    end)
    
    container.GetValue = function()
        local selectedList = {}
        for value in pairs(selectedValues) do
            table.insert(selectedList, value)
        end
        return selectedList
    end
    
    container.SetValue = function(values)
        selectedValues = {}
        for _, value in ipairs(values) do
            selectedValues[value] = true
        end
        updateSelectedDisplay()
    end
    
    return container
end-- ULTRA PREMIUM MODERN GUI FRAMEWORK
-- Dark, Şeffaf, Modern, Ultra Professional
-- Tüm bileşenler dahil: Window, Tab, Section, Label, Paragraph, Button, Toggle, 
-- Slider, TextBox, Dropdown, MultiDropdown, ColorPicker, Keybind, Notification, 
-- Dialog, Separator, Folder, Image

local PremiumGUI = {}
PremiumGUI.__index = PremiumGUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")
local StarterPlayer = game:GetService("StarterPlayer")

-- Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Ultra Modern Dark Theme - Premium
local DarkTheme = {
    -- Ana renkler (Modern Dark + Premium)
    Primary = Color3.fromRGB(147, 51, 234),        -- Deep Purple
    Secondary = Color3.fromRGB(99, 102, 241),      -- Indigo
    Accent = Color3.fromRGB(34, 197, 94),          -- Emerald Green
    
    -- Arka plan renkleri (Ultra Dark + Transparency)
    Background = Color3.fromRGB(9, 9, 11),         -- Ultra Dark
    Surface = Color3.fromRGB(15, 15, 19),          -- Dark Surface
    SurfaceLight = Color3.fromRGB(20, 20, 26),     -- Light Surface
    SurfaceHover = Color3.fromRGB(28, 28, 35),     -- Hover Surface
    
    -- Glass effects
    Glass = Color3.fromRGB(255, 255, 255),         -- White glass
    GlassDark = Color3.fromRGB(0, 0, 0),          -- Dark glass
    Overlay = Color3.fromRGB(0, 0, 0),             -- Modal overlay
    
    -- Metin renkleri (Premium)
    TextPrimary = Color3.fromRGB(248, 250, 252),   -- Almost white
    TextSecondary = Color3.fromRGB(203, 213, 225), -- Light gray
    TextMuted = Color3.fromRGB(148, 163, 184),     -- Medium gray
    TextDisabled = Color3.fromRGB(71, 85, 105),    -- Dark gray
    
    -- Status colors (Modern)
    Success = Color3.fromRGB(34, 197, 94),         -- Green
    Warning = Color3.fromRGB(251, 146, 60),        -- Orange
    Error = Color3.fromRGB(239, 68, 68),           -- Red
    Info = Color3.fromRGB(59, 130, 246),           -- Blue
    
    -- Border colors (Subtle)
    Border = Color3.fromRGB(30, 41, 59),           -- Dark border
    BorderLight = Color3.fromRGB(51, 65, 85),      -- Light border
    BorderAccent = Color3.fromRGB(147, 51, 234),   -- Accent border
    
    -- Effects
    Shadow = Color3.fromRGB(0, 0, 0),
    Glow = Color3.fromRGB(147, 51, 234),
}

-- Premium Animation Config
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
    self.Prompts = {}
    self.IsVisible = true
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "PremiumGUI_" .. self.Title
    self.ScreenGui.Parent = PlayerGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 100
    
    -- Initialize systems
    self:_initializeNotificationSystem()
    self:_initializePromptSystem()
    
    return self
end

-- Window Creation
function PremiumGUI:createWindow(options)
    options = options or {}
    local windowData = {
        Title = options.Title or "Premium Window",
        Size = options.Size or UDim2.new(0, 1200, 0, 800),
        Position = options.Position or UDim2.new(0.5, -600, 0.5, -400),
        Resizable = options.Resizable ~= false,
        Minimizable = options.Minimizable ~= false,
        Closable = options.Closable ~= false,
        Draggable = options.Draggable ~= false
    }
    
    -- Main window with glass effect
    local window = Instance.new("Frame")
    window.Name = "PremiumWindow"
    window.Size = windowData.Size
    window.Position = windowData.Position
    window.BackgroundColor3 = DarkTheme.Background
    window.BackgroundTransparency = 0.1
    window.BorderSizePixel = 0
    window.Parent = self.ScreenGui
    
    -- Ultra premium corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = window
    
    -- Glass backdrop effect
    local glassEffect = Instance.new("Frame")
    glassEffect.Size = UDim2.new(1, 0, 1, 0)
    glassEffect.BackgroundColor3 = DarkTheme.Glass
    glassEffect.BackgroundTransparency = 0.95
    glassEffect.BorderSizePixel = 0
    glassEffect.Parent = window
    
    local glassCorner = Instance.new("UICorner")
    glassCorner.CornerRadius = UDim.new(0, 20)
    glassCorner.Parent = glassEffect
    
    -- Premium border with gradient effect
    local border = Instance.new("UIStroke")
    border.Color = DarkTheme.BorderLight
    border.Thickness = 2
    border.Transparency = 0.3
    border.Parent = window
    
    -- Drop shadow
    self:_addDropShadow(window)
    
    -- Title bar
    local titleBar = self:_createTitleBar(window, windowData)
    
    -- Sidebar for tabs
    local sidebar = self:_createSidebar(window)
    
    -- Main content area
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
    
    -- Title text with premium styling
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
    
    -- Control buttons
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 150, 0, 40)
    controls.Position = UDim2.new(1, -170, 0.5, -20)
    controls.BackgroundTransparency = 1
    controls.Parent = titleBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.Padding = UDim.new(0, 10)
    controlsLayout.Parent = controls
    
    -- Minimize button
    if data.Minimizable then
        self:_createControlButton(controls, "🗕", DarkTheme.Warning, function()
            self:_minimizeWindow(parent)
        end)
    end
    
    -- Close button
    if data.Closable then
        self:_createControlButton(controls, "✕", DarkTheme.Error, function()
            self:_closeWindow(parent)
        end)
    end
    
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
    
    -- Glass effect for sidebar
    local sidebarGlass = Instance.new("Frame")
    sidebarGlass.Size = UDim2.new(1, 0, 1, 0)
    sidebarGlass.BackgroundColor3 = DarkTheme.Glass
    sidebarGlass.BackgroundTransparency = 0.97
    sidebarGlass.BorderSizePixel = 0
    sidebarGlass.Parent = sidebar
    
    local sidebarGlassCorner = Instance.new("UICorner")
    sidebarGlassCorner.CornerRadius = UDim.new(0, 15)
    sidebarGlassCorner.Parent = sidebarGlass
    
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
    
    -- Auto resize canvas
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
    
    -- Glass effect for content
    local contentGlass = Instance.new("Frame")
    contentGlass.Size = UDim2.new(1, 0, 1, 0)
    contentGlass.BackgroundColor3 = DarkTheme.Glass
    contentGlass.BackgroundTransparency = 0.98
    contentGlass.BorderSizePixel = 0
    contentGlass.Parent = content
    
    local contentGlassCorner = Instance.new("UICorner")
    contentGlassCorner.CornerRadius = UDim.new(0, 15)
    contentGlassCorner.Parent = contentGlass
    
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
    
    -- Active indicator
    if tabData.Active then
        local activeIndicator = Instance.new("Frame")
        activeIndicator.Size = UDim2.new(0, 4, 0.8, 0)
        activeIndicator.Position = UDim2.new(0, 6, 0.1, 0)
        activeIndicator.BackgroundColor3 = DarkTheme.Primary
        activeIndicator.BorderSizePixel = 0
        activeIndicator.Parent = tabButton
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = activeIndicator
    end
    
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
    
    -- Auto resize canvas
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 30)
    end)
    
    -- Click event
    tabButton.MouseButton1Click:Connect(function()
        self:_switchTab(window, tabData.Title)
    end)
    
    -- Hover effects
    self:_addHoverEffect(tabButton)
    
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
    
    -- Glass effect
    local sectionGlass = Instance.new("Frame")
    sectionGlass.Size = UDim2.new(1, 0, 1, 0)
    sectionGlass.BackgroundColor3 = DarkTheme.Glass
    sectionGlass.BackgroundTransparency = 0.97
    sectionGlass.BorderSizePixel = 0
    sectionGlass.Parent = section
    
    local sectionGlassCorner = Instance.new("UICorner")
    sectionGlassCorner.CornerRadius = UDim.new(0, 12)
    sectionGlassCorner.Parent = sectionGlass
    
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

-- Label Creation
function PremiumGUI:createLabel(parent, options)
    options = options or {}
    local labelData = {
        Text = options.Text or "Label",
        Size = options.Size or "Medium",
        Color = options.Color or "Primary"
    }
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, self:_getLabelHeight(labelData.Size))
    label.BackgroundTransparency = 1
    label.Text = labelData.Text
    label.TextColor3 = self:_getLabelColor(labelData.Color)
    label.Font = Enum.Font.Gotham
    label.TextSize = self:_getLabelTextSize(labelData.Size)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextWrapped = true
    label.Parent = parent
    
    return label
end

-- Paragraph Creation
function PremiumGUI:createParagraph(parent, options)
    options = options or {}
    local paragraphData = {
        Title = options.Title or nil,
        Text = options.Text or "Paragraph text",
        Size = options.Size or "Medium"
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    layout.Parent = container
    
    -- Title
    if paragraphData.Title then
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, 0, 0, 28)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = paragraphData.Title
        titleLabel.TextColor3 = DarkTheme.TextPrimary
        titleLabel.Font = Enum.Font.GothamSemibold
        titleLabel.TextSize = 15
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = container
    end
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = paragraphData.Text
    textLabel.TextColor3 = DarkTheme.TextSecondary
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = self:_getLabelTextSize(paragraphData.Size)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.TextWrapped = true
    textLabel.Parent = container
    
    -- Auto-size
    local function updateSize()
        local textBounds = TextService:GetTextSize(
            textLabel.Text,
            textLabel.TextSize,
            textLabel.Font,
            Vector2.new(textLabel.AbsoluteSize.X, math.huge)
        )
        textLabel.Size = UDim2.new(1, 0, 0, textBounds.Y)
    end
    
    textLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    RunService.Heartbeat:Wait()
    updateSize()
    
    return container
end

-- Button Creation
function PremiumGUI:createButton(parent, options)
    options = options or {}
    local buttonData = {
        Text = options.Text or "Button",
        Icon = options.Icon or nil,
        Style = options.Style or "Primary",
        Size = options.Size or "Medium",
        Disabled = options.Disabled or false,
        Callback = options.Callback or function() end
    }
    
    local buttonHeight = self:_getButtonHeight(buttonData.Size)
    local buttonSize = buttonData.Size == "Full" and UDim2.new(1, 0, 0, buttonHeight) or 
                      UDim2.new(0, self:_getButtonWidth(buttonData.Size), 0, buttonHeight)
    
    local button = Instance.new("TextButton")
    button.Size = buttonSize
    button.BackgroundColor3 = self:_getButtonColor(buttonData.Style, "Background")
    button.BackgroundTransparency = buttonData.Style == "Ghost" and 0.8 or 0.2
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = button
    
    -- Glass effect
    local buttonGlass = Instance.new("Frame")
    buttonGlass.Size = UDim2.new(1, 0, 1, 0)
    buttonGlass.BackgroundColor3 = DarkTheme.Glass
    buttonGlass.BackgroundTransparency = 0.92
    buttonGlass.BorderSizePixel = 0
    buttonGlass.Parent = button
    
    local buttonGlassCorner = Instance.new("UICorner")
    buttonGlassCorner.CornerRadius = UDim.new(0, 10)
    buttonGlassCorner.Parent = buttonGlass
    
    -- Border for ghost style
    if buttonData.Style == "Ghost" then
        local buttonBorder = Instance.new("UIStroke")
        buttonBorder.Color = self:_getButtonColor(buttonData.Style, "Border")
        buttonBorder.Thickness = 2
        buttonBorder.Transparency = 0.4
        buttonBorder.Parent = button
    end
    
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
        iconLabel.TextColor3 = self:_getButtonColor(buttonData.Style, "Text")
        iconLabel.Font = Enum.Font.Gotham
        iconLabel.TextSize = 16
        iconLabel.Parent = content
    end
    
    -- Text
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = buttonData.Text
    textLabel.TextColor3 = self:_getButtonColor(buttonData.Style, "Text")
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = self:_getButtonTextSize(buttonData.Size)
    textLabel.AutomaticSize = Enum.AutomaticSize.X
    textLabel.Parent = content
    
    -- Disabled state
    if buttonData.Disabled then
        button.BackgroundTransparency = 0.8
        textLabel.TextColor3 = DarkTheme.TextDisabled
        if buttonData.Icon then
            content:FindFirstChild("TextLabel").TextColor3 = DarkTheme.TextDisabled
        end
    end
    
    -- Click event
    if not buttonData.Disabled then
        button.MouseButton1Click:Connect(function()
            self:_animateButtonClick(button)
            buttonData.Callback()
        end)
        
        self:_addHoverEffect(button)
    end
    
    return button
end

-- Toggle Creation
function PremiumGUI:createToggle(parent, options)
    options = options or {}
    local toggleData = {
        Text = options.Text or "Toggle",
        Description = options.Description or nil,
        Default = options.Default or false,
        Disabled = options.Disabled or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, toggleData.Description and 75 or 50)
    container.BackgroundColor3 = DarkTheme.Surface
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    -- Glass effect
    local containerGlass = Instance.new("Frame")
    containerGlass.Size = UDim2.new(1, 0, 1, 0)
    containerGlass.BackgroundColor3 = DarkTheme.Glass
    containerGlass.BackgroundTransparency = 0.96
    containerGlass.BorderSizePixel = 0
    containerGlass.Parent = container
    
    local containerGlassCorner = Instance.new("UICorner")
    containerGlassCorner.CornerRadius = UDim.new(0, 10)
    containerGlassCorner.Parent = containerGlass
    
    -- Text container
    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, -90, 1, 0)
    textContainer.Position = UDim2.new(0, 20, 0, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = container
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, toggleData.Description and 8 or 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = toggleData.Text
    titleLabel.TextColor3 = toggleData.Disabled and DarkTheme.TextDisabled or DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = textContainer
    
    -- Description
    if toggleData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, 0, 0, 22)
        descLabel.Position = UDim2.new(0, 0, 0, 35)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = toggleData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = textContainer
    end
    
    -- Toggle switch
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 55, 0, 30)
    toggleFrame.Position = UDim2.new(1, -70, 0.5, -15)
    toggleFrame.BackgroundColor3 = toggleData.Default and DarkTheme.Primary or DarkTheme.Border
    toggleFrame.BackgroundTransparency = 0.2
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleFrame
    
    -- Toggle knob
    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 26, 0, 26)
    toggleKnob.Position = toggleData.Default and UDim2.new(1, -28, 0.5, -13) or UDim2.new(0, 2, 0.5, -13)
    toggleKnob.BackgroundColor3 = DarkTheme.TextPrimary
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Parent = toggleFrame
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = toggleKnob
    
    -- Knob shadow
    local knobShadow = Instance.new("Frame")
    knobShadow.Size = UDim2.new(1, 6, 1, 6)
    knobShadow.Position = UDim2.new(0, -3, 0, 3)
    knobShadow.BackgroundColor3 = DarkTheme.Shadow
    knobShadow.BackgroundTransparency = 0.7
    knobShadow.BorderSizePixel = 0
    knobShadow.ZIndex = toggleKnob.ZIndex - 1
    knobShadow.Parent = toggleKnob
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(1, 0)
    shadowCorner.Parent = knobShadow
    
    local isToggled = toggleData.Default
    
    -- Click detector
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = container
    
    clickDetector.MouseButton1Click:Connect(function()
        if not toggleData.Disabled then
            isToggled = not isToggled
            self:_animateToggle(toggleFrame, toggleKnob, isToggled)
            toggleData.Callback(isToggled)
        end
    end)
    
    -- Hover effect
    if not toggleData.Disabled then
        self:_addHoverEffect(container)
    end
    
    container.GetValue = function() return isToggled end
    container.SetValue = function(value)
        isToggled = value
        self:_animateToggle(toggleFrame, toggleKnob, isToggled)
    end
    
    return container
end

-- Slider Creation
function PremiumGUI:createSlider(parent, options)
    options = options or {}
    local sliderData = {
        Text = options.Text or "Slider",
        Description = options.Description or nil,
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Step = options.Step or 1,
        Suffix = options.Suffix or "",
        Disabled = options.Disabled or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, sliderData.Description and 95 or 75)
    container.BackgroundColor3 = DarkTheme.Surface
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    -- Glass effect
    local containerGlass = Instance.new("Frame")
    containerGlass.Size = UDim2.new(1, 0, 1, 0)
    containerGlass.BackgroundColor3 = DarkTheme.Glass
    containerGlass.BackgroundTransparency = 0.96
    containerGlass.BorderSizePixel = 0
    containerGlass.Parent = container
    
    local containerGlassCorner = Instance.new("UICorner")
    containerGlassCorner.CornerRadius = UDim.new(0, 10)
    containerGlassCorner.Parent = containerGlass
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -40, 0, 35)
    header.Position = UDim2.new(0, 20, 0, 10)
    header.BackgroundTransparency = 1
    header.Parent = container
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -90, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = sliderData.Text
    titleLabel.TextColor3 = sliderData.Disabled and DarkTheme.TextDisabled or DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Value display
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 85, 1, 0)
    valueLabel.Position = UDim2.new(1, -85, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(sliderData.Default) .. sliderData.Suffix
    valueLabel.TextColor3 = DarkTheme.Primary
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 15
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = header
    
    -- Description
    if sliderData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -40, 0, 20)
        descLabel.Position = UDim2.new(0, 20, 0, 45)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = sliderData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = container
    end
    
    -- Slider track
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, -40, 0, 8)
    sliderTrack.Position = UDim2.new(0, 20, 1, -25)
    sliderTrack.BackgroundColor3 = DarkTheme.Border
    sliderTrack.BackgroundTransparency = 0.3
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Parent = container
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((sliderData.Default - sliderData.Min) / (sliderData.Max - sliderData.Min), 0, 1, 0)
    sliderFill.BackgroundColor3 = DarkTheme.Primary
    sliderFill.BackgroundTransparency = 0.2
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    -- Slider knob
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 20, 0, 20)
    sliderKnob.Position = UDim2.new((sliderData.Default - sliderData.Min) / (sliderData.Max - sliderData.Min), -10, 0.5, -10)
    sliderKnob.BackgroundColor3 = DarkTheme.TextPrimary
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderTrack
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    -- Knob border
    local knobBorder = Instance.new("UIStroke")
    knobBorder.Color = DarkTheme.Primary
    knobBorder.Thickness = 3
    knobBorder.Transparency = 0.4
    knobBorder.Parent = sliderKnob
    
    local currentValue = sliderData.Default
    local dragging = false
    
    -- Drag functionality
    local function updateSlider(input)
        if sliderData.Disabled then return end
        
        local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        local rawValue = sliderData.Min + (sliderData.Max - sliderData.Min) * relativeX
        currentValue = math.floor(rawValue / sliderData.Step + 0.5) * sliderData.Step
        currentValue = math.clamp(currentValue, sliderData.Min, sliderData.Max)
        
        local tweenInfo = TweenInfo.new(AnimConfig.HoverSpeed, AnimConfig.Style, AnimConfig.Direction)
        local finalRelative = (currentValue - sliderData.Min) / (sliderData.Max - sliderData.Min)
        
        TweenService:Create(sliderFill, tweenInfo, {Size = UDim2.new(finalRelative, 0, 1, 0)}):Play()
        TweenService:Create(sliderKnob, tweenInfo, {Position = UDim2.new(finalRelative, -10, 0.5, -10)}):Play()
        
        valueLabel.Text = tostring(currentValue) .. sliderData.Suffix
        sliderData.Callback(currentValue)
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not sliderData.Disabled then
            dragging = true
            updateSlider(input)
            
            local scaleUp = TweenService:Create(sliderKnob, TweenInfo.new(0.1), {Size = UDim2.new(0, 24, 0, 24)})
            scaleUp:Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            
            local scaleDown = TweenService:Create(sliderKnob, TweenInfo.new(0.1), {Size = UDim2.new(0, 20, 0, 20)})
            scaleDown:Play()
        end
    end)
    
    -- Hover effect
    if not sliderData.Disabled then
        self:_addHoverEffect(container)
    end
    
    container.GetValue = function() return currentValue end
    container.SetValue = function(value)
        currentValue = math.clamp(value, sliderData.Min, sliderData.Max)
        local relativeX = (currentValue - sliderData.Min) / (sliderData.Max - sliderData.Min)
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderKnob.Position = UDim2.new(relativeX, -10, 0.5, -10)
        valueLabel.Text = tostring(currentValue) .. sliderData.Suffix
    end
    
    return container
end

-- TextBox Creation
function PremiumGUI:createTextBox(parent, options)
    options = options or {}
    local textBoxData = {
        Text = options.Text or "TextBox",
        Description = options.Description or nil,
        Placeholder = options.Placeholder or "Enter text...",
        Default = options.Default or "",
        InputType = options.InputType or "Text",
        MaxLength = options.MaxLength or nil,
        Disabled = options.Disabled or false,
        Callback = options.Callback or function() end
    }
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, textBoxData.Description and 95 or 75)
    container.BackgroundColor3 = DarkTheme.Surface
    container.BackgroundTransparency = 0.4
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    -- Glass effect
    local containerGlass = Instance.new("Frame")
    containerGlass.Size = UDim2.new(1, 0, 1, 0)
    containerGlass.BackgroundColor3 = DarkTheme.Glass
    containerGlass.BackgroundTransparency = 0.96
    containerGlass.BorderSizePixel = 0
    containerGlass.Parent = container
    
    local containerGlassCorner = Instance.new("UICorner")
    containerGlassCorner.CornerRadius = UDim.new(0, 10)
    containerGlassCorner.Parent = containerGlass
    
    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, -40, 0, 30)
    header.Position = UDim2.new(0, 20, 0, 10)
    header.BackgroundTransparency = 1
    header.Parent = container
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = textBoxData.Text
    titleLabel.TextColor3 = textBoxData.Disabled and DarkTheme.TextDisabled or DarkTheme.TextPrimary
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header
    
    -- Description
    if textBoxData.Description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -40, 0, 20)
        descLabel.Position = UDim2.new(0, 20, 0, 40)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = textBoxData.Description
        descLabel.TextColor3 = DarkTheme.TextMuted
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 13
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = container
    end
    
    -- Input field
    local inputField = Instance.new("TextBox")
    inputField.Size = UDim2.new(1, -40, 0, 35)
    inputField.Position = UDim2.new(0, 20, 1, -45)
    inputField.BackgroundColor3 = DarkTheme.Background
    inputField.BackgroundTransparency = 0.3
    inputField.BorderSizePixel = 0
    inputField.Text = textBoxData.Default
    inputField.PlaceholderText = textBoxData.Placeholder
    inputField.TextColor3 = DarkTheme.TextPrimary
    inputField.PlaceholderColor3 = DarkTheme.TextMuted
    inputField.Font = Enum.Font.Gotham
    inputField.TextSize = 14
    inputField.TextXAlignment = Enum.TextXAlignment.Left
    inputField.ClearButtonOnFocus = false
    inputField.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputField
    
    -- Input border
    local inputBorder = Instance.new("UIStroke")
    inputBorder.Color = DarkTheme.Border
    inputBorder.Thickness = 2
    inputBorder.Transparency = 0.5
    inputBorder.Parent = inputField
    
    -- Focus effects
    inputField.Focused:Connect(function()
        if not textBoxData.Disabled then
            local focusTween = TweenService:Create(inputBorder, TweenInfo.new(0.2), {
                Color = DarkTheme.Primary,
                Transparency = 0.2
            })
            focusTween:Play()
        end
    end)
    
    inputField.FocusLost:Connect(function()
        local unfocusTween = TweenService:Create(inputBorder, TweenInfo.new(0.2), {
            Color = DarkTheme.Border,
            Transparency = 0.5
        })
        unfocusTween:Play()
        textBoxData.Callback(inputField.Text)
    end)
    
    -- Length limit
    inputField.Changed:Connect(function(property)
        if property == "Text" and textBoxData.MaxLength then
            if #inputField.Text > textBoxData.MaxLength then
                inputField.Text = string.sub(inputField.Text, 1, textBoxData.MaxLength)
            end
        end
    end)
    
    -- Disabled state
    if textBoxData.Disabled then
        inputField.TextEditable = false
        inputField.BackgroundTransparency = 0.8
        inputField.TextColor3 = DarkTheme.TextDisabled
    end
    
    container.GetValue = function() return inputField.Text end
    container.SetValue = function(value) inputField.Text = value end
    container.Focus = function() inputField:CaptureFocus() end
    
    return container
end
