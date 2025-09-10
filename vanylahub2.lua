local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
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
local savedCoords = {}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanylaHub"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 360)
mainFrame.Position = UDim2.new(0.5, -190, 0.45, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "[ VANYLA HUB ]"
titleText.TextColor3 = Color3.fromRGB(200, 200, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -35, 0.5, -14)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 35)
tabFrame.Position = UDim2.new(0, 5, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -90)
contentFrame.Position = UDim2.new(0, 5, 0, 85)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local tabs = {}
local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, -5, 1, 0)
    btn.Position = UDim2.new((order-1)*0.33, 5*(order-1), 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = tabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = contentFrame

    tabs[name] = {Button=btn, Page=page}
    btn.MouseButton1Click:Connect(function()
        for _,tab in pairs(tabs) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(90, 90, 150)
    end)
end

createTab("Player",1)
createTab("Optifine",2)
createTab("Teleport",3)
tabs["Player"].Page.Visible = true
tabs["Player"].Button.BackgroundColor3 = Color3.fromRGB(90,90,150)

local wsMinus = Instance.new("TextButton")
wsMinus.Size = UDim2.new(0, 35, 0, 28)
wsMinus.Position = UDim2.new(0, 15, 0, 10)
wsMinus.Text = "-"
wsMinus.BackgroundColor3 = Color3.fromRGB(60,60,70)
wsMinus.TextColor3 = Color3.fromRGB(220,220,220)
wsMinus.Parent = tabs["Player"].Page
Instance.new("UICorner", wsMinus).CornerRadius = UDim.new(0,6)

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(0, 110, 0, 28)
wsLabel.Position = UDim2.new(0, 55, 0, 10)
wsLabel.Text = tostring(humanoid.WalkSpeed)
wsLabel.BackgroundColor3 = Color3.fromRGB(35,35,45)
wsLabel.TextColor3 = Color3.fromRGB(200,200,200)
wsLabel.Font = Enum.Font.GothamBold
wsLabel.TextSize = 14
wsLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", wsLabel).CornerRadius = UDim.new(0,6)

local wsPlus = Instance.new("TextButton")
wsPlus.Size = UDim2.new(0, 35, 0, 28)
wsPlus.Position = UDim2.new(0, 175, 0, 10)
wsPlus.Text = "+"
wsPlus.BackgroundColor3 = Color3.fromRGB(60,60,70)
wsPlus.TextColor3 = Color3.fromRGB(220,220,220)
wsPlus.Parent = tabs["Player"].Page
Instance.new("UICorner", wsPlus).CornerRadius = UDim.new(0,6)

local jpMinus = Instance.new("TextButton")
jpMinus.Size = UDim2.new(0, 35, 0, 28)
jpMinus.Position = UDim2.new(0, 15, 0, 50)
jpMinus.Text = "-"
jpMinus.BackgroundColor3 = Color3.fromRGB(60,60,70)
jpMinus.TextColor3 = Color3.fromRGB(220,220,220)
jpMinus.Parent = tabs["Player"].Page
Instance.new("UICorner", jpMinus).CornerRadius = UDim.new(0,6)

local jpLabel = Instance.new("TextLabel")
jpLabel.Size = UDim2.new(0, 110, 0, 28)
jpLabel.Position = UDim2.new(0, 55, 0, 50)
jpLabel.Text = tostring(humanoid.JumpPower)
jpLabel.BackgroundColor3 = Color3.fromRGB(35,35,45)
jpLabel.TextColor3 = Color3.fromRGB(200,200,200)
jpLabel.Font = Enum.Font.GothamBold
jpLabel.TextSize = 14
jpLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", jpLabel).CornerRadius = UDim.new(0,6)

local jpPlus = Instance.new("TextButton")
jpPlus.Size = UDim2.new(0, 35, 0, 28)
jpPlus.Position = UDim2.new(0, 175, 0, 50)
jpPlus.Text = "+"
jpPlus.BackgroundColor3 = Color3.fromRGB(60,60,70)
jpPlus.TextColor3 = Color3.fromRGB(220,220,220)
jpPlus.Parent = tabs["Player"].Page
Instance.new("UICorner", jpPlus).CornerRadius = UDim.new(0,6)

local ujBtn = Instance.new("TextButton")
ujBtn.Size = UDim2.new(0.9, 0, 0, 28)
ujBtn.Position = UDim2.new(0.05, 0, 0, 90)
ujBtn.Text = "Unlimited Jump: OFF"
ujBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
ujBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
ujBtn.TextSize = 14
ujBtn.Font = Enum.Font.GothamBold
ujBtn.Parent = tabs["Player"].Page
Instance.new("UICorner", ujBtn).CornerRadius = UDim.new(0, 6)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.9, 0, 0, 28)
fpsLabel.Position = UDim2.new(0.05, 0, 0, 130)
fpsLabel.BackgroundColor3 = Color3.fromRGB(35,35,45)
fpsLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
fpsLabel.TextSize = 14
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 6)

