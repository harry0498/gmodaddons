ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Money Factory Ink"
ENT.AdminSpawnable = true
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Value")
end
