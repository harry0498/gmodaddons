ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Kettle"
ENT.AdminSpawnable = false
ENT.Spawnable = true
ENT.Category = "gKettle"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "Temp")
	self:NetworkVar("Bool", 0, "IsBoiling")
	self:NetworkVar("Bool", 1, "HasHobPoints")
	self:NetworkVar("Bool", 2, "IsPouring")
	self:NetworkVar("Entity", 0, "Cooker")
	self:NetworkVar("Entity", 1, "ActiveHob")
end