local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0.9, 0, 0, 28)
coordLabel.Position = UDim2.new(0.05, 0, 0, 170)
coordLabel.BackgroundColor3 = Color3.fromRGB(35,35,45)
coordLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
coordLabel.TextSize = 14
coordLabel.Font = Enum.Font.GothamBold
coordLabel.Text = "XYZ: 0,0,0"
coordLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", coordLabel).CornerRadius = UDim.new(0, 6)

local optimizeBtn = Instance.new("TextButton")
optimizeBtn.Size = UDim2.new(0.9, 0, 0, 28)
optimizeBtn.Position = UDim2.new(0.05, 0, 0, 10)
optimizeBtn.Text = "Optimize Mode"
optimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 150)
optimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
optimizeBtn.TextSize = 14
optimizeBtn.Font = Enum.Font.GothamBold
optimizeBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", optimizeBtn).CornerRadius = UDim.new(0, 6)

local ultraBtn = Instance.new("TextButton")
ultraBtn.Size = UDim2.new(0.9, 0, 0, 28)
ultraBtn.Position = UDim2.new(0.05, 0, 0, 50)
ultraBtn.Text = "Ultra Optimize"
ultraBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
ultraBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
ultraBtn.TextSize = 14
ultraBtn.Font = Enum.Font.GothamBold
ultraBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", ultraBtn).CornerRadius = UDim.new(0, 6)

local teleportPage = tabs["Teleport"].Page
local teleportList = Instance.new("Frame")
teleportList.Size = UDim2.new(1, 0, 1, -45)
teleportList.Position = UDim2.new(0, 0, 0, 40)
teleportList.BackgroundTransparency = 1
teleportList.Parent = teleportPage

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.9, 0, 0, 28)
saveBtn.Position = UDim2.new(0.05, 0, 0, 5)
saveBtn.Text = "Simpan Koordinat"
saveBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
saveBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
saveBtn.TextSize = 14
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = teleportPage
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

local function refreshTeleportList()
    for _,child in pairs(teleportList:GetChildren()) do
        child:Destroy()
    end
    for i,coord in ipairs(savedCoords) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 28)
        btn.Position = UDim2.new(0.05, 0, 0, (i-1)*32)
        btn.Text = string.format("Teleport %d", i)
        btn.BackgroundColor3 = Color3.fromRGB(90,90,150)
        btn.TextColor3 = Color3.fromRGB(220,220,220)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.Parent = teleportList
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = CFrame.new(coord) end
        end)
    end
end

saveBtn.MouseButton1Click:Connect(function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        table.insert(savedCoords, root.Position)
        refreshTeleportList()
    end
end)

local function updateStats()
    wsLabel.Text = tostring(humanoid.WalkSpeed)
    jpLabel.Text = tostring(humanoid.JumpPower)
end

wsMinus.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed -= 1
    updateStats()
end)
wsPlus.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed += 1
    updateStats()
end)
jpMinus.MouseButton1Click:Connect(function()
    humanoid.JumpPower -= 1
    updateStats()
end)
jpPlus.MouseButton1Click:Connect(function()
    humanoid.JumpPower += 1
    updateStats()
end)

ujBtn.MouseButton1Click:Connect(function()
    unlimitedJump = not unlimitedJump
    ujBtn.Text = "Unlimited Jump: " .. (unlimitedJump and "ON" or "OFF")
    ujBtn.BackgroundColor3 = unlimitedJump and Color3.fromRGB(60,150,90) or Color3.fromRGB(150,60,60)
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
        optimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 90, 150)
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
        optimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
    end
end

optimizeBtn.MouseButton1Click:Connect(optimizeGame)

ultraBtn.MouseButton1Click:Connect(function()
    if isUltraMode then
        Lighting.GlobalShadows = true
        Lighting.Brightness = 2
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = originalSettings[v] or v.Material end
        end
        isUltraMode = false
        ultraBtn.Text = "Ultra Optimize"
        ultraBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
        Lighting.GlobalShadows = false
        Lighting.Brightness = 5
        isUltraMode = true
        ultraBtn.Text = "Restore Ultra"
        ultraBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 90)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if unlimitedJump and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")