local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

local pluginRoot = script.Parent.Parent

local Patterns = require(pluginRoot.Modules:WaitForChild("Patterns"))
local Whitelist = require(pluginRoot.Modules.Whitelist)
local Configs = require(pluginRoot.Configs)

local Scanner = {}

local function isScript(inst)
	return inst:IsA("Script") or inst:IsA("LocalScript") or inst:IsA("ModuleScript")
end

local function isFolder(inst)
	return inst:IsA("Folder")
end

local function isText(inst)
	return inst:IsA("Text") or inst:IsA("TextLabel") or inst:IsA("TextButton")
end

local function getRiskLevel(score)
	if score >= 100 then
		return "Critical"
	elseif score >= 60 then
		return "High"
	elseif score >= 25 then
		return "Medium"
	elseif score > 0 then
		return "Low"
	end

	return "Safe"
end

local function scanText(content)
	local matches = {}
	local totalScore = 0

	for category, entries in pairs(Patterns) do
		for _, entry in ipairs(entries) do
			local count = 0
			local firstMatch = nil
			local searchPos = 1

			while true do
				local startPos, endPos = content:find(entry.pattern, searchPos)

				if not startPos then
					break
				end

				count += 1

				if not firstMatch then
					firstMatch = content:sub(startPos, endPos)
				end

				searchPos = endPos + 1
			end

			if count > 0 then
				table.insert(matches, {
					category = category,

					pattern = entry.pattern,
					display = entry.display,

					matched = firstMatch,
					occurrences = count,

					score = entry.score,
					reason = entry.reason,
				})

				-- repetition bonus
				totalScore += entry.score * math.min(count, 3)
			end
		end
	end

	return matches, totalScore
end

local function scanAttributes(inst)
	local attributes = {}

	for attributeName, value in pairs(inst:GetAttributes()) do
		if typeof(value) == "string" then
			table.insert(attributes, {
				name = attributeName,
				value = value,
			})
		elseif typeof(value) == "number" then
			table.insert(attributes, {
				name = attributeName,
				value = tostring(value),
			})
		end
	end

	return attributes
end

local function quarantine(inst)
	local activated = Configs.Quarantine.activated

	if not activated then
		return
	end

	local folder = ServerStorage:FindFirstChild("Suspicious Scripts")

	if not folder then
		return
	end

	pcall(function()
		inst.Parent = folder
	end)
end

local function markSuspect(inst)
	pcall(function()
		inst:SetAttribute("Suspect", true)
	end)
end

local function analyzeContent(inst, sourceName, content, found)
	if not content or content == "" then
		return
	end

	local matches, score = scanText(content)

	if score <= 0 then
		return
	end

	table.insert(found, {
		instance = inst,
		source = sourceName,
		score = score,
		risk = getRiskLevel(score),
		matches = matches,
	})

	markSuspect(inst)

	if isScript(inst) then
		quarantine(inst)
	end
end

local function findSuspicious(inst, found)
	-- Whitelisted Folders
	if isFolder(inst) then
		if table.find(Whitelist, inst.Name) then
			for _, child in ipairs(inst:GetDescendants()) do
				if isScript(child) or isText(child) then
					table.insert(Whitelist, child.Name)
				end
			end
			return
		end
	end

	-- Scripts
	if isScript(inst) then
		if table.find(Whitelist, inst.Name) then
			return
		end

		local ok, source = pcall(function()
			return inst.Source
		end)

		if ok and source then
			analyzeContent(inst, "Source", source, found)
		end
	end

	-- Text Objects
	if isText(inst) then
		local ok, text = pcall(function()
			return inst.Text
		end)

		if ok and text then
			analyzeContent(inst, "Text", text, found)
		end
	end

	-- Attributes
	local attributes = scanAttributes(inst)

	for _, attribute in ipairs(attributes) do
		analyzeContent(inst, "Attribute: " .. attribute.name, attribute.value, found)

		if #attribute.value > 1000 then
			table.insert(found, {
				instance = inst,
				source = "Attribute: " .. attribute.name,

				score = 15,
				risk = "Medium",

				matches = {
					{
						category = "MediumRisk",
						pattern = "<large_attribute>",
						score = 15,
						reason = "Large attribute payload",
					},
				},
			})
		end
	end

	-- Instance Name
	analyzeContent(inst, "Name", inst.Name, found)

	-- Tags
	local tags = CollectionService:GetTags(inst)

	for _, tag in ipairs(tags) do
		analyzeContent(inst, "Tag: " .. tag, tag, found)
	end
end

function Scanner.scan(services)
	local found = {}

	for _, service in ipairs(services) do
		if service == "All Services" then
			for _, inst in ipairs(game:GetDescendants()) do
				findSuspicious(inst, found)
			end
		else
			for _, inst in ipairs(service:GetDescendants()) do
				findSuspicious(inst, found)
			end
		end
	end

	return found
end

return Scanner
