-- Luminosity Lib'e Dropdown fonksiyonu ekleme
-- Bu kodu Options.Dropdown fonksiyonunun yerine koyun (satır ~600 civarı)

function Options.Dropdown(Title, List, Callback, Placeholder)
    List = List or {"Option 1", "Option 2", "Option 3"}
    Placeholder = Placeholder or "Select..."
    Callback = Callback or function() end
    
    local Properties = {
        Title = Title and tostring(Title) or "Dropdown";
        Value = "";
        List = List;
        Placeholder = Placeholder;
        Function = Callback;
        Opened = false;
    }

    local Container = Utility.new("ImageButton", {
        Name = "Dropdown",
        Parent = typeof(Frame) == "Instance" and Frame or Frame(),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        ZIndex = 1
    }, {
        -- Title Label
        Utility.new("TextLabel", {
            Name = "Title",
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            Font = Enum.Font.Gotham,
            Text = Title and tostring(Title) or "Dropdown",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            TextTransparency = 0.3,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        }),
        
        -- Dropdown Box
        Utility.new("ImageLabel", {
            Name = "DropdownBox",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0.2, 25, 0, 20),
            Image = "rbxassetid://3570695787",
            ImageColor3 = Color3.fromRGB(50, 55, 60),
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(100, 100, 100, 100),
            SliceScale = 0.04,
            ZIndex = 2
        }, {
            -- Selected Text
            Utility.new("TextLabel", {
                Name = "Selected",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -25, 1, 0),
                Font = Enum.Font.Gotham,
                Text = Placeholder,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextSize = 12,
                TextTransparency = 0.3,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3
            }),
            
            -- Arrow Icon
            Utility.new("ImageLabel", {
                Name = "Arrow",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -5, 0.5, 0),
                Size = UDim2.new(0, 10, 0, 6),
                Image = "rbxassetid://6034818372", -- Down arrow
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                ImageTransparency = 0.3,
                Rotation = 0,
                ZIndex = 3
            })
        }),
        
        -- Options Container
        Utility.new("Frame", {
            Name = "OptionsContainer",
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 0, 25),
            Size = UDim2.new(0.2, 25, 0, 0),
            Visible = false,
            ZIndex = 10,
            ClipsDescendants = true
        }, {
            -- Options Background
            Utility.new("ImageLabel", {
                Name = "Background",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.fromRGB(45, 50, 55),
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(100, 100, 100, 100),
                SliceScale = 0.04,
                ZIndex = 10
            }),
            
            -- Options List
            Utility.new("ScrollingFrame", {
                Name = "OptionsList",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
                ZIndex = 11,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }, {
                Utility.new("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 1)
                })
            })
        })
    })

    -- Create option buttons
    local function CreateOptions()
        -- Clear existing options
        for _, child in pairs(Container.OptionsContainer.OptionsList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Create new options
        for i, option in ipairs(Properties.List) do
            local OptionButton = Utility.new("TextButton", {
                Name = "Option_" .. i,
                Parent = Container.OptionsContainer.OptionsList,
                BackgroundColor3 = Color3.fromRGB(45, 50, 55),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.Gotham,
                Text = tostring(option),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                TextTransparency = 0.3,
                ZIndex = 12,
                LayoutOrder = i
            })
            
            -- Option hover effects
            OptionButton.MouseEnter:Connect(function()
                Utility.Tween(OptionButton, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
                Utility.Tween(OptionButton, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                Utility.Tween(OptionButton, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                Utility.Tween(OptionButton, TweenInfo.new(0.1), {TextTransparency = 0.3}):Play()
            end)
            
            -- Option click
            OptionButton.MouseButton1Click:Connect(function()
                Properties.Value = tostring(option)
                Container.DropdownBox.Selected.Text = tostring(option)
                Container.DropdownBox.Selected.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                -- Close dropdown
                Properties.Opened = false
                Utility.Tween(Container.OptionsContainer, TweenInfo.new(0.2), {Size = UDim2.new(0.2, 25, 0, 0)}):Play()
                Utility.Tween(Container.DropdownBox.Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                wait(0.2)
                Container.OptionsContainer.Visible = false
                
                -- Callback
                local Success, Error = pcall(Properties.Function, Properties.Value)
                assert(Luminosity.Settings.Debug == false or Success, Error)
            end)
        end
        
        -- Update canvas size
        local totalHeight = #Properties.List * 26
        Container.OptionsContainer.OptionsList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        
        -- Limit container height
        local maxHeight = math.min(totalHeight, 100)
        return maxHeight
    end

    -- Initialize options
    local maxHeight = CreateOptions()

    -- Dropdown click handler
    Container.MouseButton1Click:Connect(function()
        Properties.Opened = not Properties.Opened
        
        if Properties.Opened then
            Container.OptionsContainer.Visible = true
            Container.OptionsContainer.Size = UDim2.new(0.2, 25, 0, 0)
            Utility.Tween(Container.OptionsContainer, TweenInfo.new(0.2), {Size = UDim2.new(0.2, 25, 0, maxHeight)}):Play()
            Utility.Tween(Container.DropdownBox.Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            Utility.Tween(Container.OptionsContainer, TweenInfo.new(0.2), {Size = UDim2.new(0.2, 25, 0, 0)}):Play()
            Utility.Tween(Container.DropdownBox.Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
            wait(0.2)
            Container.OptionsContainer.Visible = false
        end
    end)

    -- Auto-resize title based on text length
    Container.DropdownBox.Selected:GetPropertyChangedSignal("Text"):Connect(function()
        local TextLength = Container.DropdownBox.Selected.TextBounds.X
        local MaxSize = (Container.AbsoluteSize.X - Container.Title.TextBounds.X) - 40
        Utility.Tween(Container.DropdownBox, TweenInfo.new(0.1), {
            Size = UDim2.new(0.2, math.clamp(TextLength + 35, 25, MaxSize), 0, 20)
        }):Play()
    end)

    -- Return metatable for property access
    return setmetatable({}, {
        __index = function(Self, Index)
            return Properties[Index]
        end;
        __newindex = function(Self, Index, Value)
            if Index == "Title" then
                Container.Title.Text = Value and tostring(Value) or "Dropdown"
            elseif Index == "Value" then
                Properties.Value = Value and tostring(Value) or ""
                Container.DropdownBox.Selected.Text = Properties.Value
                if Properties.Value ~= "" then
                    Container.DropdownBox.Selected.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            elseif Index == "List" then
                Properties.List = Value or {}
                maxHeight = CreateOptions()
            elseif Index == "Placeholder" then
                Properties.Placeholder = Value and tostring(Value) or "Select..."
                if Properties.Value == "" then
                    Container.DropdownBox.Selected.Text = Properties.Placeholder
                    Container.DropdownBox.Selected.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            Properties[Index] = Value
        end;
    })
end

-- KULLANIM ÖRNEĞİ:
--[[


--]]
