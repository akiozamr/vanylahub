-- VANYLA HUB (💫)
-- Universal-ish Orion UI hub with common player utilities and config support.

-- Boot Orion
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
end)

if not success or not OrionLib then
    warn("Gagal load OrionLib.")
    return
end

-- Window
local Window = OrionLib:MakeWindow({
    Name = "💫 VANYLA HUB",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "VANYLA_HUB_Config",
    IntroEnabled = true,
    IntroText = "Welcome to VANYLA HUB",
    IntroIcon = "rbxassetid://4483345998"
})

-- Tabs
local mainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local playerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local teleportTab = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local miscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local uiTab = Window:MakeTab({Name = "UI", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- Sections
local infoSection = mainTab:AddSection({Name = "Info"})
local utilitiesSection = mainTab:AddSection({Name = "Utilities"})
local movementSection = playerTab:AddSection({Name = "Movement"})
local teleportSection = teleportTab:AddSection({Name = "Teleports"})
local miscSection = miscTab:AddSection({Name = "Misc"})
local uiSection = uiTab:AddSection({Name = "Config & UI"})

-- Basic info
mainTab:AddLabel("💫 VANYLA HUB - Universal Tools")
mainTab:AddParagraph("Notes", "Designed to be broadly compatible across maps. Some features depend on the game allowing local property changes.")

-- Helper references
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- Utility functions
local function getCharacter()
    if not LocalPlayer then return nil end
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function safeNotify(title, content, time)
    pcall(function()
        OrionLib:MakeNotification({Name = title or "VANYLA", Content = content or "", Image = "rbxassetid://4483345998", Time = time or 5})
    end)
end

-- ===== MAIN UTILITIES =====

-- Destroy UI Button
miscSection:AddButton({
    Name = "Destroy UI",
    Callback = function()
        pcall(function() OrionLib:Destroy() end)
    end
})

-- Rejoin Server
miscSection:AddButton({
    Name = "Rejoin Server",
    Callback = function()
        pcall(function()
            safeNotify("Rejoining", "Attempting to rejoin this server...", 3)
            local placeId = game.PlaceId
            local jobId = game.JobId
            TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
        end)
    end
})

-- Copy flags example (show usage)
mainTab:AddButton({
    Name = "Print Example Flag Values",
    Callback = function()
        pcall(function()
            local flags = OrionLib.Flags
            -- print a few saved flags (if exist)
            print("WalkSpeed:", flags["walkspeed"] and flags["walkspeed"].Value or "n/a")
            print("JumpPower:", flags["jumppower"] and flags["jumppower"].Value or "n/a")
            print("Noclip:", flags["noclip"] and flags["noclip"].Value or "n/a")
            safeNotify("Flags", "Printed example flags to output.", 3)
        end)
    end
})

-- ===== PLAYER MOVEMENT =====

-- WalkSpeed slider (flagged & saved)
local speedSlider = movementSection:AddSlider({
    Name = "WalkSpeed",
    Min = 8,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "studs/s",
    Callback = function(val)
        pcall(function()
            local humanoid = getHumanoid()
            if humanoid then
                humanoid.WalkSpeed = val
            end
        end)
    end,
    -- flags for config
})
-- Set flag & save using documentation pattern
-- (Orion: AddSlider doesn't accept Flag/Save in doc, but flags work for slider per doc)
-- We will add a flag entry manually if needed:
if OrionLib.Flags then
    OrionLib.Flags["walkspeed"] = OrionLib.Flags["walkspeed"] or {Value = speedSlider.Value}
end

-- JumpPower slider
local jumpSlider = movementSection:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 300,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "power",
    Callback = function(val)
        pcall(function()
            local humanoid = getHumanoid()
            if humanoid then
                -- Humanoid.UseJumpPower is preferable in modern Roblox
                if humanoid.UseJumpPower ~= nil then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = val
                else
                    humanoid.JumpHeight = val -- fallback (not ideal)
                end
            end
        end)
    end
})

-- Noclip toggle (works by turning off CanCollide on character parts while active)
local noclipToggle = movementSection:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        pcall(function()
            if state then
                -- Connect a step to disable collisions each frame
                noclipToggle._conn = RunService.Stepped:Connect(function()
                    local char = getCharacter()
                    if char then
                        for _, part in pairs(char:GetChildren()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if noclipToggle._conn then
                    noclipToggle._conn:Disconnect()
                    noclipToggle._conn = nil
                end
                -- try to re-enable collisions
                local char = getCharacter()
                if char then
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            pcall(function() part.CanCollide = true end)
                        end
                    end
                end
            end
        end)
    end
})

-- Simple Fly implementation (local)
local flyToggle = movementSection:AddToggle({
    Name = "Fly (Hold movement keys)",
    Default = false,
    Callback = function(state)
        pcall(function()
            local char = getCharacter()
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = getHumanoid()
            if not hrp or not humanoid then return end

            if state then
                humanoid.PlatformStand = true
                local bv = Instance.new("BodyVelocity")
                bv.Name = "VanylaFlyBV"
                bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                bv.Velocity = Vector3.new(0,0,0)
                bv.Parent = hrp

                local bg = Instance.new("BodyGyro")
                bg.Name = "VanylaFlyBG"
                bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
                bg.CFrame = hrp.CFrame
                bg.Parent = hrp

                local speed = 100
                flyToggle._conn = RunService.RenderStepped:Connect(function()
                    if not hrp or not char then return end
                    -- read input direction from Humanoid.MoveDirection
                    local moveDir = humanoid.MoveDirection
                    local targetVel = moveDir * speed
                    -- keep a small upward velocity if jumping / cast
                    if humanoid.Jump then
                        targetVel = targetVel + Vector3.new(0, speed/2, 0)
                    end
                    bv.Velocity = targetVel
                    bg.CFrame = hrp.CFrame
                end)
            else
                if flyToggle._conn then
                    flyToggle._conn:Disconnect()
                    flyToggle._conn = nil
                end
                local hrp = getCharacter() and getCharacter():FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, v in pairs(hrp:GetChildren()) do
                        if v.Name == "VanylaFlyBV" or v.Name == "VanylaFlyBG" then
                            v:Destroy()
                        end
                    end
                end
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end)
    end
})

-- Bind to toggle fly quickly (example: F)
movementSection:AddBind({
    Name = "Fly Bind",
    Default = Enum.KeyCode.F,
    Hold = false,
    Callback = function()
        pcall(function()
            local cur = flyToggle and flyToggle.Value
            if flyToggle and flyToggle.Set then
                flyToggle:Set(not cur)
            end
        end)
    end
})

-- ===== TELEPORTS =====

-- Teleport to respawn/spawn location (works if SpawnLocation exists)
teleportSection:AddButton({
    Name = "Teleport to Spawn",
    Callback = function()
        pcall(function()
            local spawnPos
            -- try to find SpawnLocation(s)
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("SpawnLocation") then
                    spawnPos = v.Position
                    break
                end
            end
            -- fallback: try to use SpawnLocation property or map-specific named objects
            if not spawnPos then
                if workspace:FindFirstChild("SpawnLocation") and workspace.SpawnLocation:IsA("BasePart") then
                    spawnPos = workspace.SpawnLocation.Position
                end
            end
            -- fallback to default respawn point: nil -> notify
            if spawnPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPos + Vector3.new(0,5,0))
                safeNotify("Teleported", "Moved to spawn location.", 3)
            else
                safeNotify("Teleport failed", "No spawn location found or no character.", 4)
            end
        end)
    end
})

