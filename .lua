-- RedFoxUILib (Part 1: Core Setup + Base UI + Blur + F5 toggle)

local RedFoxUILib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- GUI Setup
local RedFoxUI = Instance.new("ScreenGui")
RedFoxUI.Name = "RedFoxUI"
RedFoxUI.ResetOnSpawn = false
RedFoxUI.IgnoreGuiInset = true
RedFoxUI.Parent = CoreGui

-- Blur Effect
local blur = Instance.new("BlurEffect", game:GetService("Lighting"))
blur.Size = 18
blur.Enabled = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = RedFoxUI

-- Red Glow Border
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- Corner Rounding
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Dragging
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
									   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- F5 Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.F5 then
		RedFoxUI.Enabled = not RedFoxUI.Enabled
		blur.Enabled = RedFoxUI.Enabled
	end
end)

-- UI Elements Placeholder (to be filled in Part 2+)
local function createTab(name)
	local tab = Instance.new("Frame")
	tab.Name = name
	tab.Size = UDim2.new(1, 0, 1, 0)
	tab.BackgroundTransparency = 1
	tab.Parent = MainFrame
	return tab
end

-- Return API for extending
RedFoxUILib.CreateTab = createTab
RedFoxUILib.MainFrame = MainFrame
RedFoxUILib.ScreenGui = RedFoxUI

return RedFoxUILib
