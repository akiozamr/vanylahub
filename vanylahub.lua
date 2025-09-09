local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local unlimitedJump = false
local isOptimized = false
local isUltraMode = false
local originalSettings = {}
local optimizedParts = {}
local isMinimized = false
local fps, lastTime, frameCount = 0, tick(), 0

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanylaHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 280)
mainFrame.Position = UDim2.new(0.5, -150, 0.4, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "[ VANYLA HUB ]"
titleText.TextColor3 = Color3.fromRGB(255, 0, 0)
titleText.TextSize = 14
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -30, 0, 2.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -40)
contentFrame.Position = UDim2.new(0, 5, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local wsBox = Instance.new("TextBox")
wsBox.Size = UDim2.new(0.6, -10, 0, 25)
wsBox.Position = UDim2.new(0, 10, 0, 5)
wsBox.Text = tostring(humanoid.WalkSpeed)
wsBox.PlaceholderText = "WalkSpeed"
wsBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
wsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBox.TextSize = 14
wsBox.Font = Enum.Font.Gotham
wsBox.Parent = contentFrame
Instance.new("UICorner", wsBox).CornerRadius = UDim.new(0, 6)

local wsBtn = Instance.new("TextButton")
wsBtn.Size = UDim2.new(0.35, 0, 0, 25)
wsBtn.Position = UDim2.new(0.65, -5, 0, 5)
wsBtn.Text = "Apply"
wsBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 250)
wsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBtn.TextSize = 14
wsBtn.Font = Enum.Font.GothamBold
wsBtn.Parent = contentFrame
Instance.new("UICorner", wsBtn).CornerRadius = UDim.new(0, 6)

local jpBox = Instance.new("TextBox")
jpBox.Size = UDim2.new(0.6, -10, 0, 25)
jpBox.Position = UDim2.new(0, 10, 0, 40)
jpBox.Text = tostring(humanoid.JumpPower)
jpBox.PlaceholderText = "JumpPower"
jpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jpBox.TextSize = 14
jpBox.Font = Enum.Font.Gotham
jpBox.Parent = contentFrame
Instance.new("UICorner", jpBox).CornerRadius = UDim.new(0, 6)

local jpBtn = Instance.new("TextButton")
jpBtn.Size = UDim2.new(0.35, 0, 0, 25)
jpBtn.Position = UDim2.new(0.65, -5, 0, 40)
jpBtn.Text = "Apply"
jpBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
jpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jpBtn.TextSize = 14
jpBtn.Font = Enum.Font.GothamBold
jpBtn.Parent = contentFrame
Instance.new("UICorner", jpBtn).CornerRadius = UDim.new(0, 6)

local ujBtn = Instance.new("TextButton")
ujBtn.Size = UDim2.new(0.9, 0, 0, 25)
ujBtn.Position = UDim2.new(0.05, 0, 0, 75)
ujBtn.Text = "Unlimited Jump: OFF"
ujBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
ujBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ujBtn.TextSize = 14
ujBtn.Font = Enum.Font.GothamBold
ujBtn.Parent = contentFrame
Instance.new("UICorner", ujBtn).CornerRadius = UDim.new(0, 6)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.9, 0, 0, 25)
fpsLabel.Position = UDim2.new(0.05, 0, 0, 110)
fpsLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextSize = 14
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = contentFrame
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 6)

local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0.9, 0, 0, 25)
coordLabel.Position = UDim2.new(0.05, 0, 0, 145)
coordLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
coordLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
coordLabel.TextSize = 14
coordLabel.Font = Enum.Font.GothamBold
coordLabel.Text = "XYZ: 0,0,0"
coordLabel.Parent = contentFrame
Instance.new("UICorner", coordLabel).CornerRadius = UDim.new(0, 6)

local optimizeBtn = Instance.new("TextButton")
optimizeBtn.Size = UDim2.new(0.9, 0, 0, 25)
optimizeBtn.Position = UDim2.new(0.05, 0, 0, 180)
optimizeBtn.Text = "Optimize Mode"
optimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 250)
optimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
optimizeBtn.TextSize = 14
optimizeBtn.Font = Enum.Font.GothamBold
optimizeBtn.Parent = contentFrame
Instance.new("UICorner", optimizeBtn).CornerRadius = UDim.new(0, 6)

local ultraBtn = Instance.new("TextButton")
ultraBtn.Size = UDim2.new(0.9, 0, 0, 25)
ultraBtn.Position = UDim2.new(0.05, 0, 0, 215)
ultraBtn.Text = "Ultra Optimize"
ultraBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ultraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ultraBtn.TextSize = 14
ultraBtn.Font = Enum.Font.GothamBold
ultraBtn.Parent = contentFrame
Instance.new("UICorner", ultraBtn).CornerRadius = UDim.new(0, 6)

wsBtn.MouseButton1Click:Connect(function()
    local val = tonumber(wsBox.Text)
    if val then humanoid.WalkSpeed = val end
end)

jpBtn.MouseButton1Click:Connect(function()
    local val = tonumber(jpBox.Text)
    if val then humanoid.JumpPower = val end
end)

ujBtn.MouseButton1Click:Connect(function()
    unlimitedJump = not unlimitedJump
    ujBtn.Text = "Unlimited Jump: " .. (unlimitedJump and "ON" or "OFF")
    ujBtn.BackgroundColor3 = unlimitedJump and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
end)

UserInputService.JumpRequest:Connect(function()
    if unlimitedJump and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = now
        fpsLabel.Text = "FPS: " .. fps
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        local pos = root.Position
        coordLabel.Text = string.format("XYZ: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    end
end)

local function optimizeGame()
    if isOptimized then
        for _, part in ipairs(optimizedParts) do
            if part:IsA("BasePart") then part.Material = originalSettings[part] or part.Material end
        end
        Lighting.GlobalShadows = true
        isOptimized = false
        optimizeBtn.Text = "Optimize Mode"
        optimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 250)
    else
        optimizedParts = {}
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                originalSettings[part] = part.Material
                part.Material = Enum.Material.SmoothPlastic
                table.insert(optimizedParts, part)
            end
        end
        Lighting.GlobalShadows = false
        isOptimized = true
        optimizeBtn.Text = "Restore Graphics"
        optimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    end
end

optimizeBtn.MouseButton1Click:Connect(optimizeGame)

ultraBtn.MouseButton1Click:Connect(function()
    if isUltraMode then
        Lighting.GlobalShadows = true
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = originalSettings[v] or v.Material end
        end
        isUltraMode = false
        ultraBtn.Text = "Ultra Optimize"
        ultraBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
        Lighting.GlobalShadows = false
        isUltraMode = true
        ultraBtn.Text = "Restore Ultra"
        ultraBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    contentFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "−"
    mainFrame.Size = isMinimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 280)
end)