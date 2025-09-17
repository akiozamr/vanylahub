--// AUTO RECORDER SCRIPT
-- Taruh di StarterPlayerScripts -> LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")

-- Variabel
local isRecording = false
local recordedPath = {}

-- Buat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRecorderGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Tombol Start
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0, 120, 0, 40)
startButton.Position = UDim2.new(0, 20, 0, 100)
startButton.Text = "▶ Start Record"
startButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
startButton.TextColor3 = Color3.fromRGB(255, 255, 255)
startButton.Parent = screenGui

-- Tombol Stop
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(0, 120, 0, 40)
stopButton.Position = UDim2.new(0, 20, 0, 150)
stopButton.Text = "■ Stop Record"
stopButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.Parent = screenGui

-- Fungsi Start
startButton.MouseButton1Click:Connect(function()
	recordedPath = {}
	isRecording = true
	print("⚡ Rekaman dimulai...")
end)

-- Fungsi Stop
stopButton.MouseButton1Click:Connect(function()
	isRecording = false
	print("✅ Rekaman selesai. Hasil kode perjalanan:")
	print("local replayPath = {")
	for i, step in ipairs(recordedPath) do
		print(string.format("    {x=%.2f,y=%.2f,z=%.2f},", step.x, step.y, step.z))
	end
	print("}")
end)

-- Loop rekam posisi
task.spawn(function()
	while true do
		if isRecording and humanoidRoot then
			local pos = humanoidRoot.Position
			table.insert(recordedPath, {x = pos.X, y = pos.Y, z = pos.Z})
		end
		task.wait(0.2) -- rekam tiap 0.2 detik
	end
end)
