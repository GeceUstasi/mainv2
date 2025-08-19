-- VoidX Framework v3.1 | Professional Roblox UI Library
-- Fixed Dropdown Refresh + Advanced Search System

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

-- Advanced Item Scanner System
local ItemScanner = {}

function ItemScanner:ScanPath(path, stack)
    local items = {}
    local itemCounts = {}
    
    local success, target = pcall(function()
        local parts = {}
        for part in path:gmatch("[^%-]+") do
            table.insert(parts, part)
        end
        
        local current = game
        for _, part in ipairs(parts) do
            current = current:FindFirstChild(part)
            if not current then
                return nil
            end
        end
        return current
    end)
    
    if success and target then
        for _, child in pairs(target:GetChildren()) do
            local itemName = child.Name
            
            if stack then
                -- Count duplicates
                if itemCounts[itemName] then
                    itemCounts[itemName] = itemCounts[itemName] + 1
                else
                    itemCounts[itemName] = 1
                    table.insert(items, itemName)
                end
            else
                -- Add each item separately
                table.insert(items, itemName)
            end
        end
        
        -- Add count suffix for stacked items
        if stack then
            local stackedItems = {}
            for _, itemName in ipairs(items) do
                local count = itemCounts[itemName]
                if count > 1 then
                    table.insert(stackedItems, itemName .. " (" .. count .. "x)")
                else
                    table.insert(stackedItems, itemName)
                end
            end
            return stackedItems
        end
    else
        warn("Failed to scan path:", path)
    end
    
    return items
end

function ItemScanner:ScanPlayers()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        table.insert(players, player.Name)
    end
    return players
end

function ItemScanner:ScanCustom(customFunction)
    if type(customFunction) == "function" then
        local success, result = pcall(customFunction)
        if success and type(result) == "table" then
            return result
        end
    end
    return {}
end

-- Key System Function (kept same as original)
function VoidX:CreateKeySystem(options)
    options = options or {}
    local keySystemTitle = options.Title or "VoidX Key System"
    local keySystemSubtitle = options.Subtitle or "Enter your key to access"
    local keySystemNote = options.Note or "Get key from our Discord"
    local correctKey = options.Key or {"VoidX-Free-Key-2024"}
    local keyURL = options.KeyURL or nil
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
            for line in response:gmatch("[^\r\n]+") do
                local trimmedLine = line:match("^%s*(.-)%s*$")
                if trimmedLine and trimmedLine ~= "" then
                    table.insert(validKeys, trimmedLine)
                end
            end
        else
            warn("Failed to fetch keys from URL:", keyURL)
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
                    return true
                end
            end
        end
    end
    
    -- Create Key GUI (same as original)
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

