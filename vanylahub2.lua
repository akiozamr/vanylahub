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

local wsLabel = Instance.new("TextLabel")
wsLabel.Size = UDim2.new(0.5, -10, 0, 25)
wsLabel.Position = UDim2.new(0, 10, 0, 5)
wsLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
wsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
wsLabel.TextSize = 14
wsLabel.Font = Enum.Font.GothamBold
wsLabel.Text = "WalkSpeed: " .. humanoid.WalkSpeed
wsLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", wsLabel).CornerRadius = UDim.new(0, 6)

local wsMinus = Instance.new("TextButton")
wsMinus.Size = UDim2.new(0.2, -5, 0, 25)
wsMinus.Position = UDim2.new(0.55, 0, 0, 5)
wsMinus.Text = "-"
wsMinus.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
wsMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
wsMinus.TextSize = 18
wsMinus.Font = Enum.Font.GothamBold
wsMinus.Parent = tabs["Player"].Page
Instance.new("UICorner", wsMinus).CornerRadius = UDim.new(0, 6)

local wsPlus = Instance.new("TextButton")
wsPlus.Size = UDim2.new(0.2, -5, 0, 25)
wsPlus.Position = UDim2.new(0.75, 0, 0, 5)
wsPlus.Text = "+"
wsPlus.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
wsPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
wsPlus.TextSize = 18
wsPlus.Font = Enum.Font.GothamBold
wsPlus.Parent = tabs["Player"].Page
Instance.new("UICorner", wsPlus).CornerRadius = UDim.new(0, 6)

wsMinus.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed -= 1
    wsLabel.Text = "WalkSpeed: " .. humanoid.WalkSpeed
end)

wsPlus.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed += 1
    wsLabel.Text = "WalkSpeed: " .. humanoid.WalkSpeed
end)

local jpLabel = Instance.new("TextLabel")
jpLabel.Size = UDim2.new(0.5, -10, 0, 25)
jpLabel.Position = UDim2.new(0, 10, 0, 40)
jpLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
jpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
jpLabel.TextSize = 14
jpLabel.Font = Enum.Font.GothamBold
jpLabel.Text = "JumpPower: " .. humanoid.JumpPower
jpLabel.Parent = tabs["Player"].Page
Instance.new("UICorner", jpLabel).CornerRadius = UDim.new(0, 6)

local jpMinus = Instance.new("TextButton")
jpMinus.Size = UDim2.new(0.2, -5, 0, 25)
jpMinus.Position = UDim2.new(0.55, 0, 0, 40)
jpMinus.Text = "-"
jpMinus.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
jpMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
jpMinus.TextSize = 18
jpMinus.Font = Enum.Font.GothamBold
jpMinus.Parent = tabs["Player"].Page
Instance.new("UICorner", jpMinus).CornerRadius = UDim.new(0, 6)

local jpPlus = Instance.new("TextButton")
jpPlus.Size = UDim2.new(0.2, -5, 0, 25)
jpPlus.Position = UDim2.new(0.75, 0, 0, 40)
jpPlus.Text = "+"
jpPlus.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
jpPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
jpPlus.TextSize = 18
jpPlus.Font = Enum.Font.GothamBold
jpPlus.Parent = tabs["Player"].Page
Instance.new("UICorner", jpPlus).CornerRadius = UDim.new(0, 6)

jpMinus.MouseButton1Click:Connect(function()
    humanoid.JumpPower -= 1
    jpLabel.Text = "JumpPower: " .. humanoid.JumpPower
end)

jpPlus.MouseButton1Click:Connect(function()
    humanoid.JumpPower += 1
    jpLabel.Text = "JumpPower: " .. humanoid.JumpPower
end)