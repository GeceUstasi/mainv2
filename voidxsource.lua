-- VoidX Framework v3.0 | Professional Roblox UI Library
-- Advanced Features Edition with Rayfield-like capabilities

local VoidX = {}
VoidX.__index = VoidX

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Get proper GUI parent
local function GetGuiParent()
    local success, result = pcall(function()
        return game:GetService("CoreGui")
    end)
    
    if success then
        return result
    else
        return LocalPlayer:WaitForChild("PlayerGui")
    end
end

local GuiParent = GetGuiParent()

-- Destroy existing GUIs
for _, gui in pairs(GuiParent:GetChildren()) do
    if gui.Name and gui.Name:find("VoidX") then
        gui:Destroy()
    end
end

-- Global Storage
if getgenv then
    getgenv().VoidXConnections = getgenv().VoidXConnections or {}
    for _, connection in pairs(getgenv().VoidXConnections) do
        if connection and connection.Disconnect then
            connection:Disconnect()
        end
    end
    getgenv().VoidXConnections = {}
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
        },
        Midnight = {
            Background = Color3.fromRGB(10, 10, 20),
            Secondary = Color3.fromRGB(5, 5, 15),
            Accent = Color3.fromRGB(138, 43, 226),
            AccentDark = Color3.fromRGB(75, 0, 130),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(170, 170, 170),
            Border = Color3.fromRGB(30, 30, 50),
            Toggle = Color3.fromRGB(138, 43, 226),
            ContentBG = Color3.fromRGB(8, 8, 18)
        },
        Crimson = {
            Background = Color3.fromRGB(40, 10, 10),
            Secondary = Color3.fromRGB(25, 5, 5),
            Accent = Color3.fromRGB(220, 20, 60),
            AccentDark = Color3.fromRGB(139, 0, 0),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(200, 170, 170),
            Border = Color3.fromRGB(60, 20, 20),
            Toggle = Color3.fromRGB(220, 20, 60),
            ContentBG = Color3.fromRGB(30, 8, 8)
        },
        Arctic = {
            Background = Color3.fromRGB(240, 248, 255),
            Secondary = Color3.fromRGB(220, 230, 240),
            Accent = Color3.fromRGB(70, 130, 180),
            AccentDark = Color3.fromRGB(30, 90, 140),
            Text = Color3.fromRGB(20, 20, 20),
            TextDim = Color3.fromRGB(80, 80, 80),
            Border = Color3.fromRGB(200, 210, 220),
            Toggle = Color3.fromRGB(70, 130, 180),
            ContentBG = Color3.fromRGB(245, 250, 255)
        },
        Neon = {
            Background = Color3.fromRGB(20, 20, 30),
            Secondary = Color3.fromRGB(10, 10, 20),
            Accent = Color3.fromRGB(0, 255, 255),
            AccentDark = Color3.fromRGB(255, 0, 255),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(200, 200, 200),
            Border = Color3.fromRGB(50, 50, 70),
            Toggle = Color3.fromRGB(0, 255, 255),
            ContentBG = Color3.fromRGB(15, 15, 25)
        }
    },
    AnimationSpeed = 0.25,
    EasingStyle = Enum.EasingStyle.Cubic,
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    DefaultToggleKey = Enum.KeyCode.RightShift,
    KeySystem = {
        Enabled = false,
        Key = "",
        SaveKey = true,
        FileName = "VoidXKey"
    },
    ConfigSystem = {
        Enabled = true,
        FolderName = "VoidXConfigs",
        AutoSave = true
    }
}

-- Global Settings Storage
local GlobalSettings = {
    UIToggle = true,
    ToggleKey = Config.DefaultToggleKey,
    KeybindList = {},
    CurrentConfig = "Default",
    Notifications = {},
    Theme = "Night"
}

-- Utility Functions
local function CreateTween(instance, properties, duration, style)
    duration = duration or Config.AnimationSpeed
    style = style or Config.EasingStyle
    
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, style, Enum.EasingDirection.InOut),
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

-- Advanced Config System
local ConfigManager = {}

function ConfigManager:SaveConfig(configName, data)
    if not Config.ConfigSystem.Enabled then return end
    
    local fileName = Config.ConfigSystem.FolderName .. "/" .. configName .. ".json"
    local success, err = pcall(function()
        if writefile then
            writefile(fileName, HttpService:JSONEncode(data))
        end
    end)
    
    if not success then
        warn("Failed to save config:", err)
    end
end

function ConfigManager:LoadConfig(configName)
    if not Config.ConfigSystem.Enabled then return {} end
    
    local fileName = Config.ConfigSystem.FolderName .. "/" .. configName .. ".json"
    local success, data = pcall(function()
        if readfile and isfile and isfile(fileName) then
            return HttpService:JSONDecode(readfile(fileName))
        end
    end)
    
    if success and data then
        return data
    else
        return {}
    end
end

function ConfigManager:DeleteConfig(configName)
    if not Config.ConfigSystem.Enabled then return end
    
    local fileName = Config.ConfigSystem.FolderName .. "/" .. configName .. ".json"
    if delfile and isfile and isfile(fileName) then
        delfile(fileName)
    end
end

function ConfigManager:ListConfigs()
    if not Config.ConfigSystem.Enabled then return {} end
    
    local configs = {}
    if listfiles then
        for _, file in pairs(listfiles(Config.ConfigSystem.FolderName)) do
            local name = file:match("([^/]+)%.json$")
            if name then
                table.insert(configs, name)
            end
        end
    end
    return configs
end

