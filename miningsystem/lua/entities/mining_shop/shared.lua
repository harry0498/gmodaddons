ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.Category = "Mining System"
ENT.AutomaticFrameAdvance = true 

ENT.PrintName = "Ore Shop"
ENT.AdminSpawnable = true
ENT.Spawnable = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)

    self.AutomaticFrameAdvance = bUsingAnim

end