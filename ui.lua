local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "💫 VANYLA HUB", HidePremium = true, SaveConfig = true, ConfigFolder = "VanylaHub"})

local Tab1 = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})
local Tab2 = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998"})
local Tab3 = Window:MakeTab({Name = "Performance", Icon = "rbxassetid://4483345998"})

local SectionPlayer = Tab1:AddSection({Name = "Player Settings"})
local SectionTeleport = Tab2:AddSection({Name = "Teleport Settings"})
local SectionPerf = Tab3:AddSection({Name = "Performance Settings"})

local WalkSpeedTextbox = Tab1:AddTextbox({Name="Walkspeed",Default=tostring(player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16),TextDisappear=true,Callback=function(Value)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = tonumber(Value) or 16 end
end})

local JumpPowerTextbox = Tab1:AddTextbox({Name="JumpPower",Default=tostring(player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50),TextDisappear=true,Callback=function(Value)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.JumpPower = tonumber(Value) or 50 end
end})

Tab1:AddToggle({Name="Infinite Jump",Default=false,Callback=function(Value)
    _G.InfiniteJump = Value
end})

Tab1:AddToggle({Name="NoClip",Default=false,Callback=function(Value)
    _G.NoClip = Value
end})

Tab1:AddDropdown({Name="Animation",Default="None",Options={"None","Idle","Walk","Run","Jump"},Callback=function(Value)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if Value=="None" then humanoid:ChangeState(Enum.HumanoidStateType.Physics) else humanoid:LoadAnimation(Instance.new("Animation",{AnimationId="rbxassetid://0"})):Play() end
    end
end})

local teleportPlayersDropdown = Tab2:AddDropdown({Name="Teleport to Player",Default="",Options={},Callback=function(Value)
    local target = Players:FindFirstChild(Value)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end})

local savedCoords = {}
Tab2:AddButton({Name="Save Position",Callback=function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        table.insert(savedCoords, player.Character.HumanoidRootPart.Position)
        Tab2:AddButton({Name="Teleport to Coord "..#savedCoords,Callback=function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(savedCoords[#savedCoords])
            end
        end})
    end
end})

Tab3:AddToggle({Name="Anti-Lag",Default=false,Callback=function(Value)
    _G.AntiLag = Value
    if Value then
        Workspace.StreamingEnabled = true
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
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj.Brightness = obj.Brightness * 0.3
                obj.Range = math.min(obj.Range,10)
            elseif obj:IsA("Atmosphere") then
                obj.Density = 0
                obj.Offset = 0
                obj.Glare = 0
                obj.Haze = 0
            elseif obj:IsA("Clouds") then
                obj.Enabled = false
            elseif obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") then
                obj.Enabled = false
            end
        end
    end
end})

local fpsLabel = Tab3:AddLabel("FPS: --")
local frameCount,lastTime,fps = 0,tick(),0
RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime-lastTime>=0.5 then
        fps = frameCount/(currentTime-lastTime)
        frameCount,lastTime = 0,currentTime
        fpsLabel:Set(string.format("FPS: %.0f",fps))
    end
end)

Players.PlayerAdded:Connect(function(plr)
    table.insert(teleportPlayersDropdown.Options, plr.Name)
    teleportPlayersDropdown:Refresh(teleportPlayersDropdown.Options,true)
end)

for _,plr in pairs(Players:GetPlayers()) do
    if plr ~= player then
        table.insert(teleportPlayersDropdown.Options, plr.Name)
    end
end
teleportPlayersDropdown:Refresh(teleportPlayersDropdown.Options,true)

OrionLib:Init()

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if _G.NoClip and player.Character then
        for _,part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
