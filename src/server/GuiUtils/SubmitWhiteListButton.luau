local SubmitWhitelist = {}

function SubmitWhitelist.CreateButton(parent: Frame)
	-- delete all button
	local submitButton = Instance.new("TextButton")
	submitButton.Size = UDim2.new(1, -20, 0, 40)
	submitButton.Position = UDim2.new(0, 10, 0, 370)
	submitButton.Text = "Submit Whitelist"
	submitButton.Font = Enum.Font.GothamBold
	submitButton.TextSize = 16
	submitButton.TextColor3 = Color3.new(1, 1, 1)
	submitButton.BackgroundColor3 = Color3.fromRGB(71, 151, 255)
	submitButton.Visible = false
	submitButton.Parent = parent

	return submitButton
end

return SubmitWhitelist
