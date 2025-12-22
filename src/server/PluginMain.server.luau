-- creates toolbar
local toolbar = plugin:CreateToolbar("Anti-Backdoor")
local openButton = toolbar:CreateButton("Open", "Open Plugin", "rbxassetid://4458901886")

local root = script.Parent

local Scanner = require(root:WaitForChild("Scanner"))
local UI = require(root:WaitForChild("UI"))
local ServicesToBeScanned = require(root:WaitForChild("ServicesToBeScanned"))

-- initialize UI
UI.init(plugin)

-- open / close window
openButton.Click:Connect(function()
	UI.toggle()
end)

-- Connect Scan button
local results = nil
UI.scanButton.MouseButton1Click:Connect(function()
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

-- connect delete all button
UI.deleteButton.MouseButton1Click:Connect(function()
	for _, item in results do
		local backdoor = item.script
		backdoor:Destroy()
	end
end)
