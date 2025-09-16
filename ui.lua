-- VANYLA HUB
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanylaHub"
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💫 VANYLA HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Tombol Minimize
local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 30, 0, 30)
Minimize.Position = UDim2.new(1, -30, 0, 0)
Minimize.Text = "-"
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Minimize.Parent = MainFrame

-- Konten Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Tab Holder
local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, 0, 0, 30)
TabHolder.Position = UDim2.new(0, 0, 0, 0)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = Content

-- Fungsi Buat Tab
local function createTab(name, order)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 90, 0, 25)
    button.Position = UDim2.new(0, (order - 1) * 95, 0, 0)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Parent = TabHolder
    return button
end

-- Halaman
local Pages = {}

local function createPage(name)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, -40)
    page.Position = UDim2.new(0, 0, 0, 35)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = Content
    Pages[name] = page
    return page
end

-- === Tab ===
local playerTab = createTab("Player", 1)
local optifineTab = createTab("Optifine", 2)
local teleportTab = createTab("Teleport", 3)

-- === Page ===
local playerPage = createPage("Player")
local optifinePage = createPage("Optifine")
local teleportPage = createPage("Teleport")

-- Fungsi Switch Page
local function switchPage(name)
    for _, p in pairs(Pages) do
        p.Visible = false
    end
    Pages[name].Visible = true
end

-- Default Page
switchPage("Player")

-- Tab Event
playerTab.MouseButton1Click:Connect(function() switchPage("Player") end)
optifineTab.MouseButton1Click:Connect(function() switchPage("Optifine") end)
teleportTab.MouseButton1Click:Connect(function() switchPage("Teleport") end)

-- Minimize Toggle
local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 300, 0, 40)
        Minimize.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 300, 0, 250)
        Minimize.Text = "-"
    end
end)

-- === Isi Player Page ===
local walkLabel = Instance.new("TextLabel")
walkLabel.Size = UDim2.new(0, 200, 0, 25)
walkLabel.Position = UDim2.new(0, 10, 0, 10)
walkLabel.BackgroundTransparency = 1
walkLabel.Text = "WalkSpeed: " .. player.Character.Humanoid.WalkSpeed
walkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
walkLabel.Font = Enum.Font.Gotham
walkLabel.TextSize = 14
walkLabel.TextXAlignment = Enum.TextXAlignment.Left
walkLabel.Parent = playerPage

local plusWalk = Instance.new("TextButton")
plusWalk.Size = UDim2.new(0, 30, 0, 25)
plusWalk.Position = UDim2.new(0, 220, 0, 10)
plusWalk.Text = "+"
plusWalk.Font = Enum.Font.GothamBold
plusWalk.TextSize = 18
plusWalk.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
plusWalk.TextColor3 = Color3.fromRGB(255, 255, 255)
plusWalk.Parent = playerPage

local minusWalk = plusWalk:Clone()
minusWalk.Text = "-"
minusWalk.Position = UDim2.new(0, 260, 0, 10)
minusWalk.Parent = playerPage

plusWalk.MouseButton1Click:Connect(function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = hum.WalkSpeed + 2
        walkLabel.Text = "WalkSpeed: " .. hum.WalkSpeed
    end
end)

minusWalk.MouseButton1Click:Connect(function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = hum.WalkSpeed - 2
        walkLabel.Text = "WalkSpeed: " .. hum.WalkSpeed
    end
end)

-- Unlimited Jump
local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0, 120, 0, 25)
jumpToggle.Position = UDim2.new(0, 10, 0, 50)
jumpToggle.Text = "Unlimited Jump: OFF"
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.TextSize = 14
jumpToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.Parent = playerPage

local unlimitedJump = false
jumpToggle.MouseButton1Click:Connect(function()
    unlimitedJump = not unlimitedJump
    jumpToggle.Text = "Unlimited Jump: " .. (unlimitedJump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
    if unlimitedJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- === Teleport Page ===
local tpBox = Instance.new("TextBox")
tpBox.Size = UDim2.new(0, 180, 0, 25)
tpBox.Position = UDim2.new(0, 10, 0, 10)
tpBox.PlaceholderText = "Username"
tpBox.Text = ""
tpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBox.Font = Enum.Font.Gotham
tpBox.TextSize = 14
tpBox.Parent = teleportPage

local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 80, 0, 25)
tpButton.Position = UDim2.new(0, 200, 0, 10)
tpButton.Text = "Teleport"
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 14
tpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Parent = teleportPage

tpButton.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(tpBox.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
    end
end)

-- Save & Teleport Koordinat
local savedPos = nil

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0, 120, 0, 25)
saveBtn.Position = UDim2.new(0, 10, 0, 50)
saveBtn.Text = "Save Koordinat"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 14
saveBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Parent = teleportPage

local tpSavedBtn = saveBtn:Clone()
tpSavedBtn.Text = "Teleport Koordinat"
tpSavedBtn.Position = UDim2.new(0, 150, 0, 50)
tpSavedBtn.Parent = teleportPage

saveBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = player.Character.HumanoidRootPart.Position
    end
end)

tpSavedBtn.MouseButton1Click:Connect(function()
    if savedPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:MoveTo(savedPos)
    end
end)
