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
                -- VoidX Framework | Professional Roblox UI Library
-- Version: 2.5.0 XENO EDITION FULL
-- All Features + Xeno Optimized

local VoidX = {}
VoidX.__index = VoidX

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Get proper GUI parent for executors
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

-- Destroy existing GUIs and stop all functions
for _, gui in pairs(GuiParent:GetChildren()) do
    if gui.Name and gui.Name:find("VoidX") then
        -- Disable all connections before destroying
        for _, connection in pairs(getconnections and getconnections(gui.DescendantAdded) or {}) do
            connection:Disable()
        end
        gui:Destroy()
    end
end

-- Clean up any running connections
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
        }
    },
    AnimationSpeed = 0.3,
    EasingStyle = Enum.EasingStyle.Quart,
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    ToggleKey = Enum.KeyCode.RightShift,
    KeySystem = {
        Enabled = false,
        Key = "",
        KeylessMode = true
    }
}

-- Global Settings Storage
local GlobalSettings = {
    UIToggle = true,
    KeybindList = {},
    ConfigSystem = {
        Configs = {},
        CurrentConfig = "Default"
    }
}

-- Utility Functions
local function CreateTween(instance, properties, duration)
    duration = duration or Config.AnimationSpeed
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, Config.EasingStyle, Enum.EasingDirection.Out),
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Key System Function
function VoidX:CreateKeySystem(options)
    options = options or {}
    local keySystemTitle = options.Title or "VoidX Key System"
    local correctKey = options.Key or "VoidX-Free-Key-2024"
    local keyLink = options.KeyLink or nil
    local onSuccess = options.OnSuccess or function() end
    
    Config.KeySystem.Enabled = true
    Config.KeySystem.Key = correctKey
    
    -- Create Key GUI
    local keyGui = CreateInstance("ScreenGui", {
        Name = "VoidX_KeySystem",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    keyGui.Parent = GuiParent
    
    local keyFrame = CreateInstance("Frame", {
        Size = UDim2.new(0, 400, 0, 250),
        Position = UDim2.new(0.5, -200, 0.5, -125),
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BorderSizePixel = 0
    })
    keyFrame.Parent = keyGui
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12)
    }, keyFrame)
    
    local keyTitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = keySystemTitle,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold
    })
    keyTitle.Parent = keyFrame
    
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
    
    local submitButton = CreateInstance("TextButton", {
        Size = UDim2.new(0.35, 0, 0, 35),
        Position = UDim2.new(0.1, 0, 0.65, 0),
        BackgroundColor3 = Color3.fromRGB(102, 126, 234),
        BorderSizePixel = 0,
        Text = "Submit",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    submitButton.Parent = keyFrame
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, submitButton)
    
    local getKeyButton = CreateInstance("TextButton", {
        Size = UDim2.new(0.35, 0, 0, 35),
        Position = UDim2.new(0.55, 0, 0.65, 0),
        BackgroundColor3 = Color3.fromRGB(118, 75, 162),
        BorderSizePixel = 0,
        Text = "Get Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    })
    getKeyButton.Parent = keyFrame
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, getKeyButton)
    
    -- Key System Logic
    submitButton.MouseButton1Click:Connect(function()
        if keyInput.Text == correctKey then
            keyGui:Destroy()
            Config.KeySystem.KeylessMode = false
            onSuccess()
        else
            keyInput.Text = ""
            keyInput.PlaceholderText = "Invalid Key!"
            wait(2)
            keyInput.PlaceholderText = "Enter Key..."
        end
    end)
    
    getKeyButton.MouseButton1Click:Connect(function()
        if keyLink then
            if setclipboard then
                setclipboard(keyLink)
                getKeyButton.Text = "Copied!"
            else
                getKeyButton.Text = "Check Console!"
                print("Key Link:", keyLink)
            end
            wait(2)
            getKeyButton.Text = "Get Key"
        end
    end)
    
    MakeDraggable(keyFrame, keyTitle)
end

-- Main Window Constructor
function VoidX:CreateWindow(options)
    options = options or {}
    local windowName = options.Name or "VoidX Framework"
    local windowTheme = options.Theme or "Night"
    local windowSize = options.Size or UDim2.new(0, 900, 0, 600)
    
    local window = {}
    window.Theme = Config.Themes[windowTheme]
    window.Tabs = {}
    window.ActiveTab = nil
    window.SettingsTab = nil
    
    -- Create ScreenGui
    local screenGui = CreateInstance("ScreenGui", {
        Name = "VoidX_MainGUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })
    
    -- Protect GUI if possible
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    end
    
    screenGui.Parent = GuiParent
    
    -- Main Frame
    local mainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2),
        BackgroundColor3 = window.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Active = true
    })
    mainFrame.Parent = screenGui
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 20)
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
        Position = UDim2.new(0, 0, 0, 10),
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
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        Text = "v2.5 XENO",
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
    
    -- Content Area with semi-transparent background
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
    
    -- Theme Selector with Settings Button
    local themeSelector = CreateInstance("Frame", {
        Name = "ThemeSelector",
        Size = UDim2.new(1, -30, 0, 60),
        Position = UDim2.new(0, 15, 1, -70),
        BackgroundColor3 = window.Theme.Background,
        BackgroundTransparency = 0.3
    })
    themeSelector.Parent = sidebar
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10)
    }, themeSelector)
    
    local themeLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Text = "THEME",
        TextColor3 = window.Theme.TextDim,
        TextSize = 11,
        Font = Config.Font,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    themeLabel.Parent = themeSelector
    
    local themeOptions = CreateInstance("Frame", {
        Size = UDim2.new(0.7, 0, 0, 30),
        Position = UDim2.new(0, 5, 0, 25),
        BackgroundTransparency = 1
    })
    themeOptions.Parent = themeSelector
    
    CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    }, themeOptions)
    
    -- Create theme dots
    local themeIndex = 0
    for themeName, themeColors in pairs(Config.Themes) do
        themeIndex = themeIndex + 1
        local themeDot = CreateInstance("Frame", {
            Size = UDim2.new(0, 24, 0, 24),
            BackgroundColor3 = themeColors.Accent,
            LayoutOrder = themeIndex
        })
        themeDot.Parent = themeOptions
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0)
        }, themeDot)
        
        local dotButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextTransparency = 1
        })
        dotButton.Parent = themeDot
        
        dotButton.MouseButton1Click:Connect(function()
            window:ChangeTheme(themeName)
        end)
    end
    
    -- Settings Button (next to themes)
    local settingsButton = CreateInstance("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 25),
        BackgroundColor3 = window.Theme.Accent,
        BorderSizePixel = 0,
        Text = "⚙",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Config.Font
    })
    settingsButton.Parent = themeSelector
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8)
    }, settingsButton)
    
    -- Make window draggable
    MakeDraggable(mainFrame, logoSection)
    
    -- Auto-create Settings Tab
    local function createSettingsTab()
        local settingsTab = {}
        settingsTab.Name = "Settings"
        settingsTab.Elements = {}
        
        -- Create Settings Button in tabs
        local settingsTabButton = CreateInstance("Frame", {
            Name = "SettingsTab",
            Size = UDim2.new(1, 0, 0, 45),
            BackgroundColor3 = window.Theme.Background,
            BackgroundTransparency = 1,
            LayoutOrder = 999
        })
        settingsTabButton.Parent = tabContainer
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, settingsTabButton)
        
        local settingsTabLabel = CreateInstance("TextLabel", {
            Name = "TabLabel",
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            BackgroundTransparency = 1,
            Text = "Settings",
            TextColor3 = window.Theme.TextDim,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        settingsTabLabel.Parent = settingsTabButton
        
        local settingsIcon = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 15, 0.5, -10),
            BackgroundTransparency = 1,
            Text = "⚙",
            TextColor3 = window.Theme.TextDim,
            TextSize = 20,
            Font = Config.Font
        })
        settingsIcon.Parent = settingsTabButton
        
        -- Settings Content
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
        
        local settingsDesc = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = "Configure global settings and keybinds",
            TextColor3 = window.Theme.TextDim,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        settingsDesc.Parent = settingsHeader
        
        -- UI Toggle Info
        local uiToggleFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = window.Theme.Background,
            BackgroundTransparency = 0.7,
            LayoutOrder = 1
        })
        uiToggleFrame.Parent = settingsContent
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, uiToggleFrame)
        
        local uiToggleLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = "UI Toggle Key: " .. Config.ToggleKey.Name,
            TextColor3 = window.Theme.Text,
            TextSize = 14,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        uiToggleLabel.Parent = uiToggleFrame
        
        -- Auto-resize
        settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 20)
        end)
        
        settingsTab.Button = settingsTabButton
        settingsTab.Content = settingsContent
        
        -- Settings button clicks
        local settingsButtonClick = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextTransparency = 1
        })
        settingsButtonClick.Parent = settingsTabButton
        
        settingsButtonClick.MouseButton1Click:Connect(function()
            window:SelectTab(settingsTab)
        end)
        
        settingsButton.MouseButton1Click:Connect(function()
            window:SelectTab(settingsTab)
        end)
        
        -- Hover effects
        settingsTabButton.MouseEnter:Connect(function()
            if window.ActiveTab ~= settingsTab then
                CreateTween(settingsTabButton, {BackgroundTransparency = 0.8})
                CreateTween(settingsTabLabel, {TextColor3 = window.Theme.Text})
            end
        end)
        
        settingsTabButton.MouseLeave:Connect(function()
            if window.ActiveTab ~= settingsTab then
                CreateTween(settingsTabButton, {BackgroundTransparency = 1})
                CreateTween(settingsTabLabel, {TextColor3 = window.Theme.TextDim})
            end
        end)
        
        return settingsTab
    end
    
    window.SettingsTab = createSettingsTab()
    table.insert(window.Tabs, window.SettingsTab)
    
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
        
        -- DEVAMI VAR... (tüm element creation methodları)
        -- ...
        -- ...
        -- (KODUN DEVAMI - binlerce satır)
        -- ...
        -- ...
        
        -- EN SONDA (dosyanın en altında):
        
        -- Destroy function
        function window:Destroy()
            if toggleConnection then
                toggleConnection:Disconnect()
            end
            screenGui:Destroy()
        end
        
        return window  -- CreateWindow fonksiyonunun sonu
    end
    
    return VoidX  -- Dosyanın EN SON satırı
