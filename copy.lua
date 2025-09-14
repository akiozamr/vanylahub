local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CopyAnim"
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
title.Size = UDim2.new(1, -36, 0, 28)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
title.Text = "Copy Animation"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame
title.Padding = nil

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -36, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = mainFrame
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -6, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local contentHolder = Instance.new("Frame")
contentHolder.Size = UDim2.new(1, 0, 0, 62)
contentHolder.Position = UDim2.new(0, 0, 0, 28)
contentHolder.BackgroundTransparency = 1
contentHolder.Parent = mainFrame

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.9, 0, 0, 40)
copyBtn.Position = UDim2.new(0.05, 0, 0, 12)
copyBtn.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
copyBtn.Text = "Ambil Animasi reyyxvnnn"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 12
copyBtn.Parent = contentHolder
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)

local isMinimized = false
local originalSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    if not isMinimized then
        contentHolder.Visible = false
        mainFrame.Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, 28)
        minimizeBtn.Text = "▢"
        isMinimized = true
    else
        contentHolder.Visible = true
        mainFrame.Size = originalSize
        minimizeBtn.Text = "_"
        isMinimized = false
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local function copyAnimationsFrom(targetUsername)
    local targetPlayer = Players:FindFirstChild(targetUsername)
    if not targetPlayer then
        for _, pl in pairs(Players:GetPlayers()) do
            if pl.Name:lower() == targetUsername:lower() then
                targetPlayer = pl
                break
            end
        end
    end
    if not targetPlayer then return end
    local targetChar = targetPlayer.Character
    if not targetChar then
        local con
        con = targetPlayer.CharacterAdded:Connect(function()
            con:Disconnect()
            copyAnimationsFrom(targetUsername)
        end)
        return
    end
    local targetAnimate = targetChar:FindFirstChild("Animate")
    local myChar = player.Character or player.CharacterAdded:Wait()
    local myAnimate = myChar:FindFirstChild("Animate")
    if targetAnimate and myAnimate then
        for _, anim in pairs(myAnimate:GetChildren()) do
            if anim:IsA("StringValue") and targetAnimate:FindFirstChild(anim.Name) then
                anim.Value = targetAnimate[anim.Name].Value
            end
        end
    end
end

copyBtn.MouseButton1Click:Connect(function()
    copyAnimationsFrom("reyyxvnnn")
end)
