local ProximityPromptService = game:GetService("ProximityPromptService")
local UI = {}

local widget
local root = script.Parent.Parent
local VERSION = "v1.0.0"

-- Modules
local Services = require(root.Modules.Services)
local ServicesToBeScanned = require(root.Modules:WaitForChild("ServicesToBeScanned"))

-- gui modules
local PluginTitle = require(root.guiModules.PluginTitle)
local MainButtonsFrame = require(root.guiModules.MainButtonsFrame)
local SectionText = require(root.guiModules.SectionText)
local MainFrame = require(root.guiModules.MainFrame)
local DeleteAllButton = require(root.guiModules.DeleteAllButton)
local SubmitWhiteListButton = require(root.guiModules.SubmitWhiteListButton)

local function ServicesFrameHandler(servicesFrame)
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
end

function UI.init(plugin)
	local info = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Right,
		false, -- starts closed
		true, -- can be closed
		350, -- width
		568, -- height
		350, -- min width
		568 -- min height
	)

	widget = plugin:CreateDockWidgetPluginGui("ShieldScanWidget", info)

	widget.Title = "ShieldScan " .. VERSION

	-- root UI
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	frame.Parent = widget

	-- title
	local title = PluginTitle.CreateTitle(frame)

	-- main buttons frame
	local mainButtonsFrame = MainButtonsFrame.CreateFrame(frame)
	local scanButton = MainButtonsFrame.CreateMainButton("rbxassetid://108209380749996", 0, "Scan", mainButtonsFrame)

	local settingsButton =
		MainButtonsFrame.CreateMainButton("rbxassetid://115733686981088", 3, "Settings", mainButtonsFrame)

	local whiteListButton =
		MainButtonsFrame.CreateMainButton("rbxassetid://135176127596235", 2, "White List", mainButtonsFrame)

	local servicesButton =
		MainButtonsFrame.CreateMainButton("rbxassetid://128141811125749", 1, "Services", mainButtonsFrame)

	-- suspects text
	local sectionText = SectionText.CreateText(frame)

	-- scrolling frame
	local list = MainFrame.CreateMainFrame(frame)

	-- delete all button
	local delButton = DeleteAllButton.CreateButton(frame)
	-- submitWhitelist button
	local submitWhiteListButton = SubmitWhiteListButton.CreateButton(frame)

	-- main buttons frames (list children)
	local servicesFrame = MainFrame.CreateServicesFrame(list)
	local whiteListFrame = MainFrame.CreateWhiteListFrame(list)
	local settingsFrame = MainFrame.CreateSettingsFrame(list)
	local resultsContainer = MainFrame.CreateInternalContainer(list) -- internal container (IMPORTANT)

	ServicesFrameHandler(servicesFrame)

	-- SETTING UI TABLE

	-- main buttons
	UI.mainButtonsFrame = mainButtonsFrame
	UI.scanButton = scanButton
	UI.settingsButton = settingsButton
	UI.servicesButton = servicesButton
	UI.whiteListButton = whiteListButton

	-- main buttons frames (list children)
	UI.servicesFrame = servicesFrame
	UI.whiteListFrame = whiteListFrame
	UI.resultsContainer = resultsContainer
	UI.settingsFrame = settingsFrame

	-- texts
	UI.titleText = title
	UI.sectionText = sectionText

	-- main frame
	UI.list = list

	-- UI.servicesFrame = servicesFrame
	-- delete button
	UI.deleteButton = delButton
	-- submit whitelist button
	UI.submitWhiteListButton = submitWhiteListButton
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
