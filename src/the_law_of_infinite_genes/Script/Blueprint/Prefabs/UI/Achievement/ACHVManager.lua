-- 成就系统界面管理器

ACHVManager = ACHVManager or
{
    -- ===== 运行时变量 =====
    PlayerId = nil;
    MainUI = nil;
    CategoryListUI = nil;
    TitleListUI = nil;
    Preview = nil;
    RightContent = nil;

    -- ===== 静态配置（固定数据） =====
    Config = {
        AnimDur = {
            In = 0.2,
            Out = 0.2
        };
        CategoryNameLabel = {
            "财富称号",
            "充值称号",
            "赛季称号"
        };
        TitleNameLabel = {
            {'囊中羞涩', '略有盈余', '小富即安', '盆满钵满', '腰缠万贯', '富甲一方', '富可敌国'},
            {'首当其充', '千金一掷', '财大气粗', '不差钱', '马上有钱', '钱能通神'},
            {'尸墟巡猎者', '腐潮肃清者', '无殇镇疫使', '荒城孤伐者', '疫首诛灭者', '万尸归墟尊'}
        };
        IconPath = {
            '/the_law_of_infinite_genes/Asset/Texture/Titles/WealthTitle_%d.WealthTitle_%d',
            '/the_law_of_infinite_genes/Asset/Texture/Titles/TopUpTitle_%d.TopUpTitle_%d',
            '/the_law_of_infinite_genes/Asset/Texture/Titles/SeasonTitle_%d.SeasonTitle_%d'
        };
        UnlockConditions = {
            {'达到金币10000', '达到金币100000', '达到金币500000', '达到金币1000000', '达到金币5000000', '达到金币10000000', '达到金币100000000'},
            {'首次充值', '累积充值689起源币', '累积充值1888起源币', '累积充值5888起源币', '累积充值8888起源币', '累积充值16888起源币'},
            {'赛季等级达到10级，累计击杀普通僵尸 500 只', '赛季等级达到20级，累计击杀精英怪 150 只', '赛季等级达到30级，单局内击杀100普通僵尸，且全程生命值从未低于50%', '赛季等级达到40级，单局内击杀30只精英怪，且全程生命值从未低于50%', '赛季等级达到50级 ，累积击杀50次boss', '赛季等级达到100级，无伤击败boss一次'}
        };
        CollectEffects = {
            {'金币结算加成1%', '金币结算加成3%', '金币结算加成5%', '金币结算加成7%', '金币结算加成9%', '金币结算加成11%', '金币结算加成13%'},
            {'金币结算加成8%', '金币结算加成10%', '金币结算加成12%', '金币结算加成14%', '金币结算加成16%', '金币结算加成18%'},
            {'', '', '', '', '', ''}
        };
        WearEffects = {
            {'金币结算加成2%', '金币结算加成5%', '金币结算加成8%', '金币结算加成10%', '金币结算加成12%', '金币结算加成14%', '金币结算加成17%'},
            {'金币结算加成12%', '金币结算加成14%', '金币结算加成16%', '金币结算加成18%', '金币结算加成20%', '金币结算加成25%'},
            {'对普通僵尸伤害 +5%', '对精英僵尸伤害 +5%', '对普通僵尸伤害 +8%，受到普通僵尸伤害 -3%', '对精英僵尸伤害 +8%，受到精英僵尸伤害 -3%', '全伤+10%，伤害-5%，暴击率+3%', '全伤+15%，伤害-10%，暴击率+5%，第一次死亡时候无敌3秒，并且回复30%血量'}
        };
    };
}

function ACHVManager:RegisterComponentClass(CompClass)

    if CompClass ~= nil then
        self.ComponentClass = CompClass;
    end
end

function ACHVManager:RegisterMainUI(MainUI)
    
    if self.MainUI == nil then
        self.MainUI = MainUI;
    end
end

function ACHVManager:UnregisterMainUI()
    self.MainUI = nil;
end

function ACHVManager:OpenMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Open();
end

function ACHVManager:CloseMainUI()
    if self.MainUI == nil then
        return;
    end
    self.MainUI:Close();
end

return ACHVManager