-- RedFoxUILib.lua (Fixed)
local RedFoxUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedFoxUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Dragging
do
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
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Sidebar and Content Area
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Position = UDim2.new(0, 120, 0, 0)
ContentFrame.Size = UDim2.new(1, -120, 1, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local Tabs = {}

-- Create a tab
function RedFoxUILib.NewTab(tabName)
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(1, 0, 0, 40)
	TabButton.Text = tabName
	TabButton.TextColor3 = Color3.fromRGB(255, 0, 0)
	TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TabButton.BorderSizePixel = 0
	TabButton.Font = Enum.Font.GothamBold
	TabButton.TextSize = 14
	TabButton.Parent = Sidebar

	local TabContent = Instance.new("ScrollingFrame")
	TabContent.Size = UDim2.new(1, 0, 1, 0)
	TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	TabContent.ScrollBarThickness = 6
	TabContent.Visible = false
	TabContent.BackgroundTransparency = 1
	TabContent.Parent = ContentFrame

	TabButton.MouseButton1Click:Connect(function()
		for _, t in ipairs(Tabs) do
			t.Content.Visible = false
		end
		TabContent.Visible = true
	end)

	table.insert(Tabs, {Button = TabButton, Content = TabContent})

	local function addElement(element)
		element.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 36)
		element.Parent = TabContent
		TabContent.CanvasSize = UDim2.new(0, 0, 0, (#TabContent:GetChildren() * 36))
	end

	return {
		AddButton = function(text, callback)
			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(0, 200, 0, 30)
			Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Button.TextColor3 = Color3.fromRGB(255, 0, 0)
			Button.Font = Enum.Font.GothamBold
			Button.Text = text
			Button.TextSize = 14
			Button.BorderSizePixel = 0
			Button.MouseButton1Click:Connect(callback)
			addElement(Button)
		end,

		AddLabel = function(text)
			local Label = Instance.new("TextLabel")
			Label.Size = UDim2.new(0, 200, 0, 30)
			Label.BackgroundTransparency = 1
			Label.TextColor3 = Color3.fromRGB(255, 0, 0)
			Label.Font = Enum.Font.Gotham
			Label.Text = text
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left
			addElement(Label)
		end,

		Content = TabContent
	}
end

-- Show UI
function RedFoxUILib.Main(title, toggleKey)
	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1, -120, 0, 40)
	Title.Position = UDim2.new(0, 120, 0, 0)
	Title.BackgroundTransparency = 1
	Title.Text = title
	Title.TextColor3 = Color3.fromRGB(255, 0, 0)
	Title.Font = Enum.Font.GothamBlack
	Title.TextSize = 28
	Title.Parent = MainFrame

	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode[toggleKey] then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)
end

return RedFoxUILib
