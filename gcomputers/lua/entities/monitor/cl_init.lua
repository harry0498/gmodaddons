include("shared.lua")
include("3d2d_derma/3d2d_derma.lua")

surface.CreateFont("MonitorLoad", {
	font = "Candara",
	size = 255,
	weight = 1000,
	blursize = 1,
})

surface.CreateFont("MonitorMain", {
	font = "Arial",
	size = 50,
	weight = 700,
	blursize = 1,
})

surface.CreateFont("MonitorIcons", {
	font = "Arial",
	size = 40,
	weight = 700,
	blursize = 1,
})

function draw.Circle(x, y, radius, seg)
	local cir = {}

	table.insert(cir, {x = x, y = y, u = 0.5, v = 0.5})
	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})

	surface.DrawPoly(cir)
end

function draw.Cursor(pos)
	local s1 = 9
	local s2 = 6

	local cur1 = {
		{x = pos.x, y = pos.y},
		{x = pos.x + 2 * s1, y = pos.y + 5 * s1},
		{x = pos.x + 3 * s1, y = pos.y + 3 * s1},
		{x = pos.x + 5 * s1, y = pos.y + 2 * s1}
	}
	pos = Vector(pos.x + (s1 - s2) * 2, pos.y + (s1 - s2) * 2)
	local cur2 = {
		{x = pos.x, y = pos.y},
		{x = pos.x + 2 * s2, y = pos.y + 5 * s2},
		{x = pos.x + 3 * s2, y = pos.y + 3 * s2},
		{x = pos.x + 5 * s2, y = pos.y + 2 * s2}
	}
	
	surface.SetDrawColor(Color(0, 0, 0))
	surface.DrawPoly(cur1)
	surface.SetDrawColor(Color(200, 200, 200))
	surface.DrawPoly(cur2)
end

local panel = FindMetaTable("Panel")

function panel:isHovered()
	local x, y = self:GetPos()
	local cx, cy = self:GetParent():LocalCursorPos()

	if cx >= x and cx <= (x + self:GetWide()) and cy >= y and cy <= (y + self:GetTall()) then
		return true
	end

	return false
end

local scrw, scrh = 2075, 1571
local hw, hh = scrw * .5, scrh * .5
local scale = 0.01

local bootload = 0

local Monitor = {}

