-- RedFoxUILib.lua
local RedFoxUILib = {}

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Create UI
function RedFoxUILib:CreateWindow(title)
	local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
	ScreenGui.Name = "RedFoxUI"
	ScreenGui.ResetOnSpawn = false

	local MainFrame = Instance.new("Frame", ScreenGui)
	MainFrame.Size = UDim2.new(0, 500, 0, 400)
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
	MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	MainFrame.BorderSizePixel = 0
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

	local UICorner = Instance.new("UICorner", MainFrame)
	UICorner.CornerRadius = UDim.new(0, 10)

	local Title = Instance.new("TextLabel", MainFrame)
	Title.Text = title or "RedFox UI"
	Title.Size = UDim2.new(1, 0, 0, 40)
	Title.TextColor3 = Color3.fromRGB(255, 0, 0)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 22
	Title.BackgroundTransparency = 1

	local Container = Instance.new("ScrollingFrame", MainFrame)
	Container.Size = UDim2.new(1, -10, 1, -50)
	Container.Position = UDim2.new(0, 5, 0, 45)
	Container.BackgroundTransparency = 1
	Container.CanvasSize = UDim2.new(0, 0, 0, 0)
	Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Container.ScrollBarThickness = 5

	local UIListLayout = Instance.new("UIListLayout", Container)
	UIListLayout.Padding = UDim.new(0, 10)

	return {
		GUI = ScreenGui,
		Container = Container,
		AddToggle = function(self, name, callback)
			local Toggle = Instance.new("TextButton", self.Container)
			Toggle.Size = UDim2.new(1, -10, 0, 30)
			Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.Font = Enum.Font.Gotham
			Toggle.TextSize = 14
			Toggle.Text = "[ OFF ] " .. name
			Toggle.AutoButtonColor = false

			local enabled = false
			Toggle.MouseButton1Click:Connect(function()
				enabled = not enabled
				Toggle.Text = (enabled and "[ ON  ] " or "[ OFF ] ") .. name
				callback(enabled)
			end)
		end,

		AddButton = function(self, name, callback)
			local Button = Instance.new("TextButton", self.Container)
			Button.Size = UDim2.new(1, -10, 0, 30)
			Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.Font = Enum.Font.GothamBold
			Button.TextSize = 14
			Button.Text = name
			Button.AutoButtonColor = true
			Button.MouseButton1Click:Connect(callback)
		end,

		AddTextbox = function(self, name, callback)
			local TextLabel = Instance.new("TextLabel", self.Container)
			TextLabel.Size = UDim2.new(1, -10, 0, 20)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = name
			TextLabel.Font = Enum.Font.Gotham
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextSize = 12
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			local TextBox = Instance.new("TextBox", self.Container)
			TextBox.Size = UDim2.new(1, -10, 0, 30)
			TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.Font = Enum.Font.Gotham
			TextBox.TextSize = 14
			TextBox.PlaceholderText = "Type here..."
			TextBox.FocusLost:Connect(function()
				callback(TextBox.Text)
			end)
		end,

		AddSlider = function(self, name, min, max, callback)
			local SliderLabel = Instance.new("TextLabel", self.Container)
			SliderLabel.Size = UDim2.new(1, -10, 0, 20)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = name .. ": " .. min
			SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SliderLabel.Font = Enum.Font.Gotham
			SliderLabel.TextSize = 12
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

			local Slider = Instance.new("TextButton", self.Container)
			Slider.Size = UDim2.new(1, -10, 0, 20)
			Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Slider.Text = ""
			Slider.AutoButtonColor = false

			local Fill = Instance.new("Frame", Slider)
			Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			Fill.Size = UDim2.new(0, 0, 1, 0)
			Fill.BorderSizePixel = 0

			local dragging = false
			local function update(input)
				local pos = UDim2.new(math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1), 0, 1, 0)
				Fill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
				local value = math.floor((max - min) * pos.X.Scale + min)
				SliderLabel.Text = name .. ": " .. value
				callback(value)
			end

			Slider.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					update(input)
				end
			end)

			Slider.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			game:GetService("UserInputService").InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					update(input)
				end
			end)
		end,

		AddDropdown = function(self, name, options, callback)
			local DropdownLabel = Instance.new("TextLabel", self.Container)
			DropdownLabel.Size = UDim2.new(1, -10, 0, 20)
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Text = name
			DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropdownLabel.Font = Enum.Font.Gotham
			DropdownLabel.TextSize = 12
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

			local Dropdown = Instance.new("TextButton", self.Container)
			Dropdown.Size = UDim2.new(1, -10, 0, 30)
			Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
			Dropdown.Font = Enum.Font.Gotham
			Dropdown.TextSize = 14
			Dropdown.Text = "Select"

			Dropdown.MouseButton1Click:Connect(function()
				local Menu = Instance.new("Frame", Dropdown)
				Menu.Position = UDim2.new(0, 0, 1, 0)
				Menu.Size = UDim2.new(1, 0, 0, #options * 25)
				Menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
				Menu.BorderSizePixel = 0

				for _, opt in ipairs(options) do
					local Btn = Instance.new("TextButton", Menu)
					Btn.Size = UDim2.new(1, 0, 0, 25)
					Btn.Text = opt
					Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
					Btn.Font = Enum.Font.Gotham
					Btn.TextSize = 12
					Btn.MouseButton1Click:Connect(function()
						Dropdown.Text = opt
						callback(opt)
						Menu:Destroy()
					end)
				end
			end)
		end
	}
end

return RedFoxUILib
