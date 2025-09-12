local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

local unlimitedJump = false
local isOptimized = false
local isUltraMode = false
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

local optBtn = Instance.new("TextButton")
optBtn.Size = UDim2.new(0.9, 0, 0, 25)
optBtn.Position = UDim2.new(0.05, 0, 0, 5)
optBtn.Text = "Optimize Mode"
optBtn.BackgroundColor3 = Color3.fromRGB(100,200,100)
optBtn.TextColor3 = Color3.fromRGB(255,255,255)
optBtn.TextSize = 14
optBtn.Font = Enum.Font.GothamBold
optBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0,6)

local ultraBtn = Instance.new("TextButton")
ultraBtn.Size = UDim2.new(0.9, 0, 0, 25)
ultraBtn.Position = UDim2.new(0.05, 0, 0, 40)
ultraBtn.Text = "Ultra Boost"
ultraBtn.BackgroundColor3 = Color3.fromRGB(200,100,100)
ultraBtn.TextColor3 = Color3.fromRGB(255,255,255)
ultraBtn.TextSize = 14
ultraBtn.Font = Enum.Font.GothamBold
ultraBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", ultraBtn).CornerRadius = UDim.new(0,6)

local nightBtn = Instance.new("TextButton")
nightBtn.Size = UDim2.new(0.9, 0, 0, 25)
nightBtn.Position = UDim2.new(0.05, 0, 0, 75)
nightBtn.Text = "Night Vision: OFF"
nightBtn.BackgroundColor3 = Color3.fromRGB(80,80,180)
nightBtn.TextColor3 = Color3.fromRGB(255,255,255)
nightBtn.TextSize = 14
nightBtn.Font = Enum.Font.GothamBold
nightBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", nightBtn).CornerRadius = UDim.new(0,6)

local tagBtn = Instance.new("TextButton")
tagBtn.Size = UDim2.new(0.9, 0, 0, 25)
tagBtn.Position = UDim2.new(0.05, 0, 0, 110)
tagBtn.Text = "Hide NameTags: OFF"
tagBtn.BackgroundColor3 = Color3.fromRGB(180,120,80)
tagBtn.TextColor3 = Color3.fromRGB(255,255,255)
tagBtn.TextSize = 14
tagBtn.Font = Enum.Font.GothamBold
tagBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", tagBtn).CornerRadius = UDim.new(0,6)

local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0.9, 0, 0, 25)
hideBtn.Position = UDim2.new(0.05, 0, 0, 145)
hideBtn.Text = "Hide Players: OFF"
hideBtn.BackgroundColor3 = Color3.fromRGB(120,120,120)
hideBtn.TextColor3 = Color3.fromRGB(255,255,255)
hideBtn.TextSize = 14
hideBtn.Font = Enum.Font.GothamBold
hideBtn.Parent = tabs["Optifine"].Page
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,6)

local tpBox = Instance.new("TextBox")
tpBox.Size = UDim2.new(0.9, 0, 0, 25)
tpBox.Position = UDim2.new(0.05, 0, 0, 5)
tpBox.PlaceholderText = "x, y, z"
tpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBox.TextSize = 14
tpBox.Font = Enum.Font.Gotham
tpBox.Parent = tabs["Teleport"].Page
Instance.new("UICorner", tpBox).CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 25)
tpBtn.Position = UDim2.new(0.05, 0, 0, 40)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.TextSize = 14
tpBtn.Font = Enum.Font.GothamBold
tpBtn.Parent = tabs["Teleport"].Page
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.9, 0, 0, 25)
saveBtn.Position = UDim2.new(0.05, 0, 0, 75)
saveBtn.Text = "Save Current Position"
saveBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.TextSize = 14
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = tabs["Teleport"].Page
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(0.9, 0, 0, 25)
loadBtn.Position = UDim2.new(0.05, 0, 0, 110)
loadBtn.Text = "Load Saved Position"
loadBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 100)
loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadBtn.TextSize = 14
loadBtn.Font = Enum.Font.GothamBold
loadBtn.Parent = tabs["Teleport"].Page
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)

