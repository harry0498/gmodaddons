AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local colours = {
	[1] = Color(253, 167, 223),
	[2] = Color(217, 128, 250),
	[3] = Color(153, 128, 250),
	[4] = Color(87, 88, 187),
	[5] = Color(111, 30, 81),
	[6] = Color(131, 52, 113),
	[7] = Color(181, 52, 113),
	[8] = Color(237, 76, 103),
	[9] = Color(234, 32, 39),
	[10] = Color(238, 90, 36),
	[11] = Color(247, 159, 31),
	[12] = Color(255, 195, 18),
	[13] = Color(196, 229, 56),
	[14] = Color(163, 203, 56),
	[15] = Color(0, 148, 50),
	[16] = Color(0, 98, 102),
	[17] = Color(27, 20, 100),
	[18] = Color(6, 82, 221),
	[19] = Color(18, 137, 167),
	[20] = Color(18, 203, 196),
}

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox03a.mdl")
	self:SetMaterial("models/debug/debugwhite")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	self.timer = CurTime() + 1
	self.XPtimer = CurTime() + 1
	self.SoundTimer = CurTime() + 1
	self.exploding = 0

	self:SetPrintDelay(5)
	self:SetHealthAmount(500)
	self:SetBatteryAmount(300)
	self:SetXPAmount(0)
	self:SetXPLevel(1)
	self:SetXPNeeded(self:GetXPLevel() * 100)
	self:SetColor(colours[self:GetXPLevel()])

	sound.Add(
		{
			name = "printingsound",
			channel = CHAN_STATIC,
			volume = 0.4,
			level = 60,
			pitch = 100,
			sound = "ambient/levels/labs/equipment_printer_loop1.wav"
		}
	)

	self:EmitSound("printingsound")
end

function ENT:Think()
	if (self:GetHealthAmount() > 1) and (self:GetBatteryAmount() != 0) then
		if CurTime() >= self.SoundTimer then
			self.SoundTimer = CurTime() + 1

			self:StopSound("printingsound")
			self:EmitSound("printingsound")

			self:SetBatteryAmount(self:GetBatteryAmount() - 0.5)
		end

		if CurTime() >= self.timer then
			self.timer = CurTime() + self:GetPrintDelay()

			self:SetMoneyAmount(self:GetMoneyAmount() + 90 + self:GetXPLevel() * 10)
		end

		if CurTime() >= self.XPtimer and self:GetXPLevel() < #colours then
			self.XPtimer = CurTime() + 3

			self:SetXPAmount(self:GetXPAmount() + 10)

			if self:GetXPAmount() >= self:GetXPNeeded() then
				self:SetXPAmount(0)
				self:SetXPLevel(self:GetXPLevel() + 1)
				self:SetXPNeeded(self:GetXPLevel() * 100)
				self:SetPrintDelay(math.Clamp(self:GetPrintDelay() - 0.05, 1, 10))
				self:SetColor(colours[self:GetXPLevel()])
			end
		end
	end

	if self:GetHealthAmount() < 1 and self.exploding == 0 then
		self:SetHealthAmount(0)
		self.exploding = 1

		function ExplodeMe()
			self:Ignite(5)

			timer.Simple(
				5,
				function()
					local explosion = ents.Create("env_explosion")
					explosion:SetKeyValue("spawnflags", 144)
					explosion:SetKeyValue("iMagnitude", 15)
					explosion:SetKeyValue("iRadiusOverride", 256)
					explosion:SetPos(self:GetPos())
					explosion:Spawn()
					explosion:Fire("explode", "", 0)
					self:Remove()
				end
			)
		end

		ExplodeMe()
	end

	if self:GetBatteryAmount() == 0 then
		self:StopSound("printingsound")
	end

	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:Use(act, call)
	local money = self:GetMoneyAmount()

	if money > 0 then
		self:SetMoneyAmount(0)
		call:addMoney(money)
		-- AddXP(call, money / 20)
		DarkRP.notify(call, 0, 3, "You collected £" .. money .. " from " .. self.PrintName)
		-- DarkRP.notify(call, 0, 3, "You gained " .. (money / 20) .. " XP from " .. self.PrintName)
	end
end

function ENT:OnTakeDamage(dmg)
	if self.exploding == 0 then
		self:SetHealthAmount(self:GetHealthAmount() - dmg:GetDamage())
	end
end

function ENT:OnRemove()
	self:StopSound("printingsound")
end

function ENT:StartTouch(ent)
	if ent:IsValid() and ent:GetClass() == "printerbattery" and self:GetBatteryAmount() < 300 then
		ent:Remove()
		self:SetBatteryAmount(math.Clamp(self:GetBatteryAmount() + 160, 0, 300))
	end

	if ent:IsValid() and ent:GetClass() == "printerrepair" and self:GetHealthAmount() < 500 then
		ent:Remove()
		self:SetHealthAmount(math.Clamp(self:GetHealthAmount() + 250, 0, 500))
	end
end