-- Teleport to mouse target (if available)
teleportSection:AddButton({
    Name = "Teleport to Mouse (safe)",
    Callback = function()
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local pos = mouse and mouse.Hit and mouse.Hit.p
            if pos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,5,0))
                safeNotify("Teleported", "Teleported to mouse position.", 3)
            else
                safeNotify("Teleport failed", "Mouse position not available.", 3)
            end
        end)
    end
})

-- Dropdown of common places (example placeholder that often won't work cross-game but included)
local placeListDropdown = teleportSection:AddDropdown({
    Name = "Common Places (example)",
    Default = "Select",
    Options = {"Spawn", "Center", "Random Nearby"},
    Callback = function(val)
        pcall(function()
            if val == "Spawn" then
                -- reuse teleport to spawn
                for _, btn in pairs(teleportSection:GetChildren() or {}) do end
                -- call above button via direct logic (simpler: just notify)
                safeNotify("Teleport", "Press Teleport to Spawn button to go.", 3)
            elseif val == "Random Nearby" then
                local char = getCharacter()
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-50,50), 0, math.random(-50,50))
                    safeNotify("Teleported", "Random nearby teleport.", 3)
                end
            else
                safeNotify("Info", "Selected: "..tostring(val), 3)
            end
        end)
    end
})

