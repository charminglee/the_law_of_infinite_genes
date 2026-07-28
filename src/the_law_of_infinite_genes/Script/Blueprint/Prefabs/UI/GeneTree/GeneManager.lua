-- 基因树系统界面管理器

GeneManager = GeneManager or
{
    -- ===== 运行时变量 =====
    PlayerId = nil;
    MainUI = nil;
    Content = nil;
    SkillBranch = nil;
    SkillNode = nil;
    InfoBar = nil;
    Reset = nil;

    -- ===== 静态配置（固定数据） =====
    Config = {
        -- 初始化提示路径
        TipPath = 'Asset/Blueprint/Prefabs/UI/GeneTree/GeneResetTip.GeneResetTip_C',
        -- 动画时长
        AnimDur = {
            Reset = 0.1,
            In = 0.2,
            Out = 0.2,
            Set = 0.5
        };
    }
}

function GeneManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function GeneManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function GeneManager:UnregisterMainUI()
    self.MainUI = nil;
end

function GeneManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Open();
end

function GeneManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Close();
end

return GeneManager