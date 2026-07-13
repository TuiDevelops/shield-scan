local MainButtonsFrame = {}

function MainButtonsFrame.CreateFrame(parent: Frame)
	-- main buttons frame
	local mainButtonsFrame = Instance.new("Frame")
	mainButtonsFrame.Position = UDim2.new(0, 10, 0, 50)
	mainButtonsFrame.Size = UDim2.new(1, -20, 0, 70)
	mainButtonsFrame.BorderSizePixel = 0
	mainButtonsFrame.BackgroundTransparency = 1
	mainButtonsFrame.Parent = parent

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0.237, 0, 1, 0)
	grid.CellPadding = UDim2.new(0.01, 0, 0.025, 0)
	grid.Parent = mainButtonsFrame

	return mainButtonsFrame
end

function MainButtonsFrame.CreateMainButton(asset: string, layoutOrder: number, buttonName: string, parent: Frame)
	local newButton = Instance.new("TextButton")
	newButton.Text = ""
	newButton.Name = buttonName
	newButton.BorderSizePixel = 0
	newButton.LayoutOrder = layoutOrder
	newButton.BackgroundColor3 = Color3.fromRGB(28, 30, 32)
	newButton.Parent = parent

	local image = Instance.new("ImageLabel")
	image.BackgroundTransparency = 1
	image.Image = asset
	image.AnchorPoint = Vector2.new(0.5, 0.5)
	image.Size = UDim2.new(0.8, 0, 0.8, 0)
	image.Position = UDim2.new(0.487, 0, 0.588, 0)
	image.Parent = newButton

	local aspectConstraint = Instance.new("UIAspectRatioConstraint")
	aspectConstraint.Parent = image
	aspectConstraint.AspectRatio = 1.066
	aspectConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
	aspectConstraint.DominantAxis = Enum.DominantAxis.Width

	local textLabel = Instance.new("TextLabel")
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Text = buttonName
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.Size = UDim2.new(1, 0, 0.265, 0)
	textLabel.Position = UDim2.new(0.502, 0, 0.138, 0)
	textLabel.Parent = newButton

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0.05, 0)
	uiPadding.PaddingRight = UDim.new(0.05, 0)
	uiPadding.Parent = textLabel

	return newButton
end

return MainButtonsFrame
