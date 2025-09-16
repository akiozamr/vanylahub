-- 💫 VANYLA HUB - Roblox Lua GUI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VanylaHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 440)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Drop Shadow Effect
local shadow = Instance.new("ImageLabel", mainFrame)
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.ZIndex = -1
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.4
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "💫 VANYLA HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -40, 0.5, -15)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

-- Tab Buttons
local tabContainer = Instance.new("Frame", mainFrame)
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 45)
tabContainer.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", tabContainer)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

-- Content Frame
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 10)

local tabFrames = {}
local currentVisible

-- Function buat Tab
local function createTab(name)
    local button = Instance.new("TextButton", tabContainer)
    button.Size = UDim2.new(0, 100, 1, -5)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    button.AutoButtonColor = true
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    local frame = Instance.new("Frame", contentFrame)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    button.MouseButton1Click:Connect(function()
        if currentVisible then
            currentVisible.Visible = false
        end
        frame.Visible = true
        currentVisible = frame
    end)

    if not currentVisible then
        frame.Visible = true
        currentVisible = frame
    end

    tabFrames[name] = frame
    return frame
end

-- =========================
-- PLAYER TAB
-- =========================
local playerFrame = createTab("Player")
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local function createStatControl(parent, text, getter, setter, posY, step)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0, 220, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. getter()
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local plus = Instance.new("TextButton", parent)
    plus.Size = UDim2.new(0, 30, 0, 30)
    plus.Position = UDim2.new(0, 240, 0, posY)
    plus.Text = "+"
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 16
    plus.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)

    local minus = Instance.new("TextButton", parent)
    minus.Size = UDim2.new(0, 30, 0, 30)
    minus.Position = UDim2.new(0, 280, 0, posY)
    minus.Text = "-"
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 16
    minus.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
    Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)

    plus.MouseButton1Click:Connect(function()
        setter(getter() + step)
        label.Text = text .. ": " .. getter()
    end)

    minus.MouseButton1Click:Connect(function()
        setter(getter() - step)
        label.Text = text .. ": " .. getter()
    end)
end

-- WalkSpeed & JumpPower
createStatControl(playerFrame, "WalkSpeed", function() return humanoid.WalkSpeed end, function(v) humanoid.WalkSpeed = v end, 20, 2)
createStatControl(playerFrame, "JumpPower", function() return humanoid.JumpPower end, function(v) humanoid.JumpPower = v end, 60, 5)

-- Unlimited Jump
local unlimitedJump = false
local ujButton = Instance.new("TextButton", playerFrame)
ujButton.Size = UDim2.new(0, 220, 0, 30)
ujButton.Position = UDim2.new(0, 10, 0, 100)
ujButton.Text = "Unlimited Jump: OFF"
ujButton.Font = Enum.Font.GothamBold
ujButton.TextSize = 14
ujButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ujButton.BackgroundColor3 = Color3.fromRGB(80, 130, 200)
Instance.new("UICorner", ujButton).CornerRadius = UDim.new(0, 6)

ujButton.MouseButton1Click:Connect(function()
    unlimitedJump = not unlimitedJump
    ujButton.Text = "Unlimited Jump: " .. (unlimitedJump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
    if unlimitedJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- =========================
-- OPTIFINE TAB
-- =========================
local optifineFrame = createTab("Optifine")
local optLabel = Instance.new("TextLabel", optifineFrame)
optLabel.Size = UDim2.new(1, 0, 0, 30)
optLabel.Text = "Belum ada fitur Optifine"
optLabel.BackgroundTransparency = 1
optLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- =========================
-- TELEPORT TAB
-- =========================
local teleportFrame = createTab("Teleport")
local inputUser = Instance.new("TextBox", teleportFrame)
inputUser.Size = UDim2.new(0, 220, 0, 30)
inputUser.Position = UDim2.new(0, 10, 0, 20)
inputUser.PlaceholderText = "Masukkan Username"
inputUser.Text = ""
Instance.new("UICorner", inputUser).CornerRadius = UDim.new(0, 6)

local tpButton = Instance.new("TextButton", teleportFrame)
tpButton.Size = UDim2.new(0, 100, 0, 30)
tpButton.Position = UDim2.new(0, 240, 0, 20)
tpButton.Text = "Teleport"
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 14
tpButton.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)

tpButton.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(inputUser.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(target.Character.HumanoidRootPart.Position)
    end
end)

-- Save & Teleport Koordinat
local savedPos

local saveBtn = Instance.new("TextButton", teleportFrame)
saveBtn.Size = UDim2.new(0, 150, 0, 30)
saveBtn.Position = UDim2.new(0, 10, 0, 60)
saveBtn.Text = "Save Koordinat"
saveBtn.BackgroundColor3 = Color3.fromRGB(80, 130, 200)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

local tpCoordBtn = Instance.new("TextButton", teleportFrame)
tpCoordBtn.Size = UDim2.new(0, 150, 0, 30)
tpCoordBtn.Position = UDim2.new(0, 170, 0, 60)
tpCoordBtn.Text = "Teleport Koordinat"
tpCoordBtn.BackgroundColor3 = Color3.fromRGB(200, 130, 80)
tpCoordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", tpCoordBtn).CornerRadius = UDim.new(0, 6)

saveBtn.MouseButton1Click:Connect(function()
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.Position
        saveBtn.Text = "Saved!"
        task.wait(1)
        saveBtn.Text = "Save Koordinat"
    end
end)

tpCoordBtn.MouseButton1Click:Connect(function()
    if savedPos then
        char:MoveTo(savedPos)
    end
end)

-- =========================
-- Minimize Function
-- =========================
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentFrame.Visible = not minimized
    tabContainer.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 440)
    minBtn.Text = minimized and "+" or "-"
end)
