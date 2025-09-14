-- LocalScript (letakkan di StarterGui)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- ========== UI CREATION ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarCopierGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 340, 0, 420)
mainFrame.Position = UDim2.new(0.7, 0, 0.15, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.BackgroundTransparency = 0.06
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.ZIndex = 2
mainFrame.Rotation = 0
local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 8)

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0.7, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Avatar Copier"
title.TextColor3 = Color3.fromRGB(230,230,230)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", topBar)
minimizeBtn.Size = UDim2.new(0, 34, 0, 24)
minimizeBtn.Position = UDim2.new(1, -44, 0, 8)
minimizeBtn.AnchorPoint = Vector2.new(1, 0)
minimizeBtn.Text = "—"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.BackgroundTransparency = 0.12
minimizeBtn.BorderSizePixel = 0
minimizeBtn.TextColor3 = Color3.fromRGB(220,220,220)
minimizeBtn.Name = "Minimize"
minimizeBtn.AutoButtonColor = true
local mbCorner = Instance.new("UICorner", minimizeBtn); mbCorner.CornerRadius = UDim.new(0,6)

local listFrame = Instance.new("Frame", mainFrame)
listFrame.Size = UDim2.new(1, -20, 1, -100)
listFrame.Position = UDim2.new(0, 10, 0, 50)
listFrame.BackgroundTransparency = 1

local uiList = Instance.new("ScrollingFrame", listFrame)
uiList.Name = "PlayersList"
uiList.Size = UDim2.new(1, 0, 1, 0)
uiList.CanvasSize = UDim2.new(0, 0, 1, 0)
uiList.ScrollBarThickness = 6
uiList.BackgroundTransparency = 0.04
uiList.BackgroundColor3 = Color3.fromRGB(20,20,20)
uiList.BorderSizePixel = 0
uiList.LayoutOrder = 1
local listCorner = Instance.new("UICorner", uiList); listCorner.CornerRadius = UDim.new(0,6)

local uiListLayout = Instance.new("UIListLayout", uiList)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0,6)

local copyBtn = Instance.new("TextButton", mainFrame)
copyBtn.Size = UDim2.new(1, -20, 0, 36)
copyBtn.Position = UDim2.new(0, 10, 1, -42)
copyBtn.Text = "Copy Avatar"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 16
copyBtn.TextColor3 = Color3.fromRGB(240,240,240)
copyBtn.BackgroundTransparency = 0.06
copyBtn.BorderSizePixel = 0
copyBtn.AutoButtonColor = true
local cbCorner = Instance.new("UICorner", copyBtn); cbCorner.CornerRadius = UDim.new(0,6)

local statusLabel = Instance.new("TextLabel", mainFrame)
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 1, -68)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Pilih pemain lalu klik Copy Avatar"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextColor3 = Color3.fromRGB(190,190,190)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ========== UI LOGIC ==========
local minimized = false
local selectedPlayer = nil

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        -- animate minimize
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.22), {Size = UDim2.new(0, 160, 0, 36)})
        tween:Play()
        title.Text = "Avatar Copier (min)"
        uiList.Visible = false
        copyBtn.Visible = false
        statusLabel.Visible = false
    else
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.22), {Size = UDim2.new(0, 340, 0, 420)})
        tween:Play()
        title.Text = "Avatar Copier"
        uiList.Visible = true
        copyBtn.Visible = true
        statusLabel.Visible = true
    end
end)

