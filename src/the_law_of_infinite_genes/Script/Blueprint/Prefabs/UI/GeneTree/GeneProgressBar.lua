---@class GeneProgressBar_C:UAEUserWidget
---@field background UImage
---@field Dark_Image UImage
---@field Light_Image UImage
---@field TextBlock_0 UTextBlock
---@field Material_Instance UMaterialInstanceDynamic
---@field Percent float
---@field Start_Point FUGC_GradualColorPoint__pf2209879471
---@field End_Point FUGC_GradualColorPoint__pf2209879471
--Edit Below--
---@class GeneProgressBar:UUAEUserWidget
---@field Percent float
---@field Light_Image UImage
---@field Material_Instance UMaterialInstanceDynamic

local GeneProgressBar = {
	OldPercent = 0.0,
}
function GeneProgressBar:Construct()
	--print("GeneProgressBar:Construct")

	self.Material_Instance = self.Light_Image:GetDynamicMaterial()
	self.Material_Instance:SetScalarParameterValue("Start_Percent", self.Start_Point.percent)
	self.Material_Instance:SetVectorParameterValue("Start_Color", self.Start_Point.Color)

	self.Material_Instance:SetScalarParameterValue("End_Percent", self.End_Point.percent)
	self.Material_Instance:SetVectorParameterValue("End_Color", self.End_Point.Color)
end

function GeneProgressBar:Destruct()
	if UGCTimerUtility.IsLuaTimerExistByName("Duration_Timer") then
		UGCTimerUtility.RemoveLuaTimerByName("Duration_Timer")
	end
end

function GeneProgressBar:SetPercent(InPercent)
	log("GeneProgressBar:SetPercent" .. tostring(InPercent))
	self.Percent = KismetMathLibrary.FClamp(InPercent, 0.0, 1.0)
	self.Material_Instance:SetScalarParameterValue("Percent", self.Percent)
	self.TextBlock_0:SetText(string.format("%.0f", self.Percent * 100))
end

-------------------------------PETaskProgressInterface------------------------------------

function GeneProgressBar:SetDuration(duration)
	self.duration = duration
	self.along_duration = 0.0
	self.frequence = 0.05
	self:SetPercent(self.along_duration)

	UGCTimerUtility.CreateLuaTimer(self.frequence, function()
		self.along_duration = self.along_duration + self.frequence
		if self.along_duration > self.duration then
			UGCTimerUtility.RemoveLuaTimerByName("Duration_Timer")
		end
		self:SetPercent(self.along_duration / self.duration)
		self:OnPercentChanged(self.OldPercent, self.along_duration / self.duration)
		self.OldPercent = self.along_duration / self.duration
	end, true, "Duration_Timer")
end

function GeneProgressBar:OnPercentChanged(OldPercent, NewPercent)
	
end


function GeneProgressBar:SetText(text)
	self.TextBlock_0:SetText(text)
end

function GeneProgressBar:SetSkill(text) end

function GeneProgressBar:SetColor(LineColor) end

-------------------------------PETaskProgressInterface------------------------------------

return GeneProgressBar
