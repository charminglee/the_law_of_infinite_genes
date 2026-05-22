---@class playerItem_C:UAEUserWidget
---@field Avatar Common_Avatar_BP_C
---@field HeadImage UImage
---@field Image_1 UImage
---@field Image_2 UImage
---@field ProfileFrameImage UImage
---@field SizeBox_0 USizeBox
---@field SizeBox_2 USizeBox
---@field TextBlock_209 UTextBlock
---@field TextBlock_210 UTextBlock
---@field TextBlock_211 UTextBlock
---@field HeadImagePath FString
---@field HeadImageType TEnumAsByte<GetHeadImageTypeEnum>
---@field ProfileFrameAssetPath FString
--Edit Below--
---@class playerItem:UUAEUserWidget
local playerItem = {
    PlayerKey = nil,
    Character = nil,
    Size = 100,
}
function playerItem:Construct()
	self:LuaInit();
    print("playerItem:Construct")
    self:ShowUI(nil)
end


function playerItem:ShowUI(InCharacter)
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
function playerItem:GetPlayerKeyByCharacter(Character)
    local PC = Character:GetPlayerControllerSafety()
    if PC~=nil then
        self.PlayerKey = PC.PlayerKey
    end
end
function playerItem:SetHeadImageByPlayerKey(PlayerKey)
    print("playerItem:SetHeadImageByPlayerKey")
    local PS = UGCGameSystem.GetPlayerStateByPlayerKey(PlayerKey):GetTeamMatePlayerStateFromPlayerKey(PlayerKey)
    local UID = PS:GetInt64UID()
    local IconURL = PS.IconURL
    self.Avatar:InitView(1, UID, IconURL)
end
function playerItem:ResetHeadImagePath(NewPath)
    self.HeadImagePath = NewPath
end
function playerItem:ResetProfileFrameAssetPath(NewPath)
    self.ProfileFrameAssetPath = NewPath
end
--Type=0为PlayerUD,Type=1为Asset路径
function playerItem:ResetHeadImageType(Type)
    self.HeadImageType = Type
end
function playerItem:SetHeadImageByAssetPath()
    FuncUtil.SetImageWithPathAsync(self.HeadImage, self.HeadImagePath)
end
function playerItem:SetProfileFrameByAssetPath()
    FuncUtil.SetImageWithPathAsync(self.ProfileFrameImage, self.ProfileFrameAssetPath)
end
function playerItem:SetWidthAndHeight(Size)
    self.SizeBox_0:SetWidthOverride(Size)
    self.SizeBox_0:SetHeightOverride(Size)
end
-- [Editor Generated Lua] function define Begin:
function playerItem:LuaInit()
	if self.bInitDoOnce then
		return;
	end
	self.bInitDoOnce = true;
	-- [Editor Generated Lua] BindingProperty Begin:
	self.TextBlock_210:BindingProperty("Text", self.TextBlock_210_Text, self);
	self.TextBlock_211:BindingProperty("Text", self.TextBlock_211_Text, self);
	-- [Editor Generated Lua] BindingProperty End;
	
	-- [Editor Generated Lua] BindingEvent Begin:
	-- [Editor Generated Lua] BindingEvent End;
end

function playerItem:TextBlock_210_Text(ReturnValue)
	return "";
end

function playerItem:TextBlock_211_Text(ReturnValue)
	return "";
end

-- [Editor Generated Lua] function define End;

return playerItem