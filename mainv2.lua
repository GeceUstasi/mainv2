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
        
        -- ALL Element Creation Methods
        
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
        
        -- Toggle Element
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
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Toggle})
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 25, 0, 3)})
                else
                    CreateTween(toggleSwitch, {BackgroundColor3 = window.Theme.Border})
                    CreateTween(toggleCircle, {Position = UDim2.new(0, 3, 0, 3)})
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
            return element
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
            return element
        end
        
        -- Button Element
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
            
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundTransparency = 0.2})
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundTransparency = 0})
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
            
            local colorButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                TextTransparency = 1
            })
            colorButton.Parent = colorDisplay
            
            -- Simple color picker
            colorButton.MouseButton1Click:Connect(function()
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
                pcall(function()
                    colorCallback(newColor)
                end)
            end)
            
            local element = {
                Name = colorName,
                SetColor = function(color)
                    colorDisplay.BackgroundColor3 = color
                    pcall(function()
                        colorCallback(color)
                    end)
                end,
                GetColor = function()
                    return colorDisplay.BackgroundColor3
                end
            }
            
            table.insert(tab.Elements, element)
            return element
        end
        
        -- Prompt Element (Dialog)
        function tab:CreatePrompt(options)
            options = options or {}
            local promptTitle = options.Title or "Confirm"
            local promptText = options.Text or "Are you sure?"
            local promptConfirm = options.ConfirmText or "Yes"
            local promptCancel = options.CancelText or "No"
            local promptCallback = options.Callback or function() end
            
            local promptButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 45),
                BackgroundColor3 = window.Theme.Accent,
                BorderSizePixel = 0,
                Text = promptTitle,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                Font = Config.FontBold,
                LayoutOrder = 110
            })
            promptButton.Parent = tabContent
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 10)
            }, promptButton)
            
            promptButton.MouseButton1Click:Connect(function()
                -- Create prompt dialog
                local promptDialog = CreateInstance("Frame", {
                    Size = UDim2.new(0, 350, 0, 200),
                    Position = UDim2.new(0.5, -175, 0.5, -100),
                    BackgroundColor3 = window.Theme.Secondary,
                    BorderSizePixel = 0,
                    ZIndex = 10
                })
                promptDialog.Parent = screenGui
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 12)
                }, promptDialog)
                
                local dialogTitle = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, 10),
                    BackgroundTransparency = 1,
                    Text = promptTitle,
                    TextColor3 = window.Theme.Text,
                    TextSize = 18,
                    Font = Config.FontBold
                })
                dialogTitle.Parent = promptDialog
                
                local dialogText = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -20, 0, 60),
                    Position = UDim2.new(0, 10, 0, 50),
                    BackgroundTransparency = 1,
                    Text = promptText,
                    TextColor3 = window.Theme.TextDim,
                    TextSize = 14,
                    Font = Config.Font,
                    TextWrapped = true
                })
                dialogText.Parent = promptDialog
                
                local confirmButton = CreateInstance("TextButton", {
                    Size = UDim2.new(0.4, 0, 0, 35),
                    Position = UDim2.new(0.08, 0, 0.75, 0),
                    BackgroundColor3 = window.Theme.Accent,
                    BorderSizePixel = 0,
                    Text = promptConfirm,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    Font = Config.FontBold
                })
                confirmButton.Parent = promptDialog
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 8)
                }, confirmButton)
                
                local cancelButton = CreateInstance("TextButton", {
                    Size = UDim2.new(0.4, 0, 0, 35),
                    Position = UDim2.new(0.52, 0, 0.75, 0),
                    BackgroundColor3 = window.Theme.Border,
                    BorderSizePixel = 0,
                    Text = promptCancel,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 14,
                    Font = Config.FontBold
                })
                cancelButton.Parent = promptDialog
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 8)
                }, cancelButton)
                
                confirmButton.MouseButton1Click:Connect(function()
                    pcall(function()
                        promptCallback(true)
                    end)
                    promptDialog:Destroy()
                end)
                
                cancelButton.MouseButton1Click:Connect(function()
                    pcall(function()
                        promptCallback(false)
                    end)
                    promptDialog:Destroy()
                end)
                
                MakeDraggable(promptDialog, dialogTitle)
            end)
            
            return {
                SetText = function(text)
                    promptButton.Text = text
                end
            }
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
            t.Content.Visible = false
            CreateTween(t.Button, {BackgroundTransparency = 1})
            local label = t.Button:FindFirstChild("TabLabel")
            if label then
                CreateTween(label, {TextColor3 = window.Theme.TextDim})
            end
        end
        
        tab.Content.Visible = true
        CreateTween(tab.Button, {BackgroundTransparency = 0.8})
        local label = tab.Button:FindFirstChild("TabLabel")
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
        CreateTween(contentArea, {BackgroundColor3 = newTheme.ContentBG})
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
        })
        notif.Parent = screenGui
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
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
        })
        notifTitle.Parent = notif
        
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
        })
        notifContent.Parent = notif
        
        CreateTween(notif, {Position = UDim2.new(1, -320, 1, -100)}, 0.5)
        
        task.wait(duration)
        CreateTween(notif, {Position = UDim2.new(1, 320, 1, -100)}, 0.5)
        task.wait(0.5)
        notif:Destroy()
    end
    
    -- Config System
    function window:SaveConfig(configName)
        local config = {}
        for _, tab in pairs(window.Tabs) do
            if tab.Elements then
                config[tab.Name] = {}
                for _, element in pairs(tab.Elements) do
                    if element.GetValue then
                        config[tab.Name][element.Name] = element.GetValue()
                    elseif element.GetOption then
                        config[tab.Name][element.Name] = element.GetOption()
                    elseif element.GetText then
                        config[tab.Name][element.Name] = element.GetText()
                    elseif element.GetColor then
                        config[tab.Name][element.Name] = {
                            R = element.GetColor().R,
                            G = element.GetColor().G,
                            B = element.GetColor().B
                        }
                    end
                end
            end
        end
        
        GlobalSettings.ConfigSystem.Configs[configName] = config
        GlobalSettings.ConfigSystem.CurrentConfig = configName
        
        -- Save to file if supported
        if writefile then
            pcall(function()
                writefile("VoidX_Config_" .. configName .. ".json", HttpService:JSONEncode(config))
            end)
        end
        
        return config
    end
    
    function window:LoadConfig(configName)
        local config
        
        -- Try to load from file
        if readfile and isfile then
            pcall(function()
                if isfile("VoidX_Config_" .. configName .. ".json") then
                    config = HttpService:JSONDecode(readfile("VoidX_Config_" .. configName .. ".json"))
                end
            end)
        end
        
        if not config then
            config = GlobalSettings.ConfigSystem.Configs[configName]
        end
        
        if config then
            for tabName, elements in pairs(config) do
                for _, tab in pairs(window.Tabs) do
                    if tab.Name == tabName and tab.Elements then
                        for elementName, value in pairs(elements) do
                            for _, element in pairs(tab.Elements) do
                                if element.Name == elementName then
                                    if element.SetValue then
                                        element.SetValue(value)
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
                    end
                end
            end
            
            GlobalSettings.ConfigSystem.CurrentConfig = configName
        end
    end
    
    -- Toggle UI Visibility
    local isVisible = true
    local toggleConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Config.ToggleKey then
            isVisible = not isVisible
            mainFrame.Visible = isVisible
        end
    end)
    
    -- Store connection for cleanup
    if getgenv then
        getgenv().VoidXConnections = getgenv().VoidXConnections or {}
        table.insert(getgenv().VoidXConnections, toggleConnection)
    end
    
    -- Destroy function
    function window:Destroy()
        if toggleConnection then
            toggleConnection:Disconnect()
        end
        screenGui:Destroy()
    end
    
    return window
end

return VoidX
