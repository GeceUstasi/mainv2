-- VoidX Framework | Modern Roblox UI Library
-- Version: 1.0.0 BETA
-- Created by: VoidX Team

local VoidX = {}
VoidX.__index = VoidX

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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
            Toggle = Color3.fromRGB(102, 126, 234)
        },
        Ocean = {
            Background = Color3.fromRGB(0, 31, 63),
            Secondary = Color3.fromRGB(0, 20, 40),
            Accent = Color3.fromRGB(0, 119, 190),
            AccentDark = Color3.fromRGB(0, 77, 122),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 200, 220),
            Border = Color3.fromRGB(0, 50, 80),
            Toggle = Color3.fromRGB(0, 150, 200)
        },
        Sunset = {
            Background = Color3.fromRGB(44, 24, 16),
            Secondary = Color3.fromRGB(30, 15, 10),
            Accent = Color3.fromRGB(255, 107, 107),
            AccentDark = Color3.fromRGB(78, 205, 196),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(220, 180, 180),
            Border = Color3.fromRGB(60, 30, 20),
            Toggle = Color3.fromRGB(255, 120, 120)
        },
        Forest = {
            Background = Color3.fromRGB(10, 31, 27),
            Secondary = Color3.fromRGB(6, 20, 17),
            Accent = Color3.fromRGB(19, 78, 74),
            AccentDark = Color3.fromRGB(6, 95, 70),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 220, 180),
            Border = Color3.fromRGB(20, 50, 45),
            Toggle = Color3.fromRGB(40, 150, 120)
        }
    },
    AnimationSpeed = 0.3,
    EasingStyle = Enum.EasingStyle.Quart,
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold
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
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    instance.Parent = parent
    return instance
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        CreateTween(frame, {
            Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        }, 0.1)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
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
        Name = "VoidX_" .. HttpService:GenerateGUID(false),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    }, CoreGui)
    
    -- Main Frame
    local mainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        BackgroundColor3 = window.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, screenGui)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
    }, mainFrame)
    
    -- Add gradient overlay
    local gradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 255))
        },
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(1, 0.98)
        },
        Rotation = 135
    }, mainFrame)
    
    -- Border
    local border = CreateInstance("UIStroke", {
        Color = window.Theme.Border,
        Thickness = 1,
        Transparency = 0.5
    }, mainFrame)
    
    -- Sidebar
    local sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 250, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = window.Theme.Secondary,
        BorderSizePixel = 0
    }, mainFrame)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
    }, sidebar)
    
    -- Logo Section
    local logoSection = CreateInstance("Frame", {
        Name = "LogoSection",
        Size = UDim2.new(1, -30, 0, 80),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1
    }, sidebar)
    
    local logoText = CreateInstance("TextLabel", {
        Name = "Logo",
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = window.Theme.Text,
        TextScaled = true,
        Font = Config.FontBold
    }, logoSection)
    
    -- Add gradient to logo
    CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, window.Theme.Accent),
            ColorSequenceKeypoint.new(1, window.Theme.AccentDark)
        },
        Rotation = 135
    }, logoText)
    
    local versionLabel = CreateInstance("TextLabel", {
        Name = "Version",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        Text = "v1.0.0 BETA",
        TextColor3 = window.Theme.TextDim,
        TextSize = 11,
        Font = Config.Font
    }, logoSection)
    
    -- Tab Container
    local tabContainer = CreateInstance("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -30, 1, -180),
        Position = UDim2.new(0, 15, 0, 100),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = window.Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    }, sidebar)
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    }, tabContainer)
    
    -- Content Area
    local contentArea = CreateInstance("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -260, 1, -20),
        Position = UDim2.new(0, 260, 0, 10),
        BackgroundTransparency = 1
    }, mainFrame)
    
    -- Theme Selector
    local themeSelector = CreateInstance("Frame", {
        Name = "ThemeSelector",
        Size = UDim2.new(1, -30, 0, 60),
        Position = UDim2.new(0, 15, 1, -70),
        BackgroundColor3 = window.Theme.Background,
        BackgroundTransparency = 0.3
    }, sidebar)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10)
    }, themeSelector)
    
    local themeLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Text = "THEME",
        TextColor3 = window.Theme.TextDim,
        TextSize = 11,
        Font = Config.Font,
        TextXAlignment = Enum.TextXAlignment.Left
    }, themeSelector)
    
    local themeOptions = CreateInstance("Frame", {
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 25),
        BackgroundTransparency = 1
    }, themeSelector)
    
    CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    }, themeOptions)
    
    -- Create theme dots
    for themeName, themeColors in pairs(Config.Themes) do
        local themeDot = CreateInstance("Frame", {
            Size = UDim2.new(0, 24, 0, 24),
            BackgroundColor3 = themeColors.Accent
        }, themeOptions)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }, themeDot)
        
        local dotButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = ""
        }, themeDot)
        
        dotButton.MouseButton1Click:Connect(function()
            window:ChangeTheme(themeName)
        end)
    end
    
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
        }, tabContainer)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, tabButton)
        
        local tabLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = window.Theme.TextDim,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        }, tabButton)
        
        -- Tab Icon (if provided)
        if tabIcon then
            local iconLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 15, 0.5, -10),
                BackgroundTransparency = 1,
                Text = tabIcon,
                TextColor3 = window.Theme.TextDim,
                TextSize = 20,
                Font = Config.Font
            }, tabButton)
        end
        
        local tabButtonClick = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = ""
        }, tabButton)
        
        -- Tab Content Frame
        local tabContent = CreateInstance("ScrollingFrame", {
            Name = tabName .. "Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = window.Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        }, contentArea)
        
        local contentLayout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15)
        }, tabContent)
        
        -- Tab Header
        local tabHeader = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundTransparency = 1
        }, tabContent)
        
        local tabTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = window.Theme.Text,
            TextSize = 32,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        }, tabHeader)
        
        local tabDescription = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = "Customize your experience with advanced settings",
            TextColor3 = window.Theme.TextDim,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        }, tabHeader)
        
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
                BackgroundTransparency = 0.7
            }, tabContent)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, toggleFrame)
            
            local toggleBorder = CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 1,
                Transparency = 0.7
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
            }, toggleFrame)
            
            local toggleSwitch = CreateInstance("Frame", {
                Size = UDim2.new(0, 48, 0, 26),
                Position = UDim2.new(1, -60, 0.5, -13),
                BackgroundColor3 = window.Theme.Border
            }, toggleFrame)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, toggleSwitch)
            
            local toggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 3, 0, 3),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }, toggleSwitch)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, toggleCircle)
            
            local toggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ""
            }, toggleFrame)
            
            local toggled = toggleDefault
            
            local function updateToggle()
                if toggled then
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Toggle})
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 25, 0, 3)})
                else
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Border})
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 3, 0, 3)})
                end
                toggleCallback(toggled)
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
            end)
            
            -- Hover effect
            toggleFrame.MouseEnter:Connect(function()
                CreateTween(toggleFrame, {BackgroundTransparency = 0.5})
                CreateTween(toggleBorder, {Transparency = 0.5})
            end)
            
            toggleFrame.MouseLeave:Connect(function()
                CreateTween(toggleFrame, {BackgroundTransparency = 0.7})
                CreateTween(toggleBorder, {Transparency = 0.7})
            end)
            
            updateToggle()
            
            return {
                SetValue = function(value)
                    toggled = value
                    updateToggle()
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
                BackgroundTransparency = 0.7
            }, tabContent)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, sliderFrame)
            
            CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 1,
                Transparency = 0.7
            }, sliderFrame)
            
            local sliderHeader = CreateInstance("Frame", {
                Size = UDim2.new(1, -40, 0, 30),
                Position = UDim2.new(0, 20, 0, 10),
                BackgroundTransparency = 1
            }, sliderFrame)
            
            local sliderLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = sliderName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            }, sliderHeader)
            
            local sliderValue = CreateInstance("TextLabel", {
                Size = UDim2.new(0.3, 0, 1, 0),
                Position = UDim2.new(0.7, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(sliderDefault),
                TextColor3 = window.Theme.Accent,
                TextSize = 14,
                Font = Config.FontBold,
                TextXAlignment = Enum.TextXAlignment.Right
            }, sliderHeader)
            
            local sliderBar = CreateInstance("Frame", {
                Size = UDim2.new(1, -40, 0, 6),
                Position = UDim2.new(0, 20, 0, 45),
                BackgroundColor3 = window.Theme.Border
            }, sliderFrame)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, sliderBar)
            
            local sliderFill = CreateInstance("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = window.Theme.Accent
            }, sliderBar)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, sliderFill)
            
            CreateInstance("UIGradient", {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, window.Theme.Accent),
                    ColorSequenceKeypoint.new(1, window.Theme.AccentDark)
                },
                Rotation = 90
            }, sliderFill)
            
            local sliderThumb = CreateInstance("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(0, -9, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 2
            }, sliderFill)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0)
            }, sliderThumb)
            
            CreateInstance("DropShadow", {
                Color = Color3.fromRGB(0, 0, 0),
                Opacity = 0.3,
                Radius = 10
            }, sliderThumb)
            
            local dragging = false
            local currentValue = sliderDefault
            
            local function updateSlider(value)
                value = math.clamp(value, sliderMin, sliderMax)
                value = math.floor(value / sliderIncrement) * sliderIncrement
                currentValue = value
                
                local percentage = (value - sliderMin) / (sliderMax - sliderMin)
                CreateTween(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                sliderValue.Text = tostring(value)
                sliderCallback(value)
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
                end
            }
        end
        
        -- Dropdown Element
        function tab:CreateDropdown(options)
            options = options or {}
            local dropdownName = options.Name or "Dropdown"
            local dropdownList = options.Options or {}
            local dropdownDefault = options.Default or dropdownList[1]
            local dropdownCallback = options.Callback or function() end
            
            local dropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7,
                ClipsDescendants = true
            }, tabContent)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, dropdownFrame)
            
            CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 1,
                Transparency = 0.7
            }, dropdownFrame)
            
            local dropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1,
                Text = ""
            }, dropdownFrame)
            
            local dropdownLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = dropdownDefault or dropdownName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            }, dropdownButton)
            
            local dropdownArrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -40, 0, 15),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = window.Theme.TextDim,
                TextSize = 12,
                Font = Config.Font
            }, dropdownButton)
            
            local dropdownList = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 50),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Visible = true
            }, dropdownFrame)
            
            local dropdownListLayout = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder
            }, dropdownList)
            
            local isOpen = false
            local currentOption = dropdownDefault
            
            -- Create dropdown options
            for _, option in ipairs(options.Options or {}) do
                local optionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = window.Theme.Background,
                    BackgroundTransparency = 0.9,
                    Text = option,
                    TextColor3 = window.Theme.TextDim,
                    TextSize = 13,
                    Font = Config.Font
                }, dropdownList)
                
                optionButton.MouseEnter:Connect(function()
                    CreateTween(optionButton, {
                        BackgroundTransparency = 0.7,
                        TextColor3 = window.Theme.Text
                    })
                end)
                
                optionButton.MouseLeave:Connect(function()
                    CreateTween(optionButton, {
                        BackgroundTransparency = 0.9,
                        TextColor3 = window.Theme.TextDim
                    })
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    currentOption = option
                    dropdownLabel.Text = option
                    dropdownCallback(option)
                    
                    -- Close dropdown
                    isOpen = false
                    CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 50)})
                    CreateTween(dropdownArrow, {Rotation = 0})
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local contentHeight = dropdownListLayout.AbsoluteContentSize.Y
                    CreateTween(dropdownFrame, {
                        Size = UDim2.new(1, 0, 0, 50 + contentHeight)
                    })
                    CreateTween(dropdownArrow, {Rotation = 180})
                else
                    CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 50)})
                    CreateTween(dropdownArrow, {Rotation = 0})
                end
            end)
            
            return {
                SetOption = function(option)
                    currentOption = option
                    dropdownLabel.Text = option
                    dropdownCallback(option)
                end,
                GetOption = function()
                    return currentOption
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
                BackgroundTransparency = 1
            }, tabContent)
            
            local button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = window.Theme.Accent,
                BorderSizePixel = 0,
                Text = buttonName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Config.FontBold
            }, buttonFrame)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10)
            }, button)
            
            CreateInstance("UIGradient", {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, window.Theme.Accent),
                    ColorSequenceKeypoint.new(1, window.Theme.AccentDark)
                },
                Rotation = 135
            }, button)
            
            -- Ripple effect container
            local rippleContainer = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ClipsDescendants = true
            }, button)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10)
            }, rippleContainer)
            
            button.MouseButton1Click:Connect(function()
                -- Create ripple effect
                local ripple = CreateInstance("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.7
                }, rippleContainer)
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                }, ripple)
                
                CreateTween(ripple, {
                    Size = UDim2.new(2, 0, 2, 0),
                    BackgroundTransparency = 1
                }, 0.5)
                
                wait(0.5)
                ripple:Destroy()
                
                buttonCallback()
            end)
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {
                    Size = UDim2.new(1, 10, 1, 0),
                    Position = UDim2.new(0, -5, 0, 0)
                }, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0)
                }, 0.2)
            end)
            
            return {
                SetText = function(text)
                    button.Text = text
                end
            }
        end
        
        -- Input Element
        function tab:CreateInput(options)
            options = options or {}
            local inputName = options.Name or "Input"
            local inputPlaceholder = options.Placeholder or "Enter text..."
            local inputDefault = options.Default or ""
            local inputCallback = options.Callback or function() end
            
            local inputFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7
            }, tabContent)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, inputFrame)
            
            local inputBorder = CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 1,
                Transparency = 0.7
            }, inputFrame)
            
            local inputLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.35, 0, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = inputName,
                TextColor3 = window.Theme.TextDim,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            }, inputFrame)
            
            local inputBox = CreateInstance("TextBox", {
                Size = UDim2.new(0.6, -20, 0, 30),
                Position = UDim2.new(0.4, 0, 0.5, -15),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Text = inputDefault,
                PlaceholderText = inputPlaceholder,
                PlaceholderColor3 = window.Theme.TextDim,
                TextColor3 = window.Theme.Text,
                TextSize = 13,
                Font = Config.Font,
                ClearTextOnFocus = false
            }, inputFrame)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, inputBox)
            
            inputBox.FocusLost:Connect(function(enterPressed)
                inputCallback(inputBox.Text, enterPressed)
            end)
            
            inputBox.Focused:Connect(function()
                CreateTween(inputBorder, {
                    Color = window.Theme.Accent,
                    Transparency = 0.3
                })
            end)
            
            inputBox.FocusLost:Connect(function()
                CreateTween(inputBorder, {
                    Color = window.Theme.Border,
                    Transparency = 0.7
                })
            end)
            
            return {
                GetText = function()
                    return inputBox.Text
                end,
                SetText = function(text)
                    inputBox.Text = text
                end
            }
        end
        
        -- Keybind Element
        function tab:CreateKeybind(options)
            options = options or {}
            local keybindName = options.Name or "Keybind"
            local keybindDefault = options.Default or Enum.KeyCode.F
            local keybindCallback = options.Callback or function() end
            
            local keybindFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7
            }, tabContent)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, keybindFrame)
            
            CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 1,
                Transparency = 0.7
            }, keybindFrame)
            
            local keybindLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = keybindName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            }, keybindFrame)
            
            local keybindButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 70, 0, 30),
                Position = UDim2.new(1, -85, 0.5, -15),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Text = keybindDefault.Name,
                TextColor3 = window.Theme.Text,
                TextSize = 13,
                Font = Config.Font
            }, keybindFrame)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, keybindButton)
            
            local currentKey = keybindDefault
            local listening = false
            
            keybindButton.MouseButton1Click:Connect(function()
                listening = true
                keybindButton.Text = "..."
                CreateTween(keybindButton, {BackgroundColor3 = window.Theme.Accent})
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keybindButton.Text = currentKey.Name
                        listening = false
                        CreateTween(keybindButton, {BackgroundColor3 = window.Theme.Secondary})
                    end
                elseif input.KeyCode == currentKey and not gameProcessed then
                    keybindCallback()
                end
            end)
            
            return {
                SetKey = function(key)
                    currentKey = key
                    keybindButton.Text = key.Name
                end,
                GetKey = function()
                    return currentKey
                end
            }
        end
        
        -- Color Picker Element
        function tab:CreateColorPicker(options)
            options = options or {}
            local colorName = options.Name or "Color Picker"
            local colorDefault = options.Default or Color3.fromRGB(255, 255, 255)
            local colorCallback = options.Callback or function() end
            
            local colorFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7
            }, tabContent)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, colorFrame)
            
            CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 1,
                Transparency = 0.7
            }, colorFrame)
            
            local colorLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = colorName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            }, colorFrame)
            
            local colorDisplay = CreateInstance("Frame", {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -45, 0.5, -15),
                BackgroundColor3 = colorDefault,
                BorderSizePixel = 0
            }, colorFrame)
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, colorDisplay)
            
            CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 2,
                Transparency = 0.5
            }, colorDisplay)
            
            local colorButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ""
            }, colorDisplay)
            
            -- Simple color picker popup (you can expand this)
            colorButton.MouseButton1Click:Connect(function()
                -- For now, cycle through preset colors
                local presetColors = {
                    Color3.fromRGB(255, 0, 0),
                    Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 0, 255),
                    Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(255, 0, 255),
                    Color3.fromRGB(0, 255, 255),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(0, 0, 0)
                }
                
                local currentIndex = 1
                for i, color in ipairs(presetColors) do
                    if color == colorDisplay.BackgroundColor3 then
                        currentIndex = i
                        break
                    end
                end
                
                currentIndex = currentIndex % #presetColors + 1
                local newColor = presetColors[currentIndex]
                
                CreateTween(colorDisplay, {BackgroundColor3 = newColor})
                colorCallback(newColor)
            end)
            
            return {
                SetColor = function(color)
                    colorDisplay.BackgroundColor3 = color
                    colorCallback(color)
                end,
                GetColor = function()
                    return colorDisplay.BackgroundColor3
                end
            }
        end
        
        -- Label Element
        function tab:CreateLabel(text)
            local labelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1
            }, tabContent)
            
            local label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = text or "Label",
                TextColor3 = window.Theme.TextDim,
                TextSize = 13,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            }, labelFrame)
            
            return {
                SetText = function(newText)
                    label.Text = newText
                end
            }
        end
        
        -- Section Element
        function tab:CreateSection(sectionName)
            local sectionFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1
            }, tabContent)
            
            local sectionLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = sectionName:upper(),
                TextColor3 = window.Theme.Accent,
                TextSize = 12,
                Font = Config.FontBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }, sectionFrame)
            
            local sectionLine = CreateInstance("Frame", {
                Size = UDim2.new(0.5, -10, 0, 1),
                Position = UDim2.new(0.5, 10, 0.5, 0),
                BackgroundColor3 = window.Theme.Border,
                BorderSizePixel = 0
            }, sectionFrame)
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
        -- Hide all tabs
        for _, t in pairs(window.Tabs) do
            t.Content.Visible = false
            CreateTween(t.Button, {
                BackgroundTransparency = 1,
                BackgroundColor3 = window.Theme.Background
            })
            local label = t.Button:FindChildOfClass("TextLabel")
            if label then
                CreateTween(label, {TextColor3 = window.Theme.TextDim})
            end
        end
        
        -- Show selected tab
        tab.Content.Visible = true
        CreateTween(tab.Button, {
            BackgroundTransparency = 0.8,
            BackgroundColor3 = window.Theme.Accent
        })
        local label = tab.Button:FindChildOfClass("TextLabel")
        if label then
            CreateTween(label, {TextColor3 = window.Theme.Text})
        end
        
        window.ActiveTab = tab
    end
    
    -- Theme Change Function
    function window:ChangeTheme(themeName)
        local newTheme = Config.Themes[themeName]
        if not newTheme then return end
        
        window.Theme = newTheme
        
        -- Update all UI elements with new theme colors
        CreateTween(mainFrame, {BackgroundColor3 = newTheme.Background})
        CreateTween(sidebar, {BackgroundColor3 = newTheme.Secondary})
        
        -- Update all elements recursively
        local function updateColors(parent)
            for _, child in pairs(parent:GetDescendants()) do
                if child:IsA("Frame") then
                    if child.BackgroundColor3 == Config.Themes.Night.Background then
                        CreateTween(child, {BackgroundColor3 = newTheme.Background})
                    elseif child.BackgroundColor3 == Config.Themes.Night.Secondary then
                        CreateTween(child, {BackgroundColor3 = newTheme.Secondary})
                    end
                elseif child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    if child.TextColor3 == Config.Themes.Night.Text then
                        CreateTween(child, {TextColor3 = newTheme.Text})
                    elseif child.TextColor3 == Config.Themes.Night.TextDim then
                        CreateTween(child, {TextColor3 = newTheme.TextDim})
                    end
                elseif child:IsA("UIStroke") then
                    CreateTween(child, {Color = newTheme.Border})
                end
            end
        end
        
        updateColors(screenGui)
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
        }, screenGui)
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, notif)
        
        CreateInstance("UIStroke", {
            Color = window.Theme.Accent,
            Thickness = 2,
            Transparency = 0.5
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
        }, notif)
        
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
        }, notif)
        
        -- Animate in
        CreateTween(notif, {Position = UDim2.new(1, -320, 1, -100)}, 0.5)
        
        -- Auto remove
        task.wait(duration)
        CreateTween(notif, {Position = UDim2.new(1, 320, 1, -100)}, 0.5)
        task.wait(0.5)
        notif:Destroy()
    end
    
    -- Toggle UI Visibility
    local isVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            isVisible = not isVisible
            mainFrame.Visible = isVisible
        end
    end)
    
    return window
end

return VoidX
