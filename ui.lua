-- load Orion
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

-- buat window utama
local Window = OrionLib:MakeWindow({
    Name = "💫 VANYLA HUB",
    HidePremium = false,
    SaveConfig = false,
    IntroEnabled = true,
    IntroText = "💫 VANYLA HUB"
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local humanoid = player.Character and player.Character:WaitForChild("Humanoid")

-- variabel teleport
local savedPosition = nil

-- TAB PLAYER
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- WalkSpeed Slider
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 200,
    Default = humanoid and humanoid.WalkSpeed or 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end    
})

-- JumpPower Slider
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 200,
    Default = humanoid and humanoid.JumpPower or 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "power",
    Callback = function(Value)
        if humanoid then
            humanoid.JumpPower = Value
        end
    end    
})

-- Unlimited Jump
PlayerTab:AddToggle({
    Name = "Unlimited Jump",
    Default = false,
    Callback = function(Value)
        if Value then
            local UIS = game:GetService("UserInputService")
            UIS.JumpRequest:Connect(function()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end    
})

-- TAB OPTIFINE (kosong dulu)
local OptifineTab = Window:MakeTab({
    Name = "Optifine",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})
OptifineTab:AddLabel("Belum ada fitur di sini 👀")

-- TAB TELEPORT
local TeleportTab = Window:MakeTab({
    Name = "Teleport",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Teleport ke player
TeleportTab:AddTextbox({
    Name = "Teleport ke Player",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        local target = Players:FindFirstChild(Value)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character:MoveTo(target.Character.HumanoidRootPart.Position)
        else
            OrionLib:MakeNotification({
                Name = "Teleport Failed",
                Content = "Player tidak ditemukan.",
                Time = 3
            })
        end
    end	  
})

-- Save koordinat
TeleportTab:AddButton({
    Name = "Save Koordinat",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            savedPosition = player.Character.HumanoidRootPart.Position
            OrionLib:MakeNotification({
                Name = "Koordinat Disimpan",
                Content = tostring(savedPosition),
                Time = 3
            })
        end
    end    
})

-- Teleport ke koordinat tersimpan
TeleportTab:AddButton({
    Name = "Teleport ke Koordinat",
    Callback = function()
        if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
        else
            OrionLib:MakeNotification({
                Name = "Teleport Failed",
                Content = "Belum ada koordinat tersimpan.",
                Time = 3
            })
        end
    end    
})

-- init Orion
OrionLib:Init()
