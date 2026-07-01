-- 基因树系统界面管理器

GeneManager = GeneManager or
{
    -- ===== 运行时变量 =====
    PlayerId = nil;
    MainUI = nil;

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