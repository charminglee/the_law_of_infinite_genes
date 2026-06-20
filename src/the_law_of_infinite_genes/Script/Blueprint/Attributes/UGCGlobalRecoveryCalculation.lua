local UGCGlobalRecoveryCalculation = {}


function UGCGlobalRecoveryCalculation:GetCalculationResult(context, extraResult)
    local recoveredValue = UGCAttributeSystem.GetSourceMagnitudeFromContext(context)
    return recoveredValue, extraResult
end


return UGCGlobalRecoveryCalculation