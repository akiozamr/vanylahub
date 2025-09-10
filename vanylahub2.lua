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
mainFrame.Size = UDim2.new(0, 350, 0, 320)
mainFrame.Position = UDim2.new(0.5, -175, 0.4, -160)
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

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -10, 0, 30)
tabFrame.Position = UDim2.new(0, 5, 0, 35)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -75)
contentFrame.Position = UDim2.new(0, 5, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local tabs = {}
local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.3, -5, 1, 0)
    btn.Position = UDim2.new((order-1)*0.33, 5*(order-1), 0, 0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,80)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = tabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = contentFrame

    tabs[name] = {Button=btn, Page=page}
    btn.MouseButton1Click:Connect(function()
        for _,tab in pairs(tabs) do
            tab.Page.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(60,60,80)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(100,100,200)
    end)
end

createTab("Player",1)
createTab("Optifine",2)
createTab("Teleport",3)
tabs["Player"].Page.Visible = true
tabs["Player"].Button.BackgroundColor3 = Color3.fromRGB(100,100,200)

-- === Player Tab ===
local wsBox = Instance.new("TextBox")
wsBox.Size = UDim2.new(0.6, -10, 0, 25)
wsBox.Position = UDim2.new(0, 10, 0, 5)
wsBox.PlaceholderText = "WalkSpeed"
wsBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
wsBox.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBox.TextSize = 14
wsBox.Font = Enum.Font.Gotham
wsBox.Parent = tabs["Player"].Page
Instance.new("UICorner", wsBox).CornerRadius = UDim.new(0, 6)

local wsBtn = Instance.new("TextButton")
wsBtn.Size = UDim2.new(0.35, 0, 0, 25)
wsBtn.Position = UDim2.new(0.65, -5, 0, 5)
wsBtn.Text = "Apply"
wsBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 250)
wsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
wsBtn.TextSize = 14
wsBtn.Font = Enum.Font.GothamBold
wsBtn.Parent = tabs["Player"].Page
Instance.new("UICorner", wsBtn).CornerRadius = UDim.new(0, 6)

local jpBox = Instance.new("TextBox")
jpBox.Size = UDim2.new(0.6, -10, 0, 25)
jpBox.Position = UDim2.new(0, 10, 0, 40)
jpBox.PlaceholderText = "JumpPower"
jpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jpBox.TextSize = 14
jpBox.Font = Enum.Font.Gotham
jpBox.Parent = tabs["Player"].Page
Instance.new("UICorner", jpBox).CornerRadius = UDim.new(0, 6)

local jpBtn = Instance.new("TextButton")
jpBtn.Size = UDim2.new(0.35, 0, 0, 25)
jpBtn.Position = UDim2.new(0.65, -5, 0, 40)
jpBtn.Text = "Apply"
jpBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
jpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jpBtn.TextSize = 14
jpBtn.Font = Enum.Font.GothamBold
jpBtn.Parent = tabs["Player"].Page
Instance.new("UICorner", jpBtn).CornerRadius = UDim.new(0, 6)

local ujBtn = Instance.new("TextButton")
ujBtn.Size = UDim2.new(0.9, 0, 0, 25)
ujBtn.Position = UDim2.new(0.05, 0, 0, 75)
ujBtn.Text = "Unlimited Jump: OFF"
ujBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
ujBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ujBtn.TextSize = 14
ujBtn.Font = Enum.Font.GothamBold
ujBtn.Parent = tabs["Player"].Page
Instance.new("UICorner", ujBtn).CornerRadius = UDim.new(0, 6)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.9, 0, 0, 25)
fpsLabel.Position = UDim2.new(0.05, 0, 0, 110)
fpsLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextSize = 14
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0, 6)

local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(0.9, 0, 0, 25)
coordLabel.Position = UDim2.new(0.05, 0, 0, 145)
coordLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
coordLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
coordLabel.TextSize = 14
coordLabel.Font = Enum.Font.GothamBold
coordLabel.Text = "XYZ: 0,0,0"
coordLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", coordLabel).CornerRadius = UDim.new(0, 6)

-- === Optifine Tab ===
local optimizeBtn = Instance.new("TextButton")
optimizeBtn.Size = UDim2.new(0.9, 0, 0, 25)
optimizeBtn.Position = UDim2.new(0.05, 0, 0, 5)
optimizeBtn.Text = "Optimize Mode"
optimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 250)
optimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
optimizeBtn.TextSize = 14
optimizeBtn.Font = Enum.Font.GothamBold
optimizeBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", optimizeBtn).CornerRadius = UDim.new(0, 6)

