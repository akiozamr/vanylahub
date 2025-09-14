local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopyAvatar"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 110)
mainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -32, 1, 0)
title.Position = UDim2.new(0, 6, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Copy Avatar"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 1, 0)
minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

-- content holder
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 0, 72)
content.Position = UDim2.new(0, 6, 0, 34)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local userBox = Instance.new("TextBox")
userBox.Size = UDim2.new(1, 0, 0, 30)
userBox.Position = UDim2.new(0, 0, 0, 0)
userBox.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
userBox.PlaceholderText = "Masukkan username"
userBox.Text = ""
userBox.TextColor3 = Color3.fromRGB(255, 255, 255)
userBox.Font = Enum.Font.Gotham
userBox.TextSize = 12
userBox.Parent = content
Instance.new("UICorner", userBox).CornerRadius = UDim.new(0, 8)

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(1, 0, 0, 30)
applyBtn.Position = UDim2.new(0, 0, 0, 38)
applyBtn.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
applyBtn.Text = "Apply"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 12
applyBtn.Parent = content
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 8)

-- minimize toggle
local isMinimized = false
local originalSize = mainFrame.Size
minimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        content.Visible = true
        mainFrame.Size = originalSize
        minimizeBtn.Text = "-"
    else
        content.Visible = false
        mainFrame.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 28)
        minimizeBtn.Text = "+"
    end
    isMinimized = not isMinimized
end)

-- fungsi copy animasi
local function copyAnimationsFrom(targetUsername)
    local targetPlayer = Players:FindFirstChild(targetUsername)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetAnimate = targetPlayer.Character:FindFirstChild("Animate")
    local myChar = player.Character or player.CharacterAdded:Wait()
    local myAnimate = myChar:FindFirstChild("Animate")
    if targetAnimate and myAnimate then
        for _, anim in pairs(myAnimate:GetChildren()) do
            local targetAnim = targetAnimate:FindFirstChild(anim.Name)
            if targetAnim then
                if anim:IsA("StringValue") and targetAnim:IsA("StringValue") then
                    anim.Value = targetAnim.Value
                elseif anim:IsA("Animation") and targetAnim:IsA("Animation") then
                    anim.AnimationId = targetAnim.AnimationId
                elseif anim:IsA("StringValue") and targetAnim:IsA("Animation") then
                    anim.Value = targetAnim.AnimationId
                end
            end
        end
    end
end

-- apply button
applyBtn.MouseButton1Click:Connect(function()
    local name = userBox.Text
    if name and name ~= "" then
        copyAnimationsFrom(name)
    end
end)
