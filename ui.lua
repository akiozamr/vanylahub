local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
	Name = "💫 VANYLA HUB",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "VANYLAHub"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local PlayerTab = Window:MakeTab({Name = "Player", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local WalkSpeedBox = PlayerTab:AddTextbox({
	Name = "WalkSpeed",
	Default = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16),
	TextDisappear = false,
	Callback = function(Value)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = tonumber(Value)
		end
	end
})

local JumpBox = PlayerTab:AddTextbox({
	Name = "JumpPower",
	Default = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50),
	TextDisappear = false,
	Callback = function(Value)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = tonumber(Value)
		end
	end
})

local UnlimitedJump = false
PlayerTab:AddToggle({
	Name = "Unlimited Jump",
	Default = false,
	Callback = function(Value)
		UnlimitedJump = Value
	end
})
UIS.JumpRequest:Connect(function()
	if UnlimitedJump then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

PlayerTab:AddDropdown({
	Name = "Morph Player",
	Default = "",
	Options = function()
		local list = {}
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer then
				table.insert(list, v.Name)
			end
		end
		return list
	end,
	Callback = function(Value)
		local target = Players:FindFirstChild(Value)
		if target and target.Character then
			local CloneChar = target.Character:Clone()
			CloneChar.Parent = workspace
			LocalPlayer.Character:Destroy()
			LocalPlayer.Character = CloneChar
			LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
			OrionLib:MakeNotification({
				Name = "Morph Success!",
				Content = "Kamu sekarang morph jadi "..Value,
				Image = "rbxassetid://4483345998",
				Time = 3
			})
		end
	end
})

local OptifineTab = Window:MakeTab({Name = "Optifine", Icon = "rbxassetid://4483345998", PremiumOnly = false})
OptifineTab:AddButton({
	Name = "Anti Lag",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/username/repo/anti-lag.lua"))()
	end
})

local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local SavedCoords = {}

TeleportTab:AddDropdown({
	Name = "Teleport ke Pemain",
	Default = "",
	Options = function()
		local list = {}
		for _,v in pairs(Players:GetPlayers()) do
			if v ~= LocalPlayer then table.insert(list, v.Name) end
		end
		return list
	end,
	Callback = function(Value)
		local target = Players:FindFirstChild(Value)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
		end
	end
})

TeleportTab:AddButton({
	Name = "Save Koordinat",
	Callback = function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(SavedCoords, LocalPlayer.Character.HumanoidRootPart.CFrame)
			OrionLib:MakeNotification({
				Name = "Saved!",
				Content = "Koordinat tersimpan: "..#SavedCoords,
				Image = "rbxassetid://4483345998",
				Time = 3
			})
		end
	end
})

TeleportTab:AddDropdown({
	Name = "Teleport ke Koordinat",
	Default = "",
	Options = function()
		local list = {}
		for i=1,#SavedCoords do
			table.insert(list, "Koordinat "..i)
		end
		return list
	end,
	Callback = function(Value)
		local index = tonumber(string.match(Value, "%d+"))
		if SavedCoords[index] and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = SavedCoords[index]
		end
	end
})

OrionLib:Init()
