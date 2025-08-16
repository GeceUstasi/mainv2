# VoidX Framework (mainv2.lua)

**VoidX Framework – Professional Roblox UI Library v2.5.0 (XENO EDITION)**  
A modern, theme-supported, draggable, and modular UI (user interface) framework for Roblox.

---

## 🔹 Getting Started

Include the framework in your project with:

```lua
local VoidX = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/mainv2/refs/heads/main/mainv2.lua"))()
```

Now you can create UI windows via `VoidX`.

---

## 🔹 Create a Window

```lua
local Window = VoidX:CreateWindow({
    Title = "Test Window",
    Theme = "Night", -- Night, Ocean, Sunset, Forest
    Size = UDim2.new(0, 600, 0, 400),
    ToggleKey = Enum.KeyCode.RightShift
})
```

This will create a window. You can toggle it using the **RightShift** key.

---

## 🔹 Create Tabs

```lua
local Tab1 = Window:CreateTab("Home", "🏠")
local Tab2 = Window:CreateTab("Settings", "⚙️")
```

Each tab can hold its own UI elements.

---

## 🔹 Create Section

```lua
local Section = Tab1:CreateSection("Controls")
```

Sections group UI elements together.

---

## 🔹 UI Elements

### ✅ Toggle
```lua
Section:CreateToggle("God Mode", false, function(state)
    print("God Mode: ", state)
end)
```

---

### 🎚️ Slider
```lua
Section:CreateSlider("Speed", 0, 100, 50, function(value)
    print("Speed: ", value)
end)
```

---

### 🔘 Button
```lua
Section:CreateButton("Run", function()
    print("Button pressed!")
end)
```

---

### 📂 Dropdown
```lua
Section:CreateDropdown("Choose Weapon", {"Sword", "Gun", "Bow"}, function(selected)
    print("Selected: ", selected)
end)
```

---

### 📝 Input
```lua
Section:CreateInput("Enter Name", function(text)
    print("User typed: ", text)
end)
```

---

### 🎨 Color Picker
```lua
Section:CreateColorPicker("Pick Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Color selected: ", color)
end)
```

---

### ⚠️ Prompt (Confirmation Box)
```lua
Section:CreatePrompt("Are you sure?", function(yes)
    if yes then
        print("Confirmed.")
    else
        print("Cancelled.")
    end
end)
```

---

## 🔹 Show Notification
```lua
VoidX:CreateNotification({
    Title = "Success",
    Text = "Operation completed!",
    Duration = 3
})
```

Displays a popup notification for 3 seconds.

---

## 🔹 Change Theme
```lua
VoidX:ChangeTheme("Ocean")
```

Available themes: `Night`, `Ocean`, `Sunset`, `Forest`.

---

## 🔹 Destroy UI
```lua
VoidX:Destroy()
```

---

## 📝 Summary

- `CreateWindow` → Creates a main window  
- `CreateTab` → Adds a tab  
- `CreateSection` → Adds a section  
- **Elements:** Toggle, Slider, Button, Dropdown, Input, ColorPicker, Prompt  
- `CreateNotification` → Shows a notification  
- `ChangeTheme` → Switches theme  
- `Destroy` → Closes the UI  
