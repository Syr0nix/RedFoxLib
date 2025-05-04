-- RedFoxUILib.lua (Polished Black & Red Modern UI with Blur, Gridlines, and Full Theme Fix)
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
			blur.Transparency = i / 30
			wait(0.03)
		end
		blur.Enabled = false
	end)

	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Size = UDim2.new(0, 700, 0, 450)
	mainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
	mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	mainFrame.BorderSizePixel = 1
	mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
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
	tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	tabButtonsFrame.BorderSizePixel = 1
	tabButtonsFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Instance.new("UICorner", tabButtonsFrame).CornerRadius = UDim.new(0, 8)
	local tabLayout = Instance.new("UIListLayout", tabButtonsFrame)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 4)

	local contentFrame = Instance.new("Frame", mainFrame)
	contentFrame.Position = UDim2.new(0, 160, 0, 40)
	contentFrame.Size = UDim2.new(1, -160, 1, -40)
	contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	contentFrame.BorderSizePixel = 1
	contentFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
	Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 6)

	local gridLines = Instance.new("UIStroke", contentFrame)
	gridLines.Color = Color3.fromRGB(255, 0, 0)
	gridLines.Thickness = 1
	gridLines.Transparency = 0.2

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

	return mainFrame, tabButtonsFrame, contentFrame
end

return RedFoxUILib
