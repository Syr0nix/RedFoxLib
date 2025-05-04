if game.CoreGui:FindFirstChild("RedFoxUI") then return end

local RedFoxUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

-- Blur
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 18
blur.Enabled = true
task.delay(5, function()
	for i = blur.Size, 0, -1 do
		blur.Size = i
		task.wait(0.03)
	end
	blur.Enabled = false
end)

-- GUI Base
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedFoxUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Drop Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.7
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.Position = UDim2.new(0.5, -30, 0.5, -30)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.ZIndex = 1
shadow.Parent = MainFrame

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
TabBarScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
TabBarScroll.ScrollingDirection = Enum.ScrollingDirection.X
TabBarScroll.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
TabBarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBarScroll.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout", TabBarScroll)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -75)
ContentFrame.Position = UDim2.new(0, 0, 0, 75)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Hover FX
local function AddHoverEffect(obj, baseColor, hoverColor)
	obj.MouseEnter:Connect(function()
		TweenService:Create(obj, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
	end)
	obj.MouseLeave:Connect(function()
		TweenService:Create(obj, TweenInfo.new(0.15), {BackgroundColor3 = baseColor}):Play()
	end)
end

-- Tabs Table
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
	AddHoverEffect(btn, Color3.fromRGB(30, 30, 30), Color3.fromRGB(60, 0, 0))

	local tabScroll = Instance.new("ScrollingFrame")
	tabScroll.Name = name
	tabScroll.BackgroundTransparency = 1
	tabScroll.Size = UDim2.new(1, 0, 1, 0)
	tabScroll.Position = UDim2.new(1, 0, 0, 0)
	tabScroll.Visible = false
	tabScroll.ScrollBarThickness = 6
	tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabScroll.ClipsDescendants = true
	tabScroll.Parent = ContentFrame

	local layout = Instance.new("UIListLayout", tabScroll)
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	RedFoxUILib.Tabs[name] = tabScroll

	btn.MouseButton1Click:Connect(function()
		for _, v in pairs(RedFoxUILib.Tabs) do
			v.Visible = false
			v.Position = UDim2.new(1, 0, 0, 0)
		end
		tabScroll.Visible = true
		tabScroll.Position = UDim2.new(0, 0, 0, 0)
		RedFoxUILib.ActiveTab = tabScroll
	end)

	if not RedFoxUILib.ActiveTab then
		tabScroll.Visible = true
		tabScroll.Position = UDim2.new(0, 0, 0, 0)
		RedFoxUILib.ActiveTab = tabScroll
	end

	return tabScroll
end

-- F5 Toggle Key
UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.F5 then
		ScreenGui.Enabled = not ScreenGui.Enabled
		blur.Enabled = ScreenGui.Enabled
	end
end)

-- Dragging Frame
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
-- Button
function RedFoxUILib.CreateButton(tab, label, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -12, 0, 30)
	btn.Text = label
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.AutoButtonColor = true
	btn.BorderSizePixel = 0
	btn.Parent = tab
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	AddHoverEffect(btn, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 0, 0))

	btn.MouseButton1Click:Connect(callback)
end

-- Toggle
function RedFoxUILib.CreateToggle(tab, label, default, callback)
	local toggled = default
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, -12, 0, 30)
	holder.BackgroundTransparency = 1
	holder.Parent = tab

	local text = Instance.new("TextLabel")
	text.Text = label
	text.Font = Enum.Font.GothamBold
	text.TextSize = 14
	text.TextColor3 = Color3.fromRGB(255, 0, 0)
	text.BackgroundTransparency = 1
	text.Size = UDim2.new(0.8, 0, 1, 0)
	text.Parent = holder

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Text = default and "ON" or "OFF"
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextSize = 12
	toggleBtn.Size = UDim2.new(0.2, -6, 1, 0)
	toggleBtn.Position = UDim2.new(0.8, 6, 0, 0)
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.BackgroundColor3 = default and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(50, 50, 50)
	toggleBtn.Parent = holder
	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

	AddHoverEffect(toggleBtn, toggleBtn.BackgroundColor3, Color3.fromRGB(180, 0, 0))

	toggleBtn.MouseButton1Click:Connect(function()
		toggled = not toggled
		toggleBtn.Text = toggled and "ON" or "OFF"
		toggleBtn.BackgroundColor3 = toggled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(50, 50, 50)
		callback(toggled)
	end)
end

