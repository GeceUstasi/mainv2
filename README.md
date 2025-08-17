# VoidX Framework v3.0 🚀

A professional and feature-rich UI library for Roblox with advanced animations, themes, and key system support.

![VoidX Banner](https://img.shields.io/badge/VoidX-Framework-667EEA?style=for-the-badge&logo=roblox&logoColor=white)
![Version](https://img.shields.io/badge/Version-3.0-00D9FF?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-5.1+-2C2D72?style=for-the-badge&logo=lua)

## ✨ Features

- 🎨 **8 Beautiful Themes** - Night, Ocean, Sunset, Forest, Midnight, Crimson, Arctic, Neon
- 🔐 **Advanced Key System** - URL support, multi-key validation, save system
- ⚙️ **Global Settings** - Rayfield-style settings panel with keybind management
- 💾 **Configuration System** - Save/load configs with JSON support
- 🔔 **Advanced Notifications** - Multiple types, actions, icons support
- 🎭 **Smooth Animations** - Ripple effects, gradient animations, easing styles
- 📱 **Responsive Design** - Auto-resize, scroll support, mobile-friendly
- 🎮 **Shift Lock Compatible** - Fixed UI toggle with shift lock detection

## 📦 Installation

```lua
local VoidX = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/voidx/refs/heads/main/voidxsource.lua"))()
🚀 Quick Start
Basic Window Creation
lualocal VoidX = loadstring(game:HttpGet("..."))()

local Window = VoidX:CreateWindow({
    Name = "My Script Hub",
    Subtitle = "v1.0",
    Theme = "Night", -- Night/Ocean/Sunset/Forest/Midnight/Crimson/Arctic/Neon
    Size = UDim2.new(0, 900, 0, 600)
})

local Tab = Window:CreateTab("Main", "🏠")

Tab:CreateButton({
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})
🔑 Key System
Basic Key System
lualocal keyVerified = VoidX:CreateKeySystem({
    Title = "Script Name",
    Key = {"key-123", "key-456"}, -- Multiple keys supported
    SaveKey = true, -- Save key for next time
    OnSuccess = function()
        print("Access granted!")
    end
})

if keyVerified then
    -- Create your window here
end
Key System with URL
lualocal keyVerified = VoidX:CreateKeySystem({
    Title = "Premium Hub",
    KeyURL = "https://pastebin.com/raw/YOUR_CODE", -- Fetch keys from URL
    Key = {"backup-key"}, -- Fallback keys if URL fails
    SaveKey = true,
    KeyLink = "discord.gg/yourserver", -- Get key link
    OnSuccess = function()
        print("Welcome!")
    end
})
📚 Elements Documentation
Toggle
luaTab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
Slider
luaTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})
Dropdown
luaTab:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(selected)
        print("Selected:", selected)
    end
})
Input
luaTab:CreateInput({
    Name = "Custom Text",
    Placeholder = "Enter text here...",
    Default = "",
    Callback = function(text)
        print("Input:", text)
    end
})
Keybind
luaTab:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.F,
    HoldToInteract = false,
    Callback = function(holding)
        print("Key pressed")
    end
})
Color Picker
luaTab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end
})
Section & Label
luaTab:CreateSection("Settings")
Tab:CreateLabel("This is a label")
Tab:CreateDivider()
Tab:CreateParagraph("Title", "This is a paragraph with longer content...")
🔔 Notifications
luaWindow:CreateNotification({
    Title = "Success!",
    Content = "Operation completed successfully",
    Type = "Success", -- Info/Success/Warning/Error
    Duration = 5,
    Image = "123456789", -- Optional: Roblox asset ID
    Actions = { -- Optional: Action buttons
        {
            Name = "OK",
            Callback = function()
                print("OK clicked")
            end
        }
    }
})
💾 Configuration System
Save Configuration
luaWindow:SaveConfig("MyConfig")
Load Configuration
luaWindow:LoadConfig("MyConfig")
🎨 Theme Customization
Change Theme
luaWindow:ChangeTheme("Ocean") -- Change theme dynamically
Available Themes

Night - Dark purple theme
Ocean - Blue ocean theme
Sunset - Orange/red sunset theme
Forest - Green nature theme
Midnight - Deep purple theme
Crimson - Red theme
Arctic - Light/white theme
Neon - Cyan/magenta neon theme

📋 Complete Example
lualocal VoidX = loadstring(game:HttpGet("..."))()

-- Key System
local keyVerified = VoidX:CreateKeySystem({
    Title = "VoidX Hub",
    KeyURL = "https://pastebin.com/raw/ABC123",
    SaveKey = true,
    KeyLink = "discord.gg/voidx",
    OnSuccess = function()
        print("Access granted!")
    end
})

if not keyVerified then return end

-- Create Window
local Window = VoidX:CreateWindow({
    Name = "VoidX Hub",
    Subtitle = "v3.0 Professional",
    Theme = "Night",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VoidXConfigs",
        FileName = "Settings"
    }
})

-- Main Tab
local MainTab = Window:CreateTab("Main", "🏠")

MainTab:CreateSection("Farm Settings")

MainTab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        _G.AutoFarm = value
    end
})

MainTab:CreateSlider({
    Name = "Farm Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Increment = 1,
    Callback = function(value)
        _G.FarmSpeed = value
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", "👤")

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", "⚙️")

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        print("UI Toggled")
    end
})

SettingsTab:CreateButton({
    Name = "Save Config",
    Callback = function()
        Window:SaveConfig("MyConfig")
    end
})

SettingsTab:CreateButton({
    Name = "Load Config",
    Callback = function()
        Window:LoadConfig("MyConfig")
    end
})

-- Welcome Notification
Window:CreateNotification({
    Title = "Welcome!",
    Content = "VoidX Hub loaded successfully",
    Type = "Success",
    Duration = 5,
    Actions = {
        {
            Name = "Discord",
            Callback = function()
                setclipboard("discord.gg/voidx")
            end
        }
    }
})
🛠️ Advanced Features
Global Settings Panel
The framework includes a built-in settings panel (like Rayfield) that can be accessed via the settings button. It includes:

Theme selector
UI toggle key configuration
Active keybinds list
Config management
Auto-save toggle

Shift Lock Compatibility
The UI toggle key is fully compatible with Roblox's shift lock feature. The framework automatically detects when shift lock is active and prevents UI toggle conflicts.
Memory Management
The framework includes automatic cleanup and memory management:

Proper connection handling
GUI cleanup on destroy
Prevention of memory leaks

📝 Notes

The framework uses RightShift as the default UI toggle key
All colors and themes are animated with smooth transitions
Elements support both Get and Set methods for dynamic updates
The key system supports multiple keys and URL fetching
Configurations are saved in JSON format

🤝 Support
For support, feature requests, or bug reports, please:

Open an issue on GitHub
Join our Discord server
Contact the developer

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
🙏 Credits
Created with ❤️ by [Your Name]
Special thanks to all contributors and the Roblox scripting community.

VoidX Framework - Professional UI Library for Roblox
