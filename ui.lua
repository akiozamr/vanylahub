-- GUI Script (Roblox Lua)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Buat ScreenGui
local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
screenGui.Name = "CustomMenu"

-- Buat Frame Utama
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- Tab Button
local tabs = {"Player", "Optifine", "Teleport"}
local tabFrames = {}

for i, name in ipairs(tabs) do
    local button = Instance.new("TextButton", mainFrame)
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Position = UDim2.new(0, (i-1)*100, 0, 0)
    button.Text = name

    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, 0, 1, -30)
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    contentFrame.Visible = (i == 1) -- default Player tab aktif

    tabFrames[name] = contentFrame

    button.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do
            f.Visible = false
        end
        contentFrame.Visible = true
    end)
end

-- =========================
-- PLAYER MENU
-- =========================
local playerFrame = tabFrames["Player"]
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- WalkSpeed
local wsLabel = Instance.new("TextLabel", playerFrame)
wsLabel.Size = UDim2.new(0, 200, 0, 30)
wsLabel.Position = UDim2.new(0, 10, 0, 10)
wsLabel.Text = "WalkSpeed: " .. humanoid.WalkSpeed

local wsPlus = Instance.new("TextButton", playerFrame)
wsPlus.Size = UDim2.new(0, 30, 0, 30)
wsPlus.Position = UDim2.new(0, 220, 0, 10)
wsPlus.Text = "+"

local wsMinus = Instance.new("TextButton", playerFrame)
wsMinus.Size = UDim2.new(0, 30, 0, 30)
wsMinus.Position = UDim2.new(0, 260, 0, 10)
wsMinus.Text = "-"

wsPlus.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = humanoid.WalkSpeed + 2
    wsLabel.Text = "WalkSpeed: " .. humanoid.WalkSpeed
end)

wsMinus.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = humanoid.WalkSpeed - 2
    wsLabel.Text = "WalkSpeed: " .. humanoid.WalkSpeed
end)

-- JumpPower
local jpLabel = Instance.new("TextLabel", playerFrame)
jpLabel.Size = UDim2.new(0, 200, 0, 30)
jpLabel.Position = UDim2.new(0, 10, 0, 50)
jpLabel.Text = "JumpPower: " .. humanoid.JumpPower

local jpPlus = Instance.new("TextButton", playerFrame)
jpPlus.Size = UDim2.new(0, 30, 0, 30)
jpPlus.Position = UDim2.new(0, 220, 0, 50)
jpPlus.Text = "+"

local jpMinus = Instance.new("TextButton", playerFrame)
jpMinus.Size = UDim2.new(0, 30, 0, 30)
jpMinus.Position = UDim2.new(0, 260, 0, 50)
jpMinus.Text = "-"

jpPlus.MouseButton1Click:Connect(function()
    humanoid.JumpPower = humanoid.JumpPower + 5
    jpLabel.Text = "JumpPower: " .. humanoid.JumpPower
end)

jpMinus.MouseButton1Click:Connect(function()
    humanoid.JumpPower = humanoid.JumpPower - 5
    jpLabel.Text = "JumpPower: " .. humanoid.JumpPower
end)

-- Unlimited Jump
local unlimitedJump = false
local ujButton = Instance.new("TextButton", playerFrame)
ujButton.Size = UDim2.new(0, 200, 0, 30)
ujButton.Position = UDim2.new(0, 10, 0, 90)
ujButton.Text = "Unlimited Jump: OFF"

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
-- OPTIFINE MENU (kosong)
-- =========================
local optifineFrame = tabFrames["Optifine"]
local label = Instance.new("TextLabel", optifineFrame)
label.Size = UDim2.new(1, 0, 0, 30)
label.Text = "Belum ada fitur Optifine"

-- =========================
-- TELEPORT MENU
-- =========================
local teleportFrame = tabFrames["Teleport"]

-- Teleport ke Player
local inputUser = Instance.new("TextBox", teleportFrame)
inputUser.Size = UDim2.new(0, 200, 0, 30)
inputUser.Position = UDim2.new(0, 10, 0, 10)
inputUser.PlaceholderText = "Masukkan Username"

local tpButton = Instance.new("TextButton", teleportFrame)
tpButton.Size = UDim2.new(0, 80, 0, 30)
tpButton.Position = UDim2.new(0, 220, 0, 10)
tpButton.Text = "Teleport"

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

local tpCoordBtn = Instance.new("TextButton", teleportFrame)
tpCoordBtn.Size = UDim2.new(0, 140, 0, 30)
tpCoordBtn.Position = UDim2.new(0, 160, 0, 50)
tpCoordBtn.Text = "Teleport Koordinat"

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
