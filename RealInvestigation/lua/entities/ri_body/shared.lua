ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "RI Body"
ENT.Author = "Taz"
ENT.Category = "RealInvestigation"
ENT.Contact = "N/A"
ENT.Purpose = "N/A"
ENT.Instruction = "N/A"

ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
    self.AutomaticFrameAdvance = bUsingAnim
end