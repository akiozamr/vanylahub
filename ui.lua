-- 💫 VANYLA HUB
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local savedCFrame = nil
local minimized = false

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 330, 0, 370)
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "💫 VANYLA HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 50, 0, 25)
minimizeBtn.Position = UDim2.new(1, -55, 0.5, -12)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

-- Tabs
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 35)
tabFrame.Position = UDim2.new(0, 0, 0, 35)
tabFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tabFrame.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout", tabFrame)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = tabFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local playerTab = createTab("Player")
local optifineTab = createTab("Optifine")
local teleportTab = createTab("Teleport")

-- Content
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -70)
content.Position = UDim2.new(0, 0, 0, 70)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local pages = {}

local function createPage(name)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    local layout = Instance.new("UIListLayout", page)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    local padding = Instance.new("UIPadding", page)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingTop = UDim.new(0, 5)

    pages[name] = page
    return page
end

local playerPage = createPage("Player")
local optifinePage = createPage("Optifine")
local teleportPage = createPage("Teleport")

-- Fungsi Tab
local function showPage(name)
    for _, page in pairs(pages) do
        page.Visible = false
    end
    pages[name].Visible = true
end
showPage("Player")

playerTab.MouseButton1Click:Connect(function() showPage("Player") end)
optifineTab.MouseButton1Click:Connect(function() showPage("Optifine") end)
teleportTab.MouseButton1Click:Connect(function() showPage("Teleport") end)

-- === Player Page ===
local function createLabel(text, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function createButtonRow(parent, labels)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local layout = Instance.new("UIListLayout", frame)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, 5)

    for _, text in ipairs(labels) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 40, 1, 0)
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    end

    return frame
end

-- WalkSpeed Control
local walkLabel = createLabel("WalkSpeed: " .. player.Character.Humanoid.WalkSpeed, playerPage)
local walkFrame = createButtonRow(playerPage, {"+", "-"})
local plusWalk, minusWalk = walkFrame:GetChildren()[2], walkFrame:GetChildren()[3]

plusWalk.MouseButton1Click:Connect(function()
    player.Character.Humanoid.WalkSpeed += 2
    walkLabel.Text = "WalkSpeed: " .. player.Character.Humanoid.WalkSpeed
end)
minusWalk.MouseButton1Click:Connect(function()
    player.Character.Humanoid.WalkSpeed -= 2
    walkLabel.Text = "WalkSpeed: " .. player.Character.Humanoid.WalkSpeed
end)

-- Jump Control
local jumpLabel = createLabel("JumpPower: " .. player.Character.Humanoid.JumpPower, playerPage)
local jumpFrame = createButtonRow(playerPage, {"+", "-"})
local plusJump, minusJump = jumpFrame:GetChildren()[2], jumpFrame:GetChildren()[3]

plusJump.MouseButton1Click:Connect(function()
    player.Character.Humanoid.JumpPower += 5
    jumpLabel.Text = "JumpPower: " .. player.Character.Humanoid.JumpPower
end)
minusJump.MouseButton1Click:Connect(function()
    player.Character.Humanoid.JumpPower -= 5
    jumpLabel.Text = "JumpPower: " .. player.Character.Humanoid.JumpPower
end)

-- Unlimited Jump
local unliJumpBtn = Instance.new("TextButton")
unliJumpBtn.Size = UDim2.new(1, -20, 0, 30)
unliJumpBtn.Text = "Unlimited Jump"
unliJumpBtn.Font = Enum.Font.Gotham
unliJumpBtn.TextSize = 14
unliJumpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
unliJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
unliJumpBtn.Parent = playerPage
Instance.new("UICorner", unliJumpBtn).CornerRadius = UDim.new(0, 6)

local unliJump = false
unliJumpBtn.MouseButton1Click:Connect(function()
    unliJump = not unliJump
    unliJumpBtn.Text = "Unlimited Jump: " .. tostring(unliJump)
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if unliJump and player.Character then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- === Teleport Page ===
local tpBox = Instance.new("TextBox")
tpBox.Size = UDim2.new(1, -20, 0, 30)
tpBox.PlaceholderText = "Username"
tpBox.Text = ""
tpBox.Font = Enum.Font.Gotham
tpBox.TextSize = 14
tpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBox.Parent = teleportPage
Instance.new("UICorner", tpBox).CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -20, 0, 30)
tpBtn.Text = "Teleport to Player"
tpBtn.Font = Enum.Font.Gotham
tpBtn.TextSize = 14
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Parent = teleportPage
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

tpBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(tpBox.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
    end
end)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -20, 0, 30)
saveBtn.Text = "Save Coordinate"
saveBtn.Font = Enum.Font.Gotham
saveBtn.TextSize = 14
saveBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Parent = teleportPage
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)

saveBtn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = player.Character.HumanoidRootPart.CFrame
    end
end)

local loadBtn = Instance.new("TextButton")
loadBtn.Size = UDim2.new(1, -20, 0, 30)
loadBtn.Text = "Teleport to Saved Coordinate"
loadBtn.Font = Enum.Font.Gotham
loadBtn.TextSize = 14
loadBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
loadBtn.Parent = teleportPage
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)

loadBtn.MouseButton1Click:Connect(function()
    if savedCFrame then
        player.Character:PivotTo(savedCFrame)
    end
end)

-- === Minimize ===
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        content.Visible = false
        tabFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 330, 0, 40)
        minimizeBtn.Text = "+"
    else
        content.Visible = true
        tabFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 330, 0, 370)
        minimizeBtn.Text = "-"
    end
end)
