-- 💫 VANYLA HUB (Full Features Optimized)

-- Load Orion Library
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
end)
if not success or not OrionLib then return warn("Failed to load OrionLib") end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Helpers
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end
local function notify(title, content, time)
    OrionLib:MakeNotification({
        Name = title or "VANYLA HUB",
        Content = content or "",
        Image = "rbxassetid://4483345998",
        Time = time or 4
    })
end

-- Window
local Window = OrionLib:MakeWindow({
    Name = "💫 VANYLA HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "VANYLA_HUB"
})

-- Tabs
local mainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local playerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998"})
local tpTab = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483345998"})
local miscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998"})

----------------------------------------------------
-- Main
mainTab:AddParagraph("💫 VANYLA HUB", "Script Multi-Map dengan fitur dasar player.")

----------------------------------------------------
-- Player
-- WalkSpeed
local wsEnabled, wsValue = false, 16
playerTab:AddToggle({
    Name = "WalkSpeed Control",
    Default = false,
    Callback = function(state)
        wsEnabled = state
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = state and wsValue or 16 end
        notify("WalkSpeed", state and ("ON ("..wsValue..")") or "OFF (16)")
    end
})
playerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 8, Max = 500, Default = 16, Increment = 1,
    ValueName = "speed",
    Callback = function(val)
        wsValue = val
        if wsEnabled then
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = val end
        end
    end
})

-- JumpPower
local jpEnabled, jpValue = false, 50
playerTab:AddToggle({
    Name = "JumpPower Control",
    Default = false,
    Callback = function(state)
        jpEnabled = state
        local hum = getHumanoid()
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = state and jpValue or 50
        end
        notify("JumpPower", state and ("ON ("..jpValue..")") or "OFF (50)")
    end
})
playerTab:AddSlider({
    Name = "JumpPower",
    Min = 10, Max = 300, Default = 50, Increment = 1,
    ValueName = "power",
    Callback = function(val)
        jpValue = val
        if jpEnabled then
            local hum = getHumanoid()
            if hum then hum.JumpPower = val end
        end
    end
})

-- Noclip
local noclipEnabled = false
playerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        notify("Noclip", state and "ON" or "OFF")
    end
})
RunService.Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(getCharacter():GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly
local flyEnabled = false
local flySpeed = 50
local flyConn
playerTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        local hum = getHumanoid()
        if state and hum then
            notify("Fly", "ON (WASD to move, Space to up)")
            flyConn = RunService.RenderStepped:Connect(function()
                local hrp = getCharacter():FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
                    if dir.Magnitude > 0 then
                        hrp.Velocity = dir.Unit * flySpeed
                    else
                        hrp.Velocity = Vector3.zero
                    end
                end
            end)
        else
            if flyConn then flyConn:Disconnect() flyConn = nil end
            local hrp = getCharacter():FindFirstChild("HumanoidRootPart")
            if hrp then hrp.Velocity = Vector3.zero end
            notify("Fly", "OFF")
        end
    end
})
playerTab:AddSlider({
    Name = "Fly Speed",
    Min = 10, Max = 200, Default = 50, Increment = 5,
    ValueName = "speed",
    Callback = function(val) flySpeed = val end
})

----------------------------------------------------
-- Teleports
tpTab:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
        if spawn then
            getCharacter():SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0,5,0))
            notify("Teleport", "Moved to Spawn")
        else
            notify("Teleport", "No Spawn found")
        end
    end
})
tpTab:AddButton({
    Name = "Teleport to Mouse",
    Callback = function()
        local pos = game:GetService("Players").LocalPlayer:GetMouse().Hit
        if pos then
            getCharacter():SetPrimaryPartCFrame(CFrame.new(pos.p + Vector3.new(0,5,0)))
            notify("Teleport", "Moved to Mouse Position")
        end
    end
})
local dropdownPlaces = {"Spawn","Center","Random Nearby"}
local dropdownSel = "Spawn"
local tpDropdown = tpTab:AddDropdown({
    Name = "Common Places",
    Default = "Spawn",
    Options = dropdownPlaces,
    Callback = function(val) dropdownSel = val end
})
tpTab:AddButton({
    Name = "Go to Selected Place",
    Callback = function()
        local hrp = getCharacter():FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if dropdownSel == "Spawn" then
            local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
            if spawn then hrp.CFrame = spawn.CFrame + Vector3.new(0,5,0) end
        elseif dropdownSel == "Center" then
            hrp.CFrame = CFrame.new(Vector3.zero + Vector3.new(0,5,0))
        elseif dropdownSel == "Random Nearby" then
            hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-50,50),0,math.random(-50,50))
        end
        notify("Teleport", "Moved to "..dropdownSel)
    end
})

----------------------------------------------------
-- Misc
miscTab:AddButton({
    Name = "Destroy UI",
    Callback = function()
        OrionLib:Destroy()
    end
})
miscTab:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})
miscTab:AddTextbox({
    Name = "Run Command",
    Default = "",
    TextDisappear = true,
    Callback = function(txt)
        pcall(function() loadstring(txt)() end)
        notify("Run Command", "Executed.")
    end
})

----------------------------------------------------
-- Init
notify("💫 VANYLA HUB", "Loaded successfully!")
OrionLib:Init()
