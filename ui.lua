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
local hiddenPlayers, tagHidden = false, false

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
    Name = "VANYLA HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "VanylaHub"
})

local TabPlayer = Window:MakeTab({Name="Player", Icon="rbxassetid://4483345998"})
local coordLabel = TabPlayer:AddLabel("XYZ: 0,0,0")

TabPlayer:AddTextbox({
    Name = "WalkSpeed",
    Default = tostring(humanoid.WalkSpeed),
    TextDisappear = false,
    Callback = function(v)
        local num = tonumber(v)
        if num and humanoid and humanoid.Parent then humanoid.WalkSpeed = num end
    end
})

TabPlayer:AddTextbox({
    Name = "JumpPower",
    Default = tostring(humanoid.JumpPower),
    TextDisappear = false,
    Callback = function(v)
        local num = tonumber(v)
        if num and humanoid and humanoid.Parent then humanoid.JumpPower = num end
    end
})

TabPlayer:AddToggle({
    Name = "Unlimited Jump",
    Default = false,
    Callback = function(Value)
        unlimitedJump = Value
    end
})

local TabOpti = Window:MakeTab({Name="Optifine", Icon="rbxassetid://4483345998"})
TabOpti:AddButton({
    Name = "Optimize Mode",
    Callback = function()
        if isOptimized then return end
        isOptimized = true
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                table.insert(optimizedParts,obj)
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
        Lighting.FogEnd = 1e6
    end
})

TabOpti:AddButton({
    Name = "Ultra Optimize",
    Callback = function()
        if isUltraMode then return end
        isUltraMode = true
        if not isOptimized then
            TabOpti.Buttons["Optimize Mode"].Callback()
        end
        Lighting.GlobalShadows = false
        Lighting.Technology = Enum.Technology.Legacy
        Lighting.FogEnd, Lighting.FogStart = 1e6,1e6
        Lighting.Brightness = 5
        Lighting.Ambient = Color3.fromRGB(178,178,178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178,178,178)
        Lighting.ColorShift_Bottom = Color3.fromRGB(255,255,255)
        Lighting.ColorShift_Top = Color3.fromRGB(255,255,255)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
            settings().Rendering.GraphicsMode = Enum.GraphicsMode.Direct3D9
        end)
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("Atmosphere") then
                obj.Density,obj.Offset,obj.Glare,obj.Haze=0,0,0,0
            elseif obj:IsA("Clouds") then
                obj.Enabled=false
                obj.Density=0
            elseif obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                obj.Enabled=false
            elseif obj:IsA("Highlight") then
                obj.Enabled=false
            elseif obj:IsA("SurfaceAppearance") then
                obj:Destroy()
            elseif obj:IsA("Sound") and obj.IsPlaying then
                obj.Volume = obj.Volume*0.5
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
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
            nv.Brightness,nv.Contrast,nv.Saturation = 0.2,0.3,1
            nv.TintColor = Color3.fromRGB(200,255,200)
        else
            if Lighting:FindFirstChild("NV") then Lighting.NV:Destroy() end
        end
    end
})

TabOpti:AddToggle({
    Name = "Hide NameTags",
    Default = false,
    Callback = function(v)
        tagHidden = v
        for _,plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Head") then
                local nh = plr.Character.Head:FindFirstChild("Nametag") or plr.Character.Head:FindFirstChild("NameTag")
                if nh and nh:IsA("BillboardGui") then nh.Enabled = not tagHidden end
            end
        end
    end
})

TabOpti:AddToggle({
    Name = "Hide Players",
    Default = false,
    Callback = function(v)
        hiddenPlayers = v
        for _,plr in pairs(Players:GetPlayers()) do
            if plr~=player and plr.Character then
                for _,part in pairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        part.Transparency = hiddenPlayers and 1 or 0
                    end
                end
            end
        end
    end
})

local TabTP = Window:MakeTab({Name="Teleport", Icon="rbxassetid://4483345998"})
TabTP:AddTextbox({
    Name = "Coords (x,y,z)",
    Default = "",
    TextDisappear = false,
    Callback = function(v)
        local coords = {}
        for c in string.gmatch(v,"[^,]+") do table.insert(coords,tonumber(c)) end
        if #coords==3 and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(coords[1],coords[2]+5,coords[3])
        end
    end
})

UserInputService.JumpRequest:Connect(function()
    if unlimitedJump and humanoid and humanoid.Parent then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

OrionLib:Init()
