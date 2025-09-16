local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VanYlaHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,30)
TitleBar.BackgroundColor3 = Color3.fromRGB(15,15,25)
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1,-50,1,0)
TitleText.Position = UDim2.new(0,5,0,0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "💫 VANYLA HUB"
TitleText.TextColor3 = Color3.fromRGB(100,200,255)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,20,0,20)
CloseBtn.Position = UDim2.new(1,-22,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,80,80)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,3)
CloseCorner.Parent = CloseBtn

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-10,1,-40)
ContentFrame.Position = UDim2.new(0,5,0,35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- WalkSpeed TextBox
local WSLabel = Instance.new("TextLabel")
WSLabel.Size = UDim2.new(0.5,-5,0,25)
WSLabel.Position = UDim2.new(0,0,0,0)
WSLabel.BackgroundTransparency = 1
WSLabel.Text = "WalkSpeed:"
WSLabel.TextColor3 = Color3.fromRGB(255,255,255)
WSLabel.Font = Enum.Font.Gotham
WSLabel.TextSize = 12
WSLabel.TextXAlignment = Enum.TextXAlignment.Left
WSLabel.Parent = ContentFrame

local WSTextbox = Instance.new("TextBox")
WSTextbox.Size = UDim2.new(0.5,-5,0,25)
WSTextbox.Position = UDim2.new(0.5,5,0,0)
WSTextbox.Text = tostring(LocalPlayer.Character.Humanoid.WalkSpeed)
WSTextbox.ClearTextOnFocus = false
WSTextbox.TextColor3 = Color3.fromRGB(0,0,0)
WSTextbox.BackgroundColor3 = Color3.fromRGB(200,200,200)
WSTextbox.Font = Enum.Font.Gotham
WSTextbox.TextSize = 12
WSTextbox.Parent = ContentFrame

WSTextbox.FocusLost:Connect(function()
    local val = tonumber(WSTextbox.Text)
    if val then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

-- JumpPower TextBox
local JPLabel = Instance.new("TextLabel")
JPLabel.Size = UDim2.new(0.5,-5,0,25)
JPLabel.Position = UDim2.new(0,0,0,35)
JPLabel.BackgroundTransparency = 1
JPLabel.Text = "JumpPower:"
JPLabel.TextColor3 = Color3.fromRGB(255,255,255)
JPLabel.Font = Enum.Font.Gotham
JPLabel.TextSize = 12
JPLabel.TextXAlignment = Enum.TextXAlignment.Left
JPLabel.Parent = ContentFrame

local JPTextbox = Instance.new("TextBox")
JPTextbox.Size = UDim2.new(0.5,-5,0,25)
JPTextbox.Position = UDim2.new(0.5,5,0,35)
JPTextbox.Text = tostring(LocalPlayer.Character.Humanoid.JumpPower)
JPTextbox.ClearTextOnFocus = false
JPTextbox.TextColor3 = Color3.fromRGB(0,0,0)
JPTextbox.BackgroundColor3 = Color3.fromRGB(200,200,200)
JPTextbox.Font = Enum.Font.Gotham
JPTextbox.TextSize = 12
JPTextbox.Parent = ContentFrame

JPTextbox.FocusLost:Connect(function()
    local val = tonumber(JPTextbox.Text)
    if val then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

-- Anti-lag Toggle
local AntiLagToggle = Instance.new("TextButton")
AntiLagToggle.Size = UDim2.new(1,0,0,30)
AntiLagToggle.Position = UDim2.new(0,0,0,70)
AntiLagToggle.BackgroundColor3 = Color3.fromRGB(50,150,250)
AntiLagToggle.Text = "ANTI-LAG: OFF"
AntiLagToggle.TextColor3 = Color3.fromRGB(255,255,255)
AntiLagToggle.Font = Enum.Font.GothamBold
AntiLagToggle.TextSize = 12
AntiLagToggle.BorderSizePixel = 0
AntiLagToggle.Parent = ContentFrame

local AntiLagEnabled = false

local function applyAntiLag()
    if not LocalPlayer.Character then return end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Brightness = obj.Brightness * 0.3
            obj.Range = math.min(obj.Range,10)
        end
    end
end

AntiLagToggle.MouseButton1Click:Connect(function()
    AntiLagEnabled = not AntiLagEnabled
    if AntiLagEnabled then
        AntiLagToggle.Text = "ANTI-LAG: ON"
        applyAntiLag()
    else
        AntiLagToggle.Text = "ANTI-LAG: OFF"
        game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
    end
end)

-- Teleport menu
local TPLabel = Instance.new("TextLabel")
TPLabel.Size = UDim2.new(1,0,0,25)
TPLabel.Position = UDim2.new(0,0,0,110)
TPLabel.BackgroundTransparency = 1
TPLabel.Text = "Teleport to Player:"
TPLabel.TextColor3 = Color3.fromRGB(255,255,255)
TPLabel.Font = Enum.Font.Gotham
TPLabel.TextSize = 12
TPLabel.TextXAlignment = Enum.TextXAlignment.Left
TPLabel.Parent = ContentFrame

local TPDropdown = Instance.new("TextButton")
TPDropdown.Size = UDim2.new(1,0,0,25)
TPDropdown.Position = UDim2.new(0,0,0,135)
TPDropdown.BackgroundColor3 = Color3.fromRGB(200,200,200)
TPDropdown.Text = "Select Player"
TPDropdown.TextColor3 = Color3.fromRGB(0,0,0)
TPDropdown.Font = Enum.Font.Gotham
TPDropdown.TextSize = 12
TPDropdown.Parent = ContentFrame

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1,0,0,150)
PlayerListFrame.Position = UDim2.new(0,0,0,160)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
PlayerListFrame.Visible = false
PlayerListFrame.Parent = ContentFrame

local function refreshPlayerList()
    for _, child in pairs(PlayerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,0,25)
            btn.Position = UDim2.new(0,5,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Text = plr.Name
            btn.Parent = PlayerListFrame
            y = y + 30

            btn.MouseButton1Click:Connect(function()
                if LocalPlayer.Character and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                end
            end)
        end
    end
end

TPDropdown.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
    refreshPlayerList()
end)

-- Morph visual
local MorphLabel = Instance.new("TextLabel")
MorphLabel.Size = UDim2.new(1,0,0,25)
MorphLabel.Position = UDim2.new(0,0,0,320)
MorphLabel.BackgroundTransparency = 1
MorphLabel.Text = "Morph to Player:"
MorphLabel.TextColor3 = Color3.fromRGB(255,255,255)
MorphLabel.Font = Enum.Font.Gotham
MorphLabel.TextSize = 12
MorphLabel.TextXAlignment = Enum.TextXAlignment.Left
MorphLabel.Parent = ContentFrame

local MorphDropdown = Instance.new("TextButton")
MorphDropdown.Size = UDim2.new(1,0,0,25)
MorphDropdown.Position = UDim2.new(0,0,0,345)
MorphDropdown.BackgroundColor3 = Color3.fromRGB(200,200,200)
MorphDropdown.Text = "Select Player"
MorphDropdown.TextColor3 = Color3.fromRGB(0,0,0)
MorphDropdown.Font = Enum.Font.Gotham
MorphDropdown.TextSize = 12
MorphDropdown.Parent = ContentFrame

local MorphListFrame = Instance.new("Frame")
MorphListFrame.Size = UDim2.new(1,0,0,150)
MorphListFrame.Position = UDim2.new(0,0,0,370)
MorphListFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
MorphListFrame.Visible = false
MorphListFrame.Parent = ContentFrame

local function refreshMorphList()
    for _, child in pairs(MorphListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    local y = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-10,0,25)
            btn.Position = UDim2.new(0,5,0,y)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Text = plr.Name
            btn.Parent = MorphListFrame
            y = y + 30

            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("Humanoid") then
                    local humDesc = plr.Character.Humanoid:GetAppliedDescription()
                    LocalPlayer.Character.Humanoid:ApplyDescription(humDesc)
                end
            end)
        end
    end
end

MorphDropdown.MouseButton1Click:Connect(function()
    MorphListFrame.Visible = not MorphListFrame.Visible
    refreshMorphList()
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
