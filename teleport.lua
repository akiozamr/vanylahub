local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTeleport"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 60)
mainFrame.Position = UDim2.new(0.8, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Text = "Auto Teleport"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 25)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
toggleBtn.Text = "Teleport: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

local coords = {
    Vector3.new(223.0, 145.8, 443.1),
    Vector3.new(430.2, 155.3, 954.2),
    Vector3.new(992.6, 224.3, 1044.0),
    Vector3.new(755.0, 360.0, 1447.3),
    Vector3.new(1332.8, 412.0, 1925.3),
    Vector3.new(2620.4, 984.8, 1735.5),
    Vector3.new(3519.5, 1023.8, 1224.9),
    Vector3.new(4010.6, 1116.0, 1839.1),
    Vector3.new(3645.8, 1245.2, 2129.5),
    Vector3.new(4475.3, 1447.3, 3296.4),
    Vector3.new(4501.7, 1596.4, 3127.0),
    Vector3.new(5193.8, 1853.8, 3110.7),
    Vector3.new(5194.1, 2263.4, 173.9),
}

local autoTeleport = false

local function teleportSequence()
    while autoTeleport do
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            for _, pos in ipairs(coords) do
                if not autoTeleport then break end
                root.CFrame = CFrame.new(pos)
                task.wait(1)
            end
        end
        task.wait(1)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    autoTeleport = not autoTeleport
    if autoTeleport then
        toggleBtn.Text = "Teleport: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        task.spawn(teleportSequence)
    else
        toggleBtn.Text = "Teleport: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    end
end)