-- Key System Function
function VoidX:CreateKeySystem(options)
    options = options or {}
    local keySystemTitle = options.Title or "VoidX Key System"
    local keySystemSubtitle = options.Subtitle or "Enter your key to access"
    local keySystemNote = options.Note or "Get key from our Discord"
    local correctKey = options.Key or {"VoidX-Free-Key-2024"}
    local keyURL = options.KeyURL or nil  -- URL'den key çekme
    local saveKey = options.SaveKey ~= false
    local keyLink = options.KeyLink or nil
    local onSuccess = options.OnSuccess or function() end
    
    Config.KeySystem.Enabled = true
    Config.KeySystem.SaveKey = saveKey
    
    -- URL'den key çek
    local validKeys = {}
    if keyURL then
        local success, response = pcall(function()
            return game:HttpGet(keyURL)
        end)
        
        if success and response then
            -- Her satırı ayrı bir key olarak al
            for line in response:gmatch("[^\r\n]+") do
                local trimmedLine = line:match("^%s*(.-)%s*$") -- Trim whitespace
                if trimmedLine and trimmedLine ~= "" then
                    table.insert(validKeys, trimmedLine)
                end
            end
        else
            warn("Failed to fetch keys from URL:", keyURL)
            -- Fallback to provided keys
            validKeys = type(correctKey) == "table" and correctKey or {correctKey}
        end
    else
        validKeys = type(correctKey) == "table" and correctKey or {correctKey}
    end
    
    Config.KeySystem.Key = validKeys
    
    -- Check saved key
    if saveKey and readfile and isfile then
        local savedKeyFile = Config.KeySystem.FileName .. ".txt"
        if isfile(savedKeyFile) then
            local savedKey = readfile(savedKeyFile)
            for _, key in pairs(Config.KeySystem.Key) do
                if savedKey == key then
                    onSuccess()
                    return true -- Key doğru, UI yüklenebilir
                end
            end
        end
    end
    
    -- Create Key GUI
    local keyGui = CreateInstance("ScreenGui", {
        Name = "VoidX_KeySystem",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    keyGui.Parent = GuiParent
    
    -- Blur effect
    local blur = CreateInstance("BlurEffect", {
        Size = 0
    })
    blur.Parent = game:GetService("Lighting")
    
    CreateTween(blur, {Size = 20}, 0.5)
    
    local keyFrame = CreateInstance("Frame", {
        Size = UDim2.new(0, 450, 0, 300),
        Position = UDim2.new(0.5, -225, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0
    })
    keyFrame.Parent = keyGui
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12)
    }, keyFrame)
    
    CreateInstance("UIStroke", {
        Color = Color3.fromRGB(102, 126, 234),
        Thickness = 2,
        Transparency = 0.5
    }, keyFrame)
    
    -- Gradient
    CreateInstance("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 255))
        },
        Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(1, 0.98)
        },
        Rotation = 45
    }, keyFrame)
    
    local keyTitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = keySystemTitle,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 22,
        Font = Enum.Font.GothamBold
    })
    keyTitle.Parent = keyFrame
    
    local keySubtitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        Text = keySystemSubtitle,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 14,
        Font = Enum.Font.Gotham
    })
    keySubtitle.Parent = keyFrame
    
    local keyInput = CreateInstance("TextBox", {
        Size = UDim2.new(0.8, 0, 0, 40),
        Position = UDim2.new(0.1, 0, 0.35, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 45),
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = "Enter Key...",
        PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false
    })
    keyInput.Parent = keyFrame
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, keyInput)
    
    local keyNote = CreateInstance("TextLabel", {
        Size = UDim2.new(0.8, 0, 0, 20),
        Position = UDim2.new(0.1, 0, 0.52, 0),
        BackgroundTransparency = 1,
        Text = keySystemNote,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 12,
        Font = Enum.Font.Gotham
    })
    keyNote.Parent = keyFrame
    
    local buttonContainer = CreateInstance("Frame", {
        Size = UDim2.new(0.8, 0, 0, 35),
        Position = UDim2.new(0.1, 0, 0.7, 0),
        BackgroundTransparency = 1
    })
    buttonContainer.Parent = keyFrame
    
    local submitButton = CreateInstance("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(102, 126, 234),
        BorderSizePixel = 0,
        Text = "Submit Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    submitButton.Parent = buttonContainer
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, submitButton)
    
    local getKeyButton = CreateInstance("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.new(0.52, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(118, 75, 162),
        BorderSizePixel = 0,
        Text = "Get Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    getKeyButton.Parent = buttonContainer
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, getKeyButton)
    
    -- Animations
    keyFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    CreateTween(keyFrame, {Position = UDim2.new(0.5, -225, 0.5, -150)}, 0.5, Enum.EasingStyle.Back)
    
    -- Key doğrulandı flag'i
    local keyVerified = false
    
    -- Key System Logic
    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = keyInput.Text
        local isValid = false
        
        for _, key in pairs(Config.KeySystem.Key) do
            if enteredKey == key then
                isValid = true
                break
            end
        end
        
        if isValid then
            keyVerified = true
            
            -- Save key if enabled
            if saveKey and writefile then
                writefile(Config.KeySystem.FileName .. ".txt", enteredKey)
            end
            
            -- Success animation
            CreateTween(keyFrame, {Size = UDim2.new(0, 450, 0, 150)}, 0.3)
            keyInput.Visible = false
            keyNote.Visible = false
            buttonContainer.Visible = false
            keySubtitle.Text = "Access Granted!"
            keySubtitle.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            wait(1.5)
            CreateTween(blur, {Size = 0}, 0.5)
            CreateTween(keyFrame, {Position = UDim2.new(0.5, -225, 1.5, 0)}, 0.5)
            wait(0.5)
            keyGui:Destroy()
            blur:Destroy()
            onSuccess()
        else
            -- Error animation
            keyInput.Text = ""
            local originalPos = keyFrame.Position
            for i = 1, 3 do
                CreateTween(keyFrame, {Position = originalPos + UDim2.new(0, -10, 0, 0)}, 0.05)
                wait(0.05)
                CreateTween(keyFrame, {Position = originalPos + UDim2.new(0, 10, 0, 0)}, 0.05)
                wait(0.05)
            end
            CreateTween(keyFrame, {Position = originalPos}, 0.05)
            
            keyInput.PlaceholderText = "Invalid Key!"
            keyInput.PlaceholderColor3 = Color3.fromRGB(255, 100, 100)
            wait(2)
            keyInput.PlaceholderText = "Enter Key..."
            keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        if keyLink then
            if setclipboard then
                setclipboard(keyLink)
                getKeyButton.Text = "Copied!"
                CreateTween(getKeyButton, {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}, 0.2)
            else
                getKeyButton.Text = "Check Console!"
                print("Key Link:", keyLink)
            end
            wait(2)
            getKeyButton.Text = "Get Key"
            CreateTween(getKeyButton, {BackgroundColor3 = Color3.fromRGB(118, 75, 162)}, 0.2)
        end
    end)
    
    -- Hover effects
    submitButton.MouseEnter:Connect(function()
        CreateTween(submitButton, {BackgroundColor3 = Color3.fromRGB(122, 146, 254)}, 0.2)
    end)
    
    submitButton.MouseLeave:Connect(function()
        CreateTween(submitButton, {BackgroundColor3 = Color3.fromRGB(102, 126, 234)}, 0.2)
    end)
    
    getKeyButton.MouseEnter:Connect(function()
        CreateTween(getKeyButton, {BackgroundColor3 = Color3.fromRGB(138, 95, 182)}, 0.2)
    end)
    
    getKeyButton.MouseLeave:Connect(function()
        CreateTween(getKeyButton, {BackgroundColor3 = Color3.fromRGB(118, 75, 162)}, 0.2)
    end)
    
    MakeDraggable(keyFrame, keyTitle)
    
    -- Key doğrulanana kadar bekle
    while not keyVerified do
        wait(0.1)
    end
    
    return true
end

