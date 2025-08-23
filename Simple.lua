-- // Made by Venix \\ --
-- // Made This 47 minutes LOL \\ --

local SimpleUI = {flags = {}, windows = {}}

local TweenService = game:GetService("TweenService")

local UserInputService = game:GetService("UserInputService")


local dragging, dragStart, startPos, dragObject

function SimpleUI:Create(class, props)

    props = props or {}

    local obj = Instance.new(class)

    for prop, value in pairs(props) do

        obj[prop] = value

    end

    return obj

end

local function makeDraggable(frame, titleBar)

    titleBar.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true

            dragStart = input.Position

            startPos = frame.Position

            dragObject = frame

        end

    end)

    

    titleBar.InputChanged:Connect(function(input)

        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then

            local delta = input.Position - dragStart

            dragObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

        end

    end)

    

    titleBar.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

            dragging = false

        end

    end)

end

function SimpleUI:CreateWindow(title)

    local window = {title = title, options = {}, open = true}


    window.main = self:Create("Frame", {

        Size = UDim2.new(0, 230, 0, 25),

        Position = UDim2.new(0, 20 + (#self.windows * 250), 0, 20),

        BackgroundColor3 = Color3.fromRGB(20, 20, 20),

        BorderSizePixel = 1,

        BorderColor3 = Color3.fromRGB(40, 40, 40),

        Active = true

    })

    window.titleBar = self:Create("Frame", {

        Size = UDim2.new(1, 0, 0, 25),

        BackgroundColor3 = Color3.fromRGB(25, 25, 25),

        BorderSizePixel = 0,

        Parent = window.main

    })

    local titleLabel = self:Create("TextLabel", {

        Size = UDim2.new(1, -30, 1, 0),

        BackgroundTransparency = 1,

        Text = title,

        TextColor3 = Color3.fromRGB(255, 255, 255),

        TextSize = 16,

        Font = Enum.Font.GothamBold,

        TextXAlignment = Enum.TextXAlignment.Center,

        Parent = window.titleBar

    })

    window.toggleButton = self:Create("TextButton", {

        Size = UDim2.new(0, 25, 0, 25),

        Position = UDim2.new(1, -25, 0, 0),

        BackgroundTransparency = 1,

        Text = "v",

        TextColor3 = Color3.fromRGB(150, 150, 150),

        TextSize = 14,

        Font = Enum.Font.GothamBold,

        Parent = window.titleBar

    })

    window.content = self:Create("Frame", {

        Size = UDim2.new(1, 0, 1, -25),

        Position = UDim2.new(0, 0, 0, 25),

        BackgroundColor3 = Color3.fromRGB(15, 15, 15),

        BorderSizePixel = 0,

        Parent = window.main

    })

    

    local layout = self:Create("UIListLayout", {

        SortOrder = Enum.SortOrder.LayoutOrder,

        Padding = UDim.new(0, 2),

        Parent = window.content

    })


    self:Create("UIPadding", {

        PaddingTop = UDim.new(0, 5),

        PaddingBottom = UDim.new(0, 5),

        PaddingLeft = UDim.new(0, 5),

        PaddingRight = UDim.new(0, 5),

        Parent = window.content

    })

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

        if window.open then

            window.main.Size = UDim2.new(0, 230, 0, layout.AbsoluteContentSize.Y + 30)

        else

            window.main.Size = UDim2.new(0, 230, 0, 25)

        end

    end)

    window.toggleButton.MouseButton1Click:Connect(function()

        window.open = not window.open

        window.toggleButton.Text = window.open and "v" or "^"

        TweenService:Create(window.toggleButton, TweenInfo.new(0.2), {

            TextColor3 = window.open and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(120, 120, 120)

        }):Play()

        

        if window.open then

            window.content.Visible = true

            TweenService:Create(window.main, TweenInfo.new(0.2), {

                Size = UDim2.new(0, 230, 0, layout.AbsoluteContentSize.Y + 30)

            }):Play()

        else

            TweenService:Create(window.main, TweenInfo.new(0.2), {

                Size = UDim2.new(0, 230, 0, 25)

            }):Play()

            wait(0.2)

            window.content.Visible = false

        end

    end)

    

    window.toggleButton.TouchTap:Connect(function()

        window.toggleButton.MouseButton1Click:Fire()

    end)

    makeDraggable(window.main, window.titleBar)

    function window:AddLabel(options)

        options = options or {}

        local text = options.text or "Label"

        

        local label = SimpleUI:Create("TextLabel", {

            Size = UDim2.new(1, 0, 0, 20),

            BackgroundTransparency = 1,

            Text = text,

            TextColor3 = Color3.fromRGB(200, 200, 200),

            TextSize = 14,

            Font = Enum.Font.Gotham,

            TextXAlignment = Enum.TextXAlignment.Left,

            LayoutOrder = #self.options + 1,

            Parent = self.content

        })

        

        local option = {type = "label", element = label, text = text}

        table.insert(self.options, option)

        

        return {

            SetText = function(newText)

                label.Text = newText

                option.text = newText

            end

        }

    end

    function window:AddToggle(options)

        options = options or {}

        local text = options.text or "Toggle"

        local state = options.state or false

        local callback = options.callback or function() end

        local flag = options.flag or text

        

        SimpleUI.flags[flag] = state

        

        local frame = SimpleUI:Create("Frame", {

            Size = UDim2.new(1, 0, 0, 25),

            BackgroundColor3 = Color3.fromRGB(25, 25, 25),

            BorderSizePixel = 1,

            BorderColor3 = Color3.fromRGB(40, 40, 40),

            LayoutOrder = #self.options + 1,

            Parent = self.content

        })

        

        local label = SimpleUI:Create("TextLabel", {

            Size = UDim2.new(1, -30, 1, 0),

            Position = UDim2.new(0, 8, 0, 0),

            BackgroundTransparency = 1,

            Text = text,

            TextColor3 = Color3.fromRGB(255, 255, 255),

            TextSize = 14,

            Font = Enum.Font.Gotham,

            TextXAlignment = Enum.TextXAlignment.Left,

            Parent = frame

        })

        

        local toggle = SimpleUI:Create("Frame", {

            Size = UDim2.new(0, 18, 0, 18),

            Position = UDim2.new(1, -25, 0.5, -9),

            BackgroundColor3 = state and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(60, 60, 60),

            BorderSizePixel = 1,

            BorderColor3 = Color3.fromRGB(80, 80, 80),

            Parent = frame

        })

        

        local button = SimpleUI:Create("TextButton", {

            Size = UDim2.new(1, 0, 1, 0),

            BackgroundTransparency = 1,

            Text = "",

            Parent = frame

        })

        

        button.MouseButton1Click:Connect(function()

            state = not state

            SimpleUI.flags[flag] = state

            TweenService:Create(toggle, TweenInfo.new(0.2), {

                BackgroundColor3 = state and Color3.fromRGB(255, 65, 65) or Color3.fromRGB(60, 60, 60)

            }):Play()

            callback(state)

        end)

        

        button.TouchTap:Connect(function()

            button.MouseButton1Click:Fire()

        end)

        

        local option = {type = "toggle", element = frame, state = state}

        table.insert(self.options, option)

        

        return {

            SetState = function(newState)

                if newState ~= state then

                    button.MouseButton1Click:Fire()

                end

            end

        }

    end

    function window:AddButton(options)

        options = options or {}

        local text = options.text or "Button"

        local callback = options.callback or function() end

        

        local frame = SimpleUI:Create("Frame", {

            Size = UDim2.new(1, 0, 0, 28),

            BackgroundColor3 = Color3.fromRGB(35, 35, 35),

            BorderSizePixel = 1,

            BorderColor3 = Color3.fromRGB(50, 50, 50),

            LayoutOrder = #self.options + 1,

            Parent = self.content

        })

        

        local button = SimpleUI:Create("TextButton", {

            Size = UDim2.new(1, 0, 1, 0),

            BackgroundTransparency = 1,

            Text = text,

            TextColor3 = Color3.fromRGB(255, 255, 255),

            TextSize = 14,

            Font = Enum.Font.Gotham,

            Parent = frame

        })

        

        button.MouseButton1Click:Connect(callback)

        button.TouchTap:Connect(callback)

        

        button.MouseEnter:Connect(function()

            TweenService:Create(frame, TweenInfo.new(0.2), {

                BackgroundColor3 = Color3.fromRGB(50, 50, 50)

            }):Play()

        end)

        

        button.MouseLeave:Connect(function()

            TweenService:Create(frame, TweenInfo.new(0.2), {

                BackgroundColor3 = Color3.fromRGB(35, 35, 35)

            }):Play()

        end)

        

        local option = {type = "button", element = frame}

        table.insert(self.options, option)

        

        return button

    end

    

    table.insert(self.windows, window)

    return window

end

function SimpleUI:Init()

    self.gui = self:Create("ScreenGui", {

        Name = "SimpleUI",

        Parent = game:GetService("CoreGui"),

        ResetOnSpawn = false

    })

    

    for _, window in pairs(self.windows) do

        window.main.Parent = self.gui

    end

    

    return self.gui

end

return SimpleUI
