local SectionText = {}

function SectionText.CreateText(parent: Frame)
	-- suspects text
	local suspectsText = Instance.new("TextLabel")
	suspectsText.Size = UDim2.new(1, -20, 0, 30)
	suspectsText.Position = UDim2.new(0, 10, 0, 120)
	suspectsText.Text = "Suspects: "
	suspectsText.Font = Enum.Font.GothamBold
	suspectsText.TextXAlignment = Enum.TextXAlignment.Left
	suspectsText.RichText = true
	suspectsText.TextScaled = true
	suspectsText.TextColor3 = Color3.new(0.988235, 0.384313, 0.384313)
	suspectsText.BackgroundTransparency = 1
	suspectsText.Parent = parent

	return suspectsText
end

return SectionText
