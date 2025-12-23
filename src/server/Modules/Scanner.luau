local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")

local pluginRoot = script.Parent.Parent

local Patterns = require(pluginRoot.Modules:WaitForChild("Patterns"))
local ServicesToBeScanned = require(pluginRoot.Modules:WaitForChild("ServicesToBeScanned"))
local Whitelist = require(pluginRoot.Modules.Whitelist)
local Configs = require(pluginRoot.Configs)

local Scanner = {}

local function isScript(inst)
	return inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript")
end

local function whitelistFolderChildren()
	for _, itemName in Whitelist do
		local inst = game:FindFirstChild(itemName, true)
		if not inst then
			warn("Error, some of the items on the whitelist do not exist:", itemName)
			continue
		end
		if not inst:IsA("Folder") then
			continue
		else
			for _, safe in inst:GetDescendants() do
				if isScript(safe) then
					table.insert(Whitelist, safe.Name)
				end
			end
		end
	end
end

local function findBackdoor(inst, found)
	if isScript(inst) then
		local ok, source = pcall(function()
			return inst.Source
		end)

		if ok and source then
			for _, pattern in Patterns do
				if table.find(Whitelist, inst.Name) then
					continue
				end
				if source:find(pattern) then
					table.insert(found, {
						script = inst,
						pattern = pattern,
					})

					-- show in Explorer
					local activated = Configs.Config1.activated
					if activated then
						pcall(function()
							inst:SetAttribute("Suspect", true)
							inst:AddTag("Suspect", true)
							inst.Parent = ServerStorage:FindFirstChild("Suspicious Scripts")
						end)
					else
						pcall(function()
							inst:SetAttribute("Suspect", true)
							inst:AddTag("Suspect", true)
						end)
					end

					break
				end
			end
		end
	end
end

function Scanner.scan(services)
	whitelistFolderChildren()
	local found = {}

	for _, service in services do
		if service == "All Services" then
			for _, instance in game:GetDescendants() do
				findBackdoor(instance, found)
			end
		else
			for _, instance in service:GetDescendants() do
				findBackdoor(instance, found)
			end
		end
	end

	return found
end

return Scanner
