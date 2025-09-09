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
ujBtn.Size = UDim2.new(0.9, 0, 0, 30)
ujBtn.Position = UDim2.new(0.05, 0, 0, 75)
ujBtn.Text = "Unlimited Jump: OFF"
ujBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
ujBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ujBtn.TextSize = 14
ujBtn.Font = Enum.Font.GothamBold
ujBtn.Parent = contentFrame
Instance.new("UICorner", ujBtn).CornerRadius = UDim.new(0, 8)

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.5, -5, 0, 20)
fpsLabel.Position = UDim2.new(0, 0, 0, 120)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
fpsLabel.TextSize = 12
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = contentFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.5, -5, 0, 20)
statusLabel.Position = UDim2.new(0.5, 5, 0, 120)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 10
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Right
statusLabel.Parent = contentFrame

local optimizeBtn = Instance.new("TextButton")
optimizeBtn.Size = UDim2.new(1, 0, 0, 30)
optimizeBtn.Position = UDim2.new(0, 0, 0, 145)
optimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
optimizeBtn.Text = "⚡ OPTIMIZE"
optimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
optimizeBtn.TextSize = 14
optimizeBtn.Font = Enum.Font.GothamBold
optimizeBtn.BorderSizePixel = 0
optimizeBtn.Parent = contentFrame

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.48, 0, 0, 25)
resetBtn.Position = UDim2.new(0, 0, 0, 180)
resetBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
resetBtn.Text = "RESET"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.TextSize = 11
resetBtn.Font = Enum.Font.Gotham
resetBtn.BorderSizePixel = 0
resetBtn.Parent = contentFrame

local ultraBtn = Instance.new("TextButton")
ultraBtn.Size = UDim2.new(0.48, 0, 0, 25)
ultraBtn.Position = UDim2.new(0.52, 0, 0, 180)
ultraBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
ultraBtn.Text = "ULTRA"
ultraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ultraBtn.TextSize = 11
ultraBtn.Font = Enum.Font.GothamBold
ultraBtn.BorderSizePixel = 0
ultraBtn.Parent = contentFrame

local function rgbLoop(textLabel)
    coroutine.wrap(function()
        while task.wait() do
            TweenService:Create(textLabel, TweenInfo.new(2), {TextColor3 = Color3.fromRGB(0,255,0)}):Play()
            task.wait(2)
            TweenService:Create(textLabel, TweenInfo.new(2), {TextColor3 = Color3.fromRGB(0,0,255)}):Play()
            task.wait(2)
            TweenService:Create(textLabel, TweenInfo.new(2), {TextColor3 = Color3.fromRGB(255,0,0)}):Play()
            task.wait(2)
        end
    end)()
end
rgbLoop(titleText)

wsBtn.MouseButton1Click:Connect(function()
    local v = tonumber(wsBox.Text)
    if v and v > 0 then humanoid.WalkSpeed = v else wsBox.Text = humanoid.WalkSpeed end
end)

jpBtn.MouseButton1Click:Connect(function()
    local v = tonumber(jpBox.Text)
    if v and v > 0 then humanoid.UseJumpPower, humanoid.JumpPower = true, v else jpBox.Text = humanoid.JumpPower end
end)

ujBtn.MouseButton1Click:Connect(function()
    unlimitedJump = not unlimitedJump
    ujBtn.Text = unlimitedJump and "Unlimited Jump: ON" or "Unlimited Jump: OFF"
    ujBtn.BackgroundColor3 = unlimitedJump and Color3.fromRGB(80,200,80) or Color3.fromRGB(200,80,80)
end)

