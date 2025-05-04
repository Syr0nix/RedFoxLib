-- RedFoxUILib.lua (Modern UI: Blacked Out + Red Accents, Draggable, Blur, Grid Outlines, Singleton)
local RedFoxUILib = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Prevent duplicates
local existing = Players.LocalPlayer:FindFirstChild("PlayerGui") and Players.LocalPlayer.PlayerGui:FindFirstChild("RedFoxUI")
if existing then
	existing:Destroy()
	for _, v in ipairs(Lighting:GetChildren()) do
		if v:IsA("BlurEffect") and v.Parent == Lighting then
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

	-- Temporary blur effect for 5 seconds
	local blur = Instance.new("BlurEffect")
	blur.Size = 20
	blur.Parent = Lighting
	task.delay(5, function()
		if blur and blur.Parent then
			blur:Destroy()
		end
	end)

	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Size = UDim2.new(0, 700, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

	local sidebar = Instance.new("Frame", mainFrame)
	sidebar.Size = UDim2.new(0, 160, 1, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 6)

	local sidebarLayout = Instance.new("UIListLayout", sidebar)
	sidebarLayout.Padding = UDim.new(0, 5)
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local titleLabel = Instance.new("TextLabel", sidebar)
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.Text = title or "RedFox UI"
	titleLabel.TextColor3 = Color3.fromRGB(255, 30, 30)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20
	titleLabel.BackgroundTransparency = 1
	titleLabel.LayoutOrder = 0

	local contentFrame = Instance.new("Frame", mainFrame)
	contentFrame.Position = UDim2.new(0, 160, 0, 0)
	contentFrame.Size = UDim2.new(1, -160, 1, 0)
	contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 6)

	local popup = Instance.new("TextLabel", screenGui)
	popup.Size = UDim2.new(0, 250, 0, 30)
	popup.Position = UDim2.new(0, 10, 1, -40)
	popup.Text = "RedFoxUI made By Syr0nix"
	popup.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	popup.TextColor3 = Color3.fromRGB(255, 0, 0)
	popup.Font = Enum.Font.GothamBold
	popup.TextSize = 14
	popup.TextXAlignment = Enum.TextXAlignment.Left
	popup.BackgroundTransparency = 0.2
	popup.AnchorPoint = Vector2.new(0, 1)
	popup.Visible = true
	Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 6)
	Instance.new("UIStroke", popup).Color = Color3.fromRGB(60, 0, 0)

	task.spawn(function()
		wait(5)
		if popup then popup:Destroy() end
	end)

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
		tabButton.TextColor3 = Color3.fromRGB(255, 0, 0)
		tabButton.AutoButtonColor = true
		tabButton.LayoutOrder = 1 + #sidebar:GetChildren()
		Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", tabButton)
		stroke.Thickness = 1
		stroke.Color = Color3.fromRGB(60, 0, 0)

		local tabContent = Instance.new("ScrollingFrame", contentFrame)
		tabContent.Visible = false
		tabContent.Size = UDim2.new(1, -20, 1, -20)
		tabContent.Position = UDim2.new(0, 10, 0, 10)
		tabContent.BackgroundTransparency = 1
		tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
		tabContent.ScrollBarThickness = 6
		Instance.new("UIListLayout", tabContent).Padding = UDim.new(0, 8)

		tabButton.MouseButton1Click:Connect(function()
			switchTab(tabContent)
		end)

		if not currentTab then switchTab(tabContent) end

		local api = {}

		function api:AddToggle(text, callback)
			local frame = Instance.new("Frame", tabContent)
			frame.Size = UDim2.new(1, -10, 0, 30)
			frame.BackgroundTransparency = 1
			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(0.7, -10, 1, 0)
			label.Position = UDim2.new(0, 0, 0, 0)
			label.Text = text
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.fromRGB(255, 0, 0)
			label.Font = Enum.Font.Gotham
			label.TextSize = 14

			local toggle = Instance.new("TextButton", frame)
			toggle.Size = UDim2.new(0.3, -10, 1, 0)
			toggle.Position = UDim2.new(0.7, 10, 0, 0)
			toggle.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
			toggle.Text = ""
			Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 14)
			local indicator = Instance.new("Frame", toggle)
			indicator.Size = UDim2.new(0.5, -4, 1, -4)
			indicator.Position = UDim2.new(0, 2, 0, 2)
			indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			indicator.BorderSizePixel = 0
			Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

			local state = false
			toggle.MouseButton1Click:Connect(function()
				state = not state
				indicator:TweenPosition(UDim2.new(state and 1 or 0, state and -indicator.Size.X.Offset - 2 or 2, 0, 2), "Out", "Sine", 0.2, true)
				toggle.BackgroundColor3 = state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 0, 0)
				callback(state)
			end)
		end

		return api
	end

	return self
end

return RedFoxUILib
