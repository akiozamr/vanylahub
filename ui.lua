local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

local unlimitedJump = false
local isOptimized, isUltraMode = false, false
local optimizedParts = {}

-- Orion Library
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "VANYLA HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "VanylaHub"
})

-- Tab Player
local TabPlayer = Window:MakeTab({Name="Player", Icon="rbxassetid://4483345998"})
local wsBox, jpBox

TabPlayer:AddTextbox({
    Name = "WalkSpeed",
    Default = tostring(humanoid.WalkSpeed),
    TextDisappear = false,
    Callback = function(v)
        local num = tonumber(v)
        if num then humanoid.WalkSpeed = num end
    end
})

TabPlayer:AddTextbox({
    Name = "JumpPower",
    Default = tostring(humanoid.JumpPower),
    TextDisappear = false,
    Callback = function(v)
        local num = tonumber(v)
        if num then humanoid.JumpPower = num end
    end
})

TabPlayer:AddToggle({
    Name = "Unlimited Jump",
    Default = false,
    Callback = function(Value)
        unlimitedJump = Value
    end
})

TabPlayer:AddLabel("FPS: 0")
local fpsLabel = TabPlayer:AddLabel("XYZ: 0,0,0")

-- Tab Optifine
local TabOpti = Window:MakeTab({Name="Optifine", Icon="rbxassetid://4483345998"})

TabOpti:AddButton({
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
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e6
    end
})

TabOpti:AddButton({
    Name = "Ultra Optimize",
    Callback = function()
        if isUltraMode then return end
        isUltraMode = true
        Lighting.Technology = Enum.Technology.Legacy
        Lighting.Brightness = 5
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") then
                obj.Enabled = false
            elseif obj:IsA("SurfaceAppearance") then
                obj:Destroy()
            end
        end
    end
})

TabOpti:AddToggle({
    Name = "Night Vision",
    Default = false,
    Callback = function(v)
        if v then
            local nv = Instance.new("ColorCorrectionEffect", Lighting)
            nv.Name = "NV"
            nv.Brightness, nv.Contrast, nv.Saturation = 0.2,0.3,1
            nv.TintColor = Color3.fromRGB(200,255,200)
        else
            if Lighting:FindFirstChild("NV") then Lighting.NV:Destroy() end
        end
    end
})

-- Tab Teleport
local TabTP = Window:MakeTab({Name="Teleport", Icon="rbxassetid://4483345998"})

TabTP:AddTextbox({
    Name = "Coords (x,y,z)",
    Default = "",
    TextDisappear = false,
    Callback = function(v)
        local coords = {}
        for c in string.gmatch(v,"[^,]+") do
            table.insert(coords, tonumber(c))
        end
        if #coords == 3 and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2]+5, coords[3])
        end
    end
})

-- FPS Counter + Coordinates Update
local fps, frameCount, lastTime = 0,0,tick()
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount, lastTime = 0, now
        TabPlayer:AddLabel("FPS: "..fps) -- refresh fps
    end
    if character and character:FindFirstChild("HumanoidRootPart") then
        local pos = character.HumanoidRootPart.Position
        fpsLabel:Set(string.format("XYZ: %.1f, %.1f, %.1f", pos.X,pos.Y,pos.Z))
    end
end)

-- Unlimited Jump
UserInputService.JumpRequest:Connect(function()
    if unlimitedJump and humanoid and humanoid.Parent then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

OrionLib:Init()
