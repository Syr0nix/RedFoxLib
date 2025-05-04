-- RedFoxUILib Modern (Black UI + Red Text + Blur + Visual Polish)
local RedFoxUILib = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Cleanup previous
local existing = Players.LocalPlayer.PlayerGui:FindFirstChild("RedFoxUI")
if existing then existing:Destroy() end
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("BlurEffect") and v.Name == "RedFoxBlur" then v:Destroy() end
end

function RedFoxUILib:CreateWindow(title)
    -- Blur
    local blur = Instance.new("BlurEffect", Lighting)
    blur.Name = "RedFoxBlur"
    blur.Size = 20
    task.spawn(function()
        wait(5)
        for i = 1, 30 do
            blur.Size = 20 - (i * (20 / 30))
            wait(0.03)
        end
        blur.Enabled = false
    end)

    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "RedFoxUI"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 720, 0, 460)
    main.Position = UDim2.new(0.5, -360, 0.5, -230)
    main.BackgroundColor3 = Color3.new(0, 0, 0)
    main.Active, main.Draggable = true, true
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

    local titleBar = Instance.new("TextLabel", main)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Text = title or "RedFox UI"
    titleBar.BackgroundTransparency = 1
    titleBar.TextColor3 = Color3.fromRGB(255, 0, 0)
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 20

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 150, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)
    local list = Instance.new("UIListLayout", sidebar)
    list.Padding = UDim.new(0, 4)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    local content = Instance.new("Frame", main)
    content.Position = UDim2.new(0, 160, 0, 40)
    content.Size = UDim2.new(1, -160, 1, -40)
    content.BackgroundColor3 = Color3.new(0, 0, 0)
    Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

    local popup = Instance.new("TextLabel", gui)
    popup.Text = "RedFoxUI made by Syr0nix"
    popup.Position = UDim2.new(0, 12, 1, -50)
    popup.Size = UDim2.new(0, 260, 0, 30)
    popup.TextColor3 = Color3.new(1, 1, 1)
    popup.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    popup.Font = Enum.Font.GothamBold
    popup.TextSize = 14
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
    local function switchTab(tab)
        if currentTab then currentTab.Visible = false end
        currentTab = tab
        currentTab.Visible = true
    end

    function RedFoxUILib:AddTab(tabName)
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 0, 0)
        btn.BackgroundColor3 = Color3.new(0, 0, 0)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        local tab = Instance.new("ScrollingFrame", content)
        tab.Visible = false
        tab.BackgroundTransparency = 1
        tab.Position = UDim2.new(0, 5, 0, 5)
        tab.Size = UDim2.new(1, -10, 1, -10)
        tab.CanvasSize = UDim2.new(0, 0, 0, 0)
        tab.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tab.ScrollBarThickness = 6
        local tabList = Instance.new("UIListLayout", tab)
        tabList.Padding = UDim.new(0, 8)
        tabList.SortOrder = Enum.SortOrder.LayoutOrder

        btn.MouseButton1Click:Connect(function()
            switchTab(tab)
        end)
        if not currentTab then switchTab(tab) end

        local api = {}

        function api:AddButton(text, cb)
            local b = Instance.new("TextButton", tab)
            b.Size = UDim2.new(1, -10, 0, 30)
            b.Text = text
            b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            b.TextColor3 = Color3.fromRGB(255, 0, 0)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 14
            b.AutoButtonColor = true
            b.MouseButton1Click:Connect(cb)
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        end

        function api:AddToggle(text, cb)
            local state = false
            local t = Instance.new("TextButton", tab)
            t.Size = UDim2.new(1, -10, 0, 30)
            t.BackgroundColor3 = Color3.new(0, 0, 0)
            t.TextColor3 = Color3.fromRGB(255, 0, 0)
            t.Text = text .. ": OFF"
            t.Font = Enum.Font.GothamBold
            t.TextSize = 14
            Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
            t.MouseButton1Click:Connect(function()
                state = not state
                t.Text = text .. ": " .. (state and "ON" or "OFF")
                cb(state)
            end)
        end

        function api:AddTextbox(name, cb)
            local l = Instance.new("TextLabel", tab)
            l.Text = name
            l.TextColor3 = Color3.fromRGB(255, 0, 0)
            l.Size = UDim2.new(1, -10, 0, 20)
            l.BackgroundTransparency = 1
            l.Font = Enum.Font.Gotham
            l.TextSize = 13

            local b = Instance.new("TextBox", tab)
            b.Size = UDim2.new(1, -10, 0, 30)
            b.Text = ""
            b.PlaceholderText = "Enter text..."
            b.BackgroundColor3 = Color3.new(0, 0, 0)
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            b.FocusLost:Connect(function()
                cb(b.Text)
            end)
        end

        function api:AddSlider(name, min, max, cb)
            local l = Instance.new("TextLabel", tab)
            l.Text = name .. ": " .. min
            l.TextColor3 = Color3.fromRGB(255, 0, 0)
            l.Size = UDim2.new(1, -10, 0, 20)
            l.BackgroundTransparency = 1
            l.Font = Enum.Font.Gotham
            l.TextSize = 13

            local s = Instance.new("Frame", tab)
            s.Size = UDim2.new(1, -10, 0, 20)
            s.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Instance.new("UICorner", s).CornerRadius = UDim.new(0, 6)

            local fill = Instance.new("Frame", s)
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            fill.BorderSizePixel = 0
            Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 6)

            s.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local conn
                    conn = UserInputService.InputChanged:Connect(function(m)
                        if m.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = (m.Position.X - s.AbsolutePosition.X) / s.AbsoluteSize.X
                            rel = math.clamp(rel, 0, 1)
                            fill.Size = UDim2.new(rel, 0, 1, 0)
                            local val = math.floor(min + (max - min) * rel)
                            l.Text = name .. ": " .. val
                            cb(val)
                        end
                    end)
                    UserInputService.InputEnded:Wait()
                    conn:Disconnect()
                end
            end)
        end

        function api:AddDropdown(name, options, cb)
            local label = Instance.new("TextLabel", tab)
            label.Text = name
            label.Size = UDim2.new(1, -10, 0, 20)
            label.TextColor3 = Color3.fromRGB(255, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 13

            local drop = Instance.new("TextButton", tab)
            drop.Size = UDim2.new(1, -10, 0, 30)
            drop.BackgroundColor3 = Color3.new(0, 0, 0)
            drop.TextColor3 = Color3.new(1, 1, 1)
            drop.Text = "Select"
            drop.Font = Enum.Font.Gotham
            drop.TextSize = 14
            Instance.new("UICorner", drop).CornerRadius = UDim.new(0, 6)

            drop.MouseButton1Click:Connect(function()
                local menu = Instance.new("Frame", drop)
                menu.Position = UDim2.new(0, 0, 1, 0)
                menu.Size = UDim2.new(1, 0, 0, #options * 25)
                menu.BackgroundColor3 = Color3.new(0, 0, 0)
                menu.ZIndex = 10
                for _, opt in pairs(options) do
                    local item = Instance.new("TextButton", menu)
                    item.Size = UDim2.new(1, 0, 0, 25)
                    item.Text = opt
                    item.TextColor3 = Color3.new(1, 1, 1)
                    item.Font = Enum.Font.Gotham
                    item.TextSize = 13
                    item.BackgroundColor3 = Color3.new(0, 0, 0)
                    item.MouseButton1Click:Connect(function()
                        drop.Text = opt
                        cb(opt)
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