local ultraBtn = Instance.new("TextButton")
ultraBtn.Size = UDim2.new(0.9, 0, 0, 25)
ultraBtn.Position = UDim2.new(0.05, 0, 0, 40)
ultraBtn.Text = "Ultra Optimize"
ultraBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
ultraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ultraBtn.TextSize = 14
ultraBtn.Font = Enum.Font.GothamBold
ultraBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", ultraBtn).CornerRadius = UDim.new(0, 6)

-- === Teleport Tab ===
local teleportPage = tabs["Teleport"].Page
local teleportList = Instance.new("Frame")
teleportList.Size = UDim2.new(1, 0, 1, -170)
teleportList.Position = UDim2.new(0, 0, 0, 160)
teleportList.BackgroundTransparency = 1
teleportList.Parent = teleportPage

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.9, 0, 0, 25)
saveBtn.Position = UDim2.new(0.05, 0, 0, 5)
saveBtn.Text = "Simpan Koordinat"
saveBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.TextSize = 14
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = teleportPage
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

local otherPlayerLabel = Instance.new("TextLabel")
otherPlayerLabel.Size = UDim2.new(0.9, 0, 0, 25)
otherPlayerLabel.Position = UDim2.new(0.05, 0, 0, 40)
otherPlayerLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
otherPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
otherPlayerLabel.TextSize = 14
otherPlayerLabel.Font = Enum.Font.GothamBold
otherPlayerLabel.Text = "Pilih Player:"
otherPlayerLabel.Parent = teleportPage
Instance.new("UICorner", otherPlayerLabel).CornerRadius = UDim.new(0, 6)

local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0.9, 0, 0, 100)
playerListFrame.Position = UDim2.new(0.05, 0, 0, 70)
playerListFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
playerListFrame.BorderSizePixel = 0
playerListFrame.Parent = teleportPage
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0,6)

local function refreshTeleportList()
    for _,child in pairs(teleportList:GetChildren()) do
        child:Destroy()
    end
    for i,coord in ipairs(savedCoords) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 25)
        btn.Position = UDim2.new(0.05, 0, 0, (i-1)*30)
        btn.Text = string.format("Teleport %d", i)
        btn.BackgroundColor3 = Color3.fromRGB(100,100,250)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
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

local function refreshPlayerList()
    for _,child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local y = 5
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 25)
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(100,100,200)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.Parent = playerListFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

            btn.MouseButton1Click:Connect(function()
                local targetChar = plr.Character
                local root = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
                if root then
                    coordLabel.Text = string.format("Target %s XYZ: %.1f, %.1f, %.1f", plr.Name, root.Position.X, root.Position.Y, root.Position.Z)
                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0,3,0))
                    end
                end
            end)

            y = y + 30
        end
    end
end

Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- === Logic Setup ===
local function setupCharacter(char)
    humanoid = char:WaitForChild("Humanoid")
    wsBox.Text = tostring(humanoid.WalkSpeed)
    jpBox.Text = tostring(humanoid.JumpPower)
    wsBtn.MouseButton1Click:Connect(function()
        local val = tonumber(wsBox.Text)
        if val then humanoid.WalkSpeed = val end
    end)
    jpBtn.MouseButton1Click:Connect(function()
        local val = tonumber(jpBox.Text)
        if val then humanoid.JumpPower = val end
    end)
    UserInputService.JumpRequest:Connect(function()
        if unlimitedJump and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

ujBtn.MouseButton1Click:Connect(function()
    unlimitedJump = not unlimitedJump
    ujBtn.Text = "Unlimited Jump: " .. (unlimitedJump and "ON" or "OFF")
    ujBtn.BackgroundColor3 = unlimitedJump and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
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
            if part:IsA("BasePart") then 
                part.Material = originalSettings[part] or part.Material 
            end
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
        Lighting.Brightness = 2
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then 
                v.Material = originalSettings[v] or v.Material 
            end
        end
        isUltraMode = false
        ultraBtn.Text = "Ultra Optimize"
        ultraBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then 
                v.Material = Enum.Material.SmoothPlastic 
            end
        end
        Lighting.GlobalShadows = false
        Lighting.Brightness = 5
        isUltraMode = true
        ultraBtn.Text = "Restore Ultra"
        ultraBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    contentFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "−"
    mainFrame.Size = isMinimized and UDim2.new(0, 350, 0, 30) or UDim2.new(0, 350, 0, 320)
end)