include("shared.lua")

surface.CreateFont("KettleTemp", {
	font = "Bahnschrift",
	size = 255,
	weight = 800,
	blursize = 1,
})

function Circle(x, y, radius, seg)
	local cir = {}

	for i = 0, seg do
		local a = math.rad((i / seg) * -360)
		table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})
	end

	local a = math.rad(0) -- This is needed for non absolute segment counts
	table.insert(cir, {x = x + math.sin(a) * radius, y = y + math.cos(a) * radius, u = math.sin(a) / 2 + 0.5, v = math.cos(a) / 2 + 0.5})

	return cir
end

function GetEmitter(self, Pos, b3D)
	if (self.Emitter) then
		if (self.EmitterIs3D == b3D && self.EmitterTime > CurTime()) then
			return self.Emitter
		end
	end

	self.Emitter = ParticleEmitter(Pos, b3D)
	self.EmitterIs3D = b3D
	self.EmitterTime = CurTime() + 2
	return self.Emitter

end

function ENT:PourWater()
	if not self:GetIsPouring() then return end
	if not self.PourTimer then self.PourTimer = 0 end

	if self.PourTimer < CurTime() then
		local pos = self:GetPos() + self:GetRight()*6 + self:GetUp()*1.7

		local emitter = GetEmitter(self, pos, false)
		local particle = emitter:Add("effects/spark", pos)
		if (!particle) then return end
		particle:SetDieTime(0.1)
		particle:SetStartSize(3)
		particle:SetEndSize(3)
		particle:SetVelocity(Vector(0, 0, -100))
		particle:SetColor(50, 80, 100)
		particle:SetCollide(true)

		self.PourTimer = CurTime() + 0.01
	end
end

function ENT:Boil()
	if not self.BoilTimer then self.BoilTimer = 0 end
	if not self.s then self.s = 0 end
	if self.BoilTimer < CurTime() then 
		if self:GetIsBoiling() then
			self.s = Lerp(FrameTime()*.5, self.s, (self:GetTemp() - 92) / 8)
		else
			if self:GetTemp() > 96 then
				self.s = Lerp(FrameTime(), self.s, .3)
			else
				self.s = Lerp(FrameTime()*.1, self.s, 0)
			end
		end
		local pos = self:GetPos() + self:GetRight()*6 + self:GetUp()*1.7
		local emitter = GetEmitter(self, pos, false)

		local particle = emitter:Add("particles/smokey", pos)
		if (!particle) then return end
		local dt = math.Rand(.5, 1)
		particle:SetDieTime(dt * self.s)
		particle:SetStartAlpha(6)
		particle:SetEndAlpha(0)
		particle:SetStartSize(0)
		particle:SetEndSize(math.Rand(6, 12) * self.s)
		particle:SetRoll(math.Rand(-30, 30))
		particle:SetVelocity(self:GetUp()*(math.Rand(30, 100)) + self:GetRight()*(math.Rand(10, 50)))
		particle:SetVelocityScale(true)
		particle:SetColor(255, 255, 255)
		particle:SetCollide(true)
		particle:SetAirResistance(math.Rand(150, 250) * 1/self.s)
		self.BoilTimer = CurTime() + FrameTime() * ((1/FrameTime())/31)
	end
end

function HobFlame(self)
	if not self.FlameTimer then self.FlameTimer = 0 end
	if self.FlameTimer < CurTime() then
		local pos = self:GetPos()
		local seg = 20
		local flameRing = Circle(pos.x, pos.y, 2, seg)

		for k, v in pairs(flameRing) do
			local emitter = GetEmitter(self, Vector(v.x, v.y, pos.z), false)

			local particle = emitter:Add("effects/spark", Vector(v.x, v.y, pos.z))
			if (!particle) then return end
			particle:SetDieTime(0.5)
			particle:SetStartSize(1)
			particle:SetEndSize(0)
			particle:SetStartAlpha(1)
			particle:SetEndAlpha(0)
			particle:SetVelocity((Vector(v.x, v.y, pos.z) - self:GetPos())*4)
			particle:SetGravity(self:GetUp()*15)
			particle:SetColor(20, 70, 250)
			particle:SetAirResistance(100)
			particle:SetCollide(true)
		end
		self.FlameTimer = CurTime() + FrameTime() * ((1/FrameTime())/31)
	end
end

function ENT:Draw()
	local pl = LocalPlayer()

	self:DrawModel()

	if not self.a then self.a = 0 end

	if pl:GetPos():Distance(self:GetPos()) < 500 then
		if 1/FrameTime() > 29 then
			if self:GetTemp() > 90 then
				self:Boil()
			end
			if IsValid(self:GetActiveHob()) then
				HobFlame(self:GetActiveHob())
			end
			self:PourWater()
		end
	end

	if pl:GetPos():Distance(self:GetPos()) < 200 then
		local pos = self:GetPos() + self:GetUp() * 10
		local dir = (pl:GetPos() - self:GetPos()):Angle()
		local ang = Angle(0, dir.y + 90, 90)
		local temp = tostring(math.Round(self:GetTemp(), 1))

		cam.Start3D2D(pos, ang, .01)
			local fh = draw.GetFontHeight("KettleTemp")
			local fw = (120 * (string.len(temp) + 1)) + 30
			draw.RoundedBox(10, -fw*.5, -fh*.46, fw, fh, Color(40, 40, 40, 150 * self.a))
			draw.SimpleText(temp .. "C", "KettleTemp", 0, 0, Color(200, 200, 200, 255 * self.a), 1, 1)
		cam.End3D2D()
	end

	if pl:GetPos():Distance(self:GetPos()) < 100 then
		self.a = Lerp(FrameTime() * 1, self.a, 1)
	else
		self.a = Lerp(FrameTime() * 4, self.a, 0)
	end
end