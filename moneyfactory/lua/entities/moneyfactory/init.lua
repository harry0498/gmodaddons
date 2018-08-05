AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/powerbox01a.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(80, 80, 80))

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	self:SetVar("vent", ents.Create("prop_physics"))
	self:GetVar("vent"):SetModel("models/props_vents/vent_small_straight002.mdl")
	self:GetVar("vent"):SetMaterial("models/debug/debugwhite")
	self:GetVar("vent"):SetColor(Color(80, 80, 80))
	self:GetVar("vent"):SetParent(self)
	self:GetVar("vent"):SetPos(self:GetPos() + self:GetRight() * -15)
	self:GetVar("vent"):SetAngles(self:GetAngles() + Angle(0, 0, -20))
	self:GetVar("vent"):Spawn()

	self:SetVar("power", ents.Create("prop_physics"))
	self:GetVar("power"):SetModel("models/props_lab/tpplug.mdl")
	self:GetVar("power"):SetParent(self)
	self:GetVar("power"):SetPos(self:GetPos() + (self:GetRight() * 8.5) + (self:GetUp() * 13))
	self:GetVar("power"):SetAngles(self:GetAngles() + Angle(0, -90, 0))
	self:GetVar("power"):Spawn()

	self:SetVar("paper", ents.Create("prop_physics"))
	self:GetVar("paper"):SetModel("models/props/cs_office/paper_towels.mdl")
	self:GetVar("paper"):SetRenderMode(RENDERMODE_TRANSALPHA)
	self:GetVar("paper"):SetColor(Color(0, 0, 0, 0))
	self:GetVar("paper"):SetParent(self)
	self:GetVar("paper"):SetPos(self:GetPos() + (self:GetUp() * 23) + (self:GetForward() * -5))
	self:GetVar("paper"):SetAngles(self:GetAngles() + Angle(0, 90, 0))
	self:GetVar("paper"):Spawn()

	self:SetPaperAmount(0)
	self:SetInkAmount(0)
	self:SetHealthAmount(350)
	self:SetPrintDelay(2)
	self:SetPrintAmount(800)

	self.exploding = false

	self.timer = CurTime() + self:GetPrintDelay()

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
end

function ENT:Touch(entity)
	if (entity:IsValid()) and (entity:GetClass() == "moneyfactory_paper") then
		if self:GetPaperAmount() < 1 then
			self:SetPaperAmount(entity:GetValue())
			entity:Remove()
		end
	end

	if (entity:IsValid()) and (entity:GetClass() == "moneyfactory_ink") then
		if self:GetInkAmount() < 1 then
			self:SetInkAmount(entity:GetValue())
			entity:Remove()
		end
	end
end

function ENT:Think()
	if self:IsConstrained() then
		if (self:GetPaperAmount() > 0) and (self:GetInkAmount() > 0) and (self.exploding == false) then
			if self.timer <= CurTime() then
				DarkRP.createMoneyBag(self:GetVar("vent"):GetPos(), self:GetPrintAmount())

				self:SetPaperAmount(self:GetPaperAmount() - 1)
				self:SetInkAmount(self:GetInkAmount() - 1)

				self:StopSound("printingsound")
				self:EmitSound("printingsound")

				self.timer = CurTime() + self:GetPrintDelay()
			end
		else
			self:StopSound("printingsound")
		end
	else
		self:StopSound("printingsound")
	end

	if self:GetPaperAmount() > 0 then
		self:GetVar("paper"):SetColor(Color(255, 255, 255, 255))
	else
		self:GetVar("paper"):SetColor(Color(0, 0, 0, 0))
	end

	if self:GetHealthAmount() < 1 and self.exploding == false then
		self:SetHealthAmount(0)
		self.exploding = true

		function ExplodeMe()
			self:Ignite(3)
			self:StopSound("printingsound")

			timer.Simple(
				3,
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

	self:NextThink(CurTime() + 0.05)

	return true
end

function ENT:OnTakeDamage(dmg)
	if self.exploding == false then
		self:SetHealthAmount(self:GetHealthAmount() - dmg:GetDamage())
	end
end

function ENT:OnRemove()
	self:StopSound("printingsound")
end
