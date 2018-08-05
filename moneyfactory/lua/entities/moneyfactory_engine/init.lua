AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local ent = {}

function ENT:Initialize()
	self:SetModel("models/props_c17/TrapPropeller_Engine.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	ent.power = ents.Create("prop_physics")
	ent.power:SetModel("models/props_lab/tpplug.mdl")
	ent.power:SetParent(self)
	ent.power:SetPos(self:GetPos() + (self:GetRight() * 2.5) + (self:GetUp() * 13) + (self:GetForward() * 1))
	ent.power:SetAngles(self:GetAngles() + Angle(-90, 0, 0))
	ent.power:Spawn()

	self.exploding = false

	self:SetHealthAmount(100)

	sound.Add(
		{
			name = "enginesound",
			channel = CHAN_STATIC,
			volume = 0.4,
			level = 60,
			pitch = 100,
			sound = "ambient/levels/canals/generator_ambience_loop1.wav"
		}
	)
end

function ENT:Think()
	local pos = self:GetPos()
	local entities = ents.FindInSphere(pos, 250)

	table.sort(
		entities,
		function(a, b)
			return pos:Distance(a:GetPos()) < pos:Distance(b:GetPos())
		end
	)

	for k, v in pairs(entities) do
		if v:IsValid() and (v:GetClass() == "moneyfactory") then
			if pos:Distance(v:GetPos()) < 70 then
				if not self:IsConstrained() then
					constraint.Rope(self, v, 0, 0, Vector(2.5, -2.5, 24.5), Vector(0, -20, 13), pos:Distance(v:GetPos()), 50, 0, 2, Material("cable/rope"), false)

					self:EmitSound("enginesound")
				end
			else
				if self:IsConstrained() then
					constraint.RemoveConstraints(self, "Rope")

					self:StopSound("enginesound")
				end
			end

			break
		end
	end

	if not self:IsConstrained() then
		self:StopSound("enginesound")
	end

	if self:GetHealthAmount() < 1 and self.exploding == false then
		self:SetHealthAmount(0)
		self.exploding = true

		function ExplodeMe()
			self:Ignite(1)
			self:StopSound("enginesound")

			timer.Simple(
				1,
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

	self:NextThink(CurTime() + 0.1)
end

function ENT:OnTakeDamage(dmg)
	if self.exploding == false then
		self:SetHealthAmount(self:GetHealthAmount() - dmg:GetDamage())
	end
end

function ENT:OnRemove()
	self:StopSound("enginesound")
end
