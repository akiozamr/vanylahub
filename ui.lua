-- GUI Script (Roblox Lua Modern Style)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Ujung membulat
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 10)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Custom Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 60, 0, 25)
minBtn.Position = UDim2.new(1, -65, 0.5, -12)
minBtn.Text = "-"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Tab Button Container
local tabContainer = Instance.new("Frame", mainFrame)
tabContainer.Size = UDim2.new(1, 0, 0, 35)
tabContainer.Position = UDim2.new(0, 0, 0, 35)
tabContainer.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", tabContainer)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tab Frames
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 1, -80)
contentFrame.Position = UDim2.new(0, 10, 0, 70)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 8)

local tabFrames = {}
local currentVisible

-- Function buat bikin Tab
local function createTab(name)
    local button = Instance.new("TextButton", tabContainer)
    button.Size = UDim2.new(0, 100, 1, 0)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

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
-- PLAYER MENU
-- =========================
local playerFrame = createTab("Player")
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local function createStatControl(parent, text, valueGetter, valueSetter, posY, step)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. valueGetter()
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local plus = Instance.new("TextButton", parent)
    plus.Size = UDim2.new(0, 30, 0, 30)
    plus.Position = UDim2.new(0, 220, 0, posY)
    plus.Text = "+"
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 16
    plus.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
    Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)

    local minus = Instance.new("TextButton", parent)
    minus.Size = UDim2.new(0, 30, 0, 30)
    minus.Position = UDim2.new(0, 260, 0, posY)
    minus.Text = "-"
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 16
    minus.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)

    plus.MouseButton1Click:Connect(function()
        valueSetter(valueGetter() + step)
        label.Text = text .. ": " .. valueGetter()
    end)

    minus.MouseButton1Click:Connect(function()
        valueSetter(valueGetter() - step)
        label.Text = text .. ": " .. valueGetter()
    end)
end

-- WalkSpeed
createStatControl(playerFrame, "WalkSpeed", function() return humanoid.WalkSpeed end, function(v) humanoid.WalkSpeed = v end, 10, 2)

-- JumpPower
createStatControl(playerFrame, "JumpPower", function() return humanoid.JumpPower end, function(v) humanoid.JumpPower = v end, 50, 5)

-- Unlimited Jump
local unlimitedJump = false
local ujButton = Instance.new("TextButton", playerFrame)
ujButton.Size = UDim2.new(0, 200, 0, 30)
ujButton.Position = UDim2.new(0, 10, 0, 90)
ujButton.Text = "Unlimited Jump: OFF"
ujButton.Font = Enum.Font.GothamBold
ujButton.TextSize = 14
ujButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ujButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
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
-- OPTIFINE MENU
-- =========================
local optifineFrame = createTab("Optifine")
local label = Instance.new("TextLabel", optifineFrame)
label.Size = UDim2.new(1, 0, 0, 30)
label.Text = "Belum ada fitur Optifine"
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)

-- =========================
-- TELEPORT MENU
-- =========================
local teleportFrame = createTab("Teleport")

local inputUser = Instance.new("TextBox", teleportFrame)
inputUser.Size = UDim2.new(0, 200, 0, 30)
inputUser.Position = UDim2.new(0, 10, 0, 10)
inputUser.PlaceholderText = "Masukkan Username"
inputUser.Text = ""
Instance.new("UICorner", inputUser).CornerRadius = UDim.new(0, 6)

local tpButton = Instance.new("TextButton", teleportFrame)
tpButton.Size = UDim2.new(0, 80, 0, 30)
tpButton.Position = UDim2.new(0, 220, 0, 10)
tpButton.Text = "Teleport"
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 14
tpButton.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)

tpButton.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(inputUser.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(target.Character.HumanoidRootPart.Position)
    end
end)

-- Save & Teleport ke Koordinat
local savedPos

local saveBtn = Instance.new("TextButton", teleportFrame)
saveBtn.Size = UDim2.new(0, 140, 0, 30)
saveBtn.Position = UDim2.new(0, 10, 0, 50)
saveBtn.Text = "Save Koordinat"
saveBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

local tpCoordBtn = Instance.new("TextButton", teleportFrame)
tpCoordBtn.Size = UDim2.new(0, 140, 0, 30)
tpCoordBtn.Position = UDim2.new(0, 160, 0, 50)
tpCoordBtn.Text = "Teleport Koordinat"
tpCoordBtn.BackgroundColor3 = Color3.fromRGB(200, 130, 70)
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
    mainFrame.Size = minimized and UDim2.new(0, 320, 0, 35) or UDim2.new(0, 320, 0, 420)
    minBtn.Text = minimized and "+" or "-"
end)
