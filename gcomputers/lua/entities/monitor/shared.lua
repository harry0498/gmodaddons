ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Monitor"
ENT.AdminSpawnable = false
ENT.Spawnable = true
ENT.Category = "GComputers"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Computer")
	self:NetworkVar("Entity", 1, "UsePlayer")
end