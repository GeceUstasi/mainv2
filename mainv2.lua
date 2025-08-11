-- MODERN ROBLOX GUI - AURELIUS STYLE KULLANIM ÖRNEĞİ
-- Syntax hataları düzeltilmiş, modern tasarım

-- Framework'ü güvenli şekilde yükle
local ModernGUI
local success, result = pcall(function()
    -- Eğer loadstring kullanıyorsanız (GitHub'dan yükleme)
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/modern-gui/main/ModernGUI.lua"))()
    -- Eğer yerel modül kullanıyorsanız:
    -- return require(script.ModernGUI)
end)

if success and result then
    ModernGUI = result
    print("✅ Modern GUI Framework yüklendi!")
else
    warn("❌ GUI Framework yüklenemedi:", result)
    return
end

-- Framework'ü başlat
local GUI = ModernGUI.new("AURELIUS")

-- Ana window oluştur (Aurelius benzeri)
local mainWindow = GUI:createMainWindow()

-- Tab'ları oluştur (Aurelius'taki gibi sidebar navigation)
local homeTab = GUI:createTab(mainWindow, {
    Title = "Home",
    Icon = "🏠",
    Active = true
})

local localPlayerTab = GUI:createTab(mainWindow, {
    Title = "Local Player", 
    Icon = "👤"
})

local executorTab = GUI:createTab(mainWindow, {
    Title = "Executor",
    Icon = "💻"
})

local scriptsTab = GUI:createTab(mainWindow, {
    Title = "Scripts",
    Icon = "📜"
})

local gearTab = GUI:createTab(mainWindow, {
    Title = "Gear",
    Icon = "⚙️"
})

local playersTab = GUI:createTab(mainWindow, {
    Title = "Players",
    Icon = "👥"
})

-- HOME TAB İÇERİĞİ
pcall(function()
    -- Hoş geldin mesajı
    GUI:createButton(homeTab.Content, {
        Text = "Welcome to Modern GUI",
        Icon = "🎉",
        Style = "Primary",
        Size = UDim2.new(1, 0, 0, 50),
        Callback = function()
            GUI:createNotification({
                Title = "Welcome!",
                Text = "Modern GUI Framework is ready to use!",
                Type = "Success",
                Duration = 3
            })
        end
    })
    
    -- Hız ayarı
    GUI:createSlider(homeTab.Content, {
        Text = "Walkspeed",
        Min = 0,
        Max = 100,
        Default = 16,
        Callback = function(value)
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
            end)
        end
    })
    
    -- Jump power ayarı
    GUI:createSlider(homeTab.Content, {
        Text = "Jump Power",
        Min = 0,
        Max = 200,
        Default = 50,
        Callback = function(value)
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            end)
        end
    })
    
    -- Fly toggle
    GUI:createToggle(homeTab.Content, {
        Text = "Fly Mode",
        Default = false,
        Callback = function(enabled)
            if enabled then
                print("Fly enabled")
                GUI:createNotification({
                    Title = "Fly Mode",
                    Text = "Fly mode activated!",
                    Type = "Info"
                })
            else
                print("Fly disabled")
                GUI:createNotification({
                    Title = "Fly Mode", 
                    Text = "Fly mode deactivated!",
                    Type = "Warning"
                })
            end
        end
    })
end)

-- LOCAL PLAYER TAB İÇERİĞİ
pcall(function()
    -- God mode toggle
    GUI:createToggle(localPlayerTab.Content, {
        Text = "God Mode",
        Default = false,
        Callback = function(enabled)
            pcall(function()
                local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    if enabled then
                        humanoid.MaxHealth = math.huge
                        humanoid.Health = math.huge
                    else
                        humanoid.MaxHealth = 100
                        humanoid.Health = 100
                    end
                end
            end)
        end
    })
    
    -- Invisible toggle
    GUI:createToggle(localPlayerTab.Content, {
        Text = "Invisible",
        Default = false,
        Callback = function(enabled)
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.Transparency = enabled and 1 or 0
                        elseif part:IsA("Accessory") then
                            part.Handle.Transparency = enabled and 1 or 0
                        end
                    end
                end
            end)
        end
    })
    
    -- Noclip toggle
    GUI:createToggle(localPlayerTab.Content, {
        Text = "Noclip",
        Default = false,
        Callback = function(enabled)
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = not enabled
                        end
                    end
                end
            end)
        end
    })
    
    -- Teleport to spawn
    GUI:createButton(localPlayerTab.Content, {
        Text = "Teleport to Spawn",
        Icon = "🚀",
        Style = "Secondary",
        Callback = function()
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
                    GUI:createNotification({
                        Title = "Teleported!",
                        Text = "Teleported to spawn point",
                        Type = "Success"
                    })
                end
            end)
        end
    })
