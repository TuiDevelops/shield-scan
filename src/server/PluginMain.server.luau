local ServerStorage = game:GetService("ServerStorage")

-- creates toolbar
local toolbar = plugin:CreateToolbar("ShieldScan")
local openButton = toolbar:CreateButton(
	"ShieldScan",
	"An open source anti-backboor plugin created by TuiDevelops",
	"rbxassetid://109786044386715"
)

local root = script.Parent

local Scanner = require(root.Modules:WaitForChild("Scanner"))
local UI = require(root.Modules:WaitForChild("UI"))
local ServicesToBeScanned = require(root.Modules:WaitForChild("ServicesToBeScanned"))
local Whitelist = require(root.Modules.Whitelist)
local Configs = require(root.Configs)

-- initialize UI
UI.init(plugin)

local function SetVisibility(exception)
	for _, item in UI.list:GetChildren() do
		if item:IsA("Frame") or item:IsA("ScrollingFrame") then
			if item.Name ~= exception then
				item.Visible = false
			else
				item.Visible = true
			end
		end
	end
end

-- open / close window
openButton.Click:Connect(function()
	UI.toggle()
end)

-- Connect Scan button
local results = nil
UI.scanButton.MouseButton1Click:Connect(function()
	SetVisibility("ResultsContainer")
	UI.deleteButton.Visible = true
	UI.submitWhiteListButton.Visible = false
	UI.sectionText.Text = "Suspects:"
	UI.sectionText.TextColor3 = Color3.new(0.988235, 0.384313, 0.384313)
	UI.clearResults()

	local services = {}

	for _, name in ServicesToBeScanned do
		if name == "All Services" then
			services = { "All Services" }
			break
		end

		local ok, service = pcall(game.GetService, game, name)
		if ok then
			table.insert(services, service)
		end
	end

	results = Scanner.scan(services)

	if #results == 0 then
		UI.addResult("No suspicious patterns found.")
		return
	end

	for _, item in results do
		UI.addResult(item.script:GetFullName() .. "  |  " .. item.pattern)
	end
end)

-- services button
UI.servicesButton.MouseButton1Click:Connect(function()
	SetVisibility("ServicesFrame")
	UI.deleteButton.Visible = false
	UI.submitWhiteListButton.Visible = false
	UI.sectionText.Text = "Services to Scan:"
	UI.sectionText.TextColor3 = Color3.fromRGB(71, 151, 255)
end)

-- whitelist button
UI.whiteListButton.MouseButton1Click:Connect(function()
	SetVisibility("WhiteListFrame")
	UI.deleteButton.Visible = false
	UI.submitWhiteListButton.Visible = true
	UI.sectionText.Text = "White List:"
	UI.sectionText.TextColor3 = Color3.fromRGB(71, 151, 255)
end)

-- settings button
UI.settingsButton.MouseButton1Click:Connect(function()
	SetVisibility("SettingsFrame")
	UI.deleteButton.Visible = false
	UI.submitWhiteListButton.Visible = false
	UI.sectionText.Text = "Settings:"
	UI.sectionText.TextColor3 = Color3.fromRGB(71, 151, 255)
end)

-- config 1 --> toggle button
local activated = Configs.Config1.activated
UI.settingsFrame.Config1.ToggleButton.MouseButton1Click:Connect(function()
	local config1 = UI.settingsFrame.Config1
	local toggleButton = config1.ToggleButton

	if activated then
		activated = false
		toggleButton.CheckImage.Visible = false
		local oldFolder = ServerStorage:FindFirstChild("Suspicious Scripts")
		if oldFolder then
			oldFolder:Destroy()
		else
			warn("Old Folder not found")
		end
	else
		activated = true
		toggleButton.CheckImage.Visible = true
		if ServerStorage:FindFirstChild("Suspicious Scripts") then
			warn("Folder already exists")
			return
		else
			local newFolder = Instance.new("Folder")
			newFolder.Name = "Suspicious Scripts"
			newFolder.Parent = ServerStorage
		end
	end
end)

-- connect submit whitelist button
UI.submitWhiteListButton.MouseButton1Click:Connect(function()
	table.clear(Whitelist)
	for _, item in UI.whiteListFrame:GetChildren() do
		if item:IsA("TextBox") and item.Name ~= "Template" then
			local text = item.Text
			if text == "" then
				warn("Item without a name on the whitelist:", text)
				continue
			else
				table.insert(Whitelist, text)
			end
		end
	end
	UI.submitWhiteListButton.Text = "WhiteList Submited!"
	task.wait(1)
	UI.submitWhiteListButton.Text = "Submit WhiteList"
end)

-- connect delete all button
UI.deleteButton.MouseButton1Click:Connect(function()
	for _, item in results do
		local backdoor = item.script
		print("Destroying suspicious script:", backdoor)
		backdoor:Destroy()
	end
end)
