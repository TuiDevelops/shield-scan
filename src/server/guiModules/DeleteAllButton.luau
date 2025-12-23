local DeleteAllButton = {}

function DeleteAllButton.CreateButton(parent: Frame)
	-- delete all button
	local delButton = Instance.new("TextButton")
	delButton.Size = UDim2.new(1, -20, 0, 40)
	delButton.Position = UDim2.new(0, 10, 0, 370)
	delButton.Text = "Delete ALL"
	delButton.Font = Enum.Font.GothamBold
	delButton.TextSize = 16
	delButton.TextColor3 = Color3.new(1, 1, 1)
	delButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	delButton.Parent = parent

	return delButton
end

return DeleteAllButton
