local Players = game:GetService("Players")
local me = Players.LocalPlayer
local playerGui = me:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local usernameBox = Instance.new("TextBox", frame)
usernameBox.Size = UDim2.new(0.8, 0, 0.3, 0)
usernameBox.Position = UDim2.new(0.1, 0, 0.1, 0)
usernameBox.PlaceholderText = "Masukkan Username"
usernameBox.Text = ""
usernameBox.TextScaled = true

local copyButton = Instance.new("TextButton", frame)
copyButton.Size = UDim2.new(0.6, 0, 0.3, 0)
copyButton.Position = UDim2.new(0.2, 0, 0.55, 0)
copyButton.Text = "Copy Avatar"
copyButton.TextScaled = true
copyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)

local function copyAvatarFromUsername(username)
    local success, targetUserId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not success then return end
    local success2, description = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(targetUserId)
    end)
    if success2 and me.Character and me.Character:FindFirstChild("Humanoid") then
        me.Character.Humanoid:ApplyDescription(description)
    end
end

copyButton.MouseButton1Click:Connect(function()
    local username = usernameBox.Text
    if username and username ~= "" then
        copyAvatarFromUsername(username)
    end
end)
