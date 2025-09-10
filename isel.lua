local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeleportCheckpoint"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0.5, -160, 0.4, -200)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(40,40,60)
title.Text = "Teleport Checkpoint"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6

local UIList = Instance.new("UIListLayout", scroll)
UIList.Padding = UDim.new(0,5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function teleportTo(part)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,5,0)
    end
end

local function addCheckpointButton(part)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = "Checkpoint: " .. part.Name
    btn.BackgroundColor3 = Color3.fromRGB(100,150,250)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(function()
        teleportTo(part)
    end)
end

for _,obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and (obj.Name:lower():find("checkpoint") or obj.Name:lower():find("spawn")) then
        addCheckpointButton(obj)
    end
end

scroll.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y)