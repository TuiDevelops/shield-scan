local TextService = game:GetService("TextService")
local MainFrame = {}

local root = script.Parent.Parent

function MainFrame.CreateMainFrame(parent: Frame)
	local list = Instance.new("ScrollingFrame")
	list.Position = UDim2.new(0, 10, 0, 160)
	list.Size = UDim2.new(1, -20, 0, 200)
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.ScrollBarImageTransparency = 0.4
	list.ScrollBarThickness = 2
	list.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	list.BorderSizePixel = 0
	list.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = list

	return list
end

function MainFrame.CreateInternalContainer(parent: Frame)
	-- internal container (IMPORTANT)
	local resultsContainer = Instance.new("Frame")
	resultsContainer.Name = "ResultsContainer"
	resultsContainer.Size = UDim2.new(1, 0, 0, 0)
	resultsContainer.BackgroundTransparency = 1
	resultsContainer.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = resultsContainer

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		resultsContainer.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		parent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	return resultsContainer
end

function MainFrame.CreateSettingsFrame(parent: Frame)
	local settingsFrame = Instance.new("Frame")
	settingsFrame.Name = "SettingsFrame"
	settingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	settingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	settingsFrame.Size = UDim2.new(1, 0, 1, 0)
	settingsFrame.BorderSizePixel = 0
	settingsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	settingsFrame.Parent = parent
	settingsFrame.Visible = false

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0.01, 0)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Parent = settingsFrame

	local config1Text = Instance.new("TextLabel")
	config1Text.Name = "Config1"
	config1Text.TextXAlignment = Enum.TextXAlignment.Left
	config1Text.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
	config1Text.Size = UDim2.new(1, 0, 0.179, 0)
	config1Text.TextScaled = true
	config1Text.TextWrapped = true
	config1Text.Font = Enum.Font.GothamBold
	config1Text.Text = "Move suspicious scripts to a folder automatically?"
	config1Text.TextColor3 = Color3.fromRGB(255, 255, 255)
	config1Text.Parent = settingsFrame

	local paddding = Instance.new("UIPadding")
	paddding.PaddingRight = UDim.new(0.3, 0)
	paddding.Parent = config1Text

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Text = ""
	toggleButton.BackgroundTransparency = 1
	toggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
	toggleButton.Position = UDim2.new(1.35, 0, 0.5, 0)
	toggleButton.Size = UDim2.new(0.082, 0, 0.57, 0)
	toggleButton.Parent = config1Text

	local stroke = Instance.new("UIStroke")
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	stroke.Thickness = 0.15
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Parent = toggleButton

	local checkImage = Instance.new("ImageLabel")
	checkImage.Name = "CheckImage"
	checkImage.AnchorPoint = Vector2.new(0.5, 0.5)
	checkImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	checkImage.Size = UDim2.new(1, 0, 1, 0)
	checkImage.Visible = false
	checkImage.Image = "rbxassetid://98830532951053"
	checkImage.Parent = toggleButton

	return settingsFrame
end

function MainFrame.CreateServicesFrame(parent: Frame)
	-- services frame
	local servicesFrame = Instance.new("Frame")
	servicesFrame.Name = "ServicesFrame"
	servicesFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	servicesFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	servicesFrame.Size = UDim2.new(1, 0, 1, 0)
	servicesFrame.BorderSizePixel = 0
	servicesFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	servicesFrame.Parent = parent
	servicesFrame.Visible = false

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0.235, 0, 0.2, 0)
	grid.CellPadding = UDim2.new(0.015, 0, 0.025, 0)
	grid.Parent = servicesFrame

	return servicesFrame
end

function MainFrame.CreateWhiteListFrame(parent: Frame)
	-- whitelist frame
	local whiteListFrame = Instance.new("ScrollingFrame")
	whiteListFrame.ScrollBarImageTransparency = 0.4
	whiteListFrame.ScrollBarThickness = 2
	whiteListFrame.Name = "WhiteListFrame"
	whiteListFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	whiteListFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	whiteListFrame.Size = UDim2.new(1, 0, 1, 0)
	whiteListFrame.BorderSizePixel = 0
	whiteListFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	whiteListFrame.Parent = parent
	whiteListFrame.Visible = false

	local layout = Instance.new("UIListLayout")
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Padding = UDim.new(0.01, 0)
	layout.Parent = whiteListFrame

	local textBoxTemplate = Instance.new("TextBox")
	textBoxTemplate.Name = "Template"
	textBoxTemplate.Text = ""
	textBoxTemplate.BorderSizePixel = 0
	textBoxTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
	textBoxTemplate.Size = UDim2.new(0.977, 0, 0.09, 0)
	textBoxTemplate.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	textBoxTemplate.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
	textBoxTemplate.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
	textBoxTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBoxTemplate.TextXAlignment = Enum.TextXAlignment.Center
	textBoxTemplate.TextScaled = true
	textBoxTemplate.PlaceholderText = "Write the name of a folder or script here"
	textBoxTemplate.LayoutOrder = 0
	textBoxTemplate.Parent = whiteListFrame
	textBoxTemplate.Visible = false

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0.05, 0)
	uiPadding.PaddingRight = UDim.new(0.05, 0)
	uiPadding.Parent = textBoxTemplate

	local clone = textBoxTemplate:Clone()
	clone.Name = "Whitelisted"
	clone.Parent = whiteListFrame
	clone.Visible = true

	local addButton = Instance.new("TextButton")
	addButton.Name = "AddButton"
	addButton.BorderSizePixel = 0
	addButton.AnchorPoint = Vector2.new(0.5, 0.5)
	addButton.Size = UDim2.new(0.977, 0, 0.09, 0)
	addButton.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	addButton.BackgroundColor3 = Color3.fromRGB(54, 54, 54)
	addButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	addButton.Text = "Add Scripts or Folders"
	addButton.TextScaled = true
	addButton.LayoutOrder = 99
	addButton.TextXAlignment = Enum.TextXAlignment.Center
	addButton.Parent = whiteListFrame
	addButton.Visible = true
	uiPadding:Clone().Parent = addButton

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = addButton

	local currentItemsInTheWhitelist = 1
	addButton.MouseButton1Click:Connect(function()
		if currentItemsInTheWhitelist > 99 then
			return
		end

		currentItemsInTheWhitelist += 1
		local newClone = textBoxTemplate:Clone()
		newClone.Name = "Whitelisted"
		newClone.Parent = whiteListFrame
		newClone.Visible = true
	end)

	return whiteListFrame
end

return MainFrame
