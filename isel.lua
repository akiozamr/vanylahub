local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.4, -75)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(40,40,60)
title.Text = "Teleport ke Koordinat"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local minimizeBtn = Instance.new("TextButton", title)
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -30, 0, 2.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255,200,50)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,6)

local inputBox = Instance.new("TextBox", frame)
inputBox.Size = UDim2.new(0.9,0,0,30)
inputBox.Position = UDim2.new(0.05,0,0,40)
inputBox.PlaceholderText = "X,Y,Z"
inputBox.BackgroundColor3 = Color3.fromRGB(50,50,70)
inputBox.TextColor3 = Color3.fromRGB(255,255,255)
inputBox.Font = Enum.Font.Gotham
inputBox.TextSize = 14
Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0,6)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0.9,0,0,30)
tpBtn.Position = UDim2.new(0.05,0,0,80)
tpBtn.BackgroundColor3 = Color3.fromRGB(100,200,100)
tpBtn.Text = "Teleport"
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,6)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    inputBox.Visible = not isMinimized
    tpBtn.Visible = not isMinimized
    frame.Size = isMinimized and UDim2.new(0,300,0,30) or UDim2.new(0,300,0,150)
    minimizeBtn.Text = isMinimized and "+" or "−"
end)

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
