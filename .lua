-- RedFoxUILib.lua (Modern UI: Blacked Out + Red Accents, Draggable, Blur Fade with Transparency, Grid Outlines, Singleton)
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

	-- Blur fade effect (transparency-based)
	local blur = Instance.new("BlurEffect")
	blur.Size = 20
	blur.Name = "RedFoxBlur"
	blur.Parent = Lighting

	task.spawn(function()
		local steps = 40
		for i = 1, steps do
			blur.Size = 20 * (1 - i / steps)
			wait(0.05)
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

	local titleBar = Instance.new("TextLabel", mainFrame)
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundTransparency = 1
	titleBar.Text = title or "RedFox UI"
	titleBar.TextColor3 = Color3.fromRGB(255, 30, 30)
	titleBar.Font = Enum.Font.GothamBold
	titleBar.TextSize = 20

	local tabButtonsFrame = Instance.new("Frame", mainFrame)
	tabButtonsFrame.Size = UDim2.new(0, 150, 1, -40)
	tabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
	tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	Instance.new("UICorner", tabButtonsFrame).CornerRadius = UDim.new(0, 8)
	local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 4)

	local contentFrame = Instance.new("Frame", mainFrame)
	contentFrame.Position = UDim2.new(0, 160, 0, 40)
	contentFrame.Size = UDim2.new(1, -160, 1, -40)
	contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 6)

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
		button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
		Instance.new("UIListLayout", tabFrame).Padding = UDim.new(0, 8)

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

		return api
	end

	return RedFoxUILib
end

return RedFoxUILib
