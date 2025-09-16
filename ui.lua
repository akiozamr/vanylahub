local SimpleUILib = {}

local function makeDraggable(gui)
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

function SimpleUILib.CreateWindow(opts)
	opts = opts or {}
	local title = opts.Title or "Window"

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SimpleUILibGui"
	screenGui.ResetOnSpawn = false

	local window = Instance.new("Frame")
	window.Name = "Window"
	window.Size = UDim2.new(0, 400, 0, 260)
	window.Position = UDim2.new(0.3, 0, 0.25, 0)
	window.AnchorPoint = Vector2.new(0,0)
	window.BackgroundColor3 = Color3.fromRGB(30,30,30)
	window.BorderSizePixel = 0
	window.Parent = screenGui

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 28)
	titleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = window

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -60, 1, 0)
	titleLabel.Position = UDim2.new(0, 8, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = Color3.fromRGB(235,235,235)
	titleLabel.Parent = titleBar

	local btnMin = Instance.new("TextButton")
	btnMin.Name = "Minimize"
	btnMin.Size = UDim2.new(0, 44, 1, 0)
	btnMin.Position = UDim2.new(1, -48, 0, 0)
	btnMin.AnchorPoint = Vector2.new(0,0)
	btnMin.BackgroundTransparency = 0
	btnMin.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btnMin.BorderSizePixel = 0
	btnMin.Text = "-"
	btnMin.Font = Enum.Font.Gotham
	btnMin.TextSize = 18
	btnMin.TextColor3 = Color3.fromRGB(235,235,235)
	btnMin.Parent = titleBar

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -28)
	content.Position = UDim2.new(0, 0, 0, 28)
	content.BackgroundColor3 = Color3.fromRGB(28,28,28)
	content.BorderSizePixel = 0
	content.Parent = window

	local uiList = Instance.new("UIListLayout")
	uiList.Padding = UDim.new(0, 6)
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Parent = content

	local minimized = false
	btnMin.MouseButton1Click:Connect(function()
		minimized = not minimized
		if minimized then
			content.Visible = false
			window.Size = UDim2.new(0, 200, 0, 28)
		else
			content.Visible = true
			window.Size = UDim2.new(0, 400, 0, 260)
		end
	end)

	makeDraggable(titleBar)

	screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

	local api = {}
	api.Root = window
	api.Content = content
	api.ScreenGui = screenGui
	api.SetTitle = function(text) titleLabel.Text = text end
	api.Destroy = function() screenGui:Destroy() end
	return api
end

return SimpleUILib