-- ===== UI / CONFIG =====

-- UI Theme colorpicker (stored in flags)
local themeColor = uiSection:AddColorpicker({
    Name = "Theme Color",
    Default = Color3.fromRGB(85,170,255),
    Callback = function(color)
        pcall(function()
            -- Orion's internal theme mutate may not be exposed; this is a placeholder saving color for your scripts
            -- You can read OrionLib.Flags["theme_color"].Value elsewhere to apply theme if supported.
            if OrionLib and OrionLib.Flags then
                OrionLib.Flags["theme_color"] = OrionLib.Flags["theme_color"] or {Value = color}
                OrionLib.Flags["theme_color"].Value = color
            end
            safeNotify("Theme", "Theme color set (saved).", 2)
        end)
    end
})

-- Toggle save config example
uiSection:AddToggle({
    Name = "Auto Save Config",
    Default = true,
    Callback = function(v)
        pcall(function()
            -- This toggle is just illustrative; Orion window already takes SaveConfig param
            safeNotify("Config", "Auto Save Config: "..tostring(v), 2)
        end)
    end
})

-- Keybind to hide/show UI (best-effort: will hide Orion's intro frame if accessible)
uiSection:AddBind({
    Name = "Toggle UI (attempt)",
    Default = Enum.KeyCode.RightControl,
    Hold = false,
    Callback = function()
        pcall(function()
            -- Try to find Orion main GUI in CoreGui or Players.LocalPlayer: Wait for likely parents
            local found = false
            for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
                if gui.Name:lower():find("orion") or gui.Name:lower():find("vanyl") or gui.Name:lower():find("vanyla") then
                    gui.Enabled = not gui.Enabled
                    found = true
                end
            end
            -- fallback: try RobloxGui (may be inaccessible)
            if not found then
                -- best-effort notification
                safeNotify("UI Toggle", "Tried toggle, might not be supported in this environment.", 3)
            end
        end)
    end
})

-- Save current config button
uiSection:AddButton({
    Name = "Force Save Config (if supported)",
    Callback = function()
        pcall(function()
            if OrionLib.SaveConfig then
                if OrionLib.SaveConfig == true and OrionLib.ConfigFolder then
                    safeNotify("Config", "Config saving handled automatically by Orion.", 3)
                else
                    safeNotify("Config", "Orion config not enabled or not accessible.", 3)
                end
            else
                safeNotify("Config", "OrionLib:SaveConfig not exposed.", 3)
            end
        end)
    end
})

-- ===== MISC FEATURES =====

-- Simple spammy test button (example utility)
utilitiesSection:AddButton({
    Name = "Test Notification",
    Callback = function()
        safeNotify("VANYLA", "This is a test notification from VANYLA HUB.", 4)
    end
})

-- Textbox to run small commands (non-destructive)
miscSection:AddTextbox({
    Name = "Run Command (print only)",
    Default = "print('hello world')",
    TextDisappear = true,
    Callback = function(value)
        pcall(function()
            -- For safety, only allow print commands: naive check
            if tostring(value):lower():match("^print") then
                local ok, err = pcall(function() loadstring(value)() end)
                if not ok then
                    safeNotify("Command Error", tostring(err), 4)
                end
            else
                safeNotify("Command blocked", "Only print(...) allowed for safety.", 4)
            end
        end)
    end
})

-- ===== CLEANUP ON CHARACTER ADDED =====
-- reapply walk/jump settings on respawn if sliders are set
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    pcall(function()
        local hs = OrionLib and OrionLib.Flags and OrionLib.Flags["walkspeed"] and OrionLib.Flags["walkspeed"].Value or speedSlider.Value
        local jp = OrionLib and OrionLib.Flags and OrionLib.Flags["jumppower"] and OrionLib.Flags["jumppower"].Value or jumpSlider.Value
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = hs or 16
            if humanoid.UseJumpPower ~= nil then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = jp or 50
            end
        end
    end)
end)

-- Initial small notif
safeNotify("💫 VANYLA HUB", "Loaded — open the UI to begin.", 4)

-- REQUIRED: initialize Orion
OrionLib:Init()
