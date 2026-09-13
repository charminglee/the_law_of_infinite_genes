---@class DefaultRoom_C:UAEUserWidget
---@field Button_0 UButton
--Edit Below--
local DefaultRoom = { bInitDoOnce = false }

function DefaultRoom:Init(OnCreate)
    self.OnCreate = OnCreate
    if self.bInitDoOnce then
        return
    end
    self.bInitDoOnce = true
    self.Button_0.OnClicked:Add(self.OnCreateClicked, self)
end

function DefaultRoom:OnCreateClicked()
    self.OnCreate()
end

return DefaultRoom
