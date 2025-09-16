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

local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local OptiTab = Window:MakeTab({Name = "Opti", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local WalkSpeed = 16
local JumpPower = 50
local FPS = 0
local lastTime = tick()
local frameCount = 0
local TeleCoords = {}

-- FPS Counter
local fpsLabel = OptiTab:AddLabel("FPS: --")

RunService.Heartbeat:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 0.5 then
        FPS = frameCount / (currentTime - lastTime)
        frameCount = 0
        lastTime = currentTime
        fpsLabel:Set("FPS: "..math.floor(FPS))
    end
end)

-- WalkSpeed & Jump
PlayerTab:AddTextbox({Name="Walkspeed | "..WalkSpeed, Default=tostring(WalkSpeed), TextDisappear=true, Callback=function(val)
    WalkSpeed = tonumber(val) or 16
    player.Character.Humanoid.WalkSpeed = WalkSpeed
end})

PlayerTab:AddTextbox({Name="JumpPower | "..JumpPower, Default=tostring(JumpPower), TextDisappear=true, Callback=function(val)
    JumpPower = tonumber(val) or 50
    player.Character.Humanoid.JumpPower = JumpPower
end})

-- Morph Player
local function MorphPlayer(targetPlayer)
    local success, char = pcall(function()
        return targetPlayer.Character:Clone()
    end)
    if success and char then
        char.Parent = Workspace
        char:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame)
        player.Character:Destroy()
        player.Character = char
    end
end

local PlayerDropdown
local function RefreshPlayerDropdown()
    local plrList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(plrList, p.Name)
        end
    end
    if PlayerDropdown then
        PlayerDropdown:Refresh(plrList, true)
    else
        PlayerDropdown = PlayerTab:AddDropdown({Name="Morph Player", Default="", Options=plrList, Callback=function(val)
            local plr = Players:FindFirstChild(val)
            if plr then MorphPlayer(plr) end
        end})
    end
end
RefreshPlayerDropdown()
Players.PlayerAdded:Connect(RefreshPlayerDropdown)
Players.PlayerRemoving:Connect(RefreshPlayerDropdown)

-- Teleport
local TPPlayerDropdown
local function RefreshTPDropdown()
    local plrList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(plrList, p.Name)
        end
    end
    if TPPlayerDropdown then
        TPPlayerDropdown:Refresh(plrList, true)
    else
        TPPlayerDropdown = TeleportTab:AddDropdown({Name="Teleport to Player", Default="", Options=plrList, Callback=function(val)
            local plr = Players:FindFirstChild(val)
            if plr and plr.Character and plr.Character.PrimaryPart then
                player.Character:SetPrimaryPartCFrame(plr.Character.PrimaryPart.CFrame + Vector3.new(0,5,0))
            end
        end})
    end
end
RefreshTPDropdown()
Players.PlayerAdded:Connect(RefreshTPDropdown)
Players.PlayerRemoving:Connect(RefreshTPDropdown)

-- Save Teleport Coordinates
local SaveCoordDropdown
local function RefreshSaveCoordDropdown()
    local list = {}
    for i=1,#TeleCoords do
        table.insert(list,"Coordinate "..i)
    end
    if SaveCoordDropdown then
        SaveCoordDropdown:Refresh(list,true)
    else
        SaveCoordDropdown = TeleportTab:AddDropdown({Name="Teleport Saved", Default="", Options=list, Callback=function(val)
            local idx = tonumber(val:match("%d+"))
            if idx and TeleCoords[idx] then
                player.Character:SetPrimaryPartCFrame(TeleCoords[idx])
            end
        end})
    end
end

TeleportTab:AddButton({Name="Save Current Coordinate", Callback=function()
    table.insert(TeleCoords, player.Character.PrimaryPart.CFrame)
    RefreshSaveCoordDropdown()
end})

-- Anti-Lag Optimizer
local OriginalSettings = {}
local Optimized = false
local function AntiLag()
    if Optimized then return end
    OriginalSettings = {
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Technology = Lighting.Technology
    }
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1000000
    Lighting.FogStart = 1000000
    Lighting.Brightness = 3
    Lighting.Ambient = Color3.fromRGB(128,128,128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    Lighting.Technology = Enum.Technology.Compatibility
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.TopSurface = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
            obj.LeftSurface = Enum.SurfaceType.Smooth
            obj.RightSurface = Enum.SurfaceType.Smooth
            obj.FrontSurface = Enum.SurfaceType.Smooth
            obj.BackSurface = Enum.SurfaceType.Smooth
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("Atmosphere") then
            obj.Density = 0
            obj.Offset = 0
            obj.Glare = 0
            obj.Haze = 0
        elseif obj:IsA("Clouds") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Brightness = obj.Brightness*0.3
            obj.Range = math.min(obj.Range,10)
        end
    end
    collectgarbage("collect")
    Optimized = true
end
OptiTab:AddToggle({Name="Anti-Lag", Default=false, Callback=function(val)
    if val then AntiLag() end
end})

OrionLib:Init()
