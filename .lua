-- RedFoxUILib.lua (Modern Version with Tabs)
local RedFoxUILib = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

function RedFoxUILib:CreateWindow(title)
	local player = Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "RedFoxUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true

	-- Main container
	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Size = UDim2.new(0, 700, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	mainFrame.BorderSizePixel = 0

	local mainCorner = Instance.new("UICorner", mainFrame)
	mainCorner.CornerRadius = UDim.new(0, 12)

	-- Sidebar
	local sidebar = Instance.new("Frame", mainFrame)
	sidebar.Size = UDim2.new(0, 160, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	sidebar.BorderSizePixel = 0

	local sideLayout = Instance.new("UIListLayout", sidebar)
	sideLayout.Padding = UDim.new(0, 5)
	sideLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local titleLabel = Instance.new("TextLabel", sidebar)
	titleLabel.Text = title or "RedFox UI"
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20

	-- Tab container
	local contentFrame = Instance.new("Frame", mainFrame)
	contentFrame.Position = UDim2.new(0, 160, 0, 0)
	contentFrame.Size = UDim2.new(1, -160, 1, 0)
	contentFrame.BackgroundTransparency = 1

	local tabs = {}
	local currentTab

	local function switchTab(tabFrame)
		if currentTab then currentTab.Visible = false end
		currentTab = tabFrame
		currentTab.Visible = true
	end

	function RedFoxUILib:AddTab(tabName)
		-- Button in sidebar
		local tabButton = Instance.new("TextButton", sidebar)
		tabButton.Size = UDim2.new(1, -10, 0, 30)
		tabButton.Position = UDim2.new(0, 5, 0, 0)
		tabButton.Text = tabName
		tabButton.TextColor3 = Color3.new(1, 1, 1)
		tabButton.Font = Enum.Font.Gotham
		tabButton.TextSize = 14
		tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		tabButton.AutoButtonColor = true

		local buttonCorner = Instance.new("UICorner", tabButton)
		buttonCorner.CornerRadius = UDim.new(0, 6)

		-- Tab content panel
		local tabContent = Instance.new("ScrollingFrame", contentFrame)
		tabContent.Visible = false
		tabContent.Size = UDim2.new(1, -20, 1, -20)
		tabContent.Position = UDim2.new(0, 10, 0, 10)
		tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tabContent.BackgroundTransparency = 1
		tabContent.ScrollBarThickness = 6

		local layout = Instance.new("UIListLayout", tabContent)
		layout.Padding = UDim.new(0, 8)
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		tabButton.MouseButton1Click:Connect(function()
			switchTab(tabContent)
		end)

		if not currentTab then
			switchTab(tabContent)
		end

		local api = {}

		function api:AddButton(text, callback)
			local button = Instance.new("TextButton", tabContent)
			button.Size = UDim2.new(1, -10, 0, 30)
			button.Text = text
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Font = Enum.Font.GothamBold
			button.TextSize = 14
			button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			button.AutoButtonColor = true
			button.MouseButton1Click:Connect(callback)

			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
		end

		function api:AddToggle(text, callback)
			local button = Instance.new("TextButton", tabContent)
			button.Size = UDim2.new(1, -10, 0, 30)
			button.Text = "[ OFF ] " .. text
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Font = Enum.Font.Gotham
			button.TextSize = 14
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

			local state = false
			button.MouseButton1Click:Connect(function()
				state = not state
				button.Text = (state and "[ ON  ] " or "[ OFF ] ") .. text
				callback(state)
			end)

			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
		end

		function api:AddTextbox(labelText, callback)
			local label = Instance.new("TextLabel", tabContent)
			label.Size = UDim2.new(1, -10, 0, 20)
			label.Text = labelText
			label.TextColor3 = Color3.new(1, 1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left

			local textbox = Instance.new("TextBox", tabContent)
			textbox.Size = UDim2.new(1, -10, 0, 30)
			textbox.PlaceholderText = "Type here..."
			textbox.TextColor3 = Color3.new(1, 1, 1)
			textbox.Font = Enum.Font.Gotham
			textbox.TextSize = 14
			textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			textbox.FocusLost:Connect(function()
				callback(textbox.Text)
			end)

			Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)
		end

		function api:AddSlider(labelText, min, max, callback)
			local label = Instance.new("TextLabel", tabContent)
			label.Size = UDim2.new(1, -10, 0, 20)
			label.Text = labelText .. ": " .. min
			label.TextColor3 = Color3.new(1, 1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left

			local slider = Instance.new("TextButton", tabContent)
			slider.Size = UDim2.new(1, -10, 0, 20)
			slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			slider.Text = ""
			slider.AutoButtonColor = false

			local fill = Instance.new("Frame", slider)
			fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BorderSizePixel = 0

			local dragging = false
			local function update(input)
				local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(pos, 0, 1, 0)
				local val = math.floor((max - min) * pos + min)
				label.Text = labelText .. ": " .. val
				callback(val)
			end

			slider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					update(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					update(input)
				end
			end)
		end

		function api:AddDropdown(labelText, options, callback)
			local label = Instance.new("TextLabel", tabContent)
			label.Size = UDim2.new(1, -10, 0, 20)
			label.Text = labelText
			label.TextColor3 = Color3.new(1, 1, 1)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.TextSize = 12
			label.TextXAlignment = Enum.TextXAlignment.Left

			local dropdown = Instance.new("TextButton", tabContent)
			dropdown.Size = UDim2.new(1, -10, 0, 30)
			dropdown.Text = "Select"
			dropdown.TextColor3 = Color3.new(1, 1, 1)
			dropdown.Font = Enum.Font.Gotham
			dropdown.TextSize = 14
			dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

			dropdown.MouseButton1Click:Connect(function()
				local menu = Instance.new("Frame", dropdown)
				menu.Position = UDim2.new(0, 0, 1, 0)
				menu.Size = UDim2.new(1, 0, 0, #options * 25)
				menu.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
				menu.BorderSizePixel = 0

				for _, opt in ipairs(options) do
					local optBtn = Instance.new("TextButton", menu)
					optBtn.Size = UDim2.new(1, 0, 0, 25)
					optBtn.Text = opt
					optBtn.TextColor3 = Color3.new(1, 1, 1)
					optBtn.Font = Enum.Font.Gotham
					optBtn.TextSize = 12
					optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					optBtn.MouseButton1Click:Connect(function()
						dropdown.Text = opt
						callback(opt)
						menu:Destroy()
					end)
				end
			end)

			Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)
		end

		return api
	end

	return self
end

return RedFoxUILib
