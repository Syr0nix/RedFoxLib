-- ✅ RedFoxUILib - Full Working UI Library with Scroll Layout + Controls

if game.CoreGui:FindFirstChild("RedFoxUI") then return end

local RedFoxUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- Blur background
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 18
blur.Enabled = true

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedFoxUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "RedFoxUI"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Tab Bar
local TabBarScroll = Instance.new("ScrollingFrame")
TabBarScroll.Size = UDim2.new(1, 0, 0, 35)
TabBarScroll.Position = UDim2.new(0, 0, 0, 40)
TabBarScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabBarScroll.BorderSizePixel = 0
TabBarScroll.ScrollBarThickness = 4
TabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabBarScroll.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
TabBarScroll.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout", TabBarScroll)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)

-- Content Holder
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -75)
ContentFrame.Position = UDim2.new(0, 0, 0, 75)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Tabs
RedFoxUILib.Tabs = {}
RedFoxUILib.ActiveTab = nil

function RedFoxUILib.NewTab(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = TabBarScroll

    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name = name
    tabScroll.BackgroundTransparency = 1
    tabScroll.Size = UDim2.new(1, 0, 1, 0)
    tabScroll.Visible = false
    tabScroll.ScrollBarThickness = 6
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroll.Parent = ContentFrame

    local layout = Instance.new("UIListLayout", tabScroll)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    RedFoxUILib.Tabs[name] = tabScroll

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(RedFoxUILib.Tabs) do v.Visible = false end
        tabScroll.Visible = true
        RedFoxUILib.ActiveTab = tabScroll
    end)

    if not RedFoxUILib.ActiveTab then
        tabScroll.Visible = true
        RedFoxUILib.ActiveTab = tabScroll
    end

    return tabScroll
end

-- Create UI Block
local function createBaseElement(parent, height)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, height)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 0, 0)
    stroke.Thickness = 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    return frame
end

function RedFoxUILib.CreateButton(tab, text, callback)
    local frame = createBaseElement(tab, 30)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    button.BorderSizePixel = 0
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    button.MouseButton1Click:Connect(function() pcall(callback) end)
end

function RedFoxUILib.CreateToggle(tab, text, default, callback)
    local frame = createBaseElement(tab, 30)
    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0, 50, 1, -4)
    toggleBtn.Position = UDim2.new(1, -55, 0, 2)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.TextColor3 = Color3.new(0, 0, 0)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 80, 80)
    toggleBtn.BorderSizePixel = 0
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

    toggleBtn.MouseButton1Click:Connect(function()
        default = not default
        toggleBtn.Text = default and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(80, 80, 80)
        pcall(callback, default)
    end)
end

function RedFoxUILib.CreateSlider(tab, labelText, min, max, default, callback)
    local frame = createBaseElement(tab, 40)
    local label = Instance.new("TextLabel", frame)
    label.Text = labelText .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -20, 0, 18)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local slider = Instance.new("Frame", frame)
    slider.Size = UDim2.new(1, -20, 0, 8)
    slider.Position = UDim2.new(0, 10, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    slider.BorderSizePixel = 0
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame", slider)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fill.BorderSizePixel = 0
    fill.Name = "Fill"
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            relX = math.clamp(relX, 0, 1)
            fill.Size = UDim2.new(relX, 0, 1, 0)
            local value = math.floor((min + (max - min) * relX) + 0.5)
            label.Text = labelText .. ": " .. tostring(value)
            pcall(callback, value)
        end
    end)
    fill.Parent = slider
end

function RedFoxUILib.CreateTextbox(tab, placeholder, callback)
    local frame = createBaseElement(tab, 30)
    local box = Instance.new("TextBox", frame)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.Font = Enum.Font.GothamBold
    box.TextSize = 14
    box.TextColor3 = Color3.fromRGB(255, 0, 0)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BorderSizePixel = 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    box.FocusLost:Connect(function(enter)
        if enter and box.Text ~= "" then
            pcall(callback, box.Text)
        end
    end)
end

function RedFoxUILib.CreateDropdown(tab, labelText, options, callback)
    local frame = createBaseElement(tab, 30)
    local mainButton = Instance.new("TextButton", frame)
    mainButton.Size = UDim2.new(1, 0, 1, 0)
    mainButton.Text = labelText .. " ▼"
    mainButton.Font = Enum.Font.GothamBold
    mainButton.TextSize = 14
    mainButton.TextColor3 = Color3.new(0, 0, 0)
    mainButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    mainButton.BorderSizePixel = 0
    Instance.new("UICorner", mainButton).CornerRadius = UDim.new(0, 6)

    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(1, 0, 0, #options * 28)
    dropdownList.Position = UDim2.new(0, 0, 1, 4)
    dropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    dropdownList.Visible = false
    dropdownList.ZIndex = 10
    dropdownList.Parent = frame
    Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 6)
    local layout = Instance.new("UIListLayout", dropdownList)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 2)

    for _, option in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 28)
        optBtn.Text = option
        optBtn.Font = Enum.Font.GothamBold
        optBtn.TextSize = 14
        optBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        optBtn.BorderSizePixel = 0
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
        optBtn.Parent = dropdownList

        optBtn.MouseButton1Click:Connect(function()
            mainButton.Text = labelText .. ": " .. option
            dropdownList.Visible = false
            pcall(callback, option)
        end)
    end

    mainButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
end

-- Dragging logic
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- F5 toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F5 then
        ScreenGui.Enabled = not ScreenGui.Enabled
        blur.Enabled = ScreenGui.Enabled
    end
end)

return RedFoxUILib
