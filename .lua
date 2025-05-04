-- RedFoxUILib.lua (Final Black & Red Theme with Working Blur and UI Fixes)
local RedFoxUILib = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Prevent duplicates
local existing = Players.LocalPlayer:FindFirstChild("PlayerGui") and Players.LocalPlayer.PlayerGui:FindFirstChild("RedFoxUI")
if existing then
	existing:Destroy()
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("BlurEffect") and v.Name == "RedFoxBlur" then
			v:Destroy()
		end
	end
end

function RedFoxUILib:CreateWindow(title)
	local player = Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "RedFoxUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true

	-- Blur with fade out
	local blur = Instance.new("BlurEffect")
	blur.Name = "RedFoxBlur"
	blur.Size = 20
	blur.Parent = Lighting
	task.spawn(function()
		wait(5)
		for i = 1, 30 do
			blur.Size = 20 - (i * (20 / 30))
			wait(0.03)
		end
		blur.Enabled = false
	end)

	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Size = UDim2.new(0, 700, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

	local titleBar = Instance.new("TextLabel", mainFrame)
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundTransparency = 1
	titleBar.Text = title or "RedFox UI"
	titleBar.TextColor3 = Color3.fromRGB(255, 0, 0)
	titleBar.Font = Enum.Font.GothamBold
	titleBar.TextSize = 20

	local tabButtonsFrame = Instance.new("Frame", mainFrame)
	tabButtonsFrame.Size = UDim2.new(0, 150, 1, -40)
	tabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
	tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Instance.new("UICorner", tabButtonsFrame).CornerRadius = UDim.new(0, 8)
	local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 4)

	local contentFrame = Instance.new("Frame", mainFrame)
	contentFrame.Position = UDim2.new(0, 160, 0, 40)
	contentFrame.Size = UDim2.new(1, -160, 1, -40)
	contentFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 6)

	local popup = Instance.new("TextLabel", screenGui)
	popup.Size = UDim2.new(0, 250, 0, 30)
	popup.Position = UDim2.new(0, 10, 1, -40)
	popup.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	popup.TextColor3 = Color3.fromRGB(255, 255, 255)
	popup.Text = "RedFoxUI made by Syr0nix"
	popup.TextSize = 14
	popup.Font = Enum.Font.GothamBold
	popup.BackgroundTransparency = 0
	Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
	task.spawn(function()
		wait(4)
		for i = 1, 30 do
			popup.TextTransparency = i / 30
			popup.BackgroundTransparency = i / 30
			wait(0.03)
		end
		popup:Destroy()
	end)

	local currentTab
	local function switchTab(tabContent)
		if currentTab then currentTab.Visible = false end
		currentTab = tabContent
		currentTab.Visible = true
	end

	function RedFoxUILib:AddTab(tabName)
		local button = Instance.new("TextButton", tabButtonsFrame)
		button.Size = UDim2.new(1, -10, 0, 30)
		button.Text = tabName
		button.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		button.TextColor3 = Color3.fromRGB(255, 0, 0)
		button.Font = Enum.Font.Gotham
		button.TextSize = 14
		Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

		local tabFrame = Instance.new("ScrollingFrame", contentFrame)
		tabFrame.Size = UDim2.new(1, -10, 1, -10)
		tabFrame.Position = UDim2.new(0, 5, 0, 5)
		tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tabFrame.ScrollBarThickness = 6
		tabFrame.Visible = false
		local tabLayout = Instance.new("UIListLayout", tabFrame)
		tabLayout.Padding = UDim.new(0, 8)
		tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

		button.MouseButton1Click:Connect(function()
			switchTab(tabFrame)
		end)

		if not currentTab then switchTab(tabFrame) end

		local api = {}

		function api:AddButton(name, callback)
			local btn = Instance.new("TextButton", tabFrame)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Text = name
			btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.MouseButton1Click:Connect(callback)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		end

		function api:AddToggle(name, callback)
			local state = false
			local toggle = Instance.new("TextButton", tabFrame)
			toggle.Size = UDim2.new(1, -10, 0, 30)
			toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			toggle.TextColor3 = Color3.fromRGB(255, 0, 0)
			toggle.Font = Enum.Font.GothamBold
			toggle.TextSize = 14
			toggle.Text = name .. ": OFF"
			Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

			toggle.MouseButton1Click:Connect(function()
				state = not state
				toggle.Text = name .. ": " .. (state and "ON" or "OFF")
				callback(state)
			end)
		end

		function api:AddTextbox(name, callback)
			local label = Instance.new("TextLabel", tabFrame)
			label.Text = name
			label.TextColor3 = Color3.fromRGB(255, 0, 0)
			label.Font = Enum.Font.Gotham
			label.TextSize = 13
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, -10, 0, 20)

			local box = Instance.new("TextBox", tabFrame)
			box.PlaceholderText = "TextBox"
			box.Size = UDim2.new(1, -10, 0, 30)
			box.TextColor3 = Color3.fromRGB(255, 255, 255)
			box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			box.Font = Enum.Font.Gotham
			box.TextSize = 14
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
			box.FocusLost:Connect(function()
				callback(box.Text)
			end)
		end

		function api:AddSlider(name, min, max, callback)
			local label = Instance.new("TextLabel", tabFrame)
			label.Text = name .. ": " .. min
			label.TextColor3 = Color3.fromRGB(255, 0, 0)
			label.Font = Enum.Font.Gotham
			label.TextSize = 13
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, -10, 0, 20)

			local slider = Instance.new("Frame", tabFrame)
			slider.Size = UDim2.new(1, -10, 0, 20)
			slider.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

			local fill = Instance.new("Frame", slider)
			fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BorderSizePixel = 0
			Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

			slider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local con = UserInputService.InputChanged:Connect(function(move)
						if move.UserInputType == Enum.UserInputType.MouseMovement then
							local rel = (move.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
							rel = math.clamp(rel, 0, 1)
							fill.Size = UDim2.new(rel, 0, 1, 0)
							local val = math.floor(min + (max - min) * rel)
							label.Text = name .. ": " .. val
							callback(val)
						end
					end)
					UserInputService.InputEnded:Wait()
					con:Disconnect()
				end
			end)
		end

		function api:AddDropdown(name, options, callback)
			local label = Instance.new("TextLabel", tabFrame)
			label.Text = name
			label.TextColor3 = Color3.fromRGB(255, 0, 0)
			label.Font = Enum.Font.Gotham
			label.TextSize = 13
			label.BackgroundTransparency = 1
			label.Size = UDim2.new(1, -10, 0, 20)

			local dropdown = Instance.new("TextButton", tabFrame)
			dropdown.Size = UDim2.new(1, -10, 0, 30)
			dropdown.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
			dropdown.Font = Enum.Font.Gotham
			dropdown.TextSize = 14
			dropdown.Text = "Select"
			Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

			dropdown.MouseButton1Click:Connect(function()
				local menu = Instance.new("Frame", dropdown)
				menu.Position = UDim2.new(0, 0, 1, 0)
				menu.Size = UDim2.new(1, 0, 0, #options * 25)
				menu.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
				menu.ZIndex = 10
				menu.ClipsDescendants = true

				for _, opt in ipairs(options) do
					local btn = Instance.new("TextButton", menu)
					btn.Size = UDim2.new(1, 0, 0, 25)
					btn.Text = opt
					btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
					btn.TextColor3 = Color3.fromRGB(255, 255, 255)
					btn.Font = Enum.Font.Gotham
					btn.TextSize = 13
					btn.MouseButton1Click:Connect(function()
						dropdown.Text = opt
						callback(opt)
						menu:Destroy()
					end)
				end
			end)
		end

		return api
	end

	return RedFoxUILib
end

return RedFoxUILib
