local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CoordTracker"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.4, -100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(40,40,60)
title.Text = "Coordinate Tools"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Tombol track Icella2
local trackBtn = Instance.new("TextButton", frame)
trackBtn.Size = UDim2.new(0.9,0,0,30)
trackBtn.Position = UDim2.new(0.05,0,0,40)
trackBtn.BackgroundColor3 = Color3.fromRGB(100,150,250)
trackBtn.Text = "Lacak Icella2 (Copy Koordinat)"
trackBtn.TextColor3 = Color3.fromRGB(255,255,255)
trackBtn.Font = Enum.Font.GothamBold
trackBtn.TextSize = 14
Instance.new("UICorner", trackBtn).CornerRadius = UDim.new(0,6)

-- Input Teleport
local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(0.9,0,0,30)
inputBox.Position = UDim2.new(0.05,0,0,80)
inputBox.PlaceholderText = "X,Y,Z"
inputBox.BackgroundColor3 = Color3.fromRGB(50,50,70)
inputBox.TextColor3 = Color3.fromRGB(255,255,255)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0,6)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0.9,0,0,30)
tpBtn.Position = UDim2.new(0.05,0,0,120)
tpBtn.BackgroundColor3 = Color3.fromRGB(100,200,100)
tpBtn.Text = "Teleport ke Koordinat"
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,6)

-- Fungsi copy koordinat Icella2
trackBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild("Icella2")
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos = target.Character.HumanoidRootPart.Position
        local coord = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        if setclipboard then
            setclipboard(coord)
        end
        trackBtn.Text = "Koordinat Dicopy!"
        task.wait(1.5)
        trackBtn.Text = "Lacak Icella2 (Copy Koordinat)"
    else
        trackBtn.Text = "Icella2 Tidak Ada!"
        task.wait(1.5)
        trackBtn.Text = "Lacak Icella2 (Copy Koordinat)"
    end
end)

-- Fungsi teleport ke koordinat input
tpBtn.MouseButton1Click:Connect(function()
    local coords = string.split(inputBox.Text, ",")
    if #coords == 3 then
        local x = tonumber(coords[1])
        local y = tonumber(coords[2])
        local z = tonumber(coords[3])
        if x and y and z then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(x,y,z)
            end
        end
    end
end)