local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarCopierByName"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 150)
main.Position = UDim2.new(0.7, 0, 0.3, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Parent = screenGui
local corner = Instance.new("UICorner", main); corner.CornerRadius = UDim.new(0,8)
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,36)
top.BackgroundTransparency = 1
local title = Instance.new("TextButton", top)
title.Size = UDim2.new(0.7, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Avatar Copier (by username)"
title.TextColor3 = Color3.fromRGB(230,230,230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.AutoButtonColor = false
local minBtn = Instance.new("TextButton", top)
minBtn.Size = UDim2.new(0, 34, 0, 24)
minBtn.Position = UDim2.new(1, -44, 0, 6)
minBtn.AnchorPoint = Vector2.new(1,0)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.BackgroundTransparency = 0.12
minBtn.BorderSizePixel = 0
minBtn.TextColor3 = Color3.fromRGB(220,220,220)
local minCorner = Instance.new("UICorner", minBtn); minCorner.CornerRadius = UDim.new(0,6)
local inputLabel = Instance.new("TextLabel", main)
inputLabel.Size = UDim2.new(1, -20, 0, 20)
inputLabel.Position = UDim2.new(0, 10, 0, 46)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Masukkan username (exact):"
inputLabel.TextColor3 = Color3.fromRGB(200,200,200)
inputLabel.Font = Enum.Font.Gotham
inputLabel.TextSize = 13
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
local input = Instance.new("TextBox", main)
input.Size = UDim2.new(1, -20, 0, 34)
input.Position = UDim2.new(0, 10, 0, 70)
input.PlaceholderText = "Contoh: Builderman"
input.ClearTextOnFocus = false
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.Text = ""
input.BackgroundColor3 = Color3.fromRGB(45,45,45)
input.TextColor3 = Color3.fromRGB(240,240,240)
local copyBtn = Instance.new("TextButton", main)
copyBtn.Size = UDim2.new(1, -20, 0, 36)
copyBtn.Position = UDim2.new(0, 10, 1, -46)
copyBtn.Text = "Copy Avatar"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
copyBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
copyBtn.TextColor3 = Color3.fromRGB(240,240,240)
local cbCorner = Instance.new("UICorner", copyBtn); cbCorner.CornerRadius = UDim.new(0,6)
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0, 18)
status.Position = UDim2.new(0, 10, 1, -22)
status.BackgroundTransparency = 1
status.Text = "Siap."
status.TextColor3 = Color3.fromRGB(180,180,180)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		TweenService:Create(main, TweenInfo.new(0.18), {Size = UDim2.new(0, 200, 0, 36)}):Play()
		input.Visible = false
		inputLabel.Visible = false
		copyBtn.Visible = false
		status.Visible = false
		title.Text = "Avatar Copier (min)"
	else
		TweenService:Create(main, TweenInfo.new(0.18), {Size = UDim2.new(0, 340, 0, 150)}):Play()
		input.Visible = true
		inputLabel.Visible = true
		copyBtn.Visible = true
		status.Visible = true
		title.Text = "Avatar Copier (by username)"
	end
end)
local function setStatus(txt)
	status.Text = tostring(txt)
end
local function copyByUsername(username)
	if not username or username:match("^%s*$") then
		setStatus("Masukkan username yang valid.")
		return
	end
	setStatus("Mencari username: "..username.." ...")
	local targetPlayer = nil
	for _,pl in ipairs(Players:GetPlayers()) do
		if string.lower(pl.Name) == string.lower(username) then
			targetPlayer = pl
			break
		end
	end
	local humanoid = nil
	if player.Character then
		humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	end
	if not humanoid then
		setStatus("Karaktermu belum spawn.")
		return
	end
	if targetPlayer then
		setStatus("Player ditemukan online: "..targetPlayer.Name..". Mengambil deskripsi...")
		local ok, desc = pcall(function()
			return Players:GetHumanoidDescriptionFromUserId(targetPlayer.UserId)
		end)
		if ok and desc then
			local appliedOk, err = pcall(function()
				humanoid:ApplyDescription(desc)
			end)
			if appliedOk then
				setStatus("Sukses! Avatar disalin dari "..targetPlayer.Name)
			else
				setStatus("Gagal apply description: "..tostring(err))
			end
		else
			setStatus("Gagal ambil description dari server.")
		end
		return
	end
	local ok, userIdOrErr = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)
	if not ok then
		setStatus("Nama tidak ditemukan atau terjadi error: "..tostring(userIdOrErr))
		return
	end
	local targetUserId = userIdOrErr
	setStatus("UserId ditemukan: "..tostring(targetUserId)..". Mengambil deskripsi...")
	local ok2, desc2 = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(targetUserId)
	end)
	if not ok2 or not desc2 then
		setStatus("Gagal ambil HumanoidDescription untuk userId "..tostring(targetUserId))
		return
	end
	local appliedOk2, err2 = pcall(function()
		humanoid:ApplyDescription(desc2)
	end)
	if appliedOk2 then
		setStatus("Sukses! Avatar disalin dari username: "..username)
	else
		setStatus("Gagal apply description: "..tostring(err2))
	end
end
copyBtn.MouseButton1Click:Connect(function()
	local name = input.Text or ""
	copyByUsername(name)
end)
input.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local name = input.Text or ""
		copyByUsername(name)
	end
end)