wsBtn.MouseButton1Click:Connect(function()
    local v = tonumber(wsBox.Text)
    if v then humanoid.WalkSpeed = v end
end)

jpBtn.MouseButton1Click:Connect(function()
    local v = tonumber(jpBox.Text)
    if v then humanoid.JumpPower = v end
end)

ujBtn.MouseButton1Click:Connect(function()
    unlimitedJump = not unlimitedJump
    ujBtn.Text = "Unlimited Jump: " .. (unlimitedJump and "ON" or "OFF")
    ujBtn.BackgroundColor3 = unlimitedJump and Color3.fromRGB(100,200,100) or Color3.fromRGB(200,100,100)
end)

UserInputService.JumpRequest:Connect(function()
    if unlimitedJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    frameCount += 1
    if tick() - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = tick()
        fpsLabel.Text = "FPS: "..fps
    end
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        coordLabel.Text = string.format("XYZ: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        local coords = string.split(tpBox.Text, ",")
        if #coords == 3 then
            local x,y,z = tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3])
            if x and y and z then
                character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
            end
        end
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") then
        savedCoords = character.HumanoidRootPart.Position
    end
end)

loadBtn.MouseButton1Click:Connect(function()
    if character and character:FindFirstChild("HumanoidRootPart") and savedCoords then
        character.HumanoidRootPart.CFrame = CFrame.new(savedCoords)
    end
end)

local function optimizeGame(enable)
    if enable then
        optimizedParts = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Transparency < 0.5 then
                table.insert(optimizedParts, {Part=obj, Transparency=obj.Transparency, Material=obj.Material})
                obj.Transparency = 0.5
                obj.Material = Enum.Material.SmoothPlastic
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Parent = nil
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100
        isOptimized = true
    else
        for _, data in ipairs(optimizedParts) do
            if data.Part and data.Part.Parent then
                data.Part.Transparency = data.Transparency
                data.Part.Material = data.Material
            end
        end
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        isOptimized = false
    end
end

local function ultraBoost(enable)
    if enable then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                    elseif part:IsA("Decal") or part:IsA("Texture") then
                        part.Transparency = 1
                    end
                end
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 50
        isUltraMode = true
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                for _, part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                    elseif part:IsA("Decal") or part:IsA("Texture") then
                        part.Transparency = 0
                    end
                end
            end
        end
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        isUltraMode = false
    end
end

optBtn.MouseButton1Click:Connect(function()
    isOptimized = not isOptimized
    optimizeGame(isOptimized)
    optBtn.Text = "Optimize Mode: " .. (isOptimized and "ON" or "OFF")
end)

ultraBtn.MouseButton1Click:Connect(function()
    isUltraMode = not isUltraMode
    ultraBoost(isUltraMode)
    ultraBtn.Text = "Ultra Boost: " .. (isUltraMode and "ON" or "OFF")
    ultraBtn.BackgroundColor3 = isUltraMode and Color3.fromRGB(100,200,100) or Color3.fromRGB(200,100,100)
end)

nightBtn.MouseButton1Click:Connect(function()
    if Lighting.Ambient == Color3.fromRGB(255,255,255) then
        Lighting.Ambient = Color3.fromRGB(0,0,0)
        nightBtn.Text = "Night Vision: OFF"
    else
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        nightBtn.Text = "Night Vision: ON"
    end
end)

tagBtn.MouseButton1Click:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            if head:FindFirstChild("Nametag") then
                head.Nametag.Enabled = not head.Nametag.Enabled
            end
        end
    end
end)

local hidePlayers = false
hideBtn.MouseButton1Click:Connect(function()
    hidePlayers = not hidePlayers
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = hidePlayers and 1 or 0
                elseif part:IsA("Decal") or part:IsA("Texture") then
                    part.Transparency = hidePlayers and 1 or 0
                end
            end
        end
    end
    hideBtn.Text = "Hide Players: " .. (hidePlayers and "ON" or "OFF")
end)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    contentFrame.Visible = not isMinimized
    tabFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "−"
end)