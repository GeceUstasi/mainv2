-- VoidX Framework | Professional Roblox UI Library
-- Version: 2.0.0 XENO EDITION
-- Optimized for Xeno Executor

local VoidX = {}
VoidX.__index = VoidX

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Get proper GUI parent for executors
local function GetGuiParent()
    local success, result = pcall(function()
        return game:GetService("CoreGui")
    end)
    
    if success then
        return result
    else
        -- Fallback for executors that don't support CoreGui
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

local GuiParent = GetGuiParent()

-- Check for existing GUI and destroy it
for _, gui in pairs(GuiParent:GetChildren()) do
    if gui.Name and gui.Name:find("VoidX") then
        gui:Destroy()
    end
end

-- Configuration
local Config = {
    Themes = {
        Night = {
            Background = Color3.fromRGB(26, 26, 46),
            Secondary = Color3.fromRGB(15, 15, 25),
            Accent = Color3.fromRGB(102, 126, 234),
            AccentDark = Color3.fromRGB(118, 75, 162),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 180, 180),
            Border = Color3.fromRGB(40, 40, 60),
            Toggle = Color3.fromRGB(102, 126, 234),
            ContentBG = Color3.fromRGB(20, 20, 35)
        },
        Ocean = {
            Background = Color3.fromRGB(0, 31, 63),
            Secondary = Color3.fromRGB(0, 20, 40),
            Accent = Color3.fromRGB(0, 119, 190),
            AccentDark = Color3.fromRGB(0, 77, 122),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 200, 220),
            Border = Color3.fromRGB(0, 50, 80),
            Toggle = Color3.fromRGB(0, 150, 200),
            ContentBG = Color3.fromRGB(0, 25, 50)
        },
        Sunset = {
            Background = Color3.fromRGB(44, 24, 16),
            Secondary = Color3.fromRGB(30, 15, 10),
            Accent = Color3.fromRGB(255, 107, 107),
            AccentDark = Color3.fromRGB(78, 205, 196),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(220, 180, 180),
            Border = Color3.fromRGB(60, 30, 20),
            Toggle = Color3.fromRGB(255, 120, 120),
            ContentBG = Color3.fromRGB(35, 20, 13)
        },
        Forest = {
            Background = Color3.fromRGB(10, 31, 27),
            Secondary = Color3.fromRGB(6, 20, 17),
            Accent = Color3.fromRGB(19, 78, 74),
            AccentDark = Color3.fromRGB(6, 95, 70),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 220, 180),
            Border = Color3.fromRGB(20, 50, 45),
            Toggle = Color3.fromRGB(40, 150, 120),
            ContentBG = Color3.fromRGB(8, 25, 22)
        }
    },
    AnimationSpeed = 0.3,
    EasingStyle = Enum.EasingStyle.Quart,
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    ToggleKey = Enum.KeyCode.RightShift
}