-- Main Window Constructor (shortened for space - including only new elements)
function VoidX:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "VoidX Framework"
    local windowSubtitle = options.Subtitle or "v3.1 Professional"
    local windowTheme = options.Theme or "Night"
    local windowSize = options.Size or UDim2.new(0, 900, 0, 600)
    
    local window = {}
    window.Theme = Config.Themes[windowTheme]
    window.Tabs = {}
    window.ActiveTab = nil
    window.SettingsTab = nil
    window.Elements = {}
    
    -- Create ScreenGui and main interface (same as before)
    local screenGui = CreateInstance("ScreenGui", {
        Name = "VoidX_MainGUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    screenGui.Parent = GuiParent
    
    -- Loading Screen (same as before)
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
    
    -- Main Frame (same setup as before)
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
    
    CreateTween(mainFrame, {Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)}, 0.5, Enum.EasingStyle.Back)
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
    }, mainFrame)
    
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
    
    -- Settings Button
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
        
        tabButtonClick.MouseButton1Click:Connect(function()
            window:SelectTab(tab)
        end)
        
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
        
        -- FIXED DROPDOWN ELEMENT
        function tab:CreateDropdown(options)
            options = options or {}
            local dropdownName = options.Name or "Dropdown"
            local dropdownList = options.Options or {}
            local dropdownDefault = options.Default or (dropdownList[1] or "")
            local dropdownCallback = options.Callback or function() end
            local dropdownRefresh = options.Refresh or nil
            
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
                Size = UDim2.new(1, -90, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = dropdownDefault or dropdownName,
                TextColor3 = window.Theme.Text,
                TextSize = 14,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            dropdownLabel.Parent = dropdownButton
            
            -- Refresh button
            local refreshButton = nil
            if dropdownRefresh then
                refreshButton = CreateInstance("TextButton", {
                    Size = UDim2.new(0, 30, 0, 30),
                    Position = UDim2.new(1, -70, 0.5, -15),
                    BackgroundColor3 = window.Theme.Secondary,
                    BorderSizePixel = 0,
                    Text = "↻",
                    TextColor3 = window.Theme.TextDim,
                    TextSize = 18,
                    Font = Config.Font,
                    Rotation = 0
                })
                refreshButton.Parent = dropdownFrame
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 6)
                }, refreshButton)
            end
            
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
            local optionButtons = {}
            
            -- Function to create/update options
            local function updateOptions()
                -- Clear old options
                for _, button in pairs(optionButtons) do
                    button:Destroy()
                end
                optionButtons = {}
                
                -- Create new options
                for i, option in ipairs(dropdownList) do
                    local optionButton = CreateInstance("TextButton", {
                        Size = UDim2.new(1, 0, 0, 35),
                        BackgroundColor3 = window.Theme.Background,
                        BackgroundTransparency = 0.9,
                        Text = tostring(option),
                        TextColor3 = window.Theme.TextDim,
                        TextSize = 13,
                        Font = Config.Font,
                        LayoutOrder = i
                    })
                    optionButton.Parent = dropdownListFrame
                    table.insert(optionButtons, optionButton)
                    
                    optionButton.MouseEnter:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 0.7,
                            TextColor3 = window.Theme.Text
                        }, 0.1)
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 0.9,
                            TextColor3 = window.Theme.TextDim
                        }, 0.1)
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        currentOption = option
                        dropdownLabel.Text = tostring(option)
                        isOpen = false
                        CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.3)
                        CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                        
                        pcall(function()
                            dropdownCallback(option)
                        end)
                    end)
                end
                
                -- Update layout
                wait()
                local contentHeight = dropdownListLayout.AbsoluteContentSize.Y
                if isOpen then
                    dropdownFrame.Size = UDim2.new(1, 0, 0, 50 + contentHeight)
                end
            end
            
            -- Initial setup
            updateOptions()
            
            -- Dropdown toggle
            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    local contentHeight = dropdownListLayout.AbsoluteContentSize.Y
                    CreateTween(dropdownFrame, {
                        Size = UDim2.new(1, 0, 0, 50 + contentHeight)
                    }, 0.3)
                    CreateTween(dropdownArrow, {Rotation = 180}, 0.3)
                else
                    CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.3)
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                end
            end)
            
            -- Refresh button functionality
            if refreshButton then
                refreshButton.MouseButton1Click:Connect(function()
                    -- Rotation animation
                    CreateTween(refreshButton, {Rotation = refreshButton.Rotation + 360}, 0.8)
                    
                    -- Call refresh function
                    if dropdownRefresh then
                        local newOptions = dropdownRefresh()
                        if newOptions and type(newOptions) == "table" then
                            dropdownList = newOptions
                            
                            -- Close dropdown if open
                            if isOpen then
                                isOpen = false
                                CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.3)
                                CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                            end
                            
                            -- Update options
                            updateOptions()
                            
                            -- Check if current option still exists
                            local found = false
                            for _, option in ipairs(dropdownList) do
                                if tostring(option) == tostring(currentOption) then
                                    found = true
                                    break
                                end
                            end
                            
                            if not found and #dropdownList > 0 then
                                currentOption = dropdownList[1]
                                dropdownLabel.Text = tostring(currentOption)
                                pcall(function()
                                    dropdownCallback(currentOption)
                                end)
                            elseif #dropdownList == 0 then
                                currentOption = nil
                                dropdownLabel.Text = dropdownName
                            end
                        end
                    end
                end)
                
                refreshButton.MouseEnter:Connect(function()
                    CreateTween(refreshButton, {BackgroundColor3 = window.Theme.Accent}, 0.2)
                    CreateTween(refreshButton, {TextColor3 = window.Theme.Text}, 0.2)
                end)
                
                refreshButton.MouseLeave:Connect(function()
                    CreateTween(refreshButton, {BackgroundColor3 = window.Theme.Secondary}, 0.2)
                    CreateTween(refreshButton, {TextColor3 = window.Theme.TextDim}, 0.2)
                end)
            end
            
            local element = {
                Name = dropdownName,
                SetOption = function(option)
                    currentOption = option
                    dropdownLabel.Text = tostring(option)
                    pcall(function()
                        dropdownCallback(option)
                    end)
                end,
                GetOption = function()
                    return currentOption
                end,
                UpdateOptions = function(newOptions)
                    dropdownList = newOptions or {}
                    
                    -- Close dropdown if open
                    if isOpen then
                        isOpen = false
                        CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.3)
                        CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                    end
                    
                    updateOptions()
                    
                    -- Reset if current option not in new list
                    local found = false
                    for _, option in ipairs(dropdownList) do
                        if tostring(option) == tostring(currentOption) then
                            found = true
                            break
                        end
                    end
                    
                    if not found and #dropdownList > 0 then
                        currentOption = dropdownList[1]
                        dropdownLabel.Text = tostring(currentOption)
                        pcall(function()
                            dropdownCallback(currentOption)
                        end)
                    elseif #dropdownList == 0 then
                        currentOption = nil
                        dropdownLabel.Text = dropdownName
                    end
                end,
                Refresh = function()
                    if dropdownRefresh then
                        local newOptions = dropdownRefresh()
                        if newOptions then
                            element.UpdateOptions(newOptions)
                        end
                    end
                end,
                AddOption = function(option)
                    table.insert(dropdownList, option)
                    updateOptions()
                end,
                RemoveOption = function(option)
                    for i, opt in ipairs(dropdownList) do
                        if tostring(opt) == tostring(option) then
                            table.remove(dropdownList, i)
                            break
                        end
                    end
                    updateOptions()
                end,
                Clear = function()
                    dropdownList = {}
                    currentOption = nil
                    dropdownLabel.Text = dropdownName
                    updateOptions()
                    
                    -- Close dropdown if open
                    if isOpen then
                        isOpen = false
                        CreateTween(dropdownFrame, {Size = UDim2.new(1, 0, 0, 50)}, 0.3)
                        CreateTween(dropdownArrow, {Rotation = 0}, 0.3)
                    end
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
        end
        
        -- ADVANCED SMART SEARCH ELEMENT
        function tab:CreateSmartSearch(options)
            options = options or {}
            local searchName = options.Name or "Smart Search"
            local searchPath = options.Path or "workspace-Items" -- örnek: "workspace-Items", "Players", "ReplicatedStorage-Items"
            local searchCallback = options.Callback or function() end
            local searchPlaceholder = options.Placeholder or "Search or select..."
            local autoRefresh = options.AutoRefresh or false
            local refreshInterval = options.RefreshInterval or 3
            local stackDuplicates = options.Stack or false
            local customFunction = options.CustomFunction or nil -- Custom scan function
            
            local searchFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = window.Theme.Background,
                BackgroundTransparency = 0.7,
                ClipsDescendants = true,
                LayoutOrder = 110
            })
            searchFrame.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 12)
            }, searchFrame)
            
            -- Search input box
            local searchBox = CreateInstance("TextBox", {
                Size = UDim2.new(1, -120, 0, 30),
                Position = UDim2.new(0, 20, 0, 10),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = searchPlaceholder,
                PlaceholderColor3 = window.Theme.TextDim,
                TextColor3 = window.Theme.Text,
                TextSize = 13,
                Font = Config.Font,
                ClearTextOnFocus = false
            })
            searchBox.Parent = searchFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, searchBox)
            
            -- Status indicators
            local statusContainer = CreateInstance("Frame", {
                Size = UDim2.new(0, 80, 0, 30),
                Position = UDim2.new(1, -95, 0, 10),
                BackgroundTransparency = 1
            })
            statusContainer.Parent = searchFrame
            
            -- Item count
            local itemCount = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 40, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = "(0)",
                TextColor3 = window.Theme.Accent,
                TextSize = 11,
                Font = Config.Font
            })
            itemCount.Parent = statusContainer
            
            -- Dropdown arrow
            local dropdownArrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 25, 0, 5),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = window.Theme.TextDim,
                TextSize = 12,
                Font = Config.Font
            })
            dropdownArrow.Parent = statusContainer
            
            -- Auto-refresh indicator
            local refreshIndicator = nil
            if autoRefresh then
                refreshIndicator = CreateInstance("Frame", {
                    Size = UDim2.new(0, 6, 0, 6),
                    Position = UDim2.new(0, 50, 0, 12),
                    BackgroundColor3 = Color3.fromRGB(0, 255, 0),
                    BorderSizePixel = 0
                })
                refreshIndicator.Parent = statusContainer
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(1, 0)
                }, refreshIndicator)
                
                -- Pulse animation
                spawn(function()
                    while refreshIndicator and refreshIndicator.Parent do
                        CreateTween(refreshIndicator, {BackgroundTransparency = 0.5}, 0.5)
                        wait(0.5)
                        if refreshIndicator and refreshIndicator.Parent then
                            CreateTween(refreshIndicator, {BackgroundTransparency = 0}, 0.5)
                        end
                        wait(0.5)
                    end
                end)
            end
            
            -- Manual refresh button
            local refreshButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 60, 0, 5),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Text = "↻",
                TextColor3 = window.Theme.TextDim,
                TextSize = 14,
                Font = Config.Font
            })
            refreshButton.Parent = statusContainer
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 4)
            }, refreshButton)
            
            -- Results container
            local resultsFrame = CreateInstance("ScrollingFrame", {
                Size = UDim2.new(1, -40, 0, 0),
                Position = UDim2.new(0, 20, 0, 45),
                BackgroundColor3 = window.Theme.Secondary,
                BorderSizePixel = 0,
                Visible = true,
                ClipsDescendants = true,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = window.Theme.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y
            })
            resultsFrame.Parent = searchFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8)
            }, resultsFrame)
            
            local resultsLayout = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2)
            })
            resultsLayout.Parent = resultsFrame
            
            -- Variables
            local currentList = {}
            local filteredList = {}
            local selectedItem = nil
            local isOpen = false
            local refreshConnection = nil
            local resultButtons = {}
            
            -- Function to scan items based on path
            local function scanItems()
                local items = {}
                
                if customFunction then
                    -- Use custom function
                    items = ItemScanner:ScanCustom(customFunction)
                elseif searchPath == "Players" then
                    -- Scan players
                    items = ItemScanner:ScanPlayers()
                else
                    -- Scan game path
                    items = ItemScanner:ScanPath(searchPath, stackDuplicates)
                end
                
                return items or {}
            end
            
            -- Function to filter items based on search query
            local function filterItems(query)
                if query == "" then
                    return currentList
                end
                
                local results = {}
                local lowerQuery = query:lower()
                
                -- Create scored results for better sorting
                local scoredResults = {}
                
                for _, item in pairs(currentList) do
                    local itemText = tostring(item):lower()
                    local score = 0
                    
                    -- Exact match gets highest score
                    if itemText == lowerQuery then
                        score = 1000
                    -- Starts with query gets high score
                    elseif itemText:sub(1, #lowerQuery) == lowerQuery then
                        score = 500
                    -- Contains query gets medium score
                    elseif itemText:find(lowerQuery, 1, true) then
                        score = 100
                    end
                    
                    if score > 0 then
                        table.insert(scoredResults, {item = item, score = score, text = itemText})
                    end
                end
                
                -- Sort by score (highest first)
                table.sort(scoredResults, function(a, b)
                    if a.score == b.score then
                        return a.text < b.text -- Alphabetical if same score
                    end
                    return a.score > b.score
                end)
                
                -- Extract items from scored results
                for _, result in ipairs(scoredResults) do
                    table.insert(results, result.item)
                end
                
                return results
            end
            
            -- Function to update results display
            local function updateResults(query)
                query = query or ""
                
                -- Clear previous results
                for _, button in pairs(resultButtons) do
                    button:Destroy()
                end
                resultButtons = {}
                
                -- Filter items
                filteredList = filterItems(query)
                
                -- Create result buttons
                local maxResults = math.min(#filteredList, 10) -- Max 10 visible results
                for i = 1, maxResults do
                    local item = filteredList[i]
                    local resultButton = CreateInstance("TextButton", {
                        Size = UDim2.new(1, -4, 0, 28),
                        BackgroundColor3 = window.Theme.Background,
                        BackgroundTransparency = 0.9,
                        Text = tostring(item),
                        TextColor3 = window.Theme.TextDim,
                        TextSize = 12,
                        Font = Config.Font,
                        BorderSizePixel = 0,
                        LayoutOrder = i
                    })
                    resultButton.Parent = resultsFrame
                    table.insert(resultButtons, resultButton)
                    
                    CreateInstance("UICorner", {
                        CornerRadius = UDim.new(0, 6)
                    }, resultButton)
                    
                    -- Highlight matching text for search results
                    if query ~= "" then
                        local itemText = tostring(item):lower()
                        local queryLower = query:lower()
                        if itemText:sub(1, #queryLower) == queryLower then
                            -- Starts with query - make it more prominent
                            resultButton.TextColor3 = window.Theme.Accent
                        elseif itemText:find(queryLower, 1, true) then
                            -- Contains query - subtle highlight
                            resultButton.TextColor3 = window.Theme.Text
                        end
                    end
                    
                    resultButton.MouseEnter:Connect(function()
                        CreateTween(resultButton, {
                            BackgroundTransparency = 0.7,
                            TextColor3 = window.Theme.Text
                        }, 0.1)
                    end)
                    
                    resultButton.MouseLeave:Connect(function()
                        local textColor = window.Theme.TextDim
                        if query ~= "" then
                            local itemText = tostring(item):lower()
                            local queryLower = query:lower()
                            if itemText:sub(1, #queryLower) == queryLower then
                                textColor = window.Theme.Accent
                            elseif itemText:find(queryLower, 1, true) then
                                textColor = window.Theme.Text
                            end
                        end
                        CreateTween(resultButton, {
                            BackgroundTransparency = 0.9,
                            TextColor3 = textColor
                        }, 0.1)
                    end)
                    
                    resultButton.MouseButton1Click:Connect(function()
                        -- Extract original item name (remove count suffix if stacked)
                        local originalItem = tostring(item)
                        if stackDuplicates then
                            originalItem = originalItem:match("(.+) %(%d+x%)") or originalItem
                        end
                        
                        selectedItem = originalItem
                        searchBox.Text = originalItem
                        isOpen = false
                        searchFrame.Size = UDim2.new(1, 0, 0, 50)
                        CreateTween(dropdownArrow, {Rotation = 0}, 0.2)
                        
                        pcall(function()
                            searchCallback(originalItem, item) -- Pass both original and display names
                        end)
                    end)
                end
                
                -- Update frame size and canvas
                if isOpen and #filteredList > 0 then
                    local resultCount = math.min(#filteredList, 10)
                    local newHeight = 50 + (resultCount * 30) + 10
                    searchFrame.Size = UDim2.new(1, 0, 0, newHeight)
                    resultsFrame.CanvasSize = UDim2.new(0, 0, 0, resultsLayout.AbsoluteContentSize.Y)
                elseif isOpen then
                    -- Show "No results" message
                    local noResultsLabel = CreateInstance("TextLabel", {
                        Size = UDim2.new(1, -4, 0, 30),
                        BackgroundTransparency = 1,
                        Text = "No results found",
                        TextColor3 = window.Theme.TextDim,
                        TextSize = 12,
                        Font = Config.Font,
                        LayoutOrder = 1
                    })
                    noResultsLabel.Parent = resultsFrame
                    table.insert(resultButtons, noResultsLabel)
                    
                    searchFrame.Size = UDim2.new(1, 0, 0, 85)
                end
                
                -- Update item count
                itemCount.Text = "(" .. #filteredList .. "/" .. #currentList .. ")"
            end
            
            -- Function to refresh item list
            local function refreshList()
                currentList = scanItems()
                itemCount.Text = "(" .. #currentList .. ")"
                
                -- Update results if dropdown is open
                if isOpen then
                    updateResults(searchBox.Text)
                end
                
                -- Flash refresh button
                CreateTween(refreshButton, {BackgroundColor3 = window.Theme.Accent}, 0.2)
                CreateTween(refreshButton, {Rotation = refreshButton.Rotation + 360}, 0.5)
                wait(0.2)
                CreateTween(refreshButton, {BackgroundColor3 = window.Theme.Secondary}, 0.3)
            end
            
            -- Search box text changed
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                if isOpen then
                    updateResults(searchBox.Text)
                end
            end)
            
            -- Focus to open dropdown
            searchBox.Focused:Connect(function()
                if not isOpen then
                    isOpen = true
                    updateResults(searchBox.Text)
                    CreateTween(dropdownArrow, {Rotation = 180}, 0.2)
                end
            end)
            
            -- Click on arrow/area to toggle
            local toggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 80, 0, 30),
                Position = UDim2.new(1, -95, 0, 10),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = 2
            })
            toggleButton.Parent = searchFrame
            
            toggleButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    updateResults(searchBox.Text)
                    CreateTween(dropdownArrow, {Rotation = 180}, 0.2)
                else
                    searchFrame.Size = UDim2.new(1, 0, 0, 50)
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            -- Focus lost (with delay for button clicks)
            searchBox.FocusLost:Connect(function(enterPressed)
                if enterPressed and selectedItem then
                    return
                end
                
                task.wait(0.2) -- Wait for button clicks
                if not searchBox:IsFocused() then
                    isOpen = false
                    searchFrame.Size = UDim2.new(1, 0, 0, 50)
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.2)
                end
            end)
            
            -- Manual refresh button
            refreshButton.MouseButton1Click:Connect(function()
                refreshList()
            end)
            
            refreshButton.MouseEnter:Connect(function()
                CreateTween(refreshButton, {BackgroundColor3 = window.Theme.Accent}, 0.2)
                CreateTween(refreshButton, {TextColor3 = window.Theme.Text}, 0.2)
            end)
            
            refreshButton.MouseLeave:Connect(function()
                CreateTween(refreshButton, {BackgroundColor3 = window.Theme.Secondary}, 0.2)
                CreateTween(refreshButton, {TextColor3 = window.Theme.TextDim}, 0.2)
            end)
            
            -- Auto-refresh setup
            if autoRefresh then
                refreshConnection = task.spawn(function()
                    while searchFrame and searchFrame.Parent do
                        task.wait(refreshInterval)
                        if searchFrame and searchFrame.Parent then
                            refreshList()
                        end
                    end
                end)
            end
            
            -- Initial scan
            refreshList()
            
            local element = {
                Name = searchName,
                UpdatePath = function(newPath, newStack)
                    searchPath = newPath or searchPath
                    stackDuplicates = newStack or stackDuplicates
                    refreshList()
                end,
                SetCustomFunction = function(func)
                    customFunction = func
                    refreshList()
                end,
                GetSelected = function()
                    return selectedItem
                end,
                SetSelected = function(item)
                    selectedItem = item
                    searchBox.Text = tostring(item)
                    pcall(function()
                        searchCallback(item)
                    end)
                end,
                Clear = function()
                    selectedItem = nil
                    searchBox.Text = ""
                    isOpen = false
                    searchFrame.Size = UDim2.new(1, 0, 0, 50)
                    CreateTween(dropdownArrow, {Rotation = 0}, 0.2)
                end,
                Refresh = function()
                    refreshList()
                end,
                GetAllItems = function()
                    return currentList
                end,
                GetFilteredItems = function()
                    return filteredList
                end,
                SetAutoRefresh = function(enabled, interval)
                    -- Stop old connection
                    if refreshConnection then
                        task.cancel(refreshConnection)
                        refreshConnection = nil
                    end
                    
                    -- Start new if enabled
                    if enabled then
                        refreshInterval = interval or refreshInterval
                        refreshConnection = task.spawn(function()
                            while searchFrame and searchFrame.Parent do
                                task.wait(refreshInterval)
                                if searchFrame and searchFrame.Parent then
                                    refreshList()
                                end
                            end
                        end)
                        
                        -- Update indicator
                        if refreshIndicator then
                            refreshIndicator.Visible = true
                        end
                    else
                        -- Hide indicator
                        if refreshIndicator then
                            refreshIndicator.Visible = false
                        end
                    end
                end,
                SetStack = function(enabled)
                    stackDuplicates = enabled
                    refreshList()
                end,
                Destroy = function()
                    if refreshConnection then
                        task.cancel(refreshConnection)
                    end
                    searchFrame:Destroy()
                end
            }
            
            table.insert(tab.Elements, element)
            table.insert(window.Elements, element)
            return element
        end
        
        -- Other existing elements (Toggle, Slider, Button, Input, etc.)
        function tab:CreateToggle(options)
            options = options or {}
            local toggleName = options.Name or "Toggle"
            local toggleDefault = options.Default or false
            local toggleCallback = options.Callback or function() end
            
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
            end)
            
            updateToggle()
            
            local element = {
                Name = toggleName,
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
                Font = Config.FontBold
            })
            button.Parent = buttonFrame
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10)
            }, button)
            
            button.MouseButton1Click:Connect(function()
                pcall(buttonCallback)
            end)
            
            return {
                SetText = function(text)
                    button.Text = text
                end
            }
        end
        
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
        
        window.ActiveTab = tab
    end
    
    -- Theme Change Function
    function window:ChangeTheme(themeName)
        local newTheme = Config.Themes[themeName]
        if not newTheme then return end
        
        window.Theme = newTheme
        
        CreateTween(mainFrame, {BackgroundColor3 = newTheme.Background}, 0.5)
        CreateTween(sidebar, {BackgroundColor3 = newTheme.Secondary}, 0.5)
        CreateTween(contentArea, {BackgroundColor3 = newTheme.ContentBG}, 0.5)
    end
    
    -- Notification System
    function window:CreateNotification(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 3
        local type = options.Type or "Info"
        
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
        
        local typeIndicator = CreateInstance("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = notifColors[type] or notifColors.Info,
            BorderSizePixel = 0
        })
        typeIndicator.Parent = notif
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, typeIndicator)
        
        local notifTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -30, 0, 25),
            Position = UDim2.new(0, 15, 0, 12),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = window.Theme.Text,
            TextSize = 16,
            Font = Config.FontBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        notifTitle.Parent = notif
        
        local notifContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -30, 0, 30),
            Position = UDim2.new(0, 15, 0, 37),
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = window.Theme.TextDim,
            TextSize = 13,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        notifContent.Parent = notif
        
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
        
        for i, n in ipairs(GlobalSettings.Notifications) do
            CreateTween(n, {Position = UDim2.new(1, -370, 1, -120 - ((i-1) * 110))}, 0.3)
        end
        
        task.wait(0.5)
        notif:Destroy()
    end
    
    -- Toggle UI Visibility
    local isVisible = true
    local toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == GlobalSettings.ToggleKey and not gameProcessed then
            isVisible = not isVisible
            mainFrame.Visible = isVisible
            
            if isVisible then
                CreateTween(mainFrame, {Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)}, 0.5, Enum.EasingStyle.Back)
            end
        end
    end)
    
    if getgenv then
        table.insert(getgenv().VoidXConnections, toggleConnection)
    end
    
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
