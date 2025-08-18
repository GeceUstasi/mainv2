# VoidX Framework v3.0 🚀

<div align="center">

![Show Image](#)  
![Show Image](#)  
![Show Image](#)  

**Professional Roblox UI Library with Advanced Features**  

📌 [Features](#-features) • [Installation](#-installation) • [Documentation](#-documentation) • [Examples](#-complete-examples)  

</div>

---

## ✨ Features

<table>
<tr>
<td>

🎨 **8 Beautiful Themes**
- Night (Dark Purple)  
- Ocean (Blue)  
- Sunset (Orange/Red)  
- Forest (Green)  
- Midnight (Deep Purple)  
- Crimson (Red)  
- Arctic (Light)  
- Neon (Cyan/Magenta)  

</td>
<td>

🔧 **Advanced Systems**
- 🔐 Key System with URL Support  
- 💾 Configuration Save/Load  
- 🔔 Advanced Notifications  
- ⚙️ Global Settings Panel  
- 🔍 Search & Player Search  
- 🔄 Refresh Functions  
- 🎮 Shift Lock Compatible  
- 📱 Mobile Friendly  

</td>
</tr>
</table>

---

## 📦 Installation

```lua
local VoidX = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/VoidX/main/source.lua"))()
```

---

## 🚀 Quick Start

```lua
local VoidX = loadstring(game:HttpGet("..."))()

local Window = VoidX:CreateWindow({
    Name = "Script Hub",
    Subtitle = "v1.0",
    Theme = "Night",
    Size = UDim2.new(0, 900, 0, 600),
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VoidXConfigs",
        FileName = "Settings"
    }
})

local Tab = Window:CreateTab("Main", "🏠")
```

---

## 📚 Documentation

### 🔑 Key System

#### Basic Key System
```lua
local keyVerified = VoidX:CreateKeySystem({
    Title = "Script Name",
    Subtitle = "Enter your key",
    Note = "Get key from Discord",
    Key = {"key-123", "key-456"},
    SaveKey = true,
    KeyLink = "discord.gg/server",
    OnSuccess = function()
        print("Access granted!")
    end
})
```

#### Key System with URL
```lua
local keyVerified = VoidX:CreateKeySystem({
    Title = "Premium Hub",
    KeyURL = "https://pastebin.com/raw/YOUR_CODE",
    Key = {"backup-key"},
    SaveKey = true,
    KeyLink = "discord.gg/yourserver",
    OnSuccess = function()
        print("Welcome!")
    end
})
```

**URL Format Example (Pastebin):**
```
vip-key-2024
premium-key-abc
test-key-123
```

---

### 🎛️ UI Elements

#### Toggle
```lua
local Toggle = Tab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Flag = "AutoFarmFlag",
    Callback = function(value)
        print("Toggle:", value)
        _G.AutoFarm = value
    end
})

-- Methods
Toggle:SetValue(true)
local isEnabled = Toggle:GetValue()
```

#### Button
```lua
local Button = Tab:CreateButton({
    Name = "Click Me!",
    Callback = function()
        print("Button clicked!")
    end
})

-- Methods
Button:SetText("New Text")
```

#### Slider
```lua
local Slider = Tab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Methods
Slider:SetValue(50)
local currentValue = Slider:GetValue()
```

#### Dropdown
```lua
local Dropdown = Tab:CreateDropdown({
    Name = "Select Weapon",
    Options = {"Sword", "Gun", "Bow"},
    Default = "Sword",
    Callback = function(option)
        print("Selected:", option)
    end
})

-- Methods
Dropdown:SetValue("Gun")
local selected = Dropdown:GetValue()
```

#### Input
```lua
local Input = Tab:CreateInput({
    Name = "Enter Name",
    PlaceholderText = "Type here...",
    Callback = function(text)
        print("Input:", text)
    end
})

-- Methods
Input:SetText("VoidX")
local currentText = Input:GetValue()
```

#### Keybind
```lua
local Keybind = Tab:CreateKeybind({
    Name = "Open Menu",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        print("Menu toggled!")
    end
})

-- Methods
Keybind:SetKey(Enum.KeyCode.LeftControl)
```

#### Color Picker
```lua
local ColorPicker = Tab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Selected color:", color)
    end
})

-- Methods
ColorPicker:SetValue(Color3.fromRGB(0, 255, 0))
local currentColor = ColorPicker:GetValue()
```

#### Player Search
```lua
local PlayerSearch = Tab:CreatePlayerSearch({
    Name = "Select Player",
    Callback = function(player)
        print("Selected player:", player)
    end
})
```

#### General Search
```lua
local Search = Tab:CreateSearch({
    Name = "Find Item",
    List = {"Item1", "Item2", "Item3"},
    Callback = function(item)
        print("Found:", item)
    end
})
```

#### Section & Label
```lua
local Section = Tab:CreateSection("Main Features")

local Label = Tab:CreateLabel("Status: Ready")
Label:SetText("Status: Running")
```

#### Notification
```lua
VoidX:Notify({
    Title = "Success",
    Description = "Script loaded successfully!",
    Duration = 5
})
```

#### Config
```lua
Window:SaveConfig()
Window:LoadConfig()
```

#### Theme
```lua
Window:SetTheme("Ocean") -- Available: Night, Ocean, Sunset, Forest, Midnight, Crimson, Arctic, Neon
```

---

## 🎮 Advanced Features
- **Global Settings Panel** (theme selector, keybinds, configs)  
- **Shift Lock Compatibility**  
- **Memory Management** (proper cleanup, no leaks)  

---

## 🛠️ Troubleshooting

- **UI Not Showing:** check key system  
- **Shift Lock Conflict:** change toggle key  
- **Config Not Saving:** ensure executor supports `writefile`  

---

## 📝 Notes
- Default UI toggle key: **RightShift**  
- Colors animate smoothly  
- Elements support **Get/Set** methods  
- Configs save in **JSON format**  
- Key system supports **multiple keys & live URL keys**  

---

## 🤝 Support
- 💬 Discord: [discord.gg/voidx](https://discord.gg/voidx)  
- 🐛 GitHub Issues: Report bugs here  

---

## 📄 License
**MIT License** – Free to use in your projects.  

<div align="center">
Made with ❤️ by **VoidX Team**  
⭐ Star this repo if you find it useful!  
</div>
