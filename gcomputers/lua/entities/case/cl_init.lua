include("shared.lua")

surface.CreateFont( "CaseUITitle", {
	font = "Bahnschrift",
	size = 255,
	weight = 500,
	blursize = 1,
})

surface.CreateFont( "CaseUIBody", {
	font = "Candara",
	size = 120,
	weight = 500,
	blursize = 1,
})

surface.CreateFont( "CaseUISmallNum", {
	font = "Arial",
	size = 80,
	weight = 600,
	blursize = 0,
})

function ENT:GetComponents()
	return util.JSONToTable(self:GetNWString("Components"))
end

function ENT:HasAllComponents()
	local i = false
	if not self:GetComponents() then return i end
	for k, v in pairs(self:GetComponents()) do
		if v == false then
			i = false
			break
		else
			i = true
		end
	end
	return i
end

local smoothcpu = 0

function ENT:Draw()
	self:DrawModel()

	-- Set UI and BG colours
	local uicolour = Color(62, 253, 81)
	local bgcolour = Color(25, 25, 25)

	-- Setup cam3d2d offset pos/ang
	local UIOffset = self:GetPos() + self:GetForward() * -11 + self:GetRight() * 5.2 + self:GetUp() * 23
	local UIAngOff = self:GetAngles() + Angle(0, 0, 90)

	-- Set BG width/height
	local bgw, bgh = 2100, 2050

	cam.Start3D2D(UIOffset, UIAngOff, 0.01)
	
	-- Background and title
	draw.RoundedBox(0, 0, 0, bgw, bgh, bgcolour)
	draw.SimpleText("Computer", "CaseUITitle", bgw/2, 0, uicolour, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	
	-- Missing components list
	if self:GetComponents() then
		local i = 1
		for k, v in pairs(self:GetComponents()) do
			if not v then
				local y = draw.GetFontHeight("CaseUIBody")
				draw.SimpleText("> Missing " .. k, "CaseUIBody", 50, 200 + y*i, uicolour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				i = i + 1
			end
		end
	end

	if self:HasAllComponents() then
		-- Draw power state & other system related elements
		smoothcpu = Lerp(FrameTime() * 10, smoothcpu, self:GetCPULoad() * 10)
		if self:GetPowerState() then
			draw.SimpleText("> Powered: " .. "On", "CaseUIBody", 50, 350, uicolour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText("> CPU Load: ", "CaseUIBody", 50, 500, uicolour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.RoundedBox(10, 590, 515, 1020, 100, uicolour)
			draw.RoundedBox(10, 600, 525, 1000, 80, Color(20, 83, 27))
			draw.RoundedBox(0, 600, 525, smoothcpu, 80, uicolour)
			draw.SimpleText(tostring(self:GetCPULoad()) .. "%", "CaseUISmallNum", 1100, 564, bgcolour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("> CPU Temp: " .. tostring(math.Round(self:GetCPUTemp(), 1)) .. "C", "CaseUIBody", 50, 650, uicolour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		else
			draw.SimpleText("> Powered: " .. "Off", "CaseUIBody", 50, 350, uicolour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end
	cam.End3D2D()
end