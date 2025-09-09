local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodTeleport"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.78, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Text = "God & Teleport"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(0.9, 0, 0, 28)
godBtn.Position = UDim2.new(0.05, 0, 0, 32)
godBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
godBtn.Text = "God Mode: OFF"
godBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
godBtn.Font = Enum.Font.GothamBold
godBtn.TextSize = 12
godBtn.Parent = mainFrame
Instance.new("UICorner", godBtn).CornerRadius = UDim.new(0, 8)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 28)
tpBtn.Position = UDim2.new(0.05, 0, 0, 66)
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
tpBtn.Text = "Teleport"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 12
tpBtn.Parent = mainFrame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

local godMode = false
local connection

godBtn.MouseButton1Click:Connect(function()
    godMode = not godMode
    if godMode then
        godBtn.Text = "God Mode: ON"
        godBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
            end
        end)
    else
        godBtn.Text = "God Mode: OFF"
        godBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(507.0, 113.6, -324.3)
    end
end)
