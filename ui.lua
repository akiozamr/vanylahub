local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
end)

local unlimitedJump = false
local isOptimized, isUltraMode = false, false
local optimizedParts = {}
local hiddenPlayers, tagHidden = false, false
local espEnabled = false
local espObjects = {}
local flyEnabled = false
local flySpeed = 50
local flyBody = nil
local noclipEnabled = false
local godEnabled = false
local antiAfkEnabled = false

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name="VANYLA HUB",HidePremium=false,SaveConfig=true,ConfigFolder="VanylaHub"})

local TabPlayer = Window:MakeTab({Name="Player",Icon="rbxassetid://4483345998"})
local TabVisual = Window:MakeTab({Name="Visual",Icon="rbxassetid://4483345998"})
local TabUtil = Window:MakeTab({Name="Utility",Icon="rbxassetid://4483345998"})
local TabFun = Window:MakeTab({Name="Fun",Icon="rbxassetid://4483345998"})
local TabOpti = Window:MakeTab({Name="Optifine",Icon="rbxassetid://4483345998"})
local TabTP = Window:MakeTab({Name="Teleport",Icon="rbxassetid://4483345998"})

TabPlayer:AddTextbox({Name="WalkSpeed",Default=tostring(humanoid.WalkSpeed),TextDisappear=false,Callback=function(v)local n=tonumber(v) if n and humanoid and humanoid.Parent then humanoid.WalkSpeed=n end end})
TabPlayer:AddTextbox({Name="JumpPower",Default=tostring(humanoid.JumpPower),TextDisappear=false,Callback=function(v)local n=tonumber(v) if n and humanoid and humanoid.Parent then humanoid.JumpPower=n end end})
TabPlayer:AddToggle({Name="Unlimited Jump",Default=false,Callback=function(v) unlimitedJump=v end})
TabPlayer:AddToggle({Name="NoClip",Default=false,Callback=function(v) noclipEnabled=v end})
TabPlayer:AddToggle({Name="Fly",Default=false,Callback=function(v) flyEnabled=v if not flyEnabled and flyBody then flyBody:Destroy() flyBody=nil end end})
TabPlayer:AddSlider({Name="Fly Speed",Min=10,Max=200,Default=50,Increment=5,ValueName="speed",Callback=function(v) flySpeed=v end})
TabPlayer:AddToggle({Name="GodMode",Default=false,Callback=function(v) godEnabled=v if godEnabled and humanoid then humanoid.MaxHealth=9e9 humanoid.Health=humanoid.MaxHealth end end})
TabPlayer:AddButton({Name="Sit / Stand",Callback=function() if humanoid then humanoid.Sit = not humanoid.Sit end end})