Monitor.Off = vgui.Create("DFrame")
Monitor.Off:Hide()
Monitor.Off:SetDraggable(false)
Monitor.Off:SetSize(scrw, scrh)
Monitor.Off:SetTitle("")
Monitor.Off:ShowCloseButton(false)
Monitor.Off.Paint = function(s, w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
end

Monitor.Loading = vgui.Create("DFrame")
Monitor.Loading:Hide()
Monitor.Loading:SetDraggable(false)
Monitor.Loading:SetSize(scrw, scrh)
Monitor.Loading:SetTitle("")
Monitor.Loading:ShowCloseButton(false)
Monitor.Loading.Paint = function(s, w, h)
	draw.RoundedBox(0, 0, 0, scrw, scrh, Color(20, 83, 27))
	surface.SetDrawColor(Color(62, 253, 81))
	surface.SetTexture(0)
	draw.Circle(hw, scrh * .35, 250, 50)
	draw.SimpleText("GC", "MonitorLoad", scrw * .5, scrh * .35, Color(20, 83, 27), 1, 1)
	draw.RoundedBox(8, hw - 300, scrh * .55, 600, 100, Color(62, 253, 81))
	draw.RoundedBox(8, hw - 290, scrh * .55 + 10, 580, 80, Color(20, 83, 27))
	draw.RoundedBox(0, hw - 290, scrh * .55 + 10, (bootload/100) * 580, 80, Color(62, 253, 81))
end

Monitor.Desktop = vgui.Create("DFrame")
Monitor.Desktop:Hide()
Monitor.Desktop:SetDraggable(false)
Monitor.Desktop:SetSize(scrw, scrh)
Monitor.Desktop:SetTitle("")
Monitor.Desktop:ShowCloseButton(false)
Monitor.Desktop.Paint = function(s, w, h)
	draw.RoundedBox(0, 0, 0, scrw, scrh, Color(62, 138, 253))
	draw.RoundedBox(0, 0, 0, scrw, 60, Color(31, 68, 125))
	draw.SimpleText(os.date("%a %d %b %Y"), "MonitorMain", hw, 30, Color(190, 190, 190), 1, 1)
	draw.SimpleText(os.date("%H:%M:%S"), "MonitorMain", scrw * .99, 30, Color(190, 190, 190), 2, 1)
end

Monitor.Desktop.Icons = vgui.Create("DIconLayout", Monitor.Desktop)
Monitor.Desktop.Icons:Dock(FILL)
Monitor.Desktop.Icons:DockMargin(30, 70, 0, 0)
Monitor.Desktop.Icons:SetLayoutDir(LEFT)
Monitor.Desktop.Icons:SetSpaceX(100)
Monitor.Desktop.Icons:SetSpaceY(100)

function panel:AddApp(name)
	local a = self:Add("DButton")
	a:SetSize(128, 128)
	a:SetText("")
	a.Paint = function(s, w, h)
		draw.RoundedBox(0, w * .15, h * .1, w * .7, h * .9, Color(200, 200, 200))
		draw.SimpleText(name, "MonitorIcons", w * .5, h + 30, Color(250, 250, 250), 1, 1)

		if s:isHovered() then
			draw.RoundedBox(0, w * .05, 0, w * 0.9, h * 1.1, Color(0, 0, 0, 160))
		end
	end

	self:GetParent()[name] = vgui.Create("DPanel", self:GetParent())
	self:GetParent()[name]:SetPos(0, 60)
	self:GetParent()[name]:SetSize(scrw, scrh - 60)
	self:GetParent()[name].Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		draw.RoundedBox(0, 0, 0, w, 60, Color(0, 0, 0))
		draw.SimpleText(name, "MonitorIcons", w * .5, 30, Color(200, 200, 200), 1, 1)
	end

	self:GetParent()[name].Close = vgui.Create("DButton", self:GetParent()[name])
	self:GetParent()[name].Close:SetText("")
	self:GetParent()[name].Close:SetSize(60, 60)
	self:GetParent()[name].Close:SetPos(self:GetParent()[name]:GetWide() - self:GetParent()[name].Close:GetWide(), 0)
	self:GetParent()[name].Close.Paint = function(s, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(200, 40, 40))
		draw.SimpleText("X", "MonitorMain", w * .5, h * .5, Color(200, 200, 200), 1, 1)
	end
	self:GetParent()[name].Close.DoClick = function(s)
		s:GetParent():Hide()
	end

	self:GetParent()[name]:Show()

	return self:GetParent()[name], a
end

local Notepad, Notepad_Icon = Monitor.Desktop.Icons:AddApp("Notepad")
Notepad.Text = {}

function Notepad:GetInput()
	self.Input = vgui.Create("DTextEntry", self)
	self.Input:MakePopup()
	self.Input.Paint = function(s, w, h) end
	self.Input.OnEnter = function(s)
		self.Text[#self.Text + 1] = ""
		s:SetText("")
		self:DrawText()
	end
	self.Input.OnChange = function(s)
		if self.Text[#self.Text] then
			self.Text[#self.Text] = self.Text[#self.Text] .. s:GetText()
		else
			self.Text[#self.Text + 1] = s:GetText()
		end
		
		s:SetText("")
		self:DrawText()
	end
	self.Input.OnKeyCode = function(s, key)
		if key == KEY_ESCAPE then s:Remove() end
		if key == KEY_BACKSPACE then
			if self.Text[#self.Text] == "" then
				table.remove(self.Text, #self.Text)
			elseif self.Text[#self.Text] then
				self.Text[#self.Text] = string.sub(self.Text[#self.Text], 1, string.len(self.Text[#self.Text]) - 1)
			end
		end
		PrintTable(self.Text)
		self:DrawText()
	end
end

Notepad_Icon.DoClick = function(s)
	Notepad:Show()
	Notepad:GetInput()
end

function Notepad:DrawText()
	for k, v in pairs(self:GetChildren()) do
		if v:GetClassName() == "Label" then
			v:Remove()
		end
	end
	for k, v in pairs(self.Text) do
		local line = vgui.Create("DLabel", self, "line" .. k)
		line:SetPos(15, 30 + (40 * k))
		line:SetSize(self:GetWide() - 30, 70)
		line:SetText(v)
		line.PerformLayout = function(s)
			s:SetFontInternal("MonitorIcons")
		end
	end
end

function Monitor:show(p)
	if IsValid(self[p]) then
		if not self[p]:IsVisible() then
			for k, v in pairs(self) do
				if TypeID(v) == TYPE_PANEL then
					v:Hide()
				end
			end
			self[p]:Show()
		end
	end
end

function ENT:Draw()
	self:DrawModel()

	local UIOffset = self:GetPos() + self:GetForward() * 3.26 + self:GetRight() * 10.38 + self:GetUp() * 24.56
	local UIAngOff = self:GetAngles()
	UIAngOff:RotateAroundAxis(self:GetForward(), 90)
	UIAngOff:RotateAroundAxis(self:GetUp(), 90)

	vgui.Start3D2D(UIOffset, UIAngOff, scale)
		for _, v in pairs(Monitor) do
			if TypeID(v) == TYPE_PANEL then
				v:Paint3D2D()
			end
		end

		if IsValid(self:GetComputer()) then 
			if self:GetComputer():GetPowerState() then
				-- Smooth loading bar for boot screen
				bootload = Lerp(FrameTime() * 20, bootload, 100) -- .4
				if bootload > 40 && bootload < 50 then bootload = 50 end
				if bootload > 55 && bootload < 70 then bootload = 70 end
				if bootload > 75 && bootload < 85 then bootload = 85 end
				if bootload > 95 then bootload = 100 end

				-- Show boot screen if bootload % below 100
				if bootload < 100 then
					Monitor:show("Loading")
				else
					Monitor:show("Desktop")
				end
			else
				bootload = 0
				Monitor:show("Off")
			end
		else
			Monitor:show("Off")
		end
	vgui.End3D2D()	
end

function ENT:Think()
	if self:GetUsePlayer() == LocalPlayer() then
		gui.EnableScreenClicker(true)
	else
		gui.EnableScreenClicker(false)
	end
end

