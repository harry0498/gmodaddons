AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("3d2d_derma/3d2d_derma.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_office/computer_monitor.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then
		phys:Wake()
	end
	
	self:SetPos(self:GetPos() - Vector(0, 0 , self:GetCollisionBounds().z))
	
	-- Initialize networked variables
	self:SetComputer(nil)
	self:SetUsePlayer(nil)
end

function ENT:Use(act, cal)
	-- Check if connected PC is on
	if not self:GetComputer():GetPowerState() then return end
	-- Check if a player is using the monitor
	if not IsValid(self:GetUsePlayer()) then
		-- Check if Activator is in range of monitor
		if act:EyePos():Distance(self:GetPos()) > 50 then return end
		if not timer.Exists("UsePlayer") then
			-- Set UsePlayer to Activator
			self:SetUsePlayer(act)
			timer.Create("UsePlayer", 1, 1, function() end)
		end
		-- Check if UsePlayer "Used" the monitor again
	elseif act == self:GetUsePlayer() then
		-- Check if Activator (UsePlayer) is in range
		if act:EyePos():Distance(self:GetPos()) > 50 then return end
		if not timer.Exists("UsePlayer") then
			-- Exit the monitor
			self:SetUsePlayer(nil)
			timer.Create("UsePlayer", 1, 1, function() end)
		end
	end
end

function ENT:Think()
	-- Check if UsePlayer is still valid
	if IsValid(self:GetUsePlayer()) then
		-- Check if UsePlayer is still in range of monitor
		if self:GetUsePlayer():EyePos():Distance(self:GetPos()) > 50 then
			-- Remove UsePlayer if they walked too far away
			self:SetUsePlayer(nil)
		end
	end
end