TabVisual:AddToggle({Name="ESP",Default=false,Callback=function(v) espEnabled=v if not espEnabled then for _,obj in pairs(espObjects) do if obj and obj.Parent then obj:Destroy() end end espObjects={} end end})
TabVisual:AddToggle({Name="FullBright",Default=false,Callback=function(v) if v then pcall(function() Lighting.Ambient=Color3.fromRGB(255,255,255) Lighting.Brightness=2 end) else pcall(function() Lighting.Ambient=Color3.fromRGB(178,178,178) Lighting.Brightness=1 end) end})
TabVisual:AddToggle({Name="X-Ray",Default=false,Callback=function(v) if v then for _,obj in pairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and obj.Name~="Terrain" and not obj:IsDescendantOf(player.Character) then obj.LocalTransparencyModifier = 0.6 end end else for _,obj in pairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") and obj.Name~="Terrain" then obj.LocalTransparencyModifier = 0 end end end end})
TabVisual:AddToggle({Name="Night Vision",Default=false,Callback=function(v) if v then local nv=Instance.new("ColorCorrectionEffect",Lighting) nv.Name="NV_VANYLA" nv.Brightness,nv.Contrast,nv.Saturation=0.3,0.2,0.8 nv.TintColor=Color3.fromRGB(200,255,200) else if Lighting:FindFirstChild("NV_VANYLA") then Lighting.NV_VANYLA:Destroy() end end end})

TabOpti:AddButton({Name="Optimize Mode",Callback=function()
	if isOptimized then return end
	isOptimized=true
	for _,obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			table.insert(optimizedParts,obj)
			obj.Material=Enum.Material.SmoothPlastic
			obj.Reflectance=0
			if obj:FindFirstChildOfClass("SurfaceAppearance") then obj:FindFirstChildOfClass("SurfaceAppearance"):Destroy() end
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			obj.Enabled=false
		elseif obj:IsA("Highlight") then
			obj.Enabled=false
		end
	end
	Lighting.GlobalShadows=false
	Lighting.FogEnd=1e6
end})
TabOpti:AddButton({Name="Ultra Optimize",Callback=function()
	if isUltraMode then return end
	isUltraMode=true
	if not isOptimized then TabOpti.Buttons and TabOpti.Buttons["Optimize Mode"] and TabOpti.Buttons["Optimize Mode"].Callback() end
	Lighting.Technology=Enum.Technology.Legacy
	Lighting.FogEnd,Lighting.FogStart=1e6,1e6
	Lighting.Brightness=5
	Lighting.Ambient=Color3.fromRGB(178,178,178)
	for _,obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false
		elseif obj:IsA("SurfaceAppearance") then obj:Destroy()
		elseif obj:IsA("Highlight") then obj.Enabled=false
		elseif obj:IsA("Sound") and obj.IsPlaying then obj.Volume=obj.Volume*0.5
		elseif obj:IsA("BasePart") then obj.Material=Enum.Material.SmoothPlastic obj.Reflectance=0 end
	end
end})
TabOpti:AddToggle({Name="Hide NameTags",Default=false,Callback=function(v) tagHidden=v for _,plr in pairs(Players:GetPlayers()) do if plr.Character and plr.Character:FindFirstChild("Head") then local nh=plr.Character.Head:FindFirstChild("Nametag") or plr.Character.Head:FindFirstChild("NameTag") if nh and nh:IsA("BillboardGui") then nh.Enabled=not tagHidden end end end end})
TabOpti:AddToggle({Name="Hide Players",Default=false,Callback=function(v) hiddenPlayers=v for _,plr in pairs(Players:GetPlayers()) do if plr~=player and plr.Character then for _,part in pairs(plr.Character:GetDescendants()) do if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = hiddenPlayers and 1 or 0 end end end end end})

TabUtil:AddToggle({Name="Anti-AFK",Default=false,Callback=function(v) antiAfkEnabled=v end})
TabUtil:AddButton({Name="Rejoin",Callback=function() TeleportService:Teleport(game.PlaceId,player) end})
TabUtil:AddButton({Name="Reset Character",Callback=function() if character and character:FindFirstChild("HumanoidRootPart") then character:BreakJoints() end end})
do
	local playersList = {}
	for _,p in pairs(Players:GetPlayers()) do table.insert(playersList,p.Name) end
	local dropdown = TabUtil:AddDropdown({Name="Teleport To Player",Default=playersList[1] or "",Options=playersList,Callback=function(v) local target = Players:FindFirstChild(v) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and character and character:FindFirstChild("HumanoidRootPart") then character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame end end})
	Players.PlayerAdded:Connect(function(p) dropdown:Refresh((function() local t={} for _,pl in pairs(Players:GetPlayers()) do table.insert(t,pl.Name) end return t end)(),true) end)
	Players.PlayerRemoving:Connect(function() dropdown:Refresh((function() local t={} for _,pl in pairs(Players:GetPlayers()) do table.insert(t,pl.Name) end return t end)(),true) end)
end

TabTP:AddTextbox({Name="Coords (x,y,z)",Default="",TextDisappear=false,Callback=function(v)local coords={} for c in string.gmatch(v,"[^,]+") do table.insert(coords,tonumber(c)) end if #coords==3 and character:FindFirstChild("HumanoidRootPart") then character.HumanoidRootPart.CFrame=CFrame.new(coords[1],coords[2]+5,coords[3]) end end})

do
	local playersNames = {}
	for _,p in pairs(Players:GetPlayers()) do table.insert(playersNames,p.Name) end
	local dropdown = TabFun:AddDropdown({Name="Morph Player",Default=playersNames[1] or "",Options=playersNames,Callback=function(v) local target = Players:FindFirstChild(v) if target then local ok,desc = pcall(function() return Players:GetHumanoidDescriptionFromUserIdAsync(target.UserId) end) if ok and desc and humanoid and humanoid.Parent then humanoid:ApplyDescription(desc) end end end})
	Players.PlayerAdded:Connect(function(p) dropdown:Refresh((function() local t={} for _,pl in pairs(Players:GetPlayers()) do table.insert(t,pl.Name) end return t end)(),true) end)
	Players.PlayerRemoving:Connect(function() dropdown:Refresh((function() local t={} for _,pl in pairs(Players:GetPlayers()) do table.insert(t,pl.Name) end return t end)(),true) end)
	TabFun:AddButton({Name="Reset Morph",Callback=function() if humanoid and humanoid.Parent then local desc = humanoid:GetAppliedDescription and humanoid:GetAppliedDescription() if desc then humanoid:ApplyDescription(desc) end end end})
	TabFun:AddButton({Name="Dance (Play Animation)",Callback=function()
		if humanoid and humanoid.Parent then
			local anim = Instance.new("Animation")
			anim.AnimationId = "rbxassetid://243990076" 
			local track = humanoid:LoadAnimation(anim)
			track:Play()
		end
	end})
	TabFun:AddToggle({Name="Spin",Default=false,Callback=function(v) if v then local hrp=character:FindFirstChild("HumanoidRootPart") if hrp then coroutine.wrap(function() while v and hrp and hrp.Parent do hrp.CFrame = hrp.CFrame * CFrame.Angles(0,math.rad(10),0) wait(0.05) end end)() end else end end})
end

RunService.RenderStepped:Connect(function()
	if unlimitedJump and humanoid and humanoid.Parent then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
	if noclipEnabled and character then for _,p in pairs(character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
	if espEnabled then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr~=player and plr.Character and plr.Character:FindFirstChild("Head") then
				if not espObjects[plr] then
					local bg = Instance.new("BillboardGui")
					bg.Name = "VanylaESP"
					bg.Size = UDim2.new(0,100,0,40)
					bg.Adornee = plr.Character:FindFirstChild("Head")
					bg.AlwaysOnTop = true
					bg.Parent = workspace.CurrentCamera
					local label = Instance.new("TextLabel",bg)
					label.Size = UDim2.new(1,0,1,0)
					label.BackgroundTransparency = 1
					label.Text = plr.Name
					label.TextStrokeTransparency = 0
					label.TextColor3 = Color3.fromRGB(255,255,255)
					label.Font = Enum.Font.GothamBold
					label.TextScaled = true
					espObjects[plr] = bg
				else
					local bg = espObjects[plr]
					if not bg.Parent then espObjects[plr]=nil end
				end
			end
		end
		for pl,gui in pairs(espObjects) do if (not pl or not pl.Parent) or (not pl.Character) then if gui and gui.Parent then gui:Destroy() end espObjects[pl]=nil end end
	else
		for _,g in pairs(espObjects) do if g and g.Parent then g:Destroy() end end
		espObjects = {}
	end
	if flyEnabled and character and character:FindFirstChild("HumanoidRootPart") then
		local hrp = character.HumanoidRootPart
		if not flyBody then
			local bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(9e9,9e9,9e9)
			bv.P = 1250
			bv.Parent = hrp
			flyBody = bv
		end
		local moveVec = Vector3.new()
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + (workspace.CurrentCamera.CFrame.LookVector) end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - (workspace.CurrentCamera.CFrame.LookVector) end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - (workspace.CurrentCamera.CFrame.RightVector) end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + (workspace.CurrentCamera.CFrame.RightVector) end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec - Vector3.new(0,1,0) end
		if flyBody then
			if moveVec.Magnitude > 0 then
				flyBody.Velocity = moveVec.Unit * flySpeed
			else
				flyBody.Velocity = Vector3.new(0,0,0)
			end
		end
	end
	if godEnabled and humanoid then humanoid.MaxHealth = 9e9 if humanoid.Health < humanoid.MaxHealth then humanoid.Health = humanoid.MaxHealth end end
	if antiAfkEnabled then
		local Virtual = UserInputService
		pcall(function() Virtual:CaptureController() end)
	end
end)

UserInputService.JumpRequest:Connect(function()
	if unlimitedJump and humanoid and humanoid.Parent then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

Players.PlayerRemoving:Connect(function(pl)
	if espObjects[pl] then if espObjects[pl].Parent then espObjects[pl]:Destroy() end espObjects[pl]=nil end
end)

OrionLib:Init()
