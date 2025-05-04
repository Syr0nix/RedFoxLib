-- RedFoxUILib (Part 1: Core Setup + Tab Framework)

local RedFoxUILib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Create base UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedFoxUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Dragging
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
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
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

-- Sidebar for tabs
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabButtons = {}

-- Tab container frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Position = UDim2.new(0, 120, 0, 0)
ContentFrame.Size = UDim2.new(1, -120, 1, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Glow text utility
local function createTitleLabel(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 40)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
	lbl.Font = Enum.Font.GothamBlack
	lbl.TextSize = 28
	lbl.TextStrokeTransparency = 0.8
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.TextYAlignment = Enum.TextYAlignment.Center
	return lbl
end

-- Create new tab
function RedFoxUILib.NewTab(tabName)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(1, 0, 0, 40)
	tabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	tabButton.BorderSizePixel = 0
	tabButton.Text = tabName
	tabButton.TextColor3 = Color3.fromRGB(255, 0, 0)
	tabButton.Font = Enum.Font.GothamBold
	tabButton.TextSize = 16
	tabButton.Parent = Sidebar

	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.ScrollBarThickness = 6
	tabContent.BackgroundTransparency = 1
	tabContent.Visible = false
	tabContent.Parent = ContentFrame

	-- Toggle tab on button click
	tabButton.MouseButton1Click:Connect(function()
		for _, btn in pairs(TabButtons) do
			btn.Content.Visible = false
		end
		tabContent.Visible = true
	end)

	-- Register the tab
	table.insert(TabButtons, { Button = tabButton, Content = tabContent })

	return {
		NewButton = function(name, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, 200, 0, 32)
			btn.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 36)
			btn.Text = name
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.TextColor3 = Color3.fromRGB(255, 0, 0)
			btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			btn.BorderSizePixel = 0
			btn.Parent = tabContent

			btn.MouseButton1Click:Connect(callback)

			tabContent.CanvasSize = UDim2.new(0, 0, 0, #tabContent:GetChildren() * 36)
			return btn
		end,

		Content = tabContent
	}
end

-- Show GUI
function RedFoxUILib.Main(title, toggleKey)
	local titleLabel = createTitleLabel(title)
	titleLabel.Position = UDim2.new(0, 120, 0, 0)
	titleLabel.Parent = MainFrame

	MainFrame.Visible = true

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode[toggleKey] then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	return RedFoxUILib
end

return RedFoxUILib
