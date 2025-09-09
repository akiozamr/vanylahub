local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTeleport"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 90)
mainFrame.Position = UDim2.new(0.78, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Text = "Auto Teleport"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 26)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 32)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
toggleBtn.Text = "Teleport: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = mainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(0.58, 0, 0, 24)
delayBox.Position = UDim2.new(0.05, 0, 0, 62)
delayBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
delayBox.PlaceholderText = "Delay detik"
delayBox.Text = "5"
delayBox.TextColor3 = Color3.fromRGB(255, 255, 255)
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 12
delayBox.Parent = mainFrame
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 8)

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.32, 0, 0, 24)
applyBtn.Position = UDim2.new(0.63, 0, 0, 62)
applyBtn.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
applyBtn.Text = "Set"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 12
applyBtn.Parent = mainFrame
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 8)

local coords = {
    Vector3.new(223.0, 150.8 - 3, 443.1),
    Vector3.new(430.2, 160.3 - 3, 954.2),
    Vector3.new(992.6, 229.3 - 3, 1044.0),
    Vector3.new(755.0, 365.0 - 3, 1447.3),
    Vector3.new(1332.8, 417.0 - 3, 1925.3),
    Vector3.new(2620.4, 989.8 - 3, 1735.5),
    Vector3.new(3519.5, 1028.8 - 3, 1224.9),
    Vector3.new(4010.6, 1121.0 - 3, 1839.1),
    Vector3.new(3645.8, 1250.2 - 3, 2129.5),
    Vector3.new(4475.3, 1452.3 - 3, 3296.4),
    Vector3.new(4501.7, 1601.4 - 3, 3127.0),
    Vector3.new(5193.8, 1858.8 - 3, 3110.7),
    Vector3.new(5194.1, 2268.4 - 3, 173.9),
}

local function waitSeconds(s)
    local t = 0
    while t < s do
        t = t + RunService.Heartbeat:Wait()
    end
end

local autoTeleport = false
local delaySeconds = 5
local running = false

applyBtn.MouseButton1Click:Connect(function()
    local v = tonumber(delayBox.Text)
    if v and v > 0 then delaySeconds = v end
    delayBox.Text = tostring(delaySeconds)
end)

local function teleportLoop()
    if running then return end
    running = true
    local i = 1
    while autoTeleport do
        local character = player.Character or player.CharacterAdded:Wait()
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(coords[i])
            waitSeconds(delaySeconds)
            i = i + 1
            if i > #coords then i = 1 end
        else
            waitSeconds(0.2)
        end
    end
    running = false
end

toggleBtn.MouseButton1Click:Connect(function()
    autoTeleport = not autoTeleport
    if autoTeleport then
        toggleBtn.Text = "Teleport: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
        task.spawn(teleportLoop)
    else
        toggleBtn.Text = "Teleport: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    end
end)