-- ✅ RedFoxUILib - Full Working UI Library with Blur, Fade, and Enhanced Styling

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
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

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

-- Divider line under header
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 1, 0)
Divider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Divider.BorderSizePixel = 0
Divider.Parent = Header

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

-- Divider line under tabs
local Divider2 = Instance.new("Frame")
Divider2.Size = UDim2.new(1, 0, 0, 1)
Divider2.Position = UDim2.new(0, 0, 0, 75)
Divider2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Divider2.BorderSizePixel = 0
Divider2.Parent = MainFrame

-- Content Holder
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -75)
ContentFrame.Position = UDim2.new(0, 0, 0, 76)
ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ContentFrame.BorderSizePixel = 0
ContentFrame.ClipsDescendants = true
ContentFrame.Parent = MainFrame

-- Fade out after 5 seconds
task.delay(5, function()
	TweenService:Create(MainFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
	TweenService:Create(ContentFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Header, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
	TweenService:Create(TabBarScroll, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
end)

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
