---@class HomeUserInfo_C:UAEUserWidget
---@field Avatar Common_Avatar_BP_C
---@field HeadImage UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field ProfileFrameImage UImage
---@field SizeBox_0 USizeBox
---@field HeadImagePath FString
---@field HeadImageType TEnumAsByte<GetHeadImageTypeEnum>
---@field ProfileFrameAssetPath FString
--Edit Below--
---@class HomeUserInfo:UUAEUserWidget
local HomeUserInfo = {
    PlayerKey = nil,
    Character = nil,
    Size = 100,
}
function HomeUserInfo:Construct()
    print("HomeUserInfo:Construct")
    self:ShowUI(nil)
end


function HomeUserInfo:ShowUI(InCharacter)
    self:SetProfileFrameByAssetPath()
    self:SetWidthAndHeight(self.Size)
    if self.HeadImageType == 0 then--根据PlayerID设置头像
        self.HeadImage:SetVisibility(ESlateVisibility.Collapsed)
        self.Avatar:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        local Character = nil
        if UE.IsValid(InCharacter) then
            Character = InCharacter
        else
            Character = GameplayStatics.GetPlayerController(self, 0):GetPlayerCharacterSafety()
        end
        self.Character = Character
        self:GetPlayerKeyByCharacter(Character)
        self:SetHeadImageByPlayerKey(self.PlayerKey)
    elseif self.HeadImageType == 1 then--根据Asset路径设置头像
        self:SetHeadImageByAssetPath()
        self.HeadImage:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Avatar:SetVisibility(ESlateVisibility.Collapsed)
    end
end
function HomeUserInfo:GetPlayerKeyByCharacter(Character)
    local PC = Character:GetPlayerControllerSafety()
    if PC~=nil then
        self.PlayerKey = PC.PlayerKey
    end
end
function HomeUserInfo:SetHeadImageByPlayerKey(PlayerKey)
    print("HomeUserInfo:SetHeadImageByPlayerKey")
    local PS = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey):GetTeamMatePlayerStateFromPlayerKey(PlayerKey)
    local UID = PS:GetInt64UID()
    local IconURL = PS.IconURL
    self.Avatar:InitView(1, UID, IconURL)
end
function HomeUserInfo:ResetHeadImagePath(NewPath)
    self.HeadImagePath = NewPath
end
function HomeUserInfo:ResetProfileFrameAssetPath(NewPath)
    self.ProfileFrameAssetPath = NewPath
end
--Type=0为PlayerUD,Type=1为Asset路径
function HomeUserInfo:ResetHeadImageType(Type)
    self.HeadImageType = Type
end
function HomeUserInfo:SetHeadImageByAssetPath()
    FuncUtil.SetImageWithPathAsync(self.HeadImage, self.HeadImagePath)
end
function HomeUserInfo:SetProfileFrameByAssetPath()
    FuncUtil.SetImageWithPathAsync(self.ProfileFrameImage, self.ProfileFrameAssetPath)
end
function HomeUserInfo:SetWidthAndHeight(Size)
    self.SizeBox_0:SetWidthOverride(Size)
    self.SizeBox_0:SetHeightOverride(Size)
end
return HomeUserInfo