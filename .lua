-- RedFoxUILib (Part 1: Core Setup + Base UI + Blur + F5 toggle)

local RedFoxUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- GUI Setup
local RedFoxUI = Instance.new("ScreenGui")
RedFoxUI.Name = "RedFoxUI"
RedFoxUI.ResetOnSpawn = false
RedFoxUI.IgnoreGuiInset = true
RedFoxUI.Parent = CoreGui

-- Blur Effect
local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
blur.Size = 18
blur.Enabled = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = RedFoxUI

-- Red Glow Border
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- Corner Rounding
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
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

-- F5 Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.F5 then
		RedFoxUI.Enabled = not RedFoxUI.Enabled
		blur.Enabled = RedFoxUI.Enabled
	end
end)

-- UI Elements Placeholder (to be filled in Part 2+)
local function createTab(name)
	local tab = Instance.new("Frame")
	tab.Name = name
	tab.Size = UDim2.new(1, 0, 1, 0)
	tab.BackgroundTransparency = 1
	tab.Parent = MainFrame
	return tab
end

-- Return API for extending
RedFoxUILib.CreateTab = createTab
RedFoxUILib.MainFrame = MainFrame
RedFoxUILib.ScreenGui = RedFoxUI

return RedFoxUILib
-- Helper: Create RedFox-style UI element
local function createBaseElement(parent, height)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -20, 0, height)
	frame.BackgroundColor3 = Color3.new(0, 0, 0)
	frame.BackgroundTransparency = 0.2
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = Color3.fromRGB(255, 0, 0)
	stroke.Thickness = 1

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 6)

	return frame
end

-- 🟢 Toggle
function RedFoxUILib.CreateToggle(tab, labelText, default, callback)
	local frame = createBaseElement(tab, 30)

	local label = Instance.new("TextLabel", frame)
	label.Text = labelText
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

-- 🔴 Button
function RedFoxUILib.CreateButton(tab, labelText, callback)
	local frame = createBaseElement(tab, 30)

	local button = Instance.new("TextButton", frame)
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Text = labelText
	button.Font = Enum.Font.GothamBold
	button.TextSize = 14
	button.TextColor3 = Color3.new(0, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	button.BorderSizePixel = 0

	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

	button.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

-- 🔻 Dropdown
function RedFoxUILib.CreateDropdown(tab, labelText, options, callback)
	local frame = createBaseElement(tab, 30)

	local dropdown = Instance.new("TextButton", frame)
	dropdown.Size = UDim2.new(1, 0, 1, 0)
	dropdown.Text = labelText .. ": " .. options[1]
	dropdown.Font = Enum.Font.GothamBold
	dropdown.TextSize = 14
	dropdown.TextColor3 = Color3.new(0, 0, 0)
	dropdown.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	dropdown.BorderSizePixel = 0

	Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

	local index = 1
	dropdown.MouseButton1Click:Connect(function()
		index += 1
		if index > #options then index = 1 end
		dropdown.Text = labelText .. ": " .. options[index]
		pcall(callback, options[index])
	end)
end

-- 🟥 Slider
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
	fill.Parent = slider

	local dragging = false
	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
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
end
-- Tab system + layout
RedFoxUILib.Tabs = {}
RedFoxUILib.ActiveTab = nil

-- Tab container (left)
local TabList = Instance.new("Frame")
TabList.Name = "TabList"
TabList.Size = UDim2.new(0, 120, 1, 0)
TabList.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TabList.BorderSizePixel = 0
TabList.Parent = RedFoxUILib.MainFrame

local UIListLayout = Instance.new("UIListLayout", TabList)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content container (right)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -130, 1, -20)
ContentFrame.Position = UDim2.new(0, 130, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = RedFoxUILib.MainFrame

-- Scrolling area
local Scroll = Instance.new("ScrollingFrame", ContentFrame)
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ScrollLayout = Instance.new("UIListLayout", Scroll)
ScrollLayout.Padding = UDim.new(0, 6)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Create a new tab
function RedFoxUILib.NewTab(tabName)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Text = tabName
	tabBtn.Size = UDim2.new(1, -12, 0, 30)
	tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	tabBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 14
	tabBtn.BorderSizePixel = 0
	tabBtn.Parent = TabList

	local corner = Instance.new("UICorner", tabBtn)
	corner.CornerRadius = UDim.new(0, 6)

	local tabFrame = Instance.new("Frame")
	tabFrame.Name = tabName
	tabFrame.BackgroundTransparency = 1
	tabFrame.Size = UDim2.new(1, 0, 0, 0)
	tabFrame.AutomaticSize = Enum.AutomaticSize.Y
	tabFrame.Parent = Scroll

	RedFoxUILib.Tabs[tabName] = tabFrame

	tabBtn.MouseButton1Click:Connect(function()
		for _, v in pairs(RedFoxUILib.Tabs) do v.Visible = false end
		tabFrame.Visible = true
		RedFoxUILib.ActiveTab = tabFrame
	end)

	-- Auto-select first tab
	if not RedFoxUILib.ActiveTab then
		tabBtn:Fire("MouseButton1Click")
	end

	return tabFrame
end