-- Utility Functions
local function CreateTween(instance, properties, duration)
    duration = duration or Config.AnimationSpeed
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, Config.EasingStyle, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function CreateInstance(className, properties, parent)
    local success, instance = pcall(function()
        local obj = Instance.new(className)
        for prop, value in pairs(properties or {}) do
            if prop ~= "Parent" then
                obj[prop] = value
            end
        end
        return obj
    end)
    
    if success and instance then
        if parent then
            instance.Parent = parent
        end
        return instance
    else
        warn("Failed to create instance:", className)
        return nil
    end
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Main Window Constructor
function VoidX:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "VoidX Framework"
    local windowTheme = options.Theme or "Night"
    local windowSize = options.Size or UDim2.new(0, 900, 0, 600)
    
    local window = {}
    window.Theme = Config.Themes[windowTheme]
    window.Tabs = {}
    window.ActiveTab = nil
    
    -- Create ScreenGui
    local screenGui = CreateInstance("ScreenGui", {
        Name = "VoidX_GUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    
    screenGui.Parent = GuiParent
    
    -- Main Frame
    local mainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        BackgroundColor3 = window.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true
    })
    mainFrame.Parent = screenGui
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
    }, mainFrame)
    
    -- Sidebar
    local sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 250, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = window.Theme.Secondary,
        BorderSizePixel = 0
    })
    sidebar.Parent = mainFrame
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
    }, sidebar)
    
    -- Logo Section
    local logoSection = CreateInstance("Frame", {
        Name = "LogoSection",
        Size = UDim2.new(1, -30, 0, 80),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1
    })
    logoSection.Parent = sidebar
    
    local logoText = CreateInstance("TextLabel", {
        Name = "Logo",
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = window.Theme.Accent,
        TextScaled = true,
        Font = Config.FontBold
    })
    logoText.Parent = logoSection
    
    local versionLabel = CreateInstance("TextLabel", {
        Name = "Version",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        Text = "v2.0 XENO",
        TextColor3 = window.Theme.TextDim,
        TextSize = 11,
        Font = Config.Font
    })
    versionLabel.Parent = logoSection
    
    -- Tab Container
    local tabContainer = CreateInstance("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -30, 1, -100),
        Position = UDim2.new(0, 15, 0, 100),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = window.Theme.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y
    })
    tabContainer.Parent = sidebar
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    }, tabContainer)
    
    -- Content Area
    local contentArea = CreateInstance("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -260, 1, -20),
        Position = UDim2.new(0, 260, 0, 10),
        BackgroundColor3 = window.Theme.ContentBG,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0
    })
    contentArea.Parent = mainFrame
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 15)
    }, contentArea)
    
    -- Make window draggable
    MakeDraggable(mainFrame, logoSection)
    
    -- Tab Creation Method
    function window:CreateTab(tabName, tabIcon)
        local tab = {}
        tab.Name = tabName
        tab.Elements = {}
        
        -- Tab Button
        local tabButton = CreateInstance("Frame", {
            Name = tabName .. "Tab",
            Size = UDim2.new(1, 0, 0, 45),
            BackgroundColor3 = window.Theme.Background,
            BackgroundTransparency = 1
        })
        tabButton.Parent = tabContainer
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, tabButton)
        
        local tabLabel = CreateInstance("TextLabel", {
            Name = "TabLabel",
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = window.Theme.TextDim,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        tabLabel.Parent = tabButton
        
        if tabIcon then
            local iconLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 15, 0.5, -10),
                BackgroundTransparency = 1,
                Text = tabIcon,
                TextColor3 = window.Theme.TextDim,
                TextSize = 20,
                Font = Config.Font
            })
            iconLabel.Parent = tabButton
        end
        
        local tabButtonClick = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextTransparency = 1
        })
        tabButtonClick.Parent = tabButton
        
        -- Tab Content Frame
        local tabContent = CreateInstance("ScrollingFrame", {
            Name = tabName .. "Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = window.Theme.Accent,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = Enum.ScrollingDirection.Y
        })
        tabContent.Parent = contentArea
        
        local contentLayout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15)
        })
        contentLayout.Parent = tabContent
        
        -- Tab Header
        local tabHeader = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundTransparency = 1,
            LayoutOrder = 0
        })
        tabHeader.Parent = tabContent
        
        local tabTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = window.Theme.Text,
            TextSize = 32,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        tabTitle.Parent = tabHeader
        
        local tabDescription = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = "Customize your experience",
            TextColor3 = window.Theme.TextDim,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        tabDescription.Parent = tabHeader
        
        -- Auto-resize content
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection
        tabButtonClick.MouseButton1Click:Connect(function()
            window:SelectTab(tab)
        end)
        
        -- Hover Effect
        tabButton.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                CreateTween(tabButton, {BackgroundTransparency = 0.8})
                CreateTween(tabLabel, {TextColor3 = window.Theme.Text})
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                CreateTween(tabButton, {BackgroundTransparency = 1})
                CreateTween(tabLabel, {TextColor3 = window.Theme.TextDim})
            end
        end)
        
        -- Element Creation Methods
        
        -- Toggle Element
        function tab:CreateToggle(options)
            options = options or {}
            local toggleName = options.Name or "Toggle"
            local toggleDefault = options.Default or false
            local toggleCallback = options.Callback or function() end
            
            local toggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7,
                LayoutOrder = 1
            })
            toggleFrame.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, toggleFrame)
            
            local toggleLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = toggleName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            toggleLabel.Parent = toggleFrame
            
            local toggleSwitch = CreateInstance("Frame", {
                Size = UDim2.new(0, 48, 0, 26),
                Position = UDim2.new(1, -60, 0.5, -13),
                BackgroundColor3 = window.Theme.Border
            })
            toggleSwitch.Parent = toggleFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, toggleSwitch)
            
            local toggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 3, 0, 3),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            })
            toggleCircle.Parent = toggleSwitch
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, toggleCircle)
            
            local toggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                TextTransparency = 1
            })
            toggleButton.Parent = toggleFrame
            
            local toggled = toggleDefault
            
            local function updateToggle()
                if toggled then
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Toggle})
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 25, 0, 3)})
                else
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Border})
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 3, 0, 3)})
                end
                
                pcall(function()
                    toggleCallback(toggled)
                end)
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            updateToggle()
            
            return {
                SetValue = function(value)
                    toggled = value
                    updateToggle()
                end,
                GetValue = function()
                    return toggled
                end
            }
        end
        
        -- Slider Element
        function tab:CreateSlider(options)
            options = options or {}
            local sliderName = options.Name or "Slider"
            local sliderMin = options.Min or 0
            local sliderMax = options.Max or 100
            local sliderDefault = options.Default or sliderMin
            local sliderIncrement = options.Increment or 1
            local sliderCallback = options.Callback or function() end
            
            local sliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 70),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7,
                LayoutOrder = 2
            })
            sliderFrame.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, sliderFrame)
            
            local sliderHeader = CreateInstance("Frame", {
                Size = UDim2.new(1, -40, 0, 30),
                Position = UDim2.new(0, 20, 0, 10),
                BackgroundTransparency = 1
            })
            sliderHeader.Parent = sliderFrame
            
            local sliderLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = sliderName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            sliderLabel.Parent = sliderHeader
            
            local sliderValue = CreateInstance("TextLabel", {
                Size = UDim2.new(0.3, 0, 1, 0),
                Position = UDim2.new(0.7, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(sliderDefault),
                TextColor3 = window.Theme.Accent,
                TextSize = 14,
                Font = Config.FontBold,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            sliderValue.Parent = sliderHeader
            
            local sliderBar = CreateInstance("Frame", {
                Size = UDim2.new(1, -40, 0, 6),
                Position = UDim2.new(0, 20, 0, 45),
                BackgroundColor3 = window.Theme.Border
            })
            sliderBar.Parent = sliderFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, sliderBar)
            
            local sliderFill = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = window.Theme.Accent
            })
            sliderFill.Parent = sliderBar
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, sliderFill)
            
            local dragging = false
            local currentValue = sliderDefault
            
            local function updateSlider(value)
                value = math.clamp(value, sliderMin, sliderMax)
                value = math.floor(value / sliderIncrement) * sliderIncrement
                currentValue = value
                
                local percentage = (value - sliderMin) / (sliderMax - sliderMin)
                CreateTween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                sliderValue.Text = tostring(value)
                
                pcall(function()
                    sliderCallback(value)
                end)
            end
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if dragging then
                            local mouse = LocalPlayer:GetMouse()
                            local percentage = math.clamp((mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                            local value = sliderMin + (sliderMax - sliderMin) * percentage
                            updateSlider(value)
                        else
                            connection:Disconnect()
                        end
                    end)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            updateSlider(sliderDefault)
            
            return {
                SetValue = function(value)
                    updateSlider(value)
                end,
                GetValue = function()
                    return currentValue
                end
            }
        end
        
        -- Button Element
        function tab:CreateButton(options)
            options = options or {}
            local buttonName = options.Name or "Button"
            local buttonCallback = options.Callback or function() end
            
            local buttonFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundTransparency = 1,
                LayoutOrder = 3
            })
            buttonFrame.Parent = tabContent
            
            local button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = window.Theme.Accent,
                BorderSizePixel = 0,
                Text = buttonName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Config.FontBold
            })
            button.Parent = buttonFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10)
            }, button)
            
            button.MouseButton1Click:Connect(function()
                pcall(buttonCallback)
            end)
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundTransparency = 0.2})
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundTransparency = 0})
            end)
            
            return {
                SetText = function(text)
                    button.Text = text
                end
            }
        end
        
        -- Label Element
        function tab:CreateLabel(text)
            local labelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                LayoutOrder = 4
            })
            labelFrame.Parent = tabContent
            
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = text or "Label",
                TextColor3 = window.Theme.TextDim,
                TextSize = 13,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            label.Parent = labelFrame
            
            return {
                SetText = function(newText)
                    label.Text = newText
                end
            }
        end
        
        table.insert(window.Tabs, tab)
        tab.Button = tabButton
        tab.Content = tabContent
        
        -- Auto-select first tab
        if #window.Tabs == 1 then
            window:SelectTab(tab)
        end
        
        return tab
    end
    
    -- Tab Selection Function
    function window:SelectTab(tab)
        for _, t in pairs(window.Tabs) do
            t.Content.Visible = false
            CreateTween(t.Button, {BackgroundTransparency = 1})
            local label = t.Button:FindFirstChild("TabLabel")
            if label then
                CreateTween(label, {TextColor3 = window.Theme.TextDim})
            end
        end
        
        tab.Content.Visible = true
        CreateTween(tab.Button, {BackgroundTransparency = 0.8})
        local label = tab.Button:FindFirstChild("TabLabel")
        if label then
            CreateTween(label, {TextColor3 = window.Theme.Text})
        end
        
        window.ActiveTab = tab
    end
    
    -- Notification System
    function window:CreateNotification(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 3
        
        local notif = CreateInstance("Frame", {
            Size = UDim2.new(0, 300, 0, 80),
            Position = UDim2.new(1, 320, 1, -100),
            BackgroundColor3 = window.Theme.Secondary,
            BorderSizePixel = 0
        })
        notif.Parent = screenGui
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, notif)
        
        local notifTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = window.Theme.Text,
            TextSize = 16,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        notifTitle.Parent = notif
        
        local notifContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 35),
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = window.Theme.TextDim,
            TextSize = 13,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        notifContent.Parent = notif
        
        CreateTween(notif, {Position = UDim2.new(1, -320, 1, -100)}, 0.5)
        
        task.wait(duration)
        CreateTween(notif, {Position = UDim2.new(1, 320, 1, -100)}, 0.5)
        task.wait(0.5)
        notif:Destroy()
    end
    
    -- Toggle UI Visibility
    local isVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Config.ToggleKey then
            isVisible = not isVisible
            mainFrame.Visible = isVisible
        end
    end)
    
    -- Destroy function
    function window:Destroy()
        screenGui:Destroy()
    end
    
    return window
end

return VoidX
