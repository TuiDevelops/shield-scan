local ProximityPromptService = game:GetService("ProximityPromptService")
local UI = {}

local widget
local root = script.Parent

local Services = require(script.Parent.Services)
local ServicesToBeScanned = require(root:WaitForChild("ServicesToBeScanned"))

function UI.init(plugin)
	local info = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Right,
		false, -- starts closed
		true, -- can be closed
		350, -- width
		450, -- height
		500, -- min width
		600 -- min height
	)

	widget = plugin:CreateDockWidgetPluginGui("AntiBackdoorWidget", info)

	widget.Title = "Anti-Backdoor Scanner"

	-- root UI
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	frame.Parent = widget

	-- services to be scanned text
	local serviceToScanText = Instance.new("TextLabel")
	serviceToScanText.Size = UDim2.new(1, -20, 0, 30)
	serviceToScanText.Position = UDim2.new(0, 10, 0, 10)
	serviceToScanText.Text = "Services to be scanned: "
	serviceToScanText.Font = Enum.Font.GothamBold
	serviceToScanText.TextXAlignment = Enum.TextXAlignment.Left
	serviceToScanText.RichText = true
	serviceToScanText.TextScaled = true
	serviceToScanText.TextColor3 = Color3.fromRGB(50, 120, 220)
	serviceToScanText.BackgroundTransparency = 1
	serviceToScanText.Parent = frame

	-- services frame
	local servicesFrame = Instance.new("Frame")
	servicesFrame.Position = UDim2.new(0, 10, 0, 50)
	servicesFrame.Size = UDim2.new(1, -20, 0, 120)
	servicesFrame.BorderSizePixel = 0
	servicesFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	servicesFrame.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0.235, 0, 0.2, 0)
	grid.CellPadding = UDim2.new(0.015, 0, 0.025, 0)
	grid.Parent = servicesFrame

	local function updateServiceButtons()
		for _, btn in servicesFrame:GetChildren() do
			if btn:IsA("TextButton") then
				if table.find(ServicesToBeScanned, btn.Text) then
					btn.BackgroundColor3 = Color3.fromRGB(34, 78, 141) -- active
				else
					btn.BackgroundColor3 = Color3.fromRGB(50, 120, 220) -- inactive
				end
			end
		end
	end

	for _, service in Services do
		local serviceButton = Instance.new("TextButton")
		serviceButton.Text = service
		serviceButton.Font = Enum.Font.GothamBold
		serviceButton.TextScaled = true
		serviceButton.TextColor3 = Color3.new(1, 1, 1)
		serviceButton.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
		serviceButton.TextXAlignment = Enum.TextXAlignment.Center
		serviceButton.Parent = servicesFrame

		local name = service
		UI.name = name

		local activated = false

		serviceButton.MouseButton1Click:Connect(function()
			if service == "All Services" then
				table.clear(ServicesToBeScanned)
				table.insert(ServicesToBeScanned, "All Services")
			else
				-- remove All Services if exists
				local i = table.find(ServicesToBeScanned, "All Services")
				if i then
					table.remove(ServicesToBeScanned, i)
				end

				-- toggle normal
				local index = table.find(ServicesToBeScanned, service)
				if index then
					table.remove(ServicesToBeScanned, index)
				else
					table.insert(ServicesToBeScanned, service)
				end
			end

			updateServiceButtons()
		end)
	end

	-- scan button
	local scanBtn = Instance.new("TextButton")
	scanBtn.Size = UDim2.new(1, -20, 0, 40)
	scanBtn.Position = UDim2.new(0, 10, 0, 180)
	scanBtn.Text = "Scan Project"
	scanBtn.Font = Enum.Font.GothamBold
	scanBtn.TextSize = 16
	scanBtn.TextColor3 = Color3.new(1, 1, 1)
	scanBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
	scanBtn.Parent = frame

	-- suspects text
	local suspectsText = Instance.new("TextLabel")
	suspectsText.Size = UDim2.new(1, -20, 0, 30)
	suspectsText.Position = UDim2.new(0, 10, 0, 230)
	suspectsText.Text = "Suspects: "
	suspectsText.Font = Enum.Font.GothamBold
	suspectsText.TextXAlignment = Enum.TextXAlignment.Left
	suspectsText.RichText = true
	suspectsText.TextScaled = true
	suspectsText.TextColor3 = Color3.new(0.988235, 0.384313, 0.384313)
	suspectsText.BackgroundTransparency = 1
	suspectsText.Parent = frame

	-- scrolling frame
	local list = Instance.new("ScrollingFrame")
	list.Position = UDim2.new(0, 10, 0, 270)
	list.Size = UDim2.new(1, -20, 0, 200)
	list.CanvasSize = UDim2.new(0, 0, 0, 0)
	list.ScrollBarImageTransparency = 0.4
	list.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	list.BorderSizePixel = 0
	list.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = list

	-- internal container (IMPORTANT)
	local resultsContainer = Instance.new("Frame")
	resultsContainer.Name = "ResultsContainer"
	resultsContainer.Size = UDim2.new(1, 0, 0, 0)
	resultsContainer.BackgroundTransparency = 1
	resultsContainer.Parent = list

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = resultsContainer

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		resultsContainer.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	-- delete all button
	local delButton = Instance.new("TextButton")
	delButton.Size = UDim2.new(1, -20, 0, 40)
	delButton.Position = UDim2.new(0, 10, 0, 480)
	delButton.Text = "Delete ALL"
	delButton.Font = Enum.Font.GothamBold
	delButton.TextSize = 16
	delButton.TextColor3 = Color3.new(1, 1, 1)
	delButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	delButton.Parent = frame

	UI.scanButton = scanBtn
	UI.suspectsText = suspectsText
	UI.list = list
	UI.deleteButton = delButton
	UI.servicesFrame = servicesFrame
	UI.resultsContainer = resultsContainer
end

-- Adds item to list
function UI.addResult(text)
	local item = Instance.new("TextLabel")
	item.Size = UDim2.new(1, -12, 0, 40)
	item.TextWrapped = true
	item.TextXAlignment = Enum.TextXAlignment.Left
	item.Text = text
	item.Font = Enum.Font.Code
	item.TextSize = 13
	item.TextColor3 = Color3.fromRGB(255, 168, 97)
	item.BackgroundTransparency = 1
	item.Parent = UI.resultsContainer
end

-- clear list
function UI.clearResults()
	if UI.resultsContainer then
		UI.resultsContainer:Destroy()
	end

	local newContainer = Instance.new("Frame")
	newContainer.Name = "ResultsContainer"
	newContainer.Size = UDim2.new(1, 0, 0, 0)
	newContainer.BackgroundTransparency = 1
	newContainer.Parent = UI.list

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = newContainer

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		newContainer.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
		UI.list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	UI.resultsContainer = newContainer
	UI.list.CanvasSize = UDim2.new(0, 0, 0, 0)
end

function UI.toggle()
	if widget then
		widget.Enabled = not widget.Enabled
	end
end

return UI
