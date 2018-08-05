AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props/cs_militia/militiarock05.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end

	self:SetIsMining(false)
	self:SetMaxOre(20)
	self:SetOre(self:GetMaxOre())
	self:SetMineTime(1)
	self:SetMineTimeRemaining(0)
	self:SetOreType("Iron")
	self.timer = CurTime()

	sound.Add({
			name = "miningsound1",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "physics/concrete/rock_impact_hard1.wav"
	})

	sound.Add({
			name = "miningsound2",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "physics/concrete/rock_impact_hard2.wav"
	})

	sound.Add({
			name = "miningsound3",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "physics/concrete/rock_impact_hard3.wav"
	})

	sound.Add({
			name = "miningsound4",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "physics/concrete/rock_impact_hard4.wav"
	})

	sound.Add({
			name = "miningsound5",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "physics/concrete/rock_impact_hard5.wav"
	})

	sound.Add({
			name = "miningsound6",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = 100,
			sound = "physics/concrete/rock_impact_hard6.wav"
	})

end

concommand.Add("setoretype", function(ply, cmd, args)

	if ply:IsValid() and ply:IsUserGroup("superadmin") then

		if ply:GetEyeTrace().Entity:GetClass() == "mining_node" then

			ply:GetEyeTrace().Entity:SetOreType(args[1])

		end

	end

end)

function ENT:Use(act, call)

	if act:IsValid() then

		if !self:GetIsMining() and !timer.Exists("ismining" .. self:GetCreationID()) and self:GetOre() > 0 then

			self:SetIsMining(true)

			self:SetMineTimeRemaining(0)
			self.timer = CurTime()
			
			timer.Create("miningsounds", 0.5, self:GetMineTime() * 2, function()
			
				self:EmitSound("miningsound" .. math.Round(math.random(1, 6)))
			
			end)

		end

		self.minedby = call

	end

end

function ENT:Think()

	if self:GetIsMining() then

		if CurTime() >= self.timer + 0.1 then

			self.timer = CurTime()

			self:SetMineTimeRemaining(self:GetMineTimeRemaining() + 0.1)

		end

		if self:GetMineTimeRemaining() >= self:GetMineTime() then
			
				self:SetIsMining(false)
				self:SetOre(math.Clamp(self:GetOre() - 1, 0, self:GetMaxOre()))

				AddOre(self.minedby, 1)
			
		end

	end

	self:NextThink(CurTime() + 0.01)
	return true

end

function AddOre(ply, amount)

	if ply:IsValid() then

		ply:SetNWInt("Ore", ply:GetNWInt("Ore") + amount)

		timer.Simple(0.1, function()

			ply:SendLua([[ chat.AddText(Color(46, 134, 193), "[Mining] ", Color(255, 255, 255), "You have: ", Color(46, 134, 193), tostring(LocalPlayer():GetNWInt("Ore")), Color(255, 255, 255), " ore") ]])

		end)

	end

end