UserInputService.JumpRequest:Connect(function()
    if unlimitedJump and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

RunService.Heartbeat:Connect(function()
    frameCount += 1
    local now = tick()
    if now - lastTime >= 0.5 then
        fps = frameCount / (now - lastTime)
        frameCount, lastTime = 0, now
        local c = fps>=50 and Color3.fromRGB(100,255,100) or fps>=30 and Color3.fromRGB(255,255,100) or Color3.fromRGB(255,100,100)
        fpsLabel.Text, fpsLabel.TextColor3 = ("FPS: %.0f"):format(fps), c
    end
end)

local function saveOriginal()
    originalSettings = {
        StreamingEnabled = Workspace.StreamingEnabled,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        Brightness = Lighting.Brightness,
        Technology = Lighting.Technology,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ClockTime = Lighting.ClockTime,
    }
end

local function optimize()
    if isOptimized then return end
    statusLabel.Text, statusLabel.TextColor3 = "Optimizing...", Color3.fromRGB(255,200,100)
    saveOriginal()
    Workspace.StreamingEnabled = true
    Lighting.GlobalShadows = false
    Lighting.Technology = Enum.Technology.Compatibility
    Lighting.FogEnd, Lighting.FogStart, Lighting.Brightness = 1e6, 1e6, 3
    Lighting.Ambient, Lighting.OutdoorAmbient, Lighting.ClockTime = Color3.new(.5,.5,.5), Color3.new(.5,.5,.5), 14
    Lighting.ShadowSoftness = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.TopSurface, obj.BottomSurface, obj.Material, obj.CastShadow = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth, Enum.Material.SmoothPlastic, false
            table.insert(optimizedParts, obj)
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("Atmosphere") then obj.Density, obj.Offset, obj.Glare, obj.Haze = 0,0,0,0
        elseif obj:IsA("Clouds") then obj.Enabled, obj.Density = false, 0
        elseif obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then obj.Enabled = false end
    end
    isOptimized = true
    statusLabel.Text, statusLabel.TextColor3 = "Optimized ✓", Color3.fromRGB(100,255,100)
    optimizeBtn.Text, optimizeBtn.BackgroundColor3 = "✓ OPTIMIZED", Color3.fromRGB(50,200,50)
end

local function ultra()
    if isUltraMode then return end
    statusLabel.Text, statusLabel.TextColor3 = "Ultra Mode...", Color3.fromRGB(255,150,50)
    if not isOptimized then optimize() end
    Lighting.GlobalShadows = false
    Lighting.Technology = Enum.Technology.Legacy
    Lighting.FogEnd, Lighting.FogStart, Lighting.Brightness = 1e6, 1e6, 5
    Lighting.Ambient, Lighting.OutdoorAmbient = Color3.fromRGB(178,178,178), Color3.fromRGB(178,178,178)
    for _, obj in ipairs(optimizedParts) do
        if obj and obj.Parent then obj.Material, obj.Reflectance, obj.CastShadow = Enum.Material.Plastic, 0, false end
    end
    isUltraMode = true
    statusLabel.Text, statusLabel.TextColor3 = "Ultra ✓", Color3.fromRGB(255,100,50)
    ultraBtn.Text, ultraBtn.BackgroundColor3 = "✓ ULTRA", Color3.fromRGB(255,150,50)
end

local function reset()
    statusLabel.Text, statusLabel.TextColor3 = "Resetting...", Color3.fromRGB(255,200,100)
    Workspace.StreamingEnabled = originalSettings.StreamingEnabled or false
    Lighting.GlobalShadows = originalSettings.GlobalShadows or true
    Lighting.FogEnd = originalSettings.FogEnd or 100000
    Lighting.FogStart = originalSettings.FogStart or 0
    Lighting.Brightness = originalSettings.Brightness or 1
    Lighting.Technology = originalSettings.Technology or Enum.Technology.ShadowMap
    Lighting.Ambient = originalSettings.Ambient or Color3.fromRGB(70,70,70)
    Lighting.OutdoorAmbient = originalSettings.OutdoorAmbient or Color3.fromRGB(70,70,70)
    Lighting.ClockTime = originalSettings.ClockTime or 14
    isOptimized, isUltraMode = false, false
    statusLabel.Text, statusLabel.TextColor3 = "Reset ✓", Color3.fromRGB(200,200,200)
    optimizeBtn.Text, optimizeBtn.BackgroundColor3 = "⚡ OPTIMIZE", Color3.fromRGB(50,150,250)
    ultraBtn.Text, ultraBtn.BackgroundColor3 = "ULTRA", Color3.fromRGB(255,100,50)
end

optimizeBtn.MouseButton1Click:Connect(optimize)
ultraBtn.MouseButton1Click:Connect(ultra)
resetBtn.MouseButton1Click:Connect(reset)

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    contentFrame.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "−"
    mainFrame.Size = isMinimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 280)
end)