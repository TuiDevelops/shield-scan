local PluginTitle = {}

function PluginTitle.CreateTitle(parent: Frame)
	-- title
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.Text = "ShieldScan"
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.RichText = true
	title.TextScaled = true
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Parent = parent
end

return PluginTitle
