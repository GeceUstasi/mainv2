# VoidX Framework v3.0 🚀

<div align="center">

![VoidX Banner](https://img.shields.io/badge/VoidX-Framework-667EEA?style=for-the-badge&logo=roblox&logoColor=white)
![Version](https://img.shields.io/badge/Version-3.0-00D9FF?style=for-the-badge)
![Lua](https://img.shields.io/badge/Lua-5.1+-2C2D72?style=for-the-badge&logo=lua)

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
<details>
<summary><b>Click to expand</b></summary>

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

</details>

---

### 🎛️ UI Elements
<details>
<summary><b>Toggle</b></summary>

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
</details>

<details>
<summary><b>Button</b></summary>

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
</details>

<details>
<summary><b>Slider</b></summary>

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
</details>

*(📌 diğer UI elementleri de aynı formatta eklenmiştir)*  

---

## 🎮 Advanced Features
- **Global Settings Panel** (theme selector, keybinds, configs)  
- **Shift Lock Compatibility**  
- **Memory Management** (proper cleanup, no leaks)  

---

## 🛠️ Troubleshooting
<details>
<summary><b>Common Issues & Fixes</b></summary>

- **UI Not Showing:** check key system  
- **Shift Lock Conflict:** change toggle key  
- **Config Not Saving:** ensure executor supports `writefile`  

</details>

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
