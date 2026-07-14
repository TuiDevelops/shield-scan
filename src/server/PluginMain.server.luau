local VERSION = "v1.2.0"

-- services
local ServerStorage = game:GetService("ServerStorage")

-- creates toolbar
local toolbar = plugin:CreateToolbar("ShieldScan")
local openButton = toolbar:CreateButton(
	"ShieldScan " .. VERSION,
	"An open source anti-backdoor plugin created by Tui",
	"rbxassetid://127756562383604"
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

	for _, item in ipairs(results) do
		local header =
			string.format("[%s] (%d) %s [%s]", item.risk, item.score, item.instance:GetFullName(), item.source)

		UI.addResult(header)

		for _, match in ipairs(item.matches) do
			local shown = match.display or match.matched or match.pattern

			UI.addResult(string.format("   +%d %s (%s) x%d", match.score, match.reason, shown, match.occurrences or 1))
		end
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

-- Quarantine Config --> toggle button
local activated = Configs.Quarantine.activated
UI.settingsFrame.Quarantine.ToggleButton.MouseButton1Click:Connect(function()
	local quarantine = UI.settingsFrame.Quarantine
	local toggleButton = quarantine.ToggleButton

	if activated then
		activated = false
		Configs.Quarantine.activated = false
		toggleButton.CheckImage.Visible = false
	else
		activated = true
		Configs.Quarantine.activated = true
		toggleButton.CheckImage.Visible = true

		if ServerStorage:FindFirstChild("Suspicious Scripts") then
			warn("Suspicious Scripts Folder already exists")
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
		local suspect = item.instance
		if suspect and suspect.Parent then
			print("Destroying suspicious script:", suspect)
			suspect:Destroy()
		end
	end
end)
