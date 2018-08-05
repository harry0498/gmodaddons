include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

	ang:RotateAroundAxis(self:GetForward(), 90)
	ang:RotateAroundAxis(self:GetUp(), 90)

	cam.Start3D2D(pos - (self:GetRight() * -10.5) + (self:GetUp() * 15.5) + (self:GetForward() * 13), ang, 0.1)

	draw.RoundedBox(0, 0, 0, 200, 100, Color(0, 0, 0, 230))
	draw.RoundedBox(0, 5, 5, 190, 90, Color(0, 0, 0, 255))
	draw.SimpleText("Paper:", "HudHintTextLarge", 10, 10, Color(65, 255, 0), 0, 0)
	draw.SimpleText(self:GetPaperAmount(), "HudHintTextLarge", 190, 10, Color(65, 255, 0), 2, 0)
	draw.SimpleText("Print Rate:", "HudHintTextLarge", 10, 30, Color(65, 255, 0), 0, 0)

	if self:GetPaperAmount() > 0 then
		draw.SimpleText("£" .. math.Round((self:GetPrintAmount() / self:GetPrintDelay())) .. "/s", "HudHintTextLarge", 190, 30, Color(65, 255, 0), 2, 0)
	else
		draw.SimpleText("£" .. (0) .. "/s", "HudHintTextLarge", 190, 30, Color(65, 255, 0), 2, 0)
	end

	draw.SimpleText("Potential Amount:", "HudHintTextLarge", 10, 50, Color(65, 255, 0), 0, 0)
	draw.SimpleText("£" .. (self:GetPaperAmount() * self:GetPrintAmount()), "HudHintTextLarge", 190, 50, Color(65, 255, 0), 2, 0)

	draw.SimpleText("Time Until Empty:", "HudHintTextLarge", 10, 70, Color(65, 255, 0), 0, 0)
	draw.SimpleText(string.FormattedTime(self:GetPaperAmount() * self:GetPrintDelay(), "%2i:%02i"), "HudHintTextLarge", 190, 70, Color(65, 255, 0), 2, 0)

	cam.End3D2D()

	local ang2 = self:GetAngles()

	ang2:RotateAroundAxis(self:GetForward(), 90)
	ang2:RotateAroundAxis(self:GetUp(), 90)
	ang2:RotateAroundAxis(self:GetRight(), 8)

	cam.Start3D2D(pos - (self:GetRight() * -12.5) + (self:GetUp() * 24.5) + (self:GetForward() * 12.5), ang2, 0.1)

	draw.RoundedBox(0, 0, 0, 250, 45, Color(0, 0, 0, 230))
	draw.RoundedBox(0, 5, 5, 240, 35, Color(0, 0, 0, 230))
	draw.RoundedBox(0, 10, 10, ((self:GetInkAmount() / 1200) * 230), 25, Color(65, 190, 0))

	draw.SimpleText("Ink: " .. math.Round(((self:GetInkAmount() / 1200) * 100), 1) .. "%", "HudHintTextLarge", 125, 22.5, Color(255, 255, 255, 255), 1, 1)

	cam.End3D2D()
end
