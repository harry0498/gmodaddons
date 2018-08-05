include("shared.lua")

surface.CreateFont(
	"MoneyFont",
	{
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 110,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	}
)

function ENT:Draw()
	self:DrawModel()

	local ang = self:GetAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis(self:GetAngles():Right(), -90)
	ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

	cam.Start3D2D(pos + ang:Right() * -8 + ang:Forward() * -11 - ang:Up() * -10.15, ang, 0.01)

	draw.RoundedBox(0, 0, 0, 2200, 700, Color(40, 40, 40))
	draw.RoundedBox(8, 100, 325, 600, 150, Color(20, 20, 20))
	draw.RoundedBox(8, 120, 345, (self:GetBatteryAmount() * 560) / 300, 110, Color(127, 255, 0))
	draw.SimpleText("Battery", "MoneyFont", 240, 240, Color(127, 255, 0), 0, 1)
	draw.SimpleText(math.Round((self:GetBatteryAmount() / 300) * 100, 2) .. "%", "MoneyFont", 400, 400, Color(255, 255, 255), 1, 1)
	draw.SimpleText("Health:", "MoneyFont", 800, 180, Color(127, 255, 0), 0, 1)
	draw.SimpleText(self:GetHealthAmount() .. "/500", "MoneyFont", 2130, 180, Color(127, 255, 0), 2, 1)
	draw.SimpleText("Money:", "MoneyFont", 800, 280, Color(127, 255, 0), 0, 1)
	draw.SimpleText("£" .. self:GetMoneyAmount(), "MoneyFont", 2130, 280, Color(127, 255, 0), 2, 1)
	draw.SimpleText("Level:", "MoneyFont", 800, 380, Color(127, 255, 0), 0, 1)
	draw.SimpleText(self:GetXPLevel(), "MoneyFont", 2130, 380, Color(127, 255, 0), 2, 1)
	draw.SimpleText("XP:", "MoneyFont", 800, 480, Color(127, 255, 0), 0, 1)

	if self:GetXPLevel() < 20 then
		draw.SimpleText(self:GetXPAmount() .. "/" .. self:GetXPNeeded(), "MoneyFont", 2130, 480, Color(127, 255, 0), 2, 1)
	end

	if self:GetXPLevel() == 20 then
		draw.SimpleText("MAX LEVEL", "MoneyFont", 2130, 480, Color(127, 255, 0), 2, 1)
	end

	cam.End3D2D()

	local ang2 = self:GetAngles()
	local pos2 = self:GetPos()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	ang2:RotateAroundAxis(self:GetAngles():Up(), 90)

	cam.Start3D2D(pos2 + ang:Right() * -7.9 + ang:Forward() * -9 + ang:Up() * -8.8, ang2, 0.01)

	draw.RoundedBox(0, 0, 0, 1800, 1500, Color(40, 40, 40))
	draw.SimpleText("Leveling Money Printer", "MoneyFont", 900, 180, Color(127, 255, 0), 1, 1)
	draw.SimpleText("Owner:", "MoneyFont", 80, 480, Color(127, 255, 0), 0, 1)
	draw.SimpleText(owner, "MoneyFont", 1700, 480, Color(127, 255, 0), 2, 1)

	cam.End3D2D()
end
