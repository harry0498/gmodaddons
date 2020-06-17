ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Case"
ENT.AdminSpawnable = false
ENT.Spawnable = true
ENT.Category = "GComputers"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "PowerState")
	self:NetworkVar("Int", 0, "CPULoad")
	self:NetworkVar("Float", 0, "CPUTemp")
	self:NetworkVar("Entity", 0, "Monitor")
end