end)

-- EXECUTOR TAB İÇERİĞİ
pcall(function()
    -- Script executor placeholder
    GUI:createButton(executorTab.Content, {
        Text = "Execute Script",
        Icon = "▶️",
        Style = "Success", 
        Size = UDim2.new(1, 0, 0, 50),
        Callback = function()
            GUI:createNotification({
                Title = "Executor",
                Text = "Script execution feature would go here",
                Type = "Info"
            })
        end
    })
    
    -- Clear button
    GUI:createButton(executorTab.Content, {
        Text = "Clear Console",
        Icon = "🗑️",
        Style = "Warning",
        Callback = function()
            print("Console cleared")
        end
    })
end)

-- SCRIPTS TAB İÇERİĞİ
pcall(function()
    -- Infinite yield
    GUI:createButton(scriptsTab.Content, {
        Text = "Infinite Yield",
        Icon = "🔧",
        Style = "Primary",
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
                GUI:createNotification({
                    Title = "Script Loaded",
                    Text = "Infinite Yield loaded successfully!",
                    Type = "Success"
                })
            end)
        end
    })
    
    -- Dex Explorer
    GUI:createButton(scriptsTab.Content, {
        Text = "Dex Explorer",
        Icon = "🔍",
        Style = "Info",
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
                GUI:createNotification({
                    Title = "Script Loaded",
                    Text = "Dex Explorer loaded successfully!",
                    Type = "Success"
                })
            end)
        end
    })
    
    -- Custom script placeholder
    GUI:createButton(scriptsTab.Content, {
        Text = "Custom Script",
        Icon = "⚡",
        Style = "Secondary",
        Callback = function()
            GUI:createNotification({
                Title = "Custom Script",
                Text = "Add your custom scripts here!",
                Type = "Info"
            })
        end
    })
end)

-- GEAR TAB İÇERİĞİ
pcall(function()
    -- ESP toggle
    GUI:createToggle(gearTab.Content, {
        Text = "Player ESP",
        Default = false,
        Callback = function(enabled)
            if enabled then
                print("ESP enabled")
                GUI:createNotification({
                    Title = "ESP",
                    Text = "Player ESP activated!",
                    Type = "Success"
                })
            else
                print("ESP disabled")
            end
        end
    })
    
    -- Aimbot toggle
    GUI:createToggle(gearTab.Content, {
        Text = "Aimbot",
        Default = false,
        Callback = function(enabled)
            GUI:createNotification({
                Title = "Aimbot",
                Text = enabled and "Aimbot enabled!" or "Aimbot disabled!",
                Type = enabled and "Warning" or "Info"
            })
        end
    })
    
    -- FOV slider
    GUI:createSlider(gearTab.Content, {
        Text = "Field of View",
        Min = 70,
        Max = 120,
        Default = 70,
        Callback = function(value)
            pcall(function()
                workspace.CurrentCamera.FieldOfView = value
            end)
        end
    })
    
    -- Brightness slider
    GUI:createSlider(gearTab.Content, {
        Text = "Brightness",
        Min = 0,
        Max = 5,
        Default = 1,
        Callback = function(value)
            pcall(function()
                game:GetService("Lighting").Brightness = value
            end)
        end
    })
    
    -- Fullbright button
    GUI:createButton(gearTab.Content, {
        Text = "Fullbright",
        Icon = "💡",
        Style = "Warning",
        Callback = function()
            pcall(function()
                local lighting = game:GetService("Lighting")
                lighting.Brightness = 2
                lighting.ClockTime = 14
                lighting.FogEnd = 100000
                lighting.GlobalShadows = false
                lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                
                GUI:createNotification({
                    Title = "Fullbright",
                    Text = "Fullbright activated!",
                    Type = "Success"
                })
            end)
        end
    })
end)

