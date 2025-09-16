-- load Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- respawn handler
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

-- variabel fitur
local unlimitedJump = false
local isOptimized = false
local isUltraMode = false
local fps, lastTime, frameCount = 0, tick(), 0

-- Orion window
local Window = OrionLib:MakeWindow({
    Name = "Vanyla Hub",
    HidePremium = false,
    SaveConfig = false
})

-- === Player Tab ===
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddTextbox({
    Name = "WalkSpeed",
    Default = tostring(humanoid.WalkSpeed),
    TextDisappear = true,
    Callback = function(Value)
        local v = tonumber(Value)
        if v and humanoid and humanoid.Parent then
            humanoid.WalkSpeed = v
        end
    end
})

PlayerTab:AddTextbox({
    Name = "JumpPower",
    Default = tostring(humanoid.JumpPower),
    TextDisappear = true,
    Callback = function(Value)
        local v = tonumber(Value)
        if v and humanoid and humanoid.Parent then
            humanoid.JumpPower = v
        end
    end
})

PlayerTab:AddToggle({
    Name = "Unlimited Jump",
    Default = false,
    Callback = function(Value)
        unlimitedJump = Value
    end
})

local FpsLabel = PlayerTab:AddLabel("FPS: 0")
local CoordLabel = PlayerTab:AddLabel("XYZ: 0,0,0")

-- === Optifine Tab ===
local OptTab = Window:MakeTab({
    Name = "Optifine",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

OptTab:AddButton({
    Name = "Optimize Mode",
    Callback = function()
        if isOptimized then return end
        isOptimized = true
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                if obj:FindFirstChildOfClass("SurfaceAppearance") then
                    obj:FindFirstChildOfClass("SurfaceAppearance"):Destroy()
                end
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Enabled = false
            elseif obj:IsA("Highlight") then
                obj.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000
    end
})

OptTab:AddButton({
    Name = "Ultra Optimize",
    Callback = function()
        if isUltraMode then return end
        isUltraMode = true
        Lighting.Technology = Enum.Technology.Legacy
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.fromRGB(178,178,178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178,178,178)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("Atmosphere") then
                obj.Density, obj.Offset, obj.Glare, obj.Haze = 0,0,0,0
            elseif obj:IsA("Clouds") then
                obj.Enabled = false
            elseif obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                obj.Enabled = false
            elseif obj:IsA("Highlight") then
                obj.Enabled = false
            elseif obj:IsA("SurfaceAppearance") then
                obj:Destroy()
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end
    end
})

-- === Teleport Tab ===
local TpTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

TpTab:AddTextbox({
    Name = "Coordinates (x,y,z)",
    Default = "0,0,0",
    TextDisappear = true,
    Callback = function(Value)
        if character and character:FindFirstChild("HumanoidRootPart") then
            local coords = {}
            for c in string.gmatch(Value,"[^,]+") do
                table.insert(coords,tonumber(c))
            end
            if #coords == 3 then
                character.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2]+10, coords[3])
            end
        end
    end
})

-- === Unlimited Jump Handler ===
UserInputService.JumpRequest:Connect(function()
    if unlimitedJump and humanoid and humanoid.Parent then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- === FPS & Coords updater ===
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount, lastTime = 0, now
        FpsLabel:Set("FPS: " .. fps)
    end
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        CoordLabel:Set(string.format("XYZ: %.1f, %.1f, %.1f", pos.X,pos.Y,pos.Z))
    end
end)

-- finish Orion
OrionLib:Init()
