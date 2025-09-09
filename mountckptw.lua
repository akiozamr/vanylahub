local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiFallTeleport"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 100)
mainFrame.Position = UDim2.new(0.75, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Text = "Anti Fall & Teleport"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local fallBtn = Instance.new("TextButton")
fallBtn.Size = UDim2.new(0.9, 0, 0, 28)
fallBtn.Position = UDim2.new(0.05, 0, 0, 32)
fallBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
fallBtn.Text = "Anti Fall: OFF"
fallBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fallBtn.Font = Enum.Font.GothamBold
fallBtn.TextSize = 12
fallBtn.Parent = mainFrame
Instance.new("UICorner", fallBtn).CornerRadius = UDim.new(0, 8)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 28)
tpBtn.Position = UDim2.new(0.05, 0, 0, 66)
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
tpBtn.Text = "Teleport to Spawn"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 12
tpBtn.Parent = mainFrame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 8)

local antiFall = false
local connection

fallBtn.MouseButton1Click:Connect(function()
    antiFall = not antiFall
    if antiFall then
        fallBtn.Text = "Anti Fall: ON"
        fallBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.FloorMaterial == Enum.Material.Air then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        fallBtn.Text = "Anti Fall: OFF"
        fallBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
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
        local spawn = Workspace:FindFirstChildOfClass("SpawnLocation")
        if spawn then
            root.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        else
            root.CFrame = CFrame.new(Vector3.new(0, 10, 0))
        end
    end
end)
