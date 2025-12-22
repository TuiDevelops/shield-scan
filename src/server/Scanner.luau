local CollectionService = game:GetService("CollectionService")

local pluginRoot = script.Parent

local Patterns = require(pluginRoot:WaitForChild("Patterns"))
local ServicesToBeScanned = require(pluginRoot:WaitForChild("ServicesToBeScanned"))

local Scanner = {}

local function isScript(inst)
	return inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript")
end

function Scanner.scan(services)
	local found = {}

	for _, service in services do
		if service == "All Services" then
			for _, instance in game:GetDescendants() do
				if isScript(instance) then
					local ok, source = pcall(function()
						return instance.Source
					end)

					if ok and source then
						for _, pattern in Patterns do
							if source:find(pattern) then
								table.insert(found, {
									script = instance,
									pattern = pattern,
								})

								-- marca no Explorer
								pcall(function()
									instance:SetAttribute("Suspect", true)
									instance:AddTag("Suspect", true)
								end)

								break
							end
						end
					end
				end
			end
		else
			for _, instance in service:GetDescendants() do
				if isScript(instance) then
					local ok, source = pcall(function()
						return instance.Source
					end)

					if ok and source then
						for _, pattern in Patterns do
							if source:find(pattern) then
								table.insert(found, {
									script = instance,
									pattern = pattern,
								})

								-- marca no Explorer
								pcall(function()
									instance:SetAttribute("Suspect", true)
									instance:AddTag("Suspect", true)
								end)

								break
							end
						end
					end
				end
			end
		end
	end

	return found
end

return Scanner