-- helper to create player button
local function makePlayerButton(plr)
    local btn = Instance.new("TextButton")
    btn.Name = "PlayerBtn_" .. plr.UserId
    btn.Size = UDim2.new(1, -12, 0, 44)
    btn.BackgroundTransparency = 0.06
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(235,235,235)
    btn.Text = plr.Name
    btn.LayoutOrder = plr.UserId
    local corner = Instance.new("UICorner", btn); corner.CornerRadius = UDim.new(0,6)
    btn.Parent = uiList

    local small = Instance.new("TextLabel", btn)
    small.Size = UDim2.new(0.6, 0, 1, 0)
    small.Position = UDim2.new(0, 8, 0, 0)
    small.BackgroundTransparency = 1
    small.Font = Enum.Font.Gotham
    small.TextSize = 12
    small.TextColor3 = Color3.fromRGB(160,160,160)
    small.TextXAlignment = Enum.TextXAlignment.Left
    small.Text = "UserId: "..plr.UserId

    btn.MouseButton1Click:Connect(function()
        -- deselect visual for others
        for _,v in pairs(uiList:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundTransparency = 0.06
            end
        end
        selectedPlayer = plr
        btn.BackgroundTransparency = 0.0
        statusLabel.Text = "Selected: "..plr.Name
    end)
end

local function refreshPlayerList()
    -- clear
    for _,v in pairs(uiList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    -- add players
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            makePlayerButton(plr)
        end
    end
    -- adjust canvas size
    local contentSize = 44 * (#Players:GetPlayers()-1) + 12
    if contentSize < 1 then contentSize = 1 end
    uiList.CanvasSize = UDim2.new(0, 0, 0, contentSize)
end

Players.PlayerAdded:Connect(function(plr)
    wait(0.2)
    refreshPlayerList()
end)
Players.PlayerRemoving:Connect(function()
    wait(0.1)
    if selectedPlayer and not Players:FindFirstChild(selectedPlayer.Name) then
        selectedPlayer = nil
        statusLabel.Text = "Pilih pemain lalu klik Copy Avatar"
    end
    refreshPlayerList()
end)

-- initial populate
refreshPlayerList()

-- ========== COPY LOGIC ==========
local function safeWarn(msg)
    statusLabel.Text = msg
end

local function copyAvatarFrom(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        safeWarn("Target tidak ditemukan atau belum spawn.")
        return
    end

    local targetChar = targetPlayer.Character
    local localChar = player.Character
    if not localChar then
        safeWarn("Karaktermu belum spawn.")
        return
    end

    local targetHum = targetChar:FindFirstChildOfClass("Humanoid")
    local localHum = localChar:FindFirstChildOfClass("Humanoid")
    if not targetHum or not localHum then
        safeWarn("Tidak menemukan Humanoid (R6/R15 mismatch?).")
        return
    end

    safeWarn("Mencoba ambil HumanoidDescription dari "..targetPlayer.Name.." ...")
    -- Attempt to get HumanoidDescription from target's UserId (best for exact clothes/accessories)
    local ok, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(targetPlayer.UserId)
    end)

    if ok and desc then
        -- Apply description to local humanoid
        local appliedOk, err = pcall(function()
            localHum:ApplyDescription(desc)
        end)
        if appliedOk then
            safeWarn("Deskripsi avatar diterapkan. Menyalin animasi...")
        else
            safeWarn("Gagal apply description: "..tostring(err))
        end
    else
        safeWarn("Gagal ambil HumanoidDescription — mencoba salin manual aksesori/penampilan.")
    end

    -- Try copy accessories that might be missing by cloning Target accessories
    -- Note: cloning other players' accessory Instances may fail or look odd; we rely mainly on HumanoidDescription above.
    -- Now try to copy playing animations
    local function copyAnimations()
        local targetAnimator = targetHum:FindFirstChildOfClass("Animator")
        local localAnimator = localHum:FindFirstChildOfClass("Animator")
        if not targetAnimator then
            return
        end
        if not localAnimator then
            -- make an Animator if missing (for R6 it might behave differently)
            localAnimator = Instance.new("Animator")
            localAnimator.Parent = localHum
        end

        local playing = targetHum:GetPlayingAnimationTracks()
        if #playing == 0 then
            -- no playing animations, try to find Animator tracks in target (less likely)
            return
        end

        -- Stop local player's current animation tracks that we loaded previously to avoid duplicates
        -- We'll attempt to play the same animations with same speeds/timeposition
        for _, track in pairs(playing) do
            local anim = track.Animation
            if anim and anim.AnimationId and anim.AnimationId ~= "" then
                local success, newAnimTrack = pcall(function()
                    local a = Instance.new("Animation")
                    a.AnimationId = anim.AnimationId
                    return localAnimator:LoadAnimation(a)
                end)
                if success and newAnimTrack then
                    -- match speed and play
                    newAnimTrack.Priority = track.Priority
                    newAnimTrack:Play()
                    newAnimTrack.TimePosition = track.TimePosition
                    newAnimTrack:AdjustSpeed(track.PlaybackSpeed or track.Speed or 1)
                end
            end
        end
    end

    -- Try copying avatar accessories manually as fallback (best-effort)
    local function tryCloneAccessories()
        for _, item in ipairs(targetChar:GetChildren()) do
            if item:IsA("Accessory") then
                local clone = item:Clone()
                -- remove scripts to be safe
                for _,desc in ipairs(clone:GetDescendants()) do
                    if desc:IsA("Script") or desc:IsA("LocalScript") then
                        desc:Destroy()
                    end
                end
                -- parent to local character
                clone.Parent = localChar
                -- weld handled by Roblox when accessory parented
            end
        end
    end

    -- Run copying attempts with pcall to avoid halting
    pcall(copyAnimations)
    pcall(tryCloneAccessories)

    safeWarn("Selesai mencoba copy. Periksa avatarmu. (Catatan: beberapa asset/anim privat mungkin tidak tersalin.)")
end

copyBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then
        safeWarn("Belum ada pemain yang dipilih.")
        return
    end
    statusLabel.Text = "Memulai proses copy dari "..selectedPlayer.Name.." ..."
    spawn(function()
        copyAvatarFrom(selectedPlayer)
    end)
end)

-- refresh each few seconds to keep list updated
spawn(function()
    while true do
        refreshPlayerList()
        wait(6)
    end
end)

-- optional: close GUI with right-click on title (convenience)
title.MouseButton1Click = function() end -- placeholder to avoid errors

-- end of script
