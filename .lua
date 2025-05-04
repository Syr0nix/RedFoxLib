-- RedFoxUILib.lua (Modern UI with Tabs, Rounded Sliders, Blur, Grid Outlines, Draggable)
local RedFoxUILib = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

function RedFoxUILib:CreateWindow(title)
	local player = Players.LocalPlayer
	local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "RedFoxUI"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true

	-- Blur effect
	local blur = Instance.new("BlurEffect")
	blur.Size = 20
	blur.Parent = Lighting

	screenGui.AncestryChanged:Connect(function()
		if not screenGui:IsDescendantOf(game) then
			blur:Destroy()
		end
	end)

	-- Main Frame
	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Size = UDim2.new(0, 700, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

	-- Sidebar
	local sidebar = Instance.new("Frame", mainFrame)
	sidebar.Size = UDim2.new(0, 160, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5)

	local titleLabel = Instance.new("TextLabel", sidebar)
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.Text = title or "RedFox UI"
	titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20
	titleLabel.BackgroundTransparency = 1

	local contentFrame = Instance.new("Frame", mainFrame)
	contentFrame.Position = UDim2.new(0, 160, 0, 0)
	contentFrame.Size = UDim2.new(1, -160, 1, 0)
	contentFrame.BackgroundTransparency = 1

	local currentTab

	local function switchTab(tabFrame)
		if currentTab then currentTab.Visible = false end
		currentTab = tabFrame
		currentTab.Visible = true
	end

	function RedFoxUILib:AddTab(tabName)
		local tabButton = Instance.new("TextButton", sidebar)
		tabButton.Size = UDim2.new(1, -10, 0, 30)
		tabButton.Text = tabName
		tabButton.Font = Enum.Font.Gotham
		tabButton.TextSize = 14
		tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		tabButton.TextColor3 = Color3.new(1, 1, 1)
		Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", tabButton)
		stroke.Thickness = 1
		stroke.Color = Color3.fromRGB(60, 60, 60)

		local tabContent = Instance.new("ScrollingFrame", contentFrame)
		tabContent.Visible = false
		tabContent.Size = UDim2.new(1, -20, 1, -20)
		tabContent.Position = UDim2.new(0, 10, 0, 10)
		tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tabContent.ScrollBarThickness = 6
		Instance.new("UIListLayout", tabContent).Padding = UDim.new(0, 8)

		tabButton.MouseButton1Click:Connect(function()
			switchTab(tabContent)
		end)

		if not currentTab then switchTab(tabContent) end

		local api = {}

		function api:AddButton(text, callback)
			local btn = Instance.new("TextButton", tabContent)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Text = text
			btn.Font = Enum.Font.GothamBold
			btn.TextSize = 14
			btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.MouseButton1Click:Connect(callback)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", btn).Color = Color3.fromRGB(60, 60, 60)
		end

		function api:AddToggle(text, callback)
			local btn = Instance.new("TextButton", tabContent)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Text = "[ OFF ] " .. text
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			btn.TextColor3 = Color3.new(1, 1, 1)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", btn).Color = Color3.fromRGB(60, 60, 60)

			local state = false
			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = (state and "[ ON  ] " or "[ OFF ] ") .. text
				callback(state)
			end)
		end

		function api:AddTextbox(text, callback)
			local label = Instance.new("TextLabel", tabContent)
			label.Size = UDim2.new(1, -10, 0, 20)
			label.Text = text
			label.Font = Enum.Font.Gotham
			label.TextSize = 12
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 1, 1)

			local box = Instance.new("TextBox", tabContent)
			box.Size = UDim2.new(1, -10, 0, 30)
			box.PlaceholderText = "Type here..."
			box.TextColor3 = Color3.new(1, 1, 1)
			box.Font = Enum.Font.Gotham
			box.TextSize = 14
			box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", box).Color = Color3.fromRGB(60, 60, 60)
			box.FocusLost:Connect(function()
				callback(box.Text)
			end)
		end

		function api:AddSlider(text, min, max, callback)
			local label = Instance.new("TextLabel", tabContent)
			label.Size = UDim2.new(1, -10, 0, 20)
			label.Text = text .. ": " .. min
			label.Font = Enum.Font.Gotham
			label.TextSize = 12
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 1, 1)

			local slider = Instance.new("TextButton", tabContent)
			slider.Size = UDim2.new(1, -10, 0, 20)
			slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			slider.Text = ""
			slider.AutoButtonColor = false
			Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)
			Instance.new("UIStroke", slider).Color = Color3.fromRGB(60, 60, 60)

			local fill = Instance.new("Frame", slider)
			fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BorderSizePixel = 0
			Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

			local dragging = false
			slider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					local pos = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
					pos = math.clamp(pos, 0, 1)
					fill.Size = UDim2.new(pos, 0, 1, 0)
					local value = math.floor((max - min) * pos + min)
					label.Text = text .. ": " .. value
					callback(value)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
					pos = math.clamp(pos, 0, 1)
					fill.Size = UDim2.new(pos, 0, 1, 0)
					local value = math.floor((max - min) * pos + min)
					label.Text = text .. ": " .. value
					callback(value)
				end
			end)
		end

		return api
	end

	return self
end

return RedFoxUILib
