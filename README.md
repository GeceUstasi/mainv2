# VoidX Framework (mainv2.lua)

**VoidX Framework – Professional Roblox UI Library v2.5.0 (XENO EDITION)**  
Roblox üzerinde modern, tema destekli, sürüklenebilir ve modüler UI (arayüz) oluşturmak için geliştirilmiş bir framework’tür.

---

## 🔹 Başlangıç

Framework’ü projene eklemek için:

```lua
local VoidX = loadstring(game:HttpGet("https://raw.githubusercontent.com/GeceUstasi/mainv2/refs/heads/main/mainv2.lua"))()
```

Artık `VoidX` üzerinden UI pencereleri oluşturabilirsin.

---

## 🔹 Pencere Oluşturma

```lua
local Window = VoidX:CreateWindow({
    Title = "Test Penceresi",
    Theme = "Night", -- Night, Ocean, Sunset, Forest
    Size = UDim2.new(0, 600, 0, 400),
    ToggleKey = Enum.KeyCode.RightShift
})
```

Bu kod bir pencere oluşturur. **RightShift** tuşu ile açılıp kapanabilir.

---

## 🔹 Sekme Ekleme

```lua
local Tab1 = Window:CreateTab("Genel", "🏠")
local Tab2 = Window:CreateTab("Ayarlar", "⚙️")
```

Her sekme kendi içinde elementler barındırır.

---

## 🔹 Bölüm (Section) Ekleme

```lua
local Section = Tab1:CreateSection("Kontroller")
```

Bölüm, UI elementlerini gruplamak için kullanılır.

---

## 🔹 UI Elementleri

### ✅ Toggle
```lua
Section:CreateToggle("God Mode", false, function(state)
    print("God Mode: ", state)
end)
```

---

### 🎚️ Slider
```lua
Section:CreateSlider("Hız", 0, 100, 50, function(value)
    print("Hız: ", value)
end)
```

---

### 🔘 Button
```lua
Section:CreateButton("Çalıştır", function()
    print("Butona basıldı!")
end)
```

---

### 📂 Dropdown
```lua
Section:CreateDropdown("Silah Seç", {"Kılıç", "Tabanca", "Ok"}, function(selected)
    print("Seçilen: ", selected)
end)
```

---

### 📝 Input
```lua
Section:CreateInput("İsim Gir", function(text)
    print("Kullanıcı yazdı: ", text)
end)
```

---

### 🎨 Color Picker
```lua
Section:CreateColorPicker("Renk Seç", Color3.fromRGB(255, 0, 0), function(color)
    print("Renk seçildi: ", color)
end)
```

---

### ⚠️ Prompt (Onay Kutusu)
```lua
Section:CreatePrompt("Emin misin?", function(yes)
    if yes then
        print("Kabul edildi.")
    else
        print("İptal edildi.")
    end
end)
```

---

## 🔹 Bildirim Gösterme
```lua
VoidX:CreateNotification({
    Title = "Başarılı",
    Text = "İşlem tamamlandı!",
    Duration = 3
})
```

3 saniyelik popup bildirimi.

---

## 🔹 Tema Değiştirme
```lua
VoidX:ChangeTheme("Ocean")
```

Mevcut temalar: `Night`, `Ocean`, `Sunset`, `Forest`.

---

## 🔹 UI Kapatma
```lua
VoidX:Destroy()
```

---

## 📝 Özet

- `CreateWindow` → Ana pencere oluşturur  
- `CreateTab` → Sekme ekler  
- `CreateSection` → Bölüm ekler  
- **Elementler:** Toggle, Slider, Button, Dropdown, Input, ColorPicker, Prompt  
- `CreateNotification` → Bildirim gösterir  
- `ChangeTheme` → Tema değiştirir  
- `Destroy` → UI’yı kapatır  
