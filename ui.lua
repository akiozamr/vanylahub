--// Orion Lib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Vanyla Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "VanylaHub"
})

--// Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

-- Refresh Humanoid kalau respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    Humanoid = char:FindFirstChildOfClass("Humanoid")
end)

--// ===== Player Tab =====
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(0,255,0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(0,255,0),
    Increment = 1,
    ValueName = "Jump",
    Callback = function(Value)
        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

--// ===== Teleport Tab =====
local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local savedCoords = {}

-- Teleport ke player lewat username
TeleportTab:AddTextbox({
    Name = "Teleport ke Player",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        local target = Players:FindFirstChild(Value)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
                OrionLib:MakeNotification({
                    Name = "Teleport",
                    Content = "Berhasil teleport ke "..Value,
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Player tidak ditemukan!",
                Time = 3
            })
        end
    end
})

-- Buat list koordinat
local function makeCoordList()
    local list = {}
    for i = 1, #savedCoords do
        table.insert(list, "Koordinat "..i)
    end
    return list
end

-- Dropdown teleport ke koordinat
local TeleportDropdown = TeleportTab:AddDropdown({
    Name = "Teleport ke Koordinat",
    Default = "",
    Options = {},
    Callback = function(Value)
        local index = tonumber(Value:match("%d+"))
        if index and savedCoords[index] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = savedCoords[index]
        end
    end
})

-- Tombol save koordinat
TeleportTab:AddButton({
    Name = "Save Koordinat",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.CFrame
            table.insert(savedCoords, pos)
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Koordinat "..#savedCoords.." tersimpan!",
                Time = 3
            })
            TeleportDropdown:Refresh(makeCoordList(), true)
        end
    end
})

--// ===== Optifine (Anti-Lag) Tab =====
local OptifineTab = Window:MakeTab({
    Name = "Optifine",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Save default settings buat reset
local defaultSettings = {
    Lighting = {
        GlobalShadows = Lighting.GlobalShadows,
        Brightness = Lighting.Brightness,
        FogEnd = Lighting.FogEnd,
        ClockTime = Lighting.ClockTime,
        Technology = Lighting.Technology
    },
    Parts = {}
}
for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        defaultSettings.Parts[obj] = {
            Material = obj.Material,
            Reflectance = obj.Reflectance
        }
    end
end

local function setAntiLag(enabled)
    if enabled then
        -- Anti-Lag ON
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        end
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.FogEnd = 1e6
        Lighting.ClockTime = 14
        Lighting.Technology = Enum.Technology.Compatibility

        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = false
            end
        end
    else
        -- Reset ke default
        Lighting.GlobalShadows = defaultSettings.Lighting.GlobalShadows
        Lighting.Brightness = defaultSettings.Lighting.Brightness
        Lighting.FogEnd = defaultSettings.Lighting.FogEnd
        Lighting.ClockTime = defaultSettings.Lighting.ClockTime
        Lighting.Technology = defaultSettings.Lighting.Technology

        for part, props in pairs(defaultSettings.Parts) do
            if part and part.Parent then
                part.Material = props.Material
                part.Reflectance = props.Reflectance
            end
        end

        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") then
                effect.Enabled = true
            end
        end
    end
end

OptifineTab:AddToggle({
    Name = "Anti-Lag",
    Default = false,
    Callback = function(Value)
        setAntiLag(Value)
    end
})

--// Init UI
OrionLib:Init()
