AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox03a.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(100, 100, 100))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	self.timer = CurTime()
	self.XPtimer = CurTime()
	self.exploding = 0

	self:SetPrintDelay(5)
	self:SetHealthAmount(500)
	self:SetBatteryAmount(300)
	self:SetXPAmount(0)
	self:SetXPLevel(1)
	self:SetXPNeeded(self:GetXPLevel() * 100)

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

		if CurTime() > (self.timer + self:GetPrintDelay()) then
			self.timer = CurTime()

			self:SetMoneyAmount(self:GetMoneyAmount() + 90 + self:GetXPLevel() * 10)
		end

		if (CurTime() > self.XPtimer + 1) and (self:GetBatteryAmount() != 0) then
			self:StopSound("printingsound")
			self:EmitSound("printingsound")

			self.XPtimer = CurTime()

			self:SetXPAmount(self:GetXPAmount() + 1)
			self:SetBatteryAmount(self:GetBatteryAmount() - 0.5)

			if self:GetXPAmount() == self:GetXPNeeded() then
				self:SetXPAmount(0)
				self:SetXPLevel(self:GetXPLevel() + 1)
				self:SetXPNeeded(self:GetXPLevel() * 100)
				self:SetPrintDelay(self:GetPrintDelay() - 0.05)
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
		AddXP(call, money / 20)
		DarkRP.notify(call, 0, 3, "You collected £" .. money .. " from " .. self.PrintName)
		DarkRP.notify(call, 0, 3, "You gained " .. (money / 20) .. " XP from " .. self.PrintName)
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
	if ent:IsValid() and ent:GetClass() == "printerbattery" then
		ent:Remove()
		self:SetBatteryAmount(math.Clamp(self:GetHealthAmount() + 160, 0, 300))
	end

	if ent:IsValid() and ent:GetClass() == "printerrepair" and self:GetHealthAmount() < 500 then
		ent:Remove()
		self:SetHealthAmount(math.Clamp(self:GetHealthAmount() + 250, 0, 500))
	end
end