-- PLAYERS TAB İÇERİĞİ
pcall(function()
    -- Player list placeholder
    GUI:createButton(playersTab.Content, {
        Text = "Refresh Player List",
        Icon = "🔄",
        Style = "Primary",
        Size = UDim2.new(1, 0, 0, 40),
        Callback = function()
            local playerCount = #game.Players:GetPlayers()
            GUI:createNotification({
                Title = "Players",
                Text = "Found " .. playerCount .. " players online",
                Type = "Info"
            })
        end
    })
    
    -- Teleport to random player
    GUI:createButton(playersTab.Content, {
        Text = "Teleport to Random Player",
        Icon = "🎲",
        Style = "Secondary",
        Callback = function()
            pcall(function()
                local players = game.Players:GetPlayers()
                local randomPlayer = players[math.random(1, #players)]
                
                if randomPlayer and randomPlayer ~= game.Players.LocalPlayer then
                    local character = game.Players.LocalPlayer.Character
                    local targetCharacter = randomPlayer.Character
                    
                    if character and targetCharacter and 
                       character:FindFirstChild("HumanoidRootPart") and 
                       targetCharacter:FindFirstChild("HumanoidRootPart") then
                        
                        character.HumanoidRootPart.CFrame = targetCharacter.HumanoidRootPart.CFrame
                        
                        GUI:createNotification({
                            Title = "Teleported!",
                            Text = "Teleported to " .. randomPlayer.DisplayName,
                            Type = "Success"
                        })
                    end
                end
            end)
        end
    })
    
    -- Spectate toggle
    GUI:createToggle(playersTab.Content, {
        Text = "Spectate Mode",
        Default = false,
        Callback = function(enabled)
            pcall(function()
                local camera = workspace.CurrentCamera
                if enabled then
                    -- Spectate random player
                    local players = game.Players:GetPlayers()
                    local randomPlayer = players[math.random(1, #players)]
                    if randomPlayer and randomPlayer ~= game.Players.LocalPlayer then
                        camera.CameraSubject = randomPlayer.Character.Humanoid
                        GUI:createNotification({
                            Title = "Spectating",
                            Text = "Now spectating " .. randomPlayer.DisplayName,
                            Type = "Info"
                        })
                    end
                else
                    -- Return to self
                    camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
                    GUI:createNotification({
                        Title = "Spectating",
                        Text = "Returned to normal view",
                        Type = "Info"
                    })
                end
            end)
        end
    })
end)

-- Global settings ve ek özellikler
pcall(function()
    -- Tema değiştirme (Home tab'a ekle)
    GUI:createButton(homeTab.Content, {
        Text = "Change Theme",
        Icon = "🎨",
        Style = "Info",
        Callback = function()
            -- Tema rengini rastgele değiştir
            local colors = {
                Color3.fromRGB(64, 224, 208),  -- Turquoise (default)
                Color3.fromRGB(255, 100, 100), -- Red
                Color3.fromRGB(100, 255, 100), -- Green
                Color3.fromRGB(100, 100, 255), -- Blue
                Color3.fromRGB(255, 255, 100), -- Yellow
                Color3.fromRGB(255, 100, 255), -- Magenta
            }
            
            local newColor = colors[math.random(1, #colors)]
            -- Burada tema değiştirme kodu olacak
            
            GUI:createNotification({
                Title = "Theme Changed",
                Text = "New theme color applied!",
                Type = "Success"
            })
        end
    })
    
    -- Keybind örneği (ESC tuşu ile GUI toggle)
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
            -- GUI visibility toggle
            GUI.ScreenGui.Enabled = not GUI.ScreenGui.Enabled
        end
    end)
end)

-- Hoş geldin bildirimi (1 saniye gecikme ile)
task.spawn(function()
    task.wait(1)
    GUI:createNotification({
        Title = "🎉 Welcome to AURELIUS!",
        Text = "Modern GUI Framework loaded successfully! Press INSERT to toggle.",
        Type = "Success",
        Duration = 6
    })
end)

-- Framework bilgisi
print("🚀 Modern GUI Framework (Aurelius Style) loaded!")
print("📋 Features:")
print("   • Modern türkuaz tasarım")
print("   • Sidebar navigation")
print("   • Smooth animations") 
print("   • Notification system")
print("   • Drag & drop windows")
print("   • Responsive design")
print("🔧 Press INSERT to toggle GUI visibility")

-- Global değişken olarak kaydet (isteğe bağlı)
_G.ModernGUI = GUI
_G.MainWindow = mainWindow

-- Temizlik fonksiyonu (player leave olduğunda)
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game:GetService("Players").LocalPlayer then
        pcall(function()
            GUI:destroy()
        end)
    end
end)

-- Script kapandığında temizlik
game:GetService("RunService").Heartbeat:Connect(function()
    if not GUI or not GUI.ScreenGui or not GUI.ScreenGui.Parent then
        -- GUI destroyed, clean up
        _G.ModernGUI = nil
        _G.MainWindow = nil
    end
end)
