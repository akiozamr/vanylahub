local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local LocalPlayer = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Window = OrionLib:MakeWindow({Name = "💫 VANYLA HUB", HidePremium = false, SaveConfig = true, ConfigFolder = "VanylaHub"})

local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local AntiLagTab = Window:MakeTab({Name = "Anti-Lag", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local savedCoords = {}

local function setHumanoidProperty(prop, value)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum[prop] = value
        end
    end
end

PlayerTab:AddSlider({Name = "WalkSpeed", Min = 16, Max = 200, Default = 16, Color = Color3.fromRGB(0,255,0), Increment = 1, ValueName = "Speed", Callback = function(Value) setHumanoidProperty("WalkSpeed", Value) end})
PlayerTab:AddSlider({Name = "JumpPower", Min = 50, Max = 300, Default = 50, Color = Color3.fromRGB(0,255,0), Increment = 1, ValueName = "Jump", Callback = function(Value) setHumanoidProperty("JumpPower", Value) end})

local teleportFromBox = TeleportTab:AddTextbox({Name = "From Username", Default = "", TextDisappear = true, Callback = function() end})
local teleportToBox = TeleportTab:AddTextbox({Name = "To Username", Default = "", TextDisappear = true, Callback = function() end})

TeleportTab:AddButton({Name = "Teleport", Callback = function()
    local from = teleportFromBox.Text
    local to = teleportToBox.Text
    local fromPlayer = game:GetService("Players"):FindFirstChild(from)
    local toPlayer = game:GetService("Players"):FindFirstChild(to)
    if fromPlayer and toPlayer and fromPlayer.Character and toPlayer.Character then
        local root = fromPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetRoot = toPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and targetRoot then
            root.CFrame = targetRoot.CFrame
        end
    end
end})

TeleportTab:AddButton({Name = "Save My Coordinates", Callback = function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        table.insert(savedCoords, char.HumanoidRootPart.Position)
    end
end})

local coordDropdown = TeleportTab:AddDropdown({Name = "Saved Coordinates", Default = "1", Options = {}, Callback = function(Value)
    local index = tonumber(Value)
    if index and savedCoords[index] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedCoords[index])
    end
end})

TeleportTab:AddButton({Name = "Refresh Coordinates", Callback = function()
    local options = {}
    for i=1,#savedCoords do table.insert(options, tostring(i)) end
    coordDropdown:Refresh(options, true)
end})

local antiLagEnabled = false

AntiLagTab:AddToggle({Name = "Anti-Lag", Default = false, Callback = function(Value)
    antiLagEnabled = Value
    if antiLagEnabled then
        local originalSettings = {}
        local optimizedParts = {}
        spawn(function()
            while antiLagEnabled do
                local char = LocalPlayer.Character
                Lighting.GlobalShadows = false
                Lighting.Technology = Enum.Technology.Compatibility
                Lighting.FogEnd = 1000000
                Lighting.FogStart = 1000000
                Lighting.Brightness = 3
                Lighting.Ambient = Color3.fromRGB(128,128,128)
                Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
                Lighting.ClockTime = 14
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.Material = Enum.Material.SmoothPlastic
                        obj.CastShadow = false
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                        obj.Enabled = false
                    elseif obj:IsA("Atmosphere") then
                        obj.Density = 0
                        obj.Offset = 0
                        obj.Glare = 0
                        obj.Haze = 0
                    elseif obj:IsA("Clouds") then
                        obj.Enabled = false
                    elseif obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                        obj.Enabled = false
                    elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                        obj.Brightness = obj.Brightness * 0.3
                        obj.Range = math.min(obj.Range, 10)
                    end
                end
                wait(5)
            end
        end)
    end
end})

OrionLib:Init()
