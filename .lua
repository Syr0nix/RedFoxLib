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
-- Inside RedFoxUILib.NewTab() return block:
NewToggle = function(name, default, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(0, 200, 0, 30)
	holder.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 34)
	holder.BackgroundTransparency = 1
	holder.Parent = tabContent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -40, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 0, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 30, 0, 20)
	toggle.Position = UDim2.new(1, -30, 0.5, -10)
	toggle.Text = default and "ON" or "OFF"
	toggle.TextColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 12
	toggle.BorderSizePixel = 0
	toggle.Parent = holder

	local state = default
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = state and "ON" or "OFF"
		toggle.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		callback(state)
	end)

	tabContent.CanvasSize = UDim2.new(0, 0, 0, #tabContent:GetChildren() * 36)
end,

NewSlider = function(name, min, max, default, callback)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(0, 250, 0, 40)
	holder.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 44)
	holder.BackgroundTransparency = 1
	holder.Parent = tabContent

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Text = name .. ": " .. default
	label.TextColor3 = Color3.fromRGB(255, 0, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder

	local slider = Instance.new("TextButton")
	slider.Size = UDim2.new(1, 0, 0, 15)
	slider.Position = UDim2.new(0, 0, 0, 25)
	slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	slider.Text = ""
	slider.AutoButtonColor = false
	slider.BorderSizePixel = 0
	slider.Parent = holder

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
	fill.BorderSizePixel = 0
	fill.Parent = slider

	local dragging = false
	slider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)
	slider.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(pos, 0, 1, 0)
			local val = math.floor(min + (max - min) * pos)
			label.Text = name .. ": " .. val
			callback(val)
		end
	end)

	tabContent.CanvasSize = UDim2.new(0, 0, 0, #tabContent:GetChildren() * 44)
end,

NewTextbox = function(name, placeholder, callback)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 200, 0, 20)
	label.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 36)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 0, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = tabContent

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 200, 0, 24)
	box.Position = UDim2.new(0, 10, 0, label.Position.Y.Offset + 20)
	box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	box.TextColor3 = Color3.fromRGB(255, 0, 0)
	box.PlaceholderText = placeholder
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.ClearTextOnFocus = false
	box.BorderSizePixel = 0
	box.Parent = tabContent

	box.FocusLost:Connect(function(enter)
		if enter then callback(box.Text) end
	end)

	tabContent.CanvasSize = UDim2.new(0, 0, 0, box.Position.Y.Offset + 34)
end,

NewDropdown = function(name, list, callback)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 200, 0, 20)
	label.Position = UDim2.new(0, 10, 0, #tabContent:GetChildren() * 36)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255, 0, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = tabContent

	local dropdown = Instance.new("TextButton")
	dropdown.Size = UDim2.new(0, 200, 0, 24)
	dropdown.Position = UDim2.new(0, 10, 0, label.Position.Y.Offset + 20)
	dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	dropdown.TextColor3 = Color3.fromRGB(255, 0, 0)
	dropdown.Font = Enum.Font.Gotham
	dropdown.TextSize = 14
	dropdown.Text = "Select"
	dropdown.BorderSizePixel = 0
	dropdown.Parent = tabContent

	local open = false
	local menu = Instance.new("Frame")
	menu.Size = UDim2.new(0, 200, 0, #list * 24)
	menu.Position = UDim2.new(0, 0, 1, 0)
	menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	menu.Visible = false
	menu.ClipsDescendants = true
	menu.Parent = dropdown

	for _, item in pairs(list) do
		local opt = Instance.new("TextButton")
		opt.Size = UDim2.new(1, 0, 0, 24)
		opt.Position = UDim2.new(0, 0, 0, (#menu:GetChildren() - 1) * 24)
		opt.BackgroundTransparency = 1
		opt.Text = item
		opt.TextColor3 = Color3.fromRGB(255, 0, 0)
		opt.Font = Enum.Font.Gotham
		opt.TextSize = 14
		opt.Parent = menu
		opt.MouseButton1Click:Connect(function()
			dropdown.Text = item
			menu.Visible = false
			callback(item)
			open = false
		end)
	end

	dropdown.MouseButton1Click:Connect(function()
		open = not open
		menu.Visible = open
	end)

	tabContent.CanvasSize = UDim2.new(0, 0, 0, dropdown.Position.Y.Offset + 34)
end
Destroy = function()
	if MainUI then
		MainUI:Destroy()
	end
end,

Notify = function(text, duration)
	duration = duration or 3

	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0, 300, 0, 40)
	notif.Position = UDim2.new(0.5, -150, 1, -50)
	notif.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	notif.TextColor3 = Color3.fromRGB(255, 0, 0)
	notif.Font = Enum.Font.GothamBold
	notif.TextSize = 14
	notif.Text = text
	notif.TextWrapped = true
	notif.BorderSizePixel = 0
	notif.Parent = MainUI
	notif.AnchorPoint = Vector2.new(0.5, 1)
	notif.BackgroundTransparency = 0.2

	local tween = TweenService:Create(notif, TweenInfo.new(0.3), {
		Position = UDim2.new(0.5, -150, 1, -70)
	})
	tween:Play()

	task.delay(duration, function()
		local out = TweenService:Create(notif, TweenInfo.new(0.3), {
			Position = UDim2.new(0.5, -150, 1, 10)
		})
		out:Play()
		out.Completed:Wait()
		notif:Destroy()
	end)
end,

-- Optional future SaveManager support (you can replace this later)
GetSaveManager = function()
	return {
		SetLibrary = function() end,
		SetFolder = function() end,
	:SetIgnore = function() end,
	:BuildConfigSection = function() end
	}
end

RedFoxUI:Notify("Loaded successfully!")
RedFoxUI:Destroy()
