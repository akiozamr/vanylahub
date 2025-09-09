local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 400)
mainFrame.Position = UDim2.new(0.8, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Text = "Teleport Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(1, -10, 1, -40)
teleportFrame.Position = UDim2.new(0, 5, 0, 35)
teleportFrame.BackgroundTransparency = 1
teleportFrame.Parent = mainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = teleportFrame
UIListLayout.Padding = UDim.new(0, 5)

local coords = {
    Vector3.new(223.0, 150.8, 443.1),
    Vector3.new(430.2, 160.3, 954.2),
    Vector3.new(992.6, 229.3, 1044.0),
    Vector3.new(755.0, 365.0, 1447.3),
    Vector3.new(1332.8, 417.0, 1925.3),
    Vector3.new(2620.4, 989.8, 1735.5),
    Vector3.new(3519.5, 1028.8, 1224.9),
    Vector3.new(4010.6, 1121.0, 1839.1),
    Vector3.new(3645.8, 1250.2, 2129.5),
    Vector3.new(4475.3, 1452.3, 3296.4),
    Vector3.new(4501.7, 1601.4, 3127.0),
    Vector3.new(5193.8, 1858.8, 3110.7),
    Vector3.new(5194.1, 2268.4, 173.9),
}

local function createButton(index, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
    btn.Text = "Teleport " .. index
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = teleportFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(pos)
        end
    end)
end

for i, v in ipairs(coords) do
    createButton(i, v)
end