-- Slider
function RedFoxUILib.CreateSlider(tab, label, min, max, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -12, 0, 50)
	container.BackgroundTransparency = 1
	container.Parent = tab

	local text = Instance.new("TextLabel")
	text.Text = label .. ": " .. default
	text.Font = Enum.Font.GothamBold
	text.TextSize = 14
	text.TextColor3 = Color3.fromRGB(255, 0, 0)
	text.Size = UDim2.new(1, 0, 0, 20)
	text.BackgroundTransparency = 1
	text.Parent = container

	local slider = Instance.new("TextButton")
	slider.Size = UDim2.new(1, 0, 0, 20)
	slider.Position = UDim2.new(0, 0, 0, 25)
	slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	slider.Text = ""
	slider.AutoButtonColor = false
	slider.Parent = container
	Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	fill.BorderSizePixel = 0
	fill.Parent = slider

	local dragging = false
	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = input.Position.X - slider.AbsolutePosition.X
			local pct = math.clamp(rel / slider.AbsoluteSize.X, 0, 1)
			TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
			local val = math.floor(min + (max - min) * pct)
			text.Text = label .. ": " .. val
			callback(val)
		end
	end)
end

-- Divider Line
function RedFoxUILib.CreateLine(tab)
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -12, 0, 1)
	line.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
	line.BorderSizePixel = 0
	line.Parent = tab
end
-- Dropdown
function RedFoxUILib.CreateDropdown(tab, label, options, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, -12, 0, 60)
	holder.BackgroundTransparency = 1
	holder.Parent = tab

	local text = Instance.new("TextLabel")
	text.Text = label
	text.Font = Enum.Font.GothamBold
	text.TextSize = 14
	text.TextColor3 = Color3.fromRGB(255, 0, 0)
	text.BackgroundTransparency = 1
	text.Size = UDim2.new(1, 0, 0, 20)
	text.Parent = holder

	local dropdown = Instance.new("TextButton")
	dropdown.Size = UDim2.new(1, 0, 0, 30)
	dropdown.Position = UDim2.new(0, 0, 0, 25)
	dropdown.Text = "Select"
	dropdown.Font = Enum.Font.Gotham
	dropdown.TextSize = 14
	dropdown.TextColor3 = Color3.fromRGB(255, 0, 0)
	dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	dropdown.Parent = holder
	Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)
	AddHoverEffect(dropdown, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 0, 0))

	local dropFrame = Instance.new("Frame")
	dropFrame.Visible = false
	dropFrame.Size = UDim2.new(1, 0, 0, #options * 25)
	dropFrame.Position = UDim2.new(0, 0, 1, 0)
	dropFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	dropFrame.BorderSizePixel = 0
	dropFrame.ClipsDescendants = true
	dropFrame.ZIndex = 5
	dropFrame.Parent = dropdown

	for _, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton")
		optBtn.Size = UDim2.new(1, 0, 0, 25)
		optBtn.Text = opt
		optBtn.Font = Enum.Font.Gotham
		optBtn.TextSize = 13
		optBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
		optBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		optBtn.BorderSizePixel = 0
		optBtn.Parent = dropFrame
		AddHoverEffect(optBtn, Color3.fromRGB(30, 30, 30), Color3.fromRGB(60, 0, 0))

		optBtn.MouseButton1Click:Connect(function()
			dropdown.Text = opt
			dropFrame.Visible = false
			callback(opt)
		end)
	end

	dropdown.MouseButton1Click:Connect(function()
		dropFrame.Visible = not dropFrame.Visible
	end)
end

-- Textbox
function RedFoxUILib.CreateTextbox(tab, label, default, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, -12, 0, 55)
	holder.BackgroundTransparency = 1
	holder.Parent = tab

	local text = Instance.new("TextLabel")
	text.Text = label
	text.Font = Enum.Font.GothamBold
	text.TextSize = 14
	text.TextColor3 = Color3.fromRGB(255, 0, 0)
	text.BackgroundTransparency = 1
	text.Size = UDim2.new(1, 0, 0, 20)
	text.Parent = holder

	local input = Instance.new("TextBox")
	input.Text = default or ""
	input.Font = Enum.Font.Gotham
	input.TextSize = 14
	input.TextColor3 = Color3.fromRGB(255, 0, 0)
	input.Size = UDim2.new(1, 0, 0, 30)
	input.Position = UDim2.new(0, 0, 0, 25)
	input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	input.ClearTextOnFocus = false
	input.BorderSizePixel = 0
	input.Parent = holder
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

	input.FocusLost:Connect(function()
		callback(input.Text)
	end)
end

-- Final return
return RedFoxUILib