-- Main Window Constructor
function VoidX:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "VoidX Framework"
    local windowSubtitle = options.Subtitle or "v3.0 Professional"
    local windowTheme = options.Theme or "Night"
    local windowSize = options.Size or UDim2.new(0, 900, 0, 600)
    local configEnabled = options.ConfigurationSaving and options.ConfigurationSaving.Enabled or false
    local configFolder = options.ConfigurationSaving and options.ConfigurationSaving.FolderName or "VoidXConfigs"
    local configFile = options.ConfigurationSaving and options.ConfigurationSaving.FileName or "Settings"
    
    local window = {}
    window.Theme = Config.Themes[windowTheme]
    window.Tabs = {}
    window.ActiveTab = nil
    window.SettingsTab = nil
    window.Elements = {}
    
    -- Create ScreenGui
    local screenGui = CreateInstance("ScreenGui", {
        Name = "VoidX_MainGUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    
    screenGui.Parent = GuiParent
    
    -- Loading Screen
    local loadingFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 30),
        BorderSizePixel = 0
    })
    loadingFrame.Parent = screenGui
    
    local loadingText = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 200, 0, 50),
        Position = UDim2.new(0.5, -100, 0.5, -25),
        BackgroundTransparency = 1,
        Text = windowName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Font = Enum.Font.GothamBold
    })
    loadingText.Parent = loadingFrame
    
    local loadingBar = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 0, 3),
        Position = UDim2.new(0.5, -100, 0.5, 15),
        BackgroundColor3 = Config.Themes[windowTheme].Accent,
        BorderSizePixel = 0
    })
    loadingBar.Parent = loadingFrame
    
    CreateTween(loadingBar, {Size = UDim2.new(0, 200, 0, 3)}, 1)
    wait(1)
    CreateTween(loadingFrame, {BackgroundTransparency = 1}, 0.5)
    CreateTween(loadingText, {TextTransparency = 1}, 0.5)
    CreateTween(loadingBar, {BackgroundTransparency = 1}, 0.5)
    wait(0.5)
    loadingFrame:Destroy()
    
    -- Main Frame
    local mainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 1.5, 0),
        BackgroundColor3 = window.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true
    })
    mainFrame.Parent = screenGui
    
    -- Animate main frame entrance
    CreateTween(mainFrame, {Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)}, 0.5, Enum.EasingStyle.Back)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
    }, mainFrame)
    
    -- Shadow effect
    CreateInstance("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Thickness = 3,
        Transparency = 0.7
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
        Position = UDim2.new(0, 0, 0, 5),
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
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = windowSubtitle,
        TextColor3 = window.Theme.TextDim,
        TextSize = 11,
        Font = Config.Font
    })
    versionLabel.Parent = logoSection
    
    -- Tab Container
    local tabContainer = CreateInstance("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -30, 1, -180),
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
    
    -- Settings Button (Global Settings like Rayfield)
    local settingsButton = CreateInstance("Frame", {
        Size = UDim2.new(1, -30, 0, 40),
        Position = UDim2.new(0, 15, 1, -60),
        BackgroundColor3 = window.Theme.Accent,
        BackgroundTransparency = 0.8
    })
    settingsButton.Parent = sidebar
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10)
    }, settingsButton)
    
    local settingsIcon = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 10, 0.5, -15),
        BackgroundTransparency = 1,
        Text = "⚙",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Config.Font
    })
    settingsIcon.Parent = settingsButton
    
    local settingsLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        BackgroundTransparency = 1,
        Text = "Settings",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Config.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    settingsLabel.Parent = settingsButton
    
    local settingsButtonClick = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextTransparency = 1
    })
    settingsButtonClick.Parent = settingsButton
    
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
    
    -- Create Settings Tab (Global Settings)
    local function CreateSettingsTab()
        local settingsTab = {}
        settingsTab.Name = "Settings"
        settingsTab.Elements = {}
        settingsTab.IsSettings = true
        
        -- Settings Content Frame
        local settingsContent = CreateInstance("ScrollingFrame", {
            Name = "SettingsContent",
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
        settingsContent.Parent = contentArea
        
        local settingsLayout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15)
        })
        settingsLayout.Parent = settingsContent
        
        -- Settings Header
        local settingsHeader = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 80),
            BackgroundTransparency = 1,
            LayoutOrder = 0
        })
        settingsHeader.Parent = settingsContent
        
        local settingsTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Text = "Global Settings",
            TextColor3 = window.Theme.Text,
            TextSize = 32,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        settingsTitle.Parent = settingsHeader
        
        local settingsDescription = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = "Configure your UI experience",
            TextColor3 = window.Theme.TextDim,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        settingsDescription.Parent = settingsHeader
        
        -- Theme Section
        local themeSection = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            LayoutOrder = 1
        })
        themeSection.Parent = settingsContent
        
        local themeSectionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "APPEARANCE",
            TextColor3 = window.Theme.Accent,
            TextSize = 12,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        themeSectionLabel.Parent = themeSection
        
        local themeSectionLine = CreateInstance("Frame", {
            Size = UDim2.new(0.5, -10, 0, 1),
            Position = UDim2.new(0.5, 10, 0.5, 0),
            BackgroundColor3 = window.Theme.Border,
            BorderSizePixel = 0
        })
        themeSectionLine.Parent = themeSection
        
        -- Theme Dropdown
        local themeDropdown = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = window.Theme.Background,
            BackgroundTransparency = 0.7,
            ClipsDescendants = true,
            LayoutOrder = 2
        })
        themeDropdown.Parent = settingsContent
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, themeDropdown)
        
        local themeButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundTransparency = 1,
            Text = "",
            TextTransparency = 1
        })
        themeButton.Parent = themeDropdown
        
        local themeLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = windowTheme,
            TextColor3 = window.Theme.Text,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        themeLabel.Parent = themeButton
        
        local themeArrow = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -40, 0, 15),
            BackgroundTransparency = 1,
            Text = "▼",
            TextColor3 = window.Theme.TextDim,
            TextSize = 12,
            Font = Config.Font
        })
        themeArrow.Parent = themeButton
        
        local themeListFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 50),
            BackgroundColor3 = window.Theme.Secondary,
            BorderSizePixel = 0,
            Visible = true
        })
        themeListFrame.Parent = themeDropdown
        
        local themeListLayout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        themeListLayout.Parent = themeListFrame
        
        local themeOpen = false
        
        -- Create theme options
        for themeName, _ in pairs(Config.Themes) do
            local themeOption = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.9,
                Text = themeName,
                TextColor3 = window.Theme.TextDim,
                TextSize = 13,
                Font = Config.Font
            })
            themeOption.Parent = themeListFrame
            
            themeOption.MouseEnter:Connect(function()
                CreateTween(themeOption, {
                    BackgroundTransparency = 0.7,
                    TextColor3 = window.Theme.Text
                })
            end)
            
            themeOption.MouseLeave:Connect(function()
                CreateTween(themeOption, {
                    BackgroundTransparency = 0.9,
                    TextColor3 = window.Theme.TextDim
                })
            end)
            
            themeOption.MouseButton1Click:Connect(function()
                themeLabel.Text = themeName
                window:ChangeTheme(themeName)
                GlobalSettings.Theme = themeName
                
                themeOpen = false
                CreateTween(themeDropdown, {Size = UDim2.new(1, 0, 0, 50)})
                CreateTween(themeArrow, {Rotation = 0})
            end)
        end
        
        themeButton.MouseButton1Click:Connect(function()
            themeOpen = not themeOpen
            
            if themeOpen then
                local contentHeight = themeListLayout.AbsoluteContentSize.Y
                CreateTween(themeDropdown, {
                    Size = UDim2.new(1, 0, 0, 50 + contentHeight)
                })
                CreateTween(themeArrow, {Rotation = 180})
            else
                CreateTween(themeDropdown, {Size = UDim2.new(1, 0, 0, 50)})
                CreateTween(themeArrow, {Rotation = 0})
            end
        end)
        
        -- UI Toggle Key
        local toggleKeySection = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            LayoutOrder = 3
        })
        toggleKeySection.Parent = settingsContent
        
        local toggleKeySectionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "KEYBINDS",
            TextColor3 = window.Theme.Accent,
            TextSize = 12,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        toggleKeySectionLabel.Parent = toggleKeySection
        
        local toggleKeySectionLine = CreateInstance("Frame", {
            Size = UDim2.new(0.5, -10, 0, 1),
            Position = UDim2.new(0.5, 10, 0.5, 0),
            BackgroundColor3 = window.Theme.Border,
            BorderSizePixel = 0
        })
        toggleKeySectionLine.Parent = toggleKeySection
        
        -- UI Toggle Keybind
        local toggleKeyFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = window.Theme.Background,
            BackgroundTransparency = 0.7,
            LayoutOrder = 4
        })
        toggleKeyFrame.Parent = settingsContent
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, toggleKeyFrame)
        
        local toggleKeyLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = "UI Toggle Key",
            TextColor3 = window.Theme.Text,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        toggleKeyLabel.Parent = toggleKeyFrame
        
        local toggleKeyButton = CreateInstance("TextButton", {
            Size = UDim2.new(0, 70, 0, 30),
            Position = UDim2.new(1, -85, 0.5, -15),
            BackgroundColor3 = window.Theme.Secondary,
            BorderSizePixel = 0,
            Text = GlobalSettings.ToggleKey.Name,
            TextColor3 = window.Theme.Text,
            TextSize = 13,
            Font = Config.Font
        })
        toggleKeyButton.Parent = toggleKeyFrame
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }, toggleKeyButton)
        
        local listeningForKey = false
        
        toggleKeyButton.MouseButton1Click:Connect(function()
            listeningForKey = true
            toggleKeyButton.Text = "..."
            CreateTween(toggleKeyButton, {BackgroundColor3 = window.Theme.Accent}, 0.2)
        end)
        
        -- Keybind List
        local keybindListSection = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            LayoutOrder = 5
        })
        keybindListSection.Parent = settingsContent
        
        local keybindListLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "ACTIVE KEYBINDS",
            TextColor3 = window.Theme.Accent,
            TextSize = 12,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        keybindListLabel.Parent = keybindListSection
        
        local keybindListLine = CreateInstance("Frame", {
            Size = UDim2.new(0.5, -10, 0, 1),
            Position = UDim2.new(0.5, 10, 0.5, 0),
            BackgroundColor3 = window.Theme.Border,
            BorderSizePixel = 0
        })
        keybindListLine.Parent = keybindListSection
        
        -- Keybind List Container
        local keybindListContainer = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 200),
            BackgroundColor3 = window.Theme.Background,
            BackgroundTransparency = 0.7,
            LayoutOrder = 6
        })
        keybindListContainer.Parent = settingsContent
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, keybindListContainer)
        
        local keybindListScroll = CreateInstance("ScrollingFrame", {
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = window.Theme.Accent,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = Enum.ScrollingDirection.Y
        })
        keybindListScroll.Parent = keybindListContainer
        
        local keybindListScrollLayout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })
        keybindListScrollLayout.Parent = keybindListScroll
        
        -- Function to update keybind list
        local function UpdateKeybindList()
            for _, child in pairs(keybindListScroll:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
            
            for name, key in pairs(GlobalSettings.KeybindList) do
                local keybindItem = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1
                })
                keybindItem.Parent = keybindListScroll
                
                local keybindName = CreateInstance("TextLabel", {
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = name,
                    TextColor3 = window.Theme.TextDim,
                    TextSize = 12,
                    Font = Config.Font,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                keybindName.Parent = keybindItem
                
                local keybindKey = CreateInstance("TextLabel", {
                    Size = UDim2.new(0.3, 0, 1, 0),
                    Position = UDim2.new(0.7, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = key.Name,
                    TextColor3 = window.Theme.Accent,
                    TextSize = 12,
                    Font = Config.Font,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                keybindKey.Parent = keybindItem
            end
            
            keybindListScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                keybindListScroll.CanvasSize = UDim2.new(0, 0, 0, keybindListScrollLayout.AbsoluteContentSize.Y)
            end)
        end
        
        settingsTab.UpdateKeybinds = UpdateKeybindList
        UpdateKeybindList()
        
        -- Config Section
        local configSection = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            LayoutOrder = 7
        })
        configSection.Parent = settingsContent
        
        local configSectionLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "CONFIGURATION",
            TextColor3 = window.Theme.Accent,
            TextSize = 12,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        configSectionLabel.Parent = configSection
        
        local configSectionLine = CreateInstance("Frame", {
            Size = UDim2.new(0.5, -10, 0, 1),
            Position = UDim2.new(0.5, 10, 0.5, 0),
            BackgroundColor3 = window.Theme.Border,
            BorderSizePixel = 0
        })
        configSectionLine.Parent = configSection
        
        -- Config Management
        local configFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 120),
            BackgroundColor3 = window.Theme.Background,
            BackgroundTransparency = 0.7,
            LayoutOrder = 8
        })
        configFrame.Parent = settingsContent
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, configFrame)
        
        -- Save Config Button
        local saveConfigButton = CreateInstance("TextButton", {
            Size = UDim2.new(0.45, 0, 0, 35),
            Position = UDim2.new(0.025, 0, 0.15, 0),
            BackgroundColor3 = window.Theme.Accent,
            BorderSizePixel = 0,
            Text = "Save Config",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            Font = Config.FontBold
        })
        saveConfigButton.Parent = configFrame
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }, saveConfigButton)
        
        -- Load Config Button
        local loadConfigButton = CreateInstance("TextButton", {
            Size = UDim2.new(0.45, 0, 0, 35),
            Position = UDim2.new(0.525, 0, 0.15, 0),
            BackgroundColor3 = window.Theme.AccentDark,
            BorderSizePixel = 0,
            Text = "Load Config",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            Font = Config.FontBold
        })
        loadConfigButton.Parent = configFrame
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8)
        }, loadConfigButton)
        
        -- Auto Save Toggle
        local autoSaveFrame = CreateInstance("Frame", {
            Size = UDim2.new(0.95, 0, 0, 30),
            Position = UDim2.new(0.025, 0, 0.6, 0),
            BackgroundTransparency = 1
        })
        autoSaveFrame.Parent = configFrame
        
        local autoSaveLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "Auto Save",
            TextColor3 = window.Theme.Text,
            TextSize = 13,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        autoSaveLabel.Parent = autoSaveFrame
        
        local autoSaveSwitch = CreateInstance("Frame", {
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -45, 0.5, -10),
            BackgroundColor3 = window.Theme.Border
        })
        autoSaveSwitch.Parent = autoSaveFrame
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }, autoSaveSwitch)
        
        local autoSaveCircle = CreateInstance("Frame", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        autoSaveCircle.Parent = autoSaveSwitch
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }, autoSaveCircle)
        
        local autoSaveButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextTransparency = 1
        })
        autoSaveButton.Parent = autoSaveFrame
        
        local autoSaveEnabled = Config.ConfigSystem.AutoSave
        
        local function updateAutoSave()
            if autoSaveEnabled then
                CreateTween(autoSaveSwitch, {BackgroundColor3 = window.Theme.Toggle}, 0.3)
                CreateTween(autoSaveCircle, {Position = UDim2.new(0, 22, 0, 2)}, 0.3)
            else
                CreateTween(autoSaveSwitch, {BackgroundColor3 = window.Theme.Border}, 0.3)
                CreateTween(autoSaveCircle, {Position = UDim2.new(0, 2, 0, 2)}, 0.3)
            end
            Config.ConfigSystem.AutoSave = autoSaveEnabled
        end
        
        autoSaveButton.MouseButton1Click:Connect(function()
            autoSaveEnabled = not autoSaveEnabled
            updateAutoSave()
        end)
        
        updateAutoSave()
        
        -- Auto-resize settings content
        settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Listen for UI Toggle Key changes
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listeningForKey and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                GlobalSettings.ToggleKey = input.KeyCode
                toggleKeyButton.Text = input.KeyCode.Name
                listeningForKey = false
                CreateTween(toggleKeyButton, {BackgroundColor3 = window.Theme.Secondary}, 0.2)
            end
        end)
        
        settingsTab.Content = settingsContent
        window.SettingsTab = settingsTab
        
        return settingsTab
    end
    
    -- Create the settings tab
    local settingsTab = CreateSettingsTab()
    
    -- Settings button click handler
    settingsButtonClick.MouseButton1Click:Connect(function()
        window:SelectTab(settingsTab)
    end)
    
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
        
        -- Hover Effect with animation
        tabButton.MouseEnter:Connect(function()
            if window.ActiveTab ~= tab then
                CreateTween(tabButton, {BackgroundTransparency = 0.8}, 0.2)
                CreateTween(tabLabel, {TextColor3 = window.Theme.Text}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if window.ActiveTab ~= tab then
                CreateTween(tabButton, {BackgroundTransparency = 1}, 0.2)
                CreateTween(tabLabel, {TextColor3 = window.Theme.TextDim}, 0.2)
            end
        end)
        
        -- ALL Element Creation Methods
        
        -- Keybind Element
        function tab:CreateKeybind(options)
            options = options or {}
            local keybindName = options.Name or "Keybind"
            local keybindDefault = options.Default or Enum.KeyCode.F
            local keybindCallback = options.Callback or function() end
            local keybindHold = options.HoldToInteract or false
            
            local keybindFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7,
                LayoutOrder = 90
            })
            keybindFrame.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
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
            })
            keybindLabel.Parent = keybindFrame
            
            local keybindButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 70, 0, 30),
                Position = UDim2.new(1, -85, 0.5, -15),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Text = keybindDefault.Name,
                TextColor3 = window.Theme.Text,
                TextSize = 13,
                Font = Config.Font
            })
            keybindButton.Parent = keybindFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, keybindButton)
            
            local currentKey = keybindDefault
            local listening = false
            local holding = false
            
            -- Add to global keybinds list
            GlobalSettings.KeybindList[keybindName] = currentKey
            if window.SettingsTab and window.SettingsTab.UpdateKeybinds then
                window.SettingsTab.UpdateKeybinds()
            end
            
            keybindButton.MouseButton1Click:Connect(function()
                listening = true
                keybindButton.Text = "..."
                CreateTween(keybindButton, {BackgroundColor3 = window.Theme.Accent}, 0.2)
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    keybindButton.Text = currentKey.Name
                    listening = false
                    CreateTween(keybindButton, {BackgroundColor3 = window.Theme.Secondary}, 0.2)
                    
                    -- Update global list
                    GlobalSettings.KeybindList[keybindName] = currentKey
                    if window.SettingsTab and window.SettingsTab.UpdateKeybinds then
                        window.SettingsTab.UpdateKeybinds()
                    end
                elseif input.KeyCode == currentKey and not gameProcessed and not listening then
                    if keybindHold then
                        holding = true
                        keybindCallback(true)
                    else
                        keybindCallback()
                    end
                end
            end)
            
            if keybindHold then
                UserInputService.InputEnded:Connect(function(input)
                    if input.KeyCode == currentKey and holding then
                        holding = false
                        keybindCallback(false)
                    end
                end)
            end
            
            local element = {
                Name = keybindName,
                SetKey = function(key)
                    currentKey = key
                    keybindButton.Text = key.Name
                    GlobalSettings.KeybindList[keybindName] = currentKey
                    if window.SettingsTab and window.SettingsTab.UpdateKeybinds then
                        window.SettingsTab.UpdateKeybinds()
                    end
                end,
                GetKey = function()
                    return currentKey
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
        end
        
        -- Section Element
        function tab:CreateSection(sectionName)
            local sectionFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                LayoutOrder = 100
            })
            sectionFrame.Parent = tabContent
            
            local sectionLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = sectionName:upper(),
                TextColor3 = window.Theme.Accent,
                TextSize = 12,
                Font = Config.FontBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            sectionLabel.Parent = sectionFrame
            
            local sectionLine = CreateInstance("Frame", {
                Size = UDim2.new(0.5, -10, 0, 1),
                Position = UDim2.new(0.5, 10, 0.5, 0),
                BackgroundColor3 = window.Theme.Border,
                BorderSizePixel = 0
            })
            sectionLine.Parent = sectionFrame
        end
        
        -- Divider Element
        function tab:CreateDivider()
            local divider = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = window.Theme.Border,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                LayoutOrder = 101
            })
            divider.Parent = tabContent
        end
        
        -- Label Element
        function tab:CreateLabel(text)
            local labelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                LayoutOrder = 102
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
        
        -- Paragraph Element
        function tab:CreateParagraph(title, content)
            local paragraphFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundTransparency = 1,
                LayoutOrder = 103
            })
            paragraphFrame.Parent = tabContent
            
            local paragraphTitle = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = title or "Title",
                TextColor3 = window.Theme.Text,
                TextSize = 15,
                Font = Config.FontBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            paragraphTitle.Parent = paragraphFrame
            
            local paragraphContent = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 35),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = content or "Content",
                TextColor3 = window.Theme.TextDim,
                TextSize = 13,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            })
            paragraphContent.Parent = paragraphFrame
            
            return {
                SetTitle = function(newTitle)
                    paragraphTitle.Text = newTitle
                end,
                SetContent = function(newContent)
                    paragraphContent.Text = newContent
                end
            }
        end
        
        -- Toggle Element with ripple effect
        function tab:CreateToggle(options)
            options = options or {}
            local toggleName = options.Name or "Toggle"
            local toggleDefault = options.Default or false
            local toggleCallback = options.Callback or function() end
            local toggleFlag = options.Flag or nil
            
            local toggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7,
                LayoutOrder = 104
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
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Toggle}, 0.3)
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 25, 0, 3)}, 0.3, Enum.EasingStyle.Back)
                else
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Border}, 0.3)
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 3, 0, 3)}, 0.3, Enum.EasingStyle.Back)
                end
                
                pcall(function()
                    toggleCallback(toggled)
                end)
            end
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
                
                -- Ripple effect
                local ripple = CreateInstance("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = window.Theme.Accent,
                    BackgroundTransparency = 0.5
                })
                ripple.Parent = toggleFrame
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                }, ripple)
                
                CreateTween(ripple, {
                    Size = UDim2.new(2, 0, 2, 0),
                    BackgroundTransparency = 1
                }, 0.5)
                
                task.wait(0.5)
                ripple:Destroy()
            end)
            
            updateToggle()
            
            local element = {
                Name = toggleName,
                Flag = toggleFlag,
                SetValue = function(value)
                    toggled = value
                    updateToggle()
                end,
                GetValue = function()
                    return toggled
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
        end
        
        -- Slider Element with smooth animations
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
                LayoutOrder = 105
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
            
            -- Gradient on fill
            CreateInstance("UIGradient", {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, window.Theme.Accent),
                    ColorSequenceKeypoint.new(1, window.Theme.AccentDark)
                },
                Rotation = 90
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
            
            local element = {
                Name = sliderName,
                SetValue = function(value)
                    updateSlider(value)
                end,
                GetValue = function()
                    return currentValue
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
        end
        
        -- Button Element with ripple
        function tab:CreateButton(options)
            options = options or {}
            local buttonName = options.Name or "Button"
            local buttonCallback = options.Callback or function() end
            
            local buttonFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundTransparency = 1,
                LayoutOrder = 106
            })
            buttonFrame.Parent = tabContent
            
            local button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = window.Theme.Accent,
                BorderSizePixel = 0,
                Text = buttonName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Config.FontBold,
                ClipsDescendants = true
            })
            button.Parent = buttonFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10)
            }, button)
            
            CreateInstance("UIGradient", {
                Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, window.Theme.Accent),
                    ColorSequenceKeypoint.new(1, window.Theme.AccentDark)
                },
                Rotation = 45
            }, button)
            
            button.MouseButton1Click:Connect(function()
                -- Ripple effect
                local mousePos = UserInputService:GetMouseLocation()
                local buttonPos = button.AbsolutePosition
                local relativePos = mousePos - buttonPos
                
                local ripple = CreateInstance("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0, relativePos.X, 0, relativePos.Y),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.3
                })
                ripple.Parent = button
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                }, ripple)
                
                CreateTween(ripple, {
                    Size = UDim2.new(0, 500, 0, 500),
                    BackgroundTransparency = 1
                }, 0.5)
                
                pcall(buttonCallback)
                
                task.wait(0.5)
                ripple:Destroy()
            end)
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundTransparency = 0.1}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundTransparency = 0}, 0.2)
            end)
            
            return {
                SetText = function(text)
                    button.Text = text
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
                ClipsDescendants = true,
                LayoutOrder = 107
            })
            dropdownFrame.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, dropdownFrame)
            
            local dropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundTransparency = 1,
                Text = "",
                TextTransparency = 1
            })
            dropdownButton.Parent = dropdownFrame
            
            local dropdownLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = dropdownDefault or dropdownName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            dropdownLabel.Parent = dropdownButton
            
            local dropdownArrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -40, 0, 15),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = window.Theme.TextDim,
                TextSize = 12,
                Font = Config.Font
            })
            dropdownArrow.Parent = dropdownButton
            
            local dropdownListFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 50),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Visible = true
            })
            dropdownListFrame.Parent = dropdownFrame
            
            local dropdownListLayout = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            dropdownListLayout.Parent = dropdownListFrame
            
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
                })
                optionButton.Parent = dropdownListFrame
                
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
                    pcall(function()
                        dropdownCallback(option)
                    end)
                    
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
            
            local element = {
                Name = dropdownName,
                SetOption = function(option)
                    currentOption = option
                    dropdownLabel.Text = option
                    pcall(function()
                        dropdownCallback(option)
                    end)
                end,
                GetOption = function()
                    return currentOption
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
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
                BackgroundTransparency = 0.7,
                LayoutOrder = 108
            })
            inputFrame.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
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
            })
            inputLabel.Parent = inputFrame
            
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
            })
            inputBox.Parent = inputFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, inputBox)
            
            inputBox.FocusLost:Connect(function(enterPressed)
                pcall(function()
                    inputCallback(inputBox.Text, enterPressed)
                end)
            end)
            
            local element = {
                Name = inputName,
                GetText = function()
                    return inputBox.Text
                end,
                SetText = function(text)
                    inputBox.Text = text
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
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
                BackgroundTransparency = 0.7,
                LayoutOrder = 109
            })
            colorFrame.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
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
            })
            colorLabel.Parent = colorFrame
            
            local colorDisplay = CreateInstance("Frame", {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(1, -45, 0.5, -15),
                BackgroundColor3 = colorDefault,
                BorderSizePixel = 0
            })
            colorDisplay.Parent = colorFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, colorDisplay)
            
            CreateInstance("UIStroke", {
                Color = window.Theme.Border,
                Thickness = 2
            }, colorDisplay)
            
            local colorButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                TextTransparency = 1
            })
            colorButton.Parent = colorDisplay
            
            -- Advanced color picker
            local pickerOpen = false
            local currentColor = colorDefault
            
            colorButton.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                
                if pickerOpen then
                    -- Create color picker popup
                    local pickerFrame = CreateInstance("Frame", {
                        Size = UDim2.new(0, 200, 0, 200),
                        Position = UDim2.new(1, -220, 0, 60),
                        BackgroundColor3 = window.Theme.Secondary,
                        BorderSizePixel = 0,
                        ZIndex = 10
                    })
                    pickerFrame.Parent = colorFrame
                    pickerFrame.Name = "ColorPicker"
                    
                    CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 10)
                    }, pickerFrame)
                    
                    -- Hue bar
                    local hueFrame = CreateInstance("Frame", {
                        Size = UDim2.new(0, 20, 1, -20),
                        Position = UDim2.new(1, -30, 0, 10),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0
                    })
                    hueFrame.Parent = pickerFrame
                    
                    CreateInstance("UIGradient", {
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                        },
                        Rotation = 90
                    }, hueFrame)
                    
                    CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 5)
                    }, hueFrame)
                    
                    -- Saturation/Value picker
                    local svFrame = CreateInstance("Frame", {
                        Size = UDim2.new(1, -50, 1, -20),
                        Position = UDim2.new(0, 10, 0, 10),
                        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                        BorderSizePixel = 0
                    })
                    svFrame.Parent = pickerFrame
                    
                    CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 5)
                    }, svFrame)
                    
                    local satGradient = CreateInstance("UIGradient", {
                        Color = ColorSequence.new{
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                        },
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1)
                        }
                    }, svFrame)
                    
                    local valGradient = CreateInstance("UIGradient", {
                        Color = ColorSequence.new(Color3.new(0, 0, 0)),
                        Transparency = NumberSequence.new{
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1)
                        },
                        Rotation = 90
                    }, svFrame)
                    
                    -- Function to update color
                    local function updateColor(h, s, v)
                        currentColor = Color3.fromHSV(h, s, v)
                        colorDisplay.BackgroundColor3 = currentColor
                        svFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        pcall(function()
                            colorCallback(currentColor)
                        end)
                    end
                    
                    -- Simple preset colors
                    local presets = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(255, 0, 255),
                        Color3.fromRGB(0, 255, 255),
                        Color3.fromRGB(255, 255, 255),
                        Color3.fromRGB(0, 0, 0)
                    }
                    
                    local presetContainer = CreateInstance("Frame", {
                        Size = UDim2.new(1, -20, 0, 30),
                        Position = UDim2.new(0, 10, 1, -35),
                        BackgroundTransparency = 1
                    })
                    presetContainer.Parent = pickerFrame
                    
                    for i, presetColor in ipairs(presets) do
                        local presetButton = CreateInstance("TextButton", {
                            Size = UDim2.new(0, 20, 0, 20),
                            Position = UDim2.new(0, (i-1) * 22, 0, 5),
                            BackgroundColor3 = presetColor,
                            BorderSizePixel = 0,
                            Text = ""
                        })
                        presetButton.Parent = presetContainer
                        
                        CreateInstance("UICorner", {
                            CornerRadius = UDim.new(0, 4)
                        }, presetButton)
                        
                        presetButton.MouseButton1Click:Connect(function()
                            currentColor = presetColor
                            colorDisplay.BackgroundColor3 = currentColor
                            pcall(function()
                                colorCallback(currentColor)
                            end)
                        end)
                    end
                else
                    -- Close picker
                    local picker = colorFrame:FindFirstChild("ColorPicker")
                    if picker then
                        picker:Destroy()
                    end
                end
            end)
            
            local element = {
                Name = colorName,
                SetColor = function(color)
                    currentColor = color
                    colorDisplay.BackgroundColor3 = color
                    pcall(function()
                        colorCallback(color)
                    end)
                end,
                GetColor = function()
                    return currentColor
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
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
            if t.Content then
                t.Content.Visible = false
            end
            if t.Button then
                CreateTween(t.Button, {BackgroundTransparency = 1}, 0.3)
                local label = t.Button:FindFirstChild("TabLabel")
                if label then
                    CreateTween(label, {TextColor3 = window.Theme.TextDim}, 0.3)
                end
            end
        end
        
        -- Handle settings tab
        if settingsTab and settingsTab.Content then
            settingsTab.Content.Visible = false
        end
        
        if tab.IsSettings then
            -- Settings tab selected
            if tab.Content then
                tab.Content.Visible = true
            end
            CreateTween(settingsButton, {BackgroundTransparency = 0.5}, 0.3)
        else
            -- Normal tab selected
            if tab.Content then
                tab.Content.Visible = true
            end
            if tab.Button then
                CreateTween(tab.Button, {BackgroundTransparency = 0.8, BackgroundColor3 = window.Theme.Accent}, 0.3)
                local label = tab.Button:FindFirstChild("TabLabel")
                if label then
                    CreateTween(label, {TextColor3 = window.Theme.Text}, 0.3)
                end
            end
            CreateTween(settingsButton, {BackgroundTransparency = 0.8}, 0.3)
        end
        
        window.ActiveTab = tab
    end
    
    -- Theme Change Function
    function window:ChangeTheme(themeName)
        local newTheme = Config.Themes[themeName]
        if not newTheme then return end
        
        window.Theme = newTheme
        
        -- Animate theme change
        CreateTween(mainFrame, {BackgroundColor3 = newTheme.Background}, 0.5)
        CreateTween(sidebar, {BackgroundColor3 = newTheme.Secondary}, 0.5)
        CreateTween(contentArea, {BackgroundColor3 = newTheme.ContentBG}, 0.5)
        
        -- Update all elements
        for _, tab in pairs(window.Tabs) do
            if tab.Button then
                local label = tab.Button:FindFirstChild("TabLabel")
                if label and window.ActiveTab ~= tab then
                    CreateTween(label, {TextColor3 = newTheme.TextDim}, 0.3)
                end
            end
        end
    end
    
    -- Advanced Notification System
    function window:CreateNotification(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 3
        local type = options.Type or "Info"
        local image = options.Image or nil
        local actions = options.Actions or {}
        
        local notifColors = {
            Info = window.Theme.Accent,
            Success = Color3.fromRGB(0, 200, 0),
            Warning = Color3.fromRGB(255, 170, 0),
            Error = Color3.fromRGB(255, 50, 50)
        }
        
        local notif = CreateInstance("Frame", {
            Size = UDim2.new(0, 350, 0, 100),
            Position = UDim2.new(1, 400, 1, -120),
            BackgroundColor3 = window.Theme.Secondary,
            BorderSizePixel = 0
        })
        notif.Parent = screenGui
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, notif)
        
        -- Type indicator
        local typeIndicator = CreateInstance("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = notifColors[type] or notifColors.Info,
            BorderSizePixel = 0
        })
        typeIndicator.Parent = notif
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, typeIndicator)
        
        -- Icon
        if image then
            local icon = CreateInstance("ImageLabel", {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(0, 15, 0, 15),
                BackgroundTransparency = 1,
                Image = "rbxassetid://" .. tostring(image),
                ImageColor3 = window.Theme.Text
            })
            icon.Parent = notif
        end
        
        local titleOffset = image and 55 or 15
        
        local notifTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -titleOffset - 15, 0, 25),
            Position = UDim2.new(0, titleOffset, 0, 12),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = window.Theme.Text,
            TextSize = 16,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        notifTitle.Parent = notif
        
        local notifContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -titleOffset - 15, 0, 30),
            Position = UDim2.new(0, titleOffset, 0, 37),
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = window.Theme.TextDim,
            TextSize = 13,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        notifContent.Parent = notif
        
        -- Actions
        if #actions > 0 then
            notif.Size = UDim2.new(0, 350, 0, 140)
            
            local actionContainer = CreateInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 1, -40),
                BackgroundTransparency = 1
            })
            actionContainer.Parent = notif
            
            for i, action in ipairs(actions) do
                local actionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(0.5, -5, 1, 0),
                    Position = UDim2.new((i-1) * 0.5, (i-1) * 5, 0, 0),
                    BackgroundColor3 = window.Theme.Accent,
                    BorderSizePixel = 0,
                    Text = action.Name or "Action",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    Font = Config.Font
                })
                actionButton.Parent = actionContainer
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 8)
                }, actionButton)
                
                actionButton.MouseButton1Click:Connect(function()
                    if action.Callback then
                        action.Callback()
                    end
                    notif:Destroy()
                end)
            end
        end
        
        -- Animate in
        CreateTween(notif, {Position = UDim2.new(1, -370, 1, -120 - (#GlobalSettings.Notifications * 110))}, 0.5, Enum.EasingStyle.Back)
        
        table.insert(GlobalSettings.Notifications, notif)
        
        -- Auto remove
        task.wait(duration)
        CreateTween(notif, {Position = UDim2.new(1, 400, 1, -120)}, 0.5)
        
        for i, n in ipairs(GlobalSettings.Notifications) do
            if n == notif then
                table.remove(GlobalSettings.Notifications, i)
                break
            end
        end
        
        -- Update other notifications positions
        for i, n in ipairs(GlobalSettings.Notifications) do
            CreateTween(n, {Position = UDim2.new(1, -370, 1, -120 - ((i-1) * 110))}, 0.3)
        end
        
        task.wait(0.5)
        notif:Destroy()
    end
    
    -- Config System
    function window:SaveConfig(configName)
        local config = {
            Theme = GlobalSettings.Theme,
            ToggleKey = GlobalSettings.ToggleKey.Name,
            Elements = {}
        }
        
        for _, element in pairs(window.Elements) do
            if element.GetValue then
                config.Elements[element.Name] = element.GetValue()
            elseif element.GetKey then
                config.Elements[element.Name] = element.GetKey().Name
            elseif element.GetOption then
                config.Elements[element.Name] = element.GetOption()
            elseif element.GetText then
                config.Elements[element.Name] = element.GetText()
            elseif element.GetColor then
                local color = element.GetColor()
                config.Elements[element.Name] = {
                    R = color.R,
                    G = color.G,
                    B = color.B
                }
            end
        end
        
        ConfigManager:SaveConfig(configName or GlobalSettings.CurrentConfig, config)
        
        window:CreateNotification({
            Title = "Config Saved",
            Content = "Configuration saved as: " .. (configName or GlobalSettings.CurrentConfig),
            Type = "Success",
            Duration = 2
        })
    end
    
    function window:LoadConfig(configName)
        local config = ConfigManager:LoadConfig(configName or GlobalSettings.CurrentConfig)
        
        if config then
            if config.Theme then
                window:ChangeTheme(config.Theme)
                GlobalSettings.Theme = config.Theme
            end
            
            if config.ToggleKey then
                GlobalSettings.ToggleKey = Enum.KeyCode[config.ToggleKey]
            end
            
            if config.Elements then
                for _, element in pairs(window.Elements) do
                    local value = config.Elements[element.Name]
                    if value ~= nil then
                        if element.SetValue then
                            element.SetValue(value)
                        elseif element.SetKey then
                            element.SetKey(Enum.KeyCode[value])
                        elseif element.SetOption then
                            element.SetOption(value)
                        elseif element.SetText then
                            element.SetText(value)
                        elseif element.SetColor and type(value) == "table" then
                            element.SetColor(Color3.new(value.R, value.G, value.B))
                        end
                    end
                end
            end
            
            window:CreateNotification({
                Title = "Config Loaded",
                Content = "Configuration loaded: " .. (configName or GlobalSettings.CurrentConfig),
                Type = "Success",
                Duration = 2
            })
        else
            window:CreateNotification({
                Title = "Config Error",
                Content = "Failed to load configuration",
                Type = "Error",
                Duration = 3
            })
        end
    end
    
    -- Toggle UI Visibility (Fixed for Shift Lock compatibility)
    local isVisible = true
    local toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        -- Check if it's our toggle key and not being processed by game
        if input.KeyCode == GlobalSettings.ToggleKey then
            -- Additional check for shift lock
            if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.LeftShift then
                -- Wait a frame to see if shift lock is being toggled
                task.wait()
                
                -- Check if mouse is locked (shift lock active)
                local mouseLocked = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
                
                -- Only toggle UI if shift lock is not being used
                if not mouseLocked and not gameProcessed then
                    isVisible = not isVisible
                    mainFrame.Visible = isVisible
                    
                    if isVisible then
                        CreateTween(mainFrame, {Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)}, 0.5, Enum.EasingStyle.Back)
                    end
                end
            else
                -- Non-shift keys work normally
                if not gameProcessed then
                    isVisible = not isVisible
                    mainFrame.Visible = isVisible
                    
                    if isVisible then
                        CreateTween(mainFrame, {Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)}, 0.5, Enum.EasingStyle.Back)
                    end
                end
            end
        end
    end)
    
    -- Store connection for cleanup
    if getgenv then
        table.insert(getgenv().VoidXConnections, toggleConnection)
    end
    
    -- Destroy function
    function window:Destroy()
        screenGui:Destroy()
        if getgenv then
            for _, connection in pairs(getgenv().VoidXConnections) do
                if connection and connection.Disconnect then
                    connection:Disconnect()
                end
            end
            getgenv().VoidXConnections = {}
        end
    end
    
    return window
end

return VoidX
