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
-- Load UI from config
function RedFoxUILib.Load(tab, config)
	for _, item in ipairs(config) do
		if item.type == "button" then
			RedFoxUILib.CreateButton(tab, item.text, item.callback)
		elseif item.type == "toggle" then
			RedFoxUILib.CreateToggle(tab, item.text, item.default or false, item.callback)
		elseif item.type == "slider" then
			RedFoxUILib.CreateSlider(tab, item.text, item.min, item.max, item.default, item.callback)
		elseif item.type == "textbox" then
			RedFoxUILib.CreateTextbox(tab, item.text, item.default or "", item.callback)
		elseif item.type == "dropdown" then
			RedFoxUILib.CreateDropdown(tab, item.text, item.options, item.callback)
		elseif item.type == "line" then
			RedFoxUILib.CreateLine(tab)
		end
	end
end

