ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.Category = "Mining System"

ENT.PrintName = "Ore Node"
ENT.AdminSpawnable = true
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsMining")
    self:NetworkVar("Int", 0, "Ore")
    self:NetworkVar("Int", 1, "MaxOre")
    self:NetworkVar("Int", 2, "MineTime")
    self:NetworkVar("Float", 0, "MineTimeRemaining")
    self:NetworkVar("String", 0, "OreType")
end